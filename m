Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792DF26E709;
	Thu, 11 Sep 2025 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757582301; cv=fail; b=XF5FKq20QfMzF+wrDQAzEFeByaxXDBCJs1MALX3v3q7yW1B0+XtQWfXkKis8QkFPg4+PYiVsd7bjwpOm/zkPKVwbLosZBCTy4cjA917b7XEHqfxnn7fOgHYi4s6CLPSg+zfiZ46tyJ1prm+jpszlGwChBMUOIaPAFAvDYUbPuYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757582301; c=relaxed/simple;
	bh=jwTeC+swoPDLXdsKA+mym9T5TQCPgs/2EO/CtRPdqVc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Sp4bLYfahRW3wRAqXlQAVWVOYy3ngfwhl9uxsro88RJixzgW7vOy1hLPbKerV64BNjNOa6MROwPKIMyT/EiJP8qvmnYqFLSM58vCrQLRMKY1TYj4qz0dhgvEuL/vlYFdv3MrTiA9Z+BFH4HcL8udRdeIEkGolfIY7+pJlx957g0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aeiHkzk7; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=XK+g2sA0; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aeiHkzk7";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="XK+g2sA0"
X-UUID: 39c82f588ef011f0b33aeb1e7f16c2b6-20250911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=jwTeC+swoPDLXdsKA+mym9T5TQCPgs/2EO/CtRPdqVc=;
	b=aeiHkzk7JuT90GQp5uw+dKkrB+5MCWvTn6bqIrXavyYWQnE0963KUofNXTZyoEamywjIwwSr/853gyM8OrqrQHOYitaq7Phk1RV3PSKKC+1H+/avn1xrWnbIQmUCz3ITPTKigsNyLTtXidAOcLDaD4mVLhpWWpMujzHloqw2i54=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:3e4ffb73-04d6-42e3-8b22-66116105cf8b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:2861716c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 39c82f588ef011f0b33aeb1e7f16c2b6-20250911
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 923557316; Thu, 11 Sep 2025 17:18:06 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 11 Sep 2025 17:18:04 +0800
Received: from TYPPR03CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 11 Sep 2025 17:18:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rgBBMcrQIk2+hyTS4Pcbqs5ojEYpykufUb8NjB48TsDszDoR6rEcnqs5wEwLv/L3mdr0b9S8cLvuJv5wYVHxFZjHAgxki2Nf0pRAskwaOQdcTYOw/orMEPug2MikPkWJmzDyvxWOb0F669YqUn81YbEbQY8a9MPNU3juNeQu7PQ8LsQFG0rCqlR8yIFFF9z8x7L/fwXzNLjC2esSFf/bJWysaEwK3AY+bmCD09TDKYFF+fmsXYXhJj0VBdK1uPnUYou7NOIZRH4MHSGInyh2vXSpL+CcpOe6/M8a1lunwGb9UBryRilK9jeC1Z6Po+/itbcTVYCjhmmmBGuuKNGDWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwTeC+swoPDLXdsKA+mym9T5TQCPgs/2EO/CtRPdqVc=;
 b=kUNYMFaAzxRNJ3uoLQPj4xFp8HJNLgls4VDxV+qp3OKuaBleCCeg0tIasp4n2e14TKTHNiTEbIAL4+5yNC/7XOokLEtgcidHnE9iedZLePplDUZIxzVQLJt8YnoiZZ/E72orAuzUBBXcWshU1xYyLkYKyUamEUQYYSy76PAGi6+oslIWG+N2MiCu7tSDSKTABRIUy5wYzTzYvMrmJgsqG01pS8P7w5yYddSWm9En29AAetPxDTsviiSIffAk5lkBBjh05Bls+3zLgHeCVSuBoso7jraWpjHd6O803/zO5IX3HFRm+ExMDr41V33MMRFcbPWFlXimwO81//w+ShZObQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwTeC+swoPDLXdsKA+mym9T5TQCPgs/2EO/CtRPdqVc=;
 b=XK+g2sA0TpAlZp/vr/kDPCvmkBa9LZwhXltNOZekCdW13VZuBJ34+IWR8Rh8ufiJtP1o4is4TqxG302blhb29uiXdC+LX80qG/Yu6u6wwcsTdGvOFNUoM1Z/Lz0KrhpCpfYu5QrThua9p/IrNBGkynXG0QowYNu/eIDjXQaGvQM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KUZPR03MB9416.apcprd03.prod.outlook.com (2603:1096:d10:45::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 09:18:02 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 09:18:02 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "hch@infradead.org"
	<hch@infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>,
	"john.g.garry@oracle.com" <john.g.garry@oracle.com>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] ufs: core: Use scsi_device_busy()
Thread-Topic: [PATCH 2/3] ufs: core: Use scsi_device_busy()
Thread-Index: AQHcIpqeXAFGL9Zoj02xO7xj0oa2qbSNtLuA
Date: Thu, 11 Sep 2025 09:18:02 +0000
Message-ID: <7219c5bf11d6b2337d3c61d28abfc26d420018d9.camel@mediatek.com>
References: <20250910213254.1215318-1-bvanassche@acm.org>
	 <20250910213254.1215318-3-bvanassche@acm.org>
In-Reply-To: <20250910213254.1215318-3-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KUZPR03MB9416:EE_
x-ms-office365-filtering-correlation-id: c741e6ad-6856-4013-df56-08ddf1141bce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Z1lXVUwxZ2lYQncxdmcwUUM3dk5YYkl2amE4b3dJT0VjWVltRGd4Qm81ZEc0?=
 =?utf-8?B?eS9lVFNoVWRCWE5JL0hlVG1sQXFHNVV1MUNPR3UvSGJhNFoza3R6UE53d2x6?=
 =?utf-8?B?UUdUcEVIU1FLc2tDdkVIYTdrcXQrU2JsL1VjR0pSV3hlUDY2WjZPWjVVc01u?=
 =?utf-8?B?eXJVL1QrSlJHREprdTY0NHBYa0lDTGVIbStNV0VDQWV5b2wzbWtMWldzUWZW?=
 =?utf-8?B?OEprMGEvRkFUMFZNZDErSjVKbjhITWdWNmNjVFRFMndwVUFncHNJUUZmMVFK?=
 =?utf-8?B?VWdIaDdxRkRRc3ZEcGx3cTgxcjNoRkVxdU10N3kvenZzQUpDN2xTVVJtT2JG?=
 =?utf-8?B?cHlYcDdCc0dMNkJrK1lJd0psNnBuKzVXWVFmRCs3RnE0R0RUR2NZb0I0dlIr?=
 =?utf-8?B?RkhVcGc4czlnaHFnTjVoRGcwL1VSYmZMMHJ3YS9IMlVDOXlJSWlrcThHS0lV?=
 =?utf-8?B?bVpSU1FGaTJHYkRMalBER01BOUxncTM4QW9ncm1jcTFDOTdYZDhDejh5dnFo?=
 =?utf-8?B?MlNPUnJGMjB3S0ljWjJlM0ZuVHZLY2F2dElUUnZDcmFSVW5xK0Y0VmtNc05Y?=
 =?utf-8?B?MHlDMXpSRFFadXpnYS9sc1VEbWlmQ3BGejVWa1dmL3BDalo5UmY1Vnp6ckNz?=
 =?utf-8?B?WFNXaDg3NStDQnhpblMyRHJjeWhSc2VWeWRpcXlmNTluNmljdit4TTNWMmVQ?=
 =?utf-8?B?MnJHVWJUeDZaV2xCcFUzdTFSVzUxTmdJR3pqWGE5MTNzc3JlR0x5bXhFS21B?=
 =?utf-8?B?UzdCbGVyVVJjWHJoOUZVMWQ1WWVxTGJraDhxeFgrRmw2Rk9objlrVS9jcnI5?=
 =?utf-8?B?N0hqRmVKWVdlT3hUd0R5akJtd0hTMkdiTG5lMmFLaCsvTzRQSjNnbnpST01L?=
 =?utf-8?B?d0w3UzB6OXg4WDI1VFFtUHF1ay8ySlErd0lZRkVUalNmY25yWDNKbGRRd3Rr?=
 =?utf-8?B?NG5kMlVGUk4rWW16RGxwV1Y3aUdsWEx3YjdEVXRneHpDSGZpZHN0OFpYdTVx?=
 =?utf-8?B?Yi91OTZ3NlJrTVF2MFlHbFFaejczVUcrODRFMHh2RElCYWVJUDM1bjFnWjQv?=
 =?utf-8?B?aE1Dd0UyV21WN0MyTVVQUFRqcHhBL01ib2p5NzVvK3FYUVV1STlETGJrZEVD?=
 =?utf-8?B?UmpNR21Yd05wTFRyVy9uSzNDZTN6WjdUV0o3VE1xQVhqTVNmc0hPb0FsOERX?=
 =?utf-8?B?bHg1TWVJUWdqUXJ1UFBWaGcrMmNncDM0Y0pQdW5sckI1QnN0VkJFYUpjVWhS?=
 =?utf-8?B?c2RrcXE2MkFnMXZtenNoTzN4aHpqRzloZnRXbDlBd1FCY1dhYTNoRGRyZ0N4?=
 =?utf-8?B?eVRjbXRpSGJQZEVLbVhiRUtITUFDeGNOL2ZqMUxvU08ydzJsdnNlL1o0RFhG?=
 =?utf-8?B?eVRtVEpGVTNodmg3MHNiY1VXcHd1a0ZES3NnWFJqcGxtaU5GNXM3Q0IwK3Iv?=
 =?utf-8?B?VGczbVpOYzRVcDZhNG1Va01pUVVnbFhXTjBsMmZIaWs0R1JDbHAzbEhtYURK?=
 =?utf-8?B?eElwMmhWUStiSTVsZm5VK2VhYklMRnVHOHpPYk5uMExIMHdhOVl0SEVNM1Jo?=
 =?utf-8?B?VFRFTU9jNFRoNEZUc3pTSmV2UmNkaVBuVVhqL3hOTk5ReGRRK2huUDh3cjl0?=
 =?utf-8?B?d2ZhbTJTZ2QvRFRib2ZCK1ozeTBVTHRveXB0Wnh5V1BJcjRlcW9uZXFwTWlU?=
 =?utf-8?B?S3RON0hESkhqMDN0S1pMcGh4bWdkOFhHbStOMGp2NC9lVkF3Ukc1MGNYYmYz?=
 =?utf-8?B?MEJ1a00ya1FHd3g4UVd3dlgzejAvYUNxMEc3OVJvcXlhdGdsYTFMdm12UmFk?=
 =?utf-8?B?elZhZDdKNlI4RmszckRkQzJYQ25YU0U2WVI0VlRWdFZFWXBqclZnY0pkaWh4?=
 =?utf-8?B?blptT3JMVmVjYWZzSW1sc0p3cjlaWkdrbWJQaVFOZndZdHI4Z2tlMXBaUVFE?=
 =?utf-8?B?Z0ZLUHZPZ0ExbHk0RllxNW9OU1VRSUhTYkk0L091MG96TUx2NkFES2dHQVo2?=
 =?utf-8?Q?6TQ81w9m/IVduSkOlhzCqi0WWOYruY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVNBR0ZlUC92dm93Q01MRWZRUUNjSDQ1RjNGNTFMZ2trRWlWdWxuRHlEU2JX?=
 =?utf-8?B?K1NVS2tPK0swWjZ3RjlIUDgwWmdxMFFkTkFLNy9jbTZSQWxETEtyQXBWVG5n?=
 =?utf-8?B?ek1GTE9rS1JwQ0puaVhCeEV6cjNPVHVPSHBjTk1XdkJSTEJGQmR1ei9SMlgw?=
 =?utf-8?B?SklUOGRWb3Bxd2t4dUUyTWR3OUtLdmwxUDZ2bXFNU0FuT3RHZnhWdXpUOGFv?=
 =?utf-8?B?ZlNCKy9XbkpJMFBnVFVMbjN3Um11aXV1dzJuekxMM2RSY09wY3h6bGJIMzdE?=
 =?utf-8?B?NWNsbnVzempZaDdaY1pRblAzRXEwSmkyNDJpVHdWNnJzTlV5QkFHb0RaUWRl?=
 =?utf-8?B?NDhlRnRQMUVwVHlUWVUxaGl5bUkzVUVCakVRNmV6dzRlL280YUp4Q3A0UVds?=
 =?utf-8?B?U0ZTaXJtZDFBc2FiTkd1YW1yWFdBYlVqS001T2EzRVJJREZWcG96TVU4THkv?=
 =?utf-8?B?dlVNdmh1YlIybTFxR1RGaGwrYlUybGFGNTU4SFlOT2swY205NktaSmZVT01y?=
 =?utf-8?B?VDdSUXpLUE10TWt6UktPMlhRcUR4eDJoaXF0Z0ZrWm1QZVNoVmJVcy9TV1hB?=
 =?utf-8?B?Rkt3ZW1COW5XckZ2WjBIMmdsdEE3RndYWWVnaTRRQXA1amhEOTVuakxMdG1U?=
 =?utf-8?B?RG8ydjZhdEdabkhSZmdRQUdUZGdLMkdGS3U3ckE0K0trc3dvcHI2SWtRaGYv?=
 =?utf-8?B?UDVYK0RBb3R2NWd4TUlpVUxTS0dGZW9FanpITlNmekFpUmxMNTVCNjJkZXhW?=
 =?utf-8?B?YTdzVnRMaGhyTXZ6cGlHVzVDRE9DMDY0YlNENTd0ckczVTZtN2ltaEpRZC91?=
 =?utf-8?B?dHdpYklGWkprYm1Rc21ldmwzdHNpNEdPK1U5eUJFWHhKemx6cmdGK0RuaEdr?=
 =?utf-8?B?SUc1TmZheEZJRnJIZTZrTmtKOUxCSHZrMHVJZksvQzg2SzNWVVF4eVJXL3pa?=
 =?utf-8?B?N1RxZk02RzhqbkNzVUMrLzFUMjFsU1phZWw4NDZNeFllTjV2cTZVSHNZbnZP?=
 =?utf-8?B?VlBaYVErZ1Z0QjREVHk2VytyZUc3NmpWVjZKbXIvOHpRb1RFQUkvdmVWb212?=
 =?utf-8?B?MGhoSEtjdVByNkFTcUdZUjdFay9RS29lVXI4OURCZ1k4Z2JLNUFsd0hzbjM2?=
 =?utf-8?B?TXQ2a0QvdFBnNGN0VzhZcytuejNHNzJUUnZQb0ZHUzQ1QksyUXV0UVBKSHdF?=
 =?utf-8?B?ek9tVE9XTUlLTDNrZ0I3ZldEK0Z0VEtNc3d4WmpNRk1HcEU5cnY0M2tJZDZi?=
 =?utf-8?B?UkIxUGQvL243aWxxUXJ5ZTMzblk4MjhlMjA4UDBiNFlQNnprbnhvVVlGQUhW?=
 =?utf-8?B?WWlIS1NTT1NpekN3S2JjTlN2bmpRMHB4Y0R1Y3o4MC81QTJxRUhQV3VDc3ky?=
 =?utf-8?B?TXUySVIzTUp2cmFlZFVkaE5sWDFLRXNQYklHNnFYUjBMMUpSb2MxcTFnbnc4?=
 =?utf-8?B?MTNGRFJFZG1UNkNyZDVZN1dDUDIzamtNWUhUaUpvMTFIZ0FEbyt6cFY4ZWZ4?=
 =?utf-8?B?THZ6eit5WUlDSVErbGdqdG00NENpcVhmaVRWZXVsNUl6a00xVjdmZXNObkk2?=
 =?utf-8?B?blNyS3VLRitsZGxVODVRcE8yaGNYMElSSll4ME9KUG9WenQ2RWhNaFdzVU9m?=
 =?utf-8?B?NFFLcWNoSmpyb1g4bGl6Y3dIWFk5cVEzRm8wekExN28xU29sVW5KblBuWlF3?=
 =?utf-8?B?TUNaWWNaWUVLU2tkazFUdFBtSk05TGhRYTQ0NmExNHRHbnhQL3kwOElFeTVa?=
 =?utf-8?B?U2ZWYVJ1eitLbU9WTytQQkRKUlZsN3gwWW1WbzRHV0ZJSGZXNFNTUi95aW01?=
 =?utf-8?B?LytlYyszU25QNEZJNXlIVndDM1RWWUtZN01BYWhlbHRGakRaSm0zRTBmMW5R?=
 =?utf-8?B?eE1uUHo0N0k4VDFBd3BjK1Y0akVBMkhBaUpLNWJjTXE3QkN3d29Ca3R3TXZC?=
 =?utf-8?B?T1hkSm5lTW9xZ2lXMnBRNytncklkR1BqT2t2d1JUM0d2WjBLQiszVGwrNWMr?=
 =?utf-8?B?VzBQaVhYL3NiNEdxVXRROURzY3MxYU0zellOSjFSWnN3UUxOZENZa0h0UXJ1?=
 =?utf-8?B?V2lyUWY4azNBaXJaVGNMZFNXaVZvb2dveEx3VGdqN2dFYkVYRDZ1VXVlaW1W?=
 =?utf-8?B?djFEWVFPMXhhNVVkTmZLU2U5S3ZSRjdHbG4wTG5iTkRSQkdnMGxya1g1dXJq?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8206B6D47B8C1643B81F0A5306FEF3DE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c741e6ad-6856-4013-df56-08ddf1141bce
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2025 09:18:02.3922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +8rGnOSBV2HAaciNegl79ZQqp3Io/UEPIXAJt1R8o2GnDEViePrsil9Me0FZzg+K9JAGJyATP0RVXC7nXzATQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR03MB9416

T24gV2VkLCAyMDI1LTA5LTEwIGF0IDE0OjMyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFVzZSBzY3NpX2RldmljZV9idXN5KCkgaW5zdGVhZCBvZiBvcGVuLWNvZGluZyBpdC4gVGhp
cyBwYXRjaCBwcmVwYXJlcw0KPiBmb3Igc2tpcHBpbmcgdGhlIFNDU0kgZGV2aWNlIGJ1ZGdldCBt
YXAgaW5pdGlhbGl6YXRpb24gaW4gY2VydGFpbg0KPiBjYXNlcy4NCj4gDQo+IENjOiBKZW5zIEF4
Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IENjOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJh
ZGVhZC5vcmc+DQo+IENjOiBNaW5nIExlaSA8bWluZy5sZWlAcmVkaGF0LmNvbT4NCj4gQ2M6IEpv
aG4gR2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0
IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+IMKgZHJpdmVycy91ZnMv
Y29yZS91ZnNoY2QuYyB8IDQgKystLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pDQo+IA0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIu
d2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
