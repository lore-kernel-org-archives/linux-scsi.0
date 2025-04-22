Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E86F7083C;
	Tue, 22 Apr 2025 02:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745290572; cv=fail; b=NULKt0xTyj5WUg5p5q+1n9wL9OVFP7KC0antO7i373oksOCODxXnU/uh3VyYS4cYrjiGOKbURxJsSgLq9in0G7IcBZe2h9Hu+/n2wVr2yb8L/UOIfpa6AE04p5BUV/ke+kqFgrLN/5eY1497yS8ojYNocqrqZxvWSUJhRkAV9yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745290572; c=relaxed/simple;
	bh=ankpL3BR/kbS9o2sp4CpWLzIyIE12+6JK1Jf67SIOcs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a9cuNjTi4Ps7bMqNkADxzJuyVTem62+6jXgSEsKt4xVeG6EBMh3JkcxH0Pd0iFMRgIeWnk1rTVcaEFyX+YAWoaXvYZhjyNCE6IzweHLnO0Ee2Y1RQzYP09tJZIgFhtPfnvPQL+XvzfiK01SsiTpvz0EDUxZUnQEr9CRB/3ug0AQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XeEO9iFK; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qPkChR+y; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XeEO9iFK";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qPkChR+y"
X-UUID: 5169d0c01f2511f09b6713c7f6bde12e-20250422
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ankpL3BR/kbS9o2sp4CpWLzIyIE12+6JK1Jf67SIOcs=;
	b=XeEO9iFKwhC4O0+YSplPPkCRI8Ew4xO41a8DMhu8FAvxgCrjKXKoPtVPzdsIlT9Up0rlB4HztYNcJN428LG3M/RkXEng62vtatJJ8WcIVONsjDXT/BbuEOm6F9gihdiB7C/g0/0bOsRflIp9eBcBUQeZbFEXkUZFfC7OmxWOjSg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:0fc61f1e-305c-4d38-bcc1-fe830b9fa04e,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:4ba259a6-c619-47e3-a41b-90eedbf5b947,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 5169d0c01f2511f09b6713c7f6bde12e-20250422
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 228308170; Tue, 22 Apr 2025 10:55:58 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Apr 2025 10:55:57 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Apr 2025 10:55:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sAO9k/9RxrE52io05Tt+AuIekpqcJ5AWjLJvKUm3eLFCbrqZlJmVAl/wmgAfS4QSQ5m8dctxfREmk5oPDP7GaXEW4PTUS9H7QbHb2jlAdcrlCWDiiPoUC4tadAxL4z7uTCpu9Zb4+afV5gPjUaUlmdAHn8DNHHDae/p9gbVPROMbjKnvbx5tGqfq9HgRgfPauvdQWKnQ1kIXXu79HYMeKPK+pYelB+ro6Gv2rwFPZKFchm7Z34WlC9YJjbZILAKZXhBpu0q0+qh2bGC0elUvMHy76gAT13SpAu8VvqpFhG9HaUUSbAYlAEiFDSkB7tvm7DsfT1L20m9Qe5F58XkmjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ankpL3BR/kbS9o2sp4CpWLzIyIE12+6JK1Jf67SIOcs=;
 b=MkDLudEnIvfoSziVTkeBf/gzCrBrOijuCT9GzcB1L7dReRn7OVl0vhwgnaodGViwWpzI9LOrP6t/OczefVtk8q8Zb3KejaSuZd+xPdqCjK9rjjCMU+nFc9tBJqxlyMYUy8AmhqlOfpsvHzEzlKG1GI3gQRmYnwOj3HWNXI1DoXIhop7R9Ld/xs09ig7h4BIqPN3b/dRnXA+Vvgm9A4B0P5QdiO4QcdRZzmv5m3+8W8WpiTKNq/QP+6R/WZ1XbmgWBY0qEgS+xDFDVir8m7mTmNSRlLS6qSJFt8jFp/N/AY/DyIsEH8smGp14rL+XeBuK4h33LnpTYDCWxZqVE6zu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ankpL3BR/kbS9o2sp4CpWLzIyIE12+6JK1Jf67SIOcs=;
 b=qPkChR+ydMNir6FlN+HV21q8xxYJHmaxIRJTaHIbTy4KBdHSh17xPlNLS5tRNs33zIHntONCD8VS//Vm6kRNUf48CoU40Kvj8lKR8qCRWWFEXc8OPT4iuhAfV9heqDo6CVpUUS4z7WOWyu8ujTt+h2blbvHZoHWePz9Lx1G5y6Y=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8308.apcprd03.prod.outlook.com (2603:1096:820:106::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Tue, 22 Apr
 2025 02:55:56 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 02:55:55 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>
Subject: Re: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Thread-Topic: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Thread-Index: AQHbssSSR8RDBDpfF0WntZunJXCCD7Ou/pcA
Date: Tue, 22 Apr 2025 02:55:55 +0000
Message-ID: <7619479cd692a5ef8bf3bdb8424d173b774dc146.camel@mediatek.com>
References: <20250421135123.594-1-tanghuan@vivo.com>
In-Reply-To: <20250421135123.594-1-tanghuan@vivo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8308:EE_
x-ms-office365-filtering-correlation-id: af23e61d-dea9-48b2-d1c4-08dd814933a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bzlTdWxUK3JwRWxvUE9jcHFXZDVBT2Z6NTBmS0toejloUTZZU3RhRGRJUG5R?=
 =?utf-8?B?ZVJaRGVkU2hVWDMzODNnaFlTM1lxK0UzUkZGRmJ0RThTM0UzeGQxc3BKdC9z?=
 =?utf-8?B?dWZGRldOcTRaMS9SRFczYklhdWNqR0NmM3hHa1MzaTU1cXlieW1RRlQyN3ZL?=
 =?utf-8?B?cUtyWmltTHJGZVFiUURycWYyWERYWFFBRXhOT2ZFS3dJZ3ZPcGF1RWJ0NGMx?=
 =?utf-8?B?bTllQmdjZUNCZGp1bER6WUJ2eXNsajgzcUxaL0dFSENVQkppTFBvcTV1UFJk?=
 =?utf-8?B?WGhKVk84d3BDQ0h1bUh5ck4wMkZaUVRoRENpTGJ1WnkzZVpQT2NFcGdMdVZW?=
 =?utf-8?B?TmtQb3ppQTFYbmlWL1VjaTFUb2p1R1BCUXN4WGlVcURJMmpOT1VMUXFUYWV0?=
 =?utf-8?B?M1JDdDVGOXZoOU5jRlpDUktqNFdqYnR1N0NNbDBOMG9odzlWd082TFBCbysv?=
 =?utf-8?B?eE5hSkR0dXZvcmpWeW1BRktmNU1HR045TlgwaU14VnFuNDJCcXVLMktFT0lj?=
 =?utf-8?B?ZlVrb0pJVUpENmpUNHRGSXdIY0hKQ0ZzemZXM29pMUhCbmt0UXJhQzEwenJ2?=
 =?utf-8?B?RUg1YXZQMW9oSkNBN29DNlkvU1A2d1dWWUNHUlZsSUZxSkc3VHRYWjFrT05s?=
 =?utf-8?B?bkxVNmpLcWx4UzBYaWJyRXVhTndUN0JRWFRibTRxWVVjZUk4dmd3WVBWaFp3?=
 =?utf-8?B?Qzkza1BCTUp3QmdXZ25ySGxoeXZUNUFSZ3QyekNWMTNiU3ZwamZaM1p3L05G?=
 =?utf-8?B?MWhGT0lFWlFpQWtia1FvWG1hcGpzNjBuTlp3KzZRQlZ6K0l4K0tqbEwxUkhl?=
 =?utf-8?B?NHF3TEJiQ2RpanVUbjZJaFErcjJ3WjR0SEpqVSs2Z1RDcCtkclEyblRnQUJt?=
 =?utf-8?B?dy9obkN1ZE92TURMWUxPTHdQYU1SNXNyMzI0Qi9ZVzc5TUV2cWp0Q0ppc1pE?=
 =?utf-8?B?OUZoc1FrTkRPWjA5ZjQyY1ROOWtyK01iZ2Y2bEZGd3A4MXp1VWw5blZScnVP?=
 =?utf-8?B?VjNGZ1MxM3B5dXpyQ1oyNzlyUlNWSDNVNW0yUGQwU2Vmb25aWnVzUk91N0NP?=
 =?utf-8?B?ZW4xNkxIUWRZZjBTS3ZReC9qUmJYdUZMbDYzOGp5TU43NEw5ZnMyV0JZZXlD?=
 =?utf-8?B?QmR1UEZTbnhUdWNxYkpheGgrcE5kNGxHaVVUUW5GVGJLSzZuZDJMUEN2UnN6?=
 =?utf-8?B?S1AybTZORTN5c2NEdEIyM0xDeDFXVWhBMGpBRTE0bVplTlVWcVZrdGNpeE55?=
 =?utf-8?B?OE9lZ3FhUU4yNGx1UHJONTd4Y2wvQzBCbkQxTDUxNjN1MjVqUlRzNTJ6eVNP?=
 =?utf-8?B?Zzh2cXRrWDZLWTFPdzVwbjd2aG50V1llRjhwU2IvRTEwNDcweTE3VmJzVUtw?=
 =?utf-8?B?NDhjenNJUFB6OUlFY2dMMjV0eEN4akVxYzF1Zno0bW52WkF6bWtzWVY3Y1hW?=
 =?utf-8?B?NmMxZDhxVEE1eEJwWnB2dk5EcUR4RE9GTkwzQUhtYnB5V041VFhleW50QmZF?=
 =?utf-8?B?VitHTzc4Q21CamIzUGc2UEhlK3FjalhHaWRVd2VrbHZRRFpkU1IyWTdZblhS?=
 =?utf-8?B?TWt5dzFlMHB3MjM3cFQ5dU5zbTY0M001Z2ppSmdJT1NhUHNDWFVXYVRJenB3?=
 =?utf-8?B?MzE4d2d3WDZkdkJ1STZ2dGJKZzl6UkhpMStrQ1JNQU9DTHNLY0F4cTZ6ZGUx?=
 =?utf-8?B?VWhZcGFRTE43dURsZis1QXB4Zllra2xNUzJrZjhXZktpUzQxUVBDU2lOSzBT?=
 =?utf-8?B?cE5jaTJtR2VxTkN4L0pQWDJVYUJpdGltbGR5UlUweW9vWXhnbWM5QUNTT0h0?=
 =?utf-8?B?dG1sZ01LVWpBRFA4bVVydlVuR05GU2pSemlvRXJWdEFaTVlIbEFGRHlUT1lG?=
 =?utf-8?B?TCsvYW1FNDZYSGJEK0JiNVFZMEpkWFBaUE41ODdhWTBSN0NrOWNCYUNrekV5?=
 =?utf-8?B?UEpQNXlOeFQyR1RwMGo2aGtCNTJHS1d0S2pFaHhlN3ZyK3RRbzcwdGVrSDh1?=
 =?utf-8?Q?Y2o8YsaF6xYnWERSA0WyxALosdIpe4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUVtZUlud3RzYWNBQ0UrQzdIZUNhSXF1U3lCaGFDc0pLOGl2Q3JFRjZZYXhH?=
 =?utf-8?B?RVZuUmFvT3VudTdKSm83czVNcjRlQmg5WFB3OVdYU0wrS3FGdGQ3VTFVdjRr?=
 =?utf-8?B?Vjk5UllON3JsNFVoWFY3aDJXb29MVUIvV2wyamhyRlROMU5BYlR3ak82aVRl?=
 =?utf-8?B?bDZsMzNGdmNaQjRkUnVYNVZkN0Q1NUhYMVRxWVBkQnU4TWFrdmhGQWM5eUpO?=
 =?utf-8?B?Qm9ud3NIcWZDOXFQZzJuTjA3d3pzVnFJdWhKQXlWdmlrNE1uL3NIVWxsSUJP?=
 =?utf-8?B?ZStaaXBoZU5mLzVWaUJEMGtsaE9RbHlFQ1VYR2RYT0FRQnFWSVlZQ0pLTzBN?=
 =?utf-8?B?WDBGekRMSXJ1anBia2xkV1NqRVFLMm40TlllUU9IWG9ZVnhqRkdqMG9INzVm?=
 =?utf-8?B?NlJXUkFVY29iQ24zYkVlY2pwSXI4YVo4eGswbW1SWC9mOVBoKzJFUC9pOUky?=
 =?utf-8?B?RHFHemNmOWJOTVBrTStlWk12ZGttNEhXM254MGVOZm95dmFoKzBwNDBCM1R3?=
 =?utf-8?B?WTV3QzViSEdQVEVRMHlOTkJkRFE0U0JLMlYwZGhGbW9kbnlIa0N1WEhiUzdu?=
 =?utf-8?B?SGdubXJnQjlyaW9kd21pNHJmK3BaQ3U1YnlPQnVjenlNbTR1RFh0Q2lKcmZ5?=
 =?utf-8?B?c25ZczdPQVFEbjFmbklPZGx5VDhHMmVDR1VVclpIVnQ1MDN4cUR1bHhPTXpL?=
 =?utf-8?B?amhKZHgydUxEM296ampxZ2dvQ3FsbFZ0OWg3d0NOQXA1R2FiNlduRnhXSXds?=
 =?utf-8?B?NTJFN0RSYkhjYXlGWUJYMFZCdXFRNXk4TXVKalJ2TnRvT1ZUVitlYmY3YVRR?=
 =?utf-8?B?NnlUWDFISjFiTEJHSnlrSitiYkloNVViMG5sRkdKQUkwUlU1aU1saEYzbHVL?=
 =?utf-8?B?bFpGcW4xK0FYOWNJcGVhckFmZTE3MEdrMDZvY2U2cXpseUVzcFZ6bnBuZFBL?=
 =?utf-8?B?U0pJVUU0cHhxanVrS1FWNFA1VWlOQm9TUlhVOUw0YXA4WGhpZDZBUDZWaldG?=
 =?utf-8?B?OTBGZ0t3blh0WWhIL2VtcDAzSkhSbTlEeW1hMDU3TzlGQnA0WEdRT0N2Zm9k?=
 =?utf-8?B?aWJ3Nk1JWkdGWEkvN2dhWVdtZHYzcDNYN3hGdGhBL29telN2ZlFFaU5ENXg2?=
 =?utf-8?B?NVhYc0pGZlhSY2dMUGRKMjUwemJkemRnbEs4V1NodG1UUHBURDVKajhJZVlz?=
 =?utf-8?B?c3VFNlJqYldHVlB3aS9aVCt2YVltRDZMUmd5SzFxV0hpRmhUN1R6YjVUZjVq?=
 =?utf-8?B?bGppT2xSWlV0MmlMYjV4SkVISCtnbWNQejJ2bjJZSm5RL1NjaFJIVkYzUDFh?=
 =?utf-8?B?SFBoSTQ4d1dXZ3U4RFJsUEtsL1p5b2V2bG9Dc2hoU0ZxN0Y4RmJxdXNJR2Fm?=
 =?utf-8?B?VXh4UlJWUDRDTkV2RjR1R1N5eVV3TytOUk9UNTRTZ3c1anVlSW9HeGZBUkxz?=
 =?utf-8?B?anpBNzA4WnlvT2c1VDhLRGJINHkxZjRhN3RSamszMWhPNkRudHpUYUNsTDdy?=
 =?utf-8?B?Q2FXaHQxQUQrUHFMVDY0UTRKbDdydWNpYWNYU2NtS2hOS0c3QXdJMVZ0MHlI?=
 =?utf-8?B?b24xK3REMlFXUFlHTVpPZWZDbHMzcXFIdnVaK2NFY2FwMmpKeXJjWmIrRGF3?=
 =?utf-8?B?NUV3eGVFOHAzckJmSFNGNlArNkVaenN1a0UvRHNtYjJUZEFXUlFoZzlLOHhw?=
 =?utf-8?B?NDBEeVVmQkdZVUpQYkF6a1dxSlhDTEJ0VkYxTzdyTENEQ2JXWGdWSXIwclRC?=
 =?utf-8?B?VFR1Q2UvL3N1anQ3eDR0YlBwdmJZWmVFcG5wcE5KVWpUZGNKTnFGN3BJUm1Z?=
 =?utf-8?B?bFhGSkRSMWtiY2Nqd0o0MHhIcDcwN3pmZGJNZStRUnZacjYwYjg0WW54WllG?=
 =?utf-8?B?WWNtZ1FlcEdKUG1GVmFkWmJXQXUxUko3WEpoVHhha2RMOG5hbENUNGFHNXVa?=
 =?utf-8?B?Ymh3RDQ4ak83eFJTWHFGZjlpZXhTa0drWWkyRm1SWHZ1eVZVb0Jvbm1SSnhh?=
 =?utf-8?B?aHl1aGpGSkFaODNROXBCU2tBc0FpdEkxN1l4WWdRNEFrcGpRSXF1dExacFpU?=
 =?utf-8?B?SVBFN0hJZVlQZVFVZmhsVFRHUzFQVlh5WjhkckM1a0N3STdzeVNpMkQ4Yzkw?=
 =?utf-8?B?NkdFVzd4R09IRHU2RXRFUDY0SE9rRVduMjBnSDBPTkk4RUFSZmVHTHVhMk54?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B49777CA9ACECC4E9878D74B2E1622FE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af23e61d-dea9-48b2-d1c4-08dd814933a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 02:55:55.5650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M3qMvZnWMKxSvRzmCDZdz5mUuMTTAYT2Iz09y8jkuxSRGeJCAdJma0ONaipXcfTZeMG3xzWTgbWu39E8aEmcCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8308

T24gTW9uLCAyMDI1LTA0LTIxIGF0IDIxOjUxICswODAwLCBIdWFuIFRhbmcgd3JvdGU6DQo+IA0K
PiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRoZSBjb250
ZW50Lg0KPiANCj4gDQo+IEFkZCBjYXBzIFVGU0hDRF9DQVBfTUNRX0VOKGRlZmF1bHQgZW5hYmxl
KSwgdGhlbiBob3N0IGRyaXZlciB0bw0KPiBjb250cm9sIHRoZSBvbi9vZmYgb2YgTUNROyBTb21l
dGltZXMsIHdlIGRvbid0IHdhbnQgdG8gZW5hYmxlDQo+IE1DUSBhbmQgd2FudCB0byBkaXNhYmxl
IGl0IHRocm91Z2ggdGhlIGhvc3QgZHJpdmVyLCBmb3IgZXhhbXBsZSwNCj4gdWZzLXFjb20uYyAu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIdWFuIFRhbmcgPHRhbmdodWFuQHZpdm8uY29tPg0KPiAt
LS0NCg0KDQpIaSBIdWFuLA0KDQpUaGlzIHBhdGNoIG9mIG9ubHkgYWRkIGEgZmxhZyBhbmQgYWx3
YXlzIGVuYWJsZXMgdGhpcyBmbGFnLiANCkluIG90aGVyIHdvcmRzLCBpdCBpcyBhIG1lYW5pbmds
ZXNzIHBhdGNoLg0KU3VnZ2VzdCBhbHNvIHVwdHJlYW0gdGhlIGZsb3cgb2YgdGhlIGRpc2FibGUg
ZmxhZyBwYXRjaCANCmFzIHBhcnQgb2YgYSBwYXRjaCBzZXJpZXMuDQoNClRoYW5rcw0KUGV0ZXIN
Cg0KDQo=
