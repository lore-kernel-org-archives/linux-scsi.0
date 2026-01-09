Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE5228506B;
	Fri,  9 Jan 2026 06:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767939641; cv=fail; b=c2Ha6zF7YIiLFSZIfTQbVWh8mRCoaSKzQtA28nLSOCHaRR3dr7bejm3ujKC2dsw/CEJ538ZLVqfW/n6ZiR/tz7zVeZ+qdOkcGwtig/ggQ1sktMZwuDaS8Y+JCGzwBh9c5pdUWrWua1cmnNhuODTuR6HOEDAhWt1V2k6fRYUGGUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767939641; c=relaxed/simple;
	bh=xAvbG5Sv1pQwChtNej0HmgaYj+XhwqYulOLeVBAu+Ok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uNXcoTmdod2hcXBWvcDYzBAPsM5dWYWcvLHSZw7f87zbqUT42TDfH0bAQbPag6Tk6HRHChGjPd0dWe/EsuMCjM2MAm1G4SENYzgjq+uQ4rl4vhg9KWHlJ2drrbuOA6OAUEznQiV5p0o6xOX1XNEzTzkbNNdYv2Ccm8Y9YjzTAo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mLvFmMCQ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=lcWoLBsi; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mLvFmMCQ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="lcWoLBsi"
X-UUID: 4c99e0aeed2311f0bb3cf39eaa2364eb-20260109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=xAvbG5Sv1pQwChtNej0HmgaYj+XhwqYulOLeVBAu+Ok=;
	b=mLvFmMCQIVPDBASTLvcz/CPAf2NIa8Lwwf72zH5X0iOeNq2OIvVFK7riodJA4E8pZ0uT/M/ZiidTNStHEgsBO6HP8sYLhbHHtP9PA+QlTg4K0vjatyAWTsuwZENLLF1CrOI+GO9gyQghVzCwi063AnwTgZ+vx8tM4V1AUQtmrMs=;
X-CID-CACHE: Type:Local,Time:202601091420+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:5f597c3b-e2a2-41c2-9e7a-901dbc2361d0,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:d04b8f26-5093-468b-b7e7-d8195251fc6e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4c99e0aeed2311f0bb3cf39eaa2364eb-20260109
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1369695413; Fri, 09 Jan 2026 14:20:31 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 14:20:29 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 14:20:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VQi7mCG3BCOAVjhh5oJaXh9886WiV9ixcwHJEB3Emceodd0w4CHMFg4airKMmL27Er94rumQtC8rVlh++3eSrHiPwLeV8jdfVJBuEuqzxzDUa48oFvy8ZWkuQmxt7/9C99TZljuwJWL4/tmzhxZVOuR/62OTj5xlMeFIM1NFa//wevvHAd1P3+tMzSEWqDX2+PoynqTE4iJDfBm+IEiHfUjJ4yKrCAfz0FCAumSOJFW6WOzPSN9z9aDxPk8yzKdwUblAg0PPzmYrTUW+JcktML5/9gsGgJ40LgmwboXg7jfwi1AJUKN2EWBRHzLjw4qs4kbmrsX7nbhkXB0gklsJNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAvbG5Sv1pQwChtNej0HmgaYj+XhwqYulOLeVBAu+Ok=;
 b=mK8+uuJh8uZXtK5IYhN2FVaOf4OrhB5WvcbWmK1nOY/6BMVaOZXfZqekWiXXMDk47cvF15fD5GFJzOZ+4KK6d/OsKTqvjkT8P2pzyYPOif1FLARDMh0v9K5q2ETx5Z02dpTEgS3qAb9m2wJau2sMfi4KRatnP31bfe+0LCjfdNzMpgWbbAiLkiOAVvod4DBOBob/DRRYQgYzb2sReD1UjENdhE1Y2nwxUkzICxmqvYQGJNLoSIZ8Tqg0JKWu1pSBF9g57lW7uLyuu8oZvcwIMz6l5MH4eW/eH1Ujtr3upUzQM/O0fTxKJxY8P5zcqWBi2oPo5ZfMzgBZWUrzY7m24w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAvbG5Sv1pQwChtNej0HmgaYj+XhwqYulOLeVBAu+Ok=;
 b=lcWoLBsig/X/NNAGEMekkNklZ4Cj2GgelldeVRQyKOR7xN1R1DsZNZuJqVtVrkFwEvrHieVNVyxIhVCqtM+XceYvHB3+KjKp2qkVgrv3TCucgclXkDMo/N7/WJWN3WMjSF88eORJbPnPXPMClEFR2y+PDZo39bTYO1iJ1DKDtQE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7453.apcprd03.prod.outlook.com (2603:1096:820:e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 06:20:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 06:20:27 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "broonie@kernel.org" <broonie@kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v4 12/25] scsi: ufs: mediatek: Remove vendor kernel quirks
 cruft
Thread-Topic: [PATCH v4 12/25] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Thread-Index: AQHccB4E0xTGzVYV9kCvh5caMnfPWbVFP5SAgALiWQCAAV3tAA==
Date: Fri, 9 Jan 2026 06:20:27 +0000
Message-ID: <ebca21afb0a2c3aef82432446838c02127f44620.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-12-ddec7a369dd2@collabora.com>
	 <1bbc263bafe14343b2d60a230ae6ce5dadffbf7c.camel@mediatek.com>
	 <13960383.uLZWGnKmhe@workhorse>
In-Reply-To: <13960383.uLZWGnKmhe@workhorse>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7453:EE_
x-ms-office365-filtering-correlation-id: 1db5d015-ea49-48e3-2242-08de4f472e77
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?RHNWVjVzSzNSUnlEekdHK0pzb1l2VGlCQkdjRmY2NVM2TmVuMUJjS1JQK3Uw?=
 =?utf-8?B?TW9jajVFQWJuMFVlWnNJK1BLY0U4WXIxWDBETDc5aGxEK25SVTUxRDhsVVBT?=
 =?utf-8?B?U2ZROGdwckdIRGRGeEFKcGIwUTBnMFh2NXU0Wm1tQ1BJRmg0Y09tSEtPQ1d5?=
 =?utf-8?B?bXplTGRycXZYYis0Rko1cy9Ka3ZsR1dEWlhPTzREcStvT3BTOW56ZHQwVEM0?=
 =?utf-8?B?T20yVWFDNDlJZ0hIM0NXRXNhQTBXYkJiYS9EQVpBQ3NhYW1sakIwYkNsWmxZ?=
 =?utf-8?B?VENWSFE4MjcvVi9idWtRRjBpTkpyNlV6eXl6VDRzVU1qL3NUSTNPbDBBL1hE?=
 =?utf-8?B?clArcmkxZTVma1pRSjBmMWJQRFFCOVo0YzljR0J2VkxuZmZJenRHZWxIR3Ux?=
 =?utf-8?B?NW1hOVovakYwUTE2L2lRVFdpM2UwTU5BM1p3b2ZnVkRxbHB6d05LT2I0bGR5?=
 =?utf-8?B?clMxWGlKMVVtbHFYY2NhUm1IQ2k1Y0MvSXoyQ2pZU21CaTIxL2RRNUtEN1ZW?=
 =?utf-8?B?MTVmWmxHaW13RWxldE0wQlVoTzU2UlNzMm9FOHJwSXFRWU5kTmFBVjdxTi93?=
 =?utf-8?B?eGVTdnk4b3lOcGF0dS94UUlZTW94U1RxZS9mdUszTUJXdC8yc3BoeldzRTN1?=
 =?utf-8?B?NHNGOEdHQ0NKdnltanBVRk81Q3Z0MGN3VDJxaVY2OG9IelFpWWprRExtUHd5?=
 =?utf-8?B?cTlZMkFId0JlQ1lyNmdHRTU3TzFZL0RXaDY0MytMcTRxT3hqSno4aCt4TXNy?=
 =?utf-8?B?ZkpvZ3BJQTZ3SU9sMlhGWVFmOU9kTC9WbCtBM2lkb05pZDdrN0piVnhpVG1r?=
 =?utf-8?B?OEZDcVYrZGxxaUtNRmZ2TUlzWUhTR3lzVDdOMm5XdktMaFlhdE9KSzhRTGcy?=
 =?utf-8?B?bDNMNWtLU3BiZDlibEU3QUk5WUlSWVYzejVCZmVOdG1kUm9FbUJ0WGg1VnpH?=
 =?utf-8?B?YTFNSlE4SExzVWpuS3Bwc1Vzb1hhY0tlbFczcndmQ2JlZk95UXlDa09rM3c4?=
 =?utf-8?B?d0ovVExwRXk4SFQvOVorSjVOK2tBeUdZWGc1ckY1Zm9MbW1sNkM0cjVxV3o0?=
 =?utf-8?B?VVFqb1NpYm1walltVG85cEJoQWhJbzJpSjNyK3RLWno5S21qZmN1VEhhWWdt?=
 =?utf-8?B?RnBoYmU1dVlWSW8yWkx3MXpEK1UvQ2JURHNCMEJNaW1WcFArRTlQUlpMVWY2?=
 =?utf-8?B?dTJsVGkzMktvV2grOXRERWV3M1F4Z0J2VERXNkZuRXlOVy8wQmQ5R0pEanN5?=
 =?utf-8?B?RUtEOFJUMHBIUlVzdlR5WDhnU0RqOFY3WGtMdEFiamNvRExwZ0NEME1hWlRB?=
 =?utf-8?B?bHhRMEtmMlExSUN4QWdlaXp5dG15ZC9XYTlkOVpkY3ZKWlFLTEtIQlJUbTRk?=
 =?utf-8?B?TSt6d2tkd1ViRlpkTjhLQjFtb3Z0SWlHaFU4b2xPUThJUXdoK1F4cmkvNWM5?=
 =?utf-8?B?Q3c3UTVUUGVlZGFaZlVFK1BuM0RXYm9WSTRRRmFuUUVDYkJkUnBRV3JldEp6?=
 =?utf-8?B?d04yMzVJSFZxdFV3Um5tM2R3QllocDJubDlJVmRRNkp4TlR5ZFAwMnV3VURZ?=
 =?utf-8?B?YXlUTG5FeThFWkN6VDFPbFptWmVOcUYwNEl4Yi9tTmpWaVNoVmVJbS80OE4y?=
 =?utf-8?B?UGJuTDN6MThYU2ZKemlySjc4RlRCQlZ2VnVucmpTb3ZpVEpkb0tTdlorbW1L?=
 =?utf-8?B?RDBOZDdqcnBrUWlsZEI3VWJqUllvQ1dPZTVqYzlML2FqNnlTYmNnemE0amda?=
 =?utf-8?B?VDRrMm5MK3lLN2ZWenc0V1d5TEI4TWhaWEhpck9CWm1KTG54OUZGa1hqTEVk?=
 =?utf-8?B?SE96THVyVmhVejUzM2Q4QUE2dmtZUVBBbWZQVXY4Zlg3RkNuWCsybVgwVFB5?=
 =?utf-8?B?dlc2dmo3V3Z4d0RzQ0lIMzY5ci9ZcXJNcEwyS0RkN3dQTkpNa3FDRHNabmNi?=
 =?utf-8?B?VFFDVE5SNi9zSC9KNHdmcS9FRVJTQzFDRjNBeFRLaGx5M0VWL2JGb1l0UTlS?=
 =?utf-8?B?MVJrMUpCN3lGUGJjNHBoUmJwM2p2dFNmTmh6WkM1RFUzU1llekhwdlIwNnZS?=
 =?utf-8?B?cEs4QmRXbHB4dDdjWlNzYUZPV0hrZVNlbnQ0dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnZGU0Jqc09ZVHlSaXVhb3pWREpUQXREa3E1dmdIYnh5dlpQMTFwdWdhL095?=
 =?utf-8?B?YWduT3hJN1NPeW1rOFdNTjZqclB6MGpUem5zNFBkbEFmaWxkSXQrc09GNFRu?=
 =?utf-8?B?SVpKVlVaRDFZMjlDejVnbHVqemhNMkZza2hNVEZCTzVzTk5DbmY5WEF3UFhJ?=
 =?utf-8?B?NmpBV01JSVl1V2xjL043MmUvS2hvaTIvcGUwNWIzWC9hd1IzM055VjZJT3FZ?=
 =?utf-8?B?K29uN2tLampUT0lGQnMyVnR5aUhmSDNTdXZwUG1tL2RiN1g1WS9WOWZPWVRG?=
 =?utf-8?B?cmxLcFgrQVFLT1V2T0YweVQrOXJVb2paU1JiQjUreXVLQmxGMFpFemVaaC9r?=
 =?utf-8?B?eVZqK3dEMXJKQzBqM29KMnJWN1lnckVlWDh1M1JrckZQQzUrQ2czTHp6cXZK?=
 =?utf-8?B?ZnFSd1E0dHF0eFFINVFuVnlROGtKczhtVVhJUWxoWCtEbENnR0tjdHhzYXVm?=
 =?utf-8?B?MUlxeWlsT296SmJPZmJJUEs4Nk5wTkQ3d3Q3RlVlNk11V2pvQ1YrUHlibytp?=
 =?utf-8?B?TmQrL2dTTFlLM2R0Q3J5dVNjMlRNNkRSTVVBampCUzRhbFoyQVN1VVJFTTN6?=
 =?utf-8?B?R0FiZUlKNUdrNUhHTlBhZ0xMSGZuVUlXRjJEeVNrTnpEWC9QMnd2dFFmbmNZ?=
 =?utf-8?B?RmlibGl0bWhUeERCam52Z2w2S3JrUndta3E3a1c0dUtBcDNLRXl4WmxXQzZM?=
 =?utf-8?B?dkErRmVtdjQxTmhJMTl3dk41VFoybDJIRmhuMms3QVd4MHB4M0dxbzIxS09i?=
 =?utf-8?B?YTBSd2w3YnJKWHM4dVV4L2lTZzY3SGlLU0Z0ckM0OC9MczhnYm9Gc1hvTVV6?=
 =?utf-8?B?SkNPbUUxazlVZTV2V0V2dVM5dW5TaVBGTFA4WkNQTVVQZmtMRUtETnRCRWhU?=
 =?utf-8?B?VVNaUkhRL05wcitkSGMxclRnRTNVd0FPVzRLR3Y1ZnByR0tZUm00Z0dBa3Vw?=
 =?utf-8?B?NTh0UWsvaG9JZHgrRkZZUTZNalBHcDNpMzRBVkxTeEVITXJWSElqd1ppbzBM?=
 =?utf-8?B?cEVnK2RiRVNvcGpmdDRZanljdlNrcGEvSERmQlFNSTVBVFh0aXM4Ujg3YlZi?=
 =?utf-8?B?YUVtMzBScXlKOXJyT1ZBRXhBbXJyZGc5UENkNDljU2VnaWhzVXZrRjlVam90?=
 =?utf-8?B?S2dFZkNPVTBmTFFOam01V3YveGIyWUFRempSWVpDczZBSE9INmM3cjFxQ1Va?=
 =?utf-8?B?aVlDMkF1U2VFMS9wN3hHRHY2NDlQQmd6ZWQweWNkdE14M2QwZVVYQmZJTzc2?=
 =?utf-8?B?eGI3OEFOdWF1NGtUUlo3akpJS0VrWVE1NG1wSHZZemxJRVRtRjhKc1UvNFlH?=
 =?utf-8?B?VXVudDBwUUY0c3k3ZWFsS2ZzbjV6QnBmZEV1NE9ON2RITzd6L1RVQkJPT0lE?=
 =?utf-8?B?eHg3NU5kYjlCdjY5WDRaZmpLVklvR3dIbHNVU1JxRGY3UEtTNy9zRGYxR1R1?=
 =?utf-8?B?ZHk3RGJPTlZqamRlNDJYa2ZMeTAwRU4xeEIyaWR1UUgzSE9yaUE1aHFMaDJS?=
 =?utf-8?B?TW5rbkFhWTIwSWVSMWFDOURWSkxxdGNQSWJSR3lBV3Y5ejZEV1RjWGpwSzYz?=
 =?utf-8?B?MzRpUVR6RjNOQktoa2JQaXNXK3djR01FREZVSjkySmxFdnZVdmpMLzhvR0hP?=
 =?utf-8?B?Zk05Nm9Za2ZPNkI2akxva2JkSTBmVFRlL3N3VWVrMm1kdWxmLzN0OUx5MjY1?=
 =?utf-8?B?NzRWZ2krWUZQTGl2SmJ2OERQc0ZFUUNOUUZIK2s2UHljN1h1aHZoYTRGTmdW?=
 =?utf-8?B?cmFpc0twRjAveDA0NGZkRXQ3STVEc2R0eURORFdCQk1GeE1UU1JYcWVpV0lS?=
 =?utf-8?B?ckVBL3FhdVBESDNBQ1F3NGtzdXEvTXNhTWg4NDR2MCt0aklKMnlUWEFCbXY1?=
 =?utf-8?B?TTE0VmN3c2p6bjZtVlFabi9MTUY5U3dTSS9kazViVGRBQUdUWWg4cFl6NW5D?=
 =?utf-8?B?L0tZdHVGNVd5V0I4aHE1SDdpOUt2L3lZcnhrMWd0RllrQ2JKUWJPdkNtQlox?=
 =?utf-8?B?ajBZNDNCUEtFSmRoRmRnSGpWbXhOaHVQMHhFSEMxRE9BRldUaE1oTGRjMkRw?=
 =?utf-8?B?V0RJZDdJUWpzMk5GZXdNRTZldDRXQnNBUVExNmw2a3ozS0tHTFFzVWVIWUxM?=
 =?utf-8?B?c1RPbWV2TWJFK1lNUjhDUnhIU3VmZW5QNm1MM2NVS3BrZURNT1N2S2dOaENa?=
 =?utf-8?B?bUdzbG9hRFlzVFIxbzdYYUNvK3NHaVdaOUZGZm5EblN1QTNIK0tPL0U5SXRL?=
 =?utf-8?B?Z0hicjQzUFdrMFhjMG9Ba3M3c3p2TGt6emJoeTFhWFg1allhT0toVVJESlhO?=
 =?utf-8?B?Z0kxTmpBQ1ZOekNXK21nOVRJYXNJMDBhYnRqTER4dFpmaHU3WEM0MzFXT205?=
 =?utf-8?Q?TjhvKGoklIKRpqpM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AC52BD98A0CC44798C0FC74E64118FB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db5d015-ea49-48e3-2242-08de4f472e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 06:20:27.3110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iQ1Uw6YqwRXvPCGcpuCgZic2cUYgqm0VHP9myXoVB7InE6Ih+JLudW0X8ssjzp+vZseavNl1Q9jYPtllrSaEZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7453
X-MTK: N

T24gVGh1LCAyMDI2LTAxLTA4IGF0IDEwOjI4ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEJ5ICJvbmUgc29mdHdhcmUgc3VwcG9ydGluZyBtdWx0aXBsZSBoYXJkd2FyZSBjb25m
aWd1cmF0aW9ucyIsIGRvIHlvdQ0KPiBtZWFuIG9uZSBkZXZpY2UgdHJlZT8gQmVjYXVzZSBpZiBz
bywgSSBkb24ndCB0aGluayB0aGF0J3MgYSBnb29kDQo+IGlkZWEuDQoNClllcy4NCg0KPiBEZXZp
Y2UgdHJlZSBpcyBtZWFudCB0byBkZXNjcmliZSBub24tZW51bWVyYWJsZSBoYXJkd2FyZS4NCg0K
SSBhZ3JlZS4NCg0KPiANCj4gRXZlbiBpZiB5b3Ugd2FudCB0byBtYWtlIGl0IGVhc2llciBmb3Ig
eW91ciBjdXN0b21lcnMgdG8gc2hpcCBvbmUNCj4gaW1hZ2UNCj4gZm9yIHNldmVyYWwgU0tVcywg
dGhlcmUncyBiZXR0ZXIgd2F5cyB0byBkbyB0aGlzIHRoYW4gaGF2aW5nIGRyaXZlcnMNCj4gZml4
IHVwIGluZGl2aWR1YWwgRFQgbm9kZXMuIFRoZSBwbGF0Zm9ybSBmaXJtd2FyZSBsaWtlIHUtYm9v
dCBjYW4NCj4gY2hvb3NlDQo+IGEgRFQgYmFzZWQgb24gZGlmZmVyZW5jZXMgaXQgY2FuIHByb2Jl
LiBFLmcuIG9uIFJhZHhhIFJPQ0sgNUIvNUIrDQo+IGJvYXJkcywNCj4gd2UgaGF2ZSB1LWJvb3Qg
Y2hvb3NlIGJldHdlZW4gdGhlIDVCIGFuZCA1QisgRFQgYmFzZWQgb24gd2hldGhlcg0KPiBMUERE
UjUNCj4gaXMgcHJlc2VudCwgYXMgNUIgZG9lcyBub3QgaGF2ZSBMUEREUjUsIHNvIGFzIGxvbmcg
YXMgdS1ib290IGlzIHRvbGQNCj4gaXQncw0KPiBlaXRoZXIgYSBST0NLIDVCIG9yIFJPQ0sgNUIr
LCBpdCBjYW4gZmlndXJlIG91dCB3aGljaCBvbmUNCj4gc3BlY2lmaWNhbGx5IGJhc2VkDQo+IG9u
IHRoYXQuIFNpbWlsYXJseSwgZm9yIHdoaWNoZXZlciBib2FyZHMgdGhpcyBpcyBmb3IsIHRoZXJl
IG1heSBiZQ0KPiBkaWZmZXJlbmNlcyB0aGF0IGNhbiBiZSBwcm9iZWQgdG8gZGlzYW1iaWd1YXRl
IGJldHdlZW4gc2V2ZXJhbCBTS1VzDQo+IG9mIHRoZQ0KPiBib2FyZCBhcyBsb25nIGFzIGl0J3Mg
a25vd24gaXQgbXVzdCBiZSBhdCBsZWFzdCBvbmUgb2YgdGhvc2UgU0tVcy4NCg0KDQoNCldlIHdp
bGwgYWRvcHQgdGhpcyBhcHByb2FjaC4gVGhhbmsgeW91IGZvciB5b3VyIHN1Z2dlc3Rpb24uDQoN
Cg==
