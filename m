Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1CCDDC3;
	Wed, 18 Mar 2026 03:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773803731; cv=fail; b=hlSZyGtvEw+zVMqPXXQIa+pMCWOxYLr2kIyYQXBJMeyitIqDAlP3N3lbWBP7wJ7nwklsyKmJmLOgEdfLpnB0ZQEp9wmcNC0r6o6R8PubiifiR8Mi5xZJSP/yCfAUdLlCbjL/ka1XCMyi1lKY7Wt6mBtTOvTBK3ZjOZ9PrFhQqpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773803731; c=relaxed/simple;
	bh=relPn5El+UWeYWUHrGy33Ucy/WlNcBqzJeqLvUq7Vu8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YGU5nFjR7v2xbgWB17OKovAleNL9ePrjACTJAMsVHH1oJVkbMCRV/8gUw2whNTOZHXi5RhLmqS1rBLRLTM/Sx5H9PpLieap4oy23DJQhDZ2/ra6IZn2D6nqNkpDjG3z2AMKGbJV01IpMtlyVjy/bBgZSbmhmtWA1qh2UdT5eElA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jyTMagoP; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YF+RpXs3; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jyTMagoP";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YF+RpXs3"
X-UUID: b36ecc2e227811f1a39cd589f645bc18-20260318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=relPn5El+UWeYWUHrGy33Ucy/WlNcBqzJeqLvUq7Vu8=;
	b=jyTMagoP/LiZWe8NuSie25c1Zo9ts1xhVa3ierahAoLGAuLa2ZWa06rJMG2hK9Sp3Qr1DrVt9IxEbRF536NNNYEjfiFajew1dveaWco4cjwiH2fDiVgFJNnLTV8ogi5ssyTVcxGDUSqqUaBnynmlyQwVqbcvu6NYCO++Jucg2ko=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2eab9dd6-8a72-49cb-9c1c-abd41f59972b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:f22122fa-dfaf-419f-9dd3-d093c7e8f968,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b36ecc2e227811f1a39cd589f645bc18-20260318
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 518576795; Wed, 18 Mar 2026 11:15:22 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 18 Mar 2026 11:15:21 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 18 Mar 2026 11:15:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cFJWJ3VjHyJfS2WamguZ1zK5PKUVAu1vcdoR8uueCBtoN1yaFj270Sv9m94c9WuwshnIUdTiothadpvG1ccO8wZaoGAjFGVd5X83PQtbO4U3Gzc8rG9p8VQHtKpRGvdSrKf/e8kgTaHakWfOQBn1ZWQLFTynpFHYbbZjy7a+xOdUYEjPBpwEbXbpfGQjjEdhVu/0tN0JLwK31AqdPrOk/9Pv/5GziWLDgTxRA0Pk0T7X4fL7p3P9SlnMYl5Pz73R7/7bFHRFxyZ+x08vtyv8CgnO/OERAtkUEM8siCS/s2aO0de4TSuTXXH67wE4k7tTmNG+TwxEDwObIHxhga4qhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=relPn5El+UWeYWUHrGy33Ucy/WlNcBqzJeqLvUq7Vu8=;
 b=JJDNjfCbmJ1i+zZftiv3tJAhLun05oVUbB9e8pe1kGzSqk77Pp1x3pVjcsbn8I05NPVB8q7DnCWROaoL2I1Knunry2r/B4k22pyAml8hMBguTdtYYYJpuOFnyDZLsTqC4VcDmQ4e7r2Ufe2QaAUahLsDqnpOlKX+5tgE6S9/zHsbFP2y71G4JT4YvOkICjDaHObU5gqzifv8qnFBE7ewEDuloDI9NckXeHCOLMeZ4noHfQ1YeFYGwPm3VERVqMNa244K3cHt7eDq59baD/IvYfpFzCJu5jAlbAgGFIQkt4juZUPikq9OIMAjIdLLWt0qd2USHu2aoFDb0BsJSiQ+Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=relPn5El+UWeYWUHrGy33Ucy/WlNcBqzJeqLvUq7Vu8=;
 b=YF+RpXs3VDnKRRvFceoOG1pMWVQUkbSJTPTNAKf6Xp4ERlb+3QjBrLfU4FRUEcXY7+WROGNFnMyNv4t5oPZnvIUDWRX1J5sqXJyOXC64N+S5eKqK1LZgFL/HiicouG9yA2kJ9rt9PluJ6v4fGMpTxkFcByNwmEXJiuHbas5ShQc=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by TYNPR03MB9894.apcprd03.prod.outlook.com (2603:1096:405:3b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 03:15:17 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4%6]) with mapi id 15.20.9700.025; Wed, 18 Mar 2026
 03:15:17 +0000
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
Subject: Re: [PATCH v9 23/23] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Thread-Topic: [PATCH v9 23/23] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Thread-Index: AQHcrW0oWZSD9fqd3kmagEgYp7lkibWzsAgA
Date: Wed, 18 Mar 2026 03:15:17 +0000
Message-ID: <daee335be4aed346cd157ad41d0889f4c91337b9.camel@mediatek.com>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
	 <20260306-mt8196-ufs-v9-23-55b073f7a830@collabora.com>
In-Reply-To: <20260306-mt8196-ufs-v9-23-55b073f7a830@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|TYNPR03MB9894:EE_
x-ms-office365-filtering-correlation-id: b502adbf-5fab-4c2b-9edc-08de849c946b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: ywXVaKjjtt3879z0FhMLG1oz/3Vf9IOuPX+KakZM9SjO5VwGnxBis75whny4dAiSigyRusrni/4NmhiHXBccqRHHc1aN/cS+ACgtziX9viWIoJQ4wvVJvsCB7cv1GKlp7RnL1IPxSNfdbnW3uWodTU6wVGqx6iazGzI7w1D/MvTKflJC0Sixmf78qSD234iIGsuzoHgq7k0X52qCik3hfAY7M029I9T/usWNrqKGYiuykOe6fpFjg66/ixq+pfBZypmFTkkHlUJOz6FHlJfj74adH1ob8G5Vq0/pE2vMQIa1tRO/qF8XJNxGp0mNc2g9gP6qh/xnHNVlZAps/6DXJPkpnKFPpYmzAaT4dn05pRKjEXneTal5wfRxo3E49hIAtDtrR4brM6rRXc2r0cL9kdbc+SnE7KUxIYdthtkA51SWEoKZ4XuMyTlnSLJJRT+iO/aHHqdFL5so7w0XVEX81B6MIYusj9Gr1eVX1ZVsLxsCr+TCe1M9nDGbM5gM+Pmorm0LmTK5hN9wHehIJlztKRaHw40xzaamye3GGJQdOgZFM0Fqh5KyjhAa3Dbjnu2lpPy0TmtphzmJZqjtUlM8PjZEaG4INcy8C8OjYmGPZi5zrBCqLO8ly3kqXYvvU8FAUtGPlXurICaj/HwCzTBZkr7Vh/3Eb9AB+cD3wtTTHKZ81+rQqRrdmAW4sSi80kIOz2XkC4AtxW1o0YY3NgIAn0yQKIbsLUvo9j3m01HQC1+axZiM1WsjYQPfenSD+McLf7ZAR731AbFnDEb4hguQAIZs4JZSkLPHB8BaypjwYxyp2m3Epesv/uNlR3Lcdmr+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXFacFlDYUZOanRSN091cTk5VFYxL25QTWdBQm0rNHpZSHdvWDAzMWgrakRG?=
 =?utf-8?B?WGVFMDFTN3pveFZUUXN0am85TjNUTUJONmphRGRDNWw5YU9ZOWVLa0R1UW90?=
 =?utf-8?B?YlZTdGF3aFlKanhJSXZFU0Q5RFlZdERqWm5NTlhwbklMMlVKQ3NvbVQycGsr?=
 =?utf-8?B?T2RPN0QxQU5rRlNqaE5USzZUVTlxYjZSYTk1T0ZqQmpFeEcwVWlGUGRmVWl5?=
 =?utf-8?B?eS8vRmluTStTVjlFU2w4Q1pYb044c3I5ZTI2OTN4TkFqS25ta0RXZEUybjhx?=
 =?utf-8?B?ZUVyWG5nQUN1MDRRNlovU3RLajFwQmVGR0pSeitXTkJuSVFHaXZxMkpVcjJD?=
 =?utf-8?B?NTVlbFdyMXRMZzdyK2NqWjVuKzZRZXZ3c3JkTHVod1dEYmlHT3FFZ1ZDTjZB?=
 =?utf-8?B?ZHptMzVKVGljQTBKMkJKOHlHSFl0c0pySWV4d1VXV1FLa252MWdqdERGRGdx?=
 =?utf-8?B?d2NFZTdjWjNMbUdFREpSY0o3YzdmYXFRbzRxbG50UlJQTmF3ODlnODFETzZp?=
 =?utf-8?B?VFV4NGE5VWVTMTN2RHZaQWVFZk90ZmhFaWJxQTRYYk5SRTM2VXBRV2NMbVhZ?=
 =?utf-8?B?dTZTa0Mwbk5DbEhnZklmWnFwbHNvbzhiN2hIeWR6YVJMbGo5VDZmQU5sbVlF?=
 =?utf-8?B?NGorRlFFUnRXNlQ5aW9oN1VLWGJSTDhnbDdaaS9RdkZ5S2F6SDNzUE5nUDVp?=
 =?utf-8?B?VGx1WXcxNTRWckZvOWQ5Ujh1Mmh0L2l0emJIclFrRERocmpHRm4zR08xRnhD?=
 =?utf-8?B?bTlMb3Rab3JNNjdsZ01KUDB0cVpvbmNjQkJBN09mZnhNTHQyWG0xTVE4b3dX?=
 =?utf-8?B?TEdiVVhmb1hwSGFWYkRzMEkrU3h2OVZDeFRLL3lkK2kwTUcxYVh1bDR0OWx3?=
 =?utf-8?B?c0JUdWN1RDZQYTE4RUZnSTM0R2M0TW1RUEl6WWpUQWFtZWJwT0pGMEZaSHdi?=
 =?utf-8?B?eXFqOWJSdE5HQWlVa1lsNXpaT2xycUd3VkZvbmU1YVZIVzVxcWk5ZXpPcUQr?=
 =?utf-8?B?a013U1hLV3ZSb3lUaDZ1M0pWMTRWLy9WWEZXWC9tM2VFZi85RkZIZGFDYTI0?=
 =?utf-8?B?K09mYTNsOWo4TFpuM0p2dms2aVlSNnAremo4Ym42VW1FOFlpT28vSHVjVGRR?=
 =?utf-8?B?Z2t4VW1vKzc4YXUyekR0NXBkdC9iTFJMT0ltUnEwOEp1WVlUZDNzamtmcmc0?=
 =?utf-8?B?dnYrR1dkVysvbkxiUDM2S1ExdUV3VEdpZUN5bFhGUHNvYWZ5VE5QeWlQaFp3?=
 =?utf-8?B?S21oZm95ZU9qYXdCUGpBS1JlV00xT2RtZWVuWkJaOUl2YU9vSUZHcEh6dHov?=
 =?utf-8?B?VVdFVThYeWYyeU5IRGJsZTA1clQwNFBDRy9ybGN4ODJCb1RTQS9hV0t5d2Ni?=
 =?utf-8?B?MWFvRWMxSDVRdjlPanFSWWZlM0FLYkQrYTlTNUR5SjVjVDk5bFErUVdSK3NP?=
 =?utf-8?B?b2tNc0dsQisrcWNpMC8xOFQ4WjVDWStyNW9ZdmtvSnJwbnM5Rjl5eExqNWgy?=
 =?utf-8?B?b1JEbTJBYWlYblJTNTk5eDBsbkVxbEJxYUplRFJhU1lvRFBrcUMwVTBDRFlh?=
 =?utf-8?B?N0poWENTUTRpTDlQWDJiYzRLc2NRUklCOHJTcGtrRHRodm16OU5wbEtJUTdD?=
 =?utf-8?B?bWxyUEVyQ0g5UERmZkpmTWRsSkFkcHdENGk5SFJsU0pXdFZDNG9XdnBLblA2?=
 =?utf-8?B?RjFXQlRIamhDNExScEdwVHhnM0IyTFQ3S0ZvWE5sdU5udkFSMlViVm1EWGpS?=
 =?utf-8?B?YXhwOERXOU80T1pUVkdWZHVtdUdONFpwaWtiMW92SWNWaXp5SVJzdDNHMkpo?=
 =?utf-8?B?M0ViNHdGRkw3N2oxZkVnTEhkMzFIQ1BJdjJ6OXRzZXBYQ1JER0pPV2FGMHVs?=
 =?utf-8?B?TThIYzkxcmdNTlg5S1JWUWFHcGYrU2FFRTZYUTZ6UlpKSUlmWHExTlRTeEpI?=
 =?utf-8?B?RS9zUytEZnFIWW9OYnFRWWUwc20zNzFBek1SYVhIaE84eURFQzVDSmhYZUZq?=
 =?utf-8?B?U3M3d2tBQm1Gb0Jod2lmSTI3a3pwVjlULzU3UWhhbUVSZmRhbFJMalFHUEls?=
 =?utf-8?B?aVlQWWR2MFFJTlY3V1ZjOENBSmNmMThMYVlzb3VyWWswNnhPc2YrZFVHZmU2?=
 =?utf-8?B?eTAzRkFHMDBCWjFoTnNGeU1nUTJXbmJuTmgzZHZxRTBXTHl4U1FzVGFvMUNO?=
 =?utf-8?B?T2dLUWZTUEtIRnlOZUxOcTlWU2k0RFZselI1WHNPdW1UaUdsZkpNMXpTRzJ2?=
 =?utf-8?B?YmFxT292RjRxcFVUVDgxcVppU29aMlFPY1pRdkxpNnpnNnM5WHZHQ0kyZ0VT?=
 =?utf-8?B?dk1zalpubEo2MWo5dEMzYzhiSXBPaENrN0I1eDk1SzlTUFA3YXlWN1ZVQU9D?=
 =?utf-8?Q?H3Qpqim6dSHqRPZs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <590420873312224697DF1C4CBB9E7032@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: R4Ww+AMW7aCflKIASXTGpdCtA2XDy2EOi/yLjcLG+OmAuyTGEpetAojU8B5mttSkS0UDg4xyOU3fuERyOke0gWKSIG/BiLiyYSxi02t0aDusgK1hGKcM76wRoROgKDwFGoz7W+ssE7SHe5YZ0x6zXpsW9o6U7HHdSK6Bo/RvGP04mHDHEfpF4TaJlkCLNDnxcWlYiB+2LSY4KQzEJX/Ioy0aoQTwSRcXUfOPtP5cdSwa0J9M3ysSytryT+RMnPcJDXkEBRhWOR/jDRe+LTBMgN7oANWzLIj5rUCv5d8jNFeSKNTLnwCkaj7/KwTgvrI7huDYydZwNhFbT2lXdREE5g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b502adbf-5fab-4c2b-9edc-08de849c946b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2026 03:15:17.2953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3II803iOe3r0qSvNXhBwqT5rfpDXab/4LxkZPvbx6+dgafiMviTv9Ijxeivs+hKwlfTPWZJH6PBexPQQUJ/SvUCRo/7TyHqZAe1VYyhunk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYNPR03MB9894
X-MTK: N

T24gRnJpLCAyMDI2LTAzLTA2IGF0IDE0OjI1ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRIZSBNVDgxOTYncyBVRlMgY29udHJvbGxlciBoYXMgYSBuZXcgY29tcGF0aWJsZS4g
QWRkIHRoZSBuZWNlc3NhcnkNCj4gc3RydWN0IGRlZmluaXRpb25zIHRvIHN1cHBvcnQgaXQuDQo+
IA0KPiBBbHNvIHVwZGF0ZSB0aGUgY29weXJpZ2h0cyBhbmQgYXV0aG9ycywgd2l0aG91dCB0YWJz
IGZvbGxvd2luZyBzcGFjZXMNCj4gdG8NCj4gYXZvaWQgY2hlY2twYXRjaCBlcnJvcnMsIHRvIGxp
c3QgbXlzZWxmIGFzIGhhdmluZyBjb250cmlidXRlZCB0byB0aGlzDQo+IGRyaXZlciBhZnRlciB0
aGUgcHJlY2VkaW5nIHJld29yayBwYXRjaGVzLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFuZ2Vsb0dp
b2FjY2hpbm8gRGVsIFJlZ25vIDwNCj4gYW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJv
cmEuY29tPg0KPiBSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xhcy5mcmF0dGFy
b2xpQGNvbGxhYm9yYS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWsuYyB8IDE3ICsrKysrKysrKysrKysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9o
b3N0L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmMN
Cj4gaW5kZXggMWRmYzI5OWI5M2I1Li5jYzkzNTdlOTA5NTggMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMt
bWVkaWF0ZWsuYw0KPiBAQCAtMSw5ICsxLDExIEBADQo+ICAvLyBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMA0KPiAgLyoNCj4gICAqIENvcHlyaWdodCAoQykgMjAxOSBNZWRpYVRlayBJ
bmMuDQo+ICsgKiBDb3B5cmlnaHQgKEMpIDIwMjUgQ29sbGFib3JhIEx0ZC4NCj4gICAqIEF1dGhv
cnM6DQo+IC0gKglTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiAtICoJ
UGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+ICsgKiAgICAgIFN0YW5sZXkg
Q2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+ICsgKiAgICAgIFBldGVyIFdhbmcgPHBl
dGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KPiArICogICAgICBOaWNvbGFzIEZyYXR0YXJvbGkgPG5p
Y29sYXMuZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPiAoTWFqb3INCj4gY2xlYW51cHMpDQo+ICAg
Ki8NCj4gIA0KPiAgI2luY2x1ZGUgPGxpbnV4L2FybS1zbWNjYy5oPg0KPiBAQCAtMjIwMCw2ICsy
MjAyLDEwIEBAIHN0YXRpYyBjb25zdCBjaGFyICpjb25zdA0KPiB1ZnNfbXRrX3JlZ3NfYXZkZDEy
X2NrYnVmX2F2ZGQxOFtdID0gew0KPiAgCSJhdmRkMTIiLCAiYXZkZDEyLWNrYnVmIiwgImF2ZGQx
OCINCj4gIH07DQo+ICANCj4gK3N0YXRpYyBjb25zdCBjaGFyICpjb25zdCB1ZnNfbXRrX3JlZ3Nf
YXZkZDEyX2NrYnVmW10gPSB7DQo+ICsJImF2ZGQxMiIsICJhdmRkMTItY2tidWYiDQo+ICt9Ow0K
PiArDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHVmc19tdGtfc29jX2RhdGEgbXQ4MTgzX2RhdGEg
PSB7DQo+ICAJLmhhc19hdmRkMDkgPSB0cnVlLA0KPiAgCS5yZWdfbmFtZXMgPSB1ZnNfbXRrX3Jl
Z3NfYXZkZDEyX2F2ZGQxOCwNCj4gQEAgLTIyMTIsMTAgKzIyMTgsMTcgQEAgc3RhdGljIGNvbnN0
IHN0cnVjdCB1ZnNfbXRrX3NvY19kYXRhDQo+IG10ODE5Ml84MTk1X2RhdGEgPSB7DQo+ICAJLm51
bV9yZWdfbmFtZXMgPSBBUlJBWV9TSVpFKHVmc19tdGtfcmVnc19hdmRkMTJfY2tidWZfYXZkZDE4
KSwNCj4gIH07DQo+ICANCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgdWZzX210a19zb2NfZGF0YSBt
dDgxOTZfZGF0YSA9IHsNCj4gKwkuaGFzX2F2ZGQwOSA9IHRydWUsDQo+ICsJLnJlZ19uYW1lcyA9
IHVmc19tdGtfcmVnc19hdmRkMTJfY2tidWYsDQo+ICsJLm51bV9yZWdfbmFtZXMgPSBBUlJBWV9T
SVpFKHVmc19tdGtfcmVnc19hdmRkMTJfY2tidWYpLA0KPiArfTsNCj4gKw0KbWlzc2luZyBhdmRk
MTItc3VwcGx5IGFuZCBhdmRkMTItY2xrYnVmLXN1cHBseSBpbiB0aGUgRFQgYmluZGluZyBvZg0K
TVQ4MTk2Lg0KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgdWZzX210a19vZl9t
YXRjaFtdID0gew0KPiAgCXsgLmNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ4MTgzLXVmc2hjaSIs
IC5kYXRhID0gJm10ODE4M19kYXRhDQo+IH0sDQo+ICAJeyAuY29tcGF0aWJsZSA9ICJtZWRpYXRl
ayxtdDgxOTItdWZzaGNpIiwgLmRhdGEgPQ0KPiAmbXQ4MTkyXzgxOTVfZGF0YSB9LA0KPiAgCXsg
LmNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ4MTk1LXVmc2hjaSIsIC5kYXRhID0NCj4gJm10ODE5
Ml84MTk1X2RhdGEgfSwNCj4gKwl7IC5jb21wYXRpYmxlID0gIm1lZGlhdGVrLG10ODE5Ni11ZnNo
Y2kiLCAuZGF0YSA9ICZtdDgxOTZfZGF0YQ0KPiB9LA0KPiAgCXt9LA0KPiAgfTsNCj4gIE1PRFVM
RV9ERVZJQ0VfVEFCTEUob2YsIHVmc19tdGtfb2ZfbWF0Y2gpOw0KPiANCg==
