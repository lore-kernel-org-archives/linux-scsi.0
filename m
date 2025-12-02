Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD92AD00;
	Tue,  2 Dec 2025 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764687767; cv=pass; b=rGMJVmNv/uUAu99gjktmcSKZRS0BN1J6Z4FyZ//EDA2HZxsdVNumtiGQTUqyED08RnvbcptxyJfKJoniuB3zISBRLKB+GXuiyAszzJZK8/v/n+iPgOVB5kR/7m9oPp1pgzp+gUmDxY7UjW4FhN/K54Q6Nc8x7ue0aInExzh1d5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764687767; c=relaxed/simple;
	bh=kYqxU7eIJ0/gC7lvlCjNInhrHE6zifIAC3ZFyKHYlqM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=okqiLBQMEweqlTrZE4O0UyzZMZGrbEjBYhjP5ygzEkj0QT5lbZ8wOD/Pjl/d0dbeogzNaef7aGm2PpPFdZpRzCCemD7rPgo7F39CT/uUIGh8BzlmgJolj9MRzrA8XdaU37YdyEAoqGwbSdGmkWpm3KSG6T6t1h88IZGxGS2Dadk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Z9iSz4xB; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=D4p9UJwh; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Z9iSz4xB";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="D4p9UJwh"
ARC-Seal: i=1; a=rsa-sha256; t=1764687571; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=THZg2bdTln7j1ufzUq9Q1R0g+C0c5cuUpfVKNtIJwRjAAZOUuxACuTkugMF21T7D8u
    LVoZBXrW9Ouptt03PQAGYf0M9eZGt9YyN7271Vh13nG29BsTHwGODSFXMJbu/7K6VU2u
    4KmZPw/jSh/vGvp3qa22EhOUOJ2KriERzakfi27bVjjVnVCZHYEB0ZvUz1hzxi6Fzgh4
    Dqnikh6TmnFh/gK+211m+cu8nTHunYgNiDyDhcPa7h1OPrL77Txv23VqgGtTn1vZsd9g
    SOuckLHJiKaSNdlks6xfw4uFn5S1gF2jrX8RyvezGUhci6v7PqH+O0xLfbbqVa68Ipv5
    oVXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764687571;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=kYqxU7eIJ0/gC7lvlCjNInhrHE6zifIAC3ZFyKHYlqM=;
    b=QSKCilVoIYfBGE1H4iGjaoz91ch/iDcb1DGbaJTqxlV1wPKRGTPnMhjzkNksnVr+Q2
    Kp9I4JfmGiL6dpNPILmh9Z5NJmgdIWTZ5/DzKMyi9J8dSyCTqIR1MJRTgHMWssNjiA8b
    jDaUGV45RK97Z3EsALiAKieo6QACLHDnqVCIQf+mNEcV6Ni1sU8CL1RXob5bGpLDwgIM
    1C+sIETQlvyd2bJuaNWB8PlutbLNJz81qW/hdnSaM1lWG4SnvfmmTypi+O5CBsgWIyOJ
    TfbNeIsV9wGi7/5/xvb3npSwNhDm3GGxMv5EABHu3N5bYawSFN2Se1m5S0hkMma0bOYC
    mL9A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764687571;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=kYqxU7eIJ0/gC7lvlCjNInhrHE6zifIAC3ZFyKHYlqM=;
    b=Z9iSz4xBr+GOAJgxUX/XW0WTBzug12LFuCBGYouLm8HY7f+DMv4z420MDRbQdp4UGR
    Fq6fZpNwddz0kK08oPkjtwGHdA9lk8SqIaWAkRPyQ+v4r2v+KcqD/8wKKlIqF6FOtTs0
    oXsD/LeVr6jtnF1wIouyCghFrTPw/UyRh+GneduJAEg1rdmJuVCtnCuSSSA5gTCIn/WR
    106K5BrRMyZvFBUbnJY3AumdmqEYOItLidDbzFClv3X9DtFS2TWQ2hjpkGCe/1F/ltdl
    ZDYGJYFZM/zY5Ii1oYeI6nLm2P32RnXkUKb7tAfhUUydTkGaeEOfFQtMUQDv54AGEfYu
    LvAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764687571;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=kYqxU7eIJ0/gC7lvlCjNInhrHE6zifIAC3ZFyKHYlqM=;
    b=D4p9UJwhf7eYt/sAalj+gXG5TkInb2hLU9uB3MxPnWY6kjJU1PUNUNPPp0Umte5Pl8
    ILlXpeLwKvw6qlUgy3Cg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761B2ExVHcZ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 2 Dec 2025 15:59:31 +0100 (CET)
Message-ID: <84a72d8f1a84d438fc73c35aef3966d74c027a80.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
From: Bean Huo <beanhuo@iokpp.de>
To: Arnd Bergmann <arnd@arndb.de>, Jens Wiklander <jens.wiklander@linaro.org>
Cc: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, avri.altman@sandisk.com, Alim Akhtar
	 <alim.akhtar@samsung.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	can.guo@oss.qualcomm.com, Bean Huo <beanhuo@micron.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel test robot
	 <lkp@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 02 Dec 2025 15:59:30 +0100
In-Reply-To: <dbe51014-bb52-4ffa-976f-f3823e7c391e@app.fastmail.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
	 <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
	 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
	 <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
	 <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de>
	 <CAHUa44E5-c_rN1omhuVteBt9idz_d91r1tRKNgB2=-AWQDP2Jw@mail.gmail.com>
	 <2503bc57443042876541ab5e1f2afed8f83551e6.camel@iokpp.de>
	 <CAHUa44FeKSqRQ68FJneK_NNFNxKHWgynLpd4355GYOuJh=S0vA@mail.gmail.com>
	 <dbe51014-bb52-4ffa-976f-f3823e7c391e@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-12-02 at 14:25 +0100, Arnd Bergmann wrote:
> On Tue, Dec 2, 2025, at 14:17, Jens Wiklander wrote:
> > On Tue, Dec 2, 2025 at 1:17=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrot=
e:
> > > On Tue, 2025-12-02 at 12:41 +0100, Jens Wiklander wrote:
> > > > > > >=20
> > > > > > > Would you prefer IS_REACHABLE for theoretical flexibility, or=
 is
> > > > > > > IS_BUILTIN
> > > > > > > acceptable given the typical UFS built-in configuration?
> > > > > >=20
>=20
> I did introduce IS_REACHABLE() a long time ago, but I consider it
> the wrong approach for almost every possible case, as it only
> works around link failures by introducing very unexpected runtime
> behavior.

thanks for your info.

>=20
> > > > > > Unless someone comes up with a better solution, I propose to ap=
ply
> > > > > > this
> > > > > > patch before sending a pull request to Linus and look into maki=
ng
> > > > > > RPMB
> > > > > > tristate again at a later time:
> > > > > >=20
> > > > > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > > > > > index 9d1de68dee27..e0b7f8fb6ecb 100644
> > > > > > --- a/drivers/misc/Kconfig
> > > > > > +++ b/drivers/misc/Kconfig
> > > > > > @@ -105,7 +105,7 @@ config PHANTOM
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 say N he=
re.
> > > > > >=20
> > > > > > =C2=A0 config RPMB
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tristate "RPMB partition =
interface"
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool "RPMB partition inte=
rface"
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on MMC || SC=
SI_UFSHCD
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 help
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Unified =
RPMB unit interface for RPMB capable devices such
> > > > > > as
>=20
> This equally does not seem appropriate, as others have commented.
>=20

the qeustions do we need to make RPMB as a module?

> > > > >=20
> > > > > we wanted to make sure you're aware of this proposed change. The
> > > > > reasoning
> > > > > is:
> > > > > 1, avoids module dependency complexity between UFS and RPMB
> > > > > 2, matches typical usage where both are built-in
> > > > >=20
> > > > > Let me know if there are concerns with making RPMB bool instead o=
f
> > > > > tristate.
> > > >=20
> > > > We use "depends on RPMB || !RPMB" in drivers/tee/optee/Kconfig and
> > > > drivers/mmc/core/Kconfig to handle this problem. Could the same
> > > > pattern be used here?
>=20
> This does sound like the right idea.
>=20
> > > The pattern/dependecy used in MMC and OP-TEE doesn't apply UFS due to
> > > different
> > > dependency structures:
> > >=20
> > > MMC: The core MMC config doesn't depend on RPMB. Only MMC_BLOCK (a su=
b-
> > > layer)
> > > has "depends on RPMB || !RPMB", avoiding the cycle.
> > >=20
> > > OP-TEE: RPMB doesn't depend on OPTEE, so "depends on RPMB || !RPMB" i=
n
> > > OPTEE
> > > creates no cycle.
> > >=20
> > > and for UFS:
> > >=20
> > > UFS: This creates a direct circular dependency:
> > >=20
> > > drivers/misc/Kconfig: RPMB depends on SCSI_UFSHCD
> > > drivers/ufs/Kconfig: SCSI_UFSHCD depends on RPMB
> > >=20
> > > This is why Bart's suggestion to make RPMB bool instead of tristate m=
ay be
> > > the
> > > cleaner solution.
> > >=20
> >=20
> > What will that mean for OPTEE and MMC? That they can't be modules if
> > RPMB is enabled? Are we moving the problem somewhere else?
>=20
> My first impression is that the 'depends on MMC || SCSI_UFSHCD' is
> the problem here, and I would suggest simply dropping that dependency.
>=20

> Any module that links against exported RPMB symbols should have
> the 'depends on RPMB || !RPMB' line to enable linking correctly.
> The RPMB implementation in drivers/misc on the other hand has no
> link-time dependency I can see, and enabling it without one of
> the other symbols simply means that there is a module that does
> nothing.

I have added this option in my previous email, can you add which one you pr=
efer.

Kind regards,
Bean

>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 Arnd

