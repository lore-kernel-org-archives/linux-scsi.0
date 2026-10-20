Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=210.61.82.184
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792466124;
	b=ZfnHOO1nizt/FSkuHzgT294tBxmVwiU20Lcva7HuHh60ETs07FiHOMIhY98HnT0nN5Sd
	 x+r5LyUV2HPIVLiGBy2WMo4VOKfTT4FRKAAcCCz/REJ/nrxC1UmppXOcFOU8GInk/YVGh
	 BurShk5SkC28erEJP/35xGipw8Ut3It20U59aAGMVOU9wrN1JJiJuMA913Jst9gS6VpKc
	 PheONZRZQl4AzqauvLC9XzSlHSpDfWs+MFSIA/kSG1t8kbGAQjCcgfwRDJa3nlB5iFOMo
	 C2PoKZxkz26kX5+poxOpC6bxzhs/RaHBHbsNenE8t0dk10oKjUBB7QmTOHtlM2yM2bQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792466124;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-MTK;
	bh=oW0q1cwdecI5V0apyPTwuHVeaawOHQY8/vPIV1WRfqU=;
	b=uZTZGZXs6WCBfOHQJGxB5ZmmIyx+DyShszs6wQhUcnUMff/FIUSGGGIFVbe4+myif0st
	 fqmmo3BDrmGd4M2v2Uf/gvMO0D7qa4LeNyHlq2SFx36LRUkphjZ3AFBxkVQ/Ji2bIHjya
	 dJnHWeY01HuggIRSl1ebOBu1OJYiBvYnJ40dqLptemqeKypj3UuzobzDwmCA18FPSETnA
	 NRry8J40qUBdCVKXVKVwJKdcAGcP6dwNUqe+qAF+9ByGnK8D+5Hbm54aZbBOHKo7luAvx
	 WSo70HriV9SudTGEdTYyNFbNKyXpAvFrmp3D0FN4RAUgLvR0tzMpPLc4NkRvpwbq/dQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=WK2JQa9W;
	dkim=pass header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-mediateko365-onmicrosoft-com header.b=vPafaxog;
	arc=pass header.oldest-pass=0 smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1530606A32A;
	Tue, 20 Oct 2026 03:15:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1530606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=WK2JQa9W;
	dkim=pass (1024-bit key, unprotected) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-mediateko365-onmicrosoft-com header.b=vPafaxog
X-UUID: 77e00c8ecc3411f18dc8c9802ae25ab1-20261020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:Message-ID:Date:Subject:CC:To:From; bh=oW0q1cwdecI5V0apyPTwuHVeaawOHQY8/vPIV1WRfqU=;
	b=WK2JQa9WUIHeQevdpRux4wlAbB047ODA9vfkmYHjT7QwpebXUNsFR7h4eCdRBdft7pcvvsu81sD/3qIM05IGp2KRc2h4l//Po5iIjTuOVmQYrEurKd63IycH7FWiNKUr+AcB0YO2SdnVDFuth8ffzwO7NmDiW45oetwNT73UjRI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:0d953015-2bff-4c6d-9104-a622756d3c76,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:cb654450-e45d-47a9-9410-63bccb6d6432,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 77e00c8ecc3411f18dc8c9802ae25ab1-20261020
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2059636591; Tue, 20 Oct 2026 11:15:14 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 20 Oct 2026 11:15:13 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 20 Oct 2026 11:15:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=unsbQ3IfUo4nAZqNm18teIX/2HqJtiGWeuSpf15LP7N7Fztg7lwlS+I3iWptppY+/9kIgNYbf4GGJusQKH/cfrZq7sPr8nk/p+OX8zL8hwBr+1P4DZOdgPnIqHHBNT16elG+hPgd4Ilj6Ow8NYxYrLbrBcUsZJezvR+2wpPOnpxKEpdbsFT1kShpxkWxYRZ9isuRyh3o3dZ8b3pWrvfS/Wi23szlraxNYQeFkYGVOxGQ9Yqa9aEForVXSnwKVg66HUmVnKK8DLXRf60BszFBlrrvPGNFqIdlK5CV6ELUVSE5f5ikiVKYZRBmEpCBbB4ogldzoIerL5xhv7w/DOx8vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oW0q1cwdecI5V0apyPTwuHVeaawOHQY8/vPIV1WRfqU=;
 b=lB2g+HwNtsqHCHRF7aI8XCjPx158sLJh2ET58QBiJ6JJ6gEUS8rU3AqsHx+z061frUUK/QbuWg22Yy2QUWrpt9RwpeH0eRP5TgDP9ltUheZwcI4cDISge9FMwh2ka1tgovGKrzqHojNsW3GOSc0Q2qAJUIa6MULLfO0ZbjjYrM22kVEON3CdpWRjtIh2lNpvTJOEgGEFzq0ZWvpcrjzkOSvJyfXRzzCiPpH1NoWxl9Vui/Gh6jEwQeGIMMk7LJARGxWciTxewXD7v2AVgvt11HY2AQnY2nHqYH/gBFKWSIe+4J4isNNrDI6NE/OSaUA4LkgXHQg0KFu2f/HMvW3JQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oW0q1cwdecI5V0apyPTwuHVeaawOHQY8/vPIV1WRfqU=;
 b=vPafaxogYWGtL53lJLD0qox/GZULTlVyIq7zh3grJCeth31pJHSaoDVU1Mq7D6vveWE2v1bE3GIN4oYrUk+JegbterRZlSDb9wVkUgyzWNxQCV+jd/SSt2XB6KXufbQzDvK7t8NAJt+JEx/5iIbsr4E5w+kRlI5Lyeb6cGOvO78=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9652.apcprd03.prod.outlook.com (2603:1096:405:398::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 03:15:11 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%5]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 03:15:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@iokpp.de>,
	"Stanley Jhu" <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, Can Guo
	<can.guo@oss.qualcomm.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
Thread-Topic: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
Thread-Index: AQHdYEE25O65lL7vTkS1L0rrg1didg==
Date: Tue, 20 Oct 2026 03:15:10 +0000
Message-ID: 9d93f8cbbd1a17bb4e8ef74c27a23d1ce2a4e895.camel@mediatek.com
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9652:EE_
x-ms-office365-filtering-correlation-id: 88e084ac-19fb-40a2-4db1-08df2e5859d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|38070700021|11063799006|261009223027099003|10067099003|56012099006|18002099003|3023799007|6133799003;
x-microsoft-antispam-message-info: ++tM0TLnfP0V8evWVtN+awDgUUJ6f4VolAWpKCNJtw7NYWRKGSScPqpHISnvHz2FOoE6MKaAfJCEGXFQY3VgFmjUSEofaIwBqFej4w/APN/mngf3HB3bLIwXQ5sNBtoGe+JkL3zi5hwz/CxAMlGunG4AUuCt4rOWHElfcgWlKFvwSPjl9c5RcHxKH4Vg53nb29i+6XlnpXhBiEiAwXKBZn3GAkTRRmfD14DhdqfJ7Y+pbhPKkBm8nRiYynYzeJbqkbHlBNvLdHayLP3FIEvL6W+HO3W9tJUvGWT2gmnkn3VEFa3FC8Ad8P3pbLDQVE1vaLFxbSEMf31Y3tGExDx3Ka9VLRmvuPqJLwG6qqlJ37u1ILsznNTBgM3dTkr7KsmTpJiBztbL8jCbN0ED/OH8EU9EBbq9hulPeq9fvnaaz2ojGAKX1Y/AXYOgBXSci1iBEXa2Y6a0COgOAu6WzU7WK7S8yfjX+Jo7i5n1toC8EFde4G3x7zXWpnSJlPpo/HcsTTGseO6E772ZuAqKssg7ZeOSQ7aCH3LPs7OMHPXH5rOt1pKnSQ0VSYeokZISd83vsTS/lK9EuyidDyiR+uI93/I0hKo+H/DUbtYy1TMvOgTAieAMg7C9QNavodDrMa3EzHcewmnYOjA/CpnoNkGFK1LBD+UhMcZQ8xgK0ix2fWfM7h+1hfmv+jfeO5SQ2N1a65AmARnYH/kQX+G4Of96Ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(38070700021)(11063799006)(261009223027099003)(10067099003)(56012099006)(18002099003)(3023799007)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFZFYXMrWmxJQ1BrMlV4Z0NpalNqU3hwSDJ2VmZVZ0ZSZm1EVm90REd4M1Ur?=
 =?utf-8?B?b1IzekV6UWJMQ2hoUUFHRXZ6QU9uNjBYQnVrTis5ZFVHUGJERy82Y2JZaXNx?=
 =?utf-8?B?OHJIa1BkWWZqb0FxOVp6NEY5emo5V3FyNmhqSmw0WkxUN1p0K2FnSlV5ejVy?=
 =?utf-8?B?MDhNRW8rWnZlaU9hTXFBa2prdnJZU250UGlWWVFwRk1xZUlzTXU4eGdjSDNo?=
 =?utf-8?B?bnNndG1yTXNDYWdPamdwYktJZHVPclhRcG1tOElZd3djdmJodzdqMWY5emZS?=
 =?utf-8?B?UzlYemtrZUhQV2lxSEgwSVF0emxzV1BoS3JoakRmdjNqK1pKcVFpazVaOGl4?=
 =?utf-8?B?NGY4QTJWUmJEbFRJdmk0MGUwR05nejFPRDhwb3hIRUxiSTlMS2wwR08rUTR6?=
 =?utf-8?B?UjdQTU1iQ1RhME5SQW9uR3FYVEx3Z3NFRFViNnV5RUwweWRTMGxGR0hER2VI?=
 =?utf-8?B?ZEN3WENBdkZhVlBHa1pMaG03SkUyb0hDYUc3SFdQbGlwU1pYMnFRSkNVRklF?=
 =?utf-8?B?eW9FTDBXMjUrT2t6QmQzZFdkWVJpdzhrVDZSM05YUFhRaCtFNVI3U2FWZEhB?=
 =?utf-8?B?YzZTZmxXdG5DWlphQmdlQkNuK29Zc2czYm8yR014S3VMaFhTUzhFU3dxMXd0?=
 =?utf-8?B?WFB6WWJTSlFQVzBuRng0V1hvb1JZT2xVcnQ3UjZtK3d5cndYMVYrb0tRNzNV?=
 =?utf-8?B?VERoVFpIcFA2aE5rWVJDcUhKSlNZc3E4dWdPWDRRb2FCUHZyOWVrNGtSSk5M?=
 =?utf-8?B?d0R1bWpRaXZqay9KbTV1S0YwNUV0b1orYjdUV2NGbCtGWWRHanh2bGdWdkho?=
 =?utf-8?B?eUtwNnN6ODlMSWhQcG1tZ2lVVmpRY1ZUSGh0Q0dFN3FFc0pqY3M2Z1psMC9G?=
 =?utf-8?B?SWk1bEErVUt4SnJnWGFTWjdKcUpGU3Vpa3lWOXhackIwOFhiQ2JzY085OXZL?=
 =?utf-8?B?NDlxV3pTOVBVb2ZkbC9vZjNOTnYwYkMzMTYvRzNqYXYxeHNDdmM1eTl3SW4x?=
 =?utf-8?B?a1dEakNtQTliRHBQUWdZSXNQU2F2WmRlbkw2TWh6RFFwQlNYcGZIclVDMzMx?=
 =?utf-8?B?ZjZLL0pEQWtRZU1HMUg0K1RMcmtqYmxyOXdEMmdzZ2dtNFN6VVROZGVqS01R?=
 =?utf-8?B?clRlT3Q4Qjg4c2Z1R0NiNG1CWVJMdUN5WUFkUmh6SlRycDJ6R2kvd3J3OUNr?=
 =?utf-8?B?eE5YUVg4Zmo3Y3hEMXZqNnNnMUxiazdYeDhyWGVuNlNoV3p4U0ttRHcvZzlu?=
 =?utf-8?B?dnVrY0VMc1dvZU1CYUxtWWRlR2lOa3cxMWhrSkduTjZzRmp4QmxMWGMycnQ1?=
 =?utf-8?B?QWFxeEpvWGRQZmtucDBnZUw4YVRscDNjbTYrNzlNcXBEaG5ReUNvTzZrQTRL?=
 =?utf-8?B?bGFLMTFGQXZ5SmRmZG4yaG1YZExKc25VZXNjbHBmSTQ4Y2haQk1TK3B3ekY5?=
 =?utf-8?B?ZkNWWXRweGFxSzFCRTRNS2VTVFBtTTE3eUgxRGFSQnRTTHFRaUY4elhYMXFL?=
 =?utf-8?B?SG9ydHBaZ2NkS2dlYnBnMC9iUGk4S0xBR1p0SllRUDRjeFZmbjFBNldiZzBt?=
 =?utf-8?B?cHlXajMreWlBT2R0c2E0S09RWk5VOG9zU3JqQUpoQ0l0dXNGS2JZcmRpM3Js?=
 =?utf-8?B?cnRSNHdoUDQrbWYzRXRIbSt3OVBvYmVPb3hkNTUybVVJUENJV3NuelZQWXZS?=
 =?utf-8?B?V2dxRHpuWWxZSkZFdEw4eUZsTnhWbjRkL0t3YkRvZk8zL2l4dVpyMWxEckE0?=
 =?utf-8?B?cXpSTzg5Yk11TWxvVTFsUGRMNUtLcnRtSnRJUFFrVlNmd0Y3UFlZcG84TnU0?=
 =?utf-8?B?QVdSSEthMlhhNFJZamViaENlWHU2TEh1S0xOaExGQTF2NHhWTUViWjk0azQz?=
 =?utf-8?B?VmVIRUpNMlNwTDlUVzhUeDJlOE85WHBkTytkQmczTVZHUlVZYXpBWWZXQUVV?=
 =?utf-8?B?Z0FVVDUrZjhKdHdLQ2lVYWJnKyt0WklYcjVzc0U5VmlTNno4VFB1VkhiRHJ4?=
 =?utf-8?B?d1JnUEowMHRiU0ZISjZGOHA3TXRYQkJIdk5DcGVzY2hkSit4djBodEYxUGpn?=
 =?utf-8?B?MTc2N2JhODNUL053dVRjRGJoVUJhVElXaWlIRVJISnBZZndHRWU5a0JYL05v?=
 =?utf-8?B?RHAzWjJaVDFzcnBsL3AyM0JmSHV2Tkx5cGwxQVdGQjVXN1VSaUd5MXE4U1NW?=
 =?utf-8?B?YUxzSUFhSWtUdWJaYTROV3FuVFpzNnFTb0NINXM3ZWg1WFFDVTdSd28zQnhy?=
 =?utf-8?B?Z1NaQWZZK3B3ZlNZUWhIaFcxQTE1SGlKZ2Y0S2hqVnpvN0pQQUk3V0haQ0Ix?=
 =?utf-8?B?b2hkNnlyeUlvQzZvRmZ4T2JsUTlTY1NYU0tvcWxWVzZOeG1SbTZQUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: mcoVC06cia/9xbgHqnZ6ofVfqDDisa2vxzU2CWB8DMeERHKW4l0p2D/d/vxsN4E7664s6dAcnqMgurtHyDTrn/CkTKphQ1CbW5VtmANoJll9fmqqO4Piq1tzRac+ersa3Qvy63gW4KDNpU5HxBm5WYHismehSCTtm/6BIvoUMDC06ZEChiSMFmrbhxBJ9lWqwFh1WQWdJveUZd7HAEUzm59JWTpdQcwfl/X0rcCoKZ0KACKCe8Po7c1KddnIQ6yI2UomJpg4jLx1Nrr5/k7ao6IAlat98Av4H/BzorvQUAz50IDnKNx48xxzBvnyfLTWWQR5elj4/k5MX4UZPWJAjA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e084ac-19fb-40a2-4db1-08df2e5859d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2026 03:15:10.8935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OMCir+sattNFtY1hhk1pD2/U9vBB6hZwenHndcJbEbbnfB5h8qSNle/O0/4KIoi8OXR2ocq0JoDYHWcL2/PGXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9652
X-MTK: N

T24gTW9uLCAyMDI2LTEwLTE5IGF0IDEzOjQzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gSGkgQmVhbiwKPiAKPiBUaGVyZSBhcmUgdHdvIHByb2JsZW1zIHdpdGggY2FsbGluZyB1ZnNo
Y2RfY29tcGxfb25lX2NxZSgpIGZyb20KPiB1ZnNoY2RfYWJvcnQoKToKPiAqIHVmc2hjZF9jb21w
bF9vbmVfY3FlKCkgbXVzdCBvbmx5IGJlIGNhbGxlZCBmb3IgU0NTSSBjb21tYW5kcyB3aGlsZQo+
IMKgwqAgJ3RhZycgbWF5IHJlZmVyIHRvIGEgZGV2aWNlIG1hbmFnZW1lbnQgY29tbWFuZC4KPiAq
IFNDU0kgY29tbWFuZHMgbXVzdCBub3QgYmUgZnJlZWQgYnkgYSBTQ1NJIGFib3J0IGhhbmRsZXIu
IE90aGVyd2lzZQo+IMKgwqAgYSB1c2UtYWZ0ZXItZnJlZSBtYXkgYmUgdHJpZ2dlcmVkIGluIHNj
bWRfZWhfYWJvcnRfaGFuZGxlcigpIHdoZW4KPiBpdAo+IMKgwqAgdHJpZXMgdG8gY2FsbCBzY3Np
X3F1ZXVlX2luc2VydCgpIG9yIHNjc2lfZmluaXNoX2NvbW1hbmQoKS4KPiAKPiBCYXJ0LgoKSGkg
QmFydCwKClNvLCBzaG91bGQgd2UgcmVtb3ZlIHRoZSBjYWxsIHRvIF9fdWZzaGNkX3RyYW5zZmVy
X3JlcV9jb21wbCBmcm9tIAp1ZnNoY2RfYWJvcnQsIHdoaWNoIHdhcyBhZGRlZCBieSBjb21taXTi
gK8KNjQxODA3NDI2MDVmICjigJxzY3NpOiB1ZnM6IEZpeCB0aGUgU0NTSSBhYm9ydCBoYW5kbGVy
4oCdKT8KClRoYW5rcy4KUGV0ZXIKCg==
