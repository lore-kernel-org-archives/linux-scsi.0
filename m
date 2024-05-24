Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF82338DE1;
	Fri, 24 May 2024 03:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716522871; cv=fail; b=rTw4aOcuBGfRlJncObgYdJ+xqNOZIRx5vQQLgvwSgMkvLwaMlR2ve1F70TsPaYKK8pR2WVTlrtgq6iJlNdPVICq1vP3Y2rLHMjI+bg66Igoo9a2NkjaSQQxvhz3tI8VFktwIBGEU9/j3gsTiFbI2PsEPDkuqFrZpYzknR2dHAJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716522871; c=relaxed/simple;
	bh=Bg22QQfa0zklLBMjpJQU+DcBqsATPi+1P/SR4r803eY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hl/Nf8+6f9ddQWxp1931o9prVFroJvQmgyCFtbIe7OZULjHHINjiZWGRY/med97vZ4CKBGy2z30yTEQtL1VMOy6x44uMMIWrlyH9jZzUpjZGEHyKmPqk8P149wt3tDmHqCKnmk3tgScnr0UFqaIoO/oBfZL8GS4JmJOykxd65OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VId3uxoi; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=bOfX38QS; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VId3uxoi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bOfX38QS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716522869; x=1748058869;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bg22QQfa0zklLBMjpJQU+DcBqsATPi+1P/SR4r803eY=;
  b=VId3uxoi1UspXSIeL5jPcFdRbC+5mPEWiYGzu2mfR9WTH57XEKKO9HRu
   N4CTnMIwQ7cx7YaXs10V2suUSvaaDNxG6+R/EHq4GYKRWOxn7Zzo99tUy
   eu4EXt4ZWqi6+UNkNM6coX0VqkSCvPFvk7VL9OvfUvM1rQcMwjSw5ROrY
   cwzyEoH7X97g41PxxuqPaZhbQnbrAmchXEPZqgLczeCt2ZJdwkD2aEla0
   8pX5JIks/ieigBo1AhUG7qVtwd2YvycZDPFWAdQs/I58tqpVTXP/Qi8jg
   eWoXIrEO5K12ZJS42j9X8bYVEI8S+wfyD4blOmIoUTdPHa9yIdr5bR/dq
   A==;
X-CSE-ConnectionGUID: AMv3Yn6nShmGl03YNoxIRw==
X-CSE-MsgGUID: agZhQdbGQUOOmmPClxTQqw==
X-IronPort-AV: E=Sophos;i="6.08,184,1712592000"; 
   d="scan'208";a="17966251"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2024 11:54:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5Sb2SFC3QfkrYvXDjtEZ5Y4z/9+XOWMKHTaYwBYX8+3Be+WM7NL+M9Qwul8BFybzwoEObPBnfG57MHFJSpqaVkUIwqev4ex+kOSDvP6k3mCD/+d4d+Vx8hEGh/AFT+7kzyHRiyLuE8JCieZqB6P04bWZNQ+DBmb3+bVfIh5yx3Kp8ATvajgDWIVXTmeDttAodyKihQKfHSpNfQWX4HqObpf8m3QEopE9qL1Y716qXo4DLUVor9Wdwy3tzTt1hDDEEvRnTn9Mah7eijECT4BsP+IUdY/t0iu/yYbhCswFMb6u/A6JbRlt3oeDsHgvIyz/Zk6+D4vR7VP7vheZXtwUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bg22QQfa0zklLBMjpJQU+DcBqsATPi+1P/SR4r803eY=;
 b=N7fqvcbnE2lUglBccXGMPS0GxyI5UUYatDTFkejGwfjNtBbuMFrbbFp2KSdUNYnB5Qqt2rx2fw+jVCCbaPQ5TC+IwB5H8lf/xfnJaZrjV3VsgC6W0moFSkKKqSjg/YYtN7YQXJFzBzK4/5qcA2SRV1TJIHPGC4uT4gi8eduyhr5r81ZV43Gpds76o4WoDrI9rWIKIZKtCZq/lAMhy4IxN51DfjAwbdibdpU7QfKx5Cw2OoBM3AgMWpRcw8bKyNHGKwgiUU45Y3nm9afU/gB1L8EDELz406mzt7hHpmo/yizHakOD6hwLA2TPM7c+5mxK27ip/YFOtjrYrgx3kiPeUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bg22QQfa0zklLBMjpJQU+DcBqsATPi+1P/SR4r803eY=;
 b=bOfX38QSrMD2cHp0+LOT1tDMJw/gmRdKc87q8onfqT26snCbPbcYYzwz1UlMWZewaACWq4pKtM62Xo73RHrEMugaYU2ZxYlRpdjcfuzL6Rme0+5SGMSaLLq5SlJ6nq8gk1Cza3xN+TUngCUhKh6Hgp6+LHijQwu4n/6TqvG1PmI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH7PR04MB8682.namprd04.prod.outlook.com (2603:10b6:510:24d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.22; Fri, 24 May 2024 03:54:24 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%5]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 03:54:24 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
Thread-Topic: [PATCH v5 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
Thread-Index: AQHarREDFVbpP04WN0ixhMxOW+cAZLGlcTQAgABQkTA=
Date: Fri, 24 May 2024 03:54:24 +0000
Message-ID:
 <DM6PR04MB6575A38D05EC447D5E043787FCF52@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240523125827.818-1-avri.altman@wdc.com>
 <20240523125827.818-4-avri.altman@wdc.com>
 <61984ab3-1bcf-44e4-8b2a-0760af3cefd9@acm.org>
In-Reply-To: <61984ab3-1bcf-44e4-8b2a-0760af3cefd9@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|PH7PR04MB8682:EE_
x-ms-office365-filtering-correlation-id: 73968356-94a9-4635-8219-08dc7ba533b9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?S1h4WVRhcDhzczMvTllnYzA2WWlKU2hWU0Nhd1NTYjl4OGhzTmFOMDMzTUMr?=
 =?utf-8?B?bU5WTHhGVU9MYWF4UXV4ZERDNk1iR2lORHE3M1NaWmZ4R2hab1poK2ErSEI2?=
 =?utf-8?B?T1JZSnM1S3lmL2MrNzBDbXVoWFJxZTNEUitUNTBka0gyQk1CNW85MkdSaHRF?=
 =?utf-8?B?RGF4Yk01aTVIaWlqNGNhZG9BeUxWcUNOZzcyK1Rld0J4Z1A1SDZnMVNmOUFp?=
 =?utf-8?B?STlnTitIWkdBUVNNd1VHUVBJY01LRzBsYkRMMHVGV2NoOFRJbTBOZ0FRSjN3?=
 =?utf-8?B?ZjdHcEZZZTRJV3VMekN6V3crVnV2WG9zZWV1a0kzaUM0WnNXTXI0ZWkzaUNF?=
 =?utf-8?B?VnphdTZtZERURjNUbkxZaUp2SXZGZDlNYXUvSFltYmszZ1Z6QnpPWFp1SUg0?=
 =?utf-8?B?dTltYTRrRGJnbU5qdzBxSlAyTUdqVVBDbXgzS3R6dWZmMHlQSlczYlQwSE1G?=
 =?utf-8?B?Z3FHbGM5YnhnTlBSb1NqcWl0b1FXM2t0Ym8xMjB5ajVmRUhzU1hSTFBGbzVw?=
 =?utf-8?B?UThYZHZmcVR0N0gvT0djL2h3ZWRqTDArRUFFKzRkK1FGZnd1Q1dwb2d6blds?=
 =?utf-8?B?ZXV6WVliTXF4cWg1WFZjTEc0NldSckc1VGdHY04xVE81ZnpaYWJZbFlOOHVY?=
 =?utf-8?B?aXplVU1xMEJaVlFUaDBrZXlRalNyY3QyRnYvR0xqblhlMzc0VTBDS0JCWUFK?=
 =?utf-8?B?RGg1aTJUV2Q3Tzh0ZU52WExmUUwzREwrOThoZFBjRE9TdHBKOWEzSXZsKytI?=
 =?utf-8?B?R0d6eTJ4cWJGdnpqTVcvN2U3K2NTVmVCOFVVMzgvNCtSd1ZiQUxRQ2NNNVNX?=
 =?utf-8?B?WXBMdDZib1BMcENSc1lwYTkydlpUU213SWJDM2t0S1JEd0VSRmhwWUl0NUF4?=
 =?utf-8?B?MmJjVlFFSzVRaUwweDhnL1B4M205ZXlFMXFGc21VVGx2WlBVUUhWa0NxbTJ3?=
 =?utf-8?B?MzNhZExadEZ3RFZyaFBPSjQ0OVFMdkxwYWc1cWNLOWp3RnhRdHJBek01emMr?=
 =?utf-8?B?R01DNVUycHQ1ejBzVkl5NDRmeHhIVkFyL21lTTU4TWIrSVJkSlBsOUNHRWE3?=
 =?utf-8?B?RmsycmY3T3k3Nm5tbE8rbnBYbENidXl3RzVTTC9rWmFrNWhXSkhFMnN1RFlh?=
 =?utf-8?B?aVJxa2g4QWRycFg2dktrNGszajJ4VzFiQS93Z0pzNGhVUFdUQ0I5SVI0SzZR?=
 =?utf-8?B?QTk2TmtrTFdhUjNDcFIyZWhmU2lubU5lUVRvblBDSU02OVNJMFJ0NVpVZEJp?=
 =?utf-8?B?SGdvN1hrOTR5c2R5R3pPb3NQS0Qxdko2a2xhWnZMNE4vM3MrNW9XK0x5UHNm?=
 =?utf-8?B?c0U0d2VHR0U2WTBBdUFwNGRvT2JmQjRDVGhZQ29xOHZSYUdNRmF5Zm1BSWFT?=
 =?utf-8?B?ZDdLRVhsZWJTSFhJd2d6dGNPSVFpRGNGTXp2VXdkTzI0K3k5TmFPdGtRTXpW?=
 =?utf-8?B?MnFHeDhzdlU0cTJzS3o2YlQxUmR2Vm0wZ0F5OGc0eU80N08rWEMwOUMrZDE2?=
 =?utf-8?B?a04vYUNMWmJmNVZVdTkxdWdxZnNOVmMzM2tCMUloMW5ITFVYOXQwYVFxTWR2?=
 =?utf-8?B?d0RvTmd0a2RjcFg0NmlGOTVLNm1IeGd5R0IzOC9aaVZDWmw1c0liU1BmN1FO?=
 =?utf-8?B?blRBM0NOams3c1EvWS82L2d6Y0FUb3RYYURYK3ZSSlUwWDdzUU1TSHExUGMr?=
 =?utf-8?B?cENNd3Z2TWxSeEloMGdXV0h2dytHNkUxTlpQeHVFeWtKcFdBZXIwS3p1L2d0?=
 =?utf-8?B?dnpiSTdlcGVENmxxVVUycCtiNXRrWmZRODNuNHFNb1ZVMXhQU0hON0YxWXZG?=
 =?utf-8?B?SDloL3NWVXk4MFRYdzlIQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aWNGZVBZR1IzYUNsWUI2SzlVNS9pbDVxb2Y5bHhlbEZlQitNVEwydFBRVnMx?=
 =?utf-8?B?Y2RLRGY5SVMwbk40cUhyQm1JVXVUcENQTXdzUWhsVmlHeVVibXR3SU4xb1Jh?=
 =?utf-8?B?dzkyalN1ZWsrbzkxSWJNY0Q3aFVNUHFNZEpNc0pJWG9GUWpMQlhrN3BuY1V1?=
 =?utf-8?B?Q2d0SkVzZHc0eU5iYjB6eThnVCtLU3FLc3daWnVRRGNrd3hTU2h0TzRlMzEx?=
 =?utf-8?B?cHE3anVEY0ZxbHpxcytrbkUrcDdOSThZZkN6T016d2ZUeFlMbHlMS0JEb2lY?=
 =?utf-8?B?K0Y2Q2VKVVRoMXdpbkFCV3lielFSN0tFR3RXQ1VUSHdvNDg4WDRjdnZnR3do?=
 =?utf-8?B?c2p4VjU3Y285U1M4ZDd5QjFnUklDYXFMUmFwYzFGOW5wMVMvWCtuNDE1czNZ?=
 =?utf-8?B?R0hDRzhWMGJqZnBnK3IvSjFUaWZ1Nitla2hmS0hXYlRJWHBNa05TUTVwL1g3?=
 =?utf-8?B?Yk85cHZoRTJXMlNLWVJCRmpWUjBsY2hLbEx0aHFFY1p5bUZobUptaFB3RVp1?=
 =?utf-8?B?cHJDd2k4R0JiMnFYQktjSmpHaHY5bTZEd0dubVJjbTVYeFlCNnhHVXhIWTNV?=
 =?utf-8?B?TWg4Mlg3Q3lGNGRjWVpIeDhDWCtjZWFIczVKSE1OTjhDYWplN0N4U1ZYTzV1?=
 =?utf-8?B?M1l3TVRwdWhjU2tvbWRpRjN1K04xMFF0d2ptcDZMRzdkNW95YzVJQ3JUd3lT?=
 =?utf-8?B?cCtJMUFtNU0yVUNKeVhRSm56WjkzdW0wOW1CNzIzMWJEcTc3bzVWUTY0bkd3?=
 =?utf-8?B?Uk44RjVLN2dEU0NTcHFtNEFabytWeHVvbzRBOFp5aGtqOVJ2T3VrVHMrZkc5?=
 =?utf-8?B?V0pwcUxnNHNURGp1Nk91TEdrWEFxSXJoNG9QZ0puZFp3T3BjVVNIclgwVjNt?=
 =?utf-8?B?aXlIOWpRejlycStHTTRjUDdlRHdSTGUxSTBVdHBWOXlXdTNJN3ZWRTJrTS9F?=
 =?utf-8?B?bDdXMXVObUJ4WVhuMWNMV1d0VWFPZnRqK2JSd1V2TlgrRGpaenNINzRVRkQ5?=
 =?utf-8?B?NUhDZjhiVmZWZTl0cklLQXZHcUVvQzhMT2s1cXZuTCtFRDBOK0t6ZFF4Znli?=
 =?utf-8?B?TDd6MlFxdjZWTHBKeExuSjZRWjZhT0p3VGJGVTlIb09BTUs2dGpJUmw4RFJx?=
 =?utf-8?B?Uk5QbDFWOTRIWXFFNTg2Z1R3R3FqMk5TVWo3eTVmYlJKRTJKNE55WEZyZENB?=
 =?utf-8?B?cXpqbzVjS3ZHdjM2ZGlLMFIvVUY2dGJTL1o3eFNQbXdmQVM0UzBRd3h2eldX?=
 =?utf-8?B?alJVM28xdWVUazhIZHpnMVdCOUFTbmVBMzVFUkt6KzZ5c25PVzltcmtDYlJH?=
 =?utf-8?B?eGd0WkpOeVJuSDVOWWxZNjgyaUg4TVZVZmJZNzZ2S3ZFb3JSd3hCc08wQVRT?=
 =?utf-8?B?V0pXMXFFQjFwNU5lTFVPKzFLVHhCUUJTQk9QU2JoSFZrTzZYRWNsRFl0bk9Y?=
 =?utf-8?B?bE8zVXAwNmVXZXY4MTFoYUNQSld4YzMzU1VYekxoVUhlMzZZNVBIRDBnTC82?=
 =?utf-8?B?Q3J2eURvVExOcWNKU05OU0REK0lPWDFkZ0ZnbGFia0ZVT3UzZDNtdm5hVkJl?=
 =?utf-8?B?N2tNRk9JUDdpb2FDemRvL2hvODBTcVVxeWJwd3dKTjhpSEhiUFlnYkZKSTVI?=
 =?utf-8?B?RFQ5d3dMMTJxeTg4MjdKL1JFN3Bsd3NhWm5WWTdYcXA1M292QTN5bFlZVjVJ?=
 =?utf-8?B?NFNnNFlWa0ozOWdKV1lWODlFQWFqUGZhcER1MU4yZmszRHkrS1lpZ21CYlgy?=
 =?utf-8?B?blJFKzBiS3BCbCttdytqdWNLRGpSb3RwSTJtQ09KSUdVVWFhK015ZDg4NUZ0?=
 =?utf-8?B?OEZYVzExVkkrS2gwa0ZPdmZsMUFaQ1ljRkI1ZzNoaENaUUZXK20wRU1YaU9h?=
 =?utf-8?B?NzMxS2RjSjR1Y0ZnazdxNWs0ZGE3ZDk1ZHhCSUU2Sm5pTGJOKy9LTVh6QVJB?=
 =?utf-8?B?TFA5d21GNktrdjVJcEp2azM2YjJrdXhkSDM4YndNV2p0UklBOG5xcTlmNkcw?=
 =?utf-8?B?VEFDYjBCSFUxV25yME1zdWNQQnBQS081YTFLcHQ1WnF2SExNbTlBbkZzVGJx?=
 =?utf-8?B?YkRmdUU5bHhkN2pDeHArZVZmd1NXeEJRdkY2MlZaQzU3MVJLY0hzUWIzWnhQ?=
 =?utf-8?B?aGVsalZyOEN2czBhNk52d3Y0UWFVSFF6R1UzR0czMHlZOWZ1LzZ4eTJ3Si8z?=
 =?utf-8?Q?20iCK0SDUeZkBS86MmvucCFE4JSVtktFqOSDZXD/EJOU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ywXdipcoyvacaxN1DWYo/Xr7ttlDQeZF+yvly3EmjIT/geQt7fSZeecGpEZoHNJvlSsD4VvNnWw5CTTNU2VybekwEJqVqkEgJQfKw0zSz0enJABveSg96WgzRC4lowdyz+GNabiF0t/9oEh1JjWkR9Wk2SaIMJVjQHMC37vW/Wh0ArDeZ1BPesaloMnsk9V6Zpys96wYmXJEtusLw4cWHj0JkwWwcY9Zp+pY8WV7F+Jsgkf97Iv1q5/1p+2e+itoxF8kNzWpVv0mL9xo7Oa8QcPlXYWXtnQ7etSRij/zH9YXGo6ps28ivGldxH61McfTp1rX2PQzWjEnFj5wSo1C5vAtHuvbkt/Lsj7RDPyPiRQI4EDrbucsE7rx6PjSrexGwn8dtEoaYBX4WCgZtpgGvsnS/pX5RNe4L7W+MQbYKTkxL+btPEiwdEZmv8u/PJj63M+l3SyscDTlPlR9Uny3rzGx3hSgtlmilV3C2dmOkwDtiVj4VzIQNqIPVSwolE7wjiaGnm1BqvwOA7M4voN69gQWRd1ns34SE6PmKh+i/am7bFbuKTnvfmOI2zBo3+grZsi5l6MsfvEBJhOxOhDwET6KEpBaTPi45EGfpZKBWlV1453UG3MoPWMM4lT01hOH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73968356-94a9-4635-8219-08dc7ba533b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2024 03:54:24.7187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4PPu0TNRPF1Y5DqENEf+hlG3QzMo8CpfXxrJCb8psTS+bXC3VkB+MoweCN4qDZuvJpn3+zqWPbZrcGyBDezZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8682

PiANCj4gT24gNS8yMy8yNCAwNTo1OCwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gKyAgICAgLyog
bWFrZSBzdXJlIHRoYXQgdGhlcmUgYXJlIG5vIG91dHN0YW5kaW5nIHJlcXVlc3RzIHdoZW4gcnR0
IGlzIHNldCAqLw0KPiA+ICsgICAgIHVmc2hjZF9zY3NpX2Jsb2NrX3JlcXVlc3RzKGhiYSk7DQo+
ID4gKyAgICAgYmxrX21xX3dhaXRfcXVpZXNjZV9kb25lKCZoYmEtPmhvc3QtPnRhZ19zZXQpOw0K
PiA+ICsNCj4gPiArICAgICByZXQgPSB1ZnNoY2RfcXVlcnlfYXR0cihoYmEsIFVQSVVfUVVFUllf
T1BDT0RFX1dSSVRFX0FUVFIsDQo+ID4gKyAgICAgICAgICAgICBRVUVSWV9BVFRSX0lETl9NQVhf
TlVNX09GX1JUVCwgMCwgMCwgJnJ0dCk7DQo+ID4gKw0KPiA+ICsgICAgIHVmc2hjZF9zY3NpX3Vu
YmxvY2tfcmVxdWVzdHMoaGJhKTsNCj4gDQo+IFRoZSBhYm92ZSBkb2Vzbid0IGxvb2sgY29ycmVj
dCB0byBtZS4gdWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMoKSBkb2VzIG5vdA0KPiBndWFyYW50
ZWUgdGhhdCBhbGwgcGVuZGluZyBjb21tYW5kcyBoYXZlIGZpbmlzaGVkIGJ5IHRoZSB0aW1lIGl0
IHJldHVybnMuDQo+IFBsZWFzZSBibGtfbXFfZnJlZXplX3F1ZXVlKCkgLyBibGtfbXFfdW5mcmVl
emVfcXVldWUoKSBpbnN0ZWFkLg0KVGhhbmtzLiAgV2lsbCB1c2UgdGhvc2UgdG8gZHJhaW4gdGhl
IHF1ZXVlcy4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
DQo=
