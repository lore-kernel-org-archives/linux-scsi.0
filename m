Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011054.outbound.protection.outlook.com [52.101.70.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96F24734D9;
	Wed, 16 Sep 2026 08:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548288; cv=fail; b=fzxTMwfGTqenK9zx1kWX19vfatfFqyU23eWXeRAcYrHLgaEM71WEYEStbNLL6yuDbBRiZZFBpqzzotI/4lO/9giAvIRTVw/wOvj2J+UL/3qzGEVlH+EYOUnFZhWZKLVOCBiyCJi4v5iM34uPccW2z0QqHfuo3P0FKebGzy0aUAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548288; c=relaxed/simple;
	bh=btTK9VyV/T5h/rkWXVbdQFqjLOlCpJ0O4Kxa1h6psC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BjlBNel6HpcpFa6d1UOfiB0KgqvsrvxM/fY4Wg7AdB3S+pLMh5PxqQg4yRFIAMXU+W3eVNnrs2S8v6xDHKFG6/CEJm5nRQznRYxOIy9UJyq67tW4WO5UGY3xlL+dpV22irhE2wXhSaIiw0rwJIgALAaQeoof5Nc2mIMDrIy6ymw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=YvPbHL6s; arc=fail smtp.client-ip=52.101.70.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="YvPbHL6s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=unshYOCaeC8itaLKzxvWZ7Z4qMfzUsUPt/YHBkBncJPJpEiET7k33IJFoBIQuCK5NyiQGe8VZySlNMdjmjlRqHHuIblQk6oKM2wvS5V2mQwVaDLyG1klJ3EexwByd2AoiNhgCtFMs6AUwNaMrKd06RwToOP9So2ERJoBcZVR5Jl/Ur7ReoC1PLoXUmyk/QqaugUUSYNe1NLhhEBmW26//4yZy5ij6MnSCW3baC1Z7jIJnZruaKjt43Ff/jxufKGBqgodlz5pIKVfa6s/Wgik19szrO9yYReD57ZXXshhl+0ZoeaBfV2V/6fD+4HpXzuKVzx3Q6p/nvW620U1h4AmJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxZ8Ez+TEhfMIgB3VjK88pB7It+1EqrFackGK9FFUZg=;
 b=XYf38XBMu45M5vHQVucR2/ZlaljYZcB1XSSWKOw8dFKuKSvcEcjbYqOYWkbW0Hg14a4sgEFlONm2n/Yym/TiFxS4oGEDRt+vgqrDyCESTlrtfK9mYtK8YweYMycdyz0R5110Yb/xlAG7og46S2n1kwOGq/a3haL1Ka+bgB4MWPWshMPLYhwwj8dZhCbs2JTv0g1zlGMFtxMgHNjnbpiOOCMPExQ6vwVdbWrDytMWB2lHHRyCmwL42XfuZ1LF1NCSOxBBdE7OmrKV2GdgTCqDPULZ2hPX5cX2LWdfPLdcOsBM1wEChGrhdzbmCUiPjGvxvYyjBmA4OJqZBe6XWwIzYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxZ8Ez+TEhfMIgB3VjK88pB7It+1EqrFackGK9FFUZg=;
 b=YvPbHL6sdzNnpmyTgI1182A1kWsMslM3qUxvb9l52cpqJT2YuCo0CswKmFiaNrY7KPEYjVnRModcoogiCjtTyGcGNUiMt9JeMGrAU3UUeueKIK4+0vnEKOVjQa2ov0Bm2AkMSuPv+vv8ukMbBN5cx2Ae3JqOy1ImoUdyB5zTbCel4FG2BZpiR/ODL5G1yc8zgvoizE2iLTYnoU1MUbCFPOaxalFCnsw0sGZq5WkakwcbabTtM4RrOOJxQxvBhgkF/yJOiI0W2yYt6gAHDbB/TE2jv8CTi2wpQZmJdZYwrZztqJpjdlD+uVz9LnJ+5B3tlsyBBnGYT3+M+BbZczjknw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:24 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:24 +0000
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
	=?UTF-8?q?Pedro=20Sousa=20=C2=A0?= <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v3 04/10] scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
Date: Wed, 16 Sep 2026 10:44:05 +0200
Message-ID: <20260916084411.941297-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::21) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DUZPR04MB9981:EE_
X-MS-Office365-Filtering-Correlation-Id: ca9b1b17-6ec7-4943-c35d-08df13ceb597
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|3023799007|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 0yiBae6GK75rHWRfAj6WT0b03PlB2/VjiqdHwESJguMPuPJ8dLIV2InmRSNKEvBolkHSfex7oIse/uPYQ9S9MRkPklc3ZIQE+arOzo0uWmVMUsA0YicE1ETx4FySCdn71xYXTTVF57vWHnLmXKkUBzi7nnOX5vtfN1qWL9W/dvHJEKzAJHjb3dpbwuK7pIzYVpSzlv/vpj+6Sh+5m8lfiINm/paAPTjCyLGCrmEzh5X1DXaRpdSKG++7C+u/scpiLOSEkVZcJ32CDPOhYF2rcKodllB8gHMlK/beeT5BSjl9mHttCEbPVztgLJ299WSFt5DlWxl+tUdsUYv8VFsrqC6p0snQ62y5J+PHuErYBIvXcwkFlfnaB3Ifjt3bV8M7wggFscoptyoDXB5lQl4R0nM78KKkURuaAzKFLrxiRh3fxkyNdIag2uyCbEyVL+mj3rd0NxpkT/WdHDohG6mjdjf155UwUYFDC3rWu0yo6sRT8aX33X6dPsJupnxPOMEKsrML2ycaOQP6nH6yPpfNOGEUAnrsXW7GrUORh+WD9atWLcXPG0VkZINYu6CX7Nd7nZzxiEp5WqjpzKp5SwXxTe79M6MZC4y10Q/sM5soW6otzpZCOKsnY+ipjTaFz0tPBzBbZ2ct4+gcBjE/b+sqWq0cN0PKSJHx3F61P8/lmg1nzZJQ/xLcW1+3yc4ZGABLbxkxIoSFFUxKVc+izLzKjg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZENqeUZPWWIydndhS0RKYXdxMXBlYmltMzdya2JxbW9mNlVBT3Vxd1VyL1NC?=
 =?utf-8?B?UnNORGZaNVBYV21CSnlNN0JnRXRTaWNFaGsxaWRLaTJBN1p0Y2E4SW9sVGFv?=
 =?utf-8?B?VFhrRVRMZzNuNm9XVUtoY25IZTRUemNEdWxYZ1NOTjNIeDlFNWFDK2FUMUR1?=
 =?utf-8?B?NnBWd25BY2liOVE5SDNNQ1FGTU81YldoWEdDamlJZW5Nb0F2cXA4akZDUVMy?=
 =?utf-8?B?UkdvQW1JMEJJUjJSTFEvdThXRld2RS9TL3dtbG1LZWFIMGVxRzM4L01nWGdL?=
 =?utf-8?B?SG9wQ3NYWDVkSmNTTVoxMlpHSjVOUW5XeFd4QlVUZkhLSlRCZnpVb1c1N0lZ?=
 =?utf-8?B?V241ZlpYUjRYN1dsVFZ6L1E0VkIwTmwxVHhXRm9xMy9VRW1hWWFxZGxOaXhx?=
 =?utf-8?B?L3ZJN0NBUHMrOUFHVm5tcklIT3FzdVlCdHRlc2Y1WFdscUhRM3ZQL1hVeUUw?=
 =?utf-8?B?SmxabXpUdWxtZTIxZml6MXBEQ1JjVmhlTThCYWdWOUhwS09aZXNKeEovNXlL?=
 =?utf-8?B?ekYvMnFKU2Nobk9qNjJpNFdoUU1DWE9tcWtsVms0bHBhOHpGckJrUDVxNWZT?=
 =?utf-8?B?Sm01b2p6Q1pCQWEwV2tLSFV3QXQySER5QStOWGdKYkxNU3ZZWmxJMTBvcVl5?=
 =?utf-8?B?ekQyS0JzUWdud240U25vRHlHa3VuZ0FEVmJMemczYzRvY1p6MHZPZ04vR0lL?=
 =?utf-8?B?dUZmcS9SY3FnZXJKQ2tvNVY3T3BybjhCME5tSHpJOEI3MTNJcjRic3JRNmhu?=
 =?utf-8?B?cDJoeXlxSHpheFQ5S3FNNFZVQkVTanRKK3d2WlQvRzZHdGJwOHFPVE9SNFRZ?=
 =?utf-8?B?MGN2cVdwYXFsZmNOa2diSVBlK2h0Um9hN0tXTGpZV0hPSnhYVXNjUy9XMjVp?=
 =?utf-8?B?c1FtWml0QlhvdGlvTWl0Y1NzTlp4Vm5DOERjeDh5bW9iWkQ5WkZvdTNHK0li?=
 =?utf-8?B?VUNZVGJRbzNpWU1GUW9mR3czeTg4WTFGUVZ0NTN3UktHVFZiSzdnN1JBZ0Z6?=
 =?utf-8?B?RU9Lemt0Sk9rYTlsbGNkVkllMEhRa0JBSlZZWXZaSFlDbnUrKzF0YjhkRDM5?=
 =?utf-8?B?QlM4dDM4VEdPa2cvUzlpV1FTMWl3ZTVOQzdUaGgrRGZwUnZFVk5OM3ZDMk1G?=
 =?utf-8?B?eThyVkh0d2JLOE9iSGJRR0pWWlFNU3hNODJsa05TdGhHSmZ1TFpiS0RaQW9h?=
 =?utf-8?B?NU9HenMzdmlhR0hIVi9OcVVWT1puZi9sYlErNEpOampOd2xJWEtQUVVFM2VD?=
 =?utf-8?B?VWFoa0hXKzFBNWdkTis0VU9xNjJRRGdKbEZGZWI1Y2ZKVitjK1EzMFJ5U2dE?=
 =?utf-8?B?K3BwTzl0UnlsTFVWdkpKMVY5QXkrZ2hnOU56eThPMEQ2TUxmTnAzbWtZeUhN?=
 =?utf-8?B?S0V1Uk8raGEvKzdYV3JGNTZ2L2Mza1V3MXFyczdXOENwWDllTWpiUTEvWjJP?=
 =?utf-8?B?cWVaQ0k4cm9HTTJmbktjK2RTdDRmZGx4dEFWN0UvOWFEM0lHckZvUnhZSmdM?=
 =?utf-8?B?bk5IUEErNzdCSUtoWmMraWRmOHQ3OG5MNTRoYSs0NFZTTnVIRW5qSXdIc3Aw?=
 =?utf-8?B?UVVidlRNTENIN0lXR1NrSnhGUXZVWDNWUjhiSDdqVXNPUXVtbUJ3bnF3UUFV?=
 =?utf-8?B?U3pWQTRzc09FalNsM2hJOWNYN1E0cEFBR0lTaVBTd2k0RXFidXhsMUFkQ0ZL?=
 =?utf-8?B?VFNrb0lPZGdXeXJWendBMTVZd1RPU2VrNGZuTkUrU2VxVXM5Z1AwZFhmWnVI?=
 =?utf-8?B?Q3kyUDc0RjJxYXA0OVZxR1B2ZzYzUno1anNOdEczdngzdFZIb1piSzRKR3lS?=
 =?utf-8?B?NWlDcTB0ZTNMczIwYWNlRC9iOEJXbkVaT1RBaHFCb1E4ZlpFeWlMVnRtN0pP?=
 =?utf-8?B?b3NYNGd2cXliZjRZOHdncTJ1WmZRaUVncUl6TmI4aC9obk1mRmZDbGtGaDdt?=
 =?utf-8?B?MFJaQ0JuVTdDLzZlRFQvSzhndGZrb0tRdXVkN3h5TTZkOXVFUlNnMVBIcGNJ?=
 =?utf-8?B?RlhWUjN2UjdKcXphVjRzUksvT3RkTHNwc3BhYm5WK0o4NGcwb1lrSDRTQTB0?=
 =?utf-8?B?MU8xN29FT242SHNUVUhRQy8vYkc0ZzBqanJUSGVxZkRhNzZSR0d1VXZtRnhY?=
 =?utf-8?B?bWRyd0lHdmM3SFVNRVhVdUVwQVROQjdPdmtzclpSOHNLS3h1cjE0eDBFWHhx?=
 =?utf-8?B?cWY4bEk3UHdvZVhFcXU5RWYwb1QxeEJGUGZ4dGRQZDlqL1cvSkNzUkVlY1R3?=
 =?utf-8?B?WlNBanVhbEN3RTlFdGYrS2gwejRWMExxc01nM3IxeWRVamZHVUFzRzNKMGpm?=
 =?utf-8?B?bFIvYVlsWVFaZmJpU0ZHZ3E2QVFlTUZ4RW42UlVzeGY2emRLcUpPUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9b1b17-6ec7-4943-c35d-08df13ceb597
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:24.1609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KYtWKOwJl0p5U3qMQ1vo8/067xtlToYZS9Xo8fxx49G25cHoq+8ooWgOkFZTHaw9agj0nsrZmIe02FoBU6zszg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

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
index 21b1cf912dcc..0eceec543d14 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -141,6 +141,75 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
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

