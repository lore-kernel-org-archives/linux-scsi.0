Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BB82C1595;
	Mon, 27 Apr 2026 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777279419; cv=pass; b=GY3vPYSIxzpmM0OurxUb9morJGMGtDzp1SFMpK1HhBJkw8492XVR2zWC/QhW5E6ZjkU1lCqaKQK1teWNzx6XO8TT2WfQt0Yt1Dr2T1wtOYKj5btLSBdkj1NDqRRgGplxR5SEhhehaGbcSW3sz46E0nFO/8V3Zo/aJP/iAOP/Ys4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777279419; c=relaxed/simple;
	bh=CPhPRwer5L9xzv0bLcv1GDpPQlt9aRz7qLDAhjenRRI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lKmSVKCn2ETNfwiYDuwfExPBRzuJxax8l0mKgINaV+/Is/Bm5Qn0VY5ZekyUL/9S8zsJkbgFZosGHSDLb3im/LspmtM816o2sHRzNQSV0Bg9ufMH4vYnUlUPkNDFToCUnC/QG7RPMxMBH7KxrmyLRmaGns/t/SZqA1BjPRs5JVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=K0NvXGxy; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=yuIV86X8; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="K0NvXGxy";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="yuIV86X8"
ARC-Seal: i=1; a=rsa-sha256; t=1777279053; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=VUy6LW7tjYjU0p1TA/dIGAkVNlRcfyGtGk/RbGAORrb9UTKXPexZUGmgkeQLjrfUm5
    5289gmNFdjfIMtyrlR+pbglLSXMA/Z36dhupWcU4PtdWEwktiepbQ2+QoL7mndz8YVF+
    lghn8kDN9athOWRQ+YvYwGmZbXIJk8FZ83lsHiwoxB1H2ZxzU4UhfX2DrpQbAirf8/of
    6tn1OJUje3C8Ga9u2HLMi1V20vrEIbwhDlMUzP3sN0ioWYOW/CAjfWNhCNrsgWWtrKEj
    pLoJfYgfG2gDoNjyqB2B+9RUYpJrpJLhFWrtTWYj0NuPvv+nw0MDpBJ6O5kBTZDwUkE1
    tkWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1777279053;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=CPhPRwer5L9xzv0bLcv1GDpPQlt9aRz7qLDAhjenRRI=;
    b=Mb/l6xlbnWzHWybB05Nv1rOZZM+OasKME7Fa2yunNQ3CTL4Yyi/kg7edgVapIUuFtJ
    aFZmfWWsFOknmZGzeb3yvD2+28ivTw/psVlAlghXsYEBZ/UVQuK0CCnNL6+nAj5+bVRT
    M+jpV/pAIPhlb+REkD1lXdGVdajHD1eHZmkc8PPD7fpr3NKygY07E5uTAW7MaBYlr0Z9
    dcQpVnmuyFrarrnfn8FXi14ptg9ICXetq9yAQsaByJ4h/M+2FgfzSJSNIOo6wRiuEnSl
    /z4RPza1oSzd30Jcg/zZaD7YKwHmBEXsKCX9Nd4Xl12I7xXWxfJaBCW0SuyTl6zXQk+C
    PzpA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1777279053;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=CPhPRwer5L9xzv0bLcv1GDpPQlt9aRz7qLDAhjenRRI=;
    b=K0NvXGxyNSVZXVJP97vZMYYt/n8jVnjswOb3krSxS783019xZV4xJUljafcwmakFje
    BNgvRL536oA49w6KqWvOY6iOw5vWSyrtJBhFyskeS2sB6onNjRouRWMK696h5Zq/EUWC
    rgfnlEy5czUj57BBNKCbuytWX6xv0z3cOhFFUKnU4GDx0XyN4vbTNfOxyCygm7UTNLhd
    Jfq0mV0chtkIpGeQjXRwaIuZXG0vsvc10XHpjv+H5KORWwbqlZxDW/K7ozZITar5/Lkx
    WnfKBGkOr9FO52FZcbPKbYJPf9Xx1QZwX6Q5WuSjZumZbnwFjHFdHwekOEGKj8qp/2cG
    FHtQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1777279053;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=CPhPRwer5L9xzv0bLcv1GDpPQlt9aRz7qLDAhjenRRI=;
    b=yuIV86X8Qpy1qonNtvVaoW9QSda0DkgGJkoqiWJH9ApX8lCCbv6AL9c4S/zOGcqAwh
    NBGYIbveDh2zFa5vrxAA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZ2k"
Received: from [10.176.237.185]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934523R8bWibO
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 27 Apr 2026 10:37:32 +0200 (CEST)
Message-ID: <b1e3a3e37b7a5a4e26d429b94b2d3a0a6ea00220.camel@iokpp.de>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Add support to retrieve and
 store TX Equalization settings
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, vamshi
 gajjela <vamshigajjela@google.com>, "Rafael J. Wysocki"
 <rafael.j.wysocki@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, open
 list <linux-kernel@vger.kernel.org>
Date: Mon, 27 Apr 2026 10:37:31 +0200
In-Reply-To: <20260424151420.111675-3-can.guo@oss.qualcomm.com>
References: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
	 <20260424151420.111675-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-04-24 at 08:14 -0700, Can Guo wrote:
> Add support for UFS v5.0 JEDEC attributes qTxEQGnSettings and
> wTxEQGnSettingsExt to enable persistent storage and retrieval of
> optimal TX Equalization settings.
>=20
> This provides a fast-path for TX Equalization by reusing previously
> stored optimal settings, avoiding TX Equalization Training (EQTR)
> procedures during subsequent Power Mode changes.
>=20
> When no valid TX Equalization settings are found, fall back to full TX
> EQTR procedures and optionally save the results for future use.
>=20
> The validity of one set of TX Equalization settings is indicated by
> Bit[15] in wTxEQGnSettingsExt.

Reviewed-by: Bean Huo <beanhuo@micron.com>
