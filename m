Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4338B3E5EDA;
	Mon,  7 Sep 2026 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788797632; cv=fail; b=kb52/p2IiQOlr5hOgT1uXKiyzLs08bCZqfZhCBXjZIFpzjl4KfBiFmRoM81S9ltO3RkYk1uHzd2PiHy9tKpt5kby35plHU2gP0LRygldOEbMXDyo4vf7ZRECRBCAzLReRz3hzAsxOP+7zJ3WQMg9SzfC1k2XNx5VK1ItpgWyVKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788797632; c=relaxed/simple;
	bh=MLzSbtluwxoJ52AHrxkFpCYTPou5OKUR6OQUgBX7rpo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VaYYk/i5YDQ0It6/vrN5+JgFmF00A8WAKIAO1Tl6Yz9B9iHilbbaKrTbgV4Pmb1MCv88kRCx0dLqvSBxPqIYDF+tnSVsDewbTRumC3kgNXvCzLnhefnTAj2XuniV2oS7JZXvK/QD4LVN+Ru/v2tAshjLo8saNt3BJZ0/Q/Yqbk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GiZ0Gt6I; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Cy8+Zw6m; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GiZ0Gt6I";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Cy8+Zw6m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788797630; x=1820333630;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=MLzSbtluwxoJ52AHrxkFpCYTPou5OKUR6OQUgBX7rpo=;
  b=GiZ0Gt6I3wp/F2+T+5k+u5IYEhpkvA/hT1xGw3PPZGibxVrQy0ZA9Ys6
   Dm9tZe2ArwnmjzXuP+1MkY6p4wG+gxEvGhPaBlWO0nZg2ujJYaa2ghQAh
   5pF/yxpgfkKyTGEel5SplhoH7ddVSjzQXOj/sgnmYq8F5ag6+xe4jyIiF
   rZoEYLT62HTS7oeXTEAe6s8jwYJ4/Jx1GheV+lcjM5sEz2N3yhZnH5yo2
   OKKrxnEkkD43LXxUiglurrHDGAUaNeGxUp0xP9ZRJ2OFZkafejlF0RDbK
   tbA5XfG6IcUKjs6Z/svlmJ5C4NQmwZCQx1GWM61n3451wyh0MRc7ufqaH
   g==;
X-CSE-ConnectionGUID: nare6ImVQVWXbvZwA/1fQw==
X-CSE-MsgGUID: KIQEozUsR5mPOpDOyJ4Dvw==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="155132367"
Received: from mail-northcentralusazon11013033.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 00:13:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v2oBqgQzB/v54Nb72lAfUCMZmUug457FfwtkYtO358ggYnF26l5jXujgJd9Q/I3uvnO+AqSXjz9Z/kPSldWJmBQ1b8IC435O3xbAOSVBjqxqxrsMziaTXKbvSfeYRB/MPIDelKMkMAk6OVBaAW24cBuj2GPig7u9a09kIQbilnc9wrbZH/N4NpYTRbD26ficaob6pnhv2L8Zi1KkpIBGU0ks56ZDD8OimcpLKGSU822Llsa5YG4lAaJa6iEyaeRq/USdkjT7jHeiau5xjJ9zK3p5HyUlHhZyFJJHcMrZbaPq3FB5hVyz3cgbEHTYNRNXl8yhB7W3cOohjNdhx0sdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XylMGa5oaEiCZUFK9T9mNCbmsLzwnhXtEb+mfewT1tQ=;
 b=WK5LFSqoNPCAX+kByuklWqdUF+zuNWT34Lc7Csocmsh8hY3iMne5HdoVeeTLXX5SizgEH8IC8XiZtho0Jm62E4YWwjq/z8xRlUZVrDo1MDvJzn2tTJAvS/ten9344ChLPMzeu8gAhr9VfrVCdsq2JrNmVyB7GkyPOx5El8tt1+DTx47o2JHWHMN/Idyx9qp96bWMh2lHv1TWPYdRRZf/MBqAS/Inls5RYO+eykHQfXfJD8mJiIrb/QAjMIen3ZD/ozDrnHSHc9PZeZjpOBOBaepL4CM7Xun3ftsNaNy+PIVdBdBqZB4T1ILLxN/d9lD+vRZYMdOaIin1aBV5iW1rCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XylMGa5oaEiCZUFK9T9mNCbmsLzwnhXtEb+mfewT1tQ=;
 b=Cy8+Zw6m1Bxcztyr/NOvFQ9d6CLiMkOQHMCM1Z0hFnh3M+bj2HDNJL1l0c2i9+HrXpaFCnUu43n8kEDPPshrfROzjg0i5ygpmehHRbqJraiFszFhf2gNeKXyWnI1UYqNiPr7h48FnOkKK3rBAIJaTQj9PUfiuWrowYoIGMOxYhU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS3PR04MB10029.namprd04.prod.outlook.com (2603:10b6:8:38f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 16:13:43 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 16:13:43 +0000
Message-ID: <fbbde389-d040-405b-8f87-f589c4890afe@wdc.com>
Date: Mon, 7 Sep 2026 18:13:39 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 35/40] usb: storage: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-36-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-36-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS3PR04MB10029:EE_
X-MS-Office365-Filtering-Correlation-Id: d1664ca3-d2f9-405f-f622-08df0cfafd0f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|19092799006|7416014|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	Mj5P7+mJZo22QzrDMY+QDQZ08BzeM8em4YwUE9Y5eJoTB7HYwpSjzNVTuq4fhvNGkjgZs/4i7gy9MbBsdte2aymgUh/Fybc40yXb8cRKEc92RAeCi66aIXfsKurbvCHN2F9nAodQ83rA/uCDYqueyIL7btE+b6qD5LBiKHaTG18hQJVzpIjvrDwJ6hVFr6F7h1c0UM8pB+jCi0ZOM5K13/lloAn7BTZ/tuQ4ZKlLKOdXnjZfubnkWtg8DAshpwTFoqYd4q5QTIhXDe8R36o4JSCIbxvYj9sMgtEE45vUh10LkP4eEwN9B/q8lFOIvkdhXMg0FCTgdWyMFxwKP6LQSbeDRuWXsWEG99ILjLZOArlm1WtGV6uRenG97lKcNv8bsqiTkA722UJgE7s0NfRiyhfZmvrryvGbpeyts8Wws38YLRIVzUdHrTeUEpObt1g+sRfTN/v3J4fbxfX2Q0i0pXPjKnMhAOIufsORrZeql3ZPAj1wOCmFiAmtYiqR/sKVeUq8iR+Opl3z9w4aNu010yYYA1rHP0Nb93jzunvX1Dm/AJNKAAIzowsAEuLydokHh5vw/S0qRncqbRCc47HMNv0f7iNyFBTZHQgJxfdz/TTZnKLwMkV20Z5N0H54OxRV+5jv89qxJbS6zf74MahGGbT8xKYsCa+Q+BTtKTL/5rnxq9DNMKHVj/smhhIJQAAkG2FhoUSsYvKho9H7139hHg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(19092799006)(7416014)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0RzMjVINmJpUkVyMThFd0RyRlpZSFVpNDZWNXN0Y0R6MWxzSTZ2bHdaSmlt?=
 =?utf-8?B?cTB3NW9tTFZkcjRUL0F1Y3A5Q1B0UEh2N0JLcllLbkZ0OGpzY0Zja01WNnRq?=
 =?utf-8?B?R2pNN2Z6ZUhqM1p4MXhaeGtJQkRRam1STjRPdWJ6elFockk0UHJxUXFDazVo?=
 =?utf-8?B?VnZuWXZKNllPaUFMMXpYUTZtNWFQbW5vRTMzVkI1QU5rQlBBcDdsY0VrZUVN?=
 =?utf-8?B?NmQwbmNBZVFUY0lVVzBaWkxqQ2Npb1Z6RnlRbjNWVjJsSE5maFJYUTBESm5N?=
 =?utf-8?B?MEREOERzMFZBSTlrUDdLRnJUTCt2RFhXUkpqa0MzVmdXenVIU041MVBYbVdK?=
 =?utf-8?B?STRqU1dXZEtqS3BxSE9ia1ZFaVpwWkh6VFhpb1pWQk05b0NzZ3RHSmpwNTJv?=
 =?utf-8?B?czEzb2o3TjU3Ti93R2tNVWx4ZUVmSFdEOElORDQ5Q21VaFhPZTlGMm9Jdm1V?=
 =?utf-8?B?ZnV0TmFWRDgrUmYwY0I2MGRTZklabHJxK2JlSWkwSDR4cnJxRjREbzN4SVFI?=
 =?utf-8?B?cDA3eFlXU0dNUUo3aHNIVkE5dk5hZnJPYUk3dzdzcUd5L05RWFZZNmdaTW4w?=
 =?utf-8?B?SGU5L1BUSWJpZDI2N0JhSmlyTm5UREdETDVwTU9Xd0JTWnRzM1d3SSszL3F1?=
 =?utf-8?B?K3c4eC92d0Yxa1UrQ0t3SG04ZDJzTFZwQW8yZjlNU0dtZXV1NEdzZHBlT24v?=
 =?utf-8?B?WjduZ0t4bi9tVXRVS29zLzdpNjhWbDJZdlV6bVAxaVRmbjBtdEljR2dVMUE2?=
 =?utf-8?B?Y2UvNi9kbHU5cUZRRXNyNDhxSnhhcFlkdTdMMml1ZldHdFZmaWFYRDEvcDQ5?=
 =?utf-8?B?TlBsenJPeHBJNE9iNFM3SXI3VUl1OSsxSUF6dmZlcmw1VlhSMGJOOFQ4dDQ4?=
 =?utf-8?B?VG5jNXNzZ05FR01BOFE3WEhmM3hRT1hrcGRFd2Z2RktLV2tIWjFGd3ROTlYw?=
 =?utf-8?B?a2R2bVV4RVFqSnA4QWgrMDg1NWVGY1JmdllTbjh2L3JIN3RBZWpnS2x3bGNw?=
 =?utf-8?B?Y3FxRlBGRWYrWjVRVGNEWXNUTmpja2lmd3ZDbDkrZ3dQREZmeWcyc2ZyYnA1?=
 =?utf-8?B?V1hrRlBDK0RjbjhHUDNtUDFPeWFQZ2NHS1VzdmUzTjI1ZWVIbEhpbUwxSGhZ?=
 =?utf-8?B?Z1lXTjNiR1p6YkNEL3NiYm5YK3ozOHQwdHYxc2FkUmQ4SWkrUDQxWXNIclh1?=
 =?utf-8?B?WDd5K3ZoWXkyaTdyMGRvNVhicU92UVRLdkxSdzBhd1g0R2ZkbjhrRVROVmxs?=
 =?utf-8?B?a2ZsdTVCVVU1eit1cVFOejJsMU56MEtTZTExNFI0SHNpOUVPb1F6SEpKVTNS?=
 =?utf-8?B?R0lkRjZYTjdDRlpPNENqcXpCTWRrVTVlN2ZGZHNhbktEa09temE2a2loVUpD?=
 =?utf-8?B?ekhvQjJXNytZSlVOQnAvNHBTTW4vOEl5bjhkR1A5Uk5kMVdrcUZmWDMwN3lV?=
 =?utf-8?B?bEJ6S3I1NDN6bkYrcXV4cTl1NTJTTS9TOWphZ3VObnRVTE5kOC83YzJPdi9k?=
 =?utf-8?B?cUIycmpDQzZ4S3I4Y3UvWlJPUUJGcEZ5b21JcEpGeitCanpxZkFoRWFPSzQ0?=
 =?utf-8?B?Wk1LVzVyUnhzdVQ4YmNRd3FqMlhkaXRuL0did1NFK2ptejlnTml1c0NhZS8r?=
 =?utf-8?B?aHU1ay9VN25yT1dUSnRKUHFSV1llZy9XRGw5MWc4QktZSGQ3SUhhZzMrYjBm?=
 =?utf-8?B?WFd5SVpXRXlpK3ZRTjN4Ykl3dS9aWjd4V1M4ZndKT09kTnBLa3oxaWN0WEFU?=
 =?utf-8?B?RE1xb2VxeThqc1h1MDVGS1JIZ0xmUGxpMHNOaERqMm1BUHpsTFZEbS9YbHcw?=
 =?utf-8?B?OUdOR3pnTkZGRWhCR3k5aldiYmNqZEFLcVhMR1hpUW90dnkrMDdueW5kNlUv?=
 =?utf-8?B?S1VTalJoakxFVWFaTEw2L1U3R2pOYXZpZ0U0SFplNHIyR1k5R3RWcXBUN3Zy?=
 =?utf-8?B?N0tYWXRzMXRncTJETVh2SFBuQjg2R0xYRFc2RE9HV3VBUld4QThUdURraDd3?=
 =?utf-8?B?TlVMZFc0TkJob1NodTRYdDdNcmdvSmFwSGZUaTRNWXNYcHhYbTljUUZBWjYr?=
 =?utf-8?B?WmFUajBXTTJxUUc2MlEwc3NNcWRzK1IySWZ6dTNsWnJlRExsNE1vRjZzRDZE?=
 =?utf-8?B?RHFRT3JIMnpUTzYvaUs2OE92MzNkQ092MkRDRHQ3TGJUREU1VXJhcGM2TSt2?=
 =?utf-8?B?MXMzYWM5NThIZDFwYjFQTTVWRTcyVWpVei9PR1cxNDdkZ2tjZUtEWUpsZnl4?=
 =?utf-8?B?QzdnU1dHNHFxTnF3U1Rhd0N4V2RqTlF2N0I2aC9BM2Z0Y2RMR0lmeDhQTVdz?=
 =?utf-8?B?Qko3TEhRNUc3RC9OSU1VRm1HeWF0ZVpUVjVUQWdpdDBWWnRSSlRoZzNWblB0?=
 =?utf-8?Q?oaHbKy9Pwj0ZrW1Y=3D?=
X-Exchange-RoutingPolicyChecked:
	gFRfpybf5NCofPAmMB3vbw31VffBx8DabVd3c+fEUIzG1dCxUet4NVJQtkXGqz3b9qTswOHDdcRjO4JSWwxionY70VBcIM8KkAfOPQMfxKwTyTDR3ysn11o1XCqz69iDgrmOEHP2x5ZHmPpXZrLQ8odzd+ljbDgACvCkYHJMnVia+AqPG9rWvJvM88Wi3QSl2MVi3YZXxeSGI3YKSUoJVDFWWXZCHqCjgnfXiXBJucyP9n+jMGyp+ufe7jn9SQamJKpAWhifZcsWbjjQOOK1TdgQJ0W+5uOf+jcJNsF7/DKRfBAL1AlmLXr0Fd2k0DSZJ5zBhsZ5Q7ebI3JIqjawSA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EyIfY9nrXKX+GXc3TWBL4eyd2k+j1yEEid4Amg6SrZ9vWqx8smg+mCcrm4lUyFKuDP4R3dCmjA6fRAmiBFIJQoiTCaEeVc5xz3s3h+S2NrRtBjVQYOINlfSS/+den5yf51K96GWOfLdvFmkDYVnXgY55NCxHQnWR2+d36noO7c7M3cA4bLmN72iFAV+k/SXmcdeujujf9vGAf7hgl+b3Zbc7Vpr95ydtNcAZh2odt7OKDhcnoEx5W/gHxZyXMfgxUiA1ScPDZAiKFIq6xkOx5jl7aeBgpB/cnJbaqkCF7Z6Ya4Kzmxv3DGC46yzcEXBiFXXuUvP/2YMNT8RXEJgTrbDtULZ7aMFk+hLm1ZZSmJ0vSn+VUtLAqO8JSucJAG51Wv8T5cQBw6j3h2hnnISuVx1jWE6m7MuylhY6jsuS3GJ9ax0loDsCF8s2EvkjGz+eZl+BiXi0AXoaS3G8uF27CqrUtvnbdTP837kMfODRPk1/Fx/8zuA2RDK7fPqTva9EVLRp3L49L7MUEyXcBIMc6OG9SV96jdUvsHk1bHCmeTnfihtc2Qtpt3GOdjy6AHjqxsA+/46dfH9s4lP5TFGx9++y5xoJfJ7o3C665ilKk7ztojSroL32pcTHcFPHlTqr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1664ca3-d2f9-405f-f622-08df0cfafd0f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 16:13:43.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1LrrMAtTFvZZj+nZMxIkMTfvSFlkWW317ewyenG4V5m2kjaCrelFATcQg5hh9aBuvt+EFImzS6B0vZwSkcHkKxswoOad4HaYPV2lHocGDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR04MB10029

On 9/7/26 4:43 AM, Damien Le Moal wrote:
> diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
> index a50743caf083..05e138968389 100644
> --- a/drivers/usb/gadget/function/f_mass_storage.c
> +++ b/drivers/usb/gadget/function/f_mass_storage.c
> @@ -1103,9 +1103,9 @@ static int do_request_sense(struct fsg_common *common, struct fsg_buffhd *bh)
>   	 * FSG normally uses option a); enable this code to use option b).
>   	 */
>   #if 0
> -	if (curlun && curlun->unit_attention_data != SS_NO_SENSE) {
> +	if (curlun && curlun->unit_attention_data != NO_SENSE) {
>   		curlun->sense_data = curlun->unit_attention_data;
> -		curlun->unit_attention_data = SS_NO_SENSE;
> +		curlun->unit_attention_data = NO_SENSE;
>   	}
>   #endif

No sure how relevant it is to change something in a commented out block. 
Wouldn't it be better to just remove the block?

