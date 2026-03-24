Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F0834889F;
	Tue, 24 Mar 2026 07:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338404; cv=fail; b=X56+XiNS2jw4BEhda5a6DvYxB4to/Yi0DDXUbajgZjlvftzPWxtir00ucBQ95Qn1R2GXYTwCxxDs7F6h2yDC7nAOdoYqtgeu6Ni4E45KpnUVSple/OYG5L13YzJyX2SenlNRBwCBIi83uwCWsUSd/gOZtWM8qcQoD5VPlef0FhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338404; c=relaxed/simple;
	bh=jLucIy11VUVVd6mj1SigU0ji3kvuwPIYm7dvfLnlW7I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Giy12/Oel9RdtykfIX52s6tWCn710OwhvagebcJSAFtytIxu7Yb7W4TeVTox9ffLjGF0HE7uD1Adz1u/w3JtamyxqvA51TyZ8eT4tnTFyOd1cLzSXMz3Ix6WuoQ8ULnljht8TwD5Sm7IZBArHIU7fXL1PuH1hMdGpDY7AhFCEcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XgVk9F2f; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=uw4uMFHO; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XgVk9F2f";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="uw4uMFHO"
X-UUID: 9043720e275511f1a02d4725871ece0b-20260324
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=jLucIy11VUVVd6mj1SigU0ji3kvuwPIYm7dvfLnlW7I=;
	b=XgVk9F2fYyr6kLc2bMnoEX0sWEd1Td+CethTp0BKqsTYthEmcX9j974ttmJLXAi/c/miIffRduOxPFVDQWp+cyBqFpjd1PgpNsQ6pIn220r9dpPxTXlH1HA830VhkccmlvbInebCcz+09f3bTC1viBWWm26XRlSzpA3aKAI5KRE=;
X-CID-CACHE: Type:Local,Time:202603241546+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5d8cdb30-39b3-465e-9752-d498aae22df4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:69032594-f8ef-4ca8-bea0-143568f9ca1d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9043720e275511f1a02d4725871ece0b-20260324
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 278871859; Tue, 24 Mar 2026 15:46:27 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Mar 2026 15:46:25 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Mar 2026 15:46:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tRY8HxyDxQb/odY1cmWp2J+LYlEzNQuG5e3q2XYXltOLuP/uKImDXUvMJDI9y+5DwiF+REYYR9x+NsYasdnIAbhvNEi+DWIm1hmteZSDoYjneYc277v9NokotvVQwcH7luCgta7Q8pQ1aZADVMjuZOFDKFpuUvemI9hcw3fcXRc+fL3bFhBIiy6LsxjKmNTb0Y/CBsl4Rpcc/pPp+0/gquMdzphfz6mVktuYYwNDRAceOCZYcHW5obdu1MPCk79rXEVIxpKleyxrOJW67QRq8nGCz8Pu98R7mx5UjWUe76luezLivvSPTlya6OCDZND/2yccU+tEEDnp8K/Vy8JUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLucIy11VUVVd6mj1SigU0ji3kvuwPIYm7dvfLnlW7I=;
 b=mfsEjqSo8+XS7c7oODK4AHWBlBUGFrUM57Xzu1GyjZDyJRPtGTj86Y5AvWhNg6u8qn6ofJiHAoI8zM27JVmtGQwd3pCgSMXPyR0QDRZF8V51c0P7WEeMluzrgLUU714dyCWtyRrM+e33tbfMDCxFj01ENgkCvUtHbOtDfd7e10FuomMrGS8kp34fScv/J2ICGqkOFRkNX300GMGms9+H8YV3oaduQq+N6hF3pLwMyH8inHUvIYmazMkhExydA0yCT5XkNtWgG79Q2Jl+MgwF6LYi/SL/7GEeQ9Yw6MkrrJPrioWYOpeq5/8/pVeNiSqqMQNQ7LJlb3UZjhAahlObaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLucIy11VUVVd6mj1SigU0ji3kvuwPIYm7dvfLnlW7I=;
 b=uw4uMFHOSL1t1FY8wxS8x1+kOX/tBjwmCM2PZo/eK1ZUPXsA9kyzyTIrHfxei4qNwLav8yoJhfo7yl/JAXreXSwlPivydredxpiW3cIw3hAVtnL1A42FLcIpMrwnZEPl9KuDuR2nC03MX5z8BlNhTsjvGJbXao8qzIgLhGLYnXk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB6458.apcprd03.prod.outlook.com (2603:1096:101:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 07:46:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9723.030; Tue, 24 Mar 2026
 07:46:21 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 04/12] scsi: ufs: core: Add support for TX Equalization
Thread-Topic: [PATCH v4 04/12] scsi: ufs: core: Add support for TX
 Equalization
Thread-Index: AQHcuODketpeGCnm9kK0h5TBPTGiD7W9UtiA
Date: Tue, 24 Mar 2026 07:46:20 +0000
Message-ID: <bf904a137c1a3b8f6ec0dd712e15611155ce3e11.camel@mediatek.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-5-can.guo@oss.qualcomm.com>
In-Reply-To: <20260321031021.1722459-5-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB6458:EE_
x-ms-office365-filtering-correlation-id: 67ee3795-ecf2-491a-63fc-08de897970bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info: Mf2PWahGcO/3Gu5JI3Jt0JddyKfZ5ZlSUduHnVdJ7dWh8qzUFfvJP0nAn21is+/E/XoLi1JmMZwRPgrZRIwnA8kxJnLOIgnzZHQj5V2kf7GEoRFTPNi4y+dVZ5ZCE63AXshoy5yRVtUpXwzia6wvwPrt0jnlymWW3+G6qXhvtufBJDwazjhBh2GXB8eIzj/bW/Bkiw2Hgj+WYakyu9B9hOLWAaFHXNrnGcguKOXWdYKLeVnVNRDYziHC/TDcGyFs4fgYjiNEjW+dFCdbiivO4VHgbQEyQohcHvkkyuyMTr3DEVnBkugZgWfhCcfEcv7odh9l/BJRkptyWasIFnQTvEorfhRERcMpURJRKHMydw0totu8or29qNu6zBt8C+UYdefDgpDSKxzrHqMYpSj8fcbyH+Lt3/ylPKa5O3vyxhg7OkAjOyKJzyGeOPCkZ1DHVuNRAvnLGdFkbeAC65ZsR240kmYtV0nZ6xpTMMkgxLMnEEGY1+XxfSNs90KUc8uSkmyGLYqxi6CtE7ovGRHY/wOibu7KR/CI4jinxyFZMl6nj6XDBQ3Mm7D81XLJnXstO9lZPl41A0/yeUUhZUlraWIO7pAkTE73np2DRn3Xa4P6oWmrJon+Cnqy3Kv1FlVUCnvb7rXoh+0wPkgqbGouFWJjpknotHm2ghwc5MYjeXtqXfsjVpRJe/SDffM3/RNnaL7WpXOE3J1D9QVmmyC3Yws56OhlZyzdB53/MyvuSY8Qi91EYxw94zrg3I+tpZUhfLv8HrRserGfDWG9dg32NVUZrH5qRC1Cuwbdp3yd7Ow=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkN4TGtCWW1KV1BoSHRYdHExc1k5cnpMNnlpSTVpODg0WkJkNkpHbUtXTjBV?=
 =?utf-8?B?dFhwek5LTjNzT09vTEVGcThVbm1EYmg3TGJ3MHlCQUZZVHVVZ1o2L0R5WlRD?=
 =?utf-8?B?dXVDQ25xMXJDL0RTTTRCbmhnZ0RCSlJaV3JLd0IxN2hQWUtES1dFVVJ1UDln?=
 =?utf-8?B?NHpCMnRKQ2RBdXRDbFVRb1hVVzgvT25KdmVIM1kxYlhxdGpvWVNlcGJMcXJK?=
 =?utf-8?B?MFp4MlkzYXNxUDBVYW5FZVBydW9vaEt1VjNhQTZpWjBQcXp3NDZKcWNzendD?=
 =?utf-8?B?cXF1OVVhdW1hYWI1dG1EdlBMMG9KZXdISUhJUUc5NVZLNXpOazBEWlZTS1pJ?=
 =?utf-8?B?Zi9PRXIreTBwTnNSZXp4eUVzcWlWdzJCNjAxdWFGVmJ6L3RhZTZnSVhnVmV4?=
 =?utf-8?B?c1VCUUNQaGd1cldmSEx0OUdaYzJsSjIzVlRJUGNaU3htVXF5MEVneUVtM0hl?=
 =?utf-8?B?T3ZnUUpHY0FBVENuQjFLalFlTUxzSlZoUjE0VG9SUXdTeUpVMkxWV3hlamx0?=
 =?utf-8?B?Z2gzZkplM29jVlcxSGRKQXdSeFVqMWcrQnYxRXR3dkk3eTJpaFlyQ2RhMjcv?=
 =?utf-8?B?a20zd2RXb3N6VjV0NE0zOFJXYzA0VW4yby83SDFBSHRXY0MwZFhCZU5kNi9H?=
 =?utf-8?B?eVRjR3J4WjBVWms4RCtkbmF1OXFmWXNVYmFnQ3JKSW50dkdBcHducnpiQnVY?=
 =?utf-8?B?cjZFcFk4SUxIcTJOWGNkd0tzaXo5Wm9sV2NwRUtDaHczVG0zaWRtSjhLRXdW?=
 =?utf-8?B?UzkxczhkSFp0WXJCQmpodUlEUnBTakVxRFgvRVJCNWMzY3lSb1dpT29nbWd3?=
 =?utf-8?B?dG9meTJwTWlTdXJnd3JpdGpKaUVrajdaalBTM1BuYitHSGFXYmV3NkJPSjJZ?=
 =?utf-8?B?NVJJU1F4eUhxbCtxUzdEQkRQeStMcDI1OXl3d2Q0NkNvanR1MU51QndvYUZB?=
 =?utf-8?B?TUJjTkZVV2g5WUJYREUzOVl0VjJKUFBscW1MSzlCcGk4RjJvK2U1a1dzbmZC?=
 =?utf-8?B?Q2ZMcW1sR2NDR2FkR2dreTdBTGtoWjNwRjVQT2JhWHQwVGJQSkxoaEtRdEtv?=
 =?utf-8?B?L0dJYkVNQVdjamNsZUNBMkpNODQ4UVUwNDBoWC9qNmpCK1RFdUFFaWJMcmZ2?=
 =?utf-8?B?MkltUEZWNWVxK1dzQm5DYjdFUUxtLzl4cjI1b2dRTlpMc0FIVTEveEorYUFt?=
 =?utf-8?B?UitiTEI3Q21OQmtXTGdSUVlhNFY2N3AyODlOWjBIcm5USnVCV2pnV3FuNmlh?=
 =?utf-8?B?T05CQllPUm8xaXFmYUpNWlpqOWJSU1dZVTBoa2RDL0NEb3hDazl4K0RvUmtN?=
 =?utf-8?B?RHN4YVlVVVVMdkVYU2FSY2dEODlFWkZEZDhiTzh1bEJ5bTZ1ZHJEdi9ONmth?=
 =?utf-8?B?UGZ4THhtblNTbjBrSWR1SjBDeDY3RFA4c041dTdlMFZpYWVtZFVYb3pQdFNY?=
 =?utf-8?B?Q25wd0NHTHVwZTR5d3NNa29UaDdHUlluYkt4cXloR3kwLzJNY2NLY0NsZnA3?=
 =?utf-8?B?YXdBczNJNCtrdXRFdXYzQ2E2Y01CYm8rTHF2bVlvaDMrRUNPeEU0T1Zqa2xC?=
 =?utf-8?B?ZzhNeit4c0llMUorMTdKL28rNnROOU03MGg4ckxLVDJvWU5Ec2RhaW1yWk5B?=
 =?utf-8?B?dHlJREpQeTNEcTlnSmZlQWxURXRIZVUwUFVLV1d3SEFwbWZsb2xJZUI4YVBw?=
 =?utf-8?B?SHZwZXZGN21Ed20yR1dvVFA5N1pRbW05ZFRCSjM5bFQyVjhmblFmNkNYakdU?=
 =?utf-8?B?Q3p2N2RBeTBURkVRNXZLbFUxUHpVdjBUaXE4eVIyYm0yRDNUVXpoNWtBS0Rt?=
 =?utf-8?B?c01VZDlpSE9JZUN4Z2hUUS9wQkF1SjFZRXBLMUpsQ0tBdzc3Z0xNRythbFNN?=
 =?utf-8?B?QWtIa2pIM3A3a0hZYmJRL3RwNzJUZzJ6V0pwMzZ4YkR3ekltWmlWekN2aERw?=
 =?utf-8?B?MWtieXExYTZVSVpJYkxWemNKY0s2OTFaSDh3Mm1Db25meXJQUG1KeG1XSi9I?=
 =?utf-8?B?OW0rb3RQK2FKRjIyaDlOMmFBY0padEpJNm1kZTdPK2k0YlhEK0xYekJCN0hR?=
 =?utf-8?B?VDVUZDJTMU1QK3UrYTJYcVBWRGdhNjhZTWw1SFJhVU5iSFdnWHBob0JnRnVT?=
 =?utf-8?B?bm14ZWxUM1Faa0g0VkVtOTBQdkNqSzVOOFl0NzhEaXhkMm1YNjVLVHFrbXRh?=
 =?utf-8?B?Nk9ESEJXaDVGWUVYaytKaFg3MTA3dlRYS2liTng1UTJjTDlqKytJd1R5d3pZ?=
 =?utf-8?B?UTAvTThNRThOUG1QTnRjeWhsYkZOVmtEcWhWaStUanFSNXZCUTRYc0ppQWRX?=
 =?utf-8?B?cDQ4Zm9yRE0xWnFIbGRhV0Rva3VqVm54Q0RqT04zN2w2NmJUS1J1YVZsMTRJ?=
 =?utf-8?Q?v9W6XVu0Xfc4ng5Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D88F82DCA7EA3D4B858FF21CA25D0965@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QrBHoNqsEdE1LgbvzzhIwBfKpiPz0SVo24qH0DkvX6ughpr0aYnOD13Kv9Ua8jDQmD/+UBfhklOK60SqcD80nTyy3bvr8iPlB7FLE8XWkj6bDPvZhi/Mi7iidDcavqinpln6boPoIO8kmdWUpVW/x5LG51kQwT9SyPHAlc0/jS8iN7NnGBtGqtrC9cMZewfLgzILx72pHHwZK7KYuITlZKe/0j3K5bBLqBmp3PXEl8oOmae8digG6JcnpYssvvwGnlLnZuL06BYaRoZBMeWgojSpDNdqIMmwWdZb2QY7VdN64cX2FS6R+DjQlILw7i60ce/wxx2nWa9TIaYSxVSmAg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ee3795-ecf2-491a-63fc-08de897970bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2026 07:46:20.8340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l+hgblWokmQfCUTimXEGUv+mtQ+//ctUVScAmeAPzet8S/ik1CmCxI/2sU4kv3meL1fzyKllMIqQX5TtRLGRuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6458
X-MTK: N

T24gRnJpLCAyMDI2LTAzLTIwIGF0IDIwOjEwIC0wNzAwLCBDYW4gR3VvIHdyb3RlOgo+ICtzdGF0
aWMgaW50IHVmc2hjZF90eF9lcXRyKHN0cnVjdCB1ZnNfaGJhICpoYmEsCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgdWZzaGNkX3R4X2Vx
X3BhcmFtcyAqcGFyYW1zLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc3RydWN0IHVmc19wYV9sYXllcl9hdHRyICpwd3JfbW9kZSkKPiArewo+ICvC
oMKgwqDCoMKgwqAgc3RydWN0IHVmc19wYV9sYXllcl9hdHRyIG9sZF9wd3JfaW5mbzsKPiArwqDC
oMKgwqDCoMKgIHUzMiBnZWFyID0gcHdyX21vZGUtPmdlYXJfdHg7Cj4gK8KgwqDCoMKgwqDCoCBp
bnQgcmV0Owo+ICsKPiArwqDCoMKgwqDCoMKgIGlmIChnZWFyIDwgVUZTX0hTX0c0IHx8IGdlYXIg
PiBVRlNfSFNfRzYpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfZXJyKGhi
YS0+ZGV2LCAiVFggRVFUUiBpcyBub3QgaW1wbGVtZW50ZWQgZm9yIEhTLQo+IEcldVxuIiwKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ2Vhcik7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gK8KgwqDCoMKgwqDC
oCB9Cj4gCgpIaSBDYW4sCgpUaGlzIGNoZWNrIGNhbiBiZSByZW1vdmVkIHNpbmNlIHVmc2hjZF9j
b25maWdfdHhfZXFfc2V0dGluZ3MgCmhhcyBhbHJlYWR5IGNoZWNrZWQgaXQuCgoKPiArwqDCoMKg
wqDCoMKgIHBhcmFtcyA9ICZoYmEtPnR4X2VxX3BhcmFtc1tnZWFyIC0gMV07Cj4gKwo+ICvCoMKg
wqDCoMKgwqAgaWYgKGdlYXIgPCBVRlNfSFNfRzEgfHwgZ2VhciA+IFVGU19IU19HRUFSX01BWCkg
ewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9lcnIoaGJhLT5kZXYsICJJbnZh
bGlkIEhTLUdlYXIgKCV1KSBmb3IgVFgKPiBFcXVhbGl6YXRpb25cbiIsCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdlYXIpOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+ICvCoMKgwqDCoMKgwqAgfSBlbHNlIGlm
IChnZWFyIDwgYWRhcHRpdmVfdHhlcV9nZWFyKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIDA7Cj4gK8KgwqDCoMKgwqDCoCB9Cj4gCgoiZ2VhciIgc2hvdWxkIGJlIGNo
ZWNrZWQgYmVmb3JlIHVzZT8KCj4gK8KgwqDCoMKgwqDCoCAvKiBUWCBFUVRSIGlzIHN1cHBvcnRl
ZCBmb3IgSFMtRzQgYW5kIGhpZ2hlciBHZWFycyAqLwo+ICvCoMKgwqDCoMKgwqAgaWYgKGdlYXIg
PCBVRlNfSFNfRzQpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBhcHBseV90
eF9lcV9zZXR0aW5nczsKPiArCgpDb3VsZCB3ZSByZXR1cm4gMCBkaXJlY3RseT8KYW5kIG1vdmUg
dGhpcyB0byB0aGUgcHJldmlvdXMgY2hlY2ssIGxpa2UgdGhpczoKCX0gZWxzZSBpZiAoZ2VhciA8
IG1heF90KHUzMiwgYWRhcHRpdmVfdHhlcV9nZWFyLCBVRlNfSFNfRzQpIHsKCQlyZXR1cm4gMDsK
CX0KClRoYW5rcwpQZXRlcgo=
