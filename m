Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745089;
	b=EaKZz+tTMj2oBW2VyHq00ciR1YX78MpmOBmo0cowkOzabywY8k2+qkeQ8GwOjJVCHAWV
	 STFS7iBpFWmNcwa532oO1pvWfUsXLU5t7uT0fsh+lccQjoRrh/qWyhH2pwRzxn+XB+Qmy
	 6x3toVatEMfVDLXso3OkWhVHJA4lce2EDldofoxNuqZeg6nUJ/V6/QvUeRyDDRAyHMJqB
	 ZwOuWzdf2VHtY31JKRX927YBbmjYDJwc/Cw/QSEVVbwuWOjT5/4tl0WcOhkMvfyxmCe7m
	 YwL5txoEGZp5fK9GlYRsamQQpt+DGen5MLTsxjv/ma5h6/F9wDWdwKoMXFuNcSCfGSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745089;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0+Nm1hJa6qwhUWSCw4mFGWu71hTTgC7RUNpFlONgOVI=;
	b=ypUlCj9l8pc6nbYMh0L54FCqwxBzQocXdkPRPJwydX3i8B/x8oM+VoI31Mm2mI7LmHYo
	 a+VPtxNIGBAdkXQw4J0hlTmRDjkPPZR5SpDIpbn/wzgIVjWz1PYI9sAarS0FtTlq13AEU
	 CfsnUEVnqnpjuVQkfU6+Kxs3FVgpevpqntCKPihMCr8xi+eVc6GgrO8ITuOdQFu3u+0L2
	 gMDWyfXfR/4WU31umU4HrkCuuVp4YxYRmxE9y0PYgmAcG2LQBo6IfrldIyk/s+93FWk3o
	 fjwYDm813chIhF/HLekIbyCzCHJCaRnVo5ivKYVgDkC5uz/yOahc3XbSrrSvuliaTLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="N7bYhdo/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5036606A31A
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7bYhdo/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A931F000C4;
	Sun, 15 Nov 2026 12:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794745088;
	bh=0+Nm1hJa6qwhUWSCw4mFGWu71hTTgC7RUNpFlONgOVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N7bYhdo/O3CWRn4AtUo5MVj3x8SEHQ5OHDjpXoqvGLQvEbHkDsE3z2Qo0NIIGe9UR
	 dqmUDcTB502BiPu/vjAqEEDZ8nFLoMRxfC7t1J+CtQPI9UL4VyfNnNbpNwSHQS+SOh
	 +dHpUQjGorPIgx4K9g0aRqlp9J5zhyDRWZstp+WnKCm5sM+u2y17WbIT1bIU4NtLUV
	 sdtdtycu+13t5T8JiWsAdRgYxdyKtTQY9HXzAEDSui/suapqBG9MJXcVsGfqf3+Iqa
	 n/XVu1bKNOI9aNoCkNNexj/sSUmNwnnx+jADSV7jk3zjkw7OX1554Ov2AZ8OL6TwhA
	 KRXGig0kabzyQ==
Message-ID: <sashiko-outbox-215487@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: lpfc: drain all CQ work before releasing queue
 dependencies
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongyan Xu" <getshell@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <179474327480.103840.7747335244166055751@seu.edu.cn>
References: <179474327480.103840.7747335244166055751@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 12:18:07 +0000
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
- [High] scsi: lpfc: UAF on cq->pring in lpfc_sli4_queue_unset() before
  CQ work drain
- [High] scsi: lpfc: incomplete IRQ and CQ work drain in
  lpfc_sli4_queue_destroy()
--

commit a82bf087615a1eaf204b24247167186d3c756921
Author: Hongyan Xu <getshell@seu.edu.cn>

scsi: lpfc: drain all CQ work before releasing queue dependencies

This commit disables delayed CQ work items and flushes the HBA workqueue
before freeing queues in lpfc_sli4_queue_destroy(), and moves interrupt
teardown ahead of queue destruction in lpfc_sli4_prep_dev_for_reset().

Link: https://lore.kernel.org/all/20260928134154.1595-1-getshell@seu.edu.cn/

> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 6df5f4e7c5d65..0724dd8dcc02f 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -10808,6 +10808,37 @@ lpfc_sli4_release_queues(struct lpfc_queue ***qs=
, int max)
>  	*qs =3D NULL;
>  }
> =20
> +static void lpfc_sli4_disable_cq_work(struct lpfc_queue *cq)
> +{
> +	if (!cq)
> +		return;
> +
> +	disable_delayed_work_sync(&cq->sched_irqwork);
> +	disable_delayed_work_sync(&cq->sched_spwork);
> +}
> +
> +static void lpfc_sli4_drain_cq_work(struct lpfc_hba *phba)
> +{
> +	struct lpfc_sli4_hba *sli4 =3D &phba->sli4_hba;
> +	unsigned int i;
> +
> +	if (sli4->hdwq)
> +		for (i =3D 0; i < phba->cfg_hdw_queue; i++)
> +			lpfc_sli4_disable_cq_work(sli4->hdwq[i].io_cq);
> +
> +	if (sli4->nvmet_cqset)
> +		for (i =3D 0; i < phba->cfg_nvmet_mrq; i++)
> +			lpfc_sli4_disable_cq_work(sli4->nvmet_cqset[i]);
> +
> +	lpfc_sli4_disable_cq_work(sli4->els_cq);
> +	lpfc_sli4_disable_cq_work(sli4->nvmels_cq);
> +	lpfc_sli4_disable_cq_work(sli4->mbx_cq);
> +
> +	/* Direct CQ work cannot rearm the disabled delayed work. */
> +	if (phba->wq)
> +		flush_workqueue(phba->wq);
> +}

[Severity: High]
Can a threaded IRQ handler still access or queue CQ work after
lpfc_sli4_drain_cq_work() returns?

For MSI-X, lpfc_sli4_hba_intr_handler_th() runs in a dedicated IRQ kthread
outside phba->wq, calls __lpfc_sli4_hba_process_cq() directly for fast-path
CQs, and queues cq->spwork onto phba->wq for slow-path CQs.  Callers such as
lpfc_sli4_hba_setup() (on failure after lpfc_sli4_arm_cqeq_intr()) and
lpfc_sli_brdrestart_s4() invoke lpfc_sli4_queue_destroy() without disabling=
 or
synchronizing interrupts first, and lpfc_sli4_disable_cq_work() does not ca=
ll
disable_work_sync() on cq->irqwork or cq->spwork:

CPU0                                  CPU1 (irq kthread)
lpfc_sli4_hba_setup()
  lpfc_sli4_arm_cqeq_intr(phba)
  ...
  lpfc_sli4_queue_destroy(phba)
    lpfc_sli4_drain_cq_work(phba)
      flush_workqueue(phba->wq)
                                      lpfc_sli4_hba_intr_handler_th()
                                        lpfc_sli4_process_eq()
                                          __lpfc_sli4_hba_process_cq(cq)
    lpfc_sli4_release_hdwq(phba)
      lpfc_sli4_queue_free(cq)
        kfree(cq)
                                            ...  <-- use-after-free

Synchronizing active interrupt handlers before draining and calling
disable_work_sync() on cq->irqwork and cq->spwork in
lpfc_sli4_disable_cq_work() would prevent this race.

> =20
>  static inline void
>  lpfc_sli4_release_hdwq(struct lpfc_hba *phba)
>  {
> @@ -10868,6 +10899,7 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
>  	spin_unlock_irq(&phba->hbalock);
> =20
>  	lpfc_sli4_cleanup_poll_list(phba);
> +	lpfc_sli4_drain_cq_work(phba);
> =20
>  	/* Release HBA eqs */
>  	if (phba->sli4_hba.hdwq)

[Severity: High]
Does draining CQ work only inside lpfc_sli4_queue_destroy() leave a
use-after-free window on cq->pring during lpfc_sli4_queue_unset()?

In lpfc_sli4_hba_unset(), lpfc_sli_brdrestart_s4(), and the
lpfc_sli4_hba_setup() error path, lpfc_sli4_queue_unset() runs before
lpfc_sli4_queue_destroy() while delayed CQ timers (cq->sched_irqwork and
cq->sched_spwork) can still be pending.  Inside lpfc_sli4_queue_unset(),
lpfc_wq_destroy() frees wq->pring, which cq->pring aliases:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_wq_destroy() {
    ...
	list_del_init(&wq->list);
	kfree(wq->pring);
	wq->pring =3D NULL;
    ...
}

CPU0                                  CPU1 (kworker)
lpfc_sli4_hba_unset()
  lpfc_sli4_queue_unset(phba)
    lpfc_wq_destroy(phba, wq)
      kfree(wq->pring)
                                      lpfc_sli4_dly_hba_process_cq()
                                        ...
                                          lpfc_sli4_fp_handle_fcp_wcqe()
                                            pring =3D cq->pring;
                                            spin_lock_irqsave(&pring->ring_=
lock)
                                              <-- use-after-free
  lpfc_sli4_queue_destroy(phba)
    lpfc_sli4_drain_cq_work(phba)

Draining CQ work before lpfc_sli4_queue_unset() tears down WQ state and rin=
gs
would close this window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179474327480.103840=
.7747335244166055751@seu.edu.cn?part=3D1
