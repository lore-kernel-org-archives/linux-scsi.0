Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D01347536;
	Thu,  3 Sep 2026 03:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407567; cv=none; b=up1xlN/bQ8mmP+ECCorVG1pTZUo+nt+Kd7dil3izxbM5Q0RU49Ewola+o5FTWIf5r4JIW3IXa6t1HTEuKbCB6ge6VaDkOn84XqVxg4oCEQxpllTitLCxyHKWf2lvPboZs6cxRyAEzC+gl8eOhWe6vLaILjvty1OsAygMOt/khIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407567; c=relaxed/simple;
	bh=CUmEzVIec9fLCNSdDyHkBov1ES/fjL6Hx93K+XL7wN8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WQshePXoeWBxbLtQXB8s3jqUNguVP3kaCEsJJN8tZJKzRVU4BUOCWJC/XGd43RWN2HiuachS3/Pmlhjc5Rr/XSksP2qMOCz1zrJ73FfO07Tk+0Bp0HtGmHWhOP5G0T1X/7ZUrdeMFs5Pbt2AF86a/C/LqI5vMoHMJj9Zacb+biA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sd13sYED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sd13sYED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F5C1F000E9;
	Thu,  3 Sep 2026 03:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407564;
	bh=CUmEzVIec9fLCNSdDyHkBov1ES/fjL6Hx93K+XL7wN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sd13sYEDBsD4eC7ynuBqdEKqZ0OVRCqDs/AhOfKKC3tnJGzpEWohMg+jcQBbS2hOR
	 oV5bRByuYhrcXeDWtc9jLQbRob9T0SSbY0yL+he+/uPn64h9TI6rPRITeNrjAYVO9p
	 cXaUNA07ox0YwG5DlF0I2XVSui2aT6I+x+AgSKYaKLXlAneYP0seF/UC4+yxG1rcWK
	 r4Hugb9kbDUCJUMOmKsPnPGXBnTIy5TolWvpWJPsxO6MzZOu6p5NoRrlgy1PTsrCml
	 VlXGguIVwwl/iioAZr1QIXwyjmHkDYyy+ul/maLrvmwbrmrNJV49bsLtdiZpbF7g5w
	 DyBCUB6Dj566Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/40] scsi: device_handlers: alua: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260903034201.112211-17-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:52:43 +0000
Message-Id: <20260903035243.92F5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI ALUA devie handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and replace all hard-coded additional sense
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
11-1-dlemoal@kernel.org?part=3D16

