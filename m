Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3E424BBF4;
	Mon, 20 Oct 2025 10:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760957357; cv=fail; b=sXk5/GF6EUiY66nyaFrxIsTKJNq53Jxj7EGKL0AS1bW7B3KpCrpadi+NSkBOlfxSNMpqJEqxe7bqHOEEhgJtyoMDHX9M5OoUHU+3ZYk2Q0Jm/r+Ov2wM71tUFq4Lp+zehyrWN7SL+vrtTnOj6JYb3ksg6A8PJzZkaHfxsG3c9HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760957357; c=relaxed/simple;
	bh=ubl7pglSkz2PrHHviG3mqbg9qME5nlODfAhNslNbx6s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T7G1ynbPPh8H2ob6IeO63weMtpduV0klqQS9If+uZi39uoY5om8Hb0HsxDQY5edSxTYR+BmC1ieyh0yF88z8nKe++aMA67TWojckixC4ItXyklLL/zmFUlo+tnPj0hHRZtYBqy2GvuH2sGNjIyPnALpYz8l229qSqmzhGkY3EhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BQ2Z3OMe; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=oWX9KR2J; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BQ2Z3OMe";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="oWX9KR2J"
X-UUID: 6919e212ada211f0b33aeb1e7f16c2b6-20251020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ubl7pglSkz2PrHHviG3mqbg9qME5nlODfAhNslNbx6s=;
	b=BQ2Z3OMe993j85M99VIEAvz9Zbbcyosdh2SmfIJE65hDG6r47g147Y0HkJGWB8yeyLhAvPfc4+Maw85hsiL6w3hEiVq5X2ooMU2O0tzJpPcm3TPV70Ci1m3zryCyYMA4FK9miwiX4Ko9eaP0veM5CbWe7r1MxoRSV83nVWZNz1k=;
X-CID-CACHE: Type:Local,Time:202510201846+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:3e010b76-a1e3-4cf6-ac6c-766a577dd6fb,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:be176886-2e17-44e4-a09c-1e463bf6bc47,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6919e212ada211f0b33aeb1e7f16c2b6-20251020
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 289862796; Mon, 20 Oct 2025 18:49:10 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 20 Oct 2025 18:49:05 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 20 Oct 2025 18:49:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y2jBQfzoFAP9gSEqj6BAEEZ9SCXpvNtKyV8/ygs7zdx2/mS701ANQFXM6PhpLX0BEXAgOZ9snGW6gFJvSU06NhmgpK9sHouag/MgU7hD2piadRp/QyU3Rth9HDGZwSEekR09XpoHYq9QKcWa1HVMSguWfoOf7ugPqFcPiYK8iv74jMPreJuSUehYakTwUJyysRCsVxgieDk/6EcMc+KwjIQWjyhYcNCK9Jjc+szhuKxJrOvft3++Vc8run3Cc3f6KSoZdiybDkfX+G70GGOWs2OjIWeIALvw4tCD3jCNTXG1Ai+OMnIVLtzqKTaQ1CIUzt1Hu34KmguIzgAppHnKXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubl7pglSkz2PrHHviG3mqbg9qME5nlODfAhNslNbx6s=;
 b=Y0kMPP5THw/LgQD/Qvz2Fpt1dJMtzL3n5IRWaMN7YDCUKxxAIRdbYjX1rm3tQ+Wva4Xt/hevQh8wy14b6Ek5xu1B1xlbw4ZQkI48AtNHtPV8va+ZihK1Hho8KtR77Wq8loY/GFdt80snA/hkHx4PcdePhhVxgry6BJm1vY0uj/xZFD9AYeXezck0zVf/B+C97DfB4lMKjvFj7DeMnd/XpU/yIQD/oDsYpskuB7jhQKCQV4p8SWlPLQr2qd1bVoDffrA9WY96t+YMkdypx2xGHuhLjSxTuoPuKt+eqbLRP23nTwR8xIYe5KO80OvLT6PySyxa3oxOWHRMvvAWna8BVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubl7pglSkz2PrHHviG3mqbg9qME5nlODfAhNslNbx6s=;
 b=oWX9KR2JUDiS5OG9ir90CuqWWHnVqChSGEcJzZTh+rBBtL96HfxeGg9yXvoerk4lh08zkEv3KFb6lXbNatXF4JWlCGzQEm42RBA52BihmoZyRdY0mtQS8vUpOgxYTo/BFdPZgauE5g/xXOcBDKI+eYSkkQWdrSd5ZtC6bwFv1nI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYUPR03MB7161.apcprd03.prod.outlook.com (2603:1096:400:355::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 10:49:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 10:49:05 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "robh@kernel.org" <robh@kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?=
	<Macpaul.Lin@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "krzk@kernel.org" <krzk@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "macpaul@gmail.com" <macpaul@gmail.com>,
	=?utf-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?= <pablo.sun@mediatek.com>,
	Project_Global_Chrome_Upstream_Group
	<Project_Global_Chrome_Upstream_Group@mediatek.com>,
	=?utf-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?= <bear.wang@mediatek.com>,
	=?utf-8?B?UmFtYXggTG8gKOe+heaYjumBoCk=?= <Ramax.Lo@mediatek.com>
Subject: Re: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
Thread-Topic: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
Thread-Index: AQHb+ubXEcM0idFfNEe1g+HvnHp2OrQ941oAgAGSzYCAileogIABbykAgAAEWwCAABUpAIAABP+AgAANBAA=
Date: Mon, 20 Oct 2025 10:49:05 +0000
Message-ID: <dac87028c2ec19dae78a26aa729b950bd3f677c9.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
	 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
	 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
	 <438077d191833bb4f628b2c6da3b86b3ecfb40e6.camel@mediatek.com>
	 <cb173df9-4c70-4619-b36d-8e99272551b6@kernel.org>
	 <a9bf15e48afd8496ca9b015e7f5b03821863a0b2.camel@mediatek.com>
	 <7f285723-ecd7-4df6-8c9b-f2e786ce3602@kernel.org>
	 <4b3d2678d2b724fb53ec7272ef8daf52197d4a0e.camel@mediatek.com>
	 <3f5e2d98-4c4a-4a8b-b041-200bb1fc3e7e@kernel.org>
In-Reply-To: <3f5e2d98-4c4a-4a8b-b041-200bb1fc3e7e@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYUPR03MB7161:EE_
x-ms-office365-filtering-correlation-id: 2a3ea4f5-00e8-4cd7-b6aa-08de0fc64a20
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bGpTc29OVUt0MmFkbHBwQk52ZERWc1lKTkJiMGxjNENRMnIrcUlZOUpKNldD?=
 =?utf-8?B?RS9FZTZ4QU91Wm9kMnlrRXQvRkxxbHJCeEdaekdNdkV2bkFCeXJ5QkdVaVov?=
 =?utf-8?B?SGNZSlFDbW5BOC8vdUVVSFlpOEhydGNNL0tERVVQdFd1NCswWFFINnhGZjBp?=
 =?utf-8?B?VVhmNTltbjNlT2E3WnR1K0thRUtYM2FDUkN1Wnh0TC9MaURjaWc4SnNja1hz?=
 =?utf-8?B?TlBVQW1HeU1vdEpDa1NQejExbFkrdkR5Z0E5enVja0xneGRRMXVjNFVnSzlO?=
 =?utf-8?B?bWlUcU9PQ3NZaFdQVmp6ZXhWTmJNUkxCbUJaeHUzSS9KeGppeWFBNEwvdXpU?=
 =?utf-8?B?SWVNdG91OTMxaUZoeFpCSEJBbG5UUzJ5S3hVL2MyS25WYU1jb0wwVElhcldJ?=
 =?utf-8?B?aWh3aVdzaEJORUIwZGRhRHVkUXVuRFVrNVJHbm1TZmovZU9BdTFMdys3MnFh?=
 =?utf-8?B?ZW8yTzhySlh1M2E0TzhSLytVVXpxa1pUVDVxNUlqYlgwRmtMMmJPc3RDUlRT?=
 =?utf-8?B?Y1FUNVRvWnNKK3hoQ09UUU1GVXhsU2RuMTJxMTdVT1gzZ2NpcEE1bnR1aG1D?=
 =?utf-8?B?elVYK1B1MGlkSUpHVHhqN0dHQkw2WkVuc2lSYndVQy9ZTHJnRlZQbi9QNjZX?=
 =?utf-8?B?VWU4dy9ucGJXYVBNZEloellsYm9RT0tVVUNEMURpZ2pVaVA0V1ltYTR1clBW?=
 =?utf-8?B?UXA0STV3czFQNGtKS3NaZ0tGYkJaRTk2aDdDcjR3MXdkN2poUDZ2YXkwaDlt?=
 =?utf-8?B?SmVFZlFkZDJXTTdGcmlYcDlRN0V4cCt2d0NZME5VVnlROGJKaEpXdzBBR0N2?=
 =?utf-8?B?ZnNid2xoTTk2aUY3ZmlMUzcyQUlXMjhqdUtXVG12ZmtOeDZnd3hMTlV5VkFW?=
 =?utf-8?B?Y2hqeU0rT2krcFkyczRGSlZaUWdMaVh1ZlF5SjJoWWk2WU5ld0t4c29kU0Nl?=
 =?utf-8?B?UmFtUnM5cUNIVW8yRytLU0EyanR4RmFSSk5FSjVXeUpuRkJMWGZlaVJRaEFX?=
 =?utf-8?B?TGRtczNGZEhZVTFkblM0cXdQNkkxYjhURUpUdkxEVkQ0WUI1blBjMUIzRTlz?=
 =?utf-8?B?ZzJwN255YUtWSlh2Yk9xYmJWbFNtOHgwUU4ydUhiQ1FtKzZwWHJGTEN0UGVs?=
 =?utf-8?B?aHVZc0g3Y3MvSzd1WmxHNmJXS01zZVBTaU1HdEdHMG9kZUxZejNZeWdXZ0RJ?=
 =?utf-8?B?citRMFRkRGk5VzM4UHQ0c2tDM1g2RzdMRjAwcWZmb3FSZ2w4a3MzQStkUVRH?=
 =?utf-8?B?cVF4djdRSmg5a0ZVajNZUmlDblRvdlZ6MVNuZG5HNDhhdnNGN01WSC9jUGtS?=
 =?utf-8?B?UTRGTzk2S29tbFM0ZGdPQWovUE51WTM0MVY2WTNpTGQxQk1JWm5SRDFMRml2?=
 =?utf-8?B?TkIvMS8yOGwrSHRQRnNKZHRLRDNNRm5TSHFtMXR1YjVBbkxuOFE5WXpUZWpQ?=
 =?utf-8?B?YzlqYmgwRWlxTm5FT1o1ZTFyZ05scDlrS2JkRXBsWDY0NzZZZ0RaQlFIQ00v?=
 =?utf-8?B?cmZGdi9YU0JLZWNDZWZTUEtGb3JGRktrT2JSSU44WWoyWjl4Q3c5N3JXcGla?=
 =?utf-8?B?U3ZqWlUzUHFXWXFoamVMU2g4cG1aSEpBTUJpbm0wcFNidDEzcEJjM3RwMnh3?=
 =?utf-8?B?QThrRW9MenVDOWIxM090cjVHWWg5Q1VXK2w0OWl5SGpMTms1aE5Sb0dlRWZ2?=
 =?utf-8?B?REkybmlsSzRvUzRVSGxsakJYTi9sdjJzYmQ5bWpiL0FYTnNUcDZ4cHhReG1K?=
 =?utf-8?B?VGYwMFVCYjdBNmozUzhtK3FnMlR3Z0FzZkFNalFvSnhWd1ZQcm5uc1RqQ3BU?=
 =?utf-8?B?Y0dwdHhPcGtvZVY0VnRkamw4L1J3aTZ2QmRQQzYxWm91ZCtHcXp2V0srdEpa?=
 =?utf-8?B?aE5pdFpSdUlDNE1vTjZzWWtOdW5vQWNsanZOeTJUaW5TNHVGbUNBWkJjdzZQ?=
 =?utf-8?B?UW1HQjM2OVE0ZTVrVlVITXJNL3kyUEZRUFE5L0FMYzlJUjdoVFU0cTF6QmU2?=
 =?utf-8?B?ejh4TC9MNnZaVXBPRXRoRWxpSjMzUDVPOVg1R2pRNDh6dDNXUjhTd0ZJd3lV?=
 =?utf-8?B?eDR2N25nMy9jYVVqcFVoN1B2MnhLSVp2ZWcvZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sk9yRlYzT2lZYXRnM2hGdi9Tcm9wZ0FsWGE0YzNDSVlJMWliRFN0R0x1WmVJ?=
 =?utf-8?B?L0NybzNRTzNranNmRVhPWTA0R1NtSmFRaXZLUHMyTDZMUmJsYjd4ZUFZNGdO?=
 =?utf-8?B?ZmRGOEFYdXBoUi80R1RGOVVIaHJlQzRIWEdhRjNzOG1hc0xxZmh2aTl4amFU?=
 =?utf-8?B?c1V4WTFkbFdQMjZGRm1aRWFTeEhTazQ0NWgxNTIvOHB0UmNRMXVTblBaUGpZ?=
 =?utf-8?B?L1dnUjhGMWRuaFlIT0tHZUZYaWN3ODdhVlUzTXoyemgvRUFlZmpsS1lqMndY?=
 =?utf-8?B?cDhzTnUxa0Flc204Rk90TVdxWmxmTTRWTWRMSVhocXhwYTJDRlZrdHR5S1pj?=
 =?utf-8?B?SjBBWjdKUkRUSDl3UUZOY3E5RFdmaDZKbml3KzJWWlVjdHJOcDBzV1ZBdmRw?=
 =?utf-8?B?ZTB1d255Y0pEcXNRanBOSEFqU2h5d3BXTkkrMEFOOTRNQ2QzYnZNN0tkbnIr?=
 =?utf-8?B?MU9UclZJVndFNmhidXJXTmRVV24yaG9EdXdiYm5nWk8rM0x1bGpOQUcvNFNO?=
 =?utf-8?B?RUhqbjJqdGRLUVNRRVFyekFkUlB2Z1RhbjdvYXBXM2hYWkljYThhZ3U3b1hu?=
 =?utf-8?B?ckZFWXdzN3cvY1pXMmFVRUFDZkh4aENUU01VeiticGtvdCtFZFd1NXNUaC9h?=
 =?utf-8?B?ajFtVDZDM3Nzb1JlWXZLSU1YMEpYV2lZQUtaR2VOZ2w5Wjl3WGZPdlB3NE5p?=
 =?utf-8?B?a3U4QktsRFJ3LzExVUtGM1duaHdiWFc0QTVsVmlzck5qTDFkRU9GaThtVmNr?=
 =?utf-8?B?VEp4QUorSFV2a2tKakZ4RENlQjZGalNQdysrSTc0NGVTQlpOTitDNEQ5b3Mz?=
 =?utf-8?B?WUp6ZEJSbW1qcmFtZC9QYkd2dVVsbFNHOHpoQlEyUzNVSHEzWkVOSXZ4VDYz?=
 =?utf-8?B?N3N3ZkdKaFo3N2JnNnVpbWVUcUhrRjYwMFJpTHNvejNNRnBaN3FrTTE0cmd0?=
 =?utf-8?B?STdJK3FwNUN0V2NwU3g1NGNNei96RTRFbElSeTNjUXNxYzVwRDl0SkVSWndC?=
 =?utf-8?B?U2t3Z2cvL2dQOU9YWW5YZjd0M2IzQ1RTRWZNa256dGhRdGlKRmhNc0t4TmRY?=
 =?utf-8?B?VjNyYUJOakV2U2tJK0RkQnJPdTVFWXNPamlxMnBKc1FBemsxQmJwTWw5ZFNp?=
 =?utf-8?B?OU9xVTBXQnFXWFZCR1Uyek54bE5kb2F4YUlpdFozb3UxNlh1Z2NWUE10ZlZ1?=
 =?utf-8?B?cmlBNy95WG5xb1FDZ1c4VVdPL3BiUFB1QytPc3lhRGllVWdZMFJ2eUM2Zm1u?=
 =?utf-8?B?WDY3MVcvU3FqdlhLeVNaMUNXTmZjck1LOHhLNkl0ZVBVVngrNU1lNGdSRkhq?=
 =?utf-8?B?NVdCZ3JDTGFFaSt4bTl3QjAxMVhRQlNjd0FrZEdrN3RzWGkxNnBZQThScWdP?=
 =?utf-8?B?NGNVRjdrNFlyUUJTNnB5U1NhQ2FjeFhscmRYTHJyRGtEcjZiaTIvVHRtTEtZ?=
 =?utf-8?B?alJrOCtUYldTcS9Ea29WbjFxTTRKWGxiRzNqS01ObFRzMENHak5oUXN5VDlw?=
 =?utf-8?B?Y3JIcS9IeHN5UjQ0ODNPQS9jUGtIU0lyY29zK3hKUHJSeWpuUytCWnJrc09O?=
 =?utf-8?B?VzBCWEUzNExyRURRMm5hY1UzZnlRSU92ZC8vRHFWZzBjQVN0OThGRGVKVlcv?=
 =?utf-8?B?VFV5MktxTHczR3l0YmY3ZTdFcGVxRytSb0FDMXRxRHBHNlpLaTNTT3BEek5K?=
 =?utf-8?B?amV5LytDTkRwUHl1WFkyUm9XUlpiOVgyMHcwY3RlQzl4T1VzcmpPd054Zm5O?=
 =?utf-8?B?bFlEUnNCbitUOUl1TTR4UVl4QklsTmFRWHFWdGQvbTNNdUtpYzlYd0FGdU5i?=
 =?utf-8?B?NCtpUy8zQjlrZkp1aGROTldBaG53emNHbFdCYTJXYUNoTnhnSVo3eXhCY2h2?=
 =?utf-8?B?Z0RZdjcrNiswSDVSL201UmVPcGcvSG94ZTJZeStCWTNPeElvZStJREs5MzFq?=
 =?utf-8?B?U1FJRUdIMUkwUFZTTVFUcFQzdVdOUkJRb3Znb2FPeE9mR1VqSTdmd05hRVhM?=
 =?utf-8?B?anBUL3AwWDBrQWpTTmRaK2RxT3oxYkJLWU1QVUs3ZER2Z3EzVEJVanpQOFFO?=
 =?utf-8?B?UHo4bnhFYmMwRjBNRDhYSFhEdWNESnFreEl6azRpN1JXTzBwT0NKckpJeUJx?=
 =?utf-8?B?NUFla1VHY09pMzZkL1JxRGF5SE1GTTdzdnJsMHp1REVuSWE0eW4vdTE0WWly?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA7A365A631CC34A8A0E5B8D2D79E2B7@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3ea4f5-00e8-4cd7-b6aa-08de0fc64a20
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2025 10:49:05.4738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h1/65TIRDqHUNacRBiJHEL9bVKG5lJFF/0BnPNdVlpBCIC5eJu51mOKWxkaUkJDNSZ9giGxodPmU4tCNLe9CGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7161

T24gTW9uLCAyMDI1LTEwLTIwIGF0IDEyOjAyICswMjAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiANCj4gTGV0J3MgcXVvdGUgeW91IGFnYWluOg0KPiANCj4gIipJbiBhZGRpdGlvbios
IGl0IHdpbGwgcmVxdWlyZSBNZWRpYVRlayB0byBwdXQgaW4gZXh0cmENCj4gZWZmb3J0IHRvIG1p
Z3JhdGUgdGhlIGtlcm5lbC4gIg0KPiANCj4gVGhpcyBpcyBBRERJVElPTkFMIGFyZ3VtZW50IHlv
dSB1c2VkLiBUaGlzIGlzIHdoYXQgeW91IHdyb3RlLCB0aGlzIGlzDQo+IHdoYXQgeW91IGNsYWlt
ZWQgdG8gYmUgQURESVRJT05BTCBhcmd1bWVudC4NCj4gDQo+IEluIHlvdXIgb3BpbmlvbiBBRERJ
VElPTkFMIGFyZ3VtZW50IGlzIGRvd25zdHJlYW0gYW5kIHlvdSBzdGlsbCBkbw0KPiBub3QNCj4g
dW5kZXJzdGFuZCB3aHkgc3VjaCBhcmd1bWVudCBpcyBpbnN0YW50IE5BSyBmb3IgeW91IGFzIHJl
dmlld2VyLg0KPiANCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gS3J6eXN6dG9mDQoNCkhpIEtyenlz
enRvZiBLb3psb3dza2ksDQoNCkkgYWNrbm93bGVkZ2UgdGhhdCB0aGlzIHdhcyBpbmRlZWQgYSBs
YWNrIG9mIGNvbnNpZGVyYXRpb24gDQpvbiBteSBwYXJ0LCBhbmQgSSBtdXN0IGFwb2xvZ2l6ZSBm
b3IgbWFraW5nIHN1Y2ggc3RhdGVtZW50cy4NCk5ldmVydGhlbGVzcywgSSBoYXZlIGFsc28gY2xh
cmlmaWVkIHRoYXQgdGhpcyB3YXMgbm90IHRoZSBtYWluDQpyZWFzb24gZm9yIG15IG9iamVjdGlv
biwgdGhlIGFjdHVhbCByZWFzb24gaXMNCiJyZW1vdmluZyB0aGVzZSBEVFMgc2V0dGluZ3Mgd2ls
bCBtYWtlIHdoYXQgd2FzIG9yaWdpbmFsbHkNCmEgc2ltcGxlIHRhc2sgbW9yZSBjb21wbGljYXRl
ZC4iDQpBbmQgdGhlbiwgd2hlbiBJIGFza2VkIHlvdSBhYm91dCB0aGUgbWFpbiByZWFzb24gYW5k
IGl0cyANCnJlbGF0aW9uIHRvIGRvd25zdHJlYW0sIHlvdSBqdXN0IGtlcHQgcmVwZWF0aW5nIOKA
nEFERElUSU9OQUwu4oCdDQpXaHkgbm90IGFkZHJlc3MgdGhlIGlzc3VlIGRpcmVjdGx5IGFuZCB0
ZWxsIG1lIHdoYXQgdGhlIA0KYmVuZWZpdCBpcyBvZiBtYWtpbmcgdGhlIGNvZGUgbW9yZSBjb21w
bGljYXRlZD8NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
