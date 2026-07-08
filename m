Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E4C420896;
	Wed,  8 Jul 2026 03:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783482392; cv=fail; b=AT8RDzZaRPu3IdWPCnLXnrVS+j0vLdPKqBb9gnPyIf0ZSlokukDm5ksQZgJG/+CugFbEVl7nW7+5wjurqwbHKdnDRN9ozFX+8ADXrNUFNnqFmnjxdDKqTn83atNCVVU1zWvuUg7AjcX5MbfwmwaeyfRbApQEkaSrkiHoUUeNgBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783482392; c=relaxed/simple;
	bh=VdfSArLpFYrNaj+8rLIb7F26z0jTyBYEPkbBqfNHCiA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a3fu+sQXbtO4nW2K3+deDGaZBG/R50lkmAn28IVwDczRUvfAyZ50xXm2ts/kQyFwEKIJJI0XuPxTMpkNJD2lH2y8egibYpzxQe1+DxHOPAqSASLnPq/FJvVSAT4+loKOaU1iAR9p2EW4xwdvsENpA3JqqTmgL8+Y7BIbBq5zMYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ofl2IgPY; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=KYjYDWC4; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ofl2IgPY";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="KYjYDWC4"
X-UUID: 96609e647a7f11f1b1788b6acf885367-20260708
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=VdfSArLpFYrNaj+8rLIb7F26z0jTyBYEPkbBqfNHCiA=;
	b=ofl2IgPYAc2viSqGylLd2LB5QYhtFL5TgKf8d+iKHzNOrgt9ciSPKv5Ft5eoAtvOmPaPfLsnrCLpGY14Sq3wuIBlkX3AMllK97uQJyIAgYJ+7Q3GK15s+VV/hPYHt5bUvw+i8HveLz8AiZtTkTJ6hq20RM7k99fRnVZbEWv9t2E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:ff16cf75-a7f1-4e3d-997e-879c2bd57002,IP:0,U
	RL:0,TC:0,Content:13,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:13
X-CID-META: VersionHash:d497b38,CLOUDID:ff031d8e-1010-4359-aee5-9ea266a8cac1,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:3|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 96609e647a7f11f1b1788b6acf885367-20260708
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1702257301; Wed, 08 Jul 2026 11:46:22 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 8 Jul 2026 11:46:22 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 8 Jul 2026 11:46:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IR7P0N5v9OQIcXnz9HWs8qfPSI9UhzBi2Ap9Q61kp+Z4isP2KE/C+hsbo3jiUssZ2ZYYrHr5xr6DF+g4XEbCg7XqOGRWXg5ZqYWScaxR2YXF0g6F/z1SzWYoIOnCtOntrFrbRhGM9fZIdYa3OMbPQwzz/4s0j8V3D68WX8Zh61J7MO/HpDLquJEVBWByaYf1w0pkNg3RC2HR7bXZ9Y8rcXs2PwrykH5v8U1KyFGt9GLF9fTGN1LomccK1DKHbWyWfEeGaCFm+QSUXIpdCgcYCz/ys9y8KdxBgVYjyTs0gYo4YuvRr6MEh7dDEqpAABaz8GeHHKulTPv9Vjp/Pj050Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdfSArLpFYrNaj+8rLIb7F26z0jTyBYEPkbBqfNHCiA=;
 b=HmCLT4lUAAgHffSr6dKgY2eOk/B+frfOlxUtcLyHN4zEOmAPA6Co8Tno0IlOm0rOuTxZTjDIuBKqn42+L/wQW4J8MfTakPycNefmGMy5nDssbzhRO3FdI8msTwRZKQylRnhjEC3FNCcNMswjwPapoMmy4F3hWaJNey8CO02l+H7fh9afYMGrJi3hfhyU78tEJxyJVIm6laynXV3KjnWsvTApcCPbZDYuygiuiN5+/GSYlTx0l9fnr4YgvSLNEqP4CqJzKoralIxjJmnRhp/f0Rmq0SUZnwQZN1c0O4rg/egDZnNjR4BER8CBitJLIJrQc9FkbEsE915AV5fVZT8AhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VdfSArLpFYrNaj+8rLIb7F26z0jTyBYEPkbBqfNHCiA=;
 b=KYjYDWC4IKl1bNeUBSYfwZLsEwffUVB0iV5zj+qENQuRjfQm4IcA8u0YTDjl/j2GebTWlnPTx6xlVKNAGy5ERlaA7SbBIK/RamBWor+RTRYYp84rPxSVXsZ/1zIAA7i1pJ4Hki/0XgWf8YBodELA/Jq4WqQ3zmGAyCF8RjzXCeI=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 OSNPR03MB10397.apcprd03.prod.outlook.com (2603:1096:604:480::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Wed, 8 Jul
 2026 03:46:19 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6%6]) with mapi id 15.21.0181.012; Wed, 8 Jul 2026
 03:46:19 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Subject: Re: [PATCH v3 0/3] ufs: Add callback for vendor-specific RTT
 capability
Thread-Topic: [PATCH v3 0/3] ufs: Add callback for vendor-specific RTT
 capability
Thread-Index: AQHc/Iv9ExxycAm0nkGXM20PmE0YubZjH36A
Date: Wed, 8 Jul 2026 03:46:19 +0000
Message-ID: <9d28fc1645b621f52ec8fd00456b1432b9bf157d.camel@mediatek.com>
References: <20260615055802.105479-1-ed.tsai@mediatek.com>
In-Reply-To: <20260615055802.105479-1-ed.tsai@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|OSNPR03MB10397:EE_
x-ms-office365-filtering-correlation-id: 3977fb6f-e1db-4274-51e8-08dedca37876
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|56012099006|11063799006|38070700021|18002099003|22082099003;
x-microsoft-antispam-message-info: 4bjcBKCo0Z05g684Cp0TWzP+iyTW+D6eU2NSz07jMQYJ1Eh9Ab5YLMcNvuvmj06MLI2M/NCTjk43aJcgF8adiqHYBpRI4rNCEc1HYUtkA8D7ZepTeqyhEf2Mg4wF4YpjY/+0gtSl3Fg8M5+CFF1VB0+rofmpwSn+MvfCC2fPLTBfOkzMBVEUpkrdZ4WdJVWDPDwFZmTTL2dR37hoyGQz/FWAkhDSJX/bDJ+I9vXxzb4+NsODlBY0UMzuwbE7PFEZy3JueqOpMYWwqJg6Rh/k1nKGNiJi/dKAGfSQXBX3y6gu/LBXNkAmnd6JONNKhMZy0pdhhicRXhPdcUbhiKC0BNWSlOYCGCvpcwFZPhZm7zNZgAYalCRMw9B1ztY5bTABR89/4Phn/dDzpDdbEFxtbsASM3ffPoIx/x0ljFBI4DjgydNiu31MY14NANgeOY0ulSZPA69xgh6xQ11auKCe05WQhOMJwTJmg0nN/Zn3Waqz9FchZB1wScD0rUYms+4rDIBMbqe5t5IHWkYVwXfnDVMlV5jNK3Qa2Lh6wDxd2EPijUOZJpj9HRwFPXvXmYMdNhOs2SlXdh3A5NF7lb+16EtCvnyjqAgiDA222ZZDoqy8jBL+Ow4B8JQBhQ6kJ96AMtj8mF6sQLCL7Orjisx3a6t8al5SNSO7T6i37huwFbEBBsTbJFk2s+J1S0r/IbpgJkIEjb3l5ZWJlSoCBO45ErRHobmn9IlR8Lao6/eHxts=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(56012099006)(11063799006)(38070700021)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEYrQ1NiSTJzb20yNmhaQlBNd2xPazVlanRvOW1qUkprNitDRWI5cUsxR1Nv?=
 =?utf-8?B?OGJvOHZYWkY1TW5ReDBMVmVjeXAwYVRoL0NSU0IzNDd2UnVDSkNWTENFczJa?=
 =?utf-8?B?WlQxK2Ntbzlaa2lMN0NHZkRqTFgrNmRQUnNyRUlRWmJTdjIxaXVGUytzUkVS?=
 =?utf-8?B?U1czTWp6cGYrMG9LTjZVajZocVU3a2FSVmFxRXVTY1BCRHdYcGpVdS96Q2s3?=
 =?utf-8?B?bTlIdUVGMktRaWZ4UGlDYzFhb3NPWEExY2VMNXpZR2pQODlhMVhkWUMvVDg1?=
 =?utf-8?B?SUt0Z0J2eWdFeTI5djZRSEI4dmhuQTd1dW9MLzIrWVZpNG1PNUllbUxPNVVE?=
 =?utf-8?B?NVlOZEM2dDBERWpraWhoYkc4bkl1S0h4Y3ZMTy85WEZnZjRNYkpBTDFJSG9W?=
 =?utf-8?B?bjdvZkxaQkREcFoxR3YwZUk1WUM1NmRKaTRnUHl5MUVlOVBrSzZRbFBWQkh6?=
 =?utf-8?B?VGFmSExBTzNoOWNkR3FwdHVKYTI5bFg3Y2JiT3ZqV3RsYVdjaWlnUThtbysz?=
 =?utf-8?B?cktOVUJ3S21WR2Z4WFNlY0VXWTEybEM1UG5PK05tc2FyTm1tOFIyNTJCcmVj?=
 =?utf-8?B?Y2N4QVVwcmNZanQrMjVrdWZOUEFtMFR5dmlNME5IM1FOS2FLam1mWWR2blZp?=
 =?utf-8?B?OTdCUEpQazRLK1JjRFZoY0EzaXZKZzVWcWdjelVkRmEyKzROWExxWTJvdWxr?=
 =?utf-8?B?UUVTdHhVRlZUUXI1WGsrWnpOcERKT0txUjdDUURHaVFhM01VVWY1VytQRkVP?=
 =?utf-8?B?RVhnMmN3V0dlMVZGb0FseG5ZaXhoZUpiZnRJWDY1eFFuL2c3NHM5WTB3eXgx?=
 =?utf-8?B?Q2lYTlVkQmdWWkFXSXdOaGUrWElXQXB3QlVVMEdaRSt6OHR1eDRkUE5IMUQx?=
 =?utf-8?B?YlRLcGRiSzVNY0hVRXBWeC9XNGFrK2E3U1VSbGhIaUt3N0pWdDYxcSs2Snp0?=
 =?utf-8?B?R0E3T3lEUTdCbUNsNEQ3UmFmS1NncmVNZzhQOTZPU1FOY09tMzd3R05xbDhs?=
 =?utf-8?B?YWNjUGExRlZjaGR3akN1R2ZBU1MyOU5hMjNNeFhFMERBczhFbFE1MHR6MFUv?=
 =?utf-8?B?VkRMUFdIcVJ3UFJsVWMzY0RyVExmVGRMc1UrbDZkZUYxTUZjcGJnMTVCWkIx?=
 =?utf-8?B?LytMdkk2aEtqMU1aOHlrdlc4akE2SEEreVVrV3NrK2RhQzFNTGhCMlJndjNS?=
 =?utf-8?B?MEdLdFJMZVNqbE9MZFFBWjNjbzNzYmd5ejJhTWxtM0VMZENoN09seEpQTXdo?=
 =?utf-8?B?T2pvVkNKZFoyWVc4SXptYzdNbm53SnFreVgvTGwwYmZzU1oyOG0xQmRSaVoz?=
 =?utf-8?B?N1hwRGFTdkk3aVd5bC9WKzVsaWZadnpLMGhYbWt0enZzL3oxNHNaUVJoTFNx?=
 =?utf-8?B?bXhYNEh4M1lUTmFPc3JGZ0ZIdkJuUHZycTJ4T3pUaVNoendRai8wQlJSeUhD?=
 =?utf-8?B?dlM2cUt2Y2xnZFlzNHVPQnAwamVXNEtqN2JidG9iWE9jZEFQdFlWUE5xdVJ0?=
 =?utf-8?B?SGVqSWRQY2k0dWtPOGxuWlBpem1UY0ZBTmI3bHVkb3g4cWdaeG05MDczbEZ1?=
 =?utf-8?B?M2dkMWlacFhuOGJpdjBvMGZveTk3d2tyTnlxZHVvMFFKbWJ6ekwrdE9hcWhD?=
 =?utf-8?B?Vm5jTVJSV1B1K0doN3NKeEx2UURmUjNzdloyb3Y5Vk84cHBadHBqQ0Z5ZHlV?=
 =?utf-8?B?NlFRVkZHbytab0xvVGZsakw0bEJ6cFdnVlh3cjdhczN6eGx5UUtaSDYvS0s1?=
 =?utf-8?B?YUQwTjlvZ1V1YUMwcThRUXJBeHZOc2E3NEJHTU53QkI0Z0pKVjBGNEJ2TkNU?=
 =?utf-8?B?Wm9obi91cWxnRVkweUp3a1Y5eWNGOGR5cVRxSnJWSnhiWEphM1hpdEluVkZP?=
 =?utf-8?B?ZzR0UHJiUFNpeE5MTzFmcm1rU24rZnlodjYxankxSDVqRm12MDBnV0xJc3pi?=
 =?utf-8?B?VXFpOHZ6ZlVFOTVxMTdhWThLMllQYitVWE5xUFVRSW5tYU5NYVM1SnZsa0lD?=
 =?utf-8?B?NnErTzc0RWhxaHZJWXI1L2kvbm5UeTF0K3cwRlBJb0RRbFFzRGdobjhpZUxv?=
 =?utf-8?B?bk9LNlNuQThzWnJuYXVLU1BoRVJSdGp1SzRZQ1gxRDFLd3V6ZUZYN0dhZjM5?=
 =?utf-8?B?bnRBaHRhbXEybjZpNUF5dUhGZkhQUzN0TTluZ2pTeTNSdmYzMUxZSSt3Snov?=
 =?utf-8?B?RzVVcEdjam0rSDVhSGlXMmZiem9RaGxEcFdyQ090cGFwT24yREVFa2ppSE5Q?=
 =?utf-8?B?T0VVaFZ1cTNBUjVlMGVJU1NYb2J3bkhNYkJQQ1BSZmNrcmM2MWY3YVB3ZTUz?=
 =?utf-8?B?VkJoTExwNjhLaTd0M2VPS2prYktMdFF3UnlKb3dEQ3EvYzRHYzJ0dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66E213172FDF2349BCC0601D038B0615@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: qsox/P0zr7XK1fwoA1+dynqcZkHRmNpSIgRW9xsRUZV9XvlzulJIN9cmsyNVzdqEiHrZsGnu6jCERp1pNhRhINK3OvpkMjhoLm2M6GQRcZ7VD141gNXmtxHbyQHUieZPjiFPrK7v1nYWF+Ss3Q+gxGOLgwdBtZ0o2aSo5MBWxM8amvkkzYsLd/IKpmCebbBwKkOZJx4wDnEuyGGG7sIK3oMwQaH/OjwsZPc/3VtOIrirlhsooCw7kBRcJHPCob4IoSY1LHORVrfww/uaEaGgcrxmsXcVktjBX2VNlhAuocdjJV0rXaEZZGt2lqfy4WTkYNcH9Bu473MGktXDfR0D7A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3977fb6f-e1db-4274-51e8-08dedca37876
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2026 03:46:19.1537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IZvjkbJymh0aRyo85V97jZejTM+TLs7vesAXoUF7bfF/YjItIbdmBoDNjsgfQfqRwrmlosvItUU9YBRai83sfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR03MB10397
X-MTK: N

T24gTW9uLCAyMDI2LTA2LTE1IGF0IDEzOjU3ICswODAwLCBlZC50c2FpQG1lZGlhdGVrLmNvbSB3
cm90ZToNCj4gRnJvbTogRWQgVHNhaSA8ZWQudHNhaUBtZWRpYXRlay5jb20+DQo+IA0KPiBUaGUg
Zmlyc3QgcGF0Y2ggYWRkcyB0aGUgZ2V0X2hiYV9ub3J0dCgpIGNhbGxiYWNrIHRvIHRoZSBVRlMg
Y29yZQ0KPiBsYXllciwNCj4gYWxsb3dpbmcgdmVuZG9yIGRyaXZlcnMgdG8gcHJvdmlkZSBkeW5h
bWljLCBwbGF0Zm9ybS1zcGVjaWZpYyBSVFQNCj4gY2FwYWJpbGl0eSBoYW5kbGluZy4NCj4gDQo+
IFRoZSBzZWNvbmQgcGF0Y2ggaW1wbGVtZW50cyB0aGlzIGNhbGxiYWNrIGluIHRoZSBNZWRpYVRl
ayBVRlMgZHJpdmVyLA0KPiBkaXN0aW5ndWlzaGluZyBiZXR3ZWVuIGxlZ2FjeSBwbGF0Zm9ybXMg
KHdoaWNoIHJlcXVpcmUgdGhlIFJUVCB0byBiZQ0KPiBsaW1pdGVkIHRvIDIpIGFuZCBuZXdlciBN
VDY5OTUgQjArIHBsYXRmb3JtcyAod2hpY2ggY2FuIHVzZSB0aGUgdmFsdWUNCj4gZnJvbSB0aGUg
Y2FwYWJpbGl0eSByZWdpc3RlciBkaXJlY3RseSkuDQo+IA0KPiBUaGUgdGhpcmQgcGF0Y2ggcmVt
b3ZlcyB0aGUgbWF4X251bV9ydHQgZmllbGQgZnJvbQ0KPiB1ZnNfaGJhX3ZhcmlhbnRfb3BzDQo+
IGFzIGl0IGlzIG5vdyByZXBsYWNlZCBieSB0aGUgZ2V0X2hiYV9ub3J0dCgpIGNhbGxiYWNrLg0K
PiANCj4gQ2hhbmdlcyBpbiB2MzoNCj4gLSBGaXggaW5jb21wbGV0ZSB2MiB0aGF0IHdhcyBzZW50
IHByZW1hdHVyZWx5IC0gbm93IHByb3Blcmx5IHJlbW92ZXMNCj4gwqAgbWF4X251bV9ydHQgZmll
bGQgaW4gcGF0Y2ggMw0KPiANCj4gQ2hhbmdlcyBpbiB2MjoNCj4gLSBLZWVwIG1heF9udW1fcnR0
IGZpZWxkIGluIHBhdGNoIDEgdG8gbWFpbnRhaW4gYmlzZWN0YWJpbGl0eQ0KPiAtIFNwbGl0IHJl
bW92YWwgb2YgbWF4X251bV9ydHQgaW50byBhIHNlcGFyYXRlIHBhdGNoIChwYXRjaCAzKQ0KPiAN
Cj4gRWQgVHNhaSAoMyk6DQo+IMKgIHVmczogY29yZTogQWRkIGdldF9oYmFfbm9ydHQgY2FsbGJh
Y2sgZm9yIHZlbmRvci1zcGVjaWZpYyBSVFQNCj4gwqDCoMKgIGNhcGFiaWxpdHkNCj4gwqAgdWZz
OiBtZWRpYXRlazogSW1wbGVtZW50IGdldF9oYmFfbm9ydHQgY2FsbGJhY2sgZm9yIFJUVCBjYXBh
YmlsaXR5DQo+IMKgIHVmczogY29yZTogUmVtb3ZlIG1heF9udW1fcnR0IGZpZWxkIGZyb20gdWZz
X2hiYV92YXJpYW50X29wcw0KPiANCj4gwqBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jwqDCoMKg
wqDCoMKgIHzCoCA5ICsrKysrLS0tLQ0KPiDCoGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVr
LmMgfCAxMiArKysrKysrKysrKy0NCj4gwqBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5o
IHzCoCA0ICsrLS0NCj4gwqBpbmNsdWRlL3Vmcy91ZnNoY2QuaMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfMKgIDUgKysrLS0NCj4gwqA0IGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDkg
ZGVsZXRpb25zKC0pDQo+IA0KDQpIaSBNYXJ0aW4sDQoNCkp1c3QgYSBnZW50bGUgcGluZyBvbiB0
aGlzIHBhdGNoIHNlcmllcy4NCg0KQWxsIHRocmVlIHBhdGNoZXMgaGF2ZSByZWNlaXZlZCByZXZp
ZXdlZCB0YWdzIGZyb20gQmFydCBhbmQgUGV0ZXIuDQpDb3VsZCB5b3UgcGxlYXNlIGNvbnNpZGVy
IHBpY2tpbmcgdGhpcyB1cCBmb3IgdGhlIG5leHQgY3ljbGUgd2hlbiB5b3UNCmhhdmUgYSBjaGFu
Y2U/DQoNClRoYW5rcywNCg0KRWQuDQo=
