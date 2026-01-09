Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568A528506B;
	Fri,  9 Jan 2026 06:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767939682; cv=fail; b=GmOJnCG1JiMQCcKjz2XbjyKfUzxlC3r7S00fIFUYVbKmI3vhDcKXWBYsCqlpZzEKbHWt5+SVQaziF1QwaxgYWpxoCOSwtXRWZ6yvgq75pEu0a/ZRknvbub90lO+Becg2hJ14RDcJQrn5rV4MyHlV63DYAhFpXJm3YG6yIh/B8XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767939682; c=relaxed/simple;
	bh=Zz5JlquK+T1xDU7DWIxgHkRZ+YyvBsujzHqKmG7Vysc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SCc2YaZUCkF9FXa2aWKJM6WuptFcWLUm97WVfHqm+hIh0L63WbTLKeHWvofoGk52ttzm2hNySwg7HPsqO93bFbUl0HnEaVyaAyIFKtwI96Jlzw42WR8I20XulynJIbsN4QN6pCBFA64LavQu8p6Bg7avcilW6gSOQZsySzls59E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hfBWdium; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=mldNrCkk; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hfBWdium";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="mldNrCkk"
X-UUID: 65cbf76aed2311f0bb3cf39eaa2364eb-20260109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Zz5JlquK+T1xDU7DWIxgHkRZ+YyvBsujzHqKmG7Vysc=;
	b=hfBWdiumlCf/Hzf7ClbUSLTRwlaXL2ecgStvMTIOKWprrKBdJXnT+0Q58hnK2XdeQC/aIB8NW9tlLrC87ykPDxOAEuS4NE9g05TNbWicVXXtjbnbIA3ruwaXzwahUBHzxXs9UW32L37s3G2oQuSUSiigdPNQEVKJHs69mFxGCs4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:e8d95faf-e889-4f77-ac54-22d8f7ebcac8,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:7f229779-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 65cbf76aed2311f0bb3cf39eaa2364eb-20260109
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1943679973; Fri, 09 Jan 2026 14:21:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 14:21:12 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 14:21:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZInobJcVS/UNobMKCBzyTg6UcWKhLhRyLMFD2AmHxUJe6eou1AAac38UPTQIc66lgBpx5Qb3UZe3tAXG9CmQBWzu0fmiMr46wggTPsdB3E+gHN57kIAWU/ky9JZZXm9DfaBcmwhB1zdz6/0Ue2Ju5LMup6IjOX/M0gNA81/QicoTC11XpvAIq2x9ojEqKiC6CR5hoLqMUIXvvyuROokXOZy4P8i9lEsN7sfmikSLr/1nPHu83WwvA9+KzLEpOvtJYUWhN5H1JmD2d3vtvYLsWiN5i2rolLDQcQlHW76oTcC3UuSjlDg4Lz+mGt5m8CwFnr/5ivNKseO6ujs7Ghi9SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zz5JlquK+T1xDU7DWIxgHkRZ+YyvBsujzHqKmG7Vysc=;
 b=DEaSunjNkj7AzJ2bY42HU7MmRkcp4vuJmOxxevMJFRXxFZfNDnEfoV5cutOVjGZxGPcXrUKYwKKwroe00WYylw+aC50GtylqVhdJgR0c/F3WYxQqr5gnM2oOpV39DP7fixGtk2Qjec+8ieYx7cjCdrb5gGBM2jdfCOefLuhmNuZnBeEXhGOCF9sKZ+2834hZPkW5MVk4DxGR4y52xy1XSacstbun9TKQVnZu8Tjn2mLRa27PPU9Ij4d682kfchmPFynOmSya0diQCcN7n72qeSZGE+Ny7z8XRsNRjA2MONBUQU/bdU+PoXsd8H8PRSgeoo4BokaGw5H0kzXOSWLkfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zz5JlquK+T1xDU7DWIxgHkRZ+YyvBsujzHqKmG7Vysc=;
 b=mldNrCkk+rUYpho9Zh8fLJt5S1li+cD/zuYehxgB5+9+mM8hn3XJOxiwaLlT0GjrBEyvrfPkdtyzwwY4xVeaWH7wPQ6hRefG7BHPoU7JITbI9s0QwnTHkHrhora7hrSEms+DqISQUlFJKAWouBHiVLQhYA2iQVzlrme1Rh13a0w=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7453.apcprd03.prod.outlook.com (2603:1096:820:e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 06:21:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 06:21:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v5 12/24] scsi: ufs: mediatek: Remove vendor kernel quirks
 cruft
Thread-Topic: [PATCH v5 12/24] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Thread-Index: AQHcgIzu7Ss656GOg024q9eP9UsAKLVJXy+A
Date: Fri, 9 Jan 2026 06:21:09 +0000
Message-ID: <0c05dbe298924b469776c9cea149b01c71deb519.camel@mediatek.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
	 <20260108-mt8196-ufs-v5-12-49215157ec41@collabora.com>
In-Reply-To: <20260108-mt8196-ufs-v5-12-49215157ec41@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7453:EE_
x-ms-office365-filtering-correlation-id: fcfc0e72-ce60-4faf-7d38-08de4f4747d6
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?TUd5eGdpNUZRVWRaU2xlemZUdXdpV3Q0Z3ExaUI4elo4S3VZM3QzSWw1NWFP?=
 =?utf-8?B?YlJRV3NIZ3VmNjhjUWFJNFRHeEgrYTE3RFJzdlpTMktJUjkzZmNTQUkySnV6?=
 =?utf-8?B?aG84WVdLKzR4eGZ0cWtqSG8vK2wzYUlBd2hFbHJjN2tEVEo5VXloL0F0VDJo?=
 =?utf-8?B?ekNlVWZ6VzdlcUx0WlRvUW95aXE3aEVxMG1WQnJ1SWtLSTNTSE90Y2YvZC91?=
 =?utf-8?B?Q0U1NWVJcE5hWWFMcDlNRzloNnR4RFRRK3V5Y0x1dmZNU0QveFZVMWp5YUNC?=
 =?utf-8?B?aThOTS82VUcyWG8rWkc4NTkrWFM3NlFPUUZaK0tpZ3FIdTlPODJ6UmF6L2dx?=
 =?utf-8?B?a0hRRGJodUt2aWYzeTZaY0FvZCs4MjRFMjBOdU9aZXpXUjJGR2h4V2Raa3lh?=
 =?utf-8?B?cTJNZzgvSmt4akNkdjRxRVo5RmcvZ0pIc21lSHkxTGQzbktFYWxOZjYwR2Ro?=
 =?utf-8?B?ckJMUVVta0RaZDFZYk13YmRpVXY0SVRVVmpLTEN3ZUZqY2V6djI0dS9oRWhu?=
 =?utf-8?B?R0pzQkNML1ZvZ1lQNlZwSWJxWmRvNHB4SE10NGJWd09pNndGVjZtNWRHZ1Ni?=
 =?utf-8?B?ZkI5aHBTYnhUWVNuY0FqMEZTZXNGVFlpK3REa2tyUFVRVE4wZmhEb0JQaWFu?=
 =?utf-8?B?T3BXWXRuK1B0NllSZFAyOXhQRGR6WWQxbFVObmxSTEIwRUw5NVF3SkhLWVhS?=
 =?utf-8?B?MGllZ1ZkcDVFd1NVY2RxOFh3d3RlSzhjcUxWcDczcXBzQjJSQTYyMStlTCt2?=
 =?utf-8?B?WFlGTk1lTy9FUlp6REdZd2Z3SmxZY1dvclR5NzhPRHArSmV4YWVXWGFzaE5J?=
 =?utf-8?B?QndOZEZJaW0rWnBaU3FUNWgxMXRveVlWOFBEbTcyT0wxS1VVdnJzSktCc1N6?=
 =?utf-8?B?MGdPWk9lZjlaRzBtRUxRaU55VTZla1JTQzQyYkIweEtlNU1YMHRpcTdNUHYw?=
 =?utf-8?B?aU93NW1KMGlBU25VYk9IaVpHeVdISWRsbVd5L2N0U1NNdkkvUGo0QzQwQVdI?=
 =?utf-8?B?bVY2cEV2aHZMZWJOOGQ1ZDBXSXVlRUI5Z3k4eTlyVTBhbmdrNEFyMzE0eHVo?=
 =?utf-8?B?Umg2czdTYTdSekJxWUFXUzY2eE9qT1FXV01DT1BZVFgya0Y1WGJBdU55REVY?=
 =?utf-8?B?aVpLWjRSOXp0a1E4NCt1aEdJWXdlZm93dDlBMVVFYkk2MGMyaWFJbUlFeHZl?=
 =?utf-8?B?SG9XNlYxM3d4KysvYXNJYjUyRW1BdE5kNU9BUDVQWmhUZ0hMQnQ3WGZyNTVs?=
 =?utf-8?B?TGxEYUo5MU5RRU1CSEE5anJDTDhibzZUN1dmR29VTnplSnlVREUwcWNrc1R1?=
 =?utf-8?B?cHNyeGdSSkFFb0hOeGNZM0trenlXelJ5dE14Q2hiUk5aa0RKK2R2ak41RjNX?=
 =?utf-8?B?RmpFNTNId2hvQzJaOGR4RFpoOWIxYlJjVEVvaVNXaU9COWV1endQazU5L0ZS?=
 =?utf-8?B?Mnh4VzliSjZKV3Z2cDQ1ODNIQWE4cjRwK0JvL2FmMklhcnNyS3l6Q2lOSVBq?=
 =?utf-8?B?T0M2TkZPaW8xK29iZWhLeFkxSkNrRGpiam01TGVzcXVqS2Z2akxWek9UTHJ2?=
 =?utf-8?B?WEp6WmFybG1tZkhOTEFsaHFOR2hjK2dHTmF0T2NBeWZaKy80b09nU3FhcitC?=
 =?utf-8?B?dXJhWFdDVkkxOTE3SHZVenR5eldkVUdBc2hqYmt3eHZEaTlmTUpqRUlLcW54?=
 =?utf-8?B?M0R1V1laWGgxV0FmZDZyRnZ4c1JaNVFUYWJUVFp3YlptYXR3MmR4Mnp0ZStx?=
 =?utf-8?B?OUNONFlrcU5uaGovZUlBOS8wbXFwQldMVzhCZzJYMXN3R0QvNEsxdEIycjdt?=
 =?utf-8?B?R1dkYUhhaTllbmxOaDNNM2l2K1I1bGVYK2FaODllT29HOW5GYkN4dTBBd3NN?=
 =?utf-8?B?aEMyaktEN3lCMWVxMjRqblRDTmtBMVd5T09iS0d4dXQrYXNybnMwT3MzYXpm?=
 =?utf-8?B?UThZekFKOHJRVnVSamlJdFF4Z281Y29xK0E5KzFqa2tNVGNlWksvRjlpVzRI?=
 =?utf-8?B?TXh2SzRhdE0yRURoSnp4Q0RNNWhicVJsT2YvaVNESjZ2bHBBcDdRQ3pZZ0Iy?=
 =?utf-8?B?bWpRNXlxMlNZYi96SVZncGJlQWUyVFhtWUxTQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVFCMmdlRXBKTkdIZGlvTEdmaFRmQm5wT082a3VSTVhFcG1DbGhnUmtsK1U0?=
 =?utf-8?B?S25xSXZ5WmlCUHJaOVZRN25JQ2F4SHpjTHBDTEhWTDF2UzFWbzJrUEYxbkFT?=
 =?utf-8?B?Vi9jNHFVamhpVG5ZUGhldFczUlA4MnptZUMvL091eGU4eDZaUVJQT2tuc3Mw?=
 =?utf-8?B?aU9scERMc21NQzIzenZaWXZEUHFQOEFPVWE4OVFhYU5rYjN1UDhJL0R1MnZ1?=
 =?utf-8?B?bHoxaUhIcENPVEd1YnozbC9UQmluWmF3WGdrUkhRMVduNEtDVjg3MFdpU0dG?=
 =?utf-8?B?SHFzM01EYlptM05La2k5ampBREZ3UkNqNjFuaFZhVkZod1dOYzV3SXhjZHhh?=
 =?utf-8?B?ZlpVQ29mT0NLQ25lVWp0QVhvM0d1K1RiSTkrbWpxamozajlSMWsyV0J3TmZU?=
 =?utf-8?B?NU5hMlJ3UFNYM09hZXM5a3R2YWJtTnR1OUg5dk9wUWFQSEdSZTZsYlFGU3lP?=
 =?utf-8?B?RkI4V3BWbTAzY25wSHBLbkZyTmZkN01EVVlMZ1ViMEhCWmh1MkFWTVlWajJt?=
 =?utf-8?B?WE1tVEVnMkk4Z0hJL2FtUWVCMStRa1NBdmx5blVvd2F6bXd4bnBXam9nSklU?=
 =?utf-8?B?SHBMU2dxVnVnazRCUFYwSXVpZmlUMHBtNmlkTG85M1RSdmVPRFZpVEdqSmpm?=
 =?utf-8?B?ZjVsTGF1MVlCM2ZZM1pOMGQrZDU0UlhEd0pDUCt0dnBvaHN2WUNubVlYN1Zp?=
 =?utf-8?B?c2ZXN1Q0TjdoWWYwc0dJT1liNHJJbXY1enhoaERsYzc5dU1GMVI2UG4rb2JQ?=
 =?utf-8?B?Y3ZCMFlKZ1ZvdmNKQXA3WHF4eW1tM2lBU0d1MkxTZm5vTWpVUXFCYmJnQ25i?=
 =?utf-8?B?dm9pL3NPdFFCSTNrb05hTDZIN0Q3RTdDOEV1RC9IQTY3aVFSS3NRRWhFekJa?=
 =?utf-8?B?U3hyU25uL2NXWHFQK3lCemo3bDFNbUphVmlGV0VocldQWEU1emhRcU9VUFRS?=
 =?utf-8?B?S202dnZYVWR3SzdmTGgvZVM2OTJBWGtpWWtJSytIZGxhRTN6WkJNT1VJeGhl?=
 =?utf-8?B?OTU2b1F4aFBqTEVQMGF3V2lBUzFhaFNnSlgzNUJ3WVpqRWRFZ3pLeVdScUVO?=
 =?utf-8?B?ODNkRmRiZGorcUs5V3dWYWtidmVHTE5PTEhhUC9iU0FqN3FIdytNUGk0OThZ?=
 =?utf-8?B?ZnI4Vk10N20rY25maVM5b2tLWDhCeHhpdWtvVkV4TjhhQTRiMzBVSm5IdzN1?=
 =?utf-8?B?cklnZFg0ZE9CWk1wSDJpUEs5QXpvM3ZwL0ZkZTZZb2sxZStTVjRlaEFGeEpE?=
 =?utf-8?B?K1VpSGx6RlEwd0R4VnpkR3VhOW5MaHFuZDJCVkw0TkJ6ZThuSmxYbzBrMnJV?=
 =?utf-8?B?ckQ2a253dHJ2TWxadWpHQ2wySDZXMjkyaXhwVXRIcnp4SzAwTExVM3d2c3Qy?=
 =?utf-8?B?ak5MYUM4T3k1Q1ZtemFGMWh3ZGNSdlBqbjEveWJHU1o3ajVNZTdEdWxFU1ZU?=
 =?utf-8?B?ZHJMRnNQOURKZFdENkNVN0FKNmpYOEVsT0ZpeDYxRUozbWFTUDFiU0tyMkM1?=
 =?utf-8?B?eUwyRHl0eGp2VHp1Y3VjV0YrU3R3ck0relpYWDZQNXBYeUNoNVFqb2s3QWZK?=
 =?utf-8?B?SVJhVjZjekk0b3lkc2VBU0ROMklIRFVrQmhaZGVmTHhha1hOSW52czJlMTc4?=
 =?utf-8?B?VzBtSERPNTVia3F5elBRVGF4d3lhbGE0bXVhUjhnMmFDTmpiRnMrSDRJd0VG?=
 =?utf-8?B?SVpxWUxUNklSMVlPZXR3TlhtcjNkbE9lcGc5NlpOc0VQZ1NEVlVYWHRlUlNt?=
 =?utf-8?B?UVVmK09TamRXTGIxNXQ2WFNaVTkxMU1XbDRhQjNkUm9mYzFidkE2NFVqQ3h6?=
 =?utf-8?B?bXJ5WUo2Q3NzbCtVN1ZkTFVhdUt4emFsWDZyWDRUVVRkZmpieEhyaWsrdkQz?=
 =?utf-8?B?VDB4WTY4N2F3dldGSlYxaG51emd5OE0weXJKMHAxVnZPd0VMd1NiSDZTUThX?=
 =?utf-8?B?UVZHTmxCdUVPRXhQTkl3YjBLNnBsSXNoZHEvRkQ1NGR5ak5tQXZBaWp5WHlN?=
 =?utf-8?B?aFI1MzhhZGFZblpGaFl6dUo3bkgvZkVIVzVKTkpMSTNCQXRleHVMMjl2RHZH?=
 =?utf-8?B?azM5NEJ2UG1TSHpuUytOWmR1Y0V6end1bUl6UG5ta3VHMWYvREgybmQ3ckpi?=
 =?utf-8?B?SWgzMFh2R1ZDRzBPa2Z6cHB2SXBMSUoyc2dmYWZ2dzNjODlXWG4vb3RnUmht?=
 =?utf-8?B?ejhQejFYZHRvOUxEM0YwSDdZamxvcnpKY0J4UVQ2NGVFVnRDVE9lUzg3YzBJ?=
 =?utf-8?B?SmM5aWt3YkhNZFZxNUhxNmdqbmo3MHNqeGF0WWpuTGVvYUV5WEJBcjV2WFlo?=
 =?utf-8?B?MVhqSExSbGkxMVBSRTZmSHZBZmNGUk9hNmphY0kzSE5VN3o4U2hRZ2xZdEJK?=
 =?utf-8?Q?hbmUmh2eon0KIcIs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B759E8C10F0A04E8039B69C3644926B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfc0e72-ce60-4faf-7d38-08de4f4747d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 06:21:09.9445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: myZsWXOfXK2yQn44hsAlwk0yEQ35lDLNvUTBOCIlC+X7m1Q3tFtJ1qOy+7vmjg8s4Hlh33gGSdlmjkWd33gC2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7453
X-MTK: N

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDExOjQ5ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEJvdGggdWZzX210a192cmVnX2ZpeF92Y2MgYW5kIHVmc19tdGtfdnJlZ19maXhfdmNj
cXggbG9vayBsaWtlIHRoZXkNCj4gYXJlDQo+IHZlbmRvciBrZXJuZWwgaGFja3MgdG8gd29yayBh
cm91bmQgZXhpc3RpbmcgZG93bnN0cmVhbSBkZXZpY2UgdHJlZXMuDQo+IE1haW5saW5lIGRvZXMg
bm90IG5lZWQgb3Igd2FudCB0aGVtLCBzbyByZW1vdmUgdGhlbS4NCj4gDQo+IFJldmlld2VkLWJ5
OiBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubw0KPiA8YW5nZWxvZ2lvYWNjaGluby5kZWxyZWdu
b0Bjb2xsYWJvcmEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5p
Y29sYXMuZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPg0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQoNCg0K
