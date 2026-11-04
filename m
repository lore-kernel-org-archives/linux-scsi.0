Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828053;
	b=GcfdflqI+98i6Sgy6MrSCMp2s3+9bZNn9t4JKjErh5HeAicg3bqYqsh6634VRa9tTuX1
	 vj872Qz88rJvTvGWwAkfoHta0TLc+KiXhMs65qtRegUN6HgDi/07vrBdxa6pe28VoxsCN
	 k/s91Sdf4DYtGFImfBeLOe1S4Ejko/39BwOf7J5osWoOEqdAzoCtNE2urbSePUunVvGIR
	 drugCYLPfYcnrI0nCiQImgI+uSKV6GPAIoa94IbqG+mp2qaWOPGbNROCYIAUvH0caalbG
	 9nNZVgcPiR0qXLUq9IP0W22Ky0ezRLF8y1zsdLWh5yyLA7PjD7DvWAL628JhzpbR3kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828053;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FH6Ed6uXwagBrJj5nKpBfnX8VXTtOJ7yhG1753pBTbo=;
	b=4Ju4zGovqNIt7Q1PFAu88dzRwVoSReROyj5c+h18R3j4xA3MZwkxoIpnx/5cN35Wcc6c
	 LdCky9F64zWCZHPC5rPcKwI9QOGumIUVH7g8YhlUnb1CSJfvF7JU/fH1cKVJe4g5Emlea
	 66hkBgRcCwxaMYpQd2mjpezYOoAk4IdMkBdqbOo2gr1dUbdmT1H+WZmPeVCYFAFDrjs52
	 5xV81gCMN8egsqyk7oYCq2AnzxXjeNxF+dgr4+6O6Vsn2Yq4tStCi7CubiIoWgYit++Y+
	 MErKKM7zVmP/VaRAtlxovCUn+LbCjNCKp5ChbGlSE4WgswECDQDrueklNn6yD5ERxww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ZHRNeaU5;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AE6606D15D;
	Wed,  4 Nov 2026 21:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9AE6606D15D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ZHRNeaU5
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jKdxJ14hYzlfvqH;
	Wed,  4 Nov 2026 21:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793828050; x=1796420051; bh=FH6Ed6uXwagBrJj5nKpBfnX8
	VXTtOJ7yhG1753pBTbo=; b=ZHRNeaU5FGdEbIAgkUhj72kvt2ThOfqxCvCCFdvA
	1kUjUJY4N0XzvyV9pAkHy5qCTSu2onu05kmGX+IURsIvq3zQ3ezCBq2kH7xl+IaG
	sigyMKnlxjbNPh92Xjf6JSbwQZZDfdhF3cVn0/OU/28JJowjj0NaMn5P406WZZni
	uqz/n+FYALAXT7swAP53hoaNFHZGA5oI+T1jucwPPndo19hJHQBxOmPJ0IAuADS0
	j0yGBiAjH3vRamJ3dK8GDg1FqXmggQXGgjSV6rNv66lQCqsKa9omYuNPCi52qVdS
	Ffnt145jE/JVbSkL7BTn7CkLvOVHHQlIwrGxTYB4j8Tuow==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u-4KdqZzh3jD; Wed,  4 Nov 2026 21:34:10 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:3e34:690f:8410:3e04] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jKdxF6GYkzlfvq9;
	Wed,  4 Nov 2026 21:34:09 +0000 (UTC)
Message-ID: <d6b1da22-2a18-4966-83df-86cb9031fdde@acm.org>
Date: Wed, 4 Nov 2026 13:34:08 -0800
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
Subject: Re: [PATCH v5 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
To: Bean Huo <beanhuo@iokpp.de>, Kiwoong Kim <kwmad.kim@samsung.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 kwangwon.min@samsung.com, hy50.seo@samsung.com, cpgs@samsung.com,
 h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
References: <20261104094914.180788-1-kwmad.kim@samsung.com>
 <CGME20261104094925epcas2p1f25905de00c2548e1e1349fba5f18551@epcas2p1.samsung.com>
 <20261104094914.180788-3-kwmad.kim@samsung.com>
 <41f787035d4a5d68b403bb0f443fe6ab533ff1ca.camel@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <41f787035d4a5d68b403bb0f443fe6ab533ff1ca.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 12:17 PM, Bean Huo wrote:
> READ_ONCE() is enough to read OCS, but the lock also is to make sure
> ufshcd_compl_one_cqe() has finished?  the window is very small, and the lock
> only costs something on this error handling path.

I overlooked that lrbp->utr_descriptor_ptr->header.ocs is what is being
polled instead of the OCS field in the CQE. Kiwoong, can you please
restore the code that obtains hwq->cq_lock?

Thanks,

Bart.
