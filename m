Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B752136653;
	Thu, 27 Jun 2024 11:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719486008; cv=fail; b=AuKidJdocjju1wOA4TmISuySYSsIsMFNiRX0bGOjyXanB7lpCM+TJkjCaeHLMoIU7RULHkruCjkgj/GKR0S24C4Mjv0YZ1ZqF5DfcuhPC/qAKPuoMl3cVdpqdQgxpfc32kpclVrzDlTr53wyl22jUSU+3xE6+TrSsRXc5+AF2Fs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719486008; c=relaxed/simple;
	bh=eyrxOSIzjlC7ZFtt+UxMrnFXmiUXTZd+eXV3zIHeVOw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ij4Lz/7juSW1GhSaJbAjACQBuulhGFij2dILMoJB+fKA5dYb3f/sOV6BkVRKF5hAZFXnssj5QF2Um8lzeT6s1fJ3/R/A5M3GTM7DWS2XW+ZYHXIyZCWiDRmNF4dv2Kbz1H3Im7m35Jp6+TXHTg7a1ON4GlF4H0p3L8zb7Pp38W8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=K6ZbRpDu; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=nC8OIWZB; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="K6ZbRpDu";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="nC8OIWZB"
X-UUID: 64cc873a347411ef8da6557f11777fc4-20240627
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=eyrxOSIzjlC7ZFtt+UxMrnFXmiUXTZd+eXV3zIHeVOw=;
	b=K6ZbRpDuCW5Q0uYG0+PdKeHYGq4vIRh/h9vAmbDPCv1GoGtmaqUZGU9LJPNT/DBzPCh7TebK1ITRwFNeZlOO4KPvOnXL5opUw+HdmIiSx4fJEgaRh3GAj+Wta4MTyPgHun009D5vYO97mp8egmsX17/uIshIdOyHAF+O+Sz+qXI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:72d469c7-1523-42df-a3b2-3d57544a69e3,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:6b39a144-a117-4f46-a956-71ffeac67bfa,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 64cc873a347411ef8da6557f11777fc4-20240627
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1967666445; Thu, 27 Jun 2024 18:59:58 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Jun 2024 18:59:56 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 27 Jun 2024 18:59:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTnRF/afKv7HOno7rdXAqlEbfVWoHCSwGStbhh+qZ5i0GGduJetD8jgQTi7zLWjbcYFESVVnhEAgzmSzKsZzD7DQeA/kqtsnWSfJkgrbmPIZ2nhJTSVJZP+M/rn3Xk8tHF000sDNFPKxhYYSUeFfsiQOzDF06O4lA5Xbr+H61mBJKJI38+jglENNQj/gULQ0JAZbWzYGJKahLvhkXW+nQWxsWZovgxgakJxVFCt//3VQIkDMofAr47tdrBXVHnuIx472u31HDofd9++ouAF/sZo/f6DlPU2oO7czCkk58YbA5W828mMYDUMP0HzvwW3cgTyy1RTUjB4l0LYZGs0zHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyrxOSIzjlC7ZFtt+UxMrnFXmiUXTZd+eXV3zIHeVOw=;
 b=ThbJ7udAbVuzJhz5dpn+/V0Fo7rNScvclERBeg3twO3bO6t/bKPpXT1YhEmWXPe2kHzJ33//bs/b51ciSpQ2vADAKlxfP6YR/vumBuv5Wta5ShU7nrHgsxmznYNWQbJ909sW5LTzLXe9UfTzfiQiF+QXVow62/S47J5X3tkzK3FAof4o+5bL8vGOgM5QhRcnznojd0dsNPexxN2xrdM1r+mNbniyqUD2iNm/paD7HR18zqKevbpar2AEcHra12omaDANMJ48ToKWiWqwaxOs/qkheFPsufOVyYL1shZYbdM4SUFapbk4a5zpQDAo0Wg6lkbzS2IjCVMlaInGlzXPPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyrxOSIzjlC7ZFtt+UxMrnFXmiUXTZd+eXV3zIHeVOw=;
 b=nC8OIWZB3IaMO/acwRmPH9BcR3t0wdBUAX+l455nFmAAEnEYMAFvvPEnA1sFNB0kRczSlutf39l+hRMdtQYAf7sqxnVBBkpMoGNgqJkqryTtZss9THd1LzfXvZws0jUvaPtfmMDxDOqzbscn+nEFMiB9wbquwgQ8mu6Sp1i4mBA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8634.apcprd03.prod.outlook.com (2603:1096:101:228::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 10:59:55 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 10:59:55 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "haowenchao22@gmail.com"
	<haowenchao22@gmail.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
Thread-Topic: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
Thread-Index: AQHaxi+9yVyGxDcFYkS8cVbs4SEa0bHXNMuAgADyXICAAInTgIAAvFQAgADexYCAAQ3ogIAAG+0A
Date: Thu, 27 Jun 2024 10:59:54 +0000
Message-ID: <9284fe608d6a2c35e1db50b0f7dc69d8951be5fe.camel@mediatek.com>
References: <20240624121158.21354-1-peter.wang@mediatek.com>
	 <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
	 <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
	 <795a89bb-12eb-4ac8-93df-6ec5173fb679@acm.org>
	 <0e1e0c0a4303f53a50a95aa0672311015ddeaee2.camel@mediatek.com>
	 <b5ee63bb-4db9-47fc-9b09-1fde0447f6f8@acm.org>
	 <54f5df88-ca0a-40dd-92ef-3f64c170ba55@gmail.com>
In-Reply-To: <54f5df88-ca0a-40dd-92ef-3f64c170ba55@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8634:EE_
x-ms-office365-filtering-correlation-id: e65ad91f-5cea-4b25-8fb0-08dc969846f9
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VXVtZG1weXMwT0lleUFGSlc4TktySkFBeEs1enc1RGpZVmpIcmZPcVFTL3lq?=
 =?utf-8?B?Qi91MGtGclZpQ2JJbms3R1dCMGk2Rnh2QjFwRWp4L1BVdmExd1o5Wm5WK1NU?=
 =?utf-8?B?QU9vOVJVWXJrYW5MaTR0cnMxcmRJREwwWDZsenJvUmRCNDJtRm95UHBOck9w?=
 =?utf-8?B?M05JcTZ0OEdwSkQxYjhRcUIzWTNvSnd5eG1DT3VrNCs0d0luSTYrK3pON3hB?=
 =?utf-8?B?RlUzNWIwbExtdC92RzBFMVlVdTRvQ0xCMWpzeWZkWnRqdWdGMFdiYU94cFpJ?=
 =?utf-8?B?K0ZCeVVVc3dwM2xRSTA2MkFYdzh1bEh6Y2gzczZHWTBBMlVLc3U3NVVGNm0r?=
 =?utf-8?B?ZWJwTVYvMjFYaVJRaVhQK0xQdTBJakdKdU0xQysrR1QzUFR4TGdnZXIyT0F1?=
 =?utf-8?B?cGtObmRMOFNNbmZpWXBNRWsvdEYzZStjclU3TWJYVDlvdElHZUdZRFBtNlhW?=
 =?utf-8?B?MDYyM3gxbC9QaGRyd2hESHlaU1FVdnpLSGN0TGNqTkFIWThXTFRKeDd1K2Rs?=
 =?utf-8?B?VTlaZVpTVnVhN2p4VGdVWG9WYnFzOXI4d2tkaC8rNlJTbHZCL0NEZ1ZNSFhE?=
 =?utf-8?B?Q3VrYUl3eW5zdnA2S3Y5MFRPcFdQbjcyQ2EyUHlhMzZvMDdsZE1EWlNTRDVU?=
 =?utf-8?B?UVRyTWd2NldPdUNiQmk2TDNXSjNUc0VTVE1oU1hqaTJ6cUVjdHk4eDhwdnNy?=
 =?utf-8?B?UDcycENCNHBoNnJxYnkyN1lUT1d3Yld0UnJXMm1TT05SZWNqRjZtQ0Z3MGNN?=
 =?utf-8?B?VlUrSGpFVEYreEthcXRySEVDS3NzNUQzUnRPaXJIZTlJMXFDWnVwVDNtTGJ4?=
 =?utf-8?B?Ly9HNUVuWmF1ZlNHVFdPZ090R2NhZWtqOGJjQUFiRjhnYm1KaDF6N1dWKy91?=
 =?utf-8?B?bHNkTVlGR3EyemUvRHdzYmE0TklRMm9vaEIwVXpFREhiS0d4SFJodnRBYkRB?=
 =?utf-8?B?bzhldzhRTC9oU2gzbEFDN2ZzRUw3NGJEclNiSUJXdVZHNW41bEpiQzBCUU5B?=
 =?utf-8?B?L3JBUHFtd1VVSnpvMWpiTzBvN2U4L1RYSlk3QTZnMXZxWWRxVFNFVThQZ2xo?=
 =?utf-8?B?eEJ2bFM2elAyRU1Qd2ZFNUwzSXRjTjIyZ2c0Q3YxemR3bHBuUUFUeDYvcDF2?=
 =?utf-8?B?YS8wTG11cmVZaFE0YTVnRnpaaXc2bDJoaWFQU0RzSW9DQ3RYMHNMN0wxRU1I?=
 =?utf-8?B?OUNvSkZqREdUM2ZQUnF0dHYzWnVwNFh1Rlc3R2RDQ093a2lPcS9weVFvRksw?=
 =?utf-8?B?VHc3bFp3WkVKenZDbWdTZmRSUDEzU2RUUVU1SHpxekdKNzJBY3IwdE1JSmUw?=
 =?utf-8?B?dXVSRDJKelNwSWVpK2FyTVVtejgxYXNmcnJZUnh1c2Y1VVYrc2tXbXoyenA0?=
 =?utf-8?B?V09KU2paeWpCZlVFUVZuMTlJZWNhNlJaRFZ2WmpYT1RsY1ZSWVFiOTR1eDJJ?=
 =?utf-8?B?STlxRHBITHQrOG1XWmJ0YWVlVHgyZ3ZETFpvYktrZ1Y4OW1yNTFWZk9FR2ti?=
 =?utf-8?B?SjQrQzdaWEpZaVlXZWsyVkk1V0tyMzJNem1VWnZkZHJrUE0rWVcrRnY5TzJt?=
 =?utf-8?B?UGNEK2p3OU04ajJlZGVrSkJjb3NkZUhROGlxODhFWlNnSXltUlJ1aGFoUHBh?=
 =?utf-8?B?QjYxcVg5Rnl3d3VtSG4wOUpORXNWK2FIOU5QdzZGcFYxV2hYL1FRSG9lSmJX?=
 =?utf-8?B?SFU0ZnR6YUNiVSs3TFl4T3pMV0RSTHVDcTZMaExlV2NIKzZYWjJUMnF6aWYx?=
 =?utf-8?B?VDdSclJQRHNjVjVmT1EzL2ZUbDFTTVRuUEd0a0dseTBLTEtXV0UvazZlYjRR?=
 =?utf-8?B?Uko4Q3pXVC9LRXZNYXJZcXp1bzFRbGp2TSs3VlFubWZXTUxWak14NVY3akVn?=
 =?utf-8?B?QXhuQWV5R1VudEtZNUdyU3Vva0dVOURXSXd0eUdFWTdRNEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTFOMkZMcUQ2bFJKRXhPeFA1cFJrV3Y1RDNTbk1Na2d2VUdFWDRteW5lVkFJ?=
 =?utf-8?B?Ym92OWVMMnY2ek5Fck5lZVpvRFBCdUYxZ3JockFNWXVHT2ZuRTZVd2R4UnA1?=
 =?utf-8?B?dld4aERrckJHZHg5dUlndkpDcnhxMHFmWTdtNnRpQlNTTFZiMlpiNVlyZUZ6?=
 =?utf-8?B?S3ZJaWl2Snl6WlQwTUh2cU5sOHR0REdWRU4zSTBQZ1FrSGhkTXlOamExWkZK?=
 =?utf-8?B?bzFLUE9nWkVkSnNSUlIvTmx5K1hqU1FHbXYvSm10QU5sZVA2eWpTUytDZHdq?=
 =?utf-8?B?aTBzbDlkNzJkQUpWK3ExQzUwSjA4bEkvRXVYMFBSOHVKNnBPRXNRV09tdXRk?=
 =?utf-8?B?TXhyWjVHQkR1cldsUCttdkVmVC9FVXhMUHhSaUN1cTU4Y3pIVXZIS0N4ZHk4?=
 =?utf-8?B?dVVkZ3U5S0JSZXZ4YWhOVmlCYmlmQTRRcVlCWVBHTC94Rm1OczJiYjFxRjE4?=
 =?utf-8?B?bmZ3bnRJaVJIbUx3VU1odm45Y3krd090K1hPZHpCT0dlMUVaUmRkbEdZcjRE?=
 =?utf-8?B?OFBuajlwbjgyMlVDaHZVYmRoZGJycG9uY2VBRkIrZjc2MS9ZRWQ5bWxidVUr?=
 =?utf-8?B?WW14VDduNE4yU3dsazVDTFBQQjkzdVRsckF0ak0zbHhxSW0xc21nWFZhNVhN?=
 =?utf-8?B?RWg2NVR0NzVmMFdycWNLMGFPTEJrR0RNUHpTM2NzdCszNlhqOWdTd2RPWFhm?=
 =?utf-8?B?TmJLREpxUzlOcGJPMW1nZlN3RWdKRkxXV214eDJkUHdLTS94elZGempQRFhH?=
 =?utf-8?B?VUNvbmJBYk9hTWQzdzJ0QkhmK2xHd0VPREJKdHFpSndWcjdsU0ZLWlM2YTF2?=
 =?utf-8?B?TzkrOGEyVmpSeFJyZkN5SWJuTkUyZTBwcmxnbWdGNWsza2hpVFNqQjQwWXhu?=
 =?utf-8?B?MExnM3h0SlBzM3lUaXl2TkppNWdCczV5ZllLQnB5T3pqcDVwQTU4bUxRZURh?=
 =?utf-8?B?bytTdVNlYThNMnU1dmJ0MmlaWmxuL0l1Sk5BWm55LzhORFJlcWJGaVgwMVBI?=
 =?utf-8?B?YWNxRjllbjVRRG83VVpiWEVPWHpvMXc0UlNES0FEcWcxandtNEtjYjkvMlhk?=
 =?utf-8?B?d3ZHSTczN1FSR0FnYVNEYkpoQjhTNUl4eGlQQkw2aExKVDU3REYyc2Q3VDdV?=
 =?utf-8?B?NmlwL2hxUWJIYXRBc1hrQ09qUGFFN3c3czJtdk04Q1B0RFBLU0lhakRIUmRs?=
 =?utf-8?B?cTkvM1ZxYjZUUTY1NzZrUWF2SERCTmIyV3Z0MXBMK2tFYUVlWm0zNTBUMmpY?=
 =?utf-8?B?YnpteE5iWk5IdXVZRXpYNWQ4WEl3NU1SSEExeGEwU0lKd2FNd3g1M040ZWdz?=
 =?utf-8?B?cGdZN0VpNDZmeXNOekFaMGN4SkVlMW9IQ0xaVW9rV0xIV3ZHVHdveS9GWm5B?=
 =?utf-8?B?KzBFSDFWelRKcjBIMFI4eXcxYkFCS29GUDFCUGN0U0M3UFBSVzdhbXFwblFs?=
 =?utf-8?B?eEdjSFJ2blFpaWlxeDB2ODhwQ1A2UGxpUzdHZkxBYWU3ZWpYMEtHQ3ZxdGIv?=
 =?utf-8?B?OHFuSnB3cWtRdHBsZkVzS0d6MGcxaWJkNS82RXRiajNDR3RsbGRhdkZCekFM?=
 =?utf-8?B?b0NJaEh5dEJMNktUZVNCN1g5NVVoeGUxUnROeDg0QnRZUW9nYWE3cEJaZGpS?=
 =?utf-8?B?WVBjS0VEUEpwdlBzbUtNbDA3Y3cvZGsvdVlDclJCdFFtK2M3UHNwdnV3eFNN?=
 =?utf-8?B?cm11K2hxZHFETVk4NzJhc2F0Zi9pUnRIZXNMZ2YvNjNWYldUSHlvQVppTjdZ?=
 =?utf-8?B?cTg0TkIwQ25vTXhTMUt0bTBGcUxob29mK05SZ3JZQWYyVDFHZmZCNFRrSHNP?=
 =?utf-8?B?SXRTQkJ1V3Z4OFo3dHlsU05Wc2UzMUVqUjdPS3N1TElvM3l3MllxWkNQbXow?=
 =?utf-8?B?R0RHeEJ3aXl4VUV4T0FMV0d5czJISGJnNGoyV2wxZllUTmFtZ2Q5OFhhSmpT?=
 =?utf-8?B?YUVoL2VzN2Jvb2VuakJIL0RLK0xYTktJQitSelp3d29KTW5pcC9KanFBWjRr?=
 =?utf-8?B?cGhzZWNxQ1QrVks3dU1vNDlkSDdjdVhrUWc0Z1R6WW04d3lOeFMxVU1BeEtw?=
 =?utf-8?B?OWZiK1l1RjV6NVVibEpzUG8wVkpiK0lBeTkwbWVjY2dtZHlReUtoMXZlRFN0?=
 =?utf-8?B?ZWpyRzVWTWMvZm5Kd3J5Ui9vSW5PQ0k2b1BnNy96c2xuSXUyQVJxYVQ5ZE9B?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CDB43D04DC4624FBC1FF1F34FC617E3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65ad91f-5cea-4b25-8fb0-08dc969846f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2024 10:59:54.9205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cAlL6IDUIp4D4vjFKqzrAXgE7OxreTt40kEczmi8GJoYK2sxNdCCGBFVeTXFgfQLSIyQoLx/YIHy4Y/tfTEacQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8634
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--14.102100-8.000000
X-TMASE-MatchedRID: dwNgap4H9hjUL3YCMmnG4ia1MaKuob8PC/ExpXrHizwOIPEW9BbwvKWi
	0ikqR4oubX5McBQ6vv5KzH/ucM+GZRgZ7Tcj60QbPdG/pr9y12tA8JZETQujwunZDXpMs2JZtuQ
	cpSN3DCRnbmluteoYVlWs9tUnHWF92T2c1cWHafm5iM6hhYf4PColbMkvkyYHUekjLrC3lTADBV
	jATuEiHOLzNWBegCW2PZex/kxUIHVmIVC+RmEW7Wrz/G/ZSbVq+gtHj7OwNO3Ix3Icp6zuWzd3i
	iOWbsM4DskB0b0CqNIKd9/eoWYpt6xK5z91KJeo
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.102100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	B8E543590C4E498A65B3DE209BAB07D6F0C90CD454D45FF6AA646B71942BB8662000:8
X-MTK: N

T24gVGh1LCAyMDI0LTA2LTI3IGF0IDE3OjE5ICswODAwLCBXZW5jaGFvIEhhbyB3cm90ZToNCj4g
DQo+IA0KPiBIaSBCYXJ0LA0KPiANCj4gQSBzbWFsbCB3b25kZXIsIHRoZW4gc2hvdWxkIHdlIGFw
cGVuZCBfX2Jsa19tcV9mcmVlX3JlcXVlc3QoKSBpZg0KPiByZXEtPnJlZiBkZWNyZWFzZWQgdG8g
MCBsaWtlIGZvbGxvd2luZz8NCj4gDQo+ICAgICAgICAgaWYgKHJlcV9yZWZfcHV0X2FuZF90ZXN0
KHJxKSkNCj4gICAgICAgICAgICAgICAgIF9fYmxrX21xX2ZyZWVfcmVxdWVzdChycSk7DQo+ICAN
Cj4gDQo+ID4gVGhhbmtzLA0KPiA+IA0KPiA+IEJhcnQuDQo+ID4gDQo+IA0KDQpIaSBCYXJ0IGFu
ZCBXZW5jaGFvIEhhbywNCg0KSXQgY291bGQgYmUgaGF2ZSBzaWRlIGVmZmVjdCBpZiB3ZSBzdXJy
b3VuZGluZyB0aGUgYmxrX21xX3VuaXF1ZV90YWcoKQ0KY2FsbCB3aXRoDQphdG9taWNfaW5jX25v
dF96ZXJvKCZyZXEtPnJlZikgLyBhdG9taWNfZGVjKCZyZXEtPnJlZik/DQpCZWFjdXNlIF9fYmxr
X21xX2ZyZWVfcmVxdWVzdCBzdGxsIGhhdmUgb3RoZXIgZmluaXNoIGpvYiB0by4NCg0KVGhpcyBp
cyBhIGNoaWNrZW4tYW5kLWVnZyBwcm9ibGVtLiBXZSBuZWVkIHRvIGFjcXVpcmUgYSBsb2NrIHRv
IGtub3cNCndoaWNoIGh3cSBpdCBpcywgDQpidXQgd2UgbmVlZCB0byBrbm93IHdoaWNoIGh3cSBp
dCBpcyB0byBhY3F1aXJlIHRoZSBsb2NrLiANClRoZXJlZm9yZSwgdG8gcmVzb2x2ZSB0aGlzIGRp
bGVtbWEsIHBlcmhhcHMgd2Ugc2hvdWxkIGp1c3QgdGFrZSBhbGwgdGhlDQpod3EgbG9ja3MgDQpp
bmRpc2NyaW1pbmF0ZWx5Pw0KDQoNClRoYW5rcy4NClBldGVyDQo=
