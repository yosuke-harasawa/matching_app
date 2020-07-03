class RoomsController < ApplicationController
  def create
    # 自分の持っているチャットルームを取得
    current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).map(&:chat_room)
    # 自分の持っているチャットルームからチャット相手のいるルームを探す
    chat_room = ChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: params[:user_id]).map(&:chat_room).first
    # なければ作成する
    if chat_room.blank?
      # chat_roomsテーブルにレコードを作成
      chat_room = ChatRoom.create
      ChatRoomUser.create(chat_room: chat_room, user_id: current_user.id)
      ChatRoomUser.create(chat_room: chat_room, user_id: params[:user_id])
    end
    # チャットルームへ遷移させる
    redirect_to action: :show, id: chat_room.id
  end

  def show
    # チャット相手の情報を取得する
    chat_room = ChatRoom.find_by(id: params[:id])
    @chat_room_user = chat_room.chat_room_users.
      where.not(user_id: current_user.id).first.user
    @messages = Message.includes(:user).where(chat_room: chat_room).order(:created_at).last(100)
    # メッセージ投稿に利用
    @message = current_user.messages.build
  end
  
  def show_additionally
    chat_room = ChatRoom.find_by(id: params[:chat_room_id])
    last_id = params[:oldest_message_id].to_i - 1
    @messages = Message.includes(:user).where(chat_room: chat_room).order(:created_at).where(id: 1..last_id).last(50)
  end  
  
  # def show
  #   # 投稿一覧表示に利用
  #   @messages = Message.includes(:user).order(:id)
  # end
end
