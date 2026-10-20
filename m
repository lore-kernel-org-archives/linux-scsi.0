Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792539420;
	b=wh0Z07176ymd5IlY9nnampYtlP1TylIgDk5h28CjUb372FRMZZl5PSKglZ983/qR8/bR
	 8U23lwGPcfidk8lsAPKgHk2NRjMV+OkKz7quxkJCuo1Ev1ohBxM6WrtSVjUDtWLeWMyQQ
	 DwOuhqwnVPGJh2MCOQnFs4+o7R6Crfn33BKm9qnZgW/kiLI3nZ9eIj0x7WlwHuCaJS8GT
	 jGz3kKX5RgpbAjtDVo2eL/onjXj1NdsxN8yHJR9Txva6yn+ytIp6ixQ8ISmxWEA4t4COX
	 AbnMQru6fULOxioTWjY+UQkIh7KycaeBEQ9nbrfqiaO54oAgKIdzg5gGuUpFNa28Sbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792539420;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ab+ACCV5CBTo9Isw4eZvfkWUa4kKHQiqzuHmyUabgBY=;
	b=cltVQ1pSHzr85BGFsSEmM4CjJCzVDfFKuyPX+lhfz+EbxDd2zHYXzJBRCtLePn8M92zF
	 au5c960wDIUbcfCLHuAIp0wgvTsz0gYM1bsPwAKJ2znLepVe47vIp6kOrPnka0cirTmF6
	 SFJYSPkBAi1ij5vBmk0UyCgVWAzK3nuCbD7bu0khHJ5jFkJEGhiqN3BFyNjEoLUQ111PD
	 fxyXdaztNDcVwCCa6LVtTBH2b3HljsTP1eS2f77vkOs/RdUhvvqUSJmHrBv3wttGtrQ30
	 cHPV+vWJxA7zMRKOO2FVlC86Do2Ba5CorKW5DTBKZ3+Ao439r3C+kXfVKHYDYmb9xsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=EB+aJbJH;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA669606A319;
	Tue, 20 Oct 2026 23:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA669606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=EB+aJbJH
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j8TMv20YTzlfvps;
	Tue, 20 Oct 2026 23:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792539416; x=1795131417; bh=ab+ACCV5CBTo9Isw4eZvfkWU
	a4kKHQiqzuHmyUabgBY=; b=EB+aJbJH0bn/+3hcjZnpt+5z72w0y/SZDuaavnMg
	KCkyFy01QetZ132E42lyOgJTkeMc66EcOpyKLdRM6YGhdFR+X+FXahHQWMJy0KBj
	mInIZf/zeq1/W2XdpUhLX1Fihp9hGx5B/EcQ7tdtikO84fj4+b+1XS7MzsWwzV7e
	u/kGffEQbm6Bba/nUa+frK70CWJpc/PAsa57M7BtD0FTw9QGjnsMxfptZlwj6hXy
	8ZIk5n8/9BF2GGAENMhilEMEGFvaIJSZcnNrzHj3z8CNCTOl6MPLcoieAZUrIEIO
	bVIsDM75V3LhN99KqDWIJ5N8OEctB45tfvz6fM37RH5uhw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bfkqMK47a716; Tue, 20 Oct 2026 23:36:56 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j8TMr3WKyzlfvpr;
	Tue, 20 Oct 2026 23:36:56 +0000 (UTC)
Message-ID: <e3cb0f78-c2ed-4ac1-b578-813cb1010d62@acm.org>
Date: Tue, 20 Oct 2026 16:36:55 -0700
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
Subject: Re: [PATCH] scsi: sd: Mark the disk dead if runtime resume fails in
 sd_remove()
To: John Garry <john.garry@linux.dev>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Lianqin Hu <hulianqin@vivo.com>, stable@vger.kernel.org
References: <2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org>
 <557f3415-ea6c-4fba-844e-6d59f71f2ca0@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <557f3415-ea6c-4fba-844e-6d59f71f2ca0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/20/26 12:39 AM, John Garry wrote:
>> +=C2=A0=C2=A0=C2=A0 if (scsi_autopm_get_device(sdkp->device) < 0)
>=20
> Does this scsi_autopm_get_device() match with a "put", or does it even=20
> matter since the device is going away?
I think that it's unbalanced on purpose. There are more kernel drivers
that follow this pattern to disable runtime power management in the
driver removal code.

Thanks,

Bart.
