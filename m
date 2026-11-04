Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759261;
	b=vtMfWJxFwZmKsfMa9inBnPy/h02dWQrX6T99+HgOcppgnjtKqheseBt/AUB9jl1AWB6M
	 viDbJfEmjeh5rLf0oSJaDMCrarsVZZ+knoGE01N79YSvHxlQ0x9byU8sK3yhdklkpxXgC
	 UXIPcroeARO9zt21jz8r4wdYPIGWc5K1qOHRVhfiesP07wLR7/kMKT/eSeM9EcQQS6oiq
	 R9uH1X+uxM6V3Xzjh0ZfE8VC1zMsMyqO2XwC7aHvrbh0Be4jLGcFLTb3P3I4x0xV5ChEw
	 57iQlkxHMU69ziQCu3kc53kY6hzNRsKkDKa7NJyXgqZKtF9VlgsbH9nbLjlsTR5t2Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759261;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qSlp0oMN0bPD8t0wCUaRwnVwKnhbMr7y0AurpAqa0zI=;
	b=OuFlqcHpfeGVD06eHAje+7l6qdfbDJ78FXXy3srWy5euddj+BfsYSNs/gONsZxCTXuFg
	 bm6AbmbYzSOMbD4UWQ2pUTkcQfTO6di9EboczPH+4U7hm6AMYHSetQSLze+g3XgQ0GfM3
	 qJKhIXmPfhbVPzFnNshCwhg0cGXSbuPhnNMqYZQrXyl+8yzmolpWjtHS9vrZQNg6aavdd
	 E+xSBEUmkwMCVTU+aOYbDOWmqvqiYQcbtKTQUSCS0bEB6E9zQZpf9mICRpwM6RLnbQesr
	 uJbctNJYVJqq+hz4xaMaYsKwpBj9yHs09Bc99k+Zfz+wK4n1gnoxX9XcvPIs7GMsRpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lruYq/nG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C14E606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lruYq/nG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8BF1F000C1;
	Wed,  4 Nov 2026 02:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793759261;
	bh=qSlp0oMN0bPD8t0wCUaRwnVwKnhbMr7y0AurpAqa0zI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lruYq/nGTJcq5gQiGJ9HGDXZDMDbBDktnlIzJR/XFYQgk32gIYRGehB4A7xgtXwK2
	 9n7tBPr5n2eVomY/A4E9bbe1a1zhPR+b7UvSD+qXNwVX3U31BJHnWRSl0f/UGoJK8p
	 6E8N1cnx/c08k/Gybi+sVBfQWMvbjl8RbQjsU23eadCbBNiwsFvGTzqp9FDNXFtQyW
	 nOzh3tIPhQHGZxnLJavBl655uds/bPk2+kY2oor7N9yednTq1rQhKVhpa1rYS1/7k9
	 4q/tiMpyRF0R8+yh02JUsOCw+HxCG+6EZ0OJyWkPX5DYxpWNaHdyaczhhCNRKzQY53
	 fo/isEwEX2lcA==
Message-ID: <sashiko-outbox-196465@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mvsas: put the Scsi_Host when host setup fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261104021440.1468339-1-vulab@iscas.ac.cn>
References: <20261104021440.1468339-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 02:27:40 +0000
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
- [High] scsi: mvsas: use-after-free in mvs_pci_init() when scsi_add_host()=
 fails
--

commit 6788dffec70edd91c99d1078d3e86b6a8d604507
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: mvsas: put the Scsi_Host when host setup fails

This commit adds a call to scsi_host_put() after scsi_remove_host() in the
mvs_pci_init() error unwind path so that the Scsi_Host allocation reference
is dropped when probing fails.

> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 5abc17a2e2610..9210cb0bb2c11 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -571,6 +571,7 @@ static int mvs_pci_init(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
>  	sas_unregister_ha(SHOST_TO_SAS_HA(shost));
>  err_out_shost:
>  	scsi_remove_host(mvi->shost);
> +	scsi_host_put(shost);

[Severity: High]
Does this cause a use-after-free on shost when scsi_add_host() fails in
mvs_pci_init()?

Earlier in drivers/scsi/mvsas/mv_init.c:mvs_pci_init(), a failed
scsi_add_host() jumps to err_out_shost:

	rc =3D scsi_add_host(shost, &pdev->dev);
	if (rc)
		goto err_out_shost;

When scsi_add_host_with_dma() fails, it rolls back any partial registration
and leaves shost->shost_gendev with only the single initial allocation
reference from scsi_host_alloc().

Jumping to err_out_shost then calls scsi_remove_host(mvi->shost) on a host
that was not added. Because scsi_host_set_state(shost, SHOST_CANCEL) allows
the transition from SHOST_CREATED to SHOST_CANCEL, scsi_remove_host()
proceeds to unregister shost->shost_dev:

drivers/scsi/hosts.c:scsi_remove_host()
  device_unregister(&shost->shost_dev)
    put_device(&shost->shost_dev)
      scsi_host_cls_release()
        put_device(&shost->shost_gendev)

Depending on where scsi_add_host_with_dma() failed, scsi_remove_host() eith=
er
waits on an uninitialized shost->tagset_freed completion or drops the sole
reference on shost->shost_gendev and frees shost, after which the newly add=
ed
scsi_host_put(shost) accesses the already-freed Scsi_Host.

Should a failed scsi_add_host() bypass scsi_remove_host() and jump directly=
 to
a label that only calls scsi_host_put(shost)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104021440.1468=
339-1-vulab@iscas.ac.cn?part=3D1
