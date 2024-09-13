Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD832AE9F;
	Fri, 13 Sep 2024 07:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726211937; cv=fail; b=eHD486V5quDjhF09XmfuIdSYrRSW4W2GgqqWqTeL6fdK6he5jjq5vhivKI4RvyV6PP13pdsgQREiWKQR3AlvPsGNZ4I8LNdSmuHkk2yVtErfbp7pldbiDFz0rlaXX0xHBNJw6QffW+1i0dVOY3uEoJcYeHTmg337cp7RqCMX5as=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726211937; c=relaxed/simple;
	bh=zMWtvINfRxbrs0pm5gwy3JMwIghikSw45vgaCJniXDM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C8lTq4kURmcDl2Y/CTckI6RHAXjs6M0SuPj9MBhuFmEcOCFDjzIlDng1flapKSyyqEzHUnLId/Tw9duQ7L5zmgjqSAsyT17Nc+nvds8ddg2I+u4Y27R6RhZzgx3Ll7Jwet3H/a2IBk8pdXHNwoS/vkq7zC0rx5Aex/FDTGPOA3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=g8FbOfNF; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=V+7iHHgf; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="g8FbOfNF";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="V+7iHHgf"
X-UUID: 67c7c9c271a011ef8b96093e013ec31c-20240913
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=zMWtvINfRxbrs0pm5gwy3JMwIghikSw45vgaCJniXDM=;
	b=g8FbOfNF4oTXS88/TdXhFzMrPV1XjQu2hQIB2WUbV+ZT94q7h3T5OeCpPX5O/2B/fqogW8kMdweMBS11Xm+PLDdYTCvxfx469iLSaeLdlegu4F8Jb1bGJsnCZ9YVx2BUV7pIRvjoTfPviLtMl0/GF5JRmLH5mGpP2Vd8cC1o/LY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:5ee4e2f0-5eb2-49ea-9c5b-916da3ef0a75,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:9c90e8bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 67c7c9c271a011ef8b96093e013ec31c-20240913
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 933787710; Fri, 13 Sep 2024 15:18:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 13 Sep 2024 15:18:40 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 13 Sep 2024 15:18:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBTNZZeHo8rzPQyVrDfwUx5LMhwbKo6WuX8tKcZo30EXZyNZUXQ3vPMxSRZXvoap/EWOyFYc565fu0ePMjBlc4PNLz9r4X450vp3X+howCghTG72XkcVzVri29VEt1kDQ23KstmNLtmN2TDz7Cou/dDlzg3pQAM0YWTDIIq0GaYic62Xs6wuyqLH2jRuExT+XeKmNjHq8H3UuXoGj7I24SAYbC7bAMW3ZXHktFtuSU5VWGiW1HFFRsiczEZaUZFZ2aB/iBjUP7xVEWwNVVqeeoTOyS9ZrqVNCVr2k13hUzV1UvkEcVzGVkKvy4DZWWx+vAeoVLpVMrr950pnyjKBkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMWtvINfRxbrs0pm5gwy3JMwIghikSw45vgaCJniXDM=;
 b=hMgLHDgSX+6wok64Sz/HXyCO8v9tyHKJwrmdavDE7yptvJoBvxzxwDfO1PusvsVPQjJeniKD5NkDgusrj2kLjF+zLwdsC3e6JvevOcBetPOJAJ0IbCnm4ef3a5bdrB/JVrh2oLNDBHGKuvYMUb35ZlW+O+p1oU7X4gtqdmHcDtMETVellbldfoLoykTuXfsLLH4oXkPAUA4dlsIvOw0UJNPS2GdJsllb4vDqEcqpOGPKF1dt2HWMt/ZuJKjSx6K/TdUCIT9twU3WRmMGXWdhHMTvPAQ6kP2QfMgySQESjgZixumC9pXzcOr8Z9HnDcU+Om8K3Ck067cZXDvyDIWqRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMWtvINfRxbrs0pm5gwy3JMwIghikSw45vgaCJniXDM=;
 b=V+7iHHgfMfFc/FVgJcB3AgmTlLXlKwzTbRk+O5Ohr0hiiTtLRYwbqVJA8+Tx6TBusHpA44UcbT2YcENpRCk0J8Mr4nncYXuAY7VYsFiKW854UdTr7EI9PPxFNMXNy97pJcPn8TbgX49AGRKw6ORk2pD9u3AYzrSo0QBEb52uVtQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6534.apcprd03.prod.outlook.com (2603:1096:400:21e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Fri, 13 Sep
 2024 07:18:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Fri, 13 Sep 2024
 07:18:36 +0000
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
Subject: Re: [PATCH v6 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v6 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbBDD/9ei8+tLWLUyRJBqnfUZ7o7JS+5wAgAExGYCAAHuoAIAAqYuA
Date: Fri, 13 Sep 2024 07:18:36 +0000
Message-ID: <0e4332fefcb20ca50ff6716d0a41b26b708ac605.camel@mediatek.com>
References: <20240911095622.19225-1-peter.wang@mediatek.com>
	 <20240911095622.19225-3-peter.wang@mediatek.com>
	 <55d2cca5-0e30-4734-aa25-d5f5cdfbfd93@acm.org>
	 <d3306f9d2b88c5b6ae8d2104041e5c941898dee5.camel@mediatek.com>
	 <cad4804b-2102-4c95-9387-a63ff847cf21@acm.org>
In-Reply-To: <cad4804b-2102-4c95-9387-a63ff847cf21@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6534:EE_
x-ms-office365-filtering-correlation-id: 603a69e6-240a-4819-16ed-08dcd3c4488b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WDZkMG1yZi9KT0VoV3kyek9pYXcxUXdlckdvdDBNcEhwVXhvaWJwNGJJNEhy?=
 =?utf-8?B?bVpOemIyQlc0UGxCeDdYTWkrNVdkK3RKMkFCTmRHVEFqYkJnSkNWOGd3ZDFt?=
 =?utf-8?B?NDU0TklYcmswUzZmQVVrZ3I5czEwNmt1ME9tdERnL0ViWkZIb05YbjVmV1Zn?=
 =?utf-8?B?WktadCtINXV4TlVFZmxmREFzcHZBdTg4RHMzblMrd0x2RVJuUVdlUXZ1U3pT?=
 =?utf-8?B?TVREQ2dQVlJFY1ZNdDZYMVpITDhXb25ZekJISitGciswZ3RQdFlIeERoZXps?=
 =?utf-8?B?bWZkL291bXdLd0lMOVFDYW1TUkdlc01mNDYxSWkrUzZod0lpVnlKcWZkS0JR?=
 =?utf-8?B?QmpseHpjZXlQUUpHbzEvMGJ0UnZyWjJRYkEwd0tMamorY29zZm1tTzFZUU1u?=
 =?utf-8?B?NkRQczBHY0l0N3NPK2dyRDFVVm1OVXJFOWxIS3g1dFVyM2w0cVZwdUI1UHdV?=
 =?utf-8?B?RHJtcXFEQ1l5N0VxWkk5aVdPSjFSZHRtUlVsZzZPVVFFeXVtSmp4eldTQTFa?=
 =?utf-8?B?emtmdmxyUXpaMEo0bGxUQ1l2bXQ4QVN0SnB2dk1iYTdRdzdIZ0w2eVU0cE5s?=
 =?utf-8?B?NVV1bWtlOWRTS2NicnBZUWYwUTYySWFHWTlvUU8vdDNGS0p5SFpVZ1ZWdnhn?=
 =?utf-8?B?WExWWmJteWdBcjhZRnVZWTZ2T0xpKys0dERRQ2VQV0NhRTBDbkdDZXNtdDFE?=
 =?utf-8?B?bHcvYmxQVHdWckFyVHJMajBTVCtyOWdrcVZnS2VCRURoWEhqZEdkVkVuaWlj?=
 =?utf-8?B?cFROWUxTbk9MRGZDUFpkcEl2N0FtQnRIM3ErTEt3L3pjVEExVUFSNDl4MGdQ?=
 =?utf-8?B?U0NRb3JJOTZ2QXBtN2JxSnNiV2hSd093RUxhTW5XTzAwMkREYzJ1T1dDa3Rv?=
 =?utf-8?B?aVpRcGtONTBFanBvZnp3Znh1RktoNXNuZTh1cVdJZkxXZGNtaU9HemJYL2JU?=
 =?utf-8?B?S3BJazhxeEdHVlRPdUlsYnl6UFQ4by85VlpCNUswNy9FaElPYXhwVHJkWGxo?=
 =?utf-8?B?R3k3Q0NPdC9ybG1DZi9XMUpyRjZCQWVDUmtUdzdOQmM4aUFxeEdGYVNqNnho?=
 =?utf-8?B?ZDYyOUtJOUpBQlE3RzhmN2ZmajFuMk03Y3hYWmhRUHkwa2NIcFlNNkhLc0Ft?=
 =?utf-8?B?dElzMHBJZStPem50K2dpdjA0SWo4SGZnZkNlRGJtTFppUUVJb3lmVmMwT0Yy?=
 =?utf-8?B?MGtBYzVYSW82cUFueThFSmN6VWRzamJsWFRWaE1KQkJGcHlESmVMRXBZcEZ0?=
 =?utf-8?B?YjluVFVVclZkRUFTdVFPZGxLd1lyRkFmbWhnWUJURndnaEk1OGZwOVlFcCt6?=
 =?utf-8?B?anFrYzhsdFh2ODhIOWJlNTNQR1ZwL0xkcFZ5aHhrcXRZU3hUSEFxeEU3RGZZ?=
 =?utf-8?B?czRIN1FoeGxSKzhqSm9FeXR4RkJBN3p2NFNHU095cGRSNC9wSWpPSDNLczdB?=
 =?utf-8?B?SlQ5U3JNRUFPSFFyeGIvYVcvWTV1K2VadW5Pa0tUNFdGdWJkK0d4NEVub0RB?=
 =?utf-8?B?U09yZ1RCa2xhU3dFMU82bitzZGY5N2FVVVdRNXMrNWdvelRENVhudVkzOXg3?=
 =?utf-8?B?dDNqbTBTcEhRU3NsWlJOQ2xFMlBUcSt3dHVqYWJ0emlid1lDazlydEY0VHBV?=
 =?utf-8?B?WXhQMU51L0hwTnc0ajhkbGhwcXhZckk4M2NRV1VwWld0KzhCMlR1UHFPWkJK?=
 =?utf-8?B?YXNjM1BFSTNKekNJUGV0YUw2L291N2JPTk0yZDgrZWZZckkwYi9rNFVOUGRU?=
 =?utf-8?B?dXdGcmdCNDd6Nm1wN2MwWkhHTncvYVZPMEFLMi83NVN1cmNyZ3lJMXZrTVlI?=
 =?utf-8?B?dEJpNTRJMy91eWlMMTRYQjl0U1FJNVVJTzNjRTl1M3dBeVM3cGw4T2Q1TG1C?=
 =?utf-8?B?SWV6SVhIQ3ZQYU1QYlpVRmdzUFQzVVdoeDhwcy9CSzRUN2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWFmSXVFUTI4N2tVVzJ6cmd4OER5VmdwUXZSN1MrMzZXZk9RMENvL20vL2Fm?=
 =?utf-8?B?NXJ3OWVCdGZ0anFPd0Y4ZjVvT08rMGZsdjZ2eEpoTGRlTnVVMzY5dHFtTEVn?=
 =?utf-8?B?WFozKzNiMUNvMk92T3UwbXpGRytOL2tkQjZkemh1ZlAvRUh0RzgxTWJaN295?=
 =?utf-8?B?Ry90aHVkbGNnOEdLcGowdU8rN1JPWjVBalpmZFU3NFp2VlBHa3JIRUtTZ3ow?=
 =?utf-8?B?QUsrL0tlUStJSnNaSU1vZmFTU0FaaVVyYVhJY3N6b0lRWUY4RmNIY1lTWmJI?=
 =?utf-8?B?T1Z1S1orUUw4bzBMWitBVkIrODZQYkFwK1RGY0JGN2llRzJ5WTAwSlJUN2l2?=
 =?utf-8?B?VWJ3VXA1TktNWlI3Z1FEaTZ2K0MvdE9pV1JGRFVaQkN6aHpNMVRITTJYaWdI?=
 =?utf-8?B?dEdzYWxSSnM5R09sU0VyczhuYkNTL1JicXQzTXczM214U2FRZE9IZVVkMjBS?=
 =?utf-8?B?TjBmckdGYzVzT3RQczJ1RG1lZE5WcGprQkhBaGQrNEo2MGFJU1BWaC91anVZ?=
 =?utf-8?B?RlBhY1BYd2JleTVqenphTGNucUptclJsZkdEc0c3WG8zZkpxQ0RpRWV5YS9E?=
 =?utf-8?B?SzhwQ0dSRitsWVVDZEhWY0ZmL09lUjJKMjdDSHdQQWdXenRjNnVRNjFRNzJE?=
 =?utf-8?B?bnRnTDJ2cjJrVEtlUkEwWEpvbnpEV05xMnR4Tm9HQ3FYSTFEQ3JaWmZhM3dk?=
 =?utf-8?B?QXlreEZHSzNxNmxzaXVSYzh6bjZSN2FaaWtLZFpiZkV1L09WQW9KeFhYUGoz?=
 =?utf-8?B?RWNnbmYzYS9abmZ6aHpMMHJjMzRTVXIwNEg0N28xM1kxeU9NMlZsTjZKQzhC?=
 =?utf-8?B?alM2dis3Q29LMEM2aUNDZlRid0QySUh6dEE3NVZUL1dyZUdjNVgwRHN5ZWFJ?=
 =?utf-8?B?L3hialpIWGhsWmNLVlNJM09jRmk3UmxxQmxReS9OZFF5bm5tTitLWVYwRGg2?=
 =?utf-8?B?SGxpZEM5VURiTDFZbGJ4RUFIbGpodmJucFNUNjNrNW0vd0JPdDZEM1pQNFF0?=
 =?utf-8?B?THBjNFRld1hnR1NmeW1iTDdjYzRBNlBubHNEb0NUWWoxVzVJa0lGRDFmZGJh?=
 =?utf-8?B?Sit5ZkJJNkJ5Z2tpZkNMcmVOYm4xcHNLNFhDQXU3RU1Rckt0NWgzQ2JsWC9X?=
 =?utf-8?B?SGpybnZENEZMWU4vS1JUUklyOU9FU2FHNjN2TE82Y1hpd2h1RFhDR3M1Z3h2?=
 =?utf-8?B?bHhrYlVhTmNmREh0RWZ6UTZGRnVxUG5YQkNWa2dodlM4UXRDVy83Sm5aNkVp?=
 =?utf-8?B?MXNHcWM2Zm0zWjJGTEViS2hjcjhoSjRET05oVnl5emFYSHhja1JMeFYzZk9G?=
 =?utf-8?B?SXJGckV2YkRPeGJjTHZ3Uml1SzhianBuK1d2WGtub1V2dEp1VW9jWUpaekRu?=
 =?utf-8?B?SU1sbTZuZ0cyWVIvVEdTd3Fmdy9uNVVMWW5vU1lmTVE2Vy8raTVGaitCNkZY?=
 =?utf-8?B?ZUNSNERPOXhXNW5EdFhjeDUzZ3RRc3RURitnT2N1VmxNMGxMNHpqMkRCeXFz?=
 =?utf-8?B?K2cyWTA0OEVqU0Q5ajA4LzRBVHc3SElEV3RyWHFQbFFYUWd3QXpheVg3ZWFI?=
 =?utf-8?B?L2ZETTUyRHNqS0tLdkVQazhMNFBwTEhxWUpuMCtRVVhhNDRaenRZNlZwOXFL?=
 =?utf-8?B?SlViM2ZsZkdHMHlmeWladkcwWXhXeEYyTGJPMWd2V3d0dmg1UXp2d1pXOSs0?=
 =?utf-8?B?eVhHeVN0eG5aOTRQaGlOeFE2QWNwd3NzY0s5UTYwR0dzTjVEWEpzekJqU1Az?=
 =?utf-8?B?Q01tQkpBMUZMblpFeFVXQklNVUEzT0RvUFlhM3o4UWhpbGlJQS9OKzdlajE5?=
 =?utf-8?B?STJmZ1g4RlZQS1hzZFlKbTQ2azdGcFFkVGR1WU56c0ZBN3R4empqYkZCN2Rk?=
 =?utf-8?B?TlEweTZjWFErSFRVdk5ubUJaNEE0QXIrNHpQSStxMWwwRjE4aUNyeDdjd20v?=
 =?utf-8?B?S1RCSmlSaEdwTDcwelJiTGNJdk1XYU9rNnJwbTZzZGRsczhjSFd4S016c1hE?=
 =?utf-8?B?SDBwZzRrSjN5WFVtUG9MVDZaNUd3cElpa2gwY2pjKzJUY2dyVkhHdGRUSFlm?=
 =?utf-8?B?b245TXNEbEg4N3kvb2lHU01iMU1KTXd3ZFN2YVY3TGxMU1h6Y0FlQWZTRTRv?=
 =?utf-8?B?eGtsSEhuMndtUjRWOHd3bm9CWUNWUG1VTWs1RXdaRmMvc2YwekFJOGh2TCtL?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B730D00403ECDC48B31EEA20CBA8501D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 603a69e6-240a-4819-16ed-08dcd3c4488b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 07:18:36.3652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ufyJ9QUxfeC2WnTbK/9za6g38x0tU5dznpiK9w4/HSzonURAxRtNkUQAdqWpBis6AvWZ/YGlU0vPnBdO/bGpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6534
X-MTK: N

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDE0OjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xMi8yNCA2OjQ5IEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyNC0wOS0xMSBhdCAxMjozNyAtMDcwMCwgQmFydCBW
YW4gQXNzY2hlIHdyb3RlOg0KPiBbIC4uLiBdDQo+ID4gU28gYXQgdGhpcyB0aW1lLCB0aGUgZGV2
aWNlIHdpbGwgbm90IGhhdmUgYSBjb3JyZXNwb25kaW5nDQo+ID4gcmVzcG9uc2UgY29taW5nIGJh
Y2suIFRoZSBob3N0IGNvbnRyb2xsZXIgd2lsbCBhdXRvbWF0aWNhbGx5DQo+ID4gZmlsbCBpbiB0
aGUgcmVzcG9uc2UgZm9yIHRoZSBjb3JyZXNwb25kaW5nIGNvbW1hbmQgYmFzZWQgb24NCj4gPiB0
aGUgcmVzdWx0cyBvZiBTUSBjbGVhbnVwIChNQ1EpIG9yIFVUUkxDTFIgKERCUiwgbWVkaWF0ZWsp
LA0KPiA+IHdpdGggdGhlIENPUyBjb250ZW50IGJlaW5nIEFCT1JURUQgYnkgaW50ZXJydXB0Lg0K
PiANCj4gSSBkb24ndCB0aGluayBzby4gSW4gU0RCIG1vZGUsIHdyaXRpbmcgaW50byB0aGUgVVRS
TENMUiByZWdpc3RlciBkb2VzDQo+IE5PVCBjYXVzZSB0aGUgQUJPUlRFRCBzdGF0dXMgdG8gYmUg
d3JpdHRlbiBpbnRvIHRoZSBPQ1MgZmllbGQuIEV2ZW4NCj4gaWYNCj4gdGhlcmUgd291bGQgYmUg
VUZTSENJIGNvbnRyb2xsZXJzIHRoYXQgZG8gdGhpcywgdGhlIFVGU0hDSQ0KPiBzcGVjaWZpY2F0
aW9uDQo+IGRvZXMgbm90IHJlcXVpcmUgdGhpcyBiZWhhdmlvciBhbmQgaGVuY2UgdGhlIFVGUyBk
cml2ZXIgc2hvdWxkIG5vdA0KPiBhc3N1bWUgdGhpcyBiZWhhdmlvci4NCj4gDQoNCkhpIEJhcnQs
DQoNCk9rYXksIEkgd2lsbCBhZGQgTUNRIGNoZWNrIG9ubHkgc2V0IHRoaXMgZmxhZyBpbiBNQ1Eg
bW9kZS4NCg0KDQo+ID4+IFRoZSBhYm92ZSBjaGFuZ2Ugd2lsbCBjYXVzZSBscmJwLT5hYm9ydF9p
bml0aWF0ZWRfYnlfZWggdG8gYmUgc2V0DQo+IG5vdA0KPiA+PiBvbmx5IGlmIHRoZSBVRlMgZXJy
b3IgaGFuZGxlciBkZWNpZGVzIHRvIGFib3J0IGEgY29tbWFuZCBidXQgYWxzbw0KPiBpZg0KPiA+
PiB0aGUNCj4gPj4gU0NTSSBjb3JlIGRlY2lkZXMgdG8gYWJvcnQgYSBjb21tYW5kLiBJIHRoaW5r
IHRoaXMgaXMgd3JvbmcuDQo+ID4gDQo+ID4gU29ycnksIEkgbWlnaHQgaGF2ZSBtaXNzZWQgc29t
ZXRoaW5nLCBidXQgSSBkaWRuJ3Qgc2VlDQo+ID4gc2NzaSBhYm9ydCAodWZzaGNkX2Fib3J0KSBj
YWxsaW5nIHVmc2hjZF9zZXRfZWhfaW5fcHJvZ3Jlc3MuDQo+ID4gU28sIGR1cmluZyBhIFNDU0kg
YWJvcnQsIHVmc2hjZF9laF9pbl9wcm9ncmVzcyhoYmEpDQo+ID4gc2hvdWxkIHJldHVybiBmYWxz
ZSBhbmQgbm90IHNldCB0aGlzIGZsYWcsIHJpZ2h0Pw0KPiANCj4gSSB0aGluayB5b3UgYXJlIHJp
Z2h0IHNvIHBsZWFzZSBpZ25vcmUgbXkgY29tbWVudCBhYm92ZS4NCj4gDQo+ID4gQWRkaXRpb25h
bGx5LCBTQ1NJIGFib3J0ICh1ZnNoY2RfYWJvcnQpIHdpbGwgaGF2ZSBkaWZmZXJlbnQNCj4gPiBy
ZXR1cm4gdmFsdWVzIGZvciBNQ1EgbW9kZSBhbmQgREJSIG1vZGUgd2hlbiB0aGUgZGV2aWNlDQo+
ID4gZG9lcyBub3QgcmVzcG9uZCB3aXRoIGEgcmVzcG9uc2UuDQo+ID4gTUNRIG1vZGUgd2lsbCBy
ZWNlaXZjZSBPQ1NfQUJPUlRFRCAobnVsbGlmeSkNCj4gPiBjYXNlIE9DU19BQk9SVEVEOg0KPiA+
IHJlc3VsdCB8PSBESURfQUJPUlQgPDwgMTY7DQo+ID4gYnJlYWs7DQo+IA0KPiBOby4gdWZzaGNk
X2Fib3J0KCkgc3VibWl0cyBhbiBhYm9ydCBUTUYgYW5kIHRoZSBPQ1Mgc3RhdHVzIGlzIG5vdA0K
PiBtb2RpZmllZCBpZiB0aGUgYWJvcnQgVE1GIHN1Y2NlZWRzLg0KPiANCg0KWWVzLCBUTUYgd29u
J3QgdXBkYXRlIHRoZSBPQ1Mgc3RhdHVzLg0KTUNRIG1vZGUgdXBkYXRlIE9DUyBzdGF0dXMgYnkg
DQoxLiBudWxsaWZ5OiB1ZnNoY2RfbWNxX251bGxpZnlfc3FlDQoyLiBzcSBjbGVhbnVwOiB1ZnNo
Y2RfbWNxX3NxX2NsZWFudXANCkluIGJvdGggY2FzZSwgaG9zdCB3aWxsIGZpbGxzIE9DUyB3aXRo
IEFCT1JURUQuDQoNCg0KDQo+ID4gQnV0IERCUiBtb2RlLCBPQ1Mgd29uJ3QgY2hhbmdlLCBpdCBp
cyAweDBGDQo+ID4gY2FzZSBPQ1NfSU5WQUxJRF9DT01NQU5EX1NUQVRVUzoNCj4gPiByZXN1bHQg
fD0gRElEX1JFUVVFVUUgPDwgMTY7DQo+ID4gYnJlYWs7DQo+ID4gSW4gdGhpcyBjYXNlLCBzaG91
bGQgd2UgYWxzbyByZXR1cm4gRElEX0FCT1JUIGZvciBEQlIgbW9kZT8NCj4gDQo+IFRoZSBhYm92
ZSBjb2RlIGNvbWVzIGZyb20gdWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoKSwgaXNuJ3QgaXQ/
DQo+IHVmc2hjZF90cmFuc2Zlcl9yc3Bfc3RhdHVzKCkgc2hvdWxkIG5vdCBiZSBjYWxsZWQgaWYg
dGhlIFNDU0kgY29yZQ0KPiBhYm9ydHMgYSBTQ1NJIGNvbW1hbmQgKHVmc2hjZF9hYm9ydCgpKS4g
SXQgaXMgbm90IGFsbG93ZWQgdG8gY2FsbA0KPiBzY3NpX2RvbmUoKSBmcm9tIGEgU0NTSSBhYm9y
dCBoYW5kbGVyIGxpa2UgdWZzaGNkX2Fib3J0KCkuIFNDU0kNCj4gYWJvcnQgaGFuZGxlcnMgbXVz
dCByZXR1cm4gU1VDQ0VTUywgRkFJTEVEIG9yIEZBU1RfSU9fRkFJTCBhbmQgbGV0DQo+IHRoZSBT
Q1NJIGNvcmUgZGVjaWRlIHdoZXRoZXIgdG8gY29tcGxldGUgb3Igd2hldGhlciB0byByZXN1Ym1p
dCB0aGUNCj4gU0NTSSBjb21tYW5kLg0KPiANCg0KDQpZZXMsIGl0IGlzIGZyb20gdWZzaGNkX3Ry
YW5zZmVyX3JzcF9zdGF0dXMsIGFub3RoZXIgSVNSIHByb2Nlc3MuDQoNClJlZ2FyZGluZyB0aGUg
c3BlY2lmaWNhdGlvbiBvZiBVVFJMREJSOg0KV2hlbiBhIHRyYW5zZmVyIHJlcXVlc3QgaXMgImNv
bXBsZXRlZCIgKHdpdGggc3VjY2VzcyBvciBlcnJvciksDQp0aGUgY29ycmVzcG9uZGluZyBiaXQg
aXMgY2xlYXJlZCB0byAnMCcgYnkgdGhlIGhvc3QgY29udHJvbGxlci4NCg0KdWZzaGNkX2Fib3J0
IGlzIGVycm9yIGNhc2UgdGhhdCBob3N0IGNvbnRyb2xsZXIgY2xlYXIgVVRSTERCUiANCnRhZyBi
aXQgYnkgVVRSTENMUi4NCg0KUmVnYXJkaW5nIHRoZSBzcGVjaWZpY2F0aW9uIG9mIFVUUkNTOg0K
VGhpcyBiaXQgaXMgc2V0IHRvICcxJyBieSB0aGUgaG9zdCBjb250cm9sbGVyIHVwb24gb25lIG9m
IHRoZQ0KZm9sbG93aW5nOg0KCUNvbXBsZXRpb24gb2YgYSBVVFAgdHJhbnNmZXIgcmVxdWVzdCB3
aXRoIGl0cyBVVFJEDQoJSW50ZXJydXB0IGJpdCBzZXQgdG8gIjEiDQoJT3ZlcmFsbCBjb21tYW5k
IFN0YXR1cyAoT0NTKSBvZiB0aGUgY29tcGxldGVkIGNvbW1hbmQgaXMgbm90IA0KCWVxdWFsIHRv
ICdTVUNDRVNTJyBldmVuIGlmIGl0cyBVVFJEIEludGVycnVwdCBiaXQgc2V0IHRvICcwJw0KDQpT
bywgdGhpcyBjYXNlIGlzIHRyYW5zZmVyIHJlcXVlc3QgaXMgImNvbXBsZXRlZCIgd2l0aCBlcnJv
ci4NCldoZXRoZXIgdGhlIE9DUyBpcyAnQUJPUlRFRCcgb3IgJ0lOVkFMSURfT0NTX1ZBTFVFJw0K
V2Ugc2hvdWxkIGFsd2F5cyByZWNlaXZlIGFuIGludGVycnVwdCB1cG9uIGNvbXBsZXRpb24gDQpi
ZWNhc3VlIFVUUkNTIHdpbGwgc2V0IHRvICcxJw0KDQoNCj4gVGhhbmtzLA0KPiANCj4gQmFydC4N
Cg==
