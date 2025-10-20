Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C823222568;
	Mon, 20 Oct 2025 11:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760960807; cv=fail; b=uff2qMS85ZzppbzAMNTm0CylEfLgfEM18fwKqO/anawi/BQATgnIEdzY5/X5CpOFcEiQcr1MSEdzn9RsXfNcTTeaf1ZoTCJoN/sMWFk0Y/7LGnBPbgmxfPGPdO/MVRX4E8YhBwxJSqykrOkA2NODi6xPArWfRsUUw2AkaWvDOLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760960807; c=relaxed/simple;
	bh=HswBHiGPywFsF77KAG126weA43c/z/RIyNRi+mkpplI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tU4uYnEDX3OQFNcXgyRrt7F9kffsT3E0lAIBFCXNX8W75b5v3vCh59cvkd3wGKnJF2u6gbmy8X5bU7CV313ve0qEe4Cq5Wq0HJAt1/Pfoz7+pWGI5K6FHGVQlragR6NfX7LUiUgcC5wQa0smSqXVzwKyHgg+zR7N5LGkz9xChpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=soumNGrw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=AKX6ew3O; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="soumNGrw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="AKX6ew3O"
X-UUID: 705c6290adaa11f0ae1e63ff8927bad3-20251020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=HswBHiGPywFsF77KAG126weA43c/z/RIyNRi+mkpplI=;
	b=soumNGrwngYLp06FMsVNZcucVBwhu6hfa1IleFiKuHJi/xXpfVWq5Vx/GmdCOOo4YzIP13CLbLaHodPFhMTbIxJuJe0J8F+GbOIFLH15UbP2e2Nv01q/6Si34FsLOWDkf55QsAx1KzK3E/m47YuhQLEp9SUZ9C0oubPGZjxKBRQ=;
X-CID-CACHE: Type:Local,Time:202510201846+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:1338449e-06d7-4e6b-8d57-6dacf9013275,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:11724051-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 705c6290adaa11f0ae1e63ff8927bad3-20251020
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1497190971; Mon, 20 Oct 2025 19:46:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 20 Oct 2025 19:46:32 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 20 Oct 2025 19:46:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CF25BJSI7wQUS26dKsTrcSHwO8sREZo3LsTo/IBp55rT0ONpv9KRTC8qZfHgmFYLcY8kURGzlD5Nix6s/LQoxCkP46LcAigI7e5NtLW7FFaxmVL3T5uJcASzU9GtAUdmRvlw6OIJJ7Pf9xepqUQ9xrMgrRRrx4KKvQMtBa+5aZFNls0Fsln5iMojzXvhT0gkK549SmO5RZ+GM+ZBOs25uLmlMgi/V3StHa9OFJHPssfwQKdR8BBqsw4/hRWMEzQxWI6DIBa48jh1p1gHD24mvjQMs6ke0eiz0im8dtvmCHBUf2PMBLQ+L7D4yZjBv99DQDjIY2fWU9atUbz8ho8cYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HswBHiGPywFsF77KAG126weA43c/z/RIyNRi+mkpplI=;
 b=UoQUrtECGN9NhWMsUQAcMHjA8Qsu2PbW5IFtqvT93O4egBPXoKomuOkySUFrmioxr19mmYMf16jnsjoPOOkJazCJBSeEN1EyoDC7E4D2U8Pzq9/FiJsjuasHgnyffdD5fmKqjxm22yu8oKm1OmCmeBS4jVKVQvoAoqYQzUx+uhUV+uQhFp508jRLg1ZrysUXbym15gJooQz2I7lx8AZMczhO5G7ExkURc26C06weaDS5pmraizxc4lwXQsEqPebOMkvUl8Z/xkFrM0XZwBCp5CO+etPOw28AuO9OyzS2ZPUXphU6obtGrGCAbAD6Y3kNN3waUU+lpTB7rM5285VPgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HswBHiGPywFsF77KAG126weA43c/z/RIyNRi+mkpplI=;
 b=AKX6ew3OckxvCv8imZak2A1jyqJ+pb2ijIZLkEmHpNGqIXi6tE55ghkyJEnRUkoMhFgmrOmnbSrcvXS+SIGAs69D63r8k4Yez6LDeNparoMi+NEcAD67D+2O+ICQoxyycEgCv9o/Vi5Q2VWgULfczhyLoezp+MVsG9PeJ4+q4qU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8843.apcprd03.prod.outlook.com (2603:1096:990:a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 11:46:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 11:46:33 +0000
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
Thread-Index: AQHb+ubXEcM0idFfNEe1g+HvnHp2OrQ941oAgAGSzYCAileogIABbykAgAAEWwCAABUpAIAAA1sAgAAN9ICAAAUNgIAAC7YA
Date: Mon, 20 Oct 2025 11:46:33 +0000
Message-ID: <2fecb7235ee54bbf66d54f57bd08c62c5f7c3a60.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
	 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
	 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
	 <438077d191833bb4f628b2c6da3b86b3ecfb40e6.camel@mediatek.com>
	 <cb173df9-4c70-4619-b36d-8e99272551b6@kernel.org>
	 <a9bf15e48afd8496ca9b015e7f5b03821863a0b2.camel@mediatek.com>
	 <7f285723-ecd7-4df6-8c9b-f2e786ce3602@kernel.org>
	 <4b3d2678d2b724fb53ec7272ef8daf52197d4a0e.camel@mediatek.com>
	 <4dc420a3-cf89-4f45-84e7-4d0079240681@kernel.org>
	 <95d3fe686abcd4a6070c6613392fdb9605bdd73e.camel@mediatek.com>
	 <6de4477a-5c2e-413f-9aa2-77b7262ebb38@collabora.com>
In-Reply-To: <6de4477a-5c2e-413f-9aa2-77b7262ebb38@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8843:EE_
x-ms-office365-filtering-correlation-id: 3da5f420-a36b-42b6-b80a-08de0fce5154
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Zm9OczhsckhBTUhKeE1lLzd3L21wL0U2WFZKcm9hdEI0T0ZpYnJTZE5KK0hL?=
 =?utf-8?B?ZDZCbWM1amQ3cWMrYmRoZEQ4aWJsMm1MK3ZIQkk0V0UyTlRwS1NITnNyT1RL?=
 =?utf-8?B?TnNKNHBNVU9VYVBSTjVQY2wvWGI2Vm1TZ3A3YVUzSzM4bTc0OUNwbUxaNisx?=
 =?utf-8?B?NitHSWtVM1RJQUxFcm9qU1dCVkVBTnZJejI0M05mdkp0eFdwd1VvWUw4KzlG?=
 =?utf-8?B?V1lsdjJ0Skh4NzlYbW96VVR2cE8xMUhrc1dEQ0p3Rk5TNGEwY3k3Q01zRjJh?=
 =?utf-8?B?dXVUcHVyQUU0ZEtoNSs0RzRCUmViUWRGSWRMTGFpRWFnNVZoTjVJU0xHNGRW?=
 =?utf-8?B?bER6RHd6VjRyMUtma0JvZEprMzVWNm5Hb29na2s0SjJ3QkRDOGZGZzVDUTZU?=
 =?utf-8?B?RzNIUzdQNldDQTVJRGlNY0laN3UzNHFMRXJReTArOGU2M25sTzRIMFBMSTdZ?=
 =?utf-8?B?S2VDT2hNRDVTNzRIamdSTmQwR1o0eFdQY2g1QW1pZGNwb1hpZ29vdGpjNUVo?=
 =?utf-8?B?K3NIeFJVY2dxQjZVd3BBYXEvaVFwMW1COEZPWENmemJmUnA1enJxY0hRM0Uv?=
 =?utf-8?B?eE5hWnE5aGpYN0tCdXNBNWtZeW1uYm1STC9aOXlDalR5UFNSdHR0dTVzUnZW?=
 =?utf-8?B?S0hWd0ZjcnpqZ1hMVnBzNHFTWVBEVmlsanZ4Z0w3WFRrSHVIcnNDdmFnSEp1?=
 =?utf-8?B?WDgyVXFwQzg5Sks2ZE5TODVDeGNnQTJKeUpiZWthUjJhdVFnL200bldEVlRw?=
 =?utf-8?B?STNvckc3L0c5SHpib1hpOW1Sd2dRMFNPbHlocTVkbzgxZktEZEU1TlNIYTFp?=
 =?utf-8?B?cWM4am5yODdHSE1NRDFkZExPcCtPdWN1RDVERjFCT2pUQ1N0Z2NWNVRrU2xX?=
 =?utf-8?B?QlJ0RWp6WUtDb0hWZmZva3E4T2xnUThNbllHR2tPcHJVT3g2S29xOWNzOHFu?=
 =?utf-8?B?MXRHZHVKRmFPdlozbXh1UFNGcE5yMFNNQU4yTG9PMXMxWGE1VzdKUWpPT3BL?=
 =?utf-8?B?cG5ZSTU0SitMcVJvWTNmZjZEUG51S1owVGJtZU1maHNNcG81L3JRdlNFdkti?=
 =?utf-8?B?ODA4NHpZNGtIZEpYWjh0NjFzUnJteW4rWm9RZjE5eTcycjFjdFBjelNuNm9a?=
 =?utf-8?B?YzVLeTlOZUluMTJWTmtxNmFoNi9pSXF3U2lDV2dvWVlZN3IyY01iVXhKQ09K?=
 =?utf-8?B?T0RpUFErbDRCQXBKSnVuWGRPbUJDZUQ0STVTdEpLZVpJa3RyTHVjeXhIS2VM?=
 =?utf-8?B?RGViRnp0aUxEQnVTTWNYelp2Uy9iSXdabW81ZmtYandERE93QUtGU0lrZzcz?=
 =?utf-8?B?M2J3SWtiNHk3USs2M3BrQU9zQ3dUL21rQXArZXc4Yms4aC8yclpjWXpXODND?=
 =?utf-8?B?ZE9BZGM5cVl0QW9zZXpKTUY0RkE1elJGUkxvNmt5ZnJmR1cxU2QwTGlFM1Vz?=
 =?utf-8?B?Mm9iRmFZKzEwUEpCd2F1YWNsa2VhTlZWaEJoVDgwUU1vRFk5R1NUVmNaTW5J?=
 =?utf-8?B?TnhPZU1sN1NRSEFINDNFdjBVWmtDMnRqUFJPbi9vODh4VlFMV1N0bDRuSHNp?=
 =?utf-8?B?MU91QzNmazl1ZEE1VFYzYXRxejhVTnpicUZEcTdpOTQ3dUV6OHZSeUxNTnJ2?=
 =?utf-8?B?MzdHb1RRN1RHM3pJbTZYVnlsT3JQcTVvNzFHYU5BQWxRcHgrNHkzNnlWZ1ll?=
 =?utf-8?B?ckVJL21YMXdMUW53QW4rd0FkRmJ1czUzeHFXOUVVOUcycUQ0bDA3N0FnbDZC?=
 =?utf-8?B?MkJFQzdtcHQ3R1Y4U0JjS2JBdldjYnZvL2d0by9XTmJBaElxYmNObm5hMlBD?=
 =?utf-8?B?Z1RHTnRnOTVpMW9rb1NObUM2M2NaMGJSa2FkbWN1ME5jL3Vtd01PaklsQ3Nu?=
 =?utf-8?B?MUZ4OHZlSzhyTUs4VWJZenVDNVptMGdFQWFkd3oxNGhmYUM2cVhKOUsrZHor?=
 =?utf-8?B?TEIwc2dOTE9XdGhseEd3dnA0TFJsdE9wU3RRSzRGVnZCUHNvdlN4RVdFV1Bs?=
 =?utf-8?B?aFcrclB1bGdNa3MrS3pRaHkvYmVJS0lFeXBwSXJCbVpSWWhSOVpiVldUVldu?=
 =?utf-8?B?bElsdTlBTldFM2V4OEdOa3FjeGI4RlBnT3NYQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWd1Y2Q3NFJiekJoOEpaTzMwdnZKZHYyV09MazRDaTE4VWZTbmpzeEhzOXZj?=
 =?utf-8?B?N3YxaEFKbmt0bU5BNzA3YWxPR0Z5V0YvQWMvQXdydEJSZFlBTHhlNUNqcitH?=
 =?utf-8?B?MjUxdXQxTG9QQzI2M0lyUVNmQmJlRU5aeW5pRlA1eW55MmR3U3F6VjA0eTl5?=
 =?utf-8?B?SWlXdVl0OTkwZFVFWDdUS204TzBpTTVpNCtEZTNpd3ZFSk5xNmkySjZkZGFU?=
 =?utf-8?B?anBGbEFNOWU0NzFaVzVYQ2RucSttWlEySWl5RjE2ODlMcitGMVdRWVE2QTB5?=
 =?utf-8?B?aitIbWFIL2Z5V2VOUEQzMm9hZVFyVHEvWVg3Nkd2eWNJWDJvWFcwSTlUa29Z?=
 =?utf-8?B?b3dYOVVWSUI4ZS9tNkJVNytBM0g2M29QY0ZFUWRQUTJLMDNqcjZOMFhGdW1q?=
 =?utf-8?B?NUVsdHl4ejRwWEZMbUwwRVFVQUJSNWNVWThwQ2l0d0tsZ1h0TWI3VElESXlo?=
 =?utf-8?B?RE1HbmV2N2oxS1J3eVREZS9VM2RwZGd5WHhwZFpwcVBMNjh5QUtoalozUVRV?=
 =?utf-8?B?VHFjRW1TQjVKQ3pBcGh2aytqSWxYWm1pYXRvU0J1d29yNHFnV2tKUU0yQlJn?=
 =?utf-8?B?VGNpZitlQTBMMDF0MnRCY3JOVHh1S2wxVVNHUG5kUEJSMmxYTHI0MmNIVWlP?=
 =?utf-8?B?b3dDcXZBdUFjeGl4VnVtckYrYUlJSkFiWWhISC9oNE1Pb1V4TGQ2QUZ3MHNa?=
 =?utf-8?B?R2wwUm44QUswaHdjS2NFU05zWFRDVkJ4WEtkQkJ5Z1p6RHRWYzJ0V0QrUFFv?=
 =?utf-8?B?dWVPaVNLZURCMDk2d2tyaFUwdG1YWWNNSnFSOGk1QzRETk50bE5GRDA5UXNw?=
 =?utf-8?B?aEtTZHdxS2FFSzhZVWdsblBnb2FCRG1vNllJNUNRMS8yZEsvamNrV1R2ZWMx?=
 =?utf-8?B?czdUU3VreVpKU093ZE9CUXRwK1BVNDNxRExrSG03MkU4NTQ2c1BsbUNWNlFx?=
 =?utf-8?B?aTVESFd6VHpJNm1WWkpDcUEwQTg3THNydFlPTk1IV28zckVVTHF6aGFzOHBn?=
 =?utf-8?B?SS9LK2RUR3B3bXc4dmY5dVVUNkF2MUdlRnkrNzRHbjR2SFYwc3plM0Q3R1Jt?=
 =?utf-8?B?UXppUXpFVmRJemt3SVBFL1YrZU1MYityNVRQOWhudzFSNkZIWmgvM1pmM21p?=
 =?utf-8?B?OGF4ZFlOVGgyOWF1RFAzQlpwWEFWbGtKdDRValZheXNKN3lpMkNJYjdRSWxT?=
 =?utf-8?B?bHhyYnBBZld6OUQ3OFdqcUxqV1BKWXVZRFBwTmVpK0dsUG9waVgxS1NFRHl6?=
 =?utf-8?B?T2NnVUhpYWcyeGMrdGRqV0p1RlVvMWF1Tlp5RG83V2tKQmVtR2xVdmM3ZkVp?=
 =?utf-8?B?ek1TUWNKVTk5eWFlcDB6YWl1eHRMaGk4N2ZSc2duSGFtVSt1bktYbEkrZmNz?=
 =?utf-8?B?YnFxaENKVjF6QmovbFZlT2xveXZyQ1NpMDVKWnZ6QUltMEwva2pmaFRXSUpl?=
 =?utf-8?B?WjdmSk0wNUxIRDJEcEtMYkIzN2hyU0tjdm5GN29Ld1NuNno2NDN0blZhb1BS?=
 =?utf-8?B?UFhUZ3N2ZzU1R2FwM21WUFVZT0M3ZVBlZkJ3U1lCY0VvbkN5b3B1Zk9jbzJx?=
 =?utf-8?B?MGhKTXdOVERoeXl3aldLVXhMTEI5VVMrUzBvZ3hSNjEwT2xNMkpmaGowYlhC?=
 =?utf-8?B?Mk9aM2VkdlVMNFk0Rllvays4MC9KcTdDL3NuTVpTc1kxek85M2RIcEZrZmtn?=
 =?utf-8?B?bFFFaU1GY24ybHhremZXUjhaSWJUUXNKdDlnbzZJL3RzclNGb1EyUDJEeFk2?=
 =?utf-8?B?bHUxckJJQlhBU2tJcUU0dlBQQ2ExejhQemlvT2EzOU9rSStLeDlESUtjN3Ur?=
 =?utf-8?B?WjhtaE1ySXZmcG9wT1loQjIwUDFlQU1oVlFvVjRaNFU4cWtvdVB2RGdCQnRK?=
 =?utf-8?B?d0o1YVgvOU5TQTlxSVdvZEwxNm54RnViSnVteE9QRVMxbkw0TVhyTyt0L1ZI?=
 =?utf-8?B?MWJmaXFkdDhLeENRRzJkVTVnTk52azdSR3dlQVRZQ05jTTJCd2dnaWlGeVJY?=
 =?utf-8?B?RFFHWnpqa1V2ZnBHalIzVWV5OWpzTUtjeGZlMTJrbzhkMXJMeGZsbDJxYVBK?=
 =?utf-8?B?dEk4T0xkWW5LWFk0d2wzSWZYWndXZEN3ZnhOcGFhN2JXUHZGTHJxYU5aTDQ3?=
 =?utf-8?B?NUNoeXBTcUhBb240MEhKSXlQTzdIMTJMdjVqRC9JWHpyZ3kvbFdQZEk3eEV2?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB7752DCE343654C8C82A171BBF2146D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da5f420-a36b-42b6-b80a-08de0fce5154
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2025 11:46:33.4878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OW93m9evaW9UNWgaLhte+OxQ6n0Ej23kijUuSV1mFMvTzRdKOkPDT2CQA9f67BCzr10FVAMtFPDChCvAZXLIBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8843

T24gTW9uLCAyMDI1LTEwLTIwIGF0IDEzOjA0ICswMjAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gDQo+IA0KPiBTb3JyeSBQZXRlciwgYnV0IGEgMTAgc2Vjb25kcyByZXNl
YXJjaCBvbiB5b3VyIHNpZGUgd291bGQgaGF2ZSBtYWRlDQo+IHlvdSBhd2FyZSBvZg0KPiB3aG8g
SSBhbS4NCj4gDQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXguZ2l0L3RyZWUvTUFJ
TlRBSU5FUlM/aD12Ni42Km4yMzQ2X187SXchIUNUUk5LQTl3TWcwQVJidyFqNDZPZEVpY1pkbENR
azREb1VjOWJDMzJpbmtYSm55bjRtVEZ5cEdHQ0tfYkgxQ0psVzRFdDc1ZWdtbUtQQk9nZjNTSGNQ
SlRkWF92dDd3X2hwODItbGt5cGRVY1AzMnMkDQo+IA0KPiAuLi50aGVuIGEgNjAgc2Vjb25kcyBy
ZXNlYXJjaCB3b3VsZCByZXZlYWwgd2F5IG1vcmUgdGhhbiBqdXN0IHRoYXQNCj4gYWJvdXQgbWUs
DQo+IGFuZCBhbHNvIHlvdXIgY29sbGVhZ3VlcyBrbm93IG1lIHF1aXRlIGEgYml0IDotKQ0KDQpI
aSBBbmdlbG9HaW9hY2NoaW5vLA0KDQpZZXMsIGhvd2V2ZXIsIEkgd2FzIG5vdCBhd2FyZSBvZiB0
aGlzIHdoZW4gSSByZXNwb25kZWQgbGFzdCB5ZWFyLg0KVGhlcmUgaGF2ZSBiZWVuIGludGVybmFs
IGRpc2N1c3Npb25zIHNpbmNlIHRoZW4sIGFuZCB3ZSBoYXZlIA0KZGVjaWRlZCB0aGF0IG5ldyBN
ZWRpYVRlayBtYWludGFpbmVycyB3aWxsIGJlIGFkZGVkLg0KVGhpcyBwb3NpdGlvbiBpcyBzdGls
bCBub3QgYXBwcm9wcmlhdGUgZm9yIHNvbWVvbmUgZXh0ZXJuYWwNCnRvIE1lZGlhVGVrLiBJIGhv
cGUgZm9yIHlvdXIgdW5kZXJzdGFuZGluZy4NCg0KDQo+IA0KPiBCZXNpZGVzLCB5b3UgZG9uJ3Qg
cmVhbGx5IG5lZWQgdG8ga25vdyB3aG8gc29tZWJvZHkgaXMgdG8gbWFrZSBhbg0KPiB1cHN0cmVh
bSByZXZpZXc6DQo+IHRoaXMgaXMgYSBjb21tdW5pdHksIGFuZCBhIGdvb2QgcGF0Y2ggbWF5IGNv
bWUgZnJvbSBvbGQgYW5kDQo+IHJlY29nbml6ZWQgY29udHJpYnV0b3JzDQo+IGFzIG11Y2ggYXMg
ZnJvbSBuZXcgb25lcyBzZW5kaW5nIHRoZWlyIGZpcnN0IHBhdGNoIHVwc3RyZWFtLg0KPiANCj4g
DQo+IA0KDQpJIGFncmVlIHdpdGggeW91ciBwb2ludCwgcGVyaGFwcyB3ZSBzaW1wbHkgaGF2ZSBk
aWZmZXJlbnQgDQp2aWV3cG9pbnRzLCBidXQgb3VyIGdvYWwgaXMgdGhlIHNhbWXigJR0byBtYWtl
IHRoaXMgY29tbXVuaXR5IGJldHRlci4NCklmIHRoZXJlIGFyZSBhbnkgc2hvcnRjb21pbmdzIGlu
IG91ciBpZGVhcywgd2UgY2FuIGRpc2N1c3MgDQp0aGVtIGFuZCBmb2N1cyBvbiB0aGUgcGF0Y2gg
aXRzZWxmLCByYXRoZXIgdGhhbiByZXNvcnRpbmcgdG8gDQpibGFua2V0IGNyaXRpY2lzbXMgc3Vj
aCBhcyBsYWJlbGluZyBkb3duc3RyZWFtIGFzIGxvdyBxdWFsaXR5IA0Kb3IgdXBzdHJlYW0gYXMg
aW5oZXJlbnRseSBzdXBlcmlvci4NClN1Y2ggcmVtYXJrcyBkbyBub3QgY29udHJpYnV0ZSB0byB0
aGUgaW1wcm92ZW1lbnQgb2YgdGhlIGNvbW11bml0eS4NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
