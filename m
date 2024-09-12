Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB401A76C3;
	Thu, 12 Sep 2024 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726147901; cv=fail; b=Pnlipmz3MgntFPIpQ/E9XFQuoRqGyTjaYN4WWXumKGlRE0ojZ4cjpT3Uw6ay/EzXK8h0bgJMGn7okQ7Xo7J9G2fodgcr9bx2t69or81p8GSERWpA6s/hQ/AnZA1vqp7rU0+KVJoH9Yd0fnBB0P1pZ/w40T89gTIIP2Qz42q+51k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726147901; c=relaxed/simple;
	bh=jChd47ngNG2xH5u68bUYx/TVgl2M19LeQU4ZMp/D9HE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LU76lSTVqq5MJzGyvBe94QuN0uymHzqWldT/tKwNDUKnFgJTe0B9VU5giLvvY/2zMFHopY7fsPyNfZdYhoFYFLZhwYbU9i+FXDx2xjiFGpYOfUKxm8uGf1j1bX5fkpBQ9ia1d8jJeo0BXPmaEmkr0l5BBf1wSVZ9IexfP3B6/yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=KdtRFp/F; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=TFBKLQGy; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KdtRFp/F";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="TFBKLQGy"
X-UUID: 53b78dae710b11ef8b96093e013ec31c-20240912
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=jChd47ngNG2xH5u68bUYx/TVgl2M19LeQU4ZMp/D9HE=;
	b=KdtRFp/FKmDfGlKrSeItB1RhSkDOJgR1F++yaXkOvbqzRjxAnCYk5Al2rqCcdN1ZUS+8UcdoWYgnPsJ76TQn8c81aSrJ1h/86Q6TU4TZjQxaujv9dVzoeItZ4DafuCI89Lidftk3KAoN0mwolu3zXs/ySHtXpfhCho+B4xjUtvU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:ab438541-652b-4faf-b30d-ca2053690922,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:81a51bd0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 53b78dae710b11ef8b96093e013ec31c-20240912
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 470195442; Thu, 12 Sep 2024 21:31:33 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 12 Sep 2024 21:31:32 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 12 Sep 2024 21:31:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bU+dUnbGj2zJYtZXvA8a057R2d3beVbu5A/D4yrQyI2s33Ut+MIqi3NC3RPYkyodBEnsrASuOE3I9ipZ0dCcyGhSHCBGX/aodeM/KflB+u3626d+Fd+HWp6OE6SJzplYLlIukxqyEGEAxKrpjjcKy8qBcxzRI8vqW5JfcG8hleLJXHd9DV4u41Igl9GKrYayUDrYeL0O1Z1wCaf/AUkyd94euQ17+5f7te0JIavvdH8tnqeJe+HggHUiIkR2vIm09W/NVElQ1qtSFTShM9Qa8IVBY7jAdHD0dHuWLiUOQuAUUDN2Pf/mMPkmBmLhXy29njsC5Dg8Oqa4LRjUe4xt6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jChd47ngNG2xH5u68bUYx/TVgl2M19LeQU4ZMp/D9HE=;
 b=SAbtZvNRK6HCW3O6lLe81cWBIr/zNDXO9SsxoufMlgAsZ10QUPAfBvyobVNmvHnpz1STRJoReDWlrKZwciVLXiXxcSAmdvQiBdCYWeAfE7QdLNmqCBVK0ZZcFBS8wlxNv1eN6kDEc7WklLuCH0OXwxVSZ5MO39OlwYS6e8RxROYzU6fJsSAoY+STXOyjNtuy70aUaXzn9GuIDYau5ovEahpk40uqJQcClSP5zCZlb7usqr8178Mn4qGMAG35O4ZeZfxDM0yTnLk8xeOquSyZC54+QuMNtYn48p5oUKWssW7O8YQEWJqklkWQnAW9frgjvglV69S+tWpWN++S6EzbBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jChd47ngNG2xH5u68bUYx/TVgl2M19LeQU4ZMp/D9HE=;
 b=TFBKLQGy1qq/075O6Zec/9nHEfEsh03PwURS74+vt3VbQIRu1kNTRR2Blb7J05Vfv/WfcmB80vzm9qJo+/LHeKGdaHJC5hwvriBTynsirA5FSDZhfhyWpbt1qOsrgvC4wYxQBoYsnddpLEehiHtsAccUUInFsPg/98XLTEf8XHA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7922.apcprd03.prod.outlook.com (2603:1096:101:169::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Thu, 12 Sep
 2024 13:31:30 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Thu, 12 Sep 2024
 13:31:30 +0000
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
Thread-Index: AQHbA1N1RX6n4EeryE2vN/rAxATc77JRT7iAgADKYQCAANwoAIABMz2A
Date: Thu, 12 Sep 2024 13:31:29 +0000
Message-ID: <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
	 <20240910073035.25974-3-peter.wang@mediatek.com>
	 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
	 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
	 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
In-Reply-To: <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7922:EE_
x-ms-office365-filtering-correlation-id: 4877544a-0390-4a22-8ff1-08dcd32f35d0
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eWxHakZhNzdqdUsrZlc0dGNjclR5QVZZVzNFRmxTNGg4QkxNOGcrbGp5d1Iv?=
 =?utf-8?B?TUlJbm9HaTN2QXFPa2NOV05WSGMzL3VLdGE1MElUK01UbjdYN2RCTWFheWt1?=
 =?utf-8?B?RHdkRThMRmpFcEtFTnJJRHVpcWl0U2RmZ2FRdVFZaFRmMjFpOGV2OHVjMG1w?=
 =?utf-8?B?YzRERm5CZU04ZU9RTHo4aWxkdkM4TW5OQVQrS2dGa0dZbVh2VDBRQkhtYWIr?=
 =?utf-8?B?Tnk5Zlk1QzFicVY2dHNGcVgzU1hDMlpYdmk0cUZqMXEzRTRCT2lsQ1B5Tkh6?=
 =?utf-8?B?b1NoWE1qeTBWM3VHNjNobXRiUU5aVDRWeVA5N2lMQU8zK1FSOEJoWklPcGFB?=
 =?utf-8?B?cmdIUTVLZ0FGc253TUlZZWFuMkxqRW54UU5ZTEhDM0lNWSsxOHIwK3BRY1VB?=
 =?utf-8?B?d1NHYVlpYzlYeFZKVFl3UHZTeU5iY3NlSFNvWDZHN0NrNkdKZVlMWTNKYnhJ?=
 =?utf-8?B?RkE5clNEaGQ1OGZNQmZYK1dsVjlsSHA0SWFhbkxGMkV6bm92Um9BanhBdmhh?=
 =?utf-8?B?MGdXNUNvV0lLMmZXOEIvdEVSWVM3UVNVd0tBNE9wZjk2d0t6VjNvbm8rNmo1?=
 =?utf-8?B?dXM0Z2tGTWRrMXRaQVdyTjZEUlNjOFlpRkZwWldha3hlS1ZjRmlYZWZFTWZs?=
 =?utf-8?B?VzZuUW9YamhBa3lMUW4rUDZWVzI2bEpGS2ZzNi9Ld0FuUjFrN1NXcUdrSlo1?=
 =?utf-8?B?NjRwcUwvRHo0dURuVlBudVA2ckY4Ry9XcWFuejk3YU1EalFuSHhHWEVNTk5I?=
 =?utf-8?B?TEdQK3N6MVRTRUxNTGVaKyttTzRrK2JjSEpIMlg2STBTK1ozQ1RNcGwrbGV0?=
 =?utf-8?B?cmF5cHFnTFZVUjVSSVYyMXNHZUVPMC9mUzNPRzFNTWM3NWVlUDRPVDlIMWtO?=
 =?utf-8?B?NlFTS1JjdWVhZEdpblhZUUFvb1ZqWm5Eem5nNHJRcFh5MjNSbXBtcFFweWVY?=
 =?utf-8?B?dW9xZU4yTFdPQTV4Q2lKL21kZ09pRE5neDBLdUc1UFRucm9SUWFPSm5SaHJh?=
 =?utf-8?B?YzJMVlZEYVIya1lGdTdrTURtZmRoU0hSVENVOUN2NXYrL01ndWZteGIwVEFR?=
 =?utf-8?B?QlFnVmljZWt1UGhDMWc3NmVzZXF6Mk9HSGR4YnhtWVcyemNDVWNWRDkySHoz?=
 =?utf-8?B?UWJwYkxZYnMwRHdJY0tubHB5NmprRUxsbDJyMWp2Q2c2a1JmMXpaOGdHOFNX?=
 =?utf-8?B?ejZ3dzF4YjBheHFuR1p0VTlZazBYdVJERlUxYVJaUUVJK2V4SEtJR0x0YkpG?=
 =?utf-8?B?Qm9SOEVnamRVdWRNRHBUNW9mMGtDZzc1TXc3eUdsT0t5Rmlnb01rRUtuSXF0?=
 =?utf-8?B?UGZoSTVQMUMzc0U1ZGxDeGVaREJRT29rRHJPdEJPUkYvOHQ4UGVqc3h1QTQ4?=
 =?utf-8?B?RTFFa1JuVE9tMTl2SExaKzBlY0pFbTNuZ1pDOXI3dmRwSUYrdzN6TVpnYmRa?=
 =?utf-8?B?d3QxSXRTdWlxRG1JZE5IMXh3c1JHM2hzd2tybUFzMXhvMFgzRkdsb2VIeURW?=
 =?utf-8?B?Rjc0QjVJOWFENENUdmM5YllhNTBCamludEpYRzJ2dXlDaG5kT0hQVkJMWjM1?=
 =?utf-8?B?RmtrRjFFZDJ4bC8yeHhZWHJxaVFvQUc5dy9UY1JKUGhtYm9Xckk3S1FEa3ha?=
 =?utf-8?B?SEJtVVl5QW5vWC9pV0FtVFBCdEc2VjBCWXVtL3JxT2tNQUlKTGFjL3cwVzVT?=
 =?utf-8?B?ZVM0OVpoZzNES3VEUHcvQXJJVXo1N25oWnBrSUFXaGkyNE9KNkpHb1hHNkNT?=
 =?utf-8?B?SzZDNGhXZ1RHUHpzd09hdDM5dFlaejY1aUJyUW5vNGR6bi9TWXlCNTd2VnRK?=
 =?utf-8?B?MDI0WGRlN3BjTDBnQUkrbC9COW53bUZBd2E1bkJkNGZhL2lHd2ttZ0pHcjhs?=
 =?utf-8?B?a1E5cGVPaCthZUFHN1A5SU1Kb2NpZjVwd2FDVk1mdWFBMXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWQxemQwRStPMm5pTVVWSTNpRmtaRHFzaHZVZVRMaXlDY0oxdkVVUVVSMURV?=
 =?utf-8?B?SDQzTzVPbDExa3pCcHQ4cS9hdUdYNis4eDJmaUs5K3pGWlpXL0ZXRFpFU0Fu?=
 =?utf-8?B?K3Y4TEtNWlozNXh4YlAra0xWdjRJSFRrTXRxNkxXNUprZ3VWYmZua3pVejYz?=
 =?utf-8?B?QVU0NVFyZlRRSjd0cGsvWFVJVTYvaDFqdW1PZDJDTTF4Njg5Wm5DbUJIcG4y?=
 =?utf-8?B?T1g5dUJFbW91QjBlUnd0VitWU3hnbFFhR0tlT1IxZytUejBFM0YrVWJHRXRj?=
 =?utf-8?B?a3hCUHJlOHNoOXgrWjlpUUUrWEhNK044OG9DelJqRTlYTkg4UTFsQ1daaXE5?=
 =?utf-8?B?djhZZHlGdGNORnU0RVVqKzhMZ1J6bjkyeDZsSk9NcE9xSEh1S29Db2kzQ3g1?=
 =?utf-8?B?cHF5WTE4dXdpcFFCbFhCQlh5bEpXRFI4bi9TbjQ4cEpsQzVLVlZhWGpDUmZG?=
 =?utf-8?B?N2lKNlZwa2htNCtFRjRDVGd2d1dRWXYvMGd2MVVnb2ZuUTgzbmtQUkRBdk1o?=
 =?utf-8?B?TlZjUUJXbm5TZURjS09PTUx4bWVzMEZJSXVlT3IxdkFBcFpGKzZZWXdjVDNt?=
 =?utf-8?B?NDllMWpqN0tHaU44R3Q1MTNIM0JjZVFBS3FLb0UwWmVwc2UyTTVBMU5jalIx?=
 =?utf-8?B?ZmEyMEY3TEJnUmdZc3RkZzJkU2NvZ2hxcGdTVG11Sk9va3BwOFhzVzRoTzRo?=
 =?utf-8?B?cW4reEJlZnZBT1p5bzZNYUI0WFpRcUQxNjh2MWRXa014N0RPOVNmUjc5RHNJ?=
 =?utf-8?B?Q1BtZm9uWUc4bURZU3pPcGpTTmlqakcyVjEwaXJmT2ZnQXFGaXQybGlQM1RR?=
 =?utf-8?B?bW1WYW1pQVJsakhYMG5HeFdmTzdNUDcvbHhvVnFOWGhpQlpsb3pCcGg4ZlFE?=
 =?utf-8?B?QjJSbTN1eW5UNjdoR2w0Z3lGVTcxVGJoVjRXTVNZQnlselVTR3RhUk5SbURY?=
 =?utf-8?B?Z29iUFh0SUZQWlpEQ29RWTIxaUx0NDIwT0E0NTg2ZTFncENoWjNDYXFPUkRU?=
 =?utf-8?B?L2NGNm1UWHBiVmUzdDVtcExManV2OFpsZit2dHJjSGJQQTI0bTdEYStmdWxt?=
 =?utf-8?B?R2kwZkFLODdTNWprazdiaGIrOGYySG5PRTl5Q1ZyVWI0QVZONzlZWklqTmc3?=
 =?utf-8?B?SzN3THZFbE03Um1FMEVXbjF6bEFwY1hCRVNlek16NFZ1T3B1M0k4c01uZUg0?=
 =?utf-8?B?TTJyWG5qb2xRMHk4elN6MGI1WVZhTEVYelo2L3lmaWRmOHBsNEtlLzVGeldX?=
 =?utf-8?B?cUw3emFpTGpQQ2tocUxRcEtoS3FwZnJvM0dvSTNmTzdrVU5JRnRjME4xTjFz?=
 =?utf-8?B?MHFPcVhWWDFGWktOUkl5MkJLeGNldHU3OWEvL01FNTNqSVlWdVRUZWRTMUxq?=
 =?utf-8?B?bUNaWjMzSUIrTk5yR1RtaG4wVXoraURpVFI0RFEzQ3pQbFF0bXBaRFkzdXZs?=
 =?utf-8?B?YVdIU21rYytTai9GYTAyVjJ5YlcvTGFYM3pBTy8yendOTVQvYTB0YVpSd29X?=
 =?utf-8?B?b29xZzMxaG1HUDZTTzBNOEtaK0ZDekl6UXdxQk5kcDZEeE1seXhsejF2aTho?=
 =?utf-8?B?dmQ5SjhqQURMSWd5NFpvMXZHbERURXB4UFFHdkg0UDFJZ3h2S1d4dE4xMWxO?=
 =?utf-8?B?c0NKMk1VSzRNeFl1bWpIZjR4QnNvQmUvY1B4UFVVdUhITCt3Zm5OOXNzR1hx?=
 =?utf-8?B?Wjh3TWRxRTRiWjJ4dWc1MlJTclBRU2Y0czBadVptSkhtSERROGd4QThhN1JO?=
 =?utf-8?B?MWJZUlRyRm9wTTN5bEU3RVR3WVQyREY4Z2dxVnM4eWg1WXNiVE4wS2xocUtC?=
 =?utf-8?B?V3lQRXJCSk41dGdaRUNSUHNNZkZWazUyd1ZOZG95TVpJUUJMNWZsUVE2eTEw?=
 =?utf-8?B?QnNNUi9JWmdPZHdDMVZwL0RRZk8xUFJNRmZwR2Y0YThCOUNaa2QxYTRrSVJ0?=
 =?utf-8?B?L0lYYzJWZlhScHhVdlJ6V0xySEY2NG1DVWgrZzdMVm9rRUdDT3U4WnpNRDRS?=
 =?utf-8?B?UDNPQ1ZmZlgxUU5DRi9CTzkvNzNCOFlkN2UreVgvcjVTWHR0V2lkc1pyK3h2?=
 =?utf-8?B?YkRLb1pVeEkzK1QrS0RiR3RxdVpYRjVuT05XOHJlV09ieEhtMWtmZFpSemZK?=
 =?utf-8?B?VTFuc2YwWHE3R09WM3VlbFJqL2o3ZXhWZ3dlbmJCODFJME0zYmw3UE5qRktp?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80519BF97393F3409F5611631531F041@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4877544a-0390-4a22-8ff1-08dcd32f35d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 13:31:29.9212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oc9YfQwcUpCjhXHcTYj/mLEXB3PcEZbqpnARKqXnZqF0hi7dul8XoPq/u9yFDb0a/RvIS94rtBOJ7WoGSKywRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7922
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--26.339800-8.000000
X-TMASE-MatchedRID: Xkw7PMv+UUXUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTR3R
	HPHTssNWRIFmzE6XKyrFsBvkfo755BciDBzxS5H7tMsi+dai/0dqgUkBwIfKYIbxYwbCxGTTAHy
	DM1D54TkoOtMVP9GHHSYit8pgdsEETY/HRCFabdAz4VsCc1YW+LJXjpJzQSNNjyv+d0Z0OxYNAU
	bXEqINhcq7Xi+8pCPB3v5s9erAS6ePRNmiNLBphqbg9uWhLYLdWjiXAsVR2K04K0IMk2m3Gl/fm
	sLbUsUfAsaSuGlrFX4WYNwECG51wpkkXpMSpG5yWLCkl1lq7ByFq4bKNOR/1GNAPebYwJ/uvekl
	Z9sa6cSACA5ub2VruzikRsWvWhvIDFgoHQs6fmkhEDfw/93BuNjuRIfuOU0cRhxa4AcJ0q6PFjJ
	EFr+olFUew0Fl/1pEBi3kqJOK62QtuKBGekqUpPjKoPgsq7cA=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--26.339800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	834BD0DA09540219E8EAE47C2043E4F34C4DF6194B7263374F815C455157107C2000:8
X-MTK: N

T24gV2VkLCAyMDI0LTA5LTExIGF0IDEyOjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xMC8yNCAxMTowMyBQTSwgUGV0ZXIgV2FuZyAo546L5L+h
5Y+LKSB3cm90ZToNCj4gPiBUaGlzIHN0YXRlbWVudCBpcyBub3QgcXVpdGUgYWNjdXJhdGUgYmVj
YXN1ZSBpbiBVRlNISUMyLjEsIFNEQiBtb2RlDQo+ID4gc3BlY2lmaWNhdGlvbiBhbHJlYWR5IGhh
dmUgT0NTOiBBQk9SVEVEICgweDYpIGRlZmluZS4NCj4gPiBBbmQgaXQgaXMgdXNlZCBpbiBiZWxv
dyBVVFJMQ0xSIGRlc2NyaXB0aW9uOg0KPiA+ICd3aGljaCBtZWFucyBhIFRyYW5zZmVyIFJlcXVl
c3Qgd2FzICJhYm9ydGVkIicNCj4gPiBUaGVyZWZvcmUsIHRoZSBob3N0IGNvbnRyb2xsZXIgc2hv
dWxkIGZvbGxvdyB0aGUNCj4gPiBzcGVjaWZpY2F0aW9uIGFuZCBmaWxsIHRoZSBPQ1MgZmllbGQg
d2l0aCBPQ1M6IEFCT1JURUQuDQo+ID4gSWYgbm90IHNvLCBhdCB3aGF0IHBvaW50IGRvZXMgeW91
ciBob3N0IGNvbnRyb2xsZXIgdXNlIHRoZQ0KPiA+IE9DUzogQUJPUlRFRCBzdGF0dXM/DQo+IA0K
PiBIbW0gLi4uIEkgaGF2ZSBub3QgYmVlbiBhYmxlIHRvIGZpbmQgYW55IGV4cGxhbmF0aW9uIGlu
IHRoZSBVRlNIQ0kNCj4gMi4xDQo+IHNwZWNpZmljYXRpb24gdGhhdCBzYXlzIHdoZW4gdGhlIE9D
UyBzdGF0dXMgaXMgc2V0IHRvIGFib3J0ZWQuIERpZCBJDQo+IHBlcmhhcHMgb3Zlcmxvb2sgc29t
ZXRoaW5nPw0KPiANCj4gVGhpcyBpcyB3aGF0IEkgZm91bmQgaW4gdGhlIFVUUkxDTFIgZGVzY3Jp
cHRpb246ICJUaGUgaG9zdCBzb2Z0d2FyZSANCj4gc2hhbGwgdXNlIHRoaXMgZmllbGQgb25seSB3
aGVuIGEgVVRQIFRyYW5zZmVyIFJlcXVlc3QgaXMgZXhwZWN0ZWQgdG8NCj4gbm90IGJlIGNvbXBs
ZXRlZCwgZS5nLiwgd2hlbiB0aGUgaG9zdCBzb2Z0d2FyZSByZWNlaXZlcyBhIOKAnEZVTkNUSU9O
DQo+IENPTVBMRVRF4oCdIFRhc2sgTWFuYWdlbWVudCByZXNwb25zZSB3aGljaCBtZWFucyBhIFRy
YW5zZmVyIFJlcXVlc3Qgd2FzDQo+IGFib3J0ZWQuIiBUaGlzIGRvZXMgbm90IG1lYW4gdGhhdCB0
aGUgaG9zdCBjb250cm9sbGVyIGlzIGV4cGVjdGVkIHRvDQo+IHNldCB0aGUgT0NTIHN0YXR1cyB0
byAiQUJPUlRFRCIuIEkgd2lsbCBzZW5kIGFuIGVtYWlsIHRvIHRoZSBKQy02NA0KPiBtYWlsaW5n
IGxpc3QgdG8gcmVxdWVzdCBjbGFyaWZpY2F0aW9uLg0KPiANCg0KSGkgQmFydCwNCg0KDQpZZXMs
IHlvdSdyZSByaWdodCwganVzdCBhcyBJIG1lbnRpb25lZCBlYXJsaWVyLCBJIGFsc28gdGhpbmsN
CnRoZSBzcGVjIGRvZXMgbm90IGV4cGxpY2l0bHkgc3RhdGUgdGhhdCBVVFJMQyBzaG91bGQgaGF2
ZSANCmNvcnJlc3BvbmRpbmcgYmVoYXZpb3IgZm9yIE9DUy4gVGhpcyBtaWdodCBsZWFkIHRvIGlu
Y29uc2lzdGVuY2llcw0KaW4gaG93IGhvc3QgY29udHJvbGxlcnMgb3BlcmF0ZS4gDQoNCg0KPiA+
Pj4gKy8qDQo+ID4+PiArICogV2hlbiB0aGUgaG9zdCBzb2Z0d2FyZSByZWNlaXZlcyBhICJGVU5D
VElPTiBDT01QTEVURSIsIHNldA0KPiBmbGFnDQo+ID4+PiArICogdG8gcmVxdWV1ZSBjb21tYW5k
IGFmdGVyIHJlY2VpdmUgcmVzcG9uc2Ugd2l0aCBPQ1NfQUJPUlRFRA0KPiA+Pj4gKyAqIFNEQiBt
b2RlOiBVVFJMQ0xSIFRhc2sgTWFuYWdlbWVudCByZXNwb25zZSB3aGljaCBtZWFucyBhDQo+ID4+
IFRyYW5zZmVyDQo+ID4+PiArICogICAgICAgICAgIFJlcXVlc3Qgd2FzIGFib3J0ZWQuDQo+ID4+
PiArICogTUNRIG1vZGU6IEhvc3Qgd2lsbCBwb3N0IHRvIENRIHdpdGggT0NTX0FCT1JURUQgYWZ0
ZXIgU1ENCj4gPj4gY2xlYW51cA0KPiA+Pj4gKyAqIFRoaXMgZmxhZyBpcyBzZXQgYmVjYXVzZSB1
ZnNoY2RfYWJvcnRfYWxsIGZvcmNpYmx5IGFib3J0cyBhbGwNCj4gPj4+ICsgKiBjb21tYW5kcywg
YW5kIHRoZSBob3N0IHdpbGwgYXV0b21hdGljYWxseSBmaWxsIGluIHRoZSBPQ1MNCj4gZmllbGQN
Cj4gPj4+ICsgKiBvZiB0aGUgY29ycmVzcG9uZGluZyByZXNwb25zZSB3aXRoIE9DU19BQk9SVEVE
Lg0KPiA+Pj4gKyAqIFRoZXJlZm9yZSwgdXBvbiByZWNlaXZpbmcgdGhpcyByZXNwb25zZSwgaXQg
bmVlZHMgdG8gYmUNCj4gPj4gcmVxdWV1ZWQuDQo+ID4+PiArICovDQo+ID4+PiAraWYgKCFlcnIp
DQo+ID4+PiArbHJicC0+YWJvcnRfaW5pdGlhdGVkX2J5X2VyciA9IHRydWU7DQo+ID4+PiArDQo+
ID4+PiAgICBlcnIgPSB1ZnNoY2RfY2xlYXJfY21kKGhiYSwgdGFnKTsNCj4gPj4+ICAgIGlmIChl
cnIpDQo+ID4+PiAgICBkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IEZhaWxlZCBjbGVhcmluZyBjbWQg
YXQgdGFnICVkLCBlcnINCj4gJWRcbiIsDQo+ID4+DQo+ID4+IFRoZSBhYm92ZSBjaGFuZ2UgaXMg
bWlzcGxhY2VkLiB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSBjYW4gYmUNCj4gPj4gY2FsbGVk
DQo+ID4+IHdoZW4gdGhlIFNDU0kgY29yZSBkZWNpZGVzIHRvIGFib3J0IGEgY29tbWFuZCB3aGls
ZQ0KPiA+PiBhYm9ydF9pbml0aWF0ZWRfYnlfZXJyIG11c3Qgbm90IGJlIHNldCBpbiB0aGF0IGNh
c2UuIFBsZWFzZSBtb3ZlDQo+IHRoZQ0KPiA+PiBhYm92ZSBjb2RlIGJsb2NrIGludG8gdWZzaGNk
X2Fib3J0X29uZSgpLg0KPiA+IA0KPiA+IEJ1dCBtb3ZlIHRvIHVmc2hjZF9hYm9ydF9vbmUgbWF5
IGhhdmUgcmFjZSBjb25kaXRpb24sIGJlYWNhdXNlIHdlDQo+ID4gbmVlZCBzZXQgdGhpcyBmbGFn
IGJlZm9yZSB1ZnNoY2RfY2xlYXJfY21kIGhvc3QgY29udHJvbGxlciBmaWxsDQo+ID4gT0NTX0FC
T1JURUQgdG8gcmVzcG9uc2UuIEkgd2lsbCBhZGQgY2hlY2sgdWZzaGNkX2VoX2luX3Byb2dyZXNz
Lg0KPiANCj4gQ2FsbGluZyB1ZnNoY2RfY2xlYXJfY21kKCkgZG9lcyBub3QgYWZmZWN0IHRoZSBP
Q1Mgc3RhdHVzIGFzIGZhciBhcyBJDQo+IGtub3cuIERpZCBJIHBlcmhhcHMgb3Zlcmxvb2sgc29t
ZXRoaW5nPw0KPiANCg0KQmVjYXVzZSBhZnRlciB1ZnNoY2RfY2xlYXJfY21kLA0KDQppbiBNQ1Eg
bW9kZTogDQp1ZnNoY2RfbWNxX3NxX2NsZWFudXAsIGhvc3QgY29udHJvbGxlciB3aWxsIHBvc3Qg
Q1EgcmVzcG9uc2Ugd2l0aCBPQ1MNCkFCT1JURUQuDQoNCmluIFNEQiBtb2RlOiANCnVmc2hjZF91
dHJsX2NsZWFyIHNldCBVVFJMQywgTWVkaWF0ZWsgaG9zdCBjb250cm9sbGVyIA0KKG1heSBub3Qg
YWxsIGhvc3QgY29udHJvbGxlcikgd2lsbCBwb3N0IHJlc3BvbnNlIHdpdGggT0NTIEFCT1JURUQu
DQoNCkluIGJvdGggY2FzZXMsIHdlIGhhdmUgYW4gaW50ZXJydXB0IHNlbnQgdG8gdGhlIGhvc3Qs
IGFuZCB0aGVyZSANCm1heSBiZSBhIHJhY2UgY29uZGl0aW9uIGJlZm9yZSB3ZSBzZXQgdGhpcyBm
bGFnIGZvciByZXF1ZXVlLg0KU28gSSBuZWVkIHRvIHNldCB0aGlzIGZsYWcgYmVmb3JlIHVmc2hj
ZF9jbGVhcl9jbWQuDQoNCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo+IFRoYW5rcywNCj4gDQo+IEJh
cnQuDQo=
