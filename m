Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794241114;
	b=bsnd2RparjVgwS66GZUD7frhtKHAURd/aEshxVJHtGKwxEKLOR/+BiyeeyrRIVzc8Fdn
	 F6hT3YMR4vRErkynoR6YPFg5tNTgNDPHCqEPHlTwVoarwkC55MluoQYTWrkkY+BbND8oK
	 Hw0+asjZsNq7+4hPNNz1QFy8BgEhGWLYWgI5NKmiQOHf6T2r4mib8lsJpn9EaZwOgdW3F
	 MyMjI5KTVIBP0ihiWDa4M9dF1l3JJg5+uqJvoU6gSvLfk7RKY98M0AJM0oPkMszkq95qD
	 KqXBG/Ji+dPunqOV1K7TLQ/5DMpRBTRfk1mD1eYilC2jLCdcm1DYOkY8VtyHTOtnBig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241114;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IWbDuYEasfe3duSQwlmxTT3tk1/PpDubL/YsSJmCQz0=;
	b=kTZTnuhot6xHf4dStWOCLSsbeZ2y33ISR//sqlK0Dh9I8LXxoiX5KP+gvxRHYOxqWrAi
	 Mguw/3flWGPTovgbGCqaLNK/nBQVtIaGsV4Likk2KggXfZ211C2nK7gOnTJq9gqp5AoJH
	 zrJYoDCJqG87Ny/+WO9iirhChe1+H1YIsqWXQXF1uRTZi+1TOhULgIIOGbSPf4qKrZxpo
	 /zPhn0FvdAohYBRWql4s8Tmfy5coK0Rq+/XtjG8CmDrEknK329xk+ZrRRIfic2vZsq5CL
	 WXdNyrmcNwkX5Oj1fY3ELluLO6Lv+Z42hUFFR6Tt9+IR8P+6MuaxkyqKpaP45dcLqjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VczI4T0p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2B2606A330
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VczI4T0p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C461F008A1;
	Mon,  9 Nov 2026 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794241114;
	bh=IWbDuYEasfe3duSQwlmxTT3tk1/PpDubL/YsSJmCQz0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VczI4T0pIApyEBQkkMOfCXgNKo+t2IU93UOq3bBYDWCjzX70jT4p+p2pqxE7dNJwz
	 tXTL1dUdCjFa/uYTQH5u2mEKowfQeX+zX9nO9T62kdaCkcXMh8VYstIqoJX5GQU0Li
	 bBPrHJSrkQMtKZkVZiOHeR/JVGK83s3o9bq82lz28FOn80mvnXM2226jUEx/QHvcwK
	 v8NWs1u4/rmh2QImhuDt7GFJMiBcOiRO3DTbLCh7i1kTA3BECL4xS8mIm1PdIhndGY
	 ojgIuruZXOkcwUlErJIeNAMOSXzlYYd7fXGLTfBYKkv1U/vZ31sq3T89p/LXG/16rP
	 8CNXI1P56HgTQ==
Message-ID: <sashiko-outbox-205221@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ch: Remove the minor from ch_index_idr after
 device_destroy()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261109160651.986356-1-lcy8047@gmail.com>
References: <20261109160651.986356-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 16:18:33 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] scsi: ch: use-after-free in ch_probe() [1]
--

commit 170bbda8f45c76e2fbb5ceaccd99874da50253d8
Author: Changyul Lee <lcy8047@gmail.com>

scsi: ch: Remove the minor from ch_index_idr after device_destroy()

This commit replaces the minor's entry in ch_index_idr with NULL before
calling device_destroy() in ch_remove() and removes the minor from the
IDR only afterward so a concurrent probe cannot reuse the minor while the
sysfs device still exists.

> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index b2c9fb71c9e0a..390425671a3a7 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -952,11 +952,15 @@ static void ch_remove(struct scsi_device *sd)
>  	scsi_changer *ch =3D dev_get_drvdata(dev);
> =20
>  	spin_lock(&ch_index_lock);
> -	idr_remove(&ch_index_idr, ch->minor);
> +	idr_replace(&ch_index_idr, NULL, ch->minor);
>  	dev_set_drvdata(dev, NULL);
>  	spin_unlock(&ch_index_lock);
> =20
>  	device_destroy(&ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR, ch->minor));
> +
> +	spin_lock(&ch_index_lock);
> +	idr_remove(&ch_index_idr, ch->minor);
> +	spin_unlock(&ch_index_lock);
>  	scsi_device_put(ch->device);
>  	kref_put(&ch->ref, ch_destroy);
>  }

[Severity: Critical]
This problem wasn't introduced by this patch, but can ch_probe() trigger
a use-after-free on ch [1] if an error occurs after ch is published
in ch_index_idr?

ch_probe() inserts ch directly into ch_index_idr and initializes ch->ref
before calling device_create() and ch_readconfig(), and its error path
frees ch with kfree(ch) instead of kref_put():

drivers/scsi/ch.c:ch_probe() {
	...
	ret =3D idr_alloc(&ch_index_idr, ch, 0, CH_MAX_DEVS + 1, GFP_NOWAIT);
	...
	kref_init(&ch->ref);
	...
	ret =3D ch_readconfig(ch);
	if (ret) {
		mutex_unlock(&ch->lock);
		goto destroy_dev;
	}
	...
destroy_dev:
	device_destroy(&ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR, ch->minor));
put_device:
	scsi_device_put(sd);
remove_idr:
	idr_remove(&ch_index_idr, ch->minor);
free_ch:
	kfree(ch);
	return ret;
}

If ch_readconfig() fails after a concurrent ch_open() looks up ch in
ch_index_idr and takes a reference, ch_open() dereferences freed memory:

CPU0                              CPU1
ch_probe()
  idr_alloc(&ch_index_idr, ch, ...)
  kref_init(&ch->ref)
                                  ch_open()
                                    ch =3D idr_find(&ch_index_idr, minor)
                                    kref_get(&ch->ref)
  ch_readconfig(ch) /* fails */
  idr_remove(&ch_index_idr, ch->minor)
  kfree(ch)
                                    mutex_lock(&ch->lock)  <-- use-after-fr=
ee

[1] https://sashiko.dev/#/bug/linux-f4be7a8e-e1b8-4f47-9f47-c6a01d983399

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109160651.9863=
56-1-lcy8047@gmail.com?part=3D1
