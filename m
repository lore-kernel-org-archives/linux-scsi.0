Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4DB4AAC41;
	Thu, 17 Sep 2026 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636576; cv=fail; b=W3ogUSrg8WEmb6ovh9hdHJAWj/BABRyfYhQLOy4ZnG0IISBSmEK6mcZ/ei1pjlC1wyWVcZHVz7xudxS0WQgZYaBqYhZ26s6MGc3P7JezOp2i1ODzFBdUDXIqCSFQrMG/sx/fAhQ9HFtL/vUjKvLNDh3Ow0A3FjQHIJ2gjv/sF6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636576; c=relaxed/simple;
	bh=ZE0egIIW+z4ZjNTCfSbAu2SZBsTcN9KsSboPzVqe9sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xh+UwgpdpD1p2q4rxymWW9pAj5Fs0wBx4HLkSduyWrguwzT2R08mcghnMxXc1uzULeTrFzS7YRhr+Ha0PsjbkS+rjjmPf9LjEaQuCuTG966+3PvKwo6oyN/gkKnLZQiA9wUxm5puXWEk+IE7dsXBwHzKGxy/1LKafLWJI25d+xo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Xl+d2Cue; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Xl+d2Cue"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hg7fw+9Mm4k1urYHCgoxqazBfsZHcZEzwgarztesGTkskZJfq/a8GY+vdWPc60PYHtvI/yt+fuBSXUm9UA1IWhBowJdcNnWF9D95z7h5FQyqXszYPx7sbgCRn9E8lZoFwt2tRMzHKqhPN3Vq3rTk1sUAjHMMXnxYhJovryYPvQ806zphEIOagloaYVuYtVvGzU4J9+Ja9L4H6bYy6Ru0KFI6/gLffILarnNbXU47iHGcW1jSnSyEaRQK4+LmO5Mh++xQL+YI9Qrcpn5qdNDz+iygz+inQEdZbTJhifMaRVebHJQwVNaHgbZxsr56VUxpDevZjXCqRpDypxUOuBh3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7uoqsx2zML32xzDcSRhGJ174iSzdn9mEilSglZ3myI=;
 b=Ax7sOe5MewuSd67qhZfj9gSHdBw7lPFbNcb89z/VQx8T7Fx2QucFaPloC2aVrrdQsikG5HJ/qe4maAYUw2C0qakgDh1ij0bGy2UbhoeiCB8nuZItiQ1PChytEKlviFllYt+YUm2YUCLUIzbV4Yf+LFTFxl2eL7WJTfzRt/iYvYOuwBfifPoRQ0+zEU5xVyRwHw+ygDKCvwkXH84qfdpbaUwvlAYOkJmZG40/7f2Z52XjxofBRWcg8zqVYnLHTkxCPebfMvJNA5+10A/2ZDTHFiWBJExae1rUi394TPi6hRm75cfseVCERNzzuYHVxayXxr2/MW8S68+QkrfDaUJAgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7uoqsx2zML32xzDcSRhGJ174iSzdn9mEilSglZ3myI=;
 b=Xl+d2CuehyNFQnL2x5za8TxQrJteyZy8lMSrL99LInC1fG7ORF45WW+98FZIDzA2RR7mh3cO8ZgT6glPmxrW59+pfyX8boYRCBs71Mpj3ftZ0I+kpr2zA1JRQHGoZu27OalPsb/Mr5/SEXqp+uMXqqp/2kYsfazG/DsZeg5UDmncSLyVin0TCQS26m43IRs0SOcgFBxJF3I7l00qkw2l61+YVp0G7bH6ure77KzhScieGTn8f5NoLumCc6nUi5R9v5FT4cx0m17TB+z1MdD6TA0H0OLhlBvK4vLreAS6XOTTI2fikSKFZf8kEgZZ3C6rI+XGgOw+lVqVCKM/eOeLsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:16:08 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:08 +0000
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
Subject: [PATCH v4 05/11] scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
Date: Thu, 17 Sep 2026 11:15:49 +0200
Message-ID: <20260917091555.1443076-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0153.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: ef617885-3396-423b-16ff-08df149c4eee
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 f8Czg87N7AcEqsaV4BjZbG1gkLVYGhk33SqzQ2WYp2ibHBqKL8v1xqtVERJ9vd/RAtGnLA5rnMAY4YpNquqzEjayixWJMRB9sZ+af1fwGYUrWrqrQwJWrWTthA/emSbnjQ8/7+Qz56pYykbib1E1lJNDTsmlnUhIwf9eeN+ZqIpTaQak5BZ2c4jWbCdWq+g9Wk8KtKIKb0Z7YKFG7tkkCoqvJo6rfASExQzCNs2MmAS38++NlBDDGlwkfya71Acknpp6POVZEMu8kV/Wi8+uZ+27lrHA+yo5oPIoopOoWdJw4NHo5doLJ6CAWxbG8QitVA0fupnnO8Pph3lSYLS5b/yI7dllNt1fMkoZxi9bmmW8EbELQ5FuyoySK85Sm/Y2IUE+iVV81QhJl2kcdlqHgTs2O348CGQKyF2CwhLPFL5Zdy1F04FgQOVCyd+oSBVigvRcY72Kg/C9fQi343v8Jp8rtlMUVhbaKN/D/E3VT8Qn8Dr3Q66/YKtxm+hhYJpBwy7QZtslhJ63/DOxF+VolzXOQGBcs4aP4CJprKit1z99AXMGFZePzAbSwZVb5WzNbquB76wDOeFcPBQBagVSlsT5jtZJaefqKiT4qdLVMyZAMKJWFK65iQIuyLbBO73iDkHjVRex5nmBfaoUNyMOBBTTOD/Wp02lxUeZVzcWsPd41P93yS8UTChELuTNz0nCIZR2nQU0CAvfWhYVP3sWfg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RVhMdC83VjErOFNucHd1TEdKTDlhemhMWDhLdWp4c3JRWUs0dnpib2xVTUpP?=
 =?utf-8?B?Rm1Ib0pqVFVxQXlMMzd1MGxubUVpeG5TNUJrWmVJU3RpR1JFNHl2RTJrSFo0?=
 =?utf-8?B?c0dWakxUZUtoVWlPcGFLZ3NEWE5kYlQ5T3dQRy9oZFdmcjlpTENWMklyY2s1?=
 =?utf-8?B?S2lvdlhyTEZTdHVyOFkzRHVIb0d2YTRlVjYrN2dvMWsyZE4xUW5MVjREdXZG?=
 =?utf-8?B?N2h5cUhmVkVaaVFjRU1kY1hyT3lYaldUVmZjWGErYkpNbStNTzBNQ1ZXSHBq?=
 =?utf-8?B?V2JRQ0VZcElCeTlXNDg3L1dHWTNzRncwV21IRzBsRXh3c3FkbUQ3WXg1MW5z?=
 =?utf-8?B?bGtCbDM3djR5akwrRldXbm9EZlkySEhSZXlmbzAxWUQvWGdVQ3N1d1RvbGt4?=
 =?utf-8?B?dG83RHp1cEJrOGxMQXg2TnQrUkxQVjFvODM2RlVydytpa2VoKzVJY2JQbHlZ?=
 =?utf-8?B?bmFpalNTcncwM1l1MEZ0Rk9OYWtwV1NYYThYbzZDalY2MXp5Q2Ntb0I0OCtZ?=
 =?utf-8?B?bHIyVHZ1TERHZHdJSXVjT1UvTTN6WnJqQzNVNkFJODZQYmxTRHBOeDdQNWVW?=
 =?utf-8?B?T1pYbU5GYWY1ZjVnc1I5SERiaWlqeDFZZzVyL21PdmhHbWtoMnpYb0ZYcWRs?=
 =?utf-8?B?dmpzVytCUHNtOUJEMXhtbUowd0VzelVRUHpsQU5EL0NzWHlwbjBUOEFoQTAx?=
 =?utf-8?B?UlZGUmhwTElsbkJxWlpPclFXZGo2a2YzdWlPQzFNZVVXUGc3UnNWOCtpdngx?=
 =?utf-8?B?dU13a2d1bDVUaXlxMTBHTzBMSE5ReDd6WVprcURqMTFraTJ2aTlWMFBsUjY3?=
 =?utf-8?B?RFNlODVpbFB6KzRGR3BwNTZJSmtMM1gwcUVhM01zenpKbnplOUJmK2xsbkJ5?=
 =?utf-8?B?MG1pcFlKVG9Va0dweWlqYzNIdFVUMk1uMDhPNEFIREZEdWdudmFiU0RSVGdO?=
 =?utf-8?B?dWtxaUI1Q3VLZGNEZm8xU0piR3pRdnUzeHZVaTF1TU12cGJ1VDQ2YXFBenVx?=
 =?utf-8?B?RFhhZ0J1bXVRSG1nZ0JhRVJ4eWY5N24xTGYzdDEwanQ0aEVKRTBLbmFmZGM1?=
 =?utf-8?B?bFQ3Vjl5Q2I4dzE1Sk1MSlROUDRlcEZxRG5VeWx5M1dJWHppUjNKelY5MFZT?=
 =?utf-8?B?aGZHc3VRYzVWK2MwZVVwU01LaTZ3OG5qblNPWDcxeHpUUDh4amljdnhHYnpF?=
 =?utf-8?B?SzNpU1orRXFUM2tldW5GRnhOc0ozbFV1VmdOelZTa29Nc2xXNUZkeDI4NldZ?=
 =?utf-8?B?MWl0b2VISmtRNXZOV3dValBScHl2dGd0b3F5QzZaeVVDK3VkY0YwTC92c2pZ?=
 =?utf-8?B?SHl2ZjBmYUtkM1dsOHpYV2dZdWJ4Z1U1SFc3NG8vQmhzaWYyOEJtTm5hREw0?=
 =?utf-8?B?dHVtd0o4WDZtR1pXTFdCbWJESE1nM05zRU5Scy9KaGQ3WlBnbXJEMHU0QjFU?=
 =?utf-8?B?MlBHZkU2Y0VIRGx0Z1lmRXVQcS9Cd1Evc1hKaS9oVUZvWk0xRmRidFhJa25x?=
 =?utf-8?B?NzFRRE9nS00zeWYraTZPSFc0Sy9oZFdqNHpEbUN5TDhobUsyTE1MRlBoblpJ?=
 =?utf-8?B?SUtzTWhCSldrbG5vL1JHc3IwNlFaNjEvd2hKL2pFT09rRXBZMS9aK2RjNlFT?=
 =?utf-8?B?YTY4RHVNeFI5Mmgra0k2QkI5bTl3QmMwelJaRjhNU0cvQUJZTWhaaDU0QUg3?=
 =?utf-8?B?SzQvYUlhZ21wRWtRb0cyU1JZdkdyL2w2SGlDTUhkblhBUUxQS1RtMmtndmV0?=
 =?utf-8?B?V2R6aEk4OU96MmQra1J3cHVnSDRJNXVNdG1tbHRBVjdzcHFkSE80QWtPNWNU?=
 =?utf-8?B?c0RzeWN1TXpZOWxIeW5PeDRRVlY3bTVFSWtJbzhCZnoybUtYZCtDZGRzMTNs?=
 =?utf-8?B?bmFpZDMvOEhnS1J1RDVUUkhGNm5jMHhqS3ovWUcyTnNPUTlKWW1hRTFEYUF6?=
 =?utf-8?B?ZFYxQXJUM3ZRczFNRTVwVjBRMG5vSHg4clhuWHpSMjJJREplK1ViUlBUZUpE?=
 =?utf-8?B?VG9aeTNQNkNjL1pOVWNEWXFWWC9ZdG1JV3J4bXUzMnRPWTY2SUU3K004UVBk?=
 =?utf-8?B?djYyazlha1A2WSt0ckVtcmthM3BoZEFzKzhaS0hMUHhrNllvcUcrKzFCSXM5?=
 =?utf-8?B?ODZ1S1c2U25FYTZIOWdOMlBFQU5ZNU1BOURUWTZDZnhyNVV4R1ZUb2crMEFY?=
 =?utf-8?B?c3QzdzRZeWI4SkFHODYvRFdqQjRUdTlpM0xDYkZxbUNJOXZHMnUvcEtWMDdo?=
 =?utf-8?B?c1Z4eXBIMHZ1WUFPNmhobkNDQlNaak9qTUFoS1FoTzVvM290V3RPZHpFVUhz?=
 =?utf-8?B?azJWZUIxNkpZeHF4YVlyb3ZZMmp2NmlqQjJqTGFkVzhjdk1YbUdqaTVuUkY0?=
 =?utf-8?Q?p3fSZWqP/LYnXwww=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef617885-3396-423b-16ff-08df149c4eee
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:08.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WAa0KWHmKdDfBiGBkSYCwf1gMCzxHPfldhWyjm9kE2Sderq4af/t7TBkmFJPuG6c7ZKFa43ufeEb74U+C4zog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

The AMD Versal Gen 2 UFS platform driver carries local helpers to access
M-PHY control registers through the UniPro CREG interface.

Move these helpers into the common Synopsys DWC layer as
ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
duplication in DWC-based glue drivers and provides a single implementation
for future reuse.

Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
is no benefit in keeping them persistent.

Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
 drivers/ufs/host/ufshcd-dwc.c      | 69 ++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  2 +
 3 files changed, 88 insertions(+), 68 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 0d4d5e98ad65..c7da95999c85 100644
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
@@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 
 	for (lane = 0; lane < activelanes; lane++) {
 		time_left = TIMEOUT_MICROSEC;
-		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 		if (ret)
 			return ret;
 
@@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
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
 
@@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
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
index ccf785fce6cc..82b03b926e77 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -144,6 +144,75 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 }
 EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
 
+/**
+ * ufshcd_dwc_phy_reg_write - Write a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: value to write
+ *
+ * Write a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB),   (u8)val,         DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB),   (u8)(val >> 8),  DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
+					ARRAY_SIZE(phy_write_attrs));
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
+
+/**
+ * ufshcd_dwc_phy_reg_read - Read a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: pointer where the read value is stored
+ *
+ * Read a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+	u32 mib_val;
+	int ret;
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
+				       ARRAY_SIZE(phy_read_attrs));
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
 MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
 MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 0406f2bb576b..d8673cd54d4c 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -45,4 +45,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
 #endif /* End of Header */
-- 
2.43.0

