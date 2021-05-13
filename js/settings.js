/**
 * Update SMS
 */
(function () {
  const updateSMS = document.querySelectorAll('[data-js-sms]');
  updateSMS.forEach((smsUpdate) => {
    smsUpdate.addEventListener('click', (event) => {
      event.target.innerHTML = 'Processing...';
      const phoneNumber = document.getElementById('sms-number').value;
      fetch(`/sms?phone-number=${phoneNumber}`, {
        method: 'POST'
      }).then((response) => {
        if (response.status === 200) {
          return response.text();
        }
        event.target.innerHTML = 'Error!';
        throw new Error(`Could not update phone number: ${phoneNumber}.`);
      }).then((data) => {
        event.target.innerHTML = 'Updated!';
        return data;
      }).catch((error) => {
        console.error(error);
      });
    });
    smsUpdate.removeAttribute('disabled');
  });
})();
