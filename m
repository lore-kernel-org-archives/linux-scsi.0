Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D663399360;
	Mon, 20 Jul 2026 10:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784543215; cv=pass; b=okorcFt4Liym8vuxOYnzcfZ9duFuFy8i7E2spWPiltzpgFMdh39JdGyk/dud1xdEryzx22LpQ3iSs8EAVQ+HCFv7zRVJ7iPGUmirumMuCXRPvkp0DTJfeWNjZfnWHYgUxtC1sU/OuO9vXzZ9s1tOWzluYZN8r/1CMZioltUb0fY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784543215; c=relaxed/simple;
	bh=D6uN2sWReIprCfPPkylHnLQRLXjI+28a/AQsOF1V7XU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LUGXO143qBdVj4GePWn2Cgg92uB+KTQRE79j7A/bY+suIP9n5SWQy5o1XKpsK2FPzVQK9MRXJGQAdfUCVutvzb9Q0if8skvBVoXLB71M1l5pgwIVV4TSKXsP/6HnL+iPsuTXqkoYgZv5tCCIo+j0Divh4IF8t6wE3gpDOysvrXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=YY9v27ku; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=17/SkrGM; arc=pass smtp.client-ip=85.215.255.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="YY9v27ku";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="17/SkrGM"
ARC-Seal: i=1; a=rsa-sha256; t=1784543021; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=jPmWuP4LOLI53HEGtVG79CX6uGt7/AiXUwix/ct+y36PzWUqDkDOwqHgTV53DomV+F
    XQMIYpkbybk2+uVpXTBXn5AIVD0f00GxtU/BMWEYIjZXdqKwm2Vol7wCqTrzF27Ao9hr
    NYvHV1IpxKiiiPWSbGPyD50rQCWaqQdPWNLpRD0vLMx/VfNdHJd3p6MCOaRrnO74XR0T
    YI+KseGg/c3oEdCUL4KnY+RjIBMkx2RZLzBYN7p41CwX4+ngww80tSS2TXsVDCR5cM7m
    /c/kiv1iuxZsYgGlxIHTl0j9mdbwxeCAdHCpZQCsJyNrkDL2v1W5IDotXaUpwMZRSA5J
    DHiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1784543021;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=D6uN2sWReIprCfPPkylHnLQRLXjI+28a/AQsOF1V7XU=;
    b=Sq2CXgqulxACI0/GO+Itv6hVFBG8s7X/tCdjDhnb1EyQ78byt6LwXS72Ng+jLoN9nV
    JX8iIiz3NP3cMOYWTgJUWhkMGPjMA4qn2OmPbLC8GuzXBCkAth4renlTxj0RF6xEIh95
    ILhuD9sS5cT74VfdsL6HY43g6UKRGthJjc0qHOJGvaqge0B+zJ8MkGlJmMLHTGJpJV9Y
    sj9VRSQHqugvc9RAfgfemEAEPrqgVNiz8GVTtzSkoMCL2y9y36WFGUBaJ6itJlww0DOo
    gJ0hbAHzdSjPUXdbPsQgIvxyDhqZzECtvW1DABxuVAWqy6+l51IRDwZflbsEz6ZuyLdh
    2mbw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1784543021;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=D6uN2sWReIprCfPPkylHnLQRLXjI+28a/AQsOF1V7XU=;
    b=YY9v27ku5lXuwLK4tkKNXbrUViqM8OceZVb5L4vBQmYiMVOp7xr9qIwUzSx2M4GC6Z
    a6iC0mFDHbB2dG87xkM99eRkkgLAPOCnBzlv+4eWANOCk9QoPwcY1zMNQ8vOS2bat+IP
    MyQyZ3ERhOqL2fV3vHcB3MC3EN0crQTQO8xWIcq0d7IRcSs6jpV8NK1brzbfpxaxHkJq
    q1IQV8AQ/w7FAKWz4PETJCdh3drqT6orecX5OGQqT+wWG8fay9vmwJNF5DFRYE6b/NjZ
    EikGtB5Xz5xdUBGCXoHCZArd2bTS4jPzC0dOKAJC7k3afj34Af5Tje5Q70djb1TcwEYQ
    tdmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1784543021;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=D6uN2sWReIprCfPPkylHnLQRLXjI+28a/AQsOF1V7XU=;
    b=17/SkrGMNu3WGSF1Ulxz0qdbdJ4jZgcY5RWt2z5n55qcALuAs974By7cuNvVAjBdTq
    /MyGTHnThLuY/SwPKvBQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc926KANe7OZ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 20 Jul 2026 12:23:40 +0200 (CEST)
Message-ID: <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
From: Bean Huo <beanhuo@iokpp.de>
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, 
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	can.guo@oss.qualcomm.com, beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 jenswi@kernel.org,  sumit.garg@oss.qualcomm.com
Date: Mon, 20 Jul 2026 12:23:39 +0200
In-Reply-To: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


This is very strange, coverletter is v1, but the patches are v2?


On Mon, 2026-07-20 at 11:16 +0200, Jorge Ramirez-Ortiz wrote:
> This series makes UFS RPMB work out of the box with an OP-TEE that
> implements the standard eMMC RPMB key-derivation flow, without requiring
> any fundamental changes on the OP-TEE side.
>=20
> RPMB provides an authenticated, replay-protected storage area whose
> security relies on a secret authentication key. In our setup that key is
> never exposed to the kernel: OP-TEE derives it in the secure world from
> its hardware-unique key and a device identifier (dev_id) that the RPMB
> core hands down. OP-TEE's implementation targets eMMC, where dev_id is
> the 16-byte eMMC CID, and both the fixed length and the raw-CID layout
> are baked into its key derivation.
>=20
> Two things stand in the way of reusing that same, unmodified OP-TEE flow
> for UFS RPMB:
>=20
> =C2=A0 1. On a cold boot the very first frame sent to the RPMB well-known=
 LU
> =C2=A0=C2=A0=C2=A0=C2=A0 comes back with a power-on UNIT ATTENTION (ASC 0=
x29), which the SCSI
> =C2=A0=C2=A0=C2=A0=C2=A0 core reports rather than retries. RPMB has no ea=
rlier guaranteed
> =C2=A0=C2=A0=C2=A0=C2=A0 access that could clear the condition first, so =
RPMB fails on every
> =C2=A0=C2=A0=C2=A0=C2=A0 power cycle. Patch 1 asks the SCSI core to retry=
 the power-on UNIT
> =C2=A0=C2=A0=C2=A0=C2=A0 ATTENTION on the RPMB WLUN.
>=20
> =C2=A0 2. The UFS RPMB id is "<device_id>-R<region>", which is variable l=
ength
> =C2=A0=C2=A0=C2=A0=C2=A0 and longer than 16 bytes. Passing it verbatim wo=
uld tie the derived
> =C2=A0=C2=A0=C2=A0=C2=A0 key to a length OP-TEE does not expect and diver=
ge from the fixed
> =C2=A0=C2=A0=C2=A0=C2=A0 eMMC CID ABI. Patch 2 hashes it into a fixed 16-=
byte dev_id with
> =C2=A0=C2=A0=C2=A0=C2=A0 blake2s, keeping the key stable and unique per r=
egion while matching
> =C2=A0=C2=A0=C2=A0=C2=A0 the eMMC CID layout OP-TEE relies on. The hash a=
lgorithm and input
> =C2=A0=C2=A0=C2=A0=C2=A0 string are thus part of the key-derivation ABI a=
nd must stay stable.
>=20
> With both patches, UFS RPMB is functional from the first access after a
> cold boot and derives keys through the existing eMMC-style OP-TEE flow,
> (requires minimal OP-TEE changes pending on the CID proposal done here).
>=20
> Tested on IQ-9075 with Open Firmware [1], pending OP-TEE changes
> [1]https://ldts.github.io/qcom-buildroot
>=20
> Dependencies:
>=20
> U-boot:
> https://lore.kernel.org/u-boot/20260720085202.537019-1-jorge.ramirez@oss.=
qualcomm.com/T/#mc423eb4dcf8a15849077029e4f7c1913bb7d8873
>=20
> OP-TEE:
> https://github.com/OP-TEE/optee_os/pull/7881
>=20
> v2:
> =C2=A0 * ufs: rpmb: replace blake2s with blake2b so that the same support
> =C2=A0=C2=A0=C2=A0 can be added to u-boot (CRYPTO_LIB_BLAKE2B)
> =C2=A0 * added links to U-boot and OP-TEE changes.=C2=A0=C2=A0=C2=A0=20
>=20
> v1:
> =C2=A0 * ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN:
> =C2=A0=C2=A0=C2=A0=C2=A0 - fix using uses SCMD_FAILURE_ASC_ANY to retry a=
ny Unit Attention
> =C2=A0=C2=A0=C2=A0=C2=A0 - fix unused variable
> =C2=A0 * ufs: rpmb: use a fixed-length RPMB dev_id
> =C2=A0=C2=A0=C2=A0=C2=A0 - fix selecting a non-existent Kconfig symbol
>=20
> Jorge Ramirez-Ortiz (2):
> =C2=A0 ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
> =C2=A0 ufs: rpmb: use a fixed-length RPMB dev_id
>=20
> =C2=A0drivers/ufs/core/ufs-rpmb.c | 39 ++++++++++++++++++++++++++++++++++=
---
> =C2=A01 file changed, 36 insertions(+), 3 deletions(-)
>=20

