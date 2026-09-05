Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43613546CD;
	Sat,  5 Sep 2026 03:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579510; cv=none; b=s0CXSI3p6W2e4YjP+gTTu89wGfKuCcZL5LbXRNigQXG+Zd0HOR7M15r4rWm0p1jhqMhpWR82os2u9rTWIsGkeB7/eWqaA1IhhqbO1a/6ecbp/Dc1hovCDIe/FNZGiQI8XCvFzHKLbAcqnDiDMHXqleexF5LaO5GoZ+9CTxEFrWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579510; c=relaxed/simple;
	bh=CnoUl+ei1TfX+jQV02yVssnoeEAltrlpjmSxVifikfQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=stc4CrKjFkFTB3k/xo8lRAKa0tdsMu96bw48l3RBfB6f3s+kSHOrVkugrTIrbZUpWECInEcR77qx0l+rSmfAE47J+wYpMHLx5AX4zPEwZwoUglajGz7Hqj5W6ALiJMZ8X2kkB6m2TRGu3b//HQHCGYFtTn6nj+CLLeGFFQVMFiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pj9GdT1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pj9GdT1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B9F1F00A3D;
	Sat,  5 Sep 2026 03:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579507;
	bh=CnoUl+ei1TfX+jQV02yVssnoeEAltrlpjmSxVifikfQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pj9GdT1xo9n1nrzps5EEzbPzIorXUVQ7Vw25nU0LXe0aEr+BpZCK6L4ppEreAlGrz
	 ig3isAagQKZIplbXMFc0R+HzyfSoyKVgSMCdWC78cpp5MD6Wd3i1QF/afVCcKf/420
	 wcCVuutcrJih+ZTsoPz3EpbYWilS0ejWMFnC+q24XuUQglR77gp/zT2ml8Lp0JvXZd
	 j8abHBtvfrpEjECCXvj1qEoGBDRafQDB5x3Na+A58POT/RFk6exmYOAmRFDNUl+wBv
	 c3iQYSzT0M3Eah9eBJiIcTvseWlH+aDrJrX4LnXu0fIOYIv0ghiWadlZ/i1sR92fiA
	 /G0wVT3WRbw4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 35/40] usb: storage: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260905032224.509860-36-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-36-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:38:26 +0000
Message-Id: <20260905033826.68B9F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the USB mass storage driver to replace all hard-coded additional
> sense codes and additional sense code qualifiers with the enum values
> defined in include/scsi/scsi_sense.h. This helps with code clarity as the
> sense codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D35

