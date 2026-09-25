Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013065.outbound.protection.outlook.com [40.107.159.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737414B048B;
	Fri, 25 Sep 2026 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346989; cv=fail; b=e/5V90xujtcc5iQaxi5G1KPU19HQqRlSHOeIPJYu+2VgSAwrzNAzW5FoWTqMjijR7U2KFyTdqOxC0bVMJl8fGlN/zR2pL45uk12aoA+GggCAZzHWSnU3QpgClBfTvWddE5O95CA8YrbcKhU6EvYFnfVqk41cpAgs6+wS1iJ3+X8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346989; c=relaxed/simple;
	bh=m6szGpBKsXIUl1/uJVhVROiVGi6vyEU658NnP6M97sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QMGLaIdk4jQwAs6hJYuYVaXK57XPFUmAnnPv0GBhfzkGX/8LbmBs4vkgBfvVtH1yv2KW0qtSYyedPNNK6/8qyZPEO5hYVIZldUVEt9uv1VT66hVd9tYBt6gnTyvqF+wtar6RCNYTKMpd5+Zvkum5usy9Kq7CPdSkuFFvqqQ+xs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=BrWoGnUY; arc=fail smtp.client-ip=40.107.159.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="BrWoGnUY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OIXKmzmVSZRynO8+Gy7KNUIcc/pW9GSTe7uVsfp7CpjlPQ4N8m0hNMOX1/gZPniH7eeUAhOLJvO4ITd1BLMuhM/881ebqvhJPIXAhACLIT/UJipOVdbX8jm/wLk0Vo7Xn2VpqCeaaHrEK0roq170yeREgrG7RXijz/thXW1LAgVCxoAwFbVLUGxziEUqdIJEQzwPOuEu3TYmTw5hZfrqfISHTt6XakLMdmpS/EhRG0V0oWSbNBR7nn80KMbbYPvrKBPG7ovqXeX7tDmAlJ3mlXyURZIOtz9YxyOP2DRwwJHIhNZlm55YVcecm5Z/V2griPoOEmdCwNF85GBn3/y93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5VCOxmrakOZvoozZLzX4mZ50JYYQpMdb1k6aGo+n70=;
 b=EK0qI9pbJj8KEkR68zTgbjJQ1PNuMpsq43YJNjVwpbMA6+hsfzp57tMAsAeiy6127xN8oQibfxK5j4hX14KPhjCCtoyBnhRIENzcmQfaEyBZTrzVXfYC1Yj9fcWBXidxgfTEYXfjDcwow5DmQ1LPjQdbhKfeSwEhVP/38zGy1ewFizyBnDrs/1bN2ryxRiHWGce4hiPqwaOZuz0neUWAZPjoQCV5XmLMwdJjBdZ4N11TuwkYZgj/KNIH/aXMJ5iZy5m0mkvqKjReJP55kDst0pCRWEy8tdySfXpxo7tkpWLllfwuiP+2OFh1GEyesY2cZ41GXnfeAxssgc+KReykIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5VCOxmrakOZvoozZLzX4mZ50JYYQpMdb1k6aGo+n70=;
 b=BrWoGnUYQrFyVWQR54vrDYhpyKMWGNsW6+J+b+ACr7d3BMsnKK8N9JUxzWpNIXQ608G8uZGadKmXeEtOWM125hpdiKPaBz1PUcaChzdW4DQzzRYRaxs4cLjBN4IWtKfk5JDT2LRH2gIKwV9Gn6t1rcbElqi8n2gBiH1LbLkgwH5kq5UC1a4r7dAnWt7X5XQIdVvMU8pIDWwaZCxN+D7eHJwYHrUDBVMvmxpnOxawG8jQiO8OCvZMCINdULvIXvMYltJOH918AQpLVkOFLFZhGaArrBqYheL4xXQ2MuHRndTGhaDMXnonbNg9LrmpnNnCLBVxB7jmM71VvjZBHmd0QA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by BR2PR04MB800621.eurprd04.prod.outlook.com
 (2603:10a6:2c8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:35:53 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:35:52 +0000
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
Subject: [PATCH v6 04/12] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Fri, 25 Sep 2026 16:35:26 +0200
Message-ID: <20260925143534.3298540-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|BR2PR04MB800621:EE_
X-MS-Office365-Filtering-Correlation-Id: fce90b9c-8b58-45e7-b2f2-08df1b124d13
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|19092799006|10067099003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 IaLiSo2mvjg8PzIEUhWtm5DhCWW2k3FabZaS4skK7Xmwc63mAggMF8rOsUmqAFn1mY4BkTjtvZXKwqRpAxpDdmczLQsWppCyDYov6bsDmBtMZgQ/0aOdUxrNaAVnbUg33FfwS32L62h5BKmwWsoGZuSX7n4vP2XdkvxZT/K0s51ePG8mAjJvTLk5lUNylNXkU9Jc+t277PIWzh/kJ7MsU8PYgfHZk/fg5qdOxNMPMKX6VlpPV/MoW6E4+l5O450VXjscuEVtD3taVvubIe9GyoDXNCXUENEFjWoIHx2DHiF7/0HZ5z5051aROGWHCB/zHL8rY4BB6E2T1enDMltx6FGrPzL+Wwt0jk6esXQZM/nSCXWWD2bKKiG87x77gFxNi4BtyS6AqGPpS1gWbRSNHoEJX+056+PAXrQt3Gqz9dPhL3X8gflU3GFhcNzj5hLz7Q5+7x8ep/8PriW2Y+4oAq3tQQyeGdoKXSZe6enqK3SJYRAYvl7HPPuSezfngQuKVLVdgocGBQTkS5ctnwTOCOvwl9R1PQNpOO9bWqUN2tKsghCwkuTdk6f5rzkox1JLDklJ7tJ9wa8TmWsoyT/uIuhk0klmNnK+a/WxfW1f7Pt2fzZ2bTu4UyFvQZzUNyC8MbKlCwqlP4uncRjt21yeRdGrte6ke6AiiROpEbtTBn+nWClwDgczFfkRwnI92sDzVdnMUtEromdkIqLHsARy3w==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(19092799006)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?clM4YzI4bGZIZWRJSVFGR204aUpFM0MzMGtYdDRFclU1Uy9QNUVQSFFkay9h?=
 =?utf-8?B?THlyVjZONWh0YUNXN1hlZkkwbDBoSVlGNEwrU01NeGtpcDVLRUN5ZWxLZG85?=
 =?utf-8?B?MXFWdkozMmg2OTBHVjFXTVJsbUg0ZE5EaFJuSS9uWFk4UzhCZDZvYzdBdVBE?=
 =?utf-8?B?d2JkNFRkVkNEdWZEQTNwUGVkNGx1S3BsVU9TSUNQTHFyQnpVbmdoSnlwUkZ4?=
 =?utf-8?B?N1R4akM1WVZDbk5GbUJRazJMWmN6bnVodTkrMkpGNklQUFNYY1JocmZwUDBy?=
 =?utf-8?B?b04xSS9CMk1hMWNPZHlaN3ZKa2YyKzc4QmFQaGMxRHhsN3hkZ2pIaUVnY3Rh?=
 =?utf-8?B?RWQ5TVN3RkF0ZlEycm10QUFmSWcyVFRUR2k5eFR6cFc5UEFkNTFEMFVxTExT?=
 =?utf-8?B?bzZ2SGhwMXhXN0tnZmhVZkdyT2MvWGVmcUFDalVRVUY3OVVKdDR3Q2hSVUQy?=
 =?utf-8?B?aHpqVzdVRzlScGhrc0JkR0FPVW9OUStqVWhkVmFsdVUyTDBVVko4ekxEdXZY?=
 =?utf-8?B?MXgwS0ZnSDBDZ3NUVVU1ZEhkMjRDVFBsV1pkZ0RGMWszcFBUbGI2cFViSTFS?=
 =?utf-8?B?UnJxbGppcmJ1K3pzcXZXRVhZUlcxcjEwa3hMd2x2eWY3R3BQZmhvMlhNRFdX?=
 =?utf-8?B?N3RFR01DZWdYNDM4TmxWQkRGMmp6Z1hiU3p3TURnTkx2MFZET3pxSG1oSVpG?=
 =?utf-8?B?K0lvellObjJ5ZFZJZDYrVlM4aSt5M1dyUi9ta1VOcENpeGdKSEFrTm5Qc3I1?=
 =?utf-8?B?YXRVU2Rsa1BUSnE0cnZ0Yml1d0VZVmwxa3A2TWVHbDdVQVBEdzNmdFlycFZt?=
 =?utf-8?B?MTdGTHRIZGs1RzVyaDNiSUJmWTFaZHoxSk9Hb2Q5Rlk4NGJmemw4bW1xSEpE?=
 =?utf-8?B?SGxXOG9DNVpQem13TzRvdm96M3ltWHhkdnE5eWE2MmF6MDc3TDNMbmI1M1Br?=
 =?utf-8?B?UDdBZW5mT1JhNUZIdWxRVVJxa3BVVVhFNlNZaE8xczBleXVNbmpJdGZBd3hP?=
 =?utf-8?B?RndXSS9hQ2NrcVlpc3BMRkZkb1RUbGJ6Y2k3bzVQeVNrbEdEQTNWTmVnRVg1?=
 =?utf-8?B?SVpYQldoU2tFR0hWMFhTZ2hTeVRsUDExcGMvTmFuUHpLWW5QL1pnL0RlN1Q0?=
 =?utf-8?B?OXBOOHUyOGMzcVIxTzY3azZ6THZSNTZsMGtqZmJHMGtiVmF3VFpKNnV4cWVx?=
 =?utf-8?B?Y0M2aGNYOVhZM05LK25ZYjNSTkpQekZ4MCtycWFwT3pZbFdLTVFvNVpOYXpw?=
 =?utf-8?B?ZFFGN0d5WHpqOEE3R1BVRnB3UC9PN0ZYUlhKWjFBOHBkL3ltaDFKRVc1dnp1?=
 =?utf-8?B?T1ZoRGt1WHVTZFE5T1ZIMU5hU2hrWm13VVh6cVVHZm1KTnhoZXZuSCtFdk84?=
 =?utf-8?B?OWxpTzZtZ1dvTndYTmlqZXhOMkgxN2JWOFp3dU1pNlRLWFRYdCtxWGpwQlVs?=
 =?utf-8?B?WWViQzNXVnlkZDRDTEovaWpyYWxtemgyVFhtY0hUUGl3eVpoVW5sbnpWZGRB?=
 =?utf-8?B?Qmg0TS9GckNvUnh0MDJNM1NpUW5DZ3lLUFhsOGNKTjVKNjBnYTc0aE02RDdC?=
 =?utf-8?B?N21LTGFKb25jOEF4SkQ0cHZZYkp5MXBMOXd0d1pROVBEcko3VUFLeml4TzhH?=
 =?utf-8?B?MTNNREFKN2lOOHNVZkRvZWpMaVhBaGM2NTAwN2RObmN0djhibHFab3JiaDNO?=
 =?utf-8?B?OW1HVDBKMTJkY2pSOERLc3Jybk51TGFNOTliUW55a1dCQkZ4ZmZkbWQxQVo4?=
 =?utf-8?B?MnVwSitpTjdxSkgrbDJCYmlaUXBpNVcwTE5DWTRwU2ZiZkFYMS8rZVdMWk9X?=
 =?utf-8?B?YUU5aUx4RUMwRzJZU0FDR2tzVWhpOHdXL1lWejFGSk1kUFZpVCtjVHJXMmFh?=
 =?utf-8?B?WUo2V3J3ajNYZ3RoY3Era2pIV2FOd0ErbW8rVjhoY204L1pqZVJZdDlsWlRh?=
 =?utf-8?B?cGNrZjFiNlBFOGhDRElPblBGeXNCeHdmbUNhVWdrcWZ2S1lZOWwrdkYwaU5a?=
 =?utf-8?B?aFdESTdJblFobmZmUS9PSUx4SkpmcWY1cXVKcDBmRzJpb3NKUzZ2YTROR2tS?=
 =?utf-8?B?VlVrM0NzSUZ2L1hFU2VMQ1FYUkdHZFc5NXFtQmRBN3FWODh0dHlvZjNUMGJh?=
 =?utf-8?B?cFVweHFqdTkrdzEvRTBMM0dpV2M0ODZSQlg3aGZUTFJyQThPakRUWkZLeUJI?=
 =?utf-8?B?VTlObkN1bGJZUEZaQ0xOdDhocG9yWjhMRERKK3YweXplZnc0OHJMa3VuSzk5?=
 =?utf-8?B?Q0hYcmF1U2JpalJHSjNDWkhYaFBWWk5FeVJobUt5NFA2OHAxSUZJM3dSNnN3?=
 =?utf-8?B?bUtENUwrYUhScWtyMmM5MCtJOHFwSVM1ZDgva1NpVzZnd3dDVHhhQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce90b9c-8b58-45e7-b2f2-08df1b124d13
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:35:52.7369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnJbXV5HAPrP/RMtbRr4TBFJ9Ks6DYRj5vzMUc6LXyr+0z19/nS4AxhIjxGT0VS2iRoEfN2lTbLKtOBrWyxUVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR2PR04MB800621

Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
enter Hibern8 into ufshcd_check_hibern8().

The HiSilicon and Qualcomm drivers currently implement similar checks
using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
this logic to a common helper in ufshcd so it can be shared across host
controller drivers.

Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
their local implementations. While at it, normalize the "TX lane failed to
reach Hibern8" error path to return -ETIMEDOUT instead of the raw
TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
This is an intentional, harmless change of the returned error value; the
pass/fail behaviour at the call sites is unchanged.

Unlike the initial implementation, the timeout error is now reported only
once by ufshcd_dme_check_tx_hibern8() after its final check, instead of
per lane.

This also prepares for reusing the same UniPro-specific Hibern8 check in
a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/core/ufshcd.c   | 73 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c | 48 +-----------------------
 drivers/ufs/host/ufs-qcom.c | 42 +--------------------
 include/ufs/ufshcd.h        |  3 ++
 4 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..985573726d67 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4448,6 +4448,79 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+/**
+ * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ *
+ * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
+ *
+ * Return: 0 if all lanes are in Hibern8, -EAGAIN if any lane is not (yet)
+ * in Hibern8, or a negative errno (e.g. -ETIMEDOUT from a hard UIC command
+ * timeout) if the attribute read fails.
+ */
+static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
+					unsigned int num_lanes)
+{
+	u32 tx_fsm_val = 0;
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < num_lanes; i++) {
+		err = ufshcd_dme_get(hba,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+				&tx_fsm_val);
+		if (err) {
+			dev_err(hba->dev,
+				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+				__func__, i, err);
+			return err;
+		}
+
+		if (tx_fsm_val != TX_STATE_HIBERN8)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
+/**
+ * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ * @timeout_ms: overall timeout in milliseconds shared by all lanes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+				unsigned int timeout_ms)
+{
+	int err, ret;
+
+	if (!num_lanes)
+		return -EINVAL;
+
+	/*
+	 * Poll every lane until ufshcd_poll_tx_hibern8_lanes() stops returning
+	 * -EAGAIN, i.e. all lanes reached HIBERN8 (err == 0) or a real error
+	 * was hit.
+	 */
+	ret = read_poll_timeout(ufshcd_poll_tx_hibern8_lanes, err,
+				err != -EAGAIN, 200,
+				(u64)timeout_ms * USEC_PER_MSEC, false,
+				hba, num_lanes);
+	if (ret) {
+		dev_err(hba->dev,
+			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
+			__func__);
+		return ret;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
+
 /**
  * ufshcd_dme_rmw - get modify set a DME attribute
  * @hba: per adapter instance
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index bd223bda1ce2..b84075dfe00d 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -22,50 +22,6 @@
 #include <ufs/ufshci.h>
 #include <ufs/ufs_quirks.h>
 
-static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
-{
-	int err = 0;
-	u32 tx_fsm_val_0 = 0;
-	u32 tx_fsm_val_1 = 0;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				      &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
-			tx_fsm_val_1 == TX_STATE_HIBERN8))
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				     &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-	}
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-			__func__, err);
-	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
-			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
-		err = -1;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
-			__func__, tx_fsm_val_0, tx_fsm_val_1);
-	}
-
-	return err;
-}
-
 static void ufs_hisi_clk_init(struct ufs_hba *hba)
 {
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
@@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
-	err = ufs_hisi_check_hibern8(hba);
-	if (err)
-		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
+	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
 
 	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
 		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 1e492dac8d93..815ca82a0878 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	return 0;
 }
 
-static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
-{
-	int err;
-	u32 tx_fsm_val;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_STATE_HIBERN8)
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout))
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-				__func__, err);
-	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
-		err = tx_fsm_val;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
-				__func__, err);
-	}
-
-	return err;
-}
-
 static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 {
 	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
@@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		break;
 	case POST_CHANGE:
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
-		err = ufs_qcom_check_hibern8(hba);
+		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
 		ufs_qcom_enable_hw_clk_gating(hba);
 		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..0d9d0a26eb20 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1556,6 +1556,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba,
+				       unsigned int num_lanes,
+				       unsigned int timeout_ms);
 extern int ufshcd_change_power_mode(struct ufs_hba *hba,
 				    struct ufs_pa_layer_attr *pwr_mode,
 				    enum ufshcd_pmc_policy pmc_policy);
-- 
2.43.0

