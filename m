Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452AC330668;
	Sat,  5 Sep 2026 03:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579013; cv=none; b=bY8Z0x5+2RjQlFWHvMj/p1rilkjf5ixmr7z7SEgFZXEYX8ge47kg+6wChk0WpljkYHp8Th0dAxj52A3Aa7+kvDBjhJeNaLwEukjBRL6Wy9YswtruMou+/lLIlZGMaKWoN24f/9XFKHURhu0+nmqoopy+F3Ouh00zEOOZ8SvulzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579013; c=relaxed/simple;
	bh=4kWWwbLFgLSsGhJReylR6dTTRGmfAPvtMsFbkF/0kaY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AsO0SAyJdQdT0fxKCQLrdtna97vsgN2ZSaDSC9MLLATrSjX+tIHeNGVD+EFVN0wzdZVg/AHIGD4wONHITG3vOaaPXOTGdDKIjfrsSoSkoeIZhdjc3wcleEm3o6CNE1muvc+cT7kETxEnx/gCOCRf0hopiNMdnyl/OUyDUSNE5nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BvZiMx55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvZiMx55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8591F00A3D;
	Sat,  5 Sep 2026 03:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579011;
	bh=4kWWwbLFgLSsGhJReylR6dTTRGmfAPvtMsFbkF/0kaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BvZiMx55j6ywC8dUcf2CE1gNV1SmpxrimUjoxOI9It7V9UuulKiVzo5bhyspamMLK
	 AJxdeku0h+w8+/ttPBtkqDdItKSVxScUa/QP62x7Keg/nUzwvxErg34F+UYu0CuBPC
	 ItMqXgzg8aJWojbdzZtD5ZFpddXiZH/2I4brN+0zQ54+L0mS6Pyk0XMC8VPM+Uq2eq
	 UKruwrDaPRrvRbY0YnpjGMoY/ohd1Jw1ATmDgv0mjY1qqtWQyoPoQNBqKSflwgiGfZ
	 Sl3opL+zBkz4tTMY8JhttbF46h3SiY8i3joJnoib5hTW5gFLldt1E2UQ7j4qNfkpuV
	 hmg0Sb/M8iY5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260905032224.509860-20-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:30:10 +0000
Message-Id: <20260905033010.BC8591F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D19

