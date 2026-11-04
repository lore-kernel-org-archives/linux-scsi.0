Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759256;
	b=3BdscvFcpzoI6QUDoYd3vacfSTyqS3t4KSm8UGIMI1mpRgztLgEIB9QGa54TDFNPOn0P
	 4//ctk5ERevgcd63VueXTE1wtWFZzVJntfde1sIyytIoatGJx1DDwA2qq1g64+RdDsuIO
	 D76047FQTI0qHsmFg1XhmrlYz4i8x6ISeNWAMwnSwVjWxjotnYEIExhxAhwpI45Yb0oM6
	 dobrLS1vVc52AKOH6/mZ6wdUVD05xvFkrxb0G39Y6LbDmt3ZA4P2F1q9ujJtdNh0hiPOL
	 o3R300QMa6w7qGpozeWcmGcqnlpwIpngdBDcleJr2INbmybGo/U+1yu01pGJ4a1RCtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759256;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=clmuDIq+119PXjzT1KDgdqeM8MiNOxU/YIG6asCzbsE=;
	b=XF/eMLrOF3lf+/F8WyFwHgWQajvuKcgPoYAoFvNe7KPrxxUOYhmEAVNGdqetwTrYZ/0i
	 zvPatJPDntvQ61Jlo9TVSvzSEJ6tflOt0FERm3+U660+IY3HsV7BUkV9dyrHCk9weyD5H
	 rXwIUEIebIO/2JYRLHVHlHYH43X2hmucPnSmub/sLlN5bbxsS4gA0B/A4jZsj4b5qQI+I
	 mdVpyFNBfYKdwpML0w9XCkLtKRhocbV2WAzTtWMt2UPALn3sdUtAzhZJ7X8YhPd8TzDnQ
	 0L1AG9uWucOQB1kNgRDFDpxNSFI8Xt8yUjh19gRIDMAtlBcjlpbI6SmIBfu5Zop+UMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="hlY2/VAq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19614606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlY2/VAq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC091F000C1;
	Wed,  4 Nov 2026 02:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793759255;
	bh=clmuDIq+119PXjzT1KDgdqeM8MiNOxU/YIG6asCzbsE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hlY2/VAqNjxU8n3YxPTMLlRGYJ2nA1No8Zh3FJOMmherW3h3tGrCY/vlUTGoBg5Ne
	 GAC7h/K79+m7flEqBEWyf92pxY4eexQte6K1ZMw8WL6eVeipY4o9zalejJI0Tz+b64
	 ehc3hL9K8v/OfWazjYaMSsDyuNN1nLzLYZ7UtaXNbfR3glJnxX5VJUyVRIMGZ3Zcp5
	 KUoVP9Dm0iWou0CGGkgQQcKKW3dwGN9TenHy05iyF8jMddMATG5tVxi+GKKim3XIL/
	 cEnQLP7Tkl9RslpnRLouoO57bcYKdVc6aF28bWpzRu7OqR7ioaCi4Egk8Bbhj91s1V
	 EJjgp9H1BjLSg==
Message-ID: <sashiko-outbox-196464@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: drop the sas_device reference on port
 add failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261104021352.1467740-1-vulab@iscas.ac.cn>
References: <20261104021352.1467740-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 02:27:35 +0000
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
- [Medium] scsi: mpt3sas: dangling sas_device->rphy in mpt3sas_transport_po=
rt_add()
--

commit 513fa7a846ccb03a4cae94cd2a076f29098310d8
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: mpt3sas: drop the sas_device reference on port add failure

This commit fixes a sas_device reference leak and clears pend_sas_rphy_add
in the out_fail error path of mpt3sas_transport_port_add() when adding a
SAS end device port fails.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3=
sas/mpt3sas_transport.c
> index e74a526efa8db..38259dae91093 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -866,6 +866,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *i=
oc, u16 handle,
>  	sas_port_delete(port);
> =20
>  out_fail:
> +	if (sas_device) {
> +		sas_device->pend_sas_rphy_add =3D 0;
> +		sas_device_put(sas_device);
> +	}

[Severity: Medium]
Should this cleanup block in mpt3sas_transport_port_add() also reset
sas_device->rphy to NULL?

Earlier in mpt3sas_transport_port_add(), when adding a SAS_END_DEVICE,
sas_device->rphy is assigned before sas_rphy_add() is called:

	if (mpt3sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
		rphy =3D sas_end_device_alloc(port);
		sas_device->rphy =3D rphy;
		...
	}
	...
	if ((sas_rphy_add(rphy))) {
		ioc_err(ioc, "failure at %s:%d/%s()!\n",
			__FILE__, __LINE__, __func__);
		sas_rphy_free(rphy);
		rphy =3D NULL;
		goto out_delete_port;
	}

If sas_rphy_add() fails, rphy is freed via sas_rphy_free(rphy), and only
the local rphy variable is cleared before jumping to out_delete_port and
out_fail.

Because sas_device remains on ioc->sas_device_list or
ioc->sas_device_init_list (and is also held by the caller),
sas_device_put(sas_device) in out_fail does not free sas_device, leaving
sas_device->rphy as a dangling pointer that __mpt3sas_get_sdev_by_rphy()
can match against a reallocated sas_rphy at the same address.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104021352.1467=
740-1-vulab@iscas.ac.cn?part=3D1
