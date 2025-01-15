Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB0D29A5;
	Wed, 15 Jan 2025 11:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736941837; cv=fail; b=EaDJd3nOmvOC0OSQ80h25FQC3PbSJJNOv3BFuT6pBSzSIQurGuFo0zKlUPxCRX1hV0yXFPb3CrlrKu/JJG6D7Jr3gzgpL/mXG7SVU9/dwLzlp2UWib6cIt46nTdgrSgIZUuLOMginQVFibNXM2oJUp32dOT83gvvMT5vvTOZiNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736941837; c=relaxed/simple;
	bh=/wLXk8wIVXlRYlK8eaNQp2mwNWOkXGQTUqTGXw7Hfa4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IWzUXwbnJSCKML960PHY3CJPqF9rlcugZk9BsXUVkcT/lap686763i2AOQOBLjWdncjWvnlZDfml+2uycpFO2ZyLCIfqH4W54mTEIoDQCWMobVswHGsyKO1V5Nn+fNoWtp1DLCP64flrLiBK1tCAkzO9Dwkus+iL+gsaw3ZLe4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kbLFnv9e; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=l4gWBtE0; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kbLFnv9e";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="l4gWBtE0"
X-UUID: e89ce3aad33611ef99858b75a2457dd9-20250115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=/wLXk8wIVXlRYlK8eaNQp2mwNWOkXGQTUqTGXw7Hfa4=;
	b=kbLFnv9e283a9X12dVuDB7/Rdny4GyBvKNl5WW0KsN4wqdvsmZXMDDRa/64gN08GzNAEVcrpZn9bRVcvR+vMTWg3LBjWv411xbHRuotqNDzsh6x22plYsAuIEQkd3UvhOi8eAJjuqdWFMYCGwbryIEn2h6Vu7mkZQ2Vqoym7lRQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.46,REQID:da88d26f-a9f5-4c0b-91f7-b03ba8830e96,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:60aa074,CLOUDID:adf21385-0f10-4f52-bb41-91703793d3e4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e89ce3aad33611ef99858b75a2457dd9-20250115
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 92955007; Wed, 15 Jan 2025 19:50:25 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 15 Jan 2025 19:50:24 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Wed, 15 Jan 2025 19:50:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XtRjjKfB4edhcR0suBFPWBUcDKgF6BilKqLe31DiqlN6bwiMxUk2cr794LGxhKjS/l0bKr7Lv05SjGWN8ZkiZ4m1UJEJEBkhPqoZ0qPPwOWIm0vWjk60VBkhwfoEJ/oRIbV6BnM5IjCFR9lEgVKlOJ3OB80J8hhhFEBsBM6HLZ+KDc6onmtQ76gNkMLMQHMERlClzatips8pzrw3WsFjE4QD2OSyuUKN6k7palrS3t1y1ImhHsukk8yiU5YNbD1CWQ0gdRXGoC8FcyEsJSej3thVN9J42T+3kw/m48N3o7bThsZduYIGFT4bNL+ot6udfB6EjjU9yAQlwzEqNyWOWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wLXk8wIVXlRYlK8eaNQp2mwNWOkXGQTUqTGXw7Hfa4=;
 b=a7+J52E/BtBAG0/pe2JUDdZdqqzdgcZufiueZWFXrQ74J8kaLfy5f1Pqh2fpljv3ErhP2WrPFIcyAxBrpMYLtNBFLLgDqy7Eou/c+sqzVDjiFettT7tbbZys7+Yn+plPtH1GwlHg7+njXvj/2xDKfBesdxA2Ahj1zznoVdzK4v6BPCjzOooQ1EoAEm0m/2SLVJG3Y0cFAuTuv9z3CTbpAwMejSNUJJos6ilcNVjg/fjRoi1pSkkAfuJ7n1W0QCO2+9iC/1TTyvz3gk3Q2Jk3ImLn9sPP9FU0FAXKhZqhg5rdVOedqdeCbAQu/H+T+5ee62qFD7iL/y+oXPAOQQatkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wLXk8wIVXlRYlK8eaNQp2mwNWOkXGQTUqTGXw7Hfa4=;
 b=l4gWBtE0eyX2qUA3CDrAuliWtb+vyTVNI5Iz4iRR2EW3Yg+4JYqPUn9WdZmUkuv5qUjBnoyLCmmoEIPAlAwsGPQLiv8Mo5VTWHkiGSHY20cHkCUcp8ROpSl8T4ocwGRPpb5dECDuRQyedLSeDlbU3NtMcWepqdZoZAOJ6cKijtE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OS8PR03MB8818.apcprd03.prod.outlook.com (2603:1096:604:28a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 11:50:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 11:50:21 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>, "krzysztof.kozlowski@linaro.org"
	<krzysztof.kozlowski@linaro.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] ufs: Use str_enable_disable-like helpers
Thread-Topic: [PATCH] ufs: Use str_enable_disable-like helpers
Thread-Index: AQHbZr//7Aqd6xcrWk+l/hNYKUzuDLMXuc4A
Date: Wed, 15 Jan 2025 11:50:21 +0000
Message-ID: <e03650cf09417680b35bc57c7b8c434733d86d12.camel@mediatek.com>
References: <20250114200716.969457-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20250114200716.969457-1-krzysztof.kozlowski@linaro.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OS8PR03MB8818:EE_
x-ms-office365-filtering-correlation-id: 4d629fa6-9ff9-49d2-2cc9-08dd355aca58
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RWtCZkQ0bDBrcFR1VnphZ1N0SlBWL3BrR0pHYjNLeU5ROXZ6YmVrYUpyK3Rz?=
 =?utf-8?B?bE9iRVBTRWw5eTE4SjVzSzZORXJvYnREY2cram9lUGpHSFZkVlZXVnQyelIz?=
 =?utf-8?B?Z3NGcXk2cTRKaGN3Ym5oYXo5QkhNcG84U2N6SWJ0My95RU5KS3ExYTQrZXJR?=
 =?utf-8?B?TDFiNEdjRExDM1kwcjh5Ynd3dU0zeUh3anNsaytXdno3L2lueHlmek54NDdN?=
 =?utf-8?B?RWV2UFhBYkVLSnlzQWxKWjRFNjh2MW96QTdnMnBmWGkvNmhYNGx5M2VKNDRy?=
 =?utf-8?B?U0E5b3RuUkpWSlhJNDI4ZEhsN1VLbFRiNUZIbUw0RDl1bUcrbFhsMFBLUTVJ?=
 =?utf-8?B?VUNCQktRaVpkWEY4aDBmQUlRWU5YMWpvbkZSbzNsMTdoTlFXY01Kdk9rQ0Zy?=
 =?utf-8?B?SFM2STN4S3NCUWRoUzk3a25wZkd2NnhVTmIrWThCR0EzSzZ1cVo4KzBjNmdO?=
 =?utf-8?B?eWRtQlBJTktsSi8rOWVENFZwZ3dDMzZxaHdycmlZeHM2Vkt2MllXbGdQZUJ6?=
 =?utf-8?B?T3Y1WmsrN0UvNzhwNUFKbUxwQlhLL01vdG1IWHJsRTRaNDlzZVBsVTFCeThS?=
 =?utf-8?B?TU9xSXhyeVdCU3ZzbDFURnZESy93ODdBYUNOTEQ0dEVRYlNDZkU3QXYwU0NJ?=
 =?utf-8?B?WjE0aytTblgyOXRIWXcrTXB5Wlc1MDNHL0FwT1FaNkJ6TWQreEt5K0xSZ3U4?=
 =?utf-8?B?czRTdVRrRVYrU1BUOXd4WTVoZFdWNnYxeHZaMEJlWFNDUGdLN1lwNFNZYWRh?=
 =?utf-8?B?SkVDUkJuZ25GZU9VMmxMb1FiS2t2ZzRVTDZiYkpQOUZXUzlyUFNKSnlXc3FV?=
 =?utf-8?B?cFFUdDdUckdGSEFTOW5ZckxZUW94SVJ4MzRTMloxQ21pdUVzKytWV0NlRmNj?=
 =?utf-8?B?K1FnMnRXL1V1OGpuWnhOT2Q1Z1RQTkkxZWJOV2w2RUw0MkJPNktxR2JPWm9F?=
 =?utf-8?B?dzFhckFVbEs0ang0VEhRdmwyaDlJQzBRWHBIeUJZV2ZZcE16bi9QdTVlc1l2?=
 =?utf-8?B?QmhKKzZjRnE1NW95UUxMeDlJM2xVSE1FeVUxMFRWZ21nS0FnL2xkeUJ5UkFq?=
 =?utf-8?B?M0FyamIrQlJZSmR5VERuN1lqY1Q3ZlJLMWNuSXp5WTV3SlF0ejhQY052elhG?=
 =?utf-8?B?WFhsdHpSVXA5dmUzTmRqNEdCT3ByZ0YvN1FwRkVxR1JlL3Nta2hGUDBvWmZS?=
 =?utf-8?B?cjZTMVlCSXB4MGhBN1BZMzZ1WWloQS84UnQrUDJ5RnkxQjM3RkprWktvZWMr?=
 =?utf-8?B?YVpSRmE5T3U5K3dBTnNkWUFyTUVYcktxRXBwcGlLZXpwNUx3N2hCYVZHN3pO?=
 =?utf-8?B?bWZIUTI0Zm91YUZKTmQ1bXlnd2puMmVVdVR3QktzYTUrUEVSeFVaUzJkaFdQ?=
 =?utf-8?B?TzRCUG55TWdtN1N5cmRmVnFzYitCWk1FeklUQkZGVzVXVGU2bEVYRVRyTGp1?=
 =?utf-8?B?NTNSSW53V2sxSVBOaHBxbU9qeWo2bk5EaGNvUVdBZ2Z0VHRHQ3V2dmFlUS9O?=
 =?utf-8?B?dkNvRHZpKzJLZmRSd3krRHhINWt1NjB1TU95MzFCQ3FMR3dGOVI1VnRRTGJn?=
 =?utf-8?B?S1FtbDFZT2hsSzl3L3ZqWk5tRnB4RTBDQ2hwTXVtcUNaK21xdEZnZmFTVW53?=
 =?utf-8?B?YlZhcGtJZHdpNHM3Yy9GMUhxRG45eEk2MVpSYXRpY3BZbjZhNTFsYWZEOWlV?=
 =?utf-8?B?K2pUT0o5WHB5V3Y5M1A2SGVzYkhIOHJKQnNjWGR3dy9wdWN6MGxnOUNmOVBD?=
 =?utf-8?B?SVc0YVVBOXZtR0RnejB5TWRSK1FXTWJrQllUaDZjM0FhUzB4RWdYdFhWSUdT?=
 =?utf-8?B?aXh1MmRsRTB0MmtxSUtGdEhDa3RQcS9Uak9obHNMYWdXYkpYZG1OTDhFaWpM?=
 =?utf-8?B?R1BkT0VwbVpvajArWXEzSVQ5aUZYRXRBSVRWMUhsU3d1TkJOWmdJQVhUVUJS?=
 =?utf-8?B?N3NldVNrV3JlNlpjemVHSGJKNStWd25MQTRuOTF3eHp4Ni9weXp6bjlxcGdW?=
 =?utf-8?B?KzNNWEUwTDRBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlNzSURtbXhFQjJHREZMQmlwWDBkNG1iTEt4aGlzaGJzSFNYK0k0d0hiQ3JU?=
 =?utf-8?B?bENZeUEySElsYnI5V1FMbWhvOTUycGZOVFEvb2poN3RrRUQrdUozYzJCeFo0?=
 =?utf-8?B?WTFTVlB0dEVMUzZGMnpOdmRQNUsvblhSNUZvcktUV1hIOThBaFJwRmJiTWg5?=
 =?utf-8?B?alZqTG9aaHYweG9Wc1Ntc2JoeVZCZTg2Ri9DWWVrck93c1BLY2FoQ3N2Qkps?=
 =?utf-8?B?RUNJZjlzUzJuSTRCRllWTzhLU1NoeE43TXl6SjNIWndJNStVQ3FhQ2Z1czd2?=
 =?utf-8?B?WXBsZGFjdnpFNVhCYis4dHRLekdvTi9ITEF3R3JsSnJLVUlIaDlSOXJYVHRK?=
 =?utf-8?B?NWFQc1Z6SmhMcjNPYk5KN2pUYmJ4TEVRb3RuVGpRd0JBRUZ2bnRhMzVLRlZ3?=
 =?utf-8?B?SFhLZG41bzJJVGJvVVRhZWtUTVhha013eGdmS2h6L0tqdFdKdnZEUzEwbkNs?=
 =?utf-8?B?eStzUEZJcjNtbDZDc1g5MWxQZURJQjNoeTY1eXZmSHIzdTIyMHFIeGVwa0lI?=
 =?utf-8?B?YjI5RXBmb1hkaENvNmN3S2lTRm5qaGM0WTVMaEVzOTB1N0Yrb1BJTGh2WjU2?=
 =?utf-8?B?UEc3VVpLU2NPcDB0bDRZUFR2bm1HZnhPRlZMaGdlVnNadGdTK2RSQnF3c0JE?=
 =?utf-8?B?cUFXbXBLcnRBNExWSW1LR2ZvY3lmaXRQN2FvSFVXdGZQYldSaGxMVWhUaFV6?=
 =?utf-8?B?RDBxalE1UldmM3d3dXhhRlMyRWVjNzN2eE52SFBBRXN5TlBXZExTZmtITTBu?=
 =?utf-8?B?QjdqeEFWbmJOMGlyanJJMWVzZFU4TEJxY0t0ZnREK2lHZVFtN3R6c202Yncx?=
 =?utf-8?B?dURYVEh0NGpnSjBMTFA1dmVsaUFsTytzeVJEOWVUMHJBdTJIamR1R2ZNYktM?=
 =?utf-8?B?aGF3dUpIaDJLS3hkM2cybkhWQ3kyQUg1RWp6Q2FiMEN4eEYrWVZmU1VKSVZv?=
 =?utf-8?B?N2tmbWg2dCtKQ2h4UVp6dWRMU21mbjFxenV2Y1RtSlZpem5WZGdOc1RhZXdy?=
 =?utf-8?B?RU16K3VpbHo3eC9NZUdqeWZGQ2Y3KzZPRWhWTXRuUlQ2TFlaQWxTWnJyYS9S?=
 =?utf-8?B?d1JEZENRY0RGdjZwKzhPayt1NWo4VmJwbmxxNE5ucEpJWVlpd25MNERsNVQv?=
 =?utf-8?B?SnRXYk1IaEFlSW0wbWRwUmJleHBSalQrNitNYkxNOE5TK1U2Y1ArNE9JQ05K?=
 =?utf-8?B?ZFI1blQvdFlLVE8wZHdwR2lTWXZHM0pDRFNvYVlNL2JPWTNISTJ4VCtOdi93?=
 =?utf-8?B?U3RXM1BtSzAyY1VVcDBrYk44SzlraTlrK1Y0RjBvSFZVOFRhUkdqM2NTaTlQ?=
 =?utf-8?B?c3R6aGxMSXZsOXl3OWZEYXMwOHFRRVlmRkExWmNyTy9vK1M3MndHaG5RVTFi?=
 =?utf-8?B?ZHU4cFQ0cTc2eDZqTG5EVFcxNVFjOUNtQ3dJSmNDWmNPd0lsWU5VaWRqbCtP?=
 =?utf-8?B?aGVodjVjenVKS2gzWUp5Z3Irb3J4Mm5WL2p1LzRMcmY1ZjVoOG1kdlJjc3lK?=
 =?utf-8?B?MWgrN0VVY3lFNlQreThkbm9xU2ozdDcrbDZqN0N1SVJobWFjdU5vUkVmSllF?=
 =?utf-8?B?WW5xbUNqS3ltTG1vMldoUDdBOTR6cy8vWDN2a1VKYzU4MVNMektaemVpRzRa?=
 =?utf-8?B?Sllqa0owZVV4TXc4Mk5VeE44ZzFsc0NvbUU5Q1VYOUZLRlJzWmlyR0xRZkls?=
 =?utf-8?B?dUl1YkN0NVJMTlBsWkl3T1NCOWdiYlRUNmJUcFpHOTlyL2VrLzlkNFJZa2xH?=
 =?utf-8?B?SW5ueG9ld3B2Nks5YU5DMlJXOTF1SzYvajJsWCtabks5S29wWGJCM3JjRUN4?=
 =?utf-8?B?d1Uyb0hsejZncVVkVHFCMWl4aVk3NXFXRHBtOVVqODhDbVhtdW43ZlZZdE52?=
 =?utf-8?B?dE5EdG1jdTJsbXMwZ3dwK0pXZlRUdnFqV0t1R0ZibG5IK2wrN2xqbW5nZTAx?=
 =?utf-8?B?aWVKNm9udVloTDZ4ZDY1V3BBQnFXdzd6QW94T3g1bjVIRGd6K1UxTDh3Tjc5?=
 =?utf-8?B?RkdFaFE3UE5ZT2pHQnJuUHhpT0ZBaXp2cDdpdDJjL2ZHek1zNXNHMDVRZkxu?=
 =?utf-8?B?VElaVlB0cFVGTkF4SlRjQXFzQ1AyOC8rUURjOEs5MGFYU21iRm85VndibXBa?=
 =?utf-8?B?b0QyeHlEYW5PMnhLbEo1MHNQTUd1aE9BaTNqT2k0R285OWhQdVFNbFVGdWhr?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08CDAFDAEA9F514FA2DBDE2761A4F37B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d629fa6-9ff9-49d2-2cc9-08dd355aca58
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 11:50:21.4211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p43oASnLQxVgODUpIEyg78sIRBtioGZ9ZJOuCdNc40dGRWw3Ro5PATEKs48I3hBiGHfqp/5LS6a3vFBDItgQvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS8PR03MB8818

T24gVHVlLCAyMDI1LTAxLTE0IGF0IDIxOjA3ICswMTAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBv
ciB0aGUgY29udGVudC4NCj4gDQo+IA0KPiBSZXBsYWNlIHRlcm5hcnkgKGNvbmRpdGlvbiA/ICJl
bmFibGUiIDogImRpc2FibGUiKSBzeW50YXggd2l0aA0KPiBoZWxwZXJzDQo+IGZyb20gc3RyaW5n
X2Nob2ljZXMuaCBiZWNhdXNlOg0KPiAxLiBTaW1wbGUgZnVuY3Rpb24gY2FsbCB3aXRoIG9uZSBh
cmd1bWVudCBpcyBlYXNpZXIgdG8gcmVhZC7CoCBUZXJuYXJ5DQo+IMKgwqAgb3BlcmF0b3IgaGFz
IHRocmVlIGFyZ3VtZW50cyBhbmQgd2l0aCB3cmFwcGluZyBtaWdodCBsZWFkIHRvIHF1aXRlDQo+
IMKgwqAgbG9uZyBjb2RlLg0KPiAyLiBJcyBzbGlnaHRseSBzaG9ydGVyIHRodXMgYWxzbyBlYXNp
ZXIgdG8gcmVhZC4NCj4gMy4gSXQgYnJpbmdzIHVuaWZvcm1pdHkgaW4gdGhlIHRleHQgLSBzYW1l
IHN0cmluZy4NCj4gNC4gQWxsb3dzIGRlZHVwaW5nIGJ5IHRoZSBsaW5rZXIsIHdoaWNoIHJlc3Vs
dHMgaW4gYSBzbWFsbGVyIGJpbmFyeQ0KPiDCoMKgIGZpbGUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBLcnp5c3p0b2YgS296bG93c2tpIDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+
IC0tLQ0KPiDCoGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmPCoMKgwqDCoMKgwqAgfCAxMSArKysr
KystLS0tLQ0KPiDCoGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgfMKgIDcgKysrLS0t
LQ0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0K
PiANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0K
DQo=
