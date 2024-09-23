Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D2910F9;
	Mon, 23 Sep 2024 07:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727075218; cv=fail; b=tI0ExalPUluXafPnUaEXs/QGK5Pk5LJm4uKITpWjEY3T1egvIgvH6KPh/MS8WE8DpINrMfia3SmahcDKBCWn+zmHYMFJPnz26zqidQR7WgrI66Ts//yq3Uu/DDzEmq6P6DoPA8DnHNWOe/k5QUwibjCeBwhrI/OOMF75K+k89nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727075218; c=relaxed/simple;
	bh=2TILFndVBthTIKxu/YrAS50m8e5azpcYd66RiT08AjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FGji44YntAvt0pR/PxuSOGrEx9gCNyJ9GcW1JYpH2Y7KHKDmNJ/1/CEA58pWRw/8N/P7nqumvqSVz4OSXJ33at8wH2nlFHKJ+0JtBTihdU4o+IpHoaOxbToWf3UQOU8DS5dtM5VawXoPUc7lra9nIOgIgr6mLsJrwbCavkBF57U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=k+S0uido; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=dq8cx4ow; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="k+S0uido";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="dq8cx4ow"
X-UUID: 62d5dbfc797a11ef8b96093e013ec31c-20240923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=2TILFndVBthTIKxu/YrAS50m8e5azpcYd66RiT08AjQ=;
	b=k+S0uido0DFY73Jke4s8nLMcNsN3E7fongDiYJCn2fr2iez6CgX8/W7ipFGLsbWuLPu7iBV1JNycRQGBf3pySucYXKsnSwyRiQGE+ddnINUNY53z6SWI27Rv8PZp28VNQTglf0KQfuYz4J5ALKNho6hFQ6klTd9kaquybka+poU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:ce9f405a-3277-476b-974e-8587ce262021,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:646a9cd0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 62d5dbfc797a11ef8b96093e013ec31c-20240923
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 681640142; Mon, 23 Sep 2024 15:06:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 23 Sep 2024 15:06:41 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 23 Sep 2024 15:06:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZBGBqDmiWIG51kIf5SCLWtBj79UnHfQ6pGBYrAmowAZZ05ndHefEQy5gs8W+YeXrNMMIgmUSV6mRT4NumYyYlJcbvuokbRB8ommizocMkYJkYszMi5Z45eLYp8o7CWbYEmZxjjkMDSNuy4Ik2M2upM9u88vHm616wcYNzsk/sRJbUOVUTDLQyti8UtuW6VfTGfdGF++HKZBmHXhLeZC88UAVjNd9gdVk6ZEguqbLuRnp9yKCBhWApPdm1HFcjAQA3edQmNGtaAcvY+joTzRI2pVhdAq3n8KgNo5S3U5fno8s5oZbZ/ErRSaHW2H45WR2m6SfHsOzmY+XQOEdR0MjUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TILFndVBthTIKxu/YrAS50m8e5azpcYd66RiT08AjQ=;
 b=QTI8nHk80rrOYAen8fmxFAbnZmWpK5EWpikKaZ2OtPCbcOURnk3Q5gTS99XNpQisew+maJ8YRmH+q0RjDYCAlTXiTnBcZYDPYE/ObWgnpiCf5GqM+I2M/sY/z2quPUfMbYD1Ivw7Jax4JA7mewhvwWR/Oy7gZV4A5bIx5zblQOzZY5y5KNo6q0AE+A/nkBK24qHoqL8u9RxDEhv7m1r+ZNp+QNXhHg5TIZDYQuWkpZUauqtb9xuup3Im6vr3GKXCyJDYbA3DBZmZUosueV3XV+kFK9sKPcPpSo5gQ5R6oSTa/pAAokKhHSQ6Cj36IU2qaIZTVO2uKp0HSMlwNF7RhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TILFndVBthTIKxu/YrAS50m8e5azpcYd66RiT08AjQ=;
 b=dq8cx4owPf4NEz3/9Jul2Nktr8dVFrtvPUhcMPWpD8kmf97Hvl7omTdCuq/ukbkRmcVQTREBAokaNxbsIos6lauZ4DEopj2iVD/lvNgguhLuWF/ICnc3Rd7xeJKf+DUBrXqe7llrcBm+5t9VnRXDv9ROcBBzldYF+k0oPm2XISw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB7264.apcprd03.prod.outlook.com (2603:1096:4:1e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 07:06:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 07:06:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v4 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v4 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbA1N1RX6n4EeryE2vN/rAxATc77JRT7iAgADKYQCAANwoAIABMz2AgACCMYCAAKWTAIAAsGiAgAeVY4CAAFOSgIABKiyAgABt5YCAAHjPAIABFpyAgAP1gIA=
Date: Mon, 23 Sep 2024 07:06:38 +0000
Message-ID: <bf4ae4a400365d14c4194f2f6ffb318cb04184a2.camel@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
	 <20240910073035.25974-3-peter.wang@mediatek.com>
	 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
	 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
	 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
	 <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
	 <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
	 <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
	 <46d8be04-10db-4de1-8a59-6cd402bcecb1@acm.org>
	 <61a1678cad16dcb15f1e215ff1c47476666f0ee8.camel@mediatek.com>
	 <78c7fc74-81c2-40e4-b050-1d65dec96d0a@acm.org>
	 <f350a1dee5a03347b5e88b9d7249223ce7b72c08.camel@mediatek.com>
	 <beeec868-b4ac-4025-859b-35a828cd2f8e@acm.org>
	 <4f9e2ac99bcb981b11dc6454165818c5de6fd4d6.camel@mediatek.com>
	 <ec301d5f-cfee-41ce-ae1a-5679b2da2cce@acm.org>
In-Reply-To: <ec301d5f-cfee-41ce-ae1a-5679b2da2cce@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB7264:EE_
x-ms-office365-filtering-correlation-id: 0257eb91-06ae-4cd7-efbb-08dcdb9e44b1
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bVlybWdNKzZIaTdaZmRXbWxxUDA4dGp0YlduUUpLdDJqTVNTNElkdTIxN2Vl?=
 =?utf-8?B?WVZVYk92NVpsakN3ZXg0eTIvbHYyenRLTzFRakhuSFdhckxwRUdQWUl6b1gv?=
 =?utf-8?B?d1pMajJwOG9PU1o1b1ZJSU5qeE9KN1p3SUNRUUZtazNINGFOVkRaNy9iQmZz?=
 =?utf-8?B?eHN0WUE5d2J5aG5rNFh1MFV4N3lMcy9FRWpXMHQ3TWpIRzgxVnNDZVpRYWdI?=
 =?utf-8?B?MTFvKzkzQi9tQ3R5L3VhWEtNeXEvaTYzVk4veFFWWmJ6Z2JkNlBVS0p6WkhW?=
 =?utf-8?B?L3JHN2lzS2ZtSFFsamZ5SktPOHlzWU43a0dFclFPN1BzQ0tqNlZVaHRIbmhP?=
 =?utf-8?B?YU9VYm4yOVMwVm12dmFISU5oRjhNeTRGajR2TkZiOEc1bUl2elVjd0Z2ME1I?=
 =?utf-8?B?TFhiRXE5d0ZUSXpYOTBZTmhLT05OTm1lYUhQSmM0clBUdCsxRmFUUkhDYTJV?=
 =?utf-8?B?ZVEwTjFra0w3ekJPMUFmaVlBdnd5OXh2eGhWQkF3QWdjM284MlFNK0ZaVFQ1?=
 =?utf-8?B?OC9tQ0lJbGx5V1J3aEhIUk9sZ1NiYTM2Mk41ZWRxbDQyNG9sMk5udm5xMXli?=
 =?utf-8?B?Qll3eHJkTnhhUGFzOWdNeFBOYlRBNDhCUUNPQTZZNitWY0lSU2lmOEY1WXhq?=
 =?utf-8?B?bW1aVUd1ZFg1NFVhY1NidjJka2NDSVpadU80UXJSeXJTSDlGWEN2YTZ3Rmp5?=
 =?utf-8?B?azNRV3k1U1dKVU5wR2s3N1NFajBXZ2RxUi9OQWNrVGRodDRyZmcwN2FLamtV?=
 =?utf-8?B?SEZsblpTaWFFdjBzOFo2MkpNeC91SFdrdmNmUmNXS3ZxcGIxTVcwU2hjTnlI?=
 =?utf-8?B?NGRkU2dNMlZPbmNSSHE0MjQ0VlNCaXp5aVRhWlVITEJteXdGZWRlcGMwazRL?=
 =?utf-8?B?NmJLTWVNdTNoSFNCbG9FK3BUbjJRQWtVNEwzVlZ1dGJXT2hkVk9PYVZVazhs?=
 =?utf-8?B?SDRIU2Z3SHZoUVFONStSVjBEZHNzUzZzOWU5ek1FbjJoYTB0TEtPYWNiZ2s2?=
 =?utf-8?B?Yk1VbklrRElOcTFWeGdTZkx3VVdFS0I5YkVwWUVwRFBBNVEzVkpkTE1nOUxi?=
 =?utf-8?B?d2gwb1VvTUNhTktWY3hEOVpidllaZllhRHFHR1IzZENYZTV0VHo3TEJDRlVK?=
 =?utf-8?B?UEVMUmhDOE9MdWM3STNpZlJSdFpYWERqZHlhRVF1SDV3RXl0NjVDT2lHTlhP?=
 =?utf-8?B?TnJDb21xb1lrcmtlbGhVMlcrdE43QlNWVkJMUDBGUmJQazU4UnpQUnRTKzF6?=
 =?utf-8?B?bzFBclorQjI5NHZDQk9iaW50Z3Z4NmZUSkpyKzBrOTN0WExvOWFTalVPUFlJ?=
 =?utf-8?B?OU9yOE5xNkdoUlhqbUxOVTRod0R5RFhMbi83RFVBL1ZvOVI5M1FqRkxNakdr?=
 =?utf-8?B?ZW5mL0FqSEY3elo4bFM3SEN5d2IzOWpIc3QxZDlFUXo1WCsyQXZDNHRDUC9Q?=
 =?utf-8?B?bW5MVktSUmdpQkM3R3R3TGlTMUhPMXhsZHMzTmdSdG5vWUdMYTBkekwxQU42?=
 =?utf-8?B?eWRpYk5mNUZPRExER2tSODlwWVM3QWZkM0lKcHhnaFVHYTd0RkY5bmlkSEVx?=
 =?utf-8?B?Rzh5Q3E4MEo1U2RPU2NZQ1FSOW54RFd1b1J3QU9aekY2T1I2L0Q2OE1uK0FX?=
 =?utf-8?B?MXRaNUc3anE2K0JtQU9qUi9kb0xDS2lHaTk3YlpwQzJHdTh2VFVWZVlkd2pT?=
 =?utf-8?B?WTZoT3pTS1NHNlZPbFgrUzdLRDVlZ1N0UWJIVWd4dVF5S05XSlZwOWFlOXEx?=
 =?utf-8?B?MlR4U1JYb0RVd1JIRGp4UmZIcFkrTGpkRGVUYllnWkxxdHVHbktxc05oeFZ5?=
 =?utf-8?B?d29BZzh6VUUwQUFwNDZZdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2ZSUGt0MUlmWUcwaER3NE1PNWREOWU4M2RZb090Yit6SlZ1aHp3cTZVUElB?=
 =?utf-8?B?WjhRa0Q4SmtrYlQ2MHZFTjlUaGZBWVZ1MTBJVWlvVzFORWQxZTQ1RndVNUNJ?=
 =?utf-8?B?SHNaUTU0Nk5VVTcweS9yekxQVnB5KzNrZWE5ck5kb0xPMXkxalBhLzl2MVZQ?=
 =?utf-8?B?QjNKTFZWU0FBMXU5ZDBMWGc1UTN1c2FvQVErVXpnZElrY0JRSHIxNXRuMy9m?=
 =?utf-8?B?TlJLMHlUV0xtRkdtcGwwQnV5VHA2enJKbGREUHg5MHBPeVZUU1RQNEErU2pm?=
 =?utf-8?B?MzA5dy9uTEh2bWZBWFdYNHJMZGZpRGt0dHpnY25sbmEyYjVBWFZTQnF5ZlZX?=
 =?utf-8?B?Yk1waVpVQW55NVZianplZmpKRmtKemUyRXZrRytIU2FuZUhNUnZVWStENVJR?=
 =?utf-8?B?a29wN1hZWFlWNUM3UlFETk12ZE9MeWlFU3ViU3JMdGxGL25HSzlpQytDZ0Ft?=
 =?utf-8?B?eXpLK1RiaTRSNnRFVkN3TitXaysvUlllS1JGK1JHdFNzYXFLQ1puUGhwVm4w?=
 =?utf-8?B?Q3NPWDFQdHY4aDdXV1RoYWdvM3lXUkpWY2NFUUJhb0NmTXVjMHd4UWdoL2tH?=
 =?utf-8?B?YXRVOTIwUSsvbTlTZjRqaHB0U3lNYkNFclduOWsxYlo0NER4cm9KVHFNL3hi?=
 =?utf-8?B?SUpuRVI4SUhVTEZFZkVqQ0I2V1dVTWxmZGtRR08zcWx5L2ZseGlEREd2WmdL?=
 =?utf-8?B?YkN2bE9FdFpXSFNyWXJQY05Dd2hUYUYrRlEvcm5MWDRBMWVqTkdyMEtaRGlF?=
 =?utf-8?B?T2VkUmpwTkh4Z2x6Uit2cWFJcVhQcWdpZHNnaFgxUGZaV3RSK1c1Zm03OUJD?=
 =?utf-8?B?M1FRYWsrMkhaRmUyVTNtOWp3ZUcvMHZONnJrdnNhVnVuMTlCQ2VsY2hKQTYx?=
 =?utf-8?B?RkJBUEUwT25MVjZHeVdWOE9jMWJ3cGx3VUwxNVFXRlowK3VQZTExbHJkbUwv?=
 =?utf-8?B?NXZaVmZ3UzdDTDU5Q2FXcXpTMy9IaGJoamk5UEJ5UHlwalBMTHBPTWZTUVFa?=
 =?utf-8?B?MzFOYlRZaWx4WWZOWTVGRWgzRFpZdWthM1dSbGRtQ3phRmxZVGVyUUtjZTZO?=
 =?utf-8?B?RU9rYUpCanJ5eWVKRGtzelhvZ1ZSRVhBMGFCUWsxSUZrWmZhS3FJYjAvYS9W?=
 =?utf-8?B?QlVPbFdxeTErdy9EZkFxWWZLOG9qRFBySm93MUhEaEdXZmh0cDBrR1VIK21E?=
 =?utf-8?B?NEFWNjdvRHBQeUFObzZlNUFNMm5ybjFmNHZIbkJaYzlCQjJBbmxSQVIrT0tI?=
 =?utf-8?B?SmRLa3hNZnBTa0FtL25QdTNDQ01IQWtvT3NqTTg3d0Y0LzlQVU1SUnh4WjhD?=
 =?utf-8?B?NkNKZlNPbzBDVVREV3MrL3h1VVBuRkdmOTJ3MkFCaTRaeG9FbU5CU01JaXc5?=
 =?utf-8?B?bndTaG0vOXhFenBtMGhicXFySlNwWW1DRFFzWTgvUGcxOWgyNU9TeDU2dkhR?=
 =?utf-8?B?cEhla1BYaTZibVBsRC9ZaUpYbDNpRStHajNwYmlKTU5oRzVjbWpDVndFbTBY?=
 =?utf-8?B?ejJtYXpEVzNPbmpGSnM5ckp3MmlnMmZIMWp2Smc1V2dKenNnNnFvd1ZudkdL?=
 =?utf-8?B?ZnZSTjQxMGZMRzljVXk5VXA3ai80dDhzYS90Ry9SYWx1c0pnSkFpZ2E0WkFJ?=
 =?utf-8?B?OU5XYzNQVnpQWkMzaTF4VjJSY21Ra0hacEx3MjNNbGM3dWxuSHJVRFhuQWNz?=
 =?utf-8?B?YmN5RnFaZkdvQjRNeTl0aG1yMDNRT2FadUlDVUxkMTExQ0VXWUJQU2o3YWVQ?=
 =?utf-8?B?d3J1QWplTmF3ZXk2eGIyY01hUDZ4bHNXYkJkUk1DRHhCbWJaUERZMitCZmdy?=
 =?utf-8?B?M1hTaC9wdlV3L3JMQTliOGpENlNwK2JYQ2o3WHFVNE5hWmZxTkRFUjVqcDJ0?=
 =?utf-8?B?WDVqb3orTFFiMHZGQUkrMnlHT0haMTNpNTBtTUp5WHZBaE1JaXdmWHM2cU8x?=
 =?utf-8?B?UnNRU3QveS9nS2pSYkhmZWlMTjhXcngxNEdjanFMYXcrTGQ2TTJjellET3li?=
 =?utf-8?B?eC9ZSTR6RkE2NlZPK0VIUERwVTNXZHoyaVpwVVlQQ2hSTFd4WHkyYXlIN2xR?=
 =?utf-8?B?bUw1UnhxeFgzdmh6RGpNUXEwME9PUU1uV0h3aFh6YS9hbE9RZitwcGoyWFN2?=
 =?utf-8?B?ZDNmZWRSN0kxTitMM29GYlRwTnFSSk9IOG5qNElza1RTR3Q1bHhXQ0pqbndl?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BE7B415811496419611852431F1691B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0257eb91-06ae-4cd7-efbb-08dcdb9e44b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 07:06:38.3182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xkLP+uTdEAQ/CPF/DJ1h975S0dEM9Np09XLWeNECRsLijz+mrePrdxRpnN2N4xEhGKHMu+Ik6hWn1zVcAUDvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB7264
X-MTK: N

T24gRnJpLCAyMDI0LTA5LTIwIGF0IDExOjM5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xOS8yNCA3OjAyIFBNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAyNC0wOS0xOSBhdCAxMTo0OSAtMDcwMCwgQmFydCBW
YW4gQXNzY2hlIHdyb3RlOg0KPiA+PiBGb3IgbGVnYWN5IGFuZCBNQ1EgbW9kZSwgSSBwcmVmZXIg
dGhlIGZvbGxvd2luZyBiZWhhdmlvciBmb3INCj4gPj4gdWZzaGNkX2Fib3J0X2FsbCgpOg0KPiA+
PiAqIHVmc2hjZF9jb21wbF9vbmVfY3FlKCkgaWdub3JlcyBjb21tYW5kcyB3aXRoIHN0YXR1cyBP
Q1NfQUJPUlRFRC4NCj4gPj4gKiB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCgpIGlzIGNhbGxlZCBl
aXRoZXIgYnkgdWZzaGNkX2Fib3J0X29uZSgpDQo+IG9yDQo+ID4+ICAgICBieSB1ZnNoY2RfYWJv
cnRfYWxsKCkuDQo+ID4+DQo+ID4+IERvIHlvdSBhZ3JlZSB3aXRoIG1ha2luZyB0aGUgY2hhbmdl
cyBwcm9wb3NlZCBhYm92ZT8NCj4gPiANCj4gPiBUaGlzIG1pZ2h0IG5vdCB3b3JrLCBhcyBTREIg
bW9kZSBkb2Vzbid0IGlnbm9yZQ0KPiA+IE9DUzogSU5WQUxJRF9PQ1NfVkFMVUUgYnV0IHJhdGhl
ciBub3RpZmllcyBTQ1NJIHRvIHJlcXVldWUuDQo+IA0KPiBjbWQtPnJlc3VsdCBzaG91bGQgYmUg
aWdub3JlZCBmb3IgYWJvcnRlZCBjb21tYW5kcy4gSGVuY2UsDQo+IGhvdyBPQ1NfSU5WQUxJRF9D
T01NQU5EX1NUQVRVUyBpcyB0cmFuc2xhdGVkIGJ5DQo+IHVmc2hjZF90cmFuc2Zlcl9yc3Bfc3Rh
dHVzKCkgaXMgbm90IHJlbGV2YW50IGZvciBhYm9ydGVkIGNvbW1hbmRzLg0KPiANCg0KSGkgQmFy
dCwNCg0KT2theSwgSSB3aWxsIG5vdCBoYW5kbGUgaXQgYW5kIGxldCBpdCByZW1haW4gYXMgaXQg
aXMuDQoNCg0KPiA+IFNvIHdoYXQgd2UgbmVlZCB0byBjb3JyZWN0IGlzIHRvIG5vdGlmeSBTQ1NJ
IHRvIHJlcXVldWUNCj4gPiB3aGVuIE1DUSBtb2RlIHJlY2VpdmVzIE9DUzogQUJPUlRFRCBhcyB3
ZWxsLg0KPiANCj4gVW5sZXNzIHRoZSBob3N0IGNvbnRyb2xsZXIgdmlvbGF0ZXMgdGhlIFVGU0hD
SSBzcGVjaWZpY2F0aW9uLCB0aGUNCj4gY29tbWFuZCBzdGF0dXMgaXMgbm90IHNldCBmb3IgYWJv
cnRlZCBjb21tYW5kcyBpbiBsZWdhY3kgbW9kZS4gTGV0J3MNCj4ga2VlcCB0aGUgY29kZSB1bmlm
b3JtIGZvciBsZWdhY3kgbW9kZSwgTUNRIG1vZGUsIGNvbXBsaWFudCBhbmQgbm9uLQ0KPiBvbXBs
aWFudCBjb250cm9sbGVycyBhbmQgbm90IHJlbHkgb24gdGhlIGNvbW1hbmQgc3RhdHVzIGZvciBh
Ym9ydGVkDQo+IGNvbW1hbmRzLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoNCk9r
YXksIGJ1dCB1bmRlciBTREIgbW9kZSwgTWVkaWFUZWsgbWlnaHQgc3RpbGwgbmVlZCBhIHF1aXJr
IA0KdG8ga2VlcCB0aGUgYmVoYXZpb3Igb2YgT0NTX0FCT1JURUQgY29uc2lzdGVudCB3aXRoIA0K
T0NTX0lOVkFMSURfQ09NTUFORF9TVEFUVVMuDQoNClRoYW5rcy4NClBldGVyDQoNCg0K
