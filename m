Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB68F35C6A8;
	Fri, 31 Jul 2026 05:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785476895; cv=fail; b=kI21iDlUWuIn85/DsFfVSS++V6S/haSMT5Y1lXgFartmDdd5uzqOHXGPL7D+1IB5ule8I7Ctl8DQ89OEgP1OOQq8DZDN6w7CJQBF0JfVlacd9ti7RRhQm4tW88BWyW9zu36aKGkNLvxHxk1Tu3HyYhJMHKi4c5NurWGTSsPQrYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785476895; c=relaxed/simple;
	bh=/xqBE6tqwlC5Fz8/uTEFqlzbqdZt5lmnqgjMpsAdTNs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HKGmGjfYqjSQdVx1xQjBeZaKpXzTCiyVtyZSpEryNQ7PkVeRb3yGHNOwAk3/w5mkBQg2rsMLwiA5pR8JpnAJUDJKbgrbjeto20dn2Ke+arOxTex3CvoIn8VE/CQsMSnXbGfhINzNYNznp8OSxqGiik8IT/RzMmWaGoakHcWs5/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=MdBEEM1d; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=sTySTJRV; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MdBEEM1d";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="sTySTJRV"
X-UUID: 647899348ca311f1b1788b6acf885367-20260731
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=/xqBE6tqwlC5Fz8/uTEFqlzbqdZt5lmnqgjMpsAdTNs=;
	b=MdBEEM1d8mcjL5DQoUN7Vl8uc8e7EwhrX2aWZFqAzspSVkbvGIQWB639gIRDblT3+D2gKbM/nVC/4ZRl5tit2//bKttzUa79yfOVctRng2uhSdUkm+HY42BMgJP3BlWmDbrK/jUe9iuNaZbLeA9TdqmGyWAJlMHXM9aaMa7jb3E=;
X-CID-CACHE: Type:Local,Time:202607311348+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:dfc5f154-29a2-4b21-8db6-0ece6fef5735,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:bceba66c-3b50-4451-bcf8-9f950fd136e5,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 647899348ca311f1b1788b6acf885367-20260731
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 155632674; Fri, 31 Jul 2026 13:48:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 31 Jul 2026 13:48:01 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 31 Jul 2026 13:48:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e9izN1yn67icWhOrpPVv4riR1ESDmeti2mTq4Yimmqznmxp7oLK5AG9a8K8HmWfwPmVy9xv2ahaLgTTQWM+VoNEB9uPkrzkBf2bvhR5CuxsSckCl8fyGWIm+d9l6X58iblG3ZgKMfsiSa7N8LTz2kdUlvCfcKXxxa2t0U4JqKbN/mvUK3P52+8YaAwt9JL2NEIew8VffC7UkN0yHosehu+urO8Rsd91l/L01gCuyhF0MESgZHR1Hl27s8nmTfkmHPUKjQnHoEKKqlZKsDUGGQY9xHTcsl7D0wH/v4urPLdcmMZoQHAiZ/BlrtBryV3aGBaNWktF1CrdTBMaVkRhEIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xqBE6tqwlC5Fz8/uTEFqlzbqdZt5lmnqgjMpsAdTNs=;
 b=v+wnQq6OXWypuFLrKallupkVOw/NjmdPOPofOSJiJv5cPdikS1S9wHM1u6TplaAK85OnaRcREEfJt6gN2bHwUbk2ChTILzdvka3wjFZg0L7Vbr+Xgi3FkctUGOErLGSykJmjrbqa1JXPToV2K5FFTR/5EhSALHNmdRJ6Zdwxg9/ckZ5i8/KCWe1x3L5AhduQXVVIBjMHCTkCoJvRiRQGmChoA/NFlj//tcXrk/dVd1w0BOWRI8WLAMxXHmIhqbvt4OMFAHgAruquxiH8sNCy1VBeS+ii4jOmkY0MeB6ruMQ9E3zM+8F/oACi10+2FA0yt0e3+XBTK5Z8ej0N+c5ajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xqBE6tqwlC5Fz8/uTEFqlzbqdZt5lmnqgjMpsAdTNs=;
 b=sTySTJRVGwxhB87WwHFvSTuolqV8cw51Ak0erv0R6Nk1I6eZus06H/beFm4ufUzKZ1EPD28LULclhZP+EJoYiUdBxDwZITA8rfuvmNI+ZZO9w0zUJFT39eDuYaCt9iaeu9U5vda0VxYTy3nvyNSaAr/S3IEFmI8bRYfN/Ie2x/o=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by SEYPR03MB6901.apcprd03.prod.outlook.com (2603:1096:101:b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 05:47:55 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 05:47:55 +0000
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
Subject: Re: [PATCH v10 02/26] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Thread-Topic: [PATCH v10 02/26] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Thread-Index: AQHdIAjlejjAJrJCDkmO6vuRUDGfa7aHIDCA
Date: Fri, 31 Jul 2026 05:47:55 +0000
Message-ID: <682a5f2d0caa99575af6b3b1bacf1dae98b99361.camel@mediatek.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
	 <20260730-mt8196-ufs-v10-2-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-2-bc5ecef202dc@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|SEYPR03MB6901:EE_
x-ms-office365-filtering-correlation-id: 1323daf3-74c8-4e56-ff51-08deeec744bb
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|18002099003|22082099003|4143699003|11063799006|3023799007|38070700021|10067099003|56012099006|921020;
x-microsoft-antispam-message-info: KrDW0y+ZKOcn755qB9R6lhq4V1L2l0MtmMXeAAHYN9y/8WqE4Jt1+yv0IlifCGTit8x+Sr92XSslATg5wvSuHobjKtcf/qSKR/xsaOPGEgakQ3uJJIZU5pqAdBkNSiLjDFoY+sGdT0+/wJPv6pIbpHxMrr67ZapAi+jcUYCVJEcLAIhjhKguUXAjeZZ9rZ6d+HZ2LOkLVwTBpz/OlQnSdLqjGIMPrFFE21zh7xRFLlvjTbMzalm1snO9TI0X4dCzhmAJ756eVqYZ4hQ9G+ptwQGhv1e7PCIivWNMOBS2S8aS0A21lq+KMhDxlVT0SNT1Nt/BniK4QQwqLFmJ2F0MiPPD9QxBp5ts7Svz0oDG15MkWkqNwhjn7FHVySQuNY6TV+Zo493ju9/XOWtnsrhEF341SiM3+pJ0HcX7crAkzZTETdcloZOKrxtRdxfvdKu0e6x6dAIK1AAi/9w/Yi0RzURbrkYlhEcD/Uc+cENoD6SyM9t9hgX2ABHx0z14VueRPlt9Y+JPovgIVjzIrOAqSqSI2XZkqxbL2h6/lx0YcHATpT21+edvE/ZL5s8qONKT+5n/eXbWKY9wG4AwQ2wzQ7PRknEqcwV/lBZvBkX6BFH921tsH9s7zbgKnZ669fUlI7A5DHBUkVQZMOvrUc1hmpN3485LeMpvQ2lJT/wh8E2pO+9DmtvqDm+j+g40VpYOggt7EMEqmNPFeH7qg0Ac6T0U7ttSzXcMAO5BwEySs1o3wpBMuakxdTj/xJKulBv3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(4143699003)(11063799006)(3023799007)(38070700021)(10067099003)(56012099006)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGJodS91Nkk1QU9VaCtaMkFXQlZKdTFhNSs0a3QxYjBXUGpBRDJjRHhEb1BU?=
 =?utf-8?B?Ky9JVVU1YlJ5SDFXWUNFNTFUZEZrS3lMYjRpb3plbVFOdld2U0xGNHZUcWhy?=
 =?utf-8?B?TEN6RVBHaDJVWTBSanZaTkVxblNrU0NPWnRIeFMyQXIzcHhUOTJHV1Aza2tH?=
 =?utf-8?B?RmlSZDVFZURtMGozbXB4b0dkU3F6STFLQkI4T0pRL1FNVXFTWmtZeXIrODg0?=
 =?utf-8?B?b2VQeE9lZ1djc0UyamFaRDJLNDNtOWJiS21kazZhWGMrRXowcG5IT3lVdDZu?=
 =?utf-8?B?dW1rNVZJa3h3YmtyNzB5ZFdDSHBJWitRbDNCalpzSWZGTVVlZWZBdFRXakJP?=
 =?utf-8?B?L3ROK3BORThEVm5XRnoxT1ZaK0pqQmU0UnZsRjA3Si8wd3JjTXdadnlkN2lh?=
 =?utf-8?B?UC9PUjVYZVdYYUthQ3lubjFEUzJFMkVWakROK3VSVnM2RFAyY2NocTFxRkxZ?=
 =?utf-8?B?amd0eUZTQitmTVVRV25acE4ya2NrNUtYWm9LeW5uRlQwM244aWRWZjk3aXRy?=
 =?utf-8?B?dGd0V216RnYzNVllL0FFL2o3OVN4T0ZORmx4L0EzK2ZDVldXNDVmVlZiak1x?=
 =?utf-8?B?ZFZNL2F6a3FxaGlxdkRKbTEreC9yb2owSEdwVDUzOVdlRGI5a2xVOWdKY3Iy?=
 =?utf-8?B?MUlTMG84LzRmdFFNdDdCRWh6NHZtOFJ0R1Q5M0VMSmtNNjBiUWcvRUtaeXV2?=
 =?utf-8?B?THNucFZCaTV1Ym0xU0pPMjhyb3N6Y2h0NUFpN1V5ZUc2NEJZL1kxS3RvVzJH?=
 =?utf-8?B?VnZna3ZRVlQ3MmdTUTFRTmRjcTI3M1ZVbDUwVmdhbERISmZVbWxINjltYlIz?=
 =?utf-8?B?T0RtNlJROTZ3UWFKUmJyRmxXTlFNblNQWTVTNlFvd2JKRy9HVTUzZDVNZHd4?=
 =?utf-8?B?RTAvQWlnRnp4SlJUM1N2UmJHVFJ4SUFiVkI3Y1lhc25PUXpWUDB1cWRzZVFy?=
 =?utf-8?B?S2pBR2pHMkpwdUk2eTRjZlkrY2JVd1RHd21LL0VzSHBwcW5BVGd3aG9YazAv?=
 =?utf-8?B?TmF2M01vRnVaZFRDRjFLaVp2QnpqZmFuN2p6SytkSnpYbXhrNWswZnI1MXBx?=
 =?utf-8?B?d1l1cUFrMWpQalltcGs0ZWhuTlRkRlplMDl2UFlCMnpMUU00Zmt6REl6L2lO?=
 =?utf-8?B?dGMwK3ROODV2VkhOekthZGFHdDAycHd5VEt5dVZteHJSbnNWWkEvYWhMc2ZF?=
 =?utf-8?B?Y0xVdk5PUVRzdmxpQS9HVDk0bWt3L3F6T3RZdjgyRkV3a0cyOFlqMWtvVTht?=
 =?utf-8?B?ajRUT0w4WUN2VUozcjN1aEtqckFVZUxOK3B1VlRoOG04QTRyaTFhLzc2RVlC?=
 =?utf-8?B?ZkQ3WXZoNHhyVTZEWUJJcXZPSHQ4b28rVk9tSVA0SmFZNll5Y1FTbzNQNXVG?=
 =?utf-8?B?bi9VNFZRbnNlNytZQytweHBld2xUZkRxMkdtdVJqUzJVZHd6UGllNEN5WjBo?=
 =?utf-8?B?cEsrblJZWXpwUFo4bG9CbEZyRituRXZtTE9velVsVEFqUzhHSGRYMncxcVM4?=
 =?utf-8?B?Q1l1YU40d1FLcVlrZnpEZVlNbnd4QnJCREM0dVJML0pCZXpPalpFZ2ZTMElC?=
 =?utf-8?B?ODZSamdMOERtZ0lnV0t3UzZMWkd0MHJEcG0rb0VNT3ZrU0IrbDI1c1RES3Bx?=
 =?utf-8?B?WHVoNHd0emZXOW1LZWlPcklIR0ZmZDROQ1I3WkdjV0F0Y0lleXZjbXlqWlEr?=
 =?utf-8?B?ZVBETzl1L3c3Y2NrVS9tSGh0SDR6VFVFTE9wUCtmT0xIeS82cWRSdjNEMEd5?=
 =?utf-8?B?aVZoSnIyeG5kME4xbmFPNjNpL2RRdS9zNWN3WmROVy9LcEhKUm4xeVErdFV6?=
 =?utf-8?B?eHpmUldHcHVraEhicGRQR3BaaCt0blRQd2RwRmkxSVpiMlhwV1dvc3VnbHly?=
 =?utf-8?B?UWFXTVllRmNQMHJHeE9KVjFCMmI3Sy85SGpEQ1JnOTZOdERMeVMwOFJ5NSsw?=
 =?utf-8?B?bUhpeWFWSkc1Nzg1RHV4WUdVSU5ZZ0JMaHpYc1N2WjVpVUFNck5IYzVPUm8r?=
 =?utf-8?B?UDViVThLVHlkN2E1NlQrSGl6endxa214Z2xvZWc4cm1sbkpRVWtkRjNuUXdj?=
 =?utf-8?B?a0JEWjF0QWpIY0x2clZ5aWY3MHZmVHlZSnhEK3FsYXU0MzZ4NnB6alc4S1RW?=
 =?utf-8?B?OVV4ZS9zZ0FVbHY2cnlDNkRmdGxwb2dQSFRzUDJrdXlYOXRxVHdVK2Rob2Nh?=
 =?utf-8?B?dkxVWFp5L2JRb1h1Y3E4WncxTC9WVCtyWXZWMWdSOHJYK0FnTlUrbWtLeVhn?=
 =?utf-8?B?Nlk2ZnJab29mSWRoRG81d0c1VGRlVGlxeXlKLzFvQktkNDd3a0VDckJRdXNj?=
 =?utf-8?B?Z094bkZyaDIvYUlHTnhxVCtkZ1djN2tIcW96UjVCUlNRSnlJNUxVQXUvME02?=
 =?utf-8?Q?Ft+c8Ll1RWR3BwGw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F28C1D36C03F6C4F912119FE18632A8F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Hkp4Td+lOwgasB10t2pHuIFDs2+ucPcJgOZmFiCEFafay04lqCvacp8dZhi5mVSgi6KB5KNhkYXLqDd1pGwzmDhHWq2kUomFDBs+MpVfXhvkaAP64ei1zzhaeM9WeJT8bywBYProb4Fhy8V7pkB/NT+rf4LiRiNtoiPzAqF9748gMotUBIhpdxrSsgDLtMn6Gjf1lCsuwiA+dwug/nnFlA/f9NaawoBe3m76kkA1EAAInpJHOPsKeJDfLc7TK7lBMlvHtrzqIyzQqEoa7uOUIqVYw7VWSKzmODO148hZ5Z09qGrlMK1t/8eP4BBZ3sfnYG6DH21w98sV+tl5oMpHLQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1323daf3-74c8-4e56-ff51-08deeec744bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 05:47:55.1812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VOT+OGkI3O1wstNxGqfRoQoUfo0B5Bk4yMJO3wLgx/Sz7Ce4pQs8qg82TvsMyfe6ZqRdienltBgEQ5d2vFDDJqLlXeeJ74sG2MQt8D2M66Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6901
X-MTK: N

T24gVGh1LCAyMDI2LTA3LTMwIGF0IDExOjQ4ICswMjAwLCBMb3Vpcy1BbGV4aXMgRXlyYXVkIHdy
b3RlOg0KPiBGcm9tOiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xs
YWJvcmEuY29tPg0KPiANCj4gQXMgaXQgc3RhbmRzLCB0aGUgbWVkaWF0ZWssdWZzLnlhbWwgYmlu
ZGluZyBpcyBzdGFydGxpbmdseQ0KPiBpbmNvbXBsZXRlLg0KPiBJdHMgb25lIGV4YW1wbGUsIHdo
aWNoIGlzIHRoZSBvbmx5IHJlYWwgInVzZXIiIG9mIHRoaXMgYmluZGluZyBpbg0KPiBtYWlubGlu
ZSwgdXNlcyB0aGUgZGVwcmVjYXRlZCBmcmVxLXRhYmxlLWh6IHByb3BlcnR5Lg0KPiANCj4gVGhl
IHJlc2V0cywgb2Ygd2hpY2ggdGhlcmUgYXJlIHRocmVlIG9wdGlvbmFsIG9uZXMsIGFyZSBjb21w
bGV0ZWx5DQo+IGFic2VudC4NCj4gDQo+IFRoZSBjbG9jayBkZXNjcmlwdGlvbiBmb3IgTVQ4MTk1
IGlzIGluY29tcGxldGUsIGFzIGlzIHRoZSBvbmUgZm9yDQo+IE1UODE5Mi4gSXQncyBub3Qga25v
d24gaWYgdGhlIG9uZSBjbG9jayBiaW5kaW5nIGZvciBNVDgxODMgaXMgZXZlbg0KPiBjb3JyZWN0
LCBidXQgSSBkbyBub3QgaGF2ZSBhY2Nlc3MgdG8gdGhlIG5lY2Vzc2FyeSBjb2RlIGFuZA0KPiBk
b2N1bWVudGF0aW9uIHRvIGZpbmQgdGhpcyBvdXQgbXlzZWxmLg0KPiANCj4gVGhlIHBvd2VyIHN1
cHBseSBzaXR1YXRpb24gaXMgbm90IG11Y2ggYmV0dGVyOyB0aGUgYmluZGluZyBkZXNjcmliZXMN
Cj4gb25lDQo+IHJlcXVpcmVkIHBvd2VyIHN1cHBseSwgYnV0IGl0J3MgdGhlIFVGUyBjYXJkIHN1
cHBseSwgbm90IGFueSBvZiB0aGUNCj4gc3VwcGxpZXMgZmVlZGluZyB0aGUgY29udHJvbGxlciBz
aWxpY29uLg0KPiANCj4gTm8gc2Vjb25kIGV4YW1wbGUgaXMgcHJlc2VudCBpbiB0aGUgYmluZGlu
ZywgbWFraW5nIHZlcmlmaWNhdGlvbg0KPiBkaWZmaWN1bHQuDQo+IA0KPiBEaXNhbGxvdyBmcmVx
LXRhYmxlLWh6IGFuZCBtb3ZlIHRvIG9wZXJhdGluZy1wb2ludHMtdjIuIEl0J3MgZmluZSB0bw0K
PiBicmVhayBjb21wYXRpYmlsaXR5IGhlcmUsIGFzIHRoZSBiaW5kaW5nIGlzIGN1cnJlbnRseSB1
bnVzZWQgYW5kDQo+IHdvdWxkDQo+IGJlIGltcG9zc2libGUgdG8gY29ycmVjdGx5IHVzZSBpbiBp
dHMgY3VycmVudCBzdGF0ZS4NCj4gDQo+IEFkZCB0aGUgdGhyZWUgcmVzZXRzIGFuZCB0aGUgY29y
cmVzcG9uZGluZyByZXNldC1uYW1lcyBwcm9wZXJ0eS4NCj4gVGhlc2UNCj4gcmVzZXRzIGFwcGVh
ciB0byBiZSBvcHRpb25hbCwgaS5lLiBub3QgcmVxdWlyZWQgZm9yIHRoZSBmdW5jdGlvbmluZw0K
PiBvZg0KPiB0aGUgZGV2aWNlLg0KPiANCj4gTW92ZSB0aGUgbGlzdCBvZiBjbG9jayBuYW1lcyBv
dXQgb2YgdGhlIGlmIGNvbmRpdGlvbiwgYW5kIGV4cGFuZCBpdA0KPiBmb3INCj4gdGhlIGNvbmZp
cm1lZCBjbG9ja3MgSSBjb3VsZCBmaW5kIGJ5IGNyb3NzLXJlZmVyZW5jaW5nIHNldmVyYWwgY2xv
Y2sNCj4gZHJpdmVycy4gRm9yIE1UODE5NSwgaW5jcmVhc2UgdGhlIG1pbmltdW0gbnVtYmVyIG9m
IGNsb2NrcyB0byBpbmNsdWRlDQo+IHRoZSByeF9zeW1ib2wgb25lcywgYXMgdGhleSdyZSBpbnRl
cm5hbCB0byB0aGUgU29DIGFuZCBzaG91bGQgYWx3YXlzDQo+IGJlIHByZXNlbnQsIGFuZCBzaG91
bGQgdGhlcmVmb3JlIG5vdCBiZSBvbWl0dGVkLg0KPiANCj4gTVQ4MTkyIGdldHMgdG8gaGF2ZSBh
dCBsZWFzdCAzIGNsb2NrcywgYXMgdGhlc2Ugd2VyZSB0aGUgb25lcyBJIGNvdWxkDQo+IHF1aWNr
bHkgY29uZmlybSBmcm9tIGEgZ2xhbmNlIGF0IHZhcmlvdXMgdHJlZXMuIEkgY2FuJ3Qgc2F5IHRo
aXMgd2FzDQo+IGFuDQo+IGV4aGF1c3RpdmUgc2VhcmNoIHRob3VnaCwgYnV0IGl0J3MgYmV0dGVy
IHRoYW4gdGhlIGN1cnJlbnQgc2l0dWF0aW9uLg0KPiANCj4gUHJvcGVybHkgZG9jdW1lbnQgYWxs
IHN1cHBsaWVzLCB3aXRoIHdoaWNoIHBpbiBuYW1lIG9uIHRoZSBTb0NzIHRoZXkNCj4gc3VwcGx5
LiBDb21wbGV0ZSB0aGUgZXhhbXBsZSB3aXRoIHRoZW0uDQo+IA0KPiBBbHNvIGFkZCBhIE1UODE5
NSBleGFtcGxlIHRvIHRoZSBiaW5kaW5nLCB1c2luZyBzdXBwbHkgbGFiZWxzIHRoYXQgSQ0KPiBh
bQ0KPiBwcmV0dHkgc3VyZSB3b3VsZCBiZSB0aGUgcmlnaHQgb25lcyBmb3IgZS5nLiB0aGUgUmFk
eGEgTklPIDEyTC4NCj4gDQo+IEZpbmFsbHksIHJlbW92ZSB0aGUgJ3Vmc18nIHByZWZpeCBmcm9t
IGFsbCBjbG9jayBuYW1lcyBjb250YWluaW5nIGl0DQo+IGFuZCByZW5hbWUgJ3VmcycgY2xvY2sg
dG8gJ21haW4nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTmljb2xhcyBGcmF0dGFyb2xpIDxuaWNv
bGFzLmZyYXR0YXJvbGlAY29sbGFib3JhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTG91aXMtQWxl
eGlzIEV5cmF1ZCA8bG91aXNhbGV4aXMuZXlyYXVkQGNvbGxhYm9yYS5jb20+DQpSZXZpZXdlZC1i
eTogQ2hhb3RpYW4gSmluZyA8Y2hhb3RpYW4uamluZ0BtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAg
Li4uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL21lZGlhdGVrLHVmcy55YW1sICAgICAgfCAxMTUN
Cj4gKysrKysrKysrKysrKysrKystLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOTYgaW5zZXJ0aW9u
cygrKSwgMTkgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMueWFtbA0KPiBiL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy91ZnMvbWVkaWF0ZWssdWZzLnlhbWwNCj4gaW5kZXggMTVj
MzQ3ZjVlNjYwLi5lN2UzNjBjNTliYTUgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy91ZnMvbWVkaWF0ZWssdWZzLnlhbWwNCj4gKysrIGIvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMueWFtbA0KPiBAQCAtMTks
MTEgKzE5LDI1IEBAIHByb3BlcnRpZXM6DQo+ICANCj4gICAgY2xvY2tzOg0KPiAgICAgIG1pbkl0
ZW1zOiAxDQo+IC0gICAgbWF4SXRlbXM6IDgNCj4gKyAgICBtYXhJdGVtczogMTANCj4gIA0KPiAg
ICBjbG9jay1uYW1lczoNCj4gICAgICBtaW5JdGVtczogMQ0KPiAtICAgIG1heEl0ZW1zOiA4DQo+
ICsgICAgaXRlbXM6DQo+ICsgICAgICAtIGNvbnN0OiBtYWluDQo+ICsgICAgICAtIGNvbnN0OiBh
ZXMNCj4gKyAgICAgIC0gY29uc3Q6IHRpY2sNCj4gKyAgICAgIC0gY29uc3Q6IHVuaXByb19zeXNj
bGsNCj4gKyAgICAgIC0gY29uc3Q6IHVuaXByb190aWNrDQo+ICsgICAgICAtIGNvbnN0OiB1bmlw
cm9fbXBfYmNsaw0KPiArICAgICAgLSBjb25zdDogdHhfc3ltYm9sDQo+ICsgICAgICAtIGNvbnN0
OiBtZW1fc3ViDQo+ICsgICAgICAtIGNvbnN0OiByeF9zeW1ib2wwDQo+ICsgICAgICAtIGNvbnN0
OiByeF9zeW1ib2wxDQo+ICsNCj4gKyAgb3BlcmF0aW5nLXBvaW50cy12MjogdHJ1ZQ0KPiArDQo+
ICsgIGZyZXEtdGFibGUtaHo6IGZhbHNlDQo+ICANCj4gICAgcGh5czoNCj4gICAgICBtYXhJdGVt
czogMQ0KPiBAQCAtMzEsOCArNDUsMzYgQEAgcHJvcGVydGllczoNCj4gICAgcmVnOg0KPiAgICAg
IG1heEl0ZW1zOiAxDQo+ICANCj4gKyAgcmVzZXRzOg0KPiArICAgIGl0ZW1zOg0KPiArICAgICAg
LSBkZXNjcmlwdGlvbjogcmVzZXQgZm9yIHRoZSBVbmlQcm8gbGF5ZXINCj4gKyAgICAgIC0gZGVz
Y3JpcHRpb246IHJlc2V0IGZvciB0aGUgY3J5cHRvZ3JhcGh5IGVuZ2luZQ0KPiArICAgICAgLSBk
ZXNjcmlwdGlvbjogcmVzZXQgZm9yIHRoZSBob3N0IGNvbnRyb2xsZXINCj4gKw0KPiArICByZXNl
dC1uYW1lczoNCj4gKyAgICBpdGVtczoNCj4gKyAgICAgIC0gY29uc3Q6IHVuaXBybw0KPiArICAg
ICAgLSBjb25zdDogY3J5cHRvDQo+ICsgICAgICAtIGNvbnN0OiBoY2kNCj4gKw0KPiArICBhdmRk
MDktc3VwcGx5Og0KPiArICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAwLjlWIHN1cHBs
eSBwb3dlcmluZyB0aGUgQVZERDA5X1VGUw0KPiBwaW4NCj4gKw0KPiArICBhdmRkMTItc3VwcGx5
Og0KPiArICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAxLjJWIHN1cHBseSBwb3dlcmlu
ZyB0aGUgQVZERDEyX1VGUw0KPiBwaW4NCj4gKw0KPiArICBhdmRkMTItY2tidWYtc3VwcGx5Og0K
PiArICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAxLjJWIHN1cHBseSBwb3dlcmluZyB0
aGUNCj4gQVZERDEyX0NLQlVGX1VGUyBwaW4NCj4gKw0KPiArICBhdmRkMTgtc3VwcGx5Og0KPiAr
ICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAxLjhWIHN1cHBseSBwb3dlcmluZyB0aGUg
QVZERDE4X1VGUw0KPiBwaW4NCj4gKw0KPiAgICB2Y2Mtc3VwcGx5OiB0cnVlDQo+ICANCj4gKyAg
dmNjcS1zdXBwbHk6IHRydWUNCj4gKw0KPiArICB2Y2NxMi1zdXBwbHk6IHRydWUNCj4gKw0KPiAg
ICBtZWRpYXRlayx1ZnMtZGlzYWJsZS1tY3E6DQo+ICAgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMu
eWFtbCMvZGVmaW5pdGlvbnMvZmxhZw0KPiAgICAgIGRlc2NyaXB0aW9uOiBUaGUgbWFzayB0byBk
aXNhYmxlIE1DUSAoTXVsdGktQ2lyY3VsYXIgUXVldWUpIGZvcg0KPiBVRlMgaG9zdC4NCj4gQEAg
LTU0LDI5ICs5Niw0MSBAQCBhbGxPZjoNCj4gICAgICAgIHByb3BlcnRpZXM6DQo+ICAgICAgICAg
IGNvbXBhdGlibGU6DQo+ICAgICAgICAgICAgY29udGFpbnM6DQo+IC0gICAgICAgICAgICBlbnVt
Og0KPiAtICAgICAgICAgICAgICAtIG1lZGlhdGVrLG10ODE5NS11ZnNoY2kNCj4gKyAgICAgICAg
ICAgIGNvbnN0OiBtZWRpYXRlayxtdDgxODMtdWZzaGNpDQo+ICAgICAgdGhlbjoNCj4gICAgICAg
IHByb3BlcnRpZXM6DQo+ICAgICAgICAgIGNsb2NrczoNCj4gLSAgICAgICAgICBtaW5JdGVtczog
OA0KPiArICAgICAgICAgIG1heEl0ZW1zOiAxDQo+ICAgICAgICAgIGNsb2NrLW5hbWVzOg0KPiAg
ICAgICAgICAgIGl0ZW1zOg0KPiAtICAgICAgICAgICAgLSBjb25zdDogdWZzDQo+IC0gICAgICAg
ICAgICAtIGNvbnN0OiB1ZnNfYWVzDQo+IC0gICAgICAgICAgICAtIGNvbnN0OiB1ZnNfdGljaw0K
PiAtICAgICAgICAgICAgLSBjb25zdDogdW5pcHJvX3N5c2Nsaw0KPiAtICAgICAgICAgICAgLSBj
b25zdDogdW5pcHJvX3RpY2sNCj4gLSAgICAgICAgICAgIC0gY29uc3Q6IHVuaXByb19tcF9iY2xr
DQo+IC0gICAgICAgICAgICAtIGNvbnN0OiB1ZnNfdHhfc3ltYm9sDQo+IC0gICAgICAgICAgICAt
IGNvbnN0OiB1ZnNfbWVtX3N1Yg0KPiAtICAgIGVsc2U6DQo+ICsgICAgICAgICAgICAtIGNvbnN0
OiBtYWluDQo+ICsgICAgICAgIGF2ZGQxMi1ja2J1Zi1zdXBwbHk6IGZhbHNlDQo+ICsgIC0gaWY6
DQo+ICsgICAgICBwcm9wZXJ0aWVzOg0KPiArICAgICAgICBjb21wYXRpYmxlOg0KPiArICAgICAg
ICAgIGNvbnRhaW5zOg0KPiArICAgICAgICAgICAgY29uc3Q6IG1lZGlhdGVrLG10ODE5Mi11ZnNo
Y2kNCj4gKyAgICB0aGVuOg0KPiAgICAgICAgcHJvcGVydGllczoNCj4gICAgICAgICAgY2xvY2tz
Og0KPiAtICAgICAgICAgIG1heEl0ZW1zOiAxDQo+ICsgICAgICAgICAgbWluSXRlbXM6IDMNCj4g
KyAgICAgICAgICBtYXhJdGVtczogMw0KPiArICAgICAgICBjbG9ja3MtbmFtZXM6DQo+ICsgICAg
ICAgICAgbWluSXRlbXM6IDMNCj4gKyAgICAgICAgICBtYXhJdGVtczogMw0KPiArICAgICAgICBh
dmRkMDktc3VwcGx5OiBmYWxzZQ0KPiArICAtIGlmOg0KPiArICAgICAgcHJvcGVydGllczoNCj4g
KyAgICAgICAgY29tcGF0aWJsZToNCj4gKyAgICAgICAgICBjb250YWluczoNCj4gKyAgICAgICAg
ICAgIGNvbnN0OiBtZWRpYXRlayxtdDgxOTUtdWZzaGNpDQo+ICsgICAgdGhlbjoNCj4gKyAgICAg
IHByb3BlcnRpZXM6DQo+ICsgICAgICAgIGNsb2NrczoNCj4gKyAgICAgICAgICBtaW5JdGVtczog
MTANCj4gICAgICAgICAgY2xvY2stbmFtZXM6DQo+IC0gICAgICAgICAgaXRlbXM6DQo+IC0gICAg
ICAgICAgICAtIGNvbnN0OiB1ZnMNCj4gKyAgICAgICAgICBtaW5JdGVtczogMTANCj4gKyAgICAg
ICAgYXZkZDA5LXN1cHBseTogZmFsc2UNCj4gIA0KPiAgZXhhbXBsZXM6DQo+ICAgIC0gfA0KPiBA
QCAtOTQsOSArMTQ4LDMyIEBAIGV4YW1wbGVzOg0KPiAgICAgICAgICAgICAgcGh5cyA9IDwmdWZz
cGh5PjsNCj4gIA0KPiAgICAgICAgICAgICAgY2xvY2tzID0gPCZpbmZyYWNmZ19hbyBDTEtfSU5G
UkFfVUZTPjsNCj4gLSAgICAgICAgICAgIGNsb2NrLW5hbWVzID0gInVmcyI7DQo+IC0gICAgICAg
ICAgICBmcmVxLXRhYmxlLWh6ID0gPDAgMD47DQo+ICsgICAgICAgICAgICBjbG9jay1uYW1lcyA9
ICJtYWluIjsNCj4gIA0KPiAgICAgICAgICAgICAgdmNjLXN1cHBseSA9IDwmbXRfcG1pY192ZW1j
X2xkb19yZWc+Ow0KPiAgICAgICAgICB9Ow0KPiAgICAgIH07DQo+ICsgIC0gfA0KPiArICAgIHVm
c2hjaUAxMTI3MDAwMCB7DQo+ICsgICAgICAgIGNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ4MTk1
LXVmc2hjaSI7DQo+ICsgICAgICAgIHJlZyA9IDwweDExMjcwMDAwIDB4MjMwMD47DQo+ICsgICAg
ICAgIGludGVycnVwdHMgPSA8R0lDX1NQSSAxMzcgSVJRX1RZUEVfTEVWRUxfSElHSD47DQo+ICsg
ICAgICAgIHBoeXMgPSA8JnVmc3BoeT47DQo+ICsgICAgICAgIGNsb2NrcyA9IDwmaW5mcmFjZmdf
YW8gNjM+LCA8JmluZnJhY2ZnX2FvIDY0PiwgPCZpbmZyYWNmZ19hbw0KPiA2NT4sDQo+ICsgICAg
ICAgICAgICAgICAgIDwmaW5mcmFjZmdfYW8gNTQ+LCA8JmluZnJhY2ZnX2FvIDU1PiwgPCZpbmZy
YWNmZ19hbw0KPiA1Nj4sDQo+ICsgICAgICAgICAgICAgICAgIDwmaW5mcmFjZmdfYW8gOTA+LCA8
JmluZnJhY2ZnX2FvIDkzPiwgPCZ0b3Bja2dlbg0KPiAyMTI+LA0KPiArICAgICAgICAgICAgICAg
ICA8JnRvcGNrZ2VuIDIxNT47DQo+ICsgICAgICAgIGNsb2NrLW5hbWVzID0gIm1haW4iLCAiYWVz
IiwgInRpY2siLCAidW5pcHJvX3N5c2NsayIsDQo+ICJ1bmlwcm9fdGljayIsDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgInVuaXByb19tcF9iY2xrIiwgInR4X3N5bWJvbCIsICJtZW1fc3ViIiwN
Cj4gInJ4X3N5bWJvbDAiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICJyeF9zeW1ib2wxIjsN
Cj4gKw0KPiArICAgICAgICBvcGVyYXRpbmctcG9pbnRzLXYyID0gPCZ1ZnNfb3BwX3RhYmxlPjsN
Cj4gKw0KPiArICAgICAgICBhdmRkMTItc3VwcGx5ID0gPCZtdDYzNTlfdnJmMTJfbGRvX3JlZz47
DQo+ICsgICAgICAgIGF2ZGQxMi1ja2J1Zi1zdXBwbHkgPSA8Jm10NjM1OV92YmJja19sZG9fcmVn
PjsNCj4gKyAgICAgICAgYXZkZDE4LXN1cHBseSA9IDwmbXQ2MzU5X3ZpbzE4X2xkb19yZWc+Ow0K
PiArICAgICAgICB2Y2Mtc3VwcGx5ID0gPCZtdDYzNTlfdmVtY18xX2xkb19yZWc+Ow0KPiArICAg
ICAgICB2Y2NxMi1zdXBwbHkgPSA8Jm10NjM1OV92dWZzX2xkb19yZWc+Ow0KPiArDQo+ICsgICAg
ICAgIG1lZGlhdGVrLHVmcy1kaXNhYmxlLW1jcTsNCj4gKyAgICB9Ow0KPiANCg==
