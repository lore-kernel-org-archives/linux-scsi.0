Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792810382;
	b=bdi4h+Kvi56vRUhtSYecJQTROhh6ntfGq9+BNC4FcASACr3cLpnIDLjW75xC24x8o4pa
	 pjsgBCeiHwqvmJTCGGJ05dvD/C5aDfbypgHbGVlcKllzMbNSlLecwvOBPRXrQzP0lcNcS
	 oASR2fU0NIEnnDVNQtJw5pF21XrcrlVQwiPvBMPweCk5c6IAcQD5n9WpFRBKCwAgkF4x+
	 cXk8ViK8ZSaKS2Y3CF5TpjIa6w0TonRK19LR3qlLtxCo6jyQcUzsYlSuxZTBosxltJYvn
	 JATXa9R+n8DhI42CZxGz8vY1YMdyEVfizfM5aW6oohGaRJ6rCrKF+B1YPGRiqHntwww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792810382;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=V7oDlq3bAYUPEWxfXkFJCRMeag1Sxl7hSlqFKhXKIGY=;
	b=Z2y/xalokRuMG4aFnoEbXL12CxvK+Q/sdNBPjyZgJ2TlDzMHwIbs8XK+4OLO5SxQQuZS
	 CRkaRGB9g6tD7HaFJi4RLyh+cSxbwLE4aIwm2Ew2uW6h00ToRgNIWkj1qC9u2c9ELy7Mx
	 RbFVsJk3oGgxq7IsPz53ebf7PSLppB8QMXtsUgDWKAmh0MU3aopuz+Ta5bK42CViUDngh
	 1f6cXxNuBrIbIK5N/MboFZSFdyUw488IEpFDJvnSAvG3JumSkvT/cXXuKvUxApOM7qPdE
	 xpol14LQLVNXEzCv4Gic2yRNBhs5J7uytylKfnlwK10yKC5FPMtdwASyay8lCEAQSKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bmIrOXf/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B706C606A31A;
	Sat, 24 Oct 2026 02:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bmIrOXf/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1221F01828;
	Sat, 24 Oct 2026 02:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792810381;
	bh=V7oDlq3bAYUPEWxfXkFJCRMeag1Sxl7hSlqFKhXKIGY=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=bmIrOXf/c6pinvbKtbyUHENO3cm+PtxGWadK1KxxJxqSYyO+c77WC4/8XZfAGUVUJ
	 o8ZVr1MhR/Gce3TRc+O6L8pGRyOuGYu5ul+YA/lANPQeoeEJwZ5Asg5ONsYcDVapoT
	 Xq6kqS8XVX8TNp+CKv2nCYFuDOWzGlBvPvxfkU8v9IO5WNrpAQ4S2UsR1nMfaxd1j6
	 iVx1UbojP5KuEq2ZVfy1TdgOHbXdWglqqGtB3ZI0F1rYxiEN39z4hl0gFNZ7sXCrvP
	 lHZ8B3XryqvOcXbxjUWGzl1QdyLoAp8UpstQo/MjF94VvUtCsTfV+wb/aXhB2A7wMp
	 5edOSgbBSkZOQ==
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org,  "Martin K . Petersen"
 <martin.petersen@oracle.com>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Kai =?utf-8?Q?M=C3=A4kisara?=
 <Kai.Makisara@kolumbus.fi>,  John Meneghini <jmeneghi@redhat.com>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Laurence Oberman and John Meneghini as
 SCSI tape driver maintainers
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261020125059.1797559-1-loberman@redhat.com>
Message-ID: <yq1ecdf95dm.fsf@mail.kernel.org>
References: <20261020125059.1797559-1-loberman@redhat.com>
Date: Fri, 23 Oct 2026 22:53:00 -0400
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


Laurence,

> The SCSI tape driver (st) is currently marked as orphaned. Add
> Laurence Oberman and John Meneghini as co-maintainers and change the
> status to Maintained.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
