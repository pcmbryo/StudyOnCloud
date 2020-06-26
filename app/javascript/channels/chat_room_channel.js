import consumer from "./consumer"

$(function() {
  const chatRoomChannel = consumer.subscriptions.create({channel: "ChatRoomChannel", room: $('#messages').data('room_id') }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) {
      //return alert(data['message']);
      return $('#messages').append(data['message']);
    },

    speak: function(message) {
      return this.perform('speak',{
        message: message
      });
    },
  });

  $(document).on('keypress', '[data-behavior~=room_speaker]', function(event) {
    if (event.keyCode === 13 && event.target.value != ''){
      chatRoomChannel.speak(event.target.value);
      event.target.value = '';
      return event.preventDefault();
    }
  });
});
