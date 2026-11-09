Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794201484;
	b=ygiUJ2KjdP+jewKTkt5313hDdWEXu2lVpRH6gd0crELT2ZOnfnn+Egx6H9jXe+C3nqIA
	 vOA9tQ7gcxd8BtyWcNRVIVFrxU5Mm0rsbeRSaA9WarflqL2LqqODyfBSuUI6v4CIzldwf
	 9gl6kocbB1HiMCRarGi/1rMOpEp6UCcdD/sWcBeUTalFyUhOy+g5mf4w+hly5j0sJqcZx
	 GEhGQ4TE2QwC3JmUzlHRiULKL4sYEmdQk16I5BtHUqOqDwBpjxWDNTH2JGJKSIVReHKu6
	 aKysqVN/HdCvyre7ca8eKF0VkH9oXWjcl9EZLCQirMiNJXxcrHS3Q6bYl936u11worA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794201484;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fmbJWbR9m2JVChwONL6mJAeLQ3qC+17EalfJS207f+8=;
	b=Ka5n6Vet5+bEro01MOoErF94qbZiS2A+0BPNc2F/3bUS4pL+XmdOl/TV4956ea4RyXUl
	 tsBpyPVBzMaaUngG8IIdoFCKvKuHqHnk5H6rpCZ8a1/vo1EBiXY0VOrT+F6s8ROzcz00k
	 0q1p/0ePPgng3Jxr6WQ1mLbqumUcgj6U9muL33iY/gIwc6yfrMh2h1o08TFb8nlMeEatT
	 hLCv2lbyrU1yuMGml8j6lg2Ds4A6uGBhrA0nwe4T5KZab18LdzJE36aB7TD/uch2WTYPG
	 3PABwNlhy+Kn//W5ZYTJLpuDTVzbiLluCU66yvqCCI2Sg/dS1brbUk7nVqRzGFJ5EwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CXyMQoAy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB080606A31C
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 05:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CXyMQoAy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C5D1F0089F;
	Mon,  9 Nov 2026 05:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794201483;
	bh=fmbJWbR9m2JVChwONL6mJAeLQ3qC+17EalfJS207f+8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=CXyMQoAyljKJ8oBkrH9CfSAiPSqXsjMZ0U+WF6j/H6FePIZ4URoM3lEjC25DoK6Pu
	 3J9iyvUlHgWk7+zio9i08GFfst1xWwN3JRpxk+JXBi/vhCEKZH8UyqnF42qoRVFAHL
	 BOXkH1ISaFMsoiUZdLCfRSGTlVh7glMYBYJg6SOOYOFgw91mvN1OU+kJ+yHLjyhylp
	 Hbsu/hS3p41+LvhSBYIqWWceurEYKYDAodt8iKldPK4Ne9CD9Epv4EbiPwKzxjaU+7
	 H+2KYt/44qUj1WgAp3CeyVS42tE6h3gbOpx2hCwJJ34XKGneD9tZ6uky053r2vcr7w
	 wGakJH8Iw/xag==
Message-ID: <sashiko-outbox-204426@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/3] scsi: ufs: core: Hold host_sem in
 ufshcd_wl_poweroff()
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <973576304.21794200282836.JavaMail.epsvc@epcpadp2new>
References: <cover.1794196863.git.hy50.seo@samsung.com>
 <CGME20261109041347epcas2p17b5c0fd7b693f92eb2af35b12a24de31@epcas2p1.samsung.com>
 <973576304.21794200282836.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 05:18:00 +0000
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
- [High] scsi: ufs: core: unhandled __ufshcd_wl_suspend() error in
  ufshcd_wl_poweroff()
--

commit 3da1cf6f30fec549f078cc8184c250d266766b37
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: Hold host_sem in ufshcd_wl_poweroff()

This commit acquires hba->host_sem in ufshcd_wl_poweroff() so that
hibernation poweroff serializes with the error handler and balances the
up(&hba->host_sem) in ufshcd_wl_resume() if hibernation is aborted.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5a3ca3b4e6666..c2c34b044c3ec 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11583,6 +11583,8 @@ static int ufshcd_wl_poweroff(struct device *dev)
>  	struct scsi_device *sdev =3D to_scsi_device(dev);
>  	struct ufs_hba *hba =3D shost_priv(sdev->host);
> =20
> +	/* Released by ufshcd_wl_resume() if hibernation is aborted. */
> +	down(&hba->host_sem);
>  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>  	return 0;
>  }

[Severity: High]
Does ignoring the return value of __ufshcd_wl_suspend() here leave
hba->host_sem held when __ufshcd_wl_suspend() fails?

drivers/ufs/core/ufshcd.c:ufshcd_wl_suspend() {
	...
	ret =3D __ufshcd_wl_suspend(hba, UFS_SYSTEM_PM);
	if (ret) {
		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
		up(&hba->host_sem);
	}

out:
	if (!ret)
		hba->is_sys_suspended =3D true;
	return ret;
}

If __ufshcd_wl_suspend() fails (for example, when the device or link is not
active and it schedules hba->eh_work via ufshcd_force_error_recovery()),
ufshcd_err_handler() will block forever on down(&hba->host_sem).  Because
__ufshcd_wl_suspend() already calls ufshcd_release(hba) on error while
ufshcd_wl_poweroff() still returns 0, aborting hibernation later also causes
ufshcd_wl_resume() -> __ufshcd_wl_resume() to call ufshcd_release(hba) a
second time and underflow hba->clk_gating.active_reqs.

In addition, ufshcd_wl_poweroff() does not set hba->is_sys_suspended =3D tr=
ue
on success, so if .restore (ufshcd_wl_resume()) fails,
ufshcd_err_handling_prepare() will skip re-enabling regulators, clocks, and
IRQs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/728258269.417942002=
83102.JavaMail.epsvc@epcpadp2new?part=3D2
