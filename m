Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E080A288C06;
	Wed, 23 Jul 2025 09:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753263713; cv=fail; b=fsBOHEwj5F7JkOCDR/376iDJsfS+PrP32ng57oUgvvldhaB9DCdoTeJT9EgsTK3VotCzPZQ2DZAcOWm1wySQlfF/IQgAuMJ/L0QgUDfuzY+8nfSIpyo/2KfHFKXoTKQmvgn0MG9+LSayFhvohgVlC7e+xaq6qjXdJIz5ONTagt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753263713; c=relaxed/simple;
	bh=gUOacw6lEVOZNGdhIaC5tR97LyTxLe7J9FUzoUxX5k0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=He16nWJMLRl/26MiQU2u6vustD6jdfXXGhPK62nrQktpIVsiL6e0Rv+87zLmA4JNibEAMTP5z1Ylkh5SBpxZWQugt8+s533SdmIdjFSRos5wdKHrHHahYmwEqDL843F9E/HnFFlViU1mbpFi6XYyS1woSA1LAtCZyYSIcHVFOsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fgsQ6mvq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BsTiG0wP; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fgsQ6mvq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BsTiG0wP"
X-UUID: 3d05702c67a911f08b7dc59d57013e23-20250723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=gUOacw6lEVOZNGdhIaC5tR97LyTxLe7J9FUzoUxX5k0=;
	b=fgsQ6mvqOua8UpITwrSYz8Zlx/VTFUze/n7vgq4UBBBbjWYO8bkBkVno2BuQlhKZmTsHLstM544lBttOP1/ly1oKDvHjcsgDVjigeadsdVXfvap65X3mfL83ux/t4VoBT57a+3WOK6yC+WRUmXn1EzuommM+//EIOGeE0+oimLk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:c127a265-364f-4f5a-9a88-700b38ac36a5,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:c3642a50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3d05702c67a911f08b7dc59d57013e23-20250723
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 286558851; Wed, 23 Jul 2025 17:41:41 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Jul 2025 17:41:40 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Jul 2025 17:41:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nP1dOzGUd7GBDVyQwZHB0HCmTSFpDYnlLLEOxPKKCjWNUKgUuAhTE5hp8bVriumN15jvF5AVaJp5Z9K/+bOH5Z1AkaG8cCg4q6Oja4FUnI8u3a6nsgA43CNOMi73lO9MoQhbHEMYZjDjGmZ9DQfbkNsXGzSkS9nYc23B5S7k0va2ibHdz1l6i/MgZgu20bnLrPtfgDGe8MWURau7onhCyESlqXQZZHi1+rNF/GLTwr9HU9J8UfhCNwOjaSP9gm2kqPcCX5tz2Cyoxrn5zVJwUk1y5EevYmCRJNoO06EkcDN0MvWBMfGUWjX1ISyzQ3yEeEavN+caHjjFg1Mdt19/ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUOacw6lEVOZNGdhIaC5tR97LyTxLe7J9FUzoUxX5k0=;
 b=PcdjJax5XHKzQBDJfvMhe5gJghq7E/7sWnd/2cSKgRCcCAX5lFBWhyS5G7hQOzfuva1pR4rojf7RyF6W+Eh5ziETlnIwudjwSgI/ted62pZEWYmfj+TwCDQ04uecWmEX0RWQN4ROqAe3RLXtg7i+TeMcn7rGDJkWM8f/yOJ3QLpBEYt/e6FPVgjs5HSTHSg0IJquZzuohz9RBqk8PcBh0CnTWW39VitGt/TZGADeP2vEd0tAnVw2o2PdFR3TbZs/GS7lHZcoZF4+pYRZTMAjCZfPBSgng7hnFcisVs0+Mz67vtJoZSE62rSEeULfN1eDFcYbm3TqMc7Cma54FSdxQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUOacw6lEVOZNGdhIaC5tR97LyTxLe7J9FUzoUxX5k0=;
 b=BsTiG0wPuWRwrCktJgcWEWCTkSX1qxvqjse7t11/DSo+vrUSwsHSw0MWKskJ3FlRYFM0ttkp+pBSjkLLoIqvGgAXjDTzdshvfJUYGnl9EG2AlhVTWFsEr3yXZnbaVpFySNXdHqnrLfa7blOqxS3xI+21t+7nVy5TqkBoRW7hji4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6576.apcprd03.prod.outlook.com (2603:1096:400:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 09:41:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 09:41:36 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?= <Macpaul.Lin@mediatek.com>,
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
Thread-Index: AQHb+ubXEcM0idFfNEe1g+HvnHp2OrQ941oAgAGSzYA=
Date: Wed, 23 Jul 2025 09:41:36 +0000
Message-ID: <438077d191833bb4f628b2c6da3b86b3ecfb40e6.camel@mediatek.com>
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
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6576:EE_
x-ms-office365-filtering-correlation-id: 762ddb98-2a0f-47da-a7ad-08ddc9cd1dc9
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?elNCUEZsMzhreWMzaW1oemFCYU5oZjNHNkxQWHB2djhXcWlqYk84QlU4NzhC?=
 =?utf-8?B?RWNRQTJQcFcwRHQ0YjZrTlU1c3ovYmVSdU9lT0JHT1ZtMGkzbWYyc0tTNVQy?=
 =?utf-8?B?dlZ1QWVTSno2Q1lqS1JjUnZYQzZZcWQvN3dwVnpUR1hGSno1bi91S1hVaDJn?=
 =?utf-8?B?VXBMa0J4dFE3VEErYjZ2d0ltSVNyV1B3MkZSa0V6Q0JwaDEwZ25oSkx0NDNs?=
 =?utf-8?B?NFpoRUNJQVVXcVR3Q0hzZDNMM0l5akFuYzRBMUlBVTBhdmg2cm9YRHJJYlJT?=
 =?utf-8?B?cHE5VDRIcTVnelcrcThIRE95ODhPSXRHNjVFejRFM3NIeXBkbHFVUmR6bTJq?=
 =?utf-8?B?MkZtTDZGK3E4VGdxRWlsUWpaL0NtbmNMelRpaWJkS2d1eXBUQUNVNGR0NjUw?=
 =?utf-8?B?VzRnUVg2SDlLWkpDdmx6TFpjUWRZSjVlVE9XRGhNS215YWtYN1k1Ui9ybGt1?=
 =?utf-8?B?a1pZLzBCMHo0azBydFFKOS9KZk5DeDZGVEk4SGxGL0QwcUdsQ1dVU0VVRXpy?=
 =?utf-8?B?d0VnMVlhdUxPcVlUZEdYRThPTjJWcVRPYkNRV2xYOEpRVVpEMEZ2QTdoQWJB?=
 =?utf-8?B?Y1p5V3paU0RKZzJkTjdpK3VMRmIwaHRoeEVRMURCdTJaL3A3UFZ0RHY4UlNG?=
 =?utf-8?B?OWppSm1ZR0ZXSGJvOGNDWWtwUm1VR1A2RHlLYm5PV0ZEWHF3alcvajlteG5M?=
 =?utf-8?B?ZlRweDN3Vk9TeFN5TVA2WWJVRnJFdWdjRlNwVU95SFU0NVNYeFk1R21JMG9H?=
 =?utf-8?B?aGxQUTVkNi9waEFkbXMzUEEzYktVOWg4NW8wVzhzSnZwTE9wYkdhTlJyRElq?=
 =?utf-8?B?NHBYSURGR0ZaUDlxSUZQbUozenFSUHNGSmJQNWNZYWxtMFZ6Q0tSYnh0YUNy?=
 =?utf-8?B?Q1JoSlFQM055aHpJSHREaUxGMXlncjYzUTEzM1R0dlVlRTkvTUdoczI5S0Zm?=
 =?utf-8?B?cE5VL1d2bnllK2xFeStNMnpSbWNrcmlFeS9DYkdwdUFWWGtEMDZlVDE1S2Jn?=
 =?utf-8?B?MmZNR2h1NGx4alA3ekdndkZiYmZjZit3N0dwelZtdnpLM3hzSzN1UVNpT2kz?=
 =?utf-8?B?cnl0OUV4QUl3NWhqZEowZzg1K1RCYWtsaXRYcGw0ckVpOGoxOTcxVW1xU0Qr?=
 =?utf-8?B?TUs3dnV6MmkwT0tVR3puTTFvN2xIdk80Q2xuS0Y4RjlJelVlWTR4RWpnV2xs?=
 =?utf-8?B?TE1CK3lqYnZTaENteXdHNlN5Y2gyRVpFbkdqNzRoaUluL1NDeWxqR3lCVTYx?=
 =?utf-8?B?TWRkbGJBVWtIclNOOEhwMW1qTkdBcXhyOUVCS0k0dmIyMFB6ejVvSjFrL3RO?=
 =?utf-8?B?My9DTTNsSEFCeUZXMFZlUDlvdElLWFNSU0w0bXFIQlI5dVgweDd6NC92WnQ2?=
 =?utf-8?B?QmJMMTdmOGhlQjlwOGVNYWVXQ3VxdEIzamZONjdraEkwbkRzcGM1YisrczJW?=
 =?utf-8?B?T0MzeGYxNTh4eEloNURpZEsvQTFTcXgzSTduM1p0UGZVQllhanpGNkt1WXpE?=
 =?utf-8?B?dmN1WHpMUStYOXZka3BlZnk1M0daRlVFa1E2KzBYcUV5QTJDYklDM1NGK1ZX?=
 =?utf-8?B?bWFsZ3gxakZiOEFJMXo4eHVSOW9Jcm1INkVvS3B4ckhGRU04elF6MXQ0Uk5T?=
 =?utf-8?B?RXFZeWhMTDNBMStLZitaNzRTMzhKZlNHWkt4SUxtVURZc0VQaytCeEV2VTJ6?=
 =?utf-8?B?T1MzZnh0NHo2blRYQmw4emJEbUg5R3l2K3J3TXVkakswNUFHNzlVNnVVMzNK?=
 =?utf-8?B?WDBPSlJGUk1RQTRkOE9FVXc2YnZ2NW5xYjRia2FsWEtVcmtmQWF6dHE5MnN5?=
 =?utf-8?B?M0tNUmZBMlNUY0VmbnFzMjRmb0V3WHloQVF0d1dBY2lDQU9kbmVKa2xJS2pl?=
 =?utf-8?B?Ty9qOWJuOWFRVWtjalJtWDN0S2dlKzJqaWkyRDUvUWliT1FZemZmSndmVDVw?=
 =?utf-8?B?RFVBTFAxNjhHTFRTRmROYnJqMDVTa09vNnNZUEdYZGU5UkVqbXVjV1FKNXF5?=
 =?utf-8?B?Lzd6Smo3MlpWTjB5SU94dTAzbHhYK3lCUllzL0xkSXVPalk3ckQzZ1dsak1G?=
 =?utf-8?Q?oVxZR2?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkttSzRjZ3FoMzdhTW5TOUsvcUxYVjRza0gvTklBVmN5UWVuanFxR0RqeUhK?=
 =?utf-8?B?UEx3OFF6aGV4WTIwL1BhTDNiME44eXE5TEdNbHhKVFluM0VCS2p5OS9ZMDQ3?=
 =?utf-8?B?TXUvUEg0MEROZnlLQ25uWnZiR05HSDU4bGQyZHFEUTRpeWZxQVkwVDI3Qi9Q?=
 =?utf-8?B?b1hyTkhwMTM4SXBtMEVsdjNiWmd3enpCZ2FUUmtEb1ZPQjdYTXJmOU5rb3g4?=
 =?utf-8?B?TnhWVnNzR1dpNEpJNTNzR2lqOWFiOE0zb1g4ZEJsRmxsNlptUzFnTG96cGI5?=
 =?utf-8?B?cC9ybVJlZzExcktwM1VvTlFPc2hUcnQ5N1FtYjBtaVdYTkNTaHZiZ3d6dmFa?=
 =?utf-8?B?eWRwWm1oc1Z6RDlpZmwyUmRqQXZrQVhlalIwbDRacGdLRW5qU094ODRta1hp?=
 =?utf-8?B?eXMvR0Y4RVVjcHplL1Z3OEY1RkhnNytXZUs2bXFIU3hPVUZzNVQ5NzNRTENO?=
 =?utf-8?B?WFpWMitaUmdQNk1lM09yMktlS2paM0wxYmUxN3NvSTlVL1pTOGxLVEFYazZE?=
 =?utf-8?B?Mm56VGtGMWNDTmlvazAvRVNRWjFucXp6Q212dG1OaXREb3hZT3ZRV1N0eTkv?=
 =?utf-8?B?YlBRT2RueExHYWhkdTMvNWJJUmpVRHN5RHljK2luTjVQOFVoSU1PbDFFWEtY?=
 =?utf-8?B?MDlrakRnUVg1UTltelRQMnZNblRGc1E5anVBNmdZYXI0aTFqZ0lOdzFrTzFw?=
 =?utf-8?B?MTFISjFkMEVJU00xallVWUN6T21jZE9nZWtkRUZDLzRBTUc1TXBMTWVsNDR3?=
 =?utf-8?B?SlUyWkIxeFJybDNVcUhXM1dkei8vL0J6SGFyUmlYUEIvZFNsL09TWmR5b1JP?=
 =?utf-8?B?dXhXZ3Y5THJsMGIxZGM4blJCQlhUTXNTbC9yY3ZHemFNSDZKMFZORWpqcndX?=
 =?utf-8?B?RytBOC9UMlNrZS90c09wcHdsUlFYQkpPSjd6bXNLU3U0RlNNY2VsT3BVY3Av?=
 =?utf-8?B?YTNEaFBtNWVFUXg2bWszMzd3ZU1jVmpONzJiMnFTLzdnL3pTT3V5alo5dUY5?=
 =?utf-8?B?bk9lSVhoQWs2Q0g4WkhNWjU1TFpvVGxsWGRGY0FHVkhjQ2c3Q3phSHVOMzNG?=
 =?utf-8?B?eFVCdnFnSnJpcDFUN2hiU1NjRlFId0FmbjFBd3E0R0ROOE1iZlZTeVdxZkNU?=
 =?utf-8?B?djVWZjhEeUhZb3NsY1BiekFySmY1YU00MkNNZXIzYi90bWpyWVArVnZ1QVZz?=
 =?utf-8?B?cklCUWhFTURzS08yYW1WWFBDaktBNEh0KzYrZmVRNGtINUczaWZIWU51OWdX?=
 =?utf-8?B?d1NNK1BSVXZHeHRUWGcyYVdpM0JkNllGVVp2N3c0aWp1STZYK2JMR21ycit0?=
 =?utf-8?B?aytPZFRhczQvdW1qazlyUnVOYlU3Z1ppNktZOGhlb3BraHo3eWtBVVdTZEYv?=
 =?utf-8?B?UERBL2pOZDFSSWNwT1JJeEpXNkhmaFhtRW52RDJxSXdZSFdXNGNHVkw3SEhl?=
 =?utf-8?B?YmVHalN6N2c1TkxFbzdIU2hQa0RRVjR2aGI0VWNPbXFFc1dBeHowa3dOazND?=
 =?utf-8?B?NURCSTJFN3BLSm1Ud1FtNUd1czF6N2RFVlNuRk13VEd0NXBlMDlKQWtLbnJ2?=
 =?utf-8?B?Y3RVRHhwVlFwMmtGQmtWbEtNVXpmUUNwQlFpMHFpaWN5UEExUDRseERVOHpt?=
 =?utf-8?B?TmtLd2dsejAzQThrWmg5YU10TWo2bU5RSGEzaVBTVEFwQ1RnNmxiU3VPSkpL?=
 =?utf-8?B?THV4N05tcmhhL3lRN0s5S05SdWJmUHFpVllKbEEzbVA3RVVVbEpsMWpRb003?=
 =?utf-8?B?V3pkWVYzSGhqdWk2VGhmVWZHYjdaRVMyWVhrZjRINzFGZVV4OXhmNUZWMFp0?=
 =?utf-8?B?bHdCcGlUWElYZzl0Q1JqbUhySmJldk5PL1BiUTJ1SnR6OVZDYzZOVEpMczYx?=
 =?utf-8?B?Zi9JUXRQZVk1c1Q4KzBuN2xQN1dpN2QvMzRaN0EwQjcrVldyU2tXdndjT2pY?=
 =?utf-8?B?cmNZR0U0U0oyZXRsQTdBMlBVcHdjZWdCeFhCZVVhRzYycUlpQm16bGJtWW1y?=
 =?utf-8?B?c0tkMkNXMEZhYS9QUTcrZFhtcGdvTkYxUDh5TFVhSWxMdlhyblZtWnEwMXRn?=
 =?utf-8?B?RXh0KzFDWTJJMGM2RUQ5c0N2Z3hVZ2FaWGhyMkJPeW1ZcmMvRDk4YW9MVE92?=
 =?utf-8?B?ZXI5QVJldzk2a3cyZ09WZVkremV1cjI2MkptL0gxcHBZYXd5OVVBSEY3elNj?=
 =?utf-8?B?bWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AD813B2F747B646A337576AC0A93E9A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 762ddb98-2a0f-47da-a7ad-08ddc9cd1dc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 09:41:36.1263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7yo4Qp1RLmZxhkFdd4xSatM7t3S199jKbHaHkJEKt7Emjwq+OnTzUQlAo3qxNiZDUKF5TaalunKUX3LsyqGOcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6576

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDExOjM5ICswMjAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gDQo+IFRoZSB1bmlwcm8gbXBfYmNsayByZWFsbHkgaXMgdGhlIHVmcy1z
YXAgY2xvY2s7IGJlc2lkZXMsIHRoZSBzdGFuZGFyZA0KPiBoYXMgY2xvY2tzDQo+IGZvciBib3Ro
IFRYIGFuZCBSWCBzeW1ib2xzIC0gYW5kIGFsc28gTVQ4MTk1IChhbmQgYWxzbyBNVDY5OTEsDQo+
IE1UODE5NiwgYW5kIG90aGVycykNCj4gVUZTIGNvbnRyb2xsZXIgZG8gaGF2ZSBib3RoIFRYIGFu
ZCBSWCBzeW1ib2wgY2xvY2tzLg0KPiANCj4gQmVzaWRlcywgeW91J3JlIGFsc28gbWlzc2luZyB0
aGUgY3J5cHRvIGNsb2NrcyBmb3IgVUZTLCB3aGljaCBicmluZ3MNCj4gdGhlIGNvdW50IHRvDQo+
IDEyIHRvdGFsIGNsb2NrcyBmb3IgTVQ4MTk1Lg0KDQo+IFBsZWFzZSwgbG9vayBhdCBteSBvbGQg
c3VibWlzc2lvbiwgd2hpY2ggYWN0dWFsbHkgZml4ZXMgdGhlDQo+IGNvbXBhdGlibGVzIG90aGVy
IHRoYW4NCj4gYWRkaW5nIHRoZSByaWdodCBjbG9ja3MgZm9yIGFsbCBVRlMgY29udHJvbGxlcnMg
aW4gTWVkaWFUZWsNCj4gcGxhdGZvcm1zLg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
YWxsLzIwMjQwNjEyMDc0MzA5LjUwMjc4LTEtYW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xs
YWJvcmEuY29tLw0KPiANCg0KSGkgQW5nZWxvLA0KDQpUaGUgY2xvY2sgYXJjaGl0ZWN0dXJlIG1h
eSB2YXJ5IGRlcGVuZGluZyBvbiB0aGUgcGxhdGZvcm0uDQpUaGVzZSBjbG9jayBwYXRjaCBsb29r
IGdvb2QgdG8gbWUuDQoNCg0KPiBJIHdhbnQgdG8gdGFrZSB0aGUgb2NjYXNpb24gdG8gcmVtaW5k
IGV2ZXJ5b25lIHRoYXQgbXkgZml4ZXMgd2VyZQ0KPiBkaXNjYXJkZWQgYmVjYXVzZQ0KPiB0aGUg
TWVkaWFUZWsgVUZTIGRyaXZlciBtYWludGFpbmVyIHdhbnRzIHRvIGtlZXAgdGhlIGxvdyBxdWFs
aXR5IG9mDQo+IHRoZSBkcml2ZXIgaW4NCj4gZmF2b3Igb2YgZWFzaWVyIGRvd25zdHJlYW0gcG9y
dGluZyAtIHdoaWNoIGlzICpub3QqIGluIGFueSB3YXkNCj4gYWRoZXJpbmcgdG8gcXVhbGl0eQ0K
PiBzdGFuZGFyZHMgdGhhdCB0aGUgTGludXggY29tbXVuaXR5IGRlc2VydmVzLg0KPiANCj4gQ2hl
ZXJzLA0KPiBBbmdlbG8NCg0KSSB3YW50IHRvIGNsYXJpZnkgdGhhdCBJIGFtIG5vdCBvcHBvc2lu
ZyB0aGlzIGluIG9yZGVyIHRvIGtlZXAgdGhlIA0KbG93IHF1YWxpdHkgb2YgdGhlIGRyaXZlciBm
b3IgdGhlIHNha2Ugb2YgZWFzaWVyIGRvd25zdHJlYW0gcG9ydGluZy4NCk15IG9iamVjdGlvbiBp
cyBwdXJlbHkgZHVlIHRvIHRoZSBxdWFsaXR5IG9mIHRoaXMgcGF0Y2g6DQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9hbGwvZWI0NzU4NzE1OTQ4NGFiY2E4ZTZkNjVkZGRjZjA4NDQ4MjJjZTk5Zi5j
YW1lbEBtZWRpYXRlay5jb20vDQpPcmlnaW5hbGx5LCB0aGlzIGNvdWxkIGhhdmUgYmVlbiBhIHNp
bXBsZSBtYXR0ZXIgaGFuZGxlZCBieSBhIHNpbmdsZQ0KRFRTIHNldHRpbmcsDQpidXQgdGhpcyBw
YXRjaCByZXF1aXJlcyBjaGVja2luZyBhIGJ1bmNoIG9mIERUUyB2b2x0YWdlIHNldHRpbmdzLg0K
VGhpcyBpbmNyZWFzZXMgdGhlIGNvbXBsZXhpdHkgb2YgdGhlIGJvb3QgcHJvY2VzcywgYW5kIEkg
ZG9uJ3Qgc2VlIGFueQ0KYmVuZWZpdCBmcm9tIGl0Lg0KDQpFdmVuIHRob3VnaCBJIHRoaW5rIHRo
ZSBvdGhlciBwYXRjaGVzIGxvb2sgZ29vZCB0byBtZSwgSSBoYXZlbid0IHNlZW4NCmFueSBuZXcg
b25lcyB1cGxvYWRlZC4NCkkgd291bGQgbGlrZSB0byByZWl0ZXJhdGUgdGhhdCBJIHdlbGNvbWUg
YW55IHVwc3RyZWFtIGNvbnRyaWJ1dGlvbnMNCnJlbGF0ZWQgdG8gTGludXggVUZTIG9uIE1lZGlh
VGVrIHBsYXRmb3Jtcy4NCg0KVGhhbmtzDQpQZXRlcg0KDQoNCg0KDQoNCg==
