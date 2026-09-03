Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9289833939D;
	Thu,  3 Sep 2026 03:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407720; cv=none; b=ecDeNqE93HVNkO1IkQ+tctUR5vqje8LpQGhs4aJdG8uZ/z8zCEqToShxfJKjSeHs8dC045XNmTQWTDszLBFdEwzJTj35njtI+uFGP+N4qBm+Y+ZiFW4N54/NZ+4DqbGmKvHrAvfANAjQalz4tVtd9tzA+Qxb4nlRasNQkmxh8qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407720; c=relaxed/simple;
	bh=cBZQV/riF2pkti1Fz/4Da2NB3RK1VpR1Gg3AyVqP9o4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nJcgcUpNiBIUBBHBdcpLFxAFaC2G38h9DMsJ4cvIQ9x3527AZszUGX6unp+gWnMmT1qXSvJCxhLdib5owK/GuBLSUY/Zliu/aOyClCFeQkHLOPgelO5bhFzjzLX09osmCdVs6Dm+u3IVJ8mTEG4rWbcp0SeYS+MxcgrrAF1/ndE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AojSz3pn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AojSz3pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E901F000E9;
	Thu,  3 Sep 2026 03:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407719;
	bh=cBZQV/riF2pkti1Fz/4Da2NB3RK1VpR1Gg3AyVqP9o4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AojSz3pn00KObJR6eX2OX89uZX4xfsL9kMVI6ZkZ+7RWId3svF2fsUgGjF2oZJABE
	 REbRc/UvZsUjBntGch9eRT7AsbboJtzhK6l2h4CqLVnUYp+gFgZ5o0OCtS1DKWMupQ
	 EW8b9EJRIh4NsxcWJsk6kVUey3+CO0x6dLp+c9H8ThIG98mnIE3KEvx/BdoiX0ANrG
	 LD7z+iXD8at7EcSGTL4/rC4Z64/YlaKc2z8dGsWCxvlg/G6f5Pd1BfidsbZbbjBq6q
	 7Nj1I4DvS3T0ZM7AGEUQUAF46Yle052nlRjLtV8mXg+stLNvu0oigN2+cSQSAURR6i
	 p2LDbfFkyJXmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 29/40] scsi: libiscsi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-30-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-30-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:55:18 +0000
Message-Id: <20260903035518.C0E901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor libiscsi to use scsi_set_sense() and replace all hard-coded
> additional sense codes and additional sense code qualifiers with the enum
> values defined in include/scsi/scsi_sense.h. This helps with code clarity
> as the sense codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D29

