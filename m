Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B1E29D27D;
	Tue, 13 Jan 2026 07:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768289186; cv=fail; b=GE9YdGPCAiI3ucPhXNJca/Ih4WgSsRxbOBRt8RwhMJqpKxyF2ZEJ6Sd8ALh45454T/v7IahtOLGGoBnhzASwn7fOjg2dZAXT70/HajuqoUKti6WctlixKvPCWcfxIjuub81W1ZehsePx14NJ6bE2QvVIuZ+0YbVj7np4pnsc2u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768289186; c=relaxed/simple;
	bh=nq7S2MwoGOYXFD3ikxJANzv2lP+h436MNQuQi2hfRBo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XYS8Nupl0HA2d+BxT32rB0/s5DeHmUnKVF392xvhwRWTl6beSnULRjDuQdDMVRyxeocI9AYneuFLwEEewIsunjWNiYNs8ct1zl5WaFZmGQqEJqARRJ/71J20L8kcWBme0Tm3LzDJo0NhK63fKqFdeXpJwD7ZBo4+112WB1/S7eY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Cyis5NRS; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=FvVVugrU; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Cyis5NRS";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="FvVVugrU"
X-UUID: 26a79aa4f05111f0bb3cf39eaa2364eb-20260113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=nq7S2MwoGOYXFD3ikxJANzv2lP+h436MNQuQi2hfRBo=;
	b=Cyis5NRSA1Xutl2eCZmuPNvIEtQEhzTQMWaMrMvSLn6xDulo/A13wtQjriVweOOxDwsXFFDk0MEURIv73alDTvE+h2ttGbW1Q7elhQ163re/mFdkAPRciISo6dzzWlxFRb0wGzAY1+6/CpY585nThLUXGVJQsVXMCzdz7fMoFys=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:546de4fc-eb44-466a-a156-97dc7cfc81bf,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:47e377ef-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 26a79aa4f05111f0bb3cf39eaa2364eb-20260113
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 296037494; Tue, 13 Jan 2026 15:26:18 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 15:26:16 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 15:26:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EaLk0vyGtOtCmAoYEASOGDDdn5DxHbf3qQtiwoFc6t3JXW79rYG6wQ36+nCtlgOFVnMpn0Ppx1rU85zL8eplNfT88oQH2UOmuezlFZHWDqnGhZ3/XwABAqMJV713m7LgML9ebdtp5EE5uqsTgF04upLhLzN3OVLTTRzrPu+qP8gSvnKjGSknpTfttt7xk8EAZxm5mSHJu6WO6YdqzhLEeT0tK0rFHJb+VYfu/QvOPPzOE84pa7eA+82FvD7NytD7h2tmv4AIKA7AMrDl+LKdVXKq/tNGyJLAmnx4GitVgoa4HR5GUPfEl2I6aC3YCHhjZ03KZH71bvYPVwKJMeJevA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nq7S2MwoGOYXFD3ikxJANzv2lP+h436MNQuQi2hfRBo=;
 b=XDrTpi10Qrmn2UZmGkQWNTEoe79OWA5djPAdE2LFjKayO0fWBigNpOFolo3ELtGwbrb31l44GzmXSYGo1Th36VCD1DE27EYY1zrehvuWGYk9PQEvIUe+BXYlab3npFrsK6qrU4fvSWVaLkorc9BEFAmu0dk7Oh1k66xxeqpV54/erJZryyd6/ulf0tGxe8TQTltuCukIlcoVmg246Fsi/s9f2zBENuOZooEbXPVC2XTQjcI6sFNpHX33prPnGwFJA0YcgUCw1TMuLBOooo/Tyq2kMQLgal4vH7ffI4v1Am7z5diNYMsPYGu7djuozooEyqCV55OHjJoKrGjtCA29RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nq7S2MwoGOYXFD3ikxJANzv2lP+h436MNQuQi2hfRBo=;
 b=FvVVugrU+SFWHaRx8c2UHdbhkSLpPwkwRa/wd62BaVbnZj4kYjEbBH5UlJKJBL8uKSAEWC8eqxv6gdVGxVwJl43hz0iB3JuS/U/kHVC+5zeh2lzXlxqYbUURk6rH0Lw61a15GSRpvh0FI/oAU1HTY9smBBA59S6anIQyGQRS7cU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PS1PPF5DE123533.apcprd03.prod.outlook.com (2603:1096:308::2d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 07:26:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 07:26:13 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "krzk@kernel.org"
	<krzk@kernel.org>, "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
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
Subject: Re: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
Thread-Topic: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
Thread-Index: AQHcgIzex50QwHB34kulYV8QY4/tvrVIMsMAgAEs4YCAABE5gIAAFKGAgAABlYCAAAkegIAFF8YAgAESuoA=
Date: Tue, 13 Jan 2026 07:26:13 +0000
Message-ID: <74944c55418976375955430d27ac568149d555f1.camel@mediatek.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
	 <20260108-mt8196-ufs-v5-11-49215157ec41@collabora.com>
	 <81ed17eb-2170-4e97-b56d-488b5335ff5c@kernel.org>
	 <dd2eba99adaddf7517f06acf7805d32e261fafa4.camel@mediatek.com>
	 <87887adf-2c94-48c2-8f83-4e772ab50f60@kernel.org>
	 <e9a6da3998195b9dbda5abd26bc6dd5d3aca07ff.camel@mediatek.com>
	 <66ca211a-c909-4d0c-a22c-9cbd3489d372@kernel.org>
	 <46cb450f92887ceba07614dc85ed495f6af7f602.camel@mediatek.com>
	 <26c68bb1-1e63-4b47-babc-21ae27e3205e@collabora.com>
In-Reply-To: <26c68bb1-1e63-4b47-babc-21ae27e3205e@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PS1PPF5DE123533:EE_
x-ms-office365-filtering-correlation-id: ad21c466-c3ac-4976-01ff-08de52750861
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?L0RyeXYxeklHamtDR3RxQStrWk1OanoxYWRhVk9YVzhCUUdaNFZMajJpMVRG?=
 =?utf-8?B?ZU1zTW90dFhWQkRTSGU2TitGYUQ5YzFtR0N5ZEJDT1dDOEU5ci9PdHBOaVZp?=
 =?utf-8?B?QVRnaG9INUtwUVFXVzFLaUxPSGdOejRSNkNuU3I2YTFoY1ZMeFlVdjFUR2dL?=
 =?utf-8?B?SElhNHFWdklMa2lUU2ZOemhvd0podnM3djFzVWZXdUZtbUtsN01lN0QxdGRG?=
 =?utf-8?B?OWU2dWpaWmMzdXJUZkZDNlJMMHZiSlpmL244SFVWbVRhZEFJV1R6c3cwU2di?=
 =?utf-8?B?QXluUHk5eE9xRHUvZEJ1MzBISDVqZ3NsRnQ4UFdUSXdBeHV0Q2UrM0taMlZ1?=
 =?utf-8?B?MWNEc1MzVEhiUmdRQ1JyR0ExME05S0VXVnFuUlJXbFE4T21uNnRTOXVEa3M4?=
 =?utf-8?B?OGsrSjNWR1NTbVdtcDlvK2Ftby9BekZhTGtEY1FTaWh5UXJVWkJqZ2RUcDVD?=
 =?utf-8?B?U09xcG03TTdINklESXdwVW94UDNXbUREaXhyenRhZzZDRytFeC9XUHNjdFhj?=
 =?utf-8?B?a0RDa3IvZEFSYS9YV3ZJdVUwbVVXWHp4WldWcXhyTXpPRlRqNkhZWkpxV3pJ?=
 =?utf-8?B?UUxIMFhIUzdTelRNaUxvZE5OMUVId1RwTHhTOU1OeDR0WWpBbnB6VFhaLy9O?=
 =?utf-8?B?azFyMC9vY0hsWUp1dXpBT01kMWJTNExkM3pocHlTNVR5amNEWXhGRU1CWDZm?=
 =?utf-8?B?OVk3K0ZTL2dIVEQyOWk4c0Z6SGdnK1U4S2l1c3NMNGs5cmRJRTFoNkhRRC8x?=
 =?utf-8?B?N0dsd2llM01ZS1BKWHRkaU11SmhuUEtqcU9VSmdxVFpERUZITnpYUGtPMjkr?=
 =?utf-8?B?YkdzWFFQbG9ZRjlKQ0pGVXlhOU5NY3lwbnJmU2ZwVkswemtyeUc4TU1ubTVr?=
 =?utf-8?B?b084WkZ4VW4yVW9PRDd2aXYzZ05GakJ4eXR0V2dRaitnYktLaUN1TGJVVkd5?=
 =?utf-8?B?OWoyNlNWTUNZckFvdjZZd1VGeGNqaVM3dFdMb2MzSEYweTkyOVdvNXZWaGNa?=
 =?utf-8?B?am92bWZraTNFQUVjaEVqNU9Ld00zS2pPQ1RtWnFXMmhZSzZHbHo3TGZkcTNM?=
 =?utf-8?B?REMyT3JEUS9hRXpla2hpa2NDbkM0N1QrTkNpNndweWJSQnB3WEViWFIzRkp6?=
 =?utf-8?B?NDRxTmRpZC8vcC83dFlPZ25KTDFocVpTZDlZWVVpK2ZjaU1meGZ4VTVWUW05?=
 =?utf-8?B?d1JaTkJRUTlyQXdiczB4d21PRDJGRnFHWnhUcmlwVGlQdGU2UmorUTY0eWtj?=
 =?utf-8?B?MDE2OWxlbnZYS1BFNjFvSHJrYWVldjhzeTVrT1ZBdXJxYzh0NzRzQU54QjhG?=
 =?utf-8?B?dnc1ZG1IcnR4M2pMWUZVL21iOXN1Z29Yak5FOXRsdzl0aC9xbFZCOGZTcUcw?=
 =?utf-8?B?cjBLeTVKKzMzdHRZRFRGUnY4aW5LM1hHSWtrV0sxMG0rMDMwNjE4dzYyS25O?=
 =?utf-8?B?eFdyaXBhQ0xzakhkZ0xsb1NCRGwrcUwxc28vb0FmSjlnSWlqTWVNVDFQZzF6?=
 =?utf-8?B?UDhOaVlPTnZpU0ljZ29kenhjTEhjUWUvSXRiK1VOdTFhTmlqYjd5YTZPNXlI?=
 =?utf-8?B?eWJzZmpKRXlHc2p1QXkxVGhCbm5NUGR4TTlxcHgxb3ZadUkveDJrc1JlTnRN?=
 =?utf-8?B?M1ZRWTUvQWx3aFlzVnhCSURycUZZVTVvbzNHMXk5dC9XMGhnNFRxaVRpS0tQ?=
 =?utf-8?B?bUVMU1F5RnlXNWducFBMRlI5SDJvaS9vR2I2MmI5bkdnTWFaYXl1WDU2VzRz?=
 =?utf-8?B?WHQxdnpyQ2tmVmdvOHROb29oSXFTT2pGYnZDNmZjdVVSb0RMYlAwU0x6eXJP?=
 =?utf-8?B?elBUR2c0bnd4cWRkSlQvUk1idjVndmZ1WjVVUjcxT3hlUE1GeXF3VTNLcnBz?=
 =?utf-8?B?akV3K1JacUNxY0VjZnJ4clVVUTRvaEFwUFVFL1V6ZW1rSE9aSjNPTExhVEI3?=
 =?utf-8?B?TkdLWmhJSW5qSDJzQmFqTUxyc0tNVmcyc1lYRWpSdUo4TzZ6elFTa3RyV2dY?=
 =?utf-8?B?M1JNcGlHbmtzRDhCQU02L3dWeDlycmo5Q2RJNGRlTWdYWGpOWlRhaUxVOGk0?=
 =?utf-8?B?SkR6VzB5dFlYTExONWxaSENyTDVPWHZYWHpQUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUNvcW9vZHI2WC9mTWFPaEhhSVR3ZG1QZit6VkVxUGNFMkFrZWE0Uk1GbUsz?=
 =?utf-8?B?UENIeEhYMkRWUW1RdTArRnV2dkxjQVNIRDhPYUw5V2xUbTRrWkJvRTk3QzRr?=
 =?utf-8?B?VVkwczMxRXpKaXdXWExMYUZITUppMkQrL3RFVVpkSVJkTUQ4M1pZeFRwYVA1?=
 =?utf-8?B?eDlpbE9uQzlQdENhaDJvM1JZMFhVTGJ5Z1hmc0JWcVE5T294Y0xkMkRGb3JG?=
 =?utf-8?B?ZkJvcjNnY3BIdHhCSytrZkwzMHN3dElLMDFHZERLbXRrajBFSWp3TFNSamdW?=
 =?utf-8?B?NEV5aVFhTzJ6bzdYRjRSMEhtSnFiUU4zeFhoN2lRTTdBT0xUSy9iZHlJOFpM?=
 =?utf-8?B?OEVuKzJSZmU5c2gxZ0tLNG9UdGNyY0NUVk9LcndTVnI5dVJha3NhR0JKcWpE?=
 =?utf-8?B?cGloclB1azMxQmNTV1RpZUVhZVc3QWNVTEN6T0pWbzZLMzZzZDFCVXBzSkRE?=
 =?utf-8?B?WGtFaTIyNlN1SCs3WUJndzk0M2Vnc010N05Qc25ZODl5OUJzQUV5bWQ4T2I0?=
 =?utf-8?B?NHY2cldOa29Lc1JraGpBV0dkLzJLL1pmdjd6dHkxZ0JJdVlEb1ZkSGdiS1VV?=
 =?utf-8?B?Q3pwZU9YeEk5SzY4b3hTeVJCT3VHVlRLclZuM2taWTlhcXN4OURRUlFVWk1E?=
 =?utf-8?B?dm81QkI4SkJBSU4ycjAxenNFT2FsQmdPb2czby9jVHFHWGpPOXFFUE5NR24z?=
 =?utf-8?B?OFlwZndrZGZQTUIxUGI3QUR2MWVxT0ozTzNZY2RwSFhSUkFTeXdaTXJMNDJW?=
 =?utf-8?B?Yy9ZVDZ0dlNBc3dLSG5yZEJiVHQ0ZUJvMkZoZmt3WHlYWURDeVM0bWNKOTFY?=
 =?utf-8?B?OE1QdDRhajBHSUpXcFhvM29CRFd1TlFNdmhUempxa3Vac0s3K1FrT2ZTWW9J?=
 =?utf-8?B?YTFNRjRxNUJCeVIxenZKYjh2bU5jQ0dUZHZDWTVyb2hCSHVjSUR6RHNQc1ZU?=
 =?utf-8?B?dUMwREdURkJBcVhGd0l2cm52TUl1Zkx1QkJZdEE1N3pxWGh3STVCZ0R4QVFj?=
 =?utf-8?B?ZTBuWHpNbHc5SzNwT3NibmNoS01FdUMzMHYxZmdiaFNUWEk1Qk84RUV6aTBX?=
 =?utf-8?B?MCszOWt5emxhaHpXMGY5bnNNR2xkUGlVdjhBTHhnUWt3c3g3TFJCNzB4NjFL?=
 =?utf-8?B?cjBOUzBrZnpkT3c0ZWxXTnN2SkxzaVhwYXU3Nks1WlZ4RFhac3JCaWFodnBY?=
 =?utf-8?B?YXpwQ2hIRHl3SUdPbUxmSzI0UDd2c3lwT1BlQUFVUStYZHZWUWhwcVlrWElh?=
 =?utf-8?B?ZnB2WjZzemFrZFNsbWdpb0NxVHBxL2FwVXdEamFjSExFNVV5MUJmUEdZSVdk?=
 =?utf-8?B?cExQUllyMktqeFFDVzBuNDZhSExsNFZMYVl5RXlBb3VDWnA0OGx0cVBKNmsz?=
 =?utf-8?B?ZnpydWxFWVFzNldGYlZ6UmJWNCtEVmowOEN5UFovNDNjL3UrNVJJWW8zZ284?=
 =?utf-8?B?QkZuVm54ZnU3VW55SERoQjVyeE9ESVFiZ09hNFNueXhZSjAwSDhmNEs1dXdq?=
 =?utf-8?B?NWlhbmhRclN5a2dKT0VPR05uMWZSaGMzbGZLWjJGdTlvSFg1Z2FBOEZBRXpl?=
 =?utf-8?B?VHJQdDJmWGdZdFVvd0pwT1BSWi94MDNZYWhHY25rL3VBNmFjalBkQnNnOGJJ?=
 =?utf-8?B?V1hrV0ZKTmFRanhCZDk2M0NINUVlMkYyS0NvTHBxcXpsZ094eUVVUEI0TlU2?=
 =?utf-8?B?TnJZbUhYUXJUMTNQNEo2ZytWZ2NVbTNxcGNGdkxpTHVpK2pPTnIvemgwbnBZ?=
 =?utf-8?B?bzVZTUhqM1BIZHVNNHNJdHVpTXR2OTdqS05qaXpoVTFRbEtNQ01iYTVsV2tF?=
 =?utf-8?B?MU5yRElSS3RpWDNCVmJlTTVkSXdJSGpkd2FMR0Q1YVlVNFRqN1BqVTl5TmJL?=
 =?utf-8?B?a2VoZG03aTBaS1lZamx6eTYxeUNhT0RFUnRiVjF6YnYzT003SWRCYkRuUmha?=
 =?utf-8?B?OHdHT0JTYk5zTis4by9URTFSK3VuOTNvRFh5MDloclIvZzE1cWRZcXlGeGdo?=
 =?utf-8?B?TjlUMWhISkwxc0F2eDl1QXBXQm9nNi8vRkhSbWxqU3dsd1RQa09ETXUwTCt6?=
 =?utf-8?B?dk5zTmZFSHowV0pIUU1FLzZRVUV6V1pzRGF5TEJERUlodExvUFNVckkvaXNh?=
 =?utf-8?B?ZCthMis5VXNjTiszbEl4dkJvblZPSVVTQ0FoZTlyaTJURm53bEhKdko4YlZT?=
 =?utf-8?B?YWpldDJKR0QzRlYrQnVBck5jdnRBSTZUcXRiS2l5cHI0TzNiOFBKZkJrTXN1?=
 =?utf-8?B?ZXVkWXZhc1JwMXAzQzhFY2NPL2dDZFRJbUNJOTRndXhacUdxS2xGYjVhSzRV?=
 =?utf-8?B?RmJVdlptMVNaVWZsYWVGTy9rYlQ4cmpnSXpqVkpad0M2enpTUnhXQ1pFc3Za?=
 =?utf-8?Q?3Yw13dElN+Pcf3mM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D739CB0FE85BD94D9E6D5EAE801BC572@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad21c466-c3ac-4976-01ff-08de52750861
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 07:26:13.7810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t5SgdEh8usJRbkbCDy6flRrya8fKSY8Uf7PywTOlNY/+41haqvegQxL6xHkJNxRSB5C5o0EiNU+FBoP176r7wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF5DE123533
X-MTK: N

T24gTW9uLCAyMDI2LTAxLTEyIGF0IDE2OjAyICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gTm8sIE1lZGlhVGVrJ3MgcmVzZXQgaGFyZHdhcmUgaW1wbGVtZW50YXRp
b24gaXMgbm90IHRoZSBzYW1lIGFzIFRleGFzDQo+IEluc3RydW1lbnRzLg0KPiBJdCB3YXMgKnZl
cnkgc2ltaWxhciogdG8gVEkgaW4gdGhlIHBhc3QgKHllYXJzIGFnbywgYXJvdW5kIHRoZSBNVDY3
OTUNCj4gSGVsaW8NCj4gZ2VuZXJhdGlvbiB0aW1lcykuDQo+IA0KPiBNZWRpYVRlaydzIHJlc2V0
IGNvbnRyb2xsZXIgLSBieSBoYXJkd2FyZSAtIGlzIGRlZmluaXRlbHkgZGlmZmVyZW50DQo+IGZy
b20gdGhlIG9uZQ0KPiBmb3VuZCBpbiBUSSBTb0NzLg0KPiANCj4gUmVnYXJkcywNCj4gQW5nZWxv
DQoNCkkgZGlkIG5vdCBub3RpY2UgdGhpcyBjaGFuZ2UuDQpXaWxsIHlvdSBiZSBoZWxwaW5nIHRv
IHVwc3RyZWFtIE1lZGlhVGVrJ3MgcmVzZXQgY29udHJvbGxlciBpbnN0ZWFkIG9mDQpUSSdzPw0K
DQpUaGFua3MNClBldGVyDQoNCg==
