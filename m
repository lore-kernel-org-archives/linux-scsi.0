Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A6828850B;
	Fri,  9 Jan 2026 06:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767939779; cv=fail; b=uuV78+r+l78PWuQ6a1UVhPRftEJckwDKTcZpk3tquufU3pBoMwyTu9rWloUCfbQz6MDgtjkYM7zmRxsgcfX4VXs3uF0RhYXovEzaBoKTcM2qiOUeeUlp7txB/bzMCXWETSbXsX4EItdDHBfs+H+N9IZ4hWy/f14n5re3tjd1Jog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767939779; c=relaxed/simple;
	bh=8LtctvtYiqrySq89Y7LHzBJitRXttKmvKM1WUTA4i9U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mBtw953jzMTNlzvj735+3QSIe1XJ8BlugfgXRl4ST0Kv4pcHL1DymnRe7T7InljV91FtVgYE8+/6hxPbVe23S40rdYOpubmBzwbDrCPGWdxnIWQtzOHD1NgD3YyNK/rnM7QEUyPuhXQGau5Xg/gyomHnpY5t46H17ef2EsJlEzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kXxUDsUc; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=o8oymI+5; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kXxUDsUc";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="o8oymI+5"
X-UUID: a1e3622eed2311f0942a039f3f28ce95-20260109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8LtctvtYiqrySq89Y7LHzBJitRXttKmvKM1WUTA4i9U=;
	b=kXxUDsUc1868NIQBXjVEOyxw3TAYSEhp/Jk+Vegyw9qeMzEYfAod54XuvHsH9V3iHDY4hfNtw9yed5qtVkj5IjDVb2sbkLikPnvXx6liYemgBYd/uYG+LWXMW8jESuUYUVZh03ONAwbyOMZIBoBEJ9t7M+jUdeBZ4TMUNTrw9Fg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:f2b17e09-7791-435b-95c7-d5c1797a666c,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:8e6850e8-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a1e3622eed2311f0942a039f3f28ce95-20260109
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1090375623; Fri, 09 Jan 2026 14:22:54 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 14:22:52 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 14:22:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LwM0uMnzam0yQzqg6/YVhFjxsri0+A76mRtmC0f6DazLOt0/pbr4ZMjOnOVleMy0jC+ySYWh/KWYQagDrUfttA6TwH5rq7Ycqm3fWZW95f9nA9rL1MhJmDxKUOgf28gbWVRIKIPWjX3F/rvd90lPHv9s2Yg4XLNn91KwIZCKbeah4z+bTGOcKKpn/lPVtX2umEY0Dxjwc97wflOdm4NbTvkYIQg4p+gnSbFO9K/1gXInIJP1b4GvY2Zh6wMiUGyTJDjVSmZqo0mmtcbBTbylwPaUSsm3GtGz8HMW3RbisqFgBiy0HyJkd6izLTXeOjdn5dZ19C9gwVZ1kodLQT0dtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8LtctvtYiqrySq89Y7LHzBJitRXttKmvKM1WUTA4i9U=;
 b=w83SkNRDr3FweMyEBa7vCatgzTOgr+HdNMAtmOLA2cxDvQiBIalASJpmxY5E0+FzgcIo9/YHXW+8IkzhbbmAssKkrQMJsHp7DV+cuIy3cu1Pdw2k4sd9Qyw5OCwjGNRE9Kf4Lh2Se0xTZd0BJb1o1V6L2IxAcnGP3CHKskZlQg600RmKiQf/krqJ3cl3ow3liwV3KqFiwFp4Tors9tMTn+awOoe7TnWcTpMX4kgyqCTVCBnB2wyqsMXBcnhqDXGhu2gSXMOCxpMh5M+Fc/6VW4EJvFLtwjzcq7qBDHmWPcJj3zfvjF+UyZzzauwuW4C+wV0pXKMUy5IeiUbxyIEIew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LtctvtYiqrySq89Y7LHzBJitRXttKmvKM1WUTA4i9U=;
 b=o8oymI+5t3wIwx+O44Dl+ZIIkWvNMs6He44Lk2vgK0GiC2h42D3ixiC78xxZh76LdkyTrACw2ikyvLIMLxoiFy4KCui/Msx7V9g5yfwGDxnHKEkbZpH0LL9/VCtvzumS6jfDVZSA+YtpCr/8ylsfdW11AnEjpMuVeEroYzcb48g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7453.apcprd03.prod.outlook.com (2603:1096:820:e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 06:22:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 06:22:49 +0000
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
	<krzk+dt@kernel.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"p.zabel@pengutronix.de" <p.zabel@pengutronix.de>, "krzk@kernel.org"
	<krzk@kernel.org>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
Thread-Topic: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
Thread-Index: AQHcgIzex50QwHB34kulYV8QY4/tvrVIMsMAgAEs4YA=
Date: Fri, 9 Jan 2026 06:22:49 +0000
Message-ID: <dd2eba99adaddf7517f06acf7805d32e261fafa4.camel@mediatek.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
	 <20260108-mt8196-ufs-v5-11-49215157ec41@collabora.com>
	 <81ed17eb-2170-4e97-b56d-488b5335ff5c@kernel.org>
In-Reply-To: <81ed17eb-2170-4e97-b56d-488b5335ff5c@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7453:EE_
x-ms-office365-filtering-correlation-id: 5e954ecb-e9a2-4cc6-5c37-08de4f478334
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bG1FN0t0VW5hUGNjaVhFTTFPRDNybk9EL082aG5weVlFdzJIWWtMTlRiZ3NE?=
 =?utf-8?B?ZFpiOW1ldExoQ0pXUGVIdmxzZGlKbnV6VzVZeHg2eXVoYjY1KzFLRWZVVlh3?=
 =?utf-8?B?L29MeWc2L2RmZzV6eDBSbjBUNEZoNVRubGtqQ0M3MnhRMnErUk1jSytXRzFi?=
 =?utf-8?B?TFJ0K0t5ZkpNUTA2c2UwbDBJUGxSdWdEdHVJNmlsS0hVc2lRaFNiYk9ucHJr?=
 =?utf-8?B?bzlhb2p6N2p3cmllaGtoMVBKbXJIdExUclp6T1FZbGZ4V1JIUWRXMGtueXhD?=
 =?utf-8?B?K2xEa0tjdWtLWTZ6TUdHOHRmVGxzekZ6Z004UkoxSVMzdDRSR1hPZlpYa01U?=
 =?utf-8?B?TnliM054bXF1RzZwaUFWRW9qL3cydG9FaUphQ2FqUG8yM3RYRk1jRURveGVP?=
 =?utf-8?B?ckpaelhNTVU1dkJ5Z25xTkxNdGRLYlVFb0I1ejVtcHNoazR6VldseWF6VW05?=
 =?utf-8?B?UGZhayt2SCtNQTJtZWdvVzJHdmpCMVMzWTM4V1RGNkVNSjUyN1ZuYWJhckRw?=
 =?utf-8?B?ZW1DVU5JMktPaCthYUhKcDhTTlZOUTlCRHFRdElJbEhxVTVnSGc0ODU1amI4?=
 =?utf-8?B?TVZFQ3ZmWkJwb3FsUWJzSGFlL2hiTlQyaTdJS3FkcURXdG55ZVpnWEhxb3Z3?=
 =?utf-8?B?VHZJUzNIQXE4Z3ZKS3czdnZHYUYyK0c1K3E1azRkczJLUitmd3BGbDI2TGNK?=
 =?utf-8?B?dkI2V1VaMmpHUlYxWXVPVjVLb3FWazhvY2hqSTF0dTZ1NEw1cGJUOUZyODN3?=
 =?utf-8?B?MU5HRzFBb01LNGN0b3ZRYy9KeTZXMEl4L3dhVG14WThPcjdLbDJhMXYzUzl1?=
 =?utf-8?B?ekFyQ0kwakM1TmcxVXdTdCtPa29MdDdwR0ZjOEZoVTdHTHMvRlNlZkx0a21H?=
 =?utf-8?B?NEQybFUwTDB3N2t5QUxTUVRONmh4Szk4VXA1aE1QYlBwcWJmeDJkL3l6V1RJ?=
 =?utf-8?B?ZDBzdm83WXVkRUtXRTJhV0VaRXZnUjc0Wm85SFA5YTE0Kyt0d0J5ZEE3ei9o?=
 =?utf-8?B?MWpyYkg2bGE3UnZSNjNjWFQvKy94YVpnVWFjblJZSHpaSWVSZWozbVdyWDND?=
 =?utf-8?B?WU9uSlZsMFlFeFg2VlJlemZibkNMNHMwdEh6TmkwbWU0TWI2eFRwUkRjSVFM?=
 =?utf-8?B?Z2haRHJyYXVnM281alVGRVFoclQ3eUlRZmZhTFRuN0lhL1RIOUlPbXpYTnNV?=
 =?utf-8?B?SFpleXZQcHROTlBXOHpiVUVQd0ZadTJIU0JOdW9wcXM2TjJBU21NT2p6ZmJJ?=
 =?utf-8?B?TWlEa0h2UE1jV08rR202ZEZBTmwwTCtXQ3h4WXJxVjg2UEZFZ09oL1JOc1Ez?=
 =?utf-8?B?SDIxTVdyMWdmNCtGUWdXTnpzU1Fodk9EdjVMbDVoMDB0MVRQL1dwK3AyUGly?=
 =?utf-8?B?ak5wNHhid2JkekJEbjdHS0llMG9mN2w3Zld2Q0hMeVY0aVhwSDBINXY2RGtk?=
 =?utf-8?B?M2huQ1N3dU8wZVhCbEI1cysxOWQwbU9aMzVtTjkzYnp4N3A5dnQ2ZHhiQ2F5?=
 =?utf-8?B?ZENka2ZKcVVFYmNqNXQ1NVhmT1ZnMFRqdTRvMmltQS9kYy9relNVOGpVN1FN?=
 =?utf-8?B?WHNQaHM0cWplamxsU2cyTDI1dmRKaW9HTWcrYWtCZ3VxTUdrU1hKWGNuK3Zw?=
 =?utf-8?B?TEVUalZFbERaVWFHdWlpUHJ5dWNlSk0xbHg3Smcxa1Z6OEZkK3hZVFB5d04x?=
 =?utf-8?B?NnpIbHpIWnQ0aFkvZmZ5dWR5TDBOalFPd3JPMlFURy9tSTBlNjZ4YVBxcVFn?=
 =?utf-8?B?VXloVjJ5VnR1eDZDZ0xKTFQ5eFpmb3RBMnZMeW5HdlcwOGthK1lpaEZrRWEy?=
 =?utf-8?B?QzZmTlJmMThWSmtoYi9NWm9vUzFCck9obGpOT1ZjYnFBd2xxK1pyRTV5SnZ0?=
 =?utf-8?B?MWkvTERoRDNveVliSkwvUUlMbEUyQmtWM1FXM2Vob3h6ZFRMYmdERWkzclI3?=
 =?utf-8?B?bGtvZkNTRXVXczBYbnFTTlV5TitYMnRQNnl1YTNveWdpb1NMcWIxTllRRGk5?=
 =?utf-8?B?cEFzT3NTQ2VCRXAzNFdhaGhPMEJmYUZMSkRqdlV5bGRVWi9GUWNsTktMc3E5?=
 =?utf-8?B?cEx0M3MzekVGZ0p3Yno0NmNaMG9TMTJyWWNDUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDdVNHlENmJGanNoMHEvcVUvczBmc1RvL0tQSTUwMWpVcVkzeU92aUFNVFky?=
 =?utf-8?B?UnRJSmVxbHNla1pyQWlrOVdSVEh2aDlPTjlUV3o5Y1Y3TkN5QzhsRVNrN0dK?=
 =?utf-8?B?dkVFVituSjZhSnBjQVdjdlhycWM4c0RSVjBVcytKai9zWVZwZ01qQkpIZDN3?=
 =?utf-8?B?akJucEFKZ2hWNU9uTkROSW9ZUjdXU0prWVE0WW5LZVloemlIRjZWNGVBd25a?=
 =?utf-8?B?b1QwSU5TQm1FU3RnK3BFc2x0dk4ybnFVR3doUDZhbEY3ZlRsYWEvSzExaDVa?=
 =?utf-8?B?WkNhaUxHWUs2b2NpaWtZdVViVng3bXZiMlRxc3A0eUhEVVFUcys1QWFIL21Y?=
 =?utf-8?B?Uk5SNHkrT2YzQ2pnbFBFVkNxNHU4RWpKZG1pSythZGJxWVhRTkl5TXNOdXk4?=
 =?utf-8?B?WDg5V2h5Ym5GcFFMV1orSktRQXFqVDZDcXFDRjI0VFJoQ2hHRng1ZVNuV0tz?=
 =?utf-8?B?UXNhdG9XaFAwb0RhRGZOQlJtWVozaEhoWm5ERUtTSFJFaTVoMW1QTUgyZ1dw?=
 =?utf-8?B?VmxYV3Uwb0J0MngzWlRGUHo3YTVGeUgyaytlTTd5aUFSVHp1SHRkcTltMDZj?=
 =?utf-8?B?VTEwYmlWL3VsK1FITllpZFp6U3ZHU3dVMFFKT1FHSGxmVTN2OHFLM1liZjV4?=
 =?utf-8?B?SWszOE5teGVmbGNKRlYreVNGLzlWWGxTa1pvTlc2dC8vaEcrd1NGaWdKbzVL?=
 =?utf-8?B?UmFldVFNUGJDeHFEbTRTUUMyQjlheEd4c0IveEtCeGJyWGtDRE02SDMvYnBt?=
 =?utf-8?B?eGhEbVNYSHAzQXhBcmZRM3lSbW5ZMlErMmdFUEdybGdZQ3V2T05PRllHdDI0?=
 =?utf-8?B?V3JoZ3BoREI5cTRCNTZiSTZSMHBTdDhaazZHTXpGUUt4L3I1TUNEbDVCdnNh?=
 =?utf-8?B?Rk5ZdHZ2d2tOdkxiejIzNjlUeE9wVGVNK2xSem15VHlEOUFPNW84NlhMQ1pK?=
 =?utf-8?B?VzBHbHJCV01aa0xWSm43cktLT0hzU0dFbXZmTGNVL0lpQjFUTXFiV3p5bklp?=
 =?utf-8?B?d05XRm1raDdocUxReFFLZDgyUW5LMTJxWjlEb1d1T0FUK3lCcE5DR2I4RWc2?=
 =?utf-8?B?N0pZT05OYVBoWlp4MXdSazNpTHYzY0pLeHpFa0pzMlNqeXN1ejV0KzV5ZHA1?=
 =?utf-8?B?enRTNkRqOFFKUWNPNWlaMWlzaUgwaHFRVW9QdzFEcmdWbWZlbU1SNUlEZFBF?=
 =?utf-8?B?bkJGVUZNVksxRGxUMk9QUDAwa3diTmtxRHo4NW1SR0FnNk9TS2R0M2NISnEr?=
 =?utf-8?B?a1VMLzlqZkt4REY3czB4T1BzUWFYbXY3Y2czVENmWWNUblFPQWVzMDJ5OHhO?=
 =?utf-8?B?cFpNbGtnMUVNNjdPamd0dHFqR0Vod09DbjFCNzBIVHFLRnlFNHNuSW52TVdt?=
 =?utf-8?B?a2xnZUVKMklPYkRud3EzS0swSTJXYk5QOUdNTlNqWWFCUmRxOEFYVmplcG1p?=
 =?utf-8?B?dlJWVmNYWTg2eTdNZUtPMGpCRys1NzMyOWQ1MTV6MG5mVUJnOHRrZ0VXV0hn?=
 =?utf-8?B?TTlPckQ0RlVZNXlTeHlhQVQzNVNBQUhUODk5WC96T1hCb1ZTM3czZ3VRTEx4?=
 =?utf-8?B?cXN0NzJKZVpsVm9GMFRnZWl0a25sd3l6bDNmRHhHQ0NVeDBpd3dqQlRMc3BP?=
 =?utf-8?B?QStkbFBrOHR0OVJYaTJ5dkIvdjV2RWtBenMxd2g2cXZkRjhBZlluWHhmWVp4?=
 =?utf-8?B?T3dzQmg1NWpCWlMyZ1VuUzhTaFplTldkOGV1MnREbEozQm9BUlhZTnQ3aHNN?=
 =?utf-8?B?SkNyN0RkQlB6YXdQaVdpZzd1YSs2SHdPMUh4NWJSZmtVWFU0RjFxYWJXS1RT?=
 =?utf-8?B?VHNZUlF0Wkx0MGxZa1dxeXpwLzEzMGRlWlczbWcxL3NRRkRyU0NFRGNlWEUx?=
 =?utf-8?B?Q252Wm9WRnQxaUJCVHdYaUd2V1pibTNCM3M0aDNkRFREdExCYmdrR05KMjRr?=
 =?utf-8?B?ODd1ZEJQa1NLMWUvM0JxYk1mRXM5ajgwYlg3K21QUHJYWHJEL3BaT2FURGl2?=
 =?utf-8?B?K2JBNUdyYXBVT3VPTEJtdDFoVFdwYkc5cW5VMHZ0bXpnLzg5d0VRNXJudUNj?=
 =?utf-8?B?WGs4Slo4TkVnYnprTndUNktmREFzKzVsNjFzN2MyTnFhdXNFV3FsNTF6OTcx?=
 =?utf-8?B?SmF5cC9TcHIxODJDckg3SSsyWHNhejQ2ZjIrbG44YnZZNEg4M0tBd3JkdEdE?=
 =?utf-8?B?eGpRZzlsUm4xSWNvMEhqbmJ4NDRYdlEvdG40am5JaVpjUm5nb2hjR0lBV3Ez?=
 =?utf-8?B?RkNaOGhpaXRrRlkvSjBWenlucElLclk5NTVqYWdkS3FyUnFhQnF6MU15QzdB?=
 =?utf-8?B?ZlhsVDlqeENJdU5iUERiYVRYU3daNXdqZmc4TUxwYXBSWDJXYTlhMHFEWEdL?=
 =?utf-8?Q?RHeUyZzM6jY32DEI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E809865CA7A8547B2C77EFE60AA8951@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e954ecb-e9a2-4cc6-5c37-08de4f478334
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 06:22:49.5248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4lnNks7huGKo5zW2tFGoFe0YeFBlL/RAxQiIJeCCwQar5qJu6tiHQMz+yudJ6obySS8UF/hw727qhPyJ2piPaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7453
X-MTK: N

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDEzOjI1ICswMTAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiANCj4gUGxlYXNlIHByb3ZpZGUgaGVyZSByZWFzb24sIGUuZy4gdW5kb2N1bWVudGVk
IEFCSS4gTm9ybWFsbHkgSSB3b3VsZA0KPiBhc2sNCj4gYWJvdXQgQUJJIGltcGFjdCwgYnV0IGNv
bnNpZGVyaW5nIHRoaXMgaXMgd2FzIGp1c3QgY29waWVkIGZyb20gc29tZQ0KPiBkb3duc3RyZWFt
IGNvZGUgSSB3b3VsZCBqdXN0IG5vdCBjYXJlLg0KPiANCg0KSXMgaXQgc3VmZmljaWVudCBmb3Ig
dXMgdG8gc3VwcGxlbWVudCB0aGUgQUJJIGRvY3VtZW50Pw0KVGhpcyBBQkkgbWlnaHQgYWZmZWN0
IHRoZSBhYmlsaXR5IHRvIHJlc2V0IGFuZCByZWNvdmVyIGFmdGVyIA0KYW4gVUZTIGVycm9yIGlu
IHVwc3RyZWFtIHdvcmxkLg0KDQo+IE1lZGlhdGVrIHNob3VsZCByZWFsbHkgc3RvcCBhbmQgcmV0
aGluayB0aGVpciB1cHN0cmVhbSBwcm9jZXNzLg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5
c3p0b2YNCg0KWWVzLCB5b3UgYXJlIHJpZ2h0Lg0KTWVkaWFUZWsgZG9lcyBoYXZlIHNvbWUgc2hv
cnRjb21pbmdzIGluIHRoZSB1cHN0cmVhbSBwcm9jZXNzLg0KV2Ugd2lsbCBtYWtlIGltcHJvdmVt
ZW50cy4NCg0KVGhhbmtzLg0KUGV0ZXINCg==
