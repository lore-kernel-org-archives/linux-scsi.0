Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B372309B5;
	Tue, 18 Feb 2025 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739891579; cv=fail; b=R6tfkS1KbKxqR5Gznasq+8YK0WHQ8rODZRsUtpROGy0vPDAS0ns4bI5Z4mBRabBLvLpDLAGaybTL+FTl9uOia2yjZvwJa5hbYW2PLt798022UVk3673V9zC/MOQzt+sgNMsR5hVFD8F7kaVlt0cDM4TXfhyWYLSIadbUc3X/SLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739891579; c=relaxed/simple;
	bh=famPuR2tfioP0AV5clW/monBm7d+bSOVaF6YBizOMJ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IfPA4WV9h4El3nEUQQG6PSU5dEzv8OcN199SN3pv0lZYV/PheBjiPVb/k8XLFuOshlij7VgsIWiF3hyaESrPCBnpAf6afFbXnV8PaQD6SdaytCduDGXK4gVrHlyj0uIAiR66Tvji+ofF2vpnyD+60P0vG+3BoBQYge2wCjAoIAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=oz0Sye4g; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="oz0Sye4g"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1739891577; x=1771427577;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=famPuR2tfioP0AV5clW/monBm7d+bSOVaF6YBizOMJ4=;
  b=oz0Sye4gWABRfyqH5iCFdXmmq1o3RlE64vQMWVWqBuENAAyASztYvq/f
   wtSxUQNOXFWZhvzm9Tbowkt6JJ6Lvq6p/U/Z1rAj/EzwGB8Ihnn2y11je
   zeWxyHS8RleDuIqEqyuPETh3VKF0lUy10enOA1cPGENqKE5kti8qUsPz/
   UOGC9xWb14Jmc0DTWM+J4yWAamV3xGclfxglhe7ht9xJ4mp6rWET4TpJk
   Sh3+HlxHKuCLJ6dLGfK3X6pWgJKZFQSqf5NGgrlcwIUYIZNVKT+qB/9lj
   Yoy1AgaGsR/b5Ra083ReBBAGhkIRuprlKGK8XE4ip2eCmBoMpSro9zrAo
   g==;
X-CSE-ConnectionGUID: TjrtdolkRL6jOlByK1C/vw==
X-CSE-MsgGUID: maKPDfwCQf+RhaH25p8bHA==
X-IronPort-AV: E=Sophos;i="6.13,296,1732550400"; 
   d="scan'208";a="38579804"
Received: from mail-dm6nam10lp2046.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.46])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2025 23:12:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jkgthgTnjengIf8tbCKvHl0KiqNzWlxysC1zQHRoYXBDkycTq2U9SXN4x6cs8zYCI3V5Rca1XbD/7/MTpha5LwmzKv3EpQlxgu3kipOcII39AuS5k171jrL1IIWspSVx2wvk67j17eFiAd5DI1yr3JgdHcwyqEc9qcMEuhFKT0RLS0rYvl18R/Pt/DicMNWqG2erMggHs1dMhJ2MyK1ybyOX8OXDu2aYAkZI2AhgXckj16Sxz/yWNmw9BvTXfhIT67uKtLIyAyhZYtmHlPyXqZupCi9rdH/ZhGM4zxtpZCnyDuF5B4GDZoYX2qQ9VR8gXukAh6QCKRBYGJ+AkmGCVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=famPuR2tfioP0AV5clW/monBm7d+bSOVaF6YBizOMJ4=;
 b=sdnv8EeeqdJ5QR9Dq5JGwcoKFod8KG+Qa2sKlCra9mU5/CXgQIY7siqf684lLPteLSv6whynRaIpKfqErsQAhARGVSmQrUviy6sKYTUOMb/xcxdIL+y0v1QvK1e20aioAgHDlAH1F20/BK5SEc3K6nEFroI5XYSbRMM5mmAstvzrM44z58iJ091hQXCbglFCZkFymNVdCC1/Uaw3NxPaV7kYd/AjwQ9PczPluZ5CQLvuWVTg5y13zrTkpHFEfTJOczkYsnFa2zXXOxFR4i3nDmkIpZN+iAA0pjyzU620sAfTCN4BxKeS0pYiuSTVS+hbiVOMrsASrQO/OE5eO7A1PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH0PR16MB4245.namprd16.prod.outlook.com (2603:10b6:510:56::15)
 by PH0PR16MB5074.namprd16.prod.outlook.com (2603:10b6:510:16d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.20; Tue, 18 Feb
 2025 15:12:48 +0000
Received: from PH0PR16MB4245.namprd16.prod.outlook.com
 ([fe80::a5b1:875b:ec99:3121]) by PH0PR16MB4245.namprd16.prod.outlook.com
 ([fe80::a5b1:875b:ec99:3121%4]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 15:12:47 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: Bean Huo <huobean@gmail.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
	<Avi.Shchislowski@sandisk.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb command
 failed
Thread-Topic: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb
 command failed
Thread-Index: AQHbgfZ14xMAE1nYNUajsliEsNBL9rNM/h2AgAAF9oCAAAr/gIAAGYXQ
Date: Tue, 18 Feb 2025 15:12:47 +0000
Message-ID:
 <PH0PR16MB4245F16B2732AF3078DB1DC6F4FA2@PH0PR16MB4245.namprd16.prod.outlook.com>
References: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
	 <8be8c9c45d627e40e4ce3dc87c1ac83f32717e2b.camel@gmail.com>
	 <PH0PR16MB4245909AD2A1DE0EC2C26E92F4FA2@PH0PR16MB4245.namprd16.prod.outlook.com>
 <9e7cc353d2407cbde723fbbb41db5ac6cf83ef63.camel@gmail.com>
In-Reply-To: <9e7cc353d2407cbde723fbbb41db5ac6cf83ef63.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR16MB4245:EE_|PH0PR16MB5074:EE_
x-ms-office365-filtering-correlation-id: e2cbb8e1-de09-4c0b-f6b4-08dd502eb441
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z2t4QlhJZ1FlTm8weVF6Yy9wYlVkM3hlbXpHRjNGVm9mYUg2b1Q1RTdud284?=
 =?utf-8?B?Tit1eGZWQmNKY3pPRnFJR0xzWC8zZGdwMEwrNWJUM1ZRSW5mTW5WTURKZE9q?=
 =?utf-8?B?dkNLY3YvSktmU3A2UVorUzA5SnFHejNtdU9UazNtUzJicXVXTEpTOWhsbUFV?=
 =?utf-8?B?Q1d4dGZ4bUd3QnJNMERZakVYdzJCeHVrc1hOelY3VUt6VDVxZXVGdjFydFo4?=
 =?utf-8?B?bmJPV1o0aDNYdHB5QkJ2TzZYVG1KdmJodVNybkNpT0ZvNnNKeHFNSzEyQk5o?=
 =?utf-8?B?MVkyUHQ2NFdYUUlGNE5Eb2NUQitBcitoNkFsc1VXdGlnam9xRzNwS0lBTXhV?=
 =?utf-8?B?M3F4K3hua0h6aFJCeXhneFIreVRJN0t4eVVMUW5uU093NnE0U3ZFMEtWelU2?=
 =?utf-8?B?RWtzV1B2L1BXSFUzdTdxOC9IV3c1eWdHU251L3ZuUGdzaXViTUJIbjFLQjNq?=
 =?utf-8?B?V1JtQnFZRWdDNDNoZ09kb21vQS96L0tDTk1FT2JRMTMzcDRQWWFyOVlPN2s0?=
 =?utf-8?B?OFA1SWRiSk9TQXlXa0FWaFBuSGNodElQckRyYndyc09KQ09UWHoyT1FOMUIy?=
 =?utf-8?B?NTA3eHc1aDNKVHlKdW9YYkhPaVZwbzVNeFJOQlUwaVVUVVFxN3U1ejRiQWpn?=
 =?utf-8?B?WUFad3JadkZ5VFZ1YnllOU5yby9iaUlpbWljdmVJbjJWdnlqSHMrQ2lFck8y?=
 =?utf-8?B?SzNqVml6QkRqZG1GMURLYis3QTIzTmF3b09ycXFrQ2s1bzlYeGl1VkVaNWFs?=
 =?utf-8?B?K0dLMHFnYS9HaWpSQlAzTG12akhnNzN4MjlqN0E2eVFNc3NYa3JPMHc2YUc3?=
 =?utf-8?B?N0tldEhhUnVUM3JSNEZQR2V4MWh0NnNic1YyaUkyNFFrZTBuTDM1Sjc0c1BC?=
 =?utf-8?B?Qzd3emhDeEphVFp4NmppNTI1SnB1a1I5SzNERkZWVjE2d2JxQ1lZYUVxWDdo?=
 =?utf-8?B?cUkxOWk5SEFkamNQV29HdW0yaFdSS0Vpc09NMmJ1eGVKQ3ZxZW8yUEVQcmNX?=
 =?utf-8?B?U3RSN2FBdzNJV3ZIR0Y2cTByYmVySk9VeWU5TjJQdlhvL2x2QnRRVExsQTVY?=
 =?utf-8?B?RXphcFNTUW45WEovYUVKLzJsOTcyYkNQYWcvQmx0U2xFc0pXZFV4VEtva0ov?=
 =?utf-8?B?cE9BUnZNRW83SU9Qa3BBemxvU3hrVTVmSXAyTG9iWUdtYmg3OXo2WXFvUlNt?=
 =?utf-8?B?akF1RGlrQ24zTGthVENKcUNRSzhPK3ZXUUYrcU9jOU0wTU9HS1lqdlFjOU5S?=
 =?utf-8?B?dzFhQllrcEdQYWExSWd6TmRhMmJNN2g3ZllGdVRDZlFiL0JvWDBrVitJUHZu?=
 =?utf-8?B?OXhCRnlRd2ltZkNVQzVmY2I2bVRjRnA5Z3RidVdhM1VzU0ZNamk5L25BQVRs?=
 =?utf-8?B?Q0x4Y0Z0YzVqRDBaNnVKQU1zUmIzWnpvODFlcGlLcWJpMDdyS3BUUHFYTDZL?=
 =?utf-8?B?b2RvV1BXM0dvSCt3SytEempDbXVRMGIwOEZmUHhwL0pKWUc0UEhoRDhJMVlr?=
 =?utf-8?B?aWdwNjJ5SkJNdHFmZHRFbW1jMmtMdlFCNmp1OUgyWG5uRnJTRXVlaHN1OVVV?=
 =?utf-8?B?cXpYMFFqR0JTRnpFcDhnSExyOStXQVlEc2lwVlA4KzBVYlp6b0VRclVFS3RX?=
 =?utf-8?B?TUY1b05zekNXSVZRK1RoZEllZThnc2ZkYU1FcVUyK1h1K09iZDlyUzNHVVNI?=
 =?utf-8?B?ajN1dnNkS1Z0VVF5M05ybEdHSC9MV3lEdGYyVzJPMStXcmVnVWxyWmZWUmZO?=
 =?utf-8?B?OGh5TnhrUFZGT2REMVptQlhvRGIzalR3Y1lGZ2ozVXlhNU1Udkk3bmdzWmdD?=
 =?utf-8?B?NmQ0RmFCNFcrSllhMHFYL1AweTg4U2hHbG5vY2tWRXk3QVFURUc0NHZQSU8w?=
 =?utf-8?B?WjRGRnFKN2pNY29EUzJ2bThZb0RTUDJnYVcxTE5uaW52Y3RUYXhzc3NpRzBP?=
 =?utf-8?Q?QGLW9FDZLrw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR16MB4245.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Mi9kMXcxZzVkNCticWtUZXhpemZNUXJuN3pNVHE0Rk9DWm96Y2lxNEFoSENX?=
 =?utf-8?B?QU5ZQnJYZEF5Z3pQM2I4dVowekFmZ2lvODdRZDdHN250UzI0cWE5dFczQjFK?=
 =?utf-8?B?SlNOUmhyUjBTbWxjZjJhRTlMdGVhdDBJZGZPQ0Z1bWZEZU1TYm1TdFA0VHZz?=
 =?utf-8?B?Uk5aU0I3ZW95Wk1oK0JEb1hMd1lzRDI0cWxpV0VKTTJXYllTZlZ4eEZLbUFy?=
 =?utf-8?B?TkNkdC8zVU1QaXJkWDYwNHdzRUdzd3lVM3N0dHQxK0hUakxJdnhGbVJNOGx0?=
 =?utf-8?B?RWo2aFhFcUpLaHBLSlZCZFpsZi96VSt1Wjg4YjdodXlmYllra1JDRi9zQjBq?=
 =?utf-8?B?Z1l1YmdpWmhqWGNpZ0UySm5Ud2xORmJScVMvTGpoeXNMYTJsaGxXSjdhV1Zz?=
 =?utf-8?B?SUZUVjNyaGh3bXJXRmZ4MER6UzZLVUZpUHlXenh0aHZYT3hQbW5FYlExVHhY?=
 =?utf-8?B?Y1FiZkJhaDFFNFYxcGRxRGl4ZGhaN1JqSXp5QTBaZThHbDRaVjlMQ0xaRk1m?=
 =?utf-8?B?VXNpQTFWaTVUUUF6enAwZW5XK2cyOFZORkNHZTNQQTYyTDNraUZlSDd2UG9Z?=
 =?utf-8?B?QXJzSEhZeCtPYTFpbjBqK1hvZXFmaitYQ2JjamMxcDVXdXI1V2VrMzdZUVlK?=
 =?utf-8?B?WGxwa0ZVbEZEbGhoa04rVUdmbXVXb2JMbnlKVTFJYjNrWGhBR21acGZlVTZO?=
 =?utf-8?B?SlZHaGpQMGRaWnhmbjhCbTh6d3B1c3djSlY2dEU3UHVDdnBpUllTTWlJaWxr?=
 =?utf-8?B?NUJ2c2puaE5PVEpFdm1yZXJNVVdzaHJXVTZaRUVHeDczMFdSSHVEbVN3Ymth?=
 =?utf-8?B?N0xXbkFMYkZnd1lueHYrVjlTOEdNL0NCR2xTblpBWVVxcFhHTnF4SnJxUUNF?=
 =?utf-8?B?SGt5SjVHUHNzeGZLZ1FxZmwzL25ZaG55NzhCbEtLcUFoNVZSdXpGRERRV1ZR?=
 =?utf-8?B?cVpLVVl1VjAzakJwZ2t4bHA0aGZNcTloaDVVNlR3SGRjZ2tMWVlrVVJES0JD?=
 =?utf-8?B?UXIwYm5oeEZOUFhRK2hKWklqWUV1YitVc1IrUnQzc0pycEcxTkphUjI2U2hv?=
 =?utf-8?B?SzI4cUJidENVWkdHZmxOZ2dQVW1GWmtvRVRjMHJIaUxJb09IVjE0QUVRay9O?=
 =?utf-8?B?ZnM4K1ZmNktsL3Q2SlpTcmcycFRBWTk0Y1RDM21KOENPV0htRjZMNlM0VkJn?=
 =?utf-8?B?aUJvVVVsZUpzTTRoY01kWm9pZkR0ZzErWTN5NlV5OU0wdy94M2hDY2gxZzhs?=
 =?utf-8?B?TDdiUEkzR0xKRElrRkEyczB4QlRXT0MyZXY5cVJzVXVsOEVqNWN5MzRwMXhx?=
 =?utf-8?B?UGY2TmU5RXhEaVhFcSt4a2t1VXpRRFVLWVlCZFBNeVBTRmtmOUwwaTMwRG5k?=
 =?utf-8?B?ZVJaRjlldkpqSFBta0NlNUlPaGNDL0hYSHNsWmlybWs4cldCcmo5Zzl1Q004?=
 =?utf-8?B?ZUh2eDBuRmhiRTBvRVBPZnAzcisrWFNOMDJNYWZMR0tSUE5PTjRkbzM1Skw5?=
 =?utf-8?B?TFNiMDV3U0syWG9RaDc1WklvVXlhZTg4OXBIVDNyOXcyNlNsb3hkUUdlSWdP?=
 =?utf-8?B?a2s2UElRbmlJNWM5YWlyWXBWckNOZnRKNGVrK0hIakQxdXZpR2g2TWtFU0Ux?=
 =?utf-8?B?Z3hNc0RjU0M3ZWliQW1icnVUM015NDJnLzc3SW0vMnlwUHBsenpCYTNiK2Nl?=
 =?utf-8?B?cTJOaFl2Z0h4VVovd293SGpPZHB2OU9CYysySHJRRHRwVDFFSmdqWEw4K3R5?=
 =?utf-8?B?cVNwcW1WbFl3dWhWVTZHVlJLS2pEWklKcld4d0xZaTNGdE1hOGIrRVg4NW0x?=
 =?utf-8?B?UGFKSXpSbG9PclArNVNjMnB1YnVwL1NQOFExS1lFSzVTbWZNY0V6aHRZNDZ3?=
 =?utf-8?B?UFYwWk5oMFlmS09IZHhrY3ZoSFREY0UxUkxhQnYxVDVmSjQzanV3Nm1pUnVl?=
 =?utf-8?B?NGVvOG9tSk8wRjRnVHprdUZJZUZsUFREY2dlK1ZLTUYrekdjTkRiZnZkNkY0?=
 =?utf-8?B?Ym9ibElVVlh2ZFU2VFdEOW0rQWVhOEQrV3c5T2hQd01RS3RYRnBidWd3UFJk?=
 =?utf-8?B?RVhLcjlyUU8xK2VnUG9NN0x5RFRSWEpNYUdYRS8zalE0Y0d1aTNsTlRJZEtG?=
 =?utf-8?B?ZlVhaXNFT0pHZGY1c1FaSFlkcE45Y05JcjZrYk5lR3piRHJ4QndqbVVDVU5S?=
 =?utf-8?B?SWc9PQ==?=
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
	d++xv2w1kEyrIQu7kW44a+aBQ29Hmdeme2XZMBPdFa8gsoOPGKWErREon6ukMvwh7nj5MJBEaZMBQx+xZ/syYIyghV1O3uKDx84h8Kxdf8rOXEKuigdFn5Sh+0U5cBFkWLH6/UNz4wj2kGKLlpt6VztHOLTwzIDYk+obV2iwBLGXXw+bes3mFSvUmY8stN1FPnveO4zgJA5o/7U12E5ieBeF+qBsbS7e+GswkCGnnk4SUisWCsG6J/QEkDLbomNhvsNKLV777GCeO5TkMASYSFR3s5dhnq0C9JQvcaSHHsR2u+lp+W0WR+qWGaG3rh1/C3x7jgmq1U2Tr0tZoCMc2NhjQsDlWu9NnELKMv5KI+YZNLcIrkB2IgI9kKYm/SRjJpfKX30Crj+ec+7cQQy8LDh04CV/9vRtAF2bJj1vIr8nUB8DvLgG5Nq8UPuBs2+g8z+kWw5UvRzHjeUz9pRfogVODlPMPWzhA9LVh/JitZRxOqrSjXxAxG7amrrwvyCq2KRm6+hbEpiOa5YRZs1Dj3pPUQm79MIVR4QVBTqGw4AtaBfoEZc17WfzH21EjH3Y9tUYeMMASd9B/4x0DpFqFTlPoNg/cPHB94jJbEVznWLiRa9jxdZYy+vnRmaKOnwbPot3iLZ6PASgWvcishZlpQ==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR16MB4245.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2cbb8e1-de09-4c0b-f6b4-08dd502eb441
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2025 15:12:47.8874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +sm1M5urpkOJzTUmtmSPA+SiNcJmK9uRvTdwvQT0BNoIBM/QESAj3UUuCXHLRNlT2V+Ky/ImkG459emT690EOFwJqbMkyBV7MUC16Gf71RE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR16MB5074

PiANCj4gdmVyeSBzdHJhbmdlLCAgSSBkaWRuJ3QgcmVwcm9kdWNlIHRoaXMgaXNzdWUgd2l0aCB0
aGUgc2FtZSBjb21tYW5kLCBidXQgSSBzYXcNCj4gdGhlIHByb2JsZW0gam9iLT5yZXN1bHQgd2Fz
IG5vdCB1cGRhdGVkLg0KPiANCj4gDQo+IGl0IHNob3VsZCBub3QgYmUgam9iLT5yZXBseV9sZW4g
aXNzdWUsIHNpbmNlIHdlIGluaXRpYXRlZCB0aGUgbWF4X3Jlc3BvbnNlX2xlbiwNCj4gdGhlbjoN
Cj4gDQo+IGludCBsZW4gPSBtaW4oaGRyLT5tYXhfcmVzcG9uc2VfbGVuLCBqb2ItPnJlcGx5X2xl
bik7DQo+IA0KPiANCj4gY291bGQgeW91IGNoZWNrIGlmIHRoaXMgd29ya3M6DQo+IA0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzX2JzZy5jIGIvZHJpdmVycy91ZnMvY29y
ZS91ZnNfYnNnLmMgaW5kZXgNCj4gOGQ0YWQwYTNmMmNmLi45NDMzODJiMTQyY2EgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzX2JzZy5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2Nv
cmUvdWZzX2JzZy5jDQo+IEBAIC0xOTUsOSArMTk1LDkgQEAgc3RhdGljIGludCB1ZnNfYnNnX3Jl
cXVlc3Qoc3RydWN0IGJzZ19qb2IgKmpvYikNCj4gICAgICAgICBrZnJlZShidWZmKTsNCj4gICAg
ICAgICBic2dfcmVwbHktPnJlc3VsdCA9IHJldDsNCj4gICAgICAgICBqb2ItPnJlcGx5X2xlbiA9
ICFycG1iID8gc2l6ZW9mKHN0cnVjdCB1ZnNfYnNnX3JlcGx5KSA6DQo+IHNpemVvZihzdHJ1Y3Qg
dWZzX3JwbWJfcmVwbHkpOw0KPiAtICAgICAgIC8qIGNvbXBsZXRlIHRoZSBqb2IgaGVyZSBvbmx5
IGlmIG5vIGVycm9yICovDQo+IC0gICAgICAgaWYgKHJldCA9PSAwKQ0KPiAtICAgICAgICAgICAg
ICAgYnNnX2pvYl9kb25lKGpvYiwgcmV0LCBic2dfcmVwbHktDQo+ID5yZXBseV9wYXlsb2FkX3Jj
dl9sZW4pOw0KPiArDQo+ICsgICAgICAgLyogY29tcGxldGUgdGhlIGpvYiBoZXJlICovDQo+ICsg
ICAgICAgYnNnX2pvYl9kb25lKGpvYiwgcmV0LCBic2dfcmVwbHktPnJlcGx5X3BheWxvYWRfcmN2
X2xlbik7DQo+IA0KPiAgICAgICAgIHJldHVybiByZXQ7DQo+ICB9DQo+IA0KPiANCj4gS2luZCBy
ZWdhcmRzLA0KPiBCZWFuDQoNCkFsc28sIHRoaXMgY2hhbmdlIGZpeCB0aGUgY3Jhc2gsIGJ1dCB1
ZnMtdXRpbHMgZGlkbid0IGdldCB0aGUgZXJyb3IgbWVzc2FnZQ0KV2l0aCBteSBwYXRjaCB0aGUg
dG9vbCBnb3QgYW4gZXJyb3IgdmFsdWUgb2YgLTIyICgtRUlOVkFMKSwgYXMgZXhwZWN0ZWQNCg0K
UmVnYXJkcw0KQXJ0aHVyDQoNCg==
