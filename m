Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6D23D5C07;
	Mon, 12 Oct 2026 11:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791803368; cv=pass; b=crSN6FUQfD8Q0fvgWE/fYpp7FkUgOi3h1SS78U1di+AbXiCUkglYyITA2cPYL0Vz6y6VBSw8lKOuzFnnhA0sRFCwlVX3vi/Ka2+gQB4RIhD0wNA5sSN/85J92UqLT6AkwdhlBve60QAxAHzszCys7EexSR3KlIpVf1OPYOFyHQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791803368; c=relaxed/simple;
	bh=P2ClapjNuEAhaLeTQUhvTA2jI4GtQfghK6bt/c/RFbU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gMdQjyQwEQHX1BRegGMJJstum11bBLtYR60WavgV/ygJ44I81ZiEYlRRgzV4CTwPhtdiXXNnlDeu9flcB3qvFKGgUaNtGkTjTHmJmaNsLU5szn4LWMRNkY39uvrDkzDYzf918UNOJPYJuysMtuQbHaoMVhmfDrerdmf0N8qsdKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=LCcqgPpB; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=OfaCEm3N; arc=pass smtp.client-ip=85.215.255.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="LCcqgPpB";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="OfaCEm3N"
ARC-Seal: i=1; a=rsa-sha256; t=1791803357; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=qOkaKGXC4HiCHe2i9KEmZiXMk/3rgQIcV9QIZPgLce0vQNEHaAytJ7dB4l9UUzsh4m
    JmCchpz2i+Y1Na5OUDHNzis/SXd2VLi91c+SPAD0mbzjMKn++RLqpvhqY4RkkN900scz
    PW+uL7ixdtR5uR3sAr0nVbx1WteAKNV8uu4qJ+oo14Sy3Mq9u5OeXnvDdXL+5xlgFYdi
    VioBvMbrYpXn0sSxHNalqriyfVakiSXtP6uSmqAzFwQXi8LY97bpbRI1Oh6iD0+nMh7l
    dNwOq2R4BN+8Sm0HMmjR4cCs7AskJ/UKhYqzW9lXYHUP5TlSKDyUKRdRwUZCFzw0TtYJ
    j9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791803357;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=KA+pgc8ZZ48UwvpuWYp5dT31mq3skmDPd70xJMP+Sh4=;
    b=Z6pzfFAVzkrFkaZjCV0KREqpeQxjAzqBkT4a6qVGIBWhEK1b0Wsz1rre++yRC3Zj08
    kL0zlijnXcRc5VXNq9ti8a67xejFkS2GD8ctZAnrh6dvEirKNk+LFmqmOKiine1EJ17t
    MsHQznP/nhHoLc9aAUMKRJDCLzLfA2MZkOjKKz4KZxh9VELgyLGImqoISkMSqxWJ4Y5r
    2+9bHJ3sARt7Yv7xzct4tuVr+4sJiVIZ3fgCpytn0dq5ZrFYMnuwWuZYQnyRo3PrAl6n
    jwB7vgCodfRqPElkujm53zdkOtUAcGFjL0kmmVTwKc+lk7wLZAUM/k3PhfNmfxD+Oc/J
    zc6Q==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791803357;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=KA+pgc8ZZ48UwvpuWYp5dT31mq3skmDPd70xJMP+Sh4=;
    b=LCcqgPpBVzq0L8OpgJ0KkpPaf2PXFqy4biXQH54ej3d3jjwZsg+cBiHn5iy/PNgcMH
    zOAsJkCnAEFQQWPUpfquM4gsrODc7kQ4xIeqjq3Q39sNG5wV52ChB8Lkt7V2hf2K8xfv
    4atDvwQVIJMs9X7ldBn049Qgh/tP2b/0RbUkoBUnukC7qlwnm0ogF6GhMVgyjBk/ZRFs
    wXX3JYJFhdR3U5g0LVtCd7MEBfJOTMfjGmqZECOsJCmnYEfczCrpWii2waZzvMtoPRua
    1NqDjzBaSABgnkPFrfovt+Kl5z1EMuQuGl+xWHXOzid4mLeIrS3OPIkzdz/1lOqH/SBE
    DKeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791803357;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=KA+pgc8ZZ48UwvpuWYp5dT31mq3skmDPd70xJMP+Sh4=;
    b=OfaCEm3NV1tjpibiGzwLo+YtuNbqemGwSXORN79JaN+z/chkyZllFd6CnPok4bCRWB
    F8+uHGuhZ+/RfPpkD+AQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.108]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id z04e1c29CB9G6G4
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 12 Oct 2026 13:09:16 +0200 (CEST)
Message-ID: <91cc71e731252e372d6cbfddf6a9f6ebbdf7bcca.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: docs: Describe how to test with QEMU
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Bart Van Assche <bvanassche@acm.org>, Alim Akhtar
 <alim.akhtar@samsung.com>,  Shuah Khan <skhan@linuxfoundation.org>, Randy
 Dunlap <rdunlap@infradead.org>, Jeuk Kim <jeuk20.kim@samsung.com>,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2026 13:09:14 +0200
In-Reply-To: <20261011103319.820657-1-stanleyjhu@google.com>
References: <20261011103319.820657-1-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Stanley,=20

Thanks, this is very useful, a few comments as below:

On Sun, 2026-10-11 at 18:33 +0800, Stanley Jhu wrote:
> QEMU emulates a UFS host controller and logical units, but the kernel
> tree does not mention it, so developers without UFS hardware have no
> documented way to exercise the UFS core.
>=20
> Add a short section with the required kernel options, an example QEMU
> command line, and what the emulation does not cover.
>=20
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
> =C2=A0Documentation/scsi/ufs.rst | 33 +++++++++++++++++++++++++++++++++
> =C2=A01 file changed, 33 insertions(+)
>=20
> diff --git a/Documentation/scsi/ufs.rst b/Documentation/scsi/ufs.rst
> index a7b2b2ed1c3a..1ff1c8218bf1 100644
> --- a/Documentation/scsi/ufs.rst
> +++ b/Documentation/scsi/ufs.rst
> @@ -19,6 +19,7 @@ Universal Flash Storage
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.4 SCSI Error handling
> =C2=A0=C2=A0=C2=A0 4. BSG Support
> =C2=A0=C2=A0=C2=A0 5. UFS Reference Clock Frequency configuration
> +=C2=A0=C2=A0 6. Testing with QEMU
> =C2=A0
> =C2=A0
> =C2=A01. Overview
> @@ -208,3 +209,35 @@ the UFS specification. UFS subsystem will attempt to=
 read
> the value when
> =C2=A0executing common controller initialization. If the value is availab=
le, UFS
> =C2=A0subsystem will ensure the bRefClkFreq attribute of the UFS storage =
device is
> =C2=A0set accordingly and will modify it if there is a mismatch.
> +
> +6. Testing with QEMU
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +QEMU emulates a UFS host controller as a PCI device named "ufs" and
> +logical units named "ufs-lu". This can be used to test changes to the
> +UFS core and to ufshcd-pci without UFS hardware.
> +

should here state the minimum QEMU version for the ufs device, and for mcq=
=3Don,
since the older version QEMU may not have them or one of them.

> +Enable the following kernel options on top of the architecture
> +defconfig::
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CONFIG_SCSI_UFSHCD=3Dy
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CONFIG_SCSI_UFSHCD_PCI=3Dy
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CONFIG_BLK_DEV_SD=3Dy
> +
> +Example for an arm64 guest with one 1 GiB logical unit::
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0qemu-img create -f raw ufs.img=
 1G
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0qemu-system-aarch64 -M virt -c=
pu max -smp 4 -m 2G -nographic \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0-kernel arch/arm64/boot/Image -initrd rootfs.cpio.gz \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0-append "console=3DttyAMA0" \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0-drive file=3Dufs.img,if=3Dnone,id=3Dlu0,format=3Draw \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0-device ufs,id=3Dufs0,serial=3D0001,mcq=3Don \
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0-device ufs-lu,drive=3Dlu0,bus=3Dufs0,lun=3D0
> +
> +The logical unit appears as a SCSI disk (/dev/sda).

maybe here adds "for example"-> The logical unit appears as a SCSI disk (fo=
r
example /dev/sda)

> Drop "mcq=3Don" to
> +test the single doorbell mode instead of MCQ. The same -device options
> +work with qemu-system-x86_64.
> +
> +The emulation does not model UniPro, M-PHY, power mode changes,

I am cconfused by this statement, since I checked QEMU, the latest QEMU acc=
epts
some UIC commands such as hibern8 enter/exit, if I am correct, here "accept=
s but
does not model" would be more precise, you can check  hw/ufs/ufs.c:

static void ufs_process_uiccmd(UfsHc *u, uint32_t val)

> +hibernation or clock gating hardware, and vendor host drivers are not
> +exercised. Changes in those areas still need testing on real hardware.


Kind regards,
Bean

