Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601AF18E29;
	Tue, 13 Aug 2024 03:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723520161; cv=fail; b=szsxJko8ChswGFGu4wotTxQk09v54/JEp7+Yq0sl86589tYwBaN/LAxWIItF11T+1ODst5ajAFXJFFaDZ6LSF67sIinONJTpR6CdfLOu2fTakZXqz+yPtvCnNOQ95sK+pQxZ0OypUXQCirfRyB5YafCzizev94o24Hh7VKBS7Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723520161; c=relaxed/simple;
	bh=rsRJO3Jp3yqGaSp386+iyIhLLDiKSUOUCGJDwDi3RI8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BgwjOV7HCM2LNyT/nPzgRRbAOTqs8+HgOSl6nXGjjaSuclJ7W8NctvUVjWpkFA46vo76ifVDSww9WEzQFNFfaTXC8QnG6E0WGroso+F8v8CIb2NuLfw0j/HBMdOwb4W+Ic9/rCUK2uw8eKh6aXwYu8aH7ZzX9da3Y+wHYl8wZvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OcR1A9TJ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=K07YZW3h; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OcR1A9TJ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="K07YZW3h"
X-UUID: 238e8afe592511ef87684b57767b52b1-20240813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=rsRJO3Jp3yqGaSp386+iyIhLLDiKSUOUCGJDwDi3RI8=;
	b=OcR1A9TJkPUHLZGSgWg3FE6cdAjl2MALFiEG6Mghq87hsWgQNSLFF2NKr+c5fGRXQDkQDYaZGoh2/5BwUq0hrg+LbGRRsG9e9LIlvgQeVi1ToMAva0VeEmZLQCFUmD2gcu7mje7QmfEkt7S3CheurUXIl44TH8onl8APZAhd2wc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:60e391b1-c378-49bb-be17-8e5f85a50faa,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:73ed0d3f-6019-4002-9080-12f7f4711092,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 238e8afe592511ef87684b57767b52b1-20240813
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 189048645; Tue, 13 Aug 2024 11:35:51 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 13 Aug 2024 11:35:49 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 13 Aug 2024 11:35:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uyZMHBDQi3Jl+3TMqapsGKO4j4RfF+69iR9pWJWMDYBEaSut0A/wqKc38WJor1RyS1/xJepHRqNeGXgNyzSwStx9MXalIqcVK98evPywtYrsfc2vrRq/KCv2m0ge1dgyonMsmvBNFYvkTN171vEdoIJ3JxZec7k+cXXwWNCTsZfxXPfubWqQRxuQAhRxvlH6mqdNEMaUHdzZOhUh0mivXmc7zfSu3lu0sDzeqVu4d8RfoMiMKxYwqBNjwAUiMnsh+IMZaq1GInPRPk7Alu6cjrBrptS7car4849WwUTATDHMbVzf8apLjiAOh74S8rHrNt+1qxv+iXzFX2kbHOCuFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsRJO3Jp3yqGaSp386+iyIhLLDiKSUOUCGJDwDi3RI8=;
 b=P8pZZmKdLCDpDRUI+ICyn8hPSuUUeBlub1uSeCR9bKVElnUe8dT/iX0ChIh743LfVDR++nuUubs7+PJiIfZ6tlpJ+4E2ToaSpgeMwUPODnC8LzdU8NUZKqflnvIN6tnCEPYBSA1cVGsTZOUhvZ70jlorkmr5MIlqgZJBtXsf/3ZirVRL15hnlEvEB9pkvCbaj4lYPvGjXDHhRoTi9tgVO950OvlEk6BydG75Nsu+F/Prztn9ZILMUggZwA86DbLdqbvwoVPpjYAeRqkpzk7EsdvACrJfaZyp8Cj8xmVHvIRQyHf9hJ9yR4pK+VwWYrmO2sKN4pHkbkzX3hswX8JMXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsRJO3Jp3yqGaSp386+iyIhLLDiKSUOUCGJDwDi3RI8=;
 b=K07YZW3h+duvXCz+Z543tdVOCZXXMS0Dq2MLzL1RQ6mGmksALt/fP06tKX1rzhKxYGuW0HFQnENKln9sqce2qvT3sJ5QSkhN7H8QC1/YCwuarIxvbQvCMWOFKLeWUEmoVMQiEWJ2XorURs0/RaF/twSkqMsAAMHiqKOckXLzm8c=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by JH0PR03MB7612.apcprd03.prod.outlook.com (2603:1096:990:17::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 03:35:47 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7%6]) with mapi id 15.20.7849.021; Tue, 13 Aug 2024
 03:35:47 +0000
From: =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "srv_heupstream@mediatek.com"
	<srv_heupstream@mediatek.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH] scsi: fix the return value of scsi_logical_block_count
Thread-Topic: [PATCH] scsi: fix the return value of scsi_logical_block_count
Thread-Index: AQHa6GURk0Hq7er+AECqFwIZYzPjobIkdvmjgAAcAAA=
Date: Tue, 13 Aug 2024 03:35:47 +0000
Message-ID: <f1a25a35d10540461522219681bcc1e897f643b2.camel@mediatek.com>
References: <20240807005907.12380-1-chaotian.jing@mediatek.com>
	 <yq1ttfpw5zs.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1ttfpw5zs.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|JH0PR03MB7612:EE_
x-ms-office365-filtering-correlation-id: 89fe5399-7183-469a-d4d1-08dcbb490537
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0RHRzdFVWhTdFVySC81TjJ1MnF3dlNYcUZNemRTSGNWb1pQUzk0ZWg0S0dB?=
 =?utf-8?B?N0p5Mmp2NkxxWFF4MWtTWEl2UkhCaHliWERhL2N6MmN5YitkeU9wY3FlbHVV?=
 =?utf-8?B?UEJxSmJZdVk2cXhUbXhQV2htR2tyWThxY3ROTktTREdZRFc5bjcram5NbUl5?=
 =?utf-8?B?aXlHUnFneVVqcjFSbVhLVWQzYWRUVGovTVRPbDFGOWNXNjV6RzhPY1ZqbGNI?=
 =?utf-8?B?dEdQQ21Lamh3Z2NKSXUxeXJzcDRBWmlBWStuSllpemdGZGpCOUwvZG1EQzNO?=
 =?utf-8?B?OGVoS3lTSWt1UDYzT1FHNzNKVUtyV0FEcUJXd0JEb1NKdU93OWYvMHJ2NEVT?=
 =?utf-8?B?TEw5bXNqTjhXaUU0ZlQ0bzVuT3RmMlNqb3d4dUJZbGt3YTZLbXVYWHdaWll6?=
 =?utf-8?B?dDY3WGFmcGpWZ0k5cHZQbTlHWTRtM1FqeGNsbVpuSlVaTW5COGo5ckJjSWVG?=
 =?utf-8?B?TWxVcUVEOFBNT2FSRVZIYzBBTk5VOXByalJ0LzNPWGR1QVEvd1hFNTdyeVVL?=
 =?utf-8?B?NjVaVEkwT0tyNzB3d21HeEl2ODdKeGV3Y2swMEpjVkxQZ0NCZU1mSEFVd25U?=
 =?utf-8?B?K1FVRWFiejNwdDNFd2FkMXdLSGVycEttcEhqanFIMXZEbU11elFVV0JWYldK?=
 =?utf-8?B?MUl1eDNGbjQrRjRmRkQ4cFRES3RyenVhaXBBY05OdmZkamFkM2FJWWl4STl5?=
 =?utf-8?B?Si82QW9IS3lpSUNFL2sxT0Yrd3RqVkkwUUdLWkJSMS9QUmYvVUQ2RzlXNk9t?=
 =?utf-8?B?YWxaYzhiU3hQOUh3MS9waWwwR01SSVV3bEZRMjN2eWIxV1dZL3NmWjZCNUJw?=
 =?utf-8?B?dW5vZnh1MW4wRk55bDZzZ2dEd09CY3A5ZDJSWWJ1V0FqeFJIUndSa1dobVV0?=
 =?utf-8?B?dWtjaHQxSjdIdVVPQW9KME5yWjZ5ckFNU2lFMEFIQzFvLy9MYm0veUx6emhu?=
 =?utf-8?B?aUNrczg1bDd5VVREU2dQOE1oekJQdFdhMDRFM1huWVZ0YlJRMmVKQlhOeVYy?=
 =?utf-8?B?ekFJRkJTaVNzSUM4dnk5eFl6L3I5NlZETFpZdkFKQjdoM2lVVmMvenplRXNH?=
 =?utf-8?B?MXMyZG4yL0dINUxqTlRhZ1BXWVJrZWFzRnlpNW5TVEVaLzVHMGlEWnlzU3No?=
 =?utf-8?B?NWllamtzVnRDR2s0akRTRG1iejV0SUlHWVloUXUwRTFCYjlnUWdFRjJQNm5h?=
 =?utf-8?B?RGJFTDcxbXJ3dkxaU0tndzBTcGI4VDdIcFpaemtNSHdxZHhPeVJSZ2ppLzUv?=
 =?utf-8?B?ME93NGtnQkxZWFQ5ajBEbE5WVlF0N0U3TkpJTXFmM0xJYXBoQVQyN0tYcE1m?=
 =?utf-8?B?TzJBMDB1aUdTMGhVZTMwS1dEQXNvOEcwZTVXcHZTbHFKQ1dpemJXYTZoQ2xP?=
 =?utf-8?B?WGJ0YjdBSWlYcTBpdGpBbnMyWHV2b2lta0Fra2dXQ3R1a1U3ZnVySkJlVDVB?=
 =?utf-8?B?OU9hMDQva2dVL1d6NVV0bFV3VFRMN1BITHBxclJWdW1DSTVHOTJnU0U3Qmti?=
 =?utf-8?B?cDkwQUVLaUx6aFFrb3NaNExReVViMXRXMDhNVm9lY0NHWEJiRjZtZmpmUzQ3?=
 =?utf-8?B?TjZkZzVpQ1VzaUpJcTYyM0gxZ3JLMGtWL0Jyd1FZR2dzQ3lTVVB3ejR0clps?=
 =?utf-8?B?YnBZMU9VSjNuMGd5dFpnUk9DSnNTSlVKaWYzMVcydWM3TFJheWFTcWpGS2tx?=
 =?utf-8?B?Y0RBNEIxWEMxeWpFMnJkUzdva2RJaFNwUTdEME9JZjdoa0phR1ZpaytzNE9j?=
 =?utf-8?B?Q1Fhck9DNUhtQ2NDS2M1VnFDNklUanV2aVFYVWxiTEFjWmFxNi93QnhldEV5?=
 =?utf-8?Q?cjdBlcdtdPUMkH3kToRuiOPJUXu5yw3BqsIRA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVlLYzB0bFpORVd0MXNKNWdLdVNwWEF6cFlyTnpjeVorUU1SZm9tSjRURlFp?=
 =?utf-8?B?eDV6UDJucTlUYVVWOWFrWnl6WENjVTMwdDBNdW5HUWFzb3N4dVluS0szcm5v?=
 =?utf-8?B?NXM4bVFSV0ZCTStOQjJoNEpwZ0dJRTd0NFNGZzZROS8vOHduZHBOY21Ya3pL?=
 =?utf-8?B?UThPc2FMZkNpNnEwbE1IaFg0MjdUVVJjaGpkNnJkazFWa25lSXNvMms0ZnVO?=
 =?utf-8?B?dDZ1eGZhSXBXWnhhSWVMV1N3MGtJUVJRdjVGai9ySENGWGZNSzIvb2Q4L1l5?=
 =?utf-8?B?N21IK3FEc3pybTNTK2dVaU1jMFhBMTJwaFROM1AwY0JFcHpsaTVrR0d1bkJm?=
 =?utf-8?B?Wno3eXFyV0x6b2x5S3VNQk4yaWs2Rm11MXVDb3VJbkpzTnRBOHlXUzg1c3M2?=
 =?utf-8?B?TTM5RUhON0E2bE15NlMzTWZDTytPWC9PdVdVNjQ0NmdZZ0pMclJwYk5DU3dt?=
 =?utf-8?B?ZW5KQm5McWg3amtCQ1M1Z0ZJdEFPQ3I0cWVVUjJELzhUc1MvNUIvSHRUREMv?=
 =?utf-8?B?Vmp0MEtWWGt6THZ3Sncvdnc1T1MxaGx0N2FGWFRlOTJyc3l6ZnBUSnRTcVcy?=
 =?utf-8?B?NmtpRGxsUU1OSDNheVpPVWI3VzVJbDdqbnhMVGNadGNpdzNZWVZDZGV6amtT?=
 =?utf-8?B?Y0ZPK0YvM0VLNFJFYk1xaUh3M3Q3bDJmbnZmOHdwRXVKVG9pWWIweFBObEV4?=
 =?utf-8?B?SHREVHFNQncrNGQ3d25DV0FZbjU4OVRJNlRkMXd0UGZHMzVvaE93Tk03bmtE?=
 =?utf-8?B?RmpSaGRzZ1pKZDFjbmdpZ1diZjQ4ZGJrY2ErWEJGeWdGNkxFMlIxQVFueFBL?=
 =?utf-8?B?YVRPWUlZNFVVNGFxRmhQQ0pSRWhOS21CaWdKVXdEaENyRDZwM2JYYVpOOHd4?=
 =?utf-8?B?OUZyYXNOZmZLbVVwVkdsM0dlWGVFT1o3UmVDeURHcEh6NzNDTHdCR3VLeUNm?=
 =?utf-8?B?dnFKa29rREdHTnVORWg3dWFBT0ZJcTQ0eGg2b2xOMW44N1hPbElJZUN3YXNP?=
 =?utf-8?B?SUpnU013NEowcENJNVdxYnYrSzFCeVIrR1JRZHZEb0Z1Y0xwQXlSaVM0VmtT?=
 =?utf-8?B?ejFSS2RleUNoRTZDcDNaa20vdkY0RHhTRHplaUJ2T1hFaFM5TE1ONUZxUGxr?=
 =?utf-8?B?YjJQdmtrRHFvQ3AzcFhmWk10S0ttTXJJamFhWjVVbU9tYXcwRHV3bzBoMUc3?=
 =?utf-8?B?SDZnMXVjdjRmUDJjOTRuM3M3UnhjNTJkRWlkQ01BLzhWTUhQNzZtRmtaN3Rs?=
 =?utf-8?B?VTE3SFVHaW9BcG5mVEJmQnZCRlNsaHovMXY3WkZLdXBiMVFpYUxPUyt3c01C?=
 =?utf-8?B?Ui9FYWcveFdZQ0VhcDN0TWx0dnp5U1dBRkxMTFBGbng5akpBL2ZqaXBBeWVi?=
 =?utf-8?B?bFcrM2s1Q1dYTlgvSGYwOUxaTnU1dzU2bldDemFEOUp0QWJ4cTZ2cFhGeER3?=
 =?utf-8?B?a3BPWk1uNFJnOW9ieTAzS2loNjNxYytONE56bXU2eEU4MjR2QkZxODNFK3Fk?=
 =?utf-8?B?NHZjL2FkMGowMU5uVUdNZWIwcVFXYm8zSjdhOXVkbjdnVE92bnBSeXZSS2NL?=
 =?utf-8?B?WDhFOHhyMDhWZk1iVmhzelRTai96MzNxSTlFRDY0V1pyNGVENEVwelc0Wkhl?=
 =?utf-8?B?dlhkTnZxaTVHelVCOEdLQm9sQnhHeXhDTFhENmorSC81ZnltbUlheTc4UGNR?=
 =?utf-8?B?M0xqQng1SG04c2ZBRUdxMTFLSm0wdHNNalBVUXpuNUFvd1FWMTR5NkdyU0tC?=
 =?utf-8?B?TEk0TDBmM1lWWVJqR3RMdmJpbEJ6aytia0MxdlVlcUNTUXgweWpMc21vV2hk?=
 =?utf-8?B?ODJEK0FOY0lGdmZuRU9oQjRwTEtKdEtJQVhpWmFtVEV3MkpneWN1cHptMHlC?=
 =?utf-8?B?cEFucXROM1lMdkhrc2xZVkFZT0c2QVREdzFsWDd5TWpkaFp2eTFiM1hWK2V4?=
 =?utf-8?B?YUZkWkNtbFQ3ZGloRk5OT093Wm45UWQ1ZGhKMTJsL2RnNHViTmpZY3VtVGEz?=
 =?utf-8?B?NkZZVnk1ck1nV2hZNW9Ka20yMS90NEVYcDdZZkN0RkVpVjRBeVNLV0NzNmp6?=
 =?utf-8?B?ZjUxY2hhZk5SV1BHRFFNL3p4eXp4K2VCMnA2V1BUMktxWWFQQkJuc0VGNlAz?=
 =?utf-8?B?L0UxWnNhVitoSXZYQis4MVJLU0t3ZThxMkJQYnJhOUl5aldtWEIyUjNJNk93?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3101087D0F7464C907E11CE922182E0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89fe5399-7183-469a-d4d1-08dcbb490537
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 03:35:47.3720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7sHwvxPQqsHK2mmfZNywlIFxGrdMWcaPdEQ7bLQ3RZNT7x2dxkyO+Ltybg/hDsJwFow215oda92KwJ5HWaxI+n8nrOHicpoEjZgLd0+corc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7612
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--20.526700-8.000000
X-TMASE-MatchedRID: u8usGLXufdjUL3YCMmnG4t7SWiiWSV/1jLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2mlaAItiONP3t/okBLaEo+H5h6y4KCSJc698
	9/H9ZXKCfEC+GFN7etazZj+Hc1DvYeTXuXzhMrQwSEYfcJF0pRRLXa2P1m93zNEJplIoT86zvop
	G4c3Xow4VzcyYs8SJv4gYlnr6q/ytC/bXMk2XQLIMbH85DUZXyYxU/PH+vZxv6C0ePs7A07Y6HM
	5rqDwqtlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--20.526700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	AADA1A28A2980E023709E0073BA49DAC669D589CB4884896C784FF65D95A53312000:8

T24gTW9uLCAyMDI0LTA4LTEyIGF0IDIxOjUyIC0wNDAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mg
b3Igb3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVy
IG9yIHRoZSBjb250ZW50Lg0KPiAgDQo+IENoYW90aWFuLA0KPiANCj4gPiBAQCAtMjM2LDcgKzIz
Niw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50DQo+IHNjc2lfbG9naWNhbF9ibG9ja19j
b3VudChzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKQ0KPiA+ICB7DQo+ID4gIAl1bnNpZ25lZCBpbnQg
c2hpZnQgPSBpbG9nMihzY21kLT5kZXZpY2UtPnNlY3Rvcl9zaXplKSAtDQo+IFNFQ1RPUl9TSElG
VDsNCj4gPiAgDQo+ID4gLQlyZXR1cm4gYmxrX3JxX2J5dGVzKHNjc2lfY21kX3RvX3JxKHNjbWQp
KSA+PiBzaGlmdDsNCj4gPiArCXJldHVybiBibGtfcnFfc2VjdG9ycyhzY3NpX2NtZF90b19ycShz
Y21kKSkgPj4gc2hpZnQ7DQo+ID4gIH0NCj4gDQo+IFRoZXJlJ3Mgbm8gcG9pbnQgaW4gc2hpZnRp
bmcgdHdpY2UgYnkgY29udmVydGluZyB0byBzZWN0b3JzIGZpcnN0Lg0KPiBQbGVhc2UganVzdCBy
ZW1vdmUgdGhlIFNFQ1RPUl9TSElGVCBzdWJ0cmFjdGlvbi4NCj4gDQpUaGFua3MsIHdpbGwgZml4
IGl0IGF0IG5leHQgdmVyc2lvbi4NCj4gLS0gDQo+IE1hcnRpbiBLLiBQZXRlcnNlbglPcmFjbGUg
TGludXggRW5naW5lZXJpbmcNCg==
