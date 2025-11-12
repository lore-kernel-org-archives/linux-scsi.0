Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1AE2FD7AE;
	Wed, 12 Nov 2025 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762940578; cv=fail; b=f1ffNY0ZGUw8xjNCGO4/QBOY5zKIExNeMITWz9BJU1tSyBGM1h62zi1VIB2Oh0KPmjEFX9iHPLHH6oHgXnDzbKvw98y7iLgs1w4MrXUOdvalUbGJi32uOQ4xHYrpdyfH9V5LA8deoP4yLhwndmBzM929Lj3tdRACSaARcVl1Mb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762940578; c=relaxed/simple;
	bh=32hcom14GXMXtKfZydl3d1Trq0jTybF7n8r0OHxM+6c=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LwwItbtPERpyM3dqyHg/yQaST9KDVWnpbUVW9iRYWKeGwPzvkdLmrwlhmWX3SCpUX3ATOCBtx/OHc9BKOpR0f/mdRfxSqBudekynDy/xm71Kpr4gosVmWis3bA6sDERX5NDJJQNZL/r7SJciz4kdglk88AtdjRWG/TH/L7VNxa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GqsD5ZJ0; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=hbKnKHVz; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GqsD5ZJ0";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="hbKnKHVz"
X-UUID: f3c8852ebfab11f0b33aeb1e7f16c2b6-20251112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=32hcom14GXMXtKfZydl3d1Trq0jTybF7n8r0OHxM+6c=;
	b=GqsD5ZJ0rfxg3ZYMrgHlU9WRdcm7btb9EbBmhcO7+kb+OGFfDFEPwWMGTUtlWBrKYRbf/PUp0j0GAL7E4rVQ6tG3qkxTPavEV+q1EAZB/MBvd5N0VMXQMFrWG+Uh71S4kGcAiTj+YqZcezDmZVfkaeQP0tPRIGWoUR2CXwbLJq8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:31fd5977-d0f5-4c87-9ab7-5d930f38b52b,IP:0,UR
	L:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:2
X-CID-META: VersionHash:a9d874c,CLOUDID:06ceb6ba-0c02-41a0-92a3-94dc7dc7eeca,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:4|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f3c8852ebfab11f0b33aeb1e7f16c2b6-20251112
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1873977415; Wed, 12 Nov 2025 17:42:49 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 12 Nov 2025 17:42:48 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 12 Nov 2025 17:42:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Id0Vk2RYKm4AruGBbih/J79lLYQHI4YW+Cu1REDpLWIHvCFHPfdShQnoKZfoVol/XrQHJx2HwkzGjP/MHvGyz2Qv3Zk3vCjT2rOvUzpL+LTQDrGgCnv85I3dSKfQgslw7QFWpyAezwiW0cl3AqmA8Co8Z4povnPD+vk9IC1y0/5d90oY4x/MBCZZu/aM+LR0K2BsS4aDyghhJPK46YLvsjR0CyUJNYLqVvnGRiNjTl6hy6KsfMSgbXeF4K+uGUDwWamCPejJbtQ5p3BeN+W7eVVDYt4h0IRMmF8VD7UgSEtHRWpZbjeMdft+uiULphp0BzKLZuKzvvjCBXaOEGd6CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32hcom14GXMXtKfZydl3d1Trq0jTybF7n8r0OHxM+6c=;
 b=JGHSFxWCGgXbbvfkqbhM4n4ElJCII0TVY0/AiIOKXLNV9ILgTMhIP/uWE6cIDqeF3uy9iftX3cG0pgqbZlGD6P+uwMDF6a12F+SdCBEAj0GtVHgTFMM06BXWprARxA2FUnOiLV0A5l62zcrLBzE3AnlybPFg2GoOf74cubuAoHCqRQGigeGhQKXIX6D2jJ9m65aViZWAZMSpRXscXuSc8rg1sKUFhprnm2gs3ghDRYP/Fr4qRxSeq04nNEWykwICXo++O2DVRWGizchCac0lqLI/jyXuOttNeeh56YT3Uo4CLL4k03zDjdUrJNU53mbv3fhoGIazZzkc3p3Z+aT+3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32hcom14GXMXtKfZydl3d1Trq0jTybF7n8r0OHxM+6c=;
 b=hbKnKHVzvKKpT/j8Pj2n5cIZwKf0rov2sNgbhvbu+dhoj5GlhXQ2O7pFu82zZKLVtzsif26lYovTf9OFVKDaABBhupDG+xDXDeaBD3hvPM+hzZHOgdb4HQEe2el2IWfgcJ/7KCDg/hrJwdgcneE4Hy75sbJyRC/giT82vWeq0o4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7038.apcprd03.prod.outlook.com (2603:1096:820:c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 09:42:46 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 09:42:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "sh043.lee@samsung.com"
	<sh043.lee@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"storage.sec@samsung.com" <storage.sec@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Topic: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAIAAfuaAgACtbwCAAGJUgIAADr6A
Date: Wed, 12 Nov 2025 09:42:45 +0000
Message-ID: <d269635b6c566029d757dff59f4b0cf250b33fb5.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
	 <000001dc53b1$540988a0$fc1c99e0$@samsung.com>
In-Reply-To: <000001dc53b1$540988a0$fc1c99e0$@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7038:EE_
x-ms-office365-filtering-correlation-id: 2a838568-20e7-4d89-a3ae-08de21cfd587
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?K2xNS3lvWWQ2OUVQK0p1QVI1TGhCVnZza3dXb2ovMkkwNWNvTStDcUNLbHNj?=
 =?utf-8?B?bE1YRDN3ZkdQM3RnNll3eFZMdzhmay84TnZpbmcvOXNyK1c5T0dUUVIrMlNN?=
 =?utf-8?B?KzJjYWZSWmhKZHFKRlVJTHdRUk5OdVRCdWxDNExzcXpxaTFlbGJkSUhGczhT?=
 =?utf-8?B?eUZzejVtaWZ5UWhQWWE4aG5IQkRwTVBxTWgvcHdzeVlqODZFNGh6OTlGbTRD?=
 =?utf-8?B?UnJQZlg0TWFHV3dnc3dFWlNtREJ6eHB3M2JrK1d5by81d21QSHU0TmI1OEVY?=
 =?utf-8?B?MDhxNzVJN0hJa2w1K0cvUjJUYkl1OHVQdERKdEI2aWVNeHl1eEU4YXpHZjZr?=
 =?utf-8?B?K0UvbTdNenBqa0V6Z1BwVXMvNzBaVjJoM0NoUi9uQVQvd1F5K3J0K0RGQ0dN?=
 =?utf-8?B?RXVaLzBOOUowenBVZUtwVkNmQ1Riek8wUzU0ZXQ3M2Z3VndoWkMrbnhWQUUy?=
 =?utf-8?B?TGQ3Z1djalRGZHc4L2N3TUVoQWhFdGEwcUNpR0xmTUJTT0ZQUGFMU3NuQlRT?=
 =?utf-8?B?dGE1M0d1N3VYaUhZU0FFbS9mcXF4VmhoSkVlM2Y3cGVLZE1CbDNweUZqMC9p?=
 =?utf-8?B?SjNwRThFM21Sd0tiR21VZFBySXMxR2d3RitPVXREOWU2Sm0weEE4Y01pdGNK?=
 =?utf-8?B?U205eUhVNkhBKzRtT0dPMVl2OUpOYUNOb1JSbkRDYkdSVnRhaTlHdEl3WkRu?=
 =?utf-8?B?K2UxaXdYSmQ2SDdjY1dKZEN0dnJaS0llL2R6YS9ObkdkN2w2aFFveTJWOXRQ?=
 =?utf-8?B?RjM1UXBVTUJMK3Nsdmx4UXNSTytHNytoRU9CblZid1FxTmFrT1cvUEdRMGdo?=
 =?utf-8?B?SzNjeERoWG54R014bFN5WDlsVjk4NGFuaFdmUDF0MkxkMm1PVE1YVW83Zk9j?=
 =?utf-8?B?Vk1ERmFIMFhGRlYwcmpLc21mNlc3MTUwZHBQdjhkS1h4L0tTU1I4MTNvRFhw?=
 =?utf-8?B?L0tZcVpOY25LT2xSK3NORXdhblBZVW0xNEFJajBoWXl6bTRTbVpCSmZrWWxo?=
 =?utf-8?B?NUpZYUVRQTRsNVNrSU1WRDR4SEYxTnVWbHJKVlM1K1dYb2JjbnBzaGIxTy9p?=
 =?utf-8?B?OGFodDFzL1FpaTAwd1E4VWErUWFhVVlXM0xhaHRRVmhTd25IV01PdHhHV2tU?=
 =?utf-8?B?NkpOMWRpZWxWdi9YdzNHMWRiWWhCN2tqSng1MGd5RXhnckkvcFJYaS9kSktw?=
 =?utf-8?B?N3hiWU96ai9HNTRvdVVTRTRSeUFQQWNDS0lhUVRKc3lHMWVzRFA2cHRLaHFL?=
 =?utf-8?B?YkhET1ZJNmtFMHNqRDk4ZUtUcUZTUUZSV0xydlM3bnY4K20xSWFnTjZRa05L?=
 =?utf-8?B?bEZhVERnVHN6Z0NjTVJMQVpFdmNZZGhVSk1WTDBhbXNSd1ZLcER1eHlMc2J0?=
 =?utf-8?B?VUZvWXNLanQ2UmZlUU12UmZUL1FpeWZiZWl5aWw0MlpNcDVlVkQvZE5oYVhG?=
 =?utf-8?B?VUF4L2RFeXdTQjNEYlY1YWplTXBQR1BTRHpVMXByQkswOThQWTlHNUtBakJm?=
 =?utf-8?B?M1NrNDhNL2dUY3pDVnpwU0dRMlBOeXluU1luakVRU2U2YmJ2TDQvM3orRkRE?=
 =?utf-8?B?NU1zcjd0WldhdGkyYzh1bWhuZXp0SUJ3eEJhd3hjdE1NOGlYSmV3NFphQ0cw?=
 =?utf-8?B?MmdIeXBDMFg2R0FDamlyaTloaW1nOHdOc2ZxemJ2d2hydnNUWFY1Zk5Jdy9Y?=
 =?utf-8?B?NGxBZlNxUksxbGtLNlNISHdsaGdya3dVNjJKaFFZbzFFYWtxSEtkOC9GQTYx?=
 =?utf-8?B?SHJPYXRvejV5WHlrVzluMk1STUhSUHNFOGZHMHQyUHI2TDdnZ0VtaVRoNFRl?=
 =?utf-8?B?UkNmY0ZvRFQxNTVjSG9ZRUtqRDVoaHFHZ3BLN1FWUUp5TE9ZTnBLU0FOenk5?=
 =?utf-8?B?MVNZbDFVKzVqbFU3WUN0MExHVFVpMVNjY1RiR1NvWGJGNm9oZlNOajhacUhT?=
 =?utf-8?B?OWg4OWd1c05tWUMrbFBiV2FCZDZZMXhoT2s1aDFjdUlpdzVBT09lU3JyL1Bn?=
 =?utf-8?B?Kzd2dGh1RWRtdGxUcko4N2dnL0ZyN0VIc0x3czJXdy8vVTY2WVNoWUFSc0Ni?=
 =?utf-8?B?R0EzQ2Z5V1hRUDZaMjZKcFdhalEraHBVMFdJZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGIyTEpZWUF0ek42VUdVU0xaSCs5MHBnckJCejQra3M1Vkp1dVdwU2c3UXBX?=
 =?utf-8?B?aG5QdkJuNm15QzZNWGJ1ekEwQlozbGhEZHZHbFo1WThkVkt6R3owVVlpczRx?=
 =?utf-8?B?TXUwQUZvK3FKUE1qYlZoU0xKbUZpczZadXFGU29GU1g0U0phVEZOcEhXRjRy?=
 =?utf-8?B?OU5oK2c5Zlo2aFAvNTBKekFhcUxsYmxmNTkxNzE2bkV5TUU4WVk0cXU1anVy?=
 =?utf-8?B?dlVJbjlmS3NuZU9yTi9RbHpBbjJyZzA5Z2RYZUN1SmE3NXlsbERUd0NFTXZn?=
 =?utf-8?B?V0tQT1FJeTdacXdReWpGa1FYem5hQmd5VGgxVm9adTBVUEJqK3YwSjNxWElT?=
 =?utf-8?B?RW8rcm92c1NGT3lyajhGclBoU1VOTTNERjFEa3dPNzhPaHAwWndDckF2MjIx?=
 =?utf-8?B?OWYrVkRKdmZaNFpRek1XakZpeGNKYjY2OXl2RHR1c2oxQUUzOW5HK1hKUW9Y?=
 =?utf-8?B?dHMwcHhkYlRFaTJ4RzdvTVlDWHljS1RnRjQ2b1ZtUmJXME1hNFRMTWZpcFFn?=
 =?utf-8?B?S0duaVdjcHllQTR3R001VWxITW1ZR2VFYi9WSm9pSTVVd0hoNUE3NGtRd3hr?=
 =?utf-8?B?UTVoZ1d5c3g0NE1uZjVWRm82bG1adE5yenpaTGt1QzZYWnY3Q3NKZHlvOW82?=
 =?utf-8?B?cHVDMnNYZUZyNC9nYlhuSmIrbDR6aHNTVjY5Z2ZGOHgwaHo1V1hnOUhYeU03?=
 =?utf-8?B?dURranc4M3VaSzd5SkVMNnpVQU8yRHdOdzhXVlo1bitDQ3NVOGJuRUdENlRo?=
 =?utf-8?B?KzFHa1plemZucGROTnFaWlBnbkVFZW9hOUNDRzJLS1lSRXZ1Qml4QzNjMWNp?=
 =?utf-8?B?YkZMUWVhT0k2MnQwcVVXQk1RVDAyRnZSV291UnhIZkdnTiszbnhuZXRZYklv?=
 =?utf-8?B?M1lFbkl6c0R6bHZ1ZjZkQVQ1UkgzeEQ0bnk4MEhwdVpyTytXWEI4TmlzdVQ1?=
 =?utf-8?B?Q2QyQitXOGRtZG84eDNUNklsWGxScWQyQzlvakpnRnhteXJEcm5rN2RjeG5i?=
 =?utf-8?B?Q0s5UnhHKzRyenJoL2ZZMnJpYlN2ZUUrMzR2eStDZXZzYlJMU2REdEFpT0Fk?=
 =?utf-8?B?Q2R5Z3drOTd5dHlGdVVrbGNLcithWDRUNUNxaWdjcUhJd1MrbWtJaDhrVUp3?=
 =?utf-8?B?QzIyQWhwbllBZ0IxclkwTUtDOTdpNzE0Y3h4V2dzbzRtOWE1dTh0R3FoeDVz?=
 =?utf-8?B?WjVLRFUyczliUWNyeXZDZVFEYStxWW1lK2pWcHM5NlBOeHVLNHRxVTdNcVFC?=
 =?utf-8?B?WmwwcXpUMzdoQVp5ZDZwbTJrY2xENGI1ZngvN0F5Ty9lSlI1aCtuNkk2NG9x?=
 =?utf-8?B?M1Y4UlNHM2NQWGFQaHBKZ216dml3Z3N1a1JGdU4zV0tnVWUvemFTQTRPUDZ1?=
 =?utf-8?B?SSthc2szNWM5WE0vM3M3OFpHUGdMVTd4Z3RlOTJ0aGFVV2N1d2JhWGIxK0tR?=
 =?utf-8?B?OVorRW84cjYxbWpFL0Y4SzRpMUVMVllQZ2NYMFRRaVQyamcyZkl1MnorT3l2?=
 =?utf-8?B?M0xiV09HWUF5Wk5JNVVDZEs0VUpEWkFsakpvMmdKa0tWWWtTYVgzR09ZcXRT?=
 =?utf-8?B?dXNjNm5pZWh5MHZqR3Jjdm9YMURhQ3NvczV6ck9CdlhDbzhYcVlESWJlaHIv?=
 =?utf-8?B?YnI2WXZoUFRuZGhhb3JlYUk5enJqSUt1SElPY0xybDhLZnpYdVFqbVZyUkUv?=
 =?utf-8?B?K2x3dHFIQUNEcVVaQWhacFZjVllyTjdOMDBYYzFDM2FQQnFvWStlL3l3SVJZ?=
 =?utf-8?B?NmFwYzNkcko1c016SHhwK1U3NWhsMHZoMVBrTjcvZ3oyWG9YWDg5QkpuVE44?=
 =?utf-8?B?M2hVZFFGNy8rQnluMTNhZjRnNkUwaHlsT20yMThhcExEU0kvZ2RHcEhUQ2Jh?=
 =?utf-8?B?d3JVaUlFQkozVmpuWVlGZTBPRXg3OFRTNTNjNTdNRUx2ckJMUnU2NDBsMXVS?=
 =?utf-8?B?RmZkYlo4blIwK3VJckZlOThrdVQ0Nzh0UGFzWUcrbmZySlEzbDRDV3paZHE5?=
 =?utf-8?B?TXgyVEgyK1N0Ym90elBpZUFJU1lBd3FjN0tVY1B0eStRY1F2L2VaL0dJNGFE?=
 =?utf-8?B?QWdNVExBSVhJYkF3WDY1c3Y0ZUxNZG1lWGZZT25JeHN5dWN6NmVBU1JJTWxx?=
 =?utf-8?B?WnpqV2Qyanc4dlB1WTY4LzJmcUY1NjRXS2pocUUwMjAxTTJlSEFLQVlVc1hQ?=
 =?utf-8?B?RHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E4C284339DAE5429BEE3980D56F93DF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a838568-20e7-4d89-a3ae-08de21cfd587
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 09:42:45.7032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jBmLDx6mBqkusTFCY0krrQB3xv2k/pyyEtADS0CBtZ41Ki/syXX6XV9onjTx4qfuMaQIbfF4qbmYsBz8KeDExw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7038

T24gV2VkLCAyMDI1LTExLTEyIGF0IDE3OjQ5ICswOTAwLCBTZXVuZ2h1aSBMZWUgd3JvdGU6DQo+
IA0KPiBIaSBQZXRlciwNCj4gDQo+IEN1cnJlbnRseSwgdGhlIG1vZGlmaWNhdGlvbiBpcyBhYm91
dCBjaGFuZ2luZyBpdCBpbiB0aGUgc2FtZSB3YXkgYXMNCj4gbm9wX291dF90aW1lb3V0Lg0KPiBU
aGUgdG1fY21kX3RpbWVvdXQgdmFsdWUgaXMgbm90IHJlYWQgZnJvbSB0aGUgZGV2aWNlLg0KPiBB
bHNvLCBpZiB0aGUgVUZTIGNhbiByZWFkIHRoZSB0bV9jbWRfdGltZW91dCB2YWx1ZSBhbmQgcmVx
dWlyZXMgYQ0KPiBsb25nZXIgdGltZW91dCBwZXJpb2QgdGhhbiB0aGUgc3BlY2lmaWVkIHZhbHVl
LCBkZXYgcXVpcmtzIHdvdWxkIGFsc28NCj4gYmUgYWNjZXB0YWJsZS4NCj4gDQo+IEhvd2V2ZXIs
IGZvciBub3csIGl0IHNlZW1zIGZpbmUgdG8gc2V0IGl0IG9uIHRoZSBob3N0Lg0KPiBXaGVuIHdl
IGNoZWNrZWQgb24gb3VyIHNpZGUsIGl0IHdhc24ndCB0aGF0IHRoZSB0bSB0aW1lb3V0IHZhbHVl
IHdhcw0KPiBpbnN1ZmZpY2llbnQgZm9yIHNwZWNpZmljIGRldmljZXMsIGJ1dCByYXRoZXIgc29t
ZSB2ZW5kb3JzIG5lZWRlZCB0bw0KPiBpbmNyZWFzZSBpdC4NCj4gV2UgcGxhbiB0byBhcHByb3By
aWF0ZWx5IGluY3JlYXNlIGFuZCB1c2UgaXQuIEFsc28sIHNpbmNlIHRoZSBjdXJyZW50DQo+IG1v
ZGlmaWNhdGlvbiBtYWludGFpbnMgdGhlIGRlZmF1bHQgdmFsdWUgYW5kIGFsbG93cyBhbiBhcHBy
b3ByaWF0ZQ0KPiB2YWx1ZSB0byBiZSBhZGp1c3RlZCBhY2NvcmRpbmcgdG8gZWFjaCB2ZW5kb3Is
IHRoZSBjdXJyZW50IG1ldGhvZA0KPiBhbHNvIHNlZW1zIGFjY2VwdGFibGUuDQo+IA0KPiBUaGFu
ayB5b3UsDQo+IFNldW5naHVpIExlZS4NCj4gDQoNCkhpIFNldW5naHVpLA0KDQpUaGUgbm9wX291
dF90aW1lb3V0IHZhbHVlIGNhbiBiZSBjaGFuZ2VkIGJ5IHRoZSBob3N0LCBhcyBzaG93biBoZXJl
Og0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjEwODMxMTQ1MzE3LjI2MzA2LTEtYWRy
aWFuLmh1bnRlckBpbnRlbC5jb20vDQooaGJhLT5ub3Bfb3V0X3RpbWVvdXQgPSAyMDA7KQ0KDQpI
b3dldmVyLCBpbiB0aGlzIHBhdGNoLCBubyBvbmUgc2V0cyB0bV9jbWRfdGltZW91dCwgY29ycmVj
dD8NClNvLCBJIGFtIHNheWluZyB0aGF0IHRoaXMgcGF0Y2ggZG9lc27igJl0IGFjdHVhbGx5IGNo
YW5nZSBhbnl0aGluZywgDQpiZWNhdXNlIHRoZSB0aW1lb3V0IGlzIHN0aWxsIDEwMG1zIGZvciBh
bGwgaG9zdHMuDQoNClRoYW5rcw0KUGV0ZXINCg0K
