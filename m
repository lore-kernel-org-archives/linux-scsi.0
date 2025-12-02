Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D92D1BC08F;
	Tue,  2 Dec 2025 09:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764666784; cv=pass; b=iMaBx70fY97M4VDEUxEZ1RtIu5COM4AZF/GCTFNCXbd1Vo11DmaUCdozPCfGpZWvBok2VvuJvpmMoluTbWecEjFEOhC7BG2g+7fZgoQW6ondASdqPcswYK0km6Gig+u578X1E/At1DgfKMLnjfj7UO+BSqFxcYgQy6gA/k5fD04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764666784; c=relaxed/simple;
	bh=nGm5JI9T09QmoG21OE+VmGeJH9WuTtB4uDxzYHckbAM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MObGzDJycbds/nHqd2sQjw+i0YUhg2q8TI1Wp8aHEIdSHvRsusEEJcvomTjqwlfeDxeRmT0pwGTZmDY7aS9BBGVHEdf/NX6KSsj0KBLI/XFLO06y/oeKQ4HxLAlQ8GRfhYtMw9LcpYdHuGXPTormi9g7YzEVFe9DuqEYMrdZKYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Z82t+pVu; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=rf7GniOA; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Z82t+pVu";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="rf7GniOA"
ARC-Seal: i=1; a=rsa-sha256; t=1764666767; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Hr+uS03p3pWp6yasfenQ2K47RXEFisSVRjN27hLwmY6rrw/Oj/0kVGO3RZOZux1DGH
    BoIxS/hbEOO1hZwmZ/dZIMKWuq9kwfIR+ScBl/qer+zS9WZNUYrMm8+0ESsiIjx7zq0B
    mrTRr+FMtQjWiKG+qZVbofNMIq5FhgHzYQlhzdh8fwIWhTXNpSl/C460Y9n2V4V9+Guy
    IpKSj07PNePekvWEP5VNywofZKApguW7hC8+5d6fAMEz8y7TEHLfbodOYyzE0zSzHFbj
    CH2dAsN+PrFMGzTTuQBtwB9VXgOeITP0+OTLSsh1nijpzDukRZM4dI4/my2XATRzVqE6
    wIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764666767;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nGm5JI9T09QmoG21OE+VmGeJH9WuTtB4uDxzYHckbAM=;
    b=gtCwXL+gBk034+x0p/2Pw3fjz7iZN7G6hdl2yMIKfIY9UU4PtV09XDugO8yE2nE8Jd
    4JhvIZlvZHJISMPWkUtF2hkHObvOvzygnDLD3XXlce/IRbYx1XK3Df2ZYXYJP1lhkM/E
    cPb4Of90ThoRClniu22r+/V1EvhH3iunozcrLrJ6C5HgGnRHUIVcYocxopK9QnrkSjIh
    j2K87z0ZwrLe5av+gkVkBzqZjmhCNfa/QGEykCRn7kWONC3gnY91EIdInIPhAGLZB1jr
    s74nf3v1qahlSUK9DlYjwRmwLoPCyoTHYE/ckSRgadD+UE3+9l3b4Cpq9vx25kZBfdAv
    CZHw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764666767;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nGm5JI9T09QmoG21OE+VmGeJH9WuTtB4uDxzYHckbAM=;
    b=Z82t+pVuSN7kirpxyfVlhhHdJCAg9QfFXtVmgQ/paSIIreV+lTZAYWXBI48ij/dwRc
    01XJD1jWGy7M0hBC+AfmaVcVnCdlEhHWXUpEYeaRzRmftcFFypgLlux5YsXhJZbc6eCM
    1fmMlj+7FcaxdzZ0rMRMhCIZbmJin2f0FMuGpp2LScwd8KgHucipsuwEdoaQ/Ctz6fn4
    y5+zkAK+4c6GynBJqdakPMkE5Wje9qkXKXQVPF8fucGEC08w30wHkyW4G1Hc6RPglhW8
    hwb+7ZCFSoBmEgQCEkvSZ/NLoeNBt54PjM+sZr8cCdpZ+EwarVOGcq+0GZwgkbNq8lFQ
    Y0Yw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764666767;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nGm5JI9T09QmoG21OE+VmGeJH9WuTtB4uDxzYHckbAM=;
    b=rf7GniOALb0ptzG0SuQkI2k1kmT1fptztnkeDAQrpD892RbKln9VY+oRfonLrpNkiS
    p88W/8PQdhABjKBX+GDw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761B29CkF6q
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 2 Dec 2025 10:12:46 +0100 (CET)
Message-ID: <aff12099702c07370b069b1bb111302ec4660ad1.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
From: Bean Huo <beanhuo@iokpp.de>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, jens.wiklander@linaro.org
Cc: avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com, 
	can.guo@oss.qualcomm.com, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Date: Tue, 02 Dec 2025 10:12:45 +0100
In-Reply-To: <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
	 <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
	 <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
	 <ef4f3e29-95ad-4094-9742-c37742da26e9@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-12-01 at 16:53 -0800, Bart Van Assche wrote:
> On 12/1/25 2:42 PM, Bean Huo wrote:
> > On Mon, 2025-12-01 at 12:25 -0500, Martin K. Petersen wrote:
> > > > When CONFIG_SCSI_UFSHCD=3Dy and CONFIG_RPMB=3Dm, the kernel fails t=
o link
> > > > with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove()=
:
> > > >=20
> > > > =C2=A0=C2=A0 ld: drivers/ufs/core/ufshcd.c:8950: undefined referenc=
e to
> > > > `ufs_rpmb_probe'
> > > > =C2=A0=C2=A0 ld: drivers/ufs/core/ufshcd.c:10505: undefined referen=
ce to
> > > > `ufs_rpmb_remove'
> > > >=20
> > > > The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates to true
> > > > when CONFIG_RPMB=3Dm, causing the header to declare the real functi=
on
> > > > prototypes.
> > >=20
> > > This now breaks the modular build for me.
> >=20
> > I tested both IS_BUILTIN and IS_REACHABLE for the RPMB dependencies bot=
h
> > work
> > correctly in my configuration.
> >=20
> > IS_REACHABLE would provide more flexibility for module configurations, =
but
> > in
> > practice, I don't have experience with UFS being used as a module.
> >=20
> > Would you prefer IS_REACHABLE for theoretical flexibility, or is IS_BUI=
LTIN
> > acceptable given the typical UFS built-in configuration?
>=20
> Hi Martin and Bean,
>=20
> Unless someone comes up with a better solution, I propose to apply this
> patch before sending a pull request to Linus and look into making RPMB
> tristate again at a later time:
>=20
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 9d1de68dee27..e0b7f8fb6ecb 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -105,7 +105,7 @@ config PHANTOM
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 say N here.
>=20
> =C2=A0 config RPMB
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tristate "RPMB partition inter=
face"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool "RPMB partition interface=
"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0depends on MMC || SCSI_UF=
SHCD
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0help
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Unified RPMB unit =
interface for RPMB capable devices such as eMMC
> and
>=20
> Thanks,
>=20
> Bart.

Hi Bart, Martin, (and Jens - adding you to this thread),

Bart, thanks for the proposed solution to change RPMB from tristate
to bool. This makes sense given our use case that UFS is typically
built-in, and RPMB should follow the same pattern.


Hi Jens,=C2=A0

we wanted to make sure you're aware of this proposed change. The reasoning =
is:
1, avoids module dependency complexity between UFS and RPMB
2, matches typical usage where both are built-in

Let me know if there are concerns with making RPMB bool instead of tristate=
.


Kind regards,
Bean



