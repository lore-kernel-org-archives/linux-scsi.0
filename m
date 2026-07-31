Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566CE35E1A0;
	Fri, 31 Jul 2026 05:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785477226; cv=fail; b=fj2ecvjz1tFP22KjR2XbeX5ryay7JuAiRImkUPKXXTv7mj4PlN4f/KULVCCJ1ya6nNR70UmNf9PZaoYtSJQGO5ipwHk7C/2Y/aKYflxEeWi8AGG1gH6ny3F2Mqn2k0J+8e+CNLyZJbw672MQsCzbj5LtoHLv6s17tcrKwEe4Z1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785477226; c=relaxed/simple;
	bh=wlgOF1DG0+Vpf6RpbonUyzdBXfKmvz7lKopH/6CuSCs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YXrOkVw/ppuudfBNfFzKWVYvPzi2Gai5nqF3JyT/QHHDQxQefnh3ciT1F5huVJeeOKTsqZrTrVAfci/810jvnza0ZIPyzB+3FRHudvp0cvO5L51smFM9tN9JPrqgZml+BjScnf0lWtqkS/Aol+Wy0opHbreNHmz7n67wOoCUmmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AhDKt8YU; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=LJ/UIw/j; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AhDKt8YU";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="LJ/UIw/j"
X-UUID: 2c9a30b28ca411f1b1788b6acf885367-20260731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=wlgOF1DG0+Vpf6RpbonUyzdBXfKmvz7lKopH/6CuSCs=;
	b=AhDKt8YU7u5SiUZda+UL/5WP/6LOilMWSw17jCU4D8ZVUgj3Vhmax+GxsaMhNxyQcCjAKTp0WXX8mU95Ix1AyFRb9shbz5QKX1kQXn0DfbWDs65b8XTo0oPDQj1L+cliFHqLitYYo0ss6ZjgguygmAArBeTkQARIWUf9MMptRZM=;
X-CID-CACHE: Type:Local,Time:202607311353+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:9e654fb6-ba5b-4aa3-ad87-bc32c594dbdf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:f00ffae1-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2c9a30b28ca411f1b1788b6acf885367-20260731
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 885891931; Fri, 31 Jul 2026 13:53:37 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 31 Jul 2026 13:53:36 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 31 Jul 2026 13:53:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbzR0STm8AI1G0Js7nzshkn9YowemkyqW/2MAweVBkdm9aRbgbL0FFnBC5vKCAzWOZ3Rm2RRsW/4NKQiqSjeBrqhmg0iicqEkrMlZ0WkZjLrh4HB82OZ1tS+0LFCdruji0eCk30zK+BkzSei0x+rv408H1EQg949Vos5oyqyxxE4glb2hEfYOMFCSjWyHxDdV0eU3sXHDV9Q0MQAiSq/66qSrcKL+YCsCtRCXBU4QZAYXmq0pQ5NTWZ5vghMt2gowa0IqbDymKMj4r0Y8a2F20M4JcDPemnRrePGYblVkWFI4c+YB8HctIgv4ETqJwf+LpYy6G2MtaBv3Yh2BALB2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlgOF1DG0+Vpf6RpbonUyzdBXfKmvz7lKopH/6CuSCs=;
 b=l+xhqBYOxtJM3AdkLmG/q4YPXmynQRSEkpa/d7RS1Dga0g4GpyfK+D+D0lM2VqqvLSuwGpJw9NPKGl5lyaEDCW1J43xzTOQGzwR4AfMt1uPmD9SfszsE5J5huAxQ0wQlTLd+wFoIR8hkzQqauHdH3NgqyZj0l4BSZlBZefWKUehcWlpjLmH8lF2vsB5bW27c/WLqi+tv1WlaToPC4QuKmkbn/DrXlPs8NdwR4DryFeGlonvWeK3qaDDwbrQ46/L/Cr00u5LK0BHAs7R4omnKKtPe5pwBdVQ9QYti2HsJzDsVO/TKIBEd7xSr7HAq2uVkwG6UvG8kIkgYxySg1A1yoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlgOF1DG0+Vpf6RpbonUyzdBXfKmvz7lKopH/6CuSCs=;
 b=LJ/UIw/jXp85reDo3DMtLCK81ovM+kYBByD0sg7ByGljfTBJkeL8rrlnrA2qNkPz+re59WnUMdR2A0jE6oNyofAFc77a9exYXpxpXFn/Jq5I0eZ+b1dLbp3d5EET1bK7axwXblBItzpo+KQzidDOC6ca315tuyoX+Ljxb7QsQYU=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by SEZPR03MB8206.apcprd03.prod.outlook.com (2603:1096:101:192::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 05:53:31 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 05:53:31 +0000
From: =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	=?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "broonie@kernel.org"
	<broonie@kernel.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"robh@kernel.org" <robh@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"kernel@collabora.com" <kernel@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>
Subject: Re: [PATCH v10 25/26] arm64: dts: mediatek:
 mt8395-genio-1200-evk-ufs: Complete UFS power supplies
Thread-Topic: [PATCH v10 25/26] arm64: dts: mediatek:
 mt8395-genio-1200-evk-ufs: Complete UFS power supplies
Thread-Index: AQHdIAkO2/HP04W1VESxskakEuv3+raHIcKA
Date: Fri, 31 Jul 2026 05:53:31 +0000
Message-ID: <e6151338f1e67f5d1f989cf3868103f8e6ab19e8.camel@mediatek.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
	 <20260730-mt8196-ufs-v10-25-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-25-bc5ecef202dc@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|SEZPR03MB8206:EE_
x-ms-office365-filtering-correlation-id: d059c1b8-4d8a-4d32-dbb3-08deeec80d4d
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003|38070700021|921020;
x-microsoft-antispam-message-info: xRiW6LYKxgGmYa99G3AuRY71+PSiRcQ+riiem1meJfkkEODDXOCRej4lIy4ggObChJr3J1QBdXk9+NAzZMK3qB2hN2ttFFIFfrr1MPWLPPA90rPgPcHqAu8dV94Plu/H4Sdg7Lc/Zk8Wom3g5oQ/yqdfQgF38gfdKFkpdrSMW+Fl/wmLUIpquCZoOvOCTpmHiK7BlGoKiCQh5K33ZsdD1pD+JYABw8hzLSfzH72Ma9kSlGbNcczpfz4bRNvchEWqwrZfE42/gr4UE7QdOih4KMLG4ebcd5vfcQz6q3885U/ONUyvyUzAn99wNd22oogaaOrYtOBdTXHaktA+as4btXCmFDEC3xAJs3XbbuI79tQopy306cDqYrILA2Fye+1Rg7yhWfj2M8LWVzbV1/OmRIRvCt1Tbyp2X47uR1dwNmEiISRt0cpeUJEt2OsRvNKKfDjzO4koRW8B3DfiM4YWdNj/D4g0B5EeDeCIALsft8V4xC9nZl6EC7XRXOBf2y+Zo/w7MJ7A9w39tJG42iIH+Wz5/U7m6mcMB8teZM/WS4w20U8uOR92nsFDPPGuTUhmQty+XRnQ4RiDZUo/VUdgBHoFLaTsnq3/p0avYztnqbfsMmgwejHA8DMMj6lFXOvk9n1opHdkhYbAo6+P7BEsCwozVcDDPUbJkvVkSRDTSlLdznEQNokW80G5PTDaqximqHpvP3ETxsemnqBRizEWRVLn4HX0OunFGsFSOSppZfXEoPxB5OJhxFQlxRNlgX0d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlkzeVBrdHVKOHdTMFFXbUkramg2bDhqTTB1U1hnd3NCdkZqWHpINE1QcUZI?=
 =?utf-8?B?aTlHRnFpcG1KK0pxYTZrZjF2akorajQzbFhNMGNYVmZ6YXJLanZzdVY5c0E0?=
 =?utf-8?B?OGZhZWJnL0NsNE9ZM2xONzR2QmhYS200Sk95aXB5MTUwTzNVNXkySWJHdXBE?=
 =?utf-8?B?RzVESEZkVHRwS1ZXSUVXSGpSazNvZHlQRWxvb21LdloyNnNaY0kxOVVCbVhx?=
 =?utf-8?B?N2VmYXUxRndDclMzeW9ReWtlTUp2RFRRek1PNkRwTGJsQTZoMzN0dXRjWkdu?=
 =?utf-8?B?MEdlUWFzZW0zOUZRdXhKQ052WjF2eUM5emxEeFJUU3U1Mk45WHVBYkl2TDUy?=
 =?utf-8?B?YUplS0xJQTcySTY0dmRxZGs3N0tFbm1tajFUK3FHeEpld2QvSk51MVNveGRi?=
 =?utf-8?B?cklMancvU0hUcnFKTjRqbHY2cGN4WWlMZTEyU0N0TU0yRi9RVFo0aFYvYnQ3?=
 =?utf-8?B?QkRpRERuQ1Z0MWlxSzFHVmI1cjY2VzZ0V3doZE4rZ0NyTXBhZTdWdGFzaTVI?=
 =?utf-8?B?MFNscXNtWkpCVVBWUGdwQ241dllidzZZYisyRFVMZC8xazY2RDdXTEJBaHNR?=
 =?utf-8?B?Z0R0UTZIM2pVT2Y4OGlkSkdQWVdvNlR5aXR2LzZDa2RJY2ZVS3pRNmJHUFBZ?=
 =?utf-8?B?SkRlUDVpRUorTDk2S2FRVnhiTTFkbkZiRGJpMWEyU3NlRzlFZDlaYTFWZERu?=
 =?utf-8?B?UCtybDI3bnNFSjNwM0hXWjhZaVVkcWFOaGNaZlZIWTlyRGJuazJ2em4rVkdp?=
 =?utf-8?B?My9zeXJOZmxUNmNlUVVqaGw0Y1JVQW1VeUZPakR2TFVsM1lsUktvZTAyWUxV?=
 =?utf-8?B?bGVKMlBVbkczenJzTXU3YTNUUUI5YVZTaVlib1Z6WSswbWpZK1BEMW1tMDls?=
 =?utf-8?B?TVVtWEpRN0tIdGZVNVlKZ0NMdU1HNkNDUDUzTVI5VWhheUUyNEJtbkVwWG9M?=
 =?utf-8?B?NCtkZ1cxUm1XdlhvQ2tsdG51SWtnYTVMSmVjdVRnK0xQdHBrOEhGTjlERlJU?=
 =?utf-8?B?RWNzV1FWaG9OZEhvRk9MT1F4RnM5Q0l2V2dGeHRtYWllZlo2WGhKZm1neFlp?=
 =?utf-8?B?QzV0ZHcrZW1oMXpCRmEyY25EbzZMVlNRSkxYMFdtT3pVU2F3aUN6dzBYVm5n?=
 =?utf-8?B?MWh5bTRxOW54WVlQOUpJZWhzZCttejZzd3ljeFJ3RHNlaENMQmVoRS9PSWZo?=
 =?utf-8?B?bHNuaXpET3p2eC95L2Z3ajJYdHdrUmd5WWpSZmtlczFzQ0Z1c1NwN1gzYzFy?=
 =?utf-8?B?ZHBZUGl1ekRmUE52SU90L21EV2pWVHVFb1QyTlNnMzhFcVZ1NGRzQWpldkxj?=
 =?utf-8?B?M3BxQURZV2dwOE1aTGVmT2pMR1JNSTBsYW02bC9yYTBJQjNkaHZmamNmTkJU?=
 =?utf-8?B?b1Bodko1Q21IYXl4cXFFaFRpUCtQL09mRXBBcVoxQzFUNDBhV2ErWmFTVEhI?=
 =?utf-8?B?MXB0U3Q3Sk41Mm5yWE5kbkRkUUExcUl5RC9EenJWOTMyM0djWEJEaENUZkhS?=
 =?utf-8?B?Wlk3ZHVYSnVaZjZYM1dBQmNzNTBicUF0aytqTnRjYmY0dWxXeWtLQmtsWnZu?=
 =?utf-8?B?ZzdmNnlyV1Z6V0NMZHRhblZNbXg3UkFQeGtkbHpGaEVTekNMUWNJRmhXUFZP?=
 =?utf-8?B?K25MR2VBdVdIa0w0ZEE5RUdUMnI4MEF4MG02ay81R0FkLytCNDRLRmJOUzB4?=
 =?utf-8?B?WHlkckkrVmhSNnZzSVVhYUJBUDVDQmNOK0cxUngvdjRvYkIwMlQyaWl3T2Zo?=
 =?utf-8?B?TWZoMFY0bzhKNHRGdVV1cUc2Qko1aU9sWmdGbEtEN3RUMnVYSXdnS2Y5U3Y2?=
 =?utf-8?B?MjM5VENueUdUc3gxaFJPOXgzRjBwMmZDNzVtQWpRV3FSN211VE5FbGNrM1R1?=
 =?utf-8?B?UXRlemZuaDBZMWVUdnZKVFNXZGx0eWNUL2ZuT0QvdmkyRTk3aFFIS2ZDM0NV?=
 =?utf-8?B?VjdnSUhCWU9BcXFxN1Zyc0JLYUtFamdOQWxVaWtPU2N1S2tUeFVXUlJmQWp1?=
 =?utf-8?B?aWQ5eFRlSGEzMmhQaVBGdkdPczEvMUN2YTZ5VXh2eEJIWnhmYW9PdEg3OHVB?=
 =?utf-8?B?ZWREMjdNbkJpcUJuQ2ZqTGw2QVAvTHdSZ1E1U1ZVQWRGRmZxNGVIODlMRWdl?=
 =?utf-8?B?NFRpZXRxM0pOamdJRTlzSktRV0ExMXlyVTZhWmZINk8xL1FnTjZZT0tKV1d3?=
 =?utf-8?B?RkhFY2dpUy9aS0hVOEdlNlZMOUxYVzA2UFJpa1pTeCtSYmJ0K3QwZnUzeVJN?=
 =?utf-8?B?bnFsZVFnUGFvb2JBdlpyRk9UWHdMTWxERUZjMDJWeUExbytzdnhPY0FzdzNW?=
 =?utf-8?B?QXE2YmFkTkpBVWJnZzVRT2tzNjBNWU5nWmRoL2NrN3MxQXJQdmZVTEx4Skhs?=
 =?utf-8?Q?AcywnEN0lRRUvdP8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D89F076046C7247A39FA5C22CA81F07@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: WNqFjEly7eXWAhGM85+Ivk/CB+hpw7qpHAGnsLV0hS8xQuTzstoIyV6tQh+KSF9WtEXgZOhIcnv3/2mICSBDE53exJzbdqv58LjT2XK3gI6pRMoTmfHs9opJgo8nTCM0K/ATB+41N8+hlKv09+U4OAALE+LQOZLl7WlHinrOWGpL3qQmG/Ir7xZqxDQW/8FpPLqXN8eoItr4+wwrF6cIbr7Ud+rBvxcCOKeUYVaC1H8hUAiwAz+z8kEuynFsa3hfHDFG1hRocfdB211IcpnmpP/StnmHFjSqGLB0UHOjg5QoXMwmpUrTNhLryEyPLPvTEqVD+wjgM2FEmwh7nLp53w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d059c1b8-4d8a-4d32-dbb3-08deeec80d4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 05:53:31.6922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WxcOL4ZIn5ds/TItV4+drT+MKvB2Ebp7eYFFDfM7NQvmDpXes8OAzyI3cpDpyj1X+diKdrmi0KSXgfPGVfNQqDhPt3iKfbj9pYJ2NLX/ZnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8206
X-MTK: N

T24gVGh1LCAyMDI2LTA3LTMwIGF0IDExOjQ5ICswMjAwLCBMb3Vpcy1BbGV4aXMgRXlyYXVkIHdy
b3RlOg0KPiBUaGUgTVQ4MTk1IFVGUyBob3N0IGNvbnRyb2xsZXIgZHQgYmluZGluZyBub3cgZGVz
Y3JpYmVzIHRoZSBwb3dlcg0KPiBzdXBwbGllcw0KPiBmZWVkaW5nIHRoZSBob3N0IGNvbnRyb2xs
ZXIsIHRoYXQgd2VyZSBwcmV2aW91c2x5IG1pc3NpbmcgZnJvbSBzdXBwbHkNCj4gZGVzY3JpcHRp
b24uDQo+IA0KPiBTbywgYWRkIGluIHRoZSBNZWRpYXRlayBHZW5pbyAxMjAwLUVWSyBib2FyZCBk
ZXZpY2V0cmVlIHRoZQ0KPiByZWd1bGF0b3JzDQo+IHVzZWQgdG8gcG93ZXIgTVQ4Mzk1IFVGUyBj
b250cm9sbGVyIHdoZW4gdGhlIGJvYXJkIGlzIGNvbmZpZ3VyZWQgdG8NCj4gdXNlDQo+IGl0cyBV
RlMgc3RvcmFnZSBhcyBwcmltYXJ5Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTG91aXMtQWxleGlz
IEV5cmF1ZCA8bG91aXNhbGV4aXMuZXlyYXVkQGNvbGxhYm9yYS5jb20+DQpSZXZpZXdlZC1ieTog
Q2hhb3RpYW4gSmluZyA8Y2hhb3RpYW4uamluZ0BtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAgYXJj
aC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDgzOTUtZ2VuaW8tMTIwMC1ldmstdWZzLmR0cyB8
IDMgKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDgzOTUtZ2VuaW8tMTIwMC1ldmst
DQo+IHVmcy5kdHMgYi9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210ODM5NS1nZW5pby0x
MjAwLWV2ay11ZnMuZHRzDQo+IGluZGV4IGUwOWEzZWNkODc3My4uZjNkODM5ZjMxOTE4IDEwMDY0
NA0KPiAtLS0gYS9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210ODM5NS1nZW5pby0xMjAw
LWV2ay11ZnMuZHRzDQo+ICsrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ4Mzk1
LWdlbmlvLTEyMDAtZXZrLXVmcy5kdHMNCj4gQEAgLTE2LDYgKzE2LDkgQEAgLyB7DQo+ICANCj4g
ICZ1ZnNoY2kgew0KPiAgCXN0YXR1cyA9ICJva2F5IjsNCj4gKwlhdmRkMTItc3VwcGx5ID0gPCZt
dDYzNTlfdnJmMTJfbGRvX3JlZz47DQo+ICsJYXZkZDEyLWNrYnVmLXN1cHBseSA9IDwmbXQ2MzU5
X3ZiYmNrX2xkb19yZWc+Ow0KPiArCWF2ZGQxOC1zdXBwbHkgPSA8Jm10NjM1OV92aW8xOF9sZG9f
cmVnPjsNCj4gIAl2Y2Mtc3VwcGx5ID0gPCZtdDYzNTlfdmVtY18xX2xkb19yZWc+Ow0KPiAgCXZj
Y3EyLXN1cHBseSA9IDwmbXQ2MzU5X3Z1ZnNfbGRvX3JlZz47DQo+ICB9Ow0KPiANCg==
