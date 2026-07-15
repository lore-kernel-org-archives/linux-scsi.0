Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AE11F192E;
	Wed, 15 Jul 2026 05:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784093673; cv=fail; b=qcGidrTp+z4KUprUo8Z5qhH7q2/xwlb0o/BfDTmOUGqxV0I+8Fab7tXLHm4j1GcoGOsvQQSh87W5eGjc7fOyKGV1FZ1ZzUWYSa2nJFZmpNJqyxJqQg3ZNEfr9JKrrro9mTjDialEZqI12CVKtN8OUS2z2y+W9eQxED00ZmTwp4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784093673; c=relaxed/simple;
	bh=9VSnBkLoUjoDQ0m4kYoEoK17BwXXZ/sSXN7BYUsSoZE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qZa3kDsUPofMtdLzoB7KknFFZOHQHhDYQWjHbDHzL2l1RWtTXdRP2Cdg5z/sWw/9wBh0XwKAmmr83AfXVIWwz2lEQh57KeTXNFxrs/jr4mIu+jxc1dZ4Mt/4dvJdU7sb1GGc8QC+xTkMA6xQmHmnZNWCmqtMLBu/IKuSvTMPJDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hhk3yuj7; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qZrhmH8V; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hhk3yuj7";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qZrhmH8V"
X-UUID: bc9b0cbc800c11f1b1788b6acf885367-20260715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=9VSnBkLoUjoDQ0m4kYoEoK17BwXXZ/sSXN7BYUsSoZE=;
	b=hhk3yuj757J9IBGC+iKwC4Mzqrhc4Lhty+OowmM0/oaTErNjkTegtTdaNdOSCgjwqyF+dB/JoZsNCnM264+YSH4Tm1MngO/KURBfjHY16vZyYpjeZimIMXDNXon+QQP3TVOktUuLwRENdprOg3+T/SXsrHC6WFZh2zVdz60fv5Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:f2baf155-470e-4a42-96e4-9a55bacf87a7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:ebf2956c-97b3-4666-b78c-e1fdbfc8e794,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bc9b0cbc800c11f1b1788b6acf885367-20260715
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1185403156; Wed, 15 Jul 2026 13:19:21 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 15 Jul 2026 13:19:20 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 15 Jul 2026 13:19:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yntjMxFIRIPe+oN/ubgCrMP54c5f4fm+DSANwszaXnh1RzXN69cc10JyMYC52ReFfTrmJgU5O8QRFDx5EPnd1L9MR8Z9jxOYcwctBjveku75eomgBuxsOCehgrLaAx8tlyoJcLs+NDFmCT/8R6EnBxsrJkxQIHly//E5ifH40QgWL1jEq/TisO+y45mZpHyAfnX1EnV9RtYtZJ1i0doXHkiz3ebD9ocremgy3bnNLu6Uw98IC9kAPbzU82c2ydScnDR637+vFmLLKwfcv/G75fcUQJRtRUdjAeGCEwM7MZqiXD/svDf2VumMzJtqpI9FDmBaCd8GEhDvpXxhLon4vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VSnBkLoUjoDQ0m4kYoEoK17BwXXZ/sSXN7BYUsSoZE=;
 b=wTh7hze9d7jXRkH2GuUff2/P23P2+oFXQYszD2nWpdkrXYJltBwjVLByC685oQ3FxBH+DzRnYA8WTX09kwRf0gifcoYeUjGceg5nI+NOYeiOugI+s0VI+Wqzcc4cuKo6gsBYELzDIjTCei35aZfCiKHg/dBN0mN0x3olWxTzD9CxlsBm+F+IJ5sDj+ecNGjKqEKL3E68OKQXrVMfWsqWDH93ov9AmcOib1VaHit0wKlF3MqdrNW08Ctx5W9l6aJWTBOaChDl/2ioJRFdfwY6uFTMvFTolxnRKC99wTJBVyy/NEG7bP56Jgem6LgoksAJulOFED7rOCXhsPk7O4wwww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VSnBkLoUjoDQ0m4kYoEoK17BwXXZ/sSXN7BYUsSoZE=;
 b=qZrhmH8VsNrUMfX2upfHexTYNCUDdLKZ3f6/y62WcgKJWYn0UYN02m4TuQ3x6f5gDYRnHVGrVwFivmJqgdNJRYvovvp0fvVU4ho8C5dmS3YN4lAYAQPfte07EJGv9clsPYmE6zgv9RUi/luuXe0RGMcdkJ/EJ2AKuLxi8vxld/Q=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8160.apcprd03.prod.outlook.com (2603:1096:400:47e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Wed, 15 Jul
 2026 05:19:18 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 05:19:17 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "wangshuaiwei1@xiaomi.com"
	<wangshuaiwei1@xiaomi.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lgs201920130244@gmail.com" <lgs201920130244@gmail.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active
 suspend
Thread-Topic: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active
 suspend
Thread-Index: AQHdE7Yv7rpR8MX3jkCF2uB4J7WVW7ZuC4kA
Date: Wed, 15 Jul 2026 05:19:17 +0000
Message-ID: <8c6ec82474193b6783c195254f0e0dc15a8304c3.camel@mediatek.com>
References: <20260714172726.1736967-1-lgs201920130244@gmail.com>
In-Reply-To: <20260714172726.1736967-1-lgs201920130244@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8160:EE_
x-ms-office365-filtering-correlation-id: 6988eea7-b499-4b22-4011-08dee2309e77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|11063799006|3023799007|6133799003|18002099003|22082099003|56012099006|921020|38070700021;
x-microsoft-antispam-message-info: 3qa4eD1SRMuS4brJPOLSEPSDoLRVrl/SF3D64UwoLLRYbwAL2AwYUTu6DeqrYpki9T0mZG6Ea3wh8M16adXatysyIDdLQfqdCO+EfE2ZidTE5m+d0XpkLUFEYbOd3WJUN3JIAio1PuVhq7jyX0U1Ys3IJznXBz82cL44PcapXW19jqU23izMmpd4kE+D+C8gLbw3jjZVvXejIAHo3zoKLQnEi99pVk/L5PtNf71YDYpaKq/lTQVYGGhmK/towaKDtQm1UPW+bBWqFQI8IyNlfHLnRijQPsOZrJenKRx15jkZmdG5p9AkKQg+Ak3boi4p4O3oro6wpTcVjwHIcl5H2T7Qkk3Z6nN1GUMxhGlW0qlXFId08F7TbgPuPy9CNMc4raP7O/6O1cVXBv2dAIi2j8DX6KrPZCaJKXJiI02oo+VgNdJW8UskzABS6/22vzpPPAtNQxR8YekL66uLPBlXyFnD+biwJF2bhbOOIlJFAnD4OA0/vrYaBuHezm03O1o7RnCSAyax9RISoTbjTusSH5ORXdWAf2cO47qVO3wP73xKGVo2X3bRe7N9JK6N4pm7tlRAhkRdyU5uz2ofiKfJhyLpoAR451YPu7E9UJNIXG/80VnK4wx5E8yxwNDKegILRaglXUPRmzSTzgdy+KYuA2EmXNNFOrcH8AONETadW5hoWHs6C96h3Ky8R9rzrJ35eShS/uOwORj6l+k5yICe9waBWlBGFWRFhQy8C7JO3Co=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(11063799006)(3023799007)(6133799003)(18002099003)(22082099003)(56012099006)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1h1ekl4eWVrcUlhSkYvYkU5Y1VYYjBiSmpoUDloSUxOTFZ3YkVteDY2NEk3?=
 =?utf-8?B?VjE2SzFDNkV4bE0zVHo3OUxGc04rZjdpK1ZLa2VieHN6aGZsOHlDRE5uUlU3?=
 =?utf-8?B?MWZjU1RhYldmU0ZveEFIWHhUU3NPeHhrV1FHektTNVl4c1ZLM1NtdkVidjBx?=
 =?utf-8?B?YlJjOUI4K0wxSEhHcWEzcC83TWN2dkQ0cytaK3dxVWJqKys3bklhUWhvbitl?=
 =?utf-8?B?aXhlR1EzTm1RWXBNcEY1NU5TOVFHMHorb3JjaGs3RkpmWE91WkJiWkIwVGd1?=
 =?utf-8?B?K3FmNlRiOEdKNnFJWE1NRnBlSXdRNE1VYWYzWEF2cCtZOW8zTUdTNE53TlZP?=
 =?utf-8?B?aFRFUGw4N0MwY2NJZ2RwMkUyTmU1VllxL1VVdEZlSUlkSFpNenFTYVRYSVNj?=
 =?utf-8?B?WWRQbEhraHZoTmVuQ1ZUdW5TL1lVTndIQWhHUktRUHc5ZG5Rc2lZc2xzWUhW?=
 =?utf-8?B?R3RrZjd4RGJQSS9DZTdEUThkcjRmNC8wcU1kd0Y0dkUvM2RwdDA4RFVhclcw?=
 =?utf-8?B?SjRZUHpjUGJlYTdVcEZYRWxrdTY3ak1Ub21ZS3RkU0VCRWh5bGdNNXlEeDRs?=
 =?utf-8?B?OGo1a04xOC9NVjVFVUNTNlF0bTRwZU5KeFJYUnd3VjJQSG10YU5MR2R1a1Bq?=
 =?utf-8?B?SkgyYnlDbTBQWWcxcng0TzFWeUxuc1dpcmQ2TXBzL1NYd0tFNVZ2M1drVXZV?=
 =?utf-8?B?N05MQ010RkZtaC9Zbi9wcmF4VFN2Z0pIaTVqOHBWcExieHFGRzNuVDhsUTJJ?=
 =?utf-8?B?RU0yTkRrREN4VGczYXk4ZFB6Z1N4cVMzMmN3VmN0WkY1NjJsR3h5R1ZrRlQ4?=
 =?utf-8?B?M01kU3pIVm9hR3pGSXZkMkJQL3ppelNmOXI0OCtRSU16SGZSaUJiQy93dnlv?=
 =?utf-8?B?bGEvOFFwVjM4WXVGZzBqb21RelRKY09Na1ZGOUtNbEUvWHJITHR2UEIzVjdR?=
 =?utf-8?B?S2RiR0JFVXl1RklpZndhdCtxemc4Q0d5K1U5aGV2VW5heFpKWTlxSmUvamNw?=
 =?utf-8?B?amtuOU9UTkwyenpsaW51ZXFSWmRGWlVDWjRQYW0vbWxTZkt6ZkE2QXZ3N3FO?=
 =?utf-8?B?M1FlK1V2VU4wQzQ3djAxREo4N1FZZnpQcXJONXZxeW9QeUc5UHBzNitqb2s0?=
 =?utf-8?B?WWVGTjRuSm9WOFc4Q2wrV1VoWC9tZmdMT1VBWWdTRUNNQkNPdXBlTGtCbWty?=
 =?utf-8?B?NUpSampXN2Q2Sy9oZU9lRG81bHBJYzVHeUZTV01QRHpURFZaZGMxcXpKY3Nw?=
 =?utf-8?B?TGxTUWVYNkwyR281bE0yUEhkVjVlK09rUnpmclRqd042Vnc1TGRmZmNmbm1r?=
 =?utf-8?B?ZHRBU016TXRxWGhiNUNGSG5jNkc5K1RzU2RQWk02RkJwcXVUQTY5akh2eExq?=
 =?utf-8?B?Vlc0YlYyZi93azlsK3FDLzl0aHJKNGQyR3hOQkg5cE1vNUQ2UnlqMUErWkVV?=
 =?utf-8?B?TUZXRGczVXlaUTJWY0w3S01pRURQK2xmNWN6OEEyaXZaU3Voc1Z6UkZQNEFD?=
 =?utf-8?B?eVduZXgyd3Q5N3lSeWM0ZnJUR2JQM2FvY2dUbUxuUCtTRnFZMi9nY0oySzBl?=
 =?utf-8?B?aFo4OStNV2p4SVhmVDkvRHBvQ0hMdDh0WmEwa2g2VEQ1R2Frc3dyMHM1NXFh?=
 =?utf-8?B?ZlJOT2dmY0lUUGJERTBiaUdDQnU5eFNnbzJaS1FaYWQ2eU5GaVRWSHdpTFlP?=
 =?utf-8?B?Yks4b1JuTHpPWXdnVkFYYlFPc2dENC9ITWYwRFY5MEw2ang2YWsyalV2MlZn?=
 =?utf-8?B?aVlxTXhuT2xMb3VGN0tWR0NnZEtKdDE1N3prQ0lnNW9aOVBjcnVDQ01VV2Np?=
 =?utf-8?B?NGRTV3pRemRUZGo3elhWSWJETGNuSnU2ZmtuR1cybjZlV2VLdUJicmszb2JW?=
 =?utf-8?B?WDZPcGZwZ05wUU5OTnNMZmg0bFY4VEFVS3R3U3FDb3QzYUU1anNGaC9yV0Mr?=
 =?utf-8?B?UDlYemRPcUZsZ2xSRGl3dVdNUzBxcTRkVHpXNjdwdTV4N1FIOWNEMk0rS2pW?=
 =?utf-8?B?bW5ad00waTZ3ZmZQN2l3SU85SlZkckRLQlBiOGE3bGpzb2RiOEdRN2dvNnRU?=
 =?utf-8?B?Mmp1dWZlbEhya09BK0I2Y3JieFkycG5hRHk5RStBVm5MdEtzclBKbzczVlpN?=
 =?utf-8?B?ZitSQ2FQcGpCK2xtMlZSS3E4aWI2L3pDRjJIL2hHU3FPMVVGalFMc0dtcENC?=
 =?utf-8?B?dUNySWJtMCtRbXM4R0NKMFcxcGhPS01PME55ejQ3MHFjZGJCTVoram9RdWJa?=
 =?utf-8?B?S1RyMW9yNWY3WGhiSEZqNmcwQVJVWDlpYVRVK2FxaVpoSHh3ZVI5cngxdDMx?=
 =?utf-8?B?U1FSR3JYOFVYYkVLN1JRK1ZPV2cxbkN4dUtqdTdtaS91VXdmQVJBcTZOZ2Fr?=
 =?utf-8?Q?ZE6R8rPv45oHG/Nk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D2255B7B1A6534D8A83CD1B399054B4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Y1n2n/bc2+rZKCjkCrIISPKPLn09vJ4c/MFX5p1w+gS4X9EvkD54ApiKWxf6UaooaPxWEe+TwcsHVxs7+ZFpwdl3TK0lULSovlmqgHicRB3sxGiMW6B4cZe3Ppt7rVNDNyNS/SJRp6FCLbQkURNVjIVuIY9v3J66ysfJAyOT7oAbgA+kaXWiSU8xIhGN+t6z68qF5zJ+KeFUnG9OADeDzuQugkzeuMaZOmRbZASYTr1stHicrKbd8KcByDyEvGqdjJZTHcHr8uEHMhZhTzUlO1lkeqIbTbEoLCtGnPX1vcw8fiVP2Zg+Il00UHOSrBciztURO4bpeGQayeHcQQ50Xg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6988eea7-b499-4b22-4011-08dee2309e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2026 05:19:17.7618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: euCfiGg8n5+ualJs2adh9FNC7vmgrPotn6J8WbYqvh/37uoYXzpEcvG3wU4wVnCRfiQLKytQqCD3ptcN/0xKow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8160
X-MTK: N

T24gV2VkLCAyMDI2LTA3LTE1IGF0IDAxOjI3ICswODAwLCBHdWFuZ3NodW8gTGkgd3JvdGU6DQo+
IFVGUyBSVEMgc3VwcG9ydCBzY2hlZHVsZXMgdWZzX3J0Y191cGRhdGVfd29yayB0byBwZXJpb2Rp
Y2FsbHkgdXBkYXRlDQo+IHRoZQ0KPiBkZXZpY2UgUlRDLiBUaGUgd29yayBjYW4gaXNzdWUgcXVl
cnkgY29tbWFuZHMgYW5kIGFjY2VzcyB0aGUgVUZTIGhvc3QNCj4gY29udHJvbGxlci4NCj4gDQo+
IEEgcHJldmlvdXMgY2hhbmdlIG1vdmVkIHRoZSBSVEMgd29yayBjYW5jZWxsYXRpb24gYmVmb3Jl
IHRoZQ0KPiBQUkVfQ0hBTkdFDQo+IHZlbmRvciBzdXNwZW5kIGNhbGxiYWNrIHRvIGNsb3NlIGEg
cmFjZSBpbiB0aGUgY29tbW9uIHN1c3BlbmQgcGF0aC4NCj4gSG93ZXZlciwgdGhlIGFjdGl2ZS1h
Y3RpdmUgcGF0aCBqdW1wcyBkaXJlY3RseSB0byB2b3BzX3N1c3BlbmQgYWZ0ZXINCj4gZmx1c2hp
bmcgZXhjZXB0aW9uIGhhbmRsaW5nIHdvcmsgYW5kIHRoZXJlZm9yZSBieXBhc3NlcyB0aGUNCj4g
Y2FuY2VsbGF0aW9uLg0KPiANCj4gSWYgdGhlIFJUQyB3b3JrIHJ1bnMgd2hpbGUgdGhlIHZlbmRv
ciBzdXNwZW5kIGNhbGxiYWNrIGlzIGdhdGluZyBvcg0KPiBvdGhlcndpc2UgY2hhbmdpbmcgaGFy
ZHdhcmUgc3RhdGUsIGl0IGNhbiBhY2Nlc3MgdGhlIGNvbnRyb2xsZXINCj4gZHVyaW5nDQo+IHN1
c3BlbmQgYW5kIHRyaWdnZXIgYW4gU0Vycm9yLg0KPiANCj4gQ2FuY2VsIHRoZSBSVEMgd29yayBi
ZWZvcmUgZW50ZXJpbmcgdGhlIHZlbmRvciBzdXNwZW5kIGNhbGxiYWNrIGluDQo+IHRoZQ0KPiBh
Y3RpdmUtYWN0aXZlIHBhdGguIFNpbmNlIHRoaXMgcGF0aCBub3cgY2FuY2VscyB0aGUgd29yaywg
bW92ZSB0aGUNCj4gUlRDDQo+IHdvcmsgc2NoZWR1bGluZyBvdXRzaWRlIHRoZSBkZXZpY2UgYW5k
IGxpbmsgc3RhdGUgcmVzdG9yYXRpb24gYmxvY2sNCj4gaW4NCj4gdGhlIHJlc3VtZSBwYXRoLiBU
aGlzIHJlc3RhcnRzIFJUQyB1cGRhdGVzIGFmdGVyIGFuIGFjdGl2ZS1hY3RpdmUNCj4gc3VzcGVu
ZCBhbmQgcmVzdW1lIGN5Y2xlLg0KPiANCj4gRml4ZXM6IGIwYmQ4NGMzOTI4OSAoInNjc2k6IHVm
czogY29yZTogRml4IFNFcnJvciBpbg0KPiB1ZnNoY2RfcnRjX3dvcmsoKSBkdXJpbmcgVUZTIHN1
c3BlbmQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBHdWFuZ3NodW8gTGkgPGxnczIwMTkyMDEzMDI0NEBn
bWFpbC5jb20+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0Bt
ZWRpYXRlay5jb20+DQoNCg==
