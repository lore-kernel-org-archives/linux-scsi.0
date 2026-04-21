Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA688C1F;
	Tue, 21 Apr 2026 08:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776758535; cv=fail; b=t5pLph6tjlnYx0sVZN2jM05UdknfiiiJxeeTCSgC0uXjjb97bMOp5CgcgcxjC+4zPxQJ/N2r9SWwHpmUYMrckYOPEf7SB6SJHqmX3jB4/3CN7YRj+jIj1DLvNg5LcKeNTFUMPBztEDhu54hKpBH7g6s06girrnbp4DO3uoTXhc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776758535; c=relaxed/simple;
	bh=Ae1ZgVFL1OHsiltQ5KHQs+D2gMvye/DrrPwbx83RMaA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vEIP2GS16JcoTU18WGdtBowFABy5xNdjLkaZDhpohxbb3068+e4n2+aD6NVXvRWlfIP1wChgTVgmYHdhiFYPD/165WkXyzrEHu9SeY44625jwX6xcB2SiY3z96kjxNciPGucYmKi6sQua1KKi07z6Le17KkrXreus71P1rjBEcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AXK5gysa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KM/Lc/up; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AXK5gysa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KM/Lc/up"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLu3Cn1333055;
	Tue, 21 Apr 2026 08:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U1luO+sPFrunLpIhqMIUnYSJlGvb5ktW+JMai2hKbNk=; b=
	AXK5gysa/NkN6bQFyc98azLzsjsiTPnJFZPPLIgAAmSpJxVP1fVssPdL+0Fld+EQ
	GatM8JVvD++yelf0MsP88Vh0sGkObFKRnCTm0WjRSpL/62tmFFgUdEuc9Ls7XSdp
	eDoU2NzBglCT1zMQ5yDw2yqgDHMfQGNQuiyn45C6uqiJXJET+ljp3ucVZuBUIUEd
	hD5EU6FC4ukmQOoXDKyd8/RadhMVCOtVMnuDFZkkXZuHebMWwoiZnwow/lmSE419
	J4acDwnHlpS+zJoY5Jmp4AHQn8C7pmBcAAgRoGtbbdTyppEzsmrAzSgFlUDF5Gue
	IYpFw67Vb/oWy2NGGxKAgg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm27vvvnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 08:01:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L81D9f011814;
	Tue, 21 Apr 2026 08:01:58 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012056.outbound.protection.outlook.com [52.101.43.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn1afqvpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 08:01:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ivrEuA6ikv+pj8O7Y6VLFBwRbOTSp7YS4XE/YGhHFKruWgSOsi6Yg2Vow/msB3SUryR5iYgJrBA3S6DPhHbTz4Ks4k4xMFVnlvC+SLKCmAQhGerKIgxumM+fhhSQgotpCU01K3b9yIXofsJLC9Ti2dJS9V4wVq/b65u/wXsPUoTVprUfyT9a2VaAY90lP7vbSCgSSgRHgPrJIgkSkR2aE7w89chL6YidZxiRVbDdUETBIJomWw5Hvtam/EPdGApMM+XJ0iXoHr+tfLMrBzQu6kCy+3SX3md9rFY/DVhHURd5BnXGJkR/sasmeIF26ehQSDsTuo7W9StyWBHVjNcbtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1luO+sPFrunLpIhqMIUnYSJlGvb5ktW+JMai2hKbNk=;
 b=vr27Zp1Ym6TPsu7BiJp5ZqO3QJvl7WSc9UtQIIp8yVAlrtiyskKrIACb+ULkMTqSVhyEPzmpoxe7p7t5IoCGcx76porZrPhybveFgBYfiPoO5ZyJnsp7qzXnnkz6BBLGZkwKBay4OxAf6hAQX6zpP+MnKBYSsJa38gr1L4HAE840iTfZulH5WAjJl2Vzh2NZ2wJldZnU+chtxZAM9FYiispVxG5EWMW0yo/8pTz39dGLvtQnsJLNZV61Cew9+X8t+4uAZ11JM+nFJYy4yn4AkLlDSnd42xVfIAzYGfLlE0QPEP5pY87ukZ0GJeisIZYlBjctg2soDjGvPkF4cNXI3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1luO+sPFrunLpIhqMIUnYSJlGvb5ktW+JMai2hKbNk=;
 b=KM/Lc/up5dcSYQ6eKj8gT7UNwhv1OcdXDmTchSJp1HFo/HHioslKXBJ/Orvb+/CDiNzkvVn4WxNMjCHzesiCLFIkZD9jbA1WenYz6gjAGvuFdl5Vn8QbPL/TjW16OmVuPjfOPvKbpuM+CwsPP/pFOZ4d9mQ0wMF726PqFoRuGac=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA1PR10MB7470.namprd10.prod.outlook.com
 (2603:10b6:208:453::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Tue, 21 Apr
 2026 08:01:14 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Tue, 21 Apr 2026
 08:01:14 +0000
Message-ID: <ff05ee4a-1cd8-4750-bbd2-8a8cbab59390@oracle.com>
Date: Tue, 21 Apr 2026 09:01:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 0/5] shut down devices asynchronously
To: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
        driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <tatashin@google.com>,
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
References: <20260420152608.6244-1-djeffery@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260420152608.6244-1-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0191.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA1PR10MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: cbbca136-1fae-4661-4d0a-08de9f7c28d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zEplyf6sN/cMIUK5wCNBGkpvMQCLnOY9MyFLhOaVXQxbtbKjw8xxPqMPLTmXXTVkHUaEDG6MSPQS+ET5A//fVh9UYiiIn25V9+ZoZcJPMR9EpPR3rv8KQ5rBPCCAO+Khm0yz1JhkR8IUrh2oBR0y0ljqWOBZVrx5hwHVPiCKeKkOsIjkXqV1XQ9xqxCunMIdKjH07A25+BRqxQtZEGoNoMTywShcW89nQIxb9Rq/FkMChF1vTvVYl6IDwpjrYL7uTVFwMp8baRqZJAjYXHbg1xog6AhTRJyZ9lqF6j7IONQkhPiBiUkc7X1CufBI1hp+rqN03SpT2P4N71yjQbtbzmroCFWcZ/nv4F3U9SopT95fF9HvOlaZuEgI3E6YJlkL74K+kfRxnsdGO00J8DFhH4CHaKPNbN8xsi4jOEqSexF4UrezFXAZK05qkgGcW8iuX66oDLqCTA8pNnPwloPqs/5rCdepZPsK7FcXdOFrc6s+E4kLsqnwZ7qW2SgIQCIFPoKRgD1+h11i21Py9KtZmIBDP1BxYRB4g67O5ckZyMq5RHGZt09+HncEbEmmEIDDwwZvmT4QUm9fm7hDATwMVxkjx8BNADUivsLuvD7lvJ5md3vEa4BwOY+IWzOE0ztmDlnfpNMm8J1vSQaMfJ8QtUIyFF7AgVieee6ihKstXQYo6BTzHSRXQqtYFLAgqPIxiP+QGlAUswJ6ot2+ZKZQqg3CFsduZ0ObW7HRdz42fdg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnNDdkIzVmRSTGNoVmpDdllLTVNSaWl2Q0hGeXB2enp3c1BFbDcxN3h6ejE3?=
 =?utf-8?B?MjJWUUdwT3gxVGlEb3FVUjEzUGRYR2tJaElEam90VW1aZjJ2Skx4Q0RpNTNM?=
 =?utf-8?B?TmlSTWhRQ0pPelR6enM2Wnl3UnJBWit1VkxyVzhQUFI2ZHlsUUU1dnhjS0Uy?=
 =?utf-8?B?aDJ4cEt2WUhQY281bkFEdExvYlYxWTBpRGNYa3YrdUJmZk1ybHRaU0lIUzl2?=
 =?utf-8?B?cXdiYlJlV25wekoxTUhlRWRNUGpFMkdGNTdxT1NJeHhrQmx1cmg2dUVJR1hZ?=
 =?utf-8?B?R2NHNTd1b2FFRC9FajltK3NpcUZSVGRnSEp2Mm1pSm1ZTWl4K1JUUVZMcTI4?=
 =?utf-8?B?c0Q2TjluRnJhd3k4eEkrT0M4T2ZMTFBxQngraG9rdzJsWGU0c01SWkNoWTFH?=
 =?utf-8?B?ZFRub0xCSzFGd21STWlsd1J4NXhoTDdaMWt4Yy9QdjRLc2tvMHdvSlltWUJ4?=
 =?utf-8?B?QWZ6TXBIRElzb21vd2M2akdzN3pRcGFOazVBSEYyU0E4T2VBYWJteWVzZi9u?=
 =?utf-8?B?aTZSYVdvY0hXakZhM2lBcDU4bDIvYnd5SEZPQmZFUkowNkNCSGkzWXRiemZn?=
 =?utf-8?B?NjlEbkY0aVk1R3ppZXgxZDhjeWJFZUZFcjNwcUkwOVJWTE1UVWJqajNPK1FL?=
 =?utf-8?B?Z3U3ZTQxTFpaTXZKR1FSSWp1K282TExIY0hib0FMTE5GNzYyYnJ1SGxIVXpx?=
 =?utf-8?B?blFIQTRaQiswbm5mMFpFdE5NZ0pJakt1TzdxWGx3cWFXNVMvZHZtT0QzeG5J?=
 =?utf-8?B?OTlKUGFmVzlsdEloaTJFUWNnLzBwVzBGUitkeFV3K1gvV2hWbFQ3ek5QVXNG?=
 =?utf-8?B?bkh5b0lJY0tYRldWU3VtNXlEZzdLWnM2WlU0WnVBcWd0ekpyNm1sRHQzdVFu?=
 =?utf-8?B?aW95OElGZHRZVWxpaGRqMW94UENmWWp6Tkd6cmIxMy91VTNZMktSQTBqTFRR?=
 =?utf-8?B?MUdKdUxrMnVLdTlaY0hWcXJyWFRXc3YwYWtDdS96Wi9oRG45SDVQUU1JTklZ?=
 =?utf-8?B?UWUyUmprVFhtMlBxaEZ3SkZwc1hJSGUzN043a2U1Qk55WDU4dHc3dVl3SnNQ?=
 =?utf-8?B?YWI1OXNtWWxIa1JsbjA4eHRBVmFtMUM4RFl0aGx2cG9kMENyejBsOHB4TW5M?=
 =?utf-8?B?bExzZVZWZVdQeVYwQzB6S09sN1AyWGVzak9WUkwxTXk4Z2JsU29zY3BEcWp5?=
 =?utf-8?B?UG5Kb29VR21Ua2VpZUtBcHFVdTlDT0Q4VVlKNllOSFlkZXpyQWp6ZTFiOEdL?=
 =?utf-8?B?OTNBS0p2aWM2MVRMSFRJYVAwaUdSUy8yUmxCYjdZY29MK0pRWWpER2t6OWZm?=
 =?utf-8?B?UkxURytzSWxWWGFEeHlpdmd3dlFQZWVWWW5BUXdrQ3JlZlUxakZzTmliNmZE?=
 =?utf-8?B?ZFJjTEJDZmd0VmJBNDh6UXV1UDVUUmRVc1h2dlE0VVlPamtsR2lPWUhyOEdu?=
 =?utf-8?B?RWhjSlFYRkswNkpoY0pJQ3Q4bmxkbjRZWGorbGxxdDk4ZVdpNld0T3htYnNJ?=
 =?utf-8?B?YVJBbk9uMnJPMWtwUmNWY0JqQTJwOWE1L01OUm83Sk5uRzZxNTJyL1dhdFgr?=
 =?utf-8?B?S2czM2VCOE5mb0s3N0I4Z0lQUzhGdCtrckMyVlB5R3pDcnljVzVSMTI5eVI2?=
 =?utf-8?B?MmVhUlBmZUlqWEI1UVNCWmw1cVV3SGN2U0N2VmFyVkt1djlFSVpsK3RWZGt3?=
 =?utf-8?B?M1BoTFZsUHlzelNIeS9nMlZxTEhNcFlBcUkrc1VnQkhQWmFOanAwSUlrclU5?=
 =?utf-8?B?UW9Id1R1U2htcW42SHpKSE9RWEVvZzgvNTBpL0g4djEyRE5nTTREUGFjRVZn?=
 =?utf-8?B?YnRtaUJwZUJXaHNjUzFhV2drWDZYbThxblg0Qm5qYUIxenJ4K0h2a2luaVVS?=
 =?utf-8?B?cGlRR3pUMzhqNE0zTHhQUlBYU1IySEVkT1lPbTRqQ05NaFFOaUhDa3JxZ3kw?=
 =?utf-8?B?aTdMZWEySGZMZXVVMUUyZHV4djk1M3lIY2JiT1JBU0xmVXMvOWpna2xZeEd6?=
 =?utf-8?B?aVZOTTAvTHBvYlZLVXB6eVp6T0thS0RxSHJkZHRDTVN6U1VmL2FOcFFIb3Iw?=
 =?utf-8?B?N210aG5oNE90YXZVU0J2UnJOTWxqK0pQemYzaGdDNEFzSFBzNUJ0YWhmNDlo?=
 =?utf-8?B?N1d1L0VNTElXUUVkWFN6ZHhlMUxucEV4QzNCcjVjRGRCMjJOTStIZXZhK1V1?=
 =?utf-8?B?TnJRd3VUdldDM2RCdDhBYkVuMkcySjRGZTF5ZFlxTlBsNG9DMjMzQWZ6dGdF?=
 =?utf-8?B?d09Vais0U0lzUi9sRHNrdi8rVXIyUVo4Vk8ydzVaejFsMEtyWEt6YlZCcUF5?=
 =?utf-8?B?V3VOalJIUXMySFBVVFJzODdHdzRRM201UzNodlFhQ2Izejd0UXh4QT09?=
X-Exchange-RoutingPolicyChecked:
	WT5a+SNsgRK5cE8dFeIO0ZhctQGsf5vR3gJ7JL/FURHQvS1k7i9pyMXOt5WYV4yLiKh/rsGR2MPT7ZkTjYmrmJbxIitFUlXFur1n1V8dgd03yTJI3mkQ+n/jKeYv96VLk+kUAxaaDAcGOrnrBypYEwJWAIlzwj3T6qxOWODY4Hs9Sla9RbqaWutgrvS9+peMR83Q7ZEzQ/sPtjCqN9oO2Qas1IbW/bLbqXMkKrxMesPvrQwdqZXMtK6yI1N2w9BDsFOzLkf2TiM7hnjbQI4DreQSbdMKgueFWMLs0mcrQ9pDFXjQfhOa9tGz0nEeDs6uMW5NOPyOd+zSuzAatCKeag==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SY4RNqQRfpsUn0nUSRFX5jGbhXH8Terd7JghOKtaTEtGiFUHem+jxwggK8g9nW4DhSBCMagyIGp+viP8SJRd1HSZn3cyEDTFU2WD4LoOlY6BrSQSQUcY+ohL93RUvob/mL7X/2WDGNN0K11MUsyvK5qS1Di+vkLJDclIGCS3KR7IWt19R+7ERpfIJcwaZdcV1i+jGzGTZtOGQ6EwTo+ivnGtwzivO/GCeyE5rk+grfavXRn8Saxj5OWkQV+G4l8uHyypmmzXh0UOXcSD7t5CDunrLbrAz7Zp0DCxllphiNmaM80wf+c5wNfaCqozYLr0UyLlWgxe6d/XLmDwKOr39hoQf7es6yqz8Ac1mOsN/LZYvlOwU9TVgcM2fIMKZWcUeGkl728NJGTQm2ncvRHzcaKSpPtgO22Fp0qgBj3OY8lX+h1NxbPWhieNoZwhYACeNbzyi7TgPE5Ea32tZ/Nr35Bg7rIWe9FC+a7x5z4gH85XI/7SscDUyTzpF0hzzzVPu/Q0LhMwxPVq+H1ILIcAQHa8gAY6rC4C0utWIxr+X8q656uSMjQ/VyxIBv5UMolsoDNrZsIA7pO9c+ilpKuKuyD/hBIxBPmm0fc2X5ZmBvw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbbca136-1fae-4661-4d0a-08de9f7c28d7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 08:01:14.5529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIcNMmawE7p5/Mi5opVbwHLX5IytJbf/S7XXeg6mUknOZMH3WqXtAF9YwVxsLg8bQtOob1DgcpB3KEDt1BR+pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 mlxlogscore=972 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604210077
X-Authority-Analysis: v=2.4 cv=JYCMa0KV c=1 sm=1 tr=0 ts=69e72ef6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=y48qp_fEp6yFt0aH7BsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0E9_ukf6Rf4IveoFr3Cq0oTCXBk70RBt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA3NyBTYWx0ZWRfX5ObmMYH/VRx5
 8vEgnRJaDuxQ0KfKZFOcIyMTQuwwshph6NXwLZrtJCQUANGvqCVXGm90mrvtN6uFyrQRFK++TNb
 nv77poyiq/vBujUtGECEJJHu9gSsSNcV3vLWsvUNNyzhXW/s35RRJw+NWVzIBCkdG5IKCHXVP3E
 hf+/7Wrawdfs6/9Q5QxY4a/HgQmylBsuBw2XtDp0fIqi+RmZmn3CFIoY6PcE5iH/SDhagLBRJ6C
 BJmkxlUQYkHz1l4dfMRfpXIP5RYDdkNpZoHnOuDOz83wAHXMH5wAmLUPxOt1FGGs+7Sm4ThJuib
 MSgYSf2u3KxovNbIyulKneyc4X+pa95RODv5Ee2XKMTM35iGGM6Sure5pMyMAmqT8UCbWh5TYIk
 oYEsAM3sWJ9dGX7P2qMUg67EZPkVsiGGsyeFS+iiELnMAB0jlqp0viaIkGL92DIk8CLsV9VIGzE
 zC3E4XZNP54BsqcIs3g==
X-Proofpoint-GUID: 0E9_ukf6Rf4IveoFr3Cq0oTCXBk70RBt

On 20/04/2026 16:26, David Jeffery wrote:
> This patchset allows the kernel to shutdown devices asynchronously and
> unrelated async devices to be shut down in parallel to each other.
> 
> Only devices which explicitly enable it are shut down asynchronously. The
> default is for a device to be shut down from the synchronous shutdown loop.
> 
> This can dramatically reduce system shutdown/reboot time on systems that
> have multiple devices that take many seconds to shut down (like certain
> NVMe drives). On one system tested, the shutdown time went from 11 minutes
> without this patch to 55 seconds with the patch. And on another system from
> 80 seconds to 11.
> 
> Changes from V13:
> 
> Remove duplicate flagging of async shutdown on scsi hosts/targets/devices

Please mention the baseline or branch that we can apply this. I tried 
Linus' tree, but it did not apply.

Thanks
