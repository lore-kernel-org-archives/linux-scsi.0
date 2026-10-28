Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793229590;
	b=WmJ8KK4qeJrRkk0GfTasi6mJHHJZ9nrWrlCTsWCC5wzOqp0D7RoFXg8JXIWLH3MoOGy3
	 b3Eb4013XFG3LCe9MgRB3+o0A5j3k71xQznRN2TZ1hQva98y1XWdE6E8RluR6qnUcTVHR
	 AxZCoEDGVBZmS+Fas2ctal1JSVso9qoh4zVbhRjwqYvOjBupqfPlgSmi4kIRb+hYaFxG2
	 7FmenD9hCGwwUzt24ya2gyZmST6aCFrt/XGfxPYLs0t8vgeW2pMCIoBDMQ5j6S/RBirTx
	 fbtlb+bOZUsMc9v8VvXevOn/B1gcygJSpOxfx4Hq1Ux3v0+JuoCdugbTvIMzHbM82dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793229590;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hb0Zf2ErEuNgCNccRL3GdmSfQUfFbz64wRnm1NSyEIo=;
	b=UVEKxSYsmvaJr31rWJ93F3QI4zeo7AY9oR4guqVSWh/c3UPdFMAnMsbLmlTlWuzQs3NZ
	 8vytFCd7onbksxKETopeFa60mJi5oXWbHHfgu9ZUPuMAjr7K8BOyv0P9AeoHxRbRD3RuK
	 uXHnYyZBrxNEsq6261dGNqrM8rx3P092SMh1BQyL8Y2tr1kxI3aLCdRke/zUP7OcfjrUg
	 a8CpGoa8l5IMJ5U1KQ5wDO9HWw9WwCqEklv+f1x3Ol837toe1VOetrFKnMQ5cnvtiKW4W
	 B5YB68ciWL7pT8ThDParMnXUkxQvHKAWxgySGOIx2OAnUgdaKspo9/r049IAAe7NQLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GXOoZkGt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AD7606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 23:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GXOoZkGt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C37E1F01825;
	Wed, 28 Oct 2026 23:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793229589;
	bh=hb0Zf2ErEuNgCNccRL3GdmSfQUfFbz64wRnm1NSyEIo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=GXOoZkGtLSMYDH6s4W1lROM9zn70gtJmjgkDIoHuZT/TI8D0Lb8BsPj8tQjTcOEuA
	 Dv1Z7zjiJX+tYlCe9tFV2EdSej9mxoBBhSqMimLQlz3KPtvZcG2oJBJANonu7RNy56
	 4yzUdjv9my/RxwJsKw17O07ZytY4+gzxLGtZ617KTQjdh3zbpxF0W39Z87n1J+CVwK
	 z6YW7kYJrG+TFQS/dkODnHHRFQ2AlzWG0neQYLS7ebsOY9PtUOiefKsIXrrnJ2d+6m
	 agWtm4YoFVwpUkz3UWF9JTAFsDTEl3GOhoRzH8/alLbH0tDSkKKyt72MzDpkss6b46
	 K36ymI1cnlntw==
Message-ID: <sashiko-outbox-188543@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] scsi: scsi_dh_alua: Start a port group in the
 scanned access state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261028230807.61578-4-brian@purestorage.com>
References: <20261028230807.61578-1-brian@purestorage.com>
 <20261028230807.61578-4-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 23:19:48 +0000
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
- [High] scsi: scsi_dh_alua: initial RTPG dropped in alua_bus_attach() leav=
es pg->state stale
--

commit 82a8c8c9b2d2916e1a4b1a2ea0671b7c6f85346c
Author: Brian Bunker <brian@purestorage.com>

scsi: scsi_dh_alua: Start a port group in the scanned access state

This commit initializes a newly allocated ALUA port group's state and
preferred bit from the scan-time access_state stored on the scsi_device
rather than always starting in SCSI_ACCESS_STATE_OPTIMAL.

> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index 06eb35cc9d7cb..15471e7bf19a5 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -208,7 +208,14 @@ static struct alua_port_group *alua_alloc_pg(struct =
scsi_device *sdev,
>  	}
>  	pg->group_id =3D group_id;
>  	pg->tpgs =3D tpgs;
> -	pg->state =3D SCSI_ACCESS_STATE_OPTIMAL;
> +	/*
> +	 * Start in the access state the SCSI core read when the device was
> +	 * scanned. That is active/optimized if it did not read one, as it
> +	 * was before. alua_prep_fn() then already fails I/O to a path that
> +	 * is unavailable before the first RTPG of the handler completes.
> +	 */
> +	pg->state =3D FIELD_GET(SCSI_ACCESS_STATE_MASK, sdev->access_state);
> +	pg->pref =3D FIELD_GET(SCSI_ACCESS_STATE_PREFERRED, sdev->access_state);

[Severity: High]
Does the initial RTPG of the handler actually get queued when attaching via
alua_bus_attach()?

In drivers/scsi/device_handler/scsi_dh_alua.c, alua_bus_attach() calls
alua_initialize() before assigning sdev->handler_data:

alua_bus_attach()
	err =3D alua_initialize(sdev, h);
	if (err !=3D SCSI_DH_OK && err !=3D SCSI_DH_DEV_OFFLINED)
		goto failed;

	sdev->handler_data =3D h;

During alua_initialize() -> alua_check_vpd(), after alua_alloc_pg() sets
pg->state from sdev->access_state, alua_check_vpd() calls
alua_rtpg_queue(pg, sdev, NULL, true). However, alua_rtpg_queue() checks
sdev->handler_data before scheduling pg->rtpg_work:

	if (pg->rtpg_sdev =3D=3D NULL) {
		struct alua_dh_data *h =3D sdev->handler_data;

		rcu_read_lock();
		if (h && rcu_dereference(h->pg) =3D=3D pg) {
			pg->interval =3D 0;
			pg->flags |=3D ALUA_PG_RUN_RTPG;
			kref_get(&pg->kref);
			pg->rtpg_sdev =3D sdev;
			start_queue =3D 1;
		}
		rcu_read_unlock();
	}

Because sdev->handler_data is still NULL at this point, h is NULL and the
initial RTPG work is silently dropped.

Previously, pg->state started as SCSI_ACCESS_STATE_OPTIMAL, so I/O was
allowed through alua_prep_fn() and any sense data could trigger
alua_check_sense() after sdev->handler_data was populated.

With pg->state now starting in the scan-time sdev->access_state (and with
scan-time RTPG having already consumed pending unit attentions):

1. If sdev->access_state was UNAVAILABLE or STANDBY at scan time and the
port group transitions to OPTIMAL before alua_bus_attach() runs (or when
the handler is attached later via scsi_dh_attach()), pg->state starts as
UNAVAILABLE or STANDBY. Because the initial RTPG is dropped and
alua_prep_fn() immediately rejects non-passthrough I/O with BLK_STS_IOERR
before it reaches the target, can the path remain stuck in the stale
state?

2. If sdev->access_state was SCSI_ACCESS_STATE_TRANSITIONING at scan time,
won't dropping the initial RTPG prevent alua_rtpg_work from polling the
port group or enforcing the transition timeout?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028230807.6157=
8-1-brian@purestorage.com?part=3D3
