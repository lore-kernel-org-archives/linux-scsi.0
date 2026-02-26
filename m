Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F7F38BF94;
	Thu, 26 Feb 2026 06:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772089131; cv=fail; b=UY5CQeX56GT8mF6Kl2bHW/ieoY1aXGSHCpjXQGTH7a8BW1Ex5iJ0puW28OD6G5+pKoClPqEmFVMMQbwKm/XCexnxlfbICj7cphXBI5FXVBZsOvclNKLuDwRzYqSp4H2ZeXpXQaDZpv5vnq2sCEYeswsheu+xzg4x6xBXGBQGQp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772089131; c=relaxed/simple;
	bh=daaxhR6wYYzOJnoL+EY6LiY7BvueBPJH+jQhwXlGmQM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HnEXRWN+xW3cyrC/di59FVa5I01nRNbQbioLlonPEmbXOIpdroYqz09dwVwzazD5xC9+fV7jaPPzjzmnrYGV7I1gzATTS8E8qaJorc5GhEel+nZ4COgLGJhsr3umRofat7VJa/+9NHgZcT+9uzLODA9KJF3b/fDap9mqdo7uFBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=T6noB+we; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=UphSMhTk; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="T6noB+we";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="UphSMhTk"
X-UUID: 96e9934c12e011f1bcd7499a721e883d-20260226
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=daaxhR6wYYzOJnoL+EY6LiY7BvueBPJH+jQhwXlGmQM=;
	b=T6noB+weEtjSP+pNKvwh1CTLYFZK2BsjUjlmCtajXN8WW0q419dPIyz7aAh671Tq7FwjJWSrTsa5r0OQinDSgllCmlVK2P6a1T7Jo6Op4yLdgUUc+Mp/B8BZDU1MDdTU6nqZ0U62IINVCVQrlqqTQ5BV2hN6OgWJLbajZUUHCOI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:25bb0672-20c3-447a-bd62-6274490241db,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:aa7da15b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 96e9934c12e011f1bcd7499a721e883d-20260226
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 556750761; Thu, 26 Feb 2026 14:58:43 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 26 Feb 2026 14:58:42 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 26 Feb 2026 14:58:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DBJ+DFvw6YmQrSXpaR2G7j9bifP6pAP998mMrRIPT3vTcst8lasUq2KwkMoCkv4HK6jofLMEfzlOT4D3LHWQxVWS9uFzOCJHsfQDjBO1Wf6XBYNuh23oku7NJu5P/UEAoFsv5vWWuPKdcIX4BFh2g1Co6WIymr+sQwRhgKXcJwoXw2McgmqqzyKsgQesj4WbZcIqeRXusuvGPjPXFjSwtXfX+ruAA9VqrApvwRyj/EUjINWCvF8Qu0hZWTwGQEWgRcEx9rmdIqQ3WGh8IlOaIvMC/x+4XU/OVldBR6ceeI1UXpfHOKyyBjW2JCu3OH3D9OnhPOHtbSLH7kJFeqRLVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daaxhR6wYYzOJnoL+EY6LiY7BvueBPJH+jQhwXlGmQM=;
 b=VKfjgZOxw2yrLJmxljI62TBpZvcu4k/2e/kHUUNstEvylaWWYEghkG6qZ8B8aChu8H3DlBYpZmJ8QGvJm836oGPGPSMm6boMBBKvovS5DOckVApb3c1NYHwLlXgnQll5lFKJDNcZmInzXcDdNm1GKQBzI+0V0x7HOT6akfIjZAnzYxXCa9TircdYsGi5UFV3TMsenBJALFYpervSb8YjYr9UU5O+def3rfRBRrzho9I+hlDfPUEdHaxSDEJsBqyIMXn5sluHkpa5NiwqInGZrDYHxCje/BbSXfRtMjZKkddlkMH6fjnvsq+7xX+6NdP5L/ySLp0PZnOt/JNGDBd/sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daaxhR6wYYzOJnoL+EY6LiY7BvueBPJH+jQhwXlGmQM=;
 b=UphSMhTk54C63Hu8W4aQ95+04vIqL/+uWXV8HNubGbmqo96TD+mGgmNOoNuc7C3zX3j8quNDajti9iEY5zPShnwf8kPRBENT3nmryxnhpyQNWwxUPHAc9KeOdFDnh0GyQBkhBUK0Pkcu/FKAfAkPv5zsUo5uARqnytDZkEhQrmw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7983.apcprd03.prod.outlook.com (2603:1096:990:3d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 06:58:39 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 06:58:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "broonie@kernel.org" <broonie@kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 14/23] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
Thread-Topic: [PATCH v7 14/23] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
Thread-Index: AQHcn0nVM9FQAWzpsk6CIUfsBt/s8rWR166AgAGUv4CAAS+ogA==
Date: Thu, 26 Feb 2026 06:58:38 +0000
Message-ID: <bdd7fc6f0b84d9eedebaacf28f3d7a7dca683707.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-14-b5f2907c6da7@collabora.com>
	 <ee2e18e1a6177c40c5a4b3ed0ff228b9302429b7.camel@mediatek.com>
	 <3140774.mvXUDI8C0e@workhorse>
In-Reply-To: <3140774.mvXUDI8C0e@workhorse>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7983:EE_
x-ms-office365-filtering-correlation-id: c094c97e-4b65-42b0-d7ff-08de750477ef
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: H2EpFiarAXVOv5/p7pnbBhKB68BtKcU9iPUNLQjcz7klD/iRdGCZ4JXPS14zWz6UT6OoG3GhzZWsqiXqvqR5y4QDMOKbZ3zpJDEaCQztfYOpVVfj/7Q9xA43TUIk0QdaFRtTWgooGknyOIfW7tuk5oXQBNx9b56aMi1YmRE0DRrT1xTV4ndQBsDA/LySXwg57IxhCW9MsePni7Z3soufIee16d/7Q4zDWwovdtDJ7ngLCLeO6lbjtPqrE3GQKgPojpPDec3t5Su6ppXU3fVcCnO6DUJ9Ioko8z8iJEFzx7pW3Zt4azGBwW0/tLOGFKA9FN3K1byod2TINZs5JeNdCCauO2ms4y2/l0yNtpzPIHwBQBXpD9OLBChzGn1MwuJMYM2qdanyzBy1XaSRHgRSw9ij6LsYoAPyTuIpS4x+ydCb1LitIAnKNAxXKuOxDwhUBtd7kvJn860x4tSPaJW8OTPgrSVn4ibOuvyhAcU6Sb57ewtTFWOsxdW2SBzXD2Kcdn1j2Pd3bkHp8wptPwwsQQqj1tRMQsOuY36aYN2DlShtANltg+q/UyYDWjgucEkGVf2nI52bGqmUsj7j9+8MajGGfw4cAsDG8PrGEo/Gm1YxiT4fKfGqOPIi2gb/OdQf1pXVEe+VBZLathwpQ8Pa3XQkVw00j/UazUVJqj4JLdDhAF8s6dkA9nTMME2rBqNBiXB7HO9TIu9FLP8sEc7TNULPnH4iStNwEaB+FVwmxm12k9hfudcE0c1q3DQJdareA4+oDFqyipsWv4EqlDq/k89LI37uKx/0Hn5//5DR8sC9U/v3rYV8Dqkgjq6MlvgP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGlVN3F6dXZvNStZTnN5eVpLcXJYZ2pzSTFqcXJ1WGw3eUpBUGsrbFArT0hx?=
 =?utf-8?B?dlJrNmJFSEdReGJ3UHVLSkZrQld5Z2I4ZDY4RUhSK1BYQnFHUGJreElpMktS?=
 =?utf-8?B?UWFPenlmUEI4dzZIbWpZblBYYjFDbTlTeCs2eVpPVVdOTFNjNWpnZGppT0pH?=
 =?utf-8?B?SmVIMGpnTXJTNjErakhxVDlId2hkL050TDdUM1JJL20yMXhKcEJvTjA2ZjJk?=
 =?utf-8?B?QVFNcWl6OXBGaDBQbWJoczJoZkt5MkYrQ3h4a05CcHdyd211RmZpakJhN3Vv?=
 =?utf-8?B?UXBpTllFNTFublFReEZBUGoyVlBjdDNZQ2wrVy9KNGVLK0IyMldSdTUvR1NX?=
 =?utf-8?B?OS9lV3BHTHBZMGdCLzg4d0NjZklhdjFxb2xSWU1qRkZOK01YR2JZVzdnOHZK?=
 =?utf-8?B?UDBYMlo1RkVrRGREK3hOOFYrWXM0eVBCcEtrMmR4REViNFNjZHJPZkNkaCs1?=
 =?utf-8?B?dktQZnZ4N0Y5VWREcDM4Rk1KTXpRNkwwVzhVaURQaXhseW5OMmQ0V0tyWW0r?=
 =?utf-8?B?OVV0NWxZbFR1azhRY0R1QUtIRndrZDd1bHRCalI5ZytSMlpQc1ZXZ0x4ekhw?=
 =?utf-8?B?YkJXbkJCUTNEVFJ1L2RkamNKbUtuNi9hMzRDajZOa3Rnbk9vTFFuZEVadk42?=
 =?utf-8?B?Q3dDaXROZUxCbUtpaGxKYkw5dlNyTE9XMnpRYkRiQlljTDRGYjEzSXE0eU1i?=
 =?utf-8?B?NlU5djJtcEowUDBpSGFENWRmdTJDbzdwY21mUWQxdk9Mc3dzdkhoWnQyZmhZ?=
 =?utf-8?B?R0ZVVUt6WTZhbE5HUWQ2TkVwSUh1L2RlQmdjSnBzZjd4QmJHNmtFYVY0QThv?=
 =?utf-8?B?TkhaNjlZb3hORGVEZldMdkpxeHdGMWY0NEJJR2R2WGR3V1FyK2NCLzVKYzZK?=
 =?utf-8?B?ZWhobFp4UnAyZlFML1RIT2R2V205eXFBN01hUEhBTEF1dUh3ZzRoUEtxRE5H?=
 =?utf-8?B?czBQNE1hbWxTeVpJTEFYVEZudjNCbFptZHpHaTBuZDRqWEZ2bHRyblZQd3FI?=
 =?utf-8?B?c1djdlFMbWw5a1JZTyt1S0NpQlpIZllSVzJhYmpPV1NYTjRkZEhqUEhHRS9a?=
 =?utf-8?B?aVNRdmtUYkpnVGduNTV1dkJKOExzelhvSnNPc0M4a2R2WFVVa0p5VjNmL3Z3?=
 =?utf-8?B?bkhiS0dMWHB2WEQ3cC9UaGZZQ0tLTDR4Q1R4UXBvekZla3IwMGRpNDVXenhC?=
 =?utf-8?B?YWc3b21hbWlKcWtEM0Jab2JiMldLU24zczdBR2VZM1c1MDRzYzAxWDhQa0tM?=
 =?utf-8?B?R29LRVBQT2hoOGI1WW9IZWVUREJRQitPbnlmTXlPQWpURnN2dFRmV1pnNG9F?=
 =?utf-8?B?ZnZPak9QUmJJWEQvdzNYQlRMSlJDRU0wdmgxUEdkYmtZZG1FbUtXMVJQTUsx?=
 =?utf-8?B?cnNmcXVHdTAyeTRxTGVyQnNJd2NDQTNLRDlCVUZncjl2K0JLd1o3dUk2NVRu?=
 =?utf-8?B?MStWaXE1OXFDM0FCbXNRUjAxdmQ0YkZ5OUtzTm1ZckRoRGdKSkEwL2ZSYUds?=
 =?utf-8?B?aGVjNE9MbXdCTUpiWm5RYzBxSUpjZ3FwZ2s5WC93TmlBdWhrcXhHWFVjWWVB?=
 =?utf-8?B?cnNtUTZjNXZ6TUpYVVRMN0s5bVlOUXlGZENUVU1ncUE3L2x5dDZxQ1FFUmZY?=
 =?utf-8?B?SElzUjZWdVJhZ0hYNUsrSEsvL2p5bm1xaElKeDN1QzFkcmY2U1RLV2RPVHZB?=
 =?utf-8?B?SUVOaUgvazJvcnpxV3FXdnZMK0hJSUtoUGx5L002T01lWlp0ak4vNFE3Nis1?=
 =?utf-8?B?eExDUmVRVnRXcVp1cDVPbExwYzE2dWJHRjRreTJVZ2p2YVRtd2JjVlQ2OE96?=
 =?utf-8?B?NXdnMTFyK0NxUUJnNThpQVJJcUlKazV6TWw5aGdiUnc4SnAxTkplTEZ4OU8w?=
 =?utf-8?B?OGJYbHgwWUl6bm41WlkrZ0RRQkxVME5JMVBXcUh5d2daR09udW5SWUcvd3Ft?=
 =?utf-8?B?S3Jmc0lGZFNXQVVLbUliMWI2TzJDcUpWMzNsUVR2eHpyQXZhZVdKZkdheHlx?=
 =?utf-8?B?dFh2NWJXRVZYUUZZZEdML0RwRWpsSUYzWXVoOWJPaWNvU0ovWW1FVXZpK3RC?=
 =?utf-8?B?ZkExb05xblRPdmRZMFp6MUtRdkZnanhRTzJjcGFUSERsUmZ1RHBaZFprby95?=
 =?utf-8?B?YTRMMGlJYUdNanRZUzdXVXRiT2hTSTJTOEd4Q2FnMGtEamk0eXREZHlxRGhG?=
 =?utf-8?B?cEFrWUxDSWdRc0NaSGZ6Y0hPRDBKZnRpd3JNK2d6dzVlTkQ1SDh4QzZMNDBv?=
 =?utf-8?B?SVlPRE9kUlJsRy9VZkNPNjdBOWNFTFgrZ2xmR2REQ3hZeGtwZDBMa3VVNllO?=
 =?utf-8?B?TWlFZTJJQWlEN2k2V2cwQUVVemhxWS94ak9aWlp2WFVNcWZ5NWdmSjQzelNh?=
 =?utf-8?Q?E+57xvkVEEQV/9LM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B42C777A6427DA45893F3D72F3369F30@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ZyunQBrMl+6V3QBl7tw2MwFYs9KQVVakYTE2fLqHMQ8/3Gp2f6xZvaYUrWo3QLMf9gI7uVHlTSl2Hy36m/zNGbF3daH33pGVNJhNXmwyTe/HXer0QCLqOV7JNWTI7uBPQ2+57cLjiogHZzq6RVdR8CZuRgYyj6T5JXF0dAV+OOGFmoZ4dYPa4KaIAOgISKnpiE65pkKBd98HfeQM9lp+tnQQJ4LbpTQL50M9cep8ZLy30azQEOcaqzcYFcxXoJg4DIVNsG+a8bzxBKYWbh1DkNcUa8+a8/7TWskc1dgHaGsCDeN1l/ULX4gtU4r3B1y0MiMlgMPcrG1Wbtx2LYSxIg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c094c97e-4b65-42b0-d7ff-08de750477ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 06:58:38.5587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j1h/Jijxg2ArOoWnW3jHxUEiMLocjYnM4g82xIPFTQw9HcxUTfEGgIvbeCgV0ARsYnjVh663Dq/XR0pT4Xj1ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7983
X-MTK: N

T24gV2VkLCAyMDI2LTAyLTI1IGF0IDEzOjUxICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEkgZG8gbm90IGhhdmUgYWNjZXNzIHRvIGEgY29tcGxldGUgbGlzdCBvZiBoYXJkd2Fy
ZSBJUCB2ZXJzaW9ucw0KPiB0aGF0IG5lZWQgdGhpcyBxdWlyayBhcHBsaWVkLiBObyB1cHN0cmVh
bSBEVHMgc2VlbSB0byB1c2UgaXQuDQo+IA0KPiBJZiBNZWRpYVRlayB3YW50cyB0aGUgcXVpcmsg
YmFjaywgeW91IGNhbiBzdWJtaXQgYSBwYXRjaCB0byBhcHBseQ0KPiBpdCBiYXNlZCBvbiB0aGUg
aXBfdmVyIG9uY2UgdGhpcyBzZXJpZXMgaGFzIGxhbmRlZCwgYXMgeW91IGhhdmUgYWxsDQo+IHRo
ZSBuZWNlc3NhcnkgaW5mb3JtYXRpb24uDQoNClN1cmUsIGl0IGlzIGEgZmVhdHVyZSB3b3JrIHRv
IGFkZCB0aGlzIHF1aXJrIGJhc2VkIG9uIHRoZSBpcF92ZXIuDQoNClRoYW5rcw0KUGV0ZXINCg==
