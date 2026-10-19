Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792442016;
	b=V7XykbKZJS4QrSTvihdVOFm4DEO62Cjfcsp+FXl8ZntDMhGpTRQFdvC+qT3Bx7YAMOVY
	 Hn1NmEejtd0Ye617k7S9CrtFAjTbcpQSMMpPhEkQgcuHw1V78wgW4RHQs/HPfEAYpFDud
	 QnqPX08/qc1PN/SGNsbpZ3S2lCCPNvQs6S269D+ApH4lXJpHCKGlkX0V/z0Xde2HLJrYa
	 UcSs4AnFw+Xh0q7sSrYAxMlSpgy/aQwQU+3mR3oEwMRXL5RQ74cxTlA2r+K1xorHIxT9a
	 lIjY3m7EOxoGpJ4WIe8yDZqdOJ/FvUiaQMrLsYQtVY8FSsEDPIyUgdXLKWbzdYwleDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792442016;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZqoytXf5ITNo48qVxQ8B8oufJFRCfKTNHeMZXX0L3jA=;
	b=lJP+4MuWdpLrd9ktCN3RL/6EimDYY2dbeEGc4GCvCtuI+mymhT/QyN9ol0ElcakM+wbs
	 3i5zIk7aTa1XLbZ4c8y2bwqvKnioRBRukWQxd+bdQ/ptj5EAddoPsQ1SdSdcsTp+zhRxw
	 YL4Qyew45CQic/YsR8OVMxEqW6FmrkVwAOEWIW1qU9qCBORXH/zSfuSNNuOYfcZlJWw8R
	 c4i9pAcRReo8UwwZlAVBIM57RQVVCzt12HbEo1ET+jUCEBADMfFj/X/b05itNixn6HRvj
	 55YkJfd9h6p2XwTODkvD6vE6SIPwe+OoR8KmAkuFNqjjKT9JH3ZdZfwoAMW8U3Wm8gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Qi+fcTNn;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5883F606A31C;
	Mon, 19 Oct 2026 20:33:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5883F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Qi+fcTNn
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j7nLl5dr8z1XM4Tn;
	Mon, 19 Oct 2026 20:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792442012; x=1795034013; bh=ZqoytXf5ITNo48qVxQ8B8ouf
	JFRCfKTNHeMZXX0L3jA=; b=Qi+fcTNnDhW7cf5w9SHuU+qUyUA5byaq0TVPUT7j
	Alt6hePI0FRosAOEIaMwMRKQY5AANGKwqXn1EX/PD33YhEzKUyktpccPl+KJq5jk
	swQNMiyCJ5R2YDU85EX7qygQInVhOSEmOoUsDCz+J6kxN48f2jWP3hbx4/DooIEo
	iLOIWUGcaZY4/56wp4tlR2d2S6uJBAtfP+eWT7B4QGrHlcxN7lI81+R+pab/Yq1Q
	0JwL31thmCPfH8HxdAI0rcglFhHHhro/igB3QOcDCmtqJs7BDOr6BZyR0gUbK7Mt
	WDiKWFS8y2FhqcRDZQakSgqaJ8uC3X6wWKH0J9ZsvOsJSQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1iO_oSIpXFxk; Mon, 19 Oct 2026 20:33:32 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:80ed:7b96:75c0:6989] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j7nLg5kNVz1XM4Tl;
	Mon, 19 Oct 2026 20:33:31 +0000 (UTC)
Message-ID: <035f0183-a748-4eaa-a6a6-a358944535fa@acm.org>
Date: Mon, 19 Oct 2026 13:33:30 -0700
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
Subject: Re: [PATCH 2/6] scsi: sr: release CDDA request before copying to
 userspace
To: Wang Yingjie <x-professor@outlook.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
Cc: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>,
 "axboe@kernel.dk" <axboe@kernel.dk>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <cover.1792237341.git.x-professor@outlook.com>
 <94d7bdf7391f208b74ba98988c2a52c939d689e6.1792237341.git.x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <94d7bdf7391f208b74ba98988c2a52c939d689e6.1792237341.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/26 8:41 AM, Wang Yingjie wrote:
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index c36c54ecd354..de43d6e56479 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -968,8 +968,11 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
>   		ret = -EIO;
>   	}
>   
> +	blk_mq_free_request(rq);
>   	if (blk_rq_unmap_user(bio))
>   		ret = -EFAULT;
> +	return ret;
> +
>   out_put_request:
>   	blk_mq_free_request(rq);
>   	return ret;

This change triggers a use-after-free because blk_mq_free_request() 
calls bio_put(), isn't it?

Bart.
