Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDBD1F30A4;
	Tue,  2 Dec 2025 12:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764677863; cv=pass; b=D+a9oO3cTHleDyXpQw2YzsfeeZRPJlqjju0bdLShHN9HqvRGYr006Pfcm/r8tBotDUfBCe9K6kktIMY6CAd8Fres2wOzMwPJ8NLqGIDynWg478TgKXDjwJ8lc+mLQt9N8CsdiQjhtgB1YUMTl9dQh05Nt9f06wc6Suh+8SPh0y0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764677863; c=relaxed/simple;
	bh=tDUmmlTBnRXUIJ/rLyUlDUSGKvvpLDrYZ1CBonYSmAA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dnc0xQuMnok5LE/4WV9au+0+TCZk/WBNlrmyRR+dQEKbflv6uo9SRaTLzE2peDaFOhoyUC4rsZ3OY5Dkkd1qvYJm7DwgS4387+WX4fmQsej+NL+2/W5mY3tqS8qdeXrIaoqGiitZjdOtHz2cd5mRwIBGeHnt7dk7G9biEL5rPok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=pyuqGhls; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=TXr0mGFu; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="pyuqGhls";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="TXr0mGFu"
ARC-Seal: i=1; a=rsa-sha256; t=1764677847; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Qn5lMhL7EyG+woxJGEA4tXorj3rA9GKMpu5WcO6DZl5asEqRgR3Z54xRivJHu/7RpA
    9cxy/+3EqMm+hfq0pPiEdop2rcps8TCdTTFwC45b6gjajviuctgUwQouxVTr+zPBKIII
    5Peds8T06CTiv7wGFnvBILjouqNhxPjAqgi5ChIlqmFOWpcXhUt2bccBvpPK0+4rHZTY
    799AT3czDQecpHWv8ZCx5NFjpAS0Thmg8b8RQJlokPuyNA/h9bt04vNnGTKwx+ArBd9P
    iv7+5JxOosE7phL6SczR4dyXF+b2TO9uuobuXXOkfBv8yNDcg/NuXDPvb9pTRDBQPrlc
    jpxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764677847;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=tDUmmlTBnRXUIJ/rLyUlDUSGKvvpLDrYZ1CBonYSmAA=;
    b=Qo/wFRQ3n4q755Qp4tvMzww5SY+kfP40RUBo5ztRnDw8BcGBplQ2hQcvpo7Jf0ngxs
    ybLRUslwMXpBySnjRH+SiFcT+G3urt8wn7PBbUGbgGV3lumDCeKNgPAxRgxK1D8pFmvk
    iVpnw/feLOtRaPtM4EVqF8mhdg7bMa78BUwJUIJgwCmT243gdVlP1cZBWBKzFzEpXpbf
    CSmBXTHGmvxAkOJ3sQEEtId32teQegTDYeQCQMXLfHL0+TaqyDalhpQ7KopnuMep+3Qp
    Er7piapw37cF37D3x48YNSGbcdX0E5M83sujNyVyg0nAmdjpXSRouC2ZLG2DFLAhTEGx
    S05A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764677847;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=tDUmmlTBnRXUIJ/rLyUlDUSGKvvpLDrYZ1CBonYSmAA=;
    b=pyuqGhlsJdmG3rxjUbf+9uwWPVm2EBnykqj/jbmxEkdHXSiid6+sAdSut1P3sACSrR
    avNKutnl2eDn7xdgEHJX9wDsXXn/ND9ONrmamMjgumrwr7MISy6+2AtUDewMjI/IJJeD
    fJznYgHe/f4QURSFqUMDUm8tP30Kq1q+oJu6PT1DJsJkZWBbRNNgwPl/i70I+3vq/kQG
    QCHDYJzOJtLqzpQi9XkcU1Cqf0iMEKlYfxrbhYKXnSWDs378boUfescL46xDRDuGeq0a
    G+bHhY6otoD9hrbJY0BAg4Q/OhmOnOFA2njbuQD5437DK08WUakRH7Cc0b4HaGvB1rlZ
    DEDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764677847;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=tDUmmlTBnRXUIJ/rLyUlDUSGKvvpLDrYZ1CBonYSmAA=;
    b=TXr0mGFub3f3Z8kXg0EjQzbc71btCKG/p5vGEJg1rIp36CwE9HRGnitnpnn4ORFeQ/
    OvlQsn2VmEohc7VIgNDg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761B2CHQGY2
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 2 Dec 2025 13:17:26 +0100 (CET)
Message-ID: <2503bc57443042876541ab5e1f2afed8f83551e6.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
From: Bean Huo <beanhuo@iokpp.de>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, avri.altman@sandisk.com,
 alim.akhtar@samsung.com,  jejb@linux.ibm.com, can.guo@oss.qualcomm.com,
 beanhuo@micron.com,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Date: Tue, 02 Dec 2025 13:17:25 +0100
In-Reply-To: <CAHUa44E5-c_rN1omhuVteBt9idz_d91r1tRKNgB2=-AWQDP2Jw@mail.gmail.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
	 <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
	 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
	 <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
	 <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de>
	 <CAHUa44E5-c_rN1omhuVteBt9idz_d91r1tRKNgB2=-AWQDP2Jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-12-02 at 12:41 +0100, Jens Wiklander wrote:
> Hi,
>=20
> On Tue, Dec 2, 2025 at 10:13=E2=80=AFAM Bean Huo <beanhuo@iokpp.de> wrote=
:
> >=20
> > On Mon, 2025-12-01 at 16:53 -0800, Bart Van Assche wrote:
> > > On 12/1/25 2:42 PM, Bean Huo wrote:
> > > > On Mon, 2025-12-01 at 12:25 -0500, Martin K. Petersen wrote:
> > > > > > When CONFIG_SCSI_UFSHCD=3Dy and CONFIG_RPMB=3Dm, the kernel fai=
ls to
> > > > > > link
> > > > > > with undefined references to ufs_rpmb_probe() and ufs_rpmb_remo=
ve():
> > > > > >=20
> > > > > > =C2=A0=C2=A0 ld: drivers/ufs/core/ufshcd.c:8950: undefined refe=
rence to
> > > > > > `ufs_rpmb_probe'
> > > > > > =C2=A0=C2=A0 ld: drivers/ufs/core/ufshcd.c:10505: undefined ref=
erence to
> > > > > > `ufs_rpmb_remove'
> > > > > >=20
> > > > > > The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates to t=
rue
> > > > > > when CONFIG_RPMB=3Dm, causing the header to declare the real fu=
nction
> > > > > > prototypes.
> > > > >=20
> > > > > This now breaks the modular build for me.
> > > >=20
> > > > I tested both IS_BUILTIN and IS_REACHABLE for the RPMB dependencies=
 both
> > > > work
> > > > correctly in my configuration.
> > > >=20
> > > > IS_REACHABLE would provide more flexibility for module configuratio=
ns,
> > > > but
> > > > in
> > > > practice, I don't have experience with UFS being used as a module.
> > > >=20
> > > > Would you prefer IS_REACHABLE for theoretical flexibility, or is
> > > > IS_BUILTIN
> > > > acceptable given the typical UFS built-in configuration?
> > >=20
> > > Hi Martin and Bean,
> > >=20
> > > Unless someone comes up with a better solution, I propose to apply th=
is
> > > patch before sending a pull request to Linus and look into making RPM=
B
> > > tristate again at a later time:
> > >=20
> > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > > index 9d1de68dee27..e0b7f8fb6ecb 100644
> > > --- a/drivers/misc/Kconfig
> > > +++ b/drivers/misc/Kconfig
> > > @@ -105,7 +105,7 @@ config PHANTOM
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 say N here.
> > >=20
> > > =C2=A0 config RPMB
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tristate "RPMB partition interf=
ace"
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool "RPMB partition interface"
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on MMC || SCSI_UFS=
HCD
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 help
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Unified RPMB u=
nit interface for RPMB capable devices such as
> > > eMMC
> > > and
> > >=20
> > > Thanks,
> > >=20
> > > Bart.
> >=20
> > Hi Bart, Martin, (and Jens - adding you to this thread),
> >=20
> > Bart, thanks for the proposed solution to change RPMB from tristate
> > to bool. This makes sense given our use case that UFS is typically
> > built-in, and RPMB should follow the same pattern.
> >=20
> >=20
> > Hi Jens,
> >=20
> > we wanted to make sure you're aware of this proposed change. The reason=
ing
> > is:
> > 1, avoids module dependency complexity between UFS and RPMB
> > 2, matches typical usage where both are built-in
> >=20
> > Let me know if there are concerns with making RPMB bool instead of tris=
tate.
>=20
> We use "depends on RPMB || !RPMB" in drivers/tee/optee/Kconfig and
> drivers/mmc/core/Kconfig to handle this problem. Could the same
> pattern be used here?
>=20

Jens,

The pattern/dependecy used in MMC and OP-TEE doesn't apply UFS due to diffe=
rent
dependency structures:

MMC: The core MMC config doesn't depend on RPMB. Only MMC_BLOCK (a sub-laye=
r)
has "depends on RPMB || !RPMB", avoiding the cycle.

OP-TEE: RPMB doesn't depend on OPTEE, so "depends on RPMB || !RPMB" in OPTE=
E
creates no cycle.

and for UFS:=20

UFS: This creates a direct circular dependency:

drivers/misc/Kconfig: RPMB depends on SCSI_UFSHCD
drivers/ufs/Kconfig: SCSI_UFSHCD depends on RPMB

This is why Bart's suggestion to make RPMB bool instead of tristate may be =
the
cleaner solution.


Kind regards,=20
Bean




