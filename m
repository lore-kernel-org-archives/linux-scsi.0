Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC7B4C62;
	Mon, 15 Jul 2024 06:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721025123; cv=fail; b=rwmY0vjDeRXoQd3vEbe77EoTbalYZcdCMxnm3UYtKXM9p1wdDyeM+cQ6LIbhj4R6AA/vJqzCD/ZDf0H5dVQfrSEii47ep8HhhNAWDvsrBNbyN1wSbHTrX2ozLad6yvJ8b5Qfz77wjojFQbtFF/z3ta/s0kZ6dlTNvrvntDE+6h8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721025123; c=relaxed/simple;
	bh=AOHqAQpP6MXtYXmOBScxEstnmxgkwRNaam7IlJ4B/Xk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J8qOvb3gncFTkIglx/ORdwUO2lTpf4gYGZuY02pamFcR723jaOdIxghrkec9hD6wLyc0XSze3aCckJrgsb8Vlv2fy6V1m+jFKLMQvlCNQzZmpkunX8XLaOL5SHDK2TD2dh68NFE7kAe8m/nCmHAk0rOLQ9txSCShhQ56YQIpgZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BbUw0jT6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=clCIaG+u; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BbUw0jT6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="clCIaG+u"
X-UUID: ed2f4e84427311ef87684b57767b52b1-20240715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=AOHqAQpP6MXtYXmOBScxEstnmxgkwRNaam7IlJ4B/Xk=;
	b=BbUw0jT6X/A6mQOU27nnTJhomhSdoxGukm8bqCWSR1CQzIY9XbqX6CwEPlK+Uowp4PtsnjqAaafwkjHC0ZAFjpZw5ikKtgXB/GgzhRyGXNO4IGC0xzzNhOUjLWcfSVvAv977DSeA1wafiWjTSnVIHzdM2wmVFhgvrO6MfDnQ/+o=;
X-CID-CACHE: Type:Local,Time:202407151429+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:b88c047c-5e83-4a8f-8a6c-1f6b5a220f95,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:a78b59d5-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: ed2f4e84427311ef87684b57767b52b1-20240715
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1597412689; Mon, 15 Jul 2024 14:31:53 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 Jul 2024 14:31:54 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 15 Jul 2024 14:31:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LHXVLeIJi2XOelRn4CFziok61nkYQdhrnx/b2Bg38rmIIdmng7Hwo1zHQ6x6ANg6xG+iDKmYX0PHdTCKfuWu/BmN5sfy1XjwkXktGRh4V0Lc3qNR/jVDWY8JjDMxnLkNEwTuQblqAFBJ31+EV534zz+UYa1Rx/bwIBtXJDuVoXCojF/1kzcVGCYFFVMOTxZ5vqQegYkBVOQ05hl6ROddu61jpljbhk4+uVcON2fKH0zZTuZWZDRrQvasZ7ElUMYCCW3dLrBKtXsAmVLC8lnQ1WpYMk5qgNRvdmGV4w91nuEwJxS/20WQzUGrYoFuJxuaeyYQWltepOAI0aenw5w2sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOHqAQpP6MXtYXmOBScxEstnmxgkwRNaam7IlJ4B/Xk=;
 b=y0bk35oy3x+sRQDUxxrSDEJ05tY6JYavFFDc2NDsZZnrvTvARKgqqptR5TAp5GHWS6yjat1eWKvUX1kdEIq0vj7eiSGShQTUqB5cETwcPIkDU0Nvdk8s8KW8+3v643hkzEgaEIw867Kt8ThQpABsgerm/4WWO05s/RsygmwRaxPcNjt8iNqXFUUBfIaKSvaSMM49tZFU3iVITDxaUjlrLzhH7cMK8I99kaCqd31SSfdcuhvd6WL2Da73gwg7c4VpznRjLLv3mlPrMYGrhE9kddmDxJgEuql4YpJdgC+BzhjM3LoUfaopOyIKwKzUT3J6/c/MeoRUGEcDHwCdqGpZBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOHqAQpP6MXtYXmOBScxEstnmxgkwRNaam7IlJ4B/Xk=;
 b=clCIaG+u1FbHoqEG4vDELmuG9AQRN5L8utWYQXagUbWN25GS1u4yIYDTN841FQ7fpII5cDg55hL7/IMALmj9UVCZe6NEjezUULC7x1YLvCEIPHnOUsqD48ukwonLY5XFQnMf9KjHT98wXV6upQyIvb1D/ZUbUNs0BkdqNuns2bQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6492.apcprd03.prod.outlook.com (2603:1096:101:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 06:31:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 06:31:52 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"huobean@gmail.com" <huobean@gmail.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: fix deadlock when rtc update
Thread-Topic: [PATCH v1] ufs: core: fix deadlock when rtc update
Thread-Index: AQHa1EAILL2v5M5cn0eBJ19m5454I7HzWwGAgAN5YoCAAIR3gA==
Date: Mon, 15 Jul 2024 06:31:52 +0000
Message-ID: <0f851bf97bc7015f62e209651a1247d904dfc54f.camel@mediatek.com>
References: <20240712094355.21572-1-peter.wang@mediatek.com>
	 <d1d20f65-faa9-414f-b7fb-4b53794c0acb@acm.org>
	 <de8b34e3a4055a545de4f6ee4321f968ccbfa0aa.camel@gmail.com>
In-Reply-To: <de8b34e3a4055a545de4f6ee4321f968ccbfa0aa.camel@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6492:EE_
x-ms-office365-filtering-correlation-id: 1aa55a11-db22-485e-45ce-08dca497d06c
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NFhlUUxrY2VHUUpFcVdpcnEwaHA2TEhocXMyOGNmTXZYbnlGejM4YitNdS9Z?=
 =?utf-8?B?MWhERytzRmhiQjBmazNuVGdxdUFub0V6a2NZVHlZaVo4dWw3Y2ZaKzlMZ3Ux?=
 =?utf-8?B?blJacTFsT3hZRkJDN3pIVmtwYmJLU0Y2WnV2UnhtbHdUMlV4bW5pV1Jpcmd1?=
 =?utf-8?B?cXJkQjduQzE5Z0NwZWM1RzVtbFhtWWRoUk40R3RxT1ZTbzFiYWJjMUdPQnlB?=
 =?utf-8?B?Q2M5WnEvdHNRYmdJSURIZGNpTFMyRkhEVEk5c0dRT1AzMVoyK05iSnA5MjlN?=
 =?utf-8?B?dlR3TVhBdVlSYzRYSXBxalMrR0Z1NkJOd2FRWlpBRE9kMnhLR1pFcXQwVHdT?=
 =?utf-8?B?UmIyT1kzRVhiRXBnTVBiRlZVdStxVXVtWE5waWlDSVhYSTNHKzNCMkwwZW9a?=
 =?utf-8?B?TlZJV2ZvdWpKMG00M3o4WS8yTTVzTHVZclhwQWlZT0dxbG16RmFzNlBpK0Zv?=
 =?utf-8?B?c3pIL3hNU2ZYdGgvMGpTeFhML1dRdjN6L3ZOQlhxd3psWTRUZ1RYSlU3QnVR?=
 =?utf-8?B?cGZnS0F1R21GZU1lMFIxZUh6cDU3SFRreWZjQVFwZGVTcjdDdWUzTmZaYmZH?=
 =?utf-8?B?K1F6UmZpQzRQM1JPd2hCREhkSzZWMjJVZmNkdHJ6L1FOdm9kM05semF4VTRR?=
 =?utf-8?B?ckN3SHNUMjRNTnRSUkZoSTlLeXpHWDMrVnpwdi9NUDREZm4yQ1hIQnVBczE2?=
 =?utf-8?B?TnZFSTJpRkNJTjRTbkpuc0pvQ1k4UmRCamtoU1lHRXh4eVhUZ0hOTERNYlBH?=
 =?utf-8?B?M2I3b1VGYm9xMEt4Qm55MUZPRW9tQ3M4bUlFQ1czdlpYV3hSOHl4WG9SOEI5?=
 =?utf-8?B?S2wzQUlUV25TS1JGVXYxNzFCMGtWdXhnajg0SG8vSHBQR0RIZlc2TWdVb3N3?=
 =?utf-8?B?bFovZk95eDBUajNsOTk4d0luRHRRQ0ZEbW9UK1BBbGFZamVkajQ5aEJQdkxP?=
 =?utf-8?B?Q3dVQ0ErSHNFaXd0MFhVenpCV1ZCanA1dXV5dVJnbHR3b09FVEIxai91dTJV?=
 =?utf-8?B?YzhOWW9CZUJLYk5zUjZpbWRIVEFLMGFvZlJoNXdFYlpzZzhLU2hqMDNGeGRK?=
 =?utf-8?B?clUvYTdIb2FOUjJWb0VaTytnV2VJQ1lZT0ZBc2QwTnBoMVEvOVdqcEhMSGpq?=
 =?utf-8?B?VldiRVVTby9XMmtwMVJObGh6alhZcGo4bTZUcDEwdFJrRXZEdUtMbWR4b1k5?=
 =?utf-8?B?RmpKRGJhWnNzKzBHazFZYTZqMEF6VW4xZVdCdlhtQkRJdUliZEIzOCtFemNi?=
 =?utf-8?B?VnpBSVgvU01zNFovdU9qNEpKU0xXY09QQTVXMkl6U2Z4NFg2NG1NWnc0S0pK?=
 =?utf-8?B?elc4UkRVa3BpK2xITFRyVklKd2RDVXpYMUtCQ2h3TjJVd3Nham45Ti85WXFG?=
 =?utf-8?B?bFY0MEVBaFlRR3RaY3NtZWtNR1VPeW9wN2RPRjFFTGd4WFd2T3NlZnYydG4r?=
 =?utf-8?B?ZTRiQkt3MEQ4dFpvTk1WK0FKM2EvSnNRVnY0RGUvaUZta1FGN2JFQWs3aUd4?=
 =?utf-8?B?RkVST3FqQmxuODlaSkN2M3ZlUE5vUEV1VTdWdGRpMkErTlF0V3BQTjNidUJQ?=
 =?utf-8?B?YjVVSi9SU1kwS1VmT253NTcwTmEwbUxUbllWZ0tYMFBaV1BKWkpLOHBpeXRh?=
 =?utf-8?B?SWY5VXF5U0VINmk3Vk1Gb2o0ajVoSFIxbkpJWHkwQVNjemZuZkdwVk92bGt1?=
 =?utf-8?B?djBLeXBDV09YRnZwTEFCZXMvY2RLblVqTGhyV2NHazgwK2NwYnlMcms3azVh?=
 =?utf-8?B?b0tMNGp6V291YkYwbXZUQXhBU2lxNTNlZU90WFIrNnRsejlvVzVybk52WWxt?=
 =?utf-8?B?M1dtRTg4M29icjN6Z2hkMXZ6UmhQUmpZRTcxcWlmTHJSdlRpY0lLMnV4aG4v?=
 =?utf-8?B?S3RBNXJnMUttTkd1c216TkZ6WVhCQTV1NXVRTTlYL1pJNXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elR0WXJwUFZQWGRpeVdIT3JoYjZobTRQWURJVEJ4bUNtTlZOYzdhcFlQRS9O?=
 =?utf-8?B?WUlOdGg4bXE0ZlZsUXJ4dU5YTEdDSXBuV0RoN0hrZjI4d3gwYytmdk05bVBP?=
 =?utf-8?B?emcvaXRsNTYyNlZ2U1BhNFcvcSthRndES2c4akd6SDBQOG80OHNwVnd3WTJX?=
 =?utf-8?B?ZzE4Q2Z3eS8yK1BEQ2laTU5Gc0hmdXBDT3NTQ2xSM3lnYS8vTWlRd0k3Vk5p?=
 =?utf-8?B?aTFiTUVkZm16eTk4c3dNclNPR2ZIK0ZPTzljcnA0MkZnUjRhUmhCbkppZ3Fu?=
 =?utf-8?B?MEE5c1R2bkZqME5maWJ1MlFxVFg5dHlLai9Zd1NyM0JGMFRTQko1SE1NbEJo?=
 =?utf-8?B?V0ZocHpoek4vdVB2bklMbTZURHJUdFlFZ0lXd0M2VlF0bzJidUlGN1VqbURy?=
 =?utf-8?B?ZFNtbm02WUh2NkFYMnVrL1lPWGZ3NlB2eFBDcWswSEdGKzVRRUF4QUZhZnht?=
 =?utf-8?B?WmlQSUtOZEwyYXhON05QaUk0UDQxM1Q0TVhKYVBxbUQ1MmRubGkydFBuSjB2?=
 =?utf-8?B?YkN2UW9yMmQyOXljaVNuVEI2dGdVUVEvU0hDWjhVQ0NGcG9wTWRqUXorbEwz?=
 =?utf-8?B?QnVvYlR4ckRPcVhIZ09JWG4xSXJFSWZYQWllZW1mSk1LM2ljMGJZOUxHYThN?=
 =?utf-8?B?aGdpeGthNWhjQTh6a01xMTJRUWw4U0tCbGg1N0FFYmFiMi80SlZyWldPa1M5?=
 =?utf-8?B?dmpYMmxDWXgyY1NkU01CNjFVVFI0MlFpUjhvem1QWk01Z0QwaTBzSi9McXYx?=
 =?utf-8?B?ZU5oRzZpUGY3MHkrNVVtQzNpcVo3b0YxOVFwT1hoVFA5amdGNWtLVk9WWEVW?=
 =?utf-8?B?Qmh5RGFzYStjUmdmMTlmQmttVnQ5MlRsZ1VkMlc5YnM4RHljWmZSL2tRQ2tV?=
 =?utf-8?B?aG9Sa0NOVnE4UDNLdzJDajZsWU5NSnVnRXZlQXpnb3N5K1RFMjBweTRvWi9h?=
 =?utf-8?B?TzRFYkVIWktidFNQRXBQRVFRYUpaVXFuaDFnZ0F3ZjVkaVNnYk5TS0xWMXRC?=
 =?utf-8?B?eXVocW54aUx2MHJSd0lWN0t4Z1ZWYlh0dzRCUkdUcEdVRVJ3cStDdHFyT1BV?=
 =?utf-8?B?Z2RPaUhOZTdLbWRLd2tYTFpPWkFMM0tyc2ZjQUhkdHI2aFFRUE5YUEVQM1Z6?=
 =?utf-8?B?UnFwem5pSnZnVXJybTRET1Eyd2FvUUI3eTBweGlqNnBQcDE3Q2Fzb3VvWUM0?=
 =?utf-8?B?bTZDVU1uYnZTT3VqY3BuUzNVaTJmQVBJUnlJNUtUSFhubXhCNWhQVklTSWR5?=
 =?utf-8?B?Y2tQRmxpZFRmZ1hhUGs1Y0c0WTBkdXpqa3FGaHNaQ0xZRDdlZkpmbWdtakhl?=
 =?utf-8?B?Wk1lYkd4SEFQTnBLMkd2UkptN1B6WHhoNUVXU0t2M1B4aUpaSEZIcVFFN3Ri?=
 =?utf-8?B?enV6OHlHUkFJTFZ6YS9hY3RCcmZCeU9GclM2Qzh0ODZTVHB4QVZFWGNQalhz?=
 =?utf-8?B?SFRzQTZiRXBGLzlHQldMT3lsMTY2bVZScjljdlE2cUJRZ3dsUVF6N2RCdWRT?=
 =?utf-8?B?bVFjZ2FuOXV3OWZCZ3BwSzBvb0gxK3FYNURhRjZST0hEMWx1U3g5YmlOQm1Z?=
 =?utf-8?B?TGxyNzlKNVc3L01xaDExYnpvcWQ5dzBqRTJtR3VaVWtKT1I0eXB3MWhFWTJ2?=
 =?utf-8?B?cWFRSEhYRzBVTkRKcjlnZlkyS1pEcXFlWHBFN0U2c2VkOUhCRWljNWwyWXVD?=
 =?utf-8?B?ZGt2VXQ2WWwyWUlBOWphekV6UXZmMys4SHlOSnFwcUdTbXU5T01ITlBVQ0ho?=
 =?utf-8?B?TG55T1BJaXd0amNmcFo5K1dIVVM1NFk0U2l4VXlUQUxpWmNkMDBoMk91SGZ2?=
 =?utf-8?B?Zjd2dDdXdlJ0b0t6enFldmtVUEIxTk83bUJzV1JJdDFnNkF2MkRScDJxYnZ3?=
 =?utf-8?B?ZHUrbkFBSHpUY0NkSTY0NzB6c3VMV3ZuQWp0Y3FwS0NmYmpUU21halArRjhy?=
 =?utf-8?B?UFdDWUl5UlNtcjNLTGRpKzdUZDdXSWt1UGJkWnp4NGFSMVlaSUM1UkJtbStZ?=
 =?utf-8?B?ekdGTlVEdXF0d1hrdm51cW5GL3YrWWtHSFBNKzR3MzhpUmhLclIxL1VueU5N?=
 =?utf-8?B?NURBWXRGaUk3bXpWRVNqY29vVEdjWDFoT2NaQnAvZHpJelYrekFIeWhEeW5x?=
 =?utf-8?B?cmNDeHNmcmV1T2ROUE9vbXlDa0c1a1hlU3JIS0JqeSt2Qnh5YlRQbWh1T2NW?=
 =?utf-8?B?cmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <710B8BCA3B341449A4F33B384135871E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa55a11-db22-485e-45ce-08dca497d06c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 06:31:52.2946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ffhDaUSYO/JXNXV0KiNi3C7edGJwRcmFR5DbV6crARW+nZoFShy6KPqEyABlfmt4WJsQN+xyjU9KNA28B6hUxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6492
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--8.393400-8.000000
X-TMASE-MatchedRID: ewN4Wv8Mz/jUL3YCMmnG4t7SWiiWSV/1uYl8SpOhWWUNcckEPxfz2Iu3
	renu5Y0w5acGuJwdSBa10qVNGlRokem4jgMXwUpG4bl1FkKDELcUCv7A9Z7uMSa7ZcqwFxbx++3
	gQ26tbbhdKNWDOIhT05GTpe1iiCJq0u+wqOGzSV18GfB9SHbqW2Z85c5StTiXUEhWy9W70AEgBw
	KKRHe+r31JaD0vnbX8SxZ3BtPubt7OIbfNoeR0Rw88E9VULvToZaVmhhETh8A=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.393400-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	AE0C1E05C63BB0C5AC078C07D00ACFC473489F870AC25FFAEA5F4AA89ACC59E72000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTE1IGF0IDAwOjM3ICswMjAwLCBCZWFuIEh1byB3cm90ZToNCj4gDQo+
IG9yIGNhbiB3ZSBjaGFuZ2UgY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZoYmEtPnVmc19ydGNf
dXBkYXRlX3dvcmspOw0KPiB0byBjYW5jZWxfZGVsYXllZF93b3JrKCZoYmEtPnVmc19ydGNfdXBk
YXRlX3dvcmspOyAgPz8NCj4gDQo+IA0KPiANCj4ga2luZCByZWdhcmRzLA0KPiBCZWFuDQoNCkhp
IEJlYW4sDQoNClVzaW5nIGNhbmNlbF9kZWxheWVkX3dvcmsgaW5zdGVhZCBvZiBjYW5jZWxfZGVs
YXllZF93b3JrX3N5bmMgY291bGQNCndvcmssIA0KYnV0IGl0IG1heSBsZWFkIHRvIHdhc3RlZCB0
aW1lIHJlc3VtZSwgUlRDIHVwZGF0ZSwgYW5kIHN1c3BlbmQgYWdhaW4uDQpJdCBoYXMgaW5jcmVh
c2VkIHRoZSBzeXN0ZW0ncyBwb3dlciBjb25zdW1wdGlvbi4NCg0KVGhhbmtzLg0KUGV0ZXINCg==
