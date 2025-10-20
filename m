Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D93B2EB873;
	Mon, 20 Oct 2025 09:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760953488; cv=fail; b=PzLW5TWYLquoVorhGPlvfxPtGG//MxlrFDnXUenlyhoJbCyciupHnKMyXFq+XwEiQCQgDqUp4T+G52Hk9UTMmr4hgscxMD2swfkWnthRO2we0pLjQobLYp/TN+X9IZpi42gyR5rXiKWZhYAk/fFTgmnhKqyDyQ37McS+CvtIYCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760953488; c=relaxed/simple;
	bh=HVnOAiSRKq+TD+32JEC4Z5smGEVu1QV2UxyqaG3qyTo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qjqABvDR4Y4JRwToXqv6BJSUF7kwE1HNogtsXlSNsVeFGjpYClAHchZEZXzw9fvbOChph37e74O6SzZXvqj3/lN8YCQl54KqTvcpc5kvzxStK6iVfRuaBh/4o3DQjFfrrnmHZfjEtwe8/hmL2e5Qsz0lfPs5/tLn63yMA7ZMh5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Tpad0ycZ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Z6uxR7gw; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Tpad0ycZ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Z6uxR7gw"
X-UUID: 675a5afaad9911f0ae1e63ff8927bad3-20251020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=HVnOAiSRKq+TD+32JEC4Z5smGEVu1QV2UxyqaG3qyTo=;
	b=Tpad0ycZIc7JPukaERQFm9i83VTeXvJcPqXusOSpPwLNHu3I2PKnu5gniZuIIeIS85dY5OqO+nbs6FDKt5Ej8PwV1uzQZ6ANmKXaezulbxt8pAY8L5mA8C6DCUaYXaTJejAd6jmpt6+RXOJPL34OtPKohmKjlbAhhMDlDZroT4o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:4163d1b9-6b77-4827-b67a-a7c7f0d9d4a5,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:0c2d5cb9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 675a5afaad9911f0ae1e63ff8927bad3-20251020
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 733434991; Mon, 20 Oct 2025 17:44:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 20 Oct 2025 17:44:36 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 20 Oct 2025 17:44:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vg/QEvY/mpReNEVaWo2974861meLcU85WYdWYxlDnqz/+HouI+xSoG6KLhQ7Mqul3FK9jkCzc4h9oINeqSmIaK9M3VpcluxMc7zlguTa2SNfkuC/4/aiqXVvW0GX42M5FHhUFInqmJvX9ryvd0InFss7QyaX15til0jg6bUI2zV0w4wYPGi15CrAAZOCAIl/JMRNS5UYSNDLGnKT6wTdSVzx44oEeYSbe+ODCUDsBUelbW92tgxIwSHSgEltjmvXywMvRrHKQKGZj8UYXC2ar9ce5Sb5ekryqG/Ov0yI1elRuK9z1yjUG/2NiuXuu1oUODM/Olw9cSKzXcAPI3uu6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVnOAiSRKq+TD+32JEC4Z5smGEVu1QV2UxyqaG3qyTo=;
 b=GhJL3pgURye4K3769u4UKBz0/JM/3gHzymDdDb0EOiDu46f3genjE0RPlHvXZSZ1jD7nnYjURHViiPRejQHV8nuVMnHORE5ZXfzBGKZlsF4dbkzV9ejDPHLvw/2Wh9Vxk23mMJwc2XwGzl7N09pnWmJBss5TJmPsVCZvfyhkv/cFCm/OMOMr/6kQPGzrPAybP2dMXp6oCppDXGdf2WVfynqiSb1x+XW+4LleThHCXzuCGrBIsazvhUrgIngrqsbEXjFzRU5Br5XWnmSzvh/7FepUtJjMJ5cr/6WPPJjesH6/FYpcmmoi6rPsK1vk7PoUQ3+5WhBG9r2SNFlDdAfvfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVnOAiSRKq+TD+32JEC4Z5smGEVu1QV2UxyqaG3qyTo=;
 b=Z6uxR7gwKS+UvdPLzt9lGZalaIAr/DE3WVTf/TX4/oU6BF9t81OHz5hO7VlyGN9yF+Augo19IeA36A77LOWuEyJFmNxsj6OFsvdSVGvvU5yU/LwqlX0Susxk2AppRn2NmLGNXdQ9d60UHeokWgUi/WmL+YWLI0wsiH5o32lHL9w=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8489.apcprd03.prod.outlook.com (2603:1096:405:72::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 09:44:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 09:44:38 +0000
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
Thread-Index: AQHb+ubXEcM0idFfNEe1g+HvnHp2OrQ941oAgAGSzYCAileogIABbykAgAAEWwCAABUpAA==
Date: Mon, 20 Oct 2025 09:44:37 +0000
Message-ID: <4b3d2678d2b724fb53ec7272ef8daf52197d4a0e.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
	 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
	 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
	 <438077d191833bb4f628b2c6da3b86b3ecfb40e6.camel@mediatek.com>
	 <cb173df9-4c70-4619-b36d-8e99272551b6@kernel.org>
	 <a9bf15e48afd8496ca9b015e7f5b03821863a0b2.camel@mediatek.com>
	 <7f285723-ecd7-4df6-8c9b-f2e786ce3602@kernel.org>
In-Reply-To: <7f285723-ecd7-4df6-8c9b-f2e786ce3602@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8489:EE_
x-ms-office365-filtering-correlation-id: b7def2ae-11f8-4a88-fc95-08de0fbd48e7
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?VXVoRnEyMUdEYkFabVBIVFdJOUlITjR6OWlDWnN2Wlgxekk5SkM1RUd5bHZt?=
 =?utf-8?B?MHR1MVVrZjIwTzIyMDVqd1lLZGRhK0o2ek9LS2Q4VXlTSmdZNXVoMWEzZ05h?=
 =?utf-8?B?akliWnJvZ3dCcEpnTnp1WHlMMkhzZlFHV1dJYkdBUDVyWEQ5UlFKSnhiRGYr?=
 =?utf-8?B?TS9LQVdwMnBwVmFUZWgxV2ZhZkVFbXVmcndnWFQxMGJwV2JiM1o4L1RlUjNk?=
 =?utf-8?B?M0dYZjdOUldTb3kzQnZUcVpGbzBzaVhMODFGeXJJcGh3K1lUUGVKb0tqY1hJ?=
 =?utf-8?B?Tmozc3ZNWjJUUEd4TXUvUTNaMzVjQVUxSWNQbG96Mm5OclZ0eEEvU1RhUm9i?=
 =?utf-8?B?MXFtYVFvaFZCcVI0Y3pZWTdVajR4cnFIY1gzME9GbjNIY0w3LzQ1ZkNOSitH?=
 =?utf-8?B?THp5WmpkbVovRXRsdll1M3R3bDlRU2lkRHpFUm5uYjNuOSswWVh1Mnc3NDVP?=
 =?utf-8?B?YWMyS0c3QVVhOHl1YlAreHMwVmZCanlVTzU2Y2FiS3ZGMFJ4ZVpLUFZhQXY4?=
 =?utf-8?B?VTZyNldHQWRJSGtJbXZtSHUwYTl2UWx0ZlliWG5xSy9tZ2ZjTGdqbFRmRnFH?=
 =?utf-8?B?QWt0NWpzNEpRMkhCaFgrd2c5cjJ6RVhNNXBiNEExcjZLNlZYVlVVUlFvWVZ0?=
 =?utf-8?B?V0tuVW5NZXdmNC9DV2U3WTZXTUhiQnRhNlBNejZSZnNkQ01oczAzdVJPdVJM?=
 =?utf-8?B?b0ZKVkx6VVd1cGNORWlZN0xxUGJlZEhMTzJFLzlQV1lBVkFOaVZybHV1d2pJ?=
 =?utf-8?B?Z1NuM2d6UXQ0SkUyYkd1VzJZdEpkdlVCdXNXbktESzZrTE9iTEdvNktNQlRm?=
 =?utf-8?B?VStjdDdFNWRkTENWNXNkNWR6T0RmRHd0d0NHZ1JsK0JFMm9tYm15Ti9mazlK?=
 =?utf-8?B?UjBYZGJMMlpOUVZGRCs2ck9oS0V6QlhoVnovWmp2ZW5vTnNZa09JSzhjWHZE?=
 =?utf-8?B?b2Y5S1FYNW1qakpwQU5JSFd5WmVKdnFLcmJKMWdCWStMYm9PU1lEbGVyWmQ4?=
 =?utf-8?B?OHNMK25KblY1a0thMzBhaVg0NlNOelBEZmE4N3FnTmsyN0pxckQzd1hRcWhZ?=
 =?utf-8?B?NndDcVJUTkVFckNRcWVZbmtZMklyQlJqbjJxdXBqbC9ZYnpMclRLUHc1MFF3?=
 =?utf-8?B?RGRkRmRueXJpa1NmejZ3S1g0dGIySE5HSGxKY2ZHc2F0L2hzNjdHTjdROHlP?=
 =?utf-8?B?RkV0Tlh1cEJuTTVsZmI5Ri9VdEJCVlpjMTBaODdTc1FBS1B1S0k2TUpqMkVY?=
 =?utf-8?B?RzhSK2ZZTTI5SXNGcTdicC83YW1ZRFBPUGhyZGRUNVoxRmZFR1R4TkFIS1M4?=
 =?utf-8?B?QlJKaGh0dlJOQy94akZFOHBFKzVzdjhPdEJnRjFvWS9uU0oyY3p0c2p2dXhx?=
 =?utf-8?B?OXNleU5XT0JhS2JadmNXRWtRNisrSGR3WGI1VWh1dTB1b3MyeHVQK2xnYXVO?=
 =?utf-8?B?MTJkdG5ZeG1LMlBOOURmTWt6UE1ER0xBRXB5ZjV2WVN3T2Y2NFFXNzRNY3Q5?=
 =?utf-8?B?MGJnUzZsSVFoZzRsaHErNWpBY0VsMXFHNXZQeEpGUHA0a1pkcldkdEFUQkFp?=
 =?utf-8?B?b01YRjFSRDVuSFkrMXIrbGp0eS9sa25idVFzWGJRQkZyQ3gwUDhpRFBsd01t?=
 =?utf-8?B?UjZTK1RmbzhRbmRoOGdMRnRMQTZveG5kb0x2blJBKzQyeW94Y1FaVlZoaWhS?=
 =?utf-8?B?U0J4d1pZZ1A2TXpnSjZzWVZieWFjSzhTM01lU3krZjUxWWNDRzR4eXg0Ymp4?=
 =?utf-8?B?NTlRZHc0UnB6QXl2TlR4YndjTnZxYkZqeFFXNHgvU1drbmJkaXZkWGJpbjhq?=
 =?utf-8?B?ekVodWNOUWVFdnpwVE5abG1wa3IydlRldkJ1WU9SYjZ0V0JzN1IxRmNORWt2?=
 =?utf-8?B?UWlqNFZVRXpTMkhwbTl2MGhLWVV2b0NPTjY4MGFPbERVOHVKRUJCR2g4YlBH?=
 =?utf-8?B?S2Zjb1dBYm5Lblk2cEd6aU1ueENjUUszdUtTZmpFa2poR0grNTNYVUF2a0p6?=
 =?utf-8?B?aWJac3Jna0svZksyTDFVdWRkaXNMVmFUSkdpMEs0d0JuSnI3Z0k1LzIvTDlX?=
 =?utf-8?B?YnMxSlhZeDg3OUw4Z0dBby9MNkU4NWpoMXlpQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTRFVGFNTDZySXZneVQ3NGVTRUVRdXZ2NC80dTRtQXhYSlh1cTRnRStzNFhB?=
 =?utf-8?B?NnR1b2tzeThYZmExN0dkUkpvY3BjT0theE5ZRC9WSU9aakpFOFdqOTZsTlNL?=
 =?utf-8?B?WklSUnlYQmpxK2JJVXhEWjBhaWdCQkFFWXpmUDdYbXg0QjJZaWRqcm9ub2Vl?=
 =?utf-8?B?UXM3SzlWT1dsZkhGcTFQQ3U1SE4rWUNURDFBd0pidUZtK2lPVktaQWM4dmow?=
 =?utf-8?B?Y0dKR3JTSWtKS3UzRmxWRCtlUFpTZ1pIMWl6cUlQc3lLa0NYQVhqQ0VmZ3RV?=
 =?utf-8?B?SjlEZ201TitqQTBweTR4czJKaEUwVVFXclFoM2tRL0lSaUROUzVrTWRzdDcy?=
 =?utf-8?B?dzdVd0hiWC92TnU2YkxIUmpDV2g0NXpxRmFoWTNxR0tEWEhsdmhzdzc4S0NZ?=
 =?utf-8?B?cVI0SUhLVTUvZ0hHMmxYb2RBY3I3R2JRSGJpY2hTM1UyaGNnVmhseUhLcG1I?=
 =?utf-8?B?MW0yQWJSWWl6aVFFaXZVYjcvM0haVjJDc3QrREo3ZFhmSTQvMFdCOFAyTGRu?=
 =?utf-8?B?a25WdzN4dU5XVExKN3hORGNqVWQxSCtqODNxZlF1eXB0cE4rUHdydjFaNXVH?=
 =?utf-8?B?ZTVKY1VwKzdMMzAwMkVFTzJBbTVIdjZlc1ZsZllMa3JLbkg1Q3JCUnJ4UCtx?=
 =?utf-8?B?S1YvRlpqeDlRczZ2UTJkY0JEY1FNRmV3KzZOZXhrQUltaGx1Ykw4U1dkVXZG?=
 =?utf-8?B?QTdxODdXNVM2VGFNV2lkY0w4djRabFQxOXdNay9HM1dZVUwvRk9DVmkvaEwv?=
 =?utf-8?B?QktCRFFMVGJwK1d3dGE2ZnYxQ3piTk5udGdsY21MS0ZpOFZwUE9KU0R2NkNI?=
 =?utf-8?B?Skk1SlMzUXI3eXhOUllMZW1JK1dobEwwOVo2S21xSHQ3RU9GN0RES2NNcVpZ?=
 =?utf-8?B?bWtlanlkRk5ocVFQNUd4a0JSZlVaNTRyNnlZY1NEWVJmZW5uV0poNUxvamta?=
 =?utf-8?B?dW5TQmNHYUNDVkU5UmJRa1pBYmI0MGw5R3ZrNmFTNmJxeTI0RUN2emlLMFl4?=
 =?utf-8?B?TjIvNGdhZEsxenlQUTFFb0tIWkIyTXZ6d3FhaE9iNUlwWm9mMmpMV1ZXVkZm?=
 =?utf-8?B?V3g4OElmVTVvdmFXWXF2ZHJYalVmWUpPR1FwY2ZRQ05zeTMwQm1UZzA4MkNo?=
 =?utf-8?B?SUI4WUZWcGl0Rkltd3VoM2YyRHdjMWlxSzFtTjNWdjdnN3VjZFVIcW5rUVhV?=
 =?utf-8?B?ZTc0SWJxdjVhNHhiN2twRTJEUy9VZUpVODhkeFd2ckp0VFhvWUQ2cDlyQUJB?=
 =?utf-8?B?TFM3Q1NRYm95SEh2ZXRtcFZkVjFtMnN4TWtCQmluaHM3bkpBTGp6K3lrSnV4?=
 =?utf-8?B?ZDJmS1pFUjdxQ2dYYnJBSFpMMDRnS1A2MnMzTzY3eDE0a2dMbzlVNlZsTFMv?=
 =?utf-8?B?eS95Q1JGOGY4Z0NFT2k4VDdKNkM0dW1Cb1lwS20vWENGWDFZbFpWYW9XL1FZ?=
 =?utf-8?B?VjhnOHJHaENycGtEamhrTEhmZTdEOUFTTU0vRUhOMnMyTkhtckxUQ0h6Zjg4?=
 =?utf-8?B?MXBaV2lpQnFLRXlqd2I1cEV0Q1dQRDBHWjUzOWsrb3BDS3ozZFBMSVZHYWh4?=
 =?utf-8?B?RWhtTDdVVytLdU9XQTZxNmwvZmtYejJGUmdCUGpOYkRpMmRvUDlEam9TaHlL?=
 =?utf-8?B?NmNZTWlySjFEM0Y5SXg1bmt3di9GVkllM3pUcWIrUlZ1TjJBWm04c0JIeFhV?=
 =?utf-8?B?UmxwSms4OFNCWVdqa29oVGkwL2lSQWhIeklzVitUOU1zRjBqcTlxR05vcEc5?=
 =?utf-8?B?TGpkTllYUGMxaCs1Wit1TExRcVFJQVhGMlpzdmpQYjlUaldYc0NFbkRvMkUv?=
 =?utf-8?B?MzhBWHJXaWFFWnJ3cXNZN2RlNHJVQWdEWVRGVW5QY25pK0RQNE1PZm9JaUNK?=
 =?utf-8?B?SXJCdldjRTVsL1BjTW55TittVDRoVEhoTms2ZXZVVGNzTUZYcnNYNXd5K2F1?=
 =?utf-8?B?UnYzU1hYTTkwcVZ5SE9GVDdEaHZYNjZQOGF3Qi9zM3hmZ0szeVN5VWpVR0kw?=
 =?utf-8?B?R3VDZGRjUUk4Vk9BSnZqU3MzeXBXVjdGWVR3ZnpVVFZublRUQnJFZkhhdFVX?=
 =?utf-8?B?aEpGd050eVRwd3FvbFVSaHh3YUNXSGhERmZTWURITGptL0JueUYyYnBtS0ZG?=
 =?utf-8?B?UG5FMkorTk4vZjdud05NTUpPUCtTZTAzN1dIbXpQNU40cmtlOGYxbVcrOEtV?=
 =?utf-8?B?c2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31FEA0BF2AF3BB4F929CB5235BC64D55@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7def2ae-11f8-4a88-fc95-08de0fbd48e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2025 09:44:37.9036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BAYIrh5UlV50rjR+N6eHRmVUgp73T1NgxCF1Bmh5+X9SK0cD7tpcZm8u/RON5hbToOyL7+ou8tvbpYv39JTK0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8489

T24gTW9uLCAyMDI1LTEwLTIwIGF0IDEwOjI4ICswMjAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiA+IA0KPiA+IA0KPiA+IEhpIEtyenlzenRvZiBLb3psb3dza2ksDQo+ID4gDQo+ID4g
VGhlIG1haW4gcmVhc29uIGZvciBteSBvYmplY3Rpb24gd2FzIGFsc28gY2xlYXJseSBzdGF0ZWQ6
DQo+ID4gInJlbW92aW5nIHRoZXNlIERUUyBzZXR0aW5ncyB3aWxsIG1ha2Ugd2hhdCB3YXMgb3Jp
Z2luYWxseQ0KPiA+IGEgc2ltcGxlIHRhc2sgbW9yZSBjb21wbGljYXRlZC4iDQo+ID4gSeKAmW0g
bm90IHN1cmUgaWYgeW91IGFyZSBxdW90aW5nIG9ubHkgdGhlICJJbiBhZGRpdGlvbiINCj4gPiBw
YXJ0IHRvIHRha2UgaXQgb3V0IG9mIGNvbnRleHQ/DQo+IA0KPiBJdCBpcyBub3Qgb3V0IG9mIGNv
bnRleHQuIEl0IHdhcyB0aGUgc3RhdGVtZW50IG9uIGl0cyBvd24uDQoNCkhpIEtyenlzenRvZiBL
b3psb3dza2ksDQoNCkhvd2V2ZXIsIHlvdSBoYXZlbuKAmXQgYWRkcmVzc2VkIHRoZSBtYWluIHJl
YXNvbiBmb3IgbXkgb2JqZWN0aW9uLg0KInJlbW92aW5nIHRoZXNlIERUUyBzZXR0aW5ncyB3aWxs
IG1ha2Ugd2hhdCB3YXMgb3JpZ2luYWxseQ0KYSBzaW1wbGUgdGFzayBtb3JlIGNvbXBsaWNhdGVk
LiINCg0KPiANCj4gDQo+IA0KPiBZb3UgZGVuaWVkIGNvbW11bml0eSB0byBwYXJ0aWNpcGF0ZSBh
bmQgbm93IHlvdSB0d2lzdCB0aGUgYXJndW1lbnQNCj4gbGlrZQ0KPiB5b3Ugd2FudCBNZWRpYXRl
ayBwZW9wbGUgdG8gYmUgaW52b2x2ZWQuIE5vIG9uZSBkZW5pZWQgTWVkaWF0ZWsgdG8gYmUNCj4g
bWFpbnRhaW5lci4NCj4gDQo+IEl0IGlzIHlvdSB3aG8gZGVuaWVkIGNvbW11bml0eSB0byBqb2lu
IHRoZSBtYWludGFpbmVycy4NCj4gDQo+IFRoaXMgaXMgbm90IGFjY2VwdGFibGUgYW5kIHlvdSBz
dGlsbCBkbyBub3QgdW5kZXJzdGFuZCB3aHkuDQoNCkkgdGhpbmsgSSB1bmRlcnN0YW5kIHlvdXIg
cG9pbnQgbm93LCB5b3UgYmVsaWV2ZSB0aGF0IG9wcG9zaW5nDQp0aGlzIHBhdGNoIG1lYW5zIG9w
cG9zaW5nIGNvbW11bml0eSBwYXJ0aWNpcGF0aW9uIGFuZCBzdXBwb3J0LCByaWdodD8NCkJ1dCBp
dOKAmXMgY2xlYXIgdGhhdCB5b3UgaGF2ZW7igJl0IGNhcmVmdWxseSBjb25zaWRlcmVkIHRoZSBt
YWluIA0KcmVhc29uIGZvciBteSBvYmplY3Rpb24/DQoNCg0KDQo+IA0KPiANCj4gWW91IGNvdWxk
IGFwb2xvZ2l6ZSBhbmQgZXhwbGFpbiB5b3VyIG1pc3Rha2VzLCBidXQgaW5zdGVhZCB5b3UgcHVz
aA0KPiBzYW1lDQo+IG5hcnJhdGl2ZS4NCj4gDQo+IFN0aWxsIGEgcmVkIGZsYWcuIEkgd2lsbCBu
b3QgYWNjZXB0IHN1Y2ggdmVuZG9yLWxpa2UgYmVoYXZpb3JzLA0KPiBiZWNhdXNlDQo+IHRoZXkg
c2lnbmlmaWNhbnRseSBoYXJtIHRoZSBjb21tdW5pdHkuDQo+IA0KPiBJIGFtIHZlcnkgc3VycHJp
c2VkIHRoYXQgVUZTIG1haW50YWluZXJzIGRpZCBub3Qgb2JqZWN0IHRvIGl0LiBUaGlzDQo+IHNo
b3VsZCBiZSBjbGVhcmx5IG9zdHJhY2l6ZWQuDQo+IA0KPiANCg0KU29ycnksIEkgc3RpbGwgZG9u
4oCZdCBxdWl0ZSB1bmRlcnN0YW5kIHdoeSBoYXZpbmcgcGVvcGxlIHdobw0Ka25vdyB0aGUgU29D
IGJldHRlciBtYWludGFpbiB0aGUgU29DIGRyaXZlciB3b3VsZCBiZSBjb25zaWRlcmVkDQpoYXJt
ZnVsIHRvIHRoZSBjb21tdW5pdHk/DQpBbHNvLCBJIHN0aWxsIGRvbuKAmXQgc2VlIHRoZSByZWxh
dGlvbiBiZXR3ZWVuIG9wcG9zaW5nIHRoZQ0KdW5uZWNlc3NhcnkgY29tcGxpY2F0aW9uIHBhdGNo
IGFuZCB0aGUgZG93bnN0cmVhbT8NCkNhbiB5b3UgdGVsbCBtZSB3aHkgSSBzaG91bGQgYWNjZXB0
IGNvZGUgdGhhdCBJIGZlZWwgaXMgDQp1bnJlYXNvbmFibGUgdG8gYmUgbWVyZ2VkPyBJbnN0ZWFk
IG9mIHJlcGVhdGVkbHkgdGVsbGluZyBtZSANCnRoYXQgbXkgb2JqZWN0aW9uIGlzIGFib3V0IGRv
d25zdHJlYW0gb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4NCg0KDQo+IA0KPiANCj4gQ29uc2lkZXIg
c3RlcHBpbmcgZG93biBhbmQgY2hvb3NpbmcgdGhlbSBpZiB0aGV5IGJldHRlciB1bmRlcnN0YW5k
DQo+IGhvdw0KPiB1cHN0cmVhbSB3b3Jrcy4NCj4gDQo+IEFzIFJvYiB3cm90ZSBlYXJsaWVyOg0K
PiANCj4gIlNvdW5kcyBsaWtlIHdlIG5lZWQgYSBuZXcgbWFpbnRhaW5lciB0aGVuLiBUaGV5IGNs
ZWFybHkgZG9uJ3QNCj4gdW5kZXJzdGFuZCB0aGF0IGRvd25zdHJlYW0gZG9lc24ndCBleGlzdC4i
DQo+IA0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg0KSSBtdXN0IHJlaXRlcmF0
ZSB0aGF0IEkgZG8gbm90IG9wcG9zZSBwYXRjaGVzIHRoYXQgYXJlIA0KYmVuZWZpY2lhbCB0byB0
aGUgY29tbXVuaXR5OyBJIG9ubHkgb2JqZWN0IHRvIHBhdGNoZXMgdGhhdCBhcmUgDQpub3QgaGVs
cGZ1bC4NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
