Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DA73F44D5;
	Sun, 18 Oct 2026 18:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792348561; cv=pass; b=C7jkTOUc7pzyk2AAsYFLtJDcMZwubYHf43eVKfeaB9V0L8Iun6f1puyEKfoZA0Nt4P7aIeUn42a1UlPqaIGkbkISv0gfZGXk4J7l95OLxeE8Ipk3CuLXoz0OxjZPF+EPOvpNhhZD84hBiZQElYd6xIMOQI6uTP2Uu2HRR8kSQxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792348561; c=relaxed/simple;
	bh=nPk6kJGf1TA+NzKuYCIu1dQrc5aQA4xhUHBNocLNJ4w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ONv34bMPfOEwmTxVvq7jXMk9D7cI/fdm8nbuqY85nhgm2wHKbnihXJewa2xMr66Bn3Wogq5qSSR78HztPy2+Wv8EZQUuf+T89P1Cm6p2TcMYS8JkzJU4ZgZCmU9UhoXD0W9kt9FXqyIAxvybWlXOMALVtXSAVSLbiF7vlAwWd+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=NY78/vpu; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=IrEQXLCv; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="NY78/vpu";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="IrEQXLCv"
ARC-Seal: i=1; a=rsa-sha256; t=1792348551; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=DMXgEc+DJXmkgSnhn8dLGTR/9/6NcY4c0coCLs0e9/358iD+kd1mHGtk9i3t4ZfzUh
    KDtUK4vqBkGAuksTjCiQNNEiyPTWGrlNoRY1cX7iWow+ObJi3UiY99yxmVgVnE1LTgxy
    NlkIHvaXRodLhFJ+9kZLvCMUvEZbIOZsnOzvK16ouUw01PJ74/ljc+JG3FrQM49wkPdI
    nuioVQjm2yrwZmtl8HiPhYW07eNguO3npa7eV2t6dUmf0LtSrx2vy4nZGtEp1Vu+MPHz
    GdBZwOaVpARXUuS3zOAZx8dL3mai/82QGAkDPBScpir6aEN1b1YUeQnQY1mZoiiSczEA
    Dwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792348551;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nPk6kJGf1TA+NzKuYCIu1dQrc5aQA4xhUHBNocLNJ4w=;
    b=Qv1tK7DQ/aIl2LA8srmPwk7kkP1/x9CTJl1ubK0YX5UfrWby5bR8dTbRgYqQFWCpP6
    5a11/UQ8Lxh3DYMrAofQ9dZMAHObLHmKULKwkZwbsx3EFB4EH27oT1HQYf+WSuiz41Zz
    rBDEjc0uHo5cFrkc43BAng70xjrJIGyDGLy+ku206j34OTJTCN/nzN0BGt49x4cOaMVA
    MHNSRtIbUjEGZZrxPP4VzjVGlXNP9l+zT0n4UOO23JlecGW0Bk54IiSb+KZTLxRrQRvC
    hak0TGlV+0LpQxidTUiUr2nQp2fCKVP4SN0Nwm2jSaUUQs4zBsY+Vm6SQzPyvW/uNonz
    6cKA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792348551;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nPk6kJGf1TA+NzKuYCIu1dQrc5aQA4xhUHBNocLNJ4w=;
    b=NY78/vpuoxSdW2JYvqUYVzCJxRQHvYLHRVOZlJ1lXG4QSzq7JMNCUMfp8ZN0KX29Dy
    tJxzNzDU7Lw67LMraBuVyElDhiwBGqfcHDhYCrCEJmUUfCi+NUbPHMZ92M8dNfO0zQQ8
    95XFfo5FNGfVCgjQAW64c5DTiGhjfR4QDkKlMJ4aGgvlxFYezMY9tPDyGvc9785MrYa5
    wOzDv/H1s+/ihROrR0hh50LZ6LqDqvdEW5JlO4zonMjxTNqhzKtQc1xr/xVnejU2REuo
    1l0mdSlyvW3IhQlGpwWHNILBqceocuGfr2jHlmVIu0QX2sxiwXM2O7dfCs9J70U4Kxye
    Y6Dg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792348551;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nPk6kJGf1TA+NzKuYCIu1dQrc5aQA4xhUHBNocLNJ4w=;
    b=IrEQXLCv5uINFT9iemqM9fjn5I8OSfA/BLfEU6yMUASKpa6iZZ8JojwvVf8o9KhMD2
    qVbqexnWQZ1kSRkoQrBQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzZge/Z0bJo/ZKBs7IP24cD2xnjN93xVc="
Received: from p200300c5873684d949ea70d47c97a062.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29IIZoHL0
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 18 Oct 2026 20:35:50 +0200 (CEST)
Message-ID: <af3f01fd516c01cd6274541e7be71b155a1593da.camel@iokpp.de>
Subject: Re: [PATCH v2 5/5] scsi: ufs: core: Clear stale UIC result byte
 before peer DME retries
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche
 <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>, Peter Wang
 <peter.wang@mediatek.com>, Brian Kao <powenkao@google.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 18 Oct 2026 20:35:49 +0200
In-Reply-To: <20261015001855.3450573-6-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
	 <20261015001855.3450573-6-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-10-15 at 08:18 +0800, Stanley Jhu wrote:
> Peer DME get and set retry a failed attempt with the same struct
> uic_command. UIC completion ORs the ConfigResultCode into
> argument2[7:0], and nothing clears it before the next attempt. Once an
> attempt fails, every retry keeps reporting that error code, even when
> the device returns success, so a transient failure becomes a hard
> failure after three retries. Each such retry also triggers the
> WARN_ON_ONCE() in ufshcd_dispatch_uic_cmd(). In ufshcd_dme_set_attr(),
> ufshcd_uic_cmd_compl() also overwrites argument3 with the register
> readback before the next attempt.
>=20
> Clear the result byte and restore argument3 in ufshcd_dme_set_attr()
> when an attempt fails.
>=20
> Fixes: 64238fbd15ea ("scsi: ufs: add retries to dme_peer get and set
> attribute")
> Cc: stable@vger.kernel.org
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
> Changes in v2:
> - Clear argument2's result byte and restore argument3 (MIBvalue_W) in
> =C2=A0 the failure path instead of before the first attempt. Kept Bean's
> =C2=A0 Reviewed-by; Bean, please let me know if you would like to look ag=
ain.

v2 looks good to me, and keeping my reviewed-by is fine
