Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1326051991B;
	Tue,  8 Sep 2026 09:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861254; cv=none; b=Ev72C0GXcmV6P5a9W+CDP1elprIvH0uXChy2A8dV0OkiosGXwnnM/aEKRQynDc2tUfN/lTINMfZzJYGMSidQsRh3Z/fY6XaZd13B1fmHf8XTWHVt1hr9ML9JVL9fagb3zFqDL4WEP5phYMxAeJAhnS4zbfrAB58gX5/AEOplKhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861254; c=relaxed/simple;
	bh=hdWkG6uA+n/Vp1HbfzMflqghxgMvqXOciMdF9/vzFIk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VlFDiZxv64bd3ccpyNPEXfD84a1amL4QqTWGKQrvjMffqzIU12sCX8VyQvemTfwDH75u4fHciJq41UyekhDQm2+pm+Ec+p0hBR3Aw3oMDmeEVqNagXoK+1Oy7Ab8IBl74xlPZK1oyONvydkq0mZmDBArGo5LjTPXpX1TkoM5MZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbxcZyYf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbxcZyYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752DC1F00A3A;
	Tue,  8 Sep 2026 09:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788861253;
	bh=hdWkG6uA+n/Vp1HbfzMflqghxgMvqXOciMdF9/vzFIk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hbxcZyYf7apeKI9ZUtxUxDnU6R2lMqkzeuCogzZRomwGElnnEAJ+oJo84fqSBN2eP
	 xADIv5ImoLbo5AeuTYKSikRbQoMJVGC/3d1nXyg0i9nK6IzCz4Vmjvp2jHsY/2Fh0q
	 JDTk4Yxfdq/VcLE3FKmMq9IN9ML/rHif5FzZrV/c39dtfdvj4LGSi6qjtD8jFwMWck
	 G+GurLPNGUalksBf80foj62DhjabpczOrb5jGUGB9tHyQ9XxoZ6WY3eU9peLn4KcPe
	 C3tUHoThUpoN3s6Wesy0rsiOa3hrogPJ6bSQ2BnaasXRiYuoYRkZUZGMBWVdLmbx8A
	 RpHD/TpMb/f/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 23/40] scsi: smartpqi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-24-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-24-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:54:12 +0000
Message-Id: <20260908095412.752DC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the smartpqi driver to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D23

