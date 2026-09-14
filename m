Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B04475335;
	Mon, 14 Sep 2026 12:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390224; cv=fail; b=HoUpJsguKs/FPDbO7l/h9h6Xiwb0qa2QvU9V6JXge4c2w0IuP/P3MTcIEI7TROJJlOqncro2QnPW28Md5DLXPkRF7XgRxnb9B0UiPDjQh+QH2ZpLMhjNQXIm9aKCOBbuJJDRpUzjGd2DpNidVZIEijEz8r/UjLQiFlxAmMICuWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390224; c=relaxed/simple;
	bh=T1WVVLI2dCHbzhT/kD7wNObTExv6HtQAnr82p+jWbBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uSjhWfXWzyGQ+oH2ciqU6KSTTII0stEJHmseGy9OMtIqVTAsDpciu6cF5OqftTmMh8AOM4zj5zL+f/Wnbx2XjTrBQsltKKabGz3Xh7+zsrPx6qIXQQd5KSjpSjnbDNloLKX5UgjjsyShiW1Poq9ah8PgHEC1Q+4ZVZIU9dWi0Y4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Vp8XnMPx; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Vp8XnMPx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V8gCwnzsVq+F61Niy5RSaAJEQc+KfU0vqj/XJUTY934ojJz9G7ujq6oO5c10kYyB31WWpMdUeePnBCDuzeHYpFUThOiUbSLbohG+HpGwnMydHXf+mbutqBIik1qH4q7lkMbw7lsuoNmeWgUlmNDA1ic3Q4WpkN1xfjD5KBleIZZ9Cprw/OKmiPNwogAf9WY7lZX2FRmkE/IxtN2J01Rc2MLHnM7XP5gic0jxmtWQi/res4/qz8rNV44f7vwH7vNTRBTXL+jkb7RVCkC205n2yaeUfNaVzy7Q5mqV0Hi1Hq0h4kj7pdeSFxSJ39Px/g5r6nsY2nNJ3lvvoB0bynDrMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQUXhftURTjhh1iKq86SS9IMJdaJpMwRFa8pMuZB1KQ=;
 b=RQAz+J3gZ2JLBYU7Ebi3GoiaXfTnW0HHNzZcyfFl4PKo0NKCOGUxtHIbop1H1KU3b0bI8IxEkvlHDa4+x1VN82f7j+udliGl+0VhbMnou8It8xTqxKMd97yVKYLwhLu/dJzE+TvcI1Pffum2vCuzDsC79NcoFjsKZlPfMwTimozlXM5Inpg8SIjEWin8FrDB1lhE0RaZYNuqQDL3CX+kFtjVW1trb9OIOU4y2fHKa7+aNOKbTcv80/8FqUqKFw1QhfRsgEHeE3UMIo1cvKR79yqM/RN+sro9FAEX/cEv9/RykEPy0Y4V2TcqicioGN1xbiQ5/nN9jzhbl6appVE4bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQUXhftURTjhh1iKq86SS9IMJdaJpMwRFa8pMuZB1KQ=;
 b=Vp8XnMPxcTTFsiEYqxIakV/d7N7RHb+9ugqtQRMjtHOAFiD5Xbfbr4DChye35pJOkMiMiiFoibi7sMbeqA9Scv2btXvMT+QjrVtm1B7EVJdlmjbjeroq9F+Z3KjGJc3GSFkICVLcTEh8qvGs+AjF20RFUZPyEXjN1owQFE1Xfu1LXn0GjafXRKWUR2kWx6XLwKO7E5722ybwVJ6UJuBexwog0BS8YUgoRztCCpxowEpU/yjpQl4UNkZcEciBZEXxS7ey73mD5+SHdmGDNsrdmpPFUqtuFd5IFDfEklkHJtk/Sc1dgY4gbGtdj2pyzJjmiCvVoo4ITVd9g/WUcQNwVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7272.eurprd04.prod.outlook.com
 (2603:10a6:10:1ad::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:14 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:14 +0000
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
	Pedro Sousa <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v2 05/10] scsi: ufs: dwc: Export common clock divider and link status helpers
Date: Mon, 14 Sep 2026 14:49:55 +0200
Message-ID: <20260914125000.30812-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0016.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::21) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DBAPR04MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f28ab4-1eef-4d5f-9c44-08df125eb880
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 94hVyO8MxYUMWgsyojJSz+8M9HKqkunP9Wz0aXzqxKdH0x0Ow2H5wceIlS3K5CjGkTaQLVtkwx7pH43zj64rRSAQ22MoldIRBOM0JyBZzzfifXc6SwyPsAQEE2VpE+BlILVO2m0BXBDXzxaWj65GjHa8f5j5QjazBiwb3oi2jVx0IWvH7wFtr1BZ6oc3UU6TPFNGW22UlQ1nNaz4B5iWrm6H6wx1Upalp/XPRWLBqhBB9iOmL/zh/AQl6eNfLMGCApAhzO0TdLLgFDlkbC7zTzKehsIZv5ZfgTB03U3/PWWcBpPHBUAfASgm28WGhPVKHQWWrOEpUeXnCKC0hZ5nWdigYiOot2Uzdtvqidyv+fNqu/nqC6GjI/ck1rn9UY6JgTnT28ruMrwPNsst4FHSaP6qB6ZyikzhV3kDr2RyfaS9OC8a84lqxd59wl0po2zJtNZghscROpFYZF/YWGN0/lv6iJclh48kdK9/Y+9mbBFzsdmXjNjP2gxJqNbVfl6ilzqNNPpcynamaln5M9+G/WipprVOv8BBQxqjHuiL9nT7YdP2AtrXHHwBQIDwXPoFKG0SotArolrax06d2rlB2jwnyb9Sc+WpRt2yCGqXIyMvZqUWAqrp9hx4DcdGoIokEmJ8/OeyvZbKFdasI5HBMe5fizTmpXajxLQPVTN1A18E2c1kHiEDLkqsgrMdPO0fQDCBuAE6y172PPJxu6upHA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?M2I1RFlwOXNkSkUzUW5raE91YUsxMmhWWjFBVmhVaVdyY3hQYVZnVVhRNXJa?=
 =?utf-8?B?VFpiS2xGMFAwNExmb1pIZTdYdmNFT3RJZnJobDNMUzVoQTRaMEVOeVVuLzRy?=
 =?utf-8?B?NzVUNFFqZFVhQURjbGF2VFFwcytVTC9BeG41aUJnc2NLNUExUmxKc3ZudXV4?=
 =?utf-8?B?VXRXUFJJNWpidG5zUjN0cTY3cmpGSDFLZ0hvWXMrVVdHNnJTTFE1TUgzTHpQ?=
 =?utf-8?B?cWsyaWw1akpKNjRGdmtJUEQ0bWxWWU45SXgzQ2dralgwNVViMVZDeDJkWnRD?=
 =?utf-8?B?djVhcmFsV21tMlNQUzJzVzlJZWtrTTFRWkNaeFRiZzFEUE0reHpBQmVkNjIz?=
 =?utf-8?B?QThhTUJhdU5DRms0UDVlUU8zeWpHQVcydXdxb294UFExMUZFbnZ4MUwvRzk4?=
 =?utf-8?B?NXJpUFhHKzNITFFUUmppMDcrOFVTM1Vvd1ZLTFdOd2Vsc3BhdlByU3hJbTlp?=
 =?utf-8?B?K3JaQ0VLUlBSbmtBR2NGOXNuMWVLb3Q4TDZ3SWw2ZzRQY2JseGlqU21Dcnlq?=
 =?utf-8?B?RThqV1prb3A1UUZUSVUxajZyNVh5Wkd6TnM5NC9RbU43SHlQR001cG9DYzVT?=
 =?utf-8?B?elNlM0NOZ29BLzE4QlpvMGxlU3ZIL2R3Z1pVVFk2ZVlMMU1lSTJqS2sySFY3?=
 =?utf-8?B?MFZXblVMRmxnTG1wdENVZGtWOGs4OUt6TmVrQ1NEcGJNVGVMUi82UTJFeVQ5?=
 =?utf-8?B?VzEwMUpkREllY0xJbGVnU1FUdThqeU0xNmZJVzM2Y1ZBYmZtR3MwOUtRa2xH?=
 =?utf-8?B?TkFrU25YanZ6VWl6VGRBYThLV3pXTzJQWDZPclhMUUdxeFJTTkpNdWpBNlhK?=
 =?utf-8?B?UGRiVFIwOHMwejBrWDBZbUdESkNvMG1ERGJ6dUltWWtXK2crRFVoalFPMEdh?=
 =?utf-8?B?b2N3K0VsTU5qSDB6TGl0bk9HTis2YWJ5NWwvMFAwZUF6amxjRGdCcTdNZkFF?=
 =?utf-8?B?UHJxU2hTRWpHMndFME5HZ0l4M1V1eW4xTDJRZzV6dzN5UHBkUHVVeHRlUzh6?=
 =?utf-8?B?azV3S2xadjdHUnRTcTluZ3pNVHJrcGdqaWJCS25UOG1qNkREa3lKR1dHR0VV?=
 =?utf-8?B?RGpVb0F2UkNjTzdyZkZTKzl2cGJoZkVPaWNkcmIwb0lTTk9DSExpeVZWZklY?=
 =?utf-8?B?M0pkNE1tTVNUM0d6LzV5emIyQ2RqNFh3eitRODZYZnNvOVZtUHNBS3FiekpS?=
 =?utf-8?B?QkQ4OGd6SC9ZS2tYODlEbkJzTGRzaitCc0NkVjRZWnFQZVpsT1h0eXJZMjI5?=
 =?utf-8?B?Q0J1VTM2UlU3ZEFOVDhQT3FYdmtxd1AyN3VnYmFxV3RnWEVtalZNdzRZa1NS?=
 =?utf-8?B?c1VvU2lCT2Y4UDJlYU9ZVmFGUTBzYy9CWFdzZGVQMGhrMU9Gd3doQlJnc05q?=
 =?utf-8?B?N0ExYWl6dmFoVWFML0VlM2hRMDZnVjFKR3Y2YXYxQ0xMbHEycWFDVWRVU2xM?=
 =?utf-8?B?N2ZkVDNLYTBtTStmYTlSRTRpZHNOUFlLKzVRazF2d3BTeE5CWHZpUzdHNk1S?=
 =?utf-8?B?K1U1aVBvNWRlYUZYZmphdnpoV0pYSXVUYjZ0Uk1xeHZmV0NzdlVwWG90R1o3?=
 =?utf-8?B?RC9nU2cvUGhXUEZNMHFRakZRTHF3cElmV3RVeFV1Z1R1ejdhbG5CbWw2MFJZ?=
 =?utf-8?B?bjhiWWkvOU5BV2FkN0crM055NkVrQ0JERUFrSjhGTVZDMkR5aUNFekc0Wng3?=
 =?utf-8?B?d1Vqd2YxL1ozRGs5aXNqb3UvT2I1NzNvRVVWbUdXTTh5c21ZdWJnU01sdnF2?=
 =?utf-8?B?YnpPUUlDZlFtdDNaWmp1RjA2bytWMDZOVUxxZnBKUENLS0xFM3NyS2x4TkRW?=
 =?utf-8?B?MHBEUVRiUXlSWWUwY3lZbzlpMTdNZ1pma1hsNEI3V3kxOC9nRXVWYytKV0dk?=
 =?utf-8?B?djFhNnZmTWJjald4RDV0ZWdpSGZVQTdhU0NwQnBxQ1FsVjg1aEpCdHBKa1ZV?=
 =?utf-8?B?eDRZK3NmY3IwQ1J2Yk1EelpwZ0RsOUZFYVYwOWNsT0hKSE1Cek82RXN4bDgx?=
 =?utf-8?B?Y2ZTMDV3cGdxNkFlcWZqbkd5Y0Q5Y1ZISnVKTzZQZ2RRKy9rNXgrUjRaWHVa?=
 =?utf-8?B?U2d0ZXgwZkNoRk1zSk8yVGFvV0xlY25mWVJaOGVzNnNvT0VZRWM4anpuTTQw?=
 =?utf-8?B?TkRFbGQ4MUF5OUs3ZGJkL2VlYjZwZkxNeVpNMVRENjZ2Q1RNS2JVRlNWOTdt?=
 =?utf-8?B?eEZZS003TWc2TEtWKzJVbk5FNTZaWnhjRm55QWpTMm10TmdvUVl4S0JCTytw?=
 =?utf-8?B?djBCN2tuZmJLOTlJL25YekhuVk9DVWZVZHE4TmFvU0RWalllcTVlMHJjY0dh?=
 =?utf-8?B?UnhCVVQ4bkRkclZoRCszT2ptUVJiZTVYQzYyeXdMMkZZM0JHZmZ5dz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f28ab4-1eef-4d5f-9c44-08df125eb880
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:14.2520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3XurG7zRCkoOiiaZnnyKIVgtsafXu+B/MfSADIB6uWAqnxzah9gJkzkAaTZcU8pmDZdQYhi9HkF9P9KvG3MYzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7272

Make ufshcd_dwc_program_clk_div() and ufshcd_dwc_link_is_up() available to
DWC-based platform glue drivers. These helpers are needed by platform
drivers that must program the controller HCLK divider and verify link state
during their vendor-specific initialization flows.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 6 ++++--
 drivers/ufs/host/ufshcd-dwc.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 0eceec543d14..7fe54923c6c6 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -39,10 +39,11 @@ EXPORT_SYMBOL(ufshcd_dwc_dme_set_attrs);
  * @divider_val: clock divider value to be programmed
  *
  */
-static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
 {
 	ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
 }
+EXPORT_SYMBOL(ufshcd_dwc_program_clk_div);
 
 /**
  * ufshcd_dwc_link_is_up() - check if link is up.
@@ -50,7 +51,7 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  *
  * Return: 0 on success, non-zero value on failure.
  */
-static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
 	int dme_result = 0;
 
@@ -63,6 +64,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 
 	return 1;
 }
+EXPORT_SYMBOL(ufshcd_dwc_link_is_up);
 
 /**
  * ufshcd_dwc_connection_setup() - configure unipro attributes.
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index d8673cd54d4c..53b523ef59df 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -47,4 +47,6 @@ int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
 int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
 int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba);
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val);
 #endif /* End of Header */
-- 
2.43.0

