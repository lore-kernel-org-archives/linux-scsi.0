Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882F3303A13;
	Mon,  3 Nov 2025 11:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762170189; cv=fail; b=TUydhPr1eEyI6Vxra0/Kzcr5KvWxlwW3qqQqM+zytGR4A+Nx8VXwgPI/NGkTW+pCtS6qrUzTvlSbLtxw7nawFmwPzM4iTaeCY0N+A+2f2uwIajAcVR8UbYgpIlVsI1XFt0ivLdEyMeH3ys+YXkJbUyES+0KC+tmuAFSxnZgKRzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762170189; c=relaxed/simple;
	bh=NPluqcr7+9nHkvsqM3Xftd5HSXyuGUHXCzJ5OKOScyQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fv9unPLubJRJfu/1xoSuULFisTQhWP6p3TMLvb21+bIOCAfSZbdnoFkXFh8UAgw1BOG9U6crGhj4h0exZSKebFvsjj72TfwjE8KfPViYc2gXU4nuYcdkHe629isJrbz6J/ExgWLpNN3Tr8R6l3PO1H+DG59XlsI6Q2mDw1Zy+qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oUOsl0Ln; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fuvmLr0u; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oUOsl0Ln";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fuvmLr0u"
X-UUID: 3da03682b8aa11f0b33aeb1e7f16c2b6-20251103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=NPluqcr7+9nHkvsqM3Xftd5HSXyuGUHXCzJ5OKOScyQ=;
	b=oUOsl0LnQ/iztLdCfGC1JBolNXbQeanUl+L6J9I2z5WKscKee4o0uGhXbBgXGOAJR+7cPQSE3lPDaNl3xsDnC6baqh9xLkNBVTzF7gnTqZWryIxCVqrWb/Z9+R4dT919VB0Cj+78sfsDBT0VPnrzNsGhj9Q3+SA4CsyzI1AKs+I=;
X-CID-P-RULE: Spam_GS6885AD
X-CID-O-INFO: VERSION:1.3.6,REQID:56912a23-7dff-445a-be07-7a49d4715248,IP:0,UR
	L:25,TC:0,Content:100,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS6885AD,ACT
	ION:quarantine,TS:125
X-CID-META: VersionHash:a9d874c,CLOUDID:1cd7dc18-3399-4579-97ab-008f994989ea,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|110|111|836|888|898,TC:-
	5,Content:3|15|50,EDM:-3,IP:nil,URL:11|97|99|83|106|1,File:130,RT:0,Bulk:n
	il,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ASC,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3da03682b8aa11f0b33aeb1e7f16c2b6-20251103
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1049009719; Mon, 03 Nov 2025 19:42:56 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 3 Nov 2025 19:42:57 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 3 Nov 2025 19:42:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Za/NlRlmDlynWTxItCPey98PPzRRtt49lyLV8uw9B4HuEMMf4CWe93EKZFN2U4lT1aRHqiepn7UGe9jJpCvLHc72eNRgYLd0R00CP6BYXh1ZczIj+CXJWa0jZ0CPT2i7HLKMvYgZXc5XAqzdBsBfcX15vUROTrvevsKRd+tETX8+ZyuqBUcUt4rhuI1kC7OPa87GvpCncZ9X76558DAfe8Yt0sBMDUsUR5LUHioCYFZp6AXD/YZep3sTBHmUk3q/n7EQxrxdHz7EdyS/bNsEA/0+KuiNQrxVhC4JAwODfLB1dovvB5tmHQVKet63C6Br00MARAUpbDSy3ny3FFthDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPluqcr7+9nHkvsqM3Xftd5HSXyuGUHXCzJ5OKOScyQ=;
 b=rmojDhIz4Di4koRZl87eNYT/Eag3VtzjLIV6v4DD2ERsEpWhiY59eGcACSaxtEd+AI2EiwHeDtQfUjUeazbIPoK4sTA+nyRcIWIlTNvnriLg3GiI65s/4YdLRgl+rkMtjaSrkhrvvgs47LuCjzPXTbGh8G4+OOlksEGje/kiys3CU0ewXoo8xbKhoSTYijfju4tvCeS4MzYzFErtQggDnEyMPstne2l1KCMx3n1oXMO8ypyetPx+Z7HalSsjUPeQbQjnCiuUTSScHl4Dlh4kQlQkcI+mt15dr48esQ0Hl9rXPuBS/yt8Guir+cZjczhmxdrr1ZTOmH++iJsSgdTf/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPluqcr7+9nHkvsqM3Xftd5HSXyuGUHXCzJ5OKOScyQ=;
 b=fuvmLr0uDqY3KpN/J9ESASf43GYgJ0NcS8rJkq33RSgSiX+Evg9VDt/OQsl7QnrYd15yrptFL+OB2U52eZGvyC0VbknY1RasEVdFztMGOYxwBD70et8g2vVcf2yMydsFLWZ3yyBLkZpSBfjLHmATkYLfBFvrt2ZwRc9POv0Vyi4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8558.apcprd03.prod.outlook.com (2603:1096:405:6a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 11:42:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9275.013; Mon, 3 Nov 2025
 11:42:46 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"robh@kernel.org" <robh@kernel.org>
CC: "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "conor.dooley@microchip.com"
	<conor.dooley@microchip.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "wenst@chromium.org" <wenst@chromium.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
Subject: Re: [PATCH v2] dt-bindings: ufs: mediatek: Update maintainer
 information in mediatek ufs and phy
Thread-Topic: [PATCH v2] dt-bindings: ufs: mediatek: Update maintainer
 information in mediatek ufs and phy
Thread-Index: AQHcTGx8RXYjH5DcUUORcAiZ3mxaK7Tg1ReA
Date: Mon, 3 Nov 2025 11:42:46 +0000
Message-ID: <9188475a5445e9de238bf76eba29aa2a593a911b.camel@mediatek.com>
References: <20251103024831.3663689-1-peter.wang@mediatek.com>
In-Reply-To: <20251103024831.3663689-1-peter.wang@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8558:EE_
x-ms-office365-filtering-correlation-id: dd6a868c-7ed8-45c9-d005-08de1ace1bcf
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TjU5UUc3RHM4SmR0VXBBRTdITE1ETUt4TU5WcGZPdmtmeDY5Q1AwWGtET3Jv?=
 =?utf-8?B?bjAvc3YycWZKeFBFWldXd2liWkRoejFnZEVTNzhUbjFEck5ZNmkrRnA1ZGVS?=
 =?utf-8?B?WFVHSWhrTTNoampFbUd6WFduY1ZQbzF1cUgwZXR5dVg1R1ZCcnBrR0NJbWVM?=
 =?utf-8?B?VjJKLy96Mkh2Q2t0eUFqRGc5OGMwbkxCRCtoMEtRRTZacXRiZ28vK0lHL2da?=
 =?utf-8?B?MDEyYXR0c3J6VUErMDlaL1ZTT0IzRFMwL20yQXg5Z2E2Smw2SnVuYlRoS1or?=
 =?utf-8?B?VkluRDVqT2xOSzZHMmZJODd4a3ByWkphNEN3WXd5M2xqYkxzRnYxSGFvWGM1?=
 =?utf-8?B?UmV4OVZQMUpjR3E4UVRnSStKSWlBbHdSb09VaXVkNkU1LytuS2dYM3Rlbmh2?=
 =?utf-8?B?dEw4OXU1dm5iTitBUXVWMy8zTE11REVvRGtRYkhxQVlWRzNUVUo3bndNVjJo?=
 =?utf-8?B?dEE3dmtDS0lZeHo5a3hydWZNK3ErTE12QmNCL2NrRUl3SThRdU9QUmVUVzNL?=
 =?utf-8?B?Z1NlTUMyWVY3aGlGejA5YSsxVFE0TlpiQWRBbHdSTVNBZCtHaU4wQ3VLc2Vp?=
 =?utf-8?B?b1JJSWpsYVcvZWZtSTZqOExRSFAxTU4xWk1iZUJtMmMrdXcxVDRIN2tmK2lZ?=
 =?utf-8?B?WW03cmxOUHdjQkNYcVNiUGFxVkp0R3RZWHlJMTMyaEl5ajc3ZUlRcTgvOEt4?=
 =?utf-8?B?RExNOXNmNHJmOVRmS08yaHJrcHVPaG81RXFXbnRHZHlQNFhPc1V1ZExyNFNm?=
 =?utf-8?B?azFORFFoS2ZzVWgrc0hiL2lIemE2QlQvZUUyQ3lRMUk1VjFscU5pTUFSb1pX?=
 =?utf-8?B?SWFiakcxNG5HSTVERHFkT3paOWV1Rmhya1puNytyWDBaaFBGMS9LbXRabkJy?=
 =?utf-8?B?UEhwaFZnWWVGN0Z3TjZUQmdNeFZsUnQzSHVtYzhJTFV0c3o5MGlkd0Rhcm5T?=
 =?utf-8?B?UThrUFpRN2tjUUNDZ2RRaWE2Q01QdTdTblZieEE0WGN2SjMyWDNhcGxOSm9p?=
 =?utf-8?B?SDRjYmRLZ2x5Rnp0NndEQkcvYW0za08yVHBwT3dzd3BHbkxSU0lERGdMSjI0?=
 =?utf-8?B?dmlwQTIwcmFzRGdUa05uaUVVdUdvMzIvb1FBdlgrV1BJbTE0ZjJqR25QUFky?=
 =?utf-8?B?VUF0REpJRUJTOEN1eVI5UzRFOVd4ZFNtSEdYZVlSWFdzdldWV0ZVNzF1ZzRN?=
 =?utf-8?B?Ukw2aHl1eUd1RGtpY1dTOXd6U1lFU3p1NkEzOWFxcEFlTHhuaHNUZkYzNFda?=
 =?utf-8?B?bk9kZExRRjd6MXZBUWh2QmFldE5vMDk4YW1ZSGkvVC9GczAzbXZJZzEzbWpp?=
 =?utf-8?B?TWZsQTg0NXNkMENrVDBJSUtzblhSNWNaSGZFVDZXRlF6MHBFaThmcWwxRFhu?=
 =?utf-8?B?NnRMK3B2dHVnMTRMU0dQY0FqVXNINElDT1I5OEUyZ21yMW5GUEtBc0M1MXRK?=
 =?utf-8?B?dWFEZmVIOTFOcnFNbE8rUW1UQkpESUt3ekhXZjRab0JzU2h6ZGduL1dCL3dE?=
 =?utf-8?B?ZDRlZEgvWGJoNXQxOENkS0M3MlNrOTVPcG03NkVsMzdOWHpCNlp1R1VMK2dQ?=
 =?utf-8?B?eTJpWFA4NjlFNnFpclViemxhaWlVeEpwSUlveFlvbVJybHgwcE12dThVQit1?=
 =?utf-8?B?eVg4ZTROZU5jeVk0a3k4ckhlOGp2Vlp5eGlsYTc2bE5yMDBCeSt4RmpCK2xZ?=
 =?utf-8?B?Mk9kUTFtNW9DbkRqeUxNdllHNjd1L0hZM04wTEp2SnFEOEk3OTJlODVIY01S?=
 =?utf-8?B?cmNaNHhzN1NxUitqanBUK3NEY0gvMVRRanRyM1V4VGhYUnp2OEpPd29RYWdC?=
 =?utf-8?B?Sk1uc1d0SVdmOEhwOXVQbmVLME1TQXY2bzVTOFVMSk1LQmZUcjhwRzREZTRO?=
 =?utf-8?B?YjRJNlVOdFFlVnFoUzAyZCtGZzVObnNoNk9wUEFIMzBXb2pjdVBlaFBWK0J2?=
 =?utf-8?B?UzZIb1BBY3NxZzFnREowUmlPN0V5ZzhRWjNaekpXb2IxNWI2Vmo5VCtoSDhl?=
 =?utf-8?B?bmd2Wmp1MGpnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S09wOHlOWEpxdU4wRnE5cUZGeTZwUkZkTGhsQTU1cjBsZE1BaUFFWVJlYTU2?=
 =?utf-8?B?bGZWSFJ1T2dEaWZKR1Vuc0NHWmhBYkpwZUVhS1YxTThkdndhOXg0dHRqVDJv?=
 =?utf-8?B?amRQY3JJcFd3Tmx2WFE0dnhOVDhIZFM5eS9hOEpqSndFaXZwV0NGQmpJdE5D?=
 =?utf-8?B?ajRKcUp4T0lJbDFYVlBCMmZJdHI2WXgvZTlCeWI5aStHbmxidTdNdUgyQkVC?=
 =?utf-8?B?VnFWQTg3VGFFL0xYSjNlcStpLzdvOGxUeVpDSGVQUVdyWVVTOEZBV2hyTW5R?=
 =?utf-8?B?SmxpT3BHQndZZVZqclpkSWhPZGFvNmdrRGk0M1NnSWw5VmVNZlAvVjR1REc0?=
 =?utf-8?B?T04vL3IxNU84ZFFzZDVUVk1mT25seFoySFptSzJyMWZEYlF2Ui9QaTFEa0Ft?=
 =?utf-8?B?VE8veXJkenM1d2ZaRzNmKzVtaldsR1hOUDNVSzVvSm1HNkdxZUJOZHc4SGQ1?=
 =?utf-8?B?ZTVBMXRJQTMxMkhvMmdPMjJyN2pLdE9iUzhRdmkrMUd6SU5lVDRncEcyMUFB?=
 =?utf-8?B?Mlc1cTcvNkFCS1J6cmNONHVQNjVlMEdDT28wSUlkV0JQdlEvSVBSMFBDT3Ey?=
 =?utf-8?B?cDJ3aW16YmQ3cUMwdVBuSkhFaTZ2MUR4Qlp2QWRQcUhaZXBobUxKSlFkcW1U?=
 =?utf-8?B?OERSRmFhTWFYQW40blBhUDJhUHNsZFUzQWN0RFhHbVZTa3dKNC9zdGZwTE5y?=
 =?utf-8?B?dVVhQUxuZXVybXJNYnRjTm1GSEFPc3J1SytmUWNrZVYxVGR2U2ZRVHZvR2FN?=
 =?utf-8?B?dTVwcFpRWTF3UFZLQXZvb3NmeWluNGhZdms0K1NqN2QyRGQ1aXN0MVVwUEx4?=
 =?utf-8?B?Q05GRzY1OVVIempmdVprVFpxSUlzQ1JlVFhrbnh6TFptMGpZSHVQbGluNzB2?=
 =?utf-8?B?RENKY3pHcjZMRWtCbnk4dldoTXp5STMwWVlGRWpENUNiRSs2dUl4RlFRUGhD?=
 =?utf-8?B?YVJsVU80SXN1aURsR0YvM1h3TVBlTDJzYm9wcStod1NZcmlQMElJcmNSZG1D?=
 =?utf-8?B?UG9HN01lS0hZMVBMK1VkaEN6M3hISk5OVSt5YjhrdlB1REtmLzdGL2Nhd1hw?=
 =?utf-8?B?ODkxeDdDd3FoR1laaFZkR1paUWYvMUIzbmhOaTdhbG1iYTVidWNBOUErWHhk?=
 =?utf-8?B?WUZTSG1PVFQ1Y3lxcmI1ZTY5NkNmYXVlZEhuYnJycDFRRGdoNnNkOFRUL2Ju?=
 =?utf-8?B?LzFLZzhzMXdUbHZXeHhWdmJuVDZRTmd3WDhwb2ZHc0VSTWMzNURFV05WNkR2?=
 =?utf-8?B?cStvbkl5U05zR3UwVndLdk4xZUNVV3pubm4vdWRHMHY0blpsamdNVHJxRWUv?=
 =?utf-8?B?andFMDdOemlmZFIrR08zSXE2NEZ5QkYrV01uK3llaUlrcHB0ZXBNQ1FiaEZH?=
 =?utf-8?B?WHg1ZXdFdGE0ZWxrTGVodUhBdUtqMU1LNnFScEpFcTdFUEh6ZU5lcXhJY0Vj?=
 =?utf-8?B?eW1wSkRLdXJGRU1EODh4QklHdHBhWWtncjdMWHJNeTA3VUVsOWRYZm0yenlp?=
 =?utf-8?B?VU1oV3pTbmdEcEJodHJ0QjdNeEpXckcvMTRqbkpaa0RIQlhEQ3dPcHVBOFE1?=
 =?utf-8?B?TDhhMnMxMGpBTGs5VlNmcHpVckdVMUhnL04zN0w0ZTY2dlhab2FkMXF4M2ZB?=
 =?utf-8?B?U1dZZ0hlSzNlOVV5bWpNb1paY1QxSndWNGo0VjF6dEl6enVBd1M1ZVRYMSt6?=
 =?utf-8?B?bUt0VlgvQ2FkdURnd0Vmemd5VzE5ekF0L0tXdGRVYTU2T09nV2YwQmlCKy9z?=
 =?utf-8?B?UG1NdWdvdUJ4ODd6d0VsMGo0YWhCbnZ1WE1FQUdkL3phRloxUTFCSFlQaTEz?=
 =?utf-8?B?U2pGQXBmME5nSjVMNUJOcDdNdm5QWlVaRDNGNlF6c29oT0hVUTV1V2l2Vm0r?=
 =?utf-8?B?T0V1dG1ad0xmd0phKy93b1poNUhJa2E5cy9CV3FjMjZ5aUpSaHpJNllIWWRB?=
 =?utf-8?B?eWVrTGN2V3BWYXJQTElibUFtQWF2eTB2QjBlUXpFbXJjS012SThRUTJreGJF?=
 =?utf-8?B?Tm9Mcm9WVlp1aUpNNTNLQTQ5dW92dEF5L2NPZ0h1bHR0ak9QNWtmQ0Y0a1g2?=
 =?utf-8?B?M0NWVmhPaHV3Mi9iOWw0UGw1eEdyMC95dFJCcDZWYVQ5RGZYMWF3VmhoblRy?=
 =?utf-8?B?NmRXbjNyckl5aDZIcS9VdEpHeHlWeFVNVUlsUkpOQTRQcmpJOVZ3OFV0djVz?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77A4B2B39498184682C5D9BC4F6124D5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6a868c-7ed8-45c9-d005-08de1ace1bcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 11:42:46.5027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gglV8glX+BkJd8oG8YF5rNolaQSwjXd7y0Kw8/gPRlfA6N4/QpmueUawB6jyjxRmxw+ZiWnX9RB7mhR1dwFUJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8558

T24gTW9uLCAyMDI1LTExLTAzIGF0IDEwOjQ3ICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBSZXBsYWNlIFN0YW5sZXkgQ2h1IHdpdGggbWUgYW5kIENoYW90aWFuIGluIHRoZSBtYWlu
dGFpbmVycyBmaWVsZCwNCj4gc2luY2UgaGlzIGVtYWlsIGFkZHJlc3MgaXMgbm8gbG9uZ2VyIGFj
dGl2ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0KPiAtLS0NCj4gwqBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcGh5
L21lZGlhdGVrLHVmcy1waHkueWFtbCB8IDMgKystDQo+IMKgRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMueWFtbMKgwqDCoMKgIHwgMyArKy0NCj4gwqAy
IGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcGh5L21lZGlhdGVr
LHVmcy0NCj4gcGh5LnlhbWwgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcGh5
L21lZGlhdGVrLHVmcy0NCj4gcGh5LnlhbWwNCj4gaW5kZXggM2U2MmI1ZDRkYTYxLi42ZTJlZGQ0
M2ZjMmEgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9w
aHkvbWVkaWF0ZWssdWZzLXBoeS55YW1sDQo+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9waHkvbWVkaWF0ZWssdWZzLXBoeS55YW1sDQo+IEBAIC04LDggKzgsOSBAQCAk
c2NoZW1hOg0KPiBodHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMN
Cj4gwqB0aXRsZTogTWVkaWFUZWsgVW5pdmVyc2FsIEZsYXNoIFN0b3JhZ2UgKFVGUykgTS1QSFkN
Cj4gwqANCj4gwqBtYWludGFpbmVyczoNCj4gLcKgIC0gU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1
QG1lZGlhdGVrLmNvbT4NCj4gwqDCoCAtIENodW5mZW5nIFl1biA8Y2h1bmZlbmcueXVuQG1lZGlh
dGVrLmNvbT4NCj4gK8KgIC0gUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
ICvCoCAtIENoYW90aWFuIEppbmcgPGNoYW90aWFuLmppbmdAbWVkaWF0ZWsuY29tPg0KPiDCoA0K
PiDCoGRlc2NyaXB0aW9uOiB8DQo+IMKgwqAgVUZTIE0tUEhZIG5vZGVzIGFyZSBkZWZpbmVkIHRv
IGRlc2NyaWJlIG9uLWNoaXAgVUZTIE0tUEhZIGhhcmR3YXJlDQo+IG1hY3JvLg0KDQoNCkhpIFJv
YiwNCg0KU2luY2UgdGhlIHByZXZpb3VzIHBhdGNoIGhhcyBhbHJlYWR5IGJlZW4gYXBwbGllZCB0
byBrZXJuZWwNCjYuMTksIEkgd2lsbCBkcm9wIHRoaXMgcGF0Y2ggYW5kIHN1Ym1pdCB0aGUgUEhZ
IHBhdGNoIGFnYWluLg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg==
