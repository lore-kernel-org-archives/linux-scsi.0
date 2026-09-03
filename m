Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9427628D8D0;
	Thu,  3 Sep 2026 03:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407463; cv=none; b=oy60VWomM3plLhyS6I5mhTqi5AGFmuxPUEQpgfxCY365Lo1iSde+qoJvPumH1ylkUEd5fPs0JteYqpVNyz4H74WYCSL+Tzjd4VBltL7zBCSZcgjMEqgSGXQ7HkgLk2p/xuM1n6kdjt+jbxeQiYrKadtg8nQrF++NjRxn3auwmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407463; c=relaxed/simple;
	bh=kALreJCQJOxukTXhsfsqto/6xt2o/kjeCMmOLZl76IM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oPKsGB3LLINCRGGJi28+a25bNw1b5mG/Xettq0i+NXfeBGM0HZxszW0pvEaidpXf2hD+eBcd2qDOyRDwPxsxJRT7u6uqcsMt6bGF/moHlNTZy0HSaruJI0IxJKnrgYCEKxstKOAL/6mxKhZ6TaiaNApET1F21xOXtSzWcUENa4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hn5DrXz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hn5DrXz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610131F000E9;
	Thu,  3 Sep 2026 03:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407461;
	bh=kALreJCQJOxukTXhsfsqto/6xt2o/kjeCMmOLZl76IM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hn5DrXz6GYM1A0cmM6+mbD7etlIcWylblp1EL+XY0+pUgufrxgrBwpArVtbsq4rXh
	 2shU7Vhnsm7bPmeQYy3E7057FtmYvqF1P3wxgfQuSzIYdvGy46sETFNQDq80auqmo0
	 3/MENO5EitB3LBXoMFOvkRcmLH+dprHJo57l8OumuMnjNt33w6HQC5zv0DVNmv8BWG
	 SQvvGXnGYokqABXN+fsDumkygn4AWfOLtXS9Wq6kXmxpJPiNIqlReov4eeEOhcj1y8
	 IoD+D82YdJKnK0HFDi/WMO944rhal1ruCj9Nxx97ijEruN7gEpR75GC3nd6ISvaXbm
	 Q9H/9YPgIXWQQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/40] scsi: ses: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-11-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:51:00 +0000
Message-Id: <20260903035101.610131F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D10

