Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3AE2BEC5E;
	Thu,  3 Sep 2026 03:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407539; cv=none; b=DCbzdQRCT66Gypg0aP50P4HNJWQi3XlmFund93LJ0m2YV24orgiIOwETVglQIj4T1BP0LcGnYnp23YLAHtNYH7at0crdGWT6lUlaKyYzY5yajNRLsKQz9ng6LXP/molQRDCOsla0oYckJu0vPEJMt3gbEfIbjbp0+TtZZF2xUAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407539; c=relaxed/simple;
	bh=EKxwJoJp3DJMnm7xBDWTUxmtN+AqVk/dUdVBLABFXm0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GhZNY2oRfYjEoUce/4mpafH15/W2DAMh1C5HctExZY+2sxhehZeHTX1ghVqNCKxyiHq1uzxffJQA62OBdFr3bT8o/dWgkMv/dsVvzx0buLbiy+QXfqTIrrfAOAA8kN2wUdZQwX2B8eN9zgm/gOGawfpa2qKa1lPqjC3h1Thhzzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLl0ijC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLl0ijC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F921F000E9;
	Thu,  3 Sep 2026 03:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407538;
	bh=EKxwJoJp3DJMnm7xBDWTUxmtN+AqVk/dUdVBLABFXm0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cLl0ijC4VjWD+52lxAp/YTwhffevd/r0JFATY4a5nOwozQXoBo/G/l66V9/QzkK2i
	 V9GkFd+vaMtmNQmNfHREOmXXx7gsicJqGstGkcVsUo5ihGsvoAMW6UD58hx6/L9XE2
	 7K3d22tJi0e3vRYwYesxdr0SVMHPjtJFC02Pyt1nBO3yB8HT8WUGPMm2Iv6RZjuoq7
	 e/qgWN4haf/ze7wDW1TcgRmKmqpDUwJ+ZbcXQn0kt4sUPRjFqVRVfxbgcocn3hZT0l
	 CY3fU0zhvqzhIhK1aB7Vdj2Zg1+xM1XV712Wvw2Ljcf7cxoXZH7lRxpN2goUsNCRAG
	 6Ts1/RCGANyKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260903034201.112211-20-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:52:17 +0000
Message-Id: <20260903035217.88F921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Modify the function tw_scsi_queue_lck() of the 3w-xxxx driver to use
> scsi_set_sense() and replace the hard-coded additional sense codes and
> additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D19

