Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34F1374D9;
	Wed, 26 Jun 2024 03:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719374209; cv=fail; b=anadq9lyA9buWHaaw1z/xt3sQpESYWaQ86GyIf1wsudjFtPzfSr1JbtkWhZYfLqJQ6kPRhOWyDQ4GseMlQQLn58lGvWNOZVOKR9qhvt+qlOHptvq8TPooqWdPOfw2Vaj7liCBwDFo+W0U3EGELF5OqmzSsOR+W3700K/fhqsyss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719374209; c=relaxed/simple;
	bh=fi2zcOoHD1xmUVpwCjYLho8HqWzNg1ZVg4Ma9fPhim0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F3nDkpi7VmlD4l/iRBpHlfklAD0//iunkPXuQjZPKMapwhRBlNkO67zoKewOHbx0z6ucR7nQJQmr+mwvu0MgMly/XU0wzoEafFfCoOF19kLUuWwCQ3B++rGtoCy8hkIKr8ysbqBxGt1mXzXvTpOKQKW4CqU4IhCOuwri/VVnt4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qzan9u4J; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=nm5InolT; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qzan9u4J";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="nm5InolT"
X-UUID: 188996f6337011ef8da6557f11777fc4-20240626
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=fi2zcOoHD1xmUVpwCjYLho8HqWzNg1ZVg4Ma9fPhim0=;
	b=qzan9u4J1gG+Sz4wrtF+HzJvswR98qKMk8/w6u4VnoMETILQumW0+Gh/FBKoAU8mUMfmA0kOGfFkQEmK9pNsy6SHgepma7nlbuQ6pjRX0ZGEgIwR7v4kTyRS73XQBEDjb8FwE8hAH+ejopMtbTw5rYJZpfoGvNLWCCxfbp1/2rQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:a545e4ae-8a60-4be7-9db3-aca9041ac581,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:29430a89-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 188996f6337011ef8da6557f11777fc4-20240626
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1800080498; Wed, 26 Jun 2024 11:56:41 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 26 Jun 2024 11:56:40 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 26 Jun 2024 11:56:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h08oX5Y964cqxXyM61WFuvZopmVIDc5KH4Dph5QmzvCyaZJc8qCfu9exnsA7/Sga2JanXqA9FK6xQHR7OTFEBIzHhX+r0brqOumXf3LLblXrjrNBOHPl1qxUydBYTsbkCiq4o0CPtwwanwhSywGjTk/dlN/806BXVWVYAELs5gPQ4GeR2Cfs+JVRmNgnpP4QM8SkV+8wrnm3snv5snxysA7Ope5vbyDHCbYDo7teMLxYHPl6Sg3+kL/OZ2LDbZ3VWQg42tr6pN4j2WqJB2QPdG6t9aMWjNbJw1dzjtnt0vPxnwgVy0WJGmYZd9cSYMBHrjFmMdKl4KCiRVwrkIwfJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fi2zcOoHD1xmUVpwCjYLho8HqWzNg1ZVg4Ma9fPhim0=;
 b=GGfp2m7vQ4/bUkPnJ1SIH1ZBDI76URs96qxsgGAPUpdiNek6LZob9YCcrffmMLjj5vx+Yn9xImyFPYOsM4OT0XRwONdB4tpW/qAVqrcoapLJBi7tA4WyqzpuwEM4ZbIXB0F+YTthhUBImXBk8ufVfmlUbbVRWBNkPd+ZdFwj+obE7bil2Ys3kCvZ1WF4TvnNUbxpXnYZsPLevOmlHqTRmyZEjPdZxXWfhAchMHQquNod+kEuGpThmD2FiGasGYHgpwQ1XcN8yj1oyGfoCBgAz7keztvUV8KXEfG4hTT8zrwe2oaSTaL5y/Loec6mxBYuSFnDGlZiFcajCbE9Lbo0Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fi2zcOoHD1xmUVpwCjYLho8HqWzNg1ZVg4Ma9fPhim0=;
 b=nm5InolTw0PMHKFukSEwbr8VLxGdcsV16k7IkUT0CqsOcKl/sq13g8aNJbitYEnARh0mUgWMmweVrPjyyPakRzEfuh7iBXxHW7s4B84yCN32I+AyQ1olBiZnOx73c26/h/cAtoBlw68+bUXRg4wLEIHgFKSQHa9K+Pziv9go9IQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8114.apcprd03.prod.outlook.com (2603:1096:990:3a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 03:56:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 03:56:37 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
Thread-Topic: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
Thread-Index: AQHaxi+9yVyGxDcFYkS8cVbs4SEa0bHXNMuAgADyXICAAInTgIAAvFQA
Date: Wed, 26 Jun 2024 03:56:37 +0000
Message-ID: <0e1e0c0a4303f53a50a95aa0672311015ddeaee2.camel@mediatek.com>
References: <20240624121158.21354-1-peter.wang@mediatek.com>
	 <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
	 <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
	 <795a89bb-12eb-4ac8-93df-6ec5173fb679@acm.org>
In-Reply-To: <795a89bb-12eb-4ac8-93df-6ec5173fb679@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8114:EE_
x-ms-office365-filtering-correlation-id: a98c8e0a-4891-4edb-ec3e-08dc9593fa4b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230038|366014|1800799022|7416012|376012|38070700016;
x-microsoft-antispam-message-info: =?utf-8?B?WlhjWEVEWWs2U0pLUndqOUJmTEVLK3hZTnRjWVFLalZ5VXNmeDdVaXNVcDBn?=
 =?utf-8?B?U3ZyRmJmQzZGeDhzY0JqN3Q0WUhDZ25aS3ZuK2NNb05GWDdkNlRFdStTZEhV?=
 =?utf-8?B?amowQ3FiNlhoWnlGOXVmNzVJczVWU1pYa2tXaktNYmp6NWE3dUlRWVF0WVVh?=
 =?utf-8?B?MUFOWlpuUkVoT0YrYVVnb25GWUNVbmprM0JUMHpnWTBuQmpQbXlMeWhibk4r?=
 =?utf-8?B?TWxtcndHL01IUGd1cStDUTRpNnl2TUphQUI1U2JkZHlyVjRqTzN4OUxZekdy?=
 =?utf-8?B?U2xJS1BVNDdDbHNjVTRXUVRyS25WMnRmZWNYQjRDWmJUUEM1aUNhZVBFM2hv?=
 =?utf-8?B?QlRxVjQrOTNyNHhMSDZMSmxqY0lWRGt1NGRLT2Q1Ym84MTJDT3Fscnp5eHl1?=
 =?utf-8?B?THZSREFENGY3d1BTbkRqQnV2YjZSZWY0UWk0WGs0cnlMVzMybWxMenZQTTRE?=
 =?utf-8?B?RWNTdStBVkpuZ0Q4ZDN3MWgvS2xOaXhEOXltVElQS0huZUQxbU50NllIY0xE?=
 =?utf-8?B?U3VnRlBycVI0YXNYM01OZENIWXJidmlXMFdTaC9kV0VmeEd2aWFiaklWYk40?=
 =?utf-8?B?RG9LWS95TUpjMVhVYmZ4bmdiaVlUaVVnZWJ4dy8wcVJsb1pzZSttWGVBSHY5?=
 =?utf-8?B?Z2w2YUQxWGRHTTE1a3JIWnZGRk1hZ0p6RzUwOUg2WDVNd2MwNXJMNlNqY3ZD?=
 =?utf-8?B?UmFFUG5oZEF1VGlHM2tRdlNrek9TcFBIUDFacERzNDY2QXdoVWdMaElLMHRZ?=
 =?utf-8?B?UTg1eGZmVzQ2UkV3UHd1VDNHZVkyWWd2N0k4MmZySStwMUEvZWMvUXl2YzIx?=
 =?utf-8?B?K09Wa2E3RkI2K2ZveXQxcW9PRkRrTUVGSGxtNGxkMWwvYXcvWG9LdVA3TnFu?=
 =?utf-8?B?OXd6bmRNUGJFeCtGTjFTU0loZ1MxV0FmOVlKdU42VTE4eUU1OUZEcW0xOGlm?=
 =?utf-8?B?cjVNWThRL3BxQ1gra1Q3NGF4RWpmMzhQZEJZSUd2alBpcWVVZFUvYUZLeTBS?=
 =?utf-8?B?MTVaaEJTZ1l4dy9Ob01RVGtTUUxGQ1FLZURJZDc0ZmlSakFGQUJFTFdOMDFw?=
 =?utf-8?B?V0hNZ2VoV0FiRTlaRlZKbm01ZmF5SnJOUlowaThWTFJpMW9mQTRmbm1HLzlP?=
 =?utf-8?B?MjNaT1JPSGZ0a1JqVFA1M20vTVNWZjlEcHpGNFlGb1VxRE8xQXR3NSs5cWR1?=
 =?utf-8?B?M2FJWHkzaVVoeXFuSWdWZjIxU1B2VndWdnRFcE1ocERSM1RndnhvZXduaHRr?=
 =?utf-8?B?VGJra056c2wyelBnbHFJVDZ5VU1XQmpiaGhNZ29QZ3JYTUlPenV3cVVqOTNn?=
 =?utf-8?B?aVc3eTFkUU9RNWhTZmh5VUFOaHdadU5hSjkyeGhFdkx6ak1iMnRobDVsSnhN?=
 =?utf-8?B?YWlObzgwUy85QzI1aGNoU01QVjJEM01IZFMrQVI0K0xiY3dubFhDUWVvcE5l?=
 =?utf-8?B?TENMb05EYjNlREpwUWdXN2NaREVGcm14d3dHSkY4ellzWVh3TWVZdjlHWDFQ?=
 =?utf-8?B?MG0veWZEVEVIU0VYM3MyUnY1a3RyTnNmaExZZTI2RVVsTGJVaUZxMmpQbHgw?=
 =?utf-8?B?S1RhTGcvSmorZC84OGJ3d3V6Q3Y1QWxyczF3Q3QxT0FWK1dXcVZrTmMwaU9Z?=
 =?utf-8?B?bzQ5WDFwc0laL2c5aTR2VFQ1bTZna1pMY1V5enNkbjBoL3VjVGtmQ0NzNXZs?=
 =?utf-8?B?d1RHZFgxYytVcDRtUHA1RFlHS09raHdETUN2VC9iVEFSVkNrc3FJSGlTRHIv?=
 =?utf-8?B?d0RneWRQYmdvNSthK1BzdDlZb3pKTkc2NWVHeVE0SHJwRi95YjRmRnAycDNx?=
 =?utf-8?B?QVUrSzMzNjkyUVFCSTZrTEE3SkdGRGxNVTlGWGRaNlMzRDk0ajdPbXhhKy9r?=
 =?utf-8?B?M1dFYzd0Ylk2dCtvNmhpODMzZVBkSFg1QnFNVGdoMzNVMlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(1800799022)(7416012)(376012)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTlHMUNOY05wQ3hJNUZOOUd1a3dWamoyUGpGUzZoQno2czYzUWw2MUJWRVA1?=
 =?utf-8?B?SmRVd0N5N0hSeXcrRUFHaXY1clM4NW1HL1Y3T3RkWlo4S3RUaU1lMGFrNjNj?=
 =?utf-8?B?b2xpdFBtWFRHcVgyOGI2VGVONFdhSWdKTURtMVJqN0J5TXZZVDZIa1NML2VW?=
 =?utf-8?B?dGFxcDhvd3hFblUyYThJSTNJVkJ4dXhZMDZyTXMzMllObXJSK2RvTzYzZHI4?=
 =?utf-8?B?Wmp2U3g3bGd1aVNyNDZONWtuWCtRRDBocURCWDVxSVcvaG85dDlDcXFneHB0?=
 =?utf-8?B?bkRvNm9kUXhVcEI5ZkZ2SThGalU1TW9QOXJ1VndLc0Jia2w3aXFwSzloZWNk?=
 =?utf-8?B?OXM3K3hXcThnZTRsdm42ekRXb1BBcnlaczlBRytTaGJENFB6ZEZEd1pWV2w3?=
 =?utf-8?B?VGlyWlBCUUV2Rmw0RktHRnF4YzFrTzdyMlJQSHJENzJBUU5XUGg0eENYL1BP?=
 =?utf-8?B?d1pkZitxODJPcWJVb21jdzdaOUFmNTFqRWlyMkJZVXdCd0hmdjB1L0ozQ2Zq?=
 =?utf-8?B?djhCdnpPczY0SVBuQmhDTDMvd2xFNHZQMDErT2prSnZ4eUNXSG1NbXBXN21J?=
 =?utf-8?B?blNXYXFsK0VKb0NmUWl4K2hwUmZxSEx1RngwWXVta2Q2cTBBYms5U0RZRTVk?=
 =?utf-8?B?N0NpaEZKTGVRZHg5T2JxbG52aDFuQ2ZOcXZEbHduRVVEV3loMk1rVWNZTVdZ?=
 =?utf-8?B?d1g4SENEK1pNWHd6bnJXVnBXR25FeEorU2h2c2hhcGFKL2Fobml1RjFaRHk4?=
 =?utf-8?B?aXFBZ293dE1FOUZNd29iTUZaSVlMOEovZGYrblI3WmJFdis3WEtHaUM5NGFR?=
 =?utf-8?B?eEl6WUlsVURhcVIycWpGUzF4K01IYTZGNVowOERuYlhXeHhhNkFGTzFaUzd4?=
 =?utf-8?B?QmxTMkZQSjNKUzd6Mnd3RHl5YmZMeHNWekw3R1dLV0sxZzdjTkU1RGswRVBt?=
 =?utf-8?B?K2JqalNaRkZCZDQ4ZFNCRHp2NjJyYVRyeE1ENVlOMkN1dFlOY3ZMS0YzZGs3?=
 =?utf-8?B?UHo1am51b2ZtU2d2NEZFYU1QZDZEUC9BT2xuS3ZSVndDOVc5T3htQ0duNDAz?=
 =?utf-8?B?bjgyM0RUQXJjMUhUdlJUM1kxVUloMmxpM1ppQUN3QlV4WG1mdWVGMnppblFj?=
 =?utf-8?B?SDRsdGp3T3diWWJPbkxXOTJrZml5Z1RMNjBzWGpRVHRxeFNTY0E0dG5TME1v?=
 =?utf-8?B?Y0s5KzVaaGVkdmVKZzJ4R015elBzcjVZbDFzbW0wbGkxTEhqUDFXUmFpdmNs?=
 =?utf-8?B?eXREaHorbWI5bHZPOVhmYnZFRDJyZ2l6S0NRZHppdkJ1eU1PSFhDODBUb0xn?=
 =?utf-8?B?R0YwamlyT0VXaWNiWlU1SDZVZUpWVHdKTHdUL0xidm9YRVgwM0ZxQ1JYTHRH?=
 =?utf-8?B?ajlJU0gzYUFmQkxKUUMzekMxS0c1Q2VjbWhRQ3l5T0NmdmhFNkRwZEUzdVhs?=
 =?utf-8?B?VUxtZ1FHN1Y0NUV3ZzFkVTd1S0tCMVZENDFwUjZ4UEVsb1NxVkJuRFgyVXpO?=
 =?utf-8?B?WDN1L2FEQWFSOXV2TTdlekowTjBRc0w4SmZqdkhvUXNPeENmVVVwcE9ybkVm?=
 =?utf-8?B?anRPeTFNMk5qd2prL0IzQ2ZuOEtMREQzaU9KMGFsdWtZaHhkcytONlJyNGFV?=
 =?utf-8?B?S1JxNkZ4dDVDVEY0bVVZZHRsRmxkeGZ6V2s0M1g0eFlvZHA0QU5EdXFCUjJ6?=
 =?utf-8?B?MHVxdFdZckZpSGlCcDFPOGMwY3Y2Y2U3bFp0WTB0YytUUVJBVmJyQkdac2h0?=
 =?utf-8?B?ejdmc0xXQlBBY3lsS01WbXUwQVN4VWwvT09md25uRGdEM0k3cThzYU9qOWVT?=
 =?utf-8?B?N2t6K3Z5WGdNYjcxeVliRW4xU254eTNibFJ3Q2RIRVJxTnE4NEo1eTdvR3ZQ?=
 =?utf-8?B?azdVdDlrcmdpZ0ZHclJDZDRBUGw2OFQ4SkpHaGs5Uk5hRkFiZHYvQlBlRHky?=
 =?utf-8?B?cXFWMnFUYkxSa3dacjQ1TW9TdDlRTjVKUllWNkZpckFUejRTZi9HRU1GYi9G?=
 =?utf-8?B?YmM4QklvNXI3ZnQ1N2twU1FMazZVRkwveWJuMlJaalJPVHpSSnJVUmJtdXE1?=
 =?utf-8?B?OTdaY3JqR3pPR0JPeGV6WHJxNE9wODhNYVhMNEs3OHlOWXlUNzRkWWdLL214?=
 =?utf-8?B?VnNUaUV6VVZLM2lmU0sremY2K0tPTkpiN2UxUVZNYUM4OVFaOC9LNkhYRFJl?=
 =?utf-8?B?cGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <685563B142F4D84A959E90694B23ABE1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98c8e0a-4891-4edb-ec3e-08dc9593fa4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2024 03:56:37.1579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LKDND/ClsyjfegzESe20ZG7zBZZVBrtJQWtOg/JKZuPQqvWieH53nAhyImPXknrqany8E3wrUSJutUQdBs60IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8114
X-MTK: N

T24gVHVlLCAyMDI0LTA2LTI1IGF0IDA5OjQyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiANCj4gUGxlYXNlIGluY2x1ZGUgYSBmdWxsIHJvb3QgY2F1c2UgYW5hbHlzaXMgd2hl
biByZXBvc3RpbmcgZml4ZXMgZm9yDQo+IHRoZQ0KPiByZXBvcnRlZCBjcmFzaGVzLiBJdCBpcyBu
b3QgY2xlYXIgdG8gbWUgaG93IGl0IGlzIHBvc3NpYmxlIHRoYXQgYW4NCj4gaW52YWxpZCBwb2lu
dGVyIGlzIHBhc3NlZCB0byBibGtfbXFfdW5pcXVlX3RhZygpICgweDE5NCkuIEFzIEkNCj4gbWVu
dGlvbmVkDQo+IGluIG15IHByZXZpb3VzIGVtYWlsLCBmcmVlaW5nIGEgcmVxdWVzdCBkb2VzIG5v
dCBtb2RpZnkgdGhlIHJlcXVlc3QNCj4gcG9pbnRlciBhbmQgZG9lcyBub3QgbW9kaWZ5IHRoZSBT
Q1NJIGNvbW1hbmQgcG9pbnRlciBlaXRoZXIuIEFzIG9uZQ0KPiBjYW4NCj4gZGVyaXZlIGZyb20g
dGhlIGJsa19tcV9hbGxvY19ycXMoKSBjYWxsIHN0YWNrLCBtZW1vcnkgZm9yIHN0cnVjdA0KPiBy
ZXF1ZXN0DQo+IGFuZCBzdHJ1Y3Qgc2NzaV9jbW5kIGlzIGFsbG9jYXRlZCBhdCByZXF1ZXN0IHF1
ZXVlIGFsbG9jYXRpb24gdGltZQ0KPiBhbmQNCj4gaXMgbm90IGZyZWVkIHVudGlsIHRoZSByZXF1
ZXN0IHF1ZXVlIGlzIGZyZWVkLiBIZW5jZSwgZm9yIGEgZ2l2ZW4NCj4gdGFnLA0KPiBuZWl0aGVy
IHRoZSByZXF1ZXN0IHBvaW50ZXIgbm9yIHRoZSBTQ1NJIGNvbW1hbmQgcG9pbnRlciBjaGFuZ2Vz
IGFzDQo+IGxvbmcNCj4gYXMgYSByZXF1ZXN0IHF1ZXVlIGV4aXN0cy4gSGVuY2UgbXkgcmVxdWVz
dCBmb3IgYW4gZXhwbGFuYXRpb24gaG93IGl0DQo+IGlzDQo+IHBvc3NpYmxlIHRoYXQgYW4gaW52
YWxpZCBwb2ludGVyIHdhcyBwYXNzZWQgdG8gYmxrX21xX3VuaXF1ZV90YWcoKS4NCj4gDQo+IFRo
YW5rcywNCj4gDQo+IEJhcnQuDQo+IA0KDQpIaSBCYXJ0LA0KDQpTb3JyeSBJIGhhdmUgbm90IGV4
cGxhaW4gcm9vdC1jYXVzZSBjbGVhcmx5Lg0KSSB3aWxsIGFkZCBtb3JlIGNsZWFyIHJvb3QtY2F1
c2UgYW5hbHl6ZSBuZXh0IHZlcnNpb24uDQoNCkFuZCBpdCBpcyBub3QgYW4gaW52YWxpZCBwb2lu
dGVyIGlzIHBhc3NlZCB0byBibGtfbXFfdW5pcXVlX3RhZygpLA0KSSBtZWFucyBibGtfbXFfdW5p
cXVlX3RhZyBmdW5jdGlvbiB0cnkgYWNjZXNzIG51bGwgcG9pbnRlci4NCkl0IGlzIGRpZmZlcm50
IGFuZCBjYXVzZSBtaXN1bmRlcnN0YW5kaW5nLg0KDQpUaGUgbnVsbCBwaW50ZXIgYmxrX21xX3Vu
aXF1ZV90YWcgdHJ5IGFjY2VzcyBpczoNCnJxLT5tcV9oY3R4KE5VTEwpLT5xdWV1ZV9udW0uDQoN
ClRoZSByYWNpbmcgZmxvdyBpczoNCg0KVGhyZWFkIEENCnVmc2hjZF9lcnJfaGFuZGxlcgkJCQkJ
c3RlcCAxDQoJdWZzaGNkX2NtZF9pbmZsaWdodCh0cnVlKQkJCXN0ZXAgMw0KCXVmc2hjZF9tY3Ff
cmVxX3RvX2h3cQ0KCQlibGtfbXFfdW5pcXVlX3RhZw0KCQkJcnEtPm1xX2hjdHgtPnF1ZXVlX251
bQkJc3RlcCA1DQoNClRocmVhZCBCCQkJCQ0KdWZzX210a19tY3FfaW50cihjcSBjb21wbGV0ZSBJ
U1IpCQkJc3RlcCAyDQoJc2NzaV9kb25lCQkJCQkJDQoJCS4uLg0KCQlfX2Jsa19tcV9mcmVlX3Jl
cXVlc3QNCgkJCXJxLT5tcV9oY3R4ID0gTlVMTDsJCXN0ZXAgNA0KDQpUaGFua3MuDQpQZXRlcg0K
DQoNCg0KDQo=
