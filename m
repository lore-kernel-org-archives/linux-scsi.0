Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739093;
	b=Y392jxThhgrf2/06ZTD1hsf2lh5ol5h3uzZowfPnH6N8uBXvXXxj1MJJPnRjRz5b8+fe
	 /fNwCx+lKXcpEg2oqzO4br4XVuJs7C12Yk4+RS5KtJdOTyMQXb41h/fXhUFib/q1jeQPW
	 mp6ooSQsuTgNXlC9BNltAFHUAujiOG5br4SgnkWGqgx+/2D556mBK880zi/QCXIsPqt6p
	 wJPlF03YUOr5CO7YhLs09kk8N6s0IZoAGJ9zFv4bnYeLImN70zIBL/wMHbrRZmh/CEcCN
	 BIT8oE3mIrTrazC2Lbf9VZ9qrbRT9/+A94uxG0MMyWUL4gDU/GkLdolv2iHEnHWaNOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739093;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ImfCTvx9zEM0hCgk0rF4q02G78x6VIbWM4Sk8YP8Ob0=;
	b=3mJvC8AMMMkNUjxwW3UuxdhbDvCi6/dZDjsUQuCR4fG6su+vpAj+iMG0rmZMb/8Zc3dx
	 1Nvy7rCASVE5hkD3b6gyqt4j/kZHwsYdlA/9pERI3dT3917d04xcWDa0VKLP8mDsUvrmT
	 foreV0jEPcWW7hJIu5GyN1KkOouXq1JewxYDeoBC6iGMkVU6ODLBZ1Ve1hPho3lOr/CJK
	 0i6IQcCOA/c6saQhEDq1CQgbdPcd/3A2SQBwPL0jRa8wl8blsh2BzZLvKbsu57Ci2JI/e
	 YeSbSfsPCEK6cl7yqS6MGfNUE83saoFp8XIyeT47PvNpGDXW4tt7yka5sdFhowBxEGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="10zhzj/c";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD0F606A324;
	Tue,  3 Nov 2026 20:51:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCD0F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=10zhzj/c
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jK12X1QzGz1XM30j;
	Tue,  3 Nov 2026 20:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793739090; x=1796331091; bh=ImfCTvx9zEM0hCgk0rF4q02G
	78x6VIbWM4Sk8YP8Ob0=; b=10zhzj/cEmoTYtBDFc+VkMpDCeZJyLXhcYMLX5Sc
	Auh8TSc0cEPz0TJ1NPb8iFqEZTZmQUh5hsfbDDGNnqsdP0rFPMa3TIkqM4jRUNhD
	wDmhUNk+H3joOIu7TDmps2jIf+IxlV5el89pdmbPB05pAED9no28ZlKZ41a7rM1K
	4Ur7M2aQnxyHEh00NeNSVlQrQ7S9aPD5L2GXJDuwrK1lhDtQYfcesxZEo6nDDbtV
	g7L71EMfofKkEzDinYelDFrTHmsqRWbdfhI3+sAWnTfIAQoKogrkQdtet3CMabh/
	zH+xhaIt16DSEP+nreCD5dV4y7Yt7k7u8K/2qLxYGbJU6Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id t_SHQYvpfgLy; Tue,  3 Nov 2026 20:51:30 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jK12T68Y1z1XM30h;
	Tue,  3 Nov 2026 20:51:29 +0000 (UTC)
Message-ID: <ca5e40fc-125c-439c-af28-a277d12a6df7@acm.org>
Date: Tue, 3 Nov 2026 12:51:29 -0800
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
Subject: Re: [PATCH] block: Keep RPM_ACTIVE in blk_pre_runtime_resume() when
 already active
To: Brian Norris <briannorris@chromium.org>
Cc: Stanley Jhu <stanleyjhu@google.com>, Jens Axboe <axboe@kernel.dk>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Praveen Talari <praveen.talari@oss.qualcomm.com>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261029040001.2100001-1-stanleyjhu@google.com>
 <8125a75a-ea47-49f8-90e4-7f7c83db90e2@acm.org> <auo6tLmH0R4_TRG6@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <auo6tLmH0R4_TRG6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/26 11:49 AM, Brian Norris wrote:
> Pardon me if I'm misreading/misunderstanding, but I believe your
> suggestion is essentially to unwind the quoted commit 6e1fcab00a23,
> which might reintroduce a deadlock.

Hmm ... I think that you are right. Let me take another look at this
patch.

Bart.
