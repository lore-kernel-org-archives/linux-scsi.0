Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EC01C2334;
	Mon, 20 Oct 2025 10:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760957209; cv=fail; b=seVL1OWRFMDKJbGRVfmc6YzP8cm0VICdwK/gqY8g6ZelOoH4Zxek9os88nxuH2mbVItmWDRzueHu+2vEVLjOLGKdTd8mFk6jmOJZ6+jwLkFKZZmK2zYIe/tlqCBo7P0EDQ0dsbOQ5ba6xe0DOd9T+KG7j6+AQXo5ZfGJpOJs/dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760957209; c=relaxed/simple;
	bh=Q2Iu070SHwWF0uNY397PtoLvujXQ1FIPtOjSMYLoAjM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sjmo7uARi9ck0YmcDus+mu+edzagA4s8HiPQHN0pAnqWtibj5wBiRViKIdpTabCe8PT0xLQJPqqoJV4RWM/KYJDsGG43EwM9eFp04svktK7v74JdIKcsPCVIfBCkih/Lf30BojnwYCw/V1CrY1//lSOmgd0ZG5G5Irg0ibdmtUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fV4X1Q0L; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=MlUCyzuu; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fV4X1Q0L";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="MlUCyzuu"
X-UUID: 0f45dc82ada211f0ae1e63ff8927bad3-20251020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Q2Iu070SHwWF0uNY397PtoLvujXQ1FIPtOjSMYLoAjM=;
	b=fV4X1Q0Lt37bVmyK4NKTIIALnb2jo3M7v/rDADEgy6wmpgNC6m1p39UNvpNdk4ezX+DEsyrgIELFluWgu51bx2B9Ss0DNb05qsKOykdZ+nhxnb6eIsZxb1WRK/ay+CUK5nHAAsNmW4Z69p/xtq2aLTzRZEelxZ7IoE1PwRrHKn0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:8f70f411-6eeb-4cbc-b4be-8f51e0db804f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:11724051-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0f45dc82ada211f0ae1e63ff8927bad3-20251020
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 906997401; Mon, 20 Oct 2025 18:46:40 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 20 Oct 2025 18:46:34 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 20 Oct 2025 18:46:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afhpm0Ndi1O/Crb2gWi5Xjw7tB54CMNlpOajs/Kgbkk7CzRLzZZ993yXknUjx4vhH/xlHdJRbqpGP40Hf3EFhF7CHIzIElD8SjlSL5NvVQR9s11npEp+Y8qkZeAb+kaqg+RB2/xU2M4AHb13cHqW0dDU+ayJrvvQmVFVN7d4cSeKaPusAExaJ36bl6HrXnMxMoxq5W8l8Ngji2O/q6neruYuzs8tTZ7oc0yxZUeWBSrPZLlvk6WVLX6kt0W8GcmUHvKqjW/wa/YF8kJWl+hoXkoHjc9mEmRaIAX8t/dydbCwWgsxgsQqyth1V9SHUPjmQyThLLg//3kaFw3nTYsKKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2Iu070SHwWF0uNY397PtoLvujXQ1FIPtOjSMYLoAjM=;
 b=TKUl1UH6Zs5Kqeap4+xyXu+JoL0iqR7JhWUJcMWNDpA/kzvIhjSfsNoALo5Sbh735htJLJv7MateoGaoFLfuRUu5lPmwM5O10LTS5GyyLFiTVJN5M7W3BlyIk1/MyBD3FOTlgMZRRHNVqK/3tCJsPZ6oaG2ousLxnMyUozgJbrCwHsSXvzNLTJGtTqvdIe2UDz76dNvM2gpTnLgPA/sm/c6vLovzgEYC9IrUayeASFInPO/t9rHHwAOB/TSP1KsAKuyRFa4UhwwkPUG+omA+Z1xXvF7lj53E0E7/ZEoVKdtx72b6FThUyuRgs28efHNcvF0ifU299XSPsK4I5OsqtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2Iu070SHwWF0uNY397PtoLvujXQ1FIPtOjSMYLoAjM=;
 b=MlUCyzuuZ+t/w6S44G5PiafqlN/M0fEAQB3JyIIukkO2GYm5C/W/wR1Tb+ng7KGY0RaBJQHiEvY2k+++4mGW7RUxKiA0lXNGfaq68UXT9OtRdkHvfYpWJx2E5dQq3p3BSwMOrvi1Gfr1XFW4rprcwWCUgHKQVVPksQoyJNyEMhE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYUPR03MB7161.apcprd03.prod.outlook.com (2603:1096:400:355::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 10:46:34 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 10:46:34 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "robh@kernel.org" <robh@kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?=
	<Macpaul.Lin@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "krzk@kernel.org" <krzk@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
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
Thread-Index: AQHb+ubXEcM0idFfNEe1g+HvnHp2OrQ941oAgAGSzYCAileogIABbykAgAAEWwCAABUpAIAAA1sAgAAN9IA=
Date: Mon, 20 Oct 2025 10:46:34 +0000
Message-ID: <95d3fe686abcd4a6070c6613392fdb9605bdd73e.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
	 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
	 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
	 <438077d191833bb4f628b2c6da3b86b3ecfb40e6.camel@mediatek.com>
	 <cb173df9-4c70-4619-b36d-8e99272551b6@kernel.org>
	 <a9bf15e48afd8496ca9b015e7f5b03821863a0b2.camel@mediatek.com>
	 <7f285723-ecd7-4df6-8c9b-f2e786ce3602@kernel.org>
	 <4b3d2678d2b724fb53ec7272ef8daf52197d4a0e.camel@mediatek.com>
	 <4dc420a3-cf89-4f45-84e7-4d0079240681@kernel.org>
In-Reply-To: <4dc420a3-cf89-4f45-84e7-4d0079240681@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYUPR03MB7161:EE_
x-ms-office365-filtering-correlation-id: 5a5f68e8-6e8b-471b-ba34-08de0fc5f007
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|13003099007|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NXhBRUdFdWFScjNIOFZxOFhzSjdyOXhWMmJTeFlBQW9nWWU3QjJqNEhTbnFv?=
 =?utf-8?B?OWVndXREbk5kbXc5NDRBR3V1Q3pCbUdiSTBUQ3JEUjBQTWJBckc4YjNaa1NC?=
 =?utf-8?B?Mkw4TGt6ODRRL2QvSWRBNUpqSnlxZGNzTjJDOGsxdmhSbDRaYUV4Nm5xdTFH?=
 =?utf-8?B?bjJBc2xTMHM4R2toWVNmMFdGaGE5ejluQktKQ2JwUHIyUW5Gbi8xenUvTFlC?=
 =?utf-8?B?ZE9qQ2ZGOGc4bU5jbjYxMWNScjZrWnhCN1FjcEVsM2VFa29uQUZxRnZmdUgz?=
 =?utf-8?B?MnRNeXpsb3M0T1d6NnFobkhXamlPRXF3WUNiZTVQV1J1ZkYrbHNCTzdxQ3Vt?=
 =?utf-8?B?N1NPbFJsOHNMWDlUQ2E1Z0FqcWg3dXdza25pY0RyV1htWTVrbCt5N2pVd0kv?=
 =?utf-8?B?RUtsclNhVXVhaGVocmFWL3NvLy9GSHU5eHVnWHZ4aWpnZ2FKbnRON3kxQlZO?=
 =?utf-8?B?ZmVGN3ZMdHFsSnZPM0hKaW1pSm5INFNhSzR1dGtTMU1OdGNGenJlSm94QXJ0?=
 =?utf-8?B?c0tjdXhWemxFY0FuNE1mY2haMzdyaEtBYy9yaWMxVjl0N0ZCTFJEYWRaYi82?=
 =?utf-8?B?QUdkTTR1OWtBb05GQUQ3bUtESmkxZFE5VGdzK1gxU3FxWnJmenorR3NBWkZD?=
 =?utf-8?B?REpPaXR6YVhGNGtKNDRmYUVwekYvMDJMdGgwTDdQUE9yQlZ2T0xhenh5UXBE?=
 =?utf-8?B?VnhNNWFwUm1DSWVYVkdpZUNVWlV1NXFSbmRTSU1lYUxTMFBSVnVESmExNDk5?=
 =?utf-8?B?TnJxUjViczdoZ2owVVNlaVZUTitQYnJERnJxN05Ba3lmSnEzbWFGQS8wd0dV?=
 =?utf-8?B?SktnMllPTGhZSUN2d201ZmxCZUlVQ1M0NFFoYXMwaXowSzM4QzBlbDQ5SWs3?=
 =?utf-8?B?aFZ5ODBkMWhOc3p6QUFBVzlQVmdHNmlGWTE5MitkWkNhbHFwNU9walhsOEpH?=
 =?utf-8?B?OFV2cW14Rk9kdnVWMVU0dkZsb0lDYXdhTXlZUHBLSDdJdlFWU0NwVWVEQnVi?=
 =?utf-8?B?eGtzeUx5OWVhUFY0aVhrUkl1K0xxSXZ6bUthTlZrRGRMSlB5V0hCcEs0eVVJ?=
 =?utf-8?B?UXppRkU5U1Y0a2RnVW9hMmpKeFpvZkR0c0VzRi9uaDlMRlJ4QWZXalJzem5C?=
 =?utf-8?B?YWVYeWp6cFJ6SUtZMWJ3VTZDZVNkY1oxUFlqejhGemQ5R3RvYmh3RTIyampB?=
 =?utf-8?B?Q2ZsUlNDQnVVRUsydys4VFJyZWs0dmNBeXNISlQ3ZjlPZ3U5S3FzV29YWXYy?=
 =?utf-8?B?aDVtK1Y1TkpacDgxTE9wUmFTNWtBajF6OEtzcFR4U3A2U3grNVQwb1o0blJp?=
 =?utf-8?B?a1R0RWFhYWRvb0ZkZWdqL3dJdmJMcXRhNWJURTFuY1h4dkprTEJRdFZQVmdE?=
 =?utf-8?B?dGJsdkZ6b2ZGeG1XTjVGOWpqMmlLTDdIazhyMzdkbVl0TTVEQmNyVENkN09B?=
 =?utf-8?B?LzU2TVpXRDYwWlh0RWRpaWFnQ3hjK0g4bm9qckVCcllaZ2ZmL25nQXFJNlBy?=
 =?utf-8?B?Ync0Wko1U21kRXV5akgrM2o5ZXhYYUdNUE5DNzhQYnU0dGkzZXVRTGtvNHNT?=
 =?utf-8?B?UEprMkk3MWxKcFQ5R0VmUVRjV3JrU1d0UzVkSmxLN2UxeEkzYW1DdWlYanVY?=
 =?utf-8?B?S1lTcVNqeDkxUk5taTI3RVE5bk0rRnZFQ2VPdGtDQ21DSWVUb0V3dDJ6Zm04?=
 =?utf-8?B?dW5zUnZjay9xaDBWeHQ1VTdwUUxkbWU4S2l6bkhZdUUvNVdLallaWnBKTzB2?=
 =?utf-8?B?VVYrRHg0L0h1QWtETncydWs2VDFTYzN0cXcyTGxVWWl2azlqMWYyamNGb3NU?=
 =?utf-8?B?TUhTM3FJNnFXcWRkekpZYzdDbWg4cmhMVGw4YTNXVE5RYUttaHNuZDl6NVU0?=
 =?utf-8?B?bDlVb1ljNjYvdGpadThVWjY3Z0ZFdGhSRG5Vclk4VkJZc3MrOGJhVmFnV3RE?=
 =?utf-8?B?c0ZCVEpMcFNtd2txM3ByUncyUHdsdE1qb2U1SGJqVkgybytYNkFGcUljSkEy?=
 =?utf-8?B?SW5XaEVlcUtSSmhUd3RJK2ptUVE3bnliY1lKTUhiN0RJNHZlcFU3SVJLV0tr?=
 =?utf-8?B?ZklZamJwNmNJKzFEeGQ5dnJQa0IzdSsvK0UwdE5GTkJUV2VVUnlZRXFCdzRm?=
 =?utf-8?Q?Gf7U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(13003099007)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emNlNE1XcE9DNEppdVM3QmhKRndLZ3JCS3laWDFtVnBYR01iYlFsUVVvUjdz?=
 =?utf-8?B?V2FNcEVianFiYW13aW5INSt1cnNSYUZndHB0aU80SWxDSFVncTNaK2hReVBX?=
 =?utf-8?B?MXU1YitnVk03UnN3R1kyNlEzZ2x6OEFvek04RHA4eVpySlJmS2JRY3V0ZGV6?=
 =?utf-8?B?eWM5SnVIaGJ2eno3eUsyUFR3SWE5OHRBRWpldEVJcFI1N3BGSXoyaWpqMkpR?=
 =?utf-8?B?a0haYk5mSEVOV3FNRUpacG5rWUhOazk0MDc0RkxvU3AxUHpvT1ZVY3A3RWFu?=
 =?utf-8?B?YUZQeFJBaldPS0JFQ01DdGpQaXlkazlpaFg3aG9MRjd4dkxBMm9TRWVaQ0V5?=
 =?utf-8?B?N1VVM0hvdjh0Q0hlUDJSdjNyQklQdG9kMnJVVGJabXpwOUtHbGN6NzVCVVRB?=
 =?utf-8?B?UFVGVTdrSUVKNERpTFNhMTFnVUw4V054aExqbndSaEtCZENUTFdFNGVYMUhj?=
 =?utf-8?B?TmdEZnhVcmdVOG5TSnMyK1VEVUVnb25XNkZmdmw2blFKRTh0WXhJWFVGTUc1?=
 =?utf-8?B?ZHFJSUpOUWQ5blZGaDNBQUU0YUpWY0xyVGdNUXVpRlZXWGQyc0FmZjl5RDhH?=
 =?utf-8?B?TERLK0tmeFdsSzhLY0lBVG9uMGNlWllJdDNFUW9kS3BaMkNBZzIxaHhhUHo5?=
 =?utf-8?B?SHJhb1hxamtLZ3lWSGw5NXQ2bHNTRyt4ZEpIZnV1ckh3dVRoNllyZmxRSTMy?=
 =?utf-8?B?STBGeWZIVzBxK2txTlR2WDJPblZyQWJQNVVVbVEyZnFjTysxaG5ML2IvQUxP?=
 =?utf-8?B?N0IxUENnVHdhZ3hjMTZDaHlCNVpZMG5XbVp6dy84dFYrZzFzNTc5dmwwYVBH?=
 =?utf-8?B?YXllNFF6eXVSWW9sRnBTbGdWUVVXQkF5MnFmZml2elRNWW1vdldDa2lSUFdO?=
 =?utf-8?B?YVhMK0xtR0hSMkJaM1EwV2dvci9vR3ZSM0hTcXV5RGNLT2pxRHBqMzlzRkx5?=
 =?utf-8?B?RStIWE4zSW1UYWdxNENLSzF0TlNiVHo4S0tCRGhGSURURHZuZS96R3lSU0Zv?=
 =?utf-8?B?ai8xbXJzYTAyNzAvK29wT2pqYWlhT21UV3YveWNCcGZVV2NObHdlRC9HVXhU?=
 =?utf-8?B?TWxtSzVnYWFVQTNSRHcwR0EwU05JM2hIZEc3aGZvOEsvV1d0QjgvL3RicTFX?=
 =?utf-8?B?MjVYQzZ2UU1jYmE2WEZtT0JORmRDVTcxUW9wVlVhM2NWaTRGOTY0a3VjVXBi?=
 =?utf-8?B?dUpReWVpN3JCNHMrT2pvQ3Y4OE5xM1lpc0UzM2M1YmNsbGdjR2tXVnIrNjQ2?=
 =?utf-8?B?SDU3WFdrcFN1bHUvRnJxT0xSUzhaYklDUlhMa2NGK1NtT0gycXFjRnhJMnBH?=
 =?utf-8?B?MG9YclpOcTYrMXdPVS9YKzV3YytzalZNb2hpNGtmRXhOc0RHbGN0WVFxZFlk?=
 =?utf-8?B?VDVhQklVVGJqbWtNYjV2VENuZ0xtcEF1cW0rSXJWUzkyRndzRmt4bGRTc2xO?=
 =?utf-8?B?L0o0RjdjaitJZmFSWGppSmZGOStkREdXWjFKTTEyVmtpR2hiKzBWV1JmWG04?=
 =?utf-8?B?WlJrRUY3d2k4NmxJTG1LTGE3WDNnNGN3elJlREoreVVaZzlSTDlHS2tOTWk2?=
 =?utf-8?B?eTQxczZhZTIyU3RtRWd3ZnFNb3N2Z1FjdGUyS1FlandXNGJLUXZ3RkE4WDBC?=
 =?utf-8?B?WEVkYzhNYVdoSGc3WEdJNHdJZERPVEhvV0I0R24zSG1PbFNQYTV6RVg5TnJz?=
 =?utf-8?B?U1Q2SVlZckd5L3RkekZlS2xCTDJucW5ZZzVSaFBVNTdaZWt0Ym5LVkFjZm14?=
 =?utf-8?B?d2tYR0d3a05TbWFFTTE0TEYrVnpodmkrSVREV0x5NXY5UzdBTW9GYURuZm0x?=
 =?utf-8?B?bkZxdlVEWkdvZWF1eXczM2hRRUYzQ1krS3BNSlI1YUQ0U0tVR29kcVhCRVZP?=
 =?utf-8?B?QnpEd2lrYWI4NFNMcjd1U29ISTlXaXZRZTJjcFIrOGo0NDUzNnllT0ZuY1BQ?=
 =?utf-8?B?eEhxdVNyTGNWQXJpVW1CNG9ZZWEvdlpMUWR3eXhiK1czeFFzckNoOVZZRC9C?=
 =?utf-8?B?V29CcndQTVZHODZyaG8zaGV5QWplWnpiMUZQekVFMkVZM1FqRDZMUndWR0tI?=
 =?utf-8?B?QldsNjRSb09DVWx6Vk15UnYvWWRPV1VXWm1WL0FoVi9Td3kzdWdQb3hva1JV?=
 =?utf-8?B?TVlqZUlsMmlMYlBZbDBhVkgxeDFUNUp0eGJDaEhBNlByTTg3UzIyTjJyQWpa?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF99458813E49A4C8B1A272F6B39D4BB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a5f68e8-6e8b-471b-ba34-08de0fc5f007
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2025 10:46:34.3132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3NDwYm0T3pQ9myaH0EQGB+nBHmiJy93bcajSDKz99A+9F4piqiPHqXysi26n5/P7Te8TxtsqGZU/qtLLxzKJ2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7161

T24gTW9uLCAyMDI1LTEwLTIwIGF0IDExOjU2ICswMjAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiANCj4gT24gMjAvMTAvMjAyNSAxMTo0NCwgUGV0ZXIgV2FuZyAo546L5L+h5Y+LKSB3
cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMTAtMjAgYXQgMTA6MjggKzAyMDAsIEtyenlzenRvZiBL
b3psb3dza2kgd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gSGkgS3J6eXN6dG9m
IEtvemxvd3NraSwNCj4gPiA+ID4gDQo+ID4gPiA+IFRoZSBtYWluIHJlYXNvbiBmb3IgbXkgb2Jq
ZWN0aW9uIHdhcyBhbHNvIGNsZWFybHkgc3RhdGVkOg0KPiA+ID4gPiAicmVtb3ZpbmcgdGhlc2Ug
RFRTIHNldHRpbmdzIHdpbGwgbWFrZSB3aGF0IHdhcyBvcmlnaW5hbGx5DQo+ID4gPiA+IGEgc2lt
cGxlIHRhc2sgbW9yZSBjb21wbGljYXRlZC4iDQo+ID4gPiA+IEnigJltIG5vdCBzdXJlIGlmIHlv
dSBhcmUgcXVvdGluZyBvbmx5IHRoZSAiSW4gYWRkaXRpb24iDQo+ID4gPiA+IHBhcnQgdG8gdGFr
ZSBpdCBvdXQgb2YgY29udGV4dD8NCj4gPiA+IA0KPiA+ID4gSXQgaXMgbm90IG91dCBvZiBjb250
ZXh0LiBJdCB3YXMgdGhlIHN0YXRlbWVudCBvbiBpdHMgb3duLg0KPiA+IA0KPiA+IEhpIEtyenlz
enRvZiBLb3psb3dza2ksDQo+ID4gDQo+ID4gSG93ZXZlciwgeW91IGhhdmVu4oCZdCBhZGRyZXNz
ZWQgdGhlIG1haW4gcmVhc29uIGZvciBteSBvYmplY3Rpb24uDQo+ID4gInJlbW92aW5nIHRoZXNl
IERUUyBzZXR0aW5ncyB3aWxsIG1ha2Ugd2hhdCB3YXMgb3JpZ2luYWxseQ0KPiA+IGEgc2ltcGxl
IHRhc2sgbW9yZSBjb21wbGljYXRlZC4iDQo+IA0KPiANCj4gWW91IGRpZCBub3Qgb2JqZWN0IGlu
IHRlY2huaWNhbCBtYXR0ZXIgYXQgYWxsIGhlcmU6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2FsbC9jZTBmOTc4NWY4ZjQ4ODAxMGNkODFhZGJiZGI1YWMwNzc0MmZjOTg4LmNhbWVsQG1lZGlh
dGVrLmNvbS8NCj4gDQo+IExvb2sgYXQgdGhpcyBwYXRjaC4NCj4gDQo+IFlvdSBzYWlkIG5vdGhp
bmcgYWJvdXQgYWN0dWFsIGNoYW5nZSwgZXhjZXB0IGJsb2NraW5nIHRoZSBjb21tdW5pdHkNCj4g
bWFpbnRhaW5lci4gWW91IGRpZCBub3QgcmFpc2UgYW55IG90aGVyIGNvbmNlcm5zIHNvIHdoYXQg
YXJlIHlvdQ0KPiBzcGVha2luZyBhYm91dCAib3RoZXIgbWFpbiBjb25jZXJucyI/DQo+IA0KPiBF
dmVuIGlmIHN1Y2ggZXhpc3RlZCwgdGhleSBkaWQgbm90IG1hdHRlciwgYmVjYXVzZSBZT1UgV1JP
VEUgT05MWToNCj4gDQo+ICJUaGUgcm9sZSBvZiBNZWRpYVRlayBVRlMgbWFpbnRhaW5lciBpcyBu
b3Qgc3VpdGFibGUgdG8gYmUgaGFuZGVkDQo+IG92ZXINCj4gdG8gc29tZW9uZSBvdXRzaWRlIG9m
IE1lZGlhVGVrLiINCj4gDQo+IFRoaXMgaXMgd2hhdCB3ZSBkaXNjdXNzIGhlcmUuDQo+IA0KPiBE
byB5b3UgZXZlbiByZWFkIHlvdXIgb3duIGNvbW1lbnRzIGFuZCB3aGVyZSBkaWQgeW91IHBsYWNl
IHRoZW0/IERvDQo+IHlvdQ0KPiB1bmRlcnN0YW5kIHRoYXQgd2UgZGlzY3VzcyBlbWFpbHMsIG5v
dCBzb21lIHVuc2FpZCBvciBvdGhlciB0aHJlYWRzPw0KPiANCj4gTG9vayBhdCB0aGlzOg0KPiAN
Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2NlMGY5Nzg1ZjhmNDg4MDEwY2Q4MWFkYmJk
YjVhYzA3NzQyZmM5ODguY2FtZWxAbWVkaWF0ZWsuY29tLw0KPiANCj4gDQo+ID4gQnV0IGl04oCZ
cyBjbGVhciB0aGF0IHlvdSBoYXZlbuKAmXQgY2FyZWZ1bGx5IGNvbnNpZGVyZWQgdGhlIG1haW4N
Cj4gPiByZWFzb24gZm9yIG15IG9iamVjdGlvbj8NCj4gDQo+IE1haW4gcmVhc29uIGZvciBvYmpl
Y3Rpb24/IFdoYXQ/DQo+IA0KDQpIaSBLcnp5c3p0b2YgS296bG93c2tpLA0KDQpJIHRoaW5rIHlv
dSBtaXN1bmRlcnN0b29k4oCUdGhlc2UgYXJlIGRpZmZlcmVudCBwYXRjaGVzLiANClRoaXMgb25l
IG9ubHkgY2hhbmdlcyB0aGUgbWFpbnRhaW5lci4gV2hhdCBJIHdhcyByZWZlcnJpbmcgdG8gDQpp
cyBhbm90aGVyIHBhdGNoIHRoYXQgcmVtb3ZlcyBwYXJ0cyBvZiB0aGUgRFRTIHNldHRpbmcuDQpo
dHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvZWI0NzU4NzE1OTQ4NGFiY2E4ZTZkNjVkZGRjZjA4
NDQ4MjJjZTk5Zi5jYW1lbEBtZWRpYXRlay5jb20vDQoNCg0KSSBkb27igJl0IGtub3cgd2hvIEFu
Z2Vsb0dpb2FjY2hpbm8gaXMsIHNvIGlzbuKAmXQgaXQgcmVhc29uYWJsZSBmb3INCm1lIHRvIG9w
cG9zZSBkaXJlY3RseSBjaGFuZ2luZyB0aGUgbWFpbnRhaW5lcj8NCk9yIGRvIHlvdSB0aGluayBl
dmVyeW9uZSBzaG91bGQga25vdyB3aG8gQW5nZWxvR2lvYWNjaGlubyBpcyANCmFuZCBqdXN0IGFj
Y2VwdCB0aGlzIGNoYW5nZT8NCg0KDQpMZXTigJlzIHB1dCBpdCB0aGlzIHdheTogaWYgYSBzdHJh
Z2VyIHlvdSBkb27igJl0IGtub3cgc3VkZGVubHkgY29tZXMgDQp0byB5b3VyIGhvbWUgYW5kIHNh
eXMgdGhleeKAmXJlIG5vdyB0aGUgbWFpbnRhaW5lciBvZiB5b3VyIGhvdXNlLCANCndvdWxkIHlv
dSBiZSBjb21mb3J0YWJsZSB3aXRoIHRoYXQ/DQoNCg0KDQo+IA0KPiANCj4gWW91IGFyZSB0d2lz
dGluZyB0aGUgcHJvYmxlbSwgbGlrZSBhbnlvbmUgZGVuaWVkIHlvdSBiZWluZyB0aGUNCj4gbWFp
bnRhaW5lci4NCj4gDQo+IFlPVSBERU5JRUQgT1RIRVIgUEVPUExFIQ0KPiANCj4gSSBmaW5pc2gg
dGhlIGRpc2N1c3Npb24gaGVyZSwgSSBhbSBjb25zaWRlcmluZyB5b3VyIGV4cGxhbmF0aW9ucw0K
PiBpbnRlbnRpb25hbGx5IHR3aXN0aW5nIHRoZSBwb2ludCB0aHVzIEkgZmluZCBpdCBzdGlsbCBo
YXJtZnVsDQo+IGJlaGF2aW9yLg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg0K
SSB0aGluayB5b3XigJlyZSB0aGUgb25lIHR3aXN0aW5nIG15IHdvcmRzLg0KV2hhdCBJIHNhaWQg
d2FzIHRoYXQgSSBvcHBvc2UgcGVvcGxlIE9VVFNJREUgb2YgTWVkaWFUZWsgYmVjb21pbmcgDQpt
YWludGFpbmVycywgbm90IHRoYXQgSSBvcHBvc2Ugb3RoZXIgcGVvcGxlIGluIEdFTkVSQUwuDQpJ
biBmYWN0LCBJIGFsc28gbWVudGlvbmVkIHRoYXQgb3RoZXIgTWVkaWFUZWsgbWFpbnRhaW5lcnMN
CndvdWxkIGJlIGpvaW5pbmcuDQoNCg0KVGhhbmtzDQpQZXRlcg0KDQoNCg==
