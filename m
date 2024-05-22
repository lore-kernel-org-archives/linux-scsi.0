Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03067CF30;
	Wed, 22 May 2024 07:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716361336; cv=none; b=X27w4ynTI0Qr7pCTvESCXdGBrRo5HOL5+bpi5Xsva+A5oOMRrSxhmEg+GBgUFCqtaQVft/+M2d90KQSC36mozw+QPLu+z7+XyCY0lU2SDvWLQjy9qrKRYWdp+y07m1YuYer1FTBj5ELiMkjTQv2+aJTKDSordt67YFG4YKDK7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716361336; c=relaxed/simple;
	bh=fwaRCWvzPvI1UmPHLUZKAImIxm8Wv7EvZHtxRXetqwc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/apSQHvfZUc3Mv4gCrU8VXJkBMI/NfRjeyCg42v+RGxpbcMXaQjzRH3i93J3MBAXoocbULjyq5rXWiP1H6c8VMCNfxYkIfFwIxLmYNnZHLGqz/OzRvocmQNHTlMkdIIRbDFN90IVwFhoZDGyJrs3/8g34fHaUaEK+MVXxAmAE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=DD+jnv9q; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="DD+jnv9q"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44M2lb74021188;
	Wed, 22 May 2024 07:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type; s=qcppdkim1; bh=+RQpj1uiYR9HcyCBb06k
	V7GZV1kTw9b4x8ql1LSTPLs=; b=DD+jnv9qvMyi2gAG1UtqQhlmIjzS5CKTcKQT
	CCtrBkG92yP4bf3Ji57p+cWNIgU4i8SF4M4C9WbzcmQoHcTmALM62j4SAqqgEXei
	fSAyGIWZLS+oDv8W5Vvu4N8Dz5oV8mGhUC/mpfcOVzzrF025xoBT8CgZeLWjkFLL
	lbNHznu6RYCGrJNdGg39yVa+/vUxtHkKJT+3NPkSKkUQkCoC33FldXVMFV3WFcu7
	Dj8HL+ERsqQZsWRQOb2VJF22GsLIcemJlkk2eqxF/3000iq7kiTXQqUd5MH8BPKp
	F7b7qg/fliOD2X9hLbacZJPbGwLE54pHbxNY5Wkoa6aSt3BDOQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3y6psnfyk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 07:01:55 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44M71sBb015306
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 07:01:54 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 22 May 2024 00:01:53 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        open list
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/2] scsi: ufs: core: Support Updating UIC Command Timeout
Date: Wed, 22 May 2024 00:01:27 -0700
Message-ID: <292d7702e946ca513af51236ca9e38bf1b1eb269.1716359578.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1716359578.git.quic_nguyenb@quicinc.com>
References: <cover.1716359578.git.quic_nguyenb@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: sSGXS21wCljIOqtcj_TPU4pgcgI6DcKR
X-Proofpoint-ORIG-GUID: sSGXS21wCljIOqtcj_TPU4pgcgI6DcKR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_03,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 clxscore=1011 priorityscore=1501 suspectscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405010000 definitions=main-2405220050

The default UIC command timeout still remains 500ms.
Allow vendor drivers to override the UIC command timeout if desired.

In a real product, the 500ms timeout value is probably good enough.
However, during the product development where there are a lot of
logging and debug messages being printed to the uart console,
interrupt starvations happen occasionally because the uart may
print long debug messages from different modules in the system.
While printing, the uart may have interrupts disabled for more
than 500ms, causing UIC command timeout.
The UIC command timeout would trigger more printing from the
UFS driver, and eventually a watchdog timeout may occur unnecessarily.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 9 ++++++---
 include/ufs/ufshcd.h      | 2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 21429ee..c440caf 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2460,7 +2460,7 @@ static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
 {
 	u32 val;
 	int ret = read_poll_timeout(ufshcd_readl, val, val & UIC_COMMAND_READY,
-				    500, UIC_CMD_TIMEOUT * 1000, false, hba,
+				    500, hba->uic_cmd_timeout * 1000, false, hba,
 				    REG_CONTROLLER_STATUS);
 	return ret == 0;
 }
@@ -2520,7 +2520,7 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	lockdep_assert_held(&hba->uic_cmd_mutex);
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
-					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+					msecs_to_jiffies(hba->uic_cmd_timeout))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
 	} else {
 		ret = -ETIMEDOUT;
@@ -4298,7 +4298,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	}
 
 	if (!wait_for_completion_timeout(hba->uic_async_done,
-					 msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+					 msecs_to_jiffies(hba->uic_cmd_timeout))) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
 			cmd->command, cmd->argument3);
@@ -10690,6 +10690,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
 	}
 
+	if (!hba->uic_cmd_timeout)
+		hba->uic_cmd_timeout = UIC_CMD_TIMEOUT;
+
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
 	atomic_set(&hba->scsi_block_reqs_cnt, 0);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a35e12f..47e3bdf 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -917,6 +917,7 @@ enum ufshcd_mcq_opr {
  * @ufs_rtc_update_work: A work for UFS RTC periodic update
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
+ * @uic_cmd_timeout: timeout in ms for UIC commands
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1085,6 +1086,7 @@ struct ufs_hba {
 	struct delayed_work ufs_rtc_update_work;
 	struct pm_qos_request pm_qos_req;
 	bool pm_qos_enabled;
+	u32 uic_cmd_timeout;
 };
 
 /**
-- 
2.7.4

