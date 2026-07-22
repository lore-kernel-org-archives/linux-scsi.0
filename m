Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94532388E61;
	Wed, 22 Jul 2026 09:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784713481; cv=pass; b=P+F60mRixRMVd1LhrwUJLAnSomxDGKyynDH6DflW0CYGI2G0gYE/9b+L3O1fRkCm5EtDXIBeREVbr4fSNzW+JJxXwU7M9wFmbYjPOEPFge75ww1N54EJIyX5TA7sgwb4A36I5XJWBIRupAA3AmA8SoOqBSrB45uMp+/RdZdTY78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784713481; c=relaxed/simple;
	bh=fRK/H86hPYGYKPqFfuE70kUxCLFkw58bvH8eD02RS9k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cNLbcGxlNPuFueGZMncBRPpVRh4pLXKkZ2gq7EUlHSpY4qioQ9lVfD7nO8qZifZF8MkkTMv92s+KDwdTemsRLfe5l3qvC6qt84ZA46I/uNQzOox03A8I6mccobmB0BHSte2zeKcRf5aINOsFjTKJE0EMKQvrRta2B07bX2wPwWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=HZDBz5Jv; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=cVStJOuD; arc=pass smtp.client-ip=85.215.255.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="HZDBz5Jv";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="cVStJOuD"
ARC-Seal: i=1; a=rsa-sha256; t=1784713438; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Ce68NPwMvzxI0yXfxIsWaneDsH/MzMHs3isJrE8fFYrsa6xxjvQlqLylrC9p1nySQG
    exqX1a4O+tEVfB4OdVeDwRZ1dnave3Kp8OitDZAIovqS15keNxULie9o8cb27RayPaWM
    CKxaNvopa/NzxSutE0QvxIH3oKPOYNQi2ljOw2MEzOZR613OPoHugzYJN4Q2SFqjV16D
    DHPITtblNr+eFgWjZg4GysrhQ8hLb70z10VFe3gHSzbhOThEynThmYfsZbHfaxpfCjeP
    AZkCIehbXD6dM0zcAspNxv0kb/jOq73CpsDxKZULt8CFlIQX+Mws09mnd86A7Et535+D
    5RAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1784713438;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=lQvs6okjlslsvFq6foMRR6KEPvL//dScTFKBbA6Llrw=;
    b=jlu3NHATRfy+NbpROpLqTlouXNzm+NCLHzAuDrF1M6K3sjtvJtun+g+UJU5opQRV9j
    Yplvi24WOKTvsS5SiHHxEHw13VMRIXZcZItLIKvr1z5UEbiOwijyvD0aK8JrEqhxHEfQ
    EWq2UJ4pkV3bNIkRoKOugaOLLS++Nfk/7PRoKerx82iehth8DnSuhnZw69SMFzIBHs0d
    0QLKrrXAOHlRl2KcziXJL/9PEu4SLTtbItucEUt9A9KDvrc7QNIr3CoWlUtVGprMSprI
    CScRLewiSVHn6bYunHZMgw6mM+xbBrOXqBMiuZZFlswLqrtlffsesnRl3z49vEKR0ysr
    R1OQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1784713438;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=lQvs6okjlslsvFq6foMRR6KEPvL//dScTFKBbA6Llrw=;
    b=HZDBz5Jv4R12FRKV9S5inTcLOILjYLW4cNDjxjL01JhdFqQqvhVh/CA9MmSQk3NbcK
    yw5S+66Vm0bFeo4xtXtDTutLXKtMYAPsP/Y4lQ0Vy4cOpIQKHSU3VC75pFHyZddrkl8b
    4r3lvilfEtb9rYbQEdmi3XkELRsaJtOEY/QNJurjgUBcn7rw5N0DUFTkPv8xuFxDbdLC
    aL+A1YasrsSqgqmzRMAK7Cnu8FurtzOHDcEsfSNelHQ4nawnd3j557LGByUCeheafU2P
    P8Xe2ZByg2I3+Zu7VjNQxYWhXJrhmtGo6fKF8HwgAYQzvZJgQW6MhlQ/LsJu8/uGuiLQ
    AQJQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1784713438;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=lQvs6okjlslsvFq6foMRR6KEPvL//dScTFKBbA6Llrw=;
    b=cVStJOuDI0qmg75bwXQcGZoma/4sgynT3WOLibX+IiukYjzFxq+P9CHHc5jTH4lzZh
    nkrqQcVGXTPFK1uxReCg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc926M9hvFt3
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 22 Jul 2026 11:43:57 +0200 (CEST)
Message-ID: <0d90c3e03e7fea341490b8bd239c0354bee9acfe.camel@iokpp.de>
Subject: Re: [PATCH v3] scsi: ufs: core: Fix UFS RPMB device teardown order
From: Bean Huo <beanhuo@iokpp.de>
To: jens.wiklander@linaro.org, Ao Sun <ao.sun@transsion.com>, 
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,  "bvanassche@acm.org"
 <bvanassche@acm.org>, "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "peter.wang@mediatek.com"
 <peter.wang@mediatek.com>, "beanhuo@micron.com" <beanhuo@micron.com>, 
 "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jiazi Li
 <jiazi.li@transsion.com>, Hongyan Xia <hongyan.xia@transsion.com>,
 "sashiko-bot@kernel.org" <sashiko-bot@kernel.org>
Date: Wed, 22 Jul 2026 11:43:56 +0200
In-Reply-To: <20260721084015.319-1-ao.sun@transsion.com>
References: <20260721084015.319-1-ao.sun@transsion.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-07-21 at 08:41 +0000, Ao Sun wrote:
> From: Ao Sun <ao.sun@transsion.com>
>=20
> The child RPMB device holds a reference to its parent, so the parent's
> release callback cannot be invoked if the child device is still registere=
d.
> Remove the rpmb_dev_unregister() from the parent release handler, and
> unregister the child RPMB device ahead of the parent device in the remove
> path.
>=20
> Memory for struct ufs_rpmb_dev is allocated via kzalloc_obj(), and free i=
t
> from the device release callback, following the same pattern as MMC RPMB.
>=20
> Initialize the hba->rpmbs list in ufshcd_alloc_host() to prevent NULL
> pointer dereference in the device teardown path if ufs_rpmb_probe()
> fails.
>=20
> Reported-by: sashiko-bot@kernel.org
> Closes:
> https://lore.kernel.org/all/20260714064356.CF7101F000E9@smtp.kernel.org/
> Signed-off-by: Jiazi Li <jiazi.li@transsion.com>
> Signed-off-by: Ao Sun <ao.sun@transsion.com>
> ---
> Changes in v3:
> =C2=A0 - switch devm_kzalloc() to kzalloc_obj()
> =C2=A0 - init rpmbs list in ufshcd
> ---
> Changes in v2:
> =C2=A0 - drop the release callback
> =C2=A0 - init rpmbs list early
> ---
> =C2=A0drivers/ufs/core/ufs-rpmb.c | 8 ++++----
> =C2=A0drivers/ufs/core/ufshcd.c=C2=A0=C2=A0 | 1 +
> =C2=A02 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9..cfd1f074d004 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -128,7 +128,7 @@ static void ufs_rpmb_device_release(struct device *de=
v)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ufs_rpmb_dev *ufs_=
rpmb =3D dev_get_drvdata(dev);
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rpmb_dev_unregister(ufs_rpmb->=
rdev);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(ufs_rpmb);
> =C2=A0}
> =C2=A0
> =C2=A0/* UFS RPMB device registration */
> @@ -152,8 +152,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0INIT_LIST_HEAD(&hba->rpmbs);
> -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct rpmb_descr descr =
=3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0.type =3D RPMB_TYPE_UFS,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0.route_frames =3D ufs_rpmb_route_frames,
> @@ -165,7 +163,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (!cap)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0con=
tinue;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb),
> GFP_KERNEL);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0ufs_rpmb =3D kzalloc_obj(*ufs_rpmb);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (!ufs_rpmb) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret=
 =3D -ENOMEM;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0got=
o err_out;
> @@ -224,6 +222,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(cid);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_for_each_entry_safe(=
it, tmp, &hba->rpmbs, node) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0list_del(&it->node);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0rpmb_dev_unregister(it->rdev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0device_unregister(&it->dev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> @@ -244,6 +243,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* Remove from list first */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0list_del(&ufs_rpmb->node);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* Unregister device */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0rpmb_dev_unregister(ufs_rpmb->rdev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0device_unregister(&ufs_rpmb->dev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d3044a3089b5..60227069db06 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10988,6 +10988,7 @@ int ufshcd_alloc_host(struct device *dev, struct
> ufs_hba **hba_handle)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->nop_out_timeout =3D =
NOP_OUT_TIMEOUT;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_set_sg_entry_size(=
hba, sizeof(struct ufshcd_sg_entry));
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0INIT_LIST_HEAD(&hba->clk_=
list_head);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0INIT_LIST_HEAD(&hba->rpmbs);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_init(&hba->outs=
tanding_lock);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*hba_handle =3D hba;


Hi Ao,

Thanks for the patch. I reviewed the whole RPMB core and OPTEE call sequenc=
ey,
the issue is real,=C2=A0

The issue is the lifetime of ufs_rpmb / ufs_rpmb->dev versus the rpmb devic=
e
rdev when a consumer holds a reference of rdev.


but I don't think we can take this patch. moving rpmb_dev_unregister() into=
 the
remove path and freeing ufs_rpmb eagerly, then make use-after-free.


OP-TEE caches the rpmb device: on the RPMB probe path: optee->rpmb_dev =3D
rpmb_dev_find_device(), whch taking its own reference, and reuses that hand=
le
for every subsequent frame in handle_rpc_func_rpmb_frames(). It only drops =
the
reference in secure-world rescan or at optee teardown. And rpmb_class_intf =
has
only add_dev, but no remove_dev, so nothing tells OP-TEE core when we unreg=
ister
the device.


I think the correct fix belongs in rpmb-core: a revocation barrier so that =
once
rpmb_dev_unregister() returns, route_frames() is guaranteed never to run
again,=C2=A0for example:

     =C2=A0route_frames()
	{
          down_read(&rdev->route_lock);  //block=20
          if (rdev->no_route)
              ret =3D -ENODEV;
          else
              ret =3D rdev->descr.route_frames(rdev->dev.parent, ...);
          up_read(&rdev->route_lock);
          return ret;
      }
     =20
      int rpmb_dev_unregister(struct rpmb_dev *rdev)
      {
          down_write(&rdev->route_lock);  //drain in-flight, block future=
=20
          rdev->no_route =3D true;
          up_write(&rdev->route_lock);
          device_del(&rdev->dev);
          rpmb_dev_put(rdev);
          return 0;
      }  =20
     =20
@jens, how do you think? I'm happy to help with the rpmb-core piece if that=
's
useful.


the INIT_LIST_HEAD() move is a separate patch (NULL deref on the early-retu=
rn
probe paths, since hba->rpmbs is left zeroed). Please split it into new pat=
ch
with a Fixes tag.


Kind regards,=20
Bean

