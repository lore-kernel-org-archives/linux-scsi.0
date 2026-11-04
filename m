Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763244;
	b=QPEuJa80WLqFtAu3CUZsle3U15H259MVjF+H/Nu+7/leyBd0zcMPbt8V9eB1zO2FdY63
	 kK37qlNfpzEiRqcEU6OKMubW5Bwi11DidlmpK5hj7J14JbWRKlVHMKwq+Xi/1zsOBLsZ+
	 2olmxmcjlE74WR/RWz6KfrpxF3Snw6RxUIHxYepnKaJySqKPeqhe4VQE0rmB5VYevxIy1
	 RzbS19mOsMhgWrQwjX5GIZXS2F/ug9jHU9lgCorH4ZPm4r4MP2erAHVfy01SsjQL6hhYp
	 5nfd21EdHzm9IibCnKWAr1Fgnz/aEt1oegX4FLzSNAzRSKl7pUNV5Zj0mSf91Go18HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763244;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=3wltJZoT256uTvxqXzullfzIIrmPpuiz0U39KPUWI0c=;
	b=BChPvKTEbeUsdHmuR+ze8jpccgCAiv0AiZ8TMX1yTUskY3hOMFrNwlPTlB9qvy1S6dFV
	 sluHpchz903EEdEM1b5b3DcULgXTwzBVCOAoV6j2LX7f1RrEhqdmnRKdkpogtiD8XQPLc
	 Xefzv+cI4i3oDxeV5JmfiKJn23Wmg37JmLqt4QbWBupR+HMDZ+Q7z2xifni2Zvgjl3D6w
	 RmIHeYNkfSj59j54ORaoxUcejjlcfnmBQkC7EqWAiDcKU0O9r3N69VwCRm93dcxOIb7dY
	 RWA8Mq6a5bP2l77aPnj02bNtscdJz/n49h4sjnxiqkHBjwoD8aDLp936rXQUPnyx46g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nx9sHnGF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD9A606A328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 03:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nx9sHnGF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5BD1F000C1;
	Wed,  4 Nov 2026 03:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793763243;
	bh=3wltJZoT256uTvxqXzullfzIIrmPpuiz0U39KPUWI0c=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=Nx9sHnGFLuFl3LC73j6E+RWmE8aog0pG2ODzhERX346lPkAPFpMUmfO5iNJ2mltDM
	 54ePsuK9GsXYx0ieD6qsGvQOxD3WrlDFMTQ/j8Qrd5cXmykahmX19+jfn7f3q6iK/x
	 eJlSjU9JaQgQQ1kOOsdx6Wm0Q/oL5l4rhxvSWnTsbGUXww7B/OA4CBVOpmDcf8IDNP
	 5g/tDB0+EuLiFvP+AJLxV55DbBS1aUlS+f/i3Wog4Kc8Uh2e29n7Ygyv7o8Z2qb1y2
	 hE7K3DHruPNfe6i3091l//osZbQSJs2TTM38rkSvMLGq5w2cz0mcdbLXZWPOSAuxVk
	 EqoyEUNO7hNZA==
To: Matt Wang <matt.wang@broadcom.com>
Cc: vishal.bhakta@broadcom.com,  linux-scsi@vger.kernel.org,
  bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH] scsi: vmw_pvscsi: add support for ARM64 architecture
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261019062959.426900-1-matt.wang@broadcom.com>
Message-ID: <yq1ld791d9a.fsf@mail.kernel.org>
References: <20261019062959.426900-1-matt.wang@broadcom.com>
Date: Tue, 03 Nov 2026 22:34:01 -0500
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


Matt,

> This change adds PVSCSI support for the ARM64 architecture, restricted
> to little endian and 4K memory page size. Barrier usage is updated
> from compiler barriers, which were sufficient on x86, to the
> appropriate dma barriers.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
