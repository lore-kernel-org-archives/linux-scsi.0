Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6663D36AB7C;
	Fri, 17 Jul 2026 06:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784270157; cv=fail; b=P5aimYjb7kMj006ZNTzpVKCCdfP+/TRi3IbVIAkKKzwwVT2HEBf8S+V7k4J+Q5+wnE394p3KO3FFYHfeRDWZOuzriOSs/G6gBATm538q3MY6VYSP4LH8gGq3YJiip25NHa0xj2sb8P7Wh0YC7aUB8b8XIYtvmplBFfSO74XqKXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784270157; c=relaxed/simple;
	bh=D3ydcY7Iyr3c/JkLifvtDbjxSONccZ9ahbu3s/Ti4Gg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=egskctdFzZBw0WL+iZKv8EvMnfyFhQTgULgNB26rRa2fvg64RlX21RNUHNnfdrXZ9VLc4jZv3heWhrgLSJ+tvWqcMgKPG+a4EYlugFGmhM6WXMw+eycHd8hpa5B5IULPL0wU5j7ZiILx4jWT1oRrwZh+CC7+yZq2/lX7w98XkLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=MQ71gekM; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ZCo3J0VG; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MQ71gekM";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ZCo3J0VG"
X-UUID: bbaa0eea81a911f1b1788b6acf885367-20260717
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=D3ydcY7Iyr3c/JkLifvtDbjxSONccZ9ahbu3s/Ti4Gg=;
	b=MQ71gekMLXrXGE83LOMWqg5B64qJnNcMNPIIiguK2LQEkP9TT8PITmtWNE1zV2zlpOkA8LxROp1iHaAtJLKLGXYrP36eTYWxBbm3yfzYPUXpSxS2p8XAv57tjRbACQEhvv5wCcbj3v5ytYmiGohzvpYzmnLT6L4cSmLT04tXdOY=;
X-CID-CACHE: Type:Local,Time:202607171435+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:86f07141-d4c3-4805-a2f4-086876619eaa,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:b7a1955f-762a-4584-baab-4eebe609beea,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bbaa0eea81a911f1b1788b6acf885367-20260717
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 145884762; Fri, 17 Jul 2026 14:35:42 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 17 Jul 2026 14:35:41 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 17 Jul 2026 14:35:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HilL54X4j+Ha8AhigP0VdChLbWsaoDBtjU4P1eT9U0vYA00kbmNmNK4/9RRuzXHIk/szYE6TSNhiVRCWm23+tG258QHNoTZCF5w9u35gqEzg1YnkD15aWzyI4f880p9i+fN3fMqZgHZzhXwYSLSmF4mGV2H09YFXmcIsQEWWL5EmQ3qdT0iCJ9jJcJqmEmShQycuadkFhBmffMR4a61M0a7VeMUOVvg9jZJwTloXFYoRmilb98K95DgI/dkpTqeMyicGc0DMoCMFFgwVGGSoQc6llOlbsFo/IoRGHohVODNBg6cZLcITuDbAa9LaR7CnGJKWQfhlJbVwT1N8H7W5jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D3ydcY7Iyr3c/JkLifvtDbjxSONccZ9ahbu3s/Ti4Gg=;
 b=X4WQilnBM1TGCmQCdkA+VKyAre2hlYJDgJeKHkEQlhiA96QFlA4x5gAeL6Szh9UwXDoOzPrvuTo31holMSJZz+wL9AcEqf3ajhFP+zES2veeJSQ9Q7EY1Mci6psGwgh0gMOM1J05W7kjRnRNaDmeF4wlKIkTCGGVll7sFioVHmjHabNBdzU0Cjh0XWVbskxSoVkcC1/aXzvg1xWBI9aETR2wET4cc3PnsoVDZZLw5tDeXyozn/O7iJ11zO3pbymvvHP1ethRwMM33JxSKjRk4yKidwo4SPoAr7ehHJGByjebmbB9VKrW3chRkYskvAZ1BSh2mv/95iAMpQwP2XWeTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3ydcY7Iyr3c/JkLifvtDbjxSONccZ9ahbu3s/Ti4Gg=;
 b=ZCo3J0VGjg8nPQeudLPtALlMYqaghUrwh6U5mb3VwLW1xEPeHn0snIJ6I0TxEMZn8MYT0LnZwZl5HF+3FQTTWRbV57p/UZUit4l+8kzw1Y6inULO9EmAo3E4vt0DXVxc+oABi8zkUzEtFilVUXL7185CPQdTguGfX9jF3lQkJws=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8179.apcprd03.prod.outlook.com (2603:1096:101:1a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Fri, 17 Jul
 2026 06:35:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 06:35:36 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "panchuang@vivo.com" <panchuang@vivo.com>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mani@kernel.org" <mani@kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ufs: host: Remove redundant dev_err()
Thread-Topic: [PATCH] ufs: host: Remove redundant dev_err()
Thread-Index: AQHdFZ+A0Y6pSX5ueE2s+rLzBXpaZLZxQbOA
Date: Fri, 17 Jul 2026 06:35:36 +0000
Message-ID: <111ba20c5227b22b19b8924e09a4c6bce720ee49.camel@mediatek.com>
References: <20260717035013.563791-1-panchuang@vivo.com>
In-Reply-To: <20260717035013.563791-1-panchuang@vivo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8179:EE_
x-ms-office365-filtering-correlation-id: 3d46daec-fa83-4bbd-426a-08dee3cd9c89
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|56012099006|11063799006|38070700021|10067099003|921020|6133799003|18002099003|22082099003;
x-microsoft-antispam-message-info: aJsDt50T3f+KUjv/sO1VSj63qADIOIGqH4u8YG3cIWGe3j/+J/Cxhy6W13muNYHH6lRA5C/Wc3JVtSeStJygQMtIRn0yZK9AhWe3MxT8USoB9I9AQqsJghuJkAWlsgrCT6HB7TEqppogC3N4+1xLhmm637nFvKRcWgKvo5GofRlaayOxGFQfp8hdYam3XNWc7RsLvlbuSFjTGF+65y0x/fS0uLm3++vVDS35fSU6jtYp7VwmloKsY2kzCCSGCxwWsQr97CxWiVf1B4GtKxMZUdPiCOKXEdN/w1Qeskecy5UrA2uJui9lCD0Fd5AR0MRcjJwozx3+vMgPx3+ppIeEvGFvO6ZMSmAWntv74/y7Wj4h2BtfZujj9ca/xOB6+WytJhJ8OGm49MDF4JtDM/KLLGIgmN+Qj+uTK43akBWcKqaMBBW8sSLKKfBomjuNsWl+X0zvZyhl8VtH6CS67gvPGFHDsAKCvKU2hwr6PY4RB8trAaCkC2eHUajl+MbtxQqXT5QDCOGId5BgFrXiLUAAUeIW4Ytx0KM5izr7b292y3BpnjbLtwAeEWEMfkuX04Zy8ZMstZvy/GR0XDXyzFalE5CQ7liyVJFUhIBh2Ma4f2kt/vzjRlhTQqSpn1B8Lyhszm/8JhvJ/1eAp2iN6G6KWwoasRgkQztJljJ95XNT5+v7pzeeNuz+G/OGNZeVhYcRsD3dXXmob8NtkZqEhn1cwjv0zEx9KiAZaCSv6Il/k5iy10j5i8sM9K6PI3icI9wx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(56012099006)(11063799006)(38070700021)(10067099003)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEJodlpvVlUrblU5ekdBVDJuMjJvQk44aGlIL1VPSXJSQSs1V3Z4aXMwWWgv?=
 =?utf-8?B?eWNtQUswOVprdHZIM2hlblhlUStYcElaTEdSWUpkK2FUYTNydVBOdzNzVkhK?=
 =?utf-8?B?dXJmOWJCMlN2U1Z4cWc1Tlc5TTNrNHRuSEJkcVZ0eW4waHpTaUZhR0pGcDQw?=
 =?utf-8?B?dEtNYVVFV0xIbjh2ZlBPZHF2OWJmUGZjdmFoeG4yaVppSHcyVG43NTRSM1Y3?=
 =?utf-8?B?NUVqQTljMG52bUtLNnNvTnBUaEhTUkJBNDZxTWtEZUx0elJIaVE0TksxOGxC?=
 =?utf-8?B?QVR3OWFrRnNsOWQzTkFXdUlaWml2Nkp4ekNlZ0E5N2lxWW1VM1VpZGF5WjI0?=
 =?utf-8?B?Q0FMMTg2R2dxMVZWVzlFSndnZXZMZzZMZ25KdGNrK2pEOVF1YU92ZFVUdjdk?=
 =?utf-8?B?SU1tTktSV2h2em1ET2NZcWs1SU5aYldZYmRHc2NYVTF4SjJuNElJZGZISExG?=
 =?utf-8?B?MzIwYmYzcE9JcEdYdlAwa04wUEJBdk5GSXY3SUVEN0libnU0bkJ5SFZuNmRI?=
 =?utf-8?B?UkMwRHp3SFhacXBNNmROT3F3M0taKzd6dE5iS2t0Y2ZvRWM2Q25ObTlNTzJs?=
 =?utf-8?B?S2R0WFJUOFpLclU1UXAwd0Z5Z1RWL3pHanBOekNSUnJNNndvWmxUUGI5TW9p?=
 =?utf-8?B?alJpTmpmU1c4YnEvLzZST0Yydk5SMXIvRllYeUZIZENRUzFiK09mTGZxOTJq?=
 =?utf-8?B?c0h1Y051NFlTekhpWDhSM1Zsb2ZXaHFyR3grcEh4ZDFJek55NWt4UTJDMEVF?=
 =?utf-8?B?bUg3ckgyZjdSRmhielpobVdEZnFxQnAyLzJsa2VZZ0lSdWRzTGI3blB4a3hu?=
 =?utf-8?B?RzZqZUtRZWNrRTA1SmNuVGErQXJ2Um5WMmNPNk9vRVR0QXV3dEp4UER5REtS?=
 =?utf-8?B?NFpXT3JwOHJzQWJ4MUNYVU55aWRGcm5hRWNkNE92MzNod2dwRVZLYXZ4ZVV6?=
 =?utf-8?B?Q2FaN2FoREtZV0Z6czBOOGozaTRMMmVJcTlBUXNOOU1vc3lyRWh3Qk9leGxk?=
 =?utf-8?B?cTFxdklLY2Ewcjh0QmtBWVhsM05GM21UV0RyY0NPc0lDRkhrMjhPNllILzlG?=
 =?utf-8?B?WGt0OHVlME9UNDVldFIwSmNpUDVlVGZBVXlzMmFzNkQydW0wdU9ZQnZ5RmZM?=
 =?utf-8?B?Ykk5cEpsdit0alRKRm9NMnhlbVEwdDlFNVpndnVtMU5VWFIyQTB5Y1dBM0NF?=
 =?utf-8?B?ZnBFTVpnTTJlK04rRUQ3YVVJUTB0dWc3SWFBcm8vaFFUVUdlZ1cwMEMxcElJ?=
 =?utf-8?B?QlM5b0ticHlDUGo2ZW1rNFJHZ2VsMURGRWs3OER1a1V0RHNHakZXWGpIZWJI?=
 =?utf-8?B?UStpMzgzODd0MjhZWWhiZjdhNjB4d3ZyYk42OHNEMTVIb01zM1Q4VW1lWW9Y?=
 =?utf-8?B?dGRpZXRoK3dOSTdlN0kxNGRzNTdpUVN5KzRueG5tdWx6M0NZdjBtcVVFdDhP?=
 =?utf-8?B?SkdIMHlKbFJVTnpkcjBGYUswOTlBUUkzQitpRWUxL2pGVTlVQ25wa25FZzc4?=
 =?utf-8?B?NGErQ3RINy9qTE9aZmVvUnVtK1NoT0E2YnZRSDE4SjE5Y0U1YmhzczlwSUJY?=
 =?utf-8?B?dG1zeFNuc0p1ZkpvMnJWSWRQMzhHRGJqT3o1Y292Rlcwd3VEcXhOVGRzR2p3?=
 =?utf-8?B?WHIrL3R6L2NzK2JuaXpwVTdSWm10VlRaZDgzR25nb1dMQm03NTdHNnErTUFo?=
 =?utf-8?B?WndaOXM2bDNXVXRxcVNLRVdMZlFSU1pYMHBsKzd6ZEk1ZXBTYk1wU0VQMEpD?=
 =?utf-8?B?SGFaRUtDNWhBLy9jc3lLTWpPWnVBQ3NHODBJK3E1aXNJRkxRZE1jaVFvS05Y?=
 =?utf-8?B?WWdTbVU3dFVVbFhhalVBRkZNMVVJQ2loYVBRU1orc3JTZDFLT29TenZEeTcx?=
 =?utf-8?B?T3FBbGxxYmQxNk83SlRyeVFPWlFRWFdZeDBxSGNremcwL09qTlZxb042a2J3?=
 =?utf-8?B?Wm9Sd0Qvd3hEajFTbmJ2UWUvbFBrcCtxYWhUUFU5V0hSeE82TVQzVjEzdFdK?=
 =?utf-8?B?RjJYaWRMZG5DNzFsYk1CZVliKzJUZHAwUzZNUlNONlcwZHIrZ3pMZzAvckEy?=
 =?utf-8?B?TGJPcnEwbFUxVDNyTDVwQjNoMEJGZUQ4Wlp2ZDJPeURSSk1UNzFZY1k3TE1k?=
 =?utf-8?B?ZGN0WUNybXZPektMSHVNNWpySzh6WmhEUTR4OEhmQTR1b3Y5ZTNiOUNvWWFt?=
 =?utf-8?B?cHM2aTdxeEFsQnRvZmdNRG1mL3RXSHp4WTVIMFRpS2V3MncyV0F6VUQ3d2tI?=
 =?utf-8?B?b3lIbU9aSEJtN3dSVHNRMGk5bFRVWkRlejVjRmJNazVSaS84N3ZiUE44alB4?=
 =?utf-8?B?bXpOSHIrK3g0eW14R2Fla3ZLL004YkQ1cmhOazhLRjZhVTRUeXBQL3RlSlZU?=
 =?utf-8?Q?ojK2FO/QHlAgdjl0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A528EAB6431A5498CA422262A52529C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: GOEswxsZOeCYEdIENfJLU13cXm50uKF0eBSQyCA/5nLgS69HUJvBm1RNyvjh3EZhyE8EjPLYmVqwNWZDXLSGR1DAltqSXBWla5EjJe79qyuyXMwqz5CXyxljjHhlvnC1GjAKS+1D0L/txhq4jhFTNSmtUgjznceXJOdfkH47CsHbBjJwK+LZDyxSQnHVTH6MrDZsvYf7ULe/TzHm9bChgiSH6OBPfCI4nmoX76qdFWQTTRhXcNmqI0UsFPlI8ItDEvecPCrLldHBMwnHdHY7U4Fymnl4qfBtpzmn8GG4rsDtTS7DqtktC5TnMoAL4xW+P1o0MXkdKd1KGKxXG6WlHQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d46daec-fa83-4bbd-426a-08dee3cd9c89
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2026 06:35:36.6667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jgm9PGEJsh7iTwKDwtUAeU7QZckf+7l0ZkcYzGeAWMRUFaIQzwVRHRSNMrJtVr55KD6OJnVj6VGXnZBz6fVjPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8179
X-MTK: N

T24gRnJpLCAyMDI2LTA3LTE3IGF0IDExOjUwICswODAwLCBQYW4gQ2h1YW5nIHdyb3RlOg0KPiBT
aW5jZSBjb21taXQgNTViNDhlMjNmNWM0ICgiZ2VuaXJxL2RldnJlczogQWRkIGVycm9yIGhhbmRs
aW5nIGluDQo+IGRldm1fcmVxdWVzdF8qX2lycSgpIiksIGRldm1fcmVxdWVzdF9pcnEoKSBhdXRv
bWF0aWNhbGx5IGxvZ3MNCj4gZGV0YWlsZWQgZXJyb3IgbWVzc2FnZXMgb24gZmFpbHVyZS4gUmVt
b3ZlIHRoZSBub3ctcmVkdW5kYW50DQo+IGRyaXZlci1zcGVjaWZpYyBkZXZfZXJyKCkgY2FsbHMu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYW4gQ2h1YW5nIDxwYW5jaHVhbmdAdml2by5jb20+DQo+
IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+
DQoNCg==
