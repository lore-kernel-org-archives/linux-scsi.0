Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94754EC661;
	Mon,  7 Sep 2026 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788790452; cv=fail; b=Fg56hDDEf9G2WW9EIP5cYHB8p7HOH561m21LUzELdIruswoadLm6J/Swccx20LHshMg6/jWjZdrogXN8fFezF2JxVHhdd3vEHKePq+SSwolCfKW1cnrxJ/16PaSWxosr//R1W5oHr1KUqr4dqpyq58uh9ww4cnUS59ODIK1zZdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788790452; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vr6prFNtKbn/e05sZR/uCkrEQ26891WN4YfuoYwZkpH2Nig+cX794tb62zaSIJKY3G4L8wZD3J6ChKzRKrorfnY5u7uNlU1KjwRTYKpqBKdGRFOs4QIppI1SD2iIzVQDm2CNoO9SdCldpQp7o0Ud0R1oQjbrUyJR/gRl1vABLRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Pdc5qsiB; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FfCafNti; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Pdc5qsiB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FfCafNti"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788790451; x=1820326451;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Pdc5qsiBtOgD+LiVlAkhHKwSxFjexKDdgpzjyHbwtVRRfDaP8BPaWoGF
   uWSkspMWAxXqx/xAlUUP3DkNMC/hDXsDPWeNGQJiwLW9O5cAXetd/i8/r
   c2txIvcc04/FuGlUWAcsRdsbhOGQe+nHsh7AgKTebIANT6+1ZyL1nYZQz
   mwTZAqwEo78Sd0wwu3SW10bAcl6EjqLWw1847c76s47OAiBbyiUX3fMBA
   XKvNFchkwxUQWBt5W5ReL2qqGdMtfnhFMChz8HOI90Jc1PAtgFqRllqLS
   mDvgSZuQcEIpyDF8jC4hKgTaU7Lu6ijcUBah9Iqb5cmmZxcUqPls+H6a9
   w==;
X-CSE-ConnectionGUID: Vo8szh+sTj+eBqkEiB19iQ==
X-CSE-MsgGUID: ljAjyIQIRuOMuvcDMegXFQ==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="155127028"
Received: from mail-westcentralusazon11013018.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.18])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:14:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xnx01lY88d2xxZLUbZK3n6DYn1pVo2rBJrzP1RImnuU4fM9xqSpy5qrCPDtU9mUiQMHqKKU78i1SQypGSAusb6wSpxhDsRHQn15jeqpYkSPDcXWEwhbC6mlHBoQBinPLEguHCTcb1aHVsNsFNh3UhJPyfHtZ1/cE8G6y5YSGUZAkyGMsVg/beYznhzrfAngLDVJaP64Hig0ZMXc4MujRm+jXuvMPMhO6QkWqYV7dqTdL8SCz1KJxkrRu8wB7HzE3uHZm2FJaX+muaiwjJ8ZJdYtPKmkqF7GK8ScZNx25dkzNrljeVd1NLsOgyXyK6dSWlEsNNe1msPkC2Zbg3zZd+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=UGIJ2vDpecDf9KH0Yfwv9fjhcEhXr721GtZXc1c8krFN6XiFBmUmzYljS95rJFddjalNIRbPyVYQbx758F7+nie2nHhIIey6UmCBEjIS9xFF+x8flkltGhJLwV24ZsFQA9XQ5SYUaByjJ+opGEcdXps4+eP6e6Zsf5uHuWFWCM5umEBdSzhoXXlMC9fZkJqpTzxATY4M0tCAD32E+XdM8i/ROa+MHbzW07go8kVKgoijpM2SYr5o3BagFFgDYH2ZjPYveriBaPxjvtDp/d0+kKQ4+NFUwXV/HSvB99zvIFfzeMEzYDjyl9Vm+T1MF7Io3rYGCH/sQgmuwAmQhWk2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=FfCafNtidTfVJgAmO6FwLmYt/P4CVgvx/tH2sISTsyKsCHO41tZEVR27I0wyl3uDhfOugnSm4WmVTwYQdCZ2DLxOuOKWo6qcz8PbqdxkEgHScWQbENIU9kLR00b5cVzXT+/wtITdl1peK0S566lwU4IYGcNUfxPOOMqWpyLtdBk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV4PPF5EC0DFE00.namprd04.prod.outlook.com (2603:10b6:40f:fc02::90d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:14:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:14:02 +0000
Message-ID: <cb82237b-5db7-4648-96cc-f0289eafa2c9@wdc.com>
Date: Mon, 7 Sep 2026 16:13:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/40] scsi: device_handlers: emc: use 16-bits defined
 sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-16-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV4PPF5EC0DFE00:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c87e79f-09de-4ceb-8b76-08df0cea44a2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|19092799006|921020|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yhsGZN6LCewV/Y37g8wRiBZpK8RWok8AqMR1b7jhahNJYsbRtYQ4Wz75MIsIBdNKXxJIauxllp3EBT8gCVlrZTD+V6iH6zEemuJEnA5Eab43Cbnn6sxDmZMOyQuus88WlVMzVhBJzAKGzpR1wL0FfP4y/lSlqkO/6K7Pktk4sXEslwmfpSBMVmZGCqNhSHdSHb+tns/oQiZP4dVzo62uFfd+aF9zv5/EeBWRGSi3/i83rkRjf2WGtaRnt6nSb85ZJ1hNAzVYTAa9YZP0xNWLiFKEJiSSOFz5kSM1E0/+KQ10UJr6Yhm7iGDD3qNSTHCj33bZ+E/+2r0Hisxq0rViSnLXQXzirU9aEN7swu2MUbuVpOgjnd8woA/H/v6f4ABZi7cnyUzcMd+EO6yW6vKZ3U2Mqan43rgDwI8qX0w+l3L1pVBlHZ30g5T2GFnFrdMqjuRAvWBEwcsyAlLn1l8DjQ+FE7jxg1pTUL+LFHrF4fbv/gfiOGH8bmghCBdM+QUpQ0k08PnwZUVtqW0mSyE7Psy+15uGIAOjBqClWG/Z6jbVDEClJZTphna8OY+y/iBy1X/T7gcR/EhrXUyEdg8ClxWNfMx1EGH5lHJAAZ8/TYNuoVCv89LFJuflZB63evavqB2QJJe8bJmr8iT2lghtJIGouGOGrg/T127OdoBf93l1tmDbnMin8KI8epxc7sX2TyRXtq6Rqn8VU7f50bjMcQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(19092799006)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WCtJc0p3TTdOdTE0QllTejUva3p0QUVEWFdFaDEybTVDMDNHVU5XamJoZjFD?=
 =?utf-8?B?OFhZblBiZmxzQnpIdW5kYWwzek9jQXdERGlrUjNicGUwNXhyOUs5cnlSQkU3?=
 =?utf-8?B?bWxycUgvRzl4VUlKSTJPU0o5OFBDVjlVM0xVQnl1NTVJNEVWbkdGcmRpUGNz?=
 =?utf-8?B?SXlpcGNVWVpKa1Q5MjV0ZDRjK0tzeEJnRzlWSzl5TWVIM09WcGZGby9TQVZJ?=
 =?utf-8?B?RU56Ym5YU1p1SHJjdWdQQUdyNXdTMzBYNHd6SFBhLzRCVFRHUHpkRVRpaG1O?=
 =?utf-8?B?RXJOa1VMQzhFeVBoY1BzaTRaWUR3ZzU0MFdZa21CQUJKSmNXaU5vbUVjejV2?=
 =?utf-8?B?TUJEM3IySCtaeklaUGR5d0ZldDFySndwcEd5c3Y3MTVKZ2RaUTNmc2tHakhL?=
 =?utf-8?B?akg0Q0JFeVM1UEQzT2M2RzZXRHVTWDRuVnBjWGFkTXU5akNyTkVPQmVEMENz?=
 =?utf-8?B?em1zaWdjOTIvWWkyMjNtMEhvUVYwRXFvc0VzU3FYZXBnMlk3N2ZZTzJ4WHhJ?=
 =?utf-8?B?NW5NZEM5clVaeVVFRUt4TWtlN25IemduUUI0SUNZYUpYbjliU24xZEpWSHNl?=
 =?utf-8?B?U0ZxUFFzRk5Wc1pJbFlQSWlCQkh3UjNVRlpubW5sdmpxZUtmcGtyUlRaUVVv?=
 =?utf-8?B?WldVa2JWSVhmNFpJOWhpeHdUVllybWY3amg3emtrZjFRZmdXNThCMXdNTHV3?=
 =?utf-8?B?eThKK1R5cDNUV0Z4d1NMbTlGWkxJU21tZWZsbUEzQWhJd1pBSDZYYkNvNHY5?=
 =?utf-8?B?WWxxQzdTbWYwdjNqc1hDR21wU000clc5QURRditLblUwSDYyV1JRNXZYK0pr?=
 =?utf-8?B?K1pQT1lMSzJKVVlmZFpNdmpNcnpwNUE2NHhQTTBvYldpbjVFOFhnWXpHZjA2?=
 =?utf-8?B?Mkx6VjYwUHVnZWNaOFVNbllKZG94OVlFRGRHOExTVlhTemdheFlPOGs4N1JV?=
 =?utf-8?B?aHdqMjEzRCtjWlAwNG8wdzJiaUM3ZlY1NHF2Um53NE1UTmplZEw1WThEdVpN?=
 =?utf-8?B?YnZZcUd4S1R1c3RNTmpVTUh4VjU3eVV4T0ZCc3FzbENWdEhlRTRWaHlQK3N4?=
 =?utf-8?B?a1ArSjBoMnNiWUdHbi8zaDFJNUl1QmNUc1o5T0FyTmthSk54bEVVNjJUaDNF?=
 =?utf-8?B?UVdRUEdSSkpRbnpJRHY5NWdxaHFzSFJpMjRQUUNMUzNycWY0UG11Vmo3WThB?=
 =?utf-8?B?L3RMWmZhMjU0Z0dSK0FtZDdzUWxKVndzSWd0TTVraFl2d1d5eVdnR3hFOWND?=
 =?utf-8?B?MTd1Z2N1S3IrbkYvbmRVYXY1c3pNVUFLWDRyNG41VGhjb0hUckRES2VIdGhX?=
 =?utf-8?B?L1BtN0JOVkkraCtPNllXbW1qM2lwd1FwdUpjZXU2TmpXM2RCMDdWbURuaGor?=
 =?utf-8?B?ZTRmZmR6VCsrdUsxZzZBd2R5dGlWeUlTeHlLOXV2bmFsYkVIam9aRGthaXAw?=
 =?utf-8?B?YVF6V09VTTlZYzdMNXA0MFBxU0NOcEVhT0k1RFhxVUFINkZmWm9DakJvaUta?=
 =?utf-8?B?SEpYQW12T0ZRR05UcW01RlNXeTVSZ25uNWFuN3Q5cDlrMWdUZ3h0d1pIT3Rw?=
 =?utf-8?B?VmpucEwrYUVneTFTN0lLN2RzUmlJU3c1V21YTm9nNUErU2s4VkhZbDRNcDdB?=
 =?utf-8?B?aFRsT3NvT2NZdmY0UkkzV0k3dXJldjZab1N1YmxuaFJTVlFwVVNTOU1MNmtq?=
 =?utf-8?B?UllhRGcxa0tuT1FleWV0M2lVUzkyVzhPdE1YVk00emxrYUZ3ZENRNk5TMTUz?=
 =?utf-8?B?ZjA2cFNrNUNYOVREeWdTSFUxalkxdW9hQWVrVDV6WVdDVklUYUxidzVIYlZE?=
 =?utf-8?B?Q1hqa05MYXYxVVAxMC9qbThPZUZzNGdPZ0FuVExtdTU2NWdLcDVxMmJCTlJE?=
 =?utf-8?B?ZWpCOUt0T1lHSzYzeUVnRER5eUorZE85OEZZRTA1SVg4b1lTTGppTEp1MzhT?=
 =?utf-8?B?TUV0d0wvbmhRSHNhUzQwVmNQTFF4SVk0bW9vTE9NZEVOQXZhZzNsRFc1SDNR?=
 =?utf-8?B?NWZuTjk3MG5KT2puSmtvaHRsZTljV3Z3eWpnaFhVQnZ6ZGcyc0JKbEp5ZWJQ?=
 =?utf-8?B?TDYrYVZIOW5GWDlML1N1TGZEalphdENEZXg1S211d3k3MjB6bkxINlBza0tH?=
 =?utf-8?B?Nm8vMWtvMnV2SjZ3cUw0NDk3L24xa1BXdWFXQ0xXZzA1L2k3WUVHK3Y1NGQz?=
 =?utf-8?B?cFlwWGpQMjhvRXY0Z0FoLzJPSVI2ZzZORHY5bmsvMEZnTTFEVjlkRGlOSlJn?=
 =?utf-8?B?QkJlMXNhUDdBWSt6aGJMZW9CcVlITjM2d0l6WHdEcXk3QVRUV3hpU3VSRHZ5?=
 =?utf-8?B?aFZCZm1JT3cweTdPa3BMUlpsbXJMNFhUSTloWkhQT25Oc2ZIdENrbU9xZXAv?=
 =?utf-8?Q?dLQuXimbO2kKGb7w=3D?=
X-Exchange-RoutingPolicyChecked:
	pjyGkyVCy49SloIF7BEnpPTINP8NLa52NuVv6Rh4WiGl1nTjiprDP9dvvL+2Xe41/BKC7j0xwgsvVRIuwT7k0qP63ow9XZzJyF8kaRG6m6xb0EyXZkNZT6Uq1s2SK0MqpsIKHYmApdn8XqKNEaVzylQ4Sc+ziORalVpaq14CW8jy0XRjTZkTLIsVoNHMrB3Z7R4qKRj8r8cCuxo18Vg2YFAshdEHu+Je2zI6aCMqiGiurVhlSlNgHYk6pn0QZB4vNwe43Pr5kX3JfiGOKnt/SSB3GLqzDiOy0Q/S5p1BOKDYWOgH+qlMuVe1msONFAsf8nEh2dC5iZk8kjpbTFMlsQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gu3VT8dkUqIJZF5vyYIGS7sPtGJSlcaNNhmPtEdHvbxngefjsWfv0uWNKzCj5jj7VhGt/4twjRb6FZJpHOl6PBwzFhwMafVNK0IFNvxbu+5USpG/2i1esEL7tmvnHZ2NusmsU3mGYu2nwiHZAIMnchqXwFvIx48pErWyRuLMr1iKyU1jjJPhwCSYH0m9BHneqoVR7/rh9Q0kbQrIaj7cvQKPvCAALFvEsA6saFJRNEC2mSxBd7SjOrNw0miO3jNONvDc1l20liSUlmnsstK4jjL1CX5b5PMMBBfOZD7qLW61fjtTzqYGwYC59QiyknQxKr4if9HBCQDEmlMVF3P8vcxbRWIVKNipI0s0xS3yA/SPxczstgCqiRkSVixsqh3X8yu4x0lHjvMH6/CD1lEX3wST8R+wygkZtfY3w3hE0XXE0JnHEQXWs3fVhI+eXuOLkowIzx+hXBcX9suboNWnPO0rxMwVbAzLiw0ne98w13FEKjIkpbbTPDEmoY2CxLl7FQd+fn0fAVD3JqSWTfr5icQaGGRO9iYlNzladu7cQb6jdnU4eRlinDezN/Gs0ntkZtact3HCGUkw02xXfz75BEqfqP5vMsCTlH3kSLiDEQZTYYnVvXiLd20F86C8tNzx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c87e79f-09de-4ceb-8b76-08df0cea44a2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:14:02.5626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIa456rXqW8vVNNQAV7HDwMT2yclXgAZgxuc4nqScgy8f2b3bBC3YDoF52xdoyO8QEIEWuhHkbg4dutAfPWN2wXpMsUHKSJfFlIQzBEQrWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PPF5EC0DFE00

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

