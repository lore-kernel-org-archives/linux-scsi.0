Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB518A6B5;
	Wed, 18 Sep 2024 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726666211; cv=fail; b=BV2NsdOM+R0xrpravJwDFNx+cGNRovxx1XIi/dmVOZs1EdeOZUT4+ZO1+RNl0k1fs17jbvatRpyfxXJnkDaUEMn/RtIYIsmvQav4ZgwczhuaiXtbTlRR42xHWgXu3kCpBBZ//cFR410zlstCIWUG05GmoFB4okmCQTUhtJjXTMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726666211; c=relaxed/simple;
	bh=n0NxnhmTAlQ4tnAKj7g9UnbbLH5oDMtgi/2gWFxXpVs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l89ySFAfLkSdqZCMUhQP2sdWWFJoVqIzDXT2z2th/jjLsnr/rYvCVw2se7aU/iP02ss2AVn4819z99R0nXdpJBzX4JaMa4H9sMNQLIqTSkUuFW+XmWtUnURc9NqWVC5YoSkyuwFxk7Lei79kZgVzuTKL2aOo/efxcoke+un8v2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XEA/ciIu; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IznhMspc; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XEA/ciIu";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IznhMspc"
X-UUID: 1c85582875c211efb66947d174671e26-20240918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=n0NxnhmTAlQ4tnAKj7g9UnbbLH5oDMtgi/2gWFxXpVs=;
	b=XEA/ciIujH/2o0GZ1inMpV9Pycbt6c7WSqDdqkcREEofjt9plu+LrT9SQW6sYSQFhwnl/C0nc6uDPwB5OfIGSMV/P8vtnk16K1lB8yY6VM/wwRMDf77GiXTNw+W/nnMe6c8jGmC9owJghqPd0czWUB2onb9M/+dw2eZQov52NH4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:e6557db8-55f1-4b53-8785-8a4e9e3a7fed,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:76b631b7-8c4d-4743-b649-83c6f3b849d4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 1c85582875c211efb66947d174671e26-20240918
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1392433424; Wed, 18 Sep 2024 21:30:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 18 Sep 2024 21:30:02 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 18 Sep 2024 21:30:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ro/OR+tEGereAQGOMUFSGQxQ9e9FTJVG4+GQkQmn9iyDGd54bcYVf51YHRRUdFaE4Rt3qBiMkoxMlp3o2fkkMKFADMPzi9IIJXMAz8T49ZnU4o4DvrMiwylm4ZZY2Ve1ZUMC1zup4T4+crvEyZSW1dIR7o1Cbcz2kDWWQP7g0jCDMRrnK+pimT4r4JhuxEtkdK4fMHjnb69el+0jKxhC0Jv+LP0vJBmObMTCBxcx+O8GiLWa7MHwaH7NkaYElgYlimeVzGzDshA+DXsaCxLOKtW6HMMWTbqscLlnj+azzsGHpcTuqSFyBcpVIqD8XmL+TCyWloaJKuiFY1453uz3Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0NxnhmTAlQ4tnAKj7g9UnbbLH5oDMtgi/2gWFxXpVs=;
 b=aPiJb4d4M3OpujixzFzB/Y3f7Kk3rVz6PXUrs2Jy/3stL+iCMY2MsT/J0sdOdQTq/i5SMtyYPhYaFWG87rKLOO7Cbq0hDlEbEvBU2Gqn1inD8+N0HQwNCxmjVnHkCLWjKjqAah/OLuGRrdbKS6HGfIFYbKBmwiunGftRg/lCP787DF7LjgmojI8QvmXhwaeZLeiL+uuuQS8Ys/6eu7ZFosF9SNfnupHdMM8j5xOi+lb5NTm8t5EhIQWDV53rswkyty2aIuZiERzPZIr8pVdXLRqQPCox2dspoJ7afHJNB0CukEh3etjIQO2up5M3pLpfhyxw+8cYuvaw6LmO3W9yEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0NxnhmTAlQ4tnAKj7g9UnbbLH5oDMtgi/2gWFxXpVs=;
 b=IznhMspc8N0uYIbCZL8/JX3uHSUUi6sSQfE/8nO3I695amUqGSMxrbRPZ0Hr/UlKTIz/RNXDwsDQ5rJUtG4P12LZnTEmpRAAtsDnK1aBUbOY4ysPt5jFXCXOBiN2YnPeyBPNZFcTrWfq1iJaECLKwRYmm/oKbWQD/3TEZQzSgGo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8619.apcprd03.prod.outlook.com (2603:1096:990:9b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Wed, 18 Sep
 2024 13:29:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7962.022; Wed, 18 Sep 2024
 13:29:58 +0000
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
Thread-Index: AQHbA1N1RX6n4EeryE2vN/rAxATc77JRT7iAgADKYQCAANwoAIABMz2AgACCMYCAAKWTAIAAsGiAgAeVY4A=
Date: Wed, 18 Sep 2024 13:29:58 +0000
Message-ID: <61a1678cad16dcb15f1e215ff1c47476666f0ee8.camel@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
	 <20240910073035.25974-3-peter.wang@mediatek.com>
	 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
	 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
	 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
	 <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
	 <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
	 <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
	 <46d8be04-10db-4de1-8a59-6cd402bcecb1@acm.org>
In-Reply-To: <46d8be04-10db-4de1-8a59-6cd402bcecb1@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8619:EE_
x-ms-office365-filtering-correlation-id: fde8e76c-6f8c-4e75-f766-08dcd7e5fde6
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M0VmSVVnb0cyVThZamliZlZlWFlQaWgyK0szcCtqMVFPaFRrU1dEY0llWXZi?=
 =?utf-8?B?dm1IejN4dEpBTTUzYTIreEJFOFhndG9rUGxXQ1ZHQUZkNFU1dkIycnJwOXVs?=
 =?utf-8?B?enJNaXFnTkNTYmtPd3pwd3kzZkI0MVVPeFo1TE1HbjdPMzdtekpsN04vUi9h?=
 =?utf-8?B?ZGlXSXMvdnZ6UDc2NEM4ZG52MnpwZm4zajFqY0xJRFVZQXRSVkE2VStIdUNS?=
 =?utf-8?B?ODNTeHE2TG1pVytXNm1raS9xUXNma3pPN1I3a1VxR1BycDVpSWFtQkl1RlpX?=
 =?utf-8?B?Yk0rYXUrSWgyb0Qyeldwc0RMY1VnTjQzai9hTnRjNFM3V2ZjTU9VaGFyeVFp?=
 =?utf-8?B?MTByRFVHVGV2aGQrczdWL3o2SDBYZkNmOEM1OXl5RkZReWtTaWJKOHlQUGtl?=
 =?utf-8?B?dEw1dXZkU21ZVjYwY2lwSWJqOERpTkFQVzIrVTI2anRaQUdsNEIwRWJDZnhY?=
 =?utf-8?B?Z3A3T1lBMnJISjJxemxnZ3NrK1dYZGM0dTlWd3JFdHpvbnJHeHYzVFNxcGxM?=
 =?utf-8?B?VVo2UndEWnQ1elRvRU4waDViNU0wWUZoRzNUdDgyZ0JlMTdLbERkQ1lPU1hj?=
 =?utf-8?B?Y2dTNXdMOUVvUHUzME1CMk03dFJPdUVIbTF0NzZXYmxNb20yRXMxcG1OTW83?=
 =?utf-8?B?K0xiMERqVUVBK1ZJRzJMUkpRSWdyS2F0eHp1OXd4RXF2TjRMcXpXcFlNVmxN?=
 =?utf-8?B?NUJmbnN0VTFJanZ4SHVpY2pGUVNRUnM1cXAyZ21XdGJBVmNTSkJQUG4raWl4?=
 =?utf-8?B?bGtjWGxEVnZkTzJJeExESE14bnpFNUp5MTQwS0N6RFE2ckJyd2RmQWlkQk1E?=
 =?utf-8?B?RVcwZkxrMEFHYjNlakdkamlDRlVUcXA3YTZYVWd6dDZNd2FtVlM4ZHFwZlhY?=
 =?utf-8?B?YzRYV2xkYjJocklXeWw2MW0xelRYVFNNTjlGV3IwOTcrMnJGOGUzbmR2Zjlo?=
 =?utf-8?B?K1B3UlJ0cGtIUE1GNzE1NnR4c1E3WDJYbFFWTjE3NVhLNlUwK3prMncyN1lR?=
 =?utf-8?B?c3JQdEt6L2NKcnpESks5dWZsRkFjbjNPdlhJNUdHdks2YytGOVBwdURHSTcr?=
 =?utf-8?B?SmFUTXNJMjVJZmwxQTRFbXlUL0JhdVJlRytIZmJRdlN3ejBScy9naXgxWDcr?=
 =?utf-8?B?RWF0U25vMG9vdWw3MWRsa3JicDBFRzljY1lQVlg0c1ZKbkN6K1hRUXlXVjYv?=
 =?utf-8?B?VWJIZzNnWldidGlURzIzNnRDYUk5VTRNU2ZWWWFKS3V4NzZreGowS2tKWDl1?=
 =?utf-8?B?NHY1amYxWG1hMjA5SDRFMGlIVEYrM1JrMUhwNkRhQUpORGZSZ3lYWVZQNzlW?=
 =?utf-8?B?TlNTZnJrbHZPcUxPVmhyeHN1bG5kWkRwa3RvYlJEWFVWNU1mZ055RVFLdnJv?=
 =?utf-8?B?YlNocFRaeEcycjdtMHZDbWFnLzNzdjQ0WkFLTXJCNzBucWR1UUxxZW9qRlo5?=
 =?utf-8?B?cm83S042T0IyOEtIS0wzUEhFUFRJR29aU3d6VlQvVTQ3bWhGSXNBdXdvKzdk?=
 =?utf-8?B?OUZyVzNYME94bFNINVFPbjcvWERYUmtwMElmSkN6dHMyODFYVU9mYUtKZUdr?=
 =?utf-8?B?aWhoRkhYVk9LSUIrK2pXYjFrOHFkWDlOQU91d2FWMThrMzBmSjZML09CcGh0?=
 =?utf-8?B?STZneVZCWGFSbGRVL0VqdHI1a2dwV2tsem9pOWJhcUNITVQ2RWZ5TitCY1Fi?=
 =?utf-8?B?SDkyNVh3bmFvMTlKQlRTTkxkMC95MmI2K1MwRlBXdnRLUDNUdkFnSCtwQy8r?=
 =?utf-8?B?T0JRM0VaaE1WdjhmZEhEZUtxTTZkN0FTQWNjeUowU2IvV2dkVW5OdmVuYVJa?=
 =?utf-8?B?SFhDQ09yYmlsQUZLZEovdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTRESnNOaEF5cjd6UnBxSTZrMks2MnIreXc0TmxaaDIvL2tWeTBnRTExTGNa?=
 =?utf-8?B?ZndQcFhYNWJGNDFFeklscDAreGdDWkVZMENJUi9pWGNuS0dtWEpWMGJ2a3By?=
 =?utf-8?B?RHdUbHFyU2d3VDFBQjUwcU04TUFxTXlnUjI1WXRKemRxQUxTUlpLTkRYSUZ1?=
 =?utf-8?B?WTFMdkxqTGFDTHIrcUdiMksvZ012djY2VGNnWEI5eUhTaVFXbXhWSE9ucjQr?=
 =?utf-8?B?S2xVNVQrV0pwNXhGUGhXTUt4SGVSVTQ4QXNJaHdUV1YvSjhzcVpEaDNsTElS?=
 =?utf-8?B?aXp4VG5xR01RS1dKZnBPdVhldUhxZUJjVVJlNVdFOWp4eUVQdDlyNDZIYkhL?=
 =?utf-8?B?bm1JRzBLMTczSEE5bDdWYTdoeCs0YTlpSGgzSEUvQnkzWFRDbVJxVDZrSG1u?=
 =?utf-8?B?UDhrM3N1ZmVjR0JGcHN4YUFxUVdnem1kdmRHckpIYzhOaGZGcFRvOTdBOUNx?=
 =?utf-8?B?QzBRMkl0S1pGbm1pOERqVTRIalJ6ekRIMGJRQUV0Mnl0Nk1Hcno3ek56Tzk2?=
 =?utf-8?B?VC91WkdHSVZaRVNDeHhyMktCbHFjN0UvWllJVksvYWhZaWp5b2pJME5jYnF5?=
 =?utf-8?B?bEFZTGZEOHJJNXhUWEE4WTRhYkxKeG1WanRvSG10aW5ta0x5d3NRZy9IcXoz?=
 =?utf-8?B?aWwzUmJZbUxHZTJhSW5Xd3NhREtteVNPN0tUa05qdEkwZkxhamVpREdlaVVH?=
 =?utf-8?B?RWM0YmxjQ3E4dDB5Q0QvanN5RWZSQlA1Z0ExV29KWHpaVWRBaWIrNG5VR2Vj?=
 =?utf-8?B?MHRwTk02emNyYUJNak5uZEdHWGNzc3Y5SU1kZDVPdkdVZit1dEVta211MTNF?=
 =?utf-8?B?WnBBQTFUTFZBd0tMeDRldXZkV3ZYZ2NNQVluTjdqODZ5cU1NTm54dHM4NmxN?=
 =?utf-8?B?MTJZSGtXc1hhNEo5MXozelloNU1HVXAyQkhxZ0RuR0JMR1k5NU1JaHBqWk5N?=
 =?utf-8?B?Um5hRVVhamM4d3NNa2RoNXJXRTJ5eTFZeDBIKzVlY0RjMGw5dWVhQ1BXWE5l?=
 =?utf-8?B?QUxXZFJsSCtzVnorS0FFeVdVUm14ZTNNUjRCdVQrRTc0eEZ6RFhEL3hTUjBL?=
 =?utf-8?B?a2FveDZob0I1cGE1UjU4N1JlSFY3N2QrSklrbEs3Z0JSazgxSmlMbWRVVThj?=
 =?utf-8?B?aDdpRnl0akozbklnS2ZKS2tNZ0F6SGdzTjdLekg5NDJSZUxwbkVBaUpIT2Vm?=
 =?utf-8?B?ZHNldlM3dTlKelpxYXdFTWhUYnZIQUFMckRVN2JMbjRkSll6VW9HUUwydHJq?=
 =?utf-8?B?MjRnajFjV1VXSmROYjlZblhjTGxHcGl2YVJydlF0bXNlZ3ZxVkJ5bnNFSkpq?=
 =?utf-8?B?aHVqWVdEYVBHcU9SY1NXQ3dmUXh1cWdVTjhPR0VkTGk3Y0VJYlF4d0I5QlpP?=
 =?utf-8?B?eWp3Y3FyR2w1cVJKS3NycnJhNFpzeGM1VVduczRtWm42L3ZBNUF5c0JNQ3dB?=
 =?utf-8?B?ZEU2d01aUmd0RjNoY2I5SVdCb1ZwQmpIdnUzVlYyekNXSVRjOStXLytNMkxQ?=
 =?utf-8?B?RW1YK0sxandsY2F4MCsxT212Szl3MnFEZmRNbmFNUmMvWjd5YTBIZlVhK0J2?=
 =?utf-8?B?VDZUZXJNWmtaWklNd1hFMFJ1a3lhRkxkS284eFdkQXJmQklFektwWHRzcFo1?=
 =?utf-8?B?MU5QMllLOFVJcTZ1VHUwL0lCRHJObXd0aUdtZHdtUmdYNUJxT1ZweWNZOHJH?=
 =?utf-8?B?M2R4SWxZZGpoeER4MW50UERLOEpibitiaXRUV0FMY09iUFZ5UWRRT3pTa2Q3?=
 =?utf-8?B?SE5iZ3AxZzlDM2l5KysyS0JISk5yME1peFlHKy9pa1d4VDI2WEpYdmpSLzA2?=
 =?utf-8?B?VCtHVXduNFRKRVVNOTN3Vno5Vm4vS2NPaEpsbE5mcnZrY3ZvbDVQOXZpdUZv?=
 =?utf-8?B?ZytCTDVZSzJaWUljaEcxcXZUMFdneitEbWlyNDY4QXg4OXJZTVpoR21sUVR4?=
 =?utf-8?B?V3lLOVIvd0FJN3dnYWdNOWkwZlEwVkRXaDVtZmtwcmNRSWZGbks5NWV5VDdR?=
 =?utf-8?B?RzdmU2czVUwrdzlRcEE3UDdUTTJHWldoSG95Zyt2U2N2R1ZDQXY1Ykd0Rkhn?=
 =?utf-8?B?OHBPMUk1ZHV6Y2VnZ1hhaVM4RnRiZ3FJVVBMNEtYSVh5dVgxQ25ZdEFVaEta?=
 =?utf-8?B?dENxMk5jUXRhQTQzcUNHMG1wOVh5SGhuaXJiQ0o2Ky9jOC9FWjIxb2JueEVX?=
 =?utf-8?B?elE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2E5BB7CC2AE0A46864B3D2B6BB5A457@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde8e76c-6f8c-4e75-f766-08dcd7e5fde6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2024 13:29:58.6763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I7w0X1EL9eSIuVprVbcOzBu7K4IAIqVylfJ8XQ54BU9uvnzNF6kZu37+J/05nilZZka8PJ1QCMQ/SKgBDCnCLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8619
X-MTK: N

T24gRnJpLCAyMDI0LTA5LTEzIGF0IDEwOjQxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xMy8yNCAxMjoxMCBBTSwgUGV0ZXIgV2FuZyAo546L5L+h
5Y+LKSB3cm90ZToNCj4gPiBCZWNhdXNlIHRoZSBNZWRpYVRlayBVRlMgY29udHJvbGxlciB1c2Vz
IFVUUkxDTFIgdG8gY2xlYXINCj4gPiBjb21tYW5kcyBhbmQgZmlsbHMgT0NTIHdpdGggQUJPUlRF
RC4NCj4gPiANCj4gPiBSZWdhcmRpbmcgdGhlIHNwZWNpZmljYXRpb24gb2YgVVRSQ1M6DQo+ID4g
VGhpcyBiaXQgaXMgc2V0IHRvICcxJyBieSB0aGUgaG9zdCBjb250cm9sbGVyIHVwb24gb25lIG9m
IHRoZQ0KPiA+IGZvbGxvd2luZzoNCj4gPiBPdmVyYWxsIGNvbW1hbmQgU3RhdHVzIChPQ1MpIG9m
IHRoZSBjb21wbGV0ZWQgY29tbWFuZCBpcyBub3QNCj4gPiBlcXVhbCB0byAnU1VDQ0VTUycgZXZl
biBpZiBpdHMgVVRSRCBJbnRlcnJ1cHQgYml0IHNldCB0byAnMCcNCj4gPiANCj4gPiBTbywgTWVk
aWFUZWsgaG9zdCBjb250cm9sbGVyIHdpbGwgc2VuZCBpbnRlcnJ1cHQgaW4gdGhpcyBjYXNlLg0K
PiANCj4gSGkgUGV0ZXIsDQo+IA0KPiBUaGFuayB5b3UgZm9yIGhhdmluZyBzaGFyZWQgdGhpcyBp
bmZvcm1hdGlvbi4gUGxlYXNlIGNvbnNpZGVyDQo+IGludHJvZHVjaW5nIGEgcXVpcmsgZm9yIGln
bm9yaW5nIGNvbXBsZXRpb25zIHRyaWdnZXJlZCBieSBjbGVhcmluZw0KPiBhIGNvbW1hbmQsIGUu
Zy4gYXMgZm9sbG93cyAodGhlcmUgbWF5IGJlIGJldHRlciBhcHByb2FjaGVzKToNCj4gKiBJbiB1
ZnNoY2RfY2xlYXJfY21kKCksIGJlZm9yZSBhIGNvbW1hbmQgaXMgY2xlYXJlZCwgaW5pdGlhbGl6
ZQ0KPiAgICB0aGUgY29tcGxldGlvbiB0aGF0IHdpbGwgYmUgdXNlZCBmb3Igd2FpdGluZyBmb3Ig
dGhlIGNvbXBsZXRpb24NCj4gICAgaW50ZXJydXB0LiBBZnRlciBhIGNvbW1hbmQgaGFzIGJlZW4g
Y2xlYXJlZCwgY2FsbA0KPiAgICB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoKS4NCj4gKiBJ
biB1ZnNoY2RfY29tcGxfb25lX2NxZSgpLCBjaGVjayB3aGV0aGVyIHRoZSBjb21wbGV0aW9uIGlz
IHRoZQ0KPiAgICByZXN1bHQgb2YgYSBjb21tYW5kIGJlaW5nIGNsZWFyZWQuIElmIHNvLCBjYWxs
IGNvbXBsZXRlKCkgaW5zdGVhZA0KPiAgICBvZiBleGVjdXRpbmcgdGhlIHJlZ3VsYXIgY29tcGxl
dGlvbiBjb2RlLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KDQpIaSBCYXJ0LA0KDQpT
b3JyeSBmb3IgdGhlIGxhY2sgb2YgcmVzcG9uc2Ugb3ZlciB0aGUgcGFzdCBmZXcgZGF5cyBkdWUg
dG8gdGhlIA0KTWlkLUF1dHVtbiBGZXN0aXZhbCBpbiBUYWl3YW4uIEkgdGhpbmsgdGhpcyB3b3Vs
ZCBtYWtlIHRoZSBhYm9ydCANCmZsb3cgbW9yZSBjb21wbGljYXRlZCBhbmQgZGlmZmljdWx0IHRv
IHVuZGVyc3RhbmQuDQoNCkJhc2ljYWxseSwgdGhpcyBwYXRjaCBjdXJyZW50bHkgb25seSBuZWVk
cyB0byBoYW5kbGUgcmVxdWV1ZWluZyANCmZvciB0aGUgZXJyb3IgaGFuZGxlciBhYm9ydC4NClRo
ZSBhcHByb2FjaCBmb3IgREJSIG1vZGUgYW5kIE1DUSBtb2RlIHNob3VsZCBiZSBjb25zaXN0ZW50
Lg0KSWYgcmVjZWl2ZSBhbiBpbnRlcnJ1cHQgcmVzcG9uc2UgKE9DUzpBQk9SVEVEIG9yIElOVkFM
SURfT0NTX1ZBTFVFKSwgDQp0aGVuIHNldCBESURfUkVRVUVVRS4gSWYgdGhlcmUgaXMgbm8gaW50
ZXJydXB0LCBpdCB3aWxsIGFsc28gc2V0IA0KU0NTSSBESURfUkVRVUVVRSBpbiB1ZnNoY2RfZXJy
X2hhbmRsZXIgdGhyb3VnaA0KdWZzaGNkX2NvbXBsZXRlX3JlcXVlc3RzIA0Kd2l0aCBmb3JjZV9j
b21wbCA9IHRydWUuDQoNCkFzIGZvciB0aGUgU0NTSSBhYm9ydCAoMzBzKSBzaXR1YXRpb24sIGlu
IERCUiBtb2RlLCBpZiB0aGVyZSBpcyBhbiANCmludGVycnVwdCB3aXRoIE9DUzpBQk9SVEVEIG9y
IElOVkFMSURfT0NTX1ZBTFVFLCB0aGVuIHNldCBESURfUkVRVUVVRTsgDQppZiBub3QsIHVmc2hj
ZF9hYm9ydCB3aWxsIGFsc28gcmV0dXJuIFNVQ0NFU1MsIGFsbG93aW5nIFNDU0kgdG8gZGVjaWRl
IA0Kd2hldGhlciB0byByZXRyeSB0aGUgY29tbWFuZC4gVGhpcyBwYXJ0IGlzIGxlc3MgcHJvYmxl
bWF0aWMsIA0KYW5kIHdlIGNhbiBrZWVwIHRoZSBvcmlnaW5hbCBhcHByb2FjaC4NCg0KVGhlIG1v
cmUgcHJvYmxlbWF0aWMgcGFydCBpcyB3aXRoIE1DUSBtb2RlLiBUbyBpbWl0YXRlIHRoZSBEQlIg
DQphcHByb2FjaCwgd2UganVzdCBuZWVkIHRvIHNldCBESURfUkVRVUVVRSB1cG9uIHJlY2Vpdmlu
ZyBhbiBpbnRlcnJ1cHQuIA0KRXZlcnl0aGluZyBlbHNlIHJlbWFpbnMgdGhlIHNhbWUuIFRoaXMg
d291bGQgbWFrZSB0aGluZ3Mgc2ltcGxlci4gDQoNCk1vdmluZyBmb3J3YXJkLCBpZiB3ZSB3YW50
IHRvIHNpbXBsaWZ5IHRoaW5ncyBhbmQgd2UgaGF2ZSBhbHNvIA0KdGFrZW4gc3RvY2sgb2YgdGhl
IHR3byBvciB0aHJlZSBzY2VuYXJpb3Mgd2hlcmUgT0NTOiBBQk9SVEVEIG9jY3VycywgDQpkbyB3
ZSBldmVuIG5lZWQgYSBmbGFnPyBDb3VsZG4ndCB3ZSBqdXN0IHNldCBESURfUkVRVUVVRSBkaXJl
Y3RseSANCmZvciBPQ1M6IEFCT1JURUQ/DQpXaGF0IGRvIHlvdSB0aGluaz8NCg0KVGhhbmtzLg0K
UGV0ZXINCg==
