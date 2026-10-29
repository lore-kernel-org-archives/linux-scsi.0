Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793272340;
	b=TGvjABXPEyOvU/8zV0QhozsZQfzfhPi9Q7aIub46baYsXzA1lgzL4QYHSPTpbwYXWiHg
	 RyHMp90xaujEltHDxiM/rE3+Nf5UFZFAbRFRai6IqVY0fIoqMWu4yqRKGUPqz78KG5av1
	 XU6VrLYIKR7O+iVyqArYs2EX6yh/CxaPpo8G1+0VCQxuYjnHUB8qsEU5d1wTLWQpkvyWr
	 JZ+jCVlZx3aJkQ/MzevgT6JffUgwXbhDiVwl/KRSF+a5gtKdysZUFNrpkaMMisihAclqJ
	 PG9qVbUzUm3mHGfrRjBtqItSTct3Xxg8ONAPQigdwG5hHJ4eK/GDFrqbvRV1oyLFkRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793272340;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w/sjecDxQN2Q/G5rdX0BgBoYAl5m9a8mDy9gKf7A+KA=;
	b=aAJMn9R92nDgk9ptqSD4FEbaEW+iJgcFmBCgKVHQ0k6w66VNJvG4/gHqbDnOE7sFuHAx
	 E4iNFfPcqSaxd/RF5FZB5UpcUwXl7pH8XzuUcprAWPJ/VoThy8kPYcgF2DmoEvpIrhRKZ
	 RR6/rrx+kx9v/icXRG0iiGfGf4lIehzNB54XhE1fjPs/Q6g9Xkmrk6Vufj216UDZORlVS
	 VXYrRSAMpl9uTWoQIEdOirV6e+fDsf1lQNAETCxEqkEytNX+Pnem1JlVG2SbiLRUSbVFA
	 87+g1ObIDFjhJbTY8xqef0E7tbctwQQovMtP9p5GOQqZyKdulvXkc5fp0TaQXrEdVJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X7ErNlq8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D61606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 11:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X7ErNlq8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A360B1F01828;
	Thu, 29 Oct 2026 11:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793272339;
	bh=w/sjecDxQN2Q/G5rdX0BgBoYAl5m9a8mDy9gKf7A+KA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X7ErNlq8LncTI+/mycEc/Gdq3l/CGgnWUZOdPyUOTxjw2YlgTA69geD1L3ofK/HQD
	 qnw2Ug4QavTQjl7A+1CnQqR6EO7qmv07GSWRqe4JFgM+7GtJQ2OyNw8fEIz0jsB7hx
	 mkZ6dan6T/g4/9O5LPIj8adLANlqKw9psPaK6nbxoWJ6dTlE5qTD5lFsyDQ54rETeO
	 KjlK+ps9DHGVVFGZlETBdrVoXF32WEQ6aSvwbZ09dSa1pLMQnmT7XNy95EnWfx+aKh
	 ZVy//O5xFPJSwUL2bI+i4JzTV+EP4JVCWJT5g0g9FaPqAJjfVzHnEj5VdhQzO83NZE
	 yDlQbhJj+xCTA==
Message-ID: <sashiko-outbox-189185@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: core: Clear power-on UNIT ATTENTION on BIWIN
 UFS devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexey Charkov" <alchark@flipper.net>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261029-biwin-tua-quirk-v2-1-4d71af956ac5@flipper.net>
References: <20261029-biwin-tua-quirk-v2-1-4d71af956ac5@flipper.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 11:12:19 +0000
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
- [High] scsi: core: tag starvation in scsi_clear_reset_ua() when writes sa=
turate queue
- [High] scsi: core: missing quiesce and negative RPM check in scsi_clear_r=
eset_ua()
--

commit a245ee3df8cf93fd94b7ad3e84680f44164fbb37
Author: Alexey Charkov <alchark@flipper.net>

scsi: core: Clear power-on UNIT ATTENTION on BIWIN UFS devices

This commit adds the BLIST_TUR_AFTER_RESET quirk flag for BIWIN BWU2A05 UFS
devices and issues a TEST UNIT READY command from scsi_evt_thread() when
SDEV_EVT_POWER_ON_RESET_OCCURRED is pending and the device is runtime activ=
e.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ab39514cc0c6b..863ae93f2618b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -2713,6 +2714,32 @@ static void scsi_evt_emit(struct scsi_device *sdev=
, struct scsi_event *evt)
>  	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
>  }
> =20
> +/*
> + * Some devices do not clear a power on or reset UNIT ATTENTION when rep=
orting
> + * it to commands such as WRITE, which then keep failing on every retry.=
 Send
> + * them a TEST UNIT READY, which does clear it.
> + *
> + * Leave a device that is not runtime active alone. Until it is, only PM
> + * requests can reach it, and their senders deal with the UNIT ATTENTION=
. Any
> + * other command that keeps failing with it holds a queue reference, whi=
ch
> + * aborts a runtime suspend, and re-arms this event on every retry.
> + */
> +static void scsi_clear_reset_ua(struct scsi_device *sdev)
> +{
> +	struct device *dev =3D &sdev->sdev_gendev;
> +	struct scsi_sense_hdr sshdr;
> +	int active;
> +
> +	active =3D pm_runtime_get_if_active(dev);
> +	if (!active)
> +		return;

[Severity: High]
What happens if runtime PM is disabled on dev, or if sdev is quiesced when
scsi_clear_reset_ua() runs?

In drivers/base/power/runtime.c:pm_runtime_get_conditional(), disable_depth
is checked before runtime_status:

	spin_lock_irqsave(&dev->power.lock, flags);
	if (dev->power.disable_depth > 0) {
		retval =3D -EINVAL;
	} else if (dev->power.runtime_status !=3D RPM_ACTIVE) {
		retval =3D 0;

When runtime PM is disabled (for example during system suspend via
device_suspend() / __device_suspend_late() or during device removal via
__scsi_remove_device() -> device_del()), pm_runtime_get_if_active() returns
-EINVAL even if the device is RPM_SUSPENDED. Because if (!active) treats
-EINVAL as non-zero, scsi_clear_reset_ua() proceeds to issue
scsi_test_unit_ready(), which blocks in blk_queue_enter() on q->mq_freeze_w=
q.

Even when active > 0, the device may be quiesced via
drivers/scsi/scsi_lib.c:scsi_device_quiesce():

	blk_set_pm_only(q);

	memflags =3D blk_mq_freeze_queue(q);
	synchronize_rcu();
	blk_mq_unfreeze_queue(q, memflags);

	mutex_lock(&sdev->state_mutex);
	err =3D scsi_device_set_state(sdev, SDEV_QUIESCE);

This leaves dev->power.runtime_status at RPM_ACTIVE with disable_depth =3D=
=3D 0
during system suspend/resume or UFS shutdown in
drivers/ufs/core/ufshcd.c:ufshcd_wl_shutdown():

	ufshcd_rpm_get_sync(hba);

	ufshcd_store_tx_eq_settings(hba);

	scsi_device_quiesce(sdev);
	...
	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);

On BIWIN BWU2A05 devices, hba->ufs_device_wlun also gets tur_after_reset =
=3D 1.
If a BLK_MQ_REQ_PM command (such as START_STOP in ufshcd_set_dev_pwr_mode()
or SYNCHRONIZE_CACHE in sd_suspend_common()) reports a power-on or reset un=
it
attention while sdev is quiesced, scsi_report_sense() schedules
sdev->event_work. When scsi_clear_reset_ua() then submits a non-PM request =
via
scsi_test_unit_ready(), blk_queue_enter() sleeps in TASK_UNINTERRUPTIBLE on
q->mq_freeze_wq while holding the runtime PM reference (hanging indefinitely
in ufshcd_wl_shutdown() where scsi_device_resume() is never called).

Should scsi_clear_reset_ua() check if (active <=3D 0) (or handle -EINVAL wh=
en
CONFIG_PM=3Dy) and also guard against sdev->sdev_state !=3D SDEV_RUNNING ||
blk_queue_pm_only(sdev->request_queue), similar to
drivers/scsi/scsi_scan.c:scsi_rescan_device()?

> +
> +	scsi_test_unit_ready(sdev, sdev->request_queue->rq_timeout, 1, &sshdr);

[Severity: High]
Can scsi_test_unit_ready() starve waiting for a request tag when retrying
writes saturate the queue?

scsi_test_unit_ready() calls scsi_execute_cmd() -> scsi_alloc_request() ->
blk_mq_alloc_request() with flags =3D=3D 0, which waits in blk_mq_get_tag()=
 for a
normal non-reserved tag from bitmap_tags.

When write commands receive a power-on/reset unit attention,
drivers/scsi/scsi_lib.c:scsi_io_completion_action() requeues them immediate=
ly:

	case ACTION_RETRY:
		/* Retry the same command immediately */
		__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, false);
		break;

In __scsi_queue_insert() -> blk_mq_requeue_request() ->
__blk_mq_requeue_request() -> blk_mq_put_driver_tag():

	if (rq->tag =3D=3D BLK_MQ_NO_TAG || rq->internal_tag =3D=3D BLK_MQ_NO_TAG)
		return;

	__blk_mq_put_driver_tag(rq->mq_hctx, rq);

When an I/O scheduler is attached (such as the default mq-deadline on UFS,
where dd_init_sched() sets q->async_depth =3D q->nr_requests so writes can
consume all tags in sched_tags->bitmap_tags), __blk_mq_requeue_request()
releases rq->tag but keeps the scheduler tag (rq->internal_tag) across all
retries. When no I/O scheduler is configured, blk_mq_limit_depth() imposes =
no
limit on writes and blk_mq_put_driver_tag() does not release rq->tag on
requeue because rq->internal_tag =3D=3D BLK_MQ_NO_TAG.

If enough write requests are queued to fill all non-reserved tags across a
reset or runtime resume, won't those writes endlessly fail and requeue while
pinning every tag, blocking scsi_test_unit_ready() in blk_mq_get_tag() until
a write exceeds the 180s retry window and fails with an I/O error?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-biwin-tua-=
quirk-v2-1-4d71af956ac5@flipper.net?part=3D1
