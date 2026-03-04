Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A98313540;
	Wed,  4 Mar 2026 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772632439; cv=none; b=EPDBGHQ/OrnthTQ7duoci/VZscLWx3IgKZrxoASnGHtjz74g/ZMpH6eF+Ynz87Yum8odilcgOCBNfD5mAPbFVOvC4VSSAKf7213iJXb2vbrTos7KXk4+t4USYgF6x7eAO+x7zz2l00KRhabcaLndETLoxzR/p2EJbqjFdl7V4cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772632439; c=relaxed/simple;
	bh=5kJI6nSGZIDodIuC2pMTjqNZumnBMo2vPuZ/FLXlze0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sWFh6Nj+DPMq/3piEnfbJV0m/kB6zKJF+6HQATvjbfmGvNk5t8t3MAGOXaGDOzDA/t5S6qB9vaZo5GTa7zWPMruOJM625kZvhctMf+5D+r1q1iZrHZYyjS11xEAba+YqQuBiytqDn0NffS+LhsJ61cBy/hH41mwU+capnAplK3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M/pHjRK4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M/pHjRK4"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6249KcO01455832;
	Wed, 4 Mar 2026 13:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=3bLHtHYm6ey
	sbZwlI4DxsM4voWiikSg95ACqx8MyWG0=; b=M/pHjRK4o2Mgh8JSxk13uc0nWag
	gMStFqYrxsnx3UoapmXe1BPHKJtLcqh+oP2/oxWpPOaqheEKrjIdTc7rpa1hxbGT
	6oO3MxzPVFd9mevfg8vnfa96QVz6ULLlulKvmoRnl60k1Xpq2FeoCuS7yGvR9xmf
	4TfUs603EYCVsyrBVM4QekTkJEmaHAIePvP2DyWGzgB8puPKxkeJLOm/tXEELKT6
	TCG8uayi3H2mQlrkJNjO6hQyhn0pxIzcjTi0ieqA4k8DjiXa52VKcBLtqV0Mux4I
	PJUY5oPPozLLYcME+GCktgVwS6C1cZfv6s+QoinlLmDIkF28ndKAxJIfZrw==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cpj180s2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:53:44 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 624DrhbQ005480;
	Wed, 4 Mar 2026 13:53:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4cp8uh03q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:53:43 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 624DrgZN005473;
	Wed, 4 Mar 2026 13:53:42 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 624DrguV005471
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:53:42 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 4CD155A7; Wed,  4 Mar 2026 05:53:42 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Archana Patni <archana.patni@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 02/11] scsi: ufs: core: Pass force_pmc to ufshcd_config_pwr_mode() as a parameter
Date: Wed,  4 Mar 2026 05:53:04 -0800
Message-Id: <20260304135313.413688-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-GUID: _uuo1Q-a_tFnDMc2RyaVMkxEKObfeZEG
X-Proofpoint-ORIG-GUID: _uuo1Q-a_tFnDMc2RyaVMkxEKObfeZEG
X-Authority-Analysis: v=2.4 cv=Ed7FgfmC c=1 sm=1 tr=0 ts=69a83968 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8 a=ufAJUjbdAAAA:8
 a=6ArmoZLjwgQBAUfiQrIA:9 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDExMSBTYWx0ZWRfX2ZzjNb2Blryu
 lezwg+djhlG5KSOyW3hVQCCPTQ7EG+SciD7Kh1f74A2l0K9BLZcOPNR5mhs2Ey0IUyC8UAgZ5ue
 +Y16mNtjwCMMDsv2947pRLZgD8MoV7l9Sn1N2I18p87WMlemG0N9NgOjc07JX2xnKSm/XmOdOfl
 gD5sQA3vsNpe/Gs/Sij2qypSqT+FymjatF8mHSuUm8YgE79nUIyv8XWr7zn2Aw0qYdTW5tcgZag
 syL/3bFrlvS4Y4xXDcG66+5kP4iIRE97twUUgN+av2t14WWhDMtDX7NfbVsrs92XiR06vY+zMtT
 kthiS2sB9V2cojMQG4l+YnG3C+9o9A8MWO2dYqxwoBAqWapupV+FhYgrTVYiuAcT2AToD86ZYc5
 HMkL60WOlAhz8NNeIOeyWW920ngG/T8X43wO0Zbp76osGQd8nGS3JRHyjbpZzL+N0Tjm0ImOqJE
 zZ981JFMbku7Qbtc8aA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_06,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040111

Currently, callers must manually toggle hba->force_pmc before and after
calling ufshcd_config_pwr_mode() to force a Power Mode change. Refactor
ufshcd_config_pwr_mode() to accept force_pmc as a parameter.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c     | 35 ++++++++++++++++++++++-------------
 drivers/ufs/host/ufshcd-pci.c |  3 ++-
 include/ufs/ufshcd.h          | 19 +++++++++++++++----
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c6b9c58fece3..6809564fb507 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1407,7 +1407,8 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up
 
 config_pwr_mode:
 	/* check if the power mode needs to be changed or not? */
-	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
+	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info,
+				     UFSHCD_PMC_POLICY_DONT_FORCE);
 	if (ret)
 		dev_err(hba->dev, "%s: failed err %d, old gear: (tx %d rx %d), new gear: (tx %d rx %d)",
 			__func__, ret,
@@ -4248,7 +4249,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			pwr_mode_change = true;
 		}
 		if (pwr_mode_change) {
-			ret = ufshcd_change_power_mode(hba, &temp_pwr_info);
+			ret = ufshcd_change_power_mode(hba, &temp_pwr_info,
+						       UFSHCD_PMC_POLICY_DONT_FORCE);
 			if (ret)
 				goto out;
 		}
@@ -4272,7 +4274,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 
 	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
 	    && pwr_mode_change)
-		ufshcd_change_power_mode(hba, &orig_pwr_info);
+		ufshcd_change_power_mode(hba, &orig_pwr_info,
+					 UFSHCD_PMC_POLICY_DONT_FORCE);
 out:
 	return ret;
 }
@@ -4661,12 +4664,14 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 }
 
 static int ufshcd_dme_change_power_mode(struct ufs_hba *hba,
-					struct ufs_pa_layer_attr *pwr_mode)
+					struct ufs_pa_layer_attr *pwr_mode,
+					enum ufshcd_pmc_policy pmc_policy)
+
 {
 	int ret;
 
 	/* if already configured to the requested pwr_mode */
-	if (!hba->force_pmc &&
+	if (pmc_policy == UFSHCD_PMC_POLICY_DONT_FORCE &&
 	    pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
 	    pwr_mode->gear_tx == hba->pwr_info.gear_tx &&
 	    pwr_mode->lane_rx == hba->pwr_info.lane_rx &&
@@ -4746,13 +4751,15 @@ static int ufshcd_dme_change_power_mode(struct ufs_hba *hba,
 }
 
 int ufshcd_change_power_mode(struct ufs_hba *hba,
-			     struct ufs_pa_layer_attr *pwr_mode)
+			     struct ufs_pa_layer_attr *pwr_mode,
+			     enum ufshcd_pmc_policy pmc_policy)
+
 {
 	int ret;
 
 	ufshcd_vops_pwr_change_notify(hba, PRE_CHANGE, pwr_mode);
 
-	ret = ufshcd_dme_change_power_mode(hba, pwr_mode);
+	ret = ufshcd_dme_change_power_mode(hba, pwr_mode, pmc_policy);
 
 	if (!ret)
 		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
@@ -4765,11 +4772,13 @@ EXPORT_SYMBOL_GPL(ufshcd_change_power_mode);
  * ufshcd_config_pwr_mode - configure a new power mode
  * @hba: per-adapter instance
  * @desired_pwr_mode: desired power configuration
+ * @pmc_policy: Power Mode change policy
  *
  * Return: 0 upon success; < 0 upon failure.
  */
 int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-		struct ufs_pa_layer_attr *desired_pwr_mode)
+			   struct ufs_pa_layer_attr *desired_pwr_mode,
+			   enum ufshcd_pmc_policy pmc_policy)
 {
 	struct ufs_pa_layer_attr final_params = { 0 };
 	int ret;
@@ -4779,7 +4788,7 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 	if (ret)
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 
-	return ufshcd_change_power_mode(hba, &final_params);
+	return ufshcd_change_power_mode(hba, &final_params, pmc_policy);
 }
 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
 
@@ -6836,14 +6845,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * are sent via bsg and/or sysfs.
 		 */
 		down_write(&hba->clk_scaling_lock);
-		hba->force_pmc = true;
-		pmc_err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
+		pmc_err = ufshcd_config_pwr_mode(hba, &hba->pwr_info,
+						 UFSHCD_PMC_POLICY_FORCE);
 		if (pmc_err) {
 			needs_reset = true;
 			dev_err(hba->dev, "%s: Failed to restore power mode, err = %d\n",
 					__func__, pmc_err);
 		}
-		hba->force_pmc = false;
 		ufshcd_print_pwr_info(hba);
 		up_write(&hba->clk_scaling_lock);
 		spin_lock_irqsave(hba->host->host_lock, flags);
@@ -9118,7 +9126,8 @@ static int ufshcd_post_device_init(struct ufs_hba *hba)
 	if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
 		ufshcd_set_dev_ref_clk(hba);
 	/* Gear up to HS gear. */
-	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
+	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info,
+				     UFSHCD_PMC_POLICY_DONT_FORCE);
 	if (ret) {
 		dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
 			__func__, ret);
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 894b7589b14e..aa5e593769c3 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -154,7 +154,8 @@ static int ufs_intel_set_lanes(struct ufs_hba *hba, u32 lanes)
 
 	pwr_info.lane_rx = lanes;
 	pwr_info.lane_tx = lanes;
-	ret = ufshcd_change_power_mode(hba, &pwr_info);
+	ret = ufshcd_change_power_mode(hba, &pwr_info,
+				       UFSHCD_PMC_POLICY_DONT_FORCE);
 	if (ret)
 		dev_err(hba->dev, "%s: Setting %u lanes, err = %d\n",
 			__func__, lanes, ret);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 51c2555bea73..16facaee3e77 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -529,6 +529,17 @@ enum ufshcd_state {
 	UFSHCD_STATE_ERROR,
 };
 
+/**
+ * enum ufshcd_pmc_policy - Power Mode change policy
+ * @UFSHCD_PMC_POLICY_DONT_FORCE: Do not force a Power Mode change.
+ * @UFSHCD_PMC_POLICY_FORCE: Force a Power Mode change even if current Power
+ *	Mode is same as target Power Mode.
+ */
+enum ufshcd_pmc_policy {
+	UFSHCD_PMC_POLICY_DONT_FORCE,
+	UFSHCD_PMC_POLICY_FORCE,
+};
+
 enum ufshcd_quirks {
 	/* Interrupt aggregation support is broken */
 	UFSHCD_QUIRK_BROKEN_INTR_AGGR			= 1 << 0,
@@ -882,7 +893,6 @@ enum ufshcd_mcq_opr {
  * @saved_uic_err: sticky UIC error mask
  * @ufs_stats: various error counters
  * @force_reset: flag to force eh_work perform a full reset
- * @force_pmc: flag to force a power mode change
  * @silence_err_logs: flag to silence error logs
  * @dev_cmd: ufs device management command information
  * @last_dme_cmd_tstamp: time stamp of the last completed DME command
@@ -1036,7 +1046,6 @@ struct ufs_hba {
 	u32 saved_uic_err;
 	struct ufs_stats ufs_stats;
 	bool force_reset;
-	bool force_pmc;
 	bool silence_err_logs;
 
 	/* Device management request data */
@@ -1363,9 +1372,11 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
 extern int ufshcd_change_power_mode(struct ufs_hba *hba,
-				    struct ufs_pa_layer_attr *pwr_mode);
+				    struct ufs_pa_layer_attr *pwr_mode,
+				    enum ufshcd_pmc_policy pmc_policy);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-			struct ufs_pa_layer_attr *desired_pwr_mode);
+				  struct ufs_pa_layer_attr *desired_pwr_mode,
+				  enum ufshcd_pmc_policy pmc_policy);
 extern int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode);
 
 /* UIC command interfaces for DME primitives */
-- 
2.34.1

