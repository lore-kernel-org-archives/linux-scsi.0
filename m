Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23C73A984F;
	Tue,  8 Sep 2026 09:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860274; cv=none; b=KYHKMtANCpqimT2v/4eci6EOUgfYS5VPs1kx5q7n8KjTwJpvs20CCAXOEVuElnwO+XWRti3cKyDnk6ZKvaPeV277LmLFtMrhEdvguiC5/YyMExEUKuzTKLvmrLhVEsMbcXLK9Ze0uC5Hfuj3C+qTNoSHtXs2BZQWGQFk2uPt7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860274; c=relaxed/simple;
	bh=SgzIsFvjIVzPniU9O2hDfyKMvkwy4Az4kh9RMgTXcLU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F5BDlb+EIJvFCOw9WNjEBAmVVIQ1VG10a+BAydfskYOnJ9C0kdZQ+fEw4y441cBfe5nV1EjVSMe4N0oCUZeATAONCSrf+xnYDXhPMpI99FCNQKlUEh559r9OBoBloSfs9WxPbLdd/hTiOq8R9t24GBIJUGfRNeBbu3p84zniRvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVJTYnq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVJTYnq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86751F00A3A;
	Tue,  8 Sep 2026 09:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860273;
	bh=SgzIsFvjIVzPniU9O2hDfyKMvkwy4Az4kh9RMgTXcLU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oVJTYnq5TO8aH5JVglE0XcOrBkU/cDOKXGQaDg3tPHKJAVgF0bm4FqBYXR6Rz3/HA
	 Mg2jeWGr7BXYgseS2uynlzgZ5weNqkyqEz1i+P+cwIWbFSFXQi15K3wwy7FXQkdziq
	 DsaSPrSwxdNOA5Q3d6TCPXjerAbbj0cx8HJZt0Mtr+akTSwuJGtSBfPFpCNmvWLNwr
	 ky1b80Te6uD9ZC7ZJI5xUDlUnj4Lzxn1qzwAx74uPprFpbWz0voU5Ts0FoYKKiEfaH
	 y0n0dxA9ka5n9dPlA/Hv44AwOOdgTq/MFKxVWdBUyKiH1xcDjp3MOdQghulPygoX4W
	 34ZTtLuIJQ60g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 15/40] scsi: device_handlers: emc: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, cassel@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-16-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:37:52 +0000
Message-Id: <20260908093752.B86751F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the EMC SCSI device handler driver to use the 16-bits sense_code
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D15

