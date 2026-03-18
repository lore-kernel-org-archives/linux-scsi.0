Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F363175A94;
	Wed, 18 Mar 2026 02:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773800614; cv=fail; b=J4PeGhryzVd4AxkU7msWMSFmFL6D0LsE5jBHg7sFoyvnlEq+mVGfYbLiNlU6bz6ln96SZYVEEqxJHAH8BqR8exdaB401ZfQstC8C8lVlkMSwBmMeOa90yz3MITWRpVkhqRl7N4i2ex/hgWowbX/4R/5vugKAxJAnjSXxyjmMfDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773800614; c=relaxed/simple;
	bh=l5w5tD9R1fR3C58lnDX3jKL/az8+YrGmML5jdXfDrOg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XaZciML6tVW6JoE43N7xYO09ST8Sufj7QYsudloOqrmKBuNa7I5d8cTqWW9SZdc4QoFXwv4g89Yndx8acDf6RxMd8JAtMSvH//tmsCgaIaSB8O69FQw2/arH2HUdiMD0ZWf+lfF2tfxo/UA/OTyly649thTPLdUGGcxkmeJVMeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=eETY6Dto; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=eFCoLFCb; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eETY6Dto";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="eFCoLFCb"
X-UUID: 73844794227111f1a02d4725871ece0b-20260318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=l5w5tD9R1fR3C58lnDX3jKL/az8+YrGmML5jdXfDrOg=;
	b=eETY6Dto8AtECE0t70BAqfrhoFdt4rvoqzZVej2RJ7KQuGhQP8ZJnIyZljb9k0yEDgfooThI2oBIWgxLMsXxf/0xCqQLinptZ82wSG7x4fcc0OMeOInpaJZgGdL3M+wijP+rySGoJ5vJf3bRtRehMiBPiqHllOnYiWppeMeQfaE=;
X-CID-CACHE: Type:Local,Time:202603181023+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c0fd07fd-5720-4b88-8482-77240f46ebdc,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:16fdd216-aa6b-4b2e-be76-373ef1a42b04,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 73844794227111f1a02d4725871ece0b-20260318
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 363301745; Wed, 18 Mar 2026 10:23:28 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 18 Mar 2026 10:23:27 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 18 Mar 2026 10:23:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDqQbCVs6hX/QT12wR8vbLJKYXKWeGk8Y4JbNB3czDnphW1EbYeg1GAIKoHZXsJfcWM3qmAlGgp0XqWacsEuP8keOS/MQb9Y5VPpECjn9Z1NIQYC5qN5fbPSKsq1nu0cujIDtYaffoTVUxVCThvnq6r+afw+uij4BwgIJxsm4mfjx658RQRGzlXJWyezR2vIsufI57YnLOCooXtTX3fOHhh0TOYYnK+QJnDL4ADDWcQGkjUjStoLdXx0aubu8Wg7eyHFlCt4a2W5E1Ov3hOI7STLapUQRJPsZxfdpYf3UAu8UwQ6VOmIxoWR2RjjepZEHw0zRwDUgit7vjAtOqS/ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5w5tD9R1fR3C58lnDX3jKL/az8+YrGmML5jdXfDrOg=;
 b=TfzKcPFFbLnGgztNhUplqjCwzepLEXhS8V5VZDf14PIUMqatgnDCrGAHp1i1sl81+qj5KiwttaA/Wvh0a/tATD9zseY8LP9rJNh6n6txsafeNgq+6NHcELZoy/eOaue7jrjHw0mkwAJwwncpJoFI/hAXw2Zkpv4GHNg37OU9TGw3WYTMLgkFf0ZEo4sKcEYnFGRsiGDZUButZorywiY0AUC7UNE90nOn7oDIQQKO340CPVN1byblf1tMgDzNtpVra85hNOAwvuDJE8Temf5sxmOznLP89m2deComz8s3NNp7gPGsfPHu5JFq17oyrIS4NtHY9F5+ejNdGUaO8jO2Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5w5tD9R1fR3C58lnDX3jKL/az8+YrGmML5jdXfDrOg=;
 b=eFCoLFCbcWroZLJhwket3qASSZlvwM9T1z5IkvN30T8M4IJrxx4g3ZsLbvfysIrwo4K/OQaitWzNlhPq/bSXcX0gNT4g7ys7NUu1+dB1SWl4UPA0HxBxUBxvJmL8KWLnxSEHCz5aklOSfGuWQC3XebTc7oXubeJt2HAGqjEmk/4=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by SEZPR03MB6890.apcprd03.prod.outlook.com (2603:1096:101:a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 02:23:18 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4%6]) with mapi id 15.20.9700.025; Wed, 18 Mar 2026
 02:23:17 +0000
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
Subject: Re: [PATCH v9 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Thread-Topic: [PATCH v9 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Thread-Index: AQHcrW0RFzLKSJTvVkuMqellkJOlUrWzoYAA
Date: Wed, 18 Mar 2026 02:23:17 +0000
Message-ID: <cf7a38984309cc80a9f9acc3bbc45a1989cfcaac.camel@mediatek.com>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
	 <20260306-mt8196-ufs-v9-22-55b073f7a830@collabora.com>
In-Reply-To: <20260306-mt8196-ufs-v9-22-55b073f7a830@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|SEZPR03MB6890:EE_
x-ms-office365-filtering-correlation-id: 049fcc0c-3a33-44ae-6c6a-08de84955112
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003|921020|38070700021;
x-microsoft-antispam-message-info: SFLxYVOcLlgGLx7LaNUubPBBspyGNY4gFpQTgmE7lPUGnF/h6Hg0NcXBydaUNzIAMb3eraVhJoLMG/zAxPs3VvOcs7vB3j6NtEl7Ydu/9BCESWT26IcBLZnRu4sF4JMYhYlCP/f5H+giec+vgXGxstC5NZfo8hhQTbCDDKYRljHuIdaMXKM+MDVCpbstr999VCDhqM6fERJBe5uefGgXhy9PXv1hlJv5DdhEnlvZigrmEj6ldQgVhKnNAZWe28FwzrbJSC/jG6rBftUykf1tn+x2U6e92yfW5C98aCgkSBRQqMEJRqFU1362MeXyeOt5jDEXmOchvXd7Xjum7PP9whEt7/NBVHTbXpny33VAMhrUs0naNwkKJrouzD3AkGYAIuGtluI3R6YqfWLJnma5JMX5xFT/llDz18oHVii2PYu57B3KHH39cls5Tux0blCiytcbmJLR5hsULnzK+qKX5d6v6HfhmBqKMOOS9boPCdw/rceSnTLC3VLZykH1qOX16cQ0DQGfGYhIGsiluS8n5R9dYzgZhNoMhJMSpOXvTrE6f+9aQZpBHOAyBF1z0LpVQbJnXa/ULy3/d+AdzTzJmrtcLTUeX7g+qgjVqKYvbPB9IRIQsyaImBU/sdLmcYptDlnlh48geuVH3ZqL1K1x0XOCAAoBJ4Woj4gkx8m8mXHkW9QkarjxGdeTEqMkDvUistfNsVB4y4yYDwvOeYQkuMPVgdw2vE9Gr6eu0wymlBvhVKEVsa4LPXrEApNAZ9rDj+GIr/ogFdNc99MXxAAyM24bunz9ZSa6Hb/dM/aMGMvXwBBbF/tBnYnZrt4DxBwL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGwyeW5mVDByK254aWlnZEVnYm13RmNpWWptQWJOYlI4bDVxaEVEK0ZkLzlT?=
 =?utf-8?B?OExiNk1ZV2pmK29MMFNkMlRpdVBQS3VPM1kzaTdSS3hBb2I3M1ZPaDlkSSsz?=
 =?utf-8?B?RmdPdGdWcHhPYXA0eDJTNis0SkxmdTlqYVNpSnZqLzVIcENtaTE2T29xYjhU?=
 =?utf-8?B?cFlpamFIc3JFYnNNV1RISmdMOGJIT2ZySllSc2ozby8xR1BWaUN4SmZJaFlQ?=
 =?utf-8?B?TVY5aXBSZEdXYmdFYTFyKzBvZU5VaEN3NTBrSUdFZEVRN042VkIxQ1UyTmh0?=
 =?utf-8?B?NFp3dGhQdnQ2K1pSQjRJVit0NWdIekdDNU9rMEpwVVBMQ0l5L0pwZ2RpclpT?=
 =?utf-8?B?akczbzdqVkpHNmYwV0dpcyt2L3lGci93SzIvMUZYNXlIK1Vra2JFTFg1M0l2?=
 =?utf-8?B?T0NYa2duSlMrV3g4eHlMUW9xVW42U01uRElvU0FpOHRURCtodGxMNll6U0Nj?=
 =?utf-8?B?bXpEUTdvcXkvcGZTc1hZNFI4QVhTQnhyRythNFFHSzR3bjNiakNFNG5pdHZF?=
 =?utf-8?B?WHNJazBRRE4rV3A4YUVVc3N1SWQ2NlFiNWJHWExuYnlSZkNGVHFDamhaTjBU?=
 =?utf-8?B?QlRGWmZLYXFUak9DRDNnZkR6ZHlxWUFhMlVqMEdqV1E5Tko2UTdpSFFyRGFW?=
 =?utf-8?B?SS80N05vTjdmcWJxUkdLZ1Y1MzU2WG5FMW1sUDZkckM4OFdpQ2luK3lMb2Vm?=
 =?utf-8?B?NjBZY0x4eWRkb2pUUXNtREZlbVB5dVBxZURFeTB6RE9tK2Y1S2pNQmpLRlR4?=
 =?utf-8?B?OVIwUEtsUWRpdjVPU3J4WFpMVDE1UFM4aDFtVkkzMXJkZjdMd1pNZzZ0eXFN?=
 =?utf-8?B?SXhvMW5UYkJpR0wvYTB5SmRhTW5LWmFWaHB6ZDVCbzRnYTFZSnh1SndIdG10?=
 =?utf-8?B?NHhqeURpZmVJQi96d2V1dUFGRGdRVUEwSVZnRnRpZUIveGRCYkFxaFdqZXB3?=
 =?utf-8?B?RiswRHpmVlVOaGpwRTQzdWxsMVM3OVptS3pNQ3drRWZtV1NWZi92dVp5eUlZ?=
 =?utf-8?B?US9mamZOUEhHN1RtZ3J2N1FHdWljVjd6MUhGOFM2K1JBQXNmelpXNlkxRmQ4?=
 =?utf-8?B?NllBYnBzWkprcEt3MmxDL0ExaVEvcEtIaGtOUzMyU3M5RmhYWXVYRndHY2tX?=
 =?utf-8?B?T3RXWEJqenl2RDJBNzhRSkk3M2Rid1lCZWZmNVdnUm4zZHBHRUtxQnVWbnNs?=
 =?utf-8?B?eGF5RDFRS0VIVHFOZlhML2lvOTUvN05ndlFZTndiUjRHUExtN0w1bEcwS3M2?=
 =?utf-8?B?QTNtOTMzMDMzZEwxK3MvYmVZaXRNWkxFeTdzdzBieDEzS25nYzlFelNJMWRS?=
 =?utf-8?B?dXU3TGI2Y3NzZTVOYXQ5Q0lZTjRNTU9VcDhNMHVpQlBEcHZ5R3pyemZVOXp5?=
 =?utf-8?B?ZXdvS2pCTWZLTWcvTW04eVoxRjM3K2loYTgzZXhjV0hkcThDeGRlWmgvekVM?=
 =?utf-8?B?WGNpU2hPZkk4bFQ5VVNyYzJnVFBVaVVPMFlYRDk3SEhEWXBDakltcHpSaTdp?=
 =?utf-8?B?TmN1L0laWUsxMDhGWi9JYjA4a1U2WXQveGxVeXBjVjlreW5KV0tUeUVCY2cy?=
 =?utf-8?B?QUdkZmJGZVdEUjVzdUdIVzBPc2dvWkRnb085K3RiK2ZGYzkwdjMrU0RtVXlz?=
 =?utf-8?B?dmJyYkRMNXFLcWIzR3laMkhzdTIweS9KMWdPTERzYWV4blo5VXlodEJleERs?=
 =?utf-8?B?ZkxUeGNrbEdLY0t6SXNLdmUwcVd2aEN2NGJEZVZTbENobHlicDZXUW9NL3VU?=
 =?utf-8?B?UnVVS25MWHdyY2IvSi8wbGFsM1dJUlNEcGtXNnpSdyt0UWhtc0Qwc1dHcmpE?=
 =?utf-8?B?czIwRlh6LytlMEswai96L0R1d0lMNGc4L1EwU2M1bWdGWERFU09vMkx2a2R3?=
 =?utf-8?B?bllJRTMwdTFhZzQ1WmhYOS9qRzdKc2ZtV3lUMDBKckhiUy9nNlhhOUFGRWRr?=
 =?utf-8?B?dTdETE9RNEdpMUlJVWc5blA1T1JONmFxQ0N0QnUybDBsKzY4dU1LKzlZM2Vi?=
 =?utf-8?B?T1ErQ2ZucXJRZERBRFBtd2VHbWUydENFQ28vSXg3S1d3WnoyMlhrUHE5bmJJ?=
 =?utf-8?B?d0FwdVFSWFhmU0YzZWxCVnpJZWt4a0FRMzdUWSsrd0dld3hMTVRIZG53VTU4?=
 =?utf-8?B?Y1hsK0xIZnFjd25tYWJadFJPZWYrdkt0VDBIUnJlRXR0SlZhVGNYVlV3aERS?=
 =?utf-8?B?ZWVWOWR5cUc1WjJXeTQwZ3VLVGxRcW5DUS9JTGc2dnYyQmhoaDV4RzFZYjJx?=
 =?utf-8?B?eVRvUEtpc3MzbXJsT2o0N2ZTOTdMd0ZSc1V4V095U21nL2E4OVAwNlMraHRE?=
 =?utf-8?B?U1pvUVU2UHJhMHE2U1hyd01wNkNYVU5sOENyNHlQSFNMbjBUVFhPMWRscG5R?=
 =?utf-8?Q?hK+Nt13l/ce0ZyhQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D2D2DAEBB609C42A0B2D9B5F9372E53@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PHHnHJfmhpBXSO+Kp2nasBSGnfXyao7QrijEsxINMNh3mFiR0pMnZ6TZxcX0FhXcghRugraY5nxqMYhM6JIqlYjwIWy+dKbUE8/yt66kouPS/aKWqoGPyzeqj59RKQtPAiVlwG48MvfJrV9lWper0dnuWaM71fq4vXl9yWQNnBz7CMLzM5HciB+1H2e+4cO51WMWq6/sLA5hpS52ULXx2osaA/uXtazRa9qxt4iO3IgOAC54qC1vkeiE/rTjAftPWwx9ReSIOj5tyATHVQBupza+AVs9bJD3hVZjre+Q5RM9SuzoXxPvgSPqwhzMwkYxZfsWkQRt0U6psa13u6R2KA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049fcc0c-3a33-44ae-6c6a-08de84955112
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2026 02:23:17.7747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uKrOd8o+lAD+Z1qhk4DdrBi/+lmA2Po1/DZhUsw/0ffhAkPSPlRXamiyKhh5kNP8kHY1mAZwKrQlF6q9VSUkpVcFv2BGckSFV3Mc/qIteNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6890
X-MTK: N

T24gRnJpLCAyMDI2LTAzLTA2IGF0IDE0OjI1ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoZSBNZWRpYVRlayBVRlMgZHJpdmVyIGNvbnRhaW5zIHN1cHBvcnQgZm9yIGFuIHVu
ZG9jdW1lbnRlZCwNCj4gbm9uLXZlbmRvci1wcmVmaXhlZCB1MzIgcHJvcGVydHkgbmFtZWQgImNs
ay1zY2FsZS11cC12Y29yZS1taW4iLg0KPiANCj4gU2luY2UgaXQgaXMgbm90IHBhcnQgb2YgYW55
IGJpbmRpbmcsIGFuZCB3b3VsZCBub3QgcGFzcyBhIGJpbmRpbmdzDQo+IHJldmlldyBpbiBpdHMg
Y3VycmVudCBmb3JtLCByZW1vdmUgaXQuDQo+IA0KPiBUbyByZXR1cm4gdGhpcyBmdW5jdGlvbmFs
aXR5LCBpdCBuZWVkcyB0byBiZSByZXN1Ym1pdHRlZCBpbiBhIHNlcmllcw0KPiB0aGF0IGFsc28g
aW50cm9kdWNlcyBpdCB0byB0aGUgYmluZGluZywgYW5kIGp1c3RpZmllcyB3aGF0IGl0IGlzIHVz
ZWQNCj4gZm9yLiBDb21wYXRpYmlsaXR5IHdpdGggZG93bnN0cmVhbSBkZXZpY2UgdHJlZXMgaXMg
bm90IGEgdmFsaWQNCj4ganVzdGlmaWNhdGlvbiBmb3IgaXRzIGV4aXN0ZW5jZS4NCj4gDQpJcyBp
dCBwb3NzaWJsZSB0byBhZGQgdGhlICJjbGstc2NhbGUtdXAtdmNvcmUtbWluIiB0byB0aGUgRFQg
YmluZGluZw0KZmlyc3RseSA/IHRoZSByZWFzb24gaXMgdGhhdCBNVDgxOTYgc3VwcG9ydHMgVUZT
NC4wLCBhbmQgbWFrZSB0aGUgVkNvcmUNCmF0IGxlYXN0IDAuNjVWIGlzIHRoZSBNVVNUIGNvbmRp
dGlvbiB0aGF0IHRvIHJ1biBIUy1HNSBtb2RlLg0KPiBSZXZpZXdlZC1ieTogQW5nZWxvR2lvYWNj
aGlubyBEZWwgUmVnbm8gPA0KPiBhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNvbGxhYm9yYS5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xhcy5mcmF0dGFy
b2xpQGNvbGxhYm9yYS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWsuYyB8IDE5IC0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxOSBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRl
ay5jIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmMNCj4gaW5kZXggYWU2NzM1
NjgzZjc2Li4xZGZjMjk5YjkzYjUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZz
LW1lZGlhdGVrLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiBA
QCAtODgwLDggKzg4MCw2IEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfaW5pdF9jbG9ja3Moc3RydWN0
IHVmc19oYmENCj4gKmhiYSkNCj4gIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNk
X2dldF92YXJpYW50KGhiYSk7DQo+ICAJc3RydWN0IGxpc3RfaGVhZCAqaGVhZCA9ICZoYmEtPmNs
a19saXN0X2hlYWQ7DQo+ICAJc3RydWN0IHVmc19jbGtfaW5mbyAqY2xraSwgKmNsa2lfdG1wOw0K
PiAtCXN0cnVjdCBkZXZpY2UgKmRldiA9IGhiYS0+ZGV2Ow0KPiAtCXUzMiB2b2x0Ow0KPiAgDQo+
ICAJLyoNCj4gIAkgKiBGaW5kIHByaXZhdGUgY2xvY2tzIGFuZCBzdG9yZSB0aGVtIGluIHN0cnVj
dCB1ZnNfbXRrX2Nsay4NCj4gQEAgLTkxOCwyNCArOTE2LDcgQEAgc3RhdGljIHZvaWQgdWZzX210
a19pbml0X2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiAgCWlmICghdWZzX210a19p
c19jbGtfc2NhbGVfcmVhZHkoaGJhKSkgew0KPiAgCQloYmEtPmNhcHMgJj0gflVGU0hDRF9DQVBf
Q0xLX1NDQUxJTkc7DQo+ICAJCWRldl9pbmZvKGhiYS0+ZGV2LCAiJXM6IENsb2NrIHNjYWxpbmcg
dW5hdmFpbGFibGUiLA0KPiBfX2Z1bmNfXyk7DQo+IC0JCXJldHVybjsNCj4gLQl9DQo+IC0NCj4g
LQlpZiAoIWhvc3QtPnJlZ192Y29yZSkNCj4gLQkJcmV0dXJuOw0KPiAtDQo+IC0JaWYgKG9mX3By
b3BlcnR5X3JlYWRfdTMyKGRldi0+b2Zfbm9kZSwgImNsay1zY2FsZS11cC12Y29yZS0NCj4gbWlu
IiwNCj4gLQkJCQkgJnZvbHQpKSB7DQo+IC0JCWRldl9pbmZvKGRldiwgImZhaWxlZCB0byBnZXQg
Y2xrLXNjYWxlLXVwLXZjb3JlLW1pbiIpOw0KPiAtCQlyZXR1cm47DQo+ICAJfQ0KPiAtDQo+IC0J
aG9zdC0+bWNsay52Y29yZV92b2x0ID0gdm9sdDsNCj4gLQ0KPiAtCS8qIElmIGRlZmF1bHQgYm9v
dCBpcyBtYXggZ2VhciwgcmVxdWVzdCB2Y29yZSAqLw0KPiAtCWlmICh2b2x0ICYmIGhvc3QtPmNs
a19zY2FsZV91cCkNCj4gLQkJaWYgKHJlZ3VsYXRvcl9zZXRfdm9sdGFnZShob3N0LT5yZWdfdmNv
cmUsIHZvbHQsDQo+IElOVF9NQVgpKQ0KPiAtCQkJZGV2X2VycihoYmEtPmRldiwgIkZhaWxlZCB0
byBzZXQgdmNvcmUgdG8NCj4gJWRcbiIsIHZvbHQpOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgdm9p
ZCB1ZnNfbXRrX3NldHVwX2Nsa19nYXRpbmcoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gDQo=
