Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011033.outbound.protection.outlook.com [52.101.65.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A84A4AAC73;
	Fri, 25 Sep 2026 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346997; cv=fail; b=Cv7XZ2e8DDGLPx6WPSKifnWt7FmSw7UtVZTJ1nF1sVWlqpnZ/ApG7xAtX2Scxs1xUDV0EqPWWFOE6BSiRDL9WSpQZ7lCf6gj9Pevio1NhaZU8W5Gpqrz0tsLA4ZIqhIHi7Q0lGdaDU7mLrV9rVilp78FmwW6Ij+H6gZU9VS7FEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346997; c=relaxed/simple;
	bh=tK6CG3Hg6D2uTLW+1yMejrs7AGjyWteHTo1EXzzKguA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pKRB+kZkspFggXOCPXdLWwFlQjSjTicKKuGXc2IZK9AWQwbEwgEWOpCwBVErbVNNcDw1F3SVPDc3+KB1xi2yMrwwVlgrc0pgculvFWFHbDv30SVspHg4i7MCKrPizqH8DxQPV7XFwpYHWef4cPggDH4ihtPTK5H6Nx43ifrdr6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Mojd8xba; arc=fail smtp.client-ip=52.101.65.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Mojd8xba"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mujcrRtRWAUnkegAR0DhhS4bZ+mHAe7mwBchhTDXoBq5/PFbSbJp9X/8B/Z8wai7vc+DaZDyGeBMP4lvFPPBqpvbceFHdD5ry1HblhlTT/2H2zw4M3FhE/sVGeAplTIvIAVHET2ElhVcAe8Xxm1EYACn+sHL/0yr8OSW2zytp/8sLeJPkrcoKaP3WAZ/5JVcI3KAFgFD+H6NI6if6mlItDXcK8uLxm6FSoU4EKimDwuAOpW9toprJDBm7ih1ajldobVIG2cuu+7YDihJrohqBziuTx744TgUD18ZQxWIUDy8xTGiomiL9QHewK027QyW50F2C1yxLWUxxmWyBk/Eyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mt4MM2b+kEda7XeWiXcjklx11vtEoBsUUQ1dFr4um50=;
 b=UU2jHnTI2ixVfy3pNqT6g55h5qIFB0PRw5ozVVwXU1PmLWLm5fthyK7uNk857fYoOPiw6Ok6CaaEVVhjRB1mVy//tyUcoFMECPpo1OfUNMFksQRNysQvLkNjGb2ds1KbAczBOYsq44n/HFes2mpXa+js1fpZOAQbZRe+IGH7Zbut8K2PNfetVIZx5kXF31wfiw2j9ESxjrhEP//emYBrWQ7h/XS1VpyZucMOOqupDFaGmB8/MX2ZsiwY39z8CrlIoBqeJIJOKSfHemlI8ccpMtuWa9dpBh7VxGAFHltJDhGvO+g3R6v51s4Fv5/b8AUhYbA0DVBlD2SgoEQw6cc4dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mt4MM2b+kEda7XeWiXcjklx11vtEoBsUUQ1dFr4um50=;
 b=Mojd8xbaobl9XLNZdo4/GtnsL6kMzMAuvFVwTJgcvmDClMcKxXEM3KrCD2o9lE4vxhnQWQhV2voi6riQdsuAvzumStuUOQIYrdCrs/cIBcJ6AURH1HI4HpHVh7ZK0XrAgX2fCwbnAX/tJSN3f9LqW82gssqNqxeEpQePHQV4tDgaFYSqvgH5C9fcVE9GA0gUHF3VEjzGuP7FSSTFGdQxsBCSL+hNkruK28Dnjt+AXwCQSOG2MrTxklOZ1BK1BojSPtIEH0940li69oiXya0T3hYk/2arabM3c58VJwyTLpPltY2pAvuZYaVMm3+TiYrefsXpbwnatwWI8omgS+nTAQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7256.eurprd04.prod.outlook.com
 (2603:10a6:10:1a3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:35:47 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:35:46 +0000
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
Subject: [PATCH v6 01/12] scsi: ufs: dwc: Return a negative error if the link is down
Date: Fri, 25 Sep 2026 16:35:23 +0200
Message-ID: <20260925143534.3298540-2-larisa.grigore@oss.nxp.com>
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DBAPR04MB7256:EE_
X-MS-Office365-Filtering-Correlation-Id: f9fb9754-7d18-4922-f5ef-08df1b12499c
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|23010399003|7416014|376014|10067099003|56012099006|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
 07URJUbjN3uHE1ktLrNBw9M9u4mQLB8nBhAUYeX2VBW4hl5Jvrg1LLbRWT7YhWI2mYqdOXBS8/EmODfcjHPJk5RzUFiZlV3ucxH0OPVdDcUSky8NGtj2e4U8b/9uOrlDco73P0RyqHCsPj+6Xq0oWKxJmggfgMMJfwdJu/Psr/aixZUv9NDUTZtxYmtr1VDb/nv8mbmEYpT3rMKP9vsYbqCitBWbEn4urnIuWqySSOQJLlZcDom0Bl6wbYppqfyGm5XXgARSXmCxd8WK27hPaMlJK+tCmGQV0biZVH+fk8WHl26NXbHdBgylOHi6DThRKNCWMj+iK9QzDi8O7Lxb0Uq5o9Jc68Jnwqi45OLvc3qbX94b/CZK8x2Bv/0AtdXTMIMfQPPQC/S0diP4qTC9TuSzRBezpllQvCIa2IIjUIE5KeNmuQ58RBhZW4c6uy7NQuEyiQHV4T85UhgWMepFeVSiUKyJVTvpTUSjWbPKmXGy6IVJ5G/sZ0o93MPPa+3tQmmBXhBWCQ+dvwozPpmz2KZiuUPIr3eP+wgIp1WEV7M7I9P+WQ6k1sqq+vxZKnfORb9YXqL5vL3GCGno9Z6s3y5710z0X0wVSESjeU0799nU3yUTncthOU3HSZTRc5Cy4LubLqie3c5M13oJBKIkfnpgrkxt1FbuiThAt5w5bzcltDvbWjio+098kGzM7lFxoHusiB6bzazHNkdLH8BdVw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(23010399003)(7416014)(376014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bzZNMEhtM1BpL2Iwb1p1Z0M4N2kwdDd6OVloS1hySVhCd3pURkN3L2dVOWlO?=
 =?utf-8?B?MWViTzcyYVp1bVN5SHE1SVM5WkhKaGUvekdTOUVneVhuMUVpQUpDL3ZNbU5o?=
 =?utf-8?B?Q1pqMFVwNzlSUjRhcENEeXZBT2grOHNDTVM0TnhaOVkvOWN4SDlDZ3RoQ2E0?=
 =?utf-8?B?cmNkVkN4WlUwOC9UQW5YRzRYQXRmKytodElMdTN3ejV2K2hxWjFaTUo3bUlS?=
 =?utf-8?B?ektlZVp1QU5OSlZJZjFWSEhVWUZhMlBIMWZMb2hmS1RsTk1PSkhSWlRRSG13?=
 =?utf-8?B?TjRpblpTcllFVFRnY0ZoZ1N6MGc0SVpWbFczMGVlSWI4QlJSWlZzM0ZBNytT?=
 =?utf-8?B?VkxFeVZrN0NiYnI5OXFmd215TXlYaHFCVVlkalBEVjQxQjRPQVpqa0RnK3ox?=
 =?utf-8?B?VUtvb2Vpb0NYZDNITHZOck8wUEQ5ZktlTmQreUJWVm9nN2FpWkJxL2k0aHc1?=
 =?utf-8?B?OUxOUUxVWWtnWEdIT25SK2cvK2dRMEoxZFhLNnNUZ2Q3d0RZcmZoTkV3Znhn?=
 =?utf-8?B?WmFsWXJrcnJnaStBdHEwU2FTN2ZOdnNpMFdqb1ZoRnhoYUhuNUt0ZFFLOUsw?=
 =?utf-8?B?eUhRajlFenNSWHhtQ2dVL01QeGVzTmhRVTNZdUtqb09WMFlYbVg5UldnU00r?=
 =?utf-8?B?MCtobm8zbGNrNVlQRjFJY3A5RS9VbHdkTnhZVDYzTXUzZXR3M0NZU1RMdjNG?=
 =?utf-8?B?bXlhR0Z1QmtIMmhJVnF3MHlCU29pZDhmOEFta2N6bHdjMUNGYTk3a2dGaGxX?=
 =?utf-8?B?L1JZWUNCQkpJazJlL05PYXp1b3V1czJFdit3Wi9KSmUwZ3NzNEgvZDNXbEZO?=
 =?utf-8?B?cVFTVXJYTFRWcTExN3BhU0w3WWg4c2twREZTT2N6Wm5SbDFPak9PdGFNV0JX?=
 =?utf-8?B?Sk1acXpqa1FsVStJc21Hd3hnTXRsZlI0bkNrdmdJamg5TE5kYTlqcHR1QWJT?=
 =?utf-8?B?R21DK1ZqK3FPWlFuQWJXK3l3TzE4Z25TT29SWHB5RG5PQnFSZ0JHbEdsOWpX?=
 =?utf-8?B?MUlkUWsybDRPc3RlRlBRbTNxZklmRStQS3NyOXlFWk4vczZFQW1xS2x5UVlP?=
 =?utf-8?B?RDN0c2VQNEVPL3YwTW9IZXI0a2Yrdmxvd1I0MVlOU3hJMHhhMFk5YkcydzFj?=
 =?utf-8?B?bUc5cTBNMndOT0tvVVVWMStROHZ6S0NKM2gyWTYvVDRFMFprSXhEbjZpUnpQ?=
 =?utf-8?B?emJCS0xXZlByQkFnTmdzUFNYNFRqNEpyclpCbnQrSWJNTlZ4V2NubTJsTWo2?=
 =?utf-8?B?cnFoNi9vM0l1RytwbTNPaXhsd3RmZldYRzFJVXJRZmdMRkpCUWJHdlozdGNz?=
 =?utf-8?B?VXdZQytXa1lRT2xLSzdBK2t4ZHdGZTlCMC9mK1IwMjA2dWFqNFlrTXJqejAx?=
 =?utf-8?B?eWJkTmNTaGE3YUtLUDVBL2JlMk5TeEtQV1RoYTQxMG1kM0Vzdi9TL3lVOFBn?=
 =?utf-8?B?b29VNUgwR1VrQ1hYUnU1Q1pUVHRUOC85SSt2SGNnQXcwb285dGZHNFZHdzZo?=
 =?utf-8?B?YnNKMVBLODVlM1FjSkVrazVKNzdTbWZJbjk1RUdwYWxUYnp0djFQR0NLMHM2?=
 =?utf-8?B?dkRYQ1hEZmxOUE9rVjhOdzdGdk5QSjlqS3h6UVNRS0l5TmVPK0dkZk1ZT1Q3?=
 =?utf-8?B?TWx5RG1LNHZZbjF5SDZobGdvam8xYjZvUEl2UjRDNWFpTUxSTXlUbU93Qnd4?=
 =?utf-8?B?c1VSTGlmZElIUFJ5bjNNY3lTWGV0eWZnNEZuUFp3MnFoelI4MlIyQ3Q5UG9q?=
 =?utf-8?B?Ky9SVHlFUkpaaVZqWkhMcDdVRHVaYzNSQmhwNXBWb3V0VEFxaUhSR2p0OHI5?=
 =?utf-8?B?WllPNWZpRVNiTDBURjNuT1ZCMkY0U2FBR1JEcXJIR2NjWFp1SUN6U2l6TWRW?=
 =?utf-8?B?blJ3eDJyVGhCOHNSVjQySUh6dTBsV09OR1VXM2d6a2JqUlVHdlhmSUhiSXRm?=
 =?utf-8?B?a1lKMGxPOUNPRmhLQ1lOaFZKYjBRMVlwYWErTGpyZ3VZRXY1MXhJUmxjck9O?=
 =?utf-8?B?MlE0Mk14RzE2cjFJbTVKbHVKZWhjbWdValdnTXJEcDFrUVZ6dzhsSjRjV0Rs?=
 =?utf-8?B?YWQ5UUxHN2lvUU51YkdyRWVUZ1hyVWh1b2gzSDRVYjVoVGdlNmNQMTBkcjhv?=
 =?utf-8?B?WTUwTmlRQ0J0djg5YjJsVTc4ZkdMWmpGTjBNdFRvT2R3bVpFdHBDUUw5QWtV?=
 =?utf-8?B?Vm1OcnJHZk5VNUcrWi9ZUjk3OUdEYVZrTXBZbUVBV3ErcUNkczJGNm0wREpp?=
 =?utf-8?B?Z1dKT3FBUjBIcGlIV0lCUy9oQ0NKaFA4Mmo2c3VndXFudTd2dHJsdE9ieGdn?=
 =?utf-8?B?ODUzUWVBa0czU3QyTzkwZ24xcHM5b0lXVnRkb1MvdFJJV3BKa0VrQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fb9754-7d18-4922-f5ef-08df1b12499c
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:35:46.9159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEQEgj10SLpKJiRv6i7Z4ffa1psxykkSM8DShahXBtR0k8TLC3xt41ufGq3TDeSugMEVCwL5eywCa1BVk2AGzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7256

ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up. The
value may propagate through callers that expect failures to be reported as
negative errno values.

Return -ENOLINK when the link is down, and report a failed
ufshcd_dme_get() as a negative errno instead of its positive UIC result.
Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

Fixes: 4b9ffb5a353b ("ufs: add support for DesignWare Controller")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..71433b4d04aa 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  * ufshcd_dwc_link_is_up() - check if link is up.
  * @hba: private structure pointer
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success, a negative errno value on failure.
  */
 static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
-	int dme_result = 0;
+	u32 dme_result = 0;
+	int ret;
 
-	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	if (ret)
+		return ret > 0 ? -EIO : ret;
 
 	if (dme_result == UFSHCD_LINK_IS_UP) {
 		ufshcd_set_link_active(hba);
 		return 0;
 	}
 
-	return 1;
+	return -ENOLINK;
 }
 
 /**
-- 
2.43.0

