Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4813B3242B6;
	Tue,  2 Dec 2025 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764690468; cv=none; b=CP/Y9iulM7Uvz+0ZYssaqpcFGyqZsp/cNLM3KAEsD5vGWiRuARuPpiTXEqd/BORg8j3hRX8Hbo4Exdu7Ktzaq3IxHyPuyyLEk7a+3GeGVM5B984Oe6OQMiDLQZojnyjyy6ppSXOC/jLw+04pE//sVDfeKaZQrKt54YIEUomB620=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764690468; c=relaxed/simple;
	bh=Lm/6QSAd8ANsW/rU+YcLvKUncXFMuZJr5KF7aeyJJok=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ZXn/sbPkZ5AOroF62RHCgUg5PsZkxK1e4eoWRKwtbCwNmVrvZxZQRTdeJ5p/3dA5CvmoKqrWHlFtBnkZQsOKE1/VlHTTKl3JEat2ZcwjawVShDGu8w6fGPNt1+SynTWlVgvfdx+pM462wYlSQsIAzcV9FtnkVVdIczfVezisWHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=R3dT73b8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JVXi5DRT; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="R3dT73b8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JVXi5DRT"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D3CD67A016F;
	Tue,  2 Dec 2025 10:47:43 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Tue, 02 Dec 2025 10:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764690463;
	 x=1764776863; bh=18wtzP6qrZ6M0nTK1OhNDWh0PfYctUKDNXXgcYvjQZg=; b=
	R3dT73b8Cjy4xyH3dvr87K36NJQB554a3JN/py20QdxjTp4IB94aeDIafaXiTfb2
	luOOWVf+JbfMHg9RhoOD2XQ9HvywR7T8JxR48ceaqbkuOfhC5sVUuCg5GlILNZ2v
	UN7Gj6z3zgE68rStmK6t3fpNhTyCPvVqXi59aTBWiBN2dH7FaISpEvUpHF3kmGgE
	WS7pKLSI4qKyMwC3P12CXxt7mYn5ttCNvKWc+BYdffFQQIs5nryUKFDtRdPE1/e8
	GpsrJQwD+p1miOmnHuRi5shiY/kv76l2zV7JolZm2yzZkB+9rHpYkSmBo3+jJgyw
	UINSuJuZVwm1uKJTWk9Q2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764690463; x=
	1764776863; bh=18wtzP6qrZ6M0nTK1OhNDWh0PfYctUKDNXXgcYvjQZg=; b=J
	VXi5DRTc2vicy6xcHEkIs8lrM8VU9lt9sQoAxFi0uLQMxFUwxfFOf5nbfSBmaR27
	FB04No51LUapu1BliQNhhWUu4FIFgYBk+zte/5b4PFMevhiioEfGB2IYDk9DpffL
	Zf0HCMxWj2ryglCfqV84mLol9/2bE1QwIQmtnNnA7pl0N58IeYDQrcLNSef4H17I
	h5IOK5Yy4zX57pwKttGMCvfPOYY8k0XHInbF3f8mloN5NUwpRaImNCDsTlPQiw/r
	595mWGkAH9SKTnMn5WARCuWE71Irq5f6ORXstYU5jWaA1TDE88pdU5VPLuuS3Kp+
	ByNMgnfT2Fccp52oApMUw==
X-ME-Sender: <xms:HgovaY251uvykeL9Bi1PPNtsJ5C5T5P6GuHYrCAKlTGM7KrLBBMPJQ>
    <xme:Hgovad6CrISzTuDsHMl1RDZ_e9qesRQd4FoMfzlSZOgGWYK1elOiiczY0EkRtNu7A
    jxjJkGJPOgvmI_THaP6P7X6TdtGTnUulWz5gCl6zZuH7177-hpuRBU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegrihhl
    ohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpe
    foggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhhnugcuuegv
    rhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrhhnpe
    dvhfdvkeeuudevfffftefgvdevfedvleehvddvgeejvdefhedtgeegveehfeeljeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrg
    hrnhgusgdruggvpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtohepsghvrghnrghsshgthhgvsegrtghmrdhorhhgpdhrtghpthhtoheplhhkph
    esihhnthgvlhdrtghomhdprhgtphhtthhopegsvggrnhhhuhhosehiohhkphhprdguvgdp
    rhgtphhtthhopehjvghnshdrfihikhhlrghnuggvrheslhhinhgrrhhordhorhhgpdhrtg
    hpthhtohepuhhlfhdrhhgrnhhsshhonheslhhinhgrrhhordhorhhgpdhrtghpthhtohep
    jhgvjhgssehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtohepsggvrghnhhhuohesmh
    hitghrohhnrdgtohhmpdhrtghpthhtohepmhgrrhhtihhnrdhpvghtvghrshgvnhesohhr
    rggtlhgvrdgtohhmpdhrtghpthhtoheptggrnhdrghhuohesohhsshdrqhhurghltghomh
    hmrdgtohhm
X-ME-Proxy: <xmx:HgovadxAKZneDLt0_RaJz-KPHKj5iH0YcPftzyIjPwNzqVgZN4bHSQ>
    <xmx:HgovaSeNJgrGO-7L_zaGuhlloi_fkr5KmQlncHd7HrfoqH_iyxkZTA>
    <xmx:HgovaaurmQaiJMyLScRNePZhnXR4l5PGiQAO5k3pBRd6gf7R3EmeFw>
    <xmx:HgovafD4awmlpKmJ2lfNlvf4XLWJsFrVF0i7a0OsBQUwVfmUfBsX7A>
    <xmx:Hwovaauu1M6m905ZJKXzYv9O-CZ0pDI_aUrfRcp1SR15OAtefLMbJ3fM>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B5A0DC40054; Tue,  2 Dec 2025 10:47:42 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ALO74ngA5rV3
Date: Tue, 02 Dec 2025 16:47:22 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Bean Huo" <beanhuo@iokpp.de>,
 "Jens Wiklander" <jens.wiklander@linaro.org>
Cc: "Bart Van Assche" <bvanassche@acm.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, avri.altman@sandisk.com,
 "Alim Akhtar" <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>, can.guo@oss.qualcomm.com,
 "Bean Huo" <beanhuo@micron.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, "kernel test robot" <lkp@intel.com>,
 "Ulf Hansson" <ulf.hansson@linaro.org>
Message-Id: <a2addffc-6f7a-4313-a8a4-dbce2a18a2cb@app.fastmail.com>
In-Reply-To: <84a72d8f1a84d438fc73c35aef3966d74c027a80.camel@iokpp.de>
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
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025, at 15:59, Bean Huo wrote:
> On Tue, 2025-12-02 at 14:25 +0100, Arnd Bergmann wrote:
>> On Tue, Dec 2, 2025, at 14:17, Jens Wiklander wrote:
>> > > > > >=20
>> > > > > > =C2=A0 config RPMB
>> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tristate "RPMB partit=
ion interface"
>> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool "RPMB partition =
interface"
>> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on MMC |=
| SCSI_UFSHCD
>> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 help
>> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Unif=
ied RPMB unit interface for RPMB capable devices such
>> > > > > > as
>>=20
>> This equally does not seem appropriate, as others have commented.
>>=20
>
> the qeustions do we need to make RPMB as a module?

I think generally speaking, yes: Everything that can be made a
loadable module should be configurable that way.

>> > What will that mean for OPTEE and MMC? That they can't be modules if
>> > RPMB is enabled? Are we moving the problem somewhere else?
>>=20
>> My first impression is that the 'depends on MMC || SCSI_UFSHCD' is
>> the problem here, and I would suggest simply dropping that dependency.
>>=20
>
>> Any module that links against exported RPMB symbols should have
>> the 'depends on RPMB || !RPMB' line to enable linking correctly.
>> The RPMB implementation in drivers/misc on the other hand has no
>> link-time dependency I can see, and enabling it without one of
>> the other symbols simply means that there is a module that does
>> nothing.
>
> I have added this option in my previous email, can you add which one y=
ou prefer.

You suggested:
 "1. Make RPMB not directly depend on SCSI_UFSHCD in Kconfig then,
   Use "depends on RPMB || !RPMB" in SCSI_UFSHCD (like MMC does)"

but I think we should go a step further and remove the
'depends on MMC' as well for consistency. Otherwise you create
a dependency chain that makes it impossible to have UFSHCD
built-in if MMC is a loadable module.

    Arnd
