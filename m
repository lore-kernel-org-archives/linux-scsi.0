Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B154D43B3E4;
	Mon,  7 Sep 2026 15:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788795160; cv=fail; b=A94FpvXZ9THWQvQ1mlRrJzgz1qTIK1Snn2Xc7h3HJ6sRgAstIMFKeFy/lafuAV2oWd1deBn0Zx+fUv20ACmAQCm4MRTEN4Nu9S03Yei+YiH/BCwI2uVFtg8Z08Doep4NrU1tGwx9zMxPLPQ85+H1lG+J5JoXo4nYzKGq1iP0nSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788795160; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rVx163x+KhGG/uzc6ew2OFDaPOcbOTfBx6a/9diC7pBzEGcyhcilRuyhIk0+d3G1/A7/cZJmZ+7Pu8ODrTZScLbK1ZLF0XNx10Mz0mYcExx2nYahf9pRwfuGs6E+CrtSC2f2b0QXz/HUfWSAicHp/kfSBSe2NzTCXWM2xiW9WKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AikUdDc0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Hn0sLQQK; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AikUdDc0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Hn0sLQQK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788795158; x=1820331158;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=AikUdDc0KDgJvTmfVNucB8rpuSaXnYXCLB527DvkDGeST7K4r4L8wYzY
   qH4di3UAeFOyme7eFIt8c6hrxUAugzNYuvKlg20tZsJSiSIPdWwywX45H
   Oi7rwu1f8fPH0x9ObmKuItsiW8J1tYPuY8fsTB4vcSfgNHdsQUzRuERs5
   ecAey5v/TuxnihKmdXTHN0Oc1WLdsjcywMq00UiVq8LW1mn1usbn9fmM0
   ZSYSzk+osKrDhOVGVDviuYgxur89WlCh8Udb49cxBpt0gqUr0RaB/lsFp
   nlD121sUhey0Jf+/JHVkvhEFeJJeu2cuhdtmQpE7m+9rhu8HIFOYyazt+
   Q==;
X-CSE-ConnectionGUID: w7A6YCXsTe2YrmshS7tJDQ==
X-CSE-MsgGUID: dbaYZrE6RhWVfZm9pzhVgw==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153548312"
Received: from mail-westus2azon11010036.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.36])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:32:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JvDxxM3PmNh8uWO8d28W7L60BfAkkgDqfyQVpgQgNL8lVTuVK+UV8Ee65ilu8Sz4aKxWUakqHzvuYlsHk0vt9aMZS48IYsx0o2sAFHf0QNxDyyDTC707cvNe3Y8tbNHgreydMEHlstzNr1JM7xrdleI1fKJL72GwLX3x3ZJQTVuBPum+fF0RHQ3CjEtgjcJ6P17JzFjVowcyrJVujPwuPBmxiDa1O16oOz/XltzCQUMjDLkh4CCfUcaXcm83IKJwZEUCNx6LSO8JX8ZMKafSWNHUIRhzWvfILVD0Nv/nSvx1N5lk1GU23+dN3zEPgQiNy2ZUcO06d2/6XgYq2B/THw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=c9scomo7gMxlGU4SZMCqLh6BpT37sHOZ08wAvpyr5DBWMc7lM1ROgGgIgK7x1QygM9NDDtnk7/Tf5k2Yuw86cxNWeGPgoaiTbNLYalO+LqCWx35tdXrc0864Sx4JSNBN0j+g7c0ktoWJwFer3XdHl4oAMfuly/1Aw1NvTxt5zjWHTen6OaFA4N3ddTurro7RszCvvyy5vcVSFSUYVdAwPJt9cYeDsvBsqRFeLejX7PAVPu/pttIcthjFKoF20+DZPr2e3zw+f+XzryH1i9AebUSj42s4OIywUCoSW/7/0gB2RSzYnu6PBwMhq1CJIepSIOFeyJs9RZSvUURXbNEp5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Hn0sLQQKRVN+cavHOMpkTe0PVBWJJu1s16TdzKD4nY5Ua3IiwwMT2RcZtyFcaRybDexTSNL+IC+/xSvQiosbMJAiYH98+4zGKiS+kmMjvLQ2aLWsKKzLFZ32PeOCRHbmQgjxuXz7Dlo/59k8p84daGEQCpl9AJBQVVqHGUm15RM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB8960.namprd04.prod.outlook.com (2603:10b6:408:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:32:35 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:32:35 +0000
Message-ID: <d6528543-d2a9-43cc-8376-7e10d24d8da9@wdc.com>
Date: Mon, 7 Sep 2026 17:32:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense
 codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-31-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0210.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: eb81879c-0920-4e85-a9d1-08df0cf53da1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|19092799006|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	1PxoXLUXbEvR1LtUAY90k8PfUxK/79wdLsj9xc39GecvZylqYO2/jDKEFOzzMitqOnFHdtINpd9BwevOdTZgOgRCO/jOdrPa82LSvabwuG1v/GpTnvj8KXn7SiG4oF9SUfLd+C7q1TDcTsPV2gMzCEjgkDjmaxA2w1dh9Y+3BcasEqAjphC8RDuONlUvUroaQ1Aa6I8QUE4ZafXTxRiy5Qa4Hvq966doZyg+0WdyK0XH+xbb8K4qqx0OOPQ2wTg+UXKnzOUu/V6wpk3DQ6eBWtOTBCi3Gh/7/NiPCJbFKZpkr1Wbhc3bzWAz+6t4cZTCTeyLK/L2025FXMhXiXYuYLJhtagbTTpDeaPPh5WvBhH5RLqRDGOffbWMnX9BGQpGZMTvxw5x9u1sdA5KHOC7koZ9JmYzTQ9bjIaUXsG7KTJKTesiEppcWcOIQsvpCdtNYFX1jN2JI37V3XElpf2S+9r39JVJMrLXQpaU8F7GJlbP9zXedNLlcfuHMycvpeg4avF/kgNSMeVXATUHfdA4WMySiWXUVsarhipJMyp0sv3lQMr5iwdf4EmZyelgI9GDqdTTKWGGmMCq74jPXQ6ciwjHOt+FEWg2hpE+4cwxOe09AaFgRDutmC6al+QT6M8S/aOH/KVgCw4DdSb8TJjtoQGRRog0xAPGfBN68T6LrLXcKr2I89LDEx12y9ZPHffi35KB+q0e9U7VRU+f6fIgwg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(19092799006)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEpncTlnMjlpZVdPVGIvQUtlM1IxQVlBVURja1QzT0xINElJYy9SVFI2WDFS?=
 =?utf-8?B?cVJYdE1CWkd3MnZIdlFBdjk0T3VJenpvQ0RoaHk1eFVGN3lwTzlySDg2SHl0?=
 =?utf-8?B?Ulc0ZDlxZTg2MEhWUUlMT3Z6N1orbDBneks5QmZEMzhDSEJ5eStYTXpYNXFJ?=
 =?utf-8?B?WTFHLzhhdnlVRCtjWTVRMzRMLzVGOEhQUEo1VHVVU0VaZzl3UkNLWGFSaGxH?=
 =?utf-8?B?UTREZXp1bkJ4VkJ1M3BFUHR3OG5iR3FCdmxxejJGTVFiek00WWY4Tm9jQVZu?=
 =?utf-8?B?UlJMUmI2VGF2azQrU1MvTkJzYjkwbk5kcTVoRy8wUEJkWVpCMzNFb1NQeUdD?=
 =?utf-8?B?dmMydTdXRmJQNW1MMTc0cnJ3dUx2a0NZUkNFQklVUGJnazFSamthR0MrVHk1?=
 =?utf-8?B?N2p2UTV5aVVtRkUxaXNva1MzRmwwRDRFbVprQjI3dC9LTVpCTWljMUVFaUU0?=
 =?utf-8?B?a3lrYzdQZE1iSTB5Tk5kcDJzSHZjVlFCQ3ZUMk9aTGREc0NHZmNMUldraG16?=
 =?utf-8?B?T3NUQTYwM1R3SWRsNmVGTXlRb3FhaUVzWjNFSnhzSzBOL3JqMzhZUnMwRFB3?=
 =?utf-8?B?VmdwNllwdHU4V0loeDRkNkREWVZnN1RmWGx3VmlTOFNuNXV2WDRGNjNDTTkx?=
 =?utf-8?B?eGszRkE2Q1h3aEVxUmZkc1p2K3J4VnNQT3lEQS9KejJwOWc1dkIzQzFybVUy?=
 =?utf-8?B?YjFUQXFiTkhBTU1xaHczc3ZrZE5TZXhqUjNKd0hFUk5yK1l3SDFQd1M4KzNO?=
 =?utf-8?B?enRkOGo2VDhzQjZubFdsVFZEOFN6bnY5Y3pXK29XNXIrTzlyU1FrOFlrZnZP?=
 =?utf-8?B?dGxhRFAvMmVlSy9EZmVwcGZtOUwyNDZGZVVMREgyQTh3WjI5NTIrWVVpNDc3?=
 =?utf-8?B?dlVldFdKMFpSdGF0ZUN0aDFxRE9tUERKZ0N2c1Ivby9RK0g5aEZPb0UrMklC?=
 =?utf-8?B?UlVaK2tuOHhEaFQyM2ZsWEp5dGRZY3BmcGZCRjRBbGtseUhhYnh4ZnBDaTRV?=
 =?utf-8?B?bUQ4N21ia294bXRzLzYyQ043MEh0TlJXK0Y5MGlML3JGUWtaSnNGZEFEYXVa?=
 =?utf-8?B?M1RWRDh1NnluM0dSakltR29tcUMyVzVLMW5MZVg2SFltWU9ZeHRGZmdzS041?=
 =?utf-8?B?ZzNiSnIxRWJML0hnaWN0eXZJMkpPd3g4WXI5bU5kQXQ3YXBvcGhrWFhobTMy?=
 =?utf-8?B?SzlkeWgzeFhJdVFDNlZlMDdKZ1dOTGNXVWZpK0JMN2UxTTdQakdaUVJ0c3dU?=
 =?utf-8?B?djVYRjRiNHRQdUFqaXRpdkdvMXh6bG1zT2FJMVZnc28wNkUwOXlmSE9NM3hn?=
 =?utf-8?B?S2FjeTgzRXplTS9jYW9hZW9HU09BNy9jUkMyZ3V3LzdobjBMM2ZHajEwaWxU?=
 =?utf-8?B?VC9pZ1VNS2dJY3kxdFlGMFhZdUZiNkFlZEpzMy9hSXlaZHlrYTdMMW1IRnpl?=
 =?utf-8?B?OWhMeEdGSWhaNzFkZ3hYd1pCc20rb2xCR3ZnNHJjcUZadklrODQ0cE55ZGpo?=
 =?utf-8?B?V2FLWFF0NmI2TzNpMEVDM1VPSWFjZHZIMVI4cEMxMW8yTDhhWnRIMktjeEEy?=
 =?utf-8?B?dGxkUkFqNG9TbWdJcSsrajdUVHBNS0JlVDRqU2FMMDZNOHZnT3VWa3k4dlZp?=
 =?utf-8?B?dWdMNlVySmI2emdvT29sRkx3UG50czdidGxMWGZQMUl0bkdzMXZIN0pLUUV1?=
 =?utf-8?B?T1hUcDROd3ZHZ3JPY2s1VXYrRUdsOTNpcWtnNk9UblVickFubDROeHRlUEJy?=
 =?utf-8?B?aUg4Mm1QVStpVUd5RnVSRkpiSFVXRTBNRnQ4QzNaQnBIR0VldUZGbjZzcTBT?=
 =?utf-8?B?M1Z2d1V5Z255enJ3QUgyVG1kaUpYbHVPd2w3UTROZVRiNThqTW5QeU9weWdp?=
 =?utf-8?B?NC94M1dCayttQlA4S1ZERGhZakZDeXBzUHBlUU1zMWw0QW5HY0pDbFVVazky?=
 =?utf-8?B?NzV1a1BEeGVoNmpqNy9Wek93TmdkeXh5VDhHaWpkR2JDZWhrS3dkQlFtN1R2?=
 =?utf-8?B?NkZGQ0w5Tko0NktBT0ZFRzhRYUFobVpUU0ZYL3h3WTcyMjYyQmpXbzkwN2Vm?=
 =?utf-8?B?bCtWVm9JSzQrMEJyVnh2M2xjd0s2dTFucDNxSTlVR2VSL0tQVTk1KzJSZFNV?=
 =?utf-8?B?V0xnMlZSTElkZkJISDlqWnI4OWFGdlFoQ1JaS3grczJ1WjZhK2JLOXI0Y2hJ?=
 =?utf-8?B?SnpOdWI1b2pDUGJPcSt0VkhoR3lWcklmZzZLdnBac2dTYzZ3ak5qRVdKYWdR?=
 =?utf-8?B?OXZzWmg1dFZOZmp6d1lCTWdpZHFmd1J6YXppMHo1amp0M2dQWFRQWThrU04z?=
 =?utf-8?B?SGw0RE84Z2l2bFV4MWxPYXJnTHFma293WXRyK0F0TXFYajRXWjNuTmhJeDVy?=
 =?utf-8?Q?KGpaXO3la/e1MyHA=3D?=
X-Exchange-RoutingPolicyChecked:
	I5G4QvC/Ikp/HlblMs9TVAnile7ArJOjFjmpjnepkOQLwuODk7UHOCvR4yjeF9IBuDIF60u5XP5ApXeLdzrVV6S0EwnZ0bRb2OCumqX/5QVgkg6BlAiaSjaJSVNUNome0fMvICMAgMGp3DLIJsJkhwJ1L1YdUb4X2A0RMlbdRA0r9pklN/IpJIHrlN4Vld9DQO0G443UjqRqzePB1xEk66sKjakUqp5xTlS2yGoBgpIENoFILHsnAUYAp6rPQ1XZeDRzRvJFE9/d0x5Do/2XydKyWy0B4iJKUKDaUxVARWQQVISbQmB9x0AjkwNhxrv069fpHoUw0Vavag06UUOmpA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ampa7kYZuDh1OO31d/ekjET3GJvVq1TE/x1FitFJ+UKh/LcK7gFWT0A1CI1wqypGuI16D56zP0c0BwJ8T96a166zszCIkZSyO9clIZDVkJ/XDHVX0iU9SChkdQsxN6GkVaIHVnbhCjb1hu1PVkkLfBpll8BLyjEjmm5q53U09lZU+/RyF6zChmG5snQXEle/pPi9r6cMw4gK3BpBCn1voeaBBgGKcSz2s0IGE6JeG1lqArTIwn3rwCixo/cje0qOwpHnb3hLMSWwQf/POj6gqQ5XcLJ5ZJJ64PmZhMjx0Hf9MVTF6cUs5DH7np2OlbuIIYFa4TOBUm0RQn8BEPmAu+Ftt5MFO1eVUHIc7BAcUH8hi72hDpHkA9Y6hh69P8eG1bEfaHILEXlUXS5B328pUcdFmhPDf+bV4m71plsiwqqj3AOh7xG+tVlNM73ewkYNBPuLsO4V1L6zMlSPyVPwVZaFGiGHMo3sFpW5qxq6PMlpjcenSJGk3dLi2BqlR2oaalEAubhWJQcvMjRSLeH0/rbqAI655k1wzQTp8YtmL+BSnljljyc650UlEbggCyU00NAAxvfV5+Fm8qukAGLdme/lxiHEh3r5O8IrZqRQArmseuq/aGK+tm0OHLC5IAeF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb81879c-0920-4e85-a9d1-08df0cf53da1
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:32:35.2446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DnL1Pz8HlFeaEETyojA485esqj2075zPB8U0UPbM0C0ZviIPa8AcsUPoxFQaRAH1dtOXDJwxiwz8PGOmgqIA/A6IcBQroiIH1Ss5lpdaYj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8960

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


