Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DD5441612;
	Wed, 29 Jul 2026 09:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316920; cv=fail; b=Wpk3LNsXKHnxAj0pRlnhNgFqlrq+QInKDwnNPv0H4MmPqyJtJkudPqLPHxbXWmveQHpFeo9MxZnun5fHFvkTho8LAY9r417FstTymGM8h+gyF7jCf7zPRrOWlPHZYDqJxezPbsYMsO4itdXhF0PdbX29lmJEowzhYh0BuPKYW2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316920; c=relaxed/simple;
	bh=OIbb5HYfp+Mtisc2YntmZWGg8f/jKy9d2QawDzr3Ft8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GrxRObpX10lORVDrC06HjKfL20eEhXz/RnALyNEuHq5kS1NXk17UrKyOXcwklPCiBdTZQGYXeDtFUykxbozPMLCcqKcjsK/yJJp7OoZAV1OSOs5pLlp9udR/6DVSXw9H4/A9M8r54sGL5PcGLqqrVjZxtNCIvQi67J7oB0qUneM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oJF2BWZk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XKeR/9CD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oJF2BWZk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XKeR/9CD"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItYKJ1094325;
	Wed, 29 Jul 2026 09:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=M+z76SNXE2ANJkZzIQ5jYJBXZhCQfINMEtguqkp60hA=; b=
	oJF2BWZk/QfAbyw+9vleD8dmMCmi9BP5Jjkz7nmtEGdTk4RUZHsmvwdvrF6kXHln
	96IeDYTbz+n/vjdEjj89eFvbwxwlnA3Yoz3PDIY7gx4JjXeEdG09lkWx/rYSKSH9
	x8+nU8RzPiKeLXBnxHZ/UQMMaHUuaZYskPWrpAlKKkEYFTQNpAIL3KK4MfZrjQlJ
	gygD3MTOq/OguwVSagQMTS+npFS2G7uMUxqWi1+asJgdxGbgoYvONz2BE9fPT5Ef
	3xYcZTjyXAMgYSHIiFkI7asmt8tF/65Bc3sQgnFtNiopSJASVCt8eNTKam5E9/O7
	Q2IIuXg/bWU4GQtTcZ27/Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5ftw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 09:21:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T9KbhQ029359;
	Wed, 29 Jul 2026 09:21:30 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6qqngf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 09:21:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GwP4aL0Dp1NYZxt7D4taMyNcDgNwzwG4gDMBDIBLLhJbiXiXMTLDxahgOHNGO4RMSFEPFLzT0FxXtm7uRXxWx5nUvEp/qHf9qazZWP+LKobHSCBcWYXPTUbjp/VTrJdCDBxgmDf0/1xKJLzvk+qEpJvf+KHCvhfFKO4LJlCJzW8CCc/MdMxVlNSfnP4vl3KUvBQH+w05ISDZoOLZj8nTgxMrSDMawe97mvm8Ep+jkEu9EaVeb2WQ09EoQ6DydQc1WMjMhm2GukTFM7uyj7YDjkninILIA4L2G0syw9AczQn0hcGb5QZjufycs4HDZMO1lZhjLa/53+dqf0MxIxHq/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+z76SNXE2ANJkZzIQ5jYJBXZhCQfINMEtguqkp60hA=;
 b=bX+XYPmXXxjlnR2ocqFMi1WzQ4o2wNo2ryo4FpBGjq8DLKhTAtPflifRcekM8j2d5FZ2bGPPx+EaEfNXsW3aBexp4W9CeTs6UF2r9L3PXfYTFGqG9csnczZbCjoLcF4i4SNkRQLnj7dsl0eY+7Chax4BDtwjLIakfPA4IyT4reO6yj2TvWfRv4nYWEUOGL39+tcXuIbgO8qFwqClw4+cpCF11oBZ8S5NjwsQo9lL/aoxc1URixvqa0p1jKZK3H4HXVXmYwLh4L76kHOxxjheSvnQV/c4ySFsOIs5idwefUVtVO3YBH/kPAmz1RjnDECMFnySLtx+3M6qpNtZr8JWrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+z76SNXE2ANJkZzIQ5jYJBXZhCQfINMEtguqkp60hA=;
 b=XKeR/9CDj5BBkSjuXMYSk593eQdAdIEyeCba7hyCvfgolUhtZp6Ns6/ta8DGCUecSghS/MPyMpGvOEaMPu7p3MEKXTAjOL1+1udehMtpP28+tOhWAoXxWMZBKvGP2+f4p6jQjrCnvpin0/tTdMhmxgvkX90mSPxObKQAyIl2+K4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN2PR10MB4319.namprd10.prod.outlook.com (2603:10b6:208:1d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 09:21:27 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 09:21:27 +0000
Message-ID: <df3b932e-9b45-4e1c-bb2d-94c17147cd3c@oracle.com>
Date: Wed, 29 Jul 2026 10:21:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/27] Native SCSI Multipath support
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0232.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::21) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN2PR10MB4319:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d926aa-c591-4ae3-ffe1-08deed52c482
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KgS4ThRxCkS7v89ttRf5hEtTIm6EvxwX7WpWPH1u9XTT9S1XyWdIHHugeQBIIss/aYNpaQ89J4t37lhJy48dzEza/1bTcyk2CmIQS+sucUPL8upFf3g1VWE3PTPM2d3JW9n5QIHxqFSTCkat/b79oBqpUaTY4lgZN6tkOmP8kHDGzK2ek8EeMZ6buWRhazpPlOpVNRaJgzaWSTgKO/J3kjB5IXJJohj83Gt1lhGhcFgH8wtxMRArcY9XxOw0m429tOubBHLnce4UXHu3Y++CiAMWYAzRBZ4i4RPZeA2vHYfqFZjTN8F0b1qje7kSYDsMY0DEbuX0Z+zQqhM5m3xYqw7+TxtNWySuepBicXvDPV6wpzWVh42Yx3ZyNIwyRFQh/1BwwLiEDyDndlM+hQhVk8eOSFZWWxvXKHo3jJUMsAO+An5kQx1g6V+gB6qoSs3F0Y57Ur4RepEggzZXIWroEsz7+IQqpQjaav9hPpwWi0TpEO3buMIkGOAVXrfgLFBFA1aFLj6vjvbZOqcGc34bR6/JvM5ZPjwGJwQ9f7BLQECNc8EWU00ndpQ51UIekC2Kvh5ieRnAwDWBmE0U9Acu8KRAZ+oBGg5n07TxYZVv0Iw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTZaTGF0bW5oL1IzT0VoRnB3UU1vZFhDSmdUN0xobjR2YlJIV3NvL0xIOTN3?=
 =?utf-8?B?eE95S1c1NWd2QWt1VTdNZnlvSGZHYjhvSU1mYnlKam1vOTNyMW5iVUdGZ2J6?=
 =?utf-8?B?SXc0MFlFaWJwZllWMWRGQkQ0d21SelQ5RGUycUt6dEJGcmNIcytsbXROanE0?=
 =?utf-8?B?UXFvRXFsYzFhbFJGbnFMclM0RmRRUFBzSWI3bXZhblhZQWhnRVJvVC9wSjdX?=
 =?utf-8?B?TkNTNEdVaC9HRWZsVzUzWkdRNTcvcXFMUUJ0M2NCUXdvQTNya3UvYkYwVXRl?=
 =?utf-8?B?NmhEajB2ZmN4REJITzJNVUhOZVkzYzI1UFlKRU5UNWtTNmRTMElDSWdHemdC?=
 =?utf-8?B?RXI5cmE4QnoyUXQyS29XdE53MHVuaThKQjFUV2lOMkY2MUxDZ05oMS8xSUNz?=
 =?utf-8?B?K21XUENabzcyWjdENDVaY1k5WkVMTElNZkMvWDNrVERzMVFVU1ZEeTZucGVp?=
 =?utf-8?B?clFBcGNXODhOTlRsZysvcDdXZHlzWERPWll1cnJKTDVCN2xtUjR5cFBYQklL?=
 =?utf-8?B?V2grMWlsZStBYnV1bDVFSkpkb0d1TTc0YVRBekpJNXJPdlZERkJ0T09zTlhv?=
 =?utf-8?B?VHFyQVlnL0lUWEp3dzFERnZzWE9WQVo1NytKS0ZHbjlrWkkzMkZSZTd4enM2?=
 =?utf-8?B?aVRGYTVIbENWUE41V2NXZDAvdzhNai91SlYvWnhEa1FpY2JZSUhFWC9XRm9i?=
 =?utf-8?B?bjFTSStuUEVQdUhIcmlwN09XZFArak4zV3dOK3dUa2wyZGNpYW5JQkFNandT?=
 =?utf-8?B?STV0clZ3SHV5dTZCVUhvREM4S3hVN285WXJaektzTVF3WXVlZ0p6eUFyZjZJ?=
 =?utf-8?B?SGRoVXYrbnZTdlcreGtldDJFSGp4ay8wMEdTaUIrMGRJeUQ5QnhnQ2hKazZT?=
 =?utf-8?B?UFpKYmFzUDUxanFvaks3UC9XZW5qTmYrOEpxVm42SHlDUFNmUkZNOERDQXF5?=
 =?utf-8?B?djEwWVlEc1BtdUZFWDhhSjBIU3U4ZWdrMFlMbUJCeWtFR2ZOVHFtZlY2dDM3?=
 =?utf-8?B?bmhYQ3Q5N2k1bW15a2ZKamQxMEM3K1A2T3Q3cGd5R2wrdEdadDc4cEkxUDZD?=
 =?utf-8?B?eEdINGJrYmc3QjF0U1h3d2V3Q3k2V0tTZFd3OVIvcHZQQW1uZU5XU1NOZlQy?=
 =?utf-8?B?K0F6TVZtODVNUHFGM0tQbGhCeDlPMWVrTmlkN3Y3Q1JrMzVaZzJCcWIyNXM3?=
 =?utf-8?B?SzJFWm4vZW5PWHcvQm9hYWJvOXNBSEtHNHJOT2RjL3ArdE9XODhpU0w3RHdB?=
 =?utf-8?B?aEIySmQ0MG5QL2E2eTh0dGNRYU43ZDAzRUpsalpXQ1dSU2VWdTNSUU0rd3pq?=
 =?utf-8?B?RVVLNGpiekkxMDFmWWtSdnJIanZjdFVnZW1jL1U2WXNueDUrSWtKSm85UG15?=
 =?utf-8?B?b09kSXlETkxGczExajNHZ29Jc2lCVjVxdVAxampNYllNV1VRaTBxODBOdUZt?=
 =?utf-8?B?cllqYlMyajQ4cTUrU3JGNjNHWnFWa3BSRDIyVjJBdTZFaDZJWXBQd2Y4MVNj?=
 =?utf-8?B?NUE5aCtvcDVHYUFjRXFoUkJ1dE53TTRqak5aSFBXdnFoRzdxUStCMkJCVlpt?=
 =?utf-8?B?dHBtdnBWWW8xUmdjdGNsZjZVNHNnNExyZjZNcjBzRVYvME05OHIwZzNtQ0hl?=
 =?utf-8?B?VmtqRzVQZCsxL0lqbzNOUGdpYVJFSDNxaFUvc0NpbFFhbkVEdGFrNXVVV0g2?=
 =?utf-8?B?U1FneExab0NnZ09kbVE0bkFFbVorVityVkRNUm1uWFZkQjhlMU1FTnNtYjJs?=
 =?utf-8?B?TVdoZlg5dkZlTitGbnRHQytjdkN2cWMrRjdESHYzWXgySGwvU3E4Um90RDgv?=
 =?utf-8?B?Z1U1TWoxOUpzb25BSmlKLzNYblRnRFY2OTFEUGQ5S1BwYUN3aEExOVp5UC9q?=
 =?utf-8?B?K0xsVFUrVmhvSzVmSDdUNEU2WmJEaTI4YlFBR2pMRTdLSjNzV0t2MDJta0xk?=
 =?utf-8?B?Ym1OMm1qSlV1c3NYVzJQckRBTEJJUGdBdzBIbmZHdG96SDNkS1BMckN5ZGNP?=
 =?utf-8?B?SmJkM2Mzays3Z0JxUVdCbU5lRmdJMEVVVUZjaC9xZHFaZm4reUFoZlpWUWJo?=
 =?utf-8?B?SHRlMGp6Q3k3bTFzL0hGL3N1TmgzcHZMRDVDM1NRaEZyRGNadmtFbjJ4UUVF?=
 =?utf-8?B?emVlV3AwUDgrUG1zODByWlpDSmQ2RjFjeEtUKzBzT20wNkFnUzMrM2ZVTUh4?=
 =?utf-8?B?S0xrU0JOTjB2ZnIxcjN4L0pxMWkwaHdGR0VGOXRTSU0rdHpMUUsvdFp3YVBR?=
 =?utf-8?B?L09SblRmbHRwOUZUVG1ObWxjTU95dUZJZGdXck9iYVVuVDFIa3hHNlJQRWFK?=
 =?utf-8?B?YjNDZWhINlJLV3NQQ2toRkFQWmtnOEJaSExxTEo4aDZ1SUUza24rZz09?=
X-Exchange-RoutingPolicyChecked:
	ngPtI2hh2kGqEq4LY+nPuZ7jBXIq/S3HzXOsL4LLHNExXJE69htJNO/eyfCDUQ1IB5iJphQppRw+WlJRWJQMlm901qEkmw2HkKBFRuVTolkEo9LJmDIuL8u48u7YjpXLgMCJud5n1lH2kUaG9I0LwoqmH26P8j83cyRsbAmqgdvH/3f9389fpM/TPa1HQj+4heJ8QHld4mhBhkzCP+tSw0wPHDBinwNQkuzDsAPEXpyuAn2ZL7l8BLfpfp0MsWKFKi4ZzNMjABU+36nuH0Q7toVgor9Nhl9s0eKUs44LK8JXC5Cs6rG42rU1KYz6MtXnyRo1jEqH+pai35ztKGdiQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DxeM/t022D2QlrRKR0yCCxV+fgdA9/28AJR6ObLoTGuM7hoDv3Kl26qCSSs0NM+spoEHuxuzGkD4XOxPp10VdeJ8LHMi2+eIK3YsDKWTKBrqUuD7MKHa7JjlxPH5sRn58u9/rsfV1+/RU1JJIkqlBdoaKNkMRiNfCY2s9QEJIgBlFD06wIMFky2cAdlJ6enLGuze3Iyu5y5r6ue6CGRRNmNQZ7e2JaIQz6xwf4uniX2KPFYLq1hTNnXtHe4gHFPabHvVg2bQ8t2ZTHFlS0YJac47119QK/xx9CE1RMWiyY3rCURTlLimoIEQWZDLk7CSMB5U3QiCnw16qYGxApyccEedBAktpfjSofotH1+nzeIWmRlj7J9v+zlXhdPd2mmSn/tdtiR6tt1iwu+hms3yMX+ZBPxx7zVaoi+RENiH6ByPSL639W39iqFSX9yKYTPSPZaE9ILS0hf0K/l/Um3FLovg2CTSBlIlMgucOJmsyan0odeql1JGSupJXQ3pz83+uk/X1UBR/8yFqtMKWdzwKxNSt+fYBMfjKeCcH5k2dSj294mQSWns4unpn7XG4izcytsrCZh6X5yKH5dFLi3xhqaC0bA6JJCaDAjNz2N9So4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d926aa-c591-4ae3-ffe1-08deed52c482
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 09:21:27.6374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bh44Zai5Aki63jyshevwCkEiNTAvObEStejdL2/uctZJMzTg8v5g4UIwnut5U0qegVpjp+iJUsBOABA97oWayw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290076
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA3NiBTYWx0ZWRfXxXBy7Fo2eojS
 M27+uukJq0n++KxpHQbPbPbLmtCKcVQGQf6cYJS7SlRyLjNcEgCgA8pVWDFn4MUeF7tUU1wIuGF
 HTo/1lFGtwOp9rfTkCvXWWMx0WTFSOWK0bniDNw8M3o+h6HWjfBG
X-Proofpoint-ORIG-GUID: ScAka3DRhIGZ9OADxbkS39Q1Gm-_EFgO
X-Proofpoint-GUID: ScAka3DRhIGZ9OADxbkS39Q1Gm-_EFgO
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69c61a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=c92rfblmAAAA:8
 a=yPCof4ZbAAAA:8 a=qhJA9r4x7ZXfWcY-Yz8A:9 a=QEXdDO2ut3YA:10 a=VxAk22fqlfwA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA3NiBTYWx0ZWRfX9UJ5GnbOnZsp
 oJ0iQzPltOXVyKvbqs0ASmIklxKMzdB0Jz5qQkHdYDP4rdVGSXiHlmZ3uC9vGITARwynLRu8M1j
 oZjxwgSaUthKsKQYg2lsmfaZinLmq5jQdZ0wRJ+lA0StPIZ8LO80XL8p8Hvjsgq3GjtEK+3wlo2
 e9+ytNGByx3KQFnBMlWy0at+tvH1eHnTtErt2jy/HPkrWARLsTLi1t6u1edh93dNklsJPg6nRDr
 iUkWYzTwZm8O6/lydbihlaez5wBwu3tD1vBZlN9SKZKVT1zKX41lX/pc9OSjShiQg0jCYtbrDpb
 ZlPcoxmX55+b+31TSAVYx6KRr68/cmOJSSpofFGR9fvkXiVmoEa9e3VNlIunBOXAlrKdAZn8aKH
 AKNJ8+FjeDNEgIdrniyDOo51E3/YQj4Ck31jJ4RupZa/tYwjZkEYEz3PnX13vaYSg7t9ZEPJRO0
 9rElxtHSGqbrkVQZouIP/b4wrwPplSIijKlx3Kkw=

Note that sashiko is giving lots of review comments, but only linux-scsi 
gets notifications:

https://sashiko.dev/#/patchset/20260727144234.3802948-1-john.g.garry@oracle.com?part=5

There's a mix between useful comments and not useful comments. More 
often not useful after dealing with earlier useful comments.
