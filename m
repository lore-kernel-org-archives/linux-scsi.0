Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A36820DD66;
	Wed, 15 Jan 2025 11:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736939115; cv=fail; b=a04Gc7YGX2iijGU8yKL0+hEnpfna+AV9oqWbkeE5QRmRAmTZu/opWCjsAMyoH1LWi5q+NPpCOrI1m+5offOB8i1n9mqe4preIhrCFvfgX7t7HdgXdTBZa5a/DmnCHW+fvUgnLqB0HLxU9rnQQ33r9vZLDIWPrZwxgIV5YuHPNSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736939115; c=relaxed/simple;
	bh=T+zb7Zk1IkPgOW6DeZeDZ7lUuR9NK8IWI7g1S4O7qM8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rFuhKmKdObdZQpR17r+W8LWeXKvuIJfh5qNrcpGg6zX246KOQcsC5nPsMTFWTLCWo/y8n1h5eaYLT8jksIi+MohYgYapIGmBYXETm4xKbdwFd3qSP4mpGvXxx0m8xcRW+oRbmtd0l0u6BiAqLhKxTiWFLHRCMTx5Dk4wgMoUS3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DGV6Qdqu; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=udmeCg2R; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DGV6Qdqu";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="udmeCg2R"
X-UUID: 9358aa56d33011efbd192953cf12861f-20250115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=T+zb7Zk1IkPgOW6DeZeDZ7lUuR9NK8IWI7g1S4O7qM8=;
	b=DGV6QdqueEk8gD6NbS9paxVf9ijWn9T6vgvDNBc97JNh1KBGFC+BXpmWOE25w9ANqo6Ttqu8MilQS9JJXdRNTCMPjxubdrhdCB1nFOkSflc/Ftu6yzklm6UjwjaCyVp7goS+WQg0K6NVy6ckeEI3I7SvPcghlCekwlDMLoUMFYU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.46,REQID:8a021716-967d-456d-8dd7-d462bd5e295d,IP:0,U
	RL:0,TC:0,Content:9,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:9
X-CID-META: VersionHash:60aa074,CLOUDID:7cccee0e-078a-483b-8929-714244d25c49,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:4|50,
	EDM:-3,IP:nil,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 9358aa56d33011efbd192953cf12861f-20250115
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1242495739; Wed, 15 Jan 2025 19:05:05 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 15 Jan 2025 19:05:04 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Wed, 15 Jan 2025 19:05:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4+PBtu09qFevMkrgUwcCPHhyNhrE3/uCgYvjso2SQVWb55VyPUVXOID4L1g3ktGUSFdURIeukTtIW6/badVU3K+wyFIu9OYWLiIsO16SwIydN4jwW/op6ChGqKqvO2OmkuTeXEwWU8DA2UhKyGwkRoEeWtLsXdmFG7Kk6aH+VM8T+PLwew8vSt1+mrBtrAS4SJVMvG3f1C5si8MHf78l7+xhtNO01+2zhao4kiHiNSt/AY/6/R6PMlqy2hRIBN2zSy7I/86831U95YyAzin3e4eKYOxvtsdHBwGJAxB9t3aUoBhQIMmZCcBfBl4MZ0zxnBs2+/eGV3Qz9Tnul7IoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+zb7Zk1IkPgOW6DeZeDZ7lUuR9NK8IWI7g1S4O7qM8=;
 b=gS20LdW1u5oiaMadGtjGk+hfRaco6Gead/jTAtK3amGRUz/jj5ypiB6qaffMVehWt6kyrcImiRzm4vitJKdHRjnR5gQEBF+Fq0g0Yy+V1+uomdBGUbETXN7hf7ZZCkGM6dcNlLvEKpfzLGZIhmKTLLf/h8tfJoRX8Sx63Gae/PiQVlWMORDpXxVujljxNRqgA5PLgcGtck25S+um5WNIqtN3BPwamQdpvAaMblP7Qxv7Sk8aMkhHKAY99NhxZlzDdSuBsp3C3weGYiHl87T23ze8DUfpvvpmZRKpcavYlCAT+7qNOpwvKl++H7xqVesOqDgQWiZvobC5+1sTGUQ2mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+zb7Zk1IkPgOW6DeZeDZ7lUuR9NK8IWI7g1S4O7qM8=;
 b=udmeCg2RU5MOQjCqTA++SnIs4p2HdRcUmzVWKl3yAoUaE+OoinN1897o9xX3HgksAe1FTywyxJAgawRwkCg6Z/EFs+5zzkzCMrcQEAL5Opz6vQuNYfJ6BJGJH6LrFjISw8DdT9nF6GZ2h1NWvNXXPWX2GpGjBfGAtfi9+xWfQtI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7796.apcprd03.prod.outlook.com (2603:1096:101:16a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 11:05:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 11:05:00 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "daejun7.park@samsung.com"
	<daejun7.park@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux@roeck-us.net" <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit
 Definitions
Thread-Topic: [PATCH v2 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit
 Definitions
Thread-Index: AQHbZeme5zMRZ1NlFU+bVuHggB2rcLMXrs+A
Date: Wed, 15 Jan 2025 11:05:00 +0000
Message-ID: <2a90f92e4c72b7c11f3e44d885aaf69d16eed3f9.camel@mediatek.com>
References: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>
In-Reply-To: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7796:EE_
x-ms-office365-filtering-correlation-id: b9c41054-26c5-491b-fcc2-08dd35547488
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eHFmN1laUDhDVUN6ellPbUVnSWQ1WFhudnZMbEl0YkIwTHVRcjhtTmFrOHY3?=
 =?utf-8?B?Zy9KQkVhRUZFbnFYeTViMmMzVXRSYTFhTU9JSDB6M090OUQzQWg1c0J6QWFC?=
 =?utf-8?B?TEx1U3h0dFpXb00rbmI2R1NhODd1emltQmVQV3ExTEs2N2xXUDRJbGJEeHA0?=
 =?utf-8?B?TG53a05sZ0ZtOSt3RGVmVVVqYWRlcGsvY1NlWmpYNTdYc2NlWldhWjN6VExV?=
 =?utf-8?B?V1NxRGpmRVFQb1dmMjA1WmU5WVI2VWY3YzBYOSt2SGIwdVpQNmF4c00vV0hZ?=
 =?utf-8?B?V2hhaUhIeVRqdXBJbXZrOG5vMmxRM0JOQjZZMExLaWxQOE4xdWFWRDNNZVI1?=
 =?utf-8?B?ZXZ6M0xNSnAxNUsvZ2ZxeHNyYndrWTFGZUhXUUN0ZXRXbjRRNStUTUpCMXJK?=
 =?utf-8?B?TWVNYzFXMjZUZHM5bDhCZ2NQdlNwOG5meFliM1JFekhUbzUzcmdYSFpWU2J5?=
 =?utf-8?B?THRNWTZLendycVl6bWRURnBkVVdWWWZlT1RuN2hkVVVOYXJoSjExYUZmZmF5?=
 =?utf-8?B?ZmYvUTd4UjBtYW5FVXRGTEE4Z3d5cTlFeFZobXhzQmxsYmFuRXlHMEtuSUdu?=
 =?utf-8?B?d0l1NndnMkhBeUJGZnhtUWFTTzJ6ZGZKa3h6UTRYeFJSYUdFeTBOL0xRNEZv?=
 =?utf-8?B?OU1leXZ5RElQN3J2KzRUVkU0NkJEYnA4MnJlZGF1andrL250cjJockpkNjBv?=
 =?utf-8?B?QzBjaTYrK0lRT2hDaEhCUGgyaHZISm1RdmtZbGxtdXY0ekUyN014VmdwRnZu?=
 =?utf-8?B?ZXdhNHRXYVV4T0Rxd3VPYUtYSi9hN2l0cndES1l5M3lmR3J0QituYVRWSHI5?=
 =?utf-8?B?NnNwLzNoTGUySDFmVXBoK0FlVWNtWkVFcFdjVjJUV3FhbGdLc1JaTjEzWTkz?=
 =?utf-8?B?R0xzMUlyNmd5T244UVp4akNGOVM2Wm9jK2lnczN6SUYyWjRiZ2E3d2d0VEtX?=
 =?utf-8?B?YlVkbkNVSWZWck41ZzZCQ3M2TzhabUdQL3p3ZUZ2S2NUdlpNd3ZaMHBTOUpl?=
 =?utf-8?B?UHhOOE5CTTc5aVU5b0NNTjFlamhSUVQreXZPd0RuM1Y5dE1JNjVWVTZwS2hS?=
 =?utf-8?B?Y2VJdU9MckJieFBLcG1mR2tBa1ZKTzhnQXY0M3k3SDB0WlhYbFNQRWFnK1Va?=
 =?utf-8?B?WEhua1pvNWE4Y1p1K1MrU3ptOTFWRTRtRHZRTzhXTFhzRlFLUEdYVE1zK2U0?=
 =?utf-8?B?Yk1VanZadHVmYit3K0pZWnhwSEFCbitnWitEcUVwd1N1WXprUWRRTUJUa3l3?=
 =?utf-8?B?anl5c1J4RDc2R0R3empIcWMwWkpJM2N0cTg0dTd4YmVXL0ZDYXkvMGhPYkpB?=
 =?utf-8?B?S3VkVHRJT1lSZkNJaFh5blhQNHlHaExYcHNCYkZUMnAyRlZUc252VGlLTFlX?=
 =?utf-8?B?Zk9WNEpNOThJYzlEYXRTc1JYczYzTlFkRmVnYmlTbU14Z1JPK2xnMjRaZEhv?=
 =?utf-8?B?TytTWjB0N2phTHBRczRWaUpocWlBQjFJTmZiaU8yKy9CSmdDMzZMa3pPTk9G?=
 =?utf-8?B?NUhuRzFPWk1COXlyN2p2ZGNuM0l1dTZBTFJEOWFNSlRGYlJYTGNTWmk1UW1D?=
 =?utf-8?B?MkMvM2dQL1Fmd2FvMk96VzV5dHdPdkRCcjlxd0hEbDFWSi83ZEJwalJ1SjFR?=
 =?utf-8?B?allkWU1pb1NsZ09JaUw4dVFwdmtONzVUZUVxS0p4ZHRwMExycHNVMWlxSnBG?=
 =?utf-8?B?TGlFc2g5ZGVCYm1Ic05JMzRmQXlsOG9zUUxNOUxXTkE4RkNXQXVHZzYzKzAv?=
 =?utf-8?B?K0VWaHV4TW1LTTdVVmNmc0J6anNid3dFM3VhVVB2Sm5iZ1ByaUVScm5lZHM5?=
 =?utf-8?B?ZlBnc1pVWkZjRXB4cTNNSWg4QkN3ZGZnM1E1TUdhQ29HMFZoNE1acVVydXBh?=
 =?utf-8?B?bTJ5TTlBZlhJUUNuMXVQOE1ubjR6UklpZWNZcVRjMFVadzNtMmlucnhPSXdE?=
 =?utf-8?Q?n1hm6RZ/dqe87l25KJgVj6b89vobFsaJ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEh6bFpuQzFCMXpTQ3JDT1lxWGNlY2ZwQ3dUcXN5T280cktZVllWK0toL1ZZ?=
 =?utf-8?B?QjhBMnROTGxlZ2c1ZFdSd0grVVpmbVczVGJ5aVVib1o3cU11RzJaT2liZ2di?=
 =?utf-8?B?cTdmVUorQ29VaHphT0dLWS9rS0RpZCthaHViN1o5SFhKQktkYkRFWm01N3c5?=
 =?utf-8?B?QWJxN09nbjJpRnM3dHcwZ2hkcGxCSGhkMlFqS3ltZWU4WjBtMFBwdjUyWWk5?=
 =?utf-8?B?cnAraDlNMFptcGJKZEo3aStzcUhtUGJZdzYxYStEN2xkRXZUTWxQSXBFd1ZB?=
 =?utf-8?B?M21tdndLY0tiZ0tKaHMySVFGWmNHcUJVY0JKeFUrNERtVDljUXhGclNBM1ha?=
 =?utf-8?B?em8xVW5CUTRabzJwQjJDcWR2ckxtekU2UTdLREcvNzlTdkFhQmYrSzVTSEc4?=
 =?utf-8?B?WlY1cStGYkxIKytxbGo3NkhBODdHZWhZRVRhbDhCMUNwdlB1STBLRkxyK3JD?=
 =?utf-8?B?MFhseWVuWi9nY1cxVkU5VGl1a3hXdXBIbEphbk13NnRwdDFLTVFnczZzNCts?=
 =?utf-8?B?QjZSeURuY09tOXlpNXVhYk1TOFM1SXpYOWMxN2pMMkxJRW1vd0JmOFRUaHJs?=
 =?utf-8?B?Q2l4NlRtZXFnNmpHNDRkRUFHanVHbVBrTGozNzVrZGc5M2NUTkRDV0RheVQw?=
 =?utf-8?B?K0hERXI1NUVYV2hUZ21qYW53dnBFYmkyVHp2ZnViZkpvdUc1R3BHRzVjTytR?=
 =?utf-8?B?YUQzeHlQZGZNcEZIOFlPL3Bqa1Nrbi8wWnVpNVdlUkljc2xqVWhpblJocnFR?=
 =?utf-8?B?Y3VBclYvUnVDa1FweTlDWlZIUmRDcFEwOThPdUJiVXJBandyQ2pvYzZsVTJ1?=
 =?utf-8?B?dGVQcllCMEtGM3U4RUlJbXpKY0hXL25ZQ2l4WXZzT3Vnb2EwVnBldFlWK1pS?=
 =?utf-8?B?YXF0QnB1SjU0eHZyY293dWxrV2RwdDRkbkpuWE5CV3Z0WmpPYmgyTTF1Nkc5?=
 =?utf-8?B?MzFFTWYzQ3ErOURWOXAzMmw4NDNKdCtlV1NYdFpnUkdLVE0wNG5oU3VmSUg1?=
 =?utf-8?B?QVhYMXFtWDlnNHRKcWdaM1pNdllqZEszb2ttdC8vdmlyV3lwcVlNME5Fa3FH?=
 =?utf-8?B?TGlocUd4VmpVNTBBdmxlVS9uNnRCb1htMFlWbFY5OHk4OERGVzRRRU8waTI2?=
 =?utf-8?B?YjdOdGVwczFxNU82eEh1bWFzNDFrZndrUEN5anhaOU1YcjFhdk5KY0dSUng2?=
 =?utf-8?B?WWtRcWdkMkVCUTZScFdMZGNSYXRwRzhTaWUreWNhYXhlUGhOVTIzWVhtMURK?=
 =?utf-8?B?OWdXYXc5N253d2pud0VJU29kcXFtM0ljS2pBRGhWaktBbExmVm9wTTdDUVNC?=
 =?utf-8?B?ellROTZ1Z2dkNGxkZXhweUFVQzdmM01WWTZGdHNZTEMyekphN3hBOVRIdXVs?=
 =?utf-8?B?ZklQMEhtblg0OTYyZDd1N1JGN1lVVEEzN1gxV2hwaXFUamQrM0xhN3J4ZE43?=
 =?utf-8?B?RHRKend6elU0NmY1MXV2ZjJwTHFqUGtKTDBJNlIrQnd0S0puZXZQY0pydExF?=
 =?utf-8?B?SlRBQ1U3NVIySzFYSm1TUllPemp4bnlSUXNHUGVHVjhVcWhSQ3J5cmFOQkRv?=
 =?utf-8?B?blhpQ0c1bFNWT0pOMU5iTkJBQVlOcWE2MjY3WXh5QnZIS0F1Q3ZWZ3l0aWVN?=
 =?utf-8?B?WkJMWCt2QXZwRUVQaUxZcjF0NnJNTDMxZE1WcWNocXJhQlBGZzJZQkliWGJL?=
 =?utf-8?B?eWZFb1pHUUw5VFFGa2dhTmt4ZHhaSDY3d2FodXR4a0F4K2FQakNGL0NKVGFo?=
 =?utf-8?B?MS9EcGJqSFE2WFRlaVRrQWk1OW03bEhTRzRJdDU1d3o4c0lZd1pwQ3VWTmZW?=
 =?utf-8?B?QXJ5MGVhc2pDVU81c3ljMjFUenVHanVBYlVXblNVZE5mcS8ybzhEME1WL2RL?=
 =?utf-8?B?VDg0NnVxaFNNODA5Mi9EalFDUU9RMVMzcS9ySDJTOEJLenc4cDQyOFF0M0xk?=
 =?utf-8?B?R0UzMzdGTENkK1E2cXRlWUM0WWRhK2d2VWFHNk9od2p6N25mSXI5bGVaV3Jv?=
 =?utf-8?B?QUwvNkZNNUNkbDZSSzFHRzJZaDdkT3VFTEpteEc5UW1heUhBbktrbFBKcFJj?=
 =?utf-8?B?N1BiZkJNang4SFV1cmY2WjRCNitFbHFqM0cvVWdGUzRWZEpFZkF3VlRUckxw?=
 =?utf-8?B?ZEhLdjVNdHl3VWJaOVozaXQ2SkxaaUlyc3VZWGJhbWhweEdsY2JLTzNyTS9D?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <278CC7CD1956BB4C8BF427C094589A75@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c41054-26c5-491b-fcc2-08dd35547488
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 11:05:00.4802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OG1/X0eOIYUJHycXmJVSNttM9hoo+s+6tHSa+Tk4V/N9zauAmY9aiN2i9OjnnzIpevnxJFPlcsFPXHQlwHGNxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7796

T24gTW9uLCAyMDI1LTAxLTEzIGF0IDEwOjMyIC0wODAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0aGUg
Y29udGVudC4NCj4gDQo+IA0KPiBBY2NvcmRpbmcgdG8gdGhlIFVGUyBEZXZpY2UgU3BlY2lmaWNh
dGlvbiwgdGhlDQo+IGRFeHRlbmRlZFVGU0ZlYXR1cmVzU3VwcG9ydA0KPiBkZWZpbmVzIHRoZSBz
dXBwb3J0IGZvciBUT09fSElHSF9URU1QRVJBVFVSRSBhcyBiaXRbNF0gYW5kIHRoZQ0KPiBUT09f
TE9XX1RFTVBFUkFUVVJFIGFzIGJpdFs1XS4gQ29ycmVjdCB0aGUgY29kZSB0byBtYXRjaCB3aXRo
DQo+IHRoZSBVRlMgZGV2aWNlIHNwZWNpZmljYXRpb24gZGVmaW5pdGlvbi4NCj4gDQo+IEZpeGVz
OiBlODhlMmQzMjIgKCJzY3NpOiB1ZnM6IGNvcmU6IFByb2JlIGZvciB0ZW1wZXJhdHVyZQ0KPiBu
b3RpZmljYXRpb24gc3VwcG9ydCIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNp
Z25lZC1vZmYtYnk6IEJhbyBELiBOZ3V5ZW4gPHF1aWNfbmd1eWVuYkBxdWljaW5jLmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxBdnJpLkFsdG1hbkB3ZGMuY29tPg0KPiAtLS0NCj4g
wqBpbmNsdWRlL3Vmcy91ZnMuaCB8IDQgKystLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91ZnMv
dWZzLmggYi9pbmNsdWRlL3Vmcy91ZnMuaA0KPiBpbmRleCBlNTk0YWJlLi5mMGM2MTExIDEwMDY0
NA0KPiAtLS0gYS9pbmNsdWRlL3Vmcy91ZnMuaA0KPiArKysgYi9pbmNsdWRlL3Vmcy91ZnMuaA0K
PiBAQCAtMzg2LDggKzM4Niw4IEBAIGVudW0gew0KPiANCj4gwqAvKiBQb3NzaWJsZSB2YWx1ZXMg
Zm9yIGRFeHRlbmRlZFVGU0ZlYXR1cmVzU3VwcG9ydCAqLw0KPiDCoGVudW0gew0KPiAtwqDCoMKg
wqDCoMKgIFVGU19ERVZfTE9XX1RFTVBfTk9USUbCoMKgwqDCoMKgwqDCoMKgwqAgPSBCSVQoNCks
DQo+IC3CoMKgwqDCoMKgwqAgVUZTX0RFVl9ISUdIX1RFTVBfTk9USUbCoMKgwqDCoMKgwqDCoMKg
ID0gQklUKDUpLA0KPiArwqDCoMKgwqDCoMKgIFVGU19ERVZfSElHSF9URU1QX05PVElGwqDCoMKg
wqDCoMKgwqDCoCA9IEJJVCg0KSwNCj4gK8KgwqDCoMKgwqDCoCBVRlNfREVWX0xPV19URU1QX05P
VElGwqDCoMKgwqDCoMKgwqDCoMKgID0gQklUKDUpLA0KPiDCoMKgwqDCoMKgwqDCoCBVRlNfREVW
X0VYVF9URU1QX05PVElGwqDCoMKgwqDCoMKgwqDCoMKgID0gQklUKDYpLA0KPiDCoMKgwqDCoMKg
wqDCoCBVRlNfREVWX0hQQl9TVVBQT1JUwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gQklUKDcp
LA0KPiDCoMKgwqDCoMKgwqDCoCBVRlNfREVWX1dSSVRFX0JPT1NURVJfU1VQwqDCoMKgwqDCoMKg
ID0gQklUKDgpLA0KPiAtLQ0KPiAyLjcuNA0KPiANCg0KSGkgQmFvLA0KDQpUaGFua3MgZm9yIGZp
eCB0aGlzIGJ1Zy4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0KDQoNCg0K
