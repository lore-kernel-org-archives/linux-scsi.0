Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F031C43CE76
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 12:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389881; cv=fail; b=lBZ4klvu8sdasv1qkdwFbKnoNxrKhUVT7iuDKIFZkv6i5hMV09VarOj85d5SOr46BxYeWRooc1p2AEEPByfMnDCFilZ8KVbQlxEijldb/Xv+00oPKCBzk6RIW0szBnJoGE++yXop3Mf5LSRV7k7IhKGLYZyQW177Eb52vtdzYzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389881; c=relaxed/simple;
	bh=P1Pdo2d/YigbXhQb+XxGCaYPpFi0XdhmVbpDk5/dc6g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pPlv+AKkkFkbVVgcckga97/9XfbKzYxcyM6PX7qjWuWVA18L2HUtueMAXQaFQuCXEbNFOIG1dwyG3y1lkN5x/XBcM6NZ0Fc9Y+99uMteMGGaVzicafIjo9Kyvd5kOu25UyIe2LII4gH+6edcgvO1O4augq0YsuJhx2csPuaCipk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gyMvFJUL; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CCxIGUWk; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gyMvFJUL";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CCxIGUWk"
X-UUID: 08f13da4b03a11f1b1788b6acf885367-20260914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=P1Pdo2d/YigbXhQb+XxGCaYPpFi0XdhmVbpDk5/dc6g=;
	b=gyMvFJULh+EyR3fjk0ai2D57iPTrhAW+TFR1uWI4tRN1OSWUpDneUKPbkum+92mBveID82iHK6+oIG6xuYOwFt8G9D1CfYkptWMMZQnU3UW0AWbRZBFYxLdRW4FQrCmUOe5CwcqO8A2Fson47hwenYkxsWG4PJGLy19FDcxdEbc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:dd6d66c5-1071-4601-8dbe-32124bc3872f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:2cc74b28-9ebf-4787-bb42-3cd26eee85aa,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 08f13da4b03a11f1b1788b6acf885367-20260914
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1182317227; Mon, 14 Sep 2026 20:44:32 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 14 Sep 2026 20:44:31 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 14 Sep 2026 20:44:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pw0GNJMx6iTRhuH2LviG+Jd+bFK+0vvrqYHxfmSXf/5yCGHQ8pSK5LezPsAmadajFtwr3iByLT7/FQqNCsFwVbGHm2OHJlvnPxpeqEfUMNmmeepUuTcJSY9Cf/c+FXey7OJ7bYXTtXRM9ZB3M1mPG/Rx9FWjrqZjQh9sruL7TuwO4uaimCZjJ7HjPdEBeNjdBILZQ/2rPYppfDvGxMG3YSK4cIYGJsDbmfLUN8tg6dnadW9DM9sjFC1yVWq6N4p4O08X03tWw2N3zgOwi4DTar0sqDtxY2ZVt+j42r3PH1EGSEbjvDlLq+AARgj13FlNsDnJ+CD9JZ/yZkehtJ6smA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1Pdo2d/YigbXhQb+XxGCaYPpFi0XdhmVbpDk5/dc6g=;
 b=PBFhDx4SenKuyWlmBb2EFC11NWjKzU3TmxJjCi3BKbjAt6nZ4J9JVyF/zfj3vkEf7XfgsFXflFZTgrHXuHo7FTNLwIJmT4jD0BdW8bzTTqUI8Ru+hg8JQ6zxi05QDw6FKxeuHoNXaDirTZ+CPZnacWgPFwZkE3PgZhL3b50aj5Zs5jvR4vo3r60VO8wXkdMpu4z88JTmmWT6+/s4wHDWs/EadhV0AxupO293r1Matb2Nw9npXVbxK/RocDVuhd3YNf7wysCjleflpLj3ti9IqgF5BJZ2mWm7I3x1ahQbvXPKJmc2aFSzI4CluW36RFq2Ewyjo1vAYx7X0aQ57I2rlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1Pdo2d/YigbXhQb+XxGCaYPpFi0XdhmVbpDk5/dc6g=;
 b=CCxIGUWkBFUyB+oHtmNNhMpbX3VOS6GdiYsiUK3opDLCDqTgY5PP2Q52GdFWELVL3UAqHOmINQuCjBYLaR6tI5+wbluLKVt9QTL63txCRuwxtYFhhs+z5o70rAHYy4FfgS/WUTs1SOvqurgaotyIp4Uyh8TY+dteusWN1fvDdZE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSNPR03MB10496.apcprd03.prod.outlook.com (2603:1096:604:47f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:44:30 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:44:30 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ufs: serialize AHIT register access between sysfs
 and host driver
Thread-Topic: [PATCH v2 2/2] ufs: serialize AHIT register access between sysfs
 and host driver
Thread-Index: AQHdRCZe1ryU+5a34kufepAOcM1NX7bNynAAgAA604A=
Date: Mon, 14 Sep 2026 12:44:29 +0000
Message-ID: <d20fabf29c8e3609abfbf7364bb46b11bba994a8.camel@mediatek.com>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
	 <20260914085148.136429-3-peter.wang@mediatek.com>
	 <20260914091357.489F01F000FF@smtp.kernel.org>
In-Reply-To: <20260914091357.489F01F000FF@smtp.kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSNPR03MB10496:EE_
x-ms-office365-filtering-correlation-id: 9319602e-dd11-4d66-6700-08df125deb51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|6133799003|22082099003|18002099003|38070700021|4143699003|10067099003|56012099006|11063799006;
x-microsoft-antispam-message-info: jzqdYijtqS4M7NXK6wW4eGSLW9AvFzmdaEezdxeAyX6mCMsmBqlDH06YPdLUZTAD5HNfEWq5mPCc6GTRk3S0BDQAi5hleKsBfy+n8mOuhcf905xgN68Dg3L2OIgsLFiBeTz5c0k8MWz7SBpSvDgAZMQJz1LAvc0eag3Z/jEmHdywcDmUjwVeSrrA5n2C9hBPZ0dJLs+FE7kmP45kEeOCgLfvlZ5y5C4jVgSaO0l6FyDbhQ40L4KY0H8viJfopMsyQBwKXvCWQb4xl2/8NITJe9nNbMKkvZqDELp8Z+x7maSzKVmWmBCPEfa3kFJ5MCEJSAE9fFq9npNjT8B/NEoPnKf7omNdsXt7o8fN5tYRwdL2WllmzImQcF83C0/skproS6Te3VVabTn9Ec5JCM9m1C6A6qKeHOve9dQs9QyTlLM16QD9mLpanEMJlYfF7weeo1kjYs7pQsp+kfLU9GbTd19AJkaShzSjZM1aDO0pByxaTEkPOiY/lcTeJcWMqCNxdKFbix8/gPfseq/A0cF53Ju65xTuO2J1HfVDR88Ax61+Zs9A4TBCGeBpxMUwv56hHBptnHhpiKHgXczq0rYxQzHrtFr2/9YvB4XPtjErePW6lq9eSltUet40ex6prvySBVntrOzl4x6SqClPC3hXsgX82lnfXmVAZwogk91rDRkUWJkVHvdmmBcwUYc37/pSlQR+gM+WKU7ZBZe6nQUM/szwwTp/wsJ+vQocJCuWrKs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(38070700021)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekxBc0d3bXdCdFpaaHdPTFdlb0FxcWRSTEMrYjgwTGhURnhsYWpyQWpxSzhE?=
 =?utf-8?B?TlpETlF1bXZESEhtL2R1d3AyVGttSEI1S0VXMTJnbVBHSzJNbnNmZDBiZDZz?=
 =?utf-8?B?NEdjMGluNndZZnJBRDNhcTdtcEF0N0NqN2RrRHBsczRhbE5ISEgyejRjYVFC?=
 =?utf-8?B?R3d0cVRtS1UycUdFeS9EZ204L2QzMFdHeFBhNTR0eHoreXYrMUFabE9PMytH?=
 =?utf-8?B?RFdtR09hNzdUTTBiRFVEaHpsTVRCK2JKRTZhanBkZnpVWVZGRnhHZzNCSXdZ?=
 =?utf-8?B?NitTZ2IwVUlHelZON3pWdjF5ZVBzS0l3dnVtRkx6WEJ2S2o2cWQvaTBwYnY3?=
 =?utf-8?B?ODdTWjlPQlk5a2NNaDYrWFVNbmc1OXhTclVZQWQ3akpaRktGTjVZNmg3ZHRk?=
 =?utf-8?B?aEdxa3M3aUFUMFhsRWRiUEdmdDQ3Qno0UjYrd3lDYWFzOWpUandmRDVhdmIr?=
 =?utf-8?B?TWo1a2dDT0E5WTY2MzZBYkRrcWt2YjNnL0k1R3J6K05zN3BiRjZkcHFHOHUz?=
 =?utf-8?B?V2JqTWRyNFhtY2JZenZ3QkZQRVN6MXlwMFUvOTlldEluR0cyUWtlVXpEQTJP?=
 =?utf-8?B?eEpxdzNpY29tQlB3OEhhZVVDRmlDSmd2VkhVSGE5VzdlSm9zN05PaHJSdVBF?=
 =?utf-8?B?UWFrRUZHU3c2SDlyakR6S01xL1V1UlNucGNFNDVJeUcxLzArOXRjMUhKYkpV?=
 =?utf-8?B?TE01Y2F1b1k3bmFkcjRadmI3ZVdCT2V4MUF6OStjcU5oZEFRWWVlemt4K3Vv?=
 =?utf-8?B?bjQ0NHVqSlNIYU9DRWl1TkE5SXJMUkI0clB3TGIxNDduNy9JS09wWXVDbzNu?=
 =?utf-8?B?Qk9RQ09WMmFrR1dUQWphL1hoTTdJNWVRd25qWFdJTTNSdGJUWWhFSXV1VGRw?=
 =?utf-8?B?NHAwYmgwajlZRjNIWGFtRS9oNVFvWktCM3pBcDRkZ0xRZWo0RVQ5aFZGKzZr?=
 =?utf-8?B?c3VPbzJVc2hBTjkxM3VqMUEzMmVKKzFZTlhrZDl5ODYwN2Q3SVB3VkNRcmpO?=
 =?utf-8?B?Sk1mQlFmdE83QmNpaDVrZDZsWnRhdzdvZ1NxRDZpOG1qVlJlSGZqZnRLM3JY?=
 =?utf-8?B?ZzlTNERCckVuS2ZxNG01djJKUmRIMzBERlIwUzFaekJmbkljbmNtczNRQ3BS?=
 =?utf-8?B?c0VDYTV5V1hGOEwwd1ZiaEJ0dzBoTjhWekZWTTZaQU9uQnNmZHdsL2J2OFhX?=
 =?utf-8?B?RHVnUWR0SGwyNUw2cW14NTJYVWpSS0pndGFkSXhjUStzamZJaXdDUXRlYTU5?=
 =?utf-8?B?L1RKYVJ6WFV1SDZ2VitxR0pCRDYwVG5vN3VNYWF2MnBnQ0lFWlVIWHZ4WUda?=
 =?utf-8?B?Vm84Nk00aHhMQlNPV05WUjcvMEJGV2RNeTJqUUUrVjVJc20rZENQcE9TVzda?=
 =?utf-8?B?Z3h1SHU3clptSEhNYjFHUXFqdjNkRmZHbHJlTCtISkprcjhSZzY1QkJiQURh?=
 =?utf-8?B?bktBTDFjZktwT2pDM2svYUk4eVFndktEWHcyWWtRNGduOWVwOXpWcExQUnhY?=
 =?utf-8?B?NGJxRFlialVZc3YxTlJrcFpObjRQUGNQY2FSZVlmYnRLa1hjT1Y2KzV0UENI?=
 =?utf-8?B?VVpPd0c2OTJEdXBRU1ZCZ2lXNDdqZ0tuZHpmVWpQQzUrNmY2dkV2dzVkaWZ6?=
 =?utf-8?B?eExGYWpKTVZJSEhVTUZkM2R1QUY0SlNKMHVTaGZVQnRxTFhYWW9SY09MNUVm?=
 =?utf-8?B?MzJkZDdWSWxnMUVNQ0hNNlhKd1E0YlhINGJ0YWF4L3VZN2JlYmJ2b1dHeWdG?=
 =?utf-8?B?RXBXNU04NSs2TGwyaE1ZdzcrYWlFTytSUzVsZGRNTEN5UkN5aGgwVENmZzFy?=
 =?utf-8?B?OVJUV3lZbDJLNmh6RE4xZjJCMXpHOGJyME4xV2ovSWZBTnBWM01QY0NCbUJr?=
 =?utf-8?B?Qm1HV1NrYzJBckVJYzNxUlljSW1Db1JsSHJJVEcyMUE2bC9UVE1UOEMyRE1t?=
 =?utf-8?B?NnN2VXRkQklGSmNsdFNSMWpkbzZ5dFJnWERNZkFYdmtLbjVySXJSSVh2c0w1?=
 =?utf-8?B?Qk5jZS90b0g0VnJOb0xydDY4TFJkOGN3NXAwa0Y3WnBqdTMxdVdjN0J4VmFK?=
 =?utf-8?B?VXNIOHhoQUFndlU0MFNRbEZlL0pjUkFmS2ZQcGFNeVVJQkhhbmZmcGhEQWNa?=
 =?utf-8?B?U29sZnNDVlp2RlJRbzNlQzdoRERtUU4wRWVRZ2c1SW9ZdlFOZEpFYUpqQ3dj?=
 =?utf-8?B?RmFQbWVONHB4RnVBV1JHZzlZMFoyV0ZCWTBFTGZja0Q3NmV6ZCtLUENGU0FF?=
 =?utf-8?B?NjEybHZONlhTV0NLSXJnS3h0NU1SMGtVMGRjcjZIY3ZiUUVUdkxxd0R1Wlhs?=
 =?utf-8?B?a0NBdDcrT3hRZHpLc2RrK28xVzJwTDhlQk5BdmIwaUo4N2djUStnRnpLa24x?=
 =?utf-8?Q?N7rFu6Z67+E5cCLY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68512E03D6A1574FBFDB95C3F00DCB58@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ZCLI/ssccOcaQ9wsBH9KtLPOg+vEfD/SlHZP2iJYELehJKTi8ZYoZF3qdD4s4PP0XzVHc14L3ahhCQXePEzCWl25wakw+oIxJVeVf3KJd2jXezHgjpZf71qrSXG6mAje6Y7ej75/DPZ9B3TO+IIvr8i1YAW6KLjwH/qB/mDGbyPHMarIyb7DS85eE2khWlCnIreTVr8/65OojQt9qGMJC2F3OpTTfTvjkk4QuuH932zJuPHd/UNHQr5BNvcH4mTMSK4pyFu0kLk9miu8v3m2sOaF6p1a/CNw2isFuMkQ9b0VBTZIOclXXeGxlPV2zT7bOl810izyDkRjVAWdk/ZMeA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9319602e-dd11-4d66-6700-08df125deb51
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2026 12:44:29.8767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1khiPGE57UpFf5BoEBoSs1nqwtHap+Oxnm4vw5Z/A8mabO62rbFC3tKYdCJi5KhhF5muFpIxeZI2xy7Chk8n8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR03MB10496
X-MTK: N

T24gTW9uLCAyMDI2LTA5LTE0IGF0IDA5OjEzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IFRoaXMgaXNuJ3QgYSBidWcgaW50cm9kdWNl
ZCBieSB0aGlzIHBhdGNoLCBidXQgY2FuIHRoaXMgZGVyZWZlcmVuY2UgYQ0KPiBOVUxMIHBvaW50
ZXI/DQo+IA0KPiBTeXNmcyBhdHRyaWJ1dGVzIGFyZSBleHBvc2VkIGluIHVmc2hjZF9pbml0KCkg
dmlhDQo+IHVmc19zeXNmc19hZGRfbm9kZXMoKQ0KPiBiZWZvcmUgaGJhLT51ZnNfZGV2aWNlX3ds
dW4gaXMgYWxsb2NhdGVkLsKgIFRoZSBpbml0aWFsaXphdGlvbiBpcw0KPiBkZWZlcnJlZA0KPiB0
byB0aGUgdWZzaGNkX2FzeW5jX3NjYW4gd29ya2VyLg0KPiANCj4gSWYgYSB1c2VyIHdyaXRlcyB0
byB0aGUgc3lzZnMgbm9kZSBiZWZvcmUgdWZzaGNkX2FkZF9sdXMoKSBhbGxvY2F0ZXMNCj4gaGJh
LT51ZnNfZGV2aWNlX3dsdW4sIGNhbiBhdXRvX2hpYmVybjhfc3RvcmUoKSBjYWxsDQo+IHVmc2hj
ZF9hdXRvX2hpYmVybjhfdXBkYXRlKCkgYW5kIGxvY2tsZXNzbHkgZGVyZWZlcmVuY2UgYSBOVUxM
DQo+IHBvaW50ZXIgaGVyZT8NCj4gDQoNClRoaXMgcGF0Y2ggZm9jdXNlcyBvbiB0aGUgY3VycmVu
dCBpc3N1ZS4NClRoZSBwcmV2aW91cyBpc3N1ZSBjYW4gYmUgYWRkcmVzc2VkIHdpdGggYSBzZXBh
cmF0ZSBwYXRjaCzCoA0KYnV0IG5vdCB3aXRoIHRoaXMgb25lLg0KDQo+ID4gwqAJCXVmc2hjZF9y
cG1fZ2V0X3N5bmMoaGJhKTsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gVGhpcyBpcyBhIHBy
ZS1leGlzdGluZyBpc3N1ZSwgYnV0IGlzIGl0IHNhZmUgdG8gaWdub3JlIHRoZSByZXR1cm4NCj4g
dmFsdWUNCj4gb2YgdWZzaGNkX3JwbV9nZXRfc3luYygpIGhlcmU/DQo+IA0KPiBJZiB0aGUgcnVu
dGltZSBQTSByZXN1bWUgZmFpbHMgKGUuZy4sIGR1ZSB0byBhIHBvd2VyIGRvbWFpbiBmYWlsdXJl
DQo+IG9yDQo+IGRldmljZSByZW1vdmFsKSwgcG1fcnVudGltZV9nZXRfc3luYygpIHJldHVybnMg
YSBuZWdhdGl2ZSBlcnJvciBjb2RlLg0KPiANCj4gRG9lcyBpZ25vcmluZyB0aGlzIGVycm9yIGFs
bG93IHRoZSBmdW5jdGlvbiB0byBwcm9jZWVkIGFuZCB3cml0ZSB0bw0KPiBSRUdfQVVUT19ISUJF
Uk5BVEVfSURMRV9USU1FUiBvbiBhIHBvdGVudGlhbGx5IHN1c3BlbmRlZCBkZXZpY2UsDQo+IGNh
dXNpbmcgYQ0KPiBzeW5jaHJvbm91cyBleHRlcm5hbCBhYm9ydD8NCj4gDQoNClNhbWUsIHByZS1l
eGlzdGluZyBpc3N1ZSBzaG91bGQgYmUgYWRkcmVzc2VkIHdpdGggYSBzZXBhcmF0ZSBwYXRjaC4N
Cg0KDQo+ID4gwqAJCXVmc2hjZF9ob2xkKGhiYSk7DQo+ID4gLQkJdWZzaGNkX2NvbmZpZ3VyZV9h
dXRvX2hpYmVybjgoaGJhKTsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIFNlcmlhbGl6ZSB3aXRoIHRo
ZSBob3N0IGRyaXZlcidzIEFISVQgY29udHJvbC4NCj4gPiBTa2lwIHRoZQ0KPiA+ICsJCSAqIHJl
Z2lzdGVyIHdyaXRlIHdoaWxlIHRoZSBkcml2ZXIgaGFzIEFISVQgZm9yY2VkDQo+ID4gb2ZmOyB0
aGUNCj4gPiArCQkgKiBkcml2ZXIgcHJvZ3JhbXMgaGJhLT5haGl0IGJhY2sgd2hlbiBpdCByZS0N
Cj4gPiBlbmFibGVzIGl0Lg0KPiA+ICsJCSAqIE11dGV4IGlzIHRha2VuIGhlcmUgKG5vdCBhY3Jv
c3MgdGhlIHJwbSBjYWxscw0KPiA+IGFib3ZlKSBzbyBpdA0KPiA+ICsJCSAqIG5ldmVyIGJsb2Nr
cyBhIHJlc3VtZSB0aGF0IHRoZSBkcml2ZXIncyBwYXRoDQo+ID4gbWF5IG5lZWQuDQo+ID4gKwkJ
ICovDQo+ID4gKwkJbXV0ZXhfbG9jaygmaGJhLT5haGl0X211dGV4KTsNCj4gPiArCQlpZiAoIWhi
YS0+YWhpdF9kaXNhYmxlX2RlcHRoKQ0KPiA+ICsJCQl1ZnNoY2RfY29uZmlndXJlX2F1dG9faGli
ZXJuOChoYmEpOw0KPiA+ICsJCW11dGV4X3VubG9jaygmaGJhLT5haGl0X211dGV4KTsNCj4gPiDC
oAkJdWZzaGNkX3JlbGVhc2UoaGJhKTsNCj4gPiDCoAkJdWZzaGNkX3JwbV9wdXRfc3luYyhoYmEp
Ow0KPiA+IMKgCX0NCj4gDQo+IFsgLi4uIF0NCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gVGhp
cyBpcyBhIHByZS1leGlzdGluZyBpc3N1ZSwgYnV0IGRvZXMgdGhlIFVGUyBjb3JlIGRyaXZlciBo
YW5kbGUNCj4gc2hhcmVkDQo+IElSUXMgY29ycmVjdGx5Pw0KPiANCg0KU2FtZSwgcHJlLWV4aXN0
aW5nIGlzc3VlIHNob3VsZCBiZSBhZGRyZXNzZWQgd2l0aCBhIHNlcGFyYXRlIHBhdGNoLg0KDQoN
Cj4gVGhlIGRyaXZlciByZWdpc3RlcnMgaXRzIElSUSB3aXRoIElSUUZfU0hBUkVELiBXaGVuIHRo
ZSBVRlMNCj4gY29udHJvbGxlciBlbnRlcnMNCj4gcnVudGltZSBzdXNwZW5kLCB1ZnNoY2Rfc3Vz
cGVuZCgpIGRpc2FibGVzIHRoZSBpbnRlcnJ1cHQgbGluZQ0KPiBlbnRpcmVseToNCj4gDQo+IGRy
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmM6dWZzaGNkX3N1c3BlbmQoKSB7DQo+IMKgwqDCoCAuLi4N
Cj4gCXVmc2hjZF9kaXNhYmxlX2lycShoYmEpOw0KPiDCoMKgwqAgLi4uDQo+IH0NCj4gDQo+IERv
ZXMgY2FsbGluZyBkaXNhYmxlX2lycSgpIG1hc2sgaW50ZXJydXB0cyBmb3IgYW55IG90aGVyIGRl
dmljZXMNCj4gc2hhcmluZyB0aGUNCj4gbGluZT8gU2hvdWxkIHRoaXMgdXNlIHN5bmNocm9uaXpl
X2lycSgpIGluc3RlYWQ/DQo+IA0KPiBBZGRpdGlvbmFsbHksIHVmc2hjZF9pbnRyKCkgcmVhZHMg
dGhlIGhhcmR3YXJlIHJlZ2lzdGVyDQo+IHVuY29uZGl0aW9uYWxseToNCj4gDQo+IGRyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmM6dWZzaGNkX2ludHIoKSB7DQo+IMKgwqDCoCAuLi4NCj4gCWxhc3Rf
aW50cl9zdGF0dXMgPSBpbnRyX3N0YXR1cyA9IHVmc2hjZF9yZWFkbChoYmEsDQo+IFJFR19JTlRF
UlJVUFRfU1RBVFVTKTsNCj4gwqDCoMKgIC4uLg0KPiB9DQo+IA0KPiBDYW4gdGhpcyBhY2Nlc3Mg
cG93ZXJlZC1vZmYgaGFyZHdhcmUgaWYgdGhlIGludGVycnVwdCBiZWxvbmdzIHRvDQo+IGFub3Ro
ZXINCj4gZGV2aWNlIG9uIHRoZSBzYW1lIHNoYXJlZCBsaW5lPyBTaG91bGQgdGhpcyB2ZXJpZnkg
dGhlIGRldmljZSBpcw0KPiBhY3RpdmVseQ0KPiBwb3dlcmVkIHVzaW5nIHBtX3J1bnRpbWVfZ2V0
X2lmX2FjdGl2ZSgpIGJlZm9yZSBhY2Nlc3NpbmcgcmVnaXN0ZXJzPw0KPiANCg0K
