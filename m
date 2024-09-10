Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7401531C0;
	Tue, 10 Sep 2024 05:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725946852; cv=fail; b=AdeQNvPP9mBy4Cn0SizrqvpfynzKe/kFBD81SSb6AuivXZCxwKqCdG2itl5Hhm8joWejLvjxZKFNwiVijUHKymTGmJXAbJU7Wo6M+EhM6c628E0TtuXwQTkmIsHFlkX4JzHyc+J1QfTqg/ESlAit5OlSsy/0M1F94NAOr32C6PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725946852; c=relaxed/simple;
	bh=Pru7kAHTQlX/CBqU6OX1Ubs/QROR2aOpWi9VhTiPhZY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PN//LQ78w7qjo39jdIiJlhqDRFnmSOdWAgqafAYkIGF7Y+++lUotyYddWESJ4fq5f4PmFgEkFBcCcQ/oZxkktT9b6da29Bz/r396XbHSjYpmYpwiAxG8+hZQGn2GHZtckGDyRWtlvuNXPvwJl1snF+3ohRnuW6WPWihfzICawf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Z8lS/+xV; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=MDWneh/i; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Z8lS/+xV";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="MDWneh/i"
X-UUID: 35b9d4866f3711efb66947d174671e26-20240910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Pru7kAHTQlX/CBqU6OX1Ubs/QROR2aOpWi9VhTiPhZY=;
	b=Z8lS/+xV8PZSgqmvihUl9YK8uNm5J56QWfJtxOdQOjQyeWk4ycP7BpBVBJCSftZJ33ja+D7Fzrpeuwfl62D0BaoDTnwkSj4e6IJayZTFucTefC9P6G22QoRvqG5WpBn4V0cy+6Ea2LfQSsK4jXrS0+Cqppa/PF3GdUG09S7GSBE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:d1f3872e-c99c-4b88-955e-041c55cc0c24,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:700fb8bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 35b9d4866f3711efb66947d174671e26-20240910
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 141467922; Tue, 10 Sep 2024 13:40:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 10 Sep 2024 13:40:37 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 10 Sep 2024 13:40:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=py4lNG3aXjWXzQ6NXJ+kmskykhdQjj00+IxBNTTVwXl2cnqNttILZyIKeyPskMdM05eWExnoCPA8ImgD1WhTxRwjtU3C0NoKarjnPm0Hnkg3e3ZXhohl/w6mHIzVWvoEdZcRMTjH6MgJ5G6Qbp/DXfw3eBuEsU1odIq5DeSeDf4xOfgxYXy4Xd2DkMKdsBSUQsyIlOcHIzYQ2Y80NMhdZUYp+CJVTXqpPossgoNsTPUks1LzUYCMeiQL6912KUyvi9cTdGqVgNvBmLzjzedKyzAo2U8FHfEIMXPGU0BfMMLj+eL6t9oXJHDVpnrnelWXGSl5Zyb6LixaAaSZKCNcag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pru7kAHTQlX/CBqU6OX1Ubs/QROR2aOpWi9VhTiPhZY=;
 b=xTtilMWLV2fx5QBKzng8bJJ5z1fQKVvRguyTVxRtMUCWLGl0Pn/84PNDi3xpJGVQeWn4QwQABGnXKql8xc/Qi+na+WXyFBMtEw2PDlaqIVnSQwCxvHQlarLmAVDzOn4txfHzYlsS2Qap/UBNyLvdtzR3wftB4nzslQvu9t6gBgDP9u1XFE7Gr2kBBnYhj4JkszoG2m49ld5UGMObQOu8lYPdOM0PQIh3HIhXea1c7LMuZ2cd/VpjqadhBedvEF1QLSu80cwPaovcQv3QNuHKao+HRE00F1wXRCTgQ7wUAaoOesOA+kpAWEqJ+LBg34tDf7l90o8bVqAVDKNIHfmWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pru7kAHTQlX/CBqU6OX1Ubs/QROR2aOpWi9VhTiPhZY=;
 b=MDWneh/iI28yAoKr0r5TNO61QvVoADOQkwodsRDfgCjF1WydlguvxyJaMBGDKP6IdRgQaCjRibmtNv2JBhzfjudVIWmMy1rfdb2YBWBMFBiXC9hh2ZVYeelRB/SLpD9TK5TI3bHKSySc/c/uCRpIFhovRI3VvU65GOjhk55olvQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7037.apcprd03.prod.outlook.com (2603:1096:820:da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Tue, 10 Sep
 2024 05:40:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 05:40:35 +0000
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
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v3 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v3 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbApFPUl786o1LT0mMnOkb43t8YrJPp0EAgADbhIA=
Date: Tue, 10 Sep 2024 05:40:34 +0000
Message-ID: <2c93526e74cca5ac7ee6d952a80051733ea37c2c.camel@mediatek.com>
References: <20240909082100.24019-1-peter.wang@mediatek.com>
	 <20240909082100.24019-3-peter.wang@mediatek.com>
	 <c4d22b9c-2554-4871-94dc-3dae4bd62a5a@acm.org>
In-Reply-To: <c4d22b9c-2554-4871-94dc-3dae4bd62a5a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7037:EE_
x-ms-office365-filtering-correlation-id: 4dc96b58-d429-41e2-a3b9-08dcd15b17b5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RjJpT1doQ3FuMUVBNys0UW03K1owdHpsRFBhb21jR0J5dUgzYVVqbUJKM3h5?=
 =?utf-8?B?MFdsQTZQL1R0V2xXbjc5ZDBXbnQ1SlFpTEVYMTkvQ044OWdoUWcwQVBPdjJB?=
 =?utf-8?B?RytJeEthMTM2U3FoT3pSYkswd2xPK2Q2L2JIREhReXAzTldZbW5MWENPMjZq?=
 =?utf-8?B?VGRZUzBhUzkxUDFGd0d6RjJTbzZWZUJXNmRYYkNXMzJ1MExFYkVWWlFxOUcv?=
 =?utf-8?B?TlRnREdlOW9mMW5uRm9LK3RIWUFnaHlQTVNLRzlxaGRpK3htalB1cXRNRnhG?=
 =?utf-8?B?RWlGcFREYUVUcHFjMFpBRFJoZWpHZ0tHTHZlUlhKQVZEK2RIUi9uOFNDZWt4?=
 =?utf-8?B?M1o0ZHNLVC96NHhRK1NEemZ5Unk4UW9mWC9xeFloampDaSt2Z3pyWlloM0lT?=
 =?utf-8?B?VGduWUtJTzNXWG9mbGp6MGpRVUVWU1hTYXRONFdJZ2R6a1BmZkV6U21EbDkv?=
 =?utf-8?B?YVhCb0FyeUhBMExvUEEyVnBtU1ZiV21hNUFYSnBpK0VreVhra0JUWm1kRTZ2?=
 =?utf-8?B?K3phMWFVUmZYN2VhQkNqKzM0SDQxbzRmUThPVnlFWWNhYTFiZ2E2ZW42SHgx?=
 =?utf-8?B?R3hXek1xbmQ2Z2E1aVYwSmI0VHVSRGY5NmtGUFZ1RERLRjNPSXdsZjZmSFNi?=
 =?utf-8?B?OW9BVmVtR1h0c0dWV0pZdnFPNXlZbHByYVc2bllrWFBQUGl3NHhIb3hYejVo?=
 =?utf-8?B?N2d0bDhIQ0pkZFk0SHBoQnE3c2dlVUhHbzlMYXhnQ0lHbkdxVXpJbWJFM0N4?=
 =?utf-8?B?QWYzVmlFTmhoSlU3aGswRm44RDgycnlJVkh1cEFYbFFIdi9ya2c0WlZkTFNW?=
 =?utf-8?B?em5BWUlsSEpQYjRyT1JTMFdjcUdoZG1hR24xS21DRTc3aFBYc3NRLzg3RlhX?=
 =?utf-8?B?d1NlNUdVTGtJMGprL001dzRzWkhCWit2SHBtRGd1ZEJ1Qm53M284OGVNc1lS?=
 =?utf-8?B?Vzd4MmhSRFVpdFR1WTFidFhPT1FxZmVTYUYzejZIektyV085WkVmeE44V1pE?=
 =?utf-8?B?Y09sTDhBOUk2UFVmaU5wZ0JwelFXeVo3UkR6c0ZueGJoNXcyMS9ZRmtqeEc1?=
 =?utf-8?B?Zzc5YlZ3R2Qzdno1cGZsYVpXMldrWGYvekZ6bTZsSEdWM0k0YVljaHNtd3d0?=
 =?utf-8?B?V0FzT3BiVUZQN3JNcWM1TmdJVzEyaXpvQUlGY0Z2bGFiSzhnbThmVGNWajlW?=
 =?utf-8?B?SWJPZjd2d3hnVkphQXp1aWxKelBJZEhMcHRrekNvMTlveDY5SUxTNHUrdjJI?=
 =?utf-8?B?Wm9SYVZ3TzdnUWdsTWtrcVR2QzVodERsZkpxZ20rdkMzUElkVkxrKzNRYWhv?=
 =?utf-8?B?T3I1cnFtWXRXeUFxUndHdk50YkxlYjRQTExBM2o5MWJYaDMxUDkzcHNrYXVR?=
 =?utf-8?B?ZGdaN3pIa1VKV2JkQ01WcmZTMGdMWjRvWmpSbFFOVEduNHR5SGpibkpUOUlR?=
 =?utf-8?B?UzJCN0xEL2hrRjduN2NkMU1PVDFGd3R2RHByRDRXTlprS0ZyYVpwbCtiZE1o?=
 =?utf-8?B?UjhoRUhIanU3TGZTcVhENHdIaGZiS1RtVTFFQ0l2VEFLRklpZHZhTTU5V2hS?=
 =?utf-8?B?WGova0dDRzlQVnEweFdyZUZvOTFydDBqUGRuaWFaNVcvbURSUU1vc2w2d21a?=
 =?utf-8?B?bEFGS0RIdE1LdHlCOWlnY056SElKY2RpTHFwQUMvakg0TFdjTU9YUkxpcEdm?=
 =?utf-8?B?cytpRmc0N3pLMEdxbmNueDBaeE5QcWo2eGFhM3RRZnRWOE1EV016UjZnNzF5?=
 =?utf-8?B?K1hBbStkUUkvMXV4QkcwdW5jZnJoRkZJMkYrNExRcnphRWdxTmVJNzU2OG51?=
 =?utf-8?B?Um11T1Q4N09HYkl1TXJTTGlYdWhWc2tlUERYZ1h1NTRMVXdyUUkvWFgxbjNN?=
 =?utf-8?B?eVBxdUpZdmI3ZXVLTFRHbGdmSlBwSXMvRDNyZHlGMFdLenc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWJmRUpTZTJsNUlWdEd1L0k4YU9PMVY4VnpCeE94UUxJdDdWS1FWZURYR216?=
 =?utf-8?B?UGZxeS9jT1RvM1hqQkZ2U1MwMDlEejZnVUdhSlY4enNYcjk1T2VZOWdadnFy?=
 =?utf-8?B?N0lDTmdSaExoVHBKd3hIV1Q3THRnRWpuQ1lqb0hZSGJwUzFZbEpFQnRqeWJo?=
 =?utf-8?B?ZyszN0VOYjJiaWI3bTBKZ01aRXB2VHI2dkNWL3FGcUxyMkRsWUl6VWh2ZUpD?=
 =?utf-8?B?bk9CSDEyS0NZWnpkd2FYQ3VyeFZxRHZzSWZHTWJGZERlUVRNb3lxdWJHdkJr?=
 =?utf-8?B?QXU3NDdMMkVnRHcvR0Q4NXhZS0NNbWhpN2lWVDh3VC9lM1JqbnRtWDZDVVpy?=
 =?utf-8?B?UnF4bWpyNC9abmZkQm9TbFNNNDk0UlVySFBXTDZML3FyQXBUMG5YSUYyaWVu?=
 =?utf-8?B?cUZzZVlqOXY4R3JjL2U2cm0wdUxFY3FCOTRkTDk0U2YvLzRmUzIyVXVGeExr?=
 =?utf-8?B?REJwMVg4UUNRMG5DVElpcGRFUnNaR1ZrWmxpRE93dWRncEEwVWRZdHhXMnhM?=
 =?utf-8?B?WXpjTW9UWldoaTdwWWRWb3J5dHdySEZpQUJGN2JKQytMcis2YXRSZlpIbFZi?=
 =?utf-8?B?OGRLckVXdXkxR0FCS3ZUY2JQTnZUV0owd1RjVkZRUTcramtlRVNxTloxK3g5?=
 =?utf-8?B?OC9McEd4c1FRTVBUdWd2cWNRcjRtRldCb0VMQzRleFg0eklmTmFjeXdHeE9P?=
 =?utf-8?B?UFUwWVpDTXVtOFh3bVJxdktoalVYaTJ6YlFWeE1HWXMrSjhyNlFjUUdHbUNn?=
 =?utf-8?B?SGFYWGlSTWlWVkExZFkxVFF5cTJic0NTbHBUWmRPZDQyZzh2a2JSZVhNSEt3?=
 =?utf-8?B?WmYvOEx5U21EWXcvYXF3RUxoMGlqdUp3bE9UelFqN3E5NWErUGdnMTJjN1ZC?=
 =?utf-8?B?bGpIbkN2WUpsNjNjdWh6eXBhdm9BWWQwUXcwNzJ0aHAwMjlvYktsQjd1aEpm?=
 =?utf-8?B?UHpSUzJNM3dvVkJacUZLZFhzeDgxU2hoNGN5b21NZUd5UmJzdVFXazErZExN?=
 =?utf-8?B?cmRUNnBjakJvQmJQYWUwMHEwMzBIYzhkOGMxd3gyYUU2akxyRVpmc2JlOGhT?=
 =?utf-8?B?RzNpL1JMbFgxcHdVWDdZV01UTFF3WU1td3JqYzZXb0ZqaFhBUkRYbi9ySE02?=
 =?utf-8?B?RzZpZlVQRU82VVpweGNwNmIzT1ZtcG5LN0E4bURaRzlDbS91VFZDZEI5VzR3?=
 =?utf-8?B?dUJReVhlN3F1T3lpNy94Qmd6OHRnNkFVelZrODNyRlhTL2pKTDVjNVVSZnBI?=
 =?utf-8?B?UlU3cTk5RmV6OXpTQkVKc3pibExQbkphNjdVb3B0VXRrdzNSblF1Rkc4Z0F5?=
 =?utf-8?B?Z0dHU3RBcUdvdk9pYTdaV1c1ZFlxRlh4bE1BL2pwTFNSWW5LdisrOVBFbXhW?=
 =?utf-8?B?ZU9GRjlnQTcwVFlLWWV2TnZtam9GZVZDeUpDd3dzN0VPUWdrZUcxcmk5QXEw?=
 =?utf-8?B?MVI0dnR0UmM1Ny91ZlFwbVRLV041SmNadS9nTjlmR2cwc3d6Z3Nhc2wxMGJU?=
 =?utf-8?B?UXl4V0tvc29DSnFtUzIvSHZ6ZHJMOHRjU3gvNTFkTGZuUTMveWZFcE9lcG9C?=
 =?utf-8?B?V09KOVJtT0tvaVJhWU54YVdZRFJvemJPQXFRc2xiYW95NnpJcXRSZ1dzL0Vj?=
 =?utf-8?B?WlE0Si90anBwZjdwNkhCV3J3aTBEbW1nZHJIWFg3S0tJbGdobmFCWVA4aklU?=
 =?utf-8?B?MjFxdVQ3UmNBRnZtWHo0Mng0NjVkaVlpZ2E3NWV4WkllZURmaC9PaEIvZHpw?=
 =?utf-8?B?NElZRWQ1bHdlZkovaTdJNTBNdnBxWjJrSUNpZDBQNHpScW91QXl1VGVaYk9v?=
 =?utf-8?B?eGh3aXEybjRnUWRhZkxJazVDTlpsbnpRUWJHME5iSHlTR0IyVHNaUXl5a1Yw?=
 =?utf-8?B?L2h0dGwwL3pxbGF3ajRjWmFpZkpsVXJML3lGaEZkellQalVsWFRBY2dmdVE3?=
 =?utf-8?B?RGcxR2txMjB3TFFSamoxMWlsV1RXNjBmQ2VMb0p4S1JqSlJIL2NKeXFCamZx?=
 =?utf-8?B?Q0VMTkZqTGFOSTVqVDM3T0VhNWxtNGQwNGFJNjJFU1B0TW4yaW53bFRBVjRp?=
 =?utf-8?B?c1F0aVdtRFk0Ti9WbmVrVlFTTVh2NzViT3c2Qm1mTzFqeXJTanZBSnV2ejQ3?=
 =?utf-8?B?OTZlZUxRWU1odGUzR0J5eEFGQTFIcVA3VjdRZ0tiaHh5Tm12RjQ3Y2ZDdUxy?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FD469C12901064DB62943060890E1FE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc96b58-d429-41e2-a3b9-08dcd15b17b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 05:40:34.9184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: alfok59IxxQo8oQmLNzPEk1HduHwdPF3Dq6X2LwPjIKv5Y0cFGxRZWP3T8zBbofRZOWIFrA3ffclYp97J/xN0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7037
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--31.413700-8.000000
X-TMASE-MatchedRID: cnNFLnOjrwrUL3YCMmnG4t7SWiiWSV/1bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CzOo//J/EA1QauZoybwHAwkzvR
	QSqpv1wVOFu8ssjxG85/4EzkSEHbPKYkG37rHS8XAJnGRMfFxyX4rryovYbmmymP/1piI/6Hz0Q
	r7GJy0y/zapuMg7DQgwBcnC/GJrtacl7+trwU+WKtWSWds/km2hEIiqNvBrmNQ+OxFt/19oRMGt
	PkUyFbdK/hZaW+O9Z9ICsMQxCDS2EHWbmeNr66Rk3rl+MaNgxCBHKTJ+sfXGaxp9wUsWVTUZ10w
	KXUWXnItlP65WKSrb3F03j9r9uDDSe3iZ10QiJNsG7r4Qh7N3DY7kSH7jlNHEYcWuAHCdKujxYy
	RBa/qJRVHsNBZf9aRAYt5KiTiutkLbigRnpKlKT4yqD4LKu3A
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--31.413700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	DE07647886CBE09AADC9B585C27FF281287F850C23177FDEE7754619753E67E62000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDA5OjM0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS85LzI0IDE6MjEgQU0sIHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tIHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzLQ0KPiBtY3EuYw0KPiA+IGluZGV4IDM5MDM5NDdkYmVkMS4u
MWY1N2ViZjI0YTM5IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5j
DQo+ID4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gPiBAQCAtNjQyLDYgKzY0
Miw3IEBAIHN0YXRpYyBib29sIHVmc2hjZF9tY3Ffc3FlX3NlYXJjaChzdHJ1Y3QNCj4gdWZzX2hi
YSAqaGJhLA0KPiA+ICAgbWF0Y2ggPSBsZTY0X3RvX2NwdSh1dHJkLT5jb21tYW5kX2Rlc2NfYmFz
ZV9hZGRyKSAmIENRRV9VQ0RfQkE7DQo+ID4gICBpZiAoYWRkciA9PSBtYXRjaCkgew0KPiA+ICAg
dWZzaGNkX21jcV9udWxsaWZ5X3NxZSh1dHJkKTsNCj4gPiArbHJicC0+YWJvcnRfaW5pdGlhdGVk
X2J5X2VyciA9IHRydWU7DQo+ID4gICByZXQgPSB0cnVlOw0KPiA+ICAgZ290byBvdXQ7DQo+ID4g
ICB9DQo+IA0KPiBBcyBtZW50aW9uZWQgYmVmb3JlLCBJIHRoaW5rIHRoYXQgdGhpcyBjaGFuZ2Ug
aXMgd3JvbmcuIFNldHRpbmcNCj4gbHJicC0+YWJvcnRfaW5pdGlhdGVkX2J5X2VyciBhZmZlY3Rz
IHRoZSB2YWx1ZSBvZiBzY3NpX2NtbmQ6OnJlc3VsdC4NCj4gVGhpcyBtZW1iZXIgdmFyaWFibGUg
aXMgaWdub3JlZCBmb3IgYWJvcnRlZCBjb21tYW5kcy4gQWx0aG91Z2ggdGhlDQo+IGFib3ZlIGNo
YW5nZSBkb2VzIG5vdCBhZmZlY3QgdGhlIFNDU0kgZXJyb3IgaGFuZGxlciwgSSB0aGluayBpdA0K
PiBzaG91bGQNCj4gYmUgbGVmdCBvdXQgYmVjYXVzZSBpdCB3aWxsIGNvbmZ1c2UgYW55b25lIHdo
byByZWFkcyB0aGUgVUZTIGRyaXZlcg0KPiBjb2RlDQo+IGFuZCB3aG8gaGFzIG5vdCBmb2xsb3dl
ZCB0aGlzIGRpc2N1c3Npb24uDQo+IA0KDQpIaSBCYXJ0LA0KDQpTaW5jZSB0aGlzIGlzIHVubGlr
ZWx5IHRvIGhhcHBlbiBhbmQgdGhlIGNvZGUgaXMgbm90IGV4cGVjdGVkIA0KdG8gcmVhY2ggaGVy
ZSwgSSB0aGluayBpdCdzIGJldHRlciB0byB3YWl0IGFuZCBzZWUgaWYgaXQgb2NjdXJzLg0KQW5k
IG9wZW4gYSBkaXNjdXNzaW9uIG9uIGhvdyB0byBkZWFsIHdpdGggdGhpcyBjYXNlIGlmIG9jY3Vy
cy4NCkkgd2lsbCByZW1vdmUgaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KDQo+ID4gQEAgLTc1
NjEsNiArNzU1MiwxNiBAQCBpbnQgdWZzaGNkX3RyeV90b19hYm9ydF90YXNrKHN0cnVjdCB1ZnNf
aGJhDQo+ICpoYmEsIGludCB0YWcpDQo+ID4gICBnb3RvIG91dDsNCj4gPiAgIH0NCj4gPiAgIA0K
PiA+ICsvKg0KPiA+ICsgKiBXaGVuIHRoZSBob3N0IHNvZnR3YXJlIHJlY2VpdmVzIGEgIkZVTkNU
SU9OIENPTVBMRVRFIiwgc2V0IGZsYWcNCj4gPiArICogdG8gcmVxdWV1ZSBjb21tYW5kIGFmdGVy
IHJlY2VpdmUgcmVzcG9uc2Ugd2l0aCBPQ1NfQUJPUlRFRA0KPiA+ICsgKiBTREIgbW9kZTogVVRS
TENMUiBUYXNrIE1hbmFnZW1lbnQgcmVzcG9uc2Ugd2hpY2ggbWVhbnMgYQ0KPiBUcmFuc2Zlcg0K
PiA+ICsgKiAgICAgICAgICAgUmVxdWVzdCB3YXMgYWJvcnRlZC4NCj4gPiArICogTUNRIG1vZGU6
IEhvc3Qgd2lsbCBwb3N0IHRvIENRIHdpdGggT0NTX0FCT1JURUQgYWZ0ZXIgU1ENCj4gY2xlYW51
cA0KPiA+ICsgKi8NCj4gPiAraWYgKCFlcnIpDQo+ID4gK2xyYnAtPmFib3J0X2luaXRpYXRlZF9i
eV9lcnIgPSB0cnVlOw0KPiANCj4gUGxlYXNlIGFkZCBhIGNvbW1lbnQgdGhhdCBleHBsYWlucyB0
aGF0IHRoZSBwdXJwb3NlIG9mIHRoaXMgY29kZSBpcw0KPiB0byANCj4gcmVxdWV1ZSBjb21tYW5k
cyBhYm9ydGVkIGJ5IHVmc2hjZF9hYm9ydF9hbGwoKS4NCj4gDQoNCk9rYXksIEkgd2lsbCBhZGQg
bW9yZSBjb21tZW50Lg0KDQo+ID4gKyAqIEBhYm9ydF9pbml0aWF0ZWRfYnlfZXJyOiBhYm9ydCBp
bml0aWF0ZWQgYnkgZXJyb3INCj4gDQo+IFRoZSBtZW1iZXIgdmFyaWFibGUgbmFtZSBhbmQgYWxz
byB0aGUgZXhwbGFuYXRpb24gb2YgdGhpcyBtZW1iZXINCj4gdmFyaWFibGUgYXJlIGluY29tcHJl
aGVuc2libGUgdG8gbWUuDQo+IA0KDQpJIHdpbGwgYWRkIG1vcmUgZmxhZyBkZXNjcmlwdGlvbiB0
b28uDQoNClRoYW5rcy4NClBldGVyDQoNCg0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
