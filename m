Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC3472614;
	Tue,  4 Nov 2025 05:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762235006; cv=fail; b=c1hRwWWX/h0nsfueoS1lTfytcIZ0dCwas2dwCnkA3AkYUq+P1Cyh7lG1wwzJNPREbi+ynmpo/jSgtoEBgWIiWuPB0SSDyOkF6MrI4H0mPx7k+xbDu93FBPCeC/VJIseVejed8meN4abEVOxf8M0D99t7bYlY+6XkOOL9QXsIdSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762235006; c=relaxed/simple;
	bh=yFWpGc6PmwrBGQF9WKOHsKnLg9CqoNdkRGL+Z3ei91A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OdQJtoQH09yOx8IPq9DXrY7tqnaGbuKKHd57/0Ye9uT9uEjfBfyRmT9FBVWpIDdoTGoaAC7urKY+fEep+zvOz1iCilPeg0HoBzZJ/w2CfJBZ9zQMa7GhmeE4VwYmtYIU6AxhtgV4ouE9wKCKSNMSs1yhUsREQb/ug4OJCMGI1EE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qyKujJJS; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ij5iem2I; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qyKujJJS";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ij5iem2I"
X-UUID: 2b60d25ab94111f08ac0a938fc7cd336-20251104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=yFWpGc6PmwrBGQF9WKOHsKnLg9CqoNdkRGL+Z3ei91A=;
	b=qyKujJJS5cbbW/voizmoftmwpMRAJC3n50xn/9BYovZczT4MNyvjpcsu2pZuzKH23IJpZNcVoL31p+YJw9rVAbLaJNuTM0s5F8yfMt/rDEA5z1Xnzo/SEtCXDf++QJWon7cgVjalqV1KdM2aentVp1tEwIl4Jrw45hqXhIGMAIs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:0f72c966-1566-4f81-a4b4-e3637b08e72d,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:9c35e418-3399-4579-97ab-008f994989ea,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2b60d25ab94111f08ac0a938fc7cd336-20251104
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 790410847; Tue, 04 Nov 2025 13:43:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 4 Nov 2025 13:43:18 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 4 Nov 2025 13:43:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c20GhKMzF+Ft74VaSbWFdFjwYzvSP6rhVY9gh7/sqkb44ZS1xXMF1u8monzbTSdFdcBGEoQkWR+7Sxlhs0Ju/OXSxABlg7mUD3wSVmAqD40uTD9rdJJZpHni+JQFfrtQJPZzUAD7SLE972L8i+66cqupZrA9eZbJzlt1XRJ1T9sVCe0mkyDUL3R4kNZNx6UNzgyxV3pBcyZfVR6sKGuERjeeUAo3ZxgDL3Jjaw011rBSvF88IryRWjdy5YLOjFdVgYhHoVI9kRoDD5wyqZ7YtJ4UWaXKjX1ON25YjkrmeucBUg5JQRwCmWv/WQB9ZobhnKL7y+tgC9GaUpJZjneuNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFWpGc6PmwrBGQF9WKOHsKnLg9CqoNdkRGL+Z3ei91A=;
 b=IERmtvqtGZ9Y/2KY4G64pd0pw+ILjvZdWkgeWya8PvSaiCqJ+kcC2CVRmsQZ6BwkApGeU82oBFvRfmRBqjX2tzoR6mvpCWBdLFts3E7yrDfUFjz3QngUjL+m4mPX5MD4+3bzAlVvxXGPPfa2qYAazSOtGknQ1XyroI6nKTW2exBzS4sJxZ1pQAUMhZRUFofEUZ6qUxDkMGaYKmUDjVvC8YwX9bLqPHHBchV7JGIkG+PsbDwXMJEkfgEqfkML58UhafKfroeDnL1MNUksZrVUo+1GNNF1L3oJO02x4FeZrTPtVfyhUqmR3yCDk9I7yQojzORMmbk4hseG3L/WTrSRzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFWpGc6PmwrBGQF9WKOHsKnLg9CqoNdkRGL+Z3ei91A=;
 b=ij5iem2Il7I4kBSbx11bhXY/cNsM/W1kER/TAlA+bN65lPTeTCheAg98fCuPdbuQotpkbUB+J/JLiniE7nAVMcZzbu1/+P5uNdkYf1g8yx76Ytf/GdsKF4fkl1731Ubi5nhYZt5THLQS/VTHzIQc3hO5bHQk/zuqf1utcME15u8=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by KL1PR03MB7223.apcprd03.prod.outlook.com (2603:1096:820:d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Tue, 4 Nov
 2025 05:43:15 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7%7]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 05:43:15 +0000
From: =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	=?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"kishon@kernel.org" <kishon@kernel.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "robh@kernel.org" <robh@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"kernel@collabora.com" <kernel@collabora.com>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>
Subject: Re: [PATCH v3 02/24] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Thread-Topic: [PATCH v3 02/24] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Thread-Index: AQHcTTov5FH3aKEmO0K+Nb2511pYNLTiAV4A
Date: Tue, 4 Nov 2025 05:43:15 +0000
Message-ID: <aecc0545e85bd972e27b3104ac05fe4a7b1f3069.camel@mediatek.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
	 <20251023-mt8196-ufs-v3-2-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-2-0f04b4a795ff@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|KL1PR03MB7223:EE_
x-ms-office365-filtering-correlation-id: d058c33c-4138-4dfb-062e-08de1b650ced
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?SlY5M1VGSUtTdlkxUHNsTWVqMHFBYUFhYWU3cG40YmhZMndjUFVBUUFEVTF6?=
 =?utf-8?B?L1dSZzVRS1Y2YllEVGgva3YxQUtTMVlxZUhsOUswdEZtWG43ODhXQVJxNnFt?=
 =?utf-8?B?cFpyc0xaYmxmc1YrMjg4UENMOEVQaVphSDNTRUc5SUU5Y0lONHBhYVkyVW9V?=
 =?utf-8?B?RTdOR1FnSEZMMEFvUVJpRXR3dWxML0VlalBBOEllVVRDTGI4eTk3bnZVakF1?=
 =?utf-8?B?SVoxVWQwNTlIbThUbFQwaUVIaUlwU1k1Sk85a1plZ2pPRmNPRHF1bStmRmJm?=
 =?utf-8?B?Z0l0ZlNEVHhtV1Z6T0ozaS9VZnQvenB5Q3RkVytGUUwvNlcraHdOR2c4c3M3?=
 =?utf-8?B?SnZtZmx1cFJISmlQZitpUC9iRjVxbWpEb3lRSWVwUExsdHhZMFNMZlZ5ZDJk?=
 =?utf-8?B?YkVSanFrZzRCQWV2amJGayt6Y2lqRmRDTi9hYWdobXZlcHdxYTY4RXoyU2gw?=
 =?utf-8?B?SlgwMTFGN0JXZlZMYTJ4aXhraDUzNUx4RFNuUmg3VVg4T0I4cjA5VUQ4WFYz?=
 =?utf-8?B?ajhpWHlMMVdkeFcxVUZuTlBWN01KV09YcFBJY3Ezb095QnFUZGYxRkRtalJi?=
 =?utf-8?B?M0cxSEtZUHdVckhlbDJJY3dzN1o2MGV3Y3lwVndDMlJDV09DRVUwc0xtQS9s?=
 =?utf-8?B?REpVM3ErQkpuQVUwWUVEZ3ZEK01QSHlGc2M0NzNEcnFJWWtWS0MybE1JMEY4?=
 =?utf-8?B?aTA1T0d6ekJiSzMzRGF2Nnl1SHdHRnUzWWx2TGMxamw2aUhHVUs3MDBrTkxs?=
 =?utf-8?B?c2pWYklESEdmZHpQNHZFeGhwMTFhTUZVWHVPNVRCOGxlSlpwSEZIU1d3NlFD?=
 =?utf-8?B?eWJUZXF1WTlGVUY5VXdBSFdEMWFaU0ZpQlpiUWJjcHdENGpiTld1THhWNjd0?=
 =?utf-8?B?ZnRzN0kzMXFBdUE0NXFZVi80NWJMWmNoS05hdEUwUXBjdzF1c0NUZi9aQ2Jh?=
 =?utf-8?B?VWNuM3M1Z2FxOVg2Z2RaMHVRSnoxR2lTNS84cGJqTSsrWGdYYWkwZ2UyZ1dF?=
 =?utf-8?B?ZzRQb3l6N2FHQm4ycXFTcTZCTHd3VTVvTk5XdGFGelBMWHdrZytwSXlPVSta?=
 =?utf-8?B?bkJ0ZUN1azlkRW5Vb1BSR2NWTWJVRExCeTJiUnhiK0dnVzNxekNibjd3OXF3?=
 =?utf-8?B?dVFOY3EzalpmQTN4RTBCWXNVV2pCR3dmLy9WeGk3SStCYmFGSjQ1YWRaaHJ2?=
 =?utf-8?B?K1NpK1pDZnIvTTVwQ2dUcUtZLzhqTElGcFF4V3ZreGdaVXpZeG1CcE5saWZG?=
 =?utf-8?B?SlRBckUxNnRVWjdhZWgvQ3M3LzVndm9naWpXY0Eyblh2eVZIdEx3em9tSElO?=
 =?utf-8?B?bi9TOFFxRU5KTm9JMUFSWm9EdzlaRDI2R1hyN1crN2R0UlFLZDhUWGRhY1J3?=
 =?utf-8?B?TUNHcEVRWHdnT0l1bURBY3RMdWVRa21lL0JROC9IUVJIaFRzWTVDdmlSV3di?=
 =?utf-8?B?KzFiNUlJWTVnTHNrckwyL3pnRGdNZDN0eCt1TmEyeGdTSkliS01HZWJSVkJo?=
 =?utf-8?B?ays4ZFdRVEJnR2VSTUJnRGMwT0dTOFI4bTUzMFdNZ3FMakZ3dHBQQnpqd1Zo?=
 =?utf-8?B?bU8zNklBbE9sQ2VsTTA5bFNLQWZ3VU0vVS9EOHp3M3M0ZGFYaE5LQ2ZMdElK?=
 =?utf-8?B?dU1udVB6b2VtZWdLY0FBTUFXTFBQeXRDc21Fa0JjSGZjZ00xdS9IVnBtSzBO?=
 =?utf-8?B?dFRadWptSXovTktjLzRJL1loSjVMUDhTR3lWTWJwbmNwM1NZcVhzSlk3MVV1?=
 =?utf-8?B?UDhBeTUrYk9QRXc2Z3g1Q0N2bUl6cDhjUytlMmRTcmN4TlFZQ1FLQkI5U0U0?=
 =?utf-8?B?SFZUUTlyVnEzQWlKc3dFcFJyQ2lZcFQxVjRTMzFiOG55b0RVeHhFTzFUclJV?=
 =?utf-8?B?bm9HQzRod2Qyam02TDUvbGhwKzVLYXdmcnpCVjBLZDBOY0FYNmJlblBXcEkx?=
 =?utf-8?B?WWFud2N0TlRlT0JOblZiRUhLYzhwZE9iaG95WGpIckFWTEdFZGo2SWgwS3Fa?=
 =?utf-8?B?cVpUTGQ1ZlJIazNPUFdYcTBnU0xybElISlBweUpPeEx0T05tUTdXM08xeVpX?=
 =?utf-8?B?N09lbmVSQkp1cnpESi94MmgzT0ZRT0hHWHZUUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWJ6SHVONGZZVFVUQmM4SlF2V1NZenIyUGJxd09yZVVpRExvT2ZGZ2FIS3RL?=
 =?utf-8?B?WXdHdWY4Zm1LQ2RNYk5QV3NQOE5pRWVSaWpaaFl1UnVtWkN1YmVxNkxOeDhh?=
 =?utf-8?B?clFvN2FlbTQrS2NzM3l3NmNmWW1OZ3RKOFZqN2FnUzk3NjFoQnVsSTVaWS9W?=
 =?utf-8?B?cVBWUjFic2NLc2kxOHQxOXZLRlE4Z3RWQWJHNWtQODFWc3pQWnNRQVJaZmlN?=
 =?utf-8?B?RW9FYWtTakRRTjBUTTlIZDFROWJqNk4zeVRCWm4vNmMvM2p0ZFV5YmhmVFZs?=
 =?utf-8?B?alFrbGczWVd2d2VDWG9TbjNsOW5zZWVoSG8zSWRLVWJ4SFBrNmd5ZXZCKytm?=
 =?utf-8?B?MG4zMnpiNzVjcGVHTlZoN0dZQXZGOGF5UHJCWWsrcXBMRGVuUW40Wlpodlp4?=
 =?utf-8?B?SVBob2Uwd2pEMEZ0d1Bsa1RXT1RURnkzZHhsdi9wQi9rS09IVVNSclNvME1v?=
 =?utf-8?B?Z1I4Rms2SFlqK3c0ZlJiTmdQSU1qcHJPcXVPbmVPUmtRM0greXdyUUQ0Vlc1?=
 =?utf-8?B?cHFtaTdLYVVpODZTMFIvZEllRWVUR1orcXZGc1VzbnpuaVF3MWxxNTRobHZm?=
 =?utf-8?B?Sk1yMlNWT2ZPeTFDZDNaSTRvVlZIaVVSYlo2RVBWMGluRVV3UFNoZm04T3g1?=
 =?utf-8?B?NUdhZU14YW9NMWZSeVFld0kwVGJMK1hFZWwvZHNuc2Q5RUVxQk5Vbk5taVls?=
 =?utf-8?B?eGNmQlpVeTdkQS9vWU9IQXphWFhXRjNhdTB4Qndja2xKUE9CcWtFYUJGTDRV?=
 =?utf-8?B?d1VVdWtxdEFyZG1qbm9nbnhZcFRzM2cyNzVWN0prQjJha29WU09YSkFNMHlt?=
 =?utf-8?B?T2ZoQUFCSldUZ29jZEd4U0o1emF1S05uSDYwT3lBRGdlMFVCT25lOW5zVm4w?=
 =?utf-8?B?SnlOaSsveVRNQmN4WGVrNEdqRDZGdldPMTVlcXEzK1M1eU8weE04ZlFoMC90?=
 =?utf-8?B?em0wNmRqRlVNcGtSQWVWdmJQclNoMi9XM0U4a0QwYzZsMk1LK0x0T1ZwZG9x?=
 =?utf-8?B?SHJiV3lObzA0ZFRKVWRtbGxIbkx0OVFHeXNUR0poaWQrNTVobyszeHRrUk41?=
 =?utf-8?B?Z3dZNFRJTUJ0K0tqUDZFVFluVVBlTVI4cWcrRnJFZzhCYWF6Zlc2d1hUcFV4?=
 =?utf-8?B?a3liVU9tN1FTazRheW9uaWIram1hdHV2cnBZSnZQaGptTWNIaGU3VURGakVp?=
 =?utf-8?B?UDJpMUVBSGVHanRKdWNFdS9JUFhPT3l4S05PbkdPMUdLR1NVUXZFRUxERUQx?=
 =?utf-8?B?RFlYRCtIVkdDd1NjMHUwSzUvemdxMGpISmdGMlpzdCtxMVpDNDNndUtETXE5?=
 =?utf-8?B?UVc1UWxFTUdIRmRyeEdUMmhKVG9obnl5dFI2Nk1KdFd1a3QycENIR3FBNzNk?=
 =?utf-8?B?Smd0bjBTdTRkL2RSNENPbFhJMExtd3F4cDFiVUxTbjdSbUtNUFp3NlhUQjho?=
 =?utf-8?B?eWZ0RGpHWS9TVUh2cFVoNU90aVVJNEtyUkorR1RJYVNTcU9RUVpmNDduVjha?=
 =?utf-8?B?MWkySHVOYmZUY2tvdWFXNm1pVzY3aytkOUJETkdqTHVaMmlpdm1UMGRtSkVw?=
 =?utf-8?B?QlpBMWYyTWs5NHJmdDlxTlVyR1Zlc3dpV0N4eHMzejJpL3hOdE51OGZsdWJU?=
 =?utf-8?B?ZVgxNU42Q1lBQnlpV0d2bjVGYlFPdzYwWXR2bzljdzRHMXFWSkhxT3ZjK21Q?=
 =?utf-8?B?SVBRbllkRTlZcmhiZ1R4VWFhbm1sUW9wMWlIK2YyR0FaM2t1dnFWQ1A4NDBo?=
 =?utf-8?B?MXBvM2JYYW03Yll0NUQyUHQ2eFplTHp4U2N3TDJqZG8veHQwdllZM2FsekR5?=
 =?utf-8?B?WHJVSVk3dEJiSHBOVHk2ZUNnK1VVRTV4ZWFzK0NPazZ0b0dlTnVQWG9PWUpB?=
 =?utf-8?B?RE5xVjVTY2JBTlJETk9uazNYMm1OblJiU2prOXhQdzVjQ2ZRQTBTY3hFVVB5?=
 =?utf-8?B?TUVlUHI1dk53OHh0TVp1VXJPc3VoazdEejlNdVNtOWVOMDFRV2R2Um5iUmNW?=
 =?utf-8?B?YnRvQk05RG9LQ3ZGMEZ5L1VqeXFJMVNmbUZsdmR6OEVTL285ak0vZGtJQkdk?=
 =?utf-8?B?SFlsb3J0Yi9vUjBSREJwSGRjdzFSWU80Y0MwL0JSVWVHV0N6QitUcHd6ZUVy?=
 =?utf-8?B?ZVlOTlZUeFlvdExBcnF2c2JqTy9oUDVNZk1UQlBjL29PVVk4SFNZeFo0aG9a?=
 =?utf-8?B?K3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B19C7574EB8DDA489B74CC34C6EE564E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d058c33c-4138-4dfb-062e-08de1b650ced
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 05:43:15.5664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xPysWhkwFaML7cKEbmPj4LV48HZs2jO8FP7h4Ym972fgk4AjsNADBKQPWLp9ksVCb1afbJtZx27XePryW3vU0KKFNEyTj1Hpi+/D7fyAPvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7223

T24gVGh1LCAyMDI1LTEwLTIzIGF0IDIxOjQ5ICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEFzIGl0IHN0YW5kcywgdGhlIG1lZGlhdGVrLHVmcy55YW1sIGJpbmRpbmcgaXMgc3Rh
cnRsaW5nbHkNCj4gaW5jb21wbGV0ZS4NCj4gSXRzIG9uZSBleGFtcGxlLCB3aGljaCBpcyB0aGUg
b25seSByZWFsICJ1c2VyIiBvZiB0aGlzIGJpbmRpbmcgaW4NCj4gbWFpbmxpbmUsIHVzZXMgdGhl
IGRlcHJlY2F0ZWQgZnJlcS10YWJsZS1oeiBwcm9wZXJ0eS4NCj4gDQo+IFRoZSByZXNldHMsIG9m
IHdoaWNoIHRoZXJlIGFyZSB0aHJlZSBvcHRpb25hbCBvbmVzLCBhcmUgY29tcGxldGVseQ0KPiBh
YnNlbnQuDQo+IA0KPiBUaGUgY2xvY2sgZGVzY3JpcHRpb24gZm9yIE1UODE5NSBpcyBpbmNvbXBs
ZXRlLCBhcyBpcyB0aGUgb25lIGZvcg0KPiBNVDgxOTIuIEl0J3Mgbm90IGtub3duIGlmIHRoZSBv
bmUgY2xvY2sgYmluZGluZyBmb3IgTVQ4MTgzIGlzIGV2ZW4NCj4gY29ycmVjdCwgYnV0IEkgZG8g
bm90IGhhdmUgYWNjZXNzIHRvIHRoZSBuZWNlc3NhcnkgY29kZSBhbmQNCj4gZG9jdW1lbnRhdGlv
biB0byBmaW5kIHRoaXMgb3V0IG15c2VsZi4NCj4gDQo+IFRoZSBwb3dlciBzdXBwbHkgc2l0dWF0
aW9uIGlzIG5vdCBtdWNoIGJldHRlcjsgdGhlIGJpbmRpbmcgZGVzY3JpYmVzDQo+IG9uZQ0KPiBy
ZXF1aXJlZCBwb3dlciBzdXBwbHksIGJ1dCB1c2VzIGEgc3VwcGx5IHByb3BlcnR5IGZyb20gdWZz
LQ0KPiBjb21tb24ueWFtbA0KPiB0aGF0IGNhbiBiZSBlaXRoZXIgMS44ViBvciAzLjNWLg0KPiAN
Cj4gTm8gc2Vjb25kIGV4YW1wbGUgaXMgcHJlc2VudCBpbiB0aGUgYmluZGluZywgbWFraW5nIHZl
cmlmaWNhdGlvbg0KPiBkaWZmaWN1bHQuDQo+IA0KPiBEaXNhbGxvdyBmcmVxLXRhYmxlLWh6IGFu
ZCBtb3ZlIHRvIG9wZXJhdGluZy1wb2ludHMtdjIuIEl0J3MgZmluZSB0bw0KPiBicmVhayBjb21w
YXRpYmlsaXR5IGhlcmUsIGFzIHRoZSBiaW5kaW5nIGlzIGN1cnJlbnRseSB1bnVzZWQgYW5kDQo+
IHdvdWxkDQo+IGJlIGltcG9zc2libGUgdG8gY29ycmVjdGx5IHVzZSBpbiBpdHMgY3VycmVudCBz
dGF0ZS4NCj4gDQo+IEFkZCB0aGUgdGhyZWUgcmVzZXRzIGFuZCB0aGUgY29ycmVzcG9uZGluZyBy
ZXNldC1uYW1lcyBwcm9wZXJ0eS4NCj4gVGhlc2UNCj4gcmVzZXRzIGFwcGVhciB0byBiZSBvcHRp
b25hbCwgaS5lLiBub3QgcmVxdWlyZWQgZm9yIHRoZSBmdW5jdGlvbmluZw0KPiBvZg0KPiB0aGUg
ZGV2aWNlLg0KPiANCj4gTW92ZSB0aGUgbGlzdCBvZiBjbG9jayBuYW1lcyBvdXQgb2YgdGhlIGlm
IGNvbmRpdGlvbiwgYW5kIGV4cGFuZCBpdA0KPiBmb3INCj4gdGhlIGNvbmZpcm1lZCBjbG9ja3Mg
SSBjb3VsZCBmaW5kIGJ5IGNyb3NzLXJlZmVyZW5jaW5nIHNldmVyYWwgY2xvY2sNCj4gZHJpdmVy
cy4gRm9yIE1UODE5NSwgaW5jcmVhc2UgdGhlIG1pbmltdW0gbnVtYmVyIG9mIGNsb2NrcyB0byBp
bmNsdWRlDQo+IHRoZSBjcnlwdCBhbmQgcnhfc3ltYm9sIG9uZXMsIGFzIHRoZXkncmUgaW50ZXJu
YWwgdG8gdGhlIFNvQyBhbmQNCj4gc2hvdWxkDQo+IGFsd2F5cyBiZSBwcmVzZW50LCBhbmQgc2hv
dWxkIHRoZXJlZm9yZSBub3QgYmUgb21pdHRlZC4NCj4gDQo+IE1UODE5MiBnZXRzIHRvIGhhdmUg
YXQgbGVhc3QgMyBjbG9ja3MsIGFzIHRoZXNlIHdlcmUgdGhlIG9uZXMgSSBjb3VsZA0KPiBxdWlj
a2x5IGNvbmZpcm0gZnJvbSBhIGdsYW5jZSBhdCB2YXJpb3VzIHRyZWVzLiBJIGNhbid0IHNheSB0
aGlzIHdhcw0KPiBhbg0KPiBleGhhdXN0aXZlIHNlYXJjaCB0aG91Z2gsIGJ1dCBpdCdzIGJldHRl
ciB0aGFuIHRoZSBjdXJyZW50IHNpdHVhdGlvbi4NCj4gDQo+IFByb3Blcmx5IGRvY3VtZW50IGFs
bCBzdXBwbGllcywgd2l0aCB3aGljaCBwaW4gbmFtZSBvbiB0aGUgU29DcyB0aGV5DQo+IHN1cHBs
eSwgYW5kIHdoYXQgdm9sdGFnZSB3ZSB1bmRlcnN0YW5kIHRoZW0gYXMuIE1hbmRhdGUgdmNjLXN1
cHBseS0NCj4gMXA4LA0KPiBhcyB2Y2Mtc3VwcGx5IGFwcGVhcnMgdG8gYWx3YXlzIGJlIGRlc2Ny
aWJpbmcgYSAxLjhWIHN1cHBseS4gVGhlDQo+IHVmcy1jb21tb24ueWFtbCB2Y2NxL3ZjY3EyIHN1
cHBsaWVzIGFyZSB1c2VkIGZvciB0aGlzIHB1cnBvc2UsIHNvDQo+IHRoYXQNCj4gY29tbW9uIFVG
UyBpbXBsZW1lbnRhdGlvbnMgd2hpY2ggZG8gcG93ZXIgbWFuYWdlbWVudCBmb3IgdGhlc2UgZG9u
J3QNCj4gaGF2ZSB0byB0cmVhdCBNZWRpYVRlaydzIDEuMlYgc3VwcGxpZXMgaW4gYSBzcGVjaWFs
IHdheS4NCj4gDQo+IEFkZCB0aGUgbWlzc2luZyBhdmRkMDktc3VwcGx5LCB3aGljaCBzbyBmYXIg
b25seSBtdDgxODMgdXNlcy4NCj4gDQo+IEFsc28gYWRkIGEgTVQ4MTk1IGV4YW1wbGUgdG8gdGhl
IGJpbmRpbmcsIHVzaW5nIHN1cHBseSBsYWJlbHMgdGhhdCBJDQo+IGFtDQo+IHByZXR0eSBzdXJl
IHdvdWxkIGJlIHRoZSByaWdodCBvbmVzIGZvciBlLmcuIHRoZSBSYWR4YSBOSU8gMTJMLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogTmljb2xhcyBGcmF0dGFyb2xpIDxuaWNvbGFzLmZyYXR0YXJvbGlA
Y29sbGFib3JhLmNvbT4NCj4gLS0tDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy91ZnMvbWVk
aWF0ZWssdWZzLnlhbWwgICAgICB8IDExNQ0KPiArKysrKysrKysrKysrKysrKy0tLS0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCA5NyBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL21lZGlhdGVr
LHVmcy55YW1sDQo+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRp
YXRlayx1ZnMueWFtbA0KPiBpbmRleCAxZGVjNTRmYjAwZjMuLjM2NDY3MmJjNjViMSAxMDA2NDQN
Cj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1
ZnMueWFtbA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL21l
ZGlhdGVrLHVmcy55YW1sDQo+IEBAIC0xOCwxMSArMTgsMjggQEAgcHJvcGVydGllczoNCj4gIA0K
PiAgICBjbG9ja3M6DQo+ICAgICAgbWluSXRlbXM6IDENCj4gLSAgICBtYXhJdGVtczogOA0KPiAr
ICAgIG1heEl0ZW1zOiAxMw0KPiAgDQo+ICAgIGNsb2NrLW5hbWVzOg0KPiAgICAgIG1pbkl0ZW1z
OiAxDQo+IC0gICAgbWF4SXRlbXM6IDgNCj4gKyAgICBpdGVtczoNCj4gKyAgICAgIC0gY29uc3Q6
IHVmcw0KPiArICAgICAgLSBjb25zdDogdWZzX2Flcw0KPiArICAgICAgLSBjb25zdDogdWZzX3Rp
Y2sNCj4gKyAgICAgIC0gY29uc3Q6IHVuaXByb19zeXNjbGsNCj4gKyAgICAgIC0gY29uc3Q6IHVu
aXByb190aWNrDQo+ICsgICAgICAtIGNvbnN0OiB1bmlwcm9fbXBfYmNsaw0KPiArICAgICAgLSBj
b25zdDogdWZzX3R4X3N5bWJvbA0KPiArICAgICAgLSBjb25zdDogdWZzX21lbV9zdWINCj4gKyAg
ICAgIC0gY29uc3Q6IGNyeXB0X211eA0KPiArICAgICAgLSBjb25zdDogY3J5cHRfbHANCj4gKyAg
ICAgIC0gY29uc3Q6IGNyeXB0X3BlcmYNCj4gKyAgICAgIC0gY29uc3Q6IHVmc19yeF9zeW1ib2ww
DQo+ICsgICAgICAtIGNvbnN0OiB1ZnNfcnhfc3ltYm9sMQ0KPiArDQo+ICsgIG9wZXJhdGluZy1w
b2ludHMtdjI6IHRydWUNCj4gKw0KPiArICBmcmVxLXRhYmxlLWh6OiBmYWxzZQ0KPiAgDQo+ICAg
IHBoeXM6DQo+ICAgICAgbWF4SXRlbXM6IDENCj4gQEAgLTMwLDcgKzQ3LDMxIEBAIHByb3BlcnRp
ZXM6DQo+ICAgIHJlZzoNCj4gICAgICBtYXhJdGVtczogMQ0KPiAgDQo+IC0gIHZjYy1zdXBwbHk6
IHRydWUNCj4gKyAgcmVzZXRzOg0KPiArICAgIGl0ZW1zOg0KPiArICAgICAgLSBkZXNjcmlwdGlv
bjogcmVzZXQgZm9yIHRoZSBVbmlQcm8gbGF5ZXINCj4gKyAgICAgIC0gZGVzY3JpcHRpb246IHJl
c2V0IGZvciB0aGUgY3J5cHRvZ3JhcGh5IGVuZ2luZQ0KPiArICAgICAgLSBkZXNjcmlwdGlvbjog
cmVzZXQgZm9yIHRoZSBob3N0IGNvbnRyb2xsZXINCj4gKw0KPiArICByZXNldC1uYW1lczoNCj4g
KyAgICBpdGVtczoNCj4gKyAgICAgIC0gY29uc3Q6IHVuaXBybw0KPiArICAgICAgLSBjb25zdDog
Y3J5cHRvDQo+ICsgICAgICAtIGNvbnN0OiBoY2kNCj4gKw0KPiArICBhdmRkMDktc3VwcGx5Og0K
PiArICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAwLjlWIHN1cHBseSBwb3dlcmluZyB0
aGUgQVZERDA5X1VGUw0KPiBwaW4NCj4gKw0KPiArICB2Y2Mtc3VwcGx5Og0KPiArICAgIGRlc2Ny
aXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAxLjhWIHN1cHBseSBwb3dlcmluZyB0aGUgQVZERDE4X1VG
Uw0KPiBwaW4NCj4gKw0KPiArICB2Y2Mtc3VwcGx5LTFwODogdHJ1ZQ0KPiArDQo+ICsgIHZjY3Et
c3VwcGx5Og0KPiArICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSAxLjJWIHN1cHBseSBw
b3dlcmluZyB0aGUgQVZERDEyX1VGUw0KPiBwaW4NCj4gKw0KPiArICB2Y2NxMi1zdXBwbHk6DQo+
ICsgICAgZGVzY3JpcHRpb246IFBoYW5kbGUgdG8gdGhlIDEuMlYgc3VwcGx5IHBvd2VyaW5nIHRo
ZQ0KPiBBVkREMTJfQ0tCVUZfVUZTIHBpbg0KDQpUaGUgQVZERF94eHggTERPIGlzIHVzZWQgZm9y
IElDIGludGVybmFsbHksIGFuZCB0aGUgdmNjLXN1cHBseS92Y2NxLQ0Kc3VwcGx5L3ZjY3EyLXN1
cHBseSBhcmUgdXNlZCBmb3IgVUZTIGRldmljZSdzIHBvd2VyLiBzbyB0aGF0IGl0IGlzDQp3cm9u
ZyBzZXR0aW5nIHRoZSBBVkREX3h4eCB0byB0aGVzZSBzdXBwbGllcnMuDQphbmQsIHRoZSB2Y2Mg
aXMgMi41ViBvciAzLjNWLCBub3QgMS44Vi4NCj4gIA0KPiAgICBtZWRpYXRlayx1ZnMtZGlzYWJs
ZS1tY3E6DQo+ICAgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVmaW5pdGlvbnMvZmxh
Zw0KPiBAQCAtNDMsNiArODQsNyBAQCByZXF1aXJlZDoNCj4gICAgLSBwaHlzDQo+ICAgIC0gcmVn
DQo+ICAgIC0gdmNjLXN1cHBseQ0KPiArICAtIHZjYy1zdXBwbHktMXA4DQo+ICANCj4gIHVuZXZh
bHVhdGVkUHJvcGVydGllczogZmFsc2UNCj4gIA0KPiBAQCAtNTMsMjkgKzk1LDQxIEBAIGFsbE9m
Og0KPiAgICAgICAgcHJvcGVydGllczoNCj4gICAgICAgICAgY29tcGF0aWJsZToNCj4gICAgICAg
ICAgICBjb250YWluczoNCj4gLSAgICAgICAgICAgIGVudW06DQo+IC0gICAgICAgICAgICAgIC0g
bWVkaWF0ZWssbXQ4MTk1LXVmc2hjaQ0KPiArICAgICAgICAgICAgY29uc3Q6IG1lZGlhdGVrLG10
ODE4My11ZnNoY2kNCj4gICAgICB0aGVuOg0KPiAgICAgICAgcHJvcGVydGllczoNCj4gICAgICAg
ICAgY2xvY2tzOg0KPiAtICAgICAgICAgIG1pbkl0ZW1zOiA4DQo+ICsgICAgICAgICAgbWF4SXRl
bXM6IDENCj4gICAgICAgICAgY2xvY2stbmFtZXM6DQo+ICAgICAgICAgICAgaXRlbXM6DQo+ICAg
ICAgICAgICAgICAtIGNvbnN0OiB1ZnMNCj4gLSAgICAgICAgICAgIC0gY29uc3Q6IHVmc19hZXMN
Cj4gLSAgICAgICAgICAgIC0gY29uc3Q6IHVmc190aWNrDQo+IC0gICAgICAgICAgICAtIGNvbnN0
OiB1bmlwcm9fc3lzY2xrDQo+IC0gICAgICAgICAgICAtIGNvbnN0OiB1bmlwcm9fdGljaw0KPiAt
ICAgICAgICAgICAgLSBjb25zdDogdW5pcHJvX21wX2JjbGsNCj4gLSAgICAgICAgICAgIC0gY29u
c3Q6IHVmc190eF9zeW1ib2wNCj4gLSAgICAgICAgICAgIC0gY29uc3Q6IHVmc19tZW1fc3ViDQo+
IC0gICAgZWxzZToNCj4gKyAgICAgICAgdmNjcTItc3VwcGx5OiBmYWxzZQ0KPiArICAtIGlmOg0K
PiArICAgICAgcHJvcGVydGllczoNCj4gKyAgICAgICAgY29tcGF0aWJsZToNCj4gKyAgICAgICAg
ICBjb250YWluczoNCj4gKyAgICAgICAgICAgIGNvbnN0OiBtZWRpYXRlayxtdDgxOTItdWZzaGNp
DQo+ICsgICAgdGhlbjoNCj4gICAgICAgIHByb3BlcnRpZXM6DQo+ICAgICAgICAgIGNsb2NrczoN
Cj4gLSAgICAgICAgICBtYXhJdGVtczogMQ0KPiArICAgICAgICAgIG1pbkl0ZW1zOiAzDQo+ICsg
ICAgICAgICAgbWF4SXRlbXM6IDMNCj4gKyAgICAgICAgY2xvY2tzLW5hbWVzOg0KPiArICAgICAg
ICAgIG1pbkl0ZW1zOiAzDQo+ICsgICAgICAgICAgbWF4SXRlbXM6IDMNCj4gKyAgICAgICAgYXZk
ZDA5LXN1cHBseTogZmFsc2UNCj4gKyAgLSBpZjoNCj4gKyAgICAgIHByb3BlcnRpZXM6DQo+ICsg
ICAgICAgIGNvbXBhdGlibGU6DQo+ICsgICAgICAgICAgY29udGFpbnM6DQo+ICsgICAgICAgICAg
ICBjb25zdDogbWVkaWF0ZWssbXQ4MTk1LXVmc2hjaQ0KPiArICAgIHRoZW46DQo+ICsgICAgICBw
cm9wZXJ0aWVzOg0KPiArICAgICAgICBjbG9ja3M6DQo+ICsgICAgICAgICAgbWluSXRlbXM6IDEz
DQo+ICAgICAgICAgIGNsb2NrLW5hbWVzOg0KPiAtICAgICAgICAgIGl0ZW1zOg0KPiAtICAgICAg
ICAgICAgLSBjb25zdDogdWZzDQo+ICsgICAgICAgICAgbWluSXRlbXM6IDEzDQo+ICsgICAgICAg
IGF2ZGQwOS1zdXBwbHk6IGZhbHNlDQo+ICANCj4gIGV4YW1wbGVzOg0KPiAgICAtIHwNCj4gQEAg
LTk0LDggKzE0OCwzMyBAQCBleGFtcGxlczoNCj4gIA0KPiAgICAgICAgICAgICAgY2xvY2tzID0g
PCZpbmZyYWNmZ19hbyBDTEtfSU5GUkFfVUZTPjsNCj4gICAgICAgICAgICAgIGNsb2NrLW5hbWVz
ID0gInVmcyI7DQo+IC0gICAgICAgICAgICBmcmVxLXRhYmxlLWh6ID0gPDAgMD47DQo+ICANCj4g
ICAgICAgICAgICAgIHZjYy1zdXBwbHkgPSA8Jm10X3BtaWNfdmVtY19sZG9fcmVnPjsNCj4gKyAg
ICAgICAgICAgIHZjYy1zdXBwbHktMXA4Ow0KPiAgICAgICAgICB9Ow0KPiAgICAgIH07DQo+ICsg
IC0gfA0KPiArICAgIHVmc2hjaUAxMTI3MDAwMCB7DQo+ICsgICAgICAgIGNvbXBhdGlibGUgPSAi
bWVkaWF0ZWssbXQ4MTk1LXVmc2hjaSI7DQo+ICsgICAgICAgIHJlZyA9IDwweDExMjcwMDAwIDB4
MjMwMD47DQo+ICsgICAgICAgIGludGVycnVwdHMgPSA8R0lDX1NQSSAxMzcgSVJRX1RZUEVfTEVW
RUxfSElHSD47DQo+ICsgICAgICAgIHBoeXMgPSA8JnVmc3BoeT47DQo+ICsgICAgICAgIGNsb2Nr
cyA9IDwmaW5mcmFjZmdfYW8gNjM+LCA8JmluZnJhY2ZnX2FvIDY0PiwgPCZpbmZyYWNmZ19hbw0K
PiA2NT4sDQo+ICsgICAgICAgICAgICAgICAgIDwmaW5mcmFjZmdfYW8gNTQ+LCA8JmluZnJhY2Zn
X2FvIDU1PiwNCj4gKyAgICAgICAgICAgICAgICAgPCZpbmZyYWNmZ19hbyA1Nj4sIDwmaW5mcmFj
ZmdfYW8gOTA+LA0KPiArICAgICAgICAgICAgICAgICA8JmluZnJhY2ZnX2FvIDkzPiwgPCZ0b3Bj
a2dlbiA2MD4sIDwmdG9wY2tnZW4gMTUyPiwNCj4gKyAgICAgICAgICAgICAgICAgPCZ0b3Bja2dl
biAxMjU+LCA8JnRvcGNrZ2VuIDIxMj4sIDwmdG9wY2tnZW4gMjE1PjsNCj4gKyAgICAgICAgY2xv
Y2stbmFtZXMgPSAidWZzIiwgInVmc19hZXMiLCAidWZzX3RpY2siLA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICJ1bmlwcm9fc3lzY2xrIiwgInVuaXByb190aWNrIiwNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAidW5pcHJvX21wX2JjbGsiLCAidWZzX3R4X3N5bWJvbCIsDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgInVmc19tZW1fc3ViIiwgImNyeXB0X211eCIsICJjcnlwdF9scCIsDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgImNyeXB0X3BlcmYiLCAidWZzX3J4X3N5bWJvbDAiLA0K
PiAidWZzX3J4X3N5bWJvbDEiOw0KPiArDQo+ICsgICAgICAgIG9wZXJhdGluZy1wb2ludHMtdjIg
PSA8JnVmc19vcHBfdGFibGU+Ow0KPiArDQo+ICsgICAgICAgIHZjYy1zdXBwbHkgPSA8Jm10NjM1
OV92dWZzX2xkb19yZWc+Ow0KPiArICAgICAgICB2Y2Mtc3VwcGx5LTFwODsNCj4gKyAgICAgICAg
dmNjcS1zdXBwbHkgPSA8Jm10NjM1OV92cmYxMl9sZG9fcmVnPjsNCj4gKyAgICAgICAgdmNjcTIt
c3VwcGx5ID0gPCZtdDYzNTlfdmJiY2tfbGRvX3JlZz47DQo+ICsgICAgICAgIG1lZGlhdGVrLHVm
cy1kaXNhYmxlLW1jcTsNCj4gKyAgICB9Ow0KPiANCg==
