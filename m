Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A721F4634;
	Sat,  5 Sep 2026 03:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579490; cv=none; b=eple183h+WUtDq/8DFGLuFXZUsiOPg6r9DCJ86TrYTmqsC5NnROk74uWCG5//g79Ujjw/CtXvpEP2VLSTKkEkEoIRn0dBjMLqafJPRGUqssrZRI/uPD/GnB2w5k12QJ9Rkxd1p+86jQqnVmOTHtgtqSG8SEgyUoFoht6tluuSYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579490; c=relaxed/simple;
	bh=PtzO3O+ZXS1dZXbMv1hPRs9iCLcIZqhUAGfOehdPnuY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oWUqvm7nA7Dh6SL4GXS5VgG3YEHmo6iXczZ8itspb25IGNF64sFlaSUDhdudZgOqWeXm/LURRBexOLqv217dOGHoXzWbHV0DXWQ4zHdp75CBXnw/CFfDO/z9uBi98icJNI9tTSNJVDnRUfb3iJg7rCABfTY3kvFWc2WeU1mRabE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JM3WVTOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JM3WVTOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9691F00A3D;
	Sat,  5 Sep 2026 03:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579489;
	bh=PtzO3O+ZXS1dZXbMv1hPRs9iCLcIZqhUAGfOehdPnuY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JM3WVTOjTXREpMXC/se95C6vTJU47kHpTMt7SSOpNXIIATheU3Sm+JLftb+3DViy6
	 OEhRJgA5scItSwW1o6gQ8Ci1eYDhKnCpOo+nnf3bSdkg/d5IqcM6qjSEMTShV9uCiO
	 JlLsvCqivBJztvJBgMd97ewA5GP9BARYNAM9nP/5cUuVHip4QqooBTqd2O9fXSP/jM
	 QZ+sszGaVdJOdIDqAatsFypVmwV8GqT1cHe1FEPkZrqPZqUPfrerIsZtq0U/jjRyZA
	 2Pu8AATZKVNTXdqXr9f5TcSveYyxYbswvpAiGGEyepFd9BpNDBSRzx7niQGllWx8NV
	 oH8lo4DaVbYBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 27/40] scsi: stex: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260905032224.509860-28-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:38:09 +0000
Message-Id: <20260905033809.6F9691F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the stex driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D27

