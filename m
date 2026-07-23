Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBC24D8DBD;
	Thu, 23 Jul 2026 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784813047; cv=fail; b=Fe6B3bKSrtt4LMKNfF50zcFIu+i9jL+l2JV09Lb3t6x39gDlSDoU3PBjQ04XEciR9OyhxNGQPyNvFrq3l4Dc4GPd34Gy8cHErymh3nMEddKdsRtCHOiJTIP7di/hiigCcgps0F+oFt8kW/aas7ZME2vx0wn2oChZJ6DqgU1iDMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784813047; c=relaxed/simple;
	bh=bDOJsU/9t2zWkKn3Lp61DjIOUs+0zyvbgeqC3KcRLoQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hgJw57zpxgxruHuNLDxWSC+PypZV3VdLYa7JX9E8CzotlJpeRgHLylN/cbnw9LHlSY4vVaWDMxzczcD644VBB1jFkD6nDshY4vsxkz8JE6SUmXGKEQ+HvplqYnFWgj7R6CEVmtq8/VBpnqomtjHJw8yeTjE90KFmdjtKmZ0mUeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ESM+mic8; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jITsIaQt; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ESM+mic8";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jITsIaQt"
X-UUID: c0a84a52869911f18dc8c9802ae25ab1-20260723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=bDOJsU/9t2zWkKn3Lp61DjIOUs+0zyvbgeqC3KcRLoQ=;
	b=ESM+mic8E1ZUrxSQRW39Lh2LWWHETNAyXkf66RXjwKhMguRBwXLslYSdC69oB0xmqEb9tc5qs+sB4Wh/VTQs7f7FxitOQ3b3T7eBKhVSygyTm75B5JvI0DzLXHzoP53ruOioJqVceEcKDabapLzpTm8ljU8KWY9IW4IHQPkguck=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:bf089068-a5f9-4966-8787-47546b81eb6a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:0d1dd45f-762a-4584-baab-4eebe609beea,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c0a84a52869911f18dc8c9802ae25ab1-20260723
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 540131657; Thu, 23 Jul 2026 21:23:54 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 23 Jul 2026 21:23:53 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 23 Jul 2026 21:23:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XT14Zxs4umnlTiLJjlP2jVxWOIfhzcJUKzk4lOWvJtji9WWBVs77zHrqAFBJcWofBq1S/+6NaMKPoPilZr+7VcfHkpDd/c9kwo7y/Do+QaUVFgH1zRRCohDR3FjyJ/Jdgw/WFPe0sv3KrOeeKOkMWSItd9Sb09cZbXD0/efEBaJUyhnNQw00CTizKOnL1L2kYCjH/9NCI4+JwIxAbxmMwiZYsN3JXAip1+wno2Kv457xbHunCkGZCESSq54G89W5Ritx/LaJvC3bIGIegBQAI48XQMTSCIKydEoWZdluYm4njcq/WDU+7whfK1fbn5+nbtzbKkuHMQOdBY30oTDd5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDOJsU/9t2zWkKn3Lp61DjIOUs+0zyvbgeqC3KcRLoQ=;
 b=maLoVLnTGA7jwrj5+U+u9DXtbFApWdkkcjmAjM3AOuVC5ecSMewp+GEsJzBOY2gZZ+IDQrD1WKLaI7eUzx4s9VeUrJjFhYwuKfwEP6RbRw9ZeMOV/7ot1ig8MzZaQt/O+jAIZyDOYjHIfbVkFeka2hsPiZHogEFIZXcgvA/55PnzwA0k9e3YrZTBICon21R3ZAhC0TYh5bj3BZ3fVWh4I1J06Pw37PI8tYSOSVDF5jd7elQgWZcKETgZze3zqsE7+cS8cRSQ7Qfnckv/wKXsLaTFChSCWO2T6FCCdT/6U6xQnJVwfN1HfWrXs6vmf9QMqlGTyeFBd7YZ8kLo9qFXNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDOJsU/9t2zWkKn3Lp61DjIOUs+0zyvbgeqC3KcRLoQ=;
 b=jITsIaQtDjZvdmgUGUtIz5ufW4kYSl2dL2zohQfZQUKM1SODUhnvjo08Qnat1Ijco2zkaALDoXEumIc4/mjVcuz+avgfUpCp9s0jLro9cs1xi9ZwTXVCt6BKjn1menI2KL9cseDZzS0/9BcbyYmMf+RJ+tB0+qNJZN/2LQE0aqE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8457.apcprd03.prod.outlook.com (2603:1096:604:274::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 13:23:51 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 13:23:51 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "manivannan.sadhasivam@oss.qualcomm.com"
	<manivannan.sadhasivam@oss.qualcomm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"shengchao.guo@oss.qualcomm.com" <shengchao.guo@oss.qualcomm.com>
Subject: Re: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
Thread-Topic: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
Thread-Index: AQHdGqGbXvTTTHvqBkWHZeyNUtVtI7Z7F7wA
Date: Thu, 23 Jul 2026 13:23:50 +0000
Message-ID: <369c39e0e7ec6d78d8e10ebe74c01cccb7869d72.camel@mediatek.com>
References: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
In-Reply-To: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8457:EE_
x-ms-office365-filtering-correlation-id: 7cd3b73d-427d-45dc-748c-08dee8bda2ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: dVClEb0Iu9J85nyfi1O0+mCiZlwfXxQ+x307fLksR3lfGOGxkFC8bW38tZhH/y8sRiPleIfw8t8Qt2xWGTQ4fI9y1iLYH9s/6JTq4miGu8HDaHX/GaBZNbrRl7gdVIz9/iR/AY+cMKHfxTXzfU/P9+As5+JjNqqHvxco4FiGC/6y1709eMANsxzox3SNZWzP24SCwvDJ2mOkHeSmizCmewOzKKt5wAqHoIo/nps+ncDdWPx8oM7v2eqc1ZshbB15MKYjKWZcKdhrog83iQRAuKCQVHcV8JkzD6RO54Kqdm0CX7/9uwTeZ/7oUC/eOZWZItao6BJY+uZLOas6IIDyu7Ghd6BQ++LMKQkrzUN+1ctDs1Fkfnie9Rh5XKtFn5Jboy8b9TIAPXFuHcVMG77FlrzyHIyB60iRY3CrB//RLNrbW/jTKMIrBEyLEaw/urRusFtFx5CglRER4lXVBEXyeYtS5YXvACqxWfgev1JwbGIH9FZV0h3UlK7JVFvgARsSIWDckzIoaxjHXrlsRAPiI2/w0IWfsHv3bFog6WxwzTV7gpGg4CTdQsOsx6YYh8303Tyuddpkotlk/PdfcWa0fBrDl/P1vr1k830B/un4wsc0oWcVJtHtL+HyhjU/cUWGpMQJ2ako3g2YKeCD8SJRZQEefLQ3EKEl5fBf0Y9dBFIdpfA8o6bmPIYZ4pt2OvGiD1fbAE1IWBc5FMjhTMe+yk7FvPi+I0HyW0utjcGPUag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXZsc21kV2lqM2ttVUZlaDE0N0pFRGo1bjdTeUhSTGpqaUdyRUdYcGxHemJo?=
 =?utf-8?B?U1NjR2xEZGpLQUNOa211S2JNREs3ZHNTMUp1NXdTbHZvRWZvNCtadGg5Z2Fi?=
 =?utf-8?B?NUFMSUFvZFBmZWEvQXJEMlRSallQL0dPRGNxc3A2MkNsMzZldndIdVZ5L3hr?=
 =?utf-8?B?cnU5TE9ndTJPSENEM0FCbUpBbHBOM1Y5Mm9lVWVDVTU2bml0VlRFejArQUtX?=
 =?utf-8?B?bC9JbTFYajArdHdrUGdZQmVULy9Dci9kNHh1c28vWmlSMG82MlplQW5GdnUz?=
 =?utf-8?B?VTg1OVdHYUhleFFjR1FyTlpMamFZSkFsSTNaZTc0L3hFQWJBUVRWM2xsVFho?=
 =?utf-8?B?QXF3UUo2ZnFUUGZRcC9CbGZaT3l6WFN3Nkl2TU4xdFpLakp6di9yaU1Rektz?=
 =?utf-8?B?M0JjSXYzMGplK0x1Q2s2ZnVaVkdlekpBNFo4bis0WXNSN0Z3b2E4bUUxcmQ3?=
 =?utf-8?B?NzQ1MHJFUkJOdFE1WjdEa2VnUFNTNDd3WFplU3FEZTFNcVZpVXliNnNrRGJN?=
 =?utf-8?B?WHJ5MzVUcld0Nlp3UFVQYmVXU01VampkRWNFYVMyVkZwMUlLMDdKVzRieWVa?=
 =?utf-8?B?ZjRLVnJWVlA3Y3AwSFpOOW9GSU5VVWZLNUZWTlkyc0V4bFg2OGd1ejQwMk9q?=
 =?utf-8?B?bkE2YVBtdEhYbGI2UlZHTGdha3ZDRzZremxPM3p3bE5DanhnT2Zld3RpRDMx?=
 =?utf-8?B?bjI3SHE1TndobmdGZkFrUXVXb2tpNE9FMXIzQ3Z4QkhTUVlTZzAzdjQ4WHpi?=
 =?utf-8?B?Q2NhMndUL2dad0wrVUp4RWNxVk1DTXByTiszRFFEWDJZVEtvS2RIa0REZUFs?=
 =?utf-8?B?ZnloQkFIc0VrMncxdzVVR3lJYks1MnZEOXJvUlhhVHpoQ2o5ais4c1grYnF1?=
 =?utf-8?B?bVk4MEpRMnhWN3Z6Z2hlZDRzOGhuQUN5QWN3RGNrZ2diNnNpekYwbE12K1Yx?=
 =?utf-8?B?OU9lUnNSemdNTytWOHpTQnR3SjhhMVNVbGNuTjhVZm10aFVYM00rZ2pIOE5o?=
 =?utf-8?B?OHV2UGZSZWZ0T29ZZUpjSFpvRnV0MTFOek1Wdk1IV0pId3l4andaYTY0Z3dN?=
 =?utf-8?B?eHZzcnhCTzdYUXUyWGZ6TkhRbXJCcStsWjEzZGxXQUEzVzBNd2tvTU5HdWxF?=
 =?utf-8?B?amtyQWpPcUVwcTIrTlBmZXNDQkdvNkt0QldSVmhZVk1rQm0yaFlXellDMFNN?=
 =?utf-8?B?b0pMYXNrdkJzU0JlZ0ZnMmJjdzd2TE01dFZoSzdQODAzWE9CbGNhRVYxZGxm?=
 =?utf-8?B?QnBWcWkvdUlGcHdTblRoaW5NTHhNOGdnNG1EZWVkMGNYKzZydCtjZTdMM3kx?=
 =?utf-8?B?QmJNWng3QmVWRmkvMmk0TE1nSmNFU0ZyNGVUQS9OUmlBWWJVenpqc2pkaXU3?=
 =?utf-8?B?VXZGVVJ1b0xyaU45ak9YRzBqRGwwUHZiU0NMRjJRYmhpaU05U1dTelQvYkQv?=
 =?utf-8?B?MmpzTUI5NEV3VXlQNGZkVDFBN3R4QzdwM05UL2szcjc2M2VnY2xuZnBoWXk0?=
 =?utf-8?B?S0Y0dXJiclkyZ2NSajZtNEdjOG5uNkNOdFpaS09ibXJSZHJ1cEZTVFJNaEh3?=
 =?utf-8?B?aEE2ell5c0hKcnd1cFhOdEtpQjAvYW9LMnZrUEFnTHVXQ2huZ2h1RVVkU0lt?=
 =?utf-8?B?OTRycTN4aU9sU0JoSHdFQ3kvVW83c2QzZFJ1OHhrWFRxOW9UOHFOSVhPWGFK?=
 =?utf-8?B?bWZ0ODlGLzVUVDYyMUVzME9HSE1zb1dWTmtuVEd5ZzNLT0J5ODBEaXVXRlIr?=
 =?utf-8?B?ZmhPd2p6elNQdGNrVHU4U29XbkNvMmxONEF3MEpCR0srcXNPMVdYZmZpc2kr?=
 =?utf-8?B?RzV6V2NLSzNqTkRaaDBmVnF4NkR4QkRrc2RuWWFiZHBPSHhsN3ZneHJhMUFQ?=
 =?utf-8?B?WURrWUg0YnZ1bVhnVUVHdk9saWNiZkdYR0NiSGsxaVEvSGFFK2dHNUJGUmwx?=
 =?utf-8?B?RzRWeXNzYllVdlI5akFFQ3RZZmhGWDBTNWVrMng1eVJ4QjFKYXFobVduc1d5?=
 =?utf-8?B?eVNHb1VIK2xaZDdGaXkrck1Jd3c5ZkNXS0JhbWxOVnNaRXgrd2RmaGlsWHpo?=
 =?utf-8?B?VUMwVXplaG43d2R5VTVmSnFCU2RhSTUxSk1FaXNOWFhRdDRPN2R3R0ZiYkV6?=
 =?utf-8?B?YVh3S2htMkpjK3cyQk4vbHZNUkNSZm9XQmJaN0lnNGFsSnJKbTNtaE5UMWxl?=
 =?utf-8?B?VGZ2cm0vWC8xYVZrbkN5aEt6N0pOdWZReVdrRTN1ZDZpSGs5Zm1ZMEQ0OWhy?=
 =?utf-8?B?MlpBVHZQbDJRdDFWdkZ6VlRNZS9yRnlmbmZMV3B5cXM3ZHVHWEFoZHFIdnpU?=
 =?utf-8?B?OVVlVCtlOVZrT0Qwb2EwUFBSZjhOSzZoYVVLNlJjYVlhelN1NThkcWxaZU1z?=
 =?utf-8?Q?MI4r0aSedPhObyGo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A18B3FB3332DC448F12E1DC0B278BA7@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: S2WfeUw/1QjS4oXhfuKUxeD77HnxMhUpgbR4ojYuA98r/vyICTgsUN0ZR+8kDLeZJq+tABIR9OrGKn8zOxYJfn/LhqP9coBo+PW7irJjInl16jjkYUUzfwSE3mWuoWjBnTGNXO48ELy4G27ctr0zQLPkC61e4phshwsQkx2Rt2cB+M98cuL5S6tg+kQgiStqJzQvCLit9QEb3pGsbqYE+tqKONlHUjpnnl8x8H9IdJ48Hq9+jKX8bWFGG9vpptnxnxJsHk/mLavoGh3D7gq68eXWmavzbc884T7nmO/1nrx+AOdlwYximuRXtG1z7hOm636mbXKbfEB4amf9XWZArA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd3b73d-427d-45dc-748c-08dee8bda2ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2026 13:23:50.9500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7uLImtgOqJ7MJ7DQEmhaHyfPU10hpRU3uEFBXPE3FYE2Ze07spgAWdC5+JRbEEfAA27In5CZgBjy0IcDankgzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8457
X-MTK: N

T24gVGh1LCAyMDI2LTA3LTIzIGF0IDE0OjQ3ICswMjAwLCBNYW5pdmFubmFuIFNhZGhhc2l2YW0g
d3JvdGU6DQo+IFRoaXMgcmV2ZXJ0cyBjb21taXQgODViMmI5NjYyODU0OThlMWI1NTFhYzg1ZjAy
Yzc5Y2QwNmMwY2ZmMC4NCj4gDQo+IFFjb20gVUZTIEhvc3QgQ29udHJvbGxlcnMgZG8gbm90IHN1
cHBvcnQgc2NhbGluZyBjbG9ja3Mgd2hlbiB0aGUNCj4gdHJhZmZpYyBpcw0KPiBvbmdvaW5nLiBC
dXQgdGhlIG9mZmVuZGluZyBjb21taXQgcmVtb3ZlZCB0aGUgYmxvY2sgSS9PIHF1aWVzY2UgaW4N
Cj4gdGhlDQo+IGNsb2NrIHNjYWxpbmcgcGF0aCwgd2hpY2ggY2F1c2VzIGJlbG93IFVGUyBmYWls
dXJlcyBkdXJpbmcgY2xvY2sNCj4gc2NhbGluZzoNCj4gDQo+IHVmc2hjZC1xY29tIDFkODQwMDAu
dWZzaGM6IHVmc2hjZF9jaGVja19lcnJvcnM6IHNhdmVkX2VyciAweDgwDQo+IHNhdmVkX3VpY19l
cnIgMHgwDQo+IHVmc2hjZC1xY29tIDFkODQwMDAudWZzaGM6IHVmc2hjZF9lcnJfaGFuZGxlciBz
dGFydGVkOyBIQkEgc3RhdGUNCj4gZWhfZmF0YWw7IHBvd2VyZWQgMTsgc2h1dHRpbmcgZG93biAw
OyBzYXZlZF9lcnIgPSAweDgwOyBzYXZlZF91aWNfZXJyDQo+ID0gMHgwOyBmb3JjZV9yZXNldCA9
IDANCj4gdWZzaGNkLXFjb20gMWQ4NDAwMC51ZnNoYzogcHdyIGN0cmwgY21kIDB4MiB3aXRoIChN
SUJhdHRyaWJ1dGUNCj4gMHgxNTcxLCBtb2RlIDB4MTEpIGNvbXBsZXRpb24gdGltZW91dA0KPiB1
ZnNoY2QtcWNvbSAxZDg0MDAwLnVmc2hjOiBVRlMgSG9zdCBzdGF0ZT0zDQo+IHVmc2hjZC1xY29t
IDFkODQwMDAudWZzaGM6IDcgb3V0c3RhbmRpbmcgcmVxcywgdGFza3M9MHgwDQo+IHVmc2hjZC1x
Y29tIDFkODQwMDAudWZzaGM6IHNhdmVkX2Vycj0weDgwLCBzYXZlZF91aWNfZXJyPTB4MA0KPiB1
ZnNoY2QtcWNvbSAxZDg0MDAwLnVmc2hjOiBEZXZpY2UgcG93ZXIgbW9kZT0xLCBVSUMgbGluayBz
dGF0ZT0xDQo+IHVmc2hjZC1xY29tIDFkODQwMDAudWZzaGM6IFBNIGluIHByb2dyZXNzPTAsIHN5
cy4gc3VzcGVuZGVkPTANCj4gdWZzaGNkLXFjb20gMWQ4NDAwMC51ZnNoYzogQXV0byBCS09QUz0w
LCBIb3N0IHNlbGYtYmxvY2s9MA0KPiB1ZnNoY2QtcWNvbSAxZDg0MDAwLnVmc2hjOiBDbGsgZ2F0
ZT0xDQo+IHVmc2hjZC1xY29tIDFkODQwMDAudWZzaGM6IGxhc3RfaGliZXJuOF9leGl0X3RzdGFt
cCBhdCAxOTY0NTE5MTMgdXMsDQo+IGhpYmVybjhfZXhpdF9jbnQ9MjANCj4gdWZzaGNkLXFjb20g
MWQ4NDAwMC51ZnNoYzogZXJyb3IgaGFuZGxpbmcgZmxhZ3M9MHgwLCByZXEuIGFib3J0DQo+IGNv
dW50PTANCj4gdWZzaGNkLXFjb20gMWQ4NDAwMC51ZnNoYzogaGJhLT51ZnNfdmVyc2lvbj0weDMw
MCwgSG9zdA0KPiBjYXBhYmlsaXRpZXM9MHgxNTg3MDMxZiwgY2Fwcz0weDEyNGYNCj4gdWZzaGNk
LXFjb20gMWQ4NDAwMC51ZnNoYzogcXVpcmtzPTB4MCwgZGV2LiBxdWlya3M9MHgzMTBjNA0KPiB1
ZnNoY2QtcWNvbSAxZDg0MDAwLnVmc2hjOiBVRlMgZGV2IGluZm86IFNBTVNVTkfCoCBLTFVERzRV
SERCLUIyRDHCoA0KPiByZXYgMDQwMA0KPiB1ZnNoY2QtcWNvbSAxZDg0MDAwLnVmc2hjOiBjbGs6
IGNvcmVfY2xrLCByYXRlOiAzMDAwMDAwMDANCj4gdWZzaGNkLXFjb20gMWQ4NDAwMC51ZnNoYzog
Y2xrOiBjb3JlX2Nsa191bmlwcm8sIHJhdGU6IDMwMDAwMDAwMA0KPiANCj4gSGVuY2UsIHJldmVy
dCB0aGUgY29tbWl0IHRvIGJyaW5nIGJhY2sgVUZTIG9uIGFsbCBRY29tIHBsYXRmb3Jtcy4NCj4g
DQo+IFJlcG9ydGVkLWJ5OiBTaGF3biBHdW8gPHNoZW5nY2hhby5ndW9Ab3NzLnF1YWxjb21tLmNv
bT4NCj4gQ2xvc2VzOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zY3NpL2FsOFlr
WHlkWEpRWnJsX1lAUUNPTS1hR1F1NElVcjNZDQo+IFNpZ25lZC1vZmYtYnk6IE1hbml2YW5uYW4g
U2FkaGFzaXZhbQ0KPiA8bWFuaXZhbm5hbi5zYWRoYXNpdmFtQG9zcy5xdWFsY29tbS5jb20+DQo+
IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+
DQoNCg==
