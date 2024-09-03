Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D45C1A7248;
	Tue,  3 Sep 2024 12:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725368172; cv=fail; b=Z2jjDylk2PPQ3tdxoLdfNTY4Ww8TNlYrflppdiK6YagpnfrqEr6bHl4wHg00suIcXpvaRVf4pO+XNJbG/w3XcHhbn+j/ue3mirXzBqWt/3hFVSofBW9aOP9NazmtjH0DYCMuNqftHbD/Ltsx0r4D/SM/bQGWom2KkZetOVYfTQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725368172; c=relaxed/simple;
	bh=v7qy0qt7ZrdxZ2pHqr1VvZOjIKi7r4xRZ6todYAm8R4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bMIzy8QaMSEpjQuciJhpyhDkwQa9KEYhiTcox+qG2kzWCUSe0bdm7wsjrBnNA1WfuPaLY6WrJHnaAERGwsoAFZiodXb2Wj3XZmzJPjv6M8/TtTSJHrkzRo2rf1lpPuDJ44pxa/m3t/yfsB/k/P4Fp5IbVJJSljokx8IT5qaoeQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=FTafh/PM; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ciFbaZKk; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FTafh/PM";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ciFbaZKk"
X-UUID: df867f9e69f311ef8593d301e5c8a9c0-20240903
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=v7qy0qt7ZrdxZ2pHqr1VvZOjIKi7r4xRZ6todYAm8R4=;
	b=FTafh/PMmqT4Y9dA7rCpmBHMK/bVQsMdyNzjqZSKUEsvMlPvExS8+7RSRsV1QyprMk98JG1XSmgcvrnVWLX1ZBuShur0dZJUnfgykAj/V9sL17akdzhxzsEhR9YaW46JbtLVl0tI6yZ6KKMQT+TjxhTE+ieMYuDSKW2Inntz3Oo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:08bd21ec-53b8-401b-b075-1e1ca0c0f66a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:6be13d15-737d-40b3-9394-11d4ad6e91a1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: df867f9e69f311ef8593d301e5c8a9c0-20240903
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 211184337; Tue, 03 Sep 2024 20:56:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 3 Sep 2024 20:56:04 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 3 Sep 2024 20:56:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iWmZ4pDw0LeEso5GCFSoULXhmJjYLsH8dSqQVjS3XXPGdxpzm0tu8pwH6iGlmx2AYUKGckDiApXrbl1af2xFcImyRsC2iqvqQUw/FKnbP2Z7p8NJhuQNxpl1zGzAlPQT00ZjDZLPKz0azxlfqdVYUbXP/ebzPxz2/wOm9sHgdX8DRrIDifyBRhxmZNw2BxMLOhfJUrkhBFBLzzStJvsq8zdcuX/vcltY9ioLogS6Cr/pk6JpXBOR+kkwGbUH0ncClPOI3+Onyf1UNMGfeMXQ4dxW9//DhB+z+4mtpWLUMlGpvFFleOaOhWrr2f+3XfuM+YC9/6mUvNIidWNaiR3Uew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7qy0qt7ZrdxZ2pHqr1VvZOjIKi7r4xRZ6todYAm8R4=;
 b=Kxg3YLEm5SNcC3tTYE7PcHFCkqt6KOYj67nDejS+X+ny8dz/hXhLDZL91JVeFybG0bXyFAFSUuIpRxzVNz3bUFHgMFN+FsXfhmkjgkDVQ2bL8NJdXOj6Nj1uHSnrhcry6iA8JwdylT7Oy0LUX3YWq6aWWGo92rhvadqsO+UCK9KMI6dKGQQF9Kdun2ntvPR7p2kn6tkGfNDlULtpwL5ZY7B0UE7RTl7WzJKehn3U/YQUpYg8udFrTNDybVeP2pUlzfsXYKn8Wz1YzEZVsBgEnxY8C9Pwvt7LJGe5z45xH6FeBrlcf2QSmLNwn21vRtQs1WvhhzzQgyDPP/Un5gu9CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7qy0qt7ZrdxZ2pHqr1VvZOjIKi7r4xRZ6todYAm8R4=;
 b=ciFbaZKku/PzKQMNtbhkFtJjwpIoXO1UK/ajXfttHD4eGMJ/fW76vdUhK2Rja6Pbd6wemdqGMn+vpna0HpTGa7xobTtfnp9znzlr3HCYBd+BFeBGrfzD2x6B4aTElZCPcsMBuJFbeIqYEyoD9x05NpCX/5xE8KtpQqfS9TKwDqE=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SEYPR03MB6459.apcprd03.prod.outlook.com (2603:1096:101:50::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 12:56:02 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%7]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 12:56:01 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	=?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v2 1/2] ufs: core: fix the issue of ICU failure
Thread-Topic: [PATCH v2 1/2] ufs: core: fix the issue of ICU failure
Thread-Index: AQHa/N6PJ26RZpB7TE++KXC82NWtMLJGB4MA
Date: Tue, 3 Sep 2024 12:56:01 +0000
Message-ID: <a6095ac6117710276dff972bcb9ff2c3475ebc5e.camel@mediatek.com>
References: <20240902021805.1125-1-peter.wang@mediatek.com>
	 <20240902021805.1125-2-peter.wang@mediatek.com>
In-Reply-To: <20240902021805.1125-2-peter.wang@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SEYPR03MB6459:EE_
x-ms-office365-filtering-correlation-id: 08095c36-1d80-4818-0bfd-08dccc17c374
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Yitla2IydjkzMmlBNmdvTGxndkF4dC9xczhhZ2g5QWlxVnk5THEzS3I5UWtm?=
 =?utf-8?B?SkxqSUNnNS9OUTZ3TnAzYzlia09hclpTdng1TlI3SVRwMytndDRNQ0l5cU9l?=
 =?utf-8?B?VWNySXFaeTJ5aFd0cHQ4SnU4bUgvbWtPaDEzUVlORnN3WmdrbmhwdkhmREIr?=
 =?utf-8?B?RFRWZWVBenFhc0ZDRE1oRTUvVkpCZUp4Sk5vVXRyd3cwSmdzM3dMV3AxL0Yw?=
 =?utf-8?B?Kys4TVhoQm5IcDRWRVJscDlPVVhYT1o4SkFUb0N1cTgvWlJjeFF2aWUyT09h?=
 =?utf-8?B?MUVkVjdNcXVVQnVlK1Bya1lYMENESkRCeDFoZ0M3Q0RtQkphOGFvZmd1QW4v?=
 =?utf-8?B?aXp1K1F1dW5tNDM1YTFIT0dIV0I3NXRFd1JISmlmTlh1RHM2a0hEOEwxYmRP?=
 =?utf-8?B?M09oWWpEZVB3RUNrWG03RmoweFJweW43Qm05YnQ2Z204czN6SVBCS1d4TDRo?=
 =?utf-8?B?OG9Pa09HM0gwSkZaV2ZYTnlpUEsyZXV1Tkx0a1h3MUpzdmFNVk1zOU9OeDAy?=
 =?utf-8?B?U0Fjam1zR2hkSDNOeVVxajVXRFZMUGt3SHdwNlNnRUFJODNvSHpmNGI1Nk1a?=
 =?utf-8?B?ZFNhWG10cEpEUThkVUFEK3IrdCtkdXNvU0Raa0Q2cE43MUJhLzBJWVhsZm5x?=
 =?utf-8?B?SEJxQVF0NGxOZHFSK3gydmtHUFlZbGFtSXpPTXJCZ2RNRFFFM0M2enQvWGM3?=
 =?utf-8?B?STFzOTUyS2szUE9FYUV4K3k0d2V2eDlBMXJoNVF1WkgrN2RzWVVhVGhpVVRw?=
 =?utf-8?B?aFppLzdOVFArWXo3VnV1QjhrNjZneWlsc1RSU1ZJaURLVVRUYzk4R0g3Z3pQ?=
 =?utf-8?B?NWFVaTBRMEdEZTNtTTVvQ0pwZFRBSVpzWlM1MFc4ekQxazZXVUpFK040Q25p?=
 =?utf-8?B?RVlxcTdURDUxZ3dUbm5jUVRMamJ3b1E5M3VKVGQ3WHFIR0UxS3luaTFDWitt?=
 =?utf-8?B?WEpOWVR3SnFlMmJuRWIyaGxmK05UcGtJQVU1dVpuVXBwbmRUY3l4OExDaEFH?=
 =?utf-8?B?bTJnYlpQVXZwTWh6UG5zelByUnN4aHZUQVYwa2d2UVlkeTB3TDgwZFl6dE9D?=
 =?utf-8?B?VHh1UVFpcGV0U0pIWWNpbXVZdVIyOGxYL3paSG9qcVd4UitZemNSU0V3WDVH?=
 =?utf-8?B?dVd0d1NTTVZvOEZrbjVvbDgvUllvTTJiZTNnNDluRHdoMTg2YnQvU05YTEFM?=
 =?utf-8?B?T2E3dWFPaEwwcG9vNlhVNjc3c1MrTE14Ti85bTY4SjNKUnMzYWYzcWFGV3pi?=
 =?utf-8?B?Qng1VkFxSGNxbCtlRnkxUFlqSkNRczFDbVFYL1JNTzBSOWlUOHBrL3RiZXFz?=
 =?utf-8?B?bDB4Rm8rZnN3M09QZ0RSWWFOVm5rQjFkYmJXeE9pdVlLN1pCR0p5ZTIzSzdh?=
 =?utf-8?B?TFJOZW5FZ3NMVmV5dk5WeTdBQjlCek5XRTNmRWJrSUkvWjBHQTVWOEN4TDhG?=
 =?utf-8?B?YU92aEpLQW5pM3BpRFZEY3dBR09CKzJnTDI0MjJLUDNvYzZBMTRZOFZiaTRL?=
 =?utf-8?B?ZzhTWExoNzJyZlBybi9aclhERzJwSmZOdHJQQkRLMmphUjI1b1grMHpVNTZn?=
 =?utf-8?B?dTVBcTgzTlJUamw4K201K1lqRk12MHkrbjJKWEdaOWlFQzc4NHRZcS9ONFM1?=
 =?utf-8?B?RFRNckVROW1FaTZOQ25ja0xDbW5OK3NEa0pFMkNzK1lUeEphY2RMcjRUS3Yv?=
 =?utf-8?B?Qnk1U0dJV2k2R2h3bDE2dHdjaXlUS3FlekxnbEZUT3hJVThUTTNOZlNGQnVx?=
 =?utf-8?B?djNRamVMS0xYUzIwTjFqWlo5R3dFcU83OE41dlZMRVdndlZjdmIrNTNVWnIv?=
 =?utf-8?B?VFBoNjRkTEtWekNEUnRkNWQrYVczOGVLSlA5OU5TMk1oaUtiUFUyRHhlSTZK?=
 =?utf-8?B?NkEyb1JNSGkwWU1YMjZ5L2FIT3hFTTZlbVRwSkhMR2ZCdEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVpPTlhVWlA5ZVliL3lYSXBtc01pRkwvZ1M1VVppVkxTRUwxcHhPYzNnbTdG?=
 =?utf-8?B?R1pXQTF2bkNkdnRJQkdFTlpPekEwalNSRW9ZeVpmaGhMOUlTK1FSLzE1Z1Y2?=
 =?utf-8?B?eTFTY1lnRHUwQmNUcVNnOWVZZ2NPMnVpZVA3cmFHL3NlVWdHbmdkVFR3L2dC?=
 =?utf-8?B?YjJJZW5WQ2kySzlRZjkrZnZOckgvSEkxaVM3cU84U0tWNS9jZWtuRjJkaDFL?=
 =?utf-8?B?UkUrNHhoc1dpSzdPY1F6d01zWk9HWDk3OEJJei84aHdTaGJjNzBmKzI2L2wx?=
 =?utf-8?B?TGdNNGhLWGtYQkJmd3ZKZXN3TG1mYmx5ZWNIWkl3YUdpMHR0Uk4rd2ljUDFJ?=
 =?utf-8?B?bnpReW1iaXhvYmJiQnc4T3VqZ2NhZy9OdzNHZkNVSDM0S1BjOVA3eTA5TUhF?=
 =?utf-8?B?bTdqeUZMaXlYdXRZbzdTWUlKSzFDRzFjZFhQRHYxRUNDdXJDR21BMHRaUFFk?=
 =?utf-8?B?UU1WUFNMN1lNWTJGNldScmREY1d0N1g0V2gwZWRvRWt4VmJVTzNobWlJZ0Fh?=
 =?utf-8?B?bEhrdWpURnFmQTJ5TklMaGxwMzN1TmVDcG5od2w1dE5HbkkzK0lXcnh4ME9v?=
 =?utf-8?B?YWdUclpZWWErT0NSSmpXTllhMkNnT01WNkpFOXhsZjJzR2lsUEljdjFDdDk3?=
 =?utf-8?B?QlQxNEx0THNIYjlNYXJZQVN6TmtXT3M0QVpqRmRTbFVWaW5mZmZLRURoOEJ1?=
 =?utf-8?B?V0xFMlErWXlIc0w4R3VCYTliMUdzRU5aMEkyYmJpSExQYnhqSStsSTFmekhW?=
 =?utf-8?B?V0k4clk2RW1SUzBsK25lbzJiN05aYklaT0xnQ0ZrRXhzWnpONXNCNkd3Q1Ro?=
 =?utf-8?B?dVpLNE1RVTZQYmVTQ1NpeEpHeGhidzhhaE1FUTdSamlMdFRRVTR5MC9hZ2FZ?=
 =?utf-8?B?OXVPOGdnd2ZvWEZ1ZmdMRGh2YlY5bzVuVHdKWmxNUVdyb0IzMTBRaW54U2pp?=
 =?utf-8?B?Y2gxaFhYKzIwNWszaEk3RHd2S2YyMFRyK1N2RE1xRVJaMmkvVFlmbFNyRm9a?=
 =?utf-8?B?cnk5QllNYmZWUDd6aFNDYnFQOFNmSGpYQWZJcjJCaVdQN2FTbnRPeXJjeFZK?=
 =?utf-8?B?UzlZOVdSNDRrK3Mzb2dNK2Z0ZS9VSWFzV2xPLzZKMnlETnpMY05xWW1kdzM0?=
 =?utf-8?B?cm1iL3BsM2JGZzJJZnAzRE5ZM2N2aEZiWUtlVlBtS3liSFRUZmZtRkM0Y0JR?=
 =?utf-8?B?SmF0ZHBJRVBnZWhzWkNYRWwveEZFcjhiMytobTFzR0JEem05djlTTTNwK1cz?=
 =?utf-8?B?L3l0bFhCUTl1QURJRHdrVmJ1cFJUSWQ0MGlwZlZnSTk5d0k3SGtWRXRCSVpy?=
 =?utf-8?B?RlE3cmFGVEV5Z0JScVVpMVBnc254VnJDUjE0K1hHU2prcWc2UGVaOWhRNVFW?=
 =?utf-8?B?SDNkQmNkMVlaUVJpL3ZSbEViY2NUWGg5Y0ZQNVJHNy9CRHFmbmZ3NnFGTFBI?=
 =?utf-8?B?MWl5VFFxcU9JNEx2TjlSREpHczhhSnoyWmRVendRd2dGOURnODhseUtta1lB?=
 =?utf-8?B?N3VKWkdLU3htVDRNQUUrTE8vTCtqTWxpS0tzNGYwKzhEeHFnaWJsa2xYc1Mz?=
 =?utf-8?B?ajJLSk9pOWxEaitzREJZbm5tcTQ3WnAzalpTS2g1WFl3MmFuY0FFWHZPQWpC?=
 =?utf-8?B?c0NWRktXZUlZUjJSN0ZTRzdjam9DQnVFMzAzWTRQaXdlNE9CaVVDeE5sR3dl?=
 =?utf-8?B?dU41bmJ2cDdWNnozd2t2MmJiVUFPVjVCUGdLeEF6N0ROVlREdEl0VkxtYjlK?=
 =?utf-8?B?UXJNWUU1Y20xQWRyV0JEeTlSemREeVV5eGIvRGZBZnUrbmIyalJBTXJQZW15?=
 =?utf-8?B?bml4UXg3a2xiS2hvK0EwYnlBSi9ZRUU4RU9GZnVTM214aHZaT0R5Yk03R1BB?=
 =?utf-8?B?b2xtbEVSK0V6SjhscnF5RFNWOTNvRkJNVnpTdENrYy8yeHlMN1BXa0JIOGs4?=
 =?utf-8?B?TFpJTHRoeVdRS3BxcUFVcFZ5TU9wZW1JaEhUQnV5aWZWc3BBYVYwcjVCcWRG?=
 =?utf-8?B?b2RxVjJNUXdDdnBKdzBLdHBIV1ZQR210K2s4REVmWkpaVllVMS9HMkpSL1kx?=
 =?utf-8?B?NHkrOVZWMlcyckdrMk1uZTNXNnpNd1NQZGRRNmJVUkRjNmt3SkdOMTZoWGRT?=
 =?utf-8?B?SW1mdjA2a2d4a3Y2MVdGUlNlUkFOQ0VnSkJMTUROeS9HSHVHbzlya1h2Y3Bl?=
 =?utf-8?B?WWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B27C45B74365864CA88EEA3ADBF329F7@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08095c36-1d80-4818-0bfd-08dccc17c374
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2024 12:56:01.4805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e3zFHdG84FWrmQwoN4XfR/I+hsKuXv1NrTDLGbX8RdUJ0py+oasIWj1Os2Hc9Q/zslL/wYsX9qeeyvN4nBf/BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6459
X-MTK: N

T24gTW9uLCAyMDI0LTA5LTAyIGF0IDEwOjE4ICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBXaGVuIHNldHRpbmcgdGhlIElDVSBiaXQgd2l0aG91dCB1c2luZyByZWFkLW1vZGlmeS13
cml0ZSwNCj4gU1FSVEN5IHdpbGwgcmVzdGFydCBTUSBhZ2FpbiBhbmQgcmVjZWl2ZSBhbiBSVEMg
cmV0dXJuDQo+IGVycm9yIGNvZGUgMiAoRmFpbHVyZSAtIFNRIG5vdCBzdG9wcGVkKS4NCj4gDQo+
IEFkZGl0aW9uYWxseSwgdGhlIGVycm9yIGxvZyBoYXMgYmVlbiBtb2RpZmllZCBzbyB0aGF0DQo+
IHRoaXMgdHlwZSBvZiBlcnJvciBjYW4gYmUgb2JzZXJ2ZWQuDQo+IA0KPiBGaXhlczogYWIyNDg2
NDNkM2Q2ICgic2NzaTogdWZzOiBjb3JlOiBBZGQgZXJyb3IgaGFuZGxpbmcgZm9yIE1DUQ0KPiBt
b2RlIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogUGV0
ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMv
Y29yZS91ZnMtbWNxLmMgfCA5ICsrKysrLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9j
b3JlL3Vmcy1tY3EuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jDQo+IGluZGV4IDU4OTFj
ZGFjZDBiMy4uYWZkOTU0MWY0YmQ4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vm
cy1tY3EuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYw0KPiBAQCAtNTcwLDE1
ICs1NzAsMTYgQEAgaW50IHVmc2hjZF9tY3Ffc3FfY2xlYW51cChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LA0KPiBpbnQgdGFza190YWcpDQo+ICAJd3JpdGVsKG5leHVzLCBvcHJfc3FkX2Jhc2UgKyBSRUdf
U1FDVEkpOw0KPiAgDQo+ICAJLyogU1FSVEN5LklDVSA9IDEgKi8NCj4gLQl3cml0ZWwoU1FfSUNV
LCBvcHJfc3FkX2Jhc2UgKyBSRUdfU1FSVEMpOw0KPiArCXdyaXRlbChyZWFkbChvcHJfc3FkX2Jh
c2UgKyBSRUdfU1FSVEMpIHwgU1FfSUNVLA0KPiArCQlvcHJfc3FkX2Jhc2UgKyBSRUdfU1FSVEMp
Ow0KPiANCg0KSGkgQmFvLA0KDQpDb3VsZCB5b3UgaGVscCByZXZpZXcgdGhpcyBwYXRjaCBzZXJp
ZXM/DQpJdCBpcyBhIHRyaXZpYWwgTUNRIHNwZWMgdmlvbGF0ZSBidWcgZml4ZWQuDQoNClRoYW5r
cy4NClBldGVyDQoNCg0KPiAgDQo+ICAJLyogUG9sbCBTUVJUU3kuQ1VTID0gMS4gUmV0dXJuIHJl
c3VsdCBmcm9tIFNRUlRTeS5SVEMgKi8NCj4gIAlyZWcgPSBvcHJfc3FkX2Jhc2UgKyBSRUdfU1FS
VFM7DQo+ICAJZXJyID0gcmVhZF9wb2xsX3RpbWVvdXQocmVhZGwsIHZhbCwgdmFsICYgU1FfQ1VT
LCAyMCwNCj4gIAkJCQlNQ1FfUE9MTF9VUywgZmFsc2UsIHJlZyk7DQo+IC0JaWYgKGVycikNCj4g
LQkJZGV2X2VycihoYmEtPmRldiwgIiVzOiBmYWlsZWQuIGh3cT0lZCwgdGFnPSVkDQo+IGVycj0l
bGRcbiIsDQo+IC0JCQlfX2Z1bmNfXywgaWQsIHRhc2tfdGFnLA0KPiArCWlmIChlcnIgfHwgRklF
TERfR0VUKFNRX0lDVV9FUlJfQ09ERV9NQVNLLCByZWFkbChyZWcpKSkNCj4gKwkJZGV2X2Vyciho
YmEtPmRldiwgIiVzOiBmYWlsZWQuIGh3cT0lZCwgdGFnPSVkIGVycj0lZA0KPiBSVEM9JWxkXG4i
LA0KPiArCQkJX19mdW5jX18sIGlkLCB0YXNrX3RhZywgZXJyLA0KPiAgCQkJRklFTERfR0VUKFNR
X0lDVV9FUlJfQ09ERV9NQVNLLCByZWFkbChyZWcpKSk7DQo+ICANCj4gIAlpZiAodWZzaGNkX21j
cV9zcV9zdGFydChoYmEsIGh3cSkpDQo=
