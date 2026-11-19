Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124248;
	b=Y+/Lk6VuMPenianOOZ7xKIXXsz/eWGPYkikDJbC7Gf3CCJom0GKCVmYCKu2Yr6bzDSTL
	 nU0M1IoKLi1FaCOrLbcpCNUYUs66hBGt7oRAZPubCuKvHyy+TTP3qrx7DjuRTlONOpcDJ
	 utG7bCiDpR2koJJAniY/tnwDE9zVGtsfoIA0JUQjA3orcbN6WM1h+SMgQ/Mm3dZTbFjRV
	 t3CDH8jcjyC21nTedBnfqV7gepbbjiaSYpPq19mVOo6gERj2NCE2W1J5tQHTQcwdJlFKa
	 gEXkvNRlJY3Bo7Ab38adn6FlFi8uQr+d3eIyygMBHIS9HeAMbbThwIHRy026iskObIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124248;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=tXtna4IGsjm3D1D2wMNKYJANe/7SMkoxNQjGqyn9qZ4=;
	b=36Pu0brwr3wedgRIZSkRc5eBqItY+XNC5F9VGYmU1N6kVjp0Tg9f2KuzoR0i1pf3D8VI
	 Qlg5LbbZL28OHfkHBXrcJZhk+YBdjrs7pKfqbYbtKbYk4HNX/FRBBCRZBm4myiSpLvIQb
	 QfDh2Ms4nee8W7E/1PYy+FNEaeNd/M8H7yqGA613PSVH/PN0XXfQpKEci678FDW+Kk3kV
	 +TF5pr6b0Hk7FTXyatA5k8+idwaQxdRb66B3pke1s1TaHJ8QImfk0GfBQyVqXPGgE5kyj
	 YgcCWeHJALzUkXymMVIIySij41XyIrOKckBWqmzXaGuq7DMaN8bDR5aCxq8DLZUdjJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=IDJg87v5;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91437606A32C;
	Thu, 19 Nov 2026 21:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91437606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=IDJg87v5
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jVsJ80hr1zlpJ4T;
	Thu, 19 Nov 2026 21:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795124246; x=1797716247; bh=tXtna4IGsjm3D1D2wMNKYJAN
	e/7SMkoxNQjGqyn9qZ4=; b=IDJg87v5SmX3DBhPaVA6NWHnFokqpM1Dmo5Ys4py
	rVzoahCw4DA1oFW78S5wKULkFuf8+0/wdJpG9INYKHV1p2VcYgm3ywxpH65xBtsZ
	5hcl021qMX9FHTbKJs+us2WlIOhmlh3DMZDyJszVHj2I/eDOQtBW0EbrqAnTBnGf
	XxrFEXSaggqLyY+2/X0Ds7nkP+BXbYnxq12IHiKWYoVyRuTf6QyhhvuPiUNVjQ5j
	kqw/FKGIOgH5yiS0kx8d038aWs6tagiGeeCH2JwTHENSePQIj68k5F2box5QwzEV
	UVyL5fjVsIb+yc8Ke9Mzc/rwTCNzDcWmAKVmH6Ws2dBwmg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SGVxBrKR7-IR; Thu, 19 Nov 2026 21:37:26 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:3bd4:4c06:4b28:5d89] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jVsJ56vxLzllB70;
	Thu, 19 Nov 2026 21:37:25 +0000 (UTC)
Message-ID: <b6d6087a-a89a-4d5e-80e2-6b7f07facbf5@acm.org>
Date: Thu, 19 Nov 2026 13:37:25 -0800
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
Subject: Re: [PATCH v4 2/4] scsi: core: release legacy ioctl request before
 user copyback
To: Yingjie Wang <x-professor@outlook.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton <jthoughton@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1794990780.git.x-professor@outlook.com>
 <26e7d8d4f0648e572e6042c0ae14c1c36a83e850.1794990780.git.x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <26e7d8d4f0648e572e6042c0ae14c1c36a83e850.1794990780.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 12:33 AM, Yingjie Wang wrote:
 >   	} else {
 >   		if (copy_to_user(sic->data, buffer, out_len))
 >   			err = -EFAULT;
 >   	}
 > +	goto error_free_buffer;
 >
 >   error:
 >   	blk_mq_free_request(rq);

A goto statement that only skips the label and the statement that
follows it makes this function harder to read. Has it been considered to
restructure this code such that this goto statement is not necessary,
e.g. by setting 'rq' to NULL after it has been freed and by changing
the code below the 'error' label into the following?

	if (rq)
		blk_mq_free_request(rq);

Thanks,

Bart.
