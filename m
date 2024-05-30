Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC1917E44B;
	Thu, 30 May 2024 21:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717105043; cv=none; b=vFqgK/W+k+dtQa0qbX0pRF6fCgGxC0K2Je2NZ2g+DcA1A9XEWJUv9EbQHodsMfDq5dSj35tqx6Vj4DBmWDiLbMBPd7pYzYhP4aQySayP0K4+qyY4Y3gId9sqvU7kU12Q0xPVd4rPmtdtiRN1V7DuSbCmu4WIsM5PvDvcTP+WRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717105043; c=relaxed/simple;
	bh=kOz9/6LQkP9CSOxQHTdge7OzZg1Hp9XmIeXtpkiRE3w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gqRNa/ZxWSRZOufHCiICttnfgkF4cvLKHWAQ/zdS8cu9x28LCPj+NPcFGgLdEH9pgp+oPUH+r8ydxU9YKumcYszIFZGFqIZ6P1cAnDzPtNxQbpf3jQ/TXnwA5jq3qH+aU9I75xOrMtZ3udCVExy0J5KFAC4peSqDL5HaMhvUwtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=CHiji9zX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="CHiji9zX"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44UJ5H0O006252;
	Thu, 30 May 2024 21:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=RZi6nDtYWvhHwRM+mTndKJi+
	RyK0uOvSiCqdPVYIzyw=; b=CHiji9zXeMYVwhJOuHRQKKZ7yvQCuCMFLCz4LA+G
	8YB6yuQQycz0M0IR6GYdARke4va+Ys7TfsxBcklOCoU0qO2pw1vmoSLeicNpcvxr
	8pGiCPNYwBFzd+vaScEv6thVNKL2vaoBm5HG69IkYKkjVQg2Mi2mk7IFchl03rZe
	txex46cY4BIjlOpXr+Lq2MlRTXpRMmhYKjcbA8kVvfMP53q1fsICfc68/ApxuIJF
	M2L0O/+PSrXEdUcGRzdJlhzISm4AdepdNxo5PdW78W2/f7I775hI5VZAExpSX9rZ
	obOpa6fTC7WfGAh6Q69li0b6IcrIRqdMq2JRB9Nc2dM7Dw==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yba2hd1kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 21:37:02 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44ULb1P7004386
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 21:37:01 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 30 May 2024 14:37:00 -0700
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
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] scsi: ufs: core: Support Updating UIC Command Timeout
Date: Thu, 30 May 2024 14:36:40 -0700
Message-ID: <f3fded35cb250e16ee5aaa67d7a7288fe2799fd7.1717104518.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1717104518.git.quic_nguyenb@quicinc.com>
References: <cover.1717104518.git.quic_nguyenb@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: HYhdorVU4uqLEFK2NA3h_ZLWI-hZ2b8K
X-Proofpoint-ORIG-GUID: HYhdorVU4uqLEFK2NA3h_ZLWI-hZ2b8K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_17,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405300162

The default UIC command timeout still remains 500ms.
Allow platform drivers to override the UIC command
timeout if desired.

In a real product, the 500ms timeout value is probably good enough.
However, during the product development where there are a lot of
logging and debug messages being printed to the uart console,
interrupt starvations happen occasionally because the uart may
print long debug messages from different modules in the system.
While printing, the uart may have interrupts disabled for more
than 500ms, causing UIC command timeout.
The UIC command timeout would trigger more printing from
the UFS driver, and eventually a watchdog timeout may
occur unnecessarily.

Add support for overriding the UIC command timeout value
with the newly created uic_cmd_timeout kernel module parameter.
Default value is 500ms. Supported values range from 500ms
to 2 seconds.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 21429ee..92f1ed46 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -51,8 +51,10 @@
 
 
 /* UIC command timeout, unit: ms */
-#define UIC_CMD_TIMEOUT	500
-
+enum {
+	UIC_CMD_TIMEOUT		= 500,
+	UIC_CMD_TIMEOUT_MAX	= 2000,
+};
 /* NOP OUT retries waiting for NOP IN response */
 #define NOP_OUT_RETRIES    10
 /* Timeout after 50 msecs if NOP OUT hangs without response */
@@ -113,6 +115,29 @@ static bool is_mcq_supported(struct ufs_hba *hba)
 module_param(use_mcq_mode, bool, 0644);
 MODULE_PARM_DESC(use_mcq_mode, "Control MCQ mode for controllers starting from UFSHCI 4.0. 1 - enable MCQ, 0 - disable MCQ. MCQ is enabled by default");
 
+static int uic_cmd_timeout_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned int n;
+	int ret;
+
+	ret = kstrtou32(val, 0, &n);
+	if (ret != 0 || n < UIC_CMD_TIMEOUT || n > UIC_CMD_TIMEOUT_MAX)
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
+static const struct kernel_param_ops uic_cmd_timeout_ops = {
+	.set = uic_cmd_timeout_set,
+	.get = param_get_uint,
+};
+
+static unsigned int uic_cmd_timeout = UIC_CMD_TIMEOUT;
+module_param_cb(uic_cmd_timeout, &uic_cmd_timeout_ops, &uic_cmd_timeout, 0644);
+MODULE_PARM_DESC(uic_cmd_timeout,
+		"UFS UIC command timeout in milliseconds. Default to 500ms. Supported values range from 500ms to 2 seconds inclusively");
+
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -2460,7 +2485,7 @@ static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
 {
 	u32 val;
 	int ret = read_poll_timeout(ufshcd_readl, val, val & UIC_COMMAND_READY,
-				    500, UIC_CMD_TIMEOUT * 1000, false, hba,
+				    500, uic_cmd_timeout * 1000, false, hba,
 				    REG_CONTROLLER_STATUS);
 	return ret == 0;
 }
@@ -2520,7 +2545,7 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	lockdep_assert_held(&hba->uic_cmd_mutex);
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
-					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+					msecs_to_jiffies(uic_cmd_timeout))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
 	} else {
 		ret = -ETIMEDOUT;
@@ -4298,7 +4323,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	}
 
 	if (!wait_for_completion_timeout(hba->uic_async_done,
-					 msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+					 msecs_to_jiffies(uic_cmd_timeout))) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
 			cmd->command, cmd->argument3);
-- 
2.7.4

