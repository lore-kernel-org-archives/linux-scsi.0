Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC411D531;
	Tue, 18 Jun 2024 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718724097; cv=fail; b=S9rk47+U6jEDzBuGD2j9i/HhXT9bto8tKoQ3xwiQ9GGpZBEBMRB+fW9lXKKRnofNn6ZTj7CBzCZZOA2TlRGdTUVYDbH+jsZS6DPPhynkXMc9jwIPQz9Rfn4kvbHwdrHKhGgSJ9XLhgkNs8lKzk3iwEaSxtlMTgZ/BN1SH37VGao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718724097; c=relaxed/simple;
	bh=1WyeyrLg1LRc6OdMCqyBmn+SKb6EhqIFbq0cIASSoOQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fuf7AV2PzLqBlOUFkYGlAzZlJTmGDOudwZyMtgrBKwhoKSWTgoxH7xHvkHyxYYb8s9qQ2KxGnqv3MehUZ4n+sW5c1UwTqY3/ZuTQ4sTDCZX4aZg6KBQXRKNHipOWxEUvfAAqTk59Q8jOVXOqThI6UK15vXq67Wqk3V94ew7KrnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dad2kkSu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xzPidn4B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dad2kkSu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xzPidn4B"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45I7tPHd031961;
	Tue, 18 Jun 2024 15:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=1WWUPiwzlnTRFsW8YMZIrDPPukZj9hR2dJAig4SGuOE=; b=
	dad2kkSuc6ypHDJxlgB6GHR+3g7PRqlnYXfnamTDgWEv468DaQHBQ5IaXLMPoyVV
	PtLz/sLU5pAR8zbT/rVKlo/p7ffM/kmCnM+nXJwk2yDmuZ+DX9ifT2KOzxusco4W
	XYicvFGmXFDOWlkTCDwA5gHiHJlbCbpgAaKP+G413DO8mRSRdWU9SMFXgW3aUC1e
	xXSrAM8Hg3aNyaXb1H36rDtyxfdSWArxcaAoAD8fmUfSTHUUDWt3uVgu8mZdyy5S
	579FhyKjCLfPzuH+NTfd/anvkhxzTERdFlOa/htKRdUnI96w+jTRxqRRCYCXRDg/
	QfcKwiPdh/spj7xU/y9hRg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys30bn5wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 15:21:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45IEUDw0031332;
	Tue, 18 Jun 2024 15:21:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d814ff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 15:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEM3Es4jyekhAxVO7gJXaVcQESx7svqQkpsl1oSAjs6o11ranAV3g4KF60xnQBmkWstR7s8wnjiAwhXD21D2bGkXa/VH071oWRCHpHHVvpG/fln6x9jBNV7FOYAtHgyxPYfUAUi+VgLUdllxpKAB0g93TyO4wGDooc0OA68j9VKYkwM4hicwErLM3m+7o2QYCrqj2GVjHB00xbDQU/QrkXmmjJb1awJggefuzPAqPM1yz8J7Wz8YLtFlUCOYvSmpTcu9AdFzWyJzul2yXPesGOT3oO0ZWf9vVXjCT6jfytSQ2IIONSxLI8x55yBioFxc0lM554Y3356zxsL+rEB1vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WWUPiwzlnTRFsW8YMZIrDPPukZj9hR2dJAig4SGuOE=;
 b=hVxev2OnRvbzU0YY7lJYBcNFoUiFvWUb+D6DMtIx7BLoijz8lVEIlJ/DDpMFXrIo+TbVJDnnS6yNLEpLdQH9XuwFMOLPXDmWYlgmFyjpGOl+RY+jRMBrKdIUg3LBkSpl4dlDerRU8/ZM6jRpP6e7rpWNHekfIeedrNUbdBmXdDnnuDRKzjg3XT4kLElUOIYCcbkxsJOrnL5qqwLsemXFE9+Gv12FSrPciScYfyJ8qGdYknn5IfnhFqHqZZ6mFjy4iwP3f5a0WUNBIhEUTRAW65HSv1goJod6CWUFPJXZhJ3RhssWkCgfjGoyo7VSP8SLga+wA462hBmt4TCBQfEsEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WWUPiwzlnTRFsW8YMZIrDPPukZj9hR2dJAig4SGuOE=;
 b=xzPidn4Bkt9EjVlBrbNAfrU42KDk2wWvB8pGatOsk4paIXxtDcgcpuajcztcff4i3G8dt6DF9APrzwPGootlE3MWuB15WUZng3dJfOoLwljsdxBKvYp7WVRg41jlw7oIVAHZVpdb2wWXDK/3vYtXVb63/VsLZNga0YTnLuJF/Zw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6062.namprd10.prod.outlook.com (2603:10b6:8:b7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.19; Tue, 18 Jun 2024 15:21:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 15:21:07 +0000
Message-ID: <c4ad0886-6148-4714-b91e-3f669d438dcf@oracle.com>
Date: Tue, 18 Jun 2024 16:21:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        damien.lemoal@opensource.wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
References: <20240613122355.7797-1-yangxingui@huawei.com>
 <437c99f4-a67d-48d9-98ee-58cbbc3d19f4@oracle.com>
 <815fcddf-85cc-126e-4be1-618b5ba8f823@huawei.com>
 <bfc045d4-746e-4555-9e17-5a0be57ac787@oracle.com>
 <d590fde9-69bc-0b9c-c907-0b90838e5f94@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d590fde9-69bc-0b9c-c907-0b90838e5f94@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0028.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: a977ad6f-b68e-4462-d638-08dc8faa46cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?RDRxQmVKOGdIUE1JakFpd1ZHMTJVcTRHcWVvT01Ua0dsK1pmdVd4YjBDSFF5?=
 =?utf-8?B?bjRpUDh3MVlxQ3BaVTNSR0dheXhsaWgzOWx2eGVlK1g3RDZ4bVhTWW41T1R0?=
 =?utf-8?B?WFBXS1UxYnVuUzNmdHBvbmpKY2IrTmZuVThTUGxrY1J3RzlYMkZwNDJ0MHU1?=
 =?utf-8?B?OW9yendpZGFUcnZDVkliZEJNb016dms3SHBiNEljdzBFZmZCeUNmc0dGdmhp?=
 =?utf-8?B?bEx6SExmWmpZN2w3aWEyVno4WW5ic293U1NTQVhVaHpDUHczRGd6bHZlNThm?=
 =?utf-8?B?RTF2bG9hQmhMYjRSa3pwWlA3T1VQajU5QXc2d2IrYlpzMXF6Tk5Dbkk0TWxB?=
 =?utf-8?B?SVhiamhyWkNTeEpuVW5RUlJWWmRNOWVTNnJKSmdVRzhNMjMvMmZLS21uUGUv?=
 =?utf-8?B?YWRwTGNCMHZzdHlNbjl6cUNCL0R0RGtjNDRZcE1GcHdsWEVTY2Q0c1k0c1FQ?=
 =?utf-8?B?WnZVMTk2M0dmamM0TWJKMGdJaHhpbkVCS29PSWZGYlVvajJSWm95WXBDNGNP?=
 =?utf-8?B?Y0hmYlRzRXV1Q3lyell2NFVUQ0tYYzFyOXVHWlo5Q21PTHdEdzEzUjVUY2Iw?=
 =?utf-8?B?cWNqRlFyRk5uOTRwdVVhbFh4YlgzMFhpZ1dhK0xwTlMxQWFYWHVhQUJmRG1n?=
 =?utf-8?B?RVdVQWpKYzBSOEpSaUYrenpId0YrU2h5eHBxYlM3bklFc09sZDV6aHNidkpB?=
 =?utf-8?B?WkxRQWNTRHBTYjI0NzdpeGdMQmFpdGsxMTJkNnY5N0pTUHdTZk1HYStpQjFm?=
 =?utf-8?B?T1QyRzRGaHdycHJxdHZHM0ZwMGRGbklmN1dzU1dJdldzdWFVNXVPL1dpZGpI?=
 =?utf-8?B?R3VhdDNDUzhCUytOa0NoUHY3ZVZlS3ppR0pMbEY1TVh2MU41RlA5SDJ1MS8w?=
 =?utf-8?B?YndiZk4rdGcyYkVNdVNrdUlzU0h1T2xKT29CdUNGcDdwN3RsVVcxT0dpTExK?=
 =?utf-8?B?bGR0aDJsUFRHSHNKYmk3a05zendQWERlRnlBaVRadFdsdkVGcWRoZ0cwZnp1?=
 =?utf-8?B?ZnpWVkpieEt0YUxTUW0xMTJlR1IzWHBsQWN4UWUrT1A2S0pKMTZpajdtN0Rl?=
 =?utf-8?B?UEtSU2NNSFI4RFpFNXV6aUd0ZkJCR3ZSbUpkYlAyYUthUGNOdWRsdXI2dEty?=
 =?utf-8?B?dTZXSzNvZ2JQUDlodnROdmw0eFhFSm9DZmhiOXhlUS8vREVBS096SlNyY1Ns?=
 =?utf-8?B?Vk9KVHNYUGs4WWF3R3Q0MnN6c2J4cnpHSVlRQ2g5V09UajQvamRNZC9HTUxK?=
 =?utf-8?B?YVNjMHcrTFhNWVhQcG9FY01aYSt2RzIvYWdYNEpYQ2FNdGV0RzBsYzNYN0d3?=
 =?utf-8?B?L1I4OThFNkIxSzh0VEtJVGx0OHhRdW5YZ3l4RTgzQ0JkYkNiUHlBOWtvTHI2?=
 =?utf-8?B?bW5GSFJxMGRpNEMzR0ttSDJXb0ErbDFKenpTMkxZcUxaT0l6dklPQXhHRVNL?=
 =?utf-8?B?THFGSkRqcEV0dXRvcDhXRzAxZWFXdy8wdENrd1ZvUWhWQXFDalFiRUxyNnJY?=
 =?utf-8?B?dG1mWWZCUDNzZVRydno2ZmdUKzVvdjFBSFRtU1ppVVNjR1FxdkJjU3lCMTRx?=
 =?utf-8?B?WGpwZG9aNk81MG5UbEtOQUtlVysvSjF0RnZ4Tk1KWG5FTG01a2R4S1V1WnRY?=
 =?utf-8?B?YndjdHN2MGkweHIvcDg4aTMybHdQV0dRcnAvZis3UGRPREtYSEM4T3lJWkc0?=
 =?utf-8?B?YlVUY0p5Mnp1b0pCMjVvaHdodXZHaHNrU2JLVmRieG1WNXVjYkpvd1NhR2Vz?=
 =?utf-8?Q?NCvmsUEutR3KgOPxJp6BzFvk6ZaSb28Bo3IZulV?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cXZzR2xFQ1R0WHFvV01pdXNEamY2VmlMekdlNU9lRnUxNVNxUytCOW5odDNp?=
 =?utf-8?B?MjdyTHZ1cGloL25jTjhrdmprc3ZnWXFNTlN3Vk1OelU2LzFJSnlLekE4ZzJT?=
 =?utf-8?B?dHpwb1EzejQwbDk4UFBHYjZYNjE1ZUphU3E4T2o3dEtlcUxwQmIyTjl3K0Za?=
 =?utf-8?B?b25GMkRYM3kwNksyY29iZ0I2cXJJZjVPYlN0ZjRjSjJVek80Ny83dU1nODla?=
 =?utf-8?B?ZlVFOFFnS3FUdFNjdUFQbm0vNlVHTXNaaWFRRGJMa3hRVzY3cm9uRWdkUVNC?=
 =?utf-8?B?SjV6Y0YzeU5HTUxGdDRsN0ZkLytwbTY0OTg5S25qaEVVanRXWDlUQ2dDcXdk?=
 =?utf-8?B?Y3hIbWtyVFg5R1FOdjBiUThkSFV2NW9MdlFpNWVHcFlMM1ZFMmtPU2thTS9K?=
 =?utf-8?B?L1NWR2VjMG9CWkYrakVLT2wrc1ZYN3MvVXMxSXZDSTVYdm5KMkltL04vcVVp?=
 =?utf-8?B?R29leURiNzhuSW1ic1VTY204a3BDZ3ZIaDVWZnp6NVg3NDc5SWowaTFIZXVU?=
 =?utf-8?B?REtyTHBKU0NaVXZFUDltZTRQclIxTm1Zdk80b3IzQmN6SHBIQkgyckdIZ3dp?=
 =?utf-8?B?TlUvUDN0WGhCRUx6Vk5UZWg3eFFHYUQwRlE5YS9yMEVYZFJPdEd5N1FXR21w?=
 =?utf-8?B?N1UySGNlbTh4L0FxVUl2eUZmTThkc05SN3BxVEd2MmxjSlhwaDdXOUdRVGZS?=
 =?utf-8?B?WEV1NGlEQ1I0VklKbCt3Y0gxdDhZZzBxVFNjdERXRWVmK3k1Rkdta0tvK29v?=
 =?utf-8?B?cVhZbktCdTBTVEJxUVlUOTl5TkhRMy9ZcnZEVi94bzl4R3htOUwrK1hSMEMv?=
 =?utf-8?B?THJvVVY5YVF6WEhoNzkvMWVXYml0WlNMQzNxRXRtUjI2QmJGdkM0R01ITUdU?=
 =?utf-8?B?NGdaWC9KUmxEc08rMmtRdHkyVXYrRTFRMnNXVElneXhNWkFZckFiU3FRUDJq?=
 =?utf-8?B?bHdPbTY3RTVTRm1pWXBKN0xYUWNwUU9OOWljWkFNRmZ2K25lVFJmemorNDNL?=
 =?utf-8?B?YjkwWGdXcTBTdXdHazMvT1MwcHpIaGgweGsvWVljV0s2TlZNS3h3Q2FkN2o0?=
 =?utf-8?B?amxPUTlnUFNFZldwSVA1a28xV3JxSXQ3TjJYZmw1WmErNmtpdHNaUWcyS2k3?=
 =?utf-8?B?TURVUGhqSU1UOFgzazNPTGRZRkxLS2JJbm5TV3NLVThjbHhmcGxDTjE5UWsz?=
 =?utf-8?B?ZW1SWis4L3pMRWVtVWlQTk1wZGNNT0hiMWdGTWJYSUlRTUpWTU5sSTZNV1Bj?=
 =?utf-8?B?YVFEakU1VkdEZElvNHFtSzI4VEZFVDNCdGNtZzRMbU10azZTUDJ0ODcxUHR3?=
 =?utf-8?B?ODhlclkzVWpkTEZTcW5MUEJtVEJyRnNsNmtXbjlob3NxdlBva2lXQW1qR1la?=
 =?utf-8?B?ZkJ5VUdHUkp0NUNMQVNPWlNzZHZUanliL0I3WW9TMXZwRGtGKzE0VWQvZ2tG?=
 =?utf-8?B?QUJTL2s2Zm1BUzNpbElqU3N0YnVGL3lQS2NSa2pkY0RDQlY1VnFTaTF3QWNX?=
 =?utf-8?B?QzBZbkpzeCtFc0JKMW9pRG0ya2pWdnBvQ0tyRUxzZFU5Q2xIdHAxdDZtYUhU?=
 =?utf-8?B?eS8rVm9zR01UZFZaVU1EdE5QYWhvWWxhQ0hjOUhEdlRleHFuckhYenJEWU5h?=
 =?utf-8?B?cTZjMDB2R1JyVVBrRDl0dHJFUzZCOEllQ0ZDU2gxanpoanV1cC9OSTlUc256?=
 =?utf-8?B?dkFidVFhTGVlQnAydWJ0V0VlYnRjZFhReE5SVlRXZEVuT0M4Rkt2Vmt0UUN0?=
 =?utf-8?B?Y1QvYWNHOFNKNFFIVjRXL0Q4OGRzRVFPczJocjNwU3FGYVZOUW1OZ3poKy8x?=
 =?utf-8?B?L1dnZ1M5M0VVVWwzMEx0bVJ0eTZKd0JHL29LTkJZcTVwbnF0WURQYTMrUG9B?=
 =?utf-8?B?YmJveXI3cFAzUmpmNnZueWhaQVZzZmtvMDYyNzBZeVJhc0x2bVM0Zk9uTExw?=
 =?utf-8?B?dC9aaHlQMkxPTTlsSkNjVW12NzhEWWlTRUJiQ0NjbHFwMk5ZRmg1NWM2dXZn?=
 =?utf-8?B?S2lJUkF6dDBVekVDWXFVRGNzTHZsZ3Z5N0xzN0FJUGo5M0VTSVFVTlI3bUVu?=
 =?utf-8?B?emhVOVhzSzA3UDJYb3FGVmVuazRnbmZhUis5Y1BmWFJTNitHZ2ZJcGJ4d3JU?=
 =?utf-8?Q?rbRu3JjTU4fFrU4Z0iATzE/gu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	aT/nzk/omuZiEHnV+h9evwcQULvt0oqiDmuBQF3FlGcbhWENraBSglM6Qsz6akh/O5iwa2axGUidyGpy7WeXq7O17FouvipeveDrp/4a8ifIm9t/FGWUNgAdUbPX+ThNT/qJYVmYz81Qf/GXK9CLbnr4NoFTjgFdVK9yOhELdJUlgB9/ULmgbyMeTfNQFFLwoURQWCMoNGvXeLauqef9ppyy8nUubsJX8ImMXS6FaMddqhkBzN2MJXflnriLO/cqSVnCyPvbzPmUgOKen5axkd7rhvydSyMrhJTZYOh2MZyRWtCr+hAlRMwyWI9aifL4lbPXYRrDnpZdSLR3DZa6Gc1dAPG1knW64y6hlcYofhp23mfNZgOf9w0t+3Zq3EftDH2nw7xlveuUg8QE0xP0VPYT++LHEA2mVDL5hiIR6M3BRBymBqKlLUB1bXSsUdKxgcFJUUpVdrNVvVhbHhu2Bei2PpL7ATXp3Jbfd3N72wj6K4bYKQsjXLsbywJ69cKB5kbIiew09zTMIMQ0a15C2RNfvsBm7rfUkhKh0JR4WOtA7C0rkhct6fpix0ysXiB87rtpoQFHm8rjwg7+ea1lpPyqzCW1Zo7ceMB/n6+BrgI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a977ad6f-b68e-4462-d638-08dc8faa46cf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 15:21:07.9347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hu8hKU46IgjHBZwDMetB6I1DirFXecpB/veaSQiJayxILStG3+rUN31ThRtmTByTgwNJE79NNsfhiyOuC/NEEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6062
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=733 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406180115
X-Proofpoint-GUID: jyW_2E6-hWcOCw2XLEwNGeTMKcwx78d3
X-Proofpoint-ORIG-GUID: jyW_2E6-hWcOCw2XLEwNGeTMKcwx78d3

On 18/06/2024 14:10, yangxingui wrote:
>>>>
>>>>> We found that it is judged as broadcast flutter when the 
>>>>> exp-attached end
>>>>> device reconnects after probe failed, as follows:
>>>>>
>>>>> [78779.654026] sas: broadcast received: 0
>>>>> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
>>>>> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>>>>> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated 
>>>>> BROADCAST(CHANGE)
>>>>> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
>>>>> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 
>>>>> 500e004aaaaaaa05 (stp)
>>>>> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
>>>>> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 
>>>>> 0x0
>>>>> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>>>> ...
>>>>> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 
>>>>> 0 tries: 1
>>>>> [78835.171344] sas: sas_probe_sata: for exp-attached device 
>>>>> 500e004aaaaaaa05 returned -19
>>>>> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
>>>>> [78835.187487] sas: broadcast received: 0
>>>>> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
>>>>> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>>>>> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated 
>>>>> BROADCAST(CHANGE)
>>>>> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
>>>>> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 
>>>>> 500e004aaaaaaa05 (stp)
>>>>> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
>>>>> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 
>>>>> 0x0
>>>>>
>>>>> The cause of the problem is that the related ex_phy's 
>>>>> attached_sas_addr was
>>>>> not cleared after the end device probe failed. In order to solve 
>>>>> the above
>>>>> problem, a function sas_ex_unregister_end_dev() is defined to clear 
>>>>> the
>>>>> ex_phy information and unregister the end device after the 
>>>>> exp-attached end
>>>>> device probe failed.
>>>>
>>>> Can you just manually clear the ex_phy's attached_sas_addr at the 
>>>> appropiate point (along with calling sas_unregister_dev())? It seems 
>>>> that we are using heavy-handed approach in calling 
>>>> sas_unregister_devs_sas_addr(), which does the clearing and much more.
>>>
>>> I just tried it and it worked. If we only clear ex_phy's 
>>> attached_sas_addr, there is no need to call sas_destruct_ports(). We 
>>> are currently using sas_unregister_devs_sas_addr() which will add the 
>>> port to sas_port_del_list, so we need to call sas_destruct_ports() 
>>> separately to delete the port.
>>>
>>> Should we also delete the port after the devices probe failed?
>>
>> I'm not sure. Please check it.
>>
>> sas_fail_probe() would still call sas_unregister_dev(), as required.
>>
>> And you said that the sas_fail_probe() probe call would be 
>> asynchronous to sas_revalidate_domainin(). I actually expected you to 
>> have the new call to sas_destruct_ports() at the top of 
>> sas_revalidate_domainin(), like v2, but it is in sas_probe_devices().
>>
>> Anyway, please check whether you require this additional call to 
>> delete the port.
>>
> Sorry, there was something wrong with the previous process description.
> the correct is:
> 
> 1. REVALIDATING DOMAIN
> 2. new device attached, create port,etc.
> 4. done REVALIDATING DOMAIN
> 5. @out, handle parent->port->sas_port_del_list
> 6. sas_probe_devices()
> 7. if device probe failed in step 6 and call 
> sas_unregister_devs_sas_addr(), then add phy->port->list to 
> parent->port->sas_port_del_list // port won't delete
> 
> 8. next, REVALIDATING DOMAIN
> 9. new device attached
> 10. new port create failed, as port already exits.
> 
> 
> So, v3 delete port at then end of sas_probe_devices(). And if we don't 
> use sas_unregister_devs_sas_addr() follow your suggestion then we don't 
> need to call sas_destruct_ports().

I am finding it hard to follow you now.

Can you show the complete change which you think that we now require to 
fix this issue?

