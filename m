Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF6536B928;
	Fri,  4 Sep 2026 01:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485632; cv=none; b=hPpdIhAqVdh/zohWMwfwNhm8g5yLjqfJ2oCJWhouHWZCAj8wnkcC0p0yzbfVdc+g/7AUooiPAIansTIN7YeXgunsDgphW6GgGDAJODDP79BTbFQm/16sQqKSRDScaGCrf9MvhWf8ChMhUwnNhGiwJ3i10G/yFRlX6ppZjHxRPA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485632; c=relaxed/simple;
	bh=eUi4yXRtY23jLzF41UQd51CCboY44nwWzTaZhnJVO6k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JRK2DxUM8Md7bpqz19k+aVpzz0tOMldR6CYY2pxi8Igzyc9ZwA+EwPNCfJ+k2Jmk+vKnddxUCQhxwSvBsdUbG7B6y62VLt2xdPzmIWDQnwltBhLxRLRykIy7kEWx8eY2zHXbnip5wEqQd7putGeDvby8cNihJ4lKDAq0RJOFLYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjUVsKNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjUVsKNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1B71F00A3D;
	Fri,  4 Sep 2026 01:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485631;
	bh=eUi4yXRtY23jLzF41UQd51CCboY44nwWzTaZhnJVO6k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QjUVsKNqQxNNKiA6/YbbK9Oqxhb1PgG6yEKYk20Maj7KehhiadXGpJp4RV5Gy6O4s
	 O3xat2dPlIwZx8RHYZTymawzqKzXV4uSoO22clGmLfm5fA2aB7za+avm+au50dAVxT
	 YL/Oq1L4NNG3iBtytBwvW8CMNonfz0aLsqNp65yIq+4KwxkEAvJVB2FP1CaVqTFqEq
	 yFg+pri2kRCb5hwec3Euyy/LFY8KcrKXuub+0xrJm1OVPnykmgSK9F4hBI5wtAsdg0
	 wvPz1MJcR3GXreUM600i5HFZhV8+Jbht463/KbAPXKAy6EGD5325dhKO0LcM+NohNU
	 1NuE1JYOxmmlQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org
In-Reply-To: <20260904002644.157668-20-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:33:50 +0000
Message-Id: <20260904013351.1F1B71F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Modify the function tw_scsi_queue_lck() of the 3w-xxxx driver to use
> scsi_set_sense() and replace the hard-coded additional sense codes and
> additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D19

