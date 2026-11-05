Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866497;
	b=FxABSYYX3FODxHjsZaQV5H8dfNptbPgqsGWlbF3ylcQXKTEDcEuWn2Rxc+WnssXc44iH
	 5/E1LKyNmE09xY5PTDFIOKNHd4DCcKNCJ9lIN9A6j2PTD8X/z7nlAMGDBCLtiA37YwzmA
	 GQUetykvv7iomvy/r5bq4pRRi8gDX2rkNWs9PNQ+utgVUF2eEXV3UAhXdB6UnukwTlNYo
	 G9/SFtm+WNninuFcicC6PLTzZZarIDaNyp1EZ+Ma0TvG61UDr0HgeFlr6X1k1gPUPj8s1
	 KcfeKZLaT+zt8LXq6MsDOtWNmQ0KMPEnrXM3k6D+kfx1TQOLKy+kkUeeRwv+FVuKRRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866497;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JcAczxu2azSf6vSehFHEoLS0jfURhcRXBp3y1FZA7RU=;
	b=XMEBuwg1rBi1/gWj5o24mlDEalsTEWRTc4+vZlV/TSo0snw9lSViAQRnz0thhjX0gwdi
	 gwB8zzP1sPDaegGctshWHBNQhwan9MjKtqv/K0KVVde9GRcqaqelIAuNIKWLgY0AF98nb
	 WnatRRlotxnLZ6vc0PJl8SmxbRFuQRjDsva+lihHhAd2mKZfpD33nMGMVSZjWFo6quDqW
	 PP3AfGHbuO2BZzinOoVT406o9+Uq8+qHBf20K0hUp6Nd3beMOyFjxLli4Jm8sCyZ/nGp7
	 5oFpUl1Pad2wC5z2CWY5Lje9aIPInLs6eyciHANDm8HtgB0KcA44wMJlSBgorvohuvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvOG+hVi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA99606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 08:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvOG+hVi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7B21F000C1;
	Thu,  5 Nov 2026 08:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793866497;
	bh=JcAczxu2azSf6vSehFHEoLS0jfURhcRXBp3y1FZA7RU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=jvOG+hViefBetfUE59JCXi1+WKA+oneLA5PIOZ27bP0yop1Rv8/aRB11cij6m8JKR
	 vlDk2EjooYtMhwkiVa8r9+m5UCmXSvI8hBLdGYTE7trE3X9T/DqH0MbK5pZAJ1AlFT
	 IFhBMNkwJ8NFJYywkl4E9Mx67fnpL77VW/mztpRUOqzwGOVP4f52ldqLQn4d8MgMu7
	 arvOBqYmKSF3q5y7fYjQai70omTrRphPJmr0BwDFl7mbqnd52Zdes0+Wxj9FvD1PgV
	 orHBKDiCSCq1JDsu6XShUORNeK9aCKeu4RP6692caT0MPKX4mEROFtWzgZAu+dOYKo
	 4geFf+Blsp3Rg==
Message-ID: <sashiko-outbox-198714@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] scsi: ufs: core: Do not recover the link early
 in the error handler during system PM
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <acafa54491e27cab79150be04bd7dc91b6b352ad.1793865172.git.hy50.seo@samsung.com>
References: <cover.1793865172.git.hy50.seo@samsung.com>
 <CGME20261105080101epcas2p4c40f0278beb94d27c7de0621f54f91fd@epcas2p4.samsung.com>
 <acafa54491e27cab79150be04bd7dc91b6b352ad.1793865172.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 08:14:56 +0000
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
- [Medium] scsi: ufs: core: race on system_pm_in_progress in ufshcd_err_han=
dler()
--

commit 991f616e0ee805a5ba3aa9d0edc90a319abd06b6
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: Do not recover the link early in the error handler during =
system PM

This commit adds hba->system_pm_in_progress so that ufshcd_err_handler()
skips its early unlocked ufshcd_link_recovery() path during system suspend
and system resume, waiting on hba->host_sem instead.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3b5580ac390cb..761ffc8f0a32a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7091,9 +7091,13 @@ static void ufshcd_err_handler(struct work_struct =
*work)
>  		 * runtime resume. This avoids potential deadlocks that could
>  		 * happen if we tried to resume the device while a PM operation
>  		 * is already in progress.
> +		 *
> +		 * Do not do this for system PM. The system PM callbacks hold
> +		 * host_sem, so the regular path below runs after them instead
> +		 * of resetting the link concurrently.
>  		 */
>  		ufshcd_rpm_get_noresume(hba);
> -		if (hba->pm_op_in_progress) {
> +		if (hba->pm_op_in_progress && !hba->system_pm_in_progress) {
>  			ufshcd_link_recovery(hba);
>  			ufshcd_rpm_put(hba);
>  			return;
> @@ -10393,6 +10397,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hb=
a, enum ufs_pm_op pm_op)
>  	enum uic_link_state req_link_state;
> =20
>  	hba->pm_op_in_progress =3D true;
> +	hba->system_pm_in_progress =3D (pm_op =3D=3D UFS_SYSTEM_PM);
>  	if (pm_op !=3D UFS_SHUTDOWN_PM) {
>  		pm_lvl =3D pm_op =3D=3D UFS_RUNTIME_PM ?
>  			 hba->rpm_lvl : hba->spm_lvl;
> @@ -10565,6 +10570,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hb=
a, enum ufs_pm_op pm_op)
>  		hba->clk_gating.is_suspended =3D false;
>  		ufshcd_release(hba);
>  	}
> +	hba->system_pm_in_progress =3D false;
>  	hba->pm_op_in_progress =3D false;
>  	return ret;
>  }
> @@ -10576,6 +10582,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba=
, enum ufs_pm_op pm_op)
>  	enum uic_link_state old_link_state =3D hba->uic_link_state;
> =20
>  	hba->pm_op_in_progress =3D true;
> +	hba->system_pm_in_progress =3D (pm_op =3D=3D UFS_SYSTEM_PM);
> =20
>  	/*
>  	 * Call vendor specific resume callback. As these callbacks may access
> @@ -10666,6 +10673,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba=
, enum ufs_pm_op pm_op)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
>  	hba->clk_gating.is_suspended =3D false;
>  	ufshcd_release(hba);
> +	hba->system_pm_in_progress =3D false;
>  	hba->pm_op_in_progress =3D false;
>  	return ret;
>  }

[Severity: Medium]
Can ufshcd_err_handler() still observe hba->pm_op_in_progress =3D=3D true a=
nd
hba->system_pm_in_progress =3D=3D false during system suspend or system res=
ume?

ufshcd_err_handler() reads both flags without holding hba->host_sem or any
other lock shared with __ufshcd_wl_suspend() and __ufshcd_wl_resume().

At the entry of __ufshcd_wl_suspend() and __ufshcd_wl_resume(),
hba->pm_op_in_progress =3D true is written before hba->system_pm_in_progres=
s is
set, and at exit hba->system_pm_in_progress =3D false is cleared before
hba->pm_op_in_progress =3D false, without barriers or READ_ONCE()/WRITE_ONC=
E().

In particular, when __ufshcd_wl_suspend() encounters an error during
UFS_SYSTEM_PM, it calls ufshcd_force_error_recovery() (which immediately
queues hba->eh_work) and jumps to out:

drivers/ufs/core/ufshcd.c:__ufshcd_wl_suspend() {
	...
	if (ret && pm_op !=3D UFS_SHUTDOWN_PM) {
		ufshcd_force_error_recovery(hba);
		ret =3D -EBUSY;
	}
	...
out:
	...
	if (ret) {
		ufshcd_update_evt_hist(hba, UFS_EVT_WL_SUSP_ERR, (u32)ret);
		hba->clk_gating.is_suspended =3D false;
		ufshcd_release(hba);
	}
	hba->system_pm_in_progress =3D false;
	hba->pm_op_in_progress =3D false;
	return ret;
}

If ufshcd_err_handler() evaluates the condition in the entry or exit window
(or due to compiler/CPU reordering), it will enter the early
ufshcd_link_recovery() path without hba->host_sem or a clock-gating hold and
return early without running the regular error handling path (such as
ufshcd_err_handling_prepare() and ufshcd_recover_pm_error()).

Would ordering the updates (or encoding the active PM operation in a single
variable accessed with READ_ONCE()/WRITE_ONCE()) avoid this race window?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793865172.gi=
t.hy50.seo@samsung.com?part=3D2
