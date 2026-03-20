Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB44C28469A;
	Fri, 20 Mar 2026 08:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773994522; cv=fail; b=D/X0/UjuBb3uRdeqxM6oI1TTxjHhSko63KoJl3sqtrtzkp2npiOub4LL3IOMhzXrflzf++qNUgTd3IXI58Fmw1eyvExm0zxX95+u9dPzGK4ty1plDOd8B9rN5dzr1su52vjmoRvMKXabpm7DUIWp4Wjv70YXbpmejB0uudw4qE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773994522; c=relaxed/simple;
	bh=wh+/9ginlPkPa1vgVZAb03s8KAEl2PDK7vBMEZD6OGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k+MIJgV03Ix2efVbir8ZG6TnGX5HM4SlWX6Iq6HRZ1O1YBfVBjyWB8IPrQUukkvkvlj1ILJM1u0ynNGQ+2oYLE2ja5uYutf9eA73cFmFtf/d6D4gsqh4YMzADn0VL0xmsGJEyB0dZrUXWtrvTNS5MUVWXwx7r3ZCO7/QuKiGpRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=mKLpxCqt; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="mKLpxCqt"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62K7nj652700881;
	Fri, 20 Mar 2026 08:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=wJwSUv+Pw+5jLmwnMK+kumVelTJTbUJinMV08s9UuxM=; b=
	mKLpxCqt9PAQyePAKDTJh41mH//1A7+FgzL7OHzyOdhDRemQWsp3IUAJcr+p7GEi
	76UTWO4llbNPBC7b93/iBvQgh2DP4XCmeW+wUpJlrQf2ycM45w8mpWocZh2zZuXF
	uZCcjHdvR9H53WsfBzTU2idP5Z66/RQm0NNCbKL8iNsLEmZ/qwCeEa4oa7f6oip1
	UNpnZOZeVO2YaR0Lsd68GjXWODCvIltUlmqTiGPSkGySYlDDV+HIjmGwU+IlBrW+
	0thsJ2do0PzoXqa5KUZmYdft6QDV41TuVBxU3Ti6TX1hmxvgEOaD27YOJB3Ak0Lh
	1iAp6W8jbUyz1UQ/iUydAw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010044.outbound.protection.outlook.com [52.101.46.44])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cxm66dn3h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Mar 2026 08:14:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THtasfQaYmO2Zo6ZymRnlx8YFo9ThHNWYyB1pEg7HjETvVsg0FNDFVgAAY6Z0o9Rn+qy2WVan3St02l9sF5DJFKgDqbpjHij+hsJTJEvqniZPnfMFluaYKBcnUBMLWuYr1DDmPIQRRkmMLxoGDFDe/CYa5CoJZqOoboPKjasl9rvLXF/hQcGPwjTrpJ40vjc2l3rTrWqN0cTUmiReoIqsx4GKYPo9l51LqqZcQuIaLN5BQyH5ruPNWdCxGRlwyIq9eyZnFo+k2Xlojv+4/1BM4FKq1QHw1urGzydDbn+FF4FXOD1qreUizuBsYB+q+x9Dv9R0Q6edPzCDG7Plhl32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJwSUv+Pw+5jLmwnMK+kumVelTJTbUJinMV08s9UuxM=;
 b=GzP18DAVqTvpav3pUng7pxrtjRcdz75Rec7SNcYW2owSWSsWTJ0Xe9O1yDgPccrDRtP7xFooWjnHoLGr7crW+Nbk9WAMapIMtQxgY/cXbA1/AYcjKcUJ2GbpJ5xRPwahZZFWB0l5cr3f6a8iSyyanoZFVq720t6Ud1b4xW8svviRXnjJl1WKlBCA1Vlhgy4dau3/If4u2O/FIgj8dtaXn9RUE9QDvliP/R+xutmF+Bd7iCkdwF1+5Uor53iyc8VdjJ9//oXNPMRC1MceRxyEVeRGUdL3quDGVzFBgX8UjZiKIxRB0MM2RvQ57ExP98R3JAmzTwQ8zvGE0yq4sFj6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by SA1PR11MB5828.namprd11.prod.outlook.com (2603:10b6:806:237::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 08:14:50 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9745.007; Fri, 20 Mar 2026
 08:14:50 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, dlemoal@kernel.org, hch@lst.de,
        ionut.nechita@windriver.com, ionut_n2001@yahoo.com,
        john.g.garry@oracle.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, sunlightlinux@gmail.com, stable@vger.kernel.org
Subject: [PATCH v5 1/1] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Fri, 20 Mar 2026 10:14:29 +0200
Message-ID: <20260320081429.42106-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320081429.42106-1-ionut.nechita@windriver.com>
References: <20260320081429.42106-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P190CA0015.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::28) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|SA1PR11MB5828:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d69b453-b398-43c6-a553-08de8658c1a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|1800799024|366016|10070799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	50qi4BpbUIzkyvRRZPNxW8dw5zpWDN6F4eyPlxTmJ6tbnVSn5TItQgiiNt+Ei9gGdIDRkMRN881xkSZ3BgNDrlzrbgDtEUvlgxE3yb5acfGtj5cgxrJVPZLhltPda2QZpBakcC21PsuLKx3ZsMd/FPaXxcoSBpU2+723tRbgMGlpxhgZZy4rpJ6h0br0YUg4ZalBMBIU4WkjoIO21A7tOLAdrQXF388GrQeehRGZe0iOarU0EWpbZh5ygIlrSHcLQW3dGK4oreo5V8EKEbg4c4NXy5ztxhYwBAaZOSOFdM7q9k2u0r0pBnuCAONpeFuGfuBam3UGdvDBwp8bK+2cC8SxWvRyA8TSRncKOMz3C9YxgI6AzwbWdHsEDmpqFyv4eEXC7NflfBtGULPEAw5d+wQhymCvyZubuPp0UWlJejHaGfh1Ir3iN6GrJiVSj/3W2Sm/mq4F4XEu73/HJQwwuCRvUNTjgM/+UMOOgPdRboAZBOAeaR1hWaGFBW+coX/iPwNRgoonvSgnx33mYq+k81wfMyadC5+bIpM4N1tb0EaugKb80DkV9At50xoJszDepDdzPm3DydCM5jfi+LoInA4mibKGRp82uNWc8B5MpMFKsN6P24LOHjd8bgy7CTntIEKJOhfXeBtRXNF4bcwz1KtDOTt4iUZmalnUyxidRB8wB7daodDJ+sHcH2OgQA/DFpwTcyOwml9QSyuHUP0485DvEHccAxLlFqhn3mVYr8E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(1800799024)(366016)(10070799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEpkd2ZrSU8xWVZqTE5jckNubU9sS21Qak0vdkhKQnNYWTZWaXVnek91Q24x?=
 =?utf-8?B?aWdUTHdnSjJNU3lGS0tVRmlKWk9MQlpVNXpWdmZhVTN6Tmh2dExGUlk1NG93?=
 =?utf-8?B?eis5UnZPaGhtWTRwSkt3Vml6YUZFMkpGTGF1SkZTV1VNU0JpS0pqblZYZG05?=
 =?utf-8?B?Si9SQjlVM1l3WUN6dGhuME1XL2pGZjNIWWZaMlJrSW96bHMvSkE4ZllEWGVm?=
 =?utf-8?B?T1p1V0Y4SkpNaFR4Y2VoMWJIRVl3bEhWUHRnd2dlcDFPZ0JaU0Zsdm9abzJt?=
 =?utf-8?B?UHM1UmtqYWtHZjBlNkd0eVJyTEU3TlJMK2hRRTdpSXNUZG5PQmNYaU1kSk13?=
 =?utf-8?B?YzNISG9NaW9lYkZXNCtpRVBNUUlSL3pPYjNwZG5taW9EOFQrYm1BWHdLaTNL?=
 =?utf-8?B?eklPazdLT3lkTUdLT2EwdUh5eUJzenFpVUxjenJ1U0pLelhlcGZmeGEzQUFJ?=
 =?utf-8?B?K2tqNUYrc2EzdEpYVDRVUUZBdm5zQXgxQkR0M2pPSUJJQnFSSmIwS2FLT0Ru?=
 =?utf-8?B?VFh1UlVRbHhldGM3d0ZXOVcvODQySmxlb2xWTnQxTSszWGE0LzVXMG93T2hM?=
 =?utf-8?B?UVA2d0tXanI3ZWRrWThQVDhEOVdsdjE4dmRjY0hYcjZhTHJDZGFPc0JpWDBl?=
 =?utf-8?B?czZNVnJLZnE4N3RHZUdNWW5xNEFHVk84Mm95V0lYMEUrY3dXY1d0N2lCeFJr?=
 =?utf-8?B?SHo0OCtTNXZCbkVma2ZFRXNwR2VxWkZuMFhybkNSRzNFR3JwaWd6WG9MQjZT?=
 =?utf-8?B?LzEvMDlhRHo3dldxb1V1MExOanhFTzBKb0dCM3BkN2djUHpLTFdLL2FETWUv?=
 =?utf-8?B?SHMvUklxa0J2V1hCbnJYV01FRk50WDhEWit2WGZCajEvV29kenJra0JVMjIy?=
 =?utf-8?B?eWl4akxVSTduZjc3R3ZWRVlaMHQra3FKWWhWbXpMS3VzdnY5N0FnVjkxVkhT?=
 =?utf-8?B?czI5VkE0TkJKTy92M1ZsNVdQcHl5SnlocUZvZkpkNncvTEROZVZiV1pJNkht?=
 =?utf-8?B?eHVCM0JJWEIvYStoTG5aNE0waG1vZnlTaVFndTYzcXRNdWNDbVBBS0dBSXRl?=
 =?utf-8?B?Z0ZMTmE3eno5MUdJTGN4NWxmdlJlQVVkK04rQVg2Z05vQ01oWCsyN1o4ZjZ6?=
 =?utf-8?B?SGdkOTJwcnV6SXYyeXJUOFRYSWZEQ05BdkFoN3dZU29kTVZ6SjVPUEx6WXY5?=
 =?utf-8?B?eWswb0kyUW9oSHorTTRieHR5R2tyVEJTem1PNXJ0NGJSUjlhWW5pT2VCckNH?=
 =?utf-8?B?NUdya0VLdExRODdyVVNZTE5UZmdUVWpuQTRWQmdUYWNRd1J4TkQ2dVVkM0tW?=
 =?utf-8?B?MWpIa2wxUHpjbHZZeXdrVXVvZE1KUVFJYUZJS1EvRnM0QnMyT0F0UkJXSDVF?=
 =?utf-8?B?U2VGK09DYWlHV0Z4VmJ3a216c3hKTU90WnprZU5YRW9tSXZlaFFiS2FNdUNG?=
 =?utf-8?B?VjhmdU5xWFVyWlpObXBBTGtZSnYxTnJFZDlIUTZuM2lqSHh6NVBTSWpGMzFF?=
 =?utf-8?B?b1AzMnRrcjJTZkcxTWNhVGhWTXZQN00vSy81ZGtqZHViQ1RQOG4xR0k4bmEw?=
 =?utf-8?B?bUhRNlNPRlV1R1l1ZmxEb0lpYjk3WHkyUDVsNXd4Y3FUUGNLU0tZSU9mdGVw?=
 =?utf-8?B?ZWk0V1dnZy9KU0JwTHA1bEVZY0w5MXBRb1pQcm9CMUZWS0dLRVpDY2ZvSHBt?=
 =?utf-8?B?VisxbC9GdmZCM2FXZzduU0g2YkJ2ZDBXZHFuazArekIwZHhZTjlPaDdIdFRT?=
 =?utf-8?B?N3c1OVdjdHY3V0d6Y08wZjdwWlVxN1Y3QUNsOUs1bjl1djVqRWVxYWFCSHFK?=
 =?utf-8?B?ekhSTGNBZ3RXd1ZRZ0NoMldrZjJ0N3g4ZnNhdUxoaHZKNUZuRGVpZktjbWdK?=
 =?utf-8?B?eGZBUjZ0dEVRdUx2aWN0NXB3UlJxVEdjcmVyMU1SeStyTUUzY1diQjBKUkJY?=
 =?utf-8?B?L2J0NEo5eVg2TlVzTkJ6bkJLYTdiUVg5V3ZMNHBlcXk4ZUFDcEFjajFjYkVR?=
 =?utf-8?B?bU5UMlRPckpvbEsxeTd6ckFKZStJSVp0WlhVbHA4ZHhDY3lYaS83N09KTlVk?=
 =?utf-8?B?bGJXaXFaNUpObDh5SXZVZk1VcllEcUFzSVp2TWRaeWdVeDBXaXpYd0pKNjBv?=
 =?utf-8?B?OU5ZOHdjbTNQZlRwMysyeDhLZmpBT1U4M05aR0FXOStUUXl5WmZuYUgyNk9T?=
 =?utf-8?B?SVFTdTJMUnpsdXFzSUJMNm5tTkF3eG1NRG8yWnpSUlVUdnF2Z3R2aGNPQnUv?=
 =?utf-8?B?ZzFvWnRlVGFNb3dUVUtvTzhVNGxZdzNvU2ZERGlKM3JhMk9OUjhzaUk0RGRz?=
 =?utf-8?B?Rm43UVJFWDJVYUl2TGgvUGVhVEVBMFFsUWhZTENmelU4L2JVK1VpNlJ4bjN2?=
 =?utf-8?Q?S5BczmxVkvUOuGs8cfBetLI2UppTAVeci7dO/pq5zTIAT?=
X-MS-Exchange-AntiSpam-MessageData-1: 9ioEN4K4t38P+TKJaeoZe5hJGMEq4iMXvUw=
X-Exchange-RoutingPolicyChecked:
	NWp6C1pM4QWHq9+TUMXuZpYZXsUrzWw4j0uI/UNupVlCI3qB/cKkhgDgBpHIspXsnVwsm+8lUNcFbVU3A9R6vmJhInyAFIRzBYySZQ2WzqlX9fiENnCYcgFQ5rPwU8cnykokq3E8yUZhP9BjSkVeJbaTnMZvh0GoBx/bOkmYn0Ws9MyOPOjGqUKa+KXrRurz7JBOgP7+aTv5KHr5+EJO965xjqoI1AIyfQs037FuoKT8Q+QSyfBn3dAEzzgm/XO3iEUA2/52C9wUV17vG3TDfZrFPd7sSzpSeqOEW/W5/ENtJhuMDgNo7fUOEKqZTeUA4BBK93hYAwSyDdIx+VPSsQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d69b453-b398-43c6-a553-08de8658c1a6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 08:14:50.1903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovkPPUzoPUOBvLHYfQA3eaBy0u744p+8+HnLntequFjHGBBTjOLNefeKHfFgySJbJGZMp22eBcII1YqCYKl0rQaqPyGGArk5p66qZ0gEIXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5828
X-Proofpoint-ORIG-GUID: wheIF7gIO-HBHuFUeJpFPSA5fIrEPSpa
X-Proofpoint-GUID: wheIF7gIO-HBHuFUeJpFPSA5fIrEPSpa
X-Authority-Analysis: v=2.4 cv=fLk0HJae c=1 sm=1 tr=0 ts=69bd01fc cx=c_pps
 a=feJg8xcwi6yo0k/5NfVkgw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=v1UvDAFQwqQqS176xjIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDA2MSBTYWx0ZWRfXyoj/3rcXbf0V
 GnPBjyRM+4stAQTrwrJ+vAmc09Xy/0r3ZEWY4Ipo9nKjJ2OKdYb78E8B9VPNiV3g1ALZA/1i6vG
 eynqIBdP7sys6Pz8dzdji1kXTaMjeevRsd3D/PfmYGxiMVfi9rj3p4LNq6bS98cyB/icjJXkvho
 gjWHdP/28LeQaQK/dLSJNEEZMOSYdoq1BUmmLuPaVFpC6uL0PyGE4bzWArk7dirO9dlDGtDU9aL
 W01UDM9uPnVTyaPpOmVhEljs778wHwkjGLkbDybaMfI3tCqzRsRBC0eBqXZIf16YT+pzLtSC1be
 3BrIwahlvc++wJQWFVSsA/1t32oW9U2wrs/AIfD1Fx4aU8vluxzxeB9IKD6jwR7uttPDrm3DWf7
 8jGKVaekIuU/tsV5HdW3VETqKo1paM/EFjpmY1kWwNAuwp7bbCq8mzDDIhZoml2bemPZKyBTKvl
 12BPkLNhvyQUAC2CCAg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-20_01,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603200061

From: Ionut Nechita <ionut.nechita@windriver.com>

sas_host_setup() unconditionally sets shost->opt_sectors from
dma_opt_mapping_size().  When the IOMMU is disabled or in passthrough
mode and no DMA ops provide an opt_mapping_size callback,
dma_opt_mapping_size() returns min(dma_max_mapping_size(), SIZE_MAX)
which equals dma_max_mapping_size() — a hard upper bound, not an
optimization hint.

On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
and intel_iommu=off the following values are observed:

  dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
  shost->max_sectors      = 32767
  opt_sectors             = min(32767, huge >> 9) = 32767
  optimal_io_size         = 32767 << 9 = 16776704
                          → round_down(16776704, 4096) = 16773120

The SAS disk (SAMSUNG MZILT800HBHQ0D3) do not report an
Optimal Transfer Length in VPD page B0,so sdkp->opt_xfer_blocks remains 0.
sd_revalidate_disk() then uses min_not_zero(0, opt_sectors) = opt_sectors,
propagating the bogus value into the block device's optimal_io_size
(visible as OPT-IO = 16773120 in lsblk --topology).

mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:

  swidth = 16773120 / 4096 = 4095
  sunit  = 8192 / 4096     = 2

Since 4095 % 2 != 0, XFS rejects the geometry:

  SB stripe unit sanity check failed

This makes it impossible to create XFS filesystems (e.g. for
/var/lib/docker) during system bootstrap.

Fix this by introducing a sas_dma_opt_sectors() helper that only returns
a non-zero opt_sectors when dma_opt_mapping_size() is strictly less than
dma_max_mapping_size(), indicating a genuine DMA optimization constraint
from an IOMMU or DMA ops backend.  The helper also rounds the value down
to a power of two so that filesystem geometry calculations always produce
clean results.  When the two DMA values are equal, no backend provided a
real hint, so opt_sectors stays at 0 ("no preference").

A WARN_ONCE guards against dma_opt_mapping_size() returning a value
larger than dma_max_mapping_size(), which would indicate a driver bug.
A zero check on opt guards against undefined behavior from
rounddown_pow_of_two(0).  The return value uses min_t(unsigned int, ...)
to avoid any potential overflow when shifting the size_t opt value down
to sectors.

Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
Cc: stable@vger.kernel.org
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
 drivers/scsi/scsi_transport_sas.c | 52 ++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 12124f9d5ccd0..a5207caf8565e 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/err.h>
+#include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/blkdev.h>
@@ -222,6 +223,50 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
  * SAS host attributes
  */
 
+/**
+ * sas_dma_opt_sectors - derive opt_sectors from DMA optimal mapping size
+ * @dma_dev: device to query DMA parameters for
+ * @max_sectors: upper bound from the host adapter
+ *
+ * When the DMA layer reports a genuine optimization constraint (i.e.
+ * dma_opt_mapping_size() < dma_max_mapping_size()), convert it to a
+ * sector count, round it down to a power of two so that filesystem
+ * geometry calculations stay sane, and cap it at @max_sectors.
+ *
+ * When the two values are equal no backend provided a real hint and
+ * the function returns 0 ("no preference").  This happens when the
+ * IOMMU is disabled or in passthrough mode: dma_opt_mapping_size()
+ * falls back to min(SIZE_MAX, dma_max_mapping_size()) which equals
+ * dma_max_mapping_size().  Letting that value through would produce
+ * opt_sectors == max_sectors (e.g. 32767), leading to bogus
+ * optimal_io_size values that break mkfs.xfs stripe geometry.
+ *
+ * A WARN_ONCE guards against dma_opt_mapping_size() returning a value
+ * larger than dma_max_mapping_size(), which would indicate a driver bug.
+ */
+static unsigned int sas_dma_opt_sectors(struct device *dma_dev,
+					unsigned int max_sectors)
+{
+	size_t opt = dma_opt_mapping_size(dma_dev);
+	size_t max = dma_max_mapping_size(dma_dev);
+
+	if (WARN_ONCE(opt > max,
+		      "dma_opt_mapping_size (%zu) > dma_max_mapping_size (%zu)\n",
+		      opt, max))
+		return 0;
+
+	/* opt == max means no backend provided a real hint; see above. */
+	if (opt == max)
+		return 0;
+
+	if (!opt)
+		return 0;
+
+	opt = rounddown_pow_of_two(opt);
+
+	return min_t(unsigned int, opt >> SECTOR_SHIFT, max_sectors);
+}
+
 static int sas_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
 {
@@ -239,10 +284,9 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
-	if (dma_dev->dma_mask) {
-		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	if (dma_dev->dma_mask)
+		shost->opt_sectors =
+			sas_dma_opt_sectors(dma_dev, shost->max_sectors);
 
 	return 0;
 }
-- 
2.53.0

