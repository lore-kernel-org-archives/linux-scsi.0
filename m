Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8FB39903D;
	Tue, 24 Feb 2026 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771937046; cv=fail; b=NniKp1n8CJEZiUG/Uzjk+/SMUlJWX+2h/7q3cKMh64Hxiw+bAaH2S+UTRVs8SS2vCBdOSZb/cjGNcaji4yDqyLo8dffy8kNlKxC0rVV7XM6/os6ww4CGqGErMncbfxZ2VomegemaeE/5urELp5H+U1iKa48QfBIwkzE2DxWVpjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771937046; c=relaxed/simple;
	bh=uCgE0JzTIp9dR37sJm49X4xqhC4nh1xe3WeAfeU67vo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q07aZTK4+xtj32R9x1toKZFN9OtHatyl+/mGHDGg3UO/tu1zj2NphxgoUMQFnE/d7dbcW9uNkOwC0AmA3QSj6hOGJXCo0G2/zigIsTvtknKXOaje3qlIk0Cyx/jhDnniTffCFv/ii+/k3lzvf9Ixm1BIM4A6B0RynKtlbNv5j/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=TlqD2nd6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=oWHMIseh; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TlqD2nd6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="oWHMIseh"
X-UUID: 7eeebc9e117e11f1bcd7499a721e883d-20260224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=uCgE0JzTIp9dR37sJm49X4xqhC4nh1xe3WeAfeU67vo=;
	b=TlqD2nd6ha2NS2LL+AgDz4NkXbVswPT04jInEwxINupIzhZ8/GxDqJovyPd2qRbcacHokebWETFlJoJ6JhsyeSNNToJDHpH0uR403M2syj7FIf/CHpZHBxKG2WWt7NRda4hYKWYNH50gAQiqOFaImzjhie5KUMcmo1weGrdJEwk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:1ac83d62-ec77-4fc3-92f4-e25a1df8ccf7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:c669f0e9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7eeebc9e117e11f1bcd7499a721e883d-20260224
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1802964698; Tue, 24 Feb 2026 20:44:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Feb 2026 20:44:00 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Feb 2026 20:44:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pHY9Jg9O/K9wpLQQ46n3gZP2ygw5kn4amGnL7u/gyn+HsqUqlWE3BTAk2pEstkmXar3s72SWT6ZREqAP42X11XZDOa0tXa4xLuGsBGmwloZ/Wu/drrjGcXhkee4yuxeUyqFbbUGcTPPaMWREFANuKVrG3tCRklNfHIaDPBCpgSutSpA5+JZZQgqJns8GR8vvvJGXC2R6eKjxvkqrrwgHTE42oYmsjtqGelYCR7NPmu14RJ2BLvpbXN5H8iag7Jo9uT6q27yQxs2bA8oGJ79R2Bu8L/uiyNNp9/9xfAVEBY09ueVvNgmINxnNdMB5FwG8tdrIgs1i533fJ00Npk4PYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCgE0JzTIp9dR37sJm49X4xqhC4nh1xe3WeAfeU67vo=;
 b=WwcnwwcHipHmEKPE4u5+mqiJFYVohqFeSLR3ytQePD1cyHaLmHnRQdEFR9Hu15aP6YrJHh823E4TXUApSTwB9kTP7xLjzWlYC7C+W2+9vDBdWd7wbhu6+wWnSZDRQg/2YzcWyPqQNFvXOwBlBwWQXIMWgH+MaKCkxCKH4OBmPvscgg2/NSS2LcAEXsw2SAgCq9SgU+wLK+OP/Zy2hCGlhI6qCWW5JhQhal0xczeSs/IPegnFyje8HdH+Y9l1RRhL2Y2hDL+uv6u7bZuCo4nr62M5C2lIpVLXzalCNoEW1hvH12L9Ojhv4hLCZ5uNk5ayXX8mm7HtHIhGMyfsDBxUpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCgE0JzTIp9dR37sJm49X4xqhC4nh1xe3WeAfeU67vo=;
 b=oWHMIsehj8Q5NbpJnmJFUv3S+gCh9ejvoOuF4VkzVyV5Zg3Y0HpdOM+u8Mq3RTk4vWaqpurCi3DRis2/YnWMb09Bs2Hfr18+LC4jS7vCQxu4U7v6HZyRJOXNR+2xNfAGGykkOYYw/UqsePxbTfV9w2DV0fPxqnuALLF8GGNNbyU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8625.apcprd03.prod.outlook.com (2603:1096:405:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 12:43:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 12:43:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 15/23] scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale
 error paths
Thread-Topic: [PATCH v7 15/23] scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale
 error paths
Thread-Index: AQHcn0nZ09yCptE9yEeZhmn+2DmrKrWR1+YA
Date: Tue, 24 Feb 2026 12:43:57 +0000
Message-ID: <11ca930b1d7878bc39b294fd395aada1a846fa7f.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-15-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-15-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8625:EE_
x-ms-office365-filtering-correlation-id: a266d835-e4e9-4251-1ff1-08de73a26090
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?QnhRdXdrdUtUZkRIWGtteFhBS080TzdDV294MC90SXUxV0V0YXNVVjltRTNV?=
 =?utf-8?B?emVWT1hFV0g0b1l6dyszUVVYbVhYa2NtSXcrTDFleTQwb1A3SzZtM1RVdUpn?=
 =?utf-8?B?bDdyelFsTGVwc3lyVHlqOHFOT081MVVicWxNdG9hZUg3S1NDS1BFd1ZxSFRG?=
 =?utf-8?B?cGVHejZsVmNLcGJjZzNZRy9tRXZRVHl2QlkzV2p6NFpFR1ZpZEp0cGVhd09x?=
 =?utf-8?B?Z1hPdVpKd0taSTJCejJqdFFRaFdEOFJqOTJRLzhmRE0xdElwZDlPSEQ4MUdN?=
 =?utf-8?B?aU1LUGRHSVAxSDFRNUpsV2JoZ1lNdE1sMXc2SG9tRGxWbWtPcFlzUS92YmhZ?=
 =?utf-8?B?Q203NURlK1RObWcyMytKS1BWMlZhM2hpTGxMV2dqaER5REVLbkFrYVlLTlpp?=
 =?utf-8?B?YWF5VGh1elBuandWMll3V0FYZHV0V0NMcFNrWUhMbjZUcWRjTTVyL2tmOEkz?=
 =?utf-8?B?bUFWK241VlhVU0ExRkovSUZmc25ya2JqeUJVSDhoL041NFdzZ0ZWOG5SbDlG?=
 =?utf-8?B?UnFqQVN0K1VVRTF6ekpIQWJGcjJmWEFHeXN4RTloZGZRN0hhMDNZVmNlRFhl?=
 =?utf-8?B?V2pGVFlERXp2Sm1Qb21ITU9zdVZTeW9Ed2lFaVo4bklsUVhodGZTckREOXNO?=
 =?utf-8?B?VXgzbm5HSGNiNFpsSDBjSTlaN0p1RnduYVV4UktITUR6L2h1VisxeitubVJ5?=
 =?utf-8?B?cEI4Q3AwUVBqV3RINW5pVGpkUkpvdnRTbjZVeG5PaTFQZkFjTDljTXRKeWlV?=
 =?utf-8?B?UWtYTFNqUWtZYVYrbWcrWFkyUmRmRFhaSWQ2VUJWSURmT2U5OFFBckNDaGw0?=
 =?utf-8?B?d2FBUG5CZzR5aU9UaGxLOXgwY3BwZ2FBemNWcUlDTjkxaTlyUi9EK0JyelJR?=
 =?utf-8?B?c2ZSYnNaNnhNUnJ6dmpVTnVLY2xwdDZVZ0c5UFRYemVPNENzamZzQ2NCRTFU?=
 =?utf-8?B?dkRlYzh2TDNDdEZsNnVnaGZHN1VwSzNlVnpYNjl2b0JpWk9lV3FTWW5ZcHhM?=
 =?utf-8?B?Y1pZTDd1Y25FeG9nUFcvNVNRYkloc3Ezd1dOVDlsdjMwalRRZ2dENzRsdWRY?=
 =?utf-8?B?RnBvUFdaYlR1UjlwYjVwaU01WHo4citXcDIzdDRPVmV6R0ppUVBWNC94WFpl?=
 =?utf-8?B?ZzRLajlTMUNBQnB5YVRGakdmc2tiRGFUZWF1ZWRBTUJDYTdWNFViRUsvbHlq?=
 =?utf-8?B?ZEhnamtwd0VKWHMwdWkwZFk1TDhTNmNTYVk4Zll2ZzhpYmp1Wm9NWlQ3cWR6?=
 =?utf-8?B?cUxKVThsVzFxSmI1bjZxcXY1S0R4cHJFSHlIQ0pkbndqOEFGVHVqaXNhcjNB?=
 =?utf-8?B?WTg2NW1BWXFjOWRNaytrd0JGUC9DaEZRc3VkZ2QvU1BQWjBYSk12WUMyUEpM?=
 =?utf-8?B?MXdyamZYdjMzV2JtbGlNek1OQTk1Q2hJbkwzc2hsalRlYzI5TFlWQ2xERXJO?=
 =?utf-8?B?b3dxQkl0L2ZITGN0Z3NybVpUNWp0bUtGdzVCQ0JHWnplZ1hSSW05aTZjU0lo?=
 =?utf-8?B?UDNwcjVEbmdVeVlHYno5cnJuRnZNWW1WQ2dMWHJWaFZrY203SW5ZdmhBTVNL?=
 =?utf-8?B?eGlCREFsMGRFSTRRbXdaM1JrVkJLVi8wMStWRnhRay85TFRhOGRNTndndGls?=
 =?utf-8?B?YUhYTnVBdmJFbERrbEYyZGJaMHgwckwyVHVHMHVHR25UYncxek9oaVRlRnBH?=
 =?utf-8?B?ODBlVFN4S2hZT0prOEZuRGE0Z1RvMTRDbTJLYlRiQnNLbS9VR0VZN3Z6aXpT?=
 =?utf-8?B?UjFseTllK0g2cHpJeGxaRnFyWThJd3J3TnpkMlRIakwrVGxnUlc0THFpSG8w?=
 =?utf-8?B?UmxQc3l3eS9ra1dwdzZXd3dNb2hRMVNPU0hNcVEvMmhOcWFYb3Vja0lPdG1I?=
 =?utf-8?B?QlVScE9mMFNIcElLYzh4V2V3T0hiV2paS0VEVmowdkFZcTNpOFllM0R3aWZW?=
 =?utf-8?B?Sy95NlF1d2ZUK29GLzNRK2pSelltbUJkUzk0UFVrUVkwaHJsdGxYV0p1VHA5?=
 =?utf-8?B?RDdKZmEwVTFJMGdpZlhEckdaVEF6MWFoVVQ4ZWsyR2FhNnpMaVBMajVsbm9u?=
 =?utf-8?B?VzdtbnBLZzVETEVTbFhQVTdhc3h1b3JKemhnalB5bXNQWXY5Y3p2UDVGVkZC?=
 =?utf-8?B?bC90MXZRak9ONU1zVkVZMkhpOGFwcVc1SFlHVzdnOWFXc3ZpTXZwNVV6bEIr?=
 =?utf-8?Q?yQmqr6gfzUOeKHSFov40XxJ49rMDifayUsGi5RJlaEy6?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0hyOGdONk1mT1d1MnZBTHlPUk5tZnFMMVoyNGlYTE9yYUlxL2JrbHlCWVVo?=
 =?utf-8?B?MTJDTXk4UXQ0REYyQlp0WEw3bnV6VXFPZXA3VmR0Wk91YXY5V3RKRTVxOGto?=
 =?utf-8?B?aUJSeVJIWU94QkZoWGdhTkZMa3V2aDR1K3d6WVN5Tm5ia0wxMS9ZOFZ4Ri9J?=
 =?utf-8?B?MEgwZ1JsL3Zmb0Y1ODkvWGx5WWFQT1FHL3R1WUlKbHNadGpJaXZrMExLcFBQ?=
 =?utf-8?B?MVEzdHVlT0s0WC9GeUpqSmFVb0NpVkxhaGhUSnZyT2t1SXBTejFJdU10NGRG?=
 =?utf-8?B?T1p1bmZ3NTBoWFZjdlhYSDFZTnU5SW9WdHoybFZERk10QjhLUnc2QnYrU1pP?=
 =?utf-8?B?MGJmVW40d21MU3ZIUVZWbDBNSkdkT0cwemZ1b2p1RkNzVXR5VllvdDlKOVdq?=
 =?utf-8?B?cW1XaGk2RlNoVS96QlBGMldHdk54T2VNZ3I0dXNaN2U4Q3ZiQkRSSktnNFJa?=
 =?utf-8?B?bGl0Y0xWOHdETUxmekVOMFNqWU5VVW4vRmFmT3dHNnd0YlZWOWExMUlXS0gw?=
 =?utf-8?B?VVFWVlc4ODlLSDNuemEvYk1wV3dlSGlzT21mdUMxeEhONmNjUDZSS2R6S1da?=
 =?utf-8?B?REVXT2trV1ZTNk45YmhWYlVienJvN3FlOXNSZTNKU3NGdG1Nb0p5UkNENkNh?=
 =?utf-8?B?YndBZ0Jod0VSWDd0NWw0WVdUVTJHdzZmTjhRYmR2S2gzZWllTDFiMlpMdjJu?=
 =?utf-8?B?VE4rT2xnOFg2a0ZYUDFLNXhEOWMzbTg1WWowb2JLRnRNelZHRGswU0NtV0VH?=
 =?utf-8?B?SFFEZ0xQa09RYi8vVkplMEhFSTFhY1dzK2JuN3pmLzJCUFdqMU5oV2FWU1Fx?=
 =?utf-8?B?aXVINmRJaUNFeFZQT0RuUlQrR29aU2ZUN1R3TmZJYmtqOHQrc3hkNlc2NkFK?=
 =?utf-8?B?SHJJNW1xOGZkN2VnNEgzUDREOVNrQit5dE1hWHJzcHJWT0xMSVZ2aDc3TzRL?=
 =?utf-8?B?TS9MUnFwcnFBK0J1N3JyVFFsV3dkUmxWY0VYOFIrMXYrdGExQUxDVzkvamVE?=
 =?utf-8?B?N2w2SUllOUYrUW5vVENpQlZ4RzZMRnpoZFo1U2JCRjA5Tm40b0Y2NnllbHZW?=
 =?utf-8?B?dGdpZkxvNzI2cmRIaXR4bFY4OFd3T1ZRMTRHd3FuWEhXZCtFcThnMFR0T0pX?=
 =?utf-8?B?WDVmbGsyZU5zbiswRXV3cDJ2TExzTGJNV2piazJiK0F4dlJIaTVBVVU5c21K?=
 =?utf-8?B?N0tacHMxUi9vV21JcW1Pd2p0U1MrQTFWU1JGNXFiMm9yck1UU0hBR1ZxYSsy?=
 =?utf-8?B?TUlKWUl0UnpYakNJb2w0Q2hGeSs3Yi9NeU9OekVnNzJRU0h5SmN2alQ2Y3Az?=
 =?utf-8?B?SjhueXJEQlBNY0pYeS8vWWVINUtyeEJVdVAwNko0c3l6aG5pdUVkTm8waXJO?=
 =?utf-8?B?SG1yY1NvNDlUVjhDcnpEQTk1eHFaVm43ekFYQVB4elZDTUcvNzU2WE1WaGRw?=
 =?utf-8?B?WnYyZEVWanRZanBMQjlmbHpZMm9WZWsyNVN0Y2h6bklhMzBzeUVUUmN2dm9C?=
 =?utf-8?B?SFJTTDdlbUVtYUhOMXVaU2g5ckdTc2dNa3pJUTZxZTRqV2N5cXlkUVlqTHlo?=
 =?utf-8?B?Vzl3Kyt2WUdDUzc3NlFWS0hpT01icjZJVnExVGZyeWxuVENrVGpHY1BMQ2dO?=
 =?utf-8?B?WjUvSGduVGRDZnZQZFVjL2VQcnRJYjBaYUhyeFl0WktWWnNPeFU0SnVkR04w?=
 =?utf-8?B?YjBaNDU2UmhEbExmU0lWcmJQTUwrNG41anBLSlMyalFJakxwQlNVeEhlcmcr?=
 =?utf-8?B?YUc0V2pIYU9sVWtlWkVUanU1VGRJNDRwM0RhaTRpWDA4aVl4d1RlZ1ExT0hx?=
 =?utf-8?B?U2hIYzlMdE5TOWx3QlgvdWkzUzlxWktoUmlmWXdkbDF3NTZyZmdpTURqb2JL?=
 =?utf-8?B?Sm13ZWd2SFNyT3JTUmF4a3J6bkF5L2Z4RTdaa1d6Z3BySEIwZ28xeUpxVHBR?=
 =?utf-8?B?M3VwOHJqRXlTb0J4TUlrbm1CN1I3MVl3c1hRdWNneGhQaUc4bENpUWRta1NB?=
 =?utf-8?B?T1ZmdFNlbzNpbEIwN1RGWEI4Tm0wM0VPNTU5ekh1U0pWdlBKYzVwNWo1a3pi?=
 =?utf-8?B?ZG9HZTZzejRBY0hXR1JHQ2hBTWMwc2hCeUNENkdEYU9ZUEtRaFkwbHZncC85?=
 =?utf-8?B?R08rTmlyOVdYR2paQ05mU3I1bHFUSEZvMjdOWGVuaTd1ZzhzRnllaGtSeHRZ?=
 =?utf-8?B?RGZFS29vYnBHdG02ck5nM2lHRnZ1ZGMxMWRjVFZJOS9TUERyOE4zdWpuR1Ev?=
 =?utf-8?B?N3Q0eXQzQ1JTTE9RQlVTMEJIWkZiZk5JUzVRMyt6WGxpdTRybFllVXY3RzM0?=
 =?utf-8?B?V0RiTC9Rd2NRek5qdDcyMGJjK3ZpSmw5RFNlWnVBLzl0elF0ZTkyYlhmcmdm?=
 =?utf-8?Q?+DtaExrkrssE3OYQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E41829263A3A65468EF6034F02DA5000@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: a2ap1KbHJQE8lb1kBpyvhjGpRf6IgxDJS+Wsz2TMOhn4C16XCAZuUVsaXG+8RO7tf0XzEpCITj4qhREXdHSushe1TBdlKBHNbzIEI1VvY1kPUeQXA9UMuxiMXtq9Jru3P619P/iuZbCLbvQAkvJY2dJcQrU3sNVK4fmTyoDhzpcceo88IOPEIp6fUubxfCL83jC4v6yZFJ9M7KVhRTabCOugomqoNkUecxtTGl801CklwJQ87LDcE5nVSD0rES5GB6SbauQIehRDQz7SjNPP8o9NtS+py8fY7krcvbJ352Cbz4J7vt4H3vgfIBOyTNSHNj+iWlPiuZIPirVjh/EWnw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a266d835-e4e9-4251-1ff1-08de73a26090
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 12:43:57.4562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1hO3h1REF/W518yVGGRAwlOvLDiuT8sR03vJiwFy2BOeplAZobkufwEiEqV4pjnnvgE8q64K9G5DqRQcuJkOlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8625
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEVycm9ycyBzaG91bGQgYmUgcHJpbnRlZCBhdCB0aGUgY29ycmVjdCBsb2cgbGV2ZWwu
IEFkZGl0aW9uYWxseSwgaXQNCj4gbG9va3MgbGlrZSBzb21lICJnb3RvIG91dCIncyB3ZXJlIG9t
aXR0ZWQgaW4gdGhlIHNjYWxlIHVwIGNhc2UsIHdoaWNoDQo+IGxvb2tzIGxpa2UgYSBtaXN0YWtl
LCBhcyB0aGUgc2NhbGUgZG93biBicmFuY2ggb2YgdGhlIGNvZGUgZG9lcyB1c2UNCj4gdGhlbS4N
Cj4gDQo+IFJld29yayB0aGUgZXJyb3IgbWVzc2FnZXMgdG8gbWFrZSB0aGVtIG5pY2VyIGFuZCBh
dCB0aGUgY29ycmVjdA0KPiB2ZXJib3NpdHksIGFuZCBhZGQgdGhlIG1pc3NpbmcgZ290b3MuDQo+
IA0KPiBSZXZpZXdlZC1ieTogQW5nZWxvR2lvYWNjaGlubyBEZWwgUmVnbm8NCj4gPGFuZ2Vsb2dp
b2FjY2hpbm8uZGVscmVnbm9AY29sbGFib3JhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTmljb2xh
cyBGcmF0dGFyb2xpIDxuaWNvbGFzLmZyYXR0YXJvbGlAY29sbGFib3JhLmNvbT4NCj4gLS0tDQoN
ClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg==
