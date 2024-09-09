Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863DEBA42;
	Mon,  9 Sep 2024 03:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725853266; cv=fail; b=fxBMWvfJqNmaxDNDczvocv2pi8yz0nVKJkPtNZhgylplDBfvgn/ZZ98D7VrHcVfmfRbvlK1vUFgfn4/p+TFFnRtBhIihxhtE/4JczW1ipoXDh+tkNxP38qLDSHCamglbnPnMsnQYhbP26JbcCkrRL+iNjN3oEIRhWbGSCWAa5dA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725853266; c=relaxed/simple;
	bh=8a863gJoj3SrkwJCVfVYe+xd1dm44MdWffsXJpRxYfQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fSLbTvSzntMhPAlUIB5SkILIQ593Wo7/Zsi7/3qv2k97VqqdsgED81VgrIGdGoiFGlLcCEqPY80l2Djmi7oapTQxj4j3f+1AiXARgKBzrK2vnMLf/b08+0LEfjFZ8aJXcWb9TzuLG6jcez8xc34ENKQglQEJdk+RBa5GXEcLKIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mW2H0CMK; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=cXZmeqOx; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mW2H0CMK";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="cXZmeqOx"
X-UUID: 5017e4a66e5d11efb66947d174671e26-20240909
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8a863gJoj3SrkwJCVfVYe+xd1dm44MdWffsXJpRxYfQ=;
	b=mW2H0CMKZZtFPSTxqiCqUx85SJrhOiJQF/K9JKu8rdYo2KPukfZJeYgjPh3LiBdoJ0VnLmGye1C+/QSH7EEoBgNbQADnvN3a66qmwa2rpeIXCU7BpKzXJLl8FoMqqfzesv8/i4cHzDo3wuMjDI3G0ilfl5SkVhgdVHvtkPO5G1E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:e7920e6f-c32c-4074-a98f-6e6c778159c8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:db236405-42cd-428b-a1e3-ab5b763cfa17,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 5017e4a66e5d11efb66947d174671e26-20240909
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1059057033; Mon, 09 Sep 2024 11:40:52 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 9 Sep 2024 11:40:51 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 9 Sep 2024 11:40:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bb4SQE92MfImuHCQpQu7aN7VHscfXM/0B4GvBx87g2ZmDng5I9F/hMggdKD8dlxBiF8wdRrBnena0oF2/EFcLwkLFZa0wjHxz1uCaaibynKBYG/+iqGz7jVoKPj0sxejEqPm6qY2ihVmdUSo/N4wu6yEmN0loTipnkf6969KBbnWlcqGHj7IA6UshT3FL2Tl+9PnYzdMASAByBkXmpjNN58uNeHbVvyRzAE2W1B/ARPqBy4AgT8nhXSN5cN8XOVfYnOLolluXEA+nkxYSGhGkG9PSjVAEo7tfMM7j/5rDAynMWfoZxYlz0tzgKEs3tINmvOyMOUy+3hQj9NzqASBOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8a863gJoj3SrkwJCVfVYe+xd1dm44MdWffsXJpRxYfQ=;
 b=QVlacaSfZucLDm+8LRZVflvWymNMJcfXPYscb8ipkB5D4SqAgeOgIuMflZEY8fCpXpyNAEQ2hndQqI/r7+Bt7JLl9hbnt4+B+2fySOIOfs194wRn6LzwixIY0khkH5iuHR4UZ94qi54hJZHumtC6NIn+OddbriQNyXDFkauNn6yhUUyG3gUJV8X8MDmK64ri9QCw7Ibj09zdzUMfXM/jcZ+W1KyVObj3OpXKOmCY7c4jx2eewohWOKlo1IWH6BRFQjlBTO0etigO44Z/o5sjcQgxr062wJtIxrkS6f1GKEqTjvgTRsgR1lmplJ68p08utX8zLorGOy9M2Y0ggF0Jfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8a863gJoj3SrkwJCVfVYe+xd1dm44MdWffsXJpRxYfQ=;
 b=cXZmeqOxLsKfxUG/aMMMSB8KuOGAy0zn+6aS9J9FrQQXUkwHCiKISz0WRXwiv+TpUEDF7iTFPJPsxuRYWE/WXTzC5qwB2zfj3e0N3dDOjzz6Yki7piGy9PWi9rhWMa94AvM9rcUb9IUIDoYjGhuWLMvhWDO0NA4Zag39f79i9AM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8504.apcprd03.prod.outlook.com (2603:1096:604:27a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Mon, 9 Sep
 2024 03:40:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Mon, 9 Sep 2024
 03:40:47 +0000
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
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v2 2/2] ufs: core: requeue MCQ abort request
Thread-Topic: [PATCH v2 2/2] ufs: core: requeue MCQ abort request
Thread-Index: AQHa/N6Q1tN2DeiWQ0arLPbS+geXybJJuA8AgAUiTwA=
Date: Mon, 9 Sep 2024 03:40:47 +0000
Message-ID: <e31f180a8e78efbbab1a9a4cb5c83478f2bf4516.camel@mediatek.com>
References: <20240902021805.1125-1-peter.wang@mediatek.com>
	 <20240902021805.1125-3-peter.wang@mediatek.com>
	 <b31bf24f-588e-43e5-b71f-b4e9edd1b60a@acm.org>
In-Reply-To: <b31bf24f-588e-43e5-b71f-b4e9edd1b60a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8504:EE_
x-ms-office365-filtering-correlation-id: 9a78884c-66b9-4fe8-c73a-08dcd0813178
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cUQrSXNVVUlTSmx4QU43aGFIeVVDd2N4aDkzSFJUdUVwSXV3ZENMNzR6K3lM?=
 =?utf-8?B?b2VxNzhJd1cvMWRqTWUvOTBrZmxVMU5KbEVIUVVnOGZnV3NYTTZaNCtkOFpE?=
 =?utf-8?B?TzlFOXRGTzNsSGNVTGgwNnZ0VWh4Y1BCbkZZT0ZHQjhHTXpoNmZmTjNYVkEx?=
 =?utf-8?B?NkxSK2pZdzhhU1o5TGkyZE5HSk1BMy8yd2s2YWt4aW00SVp6dGJsYzVMKzdO?=
 =?utf-8?B?dzBRWGlHdEZsaTEvNTRHQVBTVVVmdjEyMHo0citjR0t3RXlkZjNTQ3crWjBM?=
 =?utf-8?B?WFVaTjliK0xVNHNzRGRGZjM0NU5NRUV2UzQxQ3paLzJENFR1MVRiMGg3UnQ5?=
 =?utf-8?B?RnE4Sjh3UFRhWE00eFhsTzM2a04rTThYQ0Z3Ym5qeFYvNkZnaXd3TnpOcnZG?=
 =?utf-8?B?UGRIY28rUDhtTFhNeEdaVGJnak1PY3h5QU1iWTVlWXNJNG9tY1dDZ1duYVg5?=
 =?utf-8?B?OEhBMEV6bkxDSzdsdDgvK0Y5SEhBOG1BUHl0dU9kNWN3bGN0Ui9aWHhjY0Ro?=
 =?utf-8?B?eGFhWStQa2VJalhydEs4MmJjN3hlTUN4SVdhalJWZ3N5MWorOThqTHczcm9K?=
 =?utf-8?B?SVRvc0RaUDdrV1g1c3FWUGQ0OGlUZUhBbWhKbUR6d3g2eS9SVEVPeE90NWdI?=
 =?utf-8?B?WFdDOVBWa2thd3Fva1B0Ulo4dThWSlBuQjVhUDRzcTNzNVVHL0hvMXh1NWpv?=
 =?utf-8?B?RXhBbTh5a2paV2pzZThJcU5IU3o4WWg4NFkzVnIzaWVYTXg0Tk5yU3kvaC81?=
 =?utf-8?B?dEp5VU1rUEZIc2pRK1BuSitGY3d5QnRzZTdjTDhyWWFYQ25qY0NWS2U0VmhC?=
 =?utf-8?B?Nnd2WDFzaGJ4T1hMYUZtQUdaUGJxUEl5WVRHVHM1bDI4dFNJTS81ZEVmZ21r?=
 =?utf-8?B?RjYwVW9aOGNNeGdUYnJQUVUzVGlJWlhNa3BqVlZSWGQyVFRENEs0Y0JNQ0ZS?=
 =?utf-8?B?N21nSk1YZ3MzTFBFT0UwaG1tQTBaa1g0ZUZDTGowdVY5aE83YlJxY0FMWHdM?=
 =?utf-8?B?dU5YNVJpQytDMVZMUHZhQkxibWhWVEFUZXh2TkFjWjhtUkliTEpVTFAxYkMv?=
 =?utf-8?B?dVB2aS9QUWsvc1JMczg1bzJNSlRIOXI4YjF6dE4xdDE1SGUxQjNZSHRzMFNm?=
 =?utf-8?B?L3AyQnZzQU1BNWUvRTUyb0dRNWNrQnFYTDJuc3BVVlZYYWJTaHJmSkdmUWVa?=
 =?utf-8?B?SXJPT2NXaHlRNHZsekRrTzQveW02eTJ3UG1GTDR5aks2K2FGVTlzL1FYTjBk?=
 =?utf-8?B?ajJ0QmZqOFNBZ0FoNDB6ZVMzYml1T1MvSHNpY2VaL1Z4elhNMUdUT3BMOENm?=
 =?utf-8?B?d2N5YUlhL0czUnZtNC9EU3lnZ2Jld3FKdk05Yjh1OGxUNGlVR09QTGFlcmZp?=
 =?utf-8?B?MDNXS1N4dUlRV1Rpdkt3MFlPS2xXRUhYeWRIcnRTcGNBbkZNVm1nZFR2ejY4?=
 =?utf-8?B?dk0zQXBUL3F5ZEU2MVFuWEdxOFFZNVlLbUhTSWlWNnNuM2tFL2dtT3dseHlp?=
 =?utf-8?B?Z2RpemVkTTZVaDdsZTJVZFJyU3MrY0xaRjNsbXRKd3hLdnVCN2dMeDJtU0Zi?=
 =?utf-8?B?MFBpR293Um82K1hjYVE0Q1NLZCtFODRoZ29BVkEyMXdHWmY0OVU5a3NqUUtF?=
 =?utf-8?B?czE2TnZPYzNTdFE4V1JRNktiNHh0bEVtUHlxMXJKWHVYaGJnZVVHNGoxSklO?=
 =?utf-8?B?bklkbGxiSmFsVWpDblIzN2NUSkNVVCtGVnhiUmhMVGoxaHFDRE9sM242eXZT?=
 =?utf-8?B?WUttbTJCb3FWZjQyY3NKeldTVmZ1R1NGU0U2ejZmaUlMdlJaay9MdTJrMTFD?=
 =?utf-8?B?UUEzVXRiNG41OGZxdUJ5ZUJ0WVBmUG5xME50K0FzajhLdnordFNpM2JKdm9O?=
 =?utf-8?B?ODRkRHJoV0I3VjVnZ1IxNXJlTU85bzFCbTZ5dE91dFYwUFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEd6NGFTNk0zMmkvSlVaRm9wb2NtU2pmTE5IT2p2Wm55MUIxOXFscmVBYzRF?=
 =?utf-8?B?QnNRNFBHN01VQnJYQ21CQzRVQ2xZV3pwd0JabytYRmtWNEczZUtnQXJIbzZ2?=
 =?utf-8?B?dDNxUGtEanBIdGJ5V2QyWURCVlQ0UFpXSWFmTytINTBOS29OOGhMQUx4dis2?=
 =?utf-8?B?QkRQOUpJMjhBTUlRb0x6ZUVWcXgvaGxWYktzbjVMRkdNOXpPZDZDMmdlR0hO?=
 =?utf-8?B?WHpnekhRNEtYSC9pRU5IOWNpYThGQVB0aU5qdnVPZ1h3N2pGSEswd1U3NU9l?=
 =?utf-8?B?eEFwdmY4Q09lRzB2V1ZCZnZHc2FEOVU1dVBHU2NBZFBjRzA5MEdQWTBWQTRm?=
 =?utf-8?B?eXRpZmkxYzRJR25wRC9HRlFQTWlSdlVyYkpDYm1xTWtNOHZKVEt1dTBtTURx?=
 =?utf-8?B?cDd6b0t5Q0RGMWs3L3haQVM0emYwYUVOVHYrc3hxOVQxUnoyMTVNSFBsaCtD?=
 =?utf-8?B?Zjh6MURpNVl1TXViSUlzMy9pS01xbEozdDkzS3NyR3NoMlh3SHNINi9QUGc1?=
 =?utf-8?B?SlAwb1FpYTg5bGpwWkJBUDdWOTIrd1diRUFLZVA1YSs3RG5wMTZTaTdOb2xT?=
 =?utf-8?B?NHBseE95QnVKOG1ZVXV6ZXRGMFZGdzZic1RuWDU0SnpFTVVNMVU1bktkRVpE?=
 =?utf-8?B?ZDhyK0I2ZzRsclJpRGpCeUJ4cVRBNkNpTGZHbG5ScU5CR05IbHp4K2N6RGhQ?=
 =?utf-8?B?Qk14WVdvSUJYbUR1dTdlWHAxK1JnZktmd3o3VXRlQW9FZ3FqMGZTRFQvbC9J?=
 =?utf-8?B?c0VCalBGZis3UDV5RjhxT2RIYnp0K25IbFNOMmlIcEJoUjRsK0JvZkJhNU8y?=
 =?utf-8?B?Q25QUlUvaTN6UTFrOHd6SW5wS09nc1hFc3VaZWJnZkhjbFIyUDZyWkg0K2la?=
 =?utf-8?B?NDJBL3U1c2FUcFgramtCcVk1UkdhVzFrbm44VG1MYkt1RkM0V0xxT2t6U2lO?=
 =?utf-8?B?Wi82b2VrYTVYVkFKbFFmTUlFZk1aeFBNQ1ltdnUrREVVbFdXVjB6QytRc0JZ?=
 =?utf-8?B?OXU5ZVhvc3FjdHNIc2NLOHZkZjR2TkNsMDBSY3BRdFpGK29ObmhNK29ldHBh?=
 =?utf-8?B?d0s1a2hxV3hqY09IbFB5aEFvRnhFT3BqaExzNGNRTS9nOUJJcFVmeDBRd0hG?=
 =?utf-8?B?UC8yTjJKVWtGRkkvVnNFb3VTR2JYL0UzUmYya0lNK1I4VUtFWjNEdmlYbU1W?=
 =?utf-8?B?WEkzZFUwZnpPY2tsYXpwWFJNZnEvdHNjOG9acmlaZ2JHTkRSYkM2Y1dqZmw1?=
 =?utf-8?B?VVRhSlFkN2E2bEl0MkxUb29KSUFMYVZTRkRYUUVnb3kyRlB4cVNGNEowZ2tQ?=
 =?utf-8?B?Q2hHVFpBRGR2NEsvRDhwTXltZ3hnTzRGWlVMSk4yVmtxU3V6VE85L1o4TVZa?=
 =?utf-8?B?alRPQWZQUGJQREVCaVRiUzdDQ050cDFDUEdBZ3dEczBEcHdoZE04Y2dxanJ4?=
 =?utf-8?B?Z3ZFbG9oWklTalg5cGVmVERZYzIyZUJUYzBYWHFQUlB6QTNUUHJ2MHYrYWxp?=
 =?utf-8?B?OXpDUmRKcVlhYnFIRDZqcFAydGZKV0w2UlhuMHlvVnRTNUdFdmpyUTQ0Ylk5?=
 =?utf-8?B?elpyeGR2dzIrQnZlNG8wd05VenNjSDFFdHYwYzBYYkhPNHVsVGorSGxxL2dW?=
 =?utf-8?B?VHZrSTJvRXBKY3BtWnljeTVDRmJ4Q0o4SHltaWpaRmNtenhZcTJQK3lHZFFY?=
 =?utf-8?B?NlRxUXJoRHhLQjBVRTNOTFE2TGxibFFxRjhheVkvemVDNWo2Nk1ReHIwNnBu?=
 =?utf-8?B?dGFPMU05cGtMVi9BQ3BnMGZVNnBEbXd1RS9SZDB5ZkhyenorYWw2MFg3OTFP?=
 =?utf-8?B?cXNwVEhDdTJnVmFUazNZYmFYd2RPekZHTk1RZzJnanQ5SzR4VnhGY25kRkNu?=
 =?utf-8?B?NVJRUzYvOTA5NXczYWIva0FDcjBocGZSVVJRZDhoTjlZVExFVlhrWWxhNlJN?=
 =?utf-8?B?RVR0aDErVyt5eVBCSkU3OE4yQmJiK2RIckR4SXBIbGNHSXk4dEVOVmtxdzZa?=
 =?utf-8?B?RE00Wk14d2lUZStnMDRXN2ZTSkVUYWR6enhETXpKRU4wOE1iOEN5SGVxWUl0?=
 =?utf-8?B?RnlaNnFYaGJ6a1B1STdPb2JaTHBZMUwxdzBZTWNWMWgxdGVEdCt3ZlhYc1Zs?=
 =?utf-8?B?Umh1ZmxPMjIvUXc5enAzWVpNZTBqUml0OEd4QW03YVBGZEt6MFI0SVBqaUpC?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D992B17B2857354A996AA87D54D1E529@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a78884c-66b9-4fe8-c73a-08dcd0813178
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 03:40:47.8575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bCWHi9Y7FQwYm9XL5y6E5Rl6Bk7iouCYpLAbdz1qaUrom/7dznNj6oVCH78u/l/oUoLioMm7roJrS7XyuFWgJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8504
X-MTK: N

T24gVGh1LCAyMDI0LTA5LTA1IGF0IDE0OjE2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xLzI0IDc6MTggUE0sIHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tIHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzLQ0KPiBtY3EuYw0KPiA+IGluZGV4IGFmZDk1NDFmNGJkOC4u
YWJkYzU1YThiOTYwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5j
DQo+ID4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gPiBAQCAtNjQyLDYgKzY0
Miw3IEBAIHN0YXRpYyBib29sIHVmc2hjZF9tY3Ffc3FlX3NlYXJjaChzdHJ1Y3QNCj4gdWZzX2hi
YSAqaGJhLA0KPiA+ICAgbWF0Y2ggPSBsZTY0X3RvX2NwdSh1dHJkLT5jb21tYW5kX2Rlc2NfYmFz
ZV9hZGRyKSAmIENRRV9VQ0RfQkE7DQo+ID4gICBpZiAoYWRkciA9PSBtYXRjaCkgew0KPiA+ICAg
dWZzaGNkX21jcV9udWxsaWZ5X3NxZSh1dHJkKTsNCj4gPiArbHJicC0+aG9zdF9pbml0aWF0ZV9h
Ym9ydCA9IHRydWU7DQo+ID4gICByZXQgPSB0cnVlOw0KPiA+ICAgZ290byBvdXQ7DQo+ID4gICB9
DQo+IA0KPiBJIHRoaW5rIHRoaXMgaXMgd3JvbmcuIFRoZSBhYm92ZSBjb2RlIGlzIG9ubHkgZXhl
Y3V0ZWQgaWYgdGhlIFNDU0kNCj4gY29yZQ0KPiBkZWNpZGVzIHRvIGFib3J0IGEgU0NTSSBjb21t
YW5kLiBJdCBpcyB1cCB0byB0aGUgU0NTSSBjb3JlIHRvIGRlY2lkZQ0KPiB3aGV0aGVyIG9yIG5v
dCB0byByZXRyeSBhbiBhYm9ydGVkIGNvbW1hbmQuDQo+IA0KDQpIaSBCYXJ0LA0KDQpUaGlzIGlz
IGVoX2Fib3J0X2hhbmRsZXIgY2FsbCBmbG93IGZvciBzY3NpIGVyciBoYW5kbGVyLg0KSWYgYWJv
cnQgaXMgdHJpZ2dlciBiZWNhdXNlIGVycm9yLCBzaG91bGQndCB3ZSBkbyByZXRyeT8NCkFueXdh
eSwgSSB0aGluayB0aGlzIGNhc2UgY291bGQgbm90IGhhcHBlbiBiZWNhdXNlIGlmIHNjc2kNCnRp
bWVvdXQgaGFwcGVuICgzMHMpLCBob3N0IGh3IHNob3VsZCBub3Qga2VlcCBjbWQgaW4gU1Egc3Vj
aCANCmEgbG9uZyB0aW1lLiBCdXQgb25jZSBpdCBoYXBwZW4sIHVmc2hjZF9tY3Ffc3FlX3NlYXJj
aCByZXR1cm4gDQp0cnVlIGFuZCBzY3NpIGdvdCBlaF9hYm9ydF9oYW5kbGVyIGZhaWwuIFNvLCBJ
IHRoaW5rIGluIHRoaXMgDQpjYXNlLCBub3RpZnkgc2NzaSByZXRyeSB0aGlzIGNvbW1hbmQgaXMg
cHJvcGVybHkuDQoNCg0KPiA+IC0vKiBSZWxlYXNlIGNtZCBpbiBNQ1EgbW9kZSBpZiBhYm9ydCBz
dWNjZWVkcyAqLw0KPiA+IC1pZiAoaGJhLT5tY3FfZW5hYmxlZCAmJiAoKnJldCA9PSAwKSkgew0K
PiA+IC1od3EgPSB1ZnNoY2RfbWNxX3JlcV90b19od3EoaGJhLCBzY3NpX2NtZF90b19ycShscmJw
LT5jbWQpKTsNCj4gPiAtaWYgKCFod3EpDQo+ID4gLXJldHVybiAwOw0KPiA+IC1zcGluX2xvY2tf
aXJxc2F2ZSgmaHdxLT5jcV9sb2NrLCBmbGFncyk7DQo+ID4gLWlmICh1ZnNoY2RfY21kX2luZmxp
Z2h0KGxyYnAtPmNtZCkpDQo+ID4gLXVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKGhiYSwgbHJicCk7
DQo+ID4gLXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmh3cS0+Y3FfbG9jaywgZmxhZ3MpOw0KPiA+
IC19DQo+ID4gKy8qIEhvc3Qgd2lsbCBwb3N0IHRvIENRIHdpdGggT0NTX0FCT1JURUQgYWZ0ZXIg
U1EgY2xlYW51cCAqLw0KPiA+ICtpZiAoaGJhLT5tY3FfZW5hYmxlZCAmJiAoKnJldCA9PSAwKSkN
Cj4gPiArbHJicC0+aG9zdF9pbml0aWF0ZV9hYm9ydCA9IHRydWU7DQo+IA0KPiBJIHRoaW5rIHRo
aXMgY29kZSBpcyByYWN5IGJlY2F1c2UgdGhlIFVGUyBob3N0IGNvbnRyb2xsZXIgbWF5IGhhdmUg
DQo+IHBvc3RlZCBhIGNvbXBsZXRpb24gYmVmb3JlIHRoZSAibHJicC0+aG9zdF9pbml0aWF0ZV9h
Ym9ydCA9IHRydWUiDQo+IGFzc2lnbm1lbnQgaXMgZXhlY3V0ZWQuDQo+IA0KDQpZZXMsIEkgc2hv
dWxkIGFkZCB0aGlzIGNvZGUgYmVmb3JlIHVmc2hjZF9jbGVhcl9jbWQsIHRoYW5rcy4NCg0KPiA+
ICsgKiBAaG9zdF9pbml0aWF0ZV9hYm9ydDogQWJvcnQgZmxhZyBpbml0aWF0ZWQgYnkgaG9zdA0K
PiANCj4gV2hhdCBpcyAiQWJvcnQgZmxhZyI/IFBsZWFzZSBjb25zaWRlciByZW5hbWluZyAiaG9z
dF9pbml0aWF0ZV9hYm9ydCINCj4gaW50byAiYWJvcnRfaW5pdGlhdGVkX2J5X2Vycl9oYW5kbGVy
IiBzaW5jZSBJIHRoaW5rIHRoYXQgYWJvcnRlZA0KPiBjb21tYW5kcyBzaG91bGQgb25seSBiZSBy
ZXRyaWVkIGlmIHRoZXNlIGhhdmUgYmVlbiBhYm9ydGVkIGJ5DQo+IHVmc2hjZF9lcnJfaGFuZGxl
cigpLg0KPiANCg0KT2theSwgYnV0IGFib3J0X2luaXRpYXRlZF9ieV9lcnIgbWF5YmUgYmV0dGVy
IGJlY2F1c2UgYWJvcnRlZCBieQ0KdWZzaGNkX2Vycl9oYW5kbGVyIG9yIHNjc2kgZXJyIGhhbmRs
ZXIgY291bGQgaGFwcGVuLiANCldoYXQgZG8geW91IHRoaW5rPw0KDQoNCj4gVGhhbmtzLA0KPiAN
Cj4gQmFydC4NCg==
