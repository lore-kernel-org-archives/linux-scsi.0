Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323278;
	b=Dj3IImwLAX+qyJUn+bwLNh/Oz5wagY4JmGezNoEwBshF2NEfj3UfrLaqZv3jdemIwuCC
	 m/DmnOoGdXuZlGsF9qtW8ei9UDqqshg3eG2Xmr+FbQ2lEIedWTHzm24NnO/Hxez6y8lPf
	 U2sqBs4c0C1fyWhSIjXE4Us4wdQLCbNPGXB7f1fU5FzsKgRuIxlK3cerB+kt5sO2M2nFk
	 NNEHwohQgkSJy89N9eERoBQir6kID5JOQ2tSon8Yy9/VaZcJ8DrEQ/AHPpOq9+ECbnCbE
	 0yDOp6ZVZbmbU2LnW4zOJ1ZUqxqWcC1TRc/Wo/zOb6n3CDbIReIXgy3JT9SI97jrVRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323278;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
	b=aHD0VCCghb96ooarxQkytmHQI8PK4KRFF2C33bNPn9nkmanNxndiSCAzlF6i3If16aRQ
	 ouSc79MthWi7jYVlLKyLI1SSXZpnNHFEX6Qw/4hHe6HUZVpdYSnucXnC3uwplS2MSmJfm
	 omApx96fEQoT73iXIdQyn5gE2kk+1+N1SontjzuFS065TWSoxddmobTEv5m2G4gh8iu+6
	 SqMHSp6RXI0GaCNYyAEWeofdyNGuvFxhgex0DNd3tikAUV8kYnjaiOVKSLh5dE2g5BSZr
	 SkYQewFkgFO3nl01QYP3bfZ4mbYbKPfYUpb/M3LehEc0s1vCoWZSzbowO02hGaHTutg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHozpx7Z;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A97E60A2629
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 15:07:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A97E60A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHozpx7Z
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2eb0f1b592bso8100475ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 07:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323277; x=1794928077; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=LHozpx7ZkQyIUBsAkv4C311vzxfheFN2pzrL9Y/FTHkEXQzaVUkMAz9U9wFUejAOr8
         YATASi40x9WcOvyF4dkS6SJQ2bBJHO0yE68WsOT8oewufPXMhMYT6O7d4/5H33a+EMHR
         jjCu1KqktdAA/9c8ZIpbjFjA/3BLyNbgEZc3fS3F9+PTZ5y3jCgkJQ9rhGft5ONP+cJO
         aTEF5vn9sQP8UWqDXO8UszNcV0yZFTKvtrsUk25y1Sz/3h5njQt9uj1PBQLO+FuWPgpB
         LsGoLTWDE/iFYFuKD+GJLya2PXFipxPXM8zYDthkWkjgd0549O004Xgoom3qc/ylK84T
         vykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323277; x=1794928077;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=aNlgOBrsIqCUjfmBj+hi/bgeWzXU/orq7zbZxpkTiK0jJocy8sYMfprWXKKmCqQHkV
         MuzAZbdSrZ5764mI5FcFqXomKvMVL1Sh6FiQszzseXHbUxeVFVS98JeWbPfJ75jRYyQY
         Aix8QQzXXCOGaT48FzGBpBi/XbkMJXLcFgRCSVpaqVpmhL45e2gsxonFFgkPJIP3z3no
         IBpZavsbSEnlE7ZbMzlkLjibXRJYk57NgS6PAAv9BcQrudsPbEbCuqGFgaUgDo+bxcsK
         I+jBMV6Y16vhsGOUXhnxLTfvPNgjOGzucbARQkQ66D8JpE/uubJ0c3blj1En4xg0QZx1
         LWXg==
X-Forwarded-Encrypted: i=1; AL+hErEz13ly8gWa/+vppRgKipT8TDUOMfnP+oErQdfZEQN9nbZyUmksPbV4jrB+77stXaI/+E8KQg2E1Gy9@vger.kernel.org
X-Gm-Message-State: APuU4Z8O7CYHcn4BNk6/dr64RdOTP5NhhgkQR9YYrlzojpEhf35Vwa6L
	LEKIgDB3QPvjb5fH56FOJp7ycNGDmmwKukO0IgiHmW7BhKMDbfggHvRl
X-Gm-Gg: AYBFou2GtLmV6lMv//FXFmgORFtXbIHY4U5ahi1KR9rs00HmXRemlhgjVOZzRTvNGQm
	+eg5c1znDb8taReUPc9gTij/Qu9ofLs3hTXTR4VNUdQJjwGfAyXNhoUS424c+tSEnky1ke+0jJY
	pvA0pxtgnNtFlrsUuu1LKsOsVP8Jkod0X2NmDglOQJaFsI3LZsaVk+9ROvUa6QH4OIYJW+BToKN
	lNLtKqpoXVvXPCTq+zgYb6d7/j9aFekIdrrFSFCvkUBDeo8pWeuekoViRuOPfc1cNmySTIpQOrk
	4cehd2NLj9DKTK15KeOrE11uKnYXOaLCTsHJNXEqS++WdB1mPGw0LavY4jhEv8PoCbMO+U9aslm
	spKu6vDO9DXfMv8VcoehC8ZwqtpyepuaCjUXFB0mFPH/4mFBYOUVYVU7rU3HYEq/eEZ6APIz7a1
	X/3NTpf3vLxWnvg1poGZYnqWcwlO5lqX6guRwNaSEOek5rg2uB03wzIhwngI+iHdb6W098Vifwb
	ceoubmT7smV0MxgwuZmKtiM4CdxrIyKe4y7slsFBSLzLkRnHNhNH4hecwdZr1RVBrW3j1d3qb2w
	okL2CgL+yItdx8gD9bWR60hD3gfKoB8YJJRuTSEPru1jPqpG4qg7ugX3eePeUhh8TXZ5Nv5OSLT
	jeCpWBsLj/Y0=
X-Received: by 2002:a17:902:d481:b0:2ed:1ef3:9ec with SMTP id d9443c01a7336-2edb9172a2dmr26826345ad.14.1794323276968;
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Received: from [192.168.2.6] ([27.75.101.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d78dbcsm10397575ad.27.2026.11.10.07.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Message-ID: <71f76e5e-ce24-4a71-863a-169ad262c510@gmail.com>
Date: Tue, 10 Nov 2026 22:07:46 +0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 36/41] nvmet: refuse files on pseudo filesystems as
 namespace backing files
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Language: en-US
From: Bui Nguyen Nhu Quynh <kaylovefoss@gmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/2026 4:14 PM, Christian Brauner wrote:
> The file backend takes any path that isn't a block device. With
> buffered_io=1 that includes files on procfs or sysfs which then get read
> and written by a kernel worker on behalf of the host. Refuse files on
> pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  drivers/nvme/target/io-cmd-file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index dfa8aa46188c..71c69bac5394 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -52,6 +52,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		goto err;
>  	}
>  
> +	if (file_is_pseudo(ns->file)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>  	nvmet_file_ns_revalidate(ns);
>  
>  	/*
> 

I noticed patch 41/41 doesn't include a test for nvmet. Would it make
sense to add one with buffered_io=1? The test would need a pseudo file
that can be opened with O_RDWR and supports both read_iter and
write_iter. Otherwise, it could pass without ever reaching the new
file_is_pseudo() check.

Thanks.
