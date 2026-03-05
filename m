Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D2B377557;
	Thu,  5 Mar 2026 09:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772702114; cv=fail; b=kxePEGEJhdW5t/oEMZ+4G5Hqyrhc+VFsptriqbB0azAFben1ms2+oF5htqkpY2K0WTaxLH6odFEPj0ZD6SvvQKYlBOCK/bpY50kE6MFwplnyPQaXdaFsNAu44+boZ4A/0O+DdcpEGJtvF4YDRXJEt7TuAR6XfgahfnLGVU1SHGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772702114; c=relaxed/simple;
	bh=b0liGuXkD6iQDO/UAdGDIRUNTcztF4w729OJEU0Yiuc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P/Qkw2d6mJyuAxdGCCE6Ut2D2WzcyNSPhbIGMcNjwyaQQefs5ZuoVDh9F0493mPAQ0VEVIfCDgFMkGtQqu4vJfK2pzXxH57906ukSNvPWRNEp23XUiIv4JSMTc7IJqhqX9n78gTJYuGHIK+iWZftBrkfhYbarZyI41SkjWhM8Po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=J9wewkiv; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=f370stbU; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="J9wewkiv";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="f370stbU"
X-UUID: ca298b70187311f1bcd7499a721e883d-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=b0liGuXkD6iQDO/UAdGDIRUNTcztF4w729OJEU0Yiuc=;
	b=J9wewkiveV19mayVkvg9J4vhHpR/ognMtfRAgBIpn/AAhhOtmDkQei2PsUJQ4LhaDkm3LJGf/pYFmPUxBxA44vzOVJCQG6RsjmfEvI1NhDQzHJKBePiEZpd898kofvWkixPfpbR/AggAR5SItyh3lbmBuc2kDLotskI37F5Nbnw=;
X-CID-CACHE: Type:Local,Time:202603051715+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:4935eb4d-6338-4364-807a-75bbf46b9095,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:e0e44af1-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ca298b70187311f1bcd7499a721e883d-20260305
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 735281915; Thu, 05 Mar 2026 17:15:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 17:15:00 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 17:15:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gvPrC8OHXbBcjYrUUjguz+VdBmScQZiNg2CN78EJnoOKoyBCu5PLYF9lJpQ2modogFoU910Sr+OI4bl0MXDWcb6uV/egjgpFgTrQQM6arf+k6tiKtUzW3Na4Mvopc8WqpcqiDOyn/aoddg6QqB+egtwOUcbgfLTGCAQjaQ3YIXIiLUm5FXz/Yq4reBSij0V+130qXDQpwd0iUQtp5UzOSHdtRHIlek/6g0KkSHzKSHIG4yOZpPzouSDs5Hm5EGuhqHMBKoj2Eb7MFyFha5Z6vePAtUJd8sk0yXJ/PeEE65i8ykMfXtXqp42pI5f2kIuJ6CEBfmsN6Rs09U4Pb6ANaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0liGuXkD6iQDO/UAdGDIRUNTcztF4w729OJEU0Yiuc=;
 b=T/mOW4jyUq5P7N71DAGwXaMQ+WjkcI2gFX/6wL0vcETPRlYUflEfa0zaX7SCvyBJdDSbBiUVjQRm2ODGainKrx14xH+84lrK46FD7hoeuAXMOm7UxijJ4/l/EjZT6bvHTbyj9BQWqGhuEzqhu56RvYni60l8MMLHghgShmYp36tSXjHyTlEBYAK+PaR7xCY8cbqlFKecniwvW2t+iD95ngQvzHLzBa0QgbiIpd2jMPsTuFqpMakCoqkgOUJKC1UeIn5eU7BLsoWsQ7y8ix1+Gb0OGRnK6uKuz6skP+a3UaxllXF5fbBlkdJpkPBCF1Rj+GbWO3T+NYB5JsnmzM6IcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0liGuXkD6iQDO/UAdGDIRUNTcztF4w729OJEU0Yiuc=;
 b=f370stbU21FS3cLThXiqDE4hb3h2otvk82OasGKXWeLN89kzxIupPb2+x8dUP+tgoA6sCTumBGholuXdZsEbsHZ/xHkvouGBeBYwTXoMm7MgstQ0AQ09z9Z0dzfSWFPwCAURLckXV4SEFY/UgWnWU0EXfiIFWnFFNuo9BDL25KU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB9730.apcprd03.prod.outlook.com (2603:1096:101:302::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 09:14:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 09:14:47 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v8 11/23] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Thread-Topic: [PATCH v8 11/23] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Thread-Index: AQHcq+b6PlWf3exVv0qNnn0g4WhUMbWfqTWA
Date: Thu, 5 Mar 2026 09:14:47 +0000
Message-ID: <3aeee75e78fed2be92038c776463a231b94462f3.camel@mediatek.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
	 <20260304-mt8196-ufs-v8-11-5b0eac23314f@collabora.com>
In-Reply-To: <20260304-mt8196-ufs-v8-11-5b0eac23314f@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB9730:EE_
x-ms-office365-filtering-correlation-id: e09d455e-2db5-407e-00fc-08de7a97a5cf
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: U52pIiozOTkpprC5Oaz1XbwdWA2sB2AMqolVb9lw5TcQqjaFMKBP0iv5BFUNC7mOjPjjrOF5f8bAMM7fGZ/u6FhfuCTfR4z+JSCKk/qDr4vXHKAc1NT8+C6Es+QTYSlcxa9OZ4nUiRwnZcXXSZM1XnDPXurcR+X2qoptSltSugL1ek74Kx1h6a65qVVEqaifYCjujjHZee9gg2e1eYzY60ajJDD6HErjWTGp1SllhdmJs4zsh+TTHzf8H62T89wwzlTCDpU8ihv+WoDncEBPV3syqK7jvsVzIA7nP2MADpqWQWbGeSEpGXqT+Tx51gQSPqXFlNOWHwgIn0rUwZgaX9wz2TQpz2WGf6Ditzq+87qW/MnURWsAtkNSiOJtmBuZqiwDrlRHh/B3e0O0yhvRFwDXmXmhPBLGiDgSM7tI3WGtqL5HUM5RM8dU/NK4NWvgcH1WeZnYb8DQAicZ7PVLqlFWZCMMNm4ApFjlBadweiaBzR8pq2umKC19/rVpBIz/6wDEdYqDchDLT/kHaS24bbdVlEItSMdRLmH+2dNrVs+z7Drun3aoZh+ffs1CV03h1zKpE73hkqejzaRaUbRzg7Nt4YJkd+ncOWjK0ufcKI3GxNblA/n1M9/BWDY4Hb6FUxtbLy2CCST7KS2i1lQWkZEKBToLHUnZttBOSlRJbAWe0PGz1+mCudFPdtYhNBb1LGJvRl63R53zoPZXVxVO2AKGKoil9JiKmagW9xr5vOpjCvEF/y2dNLPvUWDsLQH5YJjf57YQrT07cD09WMu5guUTUNyzUaF1Ea28mmJllAn1yLeVimP6eD8R3Eb23TTJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amlybFVkVlp5alFYUVNXZzRuUzJqQWZkeDMySDlHYWI1dnV2TEdzYnc4OWlZ?=
 =?utf-8?B?b05xVEVvSlpLYXZMQWlkRmFNR0Y5eHlPazkwYVFha3h6SUtSSWUvVUxLM2U1?=
 =?utf-8?B?clJiK3RwL0I1RTZnRUVJdngzVU1NRmtVOUtleEZLa2NvNFJKK1ZQRVROYW50?=
 =?utf-8?B?VUFFVlFQYVFDS2NYamJGQzgwOUtGSFhyWWk4L2t1T1VwRjNteFJuRDVWSUl6?=
 =?utf-8?B?RnNvd3RCamFrOStOZkwrbmdYSnhyclNJbE5JVWdFbWllQjVXZ0Iwazdzb3NP?=
 =?utf-8?B?NE1lQ1NIbHdTeTlGaS95Vmx3U0w1aFRBZGJyR2N2YkJQNWZ2SzMxdTNoRjIr?=
 =?utf-8?B?bXJ2RDNsbVh2ZjhYZnowc0JpanVZWFAxekJtZlVMWVNTVzN6WGFNaSs2d3NJ?=
 =?utf-8?B?QTA0dHMyeVQzN1dnQzIxcUw0UitrVGxSWGRpZmwrOW5nRXdZb1lXR3J6aCtK?=
 =?utf-8?B?MFg5RkVvejhleTZPbWlWbWQ4MTJXMHJRSURwREo1TDlJV3ZUSzUvSFpjNnpX?=
 =?utf-8?B?czlmVmdBTjlGOE1OSFV2V3V5NGZlRUxJc2pWYkJmdzdEN25FVTRPNmZ6VVNk?=
 =?utf-8?B?R3BlUzBFUk5GTU1GZXB6cjB0cnVldGk5Vnhsdmp1NDJWV1JKS2ZCOGZmQW84?=
 =?utf-8?B?ZkVPanIxeEJlVmxpNkRqODVpOWZUUGJXREpnMW5vc2NlbmpIM3ZaYjBWUXRU?=
 =?utf-8?B?RFdDcGN0a3hlUStFSkoweHo4MW1PbE1naWl0dHBVTjRqalRPblRKRWwyOFRH?=
 =?utf-8?B?cTdDR1dPNTVEZkJlRVRCcFB0VU93c0lDdG1FV0xNL2JGTnhTcXNLREtQWnNy?=
 =?utf-8?B?Q0dSS24vaVFXZURiU2U3SzNlZnhJN1dPcVpIaVdEc0lVL2ZlMVNvWWNIWWM4?=
 =?utf-8?B?U0pPSWR0eFNoK1MyS2RRQVpGV3A3djFMTXJFaFYyKzVmYVNJeElQdURRWjla?=
 =?utf-8?B?RnR0TmhzamN5RVdRd2k5VExWd2FQNXZTcEZKQTh0Z0dQbDkwaWZiR0NrY1dU?=
 =?utf-8?B?Rkx3VElXY05VVjF4anBNOHdYTDdIaG9keXY5cG5Rdkc2R1FUemVLQnpYa241?=
 =?utf-8?B?emVnZ2tIWkl1VHY5TVNtWkY0VFhSMDJCbXN5Z2V2amMveEZLdVE3QVVNdm92?=
 =?utf-8?B?V0FGOWdDZGpidEpTVk5ia0doYTJFSVVSZHZRUEFmSWRlMHZhQWJpbVliTlBy?=
 =?utf-8?B?NjFtTDJFcUlMTEgvYVhMbXUxRnR4cTViRmJZVm01MzY1ZEFXSDd5VGVJdW1T?=
 =?utf-8?B?VHFyZmZ4T2s2blg4cmk3MjI0T0ViTUplOS9oTlFHUzFtaWc5a1ZGckE0QVJM?=
 =?utf-8?B?eEh2ZWJYWHFnTEdlSjFML1RlMWRnSW5mUUkrK2NJbnJCK0VheENLN2NveDhY?=
 =?utf-8?B?Tk5qa01OTFlQcFlQcG05V0hMT1U5b1NlM2w0U1JhTndOUzlWcjM1aEZsMHBu?=
 =?utf-8?B?UlB6anQvLzlNUmQ2WHM1UU54d3pWbmgwdFJjQUQ4YTJHeUF4S2dlaEdoUWYx?=
 =?utf-8?B?enBtODNKYll2Q2NkWEdRaTdjUE5GZlNqek9xNHE3SzBnb1MwVStaS1JHbDhv?=
 =?utf-8?B?enlkc3lwY1FnejN5aDY3ckYwenRVZVlLNXJLWkNib0xrNy9QbHRJVjM0MUNo?=
 =?utf-8?B?R2FHQ0NwOUNIelFWc0lWR0xZQm1FNHZnb1lpTENnd3RRNzVHMjFVTGZ4Nk9w?=
 =?utf-8?B?RUpwNUxabUJBSndHU2FGRGkyUXVQWjNLWmUrdTBZR1JpRkVPRUtyd0VaeDJa?=
 =?utf-8?B?ZzF4N29CWjRtcXg4YVNhc0FvL0JRQW1TaU01K3NXbE9tRTFaeXJUbDc3M21q?=
 =?utf-8?B?dzhNdG9DK0NDQTM4bi9NQTdaZWV3K1g3NDFJd1JWNmNWdSsyYnZBVFMzaW5Q?=
 =?utf-8?B?dm53QUZVdGRGek1PaUZEZU85QnNaenFQUU9VZnpZTllWN2UrNzg5cXBKbk1L?=
 =?utf-8?B?VzZJQUZaT3FQdkVNZlA3dldPUTliTFE0cDExRDB6RzdFSzhkWVBydTdKSUN1?=
 =?utf-8?B?Y1dFcCtRQTFsTXlVemxJK0FLZkFPbzhEVSthQ3ZaenloNG52RnZiYkcrenRC?=
 =?utf-8?B?ZUxJSGVaVmxIZGNYZ2IrT3VXZ2RaS0Q1QTdWcURqSlgra3hRbXBmWEVOdDRY?=
 =?utf-8?B?MFY2cHZhaC9hQ3E0Q1dMYktMUGdUMURkMmxrTEZsbVJKNmt5WTdOb2RIMVN3?=
 =?utf-8?B?NlZDTGpCQ0F3b25oWEtWMHV5ZHBHaVFKMDBYWEpFV2RyZlRFUFY3NVdRZmNR?=
 =?utf-8?B?bWVVUFFCdFhzQWVlNjlKbjBwaEVkNStxeEFFc3JpZkh0Tlp5NEtzVjRTMEoz?=
 =?utf-8?B?UUQ0TDVMM0ZidGJraHJlWHUzWmNWRG91OGVoVWR3WVpCN3JPcUNQQkpWUUN2?=
 =?utf-8?Q?7L9F1dEe1ZCYL1M8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED8F3F3047E1354E9E64048010A76A63@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: dYro/uCdfPDAL4cj4ko1jDCDQI+aCTc1p/5mw/7Z/FjeQZQGHWKRGhndrEOYBPUHk83vKd9BAlqXnlxDnT237UrUBCk7oNdKyRwr4ZemTVxHqNYYj+jilmEYRblDwD/RSqh3PsJY5AAT3enGnuECUO31azhwzzQ/WEcGWYQSPKMXwjs3sNlYcxJk0a50qWC22zK+ljMJRVCQp9LFLh4kngt6vF2wb00jpasXnDFT/wdDYnM6/OthAWK7TadH9HA0aDhgDV5qCuA0EareNl/HAngffg5JpvcA1E0u6Sx5Usbsu99rwOMXEi5UeL7D24ty/DrViYNX9hQrWc6kk7kQxg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e09d455e-2db5-407e-00fc-08de7a97a5cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 09:14:47.3223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wg+RlXtRN/klE5gdw02i8YXp4Gc6/uZzI6XmJNIgoCxSibfh2E21z3qnSKV333K1K3TwYpxpjmNd/ApGaZuqqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB9730
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDE1OjUzICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEBAIC0yMzgzLDM4ICsyMzgzLDEyIEBAIE1PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIHVm
c19tdGtfb2ZfbWF0Y2gpOw0KPiDCoHN0YXRpYyBpbnQgdWZzX210a19wcm9iZShzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpwZGV2KQ0KPiDCoHsNCj4gwqAJaW50IGVycjsNCj4gLQlzdHJ1Y3QgZGV2
aWNlICpkZXYgPSAmcGRldi0+ZGV2LCAqcGh5X2RldiA9IE5VTEw7DQo+IA0KDQpXaWxsIHRoZXJl
IGJlIGEgYnVpbGQgZXJyb3IgaWYgcGh5X2RldiBpcyByZW1vdmVkPw0KUGxlYXNlIG1ha2Ugc3Vy
ZSB0aGF0IGVhY2ggcGF0Y2ggY2FuIGJ1aWxkIHN1Y2Nlc3NmdWxseSwgb25lIGJ5IG9uZS4NCg0K
VGhhbmtzDQpQZXRlcg0KDQoNCg0K
