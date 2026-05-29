Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CDC3BAD93;
	Fri, 29 May 2026 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780041859; cv=fail; b=nAlP8U1AGvQr3cIxBT96TatRXNpwQj2RF9N/Z+yrGilN5Em6CjUdrOmfoCs7balXtwlfJEwI8jQqhZz27e+aW+m6eXqj4W+KbNZeSRV0Z9txKUfsTEkl/4T4kpHBbft8IT3QXMVDqxFyEYAA53/V0SvCtH2NfjxkzlqMYETlzqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780041859; c=relaxed/simple;
	bh=Um2CceckWHHiw5VGp4oGMZuBVy6tCLov9vKrbQFBLYc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SyomJD0p6nPDHoqhXMOQ95st2FSHcJ98CtqAC+llQWpp3dEXaaX+RjQHf711lxAY0dsHXRVE6gWIst8dhcUfY4Mh1aDLsrP8JeKeOy7shnljf2QX3cMNv8lqDRkyI8N/U/nM0/7Lb/mQGsWOYek+B4qYIcX90i+43CoHbqhU0ZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=k+nxeaU5; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=pX/dFcm+; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="k+nxeaU5";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="pX/dFcm+"
X-UUID: fa75702e5b3411f1b1788b6acf885367-20260529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Um2CceckWHHiw5VGp4oGMZuBVy6tCLov9vKrbQFBLYc=;
	b=k+nxeaU5YsnSIxwxEPyRIOV+M7q6Rb6779TfJ4z7+B47+aya6d+4U0Q9oU4Upoe0rXNYVjJvljlOX0FcDz0NNbSyGuR29TcxCoW/p/YGr5Z73zVWzB6NPX0AKNKSZ4/s2c+owOnWdTpSeaqFYNkGMNt4KpnotUD0L6EUF5t9npA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:073e70e3-6a1a-4cd8-b556-4d82fa067d1f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:cd96864e-8d42-4275-b2ca-0fdb78df1774,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|136|836|865|
	888|898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,Q
	S:nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fa75702e5b3411f1b1788b6acf885367-20260529
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 749567250; Fri, 29 May 2026 16:04:12 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 29 May 2026 16:04:11 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 29 May 2026 16:04:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/VvYw2sZzMTPytoNQmf1eRt7gc0j6UW4N2zXDlWv5OD8SSS5p6qcwXsONzQd6X3EciSGhZL0LUIgN+DCyZMpQVSNtVxOiqKefGOGN6Ddhf6a0x3ehVJrbEPxR7JsV1RIbLyPjk5+s+vrsmd/Fmpz8719ZUJp1KNDd9etdojPVbsPmcrtsqQ1PVm6svwQkxix7Q61M7HSkfVdjBp3AdoiezoBex5XA/XBWqVjV2iB51bg8MaQIiJSZsQNQEjG+AR1VTYTflmWxhUtL3amCaK2EDSAp2onqq3+dcRSlzg07zGM2OiCyWal+fL9zzVZ1Iqe9XfVzKkAc8WMjf3PRfI5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Um2CceckWHHiw5VGp4oGMZuBVy6tCLov9vKrbQFBLYc=;
 b=qwgCrxZ2uRiw3lJj89fiO07g33vcIaJOmYzk0L2Nzu6yHmkze3HC0sKqrrjwTxcLZPMNVEsBcrEoDs6/ONl8Klwwar4QAUWd6yXXpVd9UkVnT4F/7miMUWbUQsd8dg1nREFMqTjNKbrZJKN9+IyC2Yk/bkEkKdNqRtLPw0Ej/bBsRQsYggX9y1Z+sYX7U39Pp8Vv0sp4jUg6StpUCU6YZAB1xqU8FjPR+oaIIqh7JXBxvvMpQ+5t2LOsV2MPyBE2hfeopj7bqJr7FAhVCcmG3qi1fFqv+rFF2p5XhsbzDpV7tVWuznv3ifscYrxSjaxO34EyxqbbBQbOTxpkvgtvZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Um2CceckWHHiw5VGp4oGMZuBVy6tCLov9vKrbQFBLYc=;
 b=pX/dFcm+q3lNeGfRZF45/eFFrUaB+5imItaOjZOr/2S1KwdW1pb2Fotr84Rho/CmQ3vVoubqyOAZxcmahR7gqj4g6AzQgzEjxcRRUATtShv7rAxPdVR4BlLJeVUZKQ4b+jf+cNVeHViHx9I3f1mCKSYMSP42ChQrpC/mvhPzrwI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PS1PPF5424E1DD9.apcprd03.prod.outlook.com (2603:1096:308::2d7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.4; Fri, 29 May 2026
 08:04:08 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.004; Fri, 29 May 2026
 08:04:08 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Topic: [PATCH v5 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Thread-Index: AQHc7wiYvGaU9LCfpUOGYkJrMMRzDrYkpV8A
Date: Fri, 29 May 2026 08:04:08 +0000
Message-ID: <1e432db04abc12c4109754788ab36a09111cf3e9.camel@mediatek.com>
References: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
	 <20260529011421.462046-3-can.guo@oss.qualcomm.com>
In-Reply-To: <20260529011421.462046-3-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PS1PPF5424E1DD9:EE_
x-ms-office365-filtering-correlation-id: 28b6e0a7-b86b-456d-3e0e-08debd58dc1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|22082099003|38070700021|4143699003|11063799006|56012099006;
x-microsoft-antispam-message-info: aJ4rnNdnuq0ZD2eESRoqrORhZ9OsMpJcEQ9aUpUo6mGg9FGtgPUfP2M6Tcj5+dhzhlN/l/kNRQkfQ+zGw44VQpWqjMIh4zEh6hSE6RsV46vQoK8x7uUw6/grDasSTz+YD/VAL2qsfE7VJ2o7mcdgy4jwzBGYFT0ifoUYP+YFuQcFPkzJd3iSlAHLt8/y8MiIeFOfsIW9rfDuTSpjeBTFsuJ+P6o96xSMQQS7dfRF1yrRUwB3iVlP647eENMkqy70ry78DYhSm8vNyoDa/a1N3z4DCUobLZunkTdIo6zgTmD63HS008xICe2JmFDrRz3uHi0Iddh+NE8J2ot9XNqLUcGfHfBk4fAzgevq5CEV5yBAYdzN8JOjlB9/GhHhCflkJcD5OKqjtzDDwHCtwrVZivMdadOq2kbF+KYlaPbLS4wjPKPvawEB9WIqumHaGLxe52jcYwDZuLfa8tAWns+BI4mCYFYdn97GJ2guRYGaTXa7rutHxZ79Mjl229PPrphdXhUaypajcpRqUFWNCrjLA7mB/u01CY47c5WTl2zqTUTqoZrFpPTkHOlfidPyM36NB951bp4Q8gMuV/IU9Tn1O5y4PmWp378B+ls2i8UvT/OWweRynYWfuxN8jlOFWDIQGF4GRjESM0xw57/t6u5IwXjG6kMx67m2cULsGIWruqRd3OV6jGwOiIcw1ZF+z/SfV2YCxaSSoHApFFp9rxv3WVnkmy7XBF5mP+bMt9h/q6+9YtuOIYnYezCg1JFEGvqv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(38070700021)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emxmbmxRQ1BLa0x5TTJSazdzMHNFOEdBaHRMUUlMcytEYlI5L2dKQXBZcW9J?=
 =?utf-8?B?TDk2Y0RZZEliYTQ0d2ozdGk4REFMdkxpRSszT0dxNC9ZTVlybGR4QnNybWli?=
 =?utf-8?B?SWNmOWc3Nk50WDkzMmFIUVQ5dGJKLy9SaHpZcUpGNTFMSzJoazFheE9Na0c5?=
 =?utf-8?B?bTNTaGdOTG9rQWdSME85Nmd1MmxMTU5qclAwOFp5cmZxSlp5UC90RjY0Q0dB?=
 =?utf-8?B?Um9tS2x2ZEZ3UDlUK2lpcHlxR1c5SGR3clhlQkJER0w2OXovcDZRRUpPSFgx?=
 =?utf-8?B?TVg0ckJjUHVPNjR0aDFXUmxjMUQ2T3d3eDk0L3psU0w4Z25vTzFwdUtCNnNH?=
 =?utf-8?B?dEZTZFVNLzUwYmhQeThsM2ZOQ2RQTkpSYjlVeHV1ZTJXSFBWRTlEVVBFYkxY?=
 =?utf-8?B?RG9ZZTVNVXdRbVNVbzZpQzJhcTFwcFpYYlBLL29yaVBBTXFJUnQrOS9sSWF0?=
 =?utf-8?B?QkRQMlFpVHc5S3VENWVKa3RoQ0dMZmZlc0s4MENhOFppeUJrdVVOQWRkWVRv?=
 =?utf-8?B?S04zWTJHK3Y2T2c5c0FJNFgyRHR1L1ZqeXRHdG9Yayt4MXV4alhlR2hVODdN?=
 =?utf-8?B?c1E1OUN6Zzg3WklXdTZSeG04OVpTUkFLY0pJWkZ2OStubUJCZDgwdmdka0Zz?=
 =?utf-8?B?cUJ4SWVGeUluOTVhelY0MEFEekE0UmU3MGg5SUNyWDNjNFhlbExLV05zZy9X?=
 =?utf-8?B?TGdkUVR3THRUTHRmMGFLakRKZFM3czVhZWRXakFqbW5RWXNSSmhIRWhESWMy?=
 =?utf-8?B?VUFQR2RmUXd2TGlzYnFBSGc5NzU5a1lFb25vUGdwbUQzQ1BpdGsyOTJ4T2VH?=
 =?utf-8?B?WHVzS1JSWCtqUTIwcFV5M0g4V0pRWk00UzhGMytYUGZaNFpJZWdub3l1UkVm?=
 =?utf-8?B?eTlIbTFtVHkyTGVhU0crT1BSeTJlSWtQd3VObGdGUkIwZVp5YVgwUmg4YWRr?=
 =?utf-8?B?NC9WUGRuTmRxL1czL1FXSDA1RzdSTlhjMDZuaHBRekNnZXcwVVFuTFB6ak01?=
 =?utf-8?B?RVZkdWdzc01EVTZTajhoV2Vmb25KZUVhWU5iQ3gxK211eXFralVJeHNGQy9y?=
 =?utf-8?B?Wk52MkEyVFRBOVBKbm0vbDlSVG81cTdaNXV4VW4ranNJWXBvSWdkd1lLeiti?=
 =?utf-8?B?dm9TZDFSb25RbyttYVp3cnErSllPWjJXUmhhQUh0OFlmV2c4UW05NmZnT1NW?=
 =?utf-8?B?T0tzVXpvM2x1cHRLZFB1WmJZclJOTVpIQ3h3eGVoN2YwNG5XcVpoMit2eWxm?=
 =?utf-8?B?U3hpZzF5Z3doM3h4blNRQXVYSlFQMFFrbDBiZDNwU04yWTRaME5iYUNaNGRP?=
 =?utf-8?B?UzFhdkVKNXFFY3lDV3lXQURidEQrUE1aVjljNGtUYk9ucTFFSk1GT2NOWWtt?=
 =?utf-8?B?M3E1N0t2cksrOEZTeU0vY0hyNmJ5cnRIVXlnRnBlbUd3Z0RmMHJJUktuZGp4?=
 =?utf-8?B?OEF1OGtsMHBnem9LZkVWVEsrajhFckoxUnBrQ0p0ZWpMZmpQRUpHS3AvazM0?=
 =?utf-8?B?RlE0V1R3ZHZjR0h4bi9VcEl3UjFodXZ6WVpYLzlIZXc2anl5U2NpUU5TQzJq?=
 =?utf-8?B?SkhYRDF0RjZ1SDU2UzZmSExnSUQvMDNBV0wvTGQ3cWdvc2NheXNuQ1lWUG5W?=
 =?utf-8?B?amdOVzlYNi9QZkhsYkV4NjFFT2RLdHBzN2Vldk85TTZRM3o0WnNBZ3BiMkhZ?=
 =?utf-8?B?K0VldjF1anNLc2FrU01CTUUxVUVWL2NoMW5vdlZzanNoM3EzTHhxMmRaK1RJ?=
 =?utf-8?B?TUp0V2ZETEp6ZEtlSlFNVU42WGhWVmhCWk56aTFmNEY1eC83UTZqSjhDL21z?=
 =?utf-8?B?bFlQMDNGN051ZjdLSUFYc0d2bTlqTENEdVhUTW9mTXJMcWJBbThDaGRjUGRt?=
 =?utf-8?B?a1JwQ2x2VklHRndTQWpsK3B3SkdMSDZSRzhUQklFdFowWE9QdjlzamdEVnd5?=
 =?utf-8?B?eVNNUXIzU3dQK0FGdEhVM2N2Y256b2QvcThieWtOK21FRVhhV0RvUEhvOEgv?=
 =?utf-8?B?MmJFVm94c3lZNWJIQnprQjZHM3JwYWVyV203K0RvSkUxV1pETWRlalFHZHdp?=
 =?utf-8?B?YzFKL1d4QTZGVFlyQklNc1JYdytOclFxdHFsejlxMUg3cVNNZG1pVWdhTDhE?=
 =?utf-8?B?LzBMTG9tTHFQTUxENmErUFdSSnBMRGVtTXpBeWtIMSthT25lWDhqVVphaTZN?=
 =?utf-8?B?VVJ5U3FTcjR1NzlpS3QvcFQrZkltQ1R0ejMvckcyU09YZ2ZFV0wwNlBUS1F2?=
 =?utf-8?B?UkhIakswaXlRMjlhbGMxU3hndjZldkFRbzczU0hSaVB5RU9sUnZnQTZnYnl2?=
 =?utf-8?B?SXd1RGY1MVZTN09HZ0QyNnNIazlmTHZOWXBYc3NiMjFPZTAwM2d3WHQrTVNo?=
 =?utf-8?Q?tC9Sl9C1Emu1eI90=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57AB365A025A484AB5BEAB36EFFE745A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: swhL4KwDRU/kEAxUxjpHBaEVaLxENPpsZVmTbEntye0VSFg44WbseY2SEd4hlF2SO8B2/ZUcFd1ioPJRTuzAb5toumqqk5cDkuWqShinVoKoyiOzEB86ZdTozowTntwXRnw5p/AWJJ3KHUOZZcuq/sEGUsAW5lFLVl7pUmkWwGIw9Guzg49o3bEaPS7BO6XZ36sf5YgB4//mksjyPLA3PZWaExRefZIPiViGT+Nt8qMxwqtaWRmdmZu9WiAQfyt6S3d2wlFBdUqFjovIx1QYeld/gBD9QjZ7UhKJK+0ARPxFPLEbcc/c96WZZqPUBHTDRqxS7PSMlVckVELhqhGsOA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b6e0a7-b86b-456d-3e0e-08debd58dc1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2026 08:04:08.0580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: owLSLEpLbjGuOf8K7XJ2VZYtIXKAM5e2J5Pwfsd1779aV9xmc2dCq2yPhn4S9h3Y+c4IbOpGlEcPCiqtG4cKPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF5424E1DD9
X-MTK: N

T24gVGh1LCAyMDI2LTA1LTI4IGF0IDE4OjE0IC0wNzAwLCBDYW4gR3VvIHdyb3RlOgo+ICvCoMKg
wqDCoMKgwqAgZm9yIChpID0gMDsgaSA8IGNvdW50OyBpKyspIHsKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBpZiAocHJlc2hvb3RbaV0gPj0gVFhfSFNfTlVNX1BSRVNIT09UKSB7Cj4g
Cj4gCj4gK8KgwqDCoMKgwqDCoCBmb3IgKGkgPSAwOyBpIDwgY291bnQ7IGkrKykgewo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChkZWVtcGhhc2lzW2ldID49IFRYX0hTX05VTV9E
RUVNUEhBU0lTKSB7Cj4gCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGZvciAoaSA9IDA7IGkgPCBjb3VudDsgaSsrKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocHJlY29kZV9l
bltpXSA+IDEpIHsKPiAKCkhpIENhbiwKCkkgc3VnZ2VzdCB1c2luZwpmb3IgKGkgPSAwOyBpIDwg
bnVtX2VsZW1zOyBpKyspIHsgLi4uIH0KaW5zdGVhZCBvZgpmb3IgKGkgPSAwOyBpIDwgY291bnQ7
IGkrKykgeyAuLi4gfQphcyBpdCBpcyBtb3JlIGNsZWFyLgoKPiAKPiArc3RhdGljIHZvaWQgdWZz
aGNkX3BhcnNlX3N0YXRpY190eF9lcV9zZXR0aW5ncyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQo+ICt7
Cj4gK8KgwqDCoMKgwqDCoCBjb25zdCB1MzIgbHBkID0gaGJhLT5sYW5lc19wZXJfZGlyZWN0aW9u
Owo+ICvCoMKgwqDCoMKgwqAgY29uc3QgdTMyIG51bV9lbGVtcyA9IGxwZCAqIDI7Cj4gK8KgwqDC
oMKgwqDCoCBpbnQgZ2VhcjsKPiArCj4gK8KgwqDCoMKgwqDCoCBpZiAoIWxwZCkgewo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsKPiArwqDCoMKgwqDCoMKgIH0gZWxzZSBp
ZiAobHBkID4gVUZTX01BWF9MQU5FUykgewoKVW5uZWNlc3NhcnkgZWxzZSBpZiBhZnRlciByZXR1
cm4uCgpUaGUgb3RoZXJzIGxvb2sgZ29vZCB0byBtZS4KClRoYW5rcy4KUGV0ZXIK
