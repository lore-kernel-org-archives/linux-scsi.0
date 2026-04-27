Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB4036DA07;
	Mon, 27 Apr 2026 06:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777270317; cv=fail; b=PpiNBbsQk3lzfuG7I+yDfZd8QVT2wOQ4PZrUI7PiR8INV46Amw+xD5hajAjIY1AQULwJ4iR4AO+HePmS99yHElsJQ6EwP0Qsq12Zb34K9824s9RSY0FmjE5qBgmOz7CGb7XQZeDIZRGfMsSExNeMtcjKM5VGkkqc2wNPse91wdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777270317; c=relaxed/simple;
	bh=3T9c/mAOXnUP4/hiPQO33qkhZKla6BtV3ZuRq/3whn0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L9KoJCcsBWIoe8GOhT4MyGv/z5OzDlbrvtSOyrs3RvsdVjN+N3oojpUD8SUwj2A0MdbzSiVOdjAyXfbUxq7jh1kiJIvkri10drvaZTQdqRBoDf+unOyb9BJbdOUgSY5EhF3oh5Nbw8L4KP9SBi5rFlBLliwMNPf5uiY0LmZPK44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=CktCqUvQ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=bqUEXqGt; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CktCqUvQ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="bqUEXqGt"
X-UUID: fac74ae641ff11f19781c1a04af40193-20260427
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3T9c/mAOXnUP4/hiPQO33qkhZKla6BtV3ZuRq/3whn0=;
	b=CktCqUvQPC2KtYhKHY+K8NZ69Trz8mJqBJTdpMn7AzMJXHAChAgDJLqCZ7uwGoMmX+mtjbg88kDamEIDfqbpLy25Bu1BPbvpX/CHAACPQqfmGqr8S9lvfpZzxYLtNalHmLccDSmmPwIogqENnAPZQCLo5GGPjBtvQToWyaYMirk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8f8e9cda-83bd-4b6b-b792-47b2604b588b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:e53f7ebe-65a8-4b41-ac18-3671578a914d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS
	:nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fac74ae641ff11f19781c1a04af40193-20260427
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1734609610; Mon, 27 Apr 2026 14:11:50 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 27 Apr 2026 14:11:49 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 27 Apr 2026 14:11:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZCi2kfwLB6IYyuCeWUnoNBYCgwTJANJedneUsrVnxUOiBS5QmWh9DM5IuGVVFYOmzQaK0pbkgNccpdS7oulCilqtT6MVj3I5PQar06OoFgxrtuiZoiyWjuRxIt0Z61ukT+Bk9fj8aMIl15TTKcjcQ1KUuw+zsXSHXCa0sNgZ2Bm7D0sAUL8Jx6ZY92t/E/FydttCw0SzYFoFUaMIFhDKo0x+8Tx6BqkPBh+v782LkW8kBjwjcj5kzxNvZ6AtJxNsKOWxkf1Ivf648dV49394BjQJexbPU3Ohz/QzKZi4IIecS73Ggk6Yq22ojakHLeAwEC9MxZifSgUQgEGz6O4Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3T9c/mAOXnUP4/hiPQO33qkhZKla6BtV3ZuRq/3whn0=;
 b=RemlRiVnkBK+XY9+FwACJLqScv2aa6zdSQmjeKvVvdJmAihrRA3SNExRCKvFpx2Aa7uS/iGihWLjVviAIxegqyerm4RO8elgSWxfsbgZG+3hkuMqjRewXWFeD47ePehczbgWJLkDJ8kiZ11rCZNlsBPUpWjl8mMh+JyD0PE1PWVOWZ2lSHXcr72Rwu5zgZj00a8URskPyvDwGyYV8D11u55k/NyeL+29+q8tUkQhOp6O60IknjO6JaaYv5K4z8GoRhAfrddCig0GSH2fI2p2JEXZLhJAh2BEqAEZ1yURY326oQud80CN81NQTWOFaY1Kmcs42Nv1VWt1JwGIfb+Dbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3T9c/mAOXnUP4/hiPQO33qkhZKla6BtV3ZuRq/3whn0=;
 b=bqUEXqGtnxndx9AWTmBsORpsb+c21WNDWQZczowsShG5Isnan280PqJ8OwmK5hT1znQGF/7YJb7GQzYDBv7UPEtOy1xXWEsh4BlGNJ419B3Mg+MAdZD6/qaf0JIn5lDYYDPn41tsRosw/eK4W8rMXO/C6us1xH7hFgEyTtlTw8U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8726.apcprd03.prod.outlook.com (2603:1096:405:65::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 06:11:45 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 06:11:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, wsd_upstream
	<wsd_upstream@mediatek.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: ufs: remove ucd_rsp_dma_addr and
 ucd_prdt_dma_addr from ufshcd_lrb
Thread-Topic: [PATCH 1/1] scsi: ufs: remove ucd_rsp_dma_addr and
 ucd_prdt_dma_addr from ufshcd_lrb
Thread-Index: AQHc1fpRV67n28DDjEu+qz2UGvtoeLXybXwA
Date: Mon, 27 Apr 2026 06:11:45 +0000
Message-ID: <e35cee170c92fd980a29b9aaa72fd93b11ba1bc8.camel@mediatek.com>
References: <20260427035856.1610363-1-ed.tsai@mediatek.com>
In-Reply-To: <20260427035856.1610363-1-ed.tsai@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8726:EE_
x-ms-office365-filtering-correlation-id: 31b83e94-4ba5-4466-ac51-08dea423dbe4
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: eLElUPAQZvY9MKJcyGC/CY18dg0ZkYdwhjLgk8w80TcWzrvjqqhDhcpxtqH+aX76PIPAtc/sRFw52WeFGE6/F4OYGa5mcD6XIj2n44EiMCDAlWuDqtHpQsJrDMd99lgMsJRbykNzgfCwnDCp2RMMSqnWqGylAXDwwytWSn6p30UfqKqFli5DQJC/3GKmdK0i9bP19chwnjp69HnquZNiWTTqL8u4bkqEeA1vwzjLlpGG997q5fPBSnrSy5fNvp5+zkA4ir4MywnIjqrnH9nW6zbFHmfDO/2BkBkuWJqafQjfFTB5xKJbEvN1fpfu3IErjpRrhAvUbEMrhmtlh9H7W2ZhMNStsBOaeLFoAkAFxKq4uhlXpoQ7TGqeC9qZ3nx4sM1WjfBuvnTZCSo42dmHAOoNYBJqpOfNjnJHhWuzIXG8mY3qP1WuJd2Ekp+HA/6UazILQjB09g2J+uaVXEGmaAqTc0K7ZyStJ0e1QfPyCjlYsylsOIJsfT4RA6QbsFnE1HbxwwkugzIa5SKyHjbI5KJpMH7julVesA9PZLGoPaRg2isX0SOfUgEb2Z/F/yatzLuwAg7oZaJjAPyoEpxj74K1sKWy36XINNJbSMDPNrlXWs2BTXIde/p+/tyr5Z/NDtfZwduQX0udosM31QFQKYabne5l1nR6GBFg+qet3JiHbFxIGk2Ue+dUYDA4gu5yv3J1Jv8lCyjLzPY0FzMbv57n7MgfuGjHUlSl0peIi+dHMYcj5Ysyc+Qh0Gddnh6UUSMWxWKba29wdE0su0MSCvSBOLHnZ2aFodkQIRrhbq8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVluYjE4eTZkVm1Jc2FqTDluNHZnbEVMeVpqeUx5WmhBbnJ4OHZFekZMbWRh?=
 =?utf-8?B?elhVUGVmV2M2bzRUTU15Nk9uZHg0Z3hBRzBDRG1MRlgrQzUvcm8wb0J4alhH?=
 =?utf-8?B?MzRRTTY1QW5UTGhVM3ovSEp6WUlsdEk0QU9Lbmd4OFZtU3hZcUdkL0VkekRh?=
 =?utf-8?B?OW9iRnpTVXFzaEIxaE1NRDc0VnRvYVFpaFIvKzREREhqUTUxWmU4dnl0ZFVa?=
 =?utf-8?B?NmhjUEc4WGYxSXlMdmFHYmkwamxQVEt0bkt2T0s4Y0xySE8wd25rcTJ6UWg5?=
 =?utf-8?B?Nk1NQklEeUhCQit2QjFMTlhoWVZuN3hzV0NiQ3VyYnZ3MDFsOWJJUldEam1M?=
 =?utf-8?B?Q2I3UEZPNFAyc25yM2hSeVpNdXExRStFd1VaWnIrYzlBdmhnbm5LamZJUzRa?=
 =?utf-8?B?M2NXWUtMVHdUN2FCdm1pOEM5elY4UmU2U0d5SlRZNERneFNHSzJXVkpEaUZa?=
 =?utf-8?B?bFoyWHhPdDR6V0pkTERoWWRDZzlvcmVXQUpCRHBFQkRGdDQ1V2FPb3Y1L2ow?=
 =?utf-8?B?dlVNNjdJNWNqcVZtU2d4aDhHM1lhTXU4YjVYU2tqdzZvTUR6bW42VWJ3a0ZJ?=
 =?utf-8?B?UkEwekh4Nk1ZVmY3YlgwcVYvcXYyajdjZUlTYWZEZTFoSTBEV3pwZERVYy9J?=
 =?utf-8?B?ajZ0bjBtVmFMTDArZURmSm43eTBoMS8zN0h1NlZJSFBYYmJ4ak9sSHBuQWdh?=
 =?utf-8?B?VTY3d3pQdzFXRUcvdERBUnBEZFNSUEVONnlNNnZxYTl4RHRhM1BlM0dTRDA1?=
 =?utf-8?B?aUNNbTlNZ0hrQnd2T3BYQXgrM0pqV1p0d0NUR2lNeDhEb0Uydy91RC9pN2Mr?=
 =?utf-8?B?RjBqYVB0L2lVWkJDbGdVUkpsZnpjVXVFd0RKTDFWNFRDYmUvV1dNL2RlWkg4?=
 =?utf-8?B?bEpMSE90UG5jZFFLLzBJaFE2MUUzRkxNSzE3azRPV2pPMmxmRGtCd0RRSStS?=
 =?utf-8?B?THBKcnRtaEFHRTRTSVp5Nk5tNkxZSHRWdDgyVEJDYmpwbXJXVk1OY3RzOS9w?=
 =?utf-8?B?bkx2OEM5WmJmelB0eGRCbWdGYUk2c1pKK0tpcVgybVlReC83a0lBSThsVExo?=
 =?utf-8?B?WTlOekdER2I0U1ZJcnV5RTNxRE5BcGt4TEJ5QmV3VTg3SFdNb0dnaGRJNzlO?=
 =?utf-8?B?WUFYZWptcXRTRGJuL0xCRmFYcVYrQmxNMnErZkdKclplYTFNNy9BN0ZJSk5s?=
 =?utf-8?B?alVuQm1oY3UwNUU1MUJHUm5malo5VGFsMGFsc3pIMEwvaERSNXZOaWZLd214?=
 =?utf-8?B?L0ppb3FRb0xVMVg4Z2xtVWV1RmZpY2ZPa2NlTWF6UEkzTTM4OHlkbG5wTkRD?=
 =?utf-8?B?dnZGQ1phM3NhVHhjMlFuY2FDcXNBM2JKVzZwTlJNL2JEZFI3WC9LREk3QWZm?=
 =?utf-8?B?V3N5MjRoam1jM3l1enJ0THR0MFQ2NXJpNGsvNEVQN2hWOU84Q0N4Ujdpa3J0?=
 =?utf-8?B?YUtsNE5YWHZsRnJIQ1FoUHhVYzZ5SG1nUmMrREVGWElZT08zcDg4a1JhbG4r?=
 =?utf-8?B?Q28rQkxTNTAzaHRsd0FrWkVtd1hBMERzM0N3ckZqb1hGa1c3ektqUlVkN0o3?=
 =?utf-8?B?SGlHNTJTM25IYW9wTklGOUdSamkrbTljWERkeWM1REc3UVBMSktWNU9KeExD?=
 =?utf-8?B?Y2twVlJNNnkvR3RIcHNqMHRrN1VBWGlhMjI3ZFNFSll6VEhqU1ZvT0VuaHhL?=
 =?utf-8?B?cXVVOWlqU2Fna2dwUmRMdEU3bSt6Q3BQRzl5R2R6MWxkYnVHRnlXTzBlbmoy?=
 =?utf-8?B?YTRKU215R3hLMmlMUGI2bEFRcXVoR2UxN2Z6a2F6bUpzenhMQVF2YTZRTVRo?=
 =?utf-8?B?RXM5a2FaTDlIT0dwbnp0d3FDZW10cG95YlJxUWM2b2p0bW5QN3ZrNWt6Wmly?=
 =?utf-8?B?QkhNUTFseXQvSG04OGZqZVBKdko0V0pWV21XNjRDaHd3Ly9qU3NoWXJ1SzNo?=
 =?utf-8?B?a2syeGtNQksyRGpxRDIrdlBhTTA5ZTdpMWwwM0NnbTBhdkNib0NxYjBiZHlM?=
 =?utf-8?B?Wkg1VHVVallsTCtMRlpWMHJjdUpMeW1sbGk2MW93eitFMzJMZi91cG16MlR4?=
 =?utf-8?B?UU5EUGJyN25SekNRc1dTNWpOTUV2YisrcHlGNS82R0xoZ0tHWnVLQVRERjNL?=
 =?utf-8?B?cCtvbVhZUmVXRFpZNVFRVk5jenRsRms2NVI2bG1LdHV2bmxVZUpqcTJhbk5D?=
 =?utf-8?B?bmpRYWNySisrL2JVNzNoZnRsdFYra1FWY3dvdDRjdlVRWWJkVHk1NnBsalhW?=
 =?utf-8?B?QUdLNThldVdxN0UvdFVPR1dpeldHa1RnVXVlRU1ueDdLVGhXczF5dm1ab014?=
 =?utf-8?B?K1NDN1BaMXRvNy9jdTJGWG5pN096MldTcytPL1lWRmFkSGRFTVllekVXZi9l?=
 =?utf-8?Q?z99FjKMuoTt/2vUA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F25F233F2734E49A289F854A52825C4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: goDIHMlKoRb2/MNumjA6evR8hS82SAlj1ftguDjQcc1Dm3R8uXAkOi5LHQAUvA9lXH7sBk7AftAmSzNkyaTgxFAe5KknW0iPCdG+KTGZQIjZPXNjbL6I72SKmJbLSMSMEEHJO4W4C4epJZ7V6P+KsFsBdTCeMOzUgY3xoUuyDEbZF67VZw92UOlPcK+bjTv3V749n1Zih8wb+JSeK1Xy5aQYIezTB/yZtaFqFcZ4sUcZ3MKlncVOicNyNL6nLT5hRg7z7MpesUAl+7+gStbFi4MW1fSwuMoiYhiDNSeJa8jp2zJSxFPskbg0dUbUv06jEkl+vaAWCR5d/xMFxVAMCw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b83e94-4ba5-4466-ac51-08dea423dbe4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2026 06:11:45.2649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sK1hv2Br+XmYiOLIRlXgOiUZryyyT3xYs+yeeidgJ1WKhl32wl6TE5oUdiQ0aapaOA1vlOyw9D4ZcuSUtRwF2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8726
X-MTK: N

T24gTW9uLCAyMDI2LTA0LTI3IGF0IDExOjU4ICswODAwLCBlZC50c2FpQG1lZGlhdGVrLmNvbSB3
cm90ZToNCj4gVGhlIG9mZnNldHMgc3RvcmVkIGluIHV0cF90cmFuc2Zlcl9yZXFfZGVzYyBhcmUg
aW4gZG91YmxlIHdvcmRzIG9uDQo+IGhvc3RzIHdpdGhvdXQgVUZTSENEX1FVSVJLX1BSRFRfQllU
RV9HUkFOLCB1c2luZyB0aGVtIGRpcmVjdGx5IHRvDQo+IGNvbXB1dGUgdWNkX3JzcF9kbWFfYWRk
ciBhbmQgdWNkX3ByZHRfZG1hX2FkZHIgcmVzdWx0cyBpbiBpbmNvcnJlY3QNCj4gRE1BIGFkZHJl
c3Nlcy4NCj4gDQo+IFNpbmNlIHRoZXNlIGZpZWxkcyBhcmUgb25seSB1c2VkIGZvciBlcnJvciBs
b2dnaW5nLCByZW1vdmUgdGhlbSBmcm9tDQo+IHN0cnVjdCB1ZnNoY2RfbHJiIGFuZCBjb21wdXRl
IGRpcmVjdGx5IGluIHVmc2hjZF9wcmludF90cigpIHVzaW5nDQo+IG9mZnNldG9mKHN0cnVjdCB1
dHBfdHJhbnNmZXJfY21kX2Rlc2MsIC4uLikgaW5zdGVhZC4NCj4gDQo+IEZpeGVzOiBkNTEzMGM1
YTA5MzIgKCJzY3NpOiB1ZnM6IFVzZSBwcmUtY2FsY3VsYXRlZCBvZmZzZXRzIGluDQo+IHVmc2hj
ZF9pbml0X2xyYigpIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gTGluazoNCj4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwNDI0MDYzNjAzLjM4MjMyOC0yLWVkLnRz
YWlAbWVkaWF0ZWsuY29tLw0KPiBTaWduZWQtb2ZmLWJ5OiBFZCBUc2FpIDxlZC50c2FpQG1lZGlh
dGVrLmNvbT4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1l
ZGlhdGVrLmNvbT4NCg0K
