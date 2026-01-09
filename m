Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815692FA0DF;
	Fri,  9 Jan 2026 08:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767947913; cv=fail; b=ez5/q2WZGkjk+DgPCV+RtJ31mctGd908i/fRX09Z9GhvxbHxGt6bg8Vhd3fs5n1POPMcNqrx/6X5T+5gUIyDpxgqqolAH+MyFqTen4wdXm3TxKu13j6NfeDxyQusCnYZorjHdH3VPa8TuLHKLHkxN9xogFROMdvCargu+DwFSbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767947913; c=relaxed/simple;
	bh=wzM//XdW0y0GTpNyVa0xUCkmom6w12Yh4jdtawAkHe8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OreZXtalLfB5KFotZzPPQwcajnORsQu5ZnIY67/r8OnKU5zs1BbtcBEp3XjQVRT1M8mSlbso106yOs/rFAtNYCb2oppDMTxCX01hI3BbBRsLdbrHbctq0jQs05waVNmWorgfKenCxr0j4miPDv5xXJRwJuXUcCpONZtGG8XJPfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=iBOJtUnn; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ZKu87FyE; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iBOJtUnn";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ZKu87FyE"
X-UUID: 8d5a3fa4ed3611f0bb3cf39eaa2364eb-20260109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=wzM//XdW0y0GTpNyVa0xUCkmom6w12Yh4jdtawAkHe8=;
	b=iBOJtUnnJkgy9/ocaT8xy4DY/kYFpD24+Uv+z8ZUsA+O9SjS4mGGbamcEcK9HR6c3URS+Fv4W+5Vlf34JgcY6aOEI1GAeLAytSd4Ts3O6nQAGXQMedCxYktEdWmOwzI73JVZsN2O/WItUYwmKM1YpMMy039WOWtnYuv3IXJIb60=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:cb9ca914-439a-4adb-bf36-346ab77370b7,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:79e29879-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8d5a3fa4ed3611f0bb3cf39eaa2364eb-20260109
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 905251267; Fri, 09 Jan 2026 16:38:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 16:38:19 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 16:38:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rRwnPyfTgOCTqfhSuTGjzHNsskHXliMcQxE+01TWSI7ZN0pwbfkhnsn4Dyw6mmdsn6ubclWBvMoTKiaW7ZUFLumv85ZIiJpdpFkrqjOj6QPUb2EM2Vb0wAVpCw+e7ZhIJu8bFAkSrquXCVnxaZnq0yTd9dwEsxvjDW5Vy/FGatvfy6KlR+q+qemDYGpAuNFpsqV+NyFjKPJuVBbPC1WnCs4UuuPh1+nYU6F/waTpPuDf1y8FvtrGxH1ILH/Z9XKqHzJsp/XOpx/u3melBlzGOeIeiMX1A7D3SjMrl19WqzOgFaYfxfjCL3zEcP7syOsXdo8ozHwUuQV35MxHZPz0pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wzM//XdW0y0GTpNyVa0xUCkmom6w12Yh4jdtawAkHe8=;
 b=d1q9JN3fM7+N0DFQymxMBF5EoyJPu4TuS/569KEmbWoe7exEhIPNwYLOfjgw7O6SVdC3vxB9viIIIZGlXk2XBa6wjCp4HJbVFAoVenxRcO5fRfEKKwcAdvXEFYNN8G8/DYs3LWQgsxymoi2VqawSWCj4EnjG5qkUJzxA3CXV/+uKakG826TwIRhS4/FnuYUaG9NLNBW1SmsCs7EYTeC+nnSCBiGEnL23fDRcD3gvia/4VXy9ohffPRi3Hr4/nRiGUaOqZqI8rN3IJpZMhzLBoQVRElqiMLyr5cT3bVJE/YvlOmJfBRDeC9//asdTM4nwvNca5i9OHaLiDIgvSzXUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzM//XdW0y0GTpNyVa0xUCkmom6w12Yh4jdtawAkHe8=;
 b=ZKu87FyEV5wzMtDBs8PVcxjFPvqXwpr37anw+9ZY2Oo6A+zb9/Jy4NdhoGazalE+Om3ISwm3/m7PL3orjIrRNR72JaTSyaWaE0EPzXuOALb1JRGCdjni3Rn4qMa+izF5/HxDjhhOU6H2oFTS6X+f5yUYZXPrSUdp5cIHt/T+ZJY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8661.apcprd03.prod.outlook.com (2603:1096:101:22f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 08:38:16 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 08:38:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"p.zabel@pengutronix.de" <p.zabel@pengutronix.de>, "krzk@kernel.org"
	<krzk@kernel.org>, "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "broonie@kernel.org" <broonie@kernel.org>,
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
Subject: Re: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
Thread-Topic: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
Thread-Index: AQHcgIzex50QwHB34kulYV8QY4/tvrVIMsMAgAEs4YCAABE5gIAAFKGA
Date: Fri, 9 Jan 2026 08:38:16 +0000
Message-ID: <e9a6da3998195b9dbda5abd26bc6dd5d3aca07ff.camel@mediatek.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
	 <20260108-mt8196-ufs-v5-11-49215157ec41@collabora.com>
	 <81ed17eb-2170-4e97-b56d-488b5335ff5c@kernel.org>
	 <dd2eba99adaddf7517f06acf7805d32e261fafa4.camel@mediatek.com>
	 <87887adf-2c94-48c2-8f83-4e772ab50f60@kernel.org>
In-Reply-To: <87887adf-2c94-48c2-8f83-4e772ab50f60@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8661:EE_
x-ms-office365-filtering-correlation-id: 15d4b79a-c868-45db-41aa-08de4f5a6f1a
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Um5FdE1GeVYxSDk1bG9NYmUrWklRb29sMUJxdzllZkdjeDdLa0ltWHFSMitk?=
 =?utf-8?B?MmlBeU0xODhvSTlNem9iT1JqK05WaEtBY0JZMlV2MEpzVEtDbS9KQndzcjNk?=
 =?utf-8?B?Uk5ac2ZIZmJKTitmV0o0VFZXeFlRZ21sdGZPMmpseVRVQWRXNEVoWFhzYW9O?=
 =?utf-8?B?dVBLSC9oaHZIS20zZUxkcjVkQ2dxYnR2RXpVUC9zS2wxWWhneVdySnFSUnhI?=
 =?utf-8?B?enMzcFBGOE5FVVQrNWtLeldWdUdwKzNzbFBhMHlCUGVCSXc3QVlUVFJ6dGdI?=
 =?utf-8?B?ZUthTFZBTWFCcG1HbkhoV1lFcVIyZ1EyUUFrakIzVzd6M3EwejZzejNJZmRr?=
 =?utf-8?B?MjZ2aVRiazdWakNQcXYrVTlERVlVa3hpWnNvODVVM21tNXhMQWtUMmx1N3lr?=
 =?utf-8?B?cGVHa0FIYkdNaFJxOHlTQTdsaEJqd0lSdWdENTBGNXc4SG5hSHhReE0ra3Ry?=
 =?utf-8?B?RTI3U3p5czk1T1RwUDZ5RzJQUHFvQVJleC9TSEJZR3JwVW9tR0NtY1FyYk1T?=
 =?utf-8?B?NnE4V0pCcmc2LzA1bnEwNmFEN1llVnh1L2I1dkkzYkk3NitOUWE2a1R1U0k5?=
 =?utf-8?B?cGxhVE04RFlocGJGbXFJVTdQSEZ6bXZHWlhzb1cwUmRFT3h3d2daL3U1RWFI?=
 =?utf-8?B?MFdvMVNDOXYrM0FPVnBzc1pTSU4ySFVCUVU1UnR4K1B5cE1LaVVSMUhKbzI4?=
 =?utf-8?B?RnFrTE1qTUpCcEVicnVnZXBBV3dwTG9RS3BmSUNza3RIWGJiTElRSzNPQVRm?=
 =?utf-8?B?L3VaSkd0b1VzWGtlT2lhc2pKcSszcGd2OUpoWW4zTGErM1dsVFlwL0tvbUd6?=
 =?utf-8?B?TFQ0Qy8vOXNNUWNDU3VkSUFEUGRCazNHTVVHc0ZyNmJEeWRabXl3a2VjS0NE?=
 =?utf-8?B?V3VQaGtYbEVpbEowNXdneU9EdUlTOG5nZHBJK3hNUGhqQStJRVVZRWdrellH?=
 =?utf-8?B?RERkdHRGaitvMVNZUnNVdWF2QjhucUU1Y2FsVVdBQ2lJKzRqRDJXOURsYnNw?=
 =?utf-8?B?VmhsaUNOVEo0QjVHRkRDT2poOXAycmNFL0pjOTRkMlo1N2hhOHlOQitoWXhN?=
 =?utf-8?B?di9lQ1pYVENjZFVZenRjcmdRQVJWUk45enYrd096Zm1tbSs2WWtUZ0VNVklv?=
 =?utf-8?B?MFJmbk5wSk1KZHBuTHM1L3c4NlRndjBuSWhUelFSbVdOc1R5K2xhR0dZdnIz?=
 =?utf-8?B?TWdyL2dtQUtLejBTaUg3ZHN4cllvZllmOE5JUm1jbWRra2lsUHpDTnA1Ukpz?=
 =?utf-8?B?TTRhRnVHRG1sM294L1hLOUY0R2pSS3NwN0F5dXRFbWhRd3NVNVUxMTRJZ0Fh?=
 =?utf-8?B?Y2JaRXNLQk9pNjQybXFzTkRnM0FTeENidWNxZXg0THB4SHZESmh0U213WU13?=
 =?utf-8?B?eFZNaXRldHpTVEZiOG1zdzRQc3BsdEFVU2hpZE4xaWsvM2tPR2V0NmVEK25s?=
 =?utf-8?B?Q0ltQnkyZklZemx4ZmpHVUF0MW5BSncyQ2RsOUh6RmhhT1lCYW9SMTBEU3V2?=
 =?utf-8?B?cnlHdDMzL2wrWjRJQjlUMmE5b1gvaHAvMXE5dk9YYm52eWNJRVhNOGw4OEEv?=
 =?utf-8?B?RG90SC83UnA3ZkdpWDg5ei8rLzk2SFVZa2FzeXc4YThINVM1SFAxOFVlZEFs?=
 =?utf-8?B?LzB1SVh2UDlQaVpyUVUxdVZteXNuUWxzWEYzeXUxRlJqcUhEN00wT1RQUFpO?=
 =?utf-8?B?NHhFd3N1aDZGS0IxaHhUTGtTTzRuNjRGRi9WdTFlemswMTB0Zy9zYUVpK0l0?=
 =?utf-8?B?U2hwN2tOQmJkaDNtLzgyZ00xVGtRK2pTWUhDSjNDb2R6WEtrS3BpQ2RDWmNV?=
 =?utf-8?B?WkhNSDRxM1FvYkZWOXZqWEhtR2IxaytWaGRqVjV2TWM3Y2FKR1ErbW1jQzlJ?=
 =?utf-8?B?bWJXSG1zZlJLanZuZWdoRzFWZkhaanZMMVBoampaQnlwMnAzaHlPamtQSWMz?=
 =?utf-8?B?YVBZTjBWRmliRU5FZGZJWWlXbjM3NGMxbDVwYWRBMDE2SmZBR0FDYmFLbUlZ?=
 =?utf-8?B?bGdUU2gwVlY3VXVuSkV6S2J5YXcxeGVJR1Vjc0psZU02b2ovRW95QS9CODQ1?=
 =?utf-8?B?SDV0c0t4Rzl6YkZSaVAzQUJZbUZFZTFNRkVGUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3RjZEZNdkhrelA3Y1dvRlBMSnlqc1Z3UGZ2V2tkRWY3RGVNcWZrbnE0dVly?=
 =?utf-8?B?WW9URWV4ZDFqbDB3N0N1eDNmNG5sVUc3QnpuU0wyUnVUVGRkT3VsRENkN0FE?=
 =?utf-8?B?Y3lwa1huckpQWDNFQzFpUEJTT3ByeXUvQmZWcnhYc3d2cWdVZmw5WlpTd3ps?=
 =?utf-8?B?QVhKczc3eWxTTWRqSmxCa1lYLytXbWpNajhZY3ZNRXRlSUUxdGdTaDZ1Vk9F?=
 =?utf-8?B?MXdVMmxqSDNkTzlBbWJORlB5VnNUejhOV3o4SlNBTjJpL0s3dEpYd3ZHRURy?=
 =?utf-8?B?eUZmTW8rQ3JkV3FaS3VxY2QrQlA5ak9YYlVNajNkTHkrK2pEYkk3d1JqNTl4?=
 =?utf-8?B?Y0NibkM5N3NESWRMd3djeWp1NjlOdVEwSHBueCs0R3pnazdNeTlDQlFHODNQ?=
 =?utf-8?B?akdTWXdoZ3hwR1c1M20rSTBmMWh6a1hHS0xwWDhpVkppcXRhT1Z3YnVYUVkz?=
 =?utf-8?B?MjRZVk5EZXVQOVh4TGpPY29HODA4N3JWdEpQQmN5UHY5L1VUdHVDbFdpM0Mv?=
 =?utf-8?B?S2VDSFIybGtHaHVFMm8rTVBoUEdjdjlHV1ZSSEg3NWNBeXFNY2FuRERhQ0Vy?=
 =?utf-8?B?VVo3dHlueklPOTZ1NlJ3NWNSYUxISnlhVERzQ2NBWW8vcWtZSnRRTmxuU2Vj?=
 =?utf-8?B?TmpKR2RJR1ZsNk1hb21PbmhpeXpURVBxVmY1UGNiVFd1cU1LSDJQVEVsby9Y?=
 =?utf-8?B?YWNMRXdRYVpacmVCMGtGUDlVaDgySkdhQUpteHdxMGlqWEFWZFllRmhTK1RW?=
 =?utf-8?B?VEpqTjJDd2g3VEVkWEtqWVd2WVI4SnZpWUxKKzNmbGFVUFlONDNIV0dwT3ZF?=
 =?utf-8?B?OTlSMUhxcnA4bVRVcmt1b0k0bTljVjVoVGVGamtiVDJONHBwbWt0K0pGSVlz?=
 =?utf-8?B?ZFRUNFJ4Mks3Y2VZdnZRUStESWJMYnVMbkdVcytMTGdKMTQwL1ZOdDdmKzRw?=
 =?utf-8?B?S2E2ZGdZZW0wR1NKR0YyQTJMVFZxWUFSNC8ra2JPM25RNVFKUkZMTGJQY0dJ?=
 =?utf-8?B?WWp6ZnQ4YXZxTE91UGlDZVJ4Z0ZpQ3JwVERFSUllR3ZibWhFRXA3a2MrU3Jk?=
 =?utf-8?B?Sy9tMFBLMER3OUV1T200dTFjRUI0dU9sOVF0aFBEU3pUY0FrRzdGdHVkVU9Z?=
 =?utf-8?B?eGFsTkJsd2pIWUQxL0JuS3RiNi9XVXFYMXRjcmVKS3JvTTRSSGt6VnVPUWxD?=
 =?utf-8?B?RHJETWVPanE0Sy9jMWFKVkNqbGo0a3BjWDVBUW0wREZRYlRZWEVlL3VRdW5m?=
 =?utf-8?B?Z0ZYMi9uWUNTZ0prNU9LeTAvREs5cndrMStlTEh2YUpRWXdzZk5BcHJjR0NR?=
 =?utf-8?B?ODRsdHhYUG9NRGMxSjZDNlo4ZVFyTU83VlovTit3OVJsWHZxM3NrOEE2a2FV?=
 =?utf-8?B?dGRXMDZjSHUxNTNtY0VEemFxOFhJNXFLNWMxZWRnbWo5Z01PZWRMeDFqSlVn?=
 =?utf-8?B?dHBXdHNZTEFUd2VTS1V2N2hRU0tTNkFjeEZoblZjbTNBcDU2SGNYOHRtUFVL?=
 =?utf-8?B?amI5ZU5MVjdaaXp5OEsycXpPQk9Nd05lWWVxQzN2K2tXN01lOUVzSHZRYlUy?=
 =?utf-8?B?czM5VHV0ZE9velliSG81Q2I0b0ZRbkpCcHQ1VmFXc3V3cEx6WFoyY29reWpB?=
 =?utf-8?B?SkdZYjZkZVpHUkl3d1RtYys5Sk1vTlpJbnptRnNpY2wyaTRJck9TSm9wNis5?=
 =?utf-8?B?UVJ4SkgzNkhld1ZxVXZmazNudlIxSEpEcW9zOHZ0SlFaTmZXUkh3aHgxbWFl?=
 =?utf-8?B?SEtDdG5NVUF2djl4djdDejRvSHp0RUh6R1RjODhpYjNQMStlZGJwMHFDa1Fn?=
 =?utf-8?B?SGhwMnU2RTRZQ2FPQ3ZXaDBoM2RsN21SUnZMR0xXeUx3ZGRTWUNxbVhpN1cx?=
 =?utf-8?B?UTltN2EzcVBnOC9GMlBOYzRIR2VmTm1DazNlM0NONWU4MUlkbmczMVRHTmRZ?=
 =?utf-8?B?QkV5bTczQ2lsSVZTc2RhQkhCMy9DWjkzb2Q0SjJhZzUvdTR5S0xTVytTcWVV?=
 =?utf-8?B?RDJyRHhtVXVJSDBJWjc1OERWTng0K2U4aW83U1BmME1IUFJyU254Y1l1cnU0?=
 =?utf-8?B?cTZMcHVHc1hyMFFBcTByc055M3FQSkVWNHdHbEFPWk1Kb0RGY0J4Z2s2d3Zj?=
 =?utf-8?B?cXljZW1NS3VZMFBuV3BXeVhXQ05qNGt3VEthM3ZBUE8vR1grNSsxK1VXd2xm?=
 =?utf-8?B?Ry9QVjFKdk42OHpHWHUzdmZLMy9xTG1jMFV2WUxTSmpQMXdJYnN3YlBIK2Rh?=
 =?utf-8?B?MGR5am9mZS9lWHlSckZkYnNNTUUwc215dGpvS3BTYjU2Sm1INXBtNUU1aTJV?=
 =?utf-8?B?OVdUVU5HdDFnK1pwaXJBaU9Sdk9ZWmtMYnJRN3hjVVRCYXcvc2tIbzlRMTVp?=
 =?utf-8?Q?RcEf4imUZheS8ETU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39385A5A385CC847A17612FB59E9D24C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d4b79a-c868-45db-41aa-08de4f5a6f1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 08:38:16.1763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x/UJEnidKzxFKDja2GWUnhcw4TjmzJxKGejmYufC1YTRkektzgJz4/G+kf0YUCD1rmbo9Dp7E3w9D+mbp+HC0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8661
X-MTK: N

T24gRnJpLCAyMDI2LTAxLTA5IGF0IDA4OjI0ICswMTAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiBPbiAwOS8wMS8yMDI2IDA3OjIyLCBQZXRlciBXYW5nICjnjovkv6Hlj4spIHdyb3Rl
Og0KPiA+IA0KPiA+IA0KPiA+IElzIGl0IHN1ZmZpY2llbnQgZm9yIHVzIHRvIHN1cHBsZW1lbnQg
dGhlIEFCSSBkb2N1bWVudD8NCj4gPiBUaGlzIEFCSSBtaWdodCBhZmZlY3QgdGhlIGFiaWxpdHkg
dG8gcmVzZXQgYW5kIHJlY292ZXIgYWZ0ZXIgDQo+ID4gYW4gVUZTIGVycm9yIGluIHVwc3RyZWFt
IHdvcmxkLg0KPiANCj4gDQo+IEluIG5vcm1hbCBjYXNlIHllcywgYnV0IEkgY2Fubm90IGltYWdp
bmUgYXJndW1lbnRzIGp1c3RpZnlpbmcgeW91cg0KPiB1c2FnZQ0KPiBvZiBUSSBwcm9wZXJ0aWVz
LiBCYXNpY2FsbHkgaXQgd291bGQgbm90IHBhc3MgcmV2aWV3Lg0KPiANCj4gQmVzdCByZWdhcmRz
LA0KPiBLcnp5c3p0b2YNCg0KDQpZZXMsIHRoaXMgcGFydCBpcyBpbmRlZWQgYmVjYXVzZSBNZWRp
YVRla+KAmXMgcmVzZXQgaGFyZHdhcmUgDQppbXBsZW1lbnRhdGlvbiBpcyB0aGUgc2FtZSBhcyBU
SeKAmXMuIFRoYXTigJlzIHdoeSB3ZSB1c2VkIOKAnGNvbXBhdGlibGXigJ0gDQppbnN0ZWFkIG9m
IGFjdHVhbGx5IGltcGxlbWVudGluZyBNZWRpYVRla+KAmXMgb3duIHJlc2V0IGNvbnRyb2xsZXIu
DQpTbywgYXJlIHlvdSBzdWdnZXN0aW5nIHRoYXQgd2UgdXBzdHJlYW0gYSBNZWRpYVRlayByZXNl
dCBjb250cm9sbGVyLA0KZXZlbiB0aG91Z2ggdGhlIGNvZGUgaXMgYWxtb3N0IGlkZW50aWNhbCB0
byBUSeKAmXM/DQoNClRoYW5rcw0KUGV0ZXINCg0K
