Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD927482;
	Thu, 22 May 2025 03:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747884415; cv=fail; b=H6evnRnocD/YdfyFej7KYVJFvKHlqPZHtiTvDvTdv6mZ8p9v0x9sjbeeA+8pKbd3xjRKVdtxBGDd8a6guokklbt488K39G4o+JmlJZGVWj3lN6kcgfaob5O2DUdV2vAYKbZFXTyfU0GleIokeeurc0SQwKYk/AWJmPs9aeZEbBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747884415; c=relaxed/simple;
	bh=3J3+4SEYLZsrcIgPaF8n9+LIU8f13My6RRtzGnPFyK4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mZkkO/5dA3B1R/d3tMnhB0fJlngVTeDRY5bq70ImtgasM24y+9uNbR9i1y96eKNbTK9dGWrLh7duf1ujjfKHLn6v8hrl20MiRyrhFEf7Bv4w/4uGapBIIyNjySC75jGBS37mplRaXbdIr+DejA8VbJ0tm80UyJ0Rf5BwJu+c/O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Yc7YqNN3; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=LU2Pb0/G; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Yc7YqNN3";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="LU2Pb0/G"
X-UUID: 977e34da36bc11f0813e4fe1310efc19-20250522
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3J3+4SEYLZsrcIgPaF8n9+LIU8f13My6RRtzGnPFyK4=;
	b=Yc7YqNN3jPGVDzVhTnjbYoDFz7itNMfz3zYuWqkPqA+PvyHR19zunXG0O6g3OC0U+Cv/qOQv+yDwDNEo9MUaYQ08LCjsPToMcpYmqS3IDqgv3GSyYfIh5PUjSUyr1/mqGECDfOjK1M6+f+xy8khovgDu9IO1Sb33BMKRPc464+A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:94cab357-64b6-44f3-9228-8ab4b58d8909,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:7fcc9747-ee4f-4716-aedb-66601021a588,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 977e34da36bc11f0813e4fe1310efc19-20250522
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1642140496; Thu, 22 May 2025 11:26:47 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 22 May 2025 11:26:44 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 22 May 2025 11:26:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SY7erVBZaQ9H5oMiNC/M9kHUr1cn999cp8yiubQP3QfvXIMKYGBiH6cTiwRXceaJqVZC6xVNNG1K+R9PR2j09ItlXdL3ZSiXnJ5mpoOUY6J1JnPZ0+QqO8V6rUfX+YAacBofIvYUEMvehIK0wepIQnSyOMR2my7xd9/oC1Lc2WAh85K/Ok7hucfGBhCpUwd3eASI+oHmZReesvm0RD9zgXkb/+LspnmeUncFe6uXWRdekcIXSn8a8x+CgvLLb5FCudcXKoUGgz6vRpd0j+UrY6lVt6iEA3GecpJzA31pMN8FwfrECZadYDnzIVIgOpfhCBTtNVrTUT6COPdDQjOc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3J3+4SEYLZsrcIgPaF8n9+LIU8f13My6RRtzGnPFyK4=;
 b=t/uIxVNRJ/uMGG79pT4ar22nOyTWMzpuMXUouqaPf1aWN1w4YSsMlCA056u/WVV5OZ0OD67zqN89rfzWZQfLNxN7z4GlPiNiFp1C4qP6yE17Tz2A7zYkvUjZ1IoV9l8ENR9FGcO3OHPxYt4wEG+ExsFK6fr4uYHv1XSXDBXzR0ZvIsHSTDThXR30owyI2hy0z62j+OdGQlE68WrLprdTVum8ASqJ7QSLEwQ42U5erffF3MopLfYfqgAs5xLoahgXpmqiR9vmY9Oo0Cl0BM/ibFOrbeBT09TU4yvVgz35FabZ2mZnZPNzeJ2Ok9kIzMxR5sxlsT1+/78wvNyJrLSUDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3J3+4SEYLZsrcIgPaF8n9+LIU8f13My6RRtzGnPFyK4=;
 b=LU2Pb0/GMQwVl0AoALEJpJ0GGIFyJTG4QLyBQLBv0MV/kAgEBSD++AtGh5BE77OoyuuEC/5PdKlbNO5yWyAbCcHh/cwukFqDGfaian7OQanG64YBFc14HeBdld6AMPxzUg/86+iGfHe5hTbwlGOl0IQATemNNX9DCQgltiInlFQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7844.apcprd03.prod.outlook.com (2603:1096:101:171::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Thu, 22 May
 2025 03:26:42 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8769.019; Thu, 22 May 2025
 03:26:42 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "tanghuan@vivo.com" <tanghuan@vivo.com>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, "opensource.kernel@vivo.com"
	<opensource.kernel@vivo.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"wenxing.cheng@vivo.com" <wenxing.cheng@vivo.com>, "luhongfei@vivo.com"
	<luhongfei@vivo.com>
Subject: Re: [PATCH v5] ufs: core: Add HID support
Thread-Topic: [PATCH v5] ufs: core: Add HID support
Thread-Index: AQHbyWthn7PGWIdsckicQEY+2V08FbPbf26AgAGoUICAANgWgA==
Date: Thu, 22 May 2025 03:26:41 +0000
Message-ID: <f59c50ee3f5858535eca2887f326a8bb1117371f.camel@mediatek.com>
References: <ab468bb26dafca673d7ffca7dff519b7cf024cdc.camel@mediatek.com>
	 <20250521143317.637-1-tanghuan@vivo.com>
In-Reply-To: <20250521143317.637-1-tanghuan@vivo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7844:EE_
x-ms-office365-filtering-correlation-id: a495e650-2f81-474c-2568-08dd98e078ab
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T3UxM3pOTVhKWFp5S3RnaERmMHVqdXh1ZklkUXRqazFOUWJBdSt5Z1JNUCtM?=
 =?utf-8?B?OXNvY0ZrZ2kyeEoyakdSWXZ6blFVWUhwYWh0d3U2VlZNcEQxbkV2RXdvSS91?=
 =?utf-8?B?eW53cmYzem5MKy9JTjREOVdYbmNZZXRER0NHL01GY3R1YXM2WWZ5UEdKMjhR?=
 =?utf-8?B?Q3JWOFpBZ0ZHeFJNdDRSZ1Urd1dSYWRsSnQ3ektrWG40SmZ5amV4ck1rRW1L?=
 =?utf-8?B?NFA1c2VZeXpRSlNEZnlzRDFHMHdsbDY4eWs0b0JkZUNqTStIc3ZuUnZZejZB?=
 =?utf-8?B?N1BqdEZlcXFkMXc4TEQrckRvNWRyRy9tVDJkWGNvQ2dNMFBHRnhjK0wzaHZ6?=
 =?utf-8?B?a2hVM1NrUmY0OWYyelJSZWptNXlSWE9laEE4amlkcDBiQUxWS1c3emFRdGc4?=
 =?utf-8?B?dzlDRWkwVEJaalh5eFpuOVZCMi9XZytPbmdacWJtcHhUbUNFUHR4U29TRFhi?=
 =?utf-8?B?aW9reU82WXpLWmpsWUtiWDFqY2Vhc1ZDcWlRdWNjRmE4TmJSanZTV2tnd0g0?=
 =?utf-8?B?L2xwZXZsMUxEZ3IwdHJvS0srTTdFL2cxUktLYWFvTjJUVDcxTHczMmNZZzRs?=
 =?utf-8?B?YnhaQkYzQWwyMzcxY3IraTgwUXRIRGdNcFkzZUFEb1ZwS3ZBKzViOTkya25X?=
 =?utf-8?B?OWswSTJIYStHdm04OFRudlIyQ2xaWGF0UXA1MnU5d3A5UWs1WGVnUDJVUEs4?=
 =?utf-8?B?bEN1VkVtMnpVOEVmanZ2SjA3czhiSzJsRmYrbldZeSsrM2pGL21IQUx4NVor?=
 =?utf-8?B?OE0vSEdRSmhDTElabjFaTlBKckZ5T1pMb2lMOVMyMlFDTzVXdVdhL2lRbm96?=
 =?utf-8?B?dXlvQldmTVdHdmp5NllpNDBMV0JCZENpa3BwazZ2S0dud1Q1VmxSRFN5dGNF?=
 =?utf-8?B?blNsL3RFY2pkWUtEb1YxOHZ2a2M5dm03bkJrckpMZTRxQmZnM2ZOSW40elVt?=
 =?utf-8?B?QnJoUUxUQ1M2MkFDdzE5RmJHdkZtREdUWUcyeTRZbUdpaXFNajZIc3lXTWUr?=
 =?utf-8?B?RmhmTG9RbkVoVHUyTDRiNS94RTFsYjN0L3Z6cDR4VkdLaU5PWStiUnJtWndn?=
 =?utf-8?B?U1BjQzB1VVZ1dEVPeUFNbmJHWktRQWJWeXJjWkswaXduUVpoaXN3MEk2cGl1?=
 =?utf-8?B?OC9HelNKNVhWbVhJRmFiTmNjMmRScWxwb08xZGJLWTFpMG1DU1Z4N2wrODJ5?=
 =?utf-8?B?TTZUUEhMVHpMeGxMWDdxckJIN0Z6MzN3aFNCVVR5d0RsajZLQkoyemg0bFBq?=
 =?utf-8?B?cUpLQ0crelVxK0NEcGVnb0Rram11cXAzMEQyUXBZaUQ3OWZoWmJodXhlOWV2?=
 =?utf-8?B?L3drQy9yVTB4ZlNSUDdLSlFSNFhWTXNvdkJvMEVBakpGVmNORm14TS9GTERU?=
 =?utf-8?B?QmdXcklOZG9IejU0OHFJNnZkc2g0UkJ1enRBakFmRjR4cVhpZ1I5bWdmK0tu?=
 =?utf-8?B?UDlrZzFqL1JWRXJZUUViNHJkeVVsMGhaSFpxZ2Q4a09JdVQrT0ZOZnhhUlYr?=
 =?utf-8?B?OWd2OWFNNXZScGJtODk1VUM2WjVZU0lHTzE3SDJRb24wY3lBbzMyUkx5UjZM?=
 =?utf-8?B?ZVRvOEQyaG9OY2IrbHlxZ21hdHNWdTZwYkZkZTAzdHRLNUxGU3FuREpOcDVy?=
 =?utf-8?B?aHhJTzBSRGc3RlhpR1hwemxScDFWMGRmWkdyRDVNeFlxVDNBZGhJNlErbERh?=
 =?utf-8?B?T2syeWFyUEtXV3VyS0loT3R4ZmduWWlzc1RJOUMxOFlOWkhMYndmZDNOUUxE?=
 =?utf-8?B?elJvby9sQ3NRenJaZC83Q2QzQWhhem5ybmNjRXRiM2M2Uzk4eFh5S0dNVnFX?=
 =?utf-8?B?dE0yOEZIYS9xSEJXWURZd1o1QzZ3K2o3NlloS1VhQklBMVFzK1JIZE5TbkQ3?=
 =?utf-8?B?S1llZTQvUFdzb0RYREphN0MyTzc0VDRFVXRzRlZVc0Z4Z0xrZ21IU2EvNTU2?=
 =?utf-8?B?aEdpZEZNQlgrOVVyQjZVTEFiV2M0QitVc0U5WGpzZS9iRkQxRUNtaVQzeWM3?=
 =?utf-8?B?ME42RU5uOXJ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vy9paFNzNmV4N2hBeFB1ZXA4MjZkdlhxNS9QTXFwRGJYRnFEcmxyMmozemtH?=
 =?utf-8?B?UDVsTEpWZVpFUExLdEoyUk9zMDJ3K2s1SXBZcUVmY0Z0RTdjQy8wanVZcnJq?=
 =?utf-8?B?VzE5dHZYS29XQjdWdHRDeDZlUlh6a05Xd081SGZZUzJSYk0yZ0VscE5qNTZw?=
 =?utf-8?B?aWphaGQ0ZXovMm16cW5BZ0RUdlFBMzliUDJWTWk0VHdBMi90NXhjalIweGVx?=
 =?utf-8?B?cHlwckd0YmJCT2pObEFsWS9LeHo0ZXhwVTU4S3pLVk9lbjUvUXNNRlFwWHZJ?=
 =?utf-8?B?RmVHZmdaYjlodmh6cS9GY2ExVTYrcmZlZDhPK1RhSmpnSVYvdWtwM0RWRXdz?=
 =?utf-8?B?ZE85aHVWN3l6emd1SzZDL1NLYWllSDhrTzMvSUo2SHdSNURGcDJyL3NZOC9Y?=
 =?utf-8?B?bzRoYzdjSUw4ZGcwWmNkenVDdHp0cGxmUW1YeVhGWlljZ0tPN3NXcGpWWnpE?=
 =?utf-8?B?eGc3QUI2d3BsSFp0T05VcjZLQkVLZ0RoSlV2eEUzQWR4aElrTW1vVE94U0Nx?=
 =?utf-8?B?SUhSN3B4VXovQUZmUUFlZ003T2owL3psSDhMbHpYK3VtZWVmL2pNK09rMzFJ?=
 =?utf-8?B?TVd1dzd0N01Bd0tjQUN3ZTJ3K0xKcENnMDNoYWUyWlZoUlRvRGdKMzZBSjZP?=
 =?utf-8?B?TG5YcW1TaVpTb3ZLRmJrNlcxaC9WQlUxWjJuY00xUW44MGxydFhZRHVXNjZX?=
 =?utf-8?B?VndySnJTNHRseVkxb0NLZUNKNlFHRW5UQXoxTzNlMkU4ZStacUF1V0w1cHhC?=
 =?utf-8?B?T09ER3NDYmhKUTFvM0NnSnV3c1ZKOG94VU45TGtLclY1Q29TNDZJWlZDRk44?=
 =?utf-8?B?WEdsL0tuMTk1Ui9oZUQ1Q0JPMzlJWll2SGdtdHJQRHpUNVZzSll2UW8vUE40?=
 =?utf-8?B?N3BjeDZEek5lYWRDOFBCVXV1VjIyMjBjSWF5UXFkUzltYXZnSFhMWDFCV2No?=
 =?utf-8?B?bjlrNm5GbVhUaXdmMndaUENOYjBqVWVnbVdMbTAwcHZlQUFWQm1kcEJBS2Jv?=
 =?utf-8?B?L3N3MlNwYWh2VDVsdUZnc2R3bzZaNERqTjExTGZtTElPK1hiQkpFSm82bGRV?=
 =?utf-8?B?OUZ4TGFSa01rWHlkN2VuMHorMXBtaElmd0x2R2RkTFBrbWNnSkE3bDNrRzhm?=
 =?utf-8?B?VzlJaWlCdGMyQ0tIR05SR25zeE1NSlV1WDlnalh3QUI3L1FBZWRYMUdpRC9H?=
 =?utf-8?B?TFMrLzVKeW0zcHNuam5QVXVLSmJ5SGxPenFPUHArek1RM3VZSW0wVkVSdkNN?=
 =?utf-8?B?U3N3emhVNlozQXUzY0thZWZBenZLeU5uU1p4MG4yVVFZWmhESVkrVHRubTRx?=
 =?utf-8?B?bDFjWWNyQ3E5b0JRd1ZuSmNtRFgwNmQxTkhOMWJTdG5Idm9tUWJIQWtoKzdD?=
 =?utf-8?B?S2ZoZDdNMTN4NWlKT2UwOTd4cFV3SFVwZTJnbnd0QWUrbGcwRWFXOXBtaWhz?=
 =?utf-8?B?Mm5PZkkxS0swdE8wMGJuNEZwN1dIeXNsNmt5WVNpNzIrZXBLN2hTa3BlUHpZ?=
 =?utf-8?B?SENQc2ZqRC9OczJ6NGR1YlNLK1FqNDlvMFBJR0NVTlZzODhIU09ReHVOU1VJ?=
 =?utf-8?B?UVBUUHFsTDYyNzdJZXBXK1FRZDVWWDRwQTRnR3VrTjNoa2gvVExFYnhXSExk?=
 =?utf-8?B?cmU0a1lxMmh6bUlkZG1TamNwWmJScUVjWHF4LzlKMXBDTGZjQzl5TkpIenk2?=
 =?utf-8?B?SU5EMEdEMG9pZDVwN0xKQURrWkVtMU82Z1ZnVVBFYklTTURnVTJRY3hOUG9Y?=
 =?utf-8?B?SmNiOFNwRWRTcTl1ZzVOUTNDRXE5THQ0ZSt2KytRWjB5R0RvWTM3L2REUUVl?=
 =?utf-8?B?TDczMm4zZitIaURNQWZrU2FLRFdEUGdJQlo5NG5qczZZS3FpYWgyN1FwM2th?=
 =?utf-8?B?YmVFSUFubFBHak9HK2kyRzlVNkh4b3FTdVRIL2EzUm9uYjFNUm5UcW5hQjNj?=
 =?utf-8?B?UEZLbCtmTWFKSXJHT2t2WnV2b3c2RWxSeElPNjhsbU9mTytXNE1PdUVZNDla?=
 =?utf-8?B?VlR2b2NyTCtTR2Z2b0huczNRdWNrdW05TWZTamk3Z2kySnBoeTBPT2xoUUd4?=
 =?utf-8?B?a3ZJWmttdVpoNjdZcHllb0dodjN3SFZ1dld3YXZlUk4rejNDcXRQMWduT0kv?=
 =?utf-8?B?WHpIMXNLVTdTWVpVTkhLbjNZb1lWWUJkNDltWmZEYis1Sy9GNW1lYVpyTlJF?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B48C3B022E2C5B4A817C9030C97E47FD@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a495e650-2f81-474c-2568-08dd98e078ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2025 03:26:42.0696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EzqXi4cKOgSDDr453bqu6Bfdg5NB1ixtNoeBXKnyrkJXZIyXIa3urZR+OtzeHUWc8qbX47M9BWoDlYpFheM79Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7844

T24gV2VkLCAyMDI1LTA1LTIxIGF0IDIyOjMzICswODAwLCBIdWFuIFRhbmcgd3JvdGU6Cj4gCj4g
RXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNo
bWVudHMgdW50aWwKPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRoZSBjb250ZW50
Lgo+IAo+IAo+ID4gPiArc3RhdGljIGNvbnN0IGNoYXIgKiBjb25zdCBoaWRfdHJpZ2dlcl9tb2Rl
W10gPSB7ImRpc2FibGUiLAo+IAo+ID4gPiAiZW5hYmxlIn07Cj4gCj4gPiA+ICsKPiAKPiA+ID4g
K3N0YXRpYyBzc2l6ZV90IGFuYWx5c2lzX3RyaWdnZXJfc3RvcmUoc3RydWN0IGRldmljZSAqZGV2
LAo+IAo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZGV2aWNlX2F0
dHJpYnV0ZSAqYXR0ciwgY29uc3QgY2hhciAqYnVmLAo+IAo+ID4gPiBzaXplX3QgY291bnQpCj4g
Cj4gPiA+ICt7Cj4gCj4gPiA+ICvCoMKgwqDCoMKgwqAgc3RydWN0IHVmc19oYmEgKmhiYSA9IGRl
dl9nZXRfZHJ2ZGF0YShkZXYpOwo+IAo+ID4gPiArwqDCoMKgwqDCoMKgIGludCBtb2RlOwo+IAo+
ID4gPiArwqDCoMKgwqDCoMKgIGludCByZXQ7Cj4gCj4gPiA+ICsKPiAKPiA+ID4gK8KgwqDCoMKg
wqDCoCBtb2RlID0gc3lzZnNfbWF0Y2hfc3RyaW5nKGhpZF90cmlnZ2VyX21vZGUsIGJ1Zik7Cj4g
Cj4gPiA+ICvCoMKgwqDCoMKgwqAgaWYgKG1vZGUgPCAwKQo+IAo+ID4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiAKPiA+ID4gCj4gCj4gPiAKPiAKPiA+
IEhpIEhhdW4sCj4gCj4gPiAKPiAKPiA+IENvbnNpZGVyIHVzZSBiZWxvdyBjb2Rpbmcgc3R5bGUg
Zm9yIHJlYWRhYmlsaXR5Lgo+IAo+ID4gCj4gCj4gPiBpZiAoc3lzZnNfc3RyZXEoYnVmLCAiZW5h
YmxlIikpCj4gCj4gPiDCoMKgwqAgbW9kZSA9IC4uLjsKPiAKPiA+IGVsc2UgaWYgKHN5c2ZzX3N0
cmVxKGJ1ZiwgImRpc2FibGUiKSkKPiAKPiA+IMKgwqDCoCBtb2RlID0gLi4uOwo+IAo+ID4gZWxz
ZQo+IAo+ID4gwqDCoCByZXR1cm4gLUVJTlZBTDsKPiAKPiAKPiAKPiBIaSBwZXRlciBzaXIsCj4g
Cj4gCj4gCj4gVGhhbmsgeW91IGZvciB5b3VyIGNvbW1lbnRzIGFuZCBndWlkYW5jZe+/ve+/vT8K
PiBJIHRoaW5rIHlvdXIgbW9kaWZpY2F0aW9uIHdpbGwgaW5kZWVkIGltcHJvdmUgdGhlIHJlYWRh
YmlsaXR5IG9mIHRoZQo+IGNvZGUuCj4gCj4gV2hhdCBkbyB5b3UgdGhpbmsgb2YgdGhlIGZvbGxv
d2luZyBjaGFuZ2VzPwo+IAo+IAo+IAo+IHVmcy1zeXNmcy5jCj4gCj4gK3N0YXRpYyBzc2l6ZV90
IGFuYWx5c2lzX3RyaWdnZXJfc3RvcmUoc3RydWN0IGRldmljZSAqZGV2LAo+IAo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLCBjb25z
dCBjaGFyICpidWYsCj4gc2l6ZV90IGNvdW50KQo+IAo+ICt7Cj4gCj4gK8KgwqDCoMKgwqDCoCBz
dHJ1Y3QgdWZzX2hiYSAqaGJhID0gZGV2X2dldF9kcnZkYXRhKGRldik7Cj4gCj4gK8KgwqDCoMKg
wqDCoCBpbnQgbW9kZTsKPiAKPiArwqDCoMKgwqDCoMKgIGludCByZXQ7Cj4gCj4gKwo+IAo+ICvC
oMKgwqDCoMKgwqAgaWYgKHN5c2ZzX3N0cmVxKGJ1ZiwgImVuYWJsZSIpKQo+IAo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1vZGUgPSBISURfQU5BTFlTSVNfRU5BQkxFOwo+IAo+ICvC
oMKgwqDCoMKgwqAgZWxzZSBpZiAoc3lzZnNfc3RyZXEoYnVmLCAiZGlzYWJsZSIpKQo+IAo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1vZGUgPSBISURfQU5BTFlTSVNfQU5EX0RFRlJB
R19ESVNBQkxFOwo+IAo+ICvCoMKgwqDCoMKgwqAgZWxzZQo+IAo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+IAo+ICsKPiAKPiArwqDCoMKgwqDCoMKgIHJl
dCA9IGhpZF9xdWVyeV9hdHRyKGhiYSwgVVBJVV9RVUVSWV9PUENPREVfV1JJVEVfQVRUUiwKPiAK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgUVVFUllfQVRU
Ul9JRE5fSElEX0RFRlJBR19PUEVSQVRJT04sICZtb2RlKTsKPiAKPiArCj4gCj4gK8KgwqDCoMKg
wqDCoCByZXR1cm4gcmV0IDwgMCA/IHJldCA6IGNvdW50Owo+IAo+ICt9Cj4gCj4gKwo+IAo+ICtz
dGF0aWMgREVWSUNFX0FUVFJfV08oYW5hbHlzaXNfdHJpZ2dlcik7Cj4gCj4gKwo+IAo+ICtzdGF0
aWMgc3NpemVfdCBkZWZyYWdfdHJpZ2dlcl9zdG9yZShzdHJ1Y3QgZGV2aWNlICpkZXYsCj4gCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0
dHIsIGNvbnN0IGNoYXIgKmJ1ZiwKPiBzaXplX3QgY291bnQpCj4gCj4gK3sKPiAKPiArwqDCoMKg
wqDCoMKgIHN0cnVjdCB1ZnNfaGJhICpoYmEgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsKPiAKPiAr
wqDCoMKgwqDCoMKgIGludCBtb2RlOwo+IAo+ICvCoMKgwqDCoMKgwqAgaW50IHJldDsKPiAKPiAr
Cj4gCj4gK8KgwqDCoMKgwqDCoCBpZiAoc3lzZnNfc3RyZXEoYnVmLCAiZW5hYmxlIikpCj4gCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbW9kZSA9IEhJRF9BTkFMWVNJU19BTkRfREVG
UkFHX0VOQUJMRTsKPiAKPiArwqDCoMKgwqDCoMKgIGVsc2UgaWYgKHN5c2ZzX3N0cmVxKGJ1Ziwg
ImRpc2FibGUiKSkKPiAKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtb2RlID0gSElE
X0FOQUxZU0lTX0FORF9ERUZSQUdfRElTQUJMRTsKPiAKPiArwqDCoMKgwqDCoMKgIGVsc2UKPiAK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiAKPiArCj4g
Cj4gK8KgwqDCoMKgwqDCoCByZXQgPSBoaWRfcXVlcnlfYXR0cihoYmEsIFVQSVVfUVVFUllfT1BD
T0RFX1dSSVRFX0FUVFIsCj4gCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIFFVRVJZX0FUVFJfSUROX0hJRF9ERUZSQUdfT1BFUkFUSU9OLCAmbW9kZSk7Cj4g
Cj4gKwo+IAo+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIHJldCA8IDAgPyByZXQgOiBjb3VudDsKPiAK
PiArfQo+IAo+IAo+IAo+IAo+IAo+IFRoYW5rcwo+IAo+IEh1YW4KPiAKCkhpIEh1YW4sCgpsb29r
cyBnb29kIHRvIG1lLgoKVGhhbmtzClBldGVyCgo=
