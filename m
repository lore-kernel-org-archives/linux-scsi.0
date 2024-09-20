Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5995AD5B;
	Fri, 20 Sep 2024 02:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726797733; cv=fail; b=eWepvj4OAi1gvyetT//NqrI1gqFc87aXVn6hW03VDGa9UOsm9eSCH5jO5rhX+Rk5WPOtI7BZFjosdiyEHD+AyjGKsBaBxZ4gtafhKNxkjISlov3+3Q4oKnZEJxeXg/ybR/AiWpPU3Yy8YnhATqVIA/0BzN+eqtNKV5YDqR3ZZz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726797733; c=relaxed/simple;
	bh=vOnJPS1lY3Z2/6r6wJ/HMoa/f0SXL2nbjao+2utPSbc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=clm15Ja5yt1ntqjsBrRiD1aGs3SyG8j99qyupJcw0Xz7EbJJNk1oTZ3KSV4h/S4WQRSJLpi1DtN3T4+2V7vmyEhBFbBZnYydlvuc7cBIFHF3uCYMud78LM9HunPbAM8dIuJkdiiJ74S0w0vtGmEapv4CVOvBxfF41PH3HFYKxfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=JsirScBO; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=f7l5dl9S; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JsirScBO";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="f7l5dl9S"
X-UUID: 56caadd476f411ef8b96093e013ec31c-20240920
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=vOnJPS1lY3Z2/6r6wJ/HMoa/f0SXL2nbjao+2utPSbc=;
	b=JsirScBOmwt5rIXjecyk49otUW4kADJm68dRSVex3ZzvSPhj8AWeJ1LJVWcS1JT94fLDy5E6G0S2XD7LWCUauNN+zfhIhl+Arj/R9OPg+C7VWtg0ZKkSzHvlUiIDJZWa1KFJ3icObrhN+iTWF84agVK9WsANxRiDHJtqhWLrqwM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:c095e6ef-8ab5-49ea-8f0c-9f02fed8128b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:041a79d0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 56caadd476f411ef8b96093e013ec31c-20240920
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 76196742; Fri, 20 Sep 2024 10:02:07 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 20 Sep 2024 10:02:06 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 20 Sep 2024 10:02:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G0Bg95RnNmunmHIPXqY37SEAqsk9oc3XTQV5xaZUx72SuavoJDzNTaSpNR5YsU3uf9OO4RJZ/rdGRVs/gjNP2Pnxbwqy/M2jXCxJEHykwSFVO+MYS9iRYS+HqUVgeTh3HvFSl2UiIuXYsuy1cCeRu1OzdcqI2HkCZRJ6urClks4w+J6yxvO9r25bR8bayJARd9OagbXKCkhiA/4sHUw6QNuYKAsvOSfVlXLNpZVBfqOxqlKyYy5E99tTQ0ro8ro/rpZBA+ehR4Y4vG5M+4vVdECiRShxoxFTyZEWXWf4186/CS9nGTVtntlKIIjp+Sfsk/sK9cbtPMQbJcnb+0br5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOnJPS1lY3Z2/6r6wJ/HMoa/f0SXL2nbjao+2utPSbc=;
 b=dbawsjFyhtQogyBymHE0IsxUGfFbNyWr8Mxa0DuRZuOLBcxgnNgtsgK6QDXwXZLg2MlCi6wnMdySgdIATKI4QONG1YMzLtAHe0zmZ3TdEhmjnZFfN4ufzSKYe08ohBjvLjdQ3H4DgHeSzgH9iYbqgdh0wOjq6YtnsxN03DaeK4kRmQmjXlgz+DtJkBgC53Pwedg+swFKkjXhGp6RyM6JOvSl7S01f9cL7+b3NnfkGlxv103lt3RA2zgUZiPOEvDrTdDmAG6ER3BV+W3JP+8HwXH7MxB8g52BhX+wYMZb6ofgJJaXBRuCdH0vkPO8/T58lOkuxMMghyv5ByJH6DuJUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOnJPS1lY3Z2/6r6wJ/HMoa/f0SXL2nbjao+2utPSbc=;
 b=f7l5dl9SFVbugkYW+kmPgIH3iCUxoWnqz3RQagGO9gIqsin4Ls2SSg0i2He6WvWRVWHrZ+LTbpxx4DZpf6xWk2qxMnxuuNTHbztq4FtqUoVrJzyoCzywZqD7nCdZa0/u0xyTKuSi3azPMzt5fbMwXy8godA3xUMFSt6S10OjYVg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8079.apcprd03.prod.outlook.com (2603:1096:101:16b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Fri, 20 Sep
 2024 02:02:03 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7982.018; Fri, 20 Sep 2024
 02:02:03 +0000
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
Thread-Index: AQHbA1N1RX6n4EeryE2vN/rAxATc77JRT7iAgADKYQCAANwoAIABMz2AgACCMYCAAKWTAIAAsGiAgAeVY4CAAFOSgIABKiyAgABt5YCAAHjPAA==
Date: Fri, 20 Sep 2024 02:02:03 +0000
Message-ID: <4f9e2ac99bcb981b11dc6454165818c5de6fd4d6.camel@mediatek.com>
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
	 <f350a1dee5a03347b5e88b9d7249223ce7b72c08.camel@mediatek.com>
	 <beeec868-b4ac-4025-859b-35a828cd2f8e@acm.org>
In-Reply-To: <beeec868-b4ac-4025-859b-35a828cd2f8e@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8079:EE_
x-ms-office365-filtering-correlation-id: 559892cf-ff2e-4ed4-a907-08dcd91838b5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cFBMdWZFTTlmbHJleHN5T3JHUkQ4Nm0zTWpReCtEZ3hGd3pVUWxOY1piOERH?=
 =?utf-8?B?eXRtRERxMi9hVkhqTlNZQStPM0VJU3NTdnMzZ3JlMWQ3dmxpelV5VGExdVVm?=
 =?utf-8?B?K0VzWEM4bVZQeXZwZFI1ME1pV053QUpvWUNpNVJrc21wMVN3dVRRN3AyU0ZJ?=
 =?utf-8?B?ZUFYYzZoS3RrN3BFVjJxMmwxdzRUcVFHb1haNUQrUEJvdksybmdyRHZ5MjZy?=
 =?utf-8?B?L09BWVphNFAwMUpsY1JFbVhRZU1RTzJvU3Z6UG5VTUM4SEZLZVFlbjBMaTEr?=
 =?utf-8?B?SC9JbXh3NWc3d2J0VHJFWVZrYW1KNjU0M0JwTDNVNjhJYzVUVUJJMkNSSndE?=
 =?utf-8?B?RVoyTDczald6QjJ6SktUbTR4Z1AzQm5IcENhUmRwS0hpcC9GdXhRU3FVQy9K?=
 =?utf-8?B?WWZubzFoc1FGVDdQbTdiUWJzeUREL2NyUzBmMi9ZM2g3b0xiQ0xMdndzV3Y2?=
 =?utf-8?B?WGRHMlZ1cnA3RXhzOElLTTZuWWNCS1F4WHdZTFp2UTZWU0pnMFdJbklIcVg0?=
 =?utf-8?B?MXBJNFRJM0RLdm56eks4WG1MSXJwbVlJZjc1a3JGejV5Rm5JMjNHamJLckZF?=
 =?utf-8?B?TnEyY1dka2dKb1g5QUVmaU9zMnpGc2VVQTErYjQyZ0lLVHI5L1BMdTJ3NjU2?=
 =?utf-8?B?WWw3RmxBWFRTYkE4Vi9qelNaamVnNTVueDJpalFDZUg5am14WWNjTFFyTUFU?=
 =?utf-8?B?NTY2am9hRGxrbkRKejhlNGg0MHNyVGtGZGFEOEFoK0VTbXY2UUFyQlU0Qy84?=
 =?utf-8?B?OWoxcElEQ2FQZTVmMzNtVkxjTk1Iay82K2RBOGorRGlOVTN2L3hOT0NpbmQx?=
 =?utf-8?B?Zk1Bd1lIcmJqV0JqRm9MeW82cTUrTWRoQ0YreHFaWDJhSG81ODJzUDUydEVi?=
 =?utf-8?B?WmxERjdOQjBDMmRCM3dubXhudWM1TmdQWmxiS2sxZHRCZTZzNCsvTStKWlZY?=
 =?utf-8?B?c01pSFJiODZTSUpzRDU0QU9LOE9RVis3QzhSNVY5WlRQbmpRR1NOenpFRkUw?=
 =?utf-8?B?RGVUcVBtVGJ0aDVseU5lekk0am9wT2pHN0FQM2U5N2dHdlBNNXpjNDhKT0lu?=
 =?utf-8?B?cHQxUzd3QkZSYXlXL0R1SWtxT1FQM3dtY0Nrd0NyTE83YUc5cUNHejFLa1NX?=
 =?utf-8?B?dTdpdE53VEk1TnpxbXg0MjVMTk9aMlorOXp5bUFUalA4YnNWRTVYV1dja0t6?=
 =?utf-8?B?VWtRVGF2UFdJZGdFdVdidWRTdUR2WFlmaDk1VnJJQmJ5Z25vWUVHbkxENXhi?=
 =?utf-8?B?WURQaTRDT09ndzNOVi9PVWdFczBvQk5kRHpoc2x1dUk3enkrUHJRc3piaURl?=
 =?utf-8?B?NWZCdC9tdlNpZi9zVXUra0JxMFJWdmpwWGR0QUhybU1rLzB6ZWpQSGt3cndw?=
 =?utf-8?B?bWc4MmdxdldWTFJJOVROQmtVanNhdmEwQzE0TjY0cll5eExqZEo5SDcrSEQ2?=
 =?utf-8?B?NE91amxvbkxHcStzb3BEMEVGSjFwMnR0ODlYNW5IK2VoZXgvWnRuRVlBY1l3?=
 =?utf-8?B?M01qNFRVU2J0NVdmTHBYMENlYVFiVElZYXVCZHorRUExaE5YL1ZBVTFjWTQv?=
 =?utf-8?B?T2xlTXpBWEl3L2dIdU12eTlTYnpuc0pqUHhTOTlNSTBvcTFLa1lZSG5rSWZI?=
 =?utf-8?B?akpMUlNVWEVuY3VpS3RobzlzaitBcktsallTeDVhS2VsL3NOV0RsOTIxRUhR?=
 =?utf-8?B?VDF3VE1XNksyemp1N1ZTVHhDNlVDSUNWZlpURmFCM0RBdnBLb1BNRjFaRHlM?=
 =?utf-8?B?S0YwcE1pV3dGMzFtTFlCbGkwVFJ2enF6bXhOaWdLYnp6Yk16cm5WZ0FIQWpx?=
 =?utf-8?B?M2FmdjJYS29sdGRIZndQQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWFHSjc2YXZ5WC9iTXJkYllGc2NOWGpjSGJmMlQweTBsVm8yL1F4RENLZk5M?=
 =?utf-8?B?Z1NGU2pZN2RaeEIwclNSSVJOVmpqaVhxMEdranFQT3dKaUJJKzdyMTdsK1B1?=
 =?utf-8?B?S0hwR1dmRFE4ZVVlekQ1am8wdndsUzFkV051TmtuMWg5QkJVWG5YK3g5d281?=
 =?utf-8?B?R01kTTN0V2ZoN3h4TVJ6WThJcVlIKzNWTjRNS3hLNlNUNzFzdkIyNVZKNUhl?=
 =?utf-8?B?emlUNlNUejVSS1VveVpRakFCMFlyV3hLelpqc1VrdjBOQ2U4UkRrYmVlZUpH?=
 =?utf-8?B?eDNNSnVTNFVlUWxUNHNBdGhCa1FDTGEzdnZHSi80bG5ZMXRvWU9PUGtqOTJw?=
 =?utf-8?B?YnYxdUQvejlRVXd6elk1WjZPS0F6V0kwVzBWZkJ3SldHRXBISXBkTFVkNm1h?=
 =?utf-8?B?RjkrSG81UGVUQ0s5Q291WmNLNXdMbXpmY2ZrUThZNFFXVXUvaUkvc3Z5QTB3?=
 =?utf-8?B?QXpiN0ZuTm8xT2FodnB6TXJGOWtiVU9YZzRjMjJkT1dydmlaUWNnMjU2Qmgr?=
 =?utf-8?B?MXIvb1NYZ1UrTkR0eS9iVE5PbjI5VzBuR3k1aEFoODh2L2RMaDdNMVNYVHh5?=
 =?utf-8?B?bU93M3RpVzU4QWR5SGFhek9BdnpJZkx3Wk96N0hiVTNQZTFlVUtFMm4vVkpS?=
 =?utf-8?B?WXNDamhPYnJLMU5QYVdtdHVBOGRrdW42QmVTbEhZRmwxN3hWZklFQVJxYkhD?=
 =?utf-8?B?dEZ0S0hrZHRNc1RSbEt2QUk1K0xXbXhac3d1MURob1ZiYjZrQnhIcG5UOUFS?=
 =?utf-8?B?KzVCMGdzbks5WjhBd0JRNWg3V1lNYzFnU3hyU2JhQ0c5YmhlWkljZHFMLzM2?=
 =?utf-8?B?aWtHeDdEWENYTkdQd3VRb3VacjBPcmsrQk1sSDVJU05sWnRaSDFnYy9yT2R4?=
 =?utf-8?B?YzZoSy9FVU80ZFNPRFFEQWlTMTlHeno3bGxwaGwzdk9FY04vMkJaYU90a0VT?=
 =?utf-8?B?OTAvd2FkOGlNMEZxbXVHTHNPcEl5U0JUUXZhcUc1N0NHRld5cGZwR0VnUGxO?=
 =?utf-8?B?aUFITmh3VFlwcWV0dStna0hIVG4ySGNKQzBRV2J0UlFjZThsSTgzazI0ZFRG?=
 =?utf-8?B?Q1ZLNXZVNGU1QUN5MG5EVmJBWUNxNitGQU9WcTZ3UDRPb0VYS1gyUnpqaTRC?=
 =?utf-8?B?N2RnK1JyQkdvWVV5WGhKVmhMeDh6ZUpYNmVzQVRWOGc0MVd2dXJWcnZpVTEy?=
 =?utf-8?B?WVl0aXdobXprdnpEVVZPS1FSMkx3QzNzc1d4aUpUSDR5c2ZYTGhRbHRKUjdh?=
 =?utf-8?B?Vnh1Y1dGVzhCamZNOWhDc05qSmVmeTIyM0QvbDd2M0dwaUUwdnY4UjNqTW9Z?=
 =?utf-8?B?TW9HcWhxa0g1b0ZvSll0M0I5bVhBR1Y5MEpEaVVVN0J1M2lnaHR1V2JvQ3g3?=
 =?utf-8?B?TjVpZEExcGlOYUtVSlpUMzNFL0RmN2NXYnRlMTJ6R0YvcUZSbG10alYzcTgw?=
 =?utf-8?B?T0wwQWs5VHp0NG4wa2dIYk1WQmlIYkg0WHdISjFpUDV6OGtHa085K1NIUDJO?=
 =?utf-8?B?NFZsSGV4TkQ0dEtKaSt4VUYwRSszcXo3THlKWFh3SmNNMmFFc2hFMDV6QWht?=
 =?utf-8?B?NUoybkFxZGJodEw3cjZkejc1OXlVY3B1aExOekJQTURLWTdwMGdUa0lydm9M?=
 =?utf-8?B?QllIZUswS2RraUpvMlRLblJIb29VYzl2M1BRdDVROUJyandvblZBMXJ1NXg2?=
 =?utf-8?B?ZXhybWlxdnRLUmhaSGdHR2hzNk0xT09iU2JKQ2x5eUt3QWR2akNFK3J3cWZ5?=
 =?utf-8?B?ZHplZzlxNW9sR0FsTlpKWGdiM1dOQnFXd2pqcm1kVEx5M1NmQkd6UXRXM21N?=
 =?utf-8?B?T1ZEZnFyd3JFd1lRQkRrRXhPVHNXR3BXQ1JlZDhTNGdTMHdyV1VDMkhwbWQz?=
 =?utf-8?B?NEZtVlh4alNyaXFtcWFWYXBHWUJ1eVZFbUxCZVM2Rm5CcWF6cHI1Q0NCWUlJ?=
 =?utf-8?B?QldXblNjZGtiMnpRZ2twemNoY05BWnlZVStJUHpZUVpHcHdwWmVWczlFRG85?=
 =?utf-8?B?REZQTWZMWDJUanZ4OGNoYklCMXJWM25MdkZUUThwVEQ1S0lOOGxsUUplWWlN?=
 =?utf-8?B?Vy9FK3BWbXgyOUlaM3Q5VVkwYU1tU0dXZWxycjYrK1B2d21lMXh4ZkRvaDlY?=
 =?utf-8?B?OUhaZGxZS3RDRkZ3K1MvdVFKMTZvMXJoOTh1MUN3M2pLaWUzdk5veFVlWU5z?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4733A94B91D8B47887A34680D5FB67B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559892cf-ff2e-4ed4-a907-08dcd91838b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2024 02:02:03.3402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CmlhgQJoDczWVBXMU07nn1mo8L7XzIGanKQjtjZiy3IuVskK7os8mjHrGMTPeArpEeqa/KBveXIzAlTsdq57Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8079
X-MTK: N

T24gVGh1LCAyMDI0LTA5LTE5IGF0IDExOjQ5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xOS8yNCA1OjE2IEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IFRoZSBmb3VyIGNhc2UgZmxvd3MgZm9yIGFib3J0IGFyZSBhcyBmb2xs
b3dzOg0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gPiANCj4gPiBDYXNlMTogREJSIHVmc2hjZF9hYm9ydA0KPiAN
Cj4gUGxlYXNlIGZvbGxvdyB0aGUgdGVybWlub2xvZ3kgZnJvbSB0aGUgVUZTSENJIDQuMCBzdGFu
ZGFyZCBhbmQgdXNlDQo+IHRoZQ0KPiB3b3JkICJsZWdhY3kiIGluc3RlYWQgb2YgIkRCUiIuDQo+
IA0KDQpIaSBCYXJ0LA0KDQpPa2F5LCBidXQgdGhlIGN1cnJlbnQgY29kZSBjb21tZW50cyBhbGwg
dXNlICdTREIgbW9kZScuIA0KU2hvdWxkIHdlIGp1c3Qgc3RpY2sgd2l0aCB0aGF0IHRlcm0/DQoN
Cg0KPiA+IEluIHRoaXMgY2FzZSwgeW91IGNhbiBzZWUgdGhhdCB1ZnNoY2RfcmVsZWFzZV9zY3Np
X2NtZCB3aWxsDQo+ID4gZGVmaW5pdGVseSBiZSBjYWxsZWQuDQo+ID4gDQo+ID4gdWZzaGNkX2Fi
b3J0KCkNCj4gPiAgICB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKS8vIEl0IHNob3VsZCB0cmln
Z2VyIGFuDQo+ID4gaW50ZXJydXB0LCBidXQgdGhlIHRlbnNvciBtaWdodCBub3QNCj4gPiAgICBn
ZXQgb3V0c3RhbmRpbmdfbG9jaw0KPiA+ICAgIGNsZWFyIG91dHN0YW5kaW5nX3JlcXMgdGFnDQo+
ID4gICAgdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKQ0KPiA+ICAgIHJlbGVhc2Ugb3V0c3RhbmRp
bmdfbG9jaw0KPiA+IA0KPiA+IHVmc2hjZF9pbnRyKCkNCj4gPiAgICB1ZnNoY2Rfc2xfaW50cigp
DQo+ID4gICAgICB1ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkNCj4gPiAgICAgICAgdWZzaGNk
X3BvbGwoKQ0KPiA+ICAgICAgICAgIGdldCBvdXRzdGFuZGluZ19sb2NrDQo+ID4gICAgICAgICAg
Y2xlYXIgb3V0c3RhbmRpbmdfcmVxcyB0YWcNCj4gPiAgICAgICAgICByZWxlYXNlIG91dHN0YW5k
aW5nX2xvY2sNCj4gPiAgICAgICAgICBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKQ0KPiA+
ICAgICAgICAgICAgdWZzaGNkX2NvbXBsX29uZV9jcWUoKQ0KPiA+ICAgICAgICAgICAgY21kLT5y
ZXN1bHQgPSBESURfUkVRVUVVRS8vIG1lZGlhdGVrIG1heSBuZWVkIHF1aXJrDQo+ID4gY2hhbmdl
IERJRF9BQk9SVCB0byBESURfUkVRVUVVRQ0KPiA+ICAgICAgICAgICAgdWZzaGNkX3JlbGVhc2Vf
c2NzaV9jbWQoKQ0KPiA+ICAgICAgICAgICAgc2NzaV9kb25lKCk7DQo+ID4gDQo+ID4gSW4gbW9z
dCBjYXNlcywgdWZzaGNkX2ludHIgd2lsbCBub3QgcmVhY2ggc2NzaV9kb25lIGJlY2F1c2UgdGhl
DQo+ID4gb3V0c3RhbmRpbmdfcmVxcyB0YWcgaXMgY2xlYXJlZCBieSB0aGUgb3JpZ2luYWwgdGhy
ZWFkLg0KPiA+IFRoZXJlZm9yZSwgd2hldGhlciB0aGVyZSBpcyBhbiBpbnRlcnJ1cHQgb3Igbm90
IGRvZXNuJ3QgYWZmZWN0DQo+ID4gdGhlIHJlc3VsdCBiZWNhdXNlIHRoZSBJU1Igd2lsbCBkbyBu
b3RoaW5nIGluIG1vc3QgY2FzZXMuDQo+ID4gDQo+ID4gSW4gYSB2ZXJ5IGxvdyBjaGFuY2UsIHRo
ZSBJU1Igd2lsbCByZWFjaCBzY3NpX2RvbmUgYW5kIG5vdGlmeQ0KPiA+IFNDU0kgdG8gcmVxdWV1
ZSwgYW5kIHRoZSBvcmlnaW5hbCB0aHJlYWQgd2lsbCBub3QNCj4gPiBjYWxsIHVmc2hjZF9yZWxl
YXNlX3Njc2lfY21kLg0KPiA+IE1lZGlhVGVrIG1heSBuZWVkIHRvIGNoYW5nZSBESURfQUJPUlQg
dG8gRElEX1JFUVVFVUUgaW4gdGhpcw0KPiA+IHNpdHVhdGlvbiwgb3IgcGVyaGFwcyBub3QgaGFu
ZGxlIHRoaXMgSVNSIGF0IGFsbC4NCj4gDQo+IFBsZWFzZSBtb2RpZnkgdWZzaGNkX2NvbXBsX29u
ZV9jcWUoKSBzdWNoIHRoYXQgaXQgaWdub3JlcyBjb21tYW5kcw0KPiB3aXRoIHN0YXR1cyBPQ1Nf
QUJPUlRFRC4gVGhpcyB3aWxsIG1ha2UgdGhlIFVGU0hDSSBkcml2ZXIgYmVoYXZlIGluDQo+IHRo
ZSBzYW1lIHdheSBmb3IgYWxsIFVGU0hDSSBjb250cm9sbGVycywgd2hldGhlciBvciBub3QgY2xl
YXJpbmcgYQ0KPiBjb21tYW5kIHRyaWdnZXJzIGEgY29tcGxldGlvbiBpbnRlcnJ1cHQuDQo+IA0K
DQpZZXMsIEkgYW0gY29uc2lkZXJpbmcgaG93IHRvIG1vZGlmeSB0aGUgY29kZSBoZXJlLg0KDQo+
ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPiA+IA0KPiA+IENhc2UyOiBNQ1EgdWZzaGNkX2Fib3J0DQo+ID4gDQo+ID4g
SW4gdGhlIGNhc2Ugb2YgTUNRIHVmc2hjZF9hYm9ydCwgeW91IGNhbiBhbHNvIHNlZSB0aGF0DQo+
ID4gdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQgd2lsbCBkZWZpbml0ZWx5IGJlIGNhbGxlZCB0b28u
DQo+ID4gSG93ZXZlciwgdGhlcmUgc2VlbXMgdG8gYmUgYSBwcm9ibGVtIGhlcmUsIGFzDQo+ID4g
dWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQgbWlnaHQgYmUgY2FsbGVkIHR3aWNlLg0KPiA+IFRoaXMg
aXMgYmVjYXVzZSBjbWQgaXMgbm90IG51bGwgaW4gdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQsDQo+
ID4gd2hpY2ggdGhlIHByZXZpb3VzIHZlcnNpb24gd291bGQgc2V0IGNtZCB0byBudWxsLg0KPiA+
IFNraXBwaW5nIE9DUzogQUJPUlRFRCBpbiB1ZnNoY2RfY29tcGxfb25lX2NxZSBpbmRlZWQNCj4g
PiBjYW4gYXZvaWQgdGhpcyBwcm9ibGVtLiBUaGlzIHBhcnQgbmVlZHMgZnVydGhlcg0KPiA+IGNv
bnNpZGVyYXRpb24gb24gaG93IHRvIGhhbmRsZSBpdC4NCj4gPiANCj4gPiB1ZnNoY2RfYWJvcnQo
KQ0KPiA+ICAgIHVmc2hjZF9tY3FfYWJvcnQoKQ0KPiA+ICAgICAgdWZzaGNkX3RyeV90b19hYm9y
dF90YXNrKCkvLyB3aWxsIHRyaWdnZXIgSVNSDQo+ID4gICAgICB1ZnNoY2RfcmVsZWFzZV9zY3Np
X2NtZCgpDQo+ID4gDQo+ID4gdWZzX210a19tY3FfaW50cigpDQo+ID4gICAgdWZzaGNkX21jcV9w
b2xsX2NxZV9sb2NrKCkNCj4gPiAgICAgIHVmc2hjZF9tY3FfcHJvY2Vzc19jcWUoKQ0KPiA+ICAg
ICAgICB1ZnNoY2RfY29tcGxfb25lX2NxZSgpDQo+ID4gICAgICAgICAgY21kLT5yZXN1bHQgPSBE
SURfQUJPUlQNCj4gPiAgICAgICAgICB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCgpIC8vIHdpbGwg
cmVsZWFzZSB0d2ljZQ0KPiA+ICAgICAgICAgIHNjc2lfZG9uZSgpDQo+IA0KPiBEbyB5b3UgYWdy
ZWUgdGhhdCB0aGlzIGNhc2UgY2FuIGJlIGFkZHJlc3NlZCB3aXRoIHRoZQ0KPiB1ZnNoY2RfY29t
cGxfb25lX2NxZSgpIGNoYW5nZSBwcm9wb3NlZCBhYm92ZT8NCj4gDQoNCkFncmVlLg0KDQo+ID4g
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KPiA+IA0KPiA+IENhc2UzOiBEQlIgdWZzaGNkX2Vycl9oYW5kbGVyDQo+ID4gDQo+
ID4gSW4gdGhlIGNhc2Ugb2YgdGhlIERCUiBtb2RlIGVycm9yIGhhbmRsZXIsIGl0J3MgdGhlIHNh
bWU7DQo+ID4gdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQgd2lsbCBhbHNvIGJlIGV4ZWN1dGVkLCBh
bmQgc2NzaV9kb25lDQo+ID4gd2lsbCBkZWZpbml0ZWx5IGJlIHVzZWQgdG8gbm90aWZ5IFNDU0kg
dG8gcmVxdWV1ZS4NCj4gPiANCj4gPiB1ZnNoY2RfZXJyX2hhbmRsZXIoKQ0KPiA+ICAgIHVmc2hj
ZF9hYm9ydF9hbGwoKQ0KPiA+ICAgICAgdWZzaGNkX2Fib3J0X29uZSgpDQo+ID4gICAgICAgIHVm
c2hjZF90cnlfdG9fYWJvcnRfdGFzaygpLy8gSXQgc2hvdWxkIHRyaWdnZXIgYW4NCj4gPiBpbnRl
cnJ1cHQsIGJ1dCB0aGUgdGVuc29yIG1pZ2h0IG5vdA0KPiA+ICAgICAgdWZzaGNkX2NvbXBsZXRl
X3JlcXVlc3RzKCkNCj4gPiAgICAgICAgdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpDQo+ID4g
ICAgICAgICAgdWZzaGNkX3BvbGwoKQ0KPiA+ICAgICAgICAgICAgZ2V0IG91dHN0YW5kaW5nX2xv
Y2sNCj4gPiAgICAgICAgICAgIGNsZWFyIG91dHN0YW5kaW5nX3JlcXMgdGFnDQo+ID4gICAgICAg
ICAgICByZWxlYXNlIG91dHN0YW5kaW5nX2xvY2sNCj4gPiAgICAgICAgICAgIF9fdWZzaGNkX3Ry
YW5zZmVyX3JlcV9jb21wbCgpDQo+ID4gICAgICAgICAgICAgIHVmc2hjZF9jb21wbF9vbmVfY3Fl
KCkNCj4gPiAgICAgICAgICAgICAgICBjbWQtPnJlc3VsdCA9IERJRF9SRVFVRVVFIC8vIG1lZGlh
dGVrIG1heSBuZWVkIHF1aXJrDQo+ID4gY2hhbmdlIERJRF9BQk9SVCB0byBESURfUkVRVUVVRQ0K
PiA+ICAgICAgICAgICAgICAgIHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKCkNCj4gPiAgICAgICAg
ICAgICAgICBzY3NpX2RvbmUoKQ0KPiA+IA0KPiA+IHVmc2hjZF9pbnRyKCkNCj4gPiAgICB1ZnNo
Y2Rfc2xfaW50cigpDQo+ID4gICAgICB1ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkNCj4gPiAg
ICAgICAgdWZzaGNkX3BvbGwoKQ0KPiA+ICAgICAgICAgIGdldCBvdXRzdGFuZGluZ19sb2NrDQo+
ID4gICAgICAgICAgY2xlYXIgb3V0c3RhbmRpbmdfcmVxcyB0YWcNCj4gPiAgICAgICAgICByZWxl
YXNlIG91dHN0YW5kaW5nX2xvY2sNCj4gPiAgICAgICAgICBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFf
Y29tcGwoKQ0KPiA+ICAgICAgICAgICAgdWZzaGNkX2NvbXBsX29uZV9jcWUoKQ0KPiA+ICAgICAg
ICAgICAgY21kLT5yZXN1bHQgPSBESURfUkVRVUVVRSAvLyBtZWRpYXRlayBtYXkgbmVlZCBxdWly
aw0KPiBjaGFuZ2UNCj4gPiBESURfQUJPUlQgdG8gRElEX1JFUVVFVUUNCj4gPiAgICAgICAgICAg
IHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKCkNCj4gPiAgICAgICAgICAgIHNjc2lfZG9uZSgpOw0K
PiA+IA0KPiA+IEF0IHRoaXMgdGltZSwgdGhlIHNhbWUgYWN0aW9ucyBhcmUgdGFrZW4gcmVnYXJk
bGVzcyBvZiB3aGV0aGVyDQo+ID4gdGhlcmUgaXMgYW4gSVNSLCBhbmQgd2l0aCB0aGUgcHJvdGVj
dGlvbiBvZiBvdXRzdGFuZGluZ19sb2NrLA0KPiA+IG9ubHkgb25lIHRocmVhZCB3aWxsIGV4ZWN1
dGUgdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQgYW5kIHNjc2lfZG9uZS4NCj4gPiAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
ID4gDQo+ID4gQ2FzZTQ6IE1DUSB1ZnNoY2RfZXJyX2hhbmRsZXINCj4gPiANCj4gPiBJdCdzIHRo
ZSBzYW1lIHdpdGggTUNRIG1vZGU7IHRoZXJlIGlzIHByb3RlY3Rpb24gZnJvbSB0aGUgY3FlIGxv
Y2ssDQo+ID4gc28gb25seSBvbmUgdGhyZWFkIHdpbGwgZXhlY3V0ZS4gV2hhdCBteSBwYXRjaCAy
IGFpbXMgdG8gZG8gaXMgdG8NCj4gPiBjaGFuZ2UgRElEX0FCT1JUIHRvIERJRF9SRVFVRVVFIGlu
IHRoaXMgc2l0dWF0aW9uLg0KPiA+IA0KPiA+IHVmc2hjZF9lcnJfaGFuZGxlcigpDQo+ID4gICAg
dWZzaGNkX2Fib3J0X2FsbCgpDQo+ID4gICAgICB1ZnNoY2RfYWJvcnRfb25lKCkNCj4gPiAgICAg
ICAgdWZzaGNkX3RyeV90b19hYm9ydF90YXNrKCkvLyB3aWxsIHRyaWdnZXIgaXJxIHRocmVhZA0K
PiA+ICAgICAgdWZzaGNkX2NvbXBsZXRlX3JlcXVlc3RzKCkNCj4gPiAgICAgICAgdWZzaGNkX21j
cV9jb21wbF9wZW5kaW5nX3RyYW5zZmVyKCkNCj4gPiAgICAgICAgICB1ZnNoY2RfbWNxX3BvbGxf
Y3FlX2xvY2soKQ0KPiA+ICAgICAgICAgICAgdWZzaGNkX21jcV9wcm9jZXNzX2NxZSgpDQo+ID4g
ICAgICAgICAgICAgIHVmc2hjZF9jb21wbF9vbmVfY3FlKCkNCj4gPiAgICAgICAgICAgICAgICBj
bWQtPnJlc3VsdCA9IERJRF9BQk9SVCAvLyBzaG91bGQgY2hhbmdlIHRvDQo+IERJRF9SRVFVRVVF
DQo+ID4gICAgICAgICAgICAgICAgdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKQ0KPiA+ICAgICAg
ICAgICAgICAgIHNjc2lfZG9uZSgpDQo+ID4gDQo+ID4gdWZzX210a19tY3FfaW50cigpDQo+ID4g
ICAgdWZzaGNkX21jcV9wb2xsX2NxZV9sb2NrKCkNCj4gPiAgICAgIHVmc2hjZF9tY3FfcHJvY2Vz
c19jcWUoKQ0KPiA+ICAgICAgICB1ZnNoY2RfY29tcGxfb25lX2NxZSgpDQo+ID4gICAgICAgICAg
Y21kLT5yZXN1bHQgPSBESURfQUJPUlQgIC8vIHNob3VsZCBjaGFuZ2UgdG8gRElEX1JFUVVFVUUN
Cj4gPiAgICAgICAgICB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCgpDQo+ID4gICAgICAgICAgc2Nz
aV9kb25lKCkNCj4gDQo+IEZvciBsZWdhY3kgYW5kIE1DUSBtb2RlLCBJIHByZWZlciB0aGUgZm9s
bG93aW5nIGJlaGF2aW9yIGZvcg0KPiB1ZnNoY2RfYWJvcnRfYWxsKCk6DQo+ICogdWZzaGNkX2Nv
bXBsX29uZV9jcWUoKSBpZ25vcmVzIGNvbW1hbmRzIHdpdGggc3RhdHVzIE9DU19BQk9SVEVELg0K
PiAqIHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKCkgaXMgY2FsbGVkIGVpdGhlciBieSB1ZnNoY2Rf
YWJvcnRfb25lKCkgb3INCj4gICAgYnkgdWZzaGNkX2Fib3J0X2FsbCgpLg0KPiANCj4gRG8geW91
IGFncmVlIHdpdGggbWFraW5nIHRoZSBjaGFuZ2VzIHByb3Bvc2VkIGFib3ZlPw0KPiANCj4gVGhh
bmsgeW91LA0KDQpUaGlzIG1pZ2h0IG5vdCB3b3JrLCBhcyBTREIgbW9kZSBkb2Vzbid0IGlnbm9y
ZSANCk9DUzogSU5WQUxJRF9PQ1NfVkFMVUUgYnV0IHJhdGhlciBub3RpZmllcyBTQ1NJIHRvIHJl
cXVldWUuIA0KU28gd2hhdCB3ZSBuZWVkIHRvIGNvcnJlY3QgaXMgdG8gbm90aWZ5IFNDU0kgdG8g
cmVxdWV1ZSANCndoZW4gTUNRIG1vZGUgcmVjZWl2ZXMgT0NTOiBBQk9SVEVEIGFzIHdlbGwuDQoN
CkZ1cnRoZXJtb3JlLCB1ZnNoY2RfY29tcGxfb25lX2NxZSwgd2hldGhlciBpdCBjb21lcyBmcm9t
IA0KdWZzaGNkX2Fib3J0X2FsbCBvciBJU1IsIGRvZXMgdGhlIHNhbWUgdGhpbmcgYW5kIGlzIHBy
b3RlY3RlZCANCmJ5IGEgbG9jay4gVGhlcmVmb3JlLCB0aGVyZSBpcyBubyBuZWVkIGZvciBzcGVj
aWFsIGhhbmRsaW5nIA0Kc3BlY2lmaWNhbGx5IGZvciB1ZnNoY2RfYWJvcnRfYWxsLg0KDQpBZnRl
ciBkaXNjdXNzaW5nIHdpdGggeW91LCBJIHJlYWxpemVkIHRoYXQgdGhlcmUgYXJlIGluZGVlZCBt
YW55IA0KZGVmaWNpZW5jaWVzIGFuZCBpbmNvbnNpc3RlbmNpZXMgaGVyZSB0aGF0IG5lZWQgdG8g
YmUgYWRkcmVzc2VkLiANCkkgd2lsbCBzdWJtaXQgYSBuZXcgcGF0Y2ggZm9yIHRoZSBjb250ZW50
IGRpc2N1c3NlZCBhYm92ZS4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQoNCj4gDQo+IEJhcg0K
