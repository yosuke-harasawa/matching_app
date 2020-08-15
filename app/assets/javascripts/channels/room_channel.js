/* global messageContainer */
/* global scrollToBottom */
/* global messageContent */
/* global showAdditionally */
/* global $ */

document.addEventListener('turbolinks:request-start', () => {
  if(App.room) {
    App.room.unsubscribe();
  }
});
// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
document.addEventListener('turbolinks:load', () => {

  // js.erb 内で使用できるように変数を定義しておく
  window.messageContainer = document.getElementById('message-container');

  // 以下のプログラムが他のページで動作しないようにしておく
  if (messageContainer === null) {
      return;
  }
  
  if(/rooms/.test(window.location.pathname)) {
    const path = window.location.pathname.split('/');
    const chatRoomId = path[path.length - 1];
    // if(!App.room) {
      App.room = App.cable.subscriptions.create({ channel: "RoomChannel", chat_room_id: chatRoomId }, {
        connected: function() {
        },
        
        disconnected: function() {
          
        },
        
        received: function(data) {
          messageContainer.insertAdjacentHTML('beforeend', data['message']);
        }
      });
    // }
    
    const documentElement = document.documentElement;
    // js.erb 内でも使用できるように変数を決定
    window.messageContent = document.getElementById('message_content');
    // 一番下まで移動する関数。js.erb 内でも使用できるように変数を決定
    window.scrollToBottom = () => {
        window.scroll(0, documentElement.scrollHeight);
    };
  
    // 最初にページ一番下へ移動させる
    scrollToBottom();
    
    const messageButton = document.getElementById('message-button');
  
    // 空欄でなければボタンを有効化，空欄なら無効化する関数
    const button_activation = () => {
        if (messageContent.value === '') {
            messageButton.classList.add('disabled');
        } else {
            messageButton.classList.remove('disabled');
        }
    };
  
    // フォームに入力した際の動作
    messageContent.addEventListener('input', () => {
      button_activation();
      changeLineCheck();
    });
  
    // 送信ボタンが押された時にボタンを無効化
    messageButton.addEventListener('click', () => {
      messageButton.classList.add('disabled');
      changeLineCount(1);
    });
    
    // フォームの最大行数を決定
    const maxLineCount = 10;
  
    // 入力メッセージの行数を調べる関数
    const getLineCount = () => {
      return (messageContent.value + '\n').match(/\r?\n/g).length;
    };

    let lineCount = getLineCount();
    let newLineCount;
  
    const changeLineCheck = () => {
      // 現在の入力行数を取得（ただし，最大の行数は maxLineCount とする）
      newLineCount = Math.min(getLineCount(), maxLineCount);
      // 以前の入力行数と異なる場合は変更する
      if (lineCount !== newLineCount) {
        changeLineCount(newLineCount);
      }
    };
  
    const changeLineCount = (newLineCount) => {
      // フォームの行数を変更
      messageContent.rows = lineCount = newLineCount;
    };
    
    let oldestMessageId;
    // メッセージの追加読み込みの可否を決定する変数
    window.showAdditionally = true;

    window.addEventListener('scroll', () => {
      if (documentElement.scrollTop === 0 && showAdditionally) {
        showAdditionally = false;
        // 表示済みのメッセージの内，最も古いidを取得
        oldestMessageId = document.getElementsByClassName('message')[0].id.replace(/[^0-9]/g, '');
        // Ajax を利用してメッセージの追加読み込みリクエストを送る。最も古いメッセージidも送信しておく。
        $.ajax({
          type: 'GET',
          url: '/show_additionally',
          cache: false,
          data: { chat_room_id: chatRoomId, oldest_message_id: oldestMessageId, remote: true }
        });
      }
    }, {passive: true});
  }  
});

