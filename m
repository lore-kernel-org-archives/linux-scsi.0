Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AB3313E37;
	Fri, 17 Oct 2025 06:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760684091; cv=fail; b=QeBVg0Xn32OLkoYvkO2KUfFNpdYOMKq4t/zSW7BJKstmOff7mnCgZi8y2Y1h2LIqs2Sz+zgU1/aadKLzyOp31vfDYc8HKQakVy37EdsAkHzJZ4v9OxRd/cEu65e4J7m6wepBVen+Z37yzO72pBwCFqu+9a3MP/qPQG+aChxvgb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760684091; c=relaxed/simple;
	bh=Lh98faW4ijvd91N6IMSdRhI9IuqOdiR8KBO0GXguuwc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A/Bx8ExhXcco7EwgKXSOR1VepCwF70S3+21lbQWz0AdsTbbLWlZvt9uYCBcca8CyAGAh7VisayHOEOPDmPsda5miFWko0+3uhxeWtPL0igj3v7/QQOOlIiOzY1sEiRMLyNuGCtl12TOFDUSABjSBlN6gC1WqMJtg4jS5eIopkiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aQ5WFb7R; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=i+pfDTra; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aQ5WFb7R";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="i+pfDTra"
X-UUID: 29a898d6ab2611f0ae1e63ff8927bad3-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Lh98faW4ijvd91N6IMSdRhI9IuqOdiR8KBO0GXguuwc=;
	b=aQ5WFb7R0ABwb98ZCZETeKAzb1bTJUXU/zGs7C9m/RR6ebYqRCWHOAom4ty5cP3CukOHHU2Wd8SK6ZvWznIGyanZnj0nHBIDhhoZeWQjGyDmSpUaVxAc3zqolci8qg35AV1ZWOzPVHeBUg5KwCfBjyUHmKEqbTQ27Dg52+7L6to=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:7be95a77-33c5-495e-abba-45c2bd42c4b9,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:6e7945b9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 29a898d6ab2611f0ae1e63ff8927bad3-20251017
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 71191834; Fri, 17 Oct 2025 14:54:44 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 17 Oct 2025 14:54:41 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 14:54:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uPM50AMCEAl16927ZzVL9eMBEd8uxyXcFgCQCWMeem9TGxiDPnK8vCCV0D1SHbmvRhMmJPuwZtkAdGqZoKm5uZcPZwuTVyok37QDIkMcdUxqnBT+xLcQ1VsoEBayf+kX+zbtKZPtcM1/qSoRJhYMzZ8tdKc1V8nYEkelYwiQdhuthbv053wJ6kbX3vA9JiMjFeNfVlRFoSzFIwqrhnlWgAT/FfuE5rCBBkMZoxzbsMuNdfnSOhDwpYnwOG4Ty4F52M1i+ew/LtPB4NHqdDNMZ6hgdIswUkmnIfK1AlP/1wsLXpS3+E+YdiGv9l39hMtfLXbYr3p8jEMvKQ2I4moOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lh98faW4ijvd91N6IMSdRhI9IuqOdiR8KBO0GXguuwc=;
 b=gXeVG5UNnyQwkZ+pCffHKThOKO/oyBX73u++ncQgq8/wQjCj5WyqLfwXGZwLwk8dwnRI6fszfsaYgZMz4i0R2z+BU+wqgcDN7Tns6jeaZvRkpWfLFbb59w5U3gTXW+Oe8YFXPVFXQE2XZPzmIFH1coyW6I9gW0KGIXVOFgUPpcujj+H7Q8BazFLuX8ME96YrfGb+cwgU06GZt/LoZy/4t9WlQ6S8rNiUjq9/PjsCcjrC/C/6zl1QXEKNKqjnX0s3CUpuIolb1wY8j6pM+J5oDMtoCugN1bGiYdcauCcF4Vd2l1IcVaLEEUvyaBtx1cGnzYX+xEHZU0cyJqEQvShZXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lh98faW4ijvd91N6IMSdRhI9IuqOdiR8KBO0GXguuwc=;
 b=i+pfDTraI0DOMkkMr5vULRBCIZnQ6gn+zEOCmaKdyuqI4g8FysJ4WXZiaB+kwx0GsI3RFOAhafCe1AxhL1W9rPlPYEtQiVwCyDhee7Ra3PnyYfxAUkcEI2zGZjOePCS0coxrkw5L4T5ctWrMrCegWsX+a+IYH0sll1P7LC1Edds=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9367.apcprd03.prod.outlook.com (2603:1096:405:2b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 06:54:39 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 06:54:39 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>, "nicolas.frattaroli@collabora.com"
	<nicolas.frattaroli@collabora.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v2 5/5] scsi: ufs: mediatek: Rework resets
Thread-Topic: [PATCH v2 5/5] scsi: ufs: mediatek: Rework resets
Thread-Index: AQHcPpWiaZJm0hO0l0KbuCcqhtldKrTF6KMA
Date: Fri, 17 Oct 2025 06:54:39 +0000
Message-ID: <39d226092adbe77eae0648b675b2ad62f8e3bc57.camel@mediatek.com>
References: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
	 <20251016-mt8196-ufs-v2-5-c373834c4e7a@collabora.com>
In-Reply-To: <20251016-mt8196-ufs-v2-5-c373834c4e7a@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9367:EE_
x-ms-office365-filtering-correlation-id: ca5900ff-c771-4ebf-c1d4-08de0d4a0adc
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?RU5HeGNHcGFHbXdsL0lDSnJXa2ZXOUtUY3JmNW5FM0d2RnJUbzlWTFc4NlJH?=
 =?utf-8?B?ZW04ODZzd09MNlllVGZ1LzYrNWVFeDRmbG9aMTdjanpuYUhhTmlxZnlKZW9E?=
 =?utf-8?B?M1NqVFFMSnB0RGpYTzMrVmtOcy9sOHdEdnUzWjdiNlRnQmE3dnBoRHhPWGxa?=
 =?utf-8?B?M2tqenlvSGpSVjJnSzVibDVqUjFpM1lFSDhKSlJYZEwwYm16UzlBWE5MdzZD?=
 =?utf-8?B?QlVDZ0lEQUtoT2RJUnd3NnFZTHJBYk8xYjFXckM4cnZyK1g0L0NwOXVJWlRq?=
 =?utf-8?B?S1FlOUN2RHVEbXVkNHVmMllveUVUdEovdWpCWUYzWHFlYWd2S2tYWUc0empl?=
 =?utf-8?B?eXhLVXMzNkpQRlBNWTdrTTBHS3p6MlV5UzFqNjlGWUtWSXRGa3VZWlBOdXll?=
 =?utf-8?B?bmlsUkpPOENiekNPY0RDSjdzdlU3SEFxdWp1L0U4OFZMa2hDeml2QVNWRGs0?=
 =?utf-8?B?SkVIM0FqUUU2Sm00dkFXN2w0VjVSZWJwK0pCVkVZaUd4RkdiZXM1OGxRbGhX?=
 =?utf-8?B?WW1YaXVEZXVQeFR0T1BTQjRKS1FZYzcwcklUNGN4cEV5NkY1RnYwMzhvbnZM?=
 =?utf-8?B?enJkNWVmTURtSCs0aTZ3VTFZS3RlUXYvSlZwQlBjRlJxYlFWUEtsQjVOT3Ba?=
 =?utf-8?B?alZHcFZDWFl2dkxZSktNeWY2dFZiQVpUOFhFeGVBUTlaR3R1aDNwWm1pbjNT?=
 =?utf-8?B?ZVBhR2NIWUJmNWxIUlRDOXM1TFlKQk9VWUpaTnJxbTN2S0hBaHg0eG01amRt?=
 =?utf-8?B?VXdhY1MxWTNCaURHWk93NnJpMUx6SllnNDlQOW9mYjd6Q0VCL3pERUNEc0w3?=
 =?utf-8?B?RDh1NDFUNDZnQ1d4c1BNU2EveXczTjl2ektVcEFyNUFaMXRybFBYTGhpTVVD?=
 =?utf-8?B?R3JzWlRuMlp5Ym9ldTV0cW1tZ21pa29jSDZTR0xaSWxTSldsR3l3c2QrSTVz?=
 =?utf-8?B?VWZrZm1tOGhwb2hRd3RMc21DQnV0dUhWczd1TUwvUmMxVzBQRXJjYjc4L3h0?=
 =?utf-8?B?YWVmaGdYZHdjR0M5ZDRuWk1uSXJkYU1YaHdPRVhmOGdvQXkxNXN4dnBSWk5D?=
 =?utf-8?B?WGpIUTZxVHZrT21paTRDQjFLdTBLWDR5ZHJ3dFBaZkVxV3JjcDMyaEo3ZzU1?=
 =?utf-8?B?ai9IVFZsOVMxNm4yVVJoWlZTZVZQQk0rK1NBMkVFWDVFTmxUbE84dGxJYW93?=
 =?utf-8?B?Nml0UU1jSThaT3RnRlA1NUVnVmdqYVNnUDZkMGp6aFFSanhra1dNNk1NWHhl?=
 =?utf-8?B?eDJDLytiVTdQako0NnhnS1RxQnJ4UTh4ZGVPYUFDOVJHdHFNaW5tZVpRYjJt?=
 =?utf-8?B?WDBXUmdZNTFvQk1tRExpTkFhNDJpRzBCYTM3S0p6TXp3c0JTY1hxWStJUU5x?=
 =?utf-8?B?dnE4ZHI4ejJFaDlhanBuM0NOeEVFL1l4MkFEaUx1OG5rMElVZEFDV2hrL2k3?=
 =?utf-8?B?OU13UVdhS2p4ejBLZ015T0FsSVJBbUMwWWdUTm83bzBOMlJ0ejBNSm5QQVM4?=
 =?utf-8?B?L1BwdTlYYmZKR3psYUhlN2RCbGtaaExyc1M3dGgxR1ZhOHY1WjFmNndEWVFw?=
 =?utf-8?B?d3ppT3BpeGNIR1hPUCt5MTNFbXN3d21GcEpvOVc4dWRlNHQ0Q0pHRlZiVGNV?=
 =?utf-8?B?WUxpS092eG1qYVROdHFzQktDdGZqNXp5K1dmMSsybzJyU2JZN3Jrekg1VkNh?=
 =?utf-8?B?b256WTY2RlBsbERJL1Q2Wnc2Sk1jd1BlNU9DSS8yYSt2T0h1eC9COEgzUGpY?=
 =?utf-8?B?MkgyNTRsVmprVzE0WmxZdXNuQnQwVGVuc0o3c3pNdjFpczFEM0pvMXltQk4w?=
 =?utf-8?B?dGtnNHFmdEZ6d2FSOXVvcUMzdnV6bXhQallxQUhKbjZGYkp4SnlMVWRWa0x2?=
 =?utf-8?B?Y21TeWZJbzZDa1RzTEhBVnh3Q1V4Wjd5cUZ5YlFxWC9MNU5KQ1JydFZBRHpY?=
 =?utf-8?B?VjZONTVXVHJvRUIzWlpPSHJRdmdScnUrMHJGcmFSM1o4RFRlYTdKcjN5N3I4?=
 =?utf-8?B?LytZNzVUZmloZFdYb1B0b2dONVBDb3I3Y1NyWmRGbEQ3U3p6bmJJb01Qayt4?=
 =?utf-8?B?TTFCbjBJcXMzdnIvV0J4OEpCRHpTUnVwclBTUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlNPYTZmcS9MR0lkSzI5ZlVkRnFhV2NwekxPN0FSa2VlV3p0N2NNOGFMWndv?=
 =?utf-8?B?aktUUzZmTmhoZFZHcFZDRmVhYWRmOGdoUzZ5RTdycElNVnJRVzFvdmhTdlRj?=
 =?utf-8?B?ZW9vdHlyL3FFYXE3WDh6Y1AxcWdoWnhtcm1zbURPUTBhMThXeXIrcXlkblNm?=
 =?utf-8?B?VXFxcExBODZ3QUEybEV1R3lDWDlpc2phYlBrQUpCVUFDaDJHS0VBWHlzT2JY?=
 =?utf-8?B?TTAzYnd3a2VOSjhNTS9qZmRYY0xMdFZZT1lpU1BnUEl5TUJ6bGNVUTlXNHMx?=
 =?utf-8?B?WG9UR1laVUluaTNQNnY2RDk1Y2c3RS9wb09nQTgrT2djbnBFcDMvbWtWSkN4?=
 =?utf-8?B?VmRPUUhuQ3NMaHBiUTl4VmZtUCt2VjBjUC9reSsxcldwZjVZYnArZTdTVVZE?=
 =?utf-8?B?TXdLR1ZQcCtzRDkzWmVjdUZ0WVJxbWlKL3F0NlgwcnROTUNZcXN2L2pCNStB?=
 =?utf-8?B?OHZhV2ErOVZ5WnFxWWg3Rk5NcmZyTTE5dkhvOGV0SHVNaFF1SDBDZ2UybGRZ?=
 =?utf-8?B?RjVaRjlxOENSMkZTOTgyZ1pTbW81eDdjR2haeE9GRXNmR0x2VVhTNFphOUls?=
 =?utf-8?B?c283ZXMwUXdMU3pWeXNkaUJBa0xSdFo1S3dBM3Zsdnd1VUlDYWhnenJpZUhz?=
 =?utf-8?B?b1hvYXI2c293MWQvTnlCR0hnVW9PdmpCUzlZbWRONmFka1pYZmtVc3dQeFd6?=
 =?utf-8?B?YStlckV0bmRhb09PRXorTG5lTWI5MDJZRzc2ZndmWnlET0lNc213OURTbUpB?=
 =?utf-8?B?ZEU4R29aK1VhUjc2NGR5SkR3WHkwLy90UnpRUnhZN1Z0eDFyVG5mNXdFSnV3?=
 =?utf-8?B?L29EYnpqbGFadjFscEtrUW92TW9tV1dZUm5UVTdWYzhMbzh6ZFNwLzJnSitk?=
 =?utf-8?B?M0NTazZZZDZjdkNrdlh0WUVoaDZBQXZodUhBS3FEdUUyWXpvNDh1VlJNb0tY?=
 =?utf-8?B?RE5kMWVIM2tZM3lLeDlCakx3YUVCM0k1VlRXMTZMdk05dmNrVmlUbktzcU9C?=
 =?utf-8?B?eHdWWmRRaW9RSmFBMnduRkNUTDBhbnRnVHZmNlJZQWJ6OGw2SVRwRi8wQ2tl?=
 =?utf-8?B?SEExVzgwM0N4YjcwcFlGdUlCeldJM3VEQm9sK3N5TzYwbTZRRTRwTFFyMkpH?=
 =?utf-8?B?RW9kZDQwM2ZHZ0hzY3diQ0prT0c1b3pWYlluVGNySklwampudzlQeTVoNnFF?=
 =?utf-8?B?QmdKUFU1NSt1NDFaSk9FRXhvMWpuenRicjNlMXVjdk9mb2FPUDVtYnRBNS9K?=
 =?utf-8?B?eGZ0WnVMVnNhOEZRWCtuU2ErYllpVUNUOWlDMzV6M05HOTBiTEplLzJWUXk5?=
 =?utf-8?B?SStkZ0FoQldSRDRKUlp1dStLUU5oVXI4ZjJ5QzBjdGgrNFlocmZLckt1K09M?=
 =?utf-8?B?NmhhMkdTYk5NL1RUMWFuWDE5SWl6eDlOZWhKZmY3Q0VIdCtvTmVuQVpCNmc3?=
 =?utf-8?B?aTVTOExzUFRmUzdkaDV2SGVpZ3ptd1NRcXg0YnpNcjJLZFlwdytzakRUTHBp?=
 =?utf-8?B?MlVXMnlzcVc4L09BcGlvT1dYbmNQcDdVNXBWdllRWXZPNzBFeXY1TzlaV1BO?=
 =?utf-8?B?RGtRajg1ZzI3NE42cUdpMGR6RTRaam80Uyt4VVRpdWxLM2pUM3M1UGJDRU9m?=
 =?utf-8?B?dERRU3pXSkYwTlRROEp5OHcrMEYwR0hBdnRnTHoyYXZaREhyTnlGemNuS3Rx?=
 =?utf-8?B?RDE1OVcvZzB1ZHFCbEp0RkUzUDNVSWxwT2JsTGMyem0rM0FxS2NGZXY1Vmp0?=
 =?utf-8?B?TitMQ011cWtibEpEVUdxVjR1bFlOd09zWUhOVkVvVDlSMDNoQmtqejZSWENy?=
 =?utf-8?B?VFhua2U5Y0lCR0VJVklOOExZZGp6V1VqZ0VHVTFTOUhQaU83UzNSNmFiUTdx?=
 =?utf-8?B?V2dxVkRpVWw0d1VrR2liM1NNOXk3WGoyR01tWFU0SlJ0eFBVUE5WaDBrMUo0?=
 =?utf-8?B?SWhaeW04bFFNU3p6dVo0VWFuc0J4YjdGR0owTjNreG9uWHB3Ymp4a1pMUllP?=
 =?utf-8?B?YUxEZFdvRG95bzc0dWpOeXRDMmR2QmpTRVpEU0l6dCt1S1lDZmRTUDdCdWtt?=
 =?utf-8?B?dkkxcHhkVis5Wm4xYmFQSVJSRzd2bVE5eFRRQVNuVDhzT21mL09mSXhPZlVo?=
 =?utf-8?B?ZDJoenFWQmxidjlrR2hpUGlZRmdwcm9xRmVoZnlLT2VJVDV1RWxMT0pHWVdQ?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D8000FBA5E1B845BE32E1AB48EE4E1D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5900ff-c771-4ebf-c1d4-08de0d4a0adc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 06:54:39.4058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KCRSzMj0TlIVFCTj4QObuuouHWGXDdwaYTpFyPD4kho/UWkTRxk2Dc7WnEWt9r47AOguposIxNW1boy8pOnl5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9367

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE0OjA2ICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFJld29yayB0aGUgcmVzZXQgY29udHJvbCBnZXR0aW5nIGluIHRoZSBkcml2ZXIncyBw
cm9iZSBmdW5jdGlvbiB0bw0KPiB1c2UNCj4gdGhlIGJ1bGsgcmVzZXQgQVBJcy4gVXNlIHRoZSBv
cHRpb25hbCB2YXJpYW50IGluc3RlYWQgb2YgZGVmYXVsdGluZw0KPiB0bw0KPiBOVUxMIGlmIHRo
ZSByZXNldHMgZmFpbCwgc28gdGhhdCBhYnNlbnQgcmVzZXRzIGNhbiBiZSBkaXN0aW5ndWlzaGVk
DQo+IGZyb20NCj4gZXJyb25lb3VzIHJlc2V0cy4NCj4gDQo+IEFsc28gbW92ZSBhbGwgcmVtbmFu
dHMgb2YgdGhlIE1QSFkgcmVzZXQgZXZlciBoYXZpbmcgbGl2ZWQgaW4gdGhpcw0KPiBkcml2ZXIu
DQo+IA0KPiBSZXZpZXdlZC1ieTogQW5nZWxvR2lvYWNjaGlubyBEZWwgUmVnbm8NCj4gPGFuZ2Vs
b2dpb2FjY2hpbm8uZGVscmVnbm9AY29sbGFib3JhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTmlj
b2xhcyBGcmF0dGFyb2xpIDxuaWNvbGFzLmZyYXR0YXJvbGlAY29sbGFib3JhLmNvbT4NCj4gLS0t
DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
DQo=
