Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751589;
	b=hecCWbPcKzBtifzQwnd5fpCjXCJ+qtGTh1zSa7jyIxi+9Pd/Se7z6cPjAjObOiub9q/Q
	 Vwtvz1mGpa3y77tPHyMBNwh+bbfMnJrPlfZslrQbWBZJ8z9IAVScrGRHC+LPhKCqavsi7
	 yZ/QV4yePKIpyCnbbaRmqpJ9SylqYjbSWjtSEbybm6cHYJHVRqBtCS29Sws17GgYUWd71
	 qk2TATt/7KTUHHA8RphOHqPO+qGIqdAU3EEGb9RZbmLqc/ajjd8dZSE0fEZaioWCW1AwG
	 YUc9ie+XSD/hypW4/XIGdv27x2bQJxoTRBtxJUL0hYDG5b0+t7+mrsEPcZK31l4hrng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751589;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TAScKY+I+gH7l4k+QvZCADTsccCEwwOGLI4QPVZdWGs=;
	b=5QbD1Crcx8ZxOWHNciS9POzmye76hlJeNo/YIa6vLHytlT41pi68XEej++MS4F46JKBG
	 nAeBQaUblxI6YDh+ap4JvT1OS4MGzk9MySQKUCqQVzMWXfdQKsk2fVl18IGaSqbKS/Vy+
	 XWRxy8jiAJsnoKmRIa35PQV2Eo+jVFRcJm/4P7OlYX/IDGhc5OhyACf8/1bg3k6dpKAGm
	 XePXV8N9MVQSVQjyEjjoUorY9KVD8hA8i7iLf+OzP4Gd83lUbVZCLPqt6gNHyjPbPaerS
	 guruhfNGPdAxbwYA3Zhr1vSiFJuKM8/LHaKuK1nTNq+syB6wTS0TTT2g9aZribKk27Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0hEijPu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B51F606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0hEijPu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877F41F01825;
	Fri, 23 Oct 2026 10:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792751588;
	bh=TAScKY+I+gH7l4k+QvZCADTsccCEwwOGLI4QPVZdWGs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f0hEijPu8GKBFoaA2GLzQp0PFHAnfXdcxcxZiJzKrKdt000glDXD/kAk79+9l9azl
	 JVcIu3Uj9HViZ1DUfB6kd4F8A+X1am5wMpn3hmovWZTSAp2/vsvNpufssGXgxxFLPA
	 4xlIsfLpMy4HWnjBHFhb1TL0Tk3mSwMrjglLRpOuME9sYJFo6Mn/ugAgvW7+xZmVMc
	 2wUUufUFYlKbMXVCrTTVSXd0unO7n4Ld+Q7/6PQz/5do0AQPhLDHcgFWEeijBZPH8r
	 lQbZ7dEOvKEUyLMKzrEjl4M8zFaYNsJUk7M87NmjCdTZu8HfvDayZ0e7yxsqA5hJkR
	 3VlzHLtJdQK6g==
Message-ID: <sashiko-outbox-182690@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/13] Revert "scsi: qla2xxx: Validate BSG
 request_len before reading vendor_cmd[]"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023101600.1431179-4-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
 <20261023101600.1431179-4-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:33:08 +0000
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
- [High] scsi: qla2xxx: unchecked vendor_cmd[0] read in qla24xx_bsg_request=
()
- [High] scsi: qla2xxx: out-of-bounds vendor_cmd[] reads on short BSG reque=
sts
--

commit 6dca3d90086c395d6e304de559abf4c8c863ad1f
Author: Nilesh Javali <njavali@marvell.com>

Revert "scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]"

This commit reverts commit 4cf38dd9465736141263ebb63375868311a0ec81 to
restore FC_BSG_HST_VENDOR handling for the Marvell qaucli management utilit=
y,
which passes a request_len smaller than sizeof(struct fc_bsg_request) plus
the vendor_cmd words checked by that commit.

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

[Severity: High]
Does removing all of the request_len checks reintroduce out-of-bounds heap
reads of bsg_request->rqst_data.h_vendor.vendor_cmd[] when userspace submits
a short FC_BSG_HST_VENDOR request?

In bsg_transport_sg_io_fn(), job->request is allocated with the exact
user-supplied hdr->request_len:

block/bsg-lib.c:bsg_transport_sg_io_fn() {
    ...
    job->request_len =3D hdr->request_len;
    job->request =3D memdup_user(uptr64(hdr->request), hdr->request_len);
    ...
}

And fc_bsg_host_dispatch() only verifies that job->request_len is at least
sizeof(uint32_t) (4 bytes) before calling into qla24xx_bsg_request() ->
qla2x00_process_vendor_specific().

In struct fc_bsg_request, rqst_data is a union whose total size is 16 bytes
(sized by struct fc_bsg_host_ct), making sizeof(struct fc_bsg_request) 20
bytes. However, struct fc_bsg_host_vendor only has an 8-byte vendor_id befo=
re
the flexible array vendor_cmd[]:

include/uapi/scsi/scsi_bsg_fc.h:
    struct fc_bsg_host_vendor {
        __u64 vendor_id;
        __u32 vendor_cmd[];
    };

So offsetof(struct fc_bsg_request, rqst_data.h_vendor.vendor_cmd) is 12
bytes, meaning vendor_cmd[0] is at bytes 12..15 and vendor_cmd[1] is at byt=
es
16..19 (both within a 20-byte struct fc_bsg_request). Commit 4cf38dd94657
rejected 20-byte qaucli requests because it checked against
sizeof(struct fc_bsg_request) + N * sizeof(uint32_t) (20 + 4*N) rather than
offsetof(struct fc_bsg_request, rqst_data.h_vendor.vendor_cmd) +
N * sizeof(uint32_t) (12 + 4*N).

Without bounds checks anchored at offsetof(struct fc_bsg_request,
rqst_data.h_vendor.vendor_cmd), short requests read past the end of
bsg_job->request in:
- qla2x00_process_vendor_specific() reading vendor_cmd[0]
- qla24xx_proc_fcp_prio_cfg_cmd(), qla84xx_reset(), qla84xx_updatefw(),
  qla2x00_read_optrom(), qla2x00_update_optrom(), and
  qla28xx_validate_flash_image() -> qla28xx_do_validate_flash_image()
  reading vendor_cmd[1]
- qla2x00_process_loopback() reading vendor_cmd[1] and vendor_cmd[2]
- qlafx00_mgmt_cmd() overlaying a 36-byte struct qla_mt_iocb_rqst_fx00 at
  &vendor_cmd[1]

> @@ -3529,11 +3487,8 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
>  	}
> =20
>  	/* Disable port will bring down the chip, allow enable command */
> -	if (bsg_request->msgcode =3D=3D FC_BSG_HST_VENDOR &&
> -	    bsg_job->request_len >=3D
> -		sizeof(struct fc_bsg_request) + sizeof(uint32_t) &&
> -	    (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_MANAGE=
_HOST_PORT ||
> -	     bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_GET_HO=
ST_STATS))
> +	if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_MANAGE_=
HOST_PORT ||
> +	    bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_GET_HOS=
T_STATS)
>  		goto skip_chip_chk;

[Severity: High]
In qla24xx_bsg_request(), does dropping the bsg_request->msgcode =3D=3D
FC_BSG_HST_VENDOR check and length check cause bsg_request->rqst_data.h_ven=
dor.vendor_cmd[0]
to be read unconditionally on every BSG request, including non-vendor
requests?

In struct fc_bsg_request, rqst_data is a union:

include/uapi/scsi/scsi_bsg_fc.h:
    struct fc_bsg_request {
        __u32 msgcode;
        union {
            struct fc_bsg_host_add_rport    h_addrport;
            struct fc_bsg_host_del_rport    h_delrport;
            struct fc_bsg_host_els          h_els;
            struct fc_bsg_host_ct           h_ct;
            struct fc_bsg_host_vendor       h_vendor;

            struct fc_bsg_rport_els         r_els;
            struct fc_bsg_rport_ct          r_ct;
        } rqst_data;
    } __attribute__((packed));

Because rqst_data.h_vendor.vendor_cmd[0] is at byte offset 12..15:

1. For legitimate non-vendor BSG requests smaller than 16 bytes, such as
   FC_BSG_RPT_ELS (where msgcode + struct fc_bsg_rport_els is 5 bytes) or
   FC_BSG_HST_ELS_NOLOGIN (where msgcode + struct fc_bsg_host_els is 8 byte=
s),
   reading vendor_cmd[0] reads past the end of the bsg_job->request buffer
   allocated by memdup_user().

2. For FC_BSG_HST_CT and FC_BSG_RPT_CT requests, bytes 12..15 alias
   rqst_data.h_ct.preamble_word1 and rqst_data.r_ct.preamble_word2. If that
   field happens to equal QL_VND_MANAGE_HOST_PORT (0x26) or
   QL_VND_GET_HOST_STATS (0x24), qla24xx_bsg_request() jumps to skip_chip_c=
hk
   and bypasses the port_isolated, qla2x00_chip_is_down(vha), and
   PFLG_DRIVER_REMOVING checks:

drivers/scsi/qla2xxx/qla_bsg.c:qla24xx_bsg_request() {
    ...
    if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_MANAGE_=
HOST_PORT ||
        bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_GET_HOS=
T_STATS)
        goto skip_chip_chk;

    if (vha->hw->flags.port_isolated) {
        bsg_reply->result =3D DID_ERROR;
        /* operation not permitted */
        return -EPERM;
    }

    if (qla2x00_chip_is_down(vha)) {
        ...
        return -EBUSY;
    }

    if (test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags)) {
        SET_DID_STATUS(bsg_reply->result, DID_ERROR);
        return -EIO;
    }

skip_chip_chk:
    ...
}

Should qla24xx_bsg_request() retain the bsg_request->msgcode =3D=3D
FC_BSG_HST_VENDOR check along with a check that bsg_job->request_len >=3D
offsetof(struct fc_bsg_request, rqst_data.h_vendor.vendor_cmd) +
sizeof(uint32_t)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023101600.1431=
179-1-njavali@marvell.com?part=3D3
