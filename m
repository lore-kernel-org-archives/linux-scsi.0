Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF55C44A721;
	Fri, 27 Feb 2026 16:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208550; cv=none; b=IhQaCR0j9dRSipYUQ2EJxZxEvXL8tMA223iHY533Ihhh7w7sDcVsfyLQ7P3i4CrMfTCSeDCdnzskypKBgYR++Cj9fSkKWPMW287sCKfUge7wAWwD52acIpo3Bgg2HaekHgXntfYGVoYBql/rZmtCfiEoexNSoqTZlfPBArr8Pu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208550; c=relaxed/simple;
	bh=nHP72g6ceK7RPudd+NxJyvmfeGl88C5ut4pE4yDwtP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hx13Ql4QN115yYZKyicB0DZAmcXGjZ1Cs517C/WvB0VH42ylbZijFclHSRwqUZVFg1MaQZNeGlGYIKbcQtpyq7VN3VLrfHEHzAb7JqzRi7f59vobhMcZ+//JaKmSe9cLs01jqGhTxTOSWsvZhD76/FvxGmZzv3AMNfvzhMTeZE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=db70FU9B; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="db70FU9B"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61REaRhf3628557;
	Fri, 27 Feb 2026 16:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=6c0e/ax9d21
	8TIY2/Yv25KNzqXGQJikybL9/H7+9zvY=; b=db70FU9BvbgNKzxOGkBGC5mDvC9
	D+gefqKg3XxmUmOxCrcBIyfNV2/Gaen/nTRyrrAqgybUmBLvVFB+46y70/MR1oiO
	Y8c1ETpyamS4lX2/vNTCp0UWQxJMzGh2U7atgepI/ZkA2wf8VLFS4F4tLquhQrkI
	ED4PETe9uSf4wAFwbYi8lrPGrBSWZ37bxVq9KDWrZtbHW1OUvtnz7Olzlzpbxfc3
	h/zz2SteTyQRh3s8n8bRf2I0BV7m190nFOR93tKuGH37nnCBV3di2gkd/fdqQct/
	3KxGc4qpYavtrt1yXpzoSd8S0ygsRrAy8Z8wj5/VDtyJrOJ7in9pwP/GxSA==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ck73q1j7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:52 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61RG8ZPa024025;
	Fri, 27 Feb 2026 16:08:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4cjf89aa95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:51 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61RG8ok8024138;
	Fri, 27 Feb 2026 16:08:51 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 61RG8oh8024126
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:50 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id A00C05A0; Fri, 27 Feb 2026 08:08:50 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 04/11] scsi: ufs: core: Add support for TX Equalization
Date: Fri, 27 Feb 2026 08:08:01 -0800
Message-Id: <20260227160809.2620598-5-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0NCBTYWx0ZWRfX+5faJW8BEmWM
 PDMuJhtMikSDZH9iy6xrRbO0wWC8ZCzEh94PiLqJEsglENTM30aDLRN0a1ICh3aPx4DMwflC6Hc
 d8umKAST2a6CrcOwZZ/AIf/N3Nf3efijuUQrbLr6Z/avEJ+qBuxq8eQ1z78Zbi1Vz7XxSE/S4UE
 Pg/MJQnT6EoJuFXzhIu+LrlMBE8JalLidUPXbpluQxsCHcdZw1OJRMFbphXvLx1xGAPkL9ohwyN
 OS7mvPqeOdpqE6AXzByuocNnE+8DZmWvW3v2tEJDOKdvUgHbpJm59KcjhTpRWd7MgTuPNcOecv6
 gMYPQPVZ4FRiNPvlDLlcpHJtG2n6ZxwOQfZMZ2JniKjsFUMWwGSu590f7TUi0DM18P4WqX/F477
 92e5vrqA2XYf20H3A2BF0uOC1BS3gI4IhpERTsvmUiYbHwPZYUIKPFtNzu+q4luyHy0xhi3jDTh
 o2FQkLB8IPdLm9KYl1Q==
X-Authority-Analysis: v=2.4 cv=KL9XzVFo c=1 sm=1 tr=0 ts=69a1c194 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8 a=ufAJUjbdAAAA:8
 a=Xf0mJroNzK2cDH0CjowA:9 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-ORIG-GUID: _16xEAktKP9pWQ8lpZS9coHTagnHFkcj
X-Proofpoint-GUID: _16xEAktKP9pWQ8lpZS9coHTagnHFkcj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_03,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 malwarescore=0 priorityscore=1501 adultscore=0
 bulkscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270144

MIPI Unipro3.0 introduced PA_TxEQGnSetting and PA_PreCodeEn attributes for
TX Equalization and Pre-Coding. It is Host Software's responsibility to
configure these attributes for both host and device before initiating
Power Mode Change to High-Speed Gears.

MIPI Unipro3.0 also introduced TX Equalization Training (EQTR) to identify
optimal TX Equalization settings for use by both Host's and Device's
UniPro. TX EQTR shall be initiated from the most reliable High-Speed Gear
(HS-G1) targeting High-Speed Gears (HS-G4 to HS-G6).

Implement TX Equalization configuration and TX EQTR procedure as defined
in UFSHCI v5.0 specification. The TX EQTR procedure determines the optimal
TX Equalization settings by iterating through all possible PreShoot and
DeEmphasis combinations and selecting the best combinations for both Host
and Device based on Figure of Merit (FOM) evaluation.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/Makefile      |    2 +-
 drivers/ufs/core/ufs-txeq.c    | 1180 ++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |   39 ++
 drivers/ufs/core/ufshcd.c      |   52 +-
 include/ufs/ufshcd.h           |  108 +++
 include/ufs/unipro.h           |  246 +++++--
 6 files changed, 1555 insertions(+), 72 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-txeq.c

diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
index 51e1867e524e..ce7d16d2cf35 100644
--- a/drivers/ufs/core/Makefile
+++ b/drivers/ufs/core/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
-ufshcd-core-y				+= ufshcd.o ufs-sysfs.o ufs-mcq.o
+ufshcd-core-y				+= ufshcd.o ufs-sysfs.o ufs-mcq.o ufs-txeq.o
 ufshcd-core-$(CONFIG_RPMB)		+= ufs-rpmb.o
 ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
new file mode 100644
index 000000000000..1eaaca7c34a4
--- /dev/null
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -0,0 +1,1180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Qualcomm Technologies, Inc.
+ *
+ * Author:
+ *	Can Guo <can.guo@oss.qualcomm.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <ufs/ufshcd.h>
+#include <ufs/unipro.h>
+#include "ufshcd-priv.h"
+
+static bool use_adaptive_txeq;
+module_param(use_adaptive_txeq, bool, 0644);
+MODULE_PARM_DESC(use_adaptive_txeq, "Find and apply optimal TX Equalization settings before power mode change (default: false)");
+
+static int txeq_gear_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, UFS_HS_G1, UFS_HS_G6);
+}
+
+static const struct kernel_param_ops txeq_gear_ops = {
+	.set = txeq_gear_set,
+	.get = param_get_uint,
+};
+
+static unsigned int adaptive_txeq_gear = UFS_HS_G6;
+module_param_cb(adaptive_txeq_gear, &txeq_gear_ops, &adaptive_txeq_gear, 0644);
+MODULE_PARM_DESC(adaptive_txeq_gear, "For the HS-Gear[n] and above, adaptive txeq shall be used");
+
+static bool use_txeq_presets = true;
+module_param(use_txeq_presets, bool, 0644);
+MODULE_PARM_DESC(use_txeq_presets, "Use only the 8 TX Equalization Presets (pre-defined Pre-Shoot & De-Emphasis combinations) for TX EQTR (default: true)");
+
+static bool txeq_presets_selected[UFS_TX_EQ_PRESET_MAX] = {[0 ... (UFS_TX_EQ_PRESET_MAX - 1)] = 1};
+module_param_array(txeq_presets_selected, bool, NULL, 0644);
+MODULE_PARM_DESC(txeq_presets_selected, "Use only the selected Presets out of the 8 TX Equalization Presets for TX EQTR");
+
+/* A HS-G6 capable M-TX shall support the presets. */
+static const struct __ufs_tx_eq_preset {
+	unsigned int preshoot;
+	unsigned int deemphasis;
+} ufs_tx_eq_preset[UFS_TX_EQ_PRESET_MAX] = {
+	[UFS_TX_EQ_PRESET_P0] = {UFS_TX_HS_PRESHOOT_DB_0P0, UFS_TX_HS_DEEMPHASIS_DB_0P0},
+	[UFS_TX_EQ_PRESET_P1] = {UFS_TX_HS_PRESHOOT_DB_0P0, UFS_TX_HS_DEEMPHASIS_DB_0P8},
+	[UFS_TX_EQ_PRESET_P2] = {UFS_TX_HS_PRESHOOT_DB_0P0, UFS_TX_HS_DEEMPHASIS_DB_1P6},
+	[UFS_TX_EQ_PRESET_P3] = {UFS_TX_HS_PRESHOOT_DB_0P8, UFS_TX_HS_DEEMPHASIS_DB_0P0},
+	[UFS_TX_EQ_PRESET_P4] = {UFS_TX_HS_PRESHOOT_DB_1P6, UFS_TX_HS_DEEMPHASIS_DB_0P0},
+	[UFS_TX_EQ_PRESET_P5] = {UFS_TX_HS_PRESHOOT_DB_0P8, UFS_TX_HS_DEEMPHASIS_DB_0P8},
+	[UFS_TX_EQ_PRESET_P6] = {UFS_TX_HS_PRESHOOT_DB_0P8, UFS_TX_HS_DEEMPHASIS_DB_1P6},
+	[UFS_TX_EQ_PRESET_P7] = {UFS_TX_HS_PRESHOOT_DB_1P6, UFS_TX_HS_DEEMPHASIS_DB_0P8},
+};
+
+static const u32 pa_peer_rx_adapt_initial[UFS_HS_GEAR_MAX] = {
+	0,
+	0,
+	0,
+	0,
+	PA_PEERRXHSG4ADAPTINITIAL,
+	PA_PEERRXHSG5ADAPTINITIAL,
+	PA_PEERRXHSG6ADAPTINITIALL0L3
+};
+
+static const u32 rx_adapt_initial_cap[UFS_HS_GEAR_MAX] = {
+	0,
+	0,
+	0,
+	0,
+	RX_HS_G4_ADAPT_INITIAL_CAP,
+	RX_HS_G5_ADAPT_INITIAL_CAP,
+	RX_HS_G6_ADAPT_INITIAL_CAP
+};
+
+static const u32 pa_tx_eq_setting[UFS_HS_GEAR_MAX] = {
+	0,
+	PA_TXEQG1SETTING,
+	PA_TXEQG2SETTING,
+	PA_TXEQG3SETTING,
+	PA_TXEQG4SETTING,
+	PA_TXEQG5SETTING,
+	PA_TXEQG6SETTING
+};
+
+/**
+ * ufshcd_configure_precoding - Configure Pre-Coding for all active lanes
+ * @hba: per adapter instance
+ * @params: TX EQ parameters data structure
+ *
+ * Bit[7] in RX_FOM indicates that the receiver needs to enable Pre-Coding when
+ * set. Pre-Coding must be enabled on both the transmitter and receiver to
+ * ensure proper operation.
+ *
+ * Returns 0 on success, negative error code otherwise
+ */
+static int ufshcd_configure_precoding(struct ufs_hba *hba,
+				      struct ufshcd_tx_eq_params *params)
+{
+	u32 local_precodeen = 0;
+	u32 peer_precodeen = 0;
+	int lane, ret = 0;
+
+	/* Enable Pre-Coding for Host's TX & Device's RX pair */
+	for (lane = 0; lane < params->tx_lanes; lane++) {
+		if (params->host[lane].precode_en) {
+			local_precodeen |= PRECODEEN_TX_BIT(lane);
+			peer_precodeen |= PRECODEEN_RX_BIT(lane);
+		}
+	}
+
+	/* Enable Pre-Coding for Device's TX & Host's RX pair */
+	for (lane = 0; lane < params->rx_lanes; lane++) {
+		if (params->device[lane].precode_en) {
+			peer_precodeen |= PRECODEEN_TX_BIT(lane);
+			local_precodeen |= PRECODEEN_RX_BIT(lane);
+		}
+	}
+
+	if (!local_precodeen && !peer_precodeen) {
+		dev_dbg(hba->dev, "Pre-Coding is not required for either side\n");
+		return ret;
+	}
+
+	/* Set local PA_PreCodeEn */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PRECODEEN), local_precodeen);
+	if (ret) {
+		dev_err(hba->dev, "Failed to set local PA_PreCodeEn: %d\n",
+			ret);
+		return ret;
+	}
+
+	/* Set peer PA_PreCodeEn */
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(PA_PRECODEEN), peer_precodeen);
+	if (ret) {
+		dev_err(hba->dev, "Failed to set peer PA_PreCodeEn: %d\n",
+			ret);
+		return ret;
+	}
+
+	dev_dbg(hba->dev, "Pre-Coding configured - Local PA_PreCodeEn: 0x%02x, Peer PA_PreCodeEn: 0x%02x\n",
+		local_precodeen, peer_precodeen);
+
+	return ret;
+}
+
+void ufshcd_print_tx_eq_params(struct ufs_hba *hba)
+{
+	struct ufshcd_tx_eq_params *params;
+	u32 gear = hba->pwr_info.gear_tx;
+	int lane;
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return;
+
+	if (gear < UFS_HS_G1 || gear >= UFS_HS_GEAR_MAX)
+		return;
+
+	params = &hba->tx_eq_params[gear - 1];
+	if (!params->is_valid || !params->is_applied)
+		return;
+
+	for (lane = 0; lane < params->tx_lanes; lane++)
+		dev_dbg(hba->dev, "Host TX Equalization params: Lane %u - PreShoot %u, DeEmphasis %u, FOM value %u, PreCodeEn %d\n",
+			lane, params->host[lane].preshoot,
+			params->host[lane].deemphasis,
+			params->host[lane].fom_val,
+			params->host[lane].precode_en);
+
+	for (lane = 0; lane < params->rx_lanes; lane++)
+		dev_dbg(hba->dev, "Device TX Equalization params: Lane %u - PreShoot %u, DeEmphasis %u, FOM value %u, PreCodeEn %d\n",
+			lane, params->device[lane].preshoot,
+			params->device[lane].deemphasis,
+			params->device[lane].fom_val,
+			params->device[lane].precode_en);
+}
+
+static inline u32
+ufshcd_compose_tx_eq_setting(struct ufshcd_tx_eq_settings *settings,
+			     int num_lanes)
+{
+	u32 setting = 0;
+	int lane;
+
+	for (lane = 0; lane < num_lanes; lane++, settings++) {
+		setting |= TX_HS_PRESHOOT_BITS(lane, settings->preshoot);
+		setting |= TX_HS_DEEMPHASIS_BITS(lane, settings->deemphasis);
+	}
+
+	return setting;
+}
+
+/**
+ * ufshcd_apply_tx_eq_settings - Apply TX Equalization settings for target gear
+ * @hba: per adapter instance
+ * @params: TX EQ parameters data structure
+ * @gear: target gear
+ *
+ * Returns 0 on success, negative error code otherwise
+ */
+static int ufshcd_apply_tx_eq_settings(struct ufs_hba *hba,
+				       struct ufshcd_tx_eq_params *params,
+				       u32 gear)
+{
+	u32 setting;
+	int ret;
+
+	/* Compose settings for Host's TX Lanes */
+	setting = ufshcd_compose_tx_eq_setting(params->host, params->tx_lanes);
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(pa_tx_eq_setting[gear]), setting);
+	if (ret)
+		return ret;
+
+	/* Compose settings for Device's TX Lanes */
+	setting = ufshcd_compose_tx_eq_setting(params->device, params->rx_lanes);
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(pa_tx_eq_setting[gear]),
+				  setting);
+	if (ret)
+		return ret;
+
+	/* Configure Pre-Coding */
+	if (gear >= UFS_HS_G6) {
+		ret = ufshcd_configure_precoding(hba, params);
+		if (ret) {
+			dev_err(hba->dev, "Failed to configure pre-coding: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * ufshcd_evaluate_fom - Update TX EQ params based on FOM results
+ * @hba: per adapter instance
+ * @params: TX EQ parameters data structure
+ * @h_iter: host TX EQTR iterator data structure
+ * @d_iter: device TX EQTR iterator data structure
+ *
+ * Evaluate FOM results, update host and device TX EQ params if FOM results are
+ * improved, and record TX EQTR results.
+ */
+static void ufshcd_evaluate_fom(struct ufs_hba *hba,
+				struct ufshcd_tx_eq_params *params,
+				struct tx_eqtr_iter *h_iter,
+				struct tx_eqtr_iter *d_iter)
+{
+	u32 preshoot, deemphasis, fom_value;
+	bool precode_en;
+	int lane;
+
+	for (lane = 0; h_iter->is_new && lane < h_iter->num_lanes; lane++) {
+		preshoot = h_iter->preshoot;
+		deemphasis = h_iter->deemphasis;
+		fom_value = h_iter->fom[lane] & RX_FOM_VALUE_MASK;
+		precode_en = !!(h_iter->fom[lane] & RX_FOM_PRECODING_EN_MASK);
+
+		/* Record host TX EQTR result */
+		params->host_eqtr_record[lane][preshoot][deemphasis] = h_iter->fom[lane];
+
+		/* Check if FOM is improved for host's TX Lanes */
+		if (fom_value > params->host[lane].fom_val) {
+			params->host[lane].preshoot = preshoot;
+			params->host[lane].deemphasis = deemphasis;
+			params->host[lane].fom_val = fom_value;
+			params->host[lane].precode_en = precode_en;
+		}
+
+		dev_dbg(hba->dev, "Host TX EQTR: Lane %u - PreShoot %u, DeEmphasis %u, FOM value %u, PreCodeEn %d\n",
+			lane, preshoot, deemphasis, fom_value, precode_en);
+	}
+
+	for (lane = 0; d_iter->is_new && lane < d_iter->num_lanes; lane++) {
+		preshoot = d_iter->preshoot;
+		deemphasis = d_iter->deemphasis;
+		fom_value = d_iter->fom[lane] & RX_FOM_VALUE_MASK;
+		precode_en = !!(d_iter->fom[lane] & RX_FOM_PRECODING_EN_MASK);
+
+		/* Record device TX EQTR result */
+		params->device_eqtr_record[lane][preshoot][deemphasis] = d_iter->fom[lane];
+
+		/* Check if FOM is improved for Device's TX Lanes */
+		if (fom_value > params->device[lane].fom_val) {
+			params->device[lane].preshoot = preshoot;
+			params->device[lane].deemphasis = deemphasis;
+			params->device[lane].fom_val = fom_value;
+			params->device[lane].precode_en = precode_en;
+		}
+
+		dev_dbg(hba->dev, "Device TX EQTR: Lane %u - PreShoot %u, DeEmphasis %u, FOM value %u, PreCodeEn %d\n",
+			lane, preshoot, deemphasis, fom_value, precode_en);
+	}
+}
+
+/**
+ * ufshcd_get_rx_fom - Get Figure of Merit (FOM) for both sides
+ * @hba: per adapter instance
+ * @pwr_mode: target power mode containing gear and rate information
+ * @h_iter: host TX EQTR iterator data structure
+ * @d_iter: device TX EQTR iterator data structure
+ *
+ * Returns 0 on success, negative error code otherwise
+ */
+static int ufshcd_get_rx_fom(struct ufs_hba *hba,
+			     struct ufs_pa_layer_attr *pwr_mode,
+			     struct tx_eqtr_iter *h_iter,
+			     struct tx_eqtr_iter *d_iter)
+{
+	int lane, ret;
+
+	/* Get FOM of host's TX lanes from device's RX_FOM. */
+	for (lane = 0; lane < h_iter->num_lanes; lane++) {
+		ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
+					  UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
+					  &h_iter->fom[lane]);
+		if (ret)
+			return ret;
+	}
+
+	/* Get FOM of device's TX lanes from host's RX_FOM. */
+	for (lane = 0; lane < d_iter->num_lanes; lane++) {
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
+				     UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
+				     &d_iter->fom[lane]);
+		if (ret)
+			return ret;
+	}
+
+	ret = ufshcd_vops_get_rx_fom(hba, pwr_mode, h_iter, d_iter);
+	if (ret)
+		dev_err(hba->dev, "Failed to get FOM via vops: %d\n", ret);
+
+	return ret;
+}
+
+/**
+ * tx_eqtr_iter_set - Set TX EQTR iterator with supported settings
+ * @iter: TX EQTR iterator data structure
+ * @preshoot: PreShoot value
+ * @deemphasis: DeEmphasis value
+ *
+ * This function validates whether the requested PreShoot and DeEmphasis
+ * combination is supported or not.
+ */
+static inline void tx_eqtr_iter_set(struct tx_eqtr_iter *iter,
+				    unsigned int preshoot,
+				    unsigned int deemphasis)
+{
+	if (!test_bit(preshoot, &iter->preshoot_bitmap) ||
+	    !test_bit(deemphasis, &iter->deemphasis_bitmap)) {
+		iter->is_new = false;
+		return;
+	}
+
+	if (use_txeq_presets) {
+		bool is_preset = false;
+
+		for (int i = 0; i < UFS_TX_EQ_PRESET_MAX; i++) {
+			if (!txeq_presets_selected[i])
+				continue;
+
+			if (preshoot == ufs_tx_eq_preset[i].preshoot &&
+			    deemphasis == ufs_tx_eq_preset[i].deemphasis) {
+				is_preset = true;
+				break;
+			}
+		}
+
+		if (!is_preset) {
+			iter->is_new = false;
+			return;
+		}
+	}
+
+	iter->preshoot = preshoot;
+	iter->deemphasis = deemphasis;
+	iter->is_new = true;
+}
+
+/**
+ * tx_eqtr_iter_update() - Update TX Equalization training iterators
+ * @preshoot: PreShoot value
+ * @deemphasis: DeEmphasis value
+ * @h_iter: Host TX EQTR iterator data structure
+ * @d_iter: Device TX EQTR iterator data structure
+ *
+ * Updates host and device TX Equalization training iterators with the
+ * provided PreShoot and DeEmphasis.
+ *
+ * Return: true if host and/or device TX Equalization training iterator has
+ * been updated to the provided PreShoot and DeEmphasis, false otherwise.
+ */
+static inline bool tx_eqtr_iter_update(unsigned int preshoot,
+				       unsigned int deemphasis,
+				       struct tx_eqtr_iter *h_iter,
+				       struct tx_eqtr_iter *d_iter)
+{
+	tx_eqtr_iter_set(h_iter, preshoot, deemphasis);
+	tx_eqtr_iter_set(d_iter, preshoot, deemphasis);
+
+	return h_iter->is_new || d_iter->is_new;
+}
+
+/**
+ * ufshcd_tx_eqtr_data_init - Initialize TX EQTR iteration data and TX EQ params
+ * @hba: per adapter instance
+ * @params: TX EQ parameters data structure
+ * @h_iter: host TX EQTR iterator data structure
+ * @d_iter: device TX EQTR iterator data structure
+ *
+ * This function initializes the TX EQTR iterator structures for both host and
+ * device by reading their TX equalization capabilities and setting up the
+ * iteration state. The capabilities are cached in the hba structure to avoid
+ * redundant DME operations in subsequent calls. The iterator structures are
+ * used by tx_eqtr_iter_load() to systematically iterate through all possible TX
+ * Equalization setting combinations during the TX EQTR procedure. This function
+ * also clears the host and device parameter arrays in the TX EQ params data
+ * structure, so that the TX EQTR procedure does not compare FOM values to stale
+ * FOM values.
+ *
+ * Returns 0 on success, negative error code otherwise
+ */
+static int ufshcd_tx_eqtr_data_init(struct ufs_hba *hba,
+				    struct ufshcd_tx_eq_params *params,
+				    struct tx_eqtr_iter *h_iter,
+				    struct tx_eqtr_iter *d_iter)
+{
+	u32 cap;
+	int ret;
+
+	if (!hba->host_preshoot_cap) {
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB(TX_HS_PRESHOOT_SETTING_CAP), &cap);
+		if (ret)
+			return ret;
+
+		hba->host_preshoot_cap = cap & TX_EQTR_CAP_MASK;
+	}
+
+	if (!hba->host_deemphasis_cap) {
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB(TX_HS_DEEMPHASIS_SETTING_CAP), &cap);
+		if (ret)
+			return ret;
+
+		hba->host_deemphasis_cap = cap & TX_EQTR_CAP_MASK;
+	}
+
+	if (!hba->device_preshoot_cap) {
+		ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(TX_HS_PRESHOOT_SETTING_CAP), &cap);
+		if (ret)
+			return ret;
+
+		hba->device_preshoot_cap = cap & TX_EQTR_CAP_MASK;
+	}
+
+	if (!hba->device_deemphasis_cap) {
+		ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(TX_HS_DEEMPHASIS_SETTING_CAP), &cap);
+		if (ret)
+			return ret;
+
+		hba->device_deemphasis_cap = cap & TX_EQTR_CAP_MASK;
+	}
+
+	memset(params->host, 0, sizeof(params->host));
+	memset(params->device, 0, sizeof(params->device));
+	memset(params->host_eqtr_record, 0xFF, sizeof(params->host_eqtr_record));
+	memset(params->device_eqtr_record, 0xFF, sizeof(params->device_eqtr_record));
+
+	memset(h_iter, 0, sizeof(struct tx_eqtr_iter));
+	memset(d_iter, 0, sizeof(struct tx_eqtr_iter));
+
+	h_iter->num_lanes = params->tx_lanes;
+	d_iter->num_lanes = params->rx_lanes;
+
+	/*
+	 * Support PreShoot & DeEmphasis of value 0 is mandatory, hence they are
+	 * not reflected in PreShoot/DeEmphasis capabilities. Left shift the
+	 * capability bitmap by 1 and set bit[0] to reflect value 0 is
+	 * supported, such that test_bit() can be used later for convenience.
+	 */
+	h_iter->preshoot_bitmap = (hba->host_preshoot_cap << 0x1) | 0x1;
+	h_iter->deemphasis_bitmap = (hba->host_deemphasis_cap << 0x1) | 0x1;
+	d_iter->preshoot_bitmap = (hba->device_preshoot_cap << 0x1) | 0x1;
+	d_iter->deemphasis_bitmap = (hba->device_deemphasis_cap << 0x1) | 0x1;
+
+	return ret;
+}
+
+/**
+ * adapt_cap_to_t_adapt - Calculate TAdapt from adapt capability
+ * @adapt: Adapt capability
+ *
+ * For NRZ:
+ *   IF (ADAPT_range = FINE)
+ *     TADAPT = 650 x (ADAPT_length + 1)
+ *   ELSE (IF ADAPT_range = COARSE)
+ *     TADAPT = 650 x 2^ADAPT_length
+ *
+ * Returns calculated TAdapt value in term of Unit Intervals (UI)
+ */
+static inline u64 adapt_cap_to_t_adapt(u32 adapt_cap)
+{
+	u64 tadapt;
+	u8 adapt_range = adapt_cap & ADAPT_RANGE_MASK;
+	u8 adapt_length = adapt_cap & ADAPT_LENGTH_MASK;
+
+	if (!adapt_range)
+		tadapt = TADAPT_FACTOR * (adapt_length + 1);
+	else
+		tadapt = TADAPT_FACTOR * (1 << adapt_length);
+
+	return tadapt;
+}
+
+/**
+ * adapt_cap_to_t_adapt_l0l3 - Calculate TAdapt_L0_L3 from adapt capability
+ * @adapt: Adapt capability
+ *
+ * For PAM-4:
+ *   IF (ADAPT_range = FINE)
+ *     TADAPT_L0_L3 = 2^9 x ADAPT_length
+ *   ELSE IF (ADAPT_range = COARSE)
+ *     TADAPT_L0_L3 = 2^9 x (2^ADAPT_length)
+ *
+ * Returns calculated TAdapt value in term of Unit Intervals (UI)
+ */
+static inline u64 adapt_cap_to_t_adapt_l0l3(u32 adapt_cap)
+{
+	u64 tadapt;
+	u8 adapt_range = adapt_cap & ADAPT_RANGE_MASK;
+	u8 adapt_length = adapt_cap & ADAPT_LENGTH_MASK;
+
+	if (!adapt_range)
+		tadapt = TADAPT_L0L3_FACTOR * adapt_length;
+	else
+		tadapt = TADAPT_L0L3_FACTOR * (1 << adapt_length);
+
+	return tadapt;
+}
+
+/**
+ * adapt_cap_to_t_adapt_l0l1l2l3 - Calculate TAdapt_L0_L1_L2_L3 from adapt capability
+ * @adapt: Adapt capability
+ *
+ * For PAM-4:
+ *   IF (ADAPT_range_L0_L1_L2_L3 = FINE)
+ *     TADAPT_L0_L1_L2_L3 = 2^15 x (ADAPT_length_L0_L1_L2_L3 + 1)
+ *   ELSE IF (ADAPT_range_L0_L1_L2_L3 = COARSE)
+ *     TADAPT_L0_L1_L2_L3 = 2^15 x 2^ADAPT_length_L0_L1_L2_L3
+ *
+ * Returns calculated TAdapt value in term of Unit Intervals (UI)
+ */
+static inline u64 adapt_cap_to_t_adapt_l0l1l2l3(u32 adapt_cap)
+{
+	u64 tadapt;
+	u8 adapt_range = adapt_cap & ADAPT_RANGE_MASK;
+	u8 adapt_length = adapt_cap & ADAPT_LENGTH_MASK;
+
+	if (!adapt_range)
+		tadapt = TADAPT_L0L1L2L3_FACTOR * (adapt_length + 1);
+	else
+		tadapt = TADAPT_L0L1L2L3_FACTOR * (1 << adapt_length);
+
+	return tadapt;
+}
+
+/**
+ * ufshcd_setup_tx_eqtr_adapt_length - Setup TX adapt length for EQTR
+ * @hba: per adapter instance
+ * @gear: target gear for EQTR
+ *
+ * This function determines and configures the proper TX adapt length (TAdapt)
+ * for the TX EQTR procedure based on the target gear and RX adapt capabilities
+ * of both host and device.
+ *
+ * Guidelines from MIPI UniPro v3.0 spec - select the minimum Adapt Length for
+ * the Equalization Training procedure based on the following conditions:
+ *
+ * If the target High-Speed Gear n is HS-G4 or HS-G5:
+ *  PA_TxAdaptLength_EQTR[7:0] >= Max (10us, RX_HS_Gn_ADAPT_INITIAL_Capability,
+ *					PA_PeerRxHsGnAdaptInitial)
+ *  PA_TxAdaptLength_EQTR[7:0] shall be shorter than PACP_REQUEST_TIMER (10ms)
+ *  PA_TxAdaptLength_EQTR[15:8] is not relevant for HS-G4 and HS-G5. This field
+ *  is set to 255 (reserved value).
+ *
+ * If the target High-Speed Gear n is HS-G6:
+ *  PA_TxAdapthLength_EQTR >= 10us
+ *  PA_TxAdapthLength_EQTR[7:0] >= Max (RX_HS_G6_ADAPT_INITIAL_Capability,
+ *					PA_PeerRxHsG6AdaptInitialL0L3)
+ *  PA_TxAdapthLength_EQTR[15:8] >= Max (RX_HS_G6_ADAPT_INITIAL_L0_L1_L2_L3_Capability,
+ *					PA_PeerRxHsG6AdaptInitialL0L1L2L3)
+ * PA_TxAdaptLength_EQTR shall be shorter than PACP_REQUEST_TIMER value of 10ms.
+ *
+ * Since adapt capabilities encode both range (fine/coarse) and length values,
+ * direct comparison is not possible. This function converts adapt capabilities
+ * to actual time durations in Unit Intervals (UI) using the Adapt time
+ * calculation formular in M-PHY v6.0 spec (Table 8), then selects the maximum
+ * to ensure both host and device use adequate TX adapt length.
+ *
+ * Returns 0 on success, negative error code otherwise
+ */
+static int ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba, u32 gear)
+{
+	struct ufshcd_tx_eq_params *params = &hba->tx_eq_params[gear - 1];
+	u32 adapt_eqtr;
+	int ret;
+
+	if (params->saved_adapt_eqtr)
+		goto set_adapt_eqtr;
+
+	if (gear == UFS_HS_G4 || gear == UFS_HS_G5) {
+		u64 t_adapt, t_adapt_local, t_adapt_peer;
+		u32 adapt_cap_local, adapt_cap_peer, adapt_length;
+
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(rx_adapt_initial_cap[gear],
+				     UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)),
+				     &adapt_cap_local);
+		if (ret)
+			return ret;
+
+		if (adapt_cap_local > ADAPT_LENGTH_MAX) {
+			dev_err(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_CAP (0x%x) exceeds max\n",
+				gear, adapt_cap_local);
+			return -EINVAL;
+		}
+
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB(pa_peer_rx_adapt_initial[gear]),
+				     &adapt_cap_peer);
+		if (ret)
+			return ret;
+
+		if (adapt_cap_peer > ADAPT_LENGTH_MAX) {
+			dev_err(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_CAP (0x%x) exceeds max\n",
+				gear, adapt_cap_peer);
+			return -EINVAL;
+		}
+
+		t_adapt_local = adapt_cap_to_t_adapt(adapt_cap_local);
+		t_adapt_peer = adapt_cap_to_t_adapt(adapt_cap_peer);
+
+		dev_dbg(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_CAP = 0x%x\n",
+			gear, adapt_cap_local);
+		dev_dbg(hba->dev, "peer RX_HS_G%u_ADAPT_INITIAL_CAP = 0x%x\n",
+			gear, adapt_cap_peer);
+		dev_dbg(hba->dev, "t_adapt_local = %llu UI, t_adapt_peer = %llu UI\n",
+			t_adapt_local, t_adapt_peer);
+
+		t_adapt = max(t_adapt_local, t_adapt_peer);
+		adapt_length = (t_adapt == t_adapt_local) ?
+			       adapt_cap_local : adapt_cap_peer;
+
+		dev_dbg(hba->dev, "TAdapt %llu UI selected for TX EQTR\n",
+			t_adapt);
+
+		if (gear == UFS_HS_G4 && t_adapt < TX_EQTR_HS_G4_MIN_T_ADAPT) {
+			dev_dbg(hba->dev, "TAdapt %llu UI is too short for TX EQTR for HS-G%u, use default Adapt 0x%x\n",
+				t_adapt, gear, TX_EQTR_HS_G4_ADAPT_DEFAULT);
+			adapt_length = TX_EQTR_HS_G4_ADAPT_DEFAULT;
+		} else if (gear == UFS_HS_G5 && t_adapt < TX_EQTR_HS_G5_MIN_T_ADAPT) {
+			dev_dbg(hba->dev, "TAdapt %llu UI is too short for TX EQTR for HS-G%u, use default Adapt 0x%x\n",
+				t_adapt, gear, TX_EQTR_HS_G5_ADAPT_DEFAULT);
+			adapt_length = TX_EQTR_HS_G5_ADAPT_DEFAULT;
+		}
+
+		adapt_eqtr = (adapt_length << TX_EQTR_ADAPT_LENGTH_SHIFT) |
+			     (TX_EQTR_ADAPT_RESERVED << TX_EQTR_ADAPT_LENGTH_L0L1L2L3_SHIFT);
+	} else if (gear == UFS_HS_G6) {
+		u64 t_adapt, t_adapt_l0l3, t_adapt_l0l3_local, t_adapt_l0l3_peer;
+		u64 t_adapt_l0l1l2l3, t_adapt_l0l1l2l3_local, t_adapt_l0l1l2l3_peer;
+		u32 adapt_l0l3_cap_local, adapt_l0l3_cap_peer, adapt_length_l0l3;
+		u32 adapt_l0l1l2l3_cap_local, adapt_l0l1l2l3_cap_peer, adapt_length_l0l1l2l3;
+
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(rx_adapt_initial_cap[gear],
+				     UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)),
+				     &adapt_l0l3_cap_local);
+		if (ret)
+			return ret;
+
+		if (adapt_l0l3_cap_local > ADAPT_L0L3_LENGTH_MAX) {
+			dev_err(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_CAP (0x%x) exceeds max\n",
+				gear, adapt_l0l3_cap_local);
+			return -EINVAL;
+		}
+
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB(pa_peer_rx_adapt_initial[gear]),
+				     &adapt_l0l3_cap_peer);
+		if (ret)
+			return ret;
+
+		if (adapt_l0l3_cap_peer > ADAPT_L0L3_LENGTH_MAX) {
+			dev_err(hba->dev, "peer RX_HS_G%u_ADAPT_INITIAL_CAP (0x%x) exceeds max\n",
+				gear, adapt_l0l3_cap_peer);
+			return -EINVAL;
+		}
+
+		t_adapt_l0l3_local = adapt_cap_to_t_adapt_l0l3(adapt_l0l3_cap_local);
+		t_adapt_l0l3_peer = adapt_cap_to_t_adapt_l0l3(adapt_l0l3_cap_peer);
+
+		dev_dbg(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_CAP = 0x%x\n",
+			gear, adapt_l0l3_cap_local);
+		dev_dbg(hba->dev, "peer RX_HS_G%u_ADAPT_INITIAL_CAP = 0x%x\n",
+			gear, adapt_l0l3_cap_peer);
+		dev_dbg(hba->dev, "t_adapt_l0l3_local = %llu UI, t_adapt_l0l3_peer = %llu UI\n",
+			t_adapt_l0l3_local, t_adapt_l0l3_peer);
+
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_HS_G6_ADAPT_INITIAL_L0L1L2L3_CAP,
+				     UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)),
+				     &adapt_l0l1l2l3_cap_local);
+		if (ret)
+			return ret;
+
+		if (adapt_l0l1l2l3_cap_local > ADAPT_L0L1L2L3_LENGTH_MAX) {
+			dev_err(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP (0x%x) exceeds max\n",
+				gear, adapt_l0l1l2l3_cap_local);
+			return -EINVAL;
+		}
+
+		ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTINITIALL0L1L2L3),
+				     &adapt_l0l1l2l3_cap_peer);
+		if (ret)
+			return ret;
+
+		if (adapt_l0l1l2l3_cap_peer > ADAPT_L0L1L2L3_LENGTH_MAX) {
+			dev_err(hba->dev, "peer RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP (0x%x) exceeds max\n",
+				gear, adapt_l0l1l2l3_cap_peer);
+			return -EINVAL;
+		}
+
+		t_adapt_l0l1l2l3_local = adapt_cap_to_t_adapt_l0l1l2l3(adapt_l0l1l2l3_cap_local);
+		t_adapt_l0l1l2l3_peer = adapt_cap_to_t_adapt_l0l1l2l3(adapt_l0l1l2l3_cap_peer);
+
+		dev_dbg(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP = 0x%x\n",
+			gear, adapt_l0l1l2l3_cap_local);
+		dev_dbg(hba->dev, "peer RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP = 0x%x\n",
+			gear, adapt_l0l1l2l3_cap_peer);
+		dev_dbg(hba->dev, "t_adapt_l0l1l2l3_local = %llu UI, t_adapt_l0l1l2l3_peer = %llu UI\n",
+			t_adapt_l0l1l2l3_local, t_adapt_l0l1l2l3_peer);
+
+		t_adapt_l0l3 = max(t_adapt_l0l3_local, t_adapt_l0l3_peer);
+		adapt_length_l0l3 = (t_adapt_l0l3 == t_adapt_l0l3_local) ?
+				    adapt_l0l3_cap_local : adapt_l0l3_cap_peer;
+
+		t_adapt_l0l1l2l3 = max(t_adapt_l0l1l2l3_local, t_adapt_l0l1l2l3_peer);
+		adapt_length_l0l1l2l3 = (t_adapt_l0l1l2l3 == t_adapt_l0l1l2l3_local) ?
+					adapt_l0l1l2l3_cap_local : adapt_l0l1l2l3_cap_peer;
+
+		t_adapt = t_adapt_l0l3 + t_adapt_l0l1l2l3;
+
+		dev_dbg(hba->dev, "TAdapt %llu PAM-4 UI selected for TX EQTR\n",
+			t_adapt);
+
+		if (t_adapt < TX_EQTR_HS_G6_MIN_T_ADAPT) {
+			dev_dbg(hba->dev, "TAdapt %llu UI is too short for TX EQTR for HS-G%u, use default Adapt 0x%x\n",
+				t_adapt, gear, TX_EQTR_HS_G6_ADAPT_DEFAULT);
+			adapt_length_l0l3 = TX_EQTR_HS_G6_ADAPT_DEFAULT;
+		}
+
+		adapt_eqtr = (adapt_length_l0l3 << TX_EQTR_ADAPT_LENGTH_SHIFT) |
+			     (adapt_length_l0l1l2l3 << TX_EQTR_ADAPT_LENGTH_L0L1L2L3_SHIFT);
+	} else {
+		return -EINVAL;
+	}
+
+	params->saved_adapt_eqtr = adapt_eqtr;
+
+set_adapt_eqtr:
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXADAPTLENGTH_EQTR),
+			     params->saved_adapt_eqtr);
+	if (ret)
+		dev_err(hba->dev, "Failed to set adapt length for TX EQTR: %d\n",
+			ret);
+	else
+		dev_dbg(hba->dev, "PA_TXADAPTLENGTH_EQTR configured to 0x%08x\n",
+			params->saved_adapt_eqtr);
+
+	return ret;
+}
+
+/**
+ * ufshcd_compose_tx_eqtr_setting - Compose TX EQTR setting
+ * @iter: TX EQTR iterator data structure
+ *
+ * Returns composed TX EQTR setting, same setting is used for all active lanes
+ */
+static inline u32 ufshcd_compose_tx_eqtr_setting(struct tx_eqtr_iter *iter)
+{
+	u32 setting = 0;
+	int lane;
+
+	for (lane = 0; lane < iter->num_lanes; lane++) {
+		setting |= TX_HS_PRESHOOT_BITS(lane, iter->preshoot);
+		setting |= TX_HS_DEEMPHASIS_BITS(lane, iter->deemphasis);
+	}
+
+	return setting;
+}
+
+/**
+ * ufshcd_apply_tx_eqtr_settings - Apply TX EQTR setting
+ * @hba: per adapter instance
+ * @pwr_mode: target power mode containing gear and rate information
+ * @h_iter: host TX EQTR iterator data structure
+ * @d_iter: device TX EQTR iterator data structure
+ *
+ * Returns 0 on success, negative error code otherwise
+ */
+static int ufshcd_apply_tx_eqtr_settings(struct ufs_hba *hba,
+					 struct ufs_pa_layer_attr *pwr_mode,
+					 struct tx_eqtr_iter *h_iter,
+					 struct tx_eqtr_iter *d_iter)
+{
+	u32 setting;
+	int ret;
+
+	setting = ufshcd_compose_tx_eqtr_setting(h_iter);
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXEQTRSETTING), setting);
+	if (ret)
+		return ret;
+
+	setting = ufshcd_compose_tx_eqtr_setting(d_iter);
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PEERTXEQTRSETTING), setting);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_vops_apply_tx_eqtr_settings(hba, pwr_mode, h_iter, d_iter);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+/**
+ * ufshcd_tx_eqtr_result_examine() - Examine TX Equalization training results
+ * @old_params: Pointer to the previously known TX Equalization parameters
+ * @new_params: Pointer to the newly trained TX Equalization parameters
+ *
+ * Checks the Figure of Merit (FOM) for each lane in the newly trained TX
+ * Equalization parameters. If a lane in the newly trained TX Equalization
+ * parameters has an FOM of 0, it restores the TX Equalization settings from
+ * the old_params for that specific lane.
+ */
+static inline void
+ufshcd_tx_eqtr_result_examine(struct ufshcd_tx_eq_params *old_params,
+			      struct ufshcd_tx_eq_params *new_params)
+{
+	int lane;
+
+	if (!old_params->is_valid)
+		return;
+
+	for (lane = 0; lane < new_params->tx_lanes; lane++)
+		if (new_params->host[lane].fom_val == 0)
+			new_params->host[lane] = old_params->host[lane];
+
+	for (lane = 0; lane < new_params->rx_lanes; lane++)
+		if (new_params->device[lane].fom_val == 0)
+			new_params->device[lane] = old_params->device[lane];
+}
+
+/**
+ * __ufshcd_tx_eqtr - TX Equalization Training (EQTR) procedure
+ * @hba: per adapter instance
+ * @params: TX EQ parameters data structure
+ * @pwr_mode: target power mode containing gear and rate information
+ *
+ * This function implements the complete TX EQTR procedure as defined in UFSHCI
+ * v5.0 specification. It iterates through all possible combinations of PreShoot
+ * and DeEmphasis settings to find the optimal TX Equalization settings for all
+ * active lanes.
+ *
+ * Returns 0 on success, negative error code otherwise
+ */
+static int __ufshcd_tx_eqtr(struct ufs_hba *hba,
+			    struct ufshcd_tx_eq_params *params,
+			    struct ufs_pa_layer_attr *pwr_mode)
+{
+	struct ufshcd_tx_eq_params *new_params;
+	struct tx_eqtr_iter h_iter, d_iter;
+	unsigned int preshoot, deemphasis;
+	u32 gear = pwr_mode->gear_tx;
+	ktime_t start;
+	int ret;
+
+	new_params = kzalloc(sizeof(struct ufshcd_tx_eq_params), GFP_KERNEL);
+	if (!new_params)
+		return -ENOMEM;
+
+	dev_info(hba->dev, "Starting TX EQTR for HS-G%u, Rate-%s, active RX lanes: %u, active TX Lanes: %u\n",
+		 gear, UFS_HS_RATE_STRING(pwr_mode->hs_rate),
+		 params->rx_lanes, params->tx_lanes);
+
+	start = ktime_get();
+
+	/* Step 1 - Determine the TX Adapt Length for EQTR */
+	ret = ufshcd_setup_tx_eqtr_adapt_length(hba, gear);
+	if (ret) {
+		dev_err(hba->dev, "Failed to setup adapt length: %d\n", ret);
+		goto out;
+	}
+
+	/* Step 2 - Determine TX Equalization setting capabilities */
+	memcpy(new_params, params, sizeof(struct ufshcd_tx_eq_params));
+	ret = ufshcd_tx_eqtr_data_init(hba, new_params, &h_iter, &d_iter);
+	if (ret) {
+		dev_err(hba->dev, "Failed to init TX EQTR data: %d\n", ret);
+		goto out;
+	}
+
+	/* TX EQTR main loop */
+	for (preshoot = 0; preshoot < TX_HS_NUM_PRESHOOT; preshoot++)
+		for (deemphasis = 0; deemphasis < TX_HS_NUM_DEEMPHASIS; deemphasis++) {
+			if (!tx_eqtr_iter_update(preshoot, deemphasis, &h_iter, &d_iter))
+				continue;
+
+			/* Step 3 - Apply TX EQTR settings */
+			ret = ufshcd_apply_tx_eqtr_settings(hba, pwr_mode, &h_iter, &d_iter);
+			if (ret) {
+				dev_err(hba->dev, "Failed to apply TX EQTR settings: %d\n",
+					ret);
+				goto out;
+			}
+
+			/* Step 4 - Trigger TX EQTR procedure start */
+			ret = ufshcd_trigger_tx_eqtr(hba, gear);
+			if (ret) {
+				dev_err(hba->dev, "Failed to start TX EQTR procedure for target gear %u: %d\n",
+					gear, ret);
+				goto out;
+			}
+
+			/* Step 5 - Get FOM */
+			ret = ufshcd_get_rx_fom(hba, pwr_mode, &h_iter, &d_iter);
+			if (ret) {
+				dev_err(hba->dev, "Failed to get RX_FOM: %d\n",
+					ret);
+				goto out;
+			}
+
+			ufshcd_evaluate_fom(hba, new_params, &h_iter, &d_iter);
+	};
+
+	dev_info(hba->dev, "TX EQTR procedures completed successfully! Time elapsed: %llu ms\n",
+		 ktime_to_ms(ktime_sub(ktime_get(), start)));
+
+	ufshcd_tx_eqtr_result_examine(params, new_params);
+
+	memcpy(params, new_params, sizeof(struct ufshcd_tx_eq_params));
+	params->last_eqtr_ts = ktime_get();
+	params->num_eqtr_records++;
+out:
+	kfree(new_params);
+	return ret;
+}
+
+/**
+ * ufshcd_tx_eqtr_prepare - Prepare UFS link for TX EQTR procedure
+ * @hba: per adapter instance
+ * @pwr_mode: target power mode containing gear and rate
+ *
+ * This function prepares the UFS link for TX Equalization Training (EQTR) by
+ * establishing the proper initial conditions required by the EQTR procedure.
+ * It ensures that EQTR starts from the most reiliable link state (HS-G1) with
+ * all connected lanes activated and sets host TX HS Adapt Type to INITIAL.
+ *
+ * Returns 0 on successful preparation, negative error code on failure
+ */
+static int ufshcd_tx_eqtr_prepare(struct ufs_hba *hba,
+				  struct ufs_pa_layer_attr *pwr_mode)
+{
+	struct ufs_pa_layer_attr pwr_mode_hs_g1 = {
+		/* TX EQTR shall be initiated from the most reliable HS-G1 */
+		.gear_rx = UFS_HS_G1,
+		.gear_tx = UFS_HS_G1,
+		.lane_rx = pwr_mode->lane_rx,
+		.lane_tx = pwr_mode->lane_tx,
+		.pwr_rx = FAST_MODE,
+		.pwr_tx = FAST_MODE,
+		/* Use the target power mode's HS rate */
+		.hs_rate = pwr_mode->hs_rate,
+	};
+	u32 rate = pwr_mode->hs_rate;
+	int ret;
+
+	/* Change power mode to HS-G1, activate all connected lanes. */
+	ret = ufshcd_change_power_mode(hba, &pwr_mode_hs_g1, /*force_pmc=*/false);
+	if (ret) {
+		dev_err(hba->dev, "TX EQTR: Failed to change power mode to HS-G1, Rate-%s: %d\n",
+			UFS_HS_RATE_STRING(rate), ret);
+		return ret;
+	}
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
+			     PA_INITIAL_ADAPT);
+	if (ret)
+		dev_err(hba->dev, "TX EQTR: Failed to set Host Adapt type to INITIAL: %d\n",
+			ret);
+
+	return ret;
+}
+
+static void ufshcd_tx_eqtr_unprepare(struct ufs_hba *hba,
+				     struct ufs_pa_layer_attr *pwr_mode)
+{
+	int err;
+
+	if (pwr_mode->pwr_rx == SLOWAUTO_MODE || pwr_mode->hs_rate == 0)
+		return;
+
+	err = ufshcd_change_power_mode(hba, pwr_mode, /*force_pmc=*/false);
+	if (err)
+		dev_err(hba->dev, "%s: Failed to restore Power Mode: %d\n",
+			__func__, err);
+}
+
+/**
+ * ufshcd_tx_eqtr - Perform TX EQTR procedures with vops callbacks
+ * @hba: per adapter instance
+ * @params: TX EQ parameters data structure to populate
+ * @pwr_mode: target power mode containing gear and rate information
+ *
+ * This is the main entry point for performing TX Equalization Training (EQTR)
+ * procedure as defined in UFSCHI v5.0 specification. It serves as a wrapper
+ * around __ufshcd_tx_eqtr() to provide vops support through the variant
+ * operations framework.
+ *
+ * Returns 0 on success, negative error code on failure
+ */
+static int ufshcd_tx_eqtr(struct ufs_hba *hba,
+			  struct ufshcd_tx_eq_params *params,
+			  struct ufs_pa_layer_attr *pwr_mode)
+{
+	struct ufs_pa_layer_attr old_pwr_info;
+	u32 gear = pwr_mode->gear_tx;
+	int ret;
+
+	if (gear < UFS_HS_G4 || gear > UFS_HS_G6) {
+		dev_err(hba->dev, "TX EQTR is not implemented for HS-G%u\n",
+			gear);
+		return -EINVAL;
+	}
+
+	params->rx_lanes = pwr_mode->lane_rx;
+	params->tx_lanes = pwr_mode->lane_tx;
+
+	memcpy(&old_pwr_info, &hba->pwr_info, sizeof(struct ufs_pa_layer_attr));
+
+	ret = ufshcd_tx_eqtr_prepare(hba, pwr_mode);
+	if (ret) {
+		dev_err(hba->dev, "Failed to prepare TX EQTR: %d\n", ret);
+		goto out;
+	}
+
+	ret = ufshcd_vops_tx_eqtr_notify(hba, PRE_CHANGE, params, pwr_mode);
+	if (ret)
+		goto out;
+
+	ret = __ufshcd_tx_eqtr(hba, params, pwr_mode);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_vops_tx_eqtr_notify(hba, POST_CHANGE, params, pwr_mode);
+	if (ret)
+		goto out;
+
+out:
+	if (ret)
+		ufshcd_tx_eqtr_unprepare(hba, &old_pwr_info);
+
+	return ret;
+}
+
+/**
+ * ufshcd_config_tx_eq_settings - Configure TX Equalization settings
+ * @hba: per adapter instance
+ * @pwr_mode: target power mode containing gear and rate information
+ *
+ * This function finds and sets the TX Equalization settings for the given
+ * target power mode.
+ *
+ * Returns 0 on success, error code otherwise
+ */
+int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
+				 struct ufs_pa_layer_attr *pwr_mode)
+{
+	struct ufshcd_tx_eq_params *params;
+	u32 gear, rate;
+	int ret = 0;
+
+	if (!ufshcd_is_tx_eq_supported(hba) || !use_adaptive_txeq)
+		return ret;
+
+	if (!pwr_mode) {
+		dev_err(hba->dev, "%s: Target power mode is NULL\n", __func__);
+		return -EINVAL;
+	}
+
+	gear = pwr_mode->gear_tx;
+	rate = pwr_mode->hs_rate;
+	params = &hba->tx_eq_params[gear - 1];
+
+	if (gear < UFS_HS_G1 || gear >= UFS_HS_GEAR_MAX) {
+		dev_err(hba->dev, "Invalid HS-Gear (%u) for TX Equalization\n",
+			gear);
+		return -EINVAL;
+	} else if (gear < adaptive_txeq_gear) {
+		return ret;
+	}
+
+	if (rate != PA_HS_MODE_A && rate != PA_HS_MODE_B) {
+		dev_err(hba->dev, "Invalid HS-Rate (%u) for TX Equalization\n",
+			rate);
+		return -EINVAL;
+	}
+
+	/* TX EQTR is supported for HS-G4 and higher Gears */
+	if (gear < UFS_HS_G4)
+		goto apply_tx_eq_settings;
+
+	if (!params->is_valid) {
+		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
+		if (ret) {
+			dev_err(hba->dev, "Failed to train TX Equalization for HS-G%u, Rate-%s: %d\n",
+				gear, UFS_HS_RATE_STRING(rate), ret);
+			return ret;
+		}
+
+		/* Mark TX Equalization settings as valid */
+		params->is_valid = true;
+		params->is_applied = false;
+	}
+
+apply_tx_eq_settings:
+	if (params->is_valid && !params->is_applied) {
+		ret = ufshcd_apply_tx_eq_settings(hba, params, gear);
+		if (ret) {
+			dev_err(hba->dev, "Failed to apply TX Equalization settings for HS-G%u, Rate-%s: %d\n",
+				gear, UFS_HS_RATE_STRING(rate), ret);
+			return ret;
+		}
+
+		params->is_applied = true;
+	}
+
+	return ret;
+}
+
+void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba)
+{
+	struct ufs_pa_layer_attr *pwr_info = &hba->max_pwr_info.info;
+	struct ufshcd_tx_eq_params *params;
+	int gear, ret;
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return;
+
+	if (!hba->max_pwr_info.is_valid) {
+		dev_err(hba->dev, "Max power info invalid, cannot apply TX Equalization settings\n");
+		return;
+	}
+
+	for (gear = UFS_HS_G1; gear < UFS_HS_GEAR_MAX; gear++) {
+		params = &hba->tx_eq_params[gear - 1];
+
+		if (params->is_valid) {
+			params->tx_lanes = pwr_info->lane_tx;
+			params->rx_lanes = pwr_info->lane_rx;
+
+			ret = ufshcd_apply_tx_eq_settings(hba, params, gear);
+			if (ret) {
+				params->is_applied = false;
+				dev_err(hba->dev, "Failed to apply TX Equalization settings for HS-G%u: %d\n",
+					gear, ret);
+			} else {
+				params->is_applied = true;
+			}
+		}
+	}
+}
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ed30f472e683..87777d3f4326 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -103,6 +103,12 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id);
 
+int ufshcd_trigger_tx_eqtr(struct ufs_hba *hba, int gear);
+void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba);
+int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
+				 struct ufs_pa_layer_attr *pwr_mode);
+void ufshcd_print_tx_eq_params(struct ufs_hba *hba);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
@@ -297,6 +303,39 @@ static inline u32 ufshcd_vops_freq_to_gear_speed(struct ufs_hba *hba, unsigned l
 	return 0;
 }
 
+static inline int ufshcd_vops_get_rx_fom(struct ufs_hba *hba,
+					 struct ufs_pa_layer_attr *pwr_mode,
+					 struct tx_eqtr_iter *h_iter,
+					 struct tx_eqtr_iter *d_iter)
+{
+	if (hba->vops && hba->vops->get_rx_fom)
+		return hba->vops->get_rx_fom(hba, pwr_mode, h_iter, d_iter);
+
+	return 0;
+}
+
+static inline int ufshcd_vops_apply_tx_eqtr_settings(struct ufs_hba *hba,
+						     struct ufs_pa_layer_attr *pwr_mode,
+						     struct tx_eqtr_iter *h_iter,
+						     struct tx_eqtr_iter *d_iter)
+{
+	if (hba->vops && hba->vops->apply_tx_eqtr_settings)
+		return hba->vops->apply_tx_eqtr_settings(hba, pwr_mode, h_iter, d_iter);
+
+	return 0;
+}
+
+static inline int ufshcd_vops_tx_eqtr_notify(struct ufs_hba *hba,
+					     enum ufs_notify_change_status status,
+					     struct ufshcd_tx_eq_params *params,
+					     struct ufs_pa_layer_attr *pwr_mode)
+{
+	if (hba->vops && hba->vops->tx_eqtr_notify)
+		return hba->vops->tx_eqtr_notify(hba, status, params, pwr_mode);
+
+	return 0;
+}
+
 extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /**
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 511bd576a261..ed6793b1b7a1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4341,16 +4341,18 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	ret = __ufshcd_send_uic_cmd(hba, cmd);
 	if (ret) {
 		dev_err(hba->dev,
-			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
-			cmd->command, cmd->argument3, ret);
+			"pwr ctrl cmd 0x%x with (MIBattribute 0x%x, mode 0x%x) uic error %d\n",
+			cmd->command, UIC_GET_ATTR_ID(cmd->argument1),
+			cmd->argument3, ret);
 		goto out;
 	}
 
 	if (!wait_for_completion_timeout(hba->uic_async_done,
 					 msecs_to_jiffies(uic_cmd_timeout))) {
 		dev_err(hba->dev,
-			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
-			cmd->command, cmd->argument3);
+			"pwr ctrl cmd 0x%x with (MIBattribute 0x%x, mode 0x%x) completion timeout\n",
+			cmd->command, UIC_GET_ATTR_ID(cmd->argument1),
+			cmd->argument3);
 
 		if (!cmd->cmd_active) {
 			dev_err(hba->dev, "%s: Power Mode Change operation has been completed, go check UPMCRS\n",
@@ -4366,14 +4368,16 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	status = ufshcd_get_upmcrs(hba);
 	if (status != PWR_LOCAL) {
 		dev_err(hba->dev,
-			"pwr ctrl cmd 0x%x failed, host upmcrs:0x%x\n",
-			cmd->command, status);
+			"pwr ctrl cmd 0x%x with (MIBattribute 0x%x, mode 0x%x) failed, host upmcrs:0x%x\n",
+			cmd->command, UIC_GET_ATTR_ID(cmd->argument1),
+			cmd->argument3, status);
 		ret = (status != PWR_OK) ? status : -1;
 	}
 out:
 	if (ret) {
 		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
+		ufshcd_print_tx_eq_params(hba);
 		ufshcd_print_evt_hist(hba);
 	}
 
@@ -4399,6 +4403,29 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	return ret;
 }
 
+/**
+ * ufshcd_trigger_tx_eqtr - Trigger EQTR procedure start
+ * @hba: per adapter instance
+ * @gear: target gear for EQTR
+ *
+ * Returns 0 on success, negative error code otherwise
+ */
+int ufshcd_trigger_tx_eqtr(struct ufs_hba *hba, int gear)
+{
+	struct uic_command uic_cmd = {
+		.command = UIC_CMD_DME_SET,
+		.argument1 = UIC_ARG_MIB(PA_EQTR_GEAR),
+		.argument3 = gear,
+	};
+	int ret;
+
+	ufshcd_hold(hba);
+	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	ufshcd_release(hba);
+
+	return ret;
+}
+
 /**
  * ufshcd_send_bsg_uic_cmd - Send UIC commands requested via BSG layer and retrieve the result
  * @hba: per adapter instance
@@ -4785,6 +4812,14 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 	if (ret)
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 
+	ret = ufshcd_config_tx_eq_settings(hba, &final_params);
+	if (ret) {
+		dev_err(hba->dev, "Failed to configure TX Equalization settings for HS-G%u, Rate-%s: %d\n",
+			final_params.gear_tx,
+			UFS_HS_RATE_STRING(final_params.hs_rate), ret);
+		return ret;
+	}
+
 	return ufshcd_change_power_mode(hba, &final_params, force_pmc);
 }
 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
@@ -6784,6 +6819,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
+		ufshcd_print_tx_eq_params(hba);
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_tmrs(hba, hba->outstanding_tasks);
 		ufshcd_print_trs_all(hba, pr_prdt);
@@ -7047,6 +7083,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 			ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE,
 					 "host_regs: ");
 			ufshcd_print_pwr_info(hba);
+			ufshcd_print_tx_eq_params(hba);
 		}
 		ufshcd_schedule_eh_work(hba);
 		retval |= IRQ_HANDLED;
@@ -7828,6 +7865,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
+		ufshcd_print_tx_eq_params(hba);
 		ufshcd_print_tr(hba, cmd, true);
 	} else {
 		ufshcd_print_tr(hba, cmd, false);
@@ -8805,6 +8843,8 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_HIBER8TIME)
 		ufshcd_quirk_override_pa_h8time(hba);
+
+	ufshcd_apply_valid_tx_eq_settings(hba);
 }
 
 static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 45caa162d3d8..696db71d68bc 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -287,6 +287,73 @@ struct ufs_pwr_mode_info {
 	struct ufs_pa_layer_attr info;
 };
 
+/**
+ * struct tx_eqtr_iter - TX EQTR setting iterator
+ * @preshoot_bitmap: PreShoot bitmap
+ * @deemphasis_bitmap: DeEmphasis bitmap
+ * @num_lanes: number of active lanes
+ * @preshoot: PreShoot value
+ * @deemphasis: DeEmphasis value
+ * @fom: Figure-of-Merit read out from RX_FOM
+ * @is_new: Flag to indicate whether re-newed since previous iteration
+ */
+struct tx_eqtr_iter {
+	unsigned long preshoot_bitmap;
+	unsigned long deemphasis_bitmap;
+	u32 num_lanes;
+	u32 preshoot;
+	u32 deemphasis;
+	u32 fom[PA_MAXDATALANES];
+	bool is_new;
+};
+
+/**
+ * struct ufshcd_tx_eq_settings - TX Equalization settings
+ * @preshoot: PreShoot value
+ * @deemphasis: DeEmphasis value
+ * @fom: Figure-of-Merit read out from RX_FOM
+ * @precode_en: Flag to indicate whether need to enable pre-coding
+ */
+struct ufshcd_tx_eq_settings {
+	u32 preshoot;
+	u32 deemphasis;
+	u32 fom_val;
+	bool precode_en;
+};
+
+/**
+ * struct ufshcd_tx_eq_params - TX Equalization parameters structure
+ * @tx_lanes: Number of active TX lanes
+ * @rx_lanes: Number of active RX lanes
+ * @host: TX EQ settings for host TX lanes
+ * @device: TX EQ settings for device TX lanes
+ * @host_eqtr_record: last host TX EQTR record
+ * @device_eqtr_record: last device TX EQTR record
+ * @last_eqtr_ts: last TX EQTR timestamp
+ * @num_eqtr_records: number of TX EQTR happened
+ * @saved_adapt_eqtr: saved adaptation length setting for TX EQTR
+ * @is_valid: True if parameters contain valid/optimal settings
+ * @is_applied: True if settings have been applied to UniPro of both sides
+ */
+struct ufshcd_tx_eq_params {
+	u32 tx_lanes;
+	u32 rx_lanes;
+
+	struct ufshcd_tx_eq_settings host[PA_MAXDATALANES];
+	struct ufshcd_tx_eq_settings device[PA_MAXDATALANES];
+
+	u32 host_eqtr_record[PA_MAXDATALANES][TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMPHASIS];
+	u32 device_eqtr_record[PA_MAXDATALANES][TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMPHASIS];
+
+	ktime_t last_eqtr_ts;
+	int num_eqtr_records;
+
+	u32 saved_adapt_eqtr;
+
+	bool is_valid;
+	bool is_applied;
+};
+
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
@@ -330,6 +397,10 @@ struct ufs_pwr_mode_info {
  * @config_esi: called to config Event Specific Interrupt
  * @config_scsi_dev: called to configure SCSI device parameters
  * @freq_to_gear_speed: called to map clock frequency to the max supported gear speed
+ * @apply_tx_eqtr_settings: called to apply settings for TX EQTR.
+ * @get_rx_fom: called to get Figure of Merit (FOM) value.
+ * @tx_eqtr_notify: called before and after TX Equalization Training procedure
+ *		    to allow platform vendor specific configs to take place.
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -381,6 +452,18 @@ struct ufs_hba_variant_ops {
 	int	(*config_esi)(struct ufs_hba *hba);
 	void	(*config_scsi_dev)(struct scsi_device *sdev);
 	u32	(*freq_to_gear_speed)(struct ufs_hba *hba, unsigned long freq);
+	int	(*get_rx_fom)(struct ufs_hba *hba,
+			      struct ufs_pa_layer_attr *pwr_mode,
+			      struct tx_eqtr_iter *h_iter,
+			      struct tx_eqtr_iter *d_iter);
+	int	(*apply_tx_eqtr_settings)(struct ufs_hba *hba,
+					  struct ufs_pa_layer_attr *pwr_mode,
+					  struct tx_eqtr_iter *h_iter,
+					  struct tx_eqtr_iter *d_iter);
+	int	(*tx_eqtr_notify)(struct ufs_hba *hba,
+				  enum ufs_notify_change_status status,
+				  struct ufshcd_tx_eq_params *params,
+				  struct ufs_pa_layer_attr *pwr_mode);
 };
 
 /* clock gating state  */
@@ -768,6 +851,13 @@ enum ufshcd_caps {
 	 * WriteBooster when scaling the clock down.
 	 */
 	UFSHCD_CAP_WB_WITH_CLK_SCALING			= 1 << 12,
+
+	/*
+	 * This capability allows the host controller driver to apply TX
+	 * Equalization settings discovered from UFS attributes, variant
+	 * specific operations and TX Equaliztion Training procedure.
+	 */
+	UFSHCD_CAP_TX_EQUALIZATION			= 1 << 13,
 };
 
 struct ufs_hba_variant_params {
@@ -944,6 +1034,11 @@ enum ufshcd_mcq_opr {
  * @dev_lvl_exception_count: count of device level exceptions since last reset
  * @dev_lvl_exception_id: vendor specific information about the device level exception event.
  * @rpmbs: list of OP-TEE RPMB devices (one per RPMB region)
+ * @host_preshoot_cap: host TX PreShoot capability
+ * @host_deemphasis_cap: host TX DeEmphasis capability
+ * @device_preshoot_cap: device TX PreShoot capability
+ * @device_deemphasis_cap: device TX DeEmphasis capability
+ * @tx_eq_params: TX Equalization settings
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1117,6 +1212,12 @@ struct ufs_hba {
 	u64 dev_lvl_exception_id;
 	u32 vcc_off_delay_us;
 	struct list_head rpmbs;
+
+	u32 host_preshoot_cap;
+	u32 host_deemphasis_cap;
+	u32 device_preshoot_cap;
+	u32 device_deemphasis_cap;
+	struct ufshcd_tx_eq_params tx_eq_params[UFS_HS_GEAR_MAX - 1];
 };
 
 /**
@@ -1261,6 +1362,13 @@ static inline bool ufshcd_enable_wb_if_scaling_up(struct ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_WB_WITH_CLK_SCALING;
 }
 
+static inline bool ufshcd_is_tx_eq_supported(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_TX_EQUALIZATION &&
+	       hba->ufs_version >= ufshci_version(5, 0) &&
+	       hba->dev_info.wspecversion >= 0x500;
+}
+
 #define ufsmcq_writel(hba, val, reg)	\
 	writel((val), (hba)->mcq_base + (reg))
 #define ufsmcq_readl(hba, reg)	\
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index eccb45d3b86c..dded830efe24 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -10,6 +10,8 @@
  * M-TX Configuration Attributes
  */
 #define TX_HIBERN8TIME_CAPABILITY		0x000F
+#define TX_HS_DEEMPHASIS_SETTING_CAP		0x0012
+#define TX_HS_PRESHOOT_SETTING_CAP		0x0015
 #define TX_MODE					0x0021
 #define TX_HSRATE_SERIES			0x0022
 #define TX_HSGEAR				0x0023
@@ -38,6 +40,9 @@
 /*
  * M-RX Configuration Attributes
  */
+#define RX_HS_G5_ADAPT_INITIAL_CAP		0x0074
+#define RX_HS_G6_ADAPT_INITIAL_CAP		0x007B
+#define RX_HS_G6_ADAPT_INITIAL_L0L1L2L3_CAP	0x007D
 #define RX_HS_G1_SYNC_LENGTH_CAP		0x008B
 #define RX_HS_G1_PREP_LENGTH_CAP		0x008C
 #define RX_MIN_ACTIVATETIME_CAPABILITY		0x008F
@@ -50,6 +55,7 @@
 #define RX_HIBERN8TIME_CAP			0x0092
 #define RX_ADV_HIBERN8TIME_CAP			0x0099
 #define RX_ADV_MIN_ACTIVATETIME_CAP		0x009A
+#define RX_HS_G4_ADAPT_INITIAL_CAP		0x009F
 #define RX_MODE					0x00A1
 #define RX_HSRATE_SERIES			0x00A2
 #define RX_HSGEAR				0x00A3
@@ -64,6 +70,7 @@
 #define CFGRXCDR8				0x00BA
 #define CFGRXOVR8				0x00BD
 #define CFGRXOVR6				0x00BF
+#define RX_FOM					0x00C2
 #define RXDIRECTCTRL2				0x00C7
 #define CFGRXOVR4				0x00E9
 #define RX_REFCLKFREQ				0x00EB
@@ -73,7 +80,6 @@
 #define ENARXDIRECTCFG3				0x00F3
 #define ENARXDIRECTCFG2				0x00F4
 
-
 #define is_mphy_tx_attr(attr)			(attr < RX_MODE)
 #define RX_ADV_FINE_GRAN_STEP(x)		((((x) & 0x3) << 1) | 0x1)
 #define SYNC_LEN_FINE(x)			((x) & 0x3F)
@@ -99,73 +105,101 @@
 
 #define UNIPRO_CB_OFFSET(x)			(0x8000 | x)
 
+/* Adapt capability masks */
+#define ADAPT_LENGTH_MASK			0x7F
+#define ADAPT_RANGE_MASK			0x80
+
+/* Adapt definitions */
+#define ADAPT_LENGTH_MAX			0x91
+#define ADAPT_L0L3_LENGTH_MAX			0x90
+#define ADAPT_L0L1L2L3_LENGTH_MAX		0x8C
+#define TADAPT_FACTOR				650
+#define TADAPT_L0L3_FACTOR			(1 << 9)
+#define TADAPT_L0L1L2L3_FACTOR			(1 << 15)
+
 /*
  * PHY Adapter attributes
  */
-#define PA_PHY_TYPE		0x1500
-#define PA_AVAILTXDATALANES	0x1520
-#define PA_MAXTXSPEEDFAST	0x1521
-#define PA_MAXTXSPEEDSLOW	0x1522
-#define PA_MAXRXSPEEDFAST	0x1541
-#define PA_MAXRXSPEEDSLOW	0x1542
-#define PA_TXLINKSTARTUPHS	0x1544
-#define PA_AVAILRXDATALANES	0x1540
-#define PA_MINRXTRAILINGCLOCKS	0x1543
-#define PA_TXHSG1SYNCLENGTH	0x1552
-#define PA_TXHSG2SYNCLENGTH	0x1554
-#define PA_TXHSG3SYNCLENGTH	0x1556
-#define PA_LOCAL_TX_LCC_ENABLE	0x155E
-#define PA_ACTIVETXDATALANES	0x1560
-#define PA_CONNECTEDTXDATALANES	0x1561
-#define PA_TXFORCECLOCK		0x1562
-#define PA_TXPWRMODE		0x1563
-#define PA_TXTRAILINGCLOCKS	0x1564
-#define PA_TXSPEEDFAST		0x1565
-#define PA_TXSPEEDSLOW		0x1566
-#define PA_TXPWRSTATUS		0x1567
-#define PA_TXGEAR		0x1568
-#define PA_TXTERMINATION	0x1569
-#define PA_HSSERIES		0x156A
-#define PA_LEGACYDPHYESCDL	0x1570
-#define PA_PWRMODE		0x1571
-#define PA_ACTIVERXDATALANES	0x1580
-#define PA_CONNECTEDRXDATALANES	0x1581
-#define PA_RXPWRSTATUS		0x1582
-#define PA_RXGEAR		0x1583
-#define PA_RXTERMINATION	0x1584
-#define PA_MAXRXPWMGEAR		0x1586
-#define PA_MAXRXHSGEAR		0x1587
-#define PA_PACPREQTIMEOUT	0x1590
-#define PA_PACPREQEOBTIMEOUT	0x1591
-#define PA_REMOTEVERINFO	0x15A0
-#define PA_LOGICALLANEMAP	0x15A1
-#define PA_SLEEPNOCONFIGTIME	0x15A2
-#define PA_STALLNOCONFIGTIME	0x15A3
-#define PA_SAVECONFIGTIME	0x15A4
-#define PA_RXHSUNTERMCAP	0x15A5
-#define PA_RXLSTERMCAP		0x15A6
-#define PA_HIBERN8TIME		0x15A7
-#define PA_LOCALVERINFO		0x15A9
-#define PA_GRANULARITY		0x15AA
-#define PA_TACTIVATE		0x15A8
-#define PA_PWRMODEUSERDATA0	0x15B0
-#define PA_PWRMODEUSERDATA1	0x15B1
-#define PA_PWRMODEUSERDATA2	0x15B2
-#define PA_PWRMODEUSERDATA3	0x15B3
-#define PA_PWRMODEUSERDATA4	0x15B4
-#define PA_PWRMODEUSERDATA5	0x15B5
-#define PA_PWRMODEUSERDATA6	0x15B6
-#define PA_PWRMODEUSERDATA7	0x15B7
-#define PA_PWRMODEUSERDATA8	0x15B8
-#define PA_PWRMODEUSERDATA9	0x15B9
-#define PA_PWRMODEUSERDATA10	0x15BA
-#define PA_PWRMODEUSERDATA11	0x15BB
-#define PA_PACPFRAMECOUNT	0x15C0
-#define PA_PACPERRORCOUNT	0x15C1
-#define PA_PHYTESTCONTROL	0x15C2
-#define PA_TXHSG4SYNCLENGTH	0x15D0
-#define PA_TXHSADAPTTYPE	0x15D4
-#define PA_TXHSG5SYNCLENGTH	0x15D6
+#define PA_PHY_TYPE				0x1500
+#define PA_AVAILTXDATALANES			0x1520
+#define PA_MAXTXSPEEDFAST			0x1521
+#define PA_MAXTXSPEEDSLOW			0x1522
+#define PA_MAXRXSPEEDFAST			0x1541
+#define PA_MAXRXSPEEDSLOW			0x1542
+#define PA_TXLINKSTARTUPHS			0x1544
+#define PA_AVAILRXDATALANES			0x1540
+#define PA_MINRXTRAILINGCLOCKS			0x1543
+#define PA_TXHSG1SYNCLENGTH			0x1552
+#define PA_TXHSG2SYNCLENGTH			0x1554
+#define PA_TXHSG3SYNCLENGTH			0x1556
+#define PA_LOCAL_TX_LCC_ENABLE			0x155E
+#define PA_ACTIVETXDATALANES			0x1560
+#define PA_CONNECTEDTXDATALANES			0x1561
+#define PA_TXFORCECLOCK				0x1562
+#define PA_TXPWRMODE				0x1563
+#define PA_TXTRAILINGCLOCKS			0x1564
+#define PA_TXSPEEDFAST				0x1565
+#define PA_TXSPEEDSLOW				0x1566
+#define PA_TXPWRSTATUS				0x1567
+#define PA_TXGEAR				0x1568
+#define PA_TXTERMINATION			0x1569
+#define PA_HSSERIES				0x156A
+#define PA_LEGACYDPHYESCDL			0x1570
+#define PA_PWRMODE				0x1571
+#define PA_ACTIVERXDATALANES			0x1580
+#define PA_CONNECTEDRXDATALANES			0x1581
+#define PA_RXPWRSTATUS				0x1582
+#define PA_RXGEAR				0x1583
+#define PA_RXTERMINATION			0x1584
+#define PA_MAXRXPWMGEAR				0x1586
+#define PA_MAXRXHSGEAR				0x1587
+#define PA_PACPREQTIMEOUT			0x1590
+#define PA_PACPREQEOBTIMEOUT			0x1591
+#define PA_REMOTEVERINFO			0x15A0
+#define PA_LOGICALLANEMAP			0x15A1
+#define PA_SLEEPNOCONFIGTIME			0x15A2
+#define PA_STALLNOCONFIGTIME			0x15A3
+#define PA_SAVECONFIGTIME			0x15A4
+#define PA_RXHSUNTERMCAP			0x15A5
+#define PA_RXLSTERMCAP				0x15A6
+#define PA_HIBERN8TIME				0x15A7
+#define PA_LOCALVERINFO				0x15A9
+#define PA_GRANULARITY				0x15AA
+#define PA_TACTIVATE				0x15A8
+#define PA_PWRMODEUSERDATA0			0x15B0
+#define PA_PWRMODEUSERDATA1			0x15B1
+#define PA_PWRMODEUSERDATA2			0x15B2
+#define PA_PWRMODEUSERDATA3			0x15B3
+#define PA_PWRMODEUSERDATA4			0x15B4
+#define PA_PWRMODEUSERDATA5			0x15B5
+#define PA_PWRMODEUSERDATA6			0x15B6
+#define PA_PWRMODEUSERDATA7			0x15B7
+#define PA_PWRMODEUSERDATA8			0x15B8
+#define PA_PWRMODEUSERDATA9			0x15B9
+#define PA_PWRMODEUSERDATA10			0x15BA
+#define PA_PWRMODEUSERDATA11			0x15BB
+#define PA_PACPFRAMECOUNT			0x15C0
+#define PA_PACPERRORCOUNT			0x15C1
+#define PA_PHYTESTCONTROL			0x15C2
+#define PA_TXHSG4SYNCLENGTH			0x15D0
+#define PA_PEERRXHSG4ADAPTINITIAL		0x15D3
+#define PA_TXHSADAPTTYPE			0x15D4
+#define PA_TXHSG5SYNCLENGTH			0x15D6
+#define PA_PEERRXHSG5ADAPTINITIAL		0x15D9
+#define PA_PEERRXHSG6ADAPTINITIALL0L3		0x15DF
+#define PA_PEERRXHSG6ADAPTREFRESHL0L1L2L3	0x15DE
+#define PA_PEERRXHSG6ADAPTINITIALL0L1L2L3	0x15E0
+#define PA_TXEQG1SETTING			0x15E1
+#define PA_TXEQG2SETTING			0x15E2
+#define PA_TXEQG3SETTING			0x15E3
+#define PA_TXEQG4SETTING			0x15E4
+#define PA_TXEQG5SETTING			0x15E5
+#define PA_TXEQG6SETTING			0x15E6
+#define PA_TXEQTRSETTING			0x15E7
+#define PA_PEERTXEQTRSETTING			0x15E8
+#define PA_PRECODEEN				0x15E9
+#define PA_EQTR_GEAR				0x15EA
+#define PA_TXADAPTLENGTH_EQTR			0x15EB
 
 /* Adpat type for PA_TXHSADAPTTYPE attribute */
 #define PA_REFRESH_ADAPT       0x00
@@ -187,6 +221,83 @@
 /* PHY Adapter Protocol Constants */
 #define PA_MAXDATALANES	4
 
+/*
+ * TX EQTR's minimum TAdapt should not be less than 10us.
+ * This value is rounded up into the nearest Unit Intervals (UI)
+ */
+#define TX_EQTR_HS_G4_MIN_T_ADAPT		166400
+#define TX_EQTR_HS_G5_MIN_T_ADAPT		332800
+#define TX_EQTR_HS_G6_MIN_T_ADAPT		262144
+
+#define TX_EQTR_HS_G4_ADAPT_DEFAULT		0x88
+#define TX_EQTR_HS_G5_ADAPT_DEFAULT		0x89
+#define TX_EQTR_HS_G6_ADAPT_DEFAULT		0x89
+
+#define TX_EQTR_CAP_MASK			0x7F
+
+#define TX_EQTR_ADAPT_LENGTH_SHIFT		0
+#define TX_EQTR_ADAPT_LENGTH_L0L1L2L3_SHIFT	8
+#define TX_EQTR_ADAPT_RESERVED			0xFF
+
+#define TX_HS_NUM_PRESHOOT			8
+#define TX_HS_NUM_DEEMPHASIS			8
+#define TX_HS_PRESHOOT_SHIFT			4
+#define TX_HS_DEEMPHASIS_SHIFT			4
+#define TX_HS_PRESHOOT_OFFSET			0
+#define TX_HS_DEEMPHASIS_OFFSET			16
+
+#define TX_HS_PRESHOOT_LANE_SHIFT(lane) \
+	(TX_HS_PRESHOOT_OFFSET + (lane) * TX_HS_PRESHOOT_SHIFT)
+#define TX_HS_DEEMPHASIS_LANE_SHIFT(lane) \
+	(TX_HS_DEEMPHASIS_OFFSET + (lane) * TX_HS_DEEMPHASIS_SHIFT)
+
+#define TX_HS_PRESHOOT_BITS(lane, val) \
+	((val) << TX_HS_PRESHOOT_LANE_SHIFT(lane))
+#define TX_HS_DEEMPHASIS_BITS(lane, val) \
+	((val) << TX_HS_DEEMPHASIS_LANE_SHIFT(lane))
+
+#define RX_FOM_VALUE_MASK			0x7F
+#define RX_FOM_PRECODING_EN_MASK		0x80
+
+#define PRECODEEN_TX_OFFSET			0
+#define PRECODEEN_RX_OFFSET			4
+#define PRECODEEN_TX_BIT(lane)		(1 << (PRECODEEN_TX_OFFSET + (lane)))
+#define PRECODEEN_RX_BIT(lane)		(1 << (PRECODEEN_RX_OFFSET + (lane)))
+
+enum ufs_tx_eq_preset {
+	UFS_TX_EQ_PRESET_P0,
+	UFS_TX_EQ_PRESET_P1,
+	UFS_TX_EQ_PRESET_P2,
+	UFS_TX_EQ_PRESET_P3,
+	UFS_TX_EQ_PRESET_P4,
+	UFS_TX_EQ_PRESET_P5,
+	UFS_TX_EQ_PRESET_P6,
+	UFS_TX_EQ_PRESET_P7,
+	UFS_TX_EQ_PRESET_MAX,
+};
+
+enum ufs_tx_hs_preshoot {
+	UFS_TX_HS_PRESHOOT_DB_0P0,
+	UFS_TX_HS_PRESHOOT_DB_0P4,
+	UFS_TX_HS_PRESHOOT_DB_0P8,
+	UFS_TX_HS_PRESHOOT_DB_1P2,
+	UFS_TX_HS_PRESHOOT_DB_1P6,
+	UFS_TX_HS_PRESHOOT_DB_2P5,
+	UFS_TX_HS_PRESHOOT_DB_3P5,
+	UFS_TX_HS_PRESHOOT_DB_4P7,
+};
+
+enum ufs_tx_hs_deemphasis {
+	UFS_TX_HS_DEEMPHASIS_DB_0P0,
+	UFS_TX_HS_DEEMPHASIS_DB_0P8,
+	UFS_TX_HS_DEEMPHASIS_DB_1P6,
+	UFS_TX_HS_DEEMPHASIS_DB_2P5,
+	UFS_TX_HS_DEEMPHASIS_DB_3P5,
+	UFS_TX_HS_DEEMPHASIS_DB_4P7,
+	UFS_TX_HS_DEEMPHASIS_DB_6P0,
+	UFS_TX_HS_DEEMPHASIS_DB_7P6,
+};
+
 #define DL_FC0ProtectionTimeOutVal_Default	8191
 #define DL_TC0ReplayTimeOutVal_Default		65535
 #define DL_AFC0ReqTimeOutVal_Default		32767
@@ -216,6 +327,11 @@ enum ufs_hs_gear_rate {
 	PA_HS_MODE_B	= 2,
 };
 
+#define UFS_HS_RATE_STRING(rate) \
+	((rate) == PA_HS_MODE_A ? "A" : \
+	 (rate) == PA_HS_MODE_B ? "B" : \
+	 "Unknown")
+
 enum ufs_pwm_gear_tag {
 	UFS_PWM_DONT_CHANGE,	/* Don't change Gear */
 	UFS_PWM_G1,		/* PWM Gear 1 (default for reset) */
-- 
2.34.1

