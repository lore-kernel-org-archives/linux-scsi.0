Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A61DC985;
	Thu, 16 Oct 2025 03:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760586194; cv=fail; b=D9+opliIsxIx73VLRVahjMeZZAO2t2QWX6yU69SQuMQRqzPYXZUtiLSCQJVpuqJXEF7wlI8/QdlyHD/EKTzB3L/xa2VYGotQ6rae9lRPHU8u6GoPsxnwUiKacpUK5jmTMHtAkChlt0qtTcM4kE41xohcDQDGenvNDRnRfy6xa0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760586194; c=relaxed/simple;
	bh=RoHl8fWOrUXGWKMcfcQRvacDCLQ+IAwOa8gAOfnMmss=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rvcLsTkLNKsHJeJrXVDWU4AMWtL35gYQxP6+vvO+R3WUb4eYLSYXaNOwF+C3ezLrE2/3s422UzUCt9T0GijoJOXM2E+W1PqgVC2ak7tXZOE5MjuofFzbttJtE+aSSbFLruhsb0Hc2vRAjkh6Iqzb9cC3mUX60vzBFUKcfLwTP34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mKjYJQBC; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=KKy78g3B; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mKjYJQBC";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="KKy78g3B"
X-UUID: 363322c2aa4211f0b33aeb1e7f16c2b6-20251016
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=RoHl8fWOrUXGWKMcfcQRvacDCLQ+IAwOa8gAOfnMmss=;
	b=mKjYJQBC4mkmiCbfwdxLCGYxfT9Bc5p4ti9+onKRlAn0Zsp2MjbsSikYuIJPCf83S+lN/LgCrQ08T4qL3NnG3woDJayORC2DFiLJS4SFN77QzkvAJr5BaL6Za1o/lBkdLGqrpQYK2BNpZwWU5W8hMIOjB8hJzarfQXAXbxY/6PU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:c8a38575-876d-43cc-b4d4-6016101b1a8b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:6fde1c51-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 363322c2aa4211f0b33aeb1e7f16c2b6-20251016
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 899741713; Thu, 16 Oct 2025 11:43:00 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 16 Oct 2025 11:42:58 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 16 Oct 2025 11:42:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dX/k12wdaFLBhMVy7Yaw5fm2XxPZOlXYmcVt/TQdnF2GWj7W9aw18+QCdizUyFkDhe0t8WdelN59lWhgem2kZkJg99vZBAIsg6+0wz1IbFKX0XedfIjm8iNKiSxGhcnm2o4p5inLRrcu/amW0SWpHzM3WHCmsO+fNlZw+5bECFhjF+gRD3w5zb7W8TZyr8fh2B085psPOfiSoc9ssSSF+I87NoSCRrH/fERMyTwdOyVGJLTOY4yeHPeeuk5bPxB8oXsAPLoahUkvPWWP0jtC1ta++0H3yLH0HELhCIrx3XAnFDnbXNdPh57fhgP5a0TlTFzITuJNxrTKXnNIm5TUOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RoHl8fWOrUXGWKMcfcQRvacDCLQ+IAwOa8gAOfnMmss=;
 b=JoE81zUpcuf5Sb5vkCAcly9QAtrjd/2q/PnixiqyA3/ipQm2wOU2PQ3lgkDOKtil1iW4HQGaWPJoQp75TJ7tWeoahIgZRa9op+DHzdvOQ7PPjP3NKvOqpY+uL2w/e67xSEwoiQlB+1cBsmJZbJISLIbt+TKLdpC/vqv2y3OleCtvDtPuUO4CLDyJyh39YwO3MKnVLE1FGhhY8u25DA186LaoJ54roWMerQvTckM0jzGt7EeRO/Uw+wUcoBIA65vyIkdPrSZFijg000jUPDn2AvdeeKKyA4t3SOOBU8Z/dL9HZJ5t5fgv0+c3UJQw6hdXs5mPErCLF1EKB7tvdzMR+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoHl8fWOrUXGWKMcfcQRvacDCLQ+IAwOa8gAOfnMmss=;
 b=KKy78g3BxSPoOYSMVlWZ/g5wVukHgPJzlMLRJlL86oPNOu4xZUhSkqePCa41jmhYMvEeMfBZlzkvRw9HstO+3lzXkAKvBkULEuF36DtIyO0tN+g+7GNE+7jYikZbd+7bBhWmnRwb7Pi9CNByZTSUlHFrmNTPnke5Yd+IfCSU72A=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7923.apcprd03.prod.outlook.com (2603:1096:101:171::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Thu, 16 Oct
 2025 03:42:54 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 03:42:54 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?=
	<stanley.chu@mediatek.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "kishon@kernel.org"
	<kishon@kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"p.zabel@pengutronix.de" <p.zabel@pengutronix.de>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH 3/5] scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to
 mtk_sip_svc.h
Thread-Topic: [PATCH 3/5] scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to
 mtk_sip_svc.h
Thread-Index: AQHcPRzuIvKeA+H+UkO8VcbyGQOGFrTEI62A
Date: Thu, 16 Oct 2025 03:42:54 +0000
Message-ID: <2aa16184e8c96262259eb1c24cdd92b52f222dec.camel@mediatek.com>
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
	 <20251014-mt8196-ufs-v1-3-195dceb83bc8@collabora.com>
In-Reply-To: <20251014-mt8196-ufs-v1-3-195dceb83bc8@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7923:EE_
x-ms-office365-filtering-correlation-id: 87f6df23-9e3c-4c64-ff97-08de0c6616f5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?N0VMYmdWZlFuQjFleXRlTk9ad1FnTDEwSW4vYW5ES3A5OG5RQU9NVlF2SUdC?=
 =?utf-8?B?ZGVmVXI3b2tHdVdnQXg0TE5wVG9JYVlEbjRaM0MxMXR0R3JNektvL1NHQzR6?=
 =?utf-8?B?YzlUNGlwK3hyVEs0VXUyRDFKSmVrZDRnOWFYNi85QStzY1VEQ1ZVanpSRmJt?=
 =?utf-8?B?UFZjMHI4ZVlLZ21RKytYYW9CaXRvVjhCZUwwbEMwNVBWVUNyTnZCSzFwQk00?=
 =?utf-8?B?d2diT0V1L3J0SVVISDl5Mk1YekpBOHNlT2hidDd0UFNOZW43T0tDMGhwVTMv?=
 =?utf-8?B?MVV1NFpRR2FJYVJNczQxKzBXc2NlQndSZEMzb3JTSGlPS05zbjZZY1lnWEg0?=
 =?utf-8?B?TDh5cnNSeC9leFoyeGZCaHJybVI4bFVaRy8yejN0OS9YZjM0VUxiNjhSWW1H?=
 =?utf-8?B?dVlieExHb1lrRnNtaXRCZytzTU02ZzhnRnhoMCtkUngrUEJ2MmdkSjdSNUtF?=
 =?utf-8?B?eFJOS0ZBOHphMWNZSkxwRVpXang3ZUoyR2o2cHZPeTlkUGE0QXd0WjVpNy93?=
 =?utf-8?B?Z2pKR1VsNVA1cjBxSXdJdS9OelMrTWY1NGtoaE0rbXlRNU1Ic0FXRlo2OCtm?=
 =?utf-8?B?S1JHbVo1U1d3L1hRT2tsZnBYVlZNcTFVR21kVzFNMEhCaGg3UHRDSU0vRFR2?=
 =?utf-8?B?RjE3UWxLUDFtd2RhRVlHVmhpN0pVeTZWTy85QzNWRFpwNnFXeG43VFFwdC8y?=
 =?utf-8?B?TWpTWUYrZ1gwek1NeVVsU1M4UUJOZ2t5VWVWSjEySWxBRzJDNER6TUZCV05h?=
 =?utf-8?B?VkY4djd3elhSaTRWRGlBUkNackFoWE0zOWs1a2NsTmcydW41NDBOdEhsd3Vp?=
 =?utf-8?B?MHF5a1NvNkdYTUNFblIvaGdHYUVkd2xEUTdNd3JQZUE0TGlzWXJpTnc4OVFx?=
 =?utf-8?B?M3FucmxNbjdrTlVlbWV4Ym9UL2Jwbmp0THZndGpETkMxVG5KMngyaldGdCsv?=
 =?utf-8?B?Rk53enliSFFISVFmYS8wR3EvalFwZVlmdHM3Q0JlUlNvUEhsak83L3Q3TFd0?=
 =?utf-8?B?ODVjazhtbDYrSHVHb2N2ZWJDajBuRlY1eHBXNWcwK3NEcDl5Ymg5UzQ3d05q?=
 =?utf-8?B?NStiam1vVURWa0thdGVmVUdBYytxRVo5VGVGRWdNQlh2d2c3Y0lIcUIrSGZL?=
 =?utf-8?B?Q25LVmE1bkl6TUVKNEt4anUxZ1kxZngzRExNOGF3cC9VeVc0eGxYeEtrcXli?=
 =?utf-8?B?TTVDN25GMWUrZHhBZ0tDUVZqRGhUZ3BHZkpEVW1wbWJlRWo5Qzc4c3dTbVpz?=
 =?utf-8?B?RmR3VXE5Wmg2Y0hhTGRxSVQvUEZuUUxJVld5SHplTWxUcDdFRmU1RlU1NDZH?=
 =?utf-8?B?Y1ErMEVBVVBTVkFMdnZYK3JmSEtIZC91cWZEaXVyZlVqMXFNME1pS0xvUmpQ?=
 =?utf-8?B?RjBMZUc0MHJBTzJVcVdvSU9mbWZZUzhtSENrZmxyU1pKUG1zOU16VlRWWjhs?=
 =?utf-8?B?ZE51V3B3UVAwL0t4Z0YxUlhVVWVNSlhVVFBwNTU4ak1ra1RpU0JOaFhTWFhH?=
 =?utf-8?B?ME9IL3RnNitDMGswZjNPRXFwQjNFRUUxTGVQdi8rcitoTmNweURwVTBTM2pM?=
 =?utf-8?B?Zk9tWUs3RU5jZjhMNFphdkxlOUdFNHArQmVpcGhZcGtMSTVwRDJWYjlOTVdO?=
 =?utf-8?B?MlpBT1BFR1p1SDRtMitLM1lCdHhXN1B4ekFHcGpVNlZuL1FBSndBS0pmUkJR?=
 =?utf-8?B?b0p5OWVQaE1KYVhjMWdxV0greEhpWHpTQlFWT3hNVmF1NVZwQnlUcHQ0azBz?=
 =?utf-8?B?WlN0VTgwT2tOU1JubGhFTkNiRSt2Y0hJUW1sYXlKeWpyQ1VTVDN5L3RuKzQ4?=
 =?utf-8?B?S0U1cTVYKzRQUGJ3ZHoycTU4QlRYL2gzY3RnVitkYisyb1lpMUdiRmZmands?=
 =?utf-8?B?VEtqT0pXSkF3UVpNN25FYy9aTGZURlhEYlNBNmlOeDREa0NFTnZoVHAxMzBV?=
 =?utf-8?B?ZnZmdVJ2a202cXlqYnJFOUNrK0ZFWnV3NFB2RlNjZXpoTlI4UnJ3dUVZQ3lH?=
 =?utf-8?B?czdIMmpNVE05bnp4dFdvekpNdjI0WTg5OXdqNTNiRUN2dkhIRExnTExkaTNV?=
 =?utf-8?B?QzZIS0YyN3pqNkhvTnB2Zm05ODQ2b2QwWHYwdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXdDTEIxY3ZEeHdVMDBmL0Z4dWNmVlFBY1lTV282dzMyc094d1FLb2VJWWsz?=
 =?utf-8?B?NGN6aGJmSmllMGlpSDRJVExaUExNNWFTbmRQNjg1TmpkWlorbGpUMFo3Q1ND?=
 =?utf-8?B?dGhFVlF0Z0V0MkU3V0pNN04vQ1owZWZaa04zVXZpVnd2Q20rR2ZkcmR5NGRH?=
 =?utf-8?B?QmpZMkJjakQyV3RiNVVjTkNGNEtQSmw0S0U2bXd5Q2J2SWRDMVpsbDZWUmxq?=
 =?utf-8?B?ZDJaZ3dGRmgzRHV1MkV3UlpEb2FaMWRvMVF5VHhmV2RHYzFRY0VHa2pPQXl0?=
 =?utf-8?B?V0NWZU94NkpnNVFMdm8yL1YyeGVZZWVNeVVTU1h4alRpcjBoZVJVWEVobmZG?=
 =?utf-8?B?aHFuNU1WU3c1QlBDTjNwendhcjllbGdRWm5jN040ekRnZHlhOVhuTS9FaFJT?=
 =?utf-8?B?aUQ0ZEYxSGU1THdXY0JkVGNFRGdzeEl4MGczRXNTa0cxRmVWbGpwaDZWaTlZ?=
 =?utf-8?B?ZzRiSHEvN1VZWVhtaHRaZ0ZZMGhVNG9mYWxMa1RPT25FRzRkclMwMFZRZHJ2?=
 =?utf-8?B?UmRsY1JNcUxUNXl5VWYwbGlNNVA2NVdYTno3a2xITDA5d2UzbEJjZ2xTRldJ?=
 =?utf-8?B?Q1FZZnJoVXFNZklnaUlsVlAwd1lkSVBFMXFvZWlHRzJhYWY2WS9GQjlQejBi?=
 =?utf-8?B?UEpaUEJXY2QrNjByNm5CenFhZk5aQkNOZDRpUTk3WTh5V2dtTUtJQmtPTWZH?=
 =?utf-8?B?djdLejc0ODduc1MrY3prM21CY2x4TnBpT3NTUnUxbkgvcTNocDF4SHY5Lzc3?=
 =?utf-8?B?TlJpWWFrMm9RMHEzajVPUTlMOXBFMHhmV2xFVHNkT3ZUOVltWDRTU3QraWU4?=
 =?utf-8?B?Q0ZsdWNHSlFJbkRuMkpsOW5EQjdYZGRTc1hvS1hkRlc0eTd6T1pNVWtvWDFO?=
 =?utf-8?B?NTJYdTdnWTdSNjlIekEyemh0RmxDZ1NrYklncHF1L3Z4aVUwcFVuYU9McGtR?=
 =?utf-8?B?ZmdtZGpIbTdXVkVGMlk1Z2dRYWU5QnVZOXIvNjJVRW94eC9mZ09zTXNZSlZM?=
 =?utf-8?B?dTZ4a1BXZTJxcnA3aStkL1FlSVQrVEJlSWg2KzJHd1lNQUFRbkhYNjNNYThl?=
 =?utf-8?B?VitIQ0lMSFA2eGQ3di83a2xDdUJrYW1zTVRpR09ndlpENWRhdTdGNGRzd1hz?=
 =?utf-8?B?eTVIa3BBWFNtWG9BWlppaEVST1U4RTJjTTBzeTBidCs2TjNoWEg4T2U1UzNO?=
 =?utf-8?B?cENSRnRmMWNzWmd1WFBubUFxeklxeWxMd25Jb0RtVm14RHlFTUdWaUJXb3Yw?=
 =?utf-8?B?ekZiUXdCeTdzS3c0VUpJSkYyS1Z5TEtXQ0g2UUZFVGU4L1hSQmwxcVlFTHF3?=
 =?utf-8?B?VEhyY0FMaURpWGx5cVlzRjkwMlh4VnhhYXFGaFJqeTlUZTJic3ZKejZJTlFI?=
 =?utf-8?B?S1pjZjJ1dERxRC9yd3kyMjlnTzR6TklFaWphVkUxNXBhNHd5cWZwRUxKamli?=
 =?utf-8?B?bGlNVDdsY1ZzSjVVd2wwWDh3c1VLUG56SDJIZFp3cWx4VEM3bHFpVjhvSndP?=
 =?utf-8?B?bjlVZ1lrWEx3V2dYMGpKY1pGb3JYRmhFWmtvOG45ZmJ2bFlmeS90MXBicVJB?=
 =?utf-8?B?VWMrZmFlRElCcGJRbk55L0JWeUJDc1hOVnZxM1NlY3JJMjY5T3o3UTZSbFli?=
 =?utf-8?B?dk95MkJaQzdFWVcralhnMkVuZDR1cEc4V1RZSDFDVGpSeXlSZThqVkErNm1F?=
 =?utf-8?B?UmlyUGhzM3pkN3hWaURMOUZNbEJCdnhYYjJFTTNGbThWUWlnWDhmZWxIc0lw?=
 =?utf-8?B?NWFGVk51MXFHT24ydU5rNFluZlloeTdvUDNLUkNzK1c5Y1lsN2NIaFEvc2c4?=
 =?utf-8?B?OEZmVm5kVWwveTlMclJhNmJabW5KQUFvaXdqK2k0MEZvKzQvVmhyMlRBMW13?=
 =?utf-8?B?TmY4cFcvNVBSKzFnMlBlTldwUTQ3K2xvUnBITndPVHBHSE9GcmpsSWt3RENk?=
 =?utf-8?B?NDhTK25UN1o1YW1IRnJIa2M1WWhVOCttN2IvVnRNNnlsMlJrUGQxZm13dTRl?=
 =?utf-8?B?WVhwSWdlT0p2NUgrY09VZFhYNzE0UzhNMGZSU0VxeUx2bEZtdHJFNU90Y2lJ?=
 =?utf-8?B?Sm1qWENQUVdwbG10RDlSUFc2N0xyMGRDb25TYUZRK21WYlZ4Y3JCbmxiemZk?=
 =?utf-8?B?WG9zdzkvM3ZjeEczZDlucnA2amNKV3FxcUJwcktSMGZncG9yNnFaTmhuRUR2?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C58D056300B12478DBDF4BAE1D5463D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f6df23-9e3c-4c64-ff97-08de0c6616f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2025 03:42:54.3972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +SvH53Ubsae0q2cd4840Giwz8gQfnlPQ1SwN7Gw0X76TZsUgczcm9ybMnn2/MRk3qeIEFwtCZ68xmOP9J/cSkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7923

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDE3OjEwICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lwX3N2
Yy5oDQo+IGIvaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaA0KPiBpbmRl
eCBhYmUyNGE3M2VlMTkuLjlhNjg2NjkxMmU4MSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51
eC9zb2MvbWVkaWF0ZWsvbXRrX3NpcF9zdmMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L3NvYy9t
ZWRpYXRlay9tdGtfc2lwX3N2Yy5oDQo+IEBAIC0yOCw0ICsyOCw3IEBADQo+IMKgLyogSU9NTVUg
cmVsYXRlZCBTTUMgY2FsbCAqLw0KPiDCoCNkZWZpbmUgTVRLX1NJUF9LRVJORUxfSU9NTVVfQ09O
VFJPTMKgwqAgTVRLX1NJUF9TTUNfQ01EKDB4NTE0KQ0KPiANCj4gKy8qIFVGUyByZWxhdGVkIFNN
QyBjYWxsICovDQo+ICsjZGVmaW5lIE1US19TSVBfVUZTX0NPTlRST0zCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIE1US19TSVBfU01DX0NNRCgweDI3NikNCj4gKw0KPiDCoCNlbmRpZg0KPiANCj4gLS0N
Cj4gMi41MS4wDQo+IA0KDQoNCkhpIE5pY29sYXMsDQoNClBsZWFzZSBzb3J0IHRoZW0gYWNjb3Jk
aW5nIHRvIHRoZSBTSVAgY29tbWFuZCBudW1iZXIgc2VxdWVuY2UuDQoNClRoYW5rcw0KUGV0ZXIN
Cg==
