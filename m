Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794219225;
	b=s72jFVgFfUzAzvpMQX2DOz+ZMQuPkvgtH9BF5mHlfRjJWoMc3HR7PGeoJo2l+G04ZcKx
	 mfDSeuv0IgsDvu6op1G0NVccwPNA1qmH6VnCuQE6andjMb/JDe5PQsf/J9utO5FC7rsC4
	 neqiwXbJqdmVILEKujIIz6bhe3vN1BsnSzn5n17OtnsqtsWlnKNnXY3JHx+sP17pn1hng
	 n7WIvjAbvazZtnLBo5YkyR5SFfhGiupyVSCqpr18zp8fYi2O0toTm1PhVqPU0olqUWTSG
	 k4r1PnD2HwAlZTxaeIoUChaQBSkffOBoLFmigtzG+Nrizt+k4wm5lnKlltDS+3nJhqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794219225;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iiZOq+/Rl/4q9BIQnzlXqBOkli9Hi9kHuOQkfh9dENw=;
	b=oYvOLAP7MG0IRghAJnQGHR+2t2Wutg0NsKVkFiIKjeraYpyYsaUxS1w/rvGII9iozvXl
	 G3rihB358/CWbQdfNan2pGuQwlbIuQebaZTKQGNazv35LPKR7Mk/R0R/jOs2m36UcUbQ6
	 LH33GmG+KvLVf2oefTekBdbZXR1/3JhbKwkgmb8U0J3KGnTMLZXiKN8LEeMWFSCz/hv/s
	 W8tLiHY3vBIjS82KLDA3EfKbrYQ3586QhxPpeRIAX4ICykbMC+QN9bY3Oiv3OTQ1uGHHn
	 7pEPM3Qd2s3wGGzYXC7KloQPLjqxV2xuQfWxbXnB6IvWREQBhlqIcznuKbx64MFu7vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFcmYS7f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB16B606A31C
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 10:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFcmYS7f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8021F008A1;
	Mon,  9 Nov 2026 10:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794219224;
	bh=iiZOq+/Rl/4q9BIQnzlXqBOkli9Hi9kHuOQkfh9dENw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=PFcmYS7fPqpbgPrB240+6BwBG1vJUQgGwLwhvmndrZky4UdXxC1ZiE5q5xO4gX+IO
	 MAe4FE9i1fzsjZ1ccMHmKExEH47MoKNacD8miu/oWlR+cgE/kTbEBxnywHn8ED1RpX
	 fyRr03Yxp3dGWnxwOB6NS6DnEiuRFCUycdwB4yb8eh6p17ijlnV23TvQOK1afIAYyZ
	 pHI0gvxfYNezwrPTMyuYvZvjZD0PqQ1S4HEw/h6SKY5xnmL/v6wQ2FYYhdmulItXun
	 13J1vjxk6md/c3nYAjobXe/t5BlSPVSLjsvxHtMA/Va7MCBUiD3bflSZ2YOQqom/t3
	 nYtUdbuhFslgA==
Message-ID: <sashiko-outbox-204793@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 11/12] scsi: sd_zbc: define storage element
 management operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261109095144.819709-12-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 10:13:43 +0000
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
- [Medium] scsi: sd_zbc: unbounded loop and missed error in
  sd_zbc_wait_for_se_removal()
- [Medium] scsi: sd_zbc: restore_allowed check masks error in
  sd_zbc_wait_for_se_restore()
- [Medium] scsi: sd_zbc: wrong loop bound on rep->elements in SE wait
  helpers
--

commit 9a8493bd583f59e5d376896ba0dad2854e23bbdd
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: define storage element management operations

This commit implements block storage element management operations
(report, remove, and restore) for zoned SCSI disks using physical element
status and depopulation commands.

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index bf2e60071d577..3bad1392f0e25 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
[ ... ]
> +static int sd_zbc_report_se(struct scsi_disk *sdkp,
> +			    struct sd_zbc_se_report *rep)
> +{
[ ... ]
> +	desc =3D &rep->buf[32];
> +	for (i =3D 0; i < min(rep->nr_elements, nr_descs); i++, desc +=3D 32)
> +		sd_zbc_parse_storage_element(sdkp, desc, &rep->elements[i]);
> +	rep->nr_reported_elements =3D i;
> +
> +	return 0;
> +}
[ ... ]
> +static int sd_zbc_wait_for_se_removal(struct scsi_disk *sdkp,
> +				      struct sd_zbc_se_report *rep,
> +				      unsigned int element_id)
> +{
> +	bool element_checked, element_removed;
> +	int ret, in_progress;
> +	unsigned int i;
> +
> +	/*
> +	 * Poll the storage elements health to see that we get the element we
> +	 * are interested in and that its removal completed. Since we do not
> +	 * know how long the operation may take, we cannot have a timeout on
> +	 * this loop. So check for fatal signals so that the user can terminate
> +	 * this loop if the device misbehaves.
> +	 */
> +	do {
> +		/* Let the operation proceed and check. */
> +		msleep(1000);
> +
> +		ret =3D sd_zbc_report_se(sdkp, rep);
> +		if (ret)
> +			return ret;
> +
> +		element_checked =3D false;
> +		element_removed =3D false;
> +		in_progress =3D 0;
> +		for (i =3D 0; i < rep->nr_elements; i++) {

[Severity: Medium]
Should this loop (and the matching loop in sd_zbc_wait_for_se_restore())
bound i by rep->nr_reported_elements instead of rep->nr_elements?

sd_zbc_report_se() only populates min(rep->nr_elements, nr_descs) entries
in rep->elements[] and stores that count in rep->nr_reported_elements.  If
the device returns fewer than rep->nr_elements descriptors, the remaining
entries in rep->elements[] are unpopulated on the first pass and retain
stale status values from earlier passes across the polling loop, which can
keep in_progress non-zero or trigger false error checks.

> +			if (rep->elements[i].id =3D=3D element_id)
> +				element_checked =3D true;
> +			switch (rep->elements[i].status) {
> +			case BLK_SE_STS_REMOVED:
> +				if (rep->elements[i].id =3D=3D element_id)
> +					element_removed =3D true;
> +				break;
> +			case BLK_SE_STS_REMOVE_IN_PROGRESS:
> +				in_progress++;
> +				break;
> +			case BLK_SE_STS_REMOVE_ERROR:
> +				if (rep->elements[i].id =3D=3D element_id)
> +					return -EIO;
> +				break;
> +			default:
> +				break;
> +			}
> +		}
> +
> +		if (!element_checked)
> +			return -EIO;
> +		if (element_removed && !in_progress)
> +			return 0;
> +	} while (!fatal_signal_pending(current));

[Severity: Medium]
Can sd_zbc_wait_for_se_removal() loop until a fatal signal if the removal
stops making progress without element_removed becoming true?

Unlike sd_zbc_wait_for_se_restore(), which returns as soon as !in_progress,
this loop keeps polling when in_progress is 0 and element_removed is false
(for example, if the operation aborts and leaves the element in its prior
health state, or if a paired fractional-access element fails removal while
the target element does not transition to removed or error).  While stuck
in this loop, the caller holds disk->zone_revalidate_mutex and blocks other
zone revalidation and storage element operations on the disk.

In addition, returning immediately from the removal-error case inside the
descriptor loop can return before a paired element finishes its in-progress
removal, and checking only rep->elements[i].id =3D=3D element_id misses a
removal error reported on a paired element.

[ ... ]

> +static int sd_zbc_wait_for_se_restore(struct scsi_disk *sdkp,
> +				      struct sd_zbc_se_report *rep)
> +{
[ ... ]
> +		in_progress =3D 0;
> +		for (i =3D 0; i < rep->nr_elements; i++) {
> +			switch (rep->elements[i].status) {
> +			case BLK_SE_STS_RESTORE_IN_PROGRESS:
> +				in_progress++;
> +				break;
> +			case BLK_SE_STS_REMOVED:
> +			case BLK_SE_STS_RESTORE_ERROR:
> +				if (rep->elements[i].restore_allowed)
> +					ret =3D -EIO;
> +				break;

[Severity: Medium]
Does gating the restore-error case on rep->elements[i].restore_allowed mask
restoration failures when the device clears the restoration-allowed bit on
the failed element?

While a still-removed element is only an error if it was eligible for
restoration (rep->elements[i].restore_allowed), a restore-error status
means restoration was attempted and failed; if the device clears
restore_allowed when entering that error state, sd_zbc_wait_for_se_restore()
returns 0 instead of -EIO.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109095144.8197=
09-1-dlemoal@kernel.org?part=3D11
