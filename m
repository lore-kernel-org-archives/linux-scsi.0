Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793733051;
	b=GnnuJBs/Gpy4x5DEwOJisSqOctYpXFZ3Q6fNq0lefDONGjIWcwf3znNAwwR4+n63H7kn
	 qPw1hj97HqmStx1+FcnvblCxf0xwpx0ualTmlT/UD6OMecu3DmgiISIQqofvLBr5BXlsx
	 42kHx0OxXOcM2B3OQaTl3DfcyxMFZVxnlh5dIDFOy/mceHgUfwhUzBN0n5U9TsXzd30Ap
	 uvoCHWmjgb3K1E6L2QIBU9hj023pDN2w0uzFqJV7dHuuldJALM5xvcW+c3KnI7RoOyVzR
	 VAnzyNkm6VjXQWzQT7qYqKOY1/dH8YDw5Rp663w29mbgtWPMNADm1Ayg/ImXpagdlVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793733051;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SCgrSDwLDu14W01y6Ed79QNuMBmDXe4Hq20eB+nbXuU=;
	b=Fae9UPCi81jkgTkppL9FF4AYJ+VkGvcJMOqTJrtVysKtPJeWOJ0auZ04UhuwKbr2yLRC
	 muSqCoAwdTnWqdMCi1eXgKB7bIhG1X7w+/ApevNPKe/U5cqeIGDKLKNnn3olhAD3Kkjud
	 5/XqV2I/4Bpl+AgU/TXStGLKnqMhp2g7dRdFw6yyhwI7gA/M0VYbVVmNDSYziVAdXMG8j
	 J/SXwOGvuB9D4LMDauUavamUo6j+O+ZLINxLzzOHgkWo8WzSRLpVO25enydNy0ZAylPas
	 48gJMXNFuqcl1WjEvDFtXbpvg+0RrXvEnKLXuAbA3kC1+wl28lcIFv9vuimUG+Yxaqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J4exoOYq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD37E606A324
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J4exoOYq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1CD1F000C1;
	Tue,  3 Nov 2026 19:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793733050;
	bh=SCgrSDwLDu14W01y6Ed79QNuMBmDXe4Hq20eB+nbXuU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=J4exoOYqGX1Td/nxWFwjyL5QoLsfEbI4hpActMZMgR82/uUAFzz8v50n8wieArdIW
	 usAtYZAioM8XQu5a8Cgzjs98op/HyuKAglWKHJMWsmPPpANev62M/1Lgz/uW4tMTFe
	 mvP3T78v1eRkk6PciJyNWf1ohXYM493IywwB9x+aYQY0nKHijDk958YSCSO2wiA9Hg
	 vq344dFMJ1A4YBJqKkQoxKY3ilnxb1IKVQCGdSoWmpAWvlhliK7+xBKJgaF1BZS8Lf
	 qxkNqpE6ujB4lnete2YB0xnmpj0IHKkJvpy7rCPtHw0EjkKZoDXqPI3OxWJl2Aqulv
	 4IQcFQ24Ihxbw==
Message-ID: <sashiko-outbox-195904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: unregister RPMB devices before
 their parent
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, linux-scsi@vger.kernel.org
In-Reply-To: <20261104025930358oLNtuTSPBX9Wqd6hMaegb@zte.com.cn>
References: <202611040259247915t_cYYK0k5pPbEqfdTAQu@zte.com.cn>
 <20261104025930358oLNtuTSPBX9Wqd6hMaegb@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 19:10:49 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ufs: core: devm_kzalloc() used for struct device in ufs_rpmb=
_probe()
--

commit dec08b39580959e5820891b21f9cd97a5b04657e
Author: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

scsi: ufs: core: unregister RPMB devices before their parent

This commit adds ufs_rpmb_unregister_device() to unregister ufs_rpmb->rdev
before calling device_unregister(&ufs_rpmb->dev) during ufs_rpmb_remove()
and the ufs_rpmb_probe() error path, and updates ufs_rpmb_device_release()
to check whether ufs_rpmb->rdev is non-NULL before unregistering it.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 65f2d71cf073b..1ed57d50c3ff0 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -149,11 +149,19 @@ static int ufs_rpmb_route_frames(struct device *dev=
, u8 *req, unsigned int req_l
>  	return ret;
>  }
> =20
> +static void ufs_rpmb_unregister_device(struct ufs_rpmb_dev *ufs_rpmb)
> +{
> +	rpmb_dev_unregister(ufs_rpmb->rdev);
> +	ufs_rpmb->rdev =3D NULL;
> +	device_unregister(&ufs_rpmb->dev);
> +}
> +
>  static void ufs_rpmb_device_release(struct device *dev)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);
> =20
> -	rpmb_dev_unregister(ufs_rpmb->rdev);
> +	if (ufs_rpmb->rdev)
> +		rpmb_dev_unregister(ufs_rpmb->rdev);
>  }

[Severity: High]
Can ufs_rpmb->rdev ever be non-NULL in ufs_rpmb_device_release(), and can
dereferencing ufs_rpmb here cause a use-after-free?

In drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_probe(), struct ufs_rpmb_dev embeds
struct device dev, yet it is allocated with devm_kzalloc() on hba->dev:

    ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
    ...
    ufs_rpmb->dev.release =3D ufs_rpmb_device_release;

While ufs_rpmb->rdev is registered, rdev->dev.parent points to
&ufs_rpmb->dev and holds a reference on it until rpmb_dev_unregister() calls
device_del(&rdev->dev). The only caller of rpmb_dev_unregister() is
ufs_rpmb_unregister_device(), which sets ufs_rpmb->rdev =3D NULL before
calling device_unregister(&ufs_rpmb->dev), and on probe error paths prior to
rpmb_dev_register(), ufs_rpmb->rdev is already NULL. As a result,
ufs_rpmb->rdev is always NULL when ufs_rpmb_device_release() runs.

More importantly, because ufs_rpmb is allocated with devm_kzalloc(hba->dev,
...), its memory is freed when hba->dev detaches rather than when the
reference count on ufs_rpmb->dev drops to zero. In rpmb_dev_unregister(),
device_del(&rdev->dev) drops the parent reference on &ufs_rpmb->dev
immediately even if OP-TEE still holds a reference to rdev (for example via
optee->rpmb_dev or an in-flight RPMB frame request), and sysfs or
CONFIG_DEBUG_KOBJECT_RELEASE can also keep &ufs_rpmb->dev alive past HBA
driver unbind. Once devres_release_all(hba->dev) frees ufs_rpmb, a subseque=
nt
call to ufs_rpmb_route_frames() or the final put_device(&ufs_rpmb->dev) ->
ufs_rpmb_device_release() will dereference freed ufs_rpmb memory. (Also, if
ufs_rpmb_probe() fails, ufshcd_add_lus() ignores the error and continues,
leaving the devm-allocated ufs_rpmb leaked until HBA removal.)

Should ufs_rpmb_probe() allocate ufs_rpmb with kzalloc() and have
ufs_rpmb_device_release() free it with kfree(ufs_rpmb), matching how
mmc_blk_alloc_rpmb_part() and mmc_blk_rpmb_device_release() manage struct
mmc_rpmb_data in drivers/mmc/core/block.c?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/202611040259247915t=
_cYYK0k5pPbEqfdTAQu@zte.com.cn?part=3D1
