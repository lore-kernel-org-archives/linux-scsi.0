Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C833612EF;
	Thu,  3 Sep 2026 04:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408409; cv=none; b=nYhLdVGngpcIdCeRKAILhql4WsNYNoDPZOHNZeXVynZnOw2IqXRAVU+z3rpA1Y4GUPkR5KAiJ3R0VIybGQuXZOGCqnWPeFCuvNZUtifmUxQYIZGolMum5NVExAkIDPz1TVKP+LhY0IbmvvV/KcLHuKYJkyvSNaC3uR2/egYCjxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408409; c=relaxed/simple;
	bh=JuE3nw4+XfqSWC4iyrrGr5XAE5fBkJ2KmUtqh/JKh5A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E31RiStdsWI8Dt5sQ6WWgSY8mJehf9DSCzYT6IACOvpPcrcDWU6CdI8bEVo8QlWidgoFiIgN9BxgQBb1F3TM2ombCImr6Z+NhIUrESRZl1ncpDiKoKdTlNXbaRP5CkIu6F6VZn+o2WDhMnzN169rH9TEhdyy90SNCj2j2UgZ2Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAgg/je3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAgg/je3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF3B1F00A3D;
	Thu,  3 Sep 2026 04:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408408;
	bh=JuE3nw4+XfqSWC4iyrrGr5XAE5fBkJ2KmUtqh/JKh5A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GAgg/je3/5K6J4iw8+ZL2SiM0V4c3QK+5xCO52+X0Kwi61ei6FMs+f0MSlU+TUGrN
	 CO4fFbY61JgUKP7u1lOI+nSfEFpcRS56HrQxg3lpy91mAgjxfmosVGPV938NGIqQSl
	 gvC5rJOpb5KuptXvRUaUXjE+DqyYBfceC8y01my9/bFssI6gYj40GpKnpax7gbFxkB
	 FdaG63e9l25eKraLvSPmKKQ8fk367IfcsGCNb7faoq161AD0j4rWufFHt54ynuyxJh
	 qVBspPhScSoVOpqjsREkiLpvZ3y/qG+tvxo5A3LDFbEYKiQOmsAEW+Qamopx9BuixG
	 4VkTYhWzywXHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 37/40] ata: libata: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-38-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-38-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:06:47 +0000
Message-Id: <20260903040648.0FF3B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor libata core code to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D37

