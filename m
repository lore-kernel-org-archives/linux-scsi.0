Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F58C282F25;
	Tue,  4 Aug 2026 06:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826376; cv=fail; b=hdAfVYXna7bLhDM+BKicyuBn9I0bSKeoYd7H2j7TRLvlWLVo9wnRNi7Vud5c23kGwWNtmDMD0pfJK7h+lSlS3LHTKaOkdfcJjjBQ26EadkaXkfpN6yz9VDZKBxLyC1GAzPklgLYoO9yU3d30GylLGloiNqEou18jR4hIf3xobk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826376; c=relaxed/simple;
	bh=zUkGuwbdu1obu1EcqGPWYoGwP0uBDP5HgtlVdvK9vgk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kyOgxqXyT2sq9UN3j7Cvwhk7AFyKOMQG6SqMp+Nt0JpdO2+QbcybOVJTXYDy6N/Fujssu1HCQ4J6ZtbqZGPAi0YsJmC6uo5d+mNVKxBaZwvFN0ulemcMkGPchfEcik40V3s/PmbPGFgfXiPQ0+mF/9VFW7IFUZvA8czPAgFWfWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ixoLFn4F; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=gXZOl4c6; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ixoLFn4F";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="gXZOl4c6"
X-UUID: 1a1c4cec8fd111f1b1788b6acf885367-20260804
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=zUkGuwbdu1obu1EcqGPWYoGwP0uBDP5HgtlVdvK9vgk=;
	b=ixoLFn4F70hbIe90y9l9WnrRRqFbmAWF8Wi7SIqi8DfHfcPPK8lfvDxTh4aQqPuuI+mRWNVDafHhzZhGbPIh/EpDPIytztkWzwZVYK04+jkBimB02fTk6XKkkWO7qBBGbgC2Q3CvSdACALQx+5slm5qh9rfsFRqdSzD7T8tLKPI=;
X-CID-CACHE: Type:Local,Time:202608041452+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:6a110b1f-22a8-45b7-8843-a0fb4b1c42e2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:38f41be2-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:
	nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1a1c4cec8fd111f1b1788b6acf885367-20260804
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 351632772; Tue, 04 Aug 2026 14:52:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 4 Aug 2026 14:52:46 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 4 Aug 2026 14:52:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VODt3RvSDockrZLG4jJyii32o2Mew5+EcksSGTautM6SuhZMFJiRBuSifqSIcA80SfKwSGJF4ufLJqlFqPRjCh4sAb+9AUNY6FFc0suGciduSMRPNsTSAyCM4DTzozl4Z4hkIODL0zwJvCxUsZpwXij3eO5fjM9w4DGvgCMnx3P859svEcM9Rq1qBw1TN+mvs+rW1BxHwnjOcEwf3ni49gy6OSOxUbxe8Y3ml+kcxgC2fAsxKEEMvW6rfcmpuZfTp0ENcjiZLX+WiMrPT+xkf5a2VL7WJy+USClxHhEOqwkvL/Q8RIGHgtgJ/qLSeYLrxPKziKfBVATtZqonhK9X0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUkGuwbdu1obu1EcqGPWYoGwP0uBDP5HgtlVdvK9vgk=;
 b=KwhmeOisA/a9Du3O7CK3XLDZDEGcGn1WDvTY6qxSOqHunJ2c+PTChr4TBvJ/AV4avMJuw7WkRut/ocvNvaHdGMEVsrAZsiDFNqq5QnZQx0Z2UruOwlTMSqOPlhFMhBqHDvy6nDIGUmXJmo2sQUUay1wvjVw2cGMIBDrVbXDDQ7XfjXnnNklUEpftuA3NbW/w7DnP0t+2FhplLp57bHP2MHWN579kPJp2+f0Omn0cF9RJcfwpkQMYsBpXaqNVPQd82yrvbdGjOWxlDieqtWpHDApI5dDop6ysYPXHKukllkqCFdvcrQXykL9WIJLh+vRNPM5NSAiFKFa5u84mZ+Zpnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUkGuwbdu1obu1EcqGPWYoGwP0uBDP5HgtlVdvK9vgk=;
 b=gXZOl4c6yBz7t3vdwAx+ofn8AiA9BAElz7WzUiHCSlHc6tmTaQPEXz8sr9M+RVJkwKfEF+9VGZhpnSYXZsPDQOia68QFf0BHpS2KoZVQ3PoCQbcQ/Z0niQ26Nzd0zKfwYTIN8cnb5hFPNk+OqjvFNBlr0Z/jq3kHrn5cfLOaatg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6594.apcprd03.prod.outlook.com (2603:1096:101:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 06:52:40 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0270.016; Tue, 4 Aug 2026
 06:52:40 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>, "vkoul@kernel.org"
	<vkoul@kernel.org>, "krzk+dt@kernel.org" <krzk+dt@kernel.org>, "Louis-Alexis
 Eyraud" <louisalexis.eyraud@collabora.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, "nicolas.frattaroli@collabora.com"
	<nicolas.frattaroli@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v10 23/26] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Thread-Topic: [PATCH v10 23/26] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Thread-Index: AQHdIAjxntENx7POn06PrBV79k/G8raNe5uA
Date: Tue, 4 Aug 2026 06:52:40 +0000
Message-ID: <5bd5a02970531b954d2b51ff85e2e685b3a93eb0.camel@mediatek.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
	 <20260730-mt8196-ufs-v10-23-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-23-bc5ecef202dc@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6594:EE_
x-ms-office365-filtering-correlation-id: 4a6ac309-cc5f-4a9c-99b9-08def1f4fa22
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|921020|38070700021|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info: YYJScARjLA5uE+O9EWqS3SRKODiYWP5h2iqi+UVv2f/s5Ko7uwPVAbQDdwKL2O8HdRro9+BdYAsytPCn1iN3aWI2Kt+7+tkkEjwAPm5zN+uzTlKjW2NfT8HEv0eJRr6sfhRWAHotyxWN+J7QZ9F/D3KCzbFMzfKBdCe/O6GFYe6GZBDyiAO8WPVnT9u4uZkBCEvUaoMoV6yIS481LiidVx+IdZwdqQxj60cGOmJPCVSTv4lAHi5ek4noXTCyPlolpHHS/WsjeqYG1STjyUJY94Ap84NT0zjBThtoWhzTOqyWCWi5/9X7FfDvNp5ecMEYZh5UyPyDfFkvi/tzgMnP9j3vTZCUW1Hczt9gwn1QpyioG3595q1Nt+XD1/V+du58hS4xO7uNRf+0dTADFg3TxF8iEHM5+paLHV+/9JbU7XgNMQ7JDExlefMh87aYKB8BBvs0hE24wwjkH6yXrklNl+ifD9niKSCGJ/uhPPBnZMX1JhL5x2KmuCD090qhEahjz+YYF+xHnMGgSRA+X7D4IpcbSl5ieWNewncaiUtmzbkYzDYsjSCAlV59+lkxkIs/3XN5QvKq/gKAn7i5T25lCgHnI0dX7ZETcYXbarX7rCO0RgOM/zxmRdPNdRadup+rJPHKt7uQW/lSn3uA/ushqG7574vOmR8LPtJbwjFmoUzgfoReq5spUgUDf1IUO3XG0Rq/y3O4JpXahvSUmtsZKI0ojmDNdglvfHHqgFrmDihINuirj4AHQNbZBjnh/P3C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(921020)(38070700021)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmZKMCtwTWtXbER5QklGSWcyZ25ML25LUW5kZ1ZKWERJdHZLMkhJNDd1WmpQ?=
 =?utf-8?B?UEt3UWZvdi9OQjNndWtabXJpRXp2NHAvaWtUeDRKUkJXWkxhcUVmZlRhd0c5?=
 =?utf-8?B?bFpqVW9xWVYwV0JMdmd2U2xjay85N0lKTmN5VFBhS0s0NDZGUkg2dTZEdkhm?=
 =?utf-8?B?SWtPeTBkMG8vUWx1Q0ZOLzBBYnE5VUppRmcvc2FOKzlWdmNDekprSGF2SWlp?=
 =?utf-8?B?aWRuTkJpektQNjFDamRkQllhaVY3YmZrNDNYU1ZOQjQrZi9aeE15Z3NQRmFH?=
 =?utf-8?B?S3pHL0V1TXU3WEdUYy9ZMXBaRmh1Y2lKb2E5amRQZ0VDTDZhdklZdlQ4T3hS?=
 =?utf-8?B?RWF3RGtFZXlPQXM5bkwvS0Y3Q0ZIUlpLdnJPQVVyMXlyYVJpYzFnWlo1YS9T?=
 =?utf-8?B?NVZCWVJLdmt4MmlsbGVpRHZtd2FXVXBKSlFGaXFQVHYzemtBYXdCSzUyWnlK?=
 =?utf-8?B?N3pEbE05emxWUmcweUdjaUFhbk81VkViVDRTRE41NHd5S1BnUjE5Tytuc2JN?=
 =?utf-8?B?QVBFNFZSS3RkVUlrNlVUdGlzQ2RNc1hKRmt1QzZFdDIrekhNc2VQb0k3L0lJ?=
 =?utf-8?B?WFJFN2xZSm1IR3N0TlhtQ1JqSndHcmd3dmRvaE50ZkIrUEtSZXY2cktEcUJM?=
 =?utf-8?B?OTdPUnJWaUJxbmVkWW9mbGFqdlZIaG1JOW5sUkxZa1drTmIxQmdjREczamx0?=
 =?utf-8?B?dHFuZGN5dEpUajdJWVVSS3ZUcXN0c1BvNUpzdVV1d09scUN5NTdDMUhWUEVz?=
 =?utf-8?B?RzE1Y1k1MWRFcUcyM29PTG1TUDhnclA1WlNmZHMvUTA4eHJRVFpZUmpmUzZX?=
 =?utf-8?B?Q2tGV2VETkhHcVRzSSs0TXcrVzdmSUU3OGxMRzA4a0hGNWpUT1ZmNVcwbzlH?=
 =?utf-8?B?SnNoYWJ4OXg1RGFQb3N5M2dZOXNKSXMwbGlXcE1TVnR0K0JNUEZ0OFNxcERs?=
 =?utf-8?B?Q1RhVkdWeTBJcThscXpzaVZDRVRaTDZRTmtERDVVZVRVUWFJVXVRVVZldnR6?=
 =?utf-8?B?UGZTeUF1bWJEWVpQc2FDdG5CSHVYVU0vRGJ4cnNVT2FLVjlDeDJVQ01ZeUxh?=
 =?utf-8?B?UnowYUZoUnpIeWlOek5SVHhSdUltMVZJNFdzdHVsbkZPaEFhS2IzUHJiMGhS?=
 =?utf-8?B?dWhuTXA3MUc1czFjMWk0WGd1eWJnZ3JKYjdZS1NIbTV1Nk8zZE9oMjVsN2pP?=
 =?utf-8?B?OTJKdXFIaHVjd1ZCSmhOM1NOOHFqbzNMTk5ySkYzTlU4eW5mZkZ3MFl2ZEpP?=
 =?utf-8?B?VWgzaXVCYnBZLzBmWmhOQ3hybTNNUEJJakhGYnAzNVJNTkVKY3M4WVVSTytx?=
 =?utf-8?B?NFN3eGlNMThzSWN3SlMrZTMyUlVTODl0enZWTFA3V2dzeDA3WHBLSmRsUnp1?=
 =?utf-8?B?ZFo2SEo4N21aS2xDcXJ2TFBIbTBNbEpTQksvQ1V1UnpsV0JwQXVCRnlTMlgv?=
 =?utf-8?B?TzJ3RjFFbzJDRzdHNERmZTR2S0U5RXNiQXdXNG1KVGdiR251WlhhVHoxdTBT?=
 =?utf-8?B?QnNyL2RFaU00aFlvbEJDTG1xRDBYYXZ5MWNRNTFmNmxwdUdlTXoxZXorTmdM?=
 =?utf-8?B?TG1OOHB6Mk5vZmJjbUhHREZxZktSSmhuZXRickIvSFFXWUJIM3hYRmpCKzl0?=
 =?utf-8?B?Vm42L25TcDlucUdpUWx4bHhNOHoxUmIyRVBqMWRaUU45Vk03NW5UV3N2QjZN?=
 =?utf-8?B?NTdaR2tYSUlYZE5keE9SZTZLMHhnUWhhRXBScUE4Y0JKUS96ekpFVWVUUXh4?=
 =?utf-8?B?VHRnRVFqM3kvUU1TKy9DYVgyVHJFUUhmbzFkQ1dlWnpEc3FlNVQ5cnFTcDRC?=
 =?utf-8?B?UXhFMjM1WkZIZVE3YjhzSk1vSjNGd2dKaEEwaVRIOUJ4dTRuSDdMbmhaeDhJ?=
 =?utf-8?B?TkZjTFNFM0ZOS1RFTHlrcXZXUlBRWitEdkY3cmZmMTJCSTA2UHNuYVk3WitL?=
 =?utf-8?B?Q2ZPS2JEY25lYmZxTGVCQUNqeW5vTGV5VTY4eEphRFo4T2Jqd1JabVlmbGp6?=
 =?utf-8?B?QzRkZFZoS2k2bWpyOUlhTms0S1NSNGsrQ0NYZFdMQ0VNYWpJbWJLMlpZYVJv?=
 =?utf-8?B?eEZueENSS09GRUpBaDFXbU1GdzJ1WXpSNUxPOEl0WS9wdXJpcy9Ec3BJbC8z?=
 =?utf-8?B?dmdOcnV6cUlvWEw3d0JoYzJxekIzYkVkTTlEZk5LSXd0WGNPTXpuR04xbWFH?=
 =?utf-8?B?WHdoZ2FWek81YXhURHg2TjF2Y1ZlczkrUnRZdk5Ua3o1ZmZmbUg2VmZoZHh4?=
 =?utf-8?B?Ylorc2RRa2xJN2d3MXgydmRFdnJ6NDhrZDB5d0ViV2ZMTDNQeHhFUkxaY2Y4?=
 =?utf-8?B?ODlkeW5lT1NwSHhEZTE2blBGV0tLazFuSllLTWtnMHBleFBIT0k3YXpSaE9B?=
 =?utf-8?Q?VN2OKOUniehk7Tnc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <962B3F5F0F5E95408192D22169019C42@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PCv6ceXzp9JcApw79UeDNVLz760IquSNnK1DIb6B4wyOIcGqwQJVZNhHhljHoYub9eGiC8YOWhmIEmMALpVE6oB/8oOKEC0hIdKTgeyiHQxh9wbmaSgbcr+W0xJcyebJI3GZrbRt39g7hluh9zsolkJtiQEmO1eHoncHEB/nQKJm+sEc8HPE4yHnfj1GODMenZD4xEnnPQjTpLQaZQNGf1CUnFnQHP18atj8JxHgcsPXZOE+ydXrcwbognD7ZJHKaAuFUgds3Ey7OSkAVoFYcI9MuOkTUKdO1vD0wzZAEjh40hBjnzgFHAchLFGdk75+5zgbvJPeXwT/Kw2N/4+itA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6ac309-cc5f-4a9c-99b9-08def1f4fa22
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2026 06:52:40.3725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S/kBNf8WAxAMpvtxEjfc2cPRK2Zv0Rslhzjxt2XEHbbqpqoH0GrbwmgbOy61Gj4lhWbG899RqFzTrjtgEAKZ/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6594
X-MTK: N

T24gVGh1LCAyMDI2LTA3LTMwIGF0IDExOjQ5ICswMjAwLCBMb3Vpcy1BbGV4aXMgRXlyYXVkIHdy
b3RlOg0KPiBGcm9tOiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xs
YWJvcmEuY29tPg0KPiANCj4gVEhlIE1UODE5NidzIFVGUyBjb250cm9sbGVyIGhhcyBhIG5ldyBj
b21wYXRpYmxlLiBBZGQgdGhlIG5lY2Vzc2FyeQ0KPiBzdHJ1Y3QgZGVmaW5pdGlvbnMgdG8gc3Vw
cG9ydCBpdC4NCj4gDQo+IEFsc28gdXBkYXRlIHRoZSBjb3B5cmlnaHRzIGFuZCBhdXRob3JzLCB3
aXRob3V0IHRhYnMgZm9sbG93aW5nIHNwYWNlcw0KPiB0bw0KPiBhdm9pZCBjaGVja3BhdGNoIGVy
cm9ycywgdG8gbGlzdCBteXNlbGYgYXMgaGF2aW5nIGNvbnRyaWJ1dGVkIHRvIHRoaXMNCj4gZHJp
dmVyIGFmdGVyIHRoZSBwcmVjZWRpbmcgcmV3b3JrIHBhdGNoZXMuDQo+IA0KPiBSZXZpZXdlZC1i
eTogQW5nZWxvR2lvYWNjaGlubyBEZWwgUmVnbm8NCj4gPGFuZ2Vsb2dpb2FjY2hpbm8uZGVscmVn
bm9AY29sbGFib3JhLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdA
bWVkaWF0ZWsuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29s
YXMuZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBMb3Vpcy1BbGV4
aXMgRXlyYXVkIDxsb3Vpc2FsZXhpcy5leXJhdWRAY29sbGFib3JhLmNvbT4NCj4gLS0tDQo+IMKg
ZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDE3ICsrKysrKysrKysrKysrKy0tDQo+
IMKgMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMv
dWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5jDQo+IGluZGV4IDVkZDcyYjgyNjE4MS4uZGVjZjJm
NTgxNGI0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+
ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gQEAgLTEsOSArMSwxMSBA
QA0KPiDCoC8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+IMKgLyoNCj4gwqAg
KiBDb3B5cmlnaHQgKEMpIDIwMTkgTWVkaWFUZWsgSW5jLg0KPiArICogQ29weXJpZ2h0IChDKSAy
MDI1IENvbGxhYm9yYSBMdGQuDQo+IA0KDQoyMDI2DQoNCg0KPiDCoCAqIEF1dGhvcnM6DQo+IC0g
KglTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiAtICoJUGV0ZXIgV2Fu
ZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+ICsgKsKgwqDCoMKgwqAgU3RhbmxleSBDaHUg
PHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4gKyAqwqDCoMKgwqDCoCBQZXRlciBXYW5nIDxw
ZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gKyAqwqDCoMKgwqDCoCBOaWNvbGFzIEZyYXR0YXJv
bGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPiAoTWFqb3INCj4gY2xlYW51cHMp
DQo+IMKgICovDQo+IA0KVGhlIG5hbWUgYW5kIGVtYWlsIHNob3VsZCBiZSB1cGRhdGVkIHRvIHlv
dXJzPw0KDQpUaGFua3MNClBldGVyDQoNCg==
