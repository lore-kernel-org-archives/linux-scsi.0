Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902141;
	b=Kjz9dd69qG32SYRjCUhNRTZytbeKQefpP8eZSrCvxC26E+HBY2BOQHKCkuAGyJ9kelAr
	 tmHCb9XRFn+xbTQcNMyqMgZ/L9qdjVXccI7zzXwVSbsU8klldw53nA0sxXiwYDuIVI0UP
	 0K5ufVI9vOahYmlCpoWnZiTlVW/6zE89f0UV64k5Wf3JzD1aoR5HVynvgUj3ddnMVs6lc
	 IDmGsk/AqaTJsFGAHxHUt8X1pTantmV4RzAXXPfUz2zYCPngDvnGmkDSkVOmqLJFFop7P
	 VKxdtI2SPS5fbIy7GxPTTlUauQNmKQtVBgESqCXgKaBTan44LIjz0vNvO7qpc67z7Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902141;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=M5SiIj+fBRN52LyQheSCWAl/ZpF12uGftXSG8ptTpF8=;
	b=r44anFu5DzHD0+cGcdgf3veEhHc+UscF3tZfy1M3TpFKSjjBKhLslGnWMeRztmdShtJq
	 nAcHW6EQGq13iKuKGMf0T86rO9HmhLolYJEinHERtEPAW8c780vSLFYvSG/1paGmQXbnT
	 Lpxat/OoMpS4n8oeoGLQ+SpkAulmS3MFREuhIEninZ9/moBIfttPqIve7Q9Qrg+Waup7w
	 VaIvX3SZoslHbIpmvPHF4mNSP6qODuQ0NPzThGdM5x3t/PQ4fJsedVL9Kiscp/CL777xa
	 9XyfCZ3O8BhLJofzrdxMo9d40Y8AMU1NTad4FSUoQmR7EQHZYFI40t6cpfPwqXDhWTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IAnuzGzk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A87606A332
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IAnuzGzk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931691F00919;
	Thu,  5 Nov 2026 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902140;
	bh=M5SiIj+fBRN52LyQheSCWAl/ZpF12uGftXSG8ptTpF8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IAnuzGzkLlPMLC3EoCyKUARzezA9BLRJj12IqAsKOpQo87J1CCvRAYXE2Atav2SnO
	 z0MJQrlCp03+yO5DCXaRxJzsTwIlqM19Cr3XZ6STqOk/jIPDdCZg8eu+M1qasGLLJX
	 CPafMRf/yKyDJ4MUcX19ZV6W9p35IQyP2DYaaY3/I4u7v5g2uH79kTX1hdd9eg3+HH
	 4eSGRJ8zunoNdBrkYZEg+l68j1I8hrZyTs8I2lz2q0VRP/XrCIuoTbLa/aOIVz3//K
	 lT7M1pKFSLB5J1niMBCGLHjw0OmHnN7qTS17Pk2Xu/YIa9fr8BKuhCjWW7VkrO9cLV
	 7znNe+qvPkEcw==
Message-ID: <sashiko-outbox-199695@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 06/13] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105-ibmvfc-fpin-support-v18-6-d683b74736a3@linux.ibm.com>
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
 <20261105-ibmvfc-fpin-support-v18-6-d683b74736a3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:09:00 +0000
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
- [Critical] scsi: ibmvfc: uninitialized tgt and fpin in ibmvfc_process_asy=
nc_work()
--

commit f3f5aed7c70a8803eed36bba7b018020fbce24fa
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

This commit adds basic Fabric Performance Impact Notification (FPIN) support
to the ibmvfc driver, offloading IBMVFC_AE_FPIN async events to a per-adapt=
er
ordered workqueue and converting them into fc_els_fpin descriptors for
fc_host_fpin_rcv(). It also adds a KUnit test suite to validate FPIN event
handling and statistics updates.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index e04c80050b981..a87beaeca13c8 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -3264,6 +3268,277 @@ static const char *ibmvfc_get_link_state(enum ibm=
vfc_ae_link_state state)

[ ... ]

> +/**
> + * ibmvfc_process_async_work - Process IBMVFC_AE_FPIN async CRQ from wor=
k queue
> + * @work: pointer to work_struct
> + */
> +VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
> +{
> +	struct ibmvfc_async_work *aw;
> +	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_els_fpin *fpin;
> +	unsigned long flags;
> +
> +	aw =3D container_of_const(work, struct ibmvfc_async_work, async_work_s);
> +	vhost =3D aw->vhost;
> +	crq =3D &aw->crq;
> +
> +	if (!crq->scsi_id && !crq->wwpn && !crq->node_name) {
> +		if (crq->fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
> +		    crq->fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
> +			fpin =3D ibmvfc_basic_fpin_to_desc(crq,
> +					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
> +		goto send_fpin;
> +	}
> +
> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
> +	tgt =3D ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
> +				 crq->wwpn, crq->node_name);
> +	if (!tgt) {
> +		/* Target not found in scsi_scrqs, search nvme_scrqs */
> +		tgt =3D ibmvfc_find_target(&vhost->nvme_scrqs.targets,
> +					 crq->scsi_id, crq->wwpn,
> +					 crq->node_name);
> +	}
> +
> +	if (tgt) {
> +		kref_get(&tgt->kref);
> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +	} else {
> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		dev_err_ratelimited(vhost->dev, "Invalid target for FPIN\n");
> +		goto free;
> +	}
> +
> +	fpin =3D ibmvfc_basic_fpin_to_desc(crq,
> +				cpu_to_be64(fc_host_port_name(vhost->host)),
> +				tgt->wwpn);
> +send_fpin:
> +	if (fpin) {
> +		fc_host_fpin_rcv(vhost->host,
> +				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
> +				 (char *)fpin, 0);
> +		kfree(fpin);
> +	} else
> +		dev_err_ratelimited(vhost->dev, "FPIN event received, unable to proces=
s\n");
> +
> +	if (tgt)
> +		kref_put(&tgt->kref, ibmvfc_release_tgt);

[Severity: Critical]
In ibmvfc_process_async_work() in drivers/scsi/ibmvscsi/ibmvfc-core.c, both
tgt and fpin are declared on the stack without being initialized to NULL.

When crq->scsi_id, crq->wwpn, and crq->node_name are all zero, the function
jumps directly to the send_fpin label without ever initializing tgt. At
send_fpin, checking if (tgt) and calling kref_put(&tgt->kref,
ibmvfc_release_tgt) will operate on an uninitialized stack pointer on every
zero-identifier FPIN event, including valid host-scope
IBMVFC_AE_FPIN_LINK_CONGESTED and IBMVFC_AE_FPIN_CONGESTION_CLEARED events.

Furthermore, if crq->fpin_status on that zero-identifier path is neither
IBMVFC_AE_FPIN_LINK_CONGESTED nor IBMVFC_AE_FPIN_CONGESTION_CLEARED (such as
the zero-identifier IBMVFC_AE_FPIN_PORT_CONGESTED case exercised by
ibmvfc_async_fpin_test() in drivers/scsi/ibmvscsi/ibmvfc_kunit.c), fpin is
also left uninitialized before jumping to send_fpin. If the uninitialized
fpin pointer on the stack is non-zero, send_fpin will dereference
fpin->desc_len, pass the garbage pointer to fc_host_fpin_rcv(), and pass it
to kfree(fpin).

Note that while the subsequent commit 6abed589f0fb ("scsi: ibmvfc: extend
async event handlers for async sub-CRQ events") initializes fpin to NULL, t=
gt
still remains uninitialized on the zero-identifier goto send_fpin path.

Should both tgt and fpin be initialized to NULL at declaration in
ibmvfc_process_async_work()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-ibmvfc-fpi=
n-support-v18-0-d683b74736a3@linux.ibm.com?part=3D6
