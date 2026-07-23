Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD34442B25;
	Thu, 23 Jul 2026 10:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804261; cv=fail; b=LYBvEeZypUIVZvUi8gI8z8NjPC+hYVyhq2Fl/DUFx2UCiENvVGKqDEn2k6vI52jAk9XGJcWv3PPhmVEGScWywrvvO1VKnv/0ykPoBRSRcoY0AaCC1BVChsmBPR4CjZR+9KClOQPyAy03te96VJp5qAALdAKR2+7ymnkkL0sI65g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804261; c=relaxed/simple;
	bh=YZRjF4PmAXjbmPi0GpJFIVqQaUTeRe+ZNJUkJ4l2d58=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tHOn13ZrZGEioaWp3kRc0bIWdYhU17Xnb/0cWfGkJFD4h71uSZqrlEb78NH2wI/i7kkMtF/rFTssyXA392edhBrJ22oYWI1Hcd3sZAtLID2omB+KUGrrRZ3sw2BUMNcQPDjzLZ2o1W6WM2463AfMd0hqjv9TPFGWoRf9HNB+Muo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dnged+Py; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CBZbz/DY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dnged+Py";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CBZbz/DY"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtcXf3353523;
	Thu, 23 Jul 2026 10:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=91Rgr2BlbugEbNeUddnGILlQn916mQtosDpUmfe8JBA=; b=
	Dnged+PygviXfMKUv058/2kyZLwQuq+k+fgzgy4C2cUCqrJZOKerCxxPyMteVLpm
	kyw3Rirs78DZnY6de5EN8b+DZHJcCGElzpZ92oTUr6JNpt76UHH53H6fsD5WFRrX
	/95v0LAfMFkI53WimKu3S8+OF43WSkV/Z48FcCcBa1pWXOzeW3TKL3aarmSZTCRt
	VAoO1MY8wXkYLXHz4vlw8D4xziEZrDI5grSXmhbpNG4KdHkHtNcC/PMINaqtxKfn
	NMAsfutxLx7rgGDGy238N/iEJRTP43qtrjYNVpTux/M8vu2FcHjbmIYyIaKVSvCH
	Y+vYHtAGOWQHaEzEiAiNnw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6par-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:57:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NArX8V002550;
	Thu, 23 Jul 2026 10:57:31 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010026.outbound.protection.outlook.com [52.101.46.26])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxryhgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:57:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q5X1Pg2rudgnoE2u+rW0v1jFuCHUh86Xtn/nzM0nYqi0Vtv/b1wiJvN0J7PJhkNu38ID4UtUP6TJKjdspI7eqlKTkHRLB03PNRsUY5z+uThtCCfMopY+CHweWiT2wwXpLoko4eyQMor61VvUfdhlyQW2UJ3IIUdXNX9bACc9d1xiCSK/Fy1Nyc2EmxhTGHvTmEy8YGFA0HZKapotMstZ0uf167UuDvUJqRBjNjb0+fioVaxTv4I71luWr27E6RUlhUWNxbZyLzH3GdiH+vBQw/5U5DK4afFM5AY39qrxWcUbeT2LwAeZNUy7MO9SWyrf8ycugR6wBD4KxW43jkbvmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91Rgr2BlbugEbNeUddnGILlQn916mQtosDpUmfe8JBA=;
 b=jbRLT4zX+wkg1UAElN58vB7whRQK9pmIpHFHEENy4900+JlEik2T6UV4ZgrxVD+UexHyEhyOFteJAlZM+FG15qCrrSpuI2grd6v3s7pRMlET5mr3LEtShOfnK5YtFkquw/IlNBygI8Kjn9yUEYXdRfpP72Vw3y7v1ipv2i25dZqQ3gfjhc44QWXKBA3xDfMwwLciaEhbQXPkD9cgqc1SxMFhSQwFqtwHIv9MYHWkzm9BCRLBy1REENzk9ifHc/N/lLi9nvrX6ax5VTSswMabhgztbczzMNd3UFWT+D50JlqSTJDI8VY3orKZkOMY6OaLu9txjpUnJ5Y5Kn70XteKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91Rgr2BlbugEbNeUddnGILlQn916mQtosDpUmfe8JBA=;
 b=CBZbz/DYIPiZnD67R9+L1sbEXIpisFiCFE6sxpi7i+PuX+r/BOt2mGLUuegb69oF0/IForqcWy6Euikts0nbakyEOdwPDf/3bRJrauvdmh/R0yDzx5b4/Va0x5Ugruka2gYzHZNpdtf9t13hJOZ0P3m44663KGCRMwcnJptAyVc=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by IA1PR10MB7486.namprd10.prod.outlook.com (2603:10b6:208:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 10:57:27 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:57:27 +0000
Message-ID: <01b71f33-75f8-470f-93d2-b7f04ac95859@oracle.com>
Date: Thu, 23 Jul 2026 11:57:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 21/28] scsi-multipath: add
 scsi_mpath_{start,end}_request()
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-22-john.g.garry@oracle.com>
 <20260723103244.DF5C61F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723103244.DF5C61F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|IA1PR10MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: ba206538-d125-407b-4e9a-08dee8a92f0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|3023799007|4143699003|5023799004|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VqPdOwrl0tLL/XdVZHXZWMjMasoYk10CWMEACAd2fWfH3kyhEK9TNlMOJopo8CkLf4Mz/TuLO3af+YSG6fkw+5+hnQ3pqcNZ50qztX5X4+BqZm934nKmgoKG9TfRPQegKQnflTWImAMftMS8v4nne9UoV0GzISgp4VEGOtR3CXzBmV5eSpYw7ufzcn/Mdr0PrVk3c/LtUE5l8AO6sUqI+Ol+DSVnuN2kyiExNk2IvuyBJqi2rArB96gZyGPKw4KWsu2ZEkvnCcx2KzT7EAV1AoZxuHFve6jKH7M79tscdy6pGfzbtvU4TdrsRdbauzR1Hwv9xmBU0FiCKGuDg1HhP7Ys5Pxb5leWYcPgXIE2gWStuY96/7Zy0EtatmimcNa9YcCVLpyklt0Pw6N1uVPQBgQjqj36Ql5HGRj21OQKAAXKG+y4/dE0tz+rq2Ud4JstLmvrFJ40w9h/C2c4Yyuhmx7jrFtYqp7BnmLdwhjCg5ND/t6TGzelobEaq/nNYSk8YiP5oA6X02IiPFnfsdphagzBAZUqgnrN9EWBt6ZDw65+SJy/t0i8cgySdMamxUpup088nASa1TZKZzlybWsPYYWgfEgfgUH8EVbq7VEBDCuGTCEy7rQj4bAbzNDrAbNK24/KnTd6nlrxiz2KP9akNDAeWhSdkuD31BxW/ApatZk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(3023799007)(4143699003)(5023799004)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUoxcFZHZkpKTTZVbjVFWnZpU0RCTndKcTBqaGZjZ2JNdzhBcVB1TFU0M045?=
 =?utf-8?B?N1I4NDNOVFRocTlFdDVCRzBNVzVTbVlnSk5veVlmVTZVNkEydHl1c0h6Q0Vh?=
 =?utf-8?B?WlRucXJrdWcyaHpxb1ovaTZvVzB5aWpDd2FiMWZxYmhQbHVTQlNwMjJSVlNS?=
 =?utf-8?B?WThIazJ3cFVBZWdFQzhoSnc0YnBzcm54ejYwV0dVWElncDhkd1c5UkhmTVl5?=
 =?utf-8?B?NHNDWkxQYWIvNE1Obi83RnRibGxwSWdMeEtGRThvemN0MkZNNXZybHBwMWk3?=
 =?utf-8?B?R1JJVW00MUZERS9IYzdZdjZrQlYvcU9TQ095WXhVcGJFRE5mSFFGeGJlamo3?=
 =?utf-8?B?R1FQOXFOM3gxZlpnMjEvV1Foa0NoVXRXZHRSSVJpbEgrQTlNbjVlSis1UmF2?=
 =?utf-8?B?SmlySmt0RjNlNThWamtTUnFaWWxJV0c1TU54ZU9wL0d3R0FIbEp4dGhwQXRJ?=
 =?utf-8?B?bERNZGVHUWJjWFpkUkNJMVpUdmQxcmJWajdlbytNaHNVU2ZuRFQ2bmFuOFVl?=
 =?utf-8?B?ekZxYzZRaVRNeW1XSXhkL3p0ZjdyQVFRYVgvUHJxSXJuTndVSlg1VEZ0eGpX?=
 =?utf-8?B?YnZWa0xYWDdtVHNid0t4TXdiS04vd3lGWlNCMnZtWkNYSXQ4anhqSTBnNkhT?=
 =?utf-8?B?dk15Zitnc3RTSTNLeTRXKzRjMXhVWEd3RW9UQmhwQXcwRE12dW9nS3d4UnNr?=
 =?utf-8?B?UzArTlJKNnREMEIvOUFWb3dtWmNwZThrRFVNSndBYzF2OGF5eUI2ZFBVVTFm?=
 =?utf-8?B?Vk5MTlcwdUlIZjhLdDNTay9FT3NEaG52ci80cml6bUZxa3NNblVOWldwaDhB?=
 =?utf-8?B?dHhNeWRZS1BiWWdveU5rN0FGWWdoeGEwT2F5V3EzUCtqTGkwSVBNK0c2SFNz?=
 =?utf-8?B?ejdqVVpGNXRFV3pvTGwrNzRxZ095bzhvR2cyYTA3WE5pTEJZd01TWE5rOFRp?=
 =?utf-8?B?TzZOU1F2amxMQkRFVTdJbitIeWpweGIxMkxwL3JyMnMzSkJkZzk5YjBYSS9i?=
 =?utf-8?B?NXNyL3N5VlJMclFEYWs0QW9DNmFlU1p2MzBlUWR4VWJtZWhvTStBQkgwN0xL?=
 =?utf-8?B?dVR5M2VWSDcxWHFYSDZBNW1lK3kxemRKYWZlWUNiVTVUbDRlcHFjQURhdzVU?=
 =?utf-8?B?YWlCL0QzU2tyc1hrVjA5ckZud1Fsc2RST2trb09MS3NzK21zaUNweFlQby9a?=
 =?utf-8?B?Q3FUZjFkZTR5M1U1TmcrS3MvL3B0WmN4RUJhRHlKa2kvckVUWSthT3d2cmta?=
 =?utf-8?B?NkVxUzdzSkhvVmNoNDZsN1VVUXExaHMzbVg1eWV4VW5ZNEZaZ0hYdTN1N2V3?=
 =?utf-8?B?VVlmSlF6QjdSRXNjeFVOZkZxQ2plOXVyckozUjdNOTVhSHErck9aSHVPYlNO?=
 =?utf-8?B?SDA2SzA1NThhZlVCNjVob2RicWZ2cW04a1V3TWdCYzh5UUZ2cnBxdG5oOE15?=
 =?utf-8?B?ejZDbE1mMlhPSFhyMkhxejBmNnhkaVhnUjVVaFdGYmtDWUhtbkdsOWJyYnpa?=
 =?utf-8?B?eUFGaC9yT1h6TFRPMEF6anVQdWJzVlJySWp0MVR1amIvNXJRUzRnL3VWVVBx?=
 =?utf-8?B?bGVONU5TZEt5R1JZY0MzYVR5MUpNRXREMkVSUUJJTk1yNGVCbDRzRUVzZTJ2?=
 =?utf-8?B?SFBTT1hjU1F0TUwwb3R0YWN6REM1TmtBVVZuR1lRYnZSYS94UXh1Vi9oTnlV?=
 =?utf-8?B?U2dBM0wwOW9INS9BZGVBTFIyRlF6K1AwcWpMa0dLNWZhNHFBTkhhVEhhY1hj?=
 =?utf-8?B?UitxZlI5eHVVVHFWZ2hhYzlxQ3NBaklzYnVqemhxMWh4Rk5aTmgvd1dpWWdz?=
 =?utf-8?B?anRMTGE5Y01xdTgxWG1oeURXejcyS09MWjl6TXVuK1NSalNNaGwwWFIxUlpq?=
 =?utf-8?B?d3pNWmhjbTVZWnk4dDJlK05CNzE4d01NT2tydG9ScTdWeGxOVFhaMWVnK203?=
 =?utf-8?B?LzVxdkVJY2RXcFBjUkZvTXhFSFpoN3ZPUGxGd1pjaGtLblhJUWF6My9Ob2Nv?=
 =?utf-8?B?Wk1tdDhDK3pBVG4yT3VydnZ6emViVG15OU04WjJ6RDdObFNHeXRMRlV6SDYr?=
 =?utf-8?B?aks4b1RXWU1qL0JHaEtPa2FPZDB0ajBva3hNaThJMXhQQ0xFYVp2bXhHRG56?=
 =?utf-8?B?SVZDb3I3Z0lHakN2NStWZGZFUEJPTFRpdldZMkJBUmFDZWZuRk1EVFlEWS93?=
 =?utf-8?B?U1M3cWJ4SWF5Vnk4VFljVytxVEtYaUhtN1JUNkpHcU9OSUdMRmw1L21SeGxQ?=
 =?utf-8?B?WWRBUkxKQkFjaWE0N2Q1dTVsWkhyM2pZSHFKNktibGVGb0JzMmR5emlDT3lJ?=
 =?utf-8?B?ZTVxZlJYdUY2VFJwZy9hWnZ1ZDdVS3p6N2ZxeStyeTgvcUhrRFRJOTNoelc1?=
 =?utf-8?Q?7lk4h4sVi+zMRsIg=3D?=
X-Exchange-RoutingPolicyChecked:
	l+XJL8krTpTJdxxPr5dtaR6OMTqOf9uadlpfeQtVx6+KuqWvxkkQHgwMfgFZ2tyCr7keL+oSl27KowhGlIArobceEn++FpeK5NihvtixNmM905N6y1FTdEtiF+c1c0W42pIPnTlnyRSaAdIBCVbRPyRpr/O1ICjh11P/HffsGp8z3wZ3Rrvm4ddJs4hSbuEI0uY8V9IfhJludJv3a1hyZl8iv71Xc5NzzARM242HlwdgW5QUJussUHLHi/vKP7IcPucXMmAOZMlz5yINk+aSmLillGu3tDcKWq+ySQIGuHRJBx1QvpeaUF31yF7WIZL0xxot1f4BnsAd4X93JPWoUA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nfVKJxrFgJ8Pi0cZcCQMxkHcSy+NoVHarS7JOZGXBeh4/WtIHCv2FddYe46Gx6pnLl7ssV9zbXHlCL7q2G+/QiLXUBmutUMKCtomykrcLbcZm0RrclhUPe0s6Ro+TBZf+98/IwzisKpHvYdwHndcitx24p2Orc8vQy5EYtnMydfh29xBOxEOdieXzfWnqgqmQ0u6RA12RfRH8/ejx4cIrHCCODF1gGIyHkg8c3BDhP1lbdoBHPgwP7tI7LxQA1nV6xrbB79pYLB+T1yynsmlObWC96FQB3r4YE6+hcx1NYBhxmjl670fv6CG6COAag3vZfACKqKV8AUY98FID5lFfWQ/t31pohXSAxMd++34HOyJhUtkzXKmzQnFPvTQwluac9tNZoswDGS8uSSkd4v4XeAFq/TO30DrIxbLM6wRiE0aYj+irrruHrpPDqtKC85kN0A81CMfRByqC5LnN7nHJ/TAJFexstoFg4Y8o3qd110ZiGIjBD/vDhezr/zlNpZYEsdhjRuMl9MqWBMwa8qHeH1QCI/i4NxiiJyDlXqzNahTsvUoXDk0M1fhFkLC0fb4K5gqLjldhuFZo93guqfYJ+oIpONuirat2aV+NSNyPNU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba206538-d125-407b-4e9a-08dee8a92f0d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:57:27.6225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgmHx8bB/OjOZvA+nOlQzYiJ7NyeVMkyvG+jHXpHuoBFOpBKXV1hHZg7UsFQlN5oH54TQKTIyZG7EoxwUkX6Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7486
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230107
X-Proofpoint-GUID: JU8wsLPdgcPFdvFoprXewOwvzdYwGpfg
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwOCBTYWx0ZWRfX+pcFyiO5ZPJ6
 jdqzFdMttmqtIUGA1zstWFG1391eigyM2SPrFTtvh8qU9OIp3F8a9ALh6x9ZUXBTGssqTYeJ3Qq
 7q5kV5wg18BQJ/l3rCl0nwbRolYTpWvG1sSmOYEpPJHPjpq7cMc5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwOCBTYWx0ZWRfX1Gs6aUUxoOUY
 slVhaP9iuGOn4UdraQoSLF3Ds2Az0mMPLXs30Y0LSgMoEi0gSaYJfuZiyQENtTnO5dNjsKH8QK+
 6hLbDnV+zVebd0qQ5d2cF4SxVQLdC8KiYxaPVWSMOoodPADRkIIapv2yPwC5HjEZUPKHdO2Z7MT
 I/XCT+lkGdvMy+MjG56FOEX9BGIUOtLdeQxkDUsId0INbLIMpJHOg0YRmrt2tr6GZheFa7R2UwV
 rbUeEEPOt2umYcT0ggLSi/90cXZCLFRnhe28443HDl/XbzSdC4fOtMWCOB3Q2rwOyMdNcvJJ1WY
 /l5GaL8O1oKIGNSeCv7Xdr8ZxESLKSGuvbFz5ZumkqiMRtx1vwCLeWayE4//imByNBhqbfGwB06
 C4CBOOyPGVr2Wy/HW7OhCFX1+OAbLPUUvFq6ZoaAhyq73Tz8nsCsiRFqSmgzrueVs1zR8Co9SRE
 E7vU0r5AWSiyDFiN5pFGLNjTucVP0eiaoPNpMUeo=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a61f39b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=u-alISF-cvSL-alsIIwA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: JU8wsLPdgcPFdvFoprXewOwvzdYwGpfg

On 23/07/2026 11:32, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] Unconditional dereference of `req->bio` and `req->bio->bi_private` leads to a kernel panic for requests lacking a valid block layer bio setup (like passthrough or empty flushes).
> - [High] Resource leaks and state corruption due to multipath flags not being preserved across request requeue operations.
> - [High] Use-after-free of the master bio structure (`master->bi_bdev`) after request completion.
> --
> 
> --- Patch [21]: [PATCH v4 21/28] scsi-multipath: add scsi_mpath_{start,end}_request() ---
> commit b237b1f6dbfe052243ff199e6fb756310c17d07b
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: add scsi_mpath_{start,end}_request()
> 
> Add scsi_mpath_{start,end}_request() to handle updating private multipath
> request data, like nvme_mpath_{start,end}_request().
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index e566d47199fcc..6c50fdde70d65 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -555,6 +555,59 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
>>   }
>>   EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
>>   
>> +void scsi_mpath_start_request(struct request *req)
>> +{
>> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
>> +	struct scsi_device *sdev = scmd->device;
>> +	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +				scsi_mpath_dev->scsi_mpath_head;
>> +	struct bio *clone = req->bio;
>> +	struct bio *master = clone->bi_private;
> 
> [Severity: Critical]
> Are we dereferencing a potentially invalid bio here?

will check

> 
> If a request lacks a bio (like an empty flush) or is a passthrough request,
> req->bio could be NULL, which would cause a panic when dereferencing
> clone->bi_private.
> 
>> +
>> +	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
>> +	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
>> +		struct Scsi_Host *shost = sdev->host;
>> +
>> +		atomic_inc(&shost->mpath_nr_active);
>> +		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
>> +	}
>> +
>> +	if (!blk_queue_io_stat(master->bi_bdev->bd_queue) || blk_rq_is_passthrough(req) ||
> 
> [Severity: Critical]
> Is the safety check for passthrough requests too late?
> 
> The master->bi_bdev pointer is dereferenced in the blk_queue_io_stat() check
> before the blk_rq_is_passthrough(req) condition is evaluated.
> 
> Could this trigger a NULL pointer dereference for passthrough commands where
> the bio wasn't cloned by multipath?
> 
>> +	    (scmd->flags & SCMD_MPATH_IO_STATS))
>> +		return;
>> +
>> +	scmd->flags |= SCMD_MPATH_IO_STATS;
>> +	scmd->start_time = bdev_start_io_acct(master->bi_bdev, req_op(req),
>> +				jiffies);
>> +	scmd->start_bytes = blk_rq_bytes(req);
>> +}
>> +
>> +bool scsi_mpath_end_request(struct request *req, blk_status_t error,
>> +				unsigned int nr_bytes)
>> +{
>> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
>> +	struct scsi_device *sdev = scmd->device;
>> +	struct bio *clone = req->bio, *master = clone->bi_private;
>> +
>> +	if (blk_update_request(req, error, nr_bytes))
>> +		return true;
>> +
>> +	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
>> +		struct Scsi_Host *shost = sdev->host;
>> +
>> +		atomic_dec_if_positive(&shost->mpath_nr_active);
>> +	}
>> +
>> +	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
>> +		return false;
>> +	bdev_end_io_acct(master->bi_bdev, req_op(req),
> 
> [Severity: High]
> Does this code introduce a use-after-free of the master bio structure?
> 
> When blk_update_request() finishes a request, it returns false and invokes
> bio_endio(). For a cloned bio, this completes the master bio, which the
> upper layers (like the filesystem) may immediately free.

will fix

> 
> Could accessing master->bi_bdev here trigger memory corruption or kernel
> panics if the bio structure has already been freed?
> 
>> +			 scmd->start_bytes >> SECTOR_SHIFT,
>> +			 scmd->start_time);
>> +
>> +	return false;
>> +}
> 
> [ ... ]
> 
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index 8ecfb94049db5..3ff425c5f1e56 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -60,6 +60,8 @@ struct scsi_pointer {
>>   #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
>>   /* flags preserved across unprep / reprep */
>>   #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
>> +#define SCMD_MPATH_IO_STATS	(1 << 5)
>> +#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
> 
> [Severity: High]
> Should these new multipath state flags be included in SCMD_PRESERVED_FLAGS?
> 
> In scsi_queue_rq(), cmd->flags is masked with SCMD_PRESERVED_FLAGS before
> dispatching:
> 
> drivers/scsi/scsi_lib.c:scsi_queue_rq() {
>      ...
>      cmd->flags &= SCMD_PRESERVED_FLAGS;
>      ...
>      if (is_mpath_request(req))
>          scsi_mpath_start_request(req);
>      ...
> }

will fix

> 
> If a command fails to dispatch and is requeued, the flags would be cleared.
> 
> Could this cause scsi_mpath_start_request() to erroneously increment the
> host's active request counter (mpath_nr_active) multiple times, leading to a
> permanent leak when the request finally completes and only decrements it once?
> 

