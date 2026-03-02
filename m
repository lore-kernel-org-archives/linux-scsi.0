Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAC74400;
	Mon,  2 Mar 2026 12:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454070; cv=fail; b=Jvwdtoyqy7ld68vAUT0F3nVNV+2sFvkXOj5B41f+/QAXW2wChg34YhARN4IKt9ilTSTqnnZHaW1lv5F5FV3Rup4fjMCf+lsTTnZ6m0EBAjcpNmbu6blUFKGViLjvmDnvw4k5j9DeKN8NcPE9RXNd6KwjGhr7Hvci4tvMMkgxbjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454070; c=relaxed/simple;
	bh=ANCMhkyOHphJaX16mzXn+BJNO6gOgK/ysAEcS7WxldM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kDM2sA+sC4Q2QIt9H/tniI3stqZCW5yPK7xESVC7XRjQ1izKyAjZZkbxy57uI8m3AxFHSCbWyPGcz4BL/13SScPc8vXlCvDWvp7ISiRBUw49OhOdwyzceg46HxbnKP2Lulj2ct2EOyMbp5rBvBEcTshQXe6QBI0d6QGnuwkGJ7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lUcRLOgy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zlQ0yw2C; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lUcRLOgy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zlQ0yw2C"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622CIxDN1693160;
	Mon, 2 Mar 2026 12:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/DaHIRrgj9Kym8FF5IkBbC5fmATj5VEcnI2M4+4ue6c=; b=
	lUcRLOgy725wAPTGWQagQlINeSfARipoCGxoG/TC+W6z92nCzqZpg++HZ4kDr5lB
	Z3kj4Q58jMfF922D3wkwYQ7JMXf0YYPCIia8kvBmHdB46RVBHEzUcFrfmkOBHDKw
	j5vrqlW+AQgkOr6x0Itu6OGbm6HT1GHOXxJ5tDh9B5K68mY69M732kOGM+y0qKNM
	qER1L+co8a0BuhndoAUl0Sj2zVp1z188sc3cgehGWs/9eMRyVL/LI6e5qulEbvca
	jU4tAeREE4M1fFrZPHNrZ/IJ6S2wIz+Tt+rhv6dn2BMSxgdKGkImLVAhOfmMYGuC
	6ajNL44EmU1FfO7ppwTcyQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnaeu804w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:20:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622CIP86029717;
	Mon, 2 Mar 2026 12:20:52 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8vjem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:20:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mMVcc7HxsBroN9VWrf8UWgoaIclxgzpqoUGoS7EFz5Vq15f8VliKCINZoyQmcGcrQEcctb+iTmZl3ioxv78kAyKri75dkPt9Vd5nlHw2ZrhqlPq+YfN48Aa7NEVzr9Ten8l9wjBuBA2VNvyViZbOinaFZVeUJGo+Uq6+n/RNCy/CuJUjiRKRdwvL8NMcqu3x0xGEmmFSmf+YEpWzpqHwhkHggvo0XFLhRi/eXglQI0C3NATWgmIVneDTRmIxN7TkDkqbw2Xs7vNg5JNh28y8sZjWxn4jSgO6DZg3rESeo0OXIkJsoVLntob3yrXlAGqsDdg/EPcdbFxY5G6DWzG1+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DaHIRrgj9Kym8FF5IkBbC5fmATj5VEcnI2M4+4ue6c=;
 b=NKrRgevifON7O7AOfhvm3T1tojaqA8QAbuPqxDuzTTX+NcYrYnbBRHuj/y9FTE8tFkH2o1fzXXbYjd3OgVHApV0+5PSsTZWhkTDCQvPcR/rxc743rx1+bKvkUfxbPTKKF1hZPUjywCZ76YCBRyNzavFsjjr982qN2b7JgNOUBLebv9BG0E55TnH3Btsu2dEGRC3Kaa+KtuEagLiAvB6jHEJPJSzHqhtj3sHTnGysDMOJ2XxwC1KwnWCzldeHUaHmXUDh2JWTGM74LrZDv/uK5ZUSs4tcggZnwTYcVo3eI6wg+PDixhjLpPxvVMdnE9tq6rC7SBLtEBhVnC8vOo8+0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DaHIRrgj9Kym8FF5IkBbC5fmATj5VEcnI2M4+4ue6c=;
 b=zlQ0yw2C0TU9ibTUo7f2KJOdYQgrHkKZpxN2rqQsu75RJ6oj5FhvXdG7qEJz9DTbxP/i7W+JCF0tuMej7W3U5WOG/QpZkTOCVer+zexnUzafc1XvTww5VZggxYyATqbrDl19LhBOKpbQX0z0voYTC+wZF99EDhR4VTNhLGqfCGM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5035.namprd10.prod.outlook.com
 (2603:10b6:610:c2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 12:20:48 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 12:20:48 +0000
Message-ID: <cfc6a3f4-28fb-4ed3-90da-780a2534fc57@oracle.com>
Date: Mon, 2 Mar 2026 12:20:44 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/24] scsi-multipath: add
 scsi_mpath_{start,end}_request()
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-11-john.g.garry@oracle.com>
 <aaUNQgJu8sEx-lsv@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaUNQgJu8sEx-lsv@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0524.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: d6efc2a5-2dcf-4877-c4af-08de785622f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	qchGtPRItIkMDvois8wYQpXGtvgF4+vJg+1ze4Ne+bZmArA4rbFhRJ/arf0G11WtboaiSkbnH0NgpkyhKjAmLvrAp2/1+Oh0Ieb/pXra7yQ+gWxw+ZY2ZySNPopGx8xn7XQHm5Uk5iUpCUzYV3k8kEsYN33cCkxLeov1kQRGAC66zccCRGXBCmzc2aNbURudF8Va7BbSIFbhZpwmQmg/0ORDzBzQLAOoE7De7cEaNai7NeaN3E7m/S3e/TMC7lelYOmyhbdZXbyqv+N7HYQ0gjmfhQ3yYsMyofkho7JaxU586UzwmA1w69kkOftF/hOODLj935ShUZkUexBsRYBZopJnfLwefNinmzcEXK8MfBzx2l5MSkVyfs18TxET+/a7KccJFUeONFl2zFqY6xselEdMG4C0TdzbHAovHvP8zpRjHe7haT6equeum1LQ7+QD3wOF6lxovVNjr6QrxPKV9XdST8+11+EBU0Vra4ULUoHCz2wEKyuo/AMCxvmujxvbZu5wCjHxv8NYlIcrkkKQTnfHBjW7YuNvvHzbcqMN8SgCZathXf/toeBY47OXcR9SKFPCSeFnbNszyI1t8cKqPb/ou8bI+GDNNCOIGQWaYObInUy0PJ9mHasE9J45YtkeqXPr9ZCGGIGsjjRUkhW9eVYqnZ7QUGmSPj9gegfnxfVuvejJKAW3x4gZr7yFgpYc51TjJXWCcLM6LyIm9o0prRyp3Nqjdhd1dxSekp4fDoo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Snl4R0JiNStiTDNEck83ZnZjc2xrZjU0dXVHY2RPVXRubExMUVlNNEVocEc5?=
 =?utf-8?B?MytqL1FOMFhmY3o2NEtnTThWcjBOazZxVjB6WEdtMlN5am1Ndms3WHgrbE1P?=
 =?utf-8?B?cVRZcllTUkxYRlVSSVlKVHN0OU9JMnRQM0xJd2JNMlBGUTVUVWdQNkdVV0hC?=
 =?utf-8?B?RjFFMXF3MmF1WkZSNFNSUzh1c1RvMEhQc2xrUk9pL2QreEZjL3IxMmpCUTdh?=
 =?utf-8?B?d3A4WFM5eHJrVEIvT05TRXhiWllDanpwUmRCY3pmY1ZMa1d6SFhoSElyS0g0?=
 =?utf-8?B?MUdNR3RjMlhKRzlqVVR6L0h2TUYxcHE0WmRtQnRtcW5SYWRoemwvUXV2V1ds?=
 =?utf-8?B?dkVTQ1N1TlMwd3dZcXI5NDQzZlMxb0xKZEVUb1VGOUFIVjU0U3VyeDJSN2xj?=
 =?utf-8?B?aFNxbERTaUFhSG5LZEFqN2VuSlRyeG14NHVtMC9jQWhNNW9nUytGWlI1L24z?=
 =?utf-8?B?TndwcU94M1BXS0RXV1JqQ0huRGI5eXJVM0U3bmZjbDNOSk1VWGtuTm0wZ1BC?=
 =?utf-8?B?SmxaQXhsT0pkUUpSSFcxamxCTFl0NSthYVg3M3pFRUlHSTErTklYbytWVnBV?=
 =?utf-8?B?aUlQWCswd2dLZkxzNVlFbmJqTExiTDNuODF5ay8yUnJRN0hHOW9EM0NsakZn?=
 =?utf-8?B?SlJQUmdNUlZoSW5XRGtQSzBWMkM5Q0hVRzlrTkxFZTBmSmM5akdNUTdDbjg2?=
 =?utf-8?B?bTQzeEpLNDY3eGYrOFFaS29QZ2J3K0ZTWGl0dGNUelVnbnROdWcyeDM0Q1BY?=
 =?utf-8?B?eTN6WGxZdGt3cnNxTW1odmtERkhHS2ZYWi9xRXBzZ05aQUVmb2dMTjBhdkt2?=
 =?utf-8?B?SXN5c3RUcThQenRZZkZXai95bnJkME5uc3RnR3Zsd3NOQnhKNkNDMlNQd3c3?=
 =?utf-8?B?WmNPZDJTWXpVUzZOdkF1ZEhHS080MXZxNGpmVnQxR210T1N3bE15NXNoRjAw?=
 =?utf-8?B?OUljcUdsdDNYTU53UllSUWdYQzZKVWJMdE9zZlIxTWQzTWxaaGJvR0xuMUtp?=
 =?utf-8?B?a2lDNHlYelpyV09oQUpzOTJENWhlTjduSjVHOHl3N1d1VEtNdWVkY0RTbjFK?=
 =?utf-8?B?Vnk5VW0yRVFublVaWnRnb3BhMkZ0SmNWMG1vWm5pNGRjc05yNzJPYXBpSTBI?=
 =?utf-8?B?QVpmUmRjUjdUOEJqRDh0NG43dXExemZOM2JScDhDdXNpTmJIMjFPQ2F6TUkx?=
 =?utf-8?B?TGdYa1JjbjUyTXlra092WGQyeFNxWTR1TS8zN1lsSWE0ZUhSU3RqYmpSZ1h5?=
 =?utf-8?B?bWFYbXJvZ0l4SFBOSjZrVnNLd2R3dTI5akJnQ2doK0NBUndqNWFvOS92Mk9w?=
 =?utf-8?B?Y3AzMXBYRWU5MFBJS1FZZ21LVHpsWFBUYm5iUWRhS3FVRTk4aldLb3FGcjNm?=
 =?utf-8?B?WkdWemxncGx6a2ROemNDMTcvNDY1L3lUK2Jjak9CaUkwa3hRUzFwK2JDeUpW?=
 =?utf-8?B?MjRPcHJNZG96OW9EMUNrcTBpeXdaeFp3K3k2ZTNVbXhHNjR5MlIvRmpNSitv?=
 =?utf-8?B?R3l3UTlFRERjQ0FJQUowM2FQOERtZ1hxUjdPaUVUTVNTczFDb1djQmVxSHl3?=
 =?utf-8?B?RVphZzdrckR5czBZUG5Tb01nS041WWhHeFVvTmV1cGNFWkhTb2lXa2RnQUJ3?=
 =?utf-8?B?VlYyRTBNTFZBak5GemNiYXRDK1hFWGxNZDBiY2RrRVgrbCsyMk9xRVNMTXBV?=
 =?utf-8?B?OHhWZGlFYlZPWkFqemVZMXZNR1NidVdFbEVsU1M4MjJkNzBId1BCLzhEVS9S?=
 =?utf-8?B?M05PK1VWNkIwY0JwWHJjbmx0ZUdOS0hYWXlHZXh1ZlJaeGtpZGs1cUJOd0tT?=
 =?utf-8?B?VHdPMDZvaWZnOVBERjhsSXplQWpyRXk1bCswTm1BZEJEVm9XUXU4dVNFZldj?=
 =?utf-8?B?QXI3eVhlVlRKQktLY1g5ZjIrdm81MUg5eC9UQlhqaFB0dlZSdFVWK3FNQjhG?=
 =?utf-8?B?eUFNYVBRd0F4R0lZbzhmMFJtRHpZM3FwVTU5Qk83MWtxQlMvbEUzOVhnZ2Er?=
 =?utf-8?B?RTRiRWxqNFh6K0VQbWVzcStzZWMwSlZOMDNPbEUreXFNTWZWd3NUZFpXUTRw?=
 =?utf-8?B?TFl5NUd6WnRxOTI5VU9GR0lEd20ya1ZEb0FOUDFNU29VMTRLZjdwN2JXZlhl?=
 =?utf-8?B?Y3hSWkJlbXU3VTN0ditBMHRuMWVtWVdycGVrNUYvd21uOWRVTTZEMWJjSlFy?=
 =?utf-8?B?UjBUajlHUU0zVU9rNTF4TTZRTUlSQkJVc0NTYVAxekhHNlNOOHBJdjhEZEE3?=
 =?utf-8?B?SVVvNitkTVhCWjhCM3B2dk52L3FJK2kwV3ZmQk9xdjBoMWJhWlBMaWpKS2Fu?=
 =?utf-8?B?Q3poblNOMmx5RXYvcENHQ2I3NTV4WXcxRm41Rmo2Ymd3Q3p1UDlPUW5ENWFo?=
 =?utf-8?Q?iCOIaTdOfG6m+wnU=3D?=
X-Exchange-RoutingPolicyChecked:
	QnLhkW5pAOGIXjl0ltindZvlvOyr/1kQqysxVLOhqtTlzt5rGiJn0wDJ59kkP40QRjSYUgQXjEFaXsmRJHNw1ro6wpaIhNa71Aumrqrt6c2qyBQts0DMHEtTkenw5NwFSqQQGgEVDAowylKnzah7V6IfO48bg9EFVixwZNvjIjLzK6YZZElLhzatmwDa6Ynebg/MTQAITCa62AWeuK/41P3ROmFsa/9A7WVOSk756tXd3942lRn2CtPMURKDMNQ+y0sPQP7zD0IK1oeu1V1THDcz7T79EPKmq4UpSD49xNBTYcs27k3tdwKR+hy+qIJd3xx3Cfli1cMZ16mGhZJvZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lLlK/tSqH5JFv3Ni5UGjT8YcM27u+PvUkEjYjV9+o3pH/rb43S0cUT4O6GqfO3HWElVpH12Fm3lN3/F3+uQE/ewBP4kGBM+omGpACUFEoJ3PtE2bsp2JtH+w+uDsooUEvGm4DRtqk4k+zldy9eLGOHmGEJ5I/wE7lVw18qRZQ7iDhDZI6yu0oYdYLbRWCoO+gM20EmvOA8r3aL5vtCdoU09kfk1dRh4aHt2mZ1xxQtpu8lbszoROmcCljJ+qSAYVdHWRPkv+/yaiKH6gJyXOx5VBidw0DV9u06H2UYTaGNJNXpRA4BOJlgq9X0GPpTqxTSa6XPt+MyyBMaz1/C8xOZdzvsgpBUlSRIav8kN00a2M3Oj9TYWdIuKw8ca/Ie+9hJpK4OC4KDs0BJjjMx40SUo/gd3Eti+g4Fik2ckVAws/GToU9OlMBNNR/8WIqqPBf/ioUAyX2SagPY42SUfTGYi8amDpgpVZSa9BAPldOnh47pf90/PTASDGUo2egtBJXVuBKCvfk0mA93ERJzHG5PUrIO6YE2cKCOvWKoAbVlP9d813t2gZC+/WQb6YsK7u0ze8BzZG38t42WWiMwplXsKyr7TmUamB9HeOL7dF4Bo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6efc2a5-2dcf-4877-c4af-08de785622f6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:20:48.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1mkZTsO4mJ0jD/MGffzmz4vn0wq7W70faTPjHEUDBPFEn3/+ZmcTRmEUp9J3h49Wuh3siY17bwA4PMRtTxDR/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5035
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020103
X-Authority-Analysis: v=2.4 cv=UJrQ3Sfy c=1 sm=1 tr=0 ts=69a580a5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=8ZKujI-J9Iq-vqTfnm8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _2_XgPLgCAw31J1deNcLxXaQba-xD3m1
X-Proofpoint-GUID: _2_XgPLgCAw31J1deNcLxXaQba-xD3m1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMiBTYWx0ZWRfX6B5hnzRhWQv2
 Ai6hlrn8E/Twd5HOrQJ6P46edIiSx4Hh6yiC7kkRJlHII09IAmui128rcDTiLrMxj6ZaqKmtS/i
 8A/8U0mhagKMjav9SDaf12LVhcXS3LLvovL240aQRZLltI9BFiwqbYmxWVK/pTSV3qnqr3fyQs7
 SpuaQrsSP6EMxOvOnm26iz8FrsOuMNObl89Pc3EHxPpVp350r0iFlqFkgDY5TdR2g3mtu6+BP7L
 Gw8Kh4R4ZovCRW4GHk9nnkucorEPGoyQW3EmjNwRp88ML+0wefrG7mBjWTPQ2Dj4eM6S+AH0E6P
 CSQVRkTgjIysuLLHP85bpP3Nb1kIKju2vXaaZmEepeF4blLIn6xP/bOSoVzvYPXHr1bTrRsgeLI
 8o8XAz32TQE56Iffmj4I1WZ/6EoPFbZJJCYBzEqDvPiFwXOCi6zYHFEDjktz0hknQgq+oyccrCr
 4h7noNNJw5K3fkZXrnw==

On 02/03/2026 04:08, Benjamin Marzinski wrote:
>> +static inline void scsi_mpath_start_request(struct request *req)
>> +{
>> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>> +
>> +	if (is_mpath_request(req))
>> +		scsi_cmd_to_driver(cmd)->mpath_start_cmd(cmd);
>> +}
>> +
>> +static inline void scsi_mpath_end_request(struct request *req)
>> +{
>> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>> +
>> +	if (is_mpath_request(req))
>> +		scsi_cmd_to_driver(cmd)->mpath_start_cmd(cmd);
> Copy-paste error. It should be:
> 
> 		scsi_cmd_to_driver(cmd)->mpath_end_cmd(cmd);


Of course, obviously my testing needs more coverage.

Thanks!
