Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC8312F5A5;
	Tue,  2 Dec 2025 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764685041; cv=pass; b=LX2+F8dwmB5RHMyGJEwXIoFbs5a3IRqJr0lWEIvwFI4xlbKHnNRhQfV6UxO+sOAs6CEGOuQ2FjQ1EpBU3Or3kMYwtMLNLhmTyW3whlvX4ZflIMMcvxXAjM7fDaFupRU+k5OeRGMUPvFOr860djasByHU5klB62OV9zuC2XuqkSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764685041; c=relaxed/simple;
	bh=XwcgQPQNyP84Ld3wZlXzCZ2Pax1mZItvUoBqkw3jH+A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=par+iS08onSIzZxaryOeQWRVsMxyul6SDtg3Fe+ICEyQrIrED/tK/cb4qrObhHQUhlwla7U91j7HLmZwdlcnh70vsSKtlrXNmea3nF5vTqti/z0SbOyrRta60+8qp1fOiXlq0Pj4YURnewKfPKIOVSH4R/YG3I5l+Skg24lj9NM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=pmFmOWrW; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=4q1KbgVM; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="pmFmOWrW";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="4q1KbgVM"
ARC-Seal: i=1; a=rsa-sha256; t=1764685028; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=eFEgzaJHHoQJID/6UP78r2WjeRBT47Uo4Z1laayKTlI3rVejXOIdsgzYjqxvZYVu/m
    tIOCuX2AFHSljzLkm6SacFPIsL/WDUwZyvOVcF6TPoCC4MAQQjfCMQ06nlJiz9IpYtaa
    2UPBKSfpvStSQq0hF8CGYhAq3T18PGe25kK53lpp/RutEDIgp1w44B9+jbrAaLMHR0dd
    ZjKM2F4HmSBNQPtXY1JIa3iqhsgGO8mkUU8K0wks8RoUXj/vBdB/B9ILNhXwdBdFt20f
    2asX5ITcGSIDOZgDVEpKoDROmil7n3VPR7Sj+FJU+2jc/EFRgfH8+3fthWsWqp3GZQtW
    acBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764685028;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XwcgQPQNyP84Ld3wZlXzCZ2Pax1mZItvUoBqkw3jH+A=;
    b=QmOXVCT2FqVqbjixpv7XH59icY/Nm0D5UhzkSR4qwFGWCgz9TokyFwdxy10NOApWao
    4mYpTgbg5rP8NmQ/6W7Bv8z2EXumlhrV6a55dT6XtjUtHnA8jKx4OhL+ElufGWHQNzvr
    ULtp7Uombl1oazpodEMbo3rTvV6N7iUj8NbeD6j8og1BW64Fq+3JPRiNWoQjAcUr6upv
    nXMpxrev3UmMe5bzHF1Xrl/JLVGsW0UOL5L7WxqKQ394ollJujce1Uf1foWHCxPv1pQG
    owWeEzirQyM1gBqV/T1h5Jv7C4Yq7sXp+5v18UCcfVwRdauUX7QbY1a8nuC3b2aoHI0X
    zqMg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764685028;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XwcgQPQNyP84Ld3wZlXzCZ2Pax1mZItvUoBqkw3jH+A=;
    b=pmFmOWrWPhbp9oCDnGwkxGjmJXpe12LsVRX8CW4rBG3c4Iis9bU3nBjgKS68H3emT7
    FJZ0NS9AFK+3UIZLDurRa5lSBPN/kXfmObYtSelneUxLdA4yX+H1rq3+J8POZyzew2l6
    H7wSIwwY6H2hwGKv9lROkZ5pGWHRBU/PYhjvTdiOxwozxKLLNnTl++uUVOIO2G91U5Qg
    AeNB+qmszfUlUawVM6JuBL+P3kYGKhX7oLgQTEYlSVEQSnATWQCT8Wygte1cGfRgr0xp
    eBn+y2JpPwxqz7MjVSMmYAjwWnKA3iYu71xp6IhvwJ7XBsDrSr296NuF86F6fitrulmA
    mTwg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764685028;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XwcgQPQNyP84Ld3wZlXzCZ2Pax1mZItvUoBqkw3jH+A=;
    b=4q1KbgVMvLjVFMt30KTjU/kCfoZtiDiJoGiRp4QgOhskwuPTLlcHGrBOj76jGsd90d
    +Db32l8avnztMWJejQCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761B2EH7HJA
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 2 Dec 2025 15:17:07 +0100 (CET)
Message-ID: <c0fe3cdb84c260ca12487a8c21b8baa172146e7c.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
From: Bean Huo <beanhuo@iokpp.de>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, avri.altman@sandisk.com,
 alim.akhtar@samsung.com,  jejb@linux.ibm.com, can.guo@oss.qualcomm.com,
 beanhuo@micron.com,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>, Ulf
 Hansson <ulf.hansson@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Date: Tue, 02 Dec 2025 15:17:06 +0100
In-Reply-To: <CAHUa44FeKSqRQ68FJneK_NNFNxKHWgynLpd4355GYOuJh=S0vA@mail.gmail.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
	 <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
	 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
	 <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
	 <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de>
	 <CAHUa44E5-c_rN1omhuVteBt9idz_d91r1tRKNgB2=-AWQDP2Jw@mail.gmail.com>
	 <2503bc57443042876541ab5e1f2afed8f83551e6.camel@iokpp.de>
	 <CAHUa44FeKSqRQ68FJneK_NNFNxKHWgynLpd4355GYOuJh=S0vA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-12-02 at 14:17 +0100, Jens Wiklander wrote:
> [+ Ulf and Arnd in CC]
>=20
> On Tue, Dec 2, 2025 at 1:17=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrote:
> >=20
> > On Tue, 2025-12-02 at 12:41 +0100, Jens Wiklander wrote:
> > > Hi,
> > >=20
> > > On Tue, Dec 2, 2025 at 10:13=E2=80=AFAM Bean Huo <beanhuo@iokpp.de> w=
rote:
> > > >=20
> > > > On Mon, 2025-12-01 at 16:53 -0800, Bart Van Assche wrote:
> > > > > On 12/1/25 2:42 PM, Bean Huo wrote:
> > > > > > On Mon, 2025-12-01 at 12:25 -0500, Martin K. Petersen wrote:
> > > > > > > > When CONFIG_SCSI_UFSHCD=3Dy and CONFIG_RPMB=3Dm, the kernel=
 fails to
> > > > > > > > link
> > > > > > > > with undefined references to ufs_rpmb_probe() and
> > > > > > > > ufs_rpmb_remove():
> > > > > > > >=20
> > > > > > > > =C2=A0=C2=A0 ld: drivers/ufs/core/ufshcd.c:8950: undefined =
reference to
> > > > > > > > `ufs_rpmb_probe'
> > > > > > > > =C2=A0=C2=A0 ld: drivers/ufs/core/ufshcd.c:10505: undefined=
 reference to
> > > > > > > > `ufs_rpmb_remove'
> > > > > > > >=20
> > > > > > > > The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates =
to
> > > > > > > > true
> > > > > > > > when CONFIG_RPMB=3Dm, causing the header to declare the rea=
l
> > > > > > > > function
> > > > > > > > prototypes.
> > > > > > >=20
> > > > > > > This now breaks the modular build for me.
> > > > > >=20
> > > > > > I tested both IS_BUILTIN and IS_REACHABLE for the RPMB dependen=
cies
> > > > > > both
> > > > > > work
> > > > > > correctly in my configuration.
> > > > > >=20
> > > > > > IS_REACHABLE would provide more flexibility for module
> > > > > > configurations,
> > > > > > but
> > > > > > in
> > > > > > practice, I don't have experience with UFS being used as a modu=
le.
> > > > > >=20
> > > > > > Would you prefer IS_REACHABLE for theoretical flexibility, or i=
s
> > > > > > IS_BUILTIN
> > > > > > acceptable given the typical UFS built-in configuration?
> > > > >=20
> > > > > Hi Martin and Bean,
> > > > >=20
> > > > > Unless someone comes up with a better solution, I propose to appl=
y
> > > > > this
> > > > > patch before sending a pull request to Linus and look into making=
 RPMB
> > > > > tristate again at a later time:
> > > > >=20
> > > > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > > > > index 9d1de68dee27..e0b7f8fb6ecb 100644
> > > > > --- a/drivers/misc/Kconfig
> > > > > +++ b/drivers/misc/Kconfig
> > > > > @@ -105,7 +105,7 @@ config PHANTOM
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 say N here=
.
> > > > >=20
> > > > > =C2=A0 config RPMB
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tristate "RPMB partition in=
terface"
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool "RPMB partition interf=
ace"
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on MMC || SCSI=
_UFSHCD
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 help
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Unified RP=
MB unit interface for RPMB capable devices such as
> > > > > eMMC
> > > > > and
> > > > >=20
> > > > > Thanks,
> > > > >=20
> > > > > Bart.
> > > >=20
> > > > Hi Bart, Martin, (and Jens - adding you to this thread),
> > > >=20
> > > > Bart, thanks for the proposed solution to change RPMB from tristate
> > > > to bool. This makes sense given our use case that UFS is typically
> > > > built-in, and RPMB should follow the same pattern.
> > > >=20
> > > >=20
> > > > Hi Jens,
> > > >=20
> > > > we wanted to make sure you're aware of this proposed change. The
> > > > reasoning
> > > > is:
> > > > 1, avoids module dependency complexity between UFS and RPMB
> > > > 2, matches typical usage where both are built-in
> > > >=20
> > > > Let me know if there are concerns with making RPMB bool instead of
> > > > tristate.
> > >=20
> > > We use "depends on RPMB || !RPMB" in drivers/tee/optee/Kconfig and
> > > drivers/mmc/core/Kconfig to handle this problem. Could the same
> > > pattern be used here?
> > >=20
> >=20
> > Jens,
> >=20
> > The pattern/dependecy used in MMC and OP-TEE doesn't apply UFS due to
> > different
> > dependency structures:
> >=20
> > MMC: The core MMC config doesn't depend on RPMB. Only MMC_BLOCK (a sub-
> > layer)
> > has "depends on RPMB || !RPMB", avoiding the cycle.
> >=20
> > OP-TEE: RPMB doesn't depend on OPTEE, so "depends on RPMB || !RPMB" in =
OPTEE
> > creates no cycle.
> >=20
> > and for UFS:
> >=20
> > UFS: This creates a direct circular dependency:
> >=20
> > drivers/misc/Kconfig: RPMB depends on SCSI_UFSHCD
> > drivers/ufs/Kconfig: SCSI_UFSHCD depends on RPMB
> >=20
> > This is why Bart's suggestion to make RPMB bool instead of tristate may=
 be
> > the
> > cleaner solution.
> >=20
>=20
> What will that mean for OPTEE and MMC? That they can't be modules if
> RPMB is enabled?=C2=A0

making RPMB bool would force it to be built-in, losing the modularity that =
MMC
and OPTEE currently have.

I'm wondering if the RPMB Kconfig dependency on SCSI_UFSHCD is necessary, o=
r if
it's just expressing "RPMB needs a backend"?

Could we:
1. Make RPMB not directly depend on SCSI_UFSHCD in Kconfig then, Use "depen=
ds on
RPMB || !RPMB" in SCSI_UFSHCD (like MMC does)
2. Use IS_REACHABLE or IS_BUILTIN in the code

This would preserve RPMB modularity while handling the dependency correctly=
.
Thoughts?



> Are we moving the problem somewhere else?

No, we thought RPMB is a security feature, where built-in is often preferre=
d.
what kind of senarios which need to make RPMB as moudle, do you know?



Kind regards,
Bean


>=20
> Cheers,
> Jens

