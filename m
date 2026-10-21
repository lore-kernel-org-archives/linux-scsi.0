Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578235;
	b=zOX//wCc7UGBeQ4x17U5R2g1/zL1cJ8nqVMczMmTLwufxIx6f/bAcd3tMxJTrXy7EMKU
	 P+Ya25XBdARKMNzYyWxngT0oflSOK3CytlrXn/4ORRWdTuRmj6z3zSSG45rjoE4NpO+cL
	 zLiWUvhCR1IOYP5ux8o7ID14PBVQH9kY4/7VCWQP56Ja+QCxroVZ/il8hw76ESGj8Q1aG
	 gGh9lAOjTaX5zTng0H9asyjs965Mvb986NAEqnculXZGYF/dPXnD+4N2yNn0TF1AwOaeE
	 7uZHJSb3bnW6VsySsE21EkGZfFeYxnoPbMx+3HdKpoHvdbvi09hss3aE7Vibqs86rDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578235;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=+4YsKBPVKjC1w3S2Q97q//GCWmFHyhmx8F0ayu9CF1s=;
	b=Cke48ErriJRScuLWqiXhBhg/4jSAj3icdxBSNhQOTPhoU5f7ybzUhXs1HyNryJ5Sz0N7
	 WG1o4SD+3AI5zKdISpquJLQIbfAThl7ayO3kbFMLJZq3jb2J0Hw9cUUcQOVOYRLRl3MdY
	 qBCw9ehIuk2TgwzYmEnXbaxJ8T5s3uuLnzRoT4BKc6Xy+SDbOFblWH/X/KFtEHOQ5+e9g
	 5BRe061DAwoUbf7GBixF9qnR1hfvRZVG2Hdoao9yeQEAbj9jMM+3tnq6riV5Wk+bcxDzu
	 f6Y9rmhQmTJmmrfg/l0uTcbdWXfd1P64JriaRI3hsxc/pO5XidwnOPe9aejYe3GJXCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=QnwU+Wkc;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260AA606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:23:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 260AA606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=QnwU+Wkc
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5dvF1763739;
	Wed, 21 Oct 2026 03:23:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	4YsKBPVKjC1w3S2Q97q//GCWmFHyhmx8F0ayu9CF1s=; b=QnwU+WkcIEMDTgJ1n
	LTg3GretIB2obddjPelr9uO9E2HJ92cDfFGzn2/TnRtvL9awxmXE3VTMwhQeDjrZ
	9eVW9hEzA6fr3+xaYIGevujVAhBtAELwvf/CAZ+52+vyBhaC4V3AsM+AkEpxzoT5
	e/h+xV2GESau3+6keiOYO/WiKDBYnC5kU5xcYsUxVycaXzd9q80OSCAyJ2Np4V8p
	kQd2wkzKEspNCBwT+KlQH/sbsclh/8SxKRsUAx1ETZfBfjYEnSK4hCNJG/sDyryh
	z049WX3Vwqg9goAeQ6qg6A/SNqbGZkDH4PsdZerW7FdSS0mOWLtvP73KxdKJ/ohd
	1UX3A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hepyxh2jy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:45 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:45 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 351EF3F709E;
	Wed, 21 Oct 2026 03:23:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 03/14] Revert "scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]"
Date: Wed, 21 Oct 2026 15:52:59 +0530
Message-ID: <20261021102310.3854868-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20261021102310.3854868-1-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: jgMLZaG8xIE2s5QnJ7BtaNaHL6N37fIr
X-Proofpoint-GUID: jgMLZaG8xIE2s5QnJ7BtaNaHL6N37fIr
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX8w9evnI0eaKq
 R3XSUhIEwnpO8y6rC4eF4H/gdgzMJDUcEFfKED/iXLMRcAOdiwEkdgbWaviTRrhLpOWrpa2Nnom
 on5HJlcAhHXBfLoB7b3dvy5IK5D/0so=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX7v5sgUcYAila
 SgWKZf233kgCG0sCkkWvAcq5CRA7YEWKwr3SFLV+6FMLZP7gUQ39aEc4zXJrnKTiiQhncbE2ZpD
 EaUE3HCzZbI1263QlkOUFlSRb+l1g9cUxtydbF+X9Zjri5Aq+1kGRXkh3VaNWlXrVT04bL7WB4h
 1gKvDFQJl5euj3Fixu6ssWZaxbE9xaiegKeyN9usWDd9fzxiR8bn8kMO1Atyv3+AEhyd/j4IOEQ
 gSRplDjHvICdEVyMg76kUVO8dWA2aOTr+7YQl1phzNxb/CDY62xYaU2AKzkY1EaVMu8GjzTGWm5
 7Snd0doF5QnhIjLQBV/vUQD1pgXP1QrkLX0qSeJId1fR6aP/W37flDFlBzlXq6M9k3aI0q0ksF1
 CzkpSX/4jskC+nNdno79Lu3eVEF0L8rGOgMluvnlMlT+Ri6LHNARKLqzh1qzMVOebfzqiJT3Hnh
 cIa/ncpqnRHfxaA/GwA==
X-Authority-Analysis: v=2.4 cv=Jq9kP84C c=1 sm=1 tr=0 ts=6ad892b2 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=JH6pAb7ZMQpLCrKKeoMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

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

