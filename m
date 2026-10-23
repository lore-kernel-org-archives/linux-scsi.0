Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750597;
	b=Po9okcYLDLwYq8xn92fQmKhiwRcDMKlpu+KYCRGwMNHPNObL63rsUC86b+hB4fXWffve
	 X8LxR4anJM7Ddi5fHae8RqBGPw+tDaqfQpkJDI4FStZq/II3zaE+BFM3PwZe4WYnmqHcM
	 eJLdOnKrSsHQ+cblkXf6jznC47A//W2LySgHahPYmGkzK4ueYDf1YGB7w24dKb/vUqYxB
	 htFynMH4u/vMBQTzZDHuNraUIrW7XCKaK2DD1A5EVQ6eTPUJNcPDoEXhKdiX9NrimfQxc
	 yY6AHEKhOxKLuxNquZGmraXLcxQcR6PRWsgl/vR/hXhOqBOndK1rSYyXw/hPMfaSPHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750597;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=GbhauviiVOJhnFxHf1JqoL+TDrIP3OH1akEzMRxxLWU=;
	b=KLRyXO9Ud8kFgZ2wlE5+DxlR6fCUYlLAUCs50+N12rmISGbVy/xsD5q57dQSm7FTy7x5
	 8Bdo9dFShq5AF5SsOVzz0P8uWRt9DcHOPj6E71j9vlT14q3AoGWZ8OHHYIjJ4wiDnRxgQ
	 aECX55F5tYhbn+hX74mDyU7tz9HkCWiega8FikaXtLkQ6ugQxbVYtCqTfLuuwiPMgHeaB
	 TqAuF3f751kSK7s1vhOpFcLrTDanFxznRDa8kllG+OJw0mC28qreWs3kEl93Wa44zD6b2
	 f72V5j6lXZDrzcoZINrmZHUiHQgPgzLR2CIHwgtNMN4Q7MRSdXWUAUKDvPYzwxJfz5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=Slq2V5tW;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC8606A31F
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11EC8606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=Slq2V5tW
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADcN83273667;
	Fri, 23 Oct 2026 03:16:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	bhauviiVOJhnFxHf1JqoL+TDrIP3OH1akEzMRxxLWU=; b=Slq2V5tWqDHPYMiYy
	nA9ceODdcXXVxmnOiQCeGpmKSoSDN9h8JYyFam0cAC3XOZO2Pgf/K7C/BGFgiOu9
	g+GjpKE25W7ccNUZMdAcZIXuVkjzkagWk4hUPBosiVVT1aPh9lCSWD0KKeXdHPxR
	M8P7GZLKQniNScjLW9KYynb6cxeWaipWAY4N2cGr9VEo/ei+5HiAaMjyE3L95Tka
	jG2PfXflWegRTCpbeV0Zlh0A7T/x6QzwZgiRoqSAfPrQ+SKndFwMnxgyOtvhMjsZ
	rZnYN3Wi/LUW7GmovZAd77zJr02E18Pq9vVd9u+sd7ZjX9H6zkp3T8F0y2dhlbX7
	p6u/A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hf94b994x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:34 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:33 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0CB263F7069;
	Fri, 23 Oct 2026 03:16:30 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 08/13] scsi: qla2xxx: Add validation check for base vport index during delete
Date: Fri, 23 Oct 2026 15:45:55 +0530
Message-ID: <20261023101600.1431179-9-njavali@marvell.com>
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
X-Proofpoint-GUID: H_dLeiqQEDoOwY0KtvT35BCzn_V5_BPG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfXyQlXORKS7IIx
 47i6WQtBxkZeRAdqQwasQZBaE5TpPhEGCuLeHJ5Qky2Mk/SmQ6pB1J9LfumcmWBBs3hxdo06ikn
 7x9udc7WA4e6K2+3UNcRYBSV/NqKdoapmCxswxplajeTomavkrujuseB0wvslZSMKjNujRr3pOa
 gZTCio1bxhJppdyI8cbXlQzoz1+/NVNA2g6IvLKyWj1C5fd0ZLypgp5c36zx6+Zf+0l2IxmkhET
 sYrXmCSR/x8RFhzFxz4FWEHlVkILNY76cu2QnkqgT2AfjrfXADnniowojMzUn8ivCUMabw4/K9F
 2aWTusWgE7YYavI8hG1Cx3AmnwaC0eKeUyCT++DDqtplF/x1nNa9FARv7/cECGmPXhF/nzAgzWX
 gktyU0GFX0EqOzuiLvyA4nCxjdBZeh0aVj5cOMMlnDLsCl57y4GNzMVOV18q5/w3DWRspdAbm5N
 AYBlhpXeYCia6/7eUBA==
X-Proofpoint-ORIG-GUID: H_dLeiqQEDoOwY0KtvT35BCzn_V5_BPG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX45SHU5UJQ/rM
 UNeci43rSr8OHzwVm7zWjsm3/K2DIWXc8PXQacfwy34+4alWpRiVlPA4y5F6Ew6bI8hH1Otynwq
 RLHywL+FaviL8UZNw0EZQY3H31jCoCE=
X-Authority-Analysis: v=2.4 cv=OrDaWC/t c=1 sm=1 tr=0 ts=6adb3402 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=sNYpLvrkyEg6eucKXqMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Add a guard in qla24xx_vport_delete() to prevent deleting a vport with an
invalid or zero vp_idx. If vp_idx is zero, log a fatal message and return
-ENODEV instead of proceeding with deletion. fc_vport_terminate() treats
0 as success and would free the fc_vport without tearing the scsi host
down.

    [ 4268.547235] Call Trace:
    [ 4268.547238]  <TASK>
    [ 4268.547242]  ? srso_alias_return_thunk+0x5/0xfbef5
    [ 4268.547256]  ? show_trace_log_lvl+0x26e/0x2df
    [ 4268.547270]  ? show_trace_log_lvl+0x26e/0x2df
    [ 4268.547279]  ? qla2x00_do_dpc_all_vps+0xc2/0xf0 [qla2xxx]
    [ 4268.547305]  ? __die_body.cold+0x8/0xd
    [ 4268.547310]  ? die_addr+0x39/0x60
    [ 4268.547322]  ? exc_general_protection+0x1ec/0x420
    [ 4268.547336]  ? asm_exc_general_protection+0x22/0x30
    [ 4268.547347]  ? qla2x00_do_dpc_all_vps+0xc2/0xf0 [qla2xxx]
    [ 4268.547369]  ? qla2x00_do_dpc+0x264/0x760 [qla2xxx]
    [ 4268.547391]  ? qla2xxx_pci_error_detected+0x190/0x190 [qla2xxx]
    [ 4268.547411]  ? kthread+0xe0/0x100
    [ 4268.547420]  ? __pfx_kthread+0x10/0x10
    [ 4268.547427]  ? ret_from_fork+0x2c/0x50
    [ 4268.547442]  </TASK>

Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a4ca22024ede..15fcfd2246e4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3276,6 +3276,12 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t id = vha->vp_idx;
 
+	if (!vha->vp_idx) {
+		ql_log(ql_log_fatal, vha, 0x700f,
+		       "failed to delete Vport idx [%d]\n", vha->vp_idx);
+		return -ENODEV;
+	}
+
 	set_bit(VPORT_DELETE, &vha->dpc_flags);
 
 	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))
-- 
2.52.0

