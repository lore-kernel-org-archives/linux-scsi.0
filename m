Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CE035DA41;
	Mon,  7 Sep 2026 03:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750454; cv=none; b=COS8w/36hlxhG5qri2jkptf3eXbs8cS6g0J+57tJHhzIj7T4g9qFT0s9SRLHyHzAXMxRHqUlrPzUcKIxHfRq9GpI2Q3puV/CnyXcdUF0yaCHZrRgxvPMBeHpBUx/9/0uK+4f4oeNusY+5XBramKJVp0pDq/EdcF8o29pQZ7M6u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750454; c=relaxed/simple;
	bh=MIXDmXkgtzz3jp6LmabJBNWnb3UkE+Mr/Q4OQ95016M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QLU9513lXsAweInByLzocZNpauFZYfVgj+pwhYDXR4dsPPq76WxGwksOhE2FVQzsVz1YJe2w50cl34ufNnAlcs+60ejkLrDeDXkOradfDoNetrBcJwa8GqCzRfSKR3JNC+IV40+nvsH7hpOkoDyZiTImDx2YHQS7I4JdmgzngzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+AxO7xz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+AxO7xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F4C1F00A3A;
	Mon,  7 Sep 2026 03:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750451;
	bh=MIXDmXkgtzz3jp6LmabJBNWnb3UkE+Mr/Q4OQ95016M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y+AxO7xzUyHIp9c/A6K1p3DKvWgsOzLYhGMEXtUvHgH+eb8rIB4iiAmzFSK7uMxZf
	 pSaJcVsDmJChTNoIXEq3X+6T2du7F8H0trmpIIrZhc7CcYbjjQNOoFLuBhG901HjHt
	 +4xgFoIwWsrDZlGidbfGggj9HKVDHSRtB96v72llt//+EO9v+QzKmrr+wn18IKD3t9
	 DeCA+kBO6EGn41AkEnDn05kewQAxuOwt1AcAgvsG0vw+a9IlcUAYluYP/1UlkAk9xU
	 tuHiuc6qT5C4QFX/vbUVe6lVWXiJp3efYhFMHTpvBr8if5no4xm3VWcmw+0HozFMDT
	 gnELapex+f7FQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 39/40] scsi: cleanup scsi_proto.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260907024343.1046387-40-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-40-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:07:30 +0000
Message-Id: <20260907030730.85F4C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now that all users of SCSI sense codes have been modified to use macro
> definitions and the 16-bits sense code instead of separate 8-bits ASC and
> ASCQ, remove the now unused asc and ascq fields of struct scsi_failure and
> struct scsi_sense_hdr, and the old (and incomplete) definitions of SCSI
> additional sense codes and sense code qualifiers in scsi_proto.h.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D39

