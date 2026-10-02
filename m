Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B34471D10;
	Fri,  2 Oct 2026 09:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790933073; cv=pass; b=Wq4iAopfGKVaMo22QFitMiyNU903bc0va5KCxIhpV2t0WzOiUdzxMAKnQnH1Ozmx5k88wzlScQVTZGh+kbcGTicBfXvln0B6P+iRCtFaBdbMl0RRu1vpjIlO3wZd2T2YCC8YuqWD7uKGbBvCCmz0DDPWI9lI9gDcP/vq6L/uPP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790933073; c=relaxed/simple;
	bh=OGsyA19scA0QsAjlL/scH+RGq/86dQMb9SXx//eF9rU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sjt2D2NDQTCqIk3M6HPL5X6y7NAGZcksDWD5t43b3U4VEiLm6O1cJiUEo10SK/ebQ3JyqY0KUtsFr6xzFaQ0r6/byfXhVOl4Q80hE/JuX65yezUH1GxeD+xtVQSxDbQU94aQacZ0Y48xLTmZw+qo7gupsRKabaq5qiyIHEGbvxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=fJjCzDYU; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=LxDKS+1V; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="fJjCzDYU";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="LxDKS+1V"
ARC-Seal: i=1; a=rsa-sha256; t=1790933056; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=qLHMSmKLxT4aE6HxvhLtgrEVHYt2eVj1UN6VDDPBwxZ+gQbKpsFRcQTjlrAii5bUfg
    SKATAYQ+mSPI284P5T5BEcDhUHxFYW66bobrlBBfLWrz8OITxVpligLEaFm+C6J2Wf1Y
    ro5CQZvS3FfsTJ7UnoOjkMYolcq5V5NFdAeaDboeqgQmAr9+ysfSKt2RI6oFhAQqQSmp
    hcIsHicKB/wofEYYJC79avbd5u3Q38C+4sytKcG7/65ZJS3vrJc9GvRNnYCQL5vM3F37
    nc/gaspbTmplKfwDAgPGA4lzB2P+0VF/lKxek863O4NpLeSvRznbCXw+LUas9hP8m2VO
    Zp5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1790933056;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=OGsyA19scA0QsAjlL/scH+RGq/86dQMb9SXx//eF9rU=;
    b=cBEaFTNWBcupFim/yKyj0yDxzEPpBIBWaq38bJvwIPJK2MCv5DHY7cO80cz0q0vwve
    cBrOX1XhxYndFIdjTQcs2SA6zu5dN5qsFGu8E3JEnHkswpxomlzzPFW27SZktbDWztKD
    L9fz+zlg0Gp+fGUL1/7/BQ9q2cddP50cZcZ88qdyy3twD/KUzdfDEP03k3Z2q05YHqtL
    /UL1+KW48mnQkLE45K6S7PY/at10IjxexMTf1Hl1YdWi0W2zsqoMWttbyZ/V9SOp9VVm
    0eVPc6u2dSoYH556+YedK3dt3inPM7KaCLNopEW5VuRYt27m04PnnSWjRT39fN1/+azl
    e+wg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1790933056;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=OGsyA19scA0QsAjlL/scH+RGq/86dQMb9SXx//eF9rU=;
    b=fJjCzDYUSibh1aZsOwu+Qsm9m3rXCUrilzC1TIviamNBSOf/vIju653XUoRGgkzOQP
    Y1aDvNquNruebi/3g/LNCDs7NLk4R//j/Kv/trfJgGFNWVI7xEAh3qewFsWgFysKMvzQ
    U/kLdQNH5L67RKft0Se1RHSgacJEI+G9JSWjYDfTb+pFLSLzMHHIoWdJxsU+SzFm8Sc/
    4TXSbmzmSvFQjy9hwhtOVgRfuHQmVwwnhPfZllktDnX8xSgV6jZy/PdcR090kLb+e/mP
    2qIbipoSPK02bW4is1hqA1CEhDhZsuH78WSCPKZmMgwc2ZOhoA0tBEmkEYHPKjfA1gH6
    xA6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1790933056;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=OGsyA19scA0QsAjlL/scH+RGq/86dQMb9SXx//eF9rU=;
    b=LxDKS+1VS/8IehST8lNcUPhCRaCvJjqRV86M9Nwjc8kUPxwCdrLG3FpWA+37DSMA7f
    MWfuCIZlrv/hQnfG82AQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.237.249]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id z04e1c2929OGHSX
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 2 Oct 2026 11:24:16 +0200 (CEST)
Message-ID: <8ab9b08e12bf60e89a60a86137a23e9164e43839.camel@iokpp.de>
Subject: Re: [PATCH v2 0/2] scsi: ufs: batch device-init reads with UFS 5.0
 aggregated read
From: Bean Huo <beanhuo@iokpp.de>
To: hyenc.jeong@samsung.com, "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
  "avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
 <bvanassche@acm.org>,  "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jinyoung Choi <j-young.choi@samsung.com>, Alim Akhtar
	 <alim.akhtar@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>, 
	"can.guo@oss.qualcomm.com"
	 <can.guo@oss.qualcomm.com>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Date: Fri, 02 Oct 2026 11:24:15 +0200
In-Reply-To: <1860250540.01790747102385.JavaMail.epsvc@epcpadp1new>
References: 
	<CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
	 <1860250540.01790747102385.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-09-30 at 14:02 +0900, Hyeoncheol Jeong wrote:
> No functional change for pre-5.0 devices.
>=20
> Motivation: on a Qualcomm SM8850 platform with a Samsung UFS 5.0 device,
> timing raw UPIU queries over BSG (100 iterations) shows that replacing th=
e
> device-init read burst with a single aggregated read reduces the query
> time by 75-78% (min 75.3%, avg 76.4%, max 78.5%).


Hi Jeong,

I don't know if you have plan to enable this feature in UEFI or any bootloa=
ders
to eliminate the boot overhead becaused of query iterations.

Kind regards,=20
Bean


