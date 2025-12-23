Received: from mailgw01.mediatek.com (mailgw01.mediatek.com [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D1F2FE078;
	Tue, 23 Dec 2025 09:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766482552; cv=fail; b=FiyZNOJjTjp5XVzZRI6TjQ4sipXumolEQwyJ9DCpkBUKozgQ0HTQwSz28J+sGGinbcPmuO8vkPKYLHCgtyvWjDkwpCiPjbn3OTw0lQsMWTLXJOnIbDdmpKeNj5tWiE4FSlaHWYRPHo6n87oe/SrPAsLdcLYDa3aprOGCQfuqCrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766482552; c=relaxed/simple;
	bh=xlo4vp0X7B4dvlDbDP9L85tOFT3dSeENPed3qqO3eSU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mUujYs0MGOLZID0Z1pIlchVfplGKaRNL9kOfjCwynkhK52WtezxkpaqxSgkdk1D0E71RCu3v4X7hCV6xr/W1D+HBPiI0K5NAn/5oBBuwtAX4gkel3E9IITsK131Yq89Bu97nNssbSjwMIj9OCu19Td9b7vbHRbvUxeuGPr8DP58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Lsj4L2Tv; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=m+iTYnWp; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Lsj4L2Tv";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="m+iTYnWp"
X-UUID: c115a984dfe211f08a742f2735aaa5e5-20251223
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=xlo4vp0X7B4dvlDbDP9L85tOFT3dSeENPed3qqO3eSU=;
	b=Lsj4L2TvyLhluBHh/5b50fV3J5CsN7OK5JHjzstc1isjqPOabJ7Tbf1R+yz0cV0SOYIZVbsXwcH1QldsXwcYbPnvVwsC+m0A7+0HT3lQAl8na2oNU3/9qMtBeEJxlSAuUA8eusIKfGwfLKJOMqc5Bi1IQnfeo1F/pWHalgmH4C4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:453c55d9-3c69-4d55-92fa-3e0114dae76f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:4658d528-e3a2-4f78-a442-8c73c4eb9e9d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c115a984dfe211f08a742f2735aaa5e5-20251223
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2097682543; Tue, 23 Dec 2025 17:35:44 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 23 Dec 2025 17:35:43 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 23 Dec 2025 17:35:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XhLO0miMgLBCm/uhqW22RCZai37MAPIIiDiNvSV0dNvNCGIQsxs1rwHattE3iocFOf28ZFHHepPDBOSeuohLDoo1gEnKZLhcQfojkwAzJrYIFKIPs8ZIWEcnaErUHFBA4sCQYQ2JYCtxtFyNK69CncDBDLz+L5k+m8LLZeTl9QrRMPAHhLmuCKeAjzfPsSMaYnrnxxPZJpgjpyEDUTPHgQdhg8JZfBP3EjLX0ZO/bTktrSoJDFV8i1rlf7sUtt/RZm+oFh+A1edO/JnvoGreMjj/hS2FE09dLuGQI0IIpHhOl/j2S0o00agSSDyYT1WuRZBbvklT03vT4Hn6qvnzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlo4vp0X7B4dvlDbDP9L85tOFT3dSeENPed3qqO3eSU=;
 b=uuOTOtQXRnCYZ8LgFXNigrbWzIGILu5lJHgPi2yr/63GoMqVwiWfuK0Laa04PjBwMRHEAVRg3Ia1aG+vTKX9P3r06X7+8QQZpiwte53d4DTSbsuFDeeZpSjy+EQN7OaqIuESQe00YfiAHrZgHgYd+4IlCGRxWYylLeW3trJaAV3HZ3iH8t9r3VOGmiTMTa1Cj0mzs7AB/kiZ1Os3VGBcfJxkHM0DrnBzLn43qFwJjdnVYnvMYQeGk8yYHLWlvtss2+0/Srx8EIuZypc4yPkwzkWY+CILIh8UTllzLhlaPNipTZ8dvLs0vnbaXjObaBbtfT1HqxYdkI9yISA0r0QO1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlo4vp0X7B4dvlDbDP9L85tOFT3dSeENPed3qqO3eSU=;
 b=m+iTYnWpBcOrkN2QtuGnTZKzB1q8J8RaQLlDmDaBX9MNM6f9FGgvADy2bUPO11z1w30OePothqyjCRhH5+wPR7MYZmsCZlkxbagG8T4DaL7QKbLmaZflx2PmqGs6hEqX5RnFKxhosqe3ozCQ9QpnfWyNX0Vfv3l9pnTYUH3q5r4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYUPR03MB7164.apcprd03.prod.outlook.com (2603:1096:400:357::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 09:35:40 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 09:35:40 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v4 07/25] scsi: ufs: mediatek: Rework 0.9V regulator
Thread-Topic: [PATCH v4 07/25] scsi: ufs: mediatek: Rework 0.9V regulator
Thread-Index: AQHccB37rimOvLbVPUGO2UUSvncJrrUu/sOA
Date: Tue, 23 Dec 2025 09:35:39 +0000
Message-ID: <8206d9e715f7ef987b5369d0bda68cce13528112.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-7-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-7-ddec7a369dd2@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYUPR03MB7164:EE_
x-ms-office365-filtering-correlation-id: 77959453-49e3-4d34-7a73-08de4206a2bf
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bmdpaXQwYjVTUkdWZlJBQWEzTmRidE9EWjVnQk91d1pOS0xURWtRUEtSaTVC?=
 =?utf-8?B?U0lJNXNPWFVibC9oOFZRSDZzMzdSNWNPMHk3V3VCbC84QnFXS0VMU0JYRWor?=
 =?utf-8?B?VzY4R29PUHp1bGRWdWxaRlJEZXMzb053ZlJVM1BJU0E1ZHU3eTFCWVJQd01P?=
 =?utf-8?B?TUJLQ3JMZ3RTRjl1TlhMQ2VhTW52T0xGRWQwaEtCSlM4WHhBaTk1YmQvVVoz?=
 =?utf-8?B?NGtjc2daMTdhbFFlMmhzbno0R1d2U3QxWWZhL0ZuWWZrM3dnekZhdzY5SGg5?=
 =?utf-8?B?ekREdmxDMnhhNWFOM1dEandEN2pYblRjbE9MZDU1V2VNWnBTbUErUFJOdWJr?=
 =?utf-8?B?d1VERG5sUnB1SHFUT3kzWmU3RU11RXVQS1N6OUJwY2xkaER1V0lSNng1b1dQ?=
 =?utf-8?B?akxCY3ZqN2tFdmMzRitRZ1ByYXhuTC9VOTJkZVV0eTk4dU1wekFvTDBuYmNo?=
 =?utf-8?B?eElwTDJWVURPaVkyQWpmNXRVanFrWmxSbW5MSzZsRWkza2ZvQXRxY3JILy9X?=
 =?utf-8?B?MzE5KzYzODJ1bjJHYjlxUXRTb25hRGVtYm1vUXZVaUJHei9uZ1JSOGNrZUdC?=
 =?utf-8?B?UzU5aDg3azdDRFU1MFlzbm5FcGo5ZXJTNHk0UkhDQkhYVzJrVG52RTVGRFll?=
 =?utf-8?B?OE8wR0JkSVkwN3NwdjBIOU5mcWNtSVhRaEVxck5ZZUQzcUF0Y09LN3l0MXN4?=
 =?utf-8?B?RGZZRGdZYTFPVUxxOXJYcXBuWTMxdzFSWVh4RjV0TXZpQlVkRTFiS0thL3gv?=
 =?utf-8?B?VytiaUxJUEJBTWQrWTRMcEgwWGFCbnppUVpNdVpadlBkSUw0ZE5Ucm45Ujh1?=
 =?utf-8?B?UVlmN2pvMkhMK0xkZUVjREZlOE5WRTkwb0J4TmlUWmg0czY4ZnpNL3lwbHRW?=
 =?utf-8?B?bFN2bVMwZXNnV09SZzFOOTRFMWhNb3ZJcnUySDNMd0hSMU4xTlNoUjBLUWFh?=
 =?utf-8?B?OG90S05MWWdXOFFjSDc2OW9nRWhnRVBZQ21VU2xFcnRVcktHUERxbnVTbUtJ?=
 =?utf-8?B?WHVETmFuSjJXd1NrZHJwdTJpUWNpMmg3MjBIbHh5dERGRm1FdWlyeW9rcVRN?=
 =?utf-8?B?VWdpV1ZueUM0L3MvT25qZ2lJbXNoOHo0aXYvaFgwYTdPM0dJTTdhRGRXcHNa?=
 =?utf-8?B?djJwZDY5a2NOSG1uY0VZbm1WTXpORWt1b0c0SDduWmZrRTVTQW9RR2FhaVFo?=
 =?utf-8?B?c012cWQ2OEpqeVQ0WGRleTBCM0NsbUdoOGVGa1Vpc1lsZlhTMFM2VFZmNGV1?=
 =?utf-8?B?czJGcWpwQldWQnpPd012SnRKR0h0cmxIKzU3aDg0MHN0NytKUWUrdmg3Sm4v?=
 =?utf-8?B?VTlEVmtCOXdMZ1lSSW02Tm85OEtQVWVHMjhyb3JhRyt5WmZGd3F6bkY2VkFL?=
 =?utf-8?B?dmhiVi8wTS93WGkwanBOYnRBczJ4SnpGSjlDeVR1SkdTMEJVS1dCSXgyVU1F?=
 =?utf-8?B?WEJvMGFnb29TK1RwZjZNVnhzUGJRL2NWQlVCUG1EbVBaUVl3ODE3OWEwRzRv?=
 =?utf-8?B?M05hYW8wTW9wVllRQXJ4bG02WHZ5dnBHQ3RwWFZFSEIweU15eHl4ekJQWFdo?=
 =?utf-8?B?T3lqZVhVUkQvRjIvZS84Q2gxaGhLaXZra1RsN3NlS0N3N3ozTm52bVdseG8w?=
 =?utf-8?B?NjhsOEthUVhFdEhacGJmQStHWW1zT1VHYlNiWFltM3ZCN2Z5SW94UEN1MVhq?=
 =?utf-8?B?azhoWlZwaEw1V0cyM1pTbTY2M3NMdVFpVmR1S3YvQnQya296aDM2K2FNdUF4?=
 =?utf-8?B?QS9vL2dKNGZjYVJEZFoxZ29Sb3JxbGF3MnEyUkRRV0JYdVlyUTRoOWxIdUVl?=
 =?utf-8?B?VVBhWGdWalZvL1ZubHJpNXl4S2hkYXFLazdhaENBb012VUtqRmdORjUzVnFE?=
 =?utf-8?B?U1JjNGs5RVBNaU50MnBvRlM4ZnFaTGxPeklkT3FscnBSdWFHVEFBclFIWFgv?=
 =?utf-8?B?N3YwOGVjZnRXSWJCbWE2Z0RHKzdNdkZZaXNWMXgwc0txQlMzeFlNK0RseXpY?=
 =?utf-8?B?b0l2eVRia1hXRGlTWEJKMWlWcDJaeGhvV3dxSVhTL2wrZ1dQTlBEd2lZUm9n?=
 =?utf-8?B?N1hSOEh6QjhGNVRSS2t1V1RPQTRlZmlSbzZEQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXM2eUtKV2h2ZnZYcHRVdGgxc0h0SVlOUnd0WFRTTERzZ1RuSnA0U3A4Q2Jm?=
 =?utf-8?B?MFd1dGliVXN1QVgzSExuRVF2bUNUTDNHcWtZTVdPZERtTXJjZFU3VU03TlY3?=
 =?utf-8?B?OTQrajI4d21IQk1zT2VkSzdCOEhNVUgyVmg2dmFzYTNERTNwZU5OSG1MRnVa?=
 =?utf-8?B?VGplSUFmMjdrUFNtVmtxc0oxM1pjQ3R1U2pQa1AxK091a2x0Sm51SHZTVDYx?=
 =?utf-8?B?V1FuSm9iSTd0UHZkaytPcy9rNWlRa0ZvODI4RWQxUEY2cVdOSU43Z0VSZ0h5?=
 =?utf-8?B?NUNCcWd4NE5oUS9xN1B0NFZBT2VwQWNrMTg0dkFyL21rZlpYK0M1cGcxQWY3?=
 =?utf-8?B?NVZGbFU3bUVPWW5mcWFlZEtZZC84M0ZWemxRMmdLcWN1MjVZdXZMdFNNRG5M?=
 =?utf-8?B?NXM0RlJvcUdrQSs3aGFqYmNENnJGTzJtZjJXUnFOYllwejFHekpqSy9RK0Fh?=
 =?utf-8?B?ZmhCc2s4MkRFZEU4MStDN0s1Rm5wc0Jud1c1MWsrZW5BR3Q0NS9tbTVIb01M?=
 =?utf-8?B?dGRoSitXVW9kVmdyaUQ0dEpFcFBOQlF0a1hjeGpjTk5lSDJ3UmRFdll1bkcy?=
 =?utf-8?B?RU5paGdJNnF2TWVBVmdNeVF4NG5QSGhpRHllRWJ3RFIrYzJpcGxWaG9DeURI?=
 =?utf-8?B?eWhEMUw2NTVXZ3M1YWhGazh3UTE1TVZDN25jcGhJNFp2YVZxTHFBdjdWS2hS?=
 =?utf-8?B?dE9uckpuWDJxaHNEaUZ4TzFOcExqMVNzOWJsdGJlc0xiWFd0UXVuZ1BQTGwr?=
 =?utf-8?B?SEZGMFlGMVU0VTlwbGduR0tDem84VndNRnVQR3NKcUFDMWYxZVYzYTgxalB4?=
 =?utf-8?B?aFVCL09BQ0pvanp2Ylphci9NZ2MyS0cxUlJENzFhbVZJQ0lDeUtHY3VTYTE1?=
 =?utf-8?B?cVN6aXE1NzlZeFgrUlRJcFVERWl3aVh6bDJYUFkvUHF0amx1MkFNWXJXdWVz?=
 =?utf-8?B?bC8wOU5ZdGR3RWFxUFM0QVFDMFltOVBoVEhlY3YySHVFai9Peit6Ri8zSGdL?=
 =?utf-8?B?cGhEMllhcnZabXlqM1gvZS8xZzVqem02ei8wSHpJZHJsbmdwVWExUU5OWXhM?=
 =?utf-8?B?amREMEFDV3lqUktjZ1RvYXhWVVNRdU1xdHA3RmNWcjJhODRUVEpqYW9NQ0M5?=
 =?utf-8?B?RFZUZW1kOU5ZaFJYVFJJOFlHeUw4dHBaaXM0NVdVSmhXTDh2blAxbmtOTVVm?=
 =?utf-8?B?STdNYlZNVGRUL21yaE9JQ21CaW5CTmQwZlgyaXNxM3VLOWFvOVRJVEZkUzVr?=
 =?utf-8?B?UWpkNEI5YjMwVy9GMTNYUzRJdnNIZ29mTW9POUNiL1pCMW1tOWhGRTBRdkVr?=
 =?utf-8?B?eTdxeXhzZ3dqV3c5YkVRdmNyby9jSThpbmZNdGpLdW5heXEwb1oxOFIvYWVv?=
 =?utf-8?B?dWo5UjdHaFZSSTVMeFVxVnBLN3JUb0NkMnMvMUZ3Y1RwZ3lCSmM3WlZKcDJL?=
 =?utf-8?B?TzF1N2xWdTlRdHljbUh5Rk1CK0wvTUJGeTJ6ZjZmRmxEN1FpM2xMVjdWZ2ZP?=
 =?utf-8?B?VStibVNtbTlHUUpDN01WczMxbmFudjkxUUMrcWRpcnBuZXZyUFN1eEkyNzJx?=
 =?utf-8?B?aTl3NCtRY05EU0tiUnFjcW4zbTNFQ1VDanZWNlM5cFlQUzlkVXdSZjlQM1Na?=
 =?utf-8?B?QzlSS3FleDlTYVk5LzJMbExpVVZzZ2RMSWRoMDd1bVZNL0U5T1BLaTFRaytW?=
 =?utf-8?B?YmZrY3JiMmRtRy9JVFM3WGRDd2hzSXVEdzhRemtLSXNodzIzQ1FGT2VXeGNX?=
 =?utf-8?B?RG1GK0gxbjI4N2tvL0ZHU2NHSmo5V3lncW5ENlAxOTBFNGhzRVUxRVVTYTEz?=
 =?utf-8?B?Um1iSml5c1FNb0pva240eEFZc2xPVVN0RFVHQXVMYWIybkYvNVFEbFpRbGFD?=
 =?utf-8?B?ZUovaDJZYUJvQW9JS005dEUrMFBuT2FvWFYwWGtuN1hpdTkrckZIVGszeXp3?=
 =?utf-8?B?YllJdUN2eDUzOWZPUUdLMnF6bUE0VkZaL2tibDg1NExuN3pUbXdzZXM1Mk85?=
 =?utf-8?B?Nk00amhPd3RJWWxTZnNOcDlMejIzOTNWWWswdEJtZkRRU2NZVVlpeExzU0pD?=
 =?utf-8?B?RDlJcXlaRDUyVkYrNlpabm96ZWYydmFWTGs4OGp5bEs3SU5NMW8zUlp5dzNw?=
 =?utf-8?B?RUJLb3haTElYUE9ZZk5WN2c0WlM3YVpqOERNWjdBL3ovQXVhM25MZmJIYlU5?=
 =?utf-8?B?ckVzTkNPTXR1aTFGbnJPQUEyV2ZUMlJZdWtqbXdacnV5anBuTVFUN3A0bHFx?=
 =?utf-8?B?SDJsODZITWNWYWxodjlqRDl6aWVSSUZnUTBGdjZQYkRhazJjVyt1WUFmRmpE?=
 =?utf-8?B?eUhBcVFhSGJDSGlJUjVqUFZJMTV2R0I0L2tjSzFqYzhMYkFhNlhwWG9vdXgz?=
 =?utf-8?Q?FSwQxjN9AYV9uYII=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CF00B98CCA4F84E8146123E73DBD9AA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77959453-49e3-4d34-7a73-08de4206a2bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 09:35:40.0006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6qdKVPk4XNbL3Khd0YDpXBwKfYwWWp2ZnYBdWe7FWqOTlUa76TuOlFHtmQ2GT9ub159WnMAFWk0vGjEKZoz6HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7164

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDEzOjU0ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IA0KPiArc3RhdGljIGludCB1ZnNfbXRrX2dldF9zdXBwbGllcyhzdHJ1Y3QgdWZzX210
a19ob3N0ICpob3N0KQ0KPiArew0KPiArwqDCoMKgwqDCoMKgIHN0cnVjdCBkZXZpY2UgKmRldiA9
IGhvc3QtPmhiYS0+ZGV2Ow0KPiArwqDCoMKgwqDCoMKgIGNvbnN0IHN0cnVjdCB1ZnNfbXRrX3Nv
Y19kYXRhICpkYXRhID0NCj4gb2ZfZGV2aWNlX2dldF9tYXRjaF9kYXRhKGRldik7DQo+ICsNCj4g
K8KgwqDCoMKgwqDCoCBpZiAoIWRhdGEgfHwgIWRhdGEtPmhhc19hdmRkMDkpDQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAwOw0KPiANCg0KDQpIaSBOaWNvbGFzLA0KDQpJ
dCBzZWVtcyB0aGF0IGhhc19hdmRkMDkgaXMgbm90IG5lY2Vzc2FyeSwgYmVjYXVzZSBpZiB0aGUg
DQpwbGF0Zm9ybSBkb2VzIG5vdCBzdXBwb3J0IGF2ZGQwOSwgaXQgd2lsbCByZXR1cm4gYW4gZXJy
b3INCigtRU5PREVWKSBhbmQgYnlwYXNzIHRoZSBhdmRkMDkgZmxvdywgcmlnaHQ/DQoNClRoYW5r
cw0KUGV0ZXINCg0KDQoNCg==
