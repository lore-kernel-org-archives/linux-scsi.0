Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA69450F2;
	Wed, 18 Mar 2026 01:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773798120; cv=fail; b=YiyZAd7AFTjdTGdjB6QHW8Fh5s+sC6LsCQxwpCIJKoXPwgQsAd8sSUjmqMJuOD7bxcxjPxCcGelDY+0JerDWOvm8WmfvfLJA7U6v9kRUTsRazAME9DjDXAo7EBsMzGT95T4feV+TU4UKWBEcTmAHlR23PIrUSydXW2mz3pIVedw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773798120; c=relaxed/simple;
	bh=SXa5ctLZxhnLmibkrnT95+A0UvRftv7xs4wjZY7KUeY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TguONrE5fZZgpVbmWZdrUYkd8NB1p+r18vJTrxkus2/KDQ1UTJpaE38pPByx5kSOFKqR4snFRPfl8znpRMXXhpdgQP3XlYUVcz16xqNVzG6xS4hLrTYNwZDZb3B8kGr0Ob7BUvOIcXamyzli9i1EFSPH8IXGzl5Ww/uzy2KDtOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=N96XsYob; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=bnOSzlRz; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="N96XsYob";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="bnOSzlRz"
X-UUID: a21b5a76226b11f1a39cd589f645bc18-20260318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=SXa5ctLZxhnLmibkrnT95+A0UvRftv7xs4wjZY7KUeY=;
	b=N96XsYobWYvTGmBwjTt6RNC7IuZo8nzA3Tuq0MvL86j1AYIIA5gd3slZgWvT53xXN34n62g6OagMgC9qYPX/ei9SZTD3/+UBY39BqxljlNf/HC+DX6rt+IE8XkemApHdpVs9EeJwILbsjNswCSB1YPeksIG1e07hHgy+WmUIHac=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:aca4d307-d5b3-4c42-ae9b-ed472c85e955,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:fe36d7d4-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a21b5a76226b11f1a39cd589f645bc18-20260318
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1226046991; Wed, 18 Mar 2026 09:41:50 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 18 Mar 2026 09:41:48 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 18 Mar 2026 09:41:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jHP9Zb7OymCxvp9fj526983lDJlk7UQhprF/w4JhXJNWQtBStBqKS7CvWvo9S5WZ7wEECWxItcnzyosx79tPl00blWDbbsOozz9TZ2Vfst5qKa5iVIqlrG027sp7M28djlgXslDB6v4iaJUCNelZy7pUq/nKDMZWdFKOg0b+mLZA1hSI368gHRODJ7rZHXMtOpX9jC0yIkwcnjHMdOy33B6YeFMGRVew16Qo/hxs85ULXZrv5ul7to6Xtq6qef3IAzeJRu+H8tkfEqFWodT+PwdcAm1qZormm1TAXN+Mowty9p2MFOZOvvA4hE6KAhhqdME/oFdiFU0f4t/feZeXhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXa5ctLZxhnLmibkrnT95+A0UvRftv7xs4wjZY7KUeY=;
 b=Oi/1T8JGlsT/uA0xvzkIhspUzG7BU/VPDZniQrdb2k+DTQdF9dXxm0g/F/lwfFfpNbzRV7f2uOdrC0+qH8NwMMmI8gCi5y1rYJNy4gllTNHAwWBx6h6zR0h1oFA8br4nLzGTeYYgWj47fqzvugTAo8DG0Hch0RphAIA7y0JwcQXxTJL5uHT6UKaaaMHETtNRjGPK9zIBe/Mzeo9wnXlIOJRQhudXRTQUMnIexOL37Mb39dXNgTSokj9kEgUD4C4svJdM6Fm9rOXZXTHPadSCb+zxaRKV8Tzxn9vCHfMCbBmn1Y5wT5r8dGtCLT2NRauZ3UwfYKGS2rqwUfWQwq53QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXa5ctLZxhnLmibkrnT95+A0UvRftv7xs4wjZY7KUeY=;
 b=bnOSzlRzmVIOI5TXGi07GpgQ0aqoZYUxzNz64mkiLNafa2m4vaDTq3c7x8a8aEptLoLMwe/Jhu0Q0YHOzaqaMpDZrpkaKtyzf9XiUgO6pil0pPDADO1mwmDcmXGLVRyLn5FD+tdHGzrE1DPfnbVjXJcLRcou4PkO6iMAgjdvpps=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by SI4PR03MB9890.apcprd03.prod.outlook.com (2603:1096:4:29c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 01:41:46 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::8d8a:2d79:b170:1ec4%6]) with mapi id 15.20.9700.025; Wed, 18 Mar 2026
 01:41:46 +0000
From: =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	=?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"kishon@kernel.org" <kishon@kernel.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "robh@kernel.org" <robh@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"kernel@collabora.com" <kernel@collabora.com>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>
Subject: Re: [PATCH v9 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Thread-Topic: [PATCH v9 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Thread-Index: AQHcrW0pm8iGWFNpK0Kj80iCAtmXpbWzleeA
Date: Wed, 18 Mar 2026 01:41:46 +0000
Message-ID: <1cd0e29d03e7a75d124d0d90b4727547fd162724.camel@mediatek.com>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
	 <20260306-mt8196-ufs-v9-20-55b073f7a830@collabora.com>
In-Reply-To: <20260306-mt8196-ufs-v9-20-55b073f7a830@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|SI4PR03MB9890:EE_
x-ms-office365-filtering-correlation-id: 71aaea59-bfdb-4b91-b340-08de848f8411
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|56012099003|18002099003|22082099003|921020|38070700021;
x-microsoft-antispam-message-info: Nu3tSWQvnHrIboT6bLDBBRlDyL23O32Le+1C2xOPoq5cqMzC1q4KFv6AmnENoDLUlrBWMCZz8KQyJgVXZQTuvLzF1ZK/Hf6xr4e+NaQz2AtPAYt0ywvWgdfm5+TFf1gqm6gjCc60ukiugpfHNYNeecaW2FNPNtRLz+DDdMp4xI1qn8Jpv36cm/iW1lSGSKoJ2wIOZSZtDbIdk7rcmkjAHcR4AqQEeGPgRjLsjOjuPW3DGapNktth9/27T1RcM0GzN5xzmGxAUqqPSNdtbrlLA8RuO0X8shxIxg9+mtg8tN1xmyuCDgZNCx24jBjCy92YzfwUJ8oG9GuFq8W40a6N4KwriM3dbuQbSchHAtEpZNAbAuGd2w+jVGpO/mnjI1Kqos51fBcMcvnEbK10Z9ZUdoPDG/pGyTNKYP5MzeMbdORy+3riGtgS0UvAJSjErjoU6/jP8ii+RiYpGAe5GIZaBxhyQ4F+kBlQ5APj0JIZwY8wIq5qcxjqMr2jSXeESTk3fip8fdyJ4EQpmC7K6ZvlGVU5xxvqFn5WPd3LEUUsuHiUMwuwOTGcHaodHKsJVb49gIPfdWVNfJES4j9mQqOQmlpiXF144rTtRKhXws376jHRgyp2PJvDC9jgbk1jcf6fQFfITxwmgl4B8g9v3R5l6gye6P/oqOswTvdTY/1kCYnQH6HzJEhUfzu1x7LM9677YOrTCOBFSPulJa7O+q3REOT/SXi1X2DHaCh01W9YKv0kroPuUOGLhEAdNZftNguv2OToQRisZ3fOzS8t2M95WHNc+mJI2gyhfdbWh4kO+izxvOk5CrJIuo0wALZC/1Xy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(56012099003)(18002099003)(22082099003)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2w0ODZURmhrUDg2dlpnNHFmRUd6cWtTeDhpdXhLWE5wSDFuVk9GS0RUUU9l?=
 =?utf-8?B?L1lVUTVXbUh5amVPbENZNlRkdFNpUGl6SWU3SEtqb3A1aGlUdEtRcHhHQUxz?=
 =?utf-8?B?MnZuclhOdHA5WmNSQXk3Mnc0Z2JYemFFUjVjU3k4Sm4zKzN3aVIrMzBHc0Zs?=
 =?utf-8?B?dUJtWDk1b1k4YWVQQVVYb1BBdTN3ZXdwWi9ZMG0yeFBDaDBSUlJQUjNKeFFB?=
 =?utf-8?B?ZVkwVmdsSlM4YTlLRHdaTXFMMm5sL2lyWkl6WUF4ZXNCTWNjK0JOVHN5ZWxP?=
 =?utf-8?B?YjduRU1CWmVWZ25EODdoNkpnWjRuYW1oYVNZMzVyUkloNGpKQWVSSjc3c3BK?=
 =?utf-8?B?RDFmSjA4UVhrMzFJa1BjaXVZZ2x0MmZPNWtzVm53NWZ6aFhxWHg4d1B5eFpH?=
 =?utf-8?B?eU8xcEQ0U3BHdlhzandmNHMyejc5ZERKUmN6K0dYYTRPYVYweENPTFVQUTRE?=
 =?utf-8?B?Q0tFeGtKOGVycU9sZGhkcVNaMlUrdkIvcUlZZkpkanR2M0J3RGowWC9CbUoy?=
 =?utf-8?B?NGpwQmY3RG5Ha0syMlZBNm5BcUsxS0ovWndibFZuRkJJR0I0SlpDZTZSYVNm?=
 =?utf-8?B?V1I4YjgrRHgramxVMTNzcC9FcTVXZ0ZKc0kreGJzdWdJVWZvS256NU83QldZ?=
 =?utf-8?B?aHJJMU9XN0JzQk1IOGwrQXJmSzFsNEZiZHEzN2t4VTlzb3g0eUR2VXplM085?=
 =?utf-8?B?Wm9hTXI3bFJubGpxYlNBMk1Xc3FwRW0wdDdrYllpdFl4bzlqVXF2WGdpM2l1?=
 =?utf-8?B?dVhIeCs0WjlnelFJaHhVbmFXK05pMlVNVlhnaEZIWSs1cFBYa0d5dVdhQUxh?=
 =?utf-8?B?L1RidTJJOTdIeHJDYjRrMUFGQUEzS2lHZWgzZkp4VU9TdWlaWEdsViszWmdJ?=
 =?utf-8?B?TzRGLzdHbFR2TFpvV3dMLzJNTmtUeWFid01aajlxa1pUUDlvNmR6K2VFYU9W?=
 =?utf-8?B?SGlqc2hHYXYrbWFybE01Q1lkYkZ5RUVCNzNrYzhzUndmYUExbm9ob1JXRUMx?=
 =?utf-8?B?NGs4eUZyd255elNKQmRIZDVUenBDMElxampyWEQ0QXpiRnJFV1NkeFQwRkJD?=
 =?utf-8?B?bGxmMHN3WmtkVHNZYnRFd3B3QXBZRWF0WWdOVDRLTWFma0NJSnM4YnFmcVpX?=
 =?utf-8?B?Q1p6bGIvNnFDK2FIaGpKZ1JqVjBPNytTcjBzK0tvdlEyNXpGKzJmRzR5eUpa?=
 =?utf-8?B?MTYwQlhGQ0t6Wmx2YXJzSUVpbS9YK1BxT1F3QUJsdzZaWE1MaDh5a05LVGZ2?=
 =?utf-8?B?ZmZjT2dIcFlSb2VjUzZUenY0anNmUXFkMDRMN3FROXEwY0UxY2loQjJpWXc4?=
 =?utf-8?B?cWVHQUEva0VJN0tZNVQwNzlkZ0RLRHBrTUJpRDdkTnZ0STdFaGlYZmxvbm5J?=
 =?utf-8?B?UW42Q2hxL1lNMWROeWpIcGlGbjdQTU41ZWczVW5VSEc4ZWpXS0g2UnpzNFU5?=
 =?utf-8?B?cFpiTVM4KzgvRFpoWmMrejVtMW83dUp5ZmZTWDdEa1RsNWFYUTg4c2lVK1hp?=
 =?utf-8?B?TkVQVUNLVVVqN0d4OGduZ1VpR1JxdVkzbUlyNjNqbHBRc1dlaUV5N3lXZ214?=
 =?utf-8?B?UTBoN0lXV3hLR0tlT3JFZkJNYTNYeTNOSlo1QzIzbjNsZlU5K2EyeXFSTmVa?=
 =?utf-8?B?UFh2MnlQNGdWMTJUTU90cWdtcjI5eVlFR1d4dVY4YWFValdmK1BtdFMraHVC?=
 =?utf-8?B?R3U4MmNTSFhSS3BnTXN0S2NMb2lyelF2azN0MHFtbGdLVE0rVzk5bXc1QWNM?=
 =?utf-8?B?RWtlV09QU2lRNVU5MDBxL2JOTFdOcVRPbG02cERmUnFCaFdiZ3pwYlRvR1Vm?=
 =?utf-8?B?bDVhL0s1WUV4RTRCa0U0ZlN2L3M5OWxBZS9XRmpqZTVwbVljZE9wQkpnN3Ux?=
 =?utf-8?B?V0UvRmNLbEYzVGRsYzlOQnNKZXlGOE4xMVorVU5GRFhnelZObFIvd211VCtn?=
 =?utf-8?B?Q1Y1Z1Y3ZStTaTBoNGRmRlhpdkM4WGFoajJwOFkxUGxUYkR5WXpqUndCOENE?=
 =?utf-8?B?M0xiZUdseUY5emZFZVVESTlqYUR0aGhNb2RtMndPeDQ3QU41VTZqaWg2dDN2?=
 =?utf-8?B?ODJTMU5zZEliT0M3aHBjS0JtSFZYMksxanJBcnI0TUZNWTdJRW5KdUpRWHBt?=
 =?utf-8?B?T0l2aEtZdmNzd2EyUktiRkszY3VJOFZRMkJqTGtUVTVjUEh3OVRzWWxVMURk?=
 =?utf-8?B?MVV1djhodHJJL3IzaTAzbkdoY2dtQkkzL1lLOXcvbi9IWGpxdWd6U3lJSXZU?=
 =?utf-8?B?NVY3YjNXdmF5MCt6bTNEUXp2ZVVYMUIxNEZqOGp4b0c1MXRWN0c0aFRqWjh6?=
 =?utf-8?B?OUd6WEQwZHJlRGFqOFE1V1lvM0ZsdTNHY043TStVQnQrTHdNZ2RPVmVla3F4?=
 =?utf-8?Q?NTQMVWKx2sERv8GU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0964CD06EDCEE742A451930E579AA685@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: fKm1be4BO+4nn/6bFvkER+wH2zE61Obw6gopepLAOx/EogCuCha2GcV8vzb9QyesN6CnKd4+Z3bf3n4AlgNJCr4KzqpBnay8HGkRjJQhFpReI9YdW4kngnidLuqBs/ZYBruc+gSkX1m4KlhtAZM37ldHMyN16J2Vh/qQxUUR7A1e2rRRJQ6LBNmvWL8R41l05NBBZhEU5Eaqe2T2lPkzknRddxf3z5saa9Q5EwSzAy9kCFWzm/UsaJRWrT9PlRORe4XOFVywR77LhkySPue9Ik/C/mC4V7GtyWRDKzd4TxRZyFF8fe1H7bzpSA5/9PEl2RPkf9n6KHSdHHB2JM8aJQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71aaea59-bfdb-4b91-b340-08de848f8411
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2026 01:41:46.3974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: opPdTKmei0TyKt7+wji907CFeN59cWD6zTkdLHG5HGhScaprCKgG0JrjAGZVPN2G2YHyuh8JqpiFwmdbTUizWro71w0drcbbwuqa8GoBS7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI4PR03MB9890
X-MTK: N

T24gRnJpLCAyMDI2LTAzLTA2IGF0IDE0OjI1ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoZSBNZWRpYVRlayBVRlMgZHJpdmVyIHVzZXMgYSBmdW5jdGlvbi1zY29wZSBzdGF0
aWMgdmFyaWFibGUgdG8gYmFjaw0KPiB1cA0KPiBhIGhhcmR3YXJlIHJlZ2lzdGVyIGFjcm9zcyBh
IHBvd2VyIGNoYW5nZSBpbiB0aGUNCj4gdWZzX210a19wd3JfY2hhbmdlX25vdGlmeSBmdW5jdGlv
bi4gVGhpcyBpcyBkYW5nZXJvdXMsIGFzIGl0J3Mgb25seQ0KPiBjb3JyZWN0IGlmIG9ubHkgZXZl
ciBvbmUgaW5zdGFuY2Ugb2YgdGhlIGRyaXZlciBpcyBsb2FkZWQsIHdoaWNoDQo+IGlzbid0DQo+
IHRydWUgaWYgdGhlcmUncyBtb3JlIHRoYW4gb25lIGRldmljZSBvbiBhIFNvQyB0aGF0IG5lZWRz
IGl0LCBvciBpdA0KPiBvdGhlcndpc2UgZ2V0cyBsb2FkZWQgYSBzZWNvbmQgdGltZS4NCj4gDQo+
IEJhY2sgaXQgdXAgaW50byBhIG1lbWJlciBvZiB0aGUgaG9zdCBzdHJ1Y3QgaW5zdGVhZCwgYXMg
dGhpcyBzdHJ1Y3QNCj4gaXMNCj4gcGVyLWluc3RhbmNlLiBSZXdvcmsgdGhlIGZ1bmN0aW9uIHRv
IG5vdCB1c2UgYSBwb2ludGxlc3MgInJldCIgbG9jYWwNCj4gYXMNCj4gd2VsbC4NCj4gDQo+IEZp
eGVzOiBmNWNhOGQwYzdhNjMgKCJzY3NpOiB1ZnM6IGhvc3Q6IG1lZGlhdGVrOiBEaXNhYmxlIGF1
dG8taGliZXJuOCANCj4gZHVyaW5nIHBvd2VyIG1vZGUgY2hhbmdlcyIpDQo+IFJldmlld2VkLWJ5
OiBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubyA8DQo+IGFuZ2Vsb2dpb2FjY2hpbm8uZGVscmVn
bm9AY29sbGFib3JhLmNvbT4NClJldmlld2VkLWJ5OiBDaGFvdGlhbiBKaW5nIDxjaGFvdGlhbi5q
aW5nQG1lZGlhdGVrLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTmljb2xhcyBGcmF0dGFyb2xpIDxu
aWNvbGFzLmZyYXR0YXJvbGlAY29sbGFib3JhLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9o
b3N0L3Vmcy1tZWRpYXRlay5jIHwgMjAgKysrKysrKystLS0tLS0tLS0tLS0NCj4gIGRyaXZlcnMv
dWZzL2hvc3QvdWZzLW1lZGlhdGVrLmggfCAgMSArDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDkgaW5z
ZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91
ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRl
ay5jDQo+IGluZGV4IGM0ZTcwZmI5OWU4Mi4uMjE5ODI3MWEyNjlhIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3Qv
dWZzLW1lZGlhdGVrLmMNCj4gQEAgLTEzOTgsMjggKzEzOTgsMjQgQEAgc3RhdGljIGludCB1ZnNf
bXRrX3B3cl9jaGFuZ2Vfbm90aWZ5KHN0cnVjdA0KPiB1ZnNfaGJhICpoYmEsDQo+ICAJCQkJY29u
c3Qgc3RydWN0IHVmc19wYV9sYXllcl9hdHRyDQo+ICpkZXZfbWF4X3BhcmFtcywNCj4gIAkJCQlz
dHJ1Y3QgdWZzX3BhX2xheWVyX2F0dHINCj4gKmRldl9yZXFfcGFyYW1zKQ0KPiAgew0KPiAtCWlu
dCByZXQgPSAwOw0KPiAtCXN0YXRpYyB1MzIgcmVnOw0KPiArCXN0cnVjdCB1ZnNfbXRrX2hvc3Qg
Kmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCj4gIA0KPiAgCXN3aXRjaCAoc3RhZ2Up
IHsNCj4gIAljYXNlIFBSRV9DSEFOR0U6DQo+ICAJCWlmICh1ZnNoY2RfaXNfYXV0b19oaWJlcm44
X3N1cHBvcnRlZChoYmEpKSB7DQo+IC0JCQlyZWcgPSB1ZnNoY2RfcmVhZGwoaGJhLA0KPiBSRUdf
QVVUT19ISUJFUk5BVEVfSURMRV9USU1FUik7DQo+ICsJCQlob3N0LT5haGl0ID0gdWZzaGNkX3Jl
YWRsKA0KPiArCQkJCWhiYSwgUkVHX0FVVE9fSElCRVJOQVRFX0lETEVfVElNRVIpOw0KPiAgCQkJ
dWZzX210a19hdXRvX2hpYmVybjhfZGlzYWJsZShoYmEpOw0KPiAgCQl9DQo+IC0JCXJldCA9IHVm
c19tdGtfcHJlX3B3cl9jaGFuZ2UoaGJhLCBkZXZfbWF4X3BhcmFtcywNCj4gLQkJCQkJICAgICBk
ZXZfcmVxX3BhcmFtcyk7DQo+IC0JCWJyZWFrOw0KPiArCQlyZXR1cm4gdWZzX210a19wcmVfcHdy
X2NoYW5nZShoYmEsIGRldl9tYXhfcGFyYW1zLA0KPiBkZXZfcmVxX3BhcmFtcyk7DQo+ICAJY2Fz
ZSBQT1NUX0NIQU5HRToNCj4gIAkJaWYgKHVmc2hjZF9pc19hdXRvX2hpYmVybjhfc3VwcG9ydGVk
KGhiYSkpDQo+IC0JCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgcmVnLA0KPiBSRUdfQVVUT19ISUJFUk5B
VEVfSURMRV9USU1FUik7DQo+IC0JCWJyZWFrOw0KPiAtCWRlZmF1bHQ6DQo+IC0JCXJldCA9IC1F
SU5WQUw7DQo+IC0JCWJyZWFrOw0KPiArCQkJdWZzaGNkX3dyaXRlbChoYmEsIGhvc3QtPmFoaXQs
DQo+ICsJCQkJICAgICAgUkVHX0FVVE9fSElCRVJOQVRFX0lETEVfVElNRVIpOw0KPiArCQlyZXR1
cm4gMDsNCj4gIAl9DQo+ICANCj4gLQlyZXR1cm4gcmV0Ow0KPiArCXJldHVybiAtRUlOVkFMOw0K
PiAgfQ0KPiAgDQo+ICBzdGF0aWMgaW50IHVmc19tdGtfdW5pcHJvX3NldF9scG0oc3RydWN0IHVm
c19oYmEgKmhiYSwgYm9vbCBscG0pDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vm
cy1tZWRpYXRlay5oIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmgNCj4gaW5k
ZXggZmEyN2FiNGQ2ZDZjLi4yMzQ5ZDliOTM3NWMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZz
L2hvc3QvdWZzLW1lZGlhdGVrLmgNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWsuaA0KPiBAQCAtMTg3LDYgKzE4Nyw3IEBAIHN0cnVjdCB1ZnNfbXRrX2hvc3Qgew0KPiAgCXUx
NiByZWZfY2xrX2dhdGluZ193YWl0X3VzOw0KPiAgCXUzMiBpcF92ZXI7DQo+ICAJYm9vbCBsZWdh
Y3lfaXBfdmVyOw0KPiArCXUzMiBhaGl0Ow0KPiAgDQo+ICAJYm9vbCBtY3Ffc2V0X2ludHI7DQo+
ICAJYm9vbCBpc19tY3FfaW50cl9lbmFibGVkOw0KPiANCg==
