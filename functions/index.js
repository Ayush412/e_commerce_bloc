const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.myNotification = functions.firestore.document('products/{projectId}').onCreate(doc =>{
    const prod = doc.data();
    const payload = {notification :{
        title: `The ${prod.ProdName} Just Arrived!`,
        text: `${prod.images[0]} Grab the ${prod.ProdName} for only QR. ${prod.ProdCost}! \n\nCheck out the products page for more details.`,
        image: `${prod.images[0]}`
    }};
    admin.messaging().sendToTopic('e-commerce', payload);
})

exports.orderTracking = functions.firestore.document('users/{usersId}/{ordersCollectionsID}/{ordersID}').onUpdate((doc, context)=>{
    const userId = context.params.usersId;
    const orderId = context.params.ordersID;
    const info = doc.after.data();
    const payload = {notification :{
        title: `Your order is one step closer to being delivered!`,
        text:  `https://www.gpstracker.at/wp-content/uploads/2019/03/How-GPS-Tracking-Can-Benefit-Delivery-Services.jpg Delivery status of your order no: ${orderId} has been updated. Please check the delivery screen to track it.`,
    }};
    admin.messaging().sendToTopic(`${info.ID}`, payload)
})