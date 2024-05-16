Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37712C68C;
	Thu, 16 May 2024 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715903797; cv=fail; b=NrcxJgeoJUmzm5jvTuIvi1niYOgS4Bt8LNtvPtpdqUpkCxd0n4De/sXve1Yn3ivP/uooUOUrLcUfdsv5VVQ7HgjuWcR+LwUdwBwm5609CIi6+Yr0bjJA4XkC3oPpNUcnyGGgMssh/kPy2lQnectz6+lDyZaFED61SKU2NJn87x0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715903797; c=relaxed/simple;
	bh=9YR2g/R0/y/IzVqf+79WA9xDfu80/cuuTa+3ONP5gbc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q1fdlYv/O4ILXXXGjyKwq/GQy8CcnAfY/6iOaY04NP5SkJy4DyuXxXkIY4h5KOHZVLznF+VeUVO45/2kH3HOf9HH/rwc9lYy+v54yQAA0WpxZZtcE5N9sKlJNiZnqbUOCzeQ496CiLukYZiD0TaKktH9N0esGTyXtHwpuimJ63M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dvFanTRb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nLIUah/1; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dvFanTRb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nLIUah/1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715903795; x=1747439795;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9YR2g/R0/y/IzVqf+79WA9xDfu80/cuuTa+3ONP5gbc=;
  b=dvFanTRbU9Q2mngTCjUw/LtaQIyXwE3lMXEEFO/9aUCF13CTujYnlbKc
   uZaOSQEancu35hNI7l8Z8I7xbXS0eul6L2NBqfqolwgsIe9Dynmh04jbc
   BRjRp4kb6vbucnVselhh95+Ye4zyFeuY+fMXb26GDD6Vv2Q7PmhbsMoJr
   RsBwyo2DLOVYSEClAC8FJbA6c2OtE3ouFvf/2F/UAugW53dWo6hmkRHyi
   l2tiBXUEIkkDQFaQMMrGu7gyo7YIEdBzOG5JTCqNc326fM7mDGFcjA18E
   LmPqjbbilbzVOtIXfn4y3ROf5dwh+MQRRoDYVOqD15sy1CtxBJvwzDJWE
   w==;
X-CSE-ConnectionGUID: AhQNfS7tTmqNszcQW/OnXw==
X-CSE-MsgGUID: TH8fmdVNQJSugzplRZ0iJw==
X-IronPort-AV: E=Sophos;i="6.08,166,1712592000"; 
   d="scan'208";a="16776235"
Received: from mail-bn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.40])
  by ob1.hgst.iphmx.com with ESMTP; 17 May 2024 07:56:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IB0WrXmVFLWoPrkqesuV14IL3SD4jv4A4TlX2I+17DKGxh4IOLwqd3u11uyeQqNNyDL5tADmM1ir9SVzbiirzuSFEwA0OxsHA3Qclc4/restk4WGXmXfZGDEvGHVU9iHDuxz2RxNftZhdy/+34pgp0s6FPdzGChT0+CtlCIw8qxBepfpWLWJ8C7WRXbEYtYAeEHseCVN2FqJ1UTFAdT4vfumFHg0pDdWv0m/E2XLnK3XNpD7KUxhL4cKfiGSDKdrpWB6RzofcffVveYUNMRs//XIzK3bEKA0kW2YoK7ryGCrHv/wZ+jRz7ckQPZ8XvsZMauNVUs7hAwqHgQMhZciSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YR2g/R0/y/IzVqf+79WA9xDfu80/cuuTa+3ONP5gbc=;
 b=bDDXKqkxOeqmhqxTKQoq79GqDomHuL3R9V8Smy4BZ/4vxEh1CwsGnq4wrDxjLNWKlkx6bhSiX610RsAlao2/8X5ynQa+tvxRqsaY/5LIqa3/YQB7TMsdOPd1L0tRGlW1+r7BfuxJMMxPCP/onhHTt3rWA6YsZyA7vD9UGXavaAoap9yo/znOSyK7Pge8BYYZnVSg5Pw0fQyQrOg67SHv+nl2j0UUd6hS2s3VsGMHHu3AbHmbKk2BDjvfDq+iQZpAVxOjNXGoFKF75Kjv8zGaXpKOXyPj6JWOgWBXpx+QO79nVK9L2rl14/H0iogJaygtUUVOQwIQ/i1FKfKfW/BJ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YR2g/R0/y/IzVqf+79WA9xDfu80/cuuTa+3ONP5gbc=;
 b=nLIUah/1ovczuztQjLRGsNJ69vXn91YNXM6woCoH/SoWITACSDLnyYDOuS7jS8oq12Ku58Usz0bjz8ImnSBORGuc7i7smyNINBOKdE/i4xRIqUcqDjkDzn6E/UsiPWMEZH3uhEn+hJgU81ErDJWkfrsUZcb6fpbSnKQS6/Fzypg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH2PR04MB6523.namprd04.prod.outlook.com (2603:10b6:610:6b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.28; Thu, 16 May 2024 23:56:21 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 23:56:21 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/3] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v4 1/3] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHap1UgAx6b0JByVEK7/ocLFKStXbGZ6+wAgAANl+CAAA1pAIAAg4PQ
Date: Thu, 16 May 2024 23:56:21 +0000
Message-ID:
 <DM6PR04MB6575E9CE3EDFF83074F00915FCED2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240516055124.24490-1-avri.altman@wdc.com>
 <20240516055124.24490-2-avri.altman@wdc.com>
 <91e9322b-9304-4cb7-a1be-1f43208800e8@acm.org>
 <DM6PR04MB6575208AAB1E40C6EE91A815FCED2@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1e3308ad-7bf7-4fb4-82fa-a2f63d464ef7@acm.org>
In-Reply-To: <1e3308ad-7bf7-4fb4-82fa-a2f63d464ef7@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH2PR04MB6523:EE_
x-ms-office365-filtering-correlation-id: 68f16853-fb38-403b-a3ce-08dc7603c95f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y0htVTIzMC8vTjlkM2dCUnZpb3V2L2VTMjNNZHpQellqdDZUblIrQ1ZGYWVB?=
 =?utf-8?B?T0RpOEl3cVZvL1RvY1d5VE14cWVSdzF1azZZandBRjRJN3RSV0hmdVAvb1Bm?=
 =?utf-8?B?Nkpkb0djdTUrL3p1S1Y3L28veFJFMlhBb3NIdW9CNGI5NnYxTHp0cDkyaXhr?=
 =?utf-8?B?N0xobXg1d0RsSkZDRkJPdmdBYnR1Qi9uc0trWGtmRk15aVBnaG1nd0lTL2tm?=
 =?utf-8?B?QmliYVJaMEtIR0FWV3hCaGczdGV5WWFGZHN4MmNLMXRhN0tML2FqMEE2aGxx?=
 =?utf-8?B?SDNISElhLzJCR0RtUjBqQ3Vib21lelZpVmRGS0FNaUd0aHlsVmV0ZHprWjBR?=
 =?utf-8?B?bU9rRGxyODFoLzNnOVREZTNCcWh5TURiOE1VbjRQUWZyS3Y2ajJNU1FRLzBH?=
 =?utf-8?B?dEtyQ3BjZFVROVVZSEJnckZQSktJMVN6YnNGcmJrR1RaWHRmQjRUWW5uRmVS?=
 =?utf-8?B?UjdpOWJWMWZ1L0xuTWl4UHpmS0ozbHRDUFpWR3ZHR3ZtVDJNRjVoOWZSRjlX?=
 =?utf-8?B?aGsyVlRSVTNWS0pTK1lmY3BuMEFodStIUElITVpoa1B0QUJ1TFNYbEpsOTBz?=
 =?utf-8?B?Mno3TnlpYmRZTlF6YmE3THJ0LzFud05kWVdtZW9iZDBDV3FZSHJtN2ZMRmlu?=
 =?utf-8?B?anA2cnhXcHdOUHZJNkdXODZxRTNVNENMMjQ5VjFKQ3BhTEFvQ2kxeW1JUjV3?=
 =?utf-8?B?RDFFRVkyQzYvcFZkM0pZK1lUbzQ4SGI1V1Zjd284N2NvNUNCbisvazJZSXJM?=
 =?utf-8?B?VXJWK3NwMjNVNFpCbXo0TW1hTmpmODZNVUoxWU9VM2F3NUZ4NGtzekpNVmgr?=
 =?utf-8?B?MlFEb2ZZV20wSEhJOSsvRlBvMGZvMTM4ekJ6eU0xTWJmdkJFU1JtNk14NjZJ?=
 =?utf-8?B?bEpwM09tWEJIQm1sd1JiclB4QVNLK0NJRWRkYUR3dDJQQjFXZ3JRMHVuRFd6?=
 =?utf-8?B?TEZoWEd6R1dVMVFxZGxnTnJMd0QweDFFb3BpZ1Y1QzYzdHJ6b0pHcE15ZTNY?=
 =?utf-8?B?ZU5rY1lWTnoyeHpJUjA0dVloRVkwNjh5eUR0K2ZPalFYakl1SmZtN0piT1Nw?=
 =?utf-8?B?Y2ZMNExXaDYvb0NmTWVFVnZkRVZpRWFEYURCOGpKUU4rRzBXOFd4c1o0TDRZ?=
 =?utf-8?B?a0ppNmlPeVBSVkp0V290SnJyTGxVc2hFUmw4UmZFQ1JYMFhsd0Q0Q1BsbDJX?=
 =?utf-8?B?dFlmQXlqMEQ0WlNKNHIwOWkvUXhJUTB6RmRLRTV2a3hycTdSeXBKMlFHTFJ5?=
 =?utf-8?B?TE0zenNlWG5LWGl4V2RYaUcxZ2xjdW9QZ1d2R2FjQis1SHgzV2FTcHhJd3BF?=
 =?utf-8?B?cnBEaWlSVHd0ZnBRdWM3dWZVcGI5cEE3L041WnZ1aDNDYWUrVDI2VGRKSXB5?=
 =?utf-8?B?OUVBU1BCeHNkdDNuZmZESDNobVlndVpXdmRBVTMyZ3duNTlWWnNEYzRxeGQ4?=
 =?utf-8?B?aTdXY3FtZ0hwT2NoTkU5YzdhT0ZPSE5wNjZkaFZYOGplcE5sYjFFbFlDVDBt?=
 =?utf-8?B?bXhwSXlzZXBuQlpNTmRoanpPMmlyeTZTLzh2L2dGbkVLMUhSV3FoNWVzOTNP?=
 =?utf-8?B?ZUFNenY1MEpYUHdYUkdjcHFLU1lhK1l1UExOT00zUVhjVml1NHpXOE1GVWFY?=
 =?utf-8?B?Qjhxc0VkYUFGUEtoS2xZN1VTeVlQWHhHY0plTGZnNXlnZkpLQ1FtbTA5YUlF?=
 =?utf-8?B?YTg5bzlRQS9pVFNnTUpYclNBZmdKUHE1eXU0TERVYUVSUE9Ed0d3V1Qxb0p2?=
 =?utf-8?B?UGpRZ3g5MjJTb0owMW1xUWp3Z0plYTJUdTJjanBtMzNGOGZyTjdDc2k2ZHpX?=
 =?utf-8?B?NmlNNk5XT3M0NWtWazUwQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cmxjOTJmSkRyMUJQNmRBZDlkSW94dXFqN2FHYXd2SnJWVTlrOFFocVl1bHVu?=
 =?utf-8?B?Y2xhcVhTeFh4OUVvRUhvVktnWjk0Nm50WGRUSkpRYldrR2RCR3EySG9sbHhj?=
 =?utf-8?B?aEhMVEhQa1l0Z3Y2ZTg2WHhvYmZTOWZqUDZGbmo2WU9HTUl4SWFpem1QSitK?=
 =?utf-8?B?VW0yQ2UzZ1JDL010QzBjc1hYQUt1cC8wKzBWd2kyN3hhek1IMjhRZHpEd1k0?=
 =?utf-8?B?MXpMMm1SNUNNQXdzOVdVQmVWRkwzS1BVeEpMc3dVNTdBaVRoUWVOU2Naellv?=
 =?utf-8?B?ZjJNN0tvSFA1NGx4L0ZKRnU0aW54aDVPd0hFVVBzUW5WL25VOTVwR2hVZE5j?=
 =?utf-8?B?UzFuQThUM2hVY0NJN1UwMHdYU2pjbFFERVdzUmpVMUVVQ2NjVFFyMmlMUWhY?=
 =?utf-8?B?eHdJdlNWQjJrK2VaemVzWEJvTlhlSUlKOTl6eW16OVZUejdQakNVdkJVeE5a?=
 =?utf-8?B?akppZllPVW1lamFVMlNJUENMRzdlNzdXdkxZVzRxL0NKVWN5TGoxcEJ4NWpL?=
 =?utf-8?B?ME9uaGh3VjZIeXlMcEhQdWxSWmFCNkd5dTZkeEpTMDFGU0ptNTlhQkRVWWNh?=
 =?utf-8?B?VWtUcEQzc1k2aGpWTjQ0dDNHM0ZEc0xNYXBqV2piSUNNQzgvQVBRUEFBV05n?=
 =?utf-8?B?L2FrS0psbGpVdVh6Zk9mejlWTTMrUnNRMGlQcDFNOTR6Z3FJbkIyK0RYT3F3?=
 =?utf-8?B?Q0xWVnhZUGg4VVBMTmt4NjRWWjB0SzFkK1dxYVI3OW56RUpsZGEzbG1mMGVJ?=
 =?utf-8?B?MG9HWk5mWkZVaERDdWQ5QkJ5d0RyMEFCODVQY2daRE5XdWJ5Qjl5ZWJjVFlK?=
 =?utf-8?B?bGdieTNIRXVqbm5aZHRRby8xV1JLMStVZzNNT2ZSb2o5TlZqR04reS9QTDh6?=
 =?utf-8?B?U0tPamtTVENFWFlVVUFDLzYyMHJjbXQycC9SVjJOTWFzNkd2VVpBek1Sc3Mr?=
 =?utf-8?B?S3FLRDBQc2oraVRHSUZwclh2L0tBMElZMG9mVmVuUEtEc04zWXdtazlrUXZY?=
 =?utf-8?B?VzZJOHhzTXMrb1dnSTdNM2NkMHRCZThtSWJ0M1k4cXh3Ujh3dWluK0FabFVC?=
 =?utf-8?B?Tmt4a3pNUCsxcE52cXBVTWNWTHBGSE96VzBWd05KOVpNT29hRmR6dHNtUUVx?=
 =?utf-8?B?V3k4SGtUcnUvamIvaTNmOFd1T2lyODFoazFaSG1iRnV3VlVodXVMaTBteHZl?=
 =?utf-8?B?c1R4cVNIWE5TOUdCRnB2Z09BenBZcE5aQVkzeVJZeSs1ayszb3lST1RFUDBv?=
 =?utf-8?B?Y29UOXlMd3BhMVkvN1RhZGZXYldHRkgxdmtiMERzejJHeGRUYUhsUDk1WEMw?=
 =?utf-8?B?OHFTMjFBeEw0L2hsVnZ3RTJ4ZldGRUI2TGZWYjhLUGlldnhYWFU1NVd6RFhk?=
 =?utf-8?B?eDNwZ2tPUWlQSTN3ZEI3K09iNmtKNmRJVFRLRG9CcmZPTzR1a1JteWJtaVZU?=
 =?utf-8?B?cVRBcXpaMVkxWno0WUw2bFByN2pGai9RK2NwTWs0cWhVZ0hUNUcwVk1ZUkww?=
 =?utf-8?B?MTh5bjhsVGF5L3BSbFJpSlUyeUZXYnVsYkZGOUtwZWJIQ3RIUHE2S0ljeVY0?=
 =?utf-8?B?VHpxVTFiWVhIMXUxdXJuQkN4QUV3eE50WmFIR0VPNG5vZ3pVYURwN2hwclRD?=
 =?utf-8?B?VFJwUUtzNFhmaVNpblFoTENDeldPRi9EV2JYNXRYWWhPdkJyYk5wMXRYM3o1?=
 =?utf-8?B?bmk0SU16dWptY29GR2UzN3BZckRZclFrZUVkOTIwN2x2c1htZ21LQlB3RGov?=
 =?utf-8?B?VE50RzlhZ25UQXMwOEVXdGltYmNXUHdpT2ZQLy9PQjFRNXdENm9DWGxQek84?=
 =?utf-8?B?UXJWT1hyZzFFSTREeUI5T09NQ1cxOTltbm9mYU1RZ2U3OW9mZVpLejAzR09M?=
 =?utf-8?B?SG1lMXg2M2RSTk15L3pqNXNRdFBXUE91UEdEZGxGWFk3UVJPK2plZnpSaVBW?=
 =?utf-8?B?WmdVVER4MnZ1ZThjSGpER05UOTBTQmsrdk4xTGJnYWE1TkhhY2xhenBUSito?=
 =?utf-8?B?UFpoVGwrZTFHUDBSbk5ibzNkUzFTajlNUVRKUWM5QUZ4NG12QlZuaVlJQ2R2?=
 =?utf-8?B?bVZoSWN3RHpmZUpCTXpmbHUvUUhmSkVlUlA4NUU3TlRsWm4rbkJWeXJaZzRs?=
 =?utf-8?Q?8PZI=3D?=
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
	G5AchjoLnc8fCwyC1NoNaJM7WZ/GVVlQ5Fisvp/bbvTb3Q7IbsoSCZS/DCdDL3syJ/PkLWFfZRsdK72EZOVULDBfy/+BuVY4pgwD2uZljbXVJd676IIF2QxrIbHd80iS+g+/LeuuI9X5bgE3DEwXVBZcsIqZaePyoMZ6SurDzuozsBuMpLZL6JxPkyGJJpFoDsSrzyVDWDDFj3JLllF5OfouIREQiBCKjHk5LtG/sypakRbkofHgicWRbrKDfBdHhsHywz5RhKfh5s2eVoVSqLI06t+lVtQ3jhCuQhJvxK2pjKExRUUmIlNF/m7r17y86aKm1dFL28xyn1TsREwvtA+EqBvv2iRE/PBqeECKL4BIwaRdJPFC3dzrlz2WS021rZp7xN4T9nypVYfxQEdoKbE9zmD5T06iiRrKHjn7vvqxZMDvqZuF8mwQ6QtUyczVmCJ8Dwo5iPR5XMXXWapxISZWo80P4nfS1HkyrCQz+gc2yAUBJ70AJaH68ok1+npc3iRA/6CulF1s3EA3R/tXxTd7yuN2iqj8F+7SWCS+lcmoTER+kbyWBLjmRSCMH2N877+05lRP8zItU6F2KX/mF3sw3ohB2gekTO9j2atUBH//koR7bKyHJHK1t/5I8Pta
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f16853-fb38-403b-a3ce-08dc7603c95f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 23:56:21.4881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p1R6itZyci9GtKzEftXmZIYu4uCShDbR8QbAjO9O0x/70MGXiukPmrSjpd5AblnSb95bowmU3PetwFzU0OpJ8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6523

PiBPbiA1LzE2LzI0IDA5OjIxLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4gT24gNS8xNS8yNCAy
Mzo1MSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+PiAgICB2b2lkIHVmc2hjZF9maXh1cF9kZXZf
cXVpcmtzKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ID4+PiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY29uc3Qgc3RydWN0IHVmc19kZXZfcXVpcmsgKmZpeHVwcykNCj4gPj4+ICAgIHsNCj4g
Pj4+IEBAIC04Mjc4LDYgKzgzMTIsOCBAQCBzdGF0aWMgaW50IHVmc19nZXRfZGV2aWNlX2Rlc2Mo
c3RydWN0IHVmc19oYmENCj4gKmhiYSkNCj4gPj4+ICAgICAgICBpZiAoaGJhLT5leHRfaWlkX3N1
cCkNCj4gPj4+ICAgICAgICAgICAgICAgIHVmc2hjZF9leHRfaWlkX3Byb2JlKGhiYSwgZGVzY19i
dWYpOw0KPiA+Pj4NCj4gPj4+ICsgICAgIHVmc2hjZF9ydHRfc2V0KGhiYSwgZGVzY19idWYpOw0K
PiA+Pj4gKw0KPiA+Pg0KPiA+PiBXaHkgZG9lcyB0aGlzIGNhbGwgb2NjdXIgaW4gdWZzX2dldF9k
ZXZpY2VfZGVzYygpPyB1ZnNoY2RfcnR0X3NldCgpDQo+ID4+IHNldHMgYSBkZXZpY2UgcGFyYW1l
dGVyLiBTaG91bGRuJ3QgdGhpcyBjYWxsIGJlIG1vdmVkIG9uZSBsZXZlbCB1cA0KPiA+PiBpbnRv
IHVmc2hjZF9kZXZpY2VfcGFyYW1zX2luaXQoKT8NCj4gPiBCZWNhdXNlIG90aGVyd2lzZSBiRGV2
aWNlUlRUQ2FwIGlzIG5vdCBhdmFpbGFibGUuDQo+ID4gUGxlYXNlIG5vdGUgc2V2ZXJhbCBkZXZp
Y2UgY29uZmlndXJhdGlvbiBjYWxscyBpbiAgdWZzX2dldF9kZXZpY2VfZGVzYyAtIGFsbA0KPiBy
ZXF1aXJlcyBzb21lIGRldmljZSBkZXNjcmlwdG9yIGZpZWxkcy4NCj4gDQo+IFBsZWFzZSBtYWtl
IHN1cmUgdGhhdCB0aGUgZnVuY3Rpb25hbGl0eSBvZiB1ZnNfZ2V0X2RldmljZV9kZXNjKCkgYW5k
IHRoZSBuYW1lIG9mDQo+IHRoYXQgZnVuY3Rpb24gcmVtYWluIGluIHN5bmMuDQo+IA0KPiBJIHRo
aW5rIHRoYXQgYkRldmljZVJUVENhcCBpcyBhdmFpbGFibGUgaW4gdWZzaGNkX2RldmljZV9wYXJh
bXNfaW5pdCgpIGFmdGVyDQo+IHVmc19nZXRfZGV2aWNlX2Rlc2MoKSBoYXMgcmV0dXJuZWQ/DQpX
aWxsIG1ha2UgdGhlIHJlcXVpcmVkIGNoYW5nZS4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBU
aGFua3MsDQo+IA0KPiBCYXJ0Lg0K
