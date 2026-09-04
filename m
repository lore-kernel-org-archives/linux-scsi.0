Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7056E20E6E2;
	Fri,  4 Sep 2026 01:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484192; cv=none; b=Iqlm48ej2Cmm6yJ74neRm+KRob0bTp+bF+H718TXzGJCrNRnxlZ7elsAH2xIrD0GhgNTcL2ic//HuRkq5QhgUJoGS7LUsCTUkoBMF4p7eFC9p4D7LST8gh1ZRNE7Re3LPxnbypfUgdeAZuzZK/k+UMh+SFauBNsDDAMlRlyU0hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484192; c=relaxed/simple;
	bh=x20hUqbZYs1aTgJVaZGLIS8AOihhHwpTnr3xJZxmBC8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RRKYECEhCanCV5qLi4frBGoYUVwUGVl/HACzzb8inz+J8jXmBWeob357MgBEdn50U7c+eEnFkyNYi8sXcUEUpv6tzlpGfMfzyVKwvdvfoA+kjIl4FGIxgqORKjtKXt1JmdsKtjCx53pAN8YgEgOb7YFUlAn2IAUUyRWhQSXeQ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGPhIhBY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGPhIhBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8431F000E9;
	Fri,  4 Sep 2026 01:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788484191;
	bh=x20hUqbZYs1aTgJVaZGLIS8AOihhHwpTnr3xJZxmBC8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KGPhIhBYVZNykBs3CvUDCl+hHl1cUJM+lfEv7RJAxS7bAQNUjswQNApO2PkBwE+QK
	 sLa/t+TU3qMO79i1Jj4BIYH14XixsOU8kTkW1l/ZyXCgAvqAizSc6Sk/h3aI61N2Ye
	 gjQdWoE/lZQ2Ku0TwTPNNUnfrzJOnOCK/ev8760Z2dIvoId8zKEllnRPTa0tfmXV6r
	 HtuDw8CRD1qwsQvL484CFSzkf4M9+4qVNJsPXsuI7xLHBPPVD800OJZnz5zLS4bY8j
	 6LASgxMwjCNQNGWXCrMFzB4fKf+eh/Qxq0+EhG/KTXkIfLa1TvEoim8CrQS1xyV93E
	 fREqdwc2h/Bxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/40] scsi: ch: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260904002644.157668-12-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:09:50 +0000
Message-Id: <20260904010950.AC8431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI media changer driver to use the 16-bits sense_code field
> of struct scsi_sense_hdr and struct scsi_failure and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D11

