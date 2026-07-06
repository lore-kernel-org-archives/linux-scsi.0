Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074E414DDD;
	Mon,  6 Jul 2026 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783353598; cv=fail; b=bhAJ5HC3z41Fz29rMtzPVnz07Otj6B61aAz9GbIAleS/QegcH9k26kHHyhqK30/0Lpb+W7cJeWZKsktzpquEIFGILsQ6zRy73u2G5oV0ifwZZ76iIJG5sT8CzqO0lRptnh6Mur2JIobTEjSs5r7xaAXze3x1QXmKqS4FR+ZpxzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783353598; c=relaxed/simple;
	bh=6CopWH6T6GKBFdHaO9X5IJf+9Goq0pkuXAuw++PZX5o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OyjKUqCbUpD6sxWKIA7wqSyAhjnz8JYqMLGWLj7EcDXdS7TIkfwsnIwEZ56GbFMhYtUNLrKItBvsOmtuN5I/C3NeaItQzAfxO8FnLWzzME5ggTLlCeRXvV8RW/aQaH5HOZqMdwCT53K9AIolDJq0IZLXwedbnp+uS9RUQwS5lkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P7wi5ntZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dBt2DIiQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P7wi5ntZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dBt2DIiQ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666EjZpg1138933;
	Mon, 6 Jul 2026 15:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0ZcWTa+ojg5Am+teoG/sB0bv3HbESp8QfeKRDHKeW1w=; b=
	P7wi5ntZPtS/9A/bNkIfKJkW+U9wILtI8C6niImR1NRPmtRtC+BpBc2djmWjma11
	PMV5jPmtgNpTG7BsQe+G1FJ3Shl5/bCGMm3yMKp+v9iAHyFY7LdfClGeGUhLk02N
	m89Q2lXJHdoZeI5wO6M+GfePFviaaRsRM5JvfbxClixzbcN33X8isr5W0RS/rH3O
	oGNOvP/dzsdcb9UjILZI8rzy1Q4BDVF1ivYFchhL2T15Ricy+1NR9Am+9VGd8/mO
	qjZF413YgmqYHggZEd0e8eGo+YSaf4OnQLWKlBGEnrZgA7I2ReG8kgRkj2f5SxqO
	8t73qQ7BNDW1rNfsov9wxQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rs1c0vd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:59:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666FwYaD037738;
	Mon, 6 Jul 2026 15:59:54 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmpafjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:59:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tcPM6PUA1PRFAwjAbu+qW6aw4fIsfJ8vUpy3uij7Hj/FnoAPynFw5/+3lZZDFLR8vo8xrkJt9xvWnhromGk0tGRlMOTqa+tRFlhgOqAP66KfB0cfzfmv1lnTNSxSFxD3EuLHUvH+mY3l4WCzbcOcatV3hEHyAmRSxgnpHIrO8qT4aFaZkTZDhycXLgYz0M/F4qLYIqua6oQAxpzQCMJEObOyV8lHrmIcloKBNBC6lLbrKVWewdGGKfgNAAsdU5qxmq0lw7LHIjhtpe0pHmy7uYodnGKCBcPSfx0afzK93ndKQF9JM9EvSGvJY5hg0ITWebd5759X8RRoybP+d95vhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZcWTa+ojg5Am+teoG/sB0bv3HbESp8QfeKRDHKeW1w=;
 b=bluelsBqmmz88ctfjj/dGt6pKlb+8ldPb4P+uHF4t8X60MPyTrOJajcukL6/rEYGGAyWuTfivn7rdaAHikTnrWrHLuwrOwWs+WgL/gPiFL1HKFoHy3N3rwoapZ7F6AsrzX1iiEGDlHrEO3wXkdN9HD/GZvVZ8k9Aoo56951TMl2xR5fk/RGlgBT+S1Kpz7BbpBI7yAcDaO3oB7rWyWCqpRYmPM5sXTqxWtzXZkGSxeTvqxiiXczyKcP/4O3efdNv7CqNKVx7yQkF3nyqM8+MjKJE5wWXZqxqu6avvkYJ5+TXokzQy0kohpAF46UIOIg6XROnCLiM1k4zGSJMIrgpGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZcWTa+ojg5Am+teoG/sB0bv3HbESp8QfeKRDHKeW1w=;
 b=dBt2DIiQXZr2ibLSfRoxnyOKB6FDI1dGYVhJ6/IyKgWDVNIGEeMQ2F9CQNncZcxqTj3nB4Mz0NzXib2B81Ax5fq/W45KB0HDzmrRmPN6NbdhBmZ06LofzVqa88jlduAwzP6n8vafTMY+UkuD506eiVGXq+oCSNhpIZBVSa8W/88=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ2PR10MB6991.namprd10.prod.outlook.com (2603:10b6:a03:4ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 15:59:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:59:51 +0000
Message-ID: <160fb6e2-99c1-4673-a2fb-42894e97178d@oracle.com>
Date: Mon, 6 Jul 2026 16:59:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/17] scsi: sd: add mpath_queue_depth dev attribute
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-18-john.g.garry@oracle.com>
 <20260703125702.9604B1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703125702.9604B1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0449.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ2PR10MB6991:EE_
X-MS-Office365-Filtering-Correlation-Id: 24d3aa94-56cd-4c1d-ff1d-08dedb779c8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|4143699003|6133799003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	9wt8aJdwk54MUBbQCGwNvYGM9gJQ3ial1N8Srpbz5IedjPmdQnnMAGJE5AiDfeLU/lMqtI0w/l9DcRImda2cIG/55iVGhddpzH3iamfbCgD4kpRlyrCHsJ5HIw0/TC/l3Dr5hkwoUfBmwgdSwqqybColl4yiKPv8/vBoYzyDhkUXTqjVx/eJiXUHTUZeCeBOg2pelowz5eaF01cvFISYQ9jiTgdwY8WXELZKf6dkTwIkjrTkPdg58YmCZnMr9jeeV9g8dlblFk71GEsQGrIdlG8Z7lYJRGvhkcsEIdE6rK4BJin1Mf8kqKylWhuLwbuRWBmfgsWUfWyPHsIg8ae3zKFRO8Sb+0vd5A5DgKVvkZ+RvEfyps+0O4MA5nwl9T+tAB9bCQ9bp+5DCaBR9acscXTigZ0uDnT0mmA3oCl7qCIMEzHpTuxX19SeGHCpkox/iTlbL12oVnf47RGQWW4jaBTmSu3VsFeW5DBCLuDezLisuWzWW7ys5zpuPXPlnw8Q066W8871wBx7W7qxft435zcxli+CMa6xV47WkJLrK6UGKXpnG9aQ9zhYjFgpXT3wDsWvXNZLDK+yeDH4XS2igKP8fP0mGXNpDQIutWOIFIjhqDQkgUfJXZpfj1BWPc1+mwdy6T7KZzSQtJdpKxFgom3wAfuib2Jd3SZSgwA9HME=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(4143699003)(6133799003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkhSV1JxUGZ4czJJanRjMkJ1V25RSWNKUllrY1ZaRHZ3ajkzZVc3MUhrM0Yy?=
 =?utf-8?B?TzZZWGw0Rmg5ZGl5M2FQaGpIZXc1cEJ6RnhXU1dHa0phTkNycDZiTGNFS2pV?=
 =?utf-8?B?VmhKUjRnMndxOE9sbFkyYnZxaHVlb1RiM1pDNDVwQlpWTEx3NXptZUt2dmRt?=
 =?utf-8?B?WDRld3lEQ3c1WlpSUVA1TEhSYjhTaVVVc3Q4YW56YzhwUk5OSEVTNWVTRW9p?=
 =?utf-8?B?TU5EQmV6cW1ITGpUcGorS0VDNzNvWU05MUY4RC9Xbk5LRm15L3hlaFpLanhX?=
 =?utf-8?B?NWpzWFUvRExva3psdks1amo4UUgrcVJqZDBzYi9EMnFqRm00U3g1SldHVkJ0?=
 =?utf-8?B?K0VDcU8yeGFlTXJtZXpGdFVXZmZIbkEwUVcvUlhyV3V0WnR3R2ttdmcwSTBj?=
 =?utf-8?B?SWc4K3llN09mVzErK3c4d1ZJbWJjQ2tyN0M4ZzE0WlJ0ejhOcDRXTEhIWm5H?=
 =?utf-8?B?V1lYa1FXQW9DcndacUlGTm14U2NjSkpQWmdic1gyZFgydU9nWFVDNE1wbTR2?=
 =?utf-8?B?M3NYcXdPUzFGZm96bCtUd205MTNNOEVwSGUrbXJiUDdNNUNFZWtLRGdyRWNz?=
 =?utf-8?B?ZTFyVkhBeWwxVE9LK2dPTHBPeGxVQmxZL1lZWmEzeEVQeW1Md1I5TWtoKzRQ?=
 =?utf-8?B?M1RINFNacHk4Q3B2QUlncXhuOUpLWE9jSklsZ29EVlJHVEUrQll5ekt5VU9P?=
 =?utf-8?B?SVlTbXNxWDh2Snpkem5wWWI0eHdHekVxMk9GT05nak1uMmNERkhobkNYOVAw?=
 =?utf-8?B?MVJoSEllNXMzQUNUZ2hNblNpTTdjb2RrZU02cW9DeE5oM3Vka283bHY5TjFD?=
 =?utf-8?B?Ui9tL2NFNUxHVWNZWGhqMk94WmpsTXBQZzhNNU82b0NsU3dmNUtHdGZzbm1E?=
 =?utf-8?B?czFDSGNLOHlWaHd4aEVBVURiQVNyZ1dBSGp1U1dEZ25zNUoySXlhWTBGUS8z?=
 =?utf-8?B?Q3gwMjI1TVZ5Ri9HZEcwdTNqK25nbXQxemwvcGNwYVhNL0JRQzlNTU9CdFhh?=
 =?utf-8?B?bGpJUkFBKzRHRm5STnhXR3NBcjh0Z3BROTRPaWtiTjJ5ZDFMUWJaaUNTdjZS?=
 =?utf-8?B?N1Q1RzFVTmVZcGdGV3pwaHNaYzV5QkhnVjZpbTA4dVByNm5GNXhwMUxsSHd3?=
 =?utf-8?B?blpoNG0yUjJTTmxFSkI5NVllM2tIcExzZjFKcUdyTTlsaVEyYnJnSlkxQm8z?=
 =?utf-8?B?VnRvNkZZT0VkSzFya0JmZnh3c3VUc3pXS3MzRm8xYTRWQmo5VGJmK3Fzc21D?=
 =?utf-8?B?QzNZZ213SG4xdW5SaXFFR2podUFGMGtTV2xPblRyS1kvSEN4bjZOTWIvWkw2?=
 =?utf-8?B?T01YSVV5cG50eHNORDBCcEx0a1NaMXdFTVZEa3kzZzJPU0hUd3VrVGpRSE5G?=
 =?utf-8?B?QzhnUkF5WUZyRkUwZ3RxZlh6cjlrWjFkRTJLTmtPMXVjbFdZbzFTOUEvUnk4?=
 =?utf-8?B?TUQrdndxOEdXK1ltWXZaUk1TRHVqYVRDbzViUlU0bWNIZXliQlpPa1UxVjZy?=
 =?utf-8?B?UnRjajh0RVk4UEVrOHJVcU9FVlk5UnNwT2loTkxBcXVuSnRDeGtERSszRUNz?=
 =?utf-8?B?RElnNlJWMmZPYzEydUxVbkp1bE5sVEp0L01MVDdjbk13N3NWb2J3YWhkK2lv?=
 =?utf-8?B?MUFnVE1TVkppYjJnSDR3UXZaNExDWWNkWjErL09KU3FlRXpWRDd0Y0RaWlpl?=
 =?utf-8?B?UXNneXgzaEl5SkZQQjNuUWlkUmd6TDg5NExLSTFYMTNOVmlnK2RNSGgvMTBU?=
 =?utf-8?B?OEFCdm4ydjVIWUlhelp3aU5SdldweHNEajk2RzBhczlGVEY0a0dQQTBhTmQx?=
 =?utf-8?B?MzRNc2VoYjk3OWhkNkV1c1BDNUxUN2pOYk41M0x0TFhUUWpLcW1nVGJjbkdu?=
 =?utf-8?B?Vms4ZW1EeHhzVEUrZ29nS2xBOFpQTHBnL2RlT1YxYlNMdEYzSm9uZzNaUmhY?=
 =?utf-8?B?Y1pLbW9TbHlZVk1hRU03TzBQT0JOSytUWmRxWmErTDV6WG9wdUxvdVJiMWZn?=
 =?utf-8?B?MjRnWER3bnhOMGNDYUJyYURsYk5VM2xnRFJiSTkxMk9ZWk9EZ2VKeVhuZ0xt?=
 =?utf-8?B?OHJIT2g1SS9NNzkvaC9oaHZ2d25PL2t6N0VMZXRBUGI4Qm9Kanh2OXpPTHdR?=
 =?utf-8?B?SVlFYmlEbnE0NVlISkQ4MFVDU2JpNU5rK1B1Y1dSZTluMy9aUHgyRTVYam92?=
 =?utf-8?B?R1htdkN5RDlzd1NacmgrdjhuR3ptVUlYeUFzSSswcHZPb09IdnUvUmI2UDZr?=
 =?utf-8?B?T281NmtBZGVFM2FUelBEbVI3NXE1M0ZXdUtpMy94NlV3VEVGQXRwMkFrSHRo?=
 =?utf-8?B?Z2NNeTlZelBON25WSllzRFhFc2c2RTd1THdDaXMyR3pnK2tMRVArVm1hL2Fo?=
 =?utf-8?Q?mj3lqQ8dgIneTEdQ=3D?=
X-Exchange-RoutingPolicyChecked:
	DGo0skcFGhAvfQ/GuSD7OituZ2V/tg/2FJJAgrQhYFG4Em4ol7UZ+EtBeSzsDWIPYywpFZQsH8YuwZNDYXcjfMPrpf4wQNQTULfwIbvH7vKJ/je0l2JK5qXT16st6R9bW6kSvE2T48bLrpDb1WVvuRIWPS+5u9A3CnHpYnJ9NDbE/gE5xikyx5XpaHy0sQDF30XdzrwP7fBYyhAcw1kvGnDwRnI4Limb37mv4FprIjyx0PETDydZgFVmgzUvdfcP9h1kresV/4ulLxZe5V4tLqbVbLiVuK8v9rj4pMbdZAenR8LBDEU0r/TTotmcZl7WE5xVz30KU37n24d8TfJDiw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nvHGCX4iNnCn0xZh9TEgE3+3i5MbnUCT+wj02FyXftclJmfOAgPc/uH6bTxcslvEHqVtbTJypceLkahrBFwnasyVgJcGFG94Eet9nqyN+cheMP8Ox2CJprhljlONdtO9dnuYSKTeMyyq3ksmLtalogmgfTIGT6h88GZfVTVznck9nHyMaHTgKD78t7FJAN12r28e3362fIs7umt0p6GHBHxlo+xDQU2FNqnvPMFsbCPMpTgWL2UX8wOqGhcUWhTn6hMd/bHxFLjGkyJTWeJzBglz6G9O0Tur2dcm/eElrstzhwQeAYt1wm+SeCA83CvCcEHn815GxGwLMzFyNdgwcNMJ9zsO78H9BESMpFqqCoyAR9lfS0V1IHq99H+Jw2xV3Jf9b5u3C3ZFsjRdVoT4Lu+REFKTbCjwiDj/9xp5bE7P17VMc3Q7z44d87/j+krQ39a/eN/RulkpVlHVxFDIr1eQl0nGhmO8V4tX7IigFoPAANOElkCfIx1K2O4HBythI8QtWiy7khhancdcgb2mnsDD9NI8w+hnJfbSy32B3s/dvFH1HveKpXSnSNP8iNBvlYyqNGopaPk9SY3dMo9w2wNjOj6AAdl8me6h5akuqaE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d3aa94-56cd-4c1d-ff1d-08dedb779c8d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:59:51.0526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fFzitKwbCObP1jEwi6J4q+7zT8AxHai7OoK1wIgoxAVeosPU8ova8ZZFJxW5N4rlpc64aI7rqPyGQMDHbxWmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060162
X-Proofpoint-ORIG-GUID: 08oU7GFSUevGhYU3tukGBp4O8vpCzeha
X-Proofpoint-GUID: 08oU7GFSUevGhYU3tukGBp4O8vpCzeha
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE2MiBTYWx0ZWRfX1I4fMeUB6Rhc
 TqxiG3NHwPMwXXoMzUfXLcYbCFOjET0ihNeL+jRJPiL52uSh28o2UUijSw38IdlqfDITaBNesMp
 Mi4ZuXHAslTQvaqpTrSV0hH4IcmVOzQpUWG79wJE9vaqm7MjnsAh/3BM/UyurRQUl3IhZQY93dr
 t3RHOvrine+sKPmrjEe/3D0jEOfZIAs76884XM61kOlmzSc/UE2i2Mjki6nULNvHC9UWJxIoBvg
 WHzAuTyhcodcXIlesqgS3Ei+TbCWC5aLeyA7fn/Ltd/JJYzSqHuXEO+dal8QKSgnBHIzGCvrvop
 Ps+eKuFTUxY9nbD8VvFEctka565yY/Ls4VNqDOaj6glU1jwujNQ3XXXDnXihZJ9UsUXxUDIkw7k
 a8CGx4ehzLMmZO5Iv5IQL9b3SMdGpE9A85UBDGRtJaHerr000r7i9uHIoshHptoRaEJEhZ9xf+f
 uiW8+nAmyPFQ6b38b456plspG6xdWRuBJBzSuPo0=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE2MiBTYWx0ZWRfX58+XqTA8PLEk
 8nycWDXWXkjpUX4oxLwDnrvEx2BruDqOfugklUGRSZ7PwgqqastL/aAbcBiAPzGNiHSNduH7mgQ
 ikdZU15OSicQVf0tqcLVKDSAWjTTdCbkFs8RlEKn0BIqGr0nAh29
X-Authority-Analysis: v=2.4 cv=Vu0Txe2n c=1 sm=1 tr=0 ts=6a4bd0fc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=TQJnMeXR_HuDPA3JxGIA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221

On 03/07/2026 13:57, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> 
> New issues:
> - [Critical] The patch calls an undeclared function `mpath_qd_iopolicy()`, which will cause a build failure.
> - [Low] Returning 0 from a sysfs `show` callback yields an empty read (EOF) instead of a proper error code.
> 
> Pre-existing issues:
> - [High] Concurrent sysfs read of `mpath_queue_depth` during device teardown accesses a freed `sd_mpath_disk`.
> --
> 
> commit d24252fbed25782c1f5fb88edab9e008070c4b9c
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi: sd: add mpath_queue_depth dev attribute
> 
> Add a queue_depth file so that the multipath dynamic queue depth can be
> looked up from per-path gendisk (scsi_disk) directory.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 5e0514304d81f..f6feccd557e76 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> [ ... ]
>> @@ -4088,9 +4088,27 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
>>   
>> +static ssize_t sd_mpath_queue_depth_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct gendisk *gd = dev_to_disk(dev);
>> +	struct scsi_disk *sdkp = gd->private_data;
>> +	struct scsi_device *sdev = sdkp->device;
>> +	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
>> +	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
> 
> [Severity: High]
> This is a pre-existing issue, but can this sysfs read race with device
> removal and cause a use-after-free?


same as 15/17

> 
> During device removal in sd_remove(), sd_mpath_remove() is called to drop
> the reference to sd_mpath_disk (and free it when the refcount hits zero):
> 
> sd_remove() {
>          ...
>          if (sdp->scsi_mpath_dev)
>                  sd_mpath_remove(sdkp);
>          
>          scsi_autopm_get_device(sdkp->device);
>          
>          device_del(&sdkp->disk_dev);
>          del_gendisk(sdkp->disk);
> }
> 
> Since device_del() and del_gendisk() happen later in the removal process,
> local userspace can trigger a use-after-free by reading this attribute in a
> loop while the multipath device is being hot-unplugged.
> 
>> +	struct Scsi_Host *shost = sdev->host;
>> +
>> +	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
> 
> [Severity: Critical]
> Is mpath_qd_iopolicy() declared anywhere in the tree?
> 
> Compiling the kernel with CONFIG_SCSI_MULTIPATH enabled will attempt to
> compile this code, but a search of the source tree indicates this function
> is neither defined nor declared, which will cause the build to fail.
> 
>> +		return 0;

yeah, I should sysfs_emit(0) here

> 
> [Severity: Low]
> Does returning 0 here result in an unexpected End-Of-File?
> 
> Returning 0 from a sysfs show callback causes the VFS to report 0 bytes
> read, which userspace interpreters like cat treat as an immediate EOF,
> resulting in empty output.
> 
> Should this return a standard error code like -EOPNOTSUPP instead?
> 
>> +
>> +	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
>> +}
>> +static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
>> +
>>   static struct attribute *sd_mpath_dev_attrs[] = {
> 

