
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
  const firebaseConfig = {
       apiKey: 'AIzaSyAjMmd73Y3Io7zH1p3YUKgk8kkxcJTHJFk',
       appId: '1:736900960385:web:eaa1a173db6735ba73fd80',
       messagingSenderId: '736900960385',
       projectId: 'flutter-iconics',
       authDomain: 'flutter-iconics.firebaseapp.com',
       databaseURL: 'https://flutter-iconics-default-rtdb.asia-southeast1.firebasedatabase.app',
       storageBucket: 'flutter-iconics.appspot.com',
       measurementId: 'G-D441N39ZX7',
 };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });