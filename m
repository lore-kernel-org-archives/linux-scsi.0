Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FCB1CA84;
	Tue, 19 Nov 2024 09:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732010214; cv=none; b=gJKTHVZl9QPnfJ/JPvz6idpFXaoxpbDo4ED1dVdjYFrebSlpFPL8nqzQVSdtzU/0LVAcW4v4P6PtBOa0lPQxbso7ytMO/HWLRW9te+uH21NXKL99LMCYpFyT4U06GbyCh6xszxptuJc13l+YDCz/cPU+Fq25Ofqvezv7h36ZOLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732010214; c=relaxed/simple;
	bh=rNbioY60YmAfeHXKaEFRl957jdlmgKKY21yrZbHwMv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tCbn4ZjfMszBbSa2gWie/AFjqPtr90tDwIjhlwOReCHmqwi9P8GzVORPvq+5OI0YJoHv1DRvZbXJv1Uw1dcdRG7/+vwg0Mxbf+drrEKPUj/kUFbDrExCbktWdNDAQcDgWVH5i/A6VxkGbMQq2vopdFJsqU71m4VPxz885ZprU0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=XmwM+75y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="XmwM+75y"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ7j9vW023070;
	Tue, 19 Nov 2024 09:56:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=xUe7R8XKsYNv0mClyqfH8J2phEvtwivmUTM
	75Fl3Sl8=; b=XmwM+75yx8vwq362E0EAxe7Nj8gbnArVN1vp5vnt7LcQ0CLfxQD
	4gRrw6SNCoGu6DvWkB0s8qwF0w0RKUO7npp3O/V42s4kVZ8Op55YhONH7rtv6PzN
	lRbiYgNnfpKmh/8cWRm8KfSuJzJkS/IaMiK91NG6y2wT1LiYsgpuAEawVSboFePC
	hFQB4J/+cxWSrp0UytIgPAkRmnlVhXTn4eDAOIo9MhnycR7/gaQEn/vtuEq5kDAV
	l1BMde0/Wbfjoq3VRsm2b/8tBfn6fDHea+ycaRk7iiVes78VqCKgOa1x54r+A/UF
	hh8kyJi9fTp1QFGDZ0iqGEEriv3C9CXx43g==
Received: from aptaippmta01.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4308y623up-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 09:56:20 +0000 (GMT)
Received: from pps.filterd (APTAIPPMTA01.qualcomm.com [127.0.0.1])
	by APTAIPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ9uJsm002711;
	Tue, 19 Nov 2024 09:56:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APTAIPPMTA01.qualcomm.com (PPS) with ESMTPS id 42xmfkpvgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 09:56:18 +0000
Received: from APTAIPPMTA01.qualcomm.com (APTAIPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AJ9uIhG002706;
	Tue, 19 Nov 2024 09:56:18 GMT
Received: from cbsp-sh-gv.ap.qualcomm.com (CBSP-SH-gv.ap.qualcomm.com [10.231.249.68])
	by APTAIPPMTA01.qualcomm.com (PPS) with ESMTPS id 4AJ9uIe3002705
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 09:56:18 +0000
Received: by cbsp-sh-gv.ap.qualcomm.com (Postfix, from userid 393357)
	id CA91640BED; Tue, 19 Nov 2024 17:56:16 +0800 (CST)
From: Ziqi Chen <quic_ziqichen@quicinc.com>
To: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_ziqichen@quicinc.com,
        quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
        quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        John Garry <john.g.garry@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek)
Subject: [PATCH v3] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS BSG
Date: Tue, 19 Nov 2024 17:56:04 +0800
Message-Id: <20241119095613.121385-1-quic_ziqichen@quicinc.com>
X-Mailer: git-send-email 2.34.1
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
X-Proofpoint-GUID: thBaN9mIu8qL1VUAK4TurLRrwtF8AqJz
X-Proofpoint-ORIG-GUID: thBaN9mIu8qL1VUAK4TurLRrwtF8AqJz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 malwarescore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411190070

User layer applications can send UIC GET/SET commands via the BSG
framework, and if the user layer application sends a UIC SET command
to the PA_PWRMODE attribute, a power mode change shall be initiated
in UniPro and two interrupts shall be triggered if the power mode is
successfully changed, i.e., UIC Command Completion interrupt and UIC
Power Mode interrupt.

The current UFS BSG code calls ufshcd_send_uic_cmd() directly, with
which the second interrupt, i.e., UIC Power Mode interrupt, shall be
treated as unhandled interrupt. In addition, after the UIC command is
completed, user layer application has to poll UniPro and/or M-PHY state
machine to confirm the power mode change is finished.

Add a new wrapper function ufshcd_send_bsg_uic_cmd() and call it from
ufs_bsg_request() so that if a UIC SET command is targeting the PA_PWRMODE
attribute it can be redirected to ufshcd_uic_pwr_ctrl().

Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()")
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
V2 -> V3: Added Fixes tag
V1 -> V2: Rebased on Linux 6.13
---
 drivers/ufs/core/ufs_bsg.c     |  2 +-
 drivers/ufs/core/ufshcd-priv.h |  1 +
 drivers/ufs/core/ufshcd.c      | 36 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 433d0480391e..6c09d97ae006 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -170,7 +170,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
-		ret = ufshcd_send_uic_cmd(hba, &uc);
+		ret = ufshcd_send_bsg_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev, "send uic cmd: error code %d\n", ret);
 
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 7aea8fbaeee8..9ffd94ddf8c7 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -84,6 +84,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e338867bc96c..c01f4b0c1b4f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4319,6 +4319,42 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	return ret;
 }
 
+/**
+ * ufshcd_send_bsg_uic_cmd - Send UIC commands requested via BSG layer and retrieve the result
+ * @hba: per adapter instance
+ * @uic_cmd: UIC command
+ *
+ * Return: 0 only if success.
+ */
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
+{
+	int ret;
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
+	ufshcd_hold(hba);
+
+	if (uic_cmd->argument1 == UIC_ARG_MIB(PA_PWRMODE) &&
+	    uic_cmd->command == UIC_CMD_DME_SET) {
+		ret = ufshcd_uic_pwr_ctrl(hba, uic_cmd);
+		goto out;
+	}
+
+	mutex_lock(&hba->uic_cmd_mutex);
+	ufshcd_add_delay_before_dme_cmd(hba);
+
+	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
+	if (!ret)
+		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
+
+	mutex_unlock(&hba->uic_cmd_mutex);
+
+out:
+	ufshcd_release(hba);
+	return ret;
+}
+
 /**
  * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
  *				using DME_SET primitives.
-- 
2.34.1

