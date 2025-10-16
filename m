Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DEA10E3;
	Thu, 16 Oct 2025 02:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760583592; cv=fail; b=eW+STq7zywKB7FhhUKNcQD58Ul7h0gHlZjqgebqzQc2Qpx9PPDJKEu3jk/PNxgENEi9478ofh59pFUIrPY+Nbnzq0zoF0KUWLI1vO/PowBeBMHReUH2YDwZRKNI5dL5IxhgSP2CAq02EMyPOKbIQ4wZBQyQhV11ChdDaOGgyf2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760583592; c=relaxed/simple;
	bh=1Mczf1qTJzEGJor4cBmtNJvp+BBi4WCcMLxlZEgzKnY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bVEpNlN8D2wScwRmp5lqVDgxQoOtShBzms695mRxnGSnydEzyGamgprh+9e3HkOIy2YJbinPEpPlo3jxkkQHq6kNjNtN7ACVbZL0LfmsRyOEcX+hRT+S5XGc9D5SU1M+r89m0LXVkVIcgSSY+3QHNh75oFr4xsZKBDqwRnVWvQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VJJGm6Eq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=KiVjDdaY; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VJJGm6Eq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="KiVjDdaY"
X-UUID: 2a76e7bcaa3c11f0ae1e63ff8927bad3-20251016
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=1Mczf1qTJzEGJor4cBmtNJvp+BBi4WCcMLxlZEgzKnY=;
	b=VJJGm6EqI7QB4GvxgPrMeid/3ehU6V5D5cQkLgbPrw+wWft+OspFY+FXnb8cNiHFVMx3OKP1RZgo115LtSWh7QNXMDrBUTxNqWy4SAeKNfSsQq6+XZWcnF7vbmQdzt8MfrgSHOI5VWMRbUh6rKsQd2KpNgdNNdBwlH8bdJV6vjc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:c7e21c20-b647-49d4-b196-5ce131edd496,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:1a591c51-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2a76e7bcaa3c11f0ae1e63ff8927bad3-20251016
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 984726375; Thu, 16 Oct 2025 10:59:43 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 16 Oct 2025 10:59:41 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 16 Oct 2025 10:59:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UL4zHYc/93UQFtHCAMEvuGGpS6cCpBEstL8F0wOdcN3gBg81YtjSKuGLO3+X0WVEnOWQc+L7STYFj2pcnlsd+cf/UAcXrhTR7Bvi1gEw7kEE3I9sWU56cqQLFx7SWFSvFlLw5TaN/zMITQmLyInXMOApD7tzb5yQG7S2k3eFPkqTN3tFp1nfUUwai51BPiHNTCHHBw1qlngBqFwnMTQUFxfkk4xtgUkf719PELRBIpj2T8KiM2H9GP82cDr5UzcEz6UXK+6G+QdD0e7IE7Qf9gpE9jI15aZHNJZ8PGWgtbQIYQpqs7+PMkOSFB4fJoewZXO8ic4YYhn0r3oz9wuaCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Mczf1qTJzEGJor4cBmtNJvp+BBi4WCcMLxlZEgzKnY=;
 b=PKVgGowYe6R0tlMqHJ7eqh43AvGIYh8Iw1zkNUjsBRK166aqcv+V0Ap5cMEWdI9t/Ih/USvUfa/RablOsZ5CZucRjSycO+czZ49c6ZX0f/yrGJBEKHrYfyX6eLTiGuqPF7UehEG0Da89W1f4NtKALPUQ8HZk1/8sOJfT7aXCOUdJ4+jY/Y0/igR1nFD7aYZL//+wHji0c3zUoIS7nO1w1PaIo+bc3GKDeMww5ZV7nFD8SRoucKH0/QBiPl0GKinYF4I7Ll0D4u9Q7KWlvjCFSLYy0n6ptb4pQzPOIGy4qLmRy8PwtEpqnTUi36p0FIcLdb4juYvVb6h6UxhzxkNQQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Mczf1qTJzEGJor4cBmtNJvp+BBi4WCcMLxlZEgzKnY=;
 b=KiVjDdaYk/NXMEZJEpU8PJBhJ2qzL6lA37Vw6JewDH51PSMqdfTRspmIZ1Rq7O/0SkFC9jpk78Itx9IdKsNVZQVuBLIpJ+e63RMpiAy/PNpmpsZrxgVymgViajpHXkKWB6EIwYXQSI0rokZxArkvCAH+9d1DLQSvInme27mOpc8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7863.apcprd03.prod.outlook.com (2603:1096:101:166::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Thu, 16 Oct
 2025 02:59:39 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 02:59:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?=
	<stanley.chu@mediatek.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "kishon@kernel.org"
	<kishon@kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"p.zabel@pengutronix.de" <p.zabel@pengutronix.de>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
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
Subject: Re: [PATCH 1/5] dt-bindings: ufs: mediatek,ufs: Add mt8196-ufshci
 variant
Thread-Topic: [PATCH 1/5] dt-bindings: ufs: mediatek,ufs: Add mt8196-ufshci
 variant
Thread-Index: AQHcPR1fV3Js8w3WyEyEMbLOviTe6bTEF5cA
Date: Thu, 16 Oct 2025 02:59:38 +0000
Message-ID: <1948598d44a460349757b52fb580eac731ced632.camel@mediatek.com>
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
	 <20251014-mt8196-ufs-v1-1-195dceb83bc8@collabora.com>
In-Reply-To: <20251014-mt8196-ufs-v1-1-195dceb83bc8@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7863:EE_
x-ms-office365-filtering-correlation-id: 9bfdf011-c087-40ab-0187-08de0c600bc6
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?amJtVncrODB5aXFUUDdoVUdkbEJGK3NPODBjVlRwNG8zb1JsSHVCY01RY3cx?=
 =?utf-8?B?bmNmMDRZaUFlLzJaOVlxaHZ1blp4VjlHS1N1ZmwvMlNxSXlCV2NkTWlITWho?=
 =?utf-8?B?Tmc1eWs1U29tMVFLT2xIc1BJbUk0VXJYUXRBZHcxM1QwMG9ickxESGlJUkVG?=
 =?utf-8?B?UWkrWkViRE50RzlGekNJS3dLSXNld0oyTGp1cnZqMmtYZEhrOWJXYmdZNFpY?=
 =?utf-8?B?UUlXVDYyWEVYQjdrS0NEWnRZWHhqSEQ2dTcwOStFaldoemltL2J1UGIwSTFB?=
 =?utf-8?B?UDF3SVBDQ0RpSnFJTjdHVlhPUXkxRmZEbHY3bk9teWNDdnl4TlB6dEpaazNr?=
 =?utf-8?B?Y0FXQk5TZzE5MEp5TkdhdzJyUVBSZ1EybmZnRHl3VklHVWtQcXVQWmlOdjM1?=
 =?utf-8?B?b0lFY2U0VGE4S0xzMTN0aTl6aTBRVzdGbE5FaHVjMGViSEFteTRRRTExU0tv?=
 =?utf-8?B?YjJMRklEMU5FQzA2eHhWOWRVdktGSVpaN0lHa0JDUHFuNjdUeUtSckQ0N3hk?=
 =?utf-8?B?ZTJYTXlPMGZFQVNoWFptZWpPSWtra3k1WWVORGdadVV2OHdjV3FhOXN2YTlO?=
 =?utf-8?B?cUJsZEVJUDFQUHk1THE3QUJhNHBtR2dPbjNhNkYwZzU3TVJoZUk1YXdJUHVw?=
 =?utf-8?B?Z2ppNjBHWTMzWURoSVllZUx4U29PY3dGaUpmSVNSd3drMGNLY25sdUpjL3Jr?=
 =?utf-8?B?UnZqazgzdi9JcjYvVFpjRzE0bExNQWhiK1ZzZFNEUnNkRjZFSHB2bzFldVhT?=
 =?utf-8?B?OVdLaTRvS3YzR1hxbEhQb1NxQlhtWDVyVUdQUlBPeXZWa1pzMG9oNGxFVUtK?=
 =?utf-8?B?OFVCbjNJcngvUm9pZHFBTXZYNDBBMWM1ejBzVzRpMGN2OXJPSHFuQ1kzQkli?=
 =?utf-8?B?UmVKb1NVQTM4M29UN2pRNW1UZDEwUHFwaWhrVmk0UlQ2R1dQYkVzbnN2eGJt?=
 =?utf-8?B?WGg3SGl6YUxEZWRKc0tlejNTcFh0Tlo4S1gvcm9Ha3pTTHVJWW1qM3N1Yi9p?=
 =?utf-8?B?SmZNckxHb0d5U0RuN3hsN0Y2cHhNVzdzNlVrS3NjWEZ0KzVneCtGMGVVSGdj?=
 =?utf-8?B?cG5RMThPd1psbUwxQWYweFZkNGhWSmlWV2VucXRpam83YmJOMEx1ZGJkZWJv?=
 =?utf-8?B?U3FQTmtQOVM4MjlvTEpiQTJQalhrYnZ0OHJ4cUU1S0c4RkZlNndsYmxLQ1B5?=
 =?utf-8?B?c3hRdlY0elZ0N0FiRC96UXNFZGVpb0puNC9NbzIyVStwaHhmM0F3UVFlS1F3?=
 =?utf-8?B?Z1B1QjlsV2xyczBoWk1TWWhSc296a2szd0w2THpCMytEUGU3RzRoVkRLTVVG?=
 =?utf-8?B?YUl4VG9icjFVY2FVZm9VMXVmZGF4RngvY1ptVk9kYi9JMlBBTG1UcXdXdE9L?=
 =?utf-8?B?WG5meVNYbVR1eVA3UllBRjhwcllzbFdFYTVEak52cU8zRHRyY3BwUndGVVBw?=
 =?utf-8?B?alNoNEZ2KytmOUpSQ2gvSVRuUnE4UUtBeDhzN1hhekRlRGR6ZGdSNUNxQjc5?=
 =?utf-8?B?cnB0ODY4TzIzcnhodSsrdGxmTzFoV2c2Ylk1OHp4L2E5ZzV1eG9VUTZYcWVI?=
 =?utf-8?B?LzUydmNaSUU5TFFDakQwODV6eWtTVEZwOFBZUkRnWk05RElYRUZoY1lYOVdh?=
 =?utf-8?B?cUV5cUZVeGJxSjFyMHRDczRuemtuRThyZDBtd25NaXZnbEtZR2tGV1dlYjlW?=
 =?utf-8?B?NVVjM256ZDZxSHdCbWVGR2FwVkdDWHFkZXJPMG5GS0JoZVVWZjR6TTQvVGxE?=
 =?utf-8?B?dG9wa21RTmticnFRZHE5M3hjeU5sTThUWDViYW9NcTIzN2JnWncrdTAxVG1r?=
 =?utf-8?B?R1hYelNLcktJeTBzL3lPV1dyeloxY1ZjR01wdFF1V0x2Q0dLUDBaQTlkLzB5?=
 =?utf-8?B?UTU5L0hsM2paRytnUVo2bkhPdW50d3JkZkF4cktXQkt1UHRpcG1Sbjg2NlFs?=
 =?utf-8?B?cnRncEl5OFpsRHdQaWtHdmRrOE1pcFRHdlRYeWZSSXBBSmZKaUk0SmdUWGxF?=
 =?utf-8?Q?B9ulBog0OzR2znrQa3WLLEsuDMC/OM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnV0eFUvYVhYZ2dncWh5SVpwMFc3bGc0WVU3OHo5NitoNHpxRUNsMmxWT1N1?=
 =?utf-8?B?eG5wQVh1OFNNOUhSTmdrSHR4WjlaalVpL3pNK05vTEFZSXpkcmh0S1ZUcDlo?=
 =?utf-8?B?Sk9wcEdoZ0ZXU29rTDZ1dW9uM3RUUExuMlJIYkhFakRZbVpHSGtxUllmQkFS?=
 =?utf-8?B?dXFnOTg0ekNGUFJvd3gyendsMDA5dm8wZUxiS0ZsK3gwRTVzdGd2a3dTMVpu?=
 =?utf-8?B?WnBRWllhK1BWVDNmQTR3bHJOWVY3UWlLN2RvOXdnUkwxN3FrYXNESGVGeHQ5?=
 =?utf-8?B?RzBsUEVnWGYyTnN1bmZiQml0N1pJQWlhRFJMT2tqcy9nMGM0Sng5Y0pnSGNj?=
 =?utf-8?B?ZGszbDBJUm4vSGlUTW5iQmcza2NkSG80MnZSK0JZZnNwL0dVSDZIb0twUVFz?=
 =?utf-8?B?YWk2Tkd4UkJrWnFqaDVZd1BSRHhOTHdWR2o1Yk85Zi9MVDMyQ3NjWFJRQzJi?=
 =?utf-8?B?bEhQUXFBM096Y3V2NzZsb2lOQmFwY0JxcEsyUCsxNUxhYUEvUFRBd2tMaFcz?=
 =?utf-8?B?L1dBMHBGUzZFSGNpZWlCWExrVmIvRTlodTRSczZkRERNNllDaDVQR2FpbDA2?=
 =?utf-8?B?NkxQOS9MbHBYOVF2M3V3ZnRYQUc4TGFsakV2TCtoTEJoQ1V6eTBZR25hRFB3?=
 =?utf-8?B?UUFKcWhFV2VmdEU3WXdtUitCWU1UeFFkTzFLcitQSjJmVWtka1FLZkNzMjVi?=
 =?utf-8?B?V2hOWHB1Wkd0K0JkT21pNjMvY2hKa2RIWHRlcnh3WmxWOG1yZ1hiM28wZGth?=
 =?utf-8?B?cFUrNVUxWnU1a2x1bm9VeVNJd041cXlpeFllVHBvczhNZlBkZ2U1WktyVlNQ?=
 =?utf-8?B?UG96RmpnVHN6cUI5Z1Q2SElRNUlXVTd4REM4TEpQUHNlYUJhNkUrbmZPVXk0?=
 =?utf-8?B?SWw1THQ0dzhFNkxVK3UyVjNuek5Ba01BcEJoUGlzSVp5MC9kNGVPZnFlVXJH?=
 =?utf-8?B?M3QvazQzRDRHVjZ2aHpCbmRkZHFMSEFXOXVSNEpjTTdhQXJTc1VUNzdxU25I?=
 =?utf-8?B?QjQreXdnNmUwRVJrMEhlenhmcGM2S0JGN29kRE4rTlpHVW9Rc0x5a1FOblVI?=
 =?utf-8?B?TFVyU2dDbkdIS2hJOVZDMzdiQXpnTys5K0EwdDNwUEkwd2ZZU2FQbUtMWFVy?=
 =?utf-8?B?TVFTSTA4WkJrV2xaVzkrdTFURFRLZ2g2THFDb0lLVVVJYUkxTkNKdnMwako3?=
 =?utf-8?B?WWhnSk5nYytTZGw1KzVmaU1SK0tOQTNNdWJSY2ptbnpzalY1cUs3endVZXd2?=
 =?utf-8?B?KzhMR29HdWlsTGVURnJoUXh6dU5KK0p5Sm1HNCtNSWEzNVZjNklZYTVwT1ox?=
 =?utf-8?B?QmVHaW5zK25lNmZyUlFiTWp5YVN5YlJucStOSUc4UGc0UmFoOFpueTZsQUkx?=
 =?utf-8?B?R1pSUlUxaVRZNnFYcCtlajZwdU90QWtycTQ2eXZCYmdYSFc5Y0dKbWpoOHUw?=
 =?utf-8?B?Z0prdDFGM3Yvb3AwN1FvanE0eWRqZkoxWFJiQ2JHNGtUOVpGRTRVQzZwaDlk?=
 =?utf-8?B?MnRoQ3RKdUtyRTFXcEROMEk1d3NRSDU3dDNUQ2xFVjJEeGFXVjhDU05HaUhT?=
 =?utf-8?B?OEJUUy9SWG1NTUJTN2d4N0hha1M5aW9UMmpTSWRNekZVWHd2dmFVdWxNOUNa?=
 =?utf-8?B?NkhvVjdnZFhjN0I4MFF0cVVpd2Z2c3B5UjlSU2NBRUx6ZGNxUVlMd012Nnk4?=
 =?utf-8?B?TXROVnNocERGMlZKSGlXNWNsazZ6UVJnTVB5djkzR1N1My82Zzl5K3N3N0JM?=
 =?utf-8?B?VjNaSk9zRVJZSTFETEdNT2xIdXlaTGNPV1VhMU5WWjArNXNEOW9ZMENXSjZI?=
 =?utf-8?B?RWhzajBhRWJjS01hWE04b3ZldDBDVHJ6YnJIRGE0Qlk3RDhZZkdwRkpsYUtH?=
 =?utf-8?B?ZUt0RHMzMHhJV29xaGhiRUVvVkcvY2VWTmhOb05GdUVvR21qODlPOW92UGNR?=
 =?utf-8?B?eUk4SUpsR3pDRDhZU2JpcjVNSTVpK20vUVJxU09SM0VFV0pZVDg0VG1zQmtW?=
 =?utf-8?B?TFJ3TzJNOEhnU0wzUmYrenFBV2tnTHFnVUg1VTl4V0RWNmsvWThUSmpMOFhX?=
 =?utf-8?B?dkgveEw4MWM2SHRLUXZnVExvN28rcEovdlZJRjZ4OFE5bzBRT0Qvek8xVTdk?=
 =?utf-8?B?dUJ6cTRmckI3VFBQbEFMQ3BOWGhkUDFBOENqYmY2MnJQUm5GUDVWNTJ5Lyti?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5C923549DB12F4E80ACF8393803B0AC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bfdf011-c087-40ab-0187-08de0c600bc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2025 02:59:38.6726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0XspZw9gLRS+gSYbI0JmyczPfjCu6jSaON04CkDtdpvdoICYbFvkah1WkABHOmw9adetP1PkbAhCvhz9taS9NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7863

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDE3OjEwICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6Cj4gK8KgIHJlc2V0czoKPiArwqDCoMKgIG1heEl0ZW1zOiAzCj4gKwo+ICvCoCByZXNldC1u
YW1lczoKPiArwqDCoMKgIG1heEl0ZW1zOiAzCj4gKwoKSGksIE5pY29sYXMsCgpUaGUgbWF4aW11
bSB2YWx1ZSBzaG91bGQgYmUgNCwgYXMgdGhlcmUgbWF5IGJlIGFuIG1waHlfcmVzZXQuCkZvciBy
ZWZlcmVuY2UsIHBsZWFzZSBzZWU6Cmh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y2
LjE3LjEvc291cmNlL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMjTDIxMQoKPiAKPiAr
wqDCoMKgwqDCoMKgwqAgcmVzZXQtbmFtZXM6Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoCBpdGVtczoK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtIGNvbnN0OiB1bmlwcm9fcnN0Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgLSBjb25zdDogY3J5cHRvX3JzdAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIC0gY29uc3Q6IGhjaV9yc3QKPiAKCkFkZCBtcGh5X3Jlc2V0IHRvby4KCgpUaGFua3MKUGV0
ZXIK
