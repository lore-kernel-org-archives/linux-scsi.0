Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8C8346FB3;
	Sun, 13 Sep 2026 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789321584; cv=pass; b=KguaklRPHtza+hzUCcHzHiqSxRvw+JYZcVUNLTrvAMexNVUO4M3/rgNTxf31umrOptlLmOGlHwWB/3Z64YNC/m/rgb2sJn1raOIID8CS5FDe3dMrcb/hYGedH5JPp5zWGtDuFLjWay60Qd40c4UIl9Eb8/nD9qL++pBllWEhx+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789321584; c=relaxed/simple;
	bh=hJUo93GjokfVlffrFe8OJPp1BWVc/Jw746c+f4+pPSs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cQMEyJOjjUYPoY2oLlvJ49pKR9zFXlZsHblii49Q3AzefPSIagFK0/i7pOK4wTQfKctTZOH05D7NYqUbjeDBpXoH2KGBm24+3N6BslE9K6qPHAD2odnmZIvsv8d1+LxENT2tKLmCl4hyTtEsr8yfVSa6RgOIZk11C9uKAsSrdyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=XVHTGH4E; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=DrI61EzM; arc=pass smtp.client-ip=85.215.255.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="XVHTGH4E";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="DrI61EzM"
ARC-Seal: i=1; a=rsa-sha256; t=1789321399; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=YAvT9qwtUUUoQczest2WUwIBEV/6S2yv42pgSQ/th70Q5hkpT1hArNjFGYSIs8MZmj
    33509vNqh5aeouv8zzBtBPIaloiecOnVaEUnpnx6ViO6pK2I8CNfnfFBodtBGXcK0gnx
    4H1nfw5t4j2JfLp7wWtRV5z9e4vz2G5c9GVUWOqisCJ4MspmtNRcVJ38yUbGGGZaVc4M
    4d9Wcw7CxQLaSRMAv9TVyubPoX7A0YzYkvh9I6plB/RM/M3J1cmoQvCzLWL1uRq9iXq4
    yzgW021FG4K0e+KzNrBZX+WXs5udBM+o/N/yqnLWo0QaxCRN3AX5FSXhCex2VFKuq4BY
    rcHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1789321399;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=hJUo93GjokfVlffrFe8OJPp1BWVc/Jw746c+f4+pPSs=;
    b=CXvwafzsmyxLJcufZrBYc50zHWGIixNFU6q4YnD2EFnKHyk5xoUlOpWxPuLi7G9o+/
    EDMZ3R7a2Y5fqfW1krU3ado5AUGi273V+C5pqiaqqhS5EsPndJGAzzJh1IYu6txvtAex
    EC0n90NHkduyXHjEKvEf1HkD/fbdnpicj91KXe1zngtp9+wmguPwOmMQGNeyMKnhnJ+f
    5SxXiuelmIULE2ChxbXqUpXQk04P3E4ArUGW7i29W0Z85sUTghhB4OcB/xSn2KhHwEuz
    31dv6g19W6Fn6bGeUwwpnJMPaUz2MCqyRj6WykPgMFNi7XPQavyVVeuGmMmw3pzoPMyB
    APnA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1789321399;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=hJUo93GjokfVlffrFe8OJPp1BWVc/Jw746c+f4+pPSs=;
    b=XVHTGH4Etdl7oBFL/huW3Uhx8nvlj4kGt0hE2G9/1PJgShQSirPLTKWDFcomvncdms
    Prg01h15Ed2jlC+A7oMF40JML69rE2dTnK/M06wyrGltOu7ns72vVm/vl/+B4K5cBzUe
    5Pa3QNhEZTWAc9n0VexyYHXVvBlbvlYX0yuRJ/nXvAwpAyUpXKborgVrMQQ+yzoB5ZXT
    +8n7grDf9dj2hRdUryl24lTdVm9VvUcPLGqaJZHmLvY/Y9VII+CeTLLb/L2z11f4qCQN
    RUMK7wgFqlHvYr5hcIgQbGM4aKg3dMHRgvwYKxcuUQfdGQFJbIWneRNP+DjygEU1Qp0H
    ulMg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1789321399;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=hJUo93GjokfVlffrFe8OJPp1BWVc/Jw746c+f4+pPSs=;
    b=DrI61EzMoa7dAmYFA8ydG4PhLnXKYvByHuul8pHTpbjD0L1pwt6NO0V8JpW8+WRtpD
    radfx9/ALKKopbJhYkAA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaZpI+/6SexdTq2f+8K6lHAk8T6d7JrPBNQcWo="
Received: from p200300c587296833b1b3ac6b56381a47.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e128DHhHYRL
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 13 Sep 2026 19:43:17 +0200 (CEST)
Message-ID: <72bf5465fec11fb9442e24c4679f50f288bedb00.camel@iokpp.de>
Subject: Re: [PATCH v4 1/3] rpmb: core: Guard frame requests and teardown
 with mutex
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
 avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
 can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
 tomas.winkler@intel.com, shyamsaini@linux.microsoft.com,
 alex.bennee@linaro.org,  James.Bottomley@HansenPartnership.com,
 linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 13 Sep 2026 19:43:17 +0200
In-Reply-To: <20260913033633.3159296-2-stanleyjhu@google.com>
References: <20260913033633.3159296-1-stanleyjhu@google.com>
	 <20260913033633.3159296-2-stanleyjhu@google.com>
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
> rpmb_route_frames() has no serialisation. That has two independent
> consequences.
>=20
> Concurrent requests on one rpmb_dev corrupt each other. Two kthreads on
> different CPUs issuing RPMB_GET_WRITE_COUNTER against the same UFS RPMB
> region, 20000 iterations each:
>=20
> =C2=A0 thread 0 done: 20000 iterations, mismatches=3D10889, errors=3D0
> =C2=A0 thread 1 done: 20000 iterations, mismatches=3D6141, errors=3D0
> =C2=A0 race complete: MISMATCH=3D17030 ERRORS=3D0
>=20
> A mismatch is a response whose echoed nonce belongs to the other thread,
> so 43% of requests returned somebody else's frame. The errors count is
> transport failures, so nothing failed and the corruption is silent to
> the caller. An authenticated RPMB operation is not one command. The UFS
> provider issues SECURITY PROTOCOL OUT carrying the request, then
> SECURITY PROTOCOL IN to collect the response, with a result read request
> in between for write-type operations. JESD220F 12.4.7 states that any
> request other than a result read overwrites the result register of the
> region, so a request landing in the middle of another initiator's
> sequence destroys its response. The same chapter states that a region
> processes one authenticated operation at a time, so the rpmb_dev is the
> granularity the device itself assumes.
>=20
> A request can also still be in flight when the provider tears down. The
> core reaches the provider through rdev->dev.parent, and the provider is
> free to release that device as soon as rpmb_dev_unregister() returns.
> Reference counting on the rpmb_dev does not prevent this:
> rpmb_dev_unregister() calls device_del(), which drops the reference that
> device_add() took on the parent, so the parent can be freed while the
> rpmb_dev is still alive and still routable. Unbinding a UFS host while a
> consumer holds an rpmb_dev reference and keeps issuing requests:
>=20
> =C2=A0 BUG: KASAN: slab-use-after-free in ufs_rpmb_route_frames+0x328/0x4=
20
> =C2=A0 Read of size 8 at addr fff00000c833bce8 by task rpmb_hold/100
> =C2=A0 Call trace:
> =C2=A0=C2=A0 ufs_rpmb_route_frames+0x328/0x420
> =C2=A0=C2=A0 rpmb_route_frames+0x64/0xd0
> =C2=A0 Freed by task 1:
> =C2=A0=C2=A0 kfree+0x2b8/0x5c4
> =C2=A0=C2=A0 ufs_rpmb_device_release+0x3c/0x60
> =C2=A0=C2=A0 device_release+0xa0/0x1fc
> =C2=A0=C2=A0 device_unregister+0x20/0x38
> =C2=A0=C2=A0 ufs_rpmb_remove+0x130/0x230
> =C2=A0=C2=A0 ufshcd_remove+0x54/0x22c
>=20
> Both measurements needed patches 2/3 and 3/3 of this series applied,
> because UFS RPMB registration fails on mainline. The stable tag is for
> eMMC, which registers today. mmc_route_rpmb_frames() packs the whole
> sequence into one block request, so eMMC is not exposed to the
> interleaving above, but it does have the teardown window:
> mmc_blk_remove() reaches rpmb_dev_unregister() through
> mmc_blk_remove_parts() near its start,while the queue that
> mmc_route_rpmb_frames() submits to is only torn down at the end by
> mmc_blk_remove_req(), whose comment notes that it is freeing the queue
> that stops new requests being accepted. The eMMC window is from source
> reading; I have not reproduced it.
>=20
> The kerneldoc change is part of the fix. Calling rpmb_dev_unregister()
> from a release callback cannot work, because the child rpmb_dev holds a
> reference on its parent, so the parent's release callback never runs.
> The UFS provider does exactly that today, inert only because its
> registration fails; patch 2/3 moves the call to the remove path.
>=20
> Add a mutex and a dead flag to struct rpmb_dev. rpmb_route_frames()
> holds the mutex across the whole sequence and returns -ENODEV once the
> flag is set. rpmb_dev_unregister() sets the flag under the mutex before
> device_del(), so it cannot return while a request is inside the
> provider. Closing the teardown window requires excluding unregistration
> for the whole duration of a request, which is the same exclusion that
> serialises two requests, so one mutex covers both.
>=20
> On the same test with this patch applied, MISMATCH=3D0 and the unbind is
> clean.
>=20

Hi Stanley,

The fix looks right to me, the commit message is too long, it is easier to =
read
the code changes than the message.


> Fixes: 1e9046e3a154 ("rpmb: add Replay Protected Memory Block (RPMB)
> subsystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
> =C2=A0drivers/misc/rpmb-core.c | 34 +++++++++++++++++++++++++++++-----
> =C2=A0include/linux/rpmb.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 ++++++
> =C2=A02 files changed, 35 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/misc/rpmb-core.c b/drivers/misc/rpmb-core.c
> index ecf14acf230a..bbc3c404ad6f 100644
> --- a/drivers/misc/rpmb-core.c
> +++ b/drivers/misc/rpmb-core.c
> @@ -45,16 +45,28 @@ EXPORT_SYMBOL_GPL(rpmb_dev_put);
> =C2=A0 * @rsp:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rpmb response fra=
mes
> =C2=A0 * @rsp_len:=C2=A0=C2=A0=C2=A0length of rpmb response frames in byt=
es
> =C2=A0 *
> + * Context: Might sleep.
> + *
> =C2=A0 * Returns: < 0 on failure
> =C2=A0 */
> =C2=A0int rpmb_route_frames(struct rpmb_dev *rdev, u8 *req,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int req_len=
, u8 *rsp, unsigned int rsp_len)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!req || !req_len || !rsp |=
| !rsp_len)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!rdev || !req || !req_len =
|| !rsp || !rsp_len)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return rdev->descr.route_frame=
s(rdev->dev.parent, req, req_len,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0rsp, rsp_len);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(&rdev->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (rdev->dead) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0I (&rdev->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -ENODEV;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D rdev->descr.route_fram=
es(rdev->dev.parent, req, req_len,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 rsp, rsp_len);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(&rdev->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ret;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(rpmb_route_frames);
> =C2=A0
> @@ -62,6 +74,7 @@ static void rpmb_dev_release(struct device *dev)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct rpmb_dev *rdev =3D=
 to_rpmb_dev(dev);
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_destroy(&rdev->lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ida_free(&rpmb_ida, rdev-=
>id);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(rdev->descr.dev_id)=
;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(rdev);
> @@ -123,8 +136,9 @@ EXPORT_SYMBOL_GPL(rpmb_interface_unregister);
> =C2=A0 * rpmb_dev_unregister() - unregister RPMB partition from the RPMB =
subsystem
> =C2=A0 * @rdev: the rpmb device to unregister
> =C2=A0 *
> - * This function should be called from the release function of the
> - * underlying device used when the RPMB device was registered.
> + * This function should be called from the remove or unbind callback of =
the
> + * underlying device used when the RPMB device was registered, never fro=
m
> + * a device release callback.
> =C2=A0 *
> =C2=A0 * Returns: < 0 on failure
> =C2=A0 */
> @@ -133,6 +147,14 @@ int rpmb_dev_unregister(struct rpmb_dev *rdev)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!rdev)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(&rdev->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (rdev->dead) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0mutex_unlock(&rdev->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return 0;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rdev->dead =3D true;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(&rdev->lock);
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0device_del(&rdev->dev);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rpmb_dev_put(rdev);
> @@ -164,6 +186,7 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev=
,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rdev =3D kzalloc_obj(*rde=
v);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!rdev)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return ERR_PTR(-ENOMEM);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_init(&rdev->lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rdev->descr =3D *descr;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rdev->descr.dev_id =3D km=
emdup(descr->dev_id, descr->dev_id_len,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_K=
ERNEL);
> @@ -194,6 +217,7 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev=
,
> =C2=A0err_free_dev_id:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(rdev->descr.dev_id)=
;
> =C2=A0err_free_rdev:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_destroy(&rdev->lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(rdev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ERR_PTR(ret);
> =C2=A0}
> diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
> index ed3f8e431eff..814ac3e69337 100644
> --- a/include/linux/rpmb.h
> +++ b/include/linux/rpmb.h
> @@ -7,6 +7,7 @@
> =C2=A0#define __RPMB_H__
> =C2=A0
> =C2=A0#include <linux/device.h>
> +#include <linux/mutex.h>
> =C2=A0#include <linux/types.h>
> =C2=A0
> =C2=A0/**
> @@ -48,15 +49,20 @@ struct rpmb_descr {
> =C2=A0 * struct rpmb_dev - device which can support RPMB partition
> =C2=A0 *
> =C2=A0 * @dev=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 : device
> + * @lock=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 : protects in-flight operations against teardown
> =C2=A0 * @id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 : device_id
> =C2=A0 * @list_node=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : linked li=
st node
> =C2=A0 * @descr=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 : RPMB description
> + * @dead=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 : set to true when device is unregistered
> =C2=A0 */
> =C2=A0struct rpmb_dev {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct device dev;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Protects in-flight operatio=
ns against teardown */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mutex lock;

This lock also makes route_frames calls run one at a time, not only protect
against teardown.


> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int id;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct list_head list_nod=
e;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct rpmb_descr descr;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool dead;
> =C2=A0};
> =C2=A0
> =C2=A0#define to_rpmb_dev(x)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0container_of((x), struct rpmb_dev, dev)

Both are nits, feel free to add:

Reviewed-by: Bean Huo <beanhuo@micron.com>

Kind regards,
Bean
