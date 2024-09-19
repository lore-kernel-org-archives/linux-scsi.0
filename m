Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CE219AA72;
	Thu, 19 Sep 2024 12:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726748191; cv=fail; b=p+SrKRwP7QDTQBYTts551eQ2nWdy0cBDyyQaubRj3GOZl0deKTp0hgCTYma5Ex02XojWkpbXUJmvZSMyujP1co6JMEb840cvv5+1+sSceV7vswbYia2+lEBjqYfU+d4qLjNlpZHMTVFjXodrh2TpLm0v3Ow8teU4bSAbBLqTAho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726748191; c=relaxed/simple;
	bh=1bDcZk6neqjWXrO9/rmOfrcLoQNOWtZCUppMPOxKsBI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rIuNSXhAZKEsuGTfgR2p1KXE6jNkirJRjt3jI8RVREG0+2udPj5SptBLjrIygrXKmKmj6bykOfuN5Ms67uApoL6fByDWYHgISxdwl5n5EOdrcQgJGISrWkdoafSUi7wJQS8+MRXKfn0j2O0WBLybMJGHSsWAigBMhnmytkkkfZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SBv6suj5; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=J2kzh4AW; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SBv6suj5";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="J2kzh4AW"
X-UUID: fae2df78768011ef8b96093e013ec31c-20240919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=1bDcZk6neqjWXrO9/rmOfrcLoQNOWtZCUppMPOxKsBI=;
	b=SBv6suj5J8ytiyZoVWdhADU39LowSHxQqm+A9xg2KXjN/1c3WTuftQy7G8MCiVk7aNYRttr1zttEesymfIXKp/adFA9dP2hTx9QWlZk3UWWozr/gVAQ83K8gddYeAWG5X6bMlBcDBcinM8O/I3JpEhA8XeR5ZxCAGYJG94Heh3A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:b21e236a-a26a-4a3d-948e-0f5c8f08ed50,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:3d04ef17-b42d-49a6-94d2-a75fa0df01d2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: fae2df78768011ef8b96093e013ec31c-20240919
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1717180088; Thu, 19 Sep 2024 20:16:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 19 Sep 2024 05:16:19 -0700
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 19 Sep 2024 20:16:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xVx+TtaWOOE0oqN8o1oH4roWcY8lLX3mVXXyQFTcQ94voDhTt10f+C1uqL4kBrn0Z6qqxMOxZfQzgs6aWb0UQkQ3jCBlxh6zh1BYPfZQYWR7idJVXeREC21hFFq/p+hqqEqlUw5SS34NOa3mYnwvJ3tMTMTLOMBIlt16FQXMuymEUttiSIFXokmkNJlFAiaMl1CYikDMY8qF9Y6444G/8AVbOa2pBPyxuRXOUyzPpOpBXWMEbFlV0PcCycbkj6MouNBPj+8SXIdoYsVtag8YniIxgtawM5fbLXy9uLVO0mIzdVXM9MqyaMTt2YSnu7TPIARzEZIaaEi3+rpxeQvuTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bDcZk6neqjWXrO9/rmOfrcLoQNOWtZCUppMPOxKsBI=;
 b=mzyYdJCIRRNoM8WN53swZxYMqmfRkxNidfKcl980+2EeDZDTNGwUor/2rWW/xcpDvlkl5OTuY4UhPjLqYLNS07nI49rzD+tUD2EYv58JD+IT7jKpJzxJtYfQQJF6FKbrS7dbu62ayFI8W8L2uUc2l+cwVD/TGv9jyw9XZyRyXr6+oRuT88MJpwXQ/POhdCcak90gaa1QaYmC+ZEh7rwxxm1YaL7G/Znw/BOhvjLHgE13+riAgDo9x4/e063qdr1xtXuBKEsvnCIKBG53YbZVJd7neGU9Zu+K9gfgjXLtlnnimKwgs8tfQrXaA9zfqjx0D27vSS1/YtfhFRSM10FSMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bDcZk6neqjWXrO9/rmOfrcLoQNOWtZCUppMPOxKsBI=;
 b=J2kzh4AWsQ4rxUOpxwazZbHLt8DsAS4NM9ujKHVfw6MMVBHZCKH/fezYjXi+Aqoqgeab/b22iS90uhHsgwatOQNhtciw25/PJFPEWh9kuvNo3fI5qRENorCAvxCKC5uUgYvSXLMou0GKoSWRthR/frAZcbE3/I6l2hWtm+p1Y4s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7461.apcprd03.prod.outlook.com (2603:1096:101:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Thu, 19 Sep
 2024 12:16:17 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7982.018; Thu, 19 Sep 2024
 12:16:16 +0000
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
Thread-Index: AQHbA1N1RX6n4EeryE2vN/rAxATc77JRT7iAgADKYQCAANwoAIABMz2AgACCMYCAAKWTAIAAsGiAgAeVY4CAAFOSgIABKiyA
Date: Thu, 19 Sep 2024 12:16:16 +0000
Message-ID: <f350a1dee5a03347b5e88b9d7249223ce7b72c08.camel@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
	 <20240910073035.25974-3-peter.wang@mediatek.com>
	 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
	 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
	 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
	 <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
	 <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
	 <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
	 <46d8be04-10db-4de1-8a59-6cd402bcecb1@acm.org>
	 <61a1678cad16dcb15f1e215ff1c47476666f0ee8.camel@mediatek.com>
	 <78c7fc74-81c2-40e4-b050-1d65dec96d0a@acm.org>
In-Reply-To: <78c7fc74-81c2-40e4-b050-1d65dec96d0a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7461:EE_
x-ms-office365-filtering-correlation-id: 0359c4d9-ae4e-4f17-8395-08dcd8a4dc83
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eDFCNnFmL3Z2K0tBeGlLcWNRZFVzeTVVU0VRNVIyNlJvaU9BZStzT0VEbVRw?=
 =?utf-8?B?d1hBb1QwKzFlbzZtbWNhaUFGZGFnUDUzLzBuMlFIazRhNGExQlVMK1luY2Vw?=
 =?utf-8?B?U0Z1d0ZjUkVSOGVzZGJOcWlJUWNiUTNuMWpnYUxBdWZEcnZQTmhHOEJ1NFFJ?=
 =?utf-8?B?K2lUdmI2b1RxNHdWVjgwYW83SkJxczRmSEFiWERabDExbFpUVGtqeWZLS2R1?=
 =?utf-8?B?a09uRzYxaEw0YzVROHp3ZG5ueEhZSDlCQ2JBODAxc0pNekFsSnBjVS92ekJB?=
 =?utf-8?B?RnNLTlhSZ0EzWkRQM3FXOGh5ekllaldvUGgyWVpxdnUvbzhaOEo0NVNhaElZ?=
 =?utf-8?B?WjFiQUhyRjQ1M0FFZTU3WUYwdUNWOTNrSjBTRXlKM0wwU3F0dTMvVDRDVG1h?=
 =?utf-8?B?QU9jdWNFUFJnZzYzN3pTdDhMRVo3TG5ibWxVRUNtdHRtRXUrRDJWMTMzZGRM?=
 =?utf-8?B?bjFGMXRIdmJtTVpyMDFLWEZiOXFMOFdVaE53R1ZsSWlaMkl6WC9Na1lKMnZy?=
 =?utf-8?B?SDlqeVRWUytxRUxYMVNiSUlodkxXQzhBWWdHTnIvYkVFZE16Z2RTVTJpakpZ?=
 =?utf-8?B?N1l1bmtkZEdubTdBSFpMMEdLN0NXa3EyTHV4YXBRODdMSFZWelAxUGpNTWY4?=
 =?utf-8?B?cDNWQVZxWGd6WWNUdUkwS1JiTXZXeWRiSk1zR3lsbHNtRVVHdHlqclh4K2lo?=
 =?utf-8?B?ODVSeWozVTQrNmttREpHVkZ5Q1JJOVpSb2RWNVEvU0luQ3JLSFVPSm1jU0Rz?=
 =?utf-8?B?SU1VQURUbjFlRmpvcDBIWlRwYk9kdHRjMlJiVG42UlVocG9ZL3F0U0l0QWlh?=
 =?utf-8?B?RUtRVWd3blZBM3V1YzBDci9LeEh2TkJIVWJnRHhwSmkyZk1iRSt5TWRJajZH?=
 =?utf-8?B?c3ozcVo0cFV6K3YzZTU0bmxaNWR1UFpWeCszRWZHNWZoVmc4NkVDd2dGd29a?=
 =?utf-8?B?SWJYQTlpa3VDMC9lTXIxWTJlYjdGNnNrc3E4b0xQNjJCcXlyamYzcDdTaGRQ?=
 =?utf-8?B?TFlJSFB3Y1pneTZxRVNsdkRXRUxSa3NBczhhZHhvOGtCKzdjUkxFZkJUdTEv?=
 =?utf-8?B?N1FSczZlVWlWMUJlYVJnci9vaFhueFh3ZjlyWmtHK1JObUlObXZBeHcxQ21U?=
 =?utf-8?B?L0Vva2Y5LzFGZnhuSUN6UXBvUUd5QWRIMDVrNzZ4UFBydVNwQTJ1Z0xHV3h1?=
 =?utf-8?B?MERrVWg1TjJFazd3b3JONU5teHJBcTlZdFpFM2NYSWVybFBtWm83N25NcGFq?=
 =?utf-8?B?REI2U0wra01qNWg5ckZLWDlpQkU4aFlabEJ2VElXSkZCdytUOWNVR3ZVUi9U?=
 =?utf-8?B?L2RTeG9mREZjeFN6M2Z1bmRTQ3BWb2htMDNzUHBHcDQ2NkFPWW5xSUtUdDlL?=
 =?utf-8?B?WHlwMFczSGM0OUpWSDloQWlNSDBGNTZGSGZnOEZnS2tOUC8zS29XMHQxS21T?=
 =?utf-8?B?VVhCZWNtdDMxQ01CRDVPNjJtQmZmdldlaGhRaXM4NzBxUExSRVZzeW1NSUpG?=
 =?utf-8?B?WlhtT3NIdGZlSVNZSlRISkMyUmZEOVpkbk1LSTAwSjBZRGhldy9ESEpVek4x?=
 =?utf-8?B?WFcxbGYxRitYYkNOWkJYTDlpNE1OYXdkRDRJQWVHZWw4M09hT3hHWURqTmFz?=
 =?utf-8?B?bjA2WHI4R3BZSWZTWmNrTTM1VkIxT083SVAxYTQ0WUV3ODRUa2hMR29QOUZN?=
 =?utf-8?B?YzdqQWI1UEx3U1ZCN2dOZ0ZwdThUdlJIc3BTamxXZFJWQlRWM0pweGZCUFNq?=
 =?utf-8?B?NDg1c1BEclJsQUJ6cENDcEhOd21zdmxDR2dBNGQxMysxR2dXY254NEltZEMw?=
 =?utf-8?B?dlVPWjNuTWtHaURUc2dIQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHZ2ZHo3MHhvRnU1a1FkWDJrYTVWNHVGazhHck1xd0h3cTdNVDVYQTZvRWVk?=
 =?utf-8?B?REZHQ01XdEd2dTl0MHR1aFJ2V21vMkdEMWE5WjJTclZhaU44OVFOKzlkSmI4?=
 =?utf-8?B?cVI2WXhweHJabHNYYm5FTlJBQUdGeXlySkdCWTNIY0tOVnN5aTI4R3d3bUZx?=
 =?utf-8?B?NFlOTHhIMkpJdU1NNGhsaWlra1lQMHBORmlQZDUzQnJvdFJPWDJQTklMaW5s?=
 =?utf-8?B?cXBYSC9ZbE1aK3kybFJINEpWNnovT3pjMmZJdVRzUGJucEJJRXRUcFoxR3Ft?=
 =?utf-8?B?bkEvWCtXOU5xS1YxdFM1dWRGQVgvQ2R0OURZWmlmSUdJdHFvdFJkYUNNcnpH?=
 =?utf-8?B?a2JEYW1SUDJReC9JU2NEbXcwV05xbmswZ1Y1SEljWmtHeXZCUlUyNkZ3dTBo?=
 =?utf-8?B?ZVNGSE9FT1VKQXc5UmpZZVlhc3BlNk5aU0d2QWNmUWRBOURBVk8zb1FZMFRo?=
 =?utf-8?B?S2dCMG9oYnM5SmFlRGpzZXJlSlNqaHFGbWJaUk56dGNhZmpTcjRYNDN4Um1t?=
 =?utf-8?B?cGNGdERuWGxWSnF3c2pjWTVjU2trMFQ1emtjNUQ0TWJDLzdac2FkYmZ2MTB6?=
 =?utf-8?B?clpxUklXMTYzQk5sSVhjaFJFcUhMZ2dNOGJtUG5EWitPclJvRnFpOUdkNEpv?=
 =?utf-8?B?VDNNTW5IOFI3TWwyTk0xWE1jZUlnMzJSZXRVelNRdzdJSnBRMDlWZllONTdF?=
 =?utf-8?B?SDI1TjVvSXRHb1FwL2NYQlBTWFpDcmtZa2U0OS83Y29yeVU0M0ltZDByK2Zj?=
 =?utf-8?B?ejBHVkI0bVNIMUlZYit1UmlyUUIxK1p1YzRmaVJWMmp0NWFSVzlGMWNPS0c0?=
 =?utf-8?B?ZFgzd01PWVc2QUtEcHFxZW9XaldtNjFVSHhPTVFPYjJIRDNVOW9ZWmE1S3Fq?=
 =?utf-8?B?RTVuU3F2SkZBdCtucFZYd1JjYUZ3azFxRVNqTnlYTUFnNXdPeTMzSzIzS0lj?=
 =?utf-8?B?bmtPMzRycFlibzhqNEw2ZzJUZTY5OFpkdTRTZnlNV2U5eE5XLzJabUErajla?=
 =?utf-8?B?QzlSNW1KVVNmd1VScmJCWmYyMTQ0MS9qd1lLQlNKWURHdDJjS2E3cnBwVktJ?=
 =?utf-8?B?SkNlTGZoQVE2QnlTMGFsaFJYbTdKTkg1R1ZNVXEzcVVuQkduMmxnL1BtK2Jj?=
 =?utf-8?B?ajl1R2lNQ2lqREdxeEZYQ3dGVEtWUzhHL2lrRWRpTWNxazJRUm1jRHdTMnhs?=
 =?utf-8?B?K1FMeWI5U012R0MvTlZEZG1sek9DS05zbHFUTlNhaUlhZHR2aW1Oa0wxR3pK?=
 =?utf-8?B?RWs5Qm1HK2lUbHB3cS9kWjVlamJzcFcvU092dDVncVd3dzUrcjVtdlZRMEpS?=
 =?utf-8?B?dUxIWUo3bnZrM1FJbnRMMk5aMmFLc1ZuMG5OM2wrUGNQU29JbUVBdHJvcDFZ?=
 =?utf-8?B?TFZBRjRrd1BCQmJsSUZxR252a1NyZ2lZV0oyLzhnZGsrSlY2TkxyK0w2Wkkr?=
 =?utf-8?B?cEdnSDhtMmlNdm5Mai9VeEFwUzRjRVU2VDNzV0ZBckN3RnNwNmJHYmtXc0ZF?=
 =?utf-8?B?TmN1NHc5SEc0amZiOVQrVW5rb3AxOUpCRll2WUlXTSt3WG40UDh1QVdiNmx6?=
 =?utf-8?B?TXVrVWJIVy9yWEZaNVBwblg4WTdhTVMzVitWRldad1pVVGhDSnBVMlpDNjI4?=
 =?utf-8?B?dGx6blhaV3labEVNTUJENGl4Sy90ZXpCSXplU2FTd25UL1pla2xOV292cXc0?=
 =?utf-8?B?Uk9naDNHcE1iKy9PaDY2K1IrWDZVVFJoZmV4SGs2MDdjdzRLOEJFRGZ2Qkpk?=
 =?utf-8?B?Y0tibzNDeWswcTF3Z1Jkb2xYYUtaL0d4MWZmeWdaL3ZUM2RoM0dzY2Rhenhi?=
 =?utf-8?B?RWRHVU1Ma1E1N3lyUDUxYmRzYXduRk9uN2lKd0R5QkNXeDdIN0xZSEcxNEtV?=
 =?utf-8?B?UFpyM1NIQWN4TDViWlN0U1NWZUlqOUtkT0YvQW94dHV3eHpRc0tTOXdrTys0?=
 =?utf-8?B?anlLNGw5alFlN1pVNjZQMElQTEhGMlpUNy9GNEhiWUFWU1UzMFNYUWttNkcv?=
 =?utf-8?B?Z21NR1hhV3ZuMHhqbmZsQmNXMW5sZkxJeXp6NkV2cVJvMXdKQWhwMTJCU25Y?=
 =?utf-8?B?NGpRaEVMU1NzMDZpd3hYTmNKYmNOWVdCRjBKbkNKWmxQUEFIbTY4bkV6UmQ4?=
 =?utf-8?B?SE9Fajd4MnhWcDVwczhISElUbUQ1dVNqVWlKRXdpb1RQb3h2SFlkYmNFb2NL?=
 =?utf-8?B?dlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1711CAA4C9C084AA30E7BC590AB92E6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0359c4d9-ae4e-4f17-8395-08dcd8a4dc83
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2024 12:16:16.5335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rBppKSn0qC2bnNMm6iToz/uQtbVZoNVqIQq8F53y3ywVoOdZ/By5G6Ztjwms92Mqq3WDP82gQvXZNoihEYL1CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7461
X-MTK: N

T24gV2VkLCAyMDI0LTA5LTE4IGF0IDExOjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xOC8yNCA2OjI5IEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IEJhc2ljYWxseSwgdGhpcyBwYXRjaCBjdXJyZW50bHkgb25seSBuZWVk
cyB0byBoYW5kbGUgcmVxdWV1ZWluZw0KPiA+IGZvciB0aGUgZXJyb3IgaGFuZGxlciBhYm9ydC4N
Cj4gPiBUaGUgYXBwcm9hY2ggZm9yIERCUiBtb2RlIGFuZCBNQ1EgbW9kZSBzaG91bGQgYmUgY29u
c2lzdGVudC4NCj4gPiBJZiByZWNlaXZlIGFuIGludGVycnVwdCByZXNwb25zZSAoT0NTOkFCT1JU
RUQgb3INCj4gSU5WQUxJRF9PQ1NfVkFMVUUpLA0KPiA+IHRoZW4gc2V0IERJRF9SRVFVRVVFLiBJ
ZiB0aGVyZSBpcyBubyBpbnRlcnJ1cHQsIGl0IHdpbGwgYWxzbyBzZXQNCj4gPiBTQ1NJIERJRF9S
RVFVRVVFIGluIHVmc2hjZF9lcnJfaGFuZGxlciB0aHJvdWdoDQo+ID4gdWZzaGNkX2NvbXBsZXRl
X3JlcXVlc3RzDQo+ID4gd2l0aCBmb3JjZV9jb21wbCA9IHRydWUuDQo+IA0KPiBSZXBvcnRpbmcg
YSBjb21wbGV0aW9uIGZvciBjb21tYW5kcyBjbGVhcmVkIGJ5IHdyaXRpbmcgaW50byB0aGUNCj4g
bGVnYWN5DQo+IFVUUkxDTFIgcmVnaXN0ZXIgaXMgbm90IGNvbXBsaWFudCB3aXRoIGFueSB2ZXJz
aW9uIG9mIHRoZSBVRlNIQ0kNCj4gc3RhbmRhcmQuIFJlcG9ydGluZyBhIGNvbXBsZXRpb24gZm9y
IGNvbW1hbmRzIGNsZWFyZWQgYnkgd3JpdGluZyBpbnRvDQo+IHRoYXQgcmVnaXN0ZXIgaXMgcHJv
YmxlbWF0aWMgYmVjYXVzZSBpdCBjYXVzZXMNCj4gdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKQ0K
PiB0byBiZSBjYWxsZWQgYXMgZm9sbG93czoNCj4gDQo+IHVmc2hjZF9zbF9pbnRyKCkNCj4gICAg
dWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpDQo+ICAgICAgdWZzaGNkX3BvbGwoKQ0KPiAgICAg
ICAgX191ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkNCj4gICAgICAgICAgdWZzaGNkX2NvbXBs
X29uZV9jcWUoKQ0KPiAgICAgICAgICAgIGNtZC0+cmVzdWx0ID0gLi4uDQo+ICAgICAgICAgICAg
dWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKQ0KPiAgICAgICAgICAgIHNjc2lfZG9uZSgpDQo+IA0K
PiBDYWxsaW5nIHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKCkgaWYgYSBjb21tYW5kIGhhcyBiZWVu
IGNsZWFyZWQgaXMNCj4gcHJvYmxlbWF0aWMgYmVjYXVzZSB0aGUgU0NTSSBjb3JlIGRvZXMgbm90
IGV4cGVjdCB0aGlzLiBJZiANCj4gdWZzaGNkX3RyeV90b19hYm9ydF90YXNrKCkgY2xlYXJzIGEg
U0NTSSBjb21tYW5kLCANCj4gdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKSBtdXN0IG5vdCBiZSBj
YWxsZWQgdW50aWwgdGhlIFNDU0kgY29yZQ0KPiBkZWNpZGVzIHRvIHJlbGVhc2UgdGhlIGNvbW1h
bmQuIFRoaXMgaXMgd2h5IEkgd3JvdGUgaW4gYSBwcmV2aW91cw0KPiBtYWlsDQo+IHRoYXQgSSB0
aGluayB0aGF0IGEgcXVpcmsgc2hvdWxkIGJlIGludHJvZHVjZWQgdG8gc3VwcHJlc3MgdGhlDQo+
IGNvbXBsZXRpb25zIGdlbmVyYXRlZCBieSBjbGVhcmluZyBhIFNDU0kgY29tbWFuZC4NCj4gDQoN
CkhpIEJhcnQsDQoNCkknbSBub3Qgc3VyZSBpZiBJJ20gbWlzdW5kZXJzdGFuZGluZyB5b3VyIHBv
aW50LCBidXQgSSBmZWVsIHRoYXQNCnVmc2hjZF9yZWxlYXNlX3Njc2lfY21kIHNob3VsZCBhbHdh
eXMgYmUgY2FsbGVkLiBJdCdzIHNjc2lfZG9uZSANCnRoYXQgc2hvdWxkbid0IGJlIGNhbGxlZCwg
YXMgaXQgc2hvdWxkIGJlIGxlZnQgdG8gdGhlIFNDU0kgbGF5ZXIgDQp0byBkZWNpZGUgaG93IHRv
IGhhbmRsZSB0aGlzIGNvbW1hbmQuIA0KQmVjYXVzZSB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCBp
cyBqdXN0IGFib3V0IHJlbGVhc2luZyByZXNvdXJjZXMgDQpyZWxhdGVkIHRvIHVmc2hjZF9tYXBf
c2cgYW5kIHRoZSBjbG9jayBhdCB0aGUgVUZTIGRyaXZlciBsZXZlbC4gDQpzY3NpX2RvbmUgaXMg
d2hhdCBub3RpZmllcyB0aGUgU0NTSSBsYXllciB0aGF0IHRoZSBjbWQgaGFzIGZpbmlzaGVkLCAN
CmFza2luZyBpdCB0byBsb29rIGF0IHRoZSByZXN1bHQgdG8gZGVjaWRlIGhvdyB0byBwcm9jZWVk
Lg0KDQoNCj4gPiBUaGUgbW9yZSBwcm9ibGVtYXRpYyBwYXJ0IGlzIHdpdGggTUNRIG1vZGUuIFRv
IGltaXRhdGUgdGhlIERCUg0KPiA+IGFwcHJvYWNoLCB3ZSBqdXN0IG5lZWQgdG8gc2V0IERJRF9S
RVFVRVVFIHVwb24gcmVjZWl2aW5nIGFuDQo+IGludGVycnVwdC4NCj4gPiBFdmVyeXRoaW5nIGVs
c2UgcmVtYWlucyB0aGUgc2FtZS4gVGhpcyB3b3VsZCBtYWtlIHRoaW5ncyBzaW1wbGVyLg0KPiA+
IA0KPiA+IE1vdmluZyBmb3J3YXJkLCBpZiB3ZSB3YW50IHRvIHNpbXBsaWZ5IHRoaW5ncyBhbmQg
d2UgaGF2ZSBhbHNvDQo+ID4gdGFrZW4gc3RvY2sgb2YgdGhlIHR3byBvciB0aHJlZSBzY2VuYXJp
b3Mgd2hlcmUgT0NTOiBBQk9SVEVEDQo+IG9jY3VycywNCj4gPiBkbyB3ZSBldmVuIG5lZWQgYSBm
bGFnPyBDb3VsZG4ndCB3ZSBqdXN0IHNldCBESURfUkVRVUVVRSBkaXJlY3RseQ0KPiA+IGZvciBP
Q1M6IEFCT1JURUQ/DQo+ID4gV2hhdCBkbyB5b3UgdGhpbms/DQo+IA0KPiBIb3cgYWJvdXQgbWFr
aW5nIHVmc2hjZF9jb21wbF9vbmVfY3FlKCkgc2tpcCBlbnRyaWVzIHdpdGggc3RhdHVzDQo+IE9D
U19BQk9SVEVEPyBUaGF0IHdvdWxkIG1ha2UgdWZzaGNkX2NvbXBsX29uZV9jcWUoKSBiZWhhdmUg
YXMgdGhlDQo+IFNDU0kgY29yZSBleHBlY3RzLCBuYW1lbHkgbm90IGZyZWVpbmcgYW55IGNvbW1h
bmQgcmVzb3VyY2VzIGlmIGENCj4gU0NTSSBjb21tYW5kIGlzIGFib3J0ZWQgc3VjY2Vzc2Z1bGx5
Lg0KPiANCj4gVGhpcyBhcHByb2FjaCBtYXkgcmVxdWlyZSBmdXJ0aGVyIGNoYW5nZXMgdG8gdWZz
aGNkX2Fib3J0X2FsbCgpLg0KPiBJbiB0aGF0IGZ1bmN0aW9uIHRoZXJlIGFyZSBzZXBhcmF0ZSBj
b2RlIHBhdGhzIGZvciBsZWdhY3kgYW5kIE1DUQ0KPiBtb2RlLiBUaGlzIGlzIGxlc3MgdGhhbiBp
ZGVhbC4gV291bGQgaXQgYmUgcG9zc2libGUgdG8gY29tYmluZQ0KPiB0aGVzZSBjb2RlIHBhdGhz
IGJ5IHJlbW92aW5nIHRoZSB1ZnNoY2RfY29tcGxldGVfcmVxdWVzdHMoKSBjYWxsDQo+IGZyb20g
dWZzaGNkX2Fib3J0X2FsbCgpIGFuZCBieSBoYW5kbGluZyBjb21wbGV0aW9ucyBmcm9tIGluc2lk
ZQ0KPiB1ZnNoY2RfYWJvcnRfb25lKCk/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpU
aGUgZm91ciBjYXNlIGZsb3dzIGZvciBhYm9ydCBhcmUgYXMgZm9sbG93czoNCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCg0K
Q2FzZTE6IERCUiB1ZnNoY2RfYWJvcnQNCg0KSW4gdGhpcyBjYXNlLCB5b3UgY2FuIHNlZSB0aGF0
IHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kIHdpbGwgDQpkZWZpbml0ZWx5IGJlIGNhbGxlZC4NCg0K
dWZzaGNkX2Fib3J0KCkNCiAgdWZzaGNkX3RyeV90b19hYm9ydF90YXNrKCkJCS8vIEl0IHNob3Vs
ZCB0cmlnZ2VyIGFuDQppbnRlcnJ1cHQsIGJ1dCB0aGUgdGVuc29yIG1pZ2h0IG5vdA0KICBnZXQg
b3V0c3RhbmRpbmdfbG9jaw0KICBjbGVhciBvdXRzdGFuZGluZ19yZXFzIHRhZw0KICB1ZnNoY2Rf
cmVsZWFzZV9zY3NpX2NtZCgpDQogIHJlbGVhc2Ugb3V0c3RhbmRpbmdfbG9jaw0KDQp1ZnNoY2Rf
aW50cigpDQogIHVmc2hjZF9zbF9pbnRyKCkNCiAgICB1ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBs
KCkNCiAgICAgIHVmc2hjZF9wb2xsKCkNCiAgICAgICAgZ2V0IG91dHN0YW5kaW5nX2xvY2sNCiAg
ICAgICAgY2xlYXIgb3V0c3RhbmRpbmdfcmVxcyB0YWcNCiAgICAgICAgcmVsZWFzZSBvdXRzdGFu
ZGluZ19sb2NrCQkJDQogICAgICAgIF9fdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpDQogICAg
ICAgICAgdWZzaGNkX2NvbXBsX29uZV9jcWUoKQ0KICAgICAgICAgIGNtZC0+cmVzdWx0ID0gRElE
X1JFUVVFVUUJLy8gbWVkaWF0ZWsgbWF5IG5lZWQgcXVpcmsNCmNoYW5nZSBESURfQUJPUlQgdG8g
RElEX1JFUVVFVUUNCiAgICAgICAgICB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCgpDQogICAgICAg
ICAgc2NzaV9kb25lKCk7DQoNCkluIG1vc3QgY2FzZXMsIHVmc2hjZF9pbnRyIHdpbGwgbm90IHJl
YWNoIHNjc2lfZG9uZSBiZWNhdXNlIHRoZSANCm91dHN0YW5kaW5nX3JlcXMgdGFnIGlzIGNsZWFy
ZWQgYnkgdGhlIG9yaWdpbmFsIHRocmVhZC4gDQpUaGVyZWZvcmUsIHdoZXRoZXIgdGhlcmUgaXMg
YW4gaW50ZXJydXB0IG9yIG5vdCBkb2Vzbid0IGFmZmVjdCANCnRoZSByZXN1bHQgYmVjYXVzZSB0
aGUgSVNSIHdpbGwgZG8gbm90aGluZyBpbiBtb3N0IGNhc2VzLiANCg0KSW4gYSB2ZXJ5IGxvdyBj
aGFuY2UsIHRoZSBJU1Igd2lsbCByZWFjaCBzY3NpX2RvbmUgYW5kIG5vdGlmeSANClNDU0kgdG8g
cmVxdWV1ZSwgYW5kIHRoZSBvcmlnaW5hbCB0aHJlYWQgd2lsbCBub3QgDQpjYWxsIHVmc2hjZF9y
ZWxlYXNlX3Njc2lfY21kLg0KTWVkaWFUZWsgbWF5IG5lZWQgdG8gY2hhbmdlIERJRF9BQk9SVCB0
byBESURfUkVRVUVVRSBpbiB0aGlzIA0Kc2l0dWF0aW9uLCBvciBwZXJoYXBzIG5vdCBoYW5kbGUg
dGhpcyBJU1IgYXQgYWxsLg0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCkNhc2UyOiBNQ1EgdWZzaGNkX2Fib3J0DQoN
CkluIHRoZSBjYXNlIG9mIE1DUSB1ZnNoY2RfYWJvcnQsIHlvdSBjYW4gYWxzbyBzZWUgdGhhdCAN
CnVmc2hjZF9yZWxlYXNlX3Njc2lfY21kIHdpbGwgZGVmaW5pdGVseSBiZSBjYWxsZWQgdG9vLiAN
Ckhvd2V2ZXIsIHRoZXJlIHNlZW1zIHRvIGJlIGEgcHJvYmxlbSBoZXJlLCBhcyANCnVmc2hjZF9y
ZWxlYXNlX3Njc2lfY21kIG1pZ2h0IGJlIGNhbGxlZCB0d2ljZS4gDQpUaGlzIGlzIGJlY2F1c2Ug
Y21kIGlzIG5vdCBudWxsIGluIHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kLCANCndoaWNoIHRoZSBw
cmV2aW91cyB2ZXJzaW9uIHdvdWxkIHNldCBjbWQgdG8gbnVsbC4gDQpTa2lwcGluZyBPQ1M6IEFC
T1JURUQgaW4gdWZzaGNkX2NvbXBsX29uZV9jcWUgaW5kZWVkIA0KY2FuIGF2b2lkIHRoaXMgcHJv
YmxlbS4gVGhpcyBwYXJ0IG5lZWRzIGZ1cnRoZXIgDQpjb25zaWRlcmF0aW9uIG9uIGhvdyB0byBo
YW5kbGUgaXQuDQoNCnVmc2hjZF9hYm9ydCgpDQogIHVmc2hjZF9tY3FfYWJvcnQoKQ0KICAgIHVm
c2hjZF90cnlfdG9fYWJvcnRfdGFzaygpCS8vIHdpbGwgdHJpZ2dlciBJU1IgDQogICAgdWZzaGNk
X3JlbGVhc2Vfc2NzaV9jbWQoKQ0KDQp1ZnNfbXRrX21jcV9pbnRyKCkNCiAgdWZzaGNkX21jcV9w
b2xsX2NxZV9sb2NrKCkNCiAgICB1ZnNoY2RfbWNxX3Byb2Nlc3NfY3FlKCkNCiAgICAgIHVmc2hj
ZF9jb21wbF9vbmVfY3FlKCkNCiAgICAgICAgY21kLT5yZXN1bHQgPSBESURfQUJPUlQNCiAgICAg
ICAgdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKSAvLyB3aWxsIHJlbGVhc2UgdHdpY2UNCiAgICAg
ICAgc2NzaV9kb25lKCkNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQpDYXNlMzogREJSIHVmc2hjZF9lcnJfaGFuZGxl
cg0KDQpJbiB0aGUgY2FzZSBvZiB0aGUgREJSIG1vZGUgZXJyb3IgaGFuZGxlciwgaXQncyB0aGUg
c2FtZTsgDQp1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCB3aWxsIGFsc28gYmUgZXhlY3V0ZWQsIGFu
ZCBzY3NpX2RvbmUgDQp3aWxsIGRlZmluaXRlbHkgYmUgdXNlZCB0byBub3RpZnkgU0NTSSB0byBy
ZXF1ZXVlLg0KDQp1ZnNoY2RfZXJyX2hhbmRsZXIoKQ0KICB1ZnNoY2RfYWJvcnRfYWxsKCkNCiAg
ICB1ZnNoY2RfYWJvcnRfb25lKCkNCiAgICAgIHVmc2hjZF90cnlfdG9fYWJvcnRfdGFzaygpCS8v
IEl0IHNob3VsZCB0cmlnZ2VyIGFuDQppbnRlcnJ1cHQsIGJ1dCB0aGUgdGVuc29yIG1pZ2h0IG5v
dA0KICAgIHVmc2hjZF9jb21wbGV0ZV9yZXF1ZXN0cygpDQogICAgICB1ZnNoY2RfdHJhbnNmZXJf
cmVxX2NvbXBsKCkNCiAgICAgICAgdWZzaGNkX3BvbGwoKQ0KICAgICAgICAgIGdldCBvdXRzdGFu
ZGluZ19sb2NrDQogICAgICAgICAgY2xlYXIgb3V0c3RhbmRpbmdfcmVxcyB0YWcNCiAgICAgICAg
ICByZWxlYXNlIG91dHN0YW5kaW5nX2xvY2sJDQogICAgICAgICAgX191ZnNoY2RfdHJhbnNmZXJf
cmVxX2NvbXBsKCkNCiAgICAgICAgICAgIHVmc2hjZF9jb21wbF9vbmVfY3FlKCkNCiAgICAgICAg
ICAgICAgY21kLT5yZXN1bHQgPSBESURfUkVRVUVVRSAvLyBtZWRpYXRlayBtYXkgbmVlZCBxdWly
aw0KY2hhbmdlIERJRF9BQk9SVCB0byBESURfUkVRVUVVRQ0KICAgICAgICAgICAgICB1ZnNoY2Rf
cmVsZWFzZV9zY3NpX2NtZCgpDQogICAgICAgICAgICAgIHNjc2lfZG9uZSgpDQoNCnVmc2hjZF9p
bnRyKCkNCiAgdWZzaGNkX3NsX2ludHIoKQ0KICAgIHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwo
KQ0KICAgICAgdWZzaGNkX3BvbGwoKQ0KICAgICAgICBnZXQgb3V0c3RhbmRpbmdfbG9jaw0KICAg
ICAgICBjbGVhciBvdXRzdGFuZGluZ19yZXFzIHRhZw0KICAgICAgICByZWxlYXNlIG91dHN0YW5k
aW5nX2xvY2sJCQkNCiAgICAgICAgX191ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkNCiAgICAg
ICAgICB1ZnNoY2RfY29tcGxfb25lX2NxZSgpDQogICAgICAgICAgY21kLT5yZXN1bHQgPSBESURf
UkVRVUVVRSAvLyBtZWRpYXRlayBtYXkgbmVlZCBxdWlyayBjaGFuZ2UNCkRJRF9BQk9SVCB0byBE
SURfUkVRVUVVRQ0KICAgICAgICAgIHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKCkNCiAgICAgICAg
ICBzY3NpX2RvbmUoKTsNCg0KQXQgdGhpcyB0aW1lLCB0aGUgc2FtZSBhY3Rpb25zIGFyZSB0YWtl
biByZWdhcmRsZXNzIG9mIHdoZXRoZXIgDQp0aGVyZSBpcyBhbiBJU1IsIGFuZCB3aXRoIHRoZSBw
cm90ZWN0aW9uIG9mIG91dHN0YW5kaW5nX2xvY2ssIA0Kb25seSBvbmUgdGhyZWFkIHdpbGwgZXhl
Y3V0ZSB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCBhbmQgc2NzaV9kb25lLg0KDQotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoN
CkNhc2U0OiBNQ1EgdWZzaGNkX2Vycl9oYW5kbGVyDQoNCkl0J3MgdGhlIHNhbWUgd2l0aCBNQ1Eg
bW9kZTsgdGhlcmUgaXMgcHJvdGVjdGlvbiBmcm9tIHRoZSBjcWUgbG9jaywgDQpzbyBvbmx5IG9u
ZSB0aHJlYWQgd2lsbCBleGVjdXRlLiBXaGF0IG15IHBhdGNoIDIgYWltcyB0byBkbyBpcyB0byAN
CmNoYW5nZSBESURfQUJPUlQgdG8gRElEX1JFUVVFVUUgaW4gdGhpcyBzaXR1YXRpb24uDQoNCnVm
c2hjZF9lcnJfaGFuZGxlcigpDQogIHVmc2hjZF9hYm9ydF9hbGwoKQ0KICAgIHVmc2hjZF9hYm9y
dF9vbmUoKQ0KICAgICAgdWZzaGNkX3RyeV90b19hYm9ydF90YXNrKCkJLy8gd2lsbCB0cmlnZ2Vy
IGlycSB0aHJlYWQNCiAgICB1ZnNoY2RfY29tcGxldGVfcmVxdWVzdHMoKQ0KICAgICAgdWZzaGNk
X21jcV9jb21wbF9wZW5kaW5nX3RyYW5zZmVyKCkNCiAgICAgICAgdWZzaGNkX21jcV9wb2xsX2Nx
ZV9sb2NrKCkNCiAgICAgICAgICB1ZnNoY2RfbWNxX3Byb2Nlc3NfY3FlKCkNCiAgICAgICAgICAg
IHVmc2hjZF9jb21wbF9vbmVfY3FlKCkNCiAgICAgICAgICAgICAgY21kLT5yZXN1bHQgPSBESURf
QUJPUlQgLy8gc2hvdWxkIGNoYW5nZSB0byBESURfUkVRVUVVRQ0KICAgICAgICAgICAgICB1ZnNo
Y2RfcmVsZWFzZV9zY3NpX2NtZCgpDQogICAgICAgICAgICAgIHNjc2lfZG9uZSgpDQoNCnVmc19t
dGtfbWNxX2ludHIoKQ0KICB1ZnNoY2RfbWNxX3BvbGxfY3FlX2xvY2soKQ0KICAgIHVmc2hjZF9t
Y3FfcHJvY2Vzc19jcWUoKQ0KICAgICAgdWZzaGNkX2NvbXBsX29uZV9jcWUoKQ0KICAgICAgICBj
bWQtPnJlc3VsdCA9IERJRF9BQk9SVCAgLy8gc2hvdWxkIGNoYW5nZSB0byBESURfUkVRVUVVRQ0K
ICAgICAgICB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCgpDQogICAgICAgIHNjc2lfZG9uZSgpDQoN
ClRoYW5rcw0KUGV0ZXINCg0KDQo=
