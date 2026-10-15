
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const { initializeApp } = require("firebase-admin/app");
const {
  getFirestore,
  FieldValue,
} = require("firebase-admin/firestore");

setGlobalOptions({ maxInstances: 10 });
initializeApp();

const db = getFirestore();

exports.joinQueue = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Please log in before joining a queue."
    );
  }

  const uid = request.auth.uid;
  const queueType = request.data?.queueType;
  const serviceName = request.data?.serviceName;

  if (
    typeof queueType !== "string" ||
    !["Hospital", "Bank", "Service Centre"].includes(queueType) ||
    typeof serviceName !== "string" ||
    serviceName.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "A valid queue type and service name are required."
    );
  }

  const cleanServiceName = serviceName.trim();
  const counterId = `${queueType}_${cleanServiceName}`
    .replaceAll("/", "_")
    .replaceAll(" ", "_");

  const counterRef = db.collection("queue_counters").doc(counterId);
  const entryRef = db.collection("queue_entries").doc();

  try {
    const result = await db.runTransaction(async (transaction) => {
      // Confirm the selected service exists and is active.
      const matchingServices = await transaction.get(
        db.collection("services")
          .where("name", "==", cleanServiceName)
          .where("active", "==", true)
          .limit(20)
      );

      const validService = matchingServices.docs.some(
        (doc) => doc.data().category === (
          queueType === "Hospital"
            ? "Hospital"
            : queueType === "Bank"
              ? "Bank"
              : "General"
        )
      );

      if (!validService) {
        throw new HttpsError(
          "failed-precondition",
          "This service is not active or does not belong to this queue."
        );
      }

      const counterSnapshot = await transaction.get(counterRef);
      const currentValue = counterSnapshot.data()?.lastToken;
      const lastToken = typeof currentValue === "number" ? currentValue : 0;
      const nextValue = lastToken + 1;

      transaction.set(counterRef, {
        queueType,
        serviceName: cleanServiceName,
        lastToken: nextValue,
        updatedAt: FieldValue.serverTimestamp(),
      }, { merge: true });

      transaction.set(entryRef, {
        userId: uid,
        queueType,
        serviceName: cleanServiceName,
        counterId,
        tokenNumber: `A-${nextValue}`,
        tokenValue: nextValue,
        status: "waiting",
        joinedAt: FieldValue.serverTimestamp(),
      });

      return {
        queueEntryId: entryRef.id,
        tokenNumber: `A-${nextValue}`,
        tokenValue: nextValue,
        counterId,
      };
    });

    return result;
  } catch (error) {
    if (error instanceof HttpsError) throw error;

    console.error("joinQueue failed:", error);
    throw new HttpsError(
      "internal",
      "Could not join the queue. Please try again."
    );
  }
});
