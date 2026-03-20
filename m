Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CB62F49F1;
	Fri, 20 Mar 2026 02:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773973157; cv=fail; b=li+qJ2GPDlcW6WUgRixuIUxbvY7gbjIQBpyRdyUmxQGL+V9bgBVit2SD3PmBfvxWvV27tz/FDEsIUcAokXfDiSpy0FEHgm2dwPnkSL3XGxnPdrhDIwhLzZ6/GIrkVoEiX2Nws71KEYmEJlrVKjd//5KjNIRoxkBv4Tn1JP6TTpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773973157; c=relaxed/simple;
	bh=G5n6dg3392KeTU+20Xd0BHW8/52XVph+j56qrLRh8Ik=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cZw7sFkOm0e8EBZJTPdir+iO2ld4JlMnvUqzCvUiVmrUsa8KlsYjCIN39ybn9ZjxwheEtjE8igUHJ1F/UPLJKbnUqVHl530ofqDqjoWW+pUyLav9o+RE0hmDtPmgQTRnMj30+rslf7jqi4TqbVuVbDX7ty3UnpbzI7SElSzb460=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eg7/P/A/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fF7CPXLG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eg7/P/A/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fF7CPXLG"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JGuoc01711154;
	Fri, 20 Mar 2026 02:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XiBDZHsCb1KbocCM5G
	Iu302cwuypcIJmRjPwsrSOZVU=; b=eg7/P/A/bYBQwSYUWPrgC14oH/a0cdJUoN
	9+8JaUrDjMXdCTgJCeLAjkVK797ZJQ7eAVZtgo3ALXY3Qhmr3b1p9gmY0y/B1g7G
	7YWsM4ctUMgoNoDRSWh4OhIkQREmNIJvrf0RVupeRnw/puQLze5p6Yew0CbwEXvD
	dNfCS02FuB+kvyWnqsaowP3b9dovknR10X4RYZgKuJVpBVJmrcmyiL+2OnEg9cUW
	Y1vikMcFAJQfBwCnxl/sqJ6qImHhoYxeh79jbH8g7VzAW+qxZYj2729e9lUBjtY8
	np7KgkeVTp05i9RXB/MpEVV82r3M0qYMi3CFPp41vEaA+eTqVLMg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj68vv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:19:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62K20LkG030599;
	Fri, 20 Mar 2026 02:19:06 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dq9hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:19:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzGWE45IsxKB2xD67w7RVQHjS7PJkTNjhNLj4U6hvUB34xa3V+2dWLHQoSPCUs2njfCvQpeunWUQVjbTGqyZ0mCXqGTOD6nyZ+5O3Oak4frB59AHHoNwT62YZSwX2SlUrVQ2g/LV3BJKFa85L8WPdoxadAfGfF13+UrEPjZ8IpeSyNWGvOZNd9n+WgFlw/jLmQkDY0hdgKfYusL+xKfcyNkKTtIEblzbQiKE53nOpGmtN9HXoa4kTtwyrSHpKB3ZBy873aKZGy1bqTp02IHGzkLXkCR49aQOhNLTlfEjXrRUni4xmOfvaqr1c8CTi8braG//laf2CF/4zNv/aH3tFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XiBDZHsCb1KbocCM5GIu302cwuypcIJmRjPwsrSOZVU=;
 b=RtSkSbYdZFg+BtMmRnL12DqGSx2J5xvouankaOqM/fwv+cbN96ZS/JjJazXrdARD48Qky7KKD4mox1tFjPobi007argx/dPsPcEvXVQhgy3ZqYkwMhFUTP4in5tds0he41dJpsLQ9aFRGfQesneeGEzoKo8QrdbsfEpYQkWXZMVti+ZfwTqUinJ1jwLoL40+s6SQOFdjSwgwjB40vF8wvBSjEkdTFgMIjNoxFc+sX9zDwJ/gAL/NI2vzStWdZby+Fy1ATeoxjVpAAyJT6JYk6tuprSloODiai+IdkZhiVTL1zfpMm6a/yuQogDx7PyqZUQ534/iajOstQqbmRKLxgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiBDZHsCb1KbocCM5GIu302cwuypcIJmRjPwsrSOZVU=;
 b=fF7CPXLGMxY2Yz7wKqqFfeoBd5PT88WNkZthrSVIQvTO5mz3JgR/aP0DPWzeIJ+rhx7oayUf6sBL6HXo2J6ee+zjohZ6S/ztpuvMFrig2PJ9GGW/9OtKzUg2HHtNif9VXuDWH85Ee05NXE/MlhmLZ1OF8GEcnL8vkEgBjWlCCCM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7930.namprd10.prod.outlook.com (2603:10b6:610:1c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Fri, 20 Mar
 2026 02:19:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 02:19:02 +0000
To: Joshua Daley <jdaley@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v3 0/3] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_init
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260316153341.2062278-1-jdaley@linux.ibm.com> (Joshua Daley's
	message of "Mon, 16 Mar 2026 16:33:38 +0100")
Organization: Oracle Corporation
Message-ID: <yq14imbkzxr.fsf@ca-mkp.ca.oracle.com>
References: <20260316153341.2062278-1-jdaley@linux.ibm.com>
Date: Thu, 19 Mar 2026 22:19:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0081.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f3667d-84c1-41e0-06ff-08de86270d87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|83080400003|56012099003;
X-Microsoft-Antispam-Message-Info:
	JWe7reD1l94AU4uDAu9jGs6/q3ff4r2Vjz7Cc9+JtinV8A86uuDeCG5B7R3Xw4xxRSpFf5iBW3n2vzIf/O/wDpYVovsyikiQAxnMIStNa+x46ydPgHhvTwopNyTaxJEh/u/yUNuzoj8lud54XEdrJjb0jyBKcmnQlh3P78FYLgZqb7HU6GRHZX0DdNW/lpBchORl1tbciO6bGmkLlQLRHTgNyxocQXuQiUvKvPyKL2ZXX1TXaHoorgasxErOUb7LvrPAfcb2is70hxeq5Kf0RdSyxpWPhULJ+zPawrKrASAmFq/UFIqHWwe8EM3LPyZydIMF/xJ9OpAGx7c8KdHMvpvJG7WpbY1R9/5FryO+brGiUK3Pr47eBJExES33ESwMEvsCLwcOoSIlHO+4FT0wfo2SrEypmDnFTeNUbor6iGmNDiY0ZV4slB3UFPD/07QJUClwhJ3qsm8hIajO2voKCSdXIVteAZDjtLVSCXxVUyQ4c17nTKWxhNehjFH3mj14IftVABXzYs5T89B52ZzoAiSCvKFjbVS1n/pfxajnfAGiUjifo48Y7FYVt8qNXcYBsSh6g9id/KjKciyi9+aHzQul+Ld9bOU0qi3sfE/uSN7jrsIrBZrSHKEUc9TI5tLkEFzFsfZLg9I36RN3mShnOcX1yO+IuZprxihK6Z0kvMxXa98m1YQFdBI98NggnenW3qO+l5JAc+J9tPZIDdhETRUFPNM1TCUAE2qjsy716J4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(83080400003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HitMmi5ivfvpPbiSNWpOwRhnOuoRqalaNXV/c18KVoDkRlE3I/W6OH+ru2BE?=
 =?us-ascii?Q?pgSUZi/+8BZu9eNhq2Shsbr8IMQQdgW7h23YF1xEPKHwmP0LVGN4sYkzeJTx?=
 =?us-ascii?Q?F/WdKt5m8LF2lBjR4MZgmsUnOn7q4KVBwfKp9vFDxA7SuK2fHgWfYvN71omt?=
 =?us-ascii?Q?IYdbZCEwhlFnY5jJQClgEmKhf/qMoAvbtnQhJzFIw2r89fcZjH4pajNUK/MS?=
 =?us-ascii?Q?5X4vfUIv0paDWVGR84X4yI9YEWByd4xImENwCpZ0HEX10kYFpQAnSWkoVpF3?=
 =?us-ascii?Q?UAEh6qVM0FSbmVuO1xo5qascSmvswu13JUhIPAbrgrb26kOyt5SGjW6YM3It?=
 =?us-ascii?Q?Y5Hr5QQFyKfR5f9kqsuYiQeV9T43cm57PhFqYxgd6ARlCRh5dm/p7QM9ZYpI?=
 =?us-ascii?Q?ix7/17bMdE+AOi3XsQar/HUx+RRFwj7vwhYP4yM11SXPKA0w713kSJdgELT/?=
 =?us-ascii?Q?vJVgQXTd6wv1gYue6InZgk842V27JqiwRJFXknAqJKV2HUH2nGVSTBxpKaZm?=
 =?us-ascii?Q?vKld0c+MZy6U13Ga6BeYJd6rpnt/j9WESdidAVoEvo0Ud06BxbTCCHfQ1vi4?=
 =?us-ascii?Q?PDM1tiV1B5wR9eg4L0UE8OO+SUSG2SYSewTbyhjKUMGQsH2fY50nvmBpIkJ1?=
 =?us-ascii?Q?8RFdOTx8nrHHkmFU7rU1QW6blYCAFoE/bSRIJSVj0r6tXcrc7fSxtwKuwb/w?=
 =?us-ascii?Q?L2RiiaSlPJJ9yuB5znE1oow/VcrnW9w2cN3G7+Es1P3xwCYHAF169e5RWefm?=
 =?us-ascii?Q?FM3pmOPabL/wu7TnH4r0iVq6YbjziVmPYGBe3vF7LDUvEuOX69YGHmYBBcS8?=
 =?us-ascii?Q?80BEn5fsPuTiyGqWwccAiAohf6nhEHV8K7ey1dsmmVV6rAxUNugIgnqLZXTm?=
 =?us-ascii?Q?1SZ3DELP5NmrHNd70e/6+mglurpOSHjHyXOVznukX9LfilVUedZM2DB5Ucb0?=
 =?us-ascii?Q?b1ANKqKmOD/KivUyPBBUdd3dHeXnoCd6RXmCUYuSlsi118TIkedpS9l9BDlx?=
 =?us-ascii?Q?LShXgeB9lc/5UbXPau6yp1tgdlQ/OjcQ0XGOFvq7jKzJH7H05gfozALQFhpx?=
 =?us-ascii?Q?ECtuubkYfXFHtBjbJnU/zaLndxrrWtqGui5urxfyocbS2EHtdK6SwAvkZhlk?=
 =?us-ascii?Q?VTmJmyHdGNPXIioZywScjkFc/eAE2Lgvxgfxv4JElp+2vgxpX9J6HvgjJdqq?=
 =?us-ascii?Q?L9PcLyz1xyFTCxlh4kdNzSwriRhA6lMRlWUUzSa0qUGli+NjDnTNGAawvDZs?=
 =?us-ascii?Q?Zn3GJqgWRkmo/56N3jXmSxfTKh1ZL7pxHyEs51EKrOC8tnlo7N+vvX3TfRLq?=
 =?us-ascii?Q?AH4e6AAguksVK7Pp5Ygr7+8GbivcIfPx+EPy1qUtRAHbcdfQyHc3NZvXGoxr?=
 =?us-ascii?Q?79+i0236ykTOWsXl34PT3qJo3OC27tmQ0Qqmj7FYVXEuMCDicFeQAHlwmMyP?=
 =?us-ascii?Q?1rbrZ44Jn/qPgr9IywWZzPW8if1Q1aAPel72petyP63tLwzqytRahwbs1ylI?=
 =?us-ascii?Q?/zMKCVhDviHSKA6SC/+8lRhoNszzvZlshSkTwInex6pxM9lZDFaNe/20/BJp?=
 =?us-ascii?Q?XdDXRDSL+kPE6bFlPGDFwvhNbhi+APlbnDWPrcpsAl0j0gbz3Cg/w2vd/qfi?=
 =?us-ascii?Q?l2OtGwLgw3kWbr5DxFZMmKZ5VVJvoWOnVvj6hz9cq4xU4x6AbQnHX1UuOBvi?=
 =?us-ascii?Q?HUQ6xBqP0NWZ2rLyAM55+iLR2yc+nxP0yEB7njAzNZ8+7PK0uwleI0ukLq+m?=
 =?us-ascii?Q?3uTgTTTkzfEPv6wSrjHugzrMzJ/mkxE=3D?=
X-Exchange-RoutingPolicyChecked:
	XrAODZHVgwvJ/yNCBq91Lg2G/vZrDzCRZxqtkBrmWGlfQo5xm5M+q1I+xeSXIoBDeIiQsi7c24LTDHyuCZbbPf9x4ZfASPhpe8wHw7ksKOVt36WQG32sDereuVYMqBTjj81MpthII6OMJBlNe6tNeNfI72Y64k9dbxgFaOPy0ovLTWZvRzEhj8R792otvkAOIe3NlkVgPUU9hqsClsb9Fr9lXhnpRDAmQwXyR+2LoN9uq3G7BlJ4ixVvMshKP9TKNnMJmiLYdKMntKVrAhyFA+Y7VerHMSiXzRM2nkFkBrXtnhPY+RiyA7OAT7YBocYFr3xiEZWbV7C+brIGcSuOIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sD9Xnu5C1wiEP60JU0mMTsWC8grqt28zYsoc32uz4ZB/Pam2yVZ3gbFVkBdPqvCqhuNm9NeTRw3iEnc5NtsEaQlM058WfufJ+PQhKG28O74U+9aDC2nhBQ1NEOmDEFVWt47R0YSDovXOIa/xTgb6WrFOq4TU6oLPfq6Vv38u77vvof+KgfJnZsqK+b2A4HBUCNl4I8PUpXrJC6UJsqmZyS7QRvPmhRJtFgojCVUQ2Y/JUa+C2TDI4ewnISXzghL8TN9x4/OF9HQKJI7BOJYYdFwT6+RYD5u6ZAseW5d8iWpI0q/YKX/cex8QHk6MphxXCeDbC8JVbMxzcB6dckhYN0m3qeHpc+u+Hzc5VfsA+FWw2j+l12bRoPkCxAyi988S1LsFpjJg56FiW0kf7etj2fqThFbIzaikYDo0wxsJnXoSJCLfzDZxqXgF9nJV6eSP5PlpkXGh5f2KvlJDg0qJuNDYNL1rKvh/TMijh/ja3fnM4usDz9SxD9mKL/VZtJfFNUI37yGN9zssQhlSKpUdIVwd0Z+YIyduWJDqu5WAdlJ3UpnpCj1h8ghF7Fz4+JQbftp1Ush/qIuSbSfAUjLbSn7NwuPUVoqrkMSU6jsTXO4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f3667d-84c1-41e0-06ff-08de86270d87
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 02:19:02.4093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3XevGFdXNi4X0qmNS1M509lsChG8YTeYtys2E0HfLj089QqEIDu2vLMT/HH0TdkrY+oRsDP5l2tvcHNk7GkbMwxkCfdqlxHjSH+obPOZrsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7930
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=747 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603200017
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69bcae9a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=c92rfblmAAAA:8 a=VnNF1IyMAAAA:8
 a=vaWQNdKgOiGVleeqWEkA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxNyBTYWx0ZWRfX+2U8M+MM+xX4
 vWwbW8SBKL93l3WfVyrRE0k+NKkychPmHfvtq8Zc/00hPZWhenLr1W4fKMNyf2VOof9X8PhmU3t
 gyhhd1/VXvV9XJ5r3h0aSrkp7M1x9bQfQ2GqgNk+VX9FW//5PiTocF9rsIpqfKSMtvcAC31kwRJ
 BcJn6vrJqmdd0JCI+OVOiRWC4IDYgPsg4aMByYqMARWWdAdipxgWT0vFRNSd3Yp1QGconN+rAXe
 wUR7+wqafPAZDS8nNC2OMoCMtF8ZOgr8n+iyS6MUehqXLpcXblTIOillJNGAjbo/WdboEQ5xIJS
 X/gW/UCTaIzbdGuJWXt12geEsY7dRDfC1rTyTDFQcVtYvODIqwONRr2S1sK2lx4TmMvSdDEhd6h
 RWrDX9G2jHpgA4LooAfTp3A28nRKaGxNAQ2DrZdrvlA5ccipIbdj2KPafi6YWJskqgyl+KIJVuu
 mtFURkb/WMkQAat8mSg==
X-Proofpoint-GUID: L57gKXHHehdFolExep8tW2YilQgtFqGL
X-Proofpoint-ORIG-GUID: L57gKXHHehdFolExep8tW2YilQgtFqGL


Hi Joshua!

> This patch avoids a kernel warning that may occur if a virtio_scsi
> controller is detached immediately following a disk detach. See the
> commit message for details. The following are instructions to
> produce the warning (without the proposed patch).

A few issues were flagged. Please review:

  https://sashiko.dev/#/patchset/20260316153341.2062278-1-jdaley%40linux.ibm.com

Thanks!

-- 
Martin K. Petersen
