Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89133E49C4;
	Mon,  7 Sep 2026 02:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749869; cv=none; b=tusZYnQzGXA9tzf+eavtCScNNX3eiF3iuHreB/GEnHiR8NKVTCkLkcwK4Rf+Ntv6cYLdX/60P6daUBy4mv389ry6CaqniL/HH8dI0p49Tt6JznqNbbnLh+yXulyXE6B5gB82Wf6sVN2ClQnIfc5wsCcPM/WjRuh24nOrTCWLKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749869; c=relaxed/simple;
	bh=vIcroj7WB3VW5IA2S6rlYt547th7NrO15Amo7ZjLcs4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Sb6NzMGCvMX1UOGJBbStIgFa7EeJZqgD5wWpaMGN7l9+ItaKknw7razSJyLsEmC/NnUwTpRrfJb3cixUDmt3JZlPyaXDThUCazLFDqNFNk1tdERgUjIwbLoE6Hq+aghyY1prpGv+apVsdfCnTzY6ibCPRq1NStGlCOc7pzucKks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9t0mOEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9t0mOEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04631F00A3A;
	Mon,  7 Sep 2026 02:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749868;
	bh=vIcroj7WB3VW5IA2S6rlYt547th7NrO15Amo7ZjLcs4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z9t0mOEcMrG15np5kExfAIZTy3MeSjJEyL98w7kqd9byzwPjBT9w6SZVPll1Ne8Pc
	 fiSt+fVpx2mXCbxZY1IEu+FtAl3HTG6ZbVW+e0ZSOPkn6tSdnUBUyP1JyN28aCR3M7
	 VN68WVigdZT/iAgaXP8J6XW+Rgznu2GXPMT0LZ+tyK6dlFx6ZFKWFaqefTfRJrCLzz
	 V4wjpO1IlDcI3tEFApk0tgoPFnKiHSbMt3SUdzPcoPqUTga+ufqEKqts/iMMLp4q6v
	 899/BVJKKeOWC5qxHByIJky0g1iehSW1tDjItozLRSLxaLi0M/cbC3iFrhd0RvVNa6
	 b3tokqb1Bfgtg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 23/40] scsi: smartpqi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-24-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-24-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:57:47 +0000
Message-Id: <20260907025747.C04631F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D23

