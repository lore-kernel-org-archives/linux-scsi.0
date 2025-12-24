Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E96929B204;
	Wed, 24 Dec 2025 06:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766556872; cv=fail; b=rhr8IjYqXENEiVhkVMC1zDHAQRtdR48tIBziiVeqvACfNPSyIWKBcmAdq8wS/ShrpoAZEq7TK3NEDwdGym6jrL+RXVhcF4WEJ7OXx5+JelcxO+qnmgK3q6wGl3xykwA0pRi4DkLwYUE42QBzK2VU+KU0LSJTC4GwUcSpVr9JH8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766556872; c=relaxed/simple;
	bh=LoDNrPrs2fFSlIHatSCXBHgf7hmuaNEMyCjHlh/m2fo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C9a4Z3rQP54Ejpw839NdDzixGIlU77SI8y5B4NvYoy/C8hMUG//wGRKlId4ZJcrq6Mm+GFEN7Pk8N4oMOo6Kqt5R8ISOYc5ueZ+p0PiGMuB65WBZWlRSKuv4Ih/YwoA3d3gVQ6oVnw8eSP50I2VaceYyz3Wk6/d2IaL2wKHLyr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ScWK1NWf; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=TyOl/pAw; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ScWK1NWf";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="TyOl/pAw"
X-UUID: cc694054e08f11f0b33aeb1e7f16c2b6-20251224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=LoDNrPrs2fFSlIHatSCXBHgf7hmuaNEMyCjHlh/m2fo=;
	b=ScWK1NWfdG4RIs4L9ByJigSwDNOaKywwY2A2oWIE6dAff5JTn2h3IInrrLgt0S8V+TjQRhuaaD+fMCfiIEAfeFPqNvjEuNKOGpvTqMq1hR09mcDW/NPmYVNWXm/JKqgdaaNNOAiVx9Vik9zVBNBbnhbWEKbtT9uDRqsad/px2Dg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:618afb19-a8e5-4222-9273-df86ef5f164a,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:8134c9c6-8a73-4871-aac2-7b886d064f36,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cc694054e08f11f0b33aeb1e7f16c2b6-20251224
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2011910390; Wed, 24 Dec 2025 14:14:26 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 24 Dec 2025 14:14:25 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 24 Dec 2025 14:14:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpg/r2/xLZnk7cipuhSKb8U7yNIxJC9zCwIsy08IdUR6kKbeM2OYITT7SxYb7Hh3xR70iU0ffoNuqXZs12hVKUuEE8HY9FS0wlImAfR+/syL7k/amLBH0C4kl3b/Yjbr+6w+PT/cmI2eM7NLALIpwyP7wYZetRHnhOsF+l1byCzqsfksEGl0PqyzaGGDI9Yz2Iv8Cp/OrMG/EIQDEyipkUkbjWvV2f3Q7mB5OqBVmA4Ho6TZPEwI56SpfLl/grqL/4d9DA1GVKLFpyoEURJ5fWWyNfFVkQZ4kaEHrlaW5ntCHLp+op1W9Pyjo/n01pJ865c/JTgDw/lRLhPHWOVnKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LoDNrPrs2fFSlIHatSCXBHgf7hmuaNEMyCjHlh/m2fo=;
 b=ATuDMJvFg9V+xBuNUc03j+WqEztTw0afUBSVGkFEtEdfM0eZlkTM/BP9qloshgqZYifco4CRl+pGHdJppeCkHTsWrMZNKiNEWnHnjUZ6yiw3Bf2Pas8ZZQnxUKbpIffvwOH77ExZA8D30tDNBcy3vayIxxXnB4OkTvMSXogd/ihukjgoG9B7A0sSfDm6MV+dMn8sICqLyDguHBTn9sAPs+h1VsamwMnsB8mkKdtC8XMM89VH4c33w5hsqGnJ+1ZCIpsHltCf0cve16w7b5zyd36pRxH54ZaCuPnkxc3z8b8Rot1yuS8VwSiGeCamealAP0vTNwSqRNr9IMm/qM6ZTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LoDNrPrs2fFSlIHatSCXBHgf7hmuaNEMyCjHlh/m2fo=;
 b=TyOl/pAwFiRDV8X4zUQ3x71EKpk95uLjVDYc5VOt9sixNMBBQqEV2ex9M8keE4Jq7SHofs6UNnpjQY8Oeub6N7iOWEk2qtwmcffjTPwVskpNBTp1po4V6YuP9Ph5NtCu50jn5IGN/eXRoMkVrvIvcS1syHZrLd0PtLIVQprYCWg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6695.apcprd03.prod.outlook.com (2603:1096:400:1f1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Wed, 24 Dec
 2025 06:14:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9434.009; Wed, 24 Dec 2025
 06:14:19 +0000
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
Subject: Re: [PATCH v4 08/25] scsi: ufs: mediatek: Rework init function
Thread-Topic: [PATCH v4 08/25] scsi: ufs: mediatek: Rework init function
Thread-Index: AQHccB4BJslCRreJCEqoGE8ic8sZ+7UwWNeA
Date: Wed, 24 Dec 2025 06:14:19 +0000
Message-ID: <cb912a89b651bd64a0f2f088bd4f802b68825d80.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-8-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-8-ddec7a369dd2@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6695:EE_
x-ms-office365-filtering-correlation-id: 8939a1ba-7818-4b6f-3880-08de42b3acbe
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?cHFJN1RobnBCRWNXdUd0QnVyVHV2QnZvTlhmNStWaU9hbU4wQkV5bHg3R1hS?=
 =?utf-8?B?MjlTMXVCTEUrYkkwVi96c2lUMDk2V3ZBMVhTdldiUUFINEZwVXZzb3FpWHh5?=
 =?utf-8?B?eVlIdTJZZW9KemYzSTJBdEludWp0NGd2N0hIaENPRTV3OUtBQ0FQWU53d0xE?=
 =?utf-8?B?TE9FOTU5UmhZN0N5V1FySW1sMHFQdGZlbE5UU2JMekdrNFQ1Y1I3N0d0Smp3?=
 =?utf-8?B?bUc3UjNKcHpjcm5QdFBJb1VYUC9mNnh2VzlkdG1MZW1HMUs5Qm42TklIbU04?=
 =?utf-8?B?TWZSR29KamV1SU5wb0I5NUZqUFZGVWVPMG1vQ083dWd6cnVxQ2p6cXpZeXd1?=
 =?utf-8?B?ZTBKYlgyQ1lHUE9ZR2dVK3BCWEtCT1NGRHhLZ0g2WGdvekgvTW0rdWM0VERS?=
 =?utf-8?B?UndJc29YYUs1YWloYi9GZlFFZ2RXZEtGSXZZclZ6M1RIYy83L28wUVdieWNT?=
 =?utf-8?B?MjUrTFhCZkdrcU5MNndPeTJaa2JZMkU5azNSYzQwQWRzeTI2bkRtZ2o4Sktx?=
 =?utf-8?B?UmJFOXN5TGlaT0NLMWk3NUYxRzloMnpYUVdmRlF2cmEwcnkzRDl6dkZ0Tmpw?=
 =?utf-8?B?NnYwZzVPVHlYbzlmTmNuemtqUzcwUHNQREkyNnluYVZxcjUvOC9lZS8rM1c3?=
 =?utf-8?B?R2daREozTmNKZ1pBUmtBNTFCUDlqZ3pDdFNWSU1FRzZIYUlpdUU0MTRUUWlR?=
 =?utf-8?B?dUZENVhqMTlZUGxrK0I3WHhXb0tiT2hOL2d5UTltaXNWWUJyOXZRYldzSEx2?=
 =?utf-8?B?SWNENm5KLzRhSzBmekdaR0FvZmovRzE5clNFcUJzbUp6SXI1R0lGdzhITWdj?=
 =?utf-8?B?djNIYldieHhQUFNySHdZbVBXaGtyL3ZhekNNQ3QyMkhPRVNIS2ZiRmNRcU5u?=
 =?utf-8?B?R1o0WVlhL0FXQnRMVEZ0bG1VZWloRm1XbER6WURDWTQvMEtPLzlEdTgweHRU?=
 =?utf-8?B?L2NVZkhEZnZ1NkpLTGtnZzFjYmExMER6WDFDMklnYlNVN3UzZVoyZHBTait2?=
 =?utf-8?B?cnFaR0JPaVdvWlhRenllWVRIYkN2c1VqTWlQUjNYWXNzSGRMZjlvWkpRQXRa?=
 =?utf-8?B?NkpiNUFxeXYySlMrcXVOeEgvU3NCOGkxbjRLRGxTR2ZBeDUzVk1FNk0zZzZB?=
 =?utf-8?B?VGZWQXJmbWdkZUdjYUR4aHdEdTk2bFBLVnUyYXZoQ3cwRU1pQ3RGVVkvY3Nw?=
 =?utf-8?B?L2JmbFpDL1RBNGRBOHphemVrK1kzWTFlcUdBZzNDcWZjV1FCaTRGUzVaQlBN?=
 =?utf-8?B?TDBXSHhpYVdzeGZ2RUJKdktoMFJuVzA3dXNjZFdQVHRnME9mRmo0RjhiWnFK?=
 =?utf-8?B?ZnErNTFKZ1ozaEN4eVVMZzgzYkxacDgvUVFRQVZySEdTSHdhT1JhbXVXZDJU?=
 =?utf-8?B?VzdxSytHTFU4dUlFQzNwZlBlZkRVUjhZemVHQ29ISnNLUFVUa2RxQzZ0S1dW?=
 =?utf-8?B?dEFUWk5hMENLOW5hV1J5ekNsbnpYT3Q2UjlId01Ob1E3dlp4MiswL2pOWnMv?=
 =?utf-8?B?WXVQL0J4ZzJzcGFwT2loaE5VVGI4aGw5dVdQYVNrZEZxRmUwRlVJM3RWa0cy?=
 =?utf-8?B?YUE4RWpvaDFpNUZONlllRGpTcmFRWUM4ZEpUQk40NEZ4eFFaSmlzMFRFUGhL?=
 =?utf-8?B?Y0s2YndMWmdDaG93V3Q5QnBmeTc4WVcyWllLa0lqdW1pVXZsMTJlbmx1b3Nn?=
 =?utf-8?B?MXRvNTJxME51ZVZDUi9lRXRPSkJZeFZESDR4OFdJNmN6eU1RWWtVTFc0V0FT?=
 =?utf-8?B?d2RiZHhrR1lxaDVzdmhqMEtvRE41V3o3S204RWdqZ0hBOEcwUnlHcmhpL040?=
 =?utf-8?B?b1J2LzY4TzBqWklrbFJzQmtkSlFNbEdGVDNvdjZNbWp5UEFUTmo0RWVrUDVK?=
 =?utf-8?B?blNscEk5NnJDWmMzOWZRWkVDeHlSSFNXY0l5dHhveFdNaGw3UXh3a1ZWUldT?=
 =?utf-8?B?T0lhVXVlSEtUM0huVjNvUlBUU1U1eWhWS3creEZEM3I5VXZzMDhxbnYrdm1M?=
 =?utf-8?B?Q1BCaDZ2NkdEQjUxMUZDVDNuRk9DR1lsaWN0WWg5ajI1TldtZGxpTzhiUEt6?=
 =?utf-8?B?VkpobGRFUWF6ZUNoc0xWSHMrWVppcGxveWZTQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEN6YnNKVHExUnVWNG1tV2JlM1V5SmRGbDFabHVVdWJVLyt1OVIwWWlaUnQz?=
 =?utf-8?B?MSs3MXJhZC8wcjBJek4yMXBKZDN4Smw0L1M4c1FIdjdKUHpSYUFGTldCamVV?=
 =?utf-8?B?NUhoZXdVZFY5aVdwZXU2ckNpbWY2NEZHdjBCa2c4d1owdnZEaW0yUEJGbVNm?=
 =?utf-8?B?bGcvNEhGVXVDYy8vRnVUZDQ5bU92ZitDRnFjTFp6SGRBeWtRcXp2dkIwTUUy?=
 =?utf-8?B?bU1JM0JJMTJ3WUlpTHYxalVQVWdLUDVZUHhJRjh5YVlBanVvTUR3Y3o0akk1?=
 =?utf-8?B?VG5rSndIRXBESXIrN3RGeEJVN1Y0dGc4MC9xZ0kvMUVnMDB1RVRta1lWOTdx?=
 =?utf-8?B?cXFudnhjM1hocE81Qy9ISWRvNFpPQ3hVZXFIaG5qOGpHay85Q0lCTjVJYldt?=
 =?utf-8?B?WlFlNDY1MVJUMG1KM3hyeGNyN2s0d3BhRHdwWml5KzcxWU1nVkt1YVBWZWJK?=
 =?utf-8?B?SHY5dXYyK250d3ZTY2JSYWNyR0hkYTF1SHpzcDdPSnJJaXJDWUdSV3p5ejlT?=
 =?utf-8?B?QWk4cUQ2SUpKL2orc3Zoamp2ejFEZ1lCU0hYdDZPNUR5YlIyZ0c0NzFRb0Zt?=
 =?utf-8?B?ZjRSKzNPalcvRnFITUhZTGxFa3pxNC9YUERIcmdOR2VMU3RjR3hWeVh3WnVl?=
 =?utf-8?B?U2xscDhTelprd1RGRFpiRlVQWFpXS0c3Y3J3am1lMjhBSTliNjF0SWxTYzU1?=
 =?utf-8?B?SWFzd0dxY2xhYThHN1loNU9FMElYMktUQWh0eE9VWDl2cU10QTlVQVg4ZXh5?=
 =?utf-8?B?L0FxT2w0QnkzNWJUazR3ckY3WHBCMmFKQUtWc1ZhV1crcHJLaU01dkNJTGhG?=
 =?utf-8?B?S3NsRkFNSDZ5RkNMZFA4d3hHMmd5NnJWN1UwMkdGMWdtdG40NDNoNkdTT0xM?=
 =?utf-8?B?R0ZVUzg1ZERYU0o4aTgwSGJ3TFp5MndITnBsa3RSSjRQRXd6YUVxWjlDYWxS?=
 =?utf-8?B?MVR6aXRJTUMwRzQ0Yi95NGRqc3c3cFNXVTdGMWpOa0JWaGEvZ1JZb1J0ZERx?=
 =?utf-8?B?WnNhUnFrN3lBQkZ5dktGWTZ1N3RJQkQ0blV6NjFDUEY1dnRPQ1ExcXh4cjJu?=
 =?utf-8?B?Uk02R3FxQkM4Y1pud2hQVWJBUVFHMHl5RElJYmdzaEIyV2JpSlhmLzF2bmp6?=
 =?utf-8?B?Q2xxYjE3S0txVEdvY2VjczdJTFZ2UmdjVXdpRHJNM2JMOE5tU1ZFRVVOZlVG?=
 =?utf-8?B?aFN2bFJXYkJFTi9mODdKLzBXRFpWK0poSGNnaVhydmNOOXc1cjFEMjlaZnlR?=
 =?utf-8?B?YnltSFFhcHl2V3lzSmZQemgxWnNJSFoydWRmWWUvWkphQWZYUEhUWWd1Rjcz?=
 =?utf-8?B?RElmeUVBZXZCVFNrVUFkeldENHFrTEtpQllwS3hwdVBkanBvQ0Z0d3FTSDBB?=
 =?utf-8?B?M09Ba2lVRnFpL2I5WGFVWWtBa3k5bUhBSHl2LzN6WnVoS2RpNDdGOUlRZUo3?=
 =?utf-8?B?M0l4T1pIMmdJRVl5YzYyYmRKNHhUeWEwVzJma2NSNU5ib0l0dkU0VkNVMWpS?=
 =?utf-8?B?eFExNys0SkxvOGdlOHRpc3FJWmJHSWhnbkVXN1lma3JNQk5QZHREcnZGbHVp?=
 =?utf-8?B?Ull1Y3F4Q3pVYVE1QXBEQlRVVEtxdmFWWDVTY3F5TkNWZnNsQTdzVG1FK1hK?=
 =?utf-8?B?cE83UlVPSm92L0xRMDdUMnNVdUFVWEpJL1Z3NTdHRVJWNVRaV0lkS2wwWjln?=
 =?utf-8?B?RElrT2NsWGJUaTI1MFhzNzhsUmQydUxvMEwwd3dxVlg0YnRNYjBpczZhVDE0?=
 =?utf-8?B?OUgwN1R0VGhyZlA0Y0R1Tjk0UjlBUVFKd0hHUjFvREdEN1JHZkpBWjJORTVK?=
 =?utf-8?B?RFJDbkVaS2t5YXFUT0VNbk9mQ1ZobWNla25XK3FnTXRkMkpuVXduNjgvOTd6?=
 =?utf-8?B?LzV3bmY1OXJoZUNzUWU0bXRNQ0ppc3JuVEFQTU9UYmhuZ0NHbGVlcEExQ3Z0?=
 =?utf-8?B?NkQ1MHR2OHR1M3dmUHAybXlWd29PeFFIbmw4dWwvVHRtaUJrbGg3blJuS21W?=
 =?utf-8?B?dXB0d2lnRFJKNDJVc0IxWFBCVHhHTFcrcjZIK0lkYkFoS05VbElBZ0JObzVL?=
 =?utf-8?B?RW9SWmJBS1RYV2hpbkVRamcwODE1UXFuZ3FQdk15eDYxYmNUc1ZSb3VVcndV?=
 =?utf-8?B?aWI2MkRwZGNHZVF6a0ZMam1iZ0hHY0VNeEZlUzRuem5YaCtiSXNaeVFFL0pW?=
 =?utf-8?B?djRSVmpjUk4zaFc5eWx5Z3hxU2xDQTVYUU5QUnBSWHMwTVRmQ0Y2V1hteks1?=
 =?utf-8?B?Y0g4VDhrSzRSUFlGbkYrOXR3b290amtUaG1iTVZZSEltanVaMEpUKzZ0dElr?=
 =?utf-8?B?ZVJ4dlJoMFhUOHc2eWR5VnFGbHZJZ1JtdzdJZHFiVUt0UUpSelpTSDllUVZU?=
 =?utf-8?Q?L7qQ7qDZ7VnOvAK4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8158296FF7D9B64BAACFAD969DA95168@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8939a1ba-7818-4b6f-3880-08de42b3acbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2025 06:14:19.7646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SfLW22pQ/SQWwB36ZJqYm7a7Yc1rpexhcdHqRIDvHWNrLkDUHmT/QIQudQ7SnC0913iL7eddq3BU41sx8MIBgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6695

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDEzOjU0ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFByaW50aW5nIGFuIGVycm9yIG1lc3NhZ2Ugb24gRU5PTUVNIGlzIHBvaW50bGVzcy4g
VGhlIHByaW50IHdpbGwgbm90DQo+IHdvcmsgYmVjYXVzZSB0aGVyZSBpcyBubyBtZW1vcnkuDQo+
IA0KPiBBZGRpbmcgYW4gb2ZfbWF0Y2hfZGV2aWNlIHRvIHRoZSBpbml0IGZ1bmN0aW9uIGlzIHBv
aW50bGVzcy4gV2h5DQo+IHdvdWxkIGENCj4gZGlmZmVyZW50IGRldmljZSB3aXRoIGEgZGlmZmVy
ZW50IHByb2JlIGZ1bmN0aW9uIGV2ZXIgdXNlIHRoZSBzYW1lDQo+IGluaXQNCj4gZnVuY3Rpb24/
IEdldCByaWQgb2YgaXQuDQo+IA0KPiB6ZXJvLWluaXRpYWxpc2luZyBhbiBlcnJvciB2YXJpYWJs
ZSBqdXN0IHNvIHlvdSBjYW4gdGhlbiBnb3RvIGEgYmFyZQ0KPiByZXR1cm4gc3RhdGVtZW50IHdp
dGggdGhhdCBlcnJvciB2YXJpYWJsZSB0byBzaWduYWwgc3VjY2VzcyBpcyBhbHNvDQo+IHBvaW50
bGVzcywganVzdCByZXR1cm4gZGlyZWN0bHksIHRoZXJlJ3Mgbm8gdW53aW5kIGJlaW5nIGRvbmUu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRh
cm9saUBjb2xsYWJvcmEuY29tPg0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb20+DQoNCg==
