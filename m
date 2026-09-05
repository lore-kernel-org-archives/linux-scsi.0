Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6AA2BF3F3;
	Sat,  5 Sep 2026 03:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579838; cv=none; b=WvpZ+d3VIA2B3BRjbVtN4q9Cui4U7a64aoM3F02t39w9erKmhvRBq8CUBxibR1E3xRBNdFmFT2qJiABBAnqaMdBmfgD/XuBX8G0Lc7DJ3HtQHjrgK41EsCf8JKoGB7/K8t0NGG9aOsw9cQ7R9Urms2cd36y9z7VpJ1JjVtLy5jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579838; c=relaxed/simple;
	bh=o7whB5g+1F2foiAftcf+bghUQki81gGZF8o5xqB/m5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TySULwhZQATxi7fKH77J515XrGWEj3ZJQqWsE/7OpJkusGSZSdUX0IUOcAa8mI+pbk8aWQ5Nk8Le3x3G4oUNTyuRmE0T9aeBsh1SZ5UZD+ReH/hez6jI8ocdAhHO4IfC7MK9A3LtUURDX1tNltqZP2y3esSKQy43U53fxAPIxag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oRaGBOcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oRaGBOcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6651F00A3D;
	Sat,  5 Sep 2026 03:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579837;
	bh=o7whB5g+1F2foiAftcf+bghUQki81gGZF8o5xqB/m5I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oRaGBOcqK/POIf+x8pwnogdovyObD/GrdOuZFJAeKyCpwUSkzGBgW3OEGVW6WTTr5
	 6RUYezbxnG9K1r1/ccGbtl5psmj0dGU0P+NFA6Hi7zB7giCNtNtgSNxBjwRMmKRoxR
	 CTBK26TtKjDbP3rV3wOIWJr8nLXZIMjMBz80sMZZ/rEjfPoLA32u0x85WBj5GzkEpK
	 KtUpxY6g2iISEaRivXUBZ4WgqYGotnf42LZGUUGTua7o6ZUb6Wqnvx4bnk7rk41CnS
	 cYQPmvo0W+UScTofTqdQd7NG4w2jfTMjJXlPqq5t7ksmytFC++2ybIVHSgaTqc12o0
	 XBpJrV1PIBaQA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 31/40] scsi: scsi_debug: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260905032224.509860-32-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-32-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:43:56 +0000
Message-Id: <20260905034356.7B6651F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the scsi_debug driver to replace hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> The functions mk_sense_buffer() and mk_sense_info_tape() are modified to
> take a 16-bits sense code as argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D31

