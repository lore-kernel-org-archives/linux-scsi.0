Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFB335201E;
	Fri,  4 Sep 2026 02:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490238; cv=none; b=qPBPP+lzfm1G+NpemCY3zwdsJDqFL523tdIeSTXz8/YJV95XyyfvJyf0DVebXsbUJTYW15Qs32I4aHedhJkFoGskVNYWW8NfdRPdLi55jEbQIccgVlgfkvbf4soGrPIQGpcpTVCsY8+uZPVJd4s4JB87vvy+8FxlJb/c49/XptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490238; c=relaxed/simple;
	bh=B3qs6kJ2gMlOjs1Zl/2liK6lPqyFcuW8dw04jJ/O9PQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JB0scFLoLCXgiTM/cD0jOe3G2WmPVhzyYQj7EI1eoP/qOnhWBy1t7dQgRNpyC7WSrTvLBVtngG7mRelWScT2znUlj0g7q939iPJCoNpw9gSjT9yB199Zk5MAogoivIO/YjwgA6VFdClmbKE8axtX/Df9SMiEivaABZHGYGoeXEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Soj4EyC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Soj4EyC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702731F000E9;
	Fri,  4 Sep 2026 02:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788490237;
	bh=B3qs6kJ2gMlOjs1Zl/2liK6lPqyFcuW8dw04jJ/O9PQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Soj4EyC+Xs6wg01NK0OKZgpT6/IYaRsWZq8wYp8cZ8pKqira+hAGnOy1EY+xspN08
	 5aw1DWEHsRhFICFlm7dJDpeM0+GTBqAJWthBO4L/Inp9EX8yESRH/yI0c5MfLd2J9e
	 dWtkSuPqVVAojdF8QzsvcUAxSO/OSspj9F4KU4ewmYbnRt//Vh8YF3IE4/eY+HXbjW
	 O7tJjjFN+oV8RNFXC51Ci0hOxDMb0qUmx//UdY3b/3rLLXF7i2xJzO/0IPXuA8hMGE
	 HIc2545TXjiLf6at3qXv2K5SDU8+Kd3KsNdmR5R3Io2cKfK/vjGB/62rF/SWaGyKLe
	 JwIMZWDRFi+xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 38/40] s390: scsi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260904002644.157668-39-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-39-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:50:35 +0000
Message-Id: <20260904025036.702731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Use the 16-bits sense codes and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined
> in include/scsi/scsi_sense.h. This helps with code clarity as the sense
> codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D38

