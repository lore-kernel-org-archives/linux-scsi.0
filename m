Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CBC28E8;
	Wed, 24 Jul 2024 03:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721793023; cv=none; b=FAAYn7IDeG+PW+92GHcdxWCpyOvF4wqP+TDmqJ/rCia4s4DJLHz5owmkLs9VUs5JYnbnHbCKzjlvZTCZjKGMp0kt+CG4rIg29wMz6KVbBdwmvsE6eVKt7UPZdmYwbqUK9ngvv4aVZvTWiZWmImXqLtiBjanUP69mc0GaKjOgvbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721793023; c=relaxed/simple;
	bh=1xaaCUMQJXj7AZcY/jkTHVdgk92IBQUS9VOygUtrflc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNbqy4MfWN9F5wsymD9OWGdXC8Cndl6C2q9ezQ/RO4EbbOk5kJwRTw6o2rNmxMRJWuEPRIYJ18N/luhKCI22zAJnGtQMTjHi7AESYwvOQKpNdtfpAfzb4WH5kPFMFhjMe5+BsQebjr3rND6cKvl69n4Tno6PSMCHvKi2DWeSBJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=QhTyMtEr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="QhTyMtEr"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46NItV5i016040;
	Wed, 24 Jul 2024 03:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=roiulyFFQEZJy10DwwAaZPIN
	HITRUycPJUBcSPajxIE=; b=QhTyMtErt4u7pWsqaQ+wZT5vlqIEskYh33FeCL6g
	+E6Kv+YmddBi7SRQo6Wbmp4BrxP1V++MaHCebJ3g3IrTXUWW4wTsyVtIFzTAvZwk
	ZG2p2GbBaOPcHRg/8oJL5lp7tVdYlWI0L8JVpAiERcmzqoa/ffOiH4qRdVqr85hp
	K6dzLGDm8+84SNlZvGAexcA9qTR0wwPI3rM/rraK46e7xgxf82A7IAbgUGrJjcKa
	8P5cPUCegaHizlLrR1YojG7IsAINh3Oh/KNWuihdQoqWVW7KkBwLPsizO7f1Uo/c
	VwCWhQ+OsHabrScXPS1OitqU49sTDaimb+NaraXGqDAcRg==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40g46s8v73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jul 2024 03:50:08 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46O3o7Av011707
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jul 2024 03:50:07 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Tue, 23 Jul 2024 20:50:07 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <minwoo.im@samsung.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Maramaina Naresh
	<quic_mnaresh@quicinc.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 1/1] scsi: ufs: core: Support Updating UIC Command Timeout
Date: Tue, 23 Jul 2024 20:49:32 -0700
Message-ID: <e4e1c87f3f867f270a3d4b5d57a00139ff0e9741.1721792309.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1721792309.git.quic_nguyenb@quicinc.com>
References: <cover.1721792309.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-GUID: rJUJHF2u9J709PWOooWsTlqijU-gBJ8f
X-Proofpoint-ORIG-GUID: rJUJHF2u9J709PWOooWsTlqijU-gBJ8f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-24_01,2024-07-23_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407240027

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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/core/ufshcd.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 21429ee..526d542 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -51,8 +51,10 @@
 
 
 /* UIC command timeout, unit: ms */
-#define UIC_CMD_TIMEOUT	500
-
+enum {
+	UIC_CMD_TIMEOUT_DEFAULT	= 500,
+	UIC_CMD_TIMEOUT_MAX	= 2000,
+};
 /* NOP OUT retries waiting for NOP IN response */
 #define NOP_OUT_RETRIES    10
 /* Timeout after 50 msecs if NOP OUT hangs without response */
@@ -113,6 +115,23 @@ static bool is_mcq_supported(struct ufs_hba *hba)
 module_param(use_mcq_mode, bool, 0644);
 MODULE_PARM_DESC(use_mcq_mode, "Control MCQ mode for controllers starting from UFSHCI 4.0. 1 - enable MCQ, 0 - disable MCQ. MCQ is enabled by default");
 
+static unsigned int uic_cmd_timeout = UIC_CMD_TIMEOUT_DEFAULT;
+
+static int uic_cmd_timeout_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, UIC_CMD_TIMEOUT_DEFAULT,
+				     UIC_CMD_TIMEOUT_MAX);
+}
+
+static const struct kernel_param_ops uic_cmd_timeout_ops = {
+	.set = uic_cmd_timeout_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(uic_cmd_timeout, &uic_cmd_timeout_ops, &uic_cmd_timeout, 0644);
+MODULE_PARM_DESC(uic_cmd_timeout,
+		 "UFS UIC command timeout in milliseconds. Defaults to 500ms. Supported values range from 500ms to 2 seconds inclusively");
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -2460,7 +2479,7 @@ static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
 {
 	u32 val;
 	int ret = read_poll_timeout(ufshcd_readl, val, val & UIC_COMMAND_READY,
-				    500, UIC_CMD_TIMEOUT * 1000, false, hba,
+				    500, uic_cmd_timeout * 1000, false, hba,
 				    REG_CONTROLLER_STATUS);
 	return ret == 0;
 }
@@ -2520,7 +2539,7 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	lockdep_assert_held(&hba->uic_cmd_mutex);
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
-					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+					msecs_to_jiffies(uic_cmd_timeout))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
 	} else {
 		ret = -ETIMEDOUT;
@@ -4298,7 +4317,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	}
 
 	if (!wait_for_completion_timeout(hba->uic_async_done,
-					 msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+					 msecs_to_jiffies(uic_cmd_timeout))) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
 			cmd->command, cmd->argument3);
-- 
2.7.4

