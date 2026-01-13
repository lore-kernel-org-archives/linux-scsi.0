Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F8E2C17B6;
	Tue, 13 Jan 2026 07:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768289974; cv=fail; b=d9d6FMcDbgxcMWVb2mwQGsXX0HJpUxLcnw57JPqpq9EYbhs6HKc1f3i3SoxLd6GpVkHrorlE1TA5Ct90faVoeg/errseQdUODZrFCzp4zWhVvrp7p5noDuE9RghAWTmY8r8FgynJABcPN+ca2NoGuaMa8DjClhiXCDFuxNO26dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768289974; c=relaxed/simple;
	bh=WTSCLJQF58MaFRvdtbQUxGn2bV+pw330jdSaav8Sk2Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u9L8xOS4UK5WMrlDhMl+G+OAXhsUOT4BqpCv2hW3CP70FwkAuIMVwF4t8E4aqGujcc8RpsaTUK7OYyA8J/BIW6FUg3fdmNEpjNKs2lC07G9IN/RIsmC8rAttSYxxfC095XUaG8jrlZ5rhGPS/TcQUWGb06EgNhDHlj/z2wWzr2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XMsFiAHC; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GVh2MB+O; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XMsFiAHC";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GVh2MB+O"
X-UUID: e0d57ffaf05011f0bb3cf39eaa2364eb-20260113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=WTSCLJQF58MaFRvdtbQUxGn2bV+pw330jdSaav8Sk2Y=;
	b=XMsFiAHCy672dUXbBQSe3h9riPdCJz06PzHqcEvfDGaU/QMJ/YXNyQ5g6FIyJw/bDG3WXzO18e83XAWzo7XaqadwLuwPrtFltIdZXCuVUzTKuRclJGH9Di31wxgroD2AZbbKF2QmHy/e2qL3EylAI5tT8sJubNDtIFyzXtdxmrk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:61571e8e-3678-4b85-a73c-a07184423cdc,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:d615115a-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e0d57ffaf05011f0bb3cf39eaa2364eb-20260113
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 881770366; Tue, 13 Jan 2026 15:24:20 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 15:24:19 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 15:24:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uf7Nxk1cap3k8fB2HSKSPOOiijAkMSkO7VwzOXHsrQ8kAF2Jbuh520u+t0GqROTvlSqQwhhrToQjMyJ5gF9cFtDiFktGMnplPvlbtYmhCpTIm27XUdyaL4raQrAr2IMrRSc0tfTpeNUp3fh94yC3JUfaVU2HaUE+Ukoip8WjJIAI2oQRKqXl6ZWy/JRVf7jnfanS96uWPY+mt9S77gsQjfJfw6UU3AedKxzbj4puzRGI0ln8ghAzZtjFkBinkjLZBVC02LK4qyNqj4jnJXKeyo9YR187/TUcZgUb5K50KLKbBpjLu7ge/XGsHmfxCxRwxoNqXkmsOJPe5dXZ7aSrWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTSCLJQF58MaFRvdtbQUxGn2bV+pw330jdSaav8Sk2Y=;
 b=gQh/jQ010+pZ0lPizboHyQYGKRRdoKmH9SSjbvtOXgoi4d7soZwZDcqa6NhEQw4+Wntvxt4tU5JHWW1wJonGfFWzIhnAnV9KDTINjUgX8kZqQweN4BnpIfy60+p5jjiLg4yYEfY3Z6iyRwcTrHbt+e/7LigUhxLOf6MyOgcLAnLvTW9WwJxMFwmlbDZsqVTG3JWUlkNZJhHfzxbxXF22aJ96zalV+/b96Hvdxx/okuPoFvI/bu5HwBY9vmbnrJQplecWiIe2aC+Ic0ng1Boz8ANa7NmKDbQVlk0hef5DkLS1rBmagNVAaN3OlgGHT8Utbe6bBOXxof+Z0A9gduzTMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTSCLJQF58MaFRvdtbQUxGn2bV+pw330jdSaav8Sk2Y=;
 b=GVh2MB+Oo+2P9w0DA9afzaVn+CX/ZqvR/Xf971cuKPrGKgHmfYxwoDOyAcHv+ke48rDOF830Ig07agNzGTc2BxltQ+boZmJhqIj5QX4kP2riLSmRZvUO8insOqhNJLBArw1IFuycDIkVEgUDtnBY0ggp8Ogy7oXc/qUCxLE/Ypg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9498.apcprd03.prod.outlook.com (2603:1096:405:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 07:24:18 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 07:24:18 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "liu.song13@zte.com.cn"
	<liu.song13@zte.com.cn>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"zhongqiu.han@oss.qualcomm.com" <zhongqiu.han@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "keosung.park@samsung.com"
	<keosung.park@samsung.com>, "chullee@google.com" <chullee@google.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: Handle sentinel value for
 dHIDAvailableSize
Thread-Topic: [PATCH] scsi: ufs: core: Handle sentinel value for
 dHIDAvailableSize
Thread-Index: AQHcdiAb+rXYKk7v30iIkLLOmy4+kbVPzwCA
Date: Tue, 13 Jan 2026 07:24:17 +0000
Message-ID: <aee15d0084e1801378ec8f8296bc04c58416d916.camel@mediatek.com>
References: <CGME20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
	 <20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
In-Reply-To: <20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9498:EE_
x-ms-office365-filtering-correlation-id: f0586164-9b87-4a27-5114-08de5274c360
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?MDdkd0xjWjZBT0ZZUktaa1BsVTBtQmtLbUhsM21KcTM4SnQ4WEJ5ME1LSTFV?=
 =?utf-8?B?dW9DcHV1Vm14TFFyajlIdHhPMTk3TGsrODBJa1U2UnlRcEFZMFltTDdRc05T?=
 =?utf-8?B?K0phZk5RQ0hQK2tJRHpNL0E5SllYRTdoTG5IQXBnd3RkL0MwbEVWK1ZjMlBY?=
 =?utf-8?B?TlEvSWx2YVJ3ZlIyRDF2cW1IWTduQWcvMVR0YStHRit5dXNPeTRhcThpTy81?=
 =?utf-8?B?SFpwTVZpOXZjU0VRUHM3WTlqTGhmQm5va3FPRUgyYlIzTCtkL1hEZzhtZHVp?=
 =?utf-8?B?OCtLSWV6Q2x1M0xpa1hSeEZOVW5VUXJhMFNxUE9wUEFlbjNCd25jY0krM0Zx?=
 =?utf-8?B?SnBLY1d6Z0svcUxyd3U5NEs5MmdieWQveCtiU1lJT3BUVVFCODJzUHpRVWxS?=
 =?utf-8?B?VXVzRXdRVTMwVS9seUI4Q0Jib3p5RytRd3J3ampUQnFFTjhVRFBKaVpGU0NZ?=
 =?utf-8?B?czFZYTVCRzU3blhUd3AvTEZ1dmlqeEZZQzNneXVtM1RwaklmSW42Q3dJa28y?=
 =?utf-8?B?Vm1jMTNvN2VrMnZUSm8xcWhOQmZWWG5UWW9hSFBtNklXRnhYd0RieXY3RFNa?=
 =?utf-8?B?ZWJuOUZwazF1OWQ1bU1YNjNaMVF0Q3BEUGtOaThVT3pBNStXZS9DS0tCbllU?=
 =?utf-8?B?ZTdPZDFEeTA5ejZ4LzVnNEJyQjg3REl3Y1pKNEJPRFNzR3krOCsrUUdkQm9B?=
 =?utf-8?B?VDhoZFQ2VG9OV1JIYnB0aTYwZzBSZXJjeW1oSVJBSHY2aGIwdTJVc1p3SHdW?=
 =?utf-8?B?M1dnWnRBMTJ1cUhGcG9LeGppbitrcjJPUFNhNS9uN3JDWCtSMERRM1doYXI3?=
 =?utf-8?B?TitnMCthNlAzcVRCUGliTTBOOXk4UW1TOEZjSFg4YVM3bVpVRFFEOEY0VjF4?=
 =?utf-8?B?RHFFWWJqZ1RYWVVFdkZYaHNLQkUyLzlMclVMaEdSR0xsZ0MwK3BsTjF2WVRx?=
 =?utf-8?B?SkdoaElINlBoOWlsRmdxSTd3eEdMWmdkMzZFUWpWUlQwNnpCZFZaNit6S2Jz?=
 =?utf-8?B?VWl2aHFpVmdKelBodXJDT2JzTnJrNE9oRGlOU2V3U2JUSVhoTGVSdUh1Vnlm?=
 =?utf-8?B?UUlKZ0JxVTR3Zk42ZldDWmpHZlZ3L09CdVY3K1F5dHhrRUJjUld3WGlHeUUz?=
 =?utf-8?B?aEJaVFFLa0dKN1dtWVJmaDEvSGk3cUV3SEovUnd1cGtFNVM4K2xESjQxUkF5?=
 =?utf-8?B?bVJDRVpIS1ExZWk0TVE4MW1ncytzaGN3cXYyS2xpYmZpRE1ac0lTd0plZ2hH?=
 =?utf-8?B?c3BiYW55eDhzc3pvZ2plN244R2pSL0ZFRFFFbEY3Y24vdEFlWXFCMVdxZGtv?=
 =?utf-8?B?Z2VHcDVTUDZjckV1THFrMWwwbi9WWmNnTzRYSFlXNmhtdW5lOXlESFpvUW1w?=
 =?utf-8?B?OStwWDM5OVNsbHczbS9ZTjd1SmlOSnBBTG1oNURhdHZES2ttK2h4VW1nNm00?=
 =?utf-8?B?OGVFY3FRSTJPaDZRSGpvY2JjZ2EwLzg2VHA5VUR3RjlVSnBpZWcvcFZTSjhY?=
 =?utf-8?B?UHFMZTdUNzNTaFdzUWo2Z1dMVVdmL2kwbXJrODlCREpDQ0lybHBuWUtZVHAy?=
 =?utf-8?B?QzllYTVjNTVocVB6eDVWRVdKSjRZQTNtL3NBSUNhU0xsMHF0WFA5a0ppMDhO?=
 =?utf-8?B?WlY5SkNxVWZtRlNpL2szWW9Sc2tQVDBzcm1lR3o4YVg3NUVSS1pZSk9reHBR?=
 =?utf-8?B?YWh1b3hERUdSSEkzOEhydEM3MUVDYjRkYlorZzNCQnRkTjB5cUhyaGtSMCtq?=
 =?utf-8?B?T3JWbXhFUFdqN2VRUFhibmpCK21aZ3NXb3hoYm9pUHczN0l0M2pDcnpZTnd0?=
 =?utf-8?B?VnlId2lpUTIvSG0yZ2VmZGxBdjVydklJazVZMWppencrcVlITS91NCtWQTVN?=
 =?utf-8?B?bGFCMzZSSUtVcnZqMjYwSG1vUDAyRnFmb3c1VGp5bE15a1FNRVVwcDg1UEtD?=
 =?utf-8?B?dThRUGhzQ1UzQTZLcU41cnpDNkJWWjNMb0pRUXdrL1hWS2xKTWN6TWNsQWRz?=
 =?utf-8?B?SHc2ZEV1eElUUHJGQUJXemxKOGhHUTBPTUxSaUUrY0FuSnVraTZ4Ylp1TS9I?=
 =?utf-8?B?UDJHOGJGWmFTNGkzd3hHMzIxSXM5SFEvSFdEQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXR5OENqWEFlb2NDUnZtS3JJRHU3clU2SjdvNzBFNmk1OWNqdThKWEdwb0tH?=
 =?utf-8?B?cjBwRHdnb3IrbHgvN3VDWFZYbmtMS1VFaitNcFRLVTc3cTFxSWRZc2Y0aXE0?=
 =?utf-8?B?YUd4WWFiR2V4NEw4Z3NPcEIvRkRnRlFnSHNBUXlkc3UvWHY4RUY5UlJDcnNh?=
 =?utf-8?B?N1Y5blJyYVhTUCtUY2JHVUxVNzJSdFpEUW5PM0JhSXJVekJ1ZDZ5UmpBckV3?=
 =?utf-8?B?WGVVR2E4cHRWWU9jMTJwaVhFdkc4blZNaXJCQjJiaGZ6TFltb0dQeEN5WDd2?=
 =?utf-8?B?UVg0UnZKeUh5NnRsTUxDNUI5SlB2a1FTcjJkVDdueDFKNEhIZlR5MGdPcTJr?=
 =?utf-8?B?NlB3RkRqU1FXem1WbFd3UE4zWTJHODAyY0lGa1RnMTFwRElCYVhrc3ZGTXpO?=
 =?utf-8?B?dzBvQVlicG9qU3VFVEM2bmJPTWFXbkNucFhoNDV0N1ZuN0NRQk0rNjdXb3lw?=
 =?utf-8?B?MDd0dDNLRnVIMXMxZjNGQ05VWDBmNU1Ya0NLekI3UUhjcG1GeVVlRlN1ckxT?=
 =?utf-8?B?VW9BTkgvU1d5MzNqMW9BZjR1OU5uQnFtNmUxWm1zRmNFTEkxT0Z5YUM3eTBU?=
 =?utf-8?B?emNnN3B6TnN0cFZPZ3FyNHl3RXEzT3IxNWEyekNiWGhsM3BqUXRBU2xOdnFV?=
 =?utf-8?B?QUx3QnRQNnQxZzZ0bnNma2V1TUNlbnB5UzJFWXdDT3MyU0pMK1FFa1p1aXl2?=
 =?utf-8?B?SGgyWEpHOGZaNUJPeElMNkw0NUFxbzZhTDlHWFZqZFprUnBrSHlLWGVXZVQv?=
 =?utf-8?B?YXkza1p3bDlkR2VwNkxNMDVVMlRNZEh4SGJyZEltZUE5K1dUS0NyQTFBZ0xB?=
 =?utf-8?B?YW1IR3BiT3V4b2kvNFdNODRaVFZtQWtrb2VEVEtzTndHV3ZYOFNnWlRuSW5o?=
 =?utf-8?B?Wm1MYnBJTS9SK2FlY3M4akJVRDB2cDhQQTB4Y3pwMVdNT2s0RHg4bVF6MFR1?=
 =?utf-8?B?eFZxdTlubjlFMG1yUjB3YkJpa3FXb0JZbXdMbXkyUjg3Mys4WXBMUHZ6ZlE3?=
 =?utf-8?B?c0UwemFDS3U4SW9UWExhZHZxdSs0dzJHYzdOQXhWK255QURwT0t2NlVuQmMz?=
 =?utf-8?B?NHl4cnBwMTZLbm8zVlpSanYxMXZ5WEV5N1NubHc4N29xTnR2VmhJSkJsVUQ3?=
 =?utf-8?B?elFmYzlDenBGeFpMalpwN2xzdTI4RG9VMk5xMHoyVDVjNlVMTENEdzB6YllP?=
 =?utf-8?B?MWxmM3lNOTVodHVXK2JkUko4VnZMZkhWMTJFNllCempNSmFYajhnZ3h5U01T?=
 =?utf-8?B?ODE4VUwxNU5icDZ0aEdSS3lFL2tRU2dVRHlSOVV5RWM0ZUZpcnRtNUFScXlQ?=
 =?utf-8?B?d3ZqR2haT2REamVjbEdSRmFIOUNDUUF5d2J4a2dEUlNUMHpOZ2RENWdFRUtP?=
 =?utf-8?B?cW5DKy95aWhQVEVmUk5pVXFUandxTFpBWjNRUVQ4UVh0RnJmcFpKQXo4V3FI?=
 =?utf-8?B?aEJub0dwZkk0c2t0K2MrOHlKMGRtckRwNDNybFUxSS9vTnVaZWVRTEhPOHNj?=
 =?utf-8?B?VFFaVHBSR0RzUHFmMWtrVXh4NFQvZ0RWVEgwM3llNDdrK2RMekxRV3JZSTF1?=
 =?utf-8?B?OU8zYm1ENmdlZ0N4Vk13ci81MFRYelNYakRPMUpqVDlOd2lIK0ZaZHRoR3p2?=
 =?utf-8?B?OG5yMEdXQVBCTXdsMXBPOEtNaG55K0xuSHZlRllUOFgzcWZmRWp2Ti9pSDc0?=
 =?utf-8?B?M1E3NUhPZDJZTGgyUnQrb3l1dVZxOCtUMkkwTzM4aldUTUtSL1hYNWNpOC8v?=
 =?utf-8?B?Zy9zM05iOTJxK2FVR0ZlN2t1d3FubE1SRnNSVkp0WTZuVWlyMEV0Vkl5aGwz?=
 =?utf-8?B?UXp5bjlNWkJZckpvZllJcER3UlJhQ09BNTFJeFNrS2hqTjBDbEZMcXhyMHVm?=
 =?utf-8?B?ODNOUjZqK3VpYVBuQkdQaDFBUlpxMWZrbHQ1V2l3NEpWQ005RXNNZVVKQTZK?=
 =?utf-8?B?aGsxU0hZdG5PdUt5V2VpMlJxOUpvQlVyb3g3TDU1ZGQ1eWlpUkNaekYwMU40?=
 =?utf-8?B?LzRXajVJblY4RHRsckdZTjVYNVhabUs3dURyMG9jZThaelNHdk9JSEhHWHFv?=
 =?utf-8?B?bG40VVRYUHFXdGxJaFQ1cVZSSllLRFR6VkVWQWpsb2EyZVV0aWxYR09ZSGY5?=
 =?utf-8?B?M0llZnJLamZmY1pUaEVNbTNoWENPVS9XSCsvRXdXUkVNUi96d0Zsblo1anVM?=
 =?utf-8?B?M1BWRXlrVWw3MTNHTXJ3VWIzSU5yaEh3Y002VEtjdVVMcTBMSDFaK3ZOLzZU?=
 =?utf-8?B?b0hocFFaUHNicEpIK1pJWVJzSDZsVDRpd2ZWSGo1Qk8yaGNuR3djZnpPamc4?=
 =?utf-8?B?NlRVMEgxdm1yVXNaelQxZnRmWHFuWjJiSGx6TnUyL0xXRU5pcGpNNnoyNkdp?=
 =?utf-8?Q?6aQg3xQ9mE6fdqAE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2282CEC4654F247B7CEA2B3AA61F292@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0586164-9b87-4a27-5114-08de5274c360
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 07:24:18.0276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iS0gaKAVn/55hjjdrVW/KVceKZG3Aq43TBxWw7GjXjVJ2sfJ03vmj7wPl77dDdZH9nzFLh8TsTUMX/43+fEj0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9498
X-MTK: N

T24gRnJpLCAyMDI1LTEyLTI2IGF0IDEzOjI4ICswOTAwLCBLZW9zZW9uZyBQYXJrIHdyb3RlOg0K
PiBKRURFQyBVRlMgc3BlYyBkZWZpbmVzIDB4RkZGRkZGRkYgZm9yIGRISURBdmFpbGFibGVTaXpl
IGFzIGluZGljYXRpbmcNCj4gbm8NCj4gdmFsaWQgZnJhZ21lbnRlZCBzaXplIGluZm9ybWF0aW9u
LiBSZXR1cm5pbmcgdGhlIHJhdyB2YWx1ZSBjYW4NCj4gbWlzbGVhZA0KPiB1c2Vyc3BhY2UuIFJl
dHVybiAtRU5PREFUQSBpbnN0ZWFkIHdoZW4gdGhlIHZhbHVlIGlzIHVuYXZhaWxhYmxlLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogS2Vvc2VvbmcgUGFyayA8a2Vvc3VuZy5wYXJrQHNhbXN1bmcuY29t
Pg0KPiAtLS0NCj4gwqBkcml2ZXJzL3Vmcy9jb3JlL3Vmcy1zeXNmcy5jIHwgNCArKysrDQo+IMKg
MSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdWZzL2NvcmUvdWZzLXN5c2ZzLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy0NCj4gc3lzZnMu
Yw0KPiBpbmRleCBiMzNmODY1NmVkYjUuLjEwMTdkZDNhZTVkMyAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy91ZnMvY29yZS91ZnMtc3lzZnMuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1z
eXNmcy5jDQo+IEBAIC0xODQ3LDYgKzE4NDcsNyBAQCBzdGF0aWMgc3NpemVfdCBkZWZyYWdfdHJp
Z2dlcl9zdG9yZShzdHJ1Y3QNCj4gZGV2aWNlICpkZXYsDQo+IA0KPiDCoHN0YXRpYyBERVZJQ0Vf
QVRUUl9XTyhkZWZyYWdfdHJpZ2dlcik7DQo+IA0KPiArI2RlZmluZSBVRlNfSElEX0FWQUlMQUJM
RV9TSVpFX0lOVkFMSUQgMHhGRkZGRkZGRlUNCj4gwqBzdGF0aWMgc3NpemVfdCBmcmFnbWVudGVk
X3NpemVfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQ0KPiDCoHsN
Cj4gQEAgLTE4NTksNiArMTg2MCw5IEBAIHN0YXRpYyBzc2l6ZV90IGZyYWdtZW50ZWRfc2l6ZV9z
aG93KHN0cnVjdA0KPiBkZXZpY2UgKmRldiwNCj4gwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7DQo+IA0KPiArwqDCoMKg
wqDCoMKgIGlmICh2YWx1ZSA9PSBVRlNfSElEX0FWQUlMQUJMRV9TSVpFX0lOVkFMSUQpDQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRU5PREFUQTsNCj4gKw0KPiDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gc3lzZnNfZW1pdChidWYsICIldVxuIiwgdmFsdWUpOw0KPiDCoH0N
Cg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
