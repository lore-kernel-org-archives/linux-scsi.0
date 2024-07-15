Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DAA18A94D;
	Mon, 15 Jul 2024 11:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721044154; cv=fail; b=tW8+Lh8XVoPyg95SZFLJq4GmxCnZaJ2vdDhvURttrUfxpBb7zzi1aMfVqjdu63jPncnY9SEzhCAtkGFkqqE4kxeP2Gcvgq/9z+EtrRiDlSTmYWlXevj29Q0mP+ecCdCtP3HeBVTh06cHn+aPDKtZevQ3fOEhY1lnypR6QOkpkdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721044154; c=relaxed/simple;
	bh=YpFBHMt+Fy60xVzmDX/x/B3L94Xn711xzkI7n5vpra0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fvy+6rDXfmokL4WlbryKEYvp/rnYYaZXHDKWif48S+x0AgRo4bvp+xJbmsIF48xjo61if7bAlyx3qeQQhtA2cx2ymjdyr1IZHbxVG/GQdKMsMwI0pOZXaS91sUvQRkJic33Udh8jaTb2IVpoINSmONrcvZv5Qu4at70V4GJK8Ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=KTbtfbuw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YNes5VbF; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KTbtfbuw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YNes5VbF"
X-UUID: 39281ca442a011efb5b96b43b535fdb4-20240715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=YpFBHMt+Fy60xVzmDX/x/B3L94Xn711xzkI7n5vpra0=;
	b=KTbtfbuwtH8vrcoOkQobKhZ8gaEFB2WuPI3s0ZVmlXp166sRBpEJFpxSYezjaCIwY+hzQm96mjeTun3izLT4X0cOVJJB5W7WL2zqu+I/adiVO0RWEDyzzIFOJQu8VP7TFIc5svyAN9A5hM/XtNoDW2XYwOMHBL+tOro78VXhCH8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:75d8f15d-070d-4d7f-b76d-db86d77bc990,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:8e015dd5-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 39281ca442a011efb5b96b43b535fdb4-20240715
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1971042042; Mon, 15 Jul 2024 19:48:59 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 Jul 2024 19:48:59 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 15 Jul 2024 19:48:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HxGvj2UoLj5G6YaGT4wR8ULovq2CTUS4XlOuTpoYa6jYi4l25eXGfX2J3eb/kGw5iQC/4vPLm7XW1C2kh8EbD999z8YqT6T34ttwMidk5Xp/2scQpW/wIYnpXyRbcJ5t9nwet+QPLtJzLaUwfNc4JUYSF/sRSwr9jGG0F+HbbQOcXOSSjeFhs41FQTyrI+XrIBvjqmvXU7coFVzV2xUImPS8WiRutNo+oCLc3FM9nN0uOuvDtOknJQPPUzU0NE+IMhrI6NlPolJ++BQTVJ3s6d2BqqS/kGespCbOewFxG4Q/AH1ba8WlTR5LyLP7EvD9NtEWMWa3YKc/kvn7036Q0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpFBHMt+Fy60xVzmDX/x/B3L94Xn711xzkI7n5vpra0=;
 b=xIF72/Ufv0b3XrY786BoxMYMwyd/mTnX2jh3TqzCCXmQBt68DYRG74ZO7nxS6rNTxsCWygWmA5GrmhrlUQK77egxwt3aobs2gQ7FOayicp8ZBMqvZlRM8rnasb5mzXxMwkYY93yq4nsWQJqVip2TQgkm05HRBf4SmQMH8tG1IufZyVFpmjy6sQZB+0Z3ElYL4E98MqCcL27XgVPlUNyyUVIDbbXOoWplwkZ6gu5Vkj0vde/tk8cedx5Np+jEBTuBf3R1/Te8NqmBjAVADLMUppfE7XbQEt23b/fzSADKDbL8bfk8n6An54Pjz+fZ6BhPbNt0lEbONthln2hMqDFsfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpFBHMt+Fy60xVzmDX/x/B3L94Xn711xzkI7n5vpra0=;
 b=YNes5VbF718W294JV7rqmMkXSI+7MxHRAOXbVq8pCj2yDk8pGlTkPb8H0+TaWAwrpxVzXDqWFKHvcdNDfSS0a6zoToCx/XMVW+RFpqru9HEyxkrLBKn65e7w5X7H5g1kT5uhPPCN3o9xpxlDimSz9+rul/fpFp3D9WVDAS7qAAg=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by KL1PR03MB7430.apcprd03.prod.outlook.com (2603:1096:820:cf::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 11:48:57 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%6]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 11:48:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"huobean@gmail.com" <huobean@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>
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
Subject: Re: [PATCH v2] ufs: core: fix deadlock when rtc update
Thread-Topic: [PATCH v2] ufs: core: fix deadlock when rtc update
Thread-Index: AQHa1oGfHX9jD5TnakSNwh6noF9JO7H3iBYAgAAk2AA=
Date: Mon, 15 Jul 2024 11:48:56 +0000
Message-ID: <bcff11e743d564017787bfbe6e85a509576e8801.camel@mediatek.com>
References: <20240715063831.29792-1-peter.wang@mediatek.com>
	 <b547225a0315f1729c07a5d59f0db91c33af8e51.camel@gmail.com>
In-Reply-To: <b547225a0315f1729c07a5d59f0db91c33af8e51.camel@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|KL1PR03MB7430:EE_
x-ms-office365-filtering-correlation-id: faf9cb7a-cfb8-4420-dcfd-08dca4c41c08
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Vkw3NlBUOFRDTmc5NmYxbDhOaDRNOGM3dkZ2Skg4ZE9YTnRkNzZLVXF0eWk2?=
 =?utf-8?B?TDExRTV1R1RvWmU0ZjMzVXMzK210Y21HMi9iTnRxeWpjeTUvSWxFcXdGbXhF?=
 =?utf-8?B?enA3RXVjMzBjQnM1ZUhyaFpSbERkMksxeFUrYzUrZjBydkNwaDBYb0VHZ0N0?=
 =?utf-8?B?RmhhaWovaXFkakRPQXdIaUk5SkJjamgyS2M1U1piOXpteU1EMlYxRFMvbElw?=
 =?utf-8?B?akIyVEtJUUgyamFwT1ppWmdXR2xISUxpNXVCZDA1cG9HV0FjZFBMU1NlZklz?=
 =?utf-8?B?WTBSci9ORmdFKzdHL1VZem81RXJhSWtDTWV4SXg5NUpWU1VrcDVjdDY3eHF1?=
 =?utf-8?B?aHFFWWppNEE5V05zV3dPMUwzaDkrTVJaYWNDZTF0NjlQZ2RUK3YyVG5qbHpy?=
 =?utf-8?B?RTJJVjZFb3Q5bUtvNVUxSDZKSnFnNzJCSEtBZmxxZ3RIdEVwZFZsOTU3YzVI?=
 =?utf-8?B?RHRyNnVsbUFRYTZLbktUNnJ3ZlNobjljTzE1QXU2TWE3ak1zU1NPNVA1Y2Nh?=
 =?utf-8?B?S3hCRHREMFFoemg5K3BBR1J0c1NyRkg5anc1WTFFQ2d2elZQY0duNVRQMFZJ?=
 =?utf-8?B?LzBBVkpUdmgxVncvY2NWYkswajZramlqa0thWWtBOUpDOG9DSE9uMTAxem5B?=
 =?utf-8?B?VWFFUnlFSzkzeVYyNGVJUmFzeWNzNFMyYTNiWlpualprWks4NzRZV0RQSmVi?=
 =?utf-8?B?L3BXOVZPdklxOXNybUFvVy94dUVYWDBtdUU3djI2R2VSOENFdFN2VkVNQWpC?=
 =?utf-8?B?K0p2ajdkdkk3MjhYMzJQQU04T1o3Y0dJQmlNWU1PZ3hzRjYzeFJIUHR5U0Z0?=
 =?utf-8?B?ZmU1RFNHS2EydTh1YVcwTjZ1bFloY0txMGpaTXpJcXREeGtGTVdmYWJVWXB1?=
 =?utf-8?B?SWg5MStEcElEU2ZidlFNMDNHK3A1TExTZG4zQU42ZmplRUtqNUlvcC9td3Zw?=
 =?utf-8?B?VjFRQXA4bko3dyt0TVk4Qi9EVkFCR0d6QXBKUlJJTzhWWE9zaGZhTlV2Nk55?=
 =?utf-8?B?RFhsYmtVK1lWNzErWVhjWkpVQlM5bFQyY2VRN0QzRWpKcUdlZ2hXdXFxMXNh?=
 =?utf-8?B?YjZzSDQ4SkdGSzNWQk1iUTdJelF5N0hDTmg3SmZlYjV0aTRzRmJWaTJYSy94?=
 =?utf-8?B?cEVUYW9UZ29iZm03L2xWcmRLWkR2QWZuV1Z2QjlkT0tkcW5sdW1Ua3Q4bENE?=
 =?utf-8?B?ZWxqQjdrN28wZ0cyWS9rREVpNHNVYkp5d25CN0VOVkxBQ0tzUWNzcGVEdktZ?=
 =?utf-8?B?dGE1UGxXVGlYNDR0Ly91bGNCNCtkam9JSTdQcno4dUNBQVN0YWNQSE9hTjdM?=
 =?utf-8?B?cE9CZmN0ZXhNT0wzNTNYNUd6bmtQQyszSEZXOXROYXl4MjYwZlRNUnNhcE5V?=
 =?utf-8?B?TVlQdUFUNE5DM3ZYMzMrZWQ1OWI1YXNCeFNMS1NlM09SZmlkdjNjdWRQZ2sx?=
 =?utf-8?B?RytYdnowRXZmelE2NlRRMzhkcE5KcEdVVmFXQjAwQlVySlJXYkN3SENtMFg4?=
 =?utf-8?B?aWcxQmM0RHdWN1VlTVVDeG9ldFZPU0Nxamx4bEMwcnFuT2c5NGlvSXRSSzF3?=
 =?utf-8?B?QlpKcUs4K2M3U1VDbGJLVmJsNEtKdFladlQ3cy8xOUZ5bzlGRHVOdXllcFdB?=
 =?utf-8?B?UVM3S0lFTFVrZ2dpR1o2eGVIbjZVLy9YQXJ3bUc4eGxWejZqRnYvTHhhcTVT?=
 =?utf-8?B?VWVUc1BwYU1haW03cm1BVVZRZnUxVEl6anVHWTd4VjZ6ZURlc3E4WWRCRDdJ?=
 =?utf-8?B?cHM4Nkp5ZlFmOEdGMEM2MnoxNVpDalhyeGJqNVVXc2YrckRLMExUdU1TMFhK?=
 =?utf-8?B?ZHpUZXFYUXg5djNyZGNzTnF3bmZ3dWVhNmRZTUtqQmN3TEFWSnlPUlRLeEtF?=
 =?utf-8?B?ZExhZGRUVVRKVU92V2xTVitBSjFoNEs4L2ZBK1hXR0VidEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXV2N25mQmtCL1g5OFdUbVRjdm1aUUdKSlo1YmlVZ0w4R3VNcCthWCtoUm9U?=
 =?utf-8?B?czg2ZVpuN1RLRWVaLzF1SGNlRUFteDB0R0N6bzVpWXZ0Q3BKOW1kM2NnTWl2?=
 =?utf-8?B?R05Ic1RaOE9KQkRpS25kL2cxUFJ3cG5qOGxheU1hbzV1aDhucGJibGMyTlky?=
 =?utf-8?B?VWNoOG1DYUs1bGJCS2tuQVYvTE96cm8rU2JzcUZMQzJ3d2RLUEdVdWVBWXlK?=
 =?utf-8?B?K3NiOGlMbEtuK3Fxcis3Q1BQdERSNUliY1FmNERCbHkyNjQ4Vm5IQk5wRC9y?=
 =?utf-8?B?dzRSaG9rdlBDVmZycktkdkVHVjZYYTVZdUZmWS9BdVlpaFhOUVpVTFowN0pl?=
 =?utf-8?B?R0pHQ3JpQnVJbE1oMlBLMm11Wk0zOEVvb1h2Z2FObEhzSjVnRTMvYXYzN00v?=
 =?utf-8?B?Y3cvZkhZNmVzQXdkd2RzbEJpUzlkNlNIcnorRzJieVdNN2NpQUNkZ2pkMVkr?=
 =?utf-8?B?cGRpck16Y2tETzhLeExmUGw4Y1d4bkpaSWdlMkFNS2U4QStXSTdWSzZ1WmdJ?=
 =?utf-8?B?dnQySWpsU3hZSmp6WVBzdHpOREx0ZGQxbllpOWt0bnc3MVFyNHJPUWxrOWxk?=
 =?utf-8?B?WHI2TGJhcHBJdlcxc0k4KzhaVjVBRlpTU1NRYVNmMWxrbWpRcU9QRkkyU0oz?=
 =?utf-8?B?UTMra1pOM2hJTEJnU3JKUXhaaUM4OGRlbUdZSURvcHB4cURvUUIxdXhlN3pZ?=
 =?utf-8?B?YzVKTnJjMmwrWDBRamhVMU5UNEc3ckRJYjQwTnhhL2s5U3ZEUDE5SXF3MFc0?=
 =?utf-8?B?eHdsUGpUYnBQOVI3Ky90N00vN3RqZFZxQkczeHYrd2hYeUsyMVR3ZXJaTmpq?=
 =?utf-8?B?RkFJRUVwb3F5blY3a3IzWUJQb3NiVFY5bEcrVXNJd2hqVytHcW8wbUFXM0Y4?=
 =?utf-8?B?K3VWS21pV2Rkak5tazZhbE85S0wxZkoreWRIaXlZa01WMWowMXhXdTJPQVUv?=
 =?utf-8?B?WEZBQk1admI3QUlPWEtTZTBaMXVkQWU2RVpXNVQ3SzBBTlBwb1J1S3FzWkhu?=
 =?utf-8?B?ZllVRmxCR2VvU1h6bXVrakp5TUd1VllmUitPT3NxWk9VTWlVeWg0amRvNHUr?=
 =?utf-8?B?V0hwRGQ4QXB4REcxTVdrRExIR1MyY2hUL1d6b1pBWThjVk5TaHVUUnZJQjR1?=
 =?utf-8?B?OXNIbU9TSnhSTXhYTHRlRmN1eFpieTdnMU9EZTdaR0VlMUVEcUVnMWpSSldV?=
 =?utf-8?B?eDlHSndZWGtDTTkzUndGazFQbXFtdUhSRktjSGloZThMQW1yVDRLaG9kSDFm?=
 =?utf-8?B?YWNEM2NHaGNQUnFRK3JvT0M1Q3JRbFltT0NCTkhmRGxPYWlCKzJSeDZrY3JD?=
 =?utf-8?B?M09ZTUNvRE9GenpZSzlTRm5pcEJkMFRWWElZSXpoMDJBV2xpTWlTSWNBazM4?=
 =?utf-8?B?dzcrZkVVeXUzZWVEd3B0K20ybGxaQnJDa3lWVER6M09HWDZOS28wVjZ1dVYv?=
 =?utf-8?B?OG1vYUFSR2pFRURHS2R3blp1YVdzVk5jMkhsckxBbjA4cTJYN2JCWVFneUxF?=
 =?utf-8?B?T0NuclQxNGJyMkdzYzYwN1A3eDgzc0JzYUtMMmFhRFdsdnB5NVRUNFdWdGVr?=
 =?utf-8?B?REFnYzl3Vk1LV2RxMndwc2ZObHl1a0F4a1IrcEtlWkhPUkRMZjdIUjd5eWtl?=
 =?utf-8?B?U2JoZHNiMjZHZ2NLUFpHM0FENlpzMTZwQlVHVjRXcUFDT0VSWEVQd1NSY0ZO?=
 =?utf-8?B?alZLWU8vRDV5SGxGa1BVdjRpODhYdzNvVDVDc0hHVnV0UjZ1d3ZhV3ZLWUVN?=
 =?utf-8?B?TUVmWmxTWjNkT2U3bUpWbEFNNjQ1bVprbXdVbWNOOERsdjBBK0pxMWZkbkpQ?=
 =?utf-8?B?L2h5QXVQMUx3aWl4Nm45dC91RW5CT3F0UDBhTm42aERoa1ZPZ2RFY2FucUpV?=
 =?utf-8?B?c2I0UDhuQzdEbDJEb1ZVa2JwVzgrdTRJRy9lYWpIVThPQlhtbzhTaHBCcmYx?=
 =?utf-8?B?b3JQd25wdko0YWc5WTNvMzgzNk90VEd0cjI3ZS9JV3lVRkNaeVJxdHQ1TE5E?=
 =?utf-8?B?VEQ3NDlBdWxZZXo0T1g1T1RUcEFkYzNHM01GTG1Qa3RNM1JhT2M1R2F2Rndj?=
 =?utf-8?B?T1ozT3RWNmJFVHF3YUJSb0RYcW5qa00rOVRaM1dnQkhJSmh3T0owQXhCV0Zz?=
 =?utf-8?B?TGVwUUlha3BFWlRRQkgzeHZTRUNueTRaZStxd1k5dVpvRG9kc3dTYXozL3lT?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59F5C85A786D134B89E328E470FA1D92@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf9cb7a-cfb8-4420-dcfd-08dca4c41c08
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 11:48:57.0064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7FOmIy8cnsH2qvSi/EqLS6i1wyy9AjIc2R7oxEQMWqkdBE4XjdACkIA6375mO+6nzjjo0zVKfXqXjYK1Xm7rqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7430
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTE1IGF0IDExOjM3ICswMjAwLCBCZWFuIEh1byB3cm90ZToNCj4gIAkg
DQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNv
bnRlbnQuDQo+ICBPbiBNb24sIDIwMjQtMDctMTUgYXQgMTQ6MzggKzA4MDAsIHBldGVyLndhbmdA
bWVkaWF0ZWsuY29tIHdyb3RlOg0KPiA+IEZpeGVzOiA2YmY5OTllMGViNDEgKCJzY3NpOiB1ZnM6
IGNvcmU6IEFkZCBVRlMgUlRDIHN1cHBvcnQiKQ0KPiA+IENjOiA8c3RhYmxlQHZnZXIua2VybmVs
Lm9yZz4gNi45LngNCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53
YW5nQG1lZGlhdGVrLmNvbT4NCj4gDQo+IGlnbm9yZSBteSBwcmV2aW91cyB0d28gZW1haWxzLCBJ
IHNhdyB5b3UgaGF2ZSBqdXN0IHNraXBwZWQgdXBkYXRlLA0KPiBub3QNCj4gc2tpcCBzY2hlZHVs
ZSBpbiB0aGlzIHZlcnNpb24uDQo+IA0KPiBSZXZpZXdlZC1ieTogQmVhbiBIdW8gPGJlYW5odW9A
bWljcm9uLmNvbT4NCg0KSGkgQmVhbiwNCg0KWWVzLCBqdXN0IHNraXAgdXBkYXRlIFJUQywgdGhh
bmtzIGZvciByZXZpZXcuDQoNClBldGVyDQoNCg0K
