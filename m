Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069239;
	b=EbDVh/fD6P1/tEf3NkLHX/XyOWK4BJqJB9zcr7t28e97K4ZyEFjI42JX84ce4HjSFq9E
	 /wdXjAoZFgitTLZ7Qy8zs6vc13KIVcJHLT5w9YnS959wR2HR6c1HrY2jkE1ndyCBgiBii
	 5aHFo+gK4SK2+SsGsS4rZLcld8EmfI5pSLYfPGjmchCKqqr0CWeG47u1KDhsNSPpgHUin
	 Dhk+rqT+XdBbE1B8nXlH2YFhr7qyMrbK195uC9ZpZiH2q0RBoIkNDbs9Dnn3DKdlm5wGG
	 amnyvN/g233je+a5yC3JTq8V+VspURYQ/AbSNkDPY63nFdeKIDT3NfWqhy9/NaquARA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069239;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PfHk1rmAOZii0RHxFmZrXwUlIOnbK8wqojEpr+Lt8YA=;
	b=VysYKCUfuC27ivmTB4V9MOty+pNij2SpYyFuawBc8L7iBWg10i9ny50sU6pDj7YrfM9f
	 5d7rI57A+1B+VyYlx6ADVXV8naYcKMlKvUXl9CGH3GT/drBd3MyQQtgM1vu9kDu0nTkkB
	 z7sgMY9RHsD3yWtgNhTpYzN79zOPOc/aPdZZ8w+3xqh1DuPrv1Q0dpHIXn1UwzU8N/0dw
	 e9BwpCk2UlKA85xqfy9LijClwzSze6niiE24K05RTxn0ep/lFJIQHYmTjH1aY5qkV0S9z
	 8enMGAuCDc1WgOG1z9S5R6ZOVOMLJIMLPauyXLOGbQLS/nnPFWbX9zpcfYO5Tg+0viw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aVJV2pHr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F3F606A32C
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aVJV2pHr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3201F0089F;
	Sat,  7 Nov 2026 16:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794069238;
	bh=PfHk1rmAOZii0RHxFmZrXwUlIOnbK8wqojEpr+Lt8YA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aVJV2pHr/LiDKDLCM7msi79RiTBMX2j8fNF87h56L+25MOv02O0+U/Nu73Jk2f1/8
	 HmoliZ5iQ1+Ow8Y7Mo4GVLEsdJB6maPw4yfJNq9ivn4ite7H2bZiqmXEiekQBz91dI
	 +Or773NNmKcKDiqM2ffzMSEsU07se3lAnI1IRxqwllLcZpdxpcRFjd9+HHppafHNgn
	 fXXapZKMhyqB8bDAUz2aBqYD5Jrvw27/50eDd89t6K+AxHToyCl6spyQ2CxRLRJQb6
	 ZlU8IZHflYtUwQSnhEyMrC8tCesp0yOCog/9UVVK9m0civWLNaM2kktGD+T4WQnPa/
	 9YbQHiNT8VOsA==
Message-ID: <sashiko-outbox-203061@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] scsi: lpfc: Return MBX status when a non-polled
 mbox cannot be issued
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261107161655.2628796-3-vulab@iscas.ac.cn>
References: <CAEQnVQn7fpgpm5zY=8ne0G5M_KXWg4qjecMK6smk-q+_0j1PEw@mail.gmail.com>
 <20261107161655.2628796-1-vulab@iscas.ac.cn>
 <20261107161655.2628796-3-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 16:33:58 +0000
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
- [High] scsi: lpfc: wrong MBX status in lpfc_sli_issue_mbox_s4() for
  MBX_NOWAIT
- [Low] scsi: lpfc: missing Fixes trailer for commit da0436e915a5
--

commit f038148a081f8cf95b1d6a94df61cce938e8192e
Author: Wentao Liang <vulab@iscas.ac.cn>

> scsi: lpfc: Return MBX status when a non-polled mbox cannot be issued
>
> lpfc_sli_issue_mbox_s4() reports a failure to hand a command to the port
> with an MBX status code in every path except one: when interrupts are not
> enabled and the caller asked for MBX_NOWAIT, it returns -EIO.  A negative
> errno does not belong in that code space, and a caller has no MBX value to
> test for this outcome.
>
> Return MBXERR_ERROR, as lpfc_sli4_post_sync_mbox() already does for a
> command it cannot post.  lpfc_issue_lip() maps MBXERR_ERROR to -EIO, and
> the bsg mailbox path now converts a failure of its own, so no positive
> status is handed to a caller that expects an errno.
>
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

[Severity: Low]
This fixes the -EIO return value introduced with SLI-4 mailbox support.
Should it include a Fixes tag?

  Fixes: da0436e915a5 ("[SCSI] lpfc 8.3.2 : Addition of SLI4 Interface - Ba=
se Support")

> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 715b328d3d184..05a76b00702a8 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -10121,7 +10121,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPF=
C_MBOXQ_t *mboxq,
>  		if (flag =3D=3D MBX_POLL)
>  			rc =3D lpfc_sli4_post_sync_mbox(phba, mboxq);
>  		else
> -			rc =3D -EIO;
> +			rc =3D MBXERR_ERROR;
>  		if (rc !=3D MBX_SUCCESS)
>  			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
>  					"(%d):2541 Mailbox command x%x "

[Severity: High]
Should this return MBX_NOT_FINISHED instead of MBXERR_ERROR when an
MBX_NOWAIT command cannot be issued?

All other pre-enqueue failure paths for asynchronous commands in
lpfc_sli_issue_mbox_s4() (and the equivalent interrupt-disabled check in
lpfc_sli_issue_mbox_s3()) return MBX_NOT_FINISHED, whereas MBXERR_ERROR is
used for synchronous MBX_POLL commands in lpfc_sli4_post_sync_mbox().
Callers of lpfc_sli_issue_mbox() with MBX_NOWAIT check specifically for
MBX_NOT_FINISHED to detect that the command was not queued:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli4_resume_rpi() {
	...
	rc =3D lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
	if (rc =3D=3D MBX_NOT_FINISHED) {
		...
		lpfc_nlp_put(ndlp);
		mempool_free(mboxq, phba->mbox_mem_pool);
		return -EIO;
	}
	return 0;
}

When interrupts are disabled (for example after lpfc_stop_port_s4()) and
MBXERR_ERROR is returned, callers treat the unqueued command as accepted.
Because its completion handler never runs, mboxq, DMA buffers, and ndlp
references are leaked, and callers such as lpfc_get_sfp_info_wait() via
sysfs lpfc_xcvr_data treat the unposted zeroed mailbox as having succeeded.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107161655.2628=
796-1-vulab@iscas.ac.cn?part=3D3
