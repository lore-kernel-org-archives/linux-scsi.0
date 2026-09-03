Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C1B2248BE;
	Thu,  3 Sep 2026 03:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407421; cv=none; b=D+Vbc7Vu50e93PeTT5QAiOQB5jVU42xL9vbRbxobEu9eK97i7ezpo+di6YajU+GtL1jvVFZlu6MYGynkU7agdkoREPjyZ29WioCCQWRX5a48PklIgNozMcFvaoEGd0qiqQsPtGka9G+mNsegwMwT/ZYxoxWH/bWEzJryPt5Tp5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407421; c=relaxed/simple;
	bh=bzpSeqIKxhutPbH+xXYLJxzB5sgRLVqUOubqSmxKqu4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WUmKscnhCQ6w9lSPry929ZDgr7S2q91qq3pHHAYFIy7X5w/NZkgEBc7OxwRworh8EDGNg65cPaOMj8PDHHr5x7uLvl4SYMXjZPioJ+qV0fnP504He6W6geBnq1ZAMumBoO79gDDdmINhJBjIKCZeWxRMeFWX+uxSwKQ3a8vJF4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHrCYY5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHrCYY5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585D01F000E9;
	Thu,  3 Sep 2026 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407419;
	bh=bzpSeqIKxhutPbH+xXYLJxzB5sgRLVqUOubqSmxKqu4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CHrCYY5oq0adGaR3TEz0tc19SqICD/tZPKojl2WHYOfFSbGIkxUa5MvTuWtRJItLx
	 HmwYc9xUo5PAMVhcTpYFLZdOelkPj6BH7uwg1PThKWgU0JY5lkYXDqtefW+s1d7kZU
	 s3zGMhj7D0KGeo33SzRUZ3w+ATc02SekDOR7TTvhCFJxMg0XJPzRaXMbuuMdOfhN5t
	 fPhIHLH8qp7ip6kraOBEet9vvhaNfA2FKdBFlivVKHJ513zv9ppPDXEe4HorMBauzY
	 DMGvzNZEkSJznO2ACL/P2d6suLI3ryefxf5SQB4IwUvhK89CJwZ3xiTVg/CHELiuN4
	 3jTpeEougybFw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/40] scsi: ch: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260903034201.112211-12-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:50:19 +0000
Message-Id: <20260903035019.585D01F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D11

