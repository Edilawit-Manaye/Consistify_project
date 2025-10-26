// Scripts for firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing the generated config
const firebaseConfig = {
  apiKey: "AIzaSyCrO2cc7corTduvOsGj6Q1Gj_hiiYS3l0M",
  appId: "1:121146493417:web:bc7115c9a0fcd53bb7a378",
  messagingSenderId: "121146493417",
  projectId: "consistify-app",
  authDomain: "consistify-app.firebaseapp.com",
  storageBucket: "consistify-app.firebasestorage.app",
  measurementId: "G-HLP4P96CN6"
};

firebase.initializeApp(firebaseConfig);

// Retrieve firebase messaging
const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('Received background message ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

