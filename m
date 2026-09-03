Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5889A32D42B;
	Thu,  3 Sep 2026 03:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407870; cv=none; b=kaoAKMPi8p4/Y+dtHFxfHMQuE0UUWlZwai6rwU2mJpcrOE0CrqGWDuuLViqkf7OdnOybyj6OWxeqqikqOD7jGdCdeTi28g6/W6AQGiXiHAV5MuGB6EqzHjCCsL4k60q25LKuL18+q1LPplngfQxI+IBZz2efSV9XE06OtFCXeG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407870; c=relaxed/simple;
	bh=hQWDvyZLO4WVYY1UaKSJEF9FdOJCgYuLCLX2gY+qwdw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jPlipJWq+l4CO2PYDkKIcCPwb+q54OgQ60Xigz9XqevQBdYYwKhOfMgWmEbpIlI9nQr5lmCWBU+ovKEHu9sIXK2+v+uJAMQiDF+9yBwo2F4iwnYmdlkHpkk47dsDCtIavIOdOE+28o3JpagwdUs6WiFjbkHLwmBYTbHFEqAjV+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HkARIweD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HkARIweD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B424F1F000E9;
	Thu,  3 Sep 2026 03:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407869;
	bh=hQWDvyZLO4WVYY1UaKSJEF9FdOJCgYuLCLX2gY+qwdw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HkARIweD0BZtbx0amrfq+RrC1KXChEhQwmL0xP8GdMZdlrsA3CEbJE5AlGeEH3t8a
	 bPxDHliMqEM1JfbQTa4dDJVxN4KV/DL0abtxyRRe0CBKTIPzxkxF0zs/N2MOejxow2
	 ZUHF4/EZsGef6Pu80Mnb1iv3PKK7hkxRhPiFd2csypQ4ljboKetBpEAtHwh65sQoeL
	 078SMSFn8ea94ZTr6UbH52c31Z45utNEv5USukm2u6ZkEXDFrbsQo6EIwbVB0+OpDP
	 2eEBrCljZgOP1/sDD0KlPFX3Rx8yv1r92Ja3Fjx4kehk8Jvc1lG2CBUyUtCYAT6D2y
	 /Kw3P71eGtAxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 36/40] cdrom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260903034201.112211-37-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-37-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:57:48 +0000
Message-Id: <20260903035748.B424F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the cdrom driver to use the 16-bits sense_code field of
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
11-1-dlemoal@kernel.org?part=3D36

