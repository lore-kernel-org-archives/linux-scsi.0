Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228D4248F4B;
	Tue, 18 Aug 2026 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787071401; cv=none; b=k77mSGidQMHC1ZluPoOpGOQVn8ZBcWsnMhvchsg01SgvwvYUBmRPsfRhlAz/oIg07svyIjlRlGRcU7WaMJYjk4y+D3risrX3FKiRjDZqQuB+D4CUQpiuZeg/R/LexgKioKLDwrr9T/Y3qBqUwAy/dRj40ePTPTWMnYrGv7lUwpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787071401; c=relaxed/simple;
	bh=xvT/P/1iUeQyvPLMgAxOyNVydmFkVLD1QMvDtLNo+hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T+LnROdYvwXUUj+xh2S/mR7FVWmUymDSUkg+2funo/9lk+1cQylTafo8kxzvs2bXRSNiEWRE2O914d+uTPGBVuS6tIL4mwd6PYdDj35OPo2U9XPi2ZVIOCrZNtJU7AGXaQTyxj0/hcjngZu7czatdfpEhqLaXOELC5UgdetjJmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=P6MiPxv4; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="P6MiPxv4"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hPb9g2l6hzlfvq4;
	Tue, 18 Aug 2026 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787071396; x=1789663397; bh=xvT/P/1iUeQyvPLMgAxOyNVy
	dmFkVLD1QMvDtLNo+hs=; b=P6MiPxv4rlHVi0cZfAijWopQiRpAyleU/wGKUpVi
	9OtrHTHRQ/Y79aBjFKQWETcbSF4l9JJUGYYtg+wiCXqOxRpQvscfzqoxT1P9fqM9
	L5E/nd+FurWScksYgoOGXIUeF6g0qEL96/z0srzjIACJkntYNg8fom/w0sF3RfT2
	i4ERoK7fK1XE2VaZhUw4xkGNAnqmbpQH0tMsaMiGsEGgSDaApLr9s6cheMHdaMMj
	cZRfPXgK1K7D1qAEVwc9EoF76Tcf3qSokJqpUQHxn1jVF2w++tdEXv7/XBoy7ymY
	UjiLagBEby79GvNjYX7/lhPb/NSe4EzxPW+H/JscwnGgQA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id B9fYpXPC6A2M; Tue, 18 Aug 2026 16:43:16 +0000 (UTC)
Received: from [100.80.228.34] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hPb9Y5hmszlfvpy;
	Tue, 18 Aug 2026 16:43:13 +0000 (UTC)
Message-ID: <5f7f4619-0042-4b69-af25-4f387ccc08a3@acm.org>
Date: Tue, 18 Aug 2026 09:43:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIHYyIDIvMl0gc2NzaTogc2Q6IG1hcmsg?=
 =?UTF-8?Q?disk_dead_on_surprise_host_removal_to_avoid_I/O_hang?=
To: =?UTF-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "hare@suse.de" <hare@suse.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <PUZPR06MB622453C37D2BABC5E71B195DD2DC2@PUZPR06MB6224.apcprd06.prod.outlook.com>
 <TYUPR06MB6217E3739EDF2016EAB78E45D2A62@TYUPR06MB6217.apcprd06.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <TYUPR06MB6217E3739EDF2016EAB78E45D2A62@TYUPR06MB6217.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/18/26 2:17 AM, =E8=83=A1=E8=BF=9E=E5=8B=A4 wrote:
> Gentle ping.

The merge window opened yesterday. Please repost this patch after the
merge window has closed.

Bart.
