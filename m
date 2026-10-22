Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792692243;
	b=PPIVuAAN5/aIVVWULUQrOMP7Ml6xVq6oQXRTFU2BJ/CoF8wyWH90DQtcJ/FkP+GEq7bU
	 1EWURlDrTcOyi/VZqFUxAyVeSWTefm8Lyo6oXDs9zogSg2KGXeLxVgfohEmarb0pmT3Ar
	 lrxiUy0FaMkIA9MxyK+3k79DsNoB7nP0nsm3aLOOvr1w/V3ZsAhAhrt1Mvubtg0qBGLrN
	 7d5N4XTQ6gQ1j7E0Icg0MGzb1V+D1oKupoGPnVYXzqgmsIWlH0h/qFen55L8z8LQSLMQ9
	 rd4+uiv2CguXWDUivwLWyj4V1JH9Fl5MFprVD8EZHPuMq3Hw81gq+rBeoy7v/V4U0PA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692243;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=BM23w28C0QkzQA2JRplHbyEjl4bhPIjwO4EI/zhVOKc=;
	b=Hk5h3vvQI/1TXTUtta6JQ5Sgr1Ux9ZtT35atoAtiPKvVQX4HTDUxhE9zWawRChdK7ptu
	 A0O59P7bCWIp0mcJFBfepUGOx3/zwXQl0mtNOPWgnrQsaDqANqfDKq/ewNb1aYCKUEV4S
	 TXQZBf6jCMw5hnhzZrPx3MDUKDyEr6OWIs/4UOgRiSvTX387zA24HcsOaLwMPigcOEc08
	 7tsnd26j84x79fLHK4BMGPIHh2qV74F63XmgdGowi1r+xwVfejuKfQbYMTfNZxnpteTkK
	 bQX1uICUKgE3tj0AzoVks1rWMcTBMfKfBSGrJmDSCSb8Q4jEj1dlPkl76mfxJOc44rw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=W6g6O2fY;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=kOg3vhIu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201FB606A319;
	Thu, 22 Oct 2026 18:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 201FB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=W6g6O2fY;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=kOg3vhIu
ARC-Seal: i=1; a=rsa-sha256; t=1792692204; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=UneEW5AHMyQvY0q6ZzB4DaipAhefbkNYZpfgpgut789f0re0SWkDfkXHP0aNNaMz5P
    EslQFpi+t/DUpesYNzhuj/MIAAvozb4LhGy+FdJHpAkPI7FNtIwiPGYDWyi0ZrJbGdlU
    WLQ0kSKT7j0rykszvJtkJb10wYnivanjp2hdfPq7mZqIhaIZYxUEowodKkm8veIhvmNL
    CoPbLw2hLgTVBk1ROtSomuGOJ5iGWsWJ5AT+UbigQLXi+XDFZVjsq3CCBX5MP1wmUSVA
    knaA2y/ofDK8y6hQ6cgeZyppKCjNJq4YsEJuVMXIkC9l4mH9hkchHnumf+l3KA9AnKyK
    eCDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792692204;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=BM23w28C0QkzQA2JRplHbyEjl4bhPIjwO4EI/zhVOKc=;
    b=dNOHtfFDDjFRGDfc1HqJU347VIqMN/Ne3DRKV15es2hUr37IShDASUkNke/EgXxzWv
    L4Wb+xwkDTrzb2D7P24d6tqGEFUYYwX85r5eY+R+LxqbNwKG6XXazFd72j/ZQSd9xK/2
    /8LBymr3tBeX7IXGq61aYQ7tm/TlxCA6QSmF2CnVS5iP3vG4L5vLvz7nifyHB922Q3hu
    7Uek+eDyNJkb+/gpMptro3YuG5Gwr7OPID6ozoQkoNy58xArJvDag54sRU0gybgQi3p7
    XlxcYoCqEjVBoUTKSs/bWy3O3YmkrptR6QYZDmRqvVL1CXn3H6FJkBwqpP5tiQKJYoLg
    W/cA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792692204;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=BM23w28C0QkzQA2JRplHbyEjl4bhPIjwO4EI/zhVOKc=;
    b=W6g6O2fY5/8dklWLd2dGAWiuXdn1lBCawcEa+oLC7aXtTYpvbmNCmS+JQjt4gb3QG/
    QsXYmHvI9eipWZrWKTF2DjGn5+GAvnvCO8LVT+SC+NmluC8TDXBYMID/D38x1mhZ+I3x
    o4GEMVM8vVj6tIIFUMQYYqKDGvmX8Usm3DoWMHErZd/8u/SiMfmpD0Tr88ZesBt5qHyc
    zva3qqlDC8wdMdsK3R1uefshLEfdvc3ziHkxBVFnKW5EaBzkEoA4lR6mZKcsfjjDXgxk
    oJEn2H5s82yooNkURx6UF6a0TcGDPo7ejGHDQOJycbdQL9XoBlu+FU0D4+76gaCgUgjG
    c5eQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792692204;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=BM23w28C0QkzQA2JRplHbyEjl4bhPIjwO4EI/zhVOKc=;
    b=kOg3vhIu1mN15qvkkyc8xDDwUypBREXFveofMgWnPcwGXDXCYyHUf4B9WYt89nL/ch
    dzoR/c8JCDhgmcawEJAA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZyk"
Received: from [10.176.237.181]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29MI3NbKs
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 22 Oct 2026 20:03:23 +0200 (CEST)
Message-ID: <eabb22d532ceca9177a0d674fc5afc030785f286.camel@iokpp.de>
Subject: Re: [PATCH v5 4/6] scsi: ufs: core: Fix double release in
 ufshcd_eh_timed_out()
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>,  linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Bart
 Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Bean Huo <beanhuo@micron.com>,  Peter Wang <peter.wang@mediatek.com>, Can
 Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Date: Thu, 22 Oct 2026 20:03:21 +0200
In-Reply-To: <20261022034443.3034432-5-stanleyjhu@google.com>
References: <20261022034443.3034432-1-stanleyjhu@google.com>
	 <20261022034443.3034432-5-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-10-22 at 11:44 +0800, Stanley Jhu wrote:
> In SDB mode, a command that times out during a power management
> operation can be released twice:
>=20
> 1. The command times out while its normal completion is running.
> 2. The completion path clears BIT(rq->tag) in hba->outstanding_reqs and
> =C2=A0=C2=A0 releases the command. It has not called scsi_done() yet, so
> =C2=A0=C2=A0 SCMD_STATE_COMPLETE is still clear.
> 3. ufshcd_eh_timed_out() recovers the link, sees SCMD_STATE_COMPLETE
> =C2=A0=C2=A0 clear, clears BIT(rq->tag) in hba->outstanding_reqs without =
checking
> =C2=A0=C2=A0 whether it was still set, and releases the same command a se=
cond
> =C2=A0=C2=A0 time.
>=20
> Return SCSI_EH_DONE when ufshcd_clear_outstanding_reqs() returns 0, as
> another path has already claimed the command.
>=20
> Fixes: 01d5e237b339 ("scsi: ufs: core: Handle PM commands timeout before =
SCSI
> EH")
> Cc: stable@vger.kernel.org
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Bean Huo <beanhuo@micron.cmo>
