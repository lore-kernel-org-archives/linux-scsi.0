Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2C83806D2;
	Tue, 24 Feb 2026 12:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771936896; cv=fail; b=DAyUfgRXkBzbbWWad3qylMPUKJKOfEcKvHXjJt90qWsOSbgnPxXLnHH5d+ef05DMrtHJoFKakBbwBNIuIb9oAO7hzZaNVP+5l/UD148jAlKe5LRRMF7X4grAbZeFqXUEh1GbP5IF+2tpA0LECfspPvSXTeHAkgrUce0Cebdu4tY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771936896; c=relaxed/simple;
	bh=MMQy5iY49SCn4XO/dOAO+YxY8VK+w/GMQ5e8NcBDqoc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NDOwspK/4c3vB9bwLTURtu4Jk/+jlOy+S/+F6UcvYjsqnUnttVqWpSdbHiaVhAmAwJJop5r/30pCbDKIF9YoqpI4cFJbmwN3HCqxIVGE487Ri+o7SXU9aYJx9oFSMgR++4icuiSXhXuxaiSEyKgwrQXLQFO+zfZ/eZ0e8cwxCkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dXnUuVxU; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GVBt/u+Q; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dXnUuVxU";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GVBt/u+Q"
X-UUID: 236532fe117e11f1b7fc4fdb8733b2bc-20260224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MMQy5iY49SCn4XO/dOAO+YxY8VK+w/GMQ5e8NcBDqoc=;
	b=dXnUuVxUPjZof2dKRKieydXeVK674c9ruMLwAQlskhgl7XXJw0XfA2pJ828CJaxhzt7FaACR1ig8HG1yyAbAMup5ivdnzWaSD9HDlRoAIc8Tvn2yjXGkf5kPyacilqd1fekyTWA/4U41Zo0zpvfm2svNWCUMnpxQO8lyDPpkXm4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:1b93f183-5344-404f-9dbe-c3f0ac2173d5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:3e4b377b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 236532fe117e11f1b7fc4fdb8733b2bc-20260224
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 339607721; Tue, 24 Feb 2026 20:41:28 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Feb 2026 20:41:27 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Feb 2026 20:41:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4Tv7jLiPIqifZ7H0QegA7A88h9/3zV21IC4JZDynlR0CXKn8Ar7j7fPFacx8mgkqSSzJjghLSAYANcUE5ei6ZsPiCvg3zVxvwVphtbfOhEtjQwW/dSn09oxO+bzEv1xHv7V8AFYJg1tHLwbGugc5Zhgwha8KrcwNtNErPgwmtTMz5sZTDrXanuW7fZTznzQrKnsJ3W8EohncfSOKz3ZUbU+gMk2Zl9FeSTj7jSofRDEj3RG80PUhKD2A7ptwYyWAJJBkubcG0L+TxuL/1u3AOQolEZht+X3RgIH/YHAjIkAwZJS02pDnlCV42+XJQgRR/XCg4Qqg/gC9zDU7lWJdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMQy5iY49SCn4XO/dOAO+YxY8VK+w/GMQ5e8NcBDqoc=;
 b=wDLwr7gPi9dL+7ut2SCM8yP68FZIXzTPdu1WzufmnFlSWrSWUvscL8mlTBju21qDUfs8RmxgIY2STjEUS1RcHEKI9vT0E1vm+yDW8KH1X7KrSbsgbbZMk6HEwuHCWQ93V+Yx4P74cKhgE1bjPaG8OZ9h0P1TYziKn3Po8ZywSJwxqZuinUf24L/pcmeLIr+dzixaM25BEf6ytdF/IJSw0iJr9uKILsHHYGFiu2KKUqJXi2EmV4mqnMslNKssPnwBf2b57qNMt4N58QViKAZca2dLl5rM0XsA84EMniMc1IgjoAYhPRNJI/YEbjByRiMh5T0XynFa87z9n3a3sgWZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMQy5iY49SCn4XO/dOAO+YxY8VK+w/GMQ5e8NcBDqoc=;
 b=GVBt/u+Q5pviIzVL/UlCI2M1Gu7C77/0LUKtasI11OdMo42gVBshUlQ1egW008vhojwgX84cOiuFtI3Q/3KCgxGGSYDw5xkPeuNArmshQ8qMEoVTehRRS8r4DSvrwb6dIUZdop7/+lit0rSTHlK6pZfOv7laOEgfWfTHI1Z9P1g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8625.apcprd03.prod.outlook.com (2603:1096:405:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 12:41:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 12:41:22 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 13/23] scsi: ufs: mediatek: Use the common PHY
 framework
Thread-Topic: [PATCH v7 13/23] scsi: ufs: mediatek: Use the common PHY
 framework
Thread-Index: AQHcn0nYzBbFlnGcuESiGc85/VHJC7WR1y8A
Date: Tue, 24 Feb 2026 12:41:22 +0000
Message-ID: <c50be9ba4d6023f42016fc4689431c05d4eba5a7.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-13-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-13-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8625:EE_
x-ms-office365-filtering-correlation-id: 01810c77-f1f1-4a87-f9b3-08de73a20463
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?SEdHOCtJTjZvM2pCWTIwcmVDV2VsSXlZK3RuSGs3bUJXTW5KVDBpbjF3WWIx?=
 =?utf-8?B?UmkvdmloeWFqdVJQWnpCbVZZWDc0M2lmc3lBUjJKY2xSSG8vLzIxSjJrMTBm?=
 =?utf-8?B?THpyekMxeUt5ZUkrZ0hQSGZXNExPcHV0OUFuSmJQS3hpclplMDR6bU1ra01k?=
 =?utf-8?B?TmVKQ3RmckdXN296UWVMVzBVbXk0c3pja1J2YW9UekVyM3BnMWlmbTZ0UUZI?=
 =?utf-8?B?OFdHNyttZWxXbHNYaGlJbWliTDF5RE51Q2NRQUxsMlRReHpJeE9KLzEva1Vs?=
 =?utf-8?B?M1ZGK0h6TnZiQ2lSUDZHZzEwQU1ZVzBJMVJDcjcxVENLaE9PcHpwb3I4aU9R?=
 =?utf-8?B?aFp1L3J4N3VWZys4ZzE5bkJleE9wZU5IUjFuRXdBUjF6YWRUT3B1amIxU04x?=
 =?utf-8?B?T3V3dWVXWVdwUTFPcXlTNjdYTHlmYWdrdHlpdUhKR2hFbW5IckpqMTBiS3Ri?=
 =?utf-8?B?cnduWWFNMlM1SGpXeHZkMXA4eWFMQWs2ODFLeFl1a2VqbkhMdDNSOUFuUm5p?=
 =?utf-8?B?NTNHeG5OU0RlNWQyN1ZGeHl5TDJrZTRnUzE4eUswUXJydEVnUlNOYWhtd2xy?=
 =?utf-8?B?eVRSeUFhaXpIc1QxeVV6Szl5d3B5d2NPQkdFYmVzUkR2TzJua1BFejV0a1lK?=
 =?utf-8?B?R0hSMHpacExBZ3lPMjZwdjduOGJOcGtaNjI4S2NmNjcyeDhXbDF1d3lLb3Fz?=
 =?utf-8?B?UUx1SUlMYnBwQ2V6eExsRVJOZEZHNGhYUEtJT044SEZNcEhWSXh4dXFiVWdN?=
 =?utf-8?B?MDg5WGNXcjVjUWg0YTFvVk40eEdnVXZ3WnpZVkZqMDBldlJaaVhMTHJWTzFO?=
 =?utf-8?B?WEd5QXZ5M2IwSWJEOEI5K2lTZXhpSWxXNXN2Q2drYWt6OUJjay9rdmVWK3pW?=
 =?utf-8?B?Y1FLd3QwUVprQmlob2crYWZnTHZTQWh6cmE1Sis0YVc2cVVwYWY4UENtYW0z?=
 =?utf-8?B?RUhyY0tRcVZGL2pRQlBTNHByTTg5ekViOUlzOXdjdnNOTFJYZFdOVFBOSlMr?=
 =?utf-8?B?Z0ExUlFnUGFzVW1GTTIvamxlTGpub2hOeGtJZ3o3MDNPNjNVTFZDNUNMQXNB?=
 =?utf-8?B?WUY2N29PYkg2M3VHUGY3YjN1clU2SGtTS1AvcVh5MjVVWGJ4VFZSYitYODk0?=
 =?utf-8?B?MDBiUitId09JdXJBVjUyaFZEWXZkbzhFa0Zza0ZQa1loZkpuZ1loejRYR2dQ?=
 =?utf-8?B?OUl4UDRNUVk5Nnc0R3VxK1BFc2ZkYVY2UHY0ZFBGTlpVTTZNcU9Nd04ycVAx?=
 =?utf-8?B?L1djTW8rMlBLb0Y3UndqK2dQNUFhU0p2a2dMdEkyR1dPekV1c3VLWmlDcy9v?=
 =?utf-8?B?UWxvb3FFd3FaTWFOSEYzdHZCSkt1WUlxSWVxYVNUMWhEcmFHbkU3c0xtUFVy?=
 =?utf-8?B?d0xyQnJQRGV2QWNERUF6ZkxoMW0xTUlFQ3lxeU9aOFhCYkxOZlI3RHh0RTdj?=
 =?utf-8?B?VFBzZ3dUNVlmN0lOT1pKRUYyU083WlZtWEdaWE9wM0MxbE8vUDBXUllxMDVp?=
 =?utf-8?B?TC9BMUtaYXorOTFBMTdyQ2xZTkI3Ni9MZU9wMWQ1MUkrdTd0QUdRL2kzcHUz?=
 =?utf-8?B?WGRPcEhBc0pJTVpndlZyR0JYRnV2ajRZUC94YkpoVG9JOXhQcGQyTDJTaUgv?=
 =?utf-8?B?eEJybGNSczVQbUFtR2RjK20vdDh1OSsyUWlnOExrQXg4ZGp5V0JNZFNmVWlU?=
 =?utf-8?B?bnNCcUs3em8yRmRmaGN6bkl0Y25JaWM5Z1lHZVVBcFU0ZU1pU01kSXdVckF5?=
 =?utf-8?B?S2VzYjg2Zzk2RUxzTStyZEdseUdzeHpTNzJBbU1LUEF6QVJQT0lwV01BaC9G?=
 =?utf-8?B?dE9ETVAzT3RsaXFNTnBqaDNXUHBJalFYVzRXTFdrL2dVdjAxK2NKTTAveThp?=
 =?utf-8?B?Z25ZTzJZUW1Id0dmVUw5alNoQW9OZllaNzNXbko3dWJ5SlBhcVB3UUZacU1Q?=
 =?utf-8?B?YnlaL3U5eEZRRFVFcUNoc04vWlJyUGVWVG43a1VEVEJyUGhsRDJzekVvRm9V?=
 =?utf-8?B?UEM2OVMwVWJOa09uNStMNVFSRnRicUNZbCtmWFJxTUJRSUo1MEYxYXpvNVJp?=
 =?utf-8?B?N3VuSmNtdzBsK1prczdCN0ZUTkl4RGk5WTl0TjhGeEcrbjVtR0FSVUxMeThW?=
 =?utf-8?B?Q3k1dEJCSDN1Zmt3ZTdoSkFUeXBSbk1iMlI4dFcvZmxpQUxwVjNtYW95eXBK?=
 =?utf-8?Q?LknYzaF5l2WgcrfLPyVGT+2EmqTZEdm9fm84Bz63KX2R?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3ZMTzJDVlhGSEpleXNlUEJmbjZkNkhDQU83ZlAvNkdMa0tUUEtmR1dwSk0v?=
 =?utf-8?B?WEJhNnVkNmI0ZXYvVmNPL2tlbUVkTWpVV3ZibVdLMjBpRnlaRnBSZWY2WVBa?=
 =?utf-8?B?d1FVTG9TSUxuREFLdVU1ZXFTYzdTckVWdldOYXRBNFQyUjdrcWs1eVVKbmtr?=
 =?utf-8?B?RXUxMDFDQ2JLNENERnBuZVVkY09FVUVHb2dLSEZyKzNGamZQWkgvdlM4Uzds?=
 =?utf-8?B?T2ZKUWhwb0E2WlBFYkNWdFhoMWdIREt5Z3krSGZMQ1N6NkQ2ditMdi9yVWJQ?=
 =?utf-8?B?SDhscG1XZTBjUkRFVWphbzdXVmhiSU5wSkZWazh2RmZyUVJWY1JIWXNZdkJx?=
 =?utf-8?B?Wjd3UUU1R3A3NGtkV3h6Qm5IcDhmWHhZWEJyVXFjTTNYY3FLQ3VlUDZNdEhz?=
 =?utf-8?B?ZDl2VHZTZnUyK2xnc1J3TDJ0d3ZtaC8rQThXSzZydVA5THZhU2l3OGdsQUVH?=
 =?utf-8?B?S0c5aFR3SU1rTUdxUVRYdkJFODdtdEZGWk1wdkdla25tSi90LzhpbkgvcG90?=
 =?utf-8?B?ZHlhR0hDcy9ybG9aZk5FYktQZk9zdDRPOFh4VHNTMUFpc201ZDJaajlXZmhO?=
 =?utf-8?B?bDg4dkQxVTQwU09GS1J4dytEejkxNEJEOHZxRmdSalBrbU5NWFRpQkJOM1pJ?=
 =?utf-8?B?aVdUM2xJY1FvVDE1eHJCSDE4Q3pERGdNQWl0T1RPYVQxWGVweW5iU3llTmkr?=
 =?utf-8?B?VkVzL2t3QzFkekc4NDVoRDhCejdLRGdjMHNXNDVCRXRZZTQ3VE11eiszeFRo?=
 =?utf-8?B?K05mc2s3TXR2c005ckZDZUYrVVJMVUxGZFE4bUNMMXJaa2EydnJRQ052UHYw?=
 =?utf-8?B?U1pnWEFEVzBIZVMvajFCRU10TXRhNldxWVltUjFkQWNwSmpZUUJNbGxZWVVT?=
 =?utf-8?B?aW1RdklNa0JKdXlyS255cjZ2dlFjWDZuRGdmQlY2TWtKSTBVZ1pkY0IwUU1y?=
 =?utf-8?B?bENpdmlCZ1ovVnZVWjBSd2VpeVNza1JweVFYcHllMjdwd1NOanY2THZaeUUv?=
 =?utf-8?B?OHNlWFBSV1ZMSWJvOWZvR1J5c1Z4SUpxRDVWNG1XWlhDY2VFSEpjck5ZbkZ6?=
 =?utf-8?B?R0d4T2RXWnJjUWIrV24vZEdXODFGdjd6M0ovbHRPWDFiYTNHYWlVa0gxQ3k2?=
 =?utf-8?B?djZaS1JteFI1cGk5UndDbEVqTThlOCszNEk5N21CazcvZmFua0lQaVpZOVRh?=
 =?utf-8?B?Qm9ZTmV1TlViQzVudjBuNnNoT0k0cE1kK1ppNjdRdk9HMVhpYUZNQ0xOVjlm?=
 =?utf-8?B?aU41R1BMTDJCbC9KWWhkdjdoV01CVXhLVGs5aDRsZW9iMUgwTnhaWFdkMmN2?=
 =?utf-8?B?U1pHWS9UWVIvU2tUV1kwQmF3QlVtdlphb1pkVFRnVWY3ZGRWelZhM1VuOUxB?=
 =?utf-8?B?VTlNUGdPUlRqS1pSUDVBN3Z6TDhaem1VMkg4YjV1Q0ZrSXdwelpqTUdwUWI3?=
 =?utf-8?B?bldKYUw3MHFKTm1RQWY4WUUrKzZpeldZZmt3WDByWjdLLzJpWTFYWFhUWnRt?=
 =?utf-8?B?L1ZmNUZXYm9mbFkraldFVkFMMkMrQ21iNG43RlYycjNBc1pwbXgzYWlIbEt3?=
 =?utf-8?B?Q0djYUtTVWJCbXg4T1BYcG5PQitPMmNua1lBQUVyR2FtUC9jNmlIK2g5SDgz?=
 =?utf-8?B?MnVxY0Vnd0MraHUxY1dLcDFWS3pxOVFCdDNaWDFOeWxVRjV1SEhlSGVSOHAx?=
 =?utf-8?B?Sm9sWXZGUEcvKzJ0aURzT2JTR1FqL2NTRlAzYkgzMFBtNERMS0tWSkNBK3pi?=
 =?utf-8?B?cFlpSUNndXFxM05JQi9sOUxXSXdwaExCYVhsZHNlNmpLQkUrcldhNWhYUGxj?=
 =?utf-8?B?YlJKOVRDTVlnbCtreWd4S0RvN2hMZlc2N3dyQW1GUmc5aXdnT1VPanRPK0xG?=
 =?utf-8?B?eTYxU0ZQVEFhblhYcG9KSU5JYmpTM3RoWU8xZkc0SjE5anl2eTBQeXNHdEZ4?=
 =?utf-8?B?S2I4MWR3Wlp4M3Z2ZVNqMVNzN0lEcVN2T20rMndaL1UwODFkdG80SS9ZaWpH?=
 =?utf-8?B?Ti80Wnh5Vjg2ZXlyUEdGZlFUMkh3R2F6OGdUVDNYVjJOYXRsd0gvb3lxTCtH?=
 =?utf-8?B?R3BZYVBDM3lLS01DUFZpV2Y1L2xCZGFIdkF2MFdZNTBsUXZTemRQMktabjFD?=
 =?utf-8?B?VVJ6cXhPTUdBVWRRMVB3RDhzS21qNHo3SGh0Rnd1cFlwS2tzcmtDbXROUkc3?=
 =?utf-8?B?RExtS1RpTEhsdU0rK2lUMklGakRWL2RPSC9FS2MyY3orZTB4VEJvZzNwSnNz?=
 =?utf-8?B?MmgvRXEyWEZPdVc2Um5jUVE4UklEWXVwS1c3Wi9CbGRpTk1TbmdVS1Z6V3dQ?=
 =?utf-8?B?UDlSVm11aXl0OUI1K0NyY0VRc1NLRUFvQzZCRjBzRnZxbTgyTlN0SkVmUVJK?=
 =?utf-8?Q?h3tKhxxs82aY8FXY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C8059862EB7E64CA737F1D8F74E85CA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: AONRcxwwOCeP+lOnf4Bpw+yRq69Kqka40khBfcIbcXtcyCBAGnb5n1vyMTmCnH0RH0jpQMmNyEQyv9XkVILFTBfTdUbi+DnzMquAHtn0BVswBABA/X98Hzpy+wT4HIGJr+1Q2CdICqRbB0hVSQy0vhFfdGvrSzDHtctUOB81enS7TnCaVHIfau/TwkihsNTbT5JqOwsz50y0rXALLpIBwU9ccV/wjDp6h5qlX1yLmGouUkFn9pIJkiHxNjWTIvh3n660wZCeoLHX/URZrtXS0PpuSJsUcyNMT0EvAYqGV7lmolfGTIYkQADYB5BSf1bLtP1Uno7TAD4NxVbkVDIo/A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01810c77-f1f1-4a87-f9b3-08de73a20463
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 12:41:22.8531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bTdL5ok10W32RrhLR/QYlBBI5QtMgFGxPfiA5F/ugfbctcOxGiFtNtMqeIrYw88EJL3/u+mEWUg6sgf8OdLCIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8625
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoZXJlIGlzIG5vIG5lZWQgdG8gcmVpbnZlbnQgdGhlIFBIWSBmcmFtZXdvcmssIGVz
cGVjaWFsbHkgbm90IGl0cyBPRg0KPiBwYXJzaW5nLg0KPiANCj4gQ2hhbmdlIHRoZSBjb2RlIHRv
IHNpbXBseSB1c2UgdGhlIFBIWSBmcmFtZXdvcmsgdG8gYWNxdWlyZSB0aGUNCj4gZGV2aWNlJ3MN
Cj4gUEhZIGluIHRoZSB1ZnNoY2QgaW5pdCwgc28gdGhhdCBpdCdzIGRldmljZSBsaW5rZWQgdG8g
dGhlIHJpZ2h0DQo+IGRldmljZS4NCj4gDQo+IFJldmlld2VkLWJ5OiBBbmdlbG9HaW9hY2NoaW5v
IERlbCBSZWdubw0KPiA8YW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBj
b2xsYWJvcmEuY29tPg0KPiAtLS0NCg0KQ291bGQgeW91IG1vdmUgdGhlIFBIWSByZW9yZ2FuaXph
dGlvbiBwYXRjaCAoMTEvMjMpIGludG8gdGhpcyBwYXRjaD8NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
