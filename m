Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6865A23B60A;
	Wed,  3 Dec 2025 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779018; cv=pass; b=V/qCVMJbPwzUrzdotgoO9Jb7aSBYjWeaxP08IF65+OWfF1WL85KMGBpFPNZCvvMJXQ2ckZPkYXbeQ31vC6RQPrEZGD2GCZuaYxrxPFrH1B2k7DOeV1tDvs1j4TkAH1A1rCGdK8AF6QYsLX1mosz+U9ufp6yPS5RHMfrw+YSNWnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779018; c=relaxed/simple;
	bh=AgU6gFpwsobo1glwGaBKe/j34OdWgBCKsQmCYiKCgi4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BkHOvaWb0164MijjTfm041LF9/b1pDR/mSNsW4cQlzFbLp7ZddWWeempMzycsVgTJQFvO8ev1hiNb/m+VmAbwx15vCG2PxZB0skKsUM0yGdKM8vYDKs9SW54GpiTKb1rMwETb8ONS5ManEs7wYsNBMfQbfNvEwtPMq/MV+oqO4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=S/bclzZ4; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=XHedW1jf; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="S/bclzZ4";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="XHedW1jf"
ARC-Seal: i=1; a=rsa-sha256; t=1764779004; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=VOq2EcfupwL15ph0upZ8yUpYh8Lc/upjOzqNgaUlHXv01oi2+13gVoXLqYwLJrZ0VF
    sY/B6ZxW3CI3zJTtb4hlDT7QtWjtF02vzqxwYaRBhmJPLea71LYZ9tpH15Y99TCv3In5
    Rd47PB7hx/1hMN6KwearCDy7sy6vXyHgZrRByQT2AN6TAhOHUHclWAQvWe8+gRiPzeB1
    8qCTPx84MqLHeNzJNliDrrcVqHufHONf8sQJKxJ/OfgXgvxNkhGXBlyjgjg12mwnOtbD
    hF0O50bs3NMVtgcK8hdqfZQN3gXHZnrFoIz183MD7W+XQZOnEzXqCy9T/hmrWunlviKV
    z1Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764779004;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=+CX5l/3isfMmE9SgsHes2OD1Y2tTNqM+qL2iJH/Takc=;
    b=A6gxDCITemx4Wk6yJYz4CvEWcSHzKtR7WMjWTzDI1PtCjFc+wwjQBDAEOEILxJQ34r
    AhjDAvrhzcDYIbvhyJFev/MbsohfpxB+d4BaOEBMejhQN2umOvN20cVQprlw+suW09Bz
    +6u3ehuhp8W1a/DlV1d5Be7Q2E9bX1vcpUgGp9N/x5O9ZYAcpp0EPThfoFWBA4EeJTDa
    /M9DMK+hLzqZPJlIHmf0Qn6bdtqxbYqWLQlzIoAvXSFISsgs0WrAwJCCLEBY5ZAmrO/y
    X8Iy6lZpCvUmzrlyuWstHs2kzeGXf81reEFZb7ETzBe3DWdwnWZLbLaLPzFH+Mvd0hbF
    26rw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764779004;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=+CX5l/3isfMmE9SgsHes2OD1Y2tTNqM+qL2iJH/Takc=;
    b=S/bclzZ4QHGLAEpEdX25Y7KqVUnT9UC4KHsUZmlu3j5bljpYzTMvsTLZUk1uRjoOpd
    gclil0wnTEv6dw0QDKBKyR+0b2MnZWWK8l69heHd0k2EoMLVFeh5rr6YEHLEatDyd7En
    iUPkKb/amqW+UPEout37ykkeev6osZxh7cB8wG23AblbLBcVGvJW4unIpDWGnuJOH/CO
    c/LTwOTfNvrsG6lqTyYhU2NFDs0F4CyfDC2Oo73BTIAiSEb92Svnkugt6ToejwAGKwDS
    Xrx5mLxuo3s39izZkmABHQQ+NslBLCiQlJVW3ntJDJPC4dUM3RQnaVYk3Rk1UyjZKM+R
    zosw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764779004;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=+CX5l/3isfMmE9SgsHes2OD1Y2tTNqM+qL2iJH/Takc=;
    b=XHedW1jf0Mr2uLZbj7jZILLwwC3tX6Rvk/cuYC8xM3D+iXubsSJGyiGu5XjbE0ojg5
    xWp+O9rqEwfo56mRfmCw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761B3GNNNqR
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 3 Dec 2025 17:23:23 +0100 (CET)
Message-ID: <fff872d022550536f05c181ad58577889af0b5ef.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
From: Bean Huo <beanhuo@iokpp.de>
To: Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>, 
 avri.altman@sandisk.com, Bart Van Assche <bvanassche@acm.org>, Alim Akhtar
 <alim.akhtar@samsung.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 can.guo@oss.qualcomm.com, Bean Huo <beanhuo@micron.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2025 17:23:22 +0100
In-Reply-To: <98ac8e0b-6027-4f6d-b5cf-b9ad9c856ecf@app.fastmail.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
	 <202512031316.SvDwnvhy-lkp@intel.com>
	 <98ac8e0b-6027-4f6d-b5cf-b9ad9c856ecf@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-12-03 at 15:39 +0100, Arnd Bergmann wrote:
> On Wed, Dec 3, 2025, at 07:15, kernel test robot wrote:
> >=20
> > All errors (new ones prefixed by >>):
> >=20
> > > > drivers/ufs/core/ufs-rpmb.c:135:5: error: redefinition of
> > > > 'ufs_rpmb_probe'
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 135 | int ufs_rpmb_probe(struct ufs_hba =
*hba)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=
=A0=C2=A0 ^
> > =C2=A0=C2=A0=C2=A0 drivers/ufs/core/ufshcd-priv.h:445:19: note: previou=
s definition is here
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 445 | static inline int ufs_rpmb_probe(s=
truct ufs_hba *hba)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ^
> > > > drivers/ufs/core/ufs-rpmb.c:234:6: error: redefinition of
> > > > 'ufs_rpmb_remove'
>=20
> The declaration and definitio are inconsistent: the former is inside of
> an #ifdef block, the latter is not. I think either way works, but it
> needs to be the same for both.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 Arnd


Hi Arnd,

I was reviewing the kernel test robot output regarding the ufs_rpmb_probe a=
nd
ufs_rpmb_remove redefinition errors, and I wanted to clarify my understandi=
ng

From what I see in the source:

  =20
   #if IS_ENABLED(CONFIG_RPMB)
   int ufs_rpmb_probe(struct ufs_hba *hba);
   void ufs_rpmb_remove(struct ufs_hba *hba);
   #else
   static inline int ufs_rpmb_probe(struct ufs_hba *hba) { return 0; }
   static inline void ufs_rpmb_remove(struct ufs_hba *hba) { }
   #endif

my understanding is that if CONFIG_RPMB=3Dn, compilation goes into the #els=
e
branch, which emits static inline stubs, so ufs-rpmb.c should not be compil=
ed at
all because of ufshcd-core-$(CONFIG_RPMB) +=3D ufs-rpmb.o in the Makefile.

However, the robot reported redefinition errors, which suggests that the
header=E2=80=99s #else branch is being included while ufs-rpmb.c is also be=
ing compiled.

I=E2=80=99m wondering if I=E2=80=99m missing something about the robot=E2=
=80=99s build logic.


Thanks,
Bean


