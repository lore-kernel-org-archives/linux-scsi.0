Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456652F83B3;
	Tue, 11 Nov 2025 02:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762829196; cv=fail; b=TC3iX+zsxhRgMhxF1S6WyW4TtUwRtzlmDn7wkltGCVb5KKHVKkAtyP8aksfEufmFhChEALzqlqQDRDMw+OEeTOMsaStPS1bGCXOyHE8wjB2U0TwXIqIu9spM0DVceaUOflgLTsXBc8/0ZLIxzyU4Mpbs6M5J9q96bSSvVvrNNmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762829196; c=relaxed/simple;
	bh=/1PhsAuu33YSD/h/InF7ljSAdSe3yGuP3zP+g5Q8UPo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qI3Ps2U8XRMRP7+l2d6ntBYq4TyqFeVHAXbSBa6kA6I5t46TiZzCBcZYKOMy5W9dskVC+ztWlV4VP/t5/oHYUmOg8pc5aYIWDdKRu2bJbuOnOt9zdJbtbHLUb/UIwlvgJjmpMFUX7n1PWtc4cCsZRkU2PMiFa8kvb4c8gXFHvnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nrVSlyQZ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=iQddg+Zi; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nrVSlyQZ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="iQddg+Zi"
X-UUID: 9e48f89ebea811f08ac0a938fc7cd336-20251111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=/1PhsAuu33YSD/h/InF7ljSAdSe3yGuP3zP+g5Q8UPo=;
	b=nrVSlyQZh6GamlTW370G6CCts7fSa9Q5w8eNf6eDs24bkgrlmhv7PkCMbwadpWnzSgyNjsFEj5SxlXsu2KJw1TTTBSVZPqweHRiiR5uGQPMBhYyVW6dGvOhQQ0m0U/Xdy0RLz9v+LCLJxr8f1LUSxoUG7F7AFhpWyAJaa8O5F8Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:03c2c557-a24f-40af-9f4f-946db46b6961,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:5d3a8182-b6af-4b29-9981-6bf838f9504d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9e48f89ebea811f08ac0a938fc7cd336-20251111
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2038449809; Tue, 11 Nov 2025 10:46:26 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 11 Nov 2025 10:46:25 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 11 Nov 2025 10:46:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y14MF3P71C4HpGEBs9uhkTqJR6TMU92YRQ0NQdpfdPYY+D2IV8AZbpefRa59vIuU7VeK5jhT/X3tpUCQnS7uk8jYp7H4ZkUWiP467XWtMzTvqjjeVKrERtWx+5/YS7adotDWBv8u+H/SNssMI2ZG7uvlE5X4fxQfIaP10S1pro0JvVAErRyRa92zyHC8ZEuNhXHJ8kx5jAtKhY0oTp9B3Oy7Qtx+2poGr5wSqIoXZDrv3D+ecve4Rh5dLVVra5T9r6Tirg24Pm9f28zb90hOf1uJo4QrdW5+VJpTJwNHdUXhOSwPFx/8v9TP6hqOip76cC6+tmYFlMK1g9Bka9z2qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1PhsAuu33YSD/h/InF7ljSAdSe3yGuP3zP+g5Q8UPo=;
 b=rHl+n+j9eSRkzBmnY/ShQ6UlyJV4JPz2HZS86DNsdBSq33qOZnCDo/h8+fzncQNeMZ1VLWUoDWMaldwxMXWkywzyVs0g1GFcmVyEWVIF3vbkGT8Qgtx5E++5JPvbzdgKs1+xz1mQP1iX4mDxqwlivTQdQBX2YGF03j/az/5D8XhHkIm8sS6vkcjV95JYYPIAimQh6FfG5nCZLromtHtZBL9WI/3eEOxE97CnpxAzwn9IkCCJUajZujiFfxPn8bBC2mR/jghPV0px3gEMccnCPNksaqJBJPoiTDW8UiXc9wzlc6QwEm5dsvdbHkvzLLkB11NGB3ZwdRdVdYPBSSUYlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1PhsAuu33YSD/h/InF7ljSAdSe3yGuP3zP+g5Q8UPo=;
 b=iQddg+ZiD+7au2QIIv/0Rjkc2fEV1ABSluxllG7wLzdz2nEFZqM1Y7unoxUFqy/MBCAmgJ2HRLR0pi/ve54UiQ3gMnQoK//RIIROOOH84GtupVPblJNvwJGf44GL45zkrcIH7ptFmE/e7Wn+YsggvNS07fCEWz8Mx+3A+3Wgobg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7586.apcprd03.prod.outlook.com (2603:1096:101:144::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 02:46:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 02:46:22 +0000
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
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCA
Date: Tue, 11 Nov 2025 02:46:22 +0000
Message-ID: <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
In-Reply-To: <20251106012654.4094-1-sh043.lee@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7586:EE_
x-ms-office365-filtering-correlation-id: c283230b-8715-43eb-a508-08de20cc8009
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bmZ2MktRL3dEUTErenFXWlFOZ2R2dERKTjRDUE51MC9JVHRwc25pdjg0VUoy?=
 =?utf-8?B?UXNuUU1iVzU1Vmo5VnFpKy9lL05uM2N3bUFkSXlQSXJDdHJvVmlXZ1lyS05Y?=
 =?utf-8?B?cUNEdFVtNXZ3cGhiVFJmMmkrNStYN2NHN25IR1BteUs0dlptSThqQnBnenBr?=
 =?utf-8?B?LzNmcFoyTG5GejdESlJGUnl1aEQyWGtHMHRpTFMzUnF0ZHY3VzJPNU9iR3JN?=
 =?utf-8?B?emVnQ0hna3FvNVRVNExXUy9JbFd4TUhLdm9GNERNQk82elNjWmhqU04yVml6?=
 =?utf-8?B?L3UzdFBKYjcyUUhCcUNwVFdjNEJZNktHclh4Y3EyZENRVW1mRFBHb1ZIb1Q2?=
 =?utf-8?B?YnAreGltdjVPdEFEa0x2ZEVJd2hWRjVDWEp2T3g3bUJCZ1FhTkV5aWF6dC9a?=
 =?utf-8?B?ZTFycCtFZVkvMnZ1UVZrQTdNRkZHZVUya1BGTlVSckVGQTQ5dWl4VHlBSDdp?=
 =?utf-8?B?SkNCL2NPOURiOVovWmhnNTRUN0xsWGMxdUlmd3FNZVdZYlI2YWxpNmJOME9M?=
 =?utf-8?B?c0N2R0k4aHM5M2hDdkZ6dW9xOGwwUFQvb2xyeGlTeWpUdkYySWgyNWFnbnBU?=
 =?utf-8?B?dkJ1eXF3eTNBa3o5aEl5T04za0ZBVC96ekd1OGNXZXNLbk44T21DbTlCQUZk?=
 =?utf-8?B?K3NoR0JHa3UvZDVMMFVpRFJXV0ZRVmhpNWZOUFhMR3owVmtoUnZVbjljWDlt?=
 =?utf-8?B?RnRVRGJHcVFtTzJ6SVp4Z0xjbXVPTHg0dGt6a3U4UmFtT2xDT3Q4QlRqZ3JF?=
 =?utf-8?B?bi81ZDZxZ3JsOHExVUFJVXdKOTBWQnFpMjQ1WHlyK3ZCVXl1LzhEbEt3V21a?=
 =?utf-8?B?MDFadHJ6WC91UWdPVFFEdlZxUmNjNWV5UHU3Q2JIZlAraXVjWFpDVVRPQjlv?=
 =?utf-8?B?b2lEc1F1SDJKVjZUbGZYUU5IV09TM3huL2hHVHEva3NqUXBVQnpPQ1FrVlZo?=
 =?utf-8?B?enZRY0g4SnUrQ2o5Y3Q1dTdEMzl6UjRmbWt4bjI2M1FGK2g3MFZzY3A0WFg5?=
 =?utf-8?B?U3lFWEx4amJlKzJ1SWRNK2kzZFdXek1JTDZUeVQwRW5XL3FVRHRGZjJRbGdv?=
 =?utf-8?B?T1lyRU54enlyazZJT0cvQzVSK2czUzNzV21EQUhWR2NGR2Y3VGMwbXpuRUc2?=
 =?utf-8?B?eXVGVW92UTRKd1VzWUgxaGU1ZWRoT3V1OXFlWFB3akxsd1FCYjNMM1p5Rmd1?=
 =?utf-8?B?RS9ZNVFzSUFzZWxJUVl0Y1FvVCtKODF4dTR1dHVObXlUZFR5RlJkRW8rMkc0?=
 =?utf-8?B?QUhpSHd5UWxJcVFmTTBtL0syM2FjbzlMNm9BdlU5cDcwVE4zMlRsZGJVeDhl?=
 =?utf-8?B?RTVOMzBoUU00MnhVNnZXMXdGRWUwejF4cUxySlUvRHptRTd4L2hUcmZnWTBm?=
 =?utf-8?B?cWZMdVg5YUxwS3pKZHYrL01wRXNxME5MSGJaSnJyckRxWTl1aVd1eXBGSDNP?=
 =?utf-8?B?Njhsb08xR2pyZlBDMy9lRCtlSzg0YzgxM1hFR2FuV0lUZFkyUWNSNjJKYlIw?=
 =?utf-8?B?WVBUcCtUUDRlZm4xU2VtMEl0aVQvZkRGNFJ4ejNlOCtValJ6TGdUbUUrMmFG?=
 =?utf-8?B?cnhFUmF3ZlpYZEE3azhxK2xGT3J3ZDg2M2NONjFOR3pzNFAyaWNTY1c3b2pE?=
 =?utf-8?B?R0crVmhUNk5STXlHN2hTM0E0RGxQZVovQjQ1RGZhZUw0MW9YYm1PbWtMK3JV?=
 =?utf-8?B?MHJhVTdTMWNUeTdLVCtzMDE4RnZsUHV3a1JZY0ZvNmFiOU5uRDZHcHFKYXE1?=
 =?utf-8?B?K1JSREJwWGZCdWtFNEtGSXpQZURJTkUyQmRERHZUcnlibnZKcE1OcHRZb3Zy?=
 =?utf-8?B?NW83ZHkvcnFWMVRPSG1XQW9rcVlYakNuNThtYVBYRDhEaEpBclF0RjdVOGlq?=
 =?utf-8?B?aGsxdjdpZHRXZlYzNGdxVEI2UFFWRzZsTjNEa1NuRnpvYjIxR0pXYTkxQmVi?=
 =?utf-8?B?KysvK1RiZDR0SG96Zjg2RDkwaitWbW4wSDRJMjdLa0h5NTM4ZW5vVXM3K3U3?=
 =?utf-8?B?eG4xZG5tSmJmUUNXU2ZCbE1CeERCajF4L294OHpZaHM3dy95cW8rdXlLc2Qw?=
 =?utf-8?B?ZisyWG5VTDR2cmVDazl6SzYybUQyRllIaFl6UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1dLNzdBVGpCd3NqK3orNlpYNFNqQlUydmJmbkl4VVNKbkx6Z1VQRmNmU1dD?=
 =?utf-8?B?bW5tOUtvNS9FTS9jYzVLbVhCZlQ1aXc3RWl5L2JoUC9OalJRenFUa3NoZWVz?=
 =?utf-8?B?VDY3RGxCbnQyWFZhRUk4ZlQwcmF1T0pTVkdJTmtWc3dKcGp5aElKdGQ4MDFC?=
 =?utf-8?B?MlZmbDZVWmphSUpwUGVKT01lV0Z3eXdSSEhxOVBZNlhLOEVzRHRaMElyWnQz?=
 =?utf-8?B?cldvZ0diVGY3WmdyTEhqaE5ZQ1BMN0xWVDhVUG5jOFNiVUpSdUpUUmNMZzV5?=
 =?utf-8?B?UjNOTGJHOGZPVmpDTkFValpkWVZ5SXB2ZC9SZDQ2NHBGS0ZUUGhidDBhNW1X?=
 =?utf-8?B?Uk1INXpsNXY1WEluSDR5MTRudEQ5NGtEYytFY3drYkpRaFdzTnBKLzd6S3A2?=
 =?utf-8?B?MnRUenljcVo0djFVNzZrVTJKeVdJaDJOWHZmSERhU1pacXVCSHpzaVlZb2pl?=
 =?utf-8?B?U1VMWmk1ZkJZc1hnOXpYMDJ1Q1p4M1hoMjY3Q041SFlWbnJqUS9JMUdIZkc4?=
 =?utf-8?B?VTgvZVcvVm9zWXF0SXBod096QUZZMFN6WGpRUllXNGplZEw4ME43akIwditu?=
 =?utf-8?B?dXlBdFdsaEoxNGU2OTlvRUVGSVNqbnp5bk4rUm5TcmNYU2crV3B6aGRQM0NB?=
 =?utf-8?B?eWlGZzVuMVBQOWcyZW9QcldtMUxid3Rzb2d3eTlQVUEzTlpneUF0ZysvZUQ2?=
 =?utf-8?B?TW16dG9xL3lEM0UzUTFpVTNuY3VhNDhTL1pES0R6U0hHK1UxSVRUeGNJL0FB?=
 =?utf-8?B?WmUwcXY3OWpjd0pqNStTZDV4cVpUTElVWFhrdXUxSW5RR0JkS0xyeUZoQWho?=
 =?utf-8?B?Wi9lYjgrd01lWEtSK0tiQzhJQU9LeFVBbHRrTUxUNnljVkZXMm95T0xuS0tV?=
 =?utf-8?B?WUc2bXVCL3F6ZkVKYjAycFB1UWpGMHZMVjcvZWtZMllVZi9SVm9iTmFKSzNt?=
 =?utf-8?B?UkJMNXBzdFRqUHh1c3YxTWpQRmhVWk1ZOVI5aTFYSCt2a0N5ODFLa0xyQVlk?=
 =?utf-8?B?UjY3WmhvNXgzMXJYNDBzOS83WHVCbk11UWZlY25SSGVTbnh6Q1IvY3ZyNzh1?=
 =?utf-8?B?a3BEUFVMRitKNCtJQzJucGt0Nmw2c1EvL1FjdXBhTzY5UlpXRTczSEVFU3ZY?=
 =?utf-8?B?a0UzeWpETVhWRGZwaDhIMjNpRTd4NTlJS0NMQjNWZXBpYXdKS1B4TTBCczBv?=
 =?utf-8?B?Z3liaWZSaXgxOHZ1WXM2SzcydmIrVE95c0RaK0hUTEFBNUpWQldaUnl1K0lk?=
 =?utf-8?B?S3A0V1p2UHg0VU9sUk8zN1dyTDArWGhyeFJ5N2NUYm9DOEt2QzBIK25OeWJD?=
 =?utf-8?B?YVl6UVc2anJoVmFJb1o4WlNhdnFvK1gvdjZpalNvMHpIYjBoZEp4N29hc0NZ?=
 =?utf-8?B?aytSYlc5VjhWbmo3cy9mNzc4Q1lyQk1HRFpBZWt0TzdjVHEyMTA4UmVObzVN?=
 =?utf-8?B?ZDE5Y29MNk5FcitQZURlaks5WjQyQWY3N3B6bGJUcnR3bWI5RjY5K3JsQng0?=
 =?utf-8?B?Vis1Mll5RVptMUhCUlRZNXVBS213L1BSTmQxRzZ4TE9iQ1kvN1cyZkNLYzhp?=
 =?utf-8?B?Um1aUU1UcGVaaTM1clROSDlNb2k2R09MWjZyd2k5WDg0MHFvTlB3UVN4TlVq?=
 =?utf-8?B?RGEyZjEvRlVwNjdqZkFZTDZOOWt6dVhKNThUdWFoMUdCQW9SL29wYmtJN082?=
 =?utf-8?B?ZnA0MU12bktIUVpkVldhUVZvSjN3MVlVTDdSN3ZTM1VkZFY4SGsycXlXOHhi?=
 =?utf-8?B?d1dLWVF3dUpXVEFpMTdhUGxtOVAyTGtpbWxMaUtvY3Q3V3F3RUJVZUJaWUEr?=
 =?utf-8?B?akNPQmJ4RHpSUkVhUGFQUzJvREtlQnlOTUdGbHRGb0U1YTdGT1VoQStodTdm?=
 =?utf-8?B?VTRVVXBqT0ZrYWFtclJUeHpjQXhuOGEzQnlqaEtKWEZkTm5BbWczV1ZKRVQz?=
 =?utf-8?B?d0kzVUJrMmdsSm1lUFBEdlQyOG1LRVVPQzlBMDRPS2ExWXUxSFJ2aVNrSjQz?=
 =?utf-8?B?TkY2TVhVQzJwUU10ck9zRk1Hd1FLMnErRWRqeTBISkl5UHQwMFo1dWxBZmk0?=
 =?utf-8?B?cFpGbHdGWUc5VVMvWG5aMUVLMklQdk1OejZEYTBPeG11alkxNmN4S3BybEpC?=
 =?utf-8?B?cFhzdXZTeVNIWmZMYXdzUVBaMk56QUxzczVtMTZnakRuaTgrZXlUY1lHRVlw?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <595EC242D0B51A42BE9A1273527D87FB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c283230b-8715-43eb-a508-08de20cc8009
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 02:46:22.6524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lX7Q8m6zJguFKM2lHbcP3KqrTMJIgYolbQklo9/nX7xLrKlybFL0qKtqYw2s7g6a/nc3zKW/FseDOLiYsik4bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7586

T24gVGh1LCAyMDI1LTExLTA2IGF0IDEwOjI2ICswOTAwLCBTZXVuZ2h1aSBMZWUgd3JvdGU6DQo+
IEN1cnJlbnRseSwgVUZTIGRyaXZlciB1c2VzIGhhcmRjb2RlZCBUTV9DTURfVElNRU9VVCAoMTAw
bXMpIGZvciBhbGwNCj4gVGFzayBNYW5hZ2VtZW50IGNvbW1hbmRzLCB3aGljaCBtYXkgbm90IGJl
IG9wdGltYWwgZm9yIGRpZmZlcmVudCBVRlMNCj4gZGV2aWNlcyBhbmQgdXNlIGNhc2VzLg0KPiAN
Cj4gVGhpcyBwYXRjaCBhZGRzIGEgY29uZmlndXJhYmxlIHRtX2NtZF90aW1lb3V0IGZpZWxkIHRv
IHVmc19oYmENCj4gc3RydWN0dXJlDQo+IGFuZCB1c2VzIGl0IGluc3RlYWQgb2YgdGhlIGhhcmRj
b2RlZCBjb25zdGFudC4gVGhlIGRlZmF1bHQgdmFsdWUNCj4gcmVtYWlucw0KPiBUTV9DTURfVElN
RU9VVCB0byBtYWludGFpbiBiYWNrd2FyZCBjb21wYXRpYmlsaXR5Lg0KDQpIaSBTZXVuZ2h1aSwN
Cg0KVGhlcmUgc2hvdWxkIGJlIGFub3RoZXIgcGF0Y2ggdG8gYWRkIGEgZGV2aWNlIHF1aXJrIHRo
YXQgDQptb2RpZmllcyB0aGUgdmFsdWUgb2YgdG1fY21kX3RpbWVvdXQ/DQpPdGhlcndpc2UsIHRo
aXMgcGF0Y2ggZG9lc27igJl0IGFjdHVhbGx5IGNoYW5nZSBhbnl0aGluZy4NCg0KVGhhbmtzLg0K
UGV0ZXINCg0KDQo=
