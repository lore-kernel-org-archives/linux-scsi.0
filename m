Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65CD35F16C;
	Fri,  4 Sep 2026 02:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788489977; cv=none; b=Pkpd7a5ZAyWzUec5jOE8w4AgORRBjRysb3Mbh+j+lvBrm6+B8MgKQiuDFswgo2xoTPthMbC9qCfAeSxeviAaF2NxFvusMZsA5Ntp9jWsmAzKaUZmP9dPr7eifdTsp6YJfez5BSZRqMZDeYeChTW4E9ItEXeM1rvm3YUJEndEnUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788489977; c=relaxed/simple;
	bh=CNcaILsj7wGZidEWAUavpc5S5HKvJClNvWroSJ2d9HQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TZr8ptaRuHUI328EHnFB81x97Nk6jQydEHDYRWmq8yqqwarIG8dqYGYotKiJqAI8LDeu+fxQgnhxO3IUxM7gv2wr2SEHS26TFCCkt/cXHV/o7s2Etgi6OdZF+C1CqGUhjJKcEZkukQ6wFhzcbo+WCGHS8IJkXBw+q8/VnjJKbYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loboN4b0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loboN4b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34581F00A3D;
	Fri,  4 Sep 2026 02:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788489976;
	bh=CNcaILsj7wGZidEWAUavpc5S5HKvJClNvWroSJ2d9HQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=loboN4b06jMzkha1W6dTfizSEMjqkfXVHLKVff4P1tHA7P2yN28xStHK1oExpwpMS
	 TNO3KilhYHXc61XYz1vLLW7VugG5N4rGDdUKE5sUIjoNEAC0ikp8atljCLzCzzFfMH
	 oWCH2OrINr4A7Dli+gK24sxmGfZZyRv9WwXMcXTzG87bVpd3QeG+/SDKPxkCwpIKc/
	 7orKgcLLwQfL8f1gOWUITr3d9DnkrmxBkY8LcE/r8iM3U66JCOjRw2BvOmWEENSzFf
	 MUWOEwVXUoKpzPGYLSk6P/jb7ZHPkivbVThzx5uRFQDPxSlTx/dxhZiEIU5c8ZIfXB
	 VqkHqXKAtJhfA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 36/40] cdrom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260904002644.157668-37-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-37-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:46:15 +0000
Message-Id: <20260904024615.E34581F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the cdrom driver to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D36

