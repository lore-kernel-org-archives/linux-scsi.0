Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906133;
	b=BJ4aTIcOdZoDVzG3tb36xJBtxpQj0042l3oLrdWWVitOfftuxSLP4qRP6u7KB6GrND1c
	 SiI6smOTaQlfeCVYt0aEpFZxKFCDGJwmCvXO7kmj46BXiMnRRfp88dHA6FCF7mZgDfbFx
	 4FFg4AwKU+WHiY8Mylm3gPp+1gDj0mfkvMVxOzL6VOB8sa3hI3BJYXlKPn5/pANPn3k3U
	 WpJHWpV9QIEaFciaUBFBio8KV0S0d/6TRNHP8S0gzujrjliP6gWaX6BAleP87xq9qqjxC
	 DNMzA2pSm1Xrs9JN230q2g5f+O3Ii4d6zrbXzR7EO3Mo9Gy7BlFQUhs3Fu4GDy97K3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906133;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u3CkOVk1Y+p7yE9cjU2O9vyfWNImYJVDxeribTargQ0=;
	b=me3B8frN6abj0MnWZgfh0O1LC9Lk9AOf86BjbzMi4yuO8UGPYd7kM0PXL8/lDUzVaF38
	 XCGYgksrjv/EReBEKh3H8RNt98wrSshWkK+qSdQwL+spmtRhEFWnPFb4du7/OJf7YsG9X
	 nFajZUP3hQa9GUysLQkZ1A6aBOb3rwa4OFOyprYXy0lJV/LC0Hb9nGDGaMHcSOh4BQWGR
	 iaoJJvytQgxPQepgs8f13XQJc2M0BOxQ3Mvh27ATtELGCiclIozgdIexBRq/CJc0VOluV
	 gvWHZ+yJKPEh0sjeLcIBHC5X62qtf8HI4DdMTaFd4RH1UQcKljUNJRzAznA5NCu9NTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2oGMw+Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF1B606A328
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 19:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2oGMw+Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FD51F000C1;
	Thu,  5 Nov 2026 19:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906133;
	bh=u3CkOVk1Y+p7yE9cjU2O9vyfWNImYJVDxeribTargQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B2oGMw+QP5AIM4WwQccCbhouKpjdaRBXXJ7KuZZenNcPKOsn9E0C6QT6gFXjymSr+
	 wTXGHpXMj+QHQzFYExbZyZLgaX9aUq4640pXrjZ0jDdtEkalrpMNFocE049UIyXhLQ
	 Xdqtv3CHL78k8XUx2pGKxmAB5rA+orealOX2v42TPO3wSClV+PXWNrfWmQGnqXSzXh
	 OpUF56YSoDHVkvN25GI+QGpR0NDZ3zhB5sq7g+TVSA1jJBq4qd/9sGZTVVrcv37m1Y
	 Ttx1NSzSGd7Z5ymXEOAXaIEWpGOgLONh2AFVqY495mkaM/iZFddtVMWaudiDi9LDqA
	 21GLuO2Q4ulFg==
Message-ID: <sashiko-outbox-199829@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 13/13] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105-ibmvfc-fpin-support-v18-13-d683b74736a3@linux.ibm.com>
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
 <20261105-ibmvfc-fpin-support-v18-13-d683b74736a3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:15:32 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] scsi: ibmvfc: uninitialized tgt pointer passed to kref_put() o=
n FPIN path
- [High] scsi: ibmvfc: NULL crq deref and missed ext FPIN on host-scope pat=
hs
- [Medium] scsi: ibmvfc: wrong default severity in ibmvfc_ext_fpin_to_desc()
- [Low] scsi: ibmvfc: commit message mismatch with changes in earlier patch
--

commit a2aeb896595835b42eba9922a25c766496e63499
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: handle extended FPIN events

This commit implements support for extended FPIN messages received via the
asynchronous sub-queue by adding ibmvfc_ext_fpin_to_desc(), extending
ibmvfc_common_fpin_to_desc() with a severity parameter, negotiating
IBMVFC_CAN_HANDLE_FPIN_EXT / IBMVFC_SUPPORT_FPIN_EXT capabilities, and
adding a KUnit test.

>     scsi: ibmvfc: handle extended FPIN events
>    =20
>     Implement support for extended FPIN messages received via the
>     asynchronous sub-queue, completing full FPIN functionality.
>    =20
>     Extended FPIN messages provide more detailed information about fabric
>     events compared to basic FPIN messages, including specific event type=
s,
>     modifiers, thresholds, event counts, and severity.
>    =20
>     Add ibmvfc_ext_fpin_to_desc() to convert extended FPIN messages from
>     async sub-queue format to fc_els_fpin structures with complete descri=
ptor
>     information. Thread detecting_wwpn (fc_host_port_name()) through
>     ibmvfc_ext_fpin_to_desc() to ibmvfc_common_fpin_to_desc() consistent
>     with ibmvfc_basic_fpin_to_desc() and ibmvfc_full_fpin_to_desc(). Upda=
te
>     ibmvfc_process_async_work() and ibmvfc_handle_async() to zero node_na=
me
>     and dispatch to ibmvfc_ext_fpin_to_desc() when the
>     IBMVFC_ASYNC_IS_FPIN_EXT flag is set.
>    =20
>     Extend ibmvfc_common_fpin_to_desc() with a severity parameter so that
>     extended FPIN events can propagate the severity value from the VIOS w=
hen
>     IBMVFC_FPIN_SEVERITY_VALID is set, rather than always defaulting to
>     FPIN_CONGN_SEVERITY_WARNING. Severity is only carried by the congesti=
on
>     descriptor used for IBMVFC_AE_FPIN_LINK_CONGESTED and
>     IBMVFC_AE_FPIN_CONGESTION_CLEARED; the peer congestion and link
>     integrity descriptors have no severity field, so a severity supplied
>     for the other FPIN statuses is ignored.
>    =20
>     Set the IBMVFC_CAN_HANDLE_FPIN_EXT capability bit (0x800) during login
>     to inform the VIOS that the client can process extended FPIN messages.
>     Add the IBMVFC_CAN_CLS_CRQ_PRE_DMP capability bit (0x400) definition
>     for the intervening protocol-defined capability. Also add the
>     IBMVFC_SUPPORT_FPIN_EXT response capability bit definition used to ga=
te
>     extended FPIN processing.
>    =20
>     In ibmvfc_process_async_work(), use goto to bypass the generic "FPIN
>     event received, unable to process" error message when a more specific
>     diagnostic has already been emitted for invalid or unsupported extend=
ed
>     FPIN events.
>    =20
>     Add a KUnit test, ibmvfc_extended_fpin_test(), that sends extended FP=
IN
>     events through ibmvfc_process_async_work() for each FPIN status with
>     the event types valid for that status, setting only
>     IBMVFC_FPIN_EVENT_TYPE_VALID, and checks that the matching fc_host or
>     rport FPIN statistic is incremented. The test is skipped if no ibmvfc
>     device, online target rport, or IBMVFC_SUPPORT_FPIN_EXT capability is
>     available. It does not exercise the modifier, threshold, severity or
>     event count fields, nor the error paths for a missing
>     IBMVFC_FPIN_EVENT_TYPE_VALID flag or an unadvertised
>     IBMVFC_SUPPORT_FPIN_EXT capability.
>    =20
>     Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>     Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>

[Severity: Low]
This isn't a bug in the code, but does the commit message match the changes
in this patch?

The third paragraph states that this patch updates
ibmvfc_process_async_work() and ibmvfc_handle_async() to zero node_name when
IBMVFC_ASYNC_IS_FPIN_EXT is set, however ibmvfc_handle_async() is untouched
here and zeroing node_name in both functions was already introduced in
commit 6abed589f0fb ("scsi: ibmvfc: extend async event handlers for async
sub-CRQ events").

Conversely, setting severity =3D 0 for IBMVFC_AE_FPIN_PORT_CLEARED and
IBMVFC_AE_FPIN_CONGESTION_CLEARED in ibmvfc_basic_fpin_to_desc() and
ibmvfc_full_fpin_to_desc() is done in this commit, whereas it was described
in the commit message for 6abed589f0fb.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 6e1ecf6891c71..bc65c4d9cb7ec 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -3507,7 +3517,48 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_c=
rq *ibmvfc_fpin,
>  	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, detecting_w=
wpn,
>  					  cpu_to_be64(wwpn), type, cpu_to_be16(0),
>  					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> -					  cpu_to_be32(1));
> +					  cpu_to_be32(1), severity);
> +}
> +
> +/**
> + * ibmvfc_ext_fpin_to_desc(): allocate and populate a struct fc_els_fpin=
 struct
> + * containing a descriptor.
> + * @ibmvfc_fpin:	Pointer to async subq FPIN data
> + * @detecting_wwpn:	WWPN of the local port that detected the event (big-=
endian)
> + * @wwpn:		attached port WWPN (host-endian)
> + *
> + * Allocate a struct fc_els_fpin containing a descriptor and populate
> + * based on data from *ibmvfc_fpin. The caller must have verified that
> + * IBMVFC_FPIN_EVENT_TYPE_VALID is set in the FPIN data flags.
> + *
> + * Return:
> + * NULL     - unable to allocate structure
> + * non-NULL - pointer to populated struct fc_els_fpin
> + */
> +static struct fc_els_fpin *
> +ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin,
> +			__be64 detecting_wwpn, u64 wwpn)
> +{
> +	u8 flags =3D ibmvfc_fpin->fpin_data.flags;
> +	__be32 threshold =3D cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD);
> +	__be16 modifier =3D 0;
> +	__be32 count =3D cpu_to_be32(1);
> +	__be16 type =3D ibmvfc_fpin->fpin_data.event_type;
> +	__u8 severity =3D FPIN_CONGN_SEVERITY_WARNING;
> +
> +	if (flags & IBMVFC_FPIN_MODIFIER_VALID)
> +		modifier =3D ibmvfc_fpin->fpin_data.event_type_modifier;
> +	if (flags & IBMVFC_FPIN_THRESHOLD_VALID)
> +		threshold =3D ibmvfc_fpin->fpin_data.event_threshold;
> +	if (flags & IBMVFC_FPIN_EVENT_COUNT_VALID)
> +		count =3D ibmvfc_fpin->fpin_data.event_data.event_count;
> +	if (flags & IBMVFC_FPIN_SEVERITY_VALID)
> +		severity =3D ibmvfc_fpin->fpin_data.event_data.severity;
> +
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, detecting_w=
wpn,
> +					  cpu_to_be64(wwpn), type,
> +					  modifier, threshold, count,
> +					  severity);
>  }

[Severity: Medium]
Should severity in ibmvfc_ext_fpin_to_desc() default to 0 for cleared
congestion events when IBMVFC_FPIN_SEVERITY_VALID is not set?

In ibmvfc_basic_fpin_to_desc() and ibmvfc_full_fpin_to_desc(), this patch
sets severity =3D 0 for IBMVFC_AE_FPIN_PORT_CLEARED and
IBMVFC_AE_FPIN_CONGESTION_CLEARED:

	case IBMVFC_AE_FPIN_PORT_CLEARED:
	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
		type =3D cpu_to_be16(FPIN_CONGN_CLEAR);
		severity =3D 0;
		break;

In ibmvfc_ext_fpin_to_desc(), severity is initialized to
FPIN_CONGN_SEVERITY_WARNING and is only updated if
IBMVFC_FPIN_SEVERITY_VALID is set in flags. When an extended FPIN event for
IBMVFC_AE_FPIN_CONGESTION_CLEARED (or with event_type FPIN_CONGN_CLEAR) is
received without the optional IBMVFC_FPIN_SEVERITY_VALID flag (as in
ibmvfc_extended_fpin_test()), cdesc->severity in the ELS FPIN descriptor is
populated with FPIN_CONGN_SEVERITY_WARNING instead of 0.

> @@ -3624,14 +3681,30 @@ VISIBLE_IF_KUNIT void ibmvfc_process_async_work(s=
truct work_struct *work)
>  		goto free;
>  	}
> =20
> -	if (crq)
> +	if (crq) {
>  		fpin =3D ibmvfc_basic_fpin_to_desc(crq,
>  				cpu_to_be64(fc_host_port_name(vhost->host)),
>  				tgt->wwpn);
> -	else
> -		fpin =3D ibmvfc_full_fpin_to_desc(subq,
> -				cpu_to_be64(fc_host_port_name(vhost->host)),
> -				tgt->wwpn);
> +	} else {
> +		sqfpin =3D (struct ibmvfc_async_subq_fpin *)subq;
> +		if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) =3D=3D 0) {
> +			fpin =3D ibmvfc_full_fpin_to_desc(subq,
> +					cpu_to_be64(fc_host_port_name(vhost->host)),
> +					tgt->wwpn);
> +		} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
> +			dev_err_ratelimited(vhost->dev,
> +					    "Invalid extended FPIN event received\n");
> +			goto skip_generic_error;
> +		} else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
> +			dev_err_ratelimited(vhost->dev,
> +					    "Unexpected extended FPIN event received\n");
> +			goto skip_generic_error;
> +		} else {
> +			fpin =3D ibmvfc_ext_fpin_to_desc(sqfpin,
> +					cpu_to_be64(fc_host_port_name(vhost->host)),
> +					tgt->wwpn);
> +		}
> +	}

[Severity: High]
What happens in ibmvfc_process_async_work() when a host-scope FPIN event
(IBMVFC_AE_FPIN_LINK_CONGESTED or IBMVFC_AE_FPIN_CONGESTION_CLEARED) arrives
on the async sub-CRQ with wwpn =3D=3D 0 or with a WWPN that does not match a
target in scsi_scrqs or nvme_scrqs?

Earlier in ibmvfc_process_async_work(), when aw->event.type =3D=3D
IBMVFC_ASYNC_CRQ_SUB and IBMVFC_ASYNC_IS_FPIN_EXT is set, scsi_id,
node_name, and assoc_id are all set to 0, while crq remains NULL:

	if (aw->event.type =3D=3D IBMVFC_ASYNC_CRQ_SUB) {
		subq =3D &aw->event.subq;
		scsi_id =3D 0;
		wwpn =3D subq->wwpn;
		fpin_status =3D subq->fpin_status;
		if (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) {
			node_name =3D 0;
			assoc_id =3D subq->id.assoc_id;
		} else if (subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) {
			node_name =3D 0;
			assoc_id =3D 0;
		} else {
			node_name =3D subq->id.node_name;
			assoc_id =3D 0;
		}
	}

If wwpn is also 0, the zero-identifier check right after that is taken:

	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
		if (fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
		    fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
			fpin =3D ibmvfc_basic_fpin_to_desc(crq,
					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
		goto send_fpin;
	}

Here crq is NULL, so ibmvfc_basic_fpin_to_desc(crq, ...) dereferences
crq->fpin_status on a NULL pointer.

In addition, if wwpn is non-zero (for example, set to the host's own WWPN or
a target whose rport/nvme_remote_port is no longer present) so
ibmvfc_find_target() returns NULL, the fallback path only calls
ibmvfc_basic_fpin_to_desc() or ibmvfc_full_fpin_to_desc():

	} else {
		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
		if (fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
		    fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED) {
			if (crq)
				fpin =3D ibmvfc_basic_fpin_to_desc(crq,
						cpu_to_be64(fc_host_port_name(vhost->host)), 0);
			else
				fpin =3D ibmvfc_full_fpin_to_desc(subq,
						cpu_to_be64(fc_host_port_name(vhost->host)), 0);
			goto send_fpin;
		}

Because IBMVFC_ASYNC_IS_FPIN_EXT and ibmvfc_ext_fpin_to_desc() are only
handled on the tgt !=3D NULL path, shouldn't the zero-identifier and
target-not-found host-scope paths also handle subq and
IBMVFC_ASYNC_IS_FPIN_EXT?

>  send_fpin:
>  	if (fpin) {
> @@ -3642,6 +3715,7 @@ VISIBLE_IF_KUNIT void ibmvfc_process_async_work(str=
uct work_struct *work)
>  	} else
>  		dev_err_ratelimited(vhost->dev, "FPIN event received, unable to proces=
s\n");
> =20
> + skip_generic_error:
>  	if (tgt)
>  		kref_put(&tgt->kref, ibmvfc_release_tgt);
>   free:

[Severity: Critical]
Can tgt be uninitialized when reaching kref_put(&tgt->kref,
ibmvfc_release_tgt) in ibmvfc_process_async_work()?

At the top of ibmvfc_process_async_work(), tgt is declared without being
initialized to NULL:

	struct ibmvfc_target *tgt;

When all target identifiers are zero (!scsi_id && !wwpn && !node_name &&
!assoc_id, such as for host-scope FPIN events or the zero-identifier test
cases in ibmvfc_async_fpin_test()), the function jumps to send_fpin before
tgt is assigned by ibmvfc_find_target():

	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
		if (fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
		    fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
			fpin =3D ibmvfc_basic_fpin_to_desc(crq,
					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
		goto send_fpin;
	}

After send_fpin, execution falls through to skip_generic_error and checks
if (tgt) kref_put(&tgt->kref, ibmvfc_release_tgt) using the uninitialized
tgt pointer on the stack. Should tgt be initialized to NULL at declaration?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-ibmvfc-fpi=
n-support-v18-0-d683b74736a3@linux.ibm.com?part=3D13
