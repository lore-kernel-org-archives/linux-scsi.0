Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CE114E2F2;
	Fri, 30 Jan 2026 07:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769759928; cv=fail; b=nZtwpZcyfP65JHWL6cpkCNtv7HJcI+IAJ3azj4Tg67y9KSBTrE1BGLZfqjcnXmtZa+Jf5Q5IswvwCCO0MwLtArV40+8T3DF9G5ZjHFs+uyQ7hTTIdhPJ6AC99kE4Su9TPUz00mU5NREtLTleFmj9aun7l4K9PrW7C+xw3bCFuAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769759928; c=relaxed/simple;
	bh=ZI1BT7n7+0+yGanUTCop32YzMBUpb3ogT1FpPA19z7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OyLkgvaCfTNdAMTZhHA4VCudJEl9hKGPKvf+UlUuGwlxuRA8wIH2ZCfhVgJ586mxEXVdZUgGkUUkzzo9uha34TgwHm2WYqzLd7gayvj6DdhE0LUKpBCDUZTJFGEj/4t0c1oTG6PlGk1YsxRoe7c6LNrAvChX8iqiTUYRxwNLgTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=CIr9HMBy; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BbORFQKT; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CIr9HMBy";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BbORFQKT"
X-UUID: 79d2475cfdb111f0b7fc4fdb8733b2bc-20260130
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ZI1BT7n7+0+yGanUTCop32YzMBUpb3ogT1FpPA19z7o=;
	b=CIr9HMByvvuynts/qOJ44DwJk8rYQxiq/nlvTBUfkPnVXJVWYyIDgZdqO8lfJ9vwaXK9KY18v07w0VbbupTncmeSLnsjyFstt8yY0p9tX5PYT5cPaIambPOYqfpWCqYwjdY83g0OkoMx37eaPdostQl9+g8cJVZDJGQ1DIXKS38=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:d6480a75-160a-42e8-8a88-ecc39feab2c1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:82e21ee9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 79d2475cfdb111f0b7fc4fdb8733b2bc-20260130
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1586167428; Fri, 30 Jan 2026 15:58:34 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 30 Jan 2026 15:58:33 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 30 Jan 2026 15:58:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C1ZORkxf/a4RoFi83gp4c3DfFe/E+aHWa8rJayHs83k5AW79gwThUlvuEV85A+tUhsIAFQDC53mGIUoF89WHRtIwsTrdDxixN+/rEMmD8ZXFxAbsCnSAJeWK1WWQYvDesDe9tDCBRS+p4lpRYl1IQflWGTIZBYg6EiynZs+qRHF/T5NY4LFMyd/K+Dx4vO79DG+AMZp+6IY4i8qQ4mEDCraUgCZ/vFTeznNOOFKVHrwaqxeNak8Do/Tu8D80MbQUwHrBCH28lHEn7WlRCaNwQSp78//xwpPEzKy62a9jhmCjxzBOkf+8wO3MIaqX57bEy86+to7ttvpFBjW/y3quEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZI1BT7n7+0+yGanUTCop32YzMBUpb3ogT1FpPA19z7o=;
 b=udFkACIJc1XrknixNF9ndpt6ke5KGrtpBff6BhY70BwSe80RB7O+CXzRTbpWKr63fcGSc3a2khB7qgqpLflZ6PoM1tL4PWbDnot8CiA2q0E/Z2Geuml2jwKYr2TrhYe1yxCygAkZ9/+HPrwfbK3z3vUoSKp60k3EfFUDRfyT4BrMODyFBEixnTRoff7Qv9GIPUH1aMqc1N737CzQkv9ZARFYpAHcas10y2imCAt+WFO2qxbLVEQpiqp1edlwYBal+fOQfrJPIWw4CdtzEdUerAAUAiPV10grLGNN0L8psXMMzMILdHPjrvmihy89VBPyQYwQw3y2c2i+seH9mjzkog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZI1BT7n7+0+yGanUTCop32YzMBUpb3ogT1FpPA19z7o=;
 b=BbORFQKTjnlYxc3xsnh843mVNDRzi+XHOzp2/IkxnqdQ9H59VpvL2vFz5NP37VKCpkaZNy423bT/9crfqKS5KkI/w+Ne1CPIBkypQ6oxbgPtrSAw8kHsmMUm7YzFOnze8ejnMWc4PID/7LVFOb17786A+0Md9SQyZpXtPif9QyU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB9754.apcprd03.prod.outlook.com (2603:1096:101:304::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 07:58:30 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 07:58:29 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "thomasyen@google.com" <thomasyen@google.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "subhashj@codeaurora.org"
	<subhashj@codeaurora.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"sthumma@codeaurora.org" <sthumma@codeaurora.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "draviv@codeaurora.org" <draviv@codeaurora.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
Thread-Topic: [PATCH v4 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
Thread-Index: AQHckT/GAoBnUzqNnk+/ms9+77pbBbVqWfAA
Date: Fri, 30 Jan 2026 07:58:29 +0000
Message-ID: <348df8f6023f1161df57d73a6059b671f3c771aa.camel@mediatek.com>
References: <20260129165156.956601-1-thomasyen@google.com>
In-Reply-To: <20260129165156.956601-1-thomasyen@google.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB9754:EE_
x-ms-office365-filtering-correlation-id: 136d883a-0d61-467b-9d27-08de5fd55af9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R0UyMTJCL1A3dm5UckphdWI0WUNBb01nWWZQSmxySzRXcHZETDdmVzNGRkZX?=
 =?utf-8?B?bnNKOEs3cWZMTEJMRUV3Z2toKzdwR1JITmZJUDAwNHRPZmE1RERpZmdRQnI3?=
 =?utf-8?B?WW5vODIwSUhka3pFdEh2d0ZiU0xCem5iUUVVUWpmUnI2aWovcGl3Z3o3cExB?=
 =?utf-8?B?T3pzQ1pJdnVwVjJRdHZyZmNzMEJYOTAxVVRtd0FhY29rWkVRMXJVS2htMURI?=
 =?utf-8?B?TjdvYSt3Yk8vTksyY1kwSDZXcXlZbVhqVGxPOWJLOVZHdGIwMVhvc2hPWXIx?=
 =?utf-8?B?bGtzR3FCenBxakFGdU1BNy94V2F6YlQ3NlBTd3JIVEhXbUhJcUpIaDhSc2Jo?=
 =?utf-8?B?OEhiV2NiRkxkajd5N25yOEtzMGNOaUVweDZnd1krV1I0UHBqOUU5MGlkZUw5?=
 =?utf-8?B?S0U4UFVnVnZoUWRLL0IrcVRnQ3Mwdm5KcGdEVzJQYVU5RE03dFZENCtKbTJy?=
 =?utf-8?B?WTg1UTh2dnQ1cVRWT096OG9GZ1FkY1I1WGRialRRY2VleVcrQlg4aE52YnNy?=
 =?utf-8?B?YjcwajdOOVcwM3RGL1pyeVNKR0RjOHNQTWMzZys2empZYWpxY3RDdVJUQ0o3?=
 =?utf-8?B?R0VQSk83RzdBcEZ1NVFLMHVMN2RXNmZrR0YvZzlXdWJQZ2lqZW9KbGR3Vnkv?=
 =?utf-8?B?Nlk1YUZNVFBXSVROcTNTZml1aTAzRlVlNXMwUXptUzBhYWY1RWhnRkVXYTYx?=
 =?utf-8?B?WGI5RnZRcE5qQ083UmtlSjB1d1JWUnljN1h0YVFkQWhpa1BZSktrTzNPZTdX?=
 =?utf-8?B?bUJ2MzBvWjBmUU40MEdvQ1I2TklQM2VMWHlqMGdlcGN3d3B3WFFNNi9hU0c3?=
 =?utf-8?B?SGJqdHJJV09DZGNRQVhXNnVCMGRpRTQ3OEJJRWhwSXd0cmdKdGFCd2ErQ0Zw?=
 =?utf-8?B?bzhzZU5PalAyZGhPOHppT1NNOUhXUzc1M0lmQWdHbVlCRUZTSEtVT1RjUk8v?=
 =?utf-8?B?WGRteTlHZ0dmOHRiT3F2dG1IUHh0SUVxektXWW43VHQ1emNXUWJxQU5tRXRE?=
 =?utf-8?B?MkpsU2hkZVI2U0gvQkJnMmkySXprblFPZEhCb3RodWdLSGYxcVFuUjJYRFpX?=
 =?utf-8?B?VzgyOWpLMFpiZTNOYVRhakV6dElmUC9DRk4xM0dLUm1ONXlwaWNVL1p3S0wr?=
 =?utf-8?B?aHFzVjljYjM0QWNLYWVPT3psK210NkFXYmQzL2MvZ1d2bUJ5OEFSZXl1a0ky?=
 =?utf-8?B?a1o5QVBPMnRoWm1Ublo0eU5UYnhrQU9VNEdDMjRCQTByV2ZoTHVBWHpXRW5y?=
 =?utf-8?B?QUN4K2VCMmtzREhRUDF5SU15YWw5S1B0N1cvTUs3WEdVVGdIYUNYQWxsU1dy?=
 =?utf-8?B?aGZaWFdpT1Q2UHNocmRqMGdsWTBQaFVhemJuNldYaGZZZ3BzdjdPK2czZHRI?=
 =?utf-8?B?ekRmelV4QmxhWGVKd3pZUGtwcTBBQnZkSmgrWURmQkFVN1Z4K09hMVRISVA1?=
 =?utf-8?B?WVdBRG9xWUUwWU9xMHVPVTdzZzloWlNmclZwdFYvdHdVK2ZST3V0OFV4KzBK?=
 =?utf-8?B?OGNSSlhpTHo1K2NTZGZPNHdPcldMWW5BczhRVG8yUFcwVXhBbjUyN2RvSXg3?=
 =?utf-8?B?YTkrSkZkejhmNVdjc2JEcUE2ZDVFRnFkOUVMOFN2ZnM0clFLY05vK1NUQkV6?=
 =?utf-8?B?akVoRzlSNTdnTzlvN2lGMVdCYzgxalFGTFlKMnMyaVZFOEY0SXNUMnBlOUFj?=
 =?utf-8?B?ejBxWkp2cXpQeVdqbTcrUXFFVDJKS25ZYUkrWjM5amxpOFpBcWhjVG1WaUd3?=
 =?utf-8?B?SlBJMHFlMFFZK2hjNzJzSk1FT3p4NUJBMXkwcThGU3diakY5UzVtT25NWDB4?=
 =?utf-8?B?dzZobklMbTBFZ25OOFROcTRIUTNnSU44RlJrVWhjUjVXazAyZmxTNlpHbW9t?=
 =?utf-8?B?aElEUHBuejM1NzkwTld5djArVlI0Ky9lNkhqSXozM1QrUklweUcrdnJUS256?=
 =?utf-8?B?ZGRQOEZSK2N5UUdUaGs2UTduczNFWGtxUzIrajNmamw0RWZWL2gwV0Zra3I2?=
 =?utf-8?B?WDgxQ0Q4bDkzUzMrSGR1SS9KeEhKZExrZE1Ta1QzWUdYYi9UMCtSNFNPc2RX?=
 =?utf-8?B?bEJ4U0Q1K1VlbWZFbXo4djFDS1gweHBOVXNjVHpwODdPRnpkQ1hDbEY3bUVL?=
 =?utf-8?B?d3BJYWFLd29vN3Y1N2k1U1Njdy9IbHhuMzJMZURWNXJvZnFOcTlTWVBhNFQ2?=
 =?utf-8?Q?2TjqHljmqIPdmmyvdCuDdEE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUp1ak1YUWFjZkFia0srOVp2dWtTTkFBcEZTOEM4MmZxZzZYUUdzdnZ6aUwy?=
 =?utf-8?B?UHhkWkd6QTBIUjNHckZFajV1QnZ0SlZEelR2RHNwUUIrYTl2SHgrUWtHeVM4?=
 =?utf-8?B?OWRoaGE5cDlReVIxNXNDWWtFRHVxaGF3dndib0FhWHhqT3ByeDFrcmZqQklK?=
 =?utf-8?B?MDJNbWlMTDd5ZjBwcHozOEtuZ0hHY0FWUWswN2kwR0ZjcFpGdDVzdDUwekEz?=
 =?utf-8?B?b2RmLzBpM0NaVU02UTUwYzNCSW9NY0pWaVdCcHA3ZmNDSDE1RXFKZXJkSFAz?=
 =?utf-8?B?QjkwQTgvZEFMTVlHcEN1akNLZnhwWko1UGFIQUplb21XYTRTNDhvdDhINmE0?=
 =?utf-8?B?NTZveE5QSlJqMHF0endIMzNwNHY4dDQyU2R4V3hYeEhmTHhjVXk3RkFtUUxs?=
 =?utf-8?B?YTNzVXB4UmxXMnpJSnlCdzBIclYvZnRITmlBR0VMOHhNaGszRmtCSStTZEFC?=
 =?utf-8?B?K3ExWFJ3NER1bmUrTnd6QWFnSEpJcGQ0L2lyNmJKWkU5aDZjckdYSkxhRDFQ?=
 =?utf-8?B?bU1JcEdlUHVCT25zODBQbHRtd0cxR05OMWM2d3ZCc056QzI5TEhBazhhQjJp?=
 =?utf-8?B?bVJseFpZek9FcWRreEJoSUhDZmZRZXl6SFZXS2RwNzlNVDlqREZZWG1nZkdv?=
 =?utf-8?B?d29KZHpETXEvbDBneWkwVGtMOVhHUmczVHN2eElwajdvVi9QMHZOZktlcTR2?=
 =?utf-8?B?U0ptUzdnOWlsMk45RTBHR2ZoaUxEMnpXZUZPZ29HYVMvelJ6ZTN2VS9OTEli?=
 =?utf-8?B?UVlnd3FzclBndmpJSHN6U0JZOVJTWDJUMzdiRHc5eFRZTjhoV25HYXoyTWxK?=
 =?utf-8?B?YW9waVlGMlUrMjhjNzIxYXNuRE9Ua25pUktpQzZnNFFKcVJaM01XbXNndGI2?=
 =?utf-8?B?NWQ0Sll5SGpyZzVDcXAwbW85WHNzSHgrdWNzeEZUUFhvcnlpSTlRcDdwbmh4?=
 =?utf-8?B?QmEwUmxLdnIza0M0WDU4RmN6NVU1SHIwY2dUektvUkZqVnM5NEJndEkzS0Fl?=
 =?utf-8?B?N2lpTlVhUDhwdlpYZUE3cmJPQWJIOUlMWWRaRTFLaGpFaEg3WHdCTDM0UjdM?=
 =?utf-8?B?L1ZNWmo2QkxhbWJOaTczOEJuNnMyNVRHTmJNekc3cEhVMUx2d3ZiaXVIUUlL?=
 =?utf-8?B?MkhrZ3lIVjlZa1ljNlp2eUJtM2dzTFpiRTBGSjJvWnpuU2Z6bC80RGRieEt4?=
 =?utf-8?B?L2dveTk3YytjanNNb3hNM2U5QWUzemU2MmhNdEVqRWFMYWhpOVBHaVJPNGNq?=
 =?utf-8?B?cUlxS3ZDbXVWSjV6bjEvOVVPQm5rblVBeDN0cjRFanFWZU9ya2dPaGV4V211?=
 =?utf-8?B?V2dyM09WSzlkY2ZkVDhSb2FmZlJGc2lrcmtlNjFRWXFnRlBNWkV1WnlGcHlu?=
 =?utf-8?B?d3RsR05IUHk4eTJ3aTZPYWNFaDNwRDVhZlpNWUZhdmlwbkdrcE9oQU1vWmdW?=
 =?utf-8?B?SkpTQzJGWVllUVBtbkpEMU9ocjZqOWpWaVp0QWpnQkkwY05GYjlOTUFjVWVL?=
 =?utf-8?B?R0JwbDk4YWhET2tIZjRPMHkzQStBa28ycnc0ZWtESloyRjdEeFd5QU1nU1dh?=
 =?utf-8?B?NXlaOGZaeldOU2Q3RStvTzN4Tk14Q1BHdlcxYTMvMGFweVJTWHl5UXZuN0Jr?=
 =?utf-8?B?WmZiT3lVQTY4dXd0eW1zWXpjZ1BGM0hEUGhuK3NENStXeE5tVWF6eDliMldC?=
 =?utf-8?B?RlhkZVNUUmVIRksvYmFGWTNBZ0E1NVdrMzU4d3l5UjF6NVVzbHhrRnJCTFRD?=
 =?utf-8?B?UVByeHdnaXBka3JTUmxELzdLVTNoUUg2ai9zZWR3NTlHWHR4bVlwdDhqcm9u?=
 =?utf-8?B?Y0NseFVpdDhGeXdQU0ZFOHZJVWQvTzduRjdlbW9yQWEzUUdxUWptVzFkSzFz?=
 =?utf-8?B?ZkdwNWZDS3dnaUwxV0NsU1FDMkR0STZZZ21Gbi96TmZURVBWMjZnM1o2ZHJS?=
 =?utf-8?B?SW5GYjJrL1V3YW5kN3Q0ZzBaL3Q0VlNNV0pvWFJiOVNPWENyamQ3VGc1a2Rp?=
 =?utf-8?B?YmE1SVN2ZEFXTTFNQmFnVkFESGF0WVc5THFZckJ1OGlGODZWWG9meGhZWVlv?=
 =?utf-8?B?NTNZdm1WRDI5S3JWQUIxelRYQitCYTY3ZDdzMFAyOFpRenNhS1g3d2lyMm5B?=
 =?utf-8?B?c2IvTXl2anl0aUxwNFV6M294VytxZ0tvWUNDeTdnblBPbDJYbTlFbnhER01H?=
 =?utf-8?B?SmlyWlM5OTMrT01OMnN1UTRSNWEzZUtCcDQxcWhQYjUyNGNYOHZGQnNUSzhr?=
 =?utf-8?B?OXpKcytVN1U4cGxpZzBhbWp6Rys4U0lQTTg5MVVxUVhOUVVmRGRuaVEyaDZo?=
 =?utf-8?B?WnZxWHpiU0NtNzV5U0tBbHplV093N2ZOQVYxT21aVlM3ZktqeVFZQVBTTzFr?=
 =?utf-8?Q?NRkh16e0Z7JE0umk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <560F14F682C8CB44B73E0DCF10542D0A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 136d883a-0d61-467b-9d27-08de5fd55af9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 07:58:29.1994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DHnbmaCu4EDjn7AbDjgQYMknTiVd5w6rvQFM8XeEwPz/TllijjfdUtk0RZSQzI6QM9oF6GZ7HMeqKTb0Ub8cYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB9754
X-MTK: N

T24gRnJpLCAyMDI2LTAxLTMwIGF0IDAwOjUxICswODAwLCBUaG9tYXMgWWVuIHdyb3RlOg0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUv
dWZzaGNkLmMNCj4gaW5kZXggMDM2OTA0M2NhMDEwLi44Yzg4ZGQ1YzJjY2EgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KPiBAQCAtOTk5Nyw2ICs5OTk3LDggQEAgc3RhdGljIGludCBfX3Vmc2hjZF93bF9z
dXNwZW5kKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiDC
oA0KPiDCoAlpZiAocmVxX2Rldl9wd3JfbW9kZSA9PSBVRlNfQUNUSVZFX1BXUl9NT0RFICYmDQo+
IMKgCQkJcmVxX2xpbmtfc3RhdGUgPT0gVUlDX0xJTktfQUNUSVZFX1NUQVRFKSB7DQo+ICsJCXVm
c2hjZF9kaXNhYmxlX2F1dG9fYmtvcHMoaGJhKTsNCj4gKwkJZmx1c2hfd29yaygmaGJhLT5lZWhf
d29yayk7DQo+IMKgCQlnb3RvIHZvcHNfc3VzcGVuZDsNCj4gwqAJfQ0KPiDCoA0KPiANCj4gDQoN
ClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0KSWYg
eW91IGhhdmUgdGhlIG5leHQgdmVyc2lvbiwgcGxlYXNlIGZlZWwgZnJlZSB0byBhZGQgbXkgcmV2
aWV3IHRhZy4NClRoYW5rcy4NCg0KDQoNCg==
