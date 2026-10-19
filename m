Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445647;
	b=Lx/tstiOdrb9rt3xnTgaKg7Bl7tMxYZSA8jnvQjZEWYB+GPkYfwE/QCQnGi9jNFwThRd
	 IL9SH2/2YItDfLmGgkZ0kHQQZXKr9ZfDApEPKx7cVvpu8A8RE9weG0RkYASOO14DGN9lI
	 7rLt0mtqrwIAHetygOzT4JOvYfxpajGH5eH33GcQYmlTDJySzMMPoD2SPISxOcN5RKvnJ
	 H5Bkfbg0gjfm5FIGaSzwtoQKdVsgli7OCz3YcKEbewkzFqgz2lamxHoh8SwMtWgKX0y87
	 EJtmC4qnoCRMd4CmsBgt4PO8pQnMxR8rEsxEDNZey4+AqEeRjORpeWKOH6Pa2RCLXVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445647;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=5E7RzlaDuAw9uKwHLzxHAh7RmcEba2LCM1IqL7WsLws=;
	b=I7QY+TKOknwrLHR3QxCxEJ+fK1lHcgA+laD+mdnt2WotgXQIcBDKM7wrpOhbUFe7dzZm
	 JHgrwuSYfva0IcOBEHQbMTAGDWN9pvYHqsZUA+eHlXxdCUKGD/h4L4JktuIIL/mRhAF3m
	 oeCDCrTTL/+JdLpnX/sUZVMymtyver2iBowTyK0+z5KBAtfg1vKMAP67DlY76cT6rFYM7
	 ciDFxOSp1YREIfbCK8Ix0qGLCMJTtG+Xcx5Wp1/fn2ZSatmOX6lT/ErV9att7dbpCKMur
	 Z13T1/PfScEUwUFdIiSls+6ggibFsiHKn8U/ilH3vk8SBvvMU0lJcy3cESW9UEX1EjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Tcg4MwfJ;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC33606A31B;
	Mon, 19 Oct 2026 21:34:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DC33606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Tcg4MwfJ
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j7phY5w9JzlfvpT;
	Mon, 19 Oct 2026 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792445642; x=1795037643; bh=5E7RzlaDuAw9uKwHLzxHAh7R
	mcEba2LCM1IqL7WsLws=; b=Tcg4MwfJy/ak4sxLYRZ5vRAqHeAj9OBvWsFW9CKe
	GhmAVJQ2XXY+4coq+xzTHvy2+2yZibSPxDQSxZ8/xILkiNcTk2jy1rfvWYMlXgT5
	x7NfEXivich2yBQEamk6hgcAEiGlp1jmQm5y5s9Vwn/Wa25oBA2AtAD3ke+GOnQE
	hLANc17PkU/Ikg9tMV6VPbw9Twut6WefASfjFw3qqoOGbGEfxHwIrGTtAiMUvxKU
	ZsXFhy63xNL5ImYERAyySjmfcZabocyiXXTDCWXf4vNm9otw3yVS28cxt298QXvh
	LTKrwQY52v+DrAzJN/q4xZ8jroPkXxBL9psf4SxwSeFZPQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jc0h5tQdPjhN; Mon, 19 Oct 2026 21:34:02 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j7phT003mzlfvpH;
	Mon, 19 Oct 2026 21:34:00 +0000 (UTC)
Message-ID: <9321a59c-c560-4742-8b71-5b0ec1f30c2f@acm.org>
Date: Mon, 19 Oct 2026 14:34:00 -0700
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
Subject: Re: [PATCH] scsi: reject negative SG_SET_TIMEOUT values
To: Wang Yingjie <x-professor@outlook.com>, "mkp@kernel.org"
 <mkp@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20261017084547.2880694-1-x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261017084547.2880694-1-x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 1:45 AM, Wang Yingjie wrote:
> The block SCSI path predates Git history. The BSG path has exposed the
> same behavior since BSG was introduced.
> 
> Fixes: 3d6392cfbd7d ("bsg: support for full generic block layer SG v3")

As mentioned above this issue is older than when Linus started using git
so I think it would be appropriate to add the following:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

> diff --git a/block/bsg.c b/block/bsg.c
> index 82aaf3cee582..681da79a5ba2 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -132,6 +132,8 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>   	case SG_SET_TIMEOUT:
>   		if (get_user(val, intp))
>   			return -EFAULT;
> +		if (val < 0)
> +			return -EIO;
>   		bd->timeout = clock_t_to_jiffies(val);
>   		return 0;
>   	case SG_GET_TIMEOUT:
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index c14f81403a09..162a21112d49 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -195,10 +195,13 @@ static int sg_set_timeout(struct scsi_device *sdev, int __user *p)
>   {
>   	int timeout, err = get_user(timeout, p);
>   
> -	if (!err)
> -		sdev->sg_timeout = clock_t_to_jiffies(timeout);
> +	if (err)
> +		return err;
> +	if (timeout < 0)
> +		return -EIO;
>   
> -	return err;
> +	sdev->sg_timeout = clock_t_to_jiffies(timeout);
> +	return 0;
>   }

Rejecting negative values with -EIO matches drivers/scsi/sg.c, which
looks good. However, large positive int values still overflow
bd->timeout and sdev->sg_timeout: both fields are 32-bit unsigned int 
while clock_t_to_jiffies() returns unsigned long (clamping only at
ULONG_MAX).

Bart.

