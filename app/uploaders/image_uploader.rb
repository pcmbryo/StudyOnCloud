class ImageUploader < CarrierWave::Uploader::Base  

  # リサイズしたり画像形式を変更するのに必要
   include CarrierWave::RMagick
 
  # 画像の上限を100pxにする
    process :resize_to_limit => [100, 100]
 
   # 保存形式をJPGにする
   process :convert => 'jpg'
 
   # サムネイルを生成する設定
    version :thumb do
      process :resize_to_fill => [40, 40, gravity = ::Magick::CenterGravity]
    end
 
   # jpg,jpeg,gif,pngしか受け付けない
   def extension_white_list
     %w(jpg jpeg gif png)
   end
 
  # 拡張子が同じでないとGIFをJPGとかにコンバートできないので、ファイル名を変更
   def filename
     $user_image_id + '.jpg' if original_filename.present?
   end

  # デフォルトのアイコン画像を設定
   def default_url(*args)
    "default.png"
   end
 end