Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B0E33939D;
	Thu,  3 Sep 2026 03:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407687; cv=none; b=RIWfc+XVRiJimtyHIadbDcfJzFmXXReHyc9wrQSqWayi0LKAis+IeJVFNIezm1PdfQmskEuGfCBUo6fxM7x8tjFYbIHebMfXnexGrKwgaP+CZ1ShftlTZPk3SXRb8oSV3XITZIz63MkmXjIOlDFjQTCvfTDlM4gAlivWIVYBSTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407687; c=relaxed/simple;
	bh=UpUXJ0rlwqWFyK/AgZI2DAr4izNq080THP49oLlc/L4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LkDO1SsxhFbqICI3FrJVQpvfRSy5X/1AEi84YdU2i2Lstns+gK9Yno+8UX7oOpeD4lx9UvpeACDTMoJwSFXyX4aHohSjls01VFNqW1OgHD6ywe3pFMfnMclk5/K3lex2+o49HBy/NH3/ySvrcKaWyJOyWN7l92zfC6+SU5q02MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hy4FHOAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hy4FHOAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAF41F000E9;
	Thu,  3 Sep 2026 03:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407685;
	bh=UpUXJ0rlwqWFyK/AgZI2DAr4izNq080THP49oLlc/L4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hy4FHOAuzgsqFg0yaKxke4WEeVDcyji2Hd9i9CxCwJW4d2S3N9eu3fTULn0SUwhd3
	 SMZf6ur/I0aZ6UB9xoMz0+XRw7KFNLvli3awxeETkoIzX1NQQlxK1xaIsSOX2nJaen
	 WX/2DO7TZh8U7TFDbb5j6yzbY1KycVyILIMU0d5QtFeje30/VhvVqmhGxy2wgWpYjm
	 VAtXX4JK8CTB/X0tyILVdzXzWvbHbaFO3CfJ5oJ06QEyAD/i6NHoUZZe1sfy2hRva4
	 DcDMMyY/AGPwHvbakSR2K2rzcisXi9LD5R6joiX/FXe/ziRw5B61d9D8Y8yMrUZypA
	 Z+01YqMGN1xsQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/40] scsi: sr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260903034201.112211-10-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:54:44 +0000
Message-Id: <20260903035445.1DAF41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI CDROM driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D9

