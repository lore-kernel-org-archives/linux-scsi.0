From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH 10/10] qla2xxx: Fix indentation
Date: Thu, 11 Jun 2015 04:45:11 +0000
Message-ID: <D19E602D.922DF%himanshu.madhani@qlogic.com>
References: <5570D656.9050704@sandisk.com> <5570D801.5090703@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D19E602D922DFhimanshumadhaniqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:35519 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbbFKEpP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 00:45:15 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id t5B4YBGY007954
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2015 21:45:14 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1uy1j60318-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2015 21:45:14 -0700
In-Reply-To: <5570D801.5090703@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@odin.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

--_000_D19E602D922DFhimanshumadhaniqlogiccom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9483AE79D0463745A7FCEA5FF2B0FB16@qlogic.com>
Content-Transfer-Encoding: quoted-printable


On 6/4/15, 3:58 PM, "Bart Van Assche" <bart.vanassche@sandisk.com> wrote:

>Detected by smatch.
>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
>Cc: Quinn Tran <quinn.tran@qlogic.com>
>Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
>---
> drivers/scsi/qla2xxx/qla_init.c |  2 +-
> drivers/scsi/qla2xxx/qla_iocb.c |  8 ++++----
> drivers/scsi/qla2xxx/qla_isr.c  |  4 ++--
> drivers/scsi/qla2xxx/qla_nx.c   |  2 +-
> drivers/scsi/qla2xxx/qla_nx2.c  | 13 ++++++-------
> 5 files changed, 14 insertions(+), 15 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_init.c
>b/drivers/scsi/qla2xxx/qla_init.c
>index 33cb3f6..5a5ca43 100644
>--- a/drivers/scsi/qla2xxx/qla_init.c
>+++ b/drivers/scsi/qla2xxx/qla_init.c
>@@ -708,7 +708,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
> 		if (rval !=3D QLA_SUCCESS) {
> 			ql_log(ql_log_warn, vha, 0x00d4,
> 			    "Unable to initialize ISP84XX.\n");
>-		qla84xx_put_chip(vha);
>+			qla84xx_put_chip(vha);
> 		}
> 	}
>=20
>diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
>b/drivers/scsi/qla2xxx/qla_iocb.c
>index 21d6f3f..524b5bc 100644
>--- a/drivers/scsi/qla2xxx/qla_iocb.c
>+++ b/drivers/scsi/qla2xxx/qla_iocb.c
>@@ -2763,10 +2763,10 @@ qla2x00_start_bidir(srb_t *sp, struct
>scsi_qla_host *vha, uint32_t tot_dsds)
> 	handle =3D req->current_outstanding_cmd;
> 	for (index =3D 1; index < req->num_outstanding_cmds; index++) {
> 		handle++;
>-	if (handle =3D=3D req->num_outstanding_cmds)
>-		handle =3D 1;
>-	if (!req->outstanding_cmds[handle])
>-		break;
>+		if (handle =3D=3D req->num_outstanding_cmds)
>+			handle =3D 1;
>+		if (!req->outstanding_cmds[handle])
>+			break;
> 	}
>=20
> 	if (index =3D=3D req->num_outstanding_cmds) {
>diff --git a/drivers/scsi/qla2xxx/qla_isr.c
>b/drivers/scsi/qla2xxx/qla_isr.c
>index 79f6989..b70af1f 100644
>--- a/drivers/scsi/qla2xxx/qla_isr.c
>+++ b/drivers/scsi/qla2xxx/qla_isr.c
>@@ -1579,7 +1579,7 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct
>req_que *req, void *tsk)
> 			ql_log(ql_log_warn, fcport->vha, 0x503c,
> 			    "Async-%s error - hdl=3D%x response(%x).\n",
> 			    type, sp->handle, sts->data[3]);
>-		iocb->u.tmf.data =3D QLA_FUNCTION_FAILED;
>+			iocb->u.tmf.data =3D QLA_FUNCTION_FAILED;
> 		}
> 	}
>=20
>@@ -1978,7 +1978,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t
>*vha, void *pkt,
> 		rval =3D EXT_STATUS_ERR;
> 		break;
> 	}
>-		bsg_job->reply->reply_payload_rcv_len =3D 0;
>+	bsg_job->reply->reply_payload_rcv_len =3D 0;
>=20
> done:
> 	/* Return the vendor specific reply to API */
>diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
>index b359a83..bb0ee7c 100644
>--- a/drivers/scsi/qla2xxx/qla_nx.c
>+++ b/drivers/scsi/qla2xxx/qla_nx.c
>@@ -1835,7 +1835,7 @@ qla82xx_set_product_offset(struct qla_hw_data *ha)
>=20
> 	ptab_desc =3D qla82xx_get_table_desc(unirom,
> 		 QLA82XX_URI_DIR_SECT_PRODUCT_TBL);
>-       if (!ptab_desc)
>+	if (!ptab_desc)
> 		return -1;
>=20
> 	entries =3D cpu_to_le32(ptab_desc->num_entries);
>diff --git a/drivers/scsi/qla2xxx/qla_nx2.c
>b/drivers/scsi/qla2xxx/qla_nx2.c
>index b8ceb82..007192d 100644
>--- a/drivers/scsi/qla2xxx/qla_nx2.c
>+++ b/drivers/scsi/qla2xxx/qla_nx2.c
>@@ -397,11 +397,11 @@ qla8044_idc_lock(struct qla_hw_data *ha)
> 				 * has the lock, wait for 2secs
> 				 * and retry
> 				 */
>-				 ql_dbg(ql_dbg_p3p, vha, 0xb08a,
>-				     "%s: IDC lock Recovery by %d "
>-				     "failed, Retrying timeout\n", __func__,
>-				     ha->portnum);
>-				 timeout =3D 0;
>+				ql_dbg(ql_dbg_p3p, vha, 0xb08a,
>+				       "%s: IDC lock Recovery by %d "
>+				       "failed, Retrying timeout\n", __func__,
>+				       ha->portnum);
>+				timeout =3D 0;
> 			}
> 		}
> 		msleep(QLA8044_DRV_LOCK_MSLEEP);
>@@ -3138,8 +3138,7 @@ qla8044_minidump_process_rdmdio(struct
>scsi_qla_host *vha,
> 			goto error;
>=20
> 		addr7 =3D addr2 - (4 * stride1);
>-			data =3D qla8044_ipmdio_rd_reg(vha, addr1, addr3,
>-			    mask, addr7);
>+		data =3D qla8044_ipmdio_rd_reg(vha, addr1, addr3, mask, addr7);
> 		if (data =3D=3D -1)
> 			goto error;
>=20
>--=20
>2.1.4
>

Looks good.

Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>


>


--_000_D19E602D922DFhimanshumadhaniqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AB8AZQABAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAAB8AAAAAAAAAIErH6S+
oxAZnW4A3QEPVAIAAACASABpAG0AYQBuAHMAaAB1ACAATQBhAGQAaABhAG4AaQAAAFMATQBUAFAA
AABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAA
AB8AAl0BAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwDlXwEAAABAAAAAcwBpAHAAOgBoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABo
AGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AGgwBAAAAIgAAAEgAaQBtAGEAbgBzAGgA
dQAgAE0AYQBkAGgAYQBuAGkAAAAAAB8AHwwBAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBk
AGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAA
AgEZDAEAAAB8AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACASABpAG0AYQBuAHMAaAB1ACAATQBh
AGQAaABhAG4AaQAAAFMATQBUAFAAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAA
cQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAV0BAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBk
AGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwD4PwEAAAAiAAAASABpAG0AYQBuAHMA
aAB1ACAATQBhAGQAaABhAG4AaQAAAAAAHwAjQAEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBh
AGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfACJAAQAAAAoAAABTAE0AVABQAAAA
AAACAfk/AQAAAHwAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBIAGkAbQBhAG4AcwBoAHUAIABN
AGEAZABoAGEAbgBpAAAAUwBNAFQAUAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkA
QABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAJXQEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBh
AGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAALAEA6AQAAAB8AGgABAAAAEgAAAEkA
UABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgELMAEAAAAQAAAA3Cfj
id86oUuZvjJjAkEMeAMAFwABAAAAQAA5AIClLmYBpNABQAAIMKiPXWYBpNABCwAAgAggBgAAAAAA
wAAAAAAAAEYAAAAAFIUAAAEAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBw
AHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUAbgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAA
AAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAABWAAAAUgBlADoAIABbAFAAQQBUAEMASAAgADEAMAAv
ADEAMABdACAAcQBsAGEAMgB4AHgAeAA6ACAARgBpAHgAIABpAG4AZABlAG4AdABhAHQAaQBvAG4A
AAAAAB8APQABAAAACgAAAFIAZQA6ACAAAAAAAAMANgAAAAAAHwBCEAEAAAA+AAAAPAA1ADUANwAw
AEQAOAAwADEALgA1ADAAOQAwADcAMAAzAEAAcwBhAG4AZABpAHMAawAuAGMAbwBtAD4AAAAAAAIB
cQABAAAAGwAAAAEB0J8Z9K0qT6IL8dpBk+Gw05y6cZedpsSTgAAfAHAAAQAAAE4AAABbAFAAQQBU
AEMASAAgADEAMAAvADEAMABdACAAcQBsAGEAMgB4AHgAeAA6ACAARgBpAHgAIABpAG4AZABlAG4A
dABhAHQAaQBvAG4AAAAAAB8ANRABAAAAWgAAADwARAAxADkARQA2ADAAMgBEAC4AOQAyADIARABG
ACUAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0A
PgAAAAAAHwA5EAEAAAB8AAAAPAA1ADUANwAwAEQANgA1ADYALgA5ADAANQAwADcAMAA0AEAAcwBh
AG4AZABpAHMAawAuAGMAbwBtAD4AIAA8ADUANQA3ADAARAA4ADAAMQAuADUAMAA5ADAANwAwADMA
QABzAGEAbgBkAGkAcwBrAC4AYwBvAG0APgAAAAMA3j+fTgAAQAAHMIhrVmYBpNABAwAmAAAAAAAC
AUcAAQAAAC4AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIzLTE1MDYxMTA0NDUxMVotMTk3OTYA
AAAfABUQAQAAAFgAAAA5ADQAOAAzAEEARQA3ADkARAAwADQANgAzADcANAA1AEEANwBGAEMARQBB
ADUARgBGADIAQgAwAEYAQgAxADYAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAgEUMAEAAAAMAAAA
FQEAAAbbJZZPAAAAHwD6PwEAAAAiAAAASABpAG0AYQBuAHMAaAB1ACAATQBhAGQAaABhAG4AaQAA
AAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcAZQBuAHQAAAAAAAEA
AABGAAAATQBpAGMAcgBvAHMAbwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBrAC8AMQA0AC4AMwAu
ADkALgAxADMAMQAwADMAMAAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYA
ZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAAA4BAABJ
AEkAPQAwADEAMAAxAEQAMABBADQAMAAxADYANgAxADkAMQAzADAAQQAxAEYAQgAxADMAMgBBAEEA
NAAzAEIARQBDADYANABGAEMAQQAyAEQAOQA1ADkAMABEADUAOwBTAEIATQBJAEQAPQAxADsAUwAx
AD0APAA1ADUANwAwAEQAOAAwADEALgA1ADAAOQAwADcAMAAzAEAAcwBhAG4AZABpAHMAawAuAGMA
bwBtAD4AOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADMAIAAoAEIAdQBp
AGwAZAAgADIAMwA1AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIAAAAAAAMADTT9PwAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAA
AAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQA
aQBuAGcALQBpAHAAAAAAAAEAAAAYAAAAWwAxADAALgAxAC4ANAAuADEAMABdAAAAHwAAgIYDAgAA
AAAAwAAAAAAAAEYBAAAAFgAAAGQAaQBzAGMAbABhAGkAbQBlAHIAAAAAAAEAAAAOAAAAYgB5AHAA
YQBzAHMAAAAAACN0

--_000_D19E602D922DFhimanshumadhaniqlogiccom_--
