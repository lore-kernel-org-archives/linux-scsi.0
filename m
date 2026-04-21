Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2112.outbound.protection.partner.outlook.cn [139.219.17.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6863A4F36;
	Tue, 21 Apr 2026 09:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762765; cv=fail; b=RVI9tu+/xnpeBm82R+mkjMEZ70KUx3tUYSYKmKmxlYzQx2/c2EptrEAwPyGVFur57eXm22cpqwMpMr6OkpPAm5qAikLDt5C8AK44XVChj0v7VB0lCDdKIqaKLUTrwfmvzW7tybUoYBvvi9FqX2yV8R851K3DB3l3tmufkddJrz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762765; c=relaxed/simple;
	bh=sSglirC+E4H0b3EHpVcr8gZwN+kyYJ36kGYTHvcEDy8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MEls77UnOB/RL870mBTtUapcRngAYn00ppzBJKBZ3LRRfMeL4frcJFd7wGJEKSW644pmQxy9BY8SLl/XhEFb4tZG2Xq9cwgwd/uoljce2GCxVIT0cK6ZKju0UwisFYqYt7wF3qnf5hRG1VKGDZO4SPQFs+JiPl5/6gyDYEb7xG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9ffPHXr4ZpdzeyGRi8HuwL6nBVHXqb6VcFN08amcCM0VFBmmJtE9GzUJfyb/4uHjCwdJ0R4p9cXzTxgSgzSJnqbgsM6cDZSv/xeMtZeJhsA9Uj0LCNY9DIW0xgblLlXY0KD3r88iMTNgLfOxwu1OEqCSvGppW+2hgWxD/zqor8AOi6o4fuQZo7pvtknV2l8GBcdsZAWrTjq7zAxyeT9phrcILwr0UIEmBp3F6dviOS1aznZAMa1lqnrKcGdyRCfild6CJzdmSJN9PCnjjZbKGlN/YiCQtt2j+7h8hVLsBose4eUp0AEa7L2T9LwDLfCpAJzckuly+CsoMNH1HfS7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sen7MmBs2/iVLX1GuXmxj5DGeI9Xg281nNn0L//h1eY=;
 b=gQkWQd2n/HQhb5AaZVpOT50kW8IRg/3LCj9VruLa4f96koY5iMrDgFD0mIUQdHvxpntqSiEY48iEaJZzNCzNRoCB2UvykCC6T2v5gAo7FOAovCalnOjAOy0/yfXq5+tY8LYN3Cycqf2JUVLQRhQP/5vQPsJss0K2eMX6MMmElbFLwm1f6pMx+yPw9zNzVxbanIchK77KD941VhsfbnsUUQOlHJH5ZI9br/JqbKAVgS7tGTSqWY+KnQJWY79NDl8uSF2M4BSTjz86xnSWrtFrytCzRJGXmsHbPv1MTSyfJt3bUz4aiSECPft52PzbYWUkDlzsWfUaeLbpUlIdKKZNHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0519.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:15::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 21 Apr
 2026 09:12:27 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9769.046; Tue, 21 Apr 2026 09:12:27 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v1 2/3] scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc common file
Date: Tue, 21 Apr 2026 17:12:14 +0800
Message-Id: <20260421091215.120632-3-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260421091215.120632-1-minda.chen@starfivetech.com>
References: <20260421091215.120632-1-minda.chen@starfivetech.com>
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0030.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:c::18) To BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BJXPR01MB0855:EE_|BJXPR01MB0519:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca94f7e-1005-49cc-f524-08de9f861b8e
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|52116014|921020|56012099003|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	0aGYifJJeJ0lz55HRwQrXtbuHkcnWWCsLamexJXwHckrr+n6KNWLGNKrDP+t6zEfpOuqBFaBTg7x8ASJl8x9prt04qsrg814xMJZ6HOioG91p0x/JfX4T0rIytbcF+jdsvX6GqBUs/oRBo3KfIuLetdM1QMsosjU/jUDUt4WAOXPe51kJYJfkZ0nvoAJ1Um0abP2M8AavxrmHnl2cZM0OEkDQphs4tZfj+OMPObBKl3RpaC4lBx5LUALMP6vvMjLr/knNFfgl7eID1SPi+Y5FadnecgrOAVRG/hSLj/spVq9fLqCkjbh91yFsZ/x/DyN3kthlTXqNz/EdlTH5tswI2HNTe8jYDCQPOHHgacGBPsvEjC+xPYcW6AJrZUx0hrq5wmMvDyMHmFd/IC1+QtFPAWqYEeH2ro9RrfkTdRqg0c01676DhMFb2e1xPoYQmMOoq+7euvteTdNCSFDJVuX5DSZhxjk1htt6PCuIgtY5CXftQ2KqOTiuw4ISrtJZU5j0xsae9x3SN+HBrswoygzRZ/0AxqRNAm1k+QyRrFY8a1htfv7/9VpEv5zxWDsEpQCA6jVsSfNRgSW3exqZSpAbybDZHko2O5lrvDqT0Er1Fo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(52116014)(921020)(56012099003)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rxYHn0Ad+pjgdUVII+AbqyyE75mdwOQdqeEi77t3eL0xbEqUw+u4iqEv1jRe?=
 =?us-ascii?Q?Rwmbqt/+FVrDUzdsqxA/MSThzzy3z7EV6Tq+O64QervrKU9aC0UZaNRfQwVI?=
 =?us-ascii?Q?1S5DZZ777o/Y/XUCMEbvH1DGoDo0HlzOzTF17C3M1QnF5fT+GJttpDbtALXP?=
 =?us-ascii?Q?UzesS5A1lD4t/4z1sgflA0F49972Zqs/Nx1ca+Sq2vkQ5J7sd8zSOFcXER/A?=
 =?us-ascii?Q?AFOBE2WWXMumonrOh2bjWCYIQEWfwWgnkq2TZSsnEm1TM/pMVvN0ID0uB6dJ?=
 =?us-ascii?Q?hqjuYVbJpmWt/zGLgwQj5XhaH1xaBZNLx8lG62rdRrF+T4p8o59xPgJf0g3e?=
 =?us-ascii?Q?cpCJgqTcdAzEZCSldy5AfdSdb4oJSEtCVHYyjeujTP+EZOKCHiB9vsABPFaO?=
 =?us-ascii?Q?a/QG7pJythTLnUOObIbbe1+UBwkskIEqfNDnExOxDRSYXu6kRp3fqKXnqcqp?=
 =?us-ascii?Q?T89bEbqVOFaLKgR0sGvLJKqTCW4clEFqqhfaezDQFaCiBPwlU5o9C/BOWOUQ?=
 =?us-ascii?Q?AUzbu3bRVnrzTWs+2TaPkqsgkH6cISgBp74d+jbwBI8YlFInY3dO+PcWbwip?=
 =?us-ascii?Q?1QWosoam2rSseT36ZWl/s23Z/krVsBHQLRUqeXe1Oqkh6emGocFqLyE0WDrI?=
 =?us-ascii?Q?T+mcCz9y2NY9MY1XyOndXQkkjknoniMcqqWzJ7zo6ZX6lIDmOQTLo/hbNkeS?=
 =?us-ascii?Q?pY0ea3eeGBKuBVlSBgxTLDq4CjNwQMsKWeJd4VXqSx2lWRluHn0kr427cOLV?=
 =?us-ascii?Q?J1qGRACnPZLawX8WDGrR0lCG1FhzGawBJbnydF4o1kcV1oNtyw3UKEwb1Vsh?=
 =?us-ascii?Q?sk3epQE7I/A/QspevrWmzLePTlzDU2Y3KT7C4aOZfFgQ1q/eCbZjPuDSSuIT?=
 =?us-ascii?Q?YbudNDwItnH3cs3zxzDGf40Q/feYQs7F3bXGrin9JPGulbZnujgrlLnrHIg2?=
 =?us-ascii?Q?E0cjzb8piHpqlfZCgIU4tUlZDU8rOTiOndSSp3XITJak826s47+8UjwDxxRS?=
 =?us-ascii?Q?etwP4R4N4CCHCPuB1Cp5sLJH5kCpO2QcgEVLdVzyPrdlyr8ULJgjYs3jxgVK?=
 =?us-ascii?Q?ePG3z3+tvf28ji5TeS8Gsj7hJ74se7h3xy3VcOhjQpECw5XkHilD/ldwJUsa?=
 =?us-ascii?Q?Z1QTNkP59XhDNihDlk2eRsR8vSbjiyqKHalUsO7DMCEqWaT9R8ybk89uaEtf?=
 =?us-ascii?Q?IXXJLBeVkJP3KWtqvBDjIR6paIeV042HRSN2W2ePWvVdmemqbsK8MauJIpeD?=
 =?us-ascii?Q?y6gog2/kDqEdF/KgkQI8MEM5gYiLcmwB8b9U+/o6Gbdv79b76Tnrxv8uu014?=
 =?us-ascii?Q?fxvoyAqvcJ5RRFkdi4hlP9Eg32BYs049EjjOZOU5sLFxezRDhuOUUeLtfJUU?=
 =?us-ascii?Q?VkNdPyXls0aWjh5XpnmwuMsl7V/+GzrIeIX5OS5QV+tNSdBjjlfzmE84SbJ5?=
 =?us-ascii?Q?r4TDPfi+szc92ercryecheMbT1HhwynSev3ZbKa/z3DAiHL44Sj6lql6HkJL?=
 =?us-ascii?Q?Ss2aBKbFn36rvOmMO6NcxpAXxqISEYJLua0AJQUJqSQ8V1iLjmny13UM2OYi?=
 =?us-ascii?Q?2qO1q2nbwfw8nhIqvk/OTHms2g865Ml+bXh6X7cbO7iG8uo56tXdSsZ1PRTw?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca94f7e-1005-49cc-f524-08de9f861b8e
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 09:12:27.0923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QB2rNXep5UXotZkJ0fejaZjlJ8uNU8URJUwD8itDgeZaw8PW6UtbuzP9uHBiW1vUWx7k+fops5G5FnzOzNm/kbC53hJ65lSBMDH58Xk9iac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0519

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
index 6c454ae8a9c8..0727b5e58be6 100644
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
 
@@ -486,12 +435,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
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

