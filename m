Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F053B27F3;
	Mon, 27 Jul 2026 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166648; cv=fail; b=DRmWg2TIehraHW3MugZby1UcYXjmUS34Ki7ILHmjmTPS/2MEmse52Lw2cV0meRhrUuSWE5y6YCtvLmH/e8VmNVzKM8om8nRoGR7uSMZs9nItBloDTaeuY1tq8zUKN6eidfJgLdO6lQRVSeGLAlbeUVwZHN6kDFxMG5lAQgeSitA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166648; c=relaxed/simple;
	bh=yR7x6YZ0zMw/ssYCbffh2nZ0XRvFKy2kc5X0xb+VEVM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FHR7rP+2E+46fNxsFCWrvkOzo03LZJiQ1EAE22W/GGoY7eWA7gCAge333bvLsxhXvZvS5XD6I7ozgbJwHRJSfeldv1jn+2dXQe0m6BFUepgvgZLEediRP49uboAjUG4Hdn/KRB/sERxbkGg1Z87WyJ1cYkolpE0hb9o5JILkCGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pYqAR1XD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N3dOVTMG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pYqAR1XD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N3dOVTMG"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RFXXp92420329;
	Mon, 27 Jul 2026 15:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RXrz7e1EPt/qiJ+omZBAN43Z5qpulWhcsKO/uXa62rg=; b=
	pYqAR1XDhZ5/L8P27CjOZOuxuXMMKVDGAud83nTM/nguV4VTdZdrYXVgVQUuL+S+
	LDfi9yuc2qfhNiYr2cVvfDRONLCRoH1RHSrkKlZqPzap+Puicr5q9jVKZgxiduvT
	p+Dm7NI8czaYzAB/Jo+oYrP4ul3dOBSGJxkgB1+ZcQrzDt4pMaXUk4+Nq2JlDBfS
	exZsJiTtlu/x0q6t65ZFaEeacQVRcoF+tswPCBro4VsuT21UU6BHsEQe3RRFkH3r
	un8LZ2iuF4b7igcH8cQGS8ETX21uDcsL2BhjgibBPrfNF7tMcQ7DOpNeHNf8JV4W
	hAJWrY+JLDq8MMwi14JvjA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xt289-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:37:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFZ7LV009965;
	Mon, 27 Jul 2026 15:37:22 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011028.outbound.protection.outlook.com [52.101.57.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh85ud13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:37:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELZqXeajr7sQY7KOPZyiyIdrRywUCTujflG3hvy/NbIFoDpIZF7wcz9r0HL4+PNorlae2Va7NlJYYSLZqu2+iaqtz4MHysJXNCSUHwXaNz77e4OTRGc2cOjfN+KXbF32HhezOCNT6y2SJX5iMMn+pQGHdv+2pptUlXi98sfBxDENSfvwxqZ2t1LjhsCfWqvFdNtLXOC1iGx8iw4JJYdnJ9yb5Jp5vat0d+sEHBE3RgZ/pgyMAtIjwERcqWYo1E9KHxomYoUCLagx19hiKk7EgdMjo3w+3qjw88vC/BzMXbhQHNmOCNv/0C19FHyNXue5MPWpk75bBc8+sjKWV+AY3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXrz7e1EPt/qiJ+omZBAN43Z5qpulWhcsKO/uXa62rg=;
 b=gOmK4bPwVfPaos59uLB++Tonr7YT3tUtWAe6ughfYjkkw4QZKlIY56ZO9Q3gOWKgRCVHZm0MRdFOL0HJHZ0jPuk62ss/oIT9yv9itUdY1b8DazonhaX1gLNMiDSvMvDctv2wMGlvZXtF+hfqVMgfAjSSIusL/khXYRyt6inhzf7HICiqHzgrKEsLi2SOC+4MiCZQJVW7Qz0P/rtw0b/oEMowe9gNuJrK4yy6aorzId2J8eutoEYh/146rIdX0QiSXiKM3Ex9vYYdtju76KjOD2o3KWEN8OQFZ/+O+UOSpMU08bBbPn1BcXf4qhHcIWqxTj1HFnkj58QjOnZp7X63jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXrz7e1EPt/qiJ+omZBAN43Z5qpulWhcsKO/uXa62rg=;
 b=N3dOVTMG8ASwUvP0X/z7Z4VnbYTMo/phEUqsx8z2SVH0zq/hjC3R3Nmg/aeifcjPo+LVDQ4XKkZjLp95fjOOl/jjNbPFsvvPJEB7iMM94xk9zqeVKzjB8kZNOkH6I+/OelKe6MvVyHb9vgeRbN53USCqvMN/IHUp+AgI1sAj79g=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW4PR10MB5882.namprd10.prod.outlook.com (2603:10b6:303:18f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 15:37:16 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:37:15 +0000
Message-ID: <3a372f24-8342-430b-8097-9694addf59f9@oracle.com>
Date: Mon, 27 Jul 2026 16:37:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/27] scsi-multipath: introduce scsi_device head
 structure
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-13-john.g.garry@oracle.com>
 <20260727151547.AF75D1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727151547.AF75D1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0207.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW4PR10MB5882:EE_
X-MS-Office365-Filtering-Correlation-Id: c8d9f9b6-86a8-42bb-be41-08deebf4ef09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|5023799004|10067099003|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	n0zMSHQPkNykQikrTNy31TsMNbFJ/mqdh95HBxk+iiEOsHNkMoeryGuP4sSWPA3GcE0u35PlNKoLaukW63OxYrZvMWwEEYUdbgRrLtg2THHavhjJeo4UpjwnLxv0hTvevghOth7uJ9bciN7NF8HcUkwYpYrJPObjpYqXlnNbsi0ku6j9FZuJ4NBB+M0p39+S1f3/8JlnJa74vDteyB/CdZfq8LIATcfuJH2lo2qSC5nLDZ+9dI0vk9mx+087Nd1qj6V5TDPTI1xs/LKb7tXeU0Hvl+ueOQaOu83C7LODcrDr9ovHWT5fgP9f2B5/puCc9mI+ULJq2y32VZAh99/khTqQhvOnz++GUwsB55ojCtNvOKZFsu8afTC6ybbAMVX8ZlZ9vkMR3D4w3qkAP98W0V00BGOLX3GTlG4/Cb5XvwNe8B5207IIu3zYSl93l3173zMhEEzhYzUNEzSLIsxfbgPmpYHHga5zfjtrM6PgrQQYan3yawXHqHPbLNfqQXebebvE19Atg13acHag4uX+1q7JmSByqcMcOXJJlVpwjfuy6D5mt9XD/8O2vbxwjn4Q5egi5/O3fR67ZETkNxk84cgiDqZFLyqsNhr4bOydMkZPhiHEog05T3BqJTft3d/glVqPBy9xk/lhniAm9YYrMcKiUvDf0x2PlRyewUpxXPI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(5023799004)(10067099003)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnJqRmpuSjZJRXdqaFdPNWE4M2UxT1pPNDRCNmlGSDZXRlFlNUhzTVpiMGJJ?=
 =?utf-8?B?dU5aRFNkMW1TOFk5YzhyTVhycjBjVENZVjdXQnp0Ulp1Qlh4TDRnOElFcnVs?=
 =?utf-8?B?dUVHbmVjdWdsNUFFdHJzWW1rUUVBQUNPeUdtR3Y1MVFGSXNDcjFDZnFVRStI?=
 =?utf-8?B?UVdFdkxXSkxwYUVmcXdCamZvdDRXSFk0dnBzTWxsVndselBjelFRVjN0YnBB?=
 =?utf-8?B?VWNhTVU2WjZCcFZuUHNYcTcvaE9nKzNtNmw3YlpCSVhqR1lOTW1wd2F0UWg4?=
 =?utf-8?B?bHpaaWNEblh0MEVWV1MwZWFlNE5TaU5yd2JOSzdIRk5nQ2hnL3lvcFNQN0wx?=
 =?utf-8?B?OWJCMmVsYUV6VFhIL3REdUdiM01sTUVWMUc1RXM3SlRBaHVic3d2cVcrWkxl?=
 =?utf-8?B?aGxSZmdUdk1DK1UxQUdDMWV2ajhoVDhoRmpCK3hlaVpuRG9mNXNlbkJuZFQ2?=
 =?utf-8?B?Sy9TbjlzNUU0OThxcVZvd3I4eVptbytEK0lCYVEyc0JXZmVFNVAvVTNXOTBi?=
 =?utf-8?B?cXdpRVErcy9idXkzcHBZSW9VRVZTcjV1R3ltSWJlNWxFRHdiOXk5Ky9jUW9O?=
 =?utf-8?B?Rk1kajVnNWRublJISGt2Nnc5WmlQTmZDN1NhS0J0NkRVVjBHRUNKUE1QUGJF?=
 =?utf-8?B?OFdMRDFnU1VmdnRTYjd5MGtXRzlkQVBqMDlrZWxSZlM2a3F2ai9mem45VVNQ?=
 =?utf-8?B?R1V5NzhuWGFSWTQyUkxNUFNxQTR4SlpaNE5QcnNGTFp5dU9uU1dlR1RCdXZ1?=
 =?utf-8?B?dktoOFhrc1NRVTg3TG9xOHNMbENDL0lLU0tJZlpuZ1FkWEtKaDdXU2V2ZmdJ?=
 =?utf-8?B?T3FPZUxzNXE1WTMvM2dwMlZKUlg1TXM4RHFEVHpHZThwb21hdkx2c2x6Nk0v?=
 =?utf-8?B?b25tUGFnOTJ3ODdkOVdzR2RmTkhqenVzVVdBSGgzZG9JK0l1eC9uN3ljdnlC?=
 =?utf-8?B?VDJEaXZoWUs1MUJnQ2pFOXJVQWlxWWl0ckpIaFZ5T1pUeWxldFlIcncxeGpO?=
 =?utf-8?B?azg1UTZPVndMa2o5MlE1ZklKSTZlVWN3eCs2RFMvQUZmWU42TUNHbktNYUdS?=
 =?utf-8?B?T3M3NVhtZG1FWTQrTTFjTllOTTVhUG5IRDk4VjU2bmw3c1VNcS9MUjJKZ0JV?=
 =?utf-8?B?TW5vRlNBQmtHNXZ5ZysxcFN0V2U1THFsUkRyS0RKU0hZNUVpYmJmYnBrdVNQ?=
 =?utf-8?B?WktxMWxTNFdCL2E4cFlSZWxoeWlUbUJJcnFiMHN0U1lleXFtaHdaZXhjQUs5?=
 =?utf-8?B?Y0ZXSkM0OU9NdzRaRXF3N0hlZlRJbVlaYVJBeXJHSnBWVEs0OGJZeHdlZEVz?=
 =?utf-8?B?T21wSzFZRzZsZmJjelJlYWxBN3hoWGdtMkY3K3VNaitOMXJzSW1RZXNBd0pz?=
 =?utf-8?B?Uk1WRDBpRDJDWVJWY1J5ekY2MGZJejlGUnVJTXlEamdIRC9EVHhFRDk0SldT?=
 =?utf-8?B?ZXhEczh0djd4SjBZd0F6bUozaWxYbEJ3QkpIaDVocndObmRlVHo5N29PWWpV?=
 =?utf-8?B?NEl4QkNldWhZVE5SV1lQT2VDN2ZoczluSkQzS0ZUNFFkVXZFN21obGdwTGp0?=
 =?utf-8?B?WnF0djFhUTNxUG14aUhWL3dVRUlYUzBBWHNoaUFCNloySlNrOUVtcDVUZUZY?=
 =?utf-8?B?ZURzNHVvdk00RldGOWo1Zm1oUnBWcnpkdTNNbkNkRlZUUFh5b2hjWUtwMStS?=
 =?utf-8?B?TXd4N0tLSCszME5yOGd3YU1oSXVjYlo0cEJ3ZU01UEh6RzR0VVVsbGxJMnc1?=
 =?utf-8?B?QUp6Uk5RYis4VHFWMnVWMDBNWWg1Yi9tdUMzbnpDc29UaFhNRkxGY2JnR0U5?=
 =?utf-8?B?WmQxOG5PTTF5K2U0ZE1ZSWxlcFlIQ2RPeXVqSUtsS3ZVOVRWUkhhRk5kYjBD?=
 =?utf-8?B?NG5wb0E1bUxvVi9KSG82VlZZd2h3TFRQNnRQMUlXS0dpaXhNa3Z3eWJiN0Zn?=
 =?utf-8?B?U2xRdE5LRjlidjIxZTQxVXJQODgyZUE3dWtKNmIzdkkvUVlqeU1XSDFJMWtJ?=
 =?utf-8?B?aVR2ajFCNm04OHFTdjNFcGptUzJwQzE4c0dkYUY0dGdEckJvOFduZHhGR2d1?=
 =?utf-8?B?bVhuQ2VxSmx4ZWhqN2pQQ25rZTg5M2NoUThvT1ZYMVZFZjk1aGNEMkRjb0JR?=
 =?utf-8?B?WEVVbndHWFVsd0JhekI2WVVqekZDaXFvOE5NMklmbG15TWljV3ljTmtYODBD?=
 =?utf-8?B?cGFsbUlzdDRZM21IOENiZlkva0VMek5TTlRBc1BFUGdReU44cVlhOWNhaEV3?=
 =?utf-8?B?bzNkTFFxSU9uMy9mYVFPeFdCcyt4bEVCRTlsVzJMcEZXclJQRlR0N1Q2U08y?=
 =?utf-8?B?dGRyVGJ1NkF1WkR0K1BhTnFLV3FvK2pqdnd4d2JsUjIvdjFOMmVubkJzUGt4?=
 =?utf-8?Q?S1QymloFHDkk8Xao=3D?=
X-Exchange-RoutingPolicyChecked:
	aT77YEBOxfiHmePit1qnMqn0iTMbjNw3x14lZUHfmk02+cugBqVSJzxZ0ZtvjIBOhhHt35xcbqFXUbphUpQmpVXdtcLwN7YDUIHG/Y/FXWDm0h+u9c4fYvEwhgJZck2YC3K4tHOHZg6oZNQ6NMELjTHBylFoOHxmp8h/hqQ2tdfYLAgesfQwYIgwlpMUoY7J24p93I754vgTVcCULU8oVFXgQCLHaAuazr03f0/k2HFgXq5Gi7buLPOfWnjkjp4/iQ+GEVGxyw/k7D2NBgelqHnmm2+NY14scPO+LEuVR9cC9xswdm6bKoObgQhhw/07uwlJSuQymy/sGqjUMfqusA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IYYMzLTmMwMXrMRtWkFyNcyAaw1K/zvb4amSS7HfFLXVoWR5HbbrqhAhHyfjVMc4VdLpGe3fQ8yUofGW8jVEY3HrE6FMDXXiJ729UY4VXZ+bYyZTqlG67OputBiLI2xF9rXWt7kjmy9Rqp/C14a2yUUawZf3heJHijybkP8IUW2CCYJ3OUYlVvsrQaOSWbW7l3exxgMp2F6gjHRITe3TX6zIqZ7bdbdSJwPlDayt7TJA8cS6PE24YBo4G88GoY7Pg/mSNe245WQIW3/3HP1P8tmOQfdPpV9q2NTMxZGat21uRklT42ZEXH/baUxIF9+1PvTaDlydzLDtqJdyL+KiBrCB7algaTeU3c0dpRpw80r9FNFimwF0FMXvX3kls4gulENroYNzlYnMoNsxx0jQvGt2U/R1U/hBxdoyTfa5CR9Aw7biLTozHUGW3znOXtfcvDwUsMGOJd98oweMh2NVWTE95V8FeWyYPjMdJDw9+ZY9jNTtELNDYxyL1IfFCB+dTylfNqgmW7jbZI+sZb5bhBZiDjRlOTkFFt3c8yXlKnxBdG2APH6pOvpYrJ9bn56xS+pJZ6FfoqxEDeiwRBH89gcD2FFwy5d2OqDfHLX+sHg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d9f9b6-86a8-42bb-be41-08deebf4ef09
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:37:15.1469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tsSdjDtdm6wOvS3U6dO89Gijqiz7vu9VoW183s5dyoQhj0pwZSjN5zXrh4BqsS+4EvYod6Urt4iAwF3+dcotdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5882
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270146
X-Proofpoint-ORIG-GUID: snUdNspW7MsXX3AEyPSdLBuXj3nRJz3l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NiBTYWx0ZWRfX8GBlL+a33GIX
 wilhU5hz4+3yTUwyb25JFntfDPhr1zmhLf1/zYXfcUUwiLOuBA6jR2xIogbIf763muuXJnjOfot
 8BuDcJA11qxiqHmbrqMaFlfbsRODwdWRu+81C6A8rHx/HyQ5FBqv4UqdLES0i2QRn0IddCaPjHG
 MMxzplI2h+ynuOEjfwgVsB5427r7nuOoqd7korkgLdwDH3mvebIeu2y0CzWN922JniY2aeO7loD
 wUvEqXl4BWABZDMAnoaVncCYjluWvK4W2s/EzrWDQMPBL/UZF132cgbO8X9nG2uuxwg5Z5LY+8x
 d44GTo5cMlZWfXnVxkQFz3VRNoafyQOUN16aTxm/4hJZzkfo5hDWZOaF7du/MIwms1IMW/OeOvu
 SXJJCiU7FwW1dFFDlLrXse8gHTZ88vijBGH50VHs+ZEEwKtPfkb9qRhMQ+wUCaOqiLMU06vP40R
 sXPqA+1Ff/g7pBOGwOA==
X-Proofpoint-GUID: snUdNspW7MsXX3AEyPSdLBuXj3nRJz3l
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a677b32 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=9TeFoSmYZMaWgVhgRgkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NiBTYWx0ZWRfXzTp/eGZa0MtI
 WOzh9qWNbMARG/7DZdpXufHu4P5btTXw/8qHhS8XqzUUbFZku2hKJpSj9X0ozJ8Ow8JP20KKmkP
 xR22ayvYSbkXWtBNVtyxFrseeCOVB5BY6X/HG9ZcE/mpo9Rp4Iqq

On 27/07/2026 16:15, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] The `smpdt` (mpath_head_template) is defined without implementing logically required callbacks, which will lead to a NULL pointer dereference.
> - [High] scsi_mpath_unique_lun_id treats a 0-length Unique LUN ID as success, leading to unintended grouping of devices with empty IDs.
> - [Low] The function `scsi_multipath_sysfs_group_visible` and the macro invocation `DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)` are defined but never used.
> --
> 
> --- Patch [12]: [PATCH v5 12/27] scsi-multipath: introduce scsi_device head structure ---
> commit 0296ab446bccfc5a00926fcca72b8b18f69d4e30
> Author: John Garry <john.garry@linux.dev>
> Subject: scsi-multipath: introduce scsi_device head structure
> 
> Introduce a scsi_device head structure - scsi_mpath_head - to manage
> multipathing for a scsi_device. This is similar to nvme_ns_head structure.
> A list of scsi_mpath_head structures is managed to lookup for matching
> multipathed scsi_device's.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 947f3e2103e6b..5d19ab6a89eb5 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -70,6 +74,55 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
> 
> [Severity: High]
> Does this function mistakenly treat a 0-length Unique LUN ID as success?
> 
> Looking at scsi_mpath_unique_lun_id() in drivers/scsi/scsi_multipath.c:
> 
> 	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
> 				SCSI_MPATH_DEVICE_ID_LEN);
> 	if (ret < 0)
> 		return ret;
> 
> If a SCSI device responds with a valid VPD page 0x83 but a 0-length SCSI name
> string, scsi_vpd_lun_id() returns 0. Since this code only checks if (ret < 0),
> it will accept 0 as success.

hmmm ... in checking scsi_vpd_lun_id(), I don't see how the length could 
ever be zero

> 
> This could cause the multipath subsystem to incorrectly group distinct devices
> with empty IDs together, as strncmp("", "", 256) will match, routing I/O
> intended for one disk to another entirely separate disk.
> 
>>   	return 0;
>>   }
>>   
>> +static void scsi_mpath_head_release(struct device *dev)
> [ ... ]
>> +static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
>> +{
>> +	return true;
>> +}
>> +DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
> 
> [Severity: Low]
> Are this function and macro invocation needed?
> 
> They appear to be defined but never used to gate an attribute group in this
> patch.

used later

> 
>> +
>> +static const struct attribute_group *scsi_mpath_device_groups[] = {
> [ ... ]
>> @@ -89,6 +142,74 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +static struct mpath_head_template smpdt = {
>> +};
> 
> [Severity: High]
> Can this empty template cause a NULL pointer dereference?
> 
> Because smpdt is defined as an empty struct, all its function pointers are
> NULL. The multipath core unconditionally invokes template callbacks (such as
> is_disabled and is_optimized) without checking for NULL.
> 
> When a multipath SCSI device is configured and processed, invoking these
> callbacks could trigger a kernel panic.

they are added later

> 
>> +
>> +static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head;
> [ ... ]
>> +	if (mpath_head_init(&scsi_mpath_head->mpath_head))
>> +		goto out_free;
>> +	scsi_mpath_head->mpath_head.mpdt = &smpdt;
> 

