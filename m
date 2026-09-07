Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7E21A0BF3;
	Mon,  7 Sep 2026 03:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750733; cv=none; b=Hz7tl4dr6HQI/ZcxLC0JCn9y4zNGkfuwHl5lLdTI3wKLqJGtoQOf9k/rnOwcxfrU2k/CGFr7N9O1nZWFW5XvuEF9Ef1jy6uZinXiK6MpGPMj/Q9HwNj2IJGF9NKgy79oWQg3BQRIwmH/d2Pd1sHD6m5IrlSP0oNhCJmL9OeuTVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750733; c=relaxed/simple;
	bh=28+6EMMJ8s9WgVZXWAjbmxb2H+D6uFkemtH6GmK3V4o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Rz1rwSZrJ7JmjQnuQ0jbxUWr/993NQr/G/hVy9feWHiAq433iooWKWYvqRfR3dJW45YknP2ugO09NIFDC/rW+y46h/305scm/6M1oKkMw76Mn61/MdzApAWyCg03O4QskJXAuSvGr16OkGdyXU1wIlkWuAxU8xiEd4RDtHNLNh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XV6C0E9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XV6C0E9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5883C1F00A3A;
	Mon,  7 Sep 2026 03:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750731;
	bh=28+6EMMJ8s9WgVZXWAjbmxb2H+D6uFkemtH6GmK3V4o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XV6C0E9hE/oQE5kOWit+qxS0hBU8u3tpHGLaLulPkwGI/hFlJAe4wL8YHK+WXp6Kt
	 DazJeYrTxj9PFDcU4015Doz437r4eTVWnfaNPKOtVSK7BK6Z2u1SioQDLrrgarBMxF
	 2Vbs9ktmzr8eNm0VBxgGVcAPBJgU4baSO3yd9CJAbl3ZmlQXj4PgED2LIONHK9hOX5
	 RWJyOy+YP0ZnbkuH2NDy8kwj87BgWfyYuXi4fYrWz0lgB9ucCLYc15OmppTKaWYBzN
	 6+zQLQi3y6TRR7s9iWxdxVTp2qRFsvSt6xkg7GfLqiQOXMqRT2IEWkGfKcAkw9Tays
	 MytqTXPXAl08g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 31/40] scsi: scsi_debug: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-32-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-32-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:12:10 +0000
Message-Id: <20260907031211.5883C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the scsi_debug driver to replace hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> The functions mk_sense_buffer() and mk_sense_info_tape() are modified to
> take a 16-bits sense code as argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D31

