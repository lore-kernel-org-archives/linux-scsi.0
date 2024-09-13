Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0289E623;
	Fri, 13 Sep 2024 07:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726211415; cv=fail; b=mrY0phZ8V8J9Xrzpr3D/9lM25Resw00XcDGwnor791MRiuy4Zy3aiIH1zB7gdkhGkVdAur1W/a0LQmOFkb1erz0exCq4xgiYO+5+I7f7VQk47KM9ZGNQefYnH23AuVvaUjdd+R8e2x//qqPx70+j4d5OQJ8qj/uRbZV5uK4z5Yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726211415; c=relaxed/simple;
	bh=KSDMQnXEOqX/coob9JAX5iBpHbkOfr30igzGjUsIe+A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZUx5AaH/ua9C/DqoDlY4D5tewPPMtQCHtCVHIYdth/5mo7Z0SorWBau2B/XcBqUhmD3ksfzXwnU2UVqQqBQmnkyoqCAkgqLGlmzMznAnZ+eizawuLtrhUMH8nW4WXsQmC7VMsiAOd3qlNa8F2CTO4Zt8V7jFCIbJM/3bxZUzR4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=o8zRKyBh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=nhEcPmNS; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="o8zRKyBh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="nhEcPmNS"
X-UUID: 36282b6a719f11efb66947d174671e26-20240913
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=KSDMQnXEOqX/coob9JAX5iBpHbkOfr30igzGjUsIe+A=;
	b=o8zRKyBhUMNyqKm8YAo/bzGzIZQls7uG4UNkrY9YMKvXhBbPXGl1hwfgb7S/SP5zuJQJvPJR3kRHBdDK2jNaPK4ba5enUn9kbCFcnteQF3wqa/7RLkQZ+QSddVRM4fMW+z1Xi+T1p8LGRTiZ70XaW65iNPUtw7Ram17/OVc2hVI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:3d76e7b3-bd74-4b99-a523-c2de4b17c35d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:4d66e8bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 36282b6a719f11efb66947d174671e26-20240913
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1032277110; Fri, 13 Sep 2024 15:10:09 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 13 Sep 2024 15:10:08 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 13 Sep 2024 15:10:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p36qMm9SO6VXcfJGe1eVT3gxoTkU/C+2bgqXOELKd3pqi8yQlMZl5Wem8JfqXb+d7AYjrpQprMc9zQGK8UXgCAXNCKsVjoVg34m71VNZ5ADpGcHJplVQog8Cnkui84yeEJiMjyea8/jHtEZGY1ueKA0TEwoiqcyM1HvEKFebBdeOtVq0/0u6wpIxg6XlRTj3RPK8rikUA7w1dJQt9deWPF1ymEtDqaJDK3uHwJ5sUej8vduikH/wAlr/3drnjM0w+hmzp0aT5ZjHp2xEvdBPHOyuw1DDPfCII19e9aPtMvj/BoJC964VH3dZjnk4GbeZZID5vijzOyHzKGu8mEbVTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSDMQnXEOqX/coob9JAX5iBpHbkOfr30igzGjUsIe+A=;
 b=MYdJvKQnnOUSB3kNAR6nfODJd5r4OXomljuzc369y3iFtQF/V0AZrfmEmQiJGLRiIGE8b8J8BAVA0vg+Hp//puRG9gprVLYofaM1GHOhdgz6H27VYKuv3tlpZceU4GWCTrvAxv/zBrjtEbs7Q7m+HFGQWfcAnIoLQe1uIfbEVt4PLuMd/5SHStYIjIEu55AFETYP3sTeLRRtQpZmQJrWw7ctW6JOqX80boDXbUK1DW+Cv392/8bIo9o8Q68moRNeIMXlrRKSeKGa3CCRGwYPWFVIhCB1DCeHt65rZjEjra2/IEGMdijJWku0XuapfqOnOysOLGNJfCUn6ILCKlqxoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSDMQnXEOqX/coob9JAX5iBpHbkOfr30igzGjUsIe+A=;
 b=nhEcPmNSUmlF965MUEsj/nO9r5oCMHr+pe7O9J0jYDnevpBK/q7BO3Xv0JiQhFAtN1qoCMq1DpWUsmq9miHqqPD5+ODQYihbhs5LgTtQZiRVu6SJOWa614bzf/Q107i22PWZOkX4M+fMalQAHB9hibWL6rlv74YuvmBEaTlvGxY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6616.apcprd03.prod.outlook.com (2603:1096:4:1e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 07:10:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Fri, 13 Sep 2024
 07:10:05 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v4 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v4 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbA1N1RX6n4EeryE2vN/rAxATc77JRT7iAgADKYQCAANwoAIABMz2AgACCMYCAAKWTAA==
Date: Fri, 13 Sep 2024 07:10:05 +0000
Message-ID: <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
	 <20240910073035.25974-3-peter.wang@mediatek.com>
	 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
	 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
	 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
	 <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
	 <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
In-Reply-To: <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6616:EE_
x-ms-office365-filtering-correlation-id: 551469db-26c7-4310-caa0-08dcd3c31841
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WC9WeU0vRGt0eDBSR0Z4Z1lLOEMrYWFqdTdlZHBFNWdMQmRtK0dIMWNhNFFZ?=
 =?utf-8?B?Sk1CbmRuTHJRelhNRHNHd24ySVh0eXBsZlYydCs0aXpjdWNOMFhQVTJ4Zmpw?=
 =?utf-8?B?eHppN0tzb0FSM2JOd0p1Q1d0VWU1YzlsRU9yNlcxR3NEcUh4aFB1dmQ4bE8v?=
 =?utf-8?B?OWVkaFppVFhqR2M2aVhEZkp3ZzJLSXZxZzVMT1k5YlFkN2R1ZEdsSXV0OXdo?=
 =?utf-8?B?QTJ6TEhxbjlrL3ZTVTFOTHAxenF0TE02bjlMM1crWGpqNStMTlRrU3hQNUNB?=
 =?utf-8?B?UVR3U0xrRGRIdTFGYzJZcmtRWld0TzZNYjlucWdpUlJCVFMzSUg5ek1Jdjh2?=
 =?utf-8?B?VENEQm55SkRGZS9UaUVmOVBjQ1pSWUNaUlUyL1ZhUUx5QVMrd0pFREJhSVVr?=
 =?utf-8?B?Zk8yTUY2emRDNkVXMG4yMGlpd0J0OVZJN01jVXFFZGFZUm12MkNGYWtrK2Zo?=
 =?utf-8?B?aVlBcWloSTZ1MlMzT1hqL0oycE5HUXBzbGNKUzNaRlR4ajljTWhIeWRkeWNO?=
 =?utf-8?B?V3pwdUR3NWFFamJOdE1LSWV0MFRPYll5RnZIaW45ZmdJVkp0K29CaU1qWmtz?=
 =?utf-8?B?NERaUGJKWDk5MUl5S0I1YkpPeHNhSzhrNDJQV2c5a2ZaYjFIZHRCRVJLK1hW?=
 =?utf-8?B?dDAxbHp4c0pSMVBMdkhhM0Y3Qi9ORzU5bFBwRWl5KzVxSW1MM1JRNDBvRjhT?=
 =?utf-8?B?SStuVUZwVTRKakRVY2Q1VEM0RW5XTlE5U205MzVtTHRIWW5YYVkxMmVBMGtL?=
 =?utf-8?B?bUFqaHI1aVJ5L1NWTjB6N2Q5dG9NL3pVZ09vTlRoNkhJUmxTM1UxQXphd01q?=
 =?utf-8?B?OFFwZjlOU3JNZkJFSnBqTXJjMUlqTVVETytFc2xaOWhpU2NHdUoramFiTmJU?=
 =?utf-8?B?KzJPemVUU2RZMmlncmtac3FqR2NybVpHdXY2L3VYT013bVBITFhjSm5JSXk3?=
 =?utf-8?B?SXlQblUwSWlqNFR6UmZDZlJuZGVrMXpFRjVqSmVZNWpLdGRJOGpiaUtsaThx?=
 =?utf-8?B?Um1DQ1ZvdDdJMWxXVkxOU0ZWa3RadXh6L3pZWVUrY0sxSnVQemFUN2J5alh3?=
 =?utf-8?B?N2RIQlcyU3ZPajlCWEhtNW9NWTZ4RzFtQ1c5RjliRTh3WTFsRGRFK3VPeDRX?=
 =?utf-8?B?NkZDcDlOM3NlUVM2WDAzVHJyaE9iajdxV0RCQ01Fd1EvTUc2NTVwNjNPZWlO?=
 =?utf-8?B?TEdscDdUVWJrODVjVzN0T3R2bCtJbFV2NSt0Z05zVnpjY1lnM0l1dUlHWGVr?=
 =?utf-8?B?WmhKejg5NmdtSnQ0V0dHaU9SVVo1WUZGdTRNNmU1eS84M3lnYlBIL2NNRkE3?=
 =?utf-8?B?clNrTUdGNmd1d1JWSzRZSHJCOFBDVk1vdXh3SFVxcjR5Z2JiQ3hNT0JjRjgy?=
 =?utf-8?B?K1dUNjBhbGZVQUN0bHd3Z3cxbWdNczVRMU9WWUNwUHM3ME0xYW5yWnU3c3la?=
 =?utf-8?B?TnRXSllsNXdZQVYwYjU5b1JSQUtrSjUwS1V3Tkd0Yyt5S2p3Zll5d0hVdTVE?=
 =?utf-8?B?UThMQzcxN3RUdWNadlduWEJFVGE2ZktEVi94S2NrSEZPL2Nld0hqbHV4QWJ4?=
 =?utf-8?B?ODBpVCszKy9rMkpsUnZvZTNIak9KTVVHbVZobHB5U0t0azR6Y2Z4T00vWDNT?=
 =?utf-8?B?ZjQwZTBUMGdkSlNlN0RhWGw2RGlWS05vL0xuVTJYSDNVSlcxOXRqWERVaC9s?=
 =?utf-8?B?NVVrcW5KOG1DTTRSWkVNbW1kTjFVWEVITjBuSFVPdmFqQ1BKOGdpR0JxSU1E?=
 =?utf-8?Q?KZlaDcHJMD+/9/47v1qSOt5zsTvVvPCbheP7hhq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTYrbjhQT2lkTHA0T1ZJMkV1VHNPaHJYNkV3Uzk5ZzlvY2wzSFhwaHIxbzdi?=
 =?utf-8?B?WnJMUDJQOUV6L3FxOFdWMWdKbmR6b1JJZVBBVzNuNGZlWTVQM1JHd1RJNDhi?=
 =?utf-8?B?WWhpQUxpb3BCU0Z6TXVteDdUNG9qeExkMzU5MGtFa0E5dlFvbWlOSHlJc3Az?=
 =?utf-8?B?MVFYdTNIdUFQeTFjN0R2YkRvQmxlWkJTWjgzSVpqNjB0eXB0ek9WVHlQcmpy?=
 =?utf-8?B?T1lDbExDdVcrVlJXN0FjanB4dnlaa3JDOFlIajFtVFRyQ0pVSTcxQjA1Rk5j?=
 =?utf-8?B?RXEzNm5vTCtNOTkrdUZTSDgzK0YzbUF3Q0dNWk9FK2VJVzJVK2xtSDdpeUdS?=
 =?utf-8?B?Z3ZoSTZuaUVGYzNNbUdyMktpK09pTVhmT3VkQUhoc3lGZU1aVmNPdG1YdDBI?=
 =?utf-8?B?eXlVZGF1YkNBazU3U2FJWDNYa2tvOVc3YXQ0UG5XYmdqYWd6cXhpTTBuVnpX?=
 =?utf-8?B?eHA0RVppSVIwOUJsa2NUaklEa3FOOHhNam4rbFBNejdrVDltUDlqZy9ESmpG?=
 =?utf-8?B?cG1QZjZaTEN4UldsbEtqTWo4M0ZKSVI0dXh5L214cHhGRDRLdHJ2N1V2M1Jn?=
 =?utf-8?B?QVNreHFYdk1YNlBQSWxPMmNrbDhFMUZ6cVZJOTF0VFArcVFnRTNlTXljUTJ6?=
 =?utf-8?B?R05JdkdqZlRsOE1zSFY5TnVHYzBCYXNnR0RSWEJBakRLNkxIaDY3bHZOaGha?=
 =?utf-8?B?a3F2c0toaksxWWFnWTd0MkVNcHNNSjRRREVRUnBKeXRoUVVVc2R5NUJxaFdE?=
 =?utf-8?B?UVNUU3R0cksvT0JLNUlHODVFMFFXQWNvcERvWnpuNmZMU21ObHR0WFMyeUFz?=
 =?utf-8?B?bE05YVVUUjZIeTBoSmRUQlNsME1nSHVsUzRjOW4zM1g0SWgvNmMyM1B2Uk8z?=
 =?utf-8?B?c0JxTFNaODZrM09mNW5WNHBDZzFsOGNlRlo4NUJvemtkTlpHcHRranFoRm1z?=
 =?utf-8?B?Y0NHMlFsZGhhRHcxOUlEQzhHanZZK1l6c1ZVZmpoUEQzNG52aVBqZFg1S3FC?=
 =?utf-8?B?RDlIS0RqZ0hsY2RoQ1E3VkhneEtzaC82TGMyWTZNblRBVzhGbm4rQkpHL0Zn?=
 =?utf-8?B?QWs3QmkwRmxkVWpvOEduaFI4aWxibFFkQllLVFpFTzNpRHRMNjdoQndGaXVw?=
 =?utf-8?B?TFlQbHZsMUkzODEyOUt3UG9yUE9VcXNZVTJ2RnZyMGVzQmRoRGFrR2NVVjRu?=
 =?utf-8?B?L0U5eTg4UStweE9ZNk5hcW5kQ21qM2xxVzE1bXpSb1dUbDhoTTMxSDRFVk9Q?=
 =?utf-8?B?Z0s2NnVISTFwdEJSZkdkaDNJK241bXZvdTdVRndpN25XamhJZk1OZVRUa01h?=
 =?utf-8?B?RFE2MkZMM0EwZzdxZTNZZmUwK3h5cXNrMnNiZTlMaG1PWGhVSDNUNER5NFV3?=
 =?utf-8?B?enVsQUo0djBINFJ6N1FZWW0rZVM5bXorUkxmWDY2OFVxRkVoQlNSWnpoSnVE?=
 =?utf-8?B?SFlUTmRVbXRqc2Rvd2VHUllsdTIvaFA3cUVYTVRiQkllU25NTFowSlM2aGEy?=
 =?utf-8?B?c2ZUM1Y2bWlPQ2hmNUtrQVBXaUw0b3I5MEFzSEpqbGdDV1pGTmtTaDBNaGp1?=
 =?utf-8?B?QmVGSUd3NWJFaG0wVngvQzJKR3l0S0R6QmQvUnlzQTFXUzlvZFlXUm1iVFVl?=
 =?utf-8?B?ZThnNkZwL09IL2YvTUgxVWQ5TEZxUUYrZnN4WlR1QWlsZjAxdXhnZDdxYlZS?=
 =?utf-8?B?SzBPSmZwQnp2T21heUU0SE9JOVg0V28rMVBjR0puWUJCRVE2djlzTmlJTzli?=
 =?utf-8?B?YXRtZE1SV1N2TFZRcEd3aVlMSkhwMjFNc1lBQVB4em56L01uOC9wcG5TM2Fu?=
 =?utf-8?B?WTNHS3NBdURIMnhMMFpBV1lPVXR3ZzB5NG5tVmo1Rm5pRFI4bVh0NHF2RG04?=
 =?utf-8?B?QldsQzV1MWVJM0VsT3E2TWZOZUxuYW5SNlgycWdheHhxZ1Mvd1AxelZKdmkw?=
 =?utf-8?B?UHM3MHBlN2tlOGNjYU9LT0FiMUxxRWZGMERCTDNCcmw3ZHpMaTdkTGxxclhT?=
 =?utf-8?B?YWtIZUprTmJCaHRmSEFVRWI5SFl2M3ozSlU4bWk3V2xXWG5MUlJEcFN0OHJp?=
 =?utf-8?B?S0pUdXVwRzU1RS9GYkR1RDlwcU81MHNqeWZRQ3VDVmR3eXBOdnRReThENGVt?=
 =?utf-8?B?c3RkbFdiWFlUdk8ydHN6ZXpwM3JSSCtxTTVUdERMS3hIK1UvTGFRUWMweTZL?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10AD9A18FD8E984A953A585855A3F02E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 551469db-26c7-4310-caa0-08dcd3c31841
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 07:10:05.8733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PS2lsg5VSLG0HiM9fhwLQwkt0QXAGeqOO0R3RLpChqg+5/RYcauqthYj/2aE6/DMprG87x3W6avfZIJI2XPPRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6616
X-MTK: N

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDE0OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xMi8yNCA2OjMxIEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IGluIFNEQiBtb2RlOg0KPiA+IHVmc2hjZF91dHJsX2NsZWFyIHNldCBV
VFJMQywgTWVkaWF0ZWsgaG9zdCBjb250cm9sbGVyDQo+ID4gKG1heSBub3QgYWxsIGhvc3QgY29u
dHJvbGxlcikgd2lsbCBwb3N0IHJlc3BvbnNlIHdpdGggT0NTIEFCT1JURUQuDQo+ID4gDQo+ID4g
SW4gYm90aCBjYXNlcywgd2UgaGF2ZSBhbiBpbnRlcnJ1cHQgc2VudCB0byB0aGUgaG9zdCwgYW5k
IHRoZXJlDQo+ID4gbWF5IGJlIGEgcmFjZSBjb25kaXRpb24gYmVmb3JlIHdlIHNldCB0aGlzIGZs
YWcgZm9yIHJlcXVldWUuDQo+ID4gU28gSSBuZWVkIHRvIHNldCB0aGlzIGZsYWcgYmVmb3JlIHVm
c2hjZF9jbGVhcl9jbWQuDQo+IA0KPiBJZiBhIGNvbXBsZXRpb24gaW50ZXJydXB0IGlzIHNlbnQg
dG8gdGhlIGhvc3QgaWYgYSBjb21tYW5kIGhhcyBiZWVuDQo+IGNsZWFyZWQgaW4gU0RCIG1vZGUg
KEkgZG91YnQgdGhpcyBpcyB3aGF0IGhhcHBlbnMpLCBJIHRoaW5rIHRoYXQncyBhDQo+IHNldmVy
ZSBjb250cm9sbGVyIGJ1Zy4gQSBVRlNIQ0kgY29udHJvbGxlciBpcyBub3QgYWxsb3dlZCB0byBz
ZW5kIGENCj4gY29tcGxldGlvbiBpbnRlcnJ1cHQgdG8gdGhlIGhvc3QgaWYgYSBjb21tYW5kIGlz
IGNsZWFyZWQgYnkgd3JpdGluZw0KPiBpbnRvDQo+IHRoZSBVVFJMQ0xSIHJlZ2lzdGVyLg0KPiAN
Cj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KQmVjYXVzZSB0aGUgTWVkaWFU
ZWsgVUZTIGNvbnRyb2xsZXIgdXNlcyBVVFJMQ0xSIHRvIGNsZWFyIA0KY29tbWFuZHMgYW5kIGZp
bGxzIE9DUyB3aXRoIEFCT1JURUQuIA0KDQpSZWdhcmRpbmcgdGhlIHNwZWNpZmljYXRpb24gb2Yg
VVRSQ1M6DQpUaGlzIGJpdCBpcyBzZXQgdG8gJzEnIGJ5IHRoZSBob3N0IGNvbnRyb2xsZXIgdXBv
biBvbmUgb2YgdGhlDQpmb2xsb3dpbmc6DQoJT3ZlcmFsbCBjb21tYW5kIFN0YXR1cyAoT0NTKSBv
ZiB0aGUgY29tcGxldGVkIGNvbW1hbmQgaXMgbm90IA0KCWVxdWFsIHRvICdTVUNDRVNTJyBldmVu
IGlmIGl0cyBVVFJEIEludGVycnVwdCBiaXQgc2V0IHRvICcwJw0KDQpTbywgTWVkaWFUZWsgaG9z
dCBjb250cm9sbGVyIHdpbGwgc2VuZCBpbnRlcnJ1cHQgaW4gdGhpcyBjYXNlLg0KDQpUaGFua3Mu
DQpQZXRlcg0K
