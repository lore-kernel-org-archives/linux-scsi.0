Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E2624E4C3;
	Mon, 22 Dec 2025 08:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766391193; cv=fail; b=sfXoOXuKnFWcGvxvODQQU0/Hvrs0LqIGV7mExOv9k39DX970v+dVE3nSPJfHE2tv8+9HPQRIHVJZA359BubP9I1NGgfkMkjuVn1X2YpLcW1SRU0Lb5uSG3buRBN+Q0uNKFDCvrkk2XmxtyKs5W3qemytPyPbl8H7w5UOn4myF4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766391193; c=relaxed/simple;
	bh=DCyUbJXjnvl1W6fm2uAUvmFY8croY+DdkD07b60y2kY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GLoMP7htyLdgBrd9M1cnXmk8ESJKQEPdERzb51H7wAbHagnqzRofEqPhgdx1324AfrWE6iZsnaTFVTJosRYYpah6QIVYsaDoIapBnXLvt0/rV8pxYHMd5ryVkfWs1wth13gY82oWvglpuNC1PWuFPkMcua5u40ZAKAqzP/Y3egk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=popok5tw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=H4dQCB9t; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="popok5tw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="H4dQCB9t"
X-UUID: 0a96039adf0e11f0b33aeb1e7f16c2b6-20251222
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=DCyUbJXjnvl1W6fm2uAUvmFY8croY+DdkD07b60y2kY=;
	b=popok5twDUq9iCEPKwHhuzVbh7I7lDMrI+vYVHS5SRbzTMz3TiW2jW3bGhL/g+GKg2c528aC//EPzklnzOE8HOnB9EtnAPLF36+ROAl9m/E2K4gFnHvR4QnO0iBBc7lZRaCGSO5cqMFRs9hcLMOqlmeBkTKHAR+zgT2OLajiago=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:a67e20c3-6063-4150-a288-2f9658367388,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:6c2e0903-1fa9-44eb-b231-4afc61466396,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0a96039adf0e11f0b33aeb1e7f16c2b6-20251222
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1443932648; Mon, 22 Dec 2025 16:13:04 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 22 Dec 2025 16:13:03 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 22 Dec 2025 16:13:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yqZPvlyE3dvGrTZ355xvECIR/GvSwmYMasVDxeMNmOy33D7VGv2VcBlk2UQPpwgrpO72YBv0msPuXX+LGfgkcvATaG+Pukkw/s24G1FccJKLcX6qskOTfSG/wzMkD/YTYXu5X2u+itMnW6z1ky3f83iQycRmZYBaoWYQOAZ0xn+rGo2Y+YD/eviI2GBf/QFjP+OeeS0z9LrIL+SSvcQRjI+4+ATB1J51OxHlZdt6xUNx0oTORsr42C/D4yl/ixNSw7e7u/38Fjd8JWu3qUiEXNG/mTMtKsfqwgWPLSenuNCEV4j28CRG2xTFFG7MUW2pW5O8TOPQxjcXHZeFTef70A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCyUbJXjnvl1W6fm2uAUvmFY8croY+DdkD07b60y2kY=;
 b=BftdKGqvvRmBIWVO05waV9Zf0410TspITZaE/ZtFuDYXRDK4s3PMZBkLlJB5ySZGl4uwSP/RIRHg/qo3vFB7A6iW0Mg0wcav6/Axsm4Ab4py3etZ07q2pRTGVA0PngiDzw1goY1WzsJ8uEujbEMhhRuVHC+EmMB+WTOGqADDqcrTGDwA5maU16PCGDjjr2wO0baLj++6RkTshc+yNbBdQWZSz1lIooasf3W5Vr64CvHe1TH1oAoPiSXrTZbm1Y2tNLQvruW9J+VerKTK4rzO/NR0WCifC2SYvRJe6JIxRStk+tjEHlgXOZteDohPLV+03XXaOwlQ4B9FQHTz5jjf0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCyUbJXjnvl1W6fm2uAUvmFY8croY+DdkD07b60y2kY=;
 b=H4dQCB9tgXPg7AomHcHoSJcVjo5Y07BKTHb385y9f0NmOPyQ57JP5m9eKqk6LlUgxfp5CxQjUzdyZlTjLZwk5nI1n13evEJsiIH2RzLlwHu+WLImi/wEBCxbrWCo/MmD2R//00diPKK3T3AqxfmGNoga3wql+QrxsLURz9CHkKM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7243.apcprd03.prod.outlook.com (2603:1096:400:28f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Mon, 22 Dec
 2025 08:13:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 08:13:00 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "AngeloGioacchino Del
 Regno" <angelogioacchino.delregno@collabora.com>, "colin.i.king@gmail.com"
	<colin.i.king@gmail.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] scsi: ufs: host: mediatek: make read-only array
 scale_us static const
Thread-Topic: [PATCH][next] scsi: ufs: host: mediatek: make read-only array
 scale_us static const
Thread-Index: AQHccTDbKK/WL0d1mU2bb+E6AJLCNbUtUy+A
Date: Mon, 22 Dec 2025 08:13:00 +0000
Message-ID: <65daa0cefe5c09d138bdc545be23be9e58d7e762.camel@mediatek.com>
References: <20251219214428.492744-1-colin.i.king@gmail.com>
In-Reply-To: <20251219214428.492744-1-colin.i.king@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7243:EE_
x-ms-office365-filtering-correlation-id: ce3f5b1c-efe6-45ee-607c-08de4131ec38
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Wm8vNC9SbjgxTjBnMVh1YTYwTmtCcmRRUkw0cm5JTE9ENk1nekp0NVcxcjB3?=
 =?utf-8?B?VWRiT3FtME9wMWlIV0FjTmRXWGNyVDVwb0tva1RSODVHVkZ5T0phenVYaG1i?=
 =?utf-8?B?ZVBvRzdKYnNaZG1aejI5ckFWeWg2U0I3K0ZZVmhySTBraDdrQUpxUVA2L1Bv?=
 =?utf-8?B?VGxrSVhsRTJXaW5BZ0htV2ZkV1dTT2NqZDZXWHNLRXgxNVY2c3BrVllzU3Fu?=
 =?utf-8?B?Z3NDMi9vNjlFL3NLZ3gyQnJROGlDVkpJaGpaVG1EMzN2Mk45SUVsbWcvd2JS?=
 =?utf-8?B?Z2gwcFMyU3ZMWVZsR1hjbGM1ZTY0MkkrT3dNZUl3U1JYYnZtazlwaTlySkxw?=
 =?utf-8?B?RTIzQm5VUllLVFNPSGtjQzVLRmw5NXBDNDV2b2dOMkxSaTNoR2toYTEzSmtG?=
 =?utf-8?B?aEhueUFTWVpuR1BOWnRmUWF0bWxYc05rdWNncG5SRURBcmtMU25oMFBuYmMr?=
 =?utf-8?B?RFlFTDNETFpLV3QydkxZTVFHNGJIdkhpOHRrQnFJWHMwYnZoamd0NEE0SDFG?=
 =?utf-8?B?V2ZVUFh3SytYWm4zcktGT1FxYUhRNldUN0JGNm9NYVJXeThxT0dTeEM1WXJs?=
 =?utf-8?B?Z1pRQjlLWVVpODVQNXlsbkh1Y2dMVVFZaHJTOXdCTXQyQVdsT292N00ybkJR?=
 =?utf-8?B?cmRiNXZDVnVIZC9MQ0FITXVPOFd3MVpvT1RCdjI5S1Q3eW1DWkcxOFBrMGEy?=
 =?utf-8?B?aytQL2Q4L3FBUkoxZm9PRzMxUTFiV2wrRk10U0NsNTBROFNQMFdGUS92Ni9y?=
 =?utf-8?B?eFhMTlBjV29HRnVVYnVHZWt0SEJKM2RtSDU3R1ZyQ2E3VzZMQW96YklWVlVz?=
 =?utf-8?B?anpqYVZaekpQbTB1dzcyRTBEWnJlRjFwTThheDhsZUpxRHVJMnFHUWNPMy82?=
 =?utf-8?B?SDU3NVBvWGFCVW82aloyY0EweGNES3FCY1JEd05VNGhtaHdJVk9FYkhLaEor?=
 =?utf-8?B?enZKWDRidVJIZkZjSlMwYzJFMGYwbnNzcTlDb2ZtQXpvYkN3RDkzWFRSUUpU?=
 =?utf-8?B?MkhVajhIVkEzZmRpK2JCK3VsajNFeTBRYmFyOVQvM1NoTEhpaTRuM0NWQjlJ?=
 =?utf-8?B?cWhIY1pLQzBWUWFwY1llMG94U3dQU1N1Mi9ONGVuSTY0UzQ4aWM2ZUc5Q014?=
 =?utf-8?B?WVZCMXdSU2syTThKQ2IyYVBzT0I1aTJCNGhyeCs3WjdONzByNkIxT1VhOHkr?=
 =?utf-8?B?dmFralRQLzhFRUt4RU0xWUpkTHhiNVpiN0dxQ0dZK3F3UEo4Y2tZWHpLZFhu?=
 =?utf-8?B?R01tdVZSeUlsTFd4Z2pEU0U0KzMvTUxZQmx6d2tNdzZNb3R1RCtuRmczM3Bq?=
 =?utf-8?B?RDJFKzVnbGRQdUhudk9qR09zZkpWZGhKUG1MOUdjSEwvOGpDMjNtTk8wcWJV?=
 =?utf-8?B?MTl6dmdkM2gvMHRObElVMnFYbXNsZSt0MjlGNzNYTjl0YXpBblNlQldQcmJx?=
 =?utf-8?B?MFZOMmpjR3FRK3lpdENLNDVPM0R0UG9qUUVvUkdWdjFRTjQ2aFgvVG4zZ3ZK?=
 =?utf-8?B?T29SK0hFN0ZlbGFnZHg0VkJXWjdhb3hENFFHcXRZWWtWb25aVGVJSlFNQVd3?=
 =?utf-8?B?b2Q3ZkZFMmtFN3NzNlJtTUtJbVZpd2NxRnBpSUxoNDRvM3ZjUjEzRjRKYlNU?=
 =?utf-8?B?NWVFZG5yTWl1MmJjNGU5SW5qUTM5VXhRaFpaYkt5QndoclJTd1RmVHNqbGto?=
 =?utf-8?B?dmUxYXhaME13SmhLU1dHVkNDWEp5RGQxRi9ocmFvalVDbm9Ocm52SW9ieURK?=
 =?utf-8?B?UkpMN2VYa0hMMnUxdkFzZysyU1dSa0RuckEzOFIrU2xQZFdkcjFhWkd5YWY2?=
 =?utf-8?B?NDhmOEdwSXlvOXBjYmY3dW82Z0tPVlYzVE95R0c5YXFCdVF6RnAvL2o3S2lp?=
 =?utf-8?B?aGtDQ2o1a0c0NXZaYnY0bytwckZHTEErV0VwNERpZ3JLTEprT3VEMWRTVFpU?=
 =?utf-8?B?MDQyQ3B6SWJOdDZKRUNkSkMxNnVwaEQweHRzdlZWSlB0SHNaUmViRFJsTS80?=
 =?utf-8?B?bzdkUkVoYVFMUWRLT2NoUE1lZUk3c1JMS1lvQ0tWdlNxRzdBaldtZmtVUWFM?=
 =?utf-8?B?WnVCaTA3Q2FGL0FZR2IwZUZpdUlSOXZQbTdoUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWJwdmpNWHVEekx6b3k1TlQ5ZWhnU0V1dVF4Q1o2cVNDTmxnK292aFJxZW9l?=
 =?utf-8?B?RmxBVzN0VFpSQ0UyRDhzYXI4dmN6akgyRGVDbGtMbnVhQjZIbERBTlN2NE1B?=
 =?utf-8?B?Y1J3T2dKL0NDMGdKb3NWakcreWgzczk2YTRacU1xT2pKSURiblVqd0gwV1pP?=
 =?utf-8?B?aWhGMXVxakNFVEhaM3VDa2xVa0xFc2VTT0FPNTVQd3BXb2NyRjU1R3hSMExY?=
 =?utf-8?B?TGxPd3AyTHdYMGZEeUlJUGVxUSszaWFCQ2dxMnZTV00xM2o0c1dIditPcExr?=
 =?utf-8?B?NmJZSkdBWXZqeUEwQVZ5aFFERDFtNzYySll5Z1pSMitrNVpZU3M4aU5Qa1VI?=
 =?utf-8?B?TjF2d2NZVGVqbHVoWFppZ3U4bmRUbStFTkpXa3VaVkFWSEp5eEFwS1phYm5m?=
 =?utf-8?B?bjB0ZVFXMTBoM3BoUGEwMHJ2eFl5Z1B0YkUxOXpNUWw1R2FYcW1qL1pnWEM2?=
 =?utf-8?B?YnJkNGR2NXEycHRtN3NHbHUyZU13K3ZKZS9lTEZ3UjV2MnNOZjFwcWVNQWl5?=
 =?utf-8?B?QzY2d0tneC9qUDdZaCsrT04rMXJuVVdINC8zQzZnWGl3dkUvUkF6OGgvTFRW?=
 =?utf-8?B?ZVFNWFIrRDdqRjZFS0EvUUNiQkEyN2dOQk5BVVIvdnZLSTFXL1lodGJGV2xP?=
 =?utf-8?B?Q05keUtaa0MvdTBJU1N3MXc4K3N6eklsV0g0TVdPMU1ObGpsWHNEZm5iZWxn?=
 =?utf-8?B?VVZhV3ZLVVhXenZ1dFZOMnZqd0ROVTRuRWZUYlI4L2h5RzJaK1o0NytyUFZB?=
 =?utf-8?B?YkRod1RBRUJ1TkpkMjErNVhkZzNKdjcvN3R0OEQxbVF5Qm5ZMFZsbmcwMm1s?=
 =?utf-8?B?OFliOG45bzNmNlhKazJXQXJhY1dpNWRHaWdxN1N0KzFoQndRcllMTGtIdTkv?=
 =?utf-8?B?VlNyUndVMmh4ZXpUMDdjRnIwSE1yQjk1L2J6QTdBVzJHTm95aU1qR3NPcGt2?=
 =?utf-8?B?M1U1MUtPZjNZQXRHaTZ3N3NYcHdqYUxTbHV5OWY4d0U1d09KYU5jRmJzeEIr?=
 =?utf-8?B?UEY0aldVZkdncTVyNlI5M3RCdjFUemllKytnN0RyOUhteDl1Sm5lMXI3NFRa?=
 =?utf-8?B?ZUc5ZG9OMGJQTTJZbUEvVnMxMnR4ekNsMzdGbkMvR1ZuU2xMV3kwY1dHa0Vk?=
 =?utf-8?B?aHAvN1gvVVhERVFBTXgrVEc0MlNZeWpRcWNkK1lMYzRwYnJBM01QTGZvRS9v?=
 =?utf-8?B?dDhxL2tEZGpGcHNCdmhBL3plNGtNYnY1NnVsUlovMEZWTUR4dnZsd2duVzNO?=
 =?utf-8?B?S082N0hmSWorV0VwV3g3SUo4UXkxWnJMK29RYWFDVU5adTdCUHpzajZnTlZF?=
 =?utf-8?B?dGRobzRHUGppMzZ0L0F3WmdqVHZ1OWNhM1E3aUs0Y1RhTkQ1OWdNekpVSEVY?=
 =?utf-8?B?Y3pHS3IvV00zY1VRWjl3RXUzQXAzemNUamxncHQveGdMOGlhL1dBQnpRbTZr?=
 =?utf-8?B?NmFmdS9IZnlURUU0VkVFbHJEdC9kT1IvWWJzZi9YQ0RPTTlteDRBeUQwUjRJ?=
 =?utf-8?B?RTVqSkEyVUEyS1M5SkpGYlFMNjUvTVR2UEo5eE9tRjRuNitweENUNEw3WFZL?=
 =?utf-8?B?TkhvS2hoS1RDTWhEMXpLMHlXMm0yMGhSMzQ0K1VjclBWSVlZQ2QxcU85cUZm?=
 =?utf-8?B?WXltNkRGS0YwZTlscXVxaEh6enNvSGYzMnZyZlRzYXhEa2ZiNS9kdUlsbTBP?=
 =?utf-8?B?SkQ2Y2hXMTFRMXRmNXpySkJndXVlSElidmNNOVpSYWFRS2YrU1Z1RDl0NEk4?=
 =?utf-8?B?Ni82bmdPUVhPZDRsM1JzUHY5QXlWR3M4M2ozNmhBSUtxNFUyOVFQTUdiTVdk?=
 =?utf-8?B?YTVtQzhsV2Rkem5TZHVuL1FabDNQK3hLdkJMVlJiL0I4OU5oVFRFZE15M2xZ?=
 =?utf-8?B?Yk9RQVVVS3k5b2haSXhPdGtRWk8wTTdKTFRkWTdQN3lMV2ZvcnVPUG5yNURV?=
 =?utf-8?B?M3N5QlpnT2p6Y3dRUFA3UDJsVXl6YmQ5MkdkeU93TWpWT3p4M0tqZmxjazBE?=
 =?utf-8?B?UlczU29lOGZpdGE0SENDQ2NvUEwvNFRrWWxNY1lJTHFKTVlkdmM3YmRzbkly?=
 =?utf-8?B?anh3eVJ1ZlhvelFmV1RqT3g1blMxcm9iOUpPTW82YnZrUUF2ci9QeGx5c2Vr?=
 =?utf-8?B?RzNsSHVjbzBFeUtCejI4Nm9OMXU4K0VpWmYvMU9yMDdtNlI1TWw0cmVjZGZp?=
 =?utf-8?B?VnRzOEV1TktLNVFRWU5Ham9BSnVCUjg3eUdnazcwelphMVdTVisveklnSUwx?=
 =?utf-8?B?aUs3NkI0MDBDMnZLMk9odjBybVNhNVRLdHI3TlIzS2p0V2hLYVp6Qlkzc2Z1?=
 =?utf-8?B?eHpVc2p0TWRPeWJOczdPTjZESzRhLzFFNkdJU0dsNE8yRWdBVmZMNnNyckJI?=
 =?utf-8?Q?O6Q7cWMKJANX0U44=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A39D77D1E516E8408F0FF378BB1493CA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce3f5b1c-efe6-45ee-607c-08de4131ec38
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2025 08:13:00.4868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YXB7tiYx4yfynPI07kewFzvmZNWsTnqRV8YtWNGgIo7mUDHbit5W5gBR+SZaZNMgX6FPKEl5Fz1odF6UcOMwkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7243

T24gRnJpLCAyMDI1LTEyLTE5IGF0IDIxOjQ0ICswMDAwLCBDb2xpbiBJYW4gS2luZyB3cm90ZToN
Cj4gRG9uJ3QgcG9wdWxhdGUgdGhlIHJlYWQtb25seSBhcnJheSBzY2FsZV91cyBvbiB0aGUgc3Rh
Y2sgYXQgcnVuIHRpbWUsDQo+IGluc3RlYWQgbWFrZSBpdCBzdGF0aWMgY29uc3QuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT4NCj4g
LS0tDQo+IMKgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDIgKy0NCj4gwqAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy91ZnMvaG9zdC91
ZnMtDQo+IG1lZGlhdGVrLmMNCj4gaW5kZXggZWNiYmY1MmJmNzM0Li42NmIxMWNjMDcwM2IgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gKysrIGIvZHJp
dmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiBAQCAtMTExMiw3ICsxMTEyLDcgQEAgc3Rh
dGljIHZvaWQgdWZzX210a19zZXR1cF9jbGtfZ2F0aW5nKHN0cnVjdA0KPiB1ZnNfaGJhICpoYmEp
DQo+IMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+IMKgwqDCoMKgwqDCoMKg
IHUzMiBhaF9tcyA9IDEwOw0KPiDCoMKgwqDCoMKgwqDCoCB1MzIgYWhfc2NhbGUsIGFoX3RpbWVy
Ow0KPiAtwqDCoMKgwqDCoMKgIHUzMiBzY2FsZV91c1tdID0gezEsIDEwLCAxMDAsIDEwMDAsIDEw
MDAwLCAxMDAwMDB9Ow0KPiArwqDCoMKgwqDCoMKgIHN0YXRpYyBjb25zdCB1MzIgc2NhbGVfdXNb
XSA9IHsxLCAxMCwgMTAwLCAxMDAwLCAxMDAwMCwNCj4gMTAwMDAwfTsNCj4gDQoNClJldmlld2Vk
LWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0KDQo=
