Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5171810785;
	Wed, 24 Dec 2025 05:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766554438; cv=fail; b=mPCu3Sb4PsHDYvxWIo7p7+B/fJERfFn3VhZwnYzJvk/JvZAuXa84WzpGrui0oN60oXtQARPgfibrxiznNfJNLPR19ooFm+03BN+eSFU0CjUdMphvVqH0jCfKcvLMcjNrrjFTN8oqIeHPVAY3xSeQvRi+NNRoMSyNQpuiUt/WhKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766554438; c=relaxed/simple;
	bh=VxhC54uPP+Mz++zYXhUXSwTNpOhC04ZMynwQpWTpjnU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hO7bdJ+r5YipCLCRlup3zXCStaegUH+NedbesL4xQF7rWrFCPnDSJVy4J4MCvhOYmBp4iTCvisjH2GYiByZfyy/yQc62Mm23XEBJSy0xjdF6GM/ngLTo3auWrtaRLbStarUKG9l3xZgnDs51YPIa5GSsy20t6z8l6anLmbINSVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VkDQJklT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IxL5nGbi; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VkDQJklT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IxL5nGbi"
X-UUID: 1f5ff790e08a11f0b33aeb1e7f16c2b6-20251224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=VxhC54uPP+Mz++zYXhUXSwTNpOhC04ZMynwQpWTpjnU=;
	b=VkDQJklTxT31jicmbYug8BCz4CWp/+uXeSctqnufGey6/7M9kQ6AZ+bo0SJySBHBMgP+D1zZlrYQOOPq2ZD4j6k+K998iTMtcq3miyJ8wY8g20KtkpUkrjWP6zdWAdVOnoBN2xV6zznYlK1mnndHvRNm36CZO1uGrBJArVnHoig=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:87ed5c16-7460-4c02-99e7-fd7df7e7fd32,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:1abfc8c6-8a73-4871-aac2-7b886d064f36,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1f5ff790e08a11f0b33aeb1e7f16c2b6-20251224
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1871006641; Wed, 24 Dec 2025 13:33:48 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 24 Dec 2025 13:33:46 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 24 Dec 2025 13:33:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FLWunnVY0L3/+Rn/U+qjrOoClJgvQLZUdHzsZ91VlrSLzmAKZuugX321TelQ0jqpRviAyzXUAWzVUyiG3E7q0tL9LLGAu6Ns3MbdgjerJZm4C1eZE9BEXVlCmfs7CmACKmTgwRXl69bv93Uv7p/5EeAzeU2viIuW4f3xb1BWkKPFzeNca3FbdUXav/b4fuIjNm6ZpLh2SfGuDC+mFSoet2jBDxeTPmSeVX9xbNRrEFkCd3BWqkfVFVHolR7S69hIlqYtDux+lBXkU6JRyeb3inms67XhU3jhg1rLFtKCB0uq3ccDIi3Xnmg3ko7SyOpN6dNxtlbYk0XNuPpT9+1l6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxhC54uPP+Mz++zYXhUXSwTNpOhC04ZMynwQpWTpjnU=;
 b=QXdj8/9elzvfCxbr97C6MM60zrsT33iG2TH/Pm2BVLGCbk88/JRhzsfqakeUX24kITM+XUD+6ClO0iF1Um20ZMsHqjO3v7BLlJp4MhUdDMA1GKNGX2B+s/1Yho6qrDEW7uYz0LGukCauJ8E+s9iyOju4ZX/mTX3QfSMQgAq+JKvqJdYeZX2PG+1KVcIFz9BhJa4sKCzVKXV4Ob6WJ6VUhHhsYiPcUBwUz0z4om72xPj7tT69CtSdBxErWrGjbBue6f3iJaHi3tqpYDlTgxqVN8SzhV1y+LEZUvX4uWxajke11/PDgOe+7b1Y6r06EZdJ/rGROCdQhtsYz8EAyzkzgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxhC54uPP+Mz++zYXhUXSwTNpOhC04ZMynwQpWTpjnU=;
 b=IxL5nGbiwMQSfMwNAGhhrEMuFLYwignVt7Jq4lXIf5mzBJkQoI2ERHxNr64Dyd2BGAwWVyrkuS82s6Yvp/TnK98QM33zIi1VPHt+wYuQAyjPuNBQvMqu6rf0VW8DTXJnWOSFgF7WwsmD+6J0NkDE2HKKlGZUiFuCKVrIX/OO1ac=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by TYSPR03MB8111.apcprd03.prod.outlook.com (2603:1096:400:476::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Wed, 24 Dec
 2025 05:33:43 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7%7]) with mapi id 15.20.9456.008; Wed, 24 Dec 2025
 05:33:42 +0000
From: =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	=?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"kishon@kernel.org" <kishon@kernel.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "robh@kernel.org" <robh@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"kernel@collabora.com" <kernel@collabora.com>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>
Subject: Re: [PATCH v4 02/25] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Thread-Topic: [PATCH v4 02/25] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Thread-Index: AQHccB3tisyFm9OwYUi0TWobI+UHmbUwTX2A
Date: Wed, 24 Dec 2025 05:33:42 +0000
Message-ID: <e30abc4cbda3d655d9e0ef2beeac1456b93febb5.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-2-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-2-ddec7a369dd2@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|TYSPR03MB8111:EE_
x-ms-office365-filtering-correlation-id: 6d05b199-0820-4507-655f-08de42ae002e
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Q202R1RtUnVUTndEdW9XZURHVmRGdkw1MWM1N2RKaFRwWE4zMGJiazdoS0Vt?=
 =?utf-8?B?SVhrZzl0ZjQwYjRLRmJtT2RETmRVaVVmTE5mdzVRSXRuMDMyR0gzTUxCVktz?=
 =?utf-8?B?U3lWcUNQVFZnRWI0dmUzWmJFNXcweU1IbmRuNk9ZNFcwVjZDeHc0TThZNEc5?=
 =?utf-8?B?cVBEUEUrMC94b24yNEdOMVIzaGJyTUtyaU1QeEZpL0Nac0FpckJFQVF5ZmRV?=
 =?utf-8?B?azNpVTJMN28rWlZDbkcxaWtaUUltTnE3NnhRY3FLeWlTdTdobENPOVZ1SFNT?=
 =?utf-8?B?ZUMyVDZRbzJHenpRTlZlY0tpdFdTcVJNUDdxRHp5VDRJQUNGbXNZOFRxUXY2?=
 =?utf-8?B?QW5CcHlNTVFwTXl2elV2Tm1CRG16djVoZURoTjhPVDRxeVJibXZxbDVLdUtE?=
 =?utf-8?B?T0ZNdVZqRzBHUTJXNU5jRWJJSDNwQTE3OGxJOWJBT0pSb0VxNUIvN25BRDNp?=
 =?utf-8?B?emVTcnVHRUJFdDFTK2ppenVoWVZVcS92TXRHbC9iaWx2LzRQTHFUU20yNXcr?=
 =?utf-8?B?WW1mdVBuWjJKTnVzNzBObFBJR09uaEJMUzd2YVJmRjRlcS9wam9kUFYxTzN1?=
 =?utf-8?B?Z1FwQmVwUngvL291Zk1GaVhKYUphbUhSbXQ4aERQWEI1S0JMVTZXaHFiUFBv?=
 =?utf-8?B?YmtkcDFzU0tSN1RVTDEyWCtEYUdyUmhCTm56b1c1bnkzWnU4VTY0akplbW0z?=
 =?utf-8?B?ODQ5eHhYTEFBSXVGUUlWeW42bWl6Qytac0Joc3pKTjJMVGlxM2ZNQ252UDhD?=
 =?utf-8?B?L3BNemNmRzkxUnFQTlMxL0ExRkhWMkhENC9wYTBOV0VRdXpGcTdkVnVYdzZC?=
 =?utf-8?B?ZDlLSmNvMisvbzJCVEI2Mlo4U0ZnS09UL09ZS2Q2UE9waFo1cCtKalFzSzhN?=
 =?utf-8?B?dHdnUThZNFl5S2ZLd1hJMU1LOS8wZ2JoTmxGUlBzdFRhVk40MTd6Mi9nRFlT?=
 =?utf-8?B?NWVEeVFXbE9YSVBya1RoZ2pyVVBVZ1VPQkxOWGdaL3JKN1QzcS8zYU50d043?=
 =?utf-8?B?ak11N1kraE8xaFk5VWdMQ29xUmJBV25yTThQSWllTWV6eTZWRk1CRm1GS1Er?=
 =?utf-8?B?Um9uVEpGeDlxYzVHZ3ptaGRTdFdJQWllWDBjbXBpTUc1UVJPZ0xJT3c4V043?=
 =?utf-8?B?RGZmS2d3dEgxVU9hQnN0Z3BJd2ljQlE0emxOS0FlVXdLUkpLTktPVFNyNG1s?=
 =?utf-8?B?czVMcWZmb1cxTXYvcFFxMGxoUDNyTFNKb2VhNWRvYktTdEwzYVFqaEo0SGxT?=
 =?utf-8?B?d2lqZFp4Vk5wbFRjR1VtMW40aVgrS1liVWg3NnNGd1E4REZVakRtc2hUajA5?=
 =?utf-8?B?OVpvdjdXaVJsVEtPNUpvTnFCU2ZZbzhEVXFYc2hzMGZEc3pOTWo4NEZUcFpz?=
 =?utf-8?B?V1NJSHQ4UUZ0cDFXRndWL0F0S2VVQmFsc0JBM2lPVGE3M3Brc0lSZ2Jvc25L?=
 =?utf-8?B?VGFVSTlXOHBmb2V6OWRzK09HMm15cWJmb3NQTUc1UTZXRlA2MkVrYWtQTUxH?=
 =?utf-8?B?UzNlaUdrNDllTG1JcVRtYnU1T0hSY1ZZaXZtTWd4Wkx2WWM4OUZqakRDL0dy?=
 =?utf-8?B?a1RubFFrbmhETzNXcFJIWGd3d1Awa09uZUNwdnFsMlRCREl6Sy85aFVhNW53?=
 =?utf-8?B?R3RzaTJJLzNVekpSaW1ISlJyMWpnZkM3VFE1alU1T1ZnajhpMUFISG5FYWtI?=
 =?utf-8?B?dzhmZm43SUJ1WHE0SnhqQkw3OS95clFJS3E1dDRpc1JvKzFJWExjSW5qMkpY?=
 =?utf-8?B?RUY1bjdvZy85Vk9iYmZEVlhqS1B6djZjbmZ6cmVZbHVrRG1zemJPT1BZeUxy?=
 =?utf-8?B?OW1TODlLMzRzNkttdkFXbjhvT2hNeGtLdUpmM1pGMm8xS2JjMUQraWhybDVh?=
 =?utf-8?B?cHhCN1J6MS9YOW81cFo0Sks4aEl4M0NlTmlpUFJSZWp2ZUd4RmtRRXFURE9I?=
 =?utf-8?B?QjRuc3JvY1BPTHhOWnh4anh0RmpjaEFpQ2JpOWhnVHR4NkJvVkNKTTNmd2Vm?=
 =?utf-8?B?QXc3NGh6UFRaRFUvNUhXN09UaGFIenFKRXNXZkIwZVQ4bkV0TDVmWThkN1pa?=
 =?utf-8?B?MXpvbE1VeDBFSzdrbHR0YW9FYjQ0dGxSaTNpdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFZnMUlwV3hYRnBNS1F3bVNmeEN6MWdrTVlkeVZEM0F6UFcvdXVpZXpkci9Y?=
 =?utf-8?B?Z3IxblpZcjh6TWlzTUNpWlJuL1hyY2crbDZOWjRTWkVoVzNKY3p0MTMxSGVK?=
 =?utf-8?B?Snh5NW8zVHU2T0dLazR2S3ZFVFM3MWVBTFFqbmZZR0IxMkFENzdYdHNDNnZ5?=
 =?utf-8?B?bUE2TTVzNWFQMXF5eXlhdndqNFNMVC9wS1FsU2IzMzRDcEJyVWtIcE1VaWRN?=
 =?utf-8?B?Q05qUkZCaCtXb3VsU21xZS9TdDkydTlycW53bU1CZVFMcFZBTHcybnVoL25n?=
 =?utf-8?B?bG5MSFJWTlhIUHhaUkRmZjZGMVhLRVBQekFWeDJvVmNjT2oxc1lONldTMElE?=
 =?utf-8?B?eHZXb0IzazlpeWVCd0t5bVFWbE1zTC9aN1RWNUtmRFNkMWJ6NHphY1ViTHd3?=
 =?utf-8?B?OFdHY1JJSURGOHRQR0tQOVorazdvdFFWZmJmUUY1ejYyQWlkYmNiaFB1d2cr?=
 =?utf-8?B?cTlZaWQ1MEgxUzBSdnNqSU1JWlNlMUs4QjMrZGdZcURjNmtGSFJ6Tm51WTNJ?=
 =?utf-8?B?SGZTa2trR3JxUUkwMTB4c3VSbDEzeGpzUkVESnRCb2lqaFU2RnhGYmFNa2Jh?=
 =?utf-8?B?bnQzWGh1UmRMc3FvL0FCTlNSY2FoYkd0MWxzMElaSXRnVUJib3IxeFhuZHBo?=
 =?utf-8?B?Qkh6Y205ZHNOQzRMLy9hQXdYTDJORDFZQzNaZzZ2ekhpMG10cnluSkkxMzJs?=
 =?utf-8?B?QzkyU3ZmbDNITlMrK3lTdkExUGY2WGNQRUVXNmVLMVRGV3BVaTJJdEx4VS8z?=
 =?utf-8?B?Ym96dGFadkY4UHBjb2d1bEtpVjlLUHZLaHVXUC9OeWdUUWRkaWRLMTlvRFA4?=
 =?utf-8?B?ajZEdGNzNExoeDlPZVRqUHdZNHlrY29XUUtXVHM3TWkxdzJWdDhhS3pIK2lX?=
 =?utf-8?B?Q3dLZ202alBGRmxZOEtuU0NKLzF4WnZFa2h0S2J6Y2pJaGwyN1RNUjJsZUlI?=
 =?utf-8?B?bVlSR3ViS2JJMnBrbVRGcGVLbGlUZm44eC9mcDV2RDF0cjEwd0dDR2NBMVRT?=
 =?utf-8?B?YU95WUdmUVFxcE04cE4rdDhPcUNQZTNPTjZtbFhXUndTVkdEWmlWcFEvSGt2?=
 =?utf-8?B?ZmtuWlRaYjJSMFFHb3MySUVEL3M5OGlVYUhoeE5NZC9vQ3ZUSEVBeXJYdTlO?=
 =?utf-8?B?c0pZTVVGS0thK1RZendHTTF5SWtBOE5lRTFVUG16N1lHUEFmb2tKVW5RNnU3?=
 =?utf-8?B?cFlrOC91YVhqZ1BQQW42OTVpOWpCY29oTW9WTXhCcmV1ZXpaUGZFcmtoMmhF?=
 =?utf-8?B?VEphRStjNkJoQUtOdks0eG0yek1YMGZDNVQ2Q09NR3FkL1BoWEtmd1Y3cU1z?=
 =?utf-8?B?d3JRVTBYRTQ0QXROVkdUTG1CcmlpWVU2bi9oV1dhS2g2MVMzZFBySWVWME5a?=
 =?utf-8?B?Q3FCcDhnODhKQnJQOGNJQ1U0T2xZVmlLdmRveHdkN3JaOUVia3ZQZWhhYzJv?=
 =?utf-8?B?OE16bVVheDh3ZVFvdnV4MVFIWHBCWjRmeC9nc0FOUU5mdXFIZFRQYlpDc1dN?=
 =?utf-8?B?UWEvaTk2bjFDQXNMT2dlRVFIanFFMWxIR1Flald1VVBwOGxhUUMvd2ZUdnFZ?=
 =?utf-8?B?ajZwNzM3WHV5aDBUSWd2dG1hSjdEOVZVS3BqWjdncW4vR2s1eTZTQi8rZWsz?=
 =?utf-8?B?NElVU29WUzIzbW1NMHBPOU1yaWVHTW43VzkxQlhtZ3ZqUnF0OW1hZGV6Nlc1?=
 =?utf-8?B?bmlESVB2NUpkc3M3YU93T05TcDNDaXB3c3dtd0VDU3hoVFFXY3JsTmFQamJK?=
 =?utf-8?B?YXgrSkZtTzlnMFltb3dPM2w1YjUxS0w4L2ExdGFRV0ZNUGM1eXlXdUlMV3FP?=
 =?utf-8?B?MTA3U0w2VllzTGdUNWt1WHFnU0xjZG42bDZCeXUrZWVqK09tcmd6aEx5MDBI?=
 =?utf-8?B?Zm5laUtmSWZYejNiZGNZTW52ZDM0UmlnVXh0UzlqVVZjWFJ6cmt4QTFXQXFx?=
 =?utf-8?B?RkxIZXpveExMRnFvNG9NYXMrTTBNWWFqS0FxTkF3bGZSUXd5cnhrM3JUTUFV?=
 =?utf-8?B?YU5pZjNoSnhIa2p3eTQ1N0VYYVpueXZ5UkhYRitXM2xZNzg2OG9ZYlB4TUxs?=
 =?utf-8?B?MzFvM0JLOXVkVThFRlFOK1BSTDVjWWhKUWYwODQzTXZTbWtXNUxWb1d1T0ll?=
 =?utf-8?B?azhHT09lSzB0U3FSTG1oQVlSMDVzYzFHY29Gc1RXcFA2NVBsR3QxTnVOWWdW?=
 =?utf-8?B?UUZkYWJzalJFQWN5bk5IUEMrNlY3SndHS09oekV4WS9qOVN4L3MzZFdZODFh?=
 =?utf-8?B?VjRzVjdIVkVFRW5hMzl0eCtpMkZHT0psQnBCZjNrd2Rtc1orWHBONFRkOTk5?=
 =?utf-8?B?ZEljZzlRZGV3TWRGekxIY1ErUzMxZkNVN0VlNkRUVFg0bXJydkJLckdCdWMx?=
 =?utf-8?Q?DnbASxjkr0+/ck+8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B5FB3068B070B4A884EFAFD37604A9D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d05b199-0820-4507-655f-08de42ae002e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2025 05:33:42.7438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AWnrffguq/AjVOO2PBwweKo8z7321Zsi7yyGh/3nlnLV6GFg0/+8C9Lzqj6mTLg3IFN1Hy3qFYSwZvgfMyQ/iNBsSvdy/GS18Wjzk8/YX4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8111

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDEzOjU0ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhl
IGNvbnRlbnQuDQo+IA0KPiANCj4gQXMgaXQgc3RhbmRzLCB0aGUgbWVkaWF0ZWssdWZzLnlhbWwg
YmluZGluZyBpcyBzdGFydGxpbmdseQ0KPiBpbmNvbXBsZXRlLg0KPiBJdHMgb25lIGV4YW1wbGUs
IHdoaWNoIGlzIHRoZSBvbmx5IHJlYWwgInVzZXIiIG9mIHRoaXMgYmluZGluZyBpbg0KPiBtYWlu
bGluZSwgdXNlcyB0aGUgZGVwcmVjYXRlZCBmcmVxLXRhYmxlLWh6IHByb3BlcnR5Lg0KPiANCj4g
VGhlIHJlc2V0cywgb2Ygd2hpY2ggdGhlcmUgYXJlIHRocmVlIG9wdGlvbmFsIG9uZXMsIGFyZSBj
b21wbGV0ZWx5DQo+IGFic2VudC4NCj4gDQo+IFRoZSBjbG9jayBkZXNjcmlwdGlvbiBmb3IgTVQ4
MTk1IGlzIGluY29tcGxldGUsIGFzIGlzIHRoZSBvbmUgZm9yDQo+IE1UODE5Mi4gSXQncyBub3Qg
a25vd24gaWYgdGhlIG9uZSBjbG9jayBiaW5kaW5nIGZvciBNVDgxODMgaXMgZXZlbg0KPiBjb3Jy
ZWN0LCBidXQgSSBkbyBub3QgaGF2ZSBhY2Nlc3MgdG8gdGhlIG5lY2Vzc2FyeSBjb2RlIGFuZA0K
PiBkb2N1bWVudGF0aW9uIHRvIGZpbmQgdGhpcyBvdXQgbXlzZWxmLg0KPiANCj4gVGhlIHBvd2Vy
IHN1cHBseSBzaXR1YXRpb24gaXMgbm90IG11Y2ggYmV0dGVyOyB0aGUgYmluZGluZyBkZXNjcmli
ZXMNCj4gb25lDQo+IHJlcXVpcmVkIHBvd2VyIHN1cHBseSwgYnV0IGl0J3MgdGhlIFVGUyBjYXJk
IHN1cHBseSwgbm90IGFueSBvZiB0aGUNCj4gc3VwcGxpZXMgZmVlZGluZyB0aGUgY29udHJvbGxl
ciBzaWxpY29uLg0KPiANCj4gTm8gc2Vjb25kIGV4YW1wbGUgaXMgcHJlc2VudCBpbiB0aGUgYmlu
ZGluZywgbWFraW5nIHZlcmlmaWNhdGlvbg0KPiBkaWZmaWN1bHQuDQo+IA0KPiBEaXNhbGxvdyBm
cmVxLXRhYmxlLWh6IGFuZCBtb3ZlIHRvIG9wZXJhdGluZy1wb2ludHMtdjIuIEl0J3MgZmluZSB0
bw0KPiBicmVhayBjb21wYXRpYmlsaXR5IGhlcmUsIGFzIHRoZSBiaW5kaW5nIGlzIGN1cnJlbnRs
eSB1bnVzZWQgYW5kDQo+IHdvdWxkDQo+IGJlIGltcG9zc2libGUgdG8gY29ycmVjdGx5IHVzZSBp
biBpdHMgY3VycmVudCBzdGF0ZS4NCj4gDQo+IEFkZCB0aGUgdGhyZWUgcmVzZXRzIGFuZCB0aGUg
Y29ycmVzcG9uZGluZyByZXNldC1uYW1lcyBwcm9wZXJ0eS4NCj4gVGhlc2UNCj4gcmVzZXRzIGFw
cGVhciB0byBiZSBvcHRpb25hbCwgaS5lLiBub3QgcmVxdWlyZWQgZm9yIHRoZSBmdW5jdGlvbmlu
Zw0KPiBvZg0KPiB0aGUgZGV2aWNlLg0KPiANCj4gTW92ZSB0aGUgbGlzdCBvZiBjbG9jayBuYW1l
cyBvdXQgb2YgdGhlIGlmIGNvbmRpdGlvbiwgYW5kIGV4cGFuZCBpdA0KPiBmb3INCj4gdGhlIGNv
bmZpcm1lZCBjbG9ja3MgSSBjb3VsZCBmaW5kIGJ5IGNyb3NzLXJlZmVyZW5jaW5nIHNldmVyYWwg
Y2xvY2sNCj4gZHJpdmVycy4gRm9yIE1UODE5NSwgaW5jcmVhc2UgdGhlIG1pbmltdW0gbnVtYmVy
IG9mIGNsb2NrcyB0byBpbmNsdWRlDQo+IHRoZSBjcnlwdCBhbmQgcnhfc3ltYm9sIG9uZXMsIGFz
IHRoZXkncmUgaW50ZXJuYWwgdG8gdGhlIFNvQyBhbmQNCj4gc2hvdWxkDQo+IGFsd2F5cyBiZSBw
cmVzZW50LCBhbmQgc2hvdWxkIHRoZXJlZm9yZSBub3QgYmUgb21pdHRlZC4NCj4gDQo+IE1UODE5
MiBnZXRzIHRvIGhhdmUgYXQgbGVhc3QgMyBjbG9ja3MsIGFzIHRoZXNlIHdlcmUgdGhlIG9uZXMg
SSBjb3VsZA0KPiBxdWlja2x5IGNvbmZpcm0gZnJvbSBhIGdsYW5jZSBhdCB2YXJpb3VzIHRyZWVz
LiBJIGNhbid0IHNheSB0aGlzIHdhcw0KPiBhbg0KPiBleGhhdXN0aXZlIHNlYXJjaCB0aG91Z2gs
IGJ1dCBpdCdzIGJldHRlciB0aGFuIHRoZSBjdXJyZW50IHNpdHVhdGlvbi4NCj4gDQo+IFByb3Bl
cmx5IGRvY3VtZW50IGFsbCBzdXBwbGllcywgd2l0aCB3aGljaCBwaW4gbmFtZSBvbiB0aGUgU29D
cyB0aGV5DQo+IHN1cHBseS4gQ29tcGxldGUgdGhlIGV4YW1wbGUgd2l0aCB0aGVtLg0KPiANCj4g
QWxzbyBhZGQgYSBNVDgxOTUgZXhhbXBsZSB0byB0aGUgYmluZGluZywgdXNpbmcgc3VwcGx5IGxh
YmVscyB0aGF0IEkNCj4gYW0NCj4gcHJldHR5IHN1cmUgd291bGQgYmUgdGhlIHJpZ2h0IG9uZXMg
Zm9yIGUuZy4gdGhlIFJhZHhhIE5JTyAxMkwuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFz
IEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPg0KPiAtLS0NCj4g
IC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMueWFtbCAgICAgIHwgMTE3
DQo+ICsrKysrKysrKysrKysrKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEwMCBpbnNlcnRp
b25zKCspLCAxNyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvdWZzL21lZGlhdGVrLHVmcy55YW1sDQo+IGIvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMueWFtbA0KPiBpbmRleCAx
NWMzNDdmNWU2NjAuLmUwYWVmM2U1ZjU2YiAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMueWFtbA0KPiArKysgYi9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL21lZGlhdGVrLHVmcy55YW1sDQo+IEBAIC0x
OSwxMSArMTksMjggQEAgcHJvcGVydGllczoNCj4gDQo+ICAgIGNsb2NrczoNCj4gICAgICBtaW5J
dGVtczogMQ0KPiAtICAgIG1heEl0ZW1zOiA4DQo+ICsgICAgbWF4SXRlbXM6IDEzDQo+IA0KPiAg
ICBjbG9jay1uYW1lczoNCj4gICAgICBtaW5JdGVtczogMQ0KPiAtICAgIG1heEl0ZW1zOiA4DQo+
ICsgICAgaXRlbXM6DQo+ICsgICAgICAtIGNvbnN0OiB1ZnMNCj4gKyAgICAgIC0gY29uc3Q6IHVm
c19hZXMNCj4gKyAgICAgIC0gY29uc3Q6IHVmc190aWNrDQo+ICsgICAgICAtIGNvbnN0OiB1bmlw
cm9fc3lzY2xrDQo+ICsgICAgICAtIGNvbnN0OiB1bmlwcm9fdGljaw0KPiArICAgICAgLSBjb25z
dDogdW5pcHJvX21wX2JjbGsNCj4gKyAgICAgIC0gY29uc3Q6IHVmc190eF9zeW1ib2wNCj4gKyAg
ICAgIC0gY29uc3Q6IHVmc19tZW1fc3ViDQo+ICsgICAgICAtIGNvbnN0OiBjcnlwdF9tdXgNCj4g
KyAgICAgIC0gY29uc3Q6IGNyeXB0X2xwDQo+ICsgICAgICAtIGNvbnN0OiBjcnlwdF9wZXJmDQo+
ICsgICAgICAtIGNvbnN0OiB1ZnNfcnhfc3ltYm9sMA0KPiArICAgICAgLSBjb25zdDogdWZzX3J4
X3N5bWJvbDENCj4gKw0KPiArICBvcGVyYXRpbmctcG9pbnRzLXYyOiB0cnVlDQo+ICsNCj4gKyAg
ZnJlcS10YWJsZS1oejogZmFsc2UNCj4gDQo+ICAgIHBoeXM6DQo+ICAgICAgbWF4SXRlbXM6IDEN
Cj4gQEAgLTMxLDggKzQ4LDM2IEBAIHByb3BlcnRpZXM6DQo+ICAgIHJlZzoNCj4gICAgICBtYXhJ
dGVtczogMQ0KPiANCj4gKyAgcmVzZXRzOg0KPiArICAgIGl0ZW1zOg0KPiArICAgICAgLSBkZXNj
cmlwdGlvbjogcmVzZXQgZm9yIHRoZSBVbmlQcm8gbGF5ZXINCj4gKyAgICAgIC0gZGVzY3JpcHRp
b246IHJlc2V0IGZvciB0aGUgY3J5cHRvZ3JhcGh5IGVuZ2luZQ0KPiArICAgICAgLSBkZXNjcmlw
dGlvbjogcmVzZXQgZm9yIHRoZSBob3N0IGNvbnRyb2xsZXINCj4gKw0KPiArICByZXNldC1uYW1l
czoNCj4gKyAgICBpdGVtczoNCj4gKyAgICAgIC0gY29uc3Q6IHVuaXBybw0KPiArICAgICAgLSBj
b25zdDogY3J5cHRvDQo+ICsgICAgICAtIGNvbnN0OiBoY2kNCj4gKw0KPiArICBhdmRkMDktc3Vw
cGx5Og0KPiArICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAwLjlWIHN1cHBseSBwb3dl
cmluZyB0aGUgQVZERDA5X1VGUw0KPiBwaW4NCj4gKw0KPiArICBhdmRkMTItc3VwcGx5Og0KPiAr
ICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAxLjJWIHN1cHBseSBwb3dlcmluZyB0aGUg
QVZERDEyX1VGUw0KPiBwaW4NCj4gKw0KPiArICBhdmRkMTItY2tidWYtc3VwcGx5Og0KPiArICAg
IGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAxLjJWIHN1cHBseSBwb3dlcmluZyB0aGUNCj4g
QVZERDEyX0NLQlVGX1VGUyBwaW4NCj4gKw0KPiArICBhdmRkMTgtc3VwcGx5Og0KPiArICAgIGRl
c2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAxLjhWIHN1cHBseSBwb3dlcmluZyB0aGUgQVZERDE4
X1VGUw0KPiBwaW4NCj4gKw0KPiAgICB2Y2Mtc3VwcGx5OiB0cnVlDQo+IA0KPiArICB2Y2NxLXN1
cHBseTogdHJ1ZQ0KPiArDQo+ICsgIHZjY3EyLXN1cHBseTogdHJ1ZQ0KPiArDQo+ICAgIG1lZGlh
dGVrLHVmcy1kaXNhYmxlLW1jcToNCj4gICAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9k
ZWZpbml0aW9ucy9mbGFnDQo+ICAgICAgZGVzY3JpcHRpb246IFRoZSBtYXNrIHRvIGRpc2FibGUg
TUNRIChNdWx0aS1DaXJjdWxhciBRdWV1ZSkgZm9yDQo+IFVGUyBob3N0Lg0KPiBAQCAtNTQsMjkg
Kzk5LDQxIEBAIGFsbE9mOg0KPiAgICAgICAgcHJvcGVydGllczoNCj4gICAgICAgICAgY29tcGF0
aWJsZToNCj4gICAgICAgICAgICBjb250YWluczoNCj4gLSAgICAgICAgICAgIGVudW06DQo+IC0g
ICAgICAgICAgICAgIC0gbWVkaWF0ZWssbXQ4MTk1LXVmc2hjaQ0KPiArICAgICAgICAgICAgY29u
c3Q6IG1lZGlhdGVrLG10ODE4My11ZnNoY2kNCj4gICAgICB0aGVuOg0KPiAgICAgICAgcHJvcGVy
dGllczoNCj4gICAgICAgICAgY2xvY2tzOg0KPiAtICAgICAgICAgIG1pbkl0ZW1zOiA4DQo+ICsg
ICAgICAgICAgbWF4SXRlbXM6IDENCj4gICAgICAgICAgY2xvY2stbmFtZXM6DQo+ICAgICAgICAg
ICAgaXRlbXM6DQo+ICAgICAgICAgICAgICAtIGNvbnN0OiB1ZnMNCj4gLSAgICAgICAgICAgIC0g
Y29uc3Q6IHVmc19hZXMNCj4gLSAgICAgICAgICAgIC0gY29uc3Q6IHVmc190aWNrDQo+IC0gICAg
ICAgICAgICAtIGNvbnN0OiB1bmlwcm9fc3lzY2xrDQo+IC0gICAgICAgICAgICAtIGNvbnN0OiB1
bmlwcm9fdGljaw0KPiAtICAgICAgICAgICAgLSBjb25zdDogdW5pcHJvX21wX2JjbGsNCj4gLSAg
ICAgICAgICAgIC0gY29uc3Q6IHVmc190eF9zeW1ib2wNCj4gLSAgICAgICAgICAgIC0gY29uc3Q6
IHVmc19tZW1fc3ViDQo+IC0gICAgZWxzZToNCj4gKyAgICAgICAgYXZkZDEyLWNrYnVmLXN1cHBs
eTogZmFsc2UNCj4gKyAgLSBpZjoNCj4gKyAgICAgIHByb3BlcnRpZXM6DQo+ICsgICAgICAgIGNv
bXBhdGlibGU6DQo+ICsgICAgICAgICAgY29udGFpbnM6DQo+ICsgICAgICAgICAgICBjb25zdDog
bWVkaWF0ZWssbXQ4MTkyLXVmc2hjaQ0KPiArICAgIHRoZW46DQo+ICAgICAgICBwcm9wZXJ0aWVz
Og0KPiAgICAgICAgICBjbG9ja3M6DQo+IC0gICAgICAgICAgbWF4SXRlbXM6IDENCj4gKyAgICAg
ICAgICBtaW5JdGVtczogMw0KPiArICAgICAgICAgIG1heEl0ZW1zOiAzDQo+ICsgICAgICAgIGNs
b2Nrcy1uYW1lczoNCj4gKyAgICAgICAgICBtaW5JdGVtczogMw0KPiArICAgICAgICAgIG1heEl0
ZW1zOiAzDQo+ICsgICAgICAgIGF2ZGQwOS1zdXBwbHk6IGZhbHNlDQo+ICsgIC0gaWY6DQo+ICsg
ICAgICBwcm9wZXJ0aWVzOg0KPiArICAgICAgICBjb21wYXRpYmxlOg0KPiArICAgICAgICAgIGNv
bnRhaW5zOg0KPiArICAgICAgICAgICAgY29uc3Q6IG1lZGlhdGVrLG10ODE5NS11ZnNoY2kNCj4g
KyAgICB0aGVuOg0KPiArICAgICAgcHJvcGVydGllczoNCj4gKyAgICAgICAgY2xvY2tzOg0KPiAr
ICAgICAgICAgIG1pbkl0ZW1zOiAxMw0KPiAgICAgICAgICBjbG9jay1uYW1lczoNCj4gLSAgICAg
ICAgICBpdGVtczoNCj4gLSAgICAgICAgICAgIC0gY29uc3Q6IHVmcw0KPiArICAgICAgICAgIG1p
bkl0ZW1zOiAxMw0KPiArICAgICAgICBhdmRkMDktc3VwcGx5OiBmYWxzZQ0KPiANCj4gIGV4YW1w
bGVzOg0KPiAgICAtIHwNCj4gQEAgLTk1LDggKzE1MiwzNCBAQCBleGFtcGxlczoNCj4gDQo+ICAg
ICAgICAgICAgICBjbG9ja3MgPSA8JmluZnJhY2ZnX2FvIENMS19JTkZSQV9VRlM+Ow0KPiAgICAg
ICAgICAgICAgY2xvY2stbmFtZXMgPSAidWZzIjsNCj4gLSAgICAgICAgICAgIGZyZXEtdGFibGUt
aHogPSA8MCAwPjsNCj4gDQo+ICAgICAgICAgICAgICB2Y2Mtc3VwcGx5ID0gPCZtdF9wbWljX3Zl
bWNfbGRvX3JlZz47DQo+ICAgICAgICAgIH07DQo+ICAgICAgfTsNCj4gKyAgLSB8DQo+ICsgICAg
dWZzaGNpQDExMjcwMDAwIHsNCj4gKyAgICAgICAgY29tcGF0aWJsZSA9ICJtZWRpYXRlayxtdDgx
OTUtdWZzaGNpIjsNCj4gKyAgICAgICAgcmVnID0gPDB4MTEyNzAwMDAgMHgyMzAwPjsNCj4gKyAg
ICAgICAgaW50ZXJydXB0cyA9IDxHSUNfU1BJIDEzNyBJUlFfVFlQRV9MRVZFTF9ISUdIPjsNCj4g
KyAgICAgICAgcGh5cyA9IDwmdWZzcGh5PjsNCj4gKyAgICAgICAgY2xvY2tzID0gPCZpbmZyYWNm
Z19hbyA2Mz4sIDwmaW5mcmFjZmdfYW8gNjQ+LCA8JmluZnJhY2ZnX2FvDQo+IDY1PiwNCj4gKyAg
ICAgICAgICAgICAgICAgPCZpbmZyYWNmZ19hbyA1ND4sIDwmaW5mcmFjZmdfYW8gNTU+LA0KPiAr
ICAgICAgICAgICAgICAgICA8JmluZnJhY2ZnX2FvIDU2PiwgPCZpbmZyYWNmZ19hbyA5MD4sDQo+
ICsgICAgICAgICAgICAgICAgIDwmaW5mcmFjZmdfYW8gOTM+LCA8JnRvcGNrZ2VuIDYwPiwgPCZ0
b3Bja2dlbiAxNTI+LA0KPiArICAgICAgICAgICAgICAgICA8JnRvcGNrZ2VuIDEyNT4sIDwmdG9w
Y2tnZW4gMjEyPiwgPCZ0b3Bja2dlbiAyMTU+Ow0KPiArICAgICAgICBjbG9jay1uYW1lcyA9ICJ1
ZnMiLCAidWZzX2FlcyIsICJ1ZnNfdGljayIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgInVu
aXByb19zeXNjbGsiLCAidW5pcHJvX3RpY2siLA0KPiArICAgICAgICAgICAgICAgICAgICAgICJ1
bmlwcm9fbXBfYmNsayIsICJ1ZnNfdHhfc3ltYm9sIiwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAidWZzX21lbV9zdWIiLCAiY3J5cHRfbXV4IiwgImNyeXB0X2xwIiwNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAiY3J5cHRfcGVyZiIsICJ1ZnNfcnhfc3ltYm9sMCIsDQo+ICJ1ZnNfcnhfc3lt
Ym9sMSI7DQo+ICsNCj4gKyAgICAgICAgb3BlcmF0aW5nLXBvaW50cy12MiA9IDwmdWZzX29wcF90
YWJsZT47DQo+ICsNCj4gKyAgICAgICAgYXZkZDEyLXN1cHBseSA9IDwmbXQ2MzU5X3ZyZjEyX2xk
b19yZWc+Ow0KPiArICAgICAgICBhdmRkMTItY2tidWYtc3VwcGx5ID0gPCZtdDYzNTlfdmJiY2tf
bGRvX3JlZz47DQo+ICsgICAgICAgIGF2ZGQxOC1zdXBwbHkgPSA8Jm10NjM1OV92aW8xOF9sZG9f
cmVnPjsNCkRvIG5vdCBhZGQgdGhlIGF2ZGQxMi9hdmRkMTItY2xrYnVmL2F2ZGQxOCEgdGhlc2Ug
YW5hbG9nIHBvd2VyIGNhbm5vdA0KYmUgcG93ZXIgb2ZmLiBldmVuIHRoYXQgdGhlIHN5c3RlbSBp
cyBpbiBzdXNwZW5kIHN0YXRlIQ0KPiArICAgICAgICB2Y2Mtc3VwcGx5ID0gPCZtdDYzNTlfdmVt
Y18xX2xkb19yZWc+Ow0KPiArICAgICAgICB2Y2NxMi1zdXBwbHkgPSA8Jm10NjM1OV92dWZzX2xk
b19yZWc+Ow0KPiArDQo+ICsgICAgICAgIG1lZGlhdGVrLHVmcy1kaXNhYmxlLW1jcTsNCj4gKyAg
ICB9Ow0KPiANCj4gLS0NCj4gMi41Mi4wDQo+IA0K
