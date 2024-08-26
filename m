Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A86FB0;
	Mon, 26 Aug 2024 03:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724643716; cv=fail; b=ZS3qXahrFW3Fn3oMtXs0MrRc8VJYENBE/snuQC/ChogxEUVRQYiHG4ronAXYD2r+BPC5VFrHVp+Fcnk/ekxDdiP/0ZprOkxYJlvRcencTpl1FPScBGfh95YwmQRsBbf8IcqQDUGGVX+q4LA6/AHHSs7evtKmDlyfmZf4YaRW+uY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724643716; c=relaxed/simple;
	bh=EwuIG87aGkF/TuNybarK/pSS6VkoULKsExCoFPCh/Y0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fem6y6+RpkwimSLmy54WFSpH3p3whM3AXchzoR4/QXhLZAIMxuTtMXM9pVKZkIa7+MWbw3Tuw7JCKgPwOk4maRribV4E0oZZF1Y7NlTCDWkw0OPMVplGwfjDDNUqvHbhLsgzZobdh0WBh7sVFXUvO3EGNDMOi75F1hcyc9X8GBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QqaI+qrP; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=WrGL8Uub; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QqaI+qrP";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="WrGL8Uub"
X-UUID: 1ac6e7bc635d11ef8b96093e013ec31c-20240826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=EwuIG87aGkF/TuNybarK/pSS6VkoULKsExCoFPCh/Y0=;
	b=QqaI+qrPCmEvcJqdHn/xH09T7erChXW6o6RnE2jI+lXEfRP1M56fP4Sxnhi9f7ff8KMznmFkDljEbrHJiN9o9UkM1MR8hws6BYRAiHEhtO/pd81sMToEKRF6csZN2Xu2TRk0qwclOfelgafxtvi0QPkgDDMyp7X3T+TWcbqb/vE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:dbb3b79c-d881-4d7a-b042-86c6397f4122,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:bcb3c814-737d-40b3-9394-11d4ad6e91a1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: 1ac6e7bc635d11ef8b96093e013ec31c-20240826
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2006269110; Mon, 26 Aug 2024 11:41:40 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 26 Aug 2024 11:41:40 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 26 Aug 2024 11:41:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YP/GiMJxafvsPJA8XL6XMLWnr1gH5mBBdOdM6zOlY3bMvjxIHgmhUwjIdMsCf/dFCaVAGvCb0SXzNo1DRhjRC+Jxihs/t9TOPlQ9gu4tZAuHQGwwc/k4ktXufAfpgrtSOYzpAJ6EHFD3Igp3YFvQ+cREVqorB0+hJ7zVhG5l6vZ9f3qYVRXYgBbEU3yTHJcm5cJ9UmOJpWoJQMWeS/tTnsLMfJtg7P4119GEQ8D3pEkC90SHDhnkYte8QQ/Efr58M7tctWqlbPgpJHcmt1TV8b3J0tJmV77AS5ucRsYAsdQ4mVo1ydVUEIUZ/lCqTJjsLx6ToYtgVwC71OfRTfWiFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwuIG87aGkF/TuNybarK/pSS6VkoULKsExCoFPCh/Y0=;
 b=PEd/58BfHNFBPjXE3BIE9ifzQH4693GzC15icu7w+pWfsk2SEekgzT/vS6i9VjUyBj9Pp2l5PMQ7NgnySvtAsze36teQCjVJGtLtWo21wzYZ4845wyBLEKYujA2ar8UB9Z9JXkzPaNzkwlbzILFf9nVU5scXWUEzKpPavgt8msRF++5Vs1X/zrWv5PdlqLuv37428giwJ44pnsD89fjxK0RyUJRu+1xP90E3MvXlyeReBzb+5qeWxCXIdD4ajVLZ2d9NLcs2n2LK/YP6fRcb9GAHWParHnx6BTXBW+NSJ0jhaqXiIVRkjv/muQyAHliwvuMeuseiNSL+WAtpxNbvWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwuIG87aGkF/TuNybarK/pSS6VkoULKsExCoFPCh/Y0=;
 b=WrGL8UubGitkOUEdkWAeJTqu56E4kQZ9enwIG+GeLVv+pFtwA+RnpySQPL1kYC0PdFRLYQuwdnwhcZ+IME5d6vsSFLYy18n4nlIESp/DD3ko7frYOqiKh7l8mxaqLSZpWLRcS0FDnm2b6CbJA2UlKygwbJiMFkTbwR/Hv5yV9Yw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8625.apcprd03.prod.outlook.com (2603:1096:405:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Mon, 26 Aug
 2024 03:41:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 03:41:37 +0000
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
Subject: Re: [PATCH v1 1/2] ufs: core: complete scsi command after release
Thread-Topic: [PATCH v1 1/2] ufs: core: complete scsi command after release
Thread-Index: AQHa9URPU29Fp2jc0UqB6WBmT4ZL0rI1BjSAgAPi9wA=
Date: Mon, 26 Aug 2024 03:41:37 +0000
Message-ID: <9777c609e47cfab2b8a6c2d335c02180cf941c3f.camel@mediatek.com>
References: <20240823100707.6699-1-peter.wang@mediatek.com>
	 <20240823100707.6699-2-peter.wang@mediatek.com>
	 <c5906668-1110-4ecc-9249-32e92502dd13@acm.org>
In-Reply-To: <c5906668-1110-4ecc-9249-32e92502dd13@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8625:EE_
x-ms-office365-filtering-correlation-id: 7a453b26-cb51-4b81-9f9c-08dcc580fd6d
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S21FbUxWMkRBZ0RTNktBMzAyTzJRM2JFMXJtMXVOMFhMTzYvOFRjR3RUQlV5?=
 =?utf-8?B?UzY1bTl6ODdhbnlwdTJKcFNmNDV4dy9wdm1Gb25DWGhpNkpmR05NY3pveHlU?=
 =?utf-8?B?dm5zbEcwSHA4MnhkUHJjbm1KL3h4WTJtMnJZdFhlZWJoL1QvaDExaXAwMk93?=
 =?utf-8?B?THhNTnEybHNmMjhrRFNDMnRlRnhSNUdGSmVRWGlhV1ZQTXl5bEF3UjEvZ0RB?=
 =?utf-8?B?UmJoaS9EYWgxVUtCOHJIZzJqdUM4K1lHNjlKYWFHbHBqdkRlMUdwQ09sb3ZG?=
 =?utf-8?B?WTQ5bkF5d3VkTUlvNktacis0aU9peUY2ekJxTkJWTEFQVUw1clhpb2lwK2tr?=
 =?utf-8?B?Q3JxalBxMCtSSzNFNmNYNldHNXlJa0NJT3YvQ01kR3Vmc2lIWVM4YncyeW9m?=
 =?utf-8?B?cm9QRDAwMFFuMmgrYlI0VVZrcVA4cm9CemVHSFNTRi83eVZmYlRTZktwNzJI?=
 =?utf-8?B?Z3Z3dER5T3cyVnZvN1ZlUWxBUGRTdGRjdllHcGpVeGNOam5PZk9sdkxyUzBZ?=
 =?utf-8?B?a2dnS0Y5c01QUDJBQkxydWduSGlzUlYzdjFSSkR1ZHhKbk5lRzlDNEZidkxD?=
 =?utf-8?B?N1ViOFQ2UTJIdGppYjJHS3FDTTBLbFBrYS9jNWFQd0NMak5uS0owNmpBS0V0?=
 =?utf-8?B?cGhWbSt3WjdmeXlkbUF4dWVBTTc2a0NCeE9ZT0pvcEVkbDdhckI2SExIc3RJ?=
 =?utf-8?B?UE9tUGdDNy9reUlTNjZmKy9XZ0hrQkd4QWNQZGFITTlvRlNxWGZCbmdHUm9l?=
 =?utf-8?B?NStvdHBtR2dRSkR6TWI5SkhCR09ZZERtaEhWaHhSN1N0VXMzcGhiTmFHdmd6?=
 =?utf-8?B?RnZhc0pZKytUOVRZVmhSOVVGR0pROTR3RlRzS1JRN1BkU1NxeUpkWW9EdVlq?=
 =?utf-8?B?MVBrZGZtYUl4SlBuZm9JZXNLenp6bFVyUlRMc2JyYnBKK1J1akFxSHFmS0RO?=
 =?utf-8?B?d0hvS2tySTF3Y2dvd2FMTnZ6QTBiMnhINUhqL3M5QnYwVUZTNWh0UUExbzNB?=
 =?utf-8?B?b2FnTWdYQVhhOS9lM2NiUHpJckh3alJFV21EMHU4UkpQcTBKYzNaTjJYQ1Mv?=
 =?utf-8?B?TmNGRERuQ0xEQTI2UzNJSzNDNlNpMm52MHVLZy9VR3dYTFZ0NkN1MjhDM3Qw?=
 =?utf-8?B?Vm4zdW9mM3BxTjdIdHcySGU0RE1FeCtQWkpXNTgxZ0VBUnNpQzhzeW5BNWtj?=
 =?utf-8?B?WjVrRFQ0bHFMS1VOb09RQlpoWHNnRnpyUFJJSVhiM1FUeXgzd3QvWWU1SGtV?=
 =?utf-8?B?YzJsY3BKajRiNUF0VURGd3ZrUFZxbWNKZ2lxMWNaeWdiZzVoZlBPS1lmTkNN?=
 =?utf-8?B?cGZBeUt4SlJtTnNMSjdjRzFFU2d2WlNQa0hsdXRDOENja2gzdllzRjE0aUlR?=
 =?utf-8?B?SFd6MTN4ODJQMk1jREJuVU9jcGZGQkxUT0V0L0FFOXlPSEgvZGMrOUJNUldS?=
 =?utf-8?B?cmV0c0NqNnFxTmNVcVhBRGpKcUFrUDdWeS9XVjRBVmZHcFNhRWhzbVFMUXBu?=
 =?utf-8?B?VXg1QUI2TUdSOXZDMnRoWTJBeVQxaFdERnBOZFJMYVhFUXpPdENzeU5SUDA5?=
 =?utf-8?B?YWdndUErMzFwUTVvRDhTY3d2UERNT205aGZ4UUhxSHNXaC8vVDFBN1V2M0hw?=
 =?utf-8?B?M0NXaGNzVUJuL0JEMGtZMHpJSWkrcEtTZFArWkRkMHJvZnp6M2ozYXVBb002?=
 =?utf-8?B?djdnanBpWitJL0pjQWZyeit3SEQrclJxd3hiYmhHZmFCd0FXTDQ0SGdqbDZv?=
 =?utf-8?B?NzUvbE90Wkw5Vmk2U2NRMUppdzQwR3VocWZrVjZ1MkJDU21ESlFIYjI3NVFn?=
 =?utf-8?B?R2hLVEwvelZuQzN2c2Z2dUdYbm5LaGNDbklGeWlzOURCTmczMkVkY0pjZE9G?=
 =?utf-8?B?c2pGTUk5V1p0NlY2am9va3lXcjF1RGlBbEJZQWllbFcxUVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlM5d2JZdmxmRmNjVXJWbTNaWUxmcUhsdktOaG9NWkFQWG54SFBIZ3NnREsz?=
 =?utf-8?B?bGl0c2RKNU1rUUVkSVRJSktySkJrRkV1SWVrK1pveXQvQndXeXJRdnBReWxw?=
 =?utf-8?B?WjYyVVpvZCtQZ05EZ2daQSt2NXp3Nzhoam03RW1ETmZJcXZsVmNlSXpFd3BE?=
 =?utf-8?B?UjBkZ01JaXNPTmtZY2ZQM2pJZFg4UFA1eVhMQ2NXRnljV2xjUjFHL0FmQ2NR?=
 =?utf-8?B?NjFoQ2lQd09wKy9jU1FsVlpGYVlmKzFZc0F2UmhUNVVWTnVFaFFraVRINHFM?=
 =?utf-8?B?SzlUU1F2dmxtQXpHaUUvUSs1cnBySi95QkhMYjRVcGtMN01LVW4wMlozU1Br?=
 =?utf-8?B?TVBNbndpY1BITXhreEJUQXliWE8wMERicHFDRThrZEdwNHBVYVhaQ2FDNmM5?=
 =?utf-8?B?alByRHZCWmpTeDVUcnFNcTBUeWVHK29HVEl0cEZDYmRJSmZYVGcyYkpmQk9E?=
 =?utf-8?B?b3dQM2R2emt6ak9WUm0xM0FBY08xTDlPdjhVaHhsN2JnSmJpTjhlODdZcHdy?=
 =?utf-8?B?UFp1eUpEbDZ5Q0Z6ekRYbkFKbnc5amxMSWFQb3YxQnFuNitzZmhFT2dYYWdo?=
 =?utf-8?B?L0tNL1RPQmVQNGpHQUd3cy9KdWU4TzMxVnZxaHV1akIxRUZ5UDFUTTJDUXVm?=
 =?utf-8?B?NmJXWGZrczA2NS8vUHMrMSs2WWlFNFI5SG9rR2tJeHdRQkhNVGZJZWxvZCtH?=
 =?utf-8?B?TWNvNndpZkUyQ05lVEFXVDFwdDE3bktZWjErL0ZOM0xGMk9GTGZJM0JqM3RU?=
 =?utf-8?B?Y01Jc0lTWVFWcWRycWtlTDQ1NFd4SEsyeXRPUnArVnQvZVJxQXJadit3ZHZB?=
 =?utf-8?B?TVRrV3RRNWFHUWlhOW9UUnM4Yk93V3AzQjBBd0dGNHRqTk9kckJMUHRHaTRI?=
 =?utf-8?B?MVYrd2RsZU82anFIckxwRE9FVnpGa01oZVRaNHJvMnZUaFNqSlJDb1NSTzhN?=
 =?utf-8?B?dW5yOVRyUFJXNk9iNXdzRWU0T3BzdFc0cThvOGFTSTEraDZMOW4yVUZ2RXJK?=
 =?utf-8?B?Z3NrRHU4QityTEZTd0ZaQlpTZ3hFeW95MXFTNUtjU3BoOVEybXlONXhkTUtM?=
 =?utf-8?B?azBoMDdXYlkxSFhVSURTMit0V0dBcU1MRGZMS29LSjIxWDZLOHl5akF5QTJx?=
 =?utf-8?B?U21ZNnhDSUdKakdWeTNpMEZCdFBqVFY5ZzNhcUhzMUg5dUtLbjVLdmVYWHBJ?=
 =?utf-8?B?OVFTdE9PSEZ4MlhYeWdEZEhqVmZMV0Q0S1hvS3Z1Tmp1aDZkVWUyQ2ZMR3Ew?=
 =?utf-8?B?Szc0dlpaUmczQlFBZTNuOENhRWsyUjQrYzdBOVM2OENDaVpMamNCakJ5bjNB?=
 =?utf-8?B?RldNcVEzdlhYOGlIRUV3b2dGNVVIelUvS3lVeTN0cmd0SzR6MlBHTUlpN0dN?=
 =?utf-8?B?RUpuejZZZ3hQN3JmNHdRdEN4RXJpZDZCc1JvVDRSckxVeEVQcjBBVTU1a2ZL?=
 =?utf-8?B?UFQ1UDczWFlJQVdHTEZOK1V4SXVVcUxPV05vNkt4c2VrcXhsOXlpSEpva2Ux?=
 =?utf-8?B?dUhxd2F6N09wRzAyUUZ2TklVaHRxRXp2azZaTGgxTmRaVFdNbENTbGxlcEtE?=
 =?utf-8?B?akxlVGdHR1phUnA2djhFUUtVU2p6QWRvYS8rVVgrZThmWGR0UEhveXI0MTc5?=
 =?utf-8?B?bDZoMGgzcXlnakp1S3VjaHVVVElqR3RPU1psZUVYTE5wZzFRQTB4c215OWhI?=
 =?utf-8?B?c0RoSmJPSDA2SXVIZDVVVFNWcVk3blZHeWlta0hLNG9DVDBud1NBc0xOLzAr?=
 =?utf-8?B?MWNEencwL1VTTWRidS9DZzBtWHcvZWxHV25wUGN3engzbXZMMThEcWZJMUVV?=
 =?utf-8?B?RVhIYmdNMnJyYXYwT2U5VHc0WHArRGMwVWRnaElXTVQzMExKWWExQTlsMnVE?=
 =?utf-8?B?blhxbHFyRDhLWGJZUDBwMGpsdFdMUDV5eE90cURjcktFUmxpL0FzbnNUcStn?=
 =?utf-8?B?UFlqNk1CK2NVSEIzVHR4WWk5WHFSWFpzN2l5by9TN1VQUjJHOElMOXZ4R3FX?=
 =?utf-8?B?dzRacTI5UlpubHpobWl6cDI2bUNRM29PQWNkVU51elFSazV3OHJEdG5RVUtV?=
 =?utf-8?B?N3hwQzh3ZnU0RFdnQkpuRDhJUlVKcnl1S29jVEV2OVdjL29kSERiRmc3S2Vy?=
 =?utf-8?B?VUtMVnhPQTh5Y2pUcUViZE9tRHllbENjQ0xoSktTNzl2eWRERDNmNkhEMnhJ?=
 =?utf-8?B?RXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D41CEC10B9FBC94CAC69A7B9458295FF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a453b26-cb51-4b81-9f9c-08dcc580fd6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2024 03:41:37.7511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8II5KUKVpdSm6CgAeRSLtDRzZ+UEvlSNzxA6gDm7u44ThUzEDqTIuGCHEK6nETxoZrzfnz2hUceCKhPZ18/qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8625
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--25.984200-8.000000
X-TMASE-MatchedRID: c/HXCguHooHUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu/HSsb509cZ3+Vi
	hXqn9xLEP80PorF/Kagek1pVnTxUSCbGesVc9cmQR0Wxq9RAoB4GMvMvh2j5WxSZxKZrfThMqBv
	wF+qucajSmGhhbqeH8fkECcE2DrfJkwsxe1DtvMe7KTDtx8CggBGvINcfHqhcUCxNejJnwy/pGc
	UVZJmzPpF1wEVRw4KpZo3MLgN1I0BgHZ8655DOP0gVVXNgaM0pyZ8zcONpAscRB0bsfrpPI6T/L
	TDsmJmg=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--25.984200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	EAB59C2CF270A110F26A91ED8B13DD8C264F0D6AB2E84B3B7E231CC8C32FED2A2000:8
X-MTK: N

T24gRnJpLCAyMDI0LTA4LTIzIGF0IDA5OjIwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yMy8yNCAzOjA3IEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBpbmRleCAwYjNkMGM4ZTBkZGEuLjRiY2Q0
ZTViNjJiZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4g
KysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IEBAIC02NDgyLDggKzY0ODIsMTIg
QEAgc3RhdGljIGJvb2wgdWZzaGNkX2Fib3J0X29uZShzdHJ1Y3QgcmVxdWVzdA0KPiAqcnEsIHZv
aWQgKnByaXYpDQo+ID4gICBpZiAoIWh3cSkNCj4gPiAgIHJldHVybiAwOw0KPiA+ICAgc3Bpbl9s
b2NrX2lycXNhdmUoJmh3cS0+Y3FfbG9jaywgZmxhZ3MpOw0KPiA+IC1pZiAodWZzaGNkX2NtZF9p
bmZsaWdodChscmJwLT5jbWQpKQ0KPiA+ICtpZiAodWZzaGNkX2NtZF9pbmZsaWdodChscmJwLT5j
bWQpKSB7DQo+ID4gK3N0cnVjdCBzY3NpX2NtbmQgKmNtZCA9IGxyYnAtPmNtZDsNCj4gPiArc2V0
X2hvc3RfYnl0ZShjbWQsIERJRF9SRVFVRVVFKTsNCj4gPiAgIHVmc2hjZF9yZWxlYXNlX3Njc2lf
Y21kKGhiYSwgbHJicCk7DQo+ID4gK3Njc2lfZG9uZShjbWQpOw0KPiA+ICt9DQo+ID4gICBzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZod3EtPmNxX2xvY2ssIGZsYWdzKTsNCj4gPiAgIH0NCj4gDQo+
IEhtbSAuLi4gaXNuJ3QgdGhlIHVmc2hjZF9jb21wbGV0ZV9yZXF1ZXN0cygpIGNhbGwgaW4NCj4g
dWZzaGNkX2Fib3J0X2FsbCgpDQo+IGV4cGVjdGVkIHRvIGNvbXBsZXRlIHRoZXNlIGNvbW1hbmRz
PyBDYW4gdGhlIGFib3ZlIGNoYW5nZSBsZWFkIHRvDQo+IHNjc2lfZG9uZSgpIGJlaW5nIGNhbGxl
ZCB0d2ljZSwgc29tZXRoaW5nIHRoYXQgaXMgbm90IGFsbG93ZWQ/DQo+IA0KPiBCYXJ0Lg0KPiAN
Cg0KSGkgQmFydCwNCg0KdWZzaGNkX2NvbXBsZXRlX3JlcXVlc3RzIGNhbGwgaW4gdWZzaGNkX2Fi
b3J0X2FsbCgpIHdpdGggDQpmb3JjZV9jb21wbCA9IGZhbHNlIGluIG1jcSBtb2RlLCB3aGljaCBv
bmx5IGNoZWNrIGNxIGlzIGVtcHR5IG9yIG5vdC4NCkZvciBhbHJlYWR5IGFib3J0IGNtZCwgbm8g
cmVzcG9uc2Ugd2lsbCBjb21lIGJhY2sgYW5kIG5vIGNxIA0Kc2xvdCBpbnNlcnQgYnkgaGFyZHdh
cmUsIHdoaWNoIHdlIG5lZWQgcmVsZWFzZSB0aGlzIGNtZCBhbmQgc2NzaSBkb25lLA0Kc2FtZSBh
cyBmb3JjZV9jb21wbCA9IHRydWUgZG9lcy4NCg0KVGhhbmtzDQpQZXRlcg0K
