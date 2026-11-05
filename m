Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903839;
	b=vMA/0mqpoufmizigWbnyXvRKVLVOqIIIl/xiM8r3ObDp4nQ3u8a/TgVs6M2ElBKWfS/G
	 c5xrbpTHblbKZsmhwG/5Rxa+kymhHKs2Pe7iPHBTKcO7SNcMzzQyIeT1qtoMb0OCa4RhZ
	 bPskNgBgG/VaEsznMucQO8Eqq96Whw+v1k+ONP7jxZhXKZ8hwkn3K1m5WA3GSk0dNYBrQ
	 KtPz4gszpQg+ccND20skwyCxLfTuT2Si1q9C+btoQf/EPomg1s5rkr7dqzjgUzePKL7jY
	 JRfwfYk6m5H6t8Xhug24qzMaIzSgdYnXTt8gUrLTGWpxbjx2erhagmJgBwP7v1zPO3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903839;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zvCUf1GZo2zKrKTQz7xTJbL1JhsB9mlvSUzOLxlaM/M=;
	b=0t/BcGNVZqgxl/5LPPW/gMC8XzEkGSXoY2As5sbTkgnBCIwH3BJYhORaV1/pA2W2q9DD
	 fL21lJRu+xosAdRghLImX/TK0rwtg22moUj9A4KmBDjnrKvjgAyfLEewNb4RA2WFDfiIj
	 PwrFBudxW2+A035X7/9Ufx9l6+FuWmcYsCsbn76G/hglx9n7HL+lzPeCQ1c6X+PYyB0q5
	 0aC6RTs++UfX5oJFk9bgAFI2HCCCGolZzc0TnzEfaxoCo/HcGiU9fJMbvwF9ck2BTRNsb
	 u29rE0C+S7u5ylQaacESNw/7FYGwVCQKRuMRU5LoGDSJ+/rtckoUPegtJ5/eXN7+NRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jJxTZ1No;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD3A606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 18:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jJxTZ1No
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C261F00919;
	Thu,  5 Nov 2026 18:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903839;
	bh=zvCUf1GZo2zKrKTQz7xTJbL1JhsB9mlvSUzOLxlaM/M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jJxTZ1NoiSIyzTMHSbINgaDbrQZjJgoFKk94cUJ1gix+ISZIVYHjpn5LRr/0S3EoR
	 SLKlVBSbz3Gw3oi8MY0n1YiJ7nsmfUAuiploOrMQpwA3N7xju4Vs7iB6FvK+5EIuzp
	 mpMJSHdMK6ga9pP7+wxaU4ENyXgnwkiIOHMJJSD0ChgXIQ1uomiZ/NSx0N3HsSg71U
	 nG+csn9I2+PVbuEzIUGfc1lk9ieREcqc3CaO+S8129xOUEwpbeGOLiUV7fIei0uo45
	 8aFm7FKsqMREfb7np3L7TZOlJq3ps1yH+j6jx76kMvqdbmtEfT+gf4RNM3PsP5Vk9k
	 Snja3aChpQpZA==
Message-ID: <sashiko-outbox-199779@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 10/13] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105-ibmvfc-fpin-support-v18-10-d683b74736a3@linux.ibm.com>
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
 <20261105-ibmvfc-fpin-support-v18-10-d683b74736a3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:37:18 +0000
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
- [High] scsi: ibmvfc: NULL crq dereference in ibmvfc_process_async_work()
- [High] scsi: ibmvfc: uninitialized tgt pointer in ibmvfc_process_async_wo=
rk()
--

commit e623a6d56430928cd690d92425a90ffd4dc7ba74
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ

This commit adds ibmvfc_interrupt_async_subq() and supporting helpers to
drain asynchronous sub-CRQ entries onto a temporary list and dispatch them
through ibmvfc_handle_async().

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 7406e7182777c..5dba084086d5f 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4456,6 +4456,106 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct=
 ibmvfc_queue *scrq)

[ ... ]

> +static void ibmvfc_queue_async_subq_entry(struct ibmvfc_host *vhost,
> +					  struct ibmvfc_async_sub_crq *crq,
> +					  struct list_head *doneq)
> +{
> +	struct ibmvfc_async_drain_entry *entry;
> +
> +	entry =3D kzalloc_obj(*entry, GFP_ATOMIC);
> +	if (entry) {
> +		entry->event.type =3D IBMVFC_ASYNC_CRQ_SUB;
> +		entry->event.subq =3D *crq;

[Severity: High]
Can dispatching an IBMVFC_ASYNC_CRQ_SUB FPIN event here lead to a NULL
pointer dereference in ibmvfc_process_async_work()?

When ibmvfc_drain_async_subq() passes entry->event to ibmvfc_handle_async()
for an IBMVFC_AE_FPIN event, it queues ibmvfc_process_async_work() with
aw->event.type =3D=3D IBMVFC_ASYNC_CRQ_SUB.

In drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_process_async_work(), crq is
initialized to NULL and remains NULL on the IBMVFC_ASYNC_CRQ_SUB branch:

	struct ibmvfc_async_sub_crq *subq =3D NULL;
	struct ibmvfc_async_work *aw;
	struct ibmvfc_async_crq *crq =3D NULL;
	...
	if (aw->event.type =3D=3D IBMVFC_ASYNC_CRQ_SUB) {
		subq =3D &aw->event.subq;
		scsi_id =3D 0;
		wwpn =3D subq->wwpn;
		...
	}

If the sub-CRQ FPIN event has all-zero target identifiers (for example, a
host-scope IBMVFC_AE_FPIN_LINK_CONGESTED or
IBMVFC_AE_FPIN_CONGESTION_CLEARED event with zero wwpn and zero
node_name/assoc_id, or with IBMVFC_ASYNC_IS_FPIN_EXT set and wwpn =3D=3D 0),
ibmvfc_process_async_work() unconditionally calls ibmvfc_basic_fpin_to_desc=
()
with crq =3D=3D NULL instead of ibmvfc_full_fpin_to_desc(subq, ...):

	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
		if (fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
		    fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
			fpin =3D ibmvfc_basic_fpin_to_desc(crq,
					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
		goto send_fpin;
	}

ibmvfc_basic_fpin_to_desc() then immediately dereferences crq->fpin_status.
Should this path check if (crq) vs else ibmvfc_full_fpin_to_desc(subq, ...)
in the same way as the !tgt fallback below it?

> +		list_add_tail(&entry->list, doneq);
> +	} else
> +		dev_err_ratelimited(vhost->dev,
> +				    "Couldn't allocate async drain entry\n");
> +	crq->valid =3D 0;
> +	wmb();	/* complete write */
> +}
> +
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{

[ ... ]

> +	list_for_each_entry_safe(entry, temp, &doneq, list) {
> +		list_del(&entry->list);
> +		spin_lock_irqsave(&vhost->host->host_lock, flags);
> +		ibmvfc_handle_async(&entry->event, vhost);

[Severity: High]
When ibmvfc_handle_async() queues ibmvfc_process_async_work() for an
IBMVFC_AE_FPIN event with all-zero target identifiers, can tgt be used
uninitialized at the send_fpin label?

In drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_process_async_work(), tgt is
declared without initialization, and the all-zero identifier check jumps
over ibmvfc_find_target() directly to send_fpin:

	struct ibmvfc_target *tgt;
	...
	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
		if (fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
		    fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
			fpin =3D ibmvfc_basic_fpin_to_desc(crq,
					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
		goto send_fpin;
	}
	...
send_fpin:
	...
	if (tgt)
		kref_put(&tgt->kref, ibmvfc_release_tgt);

Wouldn't that evaluate if (tgt) and call kref_put() on an uninitialized
stack pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-ibmvfc-fpi=
n-support-v18-0-d683b74736a3@linux.ibm.com?part=3D10
