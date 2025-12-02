Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A117C27FD7D;
	Tue,  2 Dec 2025 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691791; cv=pass; b=rmZQ2nOY30u24qVktGCXHx7+aZtJUvaYlWFsgf+MSxHvL/gi/c3oUUfudzdQ4otohGeb91bC2hUWklLuTr2GSlgIQpCRnr1QPcKts4+g1CgPHDXqIMUps1NwLRpi1Zxt2egcEKGh2t/kqQ/wAW5jWRPCgJNuoQsSYR7Cc4TIA2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691791; c=relaxed/simple;
	bh=40M7zTcLHD5zAGrB+wYHg/p5PPGvNbMzcCMVn8KfXb4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kh2zorOq8xCOKst6QhM7tRUmLZ2f8CgFHYv+AgXYiQBjwapf1oxda0oDgNvvUIrfAk7CRRi0IcYBrVpLlH7WHk5nHVjlSjCG8aRiyRcHBpnEdqJjx1vcfErrMl5RpcLcAn435qj1xmq0oUotXvhGnw5nB2RefYqdsN994FNB1ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=WupKa5vA; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=sqRs63Xo; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="WupKa5vA";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="sqRs63Xo"
ARC-Seal: i=1; a=rsa-sha256; t=1764691062; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=AkKAxrq6VS0bvc9SeIF7S43QUFVmV47f0bVftWWowT7rI4sVnEwrjFyi99VG3whUQY
    BdFA0frcjoIwg+5ifY/zTUbLJZGezzHnl/E5EwEh4O+1+hIb2DDuQtBg4c3s98kYDACS
    xy6zWGiUHmSj9OyQUhbPj3oSvaYwZiHcGbi/MOdqWR64KzQIa6GCWf1WdyVgTbOO8YHQ
    D8F+D/H4yTMP85hebrRB/7dFlPljt8atapHe3lR1C5yBmi54CBSO0jUdn50Dl1OnDj7Q
    XexjHBY4f8jBiLfcGCFq8cQMrRC6Dt/8VDJUv60WdFQqZgF5GQPp/exjfnxpU7R6Ze1A
    yu3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764691062;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=40M7zTcLHD5zAGrB+wYHg/p5PPGvNbMzcCMVn8KfXb4=;
    b=RqpQeZkNknU9q79yPSz0pYGGZaEKSCIF71hyboHT4ZQ81XflGRFf5KOT99GnngqNyV
    g83nwNYxLcOcQAD3oQYnmCT3vy4oCpKZy+1tV2KA2E5vvKUXhtek42EBBprfKSNmt7QN
    McNGEFhmjU5Cvf04i/fTGuNSSJDEy+zjNW6g0MkxA2nI5k1wqY29Ke1YxkMG3CvovUKk
    W5LQsniQMjRyj3WcTGJYYQBsLywXW7yOaR0Z2Qwnn3dDmaYh+XAbvvRoWoyJEaYXO9RD
    P5p/4BMBS+wS+iWiY6kwumYRl8DxEX8WCkWetw9QdXFTcW5l+R4CQ2r07HH2nVwLyFdn
    DNPA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764691062;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=40M7zTcLHD5zAGrB+wYHg/p5PPGvNbMzcCMVn8KfXb4=;
    b=WupKa5vAjBdydWqS7nudzIiJOTVKoJe9p7ecLFQbudV9ipgTyqBEPtqMpzXlf94ou7
    cPHH3q55JtcfN+NjC9tvhOTjU141uxt9ohixmdbmjIz18Ncg4gB1hs1yCsKtlVWv9XXw
    wZSl3FpObGdsFelC/HOA97YtDq/TwW9LaQkMRA6LQ0E2AWjDux7RrTDKVkrwtiIDsIik
    gOe6SwwFJguCbue0fcjgq+Xy894qBvcj8n22Lr0Shq8fzjOZVOPvKZNBQ4sZs2NNOZJX
    BbHqlLsYqJVqhlBJ++xA0aTA10GBYKHckwzfBoFaHznk+mJFxr9LnV3mOMEcSodw61Bk
    v82A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764691062;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=40M7zTcLHD5zAGrB+wYHg/p5PPGvNbMzcCMVn8KfXb4=;
    b=sqRs63Xo94Pi6wHmAnNlLLW6WRZiBfa2HM7av3chqDOHPH3L5X4K5z+BaKFqC6+BC+
    /iK/pJV/BuWfoN09KEBA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V02JrinhobXpQQgPDtZEKouyTfdrvIc9tfQiRAevJHfmXDbgh2w=="
Received: from [IPv6:2a01:599:914:3357:ec14:e0f9:225d:560]
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761B2FvgIPC
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 2 Dec 2025 16:57:42 +0100 (CET)
Message-ID: <391c97e5201d73438ec506b22c4724285d676697.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
From: Bean Huo <beanhuo@iokpp.de>
To: Arnd Bergmann <arnd@arndb.de>, Jens Wiklander <jens.wiklander@linaro.org>
Cc: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, avri.altman@sandisk.com, Alim Akhtar
	 <alim.akhtar@samsung.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	can.guo@oss.qualcomm.com, Bean Huo <beanhuo@micron.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel test robot
	 <lkp@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 02 Dec 2025 16:57:41 +0100
In-Reply-To: <a2addffc-6f7a-4313-a8a4-dbce2a18a2cb@app.fastmail.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
	 <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
	 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
	 <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
	 <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de>
	 <CAHUa44E5-c_rN1omhuVteBt9idz_d91r1tRKNgB2=-AWQDP2Jw@mail.gmail.com>
	 <2503bc57443042876541ab5e1f2afed8f83551e6.camel@iokpp.de>
	 <CAHUa44FeKSqRQ68FJneK_NNFNxKHWgynLpd4355GYOuJh=S0vA@mail.gmail.com>
	 <dbe51014-bb52-4ffa-976f-f3823e7c391e@app.fastmail.com>
	 <84a72d8f1a84d438fc73c35aef3966d74c027a80.camel@iokpp.de>
	 <a2addffc-6f7a-4313-a8a4-dbce2a18a2cb@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-12-02 at 16:47 +0100, Arnd Bergmann wrote:
> > > Any module that links against exported RPMB symbols should have
> > > the 'depends on RPMB || !RPMB' line to enable linking correctly.
> > > The RPMB implementation in drivers/misc on the other hand has no
> > > link-time dependency I can see, and enabling it without one of
> > > the other symbols simply means that there is a module that does
> > > nothing.
> >=20
> > I have added this option in my previous email, can you add which one yo=
u
> > prefer.
>=20
> You suggested:
> =C2=A0"1. Make RPMB not directly depend on SCSI_UFSHCD in Kconfig then,
> =C2=A0=C2=A0 Use "depends on RPMB || !RPMB" in SCSI_UFSHCD (like MMC does=
)"
>=20
> but I think we should go a step further and remove the
> 'depends on MMC' as well for consistency. Otherwise you create
> a dependency chain that makes it impossible to have UFSHCD
> built-in if MMC is a loadable module.
>=20
> =C2=A0=C2=A0=C2=A0 Arnd

Thanks, Just sent a new patch and CC you, please check.


Hi Martin, Bart, and Jens,

Following our discussion and Arnd's suggestion, I've submitted a new patch =
that
takes a different approach to fix the RPMB link error.

Martin, the new patch should handle your modular build configuration correc=
tly
while fixing the reported link error.

Thanks for all the feedback.

Best regards,
Bean

