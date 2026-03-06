Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726887262A;
	Fri,  6 Mar 2026 03:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772768984; cv=fail; b=tOslyiBUf5ye5LS9CLnDqZ+nblvysN5X4T7N4L0DaFmtwB/T2PsJDZOaL/T1n1LR4MGDqGgIIQlYZ34bpP4VRI+P+f6tc1seUE9d2EyiLucMbLwn5vxW3xhTbjc7GkfchmqTnNfnhO/2kQ2WGE70KaInVyaRwCAOGDgaxNUb2ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772768984; c=relaxed/simple;
	bh=mUjVMGzQLPNMQbZ/V7AiuN+/tkVUC85jggL5Nka6qY0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m8XGD4+b9ESHdK4S5flRH/t+6Q3rMYprqOVClduySP+EXemrliuFhD0MnjVxZwGPtknAFUkkcdts478jFzWnvRlokYAJtmjeswt8yi2M7dZrgIvU0IiqJqW0R7/TCcNT2+4GiZv6tjV9WOIu2GGL4dzmn8UasiAFYU1XNzcaoZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=iayG/4dX; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ZtoehIQe; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iayG/4dX";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ZtoehIQe"
X-UUID: 7d09514e190f11f1a39cd589f645bc18-20260306
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=mUjVMGzQLPNMQbZ/V7AiuN+/tkVUC85jggL5Nka6qY0=;
	b=iayG/4dXGZLDV/SYocJlGFHz5E3ik6PJLNqNohtnH9sUY0H1X6mRABGaQWvkbQ4jt1xV5psVpdcgXKiAXPbOHUgr2lPdKTqL4oO6DtFiTh8+D7kZRFdP3bsQYOrPLEw0MYYeQEI1msOVB9vuLIm6lZZ3lNiXZUAlkVJwl8huw/A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:62983bca-84e8-4418-9117-aa760a3b58d2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:67f7947b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7d09514e190f11f1a39cd589f645bc18-20260306
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1005341500; Fri, 06 Mar 2026 11:49:33 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Mar 2026 11:49:32 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Mar 2026 11:49:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUjcv90JL3n86yp8hZfbEDmIEZ6ERSMSmE3jKfn+YqIc6dFgY4KEo4AbKZJubVynsQScIvmftrsQwPE7PWs6SKUEmf3Ey8i5kvgzUbAyfwJ5a9J1vGrHQyAc6x2OXhGMPwUkrLdg9xV8z56D6AEG8wnFdKMLtc/4uYZ//CRiItqb/OzUomWKhOwQWdl8Mt+fgCaPMJ4rcrf1mrcmVxsThQV1XH2kwwOnqaDGLmYcfyjiks1rOiIEluL6xn5SOph7dlWo/jjl2nyMnzLUhePbLABv8rAiBOFLWkM6cAvpdKStUXWCY8+wc020PkyGW3jXQn/F+CtAuvMBZujpes0RKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUjVMGzQLPNMQbZ/V7AiuN+/tkVUC85jggL5Nka6qY0=;
 b=SoEfLK+zN3wkiGzskl3FeNeCntRP3H6YdpVZTXZL5CQT+yWPXfDEnnElXGJpJJ/SuNGmOp/Ay4oEk2Mc8pV7I6F/aS6/aaLGl9ZQHlVnBlqWD8IrPl1dJeefouv57thqLchvZJMpsIVuJMCo32Aivc4CxagCyAcSOGdRkXF1QYb8d3ld1WkgTaxrJR0WcGyP+armijSUby8g6waf0AFOFZ282Wt4xRbf6qNIoRHPdu1km3JyXyEQv8P+5IiNZp1FfFkUfQC/OzKubgEu/ipzkMJwreaLZuh3uynEGYcJzM+gjjmhtfvN4BxT3V9HkTvePY2M6atnoUSRDFqYuqcNqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUjVMGzQLPNMQbZ/V7AiuN+/tkVUC85jggL5Nka6qY0=;
 b=ZtoehIQeLV54DA+ThdCZfjlY5MkRHTu9Yr/7Sd/90WUIEKRVeb8lRyCT07AwsMgrH7z9Czqg2HClD56SnjwTQ/jddbT/VIr3T6iVYWcEtwU/nRcj/1Pf4tMy8anOFiA+1PfS+8ICF+/Jtz9egcQ64tOehkCJEZBHk9eo29IZUDw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8797.apcprd03.prod.outlook.com (2603:1096:820:145::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 03:49:29 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 03:49:29 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "vamshigajjela@google.com" <vamshigajjela@google.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "arthur.simchaev@sandisk.com"
	<arthur.simchaev@sandisk.com>
Subject: Re: [PATCH] scsi: ufs: core: Handle MCQ IAG events
Thread-Topic: [PATCH] scsi: ufs: core: Handle MCQ IAG events
Thread-Index: AQHcqm6tlxTa2NfLgkq8161GkZ8vOLWcm0YAgAHf1ICAANBPgIAAkQsAgAEHJoA=
Date: Fri, 6 Mar 2026 03:49:29 +0000
Message-ID: <8b1faf1871c067c28e25f1248d0f358facde38b7.camel@mediatek.com>
References: <20260302180117.2797184-1-vamshigajjela@google.com>
	 <1fa500fdfbfff7d43bea1839ce1992fb4283c5eb.camel@mediatek.com>
	 <2cdc620b-b521-4058-a802-87591aa4c253@acm.org>
	 <151ef927de40cd3e663b816194761a029c07ab23.camel@mediatek.com>
	 <c18581fb-d44a-4aff-973c-27cdcc9683fa@acm.org>
In-Reply-To: <c18581fb-d44a-4aff-973c-27cdcc9683fa@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8797:EE_
x-ms-office365-filtering-correlation-id: b902e9d3-f82e-4152-6798-08de7b335ed0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: Qr+hQ1tCMMHgxCpsDHin7fJRUidPz0FeE5XwAowg5k71nyoEK+tiHvHDCF6vOhnK0m1lFfPNkz0x8TgfweBS1/B/vk5RIzK8yCDRuzvz5A0XUZ4TUhvrWkotjzau9tufa6ks50ZbVpbyx1kYCMs+ECUwXEXcEiAZ0BWBQOqCmOuRyqIGkvShpOwG85mKTtriZ1pf5iSi31cIsbG2gGyGdu8xyyVe7l6xX6jYibRjlpZWX6532SLKxUSEQa3PUiirMThhMKIbZORUdVlufz3F6VK2fOdZADSylJv9J7+04LH5orD3rUKKw4ozgmiuYiTRRLM49O9HH0x9dwtfb2UNrzxZx/5NFdOEvRgr8Oc/7ZuaN48PSDxw7mRoYlgyaD2mKhH/5+GKMQSD79oOJLPqzV64aiq9s2N5JmpwEOC5JRd4Q7T1uqaT43rCkCbgiB4AWzS6SrCiGpOsnD2/u6cHbIN6p875728ZJFiFslrNRvMJeAPRxoAmwCrhjPuWpIJjkg91KBJ3MLn0064wkitWgIE7OBEcrL4WijVRq7EbDVbBEMZC/g4cxtayH3UYgLc7e3TKP5kb3/G7e8i0otGdKqa2RNBjStABtQRfnDlyv59AqLTK6338ItcJX6ahakVi6wrhxkePA4xbhN1oZvzWtrr+bjojX4WnBDFm1gRfj0cPreFr29qFrfy1x5LVrWXEbxudsx80n3Qg6FjaV/twJCb/Ib7lgWE56ZHkX4EbFCS/o4hdFp/Ger1ZT3NyZJ1ONVIs8qWRRTOvgs3nEf0QfiXweNVMBV018Dg5B1ilA6k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aU1rQ3c5cjhzNER5WjNlcG1kY1I4NG9keHQyalBuNVczOTNkemVBcHlFVGVH?=
 =?utf-8?B?UkFWbHdzQ2VYWkJCcHU2dXh6cEVwUFgxc2NsVjFMMkJhZEJ1Mi9KL3ZCODFl?=
 =?utf-8?B?eDZBcExlRWlDSjFtUk9oZWV2c0NLTDh1eElDYXMzUVVPMER4S0s2eGxWQnZh?=
 =?utf-8?B?aC84bkNMY0dzRFQ2YXp1b2xkT1lmdC9HYnFJR0xZdURuTytPaWNTWUxlK01I?=
 =?utf-8?B?a2FpZHhGNUd2aHB0ZzlkMXhXNGRBc3J3aGh4NGFZb3ZaRzV2MmZ3dlVaKzh6?=
 =?utf-8?B?djBjNVhvSEtkZk1RSGhzV2pRSnViWHppcTFXMlhXNHkyZ1IweVlOQU5zSzdR?=
 =?utf-8?B?VTZBSEJ5aEZsTWY2bExDUW9sOWYwS0tXV3lQOHlqWFBIV3pvejlYOHdpZW1R?=
 =?utf-8?B?Um1XUkpXNU5PeFV4Y01yazV6a24xY3g1ZjBwemVQZ0h4UTZmQW9UMWN5MUxH?=
 =?utf-8?B?T3Z4Z1QxSGh5UnFxSUtEN1FCQXdUNGZ2d3NSQUpwL0pEL2NEVmdmc29oNk1Z?=
 =?utf-8?B?b3pmWStsVGhYMkxNWmw3bTEyS25vOTRnakNMYXlMNlViUDZRRnRZSTNVNHdS?=
 =?utf-8?B?V1I2cUIyZ2swUkZ6dVJsSnJ4REtLbS9QdS81T2JjaHBzeSsreUtYK21NOExB?=
 =?utf-8?B?YTNKc3p3QytydEZLM2p0a3pHNU9LV2F6OUg0bjk3N3J3bkM1WDFMOXBkT0lP?=
 =?utf-8?B?TDBweW1NMXJiNHBTMkFObjg0cEh4THBXRVhoc05zQ2J3b1dReXA4LzhQaXRK?=
 =?utf-8?B?aEpQYklxRDV6K0YrSXRFcFZXbkh4UDRHd2M5Z1NlakRueDlaWkVsNkVkUE1J?=
 =?utf-8?B?OEFGTDJBZGhXazZkSndKcWpaME5NRjFXaGNxRFZtS2lxallMNG0rTkNlWWVs?=
 =?utf-8?B?amFrYmtBK29PZjRrTy9lRnpiYVdUQlQwM1pkVVlwc2wyQ0RwVWU3Uk1OYVQ1?=
 =?utf-8?B?eUpoWXF0a1hqVEtKV3V1QXpZREJyYlFGdzFmR0w2eDN5Y0ZCMXBiazNadEta?=
 =?utf-8?B?QSt6N1hIc1g2c2FuN2tmNUJiakNBbURRMHZNcnhlVk41cnZ1WUR0Q29qMFNn?=
 =?utf-8?B?bXFLR3NYcVo4a29vTnUyY2JpTHpjd1h4VjhIUjBackh6V2pTRDlkSEtRSFJK?=
 =?utf-8?B?WWtZY2VsZXhEOEFQSm1hSUVwQWtKTkpYVVJhR2lYb1R4eWxOaXNzY01ZNGg1?=
 =?utf-8?B?bTF0S09KZXBJcTQwckx2Sm9KRTRRcTdweER2cEhGbDR2ZEtlMUluc2pNYUFz?=
 =?utf-8?B?TDUzWGVOeGk4clYwbFVxOUZzQnJwaDltL29UdDdDdlZGZUE5U2JSSHN6MWFG?=
 =?utf-8?B?WUJpR0dmQmxuZVlkZjFNWFpBYXpmcU94bnRvK2Q1WG81TlRMMVBkSzVROWp5?=
 =?utf-8?B?KzZPMWdHTzdYVVNvMVVnMThWNE9XNkRUMGloVFZxZ1djVlRiQXpqL01Db2x1?=
 =?utf-8?B?T0dsNjNNWG1MVFNBUG95Mk9MRmxERE1pcitWSzBKTjlsdzc2dUcxQW5nRW8z?=
 =?utf-8?B?Mk9YY3hnd2orZDV6NUc0UzFZOG1CdmhJU2M0eG5GQk5mVkxxM1p2Nko2UUcw?=
 =?utf-8?B?cGtiamxYaEJCVEl6NTBmZ1AzZE80VFVuL1lRQnNUMGUxeWg2M1JXRGZiZnJP?=
 =?utf-8?B?akJKejRTcDNNcE9kd3FMQUljeFpLRnZJenlpa2VTaW1UOExDNTlXUjhOYnI1?=
 =?utf-8?B?VXowK1NiWkZFclNQMUpiV2VmaXk4WTVsSFJ6aWpia2ZaakQzM212NXczbkFn?=
 =?utf-8?B?dytGT2JMa0NjeGlhM29teWVweWdEV0Nsbk1jZnp5dXh3dm9Pb3hnNkQ2LzhX?=
 =?utf-8?B?QUJoaDNYZy9HcXBoYzJVRVRwNlNIYno0dmlNL29udzluVzdTS1dWUXlMRzBR?=
 =?utf-8?B?Q25zZlBLalhvck5QSjhVWmZMaU1tenNqeTNaNjhZMWwwU0orc3JjVkluOHlr?=
 =?utf-8?B?NVNxNGZhd2pvMklTRXNLWjEvME5mY3F1Mks2SCtmWjhpbXVPbWV0UWtMc05q?=
 =?utf-8?B?V3ZCV3ExUUZhN3Q2WkdQcWl4OVlUc2lxb1QvMXZ0Y2dSMmhtSjFoMVN0ZTd0?=
 =?utf-8?B?YXY4TEZmWFlaQXE2QzZxSElFR1hkeDUrdVBBT09XbzBHVTJ2ajU5djFIb2xD?=
 =?utf-8?B?TytHLzhMb0RKY09UQ1pQVEpHWG1ZQ1RlSzhvcWpwL2xKYXlSc1oyMEYwV0N5?=
 =?utf-8?B?b0FZS29BV2p5aWtMUE1DMnNINm9lZXBRSXk0SjdvNnZvNWJtdHZ0TXFCVEtO?=
 =?utf-8?B?WHlIVzJnRTdIaEljRFFOcHBuc0N0aHBEUGZrM1ZoRXFLNkFaUEpmS1VjYU54?=
 =?utf-8?B?M3NUTGRVVDBObW1sZURQSVZnRDBETXdWWDN2TmRJZkZCVS9hUkdQMFhpL0NB?=
 =?utf-8?Q?0dAzD7994wO63Htk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F923518A57924459C8FF950CA8525B3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: h8ugKsrMQXPnE8WPK6oi9T0eHPRNQiIUlc6EIUkiUVdv9K+ZHIpMMglzaT7ZGLgguoDzr1gjR/i+jng1l3KYm7U+lSWZCGnlrPRkhTipWDCHchyX+LK4AS9kG36NcT58YG+d8+3uaD5pby4j8ZRxb9/4SkQGODlEB6FlBsjZkhd9s1x5itpR0f0fMOBgddF1frQ3BooXJs5UJtwjEYtoGe4+Y0IXeH8/SXNDgxNRuuIJMvi4AEVmGzy92R8X1OlHyOOYRfH0VagXIeVa26E0U2FsTNeeTLvsFU6n6j1yBp95axSuQZHGZ0NlsASafXrJQ34U2BB2Zsku4aqVgWC77w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b902e9d3-f82e-4152-6798-08de7b335ed0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 03:49:29.6721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNPwLhvbDsd8kqQkB6UIpEXA0/0Snbx/QS6exWEH4/wvneHtGeZAR+JeMiOQj70+mr/VgzNVYfp7Niun01nQRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8797
X-MTK: N

T24gVGh1LCAyMDI2LTAzLTA1IGF0IDA2OjA3IC0wNjAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGUN
Cj4gDQo+IEhpIFBldGVyLA0KPiANCj4gSXQgaXMgbm90IGNsZWFyIHRvIG1lIHdoeSB0aGUgYWJv
dmUgY29kZSBpcyBjb25zaWRlcmVkIGNvbmZ1c2luZz8NCj4gDQo+IFVGUyBjb250cm9sbGVycyBh
cmUgdGhlIG9ubHkgc3RvcmFnZSBjb250cm9sbGVycyBJIGtub3cgb2YNCj4gdGhhdCBnZW5lcmF0
ZSBkaWZmZXJlbnQgaW50ZXJydXB0cyBkZXBlbmRpbmcgb24gd2hldGhlciBvciBub3QNCj4gaW50
ZXJydXB0DQo+IGFnZ3JlZ2F0aW9uIGlzIGVuYWJsZWQuIEFsbCBvdGhlciBzdG9yYWdlIGNvbnRy
b2xsZXJzIEkga25vdyBvZiB1c2UNCj4gdGhlDQo+IHNhbWUgY29tcGxldGlvbiBpbnRlcnJ1cHQg
d2hldGhlciBvciBub3QgaW50ZXJydXB0IGFnZ3JlZ2F0aW9uIGlzDQo+IGVuYWJsZWQuDQo+IA0K
PiBUbyBtZSB0aGUgYWJvdmUgY29kZSBtZWFucyB0aGF0IHdoZXRoZXIgb3Igbm90IGludGVycnVw
dCBhZ2dyZWdhdGlvbg0KPiBpcw0KPiBlbmFibGVkLCB1ZnNoY2RfaGFuZGxlX21jcV9jcV9ldmVu
dHMoKSBpcyBjYWxsZWQgdG8gcHJvY2VzcyB0aGUNCj4gcGVuZGluZw0KPiBjb21wbGV0aW9ucy4N
Cj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNClNvcnJ5LCBJIG1heSBu
b3QgaGF2ZSBleHBsYWluZWQgaXQgY2xlYXJseSBlbm91Z2guIE5vcm1hbGx5LA0KdGhlIGxvZ2lj
IGlzIHRvIGhhbmRsZSBBIHdoZW4gcmVjZWl2aW5nIEEgZXZlbnQsIGFuZCBoYW5kbGUgQiANCndo
ZW4gcmVjZWl2aW5nIEIgZXZlbnQuIEJ1dCBub3csIHRoZSBjb2RlIHNlZW1zIHRvIGJlIGhuYWRs
ZSBBIA0Kd2hlbiByZWNlaXZpbmcgQiBldmVudC4NCklmIG5vdCBmYW1pbGlhciB3aXRoIHRoaXMg
aGFyZHdhcmUgbG9naWMsIGl04oCZcyBlYXN5IHRvDQptaXN1bmRlcnN0YW5kLg0KDQpUaGFua3MN
ClBldGVyDQo=
