Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794658800;
	b=5hkDObcxIxOm3+Jrk1Q4IjV9kWoVLWP7SljFXvLj/8ToKJ0t7oawlqy7VCNoAAnui5nO
	 UHVYSQF2pu3/pPbjGY9Uqjr8N+SrcYDIhVJZcpA61EqNc3tvH/FFYQY1qU76uWiuPu8D4
	 vvMOf2reDRLYmT4aA1J6h9d16oqjVsA6fSW+rBOfPVTzOHavyAoyGAYlMdxIew91d4Iei
	 w6hkM6rSxcQPv9KIpM3FgQjSz3pl9rIf7g6mQlHWW7RvOZotUsbn5ZAL19C921XjohYDF
	 CFLhm8ZWjXKImcKkiECj2DIKBUbpbIVwKfCCM/x6o27sNjcZuQw7MBc1PTJU1sa/ZNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794658800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
	b=fYoXgbx5lOp+gmfGzLeAErKk8rLll77hQ5HoSNe6s284JsFPolcG3ei0PyMvoO6YnELl
	 wURoRDOacAiHM9tOStsmyTvgpTefGYTbTjxtU6rqHKtUSa6vEhRXZ84NTBW+Tzgeeh/KL
	 dhSgREzJ1kStV1tcm5WwHAHtiXjGDVahREqJ9EKtwBdmFZwr+m8ykG5MKOOoBCpOAsmIK
	 ZzqgHk7GLAsnWNh64+kg1p2BTcw3q2etGIj7JFJ3KDASl9zoHpiAgc8EpkX3vSyEL6vTl
	 T8wqEtSvsWMOwnrNl3JtJltRRigklVFRg6WPJCaCNZC4THTD69M/u1ds1a/5qIv2Wgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zvg2B30u;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF6C606A327
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 12:19:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DF6C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zvg2B30u
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b58cb69927so3350410a12.0
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 04:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794658797; x=1795263597; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
        b=Zvg2B30uBzOFFo54OpfHCzqSK6TOyxTRmwNZV7t2nfrBwunaCrRH+5tI09/jIosXZS
         GdYk6iMfyO0nJ3moVzjaSKnXCCWxcV1Ye+R/4YjiwdwGG8ofIv4PWH24MjP/VV4CkNiq
         nSM7j6UNEdEDdNWpjUjn43q9YL/wt1IFltOrsPhL2VYrn8g/yyR7Uz6PFelA0j1tolIT
         QTqiv37OCVMy+5oEwlNBsw2cKiejzgZGAC7AZW2QPAu9cR2dMcfIteYf8vq02JyCIN53
         /PYiFz/vA+fp7KPo0fCiRfu55fCeLd5qLFIcUMGbAUVH1mkivaDzQTprXnn5n1PDT9pn
         6ZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794658797; x=1795263597;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
        b=YB1SRJZybnVS+9gWhuitzRjgbYtMy93f7AZB/bHvwmvAYWeS0qs+cnPYIRwu5V6v4g
         PlEaoNUs/L7tLmIzpnTnL/UyrXiZC5B+KzC7LVksUZJQOYGWL4eF3+e0ycNbImCjls2x
         J4ofdrUwNmUw5vEhvJhrJhiSFA4ww/xPpuDU6TUp1IMKEs/e+R37hnPEGwaz1iPtes3g
         OZ9TuXq21ba+V8qfC+uPSeXGIMqNH1ZUOxLeqruI2k7bOuIVcAc7zX1lNQoewerdFgcY
         r66BF8/L2nUfbmK0WPDB1eoid1SoAKF51IDn7dwXJ/6XL+cpgObCr8UG0Mvc2MhZRBlw
         0/bA==
X-Forwarded-Encrypted: i=1; AL+hErH19aTOxiTZxYvOmtrE27wK62Fmu1H9Wth5PNcVzhr9cu9ZEWQQoFBM44iXKSYm/+DcGzxRIUMho3Vs@vger.kernel.org
X-Gm-Message-State: APuU4Z8Q2nSmANNvf6togy6eDzbJRljm+lL8fv3mFPEdiBWDG2HjdBzz
	L16QmVM6AWBdCYAwRfvYn3cwVTGHbQduszCiCGcEC/BizBK3N5aIIbKw
X-Gm-Gg: AYBFou0evGLFQ0tzTZOYF64nX3N9UDMv0blAaLpOt9l2xtiphIA+jAmxxC458Fhq6Yq
	kXYIqGvdThGXEE8jPMC6CY9Lfe7zNy4VFib70/T73PU3to8KXluXhluJFFYGNQG0pPqSivfE2uI
	LNplfScGcPrTlRUSjeBEtcgDfjWfqMud1uj/yS2wsUjpNDDwOjGBMFKsDZhgPYHpgrgS7yZqQ8o
	FWZ9xpjCG+ftY7sz2ZJD97vBEbaqZ9a0DfELkYc0DutOUZbNhIr7mH3BBiYAFaDYhFxXT9/pfAA
	5siQr3LNPpQCfN9nSf5OLAHoTGvhCFcwyhIjjLP7xBUU4gYhaPKlQs3vP53RYkvobZiO0L9nX5R
	uPbTyEo9u0oMKug1Bne7eu4cDZ9sCO9oSaCjPepD0OieOvCO8fFWFWZaki8/lfu6yMY+wCeNquT
	Ty1SNwtfha/JasiRdXeYFewKPSXTecgGEM41Sd3OYSkEL3D/7h/bTwQYnRvrVdWOC5Qbj0y9XRr
	psEZTX4gCxXUILI4011DXBKXiiqs0uzuAsELDjLUDFeJTsPgW1CIsP7pAicaMpOBtxyFpIYIDj+
	syA64mBj2/+R5e/m6J0EaP8V3qzedGZxPFPun3+qrYjJUGB7ATi+Kytyd4AHrjfqAIcvY1NlEUb
	2auJb6dEIJFg/
X-Received: by 2002:a17:906:1001:10b0:c41:4512:560d with SMTP id a640c23a62f3a-c5096387b02mr309942166b.16.1794658797424;
        Sat, 14 Nov 2026 04:19:57 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b5ac2asm211518966b.55.2026.11.14.04.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 04:19:56 -0800 (PST)
Date: Sat, 14 Nov 2026 13:19:56 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	bpf@vger.kernel.org, linux-nfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 10/12] ovl: take freeze protection when storing the uuid
Message-ID: <avhR7DbNbVDCyPDO@amir-ThinkPad-T480>
References: <20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org>
 <20261114-work-fs-frozen_writes-v1-10-f5ae61c898b1@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114-work-fs-frozen_writes-v1-10-f5ae61c898b1@kernel.org>

On Sat, Nov 14, 2026 at 11:47:17AM +0100, Christian Brauner wrote:
> ovl_init_uuid_xattr() stores the persistent uuid in an xattr on the
> upper root. That happens after ovl_make_workdir() dropped its write
> access to the upper mount and before ovl_get_indexdir() takes it
> again. So a freeze of the upper filesystem that lands in between lets
> the mount modify a frozen filesystem.
> 
> Take write access to the upper mount around the xattr update.
> 
> Fixes: d9544c1b0d9e ("ovl: store persistent uuid/fsid with uuid=on")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

> ---
>  fs/overlayfs/util.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 521717209b2e4..67aa7b71e9c83 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -829,8 +829,12 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
>  
>  	/* Try to store persistent uuid */
>  	set = true;
> -	res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID, uuid.b,
> -			   UUID_SIZE);
> +	res = mnt_want_write(ovl_upper_mnt(ofs));
> +	if (!res) {
> +		res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID,
> +				   uuid.b, UUID_SIZE);
> +		mnt_drop_write(ovl_upper_mnt(ofs));
> +	}
>  	if (res)
>  		goto fail;
>  
> 
> -- 
> 2.53.0
> 

