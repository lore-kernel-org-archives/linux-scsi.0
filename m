Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B252BB13;
	Tue, 22 Apr 2025 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745326131; cv=fail; b=LoG7mDy4iq/zbgn8J+OjRQRDJSz3GgFgzH313HY2aHaG+YC5IJfPYy4tqTOF6GHH1m8gjI5GMVrSz9qvX7LJbncw8lgS9Zop0rA7BZejx7eFwK2xFRUYWIp5h2PKaifDxAGK1vDnG5aZfO4/Skl42d3iiXPwLDiCLpc9/nJOtho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745326131; c=relaxed/simple;
	bh=8yIX5Iby9jpXEuwQWmfEI2Uo8CLOkYKrjHDp04A8CGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iwYMxBRMWotQnY/iA6TeljxLCQph8VJj8P+2JQICHnq5M4Sd9j82eeaMjOM1ZcvwD0Z0ZDaQRMZakYw46vqFFPW4ssdV3f0o2rbjZEOyrE9Yuq7BwIW4Peav7Wh5kw5O5HbW81kSb35F5Djxis9iA8pfwQpm6ef6++g0Gtgg3A4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rFnV4R0J; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RHugBe32; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rFnV4R0J";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RHugBe32"
X-UUID: 1ec8d00a1f7811f09b6713c7f6bde12e-20250422
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8yIX5Iby9jpXEuwQWmfEI2Uo8CLOkYKrjHDp04A8CGY=;
	b=rFnV4R0J9S3pXiYiw6Dg0qkwD2Y8oFwe8VPKYhguHmlM3eghgdBs1GPK0K/rm1NxuhIkdQhi9cIpJyXxtUrm9SCwjt7B3P+1epCg7yBqMsbu1f5SsVQBMrckVbGeLuYEDNxBZHw0LfjvhXivop1cA1fEFrtVkiw9js5Y1gFYi08=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:9f57a0cf-a3de-473c-ba57-46d98d92e2ce,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:ab9d2a8c-7f93-450e-9c23-df27069efa03,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 1ec8d00a1f7811f09b6713c7f6bde12e-20250422
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1589945491; Tue, 22 Apr 2025 20:48:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Apr 2025 20:48:40 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Apr 2025 20:48:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EgBGZ25sGrj9lqQzQCEXX8OS8jMJxqpSXPX0suqMaQZrwZf3CRqMx9RY2KP5ty92PXW/mn7ihZIOdJ8G0B1w4TAwH/X3n/l0qAdSAZ/0+LR/0JiA3kRWM67/TGsfJOACeA75KeJgOQQFYQdP1m4WJBI15K7oa2jfzLwRDzO4rv8Wdtjjgvdmd7x8SJU+93+IyuWQf2m5UVWYso5EaP6Q75Uqve+4IvoDqm0QJIBm4fDMbEMc6cFT7Bwy+u77EntHsVNuYF8X0wvzRnKXrQbV7Cb36Ng+PApLps9ZqIybyM5Ac54zdWZU46YM9murNhZuQr2ofp1Fz5hESMDz00/Sdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yIX5Iby9jpXEuwQWmfEI2Uo8CLOkYKrjHDp04A8CGY=;
 b=taIDDEyXO8phiANtwKfKXbYTOEIeGbfSMvrq4AeBMf3OsFJ3MIIP//MkPSp8uffI/LR9lf+A5VeQ5wSED+Nbcd0uMGOlBltuFgkhKhVXr+e3CI50B13r8RmIFWRL8vmJ9mXFK2s72YAtKKDEKYsifEpBfFLcnFyyIrMB5ggntE1SMleuEypz85+33sFZ9SoRUCh7DBoAPYNtsgSUk1FHoZB6zxkAJl5UFU+I5WJ1791fI1pPHhrjZnTq+HZ09lJUq2RBu0GxbDR/Fg0W53zF9qw9X0E6v3xHx77QkInagno1HXgKDUWM2TEPyhJaACTjlJSP5dTEOLy7o2SxLSF/3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yIX5Iby9jpXEuwQWmfEI2Uo8CLOkYKrjHDp04A8CGY=;
 b=RHugBe32MimZ2t7SRu2QKGmZHo6uSB6d//rfLnNDx3I1N9VmudK4v2+f6x5LumjYgzxAsVHz4ysedySeMJKRxgOol9bpWIbKtl7LeKW5Zgb2DSkSPoxdn5Gctz09pMq948YIfdu1k9vC6aRbkHv5/mrzYDIIip0NYzZvLhps46w=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB7284.apcprd03.prod.outlook.com (2603:1096:400:21b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.32; Tue, 22 Apr
 2025 12:48:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 12:48:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "dh0421.hwang@samsung.com"
	<dh0421.hwang@samsung.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "sh043.lee@samsung.com" <sh043.lee@samsung.com>, "wkon.kim@samsung.com"
	<wkon.kim@samsung.com>, "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"grant.jung@samsung.com" <grant.jung@samsung.com>, "sh8267.baek@samsung.com"
	<sh8267.baek@samsung.com>, "jt77.jang@samsung.com" <jt77.jang@samsung.com>,
	"jangsub.yi@samsung.com" <jangsub.yi@samsung.com>, "junwoo80.lee@samsung.com"
	<junwoo80.lee@samsung.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add a trace function calling when
 uic command error occurs
Thread-Topic: [PATCH 2/2] scsi: ufs: core: Add a trace function calling when
 uic command error occurs
Thread-Index: AQHbr0FUhDqRlyDNVE6efCLOe9txGbOvqziA
Date: Tue, 22 Apr 2025 12:48:38 +0000
Message-ID: <039d433e9931e4999e4011cebc2844ffacd2ec0c.camel@mediatek.com>
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
	 <CGME20250417023419epcas1p343060855c4470f8056116a207a584956@epcas1p3.samsung.com>
	 <20250417023405.6954-3-dh0421.hwang@samsung.com>
In-Reply-To: <20250417023405.6954-3-dh0421.hwang@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB7284:EE_
x-ms-office365-filtering-correlation-id: 44fa3bef-faa5-4419-e56d-08dd819c00a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Yy9uVFJLeHRSQVR5OTJZaW9nYVZlb0RuNFZINER3M0Y2dWNDSDRGNStDenhX?=
 =?utf-8?B?NDFjNWhtZUlIQUhhTkdlMUJCM1pOaEE4Z2hNZXM1RUdpMTdmbjJycDJSdUpw?=
 =?utf-8?B?NWdnbnlVZys3WGx1MW1wbjNhbWllWjAzejVXTW1tWGRyMnI1d0VjVzB5ZGFS?=
 =?utf-8?B?QUZmeHR3UHhrejhJSUJXQlJQYmV4S3U1SkRoL3E0TnFHdUtvY013aTBMUFZH?=
 =?utf-8?B?dW5tSTdCSVlkWFpZaHc2YUZ3THBwTWtjZW5Ea21IUWxKaTVyR0NFM3BNc3Zj?=
 =?utf-8?B?N0ZLcUFWSVNiV3pqNjIwcngvek92RzhVRmRxVUNZcWpYZlQ5dFZTaGlSbXdK?=
 =?utf-8?B?MjRta3JNTVR0YUxqU3ltd2liczBRYk5SS2xCb1B0S3NtdlQyRnhNcVNLUHdl?=
 =?utf-8?B?NXQwK0M1Z21WWjlYZjlOMklCa1cxcTJqKzNRcGs2SzhvZ1ArZlgzRWIyRmZE?=
 =?utf-8?B?MEExUlArSXpFTXlBNU5UTGVvOWoyVWJTVVRXZHJTYWVGMTNEY092N1c3UE03?=
 =?utf-8?B?UDJjV0R6VW1DLzhPSzhwdVdVSTFqMVJSQ2FXdzZGM3lnaWVzTHFMNDVyT3d5?=
 =?utf-8?B?ZzBWSWNNS0t0YmR4Tnp0Y1V5WVoyd0V0R29BZytLREFzVzRNOTB6TnRTcWRr?=
 =?utf-8?B?UXgvV1gxbGFpMjk3M1kxa3M3OFl6M1pRSU05VFowNE44b3E3SGtlYVFvL2JF?=
 =?utf-8?B?MyttdDUrVGRDVWFOOVBNQWJCTkIwcEZJa2FlNW42bEp4VTNzekFCdW4vV3pC?=
 =?utf-8?B?S2RnMWlMcXF0TllrblA2Ny9jbExoVjdncWVqMlhnTVo0YjFjK2xWS0NwZzdt?=
 =?utf-8?B?RG51cXVzZ29tK040YVJsTjVDWHM4enZCN0hLRm5wV2FxT01sdFFaWW9ndkxW?=
 =?utf-8?B?ZGl5UHlLTnNFT01QZ3FYQTFhaGJRVEM5S28rYVlVY2lYOGwzeXpFL1hTWWli?=
 =?utf-8?B?b0ZuZmQvNmJ0RGlIVmJvNmxFSjFmU2wxV1RvWHlTWUpWc0dGQisvN1RFdkU4?=
 =?utf-8?B?N0dSM2NSL2ZJN2dvd1FOVFJFRW5OWGk2OWc0TVZWN3JqNkNTckYxWWd0OFVB?=
 =?utf-8?B?cjRHUEp3bVNMdVptT2h2ZjFEb2s1SjNpUzJHakN6Nzd1T0ZZNlhqbmpWczVz?=
 =?utf-8?B?b0h2Tkh1NUdpZFQrM1RYam15dzNjb3ZpY3RMVkNsT0VEWFIwb0dUcTg0WjNq?=
 =?utf-8?B?YW5JTXZlcFlRVUs2eGx4TTIwNThQN1Y5OWUrUWNyakY1T3AvM1E5eFh1d1lm?=
 =?utf-8?B?WlZSNm1VSW5Sd1ZXU0dHYmJUUXNoTnhUYmEwVlgwQTl5OFV0SG1ReTNJbCtj?=
 =?utf-8?B?M25RN05HWjdXRUxjbFlwUkFCZkg0Lzc4WlBLbFFOWnFtRDZsSXF4L2ZFNmY1?=
 =?utf-8?B?c1RNSkpDYjBMZW9oOS9hUE1rcDNNWkducUdBdTlmWEJTd3NhYmlhMitBWklH?=
 =?utf-8?B?R2dIOWlMWHRNUnZsdElCK1lZdjdrSGJMcUJzSmcvVFZxMHpzaWwwaXBCY1Fh?=
 =?utf-8?B?SHNPS2hObmdDYU5ackFWT3dEazVtcmhvaHhiM1YvSEl3VXhhWU1ZeG1UV0hK?=
 =?utf-8?B?TkhYYzh2UERJNk5KOE5XU3E2Y1JzRnppZE1NbTVrYW5DNmtzWWkwNk5RQ1Ux?=
 =?utf-8?B?UUhYclp1SXozVXBXdFdyZDFYS3Z0OVN3c0tsVUhobmNaOU5yTDIxWE9TQ3Fv?=
 =?utf-8?B?cmVWdG9uQTVCQ3FXL2ttaFB2VkQ5Q1N0NUNzSXJBSm9rM3BNS0hici91Tnlx?=
 =?utf-8?B?bXhOWmRWSnI4Wk5LQm5ud0pEeG5nQ3VuQjBlcHkyZUNOcXg0TzY2NHdvYnFI?=
 =?utf-8?B?UzBEL1FudHliUTRCcDlPZzJXZkc4NmFUNVRPaENCVWVPemdmSUJCakhKNi9C?=
 =?utf-8?B?QVc4ZE9DNFk2TElFREgyK3QwdUYxZENFcHMwSTZCTmV6am05OWR2SllUc2t5?=
 =?utf-8?B?MC81R3o1dzgxRU5DcDBOd29iK2tzZlJTRlgxV3BEaEQ2QitqRUl5QjNwTWRY?=
 =?utf-8?Q?zgJ5vyxvQ+1ag8BgWX6Mo3WKpgKqOo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TE5kNXJZMWdVRkFYcWtZTGlzWjRNTUgxYmxiSEVWaTA4RXRXRUJ3alJDelQ3?=
 =?utf-8?B?cWw2M3N0Y2Z0U3NKOE4rcFZkbEhSUWhYNXFvRmxlL01zaDJCVVJadTBrZlFX?=
 =?utf-8?B?TUNMQ0d5RkM3S0Izc2p0cVVlME4xZXBwRmxlNm05MFJLKzRUQzhUZDBQZFlS?=
 =?utf-8?B?WTJLcktLVFlLR0YzZUhCRytSVkZsLzBNSEc4dmJGQmVZRWo2MVV0eG9CM20v?=
 =?utf-8?B?c2lPa0hsVm96QjJkcjVXN1c3eDBBUmVVZWwzc29HSnc1a2t1MUoyamw1YTZk?=
 =?utf-8?B?cVk3cW11L3NpZ2Qxd2ZnckR6L1ZFZm5KblRiTzlMcnRhUmVXWEZwRTBnNk5S?=
 =?utf-8?B?bzRmdGs3ajlSU0JUZFZpNGQ2OTJUT0Z6TXFlelVKd3ZwaFJDaHM4cmJINThU?=
 =?utf-8?B?MXNkcHltQjI5S1BUdDdSRFFud09KalhKSVFhVCtuRFkrWlgzMWsvOE16WFh1?=
 =?utf-8?B?ZjFyUmNhcDkzaVV4bkl1MFFrcko4am90VkFoZEZWanlkREZyTHZzSitySEQy?=
 =?utf-8?B?U09FNWI4TDk2ZC9JVEFDMFNmclZMTWhkbDlEVThJdUprdlFad3RzQ3NYQVpi?=
 =?utf-8?B?VEVrSEdJalUwTmNTTWhHSm9wTWlTUjhPYk5jQ3haOHJ4akEybS9zNSt3dm5T?=
 =?utf-8?B?aEkwc2p2T2VQSUoxVkpqaDZwSmxQMEltTFp4dWtDcjh1TlI5U2hxd2JQdDVz?=
 =?utf-8?B?dVJMV2R2YlM4UVZ2d0Vzck5ydUdyODdxRTNmTGFkUzNVTE8yTEcwOE1Qeld4?=
 =?utf-8?B?OFdnUlNKTmp1N1QxY2NmblVjWGFFa2dqS0w1dXBCWTRETjlDVzI4ZFlxb0du?=
 =?utf-8?B?UFRVdHdtcUZqK1VvTFRmTll3QjVDT1VLOEFGTzJWUTBoKzg5OVp5Z1ptL3NJ?=
 =?utf-8?B?Z3RUNW5TcWxiU21NTHJhOTlmVFRicVZKZFc3QUNvZTc4UWEzR1RWUkpNeGRm?=
 =?utf-8?B?b3VlWTFSTTltU2RqUFgzM1RXRVRuZ2RKYk10LzB5WHVFbXphNkptU2ZTK1Ax?=
 =?utf-8?B?WVVmTVhCYWhCSXZCeGVHS2c1SFNpeWdPVHhOMW0xeUdvQityWWFaNW1LMkI5?=
 =?utf-8?B?MmRBS2FEQmMrVjJaZjJYNHlPWkUzbDdoQW0wamlhVjlkZ1RSNDZyVjRTWnJT?=
 =?utf-8?B?eUh4Y1J0bFQyRXAxMzUrZ1NJMzZkUUdCQVBoZlNGSG1pejlhNllSMjFLcGVt?=
 =?utf-8?B?VzBJcDVxalN4TFRHcHBNVFJ5a3ArWURTM2pYVkp5TExseklNMnRadzZIcmZN?=
 =?utf-8?B?ZE9oVENHQ3AxUU54WkNCbXBuUUdLbCtRNG1zWlRSOURPOWdKOVlEaDlvTmo0?=
 =?utf-8?B?eGZGalcvaUJYQnpsbjYrVE9jT1NWdDIxaDVjUVVwMm9rRTlHMjc0YVpldTJW?=
 =?utf-8?B?cEpJVS83bmJQbUEzTVV6TGQ3NThvRWVkSmZqK0pEUWloRkYxUWJLazVzUXpy?=
 =?utf-8?B?NWVjdEQ3YXVRbHh0Y054Y3hxMVQ0U05mbXJiaFNTOHk2bVhyaGdsdVJLOGJl?=
 =?utf-8?B?QVhtYkpIZTVvV0F3eFdCd0RXbkMvVGk4OWlNd2MvR3pOb2JpbkJJTThPd0pz?=
 =?utf-8?B?TmI2NmlCcUFpM3NqeXgwaGRXZkpZWTJGM3NyYThncWozWlVDUVJ5TlliNzAw?=
 =?utf-8?B?YmdBdDk1d0dVSllDRmJrVkhaaWZWSGZYcmdyV0hkMnpHdEthQlp3ZzRLZHlG?=
 =?utf-8?B?a0VnSzFHRnBQM0xvSEovUHRUREo0RndKcHZRdjRmZEpRWkdWOUlaWFI4UzlN?=
 =?utf-8?B?Vmwzcko1VWIwWXJUaHBHRVNiNVEyOFNVMzF4Q241dVgweEZXMUJaMG4vc2FF?=
 =?utf-8?B?KzhNVnB0djlVdnRERXRZOTVaam9GTnkwemF3WWNESGhyWnExQnV2c1JjNGhT?=
 =?utf-8?B?WlZLU2NHaExJbUlLV2RKMHFXZGFrREoyL1BLUytwZ0xENFFUUU8wMlphVDRD?=
 =?utf-8?B?dW11OTF5L2E0TUdRV2pXQml3NXJiZWViV1BFS2U4Z2wrZ2tNd2t4bzNyeGF2?=
 =?utf-8?B?cXgwU1hRNjIrcnJwbE1idUtXWGJNbGRpbnlJanNHMTZJZ2NQYnk0SVU1aVBO?=
 =?utf-8?B?cG1wTlJrcE1lVVdWK0s3Vi9KeVgxdC81ZzRyUy9iNzZvNFJ5T0Z3NUQ4RWdn?=
 =?utf-8?B?cUgrb1hZaTdBWW41MFR2R25qb1VwWG1vbFBTMXkwc3ZZaFFJQ1RTNHlBYWg3?=
 =?utf-8?B?c3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13B4572408BE504C8E281D8412C52D19@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fa3bef-faa5-4419-e56d-08dd819c00a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 12:48:38.2055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9qFTcVO9rrhlaI+3nc7KntXRTnbME8tm19gICks4x8utJW7ALDqO5m2gU0uM9vcWsHQhkiDZQelebdE1tsI+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB7284

T24gVGh1LCAyMDI1LTA0LTE3IGF0IDExOjM0ICswOTAwLCBEb29IeXVuIEh3YW5nIHdyb3RlOgo+
IAo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVudGlsCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0aGUgY29u
dGVudC4KPiAKPiAKPiBXaGVuIGEgdWljIGNvbW1hbmQgZXJyb3Igb2NjdXJzLCB0aGVyZSBpcyBu
byB0cmFjZSBmdW5jdGlvbiBjYWxsaW5nLgo+IFRoZXJlZm9yZSwgdHJhY2UgZnVuY3Rpb24gY2Fs
bHMgYXJlIGFkZGVkIHdoZW4gYSB1aWMgY29tbWFuZCBlcnJvcgo+IGhhcHBlbnMuCj4gCj4gU2ln
bmVkLW9mZi1ieTogRG9vSHl1biBId2FuZyA8ZGgwNDIxLmh3YW5nQHNhbXN1bmcuY29tPgo+IC0t
LQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDUgKysrKysKPiDCoDEgZmlsZSBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMKPiBpbmRleCBhYjk4YWNkOTgyYjUu
LmJhYWMxYWU5NGVmYyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jCj4g
KysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+IEBAIC0yNTM0LDYgKzI1MzQsOSBAQCB1
ZnNoY2Rfd2FpdF9mb3JfdWljX2NtZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLAo+IHN0cnVjdCB1aWNf
Y29tbWFuZCAqdWljX2NtZCkKPiDCoMKgwqDCoMKgwqDCoCBoYmEtPmFjdGl2ZV91aWNfY21kID0g
TlVMTDsKPiDCoMKgwqDCoMKgwqDCoCBzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+
aG9zdF9sb2NrLCBmbGFncyk7Cj4gCj4gK8KgwqDCoMKgwqDCoCBpZiAocmV0KQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVmc2hjZF9hZGRfdWljX2NvbW1hbmRfdHJhY2UoaGJhLCB1
aWNfY21kLAo+IFVGU19DTURfRVJSKTsKPiArCj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsK
PiDCoH0KPiAKPiBAQCAtNDMwNiw2ICs0MzA5LDggQEAgc3RhdGljIGludCB1ZnNoY2RfdWljX3B3
cl9jdHJsKHN0cnVjdCB1ZnNfaGJhCj4gKmhiYSwgc3RydWN0IHVpY19jb21tYW5kICpjbWQpCj4g
wqDCoMKgwqDCoMKgwqAgfQo+IMKgb3V0Ogo+IMKgwqDCoMKgwqDCoMKgIGlmIChyZXQpIHsKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfYWRkX3VpY19jb21tYW5kX3RyYWNl
KGhiYSwgaGJhLQo+ID5hY3RpdmVfdWljX2NtZCwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgVUZTX0NNRF9FUlIpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNo
Y2RfcHJpbnRfaG9zdF9zdGF0ZShoYmEpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB1ZnNoY2RfcHJpbnRfcHdyX2luZm8oaGJhKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdWZzaGNkX3ByaW50X2V2dF9oaXN0KGhiYSk7Cj4gLS0KPiAyLjQ4LjEKPiAKCgpIaSBE
b29IeXVuLAoKSXMgaXQgcG9zc2libGUgdG8gcmVjZWl2ZSBVRlNfQ01EX0NPTVAgYW5kIFVGU19D
TURfRVJSIGF0IHRoZSBzYW1lCnRpbWU/IApXb3VsZG4ndCBpdCBiZSBhIGJpdCBzdHJhbmdlIGZv
ciBhIGNvbW1hbmQgdG8gcmVjZWl2ZSB0d28gY29tcGxldGlvbnM/IApBZGRpdGlvbmFsbHksIHNo
b3VsZCB3ZSBhbHNvIGFkZCB0cmFjaW5nIGZvciBnZW5lcmFsIFNDU0kgY29tbWFuZHMgCnRoYXQg
cmVjZWl2ZSBlcnJvcnM/CgpUaGFua3MKUGV0ZXIKCgoK
