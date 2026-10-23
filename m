Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747453;
	b=lY673ezcEq2mHGv+NBAFu/kPcjjNBKhJELutFf32jZ+C1F4mmbJDeTFTlD7SHIh7nw4x
	 AzEemvsZ198z9OK/GngJFFqktHk6jzaHKQFSVctmrODBcKDZl/POmV2McC4WiyWDn1fFh
	 PlLF+0HoYKWOabO9l+3J/CHKStDS/zAZRdhlzOtvQiNpn2oIwOjlQTV++OUK1CECnykWV
	 sWFUhbpoOcCFvgSMkLMxEx8CPdWi6VCBThff2D67iCeitySF9BhIope3jPwbMtgxwmIHc
	 zzv4C1ob0+sqUDOlwXg0O/JU629ecg/Jda726wJB2xeNOkLJ4zSWTPBzajilMEs7rgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747453;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4qTd0rBtldZzv0ASQviAtVErq/j700PUmBqt20W3lhg=;
	b=0CIfQ5sPsczs0C5YDuSeZRUsxuP13U0D7kaISMjmEVfo5lO5oZy15gU3nRe4yLF4lNKv
	 cmhii0tIeMULOD0yp6IeL1P7ExwNo7YUux+soTro/7KULmVXHRfj6abrPlYN3ihl/8xXK
	 wrR7sRWrUlo9Y2dU4uAPtymeAbVUXgZr+xpXjyuW8PwBeK5l9rmJtaIwrW78tY6k+mnSG
	 6odre0DpkO4ulzv8hhiEpdFxAqfPCZ0x750fQeq6ubbTeYyYKQ3+Mj4TVIJ0ayAv7zUv6
	 fS4iF6gas5l9sja1tRWp/IKmUh9ui8YBPOorFVkfkMFpXkE1AjlYHs1f+bZcHDJUJpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPtrRFbD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F2D606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 09:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPtrRFbD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBC81F01825;
	Fri, 23 Oct 2026 09:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792747453;
	bh=4qTd0rBtldZzv0ASQviAtVErq/j700PUmBqt20W3lhg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=PPtrRFbDIsRe5j9gwmkY6X7VxlDcrbruH+QDDxPVIiH6rmcPqe0Ae1/xYseoZervC
	 Uu4iZu7pqyj6jXAn1JxuKIKu0D0iSN8D5YFmcyOObqG6Y8i0lx/1wp5ZK+KNoLuK7i
	 //qfMMJH5e0dVJRh4ioel4bpvtbXCtLkyxCM47GoLA2E0t5Rp0zStMM3nlGxZ6gvtK
	 DaEDYLqlUt8gPCPDBhGMnMgSHQrdYCs9WBJOQ6RibaZmJzDt7JQjaTJWgamOnHneHl
	 Lxzik7sZIncsewckhkryhzhyrWKXhbnmRLDXUg1SOcWk2E+PSwEdAzc6oza3XVSoJ6
	 dzQAepEsMdhOw==
Message-ID: <sashiko-outbox-182586@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] scsi: ufs: core: add is_sys_suspended state before
 recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1582071873.61792745883325.JavaMail.epsvc@epcpadp2new>
References: <CGME20261023085501epcas2p3cc1319f4442d8fc77fdd64064bede2ed@epcas2p3.samsung.com>
 <1582071873.61792745883325.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 09:24:12 +0000
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
- [Medium] scsi: ufs: ufshcd_err_handler() still runs recovery after ufshcd=
_wl_resume()
--

commit cfd94f0f9cc528872dada8ade87c19c3c23304de
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: add is_sys_suspended state before recovery

This commit checks !hba->is_sys_suspended before calling
ufshcd_link_recovery() in ufshcd_err_handler() to avoid redundant link
recovery when a linereset and hibern8_exit failure occur during
ufshcd_wl_resume().

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cc75384c65021..988cb127ef0e8 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7041,7 +7041,7 @@ static void ufshcd_err_handler(struct work_struct *=
work)
>  		 * is already in progress.
>  		 */
>  		ufshcd_rpm_get_noresume(hba);
> -		if (hba->pm_op_in_progress) {
> +		if (hba->pm_op_in_progress && !hba->is_sys_suspended) {

[Severity: Medium]
Does skipping the early return here actually prevent ufshcd_err_handler()
from running recovery after ufshcd_wl_resume() finishes?

When a linereset or UIC error and hibern8_exit failure occur during
ufshcd_wl_resume() -> __ufshcd_wl_resume(), the interrupt handler latches t=
he
error bits into hba->saved_err and hba->saved_uic_err and schedules
hba->eh_work.

In drivers/ufs/core/ufshcd.c, __ufshcd_wl_resume() then calls
ufshcd_link_recovery():

	if (ufshcd_is_link_hibern8(hba)) {
		ret =3D ufshcd_uic_hibern8_exit(hba);
		if (!ret) {
			ufshcd_set_link_active(hba);
		} else {
			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
					__func__, ret);
			ret =3D ufshcd_link_recovery(hba);
			if (ret)
				goto vendor_suspend;
		}
	}

Unlike ufshcd_reset_and_restore(), neither ufshcd_link_recovery() nor
ufshcd_host_reset_and_restore() clears hba->saved_err, hba->saved_uic_err, =
or
hba->force_reset.

With this change, ufshcd_err_handler() sees hba->is_sys_suspended is true,
skips the early return block, and waits on down(&hba->host_sem):

		ufshcd_rpm_get_noresume(hba);
		if (hba->pm_op_in_progress && !hba->is_sys_suspended) {
			ufshcd_link_recovery(hba);
			ufshcd_rpm_put(hba);
			return;
		}
		ufshcd_rpm_put(hba);
	}

	down(&hba->host_sem);
	spin_lock_irqsave(&hba->host->host_lock, flags);
	if (ufshcd_err_handling_should_stop(hba)) {

Once ufshcd_wl_resume() releases hba->host_sem, ufshcd_err_handler() wakes =
up
and checks ufshcd_err_handling_should_stop():

static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
{
	return (!hba->is_powered || hba->shutting_down ||
		!hba->ufs_device_wlun ||
		hba->ufshcd_state =3D=3D UFSHCD_STATE_ERROR ||
		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
		   ufshcd_is_link_broken(hba))));
}

Because hba->saved_err and hba->saved_uic_err are still non-zero after
ufshcd_link_recovery(), ufshcd_err_handling_should_stop() returns false.

Wouldn't ufshcd_err_handler() then proceed into ufshcd_err_handling_prepare=
()
to quiesce all SCSI queues and run redundant error recovery (such as
ufshcd_reset_and_restore() when UFSHCD_UIC_HIBERN8_MASK or a fatal/DL UIC
error was latched, or ufshcd_abort_all()) on the link that __ufshcd_wl_resu=
me()
already recovered?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1582071873.61792745=
883325.JavaMail.epsvc@epcpadp2new?part=3D1
