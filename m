Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B011E1E1F;
	Wed, 19 Mar 2025 07:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742371005; cv=fail; b=Xu5lkUj8HvbYJenNdoNxRibiHv4IsXSZ5OAF+8g4dmwOV2pZXNtPs+1jCpg5hQTGFePfzsPMrEhqbXp9qL0cOqURjdtjNG8NF+RW2J4K9HkNtADPhqi0WiVgNHJIUg2jK6QUAShHXKmTIdAEC6zmEZB3fhHsHquk4RgZLJCXaA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742371005; c=relaxed/simple;
	bh=REIO5lmSmLEU26iAidA1FVLvrRRN+FnROnLV6GmFq0E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PObNBeb3U/vrViZP2OfP6L+8NPPLioPuxyM4QWVbKbQpx0tEzKnFZixzXdJe3UZMD2scrblqAp6XYSMGidiU29no1f2ahCH1fNxnXvBrkHO2CQpGHNoHzvKGKNE+D72pamawzBw+TgiGAYneHJrGPN1xX4GGTPq4uQnPPaInrcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=M+7qYktI; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IXhlncW3; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="M+7qYktI";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IXhlncW3"
X-UUID: ade9475c049711f08eb9c36241bbb6fb-20250319
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=REIO5lmSmLEU26iAidA1FVLvrRRN+FnROnLV6GmFq0E=;
	b=M+7qYktIIZ/YvX7xXeqRpmq5bYp739cb6eBWWIr0/rcvPXfEx2+8gGsc0pybhisq7WPpzzBWu1Z3Of9XgkiMqF+yDalzsSW/jhAoGzPj7BJjSYqp/0HM4R95ZEJZBMV8hhZYbfk/OLfLBuvkaqd58LSiUV87nRlP5lXmaaot9Ns=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:8381a214-4228-4b93-ad56-7220af9cc397,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:4bea908c-f5b8-47d5-8cf3-b68fe7530c9a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: ade9475c049711f08eb9c36241bbb6fb-20250319
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2024805610; Wed, 19 Mar 2025 15:56:35 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 19 Mar 2025 15:56:34 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 19 Mar 2025 15:56:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/DyQ1gt6GHQcq7rJYkNNcCOQm18k/WwuF9dyzOjTCpV8g5XcBv73saN+ANOTBuOVnGMZddEeL/HxPqL2fit8orhh5iYT62ScvF/n5SpeA1ci03dCu44yyHb3Q+ZDa4Fk6A5a9jGWnzNDWHevmXNa+o9wG7khpwsl4GPF9sZdSAlU9UmY+r+2yudcmwVxjlYGc0gKzqxMfg8+34jijn9wPsnoIHZL1GJTY48EYoy/daz0t2XUHG46Oxd14eANmIZVPTupcNKhXuhUrpad486MoRvRxH7ygeTVqANFzSTAm6oDKuyIHJWhNYP5n4bhKT6+fI5H6vzRxvxZAWAaBHv+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REIO5lmSmLEU26iAidA1FVLvrRRN+FnROnLV6GmFq0E=;
 b=LUjRCNONQdsTFiIIURPngyqL3JKyUuQIBHcFAlXDhdWAk3plxoagh0UC3KcJyluLZtd4beYYD4y4FFDuBSNI4EQrBepzBGFqeyS08j2KRghTlEAEn8Wq77j4khtcMINx5tukOr/IY/8Z2ZkK8sYVdOYEJNLEMAY9Fx5tb0IeXuQzQFTuBmzD2G4ETeGUwtaoNb8w6KNAEFBjwWzKjbY29UjgzVEYhh6n2/knEzDTCz4/ySGoMYaQfcEEQrH4GoqMG+qK1sNzqrBDKc28lblR5pdeh2zcLr1W0S0NId+1udXZnF2lwftKnPLh1xyVbLbobLBlVtZy3fnl73UG84ODMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REIO5lmSmLEU26iAidA1FVLvrRRN+FnROnLV6GmFq0E=;
 b=IXhlncW3jAvdCAHg2CbmWFm4nwmvtQ+LehAZp5Pi4+yUhvOLpkYSPc4NrI3dj0N9LnzgBtCkeWpRyvYVZOXRRAsSVTcwA/LVwgD4YGZVpZ8tk1Ne9HDlhbzm0PnaFLN/y9EQGV3CSAMX6R9xPy4oF6sk5tq+WVtpbECycPIulO0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8690.apcprd03.prod.outlook.com (2603:1096:405:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 07:56:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8534.034; Wed, 19 Mar 2025
 07:56:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "gwendal@chromium.org" <gwendal@chromium.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "AngeloGioacchino
 Del Regno" <angelogioacchino.delregno@collabora.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"keosung.park@samsung.com" <keosung.park@samsung.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: add device level exception
 support
Thread-Topic: [PATCH v3 1/1] scsi: ufs: core: add device level exception
 support
Thread-Index: AQHbmKDWD55Hgm4oDkCkysxiHSOSWrN6F5cA
Date: Wed, 19 Mar 2025 07:56:31 +0000
Message-ID: <61570104d58cef22716fefe459c0c45670108aad.camel@mediatek.com>
References: <6109425449ac4d18249ce7254e4fa1252138a94a.1742369183.git.quic_nguyenb@quicinc.com>
In-Reply-To: <6109425449ac4d18249ce7254e4fa1252138a94a.1742369183.git.quic_nguyenb@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8690:EE_
x-ms-office365-filtering-correlation-id: e2416087-dfa9-4161-a644-08dd66bb8fc6
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SU9yT2ZaakQvSzNCWkQrZUM3VEt2VW90MENwZS93T0xaY00rVEJNanFaWW9I?=
 =?utf-8?B?MSt0Qi8wZlc5bkRUUVdLWVhHYXczeDVrTlU0amVlSDQ1ekRTNml5b2psSkNz?=
 =?utf-8?B?YTloU00vemN6MDA5bFgrYWNHSVB6ZEdUbmlwQmhKZHFXZGp2NHB0aHpoOVJF?=
 =?utf-8?B?U0tEZ1ZraUdTaTcvK2hua29id3hMTXorbE5wOVNHeXVac3duTWlYVkZTVUc0?=
 =?utf-8?B?b1ViRDJoclFiL1cwUXZsRlJiWkF5eFo5R2VOQVJTTU10QTJ2WFBtZFBFV09s?=
 =?utf-8?B?Z0pPblpuWk9xUU1UQnNxTTJzQWxSelNRcW5zQ2FwcFdKNHJZNFRadXY5dzNF?=
 =?utf-8?B?UzUxVkhQVjJHa2dXR0ZiYlNFRkVJa2pzY1dzbjRVcG1adWZQU1pZK3VYNERl?=
 =?utf-8?B?YWM0dDB0a0p1Y3hqYklpR1NoV2IyQURHMk1xSlVGRHZrb3IyVFUvNmxFYmFT?=
 =?utf-8?B?VW56b1F6OXJCLytxcUtJTTFFVEd2Yy9yTnZJa2JSaXNyUmtJeWR0WlU5WUJp?=
 =?utf-8?B?UGU0MGJLMjA2YzZEU1JGOHpMNjMxWWFKU3ZmMm9ndm9oajFJbis0KzVlOXRV?=
 =?utf-8?B?RjZFUTlxQ0pPU0kwSHZSMkd4aTg4dWpjQU5QalNjbVRMWmpndU9GZGlYK1RD?=
 =?utf-8?B?SWtCNEpWQ0F4RFY4ZDZTaUtTMGt3bTlEMDBLQ2pESkUrdUZKeGxvUnVrYTFI?=
 =?utf-8?B?b21hS2RDL08yV2YvQjlhcGYvVjQ1R2kvaTJMMGl1T3h5ODZMdlpRdytLRW85?=
 =?utf-8?B?WFEzalBiSkhGMDQvWUJLNHhHem9FSThuQTh3WnUvZ21sUVN0ZnlpNmZNaGFy?=
 =?utf-8?B?K1lVOXZCaDZzRzBtOGVUTnJzckJ3em9TRU9XL2h2NkI5UHgzZmFPanp3R01I?=
 =?utf-8?B?R1ZyTFRwTW9xTlBxNDM0OGJFUGltVUdWVkdadjRtYXZoaTFLQUtybFlDSlJX?=
 =?utf-8?B?SlI5c0NzU1QrNFlYaVhjejg5L1FYRy9jZGFvbmxDZFNNbFFoMWNJV3g0K0Mx?=
 =?utf-8?B?dVJwM3RKY21rVHVoOHJpdEN4K0hnSXBmMGZlUG1TQTh5MnlQUVVOSDZhZ2Ja?=
 =?utf-8?B?Uzl3cWQ1WUFCVEtIa0pmajYwZlJIUHR1QnQzZUlOb20yczhYV3RWYklPQUl4?=
 =?utf-8?B?RHlYc1NyK2lNK1hnYk9PeEtFeGhZcEt6Tm5BQk9HbGtOUFlZZmpadjNadjRX?=
 =?utf-8?B?STlCUDhCZlRXbXNpSVRQY1RRaDBzb05Mc21ZSUVPYnBjL2thaS9hR0hKZ1dN?=
 =?utf-8?B?UVluVW9JaFAyTVhCOERjdDQ5c0w4WTNjTFJHVmp6Qy9Da1JSMm4wTWpGKzg1?=
 =?utf-8?B?V0ErR3Q5b1RlZTBMUVRHdXJPQk5rS0YwTmpxME15a21HYzBSaExWYTdyZ2l2?=
 =?utf-8?B?ZFpBT1ZwbzRJVTNDckJjT0xLZ3NLU3NMMmRZUHFmYkxYU3gzSjJLMSs4TFM5?=
 =?utf-8?B?NVkxaXJ0U1EwQVAvS3VWM0wwZTM2RlNseTljMGxmYW1jSXlWeVkxanFNZkRY?=
 =?utf-8?B?UVJ6am95NW1YTTd3WmwvSXJ3Ym1NWnBJWTJCZk9BWjNMQWV2aktEc05rN2dw?=
 =?utf-8?B?aXVLNHVWdTk3eFowcEVGeEg4RDh0SC9CRHY1YzVITktseWhBN2FscGFPVDRC?=
 =?utf-8?B?bUFXU2dpQXU2dlFoQXZHMDRuRUFoaXYxRWVzOU90M1ByYW03R3gwc1p1ZVZI?=
 =?utf-8?B?Z0hWQ2lPS2UvMGZldFRURkNSRWJMb3dUTndiaUdPWWxKaSsrRlRCZnpUejdM?=
 =?utf-8?B?SUEvRDFHdU53U24vbmtXZ3NUbWdDOURib1p3Mng2VFp6dS9CRkIyS1BrcEIr?=
 =?utf-8?B?aTQrdnhiUEV2clE1S3ZZVGJwWWx4V2l2ZjFvcGplQTByVm5jMGpzVDVMQXZQ?=
 =?utf-8?B?TmUzNWI2aUhuVzJxRnJJKzR5cHJINThjM2NjUmFaYzNDYTdtSFdXMHNXVFMw?=
 =?utf-8?Q?kYhHtAcJTvFGUqnOLXAMFZnCihyxT9Yl?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OStsNnM3SzgzaTNJbmVJVS8zWUIrakZrd0k3enBQRHFPNU1JMzYwQzF3cnFo?=
 =?utf-8?B?blRreU1QdWNGZkNieENTQUdBWGdKR1FOU0JGeUlWUThCOU5uR213WTE0UVEx?=
 =?utf-8?B?MDhkUmg0T3U2bytRSXNGUEdtZTFZOThQazJHTWcxT2l1YnllSUZ1U2lBb2h2?=
 =?utf-8?B?QzBoK3ZoSlFvb0ZjUURzeFlnOFdiNFJaMEpQNVFpVXhRdnlUUXpWRURIL1k0?=
 =?utf-8?B?YjI3RVg4ZW5DZVAzTndIOG9HR0x5VUUrSzQwMmtnZGh5WkUwTTJlMmlQRTZs?=
 =?utf-8?B?L1dQWUwwRS9WdThkMDBaNWdGWTNFNm16QXphQmt5djBKcndPWjlnYXVsMGxX?=
 =?utf-8?B?L2hWcndSUWJJOWtuRXdEOUNyc29DKzFwVmZyV1hIeVdHbGs2QjErUFo5OUxh?=
 =?utf-8?B?cnJ5SWpsdmQ0Tk83enFBOGNEaVJoQXVFRzAwZzU5RHNFelpUNWRxakxUVmEz?=
 =?utf-8?B?SE9NUjF1RGxrdzZwaUloZDBnb0R2Zy9CM2oxTWo1SEZzTW9EbkxxbG9YYnMw?=
 =?utf-8?B?bjJCQlRTWm54ZlFHVEl5OXlNVDFTbk9WcVB0bHpqYTNTNk01M3hiQ011VDh5?=
 =?utf-8?B?UHEvcHNsaSs5bytNK2QzYWpoeDFQK3ZEVVRrRzhKUkdZU0o2a1FWU3g4TUZW?=
 =?utf-8?B?c2RjSmRCclovWDhzdXVVMHZYR2FlSUlCKzhBR21MRXkxWXRHUUlXVmxWKy9B?=
 =?utf-8?B?WFlzbENwL0VhMGxPczdBOEtTcCtHblhzT0ltbjZ6RXQya1RCYVpKT0paUnk0?=
 =?utf-8?B?QlNuZGhtZVRZTFhQaXhCTFBVRU14SDZVSDZ5Yk83L0djS3FqRUx2b2RyS3VN?=
 =?utf-8?B?Rkg4VHZqWXlUNUU2NEc2ZXdtaFhtRHduKzlwb3FIRGpLL3llWHNYN293QlRk?=
 =?utf-8?B?b0duajFSRlVXRHpjUkVocDZwQTVreTI5RXZwaVcwLzdlZVh4NU9VQThqK2c0?=
 =?utf-8?B?QzZXek95eVJmOHhaQTIxa0V4RXZHUlRhU2RyLzZxN0hNQnordlN2ckpiWGdz?=
 =?utf-8?B?WjRLSEFQY1NFaERFeU9tZ3VSdStOM1hrVkJFZklGL1BnOXUzVitwU3NuVXlS?=
 =?utf-8?B?OXluUWxkYnkzSWpNOEZLWlJvY25ORjR2WHU2ejNncnFMbWhqSld6Vmg2aGpn?=
 =?utf-8?B?RWx3cy9CdmZOcDRLNVBTQ1VMbnEzdjlYbWNGa1NKVVdnYjN2cUZzbW16WS84?=
 =?utf-8?B?Mno1eDN3amhVaTlTLzB1a0VUdXpZNldoWWV6VWMvd0F6L3pJWHJxVTVjMjF5?=
 =?utf-8?B?b25QQzFydjlYaEg1a0gwaU1ucXZZZy94dE5ZNmNTREE5UDJKMmhSRnVKZ2l6?=
 =?utf-8?B?c1BFUXFvb3MxMHdMVFdPMmxBS05wb0dUWkRQaG9ZeUdnbEJwd254blYvNXho?=
 =?utf-8?B?SnIwTm9zLy9kajVrZXVucG5FRHVuSG5lSXFKRHk4aUpQV0F3UTltU1FzMUJZ?=
 =?utf-8?B?Q2NFWUNLaVV2T01NdkhJVXZWVGZLVXhxejlqeE4va1VETE9xUllNdVliTllq?=
 =?utf-8?B?dDU0eWpGTGVCWk85OGVraUw1b25oejNpa2U5QWl3N2RiT1dYd0NZRTdBL3dp?=
 =?utf-8?B?K1d0dHRncDk1SmxsRStCandJZXJZTjc5eGFsUzdmTVdpdC9tMTU3QUxISHFZ?=
 =?utf-8?B?SFpCam1FM1VYV0xrcE5yZjlaYjRUdFgzRCtOUUI1eFJxNUdsWFhSZUZrWlpj?=
 =?utf-8?B?VDFFZThzMEtEdjlGUGozMDV6WEtQWXZ1NzNjTHlPUVVONWh6S29xSUNRcVFY?=
 =?utf-8?B?QVJScDdsanAxMG9iekw4MHlsZXQycXBORWltZDJFRndmVEUvM296TU5ESDVw?=
 =?utf-8?B?THA4bW9vWmxTeGt4Rng5WUNxbXJjVTNxcDF5QXE0aG9vVlljTnY5NVo3cXpY?=
 =?utf-8?B?QlltR0k5N1MzU1pnTk16TEk1RDJHUTg2UEZTZ1JOMzRkUUVjajFDTUIrWmQ5?=
 =?utf-8?B?Q1VZdXV5RWNLZHBhVU9HK3c1VlFOTzU0Qlc2ZHloaytvMFA4SVZpWjhiOGdi?=
 =?utf-8?B?MkhreUJjelVCUW5veFZzcnlCREJ1L0NzbmxLSjUzOXdzTmsxZk1Od09vWjlU?=
 =?utf-8?B?bTFkWW0rNXpsTE16bjBrTzZPcnRXRmp6YW1mRXlYMFpUV2oxM3ZhRG9taWhw?=
 =?utf-8?B?cWpWbXB1TjdZT0FtdjRpOEd4VC82Qkh5MWdLVldVclB4dVNzZzBjNy9BSDRz?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DB0B982E0399C4BB8C95D2CEE0A2287@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2416087-dfa9-4161-a644-08dd66bb8fc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2025 07:56:31.3196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RUof51M5RKnu4Fyx4/zAlrhxb+5fkPJUXPvg1AYkeMDPaAHfEtIP7anQ+WIPC2qQxN4znfmFicFqIxaeiUNwMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8690

T24gV2VkLCAyMDI1LTAzLTE5IGF0IDAwOjI5IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0aGUg
Y29udGVudC4NCj4gDQo+IA0KPiBUaGUgdWZzIGRldmljZSBKRURFQyBzcGVjaWZpY2F0aW9uIHZl
cnNpb24gNC4xIGFkZHMgc3VwcG9ydCBmb3IgdGhlDQo+IGRldmljZSBsZXZlbCBleGNlcHRpb24g
ZXZlbnRzLiBUbyBzdXBwb3J0IHRoaXMgbmV3IGRldmljZSBsZXZlbA0KPiBleGNlcHRpb24gZmVh
dHVyZSwgZXhwb3NlIHR3byBuZXcgc3lzZnMgbm9kZXMgYmVsb3cgdG8gcHJvdmlkZQ0KPiB0aGUg
dXNlciBzcGFjZSBhY2Nlc3MgdG8gdGhlIGRldmljZSBsZXZlbCBleGNlcHRpb24gaW5mb3JtYXRp
b24uDQo+IC9zeXMvYnVzL3BsYXRmb3JtL2RyaXZlcnMvdWZzaGNkLyovZGV2aWNlX2x2bF9leGNl
cHRpb25fY291bnQNCj4gL3N5cy9idXMvcGxhdGZvcm0vZHJpdmVycy91ZnNoY2QvKi9kZXZpY2Vf
bHZsX2V4Y2VwdGlvbl9pZA0KPiANCj4gVGhlIGRldmljZV9sdmxfZXhjZXB0aW9uX2NvdW50IHN5
c2ZzIG5vZGUgcmVwb3J0cyB0aGUgbnVtYmVyIG9mDQo+IGRldmljZSBsZXZlbCBleGNlcHRpb25z
IHRoYXQgaGF2ZSBvY2N1cnJlZCBzaW5jZSB0aGUgbGFzdCB0aW1lDQo+IHRoaXMgdmFyaWFibGUg
aXMgcmVzZXQuIFdyaXRpbmcgYSB2YWx1ZSBvZiAwIHdpbGwgcmVzZXQgaXQuDQo+IFRoZSBkZXZp
Y2VfbHZsX2V4Y2VwdGlvbl9pZCByZXBvcnRzIHRoZSBleGNlcHRpb24gSUQgd2hpY2ggaXMgdGhl
DQo+IHFEZXZpY2VMZXZlbEV4Y2VwdGlvbklEIGF0dHJpYnV0ZSBvZiB0aGUgZGV2aWNlIEpFREVD
IHNwZWNpZmljYXRpb25zDQo+IHZlcnNpb24gNC4xIGFuZCBsYXRlci4gVGhlIHVzZXIgc3BhY2Ug
YXBwbGljYXRpb24gY2FuIHF1ZXJ5IHRoZXNlDQo+IHN5c2ZzIG5vZGVzIHRvIGdldCBtb3JlIGlu
Zm9ybWF0aW9uIGFib3V0IHRoZSBkZXZpY2UgbGV2ZWwgZXhjZXB0aW9uLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQmFvIEQuIE5ndXllbiA8cXVpY19uZ3V5ZW5iQHF1aWNpbmMuY29tPg0KPiBSZXZp
ZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiBD
aGFuZ2VzIGluIHYzOg0KPiAxLiBBZGQgcHJvdGVjdGlvbiBmb3IgaGJhLT5kZXZfbHZsX2V4Y2Vw
dGlvbl9jb3VudCBhY2Nlc3NlcyBpbg0KPiBkaWZmZXJlbnQNCj4gY29udGV4dHMgKEJhcnQncyBj
b21tZW50KS4NCg0KSGkgQmFvLA0KDQpDb3VsZCB1c2UgYXRvbWljX3QgZm9yIGNvdW50ZXIgcHJv
dGVjdD8NCg0KVGhhbmtzLg0KUGV0ZXINCg0K
