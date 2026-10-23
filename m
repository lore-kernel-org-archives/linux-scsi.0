Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750582;
	b=eXPBetC64SE+KLMEy0Xa8cAmxsbJi0YqAiD23KzNaB5EJdyexwGvztBwpWFT1drLGbCL
	 47oo/en+mCEQwhY6V+WNC0RUIYc+akyU+3+Lw3urNgSckZA5zzIrJ7nAsnv5DIERBwxIa
	 2UcF5fMRAJaYhQKX/KA6RCw9yvxDlk2kb8WyQODwbw5LU/aVkXXwP4FlsIauI1gsn/+S4
	 kMpPS6T29gRP9LzlQA1Q3CTIVePvB1Istzs4WkgZfdEQVoFc7a8qVFuSPVDVXdDP7Jvsj
	 WyhWbzKqC79XK8GrJ4uY5uqojq+ICj0QNurWWPugmlALm3xt0NqZxY7got34knruEsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750582;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=+mE3hGj5Tx8TxBYnykReuc927A8F7l2tbKHTsn71LLw=;
	b=qsM2a64E+LrQTg3P4vBSG0bJMSphZAOsYoio5HLcfgZ3mG0L2aE5o6Sz/8da0fPyT8Lo
	 bZ9At7jKDEzYlF4uHZVwQfp6W5+pGZ9+tbk4Fm9RlpFp2mOnwlxi2w4KD5LGiYxW2nWJ2
	 DwUwnOQpUNDl0rN1ekqeVre6m/LxxSjJbQm4pYi4fDvEK+LJU61KYmUiucA0qnSgYVymY
	 LgW/FJmV12h/OiqtkFwZiJUcECBC1G5jq7IyaXHMPcA9WkWrqRdV6yvTArnf9sAobpvga
	 XNaXVt8yG/cfpUvrI4U/5EU6WiezYOUdTA+JPCmdLklLl8PaoM6/5+ABVdfxKRyTa1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=I7joisvS;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E9C606A321
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13E9C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=I7joisvS
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADoM13110239;
	Fri, 23 Oct 2026 03:16:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	mE3hGj5Tx8TxBYnykReuc927A8F7l2tbKHTsn71LLw=; b=I7joisvScKuJTdtSL
	zNfF/r1IUEOFl83rcOkAozMckDlWwoSVonbnuc+aozEnDW9nn7yQZTUhDy2rROnd
	R/YdXkkhjC3oVOuAScTcSr0THxfmVtIzYGlhgxbBlwNFpC4LrWyFlDtcXYvvRquO
	tuO3FYbnQcXrv9IbpCwCLnKyb3ohI/rXhBnskLjovCL+MtCAiD1C40hnnUoPIwLz
	3HA4vORkfELOsYDmxYsEgHKIOiLpAjizcBNZkWlktTcJvoQA4dT3Ivn8i4hdv5CX
	9CGMtBXtg8Xb/m+qrVxUi5nqLoBe1iL4z2n2O9S4ziZ7WnxMdRVWh1CiIIihkl5q
	PcAww==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hfv15th1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:18 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:16 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 87E943F7069;
	Fri, 23 Oct 2026 03:16:14 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 02/13] scsi: qla2xxx: Update few AENs for 29xx handling
Date: Fri, 23 Oct 2026 15:45:49 +0530
Message-ID: <20261023101600.1431179-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20261023101600.1431179-1-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: VBjsOfOnOv9dJlFjQRVYbuxuzrUsbWwy
X-Authority-Analysis: v=2.4 cv=RPQmjIi+ c=1 sm=1 tr=0 ts=6adb33f2 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=9wQDHOz2xpCgzWt2mZsA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX+ygl2RGyrqzw
 jGpCBS9PTf8iVom5DMvTQzW7Cb7YCNjbEbC1a5D88zg+ZV0Rd3ulzAeqBAtq6ZcqoGogScfuX0F
 UWBFBnm6oRZ+UZeB8nTsXXtMAqEI02k=
X-Proofpoint-ORIG-GUID: VBjsOfOnOv9dJlFjQRVYbuxuzrUsbWwy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX9WEZdC4/OFTh
 aq9vkGQGjMdn5fMq/h1v6G6gNpUMQ4flqA43dg5A56MjCROdcTR/xHzihyoeYQT0d1eMD5II2Mn
 pZfyHOfT+3xmVbqkrHNQBC5O9LkLeInUzs51VIkhQqZBqpzwJvER/1Axaq3NJTT3LvnpN3YSeck
 KwVw2f+4os91/yAcp9bm29QuZ7ooQ7l4lolJ72MbPPt2/0zNFLLzavAh+L8eCADB9nhjeOTma/2
 cOFaukHODG1MKv84OvKeSESOTfDKahC2CdO0+x0vx+LNUf4RronS3y8VYdcO9oC652WOLL+QzaQ
 STCOJSoANCUDn8oei7ylhongvB9e7Qw0BO3AoizmtEdQYt0OewCO4h6PY+kGAl/Y65gFw1XJhy3
 kzo48UzgltkZaiCp7NgSxZs/VOo3psepA9K0bYcSe72epIu57zbQgjLbyCK1PnUSpvtKLHlhZJo
 tBAHhDpm+kr8OHfpMPA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

Handle QLA29XX adapters like the 27xx/28xx generation across several
async event paths in qla2x00_async_event():

- MBA_SYSTEM_ERR: capture and log the extended mailbox4-7 words, and
  trigger the MPI firmware dump when mailbox7 BIT_8 is set.
- MBA_LOOP_UP: report FEC-enabled status on link up.
- MBA_IDC_AEN: process the 8200 heartbeat/IDC AEN via
  qla27xx_handle_8200_aen().
- MBA_DPORT_DIAGNOSTICS: decode and log the D-Port diagnostics result.
- MBA_TEMPERATURE_ALERT: report laser information.

29xx is FWI2-capable and uses the device_reg_24xx mailbox layout, and
qla29xx_isp_ops already wires fw_dump/mpi_fw_dump to the 27xx helpers,
so the same handling applies.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 63b70d4abbf0..7bae26d4404c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1443,7 +1443,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		vha->hw_err_cnt++;
 
 		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
-		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		    IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			u16 m[4];
 
 			m[0] = rd_reg_word(&reg24->mailbox4);
@@ -1459,7 +1459,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n ",
 			    mb[1], mb[2], mb[3]);
 
-		if ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
+		if ((IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) &&
 		    rd_reg_word(&reg24->mailbox7) & BIT_8)
 			ha->isp_ops->mpi_fw_dump(vha, 1);
 		ha->isp_ops->fw_dump(vha);
@@ -1554,7 +1554,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    "LOOP UP detected (%s Gbps).\n",
 		    qla2x00_get_link_speed_str(ha, ha->link_data_rate));
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			if (mb[2] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a0,
 				    "FEC=enabled (link up).\n");
@@ -1998,7 +1999,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_IDC_AEN:
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			vha->hw_err_cnt++;
 			qla27xx_handle_8200_aen(vha, mb);
 		} else if (IS_QLA83XX(ha)) {
@@ -2022,7 +2023,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    "D-Port Diagnostics: %04x %04x %04x %04x\n",
 		    mb[0], mb[1], mb[2], mb[3]);
 		memcpy(vha->dport_data, mb, sizeof(vha->dport_data));
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			static char *results[] = {
 			    "start", "done(pass)", "done(error)", "undefined" };
 			static char *types[] = {
@@ -2050,7 +2052,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_TEMPERATURE_ALERT:
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			display_Laser_info(vha, mb[1], mb[2], mb[3]);
 		ql_dbg(ql_dbg_async, vha, 0x505e,
 		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
-- 
2.52.0

