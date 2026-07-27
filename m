Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE2A41B8ED;
	Mon, 27 Jul 2026 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169495; cv=fail; b=MM8NYhC5Y2e3wifnqEkCHKs/adqdvc5YuNikyinkqjmp+F9hReRSMnju3iFng7kCqSqnMMugW4Gehpzr48DuNAn8RzfoJtH7xzZ1kGRazyBJG+JjUp7Wiv7WuypOJWjYtEu54yzEppcomjbfI2DdPgJp27DN513xtra9qM23/FQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169495; c=relaxed/simple;
	bh=zd8KQEvt/UBiV4AGtgHHW3wQX7sABkM7/zLOkluHFUE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jFm8rdMVQWRxt4O6wLQFQhvO0dq4fLckMCmz6bQqeLIP94oIl8Am8cl44iP7jjn2wf76UKflSKxQJ0SkDjWNf30L8fBmJuj1OHGqbX1n5DuHwljwMJf/aD/vNvzS2Vyj2tzoS8BgmLIzQ8eJd+brNa9vs3k6EEeAoFjXw+ZbkkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IcnCKUa2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zc6aYig4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IcnCKUa2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zc6aYig4"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RGMYGD2658607;
	Mon, 27 Jul 2026 16:24:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=M31XGgchRs9/93sUIR+gKhnJDM9VRPu5B1wwN7ObJZc=; b=
	IcnCKUa2rSLBHZ1YW9sanugurPLvE9VIUXa5uTv2KyWFFtiaKg5vwXwl7XsqyEG7
	l7gCkZqqRsIC4zGcJSpFm/hSJIB2JLvh/cusVeZO7KPCLfAUoM+K/xJ2CsfSWRFK
	mHhezRt8HNper1WJ+HDdrxy/yzzPySDUx5SowS3TJ3uJpoH4rttrQfGoUZzEYMGK
	MFaHgI8yjMiAjCzzPrh5IzfabJRZfhb9w9FUykA9Q4dJmerwhdeVl2WF8ptkrcwE
	wQ8l9tk2vWbMyyc/I0Ae2vruaaIn8J8+bBi1J608sUfEUJlrZsvqBkHYJTe4t08k
	OWCqECR58YI5Sl2hY9S97Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pj53m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:24:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RGKgUK020523;
	Mon, 27 Jul 2026 16:24:50 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8gk1sb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:24:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GyLrfnEDh1Amo7fMBSRscs3Lo8ddJNHMzMklBnyQANOUnz/k5cbeqWZ5L3GyjetWzpI+6Eu2IFZnL997+hH6q7ap5MzF7Jz7qTzo78dfX7JwXhKzvACIkLmu7NL0w8/94MNmX6+W3G4ocJtX2Ub2mIaparV5lSw570ZrAlcY6yGhtEz4KFzgrxdeHBY7Hmot4PM9jRomBUaif3VBew/271VjpcugL8Pip1l7EX26LeooOX2LbAmccEdre2+XoS2ekC16bB1ifdzk71IH7l9VYqDgJlEBpemLo6WISun4Fkf85AIWQcNT7HarDDf2lcXPqsr8XG6BdmiyxRS5XIl/0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M31XGgchRs9/93sUIR+gKhnJDM9VRPu5B1wwN7ObJZc=;
 b=GtV8cELAymNrRnM4RgubBk5fKIheFBC3937fY0TfxWupXVrGHOFfwu7lCIarupXF/XRmY+Vcjg1GBSXqLfRGcvZ4zq4saGa/b7BPpPk3Z8rcBrKMM/IF2c7xKU+OmnNrnqCynXoOEc8IG8q83hda3s/K24OkdsR6y1f/mdnKN9itpBEGzScdXztdPS9NnBiZc6AK26prV1zXtaaAzv4jsYOBNaAF7w+6YpiRD0LHuR93oO2kH7juGwBxwI5LYMIJ0eMXo/FnNxpJZ5nhY4meEfsEtrh43c+JL9HkUNdVgAKEeZy1PTOHZWIBo5+bcXwPvSdg7piQF31tQeZYYw50uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M31XGgchRs9/93sUIR+gKhnJDM9VRPu5B1wwN7ObJZc=;
 b=Zc6aYig4L8sWExMABx/j6FAmJ20nvt34REWF3SKRIbbYGAUQcKHBRI0ZpPukabKP86vn1TlEm+OXQD8Y1IxLzLlEDEH9bHvPtuT786KKh2cWLBS7C2lbM1W3+V+9jBL9sQ/PwvDN9MGKmBT5Rhg56+AwWydYc9wRPUZRTMngmGQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SN7PR10MB6953.namprd10.prod.outlook.com (2603:10b6:806:34c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 16:24:44 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:24:44 +0000
Message-ID: <ef518ded-22bc-4f49-bded-e1fb50f056f4@oracle.com>
Date: Mon, 27 Jul 2026 17:24:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 25/27] scsi: sd: add mpath_dev file
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-26-john.g.garry@oracle.com>
 <20260727153314.90D191F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727153314.90D191F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0049.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SN7PR10MB6953:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b3b6f4b-05c9-4545-7e52-08deebfb915c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|10067099003|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	mBAHANlCOKNN9YzGFIcXxqV4NSeGvrP1MOElFP81qQVk/AciAkF6u0el8M1TQgGjf7rvodGJaE5UCS+LetADZKv175JDTuuD6wq0jF2kBBKoe48/TWY7SOITsjc2g/rC9QvYDdwEuOhbGpTDkbAxf+p0Lh6Zy7cdljgKrCfknvSHSSCyGbGHUWXeEfzHiu1IexGmWoyN0gtSn433RrwEfBFE3hG9cAJHT3TQ5tCNTnhSi88uYXGxj1GQbgSvjo84ij5ritAbnk/6Yu78vEP83I5GhR3/dGIQh8lMysRd3OS9zVw88UbZaUACKyDLl7OsgY+1XoKGMC1RHHkGSTIR49aWZA4368ipGl/Y0hstpWrZsT1Rm9s7yDtfYJ2DGU+Ccet6nV484hX3oV3ayY2KzMqZTJImyP0tyAGilNKATZ8Kp4q7IIv6r7jE6Y7zsYae53nXXPQnTSFa6Pki/d4YYscHJdeya3Tgo8ic7l1SqGjeVpyYWPNZrjAqjNbLdCXpxlp6AiUsnFJ+cK/RH/dZndUwJgOYmMPpC2PP2LLBPtJBed8bgnUNXUkQmbVXfw3yaAZetTBN6289NnpzK0w1036Vnohox20RqBmIimdAXPFMorTIk+lnoc5rOjnuyJKqNgINp7FUh+aTADOzMYVL7uYQl+ag76DlFSvOmz+++m8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(10067099003)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmJRYkR4ZnpDUy9HN3lhMjNBQms2dGhhNW1pNDNWK05lbzg3dW1JT3NIRXAw?=
 =?utf-8?B?eHVLNGc5cXV0ODlBejBZOHlzRllCNHFlS1ZFRzdQSjZXZWthYWlrQ1Q2cEpD?=
 =?utf-8?B?VHQveWw3MkF5Uis4cjJoaXZMbDN3RUxDcFJoVXNIVE1HTDFoY0ZEekE2U29R?=
 =?utf-8?B?dUZydDFMWVhTZlFyNE13ekVJeWJBdjEyZjk1eW11cHR6ajIrRDRNTEYwekpo?=
 =?utf-8?B?ZnFBQ2NYVERwZnFJK0l5T1B1VnhFTSs5YXhzbHZ6WWY2aHNJNGdRTkdqeXJm?=
 =?utf-8?B?OEd4YmFLK2d1U0w0cDRva0cyVEtmdGhWa1JNaWZBTGFBZXhEVHFlY3R5ZEs5?=
 =?utf-8?B?dzBzZUdkUk5qbFZJbWRiR3JkTzVHcUlHNC8zN0wwVERwandKblZQU0M3elMw?=
 =?utf-8?B?OS8yQVpRS0pLbFZWam1KTUJFbEVUZ21veE95Y3BTQmk3b1ZtdUlyTUZNNFZr?=
 =?utf-8?B?L3BIcVVSaFBseG9vYWxGNmZEMlB5VjNsYXl1RHF1Yk16cXlMUm1oMlNFL1JO?=
 =?utf-8?B?SWlISVFBQ1pWQlhCRjYreC8wb0FqbEFQVmdTeVFhbk5UWDFVcjBJVkFRREpC?=
 =?utf-8?B?aFJERmNBcTlHNTNBOTB0dFNWNElCRUhCZW9iUCtWaDByVnRpQUJMSFFobHBr?=
 =?utf-8?B?dVVDS1ZVbDR3dEtZOFk2dmhBMTliMjBXcjUxWSs5OUFacmxlVzE2Y2FJQzlI?=
 =?utf-8?B?dk41Q3UyeFd6bTB3MUFBWk5IMStNRzNDb290aU5HYXk1WUN1NjNWMHB5anZp?=
 =?utf-8?B?MXdrRDVveEZsYTREalZwRlM3TWdWWU9ScWNubXJCR2R0Zm02VUcxbHNreDVR?=
 =?utf-8?B?am9GU25pWm5INURLWkUzdUdnVWVnQlJpdnlkNGJQUmptZC9vZWdGVDU4Nlc4?=
 =?utf-8?B?Z2orbGNJbWowbVV1M2VSSE1xYkVJUytrN3ZjMWZ2emFqUnQraU9IVC90SURp?=
 =?utf-8?B?TVdFVkRyREF3MnB1SXgrSGF1R0tHZGR2bmo5dlo4N2poUXpHQ1VxN041a3k4?=
 =?utf-8?B?ZjFGbVlTck5lZ2FicE8yNlpWcWxvcENyR2grMlRQQU1KakpEd3NURW82TVJD?=
 =?utf-8?B?Q2JxaWNTTDdid3ZNU0hmWUd0YXVyeTZMdGZsUGVsbU9OZlpvNDBSUUVsbVF3?=
 =?utf-8?B?bGZONnpIcFRNNUVmTjVZWnlxY3NTNnVIM2prWlA5NXFQZnNqZmJmdmJCaUsz?=
 =?utf-8?B?TnAzUnRTY2I0SU1pdE1WbGZpazNBdGFxSzhEaW9nSkJyb0hyb1p0T1NManBU?=
 =?utf-8?B?TGpwbHkwL1BudXVBbVRGc2labWwrMThzRkE3YkFWVDFVWlRmMGNxTitMRFlt?=
 =?utf-8?B?NGtnRXdTdHN0RkM4b1FzL1JHL2VCeW50Y2NmYTVjMW80eGtabGZSYUk2YXc2?=
 =?utf-8?B?TlgyTEQxR2ppQnZRcmNjT2d2VzltRURoYTBCeDJ5bld0Z2RsNGRQVkN1TVlL?=
 =?utf-8?B?ZzRnLzQ0NHdaZ1BvaTFMQ0hYMTYzNXhhUTB6Ykx1N2tZRlR3RldCbjRiNHRQ?=
 =?utf-8?B?azdRdmZtM3V6WXlWRERtNDhlTEhBQXVONkVodWVoKy9wQzdZcnpHb0tNZTlK?=
 =?utf-8?B?UGY5TTM2TWlyUTF5S0pOaWpWc0VBSmt5VTM3MkhJSHl3SmE2YldxMDl1R243?=
 =?utf-8?B?ZkFSUzhGajJXem00U0tQek1HOWhIMXBzb1JlOFJobjc2M2VtcnZvME1PTE5I?=
 =?utf-8?B?RTkyeUI4RVlSRmEwOFg3dkxaZndTVU9RWW5ENWIyMmZYRHlKZGVYQ2dCbEFK?=
 =?utf-8?B?TVRNOEdkZlJSQUg1NEhhQ3ZieTlybCtLUWZHaVZsSE80NTBMR2lsSGFmZEs4?=
 =?utf-8?B?TnlnUVQzcFFZbmN5RkdYUjVublFRbnY5OVdTVDlnU3laUHBoMzNwelVHVlFN?=
 =?utf-8?B?bUlXb2FKVVpyaHRqdENobWZTeDhBYjNwRXhtWmUzRThOQzZFK0VvQzl2dlFO?=
 =?utf-8?B?NGRiMFNwbTUxaGoveHBBQ0psK1k4QXc4QXJQeDR3MzdaQjBsd0RyV3A5Si9J?=
 =?utf-8?B?bXlUZjg5YlFrVlZVUnh3dXpablE5T2daR3BtbG0rSXBkR2w5QU9MS0ZONVlh?=
 =?utf-8?B?Z000cHhLQ1phT2dDakp4Tm9MbjB6NG1hQ05xU013eE5kRUVWdUdQK3p3TVRZ?=
 =?utf-8?B?aGhmUVZrVnJ5RXlRdndsbFZGOFRlSUQvNTc5QlJQTkJLaEUxM1NWbzBLbmMw?=
 =?utf-8?B?OG95TFc4cUR2VDkrbUx5U25iQXorRzRQak9OUzFmaHhKTlN6ZE42TXFkYWYv?=
 =?utf-8?B?NGkrSlVMVHdYTXh3VmRid3B5eUdvVUkzL3JIQkJIM01pcGE3RE5NMUxGRTZj?=
 =?utf-8?B?U00zM09MelR0NEpFOG9hOERYdkNoTGIwVGZSc2kxZW5iVndNTTMwd0s5OGZw?=
 =?utf-8?Q?CfOP69Gs+ePyS/E0=3D?=
X-Exchange-RoutingPolicyChecked:
	BmxyHzZMMhD7S4sFRo5UgGfVaOORONV5heBXfSOjLAga9pu4F2/0oJJylCPD9l/l6w12Mo+MbmcT4tQXGC2UFe1X2k913k4AJSXvxOHCTv0A/vrzEZt+VSmvZVBKuHRYwmWVpXyP95eJ5RerIW7ZNAV3uHbGkOay92USTfoOz0gNz+KWh099NG1ebM+uthAkp7UBcIvO3+1z72KK5i9Ij4zqcZ6eh8C5g12jt0MH4pSBMVemCoFiWvc2zsq3s15euOh9Kj52WeauAl24O2l0D/MdGuOiyj2zXsOQOF1ZnYebUebpESN2OmVUir2wCxd0TSxOlIUm8UpwPewhKFDeUg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G76InJg10LdQG+VoQSeAa1WRfQga+6NIgZuMbfYxkBSv43AX9D46yoY8iYUr0skLg39vkhmUTlnRpIIu0tVjgAqRVg2jep/SFsO2RIX8SueF6m0DedfepRMAQGRMnlz5aE/5qcUupLQdM26RqM1SnwVhdR+9L6mZ4e8QKV7EuNQZVWZjOO/wrcwNAT9ryMXrkrmEgozVYKxSji2pVhjOoEQbdmiC7mhrM9DyoxmymVpBcX2PK53Q1zhtSrtP4+9kNM4UoLD2bUvqFGHckrbajJVjzNPZU1SN3c/ZZ2w8vmbiBZnNbvlW75r5ZpK+mNsg3ZlDMhn0uJGIP08C+bIZHjWV42y+6JX6QgyqiAzbohamEtx8YcYAC/vOXw5ZmvBe9suLwB2sor6PUxn+Jjj84m/n2kxcM5gJiuNzJxSTu4v4tUUd0xv6fB/njaNf71NVtb8bhF/p4QoTnW6ueQsvoysQub0hdoWgo7ydPokixsccbVDzE7Y7FUiPcMcuUiDt/FCPnmq3m3JEozZKXN/GZylp4k4ia+SEWxVwsDkxHGAtTxIpHLp3DaqqVcQjjJ2JHX2W5DmnLhspASKmvMtOhJGZv4JRB7h4R7io3m0bah4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3b6f4b-05c9-4545-7e52-08deebfb915c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:24:44.3717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+MLAke1CdIzpSLEWEOHvaL+R1KwsYvIv+9iq25fmm/+sKTBjYUAi5nM8s4e6bvmIhAtgeAdPFL20QJwBYqwmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6953
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270152
X-Proofpoint-GUID: y3atNm-b0PbXe8_cVGdOT5u6JarXRjyb
X-Proofpoint-ORIG-GUID: y3atNm-b0PbXe8_cVGdOT5u6JarXRjyb
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a678653 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=7-ZV3htnklM_Rz-pTtkA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX786ME2qu5Afu
 wQ1vij2Gj3HOOUyKbXre2UA/FYZk3QSrV8CZgrKnorkcQGTyBjIJrxFDT0i5R2WKNpmCTj2Y6/p
 nMMqNx2N/CypGe2h4mjjXDxOVOyvke5Plh3tfv5WYValbZV7c9XEGTnw9SXXPyBC/nVUvNYFXoo
 xuxIxCfJxlIEc4kXo0w/4uhnfo35e8lbeQJ/O/8dhLypUTx42UYIAibBi6tdV2FP7yJb5DfUNGf
 blVHVvh4jYLRTS2zTA+O6INIp+HSlBz7A9X+KY9cA1hD7pE/AKVQ2hxG/BqxAeDdOHlYYPkLnjC
 FtpMg3CQfqau/Nu0oKr/LiHLdcQIAdJJ+RygA9dgTqW/dsJSrLu+Y5u0snYHFQXnnlA4/vKvVHD
 K9uzmOp8uCZyiNbW1xCpXiFeZB4dfwG+ka6SXpW0tOfT8Nk5o2MapstBCnc7gZR3JppsC5GVXaw
 5emfcH9WeXU9935knjcigf+nazLT91ZV93owEv5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX6xKCA0N5Sghg
 bUKygGgDLACZRR0/epJ3uHWBnlhq1fi0v6TPaC2uQtDrHoEFshHhO9UlVzKu8PbEboHDxT7xUlR
 +HSW3CGllJiJnUXPKQygnT4QDoT6TJHVez70k/jkdBM22xRzq0Z1

On 27/07/2026 16:33, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The `mpath_dev` sysfs attribute is exposed to userspace before the multipath disk's device number is initialized, leading to reads returning `0:0`.
> --
> 
> --- Patch [25]: [PATCH v5 25/27] scsi: sd: add mpath_dev file ---
> commit 947fd6f1a6cab1fe0824d619f628abe9ed07adac
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi: sd: add mpath_dev file
> 
> Add a mpath_dev file so that the multipath disk can be looked up from
> per-path scsi_disk directory.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index f044b2dfaa9fd..0d73b03a3daee 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4109,6 +4109,73 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
> [ ... ]
>> +static ssize_t sd_mpath_dev_show(struct device *dev,
>> +			struct device_attribute *attr, char *page)
>> +{
> [ ... ]
>> +	disk = mpath_head->disk;
>> +	disk_dev = disk_to_dev(disk);
>> +	format_dev_t(devt_str, disk_dev->devt);
> 
> [Severity: Medium]
> Will this return 0:0 if userspace reads the attribute before the multipath
> disk's device number is fully initialized?
> 

I'll just error instead

> Since device_add_disk() on the underlying path exposes these sysfs attributes
> before the multipath disk is fully live, disk_dev->devt might not yet be set
> by the block core.
> 
> Would it be safer to calculate this from disk->major and disk->first_minor,
> which are already initialized?
> 
>> +out_put_disk:
>> +	sd_mpath_put_disk(sd_mpath_disk);
> [ ... ]
>> @@ -4539,7 +4608,7 @@ static int sd_probe(struct scsi_device *sdp)
>>   			sdp->host->rpm_autosuspend_delay);
>>   	}
>>   
>> -	error = device_add_disk(dev, gd, NULL);
>> +	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
> 
> [Severity: Medium]
> Does exposing the mpath_dev sysfs attribute here allow userspace tools like
> udev to read it before the multipath disk is fully initialized?
> 
> If read immediately, before the multipath disk's devt is set, it may return
> an invalid 0:0 device number and cause userspace misbehavior.
> 
>>   	if (error) {
>>   		sd_mpath_fail_probe(sdkp);
>>   		device_unregister(&sdkp->disk_dev);
> 

