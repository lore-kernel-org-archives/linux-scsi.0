Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789232;
	b=g6jNzuzuMa04ClwCvKCTwD6z47ADR5zKhYV1TaSfJX5k3CLYl2c1hD+Z8IURG8oUo1qw
	 YmvagJCnScmlNym4JSpH59bMJ0AfxNffRPxxTDv9cHN1I6qYD2Cd2KPDTcYFC4m9FSIjm
	 p2xRjCJiwmQoOWYRlTIq9zE/sXpg/jbeCrZZPQMc+B76LL9i9KFYi6juwNnEjwWTiAApE
	 jNETxGZzUk/BFHwgaBJNUDT701QhmbCwO0Dn3+0HLyzwr9JZwXcvG+S0VRb3VZwj/WTFK
	 P0MPTc6huP9/q1Q3bgP9omrGONxQQoZNsGdcTFk6iuvlB24kGa35IW690OqPpkgnMhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789232;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zf79cEy+8Un/AITLO+js00cZEaEIwKKBPpRXKe8mF1s=;
	b=V3U3WCUJ/Fn+7HNydXDH+vMyUpaRSkk6ssOIQvhROL72uSvfebSKOJwgYyfob4caC49g
	 1d/CNYWWCK6hU7YGZZqwoMADfselYmBwbVMC7FmcROwe3v1hMC7ZMKtLxRVoWgVYYaRnc
	 aEv8xvCaZL6RLv2W7eey6hD6zCFMUWh0iNKRSYIdJysiyFWBMoJ8lLEujfwObBGQ/3FAm
	 h8tJL2in+bJxHbBpaJhBg0iqPfQWKpQdl/Te+s9jUteHNbKLTh65X/0Go3vI8eSPHmdwV
	 h5C4/AyvshZwZD771I2mlpO9GnfG6iz1DsCQZ6du35BakHmbue9SsVhx+EsoR+s4trA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kAaAGU+k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41369606A31F;
	Mon, 16 Nov 2026 00:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kAaAGU+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07671F000C4;
	Mon, 16 Nov 2026 00:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794789231;
	bh=zf79cEy+8Un/AITLO+js00cZEaEIwKKBPpRXKe8mF1s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kAaAGU+kud1XmI36gk2M5/Bx5ba14vZdpuAcwKxpbhlSCj96caols/iY6jZ1clFAC
	 vLSbPBcKzw/HKK6pQ5C3njEHY9wBGrME9n2n8bCohasPb/P6LaxOWpxhxzisnWVfyf
	 m/cClB7S5oJwr2sOfe4PM4D2+3Y8zYjDPMGe+rtQE1UDFYgoACgoTqMUp21LyU7HWZ
	 1BqpiO3Q7KA/uOVbsQl14kP23C8vGMHWKR+WMHKo0M+Kd1NHmkSW1sTQGsC61wdOrj
	 9g6mPcLCTKquzwdzELzkleuZn1jPeR+RhEvn1k3bVuxJ2OJWmfsvk0GjM3i/mQh6td
	 vx1emLl7B/Fug==
Message-ID: <sashiko-outbox-215953@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 03/18] scsi: target: uring: Create a character
 device per backstore device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-3-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-3-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:33:51 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] scsi: target: uring: incomplete rollback in
  tcmur_destroy_device()
- [Medium] scsi: target: uring: unsafe error unwind in
  tcmur_configure_device()
--

commit d9ed44c0dc0f5b30e64edec0424a89f4739a2cf8
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: uring: Create a character device per backstore device

This commit creates a /dev/tcmurN character device when a target_core_uring
device is configured, ties the device and queue lifetimes to the embedded
struct device, and adds the TCMUR_GET_DEV_INFO ioctl.

> diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_c=
ore_uring.c
> index 135435748d367..d1ca4f16e7d0b 100644
> --- a/drivers/target/target_core_uring.c
> +++ b/drivers/target/target_core_uring.c

[ ... ]

> @@ -143,24 +226,47 @@ static int tcmur_configure_device(struct se_device =
*dev)
>  	if (ret)
>  		return ret;
> =20
> +	ret =3D ida_alloc_max(&tcmur_ida, TCMUR_MINORS - 1, GFP_KERNEL);
> +	if (ret < 0)
> +		goto free_queues;
> +	udev->dev_id =3D ret;
> +
>  	dev->dev_attrib.hw_block_size =3D udev->block_size;
>  	dev->dev_attrib.hw_max_sectors =3D TCMUR_MAX_IO_SIZE / udev->block_size;
>  	dev->dev_attrib.hw_queue_depth =3D udev->nr_queues * udev->queue_depth;
>  	dev->dev_attrib.is_nonrot =3D 1;
> =20
> +	udev->cdev_dev.devt =3D MKDEV(MAJOR(tcmur_devt), udev->dev_id);
> +	ret =3D dev_set_name(&udev->cdev_dev, "tcmur%d", udev->dev_id);
> +	if (ret)
> +		goto free_id;
> +
> +	cdev_init(&udev->cdev, &tcmur_ch_fops);
> +	udev->cdev.owner =3D THIS_MODULE;
> +	ret =3D cdev_device_add(&udev->cdev, &udev->cdev_dev);
> +	if (ret)
> +		goto free_id;
> +
>  	return 0;
> +
> +free_id:
> +	ida_free(&tcmur_ida, udev->dev_id);
> +	udev->dev_id =3D -1;
> +free_queues:
> +	tcmur_free_queues(udev);
> +	return ret;
>  }

[Severity: Medium]
Can the free_id error path free udev->queues and udev->dev_id while a file
is still open, or re-register udev->cdev_dev if enabling the device is
retried?

cdev_device_add() publishes udev->cdev via cdev_add() before calling
device_add().  If device_add() fails, a process may already have opened the
character device before cdev_del() runs, so freeing udev->dev_id and
udev->queues here releases resources while that opener still holds a file
referencing udev.  In addition, because DF_CONFIGURED is not set on failure,
a later write to the configfs enable attribute calls
tcmur_configure_device() again on the same udev, running cdev_init() and
device_add() a second time on the embedded udev->cdev and udev->cdev_dev.

> =20
>  static void tcmur_destroy_device(struct se_device *dev)
>  {
>  	struct tcmur_dev *udev =3D TCMUR_DEV(dev);
> =20
> -	tcmur_free_queues(udev);
> +	cdev_device_del(&udev->cdev, &udev->cdev_dev);
>  }

[Severity: Medium]
What cleans up udev->queues and udev->dev_id if target_configure_device()
fails after tcmur_configure_device() succeeds?

drivers/target/target_core_device.c:target_configure_device() {
    ...
	ret =3D core_setup_alua(dev);
	if (ret)
		goto out_destroy_device;
    ...
out_destroy_device:
	dev->transport->destroy_device(dev);
    ...
}

When core_setup_alua() fails, target_configure_device() calls
tcmur_destroy_device() without setting DF_CONFIGURED or calling
tcmur_free_device(), so udev->cdev_dev keeps its initial reference and
tcmur_cdev_release() does not run.  The unconfigured se_device stays alive
in configfs with udev->queues still allocated, udev->dev_id still set, and
udev->cdev_dev already passed through device_add() and device_del().

If the user then increases nr_queues via tcmur_set_configfs_dev_params()
before removing the device, tcmur_free_queues() reads past the end of the
old udev->queues array and passes out-of-bounds pointers to vfree().  If the
user instead retries enabling the device, tcmur_configure_device() leaks the
previous udev->queues and udev->dev_id and calls cdev_init() and
device_add() a second time on the embedded udev->cdev and udev->cdev_dev.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D3
