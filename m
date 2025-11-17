Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74AD31CA68;
	Mon, 17 Nov 2025 08:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763368860; cv=fail; b=HFecEcWeeLA75fezV2cZTamULzm05IiHQpgRiGcTMyH1dgVnLt+RotMnr5i0ttUg0BE/lBGCc75dpUD9BJlXY3dqSL6Hd6rROr0u94Cb425E7SP2BUS85HBa6WJtKx2IB87T+Eeq10Z80kTmOVCH6jkvmdsZ8UouhHk7+FMYKwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763368860; c=relaxed/simple;
	bh=TMHcmfkOCu821P9ruYsXCXdQ1BLpLqiSLvGuI+Tn+aw=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gOwbQtUUBaekEIRbI6F3mISKxe9398ssepO8NbvQbFpduHgftYC5g1qha165a2WtTD0/xPHOSG+DMhUZdRw46tLvrK+UyB5K55w++0f2fcUdDLmJkfmAP1h5c4ARXPoMsQIyK5/Lq7Y87Jp8qqDyQIIwHKlATFGlKtPZGBWMtoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nKCeBC8m; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=EQQply1w; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nKCeBC8m";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="EQQply1w"
X-UUID: 1f452a8ec39111f08ac0a938fc7cd336-20251117
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=TMHcmfkOCu821P9ruYsXCXdQ1BLpLqiSLvGuI+Tn+aw=;
	b=nKCeBC8mmi9ewq6PQv7jXpTjiQ9H+y+xfYGD8wDUaj8i8qnT489yvrmClW2xXtL8fFL1s5zL2WDUBioIHolutNlhu0ZvgyUcIrfe61jzSV6Up+nUeL5O5bPMC5jtE2qOj1DD9BDdQOBpmxTNL9aB94BjNl2TjBxjHiQW5KgTbTY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:d932bc7f-51a0-4e07-9649-a0a3a71cac8b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:7fafe1ba-0c02-41a0-92a3-94dc7dc7eeca,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1f452a8ec39111f08ac0a938fc7cd336-20251117
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1934372431; Mon, 17 Nov 2025 16:40:51 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 17 Nov 2025 16:40:49 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 17 Nov 2025 16:40:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x0ffWbRGKmVtpQmKHAJiGj5ILWcfPDYb48zdtRYqAWUo+DDytf+zAhuM4C4dCD6UYu+7nnx6IF0SZxR2YtDQRmehvJtQ1tNxLSFRA7bZ0r/CNxXUYq+q5u+DUt4h6vkp6ejKbLShSArCSaNr10Rv/LNO1wYszBVN5zspg8vnfhGpRaPZEn57rMCcG6fNfaks7jgSki8qxyUx2PEJCg8aOfftdoTJdmWCvsV+iYazTAms0VBKeDU1LA+DnRPNhFseRmbVk25QAUH0idDYiaC85MSfl38ZL59ACHQbnvJINM+xXyNyMe+a4xXJWcBP+uq44XGVF/aSS7NSireAiEMmJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMHcmfkOCu821P9ruYsXCXdQ1BLpLqiSLvGuI+Tn+aw=;
 b=NLTfgbTa7XI6Bd7pLQ7Q6J91ADXzUrlFv/QtrmQQo49yjrF/G5DnX1dA7VEE7sn6uKtda9mL8t4ZFcx4FDFwPFe9zdr7ygld97R7yj4ykN3Ziwds2MytHl4s6i/aeOUN46on6AScMIQ1pi/I7yADrKwBDZubZZWcvdVeErr+fh2jegw0SxqkncOIZGP/hxM6Xjzbr32Ai1joFFZhMCHkiLVlbJr4gOKbbbsI0Llo8F6jSJlLlhTYqKPtKen0dBaSIBy4+f6+8s5HyK0+i10ZfTowkZHiNIXUjZvo7BjjC1aNZlfe6O70RAKgJ1m/kfgRF33mcNH+RC49D4VN1HfEGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMHcmfkOCu821P9ruYsXCXdQ1BLpLqiSLvGuI+Tn+aw=;
 b=EQQply1wh6KGdeVsGeQGDSg+lH8US3lFqSLzVEYQVXikuTzUnB5xuJvMZ9drBAy5jGcdtKaZRzr/cWFcOsod24Ji7m6T0XMvrd0/bM1/9SDVO8eijm8D4oamLexD9eBKl2wuu4Gb5TITrGkO0fiCgHk38E+TNed96YcX/UBfGOM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8080.apcprd03.prod.outlook.com (2603:1096:101:167::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 08:40:47 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 08:40:47 +0000
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
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAIAAfuaAgACtbwCAAOjIgIABIdaAgAYXzICAABj+AA==
Date: Mon, 17 Nov 2025 08:40:46 +0000
Message-ID: <500022ecc5216afa01e7f606187f012294a76da3.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
	 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
	 <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
	 <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
In-Reply-To: <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8080:EE_
x-ms-office365-filtering-correlation-id: d979ec57-dcab-4347-654c-08de25b500fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YW12RjZtcEwrWUYwOWcwa0s3bmhySjdHeFdhN0U1YUJ4dTFySzRvVUtXZzV2?=
 =?utf-8?B?c05HQjY4NEd1LzFmQmxMYTBZRm9zeE9PcStyRTlTRGd5QUJmV05ZamN1QlZZ?=
 =?utf-8?B?T1lFOVpRZkl1VDViNnk0TCswRUtzNVdvcm1nUmRzejJtdlVRaE92ME9WSXNp?=
 =?utf-8?B?ZGUwakNUNkRQUkUyS2lvZW9FRWJ1VEU5MldLZENPTGdiZFZ5WWpvbnR1RmJt?=
 =?utf-8?B?TWxVQTZTS0xqdExZVHRIWVBFWStjNndndm05bTVXb0d2bHpGL2JVdkhRQWNL?=
 =?utf-8?B?VnNManBlUkRKVnFkWUgxZEhZMjJBVDZqaFNXNW9lK0hUQ1VwQ0o2b29QZXF0?=
 =?utf-8?B?T1Awd0ZXK0w2OVdlNGtMYXB6SG44bGgyZ0paNzFhWW8xQTNCUkVocU1SWmhO?=
 =?utf-8?B?SjFHbk1Nc09WeE9GV1FkdnFCMHlUOW54azJMUlU0SHVMZGNuM3hQZlBEYlpJ?=
 =?utf-8?B?dGR4SC85M09OWFZKTzh1VXM5eDhsbWpNblo5S3hWY2k2OUZNZ2Jja0hvblNW?=
 =?utf-8?B?dGVJVDZMLzE4amZyS3NpTWZieUk2b2Jza2UrNGlYNU1BQVVydFBXbURNdjBy?=
 =?utf-8?B?RFE0MTVXVlZtUFd1eVRXMmgrNDFQMTNsdVozUUMzaDJzVmhFaFAxc2hwekRB?=
 =?utf-8?B?ZFdPRWVCQzNaenpPLzVnMVpqVnQ0L0E5cERMV1BaeldFYWUvZXYzVWFCa0Vl?=
 =?utf-8?B?K0o3VG9oN2dJdVRySDFqQTJua1VxYWpSdEhzcEkxSXFma2ErNEVCWGhpN0NX?=
 =?utf-8?B?UmtrdlFhUVMyREgyZHROZ0pTcElHeTFlZ2NVa1E1YmxDUVdiQk9jZ2VpRER2?=
 =?utf-8?B?b3lCRENmREJCUmFJTHg0bEdPaUw0ODFET2lUaWZ1TUQrdktzdVl0dlRyQngr?=
 =?utf-8?B?LzlCc1RVSkc1dS84WVcrNE9lYk5nOEJsZndhYnlKL0dQY0toeUkxL3BTYlZY?=
 =?utf-8?B?bHBCVTl3d0xRR3h3aUY0Um9TU1J1eFlPYzFGTmlyYXJucHcvRlhVV05VdkdE?=
 =?utf-8?B?Mnc2ZnAxNnpjdncyRTI4SzFiUkhRRlJ4S3VXRjBLL2pyMFNYTUE5SEc5ZWtr?=
 =?utf-8?B?TVVnTE5mNFZIY0JNMEx5QnR5V045VGJ4T2N6OHpsVXR3OHpieGh3aDQ3NjNs?=
 =?utf-8?B?bkhiNWlKVi9aUFhUS2pRMmo1ejh4TDc4aFRtRXpYMjRKQnFaWTFLeUZ2cERI?=
 =?utf-8?B?OXppaXphOUVPTmI3Qmt5dElJd1g3NXBHMitjTGlaaWlWZjI5ZDhIMzc2dW9Y?=
 =?utf-8?B?Rndra09Icy9mUEEvaEdWMGZ4aTVCenNDTEF0UTQ4M1NiSm0wMVFmc1Z5VHd4?=
 =?utf-8?B?STh5OTlWVXB3UFloSUZNdWxQTHl2L1FNTDJ1VzI4ampNMHRGaE5FSUxNdldk?=
 =?utf-8?B?Tmhrbk5PRTc2Y2RFdnBwTU5xdHBaSm9UMkFucmlLNFZBQSswWG8vZHJHUXN1?=
 =?utf-8?B?WGxUWFRyWFR5cGg2MDk1WW1qNUV0TEpQcWM2UW5LOWk5VkkxV2RPTmFIbzlm?=
 =?utf-8?B?U3VLRE5lVWpQU2hHRng0ZUtXUjk3RHNxOGxocVUxZDVkdXkzOXVFaTB6cTBQ?=
 =?utf-8?B?WTVCZUtrTG1JTkt1RlJNNGZSTkFCQ1lIb3VKY0JpK0h5aVh2MmRZZllGZGRE?=
 =?utf-8?B?YVJ0a1RvMUxscThNcE1PSHFpOW5CK1ppNGJrRmpYb2FPQllTNUlYdi9EUmxP?=
 =?utf-8?B?dDBLNDJweUpwMS80R1p5aGJvKzhuZUM3Rnc5OUI5U09QTE5INCtnYWZPOWNU?=
 =?utf-8?B?TzludWhxd245Z0ZWbllGMlN3K1NDYWZmMlNic1hBaVc4QkxOdTFUMDU5ZjVk?=
 =?utf-8?B?Zm5WYlpqRnFpelNwSko5Sm01a0Jpek9URHk2RlRUSllCTXlBdGFVSjlNYUQ0?=
 =?utf-8?B?bkZNWFhSZTdvSlJJV2REN1oycEZvL1hVYzNhaWltUW1MM0hkWGdqNjQ1RVJx?=
 =?utf-8?B?Sm9nTW9oZU11Q2lKbWNxcVNkdS9qZFM0d0FIb1ZiMmdlRjdDNmYybU03dlp5?=
 =?utf-8?B?eEg5QW4yVGo1WkJNSDMrRmJYTmVDZjNtU2FOd3FuVEUxU1lneGI5c1dxa0N3?=
 =?utf-8?B?OHpmNE10Mkg3Sk9XdnNkU1FUbG8zeTJremdJdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzV6bkZNTWpCRmEzL2ZYRm81L0NxK1BkOHN0L1F5OTF2OTJXeHJjMkwwMkYr?=
 =?utf-8?B?OVJtRG5MYXVmOE9aSVltbFNFUHRqL1BqS0pPbXorUTRaenltVng5QUdUem5z?=
 =?utf-8?B?Q2F5U25GaERPMWtodm56eUFPT1VpalFYMnBoSHYxZlNnQmFiNHZMTExpVis2?=
 =?utf-8?B?NUd4MUlBek1FTHBERDlaMUZ4a2dJa0NhdXY5SmFrOVZVY0ZHVVJrSG5xdzJT?=
 =?utf-8?B?RHFQRkpDN0dUQTVOVDBqdko2RUpkUDBSQUo0WkRHVmFHVzV4RUZ3Nkg3K2Ju?=
 =?utf-8?B?cWJPWTJJdFlKWGdqa2RjMUUwOWV6TEtsbmllYVkzN0pDSkVWRXdkbEFsRXow?=
 =?utf-8?B?dUIrYjBGWFV6K0VvY2FMZzRYTjFVdkQ3Y1phbTNZTzg5a1I1dXFCZnU5MnZy?=
 =?utf-8?B?WGRGSnRTV2U4YVZvVkttSlgzdktRemNFUXhpc1NqUkxCRTVtNFFQT2NxVlZN?=
 =?utf-8?B?dEZQV2dQVkpmUlJjRVR1ZGE1YVpZRXltZFpzVHppOUFUSGU3YW51UnRRbUFu?=
 =?utf-8?B?dWp1RDdDb1hWKzdtSGdSWXEvb2pRSmpENWZkN1JPdTl6WmR3RHJlWjRmWEVJ?=
 =?utf-8?B?eTF3RzdleVl4VGRlN3Y0VXBETjFMR1QyZGhGbGRMalZTSHZoZDdmd24zRWVT?=
 =?utf-8?B?QjM2VndPTlM0a3Z4SGVkUXJPQzdnd0FVYS9UaUZ0OXpKdE5PT1YvY25ndnJF?=
 =?utf-8?B?Myt0bkczV3BoQjFKT2dYYUN0dGJRVk9jTTZRUnlUQzUzclRuaEwxOFc5akpy?=
 =?utf-8?B?SzJPcFRoWk1WVk13aVBidjFDc3dKKzUxS2ltT09PNjE5ODRVdVlQTDVuQ1ZD?=
 =?utf-8?B?ZW9wZ2JSeFN2TDBFamEwTnczVlFiWFRyV2UvUVp2bi9ZSVRDNXQwWWptU3o0?=
 =?utf-8?B?VHJmVDJuTFJndUF1NGVXMi9McDhKTkdDMC85NDdwU2EydHNySm1KYWZaQzA4?=
 =?utf-8?B?OE9pYUJGTTY1bXd0ZklzYlFrR1UwQStpcDFzM3I5TWc5V2pXR2YwSUtFNUU0?=
 =?utf-8?B?MzZWZ2piemFObkZ6SC9keHVSMUoybEpvU2NFcGt1QUczbjVWMGZnVlo1L0wv?=
 =?utf-8?B?WW9Ydmx3aTh0MUsrQWYwLzc1aWd2WjJUcERjTU1jeVhlMTRpTUtVZEJBVEJ0?=
 =?utf-8?B?ajhQMlZIZXBVMTk4TnlyU1oyYWFqeTVNeUJSdXp5aGEwSWNyYy9PVDhYQTFL?=
 =?utf-8?B?QlphelFIb2RiUVoxdUc4ZFN5L0E5ZGJnQ2pycExRQjdVaXh4b1FSZUhQaUhZ?=
 =?utf-8?B?R2k3UDBjOUtHYTVKM01vVGRNZ1Z1L1FIb3hzdVVwZjhFcmRLRCtSM2JSbXhW?=
 =?utf-8?B?NEZPaTVMMHJhZ0RoM0lhTkUvYmJUODJYbVk2TFROYnJIUVFDcWhYb0hVWWlG?=
 =?utf-8?B?cTR3WERlTXliMDdjY1poWHNBWFByNXpNNkVXVjdhWUxWWmxpT3ZlbWNQYUNF?=
 =?utf-8?B?NkczQmtLOTg1Y0toUmszYjNYTFNJdENCS25mRHpNRThxNkRqeUNHMnViSUU3?=
 =?utf-8?B?OXU2dGZuYmNUTUVGNnYvRUl5TGZiYmNHT3dQSEVnOThuR1BXVzhaMGUxdTJx?=
 =?utf-8?B?SUZPTW9wYkpJSUIydDJocUxXb2c2d1RPT25SU0VFSFZPWCs3VVNQdkpkdEg3?=
 =?utf-8?B?M2pBOG1oVEduaXVSWGJibzMzd1JicU50VFMwVXpLNzhwRkNrL2NkaklHSmt6?=
 =?utf-8?B?SG5MVklsYW1PYUloOEVBMkQwaTlSUGdCYytRRHJNc3hDQVlReGdjL0t6a25B?=
 =?utf-8?B?MERNSExNZVdHcms0MWlmd0Q2aG1lV0VXZGpFbEJaV1MrdG5QYlR5N25zTVlX?=
 =?utf-8?B?N0R2YWhMSFBOdGU1Um5jUlVielBZOXpPM0RRT3ptWUdvdGgyeGlPNGxNM0Np?=
 =?utf-8?B?NHdDbnJJR1RhNi9rd1JJeHBodGRkVjZwMjdVbS9tSGUrOWp3Z3Q3anlzWDBY?=
 =?utf-8?B?aGNITk1wUkYwREtGb1lmbXgyOC9xK0ZUbmx4aGlJTFdPbER0aU4vQlIyQjNV?=
 =?utf-8?B?VWs0clJta1A5bmhhU1ZPU2kxMEhPYXg3NjRhN3FCQ0hscnZUQ0p2dXRGWkIv?=
 =?utf-8?B?L0xibVhBcURzOWdwR1RhMnJydk9ZUDZkSk5hTnNQSkpVeW5lY2x5am5PU09Q?=
 =?utf-8?B?U3BKNFFNeUZaNldzYnFLS3duU0pYSXJQUWJiVzgzNUdzSEJoa2RHWHYwRFpS?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D979EE0264CE141999D95BE3F671C04@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d979ec57-dcab-4347-654c-08de25b500fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 08:40:46.8724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbdQFtaW7nxfZVo6WIcEvFqqS2kQpZLlqmnXfGnyq2hgVssPyHRY2Vcghoy6uBNU6CP1DKiApnH2lSAMvfOSIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8080

T24gTW9uLCAyMDI1LTExLTE3IGF0IDE2OjExICswOTAwLCBTZXVuZ2h1aSBMZWUgd3JvdGU6DQo+
IEhpIE1yLldhbmcsDQo+IA0KPiBJIHVuZGVyc3RhbmQgeW91ciBjb25jZXJucyBhYm91dCBjb25z
aWRlcmluZyB0aGUgd29yc3QtY2FzZSBzY2VuYXJpby4NCj4gV2hhdCBhYm91dCBkaXJlY3RseSBt
b2RpZnlpbmcgVE1fQ01EX1RJTUVPVVQgKDEwMG1zIC0+IDMwMG1zKSBhbmQNCj4gcmVkdWNpbmcg
dGhlIFRNIHJldHJ5IGNvdW50IGZyb20gMTAwIHRvIDMwPw0KPiANCj4gUGxlYXNlIGxldCBtZSBr
bm93IHlvdXIgb3Bpbmlvbi4NCj4gDQoNCg0KSGkgU2V1bmdodWksDQoNCkNoYW5naW5nIFRNX0NN
RF9USU1FT1VUIGZyb20gMTAwbXMgdG8gMzAwbXMgaXMgb2theSBmb3IgbWUuDQpUaGUgYWRqdXN0
bWVudCBvZiB0aGUgVE0gcmV0cnkgY291bnQgZnJvbSAxMDAgdG8gMzAgaXMgbm90IA0Kc2lnbmlm
aWNhbnQsIHNvIGl0IGRvZXMgbm90IG1hdHRlciB3aGV0aGVyIHRoaXMgY2hhbmdlIGlzIA0KbWFk
ZSBvciBub3QuIE92ZXJhbGwsIHRoaXMgcGF0Y2ggbG9va3MgZ29vZCB0byBtZS4NCg0KSG93ZXZl
ciwgdGhlIG90aGVyIFRNIGNsZWFyIHRpbWVvdXQgb2YgMSBzZWNvbmQgaGFzIGEgbXVjaA0KZ3Jl
YXRlciBpbXBhY3Q6DQp1ZnNoY2Rfd2FpdF9mb3JfcmVnaXN0ZXIoaGJhLCBSRUdfVVRQX1RSQU5T
RkVSX1JFUV9ET09SX0JFTEwsIA0KICAgIG1hc2ssIH5tYXNrLCAxMDAwLCAxMDAwKTsNCldvdWxk
IHlvdSBjb25zaWRlciBzaG9ydGVuaW5nIHRoaXMgdmFsdWUgYXMgd2VsbD8NCg0KVGhhbmtzDQpQ
ZXRlcg0KDQoNCg0KPiBUaGFuayB5b3UsDQo+IFNldW5naHVpIExlZS4NCj4gDQo+IC0tLSBhL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qu
Yw0KPiBAQCAtNjgsNyArNjgsNyBAQCBlbnVtIHsNCj4gwqAjZGVmaW5lIEFEVkFOQ0VEX1JQTUJf
UkVRX1RJTUVPVVTCoCAzMDAwIC8qIDMgc2Vjb25kcyAqLw0KPiANCj4gwqAvKiBUYXNrIG1hbmFn
ZW1lbnQgY29tbWFuZCB0aW1lb3V0ICovDQo+IC0jZGVmaW5lIFRNX0NNRF9USU1FT1VUIDEwMCAv
KiBtc2VjcyAqLw0KPiArI2RlZmluZSBUTV9DTURfVElNRU9VVCAzMDAgLyogbXNlY3MgKi8NCj4g
DQo+IMKgLyogbWF4aW11bSBudW1iZXIgb2YgcmV0cmllcyBmb3IgYSBnZW5lcmFsIFVJQyBjb21t
YW5kwqAgKi8NCj4gwqAjZGVmaW5lIFVGU19VSUNfQ09NTUFORF9SRVRSSUVTIDMNCj4gQEAgLTc2
NjMsNyArNzY2Myw3IEBAIGludCB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soc3RydWN0IHVmc19o
YmENCj4gKmhiYSwgaW50IHRhZykNCj4gwqDCoMKgwqDCoMKgwqAgaW50IHBvbGxfY250Ow0KPiDC
oMKgwqDCoMKgwqDCoCB1OCByZXNwID0gMHhGOw0KPiANCj4gLcKgwqDCoMKgwqDCoCBmb3IgKHBv
bGxfY250ID0gMTAwOyBwb2xsX2NudDsgcG9sbF9jbnQtLSkgew0KPiArwqDCoMKgwqDCoMKgIGZv
ciAocG9sbF9jbnQgPSAzMDsgcG9sbF9jbnQ7IHBvbGxfY250LS0pIHsNCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGVyciA9IHVmc2hjZF9pc3N1ZV90bV9jbWQoaGJhLCBscmJwLT5s
dW4sIGxyYnAtDQo+ID50YXNrX3RhZywNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVUZTX1FVRVJZX1RBU0ssICZyZXNwKTsN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghZXJyICYmIHJlc3AgPT0NCj4g
VVBJVV9UQVNLX01BTkFHRU1FTlRfRlVOQ19TVUNDRUVERUQpIHsNCj4gDQo+IA0KPiANCg0K
