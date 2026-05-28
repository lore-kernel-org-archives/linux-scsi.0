Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0DE352005;
	Thu, 28 May 2026 10:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962808; cv=none; b=GXokIvoVqe1R6+MGiIzpXWqR2lMdYo2vaQkd6Jxn6rPDEmJhAY8yQ76GX8yT27jElTfTkpiTE21KjZyEoX1aNScK8nLwmCq9ccxU5pY7sk3j81Q8hsXLxvr5srkPWyAkAKME/BDs8aXrLZrPk6K2p7yCNmKKiBk8OBfP8KMjjVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962808; c=relaxed/simple;
	bh=8/akjcJessiXzRUpLTRyh5QIkUI9KQbWvIHiI/AvzrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nee2AR6l3/pgLRESCeb54NYgtKBuL5nbwRt6J2496sDZz7G2pkEEO7b+MyeRHTfaYilQUDdB+kAnqF7RnVJs6APgcSdnbp/sD+6usf5kBeevZtP29N0QIolm/DwE6I49SDAo0wEAzeh8DqNq2lHv/pgA9kVV4kHXiPuUDtNTAJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XtlQUXdl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XtlQUXdl"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S8vSF44184457;
	Thu, 28 May 2026 10:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=rszNl9XnD9j
	K1wIRgTuAQ6Syz8B3uQLRSOCYtSWJhq0=; b=XtlQUXdlJ++vJXKeHDeTXylYgtX
	9VUw8X6iUFDRs97PKzYkTEOZibS5jQHxHNC5KQw5/k8buXJcLjr1HwG6GUQ1M3y2
	bS0M5P/3sKdFiLN3JvfBefJU8V8gDGpMBQkScebIc4szzA5w+a1/WfOsnzOy7lOi
	EkP5j2Qu022VxC79KbbP7hVzJUcYAMP7Ai4SQ5n3JtDlD9lzMOseA+8A5mWBkDGI
	jVRSvWZPr/j+DGNx7DVnpeHSp2vlxUx4v8SKlppzRgdejsv2ASA/NWnPaLrRaEZb
	z9oE4c5Xp2vwcnA9OjGyppaInyIP+4ZNp2AVcQtbtPOJhi5i3UFC/4XjIcA==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ee7yf2ass-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:32 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64SA6Vsa015449;
	Thu, 28 May 2026 10:06:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4ee8c5cx6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:31 +0000 (GMT)
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64SA4huO013320;
	Thu, 28 May 2026 10:06:31 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 64SA6Vox015444
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:31 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 0ED6962C; Thu, 28 May 2026 03:06:31 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 2/2] scsi: ufs: core: Add support for static TX Equalization settings
Date: Thu, 28 May 2026 03:06:14 -0700
Message-Id: <20260528100614.3386423-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
References: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-GUID: t1sJGitG2PY29ac6Hh-yrYIHqLxbrVwa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDEwMiBTYWx0ZWRfXwzIPOhZaEcHo
 5Gc10KgG0I2wq54KfPovsYdWTwieUm4bc5xiiTrXX8dH3W6XkW9Gr/xikHtysS/OBtXCekBt3zw
 6Nrdd3fpzqmTYs9rh3ErIGiZuuGZvhpKNJ9qxzvCjhSJeMtf6fq19xemNubUf5QA1ghehzvA0YV
 uampF7kcXbiJys35Aq9VETApYxiKCD2HgZuK/yZopj1yYSLnq4TgNu3Ztn4ojwCK/H/AaiAU68F
 m1AIu3p9tAuFsZITEXcNx2WDFASCDh0jhqMle0IhAvwxUO2y1cWzzKAHal6yeLEebJHJrJczo8w
 TUV3MDhSS37l89/rxbXLTvTthtlOFWZfs/XSANa3ztE1s60SwfzGfE237GmC9ipKwRvi0zmF40Z
 vwDnDDoJEsTtysK5XRu3zfLg6GEVv2ALScBpFiM6Bmr+67oLFNrB8xMHrHnVC+dQVQuQ0Fe2fSr
 Kxn0PRAxhCD6pMLhHGA==
X-Proofpoint-ORIG-GUID: t1sJGitG2PY29ac6Hh-yrYIHqLxbrVwa
X-Authority-Analysis: v=2.4 cv=G8gs1dk5 c=1 sm=1 tr=0 ts=6a1813a8 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8 a=-xlrxDLzkpAifl49RugA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_03,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 malwarescore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280102

Static TX Equalization settings and TX Precode enable indication from DT
properties txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
tx-precode-enable-g6 are board-specific baseline values. Values are
provided as per-lane tuples:

<Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]

Parse DT u32 properties with explicit range checks by using
of_property_count_u32_elems()/of_property_read_u32_array().

When adaptive TX Equalization is used, these static settings are not final:

- If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
  those retrieved settings override static DT settings.
- If retrieval is not available/valid, TX EQTR runs and trained settings
  override static DT settings.

So static DT settings are a fallback and are intended for cases where
adaptive TX Equalization is not enabled/used. Adaptive TX Equalization
remains the primary path when enabled.

No behavior changes for platforms that do not provide these properties.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c      |  10 ++-
 drivers/ufs/host/ufshcd-pltfrm.c | 126 +++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h             |   2 +
 3 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 4b264adfdf49..b645fe5f6d95 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -1297,7 +1297,13 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 	}
 
 	params = &hba->tx_eq_params[gear - 1];
-	if (!params->is_valid || force_tx_eqtr) {
+	/*
+	 * TX EQTR must run for the following cases:
+	 * 1. TX EQ settings are invalid.
+	 * 2. TX EQ settings are valid but static, i.e., populated from DT.
+	 * 3. TX EQTR procedure is forced.
+	 */
+	if (!params->is_valid || params->is_static || force_tx_eqtr) {
 		int ret;
 
 		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
@@ -1310,6 +1316,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 		/* Mark TX Equalization settings as valid */
 		params->is_valid = true;
 		params->is_trained = true;
+		params->is_static = false;
 		params->is_applied = false;
 	}
 
@@ -1495,6 +1502,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
 	}
 
 	params->is_valid = true;
+	params->is_static = false;
 }
 
 void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index c2dafb583cf5..6fe360efa80a 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -210,6 +210,130 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
+{
+	size_t sz = hba->lanes_per_direction * 2;
+	u32 lpd = hba->lanes_per_direction;
+	struct ufshcd_tx_eq_params *params;
+	u32 deemphasis[UFS_MAX_LANES * 2];
+	u32 precode_en[UFS_MAX_LANES * 2];
+	u32 preshoot[UFS_MAX_LANES * 2];
+	struct device *dev = hba->dev;
+	char prop_name[MAX_PROP_SIZE];
+	int i, err, count, gear, lane;
+
+	if (!lpd || lpd > UFS_MAX_LANES)
+		return;
+
+	for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++) {
+		snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
+		count = of_property_count_u32_elems(dev->of_node, prop_name);
+		if (count <= 0)
+			continue;
+
+		if (count != sz) {
+			dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
+				prop_name, count, sz);
+			continue;
+		}
+
+		err = of_property_read_u32_array(dev->of_node, prop_name, preshoot, sz);
+		if (err) {
+			dev_err(dev, "Failed to read %s property, %d\n",
+				prop_name, err);
+			continue;
+		}
+
+		for (i = 0; i < count; i++) {
+			if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
+				dev_err(dev, "An invalid TX EQ PreShoot (%d) provided in %s property\n",
+					preshoot[i], prop_name);
+				break;
+			}
+		}
+
+		if (i != count)
+			continue;
+
+		snprintf(prop_name, MAX_PROP_SIZE, "txeq-deemphasis-g%d", gear);
+		count = of_property_count_u32_elems(dev->of_node, prop_name);
+		if (count <= 0) {
+			dev_err(dev, "Missing required %s property\n", prop_name);
+			continue;
+		}
+
+		if (count != sz) {
+			dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
+				prop_name, count, sz);
+			continue;
+		}
+
+		err = of_property_read_u32_array(dev->of_node, prop_name, deemphasis, sz);
+		if (err) {
+			dev_err(dev, "Failed to read %s property, %d\n",
+				prop_name, err);
+			continue;
+		}
+
+		for (i = 0; i < count; i++) {
+			if (deemphasis[i] >= TX_HS_NUM_DEEMPHASIS) {
+				dev_err(dev, "An invalid TX EQ DeEmphasis (%d) provided in %s property\n",
+					deemphasis[i], prop_name);
+				break;
+			}
+		}
+
+		if (i != count)
+			continue;
+
+		memset(precode_en, 0, sizeof(precode_en));
+		if (gear == UFS_HS_G6) {
+			snprintf(prop_name, MAX_PROP_SIZE, "tx-precode-enable-g%d", gear);
+			count = of_property_count_u32_elems(dev->of_node, prop_name);
+			if (count > 0) {
+				if (count != sz) {
+					dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
+						prop_name, count, sz);
+					continue;
+				}
+
+				err = of_property_read_u32_array(dev->of_node, prop_name,
+								 precode_en, sz);
+				if (err) {
+					dev_err(dev, "Failed to read %s property, %d\n",
+						prop_name, err);
+					continue;
+				}
+
+				for (i = 0; i < count; i++) {
+					if (precode_en[i] > 1) {
+						dev_err(dev, "An invalid PrecodeEn (%d) provided in %s property\n",
+							precode_en[i], prop_name);
+						break;
+					}
+				}
+
+				if (i != count)
+					continue;
+			}
+		}
+
+		params = &hba->tx_eq_params[gear - 1];
+		for (lane = 0; lane < lpd; lane++) {
+			params->host[lane].preshoot = preshoot[lane * 2];
+			params->host[lane].deemphasis = deemphasis[lane * 2];
+			params->host[lane].precode_en = precode_en[lane * 2];
+
+			params->device[lane].preshoot = preshoot[lane * 2 + 1];
+			params->device[lane].deemphasis = deemphasis[lane * 2 + 1];
+			params->device[lane].precode_en = precode_en[lane * 2 + 1];
+		}
+
+		params->is_valid = true;
+		params->is_static = true;
+	}
+}
+
 /**
  * ufshcd_parse_clock_min_max_freq  - Parse MIN and MAX clocks freq
  * @hba: per adapter instance
@@ -528,6 +652,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	ufshcd_init_lanes_per_dir(hba);
 
+	ufshcd_parse_static_tx_eq_settings(hba);
+
 	err = ufshcd_parse_operating_points(hba);
 	if (err) {
 		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f48d6416e299..c01824576472 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -359,6 +359,7 @@ struct ufshcd_tx_eqtr_record {
  * @is_valid: True if parameter contains valid TX Equalization settings
  * @is_applied: True if settings have been applied to UniPro of both sides
  * @is_trained: True if parameters obtained from TX EQTR procedure
+ * @is_static: True if settings are static
  */
 struct ufshcd_tx_eq_params {
 	struct ufshcd_tx_eq_settings host[UFS_MAX_LANES];
@@ -367,6 +368,7 @@ struct ufshcd_tx_eq_params {
 	bool is_valid;
 	bool is_applied;
 	bool is_trained;
+	bool is_static;
 };
 
 /**
-- 
2.34.1

