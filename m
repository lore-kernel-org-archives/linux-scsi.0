Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111071AE876;
	Thu, 12 Sep 2024 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726148966; cv=fail; b=ThjDIJ8+o9MfazxhGDZcoZAk1Y2dY65KvOZ8WpS63QioS4ORzkgBWUFMGEWj96dOHadXL0Sj9Ylm0oFKPgykm8Qp+FQBNw7kfBS9wDuZ+Ys9fKYXHYfyJCWc1dNioSD/d4j5ch2OU1FuR0CuDVSj/SgD9RXWQ57rrgCt9TsTy4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726148966; c=relaxed/simple;
	bh=rzXAC16VWQtQS+wZxJut7zpiD+RlJ+lmGGpR4KYtLuo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iCBDuVpKLynJcmT+EiOODgZJX1Hp9TBRHzSb0Z4LpOBJfvL6ryV+5LICOWTj0Le3F5prWlBcxPAl67mPPl3bIgs3MimXIbWmsExkfrNmSl4wd3xz7em+mlk9X7AnxmQwxvc77Xg2nthrYtcWvxGnsy9OqR5JrQRTddY/dTTJaHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZZOjNhfP; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Te/vzUO2; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZZOjNhfP";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Te/vzUO2"
X-UUID: cdd44dc8710d11ef8b96093e013ec31c-20240912
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=rzXAC16VWQtQS+wZxJut7zpiD+RlJ+lmGGpR4KYtLuo=;
	b=ZZOjNhfPbaFvBcwC1kLtQmUVR3dXlGyLe96CXNpsRgFVFHTw2TgFjl1Zz0p5knwuviS1ATqksgn46EShgWsykC2Gz3fcRQuHnTAunyXgv6zqUGIuQr6uPwhLc6DoE4CMR0Ipdd5o7GuxdlTmMTbMI1VRiSsIynNC/uVo+DI4avg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:2dc4861c-bafb-4adc-8d61-f7d833777d65,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:48c71bd0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: cdd44dc8710d11ef8b96093e013ec31c-20240912
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1683427089; Thu, 12 Sep 2024 21:49:17 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 12 Sep 2024 21:49:16 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 12 Sep 2024 21:49:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q2vipc0INcSLrpWi+FA8go64DtLxpZLpyfzps5xyECuKNhfv5kbPsSkCW1W/M4zQnsHozhqvd4XA0Ev00TW1SRchscw4Kd0qclolNvcv0eAmmLizi2DTIi+Msnbgj6wzHD6Kz1KpoYX3NGLazlSg10uL334gqPQVXD/irqoqhs0s49eyKilypE/B0Ho7nYLLBcdoJeE7q9XYElS4kI3m/td+FNTY9gOgLgPW730DfQddFC+9H2+Vo0uPYh0GVGIXEdNfcNQr2CA5LTdmTmmJVlSb8DvriFmxM3vCjqsML8iyCTILDUl06+S30OtP5HrAtSg5aIbuwHS5nY3kVco5aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzXAC16VWQtQS+wZxJut7zpiD+RlJ+lmGGpR4KYtLuo=;
 b=goR6u1O7ZR0J35EPixDmx4FrvOaU+Vs8ufosCi4wNwb6YkAjXrnWW8407I5Jp2tPyleGSPX5ozPVcnx1R9pcLVoWxIOjmT755HCCEtOd6c7KEKJgDw+Sp/KDntLfrhdthd+0+m5G11lV6s3YlDoL/Y0q/HOujkJHDv0LlDSNkbEMZ7QvNPBhreG2B+f6z7Zk5TCevrYTs0ACRUSDMxpDR0/p6aUOmLCpJ0t5SQzLazN08Ue1yonB3Mn39StS5YtpnmTGTHjtmV6ew5S63VymIoNtswcV1cjhYdwsdMpYpeiQ52xVPV1FppVX/fqTOELUu4ePwuAV8+chjpPiblToWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzXAC16VWQtQS+wZxJut7zpiD+RlJ+lmGGpR4KYtLuo=;
 b=Te/vzUO2PCJw1GDpZ5z2cRFUUu4SQk7cRoxkrXKqX3by82tsp2vV5WkdhvkGEoBScUWidZlKN8YWPepSRIvirfD94nyex8w2UXZ9ocY2yXBzFcx+teec6VlQ4pZKu1Z4bRheW+B7XrX6khQ/TJytserGkCfud8o2QsZkhGl+67k=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6620.apcprd03.prod.outlook.com (2603:1096:101:7b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Thu, 12 Sep
 2024 13:49:13 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Thu, 12 Sep 2024
 13:49:13 +0000
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
Subject: Re: [PATCH v6 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v6 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbBDD/9ei8+tLWLUyRJBqnfUZ7o7JS+5wAgAExGYA=
Date: Thu, 12 Sep 2024 13:49:12 +0000
Message-ID: <d3306f9d2b88c5b6ae8d2104041e5c941898dee5.camel@mediatek.com>
References: <20240911095622.19225-1-peter.wang@mediatek.com>
	 <20240911095622.19225-3-peter.wang@mediatek.com>
	 <55d2cca5-0e30-4734-aa25-d5f5cdfbfd93@acm.org>
In-Reply-To: <55d2cca5-0e30-4734-aa25-d5f5cdfbfd93@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6620:EE_
x-ms-office365-filtering-correlation-id: e8494584-dc26-4ff0-f6e7-08dcd331af64
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V21TaDZLNnF3ZVd6eUF6cG1hSnJBMCsySG9weW1UZmNaSU10d2hhMWJvcXVX?=
 =?utf-8?B?M3ZSMmNNUUZqRk0wOEN6RzBUZE9zczdHM0duMHova0J4bTJkM3FIYjdZUFo5?=
 =?utf-8?B?NFA5L3oxd3k1Q3VrcnJnT3V1VXFaSm1WVUpJamthRU1UNnZCdkhUVmxhTDFy?=
 =?utf-8?B?N1FoaWZaOUlMQzN5WDhpRjZFQWJMY290SU93aFJxcW9qemdzSmpLVFpFc1ZT?=
 =?utf-8?B?cmV3MVFEelF3TlRvb1BIU25ZZXdqUGMwNHR5aVVvV3dIc2w5eWdDbmtrZFFN?=
 =?utf-8?B?YXNTbjhuL3M1UThmTmtMdkVRYjRaWUhRdHRKbWdaaEJIMmxTSmI4a2U4MTcr?=
 =?utf-8?B?NDU5UW9aWndhckZQRC81VEh4NDQzMHY5TkVPNHNEQmRaSUV3Mzh2QlZyNXBs?=
 =?utf-8?B?L0pQaUx5YkFkQnJETGdkUk5LRitBYTlxN09UOElDSmZIVlNhTnFwT01Yc24y?=
 =?utf-8?B?LytTYTlIN2JBUk5iYk1IVERpWnZpQjZEMU02ejcwNUUvbUZBRGMwekFxbE92?=
 =?utf-8?B?QWUrZFcxT204VkRUYXBRVDZSbFVaenJPQWxXbmlZMDJpZ3pPLzI1bXlnckNr?=
 =?utf-8?B?aEpKWFZyUzJEcUV3QzhNakxBcXA1WXJsK0NtOENSVFlXdm9pd0tLUnBuZkp1?=
 =?utf-8?B?eFJZdy91Sm1FcUY0RzhrK3NlbEhxZVUzZGFldm0ybndjeTZjQVN4VWNDdTE4?=
 =?utf-8?B?RzVKM3dCTmVwcmo2dkRsL1I0MWt6MDEveHkveUZFTDZZOU5mdENQSU9vK3NL?=
 =?utf-8?B?ZkdpelV6bFNWdXhNRWtUSVIyQTFVNjdVRU1MOHhGcnp0em80SCtPOGRxdGtT?=
 =?utf-8?B?R21TOFh1L1pQRnZveGd6SWdsZUxVdU83ZkkyZG56dDBjWFUwMGVVQ1BjdnFE?=
 =?utf-8?B?OHN3SXRwczZOcmNkTkwrZUtPSHNLbzZsTHQyK3p0Sis4YnRJL1NUdzlQSkJh?=
 =?utf-8?B?NnpwU3greHpuaGVoa2k2TWxYRHNHbndaMlZXUFAvb1NXcDlnT3Vlb1RGN1Jr?=
 =?utf-8?B?UkprSVF6cHZ3M3BhRkcvZkhjUjRlejEydmxmc3kyQTBXRWJGbmh5MEF3QnBR?=
 =?utf-8?B?WXAwTlQzNUJlRjVVWE1uN1dvV05qK3NQYXJQOW80MW1IcEEyNTZFZTlqNENW?=
 =?utf-8?B?a0ZqYjZyTC83azJSYldqYm15aHRWc2JxZkhSZGw0MVJ1aHFPMkVoMXpacmhH?=
 =?utf-8?B?bXduU09Mcy9pcndqd0Nnd3pYaThvYXB3SGIwbVVLR2NldUJqS2U2d0JXanF2?=
 =?utf-8?B?MHdYU1I1WjI5eEdPUUp6TU5RRlpKdkZvaHh1RG5ubUNtYm1nNzhQL0RRdE9u?=
 =?utf-8?B?NnpZc3J5b1NFSVJLMVdEa2Y4eEhVeUxBcEF6UGQrU2psbzROUk4rNEtaVXph?=
 =?utf-8?B?UStwVEFlZG40M2ZsYkxiempuOEF4blkrdGZUR0dRZHRBT1YxOC9Bem8zT3BI?=
 =?utf-8?B?WS9Vbnh0a3BJYXN1TllMWitpY3ppRHVjUGxkZ0tlSWRUSWhKM1hmZktuNzR5?=
 =?utf-8?B?MHhYZ3ZqZm9OWmdjRWl2dFhDYjM2eXRuUlNYTUZJZ2RFV0xyRmdyN0twWTdK?=
 =?utf-8?B?ZGZKTlFGa1h1azJOYldidldYalpLWldJTnNCK2lRY1ZYQis2dWpvOEhDNmw5?=
 =?utf-8?B?V093RGNyR0tOS3A4YkkrTno2N1p4NngzMmRIb2Noc240cnBmaWlCNmZ1Y1Mz?=
 =?utf-8?B?VXJXU3NJTGpnRTBYTDRoVUp3VS93WVI5TGxuclloTGdsdWR2NHFqMkVoSEJN?=
 =?utf-8?B?TUNPYjRXS3R0OUZxcnhVNlFNOUx0REtZUml0SHRWeWlKd0orL0FzRndyNWd1?=
 =?utf-8?B?a21KL3puV2w1YU9jazNuUDBxR0Z1dDdld3FqNHVIOXNrUWFWcXVRUnYrdGY4?=
 =?utf-8?B?c253K3QxamVZK2F1TGpiNFRNdHdid0JoeDVoTk1nL1o2dHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3FhTm1DcG83eVQwbWVZY2tpQ3VpZzJ0SEFjOEZwa1NTNW96OWY1QzJvcE50?=
 =?utf-8?B?ZCs0cW96b2xpM2FzbGRVbks2a1dLUU5veFIrdlI1dER3NEJBbHkrS0o5VVV2?=
 =?utf-8?B?Z01lMzJBMHFINDVMdVFCRnBNODVZK3JtN0I0Tjk5ZklqUVk2Y0hOYmhCc3hC?=
 =?utf-8?B?OFFhNk5Yd09Ca2VVdWZHbi9IbEV2Q3VZeHR5UExpUjc2VE1pZjBMQmFPS2Jv?=
 =?utf-8?B?TGROOUNSZnl4SmdBbkVQR1gwS1NkSHorQlJRc2hmWnRieGVIMHhGQ0lORXdF?=
 =?utf-8?B?bXpYK2VBSTcxeXJ0bWlhUWpyWmFEYkZHcnBwN0FhRnlKRTJCcXJoSi9MUmZw?=
 =?utf-8?B?QlIreTRlV2prY2tPZVdYcVpFUkxLaU8zQjMrVm5RbzNIYi9icjhSRDRTSlVi?=
 =?utf-8?B?UXQvenU0MU1qeTFXakJGSWpncXc5cCtYbmIwOGJ0Qk9TTURab2dUbW8zTWlr?=
 =?utf-8?B?bVhjQ1d0eGJicFdsU0hhNmJCajEvOGhsZkkyWk5iSlEvWGY3c0pFSGlrZGpW?=
 =?utf-8?B?TzFLL3BwVjhGMVRKTGY1dUlsU2RGTlAwQkEwVXBGODllc2dzM2R6YStKZjg2?=
 =?utf-8?B?VXhPMld3ZnVPRzdWQ0p4bFFIOXhlT3AyY2FrQlRrWlRuQ2VHWWhqN2Y4M1h0?=
 =?utf-8?B?M1Bxczg0V243a3VHVWdNSzJPdHNwdnB4Q2FzUkc4YU0xM2l5TlpEWEFkZUEr?=
 =?utf-8?B?VW1GbFdlSWd6RG8yb3J3NjJQbWo2eDYyYmJSS0ZtUXFwQmRYKzdLbnBCZ2ll?=
 =?utf-8?B?STc3bUhFOEFUY3h5UDc2a1dMa0NsUGFvMFpVUldjZnhGRmMyM3NFbDkvdTEx?=
 =?utf-8?B?dE1tR1daWmo1eUZ3QTNaS01abnBVdmZPbHBhNUtmcGVHbFp2ZVJYV3d1M2Ja?=
 =?utf-8?B?M1FhMDdEc2lJdXhmdWlqbmpVMlVVZFNUa25zdWFXY1VHRUNFaG9jYW1RUzlL?=
 =?utf-8?B?M1dTSy9DN0luUkladnlmVk1OT2poWnBQUDdTVHYzYlNYZnpmdFRzQXBxaVdB?=
 =?utf-8?B?d0MwZmIwemJyUEhGM29ZMm9NbXl3b0E5VGF5T29Ka2J5aVp2aHQwMmVvUG1N?=
 =?utf-8?B?bDNQQnJHOHVaOEJiS0pWZWlaT0hJUTBpOU9sUVdlSVFYSXM0SWdWUEZYL3h1?=
 =?utf-8?B?bUhEUHZXdkFubFhYclAvclB6UUthUnM1cDZENko3Q1JwV3k0TW9hSUl3Z0ZY?=
 =?utf-8?B?TUhIWFJwYjl2NnJCWnRKcVlucys2b2V2VkFXSEMvRmhmUWpqK29SM200U2t5?=
 =?utf-8?B?STV4eFJlNVNqT215MU5HQURyTlJWUWVYUWxaL3NZc0haRTNoN0hSZXpOaDAz?=
 =?utf-8?B?dEgxYWFKN0VxSVF1Wjc4bmQxYTNSSTJTY3gwSW9VWFpacU1DeTlEaTJ2T3hN?=
 =?utf-8?B?d3E1M0t6bGFoY2lYcEFyZDBQNndJOUtkV25jYnRLK0ZDamIrNTZqclowa3B6?=
 =?utf-8?B?YVlWRnB3U3RSc1lXeFhsOStWMkxheVltZ2FnMUk3RnFmUGFjOVZHbER5MCt3?=
 =?utf-8?B?Ymp5WE1lSHRyc1RuOFhHTElpWVFQek9CdEJJQ2cydGFWUUdXWnJmY2txTEc4?=
 =?utf-8?B?MHFmY0Q4M2xPL3AvZkZXUExCWW5NRXhVYW1lZVBLWVhsQTRHdUgzbjJYbVNS?=
 =?utf-8?B?SlFidWxsNEZjbmIzd3d4YVcrSHdNdkNORmQxSTMwN0xXMk1TNlFFM0lBYUY1?=
 =?utf-8?B?SkdGdnFyaGthSWZ0eVZqUHM3b3JqeVQwcFh2RmlQWktWb1R0c25YWGRxcjZr?=
 =?utf-8?B?amZDTk9weXRSRGtnWXY2RldTTkE3UUE4MnFOU1d0dU1aREZTTWdiOXU5VEIz?=
 =?utf-8?B?RWxGdG9CeExtZXJ6Vlhudmk1RTY1d3NqVWM0WHcwNWdhdVg2N0xraUtURXYr?=
 =?utf-8?B?SEpxRytjQ21DRGl4dEdkM1MvMC9OanVhQ0hNc2JTdjc0cHpDeG56TDIrbjdq?=
 =?utf-8?B?YS9FdHpSRmYycDloYmVPdjBBbVpONkkzSllaWkl6WmN0UDk0dkdRNU5hVy9n?=
 =?utf-8?B?SEhBOWJKYVBNSGpzLzkxV2VFMVhEalZzbTJTVmcrVmlrVnRSMlU3bWROY2hk?=
 =?utf-8?B?Z1ZFdm15YndxNzJFU09nOGd1eUwwNkREZEdLS2pLaXlYT1c4OXd5cTdBU2h6?=
 =?utf-8?B?RmdNdlA3aHZ0KzA3MmlzRWIwallsMURtMVRVS0RRdlBydmFJMHpXanBDZ0ln?=
 =?utf-8?B?WWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6997B85FF955649940571679A2B16F8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8494584-dc26-4ff0-f6e7-08dcd331af64
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 13:49:12.8627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xcWQSurxfGsuwUiqQFbQ5RP8DWl6SYGp8DA9C/a0j2qz5x9+22j2ftPXg5wOzjXrCWwh9VBqQeLeM25Rf58BMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6620
X-MTK: N

T24gV2VkLCAyMDI0LTA5LTExIGF0IDEyOjM3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8xMS8yNCAyOjU2IEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gPiB1ZnNoY2RfYWJvcnRfYWxsIGZvcmNpYmx5IGFib3J0cyBhbGwgb24t
Z29pbmcgY29tbWFuZHMgYW5kIHRoZSBob3N0DQo+ID4gY29udHJvbGxlciB3aWxsIGF1dG9tYXRp
Y2FsbHkgZmlsbCBpbiB0aGUgT0NTIGZpZWxkIG9mIHRoZQ0KPiBjb3JyZXNwb25kaW5nDQo+ID4g
cmVzcG9uc2Ugd2l0aCBPQ1NfQUJPUlRFRCBiYXNlZCBvbiBkaWZmZXJlbnQgd29ya2luZyBtb2Rl
cy4NCj4gPiANCj4gPiBNQ1EgbW9kZTogYWJvcnRzIGEgY29tbWFuZCB1c2luZyBTUSBjbGVhbnVw
LCBUaGUgaG9zdCBjb250cm9sbGVyDQo+ID4gd2lsbCBwb3N0IGEgQ29tcGxldGlvbiBRdWV1ZSBl
bnRyeSB3aXRoIE9DUyA9IEFCT1JURUQuDQo+ID4gDQo+ID4gU0RCIG1vZGU6IGFib3J0cyBhIGNv
bW1hbmQgdXNpbmcgVVRSTENMUi4gVGFzayBNYW5hZ2VtZW50IHJlc3BvbnNlDQo+ID4gd2hpY2gg
bWVhbnMgYSBUcmFuc2ZlciBSZXF1ZXN0IHdhcyBhYm9ydGVkLg0KPiANCj4gSSB0aGluayB0aGlz
IGlzIGluY29ycmVjdC4gVGhlIFVGU0hDSSBzcGVjaWZpY2F0aW9uIGRvZXMgbm90IHJlcXVpcmUN
Cj4gYQ0KPiBob3N0IGNvbnRyb2xsZXIgdG8gc2V0IHRoZSBPQ1MgZmllbGQgaWYgYSBTQ1NJIGNv
bW1hbmQgaXMgYWJvcnRlZCBieQ0KPiB0aGUNCj4gQUJPUlQgVE1GIG5vciBpZiBpdHMgcmVzb3Vy
Y2VzIGFyZSBmcmVlZCBieSB3cml0aW5nIGludG8gdGhlIFVUUkxDTFINCj4gcmVnaXN0ZXIuDQo+
IA0KDQpIaSBCYXJ0LA0KDQpJJ20gdGhpbmtpbmcgb2YgcmVtb3ZpbmcgdGhlIFNEQiBkZXNjcmlw
dGl2ZSBjb21tZW50LCBzbyB0aGF0IA0KaXQgY2FuIGJlIGFwcGxpY2FibGUgaW4gY2FzZXMgd2l0
aCBPQ1MgQUJPUlRFRCwgYW5kIGl0IHdvbid0IA0KbWF0dGVyIGlmIHRoZXJlIGlzbid0IE9DUyBB
Qk9SVEVEIGJlY2F1c2Ugc2V0dGluZyB0aGlzIGZsYWcgDQp3b24ndCBoYXZlIGFueSBlZmZlY3Qu
IA0KT3IgSSBhZGQgbW9yZSBNQ1EgY2hlY2sgb25seSBzZXQgdGhpcyBmbGFnIGluIE1DUSBtb2Rl
LiANCldoYXQgZG8geW91IHRoaW5rPw0KDQoNCg0KPiA+IEBAIC01NDA0LDcgKzU0MDUsMTAgQEAg
dWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgc3RydWN0
IHVmc2hjZF9scmIgKmxyYnAsDQo+ID4gICB9DQo+ID4gICBicmVhazsNCj4gPiAgIGNhc2UgT0NT
X0FCT1JURUQ6DQo+ID4gLXJlc3VsdCB8PSBESURfQUJPUlQgPDwgMTY7DQo+ID4gK2lmIChscmJw
LT5hYm9ydF9pbml0aWF0ZWRfYnlfZWgpDQo+ID4gK3Jlc3VsdCB8PSBESURfUkVRVUVVRSA8PCAx
NjsNCj4gPiArZWxzZQ0KPiA+ICtyZXN1bHQgfD0gRElEX0FCT1JUIDw8IDE2Ow0KPiA+ICAgYnJl
YWs7DQo+IA0KPiBJcyB0aGUgYWJvdmUgY2hhbmdlIG5lY2Vzc2FyeT8gdWZzaGNkX2Fib3J0X29u
ZSgpIGFib3J0cyBjb21tYW5kcyBieQ0KPiBzdWJtaXR0aW5nIGFuIEFCT1JUIFRNRi4gSGVuY2Us
IHVmc2hjZF90cmFuc2Zlcl9yc3Bfc3RhdHVzKCkgd29uJ3QgYmUNCj4gY2FsbGVkIGlmIGFib3J0
aW5nIHRoZSBjb21tYW5kIHN1Y2NlZWRzLg0KPiANCg0KWWVzLCBKdXN0IGJlY2FzdWUgQUJPUlQg
VE1GIENPTVBMRVRFLCBpbiBzcGVjIGRlc2NyaXB0aW9uOg0KIkEgcmVzcG9uc2Ugb2YgRlVOQ1RJ
T04gQ09NUExFVEUgc2hhbGwgaW5kaWNhdGUgdGhhdCB0aGUgDQpjb21tYW5kIHdhcyBhYm9ydGVk
IG9yIHdhcyBub3QgaW4gdGhlIHRhc2sgc2V0LiBJbiBlaXRoZXIgY2FzZSwgDQp0aGUgU0NTSSB0
YXJnZXQgZGV2aWNlIHNoYWxsIGd1YXJhbnRlZSB0aGF0IG5vIGZ1cnRoZXIgDQpyZXF1ZXN0cyBv
ciByZXNwb25zZXMgYXJlIHNlbnQgZnJvbSB0aGUgY29tbWFuZC4iDQoNClNvIGF0IHRoaXMgdGlt
ZSwgdGhlIGRldmljZSB3aWxsIG5vdCBoYXZlIGEgY29ycmVzcG9uZGluZyANCnJlc3BvbnNlIGNv
bWluZyBiYWNrLiBUaGUgaG9zdCBjb250cm9sbGVyIHdpbGwgYXV0b21hdGljYWxseSANCmZpbGwg
aW4gdGhlIHJlc3BvbnNlIGZvciB0aGUgY29ycmVzcG9uZGluZyBjb21tYW5kIGJhc2VkIG9uIA0K
dGhlIHJlc3VsdHMgb2YgU1EgY2xlYW51cCAoTUNRKSBvciBVVFJMQ0xSIChEQlIsIG1lZGlhdGVr
KSwgDQp3aXRoIHRoZSBDT1MgY29udGVudCBiZWluZyBBQk9SVEVEIGJ5IGludGVycnVwdC4NCklT
UiB3aWxsIGhhbmRsZSB0aGUgcmVzcG9uc2Ugd2hpY2ggaXMgZnJvbSBob3N0LCBub3QgZnJvbSBk
ZXZpY2UuDQoNCg0KPiA+IEBAIC03NTYxLDYgKzc1NTEsMjEgQEAgaW50IHVmc2hjZF90cnlfdG9f
YWJvcnRfdGFzayhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBpbnQgdGFnKQ0KPiA+ICAgZ290byBv
dXQ7DQo+ID4gICB9DQo+ID4gICANCj4gPiArLyoNCj4gPiArICogV2hlbiB0aGUgaG9zdCBzb2Z0
d2FyZSByZWNlaXZlcyBhICJGVU5DVElPTiBDT01QTEVURSIsIHNldCBmbGFnDQo+ID4gKyAqIHRv
IHJlcXVldWUgY29tbWFuZCBhZnRlciByZWNlaXZlIHJlc3BvbnNlIHdpdGggT0NTX0FCT1JURUQN
Cj4gPiArICogU0RCIG1vZGU6IFVUUkxDTFIgVGFzayBNYW5hZ2VtZW50IHJlc3BvbnNlIHdoaWNo
IG1lYW5zIGENCj4gVHJhbnNmZXINCj4gPiArICogICAgICAgICAgIFJlcXVlc3Qgd2FzIGFib3J0
ZWQuDQo+ID4gKyAqIE1DUSBtb2RlOiBIb3N0IHdpbGwgcG9zdCB0byBDUSB3aXRoIE9DU19BQk9S
VEVEIGFmdGVyIFNRDQo+IGNsZWFudXANCj4gPiArICoNCj4gPiArICogVGhpcyBmbGFnIGlzIHNl
dCBiZWNhdXNlIGVycm9yIGhhbmRsZXIgdWZzaGNkX2Fib3J0X2FsbA0KPiBmb3JjaWJseQ0KPiA+
ICsgKiBhYm9ydHMgYWxsIGNvbW1hbmRzLCBhbmQgdGhlIGhvc3QgY29udHJvbGxlciB3aWxsIGF1
dG9tYXRpY2FsbHkNCj4gPiArICogZmlsbCBpbiB0aGUgT0NTIGZpZWxkIG9mIHRoZSBjb3JyZXNw
b25kaW5nIHJlc3BvbnNlIHdpdGgNCj4gT0NTX0FCT1JURUQuDQo+ID4gKyAqIFRoZXJlZm9yZSwg
dXBvbiByZWNlaXZpbmcgdGhpcyByZXNwb25zZSwgaXQgbmVlZHMgdG8gYmUNCj4gcmVxdWV1ZWQu
DQo+ID4gKyAqLw0KPiA+ICtpZiAoIWVyciAmJiB1ZnNoY2RfZWhfaW5fcHJvZ3Jlc3MoaGJhKSkN
Cj4gPiArbHJicC0+YWJvcnRfaW5pdGlhdGVkX2J5X2VoID0gdHJ1ZTsNCj4gPiArDQo+ID4gICBl
cnIgPSB1ZnNoY2RfY2xlYXJfY21kKGhiYSwgdGFnKTsNCj4gPiAgIGlmIChlcnIpDQo+ID4gICBk
ZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IEZhaWxlZCBjbGVhcmluZyBjbWQgYXQgdGFnICVkLCBlcnIg
JWRcbiIsDQo+IA0KPiBUaGUgYWJvdmUgY2hhbmdlIHdpbGwgY2F1c2UgbHJicC0+YWJvcnRfaW5p
dGlhdGVkX2J5X2VoIHRvIGJlIHNldCBub3QNCj4gb25seSBpZiB0aGUgVUZTIGVycm9yIGhhbmRs
ZXIgZGVjaWRlcyB0byBhYm9ydCBhIGNvbW1hbmQgYnV0IGFsc28gaWYNCj4gdGhlDQo+IFNDU0kg
Y29yZSBkZWNpZGVzIHRvIGFib3J0IGEgY29tbWFuZC4gSSB0aGluayB0aGlzIGlzIHdyb25nLg0K
PiANCj4gSXMgdGhpcyBwYXRjaCAyLzIgbmVjZXNzYXJ5IG9yIGlzIHBhdGNoIDEvMiBwZXJoYXBz
IHN1ZmZpY2llbnQ/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpTb3JyeSwgSSBtaWdo
dCBoYXZlIG1pc3NlZCBzb21ldGhpbmcsIGJ1dCBJIGRpZG4ndCBzZWUgDQpzY3NpIGFib3J0ICh1
ZnNoY2RfYWJvcnQpIGNhbGxpbmcgdWZzaGNkX3NldF9laF9pbl9wcm9ncmVzcy4gDQpTbywgZHVy
aW5nIGEgU0NTSSBhYm9ydCwgdWZzaGNkX2VoX2luX3Byb2dyZXNzKGhiYSkgDQpzaG91bGQgcmV0
dXJuIGZhbHNlIGFuZCBub3Qgc2V0IHRoaXMgZmxhZywgcmlnaHQ/DQoNCg0KQWRkaXRpb25hbGx5
LCBTQ1NJIGFib3J0ICh1ZnNoY2RfYWJvcnQpIHdpbGwgaGF2ZSBkaWZmZXJlbnQNCnJldHVybiB2
YWx1ZXMgZm9yIE1DUSBtb2RlIGFuZCBEQlIgbW9kZSB3aGVuIHRoZSBkZXZpY2UgDQpkb2VzIG5v
dCByZXNwb25kIHdpdGggYSByZXNwb25zZS4NCk1DUSBtb2RlIHdpbGwgcmVjZWl2Y2UgT0NTX0FC
T1JURUQgKG51bGxpZnkpDQoJY2FzZSBPQ1NfQUJPUlRFRDoNCgkJcmVzdWx0IHw9IERJRF9BQk9S
VCA8PCAxNjsNCgkJYnJlYWs7DQpCdXQgREJSIG1vZGUsIE9DUyB3b24ndCBjaGFuZ2UsIGl0IGlz
IDB4MEYNCgljYXNlIE9DU19JTlZBTElEX0NPTU1BTkRfU1RBVFVTOg0KCQlyZXN1bHQgfD0gRElE
X1JFUVVFVUUgPDwgMTY7DQoJCWJyZWFrOw0KSW4gdGhpcyBjYXNlLCBzaG91bGQgd2UgYWxzbyBy
ZXR1cm4gRElEX0FCT1JUIGZvciBEQlIgbW9kZT8NCg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg==
