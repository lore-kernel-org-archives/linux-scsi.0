Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD38122AE48;
	Wed, 10 Jun 2026 05:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781069630; cv=fail; b=o34JcT/lnjcx3qPXFow7Iigk6k/4sTvlvpksfxPpAMjoVZ9tiOeCR4EhqgdmiAsKGktxTPp3OIIvSd1QnrkCAlDPO5B6n9RGDupxuiqqpBHiXJbmnkAfIe/1bLd9F4Y7eIiL2tp1aGIZk5CNIlO55uDId77jYAIe8AN/Zo9OFk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781069630; c=relaxed/simple;
	bh=v3HQIuyCHF+UAprvcnH6sVHhFhlZMHoj59NnaQt+xPU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fA+zwknR2LM6DmVp5uDqLLromfTto6tbtrLJwOsGb655w4DLn7YuPa+mhqYZ1PYERGZOkE9cJMczPJ5ZAat0NPNgHYxJlRALhF9LSYEayfULZwHbZyNxmr+xB0RnFmJkT8u4QbLvfCjwyNX6bScqeAUeEgftf1d+Iv5FAEQ81OA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jhhZE1pj; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=OBYBFi2J; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jhhZE1pj";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="OBYBFi2J"
X-UUID: ed0b1062648d11f18dc8c9802ae25ab1-20260610
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=v3HQIuyCHF+UAprvcnH6sVHhFhlZMHoj59NnaQt+xPU=;
	b=jhhZE1pjF2O8aCzmxYVzK0Ac04aPHfcBSkwKIshJqvx9v3+sW+mHgNQEOXzEK7XjAH/VfarD6BAV3vCkap9oXXnHC5T/fe4usFpT1GiiCtyhCHM7lDDv4D25fNG3lyU15GYZaxGT7kII7EQOGWcWT9IPAW1THBwxp7rDmr5FlUA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:1408030f-420f-4137-89c4-98cdcebea061,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:46c09930-7784-4a77-a538-47ed6151d81b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ed0b1062648d11f18dc8c9802ae25ab1-20260610
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1324719289; Wed, 10 Jun 2026 13:33:35 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Jun 2026 13:33:34 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 10 Jun 2026 13:33:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m8QguGu/CQPbDf2aM24lX6nbIMl/cF7L0+0XmepezhAZ2mYOcIiOj33Pi9fB8mOZNgR4kQYP1OKejGzry4Zz3NMJolx91Qv5zdGbXirFwuzCpQAp3s02s2yAMN+eRxkN9C34CVMfc86Iv+KQZmR9kYRvIkIWBUrnqtXzILTRYO5aZFrhDEO6S0IfBMzIGsLqVFdCWV8QRN4mNDaNgFXnMFK259BXLxEFDwKyIgWK4D4c3NyW4LElSAOyn6zuOSEHbqxySELK9OCzwTQJFvnwL6HnkOI8ZyeNuKFJ7+CuLr00nwvWHYVrZx5zwtFUoFj1oUa6YBDdrBshi1XZ2Mj18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3HQIuyCHF+UAprvcnH6sVHhFhlZMHoj59NnaQt+xPU=;
 b=PB1cGlK8FxFjCvdhEdmW6ThNo/OplAmPehvO0/j6AiHr9K4jWxZjuOc5jl3RJmzFHZ6ZZKwx+GP31ikGaOjQaTOt0f3K0JPsWg0uCpp7c1E0z4c1pYgDyxlJdaO/jhXv8OIh3sWo3LZ4wrBsq9d6zGvGOfoa0wS6wCrV8dsdWJbP89Fit39K7OQjUN5a2u/AELe3lTUEM6P7EBJ+j3xdLW9gEHlTGEShXB/0aYOlFYozybyBb018I5/nMAFNTyptUcLMkuRzdDQ6G6KA2Nu7jGeSfOI58ahat328Uw+tP3zvx57Ix0flS84s1++mwxsGAx5lDQrvug4wwYGepSpZUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3HQIuyCHF+UAprvcnH6sVHhFhlZMHoj59NnaQt+xPU=;
 b=OBYBFi2JoVEY8uWKxWcUgCQTfMFOztgSp6+0FIPQlPzIUD0fDeo5MNfuhnmBYAiBqTDlxjKqEaZMJt3J/hV+z8xdjVObptPVy0BVgnZAATpaNSYjWjLlwMI5dOh4yLjbWJ39HUmIBvsV9erZjJ4ghN1Af5YR7eBKoub2nAlQueg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8679.apcprd03.prod.outlook.com (2603:1096:101:234::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Wed, 10 Jun
 2026 05:33:30 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0113.011; Wed, 10 Jun 2026
 05:33:30 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "bvanassche@acm.org" <bvanassche@acm.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>
Subject: Re: [PATCH 1/2] ufs: core: Add get_hba_nortt callback for
 vendor-specific RTT capability
Thread-Topic: [PATCH 1/2] ufs: core: Add get_hba_nortt callback for
 vendor-specific RTT capability
Thread-Index: AQHc9/xCBDuiFEFcwU+lnQMd26RtB7Y3RV2A
Date: Wed, 10 Jun 2026 05:33:29 +0000
Message-ID: <cdfc51c561fd7ab2fd3f05f53a02208641ad2bf9.camel@mediatek.com>
References: <20260609103856.676222-1-ed.tsai@mediatek.com>
	 <20260609103856.676222-2-ed.tsai@mediatek.com>
In-Reply-To: <20260609103856.676222-2-ed.tsai@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8679:EE_
x-ms-office365-filtering-correlation-id: c943beb1-1bf1-45b3-0d81-08dec6b1cdef
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|3023799007|56012099006|11063799006|4143699003|38070700021|22082099003|18002099003;
x-microsoft-antispam-message-info: u48hswlhY82XuvTcFXj/C/0V8v4f5MD75kslsw7U+gIHhacGIDuHpAN48wuQXdawTyYbOMhymqcqn94wegZudHQMEwCk3UzSOiTBhstl3VoFxNF6EupGLYc1frspviM7iaziL8Uu7VMILv3FNLxNyeNzBJasGkeMeg+3owd2fDw57FDtQvcsglH+STS6MB5tD83lEkpRNpLvd/Q8F14wDJZQx0eTdGYrwUIDZ/MnkqcbfwvlvgILyY4wcUB/3ttTNazh7Bnoaf0xPb9/S+LklDYqSyKXb7bZpf4f76PgnrTR7efoRFdkmRNrRu53jqT2kq1CGTCpcAVG6KRx0WeGBLtUkaxyfg3aG1dT0Su6F9izAdWoYFsNufdilp1rkz595aG1Enkx1Pgfx1JhjmLazxsRmkk4juPrDHR2hlZNFruaKgAoSACn7by8TjGxST4NE99Rms9DptOB1/LyP5sEO8R2/ndK2PO1vcewFYRctm/C7lxrYBzaMzmz222gwzKwyCpP0Y1ZkhVUa2WZQqdiFJCLexuDD6kL9CI3MTaq5m08CHOSfz4DCg6u/CNcV4SFin+DQtZxh5CNKcB36EQBLnlC1/d8itvwyt5ZJVolldpT5WHp7G+e1i5qPUZBbMiKNf6DZxIRnz7VBR6L/K4v87U1KNJeZqDOhlWssIgyrJgMWx4n81VTbw0VTX7VPK/A6DCLg3aivkuMBVVk5aJRjCGsxm49ezAdbmWkit1TpLQkNJSPJ9X9oeTOppB0Dbks
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(3023799007)(56012099006)(11063799006)(4143699003)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1JQckhuSDJmNm4zY3lXWGI5dVVJUXArbGlaWmpqT1JFZVFBREc1VWoyYnZX?=
 =?utf-8?B?N081UWgwTGVzVFgyOCtQWXRMY25GZloyWXNWRUhlaDZmTXh1SVh4L3g1djVI?=
 =?utf-8?B?cUpLZ0llbHkyYWhneW1LWTAwcHdIMldjd3JPWTRJcmxSZjhQQTZUR3ozL01z?=
 =?utf-8?B?SDJGUVpESGlBOU85Um5aMThJMW5IaFVOdFhFV0QvWks0QVJaOTA3UDM0ZzFJ?=
 =?utf-8?B?Qk5nMjE3TzZZWTNnemxVdGpqNUpZS3N5WlVLcCtWbDZucGFNdTFVcVBUcTg0?=
 =?utf-8?B?VXdGUklNWmNzODI0N2N0a1NmWEhmTzlTaW9lb2ZUbjZXNzZEV21RalFFYmlz?=
 =?utf-8?B?OEdVNnZSdXUrN3AwSkVSYXNlRStGY2hGc2NqWFhRL2VHc2VIWi9VVENWWldP?=
 =?utf-8?B?ZWRXbFZJRVdYMEJzWWN4SDhKWHpiMVh3UzJjSEpSSWVXekN1TDVyRWhDcXR6?=
 =?utf-8?B?RVBudlFJRTJualJ2UGRTdE9BN2VYKzRrOEhVRmNsRU10RkFOd2t5dHVCT2Q4?=
 =?utf-8?B?Yng0SWJUUGJta1VJdm8ySHpPMm50aVRQTmxmL1ZKdTBEdXRHYkRsZUtMaUdz?=
 =?utf-8?B?b1NQZUdMeU1pak8ySkNVUnJ3eGRlVTN2U0o0UGw1TVlLREdtK3dDc3kyWllK?=
 =?utf-8?B?TWxkczU3OXEzMk0za0dpRnpyV1duZFR3NjFrYTNMcHZvVzc5SHUyNmx4bXps?=
 =?utf-8?B?eitIb1ZrSHBlTWQvZXdnSWhRS0NHUGdTTzU3aW9ZTEllbktRTmhheUFKOThq?=
 =?utf-8?B?U2xqTk54YlV5aXg2UitYMktndnhSRC9Mc1M2VUVzTDFFenlGYW5yRGFqRm9T?=
 =?utf-8?B?eElOS3F4TXFGazNjV2NKQTNnZ0FGcmNyeTdkSWpwaE10Vy92WWFRN055NEN6?=
 =?utf-8?B?RVNoOG8vTWxRVnNiZWVrQ0Y1Ukh2Y1pKazdzR0ZoaEV4d09pMC9objMrS0RM?=
 =?utf-8?B?OFpJa29sTXI5L0RvbER4YkhJUW5ic0RaT2g4OHNzczNVb0NnaithYUcrQkdO?=
 =?utf-8?B?a2l4QTMrMkdOZTFRM21tNEJvdyt3QXIvaHAzK1BnTTQ1U0hERW1LZVJQYmJa?=
 =?utf-8?B?SUd4bGplcnFmMEJ2Z2o1L2FQYXJKN1lhRnlWRXFkVTkrN1lueHR6N1RNejNv?=
 =?utf-8?B?Nnl1UTdyRE5IYzVkcGhnRWR5KzZMNDFoekwzREQwMzhMTXp1UmNnT2xDbXNJ?=
 =?utf-8?B?c3R0cjhITmNucW9KOGx5KzBXWEZVbGtRcTVPYnZBQmNIVEIrQWhpY3VkLzdP?=
 =?utf-8?B?SWF4azRPbmJNZXVvU0lCcUNYcWJoODlMbTRxaFg3ejlFOStiNWlnMVFLSW5u?=
 =?utf-8?B?MFVWZTVnM0doMG1JSmxGU2VtLzZSQjd4bWZHdFo0czlFTVorakdaRmYxbGlF?=
 =?utf-8?B?Y3lBRlhvckNLSGw4Mmt5bjZMZk51MEVlVlJCanRwanBTNjRGbENYUzdNKyt4?=
 =?utf-8?B?czUwbUNMbW5tVm9mUzBpb2FZOUVxNnNnS1I1N3l1a2VaeEFzUGJJT3Nna0Rr?=
 =?utf-8?B?MDZrK01GUUpWTStDYmNyUFUwS01HQ1RITkJia1gyc05EVWRDSnRndTF0YzU0?=
 =?utf-8?B?R2p3N0NKZ1p5MytjNVNzVVlZUXE1NUQ5NWNKMXVhQ00xU2crZGlnSHJaOE9B?=
 =?utf-8?B?cUVLeDIwV00wYXMrVFFNMHlGdVFENjYreFR4VVZTK0lBL01VeWlINXlNZWhx?=
 =?utf-8?B?NmNOYUZZalVuOFdFbkVyRVhLMTNWREtWVENkd3VVTGx4dXZEbmoxaEd2VjlI?=
 =?utf-8?B?WXl4bUxNcW5BSkpmSVY3Q1RlTWh4OTJuT29mckhWLzYvNmFFSjVqRjVEZzFm?=
 =?utf-8?B?dHgyUFJzTnVGM3hhMkJEMkJMTGhGVG45SW5DWUFCMmdJNTA0SWgrRlJwWEly?=
 =?utf-8?B?UzVNKzhZMTJIcWE3a1RYdkRvTXpQVmtJZndiSFBIQll1NkY2UGhIcVZwTndy?=
 =?utf-8?B?S3IySktzZmxsNjJpdWQzbmFOSmhnb045djg4YWdCeS9mSlAzZExaN0ZKd2RP?=
 =?utf-8?B?eVphM3JmaWg0WjVldGFrV3ZxbU94SjF1cWtGSnFjVStyN1NhRjIvekZnaDNt?=
 =?utf-8?B?K1VYWmhpRE42TnNqdEhhdEZCZ2dySTV2TWZMTDBmZGkxTUpFNExtTTd2TWZE?=
 =?utf-8?B?bGZpR1JnUFl1VWo5Q1A3SWRIUzk3cnVJOVB5b1UybVFUSGhYRjlLZDUyVGlv?=
 =?utf-8?B?bzFIajZiWWM1Rm94d0tLVzVXcC9ZQjFlUTV5dXRqZnZJd0VCZWhQMldhVkV1?=
 =?utf-8?B?UzFLbSsvQnZJdVVweHpCb3QzenB3VjMxV1NBTjYzS2Q1enpud290UnEzZlBG?=
 =?utf-8?B?bVNRVlMzb2VwVDY3RmIxNEROZlVUeXNnVlBhU2VTL01hcXFFZEtQcHBMcHRI?=
 =?utf-8?Q?Rmm3hHLmDq+dFhfU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B21A6093C6B12042AAEA1BCDAA746135@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: hgu7s6I/HEKEM75qPWdcYnxu1q/59b7M2O02+hbUEIoiqvRX/RnWb2xdHJfE7cZULhCZDoYPKCS9uyyUQJIqOF1ZpCivJBMcd5awBPoBeroq05hP7MMo6WVfsEVWhGmX38ZcIcNv1PWDkdnyaWfjfp6GlDg8NHovlzQkCOXUt0EhixwY1GGQFs1kpNs35mtw9UKIY6EQEiL4FD+JTZMsOcTfRXumhxyP2MTyKBS5TK60kP+emNKWPwm/J87DFzheKVrAcQHqkKvht7TswbKtrZykgykgLQNBekZkroRNPize7fFoXsCqz7oSDP6uH3F2buKtzK+zRJfboxkJrYjNUg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c943beb1-1bf1-45b3-0d81-08dec6b1cdef
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2026 05:33:29.9469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yop24I4poolOWSt/y1X08Drq7o7694X5/dTQ54wYFE2ihHdfm1ITKd7TkaKYhMwGE699xBOoLIqR8ZBYPFMqwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8679
X-MTK: N

T24gVHVlLCAyMDI2LTA2LTA5IGF0IDE4OjM4ICswODAwLCBlZC50c2FpQG1lZGlhdGVrLmNvbSB3
cm90ZToNCj4gRnJvbTogRWQgVHNhaSA8ZWQudHNhaUBtZWRpYXRlay5jb20+DQo+IA0KPiBUaGUg
bnVtYmVyIG9mIG91dHN0YW5kaW5nIFJUVHMgcmVhZCBmcm9tIGhvc3QgY29udHJvbGxlciBjYXBh
YmlsaXR5DQo+IHJlZ2lzdGVyIGlzIHByb2JsZW1hdGljIG9uIHNvbWUgcGxhdGZvcm1zLiBBZGQg
YSBuZXcgdmVuZG9yIGNhbGxiYWNrDQo+IGdldF9oYmFfbm9ydHQoKSB0byBhbGxvdyBwbGF0Zm9y
bSB2ZW5kb3JzIHRvIG92ZXJyaWRlIHRoZSBkZWZhdWx0IFJUVA0KPiBjYXBhYmlsaXR5IHZhbHVl
IHdpdGggcGxhdGZvcm0tc3BlY2lmaWMgaGFuZGxpbmcuDQo+IA0KPiBGb3IgcGxhdGZvcm1zIHdp
dGhvdXQgdGhlIGNhbGxiYWNrLCBjb250aW51ZSB0byB1c2UgdGhlIHZhbHVlIGZyb20NCj4gdGhl
DQo+IGhvc3QgY29udHJvbGxlciBjYXBhYmlsaXR5IHJlZ2lzdGVyLg0KPiANCj4gQWxzbyByZW1v
dmUgdGhlIG1heF9udW1fcnR0IGZpZWxkIGZyb20gdWZzX2hiYV92YXJpYW50X29wcyBhcyBpdCBp
cw0KPiByZXBsYWNlZCBieSB0aGUgbmV3IGdldF9oYmFfbm9ydHQgY2FsbGJhY2suDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBFZCBUc2FpIDxlZC50c2FpQG1lZGlhdGVrLmNvbT4NCj4gLS0tDQoNClJl
dmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg==
