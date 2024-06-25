Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F151459F1;
	Tue, 25 Jun 2024 08:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719304170; cv=fail; b=NFR17RjhlKMs9omknywq6TyQe0AAIwGcyBtS57/w2tLlIDuRUhMK2deZyQ1UeuF3SaDvZo/+wcXBXSvyxNrPc53FxfeM6I3QEMjCX2QFYp7w+YyKOKPuU3tocLkZv4LrLPBCtwesIUYu61aMFTcKnWWX7WuuH5L7KJvhF0cESdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719304170; c=relaxed/simple;
	bh=Q4ndlmf4/d0Fc96FqtWPuiDEMbvabDwHZutQLEESh7I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jhs1APoeKKPqyE3WpL3NDi/G8+UID1Ky4SuncXmRYleo4cm3pYDT6Tn7eRtG4AwS9ly9yXRCZ10UizLD3jjT+RAlamfee4rlRxSCz0Iq870KCTdv+kVZ//C6kvZFyuFPdnFPnKOEUkXmbKicIR1wpkBYJ22YaYlNtnICSjHn9JM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fvwggCmv; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=t7OhmbqL; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fvwggCmv";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="t7OhmbqL"
X-UUID: 050bad9232cd11ef8da6557f11777fc4-20240625
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Q4ndlmf4/d0Fc96FqtWPuiDEMbvabDwHZutQLEESh7I=;
	b=fvwggCmv2cXNYart9TK4WUZBJHMDg0t00NSgVn+1Oi4dP6HlRDVZnu9yzgeVqBvDvoIBEInRlygBu+9BuA/0msOHjBibdL0mQVjzbM/hiSHB0mzMf/cu8QdtFuwcV9dkabLJ31vg0zJl/v/VW5Hnr52RfKw1veLi+eYc2XGnZKc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:36483002-4f68-45ee-b6ac-42ffc214d518,IP:0,U
	RL:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:393d96e,CLOUDID:8deafe44-4544-4d06-b2b2-d7e12813c598,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 050bad9232cd11ef8da6557f11777fc4-20240625
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2004623392; Tue, 25 Jun 2024 16:29:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 25 Jun 2024 16:29:19 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 25 Jun 2024 16:29:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMnG0oIhW3OdvoOA7jmu+/qDFxK8Ouw+8gn2NOxyGNkLHIN2PmCic+REESrru7sdsYa5mNg9Rik6GVlFQYvBFaX9YIASO0xbqX8K51hBJCkwidcbfJdV6kEC63+SaMGpLXGTsa3AEYEgF55xnJn+DFyuA6/ucz6mcZDUJq28SMiCCOVLGxbigPiSH7TacA6ebOkPlRaVsZ7uWuWZim3L56PmVQZxs2fGgr4dMT/SqoefF3/qEJg7QHMSIslb8Ed7ssPTvkJ1Mrz5El2xZgggQYjHMyEEI/IvIP+LgdsehXflIr4BjTMn/7pzS+ceYKWfQJZnEry/kivVI8uiyzWEHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4ndlmf4/d0Fc96FqtWPuiDEMbvabDwHZutQLEESh7I=;
 b=NokjqurfVJzYUgp3dHTj6dfTl3q56h25v3k8c51mtnB6vYK2Brr6/OI2DU9fEka6g4DPQtFZWIKBP3RErJrnR19WeKARlHJZiSdprkXhUsYLKzj3RlJZpEbR5N8jwzv7POKp49BcokZjthks0B1+YBy39zEsO2UiJsAHi6Z7oqVcQXBzvfDDYJ+MINBajoDZm6quSsosbUGn2SEEFCS+FbsufneOc/C/CqBrp1ek/YeJ8o1I5vukdmPrIhgkSfrJ4hLY2uXtwfiPakhFSostN420iXVGs6fLcIPC5jU96hvPBwGlbiSk8ZJCGngbl9rx0Ka1u4vw6FTo658UnimFjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4ndlmf4/d0Fc96FqtWPuiDEMbvabDwHZutQLEESh7I=;
 b=t7OhmbqLnE3lvmBc8U1fG9DP6JOlSAUHVwavQDCVQnU/oFNewLuUB6+BrbIqIB9QydU8yUw49Jx8emGkbZIVCwxuBZuZGpdQTq87o1qvyDW+fVVR+eSS/J45UNutSgkg47WCo8aHQJ0ZuHwjNL4gSgYHuLxnIa+YEdQMmCP+15U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8074.apcprd03.prod.outlook.com (2603:1096:990:35::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Tue, 25 Jun
 2024 08:29:16 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 08:29:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>
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
Thread-Index: AQHaxi+9yVyGxDcFYkS8cVbs4SEa0bHXNMuAgADyXIA=
Date: Tue, 25 Jun 2024 08:29:16 +0000
Message-ID: <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
References: <20240624121158.21354-1-peter.wang@mediatek.com>
	 <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
In-Reply-To: <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8074:EE_
x-ms-office365-filtering-correlation-id: 4daf3fad-bf25-4de3-6079-08dc94f0e700
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|7416011|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?UURIR3k4MzEzQ1l2Sm1Nay9jV1dabm9LdU1zS2taZzlsUWtLeStUZHVaclJw?=
 =?utf-8?B?NGFsSjAwUVQvOCtBVGtGcmI1NHJVT0Z3amUxSzRUWDg4SFRLeUJxaHNweDU0?=
 =?utf-8?B?YkFKeWttZHdNQWphWjU3TUQyRHYrTG1YaWVoUm5kcU9rSGpIeGlJVnZJL0VL?=
 =?utf-8?B?VHFJOTB0TWFlbGxlekV2VEpLZVBUamwxTE93VEVkdlZwK01jTUIyZTI3U0VU?=
 =?utf-8?B?K2swdE5FZmZUYTZPeENlU1JTL3hwN0U2RnZPSytZLzFvR0pITkZvODNnSkFI?=
 =?utf-8?B?akQrQjZ4eEg1Z215cXc3ek9VczNkcGEzN1lucHhiNjBrc1QrRXltbVJ0Y0lW?=
 =?utf-8?B?MHcrRTMzTkhvQjZIM2o4SzRRTzN2V3pqSW5XSWVPUFBtSjBZNDl6NFpsenMw?=
 =?utf-8?B?QXRRcld1L0FOV2NrUkN0dG0vU0Z0ZGxCdjErcW1pbkp6VXV3RkFwVU5tNWZ6?=
 =?utf-8?B?SVY2bloxb3BlSzVYbXBJZk5MblFMTkw5U1hobXlXTWp6aE9rSEIzMTJnM01h?=
 =?utf-8?B?bjF6c3lYK3FiNUhxSVVzWGF5UThpTExlQkRkSHRpMUdaSHdBU05pU3FzMThv?=
 =?utf-8?B?aSs3aEw3Mk54c0syQzRHVzhWM280Y2dOb204SjhvRk9jdjlIMWNLYkp4ekJw?=
 =?utf-8?B?K0pSN0c0L2N5Mk1oUmdhYnVNaHdSMEk1d2xaMmM0UlU1Skp1dDN0VjhNWDYr?=
 =?utf-8?B?dVNJYjZocDBFZG9wb3ZYclFMR1lLRVJuZkZXVzFxcUlDb1U0dHRHTUZSNWN5?=
 =?utf-8?B?VHMvcW9kSjJPZFhraTZWRmlQdk54MkJjc21CVGI1YkNNMnBISS9kcm1zUDFW?=
 =?utf-8?B?TjhoL0Y0cU9YdXBhekVxN3l5Z0FGR1E0QXM0YTVReHFjN1krYTFLdkxmckNj?=
 =?utf-8?B?aUJhbzdVbEljSDZudzJpZEhCYnpVbGxidndXOWVBTk90dWdsUkV2bGpQNEMy?=
 =?utf-8?B?N3BMQk1VZFNHcHFYQnlEVGorajdyTVJjMkdTUXp4T0t1Ry9CcWxIWGx1cEFq?=
 =?utf-8?B?RWwvbGZIeVgzNWdSRHpYSW9SaUZzWVQxNWNYMDMxNDBFQkF1REtISHlnMDVy?=
 =?utf-8?B?TTRBbXp2ekNmMThMbzdBWjk3c2NtbjIzUkgxbEJBTkhuM1RUbFlVZW81V2dR?=
 =?utf-8?B?OHdkNGcxelMyVnAzTkxZcnVRQkg4MWtBeU5JTVlFeVlwQXI2ZDdUcmo5M1J5?=
 =?utf-8?B?WU50czFqVVBzNkowcGlSdTVMMUJLd0VURFZiVEd2dzlNMWVlLzQ2V1JBU0lS?=
 =?utf-8?B?NkNnVEdkbW1Nbjd3ZC9hWWQrd0czanZwd0Fqb0hFWC9oR2VJNk45eVhwSGd3?=
 =?utf-8?B?S0ZHTmZMNWJNRFhvTG1ndTh2cVQrRUw1MU5mNUdlMGNMOTVKU2hSSThnRWRU?=
 =?utf-8?B?YzR5ME10NVdtOTF2elRveWpQUWdGbGtSMDJZUkgwWkZINFlQc1RQb1lCbVZL?=
 =?utf-8?B?cUhSYnNqcER6Z245d2swaHlqR2ZLNXo1Y09tMnlHNEtUem1YOEFqTjB2RHpr?=
 =?utf-8?B?Mi85dVZVRnNEV3pUOUF6T0RlbHJ3aWZCb1hDcXZtREdXZTZYdFRsV0lVYlJ1?=
 =?utf-8?B?bnVrcThYOWtvZzl3WFcvLzR1T2padVN2QWFpeFFUS3VnK1dzeHdicXFLZDRC?=
 =?utf-8?B?bkRqVzREZjJiZGtubzBRVXhtR1NlUEpyT2tYUmxEYzdqZi8wOG1SQWsxY2Fz?=
 =?utf-8?B?NWZzSVVSSHZISjBJaW84bXBMTHV3TEhCRkNIVVRXTmdvOGpvbU1BOWUxZC9J?=
 =?utf-8?B?NkIrWEkvKzRSekdCTlVLeTVpN1FxbzZTQ3VnMk5GUHl6NjBpUWNuRFluenpj?=
 =?utf-8?Q?ykkBWSV+ENVNeKetHg0ADLHXPc3aZFu43Phls=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(7416011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkJhb1I1MFIyV05waVN3STZsTUdJbTVrTFVsUmp0aVc5MjJicVZwWkJrL1hp?=
 =?utf-8?B?VmNvSE9EK2dZeHZQc2xrN1VuTDRlVjhFTmpiNXZpZzlKdVRUTmp4cXVVMFJF?=
 =?utf-8?B?eEpYeXFIQUMzSG1pMnVzcFlhbzJvWUhydzNOSkZNVXU4Y0NqNTN5SXk4QzZh?=
 =?utf-8?B?cHg2SnMwYVNYOWQ0S2xWRWdDR3VpQjFYcWUzZnhIZGpTeElPTitCallia1VF?=
 =?utf-8?B?Y0kzSmhqNHl2a0M4UHdVUVVJejQ2YWMvT3BTSUp5SUNJMHQzalduUExWdEVE?=
 =?utf-8?B?enhCdElhYlJhMW0vRmt3WEJnOHZoaVZiaTFjSFZMWnJZc1JQbnlpVmZCTVE3?=
 =?utf-8?B?SW1mcGMzcFQ1U2IvT1RPeTNwYVY5SEdHQlhCMnVpQmh1RE1vdlhGWFUxekJa?=
 =?utf-8?B?UnFCZzM0QTNHRjlPN0M0dTNJZ1A3NjRpMVgxWGZuVmJaQlJkb1grQXYzaFVC?=
 =?utf-8?B?ZjV6UTZuTEJnR2FwNmtGM0NzTWsvNU5ZL0NRNUhaeC9tQ3R3cytSQm5jczRF?=
 =?utf-8?B?QzRNZEtOMFFhZ1pSMStNUFpRSkcwdXByWXhDMW1EbjR3c1JqeVpVWm9qdVdW?=
 =?utf-8?B?L1FLdU9mbUJSUFE1YlF5MjRlVWIxYjFqRXFUbW9FWklPYWFTSXp0ZElBcnBK?=
 =?utf-8?B?QnBZVkZ1aDNuNW5xcDdvbmZDV0NQVzgyMktNOG4rUnpnUHRjNFh2Y0wwQmdD?=
 =?utf-8?B?QWFkVjdXalhha29MN3lEdXBsRTQ4N25PclRLcGY2RllGcGw3b3dxL3FRYVVq?=
 =?utf-8?B?bHVDL2VQaitEOW9JYmw3dEdFQlNLekVZK2w3M3BObWJ2QWwxUzlSY0p5U1lK?=
 =?utf-8?B?Z0ZXQXhmb0tBdmg0dkprckV4VDBkKytPUUluMjFEa0ZzZUgrVVh2ZFFveXRp?=
 =?utf-8?B?bFpScHJQaWhOR1NSdWJIdGUreWdYRUN6NzNTQUpJR2lBemEwK09mbnRkZjIz?=
 =?utf-8?B?dndPOG5VZGx1WkZYV1VGd0MwMXEwWnFZb3I4WWlkOHBBYlNPc3NONS9PQ05O?=
 =?utf-8?B?ZG50VXRyYnNCaHhGR2FlN21GWUZZYXFhcnl1SnYva2dtcjh5enJvT1N5RTVl?=
 =?utf-8?B?WFpIdjVXc1RoemVWMGdrKy92TEREWFdHdjZCcVQxSXhsVHhMZlA2Vy94T3Jo?=
 =?utf-8?B?U1lGbmgxekQ0Z3l1Z3piVENGQWdoL25jL2NmbkN1NTVnQ0dmR2dwSHVwWWlJ?=
 =?utf-8?B?Q0tNQUdMNithc2xxZy9nZjgrbW52VDd5WmFOVHNBSTloRjVMQkdONGRWSm44?=
 =?utf-8?B?b3VtRUg3TnhIYkVjaGpHbGxHc3hFQWxCR1M5Z3MrcTl1Zy9WV2VKaDNObWZ0?=
 =?utf-8?B?b05Wam0vcjkwTy80aTlkcHg3czkvNkFSTFE2Y0hEeG5XNWdtd1lrOE5ZOS9u?=
 =?utf-8?B?N0ZTWk5TeG1pS1E5TGtPY0hDQ0xtbmIvekhsbEJla3ZWUzZuTzQ1VjFDV2pk?=
 =?utf-8?B?Y0Q2L25JQWd6QUM4TEN4ZzA5bStxenJSdkxyc21UdVI1RHpFYjRwYXpUY3Z4?=
 =?utf-8?B?aHJsL1d6WmRWNU9PUnhoTEx2cEpNWDUvd3dMZlhNMDZXRVRabEhacWxTa0VE?=
 =?utf-8?B?MVh1WmNVV2syMlg1VEh5RXQ4QlNMbTBHUzlDcE1Wa0VnRmozL2FrQk9meWM0?=
 =?utf-8?B?aHdGejJTazlmSm04cDBCMDBTNmJ2VUN3VFBqWkNjTllxQ1JIdGtJZDJ0Y1Q4?=
 =?utf-8?B?L1cwNmRMLzc2WTZ0SWxSUm5TQlhtYlFVdlRzTlBZRTIxdTdvdGtGbG85WDAz?=
 =?utf-8?B?VjBUUTdTOTNBS1Y4dU9CYWcxSVNQMmE3VHVDVmxRL28rR1k5Uy8wZjdaTzFk?=
 =?utf-8?B?K3QvdTNkUE1VUHFKQ3kyWjhSbnFLN3k3dlhVWUdOUDcvWURIdXU5ZWRUSHVy?=
 =?utf-8?B?QVF5UW5uaUcveDNORkpuQXVjZFVCaXhTWDJScm1CRGQ2VUpMOTJaR2dsYStX?=
 =?utf-8?B?VFZ1R0ZUejJLSEVSNlFjWUQ2ZWJCUktEZk1nYytUeHlrQUxnTzZIOWRaeUNC?=
 =?utf-8?B?NlpvY1phQVRTejgxRk1qVU0rYTJjR3VsakhjSkRGekZORWF3UElhdGhPSjhH?=
 =?utf-8?B?MGVBYmhuNTZDWjJjSFJVL0xxTmpNRmliU0llN0loYXNlUERwTTQ2endWNW9u?=
 =?utf-8?B?NnBUN09TcENpUUliK1VIdXBWd3phYXBORy9kL3Ftam83MngyY0w5NXNTbkp5?=
 =?utf-8?B?akE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AF9079EBED1014FB6CF49EA3B90098D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4daf3fad-bf25-4de3-6079-08dc94f0e700
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 08:29:16.8157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I/Lp1QMT0JRGMnH++Yq6InjNQVrl3kxx1I5afpIcH3Xnn0GN98kHGUY0f+mTbVZL5XlfZ795RkVgsBeghenpXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8074
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--34.931900-8.000000
X-TMASE-MatchedRID: F3kdXSFZYkfUL3YCMmnG4t7SWiiWSV/1bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CzOo//J/EA1QXzlj7Pe6V6eI6q
	q9xPsXYiqd5roS6jjBMLyzLed90BD1OA+2Akm/pTAJnGRMfFxyacQHepotRmtgrAXgr/AjP2YAj
	JavrGfnzZ8cPr/Ceqc47sSWMqGwR8HvAxUe+03PZ7tR0mnRAg1uLwbhNl9B5VOCtCDJNptxqEPL
	QgibzEiUERf2FlcIh8PtaV8ksxxlWSBCik5/ZoSSszr2nuUNKwUB8iDddtrIgAheUymmndf1I/m
	OnDCADY8DiSPJfe0Ef3gsa/ypyBk11/bObp3yCh0CDjJ3XioBPaS52LUPfcSRi9INZ1ZpGGZ/Tq
	PF3UKVmF4RCF4/jYxEubYZQfPWltC/bXMk2XQLIMbH85DUZXyseWplitmp0j6C0ePs7A07QKmAR
	N5PTKc
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--34.931900-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	D7606A27A20B051C7CD6D5E2BC9BA882CA0CC8D3F9E5B31F00E7370D7E087E322000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA2LTI0IGF0IDExOjAxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gNi8yNC8yNCA1OjExIEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gID4gWyAuLi4gXQ0KPiBJbiB0aGlzIHBhdGNoIHRoZXJlIGFyZSB0d28g
Y2FsbCB0cmFjZXMsIHR3byBmaXhlcyB0YWdzIGFuZCB0d28gY29kZQ0KPiBjaGFuZ2VzLiBQbGVh
c2Ugc3BsaXQgdGhpcyBwYXRjaCBpbnRvIHR3byBwYXRjaGVzIHdpdGggZWFjaCBvbmUgY2FsbA0K
PiB0cmFjZSwgb25lIEZpeGVzOiB0YWcgYW5kIG9uZSBjb2RlIGNoYW5nZS4gQWRkaXRpb25hbGx5
LCBwbGVhc2UNCj4gaW5jbHVkZQ0KPiBhIGNoYW5nZWxvZyB3aGVuIHBvc3RpbmcgYSBzZWNvbmQg
b3IgbGF0ZXIgdmVyc2lvbi4NCj4gDQoNCkhpIEJhcnQsDQoNCldpbGwgc3BsaXQgdGhpcyBwYXRj
aCBpbnRvIHR3byBwYXRjaGVzIGFuZCBhZGQgY2hhbmdlbG9nIG5leHQgdmVyc2lvbiwNCnRoYW5r
cy4NCg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYyBiL2RyaXZl
cnMvdWZzL2NvcmUvdWZzLQ0KPiBtY3EuYw0KPiA+IGluZGV4IDg5NDQ1NDhjMzBmYS4uM2IyZTVi
Y2IwOGE3IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jDQo+ID4g
KysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gPiBAQCAtNTEyLDggKzUxMiw5IEBA
IGludCB1ZnNoY2RfbWNxX3NxX2NsZWFudXAoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gaW50IHRh
c2tfdGFnKQ0KPiA+ICAgcmV0dXJuIC1FVElNRURPVVQ7DQo+ID4gICANCj4gPiAgIGlmICh0YXNr
X3RhZyAhPSBoYmEtPm51dHJzIC0gVUZTSENEX05VTV9SRVNFUlZFRCkgew0KPiA+IC1pZiAoIWNt
ZCkNCj4gPiAtcmV0dXJuIC1FSU5WQUw7DQo+ID4gKy8qIFNob3VsZCByZXR1cm4gMCBpZiBjbWQg
aXMgYWxyZWFkeSBjb21wbGV0ZSBieSBpcnEgKi8NCj4gPiAraWYgKCFjbWQgfHwgIXVmc2hjZF9j
bWRfaW5mbGlnaHQoY21kKSkNCj4gPiArcmV0dXJuIDA7DQo+ID4gICBod3EgPSB1ZnNoY2RfbWNx
X3JlcV90b19od3EoaGJhLCBzY3NpX2NtZF90b19ycShjbWQpKTsNCj4gPiAgIH0gZWxzZSB7DQo+
ID4gICBod3EgPSBoYmEtPmRldl9jbWRfcXVldWU7DQo+IA0KPiBEb2VzIHRoZSBjYWxsIHRyYWNl
IHNob3cgdGhhdCBibGtfbXFfdW5pcXVlX3RhZygpIHRyaWVzIHRvDQo+IGRlcmVmZXJlbmNlIA0K
PiBhZGRyZXNzIDB4MTk0PyBJZiBzbywgaG93IGlzIHRoaXMgcG9zc2libGU/IFRoZXJlIGFyZQ0K
PiBvbmx5IHR3byBscmJwLT5jbWQgYXNzaWdubWVudHMgaW4gdGhlIFVGUyBkcml2ZXIuIFRoZXNl
IGFzc2lnbm1lbnRzDQo+IGVpdGhlciBhc3NpZ24gYSB2YWxpZCBTQ1NJIGNvbW1hbmQgcG9pbnRl
ciBvciBOVUxMLiBFdmVuIGFmdGVyIGEgU0NTSQ0KPiBjb21tYW5kIGhhcyBiZWVuIGNvbXBsZXRl
ZCwgdGhlIFNDU0kgY29tbWFuZCBwb2ludGVyIHJlbWFpbnMgdmFsaWQuDQo+IFNvDQo+IGhvdyBj
YW4gYW4gaW52YWxpZCBwb2ludGVyIGJlIHBhc3NlZCB0byBibGtfbXFfdW5pcXVlX3RhZygpPyBQ
bGVhc2UNCj4gcm9vdC1jYXVzZSB0aGlzIGlzc3VlIGluc3RlYWQgb2YgcG9zdGluZyBhIGNvZGUg
Y2hhbmdlIHRoYXQgcmVkdWNlcyBhDQo+IHJhY2Ugd2luZG93IHdpdGhvdXQgY2xvc2luZyB0aGUg
cmFjZSB3aW5kb3cgY29tcGxldGVseS4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo+IA0K
DQpibGtfbXFfdW5pcXVlX3RhZygpIHRyaWVzIHRvIGRlcmVmZXJlbmNlIGFkZHJlc3MgMHgxOTQs
IGFuZCBpdCBpcyBudWxsLg0KQmVhY3VzZSBJU1IgZW5kIHRoaXMgSU8gYnkgc2NzaV9kb25lLCBm
cmVlIHJlcXVlc3Qgd2lsbCBiZSBjYWxsZWQgYW5kDQpzZXQgbXFfaGN0eCBudWxsLg0KVGhlIGNh
bGwgcGF0aCBpcw0Kc2NzaV9kb25lIC0+IHNjc2lfZG9uZV9pbnRlcm5hbCAtPiBibGtfbXFfY29t
cGxldGVfcmVxdWVzdCAtPg0Kc2NzaV9jb21wbGV0ZSAtPiANCnNjc2lfZmluaXNoX2NvbW1hbmQg
LT4gc2NzaV9pb19jb21wbGV0aW9uIC0+IHNjc2lfZW5kX3JlcXVlc3QgLT4NCl9fYmxrX21xX2Vu
ZF9yZXF1ZXN0IC0+IA0KYmxrX21xX2ZyZWVfcmVxdWVzdCAtPiBfX2Jsa19tcV9mcmVlX3JlcXVl
c3QNCg0KQW5kIGJsa19tcV91bmlxdWVfdGFnIHdpbGwgYWNjZXNzIG1xX2hjdHggdGhlbiBnZXQg
bnVsbCBwb2ludGVyIGVycm9yLg0KUGxlYXNlIHJlZmVyZW5jZQ0KaHR0cHM6Ly9lbGl4aXIuYm9v
dGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9ibG9jay9ibGstbXEuYyNMNzEzDQpodHRwczov
L2VsaXhpci5ib290bGluLmNvbS9saW51eC9sYXRlc3Qvc291cmNlL2Jsb2NrL2Jsay1tcS10YWcu
YyNMNjgwDQoNClNvLCB0aGUgcm9vdC1jYXN1ZSBpcyB2ZXJ5IHNpbXBsZSwgZnJlZSByZXF1ZXN0
IHRoZW4gZ2V0IGh3cS4NClRoaXMgcGF0Y2ggb25seSBjaGVjayBpZiByZXFlc3V0IG5vdCBmcmVl
KGluZmxpZ2h0KSB0aGVuIGdldCBod3EuDQpUaG91Z2h0IGl0IHN0aWxsIGhhdmUgcmFjaW5nIHdp
bm9kdywgYnV0IGl0IGlzIGJldHRlciB0aGVuIGRvIG5vdGhpbmcsDQpyaWdodD8NCk9yLCBtYXli
ZSB3ZSBnZXQgYWxsIGNxX2xvY2sgYmVmb3JlIGdldCBod3EgdG8gY2xvc2UgdGhlIHJhY2luZyB3
aW5kb3cuDQpCdXQgdGhlIGNvZGUgbWF5IHVnbHksIGhvdyBkbyB5b3UgdGhpbms/DQoNClRoYW5r
cy4NClBldGVyDQoNCg==
