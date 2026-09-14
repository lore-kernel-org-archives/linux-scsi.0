Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7680B4A0131;
	Mon, 14 Sep 2026 12:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390239; cv=fail; b=ST2nJCLIrxAHak8IDWxWJIVULRLakJhOoOk9AJ3N37xXHEJu68ClO2aT3ci4cpF5CIHZ0USknGrvxkMzvEn3lGIY3KxELc5S7/y6ApTq5vcEd5W8ZACCujFgxyBUXAHXrqdvRr1im1A+L5HpFdGABLwzg9S0VRqcjvKpdS8YTzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390239; c=relaxed/simple;
	bh=SlPckDvgmCgHI3K96wXmE3PZMKP1GnJCHi/dHGpHhM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YzfT++Td4oU2ijBST/To4p5e/geLQYZGShwhfTZQdbiVHXlbPklkXqcz1wg4eM8EittHwfyzP7cw6pE7ZIVlVr0U4b0fd5GYVWQtMyMtkfWkHQicWmngZ73GvAruKf8htgeom1BIWtWRVVgZ6GqTtm9nzbLCGFrz4GLzNfhfPUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ssJzEZlU; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ssJzEZlU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CDfqKaj4tlHXXh4CPN4FHxOqQjo0F0tiYedKS3V41VcvML+LqBcFutnaHRWhhwM6C7G3PqxuxxhUz0PDPkdw9Tl7IpRhIEyzBJsClxGUsnakqzWp3fZTbT6pqEvG+uTI5XPDASrltFo4UtLnq6iYn0Vt+rFsVJ3d48CYQL4lZMI+ttD0w8B5jVr+/QCcMlFAJxmfwLki9Fn/GvO3YUkSrl3HaWOzkayxNAMIO7cjmkJ8vmg8RV1X9lWh6rbnuXXK9RKDPC3OWMhqv6mXs/GjL1vNXLHT4GqsC7wAwmKFe+ihsC9PcnHt4mCIYygQ/iirS8xR+YfCmxaDU2AiHI6/Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=n/2OF/ZZZob0faXBwNDnwVWxKPd/lUJfd6Fqg7OfDNv5JUap/rSqHbTrzGe3sOFjcipmTo3ZwXbb/XJE8OzE2UfLWokN9IB2MeUTwa1SppTNilPTqWXD275cGnEdTmYMcW56Z0LVB6GfJgPL65/hmDP5/D+K3HdznNmsdxC8L4PcTT8HbGOtOn/5HCIaDg26BsIaUfnGoj29YVxrLuNrDAUdLYQtbzr7c77mTJ5rcQRcMY7agX4XaSQtCA/XuoaY5JukOWodVyyI/+/L7TBz7vZw3DV26INZfGCIIredCqtypJvXuiJRgxbpfHNZnc8rJCSMsqPJM2IlUmnpEytX6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=ssJzEZlUoU+SdbjOJCkGwLrZA3aLwkSmIFyER7uNg/xp5u/nwTfM1g3Au8w67tlpHGWA3zlVspL4wboE9fNesEUKOigKU+oqpJLDnWdQOiWF3ZVrhUJUmj1BJAFn1ONobfVvqL8XFmyAuetzIJvu+uXttcMC+yIwTe6+1rOBv8NiL74czFsVFe5PschuOXJirTjVmN1FtPdyVrqm3d424nuoHs4U+AdCZ/usu6PJb5a1z/zGWU/qKFw2tYrrlNmm1tdFOmSMQ/3HLvHgnaRY64sAc2glLOkMGOkf54vY0t+Ov/ktpQhr1axKPMVJCUUe5P4kMbWvHJcVTNxgUBe6mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DBAPR04MB7272.eurprd04.prod.outlook.com
 (2603:10a6:10:1ad::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:21 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:21 +0000
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
Subject: [PATCH v2 09/10] arm64: dts: freescale: s32n79-rdb: Enable UFS
Date: Mon, 14 Sep 2026 14:49:59 +0200
Message-ID: <20260914125000.30812-10-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::31) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 571357d2-e545-4b02-5033-08df125ebcde
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 I+dCADIBob7AlIFE+Qfl474Otuxx62gcwqscUYhUAKkzWW0/DM8CGMh1pe6OffOjAlIdwV3zHqodDQGl8sUDnw19uChlats1off4jyr4mm/aVo2FkUBnDjtJd/zpxWWh3fuoCbStNBUigsX7jrT0uVNoxmP/090lFyUxkTQ+VQbDxEjkYlyxb3JVZfI6hkNVSvq+RVOhc9/1Sjsz+6tEEeXonSCKIHsZlhb49Ubejq5km5oR7zi8a845YJcg9LerqtBiStKpw+VXrkBCeR/v1s69iTBU9IpjyggLnHxpJXPVtb2mepIfuZWP4+YT4jL6e2R64csLN2fKb8DEmyW56myZGWbLufyMQN2U3lT+Q6LgnbPagpq/Oqd/tZEPwtvoP7i0qRv5k7X9kFK87MGt2odW6c4qUxwYxoFMiwllUhw+bjf39xm0BInKg/ZMkeTRb03+KlhRpIrOSQaxYfDCP3IJ+Z1jvQJIlcokSfVfMW5Drz9tw/i8ukLtCjYWjFri4+n0OrYL+OhJ9j4NkQxA2Kyk4YDfSv1xwpzH/FzdL6eK6FwHMe8yXUT42kTQt5dZZODvE+9qPVzGtOSD5Ce4bcnx9f2WpykJF/CE2Zw8W7NXHh8jMWhMzQ+NwxVFG92/vkSiDqKEvP+sVtJjiKmS09UTpiWMXvh/ldl11Rdpgfehsfpw2UtS251Bpu3+VYfO1+VhnUV4uW/8XO5G8wGViQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?OWE2MmhheWRDTkZpc3FHank0dmhIU2QxRlpBeVpGSUhQVGQvM3ZKSkk3WjdV?=
 =?utf-8?B?VG9uYVJraVlOTU5EcFBvUzd0RmZmQStERWtlNldpV3lKbHpKb0tOSTQ4eHVG?=
 =?utf-8?B?NkJxTUlZcm8wVU1lR3piZGt4SDVHNHZaUk5ZdEhaUXdEM043OVl2SWpvY0Qx?=
 =?utf-8?B?N2JhLzRtclpYR1ZqS3E1SndlWkJMZE11TjF6NS9POVl5ODNBa3pSc1RYZDFF?=
 =?utf-8?B?anZrQ0EyNEFJNkM3SGpibXZ5RXptT25LUmRBRHZrbEN1cDMzNXhiU3poaFpI?=
 =?utf-8?B?WWdhUW44Um03UkVyL056TmwvVTBlM05YMDg5Tnc3YlY2TEhVN1hDU05POGN0?=
 =?utf-8?B?UUdJdXFCMldJamlMT0s4VWtaRkcxcWpodWFMdGNjeGw5UzFxL2hqeWJZWFpa?=
 =?utf-8?B?cis4OXlsekh1TkxLd1lsa2x6bmhvbWdFNG1JMzNBUlBzNUJXTjNLcEZzUUg0?=
 =?utf-8?B?V2w3Qk1ueVBkZ2RETUF5NTBxc1YzeXlZMlk4akNRenNsc2pJbEpiMEpGWGFB?=
 =?utf-8?B?OEdJSjRGUTAzRHpuRGpBZlg4b2JFWXhIL3NBbFkxNGxpZ2wwZE1ERXNtb2Q1?=
 =?utf-8?B?S3JTNWFiR214UURZNEpDcWVuTnc4LzVTbHFMdzh1MzdIWHlJRkdveHBiYlk4?=
 =?utf-8?B?TUo4bXdKZER3M3lmZUx4MExJeGV0aVhNam4wdFhBYncrQkE4dUg5T1NFT3RV?=
 =?utf-8?B?cHVtWHlTU1c5azRGOUNDYTU3TmtOYStWVmhxOGVJMEtlSW1hT1d4cXVPTE5y?=
 =?utf-8?B?QktUck5LQVlRVVZJK2U5a1R1dGcvUXp2ZDc0YmpjOHhaR0Zvb3RSdmtTNkpD?=
 =?utf-8?B?SlJtdUd2UDlydkIrNU5WekN6eGxZVTFkM2t3ZUlXcTZXaS9sVDI3Zm1qK1Zm?=
 =?utf-8?B?RlFBMmNYZDVNS3R0UFdWaTNMNnZQM0hYZzBKandIMnFyNGpYREdJMzhZY09T?=
 =?utf-8?B?cWw0Q2NuWFltcXVBd3pGWHVNOU4vdkVGZ1c2QlhSajBpTGZtWHFtbFM3bXhs?=
 =?utf-8?B?ZE5zeUh0ZzZLeFgvbHdqUFhpeDF5QVR6UUZlbXRMc3ZXblpBUHdiVklKUU5t?=
 =?utf-8?B?elRhMHlLNmlpdW84K3IwOTRxbngvajhOR1h4VldWOHBULzY1dTVWa0RpdU1J?=
 =?utf-8?B?UU05dnRQR0p3Mmd5VjJzWVBOdjZDaGo1YStHMlhtNHFHaUFpQmYyakVLSnZ4?=
 =?utf-8?B?ZjgxRTdVZGI3VlZjRTM5Q3ZGMkNVM3ByeGxTNDI1aGlvbHJjUDZtOXdodXA4?=
 =?utf-8?B?Y25PMFZtVTZMRTZZclI4dHdEMk1SSGFjQ3M4SXlUOGJoUVlveUdHdWZNZVd4?=
 =?utf-8?B?L3NobVBQVW14MjZhSjFLRzNRMlFNa1FRMFZrNTF3cmpBSC9PUitXMkliRnRP?=
 =?utf-8?B?R093RjNhY1k2c3E0ZnEwV1MzSis2dm14U3BGNmdXZEpnK3cvdDFncVVXYkVN?=
 =?utf-8?B?VTF3TkxxQktlWXFpZyt6ZjVTdUwwRkJ0aHUreU5Hc0lseWk5OTJJU3ZwTU9r?=
 =?utf-8?B?MURNU05NQi82R3ZCZWt3YUpNQTdhOXc0elpTWXRDSzhCYkQzalU4OTJhZjJG?=
 =?utf-8?B?WGpRQXlCVVhPYTVPNVhTbER2TDA5Y1pFcmNqVzAycGFLcUVXeFNMTlVSbWU5?=
 =?utf-8?B?T1BPK3FKYS8yMlFKb0JZT1lacnJHeW83b1lMeDNnVnBNL0liRkduZmhmNXFI?=
 =?utf-8?B?WXBPMVNreUo0RDliRmNhRDNTZmtlSm9YTy92QzhFWW8rV0JVcXRKSjQreTAv?=
 =?utf-8?B?UVpLNElGaDRMN0tRSklPaEg0eXNVQmpHRGxGa2hXVTRCanplMWtnTDRqME5v?=
 =?utf-8?B?c1pjak5BRFFnQ2Y3dzlsVTFBMytHSDhCaWl5ZVNCR2l2N2w4VlNNR0pvQ043?=
 =?utf-8?B?TEpKVDVsTGNka0NyRFF2QU1ockQrRHY5aEZqcW1HMFVGOHF3Y2Q2VjVtK3NO?=
 =?utf-8?B?QklTMHp5UVhxdjdZc1c4Y2ErYk5Kb3hKUkNmNlNhbFk0bXFnK0NwWFVCYUQ5?=
 =?utf-8?B?RHNjUzNSSkxDaVZzMU5yQU9SdENJTytsU2J4Y3NtNFZJYzVyWEIzdyt1T3FU?=
 =?utf-8?B?TDkrQmdzS2gzOCsyTUMxSVd4RlMvQncwNk1OMHE4V1plSy8rMTZtaGZRdlhD?=
 =?utf-8?B?RlI2aEVLd1BveGlsRDRSeFZ5RDByMlk4VGZ0Wm9JRVhTbW4zdDZKc2pxQjVw?=
 =?utf-8?B?c0Jnd0dzYU84NlhGQUxUZ0svQ0ZCcmRqM2lncWQrcUFNa3BDRll1K2pmN0F5?=
 =?utf-8?B?ZHQvQXhMeVVGTnY5OG4xWGs4WjJqdXVaNmNqM0krbnNnWG8yNm1MVUdIZDVL?=
 =?utf-8?B?bktXTkJQaGt0WWk5R2ZUemRjdTJmSXhNVk1xeWpiRVJkbHhyQ1p1Zz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571357d2-e545-4b02-5033-08df125ebcde
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:21.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNVoyaUIwf6FM8i1IQgWJv49nXsfY+XIPuZupWMayRQqkjE/QlsBW48ZI4TcTxxyoahRWHo0S+oRGuU32YIgJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7272

Enable the UFS host controller on the S32N79 RDB and configure it for
two lanes per direction.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
index 1feccd61258e..38c5699e6d54 100644
--- a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
@@ -63,6 +63,11 @@ &uart7 {
 	status = "okay";
 };
 
+&ufshc {
+	lanes-per-direction = <2>;
+	status = "okay";
+};
+
 &usdhc0 {
 	disable-wp;
 	no-sdio;
-- 
2.43.0

