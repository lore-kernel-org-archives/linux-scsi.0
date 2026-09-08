Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD874A4409;
	Tue,  8 Sep 2026 09:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858643; cv=none; b=n1yCM3QbRSkWhcsHmtOgCYUu55L9XWmiLerI28DLyDjcTurZLQ618lRqjaTkS9AY/3E28Ha9PnoYw3JothefO2LHmvCeU3HZQwmB+ZwFlzzSGQN1EWFza05ljmGyh+xeqrBGtypWVMdZJmOJ0nxxb1tG/uHsZ9C9QlB26Fm0BNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858643; c=relaxed/simple;
	bh=r3fa9gaur+gkDf3imLlOj1YaBRbgupIiO5Ax6eLzYU4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Zda+gpDlLR+5PUnU7LUaw/r/7uhv1o2c1mkxOaubPFiCcEvJrMNFBCu/uinMsaS2j3jqYH2E48nr6FrX7kPSewrxBoFHy7ki5e4NFVuaZS5CyGZJSCT+RBG95XtnHmBSP8bPFOCPw3nxtmjtqq+ooS0ZAcxtu2M0m0hpJa7WvtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MBz03yvc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MBz03yvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EF51F00A3A;
	Tue,  8 Sep 2026 09:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858642;
	bh=r3fa9gaur+gkDf3imLlOj1YaBRbgupIiO5Ax6eLzYU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MBz03yvcHaLoHQ3vU6HinISYQ07s14w3trRSFW2SHGk1bB24rWFafYin4ysyCIR0r
	 ECiy3njnCIA1FKUAF5mt3ett2zV7kbs6vCRGJHkh9ZDYgwKG1E9eUAt6a4/8AThtpu
	 xprebpRai2hbUAayWVsF5Fg9nRl0MTMomHN/IHZbYe/SLQgfo/+1hhtC1eXQP11xRd
	 f0iIfzI7vjcoHwdjLmeM9EaUqGUa0hyByMuBSx2GlcpkpfV/JHeXJZfWtMvgJO81OS
	 CJLgoU/CiHaSJCd4pdSZOcqQaQMWR9PJDG6vDVFDeBLO+KRLwcn/GuN5O8UHGeWx/p
	 00NUIL/uGOY2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/40] scsi: constants: rename internal struct field
 names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-4-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:10:40 +0000
Message-Id: <20260908091041.44EF51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> To make the code more clear, rename the code12 field of struct error_info
> to the more natural name "code" and the fields code1, code2_min and
> code2_max of struct error_info2 to the more explicit asc, ascq_min and
> ascq_max.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D3

