Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9A0235045;
	Tue, 21 Apr 2026 07:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776757618; cv=fail; b=OewMfFZUL4w1q6wDIKJ+HfG1ztTpgdEMI9oBpQx6kGFn/sQwsz17j/jPvPpb3LYCe+gmmKeIir1RkunQNYvg1sZo6W9igT1FKKlEybJteNI++MGQZuxquKrFOojwHwrIXEbwEwPu849wpXHu8nvuZNar3z9uOlxRlIWUBmrxNaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776757618; c=relaxed/simple;
	bh=H5V9ZsTb+w3hHi/UnQTtjkL+JRzuq2xQRhr4IAkdUUQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HDvwTr7L9FHk447MAmrYzOCkpOGvKM9uWqToDny2/bz0MNk71ZmtPtTAfoxrDZ3m6vb/Cvn29YY+ylhO460GgInAYRL35VMqn8EhcEAkfG4rVl6uBeGqLRjcJj+YwI309Pzn5SbNziJrqWULBjpMBo3pjQnBPTA0buRUPfyj1YU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Elg0/8Zo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EZ9Ebvk0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Elg0/8Zo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EZ9Ebvk0"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLuGVU1333528;
	Tue, 21 Apr 2026 07:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=I4fTP6tt/jUKhQuyzQdDkXe3VJ3tPs+dF5AE2+j0lnc=; b=
	Elg0/8Zo/tEi/0TmBdbjuSuhLrCVW81dKVLPB5dxag1oTHg9LLr6NyauhRPRxPty
	Xjf77qepKWz4EDufRMbvq5Xw1G6uz6HbRu/WcFox3xoefrV67yoXdBQoSjhfb54q
	hauCoyfGTB4MIGzEdShXAlKoUVFljLyfIkwyCHr6VomU0hA4W3JJOLe8QJ4uPs4C
	Wz5GhRX6+IP02RELqeFojnqfq1+HodwaRyCQlNq3vOU3Wm7N6nU9LpvLhtN+8U07
	1b2DFWT5OoYHZc21CG842bgh35brIt55i0EjS1TTcLUdNZLfYqq9oXc1D8vNj6xT
	CF+iOGrL8bjiY19dsvq5Kg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm27vvv39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 07:46:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L7k8MD028042;
	Tue, 21 Apr 2026 07:46:41 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011024.outbound.protection.outlook.com [52.101.57.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn1887vyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 07:46:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQ80+RgYwRE+Eso63q2TJmv06MjD2Zxt4J3WlvcVWpaQw++16JzfKB8hkocQtStW6tTWjT+MTBK8e7cC2ofDj7IIozwsEGSZzkQY5PZgMbINIhoxL3Km7HVx6gllRbeUGyr6FuZaNfbfSdZtwQy/YpgUC3br8HShzfTOXSvY/dZzcgGlJEtiLtok9xbKsSnBIAs82eFAMRS0eDhp91mf7KiRgECrAxVWu5AvxtgXnBycfqKSsNvB1Ku9TY04kXq/M6Kv8ALS38HpRTtCjcit7w1gh/IGRtjHkGvr+vV7EzjxX4JyWNSWruDx8WonhJGMBUiB7oG+itZL+mcCa1nTog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4fTP6tt/jUKhQuyzQdDkXe3VJ3tPs+dF5AE2+j0lnc=;
 b=HhTbd9XyDgDqLuVSPLOUr8l5PQ5o3eeFhqFXcQwjELDtov9DrGtqtcYlbIreHdHomjhSVPVJ8u9Ye5Tf3AansbdI8jnmcBhZdr5FDT/aCUEWtxdD4575EKr9Dvcyaay1TKQM4g1WmYllNNs8X+a21wqvcWgRxcuEwpDI7hnH+l/qRKDx368tf3IDA8RlIOIP/s/AYGo6sUMXCQVlQgwZ6WrhtNAyda/khbHip4bHCYSQY/B6RQdqrkjUf0ypMqIa9RMJYfICPaFoQT1/LzdID0hOYBwAbJL0AdDvXFojVQSGW8vqG5Ww6cMeft0QTgZa9F4RRjvnstXOctuVzV518w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4fTP6tt/jUKhQuyzQdDkXe3VJ3tPs+dF5AE2+j0lnc=;
 b=EZ9Ebvk0M/qnY504qsng1w7g+RoDbs2WDc/vTvdTfOhGsNPb5HWFElXRRYl0W5r0TlxgaUE6fgj5J4tVwS8wr4ZAGl8PDk0lfYb9Yq/tPJuvZyK7j7h9Cqf1dg6Fr+Af1YbrDuhMJA7ls6FdtgIcfC2X5kMHJe411xn+Yp4v0FI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BY5PR10MB4163.namprd10.prod.outlook.com
 (2603:10b6:a03:20f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 07:46:37 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Tue, 21 Apr 2026
 07:46:36 +0000
Message-ID: <7204ba37-3fad-430a-87ab-629cff8c52f5@oracle.com>
Date: Tue, 21 Apr 2026 08:46:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] scsi: Enable async shutdown support
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
 <20260420152608.6244-6-djeffery@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260420152608.6244-6-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0041.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BY5PR10MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: eb657697-ef56-4733-4770-08de9f7a1da1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ndygC3rxylCAFt+y1c59dL3b6bp4r13NxNTT8DGRBiGZfNgxYeh/GMnvQgLBdyKHPOTUpDq7KyfhFvob1InrqmOb99MAPuFyYyOZLMHqNfvxbpptGmZKyRJngYZU2oCPE9NUgmKhzU7eW6JGsXklfpl852kIHRqML099MBaTHgItJnEzK2DdKBPuNSi5k0rlaDvxHu01Sk7e10vT6u+xyL+P1Vh9Ptp07cVMzGaQNX6AzmvC9twdbMJ+5FaKQrdmrMki+P7WvmjDkwSvawKjxljV70+xasaJ89/ZV/JKqTptWHZNXYWHq2bMmpRtyTenbrmvxaQ8q1RP3MP283ahsGtzSL/bucxMX2to2e1dfMTFNPP4diT/KJC5+fRyixuETqikhRsiG3wRpGsoXXPsUfAQ5RSJXo7CIu6nd9GuPixWfDmwBbd+TN+Ho4pSYsf/ofwcD36BrX9HXzIwz3U4s1FMqihPyS38umPwWaP4tB206mixoQ4Y15VDtBUhJIf9QSJr/oJnmRSVwFrjkVU4GwwlSMqZAu3IKSHoSZA2YEs3gNKZKWastZ1CoxRixESrd9eFj3r4CxwbwifR6cl5PSzfx95U2r0+BzM4VHr1YtqHL8em2ARWaUM+aueSzVz88U+va34Pgc8eEhZ9gp+oH1RrfQjH6QCt8tiyUg/5FhXBIRb57oY07wH6xdMUEHEjIrt04rSwMmQmgO6i9Cy6v1Mg8RyM6SK0JRbZbJL1auk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXFKS0hzdnptNDlrUkRRK0NlTWMvRXR1cU5pbHNZa2ZkV3krREl2c2xjN08r?=
 =?utf-8?B?Y3gxQTM5bXRaclRnWEhBNXYwOS9qYU55a0l4b0x1V25sTERRQlhmMHZHVG9V?=
 =?utf-8?B?dHIrUUNvRzh0dENqbmhRRE5vMm1sbk9za2xXbzNFdVhxWHpwa0pEcW4rRk1V?=
 =?utf-8?B?MVdUYVI0WHhESkJzNmJQK0NDbGo4cUI1dkc4c2dSSnpNK1AydS9nOGdtZWpj?=
 =?utf-8?B?U0wzT3EzZWM5M2VrZmk2UEgxanlkbE52RmExMDN5blNkdFEyV3llQnhQT0Zs?=
 =?utf-8?B?SWZTRG9HYzlnOGpFRS90eFpzc215ajEvTTlyMXRkUnNVT3hMYXNXcWtsTFBj?=
 =?utf-8?B?ZXU1Sm94MVIvK0puZmViWVYrMDl5MXRFMTEvT0kvY2ZlVVZReG9KRGZXUWVw?=
 =?utf-8?B?VHN3M21uTit6ZHBva1FmZHRncnpXSmRkYmZJSFZ3NGhGK2JPNXJXMDV6eEI4?=
 =?utf-8?B?bDF2YzExUjdtNCtYd3BPYTdIeEp0c2hkWnp3c3ZGVUpXT0x6Sml4UWFjaTRo?=
 =?utf-8?B?aHFGd1NPM3ZaUEMyN0NGcUZnYnRHNGd4WTE5V3haVm5CQ0NlSVRQbVU3VjZU?=
 =?utf-8?B?SHVRcVk1UldIbnpKc1lrMVk2ZUszL1NkeHFjTUc2QnY0NTdGZGtGanQzM3p2?=
 =?utf-8?B?bFB5Mkh6TlBVTGlSY0swNGhlSU90eXFDUXFkRUt1bC94dTZJNERqSmV2N3hs?=
 =?utf-8?B?a3Z3bWVkT2xYaG5TcTlSRzlNNkNqRXlLam1BSnVzeWQ2cTdJT3lqcmt5QzY4?=
 =?utf-8?B?VzlENVRRT09lbVR0VVdKbC9VR0JPQ3NWaENEY0NvU3hQWVFjOFhzc0l5Q0Jp?=
 =?utf-8?B?bVBaZ0VMbnZIL0pMZWxrNXMzRkpjczBNa1ZPdXMyQ3N0WXgrUkFtUkJpRjRi?=
 =?utf-8?B?ZTloUDM2VE9XSXgwUnBJdjZrRUpRSllXcUcrOG9Da2s2N3JTU2tJTWF0M01v?=
 =?utf-8?B?bmtxejJvR2FHems2ajY0TWJRT2Z0a0c5QWlrbW0vSStGMXFnbUFpdFBUR1Bh?=
 =?utf-8?B?VkQwcWlwaDFORHFOdUlRNHNkb1k4ck4rbkoyaDlkUEVXNy9YSlFrL3I2ZlIy?=
 =?utf-8?B?WkpSS05GWVNzNUZXNC9iVk5SaEpBOE43OVk4TEs5OFVUaUNVRUtPUU5jWmJz?=
 =?utf-8?B?czdzbmduV1dBSE83YjlqamVMdTgydThvL0U2NHBMdk1Ua0Y4OE5CWEVNSjlx?=
 =?utf-8?B?emNienRtY24rSGtYUHVRcXFkaUx5ZjJ3eGYyVDBxUHpOVG8wbmIveEJ2bCs3?=
 =?utf-8?B?MWQwcTZ0THhVRnU5WU5LWTloV2VCQmx1K0R0YTB2Tk1LTzJHT1h0NEZRWWNy?=
 =?utf-8?B?Y1RHRC9yRWs2QkxNQVBURUgreVRLeXZxRFdxbVd5WTY5YTQrNEJDQXM3MHJS?=
 =?utf-8?B?Q3V0MHRBMEtSZEMwcWxQeERuUUh6Zk82dlVJZmtjc09ZVFkrQVZ0OFVnWHNF?=
 =?utf-8?B?Vm96Y3VGdnlJamZTQ0ozZmVEN2VTN3NOY0oyTi95dlA3aFBsTXpJOStybHZo?=
 =?utf-8?B?Nmwxd01oT2NPTEloakNjSGw0NXo0MXlxZ0hjMVhTaTlxNlY2eVA4TjNvRlp2?=
 =?utf-8?B?YWpVdVpaSFpIa0Mwdlh2NHlNN0ZFTkxKaWN3aXFzbHFwcVRwbHNsR3RzSE0y?=
 =?utf-8?B?aDAwTk1GSERXYlZzTmIwUHZWR2o3M083cTBGNHdqZCtmdzJSTzVadEZrdXN6?=
 =?utf-8?B?UXRPMHhqUHdZRkVjUDVmMWNmZDFxMFNNc1VHa1gyTGNDM05tWHk0M3I1Y0lu?=
 =?utf-8?B?dVVQUUN2ZDVYUUh3WU12NW9qS0xMSkZXcW1zVlhLaFd2OGM2bW5zbHpQWVQx?=
 =?utf-8?B?YXBzd1lOVVFkNzVHaVNPRjhxck16dUVMOU0wS3M4UHltclhxTmxCUk9KK1Bt?=
 =?utf-8?B?RXQxZDJkMFgrNzNJb2VQdGtVaUlGc1lkNnorS0h3bjlJZ0ZiMnVnRlVuSnM5?=
 =?utf-8?B?VkgyL0ptRmROMWNYNDV3bytVZWZhQVQzQ1NZL3FCZlJ1dUxKM1MyZVBpTFQ3?=
 =?utf-8?B?Uzh5S2RoN0VMNFh1R3p0aGRZbzhTcDJZK3J2a0VPVjNMWjVmclQ4L1NyWEk5?=
 =?utf-8?B?aWFRVUxjbGVoZHFieVNrNjA2RFF1MllwclczYXdsRi9WbUxYMFNnNk9HUWZJ?=
 =?utf-8?B?UkxicEI4Sk5zSTlaOEJNeWlvR1hVWGJuVUc2K3JZQW9WOGZ0QjlmcFArR2lv?=
 =?utf-8?B?YUNPZ2psZ3NEQXFabklveitYeTlYZW1DL2daeTJVTzhzWDdVZDBCR2tPNnp5?=
 =?utf-8?B?S0hMbUVXWFN4eVl4d2RyTmRKbVRXRHN5MHFNbFRPcVBUSGdzK0F6UWlFNWs0?=
 =?utf-8?B?dFVSRTd4VDUrTDdaNFFYUkFHUGY0WkdWUlhKNS84bHd3YVJEODNmUT09?=
X-Exchange-RoutingPolicyChecked:
	kbUr8iC38J8HQh0PkSSoRC+jwccUmDIkZ4eOp7zxlyzuEeC45unQwYIdPuESC06dbPANUfUXn4IvezhWivZ+lOXXAt0v7WtfOo+/t+DUtqRkxQrUDuMSX4o35pv5g3fL5LfCwpjITszdYlPB355NmxvGWyGPWm5Y2+NHTr1329nHBdEHSWiWBlZXwidPL4ABMqZjPcDWcUd5SjcGTeKsI7CVwZj6ihO1SMgSF/Jstakb3LE8O4nFZn6CrYyFP7mVC9LFCINp+hrSRocoIpM3zbeU/jXRO72NzyRkp0zoF69NiGol4SeG9OUkw3FJ+QL7v92YYxJRDedmOTwbiJZjbg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TlL+A9+VNIGdw5jxwyavbCHp6zTXhq7HnZkKj0GBbCkAuv+/N7OszheTUXKxSm3JgnDbQjP0ag777BsWSMvTMDIccwOQCP4AVwwR43HjaIMAZuk57nKBCz118n9949eKWMVybbB6ZO2kzlVYHkte+iOCKBbiQGepIuwdzBl8FpfMVanvpjvSIsudLw3JjaBqN9D4AHYdBC+QK4mq1mRVP2etP357zR5I2ceO8E6n60xEtzP28/gziHYMRMHsP6M/DCmml4CoaXbfw4Vtpi80xrsPc5k0W+tr1ZVzIbBxRQTnoQV8uTISlsqLMyoI5dbQYqPDfLM1Yb3P+9FtW5/FNMKCcW9uYZUVNobJBwfM8DXVC60da18prSXEywCD0w4ePnRuAJ7+vkDAsddgicClL+GFpGX3GAp5tPWtvpF826hqD42Wfhh49rleh1QXTfVuW5/dy8Artweo0p4rwrgdohEiVXNnVQt3NgdWhtWZ1EzXY8nMHfuqD561vdaC8inO72iRUmR5InhZXehO5d43yASTsl1qjwEbwcpIWO62J4BsMif8G9/OlkjhxV0PQxygucfuHTac9oLxTsmL9tHg0toU8CrWdOcFoqRsMRotLlk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb657697-ef56-4733-4770-08de9f7a1da1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 07:46:36.8596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F43z084DwtnO4Uf5KqWeqEEBRjv0rhaTxsQ+SXEULL4dxUZM0ZRmHxfrdGG/+nFK+FJIGQezPUeFectfWoGbUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4163
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604210075
X-Authority-Analysis: v=2.4 cv=JYCMa0KV c=1 sm=1 tr=0 ts=69e72b61 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Vmfo3CvtGgswePUCxAAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ck6_T2RmQ9_zhI0HclwLN8Z4nEFlThdp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA3NSBTYWx0ZWRfX08ZzI1ax6Es5
 0iggHxeMEvqO547AT2yY+Z5MgbQ2704o2Se0gh0kcRNN4dB383uLmEjmLPS/GskIhC2IS/Clcbv
 fatPJ7KGvO9iUcn48bOOLsL1p0bQ0THDJ9LDAj/vckIacNGgiPqCTiDfL8/f3Tx3d+XrANSiUNe
 KzJ9qB4aWDTDC+BIfHQwRYUy56A9ALl6DM/siVbw2av9M+Fu7jiP9DV0xMThbjiGbL2VHSafamy
 s0c+0ETX1TgQEubi0A9wy7FcvTMTBXfCgcwvI3Qu2Q0F4CBL7PBK9mRSXJyu7vpw1GyjQz+XceK
 y/hsznv5G27/ux40PqKNx+01JdwMetwgx5hA4sk4nFmlMrOXEj3wsyguXW+C5gcudE1pzm61piQ
 ax2wWe/JKyZauVK4t5D+XANdCMPPZ/AoLem4SEVbrkeJuwpaoyVOF5T5TkIm+D5WWx2nbv6FBaG
 8iyipZ+E6y+ZIB9jwug==
X-Proofpoint-GUID: ck6_T2RmQ9_zhI0HclwLN8Z4nEFlThdp

On 20/04/2026 16:26, David Jeffery wrote:
> Like scsi's async suspend support, allow scsi devices to be shut down
> asynchronously to reduce system shutdown time.
> 
> Signed-off-by: David Jeffery<djeffery@redhat.com>
> Signed-off-by: Stuart Hayes<stuart.w.hayes@gmail.com>
> Tested-by: Laurence Oberman<loberman@redhat.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
