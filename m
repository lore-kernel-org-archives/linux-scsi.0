Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF81313520;
	Tue,  2 Dec 2025 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764681973; cv=none; b=a7WRqeD/y230Sx6wNepn2ZZMVw1cqE62j3aRsluTqSxGQiC/eGypYDLfDEOKyPlHU7lHfahdj/DqfmKjIo1Oe32rIpphasGTNWk5vaJhbtBx4ImQOi6Jc4cy3KSgunRSl4hDDBGAY/aXSWix0zgYRwGf0TTHZEG4CEZrBjlJaWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764681973; c=relaxed/simple;
	bh=CHc9aaJz8hZzsIJqQH9C8NiyhBH3rRyq1b2fNHLTh7o=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=KYF64gxS/LIBZRzKkoVtMydKNDzcmuj8d/KE8utgouZzW7kqsfNoTSdiIKZo5x9yQCCrQL/dUAmtx8GZ/wB2+LEaRYI/Hv3mB/4GQyRQaHrHRWjlMD9/92d+8KNcXffACU1WAP3oh8TFCHTNnIaKt6QoIEb+BUU0OCvoSmQzdjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=f0+PyGIM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xdD6Yjo2; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="f0+PyGIM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xdD6Yjo2"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 193261D001CE;
	Tue,  2 Dec 2025 08:26:06 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Tue, 02 Dec 2025 08:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764681965;
	 x=1764768365; bh=MRAoT9qWoRC6LttNlZzM263sM8o01pvLPAc/TPR1Oxo=; b=
	f0+PyGIMcQqIEbA3K4LyV7L6fr7E0Vql5W5+xnjr0QGLOvOfxrETfLFOvT7u/tsB
	6HAuHYsRywSzlbLVkN5Ybc+5HcD8VvMV78fFOnfm7tO1Q83FEtTTjsL+m3Of3lQy
	8YPUNocI+dIiU0keZ4y6JGJMVZ1twctwP9jFdC0HazNsB2A95GJfrN/X+TmfuaOy
	5D0LUzPIiJarUVQPfwdyYR+m/Ixn438kjwH0pErJSHg+L4RnIrIrbmvLhq8hC6Uy
	G2M77+EGD49AWwDkN6vywicdmTP39UukOlKVylxFYmJvSWbfgZrrmO7ctFQv9w0g
	VAVTELPNg/jVciIk5T7B/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764681965; x=
	1764768365; bh=MRAoT9qWoRC6LttNlZzM263sM8o01pvLPAc/TPR1Oxo=; b=x
	dD6Yjo2ShgvYEdv7Dq3+ean5UtL/YCT2ED6fSfdOXEnR3lqbGEmlWBQB6lPnCPID
	Ua9sYB+IeG+HHURkGFEcGaLdLfeJVKM9/LS13x5KFkQQ390QAy6Iv8di5l8qhRqS
	n3Uojz3VbBBTtOoDI/dvs0vzNp8SbMs+0eszCOZmMQqC2WIBZWtSSKDv+oUtPu+k
	a51QUfxczfCaw1/lmn56mIm4Au7WlNWzDzsfyBQvTkvqODQwj9IlpYtvWV2HRojC
	+iw553sCV+p+xEKA/WVlzNFEEB5pj/adndTJm1PU06Wkssz35nMTSwekbbAiuAHd
	MhwLEu6XbLWOCK08v/N3w==
X-ME-Sender: <xms:7eguaUi9woAQ4ZU2mXiGluUh6h4pw6kwSiXddHHjvo4I35dA4AyZZg>
    <xme:7eguaX0b6JJHvO70LR5XAN-H3fXX1ovYAPjh1kIo71eBlyvMFXM2W7txz4UC_ugKW
    QN8AfAdzACUQnEJiEl1UkgSMzlaCugGXox6Xyxw6S9wlx8NNL2recE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:7eguabfw8bHh0VQTZwHmtT_e8w9VxWUVAn5UVFeiLcRe82gi8h6BAg>
    <xmx:7eguaWYvfO017K5nxBpcLDOSifp0fLotrhcS4Y3qmTmM-YkVIG424Q>
    <xmx:7eguaX5a6PWcLWqCMdnKwaDpoeqkM8rGEabPEq0E4LaalVgfVHkpdQ>
    <xmx:7eguacf6gcMaokkvj9fTsgvJnQln6CwKkYrRnNtCQ0nyl8ypsrRElg>
    <xmx:7eguacaaL2f0TlcXY54VJg2fLPVmJSopD6_toCQB8LEOMGXC2Zf_o0UL>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 440B2C40071; Tue,  2 Dec 2025 08:26:05 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ALO74ngA5rV3
Date: Tue, 02 Dec 2025 14:25:45 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jens Wiklander" <jens.wiklander@linaro.org>,
 "Bean Huo" <beanhuo@iokpp.de>
Cc: "Bart Van Assche" <bvanassche@acm.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, avri.altman@sandisk.com,
 "Alim Akhtar" <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>, can.guo@oss.qualcomm.com,
 "Bean Huo" <beanhuo@micron.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, "kernel test robot" <lkp@intel.com>,
 "Ulf Hansson" <ulf.hansson@linaro.org>
Message-Id: <dbe51014-bb52-4ffa-976f-f3823e7c391e@app.fastmail.com>
In-Reply-To: 
 <CAHUa44FeKSqRQ68FJneK_NNFNxKHWgynLpd4355GYOuJh=S0vA@mail.gmail.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
 <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
 <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
 <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de>
 <CAHUa44E5-c_rN1omhuVteBt9idz_d91r1tRKNgB2=-AWQDP2Jw@mail.gmail.com>
 <2503bc57443042876541ab5e1f2afed8f83551e6.camel@iokpp.de>
 <CAHUa44FeKSqRQ68FJneK_NNFNxKHWgynLpd4355GYOuJh=S0vA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025, at 14:17, Jens Wiklander wrote:
> On Tue, Dec 2, 2025 at 1:17=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wro=
te:
>> On Tue, 2025-12-02 at 12:41 +0100, Jens Wiklander wrote:
>> > On Tue, Dec 2, 2025 at 10:13=E2=80=AFAM Bean Huo <beanhuo@iokpp.de>=
 wrote:
>> > > On Mon, 2025-12-01 at 16:53 -0800, Bart Van Assche wrote:
>> > > > On 12/1/25 2:42 PM, Bean Huo wrote:
>> > > > > On Mon, 2025-12-01 at 12:25 -0500, Martin K. Petersen wrote:
>> > > > >
>> > > > > I tested both IS_BUILTIN and IS_REACHABLE for the RPMB depend=
encies both
>> > > > > work
>> > > > > correctly in my configuration.
>> > > > >
>> > > > > IS_REACHABLE would provide more flexibility for module config=
urations,
>> > > > > but
>> > > > > in
>> > > > > practice, I don't have experience with UFS being used as a mo=
dule.
>> > > > >
>> > > > > Would you prefer IS_REACHABLE for theoretical flexibility, or=
 is
>> > > > > IS_BUILTIN
>> > > > > acceptable given the typical UFS built-in configuration?
>> > > >

I did introduce IS_REACHABLE() a long time ago, but I consider it
the wrong approach for almost every possible case, as it only
works around link failures by introducing very unexpected runtime
behavior.

>> > > > Unless someone comes up with a better solution, I propose to ap=
ply this
>> > > > patch before sending a pull request to Linus and look into maki=
ng RPMB
>> > > > tristate again at a later time:
>> > > >
>> > > > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>> > > > index 9d1de68dee27..e0b7f8fb6ecb 100644
>> > > > --- a/drivers/misc/Kconfig
>> > > > +++ b/drivers/misc/Kconfig
>> > > > @@ -105,7 +105,7 @@ config PHANTOM
>> > > >           say N here.
>> > > >
>> > > >   config RPMB
>> > > > -       tristate "RPMB partition interface"
>> > > > +       bool "RPMB partition interface"
>> > > >         depends on MMC || SCSI_UFSHCD
>> > > >         help
>> > > >           Unified RPMB unit interface for RPMB capable devices =
such as

This equally does not seem appropriate, as others have commented.

>> > >
>> > > we wanted to make sure you're aware of this proposed change. The =
reasoning
>> > > is:
>> > > 1, avoids module dependency complexity between UFS and RPMB
>> > > 2, matches typical usage where both are built-in
>> > >
>> > > Let me know if there are concerns with making RPMB bool instead o=
f tristate.
>> >
>> > We use "depends on RPMB || !RPMB" in drivers/tee/optee/Kconfig and
>> > drivers/mmc/core/Kconfig to handle this problem. Could the same
>> > pattern be used here?

This does sound like the right idea.

>> The pattern/dependecy used in MMC and OP-TEE doesn't apply UFS due to=
 different
>> dependency structures:
>>
>> MMC: The core MMC config doesn't depend on RPMB. Only MMC_BLOCK (a su=
b-layer)
>> has "depends on RPMB || !RPMB", avoiding the cycle.
>>
>> OP-TEE: RPMB doesn't depend on OPTEE, so "depends on RPMB || !RPMB" i=
n OPTEE
>> creates no cycle.
>>
>> and for UFS:
>>
>> UFS: This creates a direct circular dependency:
>>
>> drivers/misc/Kconfig: RPMB depends on SCSI_UFSHCD
>> drivers/ufs/Kconfig: SCSI_UFSHCD depends on RPMB
>>
>> This is why Bart's suggestion to make RPMB bool instead of tristate m=
ay be the
>> cleaner solution.
>>
>
> What will that mean for OPTEE and MMC? That they can't be modules if
> RPMB is enabled? Are we moving the problem somewhere else?

My first impression is that the 'depends on MMC || SCSI_UFSHCD' is
the problem here, and I would suggest simply dropping that dependency.

Any module that links against exported RPMB symbols should have
the 'depends on RPMB || !RPMB' line to enable linking correctly.
The RPMB implementation in drivers/misc on the other hand has no
link-time dependency I can see, and enabling it without one of
the other symbols simply means that there is a module that does
nothing.

     Arnd
