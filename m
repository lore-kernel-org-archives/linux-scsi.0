Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795662693;
	b=G2lh5MltXmxFmdHLOso6wDvyBCOglbzkTQopSOGFAGSetG96jb6Bszt6CRnqLpWHGynT
	 dkX0NC1M2FThssZ57Jx0yRttAvaIXslzbaFhCh7tH2WWedyqBVR6CurPWvDBbK4T+EkRD
	 vZaqkFOwWEJGHfdrW8CtSjacg7Po59NNb5rZzsZzBPtLC+ppxsFPTpv69kns8YENDrqAx
	 hcIB6Uwd9jgNhCd22Lf+utRPfNeKFyi2uwkLm88d5wEZHpBTMBhRGoFY01pI/HOcW29Dl
	 xGJXf/5LDa97qkHie60OCO5cd6d1RzLmDGgaoBFNNjDny7ROb/Ti7IavbKt/9Dpqp7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795662693;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=AkOAXELuAWwy5wdyD0ZlsQNsawkf0zRqnDPI0pSkyaQ=;
	b=ZeXXg7AjocFwswPBFUK/twVgWEFGXLYVlQU2jqRKBEFV7YZZjMo53Rhddkr9F/RVkTGL
	 BoKF46KJf4kTh89ovsCgPz+Hw6pCya4M7VtviMpC1FOfDk0WgOIW6qtVRZAX1XITQXJJQ
	 OXRgKLjoFGI/RqoTPk4AMhNqSZZ8TUnndRQHtf5TcA/VkWqGfHM7ZicKllvhlg8VnL2sO
	 hEGchR2SeVee0zFZpeWQGJCY9+XoZfR3YQXPs1V1ejRxEaiaZl6aB4N2j4ujTcmaliMLd
	 JIoZRd6PDaMxilrWqv7khLR1DKZRSZJGpuVM0V5epRw5MOsztfTuQnKOjUjkKo8L9Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=De+ial1i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ED0606A31E
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 03:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=De+ial1i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFFD1F000E1;
	Thu, 26 Nov 2026 03:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795662693;
	bh=AkOAXELuAWwy5wdyD0ZlsQNsawkf0zRqnDPI0pSkyaQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=De+ial1i50AKFep5uf8qfU5cTE3Q+hrXhuQj1kXHIbDcU/Ry40oImUo0WvEydSAiU
	 U2r/TaFLm+YIcNq+jY6aMqb1OyQzUs+gDbX8Cp9w4Mto1kfGmyaTOmAxybY+WNXUta
	 hG4C6fbxqZR42KHu2/ckKvbFcfhZq8QSHKdmstRDGMcH3QOBW7295npxa2LiGDi6To
	 JbuDAl2mDvkcwZjoDx6wg0vYSCbIUeF/hmE1yFN6ACEpPZytuoGlwL8/I5YTNIi1//
	 uLm58oLLldd+GH4gItd0APsrvJuVkK1d62R9TPO9V47duyY9D6zsvTWktDyXaI/Aq0
	 jFq6TQgTWFOGA==
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  Niklas Cassel <cassel@kernel.org>,  Hannes Reinecke <hare@suse.de>,
  Damien Le Moal <dlemoal@kernel.org>,  Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: trace: print the CDL duration limit descriptor index
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261124124137.146673-1-johannes.thumshirn@wdc.com>
Message-ID: <yq1cxrsjnhj.fsf@mail.kernel.org>
References: <20261124124137.146673-1-johannes.thumshirn@wdc.com>
Date: Wed, 25 Nov 2026 22:11:31 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Johannes,

> Print the duration limit descriptor index (DLD) of READ(16),
> WRITE(16), READ(32) and WRITE(32) commands in the SCSI command
> tracing, so it can be seen which command duration limit a command was
> issued with.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
