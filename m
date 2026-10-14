Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0484F4733;
	Wed, 14 Oct 2026 10:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975535; cv=pass; b=X0zHsJL0Lu2QinrukosL7nNJS8i99c2unlkKKKHtE46N+x06HKcmHRJ8JuPvUMcGfkms8mIHymjl5PFWZGLT+TnUPK4P7/i6HzPB/2pxvw3ZYY9P5y34HBFygPADcFLPIn20HazJ4Mysk04XlDIv6368PYKJALDJmXow8aphIq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975535; c=relaxed/simple;
	bh=i77e+wBiWi8FqvuuJeUW9AWeITiuJSztxl7rR9SlHBk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c6WXE8mHW6x8HiLShEts6qWW1aWcLxJWBj9OAp1C+2DW/AJH3c33E7A3YfMb8vk5Xt6BLOtGuwL81wnuJMQIiDVmBVZKbsD3MQc3/x3iafopXpmccLtbb5iLWntFTC946nDFS0nftrtzAl2RxGRIu5G2bHTNQKLyJbXLn46R8BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=mDWjPhU5; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=mza393iE; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="mDWjPhU5";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="mza393iE"
ARC-Seal: i=1; a=rsa-sha256; t=1791975523; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=OA1ZxccYceiWPQRn4RfeedxzDtdGhYXZ98aj3Rp5ixpOOmQmYnLeATWtLR65N18c1s
    +MdS4TNx+K9mWxOYAl6/TKzxNxfGPkniQCt3KKBJzG9nc1xluBNyc8unqdwoJtJpYeKF
    muJsQAtk1vH3jrZhQZfieXUz8vJ+mUBMkspIECloQltnLTpXE0jbN2tbbzvQj2Z3oWOQ
    XpycyiakhYgsKu5cp3+JqWZiH0PeJqRhf9M6dIlLVZ9jcN0Yuq+e2KqzFzkkcNcIuGB+
    FkQ/smYV5NV8zOyMh+Xty6dJoevo4Wp0O70C9hUmRNCUQj5XqAs2QuG+v366EOuxVGB7
    b6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791975523;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=i77e+wBiWi8FqvuuJeUW9AWeITiuJSztxl7rR9SlHBk=;
    b=mEuxMPAlzyIm632nodxxENzRGrfDBIXf7AJdVn/EvMYdoXqEGcHohS7h2pqFRapXMD
    FpRearoEexw8wRmGlTCgenw2wlGuCRz3XwD4PLM0mO2DR7fW5lv9x7KdJPnYZdiEuX3P
    gPprvQrFkQDpDeoXxI4kKIG2nxLHvelCMDYnoMOtWgqE3DapYC51nJP8MHJ1vPpLUr8z
    e4dmOWfTdORF5B06ovDkJczeqLgagMLTPyv1HxxwYj6bPDELcyD1Hmprkf7hgR7AiuHu
    LMFxou9uhUlzZ+knd0XgZWPbxpuuDrSHSkVi1adYF2N3Wm649oOhXgx46TizGTz/B5P9
    O5Og==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791975523;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=i77e+wBiWi8FqvuuJeUW9AWeITiuJSztxl7rR9SlHBk=;
    b=mDWjPhU5+ZfHnvBR3UBil4JsiC0OwcXULLsrd9/XFQlXkiiyrjxa2mI9VZEhABWgiC
    O0kBJIQgazWJ21kitiD+9t+/m9DXICGCLyBVYBM5fY9B50FQMC+DWLoY7xdLQFGHhaIr
    0Gd6dlS0ZWESMabl+U4Zp0w9Mjqs3RfNvchW8giAhdUaOQEOZiXpVGmRF+SLSaIIMWbZ
    aiMWW3p1xBsmER+IFCEVwciy6mZba9l6nF/Xcm1dXdMiaqK7h8WD8t8l7TEwMbpA4PAJ
    xVCbU5+Qb72LCIMM9QPVKJxSh86DAw2H23HAjT8b/5R0eckI2MiIZqYuvsj3bZ2ci1A0
    YhiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791975523;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=i77e+wBiWi8FqvuuJeUW9AWeITiuJSztxl7rR9SlHBk=;
    b=mza393iEpO8uOfC+eFAI+vNsxnbP1+Q/iyTSTKjs4CboahGLWZl/bOPVIk0agqUEwS
    ZsjCgbZ2/zs1PBSTzdCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.108]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29EAwg3jF
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 14 Oct 2026 12:58:42 +0200 (CEST)
Message-ID: <1502975d00e9344bf33b5d1ed23501699895998e.camel@iokpp.de>
Subject: Re: [PATCH 3/3] scsi: ufs: core: Clear stale UIC result byte before
 peer DME retries
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: powenkao@google.com, Alim Akhtar <alim.akhtar@samsung.com>, Bart Van
 Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, Peter Wang
 <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 14 Oct 2026 12:58:41 +0200
In-Reply-To: <20261013102913.948718-4-stanleyjhu@google.com>
References: <20261013102913.948718-1-stanleyjhu@google.com>
	 <20261013102913.948718-4-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-10-13 at 18:29 +0800, Stanley Jhu wrote:
> Peer DME get and set retry a failed attempt with the same struct
> uic_command. UIC completion ORs the ConfigResultCode into
> argument2[7:0], and nothing clears it before the next attempt. Once an
> attempt fails, every retry keeps reporting that error code, even when
> the device returns success, so a transient failure becomes a hard
> failure after three retries. Each such retry also triggers the
> WARN_ON_ONCE() in ufshcd_dispatch_uic_cmd().
>=20
> Clear the result byte before each attempt.
>=20
> Fixes: 64238fbd15ea ("scsi: ufs: add retries to dme_peer get and set
> attribute")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
> =C2=A0drivers/ufs/core/ufshcd.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index bcc2512bf34b..9adb3b576e28 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4398,6 +4398,7 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32
> attr_sel,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int retries =3D UFS_UIC_C=
OMMAND_RETRIES;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0do {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0uic_cmd.argument2 &=3D ~MASK_UIC_COMMAND_RESULT;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* for peer attributes we retry upon failure */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (ret)
> @@ -4465,6 +4466,7 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32
> attr_sel,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0do {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0uic_cmd.argument2 &=3D ~MASK_UIC_COMMAND_RESULT;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* for peer attributes we retry upon failure */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (ret)

Stanley,

AI Sashiko comment on arg3 should not happen on a spec compliant ufshci
controller, since arg3 is an input for dme_set, arg2 indeed has an output b=
yte
for every command, but restoring arg3 in the set loop would be cheap safety
enhancement, but up to you:

for me this patch is ok:

Reviewed-by: Bean Huo <beanhuo@micron.com>

