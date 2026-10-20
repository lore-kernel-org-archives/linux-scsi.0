Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792526263;
	b=JrLQxouBJzObtZ6agYd/Vl4VMi2wjqpGfZ0xedcZld5JRKwAIlhNSN9uW4wetVQaqJm3
	 TJkztNCWC55zgky0kFygDC7zHBYQ3++t7tmWLTNn65Neq5BcHeRd5K4jhSoSeGn1zcbzl
	 rDvg6n/FZkwlkB3Jw9YoAgwvboZ2BKfyStRXHAG4s6xK2L0o9KEf36XW3dt5F0g4JPsch
	 g01dfTxhuWJiXOaFxe2NnQbxsqZZfFHQWYRfSU4CLfapYXjpKuw64g9SCyex84l3ZO4A6
	 nnWFhsiP7VZmvl8glT+/ZRDLGFXWuFn/U4rK7fdys84ohz68NnOhlYreyKud1yFRu4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792526263;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=sTEUgbUTY2uEZgUhNSeKZNJZu7md/19toDkZImjF00M=;
	b=Jd624XC98QtNJm9I4jnU+GBheg/3Ucwt4i8idSNGkc8G5/IU3RnlAnCT5pEQKs+hWZyy
	 ktKulW/QyAbjZGEDxoJyfLi7gvVpw9QcLz3hdoZFjeEzQPYN3E58uFLx1Jp/kuDZSvJKL
	 FFCmGM5NGwHZ3o3FwtkAWZQyEtHFhoUoWD+NO335rnb/JkroQ+Cw86OP3Ur54/2GReCNa
	 ZTYGZxq4ckLsF61I2n++laUog0V/IqAP03JqwwGeMuobyLgz+y1LYDPQHH63wFNIJknTy
	 vodKqAsxPklBjNuKmLt2HMngqlXo8SSN4qJOhcMTMsN/iosW8qg3xWHt9v05tLA6BGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=zZgSE7Fi;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60A4606A319;
	Tue, 20 Oct 2026 19:57:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B60A4606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=zZgSE7Fi
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8NVm5nWgz1XM4Tn;
	Tue, 20 Oct 2026 19:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792526252; x=1795118253; bh=sTEUgbUTY2uEZgUhNSeKZNJZ
	u7md/19toDkZImjF00M=; b=zZgSE7FiotGSntfoWSCZxUUCLkb/F/uW2mkXDhdN
	yU5dt7OWsLii6b4W2cICIG8W0bAiN0SBtwujpImz2txsnGQPc7xgeu6t4KYngnrr
	V7Ol/zSzSdsn/NarmlhiZrTNGuKnsYJJx13gLqfBVLWqmcmB92MATTnSVqVuACTQ
	WKhFaBJ7yHeMnQ4M9cnsjKfGj31slx8tmruwYfEOb1Vy+OnW+8Pt/s2q8BGg2/lj
	XioP3QQyoQ+Qqww4qyWJuqnBBmLk/gwODm2I6O9LCXqp0epudg5TVE46Nm70e1LX
	FxHljSRh+KDzbdfI6lI1wohq1M2pK4t1sP5M95aKViCIkw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qfgUZ2C7llJB; Tue, 20 Oct 2026 19:57:32 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8NVh05Mpz1XM4Tl;
	Tue, 20 Oct 2026 19:57:31 +0000 (UTC)
Message-ID: <163380cc-fee3-49ee-a773-d67f4e907143@acm.org>
Date: Tue, 20 Oct 2026 12:57:29 -0700
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
Subject: Re: [PATCH v3 3/7] scsi: ufs: core: Fix double completion in
 ufshcd_clear_lu_cmds()
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261020082110.3511797-1-stanleyjhu@google.com>
 <20261020082110.3511797-4-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261020082110.3511797-4-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 1:21 AM, Stanley Jhu wrote:
> In SDB mode, ufshcd_clear_lu_cmds() clears the request slot in the
> controller and completes the request, but leaves its bit set in
> hba->outstanding_reqs. ufshcd_poll() treats a request whose bit is set
> in hba->outstanding_reqs and clear in the doorbell register as finished,
> so the next ufshcd_poll() completes the same request again and unmaps
> its DMA buffers twice.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
