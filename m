Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3ED421233;
	Mon, 14 Sep 2026 10:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789380691; cv=pass; b=oaErVq/6UmPwvTR3DQL3NmAklFRvFc15NpWSglKe+aFF9nyzkvnZ0XqVKdONrArSPM8NVwduoRGqMvqR8eoWTnCxe6CQrmXc9aRxtAQRR3KDg2mpNrCL35vT7wz0DX0oCZJzgP4gJWbs86ByPs+JyVXMxbt7I2bllp8L48wsR80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789380691; c=relaxed/simple;
	bh=n+s7Of3owfPqu8WPuWhrDztpgUkeJEu0tQHD5fr1z64=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rbA5u4ZwxfRgZiloowu/pIgDE6c1NRT9EKBSE6YooRZJxoNwyALHwVwcpaeo4kqCskC2iFJ+gu1VzLXbU+m7uv61UbfJLKLqRgJvndyZCz/XsgRWqbkckGHGsxxFtslflZfO2havkmRQnm/2LhG37Zsoh3IA0DFH4SBtSImFkV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=BtAvkOBW; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=MnCgmZhx; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="BtAvkOBW";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="MnCgmZhx"
ARC-Seal: i=1; a=rsa-sha256; t=1789380326; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=rTPWGbeH5Cm7WWjQZjjYxVfxT2QR4NMQv8e6f8vxSaBH4qwZQn7NFhPu1Ww+7rt/xa
    oDcAH0WM2haztWP9E/RaZppK8J/5nEorJxAWdqvvujmbZcMiblri2S2NSzYsAxQ5gu+8
    fv7cd+RaA2cPf/n8Vzh3XdZjQmvGpVxMMAG/nKGqxrFXkrk2IpWwE9q0zId4px1tm63Q
    HCDBCFTrEfcfygYG3+doqx+im7eegyWGs8/YYhn6cNvu9ALoMAdaPwPQDOB5Mg99hWuY
    p5BxkppwSYdNhNLWanU48txOwZmDAcTyJ12OvnD3j3Myuow+ySLE5bbdBfrSStYX3VgS
    erJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1789380326;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=AR19CK4bMR3yBKwIhxHM2W2esP34hlrAT6Yh3DLSKKM=;
    b=hSs/Ddl+l06LzytmdxytbYE+6711KIqAZ7jE9MzSacxmPv7+zH1F68DejicRM/UBvj
    iVto/74zGZJsVWVJN+6jreyOnE4yHmdR9HWh8YDGLYD76FySHcsA5XERtmZHKSZ7C/wV
    VDxv5Di+EudDEMLpQf2YQ3+Lw6M2o11GE2gAB4o6/hUSDWH7XbfcOAqI/6ueKOuVKmpf
    xd/ToT7J0l4vLJ12zZvQrisCviYIPNPjd9SNkL1pz9TY+9hJYkD2gqPd2Svxsn7+5z+H
    BozouydqXJ8IS55jHvjnDhODRkwFaowj3D7IqdRb2/cWsEXOI7FYILFDQ759laNgYVF4
    th2Q==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1789380326;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=AR19CK4bMR3yBKwIhxHM2W2esP34hlrAT6Yh3DLSKKM=;
    b=BtAvkOBWouGTBEEJohOMftN7dBhX1p3cE6UKt3sP5m1zd4zTcVVuYm4cNHI2VtnN7x
    XMytoLtH4A8i6im659zyVhaszHaFOqBsvu+/eBFRmxSMr1DI4WMorXXGp9p+2dWJbCqu
    ZgMwj+GQdy5Rtnr635HVXdyW8t4ILaGI30xQmk/jqQTUTQ9F/Z1kwQV3OyPmrtf64AzL
    kNg52dwnX89ri0lDkBDogTgQvd4Atu4DjgMyebdSSS/2Az5pmOC9nuYlDIQkym8lSGeR
    nZDLZog+Y/bLsHGGgKSVN3QlWcIsZe0VlbdtdaelNHdM6ztASXDiS2H6OWdMtnG/nt8x
    uoDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1789380326;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=AR19CK4bMR3yBKwIhxHM2W2esP34hlrAT6Yh3DLSKKM=;
    b=MnCgmZhxjFR3APQPmKgZ9BNHp/F0PBQaVDjHo8bcsQSbfZR3motJNpAgsOTwFdF5v4
    9cfTAUtBu4F67ll/McBw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.237.249]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e128EA5PbRR
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 14 Sep 2026 12:05:25 +0200 (CEST)
Message-ID: <b07b648dd0e914e2f6d10fcfd90225c1ae83a8cb.camel@iokpp.de>
Subject: Re: [PATCH v4 3/3] scsi: ufs: rpmb: Drop the unregistered ufs_rpmb
 bus
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
 avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
 can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
 tomas.winkler@intel.com, shyamsaini@linux.microsoft.com,
 alex.bennee@linaro.org,  James.Bottomley@HansenPartnership.com,
 linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Date: Mon, 14 Sep 2026 12:05:25 +0200
In-Reply-To: <20260913033633.3159296-4-stanleyjhu@google.com>
References: <20260913033633.3159296-1-stanleyjhu@google.com>
	 <20260913033633.3159296-4-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2026-09-13 at 11:36 +0800, Stanley Jhu wrote:
> ufs_rpmb_probe() assigns ufs_rpmb_bus_type to dev.bus, but that bus is
> never passed to bus_register(). bus_add_device() rejects devices on an
> unregistered bus, so device_register() has always failed:

"has always failed" is not correct, bus_add_device() only started rejecting
devices on an unregistered bus after this commit:

36f35b8df697 ("driver core: reject devices with unregistered buses").

Before that, device_register() succeeded and the device was just not added =
to
the bus, so UFS RPMB did register until that commit 36f35b8df697.

I think it is better to mention  commit 36f35b8df697.

>=20
> =C2=A0 bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus
> =C2=A0 'ufs_rpmb'
> =C2=A0 ufshcd 0000:00:02.0: Failed to register UFS RPMB device 0
>=20
> ufs_rpmb_probe() unwinds on the first failure, so no RPMB region has
> ever been registered and /sys/bus/ufs_rpmb/devices/ has never been
> populated.
>=20
> ufs_rpmb_bus_type declares no .match and no .probe, and no driver binds
> to it. RPMB devices are exposed to consumers through /sys/class/rpmb/,
> which rpmb_dev_register() already sets up. Drop the bus rather than
> register it: device_register() works with dev.bus left NULL given a
> parent and a release callback, both of which ufs_rpmb_probe() sets.
>=20
> With the bus gone, on a device advertising four RPMB regions:
>=20
> =C2=A0 ufshcd 0000:00:02.0: UFS RPMB region 0 registered (capacity=3D32)
> =C2=A0 ufshcd 0000:00:02.0: UFS RPMB region 1 registered (capacity=3D32)
> =C2=A0 ufshcd 0000:00:02.0: UFS RPMB region 2 registered (capacity=3D32)
> =C2=A0 ufshcd 0000:00:02.0: UFS RPMB region 3 registered (capacity=3D32)
>=20
> /sys/class/rpmb then holds rpmb0 to rpmb3, and unbinding the host
> removes them.
>=20
> Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for U=
FS
> devices")
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
> =C2=A0drivers/ufs/core/ufs-rpmb.c | 5 -----
> =C2=A01 file changed, 5 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 373b60aba916..684fb37705c7 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -28,10 +28,6 @@
> =C2=A0#define UFS_RPMB_SEC_PROTOCOL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A00xEC=C2=A0=C2=A0=C2=A0=C2=A0/* JEDEC UFS applicatio=
n */
> =C2=A0#define UFS_RPMB_SEC_PROTOCOL_ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A00x01=C2=A0=C2=A0=C2=A0=C2=A0/* JEDEC UFS RPMB protocol ID,
> CDB byte3 */
> =C2=A0
> -static const struct bus_type ufs_rpmb_bus_type =3D {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.name =3D "ufs_rpmb",
> -};
> -
> =C2=A0/* UFS RPMB device structure */
> =C2=A0struct ufs_rpmb_dev {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u8 region_id;
> @@ -208,7 +204,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufs_rpmb->sdev =3D sdev;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufs_rpmb->region_id =3D region;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufs_rpmb->dev.parent =3D &sdev->sdev_gendev;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0ufs_rpmb->dev.bus =3D &ufs_rpmb_bus_type;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufs_rpmb->dev.release =3D ufs_rpmb_device_release;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
> =C2=A0

Reviewed-by: Bean Huo <beanhuo@micron.com>

Kind regards,
Bean
