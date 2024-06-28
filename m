Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8CC1BF50;
	Fri, 28 Jun 2024 03:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719544400; cv=fail; b=hfQv4QJion8btopPpsm3rzrAkMzz7+tD9k92yboMSNquKrZewFrhGI1jxN0+tQZcOwl3p625jHodv0a5m93Cg8AcrN/L8wHiH4+9SsnjtVjTkrd3pRL4olyb/U7rojyOSuMYHMFsXRQmxeR9Mx93rQT8aToXx54OFL1iPzFVBDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719544400; c=relaxed/simple;
	bh=MWeHS26a3ucWrV9sGCeX9hciavJ0HImc2sEcFERNNWo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mpuzw3xFRDUT04Hufdkl9u9gUeS15dF0U174J9hSH9L2Yq8dQr8K083Zxpr9INYKVbi6zeVtdkDJXo6cYGXS9Pzu6B1XY3YSqdkU0I74irsB64PCPxuopKjlvqcz8h3uL1gLXFQkdvhnSVLh5cjrNLrRCCAV/FgM3jXvkzW6zDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rK2+QrAC; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=XtSlMMs4; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rK2+QrAC";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="XtSlMMs4"
X-UUID: 56a3b97a34fc11ef99dc3f8fac2c3230-20240628
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MWeHS26a3ucWrV9sGCeX9hciavJ0HImc2sEcFERNNWo=;
	b=rK2+QrACcclmYBj7v7+bWf2lgwHDUpB0kikph9GGdCmAUFDM66LdYSyOvYBM5FY9R61JUJb/2ASv3gIoM8+WCz1oDtPz5N058kktw7rt07liieVTZJjQ4PG8VbtUSybTka3EXB4IpYlxXWJi7ZBe7anCvouAY6znJ46LaxjMbYk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:24d4e013-260c-40ae-88d5-25924f52a607,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:db61b3d4-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:817|102,TC:nil,Content:0|-5,EDM:-3,I
	P:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
	,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 1,FCT|NGT
X-CID-BAS: 1,FCT|NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 56a3b97a34fc11ef99dc3f8fac2c3230-20240628
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1645672831; Fri, 28 Jun 2024 11:13:06 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Jun 2024 20:13:04 -0700
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 28 Jun 2024 11:13:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxayjuZyezWXkY0f6qDoXlvCQZGpzrsLFoZFXOLDDvauVku4Ra33nwdVukwCZdxLngh0vS01iX0BPCysRGsr0AYuAZTBdGyxzOT3UBCPqGka7HwPnAxXLvpGsrLAVmkATrrb2x1E0CddYb+b1vCoG7tl+DMg8nYJ/JWN3vx2nwcFCJX5LUFBejD0xjkmgWjQr2Co+wlLnORejvul3xk4BNxCBJC9ZmwjyEViz5JP2cWFhd4LV69/d5nmrXzE7LRloVF3I5cxaN9QIv6c8lZg7yzpKDgrMndJRjoat2bo9HKGbqIt+VQ6Z+ckSxoEmfgGojNrIpDLo95Ijymwtt2zfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWeHS26a3ucWrV9sGCeX9hciavJ0HImc2sEcFERNNWo=;
 b=jQYcNMzKejoLRPV/675GgtkuRsV0/h312zBtuVsWqVAwh4KczNZ8JXVN/3kHCDgTbA2xsTvdFUo+IAx6Otr/owdU8JN/+5ABKy2NQXZ3NUSN1gUglBY8zYaz8yxN6gT6z1pnm1/psof4XnmqE8J2j1d8bJai4/W+K/bXT7VN8+M1aI5oc3whuudsIok+LDUD1QwPY8hbQYiXOdoA4jhTix4+xG68Xn3Tj8d+NM9QOaxJrjJozgkGLz1lcvEfoqSGAiWrKDlotxGdknfcHipyXsXLOk6xK6YF6ory7TW6c0+EVR4+ctrhPJyMW8lAlRQQqHq729S4anVJUzSVHXxkGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWeHS26a3ucWrV9sGCeX9hciavJ0HImc2sEcFERNNWo=;
 b=XtSlMMs48UlGkVOipHwbqajuE9KbPX6K+gGwhvX7Teb1Uxr+zf63SfO5WJAVdjF87Eq1MtVTDP5ED9dowPMrKht9pEN43Wga36VuDwkBkts8mwCVuT8fjAVRIYr614G+KUFj4KQWlESXDPYjywtENyRoDJ4p4VXhnsVvYLiDoHk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7530.apcprd03.prod.outlook.com (2603:1096:400:3ca::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.35; Fri, 28 Jun
 2024 03:13:02 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.022; Fri, 28 Jun 2024
 03:13:02 +0000
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
Thread-Index: AQHaxi+9yVyGxDcFYkS8cVbs4SEa0bHXNMuAgADyXICAAInTgIAAvFQAgADexYCAAQ3ogIAAG+0AgACaowCAAHU9gA==
Date: Fri, 28 Jun 2024 03:13:02 +0000
Message-ID: <f3a8a0e2e224f58a852eafeacd06c4b8a46471d9.camel@mediatek.com>
References: <20240624121158.21354-1-peter.wang@mediatek.com>
	 <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
	 <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
	 <795a89bb-12eb-4ac8-93df-6ec5173fb679@acm.org>
	 <0e1e0c0a4303f53a50a95aa0672311015ddeaee2.camel@mediatek.com>
	 <b5ee63bb-4db9-47fc-9b09-1fde0447f6f8@acm.org>
	 <54f5df88-ca0a-40dd-92ef-3f64c170ba55@gmail.com>
	 <9284fe608d6a2c35e1db50b0f7dc69d8951be5fe.camel@mediatek.com>
	 <a34bcb63-6cad-4b77-bd07-afcc2c75b2f2@acm.org>
In-Reply-To: <a34bcb63-6cad-4b77-bd07-afcc2c75b2f2@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7530:EE_
x-ms-office365-filtering-correlation-id: cd55d9c1-8861-4e38-e975-08dc972038d8
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZnRxQWUrWTlmeXFqV0NBdHNhTzdJWXl6b3ZDczdlQ1RVd0xxdkE5QmFKTnZ4?=
 =?utf-8?B?OWp1elBSaWRscG5VZmZPQ0RQN21McnB5alBKdi9IVUg3WG9zbEcxT3ArRCtE?=
 =?utf-8?B?UTd1ZkZoUW1mVHNPanM3S1ZGUlRCRXNRamYvaHVQUDFTdXh4VjI4K3VaOTZK?=
 =?utf-8?B?RHFUcHdwMUVEZmlJZC9FN3VIMTZxd1lIa0pQc0RMRkJXYy9EV1ovU1JvL0xK?=
 =?utf-8?B?dDhMMTQrSUdhMEhYZFpaUktxdG55RkZ0RjNnTVQ4R3pWVzZaejU2Mmh0VSsy?=
 =?utf-8?B?ZWVIRnR5bXkvV21OTDBqU3VlOU5veVAydmwwcFZXNkdORG4xRXgvVnpqeXRy?=
 =?utf-8?B?YTRGR1Y2QWFuRDB0NEVjOVUzRFloZEFwR055b0FyRk5ZQU5sU3dHNVRIZk9v?=
 =?utf-8?B?eEFPSisvZ2tpb1dQZTB5ZU5VZHJVTGpqZHJEQTYvdkFzYjl4MG5yTE5lWVdk?=
 =?utf-8?B?QWtyWUc5SVBXNzF6MURob0Rub3lxQWFPdmFpWmVpRUtVZFVsb01SMEtuRVNB?=
 =?utf-8?B?V0svVksxOUdrWHM2MlpYNmE5d3dlaU9kMVB5SjE4ajdXUXdhaWRhb25xc1FB?=
 =?utf-8?B?Z3c2WmRMMkt1TGplKzdoSWFVWUZ2c3lrN1JLZWdzV21BRWJtWHJERE5URERL?=
 =?utf-8?B?M0xVbi9kNkU4QlhwVkozR3hra0k5aFFCMFUvbzBURURueWZmakh4a0NFN0dr?=
 =?utf-8?B?Mmt6dXR2aldxemVmQXUzOFpPdzFmdXpzUTd5c0NUdFcyczFZRFNpRW9vNEti?=
 =?utf-8?B?U1FWOVkxZm1US2RsbTREQ3BEVHo2WStjZE5ST3k0M0ZwVzRRZ1VEd3M3a3U1?=
 =?utf-8?B?NEFHaUNuVEUvKzVCT2JxaVVrdHljWmdkUmlvTFVzMVkwcjNhQjdBMDgzTjN3?=
 =?utf-8?B?OWd2L2pDNHBZdDZmRWUrMk5tYlhlRTdJdGJDZW1SSHBmdlFrNVFhUWt3dzhV?=
 =?utf-8?B?bDZmWWZSZ0tuZG1Kdm9EUFdKU2U1VkVrN2xTUFhBV2NrTDlxdzdwL3pKSVhK?=
 =?utf-8?B?TWNpVHp5T3lZL1FBMVhVMzEycVI3ZzcwMGZZMHhWOTNUbGFBUGVlWVUvZHFU?=
 =?utf-8?B?ZGVQYzVNRG9iQUR5bEU3bTVQSmJCN3h1QThNN29QZStaZzBjOGhCNHU1S0tn?=
 =?utf-8?B?TWJZUEN2QkR3Mkd1L09kQ3V3dngzL2lqN0crZzRvVEMvS0FTQmR5Nk9ZTHA3?=
 =?utf-8?B?Y2N4NEhxRmRCYnpxRklVYXg0ODZsaGdVN0JuM1BRd1lnVHFjeUdLODVKdGJ6?=
 =?utf-8?B?RGVVSGNBNFduZ2NCVjFSTUpZSXUvelBCM2xmaUJkNkxpOW5ReWE1dmFwcTlw?=
 =?utf-8?B?Mjd2a2VEaDBvKy9tQk40bHE5WTJiNGpUc0FsY0RxYkh6TU5oVmNjTy9hcksz?=
 =?utf-8?B?ZnhVNndWYU9JMm01WlJCeTdweVM0SVZITFJEQ0dXTWk3a2doMlV2cjVBV1lF?=
 =?utf-8?B?Q0lTNC9TaThjaFlWeU9FOWZiRkRLaWJtcjFEd242am42YklHTkxrUVpVMnRL?=
 =?utf-8?B?RjB1bGNqUXRMZjdMNUU2UERYTWtydU1qTkMxc1ozcVdPTkZwVmRwdEtVNXNV?=
 =?utf-8?B?MlNycHNhRlAzdW5nZVFUKzN1SGc1aWUyd3MwWDdGbGZiTUMzcU56WmFjS2l6?=
 =?utf-8?B?d2VPVU9EemczWVJrRC95Zi9YQ0hNUmZQampqS0V2em5Za3ZpZWt3QytPRDNM?=
 =?utf-8?B?WXAyL0lmV1I0UmgxcEx0b1dwMU9hM0hsd28vZGpZZHBhT09oMk95NnUwcmFs?=
 =?utf-8?B?Z3B6andZTFluYzExK3gxR05ucTE1LzlyMHRpWDZHdC82MXpkRytWSzUzYTBo?=
 =?utf-8?B?NzVjUHBWVzI5NkZLYU54bUwrSndTYVBxY2xaS3R6allxUjhwUmhUZ3lxVzh0?=
 =?utf-8?B?TW4ybHB3STQ5Uy9jTkpwc1JvdGk5dnZFS3Rza3RmL0JiZWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFNSaEF5ekhIZ1AweTlCMmp0U3IzT0FRbW1tbTN1THJieEE4Y1pNdTJmcXli?=
 =?utf-8?B?Sm9KZ3BkM0lKZWNWRW5JWHZmRVJlQ2VKRzRKaHdyYmFsR1orTGhYMnRqK0I2?=
 =?utf-8?B?WGhaY3BrNS9jc2JHODRHSExmUzB4M0xBTGJQUWJHTVZtSk8veC8xUVRTd0ZB?=
 =?utf-8?B?WlBPWjkydFBrSWN6RExuaDRNVWdZVGgvbVhGZjBOVkhkVHE4b29ZMGtjRUVD?=
 =?utf-8?B?TUhJM2F6MGllOVhza0NSZG5BMTZac1BVVHFrRWo2Zy90ZUdQaFZCQU54SXpN?=
 =?utf-8?B?QVdNL2hOZEVscmFpbXVERVFqVTNNVzhmOWdzRmtGQkVJK1JzWVRocDVKWnpp?=
 =?utf-8?B?eVFWRTgyWGlJdGUyS3VPclVhVnp1V1hjRWM5U1NXaDIzbjg0ODFHTnBSUmx4?=
 =?utf-8?B?YnV2TldPLzlBSmNGRUdDN016VFd4UTNOYWxTME5wNHVMcDJwWm9hT3hWclhJ?=
 =?utf-8?B?Y1F2RVRzeHpvMytDVnlVQ04yNUdDUTZXdTB2aDZHNGk3S0pjZzZGUWlOLzBN?=
 =?utf-8?B?QjNnZXlYZ095RVpYRzYrN2NqcmdqOUR1dDFOTVllMzllS21mWkk1TnYrczds?=
 =?utf-8?B?am5ybjk0bHFqRllUUHlQWVF3Q05GN0F0RWpPWkZiWEptYVJWRmYvSVhqbkN0?=
 =?utf-8?B?cnNnU1pnYlUxdUFlWW9qajNRQ2RhS3F5T0Uza3d3eGJFNXc4MGR6TUtNL01x?=
 =?utf-8?B?S05vWjZjWHh6eWlTcmJNVEZ0WjB3akNGL2JNemZ2TlZkVkppUlZCS0hzb3lN?=
 =?utf-8?B?TmZQdzRDU0piNUtiVDlXejVhMXIzeW16UVMyUzNCcFN0b25POEFVd3BwWUdk?=
 =?utf-8?B?bGg5djJ1dGJaUnphYU5zOURPcnQ5SzJ3RXQxUlkzVG5pY3luS2xrSXBXbkJZ?=
 =?utf-8?B?eVVZdFhTVWZoZ0hRbmxxQUxBMkJ2MHM3M0F2WlA2VlVpL055UHp4bmFiQ2lB?=
 =?utf-8?B?TnU0TDRTYWhnMzIwbVBWanFlMUFSSWhVWkFXcmhMM2hXekZndEF6Y2JHZXp1?=
 =?utf-8?B?MHVPbUVLM1JDRVBqN2xRaU9vaTI0ZFhseDFyTTRuL0pxeFF3MVhXQUxydE9w?=
 =?utf-8?B?ZFQyOWhpeHBzMGJuNjVPdGtjSHZUQ1ljdS9zdDJTazFRMzBQSmQxM3l6alZu?=
 =?utf-8?B?YUFxSE00S25RK0VrUVlJV0hwSzM2M2NCVkNVRC83VTg1ZHFyQjQ5cGtiVnlX?=
 =?utf-8?B?KzBYRldFQlJDVDBPVUsyYmI2Y2x3Zy85TG54ZTJ4aTRxMUFZbzBOaE81NHRr?=
 =?utf-8?B?NHNjV0NJR1VyOTNiQWNjay9qOFF6L3VtSGhGcDJqdG8vWDRzNWZ6RWtrdXN6?=
 =?utf-8?B?YnJCUXo1YzBvVkl5N0pCOWN6WTVlenFKQnBsKzNDZnJNbGpaRG5TSXJ1Q1RT?=
 =?utf-8?B?eWVjc0dLOGRCeGJHc2tEZUdmZ1djNlNyaDJhNXdSWWVPZDZJWDdXalpaRVpq?=
 =?utf-8?B?dmFNaFJTU3V6NkJlZjBMcUMwOXJrenhTWGtjTDRYeXZqU0d0NFk2S1RJVnR1?=
 =?utf-8?B?dHRxMVluMUpnM0tFclI2eFdxWTVMNmFXS1Zsb1lrMWROYlVHUjdPWGdiRXRs?=
 =?utf-8?B?UFFZVG1VK0swaUdNZ010MzhTOWk3bjFXNk5oOUh0cjlxYjJvQ2srRUo1QUJi?=
 =?utf-8?B?bW1JYkVGKzJsUWZieVpuOStweDdSTnYvMGFKSXB5K25abkdCMEJWZ05ZcnBZ?=
 =?utf-8?B?a1ZRWUNLUWlBMzJtODNiVUYwY0gwMGt4ZUR4R3FNbzhlekZEOEhnVTNLK1ow?=
 =?utf-8?B?ZDgwODdTMEVlN01LaEJ0c0dnbFMrZ1k1Vi83MXlWYjdPVEFEbGVrbFdUWWpu?=
 =?utf-8?B?ZlNaWWdPT2RJRXd1Z0RFSmhsbnRXaXhxNGcyUkp1dWNuNHl3N3lTbGd1MmIz?=
 =?utf-8?B?K0xOT0xtY1d0dHNFeUwwMUU5QzNnSjBWMjRxRUhJTjNQMy9tS0dSaVJsaVVR?=
 =?utf-8?B?OUFUNFlnTjhZdVVwcXpNcDlnWjByZVYzZEYxZ2VsWU9sTVhMcXVEUWx0RUgz?=
 =?utf-8?B?QXd3bmVKMldPcjQwT2VWWWRjMHBqeHZXeGtkTVRhNTExQi9rMTgyWnlpdWds?=
 =?utf-8?B?QXQ1b3ZYNTdscHRWUnZISlU3cHppaTdvYjJiRXRqZ2RQa3JGV3ZyVmh5dWxa?=
 =?utf-8?B?cFMzNk9iWDFLNnljYWh3dkNGS2pCNks0UmhwZXNhbEdoOXNQT3NXNllVbHNu?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <607F51364FB36A40AB067D8CF0FF0830@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd55d9c1-8861-4e38-e975-08dc972038d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2024 03:13:02.7831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SfI3qRhy3M9c2nNHCK3MafBj3tDNjJ3wXgZdFUAWpervzFT/Y9v2YjRwcz9jQ8yM1Hq+QssOnLICkSAHjEj3ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7530
X-MTK: N

DQo+ICAgc3RydWN0IHVmc19od19xdWV1ZSAqdWZzaGNkX21jcV9yZXFfdG9faHdxKHN0cnVjdCB1
ZnNfaGJhICpoYmEsDQo+ICAgIHN0cnVjdCByZXF1ZXN0ICpyZXEpDQo+ICAgew0KPiAtdTMyIHV0
YWcgPSBibGtfbXFfdW5pcXVlX3RhZyhyZXEpOw0KPiAtdTMyIGh3cSA9IGJsa19tcV91bmlxdWVf
dGFnX3RvX2h3cSh1dGFnKTsNCj4gK3N0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4ID0gUkVBRF9P
TkNFKHJxLT5tcV9oY3R4KTsNCj4gDQo+IC1yZXR1cm4gJmhiYS0+dWhxW2h3cV07DQo+ICtyZXR1
cm4gaGN0eCA/ICZoYmEtPnVocVtoY3R4LT5xdWV1ZV9udW1dIDogTlVMTDsNCj4gICB9DQo+IA0K
DQpIaSBCYXJ0LA0KDQpZZXMsIGl0IGNvdWxkIGJlIHdvcmssIHRoYW5rcy4NCg0KPiAgIC8qKg0K
PiBAQCAtNTQ3LDYgKzU0Niw4IEBAIGludCB1ZnNoY2RfbWNxX3NxX2NsZWFudXAoc3RydWN0IHVm
c19oYmEgKmhiYSwNCj4gaW50IA0KPiB0YXNrX3RhZykNCj4gICBpZiAoIWNtZCkNCj4gICByZXR1
cm4gLUVJTlZBTDsNCj4gICBod3EgPSB1ZnNoY2RfbWNxX3JlcV90b19od3EoaGJhLCBzY3NpX2Nt
ZF90b19ycShjbWQpKTsNCj4gK2lmICghaHdxKQ0KPiArcmV0dXJuIC1FSU5WQUw7DQo+IA0KDQpT
aG91bGQgcmV0cnVuIDAsIGJlYWN1c2UgaHdxIG51bGwgbWVhbnMgdGFnIGlzIGRvbmUgYnkgSVNS
Lg0KV2UgZG9uJ3QgbmVlZCBjbGVhbnVwIHNxIG5vdy4NCg0KDQpUaGFua3MuDQpQZXRlcg0KDQoN
Cg0KPiAgIH0gZWxzZSB7DQo+ICAgaHdxID0gaGJhLT5kZXZfY21kX3F1ZXVlOw0KPiAgIH0NCj4g
DQo=
