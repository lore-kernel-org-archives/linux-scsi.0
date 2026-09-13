Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDBE3B1EEE;
	Sun, 13 Sep 2026 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789301400; cv=pass; b=pplt/QC12FjzWhNY8v6rURvQ2jbPve1anxaaEAAj/9xmBGeLQrzlgETpHT1fKgZXlg6azLYp/cY9Vot1tx0AXiMhRSAbyY1s6cg5Sekk1PAv2F0Vuxy9ZQ9nvrMA8EtUGuVW1RkZ0ZXhsKPsbwFvnvceYwfo0cLEkucjpuYUJ24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789301400; c=relaxed/simple;
	bh=K5C/5nlbBFGDMKCwhkrOHYGbFdXyKGz1/srm71B8SSc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BJQdLenY33v9XeJo42RZ7OAYMF7SQ2GUSVnHDLqnLc0AtDtZ7nGelZOTum2S5EHUeuEpyyFhxen61oc+EWuUXzHM0DLws/cfylc1YCsA5IK7EBNeP1yuqIv40ZPkD1E3lVG1JVm1Gqam2t8+LNjT+lTnFG9QQ6GNkL6JWQtF8uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=o3vvlu1L; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=WN0VYHPa; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="o3vvlu1L";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="WN0VYHPa"
ARC-Seal: i=1; a=rsa-sha256; t=1789301389; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=tdO1hpijchOtk6rk8lF9f0vZ2GuQE77vmMl8ziHiDQ7Y9eBAT2NT50k+SKdEsYn7Qy
    9h7DWjTFy4RaqyVhIDhKDqjkjbss4MBtpWYp8uL1m4ctX8DYQUAMdAF9DXcUSvhdBClm
    ZbhWX43LSTJ0JwBw/2AYOdhjpOkAFirrIM1x/sjjDjS0/np6n5OMjKcxcfCMDz/nCQR6
    cdxF6F5XF3o0w1mvHUDgd2fiX5YrqVvVT+DbhZ23WAx7Vbl1tfIaICA/d0hPyxhvKzsV
    sUBUtYGbNp+VCrWVeXreAmi+57rhduPLHFg8i4rveXxNDrviGHYvH8fQZ3juL8dzVEKH
    Vs+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1789301389;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=vuv1Gf4n5f9i/IegRmoAAmEznG0c1Jenbp+a5ZAy7qA=;
    b=SN5jTscMCxQQPLjNCNd5Gm81Ds1fOju/IlXqMOnIunXFExAIFeKhU4t/iV7Q0hHQ89
    o4lakBHcpY9OyRT1Oztl0VEkzu++sUfF1sLhnqAElJ9+FrmfnVDZDS4nn1Mj9lz1kE4s
    +cWG3HvaXHyCUX5vIgRnPqEupiTQwEL4MTp5XJCvSYluTh36bwEH5+545NivYWfy6P//
    mPBN6c5vT3VrhEwy6GAY5Pfjxrupd/0pRqe4cCIlbjrOEt8RaCi0pMyj+Ng70hQpceLo
    Fx3w1OQqeM6z8e7dR91BmxE9qZ3oiEMXxP96Fqtqm4w2L69Y5/GuD6FfqFuYzwjpIdS6
    gR5A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1789301389;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=vuv1Gf4n5f9i/IegRmoAAmEznG0c1Jenbp+a5ZAy7qA=;
    b=o3vvlu1Ljo8TrQZ/ErXUNfVgdY+uGwEvaNSO6mz7CfvQm8bBa0xkzRSIe2S3QNrAY7
    d0ccu2646ifda3s9i7FZWttAvSPYd8mo+b/VjbENsOGlt7Ir1XfBRyHKsWgk2y9YkuCU
    dwCg+gE1P5E28wvfFo6ITlQ8LmCm0wp4/d7wOC40f15K5nPfz/zE/3xU7FXGPKQV70WM
    Y+o3glpO+sU+uP1dHXUD3eLpcX6ix6YgTjdz45c7twugWFX3fa+3bV4I/reU6ugW613+
    oPDAmOYUEZypSB3+gIHsoBwuILO/S0i7p+gxIj5rMD3FA0sUtWq0xRM+MShyOqNGB2vF
    V7jg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1789301389;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=vuv1Gf4n5f9i/IegRmoAAmEznG0c1Jenbp+a5ZAy7qA=;
    b=WN0VYHPaAr7Cfz8VvnAAhQPph4E02uJMrFjHKpja21N7opFH6J2T0oP5sf2cDnJZwg
    /Qs2aAjNBxmwcNpvVIAw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaZpI+/6SexdTq2f+8K6lHAk8T6d7JrPBNQcWo="
Received: from p200300c587296833b1b3ac6b56381a47.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e128DC9mXs5
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 13 Sep 2026 14:09:48 +0200 (CEST)
Message-ID: <01d56517261d397f5e17101f03554f91529e23f0.camel@iokpp.de>
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
From: Bean Huo <beanhuo@iokpp.de>
To: Andreas Hindborg <a.hindborg@kernel.org>, jaemyung.lee@samsung.com, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>,  =?ISO-8859-1?Q?Bj=F6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?ISO-8859-1?Q?=D6zkan?= <work@onurozkan.dev>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org
Date: Sun, 13 Sep 2026 14:09:47 +0200
In-Reply-To: <87jyoqvhpm.fsf@kernel.org>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
	 <8mLXEMDMxh8mZQqVywUYUeOiZPZIPmrVGRlOkDbHptW0NEJeszKVpff5h39MjUvD5yyivwY3Z7kCXIH5VlGoiw==@protonmail.internalid>
	 <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
	 <87jyoqvhpm.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-09-12 at 13:20 +0200, Andreas Hindborg wrote:
> >=20
> > You still use scsi everywhere in your implementation protocol/scsi.rs b=
uilds
> > READ_10/16, WRITE_10/16, SYNCHRONIZE_CACHE and UNMAP CDB, so "decouple =
UFS
> > from
> > SCSI" really means "copy a small part of sd and the SCSI error handling=
 into
> > a
> > UFS driver." while JEDEC defines the UFS application layer as SCSI, the=
 SCSI
> > work doesn't go away, you just move somewhere else, and it has to be wr=
itten
> > again.
>=20
> See my response to Greg. The SCSI specific code in this driver is very
> minimal.
>=20

Let me reply this in your another email,

> >=20
> > The "friction" claim is weak. SCSI has already been changed to fit UFS.=
 Two
> > examples: UFS now uses SCSI simple copy, group number in scsi write com=
mand.
> >=20
> > I doubt how far this can go. do we really need to pay effort for a new =
RUST
> > UFS
> > driver, I am not very confident, unless SCSI is removed from the UFS sp=
ec
> > and
> > JEDEC defines native UFS commands, or we talk to the device directly wi=
th
> > UPIU.
> > please name the JEDEC feature that the SCSI midlayer really blocked, or=
 that
> > was
> > historial issue which has been fixed.
>=20
> I am sure the UFS experts will be able to answer this better than me.
>=20


this is the main reason in your cover letter for leaving SCSI. I think the
authors should name the feature, because without a real example it is hard =
to
see why the SCSI work should be done again in a new driver.


> > I would also like to see the heavy and hard parts, because they are the
> > parts
> > that decide if this design worrks:
> >=20
> > 1, error handling: abort, LU reset, retries with limits, sense decoding=
,
> > this is
> > the very hard part of UFS driver.
>=20
> I agree. However, we decided to get the discussion going with a smaller
> feature set. We can build an efficient feature complete driver, but we
> would really like to talk to the community about it first.
>=20

I understand you want to start small. But error handling is not only a miss=
ing
feature. It decides the design. Things like getting a free tag for a device
command while I/O is stuck, abort, LU reset, and what happens when recovery
fails, are the parts the SCSI midlayer gives us today. In this RFC, when
recovery fails the queue stays quiesced and I/O hangs forever. So I would l=
ike
to see at least a design for this before we discuss the rest.

> > 2, user-space tools interface: SG_IO and bsg (sg3_utils, ufs-utils, FFU=
 with
> > WRITE BUFFER), and the UFS sysfs tree..
>=20
> On the account of this not being a scsi driver, some changes would have
> to be made. But we should be able support
> /sys/bus/platform/drivers/ufshcd/* just fine.
>=20

the host attributes in sysfs are only a small part. The per-LU attributes a=
re
documented under /sys/class/scsi_device//device/unit_descriptor/, and ufs-b=
sg is
named after the SCSI host number. More important, FFU with WRITE BUFFER, RP=
MB
with SECURITY PROTOCOL, and vendor tools all use SG_IO through  /dev/sg. Th=
ese
are user-space interfaces people use in products today, so "some changes" h=
ere
means breaking them. How do you plan to keep them working? Also, the sysfs =
path
contains "ufshcd", while RUFS registers as "rufs".


> > Did any AI tool help write this code? If so, please add the Assisted-by=
:
> > tag.
>=20
> We use AI for code review and spell checking, so I guess the tag is warra=
nted.
>=20

Thanks for agreeing to add the Assisted-by tag.

Kind regards,
Beamn
