Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCFE2BEC3F;
	Thu,  3 Sep 2026 03:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407974; cv=none; b=CzoG8AoG8vLdqmQHyb6JZ6PGXAjsXBKrvA2tKtbMNAWiuSVgdoJdFqN+G9w4ypVYMPpQxNOsbWR1WTpS/2dcDFmuuQz+IaNCVb/HPBoAdcn7cVZJPJUsLQChWcnR1VoQoeRI/DL2NoTomdhA4DWhCCCSvr7wUzz8OUVRicKIO1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407974; c=relaxed/simple;
	bh=FtD45jQUyJHiP9iJYgR8ucaxuxMX18F34ZdLu24uzuw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dgcOKb+k/KvC/EUwalOoLR/4fbXLeRZQKMBlHV2IBGDdbtjHmdR7BtTWbnYbZGhsSqcAFqC31t3oJrf5A0+4N4RPwIVBr6K/k6Fv3VgOt7SCOiMpFycU6LULi2yfJS7INGPwU3h7KfissDRcE+TD8Kwg6F1OZNVzoQREhoEdpp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWfWwKhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWfWwKhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08871F000E9;
	Thu,  3 Sep 2026 03:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407973;
	bh=FtD45jQUyJHiP9iJYgR8ucaxuxMX18F34ZdLu24uzuw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fWfWwKhNw086nhk8OFMOPaLG6/rXMeMR+HWJPpVckZ3xvuV58m2M2OpDMGBP8FnG6
	 yKl9dr7f0JFRmYAttLTI2LwI/IvAjs6gQ19nJDqgpe2T+MYHmmwvsMSwapEH2d38FH
	 3DOKbp4O5yTLDXjxrroTezdKTgnfrEjWsiSS2IdV6kdYfOLGV+q6hGVkTqEy/SReIG
	 LS/ggBh+suLe5pbo5EuHXH06hpPw9MgtGpZccRLdDTyt6sYxGJsTig10oiyAeV3f5t
	 xqRD61atEQ6WgFjUVqa1G4vzMliSxyHEdTLL8LYL5MyN777NDrJPrHg2oLkUjpcTIK
	 p167dCmPcko+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 27/40] scsi: stex: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260903034201.112211-28-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:59:31 +0000
Message-Id: <20260903035932.F08871F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the stex driver to use scsi_set_sense() and replace all
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D27

