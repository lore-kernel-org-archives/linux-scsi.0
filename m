Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D533123BB;
	Thu,  4 Jul 2024 00:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720051678; cv=fail; b=BuBnia9v72MaTpQkQNDhj6fwSxlSCV96ffCy3rm0L3bcch8Nr7/gBmnzt+Rz6VpK2slyTq5k5kZBJ9AM33mbOo663M8N9xM3kNoRjbvag+X8pOyoaRKgQF39MkmPqrvdu5WsFjFDSvgI4z++156XL1pzy3Oyex9YQcTrYVFiPSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720051678; c=relaxed/simple;
	bh=+LpqJ2zEDtKaFohS1583B+mSpTTrQg40Zof7MaxYzUA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oLpI7/qGR/1swiI8d6KKyDOdoqTJdrN2vVQGbfbL5xJikuPH0r78apdBM9ZPPiRKPe2gFYF1Akz0Uxg8cJSvhFnwPSmT7GrocjsJLeag09+OdlWkUiGcUk/kJYVGkXLWY46LK6AnYoevUhO8ijG07aGGI0fupRyvc8v7em61Fo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gUxLRN4S; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=JoONGPRg; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gUxLRN4S";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="JoONGPRg"
X-UUID: 73f41078399911ef8b8f29950b90a568-20240704
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=+LpqJ2zEDtKaFohS1583B+mSpTTrQg40Zof7MaxYzUA=;
	b=gUxLRN4S0pAL8OHNFTFvHMk0le+cz5OzlL2daLcslqJfjALu5RUGvA7UyaEF/W22Df3210rVh04UuVXGgH0ee41A/HPRjdLw184LgCF/7td6WRtf3eJdMM5gRInd2hJxnS+jb5tOGtDfcfslvNactNcjbLiMda7JtVS2UaQrym0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:a1177bec-57a3-4b54-8334-dc8028a455a7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:817a0fd1-436f-4604-ad9d-558fa44a3bbe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 73f41078399911ef8b8f29950b90a568-20240704
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1055894840; Thu, 04 Jul 2024 08:07:50 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 4 Jul 2024 08:07:49 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 4 Jul 2024 08:07:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etcCvVPNSjL4/37z0TqP89WCvwENZTE/TBqYob0y+KmFJ2I9RdIvdJBHJx9Lp0waM2Pm104DusNriOiClwFDy8BZRn9CmtA/5k285GGbKdxwJ/Yrh0TPsuvwlcYLIQ8us8h9s99tUHRTLJcTJ7HW7AzH+ImDvENRwhALZw/AWeybnpOHPZklautBZJY0euyJnRBQUbpVWUqvIjxYhgf5AcWOJ+5dDYdnCzH/u2YkJsCm81ifLbhRzoNBkbyqPH8gLiOrkbz6YyW2mrmmGK0vqZnwj39TSRyLivTMZnwr0jUYrpC1rrU2xEG/K0ZIn2jg72Vb5ZzGudkeZpYtGyQohQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LpqJ2zEDtKaFohS1583B+mSpTTrQg40Zof7MaxYzUA=;
 b=IXUPbE4OP3mIWTHRGwkXcMNpI04JDaGtlJfz3OLNrOtPYup2zghuucywO65vuuj+WuvZJknjBHDEIB3cwz87Zwv/sTIPANG3srBFNflCY3Q/0I6W/jj94ElUaGOuV2seJ9nVh7dwtSBpagXrthrvteNkrrFt5bwj75K9nbc7vgF7eGu7w4h0VUMKubhza2jigpLXEYs+BgsPQcEHT4aiOgJ29BJIHP0zOYKYTRh68UW3d9mHO+ASDFqnfHldCROcZ/A98A4pn9P/9gcY3bEdbp6Q1Ny5p/zDVSAezinzPePazUlZLMJ7LROLhcmlf/pqEJC7MAH3ToQRZzYy6TD8tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LpqJ2zEDtKaFohS1583B+mSpTTrQg40Zof7MaxYzUA=;
 b=JoONGPRgHaN9QuhGZMod5NYISllNCaLSl7Kc1kvcDe/n/jdK1eBct6JNzpiDdiZmegmG9Sk8+Bds7AwJNYVUuIhqO4Wd0kUlZ+18BfsPMfTBjnTMyDGdGMYjiCnSEBueGB4lUPQdXy+j1nNB43mnhS2FwrhEV8QM1q7QoaEL1tU=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 TYSPR03MB7781.apcprd03.prod.outlook.com (2603:1096:400:42f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Thu, 4 Jul
 2024 00:07:47 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::8b7a:97d8:96f4:2e6b]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::8b7a:97d8:96f4:2e6b%4]) with mapi id 15.20.7741.027; Thu, 4 Jul 2024
 00:07:47 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: "dlemoal@kernel.org" <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>, "mst@redhat.com"
	<mst@redhat.com>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "snitzer@kernel.org"
	<snitzer@kernel.org>
Subject: Re: [PATCH 4/5] block: Remove REQ_OP_ZONE_RESET_ALL emulation
Thread-Topic: [PATCH 4/5] block: Remove REQ_OP_ZONE_RESET_ALL emulation
Thread-Index: AQHazaJhODmndRwbn0y5MS7DyBUqCrHlsR+A
Date: Thu, 4 Jul 2024 00:07:47 +0000
Message-ID: <c2022791ae3b082d9da3694aadb4b089a991570a.camel@mediatek.com>
References: <20240703233932.545228-1-dlemoal@kernel.org>
	 <20240703233932.545228-5-dlemoal@kernel.org>
In-Reply-To: <20240703233932.545228-5-dlemoal@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|TYSPR03MB7781:EE_
x-ms-office365-filtering-correlation-id: 0ff202c0-11d8-4b2c-fa96-08dc9bbd561a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?TWpWcTRETFo4eGhMQjQ2L0pBUjNLa0VlY1dILzlnZk91TkdQaDJkWnBoZGtM?=
 =?utf-8?B?WVRhelFJbDRnYmd2elQ5R29INWs3U1B0OE8wY1g3OFJNeFJmT01CZzlhY0hq?=
 =?utf-8?B?dWwzTnNvK0dlTGloSDExQVlJN2REVFo1T1dFN3dIUWF2TmdKOWpYRWpUNkhN?=
 =?utf-8?B?ZHE5d1M2TFNOQ0gxQ1ZlL29lNkxuUWlpWWZhMHZTYjQ1SmlVYVBrZk5jcFNF?=
 =?utf-8?B?YTBRdlhMakpiVUt1N00wZjl0WmJldElYaEk0SDQ2c20xUU13RDUra3YvcURo?=
 =?utf-8?B?SXBzWXRWWW1zYXZVKzduVnVZY3V0ek8zMG85ci9BcGd1UTY2TU5OMFBVWHls?=
 =?utf-8?B?VjFsRkpXM1I1cFhZaWlkbG96dlh1dC9mWlZ6UjgyeEs4OWpieUk4MW9Xb3Z2?=
 =?utf-8?B?UFBFRnZhNm9qQVp6b25Yam1wWG52ZmJwV0Y5MU5tMEVMTFNsU1pWM0doUG45?=
 =?utf-8?B?ZWp1YlE1U0FtUWxHUjBrVllzVllnR0dZNTJ6OUcrdFpVVWFXUEFJNmRwMlVX?=
 =?utf-8?B?S2NRMzJRTmFCVkZWZHUzVFBvWVd4SVNQNVBiWlk3MFVvWWg4dFVFcS80cXJR?=
 =?utf-8?B?U05pQlc2RVJtbkNQMC9FSFhxMFo2c2tJL3hDUUNZa2p2YWVKaUFRc3ZEc2Rl?=
 =?utf-8?B?SWM2M251aTR4VG43OW5lQTBCR0w3K2xWSFhXZjZVQUpvOHQvRTFpMHEvMU1w?=
 =?utf-8?B?RTVhYkNYZUk4VE1RbHZmVnFKa015QUhVczIwSUJUZ2lzSmVQNlhOKy9lVURx?=
 =?utf-8?B?b1M2bnNBSHFLWGxwdk81ZkRIazFVaTg1S1VWVDNOTGpZSVc3YVdVdXA1QVdE?=
 =?utf-8?B?T1JIQmNVY25vMTNMVXRMdk9vQXBXczRQdW5SZGlONklqQVdRQ0ZIUFFIR3Jl?=
 =?utf-8?B?aTFHd1Q4dG9KaWNmVnBjb1RZRG1MV1VHc2NidUNWZVppTWZ1RDFmZFNDY0hO?=
 =?utf-8?B?SU9HN013N1phMFIxb0RLRzVZZG9FVUF1Rks4OUFOY0w2bk1NTXRRbHAvVERi?=
 =?utf-8?B?K3FNanA2K2pnbnluSjA5MDNQMzhnR0pJc0QxWUcwREhHLzBVRU54b083VEFo?=
 =?utf-8?B?VU8wdjVtbXRYWDNLc2dHYXk1bFpGMGw4cnNpdFNKVzhhbHV6VWdyd24wU3B1?=
 =?utf-8?B?THdIdC9vbWttVGNoRFZIT1JsN1ROYTVTQmVLT0FnVEdmay9ISnNLUzFvaHJT?=
 =?utf-8?B?UGpPY1hlenN2K2plQTdpUWdvakplRExWZXc2TWd6MHZRRENCOEZtMFRyWGR2?=
 =?utf-8?B?bXJYTGlvZDZpVk9UOE9nQ1VpRCtQR1BsS0FtSitBcW5QZVBLakN5QnVuS3Rm?=
 =?utf-8?B?Qm1IdnN0Q1lOWnZxWWRqVm1HaFFRaUJkNitub0hjc0dXNS9KYTRiWi8xRHBG?=
 =?utf-8?B?WVZrZTlraUIzK2E2emtVMGxUZ05YR3NVN2daZERXUjRWN2MzTGJoVURjcmN4?=
 =?utf-8?B?TEZKWEdhdHVnM1EybUJqOVUyMG9MKzROSWhMb2lsQ1MrL0JkdHZsMTBrODYv?=
 =?utf-8?B?cTI3VTNCbTRBTWlvQTRWVGdxVFlBVGRheE1XZkhoejcvY3EwNWFoZnY1Mkli?=
 =?utf-8?B?Znh2OU1vZS80N0lUdFp6NEJPcS81UGg3RjZGSzErdHBZa1MrVkFiQVg0cWt4?=
 =?utf-8?B?dkh1b0pNL3hqZjdDajE1VkVzbkpkWUJncUNQMkRLZXJXbzBHRXRLc2F0K0Yx?=
 =?utf-8?B?N2xsMkpxTkY2Q29yS3Z4ZWtkSlVLVXRheWtMcjN6Z2VKMWNmOTBZMVRuUzRN?=
 =?utf-8?B?cys4UWc2UXZNMU1tRktNV3RYUVg2UmEweG1EeGI5cUlCSXFTdzlUNjcrNnBH?=
 =?utf-8?B?SnRSckgyT0hFWmNXRkp1SnZFemIrZzkwY2FDQ2ZaN0tibUNFbFBwb2FldUtY?=
 =?utf-8?B?Q1A3VEFXeU1YUmxUeWhzdURNVUxzU1BMb2kvLzZNZTlwSFBxRWdnTDN0cEtm?=
 =?utf-8?Q?zfHLLVlTMy8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUxDc1pyUjB5c0REWE5PNFlJazNsYWRkSGdjQTZuN1NqTE9BVHpTOGpSbTR1?=
 =?utf-8?B?cndtOTgyZzBOT1k4VnA2bUt5Y3czMUNtQ1paUG1KZk5sMWZQcklhWWFFa3No?=
 =?utf-8?B?NmdsWHkyQVV4a3locHRuSG1OWmFnWjdjcEtXODRNQlZsUm42YTgzNHlwWWts?=
 =?utf-8?B?aUdrMjVmUmRzdkZlWVN4K1Zldk1IV09tUlJSUERWZHFhUngzNjFtdUd2cG9u?=
 =?utf-8?B?ZTFqNlpiWm8rT2ZhTlU5azRoNkEwbE5SZFdDa2xSTjNnZjcyN0F5Rkt4ZTlD?=
 =?utf-8?B?MTZIRVovb0s1VjRZQXdIaDRMdnVZaEhhNDNjSEdldytmQlUyN21ITnhlcjR1?=
 =?utf-8?B?bWFqc0RsWDFzbVdzTUg2VytFcTdnODhPOG9hK2RGZFFMU2NkR1Q0Mkh4bUFl?=
 =?utf-8?B?bzB2UklvZTJBWHU2Z0V5dms4c1JBRTRlYm02YTBKejd6aXZkMTg1M1ZkTDRG?=
 =?utf-8?B?ZGc1b3FYZVZFTUJVUWR3WHdlclBUVDEwd28vSGI1WTVxcjBJVzVjOFU3WlNS?=
 =?utf-8?B?T3V2cnJKTUZiMCtlZUpHQlpvZkFnY3NoUFJxMVZDWldpNUI4MVFDN2YwRXZJ?=
 =?utf-8?B?ZWZaT2tiWGRTeGtxbjdraXZtSm1vcmhSZnc4aUJqa3pTRXovazNtY2JqOUJO?=
 =?utf-8?B?QlQ0YWkyVEFpenNoOVMwc3J6aTBJUy91cVF0RU1SWjdsTGUwOWhlbldiVTFr?=
 =?utf-8?B?RGtqYjJ5bHdENVJsckZ6d094VmQ5SHZkVGc2dmVhTjR3MGUyQW81NHVUK0Jq?=
 =?utf-8?B?NU8xQjByQUNodkFGRHJ3cGJNeEMzbS93VlVDRGdxRnhJejFidXg0WXJGcnF4?=
 =?utf-8?B?NVprM2l4dzBGR0dLUisrMno4eEE0Wi9nYU13MFJEcXBiMkRRZ241Ym15eitU?=
 =?utf-8?B?SDhYaFA0NzR1cktTKzVJZEZBall0ZnNuOTdhTDlnMEo4WXNXbC9zZ0JQaW9C?=
 =?utf-8?B?OWFjQjdJdkVhcGVxZXBxL2RzTmlZMlVLQnh3TEEwa24vZ001ZFlvTkxPa0h5?=
 =?utf-8?B?TUp4anFpaFBLSEpmRk9yZys4NUdYLzM1cFloQVJVdlNMcWJxYjVtRE1aVnM4?=
 =?utf-8?B?QldzWTkrMUFmVHhJSkdORUFFamVLQmZrVlB3RUIvazJDRzdXNm95cjRjVEpT?=
 =?utf-8?B?ZHF5QmRxdjFaYWlrMUNVNmxHaEJEZThWcGl0R3dQOXlWYVo4N28vSHdWUGh5?=
 =?utf-8?B?MHp3c2xZTEtMQm14MzY3eWhCVTU3MFZGN2FsVzF6TVZ6OUtPU1VMUitZQUdH?=
 =?utf-8?B?YVIzQWdsUzNRSzRXcjYrSEtPNWlyQVdGUHcwV25BaS8vMWwwUkR3MGthVzZi?=
 =?utf-8?B?UUxOcFBnMW5GNmtDVUdvSnJkVjhZYm02SHZYVWtlWHo2NmEvMGhFUENqUGh0?=
 =?utf-8?B?UENkVllOdXhib1JVYzdvQlRYWHYyV3g4Q2xjL1hZK1VoMmlUaGY3OWkzVkFW?=
 =?utf-8?B?cEZNQW1yZnY5VGU2QmxZUW0vOUd1WDFFd1o1YVBGdWVlME1JOFphemxPRzlI?=
 =?utf-8?B?cGlROGVsZ3BFV0Fva2pvNi9wZ0JuelNKNzlDWk1sc1BCQkJ4OGpPeG0yNkdl?=
 =?utf-8?B?S3pkamVmYlNjRlJNUEYvSFpJZUIvMWRiMzEyVVJoT2o5OGpORDhpZ05CZTNi?=
 =?utf-8?B?cTlHMG5UZ1B1S21EVld1d0I3dFRjZE56dXlORkRpM2p3RlF5eklxd1JaVUFp?=
 =?utf-8?B?WDZHMmUxQ2lHU1JaVEZXWmZaVlpvcDZNQ0VTQ1cwcXBSeGxNQjRVT1VkcVpv?=
 =?utf-8?B?Z1VvQWdBWHQxOXduZi9mUDY0ZElPbmFhMXNTQlozWW9UYkdsK0ROaHBGaEJz?=
 =?utf-8?B?TDFEdmEvV2Jpd3RPMlBHOHdxYy9FcEI4akhtcHVqMzcwS0tFMHhZRUVNb2Fj?=
 =?utf-8?B?K3FLMEZQcmhkRlNnMjM4S2pCdSsyVnc4dWJVdFVsQXZkRVJCUXliRDhRY0hs?=
 =?utf-8?B?M0ttVmo4aXR0VVBheVR6L0I0Vms2Z293V0VMWG1tY21seGRmeXJ6L3kxTDda?=
 =?utf-8?B?aXdEL1F0UFZ1K3JRajc4RmZzdmc5OVc3MTNzQWhrdzdLVzdjd2EzbEdWTmVp?=
 =?utf-8?B?RHVSdXJna25sdkl5Tjc0TC9JdEdQU2wrQTN4TWs3cUFQMTRYKytQdkJGSjVS?=
 =?utf-8?B?OG5reW5udEdzd2VicTl5UStINDZMZnJXTXBBQ1gzMk8vMU5GR0VjL3RsTVBo?=
 =?utf-8?B?OFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF960A164DACAB4A9681EB390215F3B1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff202c0-11d8-4b2c-fa96-08dc9bbd561a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2024 00:07:47.5226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uKazETkD3XCKCZxukQEMnneqZ5zrrEkub3QirRo3riPHFTjWaY4j1IsUGIylBKtRQ9zuB9RFN7IbHKkOvfohdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7781

T24gVGh1LCAyMDI0LTA3LTA0IGF0IDA4OjM5ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gTm93IHRoYXQgZGV2aWNlIG1hcHBlciBjYW4gaGFuZGxlIHJlc2V0dGluZyBhbGwgem9uZXMg
b2YgYSBtYXBwZWQNCj4gem9uZWQNCj4gZGV2aWNlIHVzaW5nIFJFUV9PUF9aT05FX1JFU0VUX0FM
TCwgYWxsIHpvbmVkIGJsb2NrIGRldmljZSBkcml2ZXJzDQo+IHN1cHBvcnQgdGhpcyBvcGVyYXRp
b24uIFdpdGggdGhpcywgdGhlIHJlcXVlc3QgcXVldWUgZmVhdHVyZQ0KPiBCTEtfRkVBVF9aT05F
X1JFU0VUQUxMIGlzIG5vdCBuZWNlc3NhcnkgYW5kIHRoZSBlbXVsYXRpb24gY29kZSBpbg0KPiBi
bGstem9uZS5jIGNhbiBiZSByZW1vdmVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGFtaWVuIExl
IE1vYWwgPGRsZW1vYWxAa2VybmVsLm9yZz4NCj4gLS0tDQo+ICBibG9jay9ibGstY29yZS5jICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPiAgYmxvY2svYmxrLXpvbmVkLmMgICAgICAgICAgICAgIHwg
NzYgKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IC0tLS0NCj4gIGRyaXZlcnMvYmxv
Y2svbnVsbF9ibGsvem9uZWQuYyB8ICAyICstDQo+ICBkcml2ZXJzL2Jsb2NrL3VibGtfZHJ2LmMg
ICAgICAgfCAgMiArLQ0KPiAgZHJpdmVycy9ibG9jay92aXJ0aW9fYmxrLmMgICAgIHwgIDIgKy0N
Cj4gIGRyaXZlcnMvbnZtZS9ob3N0L3pucy5jICAgICAgICB8ICAyICstDQo+ICBkcml2ZXJzL3Nj
c2kvc2RfemJjLmMgICAgICAgICAgfCAgMiArLQ0KPiAgaW5jbHVkZS9saW51eC9ibGtkZXYuaCAg
ICAgICAgIHwgIDUgLS0tDQo+ICA4IGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgODQg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLWNvcmUuYyBiL2Jsb2Nr
L2Jsay1jb3JlLmMNCj4gaW5kZXggNzFiNzYyMmM1MjNhLi4wYzI1ZGY5NzU4ZDAgMTAwNjQ0DQo+
IC0tLSBhL2Jsb2NrL2Jsay1jb3JlLmMNCj4gKysrIGIvYmxvY2svYmxrLWNvcmUuYw0KPiBAQCAt
ODM0LDcgKzgzNCw3IEBAIHZvaWQgc3VibWl0X2Jpb19ub2FjY3Qoc3RydWN0IGJpbyAqYmlvKQ0K
PiAgCQkJZ290byBub3Rfc3VwcG9ydGVkOw0KPiAgCQlicmVhazsNCj4gIAljYXNlIFJFUV9PUF9a
T05FX1JFU0VUX0FMTDoNCj4gLQkJaWYgKCFiZGV2X2lzX3pvbmVkKGJpby0+YmlfYmRldikgfHwN
Cj4gIWJsa19xdWV1ZV96b25lX3Jlc2V0YWxsKHEpKQ0KPiArCQlpZiAoIWJkZXZfaXNfem9uZWQo
YmlvLT5iaV9iZGV2KSkNCj4gIAkJCWdvdG8gbm90X3N1cHBvcnRlZDsNCj4gIAkJYnJlYWs7DQo+
ICAJY2FzZSBSRVFfT1BfRFJWX0lOOg0KDQpJdCBkb2VzIHRoZSBzYW1lIHRoaW5nIGFzIG90aGVy
IHpvbmUgb3BlcmF0aW9ucywgcHV0dGluZyB0aGVzZSB0b2dldGhlcg0Kd2lsbCBiZSBtb3JlIGNs
ZWFuZXI/DQoNCj4gLi4uDQoNCg0KPiANCg==
