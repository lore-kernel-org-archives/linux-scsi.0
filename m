Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871513AA3C;
	Mon, 15 Jul 2024 06:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721024857; cv=fail; b=kmMhOiF9BvI+pVZcIfiT6HZcId+2JQg2HAziCCqflFsL61Hy8rDQVCkO55Z5J1hOPc00+vUqQA3y82VnoBGJJL5muct9UzIINDz85bW/++PwfSyTP2/Mdu8mQ+/KgHAFkBhFo5coqUpJKfvPY96ZM8tb9ZtXov7pLKUUka6Gjf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721024857; c=relaxed/simple;
	bh=pclIrbT2+ayMfiYQqfEB1nilimdMwPcXjGhbax4y+ew=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r+MuXTe7aiUwMs9Jvf/DKYzpvHo7j92PVCyVIGCdK8dFX6aN8s/uggyv7o9fbFKlUcH5tgJZJmOuf6eR8+G0g6vULpk0zt4Z4iEiE9R8ZfLvpYCsef3pT4MdVtpv91cyySIKVT9BfPGMMMxKmH/FWsLxPaDpnjTLgOnjDCTVz50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uk0pYdVc; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=OSF3svWk; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uk0pYdVc";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="OSF3svWk"
X-UUID: 4d2fbcb6427311efb5b96b43b535fdb4-20240715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=pclIrbT2+ayMfiYQqfEB1nilimdMwPcXjGhbax4y+ew=;
	b=uk0pYdVctIkOD0v8uj45JZS5rq+mf5vKlPo3c5MtGYNfQLYCnfknDX94g5fEYltf3Y4HJzP7Dvk22oMvIEpGaM8kTqHT1OFRzyRsMDmHyUPxWoPxjDO/VoCHkwQN5mqaonvPjvMHZ4ojn1c6TZ63Ww7f6XYKBBtG3b3H+hCZ9lI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:d81c10d3-60d2-4a5d-ae25-eddc5b462612,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:c48559d5-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 4d2fbcb6427311efb5b96b43b535fdb4-20240715
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1849821352; Mon, 15 Jul 2024 14:27:25 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 Jul 2024 14:27:25 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 15 Jul 2024 14:27:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZLvyQnfMBwSrAG+sy1phT5YrmY1SQi28MWM0MfgRWzdYc40CJKMn/NnDj5qoAGMELLlkP9NrvkcfpTojVimwG1W7XsZsLMb1fljCJvT4uXtG/fBGxoX2ZSI0pufCohR+YMWgjOBDk9fqQiV+Nbg4ENYzbwZq4Sn3dssFVxpCQIO/DIztg6N3mbp9ymzSGuNypMoU1SuuwYqfEUDa+Q/1fWpC4p2HTYFMQ8ftYQIlz3gVrWGOQwNSU25xLoWCHBBBbv+KCogHjzc7/S3aFmYPrjGNSZTOCuCv0PwZitFjAg8zROqwpw4g/iB2nO010ndfN/bNwiiCfXQw9zYAb2Q0kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pclIrbT2+ayMfiYQqfEB1nilimdMwPcXjGhbax4y+ew=;
 b=KdHxDWbIM3T2Am4rntkXika6iuucW+BYuCZ4M5+MGAng/eBtaZwu4pg1CDdSq1pYrzK6nwzWv4uEslVlp3hO/VyAlU6dCUApjab7How79gBhELf+/o6rsHz3D1hdXS4pNph3H0/lmvsKso+Hr5w96Gcs/8JS3+oavZrc7BEK6jDTKfqTuCkqOFqlwVjfxuzixm9wm6+KBhK/gpmwHdLEMGE3mox6Kxs5Jvu7/PsrcXc4xBtnZ9c8Ep/I72TZ0sp03hYq1HqMl85c6yRxUmwW5FKqfw4MeAHC609176Z7XDEWgSgADo2s/K3zPOlpQjuipCAXbVGqrtaMrcd4L/LiDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pclIrbT2+ayMfiYQqfEB1nilimdMwPcXjGhbax4y+ew=;
 b=OSF3svWksJA+QFOnSa2mMn9g6GBhvmabZIksQySxvL/Vi66zDXr5fq1xTCH/f/NxqTmUS65J3hCNFhNptq6Lm6h+VyBKDig3+DFzGGziqrx/lj6TSFITDCFg7u1ht2pIw5UKvVtFSd4THF5z82gH86pIvUZ6eOcPyiJcyITtftk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6492.apcprd03.prod.outlook.com (2603:1096:101:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 06:27:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 06:27:22 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"Avri.Altman@wdc.com" <Avri.Altman@wdc.com>, "huobean@gmail.com"
	<huobean@gmail.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
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
Thread-Index: AQHa1EAILL2v5M5cn0eBJ19m5454I7Hy5WIAgAAEeYCAABxfgIAEUV6A
Date: Mon, 15 Jul 2024 06:27:22 +0000
Message-ID: <36907696405eb203e0529d487b6858b33abf37e8.camel@mediatek.com>
References: <20240712094355.21572-1-peter.wang@mediatek.com>
	 <DM6PR04MB6575B81B788F260A8C640684FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
	 <edbedd4e992dd0adb93adbd45a74614c4c0f626d.camel@gmail.com>
	 <DM6PR04MB6575CF59300D4AB5E1BE1377FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB6575CF59300D4AB5E1BE1377FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6492:EE_
x-ms-office365-filtering-correlation-id: b0aae90a-8629-496a-b021-08dca4972f62
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M0NobW40d1RPS1RnZXJFWW9wci9raXJvTW45VkFPYUo0MnRGalBkSm42T3ps?=
 =?utf-8?B?dWdlMEFvcFlsUGtXWUlTVlFNSVFYeERGN3RrazJSVm0vOTMydWFrQ3Y0UFp3?=
 =?utf-8?B?d2hwMFNEWnVYRDRLU1l5eVMzSjhjVHRwQ09tOFRrUGlhRVlJeWNKNi9LOTkz?=
 =?utf-8?B?TXM5dnFybDY5WTF6OFNIbHdjbHV4Vmk5YUxjNW1XdURkNlJ0cEFTeCtJQ0p5?=
 =?utf-8?B?ckp0RU1yakRDSjVzek1sa2ZZbXRsdHRqSUc2VmE3M3cwNDliYWhvb0djUmNx?=
 =?utf-8?B?TjdzWkx2VFpWR0htVGhWZ0lKM2l1NVh5STdUeVRqNDZFOXdqTG9WVVlEVXFj?=
 =?utf-8?B?WWVaWGQ0SGNXc2tMMEJteUwxWHFmdzZZYVJhNDZiV0VMcnViRVRtTVRqOVJu?=
 =?utf-8?B?TDJ2TDludG02a3pHTjVKOWxDMGxwQ2FaK1ZTd0t3ZHd3WkE1OTlhcGFjU0xr?=
 =?utf-8?B?RmczczVNQzBFb1Y2TVVxdExESVkrbE43WlorSXlsbERYb3JOMGhiTmNMNmR5?=
 =?utf-8?B?QllqdFNQeDRYZDEvVHR1UlBhMmk1MHJxMkd3VXdWdmNqVkhSWUpkOThtYUVU?=
 =?utf-8?B?dWVjdVJYWjBLNUNjSXg5L3NqSXUrMmFlbHdhU1BNRXlJZWNuUndYTXMrQmpo?=
 =?utf-8?B?cGNDMEo4eXM4bEIvcDhxdU1kdkxzd2FyZTlWYWROUHdnaXR6dU9hb284eUNm?=
 =?utf-8?B?ZHdROHd3cHQxTllsTVpXK0hrcGRLNjlrK1lMUzZ4NmRsaW9FKzV4aUVmb25j?=
 =?utf-8?B?ZWJTYVlZUmhyQ1A5ZGNuZDRaLzJQdFFVU3BqOFdGQTcyMTdmWXMxVXRMVXI5?=
 =?utf-8?B?MWJ3MFYwb2NaTllGVlFrTDh1MDJHcHdkNXp0dWhjOFZFZjRodzdnZFZLaE04?=
 =?utf-8?B?TWhvbHB3NCszaUxYcC90bFAyTDJabjNGWHZTY1lYWHhpOW03a3p6RStTUmdI?=
 =?utf-8?B?VVRHdjFSckVuc3NGMktCSHRzOU9LdmlSRzNJK2QzUXNORWl4TGgxNGw2OTJV?=
 =?utf-8?B?U1RObDBaVzdrUE9FT1d0aGk4RksxR1F6SjgrZ3ZsYTlINkd4YjZyaGNkMTJG?=
 =?utf-8?B?UjNydXJSRHlsb3dwSGdlUkk4RGY5V29vQUNpTjRzMlBHQWpOcFkxYzB2NFU2?=
 =?utf-8?B?Nk9JTm92dG1uT1dwS01EUWJxbEtsekZIcHh3UzMyRE0zc1hHSTFzcldlZnBK?=
 =?utf-8?B?VitIVWRzMEJUMGVUMDJnakllM3FjZjYzL3lUZHc0Ri84MG5xOW5LbkIwbmhl?=
 =?utf-8?B?djZzRzU3VFNDVi9QSlpGSnYyaUJZd3Vsb3REcEZjckxRZ0N4NGYwdlFPYU95?=
 =?utf-8?B?eHJ2VzJUZWtrdDI2OEtCb2xwWHIvcGkyTGNTYUw0bG80MExHY0lRWE13RWdO?=
 =?utf-8?B?MkYxSUJzT1NkdEdEdW5aMG9Qb0JzRFZqdGs3aSsyWFRLWEp3UWhqeGQ3SFds?=
 =?utf-8?B?UUxydGxvNW1vUGhuZjBIVnNjNDduUVJHcVdlWlo5Tll5UzZjMmFXc201cWVk?=
 =?utf-8?B?cHVWUDBwS0xzOUUzeHdkbTFSMmZoWUxZSllOMS9IRFI1NE10MnFmTDFHVDcr?=
 =?utf-8?B?aDdvOTV5S3hYS3A4cndOQmlDdGVHb2ljVG43eVk5aWp3S0E4Vng3Mmc0dENS?=
 =?utf-8?B?L2JZcXVkNXJXVmhsYlhRTG1pOHd4dEt1UlpPQ05BWTltQk1TTVFZTTN5UE1O?=
 =?utf-8?B?ak83aHVMZnI3ZXJheHNrYjZzUlBZNE9TRG9hTGZPK0hoQ2xCRzlKQzBMemJt?=
 =?utf-8?B?bSs1OHpscTNiYTd5UjZyNW85VC9IT25Zb0pSaGx3Vk9sSE5ISVBsM3pXRldn?=
 =?utf-8?B?ZHo3WWFuQ1NGajlkRE5JVlhUSG1mZTJZL1VtOStpT2pQQ2pTQ0dFZWdRdlNI?=
 =?utf-8?B?S29kTDVXa3pUVmxCcEFwMm1qNWdaSGJmTDQ0OFV5QzNrREE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ei9wZmY4MkpISEVubU9CNG9YS3JVWm1mZHNCZEdtSWtqbm9FRUNEOHBBREhx?=
 =?utf-8?B?dUQ3amprMUVUWVgxMUlCVllzNk5ad3NIV2FwY3FSN1VVRG1oRGdLci94anhB?=
 =?utf-8?B?OHRMM2phd1JtcE04dUhDQm5WVXNzSndXRjhzQkgwanFlU01ZdDBtanQ0NTZP?=
 =?utf-8?B?RHpxT0dpVFhRNWFvR1VHVGUrVkQ0L1FBQzV4eldXY0hRQ0U1U2NKUDVaQWtZ?=
 =?utf-8?B?eDFzb01LSzFnZGoxMkt3T3FJanl2NDBLazc1Tk82SWdkOUlPKzhQbzdDeCtL?=
 =?utf-8?B?bC9Ya2d4NGJyR2FmTnZEZmNLTHVCdnBUbC9DaVVTRmhPTEdoQzlIc0tIbVZG?=
 =?utf-8?B?TWlqR0NBOWlUeXVGU240NUxZTTVxQy8zL2w1SS9pTnY5amZRVmpyL0U1bFVr?=
 =?utf-8?B?WU51enVITk56aDJtK1UvdndPdENOZVNNbGU0RVpieDBRVWR0Qmt2c3pvTG1k?=
 =?utf-8?B?WG9Gdnh1K3JaMkk2U3h1aWhDdFJ1dXU1MXg4TzVKNmNPY1JrZS80RTE3U3ZE?=
 =?utf-8?B?UDlIbG5aTVNkejFWV1NCa2hhZDlqaGRFckJUQ0lIZVZEL25SSWlWTUNaUTg2?=
 =?utf-8?B?SzBpRUUxdzNSSXdlQ21sYzNlcEI1ZDd2V25RWENDME5HVENETmU5QWlVT0tr?=
 =?utf-8?B?TlRveTAwbmRiWjBxS0FTU2JiL3pYYStmY2h4c0FTZld6WDJjN3BBMDRyNWtT?=
 =?utf-8?B?Z043a2RPL3lvWXg3QWUwZzdNVm5RNi92Zk03UFc5NXRka3dURXNRUHJwSTlD?=
 =?utf-8?B?bE5ZV2VWTy9vOW1qbjdGZVVpclc1MFZTWCtrSWdLOCtBN2xQZVB5SDgxQ2hM?=
 =?utf-8?B?akFZSldobkJZZUJuR09yNzJSVmxDeEU5c3pmWlk2UjFKTWxaQ3NPTmVXZ1o0?=
 =?utf-8?B?eUluQ01pQ3VReUpYa0pSeHFIeWNEUTRuTUtEWHJzUk9zbmpTeGFFUnpkR0Fy?=
 =?utf-8?B?OG1MNWN6MmpmcW8xaERmL3hvUlNpdXZoM3B2SjVUTllxUVRWVUtDN1RvOTVm?=
 =?utf-8?B?MTBsMEUzTVRwS054Mmt0S0dyaDhvcm5mZUU5b0hudFBRczZ0TEo4bG8waGhE?=
 =?utf-8?B?dElMOFZ6NEhURXBWRitEWW9lN2ErMnU0OTNXaDAzMmFra1QvZzVnR2wwYmZC?=
 =?utf-8?B?S2dFaTh4MHNWNW5IWkJXaGdubmQ0SHF2K3FXMVZGOVRSbkc2dlBEdmhJekJC?=
 =?utf-8?B?ektOQzYvVGdZbExCeUFHcXk4UzMzVVQ4SGY0NW1JK2pqWUxDV3htcVJSbVps?=
 =?utf-8?B?ZHhjbHIyajR5UGZjVG5BZm9HQTJXeHlvUU1QNm9NNC96U2xNd3FJSG9TRWtM?=
 =?utf-8?B?N21CNytrSlF6MDVTOWtiSnVLUGdVUERnRXR1VEJSdWZXNm9XVmhlUnZ0OVcz?=
 =?utf-8?B?SlFlWXBJMGRZWGRzeVVZTjQwNSswOVlGNVdFdTFicHRFcW4xVStoMGlvQmRj?=
 =?utf-8?B?WVFSNURNNmhnT3ExVjh5RGVxdFNrLzRGY3VkQkhoTytFZDZKR0UxK2tORWNF?=
 =?utf-8?B?NDU4MXZZc1k1NGFoOGNxRVdqVzVtbWRIZDZCNVozMnJWd05ETVBsTGQwb0RB?=
 =?utf-8?B?U2M1b2FrU3VrNXFZanlNcE80cGV1Qm8yQlZhOW44NWV6UHQxRzZRWHNLQ0F1?=
 =?utf-8?B?MEU0K0VnYzlQTjM3VkJHZmpYbGoyWTA0M2N1cE9LUWUvaVY3WHdnRm9aU1BU?=
 =?utf-8?B?bDVabFYrNXhid0s4SG9JYWZZa3dXTi9EcFNlMWxIaFdCR2JNa0dZOWVCWWpt?=
 =?utf-8?B?V01zbmVjcnJnZkU3RDN3b3lDWW9SZDQzRDU4OGp6S3RTZWlVYktxVnd1S24y?=
 =?utf-8?B?cUNIMXE1MnFTTXJyTHRubGtPTXBmanJON09TbGNIVFIvM0ZtU0U0QUU4dHhN?=
 =?utf-8?B?eXJlZ2NNSzZtT1RDOFdZQklNY1JhV29neE5sQlVuRjlOallrRmF2Vm1lSlNv?=
 =?utf-8?B?R1NvWGtLcmIwVTZPdkxtQ2wyZ1hZeVdBMFQ3TlNMYlNsQWdUOUtQUUdXNUN3?=
 =?utf-8?B?ck54MVRFdlVsVnlwS2dERGN6dW9vcUl6Tm9md1haWjRjaEw1bmhjQTN4bDMr?=
 =?utf-8?B?aFRIWWFzVFprN0lwakwzTTE1TlIyeWJ3bVRrY2hzOUN6OUxMcXZ5SXJHUUVR?=
 =?utf-8?B?SERJcW52WHppMkFtcWJuY2wyWmx6WW91ZC9oUkFZUVcwaEtnYXRMRlgyMTRx?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC98DE5D9CE55244AEFBE624D0FC4423@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0aae90a-8629-496a-b021-08dca4972f62
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 06:27:22.1151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pWgPYcsxXJfi6WgNaCevhWyR7SZK7OKkbbSihw31iHOlYfIUWyUb+R+aF8Cj21PCO0DRmfzSDCX/QN06R5plzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6492
X-MTK: N

T24gRnJpLCAyMDI0LTA3LTEyIGF0IDEyOjMxICswMDAwLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4g
IAkgDQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhl
IGNvbnRlbnQuDQo+ICA+IA0KPiA+IE9uIEZyaSwgMjAyNC0wNy0xMiBhdCAxMDozMyArMDAwMCwg
QXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gPiA+IEBAIC04MTg4LDggKzgxODgsMTUgQEAgc3RhdGlj
IHZvaWQgdWZzaGNkX3J0Y193b3JrKHN0cnVjdA0KPiA+ID4gPiB3b3JrX3N0cnVjdA0KPiA+ID4g
PiAqd29yaykNCj4gPiA+ID4NCj4gPiA+ID4gICAgICAgICAgaGJhID0gY29udGFpbmVyX29mKHRv
X2RlbGF5ZWRfd29yayh3b3JrKSwgc3RydWN0DQo+IHVmc19oYmEsDQo+ID4gPiA+IHVmc19ydGNf
dXBkYXRlX3dvcmspOw0KPiA+ID4gV2lsbCByZXR1cm5pbmcgaGVyZSBJZiAoIXVmc2hjZF9pc191
ZnNfZGV2X2FjdGl2ZShoYmEpKSB3b3Jrcz8NCj4gPiA+IEFuZCByZW1vdmUgaXQgaW4gdGhlIDJu
ZCBpZiBjbGF1c2U/DQo+ID4gDQo+ID4gQXZyaSwNCj4gPiANCj4gPiB3ZSBuZWVkIHRvIHJlc2No
ZWR1bGUgbmV4dCB0aW1lIHdvcmsgaW4gdGhlIGJlbG93IGNvZGUuICBpZiByZXR1cm4sDQo+IGNh
bm5vdC4NCj4gPiANCj4gPiB3aGF0ZWxzZSBJIG1pc3NlZD8NCj4gYSkgSWYgKCF1ZnNoY2RfaXNf
dWZzX2Rldl9hY3RpdmUoaGJhKSkgLSB3aWxsIG5vdCBzY2hlZHVsZSA/DQo+IGIpIHNjaGVkdWxl
IG9uIG5leHQgX191ZnNoY2Rfd2xfcmVzdW1lPw0KPiANCg0KSGkgQXZyaSwNCg0KWWVzLCBpZiBk
ZXYgaXMgbm90IGFjdGl2ZSAoUlBNIHN0YXRlIGlzIG5vdCBSUE1fQUNUSVZFKSwgd2lsbCBub3QN
CnNjaGVkdWxlIHJ0YyB3b3JrIGFuZCBzY2hlZHVsZSBvbiBuZXh0IF9fdWZzaGNkX3dsX3Jlc3Vt
ZS4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo+ID4gDQo+ID4ga2luZCByZWdhcmRzLA0KPiA+IEJl
YW4NCj4gDQo=
