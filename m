Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B357B44CAC6;
	Mon,  7 Sep 2026 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794762; cv=fail; b=qVdnSI6wpX0ZHNGKHulCG9Km8h8ahDcTwq/TzwuzC1kKLCLskIVoDvX4gn0iB0Qo9iABtSRYxsh2m8YmEvgMsKPo0R0EJ35ZKHQDrgISDCuzcgBU40RjKjENtNW1d77LAaN10h3lG4ndKt96KQJtp88GUmFXIxbZq5Bu7ANxUEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794762; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gl0h0K8iFBKHYXy8W5ND1bRntC8Yua7N5YvN9kEzk+tlEX6YlIYAHTe8uUlzw8rA7EBXL+sI4TUx3xT4nSIJD8mx8rhEBXB7vcl0e5dPu7eWPPazcJ8h8gQOKJJct68gUA/fEYAt+3Q4Z7GUFOBNStqIj5ml2N8lDnh05CMIVEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bZ8r0v62; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RiV09OZK; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bZ8r0v62";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RiV09OZK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788794760; x=1820330760;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=bZ8r0v62LJsLXIml1Mqq9JAfamcMQpnwRRde0APIIHArbYS0H9YaE0pG
   2pdWkSGOLGhezCY6hUmKKjjxQQF1ZRQrDrmhPv8qqy+4eGZ2QKakJq40Q
   9Z9xdzENQ2DzJ+AlYqiGbNuaKDwfmLumTG3RnOrfWli00Gm/5a2KnkAp0
   xAi7ZkRg8foiz03rUvu6Gchem0aDNZKDYh3rJP9HdKHqgIQU+gzWwJ8Wd
   Rv+oyA3FA1o2zIsNTVpHeeZwlbHpeldTBAS6PJIcDg3Wg8FRFOaQ6ln36
   wS1KUn7B/2vMWu5tYRYSuoXu1ut9LL7SFgN/LgMAHwTI7CkdEgdwFeLmL
   g==;
X-CSE-ConnectionGUID: yLYcBi81TV+1Jc6YWnAf4g==
X-CSE-MsgGUID: dSqf13NiR/uIpILAP7avPA==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153548057"
Received: from mail-westcentralusazon11010016.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 23:25:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jmMjri8ejF8VNb89JEyBXnFQAi56WTgjsAFzihsPg5ZxCUb8Ruq5CksK0l7/mkd71tT11hSOcE7het/HpWlve1oMAQtNY3A2kZkjE0Ep63AjO9d/ABaGm1vicSrihGub0y9ImlvTX5ll5owHdgHqGvFFM/R7W20NJQpcdXhYPWfVdacpAQ8BtTRj109aizSF+VCW1BKCFY1Fj5T3mqik/BNRJTWgBO0dPFgxE7U38TTy0PnSEixMIseJU8d7psENP4A/o6Ckgir0fFg04o9E18yg3K0jt44xIYG+zceNFyOEwrQ6RDqQUdNECdsyG5P4fxhLupJ8HLWWntvTTSGmMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=xYT9N0BCUUFVUqnNbj8kWlEs7LOa1zmk+ye97puD8ch66tccfrT65af1I3hVrNvwZb1JzjPpa7BzY24k9scbUr0s8aIt5Pe8B812Q9s/hElDnZTEBf5hMYE8TBINKezuVDWQ3F65W5u5S9ajn2DHHGCMWl7bhTy4OXdi0sgpUP1e8aOqxXGABdT/4VLg6Hnx90NhLFzF5nZl70/TEFWyNBGrjzM6BGWFDjtTqFgw750B46atuDd+gNbQREgJt2Yz/6m46y2d+YhxkT4KWIYH1yhaeGPVOVIi3EYVoSpnqGA4w0M6v8fyA8Zaa0RZzHtS5zgjJR7OoddpbDsI67gVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=RiV09OZKZ1clBeOKRI2wstL4YKBEiOuOb9DvafYRHZ18+naaaMU6qPJzcGZGLEjl1pIsSJ7L7ONKgSiMdLNqxw045D3lmoBVCKo18nvjCpJuji0na9z2KXfoX21gO1dxSTyy4kRybIPTwSVawVeWPpkIpCem/jsIbmzVI4wClWk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB8960.namprd04.prod.outlook.com (2603:10b6:408:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:25:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:25:56 +0000
Message-ID: <69d39f0d-37e6-4724-99c3-4ecde2854fe2@wdc.com>
Date: Mon, 7 Sep 2026 17:25:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 25/40] scsi: ps3rom: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-26-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0166.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 197687ac-1efa-415c-a43b-08df0cf4501d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|19092799006|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	lpzs2yiZS3eC8v6Ej0gh3BI8WO9wMDLWKApqlUrcfk9i4lj5gynhIRaYEahRldm5DRiX3F5ddjSMtQZZLuy1nVtnf6y2QD8+MLVggf0+rZ+RrL4LN+n+2TmYBDTrNFDjFERGGBl3NQ2n1KNJBKH+gkkpTxqz8AGNOrePqHJlFJRx0+2m/Bdgf33q7ikYiTjI79OpK1tZR9w82C96IMSx1n4drHdraC/qGmnzWgjdviBGmpzoOogNJyCdy6yg3OIY0qu3U494mYedZ42nkN0vQFU+fWULdeDGF7G2xZmnk1nyiuPIVYbVzl3CnrrEIoKgAk48b+WOFALudTmIWmUmgtfYK92wirsb7kru/lqvTn4GPEWinRz+cm265QnvVgRiirdwea+8rYwR0ZPXHT/IpKqshuVaqXpz0fXUmNmbgpTiSiKeWPbBUBOCTJ3Ezdn3KhbSYRfz3dnSm9qSHxvGIH6CVDQIOMQBZ2kWnooSFGAy6XiZ1Ma9HYHbdCbDfn9vdkBD9t2rkScTE5avmb1MEfbWeuWMIuBPakswEAHga856K9GAb2jbaxx5vz3LMz2VwlwNP/9VQQUset1vT0PCE7nbDbOESW0cTmt43A77uejdrw+Bfqm+Fyq68w46AKHl8kPR16TjAbNsrVLCHMdDODxnW5ChHBlv1lrUp6NH53i0wrsRgLe2cTCHey/ISSll7GJou1DWCgyIr9RdHPPyfg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(19092799006)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmJTZ1I0WXIyNFFjQmhBNmN3cm00Vmx4RDN5TUtCUzFXcmJOclA4OWl5VklW?=
 =?utf-8?B?a1lSaUpzVzNhaXJXRDhmMWtwTHlGNHltV1dqb3VEUkFJcVh3NXZEN3hjb29y?=
 =?utf-8?B?UUpSK2taYXhodmh2dDJsQXRtaVdFNnQ1THFESWhwQzBScXl1M1BzZlZuNkdN?=
 =?utf-8?B?TEpYUTdyUG5SaDV3VFlzaDF1VDJxZTdPcXlMTWlzaWVvZHE3Z1hqNmJlNjI5?=
 =?utf-8?B?RnhiWXVQaHRSSEJnOXJ1b2s4Z2syMzRZNlloRVpXWmZsNXl3ZHBxdFJiSFFq?=
 =?utf-8?B?a0Z0M3JMYnpZczViU09FalIvQncwQmVWdFZ4K2t6YzYzSk1aWmlPaS9Ba1Qx?=
 =?utf-8?B?cHJWWEI2UXlDNElqMzliMHMzNkY3SXhvQzlJaTcrUFNKODZpWnRKSjNTV01u?=
 =?utf-8?B?VVMvYkp5UUNRZ1Z3Y2xpTWxkbFhia2tpTXk2a3Fabzg3QytXRTdSSFlIUzBs?=
 =?utf-8?B?VWJFY2I2WG0vL3RRekRqcWptRUFmRHJPQVNic25zeWZJK2x0N3RRM0NSbmVm?=
 =?utf-8?B?LytaZWlYUmlXcnNIYXBKbFo4ekFYS1E1dmtmdm9Xa0p2K0dyQkRHTzJBUmRY?=
 =?utf-8?B?aTNrZHYvY0VLR2Z4U0M0Q0gvdVdPTHZGbFpFTHluWXVzWlFUUWVYQmNLSXdE?=
 =?utf-8?B?MUV3Vkk2VGdyNStjbU5GdVJ1eWZybDZwZVptU21LMFZPNVRDdTJhNEcrdHFN?=
 =?utf-8?B?Z1hpUWx5c21vMTlFRUlNVE54NzZwOThYZCtTOWpJK0lSbHZBUzBER2pxT2t1?=
 =?utf-8?B?Mmczbm4yb1pFWldkby9mTlI0OXRSZ0Z6OGx0b0YyL0NQZmhpSXBwR1ErNG5K?=
 =?utf-8?B?NVcybEhIZXZoZ0oyeWxHVkJROHJMbDI5aUxXVno3RlBTSS9NT0VpK081UEZq?=
 =?utf-8?B?WTR5R3JiWEsyZDZyQTlvaVFVWlJXYXBwU2tKUEkvSUtTZktKL1RONXFDczRx?=
 =?utf-8?B?ZjJQcXN1Y09scXp0T1FlaGVpRUFwV3dnenQzdWErZTFnZTNPOXBkeE42NG1j?=
 =?utf-8?B?MGhndnZhTjU4eWVkdVo3VEc0dEdQS0NVeFl1bS9mUWdOOHduZUwwVkd3ZW1i?=
 =?utf-8?B?VUpTbGlOMTY2VHo0NEJWWTR3dVRqUEUzblBHK3NQVzFSUVh4blg2NktGSHdQ?=
 =?utf-8?B?bm9FTkNqS2NtM1ZaSi9nZjgxd1dxaVpLZ3RKS01uNXFTWnJYZ0tjRTNCNTR1?=
 =?utf-8?B?QStwYW5ncjFUWUQwQ0kzY25RTFl3UnFseWJCeFBwZWtvb000ZE05d3dhaGpq?=
 =?utf-8?B?ZXdaSXBGZFp3SXRXaXBuQ0lZUzRGcWQ3RTB3K3pDeGxTVE1qSTlLNEhGYTVw?=
 =?utf-8?B?V2tNOTA1NUw0WGxpMFVIdElkeXdWRTJicG5ENXlMSE1rcTV2RXl1OE9KUG9P?=
 =?utf-8?B?S3VSZ3orZ3h0YXBqSW1iY0tPUURSTjgyRWljOXZ0OXNnKzZGckRhM2EvVjJT?=
 =?utf-8?B?SGd1TmlyZEUvWW5kRVJFbWhzdXhLaFZUQ00ybERRRTJBemxQakVvTjFHRUhC?=
 =?utf-8?B?YkVRWmQvN2g3UW8xSVIyR01xR1BYenNrSVZTUWRYYXllaWMvak93ZVRSRHVp?=
 =?utf-8?B?MmZ6TVQ0dUNET0tGL3FzRHhCK1JFVXdwa1lVa1JlMllDajRUcWhUd25VRDNG?=
 =?utf-8?B?bjdVWnd1NmQzSHIwZUdwUy8yOGpucXVhalBLdmZIVlErZVBMejJCRnp0SmI2?=
 =?utf-8?B?cU9oNkU0aUt4Z1RmWnFqWElXTzBCalJVenhuakNjbFRPVDZCTVIzN1d1Ymty?=
 =?utf-8?B?RmhWOEE3dHBZaGRYektxWGJ5WE40dU15WURYcXRNckpiQmFhb2U2U0s3aEgw?=
 =?utf-8?B?cVB0dXI4NjNzQldReFRHL3F2MHJEbWdjN29DQzladkNmTWNPQ1hVaEN0Slgr?=
 =?utf-8?B?aEFIRDZ4OUoyLzd3dXY3VW5rNnVXRm45UVZvRWxnMkxkQXJ4K28rK2hkWDB5?=
 =?utf-8?B?enRRSTNFRmYwZXQzUWJpNFpkd3JFcHk4eW1IRVp3WmJUUWpJTXVIbUsxbnV6?=
 =?utf-8?B?SXdwNXNBTlg2ZkoraUZjQTdmcVpRMm5EVVlCYnJVWUd1Q25sU0dtazZ6TkRp?=
 =?utf-8?B?SDBhb3JXVjhhMEgvNUt4ZEczU21oZ0dlTldRb0I2OCtVUmF4YWRRT3YzRFc3?=
 =?utf-8?B?d2IyZ1dzd05tQXkxcDBXSlJoZEFMc2lzZ3JRQlFOYkYvUy9tSHpkUVdxRmNY?=
 =?utf-8?B?RHdpTVhmb1ovZGFvSTYxTXhaSnB2T1hsVkN2YkJDcUFSY3ZNVmhpdnhVUE1t?=
 =?utf-8?B?Z1Z5SUFGQ1VrNmhDS09rVG5POUNhMjB2UjZ5dUFIenRkTTdRY0hGNVZyMXVL?=
 =?utf-8?B?SmE2T0NGRFh6bnBQVXNKKzVzWFJ1RTFiYVNvd0w1cGRiOVFTTkV6SkdUcUVV?=
 =?utf-8?Q?VMPUiwIUiDa05TAg=3D?=
X-Exchange-RoutingPolicyChecked:
	iYaDpjJ9u3zSyIwodQU1PqhC7SEe7/MeVBDfpHpqFzjhvxFpsP0Hdsr8RZSK4Od9WCsKlt4myjiJuPekWUVOBq8Ry6GMltxpzrTOuVJc2jDHf9iUYa+ak0s2dXKqwzxkD+4gvutYPRiT5lzVcPuRChlCZtIbjaql1Cb+Er8YpySq7QbY1LK0VJlXAqE/xREJ2AkKzyNe7cd8OjqqNGG5W3AwMnTBpeLPG6bTiDx1Sezq9E6mS6EFm3bqYxAj1qS8rqGoWz25ykz3ciDdD9O8hqGpPLNGiGCZcDUGrknTTLomRWUap+1HxYJ4finOeB42ahNT1KM2l2VscCeXy79jng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i9x1Ik2q5/9Zo5+7uxKiZmHLDhMPbfkyJ5DxHDw/b9qgbcz29bTmw71UF3Ml7Czi6kSBjI/MaHXPpuiVIlDwQew3MPtDR2G4pBgkEuIUV6TLfOj01QQSrmnvN6Oy1NMBUKTXqNnnf6D45jRQ28M4sZuoX8xwyguE7v3tA/lZ2IFuq25JUcycae7KIY877NF0KthmT8PLgKP3d2lkVLFNUy3JIrqf60NtpL8nSRnbpvmsMBpwnP2UcRypBlRTR8aLYK8KTL1TO2hDc6woU87zrFw3hIQFZkmG+smhSpgKRXMOD10rDK0dIFRWo/caoDTJ8xg15lhNkWT8yjULwYcNSOhLsGvS4Gjytya0mdwlwSWhpoMIM42IP1DU5P3nLyvMSvQpF26a0kF3bT1+YcpG2JdM3dBBbvuVoBC7eCbeEmqbtfUJ9HLuhiDbO3Bl4u4sq0h3c722SG4hm+5dSJA6KY0a7qhYf6KWKEmbb8iOjjIcGvqKpciEHibXvXf0uwhownMNS/iEidwzyqDhyTI03dAbpVUaI455NiiDkMBw4cHfnwdIBpmcnugivmfYxIgeW7AIwn7hRE8IxFe/O61K0NvZqeujSgqjEesucgGfiljdTHh0CUD/t36JkOCYCinm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 197687ac-1efa-415c-a43b-08df0cf4501d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:25:56.7903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REwwejbmpN4Pt5kx9BJsall5FDqgbaBbwtDUbXX1P8z5o585dXEwm/wz+HtxXnnjAUaLNMNxmYzVmHx9+yzVFlZskSC45DzjBhz8YzhISXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8960

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


