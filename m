Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899143;
	b=S2WkZ6ijdHhLLX4YfaoIhNeIBWX9aAlwjGuWK1AyiwGdl79nrSUT8r518ExLHymXJ2LQ
	 31bgrau5NBmWvY7JT5v4o5y6NmglVgMv8A2FzYUJjZ4UH3xWlvl0++S0LC95hlhXIhAHv
	 LwQ3UOyPs0hc6Cfy5K0RqS7icar+UVtvTDkj/Iiis1u5QF6qJAuWyFYlt7iRTyqXOq8cU
	 BYcPcEPcx+U1jd2hPx8qdGHz05fhuXM5GpcsKd9nxtBKxb8bD/a5jC3Lc0l5WdAzWDi/z
	 DNrZf+dJdfqA6v2JBZWonBxl8B86624vzqkYHQ/lyzhBzAzOhiV018aEmsXdAX5rWGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899143;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JGggIEGEOwu3Nw2bLrU9kheGZtf7KE0FxtQIBKlyEmk=;
	b=3EtPduBBLkaTzrBhA+yCAqtFWq8i2wYU2LHQiiRhrYWIIctZMl4YByNro4hBhKnUPaV4
	 mMZFkYATToX2H2jWEO7v52eVOz4weH+bV89qjaa52XToVng0WPKRf/GSRB8zZ1qWxofw6
	 0R4JDhhHfT74lmvNFk76yxyIHGG28ppMT5LPJPm4cP/LUoarHhBjsdbfoxHlY0YOFuygq
	 DUzZ9GfolI0PP5/36GXdi+38WFYqG0NYDpIGofVpXePt3dXLWqa9J4pqwmlMvnGVji3Ka
	 bGOKUyTEbslxddan5bQgmWi5Zr0yshRJ3sFYiOa7ZJBIPzGc4W6vT+8xn2m8DbKVmLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ovl1ITO+;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161FB606A339;
	Thu,  5 Nov 2026 17:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 161FB606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ovl1ITO+
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jL8DQ3zmhz1XMYJZ;
	Thu,  5 Nov 2026 17:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793899140; x=1796491141; bh=JGggIEGEOwu3Nw2bLrU9kheG
	Ztf7KE0FxtQIBKlyEmk=; b=ovl1ITO+ocQwTUFYnSvPpmXFiPy1ryUb81CjCs6E
	Ltz+W5UDMhEwIsIZmSuJ5FbedUwBHcYTfQO3FG/Ii9QMoVAldlsokjXlsT162yRz
	R7bCG34wFU41CcPAB8SM34XO70S40f8A9km2uURvDJKz7X2du3AEizYG2WYsTlUO
	3X5oUvylO6InS3RQF6tgF3eXM7pOOXyQpwijwkWKFUW8yMBpgn5xEouwg1TYDNCo
	QsvYekK4SJPzoSZz9JlQYSWKcw4ueg3raB3QHxkOPVJTryDDWSnf1xNdrbeyhz1n
	q/10zzLRYOlDBQ/iW7yAJnbQiKAE1PttPebpAcsYFbAHKQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b2Im_TIEkGfw; Thu,  5 Nov 2026 17:19:00 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jL8DM6sM7z1XMYJP;
	Thu,  5 Nov 2026 17:18:59 +0000 (UTC)
Message-ID: <b9263599-28df-4b1d-8e37-1f1567d71d55@acm.org>
Date: Thu, 5 Nov 2026 09:18:59 -0800
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
Subject: Re: [PATCH 2/5] scsi: core: drop the dead VPD size check
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
 beanhuo@micron.com, stanleyjhu@google.com, loberman@redhat.com,
 jmeneghi@redhat.com, linux-kernel@vger.kernel.org
References: <202611051933353749X0R8jRBz5_ukO3ZdKD6t@zte.com.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <202611051933353749X0R8jRBz5_ukO3ZdKD6t@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 3:33 AM, shao.mingyin@zte.com.cn wrote:
> scsi_vpd_inquiry() returns result + 4 where result is the page length
> and is non-zero (otherwise it returns -EIO), so the returned value is at
> least 5 bytes and the "result < SCSI_VPD_HEADER_SIZE" branch can never be
> taken.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

