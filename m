Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013052.outbound.protection.outlook.com [40.107.162.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BA34B1CF1;
	Fri, 25 Sep 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346998; cv=fail; b=cM/QDMXfFhzfYJlvI8aFmohXUQteMRq846r+oAPqPPMXaSaCl9f5kIOb7BOThrrlN2qtrISWvysyTfyN8fnuSpf+KoXDcSmreOlfSOoa3e5qgEW847n+as6CfVkSbeMx0n9XXcdjPTvCcYVXQxf0/gPejTHl547TcQ5JZyYW34E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346998; c=relaxed/simple;
	bh=4NiE8tq9I4+KkmCkCSUHh9s1MZ2/o+fYsMro5apuCVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RUasB7uATZk60VEVIx/UBMNGCCFJpjE7O9T34ckPwzysZy9+RgZPoT2FS9S1qrNsUZVjRwIyAqWlsyjFH2YrzplMJtoIwwBUx+hqD7dGybhDv0a/yB+Ctp5Kk+uLa7+vUfrzI1GZWvyyuM/w5YuEGc53lSwGFmcfvB6jwB/QLgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=oFFJvEW/; arc=fail smtp.client-ip=40.107.162.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="oFFJvEW/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RtGI7pKzgAVBa7ueLlF+U6Gu1L496ce0SDaHgha7vtpUSegU4g3kbfHqEUclH3+bLjLUt/ELpNzIRdRWG8RMAMu5tzCskjfiPAroph3I7urfq3amXfETUCO9LS/b782BO5fQYfK+sGp3sOXQtgon20RugZvcwZyaUUBSjTT4xT82PBUPEYz6h+MUIN2EGdFi7gCXaYn4gOxj4c72CoWDRkvwr9DXFFXo3t3Zl5ljOFtIaRFYvqjFs2g+wAkj079FR+ZJB+WQD5TuNNf5UsXb19DcSMlUIIEN5azOiZT66L3BqHsj5pYj4WPxAMbbjfgMExeKi1TuftYhGKjAS+BeWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXp3rs+Ub6CV/8Wrfyv80LYYCUzHY0Ly1OqLfOQWSFc=;
 b=NG2OQHQMazYMizhJsTw93siTiV6I2HMlOHxzs6hV9FVpClB/kT/zj5OVV0c1Z7oeK7U/ws5oHguZLpEklMA53zWkYbnkl8rIXiOakhC1f1lOEmN/e+HVhNpkoDIV6o4FRLQHAaOGwaUn+4AHQgZI6b4qPS82ZvJT2FfYWl5VcgzMoG8JU2nyDAMg3mcMwjMLUekjDAURhgm5Uwga3yKQviSiNdk5V73QhRUTWy//fq3+i8NRY4t25Fgh8KHsYKSmg+WYJn4T/PGo7g9Bl3GLL1aZ60y1xQtgXFEmGwC87WfIPPziEcK4coXhsHTG+TaTVbihIrVOfugPxMNjY1aBFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXp3rs+Ub6CV/8Wrfyv80LYYCUzHY0Ly1OqLfOQWSFc=;
 b=oFFJvEW/0puceE+q1fvyJLeZx952/2XYdVk0RFHeu/TE6+QwQ157s6wxNLZzLBBftZBYnkocOkv9DB3FSNbHIBok6a5fBXdOqPXcimGzezqeT/Vy7l/Ev1vsl4iOkG8Z8ZXFkM6dOTl1xhRB1NVlNgRyZEP/RzRca7pBaQIWNlmvRBOjjpVkHYuoLyRZQRK9Lj6cxEycohGQA/lC/esPE0VQ/vK5WGtrGzX/jV8FDQV2i605u8SY/kqAvm025d2gvqVyW1/GrwPdUhwxE1Jh+kibngPsQ3FwN4waJY/+iky9Y56PUY+nxZflEbiBU4lgHEdwK5A/k2up4f3u9EUToQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by BR2PR04MB800621.eurprd04.prod.outlook.com
 (2603:10a6:2c8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:35:54 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:35:54 +0000
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
Subject: [PATCH v6 05/12] scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
Date: Fri, 25 Sep 2026 16:35:27 +0200
Message-ID: <20260925143534.3298540-6-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::11) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 6bf8ded3-1066-46c3-d2c3-08df1b124e2e
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|19092799006|10067099003|56012099006|3023799007|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 e0GJ217QN9datFKvg27ynHdLdWjHbIOVEmGnBQ5ba2zVjo+V6Qm2nJi/KcZoMP8Bl/cUWiOo9/1bTp1pJ6Z2RPvVTG29VPqWn1SdkjaRPVutfhRbhmnPxhh8IpaYy91lB3mXcuspEW2Er4iK8xCGrx2xOwWDwLilTcqBgOvJYW5XkBqUTNA6vbSCp1wp5xAgQPDxOuk4VwAZnKGn7n7sMZWaepJX2Gqz/6zfj/+yI+8pKr1B9SdUYreALFKHOOZdQvSqC3LGC0t8MwmnO7tqODdNjANBHUkFj8puOA7oQzoLFIsIbgklwhAEBLegKndoBsf3/B5bGwEg6BTs4BxUc7D3DN3se5jsSqu3JTvJHVN72eKB/Re780zquEQysrGgMV7mDjPE+lLaG/OIBET2+44mqhPuEeLHLTsJpaWL2YplO7Rl90fmAx9pVahNf2+bdqG84RgX/sBmHbPd+lIUwQw1C3cqzo1eLWgbUdUv5X7+TQRh3f9fQK3WBlkhZVl+c3Cawu5MO0bsa6Z5Q2D1IK7uKvmmiaSsWspge8qj2yhDSOtZBWk0lPMPH16Nhyo6YkjvcGDL6IPz7QXwf5yBfPTReZIvl2lrpydaXGKsJNR7JbalCfLEtqoDTVRlh9fmohlpA0UP8f7NQrzOSsMO1KddFfipR9VKTLH/DT4//9+q/bY/Gt+xNT9zm7cp7TtL9AWjHyAc7woyUqoUCavOUg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(19092799006)(10067099003)(56012099006)(3023799007)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?L2JIdkZLb2l4Y1N0VFJJZHZreUo3dVl0WkJlMkFNQ2EwUUlPclAyeS9MbFRC?=
 =?utf-8?B?RUdPNHdxZVR6amJIdlFISkwwNzNqMXo4TlowK0FuSUtwa1lNQUxvakFiSlcz?=
 =?utf-8?B?cFFqcVUwV2Jud0xWUXVLT2hPN2V1SFJ3UFZiUUt4SlR3ZXk2RmRzZEZpVlZM?=
 =?utf-8?B?Z3h3c2NCL1M3eUxhN0VtOG13bVpWZDhUSG15NWNnSmdvUjdiVlNzZlFlQXFY?=
 =?utf-8?B?bnRWcGlFeWlibG1KeUl2R1VJYUlEL3BhRTd5ZUQ4cGovRFRGQ1NYYWorU3RC?=
 =?utf-8?B?dWg5V05YSHAvSmRqM25mOGFudUwySTFiY01JdzZZZml6MVhhbGxUTkVwcFlp?=
 =?utf-8?B?eEhpdEFhalFTYW13dGxBVnJNZlJlOU1KME1oNEZUS3JsZEptNi9wejBQT0hX?=
 =?utf-8?B?VllscHd1UFNDVjJ0ZjU4UTdjZDRTSE5kam16bE41M2gzd0cxbWJzbE1TK1RT?=
 =?utf-8?B?UFk1T0dFVnFoazdWR2pBSGZNMXhEOUtPcXNwSWtDSC93bElrM05Ja21CWlR4?=
 =?utf-8?B?UVhxdkxoRm80ZlE2MFAzQ3ZJMGpIcnQyNzZGR1RNcVJwNGIzUk1mMTBnangz?=
 =?utf-8?B?NkVkTkdCNkE1Q1lOckV6US9RcWRzRUNFdmtScmc4MTQvMVhoSUk3QXNrcURY?=
 =?utf-8?B?dktDbmRia2I5TlNBL0k5VkRaUUlpK3ZoVWtQSmtsZFd0dGpZR0JpRTJ6Qlpn?=
 =?utf-8?B?Z2Y1WER5NjNHVjJxVW1ZWjVDd0tVdWVTVlFvbmhDTzlWeDcyY2lhUDlGSHQ4?=
 =?utf-8?B?OThuemo3UWFmTnRpdGkzeDhEa3pSNUFuUVhIcHR3Z2ZDNVMvVWdRQ1hYMVVy?=
 =?utf-8?B?Q0FrbkN0bDhhVjlROFhrNFlCZTNlMjkrRHY4T0FTczEzVGtlNUNyS2g3OVhJ?=
 =?utf-8?B?QTFOeGkyaUlWb283RzJLOWY4bjhmZnp6dlV3UmhsMnBSNkN0M3BqZm5sWDRB?=
 =?utf-8?B?UllKemRkcWYrVVN6UnJ4NDRNMUlJMnJJVzVrUkFSMWErUWtkaGpFY05VaHZi?=
 =?utf-8?B?NGVVT0Rlc3R1cWhLaHZ1YTJYMklwaTJPWVZQSnA0R2o5YitqRnp0L3l0Y3Vm?=
 =?utf-8?B?ZlM4ZFFWdmxNUHZ2WnZuMlhndm9HYW1OOS9haWpvcUhTWHZYRUxhUG9lRWtG?=
 =?utf-8?B?bE14Uk5UYUJ2NTN2T3dhZWJyRHdDSEk3bXdoeTcya3RPeVlzMlFBL0dRdmI2?=
 =?utf-8?B?OU1FWDZ3YXFxZUJUcDg1S1IzTWN3bTNsbWJQV0xtR05LaW5yOU9QRWw4aVZy?=
 =?utf-8?B?M1lXOFF0S0w1K0NHbWZvSTJMQ28xVjU5c1dvWUg3S3VnQ1NPUlNtMzV6bEpF?=
 =?utf-8?B?UjJ0V1pZS2p1S0QycHhCSytXbUxOazNnbGVudTlrZDBKNk9xWVJrbUNVeFpq?=
 =?utf-8?B?Y21VMmorWncwMGVVSHBmRmxVa3JwRlBzRFJxemxFQ21SVnU3UkxtNWN6d1Ny?=
 =?utf-8?B?UFBoVkRVNnYxMFFZTzRsMWJkenFocXBUUWxrcEpQL2FQWVN2UURUOC9Sck44?=
 =?utf-8?B?L1h3T2xHT3RqeFp3YmlZdi9OU3NnUFlpRmQrVHJ1cjc3N2JldHZOcUU1NGJl?=
 =?utf-8?B?ZCtBUngrRjhJR0VYRWx2dXE3UldidWtyOE1oZms3czduKzhTOWllRW5TcG91?=
 =?utf-8?B?UFRFanlId0VQLzE0dGpjeWUyOW9QMWMwSmxOcFdocmVUclBxTVVjUXphNUl2?=
 =?utf-8?B?OFQvT1YvN0FIbmhXVXZFN1dNUHJpY3dWQlVVVmFrWHF2Rm5zWEVDeTZCTlR6?=
 =?utf-8?B?THFsL0dxQXRLdGtOZWE3MGxYQUpqQXpQWVdyQ3dPS3B5bTNnY1FNclZVVlcv?=
 =?utf-8?B?TEpwaHdHTDFUanIwOVhaZUF1U1oyZ1BtLy9mbWg1Tmc3QXQyS2xEUDhweFdH?=
 =?utf-8?B?NEtJWWt1QzhpbG9VSjRycHVYN213ZXJPV09KUTd2dkZ4NWZSbTQ0a0xWazdQ?=
 =?utf-8?B?R1BCazdRQVo1K1ozeDFMTkhRRUVJdXNDdUtxc05IUGZ6L1FTNE1xa2FrNUVF?=
 =?utf-8?B?TVQ0bUl5MGVhRW1QeHpMNTZNTmVlVTNPK0lNM2RIdGJaZk83elhWUTNQcEFM?=
 =?utf-8?B?TkhGd2VtdDMrV2N5Y0pGUGI1THNyN0VtbTA2QkYwN3FyOVd1M1c3Wmw3OU01?=
 =?utf-8?B?OTRDSGpISGtlRVc1TjVOTllEYmVoM1lHbmdyZVNmaFl2Q2tqcWYyVlU4Zktw?=
 =?utf-8?B?QUxKYUUySm5WdUNuS1o5SWpFS0d0SklvQ0FvWjk0bFEwYkk4MUZOZWVoeHNs?=
 =?utf-8?B?azNhZm1OR2dJSU5Ia01aNktEejVNdkZmVGx6S005N2lwNHdwNWczZkxEOUpn?=
 =?utf-8?B?bTBGc1kvS3E5bjlHRnJZRGlPMWZUSWd5ckhsUlhzQzdRUEhWUk0yQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf8ded3-1066-46c3-d2c3-08df1b124e2e
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:35:54.5880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RO2D3BENHFvtYgocxO+8xeDEiYGRrOmVB+mwOaIvHdyqFMIbmU24VNcrQIS+inZxMmz13gjlW5mnd0tn2qhptw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR2PR04MB800621

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
index 71433b4d04aa..20b7174e9498 100644
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

