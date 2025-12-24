Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EDF1FBC92;
	Wed, 24 Dec 2025 05:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766554510; cv=fail; b=OtdZeMnQI9WKVMPoPbz5RiOsFCyNSon2Cfml78cSo+FzJeLifvNahCnWXbFfeh/oN+VP9wXMyCt3T/XznlZSkFBK81sNwOdexE3O56yzuiD+0ry1bfIkabDh8AdFMHHMDYoIIIYQMNke8OUIGCkoZVBk8FZ1+2QZAJIFAzhQopA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766554510; c=relaxed/simple;
	bh=+cL2jlrgKAc486lZ+xizjeL12oVj9NaRm7LOyY7U85g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uxx9oTKHmGhn9AfDg60PzytrPGBf0pxTrTqgestXrv1/QJTEAAkc/27YPiX77vrmCdfgluYy6bWN/u1848FQ+xgn+evEmVRud0kpA/5/5qTfBu5P0b94/O8361i+WDyk76w7i05KqbiGSzhMQBI//P3m3skFd7vHyGopNC+x9JM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VHegn5CP; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=mRTC/AF6; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VHegn5CP";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="mRTC/AF6"
X-UUID: 4c3d1162e08a11f08a742f2735aaa5e5-20251224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+cL2jlrgKAc486lZ+xizjeL12oVj9NaRm7LOyY7U85g=;
	b=VHegn5CPbJ6MjvQ4Z4M3HOhV1zo6k1XFAVBugiW9eOKqoiJeEycXIkc9DNIEnLKWYY9vYgQWYwPVt4iO82S+dHu2NqhiWBlELU3j5TwG7kDhx3rRgCSAEdbSo2JasRUHLvy+UcT5ZKwX6ZnGzcRuauG7JFcvZo1MLIQJxLMbmqE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:6aec2621-639f-4040-8438-eb6824ee907a,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:3d3789aa-6421-45b1-b8b8-e73e3dc9a90f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4c3d1162e08a11f08a742f2735aaa5e5-20251224
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2143373538; Wed, 24 Dec 2025 13:35:03 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 24 Dec 2025 13:35:02 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 24 Dec 2025 13:35:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rby0ootffIe890xkt4cWOmyKqXnvIJZc1uz885HdIqe8PMOge+0xqIW9CU/Yw2uvcXt3YPZz0+4/W2sjWgV74r0peQ3p7GiWqkUV5pIOZJrxn/B0UdkN66mCXcDrtJWOwhlwEWJqIu3p9wgldEipl7PC1EfPcmbHD208FbR5pb1u01NEuewQJESI5Jd0h6UJ+dsGjgoc/OnodO31jcCxxOTQO/pKCVU59MQee05kes6YR7saRJVF+wmIaVC8vlpR0KjNM5oDcPfQ67YTMfjGSL0B12hoUI6zX1Jt8/UYFiNf2xuzCK1Ymu3Oyy8mhJiGWcfpCGWDEYrO6gXNd+iczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cL2jlrgKAc486lZ+xizjeL12oVj9NaRm7LOyY7U85g=;
 b=T/UOnD4sR3k5rsPg0VXz8eNeEpFgKXmxn+QlEduASCT+AW5/DByNRK60XKvWYNQmA+CdNFFRygUZSJrOoNMGDHHG8VW6EYHfmXX3IPZS6/ixlZD3lJw/EVq1joaWzn/x2fmT1d9wdjlO95VDG5Z7qKF4WiInxLtx1fWX0vHRlleo6F4YGsSitZL5WP0D13rVPBP7WZEqTppnBFo2axJkvFxTL7nop67Y7M3A8lNzbVEMPxXGXwaftv2r9MzYv6PwO6l67ORklGdYCKdX2Cyjn/uwD3pZTmt6h/hU3OSr93k4kuxKOqTHCQHNpdoIqRwFFV8g17iE1u8B07Xbb57gpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cL2jlrgKAc486lZ+xizjeL12oVj9NaRm7LOyY7U85g=;
 b=mRTC/AF6VeTiYCFxuJCZTrqgDTlsB37RU6sI6vswpRrtgzBNKPANDcwUT3pW0IZAI717zThrFXsD/XFMCCK9oM5ayFJZb+rR+nF+lOBk1L6/zyy0UQEXPEkCBHlci/n07G3TIKSVU+fxNfqkEX3H3A1l7b3/xZmbz8N5q5XlIew=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by TYSPR03MB8111.apcprd03.prod.outlook.com (2603:1096:400:476::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Wed, 24 Dec
 2025 05:34:58 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7%7]) with mapi id 15.20.9456.008; Wed, 24 Dec 2025
 05:34:58 +0000
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
Subject: Re: [PATCH v4 10/25] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Topic: [PATCH v4 10/25] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Index: AQHccB4EHZ+v/JV6aUy8RAqR9x0vDbUwTdkA
Date: Wed, 24 Dec 2025 05:34:58 +0000
Message-ID: <1671b55e55a61af655bbab7c1de264eb70383fc4.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-10-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-10-ddec7a369dd2@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|TYSPR03MB8111:EE_
x-ms-office365-filtering-correlation-id: d81511fa-c80e-4e78-842b-08de42ae2d74
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YVpqZ09LZXZaaHQ0N0hCdC9mR2FTYjFoUEI3MHZkaEdnbTBVVk5YOXJtYjAr?=
 =?utf-8?B?OWExU2tGVTFCNE9zT25ONllTS09Ea2pDTXVHQm5SS0hXNmh1K3J5NGNEc0NC?=
 =?utf-8?B?c3ZVYTdoTmtWSm02QWNmckVhenZNVVRqM3NyRGxpS2xPVm5EWk5mYWhrUWxP?=
 =?utf-8?B?NE1yRFg5dGIrbUNFaU0zM0t2ek9Ja1M1a3NGY2dBUHFpblNVd1VIdllQYkZN?=
 =?utf-8?B?bCt6NnljWTgrOXhkd2ZVS216RXdJVnJ2QU4vaGIyRjlDVlRlSGRlcGRNVWw0?=
 =?utf-8?B?Mm84cFFpRUdVODRVMS9zWUp1RWxCWnRnaTUwWko0dkU2U3hLazZvTTFXRnNZ?=
 =?utf-8?B?VjNmMWV6RDNJUTlJOEE2MFJGV1ZkWHQ2cTVOVDVnNUxodFVrdFNGTXhWWDRl?=
 =?utf-8?B?TFZIV3VwNTVlbXpvTE9oNlpjNG5DWUw0QTEyZ0hPeU91QkxySURacVlZS2tQ?=
 =?utf-8?B?emdKRFNoRytoZy9FT21xcURpd29GQ3JOc1d6VWtRUjIyVVpPbHB1VVk2cFNY?=
 =?utf-8?B?NW5rRDRMc2V6cGEwM1NvSTNvTDMyZVdzMDRGcjhhTExYWDBhcWNWaEJDRzJn?=
 =?utf-8?B?S2RUNHR6blpZNUQvOXdUNW9mWHcweHhZOE5UeVhkSHNodnltTm1BN3hXRmh2?=
 =?utf-8?B?UkJtVGJZcWF6YjR5ZjNzaUZQeXFtdjlCUHd4Z2ZUWnhaZU51UVc4b2JXUnB2?=
 =?utf-8?B?TXBvcWxuOW1maEc1QXE5YllOOXc4RGJaVzBZWmZHN3lQVXJqbHBsdyt1cXUw?=
 =?utf-8?B?V1kycFpkTlQ5cWtDWXRVUmx6ZlpsUGNPTkxjZ2d4aUxGZTdiNUwyREZ6S2JC?=
 =?utf-8?B?QlRoQlhvd3pORldhOU5HbFEwZ0ptbTg3SVBsWVYzb0piOHdyS3dtSElyS3Q3?=
 =?utf-8?B?UjJ2em5kYm5kcFN6TmVCckNSM0VjeXZ5S0xtYzFVUkNoR0tJS2tiTHJpSkd2?=
 =?utf-8?B?Z29IUWhOeUlKN3QzWnlHTzMxQnRxNmRoaFhUQVIyVm9JdjRrdWt5dXdROFMz?=
 =?utf-8?B?dUl4Wm5ENjAzRU5WY3JzQnpjYkhvTkZsZ0g0blBRRE9oM2d6TVpDby9GUmVT?=
 =?utf-8?B?K0lwb1J3SXNxYVN0TUorNDh2anlNVFhPMTZzSlpLQ0s2dHFLRklUUVRKYjJy?=
 =?utf-8?B?OHdTMzF4bWlCSnBOYUU2Q3ZTU1E2cE9BQVN5Yjl4MTNiWndoZHJ4d0laTDEw?=
 =?utf-8?B?UkxiRGxiUnNaakhnV0xLcUFseFhrMVBHcnp2Zm51RUd2dmMyNHk1ZGhCU3Va?=
 =?utf-8?B?UWhPNmI2SDl3d2l4Q2RXbWsxbnBLTjM3Nk1LY0J5WVFRU3R4TkhQWlp4TU5v?=
 =?utf-8?B?SmIyaVl0U0dqK0ppVlBLR2N1VXJtZWlQMi9sLzd0SWl3NGZ3aHdKVHJvcUFJ?=
 =?utf-8?B?Wjhhb3hyOExHQ0E4MGFVekZGUWxXK0dmYlgrZFNCVEZ4VVo4QVFCQVo4RmFs?=
 =?utf-8?B?T1Bjc1ExYmJsSzJRSnVOREVaT0lTRGV6VmkwYWZuclYrbnZRbGo3cmMyZ2ht?=
 =?utf-8?B?aEtRWnJjem9ablFYLzJ1eEVCMVBia1VhZGdsZWZ0R2NJRmVyRXlBdnBsSm95?=
 =?utf-8?B?NmRTSjJqRFZ0U2NYU1J1a1hkcWErUi9kZVI4eldHSENjZ2ZMWnlOVlRYZHAv?=
 =?utf-8?B?Qm1TbDdjR1BPUGFubVRIbys0VHc2NEQ3dUVMLzdtVEs3UU9MMzRucWNhRDNT?=
 =?utf-8?B?WHhvWEFGelcydmNyM0E3SWFhVExYNVFLdUgxZzdPLzBacjRpbWFwT2FqdGVG?=
 =?utf-8?B?N1RxMTA1cVdWM2F3SC9tR3JoMlUwbkNtdXpjeE1rdWRMV1MwQkhoMTMzR1JC?=
 =?utf-8?B?MC9zenFoSjI4eG1ZeWdZaDlNTU81Y25xOERMNmJIWXZ3TW04T21QbUVUa1px?=
 =?utf-8?B?SSt4a2hBQ3NpY0NRMkdhZDN2bDBUbWVXbEJHMUJYTDdxaGJtUGMrb2d6MmhW?=
 =?utf-8?B?c1NYMVhKNWRTU0FZd3JyUWszZG56MWpFSmxrR2hqUFIrWHljNEdSOU5KT09P?=
 =?utf-8?B?SFliWnRiVHVaS2hqK2xjSUhadFRPMVZzYTJiM3JBNnJveFExSDdXSUVQaFJa?=
 =?utf-8?B?UWJpUCtzS3M2QTZubURkbXhBWjJQdWtJOVRZZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alphcDQ4bVNQMmxhMFMzWHlBcVViaGpYRzE5dEM5TFJ5bHJkOHkxRGJxZy9w?=
 =?utf-8?B?cHo4NnpzbkRUdW9ENEE1WWZENm5uU1FjdDhZMkM4cUVnU3dHYjlYblQvVmNl?=
 =?utf-8?B?VkZpZWJFeHN4ZVRYRDVqUGg2MG15VXlPUUx0V3hTV2V4eUtiaWVnYVVRM1Rr?=
 =?utf-8?B?akhJMVZiV2VEMWlnTG4rQXBSalhEckhFL3QwS3BXTG5ncDMzbDJOY1RWRU1u?=
 =?utf-8?B?Y1NPdUpQbGhsdzZXTlQ2WlUzWW9pN3VUWExmWm5nTk1tc0gxME55WEVibXh6?=
 =?utf-8?B?cSszb1RSZWNuSGo4K3RkVTA1bnIxNTg3TU1KYmZaZURCYXdId0hmZHl3dUor?=
 =?utf-8?B?REJwR3hNTkdGZFJrZ0RxNjFNQzdiUzhUSHNSZWdEM3haaVVYOHFlOXFFbXFW?=
 =?utf-8?B?NmVwTHhBZDBteU9aS2t2M1pVYVhOVzdEOGZWeERVcVUrOFIzRWFHQTNRcjdS?=
 =?utf-8?B?dGg2RGNpei9nYUdRWEd6WmwzVkdaVit6alpsVzAxSFBBZGNneVlGa0dZOFF6?=
 =?utf-8?B?M2Q2cW4zWG5PSnl4SzlWQ28xZnVnUHlnVFMzZE5CczBtOEd3L09obG10YnBo?=
 =?utf-8?B?VmdOT2dBVEVya3JESkRGUkxid2hvdHRQV09FSXRhZVJpRjZpb1NZZ292R0c1?=
 =?utf-8?B?S1Vscm5mQjk5U3VYV2Zjb2pveFZZTW5hdTNTOGpkUVVHK3c1YlBrTzNZRTBh?=
 =?utf-8?B?clVOemZDc2J1MlBKYkhRdVpxUVZXQSttZDhQenR4Z0MveTRmbXZHUEEyTUtO?=
 =?utf-8?B?NTVaT0pWRXNmbUdBbE1BMGxhR2ZDTkE1WGd0ZUZ6NnhsUGlWL2tZMFNvclEx?=
 =?utf-8?B?YlIwdnBGT3BYWlZ1Mmlaa1pVK3Y0T2xGdTJVMndnNURlTUhtQ1lrdzMrZ1FX?=
 =?utf-8?B?a0FkaFRzdDY1YTZFNXVjZXVSOFQ0TndSd2MweGl0bS83STBjOWtFbzkwYkJq?=
 =?utf-8?B?VndwM2ZKK1g2ZGlHWEZFRFh6Qkpvem9zeXFmLzZiYU9hTkk5c004clhaM0Y4?=
 =?utf-8?B?eDRldlgxVVlIWE5jYnNjSVJ6VEc5L0RodUdYMTJoYklWdFFGVTJXLzFmb2pN?=
 =?utf-8?B?MERFZ0JhRXFUYUg3UVpJVk5Mb2JnRHhHRVNIZUxrelVRbjVBSURPelNjMlA5?=
 =?utf-8?B?R3ZkYjVLMk1UZU1SNklGMk8yNGNtQ1Uyb3F1SkZEeGs2aTViVFhGVUhNSHhV?=
 =?utf-8?B?MEtRdGplQXI0TWUyZm8zdE0yL0U2NkxjYkk1QWhoa2JmMzgyd3ZBZEwrTUtN?=
 =?utf-8?B?Z0hrUlh5c0hhVTBrQUVrUXNJVlJPTHE4YnBQNVI4VXdlV0dseUpUWDlROUYz?=
 =?utf-8?B?eEJvQ292TW83UU9neVA4cGZnV0Z2SS9wR0NzbHJBK0hXM0Y1bEZTL3ZTTThw?=
 =?utf-8?B?UEVDSldwYW9WU2ZkSk1VR3kwUWRTb2tLVVZXVWg5UUNuNnNmLzdzazdpNW5I?=
 =?utf-8?B?NG4vR3JreUVqU2hXb0Y1Z08yNEQ3T1VCMEk3RWZOamJrMUtOVkVqUUEzVm9C?=
 =?utf-8?B?VUpiVVdpZ3dUM2N4eWNaRmwyY1JYR0FrMmphOEtrVXZSZHRLeXd0YVNlR3hx?=
 =?utf-8?B?SkxMVFpPN1BIWi9PMk13d1RHMkdqUlFnajdoNnV6T3EwRkw5bUduL01wN01z?=
 =?utf-8?B?bGhNYlN0b2t6YUkzU1h4WXhqeUVJUTQwcGlxNUhVb2RJUkVvYnJOQVNXMEU2?=
 =?utf-8?B?UTMrdmFGVW80Vis1ZW1PU3RwTWJQOHNmUy9vVUhrT0V6VFYwcG83SHplMnZu?=
 =?utf-8?B?WVBFSFhreGVWbjZJeE5sQnRRZkpSZFhiL0puYXh3QmlrVjdTUkg4a2hvcE9J?=
 =?utf-8?B?OHpkalU0WFFvN0FQZHptN3k1STdxM3F2bDdmN2NPdjFUbTNLRFZ6bytSQUph?=
 =?utf-8?B?c3BLZHV2NjJ6Nk5zSGxKbVBkdXJCd3BDSTFtVDVudnJUb0YxNWNKdkN4NFRT?=
 =?utf-8?B?dlFBNm1LSitkdGxFQlBCWEYxSURqYldTWWNWd3lHNjBsTUI2Z1lXQ2NvRTd2?=
 =?utf-8?B?MWVVWmNhNXhQaG9VOVJkdzZ0TXM1alp5eTBZNXpMelNHRDR1VkpnaHMyRmF5?=
 =?utf-8?B?YzBNaDdZYmE1cHNGamtWNmtmUWhUUWJDeWc4ZkxlQXNUaG5WQjdRc0VYK2ov?=
 =?utf-8?B?aEY2VmF5cmlXb3d6ckFlNW5zOG9pNFVubnp3eTBJSDVjcnhTRE80WVQ0SEZG?=
 =?utf-8?B?K3Z1Q1Z0Q1pYT0JoakJYeFpDU0ZLWXpseTRBRy9oY0lWSUN3bGduU1l1a21M?=
 =?utf-8?B?SXN0QlJSZkpSdzRqaWRzWVVFNHNKcXRwV1dpUGZ2MzF3a0RsRkFXUEJES2NW?=
 =?utf-8?B?Y1V6aTRUaGViOUx6MEFNdEFtUG91Nm9KWTB0Yk1pZ3g4WVo4R200QXJuYmFN?=
 =?utf-8?Q?uXyPuLyzSWIE8fJk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0946BFCFFF4B7468D02C6094188C28E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d81511fa-c80e-4e78-842b-08de42ae2d74
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2025 05:34:58.7198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k/U+nvXdSooQp0RTpl48Llu+AQebZaI/tPviukusL4v8uPMD5BN6xNAQMqxmHAn1IXtuYpXnbl3sgEp0IpxPS/7mwZPErG3tGtbAbRre0JY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8111

T24gVGh1LCAyMDI1LTEyLTE4IGF0IDEzOjU1ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhl
IGNvbnRlbnQuDQo+IA0KPiANCj4gTWVkaWFUZWsgU29DcyBoYW5kbGVkIGJ5IHRoaXMgZHJpdmVy
IGNvbnRhaW4gYSBwZXItU29DIHNwZWNpZmljIHNldA0KPiBvZg0KPiBtaXNjZWxsYW5lb3VzIHN1
cHBsaWVzLiBUaGVzZSBmZWVkIHBhcnRzIG9mIHRoZSBVRlMgY29udHJvbGxlcg0KPiBzaWxpY29u
DQo+IGluc2lkZSB0aGUgU29DLCBhcyBvcHBvc2VkIHRvIHRoZSBVRlMgY2FyZC4NCj4gDQo+IEFk
ZCB0aGUgbmVjZXNzYXJ5IGRyaXZlciBjb2RlIHRvIGFjcXVpcmUgdGhlc2Ugc3VwcGxpZXMgdXNp
bmcgdGhlDQo+IHJlZ3VsYXRvciBidWxrIEFQSSwgYW5kIGRpc2FibGUvZW5hYmxlIHRoZW0gZHVy
aW5nIHN1c3BlbmQvcmVzdW1lLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTmljb2xhcyBGcmF0dGFy
b2xpIDxuaWNvbGFzLmZyYXR0YXJvbGlAY29sbGFib3JhLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJz
L3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIHwgNjENCj4gKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLS0NCj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmggfCAg
MiArKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA1OSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgYi9k
cml2ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiBpbmRleCA5YzBhYzcyZDZlNDMu
LjEwZDZiNjllOTFhNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWsuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+IEBAIC00MCw2
ICs0MCw4IEBAIHN0YXRpYyB2b2lkIF91ZnNfbXRrX2Nsa19zY2FsZShzdHJ1Y3QgdWZzX2hiYSAq
aGJhLA0KPiBib29sIHNjYWxlX3VwKTsNCj4gDQo+ICBzdHJ1Y3QgdWZzX210a19zb2NfZGF0YSB7
DQo+ICAgICAgICAgYm9vbCBoYXNfYXZkZDA5Ow0KPiArICAgICAgIHU4IG51bV9yZWdfbmFtZXM7
DQo+ICsgICAgICAgY29uc3QgY2hhciAqY29uc3QgKnJlZ19uYW1lczsNCj4gIH07DQo+IA0KPiAg
c3RhdGljIGNvbnN0IHN0cnVjdCB1ZnNfZGV2X3F1aXJrIHVmc19tdGtfZGV2X2ZpeHVwc1tdID0g
ew0KPiBAQCAtMTE5MCw4ICsxMTkyLDM3IEBAIHN0YXRpYyBpbnQgdWZzX210a19nZXRfc3VwcGxp
ZXMoc3RydWN0DQo+IHVmc19tdGtfaG9zdCAqaG9zdCkNCj4gIHsNCj4gICAgICAgICBzdHJ1Y3Qg
ZGV2aWNlICpkZXYgPSBob3N0LT5oYmEtPmRldjsNCj4gICAgICAgICBjb25zdCBzdHJ1Y3QgdWZz
X210a19zb2NfZGF0YSAqZGF0YSA9DQo+IG9mX2RldmljZV9nZXRfbWF0Y2hfZGF0YShkZXYpOw0K
PiArICAgICAgIGludCByZXQ7DQo+IA0KPiAtICAgICAgIGlmICghZGF0YSB8fCAhZGF0YS0+aGFz
X2F2ZGQwOSkNCj4gKyAgICAgICBpZiAoIWRhdGEpDQo+ICsgICAgICAgICAgICAgICByZXR1cm4g
MDsNCj4gKw0KPiArICAgICAgIGlmIChkYXRhLT5udW1fcmVnX25hbWVzKSB7DQo+ICsgICAgICAg
ICAgICAgICBob3N0LT5yZWdfbWlzYyA9IGRldm1fa2NhbGxvYyhkZXYsIGRhdGEtDQo+ID5udW1f
cmVnX25hbWVzLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgc2l6ZW9mKCpob3N0LQ0KPiA+cmVnX21pc2MpLCBHRlBfS0VSTkVMKTsNCj4gKyAgICAgICAg
ICAgICAgIGlmICghaG9zdC0+cmVnX21pc2MpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJl
dHVybiAtRU5PTUVNOw0KPiArDQo+ICsgICAgICAgICAgICAgICByZWd1bGF0b3JfYnVsa19zZXRf
c3VwcGx5X25hbWVzKGhvc3QtPnJlZ19taXNjLCBkYXRhLQ0KPiA+cmVnX25hbWVzLA0KPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkYXRhLT5udW1fcmVn
X25hbWVzKTsNCj4gKw0KPiArICAgICAgICAgICAgICAgcmV0ID0gZGV2bV9yZWd1bGF0b3JfYnVs
a19nZXQoZGV2LCBkYXRhLQ0KPiA+bnVtX3JlZ19uYW1lcywgaG9zdC0+cmVnX21pc2MpOw0KPiAr
ICAgICAgICAgICAgICAgaWYgKHJldCkgew0KPiArICAgICAgICAgICAgICAgICAgICAgICBkZXZf
ZXJyKGRldiwgIkZhaWxlZCB0byBnZXQgbWlzYyByZWd1bGF0b3JzOg0KPiAlcGVcbiIsIEVSUl9Q
VFIocmV0KSk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ICsgICAg
ICAgICAgICAgICB9DQo+ICsNCj4gKyAgICAgICAgICAgICAgIGhvc3QtPm51bV9yZWdfbWlzYyA9
IGRhdGEtPm51bV9yZWdfbmFtZXM7DQo+ICsNCj4gKyAgICAgICAgICAgICAgIHJldCA9IHJlZ3Vs
YXRvcl9idWxrX2VuYWJsZShob3N0LT5udW1fcmVnX21pc2MsIGhvc3QtDQo+ID5yZWdfbWlzYyk7
DQo+ICsgICAgICAgICAgICAgICBpZiAocmV0KSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAg
IGRldl9lcnIoZGV2LCAiRmFpbGVkIHRvIHR1cm4gb24gbWlzYw0KPiByZWd1bGF0b3JzOiAlcGVc
biIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRVJSX1BUUihyZXQpKTsNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gKyAgICAgICAgICAgICAgIH0N
Cj4gKyAgICAgICB9DQo+ICsNCj4gKyAgICAgICBpZiAoIWRhdGEtPmhhc19hdmRkMDkpDQo+ICAg
ICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gDQo+ICAgICAgICAgaG9zdC0+cmVnX2F2ZGQwOSA9
IGRldm1fcmVndWxhdG9yX2dldF9vcHRpb25hbChkZXYsDQo+ICJhdmRkMDkiKTsNCj4gQEAgLTE4
MzMsNyArMTg2NCw5IEBAIHN0YXRpYyBpbnQgdWZzX210a19zdXNwZW5kKHN0cnVjdCB1ZnNfaGJh
ICpoYmEsDQo+IGVudW0gdWZzX3BtX29wIHBtX29wLA0KPiAgICAgICAgICAgICAgICAgX3Vmc19t
dGtfY2xrX3NjYWxlKGhiYSwgZmFsc2UpOw0KPiAgICAgICAgIH0NCj4gDQo+IC0gICAgICAgcmV0
dXJuIDA7DQo+ICsgICAgICAgZXJyID0gcmVndWxhdG9yX2J1bGtfZGlzYWJsZShob3N0LT5udW1f
cmVnX21pc2MsIGhvc3QtDQo+ID5yZWdfbWlzYyk7DQo+ICsNCj4gKyAgICAgICByZXR1cm4gZXJy
Ow0KPiAgZmFpbDoNCj4gICAgICAgICAvKg0KPiAgICAgICAgICAqIFNldCBsaW5rIGFzIG9mZiBz
dGF0ZSBlbmZvcmNlZGx5IHRvIHRyaWdnZXINCj4gQEAgLTE4NTAsNiArMTg4MywxMCBAQCBzdGF0
aWMgaW50IHVmc19tdGtfcmVzdW1lKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+IGVudW0gdWZzX3Bt
X29wIHBtX29wKQ0KPiAgICAgICAgIHN0cnVjdCBhcm1fc21jY2NfcmVzIHJlczsNCj4gICAgICAg
ICBzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+
IA0KPiArICAgICAgIGVyciA9IHJlZ3VsYXRvcl9idWxrX2VuYWJsZShob3N0LT5udW1fcmVnX21p
c2MsIGhvc3QtDQo+ID5yZWdfbWlzYyk7DQo+ICsgICAgICAgaWYgKGVycikNCj4gKyAgICAgICAg
ICAgICAgIHJldHVybiBlcnI7DQo+ICsNCj4gICAgICAgICBpZiAoaGJhLT51ZnNoY2Rfc3RhdGUg
IT0gVUZTSENEX1NUQVRFX09QRVJBVElPTkFMKQ0KPiAgICAgICAgICAgICAgICAgdWZzX210a19k
ZXZfdnJlZ19zZXRfbHBtKGhiYSwgZmFsc2UpOw0KPiANCj4gQEAgLTIzMzMsMTQgKzIzNzAsMzAg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzDQo+IHVmc19oYmFfbXRr
X3ZvcHMgPSB7DQo+ICAgICAgICAgLmNvbmZpZ19zY3NpX2RldiAgICAgPSB1ZnNfbXRrX2NvbmZp
Z19zY3NpX2RldiwNCj4gIH07DQo+IA0KPiArc3RhdGljIGNvbnN0IGNoYXIgKmNvbnN0IHVmc19t
dGtfcmVnc19hdmRkMTJfYXZkZDE4W10gPSB7DQo+ICsgICAgICAgImF2ZGQxMiIsICJhdmRkMTgi
DQo+ICt9Ow0KPiArDQo+ICtzdGF0aWMgY29uc3QgY2hhciAqY29uc3QgdWZzX210a19yZWdzX2F2
ZGQxMl9ja2J1Zl9hdmRkMThbXSA9IHsNCj4gKyAgICAgICAiYXZkZDEyIiwgImF2ZGQxMi1ja2J1
ZiIsICJhdmRkMTgiDQo+ICt9Ow0KPiArDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHVmc19tdGtf
c29jX2RhdGEgbXQ4MTgzX2RhdGEgPSB7DQo+ICAgICAgICAgLmhhc19hdmRkMDkgPSB0cnVlLA0K
PiArICAgICAgIC5yZWdfbmFtZXMgPSB1ZnNfbXRrX3JlZ3NfYXZkZDEyX2F2ZGQxOCwNCj4gKyAg
ICAgICAubnVtX3JlZ19uYW1lcyA9IEFSUkFZX1NJWkUodWZzX210a19yZWdzX2F2ZGQxMl9hdmRk
MTgpLA0KPiArfTsNCj4gKw0KPiArc3RhdGljIGNvbnN0IHN0cnVjdCB1ZnNfbXRrX3NvY19kYXRh
IG10ODE5Ml84MTk1X2RhdGEgPSB7DQo+ICsgICAgICAgLmhhc19hdmRkMDkgPSBmYWxzZSwNCj4g
KyAgICAgICAucmVnX25hbWVzID0gdWZzX210a19yZWdzX2F2ZGQxMl9ja2J1Zl9hdmRkMTgsDQo+
ICsgICAgICAgLm51bV9yZWdfbmFtZXMgPQ0KPiBBUlJBWV9TSVpFKHVmc19tdGtfcmVnc19hdmRk
MTJfY2tidWZfYXZkZDE4KSwNCj4gIH07DQpUaGVzZSBhbmFsb2cgcG93ZXIgY2Fubm90IGJlIHBv
d2VyZWQgb2ZmLCBldmVuIGluIHN1c3BlbmQgc3RhZ2UhDQo+IA0KPiAgc3RhdGljIGNvbnN0IHN0
cnVjdCBvZl9kZXZpY2VfaWQgdWZzX210a19vZl9tYXRjaFtdID0gew0KPiAgICAgICAgIHsgLmNv
bXBhdGlibGUgPSAibWVkaWF0ZWssbXQ4MTgzLXVmc2hjaSIsIC5kYXRhID0NCj4gJm10ODE4M19k
YXRhIH0sDQo+IC0gICAgICAgeyAuY29tcGF0aWJsZSA9ICJtZWRpYXRlayxtdDgxOTItdWZzaGNp
IiB9LA0KPiAtICAgICAgIHsgLmNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ4MTk1LXVmc2hjaSIg
fSwNCj4gKyAgICAgICB7IC5jb21wYXRpYmxlID0gIm1lZGlhdGVrLG10ODE5Mi11ZnNoY2kiLCAu
ZGF0YSA9DQo+ICZtdDgxOTJfODE5NV9kYXRhIH0sDQo+ICsgICAgICAgeyAuY29tcGF0aWJsZSA9
ICJtZWRpYXRlayxtdDgxOTUtdWZzaGNpIiwgLmRhdGEgPQ0KPiAmbXQ4MTkyXzgxOTVfZGF0YSB9
LA0KPiAgICAgICAgIHt9LA0KPiAgfTsNCj4gIE1PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIHVmc19t
dGtfb2ZfbWF0Y2gpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWsuaCBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5oDQo+IGluZGV4IDI0Yzg5
NDFmNmI4Ni4uY2IzMmZjOTg3ODY0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vm
cy1tZWRpYXRlay5oDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmgNCj4g
QEAgLTE3Niw2ICsxNzYsOCBAQCBzdHJ1Y3QgdWZzX210a19tY3FfaW50cl9pbmZvIHsNCj4gIHN0
cnVjdCB1ZnNfbXRrX2hvc3Qgew0KPiAgICAgICAgIHN0cnVjdCBwaHkgKm1waHk7DQo+ICAgICAg
ICAgc3RydWN0IHJlZ3VsYXRvciAqcmVnX2F2ZGQwOTsNCj4gKyAgICAgICBzdHJ1Y3QgcmVndWxh
dG9yX2J1bGtfZGF0YSAqcmVnX21pc2M7DQo+ICsgICAgICAgdTggbnVtX3JlZ19taXNjOw0KPiAg
ICAgICAgIHN0cnVjdCByZXNldF9jb250cm9sX2J1bGtfZGF0YSByZXNldHNbTVRLX1VGU19OVU1f
UkVTRVRTXTsNCj4gICAgICAgICBzdHJ1Y3QgdWZzX2hiYSAqaGJhOw0KPiAgICAgICAgIHN0cnVj
dCB1ZnNfbXRrX2NyeXB0X2NmZyAqY3J5cHQ7DQo+IA0KPiAtLQ0KPiAyLjUyLjANCj4gDQo=
