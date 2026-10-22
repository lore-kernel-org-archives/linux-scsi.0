Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792712418;
	b=0fg+fpJpSZHkfkx6wtcaBXDwGqorj69rTap/m72yB7fAJlAMgQx06DNqNvxqMljBw0V+
	 0hTf9ggyIIoO/iTeZ0dpkKuJWW3NXcYP0Fb1j2P0kt5xlXRn0OA3tX9w4xXi1QDCiNEqe
	 DOfRhznCXHANYDF8sSJioz13ff+l5If51oC2Cy/jIfFlNzzUeKDC1uBvTaZji+zi0eJqM
	 qq0sVKgN2V8aZCKsQqXz60Yu3PM43y/hWjrpmagG3poo5otVVjE7VFcQwxL6VMtmK+htv
	 +N0m/GdUM3BzoSuaWX9XscBgMGkPb5JE2BUccwEkoNiWNlKA9ggCgrIfUmNq0F8jN7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792712418;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=KX4EJZm0EQmRTLudL/JYLH8HB7RyxKs12LfEmWjjSyc=;
	b=R+9P6HA/FmYfcmwov7bOoeOdZH9sjYPDFf0TbAe3j5K1pGT31p0cHWUh7A6Z3atuSZ4u
	 7MOcZKYfcPm5p5sLRbzBT1rRpEfOknbStXoPpbaUa7ubx8rNXExkLHKTRNBGUHOEKmntc
	 NQJN6gf5gpgMDDMpLym8+k3lJD0WvUqNjcSSS5388yCNTzT2EWufwaxPc8S5z/0V/K26C
	 LUW7oJa3tOyl7yKKyN7njiVRCMnLvc97NZ1QMeUAg5bCxh6q/cH7pOT1m7UFqrLTtUTYG
	 A52T6R7rV1Cg8sZ1FL6i9GtcW2jBfiTS2lfPjDKMXjMcL118bPIlmhrKG6u5qZFys+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=iIb1yoqq;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2287606A319;
	Thu, 22 Oct 2026 23:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2287606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=iIb1yoqq
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j9jLm6ylvzlfvpy;
	Thu, 22 Oct 2026 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792712414; x=1795304415; bh=KX4EJZm0EQmRTLudL/JYLH8H
	B7RyxKs12LfEmWjjSyc=; b=iIb1yoqqHG9VLoqUxoScAVCGRtfMv125y8pQpoHp
	YQ/qGomAd2oWXEDiGx9osdPqvaKJq3D/OG/N/tSXiJ0vP1isL444t6j4H9hGMtNL
	bBfH4mVOddzDIkIjQlZpfUzOWuBtVAK9A2Qzk3c3atZRQPy1UR8+NKf+VtIApNf5
	Y3lS58GQ75/Hg1qAN5MlH+vcVyI97DSCB3/nka8P39MH3WbXwjsGKXYuAwM4uzod
	5JexRFC8qgBFAd6A2YwtQ3gC1zBSz9/7S6833eus/uUdcQA19rn8MDZlJReE2A9X
	gI8ymhyA/RaOE4dQoL7sTd+9ufOJJz9Rll6iAq13/tynIw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hT7VQrYR-Qkk; Thu, 22 Oct 2026 23:40:14 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j9jLj4mQYzlfvps;
	Thu, 22 Oct 2026 23:40:13 +0000 (UTC)
Message-ID: <b09b2cee-fcc9-42b1-8e13-3e94aa02a8e6@acm.org>
Date: Thu, 22 Oct 2026 16:40:11 -0700
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
Subject: Re: [PATCH v4] scsi: arm: Convert acornscsi-io.S to C
To: Breno Rodrigues Alves <breno3011alves@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261022183658.58090-1-breno3011alves@gmail.com>
 <20261022185224.60700-1-breno3011alves@gmail.com>
 <20261022185224.60700-2-breno3011alves@gmail.com>
 <871p9h1kc7.fsf@trenco.lwn.net> <87wlr9z8iq.fsf@trenco.lwn.net>
 <87o6clz749.fsf@trenco.lwn.net>
 <20261022230049.95290-1-breno3011alves@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261022230049.95290-1-breno3011alves@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 4:00 PM, Breno Rodrigues Alves wrote:
> I will leave the decision to Bart and the SCSI tree.  If they decide
> the churn is not worth it, I will not resend.

It's up to the SCSI and RiscPC maintainers to decide how to proceed. I
do not have any RiscPC expertise.

Bart.
