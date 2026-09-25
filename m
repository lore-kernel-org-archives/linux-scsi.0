Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013052.outbound.protection.outlook.com [40.107.162.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF8A4B1D1D;
	Fri, 25 Sep 2026 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347036; cv=fail; b=aur/ercv7FG+2Hxi/6or571saWxzJ7ZkdcYRaBdt/gPHpB7KFJvXI9MqLmLjcLCd8W4DDO2pK2cryijfyzogmJ296fL2DMYCPXPjshzAi7TFyjzpa0OKYfAOrMOnchTEr3m9OXj9PULh11QiPLDDiW+nVbngqUAzmyqoHda19sQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347036; c=relaxed/simple;
	bh=4xkBl3OG8MRo6BkfecIQ4TfHdFzHjKdQZlBCV4k1foc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MK04OJT4eDDvph1/R1MVRisH1MTdlwaHXT5KzdObF93H2rpobtt38c0Uv5eRJaZ2+g6BhGOYY8MdfPQlH4Lp/rzrTFALiybDOI6k/CEfjw0ma7pyu4fV3YrrbaViVmMC4FWN4v8DzobcsCxAo0uz/eh8LF0iWTztaoKle60t2yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Y1sKzz3d; arc=fail smtp.client-ip=40.107.162.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Y1sKzz3d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjCN8nxYxsYIdkmP4Kiqz8pEdjgT3e0DTJ1yTsPDxboW4ythlTQeJqWUodmV9qKIztOuvqrebqJFBifnzOe0htGTnF6NSa1PLan+S06iebPNHlGqjl8O3zTo9HWvJrnA6QKufBr5e+SGG29cCDgqZShounlEnL1eaA99Aos9DkbkULQNpeN5EOnKp9E9BHfxb0QriCMuB8JBEGB1vszhaHAnKy+XYeAQzzmlllahKYwsErAoIV2Kh0EWznNTEN1PutNPAgHYRrz/Y+2IT83oyVAmnY6q6JcncGDjbAQk6rvHup77HlPkcDyXdOXEV3s41bO1RFoH5UsjfAL+MWLAPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqxCE2d5GztTR3HjBlRXysS6u8eaq1wh4DF+uFgkQhQ=;
 b=SbB18hm840WP+JA9ZKQBUmFpeC3mG4PecnkLfFnFZ3/sAcNrixYMvyhZJu0A3JAAYMOIMBdF6obMD0M1EzFt1BCGZjtsHwesHb4T/5UB4gl5BXWV7e1qVH0CQkmiKrKFZQOwGjIZH9UKJHc5elYYUsZ07oo0Wp3udS9cp6X7gSPLnFJB2NvKNTEnnEkPOiwgOBTCPNxkeLLhTWca6Jc7HGAz89SssRD02t7nXrDDHUfecRK6mpxAbt0C5MMhBy/gU+fXiegwY5NHPCaOBtQHa9Cm/qzwFL+E2tN2rPM/DseCugYhhFPNGFb0Z6Ev13no68bY3IeBm9/gGjACWs7HXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqxCE2d5GztTR3HjBlRXysS6u8eaq1wh4DF+uFgkQhQ=;
 b=Y1sKzz3dkB1icdUuyPpTkPqrifWq4CetUhBJNGLqL9PZbjTnX1AM3RA65r/joxZf/eP+jNjAeDYHE/hWqSvsblbCQfXnI6S9ocXKpphZcEH5J6rsK5MxvdXH4qCIgecwJXy6pTIad9U8sX2V4yvk+C5b9JKruiuK2GmKKuddnEmMV+uxFvAjKZ95M4lBWMR4wpQukJNKQuhjesHfnKyCE9WA1RnEUVh2vSN4hkcZThWTX7/gnAhEPfRL+U2hDDUANAhKKK272SSUGjiE3UyS81t5KJJFxryIMOpRMSvxLxfSmREK+gLb9DGRkV2KB8ORSmDT0ZY+/dukP22OyRi+zg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by BR2PR04MB800621.eurprd04.prod.outlook.com
 (2603:10a6:2c8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:36:04 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:36:03 +0000
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
Subject: [PATCH v6 10/12] arm64: dts: freescale: s32n79: Add UFS host controller
Date: Fri, 25 Sep 2026 16:35:32 +0200
Message-ID: <20260925143534.3298540-11-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::16) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: ecff4ce5-ecdd-4598-9b73-08df1b1253bf
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|19092799006|10067099003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 kY8wnRYBFXMp7egjk4f/RlKcxwlBYaoPvpctwSK11hq8S8zvQjDTC0kyxC4VeNdzJwloJBW+VSf6KODQ/DSrTj2/6n0OEDd/6BaJINIoajfn/chgnY4OCSKkOxpmDh1IaqHcs/ySJnNCmQkpE9ZYSOtsWc8aEkBSepOedHBoMvmvvJ7ELzVyy4m5hpReYHmRK24wYwp0xJohLcWmsskiNCPovfRYacQ9PmCmWvKaYzWVWzxknnFjOoJ/qeUScQtenX9JZfEi6m5gsiKhmdcLoP6TdgtCN4OFI3cpXOs/2IeQg9VNd37302VuobNvVDHC1Z36l5A/uvbh1M9eBZB7ru9sfjQfaT5mQYhza0YGCnW3zCdlq2xUH4Q3iKya1nLK8z0W/yQbu5XdqKw4+h4PIFaNG5pCRc6KfmKPMfcy8Gw9CBPNEjhlfYMYpZkRw/uTgtAd1xFseIvjjcz8kwCocmIOt5HL6Vi1IM8MC22PATqbtxKJySd/DoJPzcVlZH5vFsHUsLfDUFhQ+ku6nNENP6ZGYYTmKxDV+xu8yqd66BB83xDRZ1W8AQoAkefgN9ScLy/Q7j26RKaHGNkNDL704PjxOknuh7HH8yqYnOcVvv8VDYf/OjQNOJAkJmkgmD5+PnOjF2FLCybqxw3pc1KWTBGuN4HyoTXxU0HOvGLktAwUDRfhglpBQkT/Wor8hK+BmKdqxhiqImTNFx8KcApTkw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(19092799006)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UWNDRjFlanY5K0NSVFN6YXpxWkVIMFZiazRtaytBU1lNRGlnamJuUkw5TnBC?=
 =?utf-8?B?NnJ1Sld5VStnMWNJaVRUVTlTTGRhRHJCN2RDcTBOOU1TL0o1TWo1KytwdGhz?=
 =?utf-8?B?cm1nZi80RDkycHNLekIreW5PVlZSVVdJcGtIdXBobERsL0c2bU85MXNxSkEy?=
 =?utf-8?B?TVVYYWtDNVo2SnhUS1h3djRoTktPV0FWRitpbXRxOXVzTjNleC84c0dzVzli?=
 =?utf-8?B?UmhkNXh3S2xuZDVmL3hlOXhTYWNJaWxFdThGL0xndVd0dE14V2t5QkJTankr?=
 =?utf-8?B?REgyWklQbGpmeVhyYmVWY1NuZmd0WkVjSGtQc01SV2JLQ056bG5XVTJ2ak1J?=
 =?utf-8?B?WjFpbU9nbUdZY2xRSCttUWFmVkloenVET1ZqT2FnVFcyamlhNTNqVk02WTVS?=
 =?utf-8?B?RnFRQmJIRW1wWXlRa1duZzk2UnVjUWlZOHFpdTdSRmhxMU91MlpKaUtGam16?=
 =?utf-8?B?dkZXYUFWMjlya25kZW1LMmdhZ1Y1MnlJeS9FUTF1cUExMjNmTEJBb3pxNGJU?=
 =?utf-8?B?enlNdGt1WG5yUGF0NENkNzdZVXlwUzBLUTU1aGEvSTFPYUFCVFMydFVGR1VJ?=
 =?utf-8?B?bHpadW9XYnZLVW5tc2FBNW8vMnJZaXladHV6N0ZHMWJWYk1XLzFiQ3dYdWFQ?=
 =?utf-8?B?QTJmdUFFeGVRcEdMQldxNEo0ZXUzQ2IyQ0NsTTA0MEJDZHNmdzdYK2dEWnln?=
 =?utf-8?B?MkZvbENBQy9aek5naThlY3hKYXZ2S2RuK0NWeWRISk1iaDJjTnVCMC9YOHBs?=
 =?utf-8?B?ekxiYWFNNHNxOEU3MHo5WVZSMlVmWEtHbGEvMWlDMEpybkdLSXdHanpkdEpi?=
 =?utf-8?B?bVpNRUFRT3dRNmRLTFc2SzY1R2h4a1o1Mi9ScjJlQXphYkhoQW1YVEtrL2Jo?=
 =?utf-8?B?Vm9SNHE1LzJ2WFNDS3JybjZwQ1VLblRXSWJpekJDenA2OElmeEwwV3hCMVRS?=
 =?utf-8?B?MDFzUmllYVpkbS9wY2VMTCtoYmozVHJ4c3NqWlhVa202dGdmT3pzaTgycVJE?=
 =?utf-8?B?bmdsRnUxRDFuWjhJT0V5dm5xMVFyL3ppa3dBdDVWRDJtUFlKV1pLMmlocGdX?=
 =?utf-8?B?MUlBRVhxdGtMS1Q4QWhKanh1a1Yydk91azN2MzVTWVE0am5WdFlVTXQxenB4?=
 =?utf-8?B?OFZkNlNIV3ZSclI2Y0I3MGQxdHNINHJ3SWRFNjkzdVBNVy9qNVhleTljN0Jo?=
 =?utf-8?B?UE9FZ2FvU2VOSHNQamtuTW9mQ0ZoVll1cm5IWjRNY2FXZkltdWtOUGF3VTcy?=
 =?utf-8?B?eW1vZ0FacVc4KzFIZ2dhQkJMby9kakJBOUsxQWNMZ1REK1lwWjJLUzE4cmox?=
 =?utf-8?B?bjBJZ1ptanJaem5SVHBjTzhrQTh1MkcybU8wTWV3QVBEVHNIZVY3aFI4d2NO?=
 =?utf-8?B?RFY2YVBTUnBMMytBSFNiRHZmcmNnMW10SHZ3NXBDSXJ2ZjlIYzMyQW9jOHhp?=
 =?utf-8?B?QUlVaFhENWIzVzIzRFZxVXpmWWw0dmtweUt4cVRDR3dmdCtMaHNKNjg0cHNZ?=
 =?utf-8?B?TXZyZGtUSnNPSmtQL0dFZmRoSER2ajZkUWthaWxnM09Ub05jVUgzMSt6c2RC?=
 =?utf-8?B?MlRLeHpGckx0a2lzQjBPbGZkV0s0K2s5RnFJdHhiSHJVMjlSZFVqMVR6c1Fn?=
 =?utf-8?B?ZHB6TkR3SjlIWHg3RHBGbFF4S1psbHB6MWdoSHZCb2o4d1hkZjhHaHFBeTZm?=
 =?utf-8?B?NWhUSTkxaXVnRlZQdTIwUkYrYlBmcWtYeTVZZ2t4YThPdXBPVzUvS3NaQ1RO?=
 =?utf-8?B?eWZ6dmRDOThNeWJBNTJSYWZCT0JWWjI4WFlzZVpsejJpN2FWa25wRmV6MG5O?=
 =?utf-8?B?K0t6SUR2ZjhYdEpnOHhnUmFtTTQ2K2pBMmZ2Tlc5ck9UL05OY0tob3NFZUFy?=
 =?utf-8?B?NFF6RGh1d1ZTY1hMM2VTcWFVbmdOWFlLR3V0QkJFSDVhZ0dTV3RrbWpYU2lG?=
 =?utf-8?B?emhMbnlZWHpVZjJZVmtGUHdLU3hhL09ZVHhTZ2ZKYzFPL3dzaDhDblV2SnVB?=
 =?utf-8?B?MDREWHJTU3FnVnpHeU9zN0hSZlNua2hsRXhyQnJlcm9vK2tpbmlsR2tqU3Vo?=
 =?utf-8?B?VDVpL2R2RFkwWElydUEwU211YWRMTkhzOUNJQmo5UUk2ditUSUVieHVkVFdk?=
 =?utf-8?B?U0dpdi83d2FiWEcwUTN1Wm05UGtmTGZNZm05OEtNQk5KTDVjRzJhdEVvWEdu?=
 =?utf-8?B?NkVUbjdET3gzUkZ6VFBVdDE5akZqS29hVnNiY2hhNnMwbnh2UUJ1UzBVYVh3?=
 =?utf-8?B?L2FDeDNodStsZHlub3NybzN4Y1ZHWVhLeW84a2M1R0taNnpDa0doRlBKRDhm?=
 =?utf-8?B?KzNjKytJd2VhMDg4ZXYyaTI0ME5Gd2wyRmJLVElySnFYNHJQVXduQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecff4ce5-ecdd-4598-9b73-08df1b1253bf
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:36:03.9115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PpRivSaLNBZcYKZd2kDPw2PG2fUMzXdRDbxqNB/I7ClE6PfDtVj9Aa8hQaSktjrMoRqnYDZRJ6YqjGUnfkKzKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR2PR04MB800621

Add the S32N79 UFS host controller node to the SoC dtsi.
The controller remains disabled by default and is enabled by board dts
files as needed.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79.dtsi b/arch/arm64/boot/dts/freescale/s32n79.dtsi
index 94ab58783fdc..9f64a7acc3f8 100644
--- a/arch/arm64/boot/dts/freescale/s32n79.dtsi
+++ b/arch/arm64/boot/dts/freescale/s32n79.dtsi
@@ -100,6 +100,16 @@ uart7: serial@4aa40000 {
 			status = "disabled";
 		};
 
+		ufshc: ufs@4ac80000 {
+			compatible = "nxp,s32n79-ufshc";
+			reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+			reg-names = "ufshc", "scm";
+			interrupt-parent = <&irqsteer_coss>;
+			interrupts = <211>;
+			clocks = <&clks 0x92>;
+			status = "disabled";
+		};
+
 		irqsteer_coss: interrupt-controller@4ed00000 {
 			compatible = "nxp,s32n79-irqsteer";
 			reg = <0x4ed00000 0x10000>;
-- 
2.43.0

