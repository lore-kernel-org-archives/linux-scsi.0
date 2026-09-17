Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CE04AB1D8;
	Thu, 17 Sep 2026 09:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636578; cv=fail; b=WqosrDsH3I0fqnP6yqb2HW2PXwAoIUJyJl9vfWOCQEDck150hdOKDU+U9mreyfFJZdKNeNHCvyzZT11rKEYx2esLon6SMKfS+p0IEr0KF2/yYF2zz0EXzrf1DIARkd6pIzgExb6Y1BtAbgZFjgVkdfHZ9DnTTDdb0hR6FE4nTug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636578; c=relaxed/simple;
	bh=93SRhXjUxz1byGfzUvmXDstTzFRRiX+x6ziIEntNfGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p5zSCSsSP7Xz0pZpVM9y5WcGgcOlyrHWtKp2v8n5QpppAfhjtj6/MiZ3x/JON7rccbYwtcLcbKzcl2MORXkaCIWp+Lz+fgWfF4BdiQCK56DFLDIgEtNoz+YsLsBj7IuK3qLwviiBfXCaChUhyqvgbjUiadfz6jvCT1GwTT8YMIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=cJ8czPam; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="cJ8czPam"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RMQ07Bfqi4D7bKpAIS/HttewFeuOEFekJBjvDNpVS+pNIytbiGfYpUEzSBgkTkhfjH96EKo1lY3a195T0T2GUlEOaCT+yXBcpGuf0SRT7T4DGKPgaOH0TtGEeig0+IGkVNuD+hAoJsB5pODCZWBK81cWTIQ5Z8Eg8/nfjvDQ9+ll3/Mwk6SPUldIXDeS7MV+aEBV7f2ey/abclVBRhy7AYHqpH0mdNLzvJCHve2wCziFz1oZWmbZphshAmUfpGEBAw0qyJEnQrAGFLpSh5PwqSpZtD3VkaN+l/WRrP+e+xat5130I9a4GXKCtiarLsMhG1c6g0dk2pdPMkI2fvQGZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPM4cIMEuK/SLaKck7AgGlfS4gGu3+p7D0uDQrXERn8=;
 b=blXSWv3vmxq2W55uzBCOCuQhBYIoccU1Rrz4LB0GwlQiNnhRTNM0RyQqIxVDn606nDfue/r1Yy8dzESpUZlcRwEEOgEnP63IzpDzpb50zNZRcjkevpbMsLmNQ9OCpaAyCKWFc3luVlQcEqRse61U4a12I32fd+r433RlZpTUzrc1k53d8wLTWDJHo1QuHNgaS+tVNep0WyhNWyHZr6NeJrl3IlC1NxnQv+KDLNm9cgpcHD0bNnHGDRHBj0SMmdwnTsY9S8Q6nxFhc9Xgbujj7gRLVY30EmsvGzrFZIfFGN38en4XqMuYY4ZcTya/z6Ur7J/XENdjGuIwYk2kn75hEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPM4cIMEuK/SLaKck7AgGlfS4gGu3+p7D0uDQrXERn8=;
 b=cJ8czPam56IZdYJwJGcP+ul0Maa9b0YJL7W90V28HvILV0hVAY0tjYEhv8Y7KFFNcQOAR0COiTDjJt6BGB7G1JJTRRfLIxXabhxpLjkz2zxzrhMRgR4bdfVGsnbwnUjMWQoEucwopvNHVPO03vb84kbKM4gcpSLqlSwHSgmw0rnn/F/8z9Yg6CImncEiFMfDTw76eoprAhaMlVe0Z6sZadNVZb+XcsRlpPZvT6d/zyMTYaAMIrmsmEVHnmhhu5LBMz8X54HITxe+HEsbGD9WrcKEhaXIdt3nfgStT5xrb4WUUjS9o8lO0mngvspH+RmUpMSQglSjIZd782E3zZT35Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:16:10 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:10 +0000
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
Subject: [PATCH v4 06/11] scsi: ufs: dwc: Export common clock divider and link status helpers
Date: Thu, 17 Sep 2026 11:15:50 +0200
Message-ID: <20260917091555.1443076-7-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: baa2f17a-c2d0-4e63-c06f-08df149c4ffc
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 EPFqFtJN+BE6/QyyCBdHbpiiLv/lu5jjCNUnmjGrciImcobX1H0wSK9beTvSFEOWISyuxyvgxMGV5oNFtzCt0DnbUfhgDamuMUjHzMRamtYIktgwWfKUoN99ur8ZL2mB9A5Fwp7BMwlpUkxuGTEJR9XOcp+ndoFtGcpUujZJTbgBhjsFrH6/BO4fXublFN4MQuor9gyl54S2RmOCHkhnWdgZDED1A5CVnkQi+AzjuCq3KPdEzHYv6pVDtT7PavrfGO9eosW2xeW9zAwwzSSi6AwX2X/kkxvubDPUyqB7INnnQa5p9ygS2fPZmKBCwQ/TQvNw9+g0W1Yv0dtUvEPFR9OjKhJ9zdRnOiwWNuVwWOb9Qzbqxa7EGjIThmxEUVxxwtw+pmz0N9vEezY35D06EJfON5BbFJ09q6oAw9kB8rax2X6LWTDzrFx6iPccxY8K9qDGAxA5vvW587j+wvMHyxsoeQBfHE11bbpPkcPTbs2R8HpbSEAz22ut+Av90ctNN7gndV2ac4gkGng6fcOZruACqsGvlkbF+SuUyCCiW4rRQnTooW5RL6NvCPRxo/oVjRm8XH+UTRj1qq2eS2IfAno3S+qMLp5hfXV85nojT0hiVfEWop4gwz2v4wBeVsaPywHl34CkFQhg+dTy3n4W1XBX7y3nZTQGmNXvSDqy/kugjjJ7ozkdhA8lYCwXytT9lja+EjR4WlVVGq9lQJOOeg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZWlkLzRjWXhIa1d2K1NoWWYxUFA2L2FDZkdwNU5FM0xrUWV6SXdHb1BHbHdi?=
 =?utf-8?B?UHNXZFNRTUQvd2JvTmZLWVg3MFlXMDVIcUM3Tit1MlE0MU1hU0tUZUpOdStB?=
 =?utf-8?B?WW1ETXMzTk5STVBOeGc5azdsNDMvWml5MEVlUDdneE1WdDZDY3FreHpkSkRn?=
 =?utf-8?B?cTlLbjVwNUNPcVFLWS9yVnIrZEwzSHd3U0FXNmx3QVNFWjJiWCtob1FQejBu?=
 =?utf-8?B?QWhicncvRDlKbUtTWC95WjBBakp5bDZwdzl3MFFaS2E3VFE3V25USDhxRTBw?=
 =?utf-8?B?RVJlOHQrTFd3T05GZWExNURDcDM0MW9XcGxON3ZMOUpzYmswMGZtVHVHa0Q4?=
 =?utf-8?B?TW5BczBBc2c4a09WeE1CYWF5bCs5cE1WKzIyT0RLenJBS1I2NVBNZU5XSmdW?=
 =?utf-8?B?MG9qd3liOTJZN1VSUGlPcTE3aVNIYkZJcmJId1VIbUF3WkRCSEVuMlNTNnJC?=
 =?utf-8?B?S01CaUxjT29PTEVJSTBON2w1d3ZWcXJzZ3l3Y2UwSWsvNXM4UHVNRk9hWVhO?=
 =?utf-8?B?TlcyZUNaeTBrT0RxQzBmRTA2OTR2TU5mRjB4TnovckFhMXlEdUgvclFiSXNQ?=
 =?utf-8?B?QU84TXE4YzVTeXJ4YVAxclA0QUE3d3AwdGFqNHNxMWdHdDNmclZVcEx4UmZy?=
 =?utf-8?B?WWNPREtOejNXOUNDL1RkZDVVUUdGRERVaTBrbVFBTGRxSUZhWjlYdHo4VEtS?=
 =?utf-8?B?eUJkUUhkM0NSWHp1RjB6QnNoNVYzSVdRbUh1NEZqU3haV3l5cEJiZU5FZkts?=
 =?utf-8?B?R3dJYVhZamRrVXdOQXRXcHVOcStBd3hVS1NveFo3WFEyZXQzV1R6Mi9iQTcv?=
 =?utf-8?B?b2QydmlmRjVpRnRUSjBOejhFU3QySDNUVStNUDZNYjV4SXdZWFNna1A3aExR?=
 =?utf-8?B?VTdJbm5HSFUyNVVNTk82RTdtTURxNTNsc3lGYnl4SVJLWUNncVFhZ1FrRldI?=
 =?utf-8?B?dmU3eGl2VWZHRWdzQ2NsRG91ZDBKZmlOR2ppNDRNZzJ3cy9JQmRJNmJTWVdR?=
 =?utf-8?B?Nmpnbk1uQnpaVnIzSXo3TFArTGhYRnlKNEUyWi9aNWZjeXBCZm1ienJjcDIz?=
 =?utf-8?B?a3hBdWRQQnhselJQc1RLQXZBTS9HOEQxVDRwYVhZZHdyZHB0b0o3cm1BYlln?=
 =?utf-8?B?UHozREhuNC9WNW94V3YyTFhFa3g0Yi9PY09EQTBERzN0WEtHeVRVTXJ5bEhP?=
 =?utf-8?B?cmo5cGZFYU5lLzdYR3lHQWw1T2xDMjRIMmthVHc0UTVqSzU0STZnMEcraTBy?=
 =?utf-8?B?V05sblpvWTFlSm5NZXhNcFFHd25BTTNwOTd2U1dtcXlkWThXQXQ5U1oxWFkr?=
 =?utf-8?B?UTI2alBodTc1aW9CVE1PS2RHK3RpaVk1WDhXMDM1bmE1NVBtcjJVRklZb2xF?=
 =?utf-8?B?R2VJVTZnY1U4NjhrWHBDTm9wejdodUlpc0xhZWJwNmhzdWFmd1AyL0lWdzRq?=
 =?utf-8?B?ZUIwU1FsMGZMdFJyVHZSNDNvZ2s1RUIySmtlS1M2QklLNVhNTStSQ0NsZ1hj?=
 =?utf-8?B?dVRCOEM2ZUR2ZWVNaGxzMnM1SXZlN05GR096STNEOTNiS0hGUyttVHZkTmpr?=
 =?utf-8?B?VDBnQzdxNjJjUnNzbXRYQXh3TGIvbk1YU2U4S2NMWWRIanc5S1VSa3Y3cHFu?=
 =?utf-8?B?VVlSMWc5M1NTWjVoZ2RoQnNaQjRhem5WWXFibjBHcy9lUFRjTWN6NEpia0du?=
 =?utf-8?B?NzBhUmVzN3NJM09JMHl2UHBlREFVTlFNNVJJTnZVazRvb21OL0VubEV3dkI5?=
 =?utf-8?B?YUY3OXl4RGdtR0M5dE44ei9uU0o0eHBSL3kvSk91RXYyNE1COTJpNHFxMC9x?=
 =?utf-8?B?UnBCWUVOTHlvOGthUEZuUHIrZWpPNGJsWEFyZDBLTmtldFk0VWsxcFA2WkEr?=
 =?utf-8?B?MER6dW0rNWh2cFM5dVMvWHFEZ0dRZVgvaWViajJ0Wk0rbUl2ei9Qa0d4ZmRJ?=
 =?utf-8?B?NWhCcUJyckkrSHk1dkhtcExTdTJmZlV5SFlnWThSTzVYbHI4cjdJUGZHQVd2?=
 =?utf-8?B?NkJHTzhvZHR6YjM3VDRrdDUzL0gvdTBNSzZpd0NUM21BbndZZy90OGxvRlpn?=
 =?utf-8?B?SW5LcXd1ZUtMbms4cDlCSFcxZzBtU09ZSnZaNTI3dFY4dUZ1S2FrSE9YWjFC?=
 =?utf-8?B?TUJJbktZYkcyYlNEeUxNTmN5TGI1VXljSkFQSHlVTHJkSjJBaVBVRDVCU3Js?=
 =?utf-8?B?eXIvY3BBeDN3MG9MakhndzhLek82dHBzL0R5YVZsR2tpeG1iWjZWMHV2aklW?=
 =?utf-8?B?Ym5leE9TNmhqYXVRYmN6aC95cmxJSDZxaGt0K3ROODdsRXBHdFhUUGNWUzcz?=
 =?utf-8?B?eUorZ3crdjlZeHlxQXlmTHA4ZEpsVU1RUENndStnNGxhcnN0NHBZdkhNYkVn?=
 =?utf-8?Q?a+NNT8jyzyyv6G64=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baa2f17a-c2d0-4e63-c06f-08df149c4ffc
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:10.0247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQVxWBH95wDB2n0AMRarO8vnxmyLYQd8BmwDyJU/IqEW61T/6ZImC9DsKXBjh/75B9FV/5z9ULcFdaQ4IzcFuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

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
index 82b03b926e77..977b368474b0 100644
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
  * Return: 0 on success, a negative errno value on failure.
  */
-static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
 	int dme_result = 0;
 	int ret;
@@ -66,6 +67,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 
 	return -ENOLINK;
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

