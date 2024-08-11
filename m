Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176491E885;
	Sun, 11 Aug 2024 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723384824; cv=fail; b=oIlUgbMxShKfUVCeRobbSPLL5tZjCQDF5gNpSo7+hSxjv02Vz4Y4bNuGZdnuz+iqY3oc9dowQnyn/Ae/FGrLIPJry6pj2N4KO58qlpA7MiTC/vQdBDKo0zmjq64qdlDhG3rrubCMJaCOTR1AfG9Ij0/HUk7F6GzAEJya5hiNBnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723384824; c=relaxed/simple;
	bh=Wfq4lLQI37Y6gqMt1x9CYAhHQ/twPxP4DKVa+dtFmDI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L7dW5JYEcqnv8ZX2vuqV3nv0T2QUnqcZemTUDmE7un2YUp9AzvdI/dxX7fEL1DwoJcPdVNgbEIKZsqNxHTSYCqWD6EmGTMMW9la5DJHacz9VDQyxNHmf0gt49DZOqIJU3V5jo1WUbPVUGFGoTAIvwP8svAZViGMRjTuHf428Dsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rp3Q1u/W; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HIGj1iHw; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rp3Q1u/W";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HIGj1iHw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723384823; x=1754920823;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wfq4lLQI37Y6gqMt1x9CYAhHQ/twPxP4DKVa+dtFmDI=;
  b=rp3Q1u/WfMm7SIqYjlhO+AZgL5JxoLvbRxE9HB+lVDNmjTtoK6BiGY81
   yBh5C7+76QfzugxnsFDI9asbWftNEKgw4Ry81pNn/d8g5mlSXIW0xmwq4
   +/hIHgyTucS9qIbpQbf7V8h06lAqVEc3VSCho2/n6MTleWbMN2tUVxyaG
   xcQU6UDUrCtiQJdFOEhWOe0IJJ8QGRk5IhxuVrPKnpP1dyu1raZY1n3bK
   ffCFnmEfoddAqLKHeb4WcN4R0BPTFqCeAIfOf9ubclOJuYy05kThW56+m
   y6ckC8CQ7S/2nSEXgAdSUt5Pl01IjPqd9dMAOJ9VbhVfjT/INwbBpXQBU
   g==;
X-CSE-ConnectionGUID: NjDC8xjBQTGDbYcnL+xBCg==
X-CSE-MsgGUID: ZKrbvzY2Txedz4e6WIeP4A==
X-IronPort-AV: E=Sophos;i="6.09,281,1716220800"; 
   d="scan'208";a="24008014"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2024 22:00:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ggIDPG6glqcF+xiF3b8HFRaCu6a7cC4vGoST2reaa3Aed2GtztkU3/hsWJUFQNLCJ3P3RdziA3tmM5S2MeDPuMLMTJCH+2u8ArF3QMnp/ssLraywUWLkcld33IsCPQB+6WVBIPEUVnx/McvvP7RyciCxXX81F3ssPfAzBuGUOyJBQ5VslQpU2RaLLT6p1Icy5zZTM2xcVCt9ZjCgwoIa1rs+NnwIXdXc6XB6OcDPfVItzsdoZRO9zkRjEVEZTgbBQJOgA/nrQ/oPrlYGrvmxHRa+2558Asts6fTQiCLABATdltBo/XUzRNIyGlhM8YhtEjetMmfh1/V/hGQ16MMl/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wfq4lLQI37Y6gqMt1x9CYAhHQ/twPxP4DKVa+dtFmDI=;
 b=Jmr6Md4LrHrjKdnHR17fI3y7m57zfEXeigNDf8dakSS+B+xXfCtiKfPf7gSmoAuiaAUjMoQynvtsWHzSkCGts0wywSEBo13eUuukV/dIi8nEraUYPuMQvr3Tg0fe79oO+eKirvOPiLNKizPVGn7Yytb1JVxhsI/B9ysW35g7m1OTjqFsO5V/Y17Zgfcbh6KU70hmII0rC3DE72hDCT6MImO5ablqRINIDOqwDK/rdjY0ylAVPsUzkRxHoApJ8JUeHvmjHjpr0twPeYm3IC5fsHGam1V8NZQzrrqweOTLioDGiXNuTDl2X0KnaHum1eb1+8p00CvQaWQzyqKPmivVUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wfq4lLQI37Y6gqMt1x9CYAhHQ/twPxP4DKVa+dtFmDI=;
 b=HIGj1iHwcG05rT2ESqbatZzRoez46ZqEy+KpAwerHPIPVeXAS45XjP0Tv9TbKaXU4kK5YV8cju48nN81wIDwPEX3riE8iVd29abHIV2gz4ZvM6C7/TAOZxeHEKW34KASMVQRyU11TB6vXqNoxlhdvs2EAtVrlBOURBvctTean48=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH0PR04MB7479.namprd04.prod.outlook.com (2603:10b6:510:51::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.19; Sun, 11 Aug 2024 14:00:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7849.018; Sun, 11 Aug 2024
 14:00:14 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>, Keoseong Park <keosung.park@samsung.com>
Subject: RE: [PATCH v3 2/2] scsi: ufs: Add HCI capabilities sysfs group
Thread-Topic: [PATCH v3 2/2] scsi: ufs: Add HCI capabilities sysfs group
Thread-Index: AQHa6i1LLUyZwuXaTkauKIr+mbUH1LIejp0AgAMF1WCAAHSagIAAD81Q
Date: Sun, 11 Aug 2024 14:00:14 +0000
Message-ID:
 <DM6PR04MB657544D3D237C451E570443FFC842@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240809072331.2483196-1-avri.altman@wdc.com>
 <20240809072331.2483196-3-avri.altman@wdc.com>
 <20240809075522.GA9360@thinkpad>
 <DM6PR04MB65751DE4930E7198279F6FE6FC842@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20240811130221.GA2809@thinkpad>
In-Reply-To: <20240811130221.GA2809@thinkpad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|PH0PR04MB7479:EE_
x-ms-office365-filtering-correlation-id: 096fdefb-9b80-4333-ea98-08dcba0dec9d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ays2KzBYbng1bFRpcmczSmNxTlBraWlGWUZ5Q1FBMkFZSG12bWxKSGZUM0xk?=
 =?utf-8?B?ZHNSMlMxcmUrdFhVOFJZUGNCZDhycFMrR0dWNnJUM0FVMlE0VGt5MFFLSGdV?=
 =?utf-8?B?eGJtR2ovdGxrTUQ5SGFJM2V1aG4wU2FZNUFYM2VSUG5XTCtncVh6ZHYyajVD?=
 =?utf-8?B?c0lKNUUwbnhrTHdQdEF3TVZvQTlzUWVQVWpCRWtyTnRKYkhuMEZpQWE3WVVV?=
 =?utf-8?B?c3VDV011MnFzYlJDZ011TUttUkNJQ2N0SklmQ1JjS3pMa1NOaHBZbHFsQmtV?=
 =?utf-8?B?NWE4YkRlV0I5aWZZVEdnd1A1YTFBbHlEYlUwc1J3UjZiOXdEY1lROExNRVZD?=
 =?utf-8?B?Q2VQY0Fic292Ukg0Tzl6c3FYaGRNUFcycXluY3FhZjdDeWl3bDFmYTZKd2Uw?=
 =?utf-8?B?V2dXYjcwRjhSNWVpd0k1eXVFWXlLcEt0Tnl6TVI1bGtvU3pqL2FZeGkzdEt6?=
 =?utf-8?B?NmlZTVpZZ3ozWGxxc2NsZDcrMkIzbTZTN2RZRTJxOGtndGdyK0JNeHhxb1FG?=
 =?utf-8?B?QUx5OEZDcFJsdXVvdGZjQ09xWXpZT09wUFVRV0xqN3lXNzcyMmZPY0RmNzZK?=
 =?utf-8?B?aXVieWQyMUFpU1dudmFwSXc5VDN1OUp1Yk1OQW1hQkdFS3kvLzNEbSsrRUE0?=
 =?utf-8?B?dGduV2RDa0Q4SXpRWVBWUlE0VDhzSUhVSURLNDkyNHVuVzNjelhXdVFnOWlz?=
 =?utf-8?B?d3JRblByaTVCdTd1QkIwbHkySnRkanMreEhLRGl1QnFRNFRXYmVReGZ0YkUv?=
 =?utf-8?B?QlBPL1p5R0QwL1cydytGRm1pTEZueXNScHIxbFp5ZlRWUXd5eXBQVEZ5ZlQz?=
 =?utf-8?B?am50SlFQQkF6dFhHdndXcW1KczlXVTdjbHJCaE9QRUhtMWhJQjNWbTQwQ3BI?=
 =?utf-8?B?bFluRzhPc0U2SFZocmljUWllQzJCREkzSFVpc3E2cWhhUldSaEV3N0JOMGN0?=
 =?utf-8?B?a2lGK0x5czM5Mjk3M2JuQ1lCa0hwY2ZneE5JaFlaODlpV1RDVzZjQ0huS3hO?=
 =?utf-8?B?dWVsQXRybGVDVktqN0lVaCtzNjAyaG9sSExlRW04bmFlaFdjcmcxR1p1YW5Q?=
 =?utf-8?B?QlJmY3ZtVlozQ0I0aVU4RzlGS1NMK2lNOWtiLzluSnNub2UzTGlyd3M4aVlq?=
 =?utf-8?B?Q1Mzdkh6NnhXQmNTZysxSVhDdmpkLzVrZkZyVi9jcjlQczJvWU56Ym05KzND?=
 =?utf-8?B?ODJqMHNkRHFlZlpjNG1UN05oalFTSVg5aEIvWlhsV2t1YURPcVFuT3lPK3BE?=
 =?utf-8?B?T2owL3lHOS9NM0pGa0V2RWNIeUhQVDMvR2MwaFowZzhUUmo0bEpVTmFTUldn?=
 =?utf-8?B?ZVozd2tzUTJEL0pVWVYxY3ZlWUc2SjRNY0NWS1BCaS9sYVBSTzdHZGQwQlJ6?=
 =?utf-8?B?cWNDV012Z0lLNjlLOU93TjZSejRVc243NmUrQnpOM1Q1TllqYjhTV1ZJQVhv?=
 =?utf-8?B?RVcvMHlFSzdPREFmbUdyRjhXVHdaTzlFd0VVQTFYdGQ1SVJ3Z1RrVzQ3SHA3?=
 =?utf-8?B?MmRRVnN3UG5Lam5kU2VmYXNxeWpsb1MzN3UvOE9UZGJ3RHhsanFSczNseHNJ?=
 =?utf-8?B?WGF4RmRrVjdSQ2ZuWlNXZWhtZ3RyYnhIenphUDZGTXk4b2ROQ09ybVpUVnZh?=
 =?utf-8?B?QW11c3ozanozMkVaUVZ2a1hwYWpUZHpzbmVWZGNsTHdyUEd3cGZldWc0N1Fk?=
 =?utf-8?B?TzBiakJOWnVwQkxnNVRWRU1JeVlRSlZ2eHJta05ad2hCby9BcVB4MlQreHpy?=
 =?utf-8?B?NC9jc25Bby9UNzlVcW41ZGEvREZOalMyQytNb0VFcXNZM05odUhkTmYwWk1h?=
 =?utf-8?B?MG9GcmNCeTV4ZCtvb2VhcmhlUjFaRUduWndJbFl2RWU5UUlPTXQ0ZEsrSFhT?=
 =?utf-8?B?RkRwY1RxcWpubVlLNUJwUlE4clpMbFc1M2Jyb2hCVnhTK0E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N3orMnBTQ3hpUUFOWmdNcEZhT2lxS0FBYnBFQk9jMnN3TGJqNiszRXhWSDZR?=
 =?utf-8?B?OTFuTkQyV0UvRkR3U3NrRWphVDNMM1kzOGxKVUdkczNZT3hVR1NHMVdpNk1I?=
 =?utf-8?B?WFJQOGQ5TUhWS2ExaENBbUNJc0JINmJhTSttbUtmQVVUSnlGWnUvWE1LRTND?=
 =?utf-8?B?bzhicC9oSHdGR0d0cWhVVUxTVzA4Z09iMjUwUWx4OFVHOVVaeUFnSWFPem5C?=
 =?utf-8?B?dnY3UEUwODZ4U3ZoQkpZUVoydUdaRmxBZXlrR2VhSXAwMEdjRlRHZ1lRelg4?=
 =?utf-8?B?LzlleEZZaXZhc3VBQW0raGhRUmFrQXRZTDlLZDQ5cEM2cyt0ekxHeGhldXJC?=
 =?utf-8?B?QkQyZXRZU3ZwS3pMRDlIZHA4TFZKdXlwN3huMDRkcW94RGw3SmZiaHpvYkg3?=
 =?utf-8?B?QmxlcFNQOC9WcHNBVHVLTWNsK01nYnE4S3dhN3BDUVFOL1hNdDhva1l1MXpL?=
 =?utf-8?B?azhBTHRncVFEM0xTZmlqU0RNd0h0WmlmNHRKNFlub2VPTnU0YWxSN2tZWmdu?=
 =?utf-8?B?RWNTem5LL1pjTlhYSTNxQ3FLOE4rRlZpamhXcG84L2p2Y2JVTzJ0YUUvMHpq?=
 =?utf-8?B?QzVSM0dPSE03MzV4WWxrZEtrYWlTdGZqUGJjNzVwQWNpQWhzbkloalNOeGdp?=
 =?utf-8?B?dEFxUEFJMXB5RVBCRjdsSmpFQmk3RDJQeGdsUWo0MXdXYUxCYTZKbWlWblZT?=
 =?utf-8?B?T3lZNXpWRWNKWFUwZW10MHQ5SE56eEthOFRzTGhFa1NpbFNGRlB5SXZyYXhu?=
 =?utf-8?B?cTh3MTVrdE1pbjY4azkzTVY5d3h1bWUvYzY2V2hQUGxPYzNMNFl6Y25pTmpF?=
 =?utf-8?B?Y0VNcDdXcnpkeUV2MkEyOFVZbElYLys2U1c0RVRWMWtxNGNjN0VTaEQ0NlJF?=
 =?utf-8?B?a0w4ZjV0UkFGcEc0cm5pK0JyMi85WVZIQzFybUdKUnlLTnZEOGlRSnRJWmRC?=
 =?utf-8?B?SzhYdjRQc21jQmpZdVB3WmZ4RFgwMG4xcTZwVG1OK2FYNTU4MVdMWTNPMy9N?=
 =?utf-8?B?UEt0MkI1VUNMTDNKMXNEaTlka01mSjY1RHZKQ1NLaWJ2N1ZDcisxZUpzWXU3?=
 =?utf-8?B?NG0vRmpmZ3RXMU1OcGJYYStTcWtQK3o0WU8wU0JhR09TRkJEbFd2TFBIVHR2?=
 =?utf-8?B?QUVWSWxVL3N0M2tsTW9wQTdUWCs5eFJaYjlkYW12Ny8vQVcwQk1EaDlySzJt?=
 =?utf-8?B?V3NXeFBrNWdDZ0F5WkJyQWZWekdKMmtkM2YvaTlDZG9Hc08rNnl6Z3J0b2RO?=
 =?utf-8?B?ZzZsYmFWZk05ZkRybndCc0pMTFdkN3Z1WDc2Uk1LamNQY09yVVJpd3k2TFZs?=
 =?utf-8?B?R2IybS9XdjE1YlBQWW0zd3JrWUkwRndPRE9rNG5UK2pnRVEzeVFLYUxuUkZa?=
 =?utf-8?B?NmF6V3VlVExCUTE3VmRZY0pRTEdaYUJNbSszTDk5MDlOSHlFR08rMHNGRkFK?=
 =?utf-8?B?N29oak50WUlRN25UMHFGWnNWQlM4blE5RVl2cDFjaWNsdGhSMDhwUk1OVDFG?=
 =?utf-8?B?b1NWMnhPTXgreEIraU5mUjZELytuZ2JnNmdBVEJZQkI3bytwaSs0OWdwY2dx?=
 =?utf-8?B?c3Qya2J3RlpsOTNPczAzVStlT2xDRUpHRWF2dytKQ2FRVmZlMWkyaVIzWlZ6?=
 =?utf-8?B?ekFNcStjY1V2TUVZQUF5NTlVSXFuZytSWWFjcmxuR3c3WHl4aXQzcWw5RytO?=
 =?utf-8?B?TURaaUlZVWpabUVGcUt0RUc3UEg3U1lsK0tQYkhtYy83ZE1KNjAwSGhPQkt3?=
 =?utf-8?B?eGx5dTMzR0hZN3dQSm8zYTRQOVlFVGxmQ2x2NmtRVFo1c0NYa3RKT2lvYTU0?=
 =?utf-8?B?V0lybW42MlFobjJiaHN6VGp1YzV3aTJORUJpd2UrV1JuOCt4UTFEekxjV3NQ?=
 =?utf-8?B?ZnpWU3cvdlN6MDJ6Y090QzZGcWt3cHVQQ1V6UCs1THlhY1hsRzIzVW9wbTJs?=
 =?utf-8?B?N3BjUzQyT2NrMkI2a29IVWV1bldPSnJ0L2xkSHRrbTdtNlluRzFKZ0NJVGJh?=
 =?utf-8?B?cE5ZOWhqVjFqcUF6SXc3YjVURU1haHJIOXAwanFickN2QldsZVVwaTBLRXd3?=
 =?utf-8?B?cjYvZU01Y1lTMjA3WVBrUmV5cTAxb1lSNm9MTEl2eC9RSDBDWkpreXhwRnZT?=
 =?utf-8?B?a0pQVFlFbDRXaGgzeXN6MU5HeksyTU82NVNJaHB3aEc4YnFIQUc2QXR4Q0V4?=
 =?utf-8?Q?1XTmg+QHJ33SaW4ASX3Fd+uWRz+K8G0PLHJj3B7RlZXc?=
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
	GCD5jMGxZ4hYgw05od5noqP5aFM222tAze1q++g7XkxYce/g11PY+tOSrqn176jdpequF6hcwIUgYrrTjNRjCQEhi/PVWdAsTSVK28vyg/DJXWFsMwytBCHfmIF5MqyYBxkjVhJ7VMc+7Jybq9pH9QaV6nh9qJnxEtBOa+w96Ez9qoyOtWOmdL44ttDiqWoxuwuuDviZISkKRcc2zup7L+0Onn+VxjTf8thhH9epWXioOzn/53chQcEAp6iyiJ0688ANrgSVPDzsdJZrWXqO+Yg6f4YKL7B6jEVT6HikDMrA/qg6RMfMRP6cUEF4t4aksdIP4MBkC6NmcIdvCHZCXXLlT1O/PKMxJbjo99ia2HuqLZLdFOGhO2SLFRn3sw2vGOYSJH7iBogcO8Y8v+PKdpuQs81K9U/vMn/H6tMyBZwRlaDOBJZEKLnPnzHAJmBt6+8BPr+P7cIC5aVnKIWHhw89LMgaCZdLgPnL7TzyTqakxnDdfqcQv/CJpy4y+ajaE1CM0s+EjDNpCCE7J/JY7pl5rNhSF4XktMdxdMY/kjVHjwFXuumygdUTtHC/Vy2z7tU1SB+E+UiVQ0YmnSgmadpzi7gebv7Kb8GPHs2Fgtb32UFTD4qu+aQPJyYpd0br
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 096fdefb-9b80-4333-ea98-08dcba0dec9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2024 14:00:14.6711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJTP2vQQeA606Im6YHhyZI07/g/AFZfR2WVzuzd+fE7G2Y3H5X3wsX3Ywx38Y1T+PNRPySYctiMv+UfnlC2aYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7479

PiBPbiBTdW4sIEF1ZyAxMSwgMjAyNCBhdCAwNjoxOTo0OUFNICswMDAwLCBBdnJpIEFsdG1hbiB3
cm90ZToNCj4gPiA+IE9uIEZyaSwgQXVnIDA5LCAyMDI0IGF0IDEwOjIzOjMxQU0gKzAzMDAsIEF2
cmkgQWx0bWFuIHdyb3RlOg0KPiA+ID4gPiBUaGUgc3RhbmRhcmQgcmVnaXN0ZXIgbWFwIG9mIFVG
U0hDSSBpcyBjb21wcmlzZWQgb2Ygc2V2ZXJhbCBncm91cHMuDQo+ID4gPiA+IFRoZSBmaXJzdCBn
cm91cCAoc3RhcnRpbmcgZnJvbSBvZmZzZXQgMHgwMCksIGlzIHRoZSBob3N0IGNhcGFiaWxpdGll
cyBncm91cC4NCj4gPiA+ID4gSXQgY29udGFpbnMgc29tZSBpbnRlcmVzdGluZyBpbmZvcm1hdGlv
biwgdGhhdCBvdGhlcndpc2UgaXMgbm90DQo+ID4gPiA+IGF2YWlsYWJsZSwgZS5nLiB0aGUgVUZT
IHZlcnNpb24gb2YgdGhlIHBsYXRmb3JtIGV0Yy4NCj4gPiA+ID4NCj4gPiA+ID4gUmV2aWV3ZWQt
Ynk6IEtlb3Nlb25nIFBhcmsgPGtlb3N1bmcucGFya0BzYW1zdW5nLmNvbT4NCj4gPiA+ID4gUmV2
aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiA+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4gPiA+ID4g
LS0tDQo+ID4gPiA+ICBEb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci11ZnMg
fCA0MiArKysrKysrKysrDQo+ID4gPiA+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmcy1zeXNmcy5jICAg
ICAgICAgICAgICAgfCA5NSArKysrKysrKysrKysrKysrKysrKysrDQo+ID4gPiA+ICAyIGZpbGVz
IGNoYW5nZWQsIDEzNyBpbnNlcnRpb25zKCspDQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQg
YS9Eb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci11ZnMNCj4gPiA+ID4gYi9E
b2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci11ZnMNCj4gPiA+ID4gaW5kZXgg
ZmU5NDNjZTc2YzYwLi5iNmUwYzNiODA2ZmQgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL0RvY3VtZW50
YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZHJpdmVyLXVmcw0KPiA+ID4gPiArKysgYi9Eb2N1bWVu
dGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci11ZnMNCj4gPiA+ID4gQEAgLTE1MzIsMyAr
MTUzMiw0NSBAQCBDb250YWN0OiAgICAgICBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0K
PiA+ID4gPiAgRGVzY3JpcHRpb246DQo+ID4gPiA+ICAgICAgICAgICAgICAgcnRjX3VwZGF0ZV9t
cyBpbmRpY2F0ZXMgaG93IG9mdGVuIHRoZSBob3N0IHNob3VsZA0KPiA+ID4gPiBzeW5jaHJvbml6
ZSBvcg0KPiA+ID4gdXBkYXRlIHRoZQ0KPiA+ID4gPiAgICAgICAgICAgICAgIFVGUyBSVEMuIElm
IHNldCB0byAwLCB0aGlzIHdpbGwgZGlzYWJsZSBVRlMgUlRDIHBlcmlvZGljIHVwZGF0ZS4NCj4g
PiA+ID4gKw0KPiA+ID4gPiArV2hhdDogICAgICAgICAgICAgICAgL3N5cy9kZXZpY2VzL3BsYXRm
b3JtLy4uLi91ZnNoY2lfY2FwYWJpbGl0aWVzL2NhcGFiaWxpdGllcw0KPiA+ID4gPiArRGF0ZTog
ICAgICAgICAgICAgICAgQXVndXN0IDIwMjQNCj4gPiA+ID4gK0NvbnRhY3Q6ICAgICBBdnJpIEFs
dG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4gPiA+ID4gK0Rlc2NyaXB0aW9uOg0KPiA+ID4g
PiArICAgICAgICAgICAgIEhvc3QgQ2FwYWJpbGl0aWVzIHJlZ2lzdGVyIGdyb3VwOiBob3N0IGNv
bnRyb2xsZXIgY2FwYWJpbGl0aWVzIHJlZ2lzdGVyLg0KPiA+ID4gPiArICAgICAgICAgICAgIFN5
bWJvbCAtIENBUC4gIE9mZnNldDogMHgwMCAtIDB4MDMuDQo+ID4gPg0KPiA+ID4gVGhpcyBkb2Vz
bid0IGxvb2sgbGlrZSBhbiBBQkkgZGVzY3JpcHRpb24uIFlvdSBhcmUgbWVyZWx5IHNwZWNpZnlp
bmcNCj4gPiA+IHRoZSByZWdpc3RlciBuYW1lIGFuZCBvZmZzZXQgdGhhdCBnZXRzIGFjY2Vzc2Vk
IHdoaWxlIHJlYWRpbmcgdGhpcyBhdHRyaWJ1dGUuDQo+ID4gPg0KPiA+ID4gQWxzbywgSSdtIG5v
dCBzdXJlIGlmIHdlIHJlYWxseSB3YW50IHRvIGV4cG9zZSBIQ0kvTUNRIGNhcGFiaWxpdGllcyBh
cyBzeXNmcw0KPiBBQkkuDQo+ID4gV2h5IG5vdD8NCj4gDQo+IHN5c2ZzIGlzIGFuIHVzZXJzcGFj
ZSBBQkkuIFRoZSBpbmZvcm1hdGlvbiB0aGF0IGlzIGV4cG9zZWQgaXMgc3VwcG9zZWQgdG8gYmUN
Cj4gY29uc3VtZWQgYnkgdGhlIHN5c2FkbWlucy91c2Vyc3BhY2UgYXBwbGljYXRpb25zLg0KPiAN
Cj4gTG9va2luZyBhdCB0aGUgY29udGVudHMgb2YgdGhlIGNhcGFiaWxpdGllcywgSSBkb24ndCB0
aGluayBhbnlvbmUgY291bGQgaW50ZXJwcmV0DQo+IHdoYXQgaXMgYmVpbmcgZXhwb3NlZCB1bmxl
c3MgdGhleSBoYXZlIGFjY2VzcyB0byB0aGUgc3BlYyAod2hpY2ggaXMgbm90IGZyZWUpLg0KPiAN
Cj4gPiBMaWtlIHRoZSBjb3ZlciBsZXR0ZXIgc2F5LCB0aGlzIGluZm8gaXMgb3RoZXJ3aXNlIHVu
YXZhaWxhYmxlLg0KPiANCj4gVGhlcmUgYXJlIG90aGVyIHdheXMgdG8gZXhwb3NlIHRoaXMgaW5m
b3JtYXRpb24gdG9vLCBsaWtlIGRlYnVnZnMuIEJ1dCB3aGF0DQo+IGV4YWN0bHkgZG8geW91IHdh
bnQgdXNlcnMgdG8gZG8gd2l0aCBpdD8NCk9LLiAgV2lsbCBkcm9wIHRob3NlLg0KDQpUaGFua3Ms
DQpBdnJpDQoNCj4gDQo+IC0gTWFuaQ0KPiANCj4gLS0NCj4g4K6u4K6j4K6/4K614K6j4K+N4K6j
4K6p4K+NIOCumuCupOCuvuCumuCuv+CuteCuruCvjQ0K
