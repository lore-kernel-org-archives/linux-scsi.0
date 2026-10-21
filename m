Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560936;
	b=SyCwIT0QmVkbNeXZ2JlqmICBPMXgcDCFNwCxuxxcMIvRAchlTYxM1pslgNUjrrKNIxWt
	 XVAvI4oelulmBov3rnSlFhqM4T1CPYML1oXPrfuzFS2mPu4I7xynMhb/LdKzV+i4l9gMJ
	 4dyKLxtJ6Gdp199D3iSfsiinruZ7BDDpU0t7QdJBSEgY8BJldmhypUkqMXR+REC1EhsPJ
	 8t5fR632aIdSgrgrbd0mohOcmu11zAhP+1BmCXNannJEURisA/KV+WTyOvbi/GnSsHdMA
	 lNbKwWsPQ+tD9Kv0N6rGWb39izYENayEpup32rWr1SPJq+Nvo2cbDhPYTLY99bxgAyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560936;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xygS5ZZoMMoPhPcNBZvuKpErMC9HsA8rDupLxl2AxWo=;
	b=m+eK9/KIwmX7eYpTtzcbqtuTF84n4W4Z+gHdydZR3vy/302aBoqxk7fpGhNNf5fqmng3
	 do3Ygcd+jrc6YR5/Z751PZK2Jr+QGw0+dEJBrTQVZYvjKTyxk3OtW2OqyQOkSvNAPeGVW
	 33NFD1LPHiud7ohQLVEX8YcylmEOeRYTdypBRY3T+nn2LUEGWlKMXOLi4o5wDd0m8gPpe
	 v8NR5tlnzXhFt3zWmmP22dL0PQilcU3lHZiIosDySNt4pFoJA/hlt8zZdw3fSryUbPecc
	 tQxFaqhdoGpRLIqYoUrUfLvHThDcTkAQmDaSRpeYxHq/DLOjOfLbs+bdlcJhVILDQeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mDBEi9tX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016AB606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 05:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mDBEi9tX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970C01F000C9;
	Wed, 21 Oct 2026 05:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792560935;
	bh=xygS5ZZoMMoPhPcNBZvuKpErMC9HsA8rDupLxl2AxWo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=mDBEi9tXFhPLD5dwZzR/8nZhyk9Fh23MubcvB9EvyAwO2a4BD7VQEOSHaVzPxCZFh
	 ncCMdtsQ3GpVfXj6wczRXt5D+oKElHn8WkzA4pO9TjyyBPAiBMQ9PVeq6tJ4L4MpVM
	 1bp5gxgBzFZvCa4zH4QAcL9TzCDnG+YzXgyekgl/nPUv6hkixUpRt1wGEestGdA/WG
	 MNlKNCAd4/xcam+bLWZpafrvh6qetJI+wEviXl18yz3evFwDNvQXKU0EtslhmBEsj3
	 2ONsi3Tr4RWT7uB9ugLu+DxHAMgz2i0W+l/3iGlm27y6oW9xM4ZwtAwSqTWx7lNDBl
	 BVdeCn4izppxw==
Message-ID: <sashiko-outbox-179808@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] scsi: ufs: Change the error check sequence for auto
 hibern8
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261021051951.1687479-1-hy50.seo@samsung.com>
References: <CGME20261021052403epcas2p43e1a022f46314c1a9d1ffb66502c29eb@epcas2p4.samsung.com>
 <20261021051951.1687479-1-hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 05:35:35 +0000
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
- [Medium] scsi: ufs: fallthrough after auto hibern8 error in ufshcd_uic_cm=
d_compl()
--

commit 5bb3d85e5945c6dc3a3a1bb37e02acd5c7703a06
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: Change the error check sequence for auto hibern8

This commit moves the ufshcd_is_auto_hibern8_error() check in
ufshcd_uic_cmd_compl() ahead of the active_uic_cmd check so that
auto-hibern8 errors are recorded even when no UIC command is active.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cc75384c65021..e15b08488187f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5928,6 +5928,9 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_=
hba *hba, u32 intr_status)
>  	struct uic_command *cmd;
> =20
>  	guard(spinlock_irqsave)(&hba->host->host_lock);
> +	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
> +		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
> +
>  	cmd =3D hba->active_uic_cmd;
>  	if (!cmd) {
>  		dev_err(hba->dev,
> @@ -5935,9 +5938,6 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_=
hba *hba, u32 intr_status)
>  		return retval;
>  	}
> =20
> -	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
> -		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
> -
>  	if (intr_status & UIC_COMMAND_COMPL) {
>  		/*
>  		 * Store the UIC command result in the lowest byte of

[Severity: Medium]
When ufshcd_is_auto_hibern8_error() returns true in ufshcd_uic_cmd_compl(),
execution still falls through after setting hba->errors:

drivers/ufs/core/ufshcd.c:ufshcd_uic_cmd_compl() {
	...
	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);

	cmd =3D hba->active_uic_cmd;
	if (!cmd) {
		dev_err(hba->dev,
			"No active UIC command. Maybe a timeout occurred?\n");
		return retval;
	}
	...
	if (intr_status & UFSHCD_UIC_PWR_MASK && hba->uic_async_done) {
		cmd->cmd_active =3D false;
		complete(hba->uic_async_done);
		retval =3D IRQ_HANDLED;
	}
	...
}

In the normal auto-hibern8 case where no UIC command is active
(hba->active_uic_cmd is NULL), won't falling through to the !cmd check
always log a misleading "No active UIC command. Maybe a timeout occurred?"
error and return IRQ_NONE?

Also, if an asynchronous UIC command such as UIC_CMD_DME_SET is active with
hba->uic_async_done set when an auto-hibern8 error interrupt arrives,
UFSHCD_UIC_PWR_MASK includes UFSHCD_UIC_HIBERN8_MASK. Could falling through
with UFSHCD_UIC_HIBERN8_MASK still set in intr_status prematurely complete
hba->uic_async_done?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021051951.1687=
479-1-hy50.seo@samsung.com?part=3D1
