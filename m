Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E523E9580;
	Mon,  7 Sep 2026 02:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749738; cv=none; b=cCy8fr0m7JOsPEu99E3w0Co3kCk1ab97QuILccUjjP6wVlUqZlz/239UJagb0HmIvae32aqENg7rJ+Ag2miuoMVLbA3K7KltQZHGr8xBTyO8RrD1GTI0DZZuQHP01WOIt3b4S8Pyaf3tA1UznVqie6+187HhuxVnVJzYEUqdF4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749738; c=relaxed/simple;
	bh=mknaqL234Q6d6gOVW89CwUhiPeVKv81s6g1V2aepLhY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PxloIJhi3NMrzksftczwLBPu+rUxXVqtTNRlrn0RMPxOqKfLlORQkn+Ts7Lr3JlaBuJ3zCXLwWhiyQXJ1RJ3LVEyXoo2VncpGSlL/Nx3oRaa+swksOjCGiiuSuwkCPPYS9bbNptLT+2qtt0EUf4UCSBxE3vaBdoTdcV2ApQQU2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KR30ZziS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KR30ZziS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911F01F00A3A;
	Mon,  7 Sep 2026 02:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749737;
	bh=mknaqL234Q6d6gOVW89CwUhiPeVKv81s6g1V2aepLhY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KR30ZziSQyzL4lsdNhea01YD5XzyBOImodfxdEDDIZMsFJD9b73P8s0ihiIQV6gLT
	 CEeDaKDfyCSURLDSSAZxxHD/JGelmnnnV6VV8aMND+z9iKstFNEifk54SnARrJphnm
	 IE8TVGxTGLrW5RTcyQeyKJpPK8qiYz9xheA89UI+hCYPQbEMg5vgd3SwWiuaURlsxK
	 91SNk4YgdtMGCxgXZeXTRttDSq/VUudijtUzwbr1moRbqicbkCiFHI7AlScT3A4b+R
	 G9cP0rtsajwAgNHjXJ2vMyRJv1K385du2Pd0gQmkgH4MibCIzAr//UFGlfIXpcoTHg
	 STIzIsJz2g6Rw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 18/40] scsi: mpi3mr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-19-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:55:36 +0000
Message-Id: <20260907025536.911F01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the mpi3mr driver to use the 16-bits sense_code field of struct
> scsi_sense_hdr and replace all hard-coded additional sense codes and
> additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D18

