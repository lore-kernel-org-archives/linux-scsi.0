Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8680536683C;
	Thu,  5 Mar 2026 09:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703306; cv=fail; b=PO8y2NnR8xA2dC89RFxIekxlD59aFXbWr0rpCi3uNpH8WZUpTdn2LIce5871K9v4VXOKtsgyxPseLNghy2z/Eb3QMHxXConRMASuqPvNo52Ll3B5HKqkQafZprB40nPdl+y1+0FRqt0wEpkxhDyTGWkCACG0CXS1ffUUm7zQKtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703306; c=relaxed/simple;
	bh=2uYFhtFl37Y/xhQsF5W3s5MtABIaWiBeZFRURMrG5ZI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mraACxp9imd+NBlahzZIpM9fvR8gyYU/j4MzR/KNYBuLUiuq6C3P85iq4t/d2GfYCW6BzKGkVUFpGslKVfV9dkEgBbEb3sAAH4YFp6TWzjwQ5/nVS22DVmvsvj5JNTswJ1ij4TXvrmEDToKR4IixJ/10E6YxHQaw5J52S153QPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Psicr2V2; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=rOzFM59x; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Psicr2V2";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="rOzFM59x"
X-UUID: 90958546187611f1b7fc4fdb8733b2bc-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=2uYFhtFl37Y/xhQsF5W3s5MtABIaWiBeZFRURMrG5ZI=;
	b=Psicr2V2YBQ2y2qDhrA5kKmwsZWnB524opYaUBG0K0f48GRJzBFBscxzcD7umhD2WuwngRacev/eSY3SPJoDbpqr8NGf0yxGJ5cOLlJF1q5mx1H2iIRmtFbr87LpsEX0j8XLVFE8KeyPX10KMdRtezS1BIZ+aJngmIroa3t5oQo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:10565dda-cfb9-432f-b927-cb0b335213b7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:b2bb46ea-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 90958546187611f1b7fc4fdb8733b2bc-20260305
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1786123770; Thu, 05 Mar 2026 17:34:53 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 17:34:52 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 17:34:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XCaK6jxB2lCUE5vMMEFyAcwdmTQKGIZFxT5jiB1u4stDRqLADyONSCJfJdOY79Sl9uI/XiV8rzRtkG14va0kSpdIsIS4fXIlZeUOwC/96YeHwh/P7/NaotBEfQzB4D/hMal6X9EzTh/8CG+BQzP5N7sJhEewTD4+uprylH9Vm8JWQ8dOOqlcTJV3uYCAyJwcaeMg6FC5Xa5mp37SByK6MmkU1u/fzKzR6P5/rnlhIVXqOFMJFA7HquoqkoX0VplUv976YFbiIX9ZaHNprdNf2fUa/MEfHd8ETYcS37r7kRKTeRYEnksJR95VM8PdJcbNeocFBjsC/3s/I5FRebZSoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uYFhtFl37Y/xhQsF5W3s5MtABIaWiBeZFRURMrG5ZI=;
 b=msckGPjOuDktwCev/8wZ7+qAvRGhYDftMOJSWc+EsJAxfki08yZkMcpTm18WNRutKrgSSA4eZ9b/VN5inJ4jAsoCQTpWnnmQNViMrY84IRGBnQiEbnv1K5o66Yda1/GEWahnVbvnn0x4wMpZHYBGhYjzmG1oWke68NrwbHLB8uvQQTL8zu+SuarxVlziNXXsx83P7+aY3Cl4MrcAbi0Vo0rV2WaUoMCRQ69jSpCPjDS3//tv3yK+pHJ328RibsSWZpndrQLs0bmkSe7zgL4kTBoDHMvmey+JCLUPa3iHtqaEWMaadwnwiRtLdJ0Biw37v8b1FKdvAsaaBLBFxSpXmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uYFhtFl37Y/xhQsF5W3s5MtABIaWiBeZFRURMrG5ZI=;
 b=rOzFM59xdWWJoMd5fq5xc4OgioF2s7lSXOXilzfkOHbTg+HetCjlBG4G7gPVvj5iR+UbxY2ysRO5B8iKKAQe+8qnbwWfX9Hnlo/0V71IigHrRJUPCNgzbxV6kYc1HH0Ai5IwTqx5PVdODeOKhxfihNREtPkRD5Jm0Lkq8mOZekg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8822.apcprd03.prod.outlook.com (2603:1096:820:144::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Thu, 5 Mar
 2026 09:34:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 09:34:47 +0000
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
Subject: Re: [PATCH v8 16/23] scsi: ufs: mediatek: Clean up logging prints
Thread-Topic: [PATCH v8 16/23] scsi: ufs: mediatek: Clean up logging prints
Thread-Index: AQHcq+cRyg6+puh2fk2Dudf/xVJc+7Wfrs6A
Date: Thu, 5 Mar 2026 09:34:47 +0000
Message-ID: <070f6e12704d44b753753dade1ddbde2c1b82069.camel@mediatek.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
	 <20260304-mt8196-ufs-v8-16-5b0eac23314f@collabora.com>
In-Reply-To: <20260304-mt8196-ufs-v8-16-5b0eac23314f@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8822:EE_
x-ms-office365-filtering-correlation-id: 85db9778-ca70-49ec-7d5a-08de7a9a7164
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700021;
x-microsoft-antispam-message-info: UycT4hOkp8mb2z1Q8ViIIsvQkUwnWrkAQjP8+euU8yKTSA6KxYMGk45po7HO4+8P9CsC6rl6CalgSLoiRNmDaAl3tzGaM58X+2ubjXRhD0eflryUoD/I+/lXiRCJvVrtWza+KmuFtHpSe2JPS8C3vX3aPIpWM+eQgz27mCbr1CQxI/zDKUt7APElXNolDx9OiN7pN95dQ3squvyjl991pvTS7q1R4MX1fEnN2lB1G4RbO68URv+VmIo2gdQ8Rci6ExSRBl0eM0Ral25Q0x0WpY2l0a19r5+xNcXTLXLHFkoaBB1wMgNiNNloOgayhjP77c7BfijPqeJbwowJpUmPLV893tyIl5YsucWaiX6YvL4IE1y6N55+t5kTlZRO6Z0gXgl+WzmSDe4vhAIOrNMtxPLSN9cxOexAtU9T6OOXlunWBPbE0qlkNmFsFLawsuSsPADm6+htd2KLmxhb/0GC7OLVrpMGKn0V8RYE5hO/BWdX83rT6CSM5EAjWqro+qcMIr7xvEElTYDcEBvR7M6/+Bj6nPbyi48zuA0LJ9hlN/Ygg3tHzOLf3UF/1DtDn6RU2anNOj0Cvo++WdAHInaVEtixPXVzmkRuTIDI4cYA7Q0cVS1DYJRggIF47yj6NXoBqLc1rCjAu2m6TQz01yr6avzE83UZ0DsVOtifa1qZUfx2OvyQC3BZIl9YAPgXQuvG0B/jTNTSHCdcBBnvY8PLtHhaAsXJfEdFXDKqoqkwOb7Rnp7BwuoBxhk0qtaqIulzfPXcfsILoUUcxXhwgSYJMzV2PaPXcUkxPIPYB9xsd+ty1fAI+a/tCcqONjKvec/H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkVEMytlSHlQYWV4bG1EK0JaWWl5a3pNUXdnMmc2L3dEdTRHUUNuOUV1ZGRw?=
 =?utf-8?B?d1BHUEFoVkRpTE13OE9lZG4vMVNwaU9DNW5iZzRmNDMyVDZPMmtFMW11eE9j?=
 =?utf-8?B?czF5SHVZSkRzMG1OU2RuSzRFN2pXT1VEcGdwWFRmRXFKUWN1WFowam9JbzVD?=
 =?utf-8?B?Y0c4TyszMTBFejc2MEZ2cjdzUjRNaDRsYWVKeHpITUMxTnUxVnJZMThFMlpN?=
 =?utf-8?B?VFd6cXdkL3lJdVZUTVJVc0dSNHJyYzd0V3dLOTFBczNYWmpuOVp0ci9SZGJJ?=
 =?utf-8?B?RkJhZmZCMG1FZlh0YVRneE5haFdWS20rYVQ2VFZaWDUyZlFiS2FSRU1paTZB?=
 =?utf-8?B?NE5jMEd4M3ZxVWtjUkI4TnlGakppZkFKeE9Dd2UxQ1lBVitnYi9vdGdjSlBM?=
 =?utf-8?B?cEp2Y2x6N2R3S0hwVHVmNDhWUWRXSGcyMHlpVFdHSnZtRXFOdkZ2eHBLZGVl?=
 =?utf-8?B?bE5lZkR3YkRwYmRyUkx0R254bHU3S3F6ZUNIQlhYLzJOdGpJOXpPQVdua3VU?=
 =?utf-8?B?c1A5bTNrM1lyQkpTWk1INmoxNWJYaUMzZ3ZoSHlyRDY2UDhIMXkxbU1IU2gx?=
 =?utf-8?B?QzRjNTk2cTF4dzRoMjMwNHRGZkpINkRDb0w2MXlsd3BCWDdzeFJSQ3BvRklP?=
 =?utf-8?B?dGx5TFRqTkJiMGhDMjIyQkZ3UlJLazM0WldTZHB0R3RDaWRjZm56azZWcjdH?=
 =?utf-8?B?MktDcTZQNFc1R1NoRTh5WXFveEpmb25zMkJpWUlONnAwUDVmY3lQejVXUmRl?=
 =?utf-8?B?OWdVdllXaWdhWldlQ0ZpcFZ6OURYcmozLzlvVzgwRjVzL0cxMmdLM0JvTGw5?=
 =?utf-8?B?U1ZmZ25JVUdSZ3E1blhwYXZ6ZHF2ekZjdlVXdDRFSDBRM2xEaFR6dTR6cXFv?=
 =?utf-8?B?RjJCczVJMEhDc0dJbHJ2U1U5NUUxeERXNGU0cDVIeW9ZVjJyNVk1VkF6bkZP?=
 =?utf-8?B?aWJFclFjT3hqTnd1M3J6aG9yMWZxbDRXbExlNTJ3UHQya2s3MnJaWnRZWmlo?=
 =?utf-8?B?RjZUblRGTG81c2tGK2d4SUoxY1dxanI0U1kyaGNTSWR5TDRwN0J5SlpNVDEy?=
 =?utf-8?B?TVd1MjhGcEh6eGN6RGp2ckF3ZGFSNS9pMlk0ZlpzamFvZVl6Vk5TOGptTTlu?=
 =?utf-8?B?eUJ1NGFFb2ZCM0FnYVA2c3N0RkxhR2VGZENxN3NNMXB0NlNTcVJycTY4aU9L?=
 =?utf-8?B?SWVac1ErTDR3cWcrOEFOT1UzSklxRFdiZUVkNXR2eXNpUnZRaWl0RDZkd2RF?=
 =?utf-8?B?OVltM1pzczNRb05razV0bnZvWDZETlNiVmM0ckJKbm1WcWxiaVFFSGt1alNZ?=
 =?utf-8?B?aVVEdVdzbERaZVkzdE9RL1QyYUZ6RWlKMU9PRUwwaW9vSmhOd2FGdGxXTkRZ?=
 =?utf-8?B?T3A1TmxyR1pRMTZTWngxeHMwVVBrQnIrTEQrRWdLemRPR1Z0a2JPNXpjYzNG?=
 =?utf-8?B?NFFEVW0waGZEVHU0MmtCK3dnNFprNkZDR2RTeHNhMUh2NmJLRDJyYmp6aHRw?=
 =?utf-8?B?VFZyUGorVXAwOFNYQ2ZsSDVVQWNHeFNoUjBFNWVYM2J6YjV2Q1J5eHdpMGZG?=
 =?utf-8?B?aDFDYmtwS2x1bGVSV3NmZUJ5bTBBSmRmQXZlQ0p3WVkrb3FJOGFqSUYwclcv?=
 =?utf-8?B?MXpONDZkK1ErTHhqeWlwRTRIVHo4TGMrNUk1R2hxZWx4T1BUalhTSmh3dmdG?=
 =?utf-8?B?UEdsVTZzZTIxNUpEejNpcE51cHRiVDN6dEZLLzlyNWtaczdYOTdRQm9HTkV2?=
 =?utf-8?B?eXRhbHVweXR5K2t6TUh5aTNLYkpNdWRPdmppbW9ZRFFreDJVcFJvTXpQdDA1?=
 =?utf-8?B?VTBHK3Q2NWJYMTA2NUdmczNhTVk1VEJHRTZuY2w3cDdpcWw1d1dPOER6SmRm?=
 =?utf-8?B?R243MU11aUMyc3RnNWprMXMyMC8xWnpvaWl1Z09rMUZQTnU1MzRPT3JCc3lX?=
 =?utf-8?B?S282eXJVSHR1TW1pWHQ3SmloOTNBcFNyaUdhcGpMOFVEamNxa3VZaFFULyta?=
 =?utf-8?B?TmhNb25GWjlkZ3ovaW85bzdLL2toM3N3aU9vd2JSbGRiSUFVbG5RR00yNHZ5?=
 =?utf-8?B?OWsxYU4zSHBsYkEyMmNrZzRBWjZybVIwUWw5bldwU3g0bGl3dDdvd2s3YXRo?=
 =?utf-8?B?aUtVMWJreGc4UGxiaVBRanBKMGxKRFhyRUVkeWlFTnRoelkva2tHZUcxbUNr?=
 =?utf-8?B?K0RjV3BRY1FOQ2dRNVByUEJ5Q3o1MmxwZWhhZi9Nb3ZoeHI5T2NPZUI4ZW1n?=
 =?utf-8?B?d0VHNFFJN1ZEejEzbVpBTGZhOEt1b0RFRyt5aFd4d0xvb3dXcDlHV0s2NTdM?=
 =?utf-8?B?VnBLUWZxTjNBc29GZjVjUGJPRzJqamFPTEJwTzQ1RzJoek9PbTQ0Zi9yaWdB?=
 =?utf-8?Q?poOFeqDSVa6Rlb4U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E089DFF950AE884C9D0BDEEE0C020886@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PTEDKMhFheO1wfzCsivDyRcyCQJC+TxDweLDeBEyxP7Ylm2hsUKcyzaoRuoWrmpF25kBZZE7AUEZAlPBF8cDWR4yVRnY+PA2ZTAqnLhELZJxFFrR07yIqg36lPILBd7Yvv5zgTDyiPE1dvhutqycqEwS0GBLjLB1cr4SVGVBbvn5ZOuX5sYoGSOZhB/YpdFtvsb56fplXYMsiBxyOeKIqzpx4ukxmsv4t23je+XPBiSju5PcdMcKV0qWPKHQ91YwIvUU4s3nAeilbmidLgG141VpG64c9SILBK3lwr4tLujcqJjrezrrXyUoCnK7xNvlU9WTrXoFaCgXn4yyN0AbqA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85db9778-ca70-49ec-7d5a-08de7a9a7164
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 09:34:47.8852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vV7wPBEwG9tMxdPYiwMfxRKte5D27IuFSFQcSN/6asvUOzlpFFdX6n7s0ZN7eO7qXM6iKv1OCToyPTi3YgkLuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8822
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDE1OjUzICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoZSBMaW51eCBrZXJuZWwncyBsb2cgYnVmZmVyIHByb3ZpZGVzIG1hbnkgbGV2ZWxz
IG9mIHZlcmJvc2l0eSwNCj4gYXNzb2NpYXRlZCB3aXRoIGRpZmZlcmVudCBzZW1hbnRpYyBtZWFu
aW5ncy4gQ2FyZSBzaG91bGQgYmUgdGFrZW4gdG8NCj4gb25seSBsb2cgdXNlZnVsIGluZm9ybWF0
aW9uIHRvIHRoZSBpbmZvIGxldmVsLCBhbmQgbG9nIGVycm9ycyB0byB0aGUNCj4gZXJyb3IgbGV2
ZWwuDQo+IA0KPiBUaGUgTWVkaWFUZWsgVUZTIGRyaXZlciBkb2VzIG5vdCBkbyB0aGlzLiBJdCBm
cmVlbHkgbG9ncyB2ZXJib3NlDQo+IGRlYnVnDQo+IGluZm9ybWF0aW9uIHRvIHRoZSBpbmZvIGxl
dmVsLCBlcnJvcnMgdG8gdGhlIGluZm8gbGV2ZWwsIGFuZA0KPiBzb21ldGltZXMNCj4gZXJyb3Jz
IHRvIHRoZSB3YXJuaW5nIGxldmVsLg0KPiANCj4gQWRqdXN0IGFsbCB0aGUgd3JhcHBlZCBrcHJp
bnRmIGludm9jYXRpb25zIHRvIHJlY3RpZnkgdGhpcyBzaXR1YXRpb24uDQo+IFVzZSB1c2VyLWZy
aWVuZGx5ICVwZSBmb3JtYXQgY29kZXMgZm9yIHByaW50aW5nIGVycm9ycyB3aGVyZQ0KPiBwb3Nz
aWJsZS4NCj4gDQo+IFJldmlld2VkLWJ5OiBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubw0KPiA8
YW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPg0K
DQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
