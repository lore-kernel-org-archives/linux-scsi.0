Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D92D4A3F3B;
	Wed, 14 Oct 2026 10:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974623; cv=pass; b=eByTsGb1/33Fz0LtBD8TEaYHHfPg890uL0gDHbpK8DMvAdonWK0ttdlVB/Zbj/Ne6/i4aVq+osc6qWnmeRZwVVaf4i2pUFVKA4c0KiclPyLuKvdj0N52re6cPCzaroKWL2fYozQynNrcWqhhDBIRcl15L9oSSchjqu7RfNQum1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974623; c=relaxed/simple;
	bh=5x3u6FiR8qckv8HF7OAp0XN3GDedSEoUChbL0yqk9NI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nhr0XUf9ctuyNRQDP/oRI+qoiEB3FOjTfCrJtn+gRpQzBSNQ4u23wBhoakG3cx66mlW1+py5k1GLiXCvhp70eoHesxdd98NkqXeKTCnizNn0sk0b2SbCWF/QO9IIFYVSaOjnrqcdkYTz7UKdxcLcVdJ3NzfxEyVPWT76LOnXgI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=hUS+ocX+; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=l6rdbnAn; arc=pass smtp.client-ip=85.215.255.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="hUS+ocX+";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="l6rdbnAn"
ARC-Seal: i=1; a=rsa-sha256; t=1791974612; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=rozXirl2H8Nl9/n7e0eazNK/Qscin6anq4zwtddIecm2bbE2jJ/Dh4AbszU0x8uMnC
    1y7xRVgB0ELBGDVpJTzoJ15334vjLcZU01xfrsoXJxllz4I0lQo+M8HkJvtQqCu+F/Ha
    C85CfBfZdFbzUM7dWDcX3YAeqLrhYWjhbjFwRs1DeOIQ7XbgjgLI/caS5p1GsBn1+Cx/
    3HPfLGYOH++x2hgkl31poanxcWeCMyogA2GCw9IDV/EcZVXePRrFWtVb/h6J4eJgIl8b
    YcILrfqyktE8HkxtcNkLFns27cXtzmfMGlF1X2c1oATrzIuDguIwJd0C1/y1GiAKlb18
    Po0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791974612;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5x3u6FiR8qckv8HF7OAp0XN3GDedSEoUChbL0yqk9NI=;
    b=E4cYyf9x0geOUmdAbksbptRmbGfWIrMouyc7WmY+ISjkhaboLc/ypSOYn5/nBI6RX6
    qlArPdiiADJb6EyvFng63sXv0961p4Mn1ZRTaJU1eMjeVLM1Ba9Vrg+o8YDmHGspILlQ
    Ar181JahhFxZ3Bum9dbFoCgCOKLZNanjh7LVFIF121mocPcyka1oq19gQWuAMRJXhK5S
    ZCZPVI+XmaI8yT3v1S/NQHMIM8c/YxMDfPE3GDBVH1jYDIJae8JuPdtGLVAmSIIvGNZT
    Gj9mzxcVj5OPZuK1NqZQB3AJeoMgnDZXWQZU5cpnndVF5OqDGLFbHznXuDgtcs1CmsF8
    bHww==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791974612;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5x3u6FiR8qckv8HF7OAp0XN3GDedSEoUChbL0yqk9NI=;
    b=hUS+ocX+kAntLxaHRsDwgJt4us0Wp3rmOksQFOnvP6Vfu2r1y1oVO0g1EJ2oMpQApM
    Ol3SWLy3IHr1Mb7yO56CDa/uHIwa7gWAfT3cn1fOqXY52KRmE8JB5/i5SuGBU2g85JBX
    wbNVaX/1Z8yvbMCvRO84u7sonY0sXLO2pEgTHcE6NY9nC4X5TdLi2QNmKvIY6YeQlrph
    P1hzZYKytaSfUZ24RZfHxc8mujhoG99W39PdR960CqLutcIzCAYhF89UaGXLCedAVVtP
    YdnZPkEhE69mL6jLyENQdg0oqWEmUbk0RPwNnB7WLrekgPr0AedHux2ppFi1JIu+6lD8
    MUNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791974612;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5x3u6FiR8qckv8HF7OAp0XN3GDedSEoUChbL0yqk9NI=;
    b=l6rdbnAnBnxiqzUh2jm3/q78XdqMTW74v1E+AcdAfOjwQLBtLIqW2I7WLTRnVi9oqQ
    qio2UyYsVPBFObNVChDQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.108]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29EAhV3el
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 14 Oct 2026 12:43:31 +0200 (CEST)
Message-ID: <c39f4af2716cdc1c71170a9eabdbe29abb8c4bb2.camel@iokpp.de>
Subject: Re: [PATCH 2/3] scsi: ufs: bsg: Clear the UIC result byte before
 sending UIC commands
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: powenkao@google.com, Alim Akhtar <alim.akhtar@samsung.com>, Bart Van
 Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, Peter Wang
 <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 14 Oct 2026 12:43:30 +0200
In-Reply-To: <20261013102913.948718-3-stanleyjhu@google.com>
References: <20261013102913.948718-1-stanleyjhu@google.com>
	 <20261013102913.948718-3-stanleyjhu@google.com>
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
> ufs_bsg_request() passes the user-supplied UIC argument2 unchanged,
> including the result byte (bits 7:0) that only the host controller
> writes. A non-zero value triggers the WARN_ON_ONCE() in
> ufshcd_dispatch_uic_cmd() and corrupts the reported result. Found by
> syzkaller.
>=20
> Clear the result byte before sending the command.
>=20
> Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in
> ufs_bsg_request()")
> Fixes: 9fb4c793223b ("scsi: ufs: core: Complain if UIC argument 2 is inva=
lid")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
