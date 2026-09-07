Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9981539733E;
	Mon,  7 Sep 2026 03:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750174; cv=none; b=Ge+tWCDv0AwcjUQMlAr1E9nTRBpokkQ4Obx/xyGZ89fH5tDm2TYOnU5TagRaQjRf3/nEMCclIzaiQ0ijvHtbT18b/+ALpTbwUW4gDY6rUSbZg79QwHXeFKRy6I7GkSHU1bQi40128SOsHMVhsBwX9UAh2baQ9TOcar6EtMXFed0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750174; c=relaxed/simple;
	bh=zWoiLp95CgrT/UziNpt7EJcTbsYMec8Y86YafDQZBK0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dwQvxBLCTcZxDgEHHMAuRv+Xb3k302wa7cXaSBJa4C5BnGszvj+RDBrCGAfUdLUADRU5LQ21xbi91b/L4H3Fs+ZI5Y5MOdL9SKq/GPoGReBodsO3xWrQz4QeY0Ic9lLtNZbPnPerYowEPiENZg02UkbASIyCdAJdVF7zOtnMC6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9f8SJz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9f8SJz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19F51F00A3A;
	Mon,  7 Sep 2026 03:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750173;
	bh=iJ54KK5rTFe/VEHanazTdHpHhRch+QQ/q7NPn2kaL6k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O9f8SJz5tcEUK7WikiCUJH3yvP4GjdJ+fuhICxlUvR8F99rRk6W6cdVllgQ8zDp2d
	 jxe2z8jF4B2KbLZn47zUVIecfMxQ9WMD3MMaydnLtjH4+r/ks7rzsPRc+0ogJoVq/U
	 Hu+jaae79U7wJ85DoZYoornjiqezAC1cdB3gM4+tEzG3EFaq3nHoK7a+P7tiD0uVqI
	 liKZVKOmiFVR0xNTqWyoJQJPPDyJv/zY72uguyyNkcolgjgn7EE/RndCxKPduGv3bJ
	 GIwQKIXQfg6eawKhYyrWBo4TGUfViEO+1nFRz+5GylYrlJblTCM/QZ9r+A9NXx7GNV
	 ESC0mEzZ6wWng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 40/40] scsi: remove scsi_build_sense() and
 scsi_build_sense_buffer()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260907024343.1046387-41-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-41-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:02:52 +0000
Message-Id: <20260907030252.B19F51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now that all code has been converted to use 16-bits sense codes and to
> initialize sense with scsi_set_sense() and scsi_set_sense_buffer(), remove
> the inline definitions of these new functions, change scsi_build_sense()
> and scsi_build_sense_buffer() to use a single 16-bits sense code as
> argument (instead of separate arguments for the ASC and ASCQ), and
> rename them to scsi_set_sense()  and scsi_set_sense_buffer().
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D40

