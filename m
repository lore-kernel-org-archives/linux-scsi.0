Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793160542;
	b=q96yiGHBd/7QsK5xYLiBisW+/YIwUmS6aFy27yUp0hlr8XX+2dKGdbsKdkDTh33Aq80C
	 ZWD77l6/cnkMOi5R7k43tULcnB98EblFFhZtEVmuJAPplCz/R8vegfbgGDRla80lk8ZJL
	 plnYDUyydseEbm3BlNBp/DGhdc2QtxXoN/Stz3LH/5DyaB3ZAtluAoLX0VAgVTQI8DeqC
	 bZqDhqrBjoNX2rmwII8bRholdKTM+Q0qgsjZhsY8OLnaW4yTcVaaYhaOEbZJoSxPakWsi
	 UTFcwsw9BZptY9YHzbVQ7yOUA1J2Uq8vGr/77VZBCz/Qf8bzNwSidXp0HAZdDbIS83g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793160542;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=pbioChka4CzVyFKDwQkodpY3yzbr0BYV0O4+n+DDWfI=;
	b=Qky/FJfTZbGHQMjV5V0R7L0vcooF2T9lWQqPs8N9j2xYxXdTUx+p+nNUXKqfitltw8Nu
	 eSLr8BErAZcn2X3xhYlTWHhW3UUS7ENfJenImentZwPEXsLhU9zeDKi3wHs24WXRWx1zJ
	 Eh6jfSybVZ0PZYk2XeRSpG+HufMHAqBdt+zsO/p6v2REvlFwSIFx5mk0AWokipS+bP3cc
	 iOUiNmyBcRcMe7g7cgxxTZRu6Mti1xU8V9T4WCs/dKDI2Wc7IT9V3e1aRogsqWzkMbUpt
	 lJYUkajf5UGkolqjwmaTu3JiiHoTb6bfhTXqScsoSIK7a6cuEcQ3m+lk3MVhopiQx9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=JOUuDFsU;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9983C606A31A;
	Wed, 28 Oct 2026 04:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9983C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=JOUuDFsU
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jDv4R3gr9zlfvpW;
	Wed, 28 Oct 2026 04:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793160533; x=1795752534; bh=pbioChka4CzVyFKDwQkodpY3
	yzbr0BYV0O4+n+DDWfI=; b=JOUuDFsU/MQTE5K7oj8PGvsi/wygpkRkG6E3qIxw
	HejIUTMpW0GYTZC2WpgYNLx95UwppwdLrwNCr8jS9OOwpex6c0QYgncxBXempzpT
	86yoEbvbuRa93mOTpKVEjdUGSxYK+kJmYurWIQ5vRuFwqk6b2n0i59t2C1HbebtF
	mT5Boamm5RY/QuQ9Rp4PtOJtqzpVO+KN70w5Hhua2VKeNObhwtqDvV44HZ+u9j8z
	lrd1GYqU4ZQoYy5p7nDB3u+RVblb8FVgRCR5PGeVGHUCj8NyPLqIlLF2988RpStj
	gfQ++RiRdyhKUxuLQoVdYDd0vQjIwiRSsPXJKy0r0AoCDA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E4kBdUCQaUik; Wed, 28 Oct 2026 04:08:53 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jDv4P2DpMzlfvpT;
	Wed, 28 Oct 2026 04:08:52 +0000 (UTC)
Message-ID: <341706de-b607-4e29-917f-568c4cddf782@acm.org>
Date: Tue, 27 Oct 2026 21:08:52 -0700
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
Subject: Re: [PATCH v2] scsi: core: Balance the pseudo target reap reference
To: Giuseppe Piscitelli <ooonea@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261027100859.1031135-1-ooonea@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261027100859.1031135-1-ooonea@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/26 3:08 AM, Giuseppe Piscitelli wrote:
> Drop the caller reference in the common cleanup path, as the other
> scsi_alloc_target() callers do.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
