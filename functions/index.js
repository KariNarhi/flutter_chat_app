import { firestore } from "firebase-functions";
import { initializeApp, messaging } from "firebase-admin";

initializeApp();

export const myFunction = firestore
  .document("chat/{message}")
  .onCreate((snapshot, context) => {
    return messaging().sendToTopic("chat", {
      notification: {
        title: snapshot.data().username,
        body: snapshot.data().text,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });
