Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.134
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794470208;
	b=BbBJoNRNFwIPHYyeVXfM374El+ZqpKK8CZrjYRCoDUXzuKT4SDGWcynLBKgHtVwE3HYH
	 pAUe2nAPTVNBC16YjQ8kK4xxKHcbzDtNsq7e7uL5uJHHWEbaE9IBOZWs08gRV+LfDIVHQ
	 K6Zdk/A4FNS1JSwpkNkQB6eiV35VzYktbIngibqfdW3Rhi3RxjE7Fr8YJ3dB8dFbyU5DH
	 IJ5FtO1pWfuncBRelZq42R8U3iVIVzx0aLWIjdu8NTQyrRlZZaXnre5PdX9AXGIcehqSU
	 lVmX390JgYNer0DDHpG+1F8QP/urct0ZeX+R0nPimL5ufgX2NBrrm0a7x5gFDN5TD4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470208;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Type:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=CXOxi+zfwhQyMKk+2647IjewZYKpz582OzXOoviTcmw=;
	b=jBjrQ9aYi2rtQJI2N4vod0dGJYqwexm1uoK/IRE1g2sWqyRoUHicwWLC5UfZMBHnTxbw
	 RaTDbP7MTJzTeFYbtBstMFZqIdvgMuY9v44CYbXdOXtd6mKvMhKSrcnbCib/lHDS5D5cC
	 dHFQMYoPR60g48BcGmA8CU0vQ6qpa2yDJCPbjsY1b/ByfT1tcbGnnn3ZsQrCZOXRQN4oe
	 fKl655Sykea6flIrekx7bwQdbldiI+6OZUOABbci4L+dZLzvIPR6XrafmIIUs87R/liF2
	 RmVaV+OnMPrRHNCpTy1QITwIgeRfSn2BMYLPf1lV6MWF/dbm/7itwi8HQ5RhAfggMig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.134
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2134.outbound.protection.partner.outlook.cn [139.219.146.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3490606A327;
	Thu, 12 Nov 2026 07:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3490606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnwHOtzaeHLSdT8wPL6MLML0fvIA8IIypi9NySC3W1rWRcLskbrBfsy5Sk90j/c7tHqnrEfuTj1O4IfKCFimi56H7KBpN26Xyro/pVTN+flLTZZ7Lqcc/Ep7K/s00wsKCTC21i9EkYH6AGMIhJLy2R1S+gBwsraS3r2kAFN9IdtbxpKs/ETclbOfvSmt+It2BUjj/+bL9KHHr3fcAPDq+3fWZ15rLuegyHrr+AQPv6F+RvsUswtbRBxalwD7lcm3MU2NJNqVn3kMe4mm4nO+PVrePn3UxVjsrUcHq0X0dfyIdWLMAjkJJ+dUyxumomlp8jwE9KHPXSvMvTYgLuQg1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXOxi+zfwhQyMKk+2647IjewZYKpz582OzXOoviTcmw=;
 b=Sy/wmyCXxSChtMvVL35y04P5cU2aRgVLjIEOjHgUteru7oosv11xl9c9dOqj4gGSi+DMS8kySw4ZNhm66GGEMd2VE/BrZWd5GKbpXlewMaoK1nM4sbJfM1PCPzR1aFgynl+wxMdrvA9d+g7F0bvIOqmN3u5plP+17egK7xPUif5c22pIX9XnkQ3opbnbIA+KWcOefwyMw1t+/O0WOvoUX1UYzf0n9o/rN36fMDZr476iDuib/lpKR3yrH6Yzg2GgU1jWifMF6XgFB6v1tXNNwVRl0lMJwiCY1wxWj1bVA5uR5F0KrL+ER9unjUh+INdkc+jHSWDgiL87dnN82Rjp5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::7) by ZQ0PR01MB0999.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 07:56:27 +0000
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 ([fe80::d777:e23a:d111:5fa1]) by
 ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn ([fe80::d777:e23a:d111:5fa1%6])
 with mapi id 15.21.0615.009; Thu, 12 Nov 2026 07:56:27 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v4 3/4] scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc common file
Date: Thu, 12 Nov 2026 15:56:15 +0800
Message-Id: <20261112075616.118436-4-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20261112075616.118436-1-minda.chen@starfivetech.com>
References: <20261112075616.118436-1-minda.chen@starfivetech.com>
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0035.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:2::21) To ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::7)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1111:EE_|ZQ0PR01MB0999:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f60a3ea-3904-4422-02b9-08df409274bf
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|52116014|366016|1800799024|921020|38350700014|261026140227099003|56012099006|10067099003|261022105027099003|261021121427099003|261021123027099003|261026121527099003|261028144727099003|261102130727099003|261102123227099003|261009223027099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	5Z9ldNDVvzwNRdUcygMsWbDkpv2YVlDntAbz+dm7NhhsH/ivCbaCOCD1kRqSvB/WC82H7fVQa0bmGPBpZVheeDpN/RCZLl5z3XSx2T4eg4pIuen6kJ/iJqtha0LDWg8v1Z4ULQG3oJoXWU60p9CTytI09PQqM5LgsWm9zJ3dAyor3bBwqBr1AaOpTR44vf9FdnmJGXI0YDtbI13Q1yad70Lh6DkVsIfGmDpz1H1zU3gJWOSSND6JbnQknKxnJM9oUIGva48n/pEB9COyOQu/EcShxELcdx/t0TX2uMAF42UOstoZh9cu3ASaYsSeNI+zhaecSvIfqwr1KKE6fndyljNKgHgocdT5FnMfFU0+FBvxZgeAAPDG8N9vTgFzHysjhjS2Q5m9olnZTOS2kmFak1a/tDOLPm4cy8/IgzPI0BKCRvW3lrZJvrlcG7t4VAhTB+BELPw0s9sAuesxfT0/bxsIYCtoNUVX+iqDecCcKDdFHt2mOY5eCTgVJRrDcCgjM+/wQx+uudkDcY27xSKe/vC7R7qQRCpcBKdTmf6/onQ31jJcS0WDDBsO2OuRlnfvFUzNE4JALAKVwWHqPoO2zQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(52116014)(366016)(1800799024)(921020)(38350700014)(261026140227099003)(56012099006)(10067099003)(261022105027099003)(261021121427099003)(261021123027099003)(261026121527099003)(261028144727099003)(261102130727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hEVQuEE4bizrel3jWoQC0+PM3F4cqKhsQ0SVNfh+HtaEv1AC5C6Xk4V3BYxj?=
 =?us-ascii?Q?dbxUdHYYfI7LAJiR0W5c3+VLsrVGFjGVaMrV6OScWWd7dyVRkog6W7IxYOXW?=
 =?us-ascii?Q?CgdFVtFRzasH5cPNESAeRjqTzLeN1lhnnZRx4EEeK3o1HRGPYMtcD4vD+FvL?=
 =?us-ascii?Q?ckx/wotBcuZGVfRXAT0SIL//62f74d3CnahnO6alS23QpGqj3EdN6xWyWNUN?=
 =?us-ascii?Q?TtqEX174XKd/K9SGdW50EvVLfrZlgH/DbVrlaJ2OjG1WPXbYOmS4S8BHmKMB?=
 =?us-ascii?Q?U8qLByslGHgrDhH1Ux02fW66D3z0H2G8PCtXj0zxoqMn2td26hnctlJf5tr9?=
 =?us-ascii?Q?9ExzDNjbpxi4F6vVQ7uX7jnYsgBbeHXlswWWDqp0f5Q23QhgQJUE6LqZUzmu?=
 =?us-ascii?Q?luuCe2IiF9DW1VXOrmcO2ipgoSBnbAFViIQpXoOKrpGKNkpRRDnpDERsf8x2?=
 =?us-ascii?Q?FqMbvow7M965U45/FuEDEBD3j/9zHQgK00wELQgwXctv2U5rbYvTC1uF6JNK?=
 =?us-ascii?Q?qF4WsDz/fC7apbvvY1mKlpSyKb8PTPDaUl9VQHaeCX1+CDitfe3i6rHrneon?=
 =?us-ascii?Q?1AUHRaptQp22CE8Qhr8RJHrAxYH++t4fPVzHtlfr3OqOVE238Jve2zkvUwrg?=
 =?us-ascii?Q?IgeVJym/hOrXfp7Zng5LBsOJcawVxNfHayVCw0t2VeQ/M+nmuU8x3dJlkGSO?=
 =?us-ascii?Q?SUvEnJK71PT6YKAGmv7clNvK8d3g9nr8t8uNUKrsVA16Ud0ufgtS0S1iyBni?=
 =?us-ascii?Q?jM8ZUcaO79KEV17uRaSn2butKqgw4r6wWnsajSZCqTTiNXeOW32jRhHncHIu?=
 =?us-ascii?Q?Wlj+1cXaxJHRAaNQMtbRHP6qSKPssj3AV0BRg/2achKxiWJimRKpiIj417ZX?=
 =?us-ascii?Q?Zz81xlP/b0lX4PU/hthYrTBZx1qlsl/Aj4bNJu+O0KmDrfXNlFbBT3jabfN5?=
 =?us-ascii?Q?VvnuH2sqTL3B6VIidsRflcwhG1/IA3skRdR2Mt/q4F7Q64BFqHvIDLbND5dH?=
 =?us-ascii?Q?BMoI9h9pQx05Q7qyvGvlY7r24FzoSfEf/NthCkK8bMMeD5eJAQM+0W3isJgi?=
 =?us-ascii?Q?kB3kUKF4eCPGL+Xz/QaVxE8hOYU8k513Ousvvi8MKGIOWwEGTVwgYT1op+yu?=
 =?us-ascii?Q?2SUpZu/oTJdfjDI/nSPnevN/juYI9nx6dFRZd4ecEJbm9xxK2qtL0306Ec+T?=
 =?us-ascii?Q?2S3CqTZkPA6uIpfQZAZzzImn1kD/wsgPrYl6/1KqvQwQZtAW7BxjE3/jcCRm?=
 =?us-ascii?Q?+2snMpySX1aXKkTDIiMqK18cParL8qbumLNjavYUB4+WwuJk20vhVB72t6ev?=
 =?us-ascii?Q?0/DBooEXlNw3G+MxLGOKXhwuCmcooj9J70QjBmnRDD2xm4wM4yRD9fi8xRbo?=
 =?us-ascii?Q?9woYDxLGf9LpBmH4tTl/zawyeX20GFSOwgZB1YXj2qBKV6O4bJZ9vHZhyLn+?=
 =?us-ascii?Q?vF6VZhYzZbxmXuHN+wupxo6IDqOg3ObLI0FkX7Tny1qPeieHG7A5USzabEJh?=
 =?us-ascii?Q?dgJ3+OGh2VmKIXg7SDEQIz0k6sAJrN1ZEYvuwCBxPkv+b6mt6xsCEpyH40Av?=
 =?us-ascii?Q?q66i0vYoiQcnOxKzDdqWnxjt+6VWd1ZXnBkPwDKSFhchzrQqcchubO05MbsB?=
 =?us-ascii?Q?IEfN90bgh0nAvN8vut2M9efinOVtcJyxESqveGez4yR2ONrRYwUh8UdOkZnW?=
 =?us-ascii?Q?niuMr76odsKWyRNrZ+Gzh83D/VhemLv60VANVEycsYUF3uMsqe6kyb+0lyoj?=
 =?us-ascii?Q?r2KyZ9AP81MPRE0Ox0UOX9lTWLJytUs=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f60a3ea-3904-4422-02b9-08df409274bf
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 07:56:27.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYztt1R8P1NGNa3SSp9fg5j3ptTO2I62lYwgqTfnz0FL0G4qzVIJKz7iL2i+j4WNcJ4zXT/6u0u6OX5UiL+bFpa7dg1cSYXR/hBcVXMAZ0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0999

The PHY register read/write helpers in the AMD Versal2 driver are
generic to the Synopsys DesignWare UFS M-PHY. Move them to ufshcd-dwc.c
and rename them so that other DWC based glue drivers can reuse them.
Add kernel-doc for the exported helpers. No functional change.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 77 +++++++-----------------------
 drivers/ufs/host/ufshcd-dwc.c      | 61 +++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  2 +
 3 files changed, 80 insertions(+), 60 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 18a5504279e6..c969c5e6cb76 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -43,49 +43,6 @@ struct ufs_versal2_host {
 	u8 ctlecompval1;
 };
 
-static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
-{
-	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRLSB), (u8)val, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRMSB), (u8)(val >> 8), DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
-}
-
-static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
-{
-	u32 mib_val;
-	int ret;
-	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
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
@@ -154,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
 	u32 reg;
 
 	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
 	if (ret)
 		return ret;
 
 	/* Program ATT and CTLE compensation values */
 	if (host->attcompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->attcompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
 		if (ret)
 			return ret;
 	}
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
+	return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
 }
 
 static int ufs_versal2_phy_init(struct ufs_hba *hba)
@@ -376,7 +333,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 
 	for (lane = 0; lane < activelanes; lane++) {
 		time_left = TIMEOUT_MICROSEC;
-		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 		if (ret)
 			return ret;
 
@@ -386,12 +343,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 		else
 			reg &= ~MPHY_RX_OVRD_VAL;
 
-		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 		if (ret)
 			return ret;
 
 		do {
-			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
 			if (ret)
 				return ret;
 
@@ -453,12 +410,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
 		/* Remove rx_req override */
 		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
-			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 			if (ret)
 				return ret;
 
 			reg &= ~MPHY_RX_OVRD_EN;
-			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+			ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..fa6ef641e4c1 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -15,6 +15,67 @@
 #include "ufshcd-dwc.h"
 #include "ufshci-dwc.h"
 
+/**
+ * ufshcd_dwc_phy_reg_write() - write a DWC M-PHY register through the CR port
+ * @hba: per adapter instance
+ * @addr: 32-bit PHY register address, only the low 16 bits are used
+ * @val: 32-bit value to write, only the low 16 bits are used
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB), (u8)val, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB), (u8)(val >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
+
+/**
+ * ufshcd_dwc_phy_reg_read() - read a DWC M-PHY register through the CR port
+ * @hba: per adapter instance
+ * @addr: 32-bit PHY register address, only the low 16 bits are used
+ * @val: 32-bit read return value pointer
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	u32 mib_val;
+	int ret;
+	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
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
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_read);
+
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n)
 {
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index c618bb914904..076076903730 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -68,4 +68,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
 #endif /* End of Header */
-- 
2.17.1

