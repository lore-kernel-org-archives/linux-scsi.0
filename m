Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30F0471258;
	Tue,  1 Sep 2026 10:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258153; cv=fail; b=SAe5WbpWIL3YFYfTlOaFagJjfn6XU4OUL8sWOXbiWeqR2yihSJJXNI9v5pP7hTqPUS007ngz5kY5m5gcWVq6VhZ4MJqhtJcJMZuLl6srAVSR2mnXyCqbj8LcI141S4BnHPcetjFJYsYzO9SlINSUey0hX4h+flKCH9EgAtMzNOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258153; c=relaxed/simple;
	bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T1T85t6QszQ1AM+InHRDdtbhyfSsQC+dS/yx0jyO4+VqfGUeamFi2E5/C4rzE//XspsPkOgKPvNSKayFS8U0BFb1d5pOk80h1jZTCXeaWF2vpQ2TbtgV72LtCrHHiX2LU5bM++fRI97Z2bNr+KfdL20exwv8eRggVodhbB6FXsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QX4cZhjc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uFUJ9EEp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QX4cZhjc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uFUJ9EEp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBvO02222306;
	Tue, 1 Sep 2026 10:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=; b=
	QX4cZhjc5ouVmQAEgH3zBdC8no/+V9NRGYhPtLw/FJ34QAm2OgbvYBgjETJB/Nbb
	K3zIbOaGUQ5QHGLZnas/hzP/vnuFHW1QmPDTeMRgw7c5OTgYs95vk64mi+8rxB1n
	PoQQ0ozMsA+6dwgAyJg/uo6cd7Vfxj96unSz3LoEiWDOvUVlcuq1QBcW+gXU9yyy
	QPadTl0ob+7KhXubRe7YY4SHwh/5HzUQ7YD8k36wzoIDjP0d4BQqRmLVOKKM96z9
	rCdNSyDSqJJGfRHUzayQuWH3YD2/xHd5wFEKnMDK3Oz/75jjgn3Z8iPQyZcHrM9S
	Gdu/mqT0pzfzXPNvNKb01w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqyrvawf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:22:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681ALeTV006715;
	Tue, 1 Sep 2026 10:22:20 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012052.outbound.protection.outlook.com [52.101.43.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvq9pbp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:22:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMYoI+qF1+b3OdInLtyxXphzu1O9u+oO0ehAs3LZxlVQZNSYJOsXqXoymaKHkPtq1H+mB0ebmMk2d47hUO08IOLe89eB3BP7lshrbYdolSC6GQAf3UFwxpTdmnxCsm4rSclpCjuOIjO0vxKdiIg3Wrpt2t4TW9qx5LccGJALb87A4Mf7svo31tjrHMTD3/avQpsfgtgrBt0tGoo+RBasZHbgCDQ7mR8z7R4Fgu0sjfBwrH6BcZRaG1xwdUVKIlbPrqc1VONtBGJntmPf6SXBZDGGPi+GkE38V1GBEO7n0XGOC+Ma2ZJ+MBgMlR4nmxA2gM/QYR7sGzmf/NjDom4V2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=A+FOSlhdsSHEvQNsVWe3yEBZCKLv+D0Fg5CEXqKbs+YAOVJtNGAIcCFRqHwHP3z6bB5tLtQeLoYxAVnjFYhHKN71giwvLP7RpQbEC0lYegV33gJDFiTYIFscsZzBMj26AKoJWkt8FwZBUrqGmBBgjdTvkV4+IdiaZiPn5zrBucpUd9fSVx9Pv4pnUj3J5Gvht2vWbrXomP/jfQuqevbN87bhb1yADQtQsMe2AJ5tRGKTR2V2VXwIvp/+rIn5aBCc6Bn5X5L2DO5Y5+nZgAZr/+pF6M0KbyG1KerNToklptVk+z8wXgjCfb7s/YhaGf02mwqe6vlMQlVOwXj4JhQRDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=uFUJ9EEppTvY7Np+19IfRLdy7BFTIelX5LaMB9pTTaCm/QLO38Lw5Wqv6OvNnMXUF/Z3+h5jzBjG0e2dnXPRIszoakubQRojELxBQvZoB7/vagcTsQsjDJzxeuuPhtXtuZBCNqSlfEOwxIFAsJQjBQ1gUUqQ9JkToPv8fv5iNZ0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:21:56 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:21:56 +0000
Message-ID: <84fe1df7-4bce-47f3-ab6a-2dc67e9a9109@oracle.com>
Date: Tue, 1 Sep 2026 11:21:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node()
 call in _base_assign_reply_queues()
To: Ivy Lopez <skunkolee@gmail.com>, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
        ranjan.kumar@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, johannes.thumshirn@wdc.com
References: <20260817221300.43286-1-skunkolee@gmail.com>
 <20260825190313.24013-1-skunkolee@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260825190313.24013-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0606.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CO1PR10MB4754:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a479118-e1df-4926-3970-08df0812d954
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
 z2/p6j6mNWle3G/gLyn3k5YC9bWydh90AGPFZrEs3jFw3ViK96JItFafZ36xFO7UPtK6md5/MDipI8vL0oRyKlUXfEVW+W7f6mC045AAuIR3zPoGBfqKdeydOBylAVy23A+nmIxmNABHIrq4l7TRag+NlDgcGbZqxlWv+tKjmYLqFvPhx6S38mGFkhgX+J/AcwU2rDiomdzsnJ36gW89cDaWWHaLwlqYeJOKnJ/SGsbFO25V+dlTah3ARtF1EVeO7LebAXngUF3Vs/cIQkgXAOi9Kfm5OcU/9kfsIixGR9j7MgF/OWZzjYAt9vv/6hxlaaXfIYhDDbVX8mt8nVHWMAxpE5B2LB7ttffUvhKYlx5YCb7R/R65tOQxh7NWj28LbQOKX1vJPgntdbM96IONYCA+0FBkNSO/OgXhyzxc39YjZ5vHOsncIZIGa1sEPKhw6hRTr7MSIPvm9N8jqpKHKIpmKOKA1KfY4lWiDbJWdG6MGxxWq8cpao1Mrge6kuXWQWUXKYJEmSpnqet0XlQAOd+eVOj68y2dfI5wpNBdAeAsxtZG42/IHx1WO1kqREy9s9ikIStKRPR6CUnn42mYePbwLjiqHFFKz1SxgBoKqZ2+52DQ21VfRaiqIDrMVYiB/MK5+URYkROYg/MrB0NDy2Gg22dyzHICHt3FwPcfduY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MGVsK2lndzg2TFlpemRhNk1PNlZXWk1wd3U1RjRnZGpyRGFWbi9yRis2QitS?=
 =?utf-8?B?bEVjc0lSR3FZQW80bUdVM0t6ckZCVEdFNXpLUXdPZ09QSkJ5bEU4TmU4cjZT?=
 =?utf-8?B?c2UvU1ZHWW9razN1V0s5YldTSmxSMndRTE9Gd1V4TXF5Z05Ga2FxSndIOVFY?=
 =?utf-8?B?R09qSk9qand3aWc1ZFNlVkZUSTM2emRSVFprTXhkZS82azN6alFXMjB2ODlv?=
 =?utf-8?B?OTg3Nzh6NFVWTG1JYk5GMjV4NGlodTd1TkxsaWVFM2hKeGxhZFVjM1oyQmF4?=
 =?utf-8?B?TnhxMG9IZVZNNGlQbDJDNmsxVXZjMW45cFZSS0hxQU91WmNSbDR4aTZ1ektz?=
 =?utf-8?B?Uk1zT1ZKRFAxWkdVNzJLeWoxSFRoaVlKeHZoNDJJbmYyaGpFY3ZBU3ByMDQz?=
 =?utf-8?B?V0tFaklhQTByWjF6a09Pam5nOW9KbzQzZ2poc3RLaWNVbS8rM2RSajdyVEhY?=
 =?utf-8?B?SDJHQjNEUHp2QmRDci9zUGYrMnJmLzBmVkptZjZEalFoczU5cm85K3lIa2ZB?=
 =?utf-8?B?d0s1akVQZk15d1JPMmdaUkVYaTdIL2xXN2JvbHBhK0ZMNVZMQTVjTGJURWd0?=
 =?utf-8?B?NU55b1c2QWlmRzlhaVpOdTZVRXZ4VDJ6TkFxLzl1QTdxbFJIMDdTNjExUHBh?=
 =?utf-8?B?cm5KcHJHNC9oTnJ5R1hnVDN6SlZEUExTV3lMR3pDcFBqRDFabDAzWERXWXVw?=
 =?utf-8?B?eUtvbFVTTEIweENrRE9UcFprdjVEQ0V2ZjJhZ0U2ODFubUwxeENVUzRlZXFa?=
 =?utf-8?B?c2Z1bzc2NmxSb00zeEJvMmlxN1k0VlZkTmdMVExkWDFiZnNtb1NXZ3E5VmRC?=
 =?utf-8?B?S0JIR01FU29ZcTFEc2QwY2l1MERBNFVBVUZUaWU5dW5xbll3ajhkZTdUcEhR?=
 =?utf-8?B?QXovaUcybDUvYTZzRmhyMWh5VUdKR3RNNUU5aTZwWjhGK01XY0o2VUpKUmVQ?=
 =?utf-8?B?ZTA5R1VnM3hCdnhabDA1aWpPOFJzT050SXJBS3RUalZDSjdiN1JFb0pDNG9o?=
 =?utf-8?B?N1ZiU0xrUkhqY3ZCbW82WC9idlUxL0dDUUV1VkpxWGc0UHJ0SnBKa1dTUnN3?=
 =?utf-8?B?Z0dvS1p1RFlNNHBvVFdYVzlLbmlMWG1GaTR0MjNRa2xRbmZLb0Nlc3BFd2V1?=
 =?utf-8?B?WHB2UVBWcGlHbTdzZ05UelZCa0JpRHIwKzVVTzk5aVc3cFFjN0FEbjZtRS9a?=
 =?utf-8?B?akZZMGYrMEJIVEs2SWhtMHNKbEgyV1c0MGtMSTk2RTY2cHppL2RrSE1RMTlZ?=
 =?utf-8?B?aGR5bmYwU2JOL3hjNWo4ZmVsaC9wNWttUnZFV0JKMTdmdlZxU3NXcm55TFdr?=
 =?utf-8?B?Y1RvZ3VQV1hMbUYwYm0wVnYyV0NCd0tVdU50UnZnbmNhOUJkcDNndDVtWldD?=
 =?utf-8?B?djVCNzVGMmQ0czNtT3pnY0xWTy9COFdTYVFYQmZSVmwyOTFCRmlYSHZNcnpX?=
 =?utf-8?B?UFc3UzNldG1RTWwrZ2QxTXR0V1B0dHc2MnNHSVNpZTRRS0t1WS9VUHEwcTcy?=
 =?utf-8?B?SGFQbG1nbW9Ya3RWdnh4OHZyT3ZrUW5UUDFTY05DNkRtcGJtYW1ZUHpYNU1j?=
 =?utf-8?B?U09pT0VSbTh6dmV4d1JyNFJCZjdoQ1N4bE43eFJLcUlOdUVrNkx0VzVYeTIr?=
 =?utf-8?B?VFQ5UW9TWngvSFplUER0bHNyVWJ4Sk90dGo2bTNkclVQQkM0WUY5YlZ2T0lV?=
 =?utf-8?B?K29wQ3dYWGg3bTRHYm5jVjA1NlM0Z2FDZEJ4UE8xaFVJdmpiOGRCbWVLZmdQ?=
 =?utf-8?B?L0Z4OFFvVHhqWFdIbHpwZHdPanJMOUh1cXIxcVNIYUZlTGpBeUF3VkE0ZXNq?=
 =?utf-8?B?WjVHYkwrZnAvc2dCZDEyOUNyNVpYNHNPTkhxY1MrOTdndXZFZ2lPaG92NlhF?=
 =?utf-8?B?SGRLa0tZMXJUZDlMOU5sSkwxUFNhSEtXWFBLckE4WTYzaUkvVXdYTEl4UDVR?=
 =?utf-8?B?Y3hPaVhXeHFBR1pSVzBnTFJVd2Q2TEU1VVlkOWNZNE9lVC9JZ3lsZ1pJVDZh?=
 =?utf-8?B?ZWl3aGZmdDl2bkRhNkVZM1UvN0FDd1JHNXB6NlE5TFBjR3dady95SXQyLys1?=
 =?utf-8?B?MlBWLzZjeEhNQmhNNGQ0T0lwNFFPcmhZdkJaYy9TYlkxNE9sUWdZa2RLYzYw?=
 =?utf-8?B?YktiV0ZTRklRMWNyNUpLMjZiZy85MGxqd2s1T0dlUEtnMHhtZWljYmJ2ckE0?=
 =?utf-8?B?KzF4SE5SclRKSnIzVExJN29yWUgyanNubGduZis4TE5NVUlIUVp2QjR0S1Zz?=
 =?utf-8?B?Tnh3dFM4YkdvdDFhazVlSFVkd1B4Tkp6MnN6ZFJFTmJtb2x3M2ZkbFQ0RXN5?=
 =?utf-8?B?WmJDc2V1OUFScE5HVlFWU2E3eXNSV1RsbWNLd0ViUE1xNjdCbEtBSFFucnA1?=
 =?utf-8?Q?uJ2Lz15JnnKG+LJE=3D?=
X-Exchange-RoutingPolicyChecked:
	Z6FHxx9Y7M/1XSGPDjtZTEPQnTpphsDYveQfMHflLQcDIlhl2yqoGrdoq60+inVSD+Ono0QH2Mr5j8Z/niVkEb8pwNEGFqSEIUnluD9Uv36ei5TyZgLqTK1azSiwg13Yd/roRznea5ejf6fPdAk2X4kEBK+wkc53yv+Bz9+WBrpoIdIvw5AHRvZVu9RAf9NEf3d2uM8obCInw09Ybkrz/rlo3HTqOTn0F0Yme5zmXCo46gFW4G0tvf31Aa1SvS74Mj8aHQ8Mr8NTi5AA7/kW9ZCD/btC/y4kWYRUkMZ9V4CbMJ8IdhPmmopZ+EAG+G5RfWa6AFKmwcFWcoQxAGLjbQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HGvOXUeN86I0psSBSsiaHFppjuhh7VjBWVASgextYCTx5DZsa6qzsKjIUsjkI9Ng+Xpx5/CPEk+lIjA/27iuV0hudYJMtDwp5vAY3VPLRpvnlTG1oFKgaFjkH770+HkGMDC60W/7H8dAtZDdHfkNo29RbgW+miAevQHPhBngkBSq1NcdNMUJqpZ+2g/NZqTSDBMnIy4v9zkzqXqIXpXcJD9M1H/L6UhSE3fnYZ1Vl266or9C+JupskDL7G4R+o+05SywQw4lFlVBoa/+hWNsJW3pRBMVgbcRdRB+lNrsPGFA1Pg957FmcW0tA7V0vZUU91VF7p7uE1KUfsxu3un5LSWnno3HhbgHOv1VKY29yMqpQqgVfSKPyiOMw8AOtPqNGV5DqDlFDNm0lI1MTZ7IivQ//RxebJU4qTC2l7aDkRKWbdP920m4tbrfzhn41Ds2NigHrUdojjzqYGSR6hDkY7qb6Ppr4VHkqReq7GLQOpd8P4CkJPS7G+sz6Rgsm8draOl/HtHtwb4lAVckEF+W6n2KezsCFh3YmA0V+uAO2/zKFc1fak7KPs7yANZGoWEZ5TEQSe942wNv8BMc4v/5n+t8vRDt3R7iQubjFsYNj/w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a479118-e1df-4926-3970-08df0812d954
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:21:56.1625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZZtz0AYOKaqVRpjfL9j1MnTpMbieWly4Fwl5GRNeE7RF649PPrz8FsQrx1JyfLAOz7Q0CMo0ZWxQUPS2J26Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4754
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609010092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5MiBTYWx0ZWRfX0e0aS0TzArIg
 9YLZjgxK9SqWkj5nL3aCCig6tNZ2NsX7wq+FEGe0IBQtUPE1H7GSDIys5oLb944JchycPjcP0+X
 98NXYSJZ1X4EFiDE7lR6kxdoS1ieuCwxLaz0WK/cG9bjTRY0H9R/Ur/IEF/Mk86lyEP9ou4Lqps
 dtgOUMo/vNsnSdrTAP9hBAr8jNn8TlYAJBMvhQF531nA8OAVaClNzhixXEpQzKIgoxdX3y0D6eJ
 e8rIyHleiXff2Ogt7aEij8XGi0DsllAFCnXHpco67EIybych5oC6Aqz6XeQ1pY9CKlveM8tv//Z
 DLtIa5hVzsgu+Ytdn5FowYSd3jHeY3wuFah1baOTw0oVoT1AjvPkCMzf9/TJyBeFGXOK9IfHmHq
 bYxFb+ZLY48msiPiybTUaz5qd/NJ0CzKgrmeNWI64iWwLsuGYip1Xnz+GVixA/nLGKeoTvCPgZD
 kGOoP1DaXtmOi2gdQ9xesXY2yU7sdlxBkDwC579M=
X-Proofpoint-ORIG-GUID: jdKoKt8gE0re2Xxm0mbG-fRh10p6fDv6
X-Authority-Analysis: v=2.4 cv=fbCdDUQF c=1 sm=1 tr=0 ts=6a96a75d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8
 a=YwXNSyxGt--lyTdxN8QA:9 a=QEXdDO2ut3YA:10 a=6pWzAbgKvXYA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-GUID: jdKoKt8gE0re2Xxm0mbG-fRh10p6fDv6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5MiBTYWx0ZWRfXwQkoixXiZpwY
 pPGFKAbY9LnQ7lYp5zqiUE5tND62KWHwx92rhmqGyet19LRDiWhQ004QgHTATLTf1G26Aq1+Pdi
 bNADbTmgBiNrSlFVUe/y5n2H6+T27sSOG6vfqOcisQxtzy+urn7p

Reviewed-by: John Garry <john.g.garry@oracle.com>
