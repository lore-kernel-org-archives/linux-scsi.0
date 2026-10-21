Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579167;
	b=MzakqBfvptKb1bAQMb5evMWiAQvxa3Czoyx1W3E1Uzba9FFOWMMt84LVd85U5fxv8oeT
	 L2K4+hMwXpIP42K6lY3PaALSp/OhgBmiToo7A2tqo4Cejl52LMs945pCdPARX7MAyquF0
	 7hDoJdNuPSWOIkpisTVfTFKA10fahe+p1jYu+tDgrEM+76KA6M7MlzRqZwQ7e+yDlnofx
	 gG+w4JuVErjDjEw0kHp1Y1wsvOqmgKPwvFkJ3/c0l6WxtRfIu1azkCqg5v9X2Xlep6+JV
	 nyrfXLCvg7fCKeJMuWPGzDN0ar7IGgVDf6dxaeDuOizUX1YpkOKOUXvwOikve3U7FJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579167;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G3lc/H2KIWpedu+lRK9IGL4rv6k3TwRgeFXOxzdi710=;
	b=Zq+H2OoHP0xNG+/CVJ4ng8qM5AEnnczqGzDnXVyfrYoIpfQqWCWy5PROCnRVMAs2y7oK
	 dnFOhHVaNGrJlihGsmV4cTqS+4OooUEaduKVh/QMpfskHfeO8PH7oLLK/dAxDwyqWKp6f
	 KZXsEh2P7dJSTL5XFDrbfTgY0NPUAyar3VSGyTAjJTwKJoWgpg1ADH6SWlZjQIGfTjtnL
	 ze9J6092cLfIxQLG3vI2WasFARyEw+3Jq+EDYuvI9VbSquNf8r/cg2RWuF1Nyk6sQ/M6I
	 zZ9IGQgezcZ1ynHyg5myDymxuk9d7OB1Sn+XbCZAeTFb260q5CBF/bEnKAYMrck9sAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=neT+Gj3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B22D606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=neT+Gj3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF5F1F000CA;
	Wed, 21 Oct 2026 10:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579166;
	bh=G3lc/H2KIWpedu+lRK9IGL4rv6k3TwRgeFXOxzdi710=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=neT+Gj3D0nBltKANKpAPW/rM6YaG2voLTb3owa4kSaJkraBnUlq5ZxuA6qmPwLiQ6
	 KLNFQVfN7ZgluSh8y8MWPw8m0w053zg3GsHmchVBvC25byan5ktnvWaZFujVon0VaA
	 C62aAhzhSF+noOBo37gdGRdXnS9NtQ/y/S6uP6QTKTGTKlZsdjtZ+pd7MPciswC7a8
	 c/o4HHmAvpr5i+XmM6aw56VRKqbxdTRE3kjLcYW4MpZauDQMXzcL0X56YaC9XA4ylX
	 7CNMcsrOcKQSLcEd2v1dTAgEJXWEYWZ4SZq0ZpOJsH/wGXb2j+MmNYJ7zLxBNAn7AO
	 uOTS5kxV/y4uQ==
Message-ID: <sashiko-outbox-180110@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/14] Revert "scsi: qla2xxx: Validate BSG request_len
 before reading vendor_cmd[]"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021102310.3854868-4-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
 <20261021102310.3854868-4-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:39:26 +0000
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
- [High] scsi: qla2xxx: unchecked request_len in qla2x00_process_vendor_spe=
cific()
--

commit e8eddc274aa704e6e53be86fa33bbd27ed747026
Author: Nilesh Javali <njavali@marvell.com>

Revert "scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]"

This commit reverts commit 4cf38dd9465736141263ebb63375868311a0ec81, which
added bsg_job->request_len validation before reading elements of
vendor_cmd[] in drivers/scsi/qla2xxx/qla_bsg.c, because those checks
rejected legitimate requests from the qaucli management utility.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index ab559048dbb82..19a514a153aef 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -160,12 +160,6 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_jo=
b)
>  		goto exit_fcp_prio_cfg;
>  	}
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t)) {
> -		ret =3D -EINVAL;
> -		goto exit_fcp_prio_cfg;
> -	}
> -
>  	/* Get the sub command */
>  	oper =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
> =20
> @@ -764,10 +758,6 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
>  		return -EIO;
>  	}
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + 3 * sizeof(uint32_t))
> -		return -EINVAL;
> -
>  	memset(&elreq, 0, sizeof(elreq));
> =20
>  	elreq.req_sg_cnt =3D dma_map_sg(&ha->pdev->dev,
> @@ -1000,10 +990,6 @@ qla84xx_reset(struct bsg_job *bsg_job)
>  		return -EINVAL;
>  	}
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
> -		return -EINVAL;
> -
>  	flag =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
> =20
>  	rval =3D qla84xx_reset_chip(vha, flag =3D=3D A84_ISSUE_RESET_DIAG_FW);
> @@ -1048,10 +1034,6 @@ qla84xx_updatefw(struct bsg_job *bsg_job)
>  		return -EINVAL;
>  	}
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
> -		return -EINVAL;
> -
>  	sg_cnt =3D dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
>  		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
>  	if (!sg_cnt) {
> @@ -1529,15 +1511,9 @@ qla2x00_read_optrom(struct bsg_job *bsg_job)
>  	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
>  	scsi_qla_host_t *vha =3D shost_priv(host);
>  	struct qla_hw_data *ha =3D vha->hw;
> -	uint32_t start;
> +	uint32_t start =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
>  	int rval =3D 0;
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
> -		return -EINVAL;
> -
> -	start =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
> -
>  	if (ha->flags.nic_core_reset_hdlr_active)
>  		return -EBUSY;
> =20
> @@ -1580,15 +1556,9 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
>  	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
>  	scsi_qla_host_t *vha =3D shost_priv(host);
>  	struct qla_hw_data *ha =3D vha->hw;
> -	uint32_t start;
> +	uint32_t start =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
>  	int rval =3D 0;
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
> -		return -EINVAL;
> -
> -	start =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
> -
>  	mutex_lock(&ha->optrom_mutex);
>  	rval =3D qla2x00_optrom_setup(bsg_job, vha, start, 1);
>  	if (rval) {
> @@ -2453,11 +2423,6 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
>  	struct fc_port *fcport;
>  	char  *type =3D "FC_BSG_HST_FX_MGMT";
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + sizeof(uint32_t) +
> -	    sizeof(struct qla_mt_iocb_rqst_fx00))
> -		return -EINVAL;
> -
>  	/* Copy the IOCB specific information */
>  	piocb_rqst =3D (struct qla_mt_iocb_rqst_fx00 *)
>  	    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
> @@ -3379,13 +3344,6 @@ qla2x00_process_vendor_specific(struct scsi_qla_ho=
st *vha, struct bsg_job *bsg_j
>  {
>  	struct fc_bsg_request *bsg_request =3D bsg_job->request;
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + sizeof(uint32_t)) {
> -		ql_log(ql_log_warn, vha, 0x7000,
> -		       "BSG request too small for vendor cmd.\n");
> -		return -EINVAL;
> -	}
> -
>  	ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=3D0x%x\n",
>  	    __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
> =20

[ ... ]

> @@ -3842,10 +3797,6 @@ static int qla28xx_validate_flash_image(struct bsg=
_job *bsg_job)
>  	if (!IS_QLA28XX(ha) || vha->vp_idx !=3D 0)
>  		return -EPERM;
> =20
> -	if (bsg_job->request_len <
> -	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
> -		return -EINVAL;
> -
>  	mutex_lock(&ha->optrom_mutex);
>  	rval =3D qla28xx_do_validate_flash_image(bsg_job, &state);
>  	if (rval)

[Severity: High]
Does removing all of these bsg_job->request_len checks without a replacement
reintroduce out-of-bounds heap reads of
bsg_request->rqst_data.h_vendor.vendor_cmd[]?

In block/bsg-lib.c, bsg_transport_sg_io_fn() allocates job->request with the
exact user-supplied hdr->request_len:

    job->request =3D memdup_user(uptr64(hdr->request), hdr->request_len);

In drivers/scsi/scsi_transport_fc.c, fc_bsg_host_dispatch() only checks
job->request_len < sizeof(uint32_t) before matching FC_BSG_HST_VENDOR and
checking vendor_id, without verifying that job->request_len covers any
elements of the flexible array rqst_data.h_vendor.vendor_cmd[].

Without length checks in drivers/scsi/qla2xxx/qla_bsg.c, a short
FC_BSG_HST_VENDOR request (for example 12 or 16 bytes) can read past the end
of bsg_job->request in:

- qla2x00_process_vendor_specific(), which reads vendor_cmd[0] (bytes 12..1=
5)
- qla24xx_proc_fcp_prio_cfg_cmd(), qla84xx_reset(), qla84xx_updatefw(),
  qla2x00_read_optrom(), qla2x00_update_optrom(), and
  qla28xx_validate_flash_image() -> qla28xx_do_validate_flash_image(), which
  read vendor_cmd[1] (bytes 16..19)
- qla2x00_process_loopback(), which reads vendor_cmd[1] and vendor_cmd[2]
  (bytes 16..23) later in the function:

	elreq.options =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
	elreq.iteration_count =3D
	    bsg_request->rqst_data.h_vendor.vendor_cmd[2];

- qlafx00_mgmt_cmd(), which overlays and reads the 32-byte
  struct qla_mt_iocb_rqst_fx00 starting at vendor_cmd[1] (bytes 16..47)

Commit 4cf38dd9465736141263ebb63375868311a0ec81 over-estimated the header
size by 8 bytes because sizeof(struct fc_bsg_request) is 20 bytes (sized by
the 16-byte h_ct union member), whereas
offsetof(struct fc_bsg_request, rqst_data.h_vendor.vendor_cmd) is 12 bytes.

Could these checks be updated to use
offsetof(struct fc_bsg_request, rqst_data.h_vendor.vendor_cmd) as the base
offset instead of reverting them completely, so that qaucli requests succeed
while still preventing out-of-bounds reads of vendor_cmd[]?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021102310.3854=
868-1-njavali@marvell.com?part=3D3
