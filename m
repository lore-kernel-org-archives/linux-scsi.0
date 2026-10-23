Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750585;
	b=w7y96N2pZlAfSpEMVKVFfH/UKPeob+Gtfvq194OOb1Go05icH0wJdrQGj0O8pivUy2hZ
	 otujB8w4KU5mqMXlyNlycUv+fhOAVbjLqyhH/v6q1QAxTL0VED38CLFRnaO9drjuHc2As
	 GXzoGES1zv/LYeXr/0OHcHoYsj8aRYMUcn7KLV4NN9x+w6sWr+TLXrtEdU/zFIa/GWn5M
	 du2zkUyNRNmqPENdUbb9A/ZePvirTxd4Qh1j3fNG6fibK2SvWt4od0tcKJcQhPjewzGF/
	 zDS6ERu5q3e/4C64yUp/wD7EAybk9xE3WoKSW2/DWJ5cVXvHS6ADJeUB1+Q4Q2JqCTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750585;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=+4YsKBPVKjC1w3S2Q97q//GCWmFHyhmx8F0ayu9CF1s=;
	b=D0ydEb67QO1YsaC8zJ20YW5XijvddyDKjxqraGioWNzNQOMm3UDgOnR4GiSZICVsOSRD
	 b0Dndft12ulq9NXZ7J4AUjTvfALM0/GHk4SnsSwPI4mUsjY6korqqbGELBrJhBT9lde9t
	 PQhvQsXWz+5cfXCqc9sYofSOFMC74qEsKtkrP5V293i70CI+HS9REmPhlS4c//+9dHTwv
	 PnEdLAnR3InfvWZagwLF8eKD60V/5VIw872RvtcluUZOMTpr2saqXz5KO51Rr+y4ed4VG
	 MlHXlXMs+ki6tPXQkugvmvbi/sE/sf6CrNeMHaQ4aT0oqVQmmQSfcbJN36Lz0JlJ4sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=NdDd6Dye;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C5B606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4C5B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=NdDd6Dye
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAEAKt3757772;
	Fri, 23 Oct 2026 03:16:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	4YsKBPVKjC1w3S2Q97q//GCWmFHyhmx8F0ayu9CF1s=; b=NdDd6DyeP3aK4d5D9
	tFbNu5JqfP/gU7uMVtIOlJVOK87rJ9l9Z3LAFE9v9wl3WKELS62URonyI5KpOBBy
	5LvA8FesBX2+toJIDfyvhdA8jqYpRYADLBwC1hQrhGlSLBh4DCKSXUWYkt0tu7vA
	Ac2CNkJZNueQ64YRJazB4ErOVcml/dLQnCyEEWEWJZUuRx1Wc3/ul0P7HiQfZAWy
	lIypGk29FYcKpdPVNryqJNsIJ5WV2Tea+ApJZWKqVOZedgRkNO8fkT0qgbNVNIUo
	A2ahiT83h0053tbvS7Iatq+3oEHaZqBTlYdjbFTOa6bnlGSiAbmriSxpUBjhrLrF
	5tfLA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hfmdtn9wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:20 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 354673F7069;
	Fri, 23 Oct 2026 03:16:16 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 03/13] Revert "scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]"
Date: Fri, 23 Oct 2026 15:45:50 +0530
Message-ID: <20261023101600.1431179-4-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX8C5Yr+riC73+
 cCn8O4dWQzX7dAFM5BB1v2inZ4BraIwQ6IcZ8LHKClAkFGdB9uBW+frCvotVimfnFPAfrYePGYZ
 bv/UeixmI3kaXcy41WuAQcErPHGWe/U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX6ZHmFzo9fRZD
 sx9NjC1eGl6PxLWEWgu7h+XwMmGNqiM28zhDvzBcBVxWeSqUMVohRn/YzbCElRmtNHUPZlOyE3b
 naziVFrQg3gY5poq4kvg9NSRRz/AXAAsGJl1N/X78kS0VTXMSxXsRlkkIqBTXWcIvEEfA4xgWN7
 5pdHYIvyq85B6//ARuVNMuFrkVVoAfm1WGw/1bLM771HuHB/pHUwERa8RHQtiHToCZyy+FCbUlS
 CdtnD0CpjyRERP1lu7Sj2eFG9mj8x4dLfKUxCH5vByjYAERoG1KKAvp3lNnBo+ihbV9vmihw5Ri
 ukIKg7uPB8MP4OMLW8esBE4j+pKJpoi1014WMvK2UScOLQdENnGTyF3fNxq5miPSCIFmkMymKu+
 efdgLQY6Uk4E1cGh4odzwPoOzF5bsvCVVw16VHRkwKFtcrvMXZR5FB+B3lhdo8JiuSTLbOIEYTv
 YmvU7ncKRbeFllO38xw==
X-Proofpoint-GUID: PcvsjXp1HAp4z_PYzzcOUYGkQePq9yw-
X-Proofpoint-ORIG-GUID: PcvsjXp1HAp4z_PYzzcOUYGkQePq9yw-
X-Authority-Analysis: v=2.4 cv=PalqFShd c=1 sm=1 tr=0 ts=6adb33f4 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=JH6pAb7ZMQpLCrKKeoMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

The added request_len checks reject legitimate FC_BSG_HST_VENDOR requests
from the Marvell qaucli management utility. qaucli passes a request_len
that matches the historical userspace layout; it is smaller than
sizeof(struct fc_bsg_request) plus the vendor_cmd words the driver
started requiring. qla2x00_process_vendor_specific() and several
vendor sub-handlers therefore return -EINVAL ("BSG request too small
for vendor cmd") and management commands fail.

Restore the previous behavior until validation is reworked to match how
admin tools size BSG requests (for example per-command minimum lengths
or userspace fixes) without breaking supported management paths.

This reverts commit 4cf38dd9465736141263ebb63375868311a0ec81.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 57 +++-------------------------------
 1 file changed, 4 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index ab559048dbb8..19a514a153ae 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -160,12 +160,6 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 		goto exit_fcp_prio_cfg;
 	}
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t)) {
-		ret = -EINVAL;
-		goto exit_fcp_prio_cfg;
-	}
-
 	/* Get the sub command */
 	oper = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
@@ -764,10 +758,6 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 		return -EIO;
 	}
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + 3 * sizeof(uint32_t))
-		return -EINVAL;
-
 	memset(&elreq, 0, sizeof(elreq));
 
 	elreq.req_sg_cnt = dma_map_sg(&ha->pdev->dev,
@@ -1000,10 +990,6 @@ qla84xx_reset(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
-		return -EINVAL;
-
 	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
@@ -1048,10 +1034,6 @@ qla84xx_updatefw(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
-		return -EINVAL;
-
 	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!sg_cnt) {
@@ -1529,15 +1511,9 @@ qla2x00_read_optrom(struct bsg_job *bsg_job)
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	uint32_t start;
+	uint32_t start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	int rval = 0;
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
-		return -EINVAL;
-
-	start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
-
 	if (ha->flags.nic_core_reset_hdlr_active)
 		return -EBUSY;
 
@@ -1580,15 +1556,9 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	uint32_t start;
+	uint32_t start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	int rval = 0;
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
-		return -EINVAL;
-
-	start = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
-
 	mutex_lock(&ha->optrom_mutex);
 	rval = qla2x00_optrom_setup(bsg_job, vha, start, 1);
 	if (rval) {
@@ -2453,11 +2423,6 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 	struct fc_port *fcport;
 	char  *type = "FC_BSG_HST_FX_MGMT";
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + sizeof(uint32_t) +
-	    sizeof(struct qla_mt_iocb_rqst_fx00))
-		return -EINVAL;
-
 	/* Copy the IOCB specific information */
 	piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
 	    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
@@ -3379,13 +3344,6 @@ qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_j
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + sizeof(uint32_t)) {
-		ql_log(ql_log_warn, vha, 0x7000,
-		       "BSG request too small for vendor cmd.\n");
-		return -EINVAL;
-	}
-
 	ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=0x%x\n",
 	    __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
 
@@ -3529,11 +3487,8 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 	}
 
 	/* Disable port will bring down the chip, allow enable command */
-	if (bsg_request->msgcode == FC_BSG_HST_VENDOR &&
-	    bsg_job->request_len >=
-		sizeof(struct fc_bsg_request) + sizeof(uint32_t) &&
-	    (bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_MANAGE_HOST_PORT ||
-	     bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_GET_HOST_STATS))
+	if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_MANAGE_HOST_PORT ||
+	    bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_GET_HOST_STATS)
 		goto skip_chip_chk;
 
 	if (vha->hw->flags.port_isolated) {
@@ -3842,10 +3797,6 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
 	if (!IS_QLA28XX(ha) || vha->vp_idx != 0)
 		return -EPERM;
 
-	if (bsg_job->request_len <
-	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
-		return -EINVAL;
-
 	mutex_lock(&ha->optrom_mutex);
 	rval = qla28xx_do_validate_flash_image(bsg_job, &state);
 	if (rval)
-- 
2.52.0

