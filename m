Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DCC8488;
	Wed, 14 Aug 2024 06:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723617591; cv=fail; b=HKzYljyEa/g1uyOj7sTR1S4hHNOi1St3Q9aBxxogjrXbRUqLfZsNTu5AtwMuCmdYsxSfUmuNyzWyn0wG74HiC+ERUG45VaSreaSiSC7zpW8CzVgOHcbvD8fTMvMPSrDCdmFKZj1GPx2WlQ15YHxmOKIcKHdhX9jmuKqi+FH/z9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723617591; c=relaxed/simple;
	bh=7FRc2XoGxRG7JKzyJSVQl8lezcJvQ8R1iNA0bleV844=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LVH1JmQ4rSvqgF74KIqxeiUm6p06489yE4VUkfu9DbH8ZGjdQuTFsveBVXSPFX8ahUGxxHhLmdrHuZ2tsziGkthbUrey4IJfJtNPAaMlfaR/Tv08A5eDeWyb8C3zziGik1FPrNrwgB35Xg5FuYGvzrq0p41yZ+Y0ujLibwcj8Vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Od0/G6j6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YYGlr5mg; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Od0/G6j6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YYGlr5mg"
X-UUID: f78aaaa85a0711ef87684b57767b52b1-20240814
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7FRc2XoGxRG7JKzyJSVQl8lezcJvQ8R1iNA0bleV844=;
	b=Od0/G6j69bc12weuC0KYkPOFaRYU7+XnmRdLtI8R4rq4lYblSqJ4i5LmWFrgqxeSDkal43VLSA1VsPrSo7AKBG0wpcD3yzdrVKki97YroCclqXb0r8EZ8D/HOIzCWgEfx70vZZjDecAu/I7OgWcYHkKbpSYeYBoTzR/qsS4R6Go=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:fe6bcc43-d1c5-4726-89a5-8317f63c849c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:51e21e3f-6019-4002-9080-12f7f4711092,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: f78aaaa85a0711ef87684b57767b52b1-20240814
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1015879873; Wed, 14 Aug 2024 14:39:33 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Aug 2024 14:39:33 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 14 Aug 2024 14:39:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKn8ng1/18cXfSCXNCF1TFMW6Uyy6rLy0gO7VroH36PVDUddMWYaBa3DA8O5jAfpeHwkidtZ9bWTFoOFgy+44DFAzm3tS5ZYX3MQWrJY0+JgY/e1Op3TYj31x0oIQ6AGyCNlaPNQ5g98aQZKc+DbtJVAtOkvEqxyW1e2w/RUj//HV5iidv7r0vVoAlNdDONRFEDVBaSMKvdk/cdbP9I9leoUl8aqQbnjOWVa7sx+5j4fh1BKrklIehY9UqMw6fSegrCVeNA1YVPK7ABcEo6kt1uCPaA4kJEO3WseXlFXtdHy66//jd9zLEpgNE1vnZlUzMEQzqrnx0/H55a72NHOVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FRc2XoGxRG7JKzyJSVQl8lezcJvQ8R1iNA0bleV844=;
 b=uCK7wqwwOfT0/llNI75q9/CTo8jSnqch2c6PBF60oz95B51JnlWIyjKANhiHAaD9RNd8EUK8srr2KDnghYAX9zYQKakr4FABEBGVbVTg2A7/3bBNx2As51CWoxI2pEQXOW9Mh583tHvgKG8fFi+s02WIbaFBS3zw7MZPV3aSQVY+CsW4AXsnp7YyWHHt4zJ81i74VK8GTqMRpFhyLoZKeSCRQ70DEKGACLrZkbbIjbXtWDAcrnMaI7PU155iT5nKkweO/ylH0TPMcGXuMlXSBoGXaOUwQbm0wSaASEhDHEI4VVMV7Y+rqibTvrjPYwxsp0d/1n9xLwspuKB5KGZ7Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FRc2XoGxRG7JKzyJSVQl8lezcJvQ8R1iNA0bleV844=;
 b=YYGlr5mg4zjRqy14oHIeS3U/G96cL62AtNfIsa1EASacy677bHlqrRL5g8V2EXMmr2dB6mszoEH83m2a/kIXubSPCkT0/qx9m8Lme168UU76yM1HlqtEAy9B/MMSHwWqZL/wXmTEVskxvG/yFn5QsWWUxL2AJRbSoj2Vt0NGkHM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6526.apcprd03.prod.outlook.com (2603:1096:400:1f7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 06:39:31 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7875.016; Wed, 14 Aug 2024
 06:39:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "zhanghui31@xiaomi.com" <zhanghui31@xiaomi.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.co" <avri.altman@wdc.co>,
	"huangjianan@xiaomi.com" <huangjianan@xiaomi.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ufs: core: fix bus timeout in ufshcd_wl_resume flow
Thread-Topic: [PATCH] ufs: core: fix bus timeout in ufshcd_wl_resume flow
Thread-Index: AQHa7hObCMcPYbbSCEW76mIaYJkvQrImTUOA
Date: Wed, 14 Aug 2024 06:39:31 +0000
Message-ID: <58c2bf59f5190f6ef527c1debffaf73cd0752311.camel@mediatek.com>
References: <20240813134729.284583-1-zhanghui31@xiaomi.com>
In-Reply-To: <20240813134729.284583-1-zhanghui31@xiaomi.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6526:EE_
x-ms-office365-filtering-correlation-id: d74da50d-6a07-43b4-aab3-08dcbc2bda9f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: iOzq4B8cjoPGDmG8RLlOVyfxtbLN+seDh9vhtKjHQ/NitQJHt/IqPRI0OTNeGSY3LCf+C8KH5Ir8vIP8+yUWIYf9Y5qUL46N+eYq09t0YwT116JBFkVeAdAVAxOo/dThAO8tPaOPgEIGvuLlKP7uHxy6We+LOf2QtFx1x6Xz6sddLD7rn1WRUEJ1FnXwWh6M+jQsFGH5HP4AQN8FupImlqLk40liWwB0OJDVyehi8C0XyzMo8BlpuE8MuM74iXKiVeFqeK5AdvKSGBazMlmVw/+lNX3xXHfT4Fi5Bn6xyPD3j9VvzvdZhni/P6PxUxSGY84HeS7FDl37X7P5/gm49/g9Jxr8V+Cwqf8PpCsxeCEcUVZFcfXEtj6jcOQLv0Jfa+iTjrgKrjM1doEbKMSEhhSaHYjpK0WjOa1cLJd0a1iLWHgACOMz3m9iPRqwqoW76XZ1/BrGoQ/3ZayAmTdxOIx+rejSlQedJFsDqxy9aFHJQv0plNMyCnqYl0u19Ir11bDVcfUB2DbBMjOjGVIh49PtgNgxb90YlnXsPCBaP9Jt4kTeTimo3mK+9mfAboZmCu8Apv/3PF3QiB8MkdjaD19JhuScQoOseLbyjVXLIDgj1Fi4sTEwdwfX8P2IG1nS7xuTJKxEVKAqGO6LOpipXlioqpf1hVsvwUZJ9MTU9pBLm4Z6XOm3afKPZafGvL/7pMjsgrHsCt0oZpzOH9pc2ly0ya2yjnSvueDv12QDs/8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFpBUzUzeGxmTkJqZ3pKNkpHTlh4eC9OMkFnSWVWVzVMSTlVYjNhTVo2My9z?=
 =?utf-8?B?TE9ucTE0YS9oblNndTB1TDhFQTFHWHZiK3Y0ZEtlUGhHejZyZExvdGJnTisx?=
 =?utf-8?B?SVFXQjNJK2RRK0llYndnMC93SzloMDRuWllPWkxOMFlRVlFpekhTR0JGM2sz?=
 =?utf-8?B?amxyWE5lU01CdXBYR0hmRE5ESllGSFYrOE8yZy9WN0ZkUS9wUy9lNXRwRzBS?=
 =?utf-8?B?Y2lWUjVIcGpNbFRXWmZtOHplWkszSkhrcVNpZU9aT3FoN3FxR1RZZzVNcmN4?=
 =?utf-8?B?RWNESVdjekcvUHRPLzFEZmhSQ2EyRmJ2dWN3WnRnekdsVVluZS84MGlxMFBz?=
 =?utf-8?B?UVhIbEw0Zm5sZjZRRktqTC91aFVGZlVIeWtKOHdaQU1zYzdvdkxuUVJOdWdF?=
 =?utf-8?B?T0k3ZVRSYzlwRTVmZHliVk1MQUxDcjNaT0VnYWJyeU9ld3VXcGErVHhTTFMz?=
 =?utf-8?B?dm5LYmV5RmZzaTRDLzdwUVhwaGFuVTh5Yk1jSzYyNGxYRjViMVF6VnM1Vm5W?=
 =?utf-8?B?aGhYNnhtVUlpclVQVEZVeEJ6N2ZMQkdGNXRYZTFKMGRnWXZFcnRYUFFTVE1F?=
 =?utf-8?B?bFJCYmNzaGpNaDkxZFRDdEdiT2ZvYkpiUnVwS3RDVmNCNU5lTHArSVJSQ0U2?=
 =?utf-8?B?N01ybStnZ3hka0J1eTVMUm1XcmJVeFdLWDNqUXFYdGI1SWVOTWVzb0w0RFcv?=
 =?utf-8?B?UmN6ZFdmcWZEcCtDMFJkUm5XV25XZnBFWHAwVHhnZDZYYlNidkgwbXZXemg5?=
 =?utf-8?B?RDA5a01RajhWSENocUNjQm9IQWdXQlBhcTg2ZTNFQTE4OEltZldRODZWL2g3?=
 =?utf-8?B?c0Z5QWJYK2NhdmpFdTBtc0tzTm5wcmdsbWFubkUwOStLcEZncU95VGNmS1F2?=
 =?utf-8?B?NWEzRFg2enNFeWZOODJPbVNOV2JKYzVuU3VFYzNiallWUEZwMm0rb21BL092?=
 =?utf-8?B?ZXRZSVhzaHRlWHdxRUpETkM2KzJvUU1paDlWV1E5cTcwcDJ0U3pXdGJ3VzRn?=
 =?utf-8?B?SVBSc3JneDF5T3YvSFhlUjRFVER3eVkvUWhyeUZ0c2NBWW91OWROd3hWNWc4?=
 =?utf-8?B?WHdvdnRNTnBUeWRTVHNrRDhBQW1BYjJVcE9ZK0lqRlVBK2JzdXhkb0Q4YzE2?=
 =?utf-8?B?ZSs0VVljeUppZndNZEVGNHNpcUpoa3B5dmVWMDc5eVNRVW1Tc3FwVVY5NDAx?=
 =?utf-8?B?ajRHZ3BSMTZwMmNVRXY2akMxNUYvc2N0dTZ0M3FBL0s2bi9QbnRUdXNGcmZj?=
 =?utf-8?B?dEdqakcrUng3b1phRENnczVKeFlmcmdMMUpja3hyNHBEenBXRC9WczJsVGJj?=
 =?utf-8?B?NVQ4SHloamxjU2VDNUZHTEFBYjBrL2FBOXk0Mm00TXJlSlFLV2JZUHU4MWZi?=
 =?utf-8?B?SFFwM0xpL0ZWUHRZZUdJM3NJWDRGc3hLTHBvNlNDVG9aL3B4NHJ0RVppcEJn?=
 =?utf-8?B?Ynd2dFdoMGpnT1hVQ0RWK1pMWk1senRZZE5yUEtpbG9CZHkvdjBWZkY5K3Vm?=
 =?utf-8?B?cjJ1SzF1QXJmY1drS3hQSUl1WTJDMzlYanEwZ2phQnFlK2prVHBEWE9xbDlE?=
 =?utf-8?B?UUJVWHF1ODAvV3prN3FsVko4WStuTHQ3aG5ZSzh1emxzclFBRGlTR2h6YXNW?=
 =?utf-8?B?ZVJ1QVc1RGQ1ZDBYODg5Q2l3cVNqSytFb29EY3JSTVBIZHRXYjJDS2prbDBM?=
 =?utf-8?B?MVVsR1pvNmRPY2E5TzJpTWhwenhGTnpCNmQweVRQVkpjRXVhRGtmUWZpc2VS?=
 =?utf-8?B?MTM0UUoyUXFscThDRlBTWmVTWVV2L0c2ZFVRUEtDclBPLytwM1g4blNTZUJu?=
 =?utf-8?B?NG9EVytRcEhwRzZzbjhuT0JmR0hHMndlTXM5WWRMa3doSEVybWkvZlZqQXY1?=
 =?utf-8?B?MGxSa25kSmp0bVRVVi83WGFKSG9Vck1JcHUxTXhrTzZpUmhvTitVL2hEVWRy?=
 =?utf-8?B?NjhwcFQvdFk4dVd3WFBTYisvM2VmdDlpV2JJcEJCQk9KSEtYWW1wNVBQbTdL?=
 =?utf-8?B?MTk0Sjl4SDZEdEhFMWU3aHR6M2ZSeDErQUlQSWxXUDdBR2xydm9YWS9PT1Uv?=
 =?utf-8?B?cmVpMUoyNk9uaGwyQVZOY1FDQ2pzdnZ1ZjdrUHBtdzhmc1NjcjBDeG5zZ2Yx?=
 =?utf-8?B?cTRSNjlPWmtHSGMwczF3WS9UTUhFejE1NnNtaDFtQyt2enAzWm5SelUyWW10?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8542AEA3EDA3B4CB8DC50FAD4F206BA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d74da50d-6a07-43b4-aab3-08dcbc2bda9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2024 06:39:31.7145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R1Lr5Cvl1Kt30OK0/d6yx1oi8B21RHbrhKdwJ2p8zWaQeUIFGipulh93+t/ViXGs9aDxG5GioysK9xBq6KAM4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6526
X-MTK: N

T24gVHVlLCAyMDI0LTA4LTEzIGF0IDIxOjQ3ICswODAwLCBaaGFuZ0h1aSB3cm90ZToNCj4gRnJv
bTogemhhbmdodWkgPHpoYW5naHVpMzFAeGlhb21pLmNvbT4NCj4gDQo+IElmIHRoZSBTU1UgQ01E
IGNvbXBsZXRpb24gZmxvdyBpbiBVRlMgcmVzdW1lIGFuZCB0aGUgQ01EIHRpbWVvdXQgZmxvdw0K
PiBvY2N1cg0KPiBzaW11bHRhbmVvdXNseSwgdGhlIHRpbWVzdGFtcCBhdHRyaWJ1dGUgY29tbWFu
ZCB3aWxsIGJlIHNlbnQgdG8gdGhlDQo+IGRldmljZQ0KPiANCg0KSGkgWmhhbmdodWksDQoNCklm
IHRoZSB0aW1lb3V0IGNvbW1hbmQgaXMgU1NVPw0KSW4gcmVzdW1lIGZsb3csIGlmIFNTVSBjb21t
YW5kIHRpbWVvdXQsIHVmc2hjZF9laF9ob3N0X3Jlc2V0X2hhbmRsZXINCmludm9rZSB1ZnNoY2Rf
bGlua19yZWNvdmVyeSBvbmx5LCBub3Qgc2NoZWR1bGUgZWggd29yaz8NCg0KDQpUaGFua3MuDQpQ
ZXRlcg0KDQo+IGR1cmluZyB0aGUgVUZTIHJlc3VtZSBmbG93LCB3aGlsZSB0aGUgVUZTIGNvbnRy
b2xsZXIgcGVyZm9ybXMgYSByZXNldA0KPiBpbg0KPiB0aGUgdGltZW91dCBlcnJvciBoYW5kbGlu
ZyBmbG93Lg0KPiANCj4gSW4gdGhpcyBzY2VuYXJpbywgYSBidXMgdGltZW91dCB3aWxsIG9jY3Vy
IGJlY2F1c2UgdGhlIFVGUyByZXN1bWUNCj4gZmxvdw0KPiB3aWxsIGF0dGVtcHQgdG8gYWNjZXNz
IHRoZSBVRlMgaG9zdCBjb250cm9sbGVyIHJlZ2lzdGVycyB3aGlsZSB0aGUNCj4gVUZTDQo+IGNv
bnRyb2xsZXIgaXMgaW4gYSByZXNldCBzdGF0ZSBvciBwb3dlciBjeWNsZS4NCj4gDQo+IENhbGwg
dHJhY2U6DQo+ICAgYXJtNjRfc2Vycm9yX3BhbmljKzB4NmMvMHg5NA0KPiAgIGRvX3NlcnJvcisw
eGJjLzB4YzgNCj4gICBlbDFoXzY0X2Vycm9yX2hhbmRsZXIrMHgzNC8weDQ4DQo+ICAgZWwxaF82
NF9lcnJvcisweDY4LzB4NmMNCj4gICBfcmF3X3NwaW5fdW5sb2NrKzB4MTgvMHg0NA0KPiAgIHVm
c2hjZF9zZW5kX2NvbW1hbmQrMHgxYzAvMHgzODANCj4gICB1ZnNoY2RfZXhlY19kZXZfY21kKzB4
MjFjLzB4MjljDQo+ICAgdWZzaGNkX3NldF90aW1lc3RhbXBfYXR0cisweDc4LzB4ZGMNCj4gICBf
X3Vmc2hjZF93bF9yZXN1bWUrMHgyMjgvMHg0OGMNCj4gICB1ZnNoY2Rfd2xfcmVzdW1lKzB4NWMv
MHgxYjQNCj4gICBzY3NpX2J1c19yZXN1bWUrMHg1OC8weGEwDQo+ICAgZHBtX3J1bl9jYWxsYmFj
aysweDZjLzB4MjNjDQo+ICAgX19kZXZpY2VfcmVzdW1lKzB4Mjk4LzB4NDZjDQo+ICAgYXN5bmNf
cmVzdW1lKzB4MjQvMHgzYw0KPiAgIGFzeW5jX3J1bl9lbnRyeV9mbisweDQ0LzB4MTUwDQo+ICAg
cHJvY2Vzc19zY2hlZHVsZWRfd29ya3MrMHgyNTQvMHg0ZjQNCj4gICB3b3JrZXJfdGhyZWFkKzB4
MjQ0LzB4MzM0DQo+ICAga3RocmVhZCsweDEyNC8weDFmMA0KPiAgIHJldF9mcm9tX2ZvcmsrMHgx
MC8weDIwDQo+IA0KPiBUaGlzIHBhdGNoIGZpeGVzIHRoZSBpc3N1ZSBieSBhZGRpbmcgYSBjaGVj
ayBvZiB0aGUgVUZTIGNvbnRyb2xsZXINCj4gcmVnaXN0ZXIgc3RhdGVzIGJlZm9yZSBzZW5kaW5n
IHRoZSBkZXZpY2UgY29tbWFuZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IHpoYW5naHVpIDx6aGFu
Z2h1aTMxQHhpYW9taS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8
IDE0ICsrKysrKysrKysrKysrDQo+ICBpbmNsdWRlL3Vmcy91ZnNoY2QuaCAgICAgIHwgMTMgKysr
KysrKysrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUv
dWZzaGNkLmMNCj4gaW5kZXggNWUzYzY3ZTk2OTU2Li5lNWUzZTAyNzdkNDMgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KPiBAQCAtMzI5MSw2ICszMjkxLDggQEAgc3RhdGljIGludCB1ZnNoY2RfZXhlY19k
ZXZfY21kKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsDQo+ICAJc3RydWN0IHVmc2hjZF9scmIgKmxy
YnAgPSAmaGJhLT5scmJbdGFnXTsNCj4gIAlpbnQgZXJyOw0KPiAgDQo+ICsJaWYgKGhiYS0+dWZz
aGNkX3JlZ19zdGF0ZSA9PSBVRlNIQ0RfUkVHX1JFU0VUKQ0KPiArCQlyZXR1cm4gLUVCVVNZOw0K
PiAgCS8qIFByb3RlY3RzIHVzZSBvZiBoYmEtPnJlc2VydmVkX3Nsb3QuICovDQo+ICAJbG9ja2Rl
cF9hc3NlcnRfaGVsZCgmaGJhLT5kZXZfY21kLmxvY2spOw0KPiAgDQo+IEBAIC00ODU3LDYgKzQ4
NTksNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9oYmFfZXhlY3V0ZV9oY2Uoc3RydWN0DQo+IHVmc19o
YmEgKmhiYSkNCj4gIGludCB1ZnNoY2RfaGJhX2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0K
PiAgew0KPiAgCWludCByZXQ7DQo+ICsJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gIA0KPiAgCWlm
IChoYmEtPnF1aXJrcyAmIFVGU0hDSV9RVUlSS19CUk9LRU5fSENFKSB7DQo+ICAJCXVmc2hjZF9z
ZXRfbGlua19vZmYoaGJhKTsNCj4gQEAgLTQ4ODEsNiArNDg4NCwxMyBAQCBpbnQgdWZzaGNkX2hi
YV9lbmFibGUoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIAkJcmV0ID0gdWZzaGNkX2hiYV9leGVj
dXRlX2hjZShoYmEpOw0KPiAgCX0NCj4gIA0KPiArCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9z
dC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ICsJaWYgKHJldCkNCj4gKwkJaGJhLT51ZnNoY2RfcmVn
X3N0YXRlID0gVUZTSENEX1JFR19SRVNFVDsNCj4gKwllbHNlDQo+ICsJCWhiYS0+dWZzaGNkX3Jl
Z19zdGF0ZSA9IFVGU0hDRF9SRUdfT1BFUkFUSU9OQUw7DQo+ICsJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiArDQo+ICAJcmV0dXJuIHJldDsN
Cj4gIH0NCj4gIEVYUE9SVF9TWU1CT0xfR1BMKHVmc2hjZF9oYmFfZW5hYmxlKTsNCj4gQEAgLTc2
OTMsNyArNzcwMywxMSBAQCBzdGF0aWMgaW50IHVmc2hjZF9hYm9ydChzdHJ1Y3Qgc2NzaV9jbW5k
ICpjbWQpDQo+ICBzdGF0aWMgaW50IHVmc2hjZF9ob3N0X3Jlc2V0X2FuZF9yZXN0b3JlKHN0cnVj
dCB1ZnNfaGJhICpoYmEpDQo+ICB7DQo+ICAJaW50IGVycjsNCj4gKwl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KPiAgDQo+ICsJc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZs
YWdzKTsNCj4gKwloYmEtPnVmc2hjZF9yZWdfc3RhdGUgPSBVRlNIQ0RfUkVHX1JFU0VUOw0KPiAr
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4g
IAkvKg0KPiAgCSAqIFN0b3AgdGhlIGhvc3QgY29udHJvbGxlciBhbmQgY29tcGxldGUgdGhlIHJl
cXVlc3RzDQo+ICAJICogY2xlYXJlZCBieSBoL3cNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZz
L3Vmc2hjZC5oIGIvaW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gaW5kZXggY2FjMGNkYjlhOTE2Li5l
NWFmNGMyMTE0Y2UgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+ICsrKyBi
L2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+IEBAIC01MjMsNiArNTIzLDE4IEBAIGVudW0gdWZzaGNk
X3N0YXRlIHsNCj4gIAlVRlNIQ0RfU1RBVEVfRVJST1IsDQo+ICB9Ow0KPiAgDQo+ICsvKioNCj4g
KyAqIGVudW0gdWZzaGNkX3N0YXRlIC0gVUZTIGhvc3QgY29udHJvbGxlciBzdGF0ZQ0KPiArICog
QFVGU0hDRF9SRUdfT1BFUkFUSU9OQUw6IFVGUyBob3N0IGNvbnRyb2xsZXIgaXMgZW5hYmxlZCwg
dGhlIGhvc3QNCj4gY29udHJvbGxlcg0KPiArICogcmVnaXN0ZXIgY2FuIGJlIGFjY2Vzc2VkLg0K
PiArICogQFVGU0hDRF9SRUdfUkVTRVQ6IFVGUyBob3N0IGNvbnRyb2xsZXIgcmVnaXN0ZXJzIHdp
bGwgYmUgcmVzZXQsDQo+IGNhbid0IGFjY2Vzcw0KPiArICogYW55IHVmcyBob3N0IGNvbnRyb2xs
ZXIgcmVnaXN0ZXIuDQo+ICsgKi8NCj4gK2VudW0gdWZzaGNkX3JlZ19zdGF0ZSB7DQo+ICsJVUZT
SENEX1JFR19PUEVSQVRJT05BTCwNCj4gKwlVRlNIQ0RfUkVHX1JFU0VULA0KPiArfTsNCj4gKw0K
PiAgZW51bSB1ZnNoY2RfcXVpcmtzIHsNCj4gIAkvKiBJbnRlcnJ1cHQgYWdncmVnYXRpb24gc3Vw
cG9ydCBpcyBicm9rZW4gKi8NCj4gIAlVRlNIQ0RfUVVJUktfQlJPS0VOX0lOVFJfQUdHUgkJCT0g
MSA8PCAwLA0KPiBAQCAtMTAyMCw2ICsxMDMyLDcgQEAgc3RydWN0IHVmc19oYmEgew0KPiAgCXN0
cnVjdCBjb21wbGV0aW9uICp1aWNfYXN5bmNfZG9uZTsNCj4gIA0KPiAgCWVudW0gdWZzaGNkX3N0
YXRlIHVmc2hjZF9zdGF0ZTsNCj4gKwllbnVtIHVmc2hjZF9yZWdfc3RhdGUgdWZzaGNkX3JlZ19z
dGF0ZTsNCj4gIAl1MzIgZWhfZmxhZ3M7DQo+ICAJdTMyIGludHJfbWFzazsNCj4gIAl1MTYgZWVf
Y3RybF9tYXNrOw0K
