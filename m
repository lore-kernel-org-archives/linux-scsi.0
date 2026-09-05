Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AA02D6E72;
	Sat,  5 Sep 2026 03:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579242; cv=none; b=Fnd/jOCy7qXs1Zm7FSiyMAEqTh54wYKwiSBerci8ZUPzc7lYJZYOvXIPEVqErPwpT/Hpun1EfSvRVZ8fPCqxFJsmsvbQMrYYiZeJKgqXsocb2qs/kFL6eD+F2QwYakb21A/X4jMAm421SA38834OjRa+QkGprRzovx604TB7TvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579242; c=relaxed/simple;
	bh=sNoWWajY4VjWRgm2EVWAR66rb17/F4RvwNwHw2jnKis=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TSqHEa4otHH3Tw5J+3XFBI9XQZzkA6x4l6BvomAPcOqevIAODyLg6os+tMtryVpoORguDB+GyTXd/yfOjy+xeLCDKG4HmHOmlWaoIxW8aLFWVaQZCkTR3+UB0ubMR9Sd+Jhf2gtjoEKtpUbbDs2GDcTiUYlUy7n1WDIygDR4QJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDynzYJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDynzYJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37371F00A3D;
	Sat,  5 Sep 2026 03:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579241;
	bh=sNoWWajY4VjWRgm2EVWAR66rb17/F4RvwNwHw2jnKis=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HDynzYJXy0LuzVLkvUhlK/SHdnjEyAmg+jG5MPWyZB8JxusjBNNtGm5lxq+L7y69e
	 RXCHGNBexmtwEy5hOCmUEeZXTZJF0EkW5AcyZWyBIEryVllCYt1JkClqFVs/aPLGG3
	 BXP/vTaDafVHVQKIlLgiKzJckIOeV7JP6OCcsyeTApoU5srXs3M16Y8qQ0oNUArRBY
	 sxfgVSNGVIcQgfxOOHbY1XiKpLWhfvSUFXfg9KrPK9zRVkq7rKxg/5ZOcsS3hphn2W
	 lWMiggZhxf73KTFBfNFd775BPa+vnuG4XXG36thiz6cWiKxt8j5rVovOU51of1xlAe
	 EI88cbUQtmnVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 20/40] scsi: leapraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260905032224.509860-21-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:34:00 +0000
Message-Id: <20260905033400.B37371F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the leapraid driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> With this change, the locally defined macros for ASC and ASCQ values are
> deleted.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D20

