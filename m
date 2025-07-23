Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF73276056;
	Wed, 23 Jul 2025 07:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753256054; cv=fail; b=Fs9tug8/KwuvbjUgclVD+/goJxEPCpGEAF6hOtXFxQQDJrBzUVUg8Xz8mLKu3Ub6nLSx9bhSFetFjz/LhFfSebrS23EChrfGj+fPLAJkFzz4cgjDtSUtDqUbmaNHtVgF3iOqBT5bYyA7on+YEG3NOboCmDVwJVP066IRZRuHjrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753256054; c=relaxed/simple;
	bh=72zJczENI9mMLSyWioiG01adsfJgABKyNwMN86fngcc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bd8C5x/cdpM3fHQy99/BadCfLxq090ORah9zYceb/LMClgTlnw6KiqICDK95pgK2ZBVTt3zEYMdLbTkKEwRMM2DayHpBOo2WLiB6cuFZ54ukRrNcKgE9P39vs5T0L4WM+e0zIonjP1t1rJvyTPpcJ1wyiS4YdrL1EIQtRjkoCgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AqOHMjlM; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Wy9M1C4b; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AqOHMjlM";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Wy9M1C4b"
X-UUID: 665bde5a679711f0b33aeb1e7f16c2b6-20250723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=72zJczENI9mMLSyWioiG01adsfJgABKyNwMN86fngcc=;
	b=AqOHMjlMNDcPKt2J/ZX1GRg+JQLfgie+T5sA7zVpkuelvC8B0ewSrIHgo9g0ylFaKMX/RWsIiEBsyfBaUmhaIjit8e0QevWq04mqvSnzOJ7/92ETC0s8peHxXs5NaDyDhJ6y1wZ0Rx2WtI3RHiFgM7P93cjMP4ku2hMpbvxaLZA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:7128dd13-9413-42e0-8b5f-efef8a2a76da,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:43032950-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 665bde5a679711f0b33aeb1e7f16c2b6-20250723
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1943509207; Wed, 23 Jul 2025 15:34:00 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Jul 2025 15:33:58 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Jul 2025 15:33:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PbQKCsQnYPtPI5AkvtFjqOwXtnsxkFAHfAEGPC7op7sbXu+1WvSOYbMvvU4SGnKgI+JecXNDN2GA/uZaKdF9Yw8vh0QdEgFiHnD/MCcKyiaZxiyMzo5/FcfOlLu5VSt/6npF8xHeFnf9ODnQJ4cfkIhqje42wE1iM4bNa9zGqEmjpZzLmfam4L7kwN00sawUelxUAyXQs4Zug9PK1qLs5jXsNmvd6l8h26hy2li7HyQuPIPiHYkA0kRdSXsjVbisgm5ruOWtozC9HN0Y0n/CuKUoO7X+ps+6TQLaB8o2vsUXXw0dE/5hwcKOyAsD31oxc0h1KHt17+OTe/t7hAbZ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72zJczENI9mMLSyWioiG01adsfJgABKyNwMN86fngcc=;
 b=SLgP2UbV8qnzgWq143qsDcHDLYrxLwUZhgYsKaZXEJDF1ID/3u4Ctg4+AJ12M3TSyb8pb8Fjxpt3+W92CMOTkQRLSmkINhuU+0pLVrhF8LX9iqsmmYSNfaWAglEPfabbLtfw8YmTVn4MjtzMqDrfND9zOmlGrlbOEjZklrpuc4zs5s8nFU6dnv7lbKDlazpVmE2AYUOBL7m6I0slYX9gPtiRmTte5lwoJ3etxV0EQ6kRu3oWI5VzWuelRRw+9ZMvUtfTsjmavVJtRhbJa720lBvtcyhh2TdsX/KMjN8owejicFDBJS+OEJ8E2Oedy5vDw3qXYOm2wcmjTnAi1Ale1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72zJczENI9mMLSyWioiG01adsfJgABKyNwMN86fngcc=;
 b=Wy9M1C4bEMktFFfeyAd16urCOyYukCBZmi0NCSi/6se608iMsYOVTB0N33DOX77PkYKKlaC1zTVgCD9jhwEJrAEXBA3B3dwTKgomuvH6hesuV5FScMnD1HCpxwCsC/8slCWJVMxKDwm/uwcKfYCm/Biuk63m8zrdNHIrAGRYQ7o=
Received: from SEZPR03MB7810.apcprd03.prod.outlook.com (2603:1096:101:184::13)
 by JH0PR03MB8115.apcprd03.prod.outlook.com (2603:1096:990:35::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 07:33:55 +0000
Received: from SEZPR03MB7810.apcprd03.prod.outlook.com
 ([fe80::2557:de4d:a3c7:41e8]) by SEZPR03MB7810.apcprd03.prod.outlook.com
 ([fe80::2557:de4d:a3c7:41e8%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 07:33:54 +0000
From: =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?= <Macpaul.Lin@mediatek.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "macpaul@gmail.com" <macpaul@gmail.com>,
	=?utf-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?= <pablo.sun@mediatek.com>,
	Project_Global_Chrome_Upstream_Group
	<Project_Global_Chrome_Upstream_Group@mediatek.com>,
	=?utf-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?= <bear.wang@mediatek.com>,
	=?utf-8?B?UmFtYXggTG8gKOe+heaYjumBoCk=?= <Ramax.Lo@mediatek.com>
Subject: Re: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
Thread-Topic: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
Thread-Index: AQHb+ubWKq+iXE2BqUelDOs6odTdtrQ941oAgAFn3IA=
Date: Wed, 23 Jul 2025 07:33:54 +0000
Message-ID: <845f204b2b2e39b794cdb9c0f3293dc8cba7286a.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
	 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
	 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
In-Reply-To: <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR03MB7810:EE_|JH0PR03MB8115:EE_
x-ms-office365-filtering-correlation-id: 4f7f18ab-7f34-4af3-195a-08ddc9bb4735
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?eVJVMnZHNERYd3BsblF5SHV2UnZtSWFaeFNpVHFhd0VCK0dBUGg3VUdnOWlU?=
 =?utf-8?B?eVNZeDE4bUNmRzJYNnNtREJQeG1qSDF6R3V3TzdVV1IxZlFuQ0tzQi83RjIy?=
 =?utf-8?B?Ui9qbHBCS1hxNHFIcXdtMFZETS9XOHMzbDIveVdzVTZEb1l3YnFzUDYrcjll?=
 =?utf-8?B?bzdLbVVHWDRhQlNuc1o4VmFINldHNElSSVdBUm5ia2U0ZG1NUDFySVpCWEFx?=
 =?utf-8?B?a3NNNGdVei9WS1g4M2ZDN0wyZFRnZ1hKaU9CSGhBUmFkVU90eDQweERlcnFT?=
 =?utf-8?B?Q0ZObWI4VDhFSFlBMGdDekdhcE4yK0VBRGdOQ29aWHFqWTFTS1kxanhnMFd6?=
 =?utf-8?B?Vm9ZTzFDWHVsVkY4bnEwT1lObVo0WU5kL01wYStmQTdQL3R0OXBjdllHN1dG?=
 =?utf-8?B?dVZJSTNld2NkdzE3RUFablhTZGYweDFPeXJzZVR1UE53Q2lRQW5QZy90OU9s?=
 =?utf-8?B?OUhicjkvM2pDeURvRUlnMUJXSm5OTytGUXl6bi85L0RuemdMTWg1SlUvYlJY?=
 =?utf-8?B?VUFDVHo3NkJ5YmpMckdYbExQZlh4OFFtc0JLZWtOTHl1OWgycUNDOVI4YVcz?=
 =?utf-8?B?czU5bkxMdlRXTElVMUt3RkxUTjdINU95UGI4S3F2MjlmQVJqSDg1YUpRU2x5?=
 =?utf-8?B?VFFIVUhlb25hSGlQamc1cEVjSEVjY1gzQ3h2WjJOUVZnSzQxZVJRamxNUWkx?=
 =?utf-8?B?aHBkRmxzaFNydm45MGYrSEZLQVN3UjQ0YU9PRHJHMHp1L2NTTTgwbzZjeTRu?=
 =?utf-8?B?L1didElDNG9nLy9VWGQ0V3UwSHhIY1RvTHViKzU2K09mTDZGM2JQZDlqVkZ5?=
 =?utf-8?B?ZWdmclBRbFpmWThwS1FLYnQzb09jTzhXVnFTbUlEaXVydjJJZVR2Nk9kd3RY?=
 =?utf-8?B?QlMzMFlwV2U4azlqTGkxMWhiOGw5NDgxdkQzMHJiYnVnZU9hVUFJR2xSc0pp?=
 =?utf-8?B?SzZEazZORXVGdUE2QlZiRjU0TUFHcjk1bGlHRlR3TWJEeVRWTzFiT20yMUts?=
 =?utf-8?B?NnRuQm5HWFNINjEzSnFTWjhvYnhxdGVycVExVWg4WE5XRGR3LzZTdWdHQm5D?=
 =?utf-8?B?cENWT2Vpbnc2SWh4ODFIeTR2SFk3TGM2VEtBUTEybTRBUGorb09Ib05ITHkw?=
 =?utf-8?B?TW1HU2U2WCtaN1lLS1dEckhUYmlFSGp4Y3IxNE9mSmc4MXE4cVN1VEpRdXVB?=
 =?utf-8?B?V1dNeGNKV0RnNDQ4R1FKQk1oWW1tNGMvZ29CU2JmUE1RUitEakZsUzg1QnV6?=
 =?utf-8?B?NXBSeGNQVUxycHBLNUwvL3JoaFkraUZCUm5vd3JoRzNCWVlBVHpmMWFKMWNK?=
 =?utf-8?B?dmRGY1BEeEFHVDBaQ3AxcnBGVWYrZTFQOGtKMzFNMUdPVHM1TmdqdEQvREFl?=
 =?utf-8?B?b2Y2MHRzU0dIV3NCNU9oeTkxbmI4MFZNOW5yclZhSU5XdTZjVmJrR3QxQnVl?=
 =?utf-8?B?WUt1UGN1UGo1bVBCdkdtRGtUaXhrOWMybGg3ZHJXUSs5U0dTYm9rRHpYOHAx?=
 =?utf-8?B?T0NNTnRZZjNGUmhuNmlRdHRhMDUxRWJCWlV0VGtlajVMbk5RVlBYYTJmdE5j?=
 =?utf-8?B?R3lNNFlESC9ENGYyUFoybEI5UGwvL2IwUHdrMHMxRnhlM0MyakRhL1pBSnlG?=
 =?utf-8?B?NlVZYUdMdW02M24ycHRTTklxRlFHenlqd1ZZMitoc3dBbUFtS0JTNmVtRWhi?=
 =?utf-8?B?c1BMQjVtUGdwQW15akFQSGgvU0JxWTZaN0dLa003cmtCdGxVVUIyOXEvYmQv?=
 =?utf-8?B?bW14cGU4T1lQRUgzbHU0T1ZXOGtBazVuYW9kUk9sMHRhbXNPK3Z5TUFVY3VR?=
 =?utf-8?B?WnpCSmpxc2dXcG9xcVBZQk5FWXRVeFBXMjVwYVRwRVRXSVlRa2Vjd3NybFpW?=
 =?utf-8?B?SmtMR2RsUXUyMmdKWWlDd25aeEVsMFVJY0lyK1k3WVhIVTZ1Wnk4cFVaNDEr?=
 =?utf-8?B?RTRCY2p1UzlHU2s1SHJ4ZzRvejJRYitYZVcxT3NlQmlHSjg5TTV6WUM3VlRw?=
 =?utf-8?B?T054MlhjajhkemlUTUtzRzU0SkhBR2Y5S211YjRFK0l2dUU1MnUxaDU4eWJK?=
 =?utf-8?Q?r1AMJp?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR03MB7810.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjVidVljbUhMS1RtQW9Kb2p0eWpudEhwSllxV2hndjhSL1o0TUNyb3ZGZlBI?=
 =?utf-8?B?aFptZDllYzhGbU5haVdZbXhmbmZ1b3lWRHlOc0hHS05IY3pQOWJYenViS3Rk?=
 =?utf-8?B?ZWV0cFp2akw1TGVGV0puU3hKb0pOWVllbWFVMzViako3N1lYY3dzZm8xZHhY?=
 =?utf-8?B?cWlUanNrQ2tpMlpKWnR1ZWhVdHBTWWJxanM3T0dramhKU3BzeXkyc0xSQ09r?=
 =?utf-8?B?dmZ1RnFrdWFFZUVic0VNQk5yYkJzUjNaOXJxaERadDhNZGdKaUpEZklPaVk2?=
 =?utf-8?B?dHExRlg0bHI0Y2Vla3pDSEtHeWtqUng1djNIdHhXOVZSaWl5cVVWVU1Ja21E?=
 =?utf-8?B?WHJpUW5RVUVHNXcwOWQ4VUJqRmxqMFZ5UFJyWDNmY1JQTzAyQzJsaHVneUdR?=
 =?utf-8?B?UDArVjY1aUpDU0Q0YjBQSkx1VHRka1VpT3NvWGx6eVVEVkhLOGlTSGhiWkhv?=
 =?utf-8?B?NkxyYkpPWEJZM29QQVY3RmM3Vng1dDV4SUk5eWM3dGtvSGZSYjBFUU5lcFNN?=
 =?utf-8?B?K1ZFWkZoNjJNcWt5QWdJTUhVNjBITkRzaDdvQWRZc2Q2SjVUM2VGOFdoSndp?=
 =?utf-8?B?dEJsMEo5VWwyV2V3aEp4bi8yVjJNYVJFbkNWdVc4ZFM0bGJiaHRYUVJyc2h4?=
 =?utf-8?B?aEhGbnBRREZZYWRaSzNidXhHMnNMckFJYzI5VVpHRW5EWUxuYUZjbWZWaHVj?=
 =?utf-8?B?MUhtcTYvUWQvZlM0WlRHSEo5RW1OejJsN2VMdjJtYzJCSGkwQ044VVhid254?=
 =?utf-8?B?ZlkwWVRkMTVDQjdvVlhXcFpnUStyVnNZcEJDTVZJcXhxYmFuODR2L0pabW5o?=
 =?utf-8?B?SDRnY2pTdjdLY1VQdktzelhqQjM2dWhCK200MWVFa2IvRk4yTDRYTFBXRzVO?=
 =?utf-8?B?dDhtbHdjd1QxdFArakFTZEJpa2Z3RktWb3JMdTJxUlB0RFlmQmFFcUlRUmk3?=
 =?utf-8?B?SUVYYm4vYk9uZnk0T1N4ZzRuU3c2Sk1Cc2tSVTdUbUVIb29BdG1LV2FHRFE0?=
 =?utf-8?B?NWpEN3BnK0N5blAvUVZwckJDVzQ2Q25wemxOUlZpOGhRdGZYVzFlZFVheWxJ?=
 =?utf-8?B?VERGRlFTekpsMjlQSW95UDNLR3piM3VYLzVOdzZ6UHhkQk5OMTFBVFl0VDhW?=
 =?utf-8?B?YlluYTM0WGpJd1c3cnNHTXV1aGxaUWFVOWloT2VpMnNBckg2YWRObWJKU0lO?=
 =?utf-8?B?bnVMb1NOQS9PZVVpUGxoSHdqbGVqREV0Z1gxR0g4aTFucTJZT3FCWW4vUGFT?=
 =?utf-8?B?QTBYOW5pMmtHRU5IUURkSTBlY1JFc2hFMDc5MW9NLzRlSEtqcENYMSs1VGFP?=
 =?utf-8?B?bVR2dlhLZU1uMXF0aEQ0ODM4dEd5SG1pdmg3QndBcUIzTjh2bENFOEQ0bEhF?=
 =?utf-8?B?RkFmc2VvNmgwRVRLSHliODZkcDlDcnY2bzArcjBURm03b2lsWjhNRFY5QU02?=
 =?utf-8?B?VjNDbmtlaFNOWEk4bjZaUHc4TnBLczdGOXM1UGpHNDB1Wk9GNlVZNXpYdFp5?=
 =?utf-8?B?QUF5QXZ2N2RqdFdKM3RXTmJDb091aUdSRExld0FzYXFCcmZHejRqNXZtcm1Z?=
 =?utf-8?B?QzBXZnBscDM4UUJSaHJ4WUNpQmpaOFMrR2hST3ZDbGhnbzdxTnl2V21TaWJo?=
 =?utf-8?B?UW1kUmpleTZUcCt0K2t4eUJGNDZxUWl2dkhuMmU0RnlWWjVLWFlKekR3dGtH?=
 =?utf-8?B?enZBNE9IaTdrMFloMmxwTFpYMkkrWkRGd2ppMXp2WTNPanBFVmp6TUV0TlFv?=
 =?utf-8?B?a0dqUE9OSHY5YkZvaWtWWjlFUDdNZFkrdDlDNjU4WmxiVENUY3JSV1ZaTVdU?=
 =?utf-8?B?TGxWTmNDemNxdGZIRXVKekZrdHBWd3d3aWpuR2IremI5SFYyb2NMUnNoOGxn?=
 =?utf-8?B?UkhxVmNTTDA4TThXNEVhN2pycnFhWEthQzZqUHA3QkpKdjdrVXFNaStxSVlV?=
 =?utf-8?B?NmpXaHIwRzJOamhQWTJrREdwMkxseVkydHRiRlRGdlkzWUpWUmVwREo2RnhO?=
 =?utf-8?B?bE54SHY4dzhjL2ZtQ3Z1OUFmRlNRekM1RUMrZnBTc3FTcktBQVppejd0WHNK?=
 =?utf-8?B?SThsSnBsMFdIZWRjWGxoRnBPYW5kTTZ5ZmNrUmhVRTVIT1hkRXRFU1RWdUpt?=
 =?utf-8?B?MU9POWhkdXlKN1BSdGxFRFZlc1ZIWWw5djFoZCtuNzNwc3ptMDNxdkc3NzV4?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E80169CBBEFFB040B910776A8F666C65@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR03MB7810.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7f18ab-7f34-4af3-195a-08ddc9bb4735
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 07:33:54.6892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VyxtLl+cb+nAtUtZggq8wCPxe/AAbB8tekbn5+k+Kia/SomK/8GY7zcz++/hcBbm0y+DCKnttmgd2um6YBzWTiCB6oWg4sVWKpBZJlzIro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8115

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDExOjM5ICswMjAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gDQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBs
aW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBz
ZW5kZXIgb3IgdGhlIGNvbnRlbnQuDQo+IA0KDQpbc25pcC4uLl0NCg0KPiBUaGUgdW5pcHJvIG1w
X2JjbGsgcmVhbGx5IGlzIHRoZSB1ZnMtc2FwIGNsb2NrOyBiZXNpZGVzLCB0aGUgc3RhbmRhcmQN
Cj4gaGFzIGNsb2Nrcw0KPiBmb3IgYm90aCBUWCBhbmQgUlggc3ltYm9scyAtIGFuZCBhbHNvIE1U
ODE5NSAoYW5kIGFsc28gTVQ2OTkxLA0KPiBNVDgxOTYsIGFuZCBvdGhlcnMpDQo+IFVGUyBjb250
cm9sbGVyIGRvIGhhdmUgYm90aCBUWCBhbmQgUlggc3ltYm9sIGNsb2Nrcy4NCj4gDQo+IEJlc2lk
ZXMsIHlvdSdyZSBhbHNvIG1pc3NpbmcgdGhlIGNyeXB0byBjbG9ja3MgZm9yIFVGUywgd2hpY2gg
YnJpbmdzDQo+IHRoZSBjb3VudCB0bw0KPiAxMiB0b3RhbCBjbG9ja3MgZm9yIE1UODE5NS4NCj4g
DQo+IFBsZWFzZSwgbG9vayBhdCBteSBvbGQgc3VibWlzc2lvbiwgd2hpY2ggYWN0dWFsbHkgZml4
ZXMgdGhlDQo+IGNvbXBhdGlibGVzIG90aGVyIHRoYW4NCj4gYWRkaW5nIHRoZSByaWdodCBjbG9j
a3MgZm9yIGFsbCBVRlMgY29udHJvbGxlcnMgaW4gTWVkaWFUZWsNCj4gcGxhdGZvcm1zLg0KPiAN
Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjQwNjEyMDc0MzA5LjUwMjc4LTEtYW5n
ZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tLw0KPiANCj4gSSB3YW50IHRvIHRh
a2UgdGhlIG9jY2FzaW9uIHRvIHJlbWluZCBldmVyeW9uZSB0aGF0IG15IGZpeGVzIHdlcmUNCj4g
ZGlzY2FyZGVkIGJlY2F1c2UNCj4gdGhlIE1lZGlhVGVrIFVGUyBkcml2ZXIgbWFpbnRhaW5lciB3
YW50cyB0byBrZWVwIHRoZSBsb3cgcXVhbGl0eSBvZg0KPiB0aGUgZHJpdmVyIGluDQo+IGZhdm9y
IG9mIGVhc2llciBkb3duc3RyZWFtIHBvcnRpbmcgLSB3aGljaCBpcyAqbm90KiBpbiBhbnkgd2F5
DQo+IGFkaGVyaW5nIHRvIHF1YWxpdHkNCj4gc3RhbmRhcmRzIHRoYXQgdGhlIExpbnV4IGNvbW11
bml0eSBkZXNlcnZlcy4NCj4gDQoNCk9vcHMsIGl0IGlzIHNhZCB0byBoZWFyIHRoYXQuDQpNZWRp
YVRlayB3aWxsIHJhaXNlIGFuIGludGVybmFsIGRpc2N1c3Npb24gYW5kIGhvcGUNCndlIGNvdWxk
IGdldCB0aGUgbW9yZSBzcGVjaWZpYyByZXF1aXJlbWVudHMgYmFjayB0byB5b3Ugc29vbi4NCg0K
PiBDaGVlcnMsDQo+IEFuZ2Vsbw0K
