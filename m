Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42E13AFCF4;
	Mon, 27 Jul 2026 15:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166399; cv=fail; b=UF8iqaUYCyiByUsGku+NTYz0PP3G3L5rm4Kmn63qWd1E8O6dYPSShCNegaoSaFoN3luj8Q9HAIZfGoPDNDrWCA9SiBimdhp6qCQRNYKmioO1VAs6a9Z9erfNupH/tlJgHcFGSViao/1ksPWwmGJ8UJLCGk9VSkwZIaDfhxCulHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166399; c=relaxed/simple;
	bh=Saxd8z45AbeCNX4EwhGtkmjo+RZlzanibWFuyCzHnOk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aVmxHYs3e5l0B/Tg3tLHAOTqqTBc1kPuMQV5AjgP1xT2Btw+lfJHrEBFl9p8hKtHuJaBAX9M3TW37BYQ75cYkVsejRPdsYPKh5OrA1rtJ/Pp2dNvQNm0GpaKC4mewpYNi4XEIVcGgcabFoQdolnpjW41rRNpkA/bO5TWOEASZ4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JuV8WGFv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YnE7gZAO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JuV8WGFv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YnE7gZAO"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RFWo8i3375753;
	Mon, 27 Jul 2026 15:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0EgZZ5ksCpvjt1WvhJMn00N7ThZ5KVCkx4KEoabS340=; b=
	JuV8WGFv4iYRFJg15C8JvMZQPQ8/gh+rqz3iprGNCX+ymXB4b7m6XwstJ+Z8AB13
	zjp+KId3GBFkQQawh05Lu4fSlKHFOF1n1SQ74DBqmflhKz37BJcEDHln4olDSFxs
	M5JXhi9XMRuN8Lj9/gURof7v6GPW7sh3XBAVBpEmR54XQk3VF4RznOsEiG2FwvPO
	cl+dr/1ow3GrmwVkklDmR3oZLHtLqmsKVi4MFiLgWRCUlXaULLmapOi+zBHQqBt2
	qB/N1L4FargWh6FVr5Dc9kByyZHPHBITWyHZiDa7/Vp2GJn3dbqv3z0gdeX+aKHx
	jRTgDz0NiI15zVzfr1pA0Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyya2y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:33:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFPYI1007025;
	Mon, 27 Jul 2026 15:33:10 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6nk13k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:33:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TROj6+wwnqYSI2+u8ZLxVHtuutpU5ix2TsLfVHNNCQ50NpBJrSr/b0KQF/3NyxWrYFoZ+op0KcOwJ5XxFJYzDoxjwjNM03k/NbWVMFZSOIjOch/UkGMi5Ns3zhj3mgvUn4LfuRMP1ktzjvkBavK6i/v6/AExuII1NLvWaZmSkGPH//TmL5VKxshoeU/FqNNoS/8xXKmBvjUHT16QdsFtxaQuFFV+/pJAgRTYx+/1tqrN+rso49pWYyqc7Paem+SdvQXm8k/FTRcIgmZSudDxhgVoEtIZm09wsyvTma4qHBF7ERPhb1Y2+uRrSsqegVBF4Y5o0NNR/SNIz/oIfd/BrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EgZZ5ksCpvjt1WvhJMn00N7ThZ5KVCkx4KEoabS340=;
 b=TYANu7ZT7eLAdwT65I0l7rb0nqHYE78dLejxml3u1ZOaQVrXEFQ/tHwJN3GiKAetYsTIm23ZjAqejhLUkbXDn1UC2QfyKlgPt/9H7aH1PX7ZQR7mjC4Tm3KyfcKNpRFuE3zb8ZL/FkfnvFFMPx0NYp9v5lIKtjbq4rnpZqWmAXbQ5Y4+9Zps97xpsGSnsbY+CQLx1S0kxAsdCHnzXSixarE+h21dsGQbYzAf0/Eby69Lb2WxUwcsF2098VgSVWoJsNfN45xsi/0+2edWpBFdvuq1ykqaZouyAc+GwLHCfyFsIRCweE5V82RDXiaxadb2+b9Jw+dOXWAFKRdBulgIaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EgZZ5ksCpvjt1WvhJMn00N7ThZ5KVCkx4KEoabS340=;
 b=YnE7gZAOSx1D8f4KJlbKGuCZAT1FJVkOPGJ+4TsoP2XGBYjr+kyh/H8LfIRrFe9JCAsx1ItSHlWptg451MiIyxx67WftkomepuQiWeqeky/P+nfUUIQi8bGQxTMpYj4oJTi/BtiRN26YkkZ96Nz6WIhoZ9x859JNf0164yvASrQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA1PR10MB5868.namprd10.prod.outlook.com (2603:10b6:806:231::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 15:33:06 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:33:06 +0000
Message-ID: <2a3a595e-072c-4b5d-ab69-dad1a7ad0eb8@oracle.com>
Date: Mon, 27 Jul 2026 16:33:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/27] libmultipath: Add sysfs helpers
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-8-john.g.garry@oracle.com>
 <20260727150330.E95341F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150330.E95341F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0268.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA1PR10MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: f87fb85c-9855-499e-1a96-08deebf45a58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|22082099003|10067099003|18002099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	aFCHEY7zn98Glt1tygEzRxfLMLLMdGpahwFoJRvCaOuz7uRgYvURddKGXt6pW474NtTs8Dd7Y3gw0uOrGUgDSB3fUZbl3VvRl4sO9r3LTfUnthusl543jKMZFSVF1+SC796zqyRtLQA5b+xyVnfSRDRua7agBiLOim/jYnpVZQlb2iApn8eo8yBRNVyIrzQJo2q0JUnBNvIgpAuZEtKgqZnv4k8+7mceZpZgiraWalI5wVfNxK4qn8skl5WictHP4UiW+SAVumXEfdzUYHl8UylyxU3uBJK5GyZBT2mDZhJmzSl7WaLzaf8FGyJ9it6KgpCuVRFo2QNvS6dJkwjOCTWOGFl1/z+4sZDvr1MsHbyFx8bkQhOfmoZ2aOQTAwp2o4/aROXEQ2WMwYGBvtkeBQXMKRKM0QynMGLHWwKIcdngjUZ35F8ZBjs2FBEH1IRWq9zf+2LEObnUf6ellW57CJaRfOs1l9CXiBg8NeXvpdIOnqjUIOyAphP9dP2/lEtOU3+p52OUY+IMFTW25y6F7FDRfW145/XGcxZB2VNfaSqtPLTx+6YZZjxtVav5pLzixThYLskks6ejLofu/6h9Isf2cAOXmJFyeSmZw7j4KjU+Fgz/amNtmtFls8AmAwBU2R3HaTSFwVSDQRIIorRnMsyVzzI8fzUGWrpBvndJf14=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(22082099003)(10067099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFVKWXRvRnVwVzhuaC9Td2ZjcWxzUTBCOFp0bjczVkR3V3cwUEl3SGtWZmNG?=
 =?utf-8?B?N1E0VENZWGJEVTF5cmlvUHkrYllqMEFaZTB6YXFwQ2hlOGtreVU0VkZ6dUdJ?=
 =?utf-8?B?VlFxU0tIS25XRk9xd2dRcThtcGJkNWRrUEZYdld6WTRzb01CZnNEUVVBQmNj?=
 =?utf-8?B?VnUwK0dmdThoUlNHQUszZ2gweHlFOVFvclA3SThVd2JUeW10aklIL3I4Z3Js?=
 =?utf-8?B?elBNVnM4RUN3eUw1UVNDSEFFTWVPUVNONFNuaUs3WkpKb2VJeDVvaUVqV3lD?=
 =?utf-8?B?RHBjNXh5bVVJVzVNYUVpYkdYRnNzSlZwYzlUUVBqTnA3Tmw0anR3dlV5cEtt?=
 =?utf-8?B?c1BkYXpsbWlVVzhiVnpnbVVxVm5VTjJndFR6UUZsUFFkR0NMRUg2T1FjL0pJ?=
 =?utf-8?B?YlJLSjYrUEhubXJpd215QXBKWkV1eGQzVFBPSWVpSHZQTU5KSUtPY1kwTkND?=
 =?utf-8?B?ZkpvWldOSmMySzdKRkVKbUVOZ0xnd2ZlZmw4TTJ2azNzT2NUc2hMeHl2ZXBX?=
 =?utf-8?B?YlVCQTYwaEkzK1RPM0ovMjU1ejNsQTFSdHBvbnExVE9CeGJjRkcvREx3TU5s?=
 =?utf-8?B?Qld6di9pZGdZd0k0UG01YUc2SWJxK1NzZkhHWFlNbC9VYTNKeXNRZnlhVUxL?=
 =?utf-8?B?Y1ZCOGJQTS9GZnYxU3ZZbVk5dTRabTR1VVVBZUg0aVFrbjZQcVVQVGtsRUNR?=
 =?utf-8?B?MUxLZFdkeUhOWXRubkRDd3VlbXNuSDU0R1RBN2J3cHJQVVBmUWRLUXljejky?=
 =?utf-8?B?R1ZzdkJQRlA0dlZyUVk3cVQ3dTdpVFNqZ2htMERveSt3bXhIMkhmOURJcTc4?=
 =?utf-8?B?WjExMFVUbkVBZ25MQi92dGQ2YytGY2VGN3hKUVM2eStyNzlKQmUzRE94NU9u?=
 =?utf-8?B?V0FRZUl4bDZPNk84R3M4bHFvU1BHTkhDNUV2aW94b29aTHdLZjg3bnNMWXVD?=
 =?utf-8?B?bEdNWHRYSU91L2hWNDFGbFBnMmx0bmJhRE5ZbHloTkp4K1ROQ2x1SXVzdHUx?=
 =?utf-8?B?NmRkdjBDMWZ1QkI1NzlaRHRwM1R6emRpaDlQcXJLYkRVb1JTOGE2STJPMm81?=
 =?utf-8?B?MENwV2FNK2JyTHF5WTZSYzFIeGdqeTlNV0ZJeEhVMXcwTjdCU3FqTXlPeXJY?=
 =?utf-8?B?MkFRalJjNjNTR0Y5Q2YrcUpxZmZEczRIQ2NURWd3aEljenpieFI0Rkp2QUtY?=
 =?utf-8?B?NlI3L3ZSbjRrV3hJSExCTWc3YW5KRHF0Ynl3VVFkaFB1eHU2YkxMMTBKRytS?=
 =?utf-8?B?cWgxVERhL2NSQlJtYVVGMXcwVWhhdlp1QVVFaTE4cmF6czUxbWRjbkU0TWdY?=
 =?utf-8?B?cWt3ZTNMZGx2RkdtejhxTlprUnpPS1plb2xMV1ZxWWZiMFYwcGNPdzVSQmtE?=
 =?utf-8?B?UDZhYnJ0Rjl6eVFUWTJIckw0TyswbDhPZ0UxOUFNbXhGOHI2UGtIRSs2OGMx?=
 =?utf-8?B?WDVTUmx1TWZPMENiZFp3QzJtbmtqOEIycEluL0E0VzR3S09DV0xuRHRzNllC?=
 =?utf-8?B?UTFmV3d4SmluMVB5MmFRRERSc0o1VVBYR3ZxTUNZd0dNZElnOHZKaUhNOEl6?=
 =?utf-8?B?a2dRc25qalpQVHhWbzJ2bkdoQWRyQmhKVXFnYlQ2aVE3V2psV0oxZ2pzN3Nj?=
 =?utf-8?B?bmZub1dmQjViNHczZnNhTUFoUFBxUURuZG5Qa1ZIakpiTHhDVFNoU1l1R2M2?=
 =?utf-8?B?eDRIbGxtdnZGVWx3aXpYZU8yOFlsbmdXaXVScmpyMGozMUVaeVpnRTVueVRN?=
 =?utf-8?B?QkF3SGIyM3RLQ3Q5cm1IemlTdGVCTUp3ZXRKNFgwOTdWYzJ1Mlk4OHZsZ0hW?=
 =?utf-8?B?aStLaWZReCs2QWdoc1o5cmw5dXhNNHIwbEVaU2Nrc2NJYUpLUDBVbHUweFhi?=
 =?utf-8?B?TmdWWUErVlh2dk4xUml6SlZFakpUSzZXOHg4ZXFmU3R5d043Yll2ajlMZVRE?=
 =?utf-8?B?YmEwTWx3Y1RiZnRTVEtvenFKREZabzgzMlc1dmFiTSsxQzJPMm55Ynd5ZmQw?=
 =?utf-8?B?VE1KYUI5U3lXaXN6S2VsL1d0MGhNRkZYd1ZsQS8vaTdObjVlSGlyeUJTV2hn?=
 =?utf-8?B?ajRjRG5sNXMzMDRjajdOVjg5RkpnTDRQYTlUSWN2ZmU4OVVDbXNLcVJkVkxE?=
 =?utf-8?B?dFI5TWlkbWJ4NmVlOHNmZXYvZ3JtZ3RiY2ZRTDFKTlhDN0xEYjUzOCtPeCs3?=
 =?utf-8?B?UDVQN051c3ZJNWRCUXJKYkFzNWl6ejhnUzBxM0MzZ1N6Mng2RVc4am1LZmFK?=
 =?utf-8?B?SVRwWEVkNHM1cFRaN1FkcHlWT1laWkxWY3RaNWNYbW5qSVRPTTFLWk1mbWtV?=
 =?utf-8?B?NGRGK0JHdUlwSUVLMEJvam11MXlEVjNRRzcwdFkzdmlVbWlSdnhCTFdsMy8z?=
 =?utf-8?Q?YLqiutTpnlMIKHo8=3D?=
X-Exchange-RoutingPolicyChecked:
	no16HUUv6hSvI5mNsMeBfEGVJdakp7nf3Bl7pAwirtQulx0FNESNmZj89rN51LbckH02gJ8680oXxlT6yvQgHpIS8Rjl6bAumJGfp6gWTYETR1RCIKHgDuxmp2WOHpLYb6VWOIgFGq7orIg2vmvlh8evPk2eIMiqqeUS9eiLZ3r01yJNqBhAwPz0yA3LBfzs6ydulA356B65YMnh+mBmNDzN2P4grv1F175dOL6t9DaB+gPnC9HVHfFC00/t3dyim2i2XILjLIif/n8ItggqTukOhZN+hmWScoUOkxu0D8TeTAUiNWttMn//XNk2BErwFDBvheHYzDp0Q26gIqJeeQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KGKQTRuugS7k48aZ4zDmc/eVNlWkjXtaqwq6oGA5tFcfLFvxF+r/56k+F7LZnkXWoUJO0JoIMQx7nTRqeYINNz5UtkMl+M9JDomcneT2o71HhRZi5vFOxixWjZ1fRkL4YYMtOz+DWEkgmmph5q4TdRUKFwMx/Cjtm+3lSLPdkha/0I6DHDCy94Rnbs5PDnu7naBQegvEua4eTsX09mNgGfMzRz0hdg7k1FezHdM3z7A+ZXT04RyNxIFSYqpF2whzfbfTYLKFsJZPpV6tIWxIra6fyMJB/wcqbcYZw7epEdTilf+crXQIJSXK1LvSzt+uruknli0bFc/CnkoNw3bz+pDSLqqKadlJZJ1rVzhK9QSWzZCod8tABQY+CYSFcqVhou/EQyB5Rgaec+yMiCvmDj8AJ4jKbbdPPt20N+Pj2LKObqXdU3rOTvhF4OYcxyYabEhBeqgFXk8W22wmvRUkiDD1FG/u/I+1pvT9yeLiKDrV8VEWgRHKP6ziBArl0H5mpL4MWDDz5NydNORcrPXgfUkGgM5jQ/O0eAQhM0Mu6ta2hs/B6260KTmFlylxio+/Nv5klK5A4043C+VsTp7mxRrRitzxENOBMD8YqTrMb04=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87fb85c-9855-499e-1a96-08deebf45a58
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:33:05.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnBXqhBjSKvHCXrcIRby/v/KQjI4RKLmsNWsdVoy2HZkBnyId+V16sLvNQXtLBRDAOmbs2BVqy3SjQ3BxMCJjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5868
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=807 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270145
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfX4CXG93PTz8sg
 lW8vgrig+He3byxqitePCUXA2eTaFSF4+AmEgVLyAV3/Py6Wz97uZFB8FELz5NTKOQkWVlP1Mah
 KsSRvsJKTNOtvHqkaUkmi92kco2vqaxzu8IEUApEUEFjzEjFTRXH
X-Proofpoint-GUID: CMKjjVXivL68e6lYehATatebVBKtc0eY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NSBTYWx0ZWRfX1H4r0AlIwPbs
 M8RLgpFKojYd+F1FSIEOw1XqVhnaAs15FuXdghiD87uop4CzkPdfo8QQgx2uQS2bNLuimbMOlts
 8ZO8wkJ8amsr1dXWf9jhF7yJEz2RZNGqGt0k1TsSWWmQGZjHbI5xRD8XP9UBvzXQocas1SlHV/d
 JR9DHM++tZGaK1fgfeBCWhChgsVego9sPQx3Uj73FHdhQEsPls1nGKp1f8mut8U/Eh4Jd64SgYI
 zesHGOEPg3fchrly0gN1Dsw1LyacABJ0imlGRYtJtQMyLFFBs6mRU7VtC2yB+fbodzhc4ACjl0G
 lLw/qHV7RXKrgiYoaLvKs0/+4mvyAeLF6wdjmm6Mr2PwpZSh7pBWFLWEjP7HOvlOjq6AlMKdEDf
 7t7j9/inBbutbu11394yQayknVGrPu8KLYUXYxznJR8XRTpRw8pHy2AcWfSwY0umCZBcjBmfS4X
 EI/39BMRgZfMOrVFt0mydYslk8vKRlbjm3yc3HmM=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a677a36 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=KVw_TornvsTa4DbIXpkA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: CMKjjVXivL68e6lYehATatebVBKtc0eY

On 27/07/2026 16:03, sashiko-bot@kernel.org wrote:
>> +bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *buf)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
>> +		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
>> +			mpath_iopolicy_update(iopolicy, i);
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
> [Severity: Medium]
> When updating the multipath iopolicy via mpath_iopolicy_store(), does this
> leave stale paths in the current_path arrays?
> 
> If the policy is changed (e.g., from round-robin to NUMA), the policy enum is
> updated but the cached current_path is not cleared. When mpath_numa_path()

It is the job of the driver to do any path clearing or similar - see 
scsi_mpath_device_iopolicy_store()
