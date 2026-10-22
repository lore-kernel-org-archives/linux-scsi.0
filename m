Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639448;
	b=MMN8tyVlG6mzOVapTQ/yWrWEyQClvc49nlVpMPoEqonP0KpCBXkNVYYXwBa8zvkmRqAx
	 eQhpgSJvjXmTBWUNe9A5Ij2JeAidEQPibxCxDpJPlJJbIOEdGyBSTm249wjR8iqjs6x51
	 UEy9aHsnTHzQO/YRTb5vNEgSNdVzMRJbf/tshzaI2ZJUQXF6t5rHtEis2Ndyk4q1NyUdC
	 WAg0altS9Gt4xH7aSw7FSd9Ppk3mdgSLGJLkdyRDMN88yxEaZOyPG4nnBx4QROJYK/W54
	 xmDHV0uYzGdBQPBh+BcwrmIaOgOFoZZYyd8ozhtGRl2R6RD6kQNz0LMndCs74Bkc7oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639448;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=aa9IrTqfOnLfrWZWM3bLo9Ex3Y6PeCzo4HBarUNh1+c=;
	b=vkdbH34FQmpiO5rrcNzkMLYbmepJNuvKkEYzaHQla8BdiqspYTQdOmyFw7fRC0uoj9uw
	 V+ceLCf2bdITqjYnk3N38/Rc23qj8h/yQ7aJt3L9VzPX9RDxxEE3lpaIqMUKAN22JBEmO
	 LCIies6NKPbyeCGDo8TG+/IvRbOtXo4rLGO3PFtLPInwSzhsqmG1UCyjhsU3Ovwwv/YEW
	 c9ayFSXHihnoNTtciDACosmKO/WqWpXOtWMYFI9Evyq6yEIaQu+mB5ViThvURW63ZMWrE
	 GXLRKfa6Rymz9iFGZVEjFrqvmL1Hk2/CNDvoHO6zZUXMLOpRoblT+VZpmsVu17taxtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=DSlhYaR3;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0D1606A319;
	Thu, 22 Oct 2026 03:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C0D1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=DSlhYaR3
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j9BMW4PCkz1XM4Tn;
	Thu, 22 Oct 2026 03:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792639444; x=1795231445; bh=aa9IrTqfOnLfrWZWM3bLo9Ex
	3Y6PeCzo4HBarUNh1+c=; b=DSlhYaR34MTjT3zy2lmrmuHWeqtymyTYFDA59FCq
	Uo/BNSXqbe+iciGszEE2XFWg60ZxznkzVctwt8OX6wEvR0w+JqY8UCKdPxd3q1rf
	pBfq9g9ZS7YcZ5DC0ON/p0Ci1wFUDv5hnSOWVTa7eMHjXByFUztS4o/UcN+ju/Na
	TKzieyHAGI/RygdgyDEJQ7AUUzMDzUA4Z+IQalrAQj1yR/0qVSLJWqR6BwKolRo9
	Jw1AtUggtTyXjqZq92PzvQKgvfBPHaiu6QWWgT3otRx5lRTZ6VgVeAzJwAm41QJ8
	QWR8MDFiQJheFn4O2zv13GBsZy1+I7FFfuVTAx+IbsnNQg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id z9yNsZqHfWNT; Thu, 22 Oct 2026 03:24:04 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j9BMR3R4hz1XM4Tl;
	Thu, 22 Oct 2026 03:24:03 +0000 (UTC)
Message-ID: <70799053-cf5f-4875-abcc-1c96d79047b3@acm.org>
Date: Wed, 21 Oct 2026 20:24:01 -0700
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
Subject: Re: [PATCH v3] scsi: handle out-of-range SG_SET_TIMEOUT values
To: Wang Yingjie <x-professor@outlook.com>,
 "Martin K . Petersen" <mkp@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <eb20226b-cfae-4b10-b42c-1b12c2d17687@acm.org>
 <20261022025508.294713-1-x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261022025508.294713-1-x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/26 7:55 PM, Wang Yingjie wrote:
> SG_SET_TIMEOUT accepts a signed int in USER_HZ units. The sg character
> device rejects negative values and limits positive values so the converted
> timeout fits its destination field. The block SCSI and BSG paths instead
> pass the value to clock_t_to_jiffies(), which accepts an unsigned long,
> and store the result in an unsigned int.

Reported-by: Bart Van Assche <bvanassche@acm.org>
