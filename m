Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759022;
	b=FmVW5UxCGwpNEhhcZQF6yFUFnKIWJKARi18OVan1BfZxEkXtUQe419viwkGVa+iPyNaE
	 QWZb08m2qv6D3XIn+D4qojPjXmMgBBI6Osz9yIURcRDpc2eXNXjm0dv7UTkAehJaiZklE
	 2xpQXLEUbxsHIExEi/m6IMhOPvhl8dPmlawXshdo2V9KwWazfnHtynmunJmx452HyboZA
	 QOtI1Nh7+G8UzHPdlasH5vWYTxbsKYrXKa0LZ9ZrMCCnDU7SVCBkuW7qquxe3CvErsYNL
	 uFRwUntTFSj41c3WExCCehUfvQkdK7VmvQ418mM+6K5XwB1rK5jQMfvkaDU8gNEqf5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759022;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lnPsgEQKjA7wi9W+n5dDO3+mkOKz+j6v6gVd5OU9Wu0=;
	b=EYuqLKHwZ9Q0af1fAyVg+rKS2ORaRxbUA796xGLqQY+zHC0Vw9NZC2q5c5LlQdTc4ls/
	 D4lhH2FGLgrS99e6OC/JP8cSRzlK/wLc7FYmJJaqvE4S+8Grw84NNQuuD83APIjan+02E
	 OqznrnpeYD6885FqDIyIGnBp490NF8oCfiAiBWLEtA53Db1kYGFU6YITdd+6hNKogc1jD
	 /e/ku22MVSCmfs2cWuIXak6FV4BMDUqKSobFVLx62d7RbWZwzy5Nn6Ov6Tg2VBz2gxlE0
	 hKhYTCAlrNFMwyp/RyKg87BeHq3wyuWDZ9faHU66D6zGCjlMbHrQPcHx7S4t6PJgjmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EIhiiRKg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503B5606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EIhiiRKg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF091F000C1;
	Wed,  4 Nov 2026 02:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793759021;
	bh=lnPsgEQKjA7wi9W+n5dDO3+mkOKz+j6v6gVd5OU9Wu0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EIhiiRKgagcvnT5U18Qt9P/cBxcZJ5Eg2GEi9w5U0yZRA44dIjLzA8Si++YA2UZvl
	 pegpKOArV7tIDbbORzTMJ7XYg408NgjRTJd214r7rlI9GQYsYr6D3xAtn9SDEbHclt
	 LNbUzmbku6Ag79vMf610BvvVqtBzcYw5/3kGz0NlUQTA2Y93Ch8fKnLnj3LUFEN8dp
	 XMi4xW/qpTXrJuuKk0aBlIF1Dea2D8yV0AG76XbQJUyyaWQsCQPzxgQ85gMDKV5P1C
	 G7JYQkU5G1CKNN8Gem7kILk0nl+fJJ9I33xKvn3IraXsitLAsfm9slk2IxI5X2bXqU
	 CvFYETXqLF/gw==
Message-ID: <sashiko-outbox-196449@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: myrb: unregister the SCSI host on remove
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261104021419.1468133-1-vulab@iscas.ac.cn>
References: <20261104021419.1468133-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 02:23:41 +0000
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
- [Critical] scsi: myrb: UAF of cb and active monitor_work in myrb_remove()=
 teardown
--

commit b7fd5614b253ea1ce6d98ee7d37937a94b3e4183
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: myrb: unregister the SCSI host on remove

This commit adds a call to scsi_remove_host() in myrb_remove() so that the
SCSI host is unregistered and its device registration references are dropped
when the PCI device is removed.

> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 95df6e5345f7a..e43d86f139c12 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -3496,6 +3496,7 @@ static void myrb_remove(struct pci_dev *pdev)
>  {
>  	struct myrb_hba *cb =3D pci_get_drvdata(pdev);
> =20
> +	scsi_remove_host(cb->host);
>  	shost_printk(KERN_NOTICE, cb->host, "Flushing Cache...");
>  	myrb_exec_type3(cb, MYRB_CMD_FLUSH, 0);
>  	myrb_cleanup(cb);

[Severity: Critical]
Does calling scsi_remove_host(cb->host) here trigger a use-after-free of cb
when myrb_remove() subsequently calls myrb_destroy_mempools(cb)?

In drivers/scsi/myrb.c:myrb_detect(), struct myrb_hba *cb is allocated inli=
ne
within struct Scsi_Host via scsi_host_alloc() and obtained with
shost_priv(shost):

drivers/scsi/myrb.c:myrb_detect() {
	shost =3D scsi_host_alloc(&myrb_template, sizeof(struct myrb_hba));
	if (!shost) {
		dev_err(&pdev->dev, "Unable to allocate Controller\n");
		return NULL;
	}
	shost->max_cmd_len =3D 12;
	shost->max_lun =3D 256;
	cb =3D shost_priv(shost);
}

Now that scsi_remove_host(cb->host) drops the device registration references
taken by scsi_add_host(), the scsi_host_put(cb->host) call at the end of
myrb_cleanup(cb) drops the final reference on shost->shost_gendev and frees
both shost and cb via scsi_host_dev_release():

drivers/scsi/myrb.c:myrb_cleanup() {
	...
	pci_set_drvdata(pdev, NULL);
	pci_disable_device(pdev);
	scsi_host_put(cb->host);
}

Immediately after myrb_cleanup(cb) returns, myrb_remove() calls
myrb_destroy_mempools(cb), which dereferences the freed cb pointer:

drivers/scsi/myrb.c:myrb_remove() {
	struct myrb_hba *cb =3D pci_get_drvdata(pdev);

	scsi_remove_host(cb->host);
	shost_printk(KERN_NOTICE, cb->host, "Flushing Cache...");
	myrb_exec_type3(cb, MYRB_CMD_FLUSH, 0);
	myrb_cleanup(cb);
	myrb_destroy_mempools(cb);
}

drivers/scsi/myrb.c:myrb_destroy_mempools() {
	cancel_delayed_work_sync(&cb->monitor_work);
	destroy_workqueue(cb->work_q);

	dma_pool_destroy(cb->sg_pool);
	dma_pool_destroy(cb->dcdb_pool);
}

In addition, because cb->monitor_work and cb->work_q are only stopped in
myrb_destroy_mempools(), running myrb_cleanup() first leaves myrb_monitor()
able to run concurrently while myrb_cleanup() -> myrb_unmap() frees the DMA
buffers and mailboxes (cb->enquiry, cb->err_table, cb->ldev_info_buf,
cb->first_stat_mbox, cb->first_cmd_mbox), unmaps cb->mmio_base, and frees t=
he
IRQ.

Should myrb_destroy_mempools(cb) be called before myrb_cleanup(cb), matching
the order used in the myrb_probe() error path and in myrs_remove()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104021419.1468=
133-1-vulab@iscas.ac.cn?part=3D1
