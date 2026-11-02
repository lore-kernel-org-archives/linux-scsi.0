Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793627949;
	b=A9Ysi20xDtUQbj2MJNMSae+4gc+cTF1QuY+d2j7fXktJuZ6t0cARfwiYg1F+60QP8LVb
	 HU62fc6PkxsIso1386MfLH40jFBO0TJMyPQdpGpkryrjfch/DRs5HI9KDwEwWVGEMksmB
	 YYiJD9QtTmMJkAGS84q9sjgHFj9T7K1mp58skI7Z6hVnrHeGLiEDE8TRXIwXOfrcnx9Be
	 /MJeDJGEeVop5khatyZUkRJjmbT6WVyr5CCwnB4hSDa4ua4/1I+nHY4XrV9aEdfBZhtmv
	 fBALTvuahPBBRhSg6Yv+Xy3M/+tMkNtZIzES9Jyscvf8eOAV4oh/v5wMxXi5pJ7JYfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793627949;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Hp60KYe/G+wIBHX0urJ01qD/WmuXk35eX18sVskhLdk=;
	b=07bYOA1h49vHzzuanmLuQwh6lQNGMutHtWaAJNB0jMDmImFZM5D3IbE8bp9LvQS3dPtF
	 w18/h8HdZJuv51UwN78IrYWFvmRKT6sUwq7kT9cyuSso/IXQoz26L1yUrd5rFTwCfXmMk
	 6vhnWEAGwhtDxiEIXySgHmGeR2hWt+WSRYNFZ/LnIn9rpnHrn6z5ZE4KE5H7wx7+MsmvF
	 IIo2KfjKISYw/MrOZ5YAZmzVqrUgpkZJImMX7qKyj8piFPAZQimb52SLFviuVV/zi99oA
	 F8xU5S95rOIWgKPuVmS25wqtHVgW6SGmruVGVh4dyPozy7J8eOkKXlO+Pt9H9Lqnutw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAbyaC+s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EBD60A2624
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAbyaC+s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9D11F00A1A;
	Mon,  2 Nov 2026 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793627949;
	bh=Hp60KYe/G+wIBHX0urJ01qD/WmuXk35eX18sVskhLdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RAbyaC+s5g3T+lf1INzeJbQ7oOvf3WbDBsGISVBelnz1nPMHvTrVa0bgfxRsoWd9H
	 L/ykbeoOdgmdzBkF0rCPsqnil88cGG7WiTrdgMK7yCVF3iripHLPz5/GIWkZiUh2c5
	 JxAWo90IEnIRc4IkNU/s167gcgBcYRjLzqECz6ChUjHMbCJDKQYn0883x9KUkZKWzo
	 R66XViNucCOyIKFVVifny/w72QkMl5uX2wHBEmtgVfBSPeMPGdzjdb0rNdIHTOCqW5
	 qVWZ5YQ6gPTXq/FWKCt4THbFyMkZUBXZoD3+AWGXJhvmfFQ84q37yB3tXt1kx3TNpq
	 PG7vvf/uHmbSA==
Message-ID: <sashiko-outbox-193512@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: mpt3sas: Serialize interrupt-time sdev
 block with hostdata teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Layton" <jlayton@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261102-sas-abba-v2-1-b3b9ba874b5a@kernel.org>
References: <20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org>
 <20261102-sas-abba-v2-1-b3b9ba874b5a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 13:59:08 +0000
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
- [Medium] scsi: mpt3sas: unserialized sdev->hostdata publication in scsih_=
sdev_init()
--

commit 4a6206c3cdf6053f62da0b3cf7f294219f312a94
Author: Jeff Layton <jlayton@kernel.org>

scsi: mpt3sas: Serialize interrupt-time sdev block with hostdata teardown

This commit adds ioc->block_lock to serialize interrupt-time device blocking
in _scsih_block_io_device() against sdev->hostdata teardown in
scsih_sdev_destroy().

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 085d4672db854..c7886a12d3088 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c

[ ... ]

> @@ -4234,26 +4238,30 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *io=
c, u16 handle)
>  	struct MPT3SAS_DEVICE *sas_device_priv_data;
>  	struct scsi_device *sdev;
>  	struct _sas_device *sas_device;
> +	unsigned long flags;
> =20
>  	sas_device =3D mpt3sas_get_sdev_by_handle(ioc, handle);
> =20
>  	shost_for_each_device(sdev, ioc->shost) {
> +		spin_lock_irqsave(&ioc->block_lock, flags);
>  		sas_device_priv_data =3D sdev->hostdata;
>  		if (!sas_device_priv_data)
> -			continue;
> +			goto next;
>  		if (sas_device_priv_data->sas_target->handle !=3D handle)
> -			continue;
> +			goto next;

[Severity: Medium]
During LUN scanning, scsi_alloc_sdev() calls scsi_sysfs_device_initialize(),
which links sdev onto shost->__devices before invoking shost->hostt->sdev_i=
nit:

drivers/scsi/scsi_scan.c:scsi_alloc_sdev() {
	...
	scsi_sysfs_device_initialize(sdev);
	...
	if (shost->hostt->sdev_init) {
		ret =3D shost->hostt->sdev_init(sdev);
	...
}

Because sdev is already in state SDEV_CREATED on shost->__devices,
shost_for_each_device() in _scsih_block_io_device() can visit sdev while
scsih_sdev_init() is executing concurrently on another CPU:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:scsih_sdev_init() {
	...
	sas_device_priv_data->lun =3D sdev->lun;
	sas_device_priv_data->flags =3D MPT_DEVICE_FLAGS_INIT;

	starget =3D scsi_target(sdev);
	sas_target_priv_data =3D starget->hostdata;
	sas_target_priv_data->num_luns++;
	sas_device_priv_data->sas_target =3D sas_target_priv_data;
	sdev->hostdata =3D sas_device_priv_data;
	...
}

Since scsih_sdev_init() assigns sas_device_priv_data->sas_target and
sdev->hostdata with plain stores without holding ioc->block_lock or using
smp_store_release(), could _scsih_block_io_device() observe a non-NULL
sdev->hostdata before the store to sas_device_priv_data->sas_target is
visible on weakly-ordered architectures, leading to a NULL pointer
dereference when reading sas_device_priv_data->sas_target->handle?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-sas-abba-v=
2-0-b3b9ba874b5a@kernel.org?part=3D1
