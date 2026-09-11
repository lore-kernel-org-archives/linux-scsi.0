Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2132.outbound.protection.partner.outlook.cn [139.219.17.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEE243A7E7;
	Fri, 11 Sep 2026 10:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122274; cv=fail; b=VzeIjoj9Nu/avOq+f9b9RCD0TjjzyxB6106aHOqUPD6p2CBMFCk8sXITVroysDsEgFMmWnQtIUgbeaStXz+QB3b4Hcm4l0tBQLXVQ1XSP99Y844Pe8sC9hCwY5UM90Bw+C88s7Q7R9wjJSk4y07WvYAgeRG5rboXOV0b46QgwKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122274; c=relaxed/simple;
	bh=1md+k+jdnycV06xXtdR04WxvTvNMX+vKJAZTCLB4NRI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gr9BolA4fBW5OvYpg67w0x6wmEMPRK9xp5Qa6GTrgj0D2kTNp7ftPnhBN0Ufu0LA+QVvg80Ip/w2ZYtme/f3BueGVcbz/1doRF9w9rEjKTS04R2KL3/AMJjfciEEZn6UTHh7FGcbSSPlp6Fo8mLkR/YElepOvjfv+4LmrndVImE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTjne+I3lsKqs4RIwAvH8ETK4+rdmt52PdkfgLgRC9pB46pvuyJLBtw4ztOxB80y0YE2SwfF1hBcgS8hGj0jiBa+Kp55+VIr78MMSrCEpQlHJLCemj1zLXDX4XxX875J37/z6YlkJMFieKMisFJq1bS0RBR1dsevVZ49BgznaB/vx5d7FnHO3fB+e5dXH1jeqvSDVXGDh9NJ1cC6W5dcGO4oHfeL6cZUia23qY8eF5AvMYsXBrG4gGVDjNrbOBPaLi/h3oKQ732soFc2Daya7+cuWRLZC6qQPwr/i0s+2XxxmUq5mtiGOXYlqLkCmV7RxASgpTuTs596yaJ4y2aX5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4EzxHFUTu9WVBH+v0tR9P7XybMLoPk/e0NVjTM3rnA=;
 b=O7wwDtF1Twe9QW8sJKwudCC57VOCUaAOuMFVFx8JY+hxi8i4X/Zi//8byUa+BBvZMu4433h8G+wA5OYo6KGZ+iE5N3/01ExMVQgp9ypOJzst5uHeSLOOaIlU3Q/CzVBHQdctSE8VXZX/liV3wpiMPE7P52B2UUL6jOepfB5uYgbFmGqLz3gErX+Uxxfz0/ybrWdSwolVpq5bhnRA2LCWfiI9pT3//G8MOXMQm/HPQXEGMXukclBT7xG7RGY+5/1bcE/ScGKtD3UDNQKRqSV4zWMlXTIA71R/0lOnLs9ZycVt7ryoozMziXaK9PdX3MqYQx/n0oW7TzGV3R1QJXu13g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15) by SHXPR01MB0573.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.18; Fri, 11 Sep
 2026 10:24:13 +0000
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 ([fe80::9b99:12dc:a115:b90f]) by
 SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn ([fe80::9b99:12dc:a115:b90f%4])
 with mapi id 15.21.0339.017; Fri, 11 Sep 2026 10:24:13 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v3 2/3] scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc common file
Date: Fri, 11 Sep 2026 18:23:58 +0800
Message-Id: <20260911102359.83288-3-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260911102359.83288-1-minda.chen@starfivetech.com>
References: <20260911102359.83288-1-minda.chen@starfivetech.com>
Content-Type: text/plain
X-ClientProxiedBy: BJSPR01CA0016.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:c::28) To SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SHXPR01MB0863:EE_|SHXPR01MB0573:EE_
X-MS-Office365-Filtering-Correlation-Id: 155ebce1-d236-4e7b-384c-08df0feed39e
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|366016|23010399003|1800799024|38350700014|921020|6133799003|3023799007|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	p1RApmtTnxFrpxuCU3dhWxG2E+l4KhVfzHEHOtN+sbZpFJcMAHCp4KKINYFL1IckOApvD5cbQvQJ+muRP23NxJopdlAMfHbdjCVFpAGeuPD+ZbpYM9XnLXQ/Xs7DIqdYaTEqgtLmKcHzWfAQD1DjeMVLWNazPO2mdSMpZhI81AuOAErtpPv5gi0SLZcErvcdxj5h/nfxRAdbce4V4kBxxYYl2JFVm2Xb4tNcUnIbTBboJmCKYy94t9OeptAxo0TSH5u2sQrM34+GkBBVwNPPMIue0T6XG1c2B1HQf7V74xH0FKOlhTm2GVauAFjRSVQDRh9OEiiAwDdh79261C53H/fm6T6HcoqoGJZ7WZ22FOfblxT5Bps6zLepheBbvOnkabu/hYApE9UaoehU+1WcO0JaSQDrcWHVEUioVdz6FN7SSXHOZrbcTRsZsY10yzZ+/Pryturtz7JCIpqD1B2C0jQ6obXS+1HZKrcuJ7sshaPYNKORHB/NXs2y0yt7UqBKoE2QR3NrDt2A6nJysPflxaA6iq5rVvbmNTDWXV5f6LAO1n08hcinYnNs5dgqhllx/YxsIj3sEKljYI1nW+yl9w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(366016)(23010399003)(1800799024)(38350700014)(921020)(6133799003)(3023799007)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xBtmAdIp/ARrO9tBhXqKAunPxSRMHqxSfyKzzNjaYBHVxz8RwBfahPNXPbiV?=
 =?us-ascii?Q?tZepUhvLOY+hVsl6gkWjbaUSlYX2eoQMRdYAONaG8llrLb6M/8kp/Nt5J4IB?=
 =?us-ascii?Q?EgTG0VupH8FCYTB2Nt2FoDIkDSa3M7EloyRszgBqgyBvX84RDyHrRGxUXuH1?=
 =?us-ascii?Q?vOrx05pxuzeVA+f1rJLNrUCU0qeTw3CZzSIQdwMq6j0R0JBoiddNCVwznubU?=
 =?us-ascii?Q?9XrvIMT5Aytl4a4jaHMyGr5N6mpwTQ6ABV1s6luVOEQrWbTPdOhEImmjAKPr?=
 =?us-ascii?Q?h/6UCXhdINn6NYYJQuQhdlG+y/2r0TuJxWf/bCl7WdCxWrdCdieORgg83aZn?=
 =?us-ascii?Q?PtIyfJghn4DlR7cMAy0YX8oTMhSY+xltHgwQB3WuI4Qyx7uL5K18eCbX4taV?=
 =?us-ascii?Q?yDfAMS7n9fdZFO3Id1e1xH4HgwPjY2Xe9OutNowmXbYgmzUA4M0TYm1mHh8c?=
 =?us-ascii?Q?q99LlxKPz8gHxCAm81eJ1e9b1gJvyI/t31D7HFVsnnpS/On3NgDbWin8iSE4?=
 =?us-ascii?Q?1BA/qA2EzMLIeKpfrQ4s8P2Tn+LxFcJwdesyw/NDMuxzAViCXjYHD0NNtHav?=
 =?us-ascii?Q?SENPg9VDj5VS5VJhzUEHklXVvFYV36v3ppJK4IaQGCBE0hXWRgaLkhxT7tZg?=
 =?us-ascii?Q?cpsD4HS0HRxaf8J+lIfV+tpNibCtfZSl9TtaWspn2aGi1fdCj4ywd87Jsk3w?=
 =?us-ascii?Q?m51X97NKTbEK0W9Z/KnSNnc6syyUOr6LFJjjZkgdQvSnL4ryHCIKgaITtPLR?=
 =?us-ascii?Q?5nWTMfafyOaOfk1kxip1rMfZH58ZSlnUp9/myJ+CzMkzNoSsCQJT2qNyXP0/?=
 =?us-ascii?Q?WJR0VvN3yVOO2PVhmJAhdq0QvJAKSj07kwC4ANGHFkPcNfkwG8Ul0pTv07qt?=
 =?us-ascii?Q?/dPdwE7/FYDfrJ7aF/hES/KHRIux/bTqejAMDcZuSY9ECgr3YDwlS7RwERbD?=
 =?us-ascii?Q?tFvhFciBgK0M4Y0aP0yyTQRHdNF0epZiJw3yyNhcPPduENs/MTU4JgZd/zXg?=
 =?us-ascii?Q?Gevatwm6sxMqesIJw9nwGBon9nJKDls5PiU0UcPaqp8kQZZ9am5RIQoNja56?=
 =?us-ascii?Q?3PURFreV4dHcXdZgS7BNZnPNQp1nefVDGvz5QLs+QUhcBaANqtR9s4eL2qxU?=
 =?us-ascii?Q?JNTlocaa+85eMGh0H0s+ErUggjkFichGt/Nn+48OEaEMaokijxNjMw0BORkD?=
 =?us-ascii?Q?dn+jEnSGXWHJHxaPxsSrj53Ouubtkf07IYYGBrrqk0Otto5QySRg0XgR0N9K?=
 =?us-ascii?Q?+Q+3oF9U1DnoTPJPUDoiNcztMkHv2MkMDUEijFTxXBYwqmdNIy6MjkI9Nski?=
 =?us-ascii?Q?tfHGlePpj2LL+Qnuegvr0hSLD/DUY+tTo2vSfv774fRsV7iCUUAjKNw8oVQY?=
 =?us-ascii?Q?NtuOA7nLpzJ3N2VBuBe+5BCbTPaZ8JRnaIlvMc6Ju1JZzSiYpEyTNN+07YLP?=
 =?us-ascii?Q?M0pziTV0GxpX/XD3yoe8Z2fPSJp+S/3ETd9F4rvtxr2aknX9LtYtHXQ8pt4+?=
 =?us-ascii?Q?03yo/QqT4hp0MfE2t9Ke/zSKZdv3oCo25xjQeWV9+uJ4zTREFTI7Lv2W6uAS?=
 =?us-ascii?Q?5xdosYL/Zj100bdVNIbumkamd9B5Ajq0RikPQIedPj/8Nc72pzJ5OLQAPwjv?=
 =?us-ascii?Q?xEL4GeTjH5YuREalCX1/YY5kHU8f3B+CiFteH3rtv3voREj2TaNTUBqu7uDo?=
 =?us-ascii?Q?hRIx13xpHk6pepV2me/bE2igUJVO2wAF9t++zYU88+Fop4ntclEBPRgrVkQn?=
 =?us-ascii?Q?82vZ4CYp3kOIak4eAlOkqLHzAxkBFHU=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 155ebce1-d236-4e7b-384c-08df0feed39e
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 10:24:13.8089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ejDjXlfEQ82PfN/AkU5VvjcJP1kzQz0NOsFYz+R4B6JXEtCCrsF2B/jVm8VZQiYd4ftV4d/xI8cO+4uP0l9qn3Q5Uoj8f3i0WzG00wmYSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0573

AMD versal2 UFS using designware ufs mipi PHY. The read/write PHY
register API are common functions for designware ufs PHY. For other
vendors reuse the code, move to common ufshcd-dwc.c file.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
 drivers/ufs/host/ufshcd-dwc.c      | 53 +++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  2 +
 3 files changed, 72 insertions(+), 68 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 2154d6286817..2e671881e7ae 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -43,57 +43,6 @@ struct ufs_versal2_host {
 	u8 ctlecompval1;
 };
 
-static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
-{
-	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_write_attrs[0].mib_val = (u8)addr;
-	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
-	phy_write_attrs[2].mib_val = (u8)val;
-	phy_write_attrs[3].mib_val = (u8)(val >> 8);
-
-	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
-}
-
-static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
-{
-	u32 mib_val;
-	int ret;
-	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_read_attrs[0].mib_val = (u8)addr;
-	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
-
-	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
-	if (ret)
-		return ret;
-
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val = mib_val;
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val |= (mib_val << 8);
-
-	return 0;
-}
-
 static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 {
 	u32 offset, reg;
@@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
 	u32 reg;
 
 	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
+	ret = ufs_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
+	ret = ufs_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
+	ret = ufs_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
+	ret = ufs_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
 	if (ret)
 		return ret;
 
 	/* Program ATT and CTLE compensation values */
 	if (host->attcompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
+		ret = ufs_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->attcompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
+		ret = ufs_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
+		ret = ufs_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
+		ret = ufs_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
 		if (ret)
 			return ret;
 	}
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
+	ret = ufs_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
+	ret = ufs_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
+	ret = ufs_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
+	return ufs_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
 }
 
 static int ufs_versal2_phy_init(struct ufs_hba *hba)
@@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 
 	for (lane = 0; lane < activelanes; lane++) {
 		time_left = TIMEOUT_MICROSEC;
-		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		ret = ufs_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 		if (ret)
 			return ret;
 
@@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 		else
 			reg &= ~MPHY_RX_OVRD_VAL;
 
-		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+		ret = ufs_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 		if (ret)
 			return ret;
 
 		do {
-			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
+			ret = ufs_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
 			if (ret)
 				return ret;
 
@@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
 		/* Remove rx_req override */
 		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
-			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+			ret = ufs_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 			if (ret)
 				return ret;
 
 			reg &= ~MPHY_RX_OVRD_EN;
-			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+			ret = ufs_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..b057a78e151c 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -15,6 +15,59 @@
 #include "ufshcd-dwc.h"
 #include "ufshci-dwc.h"
 
+int ufs_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
+
+	phy_write_attrs[0].mib_val = (u8)addr;
+	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
+	phy_write_attrs[2].mib_val = (u8)val;
+	phy_write_attrs[3].mib_val = (u8)(val >> 8);
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
+}
+EXPORT_SYMBOL(ufs_dwc_phy_reg_write);
+
+int ufs_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	u32 mib_val;
+	int ret;
+	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
+
+	phy_read_attrs[0].mib_val = (u8)addr;
+	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val = mib_val;
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val |= (mib_val << 8);
+
+	return 0;
+}
+EXPORT_SYMBOL(ufs_dwc_phy_reg_read);
+
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n)
 {
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index c618bb914904..8091f186a9b3 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -68,4 +68,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
+int ufs_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
+int ufs_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
 #endif /* End of Header */
-- 
2.17.1

