Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243546;
	b=GbbaJWuElnqG10tTVz73v5jYXgj/rpwhvGhSD9wm7IsueH7bvw4ckisaoBTGhp3m64oe
	 B5XHegR3xuASlR2vZgznE3g5V+M9ruQoye5013Y85xdRaoOAbkHkGUv1IninlAgcrzJrU
	 jEDxStlNfOsPRLHP3oupZM0o0arqDbQ/izrFLH44FJT7KlTrkJr0SkubwpX/hb1+Zma8A
	 5fqrplhPlDHfRj05fSlN33fttwraMQZvLue65pOoysj0H1S3dIm1RlduoLQpS+225hKkA
	 DN7HYUJGpG/89csXooAhSRwNbQAXdnRr38oVKbmlSslyghkfVTt8KejeZ7QDd7klbSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243546;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WYdmfI7bVay5rHSRxixMK14CB+up5qwSvYWPH3fTx8U=;
	b=NRZrfpUX7JEMklXTuUrXO+6dkbUoCOhy0XeHG5mZMdpbmp5dwG2jYmJMLhyYcjI3+uRa
	 1n9APFXcVrH6ajuZ02d4AnsoN9cFPWhyjhbNl3mV3UMscg4vjQoST19rIkogovu9qlxDG
	 i8RwgkEkpBhqDvaTIHN+hBuAEUc9g7THsGQw/DfRXe0TeBcc6JWkUVhRP0sjj403QkLxu
	 OJiEK6Y/Jpod+rIx4A8aF8nVAuHcOYZVdcja3DxTsDJ3YMiA56jBEvhs66eWaXDh8UkWK
	 CIqFudZ+VPN3qooBBmyuO+7uuPaHH87EGwrCTT4YvR62CmnY53RJN1okGS0ChcH4ZZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QnW5Ie3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C2B606A325
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QnW5Ie3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5331F008A1;
	Mon,  9 Nov 2026 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243545;
	bh=WYdmfI7bVay5rHSRxixMK14CB+up5qwSvYWPH3fTx8U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QnW5Ie3gUiHUHhW+/XS6ZbOPSUZvmIUyW3q72kYGe+D6Vefa8y/V1h9rWp3MWnCdl
	 AaazcpbirgmBBm7rmyzHUOBMV+jgVNvVw5Z/vr0bdoJpOLFNIp+3YyNOb5kD68F6Jp
	 gwLpn129ZVWxtOr8fwZH9+9L9q+naRGdupDj94dz0R64rTDiSBTXuEZ4h2BlJ+nHx0
	 SwqHpwqR5OH82/PE3XOtpOCZwmiVTrhdPvLwDUfp/4a2VMGbO/OSbHACvwIw7y3HLy
	 tDx9f6USqWGxkpltvfd+pGWlJsJpZfDwuR2ld/7dt8bkLbDYPACQnltxjyJcp2G7we
	 S2FsLYLhhXxUQ==
Message-ID: <sashiko-outbox-205259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: iscsi: Remove the endpoint ID only once when
 device_register() fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261109163649.1092897-1-lcy8047@gmail.com>
References: <20261109163649.1092897-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 16:59:04 +0000
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
- [Medium] scsi: iscsi: failed ep left in iscsi_ep_idr in
  iscsi_create_endpoint()
--

commit bcf1b2eaf3554e78f33bb71b87b333ff7a9501a1
Author: Changyul Lee <lcy8047@gmail.com>

scsi: iscsi: Remove the endpoint ID only once when device_register() fails

This commit drops the explicit idr_remove() from the device_register()
error path in iscsi_create_endpoint() so that iscsi_endpoint_release()
removes the endpoint ID once.

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
> index b094af7c997e2..6e38fbfd5a9de 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -246,9 +246,6 @@ iscsi_create_endpoint(int dd_size)
>  	return NULL;
> =20
>  put_dev:
> -	mutex_lock(&iscsi_ep_idr_mutex);
> -	idr_remove(&iscsi_ep_idr, id);
> -	mutex_unlock(&iscsi_ep_idr_mutex);
>  	put_device(&ep->dev);
>  	return NULL;
>  free_ep:

[Severity: Medium]
Does leaving ep in iscsi_ep_idr here allow iscsi_lookup_endpoint() to
find the failed endpoint after put_device() drops its reference count to
zero?

iscsi_create_endpoint() publishes ep in iscsi_ep_idr before calling
device_register(&ep->dev) and before setting ep->dd_data:

CPU0                                  CPU1
iscsi_create_endpoint()
  idr_alloc(&iscsi_ep_idr, ep, ...)
  device_register(&ep->dev) -> fails
  put_device(&ep->dev)
    kref_put(&kobj->kref, ...)
      /* kref reaches 0 */
                                      iscsi_lookup_endpoint()
                                        ep =3D idr_find(&iscsi_ep_idr, ...)
                                        get_device(&ep->dev)  <-- use-after=
-free
      iscsi_endpoint_release()
        mutex_lock(&iscsi_ep_idr_mutex)
        idr_remove(&iscsi_ep_idr, ep->id)
        kfree(ep)

In addition to the refcount addition on zero and use-after-free on ep,
ep->dd_data is still NULL because the error path skipped its
initialization, so callers of iscsi_lookup_endpoint() such as
iscsi_if_ep_disconnect() -> transport->ep_disconnect() will dereference a
NULL pointer.

Replacing the pointer with NULL via idr_replace(&iscsi_ep_idr, NULL, id)
under iscsi_ep_idr_mutex before put_device(&ep->dev) would hide the
failed endpoint from lookups while keeping the ID reserved until
iscsi_endpoint_release() removes it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109163649.1092=
897-1-lcy8047@gmail.com?part=3D1
