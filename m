Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA3BA42;
	Mon,  9 Sep 2024 03:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725853120; cv=fail; b=fe+9v0cONcnJaLBIvQ21OsAs5ExdTXx3UtBT0Iw7tarhcHrYCkR/iDQ1NYByKdcSpWdJ+SyEcgdSv8FdlFaOR2Ys5ptHycPUI/YrwT8mO2RlAPAha2+atyGlsp49unzQYhV4FNNT4360EQ3MotjUDe6yRBHYDjMnN1Rdi0OvJYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725853120; c=relaxed/simple;
	bh=T6i0em5ACB/t9mOKrKnTjzjdt91zeYC1mZwYt+GeMrk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lMrtqDb8VxMDxoYb4xwn2KVMx7tn9OjGKNE91hFOul7RPh7aEf7UE5M+bFdCVn2+uAr/pDUrk5esHUd+4szyjM2Hiq+2lcF5hUX/AaclOATz0Yici3ItYjOATQ5VxM6+NZhbk0dToMnwev0ibQy70TqR/Q5Rep1ZRT/vqA9YSy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=B2LV8h//; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ufP7yYZB; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="B2LV8h//";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ufP7yYZB"
X-UUID: f8ba06946e5c11ef8b96093e013ec31c-20240909
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=T6i0em5ACB/t9mOKrKnTjzjdt91zeYC1mZwYt+GeMrk=;
	b=B2LV8h//h7XwENdPDUAjHHnbW81nOwENuUO9NfYts/Y7loY0TIgnWEvYZK+2oaiUfzXP1qhNA6DaN1S0n7Uy17pRwO4+Qh151wdiEq5MFxwIjTUpUCha8d5fBYr4iv0CHUXLr7Cx13WqybgMlYSlJMRW50ZI7Pd8kfFHkLxXgNw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:c66b990d-5428-4bf1-af9b-dbf91e081d67,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:34f8e4cf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: f8ba06946e5c11ef8b96093e013ec31c-20240909
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 926663196; Mon, 09 Sep 2024 11:38:26 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 9 Sep 2024 11:38:24 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 9 Sep 2024 11:38:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NgP/iZF4T1uP84p6YBAJ1/JAeLTap0HIx+RQ99FU9w1Ia1aMqeD41oP9LPOiKpSIbO3YcwT3o2GCx1WKQjB7w4G5WTcKo+aPu9cNaamLwJ4EdcxWW/FUOn33YY8JskKUa8y87lw3PRqJvcvVDvvaYggM5aN82gXDp1WMSg3+06e++HYEERitPOEmz5/Am9fRvYpjbop9IjG1tO57ye/lBn9RTrZ1c3MQiNonDnQpF5gFloVu9DrD6DOH8EWC3n6Pyzc2Asih951PRCFb1xky2hjSesolU7zfYWZNug+1nzEjO4fhJx7WoeancJVd0PseSvX4RS8J9pwiXsxFQ43Ltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6i0em5ACB/t9mOKrKnTjzjdt91zeYC1mZwYt+GeMrk=;
 b=AIFp4jU/148FdoovyH/oZolwR1hj1PjRlupryHQCv90B3ahoaAaBXQF+3ayOaj6blPs+1+6jRKUp6KojVcViLmgnMHh6ZCkroH4DyDddRk3/4PcnHX6BCt0m+SJ0PS4vmKRNkPfgbUBtV4X6o09Wmcz9cqKmqNqnep9ZhMeCq9h+CpQ+w88nm+wsIru70hzDwKU98xVNqpt9Asrl8ZVxkrOC8+znB2VDAht6rhehW3jEzbqwZLPSowD1qIOIiCb617JOqi68G3+iDDSQGk+Z/RaFVZ065ZtJr0UytTBE97ojp8JSj8ZuqF+nXPICTuTwKT8h8PtLIvGh/WXvJOuC/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6i0em5ACB/t9mOKrKnTjzjdt91zeYC1mZwYt+GeMrk=;
 b=ufP7yYZBimfs8rN8BhfEnbtpIX9Fw92JAG0pWfi/24YQbQIn0damJYN9o/XW6TeUMKX8/3JnSQLFxuggjzr/b2ObHnTkGj38JOLJavlNlIesNuQ0M+UjiB0jjJnbGxNy54bQY8RkH86F4HICmgxCY8XeP4m0S6EBJsFO7ha6QAM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8504.apcprd03.prod.outlook.com (2603:1096:604:27a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Mon, 9 Sep
 2024 03:38:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Mon, 9 Sep 2024
 03:38:22 +0000
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
Subject: Re: [PATCH v2 1/2] ufs: core: fix the issue of ICU failure
Thread-Topic: [PATCH v2 1/2] ufs: core: fix the issue of ICU failure
Thread-Index: AQHa/N6PJ26RZpB7TE++KXC82NWtMLJJtUWAgAUkbIA=
Date: Mon, 9 Sep 2024 03:38:22 +0000
Message-ID: <6fcf127810308a6a696d54312f35310a3a125eb9.camel@mediatek.com>
References: <20240902021805.1125-1-peter.wang@mediatek.com>
	 <20240902021805.1125-2-peter.wang@mediatek.com>
	 <f5274603-3687-4386-b785-129183d84f4c@acm.org>
In-Reply-To: <f5274603-3687-4386-b785-129183d84f4c@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8504:EE_
x-ms-office365-filtering-correlation-id: 9bc5397a-a268-46bb-2bb6-08dcd080daae
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UXNVNmFJWmp5ZUdmMkRjTUFHa2dsZmV3aUdDR0s3SkR2WFdQbjcyQmM0djlC?=
 =?utf-8?B?eWFvbXRhM1hPUnVSUHlwVHF5UC8zci9KYlNxVURsN0F4UXRsQXpjaWF6Ykk3?=
 =?utf-8?B?WHhzQWFsVW8vMzNDQ1BXMzIvTWtOUGNTVXpSQVhCT1Z2VUY3VnQ4ODg3Y0hC?=
 =?utf-8?B?TzJrcWtNam16WFZTZDNaN3hrRGxUZXN3QTNMUFpQZWlpaWdGVVRCSVN3bGhU?=
 =?utf-8?B?U0hKNWdZck1yRTJTYzh5QWprUGRBVzNiMko5ZkFLUnFieXhxYWZwYVNBWkJn?=
 =?utf-8?B?UTRJYno1QzZkMVc4SjdoMWtqYWxkVDBwL2pCREM5dWtLOVRNUWQzdmxNQ08y?=
 =?utf-8?B?YTF3YXhOUHVnNEJlTVFoODBqNkM0VmJiSkVZVmJua2pOYXAzSVdoVDJ0dHNj?=
 =?utf-8?B?bEs3TFVxSklFU2JZQlZXVERHNlR2eVBySW1DRkx0YVlxSlR3d1RzS0F6OW9m?=
 =?utf-8?B?MXNRZ1hFUWppV24vdWxhZFJlOUd3Zm1GY25qSUxnSzZ6aWtOcTRma2l0cVRw?=
 =?utf-8?B?UTJNbk1Gb0pZbDRxVnJUR3habGFjeDl2bVl4aDJaU25yUFpSUk15Q2RpLzMy?=
 =?utf-8?B?elpSMTd4VlJIME9jWXoydkg1Z0U2L3JzbVhxcURGM2JReDJhRlFNdVJRSFpr?=
 =?utf-8?B?Z21VcDRNZWdQRFMxUVR6WUdsbmNwV1VzY0VFek4rakFLT2RlK05zSkllb3py?=
 =?utf-8?B?ais2WlQrd3UvZ1J0UjZ2SGRsU29MQTl6eU0zWFNoTFB6MGhJYWNuZHFaRUpl?=
 =?utf-8?B?NDliYXpvM3VRd3hoZVBvMVFoYWxsVGNXcEdBV1JJZ05vNWJFR2dMQnM0YkhC?=
 =?utf-8?B?eEdLbGJXS0o1YVYxMEhHb2Urekg3Sko3YWFMY2xvZkM3cjdvdjJTTTk1bEZH?=
 =?utf-8?B?N011eWF5dExGVmRZcFhyZUxiWHRYNG1kVkNnWlE2NTBzSWNXTUt2S3FNUjRi?=
 =?utf-8?B?Z0pUQ1ppbHltRjY2OWYra1FKd3ZheEVOL2c4c2VTb2JIWTE0YjlWdjZHcmpQ?=
 =?utf-8?B?MWRid3RYWThOc2hERG1GQlowZnpEV08xSWZSM3ZtR3N3MEQ2clJzcTF6L0RK?=
 =?utf-8?B?b2h5SGJWaFNndE16aWUzR2NqVHNFcnVzQ0NNeUY4aE94ZFZIbDJ4N2diTG1n?=
 =?utf-8?B?R1pPV3JiWGpFODdiVzM3blk1ZVBPcVFXTUs3QTJLQlFsL2grV1ZBbnhPeG05?=
 =?utf-8?B?YURQU1VYM2p4NTB5RDR2UXVzNFFsMkRzTDdERTRYQzZIVWp6Rm85TURNR2pv?=
 =?utf-8?B?UlJHMHlqOGdGeHplUUZUR281MHNqakg3THZlc2kwbk01UmNPcm92Y3FDVTN3?=
 =?utf-8?B?ZVVzRlNuc3B5SUFjN3cyNWdwTFY1MEplMHlnQ1Y0SldLUlNCRlhTR0ZUeUhq?=
 =?utf-8?B?ZGxRSDZ6SDkzdFdwM3loeG1STksra0hYamwzd2EzYkRrRGpWTkp1UEppNno2?=
 =?utf-8?B?STQ4OXlNbTZEeWtaYTlLNHlSUWtYUGQ0emM2cERaU0VRcThTTHkwTk5VYklP?=
 =?utf-8?B?ZTJjTFF1VERhSlVzSlRyd1ZJdFRGcHFmd2VtQk1WMU5VSHcwbmlEaWVjV1lZ?=
 =?utf-8?B?MG51bm42WFY1RVNTQ2hOSjNDV2VwUWpFSjc2UFgzM1lad0JuMnhuUEVEZFVB?=
 =?utf-8?B?UDNEdGovZFlGeU5sc2FyZmUxVmxzOTllUTNyUXJVdVJYUCszM3pQLzBpRlZI?=
 =?utf-8?B?Uy9WcFhGeXkzYm55TUU3UGRlRmo2cGtCNit6UlljNXJEempTRHJjQlZVa3hr?=
 =?utf-8?B?ZkFNa2t6VzlmNUs4ckxXUzFCR0p5YWZwb1kvbXl3cUlVWXZjZUgweWo2aXF5?=
 =?utf-8?B?aHlDVm8zWDFNYXlsSnpmTWRYajRzVm9icml5L3Evald4bDIvYjZrU3A4RVZZ?=
 =?utf-8?B?bUh5ZTBBdHJONjBLRFRXZkNORFJ4eHc4aTI0dTM4dnVmaWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1MwTlUydHR0UllscDJUc1NwdU5kaE9KNjh2elJlUWdkV0owSVM4bTlmQ0NZ?=
 =?utf-8?B?SURERnZCRURla1VIeXR2TndER0xDeDQrNUw4TnBmcEpWQkFzTVNzVUU1ZDl1?=
 =?utf-8?B?SWZrTmk0aUNDcUZUMnhYK1I5b0paMUQwTzBrSy9TRnFlOGY1TlQra3UzUllq?=
 =?utf-8?B?RGFvZHp6VEJZUFM1cEFWbklna1N1UGxUQk5DZWVpNnkrQlJSellDT0lpR1ZP?=
 =?utf-8?B?aDNJN1NjK2ZrT0s0RndQVVZ4NEtRL0hKWUJPWHQycDBDbjFER2hFRXA2Z1NY?=
 =?utf-8?B?bHJLekgva1MyYk5NdDAvclFtbVkwYjd2WVJMTGYzZHd4Ris1emdNNm9XQW12?=
 =?utf-8?B?US8xZXZrb0tzdDBac0FEVVkrVW9PWDBZN1R5angwQkdzdnNVUHZDdzFLSGkr?=
 =?utf-8?B?cEE2cEc1Nnh3S0xxOUtvdFZ4UnJQZzBoaWxnMjBjUnEwSkx1SGp2TDFPYzRG?=
 =?utf-8?B?NzNLdmcyTlhjSXJzUXNDNXZ2dTV1aUNqQkNTNjBKdTc1K1dTaGQ3UForRFM1?=
 =?utf-8?B?V09UMGJwU25nYUlKN3RyU0RFQ3dUZitxaXlIZGt2NXcxTGlheXhKaVZEWVA2?=
 =?utf-8?B?UlJTSW5MWFAwT0hFRHZkb2NrTm8zcnFpQ2lQb0NRT3FjZzVBSFkvVVBRZVVx?=
 =?utf-8?B?bzNySGVWSld0SEZxM0NLaEhheWxMRjBNOU5aekhKYmh5ajJUNEhZR2JoTXA4?=
 =?utf-8?B?eXQ3VDJrUVhJVGc1ZDl1N1h5K3NIOUhHZ3RSSEhhUmQvckxSRS82SDNOMWNQ?=
 =?utf-8?B?Y3RicW15MHZ6M0dPWkdRajFva25HTzRqaWRFQWI1TjRhZ1l1clc3dGJwS3Az?=
 =?utf-8?B?QWw4NjBIbU4yYXE1d0x6UnFyaFFMV3FmUCs2a01HR0ZjcnVuWWtxT1BSM1Iy?=
 =?utf-8?B?YzdmMXFtQUNJOEp5YldIekFPRkdwaW44VGlRVkxOa3R5Rk9URmZSaHhSMVAr?=
 =?utf-8?B?L2hmYkdhOWRuU2VmQnRXK2lOOWo4L3pzd1dxWmdXaS9ISzVnVzlYb1VPZ3JG?=
 =?utf-8?B?MEVJalpjcEFhbjY1RzgvUFdaeE1aMVhzWWJsR3V1T3JKYm1Tby9HSjF1c1Rn?=
 =?utf-8?B?Q2Rza3JDYXZnUXdreHV5NEpESDFwR000RU9Md0E2Z2NXUGQ5UWZmVWxTYndW?=
 =?utf-8?B?bWo4WnA0b1EybUR0cUxnbC9SdjBselNWeVNnSDJYUGY1cUNOZ3lpQm15UFFM?=
 =?utf-8?B?UEcxZ0dTQUJxUTFySmdMazB3ZEJvZU9XRGVueEQxbWZuWlNFTUlxQ0hUQzBj?=
 =?utf-8?B?YU8yRzFmMHBrWVZOVDhibW9qQVp3aHN1MHVKdHRJWXJUS1hWTGhyUFJ5YUVN?=
 =?utf-8?B?NTgzM1NFQzhJTkZEVElLNlZHUkNDOVlKanZHOUZMZWEyYytaQ3ZvRzhlTDE2?=
 =?utf-8?B?M2dTOHdKL05rTVp2c3JUTlprSXhhQlE5SUo4OUlDUW03aDg2Yk5leGZxdlp4?=
 =?utf-8?B?MkRpRkxOc3Y2aE10S1V0eHI3dWFoOHRPRnh3cWJTS09QUEQ4eStVdGV3YllE?=
 =?utf-8?B?NmVLcllSckZMalQxdG1PRENPeHRTNU1TYzZ6RnJyTkU4czhZQ21pRy9qanVJ?=
 =?utf-8?B?ZHMzZ2RWZnE3SmFSbk91QmQ4ckVoTHZHR3pXL05FbWRJYkFPcTVuN3hyd0lZ?=
 =?utf-8?B?OVl2bkc5N0lJRzNMTzJUSXFaeUEvMCtiSit2TGhqS2VJQitkYVRPMENocE5B?=
 =?utf-8?B?ZFlmRGpwaXk2c3VzZTgyaUxiSEZ2ZzBILys1SDBneW5ZbEl2SzE2blRBSjcv?=
 =?utf-8?B?L3V1T3hPSktHMnQ0ZnJsVS84RlhZMkZiVnZ5VEVkUDBOSGt1dlYwckNjdksv?=
 =?utf-8?B?VWRpbFJHOGlhaE8va1pBUytZY01DV0UzOFRQWW5PV3Zod1ROMjQ4dUFITGh1?=
 =?utf-8?B?WldkNEFSbTFTTkx2MWJxQU1mam0vNDZLUXdSMWxVNTZhZmFvcTRkcS9mVDFM?=
 =?utf-8?B?c1RsMzE4WFBEM05KWU5rYU1vZkZ6SjE4NGFHbzZ4Z2pGSkZKSEloUWZJUmVx?=
 =?utf-8?B?M1FjR3dGenE0aXgwWFRXREp0cUtqME1CY1JqNGc2RmE3bVViZTNWVGhMcXZt?=
 =?utf-8?B?dXdWeVc0MnJ4RVlmMjBpYjBaSlk1QnpNOTJhN1l5VHZadHRXc2QvNXo4anJU?=
 =?utf-8?B?bUM5VCt0Nnl3WE5lUFZlR3BwZHdndmRJU2J1dHZnWEVnN1FtZldpZFZDZkFz?=
 =?utf-8?B?T0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E04B84A0833EF43B2C519AE5C2ECB93@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc5397a-a268-46bb-2bb6-08dcd080daae
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 03:38:22.2872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7NYorFcJH8Q60M6SKKVGx8dbMtlLKuL6MJL5axF2XGTb30Z03Qska8ZhBmBKnaP6K3Pj6ji/NWgGmlWcBbdKHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8504
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--25.198300-8.000000
X-TMASE-MatchedRID: Y6GLOewO+JjUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTfdM
	mQr0XJB5FDD/cchgtzDwn6l+i8UJPsdbxJISYh0rAJnGRMfFxySTbbsi+pqSFVz8J52OVy+SnhZ
	ybKoFsXPjzQKcKuB4xEG4tJ9m3jKwaHrvjgosK0p4CIKY/Hg3AwWulRtvvYxTUHQeTVDUrItRnE
	QCUU+jzjoczmuoPCq2UTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--25.198300-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	1EED00F562B90968468FC029F7BEEB9107CE37994187F797D9A69167DA68BF552000:8
X-MTK: N

T24gVGh1LCAyMDI0LTA5LTA1IGF0IDE0OjA2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xLzI0IDc6MTggUE0sIHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tIHdyb3RlOg0KPiA+ICAgLyogU1FSVEN5LklDVSA9IDEgKi8NCj4gDQo+IEZlZWwgZnJlZSB0
byBsZWF2ZSBvdXQgdGhlIGFib3ZlIGNvbW1lbnQgc2luY2UgaXQgZHVwbGljYXRlcyB0aGUgY29k
ZQ0KPiBiZWxvdyB0aGlzIGNvbW1lbnQuIEEgY29tbWVudCB0aGF0IGV4cGxhaW5zIHRoYXQgIklD
VSA9IEluaXRpYXRlDQo+IENsZWFudXAiIHByb2JhYmx5IHdvdWxkIGJlIGFwcHJvcHJpYXRlLg0K
PiANCg0KSGkgQmFydCwNCg0KV2lsbCBjaGFuZ2UgY29tbWVudCB0byAgIi8qIEluaXRpYXRlIENs
ZWFudXAgKi8iDQoNCg0KPiA+IC13cml0ZWwoU1FfSUNVLCBvcHJfc3FkX2Jhc2UgKyBSRUdfU1FS
VEMpOw0KPiA+ICt3cml0ZWwocmVhZGwob3ByX3NxZF9iYXNlICsgUkVHX1NRUlRDKSB8IFNRX0lD
VSwNCj4gPiArb3ByX3NxZF9iYXNlICsgUkVHX1NRUlRDKTsNCj4gDQo+IElzIHRoaXMgcGVyaGFw
cyBhbiBvcGVuLWNvZGVkIHZlcnNpb24gb2YgdWZzaGNkX3Jtd2woKT8NCj4gDQo+IA0KDQp1ZnNo
Y2Rfcm13bCB1c2FnZSBpbmNsdWRlcyBtbWlvX2Jhc2UsIGFuZCBpdCdzIG5vdCBzdWl0YWJsZSBm
b3IgdXNlDQpoZXJlLg0KDQo+ID4gICANCj4gPiAgIC8qIFBvbGwgU1FSVFN5LkNVUyA9IDEuIFJl
dHVybiByZXN1bHQgZnJvbSBTUVJUU3kuUlRDICovDQo+ID4gICByZWcgPSBvcHJfc3FkX2Jhc2Ug
KyBSRUdfU1FSVFM7DQo+ID4gICBlcnIgPSByZWFkX3BvbGxfdGltZW91dChyZWFkbCwgdmFsLCB2
YWwgJiBTUV9DVVMsIDIwLA0KPiA+ICAgTUNRX1BPTExfVVMsIGZhbHNlLCByZWcpOw0KPiA+IC1p
ZiAoZXJyKQ0KPiA+IC1kZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IGZhaWxlZC4gaHdxPSVkLCB0YWc9
JWQgZXJyPSVsZFxuIiwNCj4gPiAtX19mdW5jX18sIGlkLCB0YXNrX3RhZywNCj4gPiAraWYgKGVy
ciB8fCBGSUVMRF9HRVQoU1FfSUNVX0VSUl9DT0RFX01BU0ssIHJlYWRsKHJlZykpKQ0KPiA+ICtk
ZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IGZhaWxlZC4gaHdxPSVkLCB0YWc9JWQgZXJyPSVkIFJUQz0l
bGRcbiIsDQo+ID4gK19fZnVuY19fLCBpZCwgdGFza190YWcsIGVyciwNCj4gPiAgIEZJRUxEX0dF
VChTUV9JQ1VfRVJSX0NPREVfTUFTSywgcmVhZGwocmVnKSkpOw0KPiANCj4gSW4gdGhlIGFib3Zl
IGNvZGUgdGhlIGV4cHJlc3Npb24gIkZJRUxEX0dFVChTUV9JQ1VfRVJSX0NPREVfTUFTSywgDQo+
IHJlYWRsKHJlZykpIiBvY2N1cnMgdHdpY2UuIFBsZWFzZSBjb25zaWRlciBzdG9yaW5nIHRoYXQg
ZXhwcmVzc2lvbiBpbg0KPiBhIHZhcmlhYmxlIHN1Y2ggdGhhdCB0aGlzIGV4cHJlc3Npb24gb25s
eSBvY2N1cnMgb25jZS4NCj4gDQoNCldpbGwgdXNlIGEgdmFyaWFibGUuDQoNClRoYW5rcy4NClBl
dGVyDQoNCg0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KPiANCg==
