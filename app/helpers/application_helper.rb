module ApplicationHelper
	 require 'qiniu'

	MOBILE_USER_AGENTS = "palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|" \
                       "audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|" \
                       "x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|" \
                       'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' \
                       "webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile"
	def mobile?
		agent_str = request.user_agent.to_s.downcase
		agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
	end

	def generate_qiniu_upload_token
	    # bucket = "chenxiyue"
	    bucket = Settings.qiniu.bucket
	    put_policy = Qiniu::Auth::PutPolicy.new(bucket,"aa",3600) #参数是七牛bucket名
	    # put_policy.scope!("chenxiyue",key)
	    callback_body = {
	      fname: '$(fname)',
	      hash: '$(etag)',
	      id:  '$(x:id)'
	    }.to_json
	    # 构建回调策略，这里上传文件到七牛后， 七牛将文件名和文件大小回调给业务服务器.
	    # callback_body = 'filename=$(fname)&filesize=$(fsize)' # 魔法变量的使用请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#magicvar
	    # put_policy.callback_url= upload_callback_users_url
	    put_policy.callback_body= callback_body
	    put_policy.callback_url= image_upload_callback_callbacks_url  #上传成功后回调的URL
	    Qiniu::Auth.generate_uptoken(put_policy)
  	end

  	# 生成七牛的token
  def generate_qiniu_upload_token
    # bucket = "chenxiyue"
    Qiniu.establish_connection! access_key: Settings.qiniu.access_key, secret_key: Settings.qiniu.secret_key
    bucket = Settings.qiniu.bucket
    puts bucket
    puts Settings.qiniu.access_key
    put_policy = Qiniu::Auth::PutPolicy.new(bucket) #参数是七牛bucket名
    # put_policy.scope!("chenxiyue",key)
    callback_body = {
      fname: '$(fname)',
      hash: '$(etag)',
      imgable_id:  '$(x:imgable_id)',
      imgable_type: '$(x:imgable_type)',
      user_id: '$(x:user_id)',
      return_url: '$(x:return_url)'
    }.to_json
    # 构建回调策略，这里上传文件到七牛后， 七牛将文件名和文件大小回调给业务服务器.
    # callback_body = 'filename=$(fname)&filesize=$(fsize)' # 魔法变量的使用请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#magicvar
    # put_policy.callback_url= upload_callback_users_url
    put_policy.callback_body= callback_body
    put_policy.callback_url= image_upload_callback_callbacks_url  #上传成功后回调的URL
    Qiniu::Auth.generate_uptoken(put_policy)
  end

	def qiniu_image_by_hash(hash, opt={})
		url = "http://7xsr0z.com2.z0.glb.clouddn.com/#{hash}"    #为了方便硬编码七牛的域名
		format = opt[:format]
		width = opt[:width]
		height = opt[:height]

		case format
		when "square"
		  url << "?imageView2/1/w/#{width}/h/#{width}/q/90"
		when "preview"
		  url << "?imageView2/2/w/#{width}/h/#{height}/q/90"
		else
		  url
		end
	end

  	# Override the filename of the uploaded files:
	def filename
		@name = Digest::MD5.hexdigest(Time.now.utc.to_i.to_s + '-' + Process.pid.to_s + '-' + ("%04d" % rand(9999)))
		"#{@name}"
	end
end
