Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F94110A;
	Thu, 18 Jul 2024 00:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721261900; cv=none; b=uRDLU7qt/3GCAnMudj+uv240Y6MMVHVuwu5u3SPDiaUAQfDrAh/r4F5JXzGlJWoh8VxMh04s/nwfoxERvjwZXQO4mtdo2GjLRSJAGuiQf+fUdHI57437SR4w85wpOgggIgsIUaUEpFX8JyOOh0d4SbAMmKj03kwsaT/ttW30Ey4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721261900; c=relaxed/simple;
	bh=YAdKIdCQxC2OE44k2pU5gFUD9p+GyJ9koCSMZuhusQQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEQjYeOx1+52fYj0ggx4fQASCBtAX9xfs3GkXdMduUP3NNHOzbDdwn44lZSmCz369/RHT16iLySqTYqWvxmyPm7ZAWu7fd8QwmtlAakDEwsEZelZC+HFkHyDrVXc7nAUOd5o/FGUAxa/XFL3PP7jNDZB7BwK1FnhaUodJ/XXUOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Yt7/FCmw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Yt7/FCmw"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46HEwWE5023107;
	Thu, 18 Jul 2024 00:17:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=fUNVu7aXgTOSt3jYuESDirOa
	PpbzxWkbmxCG//zdUck=; b=Yt7/FCmwze61SAtoQCBDlb4zCst6z7f5xuYP7ZEb
	3AvxhWLsON5T8m5fkn14tOBj3Nuv0/sdSeerRqze6xnYva/1TTe8PjajecMqPDco
	APfkKx/SAn9nJU3GI/h75H+san9AU/tutuIkulKyrhy2DOXu4/Ory7kybvHKr/i2
	IYjDEB8PHfOBEiCaEBkLp8FG0WfI7kX3rihac2PyTivHVeOXxoBxcKY8ciHxmQeb
	ENDTxMJ607CwK5dexjevxQKtfW+DC7GGC/WfpyCd0OwpBOjCGrL6AHE7fJv/a/on
	OYiNP/jZji6mmiVrnfyWcYCJ4RyUIvJ2koeMRggRie2rbg==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40dwfnm1s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 00:17:58 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46I0Hv6r015254
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 00:17:57 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 17 Jul 2024 17:17:56 -0700
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
Subject: [PATCH v4 1/1] scsi: ufs: core: Support Updating UIC Command Timeout
Date: Wed, 17 Jul 2024 17:17:34 -0700
Message-ID: <44dc4790b53e2f8aa92568a9e13785e3bedd617d.1721261491.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1721261491.git.quic_nguyenb@quicinc.com>
References: <cover.1721261491.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-GUID: cv-FUhh66BZb4KDgwCRo8l4EzUQTiJHo
X-Proofpoint-ORIG-GUID: cv-FUhh66BZb4KDgwCRo8l4EzUQTiJHo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-17_19,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2407180000

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
---
 drivers/ufs/core/ufshcd.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 21429ee..d66da13 100644
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
@@ -113,6 +115,31 @@ static bool is_mcq_supported(struct ufs_hba *hba)
 module_param(use_mcq_mode, bool, 0644);
 MODULE_PARM_DESC(use_mcq_mode, "Control MCQ mode for controllers starting from UFSHCI 4.0. 1 - enable MCQ, 0 - disable MCQ. MCQ is enabled by default");
 
+static unsigned int uic_cmd_timeout = UIC_CMD_TIMEOUT_DEFAULT;
+
+static int uic_cmd_timeout_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned int n;
+	int ret;
+
+	ret = kstrtou32(val, 0, &n);
+	if (ret != 0 || n < UIC_CMD_TIMEOUT_DEFAULT || n > UIC_CMD_TIMEOUT_MAX)
+		return -EINVAL;
+
+	uic_cmd_timeout = n;
+
+	return 0;
+}
+
+static const struct kernel_param_ops uic_cmd_timeout_ops = {
+	.set = uic_cmd_timeout_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(uic_cmd_timeout, &uic_cmd_timeout_ops, &uic_cmd_timeout, 0644);
+MODULE_PARM_DESC(uic_cmd_timeout,
+		"UFS UIC command timeout in milliseconds. Defaults to 500ms. Supported values range from 500ms to 2 seconds inclusively");
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -2460,7 +2487,7 @@ static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
 {
 	u32 val;
 	int ret = read_poll_timeout(ufshcd_readl, val, val & UIC_COMMAND_READY,
-				    500, UIC_CMD_TIMEOUT * 1000, false, hba,
+				    500, uic_cmd_timeout * 1000, false, hba,
 				    REG_CONTROLLER_STATUS);
 	return ret == 0;
 }
@@ -2520,7 +2547,7 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	lockdep_assert_held(&hba->uic_cmd_mutex);
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
-					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+					msecs_to_jiffies(uic_cmd_timeout))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
 	} else {
 		ret = -ETIMEDOUT;
@@ -4298,7 +4325,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	}
 
 	if (!wait_for_completion_timeout(hba->uic_async_done,
-					 msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+					 msecs_to_jiffies(uic_cmd_timeout))) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
 			cmd->command, cmd->argument3);
-- 
2.7.4

