Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2372ECE93;
	Mon, 15 Jun 2026 08:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781513062; cv=fail; b=JsTKs8exZJLMKw55t1DFvwaA+q65NaaKw1DUgNvXXS1AoPnaU8Ph5QcrCUH6yq0w8DxQdH7Hv7CC+znUpoj8WagmTIYoKCfZOAoTejpUzThHCA9naxbBseFMM/AqxmKtizCzKpWG2isWB6trHC9flAD+Hz0QTdperY1J1oh864w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781513062; c=relaxed/simple;
	bh=s6tQeTFsQceEZnJoxLcl9hqHqPrNYAIcFaWWEReV6ik=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tCyopseCpXIG4q8Y6sQrMKzySlVH4jTnagtO6NmGv6kLtR7UToJF5t0EZGo7qr16FRxlTW6UJaLhmhp7UcxIFltDOZGEbvleoEYo+2VsAAoWDn1W9bi5en3HOMSuYcL+iPO4m7jr1A3cyJr6WCkvz1bBCFKBVdx2LoJrPUnSKf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QPfZueUq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qFs3a0sc; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QPfZueUq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qFs3a0sc"
X-UUID: 628d1ffe689611f18dc8c9802ae25ab1-20260615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=s6tQeTFsQceEZnJoxLcl9hqHqPrNYAIcFaWWEReV6ik=;
	b=QPfZueUqqNmTT63uScT6PWK/VpJWodr48R96hA5IJaHjYrFQt09P2iQemBigBbB/Ai2UxCr7QnSHVqxsxbQRFpYzcbNjF9uUf/pG/uzzdo5+sv+v3YKMpejBj09oVqYethP3B0uvqj0GDfQOepMMANihj2RXK3Qd8zuYo47OP/E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:9ca8f789-3837-40e1-9f72-dc210af3df5a,IP:0,U
	RL:0,TC:0,Content:14,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:14
X-CID-META: VersionHash:e276073,CLOUDID:1b079354-902f-47df-afe3-f34f8d753c22,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:3|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 628d1ffe689611f18dc8c9802ae25ab1-20260615
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 951502862; Mon, 15 Jun 2026 16:44:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 15 Jun 2026 16:44:12 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 15 Jun 2026 16:44:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3ebewTe3kKDyxQ+MhGTnpXkggIMwaGcXAItW66zA2b2mhH3YgGGIhDgayWzjwNIy1KNpqyxjGg98GljyWvEFYfEEO47y5hPzkknUKnO50/LkcQX98PRjnuh7pq9jXjYhQ2qCX1uhRv6tCVeUaZRCG2SiSnhiqs0onFRbbkOPPMg/DCFnrU/JQq3bFxkGWG4EjMxr5CrBT0V0kf+vfkVS+Q22KNlZ5+vu4CcwA6fIHQukUMY6aGdROC4CMjfMega2DcaX2cAUYf41qhMm4XMW8m5nF0x6u0wywgNTPoRTLBhXGaTl+8vFDpnBbIfkYLqnWjUOIurLtOb3T7Xa5pNUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6tQeTFsQceEZnJoxLcl9hqHqPrNYAIcFaWWEReV6ik=;
 b=qCgkeIjNqlU8gtxFNiPdQQ3DvNvKzkNXC6OkH9oIEOF07ne9G7sj/hXM55RwK/S7JAua4uVjtaotnPBnFVMYQgbR9Zd6L22AHNW2IuVKWp96qqI+H9IvetE5HTEPKrp/dOMhspSjUIV39hU3ADUms5ixOWH2/ClddGLNfzmmLeq1Ho7vcJZ/gIQUyC1qj2qZdTO1UhivZeQeVBkr8H36kupiE4r1cR+za2gjoyUdSIThljbpA7ws4OFARrJldv9NMfMMYfafKN2s2qgdwIq0jABWiH4oYTHomclfIxVdgjrXqeUmPRJ/KOYPV3y9G/9Y+A51yKVPAh7w/IHhKFnP9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6tQeTFsQceEZnJoxLcl9hqHqPrNYAIcFaWWEReV6ik=;
 b=qFs3a0scRoG/TNl6PAUS+du6WSFGnD9yrsmWzZx1IJEO0k61RsGnH8ILvKwwKM5NL38xuH2zyuipjF1+NhLznZ4HmZgryXA1CvwJgXckO1b6eaYCL6QtAl1tBTxgqofi7SaOSilKgScHFw2p6MEbbuEim7mKZOvknitfqN0ncKA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY8PR03MB10475.apcprd03.prod.outlook.com (2603:1096:405:3aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.10; Mon, 15 Jun
 2026 08:44:09 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0113.013; Mon, 15 Jun 2026
 08:44:09 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>
Subject: Re: [PATCH v3 1/3] ufs: core: Add get_hba_nortt callback for
 vendor-specific RTT capability
Thread-Topic: [PATCH v3 1/3] ufs: core: Add get_hba_nortt callback for
 vendor-specific RTT capability
Thread-Index: AQHc/IwUWwohKGsDoEaz5VXhf+Nf4LY/TSoA
Date: Mon, 15 Jun 2026 08:44:09 +0000
Message-ID: <3b0e271967c3e7cbb2f4d2b188300c7ef4b50707.camel@mediatek.com>
References: <20260615055802.105479-1-ed.tsai@mediatek.com>
	 <20260615055802.105479-2-ed.tsai@mediatek.com>
In-Reply-To: <20260615055802.105479-2-ed.tsai@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY8PR03MB10475:EE_
x-ms-office365-filtering-correlation-id: f53c572a-1a3a-4dab-a2df-08decaba4481
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|4143699003|11063799006|56012099006|3023799007|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: vCZ1VXXP++wdEDGMU8BBCGEOOcMMTxFI7pay/U1/XEXg6dh3i6KsJaeEZ1WAnby0hmsaaSKGVt0qjpnN0sG5ZuBOMTJW1SAIU5SsGIVzxZfIx4DAp/pwbb8YOP2v9t5ywPTEXSUZxed7XrAwX9g12jVufxSFFceg2M/wgrZbIrcI//A4QMw3ubHCOmCY+7HrVvMBEsx77fCIdFCMIVy0riqkwwgyXPNj5zmB2JHu4J52EAzqXy/wquinjZCagaDSdDDlpX2DnTpX4Ol6ZCnqBAmo1b0srKDgYJg4o5ILS5BOGCA1Kikj0iECrlLAm1hPoIjAqJa6pEYjOutbwzZeFGxF+DzpTHmTN724jMbMFpBMsWgo5d4TE4BGsgWazMkIKWXccu5CNe36fvIAfryl3LKUYrv/SNJfXexCAxkou5vSlOiPN5TN+Ln2DLjb5j6i0HBYzxRP4Qrv/OJuDtwfcckT1nLX9pwizicyq4WzziPpyPtOvmPGoWe9AlvGwq5bbNmlMLAPoMbgeR/KPkzMxQtmMSIrZj00Y5DZbVbPSHu9mehp9UVXObbNGWLVuuzUrxs4+xqRimIrFrsiHPPxXOt/5nbltfcb7zceYRagg6QdrnpZM3nMUhnhwr92XDxnlQSTINvQ3OonmshNPvDdj2gVYWqolFC4xqbsq6fQCvcljbDG5jjrc535M5jikAMVY2gVam+vazBqIBmA+2F6+R+n6Q4Rw/Aq1GaPZ3ckrLkQ867L+zNDt5OvDKJN6Vs6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(4143699003)(11063799006)(56012099006)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGpFWit5UCtyZC9mVjZwUVYzZ1ZvSHA3aEVGN25ERkVoRzY1c1UvSXVuN1or?=
 =?utf-8?B?bXZqS0JjL0luTXdaOEVFUUlqdTdJNEhoU3kvUWZrQlArdUttWUtCTnhUWTlI?=
 =?utf-8?B?VUVXQmZlejNCL1U1NHJoS2VGaWJIMVZ2MHQwVFQvdS9NeDZBaXNubWlNUGtI?=
 =?utf-8?B?ZXFJRnBWaHlFRmd6MkN2ekdORER4aFA1elNUZGJzU0M5UHRwR3FWdnN3dmJS?=
 =?utf-8?B?eVNwUDkvZFhTOFFKdW5BaTh6aStiWEZCV0tQQnk2MmV3NU82OWtiQ21pZGdU?=
 =?utf-8?B?NS95U29BSUlGM01YYkkwWWswek55QXQrYXEvUFdKd3ZIaEhEbkhOa05Takox?=
 =?utf-8?B?clpyeVFualdDZlNWenkrQmF2dDBWUGFyWndweitza3UrTUtNYnliVTdiQkYr?=
 =?utf-8?B?cHR1STFmMGduM1E2Q1ZlUTVMMmxJNk55WmRBdTlDeUJTZ3QzS2ZPQi8rbFpB?=
 =?utf-8?B?dzNXMXFuSlpSN1BsK2NMRFV1Qy9rM2hOd1psN1k1Y3MrZFcwWG9IckpQNWdH?=
 =?utf-8?B?TUhJTDZObUNoUFo0MXFXVzhlbFFBdXFBcHNRMEtVdWU3QUU1TlBjSUJ5UGNB?=
 =?utf-8?B?ZTdIU05zVEdPTTlFOWlobVpGN24yc210OWxja2JiNzVNcDIwTEg0ZkRBUDl2?=
 =?utf-8?B?WlBMa3dseGg1Z2ViekxuOXZMYjBpNWN3OHN1WFd5SnY2eHlKQUxTSVVmUzFZ?=
 =?utf-8?B?NXg5RXBDQXM1dmo0ZElqTEJQL0xheGVRRCtaMENBSVJud0lQRGR5a1ZsS0M5?=
 =?utf-8?B?aCtFWFFHRjJVeUcyNUdRWFZCd0VFSGtITVhOclhPd0NhZm1jNDBHaGpKTlcy?=
 =?utf-8?B?Z0NjbnFoZ1czUERQYTVzMCtLSmx3bUg3ZkNkV2xJWDJySTBkZzZoY1Y4TWZF?=
 =?utf-8?B?Q0lMZXBZMk5KUEJORzdUck5ERXlRclV0Z1J3TUt3VW95WDlGbVFueUZJL3hn?=
 =?utf-8?B?Zm1CaW5JdnJPVnkyZFNGM3RXcWxxdjAxZXU2NFZjTTkwWitzeVh2amg2VnZE?=
 =?utf-8?B?WmRocGZ5NlBYcUxNeVZNSlY5bm9GdGVOT0QyTGlhNnRmcXdKR3A0eVJmL0xs?=
 =?utf-8?B?Slc3MkI0UFErMk5rNkdQclU2eWkwUFQ1WGdvTjVDRWxicGRYZWV1eFFJYWpV?=
 =?utf-8?B?QTVEQ3EvZ3REVXB5RHVLdDNhcHFlV1c4WnprWFNaWmVCWEc3ekhSZlc1RmRY?=
 =?utf-8?B?S0JvUWhYem5iRm5kZmowbzl3T2prVlVwVVB0UHk1Y2s4QXNHR240YXliQ0pO?=
 =?utf-8?B?a3JiRStNeUVjVVA0VW1YNUo0d2pJYmFFWU9sbm1vNWhSSTNUcTBodTZud2dU?=
 =?utf-8?B?bzE5ZklDanYvWSthWkttN2JzY1BBaEpxa2d3UndjcXRpdGxvOFR1VnFGZVJp?=
 =?utf-8?B?NjViQTRhbG02dy8rL1dkcVhJeFZrcXdOV3hGNDdiM01kMFNkckpoOGc5TUJp?=
 =?utf-8?B?MEVkYXo5OExwSEg4QytNc0lONzkwdFMrRmVrRldqTTdTZCt0RUxVNjdwc0p6?=
 =?utf-8?B?K3lqd1h6WmQyZW9xazN6eDFPWFhHWHNhSVNOcEEwQ09CZmVVME1DNzRVeUp6?=
 =?utf-8?B?Ny9jcjZMcmZkbkJLZDVqeXRoenVJYUk1eVcwSEMvaVJDenJ3bHFLdHJIMlBx?=
 =?utf-8?B?NEhzMTBSZ3R1TEpLMFBORlM5U3hpUTBkZ3VQaHM5MWMzY3Y2ZGRYdkRxcTdz?=
 =?utf-8?B?ZE9yUk5VSmRwM2dLQTRLbVhpb3E0NlpGWDFEYkNkMStPaDJ1ck9nemFDanVl?=
 =?utf-8?B?ZHd4ajF0WmFxMmVDSXBYOHRlY0crRTJlbW9qV09aLzI5dDlPTTd5eVRJekdz?=
 =?utf-8?B?VkgxY1VJY3hsd1hjQXppZVRBbTZ4S25CQ0c1QzB4QllwY0M1NWdNOE43VlJY?=
 =?utf-8?B?aVliUlVubENoblRIMk1VSmtZZmwrMTQ1b1FpRXVaSzlXWTRBMk1Kb3VhVjVl?=
 =?utf-8?B?eTNTSTBXMUpweURtZWkwMjVmT1hnSVFha3hFRzdiU0pvaitOcmNNV2ZhUTRy?=
 =?utf-8?B?QUZLd21UUHBTcWg5Ti9panR1ZlVMMEEvSmhSeUszdUhlZ0hvVUJyWGNiUVRI?=
 =?utf-8?B?Qm9STmJ4YUZta05LdmJqRVYrUDEwdzJBYm5HTjZEanpTQWNYZG9HTmJjQTB5?=
 =?utf-8?B?VC9OUzA1bWswZmV1VFN4NFFLYzJVWDMvOGFSTjFoUkZzTG5tcmhBQ1M3ejdv?=
 =?utf-8?B?ZndzUGNQeW1iRllMOFhVZTg3cEFwZGdRb0J3N3p1b2NIbjJZQXU4UWJ0RGVB?=
 =?utf-8?B?TzRzbElOUStablZYZ0cvMm5SRjMrV0N1M3RkaWxDZTdDZWJLTzZ1RnFpdXhY?=
 =?utf-8?B?NDV0eXFWaVhqaWZDcDA4S3FOWEFjRTl3aDh5aDd6U0hyNHpBakJaQ1IxaFVD?=
 =?utf-8?Q?jAKqNGv+KJuwDHf0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <734BF0CFDDE0E84883AB23812AC863E6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: jtUvz1X38k6BsFpypHjy8oeErntyo9Kcekmi3k40ZG+Z39DrcpgC/2gxbg3HnfXbO/loeKQ5tbwULwcXa1xeTLMuU9onVi1ReE5OHCwsrl55S4Viy9FVnWkO7Wsrvpi/VaYPbsXIHDrskpTPYXs6UrUCZMEwm9MwqIWMTZEHh3I9qDXYIe2sstpg79hcJXHeu0YM+r5wfwARlBm/FEZ57LR+e2S6ZntxSkOnjG+EsRoJy47dbJaGRzz5rqq6uy1Ih1oliBwNp4IoZYojTv/4Ozz8q0pyXdr0RBeuXBmEy/mOLXeZx77io+2jGbyP8i78h4yvxno7zvTi64I48oajKg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53c572a-1a3a-4dab-a2df-08decaba4481
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2026 08:44:09.4999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9JXGUuMOVbs4UmIdpK9/b56Uy2YdmBTsqrx8gFpCEewomrqonjIgK30k30n0s1EYzyZetJedlZePXsIwY6D7uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY8PR03MB10475
X-MTK: N

T24gTW9uLCAyMDI2LTA2LTE1IGF0IDEzOjU3ICswODAwLCBlZC50c2FpQG1lZGlhdGVrLmNvbSB3
cm90ZToNCj4gRnJvbTogRWQgVHNhaSA8ZWQudHNhaUBtZWRpYXRlay5jb20+DQo+IA0KPiBUaGUg
bnVtYmVyIG9mIG91dHN0YW5kaW5nIFJUVHMgcmVhZCBmcm9tIGhvc3QgY29udHJvbGxlciBjYXBh
YmlsaXR5DQo+IHJlZ2lzdGVyIGlzIHByb2JsZW1hdGljIG9uIHNvbWUgcGxhdGZvcm1zLiBBZGQg
YSBuZXcgdmVuZG9yIGNhbGxiYWNrDQo+IGdldF9oYmFfbm9ydHQoKSB0byBhbGxvdyBwbGF0Zm9y
bSB2ZW5kb3JzIHRvIG92ZXJyaWRlIHRoZSBkZWZhdWx0IFJUVA0KPiBjYXBhYmlsaXR5IHZhbHVl
IHdpdGggcGxhdGZvcm0tc3BlY2lmaWMgaGFuZGxpbmcuDQo+IA0KPiBUaGlzIHBhdGNoIGtlZXBz
IG1heF9udW1fcnR0IGZpZWxkIGZvciBiaXNlY3RhYmlsaXR5IGFuZCB3aWxsIGJlDQo+IHJlbW92
ZWQNCj4gaW4gYSBsYXRlciBwYXRjaCBvbmNlIGFsbCBwbGF0Zm9ybXMgYXJlIG1pZ3JhdGVkLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogRWQgVHNhaSA8ZWQudHNhaUBtZWRpYXRlay5jb20+DQo+IC0t
LQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo=
