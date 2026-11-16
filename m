Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865963;
	b=dVhxVrrcFlaHafjPtllawWNwnGc3nG0fvLBR9g2x1I0f/frcM4GBAzlEQMBPFePzdA07
	 W9b9/aSOBMqe6RK6c4SzaieWGHWxcLd+cO1cJtSN0vFBWVLlL8wVLQRAAe9yyPawV9LB7
	 xH/QhqCOTjIsO864l0PJMYjUFes3nqQtBQTpoyGFnUrlTNuz/VLvmlMmkLFovqYDgw7pu
	 b+WENl9WHxrigUYR1kQZ0GC3j8FZ00BHEXDoufW+AWN+cDkj+pi2eJpRrbbkW5gcSd5nG
	 tZEfj3dFRvkBGf8AsOFz8K3VlGequZxepfcKZcyz2DmiP8t+jzKer6UWp1vUnEjUCWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865963;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d/FhX9WT1gQJXQssqocFu0hSb54mue+iJKzekPdgL+k=;
	b=RU7pjAesIbD7BkCaP5Wr2MTpw8qBuekxQrkru+d6lOaquVo4WNTGwpqVPpog1GtQ2adR
	 mrWT5vYDCsw5lK6h8VbkAAQDP2bZankqw38mi5d212FW+fx3wfUzB0ZyXY4um7fLyb4O/
	 CZBeDeDoaJKxmQxiZtVOhO73hSz18+UqzZJr2QbyKsaVtPnldnaNoytG/2ZPEt0ZBG39v
	 Ru720lzIlodGCJYFjCOsuNyXz7hS9q8wK75tDlWaGbSK1R+hGD3HCOhGNpRw23/y3okPV
	 QDuUeXEKrxFwJxHc/3plTBKPHSJMio1CS5fFHlYUHxcZSRnqDvleNy3ttl31q0csIEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iVnq6oQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375BE606A322
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iVnq6oQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE6A1F000C4;
	Mon, 16 Nov 2026 21:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865962;
	bh=d/FhX9WT1gQJXQssqocFu0hSb54mue+iJKzekPdgL+k=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=iVnq6oQc/2U3NBdqFDMwkMgqP6YXHNdAQRS2kKnhQ2sdCmWVaPMVKtkMbKrWjJXEc
	 yrgGXWob3x04XlQVuXioS3l1KCsQQO5DkuYjda4TlIdlGQ211ct8Oya/L73Iu/28sV
	 /iwEiFAhlHJovoF+/cHUjGwu4nqKIJxcycPihT5JfEs7JOcYwspaRpSjjuLmZNrho1
	 t69+3eUVU3sr4eNDUY2FWMSeonanfDWoKy80HAFbddZupTijgdAs8spufx7L8ssPoe
	 CeBD7QjqosPQxTkSW1F5tQLG0RwH3lDwhwJc9PDd6wN+CNhapjoyWefS/C1zPi5YJE
	 36pTkXPlFYm1Q==
Message-ID: <sashiko-outbox-217759@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 12/13] scsi: sd_zbc: define storage element
 management operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261116213702.225970-13-dlemoal@kernel.org>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 21:52:42 +0000
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
- [Low] scsi: sd_zbc: unused pre-restore report in
  sd_zbc_restore_storage_elements()
--

commit 243eb4ceb1c6dd8c1c98cb3da00f3669c1215225
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sd_zbc: define storage element management operations

This commit defines storage element management operations for ZBC SCSI
disks to support reporting, removing, and restoring storage elements.

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index bf2e60071d577..13cfcef19c38a 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c

[ ... ]

> @@ -560,6 +573,480 @@ static void sd_zbc_print_zones(struct scsi_disk *sd=
kp)
>  			  sdkp->zone_info.zone_blocks);
>  }
> =20

[ ... ]

> +static int sd_zbc_wait_for_se_restore(struct scsi_disk *sdkp,
> +				      struct sd_zbc_se_report *rep)
> +{
> +	unsigned int i, in_progress, in_error;
> +	int ret;
> +
> +	/*
> +	 * Poll the storage elements health to see if we have any element still
> +	 * being restored or if we got errors. Since restoration is a best
> +	 * effort process, we care only about failed restoration for elements
> +	 * that are allowed to be restored.
> +	 * Since we do not know how long the operation may take, we cannot have
> +	 * a timeout on this loop. So check for fatal signals so that the user
> +	 * can terminate this retry loop if the device misbehaves.
> +	 */
> +	do {
> +		msleep(1000);
> +
> +		ret =3D sd_zbc_report_se(sdkp, rep);
> +		if (ret)
> +			return ret;
> +		if (rep->nr_reported_elements !=3D rep->nr_elements)
> +			return -EIO;
> +
> +		in_progress =3D 0;
> +		in_error =3D 0;
> +		for (i =3D 0; i < rep->nr_reported_elements; i++) {
> +			switch (rep->elements[i].status) {
> +			case BLK_SE_STS_RESTORE_IN_PROGRESS:
> +				in_progress++;
> +				break;
> +			case BLK_SE_STS_RESTORE_ERROR:
> +				if (rep->elements[i].restore_allowed)
> +					in_error++;
> +				break;
> +			default:
> +				break;
> +			}
> +		}
> +
> +		if (!in_progress) {
> +			if (in_error)
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
> +	struct sd_zbc_se_report rep;
> +	int ret;
> +
> +	if (!sdkp->depop_restore_supported)
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Get the resources we need to prepare for waiting for the operation to
> +	 * complete.
> +	 */
> +	ret =3D sd_zbc_alloc_se_report(NULL, disk->nr_storage_elements,
> +				     true, &rep);
> +	if (ret)
> +		return ret;
> +
> +	/* To detect restoration errors, count the number of such elements. */
> +	ret =3D sd_zbc_report_se(sdkp, &rep);
> +	if (ret)
> +		goto free;
> +	if (rep.nr_reported_elements !=3D rep.nr_elements) {
> +		ret =3D -EIO;
> +		goto free;
> +	}
> +
> +	/*
> +	 * Execute the restore command and wait for the elements restoration
> +	 * operation to complete.
> +	 */
> +	ret =3D sd_zbc_execute_storage_element_cmd(sdkp,
> +					SAI_RESTORE_ELEMENTS_AND_REBUILD, 0);
> +	if (!ret)
> +		ret =3D sd_zbc_wait_for_se_restore(sdkp, &rep);

[Severity: Low]
Is the sd_zbc_report_se() call in sd_zbc_restore_storage_elements() missing
the element count described by the comment, or is it left over?  Nothing
inspects rep.elements before sd_zbc_wait_for_se_restore() overwrites rep on
its first iteration, so this issues a redundant GET PHYSICAL ELEMENT STATUS
command on every restore operation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116213702.2259=
70-1-dlemoal@kernel.org?part=3D12
