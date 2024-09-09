Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8199D172BCE;
	Mon,  9 Sep 2024 03:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725853307; cv=fail; b=iLXn9II7k6b1wig1mBsr68KeKK0p9u7OQcfV6f5shwZzllpF8L6qpPMqBjEsvm2MAr3rqGU/B6fFBcuQAIxPY6ShlYJelih/nbJWFNjv4zcNOGrtXYAsU42HlnqCrUxntsei0ihiw5/O0anjXjEXJrIcM+HW93q21Es1BHj2914=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725853307; c=relaxed/simple;
	bh=gjqf4rbzA/IEI3rYdHaFjiTlycb3aV/84mMsCKCG8p4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SdOKkPFOEw7tqe/mVYIVuCnM64D7v3KR3l5l0azOdTH6vn6xccUXo76EIo9d592ZZqRbvShvdk1O+uoLrksRE3W4vvQdIdkIo/pvQVZPGanQ8Ln5hswjsa+1PgtLi6I5IiVII5MDpM7BLeuWqtp9aoMVPxqu2YnokjEYRpCORsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=I76Ci6lH; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=V8zafNN3; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="I76Ci6lH";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="V8zafNN3"
X-UUID: 6ccd8aec6e5d11efb66947d174671e26-20240909
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=gjqf4rbzA/IEI3rYdHaFjiTlycb3aV/84mMsCKCG8p4=;
	b=I76Ci6lHo9DX+Qy7PZzsZJxNhc4k+ysGuIl2dn12WFHgTo1ygdLvqut3WoakY6B5Kw6lNp5+wP73yzcRG9SKoRY91DJXCT5LtZReAizc2x1syy4SOLJ8O3DJ9Jiuj+P+FAdu5BZT5Il+5fGd5aTswv4/BZM8uIzU5nI80fVz4lE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:8d6058e4-50df-4001-a9bd-8b6338b59cbf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:4b75a6bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 6ccd8aec6e5d11efb66947d174671e26-20240909
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1809284166; Mon, 09 Sep 2024 11:41:40 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 9 Sep 2024 11:41:39 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 9 Sep 2024 11:41:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iBwbdXHIsFd58n9SgNd5TlQTxbh7MOOXo3D+BAIxcJwbWIqLM1Uc2K7evRx5+XRwQcWfrjlKvbQD2DYP1TEIewSUFbA1VB6dYeDgsohukfAhAL9oEhZFAcRYE6G8qhMnZMlIESpwZ+JIdCqtAtCs5/T5vqPyfX8w9GCR2GldKq0IPmBnQL+BejlGMIchWHQJeruH99nFTSVVzEE6/cpA+aUFkXZj9H7FfZ7EZQmwJA3kIUcOT/sM5EtzI00i4rldbhO/ylRLuOU+Ghd1UE9nRcApSuT5Lv3SYe2+JU9DchVELars0BnadtXE77VC7/3s8V0AU+l+rmkXT4dWmA9xIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjqf4rbzA/IEI3rYdHaFjiTlycb3aV/84mMsCKCG8p4=;
 b=fLrBASCL0283Zym/aMeRjYSb4z0vEiKYAFZGyX7UY+3SSoB1WXmcMWWGOH5P9lMMqzN6pnovJSsQo68SNWlhQAHZMhwxlDmQiQPZRKYW6hADg4LfwwdYIx3vksCBXvUwR0qd0zV/hPnXxBh8ZYdmj3D1V9GW2BeMsr+8RcDHrLViL20oVmaPSrniV2YCJ5LZM2SWb2FRykY2OZYBEfQvWqFtkVa7mgDY7Mc4urtToLw59dBtAatFFnEU5NL/72udln7DJqGKZCJaPA48Z3Cwgtn3x3IAc7l/Kvy9/f9MlLELfGnbQUy3vkfR0XrcYoRzERtTePo3aczJ+yT3kVGV/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjqf4rbzA/IEI3rYdHaFjiTlycb3aV/84mMsCKCG8p4=;
 b=V8zafNN3JWgbbZI1T7XE5Qtc82cXSxxtGwTad+FSsKCdsdNitAU8XACzLf8AyI5xLjVprOlv/ewg0jIOeZeSFHp6bVnkPO3Uj6lpvk3oLjoM6TVrTp4OSoopURVfX1NIrkKbZnUb6jB6SzzWaIhRVleIO7ibnwXcp8OGbSILKrA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8504.apcprd03.prod.outlook.com (2603:1096:604:27a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Mon, 9 Sep
 2024 03:41:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Mon, 9 Sep 2024
 03:41:37 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
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
Thread-Index: AQHa/N6PJ26RZpB7TE++KXC82NWtMLJLP/MAgAOapwA=
Date: Mon, 9 Sep 2024 03:41:37 +0000
Message-ID: <ffbd0593f8f736a2631b7711c7a1287189806006.camel@mediatek.com>
References: <20240902021805.1125-1-peter.wang@mediatek.com>
	 <20240902021805.1125-2-peter.wang@mediatek.com>
	 <4d28f099-137f-b9b8-463f-40ec2a745694@quicinc.com>
In-Reply-To: <4d28f099-137f-b9b8-463f-40ec2a745694@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8504:EE_
x-ms-office365-filtering-correlation-id: 6bc01fd2-ee9b-4bad-53e3-08dcd0814ee9
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VDhYUitYUStudUtNTE5KUHIwZkovSHBkc0xpSHozaGIrZWZxM2p3eFdkVnU5?=
 =?utf-8?B?UElzY2JVcE9iYWwwMnhBakNRWHZFWWpFbE5MSHdPSkZYK1hDYnlpa2lBa3pG?=
 =?utf-8?B?VFF6SlVBek82MStvRFRCTFBDTjNxWFZHTFRrdjdIdkFyZFN0Z0EreFFFblQy?=
 =?utf-8?B?U054cVFmMC8xa05DVkpvM09ndi9BNFBVUlloZEk1cG1VU20xbTU4Vm5pRk05?=
 =?utf-8?B?ZEFQUW0vdHhOaUNFa0tWK280SkpTeUYrS2RzbEJmQklKdnlmSDBPOXZ2NVdl?=
 =?utf-8?B?ZzZYTVVFTy9VOExaRVl3NUJmd0ZiSEsxcUxEbkYxaFIzbiswbHVhZEFFSWpl?=
 =?utf-8?B?N0pKQUNGRDhvQW5mQlkrY1BsVFNCSkVwSjRUbWdIR0M1bFp1TDhRK3VuaWN5?=
 =?utf-8?B?SHpscjJxNFZ5cDRNU01SRG9kRWNNdmU2c1J5VFJ1bmxFa0NndG1wamE3NkZD?=
 =?utf-8?B?cE1DK2g1T3Jtb1hlMkxDenZjUnJ5MXFYeWg5cW5aWmRhWkw4dkRoekJxRGdX?=
 =?utf-8?B?V2tWMWEwd251R0ZCZ3lQSW9qeWcrWVFGSVI4Y3FuK24vT09EcitMNHFrR2FO?=
 =?utf-8?B?ekhyV2IxZDNMRnZaVzM3a3ZRMzhrd1Z0TE1JOWs4L3BtUzRCcFNwWUx2eFB3?=
 =?utf-8?B?aHhpUFZnbTFoZVVZRjhkTkErTHZhWVVCS2ZKU0dtd0QzWUtQVFkzNFNwNXUz?=
 =?utf-8?B?Yk90VzFueVBzaUhmbWVtY1Y5d21qSjFDVFAxdHFBV1ZuQW8vL0lWUVNsK3h6?=
 =?utf-8?B?YkNabmxyUlZjTTcyc291ZzhXTVlkZlQrVWhrdzhidElORzlpcExLdFBiTDNw?=
 =?utf-8?B?aTFibGo0WlNBM3grM3RsRms3ajRWL0NoWnEwZlVYeEZqcDBOUkdzWnJmcWtU?=
 =?utf-8?B?WjlOeHNEMmN5ZStmSVk1cHpTKzZpQ3k3TjJOMXo3amlpdmFIU2pNODFWNFRa?=
 =?utf-8?B?dmppSXJ1ZjU2Q0VKSlBnSkx2ZjJIc3VZdkpCUUgycFFYQWVWbjk1N0kyVEUy?=
 =?utf-8?B?UHVaRThvNkFGK3V3Uk5nK0tGdWgxYkx3SWVQekJIZHZESEVzTlowMjFMRDlP?=
 =?utf-8?B?TnRwUUF6REU4Yy8zNWRkcGp2bzJlRy9oUjFRRkZiR2Y1ajF4ZGcrTUJjbDhz?=
 =?utf-8?B?R0VNUUEvZG5RL04vZlZsMHZscWUvWnVXc2JkL1p5LzFZZG85WTFoRHBpYXA0?=
 =?utf-8?B?TUF0VUJxajIxVDcrU2licVNoeDZIQUFzWXhUazczVFpqWFB1OHJaLzdjQ0lK?=
 =?utf-8?B?MXA5VlBTNFVrU3hGUDltclprMEY0U2FYbjlKWmZRelRvd0U0VXROKzBnLzhu?=
 =?utf-8?B?azhVVjFRWUpOUmhLWjZMRmZXd2RHSmJ0MEh5SkExK2xKV1g3MkFrMUJQVXpX?=
 =?utf-8?B?MmJGQmVsalRLWG9zcFRUeDdTRmQxUmFKUWx2dE0xOU0zOXdzd2c4Y2FYWFBE?=
 =?utf-8?B?b25VZTdjVXFMZVF1Zi92aHJLMmU5aDZyRzV3TVNZTE9PZmRWOFU3RzZGVmYr?=
 =?utf-8?B?S3dNOUE5aExRT21teE1VMXQ5V281ODFUTUNvZjl6R09lRDZ0QjhiRmQwMnRa?=
 =?utf-8?B?S1FOQU9GZEcvcHd1dEtDcEFKZkF0TzhUZEtKNVFYRHY3dnpYMjNjQUJkRXlq?=
 =?utf-8?B?L1RZZUlNUXZWbW10aFRESTBWdzU3d21iNDN2WHlTVFdlK1gza2JDL0hQZmY1?=
 =?utf-8?B?bFFYTC9SK0wvNzh3ei8wdDIwMWxTL09WS2orSkIwSys4clUrU3lUZWljaWhY?=
 =?utf-8?B?OEx2OEpEcjc5QVVnLyt3SHMrL3M5dS9ZMWxaSi9HUDR4N3k0ZzZHN0QraWFK?=
 =?utf-8?B?elhFeDJZQVVPR0J2Z054ZzBBV2VkOWN6aWM2M3lBYVBWT2lvRmI4RTNCK2cz?=
 =?utf-8?B?MlFyeTNGdTJBNnNzdmx1Z2FHSktLNmtTaUhOTGhzVWRvL1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVBlZkpiRUs3cWlzVWF2UUNZS0pWa2Y4aC9FTTlDS2puWThjaFZyODEzdHVl?=
 =?utf-8?B?SGpuOHRUOFY4YTNob01RaGdqTk5VSUpITGJRMW9NNjVxc1lmUTc0b2RaUmlo?=
 =?utf-8?B?dFpFUy9PMVhTWWdxQ1BZdGpmbFFBNkRtNG9FcWs3ckdyT2RWVll6a0Q3cmZY?=
 =?utf-8?B?SEVZelNCbURDZzdwYW1HVDRoT1ZrMnFHcEMrMTJYYWczd1doaHc3b1dmV3Vi?=
 =?utf-8?B?S3dGYnJSZENrRXhzNXZVR3o0cFpJd0thQVllWVNuT3pSZE9ycllHZWZxb243?=
 =?utf-8?B?dFZwazRqckhKL2s1Q0xJVm9MaUFQMDdrZWVzbXQ1ejFadyt0VGJBQjdyR3dY?=
 =?utf-8?B?TlBoaWcwTGp6V2x4djNZdU9WZFkzelp1TEo4NU9OSDdSL0ZGRDV3bWxzWk0r?=
 =?utf-8?B?Qk5ZVjdLNnlyN0w5bFdseS9QbXRMUVBaWnNXeENEMXViS0lMZlFSKzdkSUdn?=
 =?utf-8?B?Z0tESER3ZmtzMmVuNEdqTGRtS2tuZHV0Tzc3ZS9kaldNd0l2Z2VVdEE5NEor?=
 =?utf-8?B?cnRLVjVqUlRtNU9vbE5BRTYwdzY0NE5wc2Z6eFhWOXNtdmpwR2N1NWRudG5U?=
 =?utf-8?B?cExIQVVqT2tTMmxYTzUxRWtMMytqTWV3RnhiWVdPajhaekwzN0l6dHlJQk1P?=
 =?utf-8?B?RVZIVjU3MzRDVlFzS0dwN040dEdScTVSN0tZUFZFNk5OMzVuc0Z3aXFpclVa?=
 =?utf-8?B?RVVhb1JwOTRISE9hS1Y3c2w0WjdidmV5bTFKZkM2a01iWm5Jd096RFBHQklr?=
 =?utf-8?B?WGh1VHdsNWJ6c1Y4YzlSblozRG1CU01URDZwUEJta1pCWTN1VmFrRkpRbUVN?=
 =?utf-8?B?QUQ2QThpM1ZkTEg2SU93SHJhNEpLb2VLNFQ4UFRFb3hSa003VzYvZzg0Q0Fq?=
 =?utf-8?B?VWFEU1hFTmNKdndiZ0J0R2UvNitpcEpFcnpqMlV3YXNHM3ZST2JSc1JsTGY0?=
 =?utf-8?B?L2pQNEE5L2syMjViV3JwYjdrK3NUYUFuODQ2ZmhTME1MOXJRUzVPcWJNSUti?=
 =?utf-8?B?eVNDbnk0SHB6bEIvTVVUMXQyOHhZTEZibGlFUUVyakRUM0Z6Q1N6ci85enN0?=
 =?utf-8?B?VzFQTEp0UzZTYkwveTVxSVlxMzBNd1VPNFlORkkvWnAvRWRFZTBNVWRMU1p0?=
 =?utf-8?B?RmZZS0MyUXMxS0ZVaElLcWE3TVhhZ0JYTFNGSEF1bTR2Tm1kTm0wYjlQM2tD?=
 =?utf-8?B?OENGVjR2U3lFb2ozcE1DYkhXQ25vdEdSdiswckZ4UFZKWmRZVUVBUTQ1MGRp?=
 =?utf-8?B?bEZzWTJvSmIvK3ovaW1PYko2WnVFS1g3cmcwc2puQmMwcE9pbWNqeFBGM0Uv?=
 =?utf-8?B?SEp6ZnFHOGZKYnNZbExPTC8wMnBkeVNkZ1lsaW5TVnlyai8yVDBCMnN6K2JE?=
 =?utf-8?B?eGdMZWlsa1dlVGNvZVRTaFpPMk4zcmtZNzlMelJPdmpXbW9JcFJQMUMrVEdo?=
 =?utf-8?B?OUxtS2MweWdJNG92S2t6dWEyQnJHZk52OTZScjBzcUZHQ3NvTStKQkVTcWhV?=
 =?utf-8?B?UjdzUUhtTlNVek94OUY4cnlpVjJQWkRzd3BYV0VHM0REclZGOXo1dDNxUmRE?=
 =?utf-8?B?VkJXeU5XS1AzLzhyMmdVZm5jRkZCUDRHY2xMUW1sUGIvbW0rN00ydk1wTnly?=
 =?utf-8?B?cWZZdGcxa3NnZUl2SzA2M0hsZy9hYUpQK1Fpc2d1aGlmcE1EcHRRMWovTEYy?=
 =?utf-8?B?bGJwaDFJaGhaMUxIczIrWG1Cd084SDRIdmFBeldrZTdUWUhPMW90TE5UR2sx?=
 =?utf-8?B?cUt4VjdyenNZbG9IYVFnTHExY05LV0k4akR2UnZQa29aNVhodHVFUmVJK0xw?=
 =?utf-8?B?TVRTY0laYjh1NTQvR1hZVzdjRXpGTlY2VXBvRVdCaGV6b2dwYkg3WkVWOHk2?=
 =?utf-8?B?UkNXcGRMZHdJTEJUa1FMWEVwUVJKeEd2MzZ4VEFkcmhZVm9lUlBlbUc2ZnBO?=
 =?utf-8?B?T3prVDBvQlQ4ZlNQa2FRcEd6THVjMnplMERDdHRmeEtVd1JmaHUyYUg3SXpS?=
 =?utf-8?B?bW4vdGV4RmY5STlOL3ZTaU1XZ0dFT3V1TllNckJrNXhqUkdwa095bnVVeWcz?=
 =?utf-8?B?Nk90UkQrQ25CYzNkOUkrbUowdEova2ZxS2dVOTUwQlNSN0JRWjlzKzhTTGt2?=
 =?utf-8?B?dXVxQ3ZqWWpuMGhjSDZISEMzeFdqcUJxOS9YTHhTU3pnWXBOcEhkQVQrWHFU?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6687B6BFD1E2C1429D25E602CBBA0701@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc01fd2-ee9b-4bad-53e3-08dcd0814ee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 03:41:37.3016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CCzI3wUFt9t6hLtHb96AiWwJnIhyVzroKkbisN7yN205bcoQUx4tbyb+oaWcb1+Oewc4HBERurDt0pUHRA8+WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8504
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--16.068000-8.000000
X-TMASE-MatchedRID: F7tLedRt7ifUL3YCMmnG4ia1MaKuob8PCJpCCsn6HCHBnyal/eRn3gzR
	CsGHURLuwpcJm2NYlPAF6GY0Fb6yCn6dhLukK+2HGfRQPgZTkip+Mk6ACsw4JlOHCSh9uqMhEwa
	0+RTIVt0T1H86vwca/5lRsxp1W42u1ZganTi7yVhtD1qg9KZYkTGZtPrBBPZrZj0yUhVrMqujxY
	yRBa/qJRVHsNBZf9aRIC0OoeD/hCbu2nB9KtyYQNmzcdRxL+xwKrauXd3MZDU980qe9xzB3A==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--16.068000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	79A407F2D8198683750A641CD33BFD810305381E3F8191FD704E31B1BB4AB9832000:8
X-MTK: N

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDEzOjM5IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiAgCSANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0
aGUgY29udGVudC4NCj4gIE9uIDkvMS8yMDI0IDc6MTggUE0sIHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tIHdyb3RlOg0KPiANCj4gPiAgIC8qIFNRUlRDeS5JQ1UgPSAxICovDQo+ID4gLXdyaXRlbChT
UV9JQ1UsIG9wcl9zcWRfYmFzZSArIFJFR19TUVJUQyk7DQo+ID4gK3dyaXRlbChyZWFkbChvcHJf
c3FkX2Jhc2UgKyBSRUdfU1FSVEMpIHwgU1FfSUNVLA0KPiA+ICtvcHJfc3FkX2Jhc2UgKyBSRUdf
U1FSVEMpOw0KPiBIaSBQZXRlciwNCj4gSW5zdGVhZCBvZiByZWFkbCgpIGhlcmUsIGhvdyBhYm91
dCB3cml0ZSAoU1FfU1RPUCB8IFNRX0lDVSkgdG8gU1FSVEM/DQo+IA0KPiBUaGFua3MsIEJhbw0K
DQpIaSBCYW8sDQoNCk15IG9waW5pb24gaXMgbm90IHRvIGRvIGl0IHRoaXMgd2F5LCBiZWNhdXNl
IHdlIGRvbid0IGtub3cgaWYgDQp0aGUgZnV0dXJlIHNwZWNpZmljYXRpb24gb2YgUkVHX1NRUlRD
IHdpbGwgYWRkIGV4dHJhIGJpdHMuIA0KT25jZSBhZGRlZCwgc3VjaCBhbiBhcHByb2FjaCB3b3Vs
ZCBhZ2FpbiBiZWNvbWUgYSBidWcgaW4gdWZzIGRyaXZlci4NCg0KVGhhbmtzDQpQZXRlcg0K
