Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C782C158F;
	Thu, 13 Nov 2025 10:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028531; cv=fail; b=h2PN4eovntOpJrU2bCKd4+VoV7ihWwTxQbXPoj9RVy77GEGsruGXmVkljDEbGuYpjX9fNZMBLHu9gXROhNNK6zgS0/EjSACbF6cSqz6intcBmIeK+JwrVWQcbngh7U0GJJv46T8Q5PVX+vRilEwKIArGRLQeCwLTAOhLXedH/sM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028531; c=relaxed/simple;
	bh=H8AKbM6orO6e6kwlZmeE3hjIkLFcukQNGSQ2gZwideg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QWr+7W2NHLILPmGZloz/+DC64kd30LBoBMe+NW/seX3fiS1CYB4UR/mX51vQQb7KltOhFGzaoOaC9fP2WlcJvym0iPf+rO5N0rkhMdrFiGfdR/8XQzfP2HuA74RuyJGw/QwREUld0/duWhOqaumyBrEQ7W8CwFBsZPWmv0rSLU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DEZJldjd; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ojJVR40U; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DEZJldjd";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ojJVR40U"
X-UUID: ba44f76ac07811f0b33aeb1e7f16c2b6-20251113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=H8AKbM6orO6e6kwlZmeE3hjIkLFcukQNGSQ2gZwideg=;
	b=DEZJldjd1fKr7vUTg//djc6LbVGBOEK5A8hBgM0ypmR/1gcZgKNHcACGCjxOYqLb1uwx87y5Mke0K3CXLVNDYLL539ScNBtjgxi53VWVHi7fFiYl0GcABli1YgFQl1n2SNL2Mex565O/f5gxdrhMmpl2RfNp3ib5VtMyPOucGn4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:63782fb2-e0ad-4277-bc80-28d80d85efe6,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:1c2adb57-17e4-43d2-bf73-55337eed999a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ba44f76ac07811f0b33aeb1e7f16c2b6-20251113
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 189822044; Thu, 13 Nov 2025 18:08:40 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 13 Nov 2025 18:08:38 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Thu, 13 Nov 2025 18:08:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XPtowUupsGJO+0MYg45lQKtLy+xxWQ8vdymtYwtHJDG0lZ11DRtg1nj/IEGW4jK4gq2Y8pFq/oMHkGwUhk17jJrSGP1tLhXC5xqKHC8qFVwABi6FiI9yb/rc2k3cgBToW7U8rOFFq3AuINSXoJrsxKFSrJwjIb8QeZdOG96DaDhLSJFrdnKQLfGr7IlnFtsAG7JfATxFmaTFzNEyoD8osfSTgtxB0Laiz8l9gAGtiOLLNOE8DNvh90xFkSZC3SbA3weU1EptwUaaBckdpQE8XDwMJ51sgF5ZBCDSYA9dDg9nkI9VSNPBTROaIqss2rNIKoFv7D4qKiM1/moYr537kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8AKbM6orO6e6kwlZmeE3hjIkLFcukQNGSQ2gZwideg=;
 b=v0cvgk6ym6g1oYwCKH0F4NgK/F0/Cn0e+CACFhZEzlkUW9317s9kmhGyiHaxp4CxmsRrhjSB5V52EVtUlPkL2kK8OHeFUBGl6kK3k3Yv2QinT6kwmQSnsNq7QwWAPZ5hioAvNxutdQ4TxJ+a5/0EQxhm2Qr1OKjGraQogvfhZWEub1QnuNX/CJPtqlr0BHNy3oxWnd2p9lelMGi3hjWJO09CbVu9Ao9/xDwqfxOzR2T6xVj+LR94Rb++QK1d6kYOVL0oOnl0hjpbDv8LN52AoHGny7n4CviojQvt3cJX/W8NJBzrWSu9B5IwbWlJBe6WWEPOPbo2AY3toKQgaLXqVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8AKbM6orO6e6kwlZmeE3hjIkLFcukQNGSQ2gZwideg=;
 b=ojJVR40UfYK2h1NaX3Q09YyhUjAxJv1B96Iyrjf928cibpO/0FtGltYljq0HdUtqDUajruDTp1J2D87tonpaaVnFbX1Nrcf9tORNv0n1sIhT9e+TgGCtDTQqw7RJOrpZptgHnEv+CPc4PX7KtcUx4PPsSobdcLjaxKIJZ0ojdWM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6452.apcprd03.prod.outlook.com (2603:1096:400:1bf::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 10:08:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 10:08:36 +0000
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
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAIAAfuaAgACtbwCAAOjIgIABIdaA
Date: Thu, 13 Nov 2025 10:08:36 +0000
Message-ID: <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
	 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
In-Reply-To: <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6452:EE_
x-ms-office365-filtering-correlation-id: 078b5cbe-5ffd-4da6-a87a-08de229c9c2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UTI0VDg5Z0VWQmVabHJQcUw3UDRidDRlY2VIcEVNVXhjUkZTYmpnRHFaK3p3?=
 =?utf-8?B?dzJUemc2RlVWM2lwVjFSTTNSeWdJZGJNTDlDdkQzUzJwRG8rUnVYRE5PNnpv?=
 =?utf-8?B?T0UwR0ppM2xuK0pEMXhmVzBieC9ZYS9KaDZ6d2xydEh4a09IdlR4bFdUZTc4?=
 =?utf-8?B?SllJdkRBRGlXaTNXS0FPc2VrR2NuZEh4SlVhdHVXMUh6c2JBdmQyT1VRYUNp?=
 =?utf-8?B?ODdvaWloR1gyQkdYcURaM2RESStZUFAybkhacmtvdW4yUGNVUGErYXpzME9w?=
 =?utf-8?B?NEU0dFI4VGVqbGF3MURRcTJnbFNkYVJ5UUpaYzRQV0oySU9mZ1BuSmc2ei9U?=
 =?utf-8?B?aUJwOHd2bXBIZjRrd25ZYnpUSWlmY3JVV3o4WU9GQ1c1ODhsblV3c1ZnVkIv?=
 =?utf-8?B?K1F0N3ZuWDUzcEVlSEhGZjNlcHp4UlJnekdjR2VTZjdmcHBnU3hTQWRpOVRx?=
 =?utf-8?B?ZDdzdlIvUEQyRWRQTjNyNEpUb3A2SHhzU24zYUI0aXVEcTJVOG5EbzJZZWJD?=
 =?utf-8?B?SCtjRU5ZSXAvQmNCeCtjVHNuVFZDYWQ1UmYvR0VKZ1NUSnJhL2Q2WDZ1dDNk?=
 =?utf-8?B?MWNqMWJCWVNseCtaVCtqWWMySWtYai9hUVArSDU5S0IxWkFaTXdNOVUreElr?=
 =?utf-8?B?SExWK1FSbTdjNlRxMWZFNS9obmNFK2Vua3pPY0pheXJDemxRYUVtekthbk12?=
 =?utf-8?B?QSs5S1JLK1ZsNUNHZkdobEZCUXdGOWgxU3ZJa2V3V2lxOExEdWdzdE1GbURV?=
 =?utf-8?B?cndwb3JOTDFFR1I0encwZ0ZHN0t0amxoVDVVNVFuc2prVWRLaUp4Y1UrMU1M?=
 =?utf-8?B?QVN5TlN0S1hIWXNmUnFDdzh2T0pvdkIvcmh1UmlIbjNydVZSb1c5cEdkdm41?=
 =?utf-8?B?dEZ6cjNEWkt5V1lWbVBydytZM1N4blltQStsbno1dFFUamNuWFF4OGl5Nis5?=
 =?utf-8?B?eHhObVJ0YUtsYmErSEV2NHdBSTJwNzROSWVGNVp1QXpNSTc2bERqRi9FWWc4?=
 =?utf-8?B?ajdwR2s0Sy8xMmhIenFKY3l0RG1YanVyVEQ4R0V5VzhLMUFHNS9wcUF1MDE1?=
 =?utf-8?B?K1loeUlwemx3bk1BRlhnY1lRZ1F5VWNORXJuRWkwRE94REVMaDBGaE1NdVFz?=
 =?utf-8?B?OFIyRm1jaXF0aVd0Qlkza0ZXalVXRURYU3A2MWp1Sm9PUkZvb3RaTDNaMWo2?=
 =?utf-8?B?NzVWYldVZG91N0s1bnppSzdrcU5WU3hQVlZIMHNQOWdwcFVBRDAvMWFneVlv?=
 =?utf-8?B?cEdwTjBYYnFqSWlaVVBDU0lLTlBmd1k2ZmljUFRNL3NOM01JaS9XbkVUa3Za?=
 =?utf-8?B?bUFMNEdieHg2eFhuWWNrQjJCZGFxdDhEZ251RnluZElia205WGF6NFR2bnIw?=
 =?utf-8?B?eHI4VDUwTlViVThma25Jc3RkK3QvYjRxTHlkT0dYQWxWS1hxdDlIZnF4UHdn?=
 =?utf-8?B?SjJzdDVLMUEyZHNQN1h0MHJrRVFERVhDYmpER1FXV2FHR0o1bEY2RGxSYk5L?=
 =?utf-8?B?am84RlZBVitnNVdCWjdmYkN2S3hFNWprVlRhQXBCT01uVGNrMVRmaUtPT0xy?=
 =?utf-8?B?M25Vd2VXc2dQQTRWQnVma0M3aVl5RC9GeUR0d1hFenQ0QXBBSTlXWXhwdm9h?=
 =?utf-8?B?QmJWL0VraEFFK1B4ckloQ0ZTa3pqczExdHRmNTErblZQelR5aXhkNU5NQVYx?=
 =?utf-8?B?MUNBNHRxa3Q0QktRNVByZEVSZ1lmeThJcjR2dFRtVXAzc3BybTZvbTJyVFFx?=
 =?utf-8?B?eU1pWXJESEFkVlNDRjl6dGRGQnVJOTBHbjlGQTkrbzhmWEpTblFTU2RVM21Q?=
 =?utf-8?B?eHhDV0M5UEpSNnBnN3M4cGxBdFpJWHBkcXI3ME1pOHFXR0lXTGQwRXRhRHI5?=
 =?utf-8?B?ZlpxVHVEL0ZPcjBBY1VSREF2TUNLOHJmVmlrczVpWEU5TndsV1JuRXRZQnhM?=
 =?utf-8?B?SjhHaFZWcE8zM091RG1kQnE2Y1ZuMjNqRlVmZnZXemhoUWZIcVRRbUtmcTZa?=
 =?utf-8?B?RXNzOHJUL0tsRUx0aCtNN3V2cjJMVG5mWmtBYzI1WHBCRUlITmZ3dnlFR3FN?=
 =?utf-8?B?R0FualdvbGx0ZlZyVmtRWHZQcFpOYmYwL1NPdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnVKdHlzTlRpTmJlSUtXYUIvWkNuVDVJazNOZWpiWjNqU3Q1cGtLcTFUeG5G?=
 =?utf-8?B?QnlhQncxTEhOSDRYV1ovaUpMTlg1M0F1L1F5WFpQY3hWZTZBZFV0NVBUSkVp?=
 =?utf-8?B?MGZLRmh4VG9NdnJEaGtxOXRJYWwrVFlna3lKRjV6cUVWT2FGaVg3L3VCY2dI?=
 =?utf-8?B?MldZUVNBeG10T1N6bkJRaTVaWTZ0RkFzQTF4UGZYTkRNdXBPVnRFVWdKaG5K?=
 =?utf-8?B?ekNNSGNYSDI1RHVqM0dHeUlteUoxbWJDTFczeVY1VGVQenhaOVEwcnpIQmQ0?=
 =?utf-8?B?MWlqTzhBVERTTGJSVFhCWnpoT3pLZ1daVFhNM2hnZTMycFNhTDMybno1eFJn?=
 =?utf-8?B?UDRFNk5NRnhpaEtmTVhNZnFaTzBCVDJCNGcrR2pSMk8zY05ZNElZSTlPUVpv?=
 =?utf-8?B?QXRKR2dzSm5OVGtpUzczMVB3UzhuVUV4eVZmUC83dVNJWkJtSHd6N3djMk5n?=
 =?utf-8?B?SXR6Q3VjamJ4eWM4LzV5TVFNcHU4TUVEVkVZd2VoZ0ZLNmE1d0w5dzAzaWl4?=
 =?utf-8?B?VVgrT0Q2SFhKN1FNV0llbVdlMnJJOW5hUnp6VEVyc085SEtPTnE3cGYxZ2l3?=
 =?utf-8?B?b282ZzFhaUE1cGsrb0toWnZSS2NGR3FYNVhCYU5jWENzbWdaUWNOMXBHUWpp?=
 =?utf-8?B?WWpKMDVpYjBhQUdVdnRrWHp6YlFrZm5xSUhYY1dQN0NDYjdXLzJTd29HbnRi?=
 =?utf-8?B?Z2REeTh4QUY2eWYxQ1lWOXBjd2lEbEpnTW1tU1h1OEtSdVVxSUg3VjdqUWNu?=
 =?utf-8?B?SmlXVnlHVDB4NU5yanpaSjJGSlgzRFhpZDNXZEpnL0M1TVNkTUI4SEVjSkU4?=
 =?utf-8?B?WVVsV3BqZFZMRnNFWUtEQ0s3cm50SWJjS0tzcEY3bXM4ZXVDTnc3MVZLdERC?=
 =?utf-8?B?WklJbkxxSEpmZ2FpYWlueU05ODl4akpwckFMM3g2a1ZzZDZSVFpxRXk4TjRp?=
 =?utf-8?B?NFo2MU5udFFUNTV5aGRLNm1JWjVML1Q5R003c0plSzRreFFGQ3MrclpFWUs5?=
 =?utf-8?B?bktPVFdicGlMOWNDdm1xd2NybTN5NjBQczJEWityazFOdS9jMWNveFd5em1k?=
 =?utf-8?B?cUF6MTRnRzZpdVdaOTAzU2wvY1VuM2NQL1EvZjNpTE5DYmNSOEY2UFZyb1kz?=
 =?utf-8?B?emQrK3dROE1UVGN2RUQxYkFHbkgyWklNRkc1S3daQndZNUtsbFpWMWo3REY5?=
 =?utf-8?B?LzJybHdEM3gzdVByenhRZFJhRUxNc1JRYW9UTVRqdFZNUS8zMUtibnhhSG5z?=
 =?utf-8?B?czZnRFZUaWJOK1lncGEvb2h5b1U1aVk2c0RkK1BnN2h5VVdpZGhvcmFOUXFh?=
 =?utf-8?B?clhTMVkzUy9hbllhdkE2M2xOcnJZbFhDeUdWR051KzAvVnpMTjZuTGdjM2lp?=
 =?utf-8?B?bllyYjl4RytGcWUzQnRWTVU0TUxWWTNRdzJIN1J1alVPQUxJNzZjVFgzMlZY?=
 =?utf-8?B?dVVDVVV6VHZ4SCtHM1BPRkJGSmpPakkxdnNDMFdQck9SKzJYU0lRSHFaU1JM?=
 =?utf-8?B?ZXR3VWdzNGlTb3p4QS9NVFNEM3M1NUM3NzJrMW9HaXE4UFpnK1BhZ0xES2px?=
 =?utf-8?B?c1JRVXZKaUc2WHNTZEZWcHI1NDJEUG1LaHczZUJoWk9kd3kzOXBzYXJZSUdF?=
 =?utf-8?B?bzlDS2p5RVZIMWlnbEJrWUY4UUFmVHl3b1BUK1JNVlBQTEpTd1hNU2hJTlVm?=
 =?utf-8?B?aEthUm8yV3lDd2VvUWhiWjhFSXB1OVRwcDRadTNOVTZ2MTJlc2s3N0JNY1Bq?=
 =?utf-8?B?ZkU1RGlXbFNGK0FWNC9pemFhOEtYbHJ4LzVWSnhRY050ZjJwNDNmQTJtZUVp?=
 =?utf-8?B?OWkxRlNRUHA1TXFsUHp5cTBmWWxwejNWLyttU3RCQUlxeFYzRHhHTkZKVDNC?=
 =?utf-8?B?VlVTajUrQ0ZDRDkrNm1PZEFHaGpSZ3ZCaEFmNnE0d1I5RjZza3J4YW9GdnVR?=
 =?utf-8?B?N0pSeU9HZlp5TkZqMVlwRmpsSGM5Zkd0MTU2L20vV005MWk5Mko4bGhxTHBm?=
 =?utf-8?B?TmpaZ2lGY1pYQlBqRjZoN2YyTWxWVnpNSS9Sa09DUjNVYS95dUJSTEJjdHNY?=
 =?utf-8?B?aEhUdjdpNlFvZi9rSE40M1dPMkNTOUk4QjhOQ3YzcitXQVlaUDJaTFJEZnpF?=
 =?utf-8?B?aGVRUTkwODJDU1FGMlRpNmV1M0FxMnY4QXFSU3JqcVVmMEdSSVI3L1VIekd5?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C1D01CEAA05AB42BEC4F6C6F6F8847C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078b5cbe-5ffd-4da6-a87a-08de229c9c2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 10:08:36.3513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z3bDTxRFQB6ost8qEsqqJjdcYTanECQjPregF6pjw/oHbLxuca3fMWkF9SvoAQd3zaKJ2q/Cnb6Lz3UxsNKDwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6452

T24gV2VkLCAyMDI1LTExLTEyIGF0IDA4OjUxIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBDYW4ndCB3ZSBpbmNyZWFzZSB0aGUgZGVmYXVsdCB0aW1lb3V0IChUTV9DTURfVElN
RU9VVCk/IEluY3JlYXNpbmcNCj4gdGhlDQo+IGRlZmF1bHQgdGltZW91dCBzaG91bGRuJ3QgYWZm
ZWN0IGFueSBjb25maWd1cmF0aW9uIG5lZ2F0aXZlbHksIGlzbid0DQo+IGl0Pw0KPiANCg0KSGkg
QmFydCwNCg0KSW4gdGhlIHdvcnN0LWNhc2Ugc2NlbmFyaW8gKHdoZW4gdGhlIGRldmljZSBpcyBz
dHVjayksIGl0IA0KbWF5IHRha2VzIDEuMSBzZWNvbmRzIHRvIGFib3J0IGEgc2luZ2xlIHRhc2su
IFdoZW4gdGhlIHF1ZXVlIGlzIA0KZnVsbCAoNjQpLCB0aGVyZSB3aWxsIGJlIG5vdGljZWFibGUg
bGFnLiBBYm9ydGluZyBhbGwgDQp0YXNrcyBjYW4gdGFrZSBvdmVyIGEgbWludXRlLCB3aGljaCBp
cyB1bmFjY2VwdGFibGUgcmVnYXJkbGVzcyANCm9mIHdoZXRoZXIgVE1fQ01EX1RJTUVPVVQgaXMg
aW5jcmVhc2VkIG9yIG5vdC4gVW5kZXIgbm9ybWFsIA0KY29uZGl0aW9ucywgaXTigJlzIHZlcnkg
dW5saWtlbHkgdG8gZXhjZWVkIDEwMG1zLiBTbyBJIHRoaW5rIA0KZGlyZWN0bHkgbW9kaWZ5aW5n
IFRNX0NNRF9USU1FT1VUIGlzIGFsc28gYWNjZXB0YWJsZSwgDQpidXQgSSBzdWdnZXN0IGtlZXBp
bmcgaXQgd2l0aGluIDUwMG1zLg0KDQpIb3dldmVyLCB0aGUgb3B0aW1hbCBzb2x1dGlvbiBpcyBm
b3IgdGhlIHZlbmRvciB0byB1cGRhdGUNCnRoZSBmaXJtd2FyZSwgZW5zdXJpbmcgdGhhdCBUTSBj
b21tYW5kIHByaW9yaXR5IGlzIHNldCANCmFwcHJvcHJpYXRlbHkgdG8gcHJldmVudCBzaXR1YXRp
b25zIHdoZXJlIGl0IGV4Y2VlZHMgMTAwbXMuDQoNClRoYW5rcw0KUGV0ZXINCg0K
