Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011033.outbound.protection.outlook.com [52.101.65.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351514BA1D2;
	Fri, 25 Sep 2026 14:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347030; cv=fail; b=iBc9p1gmuwsbE7wfKliYxMkVqb8bYss2+4/JAhrIJz+sSqNjpf5P5vXRErvgOK8HI8s3qlrPyFR1xAv1Y4K3rLVVu0tRh0iXSFLI6AjrSzbL8dAnzql4YuX80+lcKiesjlh4eb4ulu6v+3rnrky6pjfA2hq4U8WT/B+pAju5KmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347030; c=relaxed/simple;
	bh=Gc1TxaOrHN222id8IhR5snYb5IiAsyn5XSCkLEPlpak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kx/ioukrdkZqqE5JGGvmicwhL+sOYxsXyzzynBSBMU/09POe/mbWcnDHg7dC4Aos98DWdWCuew9esM3YiKs/qkuM4SlnSAfv89Ib14jKKZdbcgTFv0ByTtmuwYA6QcH45Sd9XSDUbRhXh+4BK+1pP1b/vGy3V4Qxib1EWcNzlA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=cojlpplN; arc=fail smtp.client-ip=52.101.65.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="cojlpplN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQkblrdfKixkLFBGU/wOAM6y++7T/PyHcti4Q+3dIKNdqvAOwDnJHDSbUCuJ23vmWVCaa2inYEIn12IB08NNGtIDjjRZETX6AvOGfQ7AoFYwgk2/OqDC3P5TVeXj2cCkAi6T38LrwvR6VevAJL5IuvUR0K1M/qiOhcjVi23maXrFEUcPBk0PiKKbC/Z0lXInzgVGgwx/FPjfkVtXCe5yvr59xt+hhV9DRARTK/9aDWTzivWUMw+0fWPONjZ1fvZpcDeYw75GRpjzbG4nnKKq7oVtrCD9yHHN5mbCtMRX8zvvc99E8i0StBP25yCCJ3Ux0PT4Nnc9ux+esqFN5S76ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=BpzavAQjnqgbaBvN5A+HHCejt9NPyDjqS6WQyHhU0+k1yyO7bgqs6yjtdAthzzwNKLDYv5Y4xjMVj4Quz8KXsk3D5zBL4XwW4+Xp3c5+0ELQYkVxL4FrlQ4OjIxMJdjM2PlD/PW0mg0qbgFgio7VGYEMnJ4h5cZo7RF9aPN+GHr+AqDv8DsLTcsiLVky3UpjUhlSScduPpx0Gzff8ikh9vnlqilBKtHJDqgxit9xzZ4zKEVXB1UddA348TLIfgEnuvRQl2DdDrfQffpgElRiMEEGPi9ORFsu7EBbSUBsSGPe+7Q5sKh7uQ0J1d+VbVjaJXgspaFHH7Sa/kpJbDuyYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=cojlpplNFQakN5Xx3hNq8Yn3+kxES9PthhfhYjJxolktrfjpL4K5Wq61N+eH6fuAam+bSJ5rU4f3Dtn02pypQZmqaZwcvilojFD4oN28NKW/+IP1utb7TrJT0uqHX9PFnOcWOI+Ms6/NnTPJIpTerH2CBBIZ6FVPA7nnTAoOO0xHy0mEUNxtCvM0NPGoMhb2mN/kN/CqLvcDenw4TQ12drJpE/Ar1B3OgPi+x7z1GsvcaDUxKJlrQydueFyyP0E3EYbiTIY3xiQNsjwXgMTRGAce0uloz0UPv5hNDKmN3I8D8wM8hUT6C6e2Ai0qJtpCStUYh3ttQaOGezYjZydPJw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7256.eurprd04.prod.outlook.com
 (2603:10a6:10:1a3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:35:50 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:35:50 +0000
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
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>
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
Subject: [PATCH v6 03/12] ufs: unipro: Add TX/RX FSM state attributes
Date: Fri, 25 Sep 2026 16:35:25 +0200
Message-ID: <20260925143534.3298540-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DBAPR04MB7256:EE_
X-MS-Office365-Filtering-Correlation-Id: 439129b3-7917-4090-d47d-08df1b124be9
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|23010399003|7416014|376014|10067099003|56012099006|6133799003|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
 ShufaJAKD8fQBUX+ykfpFivx+Sa2EcgC5y8ZqKP8bLq5LivpMX7YlDdyj9p9geUGjKfrm6ssv/wbb5Knj3ulfiHlL8yk8se3en9zZmVFnWN82CN4iNLzNoxKGQFfoZHn1k0RAH/m9Z48gU9tMHo/odlixmYTTe4UXHt9RrXaABt41NJLOcIGqvXBlcjdfwEGjy3O2G0nzWPrSAVa5ZANKVGD+5gYSu1YaQHjgMhbzqyrMNTykPw27WHvEEi3A7n2NlLStLpzI922LnMtH4lMY1Dw6+c/XqhNKVvSSeqJBpvsMKUKNl8y/F5KeKVLAtbLR7z2YXvzXXUMNGzu2xi4OBRISk0J2AZCEGBHZgmovLYikPmEl+vvUiorZbzg1GxPTJM65uZd+N9J6+1AEO+NKnDl7CugEdF01FSbXIGdMWFQIwG2J1hPhxRRdf5FfvXDHnQ96nHC25PHnFgUHH+h2WQcAI6r+8rcKQB/zPaK509dPaLqDqBFEn5/lItd6yoYA5Cebfy0WpTFLwga6BzoSGmb0Dwt2kpa5yAUZq2sJxlrTUkATwYF8MFsU6fGxD1aXgzxvQMImdmhYAj3mGsj7vf5l+C6lAMMRXzCJEyXI9zQIDe+5R1Vln0K70f+K31LfGj+m7vj05g5PnvjnuFPuWMoVnPvaqr4nOIkR050k2k9XYCctD6EN9ZZWEiz4gKonZDu0vcyvwMBF/+ZzYdzzg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(23010399003)(7416014)(376014)(10067099003)(56012099006)(6133799003)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bk9iZnIvK0ZianhWMGh4WDBTb3cwa3pBUStRNHBIMk4xanRhTFU1Sm5GUjcz?=
 =?utf-8?B?Tm9EYXlCR1pnMFdaR1prcmFjZFNkcjZBek9nUXJxRmpwREFna0RqU25JMmUr?=
 =?utf-8?B?M29lTHJrV2FEY0syU3B2TmRoeVRsbVlPNjBidXZjblJmTGYzbU9jSkdod1lV?=
 =?utf-8?B?ZnRaOWlxeHBIbUQzUWNjMk0wdDhwZ3ZZd1JDZ2xMMU8xNEdUdm5LTmdERFdw?=
 =?utf-8?B?YUd6ZURZeEUzVEhmM0dTL1hWdVlTbVgvQTZaelpsdm0zVmlTOEQwbU9WYnZH?=
 =?utf-8?B?TTNlZDRvVm9rem56YlFvZk1uTTRRQm1IOXM1WnVSNUFZWlJ4OXZZMGNSckRw?=
 =?utf-8?B?Vkk3MTFjZ3FFMkU2UXZzSkM4ODMybzl3UkN6V2xTNnhqUVRROUQzdmsyOEY0?=
 =?utf-8?B?RjYxdnhxNnZxQSt1Slg1QlIxU2hpcWY0eUNob2s2aXViTWxxdjNSTjV0d1pU?=
 =?utf-8?B?K2UrUXNaZnhUQzdIUUhDYWptWE9hZ0xSS1ByY1dvRS9TM3g4eGwza3JFdGJR?=
 =?utf-8?B?NkxkRmdseXRLS20vd2ZrN2xjNkthcG9GNlovRUNweGFMQkZ4TFppNEl2MkNy?=
 =?utf-8?B?a3Z0T0hVbVJtWmpBMU1rTEFvdHNMazRWQnQ0S0xTNVRSZVh6eVNhb2ZOZU0r?=
 =?utf-8?B?VHhudmJLSlJqZlZSdnZiTjRxZnhvQ25yRVBaQVAvZHR5a3ljVzMwRWtlUU9N?=
 =?utf-8?B?d1lnSGF1aXZFZVNPMk0xVVpld01LS0UzN0lZcjZsd08zVjRLaC81VVRYZENZ?=
 =?utf-8?B?bUg0TGxrMTZPWDhzM2tPQnZXMkl4d3JqMVJNTE5WdmRDVmxNTTlCSWo0NnBE?=
 =?utf-8?B?aGFFeXlXWXZSR3FvaWd0eDF0c0Zwc28vbzQ3UDdTSnJoWDZiWnhMMWIwZWJr?=
 =?utf-8?B?bWV3TUd5NC9xS3NFRTIrZ2g3OFF5MGl6WGl4TC9PU1BwNWltVDBKV3ZMc3ZQ?=
 =?utf-8?B?Ykt2ZDB1VmJhaUhxYU52M2xTMTloMEhaZTZ1d3czL3YxSllVMnc2b21RR0hy?=
 =?utf-8?B?WGhjNjZMTGRhWUp1SVFKcjlPTWZURmwrb0pjV1Fwbi9KbkZtcnNlSXJ6Kzdw?=
 =?utf-8?B?a1lwTU5IS2tkQ0F4ekgxeUpuek5ubjRrZ3pWeDQwaEVDZFFHS0tnWkFQTC82?=
 =?utf-8?B?VytYL2JFc1h2NjNMVCtOUTFZNkVFNVZUaXM0Nmd0TnFPamZHUURrWUFVUDJD?=
 =?utf-8?B?dHk2TlI0Qms2YllzWEZVaDVYVE5tOTJEaXdtUmN4SE5LbmZMYUxyRHlvbGhZ?=
 =?utf-8?B?RFdVeUMwVGpZWkpRb1pmVWptTVBMQVJGdU5jNDRSeGUyN0hWTFJYL1QxTVBJ?=
 =?utf-8?B?eGtlbG9CbStTSGVxd1pybFpKS0VVT01lOTYzRERoNXpLUzFFNXhKVXBlejJD?=
 =?utf-8?B?aEFkeFgra0piNnBsYXJpUVNvWkkxK201VmU2d3N4dHdPcDZUdXl4RThuQWJn?=
 =?utf-8?B?SVhNMWpnaUowc2k2VVpnRlhQOHBXMjlmcGd4azhQRFdNaE8rNkMySWM3MVBT?=
 =?utf-8?B?MjJnNERJSnFIVmRLL3RhcDA2RncwZkhMaERBM2U2NXBVUDJTdUtJejB2RHRG?=
 =?utf-8?B?Um42dm5OMkh5VldaUEUwWG03cjJuR1IyNDA2MnNDVzVmQ2VER3hmUnEvRVAr?=
 =?utf-8?B?ZCtMQm1udE54OUVqWnFUd3BkU3kxSXpibkdua2N4aDcvajQyTG8xb2RzYjQ3?=
 =?utf-8?B?OXRrMUhXaGpGbDNQWjJqa2JIRW1qaVJvNEQ1L0R0MEEzcm5RL2UzTU56cHps?=
 =?utf-8?B?VUlTSkNTdGs4M0hPemxMUFYzMVNsUlJYRWdaczFsYTRIa3dDcUhtekMxT0tS?=
 =?utf-8?B?aEdtWWlzekNqeWpvSDRmV3NvOGUreTRUNi91MjlZTWRadEppZW9XdEhJOTRR?=
 =?utf-8?B?NXlUd3NpUThFQ1Vra2RGSzNHMkVKeFFQR3BVeWdxS0lEcmhHeUF0cDZuRjVE?=
 =?utf-8?B?eFdWNVJCTFFXQU85MlNRcjBRN0gzWnhZczlGK2plQmRqR0h6THViN3MyMXBB?=
 =?utf-8?B?bFVrSlRnaWQ5MnNGKy9EQTdhQzhSeUV0QXJvOFBHR3A4aGVONmVNT1lrMllX?=
 =?utf-8?B?ajlYbEh1OGdaZVlqR0Z1SGFwMTEwU2FRMXNMUDdJVnIzNEYyaTdWb2Q1SDJC?=
 =?utf-8?B?QXhMSkJySCtmbXpmZGtqVmkvVnBSUGhkZG1RQnBiUzlkdDBSeTJJS1ZlaEpM?=
 =?utf-8?B?azVodTZ3NG83YVhUcTdkTHp3Z2F0ZWJaYS95MzJkS2NrQUg3T3NWeVROaWEv?=
 =?utf-8?B?UjNnckh4ZVdPVnRVTDBFZUtPWDVaTXJDWGxBWHRMWVNON1llQjRWMnBsVDBO?=
 =?utf-8?B?MTFPRTlQNURnQy9UMFFHYkZERzR4eVQ4TzVVbTA3dkxLdG50VGx0UT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439129b3-7917-4090-d47d-08df1b124be9
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:35:50.7578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TB0szof7plI8INJFvMCyoOtsSgWkow4I4C0VLHFhbZhQFLaWcJM5HB3RqSYHHhClkiJC9z8cDQROmq3SF3Quww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7256

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

