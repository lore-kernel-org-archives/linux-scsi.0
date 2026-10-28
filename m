Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213957;
	b=NWa+pbpXXlc4mGNyfJ5L3M3SbNcyw4ezVIJqcqOVLvQRuPlTA8OXILQQd6yt21Rl0Yn8
	 B2XVIkrw4nOJnpIMaMu6q6PVF2FoM+bDrNk9GesHBYzDHFPAF+fgTBzh6HEvToxgELBl5
	 YDRHigq6TF5OFIi2en11huyIcNLaZ9XPTSMQ9vQXgC93DHnjG5dDinSfbQuFR49/GgYTp
	 cgxa2wB6oqmXapT/KeZIEv35I1DhmdprLW0N1gZIX1uwXdKfs5Gc6RVPKznyrXgfuHlvQ
	 BDXtYi83VSiH50qxsxdgNcalg2V8IxW8PPPbKEdquB7POsk3UUSjQawj8kHaem5H9jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213957;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cg+sVMqSUFw1aoY6M4ozeS3psb+p6eboE70MCPclKb0=;
	b=3BHpybEYZJnJp8m7+rqaZclfs1sAVTxUS5XN2q3KEmp3iEhUtIi0UzlgwmG17UReiRlQ
	 cEBU+40JFfJGBBn/VTal6Cq1GQVCzaW5eVG/u6VWWsoccQUhi53JahzDQ7SqgbqRZlSAJ
	 bmkFj4IW4L8kI4K8aWGDKrDKFZoQbiXeljtrLi3IqG/IZjUVabdJlwjpI7p6YSr7m8LtP
	 gT3R8kKxDwg0zxktjYQREJ+nQK/OXB6HXMtgkNIjXJn6s50zzkrGQ9QcBw+LgfrCIfhm5
	 qje5NxLAscWyNC1pFRPn30RYKDKKDuA4/GkOJ7QQz+rJxbx23T6iJwGSqO3e95oV1Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVfZhkKy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F80A606A31F
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVfZhkKy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF9C1F01828;
	Wed, 28 Oct 2026 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793213957;
	bh=cg+sVMqSUFw1aoY6M4ozeS3psb+p6eboE70MCPclKb0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FVfZhkKyzFtnMbSesn2vKQgeD7o9NpFw6KZR0TE4rxa6VBCzZ588jmMGZ4dJkzBhF
	 D+DjQR7MoP/VKYrzFNszDK3P+Cr7LMH6H0WIyS5tH97FoPSfTXzyhU/klgpoQfDsOU
	 h0RuJyvi8UrTOK19n4m58bdXmsF3yQqba+fCkvBgmcA6eMbq667bED2rbSGSyROuu7
	 /0RvYuEzTbaaiNVybxfGXHY3x4wmyplf5zU1CpG4YbhS8kkUPHnaiYHa9XGkKl8gob
	 RMucpN05tVSnhUM82VJY+Pcxh3NVw9PfqPl5LGNqVbsGc+4oVvmOpyStdTTwsl2sxb
	 1Ra4NPsRjKsmg==
Message-ID: <sashiko-outbox-188322@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] scsi: core: Match ULDs to logical units in the ALUA
 unavailable state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261028184216.25453-5-brian@purestorage.com>
References: <20261028184216.25453-1-brian@purestorage.com>
 <20261028184216.25453-5-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 18:59:16 +0000
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
- [High] scsi: scsi_bus_match() fails to match PQ 001b devices after ALUA t=
ransition
--

commit 8555f2a23fa08a25f1e358e107e5863a5e3dec5f
Author: Brian Bunker <brian@purestorage.com>

scsi: core: Match ULDs to logical units in the ALUA unavailable state

This commit updates scsi_bus_match() to also match SCSI devices that report
peripheral qualifier 001b (SCSI_INQ_PQ_NOT_CON) when their ALUA access state
is SCSI_ACCESS_STATE_UNAVAILABLE, allowing upper-level drivers like sd to b=
ind
to logical units scanned while in the ALUA unavailable state.

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index fe54792ed69e4..8d90f0c715ce2 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -539,7 +539,19 @@ static int scsi_bus_match(struct device *dev, const =
struct device_driver *gendrv
>  	sdp =3D to_scsi_device(dev);
>  	if (sdp->no_uld_attach)
>  		return 0;
> -	return (sdp->inq_periph_qual =3D=3D SCSI_INQ_PQ_CON)? 1: 0;
> +	if (sdp->inq_periph_qual =3D=3D SCSI_INQ_PQ_CON)
> +		return 1;
> +	/*
> +	 * Peripheral qualifier 001b is also what a LU reports while it is in
> +	 * the ALUA unavailable state on this target port (SPC-4 5.15.2.4.5).
> +	 * scsi_add_lun() reads that state with REPORT TARGET PORT GROUPS
> +	 * before the device is registered. A LUN that is not mapped reports
> +	 * 001b too, but fails REPORT TARGET PORT GROUPS and so is not
> +	 * matched.
> +	 */
> +	return sdp->inq_periph_qual =3D=3D SCSI_INQ_PQ_NOT_CON &&
> +	       (sdp->access_state & SCSI_ACCESS_STATE_MASK) =3D=3D
> +			SCSI_ACCESS_STATE_UNAVAILABLE;

[Severity: High]
What happens in scsi_bus_match() if a logical unit is scanned while in the
ALUA unavailable state (setting sdp->inq_periph_qual to SCSI_INQ_PQ_NOT_CON=
),
and its ALUA access state subsequently transitions out of
SCSI_ACCESS_STATE_UNAVAILABLE?

In drivers/scsi/scsi_scan.c, scsi_add_lun() sets sdev->inq_periph_qual once
from the initial INQUIRY buffer and never updates it:

drivers/scsi/scsi_scan.c:scsi_add_lun() {
	...
	sdev->inq_periph_qual =3D (inq_result[0] >> 5) & 7;
	...
}

Meanwhile, sdev->access_state is updated dynamically when the target port
group transitions (for example, to SCSI_ACCESS_STATE_OPTIMAL,
SCSI_ACCESS_STATE_ACTIVE, SCSI_ACCESS_STATE_STANDBY, or
SCSI_ACCESS_STATE_TRANSITIONING):

drivers/scsi/device_handler/scsi_dh_alua.c:alua_rtpg() {
	...
	rcu_read_lock();
	list_for_each_entry_rcu(h, &tmp_pg->dh_list, node) {
		if (!h->sdev)
			continue;
		h->sdev->access_state =3D desc[0];
	}
	rcu_read_unlock();
	...
}

Because scsi_bus_match() requires sdp->access_state to still equal
SCSI_ACCESS_STATE_UNAVAILABLE when sdp->inq_periph_qual is
SCSI_INQ_PQ_NOT_CON, won't driver matching fail whenever sdev->access_state
changes to an available state before or between scsi_bus_match() calls?

Specifically, this appears to break ULD binding in three situations:

1. In scsi_probe_and_add_lun() -> scsi_add_lun(), if the target port
transitions out of the unavailable state after scsi_probe_lun() issues INQU=
IRY
but before scsi_read_access_state() issues REPORT TARGET PORT GROUPS,
sdev->inq_periph_qual is recorded as SCSI_INQ_PQ_NOT_CON while
sdev->access_state is set to the new state (such as
SCSI_ACCESS_STATE_OPTIMAL). When device_add() runs, scsi_bus_match() returns
0.

2. In scsi_sysfs_add_sdev(), scsi_dh_add_device() attaches scsi_dh_alua and
queues pg->rtpg_work on kaluad_wq before device_add() runs:

drivers/scsi/scsi_sysfs.c:scsi_sysfs_add_sdev() {
	...
	scsi_dh_add_device(sdev);

	error =3D device_add(&sdev->sdev_gendev);
	...
}

Since sd_template sets PROBE_PREFER_ASYNCHRONOUS, __device_attach() also
defers probing to __device_attach_async_helper() -> driver_match_device() ->
scsi_bus_match(). If alua_rtpg() updates h->sdev->access_state before
device_add() or before __device_attach_async_helper() runs, scsi_bus_match()
sees the new access_state and returns 0.

3. If an upper-level driver module (such as sd_mod or sg) is loaded via udev
after the port has transitioned to an available state, or if a driver is
unbound and rebound via sysfs (bind_store() -> driver_match_device() ->
scsi_bus_match()), scsi_bus_match() sees sdp->inq_periph_qual =3D=3D
SCSI_INQ_PQ_NOT_CON and sdp->access_state !=3D SCSI_ACCESS_STATE_UNAVAILABL=
E and
refuses to bind to the now-available logical unit.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028184216.2545=
3-1-brian@purestorage.com?part=3D4
