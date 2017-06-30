From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH][scsi-next] scsi: qla2xxx: fix a bunch of typos and
 spelling mistakes
Date: Fri, 30 Jun 2017 23:24:29 +0000
Message-ID: <C8A2637E-B0EC-488E-9939-68CBCD857899@cavium.com>
References: <20170630134741.13965-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0044.outbound.protection.outlook.com ([104.47.42.44]:31815
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751189AbdF3XYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 19:24:32 -0400
In-Reply-To: <20170630134741.13965-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <A5A57490534A394689073374BA39E3CE@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


> On Jun 30, 2017, at 6:47 AM, Colin King <colin.king@canonical.com> wrote:
>=20
> From: Colin Ian King <colin.king@canonical.com>
>=20
> Fix the following typos/spelling mistakes:
>=20
> "attribure" -> "attribute"
> "suppored" -> "supported"
> "Symobilic" -> "Symbolic"
> "iteself" -> "itself"
> "reqeust" -> "request"
> "nvme_wait_on_comand" -> "nvme_wait_on_command"
> "bount" -> "bound"
> "captrue_mask" -> "capture_mask"
> "tempelate" -> "template"
>=20
> ..and also unwrap a line to fix a checkpatch warning.
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c | 2 +-
> drivers/scsi/qla2xxx/qla_bsg.c  | 2 +-
> drivers/scsi/qla2xxx/qla_init.c | 2 +-
> drivers/scsi/qla2xxx/qla_isr.c  | 3 +--
> drivers/scsi/qla2xxx/qla_mbx.c  | 2 +-
> drivers/scsi/qla2xxx/qla_nvme.c | 4 ++--
> drivers/scsi/qla2xxx/qla_nx.c   | 4 ++--
> drivers/scsi/qla2xxx/qla_nx2.c  | 2 +-
> 8 files changed, 10 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 6dd984203666..08a1feb3a195 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -929,7 +929,7 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t *vha)
> 			    iter->name, ret);
> 		else
> 			ql_dbg(ql_dbg_init, vha, 0x00f4,
> -			    "Successfully created sysfs %s binary attribure.\n",
> +			    "Successfully created sysfs %s binary attribute.\n",
> 			    iter->name);
> 	}
> }
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index e093795a0371..2ea0ef93f5cb 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -293,7 +293,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
> 	if (bsg_job->request_payload.sg_cnt > 1 ||
> 		bsg_job->reply_payload.sg_cnt > 1) {
> 		ql_dbg(ql_dbg_user, vha, 0x7002,
> -		    "Multiple SG's are not suppored for ELS requests, "
> +		    "Multiple SG's are not supported for ELS requests, "
> 		    "request_sg_cnt=3D%x reply_sg_cnt=3D%x.\n",
> 		    bsg_job->request_payload.sg_cnt,
> 		    bsg_job->reply_payload.sg_cnt);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 8a5f5ef069ae..072ad1aa5505 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4660,7 +4660,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
> 			} else if (qla2x00_rsnn_nn(vha)) {
> 				/* EMPTY */
> 				ql_dbg(ql_dbg_disc, vha, 0x209b,
> -				    "Register Symobilic Node Name failed.\n");
> +				    "Register Symbolic Node Name failed.\n");
> 				if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
> 					break;
> 			}
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 011faa1dc618..6c6e624a5aa6 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -432,8 +432,7 @@ qla83xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_=
t *mb)
> 			    "Register: 0x%x%x.\n", mb[7], mb[3]);
> 			if (err_level =3D=3D ERR_LEVEL_NON_FATAL) {
> 				ql_log(ql_log_warn, vha, 0x5063,
> -				    "Not a fatal error, f/w has recovered "
> -				    "iteself.\n");
> +				    "Not a fatal error, f/w has recovered itself.\n");
> 			} else if (err_level =3D=3D ERR_LEVEL_RECOVERABLE_FATAL) {
> 				ql_log(ql_log_fatal, vha, 0x5064,
> 				    "Recoverable Fatal error: Chip reset "
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 0764b6172ed1..7c6d1a404011 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3893,7 +3893,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
> 		rval =3D QLA_FUNCTION_FAILED;
> 	} else if (vce->comp_status !=3D cpu_to_le16(CS_COMPLETE)) {
> 		ql_dbg(ql_dbg_mbx, vha, 0x10c5,
> -		    "Failed to complet IOCB -- completion status (%x).\n",
> +		    "Failed to complete IOCB -- completion status (%x).\n",
> 		    le16_to_cpu(vce->comp_status));
> 		rval =3D QLA_FUNCTION_FAILED;
> 	} else {
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 1da8fa8f641d..53e58e9daba8 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -489,7 +489,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_por=
t *lport,
> 	struct nvme_private *priv;
>=20
> 	if (!fd) {
> -		ql_log(ql_log_warn, NULL, 0x2134, "NO NVMe FCP reqeust\n");
> +		ql_log(ql_log_warn, NULL, 0x2134, "NO NVMe FCP request\n");
> 		return rval;
> 	}
>=20
> @@ -626,7 +626,7 @@ void qla_nvme_abort(struct qla_hw_data *ha, srb_t *sp=
)
> 	if (!rval) {
> 		if (!qla_nvme_wait_on_command(sp))
> 			ql_log(ql_log_warn, NULL, 0x2112,
> -			    "nvme_wait_on_comand timed out waiting on sp=3D%p\n",
> +			    "nvme_wait_on_command timed out waiting on sp=3D%p\n",
> 			    sp);
> 	}
> }
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.=
c
> index 0a1723cc08cf..a77c33987703 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -782,7 +782,7 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
> 		(qla82xx_pci_is_same_window(ha, off + size - 1) =3D=3D 0)) {
> 		write_unlock_irqrestore(&ha->hw_lock, flags);
> 		ql_log(ql_log_fatal, vha, 0xb009,
> -		    "%s out of bount memory "
> +		    "%s out of bound memory "
> 		    "access, offset is 0x%llx.\n",
> 		    QLA2XXX_DRIVER_NAME, off);
> 		return -1;
> @@ -4250,7 +4250,7 @@ qla82xx_md_collect(scsi_qla_host_t *vha)
>=20
> 		ql_dbg(ql_dbg_p3p, vha, 0xb040,
> 		    "[%s]: data ptr[%d]: %p, entry_hdr: %p\n"
> -		    "entry_type: 0x%x, captrue_mask: 0x%x\n",
> +		    "entry_type: 0x%x, capture_mask: 0x%x\n",
> 		    __func__, i, data_ptr, entry_hdr,
> 		    entry_hdr->entry_type,
> 		    entry_hdr->d_ctrl.entry_capture_mask);
> diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx=
2.c
> index dc1ec9b61027..0aa9c38bf347 100644
> --- a/drivers/scsi/qla2xxx/qla_nx2.c
> +++ b/drivers/scsi/qla2xxx/qla_nx2.c
> @@ -1572,7 +1572,7 @@ qla8044_read_reset_template(struct scsi_qla_host *v=
ha)
> 	/* Copy rest of the template */
> 	if (qla8044_read_flash_data(vha, p_buff, addr, tmplt_hdr_def_size)) {
> 		ql_log(ql_log_fatal, vha, 0xb0bd,
> -		    "%s: Failed to read reset tempelate\n", __func__);
> +		    "%s: Failed to read reset template\n", __func__);
> 		goto exit_read_template_error;
> 	}
>=20
> --=20
> 2.11.0
>=20

Looks good.=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
