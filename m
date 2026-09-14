Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E31649E5E1;
	Mon, 14 Sep 2026 12:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390235; cv=fail; b=rAMDaCiDO8PTUmG8M1RVXSYyaEBJSibgKLj8Zphs1TztkCLosHIfwujuS8XyE4cW8NjI0Y2dE2ok3OOzg2I+hQlQh1jCETucqCzvAMz1ATKidyrCJXig4uQDJVA4nemIasLmQt+e3qAGzzwkfGwNRIzL7G2YyteQxjTtObm6Uuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390235; c=relaxed/simple;
	bh=pZ/RxeCSS+yGKCwyxaejW/gTmFqTnFiUah4zsBGqaK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gFlVPui+Zm6/q7Ux3B+NYtDnmh9CLyEWfqSb5VsdEPeuVHOOmF//YJdd3ZXTWGnGjfuMDvqUJOc8XNss/OW8A7clRNOCn+Ilqcq5Eqaa3QyBazL6tRKmUVLZY029AYdri+D4Bf1v7zcebSGtIwbmGhCXXGA21YYoxeYkkT7QMtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=P1h3YYEm; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="P1h3YYEm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sB9LhcBFNNxXGVlPaCVlgPFSJ6gBUWSzOymTOC+8SEYq4+j98txCh9Wzpx+g2PU5KcTS+T8I1iNMd3IaCS5No1kl1eKhQVIXQWPZ/xaajqcOvdB+AeknLVmncLpoyYAaLE0frZ1UZ16jz7wDCRq3ykjLBwkIG0pl/K31Wmw7S1PsppTE672DrC+oiePYXxRmcojTwCLzwj5A82d6rjxO34NMd8M5gM9OQgKmEJGnAPEokqGn9he7TmhLgn5J4AeKxwd1F1lS3/nF7/KVNHaCWxCdXYf74xQwgD50oj58nkMnyMqu3hz1UwrPgTG3vYtuoZuCYAl8SMuyMFsSjeRN/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNHOWLjM2NWYs2V7TInUeViamiQcPDXKCJjXViB/JNQ=;
 b=PPXMgLaiga5U9K78vLQy4re/zWxPC8v6PEAUmC9M0wDEiNioFuld1HC6sipld+Z3IA1ZTeRx2vGw+iOh1OzRjPifR8eIfsGrfwKiixg4heduTcj9GKxIzbaMzF1/CX/tjTSQ7t8xJX1QNvhH8muyzhv8fAbiX0f3UUjQlTJFYQnAfa32Xjn74JVH4JJwZWBEtGnFt0+Krqnc0oklU1EmixBHUz60zGhZdYllzrocCdqyabGaUdkL0bn39i6PRx9bA95ewX0QDIR5GtvGnby6x4efDlIZxAO76iBuP2AZdgEZFOa1KvqfIjER0pEFDRZExHnyroTvkF6Jt4808nKQyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNHOWLjM2NWYs2V7TInUeViamiQcPDXKCJjXViB/JNQ=;
 b=P1h3YYEm4fj59nGz5JPUKC99mkm84yVQhER6OyV3w4Gy9hjPyLulUuGQ3/VdVzuycamKkkmYEijL6gUZ5FCK/TYdHIuEKgQnxuGQdrwxpRrvoY7bZgYsXPhDilBZQL1jp3bAETcFnyV22+3R3UJOD17ElLPcu71avBWFghwC1URmTjPo8KAQCSCLQC2vETvfc1SoifKmv+V/36bZgdqAGfihEA8l8djvO0Skozi7S+5wKDEI+qWvkygqMWmT9YhYpqo+PZSNF+tZ0vjdYWgwHcHnF/w5yrbfcAM4pRhDITMgjCMhTFmhnkjP6PQIllpTBjK/4oEA2P7SkZyEiqf5Pg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7272.eurprd04.prod.outlook.com
 (2603:10a6:10:1ad::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:19 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:19 +0000
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
Subject: [PATCH v2 08/10] arm64: dts: freescale: s32n79: Add UFS host controller
Date: Mon, 14 Sep 2026 14:49:58 +0200
Message-ID: <20260914125000.30812-9-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0004.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::9) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 33c34194-8e8a-4e01-2323-08df125ebbca
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 YEbsEAEpRE7RNdNrignn/E+kZV8uDBRr7iVJX+8rDpssHVSPJ/lwHAygQt24g8dLMaW0dwEZqb4etse9SsLzagQtz9ryPMqOFvSq2pUYJANzy2R8aYhFPrMwzVBwh6U4xJuKk3QzxF8ZpKbF1hKC8/Eva6OON3UhqD7SsPUhBjjtWpA5r85ilf94jCFV3RDY6tOIgAq5RFSGW5B8b83gWFA+I8TZGtBv9MjNPoG7CqtV+sBYouOTQlOHVaSQCGuJ2OyzvRandiGG6aJtZxsZT/7EWsAMWNKWkN8hiYJs0ESrH1bGBdtbWlaQLnRfvHSYekBeyFz/MzuDsSP6ezLFtIzSZRmsxSJmGS4jd/Sa22rIPqV+CcLdHgKUWGm4din7/rSJr6JsaM9y5XVhx6eUV1tYmkqMZhsle2AHBxjLW8KC+QQzmrCoMu/CuQAUUXnDjpyq0IlAoBYwWk3k4ZZTStfQsYkdjCq/Z78J91wJet4q8evslvSmM6LCYnzBZhUm4FP2OA2ejkWi2RYqmdfuy8dQHnCWt8l4FGmViXLhAOZ8NgvKeAjbHsqmOVrMIGVDQS5kUzYYRCiq7vEQdw5J8uUZCBo6tyRRct9KeyGPMW18ZUuD2GaxELNbiyji3QoaTqhKdlilMe5nNp2F5aPNFVHmG+EUp2VFzFeNzJ2uqjUvhnHimCJQhHm+immsciPKWEOnGyMg8UMkKF6q7s4tdA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cmdoVGhLeEJxZk1tWDBnWjJDM3JKVnY3WHl3NDJGQ3ZHQW42UkVTT1NlMk1C?=
 =?utf-8?B?NkltL2h4Q1Q4VFp4Nkx6dkRsNnhQRXVGSUpBY2tDQjlhb0pLK2JpS282MVVs?=
 =?utf-8?B?QnU1MWpFQnI2eTBGeElvbS9DUXZCVEN4ZEUrMnY5cnBQbmhJNERBQ2JGTXZx?=
 =?utf-8?B?UW9WQVl1OFFlMUlrZnZQTnZNd1U2M1dqbmMxSGNLd1VWTitFNXBUUmN1SVBo?=
 =?utf-8?B?T00zQ2pPNndrV0k3d2Q1NjFiSzNSMHZ3YlY5MTZubVlndTdZUktzREVRWGk0?=
 =?utf-8?B?a2tUUkc5MkhYbTh2RFJxbmY5Wng2U09LSVBnNk1CNVJmQURiTW5uMURydzRt?=
 =?utf-8?B?U2JzZ08yNWVJYndlR0ZzWXZpYWF0UThweldYQmxMb3ZtQ01qRnN4aWlCZXdS?=
 =?utf-8?B?WGFkWXR2V0tscE1JYWNOVk5ZdmpLME82VHNTRG5DOUM4cTRBK25WS2NnQjJm?=
 =?utf-8?B?RmoxMUNPbjNIUDdzYjZRcFdIa1ZDQ3lZdlpQTUVlc0tPWjVUeEE0Y2hzMjN5?=
 =?utf-8?B?c1JhdkFrZlNBUDlNRWtWMThOK2VKbmk4UGQ5T09WM1djV3FZQkU3V29FN1dq?=
 =?utf-8?B?RTR5ZUMzczNGVUx4VUdiKzUwSGMybGh4TTZ5bE1vOXR5enBjNXpBelBBTTND?=
 =?utf-8?B?ckJSWWdicFB6dTRuQ3hSblVMTkYySEl1SGNuOFJUSmlXVTIwVlk3SllGOERV?=
 =?utf-8?B?RG5ZRXVXVEh1TWd3clQyN2hVZTE1Q3VQeFkvN0JXb200enI5SmhCUTA4cTVz?=
 =?utf-8?B?dXg0bkpmRDV0b0RSQjZnbjFsOHlHRjFhbWluRWdTZ1FYMUxDQmFicEZ6UG5Y?=
 =?utf-8?B?TVQrbUFnS1dKMjRaZldvbkRkcG5SQnFWcXZXa1l3QmJyOEgxUmthTlFkd2Q0?=
 =?utf-8?B?OENibEZUS2FYdW5XSWsvSTBlakNuNkpkL29ZSlhCbHpNTFA1cVNvV3ZnMitF?=
 =?utf-8?B?SllDb1QxT1dSUHBUMjF5L0dhT01QajErMC9IZElKd0M3anBiMzVwUDdQY0hm?=
 =?utf-8?B?eGtQUXR4T2ZJRW1MclBhTzlRL3p2Vjd3VmRNVXl2bXlieFowTzk4eVZMbG45?=
 =?utf-8?B?bmRRTFF3TWp2NEdWTTVIeVpmWm1yOTNUOFFwM3pLdUhvNFhYLy9vRzFKd3dm?=
 =?utf-8?B?NTFyMkhZbnNDcGxpOVhQTGdTSnVReXlpb2cvaEJBUkw4VEFBY3JyZ1VhcEpW?=
 =?utf-8?B?WmIwbDJBMHR1c3NUeGxYYUVoYVRvQXYydit6ZFV2bGRMYlBiNXR0SzIrVURN?=
 =?utf-8?B?OHJET1VoQW5aaDluVFMrNGNhU3RpYkh3L3Bpcy91V0ltMkRYemF3Q0syTUhz?=
 =?utf-8?B?UWZRRTlFSFZSRGFpTDFXZFE3a2w3WWZCbWI2bkZmd1ZsM0Z2WXYzNkJTMDZP?=
 =?utf-8?B?TzJvY0VJRkhVQzlVcVRoY3RLbTZERXlicmdBMDByb2lIQnYyVVZ0SVU3NUJa?=
 =?utf-8?B?RytzTExhWkNXTEwrNEdhUUt0Nis0SjJrS3JzekRTU3VGQ0I0MDM2bVl2bFk4?=
 =?utf-8?B?SFNONzl0SjV3ZmRzM2c5QkYxM2g1bFFrZDJFUVEvbzdYODdtQzJpL3hXVVlQ?=
 =?utf-8?B?aVVRY1pkazBnMjIzb1hsWFdTQ0FkcVozbXg2WGxhdHFFWVlyU1pxb3B6dncx?=
 =?utf-8?B?Nzl0dzdTOTVvQzhLZndBN3FBczFuSVRhQi9PVXQzNWN3dDNQeWpZc2pXY1Fw?=
 =?utf-8?B?WUFvRGZrQVp5bnRoY1B0ZDdmeUVmOUtqZ0xqVTNGTEtyd1FyREsrTXZhNDJW?=
 =?utf-8?B?TEVaMm9FZHhFR040SGpDSWZ5YXo0ZTkwUkFiUkZiU0h4SFozeDFPU0ZhODRo?=
 =?utf-8?B?SXBRMEdudkZnaVl4MTFCL2hxZ3I2OVRTdDRmdk9WWWhOZkFUMmx0VjRtTGg5?=
 =?utf-8?B?dGw3ZEpKN2xHeEJTbU9YdERza1Iyb0RtRXByVVVSRXo4anZHQlNHK2tlYTRB?=
 =?utf-8?B?KzZpZXJic3VCUGlPTDdzeVRNczFxU3E4aE96TVpFbmJsODlucmEzb2NHcmNy?=
 =?utf-8?B?RVBMZnlKdk83ZUxoYUthOGVxaGJHT1VJNzF3aEFDOTd3a3g0SXRyOXpUWmph?=
 =?utf-8?B?NFNmbzBDZDF0S0JKb05PSk5mZ2dNZDVpMFAzbjVhRWZFWXo5a1BVTlRMbTZB?=
 =?utf-8?B?eXJ0Y0dlcTEwN2NoTnRwWnE1aTZLSkNnOUJhenhzSGRNdlN6cVUvaUcvSVRu?=
 =?utf-8?B?UnBIVHhvdFhSbElvcDJFNjUvdSsrQmtEckZpbjd0eGo3bHZTVXBDcHlmd1Bo?=
 =?utf-8?B?R29lVUo0RlF2eUJsR3Ird2pWTTRJRXc3ZEo0SXVyZlliMWs3NFQwWWNkNkRo?=
 =?utf-8?B?WXFJMTRsME03QnNyczEybkNSM2pSU0gzL2ZOSEdTOUZDMHFrR3hDQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c34194-8e8a-4e01-2323-08df125ebbca
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:19.7786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZTDYenirrODOaijsFoJRj2oLnA8YQjilOfcvcPa0iOwxmrIf3UrY1HB3q/KljS2PKApcgE9z+1Hy+/kDDRViw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7272

Add the S32N79 UFS host controller node to the SoC dtsi.
The controller remains disabled by default and is enabled by board dts
files as needed.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79.dtsi b/arch/arm64/boot/dts/freescale/s32n79.dtsi
index 94ab58783fdc..0b51ca8bc7f9 100644
--- a/arch/arm64/boot/dts/freescale/s32n79.dtsi
+++ b/arch/arm64/boot/dts/freescale/s32n79.dtsi
@@ -100,6 +100,16 @@ uart7: serial@4aa40000 {
 			status = "disabled";
 		};
 
+		ufshc: ufs@4ac80000 {
+			compatible = "nxp,s32n79-ufshc", "jedec,ufs-2.0";
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

