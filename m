Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643F13563D4;
	Fri, 31 Jul 2026 05:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785477130; cv=fail; b=MWBpOv20V+jII8MWAL1GXfUulFW6CpOkFvxKwZd2tUzuI7f2ZL9YoU98R/f3glZhgvq05dpGSIJIHpFMUOC3TjW+l5494j2Aq88ons9MtIe9fzHGw615xCF/55ghOehg2hR+McGz/u+NrZCyEAyhdsO0aYotyVHdaZeSTHPQ6NE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785477130; c=relaxed/simple;
	bh=Chkprt9DUQkcSPPYmjY++47vMxpn1wb3d5AvmTTXkT8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sem58J3IaE+Iw//29hZpW0UHwF2C0/QXxrOjGQ6M+88ITLqkttyI//Dq0QEUuM5s7WKr4yWx5Dzqu8r/Qm/C3Mb7jli4Ilh3gNuiarbcyOH5DxuHnogMzPGKQXgKwb83v/H5lfL+4DIdKs6auRlGlPU8PdiWTCreh06WR9QEIkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=FCxo7d4x; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=mvu6d1QT; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FCxo7d4x";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="mvu6d1QT"
X-UUID: f3b3c40c8ca311f1b1788b6acf885367-20260731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Chkprt9DUQkcSPPYmjY++47vMxpn1wb3d5AvmTTXkT8=;
	b=FCxo7d4x8xIfifHyqUEIvBj4lrypZPJaSR7NQ8HCUF0h1enjsqM3crKiC0bpR0WqZBhNF7i6jy7qvNcv7V9K9rWAT3+oxlyNd9/J2+H7lN8vtc2lvNF+sGfHFxIBwAc6uEbthEd8H6mRzr+TShKRkYYEQDIimrwzpNJrdC+ySG8=;
X-CID-CACHE: Type:Local,Time:202607311352+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2a71b2d6-079a-460a-b3dd-44da3634cd95,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:b20dfae1-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:
	nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f3b3c40c8ca311f1b1788b6acf885367-20260731
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1202636887; Fri, 31 Jul 2026 13:52:02 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 31 Jul 2026 13:52:01 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 31 Jul 2026 13:52:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzTmzviwb5/uZ8l5INQ7ya42o5yqxfoJ1V3H7B9ULsJnzfWXOZ7LMF/kdHcXGxslHkqxT1TVL54Qnzt8iZ/s19zse+IJ9T5c4Azbm+P9zn48KWDkmv0n6muRKQ4CnAklYYDReciV3b6Yi/1EN8sk8AmukIU5qrVYjbUS9Oifp7uohV6fSExpjfWWtvrMccndXW9ScGZTfuldJJLIWv2/crF0xBPbkOhORJtH8cv/u2I5qJ8P53kRgvySAPjHYBpayYysRFiv2DqROqdYiusBq4svhw4vWvrGengQGV76gWYRpqLBnzUd/LNhLNc5bUWrJXbAFnNYIEd7inls3/CJSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Chkprt9DUQkcSPPYmjY++47vMxpn1wb3d5AvmTTXkT8=;
 b=brAJve/vpdJCR2lSWb+MKQJK0AB2tB3iUypaD8YBKD8NlShdRU7UEahIhjrdPdyKD5lq8kF3JivK9VNcvJx4wXrjusjNQgV+8K9lR3qRhO/qkgFS9zhoym2rHFZmr7AdoeR9dlZI8DshbhFr7DBzyxuGDTkavBa8NjhXq6wPJG9fe18UsTJrx4wvboL+uc/cG7LzBfbNFKR6JDmxDUzQqsG8edeEwX7xoNCcUKK/QxaH7gjgbunY0zn/QBcaXf9AmAlwM94azT2ezXu3XBvo1IOsWup/nTWWrgiTFteB//54BkXnGzoucjnXl0AMwUgsi/srUOyyy/xIDywAvz38+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Chkprt9DUQkcSPPYmjY++47vMxpn1wb3d5AvmTTXkT8=;
 b=mvu6d1QTQaAfwbH4VNaUF0teh7DQWclckuJ958gq9itY0GE03hfzBokiQlUUpckPHL3PpUVq4AemaCerv9WTtpfYfcivKTBX8zrBi+D8DIsuRw/w296qCCP0uDn9WRHO31ZdwiMUgjdxpqcu16VFKMModoRC5QEEAz+XVImdJ9o=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by SEZPR03MB8206.apcprd03.prod.outlook.com (2603:1096:101:192::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 05:51:56 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 05:51:56 +0000
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
Subject: Re: [PATCH v10 22/26] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Thread-Topic: [PATCH v10 22/26] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Thread-Index: AQHdIAjxDnIw2cCmjEuwJhAbcnExHbaHIVCA
Date: Fri, 31 Jul 2026 05:51:56 +0000
Message-ID: <2941460533596c6704e2e0897feaabae37c87beb.camel@mediatek.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
	 <20260730-mt8196-ufs-v10-22-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-22-bc5ecef202dc@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|SEZPR03MB8206:EE_
x-ms-office365-filtering-correlation-id: 506287c4-c068-48d8-9885-08deeec7d450
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003|38070700021|921020;
x-microsoft-antispam-message-info: xPPYVv0tdDgskIfhoFS3rJm1HE/FakT0AhRFB1xEI5/CN+6wOcCmgbW9wOAOPhMlphqlKIaIgH/blqWSSQkXlI5a+BnC6Wl/PgBRz1qdvHGtZWOhQonMCHSDLfjk1r8Le42C4tF8nJA67te3gDLZmbTUwZDQRO/z4b9FuNwVN7J6RenKUp5FogwE8GUEHhJhK6aWK/4Ta0TsJrs5pPBV16FwxhR+/RH7ITnJrXgorjIWSLGjtt6kNji6jvUmjuFDITBUWnjZW94uZpdO2smGJWbZuLxtWV5m11PhLkNMGerKFKc0Sxrec25VyHi4fT3oglbJdEjb+0WsPVu4ti8VduRuKkJCPxWQZZSJPOOVEA/6AClVIcYDr5o0sEPca8C0OCpOISfYh6a5Qud+0I2Cd4rDTbS27bgTe4MIlR27f3/MIoz1AboidQcnK/90AFitKUbUZ4wf1hkIqH1hSlIHOuvBhH06A32f8mbdzENlWg1wq3d+abFhKqUQxg2AKLWaQuh3iCzJ2yeGMHg4ivdYE5hBTzm16axmUqwt+IH92k643yFXamOISK643vpPHjaHGtJjSElvo4JTqlIc2IrioP+rMlF7+KNHD4wCxi3E1u0gV+UMnGcwEoUj9f4c2lSCC2/mOHGb09Rvy4h27bd5YfWHHKP9MFYBlxvmfhIE9lOPFDug7/27vLwCDXJsSSW18SoZgqM/ZLvz1ZoiTJ4tVH+cbzls3b1y1pYO8SMR5gAH2xV0nPrSnDVzrlf76AIb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXIzZnI0ZXRsZWtxRnh1YTI0MEpJbmJ4eE1acmd4NFZYSURhWHhXdFRyVHNI?=
 =?utf-8?B?N1lsSGxjQjUrcU1kRFY5NzNHVmpTL3FlSXgrY1gvT2JyeVJ0YnUvQWtJOWF6?=
 =?utf-8?B?VlhhdHByaFZVbXlWSlovbUUvZTVscG53bUhDclJFamJZUmVQZDMrVkpKRWc1?=
 =?utf-8?B?Vjc4eWpnWXhKT0YyY0V2aGJKZGUxYWpncXg1RFhEM0kwR1JJZVBkRUJFaXFU?=
 =?utf-8?B?UTdreGJWeDdIUkNYU0ozTU80U0dacE5QTVV1SkVGUUtxWW1LOFVjNFEzQ01j?=
 =?utf-8?B?Sjg0K1grQ3Z5dWxXV2YyZnNNeDhsMFdYUlJLTjFZbGQ5azViUlNYYktQcUw1?=
 =?utf-8?B?eURxV3RQV2txakw2VnZZOVhJMUFwMENLbEc5NlI1cGg5czFtV2gvR2FJK1Jp?=
 =?utf-8?B?U2RvNWZnZ0NGcnFQSXZpa3dlOTdxUGREZEtEOEJxQWVTTVVydHcycHNJMDl0?=
 =?utf-8?B?SGlpYklrNG9OUDdaMlUwQ0RuUGtCMUJnM3YrUXNxM0ZBcmxUdjZxVmhCOUov?=
 =?utf-8?B?c3FFWlNFVXhxRFQ2ZldSdU5JUFFXNWJpK0dwajhZQ1E1TC9YV1R2RzdyNmM0?=
 =?utf-8?B?OGtuVU9NM3p1M08wRk1KWDB5Zzl6Z3Jjdmt6eVdLODhHRVFZak1VdTkwODZC?=
 =?utf-8?B?aWcrNWNqczBXbkZlN1UrdlpkdlhSZjg5Q2Q4d25KNlZYVFRKanJjU2lUaTgy?=
 =?utf-8?B?TGdRNXVMWUQ3VklkVXdYdm0wbmZKSEZVUWZ1RU42cGtDcHZhUmpRTVpKL0lo?=
 =?utf-8?B?c0JjOThPK2lQeENod1QzemthYWNNK3pBZ042RUFoOVQ3bHFMVzlocDZOb0hv?=
 =?utf-8?B?L3QzN2VoSzdFVEt2azJnUjRqby91ZkFsT3UrTllKanpuSXZ4NFhrc29JdE4v?=
 =?utf-8?B?V21xcVdEYzJVTVV3czJ3Q3Q0MC83QXRDazllWUxzdEljNXhRZ2dlZlQ0dlQ1?=
 =?utf-8?B?d2JXbWlKMTlCSHhYOWdaQllET0w2aXA5WG5rdnNEZWRwVDdvc2NGZ09OV3Bm?=
 =?utf-8?B?Zithbzh6Z2JiWW1RRnNFbkZDM3B6cTI0NmVkaUNXQitFWW5oYjYrVXZhSmVD?=
 =?utf-8?B?dzBzRDg3eE9QS0tmSCtqZFJOOW5wQ212R2ZhOUVJZXVnWjBFWWxLZ0hQNXJH?=
 =?utf-8?B?eGFaWXdNYmZ4U3pOT3p4WWZyRzE3YkpPa0NaVHN2QjZSTlB6dG1BeXFMVWJD?=
 =?utf-8?B?RUZwc2NPT1lqS3d4NGhDWU9Xd0hZKzEwYmxnUUszektTMnVyQWI1SFBXMmhJ?=
 =?utf-8?B?cE54RjVQeHJ1bmZuQ21JSW05QnN1OVJ1aWVvSzk5dklDcE4vMDdMcExhOEhT?=
 =?utf-8?B?VTljUUFPbkdxZjNVTXFKbEU4K1BmTVFCRGM5OC9PV3g4WU9kSUpzbVFwRWgw?=
 =?utf-8?B?d2JJRnVJczE3b29tZjg1VmFicFovdEtXTkxoM25menJ1Mkd1V2lSWE5aekph?=
 =?utf-8?B?OGIwN2ZyV04xMG1Gam5nRWJobFo1ZGlITWUzVW5EcDFHczBoUWdCM3UxM3Az?=
 =?utf-8?B?K3pqQmEyaXZWMUNuZllIaTJSdkJFQml1c1c2UzZsOHMxT2Y4K3ZOaloxWGZL?=
 =?utf-8?B?c0RLOENla3pDL1NodjMrWjdMaXVHTEduUjI0WDhoR1pDYWZYdEQ3TFIrbE16?=
 =?utf-8?B?V0NMV1dtTFR5SFFFdURIdTZjdEtYUy9NSUh0cEtBZ3ZmcHVPYmVVdHphdDRu?=
 =?utf-8?B?NXJaVnFZYnFGTXdMUk5BaHVOOGhYek42WW9KOXVVdkFQZ2FObVlxdmxBcC9p?=
 =?utf-8?B?UWR2YVI0amdoVTBCZ3JBUGJYanliQThRTGtCSzd3SU92aDYxelBOZE9GaXdl?=
 =?utf-8?B?cDhJWHpYTmM2V3NYS3dHZWIza0ZYSGdadUk3QlhodnZrN2VpL2Ezb1V3WTl2?=
 =?utf-8?B?WDV6WWpmRC9XdXd3WnVoeWpjTm9GOGhXNGVyanhBeTg5SytxWHdrOTY3T3pN?=
 =?utf-8?B?dXI0b3liWmZCZlRPanlRWncweVNMSDl4S1NLY2pvQnFZVis2MFRWTkkwUlJj?=
 =?utf-8?B?azdROC9WMmoxVTYrUVdBTmpLbWlYM05NMk44UDlvSVNKSW9qeU0xWXBkMFU4?=
 =?utf-8?B?cXFuR1ZmRkdTK240VndMVWZFVWdCdEtvcVVmbjlIRit2NDFoWmU1eXA2ODNu?=
 =?utf-8?B?RjNNOUxiY1JXRFBVcExVUE9obVEwdGFnM3U4M1BUT3d4STJQSzlQbEIyWmIx?=
 =?utf-8?B?Z0VvMGxkbC8zQXpNN1dVcUx6a28rcXpyS1J0MnZ6emRld01lMmNoUHBEVFJt?=
 =?utf-8?B?Z1Y1S3R2NUFNcDc0eW15S1hoeVBkVjEzOWxZcGo1WVNnL1JwV1V5aHU1TVc2?=
 =?utf-8?B?eFlTOWl4QlRiSEVRME4yZW8vcGY0MzZ4dTRnTmdueVFqTHdJelBub2owS3p4?=
 =?utf-8?Q?eCZfCHsC84KrpEx0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E731FE0A2B089478DCC1A800C085F73@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ZcPMXzHI8JeTfp2FFB7IBZoPctJoLqNJVWYZyTSBx7M0kuug5IXT/aEu1kNHXicr6W4MgFd7q3fMymHPKtdBny55p2mFeLkrj1H4hmi/jFdNKFEN7AjWKKCIDYAmt65GxzeAcubOpuOiYCMGQl4YSx4+lGgd7wFOjkB6TzwQRxdH251ly4DtvQ1zYB9fxpnjZ1ofTS5pNfafwYWYho94Ku8VqYlxPV3MORA4+l48ElLUhB9mDxWxW5TerdZeRPML2UuV9vT4u6+D+zssww5N27HLeFz7Ihpa5bkxsLFMsRkSwzn0Uf390nlcCaEKYn4Z3l5OQDerEMqOfrLD5LuD2Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506287c4-c068-48d8-9885-08deeec7d450
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 05:51:56.0794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IcQ19/SjUafmTVbPQPquYGlrfp9xxVN5l6lqnZK6msgWuyb8dzP2hVCgtGp3DwBJ9dtGRw6MxBzxndhRyMTobhKlD7eENriKbVBWFj9tjWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8206
X-MTK: N

T24gVGh1LCAyMDI2LTA3LTMwIGF0IDExOjQ5ICswMjAwLCBMb3Vpcy1BbGV4aXMgRXlyYXVkIHdy
b3RlOg0KPiBGcm9tOiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xs
YWJvcmEuY29tPg0KPiANCj4gVGhlIE1lZGlhVGVrIFVGUyBkcml2ZXIgY29udGFpbnMgc3VwcG9y
dCBmb3IgYW4gdW5kb2N1bWVudGVkLA0KPiBub24tdmVuZG9yLXByZWZpeGVkIHUzMiBwcm9wZXJ0
eSBuYW1lZCAiY2xrLXNjYWxlLXVwLXZjb3JlLW1pbiIuDQo+IA0KPiBTaW5jZSBpdCBpcyBub3Qg
cGFydCBvZiBhbnkgYmluZGluZywgYW5kIHdvdWxkIG5vdCBwYXNzIGEgYmluZGluZ3MNCj4gcmV2
aWV3IGluIGl0cyBjdXJyZW50IGZvcm0sIHJlbW92ZSBpdC4NCj4gDQo+IFRvIHJldHVybiB0aGlz
IGZ1bmN0aW9uYWxpdHksIGl0IG5lZWRzIHRvIGJlIHJlc3VibWl0dGVkIGluIGEgc2VyaWVzDQo+
IHRoYXQgYWxzbyBpbnRyb2R1Y2VzIGl0IHRvIHRoZSBiaW5kaW5nLCBhbmQganVzdGlmaWVzIHdo
YXQgaXQgaXMgdXNlZA0KPiBmb3IuIENvbXBhdGliaWxpdHkgd2l0aCBkb3duc3RyZWFtIGRldmlj
ZSB0cmVlcyBpcyBub3QgYSB2YWxpZA0KPiBqdXN0aWZpY2F0aW9uIGZvciBpdHMgZXhpc3RlbmNl
Lg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFuZ2Vsb0dpb2FjY2hpbm8gRGVsIFJlZ25vIDwNCj4gYW5n
ZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBO
aWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPg0KPiBT
aWduZWQtb2ZmLWJ5OiBMb3Vpcy1BbGV4aXMgRXlyYXVkIDxsb3Vpc2FsZXhpcy5leXJhdWRAY29s
bGFib3JhLmNvbT4NClJldmlld2VkLWJ5OiBDaGFvdGlhbiBKaW5nIDxjaGFvdGlhbi5qaW5nQG1l
ZGlhdGVrLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIHwg
MTkgLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE5IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgYi9k
cml2ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiBpbmRleCA5MGM4NjA2ZDg1YTku
LjVkZDcyYjgyNjE4MSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWsuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+IEBAIC04ODAs
OCArODgwLDYgQEAgc3RhdGljIHZvaWQgdWZzX210a19pbml0X2Nsb2NrcyhzdHJ1Y3QgdWZzX2hi
YQ0KPiAqaGJhKQ0KPiAgCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3Zh
cmlhbnQoaGJhKTsNCj4gIAlzdHJ1Y3QgbGlzdF9oZWFkICpoZWFkID0gJmhiYS0+Y2xrX2xpc3Rf
aGVhZDsNCj4gIAlzdHJ1Y3QgdWZzX2Nsa19pbmZvICpjbGtpLCAqY2xraV90bXA7DQo+IC0Jc3Ry
dWN0IGRldmljZSAqZGV2ID0gaGJhLT5kZXY7DQo+IC0JdTMyIHZvbHQ7DQo+ICANCj4gIAkvKg0K
PiAgCSAqIEZpbmQgcHJpdmF0ZSBjbG9ja3MgYW5kIHN0b3JlIHRoZW0gaW4gc3RydWN0IHVmc19t
dGtfY2xrLg0KPiBAQCAtOTE4LDI0ICs5MTYsNyBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX2luaXRf
Y2xvY2tzKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEpDQo+ICAJaWYgKCF1ZnNfbXRrX2lzX2Nsa19z
Y2FsZV9yZWFkeShoYmEpKSB7DQo+ICAJCWhiYS0+Y2FwcyAmPSB+VUZTSENEX0NBUF9DTEtfU0NB
TElORzsNCj4gIAkJZGV2X2luZm8oaGJhLT5kZXYsICIlczogQ2xvY2sgc2NhbGluZyB1bmF2YWls
YWJsZSIsDQo+IF9fZnVuY19fKTsNCj4gLQkJcmV0dXJuOw0KPiAtCX0NCj4gLQ0KPiAtCWlmICgh
aG9zdC0+cmVnX3Zjb3JlKQ0KPiAtCQlyZXR1cm47DQo+IC0NCj4gLQlpZiAob2ZfcHJvcGVydHlf
cmVhZF91MzIoZGV2LT5vZl9ub2RlLCAiY2xrLXNjYWxlLXVwLXZjb3JlLQ0KPiBtaW4iLA0KPiAt
CQkJCSAmdm9sdCkpIHsNCj4gLQkJZGV2X2luZm8oZGV2LCAiZmFpbGVkIHRvIGdldCBjbGstc2Nh
bGUtdXAtdmNvcmUtbWluIik7DQo+IC0JCXJldHVybjsNCj4gIAl9DQo+IC0NCj4gLQlob3N0LT5t
Y2xrLnZjb3JlX3ZvbHQgPSB2b2x0Ow0KPiAtDQo+IC0JLyogSWYgZGVmYXVsdCBib290IGlzIG1h
eCBnZWFyLCByZXF1ZXN0IHZjb3JlICovDQo+IC0JaWYgKHZvbHQgJiYgaG9zdC0+Y2xrX3NjYWxl
X3VwKQ0KPiAtCQlpZiAocmVndWxhdG9yX3NldF92b2x0YWdlKGhvc3QtPnJlZ192Y29yZSwgdm9s
dCwNCj4gSU5UX01BWCkpDQo+IC0JCQlkZXZfZXJyKGhiYS0+ZGV2LCAiRmFpbGVkIHRvIHNldCB2
Y29yZSB0bw0KPiAlZFxuIiwgdm9sdCk7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2b2lkIHVmc19t
dGtfc2V0dXBfY2xrX2dhdGluZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiANCg==
