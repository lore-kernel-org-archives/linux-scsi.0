Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8872D0C89;
	Mon,  7 Sep 2026 02:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749880; cv=none; b=NuN4PLRCx4HPBsKJ00lMz2wv85YOEvGSyEgNL38ntHjdlnzHp69kv5XR0kaLdrMy+FNkje7JRszkGmbY6UCcN/Qtbn355BjGlrJ9zJrU9Z0YdDqGQ62P1r4r24VE91iTNX4wocBkXcZK2cfm+OndpmVs0X2h+ZaoFZOcQbN95G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749880; c=relaxed/simple;
	bh=kkmmUixG3ERJBoPVUD/+7S2/QaOfrQ88sWjNHMSNiDc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i6Nj5fUlvMWyPxinqkYLpc8jpCuxovmdSWBFcTziQlOusY0+LD5wgzl+QjLeR0xYjwcZ5/STBMOD9zgk9G8KrKSNuHRiorEHJl7RydI7fLFBaXl92o1ZkwoZduR6sFjyGceZhiRsIy28OnlCUrqkFzyDf4EAl7jFPLO6AH1dAtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcOUt1gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcOUt1gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04AE1F00A3A;
	Mon,  7 Sep 2026 02:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749879;
	bh=kkmmUixG3ERJBoPVUD/+7S2/QaOfrQ88sWjNHMSNiDc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TcOUt1ghbc5Mx6tuwX7/lfjEmD1iSwOmBkgVsH52+WzzqusUIkCkUxdF3x1k5QVRv
	 LPg6Hy/1gcLYcwoZp/oS4lMgwCmRjrk8aGT4k5fbw2xMXUBbhsw07lALBd3AJpy2pT
	 XSNj0z9g9ulVmbo3A3kKFYe39sZP1rEf7O+KVUHbaZXfvGu1Cybv1etcq8Cssc9LUs
	 1Tsqkz2e8ZWnJ/z6UjniU7PzDCrQqmjvsaQsO7E4zdI0+09NP3A7ydGbj6XXlsYowX
	 pCUQlfgr12ijWlAUcbepBjA9JtvyiFZepvLWaokmWYZnr5i2nE0BWo5l9fVx3/FEIY
	 YS5RwgF6LbGfA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/40] scsi: st: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-13-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:57:58 +0000
Message-Id: <20260907025758.F04AE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI tape driver to use the 16-bits sense_code field of
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
387-1-dlemoal@kernel.org?part=3D12

