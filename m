Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793932371;
	b=siNjEBbmoL9ZO9pFz0tdyPabV/VYAsui595zW9Ku6jx9+552dIUCJ2gpGHYqXgqgoYQz
	 gRnmcP8T7u1o5MSpiTw5GiosOuzMGO0CKKeAeKu4ZWGnRE1HuO767ULncjM6S4JRHewCA
	 OzSUapQL9QcAqIXvBmSKUX5+OsPd77JkxLjVLM6Lha8VDFt7CLg/2QcmdBbVa3Zh37d7g
	 xqLe247+w1weeKJG8m6nQ2FdikjKGNjJBRxwQHH9j54oFmgWRlp16XkJ0sVU6gey5W7+c
	 IY/XXk/jtOfB/j881w/+21xvRI52szIDROK/D2aFmDaRGe3zxZGkFxsSAFApc8mJS7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793932371;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=htoiJCiQuZSbek4CASj/9iHJ9xOKaZe0XsyxrTftGQQ=;
	b=o0DNBESOBePcQ0gwwgfiMav6g+MdjCFAcHxMCreeU0HYssUZOijNpl76RFMZIIsk6Xw8
	 wheqWBcotgCLdBGlQIi9mMRPRX1bFMZsbBrGVN1gnL2ZyUSH08wPf1TPYW1XgwuzRvDkn
	 qQnoywBd25wvlYm+lOVqIhDxgJPujN1/1eCS2n1aXmpBwb0Jq6zJi/TsFbUhvk8dl8OiO
	 cDtj62/hRJkGXx9fJUT0/0gXW9+/rso6d9UIO2kwU0KkxGsJOpOgNe+8y32vj99TVMmFR
	 k4riuybpi+Z3hVQaMNoqRMvu32Y1inuXluoPeX+FL8u35PY/PqXYKK7dgplX9/uoSQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lf+QRNu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C764606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 02:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lf+QRNu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2381F0089F;
	Fri,  6 Nov 2026 02:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793932371;
	bh=htoiJCiQuZSbek4CASj/9iHJ9xOKaZe0XsyxrTftGQQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=lf+QRNu7iNpEhWAShAtqalKnvAz60CAaWHF27KrHc5j/f9bFkYFrIB77VM4sPaHje
	 ZEqyxTV2YiavwM2TkuMCZgyDzD0bGF0sTZnjZTGLXn6LFI8LVWYfjghORZAM9sDsE5
	 4GXW0xQEoUM8AS5GGH6PNH+GB+1PuamchETomBM1GAi9vjmkscaSyIfe4X1N589sAY
	 YVnb9PwcF2TJ/q+gkxyHoc2PwpKDA27Vg4lnWDRdfAPsWO5eq7F2C8Be1zPyfnjzDl
	 kSBPGIH9hVWySD5CnEcJoavQAkHg/tvO3Amk6Ag/yX/uOLzYoqzuSTMw3KSiYyShIS
	 Pfz/AIh3veUfg==
Message-ID: <sashiko-outbox-200603@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 3/3] scsi: ufs: core: Set shutting_down in
 ufshcd_wl_poweroff()
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <66845a28b3014bb53b7f1332c258009b80707297.1793931113.git.hy50.seo@samsung.com>
References: <cover.1793931113.git.hy50.seo@samsung.com>
 <CGME20261106022021epcas2p20d78ac51e55f03348d496f45e96031e1@epcas2p2.samsung.com>
 <66845a28b3014bb53b7f1332c258009b80707297.1793931113.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 02:32:50 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ufs: core: ufshcd_wl_poweroff() breaks ufs_mtk_system_suspen=
d()
- [High] scsi: ufs: core: ufshcd_wl_poweroff() corrupts state on restore ro=
llback
--

commit 744164ab90d2e91d1a44bcd61cfe43ee02a7ac78
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: Set shutting_down in ufshcd_wl_poweroff()

This commit sets hba->shutting_down under hba->host_sem in
ufshcd_wl_poweroff() before calling __ufshcd_wl_suspend() so that the error
handler does not attempt link recovery during hibernation poweroff.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8571e91263e51..e59cdc224ef96 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11592,6 +11592,10 @@ static int ufshcd_wl_poweroff(struct device *dev)
>  	struct scsi_device *sdev =3D to_scsi_device(dev);
>  	struct ufs_hba *hba =3D shost_priv(sdev->host);
> =20
> +	down(&hba->host_sem);
> +	hba->shutting_down =3D true;

[Severity: High]
Will setting hba->shutting_down =3D true in ufshcd_wl_poweroff() cause
hibernation poweroff to fail on MediaTek controllers?

During hibernation poweroff via:

  hibernate() ->
    power_down() ->
      hibernation_platform_enter() ->
        dpm_suspend_start() ->
          dpm_suspend()

devices are suspended in child-before-parent order, so ufshcd_wl_poweroff()
on the child device wlun (&hba->ufs_device_wlun->sdev_gendev) runs before t=
he
parent controller's .poweroff callback on hba->dev.

In drivers/ufs/host/ufs-mediatek.c, ufs_mtk_pm_ops wires .poweroff to
ufs_mtk_system_suspend():

static const struct dev_pm_ops ufs_mtk_pm_ops =3D {
	SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend, ufs_mtk_system_resume)
...
};

And ufs_mtk_system_suspend() checks hba->shutting_down at entry:

static int ufs_mtk_system_suspend(struct device *dev)
{
	struct ufs_hba *hba =3D dev_get_drvdata(dev);
	struct arm_smccc_res res;
	int ret;

	if (hba->shutting_down) {
		ret =3D -EBUSY;
		goto out;
	}

When ufshcd_wl_poweroff() sets hba->shutting_down =3D true first, won't
ufs_mtk_system_suspend() immediately fail and abort hibernation?

> +	up(&hba->host_sem);

[Severity: High]
What happens if hibernation poweroff rolls back and invokes .restore?

In drivers/ufs/core/ufshcd.c, ufshcd_wl_pm_ops pairs .poweroff with .restor=
e:

static const struct dev_pm_ops ufshcd_wl_pm_ops =3D {
#ifdef CONFIG_PM_SLEEP
	.suspend =3D ufshcd_wl_suspend,
	.resume =3D ufshcd_wl_resume,
	.freeze =3D ufshcd_wl_suspend,
	.thaw =3D ufshcd_wl_resume,
	.poweroff =3D ufshcd_wl_poweroff,
	.restore =3D ufshcd_wl_resume,
#endif

If hibernation_platform_enter() aborts after ufshcd_wl_poweroff() has run
(for example due to a pending wakeup event or a later device failing its
poweroff callback), dpm_resume_end() calls ufshcd_wl_resume():

static int ufshcd_wl_resume(struct device *dev)
{
...
	if (!ret)
		hba->is_sys_suspended =3D false;
	up(&hba->host_sem);
	return ret;
}

Unlike ufshcd_wl_suspend(), which keeps hba->host_sem held until
ufshcd_wl_resume() releases it, ufshcd_wl_poweroff() releases hba->host_sem
immediately, and ufshcd_wl_resume() never clears hba->shutting_down.

After a hibernation rollback, doesn't this perform an unbalanced
up(&hba->host_sem) (incrementing the semaphore count to 2) and leave
hba->shutting_down permanently set to true on the running system, disabling
error recovery in ufshcd_err_handling_should_stop() and blocking user
accesses in ufshcd_is_user_access_allowed()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793931113.gi=
t.hy50.seo@samsung.com?part=3D3
