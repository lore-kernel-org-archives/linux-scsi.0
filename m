Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575D7EAC7;
	Wed, 25 Feb 2026 07:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772003907; cv=fail; b=WgWmX6uqL8wHJU7VGIFFZeivLXLw4zZTDEuGcZTV6LlE4/MxX0PdU77wjFTGdzTffoASzR2/TvK0O5VzFpVxF8LH4/HaIsuaY0MpCKzE3g10d3cAVYWXvJddkKDugius0/vWhuWi5x3NJM0GhR0mpmWozLCav9zIbAEt0/UgYrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772003907; c=relaxed/simple;
	bh=qQ9pGBsAVOKsehrF+A1Z3bFP9quu/oFfYHYg0xDlbgc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kjg4gds7G5n/xL/cqNBAk0RDqTl+wx3Qzqn/K2c9WLmj+MYag0e29Vyb0SPU/iA+fJSAYfBOzjXvrejy4/ZA1PX1gVdmN462xJ9jpcTe1g4XDmxH0xGJWmajVdUph7YklduIRvACSSIdVcgf6ZLZafC3Ij+Aqs4A5b3V1ybhCFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jDsDo5XD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=rKP6p4RC; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jDsDo5XD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="rKP6p4RC"
X-UUID: 295f88de121a11f1bcd7499a721e883d-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=qQ9pGBsAVOKsehrF+A1Z3bFP9quu/oFfYHYg0xDlbgc=;
	b=jDsDo5XDwBukwwDzLaUK+ICuHyuT8VvDxlOrydPYOuZZC9gS491yzWi58A15giCfS4Ml41jXkcEDutZ769iT1lZaJSBMqpZOiWf5uN8Eit0cCRIKXidrdgLUcchUMx19xZhmBueYIhuJg8jIZgD1Qug7d3R1l8o9TQqHGWyPkfw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:8b514a67-72f4-4fd7-9029-304daf1fcc91,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:f65c3f7b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 295f88de121a11f1bcd7499a721e883d-20260225
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 377622599; Wed, 25 Feb 2026 15:18:19 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 15:18:19 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 15:18:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F889uyNeX1jWAgmZjqMNz0ZhVRe/A/mJVKQ2ATuejL1LqSbJ/jMDvZW5Zo74slj05qJVmSYDqsmVcAun3c7QN6reE6cTMolMQut5exhutw7RXnodsETg6GzwFj6bsB5xeOQkM1CNeg2VkXuvnaN6MNQ6EeFdYVakzlR7vVNCqMO7TEGV5rnTx0T8BV91dhEE68P0Xjdhc2JIrHEFrqrZu3aoTRiP+COeXGbTyZhgAjqWB1ZLxzMxL+edUsaO2i/8gO5wIG8A4RFN3izx31TfaLlJuI/nK6B7urMqsjqYw9dcdgW/WzGFBckvM2djUpmZXSk8tVG1wlfrtkXYnIhQbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQ9pGBsAVOKsehrF+A1Z3bFP9quu/oFfYHYg0xDlbgc=;
 b=hV5hogyfAxhvVznqi7r4DXCGxf5iwoVz8Al5B/447yQyiuLdJxv9BL/CXH7Icijghy62uP+dww6J+9TvWSbMdb+G6OWkos0mtRGb9H676LWihqJhSDfsZHjx9fmowvVkHrE7xSQcuTbKj5QBxWvC6kojEeSw/92XHyNLpt6lTwz7IureDqDLCdw0OdSUouYGndI5MVQo7RUwbj4anyDYEdRMZnRHAe7pS6GbL307pM6v8eoROI4kWO0RGoLZjNwgZ8+Vwqi0ZgRGyMG7wJnfpE5htRiVYPVtHGwVVQQd2or++xMx4ANISUFz09wvGkMlTtKD8PjcWGjctky+o2nMgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQ9pGBsAVOKsehrF+A1Z3bFP9quu/oFfYHYg0xDlbgc=;
 b=rKP6p4RC8tSYSJESvfbjuPgS9fAa7X0LX90JCmNrcVaXi7QLXQ9GIEKHYEDlDyG6HCudSgNkNDrcB838MksWaCCNn6S9DINVyLdPv2tGWEBi/bcPHntL96S7JIzU750Laee1pPrRtSEQO/42bB5PwRZ1ixIB/QK/+pCbd9q68E4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB9573.apcprd03.prod.outlook.com (2603:1096:405:39c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 07:18:16 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 07:18:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "broonie@kernel.org" <broonie@kernel.org>
CC: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "kernel@collabora.com"
	<kernel@collabora.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Topic: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Index: AQHcn0nPvDFB0gw0KE2BmOLle5gC1LWR1niAgAACtwCAATYNgA==
Date: Wed, 25 Feb 2026 07:18:15 +0000
Message-ID: <a8d6e71adc6892ba3b7059d50d06481118e7e8cf.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-10-b5f2907c6da7@collabora.com>
	 <2c7c84a2df19624ba9f207fd3fee47a8bdd9d8dc.camel@mediatek.com>
	 <3f4920b2-4697-4897-bdca-65c9f02909d8@sirena.org.uk>
In-Reply-To: <3f4920b2-4697-4897-bdca-65c9f02909d8@sirena.org.uk>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB9573:EE_
x-ms-office365-filtering-correlation-id: 9c09a32b-7645-4a77-656d-08de743e0b55
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RnRqcXI5UkRMMEp3UFFmNlYyQzl4TkZ3Z1F1WERXSERNVmxlSXA0SHBMOW9h?=
 =?utf-8?B?VzdWZk1wTG5SWEpyREFhQmkzbWRpR2wxNGQ2YUhEZ0dMbE5YYUNOQVgrVzVr?=
 =?utf-8?B?Q1pFYkhSY2EvVy9vT2pxOHpFc0FnS0pUMXV4NlpFNkx2SjJLd1J1S2s2c3JN?=
 =?utf-8?B?L3UwZEoyRXlXOExJSG5IZlhlTy9NbnJva2JuRW4yM3pGZldKdXFVK1NhTzk3?=
 =?utf-8?B?MEx5d3VBaFM5S0cwZUtwRXNOSW9FR1puL0pHSzdSRlJTbi85ZGJpUHN0VGQx?=
 =?utf-8?B?VUp3Q1lhTUdYZXpLYTBiajdRTlZ5U0NmTkFPRVRhK1VlSEFGc1pFaE9YNnhs?=
 =?utf-8?B?bVB2OHNhNkJNd1Y5Mkk2ZC9JOWVQTE1LcllqV1hLV2dtYUFiaVZSMUZYc1U4?=
 =?utf-8?B?aHVVdGthN3phT0REMFhmbnBVZlBsU3RKNW9XcXVCSHpVeFVFOXJTZHAyYXhw?=
 =?utf-8?B?V0xFNTBnMnljTTREcVg3UXMvOGlnVTdYZGVQQ2FzRThZMHdVWkRkTDRUSGR3?=
 =?utf-8?B?enVJNVlwdTZ3d1NneThJcDhKSzg1aWZVZXh1T2xrdUxmYllKT1QyS1cvNHUz?=
 =?utf-8?B?TkVXYytmOFBycXVNOGg2aUxIOE85bytLWGx1dlpPZ2tvdnFrOWdpZCtiWWVi?=
 =?utf-8?B?VmowOEYrTGdHLzcwcnR6dVJ0NU9kM2ptcEljKzAxSmcyeW43SUdlVGRBQ0lE?=
 =?utf-8?B?MHdERXZUUzFTR1d5cDd4QUUwSWExazRKaldNMUFPekpSSWc3WG8rOVFEUS8x?=
 =?utf-8?B?YXB4UStYMG8xeVZiOVRuRCs3MjFTQWYvUXdGd0piWWVHYUg5eEFKVFlvNi8z?=
 =?utf-8?B?YXJ4cUdxcm93Unk3T2RoMXZlS2dtVkdQbjQrcXdKcTBmRkl1WmtKMkxSZUh0?=
 =?utf-8?B?d0JvS2pVSXRaWTRBSzJPNmIzR0NJc1k4NjRVTVlHSkRmRE5kczZXY0E4Rkkw?=
 =?utf-8?B?WmZFKzA3bnRkZFlncDJ5bzR4ZzdQSCtjSlhSQ1d5dkxoR3ErYlB1cWh3cWh0?=
 =?utf-8?B?Q2JzcVlBYmlFbjAzdG1qTThZeUdLTlFEbkhZbjBqbzNILzRrd2czVWF6bXdr?=
 =?utf-8?B?azRSUDUxVzczb081UHd0UEtWalNPUy9iWHl5V2VVT0xJdTlUTUcxb2d6MTBO?=
 =?utf-8?B?ZG53cm9YbVFTbWFPMU9PaExEbW5sMVc4bzV4V3cyaWEyaXBidS9WTkswMEFU?=
 =?utf-8?B?LzhWQkJXNmVSdWo1TFd4NElhSUFZRGlSL2pXU2JBVm9Nd2llbVlscTlzdCtz?=
 =?utf-8?B?Nmk5QlFUYlZ5cmZjVEZuMVlQS1FJa3Qvd1V3RTZsYlA4VVN5WGI0TlhtcHdm?=
 =?utf-8?B?Q2l2c29SZlBHZnZzWlZlbTU5UGowVnkxdHhRTTRScENJdEU4NHNiTlM3SkhX?=
 =?utf-8?B?MzUzN3FuS1dCS1oyR29YOGZTRVlndzNtQ0hyaUkrWnZYTytDMDk2NXNlYVB6?=
 =?utf-8?B?dTNoaG9EZWRWdUtpY0xlM2txNzFjM1UxZ1ArZkNGY213WXlTYlRPS3lsZHJQ?=
 =?utf-8?B?bzdEQ0x2RENGSmc1anVxMk5ZQndsa0NiaHpYR1Brc2cyMWNqT2s0RmY3RHRt?=
 =?utf-8?B?SXZLWHNCRmUvUFp4UTc3YUpYTzRTV2NFMVQ4UEh6Zm9Zc1NtS3hpdkVmM1c1?=
 =?utf-8?B?TDVMekdoVEpRRVRMaFZLL21ONytobXU4SXZtbUx2V040TElXRjNDSWZZaGpT?=
 =?utf-8?B?VUZrOE44MEsxUERmRXhrWTF2RWdxZEJub0k3b2ZLYkQ5dkdTbVNUdDFxQWNn?=
 =?utf-8?B?MnNHQmVIenpvOEk0RGdKaU1yRWxnM0FyQUcxbmtBUGtpL2VoZi9GRS8xNzhR?=
 =?utf-8?B?OE1nZnJlMXN6cW5hUlE0Z01LS0gzZHdPd09RRTN4U2RKdDlTZ0ljTUFzQTha?=
 =?utf-8?B?Wm1hbnAyUHRSd09xOUthYmI5V295YWc3UW1DQXF4WEJ5ZVpTRWtTQzZqUWtL?=
 =?utf-8?B?dkh3RHdrWXBySnROckhXcG4yT2ZMaFpTb0JaK0NONjllbHB5YW85WTgzVkc2?=
 =?utf-8?B?RVZ3UWZTUXB3UFNOalZNLzhnU3BrQkRJUjBIT1VjR2h4cjlMRS9DeFoxa0hh?=
 =?utf-8?B?YXVUTFE2N3RvWHh5a3pMK1ozOEh3cjNtSzNiMko0MlpTTnNQaTRJQ2ZKZGJv?=
 =?utf-8?B?ZGZRUFMxWmtFT3k3ZDB4dWJ1Q0RXcjFMK2xBZGl2QWkrd0RGamVHRy9waWVS?=
 =?utf-8?Q?z30KcryUt6ciocyTpjrJKKI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eis5ajBqajdOSk1xUFhrVUd5MGhVYzVuVmErR0s0eUIweFJBMHo4UFIvYjRP?=
 =?utf-8?B?a2VVN3lPbmxCV3FlSWh1QnZTQWtPZll0WDVpZ1kvVjVldkMzSU5zWmNRWFF0?=
 =?utf-8?B?RHZibWpZTzNmeG5QOGRVZmJETGtlWDRYQzZBSkJIem5VcmlQOVMvaGRWc1B3?=
 =?utf-8?B?ZmppcDZRVkZyME42WU93b1YzNEZVdUY5QkJKdVl3bGpxdXZOdTl5Q0xuS2xS?=
 =?utf-8?B?VlRJdEJCNS9mQjd3VDlzeVhwVTl1Wk9FOWltR1VsU0JsYkFrR2hKVjZiOFUw?=
 =?utf-8?B?a2s3UzJldy80WVJmY0ZIMHRQQ1FHd003ZWhncUtncU95NjBnMWdOT2wwY0c0?=
 =?utf-8?B?Vkx3SGt2Q3JGTlkxeHhpRkFaYzRmdG4ydDl0ODRjZEdReDlLdGdXcnVtTmxI?=
 =?utf-8?B?MjNzWVBra3YwWFdJM3BpS3lIV0NlZzBxZy85bWhtV1FLQm9ER3ZGZ055NTNq?=
 =?utf-8?B?N3VXNFQ2a1FVRUh5cHlmdFdDcGdQSStxNFVkbVBaT3pVaklZSG8wMlZYSEp2?=
 =?utf-8?B?N2JKSVJpbTR2a2d6cW4rUnZnNSs0N1QvTEtmL0VWZ28xTEtTM3RONElSRzNj?=
 =?utf-8?B?OE5qaVhmRVN0UFRRRml6aFNsOWZjVXpjck9WNkkyUURYWFNxZXJ2LzQ2dTRW?=
 =?utf-8?B?bGU5WjQzenNLbHNJNjRuVjFsK1pxOXM1aWxPc1hpRVViYUtrL1B0dG56NmNs?=
 =?utf-8?B?ejBUbUpoa3luV3RBTkpub3lodklMNmxWcExBNjlUWXZIMDJUR0ZlR3NyMVhy?=
 =?utf-8?B?eDJ3Ykh6dWJvUGZBQnU1RjBrdjRzK3lWVnJjZUVZZGpDVm45dEJHN3pOWllp?=
 =?utf-8?B?Y1ovY0NxeHEzWDF4Z3ZzUktJaGFXc1I5anF4QkdPc0dxZVloY3QvQmZqUHRp?=
 =?utf-8?B?RzVOMnJBZ3AySVVvNTF4Y2RCQ3l0ZHJwNlE0bEIxV2Z2czFiQ1hqTmE5NDc3?=
 =?utf-8?B?Z1J2QlFnTDRkQkJxcUNrOTFCUEpMR1FpbEhlOWZNYy9zUEJMWGV0Zk9sbEda?=
 =?utf-8?B?QzlFTUdTdlpXa2ZETndTOStLYXA5YlI0MW1iSUtTaDVIZ2RhczNyS1QzZUt3?=
 =?utf-8?B?VWhDcWRZUzZWUEVydDVDdXREWHhMdG1wYWdwNGhkUG9WV21vRVJQTnExaWdC?=
 =?utf-8?B?RWlmWm4vRERESVhHOTZ0U09HWUdxMy9FODJBUUpKcUM0alU4dDJHQ0pqWjJ6?=
 =?utf-8?B?VDE2Q014ZFY4Z3dwNURheWJPUEY0MCtWU0Zpb0hPSGg2cDE4b2xvaVFrVXRH?=
 =?utf-8?B?WVVOZG9yQnV2a3o0Y1E5UjBtZkEvVlMwZlRBQUdySHI5WXhWeGpQNi9VMkUx?=
 =?utf-8?B?RElpMytJMERKTmhOS1hWZFB4dEdkWWN5SGtkWFRsMEVzY09hMkxRZ0xoMFlL?=
 =?utf-8?B?UHgrTTV0NGI2TTlxMWFya2dXd0MrSU5vUHRpbzE1b1dYQkNKU0VlOHF0QTBt?=
 =?utf-8?B?NkYyRWQxMUEvY2tsazBiSnp3bHVGcDlJK2EzTXdWeE1ucGNIK3lOTWdBS1g3?=
 =?utf-8?B?UXFkNWpSWVVrRm1WSnowcWtCTHJHNTkvcHVxenZ4aDlFU1VUd254WERtV1ZV?=
 =?utf-8?B?TkEwSFR3bnJVaHo5aW5wWTdQUS9kUzBqTTdweXdFV3EvNHVudFJZczgwNHFt?=
 =?utf-8?B?cGh5MVVDV1BpVXBud2VCTFNSTU1yKzhmdDNUakYzL2NpVlJVb3doRTJvUlpy?=
 =?utf-8?B?RGlwZmY2eVBUcTNqZmhDR2JHN21qSHN5STY3OHF6WVZ0aGg0QU1IRHZkTEg2?=
 =?utf-8?B?S09ENFVKeEl1UmREcmllSGZwSjk2aWsxUVBTYU41ZktTMzFiRW41YnRLNEtV?=
 =?utf-8?B?WnUyVWx4RnZXTWNTZ0tSajl2Zm52VUdNcSthcEYwWUowQXBKaWdnemNORThF?=
 =?utf-8?B?cWxoVllDNERMM2NiMXhnOW5xZk9xVmxGcWFubFFVbjM0Sk9JZXRTNW1tZXI0?=
 =?utf-8?B?L3NQV2xTdEgvd0VXR0djRXZ0Z0NzSXRQZ1duaWM2anV2VnIxNlN5eUp2a2NE?=
 =?utf-8?B?VHpqZW1vbUdSWHE4Zmd3SWJKaHFMMmVRUldDbHhIVDJncnc0ZHNwTExmSkll?=
 =?utf-8?B?Z1ZiNFRyMisxZ0NBQ0I2Yi9mNzdWUzlZRlJsOUVtOVdsQUNPYW1qZFI1eXJZ?=
 =?utf-8?B?eFl5NWp0TkZPVWNYQXh2bmJ0N1JRVEQzeUN2Wlp2ZjhqVzc4L01tTXRPN05Z?=
 =?utf-8?B?UWRnUE9CRnE1Y1FldFRtb1Y1ZUtLL0xzRWdqR3hwc0pmaTN2VjZYTDJCV1c1?=
 =?utf-8?B?eTBtSEdYNmhEcGxZM01nWklHWlZoTzViMFRnMmJPL1RwTDRXYTIxTUcvaHZ3?=
 =?utf-8?B?dnd2dVVPbU5hbmVYcFhQTnBVUlA3Qnp4T1gzK09zcE1oR1JCVDVwQVVMbmJU?=
 =?utf-8?Q?AhNnLp6pa2yhRi5c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62D30C4CF6621C45A0C7B718398672D1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: tO2qiWMpksuIl4pusc0XFnfQS0VYDrR+rkfOttm4vk7vL1OtP8ugocy23EXl/QOm9jyltPImB8neJxufAh7kQO86tvAYIYXNS75LVDfikKVlyJop2WYUodk3Wn7s33sc0t6fMUDR4/kSNZxuHh6QSFaK00bEpmg161FqCh2gwuBUYTuCH60KqjM4G+f97ArVKrSMSHsj1h7u7ZN4/hmEgU6OyvjkcYnIflom3aAKbbFC+PHAkz/gfdE58A7bmYcvzeZx3tHDibWjNF2ztVgk3iogOUt9VdBXqR8+xtfp4Zop6LmJFa+EElCCKTNhM4CwnrwiirmFmtdLu6Ek+1ie2g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c09a32b-7645-4a77-656d-08de743e0b55
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 07:18:15.9550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i9Nr4HyYhO/MaAlyZUCHlDULe6G0qnOnUh0dH2xSZ+JeqETe0Oq8C3a/KtmpEqiPQb1P3e+OZ20UNjaudsQ7uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB9573
X-MTK: N

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDEyOjQ4ICswMDAwLCBNYXJrIEJyb3duIHdyb3RlOg0KPiBE
cml2ZXJzIHNob3VsZCByZXF1ZXN0IGFuZCBlbmFibGUgYW55IHJlZ3VsYXRvcnMgdGhleSByZXF1
aXJlLCB0aGV5DQo+IHNob3VsZCBub3QgcmVseSBvbiBib2FyZHMgaGFwcGVuaW5nIHRvIGVuYWJs
ZSBhIHN1cHBseSBmb3IgdGhlbS4NCj4gU2ltaWxhcmx5IHRoZSBib2FyZCBzaG91bGQgb25seSBp
bXBvc2UgY29uc3RyYWludHMgdGhhdCBjb21lIGZyb20gdGhlDQo+IHN5c3RlbSBkZXNpZ24sIGl0
IHNob3VsZCBub3QgYXNzdW1lIHRoYXQgZHJpdmVycyB3aWxsIGNvbnRpbnVlIHRvDQo+IGJlaGF2
ZQ0KPiBhcyB0aGV5IGRvLg0KDQoNCkhpIE1hcmssDQoNClRoYW5rIHlvdSBmb3IgeW91ciBkZXRh
aWxlZCBleHBsYW5hdGlvbi4NCg0KUGV0ZXINCg0K
