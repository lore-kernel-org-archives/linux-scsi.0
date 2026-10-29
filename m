Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793271188;
	b=aY+JNQ0hxWeGoCPNmwThpSH01WeyvN0Rft3vbHkdAAZKFr/jedQNDTSB5E4cBjM4yhHs
	 d+N0u/1SeK5nCDmy31dYOEOTVNpJSf5vsEPFfnqYtZGlCyOKU2vFtboTSRBubgVJ3hYXN
	 Mbb1HkQc28oZ7uNEZZpQ6Gg4MbHkonQrwH/UYMD4WMkqTDEbc6XqSWc3zlzUj0NFsNw3G
	 BVdRlKNS46WdYUGeKzi0x/UC2wK9ZISuNzqCaCqE3/6wPO1ZXfk0hDmHJJjD1e4HE17If
	 TPmPPhhyeoyic/Ia2Kn2iYokV4NeesmMvQMG9nPtKDZFSW7LInsla/cNo7foTyH5NwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793271188;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=z0T3u86hkedH3eaRgGYwzQ+GOmGeNII7gwe8E9j9n9o=;
	b=YbY1DjpqRJY6Ag8V7T+0Up+6Sudepy037XLRT4Sq8yJhu2egLvxzBr2T71JfuqWJHTZ7
	 Ld9WhHo34wdqcUqfsMGkjV9Sg/2PGhd4uOLxo/fIQlODdGBhTWAKv17z1dFuSQWckM21g
	 Qji+YzHbKcOJsZFxIuhkTc225/RCSNdYonlxmSiDJpeBkGEhJimfMq5YlMwFcjM1M9ZVx
	 4krpnMSnDIlXbr+pVdXHLM4EUZXHoMbiwySka8DOzRod4kivA3aII+GZe3imdY8+YxP7c
	 Zxkd5JFV8/RM9zcWtHCL/fSzo4rG30+ZbjwnCGwSd/0b3WT0rxLfHOZiCNqZLe/8+hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gEWQuLGs;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FAF606A325
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 10:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2FAF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gEWQuLGs
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48df4f540ebso970255f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 03:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793271186; x=1793875986; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z0T3u86hkedH3eaRgGYwzQ+GOmGeNII7gwe8E9j9n9o=;
        b=gEWQuLGsb2TWmX0i/zb98QqXRohpXAUBYFR15k51NTn882zLijJLOBqff8ZfnuUmyt
         6RfN7+niFBOK+6GRKUBK/NQT/i9XIRCKwnU8hfjqfyQQ/MiFetoiPQYssIAQt9sF1tFd
         LX02L9zCnUP+FnGYH3oCTfUMCTASFM4uXCwKSbuqeAfeA8yt1jJPqyGLcozcFXrk82hf
         86jjryjNii4aQuls1B80pjo+fV1Z7k9ENiktohfS+inmtjbGv7lUxX/5v6jVKBjFGycZ
         fQL24LEvjAxaLKAy1GJ4d3OKLkXUfZXmrKaPpK9M0BqiMPdIyyTI2mqFlnHk+arUVi6n
         1i6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793271186; x=1793875986;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z0T3u86hkedH3eaRgGYwzQ+GOmGeNII7gwe8E9j9n9o=;
        b=G/4trszIvT9FtJEh0SGTkxGMbFkpxtRPEJSpkNz4X9ssxSEYUY+y9VcqYnmIk8l4zz
         Sz1NIMHwJoS3fnl0Qiwa3QnyucvYyIiUMCSoBez5lpxP7RAEPc93z+i+L2swtmQpcdZK
         uF1tJnCK/hmGzX9a5qhGpFS7UFh9J8ZDOUycuA5JfVkzoRuX5Wd4Dh8P9JxlKhKz5oBL
         XTYi03VSofrRfi2lIZkAoVn20raQ32NR1UkJnsamro6ago5Hi6DOLknQqGe+2tiam0vo
         s9LBso1raLTc85SRYbaaBU7x9nmYyQ4aKL+NXa0iJ4NRLZQ2/BE7H0K51toVpxjv67M1
         6TOw==
X-Forwarded-Encrypted: i=1; AKwUvBwPK4R8m+vXKXP22Bdw5+f9cdaN6d90SpnfjBIINbLeaSMS+HyXZgpPc2hljxpcPKPsnwGE/kVe7iZ+@vger.kernel.org
X-Gm-Message-State: AFq9FYIAYxw1uwLn4WwFCxUARE7Nvy0sV1u3oOcOJ7yzq3EioDcD982m
	fHR5qVQkJ7+D6+VbJkqAXsxLZmTfZJ+GCSnLsq9DfXhtPbqxHGorIUob
X-Gm-Gg: AYBFou3hpMWWm7j89q776AkSdu/IHGylvOeVtdmX5jrUL9pDlIIdVxUqEzFMTBBnin4
	BbUYAAgdGUhEfQl5FkIl2roaEmxNIGEhmgIAK7A1IIAc41n4r18OJRhVDsFTdXE0dUm3cq8KYkn
	oZklILyOUfFnFHs3nK0hp6uppJzZfFSUoMMtvhcSqr1rVt0a4TFAiFG9T2yRmTzySWcdqEXwxir
	bcWbpGTUVn6HAk+bDW1fTW7qYKLZChDuQ6VY9KVK/JzstFIC6puI0TfWz9ZAR46sHgsV5tyRHCc
	jv/OYpUA57YseWH1Im9pEW0wNBxe7hSiRc4LDdKGKrvhpj1KWpKE5a1xZaRJ9a7KwGipsqDuzph
	wCE01qJrmRLz05n5Emx1fNMuKXiOrKGJvxKJmqMPZ3iPKTxJqhmdP0xB6B0L8rNAG62pcRAT5SE
	qsLNteh2fPsQuSuQyEBRBwogxskpjwrmn8JusjQ5ohIOgMwoWlfoiPHOtiHSYGhsgFrliTTZL2v
	rDwkt77joMB51U3EoHguvEpwlTdLpp149s1mjSk9wgpKlPuIvzJc6aHp1SQm//XPCvXlcz49ynS
	qTV+nrw0r+Gc3EURGOcLGhQyEMYq2V7gaOQFpl1Cv6HPWY8YWTEEFqkirtONmeuXWD2KNb/xS/J
	QvgW9isM1CNqN49OaXL+qlffum909uJM0zqYqtbJcD1dDb+sQ4WVJY+PuhBThD9Fl9SH37aWih4
	zFT1AfE/2K12ZXb45BW/Qe57U=
X-Received: by 2002:a5d:5f52:0:b0:48c:69bd:e971 with SMTP id ffacd0b85a97d-48e5d2e6d40mr12705105f8f.16.1793271186318;
        Thu, 29 Oct 2026 03:53:06 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm31889960f8f.7.2026.10.29.03.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 03:53:05 -0700 (PDT)
Message-ID: <7fb73a55-c7f8-45bd-b12d-e46f1efcbe67@gmail.com>
Date: Thu, 29 Oct 2026 10:53:07 +0000
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
Subject: Re: [PATCH v2 5/5] nvme: support dma-buf registered buffers for
 passthrough
To: Anuj Gupta <anuj1072538@gmail.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org, bernd@bsbernd.com, joannelkoong@gmail.com, miklos@szeredi.hu
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 fuse-devel@lists.linux.dev, joshi.k@samsung.com, anuj20.g@samsung.com
References: <20261022144501.2478417-1-anuj1072538@gmail.com>
 <20261022144501.2478417-6-anuj1072538@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261022144501.2478417-6-anuj1072538@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 15:44, Anuj Gupta wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Allow registering a dma-buf against an NVMe namespace character device
> and using it as the data buffer of fixed uring_cmd passthrough I/O.
> Complete through io_uring_cmd_hw_done(), so the dma-buf map is released
> at hardware completion.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>   drivers/nvme/host/core.c  | 16 ++++++++++++++++
>   drivers/nvme/host/ioctl.c |  5 +++--
>   2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index d81462e864a4..6157ff839929 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -8,6 +8,7 @@
>   #include <linux/blkdev.h>
>   #include <linux/blk-mq.h>
>   #include <linux/blk-integrity.h>
> +#include <linux/dma-buf-io.h>
>   #include <linux/compat.h>
>   #include <linux/delay.h>
>   #include <linux/errno.h>
> @@ -3982,6 +3983,20 @@ static int nvme_ns_chr_release(struct inode *inode, struct file *file)
>   	return 0;
>   }
>   
> +static int nvme_ns_chr_init_dma_buf_io_ctx(struct file *file,
> +					   struct dma_buf_io_ctx *ctx)
> +{
> +	struct nvme_ns *ns =
> +		container_of(file_inode(file)->i_cdev, struct nvme_ns, cdev);
> +	struct nvme_ctrl *ctrl = ns->ctrl;
> +
> +	if (ctx->dmabuf->size > UINT_MAX)
> +		return -EINVAL;
> +	if (!ctrl->ops->init_dma_buf_io_ctx)
> +		return -EINVAL;

Let's return -EOPNOTSUPP for consistency, with that

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

