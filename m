Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCAD374A1E;
	Fri,  4 Sep 2026 01:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485550; cv=none; b=GJywgbxp/V515+8JSpQ2nGb+SH3JO2vmADT5KW1v3EkccW3WjwPfDoGfLH63MD2I60ZrTLnOUACWOcTTaXsvfG8LlPL+Qou0nKAZ1XgzmF3L/zghAu4GcR4gBNVjk7rK7Ei+IJoOIjJ4GQo/6VG6jb/5/pd9b3mRmCv9rW6GslA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485550; c=relaxed/simple;
	bh=60pw48kQBNJzpVxfnYhGF/fVZP57i+bEGDHwmd5W0rU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fkryJZx+KcBpnVXIMNNCClBSWKqCFd5SkwtnSIXwXbWYSiBXcMW6kgoZPkg0YYeaZfnjHF2g24keOdtLIJEPRN0nh0pIxJBnMXmN8xl7RmO0xVMT3me6YLh+96qh9VMrvxH8gp+Iuf57tc6+KsuhXO+4Sm0/Lel808SRKCPSY0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uve4yRsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uve4yRsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF881F000E9;
	Fri,  4 Sep 2026 01:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485549;
	bh=60pw48kQBNJzpVxfnYhGF/fVZP57i+bEGDHwmd5W0rU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uve4yRsEOBsspQBAQVLfzfwXkE3sDt1+7F5qM9PJBivmCc/1b8G2yRwxMz3FkuZ+d
	 8EkmSNyDz+67mRCrG+qCE0NJWaVL4Diyo8d9XlyJXYjjHh/LT9/KY7ddOdUMr3Dm/z
	 bLHxGymlTF7tiS0RozcLvjCWF7+Frh0LfAxoW2c/GvH+j7nI3yaJf5wOpOo9hYwJd2
	 xdgYVKXNswxPI6kGoiS3TFjKlc+kbVLSZ5/7wFmefF9qGwSFjhEFoYKqJYzpulz2BD
	 02SkJsUk/texHLouYYY9IZtmM5+TiW/oj8pHlUwxcRW6NCM03cKZ+3o2KOjATq23PE
	 3+M2z8WeKrQiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 18/40] scsi: mpi3mr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260904002644.157668-19-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:32:28 +0000
Message-Id: <20260904013228.BCF881F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D18

