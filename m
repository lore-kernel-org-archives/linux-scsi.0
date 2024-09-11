Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169742AF18;
	Wed, 11 Sep 2024 06:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726034646; cv=fail; b=WZgh7ta2znwg3q+yo3KPFOoQvRPRH+ub9oHe1oQrmMLFpaRi5K7rHHplMd2tNVBl2ObXX1d7W4ZrWooYd/KaocGJMH2bfq6dEeeNs6B9cAfSgiPFTycMsG4iJ9TInl7qwFLdMowR/0L/1c7Fn7LRe8iOkciXxz9WPxQQlt/e048=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726034646; c=relaxed/simple;
	bh=k2XNltGgcTjyYZtCZhp/yNNsjVgyQdP6qJAA/1RE2gU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oIhGCu3bqYBKe5Wjs0pRv5nYPa7Xch1rz3EzIlxBi9+r6bo33OFOPgZfRlW1/p6CexYFgLNbLYR4nyGwV5LTnwWzyHU9uvVHnBlNw5ZcjOLJTkepxtbcO+/qajckvVyjLYLJNq9G5lMxPnNhfXcZ1fqf5e5ff4KU8VHzyi+/78A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dkqQLtZC; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=p5CMucqo; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dkqQLtZC";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="p5CMucqo"
X-UUID: a15f1daa700311efb66947d174671e26-20240911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=k2XNltGgcTjyYZtCZhp/yNNsjVgyQdP6qJAA/1RE2gU=;
	b=dkqQLtZCPIWLyAgRkSNGrlM/9w6khaaoSHrgvZrz8kXvXc83nqLrYOBmKYMGJ3jUA3TWdIebz8xJaXcWxRgX0M/zjrBOXB93hMVDIRa/2u4qf+1FXytiXofLIBnjkRVqA21EDur3t/59/9/KPUj5KV6Eevck6I/zpg0Ng1WErIY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:83ea7c3a-2b8c-4d84-9acb-66e7b0702df0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:a6f4c7bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: a15f1daa700311efb66947d174671e26-20240911
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 749092771; Wed, 11 Sep 2024 14:03:56 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 11 Sep 2024 14:03:55 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 11 Sep 2024 14:03:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EUjqLifA1WLe9ilARX66jY5UjsWShDZ4eN+uRBcqQydFKhKs4Qq/Qr2R0At5CgwNwRMkry5vp/ZvD4DdB85rYXeaBjRTfNntR6yRKkBjYFPOf0hbxaUJYYiPLIjnCsOwALxY/tYcT7nsbdd1aQ98uro37D4475aERn1Gnx0MAEmgMWC1LzMm96i56ph1HR5vCITotoPD6ZwLeuWe+8nV9ByeYxcczMaXgk5vkHfLi841RBCIwOpuHhXpGxQ+q6V76KAXugsmyMdZwf4arNzCoMhjukqY94kxMehMG765CtNlOberY/LiLcvV/WwX8vHIbEMBVEv4vG/v5Fo4StGWhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2XNltGgcTjyYZtCZhp/yNNsjVgyQdP6qJAA/1RE2gU=;
 b=tjVLqO4z93FJo1j7FBXoigXSJQQ4iO5nl9+zUZyaswHmgI0CYbWWueSJi6LTAcddgOxcaL/mluDEcq8rPDVrSC8qrwRy+pslOIDqyifwo7TKCq2QJCJC7xTigeoUdAPE2qX6EpOgyjgLNvYRk8DAz2uOG0XeQstjSfuNYQdnu2UDUFas6K0J+uUxAaBwjTm9ybbl+A9DqjtTL17ghQ+5wNQ2iaGqIBYOBAiJpHazDYaAzF16azkUhSKAxn6ECokv/fhw7AkSCQ6ToRXGIxgY7/OmhQrjOrJQdTGNYN6f85Dlh1f0ODXaPxi2tF/wtCZiclK5/YLSuTDxnAKgs2qNcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2XNltGgcTjyYZtCZhp/yNNsjVgyQdP6qJAA/1RE2gU=;
 b=p5CMucqo6bImSp3htR2sDab2j4BWhhISKqmPG0nXL3sPALyQNCtqys9gpL0D53aq1LSiy1+E9AE4M7AGMR/Tluekfs3opEitY+bR2O9q8lj5EC3gleutETLrMsN4hbrKacBjSwuxZlfAUB5cBQ+tzPAutvBkU80mTaXqhp+R/I0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7705.apcprd03.prod.outlook.com (2603:1096:400:40e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Wed, 11 Sep
 2024 06:03:53 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 06:03:53 +0000
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
Subject: Re: [PATCH v4 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v4 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbA1N1RX6n4EeryE2vN/rAxATc77JRT7iAgADKYQA=
Date: Wed, 11 Sep 2024 06:03:53 +0000
Message-ID: <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
	 <20240910073035.25974-3-peter.wang@mediatek.com>
	 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
In-Reply-To: <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7705:EE_
x-ms-office365-filtering-correlation-id: 51b44475-bdf5-4fbd-aca3-08dcd227838e
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K3BnazJ2eFFxZ2xKeTFEeUVZWU5mL3VkNStWaFo1aHhQcENxRjkrT0JyMzFq?=
 =?utf-8?B?NEUrZVJGbFZ3NlpGOFFWRXlDUDJTMlpYSWZZSGN2dk13M3M5UkhZcjh4K21a?=
 =?utf-8?B?dEZTcXpkNUFUTGFPT01xTlhrN3M3aitkRnVwUkk0THhtTVBLSzlLc3dlVDNj?=
 =?utf-8?B?TFZpNmQzbEJ2R3lQYndzdzFkVS9NOGRVcUpzNFpBamxDT1hBWGNKSFQxLzZD?=
 =?utf-8?B?L0xSTm5tTHVwUW0wNHlia1dNWTJlV3RINlMxeExXVStQS0FhQllvandQU3Qz?=
 =?utf-8?B?aldOL1dBMFhDdi9BTHAvSWhxL24vU3p0VkJwOUxyTHRJNTJFOHpXYWp1dW9J?=
 =?utf-8?B?N2VOdmtBQitOVm1FVUlwSlVWOFJrY0Y5MkR1R0tMbFhuOXc1aVlpTGpzTms1?=
 =?utf-8?B?bEE2NUVaZk9hVS9iSUdSVExpTXZPSzVXS3pDQlgyT0VOT2h6WXVNR3JKV0RW?=
 =?utf-8?B?MFpBVzVxUTJ4THVoQlRsajQ4ZU9FcnI3TEVhV1RzenVWdytpd2tiTWovbVds?=
 =?utf-8?B?T1RXWUtySWxGMWowN2pTZXhsTFl3QlFieFI1anptL1NXV0FIUDFLUmJOY0RU?=
 =?utf-8?B?NnhSZktvaGhUTVBHZDJsSEdnQjg5b0NhYzdNYlRZZW8wU3pYc0VjRVg4dTgy?=
 =?utf-8?B?QllSc2hSZ1VSeGYrZHZpSEVuVWJEUEJ0ZFVkemZMWVpLTDdyMmkwSVlQMVBw?=
 =?utf-8?B?dUpmYkp4cmxMbTVLR25ubzJXSVpFeVFudjJpUGNTS0p4am9RaDNOSU9nVy9u?=
 =?utf-8?B?TDhWUW5zN1FndU5xQTZMN1o2UXJpZiszaUx2UVJRa0ZZY3dVamczbGkzOExL?=
 =?utf-8?B?bFpvSVZJbEd1UmNuNXhRd1VMZjhTY1l0YWQxMlBrUkJSRzdrbURkVUYvWlRj?=
 =?utf-8?B?K2QvZlo3TWRWSEJHbjlwZXlINmwwUlFrV1VQVEhTbDNzTUgvQWh4Q1BVWUFE?=
 =?utf-8?B?azllTzU1cFBWdFhwOW5NenBWRnl5a2M4UmpaTEpiQ1VRSjdIQmpxa2JCUlgv?=
 =?utf-8?B?dm54bzVCQkNKTk5WQ1UxbjdvQ0N6dmhoRmkzMkZ2T09jVmNKL2hsRnlVZGk4?=
 =?utf-8?B?U3lqcGJXcm50ZCtRL1lORm51MEt4WUY1V29PSUh0elBJM0M2eHgweGFJZ1R6?=
 =?utf-8?B?ZkhUdlFROHVDY3VlbjBFQUhQN1c5VDZ4MHY0N1h0alVhSkRudGM4MlEvMUJX?=
 =?utf-8?B?WlpVMkhCUVNNdkZ3OVZmemhwYzVZc0J0dk1nRWxZdlptQmZDWVZZOFZoVWhq?=
 =?utf-8?B?dFhXQzZObTBEd2xBWmRjMmRSVUJtaEZxV3lhUDVJN1NjQnJwRUZraStsNXdm?=
 =?utf-8?B?Vi9iR295RU1xcm9LdFdrUWNJU1ZVYkZYdk5jUzdYT0ZTS1Z4TWRVbEFValVt?=
 =?utf-8?B?S1luTzZpWlVXNU5iNnBZOUdQazFJRU9acnJzVzFmSUQzSDduY084TnRjU2ZH?=
 =?utf-8?B?bll3c21aYldPaEsrRXVjQTVBK0lvSnVveFdDeFNyWEQ3bkdhQmE2N3pPZDVx?=
 =?utf-8?B?TmRYbU5ObDJjNmRSU2R4VW9sNkJraGhRRkFpVCt4Z3BPUlIrWWtYUHhLUTd2?=
 =?utf-8?B?Vm04MGYzSFJhQXYyMXZrRWlhSkphRG5yYkdzYkp4QzJaeXZjS0ZOcElMempP?=
 =?utf-8?B?QmYxbmhjZ2pwRFhpK3FtRFNVMzN2bGdOVkx6VW04SnBDSzVlajBxR3dxWXVN?=
 =?utf-8?B?R0IzR3NZL00yWnY5d1l4d1lQY0pIenRBQnFPV1d3cTJRbklWU3QwUGhwdVVs?=
 =?utf-8?B?RW9neWlBT0VqTk5aVVBUQUp1TjJFaUhuQ0h1MjJ6bXcwTGpIYWF6U0pndjZD?=
 =?utf-8?B?aVdtQURHRlQ2T3p4RGg2SkVSNXJVTVYxajVNeU4zb3NWc3YxZ2lyYTM0OUUw?=
 =?utf-8?B?VTdrb1FGaGFoQXBBK013V2tkWkk3N1JjVVJJbFIwVCtKSlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0gyODFmUVl5NjlYVU1ISW4wZlI3SU1KYUVLTFdZS0wvRzJYbitvK3kxUVV0?=
 =?utf-8?B?c1EyTi9NUS9CSnpXc01JUFBmckxhR0Q5dDVvWDdrdHlkNlNHWWRMZjk2ZWlv?=
 =?utf-8?B?TXZLR05QNW1pT3d1MjZiRkFRU1AwTXpvSHNxWnhaQmdOdm0zdmFUZ3pnY0Ux?=
 =?utf-8?B?cXNwb1l5c2E3SDBvUng3c21lR21UTEdSTEdVaWxtbnJ0N3RiUGVmcFVudGkw?=
 =?utf-8?B?ckozOFJCZVIySUNRekJCWTZMbWVXdXBETk5mT3ZZWkFxTXUxbFkxbFNiRDlZ?=
 =?utf-8?B?SlJtOGxHeXlMQkFWMll4Vy80QmkzNHhkSGdVTENIcDhzVVljaWZJU3BIVks5?=
 =?utf-8?B?WDgrY3lVbEdMNWxaUGtCWkdFN0RxTUtmUjVkb3N1SnJwZUpCM3hMVDlFYnZP?=
 =?utf-8?B?YnhUeWlvQUVBV2JoUjRsdDFRY2QvRC9HcXl1Z1FtQ0FZbmlPRU5Ua0hXbUtQ?=
 =?utf-8?B?YWZXNDFtaVV1Z0h2ZGcyUnV6OVpKZStYTlBaOHFDdHdWOFpIenBpWTkyVXhR?=
 =?utf-8?B?bDdNVGtLc1NmNFU5eGsyVXIxWjFRV2lvWitwVEVXUURzcmZXL1F2K095anNj?=
 =?utf-8?B?clUvSGFWRkRpUGN2SEpIc0loWUpGZnU1ZlVYZFZhaEplYWoxK3B6RzlNcWpK?=
 =?utf-8?B?MjZJWmsyaG5tRXd6M3QrNUNTR1JYd1V1MndzNTRYOWhlUjRoL2RtYmE0WjZN?=
 =?utf-8?B?dkFiQkpzaEpMeVIySjBRem9ZZjMxNWttWlVxTENpeVdDZDVUTXhMMkEvM1l2?=
 =?utf-8?B?RW50dGFKUStrMDd5TGdOOENITVdRcU5SZkFlRFEyTG4zVGlCVGtvT2MydEJj?=
 =?utf-8?B?RVVvZGt1bUV6T0E2U2ZqUXpUN2EwKzhaNEtNTHNPckJqWFV2VW9OV2QxRzRs?=
 =?utf-8?B?RnJGc25YUFBNR0p1TjVpVm9JdzJMUjN5dm9DOE5TMitraXZkVDVqUE55L3B4?=
 =?utf-8?B?ZkNiRWtKL3hrOElHM3BTakYxZ1VEcUVQejFkbmVLQ0dqSGlyYk11QWJ3MlRM?=
 =?utf-8?B?Ums2UnUwekxwNmZpalR3TzRwbk1qVFlEU05oUlE0WVg0dEE3Ym5MRk1XQy9k?=
 =?utf-8?B?QTlWZ29URVpzV2VBUFBNc1pMN0M1SlNYZ0JKSmRORFZPV05yWVpBUHhNSC9J?=
 =?utf-8?B?aWpiUVVlODRtYU1IdUtBWlVNYU9oUzgzSmdFbDdibWtDTFpPcWZuOVNjOTZn?=
 =?utf-8?B?NlkzQStzS09xQ0Y0YnF2YVlUa2czWkxtc0gzd1pnRVNoeEtpQ21VU2orYzRn?=
 =?utf-8?B?aVo3MXYzSC9Ia2Y1MDhrU29yQ3lPOWJ1TzBKMjk2MkRvYjh1V21BaERnaUtZ?=
 =?utf-8?B?VHRvQ0J6MjU3YXYyQ1JsOVVJSmJWWnpocnNUSVBtMUVDUDZ2b1lodzdIZHQ4?=
 =?utf-8?B?VDhnVm1XZTU5SFJqN0xIUlBYT0liR25KOU5rdSt2dm81RWhWZFQ3NHR4MVJt?=
 =?utf-8?B?UStqRmhzMW1jZFlCbU5YYTdjR2Z6cERFeDZ1QUMrU0F3TVFzallvZFJDNWtB?=
 =?utf-8?B?SFJYQWl6NXFCcExrT3ZBMzNxSjg0Y1ZnbUE1ZUU3WFhzdTVqUE92eWNLd2Qv?=
 =?utf-8?B?VnEzTisvOFNmcVhPdE1nbXArMGNEL2ZRYlBaMEF0M2h0MGxXZGhqNkVPcjFO?=
 =?utf-8?B?UEVtTm9wdUN0M0VJZHplWU16ajJFUWVyaTEvcTVXV1cxd0pINjRMajZkcWd1?=
 =?utf-8?B?WEJhRW1IL21zenVnM3lNbkpmdTlCWkhYOWpGZzR2dUhaMTBqcUxWMzA5blFD?=
 =?utf-8?B?MGhwYmc0dVZWYzlPK1NnNUNoaFRmNGltNWw3THQwQ3IydDBFUnY4RkZuajBP?=
 =?utf-8?B?bDl2YzdKVWlhbzNGSWM3ZHRvTGswTTdad24xYUVWZHRWUmxtc0JTN1pDUVNW?=
 =?utf-8?B?blVCUWQ0LzJKR2RuZDBTbXJGejJNUGNGelA5dUZjT0lheHo4bjkvYk85bjZB?=
 =?utf-8?B?dkltMkRpeDU1cFV4U200QUs2dFRuM3BKeUhSZFVKdGs1Mkg0NU9CYUNONHF5?=
 =?utf-8?B?dVRmeG5INHg3dkJBVy90azNOYm0wOVZ3UmRwaEhISDFBTzVteHhmOHpINE9Y?=
 =?utf-8?B?U0RGY0FaWHlxZnZ0dHRrNWV0VithVVcwcTM4WkkzSnl0aG5zRktZQzN3eTBt?=
 =?utf-8?B?L2xNVjZXaFN1SEVWdzJFTitjcXIxNk9BTDVVMUsxOW1xUms4QVRmTDBEc2xu?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63ADA33AE0368C40AD5D5150ED540ADB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b44475-bdf5-4fbd-aca3-08dcd227838e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 06:03:53.2319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y8FBOEziqNKg2fG8ndrZMXFjKPQ1VwsfbiO+iXK4NWsPqgOOxt8MQD0300L6A6HkZ1wG3CF+//AUOixF85V36g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7705
X-MTK: N

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDEwOjU5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xMC8yNCAxMjozMCBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20gd3JvdGU6DQo+ID4gdWZzaGNkX2Fib3J0X2FsbCBmcm9jZSBhYm9ydCBhbGwgb24tZ29p
bmcgY29tbWFuZCBhbmQgdGhlIGhvc3QNCj4gICAgICAgICAgICAgICAgICAgICBeXl5eXiBeXl5e
XiAgICAgICAgICAgICAgXl5eXl5eXiAgICAgICAgIF5eXl4NCj4gICAgICAgICAgICAgICAgIGZv
cmNpYmx5PyBhYm9ydHM/ICAgICAgICAgICAgY29tbWFuZHM/ICAgaG9zdA0KPiBjb250cm9sbGVy
Pw0KPiANCg0KSGkgQmFydCwNCg0KU29ycnksIHdpbGwgY29ycmVjdCB3b3JkcyBuZXh0IHZlcnNp
b24uDQoNCg0KPiA+IHdpbGwgYXV0b21hdGljYWxseSBmaWxsIGluIHRoZSBPQ1MgZmllbGQgb2Yg
dGhlIGNvcnJlc3BvbmRpbmcNCj4gPiByZXNwb25zZSB3aXRoIE9DU19BQk9SVEVEIGJhc2VkIG9u
IGRpZmZlcmVudCB3b3JraW5nIG1vZGVzLg0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IF5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eDQo+IFRoZSBob3N0IGNvbnRyb2xsZXIg
b25seSBzZXRzIHRoZSBPQ1MgZmllbGQgdG8gT0NTX0FCT1JURUQgaW4gTUNRDQo+IG1vZGUNCj4g
aWYgdGhlIGhvc3QgY29udHJvbGxlciBzdWNjZXNzZnVsbHkgYWJvcnRlZCB0aGUgY29tbWFuZC4g
SWYgdGhlDQo+IGFib3J0IFRNRiBpcyBzdWJtaXR0ZWQgdG8gdGhlIFVGUyBkZXZpY2UsIHRoZSBP
Q1MgZmllbGQgd29uJ3QgYmUNCj4gY2hhbmdlZA0KPiBpbnRvIE9DU19BQk9SVEVELiBJbiBTREIg
bW9kZSwgdGhlIGhvc3QgY29udHJvbGxlciBkb2VzIG5vdCBtb2RpZnkNCj4gdGhlIA0KPiBPQ1Mg
ZmllbGQgZWl0aGVyLg0KPiANCg0KVGhpcyBzdGF0ZW1lbnQgaXMgbm90IHF1aXRlIGFjY3VyYXRl
IGJlY2FzdWUgaW4gVUZTSElDMi4xLCBTREIgbW9kZSANCnNwZWNpZmljYXRpb24gYWxyZWFkeSBo
YXZlIE9DUzogQUJPUlRFRCAoMHg2KSBkZWZpbmUuDQpBbmQgaXQgaXMgdXNlZCBpbiBiZWxvdyBV
VFJMQ0xSIGRlc2NyaXB0aW9uOg0KJ3doaWNoIG1lYW5zIGEgVHJhbnNmZXIgUmVxdWVzdCB3YXMg
ImFib3J0ZWQiJw0KVGhlcmVmb3JlLCB0aGUgaG9zdCBjb250cm9sbGVyIHNob3VsZCBmb2xsb3cg
dGhlIA0Kc3BlY2lmaWNhdGlvbiBhbmQgZmlsbCB0aGUgT0NTIGZpZWxkIHdpdGggT0NTOiBBQk9S
VEVELiANCklmIG5vdCBzbywgYXQgd2hhdCBwb2ludCBkb2VzIHlvdXIgaG9zdCBjb250cm9sbGVy
IHVzZSB0aGUgDQpPQ1M6IEFCT1JURUQgc3RhdHVzPw0KDQoNCj4gPiBTREIgbW9kZTogYWJvcnRz
IGEgY29tbWFuZCB1c2luZyBVVFJMQ0xSLiBUYXNrIE1hbmFnZW1lbnQgcmVzcG9uc2UNCj4gPiB3
aGljaCBtZWFucyBhIFRyYW5zZmVyIFJlcXVlc3Qgd2FzIGFib3J0ZWQuDQo+IA0KPiBIbW0gLi4u
IG15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBjbGVhcmluZyBhIGJpdCBmcm9tIFVUUkxDTFIgaXMg
b25seQ0KPiBhbGxvd2VkICphZnRlciogYSBjb21tYW5kIGhhcyBiZWVuIGFib3J0ZWQgYW5kIGFs
c28gdGhhdCBjbGVhcmluZyBhDQo+IGJpdA0KPiBmcm9tIHRoaXMgcmVnaXN0ZXIgZG9lcyBub3Qg
YWJvcnQgYSBjb21tYW5kIGJ1dCBvbmx5IGZyZWVzIHRoZQ0KPiByZXNvdXJjZXMNCj4gaW4gdGhl
IGhvc3QgY29udHJvbGxlciBhc3NvY2lhdGVkIHdpdGggdGhlIGNvbW1hbmQuDQo+IA0KDQpBbHRo
b3VnaCB0aGlzIHNwZWNpZmljYXRpb24gZGVzY3JpcHRpb24gZG9lcyBub3QgZXhwbGljaXRseSAN
CnN0YXRlIHRoZSBPQ1MgYmVoYXZpb3IsIHRvIG15IHVuZGVyc3RhbmRpbmcsIHRoZSBzcGVjaWZp
Y2F0aW9uDQpmb3IgTUNRIGFib3J0IGJlaGF2aW9yIGlzIGZvcm11bGF0ZWQgd2l0aCByZWZlcmVu
Y2UgdG8gdGhlIFNEQiBtb2RlLg0KDQoNCj4gPiBGb3IgdGhlc2UgdHdvIGNhc2VzLCBzZXQgYSBm
bGFnIHRvIG5vdGlmeSBTQ1NJIHRvIHJlcXVldWUgdGhlDQo+ID4gY29tbWFuZCBhZnRlciByZWNl
aXZpbmcgcmVzcG9uc2Ugd2l0aCBPQ1NfQUJPUlRFRC4NCj4gDQo+IEkgdGhpbmsgdGhlcmUgaXMg
b25seSBvbmUgY2FzZSB3aGVuIHRoZSBTQ1NJIGNvcmUgbmVlZHMgdG8gYmUNCj4gcmVxdWVzdGVk
DQo+IHRvIHJlcXVldWUgYSBjb21tYW5kLCBuYW1lbHkgd2hlbiB0aGUgVUZTIGRyaXZlciBkZWNp
ZGVkIHRvIGluaXRpYXRlDQo+IHRoZQ0KPiBhYm9ydCAodWZzaGNkX2Fib3J0X2FsbCgpKS4NCj4g
DQo+ID4gQEAgLTc1NjEsNiArNzU1MSwyMCBAQCBpbnQgdWZzaGNkX3RyeV90b19hYm9ydF90YXNr
KHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGludCB0YWcpDQo+ID4gICBnb3RvIG91dDsNCj4gPiAg
IH0NCj4gPiAgIA0KPiA+ICsvKg0KPiA+ICsgKiBXaGVuIHRoZSBob3N0IHNvZnR3YXJlIHJlY2Vp
dmVzIGEgIkZVTkNUSU9OIENPTVBMRVRFIiwgc2V0IGZsYWcNCj4gPiArICogdG8gcmVxdWV1ZSBj
b21tYW5kIGFmdGVyIHJlY2VpdmUgcmVzcG9uc2Ugd2l0aCBPQ1NfQUJPUlRFRA0KPiA+ICsgKiBT
REIgbW9kZTogVVRSTENMUiBUYXNrIE1hbmFnZW1lbnQgcmVzcG9uc2Ugd2hpY2ggbWVhbnMgYQ0K
PiBUcmFuc2Zlcg0KPiA+ICsgKiAgICAgICAgICAgUmVxdWVzdCB3YXMgYWJvcnRlZC4NCj4gPiAr
ICogTUNRIG1vZGU6IEhvc3Qgd2lsbCBwb3N0IHRvIENRIHdpdGggT0NTX0FCT1JURUQgYWZ0ZXIg
U1ENCj4gY2xlYW51cA0KPiA+ICsgKiBUaGlzIGZsYWcgaXMgc2V0IGJlY2F1c2UgdWZzaGNkX2Fi
b3J0X2FsbCBmb3JjaWJseSBhYm9ydHMgYWxsDQo+ID4gKyAqIGNvbW1hbmRzLCBhbmQgdGhlIGhv
c3Qgd2lsbCBhdXRvbWF0aWNhbGx5IGZpbGwgaW4gdGhlIE9DUyBmaWVsZA0KPiA+ICsgKiBvZiB0
aGUgY29ycmVzcG9uZGluZyByZXNwb25zZSB3aXRoIE9DU19BQk9SVEVELg0KPiA+ICsgKiBUaGVy
ZWZvcmUsIHVwb24gcmVjZWl2aW5nIHRoaXMgcmVzcG9uc2UsIGl0IG5lZWRzIHRvIGJlDQo+IHJl
cXVldWVkLg0KPiA+ICsgKi8NCj4gPiAraWYgKCFlcnIpDQo+ID4gK2xyYnAtPmFib3J0X2luaXRp
YXRlZF9ieV9lcnIgPSB0cnVlOw0KPiA+ICsNCj4gPiAgIGVyciA9IHVmc2hjZF9jbGVhcl9jbWQo
aGJhLCB0YWcpOw0KPiA+ICAgaWYgKGVycikNCj4gPiAgIGRldl9lcnIoaGJhLT5kZXYsICIlczog
RmFpbGVkIGNsZWFyaW5nIGNtZCBhdCB0YWcgJWQsIGVyciAlZFxuIiwNCj4gDQo+IFRoZSBhYm92
ZSBjaGFuZ2UgaXMgbWlzcGxhY2VkLiB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSBjYW4gYmUN
Cj4gY2FsbGVkDQo+IHdoZW4gdGhlIFNDU0kgY29yZSBkZWNpZGVzIHRvIGFib3J0IGEgY29tbWFu
ZCB3aGlsZQ0KPiBhYm9ydF9pbml0aWF0ZWRfYnlfZXJyIG11c3Qgbm90IGJlIHNldCBpbiB0aGF0
IGNhc2UuIFBsZWFzZSBtb3ZlIHRoZQ0KPiBhYm92ZSBjb2RlIGJsb2NrIGludG8gdWZzaGNkX2Fi
b3J0X29uZSgpLg0KPiANCg0KQnV0IG1vdmUgdG8gdWZzaGNkX2Fib3J0X29uZSBtYXkgaGF2ZSBy
YWNlIGNvbmRpdGlvbiwgYmVhY2F1c2Ugd2UNCm5lZWQgc2V0IHRoaXMgZmxhZyBiZWZvcmUgdWZz
aGNkX2NsZWFyX2NtZCBob3N0IGNvbnRyb2xsZXIgZmlsbA0KT0NTX0FCT1JURUQgdG8gcmVzcG9u
c2UuIEkgd2lsbCBhZGQgY2hlY2sgdWZzaGNkX2VoX2luX3Byb2dyZXNzLg0KDQoNCj4gUmVnYXJk
aW5nIHRoZSB3b3JkICJob3N0IiBpbiB0aGUgYWJvdmUgY29tbWVudCBibG9jazogdGhlIGhvc3Qg
aXMNCj4gdGhlIA0KPiBBbmRyb2lkIGRldmljZS4gSSB0aGluayB0aGF0IGluIHRoZSBhYm92ZSBj
b21tZW50ICJob3N0IiBzaG91bGQgYmUNCj4gY2hhbmdlZCBpbnRvICJob3N0IGNvbnRyb2xsZXIi
Lg0KPiANCg0KSXQgd2lsbCBiZSBjaGFuZ2VkIHRvICdob3N0IGNvbnRyb2xsZXInIHRvIG1ha2Ug
dGhlIGNvbW1lbnQgY2xlYXJlci4NCg0KDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZzL3Vm
c2hjZC5oIGIvaW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gPiBpbmRleCAwZmQyYWViYWM3MjguLjE1
YjM1NzY3MmNhNSAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiA+ICsr
KyBiL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+ID4gQEAgLTE3Myw2ICsxNzMsOCBAQCBzdHJ1Y3Qg
dWZzX3BtX2x2bF9zdGF0ZXMgew0KPiA+ICAgICogQGNyeXB0b19rZXlfc2xvdDogdGhlIGtleSBz
bG90IHRvIHVzZSBmb3IgaW5saW5lIGNyeXB0byAoLTEgaWYNCj4gbm9uZSkNCj4gPiAgICAqIEBk
YXRhX3VuaXRfbnVtOiB0aGUgZGF0YSB1bml0IG51bWJlciBmb3IgdGhlIGZpcnN0IGJsb2NrIGZv
cg0KPiBpbmxpbmUgY3J5cHRvDQo+ID4gICAgKiBAcmVxX2Fib3J0X3NraXA6IHNraXAgcmVxdWVz
dCBhYm9ydCB0YXNrIGZsYWcNCj4gPiArICogQGFib3J0X2luaXRpYXRlZF9ieV9lcnI6IFRoZSBm
bGFnIGlzIHNwZWNpZmljYWxseSB1c2VkIHRvDQo+IGhhbmRsZSBhYm9ydHMNCj4gPiArICogICAg
ICAgICAgICAgICAgICAgICAgICAgIGNhdXNlZCBieSBlcnJvcnMgZHVlIHRvIGhvc3QvZGV2aWNl
DQo+IGNvbW11bmljYXRpb24NCj4gDQo+IFRoZSAiYWJvcnRfaW5pdGlhdGVkX2J5X2VyciIgbmFt
ZSBzdGlsbCBzZWVtcyBjb25mdXNpbmcgdG8gbWUuIFBsZWFzZQ0KPiBtYWtlIGl0IG1vcmUgY2xl
YXIgdGhhdCB0aGlzIGZsYWcgaXMgb25seSBzZXQgaWYgdGhlIFVGUyBlcnJvcg0KPiBoYW5kbGVy
DQo+IGRlY2lkZXMgdG8gYWJvcnQgYSBjb21tYW5kLiBIb3cgYWJvdXQgImFib3J0X2luaXRpYXRl
ZF9ieV9laCI/DQo+IA0KPiBQbGVhc2UgYWxzbyBtYWtlIHRoZSBkZXNjcmlwdGlvbiBvZiB0aGlz
IG1lbWJlciB2YXJpYWJsZSBtb3JlIGNsZWFyLg0KPiANCg0KU3VyZSwgd2lsbCBjaGFuZ2UgdGhp
cyBuYW1lIGFuZCBtYWtlIGRlc2NyaXB0aW9uIGNsZWFyZXIuDQoNClRoYW5rcy4NClBldGVyDQoN
Cg0KDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
