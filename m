Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903139;
	b=A2LYIk4946sOtoQXgEQ/3J6LrIXyOynHJhOAPRoj/J0lF2IznDnEU5/OWPJOrTxbWRXB
	 ywWkR5kNV733EK7wi0bfAJrz5RDgTtMPsD/lA75FqMYlsBVEK74W02ntgtaDxwSP4Xqg+
	 BxPrffh5tkecxDVWFJPiX7Onbe3z6V6mUrrKKAEppH4MduZ0U8B91C0N7rZIE6XHvsHt+
	 u7iYE9V3dpmbfpGgpFTWZu6yHEjNRqhcJzNx1LcbxPkgzh8XUI5Kb9fSLzFS1uypYSd26
	 DGU4pCodR6Uusw9Mrgp/tjZCHVsmfR6TIDkaxodXHb4TvZ2OLiflMmEH2m73vv+cK8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903139;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+efgDKFWXwjuhJAos//pwUOxsp9Unrux3K4RUZWvSd8=;
	b=rb4VzcihM/yjSuGpFqBq8fbglegnhNYj/9nhV0zEnZrFAvGcuS+9eC0JSabfLWMLTA/v
	 qohefO2XtqYfXv7JV0m/bzuiOgJSAlYhbXfFX6LwgZVIwjJAxbkmf+HuE8Kf2swUheFBi
	 8DI0AGoPVVAxELh0iF+86lbaFFoWuMnMj8e8E8ZkaD72nKxoHRmK8D3o7Y0lE6QTIkKgA
	 mtwmnIXzZ/gKZdNf9mfMO2Qq3Qyw5jdQKXZPZlaAIB9+TaQ9odK7u+Rh0T2sxx0gcUGBn
	 mjf8K47WjHszOmmcGRXOZllxAQc/Uu37RTbRrzFQleapCFLsfhTAuhO3qCD39/uGWew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqML5R5x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66BB606A332
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqML5R5x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576E41F000C1;
	Thu,  5 Nov 2026 18:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903138;
	bh=+efgDKFWXwjuhJAos//pwUOxsp9Unrux3K4RUZWvSd8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FqML5R5xLrpvUesjW4Q1smiJAPQXvoTmUW8QTObn8jdxtuhdw4/e95260ZblE05WD
	 F4TsINhOpnt89ImwKsEGlfFdlWO7nUBHgcEIezF4j7kZcm0iz+oAsVf9MnGFsf2eZi
	 foOpHgPtABJl92p7F8mN7kwpev1P+q3qTFHUfLE1ojLHDbAB5wEU4N+WNzaab7a3n6
	 mN1wXoYH/gHJ7N6ValsFun0PPyA/QwW1PT+5pkjcDAys4a1+rjOAqsnegytDoU37JE
	 egczaGzeWAaYOE4fwT+3Uvw9nk/JHq3Q4oBs3npHlIOfDIz1rLiW2/fVTGvwomGWlk
	 gLjQ9rSlU68Iw==
Message-ID: <sashiko-outbox-199759@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 09/13] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105-ibmvfc-fpin-support-v18-9-d683b74736a3@linux.ibm.com>
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
 <20261105-ibmvfc-fpin-support-v18-9-d683b74736a3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:25:37 +0000
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
- [High] scsi: ibmvfc: uninitialized tgt read in ibmvfc_process_async_work()
--

commit 6abed589f0fb0c5ef9d54c07ceaaef90b5ef640d
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend async event handlers for async sub-CRQ events

This commit refactors async event handling in ibmvfc to support both main
CRQ and async sub-CRQ events via a tagged union struct
ibmvfc_async_crq_event, and adds ibmvfc_full_fpin_to_desc() and assoc_id
target matching.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b9b571db44649..7406e7182777c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3483,33 +3528,59 @@ static struct ibmvfc_target *ibmvfc_find_target(s=
truct list_head *target_list,
>   */
>  VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
>  {
> +	struct ibmvfc_async_sub_crq *subq =3D NULL;
>  	struct ibmvfc_async_work *aw;
> -	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_async_crq *crq =3D NULL;
>  	struct ibmvfc_target *tgt;

[Severity: High]
Should tgt be initialized to NULL here?

When scsi_id, wwpn, node_name, and assoc_id are all zero,
ibmvfc_process_async_work() jumps directly to the send_fpin label before
tgt is assigned by ibmvfc_find_target():

	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
		if (fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
		    fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
			fpin =3D ibmvfc_basic_fpin_to_desc(crq,
					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
		goto send_fpin;
	}

At the end of send_fpin, the cleanup checks:

	if (tgt)
		kref_put(&tgt->kref, ibmvfc_release_tgt);

Wouldn't that evaluate and potentially dereference an uninitialized tgt
pointer on the zero-identifier path?

>  	struct ibmvfc_host *vhost;
> -	struct fc_els_fpin *fpin;
> +	struct fc_els_fpin *fpin =3D NULL;
>  	unsigned long flags;
> +	__be64 assoc_id;
> +	__be64 node_name;
> +	__be64 scsi_id;
> +	__be64 wwpn;
> +	u8 fpin_status;
> =20
>  	aw =3D container_of_const(work, struct ibmvfc_async_work, async_work_s);
>  	vhost =3D aw->vhost;
> -	crq =3D &aw->crq;
> +	if (aw->event.type =3D=3D IBMVFC_ASYNC_CRQ_SUB) {
> +		subq =3D &aw->event.subq;
> +		scsi_id =3D 0;
> +		wwpn =3D subq->wwpn;
> +		fpin_status =3D subq->fpin_status;
> +		if (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) {
> +			node_name =3D 0;
> +			assoc_id =3D subq->id.assoc_id;
> +		} else if (subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) {
> +			node_name =3D 0;
> +			assoc_id =3D 0;
> +		} else {
> +			node_name =3D subq->id.node_name;
> +			assoc_id =3D 0;
> +		}
> +	} else {
> +		crq =3D &aw->event.async_crq;
> +		scsi_id =3D crq->scsi_id;
> +		wwpn =3D crq->wwpn;
> +		node_name =3D crq->node_name;
> +		fpin_status =3D crq->fpin_status;
> +		assoc_id =3D 0;
> +	}
> =20
> -	if (!crq->scsi_id && !crq->wwpn && !crq->node_name) {
> -		if (crq->fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
> -		    crq->fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
> +	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
> +		if (fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
> +		    fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
>  			fpin =3D ibmvfc_basic_fpin_to_desc(crq,
>  					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
>  		goto send_fpin;
>  	}

[Severity: High]
Can this dereference a NULL crq pointer when handling an async sub-CRQ
event?

When aw->event.type is IBMVFC_ASYNC_CRQ_SUB, subq is populated and crq
remains NULL. If scsi_id, wwpn, node_name, and assoc_id are all zero for a
host-scope IBMVFC_AE_FPIN_LINK_CONGESTED or
IBMVFC_AE_FPIN_CONGESTION_CLEARED event, this block unconditionally calls
ibmvfc_basic_fpin_to_desc(crq, ...), which immediately dereferences
crq->fpin_status:

static struct fc_els_fpin *
ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, __be64 detecting_ww=
pn,
			  u64 wwpn)
{
	__be16 type;

	switch (crq->fpin_status) {

Should this path check if (crq) and dispatch to
ibmvfc_full_fpin_to_desc(subq, ...) when crq is NULL, matching the target
fallback path further down in ibmvfc_process_async_work()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-ibmvfc-fpi=
n-support-v18-0-d683b74736a3@linux.ibm.com?part=3D9
