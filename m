Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.148.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793955935;
	b=fslevPCCfy+zk4pU/YlOcMJjLFUoCnh7DqceRjShhcxwluhS+k2RjX+GKypmUb9OmQmE
	 0D+A83+1hGhMs8YFJyN4LDQgLizryobPOmv+4lczumKPp9f1L4M1JdPRrv27BhtP8S2re
	 QN+DLr2EsAx7JDN7RXWN7f8hGNvhjVM76MbX2Aj4b2/2oCu5TC29Yyn7cBMGFiQXrHKGW
	 m3874p01iQsjxamn/RAkfiZmnVE5087neb9V8EY+c0eu9/QnLJ+xrVkFu11zi+6Zo2AKA
	 3IbqpRJjUOyb+KV6qpjwYJBs9mTJ7F8mGV1o/ovMhBwNi/E5x70idZieevL4FUgcGKg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793955935;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Received:From:
	 To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
	 In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Reinject:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version;
	bh=KsG/PHUIKAHbV9n+Y7R8+KtwBCC93G3dVfI+NN3llUI=;
	b=TE/7kEkCsnLRh2OVgXg4JDN5WIuRaeYqg0Edk8ZuNAnN7gFu7i0aKPNNaZHEWbX3himL
	 hOeSy46zxggFF+/cSW8kz2fSrQ7WBJ/2/A0O2yHSFFSGpuNGPpyHkGewTwDsIWxlp1wP9
	 j2RJc7zRzUDQx8zUkl83tj3I9m1E8HPGnZxEC2fmoC35B97idSb6HdPGZd7KSEhdIsY8q
	 lnsiMpfE52+daKm36ajGSY/A75UGmryCHol2lhcW0rQ3qu0UCOPllD+KKCPB/OHb186+5
	 43KSTYrmKU3IP53hiTkMRqg7oSSQP7OmmhdlOqIlYhp3lCBAVPZMJRPSzNUvVpqZiQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=selector1 header.b=gv5gAnbE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1130C606A328;
	Fri,  6 Nov 2026 09:05:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1130C606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=selector1 header.b=gv5gAnbE
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67TDkr2948532;
	Fri, 6 Nov 2026 01:05:25 -0800
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021135.outbound.protection.outlook.com [52.101.62.135])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hs3qs1rfq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 01:05:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pUarDnzv8JIkIJIFo2vXQizymWMgcEpd1h5vnX9rgwa0fpK6g2Y+T7sk+2AyXwiCK8HWugk5wTv2/Skpk1LyVi8VQ/cAfNwfNUnhCBCvoM7ytYQ4tuSx7yGE1+aRnMjCZC9khqdgOY6hxhn4/3Zw2/c5UZOVHuHvqx6NcB+nR+pCdveaqvEuitZn8u0zQnCdwo8Hy/59V5DEReJWVeJBoZvhfwa7/gMcP14sQtgE7W/GJRl1WHzNzvPrK41MLnY+O3vlJf+hn7j21nYwtZdkpBq9UVH/hflthD7+xDkLEW+nWg15qea4PE460/VnFVAdYN8sWuNgtcezb84za3tG0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsG/PHUIKAHbV9n+Y7R8+KtwBCC93G3dVfI+NN3llUI=;
 b=uhyEgniYZVX/6wsG5cFVje8lhYSsEnz+UahhrY3Be0Q3mKdLHWYrRDPgZbxPQraga7EXhzk8h85EPZZG3Kxz3KllDbzy0/2mO28c83Q0ab9YYReBWPccgFioLcgxEmaXBAxIOTRazVFCLvL2Dr3YF10sRYtg4W1ZuQHMo8uCSYyo2zKKsveSYebScqlVh2tamR/ad+E8A+J6TkYORpavNhDv60377yPK8vImbQM4SkKRzgpQB7Tr8xWCHW102i9tMcis24yzZEorqQtJA6+Stp4nr+IJroJ5DD4yOgCEqzMEx6TnXwYerCHlwYxpM23267Rg+8UmNBfbJAK2a2tL6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsG/PHUIKAHbV9n+Y7R8+KtwBCC93G3dVfI+NN3llUI=;
 b=gv5gAnbEddYLhw7DQiNRS7Cw32KsQWwhFR+qCU66K1AxVIndA1/e2edoJcCp0lonDv45ODUjpvfTjYN5i2+i8qEcizDI1uyfptr8dsM6795yPWb0/ASVFePiEKM6g/8nAJDHeSjNlG56NqGLNavQhgeKpDHXn4K4ZB/weVKd9rA=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by SJ2PR18MB5633.namprd18.prod.outlook.com (2603:10b6:a03:55b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 09:04:05 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%4]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 09:04:04 +0000
From: Nilesh Javali <njavali@marvell.com>
To: Jesse Taube <jtaubepe@redhat.com>,
        "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nimal Prabudoss I
	<nprabudo@redhat.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Manish
 Rangankar <mrangankar@marvell.com>,
        GR-ETH-Storage-Upstream
	<GR-ETH-Storage-Upstream@marvell.com>
Subject: RE: [EXTERNAL] [PATCH] scsi: qedf: Remove unesseary function call
Thread-Topic: [EXTERNAL] [PATCH] scsi: qedf: Remove unesseary function call
Thread-Index: AQHdZ78/OTaDmejuRk2U9n4R4Gwwbrcgy37w
Date: Fri, 6 Nov 2026 09:04:04 +0000
Message-ID:
 <CO6PR18MB45005C3DFDB1953B123A1D35AF762@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20261029160443.904468-1-jtaubepe@redhat.com>
In-Reply-To: <20261029160443.904468-1-jtaubepe@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|SJ2PR18MB5633:EE_
x-ms-office365-filtering-correlation-id: 4c07c7e6-3420-432b-9e6d-08df3be4e854
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|11063799006|56012099006|261022105027099003|261021135927099003|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261028144727099003|10067099003|22082099003|18002099003|6133799003|4133799003;
x-microsoft-antispam-message-info:
 CvEmcyTa73Ej3uEOwRhsR+3P7khq3XeHr5xF1GUwEn6CVTfBG5fH7ylg7ZpPAI4xaL67qJ4ioPctYaLvXUDU1inKXIo4KT/aFuRJXN2RUdJ//6yqUWoMO2FFLBSl2DVjoB3B0tdxFUcG3TL78+JoWMqr83btsA8FPQZzh4e2e3Rx1kVDUiEjan2N8WeXYuOiIwKzXr3Cisrj3ow8KREtNtsww0N/Ldu+ABuNwP62AVSTN2aPcwCBahSXPIx5EPsREqFzY0mWajYCP2LcY05umtBLgKoE1oEmvhdLObz3crEiRxd695RMDlOqYzAneZix1LdQbokUVJv615jmYs6aEleoDD7Zfa17d7LzlStJrtr9VGlbjIAQKuMz9kbJdMirqQtQXSoXkWBxC7YG5f0RHE7WNGbNESWrh5Ym6woa5MCRm6ZBZR3MyqSToz2YuBa2J/eacINVRFQRIJ/LrNcOmXRi05JWnqXaWuB0taGhdrL0/TtxxNGEgqrFRiUdJgaisYF2LKkhWm4bT+M+wRqTO0PWd8lVtElzIC7IudZb2bE/oGQYHlsWUzqg+8Ixt8zd/fxvYaU9/38wSpI2LNe5JnjvkzZANvXJwjOXLhQWqb9pdlG/waNgF0VP+CjYxhktIq0g3uQKzPbANYCNf47hwUOtCOtpRv5YzsTP7RuXMuo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(11063799006)(56012099006)(261022105027099003)(261021135927099003)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261028144727099003)(10067099003)(22082099003)(18002099003)(6133799003)(4133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?akxUWGpSbjVBVU1mb2lHNCtjQVc0U0ZMaHRIK1cxcXNuRHVjNkhYSU0zNGNq?=
 =?utf-8?B?alJ2Q3dNZ0NPdmhCTmMzRnZlWEZnbVNoNXYyQS9EQjkvdzl6TVFLeGtvMTA4?=
 =?utf-8?B?YkN3QytmdEw4cnFGV01IY3hFY1Z5Wnd6UWRPakxCTmNVdE15QTdtT3VyWlRQ?=
 =?utf-8?B?Q1pGeDZ6ektvbjY5YVk1Q2JHTmNMekV1MUh5SHpVeTlkUmRxdW5MUXlYREY1?=
 =?utf-8?B?d3NHS3BoOHhzMlU2QWVybFpINEFvZ0YzMGVFa0JwWEdUQVUrblVYNzBwK2Ez?=
 =?utf-8?B?MjhzK0dsY3Q0QWZoQVgvMTdxbEN1NEpRUHpleXlGNzRrMGVEaDRpNlY3NUls?=
 =?utf-8?B?NnB5VDg0QmRLTi85YmhCRE90WTlLYjZ2WGhMWE1NWGQrZUNNWU1TUkhGSGJM?=
 =?utf-8?B?QVduRmJ2VzRQM3lBcHVVaC9DcEdqbzRhNlp2RmFPcHJ6UG93clhlY2hHOVdm?=
 =?utf-8?B?ckJ5TFhTOGREbWZZanNkZnFlU0tFdnc2c2gvSmpsMXVBYkpxNldGOXViZWcz?=
 =?utf-8?B?NlcrbUJHdWlLSiszMnBFSXZCTkZhMmJwN0hwREg5NDRoL0pWaHBlQk1wTnZk?=
 =?utf-8?B?YTJHeWc4RUtmSFFCNGE3QkZUdUI0T3N0ZjZaYUo2YXd1azBoWHJteXFsdXpx?=
 =?utf-8?B?WnMyQnpaanl6SCtpaTJPRmdsZGVFdVpFd1ZSeG53M29ZMDY5ZmU4bFQ4bUNX?=
 =?utf-8?B?VllzdWwyR0hLbmhURFRsaWhxTUxrNmlXUy92bUhnS2d4WWwyNzRyUWM4eGRs?=
 =?utf-8?B?WHpDdGhEZlZMZjZqZjJoS1FBSVZsZm1SUEpiZkZDWjJ0NnVXcUtXdDBCUUF2?=
 =?utf-8?B?NnNMWEszQjdDRkYwcUNoYUFOWHRkRGV4RFFHZ1ZING5PenlQZzNwOHhRK0tV?=
 =?utf-8?B?WWlrbVFBTFBoMG1YbE5BOVJPcVRtamRYaHBraUdrNzkvQXRJZnVqTG1ZOVor?=
 =?utf-8?B?akkwU0dRUUJpSGJMZE9vTzR6Q0R3TFNWcXh2TUxyaVczaU1UclU5WllHZWw4?=
 =?utf-8?B?L2h0bFZTYTkvaFUyMWgxOStJaG91RTB4RjhHaXNKMzh2anU4TFJESHRjSlN1?=
 =?utf-8?B?N2FQak50MXFncmJaZHh4MHVpWmJCWFJNSTdXdTkyazYzTWlRTEZHWW4wN0g4?=
 =?utf-8?B?K2dBZ2NZMHFZSWZBb083bzYrdnZLNmRXZTVSZ1VKdmkwVThYWXRsMUxuSjhF?=
 =?utf-8?B?dlRoZ0VrSzlKWVJhUVlwYWdtSE9ROVRkOU92c0d2QlN0aWVnK1lMTU1aZXhq?=
 =?utf-8?B?aWloZ1JTQWdLdC8yUEhWMHVacnp6eHpCaXhOTjBTZG82ZUJDZnA5dHpweExW?=
 =?utf-8?B?TFBtMHVnWXpMbzE5TUZwQktyWGNKSGx5L3FxRXQ1N3hzRFJvT0dFL00xdWxz?=
 =?utf-8?B?Uk9BQkx4Uys5TmxEY0R2RVA3OER5eFE3anRva2U3NnpGSGlIdUZTMEtTR3or?=
 =?utf-8?B?TUVIalo4b1h6WENaRDMyNjdXYXBWWDFVcUdWbXJabFRmeFJFMXg2QVpyOFBz?=
 =?utf-8?B?akxvUE1HeHpvVVdKakdnTG1sckJBMkUxTW43dllZazFkRHdpSUVNcGh6dHUy?=
 =?utf-8?B?MCtuYmVjbWdsWnl5bElaR2NaV0xyOHdWbHpEODRnQklLdlBkSUVvbDdaRWhD?=
 =?utf-8?B?eVFkbE5hL09zWGRHNGxJUXZNWEVPdWUwUUNSUFJ4NXRvNjllRTNObktadUtN?=
 =?utf-8?B?aG9lWVVxS2loYXJVUk1rN0M5TStxbFBOMUNibFhXMGp1c1BFSzI3ZFdtNG5r?=
 =?utf-8?B?bkJybmNHRXNYRHgvVEhiaVdFTXArbVVzTGx4RXJzelNkYkZvblgrb3Q0enF6?=
 =?utf-8?B?bWRJcUZlblJUbExYcnNwYlBwbHdBWHVNQkMzaFdVcGRWU3ZYZGFyNnhhVGMw?=
 =?utf-8?B?ak9UN2FkSkJlTUFKWnFPRXI5eU45clVzUW15L0t4dEovb0lhM1Y4dks2dnc4?=
 =?utf-8?B?QTZwTlBReWZQTUEwbnAwUGZiNEM1RjFNZUdtQ2hUbGRlSWROcUlYUEE2YnRh?=
 =?utf-8?B?M1RVaHk3RVllMW1Eck9aK3g2a2VkWGJxc1VrWWRkZEczYzFvTWNCSGRYSktE?=
 =?utf-8?B?RGt2NWR3aE4rQ1FtUkpYN2VyTE8xK0g4VGg5R3ArbDhQazZrYlZwekpzbmxW?=
 =?utf-8?B?cXBvakNVVnQxNDVSSXQzMkxQZWxsUWxVaHl4aDRNdUpPaFB6MnMxTUdpUUJz?=
 =?utf-8?B?MHBsak1iR3BudFhCVVBOR0pYaGZ4VlVibVMzZ3UyZjd4a0tIalBSdGE3Q1Vx?=
 =?utf-8?B?UWttcUpwMCtzWXhxQ3MyUGpUSkdwOWE4NW5NUldnSnpEYWEwbkRnc0VmcXpa?=
 =?utf-8?B?aFp1V3lHRXVFRjJ2V09Yb0MxbDdGWnVFaExVS3ZwTmo1eXYvYUxVdz09?=
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
X-Exchange-RoutingPolicyChecked:
	e3C142j0qJ4naBK7rCYs0AvMfmjW7Wh35kcVj1W0dGEE15pQc4vnYixlq4tkUJ0p/2qW3Q8MmCmXhzPIzihngQPN81YHjTuA3UDkqhGsyw4MGXlUIqobEH8EvTMljhPZvQGpuL9/HqcNV5E+ef+Q5O5/8jvX9FBOLwk4JRU7l9TnKoyJFnLcxHdrQr5hxdNqnN/0xDD7wabwlK3KrqS1EOFBonW0+Jz9SgUu0unKIbYBgKS5IASxK5hoJpYN9QOFj2CP+F3PGEqcLnJ48W+2a8HEFIq3O1d3DCB31dfNWAwJRdQj/S740rys87S2f+mpQf/QERMXE/bYHmhQUq08RQ==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c07c7e6-3420-432b-9e6d-08df3be4e854
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2026 09:04:04.5904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nqKhLsUoCcDaMHBOmEnlJoF9DoOV+bNpGjHpb2djNHIYssc6U0gjKSB33ZXUkMJ/6pHitwH4+sfEOvcerb96Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR18MB5633
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: IBbHTlD1mtPe3OCGcvXHXxdGxrELIJHM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzNSBTYWx0ZWRfX6R5JVBKY8uVn
 57dWfwygm2jWeXjAgPSRCu5YNbzGbNjxIqtvwS3DCr7WssNpUHEGWI4EFZxubi7J2RnU/YHWkLW
 SO22uXusGiaxJFIWwsm0arNXGNa1N6xoNWkzQDYqt8oCEtRuH6KxyzV9QTwGkTYBWzsiQZmjPWU
 mVY8VhNXO7LBHYh6733kBrh+FLsXMC5weMchNmuSyscrEtP+zwV1jL1lQ83T4A+dFQItkutBwas
 wseQncie4ZOusfQeoSaf//RYfPDGy8Wk24dPAoXJIl59SCNmXRG65GQ1MiYIVQuRSTEQPqeShL2
 IxRxItEGIoRBhZGfep5khw2FEKgTVSuDw2dwaZ1L7kWr+b1v085/AfNbyg/mWG1vcYY1SPFpRiA
 CHMdcUtHFu3sVSdDzgvGEQm2d4fqMRYuVoXbAMovz2nOO753gnH/in4iZLPyNtdfRS7T0MkKWJn
 OC2F9GJCvS3RKROCZYg==
X-Authority-Analysis: v=2.4 cv=Tv5zFzXh c=1 sm=1 tr=0 ts=6aed9855 cx=c_pps
 a=rzUdehR910POqGivuQKQfw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=RpNjiQI2AAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=bLk-5xynAAAA:8
 a=M5GUcnROAAAA:8 a=dnWkpfBXLDa12dVJGjQA:9 a=lqcHg5cX4UMA:10 a=PRpDppDLrCsA:10
 a=QEXdDO2ut3YA:10 a=zSyb8xVVt2t83sZkrLMb:22 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: cWFGv5eBXurXh8lwA-BHzLgNa-FDsM5b
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzNSBTYWx0ZWRfX5GzokWyT7ly4
 a3yay/bHXo+5Vj/De0z+b5qRiq5BQqXL7bNewmUQGsWOubUY0Ow1rG9+U/Syvq6pYDMyczA3ekJ
 ROB1a9k0fRxdMKKtl+SEJS/UHRw+pzg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01

DQpKZXNzZSwNCg0KDQpGcm9tOiBKZXNzZSBUYXViZSA8anRhdWJlcGVAcmVkaGF0LmNvbT4gDQpT
ZW50OiBUaHVyc2RheSwgT2N0b2JlciAyOSwgMjAyNiA5OjM1IFBNDQpUbzogTWFydGluIEsuIFBl
dGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCkNjOiBsaW51eC1zY3NpQHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgSmFtZXMgRS5KLiBCb3R0
b21sZXkgPEphbWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb20+OyBOaW1hbCBQcmFi
dWRvc3MgSSA8bnByYWJ1ZG9AcmVkaGF0LmNvbT47IGptZW5lZ2hpQHJlZGhhdC5jb207IE5pbGVz
aCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+OyBNYW5pc2ggUmFuZ2Fua2FyIDxtcmFuZ2Fu
a2FyQG1hcnZlbGwuY29tPjsgR1ItRVRILVN0b3JhZ2UtVXBzdHJlYW0gPEdSLUVUSC1TdG9yYWdl
LVVwc3RyZWFtQG1hcnZlbGwuY29tPjsgSmVzc2UgVGF1YmUgPGp0YXViZXBlQHJlZGhhdC5jb20+
DQpTdWJqZWN0OiBbRVhURVJOQUxdIFtQQVRDSF0gc2NzaTogcWVkZjogUmVtb3ZlIHVuZXNzZWFy
eSBmdW5jdGlvbiBjYWxsDQoNClRoZSByZXN1bHQgb2YgYHNrYl90cmFuc3BvcnRfaGVhZGVyYCB3
YXMgdW51c2VkLiBDYWxsaW5nIHRoaXMgZnVuY3Rpb24gd2FybmVkIHdoZW4gYHNrYl90cmFuc3Bv
cnRfaGVhZGVyX3dhc19zZXRgIHJldHVybmVkIGZhbHNlIGNhdXNpbmcgYSBwYW5pYyBvbiBkZWJ1
ZyBrZXJuZWxzLiBTaWduZWQtb2ZmLWJ5OiBKZXNzZSBUYXViZSA8anRhdWJlcGVA4oCKcmVkaGF0
LuKAimNvbT4gLS0tIGRyaXZlcnMvc2NzaS9xZWRmL3FlZGZfbWFpbi7igIpjDQpaalFjbVFSWUZw
ZnB0QmFubmVyU3RhcnQNClByaW9yaXRpemUgc2VjdXJpdHkgZm9yIGV4dGVybmFsIGVtYWlsczog
DQpDb25maXJtIHNlbmRlciBhbmQgY29udGVudCBzYWZldHkgYmVmb3JlIGNsaWNraW5nIGxpbmtz
IG9yIG9wZW5pbmcgYXR0YWNobWVudHMgDQrCoMKgaHR0cHM6Ly91cy1waGlzaGFsYXJtLWV3dC5w
cm9vZnBvaW50LmNvbS9FV1QvdjEvQ1JWbVhrcVchdFkzWjFmOFVZbFhhdFMtY2VkM2E3bGpGZHl1
WnFpU2hEOFU4NGNRRHJpZTZ4ZmwtQ2VhNHMtMDBwUlpna09BY0VReHAzRlBydC1EbHZnVXV3RTRO
SzUzYjFScGwkwqDCoOKAjCANCg0KDQpaalFjbVFSWUZwZnB0QmFubmVyRW5kDQpUaGUgcmVzdWx0
IG9mIGBza2JfdHJhbnNwb3J0X2hlYWRlcmAgd2FzIHVudXNlZC4gQ2FsbGluZyB0aGlzIGZ1bmN0
aW9uDQp3YXJuZWQgd2hlbiBgc2tiX3RyYW5zcG9ydF9oZWFkZXJfd2FzX3NldGAgcmV0dXJuZWQg
ZmFsc2UgY2F1c2luZyBhDQpwYW5pYyBvbiBkZWJ1ZyBrZXJuZWxzLg0KDQpTaWduZWQtb2ZmLWJ5
OiBKZXNzZSBUYXViZSA8bWFpbHRvOmp0YXViZXBlQHJlZGhhdC5jb20+DQotLS0NCiBkcml2ZXJz
L3Njc2kvcWVkZi9xZWRmX21haW4uYyB8IDEgLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9u
KC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWVkZi9xZWRmX21haW4uYyBiL2RyaXZl
cnMvc2NzaS9xZWRmL3FlZGZfbWFpbi5jDQppbmRleCBkYTQyOWIzYTQyODMuLmYyYmMwYWM2ODRl
MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9xZWRmL3FlZGZfbWFpbi5jDQorKysgYi9kcml2
ZXJzL3Njc2kvcWVkZi9xZWRmX21haW4uYw0KQEAgLTI0OTYsNyArMjQ5Niw2IEBAIHN0YXRpYyB2
b2lkIHFlZGZfcmVjdl9mcmFtZShzdHJ1Y3QgcWVkZl9jdHggKnFlZGYsDQogDQogCS8qIFB1bGwg
dGhlIGhlYWRlciAqLw0KIAlocCA9IChzdHJ1Y3QgZmNvZV9oZHIgKilza2ItPmRhdGE7DQotCWZo
ID0gKHN0cnVjdCBmY19mcmFtZV9oZWFkZXIgKikgc2tiX3RyYW5zcG9ydF9oZWFkZXIoc2tiKTsN
CiAJc2tiX3B1bGwoc2tiLCBzaXplb2Yoc3RydWN0IGZjb2VfaGRyKSk7DQogCWZyX2xlbiA9IHNr
Yi0+bGVuIC0gc2l6ZW9mKHN0cnVjdCBmY29lX2NyY19lb2YpOw0KIA0KLS0gDQoyLjU2LjANCg0K
VGhhbmtzIGZvciB0aGUgcGF0Y2guDQpSZXZpZXdlZC1ieTogTmlsZXNoIEphdmFsaSA8bmphdmFs
aUBtYXJ2ZWxsLmNvbT4NCg==
