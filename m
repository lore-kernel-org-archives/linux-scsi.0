Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B53629B8E8;
	Sun,  8 Mar 2026 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772982909; cv=none; b=E9smWOk9Rb5g04RyMjuYPpsP4AG3xgpjteit3iQWTHmLe+Uz5AWcIjm3F8nHUFsIWOT0D+A1i0YOIU+BrZoL2ii/J9BamYZ8Ixbb+aWIUjS7toruG50zhX/jH8dfKoM2QDv0g+l19P6GFMmzewnWEYliway9UdOCrxHrumAZ5RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772982909; c=relaxed/simple;
	bh=sQVCmCy9+ySEVmf0TX3Lujv2LY9OTEejXwRCNUWypwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ro/Ue5ZjQm4+7BunRoXfRYML64S+awUBHVyyqMyI1NTqgcu8C06YspRT2yNsqqJ6VfvEy+EAGDXX9V0HEU8rEHGOVUEaTVKcKWdt9ptoyVyDSZyQbdkBR7f4qQhmfufHbA2/P9Dv2SvZdPkQ1shqU7lLw8AMUo7yss51FukU/Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NKTiI7C0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NKTiI7C0"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628AqeVF1112394;
	Sun, 8 Mar 2026 15:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Ei6Shrv1EZQ
	sWBpTGkA9eKg+azUkvFoOk1mza4i4vZI=; b=NKTiI7C0pQM1v1nf2yxeTZbY8ng
	66jfax04qBdAZvX3dbW9nYMIIRGJdQ5MunLhJJ11FmFjaYVLkySyO+yBntcuIfac
	VYzwqWJc5eLkIprWR4NI6/EUKnAtNOgH0jBeuIdxeK1mVfQsef1N/CJ4lPKdl5WC
	fQ916JhKOvqU6A2l0m4nQzoN7EyNKJ9FTzU5LFeHDG4MDc/05W/H3gAQT+2aYDcz
	GXj1beXFM/5IUijQIVSRg7q3zf7MKu4NIFLemm7gNFGtOog9rDEUF0ZHWcIprpTe
	sT/LQwnQwq8Q3xIGN7nf18e9gwtxRCU+VxzMPni2NW48Dfik9/PQWZ9aIzw==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4crbbg2s8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:14:52 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 628FEhmd017715;
	Sun, 8 Mar 2026 15:14:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4crd3nave1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:14:51 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 628FEpjY017762;
	Sun, 8 Mar 2026 15:14:51 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 628FEphW017759
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:14:51 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 34CE35A4; Sun,  8 Mar 2026 08:14:51 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 06/12] scsi: ufs: core: Add helpers to pause and resume command processing
Date: Sun,  8 Mar 2026 08:14:03 -0700
Message-Id: <20260308151409.3779137-7-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: sa05aiPZcmQdxXRAYjt2sPHiTWojcNx5
X-Proofpoint-ORIG-GUID: sa05aiPZcmQdxXRAYjt2sPHiTWojcNx5
X-Authority-Analysis: v=2.4 cv=SumdKfO0 c=1 sm=1 tr=0 ts=69ad926c cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8 a=gPywXGqH3ohmGHrydA0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDE0MCBTYWx0ZWRfX9wCVZXTyC6B9
 thG/l+jcAgP8apAqZ3B9hbXcBK6mb9hQ4piklu4w8pgwx13XN2TTwd5C/0cL6Q7p8zgd/sBx/T+
 bAHUkFc5qjQyFQbsALK3Ved9UUmmZKlxNjNslL0r59LdgGnYX5DmiT4ooFFEDNJSZ+a8ucVOa8q
 ybfi8IkEwggzpxk8Wl7gktFminRGYvhNdv0QQso19sQogZBw+hdVrT3VYysGncZsiKFTnwpBgFI
 7ROC+RCIZ2NEhN4pZqPXc9Z0qfyJZzlnhuTfgkcqwn87HB98vE+Aq+SMWjBA9276OF6zsx+OASZ
 /YnXyosr5wv5vv4rXDSb10s5Hh9x062I89NxqTWMmDja6duX8jA7/Iit6vuFQwI0NywQ1C34q2G
 yJg3CFzWQR4OrZo94hy0BCIIeUFBHEL19a/dZoUSYuP8sqLX2/0VJH/wFCqyjTGEuNbpqklnkoS
 8gZQaEEYs6cZgEZpyMA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603080140

In preparation for supporting TX Equalization refreshing, introduce
helper functions to safely pause and resume command processing.

ufshcd_pause_command_processing() ensures the host is in a quiescent
state by stopping the block layer tagset, acquiring the necessary
locks (scan_mutex and clk_scaling_lock), and waiting for any
in-flight commands to complete within a specified timeout.

ufshcd_resume_command_processing() restores the host to its previous
operational state by reversing these steps in the correct order.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd-priv.h |  2 ++
 drivers/ufs/core/ufshcd.c      | 42 ++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 20ec8d8ac0a4..2303d57bf874 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -78,6 +78,8 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag);
 int ufshcd_mcq_abort(struct scsi_cmnd *cmd);
 int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd);
+int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us);
+void ufshcd_resume_command_processing(struct ufs_hba *hba);
 
 /**
  * enum ufs_descr_fmt - UFS string descriptor format
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 15543ad03181..6fef24612be1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1362,6 +1362,48 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
 	return ret;
 }
 
+/**
+ * ufshcd_pause_command_processing - Pause command processing
+ * @hba: per-adapter instance
+ * @timeout_us: timeout in microseconds to wait for pending commands to finish
+ *
+ * This function stops new command submissions and waits for existing commands
+ * to complete.
+ *
+ * Return: 0 on success, %-EBUSY if commands did not finish within @timeout_us.
+ * On failure, all acquired locks are released and the tagset is unquiesced.
+ */
+int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
+{
+	int ret = 0;
+
+	mutex_lock(&hba->host->scan_mutex);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
+	down_write(&hba->clk_scaling_lock);
+
+	if (ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
+		ret = -EBUSY;
+		up_write(&hba->clk_scaling_lock);
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
+		mutex_unlock(&hba->host->scan_mutex);
+	}
+
+	return ret;
+}
+
+/**
+ * ufshcd_resume_command_processing - Resume command processing
+ * @hba: per-adapter instance
+ *
+ * This function resumes command submissions.
+ */
+void ufshcd_resume_command_processing(struct ufs_hba *hba)
+{
+	up_write(&hba->clk_scaling_lock);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
+}
+
 /**
  * ufshcd_scale_gear - scale up/down UFS gear
  * @hba: per adapter instance
-- 
2.34.1

