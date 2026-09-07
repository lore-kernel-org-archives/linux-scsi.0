Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A5D38BF6A;
	Mon,  7 Sep 2026 03:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750005; cv=none; b=QheYnc+VfUd8ioRT/rPdsixpRawskTVBT5WV4vMvpcj/Gye5H/Z+Z/GPItljHRthgcdVSl2QmwfR3inTi+mDMQX1cQiSW6K+eHx49iw5roK32v5mybmQhZAaE4+An1aqc/998IQzvArGVwrLeZIi8NwGUnkEvVdX289osag3j4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750005; c=relaxed/simple;
	bh=rQwEguELF5NCgnG4SXHAm9eTUTOh8cCm8YvkSYH9GWE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V8eBVz1Dsitu80WhjYDZRJL3/iybdkVFbSHGtRgwZqprYmwrPw+TcDKfatoZTNXFpNcYtAQt8lDoAJirlR3TgGXXif3kuNQ+cHbx2K4Ynujbj7e7jt0LAzdLG87k5qlyoUZfxY32x+6Efco+q0eI7hbG/O9btB7pAl7gfqxUXx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7iGVhOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7iGVhOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F71F00A3A;
	Mon,  7 Sep 2026 03:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750004;
	bh=rQwEguELF5NCgnG4SXHAm9eTUTOh8cCm8YvkSYH9GWE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T7iGVhORCJqBSolAqoGEW0JE2B3cXR1rEyBIN2m1A+Yfn7zUMr/kKlSaYe9zKwoO9
	 +ZjJU6vYq+gD9GOjYGpbZ3A73DBKmtQikU2sfsk0Yo7D6tjq/AAHTPQZ1cQs6So8jZ
	 ieTeWSh730v+qT1bkPqr6BfNJ3mRjYOsWbltvxnvBnfTQDlQnotvGge9vD2SLjT8mH
	 vcCVos0llGlgOEQ2qF2ZlDu8P0UERtkH4kFfsN52EOwKmleEJk5PBn5KGxMj4zY3yc
	 vH+YmunCZRwOcE98s4wA0bpLZ8zWT/LEL7IBCpnDQBkp03rXFeSn+l/NXdava/1eJL
	 S1r/KxofZIXHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 20/40] scsi: leapraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260907024343.1046387-21-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:00:03 +0000
Message-Id: <20260907030003.E78F71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the leapraid driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> With this change, the locally defined macros for ASC and ASCQ values are
> deleted.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D20

