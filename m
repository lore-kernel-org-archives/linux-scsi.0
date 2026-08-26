Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6631429035;
	Wed, 26 Aug 2026 13:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751674; cv=fail; b=FYF1DBdft8RVDCXwNYBw0R0JkCzjAFISXsL7U7lK9VIUFLmTYuzlmQcyPmGJt0ig2I6kJARQ8ipvgiIV9dHe8JumORHw8eaMtP62OnAt3fTwVKJxqEQg3aYXf59ujfcNZrmGvPhCLBwete5TMR7EAcoLJKJzgHgVm3EUz/5WKBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751674; c=relaxed/simple;
	bh=IKR6tPzCusO1x2STI9zP+1swPcQBEdOG7/4X0RadfeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s1yeNcBr1spYMfSEb0PN2vWcUix1vKebD2ZDv7NmZb9p1qRPPSZgSQGXkqmRw6PdzKg6oLaJzqYjj8BDb7rX7xauMfvq/6IjmQlledcNw3mjHorvlaHuG1uEBWSGrUSXKLdZfJnO/uf5dXg+1IMZrgPxFhFZ5VHraHs52hoX+vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=keag9uzJ; arc=fail smtp.client-ip=52.101.70.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="keag9uzJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aV3jQxT9u4SC/V1pj562Lsvhk0v9sGN36vjaFUNa+OIZdaMpdWjMgv5gml0d+hD1wabUFVzR8S7mEJsQ9zUGHSl+norqtC7Nc9krsrfT4J0TOJTjXfKEy1Iv2mL39+S+jF/jVxbdCKXydM522ZtY2ElO/iAczLvYqp7Z/hrFSaEYY9OliG92xauw8WnH5uhKXapf1yydFQDPf8Bcwr4dADkTHrNhKTFNbkn2TGpSqV8audc4e7EKIIVJL9YeJ5XBtVNxvb1SKSoh0w4JRx7QgkUzz62S3wRxk+LcJ7FVJOGjhwRLTiAS2LXhit7rBSepHOc+8YnJjVMjkFLR9kpVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7Q6p45GrG60DJDvQAPYQHbAvXhG+Xh3LO3l71PjPjc=;
 b=R9oAfJOlgdEjbMHSL8KKeLM7wCF1tjY5EkBmsyVWeD98X0upOX1xd10ZEdMr6AwcechrHDs+KfndwbZ8GBjTDozJFuq8qQWxM22rEZWM+cSGreqBxq66QQ8uFfBe1KtulzbR4veMO8ONC8ITJ0ohwjD54ru0Lynzz4g1bUN0uVvR2pkpT/aNS5zivEAHfz45JQyvUhdzGVnJkCvputE62Eh2QfWObOfpQ5DeC7md//S/sJ85IoobR04hnXPnTWvHKPvYQHs5r6AS9aUxn0B61CJqleO7FGjiwTdiSfV6h8/tqO8y/0PrNQpwJGhPLswEr5dv4tNQb1DOYK8LxBVKaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7Q6p45GrG60DJDvQAPYQHbAvXhG+Xh3LO3l71PjPjc=;
 b=keag9uzJXpc8tIwNE6vbs6A7zSIF55W3q+79El8RXlu8pEwss4qUZDmUZ6SRsxh2ksPCAdtaQ2kPzkQMEbyZY+vdSh82+XEM2yUEWR6hAnNhi7SGUGYEQ2WFlBhkh2UVKU0V6pvo2nsiYGZ3o5ja6KMbxvJumMMFW3TZ6DQpnNny/7Q0eKKfA0rT4xrPI78NOVNAkeDfAvkRAAN14/+gcaLxui8ukzrfjATqyU9qCmqK/vDhIUS+iPivFx5nozycprhvdVDsJ2cfNT8NnulaOvYpd/v3/2U7TwzrVjdez9LnYps55h9brrOnRrtbV+4WobhMHaXi5OvQT65W7L6dfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GV2PR04MB11862.eurprd04.prod.outlook.com
 (2603:10a6:150:2f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Wed, 26 Aug
 2026 13:41:03 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 13:41:03 +0000
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
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org
Subject: [PATCH 05/10] scsi: ufs: dwc: Export common clock divider and link status helpers
Date: Wed, 26 Aug 2026 15:40:43 +0200
Message-ID: <20260826134048.854748-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0378.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::16) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|GV2PR04MB11862:EE_
X-MS-Office365-Filtering-Correlation-Id: 04568087-a577-40e2-a0d5-08df0377abbf
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|19092799006|376014|366016|921020|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 pGJCA9R7Db1tU4gGZPh7m/lV2KxO3duBvASy2XOrwR3oPlb1tqSoq+ilsMhFfk42fPSd4I10xk/AC5z3V1KlUh6xi6a+xvOEehIjmHUt6KpOmTiKFeG2D9wFHpHnl2r5DG1GVmN9WlL2ctAE07FNfkKlM19K7ABn4MkuBCUheS4aMYwCoEeTtyLiJOrXW209A0Yx/HzlHJxmpiHIeJmTuD1ZNHTlLcfdqphPaySKfFWVKvkB+piaTfK21w05N06ORmOqBzMgS3hHfeC7l0aVBdAGe0DR4frVwoDH8V0GXSp2dMJuE+d7lVtR8KGOi+FBmJslMyOImoxkoFaUIejY6BUaJ6h708gH8iQxwkoBbyTT2sb7CORzSRTGgjvvlDNchOrlqls7EzqWciFOdKq9t9bDOFb2gGh/NklVCESibzWZ7/FVON5izV/eqUh6SuCk0Sk4Y5dEiB/wddc652UTb+U2V4unC88nZcDGP786aOep+b+whIdXh1zIbOvlj4QFq6KKdOy97gyjWDvHTSjTOojIQqqN4qgmMY7WsPK3gdLEdPf9RNCMMHaGSKSiSBb94tgPmLjxaMgXkc4C80c8KPgzm7df4d0iODwXe3S9Kfq1FDy8QP6ZQJJbokNDgKA9hwwg84BszfNpRZhx2I3c83HtFMhKgEtV/t8D9UPECCeYz41Z9ht8S2PRQUwbo5+eIYVs8OHwKF7+FQmsjDWVrw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(19092799006)(376014)(366016)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SWdEb3UrNEMzbENiYzRTNFBnaWJzcEZQWi9sN0hBVnN2QjBmbitBdDUwZFFv?=
 =?utf-8?B?V1loWVJCdHZDRmI0b3hWeTM4MFVURXMyZ3VubERLS3hVR3JpOU04OHh4MkFI?=
 =?utf-8?B?U2pERDFOOWo2KzNhc0ZSS2prMVM2QzAzWGJWYU5lelpVdTkxMVhUMVZ4QVVR?=
 =?utf-8?B?MzlDTjdSV1RYY3MrSjNGa2JnVldqc3FkU01DUFRyVDNyTERFNjJlTDZKR1ox?=
 =?utf-8?B?Unp0U3pmUmk3Q3p2Z29CTGV3azhWYlRlZEp5TTNwVkNrTHFCS1d0YjRkaDFY?=
 =?utf-8?B?L2NsV3daTXNFU0l5alkrTjZEWmVmcjB6WUFNRkphakpLcFBiZmNqWTVYTjVC?=
 =?utf-8?B?VnlwTEFTZTBoeG9BODhyeE8zRGU3dXRNYjRSYktYNXpnL2tGMHNRdlNrT0Vs?=
 =?utf-8?B?U0pVd1JWaldFcHJTR3lvT2dQTzZBdUFMUktFUmZibllwd1Q1MGlLY25LMUhH?=
 =?utf-8?B?dExjdVN2dW1PaU9Bb29ZUGg3a1VvSzBRT1dJQTVqa3FQaExFaTZkMEFBRDJM?=
 =?utf-8?B?VWxmZWZTMVVwdEt3WXdOR0dqaWYzUEVDbXlmb3ErRUFlc3E1elhWQUkyZVNm?=
 =?utf-8?B?S2Q4MjR5RXB2UmNYRTFidjVwZ2Y2U093L09ydlV6d0ZJLzJtWkZ2aGJMVzY3?=
 =?utf-8?B?TldVZFhNaS9ocTJXbGRDNE1oRFUya2V6dDZGdlp3L2JwS09Ja1VXMlFLVDRi?=
 =?utf-8?B?SGNGbURpWVFYV2dGaUw4OTJ5NW9PbFYrNUVra2k5QzdZaE1nWUJsMkdoQjVn?=
 =?utf-8?B?a0RkdnZKVWVHMVRRVWppYjVwVUk0T2hOV0h4RUFTS3MvNGJWWmhSMjRyckRj?=
 =?utf-8?B?MHhuL29HWXQ3MXJzNVJFVkRkUnJ1a0xBNVlCbStQaHdRclIvYnFSb1pvV2VC?=
 =?utf-8?B?MU1MTTJtVEJGUzBVT0RodGVmdjEreFBnQXUxd2F0Q1gxK3p0aGZtKzJyL3Vh?=
 =?utf-8?B?cTNJUXlnRUw0R1pIbUNNM0lEWDJyUnA3Z1d3UmEwSTBCcjhPcDZwejR3Y1hC?=
 =?utf-8?B?Y2pleGszTjBJN0RNaGVyN1Y4VTduSXI5SE50QlR6elVWTkJ2SzZKbFUzWWhr?=
 =?utf-8?B?TDZ5RC9wdnlQOTVMamdDZFRTMk1JbWtPWjFJdnhtYTgvQkR1TFhYOXVZWjVR?=
 =?utf-8?B?cmxMR09mU21PNlh1UTAzTVZMSlBmcDJ3RUtvcmxBZzZWcFRIcjNDTzU5bDhh?=
 =?utf-8?B?TGZsSVF2N0VVUHVHUnMyU1JvUmV5SWlraHJLOGg0SVplbXFwRmQ0emRzYVpS?=
 =?utf-8?B?NVNNOXdqOWEwUDJXMnAxS2xKN3dRb2s1MGltdS9xc0ttQmdIODhjNDk2OWdN?=
 =?utf-8?B?OGQ4YTAvVkFtSVZ0MmZtTUZ1NjlWaDM4UzkvclFaWEI0cC9wQ1JPNmc3eThP?=
 =?utf-8?B?K0p1N0crV0JhMTlZSDRNaG53UElRNTd2RG5VU0oxOUZFRXdIYlBEQzRFQWkw?=
 =?utf-8?B?K2Vna29rY2FjNnZibkE3cWJ0Zm01YWpINnhlZVA2aHpjVGNlUDNkQ0RoeVBD?=
 =?utf-8?B?SEROQzBMYityREwvM2U3blc2MTRBS3Q2bmJaYUFhUm1OSGhVRVdRUnNHUjFQ?=
 =?utf-8?B?RzRnWm5zTVdLeU9Vb1BOdGk4OE5mdjAvN0NXQVJpeGdKZVYxNk5wMGNFSldN?=
 =?utf-8?B?YnU2cWNiWU1NVDIzd0lrTnBjLzdDQjFvK3N3M280ZTBYRVhLRkJTZk5mL2Nk?=
 =?utf-8?B?VFByYWE4Zy9xc3FJRUl1R0hQRXliMUVIVnhFWmFzV3lxWWNweDhMdFZvSkFG?=
 =?utf-8?B?RUFyS29ZSVRFZTJMNCtTWEVBNDY4RzloQk51bnR0eDVud1h5OGNxeEtoQnRn?=
 =?utf-8?B?ODFBZ0ZaMFhIenN1b0dNV0xGM2x0eGpEWEx3VDk3eFdtQ1Z3UEI2M0dTWnJJ?=
 =?utf-8?B?TjdIMlBsSEdHQjg0ejArSnpPNWhCdk44b1JZaElwNGFnTjN4ZWJiY0ZhZEg2?=
 =?utf-8?B?U2J3MHZQOGNhcVNxanQzbS9JUldrRFBPc3FQY2lSZTdhaFVmOVgydWVvVkNX?=
 =?utf-8?B?aFVBV0JRTW9vYmpDSTM5SStnR1BPM3l6WENFcVltczBJMXMvWk5WNlREWkk2?=
 =?utf-8?B?bm5sMzhnR255Y3BLUlF0RkpwNFQ2QUZReFVaK25oL3VDT0VuMTFYZlhFRGhH?=
 =?utf-8?B?ZU1PMVd6aWJXNWNxUlFMeW1jemg2S2FEbFphQVpFcFFsd0dPU1o0dTRvdnhN?=
 =?utf-8?B?WmgwUEZyWWhPUHZNb0Q4ZGY3RENWR3lLMmZ2KzlTL0NaREwvVUhQUjR2dDl3?=
 =?utf-8?B?MWxxOVpOMzFsTTNqMXd4MXhmcmZkYzZyenZ4dW9wcVJpOG9IMm9VMnR0OUhr?=
 =?utf-8?B?N0U2Q3lOayticGo4TWJUQnA1WHBVbEtHOEtCSWsyYVc0YWJYb2lqQ094ZnJS?=
 =?utf-8?Q?tV3W4KaA1cTu1x7o=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04568087-a577-40e2-a0d5-08df0377abbf
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 13:41:02.8156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7NK50t9mAnGsAqhsh5mMrObjrWvkeaYcyZTXVrBkb8HVh99QuEnnThR5AFDrS4o6ftP3G4f458ck3NRndShz5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11862

Make ufshcd_dwc_program_clk_div() and ufshcd_dwc_link_is_up() available to
DWC-based platform glue drivers. These helpers are needed by platform
drivers that must program the controller HCLK divider and verify link state
during their vendor-specific initialization flows.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 6 ++++--
 drivers/ufs/host/ufshcd-dwc.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 45920793d1a8..4a689d211e81 100644
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

