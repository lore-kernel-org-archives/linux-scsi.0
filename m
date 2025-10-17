Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92820222578;
	Fri, 17 Oct 2025 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760684039; cv=fail; b=BbrhoDf1GFra97Cw7rdII9IXs+Z9dy+M6/VinQ00bDkpESs7iw8W0wjs+wXCcT7jVAYKLbOy117/cj6xBQj6UiBd2S8QSCHjBvQj/31Y1Qc/JZ3HvK6gnL6KD2CqeXx0kU3Yk8A+OWJC65g/c7tNAX13gywY4GOjHFoyl2pDcz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760684039; c=relaxed/simple;
	bh=TelKorf8XnQaHxUqVWDwq81FgYM+eaLEM/tjuDPbVaU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LzfMx4vYdMgLOEQ8hkzOGm03b6gvWHNuE7J2rAxQdkHFjg6AM49Lr+5NdJdD+++SKq1g3452njmX5I/pTBz31akJOms3FM5GG9jaP7OJ6DRG09dEuU8JomLHqgJBj4oc3Y5lBSoFQGWaMaF16Y1u6pVRIbySYqOIAwPkjRgPovE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=sSyjiZcG; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=aWpJeSsp; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sSyjiZcG";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="aWpJeSsp"
X-UUID: 0a15abe4ab2611f0ae1e63ff8927bad3-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TelKorf8XnQaHxUqVWDwq81FgYM+eaLEM/tjuDPbVaU=;
	b=sSyjiZcGldtIfQUUatCGfrZqaKGAii4+c80egK94m5zl2hNFDLWQztaPVyMkfz9+tKchnU6onLaSej2u2hHMNBITIiJaRTSWPgJpwZlOmw2KKqER6l5LW8uRDb+J+9dvKnhFGzFIjoquIuq8P2c/iUpNLycp0FSDFmaBhN8pCQI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:9fcb74df-108a-44e8-b562-5f1a47bb3ae7,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:087745b9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0a15abe4ab2611f0ae1e63ff8927bad3-20251017
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1943924474; Fri, 17 Oct 2025 14:53:51 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 17 Oct 2025 14:53:49 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 14:53:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bUEBw241Kkc1jGBjfpIenxInTA4aqJp5gTigSG9pQjRsiIYNgOagSSolDR7/G+1k+aAW3rqiAO2zMUBC8Ylmr+Sf8tIwsU8aUocKsCjwhA0RC7PY41iB/hNSv1+CPh6JyMuM3h97CuSNoBd0XTSZrJ451OXB8o54HBnC3+gwwyWmYc4t0HTi6JZH1kR4ouGOr/M5hSzYkB23TgS0CX96rLAgpGZHi509NM8I5Ws2C56sD4s95v5BnzM2Zqq5EnoEYJisr7VyXnC8pdoeP2QfkTSWrZ5JYz8+6BidFiu2E9jlAmvBTRaaxT5Jd+X3gPsglOKxIEvV6xcWfuflCHwAGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TelKorf8XnQaHxUqVWDwq81FgYM+eaLEM/tjuDPbVaU=;
 b=Kcc7Bm3r5wLu9O+IDZFRZgqY0mfXJg4h7zhSsOFAFr75CRRdULoYRg/AC6g5VfegG374sloMCctBg89t5Zd2IUpl93fGq+6+/LOm2eU4Aw9IAlTRlb5k5I8x72fCrUSGw7JzXu0OeDtrZJACgesbdrNPKKmUccGpmm8TQssbgsih/xzJHCN7PsWNDQ931s8co+Dd7is00AOoemH9uQ58Sof3S0YeVBxSPXMuVrZ4P+1OYnDmlCGxbU4+0quJoMmeUrEv1MxneL/FE+dZr7sxbie82OFX5AU8HnmdW0wPK/i6Ez7eD8Wt5JvgnX+0WhpaAjTylBpzTzj2mgDnGUrEtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TelKorf8XnQaHxUqVWDwq81FgYM+eaLEM/tjuDPbVaU=;
 b=aWpJeSspDTOR5BE2QaewN2+O+uxrwZs64F3kMcF6gYsVdYUQz5RKvJ6kU9S22Rpn9d/LpfODUHOu9qpR3PaviJ0cYHjnaQCh4euiW2hb3hWvnAmW7EEk/Y4w5pQRzDORnebDrIe+ExHo21rkmXMXDeDDkQbJsiggBcpms09itsY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9367.apcprd03.prod.outlook.com (2603:1096:405:2b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 06:53:46 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 06:53:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>, "nicolas.frattaroli@collabora.com"
	<nicolas.frattaroli@collabora.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v2 4/5] phy: mediatek: ufs: Add support for resets
Thread-Topic: [PATCH v2 4/5] phy: mediatek: ufs: Add support for resets
Thread-Index: AQHcPpWLLF6DRCvu0kycpnMAY1/jhrTF6GSA
Date: Fri, 17 Oct 2025 06:53:45 +0000
Message-ID: <74453fd50969b6ad8ad5c11ff842155cb9c29c87.camel@mediatek.com>
References: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
	 <20251016-mt8196-ufs-v2-4-c373834c4e7a@collabora.com>
In-Reply-To: <20251016-mt8196-ufs-v2-4-c373834c4e7a@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9367:EE_
x-ms-office365-filtering-correlation-id: 4ed29cd2-8450-4d40-fd94-08de0d49eaf1
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?blpVdE9BNThQQU9vUGhObTRUTG4zK0RianVEUVBwamJaL0VLRVJZUUtuNVVU?=
 =?utf-8?B?SmtTMERaa0hXcnkxUHd5Y2RPbzZvSVkxdHd2S016QmJ1by9pblBDV3ZyRGVH?=
 =?utf-8?B?Nmo0VXQzYml1R2tBWG51b0pST0NLc2pxYjdRaTRxNjRmVjk1WlZxaFVaVCtz?=
 =?utf-8?B?dVVpRy9wZDRlc0kvcEpGbmQ4dVYwdFRzSkhwbFl2UVRUQVlkQlpEKy9jWU1r?=
 =?utf-8?B?OHY0UlRLSnNrOTZ3V2VGKzN0aytQYUNLUm5GU0I5NklUd3RNMEttUkN1RUgw?=
 =?utf-8?B?a2NuQmk5ajBFWnl4eFIxenQ2RHBmczdCeXlRUWlPSTZOSmtkS0pwUEYvZUZr?=
 =?utf-8?B?dFl6MHM2aU1uOHJpNm9vdzU2akVraDNBVHlBazU4K1ArVGNlRG9DYXJ2bWRo?=
 =?utf-8?B?TnoyNjhsamVJUmJBWjFUMmszU1hHYko2eS9uaHpOcTN0NEo1ZjB0bDdwUEcv?=
 =?utf-8?B?V3lWTkRmamVkS0lIVUkyc3d3czkvZkl6QWgrTkNJUnZxd0xoZjhLaDVtcFo2?=
 =?utf-8?B?M08xRE1xUENUTm1hUVNCNjVoZWhDd3dVaUpFMmh0STZTMlcxR2xEQzN6SGJs?=
 =?utf-8?B?c3lFZWY5OSszeno2RVEreWIwNFJWK3ZBaUozblluVExFVnRtNkpLeW1ZQVlY?=
 =?utf-8?B?NWladllLWDNyTkJQQW81Zk44eTdlNEFCQVQvWG9lbHIvODViK0YrSFdpZUs4?=
 =?utf-8?B?VkRsYTFNTEJ1VzFuNUN6ekFOTXBXZkZnUDJEclVjc2psc3NRbVdYL2tlVjRN?=
 =?utf-8?B?UHBzSWlzdGREa3FIQi9UV21iVzh6WndlejFKemdkMUhhdHdmMThrL25aSWZv?=
 =?utf-8?B?RFJvOXVJWVJ6enVYcktwTlZqNmltcFNTQzVFNlQ4ZWxrdlY3dlk0ZlFYem9R?=
 =?utf-8?B?QnNHWVB4VmVpQW5tNklveHhMZkFnY0FNNk1zUFJzdlZPWGEyWVRJQ20rYkJr?=
 =?utf-8?B?Mks0VXQvelhhcHRkeWZPRGRqQXdkUnExQXdRTWJnYmxrWXFWUVR1TDdsSC9H?=
 =?utf-8?B?R25HczFUdTdGTXJFUEIzUzdyeHYzbkpmNmZGWnZVNDNHQVc3MXdiNlVPSXNn?=
 =?utf-8?B?ZEN4WXVoSFVqQUszY29vQzZua2VBRlhZKzI4czI3MDNlNXVXUXhlZWJ0ZWVQ?=
 =?utf-8?B?cFNzK1I0UGFPZGF0b3h1bnFUbjFNUU1HKytXZ01LREVvOFFLMGRKR2VCTFRV?=
 =?utf-8?B?UEtWL0xtOGdDUldxVWN1Z2Q3Wno5S2NaY00zWVQ2cnR1WURDYi83bEtydWhY?=
 =?utf-8?B?M2kwTUNIc3dHNTZtY0YzQ3FyRkVuWGVXYk9QK04yTGhkR1lKeXhXc3dBRGxJ?=
 =?utf-8?B?cG1JWFJFZDdaeDBrVVRFcFpIQTNCdW1BaUlMQTdIam1FdS9xVG5jUG5EcGZB?=
 =?utf-8?B?VXdxOXBQU2tydXRVRlNVMDhLM3lvK2NKazZzQytacm9rdG9aZGw3STF4WWEy?=
 =?utf-8?B?R3ZIQ2o2WkUyQ3plS2d0WFd0NWI2Zm5BN083bGg3bCtZbDRuTlExR3JVclor?=
 =?utf-8?B?Z3dyeW5WT1hHRVFBcFRudVBjZm9MTXNNeGpwY0kySm14eVhNTVJCL1NOYXF2?=
 =?utf-8?B?dEFDN0w1a0hyQWRXdE00Z1MreThNOXZvbnZiVTNGWjNLeXlhVzJ2akIya1Y0?=
 =?utf-8?B?eUk3N2g3U2RVT240MVUySkhVdWRsMy9UdnZDSWQ1cHlicXlXWkxZcm8vVzFM?=
 =?utf-8?B?SVEzWngxYTBPY1gvNGw0OXJMZ3RJQ253bzZKajQxbjdicWExVGZxVStPZk1k?=
 =?utf-8?B?Z0puYmZONDNOcVFaTDhYMVhqcGZBSGxXRitiNnV4WXNrVVJ0NjlZY21wTmcy?=
 =?utf-8?B?TXV2bmtCWUp2dUhiZlZvbnNjeXpwWHczRGErcHBNcVcxQ2VXcW9HTHdhRi9w?=
 =?utf-8?B?aWV4MVRRMnhQbGEvN0lWcU1Xa1FUN0JTT0k3QzZqL3pPbDVzQmJRL0QzVjdC?=
 =?utf-8?B?cGdZU0xoa0FVYnJjS25BcW5GZ1kvRnJuNHh1RXBpV2ZkZmtJSEZEWWhrbWU3?=
 =?utf-8?B?ZVBhV3ZTdWtnK3ByRTJlMHhMK1htajV3VVhQaHljdzI1eVN6YWI5RmZxcjEw?=
 =?utf-8?B?MWVWYk5uMWtjWXorWHdLa0ttblhHVjcvT1I5QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ky8vRGxqNjA1dU02YWJaUm5EMitsWTMxYmdIRStGZWExRW5SbVprMVlHcmxs?=
 =?utf-8?B?Y1ErQ3dqUmo1SFdhSkFFK2F5bkptTWNET1V5L1gzVVVMWGZxaEk4Mjd4eWlJ?=
 =?utf-8?B?Qk5TbzdUak9hSEFzMHFra205cm9XdkZmNGhYdFRCRklqWnNYNjR5TnBlRFI0?=
 =?utf-8?B?cUd1SU1JbGpXRnQ4L2xlQTM4blp1U2daQ0FBc3BSblhuamZXbTQzTW5ZbzRL?=
 =?utf-8?B?TFBZM09lUDFrQ05CVDNMUm1HL0RSSkdPdDFXM3FsS0xIVFlzbkk5YjdET2Rj?=
 =?utf-8?B?V1ZTUElsSFVQQnVENHlsdGl3eEdyQVN4TEJ2VDBvYmlVak1qUy8xVHpzQUJO?=
 =?utf-8?B?anZMbFlEV01zd3NOUU5oOGJMR2N5TCtXcGNKdW5sY0tGSTM2SmtvZktHa0dt?=
 =?utf-8?B?bXdnbllFVktEbEg1U2ZQMVpucmczWjFTZVFMNWhxTUNCNFNZUjBoR2JFZjFX?=
 =?utf-8?B?Q1o0ZHhHMkhHWmxPcUJWM0hNa2NYT1R2UUNJaHV6cENoVW1hUTR6ai9xNGFJ?=
 =?utf-8?B?U0tQOEFUYUV2UzRjVlpWcXZ1NHFrdjVzb2lFUmFNbEtkK0FPZ0xmK1VWQTNh?=
 =?utf-8?B?RGFEUTA3RnFOYmhsblQrSjNzVDdXemRINXpqN1REUmwyY2JXam5NSStRdHJT?=
 =?utf-8?B?VFpXd29YbTNabWRHQ1cvMXpYT0FXSkVBOXZjUUlEVW5Ob0tGcjVaNmUrVEM5?=
 =?utf-8?B?ak9uWkhjMDlTZ0JtTENvOTJzdnVRcENhZzUwM21OaFhZeTVuR0pSMjhwbVdt?=
 =?utf-8?B?UnltNDFQYUlIQUdGd0l0OXVKaDB4dWw2OUFUYjlsUzYzRlNjbDAzL0RqSVdV?=
 =?utf-8?B?OXRCMEQrclpqQkx0aTNhcTNOTjVoSzI1MnpFSzFHbG1KcUhRck9oRk1UVktT?=
 =?utf-8?B?L2xoaWttMkwyc1NVMkxTVU1BdGJXQXhQOUNkQTdGaHpPOGlWdE5QYUllcUY5?=
 =?utf-8?B?a3F1eWlvRnczYjhKN3dRc2dyWGxXWktlOE1hMXNVRGs5RVEyQ0lsL1AxUldP?=
 =?utf-8?B?N3YraWQyZDlwUzhhdzBYaG9VVkQ5Slh1UnFKQWZRVVFJcGl1djc5U1dhZjEw?=
 =?utf-8?B?QktnVlIvTFo1MjIvdUhjYU5iZlRJRjFUU3BvaWtqN0RvOHdCaWZyR0JFekxX?=
 =?utf-8?B?Mzdmb2IrdHJKL09CRXJudEo2UU40V3RycmF2aUIwM2J3Vm9ZelVLY095emxN?=
 =?utf-8?B?dkJmR215Qlg0WThQdEtyU21Cb1FWR29IdXNpZCtrR2R1dHhTbWorbHF5SlBD?=
 =?utf-8?B?NWdIU0N3enp3U0xaUlhSRHBheW1LcTdRMENOa01wVGxuTTZBRzZBRkxKMWxp?=
 =?utf-8?B?SkkrZWRZVTNod0dTUHhxb21mY2N2UWdkNkJWRGt4VUQrQUhqc0ZBVTd0RHZV?=
 =?utf-8?B?NXorTUlQeTcxT1NqckxvL3NTL3hGTFR4eGorekNyVFJWYisvV2JLQk9tWnJU?=
 =?utf-8?B?c0dYcytsVWpYWW4xUzNNTTdzUWVKUEQvc1VMQ09YblhKcmlOQnFaNk1lVmlG?=
 =?utf-8?B?R2RSMHQreXNjVlR1QzVSMlJEeUtndENTbFZWdVlUdmRNNzloeldCdG1LdE1k?=
 =?utf-8?B?UnNUbUFnd0luZXFUNE9oOXJYZTIvWHBFOW52Mmh5ckwwSjBRdG9VZitvMkVm?=
 =?utf-8?B?R3A4YzBSb0dxL3Z6SEFsV3d6a0hTK0ZDcnQyckp2K2cwK3RpSU9SenJxMXVK?=
 =?utf-8?B?b2R3T0tobG1kSDc3UzlrNEQxNm5iYk15VjJFUmtLNW1OWHpQNWpBcUdUL2hZ?=
 =?utf-8?B?TU5UOWx5eGM1OG4yT0M0OElvcyt5ZllYSnU3VHZQTmpZUjg5cC9iYTJWejRK?=
 =?utf-8?B?SXUrS05JNXJUaEVpSUtJQkhXU1ZMTkIyanhhb2FKb3VEMTJCV0toYnJnVmw0?=
 =?utf-8?B?VVBoQTFQTVBwa1NDL0l0OFpiNzR1Z3RlN3RzSGpIZzVqWDBzVHpDeFE2Ujlj?=
 =?utf-8?B?bHhLRitFMC9ERTgrL3hpb1d5dFRnRk45cHRKWnpxZW5tOStLdTFEaTJLRC94?=
 =?utf-8?B?NmFldEFNVGZzcE02Z0szWUF6ZXNDaUJrZitROSsrWi96UHFLM3hzY1BoaUtw?=
 =?utf-8?B?UGJBYVdFYnNIYWdkaWY0d1M1QUNMTEE2Y3dvZVUxTi9aTy9GdExVRTRScndU?=
 =?utf-8?B?dmlxZkVGeGhuQnAyUGRLTks2RlI5eEhvZ1RZczkwRTdERGVrNkxLRmNKcHZ0?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66237D4A0A35664791BD907CF085BFA8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed29cd2-8450-4d40-fd94-08de0d49eaf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 06:53:45.8242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XnFbsHSsmcbhyejEUyklE/93nsN/sCoUt6Bd72DjSQbiiqrPSU3om1Q3z+uGos2L9unDh6fjqefOwXFKt7LpRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9367

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE0OjA2ICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGUNCj4gDQo+IFRoZSBNZWRpYVRlayBVRlMgUEhZIHN1cHBvcnRzIFBIWSByZXNldHMuIFVudGls
IG5vdywgdGhleSd2ZSBiZWVuDQo+IGltcGxlbWVudGVkIGluIHRoZSBVRlMgaG9zdCBkcml2ZXIu
IFNpbmNlIHRoZXkgd2VyZSBuZXZlciBkb2N1bWVudGVkDQo+IGluDQo+IHRoZSBVRlMgSENJIG5v
ZGUncyBEVCBiaW5kaW5ncywgYW5kIG5vIG1haW5saW5lIERUIHVzZXMgaXQsIGl0J3MgZmluZQ0K
PiBpZg0KPiBpdCdzIG1vdmVkIHRvIHRoZSBjb3JyZWN0IGxvY2F0aW9uLCB3aGljaCBpcyB0aGUg
UEhZIGRyaXZlci4NCj4gDQo+IEltcGxlbWVudCB0aGUgTVBIWSByZXNldCBsb2dpYyBpbiB0aGlz
IGRyaXZlciBhbmQgZXhwb3NlIGl0IHRocm91Z2gNCj4gdGhlDQo+IHBoeSBzdWJzeXN0ZW0ncyBy
ZXNldCBvcC4gVGhlIHJlc2V0IGl0c2VsZiBpcyBvcHRpb25hbCwgYXMganVkZ2luZyBieQ0KPiBv
dGhlciBtYWlubGluZSBkZXZpY2VzIHRoYXQgdXNlIHRoaXMgaGFyZHdhcmUsIGl0J3Mgbm90IHJl
cXVpcmVkIGZvcg0KPiB0aGUNCj4gZGV2aWNlIHRvIGZ1bmN0aW9uLg0KPiANCj4gSWYgbm8gcmVz
ZXQgaXMgcHJlc2VudCwgdGhlIHJlc2V0IG9wIHJldHVybnMgLUVPUE5PVFNVUFAsIHdoaWNoIG1l
YW5zDQo+IHRoYXQgdGhlIHVmc2hjaSBkcml2ZXIgY2FuIGRldGVjdCBpdCdzIHByZXNlbnQgYW5k
IG5vdCBkb3VibGUgc2xlZXANCj4gaW4NCj4gaXRzIG93biByZXNldCBmdW5jdGlvbiwgd2hlcmUg
aXQgd2lsbCBjYWxsIHRoZSBwaHkgcmVzZXQuDQo+IA0KPiBSZXZpZXdlZC1ieTogUGhpbGlwcCBa
YWJlbCA8cC56YWJlbEBwZW5ndXRyb25peC5kZT4NCj4gUmV2aWV3ZWQtYnk6IEFuZ2Vsb0dpb2Fj
Y2hpbm8gRGVsIFJlZ25vDQo+IDxhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNvbGxhYm9yYS5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xhcy5mcmF0dGFy
b2xpQGNvbGxhYm9yYS5jb20+DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5n
QG1lZGlhdGVrLmNvbT4NCg0KDQo=
