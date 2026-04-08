Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E797A2EC54A;
	Wed,  8 Apr 2026 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775663660; cv=fail; b=sJK3AsYK1kDIXH3TMpphb54/zv0MyyEXjetqQ3WiTGtJXcpi/fyMVWieJC9tp2GcwJGKAY4O/tP+Ma1ZJS6j7Uu8V+qhDfdhDClw0onRWzuXqBgZ2NQhw0IpBBjDEiezL59YqthCcGsdPOzsXappsVLN4XWGCWnLe+0eBP6hRuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775663660; c=relaxed/simple;
	bh=nAevaKzzg9z+kn97ggISJVHf7szqb2BVnCWXfd681Ec=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tzcGKStqskD1W8Zn6VTRRqxNviPVQrNiTAFLOfEj0mfMHfi1kaR1T+eLhMtUIL2/9nrCyzHawwCNEmlazr0wQK9eaj63Ex+0Rw9cud9iYFjnrIrqH0TcHSCLMcLnQBc12Cl0DZW2bdIgM7GrKUgonY4JBjc5gD4OuOMILXcwPIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BIkM5AJF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SGv3nzRz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BIkM5AJF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SGv3nzRz"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6386o5gd3711058;
	Wed, 8 Apr 2026 15:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6RXdx2a0OLosEW3qBE9TeBtiWxMrfGV3Yezk5WUDgbs=; b=
	BIkM5AJFVnEBGap2eFAn0wePVNFxboCThV0mIBkmadOCW5zmuPVfafVxxH4MsJ43
	GYI83aTcGYNb711s9klxiZsNOzBcH3SCxk5vd8ERSw6Ct8kNS3uf71GpAB84mC7E
	0MjcuEfvdw3Gv9rg+V3jOvsSdg9mrXcAvIs8rz30mGCqCWDpxA3J0ABJUaLBI51k
	SrcIyMo0eYReo/l0UgOBEpoRjX6bZeThOw5NcR7hSIAEt+j4RYlADPQBqXE+Grbi
	LoOn6F3BpRBrZxypzJNkb/CmrABQ4mb/Lmow+Z8dxDOLCVEcEW6c/VCrjKoiz/XX
	Yv7yO5CeqOqo5Nn5ZuucgA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqaku7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 15:53:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 638FdQ0o003539;
	Wed, 8 Apr 2026 15:53:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011028.outbound.protection.outlook.com [52.101.62.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5wws28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 15:53:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WBXaQjajidUU2bfuMjzvxiOPeSEiPivsvGAxo4AG3fN9GYPaT1QoizD74o/DHeioEQ+N440oA93L3Ha5P5F1IPVAxTEQOB4v5vDn1FpOUoF9y7dUXLWHhc4dpd3HUKhRn83bhhw9Bf0iXcsapkLjS/CzzRNFdMEnvz7rZJPfEWPvHE3kBW++Uj6vtcqPGQ2DBgAULO9MEV9/qOS9jRc0wmQyuwMwovz4ybRN/VUbZ4Jvm94P1ZaE4xHh0h6hhMu9kgf//nI/fn8cSJIjnbUfXWHnoF0M8er7urgkZnVP7mxKln852xWY4OIHJOylU4l4spUO3cfsBQPRmPB3opeWLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RXdx2a0OLosEW3qBE9TeBtiWxMrfGV3Yezk5WUDgbs=;
 b=E0bPP94cDpRj2zC0FrV5Vrr3cP8d2lQ1E/nDzETXLofyuAmgNdlxZFiwSJ9b+775DBuPj9CCF89HUhtu/SGqFtM/wj1m5L+ME/GaENK+ZWMwNMx9UsCZ9bLtlmI182qsA6siXtgCjeQsxHP2uNueByBxfMBzNvDeNbn6jJhgZH+O00Zf0pMGkpiwbuYz92WdOWmf/btD+uL2YqjaM1UxBQAABklJPSKpEunFBDVQVPgfjC5UrZvhzT3AU1hf1jzmvTR1GeA1Ime+8j8ail7Pj8OtB01AQxhx7n++NOGK7YIvxVCjUSyDK4qfbJtlGmES9n+VPEVcQBBU4y5pCd0f3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RXdx2a0OLosEW3qBE9TeBtiWxMrfGV3Yezk5WUDgbs=;
 b=SGv3nzRzvqPCq0077bGd8nMGDEoVgmtmb/daCiw4Qrg02OMQvFMlrTPLlA5TFokGdPu09gxECrmgXDBjMMPJh5hkMumd8pNGOVy9Pm4r9eMb6p4z660n2GTJEubw26Y9vPz9n+xyxh4xXHP9JGytf+mzZJqD72EimrRiE5mKXbc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ0PR10MB6432.namprd10.prod.outlook.com
 (2603:10b6:a03:486::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 15:53:51 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 15:53:51 +0000
Message-ID: <069f3f1b-8150-41e8-a760-f85a0b1b0ce4@oracle.com>
Date: Wed, 8 Apr 2026 16:53:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] scsi: enable async shutdown support
To: David Jeffery <djeffery@redhat.com>, bvanassche@acm.org
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>,
        Pasha Tatashin <tatashin@google.com>,
        =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
        Jordan Richards <jordanrichards@google.com>,
        Ewan Milne <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>,
        "Lombardi, Maurizio" <mlombard@redhat.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260407153532.6395-1-djeffery@redhat.com>
 <20260407153532.6395-6-djeffery@redhat.com>
 <c5cb8cf0-9beb-4bc4-8ce6-83b4544beede@oracle.com>
 <CA+-xHTG9tMCCf11NZwKfvE5xvCfjXrttDXhFsyz=SCofAc9Mgw@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CA+-xHTG9tMCCf11NZwKfvE5xvCfjXrttDXhFsyz=SCofAc9Mgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0331.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ0PR10MB6432:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e3f3cf-d5dc-401f-a8b6-08de9587076d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1yrathUA/8GSTnXwtTFH6Xt2340autTqSyeL0gaRbD7GfL41J9qc6uyfU5K/pwklUvbNIkgxYJw0O8tO0Z4Zdy7Dajh5KI4YaVoSCbfCpsizhdfwt3pC8ZCDUsOBtzZrhHFhmP0scQVl6sZh2wd4HL5ljsdcaKqjDC30dxxeCtY8Lto1etdKh+D8I1Bd/CYoqLYCA3jbXtZIeCPeHebQ0ShO8zHWJI1CUbgA0Ogl3Yi2ZBeD/nUSf1sMXx05r+ew19UZl/DHhJyOWhrtmA4GmdJTPwLACPrkDuSkLNVT6e+/vpfliHAZjf2t9ZKcPqOuMtCpHnVVHL0bcZk9B4hD4EPs43LC4x91OpPaWNIQGbGApIkDRurbBaL5InA3gjABPnZnTlfzAxeJr1Ka6qHNTd/bYTjha868vRU9ecYvXEdCzIpVIHzi6UaamTTkA29SsamaNJxDA+7ZBZEyj6v4ZbCeeM/pKlg6CqTVVIukohRyGXBG6i7+jylMTNnISuFApqMrIgVudqT0wz/XIUihTPuP5LF8TonnT29zaeHRTY1JgdlYVgtq61qPuDywVstkkrDLlRS6xoA5rR90UtllqYa7gsuqy1iTGG/WTjlpNr0y9Q2LsXlCzw998HV1m1izcZTyw+OgtUou37I54154gABlUr+Ww11BJJYOYrqd0rRDtbpecI+X0iPEZHT6HHir8wn8Eh3gcJ/qM6lxX50SCT8SCLAx8ZM9DXAIBZ4f+/M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHZjclovV2ZzTS9meXo5UnpDWGNMQm5BVHptcmlRa3l0U1JBaTB1OStEbXQr?=
 =?utf-8?B?MmE4aFZsK0Noc0RveXhTS0hhUnhHbHJKSnFvYm1WQmxrWUlidjk3MnUxZEVn?=
 =?utf-8?B?SkhsN05DK3EwcGRqUFNvN1JVRG54dXNXSkxzSFg4U0NRRnhMWDJrV0xpcVFv?=
 =?utf-8?B?VHJkdldvUEEwbGNyczB5ZjVYRWhRV2srRXRaMUJERWVPdXd3azRwcHVFTUZn?=
 =?utf-8?B?Nm5DemxBSllFelNXZXY1SUZuQ3k3OThIeGlGSnAvOXBLNzAwWlhLNEYxb2Nv?=
 =?utf-8?B?ZVN1L2MvTk5aTDdkcEdxaVJ4ekYrNldlVEgrWk5Dc0M4SUtSQWFyN3BuRSth?=
 =?utf-8?B?aUZmN1F1QVYxUndNQ3NaMEpuMFprQXNDZlJoZzl1bWZ1TzZ0RnhhcWJWVGtH?=
 =?utf-8?B?c0JQdnRmZU9kN2VqUTkyWGNlZXcrM2Z5RlZvNmswYnhaT1hnUWV4VXc4Y01v?=
 =?utf-8?B?dkttUnFuMHc1VVEreklQOCsrZnQ3SEE5cmd2c0RMeGExK1BKMkR2YWJBK25O?=
 =?utf-8?B?VUhOcEpGVFkzS0diaWpHakIzbE41WDFqOUs2cHN5T0VEbjloR2lRTWVSVkZM?=
 =?utf-8?B?aVpBYnRQeFBpa2dJTHhSMEZLclJUZ216MmNXRHdmVmpaWGNUNzVCY0h0ZUJK?=
 =?utf-8?B?Y25jZkJSaXMzMXVOWTVGdnFEL2RVcWp5RlFUclpjY2JmRWhUd0syTjVMVy9u?=
 =?utf-8?B?ZWgxVEdML01KV091aTROU0VkU0V3VGRDS0RNd0k2ZjhuSjdFR1NXK0trV0I5?=
 =?utf-8?B?N0NqaWJzR0tBZDhJT2xRODBvM3cydEFzYmVlK1hEYW85dDRJcTA2TnpQTkxS?=
 =?utf-8?B?U1ZXVHFlTk04OWlWM0NsSkhRSlBpbkRic1ZheThrenBMcjk3elBESzRsZ0hG?=
 =?utf-8?B?NFR2SE5CeTNFRTVIVytGRjBBUFBnb2Z5UWVnYVZ3eDdPa0Zya0pGblA0RFJl?=
 =?utf-8?B?amQwY3dnYXNkK2VzajBwRE5USUt3bzFxdWE4KzhLRFJsSUhOUythTGpqNUxx?=
 =?utf-8?B?Nlc4eG5YQm9NTHdvS002eDlTMU9YYkVMR1RuMUVNbklpaHl2TFZRbHBDZFRs?=
 =?utf-8?B?SThLaTdpVFdtMk5TaUloWnJiQmFxQXhGUUF1SGZObjFhSVZiR3IzTFIzSDAr?=
 =?utf-8?B?Q2s2clBPZG92cnlNTWNrbHNqbjdvVVNPWjJ1d3V0KzNpQVluN0VqMjZoMlkv?=
 =?utf-8?B?Tll2SDVENmlhNDdidm54OUwvNWIyUWUyY0FYYmVUWGJjOU9tekZMNVRxbFdI?=
 =?utf-8?B?WHBIQk1FaXJWaW9CZ05KZGJEVDR3ckV4UkJPbVVlVVNQVDB6Yjd3bzBhMndP?=
 =?utf-8?B?NEdXaFMzRlFrWTBiL3BxcHc1RFFCbnNEcmRIaUx5UXE3cUdXbTVVYUE0QWZ3?=
 =?utf-8?B?dmFJbjdOU0puZGV5WWIwN3RDNzR4U1pUdzU5K05HSktvaDZzTk5IQVoxQ2tC?=
 =?utf-8?B?T0RqbE9zMlNRdmNNUHVIR1d1azN1RWJISVNhUHNpTmNLTG4yb2NVS1d2RVpD?=
 =?utf-8?B?cFhHanNoN3VqR1RSMVFhVjVvQlkvQTFWb1BGd2dONG5Eb0t6cVVKMVNzV1Bt?=
 =?utf-8?B?eU9Ba3NvNGFSRmtONzZubXJUZ3VPTzVQYkphYjRKbytmRkRJTkxRaXNJREcw?=
 =?utf-8?B?LzFRcUVNNFBsOHNkZ3BobFY0TG1BUm55QUU4VjEwOXoyNm8rdkhKY3k4N3ky?=
 =?utf-8?B?Slh0QjhZV1NoalVOVFh1bUJTRVpaaGtWUTdjMFFlSVhzYmFzUEhwZTZpeHhO?=
 =?utf-8?B?aXpTSnVlRmtJQUMxbmNGbEJSZmF1NXZWUFhETUFkYmlLKzl1Y2s2bFoxQUxl?=
 =?utf-8?B?ZWtQOHEyN3gySklMSFIva3ppSXFqS3E4cUtKeWR1OW9tUnhGVUdDWHhRRHNX?=
 =?utf-8?B?YmlGSmlGZ0JpSTBKQjRyRENrT0k2NWZpQXNKaE5qR1BacCt3UWg5SkdIMHFn?=
 =?utf-8?B?MU5QaW5nOE1iSlJ1cGtRTjVVY2FROHVuSStyTldCLy9MYmZnR1JhblB3ODFs?=
 =?utf-8?B?TGNWRFlYVGZiSVlsTjVWZzBIdGpLcjZjM1h6TzcwbzU0M3BBT0tKWHJXdlNv?=
 =?utf-8?B?Ny84MC9lWHMzWnNOT1hDNVpSdi9CZEZ1RFdVd0lWaS9JYjVhdEJlUDlKYlV3?=
 =?utf-8?B?eGxBRVdLemNSZlc0ZU16c2YzdHVkRVdYdERydzdKR2VVWkhTMDdNNXgvZkVX?=
 =?utf-8?B?WGVaaGVPaGcwT0pPZVIvZHlpeGVjbXpDTWppYTdnRTZlTHc4djJhdktGSUxk?=
 =?utf-8?B?ZW9CS0FrZS9FMitiQkhRdEdGMUFCVWxpVVBQYmFtU0grMUVZSWZTYUl1cS9r?=
 =?utf-8?B?STJCbUFyTXd3STk4SjdQV0g3SUsvOFc5SmgwNnRtOXE1czZKcjVZdz09?=
X-Exchange-RoutingPolicyChecked:
	vAhdGPJ3oMYpzKN4X00FmU2SwXYdZSmlJRWRqni9rQGeRWbcbxXCG91Y1j5CEzTX15JgGWGb3Hz17gVQPXFvS4hifhvsyXOU9+NA1XhfBpzLztkHdCC7jR5bOlq2ytBSOxd/j44bGS2K8E1czMxIONOiJJ8zzIhgn89YToLZkM+VyFvEF0BT3kUqwurf6JOoy2lsj8GOu2DaUzBBM5/fW6Cf+xdBsFiLBeiL9RFj1lzZew4xMDU3+J13aagDIwIrBBEaHGjRFtch7h2oMIk/mEOOTO0Ozr07n32w7QP+s2rQt/D52TKEuqJqszpQatuszSBzDGHQ+4Rmv56f7xWBBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ROrzqbMy3aZioc3sMLT+IMnYoeNFQol8SgMRDrfIoltnYOchPugWXg79X6Lw2XC+vg8nJ3/U+UvQyAAQ+i3ULBITy9PRW9QnU0Yr/Mnp+sduD0XZFx3lEDBhqNb2F5gT1/VZbS8Sp70Hdre9ZHBlf7em/IPVwYIjPvh6zqLXa+t8T+jHFdud487FTla+WEarvpbgS7JaDpcWoRz6yOtz8RBqAQ+AWACBRWvkA15d/LyPexT8G/iT7NZ1Yd4Bb5NwGKAKDdQIQsSeYQaoWuT/7AOiSiM38K0kG32OCeMm49N+1IRExk14nyJJ/QBMxW8IY+cS29WXAxhSbfgUV92lgyhCr5SnFrbZbM2jrh1P0RHs/yQbqOfhKivfEhX4kdSh6Ad9SzkfRMcLKzl5PCxnFN6URsPWvaiKAR3FbKQddzke6piejNVL7jlmhGzG4dEzfsicZj7noeK5PQ/5dBAnAxb9apY18/vCr0CJImtyoSvfpt9ZXwkNHlouIaJaeGkyMPVZttaFtG3PtF2ofuSKPQMh5wyttlKf1KQpEye58OG5xqusp/q17eAYiifD5l/Tg0NYur3nVlsw1xkFtNUenyWy+O6BQVtPrVQkIbwCKps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e3f3cf-d5dc-401f-a8b6-08de9587076d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 15:53:51.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uauV8Smn+yLH+bDGt9UTRhgTv1PKviNWFjRTrRy5enbXwR4vYcqQgebp5/L2dqt2P1J0H0gNAY420tikCKbLdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6432
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_04,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604080147
X-Proofpoint-ORIG-GUID: pMW7CA6TvIHATarYVoe_EiCnk761tp4d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE0NyBTYWx0ZWRfX3jwGbqW7fEWB
 NcKFG6yroMxmlv6QC4a21pXU09nlFRJMgEgLOwqTbvkLI/gejCPKSYRj/zcIt51GbfwLSSSJuK3
 H7hV7uu32TXbq1FgMBlZV6RjFUC6nRhl7xITN8KU5kVdk0LQG2sG4fSZQIAmHHYqG//9i6WPpP2
 hxce9gkFLe6/ZU8g70EU65A+EcDM94R95vA4wipzewB61GAKqrQFWCQVqotxL1+rVzU99usVtHQ
 n9OERHZcuZdseP5fvU7KfZeCvgdpJsFacgEOeULL8z21y/ccn5v82t4mKEyY4suGun+xYm+ng8M
 0TwUmGotM2WprOtdi9NRFjHzIEfAx2anMWduhS+bJwJ1mdkCHVfis7w3Ecx4UoTFe5WW/Lkd+3t
 CFytCgb0cNHT6YCZRPlhY1/FvF/bvXzC9TPcPP7rpl0Vq379o8MzVow6IkKIbYx6X5fdlngfC2Z
 8iYbLdFwDrQXcSqzt1xU4yOoxwJ4emwibTciHPY8=
X-Authority-Analysis: v=2.4 cv=AsTeGu9P c=1 sm=1 tr=0 ts=69d67a16 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=VvkY2f9bBuQvh17hljUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12291
X-Proofpoint-GUID: pMW7CA6TvIHATarYVoe_EiCnk761tp4d

On 08/04/2026 15:16, David Jeffery wrote:
> On Tue, Apr 7, 2026 at 12:35 PM John Garry<john.g.garry@oracle.com> wrote:
>>
>>>    }
>>> @@ -1396,6 +1397,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>>>        transport_configure_device(&starget->dev);
>>>
>>>        device_enable_async_suspend(&sdev->sdev_gendev);
>>> +     device_enable_async_shutdown(&sdev->sdev_gendev);
>> We call device_enable_async_shutdown(&sdev->sdev_gendev) here and
>> scsi_sysfs_device_initialize() - any reason for that?
>>
> It was added to match locations where async suspend is set. 

Well it is not exactly like that. We have the following:

scsi_sysfs_add_sdev() -> device_enable_async_suspend(&sdev->sdev_gendev)

and

scsi_sysfs_device_initialize() -> 
scsi_enable_async_suspend(&sdev->sdev_gendev) -> 
device_enable_async_suspend(&sdev->sdev_gendev) when not async

Maybe similar needs to be done for this shutdown feature. AFICS, Bart, 
added scsi_enable_async_suspend(), so maybe he can comment.

Thanks,
John

