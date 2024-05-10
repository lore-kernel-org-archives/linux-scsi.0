Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DECE13B787;
	Fri, 10 May 2024 04:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715313624; cv=fail; b=HJJi1laTQkJEPU1DX9Wb1MPErhtXPcIFyI0kpCudZ6aJqG28h8QgcwnSdDhJXg7IOr/GB1E71HfuBRw7PJ/ks0lQ/zoO/UHoqv5XFYZHeazW3J8zFd34s/OLXcDooJXbJAdKocmoJNCaJt5FAcWrtQEPnjXhB2CigZ7qg8tanAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715313624; c=relaxed/simple;
	bh=3i4g5tMcLMJ4BT4ZRhegLraOFp7PW8QaimblvxP9DtQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rG+9T/NYkwa/7BIiE5Rl2eiC0CpVKfJKIJ8u8TZkLg3ebd7jdY4UIKKEM4hnVsSGsAT9I1JX6q1FiCWjk3VUPedQ7foVKTIWbQekC8uCBzadoT5elCs1rU1PXoq0jnfqrAZWFIVFu+pPqzcWgQzI2Fzkt4egm4mdXgtcjSLt5os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pvH7QIAR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XvqY4/r1; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pvH7QIAR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XvqY4/r1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715313622; x=1746849622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3i4g5tMcLMJ4BT4ZRhegLraOFp7PW8QaimblvxP9DtQ=;
  b=pvH7QIARBH0/1aXVX6jQ7p8iWLcx0YWbMM2v5fj2e/kwl2vsoSSgoyVV
   ZtnNcx9yBmGZFzDTlIngye73MOQ6ee8P/sVZTGZkw8XYbY+x75OhmghKU
   CQjNULFSCNPwRwDt6b+B/54ZLw1swy18O8RoQ35yTSIJ337J6NzoS05aF
   HuCJUOZyd5FTBseumqmMgdtJpUPw2tqP1hdNWDpRu6qxPM3jHl5iNm1Gi
   PrXPKhlbzCzXlVN92udfUNLqXt2aDZ23rI2Fe+5/1/rBrZuRRkAK3PoCr
   BvwKYJFPw7ktTTCNqQK6A6N5cCvnunoDAbzrgcZbOK+Ttmvh8g5Iax6uy
   Q==;
X-CSE-ConnectionGUID: +1C0/l8RTkaIGrzv5mOPCA==
X-CSE-MsgGUID: akYP4/O2RWWws/OJqo5bow==
X-IronPort-AV: E=Sophos;i="6.08,149,1712592000"; 
   d="scan'208";a="15766066"
Received: from mail-sn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
  by ob1.hgst.iphmx.com with ESMTP; 10 May 2024 12:00:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9hNYiZcEfpUd2OVzHhB4i7viIGG/4RcJuf901QX4Y4jJpNH6Pf+cLD9HIlkrpojTabeHopwfskbI7OZVW9LlEVa/ZH+dx0wgjkbZ3CpsZS3yZn0LiCfwyNtX7SuXHxBLcToX+zPpkIjaGRFXtibTembk1jgyWF1O9Knfegk2uj4SLC3M9aS4uD/oZVl3CJ7F0UIbHwnWjF/dr3PaSxtKsi2BCrYLPFAYg6+49KyzavFfMa+vF1ywM5E1XKNsSrfHlmCRkzz6Du5sO8o5s8EgmM7YRW/+MgkMzH2z5h885iW54xgZXAj0nHg64TOaJZvV7yGJuqXHYWUEzEjbgXvBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3i4g5tMcLMJ4BT4ZRhegLraOFp7PW8QaimblvxP9DtQ=;
 b=laJBVQq2VVTnDCmccopS9HxOHw14smk/4+wOB9Tu5T/xq/rhK26yOJlCDCVFpZaL4bHprLLvE3HPQWFqW1qpOeRB2SfdvSApUJT9MIjNNSLWXjSN93Bu77wfBT/bC2pcJDahy6WFsyu3XtKCs9dZwgse2Ls+AAkDnM5dWGfXrMPJPQHoWJEI86vj+PWh8CWo17Li3N35qtD9g7lJHwv/Aqc+tiyf3NJHYMz3oPosSs4ccSDWEoUEBw/hhHBxqHMW38vxTwa0VzG8tknbSbS++vOt6CXWvrL2YsfA+dUok72lTaNAHkiVlmLVrMnyccmy0HY4Qm4JJtwcrS2aD8a0qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3i4g5tMcLMJ4BT4ZRhegLraOFp7PW8QaimblvxP9DtQ=;
 b=XvqY4/r1h6DIPwKHzcitfAPFc2QdVScv2x9NW+o28UYBQpHme0aMDCf4AK1ngT13yiV+ZyrFg6evQ5MJuSRLcLYg906zjIuGmkow2CJQraUlDfCkvUzUHD4qhGx7syo7gO5yE87ik7mwzV0lRyikX5I+dx7FMcHewhqwiQz3E+c=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7423.namprd04.prod.outlook.com (2603:10b6:a03:29c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.49; Fri, 10 May 2024 04:00:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7544.048; Fri, 10 May 2024
 04:00:09 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bean Huo <huobean@gmail.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHanU3naXbfPalq8kifk3TPwmTFrLGNkBQAgAJQ9hA=
Date: Fri, 10 May 2024 04:00:09 +0000
Message-ID:
 <DM6PR04MB657511CB925E59650AB1A4C6FCE72@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240503113429.7220-1-avri.altman@wdc.com>
 <e00686432d2aa09880f801eecadbb2bdf6d23573.camel@gmail.com>
In-Reply-To: <e00686432d2aa09880f801eecadbb2bdf6d23573.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB7423:EE_
x-ms-office365-filtering-correlation-id: e85a14c0-0899-43d8-9771-08dc70a5afa6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?RGJyVVJLdGZRL1I2ekZBNVZRcDV5Z1k5aUJTVzEySWpPa0RvZTIxUUM1ZFI0?=
 =?utf-8?B?OUdCWVd6U0cyV25rSS9neUI1ZFZ1ZGU2SWdDWDVBQVdQNnlVZkxoa1BudVRE?=
 =?utf-8?B?R2hFTUZYMHU0NnZHYmwwczBTRHlZb2swQXhoOUNNck9BcDBWbVVNbzgvdkpS?=
 =?utf-8?B?THNTSDRGUERIdkk0b2xRdUZjd080cXFKUUtRY3pRa29MN1d2VzB5MVJoaUpG?=
 =?utf-8?B?ZDhXQ2tGY1ovT0xFRVNoOVRnNEJ1cCtkNmM1Z0V1UzRJTkJNdjVhLzRwVFB3?=
 =?utf-8?B?S2Z4bHhNcU9Pb2VkbVBhd1ArZ0tGeDBNeEorSjJqV21mS3hFa3QxV01adjFi?=
 =?utf-8?B?MzBiYnAyNTEzbGowZnN2OVZHRm1iL1NWVWZsandVWGdKbDE0NVE4VUkzYnNi?=
 =?utf-8?B?K1hLWWpEVVpXUERWaytwbGlRLzhhNFFmNk84WnVYSG1VNzZuV2t5OGcwT3hB?=
 =?utf-8?B?Nk5zSmFKU3hvRnRvdlByM0l4K2hSUGFKM2plVnZwVWE0b20zMnRINmxWT29h?=
 =?utf-8?B?dXAxZUl0a1h2aHkvbnhCeHNHdUVyOXdqQW5kV2VmbjVDWHlvV2E3ZjI2bVZL?=
 =?utf-8?B?TlM1ZDdWcklPOTlLN2tCNXk5M0l4eEs0RFRZbC9tYjRBZjZZUWtXbnYycWlQ?=
 =?utf-8?B?bzFXWUpDanN6Z0hOSnNZLzZ3Y3lQd1lvVTgxWGdQNDM5aHFFTWx1MzVQU2p2?=
 =?utf-8?B?Zi9vTGlGbm0zSXlOcm9MYkxoeDFSZHBTekZ6c210YTlvZkFHdklCS3Z0OUFk?=
 =?utf-8?B?SDQ4ckRSSmFVNWtKc3ZZcDBMSXNNSlhZT1lwLzZ2WEZlTlpNOUxiVmRRUVc2?=
 =?utf-8?B?SlNjdkFLN2EzZ1NhOHpXU00vd2ZmQ3B1Y1VqaExxNWh1RzFGcXo5NkNWN1J3?=
 =?utf-8?B?L1ZSRWNGSVRYMnhCdUFscDZwd2E4c05oY2k1T0hvVVlvK3JsODNqWkFaRm5P?=
 =?utf-8?B?L1ZCdmZoNENzbEJ2aEVXUm9qWUZyUGVrME1pemJadjBkdzFlSUVGanpuME0v?=
 =?utf-8?B?VjFJa2FEeVJrUGd4MkMrSmZYLzVVek5XYmNSZnBlV3U0NEdMSS91YlRjcXNW?=
 =?utf-8?B?RUJQOE9Vd3RLRHMwOElHWFN1MFo2bHNYZnk0eW4vL2RKdHVESUtHTW5RNkc2?=
 =?utf-8?B?amR4QU4zSlN6eW9DcFA4SVoxamd2R3EzREVKWTFQRTZlSm15ZGVQd1RMdERO?=
 =?utf-8?B?LzZuYmZNNjl2dElhWkhFRWVJV0JlelJ5OHp6TDYrYnhjeVN5YVY1SnIxbFJV?=
 =?utf-8?B?L1IvU2EyWUxwMHpOM3JUVEpPZG1EVSs4cHI3VGw1eUJmcUVrTk54eWZOMVIy?=
 =?utf-8?B?K005YUMvZ05QcHN3V3JEdFREaFU0RkhOUkluQWdESEh2TGh6dkJ5RFFab29o?=
 =?utf-8?B?MjhrY2t3WjJCUnVXTmNjT0tRQ3JSK3EzTUFMeVkvZ3RjQUZMZnViWUV5UjlD?=
 =?utf-8?B?WVNSekh6L1l1VlBkaFFaQ2dlZzhXVUcvOEU5TUtNTzcxV29IaXA5V090UXg0?=
 =?utf-8?B?a1VYZGxQSnd0WTlXeTVPd3Y3azFXQk9vYS91VkVFYWIyTGFmNkxhUk5mSHB5?=
 =?utf-8?B?T1pwaUtTT04wcWU2OTRMOGJRRzVsTDlkbWozSHJUMEV0bkxPYlp2ZE9za1R0?=
 =?utf-8?B?ZW9rWTdSV1ZXT09aeW5Hc0xJY0lXZTM5cWZBQ1QzNlhpd3c0WUpXWkF2NHRT?=
 =?utf-8?B?RkJyQytheE5pbTdCblhqYjBGVDhiR3krNGgrdkE0WW0yeEE0NVV1SnZlQjhn?=
 =?utf-8?B?NjVTSHZLYkgrbEtxQy9RbXF1TXRZbnYyZitGOWh5VWt1RUIxeXYyYUpqSWw5?=
 =?utf-8?B?ZHhIQnlFcm9jWTNZNkVZZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TVdDRHV5dW8rN1JGQkl6aTJNVW5RRmhxaHh5VW10LzZ2cnJZTTNkTkFGbXN5?=
 =?utf-8?B?RmduOXJqNWRTeVEzZURWMWZjSVAvZDVYeEFaVFZodU9TUGdSTGNkbjdrMU5H?=
 =?utf-8?B?cnVaVmJUeFhkU0U1QzNpK3cwL2FvaWpYdGZZUE1BbW91QnJjS2NvYTR1OHN1?=
 =?utf-8?B?L2JiNlFPQzBOSmFwYmVVbU5sZlFCN1lsSWNTY0JqeGsvTXBUN2hRVG9KVW9l?=
 =?utf-8?B?a29HbkFWUHdZT29rM3ZrLzVxY0tna1ZoTkM3Z0h0YkNpc0NwSE5VWkJ2V2dj?=
 =?utf-8?B?bUhUSHFOTDVHMXJQYW9SSzZ1M2V6Z05vMmdVa3dlZjFtMVNqc2t1cVhxWkFL?=
 =?utf-8?B?N1k1OTNPSlV5c2xPNjlDYkFKcEdKV3V5N0MzS0ZmZExYOWZyZ3FZQklobFEx?=
 =?utf-8?B?bGN0YW13QkVTZVpoTFZoUWNZcDNDL0lQYU52ZkV5ZjRaNEQrcnZINWFNTk1n?=
 =?utf-8?B?Y1dyL1VSTTFDZDdqREtIQUxMTVl4ZXh0ZFJUWWgwQ3E4Y0JnL1h0NHFKUWZk?=
 =?utf-8?B?MUdIcUk1YzhkOXQvdHBraFpsajZ2ZXd1dEpZNlJpV2orcWtjalpLRWRJTytS?=
 =?utf-8?B?cjdKRk5DbHc0cEJUd3FWbmNUemsxQ3VUdnBNeHA2eDllUmhoMFRLcVcwb1B2?=
 =?utf-8?B?OXZhemZPRXpJby9JTjh1U3BadzQ0bGFpbStablFVOWFtMHNjcm1sZnVicHZu?=
 =?utf-8?B?WjJ3N2FKMlliaHRYeVhEM284UVpJcUF3eDZXTGlPTkZyTWRTS1YyYU44Vjg2?=
 =?utf-8?B?ZEFWVjc3eWtmaVFaMlF4WjFMc3RGMTVueHpmZlYxdDVMT3VwdUR6NnBoZTVG?=
 =?utf-8?B?QzhKOXd5eVZsZlliOFlITW50aG85U09La1NCd005UXZZallFNytIRkUwODZ4?=
 =?utf-8?B?ZHNQSkJUUVFleFRzbTVITHgvN0V4ODlRWnJjZjdPS3dNY0RnMGdRNWJvSFNl?=
 =?utf-8?B?QkgwZlNQcGZ5eklyNnZBdm8xdExPWWpwQXduOFI5YzB6c1JYbzZING8xczNF?=
 =?utf-8?B?YlNvYWhJY2hLSXR0NUhIWWVyYVNTU1NHR1Y2Umc2bUVqNFZWYU1sdnNUSGhS?=
 =?utf-8?B?YzNkS245V2NwVWNTZEJJdTRNa2F4TWpQYTVHcW4rcDBGS0l0OHplZjczbEM4?=
 =?utf-8?B?QVVnRS9xZVcydUE1K1VxL3VZZ1Z6cGZCOEdOcGhVY0lRV0RDNnlQOGpwME1I?=
 =?utf-8?B?K2hkZEtITGNKNTFyd2xmaHY2VXR1TjNkV3plVjRPZlFuck11OXNuVzYxMDFG?=
 =?utf-8?B?Q1QxVEFxNXJwdE9nQUJHb3VQaGN5M1RQdVY0Y2gyK1BCK1hXd2NuR0lmLzJO?=
 =?utf-8?B?L2lydHRmUSt4dnE4Ly9pTkJ6bjkxengzRnlyNU15QzJpbUVPOExoTjg5aTZu?=
 =?utf-8?B?aGk1OGdSYkd5R2NlYzhUeStNMzRpYzBWcGoyeEhqNnNtVXp2Q2dqU24yZWJ6?=
 =?utf-8?B?VjAxMzFKelYzWHBIR0dVM1RFYW1VL2MxUFVxOHNwb09Ra05NL3E4VGlsWFpB?=
 =?utf-8?B?QWZObmtXM3RsUno1aWk0ZWUzRXZsSUVFZkVodTVUQy9RdGhId0NJcWtsU245?=
 =?utf-8?B?TUFRYzhSQWM5UVB5RU9HQ3F2bEJWelpqK2thQmlJL2JrQm54VUZnMkFUYUJQ?=
 =?utf-8?B?WGlrdmhQbllMWGNsV2xySWRxZk42a25kV21QNFZXakhpQnJhK0VTQWtDQmVM?=
 =?utf-8?B?K20wbmN5OWpuRHBYMDZIL3c3ZU5QeVZEcDJ2TUsxc0xST1dDL21PSHd0cm9t?=
 =?utf-8?B?SElNQnVIeDh0Q001USswT0E1MHRxcDhHMFhOdERCZGJUWFpiaFNIeUx4eGhI?=
 =?utf-8?B?VjdwUmRHaDgzYnNMNkpQb3NSM0Q2WnlTTHQ1cHBVWHhoRUppaXMxZUh3bWta?=
 =?utf-8?B?MmgybW94QjUwQ2FqcW15WXhCMStPNTQzVXRVN1YwZENrbHBjV0g2akdyQkVV?=
 =?utf-8?B?QW0rdnhIazZRU1Y1bEErYzhQbDlkQy8zTTdyd01kdktqWVJBdDgyd2s1bXRQ?=
 =?utf-8?B?MWRWbDl0RmRZaXl5K2VwYkxJd1hSZW5uMjk5ZGtXRjhsU1VIMUlMRE1VTUNz?=
 =?utf-8?B?d1h5MjdSNkNTYmNOdThMZlVVbVpOdUpRZ3k4N2lCMndjcVNkdDI0U0RPVmYz?=
 =?utf-8?B?UTRzMU1TTTlhWVY3TnpLUDNVcDlWb1VoQ2czS0pmV211clE4MFYzcnozRnh3?=
 =?utf-8?Q?xDAwCqJZQ6xKjpcEHSL6EWBUlj1slsurSqUf70GrSh4K?=
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
	n5EQF80/WaoAgnSTTTNoZsrmizp8MqC5lFEv2S0obinWjl4nZBtOdB80qwIJrUCmLO/WFfZYBG5KVqLnRJlN3vyvQpKAR2AYf+ccHgKjDkJOFENRK8Umzcc+Jk10UCh0ThjmpfIl9WR75s7GnBMJcMf9nYLIn4lQY9SdI7Ln+LGMw+CbioSajpIMCQr4FnTgqMJDk2fCR/OVC4yRMEeL3oQ3wf3z4C7qyZDLV3TAx+S+2iILZimQVoKtl48MMlzP8EAOcZZDo7UFdOF4e7/29NJ7sNM+Nm842a28rd8eK6dQxZR1HG+NRzOqSUH6NIeofFujNvY7gyrwjGLcBCKjkfVPxgtYzU6PRS2gb4izD1CCmb2RMOMh4A1Fw9YZzFwIMVavkzWk93e7+z6PJ5JzDMrZJm6fxH/5016HehiclvJ+bxbkCJyj+q+sU2XgPS6C4jnCQ36fv9UDGKWeiq6dxTXlR3oRiJeK4Z73EvKgkI9jYjqneNstE/P3v5DKODOnsZOmDzDn2HDwERtobVnbZtsEDDotwfkA8SVMTgWyktEXj2x8odgWTyKSkL1tTpIpV0L+kCUe4wiGoWx5uLlUKq1X8nJXJvgpmpNEQz+wTRGrWKuJ6LaxCnqHKbCYAixd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85a14c0-0899-43d8-9771-08dc70a5afa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2024 04:00:09.8018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8wy6b1GXu8GssrfGVt+MobfIWbswp44qpaIBk//22WsJ6fTw1zq48+VOVEMDGPaJkt0QLRmdvHCYGG7KdJkzww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7423

PiBPbiBGcmksIDIwMjQtMDUtMDMgYXQgMTQ6MzQgKzAzMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0K
PiA+IFVGUzQuMCwgYW5kIHNwZWNpZmljYWxseSBnZWFyIDUgY2hhbmdlcyB0aGlzLCBhbmQgcmVx
dWlyZXMgdGhlIGRldmljZQ0KPiA+IHRvIGJlIG1vcmUgYXR0ZW50aXZlLiAgVGhpcyBkb2Vzbid0
IGNvbWUgZnJlZSAtIHRoZSBkZXZpY2UgaGFzIHRvDQo+ID4gYWxsb2NhdGUgbW9yZSByZXNvdXJj
ZXMgdG8gdGhhdCBlbmQsIGJ1dCB0aGUgc2VxdWVudGlhbCB3cml0ZQ0KPiA+IHBlcmZvcm1hbmNl
IGltcHJvdmVtZW50IGlzIHNpZ25pZmljYW50LiBFYXJseSBtZWFzdXJlbWVudHMgc2hvd3MgMjUl
DQo+ID4gZ2FpbiB3aGVuIG1vdmluZyBmcm9tIHJ0dCAyIHRvIDkuIFRoZXJlZm9yZSwgc2V0IGJN
YXhOdW1PZlJUVCB0byBiZQ0KPiA+IG1pbihiRGV2aWNlUlRUQ2FwLCBOT1JUVCkgYXMgVUZTSENJ
IGV4cGVjdHMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRt
YW5Ad2RjLmNvbT4NCj4gDQo+IA0KPiBBdnJpLA0KPiANCj4gSSB3YXMgc3RpbGwgY3VyaW91cyBh
Ym91dCB0aGlzIDI1JSBnYWluLCBzbyBJIHdpbGwgdGFrZSBhIGxvb2suIEl0IHdvdWxkIGJlIGdy
ZWF0IGlmDQo+IHlvdSBjb3VsZCBzaGFyZSBtb3JlIGluZm9ybWF0aW9uIGFib3V0IHRoaXMuDQpU
aGFua3MuDQpUaG9zZSBhcmUganVzdCBmcm9tIGVhcmx5IG1lYXN1cmVtZW50cy4NCkJ1dCBpdCBw
ZXJmZWN0bHkgbWFrZXMgc2Vuc2UgdG8gbWU6IFRoZSBydHQgdXBpdSB3b3JrcyBsaWtlIFRveW90
YSdzIGthbmJhbiBjYXJkcy4NCkFuZCBpbiBnZWFyIDUgLSB0aGVyZSBpc24ndCBlbm91Z2ggY2Fy
ZHMuLi4NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gDQo+IA0KPiBSZXZpZXdlZC1ieTogQmVhbiBI
dW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IA0KDQo=
