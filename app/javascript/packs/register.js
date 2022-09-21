process.env.AUTHOR_NAME="Theodore";
const appId = process.env.SQUARE_APP_ID;
const locationId = process.env.SQUARE_LOCATION_ID;
console.log(process.env.AUTHOR_NAME);
console.log(process.env.SQUARE_APP_ID)
console.log(appId)
console.log(locationId)
console.log(process.env)

async function initializeCard(payments) {
  //debugger
  console.log("-------------------------------inside initialize method=------------------------------")
  const card = await payments.card();
  await card.attach('#card-container');

  return card;
}

function buildPaymentRequest(payments) {
  debugger
  console.log("-------------------------------buildPaymentRequest=------------------------------")
  
  return payments.paymentRequest({
    countryCode: 'US',
    currencyCode: 'USD',
    total: {
      amount: document.getElementById("price").innerHTML,
      label: 'Total',
    },
  });
}

async function initializeGooglePay(payments) {
  //debugger
  console.log("-------------------------------initializeGooglePay------------------------------")

  const paymentRequest = buildPaymentRequest(payments);
  const googlePay = await payments.googlePay(paymentRequest);
  await googlePay.attach('#google-pay-button');

  return googlePay;
}

// async function createPayment(token) {
//   //debugger
//   console.log("-------------------------------create payment------------------------------")

//   const body = JSON.stringify({
//     locationId,
//     sourceId: token,
//   });

//   const paymentResponse = await fetch('/payment', {
//     method: 'POST',
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body,
//   });

//   if (paymentResponse.ok) {
//     return paymentResponse.json();
//   }

//   const errorBody = await paymentResponse.text();
//   throw new Error(errorBody);
// }

async function tokenize(paymentMethod) {
  //debugger
  console.log("-------------------------------tokenize------------------------------")

  const tokenResult = await paymentMethod.tokenize();
  if (tokenResult.status === 'OK') {
    return tokenResult.token;
  } else {
    let errorMessage = `Tokenization failed with status: ${tokenResult.status}`;
    if (tokenResult.errors) {
      errorMessage += ` and errors: ${JSON.stringify(
        tokenResult.errors
      )}`;
    }

    throw new Error(errorMessage);
  }
}

// status is either SUCCESS or FAILURE;
function displayPaymentResults(status) {
  //debugger
  console.log("-------------------------------------------display payment method------------------------------------------")
  const statusContainer = document.getElementById(
    'payment-status-container'
  );
  if (status === 'SUCCESS') {
    statusContainer.classList.remove('is-failure');
    statusContainer.classList.add('is-success');
  } else {
    statusContainer.classList.remove('is-success');
    statusContainer.classList.add('is-failure');
  }

  statusContainer.style.visibility = 'visible';
}

document.addEventListener('DOMContentLoaded', async function () {
  //debugger
  if (!window.Square) {
    throw new Error('Square.js failed to load properly');
  }

  let payments;
  try {
    console.log("------------------------------")
    console.log(appId)
    console.log(locationId)
    payments = window.Square.payments(appId, locationId);
  } catch {
    const statusContainer = document.getElementById(
      'payment-status-container'
    );
    statusContainer.className = 'missing-credentials';
    statusContainer.style.visibility = 'visible';
    return;
  }

  let card;
  try {
    //debugger
    console.log("------------------------------card initialize-----------------------------")

    card = await initializeCard(payments);
  } catch (e) {
    console.error('Initializing Card failed', e);
    return;
  }

  let googlePay;
  try {
    //debugger
    console.log("-------------------------------GooglePay------------------------------")

    googlePay = await initializeGooglePay(payments);
  } catch (e) {
    console.error('Initializing Google Pay failed', e);
    // There are a number of reason why Google Pay may not be supported
    // (e.g. Browser Support, Device Support, Account). Therefore you should handle
    // initialization failures, while still loading other applicable payment methods.
  }

  async function handlePaymentMethodSubmission(event, paymentMethod) {
    event.preventDefault();
    console.log("-------------------------------handle payment method submmision------------------------------")

    try {
      //debugger
      // disable the submit button as we await tokenization and make a payment request.
      cardButton.disabled = true;
      const token = await tokenize(paymentMethod);
      debugger;
      let verificationToken = await verifyBuyer(
        payments,
        token
      );
      console.log("----------------------------------------------------------------")
      console.log(token)
      console.log("-----------------------------------------------------------------")
      debugger;
      document.getElementById("nounce").value = token+" / "+verificationToken
      debugger;
      //const paymentResults = await createPayment(token);
      //displayPaymentResults('SUCCESS');

      //console.debug('Payment Success', paymentResults);
      document.getElementById('payment-form').submit();
    } catch (e) {
      console.log(e)
      console.log("something went wrong")
    }

    async function verifyBuyer(payments, token) {
      console.log("------------inside-------------")
      alert("testing")
      const verificationDetails = {
        amount: document.getElementById("price").innerHTML,
        /* collected from the buyer */
        billingContact: {
          familyName: "Joe",
          givenName: "doe",
          email: "j@gmail.com",
          phone: "9999999999"
        },
        currencyCode: "USD",
        intent: 'CHARGE',
      };
      console.log("---------------------------------------------inside---------------------------------------------")
      let verificationResults = await payments.verifyBuyer(
        token,
        verificationDetails
      );
      return verificationResults.token;
    }
  }

  const cardButton = document.getElementById('card-button');
  cardButton.addEventListener('click', async function (event) {
    await handlePaymentMethodSubmission(event, card);
  });

  // Checkpoint 2.
  if (googlePay) {
    const googlePayButton = document.getElementById('google-pay-button');
    googlePayButton.addEventListener('click', async function (event) {
      await handlePaymentMethodSubmission(event, googlePay);
    });
  }
});