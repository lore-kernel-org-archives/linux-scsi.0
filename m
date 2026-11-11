Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409325;
	b=aHdvdeKJjNmEeCLXmCcPX16C1I8JzdjEj2uf6XOSJAxLjGh4aEcLRHx+gPcy3hiDV4Du
	 +4tGtkctKb3x+ravTADO/5kvwl+eGn6c99b8UfOza7YG9dJ/PY/OGVIlaHmYEWz2Xdglu
	 4IGzOxRBtB72HxzaUz8e/HU+3+U6R7TWidjj6lRM7Mj0rmW85gQAk9Y4JwN+zoOf33UYB
	 hUfE8m3U9NDYetPNXKlJde5zgn6oy+GsREVOpfGnOPQjL1NrweoeIMj5y5c8n1t+USTYQ
	 akxZuiOye0elzfTEt6Swmol9nRDh2fRLWrcCp/wHMs7rKIxntJrxUtPG987ON+943RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409325;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=b6SvGB8kKqPUOQP26F4ZdFDXmmxIL4Ia8xZRcT+x4Wo=;
	b=EbRuH/21QLPGt3mGxbWGM2+yMMnWWMXr/8r4InbByJsx6uLXCPp4TD1d86Debmaq6CQc
	 ZltWR/V9moZlGOYAOVlMT/IqoP+UOWrogIzQDdJKGhKNjklCv+hI4VdOT9OuKsNaKRgVY
	 8wBjkOyEyeMppJ6/1bOffZ18TEJDE7/zVbbHEU5sgeFOP22vkCtkQ2prZ98mF+D2fxVsD
	 rXz9d+0pleei+9l84xNYZmJCRtcq1yB0weeM8F32l6GEdsmSUzgcofVSGhS2ozUgdy2AC
	 z7RD11zIgy1rnjULgzgYz/corvTx1OCaL8fzx4h2Rj3HhovWAGdPqQSpyGq5GNJxypg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ap3Jhk+b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1529F606A321
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ap3Jhk+b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5661F00A06;
	Wed, 11 Nov 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794409324;
	bh=b6SvGB8kKqPUOQP26F4ZdFDXmmxIL4Ia8xZRcT+x4Wo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ap3Jhk+bQAWN9PMTHH/C33CYwcnpbgRHkWt0vGDYclnvL/DEqFA/0QXaseuMakaut
	 1E/zFurtIqM3odzZ1LG+H578dl99QUVJTFkaBDBRU0kTvixmyIk5tHza4CQ/iABVgp
	 +/ka13n/Vnx7PuN5hniute6vXL7E1rAbn6B/CshBRBI4tRsLhSXMvGsRQRXfomczIk
	 X3u+xArsbZrfFkGB/webOoj9MyeduCs7jHBdnsjcOy/b+wREZxO6oYT8hNHhY4nUw/
	 p1nepJkwEW3sIUk9gptVjO11cBeLDHgqO2igvXasgs/36idqJ86Qf2eMxiiBdgxo2i
	 MTZswhhPJ2zOw==
Message-ID: <sashiko-outbox-209211@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Register the RPMB bus before adding
 devices to it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexey Charkov" <alchark@flipper.net>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261111-ufs-rpmb-bus-v1-1-b07100e53f6c@flipper.net>
References: <20261111-ufs-rpmb-bus-v1-1-b07100e53f6c@flipper.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 15:02:04 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: ufs: core: bus device name collision in
  ufs_rpmb_probe()
--

commit d7d8b8a6fbcbb4705a5d1c464cb5ca946759c72a
Author: Alexey Charkov <alchark@flipper.net>

scsi: ufs: core: Register the RPMB bus before adding devices to it

This commit registers ufs_rpmb_bus_type during ufshcd-core initialization
and unregisters it on exit so that RPMB region devices can be added to the
bus.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 7566733376480..591e7f2e14740 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -276,5 +276,15 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
>  	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
>  }
> =20
> +int __init ufs_rpmb_bus_init(void)
> +{
> +	return bus_register(&ufs_rpmb_bus_type);
> +}

[Severity: Medium]
With ufs_rpmb_bus_type registered, can ufs_rpmb_probe() fail with -EEXIST
on systems with more than one UFS host controller?

ufs_rpmb_probe() names each device using only the per-controller region
index:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_probe() {
	...
		dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
	...
		ret =3D device_register(&ufs_rpmb->dev);
	...
}

Because bus_add_device() creates a symlink named dev_name(dev) in the
shared /sys/bus/ufs_rpmb/devices/ directory, the second controller's
"ufs_rpmb0" collides with the first controller's and leaves OP-TEE RPMB
unavailable on additional controllers.  Including hba->host->host_no in
the device name (as ufs_bsg_probe() does) would keep the names unique
across controllers.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ufs-rpmb-b=
us-v1-1-b07100e53f6c@flipper.net?part=3D1
