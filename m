Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977EC1F4634;
	Sat,  5 Sep 2026 03:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579126; cv=none; b=fmtdLn+QZjRrAyVJ4VzsX4vfqghLIpwRGPNrjjn++V+unroP5mGIpuHGJYWvQ++jEHWMbsZags4R+2KsQ4Eavxt2y3cuvtebvYYDS84UViJfQDXdFpZqw/Wmo8wS3HsX0lGcczh/uTGziXF+wB2+U3Kz+Zg3WgjK2WDZux73ihY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579126; c=relaxed/simple;
	bh=9ujlCOZ7phkM7SKdiUtcSWfMxhugWPLVPVcFtYuHeyI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DVmq2BM2NBVOM56cM0qk2M3YjJUZlYkZS6q1AwmrAcJZPtcseiwQaYkdgoy37LvQCwNpaBvCIBjSs77jNDmRnI9Za2liZ5dJdZmNr4Ki4y8rSyw2mHeWlHjv59DYhODOawGwNi3t8GGteEGqyzMQCnMWvAg7rUg91KN+YYb5bV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHEZevhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHEZevhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9291F00A3D;
	Sat,  5 Sep 2026 03:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579125;
	bh=9ujlCOZ7phkM7SKdiUtcSWfMxhugWPLVPVcFtYuHeyI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aHEZevhP/PPdVcskzwhT/zTyF3Zlq6uB8jwMNMelHZc7o12vlEGcVavu2rwqN7Vn9
	 JjR9WRDC1oxt2wuq3I/61tEkzvZXYzEt4bG9zrhkXee56pDVCXe7buV5u35VAmF1eg
	 Yuwiznh00/jAvmi5n6h3z5DKn00x6ffZrOdX7OLUgbUhy2MzNYnkCbquG3L0Pc0M5s
	 o/VOOUYP+eL1vfl6PKcjFJTjYBkPA3ds6tBZ6SkSdGnLpzyfvGC11eOKxG2RtQ38P2
	 kDaFgVn96+fjanD4QADVwWOpdd9ZOe3cHzNLstVxGCLDCqKVuTWVJqXWx4LkHW7PI0
	 pWp/R7463xMDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 10/40] scsi: ses: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260905032224.509860-11-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:32:03 +0000
Message-Id: <20260905033204.9C9291F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI stroage enclosure driver to use the 16-bits sense_code
> field of struct scsi_failure and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D10

