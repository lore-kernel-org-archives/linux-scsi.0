Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428423;
	b=U/UcM++67GoFzOCTwVFP8mpFjUhalo60mwS1RBURKyuNwuank7IR8aIKHdpVp2W0ScFB
	 D4XP4mo0UzX3cpPEBeNbT+qsRuJpUnsm9AmPaFqhXTI72HIc+oWObCifT13srHX5OTjew
	 DvSyUIK1Qtqq3pfeFM9luTkjdt/lzD8Sn4d0YyeQHKs3Z7+HGyRvhCgzcFwRbIjWxcgRF
	 IOIDh097/A6MOS9MiUhQWXm9sAUXlra1BfW9k45qfIFWRjus8Jgp9mbroSYwPdEiIHMB0
	 foAlBZjHBMhB+CuCKs4+7fpqpaCA2eRPbE3QqD8GztKGPLgltotifV2hig+ZG/HTigw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428423;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qfO109l0TvDjVf0ceCDtcah5Jzl+8rqydzzTxs7XYH0=;
	b=X/4yxBpBvPagVWJw+wBLCVmSTYWytbi2C444TF+xsrDhyiJz+XWfA+hKA7+kaXUpZFoo
	 gNkWKuDc3nZWM4EFMDz3Nm4xsSg2Fn7T6M3rfV8Ia36WsYpMpE089sM6pDvRjn1G1BuvE
	 ofIkHysNkjvjTn+2dYYbcVN1zDXp/ktx4XSSCzDFsIe2GdVNeYq71HAcZB1J+afvDLPhq
	 TdHQkWGur9D35Vu4Ka39VxKGWQJ4aGkGnhRq8gCJ+Ra7orXUoTghpyRH/rhHK9ip1B+Dy
	 jqPwuHzu48aGGnE0Zk9aUYTX9bcxGt/Aj66WEd9t9BlATJywdfVRrcIFcdilYVt2nbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YBbJCVpl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B360606A324
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 16:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YBbJCVpl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80421F01574;
	Mon, 19 Oct 2026 16:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428422;
	bh=qfO109l0TvDjVf0ceCDtcah5Jzl+8rqydzzTxs7XYH0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YBbJCVpl+voewWZDTH/hTbeq0cjHOAgxuzGqG2b1ZFJ0G1RJ5EdeCd/gIKSDtu6dQ
	 WDqd4u+bpv8NUxSdJYThwfSADkxr9lIjkUrE6ZItp3gj8ECkUMXZm1wmHLAfgpJsnM
	 tHA+mA27cMAsb9dft39Ic9rtlciyXKh26pRFEVXQcMFqI2RUftwq7UCvvQ+xGnvd09
	 37wfY+YuDUDhZI6tUhoCuSZQWlL4YxhvkDlOPH82pieLXTzR3LSQo1yCNdwrMuq4UO
	 vC7EPmD0g4DS74SWm/XXUCN+mjw4KCFqjG89qbfrZD4wdUBfViV+xcUnCBPiORJZpN
	 DjLdjZ6TKodPg==
Message-ID: <sashiko-outbox-177932@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ppa: cancel delayed work before freeing on detach
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261019163821.659714-1-tristmd@gmail.com>
References: <20261019163821.659714-1-tristmd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 16:47:02 +0000
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
- [Critical] scsi: ppa: premature cancel_delayed_work_sync() in ppa_detach()
--

commit 917c5d0559eb52b27c70170022ca6e35b2cc8798
Author: Tristan Madani <tristan@talencesecurity.com>

scsi: ppa: cancel delayed work before freeing on detach

This commit adds a cancel_delayed_work_sync() call on dev->ppa_tq in
ppa_detach() to prevent ppa_interrupt() from accessing freed memory after
dev is freed.

> diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
> index 8a4e910d5758f..7f4b2a4157725 100644
> --- a/drivers/scsi/ppa.c
> +++ b/drivers/scsi/ppa.c
> @@ -1136,6 +1136,7 @@ static void ppa_detach(struct parport *pb)
>  	ppa_struct *dev;
>  	list_for_each_entry(dev, &ppa_hosts, list) {
>  		if (dev->dev->port =3D=3D pb) {
> +			cancel_delayed_work_sync(&dev->ppa_tq);
>  			list_del_init(&dev->list);
>  			scsi_remove_host(dev->host);
>  			scsi_host_put(dev->host);

[Severity: Critical]
Is calling cancel_delayed_work_sync() before scsi_remove_host() in
drivers/scsi/ppa.c:ppa_detach() safe against new commands being queued or
in-flight commands draining during host removal?

Unlike disable_delayed_work_sync() (which is what drivers/scsi/imm.c uses in
imm_detach(), rather than cancel_delayed_work_sync() as mentioned in the
commit description), cancel_delayed_work_sync() does not prevent subsequent
schedule_delayed_work() calls.

When cancel_delayed_work_sync() returns here, dev->host has not been removed
yet and the SCSI device request queues are still active. Concurrent I/O or
shutdown commands issued during scsi_remove_host() -> scsi_forget_host() ->
__scsi_remove_device() -> device_del() -> sd_remove() -> sd_shutdown() can
still invoke ppa_queuecommand_lck() before blk_mq_destroy_queue() freezes t=
he
queue:

drivers/scsi/ppa.c:ppa_queuecommand_lck() {
	...
	dev->cur_cmd =3D cmd;
	cmd->result =3D DID_ERROR << 16;	/* default return code */
	ppa_scsi_pointer(cmd)->phase =3D 0;	/* bus free */

	schedule_delayed_work(&dev->ppa_tq, 0);

	ppa_pb_claim(dev);
	...
}

If dev->ppa_tq is re-armed after cancel_delayed_work_sync() has already run,
and that command times out and is aborted by ppa_abort() or ppa_reset() (wh=
ich
sets dev->cur_cmd =3D NULL without cancelling dev->ppa_tq), or if
ppa_interrupt() calls scsi_done(cmd) allowing scsi_remove_host() to finish
while ppa_interrupt() is still executing or re-arming itself, ppa_detach() =
can
proceed to kfree(dev) while dev->ppa_tq is still pending or running, leaving
the use-after-free in place.

Conversely, because this driver has no hardware interrupt and relies solely=
 on
ppa_interrupt() polling via dev->ppa_tq to drive ppa_engine(), release the
parport claim, and complete commands:

drivers/scsi/ppa.c:ppa_interrupt() {
	...
	if (ppa_engine(dev, cmd)) {
		schedule_delayed_work(&dev->ppa_tq, 1);
		return;
	}
	...
	if (ppa_scsi_pointer(cmd)->phase > 1)
		ppa_disconnect(dev);

	ppa_pb_dismiss(dev);

	dev->cur_cmd =3D NULL;

	scsi_done(cmd);
}

cancelling dev->ppa_tq before scsi_remove_host() stops polling for any
already in-flight command (dev->cur_cmd !=3D NULL). When scsi_remove_host()=
 ->
__scsi_remove_device() -> blk_mq_destroy_queue() -> blk_mq_freeze_queue_wai=
t()
waits for in-flight requests to complete, wouldn't it stall until the SCSI
command timeout fires, and also skip ppa_pb_dismiss(dev) before
parport_unregister_device(dev->dev)?

Should dev->ppa_tq be cancelled (or disabled with disable_delayed_work_sync=
())
after scsi_remove_host(dev->host) instead, so that in-flight and shutdown
commands can finish draining and ppa_queuecommand_lck() can no longer be
called to re-schedule the work?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019163821.6597=
14-1-tristmd@gmail.com?part=3D1
