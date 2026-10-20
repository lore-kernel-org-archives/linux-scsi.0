Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792515227;
	b=z9Z27Y3pnVSmEjcuwG02JlHPClKMvYRg5omPgoY1ibrpHdgf4JdmAz11Jt1Mz+/a8ZTQ
	 adNZZjZ93wBqsTq/Xn7Y7bg9QmO8DlYtc2avw1hh0rOhLQNg+7jj9NqtSQI+agG1AUuA2
	 v0YAIC2ce3v6audPGfHPClBLz4KmVHZn1itmQJCXyN8QHkh0Kzz8GByUENFj7cbislyWI
	 1MqBNBHg9F51VNkrAfx7jPEP0o4C41x0SqjhzZCywRvCPtMcdVx4aDUAc9X1GMejwDK3y
	 JGRvzOpr2PEZCoYpFZNzV1k0rJCWXTTTNHHB5+nXJAZNr/z5xENJLlQrTXUob0cmqzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792515227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=pFjMjrUW0NYlGV6eXcQPR970X7IB6G109x7Ig0FhqbQ=;
	b=yZJ4wRzDXmH4h/kRqoGdgSmdHGgqb4bniOSVbSmzQPqpdpwntHhMsqKYe0fR05LdZniu
	 UxPJ6LyAPj2DQy1KBYQJxEpF/CE8Zgc+2kU2wMchNxE52PKmLvjWgQ4tn0pZbpVL7lzcQ
	 ZZbHAsBX8BwyUX34Mmdkkl04hOdQSgOGAeLmSGxC5YBcrruXelsm648MmEhD1xhrMT7XT
	 uNKO4DOINmfJbmw5+fdJ5l7NqBJajzTOl8IQnpwOH6QiDvFiHkz9qBPrHKP64OCRGTZI8
	 gNjGdZQ9hTMO4yp/S2Iwpv006kNBY+ky6utkngp0JLf/X+XZ+4/GYwVNCNcZLs6LowA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="U9B4C7/d";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935FD606A320;
	Tue, 20 Oct 2026 16:53:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 935FD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=U9B4C7/d
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8JQf07v5z1XM4Tn;
	Tue, 20 Oct 2026 16:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792515222; x=1795107223; bh=pFjMjrUW0NYlGV6eXcQPR970
	X7IB6G109x7Ig0FhqbQ=; b=U9B4C7/dxqWoePuwLsVCiFmNZQxEdyxGesuKcdjN
	P6SFIh7pe0Km0b/1i0E+hFozuN4Q/+3rXDuj+uFzoTe2CKcF+uR33sPknEoV0KYL
	xGPBXe30IQRkXWTQ5gG0l7ywRzXt9oVwt6nY+qdPKM073BJ9hTgkNUti2YTPKLEO
	U8jM1xC3DZC4DPdMicT0sYxBBhliYyYfXL/iETOH5+GlEjh0GTab9lSLyjMmYtvP
	whmA5GNaLJiAqabeDtCaj/gdhmOb01ip/WyvWXTE4zgCFhxDQp6DAwAh7MBxwCvM
	vNpLSV4z8a1T1iVReoCF9jU+AR+Nj84NduvlHHYeLxg5Jg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fXs8ebs7fYK7; Tue, 20 Oct 2026 16:53:42 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8JQY4B8Rz1XM4Tl;
	Tue, 20 Oct 2026 16:53:41 +0000 (UTC)
Message-ID: <3a07f61f-bd49-487a-b72f-209a7b8cd3cf@acm.org>
Date: Tue, 20 Oct 2026 09:53:40 -0700
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
Subject: Re: [PATCH v3 1/7] scsi: ufs: core: Remove an always-false
 WARN_ONCE()
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261020082110.3511797-1-stanleyjhu@google.com>
 <20261020082110.3511797-2-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261020082110.3511797-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 1:21 AM, Stanley Jhu wrote:
> The WARN_ONCE() in ufshcd_poll() can never fire. completed_reqs is set
> to ~tr_doorbell & hba->outstanding_reqs on the line above, and
> hba->outstanding_reqs cannot change in between because ufshcd_poll()
> holds hba->outstanding_lock. So completed_reqs & ~hba->outstanding_reqs
> is always zero. Remove it. No functional change.

Patch 2/7 has a Cc: stable tag so this patch should have that tag too.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

