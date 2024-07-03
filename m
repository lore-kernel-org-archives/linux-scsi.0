Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E52143C42;
	Wed,  3 Jul 2024 10:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720002072; cv=fail; b=eST5aaCPSxP1zIlm27hG80JV/JJKGmw/z6n1aZaaz5g5GuVS1fvNFH5c1uFUkjmpnLdtajqqmHK4Qe8r4/I4b5Ixtf/ihUI/lUuXHT49SReba6xbRsml1haTY8ER+uzd4ZbYalYQ5n6uegUfMAhhUQCO6DrpWqPoNreITeia9p4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720002072; c=relaxed/simple;
	bh=0WvRHka0wWE6SKoWPLdXRKhi2z5otz30kwW0FMGAijM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SCLxuDtjUbdQS12UXUFFXdDhDBj2Ets9MrmnDFf2wUGtYB3Alf+FgSPFQufk4oDtc7EwLIFoWjOBvHbnN6hQ0h++tBNMxfIUz75A7zUJjmkisp6fGx1iD9cEFGHryd9939PWIeEqgSuEtGXS4jxsZ2ilvCbWK5xuR9puxFEs/GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lhflMizI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d32tsxhl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lhflMizI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d32tsxhl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4638OE0j015994;
	Wed, 3 Jul 2024 10:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=gzSOLHq/hoe+cUNKvMGjbb+Wx6ZQUE5q8q/ZGJMmk6o=; b=
	lhflMizI12L9M79n+DITsOo0mZ2g0yp3LL+uYfgPM0Y2iao3k/DJUNf1m6u9qlEE
	x2j5jVXm2g6vYo6X2NvyiCNvi8TMydGHrpXpilwU1FMzLtw4jnUtFHURu0dzUHWO
	e1WNeX+w60mwuRWPg4JaIG12z/LPmvZEJ3fg+q8M/mo03/fM8LLGTaBJ3RNmN33/
	FgcwrJObt6+uAH4eK/6DV+3jxvXKLIu7Qy7gu4lnPX7nbsaiQmHo0fEQQIr4uC/I
	ghHDHrQt//nkr0ewgkTnrsWQ+jC+zx05Y6Y4B+auxmwblazm4VyZQB4wrv5G4apc
	p0NWM+LXlzf61EnwGvUOyA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402a597n6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 10:20:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46392l8m035952;
	Wed, 3 Jul 2024 10:20:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028q8s1q0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 10:20:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESzhIQPh3t/86Sc0NJ9OGf3es0vgklA7rkAwiX/WtSaAZJ0mVNb4T6N027WnlQ9XKex1Vh2Hazcw+53bne6C+ucnMabHB8SaTfvqQ46iLykcPdY7YhKYAjZ+kdV4XEetRXgmUThKJoP0ajtlCZ472impS6kIAyF5xE8/Hn0iembMKoTO0X6cA7fRsAaTkB/Ot/dE2RNSUmbMQk+Qd1WB1uqRCHpLwKnXdOQjXozbMlLD8X5inxSBC0UN7bW/a/D0wS/XT9y5P7quqLcfQzAOw4Me2vgAbb06xFXZDY4tMwV5XWuJm5JQyRMA3cTTCDOPFIbPXO6aM+/zLzinWOn6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzSOLHq/hoe+cUNKvMGjbb+Wx6ZQUE5q8q/ZGJMmk6o=;
 b=Wzc+Ou2/nwY2daC3d8RGp96D+f33o67T3oAfpV94t4GVHY8lXzi0qydi2f0lfKhI38Y4MlGIL5rGbs3slvf8yEoTOkU2R719krkKtlDG89tHugjkLw/AmZazYrTLYfjV225TPRjyAJqDhBk9TkwjMSCrqnYcHjCBX1dIxb+W4pYamF6l20XNWxV4yZCR1NRXamWpCDek+uLowVYptLY93u2UioEw3ma4svksyKbWD5jd0Yr5TJnLUdxal5Fu9QRwMx0rkGY7+a6FFw5i/gzCD8Y0WyGPFQ+39LXDuqiOdq3Be6FqifHl+qe9sTIUdi2wnwK/Gvm4G+c3wZPyWMCMeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzSOLHq/hoe+cUNKvMGjbb+Wx6ZQUE5q8q/ZGJMmk6o=;
 b=d32tsxhlm8l/JgW0M3hOA09iAbefN44WrRpEm+1QF8W9lNIMMfuC8z0oX9Ll3m5Cydf+jluLQ3N2AovecGzgawv0mYVlKFcF/A+JfLagQiIPOg7mpS+dPRcUM7JQo1rBYlCWqs3pMDpqqkQ+PmDlYU4coIu8Es6spABTw95awAw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.26; Wed, 3 Jul
 2024 10:20:56 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7741.025; Wed, 3 Jul 2024
 10:20:56 +0000
Message-ID: <665021a5-b17b-41ac-9d45-792ad403f1dc@oracle.com>
Date: Wed, 3 Jul 2024 11:20:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] ata,scsi: Remove useless ata_sas_port_alloc()
 wrapper
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        linux-ide@vger.kernel.org
References: <20240702160756.596955-11-cassel@kernel.org>
 <20240702160756.596955-19-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240702160756.596955-19-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0011.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: f9a1c372-1464-4574-f63d-08dc9b49d366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?RTlrdHpldVlRVGMydlRzSlo2Q1czTWYvNktBbUV6emZnNEViT0I5VHdNQmN5?=
 =?utf-8?B?NnRPdnFnTkQrbFdFeUxOTFhMUHNxK2NxQmM0NjgyQTJZUGM0R3gweHhmdk9X?=
 =?utf-8?B?d21yOWNuY1UySEdSS2NyY3BQS0srckYwN0FScVJ6bC9mQ2NIWWx4a05ZcmRv?=
 =?utf-8?B?Mnk1Q056RVJ0dExBN2FtRWVoU2JOOHNvcjIwSU1rRWt1YnlzQXVEWXhFMk4r?=
 =?utf-8?B?UXRpdlB5TjQwMHhaS25GcGR0ZFRZeFh3am8zRUFwYUptM3FXdER4alJZWWJE?=
 =?utf-8?B?RmxBUmVxZlVxYkl5ZXhrSm5lRHZ1d01BMGFNWXZYelpiRWVTd1VIMktwNTlD?=
 =?utf-8?B?dXBxTVRIMDJQVFVLNHg2Z0FzLzZ6eC9DYUFwQmxGNlllT28zR2tjMHQ1UmVu?=
 =?utf-8?B?MUZSZSt4TVhnaU9UQnprZjF0TmxRSVJuUVRsTjlnQ2lQaWFWMW91cnJOUFph?=
 =?utf-8?B?cFpQVjYwSjFZRGVsUVMrOEZwTFA5WHZvelcrbHR4RGxJdlpXNGYzOHFUaU9G?=
 =?utf-8?B?ZDdCcXZibnIwZVpCd2lDcUlvdFhPMTZoR3RkcUVGSmY1WWZBa1dhMVRwMFVK?=
 =?utf-8?B?ektTVWZOd0FFUThjMDdLSGxCdEpPUlNlSTlkR21sbWwrWnJteEtkUHFkMlBR?=
 =?utf-8?B?RHVZengrUzl0UkEvWHlTMWhGcUtKSCtYbUZicU0zdFZZb2JFdENldHpJeit1?=
 =?utf-8?B?UWNsN0Z6WVFUcXR4MkVuMFd2QUc1cllOTjdtWi9URkZwakZLblRmcWhRWFZB?=
 =?utf-8?B?Z1k0dmFIaHBvZE1lQVo0UmwrTmxmY2ZNUzJ5VWZPdnZkdFNYVjlJVWtmRzdx?=
 =?utf-8?B?OUhLaGNMUWlOdjhzRkNaM3dnSXVYU3dWNVZzMVBIL3RmTllRYnlPMkVMSWow?=
 =?utf-8?B?dW5xTVAycnY2eWR0TmpYcGIzczZEcVlJZUJ1dWZlSlVreE5tazFyTW5xYUg1?=
 =?utf-8?B?R1prUGRFU2NaUUpTQUxwWmgyaG1WMEo3NUVEZ01ycjJvVG9PVFc5czEyZWNH?=
 =?utf-8?B?OXluYzNzOU9sOS83Qm51VlFnY1lFdUFGMkhrN3JNb1BRMTBpVWlYa1NrOGlU?=
 =?utf-8?B?d25nTmpnQi9RQnBtSUVRakNnK0JjcjlSdkxpd2xaMVdCcks3UXVBMU1jdDhw?=
 =?utf-8?B?UEpqY29WTks5MGVQUlZ3SG5OOHkyRHMxZEhNME8zT09tOUVNNGNJNWFPUGc5?=
 =?utf-8?B?dWtHZllsMTY3NTJZcDFIRmEzbHZUVEozTkNLVVR5TGZrekgraml5ZnJvSXhk?=
 =?utf-8?B?UzBFUXJqYnlJSTVtM1I4Y1paNWM5UklrbGhMMVN0SVBRenZBWVo1TFhESDZn?=
 =?utf-8?B?bzMxdmxQNkhDZjR6Y2t4Tk5tRWQ5dkZiTHdsVnVOaWJTTDBTUHZtYlE2SnNI?=
 =?utf-8?B?Uyt3bTdUVzZTRDgrRlg5dlkrSVplUC9KMUpabndvQSswWitVbU9TNXg1dlBZ?=
 =?utf-8?B?a281bzJYQytEdUx4WVNOanVSTjZWTFlvWnlyVVI4bndBM0ZsUVF2eTdwWGJW?=
 =?utf-8?B?V2tsT3hucmJOOCtVMlhySC8zbnVTZ0FrRmVJc1h2STlvSHRyWktVV2tCTEhi?=
 =?utf-8?B?RGRpNk9mck1zOE9uUE44TTlUMGJTVDNsNjdjU2I0VmhjcWRTV0lMN25kN2xL?=
 =?utf-8?B?amE3TmgyS0pJeWRKc0xySjRiejQva2ZIbkE1YW9KWGc2NzVPVTNvbWJOU21W?=
 =?utf-8?B?ZVZzeXUycE10b3A3a1NtS0VpSmpiaXJZVDNHZ0J4ZmoyV0hvTzFMSmFMZFor?=
 =?utf-8?B?eDhkU0JHUTJSWDdPL3lJUW1hcFdpN0Zod3ljM1NZbldody9FYnFrR2NISHU0?=
 =?utf-8?B?Q0Y5OHVJVUtjajZBS212UT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bVdhcktNdTFPVkxSeVY4eFdFdytJZ1RWUk94bDlSai9XNEJ1VHRqVm9mYzhS?=
 =?utf-8?B?eDRoYXk4TEovZXdYdXBJWFd0NTNIdmF1b1ZiMUpQdklPTHUrKzc3eU9HZnVZ?=
 =?utf-8?B?TitUaXkzaWJQODM2MjYvdWI4ZGlndTNqNURETGJOZFo5dFBSQ2VLODgzQVlz?=
 =?utf-8?B?bGxaeHpxRVNXVmtXRGkxTjlKUGozRHBKZHo5Uzh1bzlJaHRNbFZjc2NMNUs1?=
 =?utf-8?B?a0RJb1hDaFlOOS9sRDdIYllBTnRUUGZqakI4bFozT0kveEM1VldiYVMxN3h2?=
 =?utf-8?B?a0NrNDlSOUxhMkVCUkpVZ3Ayb3hCbUt5L0xlOS9aZ2NNK0RwVGFVZlhzejRD?=
 =?utf-8?B?N2dWT29nTys3b1JRaHhHWWpTdnBpVkJkTzZMQXo3a1hNVVZvY3EyUm9Sc0xq?=
 =?utf-8?B?Q0pKMlZxVDl2YUliRGtZMG4zbUZvR3FVQUYrLzJCZ0RQYVN6amRUcEVwdjIr?=
 =?utf-8?B?S1lQWXBOV3ZmQloyUGRGRzRqNFVTekgvS3NpMGIwdndnTkM4blVSYVRBU2xG?=
 =?utf-8?B?bEhQMGNaOUVwbktkV29iTlFkTFMvMVh0VTNyZlhYU2ZBV0VJOW1CaUF0R0Ja?=
 =?utf-8?B?aExxS01MczBIUlhBanBTWXBYdDFKU3RJZm9RcUt6cDdXc2R5UVRhS1J4THcx?=
 =?utf-8?B?bWpybW1WaFdNV0ZwUnhjVVNMT1R5NkVLMVpjMDJ4MXk4eE1CVGpaOEoyZS9M?=
 =?utf-8?B?dHRLcFhBRnVHYm5HeVhEYWJTMGRSaHBKbmpqOGxXSy9vOVdudVpTYklTdkc4?=
 =?utf-8?B?am15ZlRqWmxjdnczdGQ5R0t6R1k0OFdDMG1vU0ZKK3VJazhCZkw5NGgrU3V0?=
 =?utf-8?B?a3VVYVZDUTZSU3l1TUFIZVRGdWQ5RHh6MTNneEtBMG10dTZKOStWazV0ZUlr?=
 =?utf-8?B?ODZBRlBsVUpqLzR4bVVINkdIVHF6bWNHdnJGNmZ6dEtGc09TSzhoZTg0SlRv?=
 =?utf-8?B?YjdEYVIrQW04U1lkNi8xQzZzSHlhU1RRQVNBUUhEaWZmeWhkNk1oK2JNZnlE?=
 =?utf-8?B?d1U3OU93ZE13MEJsVGRVWDhKSkEwOE54VktQSW5Mc2NkTzZkdVNEaXJCc25R?=
 =?utf-8?B?YzNlK3BCVmtPK2cxTzdEbmN3UXJUcytpeHpPazkrQ3l6OEppWUMvRVVoRkdp?=
 =?utf-8?B?ZXAxT2tVSXRoaE91bzNGTmkzMGdOWHA4T2dJUnpTQTU0TUxDeEo5UFZRaGJa?=
 =?utf-8?B?OGFBc3IxKzRoTFNBRnRMazUwWGR0bE04WnJHbGk1K0I4TDN3c3Y1Qkdvd1lJ?=
 =?utf-8?B?OWE5NU5zNkhLb3dGUnc3ekZ4bXFCd1lGQUgzTVlOUDNUdWs1LzRUR1JGU2I5?=
 =?utf-8?B?RWMyV0NFeDNYYTlVOWJHN2JDcGxzSmNSZ0RzTWJnSTNvcC8rUDdia1hhb2Y5?=
 =?utf-8?B?cVZFVmlscWVzNjcrZTZQdnBSeUtMeVpnTFh2SzdaTDlFNG5YMHpZUUZhNHMz?=
 =?utf-8?B?R3JlN21vdC9QZExMSGdCMno5RWtqNTF0REFRUWcwc3ZaemZUd3pmWmFyRHFB?=
 =?utf-8?B?ZkgyQy8vdUJYdUkwaFZKUjBsSGZWb01nd21vbXllc0dvY1FJYzRNSnVsVGU2?=
 =?utf-8?B?QmwvakN2dFN6UzNZY0xHZDdyUDFXbm1mM0JFcE54ZTJWUEJZeDZkNmQ5Wk5X?=
 =?utf-8?B?NVl6ZDQ4dHpFN2lIY05UVlZmZy9keGp3TldpSDYzTGIwUmlIR2p0SktJQW5v?=
 =?utf-8?B?WHAwaFlvRWc5RDA4OE1yaU1uMW1OYy9QakdaZ3Q1NnJsQ0NtSGNJc0JDd0lt?=
 =?utf-8?B?TXFVYVcvbzZEeEJNazdiOFhGbXlXVVBEK1l6ajFZYUFySFliakpNRm9kRk4w?=
 =?utf-8?B?bzQydDlLaTI2Y0R6VXlPNGVwZE9mN2ZlSUZzWGdmVytaWkVFYkZDUmZpbmpJ?=
 =?utf-8?B?V0ZBRGN2eXdiMGRxMkcxaE92aEhkU2FPb2ZYRjJWVmxvRWJVZlhiaDREcDFw?=
 =?utf-8?B?RUlvcjl6RDVmblBzTzF4YjV2a1hEN3AweDN6SzU1NjNtaXJLM0ZnWXN4MmtX?=
 =?utf-8?B?bUhKVUJMSFZKUnIyN2g0blhCMnYwdjlyb1cyZlM2bzNUNWJZbGtzYUQ2ZTNJ?=
 =?utf-8?B?OUxybzhyMEdPRXhrdmRkV1lCYU94cXhUMTlXdkE5REs2M1l4Z2cvNlN1aGtt?=
 =?utf-8?Q?cu+oBzQEQbZsE2d7DlgWN9iN7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	FlS9y4tojkb5ywS4zOrTOZgXjLHkKWKKDpCWLPqqb9CFg5nu4/dz4bW806atHtE0XjjewHjwZ8f00qkIlPQNeZzdfOaBKBSzIF83LW3driMq3JaYysueHeOxG34ahD1d77aiapRSGhk8KJ6ZNDaSaBAY+3wthmPaFq9+bVe9UU8SO6wrHerWKawR7+9pGt4/pPAQ9g4WbuUGJfS9QMtj0G2gzks5qkOrZZpqv0bdLXphGjl1cHiZV31yL1Psu+x1pQBgEe+za/rouUvvajgCq/PgHK+2MoyzmDDlqcXSXgiSAO6CgjZv6sBx6m+gG5ZnL9egHnzT8bI6kE/+LS12b2+8/Xrylchjho9dRGg/+CM101aqWujuHe4WRdoaIcwGDyvDV2N13gxlDIqJ+2V1p2mGoWminS6k/pMUSMV/SLpiIT8DM+yPfq9nhnfwHDYD3Sb+WmKgBt+gk0m68saoDudw7sS8qUEOsliSSL55yqZprvOQoCWYUdWjpQdGSfSIRwasan2J4s3OB2sYi8DAzW0bkqfVh/F3mEtBmLb9d3X7qhdbgcny9LvOYhjx8ZTzfdA1EGUHkJuFgV5Uq3WusIrL+peN0IkxhwMQpY6/aAM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a1c372-1464-4574-f63d-08dc9b49d366
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 10:20:56.3421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ITgLtz5CseK6IvwJAHwBhptRefOzZt3oZEVWKD+OtSpII2turo2ro4nUn+iI5XC5SG9xT+mitnwcICzhGn+Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_06,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407030076
X-Proofpoint-GUID: YYj0xVdXoeR_V8yafzeRuT6zp9mbU8eg
X-Proofpoint-ORIG-GUID: YYj0xVdXoeR_V8yafzeRuT6zp9mbU8eg

On 02/07/2024 17:08, Niklas Cassel wrote:
> Now when the ap->print_id assignment has moved to ata_port_alloc(),
> we can remove the useless ata_sas_port_alloc() wrapper.

nit: I don't know why you say it is useless. It is used today, so has 
some use, right?

I'd be more inclined to say that it is only used in one location, so can 
be inlined there.

> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c     |  1 +
>   drivers/ata/libata-sata.c     | 35 -----------------------------------
>   drivers/ata/libata.h          |  1 -
>   drivers/scsi/libsas/sas_ata.c | 10 ++++++++--
>   include/linux/libata.h        |  3 +--
>   5 files changed, 10 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 5031064834be..22e7b09c93b1 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5493,6 +5493,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
>   
>   	return ap;
>   }
> +EXPORT_SYMBOL_GPL(ata_port_alloc);
>   
>   void ata_port_free(struct ata_port *ap)
>   {
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index b602247604dc..48660d445602 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1204,41 +1204,6 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
>   }
>   EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
>   
> -/**
> - *	ata_sas_port_alloc - Allocate port for a SAS attached SATA device
> - *	@host: ATA host container for all SAS ports
> - *	@port_info: Information from low-level host driver
> - *	@shost: SCSI host that the scsi device is attached to
> - *
> - *	LOCKING:
> - *	PCI/etc. bus probe sem.
> - *
> - *	RETURNS:
> - *	ata_port pointer on success / NULL on failure.
> - */
> -
> -struct ata_port *ata_sas_port_alloc(struct ata_host *host,
> -				    struct ata_port_info *port_info,
> -				    struct Scsi_Host *shost)
> -{
> -	struct ata_port *ap;
> -
> -	ap = ata_port_alloc(host);
> -	if (!ap)
> -		return NULL;
> -
> -	ap->port_no = 0;
> -	ap->pio_mask = port_info->pio_mask;
> -	ap->mwdma_mask = port_info->mwdma_mask;
> -	ap->udma_mask = port_info->udma_mask;
> -	ap->flags |= port_info->flags;
> -	ap->ops = port_info->port_ops;
> -	ap->cbl = ATA_CBL_SATA;
> -
> -	return ap;
> -}
> -EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
> -
>   /**
>    *	ata_sas_device_configure - Default device_configure routine for libata
>    *				   devices
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 5ea194ae8a8b..6abf265f626e 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -81,7 +81,6 @@ extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
>   extern int sata_link_init_spd(struct ata_link *link);
>   extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
>   extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
> -extern struct ata_port *ata_port_alloc(struct ata_host *host);
>   extern const char *sata_spd_string(unsigned int spd);
>   extern unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
>   				      u8 page, void *buf, unsigned int sectors);
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index ab4ddeea4909..80299f517081 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -597,13 +597,19 @@ int sas_ata_init(struct domain_device *found_dev)
>   
>   	ata_host_init(ata_host, ha->dev, &sas_sata_ops);
>   
> -	ap = ata_sas_port_alloc(ata_host, &sata_port_info, shost);
> +	ap = ata_port_alloc(ata_host);
>   	if (!ap) {
> -		pr_err("ata_sas_port_alloc failed.\n");
> +		pr_err("ata_port_alloc failed.\n");

nit: Are these really useful prints? AFAICS, ata_port_alloc() can only 
fail due to ENOMEM and we generally don't print ENOMEM errors in 
drivers. I know that we change the error code, below, but still I doubt 
its value.

>   		rc = -ENODEV;
>   		goto free_host;
>   	}
>   
> +	ap->port_no = 0;
> +	ap->pio_mask = sata_port_info.pio_mask;

Why do we even have sata_port_info now, if we are not passing a complete 
structure? I mean, why not:

	ap->pio_mask = ATA_PI04;

> +	ap->mwdma_mask = sata_port_info.mwdma_mask;
> +	ap->udma_mask = sata_port_info.udma_mask;
> +	ap->flags |= sata_port_info.flags;
> +	ap->ops = sata_port_info.port_ops;
>   	ap->private_data = found_dev;
>   	ap->cbl = ATA_CBL_SATA;
>   	ap->scsi_host = shost;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 84a7bfbac9fa..17394098bee9 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1244,9 +1244,8 @@ extern int sata_link_debounce(struct ata_link *link,
>   extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
>   			     bool spm_wakeup);
>   extern int ata_slave_link_init(struct ata_port *ap);
> -extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
> -					   struct ata_port_info *, struct Scsi_Host *);
>   extern void ata_port_probe(struct ata_port *ap);
> +extern struct ata_port *ata_port_alloc(struct ata_host *host);
>   extern void ata_port_free(struct ata_port *ap);
>   extern int ata_tport_add(struct device *parent, struct ata_port *ap);
>   extern void ata_tport_delete(struct ata_port *ap);

