Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E89E144D38;
	Fri, 14 Jun 2024 06:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718346661; cv=fail; b=gxgHY+mE0TcbnlLQ48q3L79uAmALOqNg83IGQFYQJoCEY0s2r9v0d7Lyu+z6CNsAsCzMvc4aTE3/1GFOoXrpRqBQrEj75/02TvyufzZ5OODYMPHqoLwuZlS6ljhNjQwwS10RG7LXJDUX2uXME8LLUkY4t65EDTehpMk2coOtuXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718346661; c=relaxed/simple;
	bh=8E4ehx0zckegqlZBGorIhkOg6wJHHPyiHOYPXlEdCfQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QTFsm2MJ6E5EOHMnJsIXOw4RxfpZhDbL6LfLVau1YphFqrH3knI7cvYGoSMQYw68Ykte/ZgRb4Ydov+TtKNcRmiQccSeUpvLJpxyyal3lucxRTs13C28rS5yXscyL30SMXqexShc5s3acyi8lH/5DPH3MJe+IaLy/XRjSy0Huf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=J5LFTHMF; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=QrN12iMf; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="J5LFTHMF";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="QrN12iMf"
X-UUID: a64702ce2a1711efa22eafcdcd04c131-20240614
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8E4ehx0zckegqlZBGorIhkOg6wJHHPyiHOYPXlEdCfQ=;
	b=J5LFTHMFYh2I26EeLCFxGTd/CsxH8sc2fKBBqIkMJ1z5uIrXy+INiQW0giJ/+Bp8tTCQ3G1c8JC+Kfb9UuSXLuL4UkXhUglToMQ76jPjZ5P7Y4yWqpc0QsOP+/g1Ck7WnOcHeMzeIbIdqW6BfUhgAjGYmQ0z+cpLBLI58EK2Loc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:2dedb14a-51ee-452f-87fe-753212c22a51,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:83c49144-4544-4d06-b2b2-d7e12813c598,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: a64702ce2a1711efa22eafcdcd04c131-20240614
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 129785547; Fri, 14 Jun 2024 14:30:53 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 14 Jun 2024 14:30:51 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 14 Jun 2024 14:30:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBdUKLiJFtLuPTHcovlWCm8q40XdR/+/JEJ+6W/Z8CMpJR2wy/eT5xUgg2yhyv1GnHApWCjutsYvKLg/pU8zX2LeBTgOqeG7NiZwryiDNOQb3gSZAjv3KJ8RMs9B81nakxO1n+h+vf+Dy/k+EffNDxr7DS4RNkRwLghTJw384kjqI/nQS5+jWAL+bU/xHL0EYrHbNut3XygziTAZ2CS3BS9cOV/9ZBZhyGaIHuZvoAZMVBE0GoyHoN6sJqwlQrJW+FexwmDfJp652BKxKnRxv/EQidNXepyL87UMXCRx2/uX+gXhe9TY8txPbwbacln4Hy/YSwO1+shG7ZZFHtsDJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8E4ehx0zckegqlZBGorIhkOg6wJHHPyiHOYPXlEdCfQ=;
 b=LPDPpN7+kL7fHHrKUuXd+aFD3UPXsyNhZSbfvGD8FrNYl/edBoXnX/XoHXX7fptiO3Yy4pAfuDviHf4n5abyr5jiyJNmwIEFrgbhtx9GQV7C+3hHvzqEis+u2INuhBSbq8U2kG9arjPt7PQypfefRwS8x+N0VDL9V2ogQ6XBSntrwOTNuH/NHwGx3f8ARt+zDm9UK9kNTolCFEf/V6z8iYnpotRsQWH7lfgy8shkXs75Y+1TdNVp5ZJ8xcA4Dd9gBmL7KURs43DrA81qsDkhpRpeu+uYiaoA9HLDLPEbkfZSzE2YVU621BnkR6vui/b2oCp8eqtIR7j9TJMXKrbKGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8E4ehx0zckegqlZBGorIhkOg6wJHHPyiHOYPXlEdCfQ=;
 b=QrN12iMf57k5dsoh3vtCFYMWs2TkpeL4TPQoKhNfvAQzY8sGMumcAUTS0/DLVQ6z8rK2i7sLslk1TUyEOWRS7rBwWHNjfEIvujwhA1VA4ovLCe5tqu4d7wMMWZPCQNLq1+3b5XTDSG4eE8q4TYBh/3iO0U83wA1eDZWDYR9HMRQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8142.apcprd03.prod.outlook.com (2603:1096:820:102::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.24; Fri, 14 Jun
 2024 06:30:50 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 06:30:50 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jslebodn@redhat.com" <jslebodn@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ahalaney@redhat.com" <ahalaney@redhat.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: core: Free memory allocated for model before
 reinit
Thread-Topic: [PATCH] scsi: ufs: core: Free memory allocated for model before
 reinit
Thread-Index: AQHavb98L7TgfRpUHEmt0SnRKaCTwrHGHZ0AgACvroA=
Date: Fri, 14 Jun 2024 06:30:50 +0000
Message-ID: <5c3acfacb567cb9871f7ad3721b50d0c4970b676.camel@mediatek.com>
References: <20240613182728.2521951-1-jslebodn@redhat.com>
	 <20240613200202.2524194-1-jslebodn@redhat.com>
In-Reply-To: <20240613200202.2524194-1-jslebodn@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8142:EE_
x-ms-office365-filtering-correlation-id: 535e368b-5da7-4682-d7bc-08dc8c3b889d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230035|376009|7416009|1800799019|366011|38070700013;
x-microsoft-antispam-message-info: =?utf-8?B?OXJYZTVoek1nd1g0cTJ2eGdWVXFtZ3FNQ3ZXOUVVMnhtMkhNKzhOejA4RGN2?=
 =?utf-8?B?VXozbXcySXdCSGFpcThFNW93UUVCaDRNUG9PRlUyVHVldEJCNWVYNFVvcFVT?=
 =?utf-8?B?YXd1anFTUTZTZVRyYUFPMVBwN0pFb2liSk1tQ00rTXJzcEM5SkVOMTRmTVJF?=
 =?utf-8?B?UGZrbnAxdUZaV01ub2ZYYzJOT3BKZWtJajNCWGNEK09tYXdjY2dFd0VJWHVP?=
 =?utf-8?B?azNmd1pwWHpUZTJqbTI0ZXRLZi9EelYrVlhvaGFYL1cyanRQUkpFSzFVSlBK?=
 =?utf-8?B?c2dTR2FqZmJsWllZb2lvMkxQVHZLT2ltUmMxNFFkOXZ3c2V4T01MQXRBK0I0?=
 =?utf-8?B?OHFvS0RibzUyZDVXSlpnazFCeDgxYW9xWE5WTkc3NzdjcnE1eXFvRjdGV2kw?=
 =?utf-8?B?WXlDWDUwOGhvVDB6MVVwMnVBQWlTWW8yWVhBVE5QWUxjMmx1Z0FkbjBnOXVp?=
 =?utf-8?B?WmNiNnhQMzlha1plMENSak9SQ3orSkV4bEFuay84MGN1TUYrL091WW5nUm4x?=
 =?utf-8?B?aXk2NkE0S2RmVnpOSEVnQW1MTGlhZnhpeHY4WkZGNFZpN2FrdUJoVEhKWjF2?=
 =?utf-8?B?WTBBVGZRRGJmZ2pUaWpkQVczU0ZYYmhwYjBEM29XSG1aMTM1elQ3YUdCcFp1?=
 =?utf-8?B?cGJycGs5cXV4SU1EVllwYnVQb2FrdEdCcTZnUDdObWZRV2w4dXFEL3M0Yy9y?=
 =?utf-8?B?RE4zL25QbG9uY040M1dCS3QxZFlVYlQzNStiVXd0QURncmxuSXRFNEFiTTFU?=
 =?utf-8?B?emxuM1RhK2drY0dLUnNVK0p5TnYvZnJSc3Nld0l1TWZjK2huVEY5N2ZOcEM5?=
 =?utf-8?B?bU1rWG1MUmVQa0xEcTFjRHhRS0p2UG02bkZHNHFxU1o2cE5rTUw5a0dUTVdG?=
 =?utf-8?B?NENEMWU4YmpSVzFDNlJxTkxzRDFOYUw0ZjJDVEdtNXFTM25qVG9Ya2JoWkJx?=
 =?utf-8?B?UXExUndNYU1rd0FNQisyYWhrVlE5Sy9YeHk3Tk9TVVR3d3AwdFZUTDc0M3Mw?=
 =?utf-8?B?UVBJa3RoRGxqRUlMdmlNSkt0Y0h6bm1haGRnQkkwZGw3a1luSHlyaXFRRzRM?=
 =?utf-8?B?MjB2ei9NNklkdkpxOXlJd2dyY2FWeHNGMTZlWlZOcllRTDgwVlphakpuRzdn?=
 =?utf-8?B?MXI4aHZTclhjRnE0Nzltc2Jxa1JUaSs0UGZYTEZyNG9LaG9lM1A2T3ViOVNl?=
 =?utf-8?B?dFZOMjlOVU00dkFSbysrVGpmMFdRRjQ5TUZtaGN0WWFUN0ZrR1JTRFlhMFJY?=
 =?utf-8?B?b0xQWEFtdHBhVllIQ1lPVmZuTUg5Q1Rsc2t1S3l3bjdFcWY0emd1bVpheG5h?=
 =?utf-8?B?VmdJUzFNdHVUQnl2aU9GRmpzdFlrK3lSdDJBT1NRWjA0M1JRakszY3p2YmhV?=
 =?utf-8?B?OEhJMFpFZUxpMGZSaWNYMExsZUg5RUg2YkI0R2V1VFJxektIbGRiRFovcGsw?=
 =?utf-8?B?NDNQYVJYajFYS1haS3FHT3lrSTdYN21VTUxzSTNmZTV3NllZUUpiWWNUL1Rn?=
 =?utf-8?B?aUdGeHZLaHlxWGZWL2tDbXNLbmIwMzA4dWRWRTlSbkI3ZzFMSGV2aENhNksv?=
 =?utf-8?B?NWE1TnJGaWRUOFhsdXlCcmoxL2hNK050QnpkNEsrSHZXRktZY3FBM3NhS1Vl?=
 =?utf-8?B?cG5LbGlEUVE2RTdzdkxIY2pyK0dQcGRQOWVHclJTRzBiRlRWbkRMcVVsRGRx?=
 =?utf-8?B?TGFwd2tLcVBDY0NhTXcwM01KYy9YOGx3VVRSVWU2ZGpXemdaTUJlamtuL2hx?=
 =?utf-8?B?Tlk4b3h1UUdveGFaTTRFZVpOVFFYZVhhMVhpOXlNd3l5d0c1QlZ3SFRHdlM4?=
 =?utf-8?Q?DnxNFtUFkXSgJOGBZhDAgiXq5WaRigDl2Vj10=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(7416009)(1800799019)(366011)(38070700013);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUhZdk0zQnlvYS9sMWFsQmoyVTNQWUFmem8xd1h0c2lPUXhoSHl4SDJNRmw5?=
 =?utf-8?B?dnhmakgzUHV2N0tyU2RxKzArWVI5U0JhZTE4ZnBCVzRHOWtGRU1DVytiYk1x?=
 =?utf-8?B?dnNhaExDaUR4M3R0dWU5czFTcjlsdmNuc1JHZnJMNXhSaERsd0pXVFRpSW9M?=
 =?utf-8?B?MGdueWsrYUQ3OUpWVG12bWtDb2JBK3Y1cmllVm1XK29iNkFZWmN5UC9telVa?=
 =?utf-8?B?ZmZETWpQREVyNWdwQUtVVXBMVlE0RjFoZWs5NDFONHhrazNtcVVpdENWVzBN?=
 =?utf-8?B?N3ptazFkRU1zUWV4b0lxdHNmSlZWU3M5dGdBRFkwa1JSZFhxckE2Q05iY0tt?=
 =?utf-8?B?NGoxUCtJem5aNnhpRksrbjJyVGtJWkRWVXJBWnpjRUowaGNaMXR6NWlYbVFo?=
 =?utf-8?B?c3JNNERpbjJYbkxVbjdyS0FzeGlzV1J3K2ZvNnNqTWVSV1F3R3d2aUFjbnVL?=
 =?utf-8?B?cnM2bDRDTzM4VUJmQzlhKzkrT1REYkdNUUhvdTNTYXRVM2l4ZVRrM1NHMUVl?=
 =?utf-8?B?TTgrQ0Rud09WeGgrQWVEalg2Y0Vuc2EwREhQa0V6ZlNoN1NMdGhsYnhTVFh3?=
 =?utf-8?B?NytxMThlRFoyNXZhZlQ1TkVEY3AzUlUwZ2hrTlBQREdtODZRbHc5b2RSeit1?=
 =?utf-8?B?d2RXTzkxd0V5R1ZYZzZFZ21TSDB1Zmc1c0w5NlpDcDRuNTNCMFQvTDFEWmNS?=
 =?utf-8?B?QUhvb0N3bis3aHdaUFdvc0h1RHJ6M016dkFZeERCd3RTRnlhNk1id1JRK2dD?=
 =?utf-8?B?RHdPZDZnUi83UVdydldwd2pmL2JJWG5vM1lXWmdnaHo4NzF5STc5TkFyK3hI?=
 =?utf-8?B?NXozMVZ1YVNla2J0TEU5cmlBT3YybGFaTm80bkdTdXdFSmhLQUxoZGRwZVg1?=
 =?utf-8?B?SjdoSTZkcmpQMUMwRXVscDhlSGhqSFZrc0I3K3RCUXhveEJVblhXdlE4a0Nm?=
 =?utf-8?B?bTk3T0FJRmpPOFJ3dWttTDRRMTUvNFlwblN6UWNUalhxTGZ1TUozc1lGK3N5?=
 =?utf-8?B?Y1FHc0VPSFV6RmJGSUlRQ3lGUCtxWEZtYjlRMm4welJNTkk0RnpVMUFQYStJ?=
 =?utf-8?B?VVgyRW5ZK1JaRmY1cFo5bXBZVFR2VGpRSmFjNS9aRXQySGNZL1VlWHlsZjBr?=
 =?utf-8?B?ZUFiMFlMd3hXVzZZdEpNR3liVGduNVIreGRUR1k1L1BXZ0VGTHA2b01CNnpk?=
 =?utf-8?B?cUxkVERnSlFJTnhTRXFCcXVuWUlTaE55SXdaT212c1BXVnJGdXdmVXJlbDJR?=
 =?utf-8?B?SHlERU9TNHY4REJPNmo5NjR5aEpiL0VERlhIRUVWcUZQODBnK3IwcWYzU3VJ?=
 =?utf-8?B?VDkvYWZta2FFVE5ybDl6VUhsbWZ4QSt3OHRyaDlhcGxhc1Y4RDJxc0ZzdmlW?=
 =?utf-8?B?UWpwaGxEdFJrT3k1b2RFd1IxV2tYd0srdnFlKzE4bThGcFJvdFBSYjFVVitu?=
 =?utf-8?B?eUlTZXYxSm84ZFRLWXNXWEVwczFJVjVpSW9WWDM4TVZaMFNod3oxTGVmSkU3?=
 =?utf-8?B?bGdjNnhjNWwxYjl3ZklDL0J6cFUxVlF0MnpqQ2lzR0x3L0o4UXM5OFBRNElo?=
 =?utf-8?B?NXZzTWp0NTArVG5KV24yYStOR1dTNkNja2tyQmFGc1V0ZVc5eGxzQ0FRYUN6?=
 =?utf-8?B?SVdLbWdGYVVMdDJwNmRYS0gzeHhheG5kek9EUXJ5YnkyMVdUdlpiN0crYXZR?=
 =?utf-8?B?NGltQWE0MWNkMGpjbVpKZ1FjOGtrOU5JTXIxaFplVlpCcjdNOWlrZHU4aDQ4?=
 =?utf-8?B?bmNjdW1XS0cxQUJnL29ObmlLV2p0dkNOd3VENlBkcmpod0wvQ1NTemhZTUl2?=
 =?utf-8?B?REEybVdGMDZSNCtWRlZIZjloZzN0T3k3dDBsOHJZd3gvU085MG8zK0RZOG9U?=
 =?utf-8?B?S1BiUThTeXVKbVh5VDM0Zkdqa2VKOXRUNnVTQkpHbmg0MXhTdHI0Q2F5TjlT?=
 =?utf-8?B?cDBWNUUrUHo3a1pSVEhpL1dUS2pXbU96MmZ5VjF4Z3k4eFhQbDdITUgveTM4?=
 =?utf-8?B?L0Y4eXhNYXkrRlFISmVKRytLTW00TWhiZlp4aDIyOVpvb1plMXJFekFTSmVK?=
 =?utf-8?B?WElzaDBHWnpuVkRQd2lEUmpiK1lqNTV5WEw0TkRBcW9KS3U2dCtkVHZmNWpT?=
 =?utf-8?B?SGNVNHJ5eEkrTjRIVEFWb1ZLTFdUNTgzY25WSVEzc1ZXaEtDMjdZeVBxVmRU?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1F8F2C6301F544B8A892DF09F2F2B30@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535e368b-5da7-4682-d7bc-08dc8c3b889d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2024 06:30:50.2342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8r+7nFwnkB8YR1NSISfLGIC6JFQNpYqmC6nZhdKtdd0EjrLAJmjOzDLFBEJu4nx0e7o1RA7PTv38CIoYHWcycw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8142
X-MTK: N

T24gVGh1LCAyMDI0LTA2LTEzIGF0IDE2OjAyIC0wNDAwLCBKb2VsIFNsZWJvZG5pY2sgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgVW5kZXIgdGhlIGNvbmRpdGlvbnMgdGhhdCBhIGRldmljZSBpcyB0
byBiZSByZWluaXRpYWxpemVkIHdpdGhpbg0KPiB1ZnNoY2RfcHJvYmVfaGJhLCB0aGUgZGV2aWNl
IG11c3QgZmlyc3QgYmUgZnVsbHkgcmVzZXQuDQo+IA0KPiBSZXNldHRpbmcgdGhlIGRldmljZSBz
aG91bGQgaW5jbHVkZSBmcmVlaW5nIFU4IG1vZGVsIChtZW1iZXIgb2YNCj4gZGV2X2luZm8pICBi
dXQgZG9lcyBub3QsIGFuZCB0aGlzIGNhdXNlcyBhIG1lbW9yeSBsZWFrLg0KPiB1ZnNfcHV0X2Rl
dmljZV9kZXNjIGlzIHJlc3BvbnNpYmxlIGZvciBmcmVlaW5nIG1vZGVsLg0KPiANCj4gdW5yZWZl
cmVuY2VkIG9iamVjdCAweGZmZmYzZjYzMDA4YmVlNjAgKHNpemUgMzIpOg0KPiAgIGNvbW0gImt3
b3JrZXIvdTMzOjEiLCBwaWQgNjAsIGppZmZpZXMgNDI5NDg5MjY0Mg0KPiAgIGhleCBkdW1wIChm
aXJzdCAzMiBieXRlcyk6DQo+ICAgICA1NCA0OCA0NyA0YSA0NiA0NyA1NCAzMCA1NCAzMiAzNSA0
MiA0MSA1YSA1YSA0MSAgVEhHSkZHVDBUMjVCQVpaQQ0KPiAgICAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgIC4uLi4uLi4uLi4uLi4uLi4NCj4gICBiYWNr
dHJhY2UgKGNyYyBlZDdmZjFhOSk6DQo+ICAgICBbPGZmZmZiODY3MDVmMTI0M2M+XSBrbWVtbGVh
a19hbGxvYysweDM0LzB4NDANCj4gICAgIFs8ZmZmZmI4NjcwNTExY2VlND5dIF9fa21hbGxvY19u
b3Byb2YrMHgxZTQvMHgyZmMNCj4gICAgIFs8ZmZmZmI4NjcwNWMyNDdmYz5dIHVmc2hjZF9yZWFk
X3N0cmluZ19kZXNjKzB4OTQvMHgxOTANCj4gICAgIFs8ZmZmZmI4NjcwNWMyNjg1ND5dIHVmc2hj
ZF9kZXZpY2VfaW5pdCsweDQ4MC8weGRmOA0KPiAgICAgWzxmZmZmYjg2NzA1YzI3YjY4Pl0gdWZz
aGNkX3Byb2JlX2hiYSsweDNjLzB4NDA0DQo+ICAgICBbPGZmZmZiODY3MDVjMjkyNjQ+XSB1ZnNo
Y2RfYXN5bmNfc2NhbisweDQwLzB4MzcwDQo+ICAgICBbPGZmZmZiODY3MDRmNDNlOWM+XSBhc3lu
Y19ydW5fZW50cnlfZm4rMHgzNC8weGUwDQo+ICAgICBbPGZmZmZiODY3MDRmMzQ2Mzg+XSBwcm9j
ZXNzX29uZV93b3JrKzB4MTU0LzB4Mjk4DQo+ICAgICBbPGZmZmZiODY3MDRmMzRhNzQ+XSB3b3Jr
ZXJfdGhyZWFkKzB4MmY4LzB4NDA4DQo+ICAgICBbPGZmZmZiODY3MDRmM2NmYTQ+XSBrdGhyZWFk
KzB4MTE0LzB4MTE4DQo+ICAgICBbPGZmZmZiODY3MDRlOTU1YTA+XSByZXRfZnJvbV9mb3JrKzB4
MTAvMHgyMA0KPiANCj4gRml4ZXM6IDk2YTcxNDFkYTMzMiAoInNjc2k6IHVmczogY29yZTogQWRk
IHN1cHBvcnQgZm9yIHJlaW5pdGlhbGl6aW5nDQo+IHRoZSBVRlMgZGV2aWNlIikNCj4gQ2M6IDxz
dGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFuZHJldyBIYWxhbmV5
IDxhaGFsYW5leUByZWRoYXQuY29tPg0KPiBSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxi
dmFuYXNzY2hlQGFjbS5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEpvZWwgU2xlYm9kbmljayA8anNs
ZWJvZG5AcmVkaGF0LmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53
YW5nQG1lZGlhdGVrLmNvbT4NCg0K
