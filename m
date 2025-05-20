Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884091E492;
	Tue, 20 May 2025 02:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747708873; cv=fail; b=sRxGUl1joQaQ5xzIM0EbqmeP1Y8vi+XTZeIhYhFpnQ3xThXQqy4DE+Q8R/ZrlQKQ3ZQettmJM9If0HGbM88iXSQlcok3ipRaF0laecZPrvvDiqxsvhk5YVzUA1gfe2OQFvhtQg/hNzZUPd0A/S4ty8SZ/EJg2n3XpYTWVrVkIEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747708873; c=relaxed/simple;
	bh=RTSCINden0sIJXwdNEvBo0Lu2L6jNTC/B1b2IzeLuV8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WVfhGb0McrtXtYG8f1MgnlJoQ3Qu7xdLK/OWFPDXR8g6c9fUn6hprbZM8RqMYNDzDePmWBkl59NFyY0VawY7+JCp+Ci0SHQg9MT83EB/YAC+JfLJxExecpuymP9rIFc6+49eaZNF52KZjLrxVaXTvo2pcNn4B8FjSiAKwZQVGgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Jhbs6AYh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YDj6QxaY; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Jhbs6AYh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YDj6QxaY"
X-UUID: dcac386c352311f0813e4fe1310efc19-20250520
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=RTSCINden0sIJXwdNEvBo0Lu2L6jNTC/B1b2IzeLuV8=;
	b=Jhbs6AYh2lFBuv+TE0M/SwSYa/WXuaEQwldL0kdjCtEu6bRu+OnhA05IMtOUPmRfOWhAeoMvGwqA2hyzW7nszRued+K3jI+gSgFvDMtCbSEzLHkjYGrU0/1frrNg9Q33n6LZcqsVbxWyrkF9AYHRypCeoFU65P/uEtocn4s9zkc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:d898d1d3-5d9b-43fe-addf-d9eebff1201b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:9cce2bc0-eade-4d5b-9f81-31d7b5452436,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: dcac386c352311f0813e4fe1310efc19-20250520
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1664930561; Tue, 20 May 2025 10:40:59 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 20 May 2025 10:40:57 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 20 May 2025 10:40:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V0S/es69txOFPax126NNfw1oDa4cCyLvVFDeDSuyfbEU6FLpOI1h5VXL0GaNWW2QspMpozQ2NFe5A6dmjjLaaF4L9gTS1UNgwdLkouqtptL+RJsS2fYMSgOBwjyPWjqt4G4Mqd3fH9TidTZUFcxpf2GCIKM07WpXieZHGKC4oRahHRO1qe5WD2Sn5twqVkoIHMT3T3h3WrJGe+3tP+/BeeYIY693tsp6+IvGCHGZkISGqm/WlNg9hZBWc1Nq0ja3+CC27OCCHVx0WdgFDqe0SLutzfg7diwXElCYKPV7fkryJ2u37m4UqMwUIF55tKdt8ld+aY23M6mnBuDbn6hL/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTSCINden0sIJXwdNEvBo0Lu2L6jNTC/B1b2IzeLuV8=;
 b=ZIb9RYOTb25NIVLKQpvlnoNKX+rpAIoL+Hc3GVEG4VfqwhQ9nS8WwWAgbn6ZExzAv5HDeRQWRJ347exeifFBtkMF6RoQ32nBQTO9qlT1FPy0r+Gd4VdKVjjzzrSCtPjzvnuqGD1zAdXt+sDJYkrqbta1Yjw2mtK/KDJrqJlWnd5JSYNddM5+Nes+aikpe+n/FuJaX2IPy1eCnFpaVG4SkRf/1X2Jd+vivigVSv0hh4ZRHwXjh38TNOL7fmi5QMEiWNIKw2vAa/Mi+3BFBkU9DIZggR8W3MancOkACEbwQRY+avi4umek9xICnvX/t7oW19AaJxAVxrW3nmYEb7DEjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTSCINden0sIJXwdNEvBo0Lu2L6jNTC/B1b2IzeLuV8=;
 b=YDj6QxaY76dFQ8oQAmsMi6tUN7LmKCBMue51pvxufCRMZSDOlAW4xWaO5WiKCycImLijrEQdnSYdeY6BNMpDXgzQ5yVsPoYg6o39O3vSBMuy2mSWvEIyr9H+APwIliH76WR5SLzsMkRiWUYUD7ngTssAAFgKYZuaOkOU4xJ+650=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE2PPF0DEAE0EC0.apcprd03.prod.outlook.com (2603:1096:108:1::488) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Tue, 20 May
 2025 02:40:55 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 02:40:55 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"ping.gao@samsung.com" <ping.gao@samsung.com>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
Thread-Topic: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
Thread-Index: AQHbyGmBx2vjZYj/lkqaswv+bgORgbPa0GMA
Date: Tue, 20 May 2025 02:40:55 +0000
Message-ID: <63383483544a5f673f8b3fb7e47ea163f5d05541.camel@mediatek.com>
References: <CGME20250519025509epcas5p2bdc884392dafa224289b337c1232daf3@epcas5p2.samsung.com>
	 <20250519025559.1263821-1-ping.gao@samsung.com>
In-Reply-To: <20250519025559.1263821-1-ping.gao@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE2PPF0DEAE0EC0:EE_
x-ms-office365-filtering-correlation-id: 8c7d6652-54f7-425f-95e0-08dd9747be82
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?TFYyUUhSZ25PdHhUcTlueXVYYnZ2K3RNaWtHZWJQMHdvbE1RVEpTQ1FGOGVm?=
 =?utf-8?B?WHEzaTFIWllRYTJZWHVBSEdRWW9FTnNDbk4rcFJZRHVuNEFuQU5lOVZ4OEpp?=
 =?utf-8?B?STNTdEZFRU00dWtvVkpxRXVjSTJHMDNRN3RVVFBURjZXVGhsMU1QNkNyWklG?=
 =?utf-8?B?YkZyYXRGbGNVaHlVWEYxUm55c2I0WTNXcTRSNHdCc3l6VjFrVVFvbVNjRlUv?=
 =?utf-8?B?TUptQ2t5WGlucGovdXBDSk5MTGZIQklwaVEwUzRvcnhuUkhiaWNJbklaOWxr?=
 =?utf-8?B?emdLUms4SExkeC9DMEJyd1FzalFTRFJiT1N3bXdVeWdIZGhPSWpzcG1ORnlx?=
 =?utf-8?B?ME41K2dZM2h4ckVsbXJpaVhzT1Jyclp1T3d2dmNzc0VKekRoNjUyT1pEVjVL?=
 =?utf-8?B?dDJ4Ulp1N3JHZ1ZLVTVVZldVQ0grUlVBdGdHVTRGbW5LeEFTakFVbFYvVFlZ?=
 =?utf-8?B?Rldsa1ZpeHRaNzFwOExjL09JMHloRWdMWmNYYTY3MUJkVlpYK2x2bFB1SFdm?=
 =?utf-8?B?aFhVY0lUaUR2SEQrM29uMnFmWUNkcUJQMk5qYk4ySnZPRXduV2RsN2I3OE02?=
 =?utf-8?B?czNuZ3hyK3pJaXlidnEyWHZ5SHI3NXdIMzNzeXdLbUk1bVhRNnpjTGdQL0x2?=
 =?utf-8?B?YWM0SEVPeW9LT28vRzdWNGpuUFBHQmhBZmUrYmFwNkwrQytwOC84a3ByK2hF?=
 =?utf-8?B?Q1BnTHZXL0ZQUldzSGhkMXNWa0Y0YktSdHYvNlB6b3RLd2lEWkhMcDJPdERJ?=
 =?utf-8?B?UG9jZGt0VDZMelRreGttNTBIb1k2UVJUZWxENDN4ZlBnclJyOWdVYVVwY2Ja?=
 =?utf-8?B?enFpWDdraTZqU1dEVTB6NjgySnNFaExBOWZ3ejc1MUFUTTZQYXZRRWRzbTZT?=
 =?utf-8?B?Z2dWaTdxeE9wa1cveC9GcktGZ09wZUsvaEVPaEhRTDBBSHV4SWwxYkM0YVY1?=
 =?utf-8?B?N2pGL082QUQvYk5vYmxXdkIwbUpEWmVhTUNuaDkzaEhDbWZ0MnozWEZBQjRB?=
 =?utf-8?B?MnZxa1hVRUlFYzAreGFVWjhsL1JteVBISEU2L2tyanlIWE1NcHJzdzFIOFpq?=
 =?utf-8?B?WlNxUEJGL3M1TkZTY3N6ODRCUzloZlVEa0Yyd1JEZWFkUVhrZTdGSnhwU29Z?=
 =?utf-8?B?elc5ejdwVDVBRkJFcXJxbE0zM01EdXcwMjBrZG1Sd3QxMmZiZGRDbHVJazFj?=
 =?utf-8?B?ZWNGK1dKdUs1U2JNOHkySkxoRTA3NDBCR2hvRTR3WkxWTmdtajNhV3h5Z0Fs?=
 =?utf-8?B?Q3c4WUdESitwQWxra0lyQ29YTHExa0xZNmoxT0dzVXJtVzNFQWcvOHEzV2ht?=
 =?utf-8?B?cnhoL204RE1zR2EvVW9MNHFHRm5LTllGSmpCWm1OaC9MU1Fiei9PM2drWVo4?=
 =?utf-8?B?MlJ2elp5TEJwRUt5Y0o0L2JJM3ZGc0Nyc1NaT3NPYzNqR2hBN2ZONkQ5MWVx?=
 =?utf-8?B?YjM0M25SeHJkMk5CQUJRVnZGS3pLcWlxK01FQ05TSnNCWjVkTDRPVFJkRE50?=
 =?utf-8?B?YjJ1WlN5UUR5MDNxVGUrWEFldjVyYXN6NXJNbmNOSmVIS2hXWTlIRXRtWlN1?=
 =?utf-8?B?QlBFdnZqbndyWnJqQk1JMkRIQ2VBaDFKMThkN0RDQmNMZG1id3VUQXRRdEhR?=
 =?utf-8?B?dFRwN0lWOFRNOE44cFhETFhoZGFjTVgwMHZOclpNeHRoWVJlSWpvVTFSVzhV?=
 =?utf-8?B?Ti9uMmo4LytMNVFoYW80bncyRTN1djVVaDY3U25ZNUJncm9CUFh6T1BOaVM1?=
 =?utf-8?B?czVXVWQ1ZWtSQ3VZY3VqUDMrZUNCVFhhdEpzc2VBaThuRVRzbytsbjBUTXk1?=
 =?utf-8?B?cTBqeitQdERBcnBiNFkzT3VLbUdDekI4U3pQZ2NVUHJDZTlsb0wvRGtCWUZq?=
 =?utf-8?B?VllWY09QV2d2MElscXkwZnlmQUNRTnhwUFlxd1h3UmZaemxTYlV5RTdLcWJM?=
 =?utf-8?B?a0ZaR2M1VWhmL0pGYTVlWkJFMEdWZVkxN2FFWVBjVGVRZk9XSzdVa1JoWGkr?=
 =?utf-8?Q?kF0JkaPQSJ/zDvzL1WpextcBMs10C0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VSt6UWJ4M05EL3ZyRUVETWlSRXFiYWt1YmFqd3ZsY1N1dGRVT3BIeEEydWQw?=
 =?utf-8?B?RC9lNi9VV3llWmNRNEdqcEIra2pLSTJwVTJZUkhJS1Zrc01MdVlSci9Na2Fz?=
 =?utf-8?B?Y0hoL3JTZExLNC80Rk5NaldiNFNvOVV0dVRoOVlrOGRDbENXbVpObGkwd2dB?=
 =?utf-8?B?Umw1anVuS1JKbElad2NMSExCMUcyeXlldU16d1lmUXFJZkJRYURpNCswSHhY?=
 =?utf-8?B?SmhZZ2xTWEw1d0VNQ2hiYWtOMDZsTVl4RCszcUJFalpNVUlRbFJuQkVDU01C?=
 =?utf-8?B?bTdQMVZNUDFETGVLb281bUtSSkdqeTRMV2JjL1VFSkRYYWpXcXlORi91NGhn?=
 =?utf-8?B?WlY4b1BhVkM5T3RrOWtsNWk0UC9ZNHovRSsxVmFGTGo4RXVLdGJjdGxudmlC?=
 =?utf-8?B?QTdHZEMxekFQRE04NjVBb3N1aWtjR1Fxd01CRWlQU28wM1VnSVFRcW1QTTUr?=
 =?utf-8?B?Z0xpdi9QZzVhMjJiWnF3WGZYaVBkL0NUL3Q4c29lR1FJcjhmQjViY2RJZVlK?=
 =?utf-8?B?UVo4Nm12TSs0ak1EZzB1UjFiZ1ZGWWswY3BBdUxBY2ZhWVAvVU82bFdGdXM4?=
 =?utf-8?B?UGRhckl0UGIzaVlCenR5NDBITS9uTVMxWWx2NFpyNHRZVERBc2h2UzU2a252?=
 =?utf-8?B?RFNLTDlWMi9rMXBoc2NxOGlYdzh0VmdWL2prdXpwWm5LQ2NFR3ZVRG01QXlO?=
 =?utf-8?B?ekJ0MkpYbG1WVGdSU1FZLzVVL1FDdVlVTUZBZzJLclNSZFRVNjVUVm1sSDlC?=
 =?utf-8?B?SE9DRllNUzZSMkhJdFN4ZDlpWlBrZXQrL2kxQWVBUVpZcmdFTm5CbzhBZHBZ?=
 =?utf-8?B?SnBnaTBkOERWT1E4NGdVbFY3Q0ZiWlp0TjRnMkRLNnE0alg1b21jd0dwWDVX?=
 =?utf-8?B?QkxQcWJzSXRSQW5DKzNmTkE4eVk0RmljUm1rblZ5S3MyR1hrNVNqdFd1RDhU?=
 =?utf-8?B?STB0bVJYcW1QelBpUkQ1NS9GOGdFRVoyazQ0cStGSzNqUUFFOFUxLytQUS9m?=
 =?utf-8?B?a2szL2tnc2VYT3N6cnlQYkNHNDNtLzR1UTB3RURJbzFxM3o2Wkc2M2NaZ2Yz?=
 =?utf-8?B?ay9ONWd3eWt2QjZqOVE0Nmh5bElMK0dPQ0pramdRa2lHV3NQdjZRZVVVZWZR?=
 =?utf-8?B?MDVKVTFjVXYxaExEdkhFRzYreTZwL2lTS3F6REVVb2h2NWkxWGo3SERIbmZJ?=
 =?utf-8?B?Mk1kTUxsWi9MNmRmeXZOK2ZDRVlKK2h2U3BjNHllaCtiV1dWSS8yd2lYNU1R?=
 =?utf-8?B?c1JxVm5USXRCN1VLeVVlVkE4ZjVlNnRIdGR4bkZleHZGV2F1Sm5OVFpKZnh2?=
 =?utf-8?B?ZWdYRmZnNkJFckJVbTF3WHNrZXMwR056SEpZY3IrWHVzSlZJN3VlYlpUclpi?=
 =?utf-8?B?b09IdmhpcTRkRGxnb1RqcWkyaVVsdTRrN00waXYxTWtkUXpZME5RQkxJZnhD?=
 =?utf-8?B?S1pPWkU4c1dvWEpDOUxha2xXbTFVQ1NwZWhjS2V5SGNiU1FpdnpSOGdqalZX?=
 =?utf-8?B?NGxtQTczV0czY3crMVJuSUZSbjZmaklVL3A2MjFDSFJXR3dJS2FWbmhPaE5R?=
 =?utf-8?B?MVhMMm1sRCtUTkRjVTNMMlBveGR3RmVNTnBLRm53MDZoMTdONWZWUjdaRHA1?=
 =?utf-8?B?NHRhbXFLdXBER1VGTHowM1hlU3VKNExobmdvRXJqQVZodkY3MjMrMzVycGxZ?=
 =?utf-8?B?emNLWHkvRm0rQW5qZlpDTFpwQnhBWXN1RE84Tk9Gem16dUlwcjR1TDBQZEYy?=
 =?utf-8?B?c2gvTkFTazFXcTRjTVRFKzlGWDZYY2g5Z01uQThDdE8xSGNyczNSZVVNcG9X?=
 =?utf-8?B?a3hUNUpXdEFLMUJXa21FSU9jUG44WVZGQmhBaGZETDBiNHZ5djdXOVJtSjMx?=
 =?utf-8?B?N1ArTTcrSjRFdldRbkM2T0g0VTZONmJlTmxXU1hWTEc0aERaWlF3K0hidjBm?=
 =?utf-8?B?SVIva0JBY2JkTlZHWllnM3B6em8zTUtuMkdUOHlza2pYL21XVHVrTjgrU25E?=
 =?utf-8?B?S0N4RUMvVTJ2cm5zWUFBY3o2SzVZOC9ja1BhMXladDdrMngzVTd3NFp1Rk50?=
 =?utf-8?B?SWZ4YmJtNmU4UHROa25McCs5WHRtQXVNU2tPVEZoTXR2TXI0Q0dmVkxtQ1RR?=
 =?utf-8?B?TlBWMEh6dWVRUDEwNElOY3VrcXp4eC9Lc0VYZTd2VVJzemZZQjFSV3AvSVpm?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB1A205F8B755E419C85B4794897AB3E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c7d6652-54f7-425f-95e0-08dd9747be82
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 02:40:55.0696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fsoF2cvV9UXNK9v5FhRr8cJY0qzeVrPNZ9kISsbPwyM9F+7n8ptphIeh0AQrUcsL0kqeVtR4Gy4dZnCqF1lU1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2PPF0DEAE0EC0

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEwOjU1ICswODAwLCBwaW5nLmdhbyB3cm90ZToNCj4gYWZ0
ZXIgdWZzIFVGU19BQk9SVF9UQVNLIHByb2Nlc3Mgc3VjY2Vzc2Z1bGx5ICwgaG9zdCB3aWxsIGdl
bmVyYXRlDQo+IG1jcSBpcnEgZm9yIGFib3J0IHRhZyB3aXRoIHJlc3BvbnNlIE9DU19BQk9SVEVE
DQo+IHVmc2hjZF9jb21wbF9vbmVfY3FlIC0+DQo+IMKgwqDCoCB1ZnNoY2RfcmVsZWFzZV9zY3Np
X2NtZA0KPiANCj4gQnV0IGluIHVmc2hjZF9tY3FfYWJvcnQgYWxyZWFkeSBkbyB1ZnNoY2RfcmVs
ZWFzZV9zY3NpX2NtZCwgdGhpcw0KPiBtZWFucw0KPiDCoF9fdWZzaGNkX3JlbGVhc2Ugd2lsbCBi
ZSBkb25lIHR3aWNlLg0KPiANCj4gVGhpcyBtZWFucyBoYmEtPmNsa19nYXRpbmcuYWN0aXZlX3Jl
cXMgYWxzbyB3aWxsIGJlIGRlY3JlYXNlIHR3aWNlLA0KPiBpdA0KPiB3aWxsIGJlIG5lZ3RpdmUs
IHNvIGRlbGV0ZSB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCBpbg0KPiB1ZnNoY2RfbWNxX2Fib3J0
DQo+IGZ1bmN0aW9uLg0KPiANCj4gc3RhdGljIHZvaWQgX191ZnNoY2RfcmVsZWFzZShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKQ0KPiB7DQo+IMKgwqDCoCBpZiAoIXVmc2hjZF9pc19jbGtnYXRpbmdfYWxs
b3dlZChoYmEpKQ0KPiDCoMKgwqDCoMKgwqDCoCByZXR1cm47DQo+IA0KPiDCoMKgwqAgaGJhLT5j
bGtfZ2F0aW5nLmFjdGl2ZV9yZXFzLS07DQo+IA0KPiDCoMKgwqAgaWYgKGhiYS0+Y2xrX2dhdGlu
Zy5hY3RpdmVfcmVxcyA8IDApIHsNCj4gwqDCoMKgwqDCoMKgwqAgcGFuaWMoInVmcyBhYm5vcm1h
bCBhY3RpdmVfcmVxcyEhISEhISIpOw0KPiDCoMKgwqAgfQ0KPiANCj4gwqDCoMKgIC4uLg0KPiB9
DQo+IA0KPiBGaXhlczogZjEzMDRkNDQyMDc3ICgic2NzaTogdWZzOiBtY3E6IEFkZGVkIHVmc2hj
ZF9tY3FfYWJvcnQoKSIpDQo+IFNpZ25lZC1vZmYtYnk6IHBpbmcuZ2FvIDxwaW5nLmdhb0BzYW1z
dW5nLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tPg0KDQo=
