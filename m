Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859B4149C7B;
	Mon,  7 Sep 2026 02:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749691; cv=none; b=Ee5EFtU4jrMIpwxV4RCJzBNA/0bI6vwAo00rcg7gRwA7JGQlxVrwoqjIA3z8eBLKjtMr/yvhAiZDigpl+s6TCdnpfATKduSjqmCtkAVKiIxvdsHXjJJ4vA9Sfa2eG/R3XtH6aDjBlFv9RufQgbZOgJoanfiNrRHJDx/uLnKRplw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749691; c=relaxed/simple;
	bh=YTfMJ27w3tmGiNvP50RiTU7KAq17EuMjy+S0tqETMUE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dIQMtLARD0CXpmnH47sRaHbuilnz8E0ywPCOo47toH2pWSJ+5XWApXph+j6qZSlCnXfaAEP+nrlch8a/cqoDZPHy6TFnPLnpQfqyCYMbTeeiSJwRL7Xvp4PosqjSnrwX9XL/N5KQ1VfqQV0ZZKz40lXt9tD2MpbC12Gq8LO8Srs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irhR7+pD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irhR7+pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983E91F00A3A;
	Mon,  7 Sep 2026 02:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749690;
	bh=YTfMJ27w3tmGiNvP50RiTU7KAq17EuMjy+S0tqETMUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=irhR7+pDaUbX+oPPMNWw+59rRzYhJI+7pfXvM167GaaQdKOe2exvVZU+sG139jc2V
	 Q6+h++kmesaNFLhCGjeih4jfmFk/lpMXiuGhd3ohUC3x9RAnlp8GJZ390yjWKv4SU+
	 D2iKlDyvw2u6tJadtcmttdZObU4UZzQyQjmBLkrgXNccB44nHh/iEdJ8FXLYVjfCGn
	 PNQbwAR8i9UeFM1mGTd2TOfDX0UJq/L1jgCjrOt1LAB2rhJzNik+7iFR4+FpHaKz9J
	 QSrP2yYLHmcznK61Cfx3Ci6Om71bx3fJeBhiSmUww+3Y1tnindpvlh7vVpCKKqU1LA
	 L73rLoGIGve8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/40] scsi: sr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260907024343.1046387-10-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:54:49 +0000
Message-Id: <20260907025449.983E91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI CDROM driver to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D9

