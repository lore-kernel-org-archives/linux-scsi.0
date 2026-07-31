Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBB1149DF1;
	Fri, 31 Jul 2026 05:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785477090; cv=fail; b=q/nhEb30geCK0DmTtxFIVuyIN3/wSvJUczsNZJ4pV4bIgT2Tq7nPQg0bicZVt5Z80csPdkoDQGOf8HoIei+aBlKfrUAPJGM3dtOG+EP/y47wyHJ2hvwgSN1T728+0xSQqc9uz+dXwL9ivql62rb/R0g3tjldQVn5ZPSElCa+CA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785477090; c=relaxed/simple;
	bh=WDO3G3lU4kD6kIU15S/wnlRGc1EXk+PoGLxKdMriGq8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IJqFl1NoN6/dYTi0951p/eiT7jT41MxjkWdMOJhh4WDXz1A3Ug/4hf+eJ4wHe8bUTvFs4BfHYbrHp+epvna3Sx5UkrNhRFDYAindSU2uJQx5yzuJw+eYDYGaOZd46OeUL7YHMdNxJZ+ysuNQuErXwrO80fETWxEMpudF5WH8aqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=innS4Umm; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=lLobzM7K; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="innS4Umm";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="lLobzM7K"
X-UUID: dd3cdd588ca311f1b1788b6acf885367-20260731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=WDO3G3lU4kD6kIU15S/wnlRGc1EXk+PoGLxKdMriGq8=;
	b=innS4UmmZDFT9KYze0jf5egeyUu+KwJI8zOyohaJpKNd8NZyGrjWxYM8hzNyko7UDli6aJBgobUAmy/LrWMg3I/OcRKPpbnQ6+wxo1pw2gaeI4cmZGH+Bq356bZC5Q/COfZgm0RVp1rwGXKzNgk2tDnu9nWpDrNavIwuoEUdf5w=;
X-CID-CACHE: Type:Local,Time:202607311351+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c8b23727-bc83-4881-b54a-f92b3c737bb8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:6ad9e744-7daf-432f-874c-469ff58f1470,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dd3cdd588ca311f1b1788b6acf885367-20260731
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 285476429; Fri, 31 Jul 2026 13:51:24 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 31 Jul 2026 13:51:23 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 31 Jul 2026 13:51:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMAxJ4yc5gAORORi0ZXJsAgphm+Lm+ISC51BFQQb67ZJLxlRSSil8g3OWUlGSajnoEFLwP64oDYXS5QJdxLt81U4wNiZAq4hFg0azW2Sm9sfn4EpN9zhWC09Vfm+B8lvxjn1MQBq9jIWpH1iJIS422kr7whVluMPpTTZluPeHe/CMCzzvV0lfORaGlsCujKuzqP2XXK9kccLqQGmF6l/LlCWl0C0UFCwiygyGD827gFoIKJGZ/bFKSCJGahOq8YvZxvEXuH4u+ZfzZD6W7R+sfHTN0Wz4xVuf7kTCIzEzrdP4FnaqXyTgHka1mofnDC/p4LxYIBga4Ux+1aBt/vkJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDO3G3lU4kD6kIU15S/wnlRGc1EXk+PoGLxKdMriGq8=;
 b=JSzjhLc4kULenoQQAUk/eAWyJ3ZIxa72yPtgZY13/gAAb6ETfOZOjyh/olJxuA5wSUNwevf1zlCV8PS33eG//8ulbM8IJVkXs9qq+/nNIMBaCaQuS2KDWHg+yeMPU2NXbaEggaBUEOC9NbGzzPO9PCefmI66qCH6Bi3P5+VJhUF5mW73GKuns8HiMAL6UnB2UiWkFsnEsNEQtsBkkn6tEn3KpZQ7DrDvQ/xE53k/MiGg8c4rZE1HfcO5Oles2lcAXheE4WK4mwEyAs5ZgkiW9BgxRUUxON0AOwhKuF0uHOGTUzJYe70cc3iLfiOLTKhGUjbJlJP2u6gvwAqRNKV2Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDO3G3lU4kD6kIU15S/wnlRGc1EXk+PoGLxKdMriGq8=;
 b=lLobzM7Kiq2Jwsqqd5n3bMpsq5I+8bzRQJirRFCAuV+Ob1v7NguI48Np7KW7tYpwz/2LcKCyPIcXdfnVdRDhyzhrr5CEuO3BUT8LpV56gCk+zK4GLHUmGHwsZgguybB5AavJx8ZaXgDFrtGeEkqZNOXohnaRC8F7c+3rX7nvodY=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by SEZPR03MB8206.apcprd03.prod.outlook.com (2603:1096:101:192::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 05:51:18 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 05:51:17 +0000
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
Subject: Re: [PATCH v10 13/26] scsi: ufs: mediatek: Use the common PHY
 framework
Thread-Topic: [PATCH v10 13/26] scsi: ufs: mediatek: Use the common PHY
 framework
Thread-Index: AQHdIAjkjxWiBifiXUyIoTdG868FOLaHISIA
Date: Fri, 31 Jul 2026 05:51:17 +0000
Message-ID: <5bd6efe2079ac94a3e39dba3d1f644cb627368da.camel@mediatek.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
	 <20260730-mt8196-ufs-v10-13-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-13-bc5ecef202dc@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|SEZPR03MB8206:EE_
x-ms-office365-filtering-correlation-id: 7261d0e3-827f-41ea-c938-08deeec7bd3f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|4143699003|5023799004|11063799006|6133799003|56012099006|18002099003|22082099003|38070700021|921020;
x-microsoft-antispam-message-info: nKRkzewtuM+RVPwVbVvW7rH3avD/JrWRzShzA+yOuh+kPlKUcuFvfcYwBq+vWZ1d3JdiirKsLURfUrTiid7lLQ+eBO0IKtE3h6I2louH7Y19awIIKS2Q4A+8vqQsGvfZi37T4vvPAQfXbEp25NMt8n37m2dHijh4wSgE5Kmiphv/BiYI8zjCZ/YO6hTI5yuUG4JeSYjDYW2ga2ZTv0xVk5sA99wvqO1ZFd3bKFvk2MG7KJ4tUr+Gvs/MDFbRuhhGJfB9t0eM0LlH39OaAfSTdETSs2uFL4mOuwjMuzSIfVil5Z+ZlXiGyargEWxlKgD+3D2efRBF6rf8N9+E1uoCdcoF9iZNUOeQt6Zai/Iol2NNjriPmICLz9fVAgBtvoX02320IZKFPVfuZ/OkW8dygj8xKlDUx9o5wsUaal0QJBK8uYzg/Ro8CSeIL+3EUhYPsqj33Ke204XHWIZ8bua1iHrcGQv/2hxhhw8HzdpZC/Gd45Bejj7PXMmp1HsOoREyXr8YihHb1nrTtvzTbU4jLx+xW2kfRKF225PC1RuQC81LzISyazjtu1s38O2I2kvQnzQ+IZA3eNHn3ZGVdRv9MvNOpB8yrAEzw0zKXBc85+gsGcfCpSVj5Vsz62EKpdIxD13cgbI9GtvvbJ9HQgLyoF2AHPQcFHC18/rXsD96F9hhM4J3N3BLjqUlO9LXVQtPsNUWRTHQ5dplB09dSsrd6k6floulj2N5nOK6zaAOJX48A1gzetj5Gff5cgoTU97C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(4143699003)(5023799004)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2ZIQXZJWjVKUzlGSEVxUWlaREs5ZXZpUjJEOGJqb2sya0FTeU1IUlJjMVVz?=
 =?utf-8?B?MmwzaUFJZHlkR3RyU3hBYmZ5NWFYU2IrMHQ2WHV6L21uTUVUdXBiV2JINkIz?=
 =?utf-8?B?SW4xdlBsN0ZHaEl2bkRFMDFjY2FlYVhGRzhCN1FLUUVsSnJ2OU5BSmJJeVdZ?=
 =?utf-8?B?OUhwSER3Sk45NFFWNDNMQ0l4TlBEK1U3aGs2dUE4RmdaUUVPckFTOXhjbkxS?=
 =?utf-8?B?c0k0K1U4SFRvaVJqWWZaZjZ1cWpodnVmMTFYZlhoeHFhQ2VJczNNVGZxNWtW?=
 =?utf-8?B?Rk1rY3d2L0x2Rm1UTzdsbEtQOUhVQjlqTzUvYitGRDRaSUtJOEtYTSs2cXlX?=
 =?utf-8?B?YXVubG9VMWQrbmpWNytEV0ZBaHhsZXJaOFFiRkwrVHkyUHFnR1NMdEVtcFg1?=
 =?utf-8?B?U0dsL2kyaG9DaWNRUjBoRDZXcHpZSHRJVmREcS9DVHZocHFzWEEzNlVRT1dK?=
 =?utf-8?B?ZjVSVVFZeUJHcFpqSlBSMnp0QnFCR0wvRFo1VVFOeWhaU0hMSHBZU3prSUlY?=
 =?utf-8?B?MXhzYzRvT0d5b1M2eUE3amR0TXNTZW9JemE3YXB4Yi94OEZmQlNseVhnRlc0?=
 =?utf-8?B?OHF1NEFabjRadno1amdpaVpPVHo1N1d2YXZSYlJvd2ZFb3ovZStOZU1PRzVC?=
 =?utf-8?B?STF6Y05OVVR0WEpvYnJoYWxybUZ3YTl6ZlVhYllKT2duNjhoQUdtNk43YW92?=
 =?utf-8?B?bjZEY1BzZ2JwNmdBcGRyZVNEcFRUSUV2OVIva0tYUnFYVzhFNFlWc1hzWEFO?=
 =?utf-8?B?M3JvRjZnWlJuTDJzVit2L1F1TDNhMDloZmcvcUtKSitxZVB4cm1QYTFzVURS?=
 =?utf-8?B?T1p3ZjFLT3NFSUZRSG9ZZzFPUHdIb2FKZ29CZjMyRUtaZnVSblBFY1p1aUtO?=
 =?utf-8?B?R1VBV0RKVVVLNEtOREpQTHdIYnRybHVDM1E1bVNCcDZNZ2p2YVRPbEx3RjI4?=
 =?utf-8?B?WXEwc2RMT2l0a2FITnhnU2kvOTRVTVA1WjZ6dUM2ckVnUU5OMWRBSU9sZ0ox?=
 =?utf-8?B?OHdHc1NOeXhhMUxyUDY1Nko5ODQzNkZaNENud0dLMkRpRS9QanNIWHlFZ0lV?=
 =?utf-8?B?U1hBY3VFOW5MZHdQUEs1dkxJZHpWV2V4amQrWk1TY242RGp0N2pGcS95MXh0?=
 =?utf-8?B?SlpxdkVleVRBU3pPOE0vb3ZRVDEwaVk1UElJaDJ4OW1MNDl5dlgvMGNzamhJ?=
 =?utf-8?B?SC9tLzE4L3YrQitZRXUzQWVTd25aM0NzVWJ1SUlmTWs2bmlTYkxwcDlaUHBQ?=
 =?utf-8?B?VUFDUE9MbUg2WjZaK3NlQ08vZW53NVlLZU9YRE9CRTN5QjRZV0l2ZlNaMUp6?=
 =?utf-8?B?Z3FZVFdSZUtBOW91Y1dBTVFzamFYQ0UrUUJGZlVjZjFYRW50c0x0WWhheFZW?=
 =?utf-8?B?Ulp4b2gxTDJNdFp3eS9odU5Md3FQTHBQZjZRLzd5eFhTYlg4NnVYVGp2YXNj?=
 =?utf-8?B?aEozMFU0NFBHc0ZNMjFrOXkzWG9NZHh3ODB4V25tMk5qRXlhWkNkelBGVko4?=
 =?utf-8?B?VXNkby9lT2w4MjY1ZDlZWWRsRjluTXRVYlgwUllISStyQVNIZHBYTG1yUFEy?=
 =?utf-8?B?RFF5bGxoRnZBVk94Ty9VbU9Ib1hvUmM1a0taMmloNm1tZUNiR3A3MzltZVFp?=
 =?utf-8?B?WlVGNXVNZUZIejRJcDU0SmlRQm5hYmo5SW4wblE2dDNQR1pYVjRmWFN4MU44?=
 =?utf-8?B?K2FVbm0ra0g3WVZ1Z01QTjdvQ2tvdXNSYkpaUHpNNVdoVGZmQ3JTMnlKcjlo?=
 =?utf-8?B?bTk0Uld6RDFFS0FDNnBramVSd2VMTHNDQkdPTTlETGJ4aWtnQ1RyWjA5cHk3?=
 =?utf-8?B?d3REUGhrOEtrMkNhd1ZRSndmak43SkdXT2lvYmc0YTM2NVUvc0NOa0pzTlF6?=
 =?utf-8?B?ZGlOOGNLcDJLcFhmVFNGbW9JbHEvcFlXNjQ0ejg4ckdFUXhFWnJFdUV6dW9P?=
 =?utf-8?B?K01nY2kwMHg3aUF0MmZBYlZhODNUZ0tRV0cxeVBXMytMV0pBRmpVczV5LzJX?=
 =?utf-8?B?c3RQa2hsSEt3WDg0RHVwV2YwOVBKYWpFU1FtR2I2NXI5cTBJSm9FZDdyWSs2?=
 =?utf-8?B?TW01Tk5Qc0ZoNmFwWmRkUGp6NTdlRi9XbG5JVUU0bUZwNkhaNjBBZzRjVndv?=
 =?utf-8?B?c2JRTThBZGNoMHdYUGZuR3Y1U1JOWS9iR0FqZWVyUnh5cUpHYXZ0RnBpK0VH?=
 =?utf-8?B?RGQ0amVvbE5qdjV2cHVRekJieFB2L0N6T08xajcxS1FKRytlZHA0YmFrVjVZ?=
 =?utf-8?B?ZmlHclhCRmNBUzIvT2NTYUR5aWQzeFNhL2gwbE9MeHVCTWJhOWVRWnJod0w5?=
 =?utf-8?B?cXc3N0hXckZFVmYrdk5SeVpsa2dZeEFtNHJJT1laRmlKRlg2VFoxcjNNK3RM?=
 =?utf-8?Q?pb4BthMgmidEcfHo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FF0781839C0A8408311AC48B4ED6CA6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: TUI0tNWqnDckghMwfVSTXIU4jmHqNtoaYpwyVIOSS+MFoHnzHVKqR4Dt125eCLGrHKj/sor1n4oqD3NHNRN7TcZgOWp8jI8s9MGkRmbbvq5a6MDN9sKqiaPjvAq+99VnCKPPnr/uV4ez4/S6r3C6DcC2goC2U+5qmK5TzriHwP3ns4YS8zKQb7ENM3w9CDtdRN0J36jcnxHghuQ0dFHyDMd9NDpfhhnkWcUDW697n2ZIYf1t9qGqX5NI+DhgqEmIV1bnfzDUOxYelLSdoTbEAco67ke9gW8dAUG/NrfaEIToI4pFsWyvzX+TTm1QX95+wYEQg8HwkOvC+4qgzSNDvw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7261d0e3-827f-41ea-c938-08deeec7bd3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 05:51:17.3852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zOyY4J9rkDj6UpGYNCCtJwHV66dUxd+ClUAGut+2HCelbXnuLt+vrNoU+peTWP4WgRLNBJ6Dstz6U/M0zlJLXzgu3+o2pVGDyWZjtGRtjJI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8206
X-MTK: N

T24gVGh1LCAyMDI2LTA3LTMwIGF0IDExOjQ5ICswMjAwLCBMb3Vpcy1BbGV4aXMgRXlyYXVkIHdy
b3RlOg0KPiBGcm9tOiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xs
YWJvcmEuY29tPg0KPiANCj4gVGhlcmUgaXMgbm8gbmVlZCB0byByZWludmVudCB0aGUgUEhZIGZy
YW1ld29yaywgZXNwZWNpYWxseSBub3QgaXRzIE9GDQo+IHBhcnNpbmcuDQo+IA0KPiBDaGFuZ2Ug
dGhlIGNvZGUgdG8gc2ltcGx5IHVzZSB0aGUgUEhZIGZyYW1ld29yayB0byBhY3F1aXJlIHRoZQ0K
PiBkZXZpY2Uncw0KPiBQSFkgaW4gdGhlIHVmc2hjZCBpbml0LCBzbyB0aGF0IGl0J3MgZGV2aWNl
IGxpbmtlZCB0byB0aGUgcmlnaHQNCj4gZGV2aWNlLg0KPiANClJldmlld2VkLWJ5OiBDaGFvdGlh
biBKaW5nIDxjaGFvdGlhbi5qaW5nQG1lZGlhdGVrLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEFuZ2Vs
b0dpb2FjY2hpbm8gRGVsIFJlZ25vIDwNCj4gYW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xs
YWJvcmEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMu
ZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBMb3Vpcy1BbGV4aXMg
RXlyYXVkIDxsb3Vpc2FsZXhpcy5leXJhdWRAY29sbGFib3JhLmNvbT4NCj4gLS0tDQo+ICBkcml2
ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIHwgMTM0ICsrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLQ0KPiAtLS0tLS0tLS0tDQo+ICBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5o
IHwgICAxIC0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNDIgaW5zZXJ0aW9ucygrKSwgOTMgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsu
YyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5jDQo+IGluZGV4IGU1NTI3OTY5
YTVlNi4uMzg1ZjAxODBiMjMwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1t
ZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gQEAg
LTI5Myw0NCArMjkzLDYgQEAgc3RhdGljIGludCB1ZnNfbXRrX2hjZV9lbmFibGVfbm90aWZ5KHN0
cnVjdA0KPiB1ZnNfaGJhICpoYmEsDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gLXN0YXRp
YyBpbnQgdWZzX210a19iaW5kX21waHkoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gLXsNCj4gLQlz
dHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+IC0J
c3RydWN0IGRldmljZSAqZGV2ID0gaGJhLT5kZXY7DQo+IC0Jc3RydWN0IGRldmljZV9ub2RlICpu
cCA9IGRldi0+b2Zfbm9kZTsNCj4gLQlpbnQgZXJyID0gMDsNCj4gLQ0KPiAtCWhvc3QtPm1waHkg
PSBkZXZtX29mX3BoeV9nZXRfYnlfaW5kZXgoZGV2LCBucCwgMCk7DQo+IC0NCj4gLQlpZiAoaG9z
dC0+bXBoeSA9PSBFUlJfUFRSKC1FUFJPQkVfREVGRVIpKSB7DQo+IC0JCS8qDQo+IC0JCSAqIFVG
UyBkcml2ZXIgbWlnaHQgYmUgcHJvYmVkIGJlZm9yZSB0aGUgcGh5IGRyaXZlcg0KPiBkb2VzLg0K
PiAtCQkgKiBJbiB0aGF0IGNhc2Ugd2Ugd291bGQgbGlrZSB0byByZXR1cm4gRVBST0JFX0RFRkVS
DQo+IGNvZGUuDQo+IC0JCSAqLw0KPiAtCQllcnIgPSAtRVBST0JFX0RFRkVSOw0KPiAtCQlkZXZf
aW5mbyhkZXYsDQo+IC0JCQkgIiVzOiByZXF1aXJlZCBwaHkgaGFzbid0IHByb2JlZCB5ZXQuIGVy
ciA9DQo+ICVkXG4iLA0KPiAtCQkJX19mdW5jX18sIGVycik7DQo+IC0JfSBlbHNlIGlmIChJU19F
UlIoaG9zdC0+bXBoeSkpIHsNCj4gLQkJZXJyID0gUFRSX0VSUihob3N0LT5tcGh5KTsNCj4gLQkJ
aWYgKGVyciAhPSAtRU5PREVWKSB7DQo+IC0JCQlkZXZfaW5mbyhkZXYsICIlczogUEhZIGdldCBm
YWlsZWQgJWRcbiIsDQo+IF9fZnVuY19fLA0KPiAtCQkJCSBlcnIpOw0KPiAtCQl9DQo+IC0JfQ0K
PiAtDQo+IC0JaWYgKGVycikNCj4gLQkJaG9zdC0+bXBoeSA9IE5VTEw7DQo+IC0JLyoNCj4gLQkg
KiBBbGxvdyB1bmJvdW5kIG1waHkgYmVjYXVzZSBub3QgZXZlcnkgcGxhdGZvcm0gbmVlZHMgc3Bl
Y2lmaWMNCj4gLQkgKiBtcGh5IGNvbnRyb2wuDQo+IC0JICovDQo+IC0JaWYgKGVyciA9PSAtRU5P
REVWKQ0KPiAtCQllcnIgPSAwOw0KPiAtDQo+IC0JcmV0dXJuIGVycjsNCj4gLX0NCj4gLQ0KPiAg
c3RhdGljIGludCB1ZnNfbXRrX3NldHVwX3JlZl9jbGsoc3RydWN0IHVmc19oYmEgKmhiYSwgYm9v
bCBvbikNCj4gIHsNCj4gIAlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92
YXJpYW50KGhiYSk7DQo+IEBAIC0xMTg1LDEzICsxMTQ3LDIxIEBAIHN0YXRpYyBpbnQgdWZzX210
a19pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICANCj4gIAl1ZnNfbXRrX2luaXRfbWNxX2ly
cShoYmEpOw0KPiAgDQo+IC0JZXJyID0gdWZzX210a19iaW5kX21waHkoaGJhKTsNCj4gLQlpZiAo
ZXJyKQ0KPiArCWhvc3QtPm1waHkgPSBkZXZtX3BoeV9nZXQoZGV2LCBOVUxMKTsNCj4gKwlpZiAo
SVNfRVJSKGhvc3QtPm1waHkpKSB7DQo+ICsJCWVyciA9IGRldl9lcnJfcHJvYmUoZGV2LCBQVFJf
RVJSKGhvc3QtPm1waHkpLCAiRmFpbGVkDQo+IHRvIGdldCBQSFlcbiIpOw0KPiArCQlnb3RvIG91
dF92YXJpYW50X2NsZWFyOw0KPiArCX0NCj4gKw0KPiArCWVyciA9IHBoeV9pbml0KGhvc3QtPm1w
aHkpOw0KPiArCWlmIChlcnIpIHsNCj4gKwkJZGV2X2Vycl9wcm9iZShkZXYsIGVyciwgIkZhaWxl
ZCB0byBpbml0aWFsaXplIFBIWVxuIik7DQo+ICAJCWdvdG8gb3V0X3ZhcmlhbnRfY2xlYXI7DQo+
ICsJfQ0KPiAgDQo+ICAJZXJyID0gdWZzX210a19pbml0X3Jlc2V0KGhiYSk7DQo+ICAJaWYgKGVy
cikNCj4gLQkJZ290byBvdXRfdmFyaWFudF9jbGVhcjsNCj4gKwkJZ290byBvdXRfcGh5X2V4aXQ7
DQo+ICANCj4gIAkvKiBFbmFibGUgcnVudGltZSBhdXRvc3VzcGVuZCAqLw0KPiAgCWhiYS0+Y2Fw
cyB8PSBVRlNIQ0RfQ0FQX1JQTV9BVVRPU1VTUEVORDsNCj4gQEAgLTEyMzAsNyArMTIwMCw3IEBA
IHN0YXRpYyBpbnQgdWZzX210a19pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICANCj4gIAll
cnIgPSB1ZnNfbXRrX2dldF9zdXBwbGllcyhob3N0KTsNCj4gIAlpZiAoZXJyKQ0KPiAtCQlnb3Rv
IG91dF92YXJpYW50X2NsZWFyOw0KPiArCQlnb3RvIG91dF9waHlfZXhpdDsNCj4gIA0KPiAgCS8q
DQo+ICAJICogdWZzaGNkX3ZvcHNfaW5pdCgpIGlzIGludm9rZWQgYWZ0ZXINCj4gQEAgLTEyNTUs
MTEgKzEyMjUsMjIgQEAgc3RhdGljIGludCB1ZnNfbXRrX2luaXQoc3RydWN0IHVmc19oYmEgKmhi
YSkNCj4gIA0KPiAgCXJldHVybiAwOw0KPiAgDQo+ICtvdXRfcGh5X2V4aXQ6DQo+ICsJcGh5X2V4
aXQoaG9zdC0+bXBoeSk7DQo+ICBvdXRfdmFyaWFudF9jbGVhcjoNCj4gIAl1ZnNoY2Rfc2V0X3Zh
cmlhbnQoaGJhLCBOVUxMKTsNCj4gIAlyZXR1cm4gZXJyOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMg
dm9pZCB1ZnNfbXRrX2V4aXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gK3sNCj4gKwlzdHJ1Y3Qg
dWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+ICsNCj4gKwl1
ZnNfbXRrX21waHlfcG93ZXJfb24oaGJhLCBmYWxzZSk7DQo+ICsNCj4gKwlwaHlfZXhpdChob3N0
LT5tcGh5KTsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGludCB1ZnNfbXRrX25lZ290aWF0ZV9wd3Jf
bW9kZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiAgCQkJCSAgICAgIGNvbnN0IHN0cnVjdCB1ZnNf
cGFfbGF5ZXJfYXR0cg0KPiAqZGV2X21heF9wYXJhbXMsDQo+ICAJCQkJICAgICAgc3RydWN0IHVm
c19wYV9sYXllcl9hdHRyDQo+ICpkZXZfcmVxX3BhcmFtcykNCj4gQEAgLTIyNzIsNiArMjI1Myw3
IEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfY29uZmlnX3Njc2lfZGV2KHN0cnVjdA0KPiBzY3NpX2Rl
dmljZSAqc2RldikNCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X29wcyB1
ZnNfaGJhX210a192b3BzID0gew0KPiAgCS5uYW1lICAgICAgICAgICAgICAgID0gIm1lZGlhdGVr
LnVmc2hjaSIsDQo+ICAJLmluaXQgICAgICAgICAgICAgICAgPSB1ZnNfbXRrX2luaXQsDQo+ICsJ
LmV4aXQgICAgICAgICAgICAgICAgPSB1ZnNfbXRrX2V4aXQsDQo+ICAJLmdldF91ZnNfaGNpX3Zl
cnNpb24gPSB1ZnNfbXRrX2dldF91ZnNfaGNpX3ZlcnNpb24sDQo+ICAJLnNldHVwX2Nsb2NrcyAg
ICAgICAgPSB1ZnNfbXRrX3NldHVwX2Nsb2NrcywNCj4gIAkuaGNlX2VuYWJsZV9ub3RpZnkgICA9
IHVmc19tdGtfaGNlX2VuYWJsZV9ub3RpZnksDQo+IEBAIC0yMzMyLDQ4ICsyMzE0LDE1IEBAIE1P
RFVMRV9ERVZJQ0VfVEFCTEUob2YsIHVmc19tdGtfb2ZfbWF0Y2gpOw0KPiAgICovDQo+ICBzdGF0
aWMgaW50IHVmc19tdGtfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIHsN
Cj4gLQlpbnQgZXJyOw0KPiArCXN0cnVjdCBkZXZpY2UgKmRldiA9ICZwZGV2LT5kZXY7DQo+ICAJ
c3RydWN0IHVmc19oYmEgKmhiYTsNCj4gLQlzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwaHlfcGRl
diA9IE5VTEw7DQo+IC0Jc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYtPmRldiwgKnBoeV9kZXYg
PSBOVUxMOw0KPiAtCXN0cnVjdCBkZXZpY2Vfbm9kZSAqcGh5X25vZGUgPSBOVUxMOw0KPiAtCXN0
cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3Q7DQo+IC0NCj4gLQkvKiBmaW5kIHBoeSBub2RlICovDQo+
IC0JcGh5X25vZGUgPSBvZl9wYXJzZV9waGFuZGxlKGRldi0+b2Zfbm9kZSwgInBoeXMiLCAwKTsN
Cj4gLQ0KPiAtCWlmIChwaHlfbm9kZSkgew0KPiAtCQlwaHlfcGRldiA9IG9mX2ZpbmRfZGV2aWNl
X2J5X25vZGUocGh5X25vZGUpOw0KPiAtCQlpZiAoIXBoeV9wZGV2KQ0KPiAtCQkJZ290byBza2lw
X3BoeTsNCj4gLQkJcGh5X2RldiA9ICZwaHlfcGRldi0+ZGV2Ow0KPiAtDQo+IC0JCXBtX3J1bnRp
bWVfc2V0X2FjdGl2ZShwaHlfZGV2KTsNCj4gLQkJcG1fcnVudGltZV9lbmFibGUocGh5X2Rldik7
DQo+IC0JCXBtX3J1bnRpbWVfZ2V0X3N5bmMocGh5X2Rldik7DQo+IC0NCj4gLQkJcHV0X2Rldmlj
ZShwaHlfZGV2KTsNCj4gLQkJZGV2X2luZm8oZGV2LCAicGh5cyBub2RlIGZvdW5kXG4iKTsNCj4g
LQl9IGVsc2Ugew0KPiAtCQlkZXZfbm90aWNlKGRldiwgInBoeXMgbm9kZSBub3QgZm91bmRcbiIp
Ow0KPiAtCX0NCj4gKwlpbnQgcmV0Ow0KPiAgDQo+IC1za2lwX3BoeToNCj4gLQkvKiBwZXJmb3Jt
IGdlbmVyaWMgcHJvYmUgKi8NCj4gLQllcnIgPSB1ZnNoY2RfcGx0ZnJtX2luaXQocGRldiwgJnVm
c19oYmFfbXRrX3ZvcHMpOw0KPiAtCWlmIChlcnIpIHsNCj4gLQkJZGV2X2VycihkZXYsICJwcm9i
ZSBmYWlsZWQgJWRcbiIsIGVycik7DQo+IC0JCWdvdG8gb3V0Ow0KPiAtCX0NCj4gKwlyZXQgPSB1
ZnNoY2RfcGx0ZnJtX2luaXQocGRldiwgJnVmc19oYmFfbXRrX3ZvcHMpOw0KPiArCWlmIChyZXQp
DQo+ICsJCXJldHVybiBkZXZfZXJyX3Byb2JlKGRldiwgcmV0LCAiR2VuZXJpYyBwbGF0Zm9ybSBw
cm9iZQ0KPiBmYWlsZWRcbiIpOw0KPiAgDQo+ICAJaGJhID0gcGxhdGZvcm1fZ2V0X2RydmRhdGEo
cGRldik7DQo+IC0JaWYgKCFoYmEpDQo+IC0JCWdvdG8gb3V0Ow0KPiAtDQo+IC0JaWYgKHBoeV9u
b2RlICYmIHBoeV9kZXYpIHsNCj4gLQkJaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0K
PiAtCQlob3N0LT5waHlfZGV2ID0gcGh5X2RldjsNCj4gLQl9DQo+ICANCj4gIAkvKg0KPiAgCSAq
IEJlY2F1c2UgdGhlIGRlZmF1bHQgcG93ZXIgc2V0dGluZyBvZiBWU3ggKHRoZSB1cHBlciBsYXll
ciBvZg0KPiBAQCAtMjM4MiwxNiArMjMzMSwxMiBAQCBzdGF0aWMgaW50IHVmc19tdGtfcHJvYmUo
c3RydWN0DQo+IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAkgKi8NCj4gIAl1ZnNfbXRrX2Rl
dl92cmVnX3NldF9scG0oaGJhLCBmYWxzZSk7DQo+ICANCj4gLW91dDoNCj4gLQlvZl9ub2RlX3B1
dChwaHlfbm9kZSk7DQo+IC0JcmV0dXJuIGVycjsNCj4gKwlyZXR1cm4gMDsNCj4gIH0NCj4gIA0K
PiAgLyoqDQo+ICAgKiB1ZnNfbXRrX3JlbW92ZSAtIHNldCBkcml2ZXJfZGF0YSBvZiB0aGUgZGV2
aWNlIHRvIE5VTEwNCj4gICAqIEBwZGV2OiBwb2ludGVyIHRvIHBsYXRmb3JtIGRldmljZSBoYW5k
bGUNCj4gLSAqDQo+IC0gKiBBbHdheXMgcmV0dXJuIDANCj4gICAqLw0KPiAgc3RhdGljIHZvaWQg
dWZzX210a19yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIHsNCj4gQEAg
LTI0NDgsOSArMjM5Myw4IEBAIHN0YXRpYyBpbnQgdWZzX210a19zeXN0ZW1fcmVzdW1lKHN0cnVj
dCBkZXZpY2UNCj4gKmRldikNCj4gIHN0YXRpYyBpbnQgdWZzX210a19ydW50aW1lX3N1c3BlbmQo
c3RydWN0IGRldmljZSAqZGV2KQ0KPiAgew0KPiAgCXN0cnVjdCB1ZnNfaGJhICpoYmEgPSBkZXZf
Z2V0X2RydmRhdGEoZGV2KTsNCj4gLQlzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNk
X2dldF92YXJpYW50KGhiYSk7DQo+ICAJc3RydWN0IGFybV9zbWNjY19yZXMgcmVzOw0KPiAtCWlu
dCByZXQgPSAwOw0KPiArCWludCByZXQ7DQo+ICANCj4gIAlyZXQgPSB1ZnNoY2RfcnVudGltZV9z
dXNwZW5kKGRldik7DQo+ICAJaWYgKHJldCkNCj4gQEAgLTI0NjEsOCArMjQwNSwxMSBAQCBzdGF0
aWMgaW50IHVmc19tdGtfcnVudGltZV9zdXNwZW5kKHN0cnVjdA0KPiBkZXZpY2UgKmRldikNCj4g
IAlpZiAodWZzX210a19pc19ydGZmX210Y21vcyhoYmEpKQ0KPiAgCQl1ZnNfbXRrX210Y21vc19j
dHJsKGZhbHNlLCByZXMpOw0KPiAgDQo+IC0JaWYgKGhvc3QtPnBoeV9kZXYpDQo+IC0JCXBtX3J1
bnRpbWVfcHV0X3N5bmMoaG9zdC0+cGh5X2Rldik7DQo+ICsJcmV0ID0gdWZzX210a19tcGh5X3Bv
d2VyX29uKGhiYSwgZmFsc2UpOw0KPiArCWlmIChyZXQpIHsNCj4gKwkJZGV2X2VycihkZXYsICJG
YWlsZWQgdG8gcG93ZXIgb2ZmIFBIWTogJXBlXG4iLA0KPiBFUlJfUFRSKHJldCkpOw0KPiArCQly
ZXR1cm4gcmV0Ow0KPiArCX0NCj4gIA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiBAQCAtMjQ3MCwx
NCArMjQxNywxNyBAQCBzdGF0aWMgaW50IHVmc19tdGtfcnVudGltZV9zdXNwZW5kKHN0cnVjdA0K
PiBkZXZpY2UgKmRldikNCj4gIHN0YXRpYyBpbnQgdWZzX210a19ydW50aW1lX3Jlc3VtZShzdHJ1
Y3QgZGV2aWNlICpkZXYpDQo+ICB7DQo+ICAJc3RydWN0IHVmc19oYmEgKmhiYSA9IGRldl9nZXRf
ZHJ2ZGF0YShkZXYpOw0KPiAtCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0
X3ZhcmlhbnQoaGJhKTsNCj4gIAlzdHJ1Y3QgYXJtX3NtY2NjX3JlcyByZXM7DQo+ICsJaW50IHJl
dDsNCj4gIA0KPiAgCWlmICh1ZnNfbXRrX2lzX3J0ZmZfbXRjbW9zKGhiYSkpDQo+ICAJCXVmc19t
dGtfbXRjbW9zX2N0cmwodHJ1ZSwgcmVzKTsNCj4gIA0KPiAtCWlmIChob3N0LT5waHlfZGV2KQ0K
PiAtCQlwbV9ydW50aW1lX2dldF9zeW5jKGhvc3QtPnBoeV9kZXYpOw0KPiArCXJldCA9IHVmc19t
dGtfbXBoeV9wb3dlcl9vbihoYmEsIHRydWUpOw0KPiArCWlmIChyZXQpIHsNCj4gKwkJZGV2X2Vy
cihkZXYsICJGYWlsZWQgdG8gcG93ZXIgb24gUEhZOiAlcGVcbiIsDQo+IEVSUl9QVFIocmV0KSk7
DQo+ICsJCXJldHVybiByZXQ7DQo+ICsJfQ0KPiAgDQo+ICAJdWZzX210a19kZXZfdnJlZ19zZXRf
bHBtKGhiYSwgZmFsc2UpOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vm
cy1tZWRpYXRlay5oIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmgNCj4gaW5k
ZXggYzYzNzQwYjk4ZTg1Li44YjNjZDE3ZTYyMjcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZz
L2hvc3QvdWZzLW1lZGlhdGVrLmgNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWsuaA0KPiBAQCAtMTk1LDcgKzE5NSw2IEBAIHN0cnVjdCB1ZnNfbXRrX2hvc3Qgew0KPiAgCWJv
b2wgaXNfbWNxX2ludHJfZW5hYmxlZDsNCj4gIAlpbnQgbWNxX25yX2ludHI7DQo+ICAJc3RydWN0
IHVmc19tdGtfbWNxX2ludHJfaW5mbyBtY3FfaW50cl9pbmZvW1VGU0hDRF9NQVhfUV9OUl07DQo+
IC0Jc3RydWN0IGRldmljZSAqcGh5X2RldjsNCj4gIH07DQo+ICANCj4gIC8qIE1USyBkZWxheSBv
ZiBhdXRvc3VzcGVuZDogNTAwIG1zICovDQo+IA0K
