Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F08E381B05;
	Thu,  5 Mar 2026 15:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772724528; cv=pass; b=TEXwPXc1BIFl8A3CbdxS2g0V4MNNjhahiWDDZTpOF9LGLPPmMQtCSfZEsgw4F+6yNWIvim5YmpkQ1ENAvN3dd7jhrfz0urRWRk6hp3/TQdi5Hc8hCWSYyXMeFMjTq+SUKjRyAY7ZI/oxULsBQBW6k92yk+bYxszzHr1CiLZZLP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772724528; c=relaxed/simple;
	bh=GyfEWDA4WY/JVJH+sN9E8894942o4AuX6wqzVKR7s0o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=idcP+lj1+8lNw5w5FFDHL2eLkceZbPNjKLzNDykUr1EwI024sJuGFrPU3mukUjhMHjZYzx3HbGOUAuODeT+m7UrqX4QrISmoSQ1rYh3I0Cw4DHZ9VsyESvuLhH9JX0oH9Y+ihviqgQo0Pk2Zpcn57THrkwv2l7InhQj2rreCVCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Ivu5PIdL; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=UwRwlIrv; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Ivu5PIdL";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="UwRwlIrv"
ARC-Seal: i=1; a=rsa-sha256; t=1772723084; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=cw4m37SOvk8u7b9ffp1hw9PhdWe11RmUm9AziYiNGzXYouhmCt9WhPUIIRjdNPXjJq
    6PHfaodLGvgSyf7mKWV62+fqql0Ks+6szfCtMr1I+gdiZYSOJs4TgBIrrlDdsnwZAG2r
    aYDhUmpoKVe5mcGCo+zng3cvNgchf53GHRZRdLyItCF8bzkSQ08KmBxO9s8G+HlDFT5V
    tUoVqEU9LFvNGHc71KBdTeLO0++63QtmaRI95p21GjY7ndFqOxLm3j/mVr+QiVDIRRAT
    WyIh1Pqk2ZSrKdb+oF4qoZ5MrDrQn833OyOu6Q9Tx02jSvI5vcZ6P9nwZjkY9LHHMHzl
    ON8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1772723084;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=GyfEWDA4WY/JVJH+sN9E8894942o4AuX6wqzVKR7s0o=;
    b=SzhKspfABu22MxjYbpof4D4qXJH077/WPXs+E6FSiwuXMU/1oxDLqdjJyLtk1ObXKk
    Qy7RQwUFkq4U1y6b0jicRWmqEcYtZKkbGWGtBD9QouNhpf7wNmWfTuxOMcHtQHO1gxWg
    DNEXZug4l9cSZz/pRoSue0cRllLhwA0jUKvyUwiCA+HTb7Fq8rx5jQr8TyrJNhgqDFs6
    Mq+cQwmMMEYdq2G+RQJPAYfC3MlwCfX4IgDg49X2yF7pkd7o4QQIevl7+keUieRE1n+S
    KGKmXvWcTyG+HWMhTESKBXmlQ/rfvm0M+T70eDl4qPGLA+pJEDRFOBl6LpxD+0QIVj2h
    jD3w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1772723084;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=GyfEWDA4WY/JVJH+sN9E8894942o4AuX6wqzVKR7s0o=;
    b=Ivu5PIdLe657vURoySW9zhV5BcRkIGzQS9+Q5Xt9ocPIW1Te2r0gwnf1P6Uy/DW9u0
    Nb+/8EEaf0LdB00bTXANLcGq48MpPQEBekNLakrA7vcRDxutObNxfb747fqhPYN6wOqm
    wa5sTTIuduFF80x6p75uQXiOqV1mwUVcZmFC68R4ap7TvCDwz7oEDtiGvtHREm0X0KKt
    EiMZIG9F/8Nvl7ssut917fGxPGYuZwOhx0Kdu1YMdvpSdWPnz9vDAh6FEeQhcIqO/Ydq
    HkUIm3nFVO3gTK4YckgXWMjdzPLXabl1RbLF9UX4OVKQG0Q3Ng3pwuuOYwkS0UdIwN38
    HIzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1772723084;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=GyfEWDA4WY/JVJH+sN9E8894942o4AuX6wqzVKR7s0o=;
    b=UwRwlIrvUlqsxvhWnwFKEUi5e7iADlH5h+t66RJbZEC+WpmOsIRA7DyMrjSQAOBfNk
    tG6MBjwHM+9Mxc3tuGAQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z79345225F4h63E
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 5 Mar 2026 16:04:43 +0100 (CET)
Message-ID: <e116e78ad9590f5845aaaf7d4e26833a7a0194d0.camel@iokpp.de>
Subject: Re: [PATCH v2 00/11] scsi: ufs: Add TX Equalization support for UFS
 5.0
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, "open
 list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-kernel@vger.kernel.org>, "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
Date: Thu, 05 Mar 2026 16:04:43 +0100
In-Reply-To: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Can,=20

On Wed, 2026-03-04 at 05:53 -0800, Can Guo wrote:
> Hi,
>=20
> The UFS 5.0 standard was published today,=C2=A0

Myabe replace time sensitive wording =E2=80=9Cpublished today=E2=80=9D with=
 stable wording?


> introducing support for HS-G6
> (23.2 Gbps per lane) through the new UniPro V3.0 interconnect layer and
> M-PHY V6.0 physical layer specifications. To achieve reliable operation
> at these higher speeds, UniPro V3.0 introduces TX Equalization and
> Pre-Coding mechanisms that are essential for signal integrity.
>=20
> This patch series implements TX Equalization support in the UFS core
> driver as specified in UFSHCI v5.0, along with the necessary vendor
> operations and a reference implementation for Qualcomm UFS host
> controllers.
>=20
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> TX Equalization is a signal conditioning technique that compensates for
> channel impairments at high data rates (HS-G4 through HS-G6). It works
> by adjusting two key parameters:
>=20
> - PreShoot: Pre-emphasis applied before the main signal transition
> - DeEmphasis: De-emphasis applied after the main signal transition
>=20
> UniPro V3.0 defines TX Equalization Training (EQTR) procedure to
> automatically discover optimal TX Equalization settings. The EQTR
> procedure:
>=20
> 1. Starts from the most reliable link state (HS-G1)
> 2. Iterates through all possible PreShoot and DeEmphasis combinations
> 3. Evaluates signal quality using Figure of Merit (FOM) measurements
> 4. Selects the best settings for both host and device TX lanes
>=20

what happens when EQTR fails, mabye you have this comments in the patch.

Kind regards,
Bean


