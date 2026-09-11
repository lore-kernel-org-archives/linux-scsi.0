Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C68E4A4F0D;
	Fri, 11 Sep 2026 21:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789163296; cv=pass; b=CC5Z+TzJxVIs7dpBkmODd7Jq7jHtyNdCSryg5A4q0s7sDIRF4izxSl/WMudMp5G94NPUgedyPLT/wwXxJEEcXTzBh25Ygx52y0vo3eZlEvRDIsv8z9GNn9jwhgvUpWaGJs43a5xZwCyuwHsYK6Ly0wAoceqC60+alV8MozBdgqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789163296; c=relaxed/simple;
	bh=ycUmqjr+j15i5WMteAkNalLy0jHrNrq78m43VLmnzVg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=THEjQpq3aFFiDgokvxYrTfBKygo3U9pt+9iLVWVL7a0er+JNUG1prmCkmmHOFEtKlB+hjOaTNPeyHpnQ7JMxm0flL1mXlWr5hMBIYymDe8YcsPd+ujuS2RJsfL+4hLXrpegseMohip0jQbHZXWjfv8tFiFaE3ITF1wsuVVbjS/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=f5RgMYTq; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=AajCHCLF; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="f5RgMYTq";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="AajCHCLF"
ARC-Seal: i=1; a=rsa-sha256; t=1789163098; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=f/5NYhka1D7iIUgBsnzzokn7zcC5XX4OFWKtWeZQmvWMZ9mSYCBnUEFDBA+nvPp1Iy
    FnHvB89ahbQdAcfN2tfWU5R+h8edEL6S0lv7OWKPj/utArCf5bR28PVyJFsGC7l0w1ua
    gnYsdlDFqtcsG4cBAWVVSNmgnoKBb3SRmhg6V3E579DqwZxHSQVuzjZJt7mN3AsExXPA
    rZZUshijnSNpgyC85x9C2ByLWGg/xoPEltO6EW9Xvp4/HC+9qkMGFbfizexbzngXowBx
    WGf/OfsMFA5Z2Khbejy6jVFNTpXBGxHs+4tvdKfBk8XA1NToPWmWmBSNeZzDzRih8rGi
    Iswg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1789163098;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ycUmqjr+j15i5WMteAkNalLy0jHrNrq78m43VLmnzVg=;
    b=cth0f/wtacQmjLvvl8syxe9R967N+tYhGYAYzNrWWXErlT/ARXXGLPLqeWxJ9LFYQg
    vWOxIAVTimZFAhqhinCQZuTtPwRLyR7Klt7FHaGLhtnO0VVW5T31czcjn0ynOk2a5M4l
    OozL/0FenauxH/88DWbq4/Z31rku6O5VCxQPDQe9bknFcN9tDr5FPsOnaKoTiZYCUWIW
    bkCzT648Qy7hlOGtUGdQYcbIl2vQ5gRpFxyU8u6lyNMb4okVisc15e0UIwXNL3cniwMn
    1MPn99Tl6gqEYyeRH87R7W+ap0Nefph6jcRYMxn5ZgzsrKF2u3HzKXaeiIeV/n+WamsD
    UBYg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1789163098;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ycUmqjr+j15i5WMteAkNalLy0jHrNrq78m43VLmnzVg=;
    b=f5RgMYTqJfMquxhwtGA1DA8ll+WRybZZYXiUoW24vkwa75QjnUmbUvbvUzptfrMXPd
    jKVqeQ0mcQ0B9bIlA72euuDYnwkJ+LIlAFE4yrirLgnA6IVjuSkd/0sMm7yqvgMaVeAi
    2A4IzVVnYfbPGil13A0VqfYMzlPF8lwbDELAICK7XCu9Xug1zXeT5dHap/pPjeAqL6/N
    lsShedLC77xvgfp5pBizkJcafoe9FLBb4jYuFW70RODHTI5BfB98Ay2h2pqyDq3OEdAB
    KA9Mes98YQ1aMS5LlJJojjrJIxAonlOcLmCaLD71o6cmYjwHG3Ukd4XmP5DlhXOyMIVo
    +Wdg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1789163098;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ycUmqjr+j15i5WMteAkNalLy0jHrNrq78m43VLmnzVg=;
    b=AajCHCLFEu4bkgKHsBEN/GFCkWfWeG372Q42FB3qM+VArRk9jvVqzlSSDdsJqepvyO
    tfbGFyMz9PXCnliZ/uDQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaZpI+/63exJG3nKe+1cCDsnKpsYY+u4Ll0RlE="
Received: from p200300c58729681c3f3e4b76edf8c1cb.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e128BLivUx1
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 11 Sep 2026 23:44:57 +0200 (CEST)
Message-ID: <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
From: Bean Huo <beanhuo@iokpp.de>
To: jaemyung.lee@samsung.com, Andreas Hindborg <a.hindborg@kernel.org>, 
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
Date: Fri, 11 Sep 2026 23:44:57 +0200
In-Reply-To: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-09-12 at 00:52 +0900, Jaemyung Lee via B4 Relay wrote:
> From: Jaemyung Lee <jaemyung.lee@samsung.com>
>=20
> Add a Rust UFS host controller driver that exposes UFS logical units as
> native blk-mq block devices without depending on the SCSI midlayer.
>=20
> Implement host controller setup, UIC link startup and power-mode
> configuration, device and unit descriptor discovery, query operations, an=
d
> SCSI protocol command construction. Support normal read, write, flush, an=
d
> discard I/O with coherent UTP descriptors and owned streaming DMA mapping=
s.
>=20
> Provide both single-doorbell and multi-circular-queue transfer backends.
> Map shared blk-mq tags directly to UFS task tags, retain request ownershi=
p
> while commands are in flight, dispatch completion per MCQ completion queu=
e,
> and return polled completions through the blk-mq completion batch.
>=20
> Add PCI and Qualcomm platform frontends. The PCI frontend supports the QE=
MU
> UFS controller and existing Intel and Samsung IDs. The Qualcomm frontend
> provides the clocks, PHY, reset, interconnect, power-domain, OPP, GPIO, a=
nd
> controller-specific initialization needed by supported SoCs.
>=20
> This establishes normal-I/O support for UFSHCI single-doorbell and MCQ
> controllers. Full timeout recovery, error handling, and power management
> are left for follow-up work.
>=20
> Signed-off-by: Jaemyung Lee <jaemyung.lee@samsung.com>
> ---
> This RFC introduces RUFS, a UFS host controller driver that sits directly
> on the block layer and does not use the SCSI midlayer. UFS logical units
> are exposed as native blk-mq block devices, the same way NVMe namespaces
> are. The driver is written in Rust.
>=20
> Why decouple UFS from SCSI
> --------------------------
>=20
> The existing UFS driver is built on the SCSI subsystem. That made sense
> historically: UFS adopted the SCSI Architecture Model as its application
> layer, so reusing the SCSI midlayer's command queuing, error handling,
> power management, and logical-unit addressing let UFS reach Linux quickly
> and reliably. ufshcd bridges the SCSI midlayer to UFS Protocol Informatio=
n
> Units.
>=20
> That foundation has become a source of friction. The evolution of UFS is
> governed by JEDEC and increasingly includes UFS-specific features outside
> the SCSI command set standardized by T10. These features must still be
> expressed through, and constrained by, a SCSI-shaped driver. Features tha=
t
> are meaningful only to UFS are difficult to land in a subsystem whose
> maintainers reasonably want to keep SCSI focused on SCSI, and block layer
> or shared infrastructure changes that UFS needs end up mediated through
> SCSI's priorities. In practice UFS is treated as an add-on to SCSI rather
> than as a first-class storage interface, and a significant amount of UFS
> functionality lives off-tree as a result, with the back- and forward-
> porting cost that implies.
>=20
> We propose to decouple UFS from SCSI with a standalone driver that sits
> directly on the block layer, alongside drivers like NVMe. This lets
> JEDEC-specific features evolve independently of T10, gives UFS
> its own dedicated review surface, and removes the impedance mismatch
> between the UFS data model and the SCSI command model. UFS uses a subset =
of
> the SCSI command set within command UPIUs, so the driver can construct th=
e
> required CDBs directly without depending on the SCSI midlayer.
>=20
> The driver is designed around the UFS and UFSHCI specifications rather th=
an
> as a line-by-line translation of ufshcd. Its target is JEDEC UFS 4.1 and
> UFSHCI 4.1.
>=20
> Why Rust
> --------
>=20
> The architectural question above would be the same for a C driver. We cho=
se
> Rust because UFS features arrive at a high pace, and turning new
> specification features into stable, validated code on tight timelines is
> where memory- and concurrency-safety guarantees pay off: fewer classes of
> bugs reach production, and iteration is faster. Rust's growing acceptance
> in the kernel makes a block-layer-native UFS driver a realistic
> architecture to evaluate.
>=20
> Initial feature set
> --------------------
>=20
> The new driver supports single-doorbell and multi-circular-queue operatio=
n,
> PCI and Qualcomm platform frontends, logical-unit discovery, and normal
> read, write, flush, and discard I/O. It uses shared blk-mq tags as UFS ta=
sk
> tags, keeps request ownership through completion, and uses owned DMA
> mappings for the complete I/O lifetime.
>=20
> Full timeout recovery, error handling, and power management remain
> follow-up work.
>=20
> Patch layout and dependencies
> -----------------------------
>=20
> The single patch contains the complete driver. This keeps review focused =
on
> the RUFS architecture and the SCSI-independent blk-mq model.
>=20
> The driver depends on Rust block, DMA, IRQ, and platform abstractions tha=
t
> are intentionally excluded from this posting. Some of these abstractions
> have already been posted to the list, most notably in the Rust null block
> driver v2 series, the Ownable/OwnableRefCounted page series, and the
> impl_flags extensions. The remaining abstractions are new and will be
> posted as separate series before the first non-RFC version of this driver=
.
>=20
> A buildable tree based on v7.3-rc2 with all dependencies and this patch i=
s
> at:
>=20
> https://github.com/SamsungDS/rufs/tree/rfc/rufs-public
>=20
> Testing
> -------
>=20
> The v7.2 development version has been exercised with SDB and MCQ on the
> QEMU UFS model, including ext4 fio workloads and module load/unload cycle=
s.
> SDB probe and normal I/O have also been exercised on Intel PCI and Qualco=
mm
> UFS hardware. The current port has been compile-tested independently with
> PCI-only and Qualcomm-platform-only configurations.
>=20
> The exact v7.2 tree used for the hardware measurements is available at:
>=20
> https://github.com/SamsungDS/rufs/tree/rufs-7.2
>=20
> On Intel UFS 2.1 hardware, 4 KiB direct io_uring at QD32/job gave
> these optimized-mode ranges over 1/2/4 jobs (three samples):
>=20
> =C2=A0 Workload=C2=A0 Op=C2=A0=C2=A0=C2=A0=C2=A0 RUFS kIOPS=C2=A0=C2=A0 C=
 kIOPS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Difference
> =C2=A0 --------=C2=A0 -----=C2=A0 -----------=C2=A0 -----------=C2=A0 ---=
------------
> =C2=A0 randread=C2=A0 read=C2=A0=C2=A0 48.91-61.26=C2=A0 41.56-41.60=C2=
=A0 +17.6% to +47.4%
> =C2=A0 randwrite write=C2=A0 8.19-8.30=C2=A0=C2=A0=C2=A0 8.21-8.22=C2=A0=
=C2=A0=C2=A0 -0.4% to +1.1%
> =C2=A0 randrw=C2=A0=C2=A0=C2=A0 read=C2=A0=C2=A0 5.26-5.34=C2=A0=C2=A0=C2=
=A0 5.28-5.38=C2=A0=C2=A0=C2=A0 -0.9% to -0.4%
> =C2=A0 randrw=C2=A0=C2=A0=C2=A0 write=C2=A0 5.27-5.34=C2=A0=C2=A0=C2=A0 5=
.29-5.37=C2=A0=C2=A0=C2=A0 -0.8% to -0.5%
>=20
> The coefficient of variation (CV), calculated as the sample standard
> deviation divided by the sample mean, measures run-to-run variability
> relative to the mean. CV is a descriptive statistic; no normal or other
> distribution was fitted to model the variation. The accompanying
> two-sided 95% confidence intervals for the mean used Student's
> t-distribution because each point contains only three samples. Those
> intervals assume independent, approximately normally distributed sample
> means and should be interpreted cautiously at this sample count.
>=20
> RUFS randread had a CV of 28-57%, versus below 0.8% for C. Its apparent
> gain therefore has low confidence and should be treated as preliminary.
> Both drivers also logged platform UIC errors. Stable write and mixed
> points differed by no more than 1.1%.
>=20
> Feedback
> --------
>=20
> Comments on the decision to bypass the SCSI midlayer, the blk-mq model us=
ed
> in its place, and the proposed prerequisite API boundaries would be
> especially welcome.

Jaemyung,

thanks sharing.

You still use scsi everywhere in your implementation protocol/scsi.rs build=
s
READ_10/16, WRITE_10/16, SYNCHRONIZE_CACHE and UNMAP CDB, so "decouple UFS =
from
SCSI" really means "copy a small part of sd and the SCSI error handling int=
o a
UFS driver." while JEDEC defines the UFS application layer as SCSI, the SCS=
I
work doesn't go away, you just move somewhere else, and it has to be writte=
n
again.

The "friction" claim is weak. SCSI has already been changed to fit UFS. Two
examples: UFS now uses SCSI simple copy, group number in scsi write command=
.

I doubt how far this can go. do we really need to pay effort for a new RUST=
 UFS
driver, I am not very confident, unless SCSI is removed from the UFS spec a=
nd
JEDEC defines native UFS commands, or we talk to the device directly with U=
PIU.
please name the JEDEC feature that the SCSI midlayer really blocked, or tha=
t was
historial issue which has been fixed.


I would also like to see the heavy and hard parts, because they are the par=
ts
that decide if this design worrks:

1, error handling: abort, LU reset, retries with limits, sense decoding, th=
is is
the very hard part of UFS driver.

2, user-space tools interface: SG_IO and bsg (sg3_utils, ufs-utils, FFU wit=
h
WRITE BUFFER), and the UFS sysfs tree..


Did any AI tool help write this code? If so, please add the Assisted-by: ta=
g.

kind regards,=20
Bean





