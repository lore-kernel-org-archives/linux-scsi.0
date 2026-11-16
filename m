Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794787455;
	b=qgSMIQHdueFSc6J/UsfD0XelzV5EipKM2xNjNmljFcn7cSlCTQR6AjJmCB/7RVZlyhjt
	 /oR8s+v/si/tF9JCbUVD6jx489PyZzomr+sjW7g1FyGU0RuqPu3uR7M2Dkobkllx7uPKO
	 3qGQilEB6PW9DzWAEZAqx/lm2WMbVgGIjthBi854AapAmxIQ0Ch7XeCueVGCCGi1yJ4eY
	 5qM0MntkU9Yz+IHZaEMNiyZ3ZFNnR1oemfDHdHnY4PJyZhVzCctZUWNNDXo8kCm/2yO1u
	 RTfK6zk5en1DaCcrhmeCB5kPGKDptXU/LysR9r00hmJDfDkgSu9BRIjuqnIsiIF1FSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794787455;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qC5/IFvay/3tPPAO8/DdmXwEJm9t4ZhL0/j2eI/FxUE=;
	b=Ha0+qYqVS22B/fwalZoKRncOUwiBgYVBUimKbvNAOmL/HQZwwc/yIFNBk71F8U+UEAwD
	 gxTs8nQpeW21jVW8ko5KQlJUc8ylG/p0NjN3DBptn+lgoIh3qVJwfXXzOXjoAOvXt+DEF
	 yHktg+GSv7ZKmieULBzY2cxBP8yG+n8r7ZsMxBqJID+gqVlu35KOZCpXKg75cCAYZWqWR
	 avisYsOuATot7bbGkROCT1nTbt9gamqKkMSNMw1Vb0gy5/Jt89i20luywnB6fk7t+L64n
	 zSsNsTLXybREIKBmCCdmGsINWeEYqdX2Bm98X1NiGdJu/ammXyN/cL50AFMQ5iBj9Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="I/YSprNz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAF5606A31F
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I/YSprNz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278941F000C6;
	Mon, 16 Nov 2026 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794787455;
	bh=qC5/IFvay/3tPPAO8/DdmXwEJm9t4ZhL0/j2eI/FxUE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=I/YSprNzt38Dy1kOomji3SjzuXxJ3LRYDvReYkTZhCPy9CtAiSfeDddj9+twtCPcp
	 Mxt4qWC461G2fOegDe5D/6cOC7+BNoYLl0OoTchTBnDvERSiRNz8oZQhZDEtS/wSey
	 tptgTUpiPxnRTxAEZmV6fRdt8+68jCyGseFy8LXnzTKPyfwbLTVVFVDQFl2IPEBXjW
	 wZ3x4+R544KBPwS9h8SSBXKin2SyVwOZ5ubj7JEGWEhDQMoKb6ZRli/zd+G1hzsHeY
	 0CKW61QLDzeqxk19wTH13VY/VPhzFse6AIEAKFfBtwLXkxSTm2YgG4CDZp4kdi1pWU
	 mXcMuU7MZ3Fag==
Message-ID: <sashiko-outbox-215939@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 12/13] scsi: sd_zbc: define storage element
 management operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261115233327.941586-13-dlemoal@kernel.org>
References: <20261115233327.941586-1-dlemoal@kernel.org>
 <20261115233327.941586-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:04:14 +0000
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
- [Medium] scsi: sd_zbc: missed restore error in
  sd_zbc_restore_storage_elements()
- [Low] scsi: sd_zbc: missing ULLONG_MAX check in
  sd_zbc_parse_storage_element()
--

commit 41edcf895fef1b022cae55f553c74d5d5da41fa8
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: define storage element management operations

This commit defines struct blk_se_ops callbacks in sd_zbc to report,
remove, and restore storage elements on SMR SCSI disks that support
depopulation.

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index bf2e60071d577..6322256028aa4 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c

[ ... ]

> @@ -560,6 +573,484 @@ static void sd_zbc_print_zones(struct scsi_disk *sd=
kp)
>  			  sdkp->zone_info.zone_blocks);
>  }
> =20
> +static void sd_zbc_parse_storage_element(struct scsi_disk *sdkp, u8 *des=
c,
> +					 struct blk_se *element)
> +{
> +	struct scsi_device *sdp =3D sdkp->device;
> +	sector_t zone_sectors =3D sd_zbc_zone_sectors(sdkp);
> +	u64 capacity;
> +
> +	memset(element, 0, sizeof(*element));
> +
> +	element->id =3D get_unaligned_be32(&desc[4]);
> +	element->restore_allowed =3D desc[13] & 0x01;
> +
> +	switch (desc[14]) {
> +	case SCSI_PHYS_ELEM_TYPE_ALL_ACCESS_STORAGE:
> +		element->type =3D BLK_SE_TYPE_RDWR;
> +		capacity =3D get_unaligned_be64(&desc[16]);
> +		if (!zone_sectors || capacity =3D=3D ULLONG_MAX)
> +			element->nr_zones =3D 0;
> +		else
> +			element->nr_zones =3D
> +				logical_to_sectors(sdp, capacity) >>
> +					ilog2(zone_sectors);
> +		break;
> +	case SCSI_PHYS_ELEM_TYPE_FRAC_ACCESS_STORAGE:
> +		element->paired_id =3D get_unaligned_be32(&desc[16]);
> +		if (desc[20] & 0x01)
> +			element->type =3D BLK_SE_TYPE_READ;
> +		else
> +			element->type =3D BLK_SE_TYPE_WRITE;
> +		element->nr_zones =3D get_unaligned_be64(&desc[24]);
> +		break;

[Severity: Low]
Should SCSI_PHYS_ELEM_TYPE_FRAC_ACCESS_STORAGE also normalize a reported
count of ULLONG_MAX to element->nr_zones =3D 0, matching the handling for
SCSI_PHYS_ELEM_TYPE_ALL_ACCESS_STORAGE above?  When a device sets the
number of associated zones field to 0xffffffffffffffff to indicate that
the count is not reported, callers of bdev_report_storage_elements() and
BLKREPORTSTORELEMS will otherwise receive ULLONG_MAX instead of 0.

[ ... ]

> +static int sd_zbc_wait_for_se_restore(struct scsi_disk *sdkp,
> +				      struct sd_zbc_se_report *rep,
> +				      unsigned int in_error_orig)
> +{
> +	unsigned int i, in_error, in_progress;
> +	int ret;

[ ... ]

> +		if (!in_progress) {
> +			if (in_error > in_error_orig)
> +				return -EIO;
> +			return 0;
> +		}
> +	} while (!fatal_signal_pending(current));
> +
> +	return -EINTR;
> +}
> +
> +static int sd_zbc_restore_storage_elements(struct gendisk *disk)
> +{
> +	struct scsi_disk *sdkp =3D scsi_disk(disk);
> +	unsigned int i, in_error_orig =3D 0;
> +	struct sd_zbc_se_report rep;
> +	int ret;

[ ... ]

> +	for (i =3D 0; i < rep.nr_reported_elements; i++) {
> +		if (rep.elements[i].status =3D=3D BLK_SE_STS_RESTORE_ERROR)
> +			in_error_orig++;
> +	}

[Severity: Medium]
Can sd_zbc_restore_storage_elements() return 0 when a retried element
fails restoration again?

When an element is in BLK_SE_STS_RESTORE_ERROR with restore_allowed set,
RESTORE ELEMENTS AND REBUILD attempts to restore it again.  Because that
element is counted in in_error_orig before the command is issued, if its
restoration fails again (or if it succeeds while another element fails),
in_error will not exceed in_error_orig in sd_zbc_wait_for_se_restore() and
the function will return 0 instead of -EIO.

Only elements in BLK_SE_STS_RESTORE_ERROR with !restore_allowed are
ignored by the restore command and should be counted in in_error_orig.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115233327.9415=
86-1-dlemoal@kernel.org?part=3D12
