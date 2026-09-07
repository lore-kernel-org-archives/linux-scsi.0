Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72D17478;
	Mon,  7 Sep 2026 03:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750589; cv=none; b=P055bthMsChI2gz3MnNQbCZMHUDcIUw1BSAHnmPsx2hwa2TMl0k6Jvomaxeg9QvrLXhyf1uQydg90laSt33zBxxmv2dyGydZxr8XwDunjR3WrB9i63Cw3WjTLJftEY87sTNqe+mLhcP56mF/y4/2sCRZjl5gFFVSsO/SUzCstRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750589; c=relaxed/simple;
	bh=9R4Y+NriZFzABtWrtq1bUfro/LPytUS66pygV1ziJqQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y84NHeta5FlKet0tl+IJv4/7EXClmkhjgf9k93OHwY0EVqaOiAzgmYZqcZH55VTajG/AMadxUV3KUBiD/br86+bHfL5/51SKH3/6/iP5xrojxAvIBlCvkIAnOQ1E7EXmgZr660MdXzf+tEwvuv3ySUqFO0IL6yfeE9Qn26z5m1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTXiwd8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTXiwd8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E331F00A3A;
	Mon,  7 Sep 2026 03:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750588;
	bh=9R4Y+NriZFzABtWrtq1bUfro/LPytUS66pygV1ziJqQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aTXiwd8OruZMZXXwa/BligQyz4Xvv/1E0aOs1nnWhSpDF1XIfQCJSNSGBbXiGzqI4
	 1ArLrC3A4AMt1dDyc5ljZ7T+LJzpK8forZOQ5wvX2C5gyOVU1thojodOTaZlbaa7B2
	 2SvSeeH8hoWR1kQZTsi6HAmZcGPZnlIcmsuQuOpLpOts+uhJHFCTVlyBqeKKE/zjaB
	 beW4Xt4567PymV4b+BLJFyg3vOM2tjQVcehon+TGLTUpDwPruUANKsu3SqkW8zVvvo
	 21ffWDKCsCZJTuNY8wkR7YenVgeLesxnm7gnYYwHvmLogRWAvAant/mwy1UDUcKj9J
	 yKza8ghIBO6kg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 38/40] s390: scsi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260907024343.1046387-39-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-39-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:09:47 +0000
Message-Id: <20260907030947.E6E331F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D38

