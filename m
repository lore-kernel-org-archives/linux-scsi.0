Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EB92D8766;
	Tue, 18 Nov 2025 05:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763445169; cv=fail; b=S5W9qMaH6SQIvSmYQRgwcyqBrL7SuANxSjoQnyJF/kVX6m75XB8afT8nFKyV4jvEDWLe2yPwmfaEQgMkH7z4DWDUQYeB+ivZi00nDxtwUfxrHgwPGFa00KIKuYKKt0N38vK3ExSXaHqqm3RPboPMMTaV8oi97TpIKb8u7dyETOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763445169; c=relaxed/simple;
	bh=HXoyW9qTaBVcWnScP2SCtVHpRJcnf4pDxNwFP06lB8w=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hQzJUlhQnNFPhj3QaMxHV/44xdO1yB58COXVkGHXbaB2+rPnjlVTfvl9KIVR9iuPo90nsLTLBXuCUUbVuXUKyXJLIAWxUYZ26ms546bxmaZIXmuozp3zWQr5nwiw3WYBLJxvjhsaVT8p5WXwwABAfWCRtsbSHbi6x619iNdd5VE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nKmtIhqp; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=vzh6hn4L; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nKmtIhqp";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="vzh6hn4L"
X-UUID: cc704890c44211f0b33aeb1e7f16c2b6-20251118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=HXoyW9qTaBVcWnScP2SCtVHpRJcnf4pDxNwFP06lB8w=;
	b=nKmtIhqp9BHReGbv8thVBP9CotlIHCn/8zvub2io15lfk4lBl+4womD5L1jAwYLlIbfhMvuQ2QdgwYJY9CgBdxMIjMk3j1079bw+dTkUVR51wR9Ut3v01Mqf+NYnc/EpQl+mdmfziW7YsH+UUoEMbZT10tRLzVdNp0Aj5Z8yn3M=;
X-CID-CACHE: Type:Local,Time:202511181348+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:c5c64c9e-c346-4992-8929-36dc7b47a2ca,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:97a40358-17e4-43d2-bf73-55337eed999a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cc704890c44211f0b33aeb1e7f16c2b6-20251118
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1202862369; Tue, 18 Nov 2025 13:52:42 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 18 Nov 2025 13:52:41 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 18 Nov 2025 13:52:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkMIrp62c3ui9PavhjRQXETny/IElXq9mn+1k1NcU11S1QnCcA2egGIjFLNCcp4ax1pghuazap5Tko+UkaT+td/NijAG3Vety+vWOrBthylhUuEoG9pFZn7AkEboEfWkzWqMyIJOmH2W/j7zwL0R750m8Vn7mEV5JeLtzSU5ShQ05Jcce3myzylVHSbfN8jj5aoN0Hpjcd1NGPIHbCtu5F09qeQcTdJpn30cwcBdqY2MyVZ1XsEABqVQB0eutfM2j57vW6aDXpo6XvsC3GjUXexTQ+s6TPYixAK0wMemdyMOl9wj3OP0tqopeAGezYMUK6DM4F/j6lnWEvIvNbMKnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXoyW9qTaBVcWnScP2SCtVHpRJcnf4pDxNwFP06lB8w=;
 b=yPTRRohIaawZ6LYSwCGi5q1VMCi75Sj6UiRg/gwYra7lRc3hBEQ//3YlviIimyTZ+IMfnxYfjkkHVTENdSjeLHTqHJhBCcDo9Eujkrw0/HnmWTSk0sUJhuw/TPZBAE4+RHlSjmD5aUpcaSHkkGtM52hf3gTTci7ZbF7036/WGpk5YDREOlyhqcCep3j8rTt5/ZUAe2INcy3PzBgeWptftJ/vd0HdPT2+RpSNEBXHdnt3mP473SPNTLsm8vTtzZGMcUW4SLbtZ+5XGKhDgm3LdSF0u65nnuDtWEO4diHu2Q58RPJ7qRA41mkSl/y/oNq7+57lEc04aNthOddxavSNTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXoyW9qTaBVcWnScP2SCtVHpRJcnf4pDxNwFP06lB8w=;
 b=vzh6hn4Lv3NLAHy73VdkifDmVbIbyMA+BccqcvfK3zZsRfx+Yp3KpP7OVSq1Z0wtoyD6nGmxfTdPxZJ9o3XOpCMG7wzeRt5cdTbXeUdMK13xiH+rODKLEWjBc55ZaE+VWtrZjOMnXzNYNCOhaQD+m7cWfLM5Hz94gnDOBnqnB00=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8135.apcprd03.prod.outlook.com (2603:1096:400:44f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 05:52:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 05:52:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "hare@suse.de" <hare@suse.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Topic: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAIAAfuaAgACtbwCAAOjIgIABIdaAgAa29oCAAN0ugA==
Date: Tue, 18 Nov 2025 05:52:38 +0000
Message-ID: <7acf375efe2047f9def4de208980fbd2e0e29b34.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
	 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
	 <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
	 <c1f69239-b289-455f-b1b4-89fd3a6ddcee@acm.org>
In-Reply-To: <c1f69239-b289-455f-b1b4-89fd3a6ddcee@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8135:EE_
x-ms-office365-filtering-correlation-id: 8b474d30-d3f6-492a-a173-08de2666ae3b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UmE2Q3dXMnVYS1dIOXA2c2VTc3h2OXozUUlqK3VEcWh2YU8yUU0wb2pZbWYv?=
 =?utf-8?B?cHZ2bW10cW5XTndVb0VIM3NNK2hMRkQvUThWM1JmaDgxV0NVdmpSYWIwOW1Y?=
 =?utf-8?B?VzIzV0xMbitLZlBWV242Q0gybHdudVk0dW0vUFZyV25scmo5TU8rWWNQNTRM?=
 =?utf-8?B?dU5xaS9kbm9KT1Ryb0xxRkphTTk1SzdvQzNPVk82OXdaRmV4Sm0vMXMwT1Vr?=
 =?utf-8?B?QVZvWC96eTlJNDVqUWFYMjN5ZTBEVGNDa1Q2QXE0SVhSSFZsQW16MXZTblF3?=
 =?utf-8?B?T1p6N3RoUzBSS2NqOUpJYWhYTmJ5WDRZZmc3dFk1WEJkLytsMWx3K3d2WE1r?=
 =?utf-8?B?M1hIbDNtbUx4elFxVDh3ZVlKQTZSc1NyZFVTbzRMZ01pQng1S0VDeFkydzNl?=
 =?utf-8?B?WlpRL2FQQVNRUWNIRTlVcjh2SGwzc3NscDRYV08wTlFTL0J3ZEJBVHNxdUhQ?=
 =?utf-8?B?K2VZeGMybUNaajh2M0Q4RlVOeDkzemllU1Q4K2J5V1lHYWlya1hIYVdiZXdw?=
 =?utf-8?B?UUx2eHFNN1BLNEQrYTBEdm1pN2kzMU5wbitvVzRPN0N6SUsvUTBmK2hTTFZK?=
 =?utf-8?B?cHN6Vnh1WTVOaVNRcnZGWFpuWFluZVNPM3Z3a1BzNzJhL283ckZqV3JkOVFi?=
 =?utf-8?B?NGpraG55dmYyL3F3KzQ1eVBUOVFOTTk0bnVEUVFVd1dmWjNZZ2JDRGRLejRq?=
 =?utf-8?B?ZHdGVTc1TGNoeHVIajFnbHIrTHFodXRYeGZWaGhJWnRYTnVDV2hXbTdETmpI?=
 =?utf-8?B?cHdFUEZ6UXoyOWNNVVBCd3cwbDBsUDJmU3lZUEU1YW1RWjJadm5FWDhxWmRO?=
 =?utf-8?B?Tk5TVGxFSFN3VnRqeWNVRXd4WWhyM0JHY1oxSHNpcTd0cFlCdWtzdThuQmRw?=
 =?utf-8?B?bkhZU2RqRG1HZS9qZmRKUEtYUmJmd1FBNmhycEhVTXZJREFZUmZOd3poVmJs?=
 =?utf-8?B?ZlZEUEJNeXFkMXgvQ05kRzVhVzUyY3BhNHRZakVqYk9FRTBSbkNUN2hjYlNo?=
 =?utf-8?B?cHJFRWpGWmsxeHg4L0luVjhHZ00zWWxxcDBBQnZxKytOUm9lZWVQckxVSXFH?=
 =?utf-8?B?dHhQNmZRYTZaYkMzNGh6c2E5cE5uUlphNGtMZ0VkQ3FWaGgyS2NZL3JCa0U4?=
 =?utf-8?B?SkZOSUlZUGZ0cHp1SmtKWnQwOFlweUhoelVCSlhjZWEwWFF5MjU2cTdWS1ll?=
 =?utf-8?B?NlNWS1JleUF5L2wzZWFJTVcxMUFRZzVqS3h6Y3V2bVNOUmNsOWdFRHJhbEh6?=
 =?utf-8?B?YVJSNjUxaTcyQnBCVitkWGgzUjZLN0NqaHdEVWE5L3MzODhPQlJyMWphUElH?=
 =?utf-8?B?RUExVFQzUy91WEJqSEhaM3luN2ZyNTQ1UXBueE83ZTdmNDJpc1NLMi9KS3Q1?=
 =?utf-8?B?Y2xpRktLeWFoK0NxRXo3WnFQVnF3N05pQ1o0ejNGQXFUbC9QS2V2d0VWMEI3?=
 =?utf-8?B?aDZ2L1l4U2JRTmRNT2FxSDlEZ2xmSkF0SlRJRVU0Qkw4L3FYM3R5eFAwRDFi?=
 =?utf-8?B?ZUFKaElaQXIzMXF5TDR2SVFhMm9ta2JPOTc4VUs3OFY0TVMwWVdYWU5EM3Qr?=
 =?utf-8?B?aUlYWDVEV3o2eVVIbWNwL2FxSldMb001SkR3eHNSZEZvSDBBWjhZU2ZrRWFL?=
 =?utf-8?B?Sm9wYU9QTWxIMjVKdkJuT0RSRFZqc1RFa2wxM3p6cWNQUEgyNUFoME9pYlFP?=
 =?utf-8?B?d3lJalQvSnI4Q3B1U2l3ejFPNEhOZjhlN1JXY1dDdWZtelA5MzVkei9iN3Bl?=
 =?utf-8?B?YTlRL3lKMzNSampJL3p2SGhBdCtIZWVmQ01iTWZ4endoRkVzZXcvZU9ubDNa?=
 =?utf-8?B?d3Q2Z1ZENWE3S29JNjF4UHo0TUwvenA2TnUzTzFteTE3UWR1T295Ykt6Vlo2?=
 =?utf-8?B?V1JNSDR4MFQ5YlF3dFVWeUhJTmhXTm9iOUxVU3J3ejM2dnlMNzZ3ZFV2NFdv?=
 =?utf-8?B?NWtKUDBUK2VUdGplanA4NXlRT3Jra0N6UjVZSTdPUDA2aFo0Y21lR3ZHV0lB?=
 =?utf-8?B?VjJIZkE1ek1HSnlmcXN5Z0p2OWJXS3QrbnkxekJjWUhiV2hYdWlxYm1mQ1ky?=
 =?utf-8?Q?FsqNmZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c25jVEE2NDFDOXllNUNhWWlqNkxnemd2M08yd2ZOVDhzYlZOTUhJVFU4RE9s?=
 =?utf-8?B?UHZ5eGJqdmtWY2Q2VThMYUpPQndvWmlOcnpjenVLSEtGZTJkWmtPV0JoTlQv?=
 =?utf-8?B?a0tMaS81amx6dU5hUlE2OU0wTHJmY2VERTA2aE1hV05zSGd1Vit6UVFRM0pJ?=
 =?utf-8?B?V0dqQ1hpZ2F6d0lFZFdrL3ZaQmJHYVpLS2pycmJXTnFMektuRTRkMTJKM0Jy?=
 =?utf-8?B?QzBaQzVJdkE1RXE5SVdnVGJxVDUvTkhySzI0SkNsNHlqQXhOWERIVTlXU1Fj?=
 =?utf-8?B?djVhdkpUQlA2V3l0YmxNcU1aTWJoWUphckIwMjdRM3pvRXQ4eFFQQ2YwL1dN?=
 =?utf-8?B?WGN0WDZSUVc1emEzZlNRMEhEOUtib0lUZGxvNC9ackxETTNPRFlIR1k5Mkh5?=
 =?utf-8?B?RXNieHJUcWcvV0EyS1ZKWkMybnliR2lGaURWS1dmY0U4blM3Y3plOWUyRVAw?=
 =?utf-8?B?N0JPQ1BDTHBNSUNFNEVOR0RReGc3Sy9sM3VZZDBWb2w5VjM3ank2cUl1SFlM?=
 =?utf-8?B?TS9uZWR1VVFBK2xtZ3VxeWo0dTVLck5BU1pvZ2F3L21Jc3NOOUIyM3d5UDdW?=
 =?utf-8?B?WE55S3NoRmhwT1hnSlZ0czhLRkZBODQ4aEwyaThNZnUrZWRTaVM1SGkvWkNz?=
 =?utf-8?B?Z2VNdHc2bGNNQlFNRmo5K2VRbmoxMGw5Y3NNMDczWlpVYjZyd1gyQlRqNCs1?=
 =?utf-8?B?eEVKZzZTWW5Kek80V3VPamRGN0E0aWtUay9nZ0xpYTIyam1Qc1JXZmthV3A1?=
 =?utf-8?B?NWV1TVVibnlxMW9CUEtzbTFQRzF6Z2cxZkZScm04V1cxakNwWEE0d3JxOGt2?=
 =?utf-8?B?YTJuNzhBT2NRVG5uTXc3MURKYlFvbndKa1h2RTFPUzk2TVVnZ1RHL2tnSS9w?=
 =?utf-8?B?WXBoK0VnWEFLUlRFaG16ZGNRUCtpd2d0M0hETmk0K0l0VS9nYi8rWERwYXRO?=
 =?utf-8?B?clNvUDFWSmM0YXBVaHpFN3Rqalp3N0lOTmRSdjJvcEordEdUT3I1WWJidXlI?=
 =?utf-8?B?UXVrc3lIUWVqZ0lVTE5DT0hHUEIvRTZZbkR2dTNiUHRtekJPS1RZcHRYYnVR?=
 =?utf-8?B?OG82OWZvdDMxV0MvSlhDNXlqVjRjejg2MlA5dlVEU3FnckxqSlRNaWhqTFJK?=
 =?utf-8?B?MndwZ1BIZW5EdUR0dXhMd3lOZm9ROFRzeWNqSWg0a2hzbGRNcWgycGtTcmZM?=
 =?utf-8?B?dGJ1bUhNeWtxamlYUmVCZ3U0WWFST2JLSjU3NkFxV0tZRFdNTlNvUXJLZlBO?=
 =?utf-8?B?eFpRTlN2eDZUREpUOU1INUV0M2N3ZDVMTWN2dGUzb0NDTENJeElnQ2pMVU5U?=
 =?utf-8?B?TytmWWJvcWF6M1Y2YVBtV2N0a05yQkdaYVZkdlE2c3ptNllyUE5TSzg5REZB?=
 =?utf-8?B?VEFpQ3ZVMTI4czBnTHZyZ1NkM1JLVWJ0ZlJaUFBHQ0F4Y3lrWFg5bXBZalll?=
 =?utf-8?B?Kzdzd2pIQnBtcG1yQlA5ajl2TGhYNGRVNThQL21vd2Zhakp4K2ovSnpIM3Q3?=
 =?utf-8?B?alNJZjdUTVdCVnR0ckZ0aVBMRXEvVG5ndGRNVm9oUDdNb0JPNmxCOEZtOUU3?=
 =?utf-8?B?bjI3NWJzeVhva2tqdit4ak9LM0hJdHhMY0RrVmEwRjBIVjdZdFlQQ2U2RVpr?=
 =?utf-8?B?Rm1qUFdxd3RHRjkwWW1wVDlHc1FYam53RkdUQldNRlU5dXNJTVBtbVR5Sm1T?=
 =?utf-8?B?ajcwV09mWkhGL1kyWnRqdW9WcTJHZkJ6Szd2K2lRd0FiNlBhVzloU3B5NzRp?=
 =?utf-8?B?bUNZT1pWdDlMY0xUS001VEVDcXUwZkp6Y25Kb281YUtSMFROczl0VWF3cjJ1?=
 =?utf-8?B?ajJ0ZW9QVlpqbUp0bTFMbmw3dFAvUm9uaU1UTDgrU2I1TTFIVFhqQ0ZUN3di?=
 =?utf-8?B?TkhMN2VSaGRHRVpsZE1MUG5sOXJOczFEMjhuVUJhYU51V29OYi8zaFdFYkwy?=
 =?utf-8?B?eXVtbHpDU1ozSCtBdEdTVW05M3hrZVFFcmtNWEtORmpWSncyMVN5ekYvUE5a?=
 =?utf-8?B?NWRWVUNxOWZZMVh3Wi9IcXM3YVJlRXBYWGp3eW82ay81TkZETzlSeFpPdmpy?=
 =?utf-8?B?ZDlxdVo3ZXNRa3A1b05VTFpEbGR2OVNNMDNscW90bU9SUThEYksvc1lLbk1i?=
 =?utf-8?B?eGdldThOYk1LVHNlSHd6L1lBNnFBTGhkaGV5U0ZmMThwdFV1TCtxTklOSEEx?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59A02BC78CDDB445B3D2BD8E529C15AF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b474d30-d3f6-492a-a173-08de2666ae3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 05:52:38.4607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uOdv2K3Y0BH2RsdICpyEhcEyp2dIgaA3UQSD6SCbckhSD3eT70mr3CwCYXinvCxuwBQH9q6cn5c3Pu+m8hxN9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8135

T24gTW9uLCAyMDI1LTExLTE3IGF0IDA4OjQwIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGUN
Cj4gDQo+IEhhbm5lcywgZG8geW91IGFncmVlIHdpdGggaW5jcmVhc2luZyB0aGUgbWF4X2FjdGl2
ZSBhcmd1bWVudCBmcm9tIDENCj4gdG8NCj4gSU5UX01BWD8gSSB0aGluayB0aGUgYWJvdmUgY29k
ZSB3YXMgaW50cm9kdWNlZCAxMiB5ZWFycyBhZ28gYnkgY29tbWl0DQo+IGU0OTRmNmE3MjgzOSAo
IltTQ1NJXSBpbXByb3ZlZCBlaCB0aW1lb3V0IGhhbmRsZXIiKS4NCj4gDQo+IFRoYW5rcywNCj4g
DQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNCkkgdGhpbmsgd2UgY2FuIGNoYW5nZSBtYXhfYWN0aXZl
LCBidXQgdXNpbmcgdGhlIGRlZmF1bHQgdmFsdWUgb2YgMCANCnNob3VsZCBiZSBzdWZmaWNpZW50
LCBhY2NvcmRpbmcgdG8gd29ya3F1ZXVlLnJzdC4NCg0KVGhlIG1heGltdW0gbGltaXQgZm9yIGBg
QG1heF9hY3RpdmVgYCBpcyAyMDQ4IGFuZCB0aGUgZGVmYXVsdCB2YWx1ZQ0KdXNlZA0Kd2hlbiAw
IGlzIHNwZWNpZmllZCBpcyAxMDI0LiBUaGVzZSB2YWx1ZXMgYXJlIGNob3NlbiBzdWZmaWNpZW50
bHkgaGlnaA0Kc3VjaCB0aGF0IHRoZXkgYXJlIG5vdCB0aGUgbGltaXRpbmcgZmFjdG9yIHdoaWxl
IHByb3ZpZGluZyBwcm90ZWN0aW9uDQppbg0KcnVuYXdheSBjYXNlcy4NCg0KVGhhbmtzDQpQZXRl
cg0KDQo=
