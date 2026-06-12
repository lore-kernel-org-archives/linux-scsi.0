Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5B91FB1;
	Fri, 12 Jun 2026 00:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781222712; cv=fail; b=AWWbSYh7CeAXHcoY4Aosgtskm/9GhU1ZB3fcwgtigTk6Lxml/IfNfKrMQs1F9ULTVf0CCTaScDN3vB8ZCKnsGnV6SyLPXtbqJfQXYujXOmLGBSwcekAHS7s8BqN/gQZsMQD+500zBioKRuhxJtjzIOSvg9vqpZZd6opGx/UM03M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781222712; c=relaxed/simple;
	bh=CNoGraKfnz+5NZOiOvzoNqADoKAwXQWD+6MjRnQ5Et0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FRYPg1WLDxtylNmL1gNkvKjH6iumIk72kUQLmT5SAcVhU+WF/syIuDSqyv5Fg8a7XYLPeOIKFt1mdUnR1X3OvWIOvY+CiG+9nWf8rDffKEdbcZBsp8lUtsQACjHH0PxXR0gIA08GfZg2nMgnlXiIFFLmVYUozUf1HVKaiG+vhAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oWZMuD6D; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=i3zyMtzb; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oWZMuD6D";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="i3zyMtzb"
X-UUID: 5d3f296265f211f18dc8c9802ae25ab1-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=CNoGraKfnz+5NZOiOvzoNqADoKAwXQWD+6MjRnQ5Et0=;
	b=oWZMuD6DnyKv+9st33rtT7EXtQVjDM9sCkRiZtTfKjue4cQmK7dtLu79PM3aa0fHfXVScAzQuarxauR1FOYyBOhSdzTEHTdK0FZQFcgUzSekqsehLH/EeHhupDPagdyOJ3CDTS7WThyKnzoX3Dx+KEOqDjYO70my5t+10D1MgbE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:0a366b8f-e470-4e1e-bfc2-f229bf87bd25,IP:0,U
	RL:0,TC:0,Content:13,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:13
X-CID-META: VersionHash:e276073,CLOUDID:fc421627-afc3-4ed1-ba0a-209ce2a83810,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:3|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5d3f296265f211f18dc8c9802ae25ab1-20260612
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1623907990; Fri, 12 Jun 2026 08:05:04 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 08:05:03 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 08:05:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6Ee7WUmRVhPCxCMW/+Gj9sdoiiMJyJq0ezng57F1ewNoeeMrSJKZoEBGgpXp7SdqqTbXwtV7Bp8vOq2zg21RHtDADe6sBTVSLwCKWrqv18wMV6SwqxnrfBhLFVCRRIhwB6brSyHhpdcn30805rrOCfiQKgaWKF+ercpITRGILVjlUorfgutIQ6yor6r5pDHHBTTrbG+uahqgq27+O5e/dScFO9AxUwSBti/3AbdruwxPdcdH7jpjSsTtHsnHy/USN2XhWlG5YmayHyvjI/CiBLMc5dPZBmSYX+toqpB3Mwa1TjISltKvVk94fAX+95w66Ani4i1HP3oM36e1y3C+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNoGraKfnz+5NZOiOvzoNqADoKAwXQWD+6MjRnQ5Et0=;
 b=ft6LSY91GW+Q/Ihf2JTcR/0qvSmDxR6O561qdrrOm3zcds84zL37GJoeo74++m/WDVZM7fYlr37TyQOzhZgfjAajvKRFajpk/ai10jFGaU+Zq3UzzCdMdcELDMLAL5NPcWKC1r+F+eBVH6lN3q6kSM8m4Gwcs8rHKidjdHOWDKAxEl2aJrpQy1KQDVRmLNHAucqPPe9Y/Cz6UuoYV5tTSjOEWGuR8RPKuzlW57vcz1A3wPtvBNPwRYfwamQSHp1lp24XwTwM7RdG4Dg00U+S+p3DtKocuofx9LH2oKUtOo05WSDLbfqzvN+aQesKP9ftA7+4JhGKZdEOPVMVYYfstg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNoGraKfnz+5NZOiOvzoNqADoKAwXQWD+6MjRnQ5Et0=;
 b=i3zyMtzbZZB6ucYCkcJc+wV3H8kH4WhhUO9O/hDd1oQDjHikUKvq+iouRDwEidw5dWoUW9Hyb594WqAAwU5B+uSSqx7PkOTEvWl1v2ek2QG1p0Hsmhrt5jW1MPbB8E8oVUE3rnzYpUcBjR3xOFjYJqKgA9vzMG3Ilq/2P4eF3do=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 SEZPR03MB9633.apcprd03.prod.outlook.com (2603:1096:101:22c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Fri, 12 Jun
 2026 00:04:59 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6%6]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 00:04:59 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Subject: Re: [PATCH v2 0/3] ufs: Add callback for vendor-specific RTT
 capability
Thread-Topic: [PATCH v2 0/3] ufs: Add callback for vendor-specific RTT
 capability
Thread-Index: AQHc+fnHrRx7EivWTE6MasQ/l0lEaLY6CkIA
Date: Fri, 12 Jun 2026 00:04:59 +0000
Message-ID: <3caf962878536cc1d0ba6f95e44a817cdb04a408.camel@mediatek.com>
References: <20260611232632.2324422-1-ed.tsai@mediatek.com>
In-Reply-To: <20260611232632.2324422-1-ed.tsai@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|SEZPR03MB9633:EE_
x-ms-office365-filtering-correlation-id: bdb09570-a43b-4778-ccf2-08dec8163e34
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|38070700021|18002099003|22082099003|11063799006|56012099006;
x-microsoft-antispam-message-info: I9LA3/yspTUpjHixAxnla9XQzgH1MgUW4D4FOpKuLPaej8AFKDurSbGbUBXBBOb1yFBBiW7LKwYnYA2Efc9P0s6u/q08kTcLVV1Lzs0nS23ApxcXQCh8gnst69fMtKcPqZFDBMreHPeAUle8r/PfcjPyLf0iwGU2DTTqI2YuLmoqZkFXnh5tREDaqj4iRR2q8NshCewq1bS8F/tHuMy0q8CjBQNtLqNHLq8B2WkIZ4IVIcJ9ufuYhL2RGRdMuQMqe6D6RIualz4gveZUbuFoWUzeWiBNQdOA5Z0BFcI56ReQ+C13dPFUr1SP8jdcG95TUBzxFIW1TshfiB6B28Oes6hjrrF23oHdmkmTPHNItuM72AXHjcKYQ7SnHatzmovs7ylixIaKorVwA10LSKYi29l6oSwSOzBCe8odSmXE3JlnJcIzm4MBeJUrvZROEGor59DbXcX2s25C7Uz182T0sMD5eyIl7n4CSr9NCeZY1bQ/MnUE6Vc7x1HzTAcjGiFXfxqElK05eqSd4pViHnmTG5+pOQ6izcnmjMRv6kOFn0wmT2vWxHIznzKzPSfW99bOVGQOQ72kku5akJTzPbqqEWEeurxRiRS0G+NjwUoSGv6fczrgDpJQXnXIHaRJ6jIjfZt/Gc/APlemJv/H06NdNgQjOIKwUZfSa3muocXsVeAnZma1SnOMoEpUL8/DL2ZsqL/PVRDqrPa5PMfqbLUSOm+u42Sgs/jaxM5Pc4lIrJeFQyPxbbl8/CHI1aJB7UL1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(38070700021)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2FwMlJ1V011QWNUdTcvNGNjNVgyZlNkdkhrSTVZSERmWWZJcGpDS2tPZDB4?=
 =?utf-8?B?c1FwanNFYWpOeldKKzdZQk9TUzRpVE5BTElteWdrZGRxM2dGZEllcDQ0RHlp?=
 =?utf-8?B?RFNHbFIrSXRycHVMUThoYkdFUVhUM1A2cDEyYm93N1pqeFdmSkxnNVpZVjhv?=
 =?utf-8?B?L3ZsVGp3VVFCYlUybmx4eU03Rkk0SXgySU4vL3BFbS9kUE9ySXd5azNSckhP?=
 =?utf-8?B?WnNaRTkrRVExaXlPeVRmYUJZK3k4QlZqNVFjYnUycDRVOG9zM2l0WjR4NWxt?=
 =?utf-8?B?QUlaeTZxUVpUZUV1NmlFc3cyaWVOdlJZdUs4L0pHR1BxVFNkWlI2c3FXd25E?=
 =?utf-8?B?MjlFeXFQclcwRHU2MkN5c2xnb1krK0R2VURMZk9mRStyTFlFbW9LYUVSRkFL?=
 =?utf-8?B?OFAwTzJ6dVVjOTFOaGNDd0NwdW52dzY2T0F2Um81eVFPWnZkVWE0RnUwYndt?=
 =?utf-8?B?L3ZPdXZxNGdxUjV5UkVrV2FDMWR3N1NpRGhnUnpzcndPR25XbmRxaTVZUW1s?=
 =?utf-8?B?U1ZiV1FmNU5vMDlzc0g1SnFtR3VabHBiaU5vN2hPWmRZMi9YK0ZrSWcyQVJL?=
 =?utf-8?B?YU43MnZhTlVKUGR4NHR5SzVnRFNqVUl4U25PMVZ1N081ZzZSR2tpdXQ2QVdR?=
 =?utf-8?B?N3JsRGVJUUVIMzJjVkFhSGdYeHBOeFFxWXM0MGxBZWVsMzVQczlaUHV3aUdQ?=
 =?utf-8?B?SUVtd0R2QUxPa2lFbzJmMW5pOHY1QTZyMWxyOVNrcFdMbUduckl3L1lnTnUx?=
 =?utf-8?B?NG5KYk9vQ1lhYXNBMS9sZlBybURzWStIYlp3SEx1YlEwMkNqdWlkK0w3Z3lt?=
 =?utf-8?B?aVdyaVMxTll0bFB0MHpUSFlQQzlRenBEUzRNbW04QzIwK0dod0wzblhtMnBt?=
 =?utf-8?B?a044Wnp4ejRDR1RUSlZsUm93UEpCOC84OGF5MmhKTVdzVW9YcTcySjU4aUFL?=
 =?utf-8?B?Sm1LWTUybHRPNWpuaE9BM0JRN0lWVTlCOWptVFN6eVVaL2FsVUxJZ1Vpb0Z0?=
 =?utf-8?B?ZEttOG5RS3pHemRrblNVaTVOVktKVGRRL1ZzSEVTV3BPdGtSazhJcGtxektL?=
 =?utf-8?B?Q1FaUWVCRUUrVUoyb2hyRHowajlKdm5scjVJZ0tCQmJsWTVrbWJKSTRyazNF?=
 =?utf-8?B?QnNmSkVLd09SaDg3NWpFOUgyZ2VOOUlxR1o0eWw0U1Flai9RNUVqRUFlejBq?=
 =?utf-8?B?OGxpcDdGNlB6VW9jeW5sU2VLUTlMUkZnbXZhOGJ6bjZaRUZCYXQ2N0llMU5n?=
 =?utf-8?B?eWpxcVFLa3VOSCtMTHZLNThaVHI4Rk9ZYURtY01sNllVQ05DeTNlTnZGclY0?=
 =?utf-8?B?THE5VlRQaTVzSko2WGtPZUIrZmthRzNVSzJHclRjVHFUK1c2eitjcm8rOGph?=
 =?utf-8?B?b0ZES1QrTHVGSmdWUVlxR0VnM21iWlpMODVaNXNLTWFvUkZVZW1Rd0pweSs3?=
 =?utf-8?B?UG9YL2JOdHQ1K3pPSkpuRlpMMmM3b1VrSXZlSEkxMjVFQUs5TFZkaG1zVkJN?=
 =?utf-8?B?cUI5ZndGRkhxL0Q4TGFvc3B4UVF6VE1JVVh3Vjh1ZG9maTBYbkNNNGJ1c01a?=
 =?utf-8?B?T3FzRDBWb1VvTWVGbm1QdWlDMHRKQ05abUtHTXhlWGpqYlFzQVdoWUF6QURF?=
 =?utf-8?B?Wk5odzZldUJWWlYralFqYWlsZVMyWmJiOWZ4cWg5R1ZxMzAzcGo1Q1RDT3Mz?=
 =?utf-8?B?aFRxRkV4R0FxREVkbGNPUXVJNTc4MHh0NE5SeEhZbGdNQ2djMFAxTnZ5eE1P?=
 =?utf-8?B?RUpGSHJRY3VoeXNhUUxEZHpza0xEZEYxbTBQVndLb21Rb1ZGNlhuN3ZNY0Zv?=
 =?utf-8?B?aFpnSjFGWHZaQnUzRzc5bytzM3ZYdlQvWElwSjU3N29lWkJJSk42cGxtbEpo?=
 =?utf-8?B?alhHU3RIbnZmcVNZYzVYcnFsZUc3TSswUzdPam1GOHZmSUhQQ0s1eVJKbVpG?=
 =?utf-8?B?VEtCcWZNdGJVMlFsR1FtSnVTVWV1VHNUNC9wK2I3VUlJYmF2UXBZZzBRUXIv?=
 =?utf-8?B?SlhGVThtWFNNNXFIcW5wakxBcHh2bW1VNlFFQVlSMjRwbWhOZ0gwMlEwQmlx?=
 =?utf-8?B?MlNCSnRoWlp4SThTaGtseVVNZW0rdDhxSTdPMGVEL0NhOFNpeXVvL3g2SFNI?=
 =?utf-8?B?MmxZbkNKRmRid1F1L0FBZlpQc1NsYm9wdlh2R3ZQTmkyckp2ZmZ6bTdoUmhj?=
 =?utf-8?B?QUVwbXpKQllOamFVNkFnejIzY29DVXpzcVlCR3pNS1JyOXBGOEwrSEY1YzBY?=
 =?utf-8?B?QzB4RDhvc2JvS3MzbHF2dE1KcWZiWFNuVEVxNWlyL2VTcDF5NUFkK1M2SnNn?=
 =?utf-8?B?TVVJWEFNeWYzM2l4TElxa2p6Z3psNzdWeUJqMitCaGJOV1pDanBqQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B01E83A4F14DA24485E41C3D6C0D9907@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: m+jkq4lAtYdRzknqoSOIUwPXcpg/e7OKTsmr9DqNZEkSy3wXVOrVH9f4AlorJUs6mmJpRAj9rlvCFLRHj+5yoVXEuyjsCEXHYBq5YpC6Pk7pjeYTeaGvFEUNrBkzHyVkftPRL9VCAhP2HqeCBm4XQoPT2fzvrPfsq2vC1SLH41oRGJVVGUcfZhyBQuPyjAj6gHWHpgC04YGevsTGygTsTX9dihQ3NusTg7x4apw9dor7+XxtM8tOdCKXwMab7Nr21fyoR/66LmBeUkIE5MrjNFEE66tiPjsY9H/QueZ/4Qk6RZ0JPO/asgUls/6Ef8afc2ilLYmIY2E3Ne4IYUa60Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb09570-a43b-4778-ccf2-08dec8163e34
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2026 00:04:59.1057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9XoDRdiHWYKPmCY23mTdONOZLSdaUJ2Kc2TE+LDnbi0oRCnSIPWtYXghvZfTZClNpMb64z36f5k93IOELw5D1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB9633
X-MTK: N

T24gRnJpLCAyMDI2LTA2LTEyIGF0IDA3OjI2ICswODAwLCBlZC50c2FpQG1lZGlhdGVrLmNvbSB3
cm90ZToNCj4gRnJvbTogRWQgVHNhaSA8ZWQudHNhaUBtZWRpYXRlay5jb20+DQo+IA0KPiBUaGUg
Zmlyc3QgcGF0Y2ggYWRkcyB0aGUgZ2V0X2hiYV9ub3J0dCgpIGNhbGxiYWNrIHRvIHRoZSBVRlMg
Y29yZQ0KPiBsYXllciwNCj4gYWxsb3dpbmcgdmVuZG9yIGRyaXZlcnMgdG8gcHJvdmlkZSBkeW5h
bWljLCBwbGF0Zm9ybS1zcGVjaWZpYyBSVFQNCj4gY2FwYWJpbGl0eSBoYW5kbGluZy4NCj4gDQo+
IFRoZSBzZWNvbmQgcGF0Y2ggaW1wbGVtZW50cyB0aGlzIGNhbGxiYWNrIGluIHRoZSBNZWRpYVRl
ayBVRlMgZHJpdmVyLA0KPiBkaXN0aW5ndWlzaGluZyBiZXR3ZWVuIGxlZ2FjeSBwbGF0Zm9ybXMg
KHdoaWNoIHJlcXVpcmUgdGhlIFJUVCB0byBiZQ0KPiBsaW1pdGVkIHRvIDIpIGFuZCBuZXdlciBN
VDY5OTUgQjArIHBsYXRmb3JtcyAod2hpY2ggY2FuIHVzZSB0aGUgdmFsdWUNCj4gZnJvbSB0aGUg
Y2FwYWJpbGl0eSByZWdpc3RlciBkaXJlY3RseSkuDQo+IA0KPiBUaGUgdGhpcmQgcGF0Y2ggcmVt
b3ZlcyB0aGUgbWF4X251bV9ydHQgZmllbGQgZnJvbQ0KPiB1ZnNfaGJhX3ZhcmlhbnRfb3BzDQo+
IGFzIGl0IGlzIG5vdyByZXBsYWNlZCBieSB0aGUgZ2V0X2hiYV9ub3J0dCgpIGNhbGxiYWNrLg0K
PiANCj4gQ2hhbmdlcyBpbiB2MjoNCj4gLSBLZWVwIG1heF9udW1fcnR0IGZpZWxkIGluIHBhdGNo
IDEgdG8gbWFpbnRhaW4gYmlzZWN0YWJpbGl0eQ0KPiAtIFNwbGl0IHJlbW92YWwgb2YgbWF4X251
bV9ydHQgaW50byBhIHNlcGFyYXRlIHBhdGNoIChwYXRjaCAzKQ0KPiANCj4gRWQgVHNhaSAoMyk6
DQo+IMKgIHVmczogY29yZTogQWRkIGdldF9oYmFfbm9ydHQgY2FsbGJhY2sgZm9yIHZlbmRvci1z
cGVjaWZpYyBSVFQNCj4gwqDCoMKgIGNhcGFiaWxpdHkNCj4gwqAgdWZzOiBtZWRpYXRlazogSW1w
bGVtZW50IGdldF9oYmFfbm9ydHQgY2FsbGJhY2sgZm9yIFJUVCBjYXBhYmlsaXR5DQo+IMKgIHVm
czogY29yZTogUmVtb3ZlIG1heF9udW1fcnR0IGZpZWxkIGZyb20gdWZzX2hiYV92YXJpYW50X29w
cw0KPiANCj4gwqBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jwqDCoMKgwqDCoMKgIHzCoCA5ICsr
KysrLS0tLQ0KPiDCoGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgfCAxMiArKysrKysr
KysrKy0NCj4gwqBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oIHzCoCA0ICsrLS0NCj4g
wqBpbmNsdWRlL3Vmcy91ZnNoY2QuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDQgKysrLQ0K
PiDCoDQgZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4g
DQoNClNvcnJ5LCBJIHNlbnQgdGhlIHdyb25nIHYyLiBQbGVhc2UgaWdub3JlIHRoaXMgc2VyaWVz
Lg0K
