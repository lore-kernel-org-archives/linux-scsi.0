Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A353A5433;
	Tue, 22 Sep 2026 07:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062417; cv=fail; b=sWNV7NIUeTMLYAX/1nwkKEzTEwXPKyonZaUk2tLuWVOdoheMtjfuJhBm1OcIQUSadLhl6cvMM3gAKSCczc3te0kxrNvrwcA2vDcU288bB8SGx2kYavrtYT3F2lX0rpRe51J5od+MK+1GJP/kyDpHLyn3arxC2yAj0hDtF7ZARyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062417; c=relaxed/simple;
	bh=Gc1TxaOrHN222id8IhR5snYb5IiAsyn5XSCkLEPlpak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=igCwCNrJmh0/Jbk27vHdumisqmDAYxdNJpKMakVEg7h5L3JLrRJiKvkmnB3GYS9oUEB2yfK1UF9zQrn1eSXyZMdDLuq7gpFcijjXOJRpYm7z5pNvu7AldqYp0bNQO+o12+PKLGQeXbPDPcyGdOgINgu2aDeQYx2qE3+IxJ8FY+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Dgrtbft9; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Dgrtbft9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUqWui2sUj4KLegw+dYW/NSvkfNvKgz4gi8kJoDSAj1vsDCZmzG9Z6PfsQyl7bTReZqA3B29+qkPU1iMoMUb463JZk7cgCO78sqfy2186DKUBpYVdpiCCVnbh4J5jXbfJ01qwLdSKz35g/07GJUZgFhWSCK9rEUfq+i4whgbDZBVdatRgglQx7zCm6ICV+fDZy1H8raSovHkcQIwC7HF5t/USzKe3X812CMrL3l35czyV+0+U0nZdELY/rKc/CSyPwVUfDZHDKdFBJO66tEAmMsZfuWAyaiNcsTAIJKxUyU0rddYtMJd5pdkc4Fj6hJfcUlywYQZftgwzTLjW/RjSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=I1k7IjuIGO321cpiqGzfcgbclvGUwB7XZpaCgkgMC3XgVvNQj9SagZRwMF/KtggaGJJ46gUkI29Oh19SFthsZQhbD6HCrxI7IVpMuHWCV3MBpJ4Hh2WA+Wye+EwrrTaLL5MUEl4M3E3U8v9q+HCSM1xBjGlpf1mgasWJDq+kdENf/hPDXbZdCTH2uqoIW9Xl6JC1P2RqGKmbNe+vTp7CSALSLdnFiZHtDltXwpd3FjF/BAU9rcee48b0wgiC5kwz0JG/JkZ2TYYdQyraiVd9YASkiQtyKApGjkjSyJ1TlQryrUMxB+BVG6xzO4AMhDCRLgFnez9JKRKoHQQDthYxEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=Dgrtbft9fhBglFsizcZ0fHf8+fPTYZeM1mqgayR49QWkxdN5Jv9SELj1FuUAVGjgx6GCln+1nxfi03OOnAlBDMpk5HfjMKgal0xs+K083/CcNJWjjj5dnrU4Kj4QIUaBTBX4dSwWnC7I7WzI0DwqmY5jxFFMMoJb0QWpKhRaCv02jpT1QNyyW7Ohq1ZOBDoHDftkU9zA+DbGj4F05ewDjvZJJGvGJAdNOQFjCtKtJZ5vN0LaOLpJmz7wRitwzJnzVUgeLXDawc7uwBfx8NlCYvDYSUzdu7lqemi/kcAYRIwzXe3opVvemq14TDi5L8wdTX0rn8NPUdqwhNQm0vX2Ow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:19 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:19 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v5 03/12] ufs: unipro: Add TX/RX FSM state attributes
Date: Tue, 22 Sep 2026 09:30:00 +0200
Message-ID: <20260922073009.1449688-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0001.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::11) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|MMZPR04MB213195:EE_
X-MS-Office365-Filtering-Correlation-Id: cb4d34ed-27d6-482c-a118-08df187bc5e8
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 woBCBcztCGAh5xvU8vuIh08aBRWv43Da3t/iDQ4m3P1t0048ZHnt4dlOZmG05vteCAqfbOf2rSZzcuac6vnQRs66DrptGNSji02/u8f0UQXnOnEdrusv3set29Zf9UDotQloxIqd7A+ZcroIJWGzVadF5GjTWglKYpD8Kta4XlpZY4vWEXuQdU+kxh6lufnRLZpOC24zipc/MNaHdfAwWikzmEZVp7xyR292l8dhjyLQGh9RG0DXGkvRUL3ixqefUi2yk1fHwpHK3O0bi6jk2o5Duv0kRxeORA3HEz+xrlfoYHdw/JOKUnMMyJcal1iB/pfeihyhsaR96MOZ8T8pSxh+iqt6DCCWqO4PRqFg5R7rOHFZmAvMd6y6p6F5rOr4yfEGlDaN+Skp9yA6k9V5ih1Xx8uBBy+cbrn9u1RstRCAAjQgqx/Vnns8CRcP3rFGeHuoIWkkUK92WSmkvmoxqPHsmZ9JD6bd9JqwLFGHJv/Y5fuv7GmHWBXl3zuwFLwCWO5ZgqHJKPN15qe0PQwDx33SBerNTuFCNUYQARugIXoU0ODrcRB6Slx+H0uwGnCHDAuzgs9B4RgpijTdS/ny9PF3a1RDolHWFCfjlNyuElOH8WIWJvdT4wEOlOKTBMcPWGBGzcelnbXKnfmxBKUQp8Nv71rfbzzJ/o5uS2wg9d3sg1WTw/i9y2T5oQbRaHq86G2nSHddLpKlx/Zlub9kPw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZUNmbHoyRis2d1JkUkFmWEVyTWtrV1A2ZDFBSEZxY3NLYXQrNyswYW5sNnFN?=
 =?utf-8?B?Z0NhcXY2bENpOTRQOW9pbFhpblFXblczT09jYnBNVXpxb3F4bUhEdzV2czhP?=
 =?utf-8?B?WDdWbVJEaVAwb3RxQXBNaW8xQXlaMjhwSnRUSTBCQXhHdWhoUUdNKzFjbFo3?=
 =?utf-8?B?SDNHUVhoYWtlSGNnd3dYQnFNVFVaSm9PZnh1d2Z3eWJBRlJBMXZsMDFiajRp?=
 =?utf-8?B?R0JqNTFvWktNeE9RYmgxVjI0NkJZd2Nvano0M3A1M29oNEg1WXE2cklaV21J?=
 =?utf-8?B?MFB0MUpHd1NBTHdhSFdQNUNHb1FYZGhRN0lVdHVGREM2RW1LZmZGdnE3UnA1?=
 =?utf-8?B?TGEzL1YrMjFKR2J6NHF4VkN6UFR6eXlnZzl5MkJBVnhMVXNRS3hjc296VHVV?=
 =?utf-8?B?U3pUWFQvc25hSHM1OUY1VWRIcTBDSFJab2hoTkFjVFdqV0hQRzlWdWFTNzBM?=
 =?utf-8?B?Y1JUdlRNTkJDQUdOclRrL0tDWmptWkI2ek9xOWVFRFNHVmpGYXNGVVpyaWF5?=
 =?utf-8?B?S0t1UnNHeXNlUVB1OVVLa0cwYnNJZGdEZng5ZGtoRVdYWS9VNWxCVUJhdjd3?=
 =?utf-8?B?cEVPWCt3b2h1bkxKUUhIeHNIU1JLZG1vY3dUQ1NYSy9oSHIzT2FEd1doNGpu?=
 =?utf-8?B?bC9wK3pWSmo4VUJ2c1FZYUt5TEQzeW42ZFVYYW50OEtxVk9EWnlVcUxCMnZT?=
 =?utf-8?B?RDdIZ2dFZVFJa25acXlKdGN3Ny9ZRTZXMUtPTDQxNEp2Z0RSZC9rLytVbWpH?=
 =?utf-8?B?SGRwd1I0Z1dWMVN6VkZiL04zUmRrMzVhSnB3U1VvZ3BFZkVveXdEYldka2F1?=
 =?utf-8?B?c1F6ckU5MCtuamhuYnNna0VPRXZsVXpubmJuaFBVc3JuWXZ1RHh6TWc1WEI1?=
 =?utf-8?B?Rit1bHNSVDg0TXlYaXRJZzVSZXFaODlXWG9BbnVPY3JEdHZPOGVseURGUGow?=
 =?utf-8?B?M0xIVTRDWC8wYmxpRGZFSUROcHhYNllnNFVnem1KNGwveEFVVGJLcDVOQ2t0?=
 =?utf-8?B?OG1NKzNUVlJMY3lYbm1VSlMra3JRNXhPdzNxRHgwNXN1OTJLcmFCWFJ5VVI1?=
 =?utf-8?B?ZlBoUkN2QmZuL2Zkc0pMd1U4c0dXeVZ0eTdIUDJGTTFlTGJYbStlZUZNQ01j?=
 =?utf-8?B?b0dVMzlsV0dUSDBJcTVNLzM5bTRPVjBRTU9JOVAyRHo5SXN5RUk2TmZhZytT?=
 =?utf-8?B?bVpCb29WdEVuUU9VWHNqd1UrMHczazI4azhuZ3gxUGFWcnVHNWlrU3MzK2Q1?=
 =?utf-8?B?RzJiYVhQeXVsZ3BlajRPRUFaeElWWk9EZXFYNTZTYjVQQm01M045b0I1TFV6?=
 =?utf-8?B?QVJ1OTF0UHJqSDg4eG5WOVd4cDZzYUlrNVBoeWlxY2pRMDhlcGhMaHJ0eGNm?=
 =?utf-8?B?WFlWaWZPVjFtbDQ2YXpVV21BWEVZMHVydVBjeDhNa0I1VkdMTHUyNi9NWUNu?=
 =?utf-8?B?OVEyMG8vWmxNQmFpc2E1QlIyVVlkUHgxNTFDTENlTFFGSXRXbllZNFpjTTRS?=
 =?utf-8?B?YVo5NUdRZjVrMXZnc0Q5K01OaGU1RXJPdlZFc29TOUhlRlNNWDZwVVR3dTdG?=
 =?utf-8?B?alE5QTVvNFdVTXMvcjZURitITXhzWUo4WkRwcVVFbW5FcTlWSVBidXh0Yng4?=
 =?utf-8?B?cnZyQmZwQ09GRERVTW1zZVdPOFk4UlY3VVNOR2hEdVNVcXZPeUY2UnlLeDgx?=
 =?utf-8?B?ME9IdUVHK0RsNDAyV01sdVhxUmVZTkpadU5WSjh1MmVOb3E5a1Y0eEc3RFFC?=
 =?utf-8?B?T3F5MlZwa1d2aE9zVTdEa3g0ekp5U2hDTlNmN2tkdXNBb1BlWE50Z3oyZWdZ?=
 =?utf-8?B?WE43RDFWRHY3N0tHZHRSTzhXVFVxMUFoeis4S2dIL0s3ZjB2Y3ZQL2NxWGlZ?=
 =?utf-8?B?S2ozUVlMeTNRQXViZlZ5UWxzbXhTRmMxSCtJVC9senJkVGxNUHJNN1hyL2dq?=
 =?utf-8?B?dzdzVVZtR0hIemlKd21uMkM3UGxpWEw4eVFibGcwWlVOR2lEelk2NzZjckNk?=
 =?utf-8?B?bDB5WjV0cTRPbnIrcEJ6Z2R4Z1Z0b1ZON0ZNd0wyekhKS0ViOHQveDhwS3Jn?=
 =?utf-8?B?QzhObGtVYlA4UE1MSDlSQ1RxS1YyWUdzVEg2QW1mZ21xQzR6clVsdE5RL0pB?=
 =?utf-8?B?WUd3TDZzT0gwZGFBZ0F5eG56S2NicmtoYjRsVElyNDEweE9XUUI5OENxUTlS?=
 =?utf-8?B?YXdsRkJpYnZKMmNCa0t4SVV6UGI2RXNTSWZMMG5oWXAxMENoaStSNkVaOERM?=
 =?utf-8?B?OVIwU1JMUXdDYWI0SUJsc1JoYjRYeVBoKzR3WDhSSGZXQklON2ZNK1QreHdk?=
 =?utf-8?B?cVFJQjBmZUIvd2l2N3YyKzU0bXpKSjAyRXhMMkF5MWttM2hUM1RrZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4d34ed-27d6-482c-a118-08df187bc5e8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:19.1075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmjJGdoYQufBZnPQG/6tv3eJkDXU1yH0fQRpbCVVPJ0DicdzG9ijYd29S9HubmS+Pm4DPg8lO8CkC1zWOEWhcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

Add TX_FSM_STATE and RX_FSM_STATE to include/ufs/unipro.h, as these are
UniPro M-PHY attribute definitions rather than host controller specific
ones.

Remove the duplicated local definitions from the HiSilicon, Qualcomm, AMD
Versal and DesignWare UFS headers.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 4 ++--
 drivers/ufs/host/ufs-hisi.c        | 8 ++++----
 drivers/ufs/host/ufs-hisi.h        | 5 -----
 drivers/ufs/host/ufs-qcom.c        | 4 ++--
 drivers/ufs/host/ufs-qcom.h        | 1 -
 drivers/ufs/host/ufshcd-dwc.h      | 4 ----
 include/ufs/unipro.h               | 2 ++
 7 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 2154d6286817..0d4d5e98ad65 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -112,7 +112,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		u32 time_left, mibsel;
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MTX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(TX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
@@ -132,7 +132,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		}
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MRX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(RX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 2d214ce9620e..bd223bda1ce2 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -30,10 +30,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
 
 	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
 			tx_fsm_val_1 == TX_STATE_HIBERN8))
 			break;
@@ -47,10 +47,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	 * check the state again.
 	 */
 	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				     &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 	}
 
 	if (err) {
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 6af6a268458d..08dccfbec404 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -39,11 +39,6 @@
 #define MASK_UFS_DEVICE_RESET		(0x1 << 16)
 #define BIT_UFS_DEVICE_RESET		(0x1)
 
-/*
- * M-TX Configuration Attributes for Hixxxx
- */
-#define MPHY_TX_FSM_STATE	0x41
-
 /*
  * Hixxxx UFS HC specific Registers
  */
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 38897d01fde2..1e492dac8d93 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -390,7 +390,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 
 	do {
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 		if (err || tx_fsm_val == TX_STATE_HIBERN8)
@@ -406,7 +406,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	 */
 	if (time_after(jiffies, timeout))
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 3c6cb2281af0..1ec661277c1d 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -10,7 +10,6 @@
 #include <soc/qcom/ice.h>
 #include <ufs/ufshcd.h>
 
-#define MPHY_TX_FSM_STATE       0x41
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index a5e40e7604a1..0406f2bb576b 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -27,10 +27,6 @@
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-/* M-PHY Attributes */
-#define MTX_FSM_STATE		0x41
-#define MRX_FSM_STATE		0xC1
-
 /* M-PHY registers */
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index e0f490e11c7f..6fee545bdee5 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -34,6 +34,7 @@
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
 #define TX_HS_DEEMPHASIS_SETTING		0x0037
 #define TX_HS_PRESHOOT_SETTING			0x003B
+#define TX_FSM_STATE				0x0041
 #define TX_REFCLKFREQ				0x00EB
 #define TX_CFGCLKFREQVAL			0x00EC
 #define	CFGEXTRATTR				0x00F0
@@ -72,6 +73,7 @@
 #define CFGRXCDR8				0x00BA
 #define CFGRXOVR8				0x00BD
 #define CFGRXOVR6				0x00BF
+#define RX_FSM_STATE				0x00C1
 #define RX_FOM					0x00C2
 #define RXDIRECTCTRL2				0x00C7
 #define CFGRXOVR4				0x00E9
-- 
2.43.0

