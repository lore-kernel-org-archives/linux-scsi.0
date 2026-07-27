Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D5B3909AE;
	Mon, 27 Jul 2026 15:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166187; cv=fail; b=D/tULuJDCacIDFvWXDxjdQaURAa7ortp383QOR+dRU/4zq+9sLS0Z5P7G+qE4LKNJ3jqRmb4Ha48lYpQc2npDPJ2LRqG+ljTn3FAFtNCX22sTpiYdIFivR8muOkSZOsp3MBh6QT84kPc/nqjZMO80Fpl5kpdjkvbfKngLjUnxtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166187; c=relaxed/simple;
	bh=+oHLilGfRq4jElQ8tu4J9VSQvRZAthsKvW9LvO7sY5E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RybTBc8hlBQOZpQ4tmnEDL2Ph/HxZQ6hI2q+A7dtM+KK7K4rElOD0HENaya8h3lPRnFt6YUFOPP4C4hgTYs85DCYd55edMGcriSI/B7kyig8r44u11ZS9+a+DbLM3SJUzulAi6LJX5MnOCF1p7fwHPLvtnRjtmuK3Ycn0z86Fgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ze/KUi+8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kwrG8mq9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ze/KUi+8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kwrG8mq9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66REteC42501020;
	Mon, 27 Jul 2026 15:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d4eG7/7eEQnvvyx7lsk+4QtbzxGFQ249u3TY1EwLmrA=; b=
	Ze/KUi+8HngmrCpZRfclv3AtlDATM9mxPQvca0T4s2m4FovjjzPuYXZXXPf32wAB
	ICgjj2Kol1/DAvpqsjjoKRKpZC4xW9gF1DBpd0AtvptanIzbX4/bNWCeI2qGVO66
	vm2r/74vruh0Lg0/jIsSUEO0LjhulbIO/Mwv7vl7y67p0c+PkDhoE/6JPdGrgI2Q
	UBONpVcKE0A1/spkAX+sm6ZRhyXM1eW4Rm7lwIH6OWH/R4b8O/olObolmyL/ksDY
	+FII8MEbTmNHyTHH2O/aJjqHm7kbTFjIVK560Qci/YUkCv/lX3txarfuFaMmq9Fn
	LVBlXhjI8Wrewk5hFcnajw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pj1cb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:29:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFPanC018018;
	Mon, 27 Jul 2026 15:29:43 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6bjxw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:29:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtf97DthPCMA8v86sVwtb9WHhq4QMwvtYxHAPllq5o1jlw7uixJ6YaAfu2rj3Mg1uJBfcSND/XXx/+i9TgQO2+5sWO+OFabRuZgsFc8/rwxOQJv91IwnS27CGbph9x4tssYgF4I37GZ7MDh6wpQNzea5rwoHYJeZAobNzD7YA/D9Ep9fWczkZTJ9cArmCItOpanBRw5SUdcY/Jgp+Khwv0XRQkA/3zx4mDxkBnRWcKq+0sivFnxgA4OA/lUpu2mAYybxjcQoBnRmNoWSWmg1PnMntQv6+W2pHtjetisEEhJ3Nchzyj99uWu3Jx5K4SOvxzDEXR0kZ4hKBRgk6C0OwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4eG7/7eEQnvvyx7lsk+4QtbzxGFQ249u3TY1EwLmrA=;
 b=qkNZO7lHWZ80nJBOu1NH6zYePKS111lGDDq7cevTu9HOJl2yV+AwRgAWEgq7Dpdo04hMBSmIQ4lbA42LEl7VV2KN00YzMqXBhbzFDEpeN2sUWFbAS31/PBun2wm9XoXHyGamipQ36w1Orzv5Kph9m7k/7WhKV0V05F5N6SYpOeLj+GFOICBNOd5U/NlNXGpuS72WX/x+hEJlBn/Ew2Yn22j8/aiXa6POgRsR+txKEKeJiR5xVz+H9Mdqv6xwEAazoA3FoPhhVxXNOJI/Rci5OWsduXh6ZzdYudHNifPLv5/5blSN6yGuc6SGfmd2i5n42kV7qfDo6VAYtm5z7ciPFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4eG7/7eEQnvvyx7lsk+4QtbzxGFQ249u3TY1EwLmrA=;
 b=kwrG8mq95XHDabwQJx2SooHF5T9GrmWqqxZtvEFDNRKX4xoxCtsj6Xp1psQlJZ++GyBFvOp4sHB0UFl/llymZL9rftG1MmuttnEKEkrpnbzoXXNxD5GnW5OvE24BpdZ6zB0cHdEMySnIWNxivGXjyOzPhvqqpxZO5eP546du8TY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA1PR10MB5868.namprd10.prod.outlook.com (2603:10b6:806:231::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 15:29:38 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:29:38 +0000
Message-ID: <4d172eff-116a-4057-a033-3dd17f3335f0@oracle.com>
Date: Mon, 27 Jul 2026 16:29:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/27] scsi: sd: add mpath_queue_depth dev attribute
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-28-john.g.garry@oracle.com>
 <20260727152856.3854F1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727152856.3854F1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0335.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA1PR10MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: 5538b4d2-b447-4e57-9088-08deebf3ded9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|6133799003|56012099006|18002099003|10067099003|22082099003|4143699003|3023799007;
X-Microsoft-Antispam-Message-Info:
	dGPc8DuINRj56BTzjTY6HGlXCjl6v5IZJKM1yY6LPV+3AiIOBNX/tHHeCpO74NR417is5ZrjG93TFhBCCZxcszanFSopbYu7oduhOsvOXAGI9SYs3waxPwc/R5MOpg2Zfp0wPZMKbx7uybzoPlxAU1EHQZTHgijUV+Kd7KZ1BOoT3rIxMy2JAChZ5Nr2SdhncaqB6mbrGkuJN688XvaxzdZh37n7W8M98sN0TTzJUMcl7JIYeQ/VH/y8yohWGzgBAwY93e7sW2wgiNwfyMPNDkm2sKW+PilymrCz0RuUppdd86otBDrJloqNwB5wbO1Ln43yAuG3tXlhfDsFIuGE40xRhCOqBDWfGk2LRwmH1LHHj1A3rnbY3GcuRNF5XA3o9SsH8oFnbeew6RjklzTqXcEZF7slZdnArqPh2G16aoO8+ouu8BpIJAOKHeh1X3LyqDKIR8j7GED0QE4IzTjUg58UOGrfyMTirHyDi8H/W/FVbhpRfnNNsirCOdu7WlKKznh4nLFZpD35N2LA5TMRwIswmTemDj1FgTKH3NPkjhYY1uyTCjmuAfBgaZ9D3QEhMcZBzf5Zq9jVbIcxbaxoqHNyfQCcCnk+GJGA98UKSjuHuYLUf+KnInDTWIddA5q/jfqQlqi/dQBL5L/nWRjJXCjBJY5EH4uM5nitXiznlgU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(6133799003)(56012099006)(18002099003)(10067099003)(22082099003)(4143699003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWRpNUNwemtOTWdWK0pJQnZvTFlBYmg2Nk1jR0FYN2hXSUVaU1VVUjhnS1dO?=
 =?utf-8?B?NEttbkdyZ1A5RDErVk1HeVdqQTdoampTa09FYjJQeTc4aUtWQ1ZGT2M0REF2?=
 =?utf-8?B?NEFuQWtYSXNvUHpnKy9wTlVLWm9BbGE4dXNLYnhpNHl3WUlIN21zNHpWeVVu?=
 =?utf-8?B?czF0U3IrMFlod0JKb1FoNFdBRU1SRnVvbS9pbWtuS0NybktPdDNOM0p3QnhQ?=
 =?utf-8?B?Y21LSEJ2ODc2MTg3dU13eUsyWkgwN0RIcnRNa3hEMXpXcnpCc2s0Q2JIa056?=
 =?utf-8?B?ZHlRRjFrMStWK3NSbGtUOTVXUkp6K0JBeC9XalBOa0pvTEU3Q0x5NUdIb1Yv?=
 =?utf-8?B?VkFuR2xoTHprWG5uQVdNRGdQM1RCcGFsclJETGxwZ0NkVXRrd2M2Y0RXd3la?=
 =?utf-8?B?NC9ZS25wOGc3SHFZdVBkVHBtaGQySmd0N0VKOW1jdkdDUW14cUlCdFdMTUVN?=
 =?utf-8?B?Yk1EUnMwOWZ0T2IydmNseTlkZ2lWSlF6U0c2SDN0WXZFVHI3R0dmMlhYS2dE?=
 =?utf-8?B?dUFSb2lOdVNaNTUzT1EyLzVNU3VoYzlDNGgvWTRES1lLMlZNRzhlZll6Ulhv?=
 =?utf-8?B?bHltcklzS1NPV3Z2K2d3MkZjZnRLaWg2Ry9FdGo0Umo1UW15d0xOQWRnQk1K?=
 =?utf-8?B?L2hTd1RaOGtGenpzbU5hQXl0ZzRINkJCSE1IVTgxRnpmZzE3aThEK28xcERW?=
 =?utf-8?B?bi9PeWRlZlpSREpzNmlSL0RuRzkyLy90U210dndrT2hsdXNFeXBLNjB1eW5v?=
 =?utf-8?B?dHJVVHdOK3hJRVZYNnBZL3BmRG1ZN1dZeGlPc0FLdUtBZXQ1aVhQNDRueDdj?=
 =?utf-8?B?OFZtcjhrcXp6TG5FZ2F4UWFicTZtM1ZIVnc0VzROalNvSitxYllJQ3c3Rk1D?=
 =?utf-8?B?eitBNC9VYkQvd2FrQVd2Qmd6bzdRRDIvbU13eUpWTEtTNHZvVDFNNis0aGp4?=
 =?utf-8?B?OXQ0YjZVNERubVVmZFphRVExdjVqamY5ZmlGNE9mNHVvVHBJK2w1Nlpqa3cz?=
 =?utf-8?B?QlBIVWs3THBiT0hVRi9EWEdzUFVseC9PMTFvTEx1NE5ScTFNQ0R3cStISk9H?=
 =?utf-8?B?YkMrbVBxdFkvRzlDRFFPY0RIc0FQU054SzBMVjN6YjJPK1N6bUJRZUFOWDEy?=
 =?utf-8?B?YmlLQ3hyNEpsSm9Nak9tTlVTM3Z2SkRucFFBWm9YN1BDZEY3UWtOTEF5ZFBE?=
 =?utf-8?B?Q1hsNk1iclhkbkZDS0owOUdOSXB5UE9jS0pqQXlHWldyODBZMm8vTWp4RmND?=
 =?utf-8?B?Nkc5NWtoSm93b3lhR0cwdTBYLzVZTk9pN1ZHL2IvaWc1MWl6cERnK09xcVRU?=
 =?utf-8?B?bHBQN2V0V0czNW1Od09LaFZOOEdlSmwrTlV1dFpDM3h1NmRJeWpPVURxVHg1?=
 =?utf-8?B?NmpwNEUwUjU4Q3I1SExGaU45UXgxMHd3bkcwWE1uT3p1S3UxMk1oZWRmNjdk?=
 =?utf-8?B?NHQ4Tm12eUxLRHNSOEtMaE9LY1ZJRnJ3Ujgrd3JuVVZ3ZjhuTms0OGVLRTEw?=
 =?utf-8?B?alo5Y2hwQ1p3bm1vczlJK1lrSGw0SmlBcTU0aW1QQytTbEJ1N3RIOGFJOU1C?=
 =?utf-8?B?UW93Q1kyMjlZTVdrWjlEQmZhVU1kRUxERXB6bnFZNWhUQW12R3ZQWWIxbjdk?=
 =?utf-8?B?cUVMVXpqWVBmeXdQSW8weVhlTUZNcnZUZWVNdGh5emdjODRxT01sSHlQYlZR?=
 =?utf-8?B?RHVDSnk1MXZIMXpQQUM2VFBiZm1VcVJFRmt1Nk9EcUY1amkrOHJ1dnRPQkQ1?=
 =?utf-8?B?KzNpMEtKWWExaU1QbXFhU0JUcWRPcmRiQUsvVmNIZVQ0OHYwQ1FyZzlxVFh5?=
 =?utf-8?B?Nm5qeHhmSWkwNXZWcmlzQkdadWxtaHpmZC9LZTcxbU9hUUVWRG9aenJUdTh4?=
 =?utf-8?B?OStrOG5BS3dFSFpKOFZhVFdLV0MxRFpmQU5vREh1MHV0NW9qY0hrSGpKY29Q?=
 =?utf-8?B?S25jb1NodExSQk92WnFrcVlaeDJpMTRNRjBnWHJVSTJJNnlkcnA4QzFkUFln?=
 =?utf-8?B?cUxuelN1bXFnQkdIOFErTWpZaG5Lb3YwMW00Y3ROOWdaMjR2c2s5T29BWFIz?=
 =?utf-8?B?SUlnLzFtUGgrNTRJSm5EVTlMZ0w5bTZzVTJDMy93ckNmeEozSUp5WHAxMXpL?=
 =?utf-8?B?T0tseDEweXE5MzhWRW1tWVplOVdCakd4a1ZiSzduRjFHVWFycmpSaERZdGpX?=
 =?utf-8?B?NUdrZkdTV2svYTR0SkFXN0Q4TjZJV0NxRHYxU01maC81WHNxQmU2Q1RGVEtw?=
 =?utf-8?B?MjRVQzMzNG5LdlBZR0lCUHVqa0ozbmRPSy9LcEdpTzRxVkhQeDlRa0JrRXZk?=
 =?utf-8?B?UUR6MEp1MlJwREx5NU12TlROTHZZdlJYZ0xTSEExa2lPUzVLcDNOeWlrdFd1?=
 =?utf-8?Q?AwoRzaosPKb3KHCg=3D?=
X-Exchange-RoutingPolicyChecked:
	p6znRIgr2ZM28bdbOzvk3pwdS0DCvbup5QLVwO/qTlKV1MEcq5PGZv88woZh0eGsgHzQg/9VTF8ZEfudQ6yZIA8e15EwijZ0B2PTr1jiTIe3tIGfZJzcZgRR0T/PZ9LRTlRWrhPZNibScqS6w4HAKIwJxXnS4nXuvhsM/bmBJjYxFYsmmn0AQkgs7oXdBIlO6Y3oPqgDs9ILLF9RY4c3jW1/MrRkRPsCdkWkfGVvo6+KgNYTSg8UcyJwoDKooaNXusa0xgDFQlqNJdJMiJSEFbFHd64IyP/4/gF0P8I0KK+d5Q36qufVCrmJtHK5LIoXB+bRwmwKcWrKsfKbBwr+tw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V8XbcXu8njO6WBZVRYdRZqa86OLv8l+6/ftuv1pVmOyIWIc4nkkN3cPJt7Sbl0hqJP9nb2dw+rRS+fIVufJ+FzbA8k3BcHABJw0bnFcbLXzBjHNYAg9tXaeyUfX8T2Kefs27aza2bxaDOYleTXgpqLDOha9eyBbZCUFYxpFHu/NIL4H9rGTGblOStKcyzc0dY9k5PICYSuD9lzJQ97AQ/LoQGdNJP0C5f6nPjsBvPgY0nyxDHHmYfFt22n8iPvN65xqOHD0MtF+nJ5PMCSX/I+VziviShtrMypKaXu+GcNu952k6gZ0I9cth5ocLHHRMK3zmQWssxgRA9pz7fnYLeEy6BIcHdip4oeh8MHj/OnTfqMlyXNuCy/mzPqW2Pw1ZZ0CJ25y+AGlygOyoHgmDKWwtfKWUznuWyw0yapZBZXKyXJ828ZWrLdAtW0o0egWCNvTpUvy2MxPa8kiLhw/XFYR1ciP1OzW5jlUGizZ/9mfuCCyyDs/LPojD16gG6NW7p9shCHUz6v7c97QOOJihOUKwUUc+RvRMtEB/HJ6WxNZLsAstOGOm+UTZ3NqCYkuPEOswD91h5ccwx5Np4lv3KUU5/4cfOGLWM/fJmHtNsT8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5538b4d2-b447-4e57-9088-08deebf3ded9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:29:38.3830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5EfdDSw5jZ/aD3cq2VapEFweneSSYTpj+aJNSRIw1NEX33zk1Rm/bGCMzMBjIOvJwCh4UOuMu7JaB/KAOrHTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5868
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270145
X-Proofpoint-GUID: 17YiWav-d_G3jfxX41IShz-HlGHt6gku
X-Proofpoint-ORIG-GUID: 17YiWav-d_G3jfxX41IShz-HlGHt6gku
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a677968 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=0KmJrFj8ipl5Ivy8eFEA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfX9+is4Xr+bh2E
 l4mFvGV8/WXQJ9ICjRn2jmVTXEnZtfoxHwFnPecSwebjf98e3HI4/nurQAVc2n54tx9PNTWYCWJ
 pVfW1zd2Bdg5nW2EnHsQSSM82T6OhAz37EepUEbBYpc7hKTC5F8Fryp6WcuOQUjcugJGO2Yb4Cm
 Hv4KkEldGYS0ZvWnwdJyOqh0nT+WcdRzzfuOY/rMvujQBmELL1QLZiEUyik7YzynqLZEITvp6Uc
 QjV6dKLQouAYB4pGvpOG9nwKvlvrnlmRpmz6kqTffynvTJIrpk6GKKhOjMuQR/eewEcawPBXr64
 IWfw7VVTqb6DCLVrEaJuoO4AMrLWU8d8DPP8tR7W02oBRctCHtvTdlcDiS4xhY8QMfpMbJepPSe
 NpBCAJMLNSs1bbd//kg6y3kV3Doagi2U5u0XOHvOf+Yt2B+7cTu5fusdGpWrwlsMQI07vhFVbuf
 whjJE0nwE4xf016/5RGwGwDH5+mwNiS3MqhhviFM=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfXxRzZhQbJK7jM
 cxOeT3wTWvSukULPoY7zfKTUHjhGRCLOcNX1V2bdqxjCv+5WZGxF/0X/84B90dTlOtRhyCc3FxO
 6OEoF8QqFBF2LWAiwPGKhBHEwklsDnVJY326GKqvAJs2ihlrUYyo

On 27/07/2026 16:28, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The sysfs show function `sd_mpath_queue_depth_show` returns 0 when the iopolicy is not QD, causing reads to return EOF (0 bytes).
> --
> 
> --- Patch [27]: [PATCH v5 27/27] scsi: sd: add mpath_queue_depth dev attribute ---
> commit a1c72efbc115f45170fc3510049d2e925ee24a95
> Author: John Garry <john.garry@linux.dev>
> 
> scsi: sd: add mpath_queue_depth dev attribute
> 
> Add a queue_depth file so that the multipath dynamic queue depth can be
> looked up from per-path gendisk (scsi_disk) directory.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 6b6aef361ae22..fbf9da686f25d 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4159,9 +4159,28 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
>>   
>> +static ssize_t sd_mpath_queue_depth_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct gendisk *gd = dev_to_disk(dev);
>> +	struct scsi_disk *sdkp = gd->private_data;
>> +	struct scsi_device *sdev = sdkp->device;
>> +	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +				scsi_mpath_dev->scsi_mpath_head;
>> +	struct Scsi_Host *shost = sdev->host;
>> +
>> +	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
>> +		return 0;
> 
> [Severity: Medium]
> Should this return a standard negative error code like -EOPNOTSUPP instead of 0?
> 
> Returning 0 from a sysfs show callback means zero bytes were written to the
> output buffer, causing user-space reads to receive an immediate EOF and see a
> completely empty file instead of parsing an integer or receiving an error.

No, this is same as what NVMe does

> 
>> +
>> +	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
>> +}
> 

