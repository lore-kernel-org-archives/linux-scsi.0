Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794171768;
	b=LoYvf4ugH4lgy1ZTWC85wa70f8wWQ+sG6OtqnuSeE0y8elr3Hgi+R2xhBhxyvbzVMY5O
	 w4s6douxPCEZDmlN3ur0UZwMhyS1majseehHI4Jo3V41SQpUEZ4I7ALvwDRPxva9IfdCY
	 5zeBsOAe27KfxvJAtM5dI9QuJYyUySjPmZ6X01kvWS3lAsxI8xCqWxM/Eu7uEh6CYIGFW
	 w+lk1YreMIyEtfcTk8WD5zsNdGzPPlT1J3EJ1BzzvVUO5v91MKelbt6QikcnbvZJzN3xP
	 3AHC+alUMbQNBVf3N0m1LUAOFfGXx6W9dxqI4GaDDVsRQsoQA1bzs9tm5HNEJvG0XHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794171768;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZOaH1T4j6iP+c7Um2ZMTbLe681u2iyfuCqiIs0/2p4I=;
	b=cioJ0S7mm2PO+pvLIxC6UoDneFbVGGR/tkfs2T9aRd95QFV9b892pmymU5J64C+f6nU3
	 OktHqGfv0fs8PVlQZTBEs4IyjjhJGI7XsW0LMqiCaDXFh6KOJJYdLWXX6sAobNxZ/4o3A
	 MQzml6gk8fuCzZrF44G/7IpQWsWgYdJe4zs5VYAWDez784duTlH09H/SWKRPcHn4SRcu/
	 PxNKqlqi/HbdGIcOs2D2hmBA8s4NN+0Xf3/wQc33Yy21hpGB/EHr1KfagZv5BYH7ouQTR
	 4+b39Sn85lgTA5GxOLZlHw0YmNmh9OfeS++QhxDzh5MGtFX0uIdscwY0n0HvvYKrTPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vk9nNIcZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18472606A320;
	Sun,  8 Nov 2026 21:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vk9nNIcZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA431F008A2;
	Sun,  8 Nov 2026 21:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794171767;
	bh=ZOaH1T4j6iP+c7Um2ZMTbLe681u2iyfuCqiIs0/2p4I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vk9nNIcZkyDrBaeyeKPZjfBLKeKCmns+EiVR7yDIl1G2hbJ3IQXsAgddoyk32XypB
	 W2L1kVth/SLQ+YV21z0FpFuBxJleNnq7R6YesnMetTuIpP9E/fV6p1TJhi1wDvp/+4
	 VIEFRbdpGvBdVKkVhkP19VtLP/kNfhAnLw5Q9T4edk6qiKF9+dr7dsIWoq4UJHgdzK
	 g0VBGmSaSx4voZmDxEn3Xt0vG+dKf7LUFQNVmSRz3y0sepm6I0IdbO+N/4aEav3tYA
	 kKe0nCzvICOuQS76CVD0IE7sBEFGMiG8ObNzLrbFlKK4rxNDZiSDpA7YwR4zLZCIHl
	 kjUH9xIq4H6Gw==
Message-ID: <sashiko-outbox-204045@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 12/29] scsi-multipath: introduce basic SCSI device
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-13-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-13-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:02:46 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Low] scsi: CONFIG_SCSI_MULTIPATH depends on SCSI_MOD instead of SCSI
- [Low] scsi: duplicate MODULE_DESCRIPTION and MODULE_LICENSE in
  scsi_multipath.c
- [Low] scsi-multipath: off-by-one truncation check in
  scsi_mpath_unique_lun_id()
--

commit 006413118882829d81f9e30417cb6f7346390426
Author: John Garry <john.garry@linux.dev>

scsi-multipath: introduce basic SCSI device support

This commit introduces struct scsi_mpath_device, the scsi_mod.multipath
module parameter, and per-device multipath allocation and release hooks
during SCSI LUN scanning and device teardown.

> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 90b65bebec703..2491fdf6f563e 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
> =20
>  	  If unsure say N.
> =20
> +config SCSI_MULTIPATH
> +	bool "SCSI multipath support (EXPERIMENTAL)"
> +	depends on SCSI_MOD
> +	select LIBMULTIPATH
> +	help
> +	  This option enables support for native SCSI multipath support for
> +	  SCSI host.
> +
> +	  If unsure say N.
> +

[Severity: Low]
Should SCSI_MULTIPATH depend on SCSI instead of SCSI_MOD?

SCSI_MOD defaults to y when SCSI=3Dn and BLOCK=3Dy:

drivers/scsi/Kconfig:
    config SCSI_MOD
    	tristate
    	default y if SCSI=3Dn || SCSI=3Dy
    	default m if SCSI=3Dm
    	depends on BLOCK

When CONFIG_SCSI=3Dn and CONFIG_BLOCK=3Dy, CONFIG_SCSI_MULTIPATH=3Dy can be
enabled, which selects CONFIG_LIBMULTIPATH=3Dy while skipping scsi_mod.o and
drivers/scsi/scsi_multipath.o.

[ ... ]

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> new file mode 100644
> index 0000000000000..97f7513b47122
> --- /dev/null
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -0,0 +1,150 @@

[ ... ]

> +static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +	int ret;
> +
> +	ret =3D scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
> +				SCSI_MPATH_DEVICE_ID_LEN);
> +	if (ret < 0)
> +		return ret;
> +	else if (ret =3D=3D 0)
> +		return -EINVAL;
> +	else if (ret > SCSI_MPATH_DEVICE_ID_LEN)
> +		return -EINVAL;
> +
> +	return 0;
> +}

[Severity: Low]
Should the truncation check test ret >=3D SCSI_MPATH_DEVICE_ID_LEN instead =
of
ret > SCSI_MPATH_DEVICE_ID_LEN?

In scsi_vpd_lun_id(), a T10 Vendor ID designator with 252 or more bytes is
clamped to id_len - 4 (252) and formatted with snprintf(id, id_len,
"t10.%*pE", ...), which truncates device_id_str at 255 characters plus the
NUL terminator and returns 256 (SCSI_MPATH_DEVICE_ID_LEN). Testing
ret > SCSI_MPATH_DEVICE_ID_LEN accepts that truncated identifier.

[ ... ]

> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("scsi_multipath");

[Severity: Low]
Does linking scsi_multipath.o into scsi_mod.o emit duplicate MODULE_LICENSE
and conflicting MODULE_DESCRIPTION entries in scsi_mod's .modinfo section?
drivers/scsi/scsi.c already defines MODULE_DESCRIPTION("SCSI core") and
MODULE_LICENSE("GPL") for scsi_mod.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D12
