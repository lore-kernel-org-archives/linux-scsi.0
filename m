Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792614556;
	b=oD5l6zt/YIMeVyNu4b0zsaYwpUaLZ+cbdnUctLXL6YyxtD0Fg/0sS+gpo5YALTc0N+nW
	 QU+TqUIBjaKA7NQa3Uo+McRagZbepi0BZi/8O1+JUIBTI/lGhT5qmWyHrAvGBCni1nvqm
	 cr8XsCWf2SvJACBv+o+QzQCPCK6EwV758xTBzUkvBL1yraYfvinMwVvn+ZphDn20WNZOr
	 QALa0rJd2SFu5ss9oZHZbGS2mS0Hy08Wh3MRzrB6imxO3m8/QElDOyuHeH4a1LSsoouZi
	 idjmmDFkkOwHDXgHfSbvvh5l2x2h/rAmFJhC3aVoLu4iIbjmQ8e+GO2iHtv2GFIczuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792614556;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=N67W64rLQ7g17jQDap7JCizaVRTo5hdYxloLj3MCFzE=;
	b=dfgM8R9BZ/Movaukg1bbP76cDrKJPAolFYiuC1A3BkigmE9yxC1bwU3OJotEE25bycrt
	 EnWHDWXn/HsqPlhjAfeVQ2ILPy0AGy1SHZew7YM0AjO/fqWJOX7YU0K+MjFS79Wg4XIjl
	 ID5/tP2EaCf2eRLjk+1XZABgdZcGWIcoajCMvt99yGsrbOnxle9aZQ9xJH1WFpfMPpUUp
	 HX9QOXoqqOLnf3X8YRW5xiCqfbNGtRDogTgIxvf8g0vE2FuR15JgIR8TwIlf9LVXzsWjC
	 xtjpFECi/uZWetVj00udfZ+lBxk39GU2QzYdIK0YirL9hewQSqyOtgRlCTrcV64DsMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=QHPxv1NM;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90588606A31E;
	Wed, 21 Oct 2026 20:29:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90588606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=QHPxv1NM
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j918j3zbpz1XM4Tn;
	Wed, 21 Oct 2026 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792614546; x=1795206547; bh=N67W64rLQ7g17jQDap7JCiza
	VRTo5hdYxloLj3MCFzE=; b=QHPxv1NMCk15Xlf6/G+reX5rINWJl4zYj0M4Kf4R
	xAyys6kf/AWITd9MxzSjMJTTyt4pQrY+2aLSkfrgAiZ60A4xSQrfPIRzveqo3Xg5
	VocnHkgHzYfFrs/IpeCJNcGLPotcHic4/UW4JVsjrNRhLo5gSlHwS80xHNKI1J62
	lTJ9pqbUmUhHmV6vPIfN+bm1FJ1WtkoDdxs+usZ1/3HdUmpgdf2wyvkbcUYAPhbA
	cc442VNaSFnql/Ap2fVpb0A8tQBldBt9U0A3IGHoRzzi1hmFzMmyDiJNmngSQ1DU
	jfIW4Dy92EsmZdQlAhRzpZcHy2G2gWutrcLS4mRC1iWNDw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SAEBwvzpxHju; Wed, 21 Oct 2026 20:29:06 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:9952:bdcb:9eec:da8c] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j918d1w4jz1XM4Tl;
	Wed, 21 Oct 2026 20:29:05 +0000 (UTC)
Message-ID: <eb20226b-cfae-4b10-b42c-1b12c2d17687@acm.org>
Date: Wed, 21 Oct 2026 13:29:04 -0700
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
Subject: Re: [PATCH v2] scsi: handle out-of-range SG_SET_TIMEOUT values
To: Wang Yingjie <x-professor@outlook.com>, "mkp@kernel.org"
 <mkp@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <9321a59c-c560-4742-8b71-5b0ec1f30c2f@acm.org>
 <20261021181804.136336-1-x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261021181804.136336-1-x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/26 11:18 AM, Wang Yingjie wrote:
> diff --git a/block/bsg.c b/block/bsg.c
> index 82aaf3cee5825..632b3f6d98b29 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -132,7 +132,11 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>   	case SG_SET_TIMEOUT:
>   		if (get_user(val, intp))
>   			return -EFAULT;
> -		bd->timeout = clock_t_to_jiffies(val);
> +		if (val < 0)
> +			return -EIO;
> +		bd->timeout = min_t(unsigned long, clock_t_to_jiffies(val),
> +				    min_t(unsigned long, UINT_MAX,
> +					  MAX_JIFFY_OFFSET));

MAX_JIFFY_OFFSET is guaranteed to be larger than UINT_MAX so the second
min_t() expression can be changed into UINT_MAX. Additionally, please
use min() instead of min_t(). min() has been modified recently such that
it allows some type promotions.

Thanks,

Bart.
