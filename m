Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A07E571;
	Wed,  7 Oct 2026 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791332580; cv=fail; b=QI59QWZ79e3ShyxV+Qgx17vc4vTJux7bV+4DKbxGXUILXRTlJ4gvJUhyC/2dcVNthixXhX6C9nBsEMdhUSZAwu38+2KKMJmDSzyLWDUmBGMm7JDgO8Y7KosSR6JvqHjzhu4Xi1yg8iyouNfbxa6BZGcTXQ0/jxS3KOP19S6K+P4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791332580; c=relaxed/simple;
	bh=saZeyo4ZSIkh6n9SeaolMEUJ2TJ2iblKqjewUVgP2KA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 MIME-Version:Content-Type; b=lzmPVPZWY7bw293AxEH6LdSK4puHBizP4SV5kyPLD1DNDlKtnmhNsvC20y0FXOXy+eKZb3hNGCIrbF801SllRpiOSXsXV2HuZjIGPuG+KRR8ralg5tO8PSmsr65RcDcW2E5Ix7AaMZ2HMS2kwtUs7na+UI7KvwbPC2WisCceKbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zy640nc+; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lny/PN1k reason="signature verification failed"; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zy640nc+";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lny/PN1k"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696Lb3XY2553094;
	Wed, 7 Oct 2026 00:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VtVp4bhWrheUsOxz1OUz8d9AbU4LGKeo0cfong1ulqI=; b=
	Zy640nc+FcLJGqMSgD09ED+JdK612W4Y3Y5lBoIcmww9nhr0CzYn4PdD5KV/jx/V
	+4ekGmwe0kvjReoshpRb+Ui4K5KNT+TXwpY20FmHNSJ3hxuXr7grlR/QKLVxwdqU
	t1bliYb8sQV27z+B121bwg+2Ol1HdyiaEsOCOqk+nDaSRXfViLp8/lt8/cOh7dOJ
	0WSvcKLsGNEnBsmjAraI0NKa+YoGa3milSGsfvhgBRFvpdfqU7Ud/eov8slYS9pD
	+4Gifi52T8hlXO7Wi7oeFRtKabqE0IXwdWSrZge3re1ydvOFppR6rbBlAcMAcopU
	abgxn/dJ9KR/7DSAxHUQzg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2srcvwk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Oct 2026 00:22:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6970LAso036773;
	Wed, 7 Oct 2026 00:22:53 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d00ac9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 07 Oct 2026 00:22:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xxGYB8caWBZaF66ahEffl0j+PbY6ALfLzzYwD032mPkGNWJMnL1l+p9wpipTp3sAUMBiemAGcsu3E1qL2mMJ9E56Nx7ROpP/1gSh/kErc+x6G4MDIZGo4hOJ7YUJhbiELC6J0pW16E6PfMMkFcvePvpQ/13ExtoLvTJuxl0ElSdrRVOuc8EgAoTDynO/dRD3y2K4Yn6FLK4p9HTbqXgcfqF/oEQib8gvdvv0/tNODvStRBwoiIey4GIvTPskEBqyXYvWb3Wj60ggmOQcGeK5dI1XIcxf5DTYt+UQ/nNyOCFWsZamrBOAdeDzcS9N8fuswbvIvTLc9KW9wLof76eK4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Vu/WTM7PXIf2Rwu7t4zT9OVwuelunPXv6NJa5zo6Zs=;
 b=N3s9GHqKhMLYDoj4MczirE01ykufrayC1ad5ynH1tJHHwvi+DrL+1QY2RLP6ERhyyJIM064VEMgI4BheFkZinawS05AYbrobns/xT84YuLwNmgmTtNXu7pMUXRrDgp86BFI9uWfNZ0bgIvxQ2ZKq0NoNMM3m+2e1xCzXZ6Bp5SWdwfcdBBQccT/22j/KsNzoSqKaPooLpAex5uNiMv2iy+ga/Q8SFQuKYcLiYYuc0iMUcwtNrqg/XQxpW/olOk4SHcLYqrUI2/Yfqyfm5gqFDlBYvAWiyCPwPpYrTkJMrSNCU6H6TnrsKYlnxAm3iaTKjXhd4agJLVdaYMnKkqg8sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Vu/WTM7PXIf2Rwu7t4zT9OVwuelunPXv6NJa5zo6Zs=;
 b=lny/PN1kXfVFLxehIFb3BlaqGGGY9wIgieMP2J0OQFrnxNIqBfbiw2t/0N+Ukyxf+eHe4yze7JgXJMOQXjRhwGUwYfGpyOmXgvkDL6CLYi03QHDX2lWomN22/YCUPgWQ4YwPcmKB5OP+4Th42XOC0CWpaM0Jd6bSYNVl1mzg6ag=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by DS4PR10MB997575.namprd10.prod.outlook.com
 (2603:10b6:8:31e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 00:22:48 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120%8]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 00:22:48 +0000
Message-ID: <ebf6b4a2-5dc5-43da-a19d-3d9774b28825@oracle.com>
Date: Tue, 6 Oct 2026 19:22:47 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: Disable interrupts while holding
 delayed_cmd_lock
To: Yu Zhang <yuz08559@gmail.com>, mkp@kernel.org
Cc: d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260927091329.13482-1-yuz08559@gmail.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260927091329.13482-1-yuz08559@gmail.com>
X-ClientProxiedBy: DM6PR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::21) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|DS4PR10MB997575:EE_
X-MS-Office365-Filtering-Correlation-Id: 8808415d-9671-4f40-e4d5-08df24091dfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|56012099006|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	7CT99sO/W8ts01bpWO8AcCGYuaYHPGKFDUW1RelpH68YyGy7c4NKuykKWV7iBptO2wE8Y32DmxzMLo6lgjKeSUgilCZ0dgDvTotuNc8BsYAGrGsC6MPsym5iTX9AaHZai5kKh/K27DFWokLn01KEedH7amYedFBxltiVwv2iKH9Qz4koflCof3wTPBI3IbNDUPpuZFDZ7A+NoaessPJBk2V8OXxbNXXK0pW2Z/qs1/qYrETmOGTz+lTRK1N+kG+BtvrlNamP+IY1wfJ9I9cf8o1P3p+P7Y0F+YqL44KpOU0MJdgc0Kg6GDtcGeFK9mD2l8N71LdfrqOKosh4Oi/xMJDo7SNJnHrFPJI01JA3HjXRmK9ozIDjJlQ+ykv9hAcx+blZA32sELEJ5tWB4hKYhZ7gBgw7ZTrLZeZRVbF0NwRblv8tkxGIvL134FFQ7C56L9yO/jXsno+ycired6bwtz0sNccYe9QG3kORz60CCt2/MoShd/oKj3Cyo3VF9wzf1cyrraRUfpx0A+yvqxYz7evXeEzSa59/1v4Ny2DIhC1c1Cx2Pfb7Yx0Z8K1I5iidj2/C5qWrACSbJrftCpUeFz35nmoYEZGAbXXbpn7RF449I5z9CKhXd38kUkUtOjuwDXcoroqkdC/EjrbjritqqP0dzcKaKfTT+l7/0NeFTYM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnJDdUtEZkdSK2p4Z1ljNXF6NGxKeDE0d2FwNFllMnEySGdyc2JYSUJXLzFs?=
 =?utf-8?B?WUJnY3Y3aGkydU1nWHo1Y0Zrdzd6eUJ1c3hVSnJ2NlJFVUkwQUV6b1NYWG93?=
 =?utf-8?B?Y3VkUzZLanFoVU5FQ01lcXY0dyttd1pVYTJuS1UrTUdDbHIwd0RGMFU5MkFX?=
 =?utf-8?B?WW5obUhPVjc3VEdvRFdDUGZidkFiQk1BelhMYzVEaHZQdFp4U1FSY1hVcllu?=
 =?utf-8?B?Rm1SOXZnV1A5c2JFUCtwZzNVS08rZ01Vd01HNTNxYzB2a3F6bGR0VUNKcy9L?=
 =?utf-8?B?eGZwaG5heXVBVHk3UDF6TTZBSXBKWDRzQ1pjU0ZVTHZ3Vm5JMjd6VlJkUnIz?=
 =?utf-8?B?QlZpWlB6VEh3UzdBeTBUREM0blNlVjNsRnBrUVJSUzhTdmVtVzEyT0pLSlpk?=
 =?utf-8?B?YzhTRUJpT2ZiSXo0bGpFMzR3YUk1bW9TMEJIbUp1TE83aFBKWGd0RjhPeUkr?=
 =?utf-8?B?Z1htKzI4T2E1WWtocmFRelA0ZzlZbnZsTUdkbEJqa3oxN1d5dGVPaGF1Q1k1?=
 =?utf-8?B?N25Qbmpncm5sM3hXNmtuZGp2cjZtWTl3MGg2YmxONGZpOVBWNFhJdmV1d1Zq?=
 =?utf-8?B?RUxxUnlIQWxVa05Eb0ZwMGZFaW5OdG5wY3lweU5YM0c5RVcwVTliT2NyR3BH?=
 =?utf-8?B?eHJhdm5BQWdkbncxQXV1U2RHMnYrbHpuRmtXK1FWWHNCd0VaRjZ2ZnNENEUr?=
 =?utf-8?B?dE9tQ3FOdkU4bzdsajY2RzF2RWRmdnBDSTZiSk9YSlVZd0N4ZjdNV1E0dytx?=
 =?utf-8?B?ZDFWNi9qZDVvTWNORnFocGhSN0NISkd1ZG96Yzl1QVVNL2lqcktuajJVRVdO?=
 =?utf-8?B?UDMxYlBLbFVSdkQxRDhEL25WWEhDZWRqUkFWYWhqRHVFaDByZWNobTBpQjVQ?=
 =?utf-8?B?cGx3andLN0VYYnZoVlZFK0VPdTdyYU5Qa3NqbXNsOHcyN0JDcTNXRlpRTVZ4?=
 =?utf-8?B?UTU2bzRmbDExZ3dVRUpUNUxUb0tGOGNWa3ZjUEpuc3JVN3hZVXcrb21ybTUv?=
 =?utf-8?B?a2JER3NzTmdUVTh6bkY2eUVrcmxBajl6WTN5ZkhVSndlSldJdFBLQU5WMFA1?=
 =?utf-8?B?RVJhWXBVV2hWU0VaaUt4UTZxTVhWZWIrMncyMmdXWmoyVkx5T0tlMEpZYTlw?=
 =?utf-8?B?VU9ZMVFWNk5tR1ZseGVKd3gyRC8yT1lTYWNCZjkwdkExanh6TmJ6QmtiS1hW?=
 =?utf-8?B?d05ZSFd1V2o3QmZUSXk3VisxY1dyMWJieGpjUkIwdEpRRnJOMndFeEY4RFN5?=
 =?utf-8?B?KzkyU0VMR28zU0tRUkNBblREWVF2QjdBMldFUWVYRzlpakl3TGl0NTVRVWZK?=
 =?utf-8?B?QWpZRy85aGdBSDNIK1FnbWJ5UVNKaU1CMi9Hd0llM1cwOWhIelphTkYwSTBx?=
 =?utf-8?B?emZyTDg0Y2svU2g4ZmFGTXZJQUo0R2NDYXV2eGlKUk1sRXJyK3cvSjZiYmk1?=
 =?utf-8?B?bXpuV2pVNE5kMTVWUWJCV1ZRSWVqV0tVSXZIK2NxMXpoWXB5TGczeHJHLzVT?=
 =?utf-8?B?QktBaUU0eXBFNGVMN284L1AwRThHRmJqVmlPeHBvWS9UQllGUGpsMENBcG5F?=
 =?utf-8?B?T2prRS9VbjJoaGlCbEliV1JuVWN1UGQxU0NYakIxSGpsd04yc2pzNUl4dHUx?=
 =?utf-8?B?Z0lRZDI0QmFwNEMvWHVhNU5MdlZ0aFVTeDZWY2ZiVTMxdzdHQTI0UFZwcUJo?=
 =?utf-8?B?UlZ0NC9KMkI0NUR3ZjBzelhxcnNuc1FSbDNUNDdWZ2cwM04rcVVNaHBVTzY0?=
 =?utf-8?B?Y2l2L1dOTEpVb3VkWXR6N2RJVmk5YlZqUVp6RDBpdU5zTGY0T1hIaXdTMXpZ?=
 =?utf-8?B?RUZXSTl1Sm9MdUVkNVM5TGE3QTM0bnFURXFrTmNBUzRjR2l0eGI3SENFYjF1?=
 =?utf-8?B?emRxaUhMbnBIL1NBQlhiS1dlRGx5M2xQaUZGSHlqemlCTDAyMkRBQzBtUnlx?=
 =?utf-8?B?c29MMW1lcGY0eERteS9uVllDMEdvL1ljMHh2QnBMZUVOalVuTU1GZzVXSlhW?=
 =?utf-8?B?bDJCdXVoZUFaVnNMczdhT1BIWVpQWnQxZTdOYVVBUWlyOHNVSEdDSVdXbFlR?=
 =?utf-8?B?cGZRK1V0d2hMOHpiakZsbjg2T0NGN3pjd0NqZXFyWWdjSDAwQUlsWmhSZ0tW?=
 =?utf-8?B?aXBjT3QySzI5R3dlcm1OUzdIVXBNd2RmR1NHSDlHSHZ4MlJzbUJ2a00vc01C?=
 =?utf-8?B?WEhRNWNhYVpBWWVQNmg1Wmc5d1J3NW1NTzJKbElmWmp4UFVYV3YyNFh5UlRo?=
 =?utf-8?B?VDhuVlBlU25hM2o5eW5MVm1DOGZ1TDZVNFBUNmNwY3RkRFlZa0NtZXZWZm9Y?=
 =?utf-8?B?dXE3Z2prZzNhUlJKbmtTclZ1bG8yRnZDblVsNzUxeEdhdWlYeXdkU0gzQXBl?=
 =?utf-8?Q?lv0N8xAtGiT/rxxM=3D?=
X-Exchange-RoutingPolicyChecked:
	lLj7KOA8Uo2L0e0paEJ7bCaS5C1R1Jr0R1CUYooEJxF2Y8RrUVhBhCi8WKBT7JPuPkACqZ2gOQVn4ui+RzLzbn/i1Z8Biq1nTTsZ3YqWJAyV3Ik/6Q72/buoDNUpSNwJ10dMzTqa5Lu99vAPJ/J8BuRnjaVyZlK2rLeCU2DQXeEgj1q368ySRr0VB7qC8jYE2kKDPNom28JK6pwty9jF1YmLVArrPIn3jOCZR1Z5Ot9eWMtK9zE2mzB8aXpvf4+xG8PNooUZJhW2IYF40XWMdndNmhHBIgZp+L8pgRNSkq+9615Ep9n4NnIxMSCHBU7eEWKe/UJhFYPG1nmdAJWNvA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8Ev+3IDHW58xNbfe6OZwDhw1CcYz+74fUZGhOy2TxKJW6N2VK51loziSrsTxhvDVVq7Bk3wUobQubmfky92besYC9KjzbqHE1bnreYaoOMfgyLZ5k5gLVK6uUCkwV0j0ah97oW0lt8ETZK40z1Rp3RZ4Btbl1cQmcLxmWPYpRkOn2ZHFEKV4ycAy6Q3R/y51TBaNj1bjNrUAU4pvAXf2tW00SZEqqkKmO/pAPYTfv3nNqCuNzttgzSvxnrT9T9aV7zhNWJuyEP06N2XYGbwd4nsdI226Dq/mZkbMe5AGm9/vLgaV/tUeRRompVk1rsyR9SVfi7D7PJl4H4BW2MXttfgTu/1ZBt92zfl2KQrPg8hcWiBE1T1twfT6TFwr6XGseOhV8njshw9WFQ+pfdYzeGYeXnYa8+yzT6vlzhsyq1raP/d/my81P3E1W8XD8L5LV0DvqE43jtJHg+karuXxd4LqSuy/qFoIuzA+l1LO1R/3vYSrmSyh1xij/mdnwZUdq/t2IbEoXyQ9Mv9PV0oj9G/v2y2zXb/bi6aSRKPOl3uVei27YSyToaxzenSYmRPEsAB77y/xT4uK0sT9WGINwvzlWRJkRuLyToRem+PUMsg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8808415d-9671-4f40-e4d5-08df24091dfd
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 00:22:48.8077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHaA6iPrG69dmHArNLFtnJNC/zOTP83WFN3WkYqoaZ97XYxA/XDkLurX3II+gYjdk8bAy65nOvRbiKsgoy5akhDIWn2J99pJBhsE80RGKSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997575
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610070001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMSBTYWx0ZWRfX9yx9n8Ffvtu9
 wEsOudOCZqk8IaqGUBm9ygibfyJ0p345Z0iNP/WVyY+tkKQtZNSH4hSkb5NBGI8qdZKypraHRKO
 JMypJFoxT5CQ1TnLWR8OZj6QXjKdicbkoktZ9IxgnA1eYBsfhGfH
X-Authority-Analysis: v=2.4 cv=d/dgWhjE c=1 sm=1 tr=0 ts=6ac590de cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=RpNjiQI2AAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=SBOjPkjV2dRXvfXsUQcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: IUDTGGFkkiMMwjcXZDvApV99iXY_Eudm
X-Proofpoint-GUID: IUDTGGFkkiMMwjcXZDvApV99iXY_Eudm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMSBTYWx0ZWRfXzWNk88p0QYNV
 JLd60ENKNDAnoSi/VX13ZcBUP1CU+SVCkdjtHbJPgYWHg6mZVAUMmltOvJFOlfRnxvB/W39eQTA
 Ksm1I/72MhIYOqXiaU372Zeuz4/ZUBeJrdA2vX0sogflKiqWAjJtGG3QP5imdqUqbC9TvdZ7YHL
 yyAFOGpWbxNbVifM75OQ29bahc871CqI1s7UL6RrzKuaZ+mmpCuqdXSRCslsRvYdX+M8HI6e4uV
 VqlKHyLWdvrF7aHAEugnZujrWdf0nHLQLDEUDSD6VPUJd/ueQrk8UrCvq2y7JL+BiMgiB8xQEIv
 dFxVHw5qQmsP4tu5RiUtvx/JwJocWsyZ/3murXiHw8YZyxxN04zeVCn3V/q2OSGKHvDSGByULyl
 8de2PTiwD7PecXL7Rf9v10q+6Kn0wzL8/H4QksQorGA8a3I5q3XRGPfzxvekCLKqHyocjlguXmz
 D0kNNkqEVmCPZdqyhJA==

On 9/27/26 4:13 AM, Yu Zhang wrote:
> target_do_delayed_work() takes dev->delayed_cmd_lock with a plain spin_lo=
ck(). It runs from system_percpu_wq, so interrupts stay enabled while the l=
ock is held. Every other acquisition of that lock uses spin_lock_irqsave():=
 target_handle_task_attr()
>=20
>=20
> target_do_delayed_work() takes dev->delayed_cmd_lock with a plain
> spin_lock(). It runs from system_percpu_wq, so interrupts stay enabled
> while the lock is held. Every other acquisition of that lock uses
> spin_lock_irqsave(): target_handle_task_attr() and
> transport_complete_ordered_sync() in target_core_transport.c, and
> target_non_ordered_release() in target_core_device.c.
>=20
> That was safe while every caller of transport_complete_task_attr() ran
> in process context: target_complete_ok_work() from
> target_completion_wq, transport_complete_qf() from dev->qf_work_queue,
> and transport_generic_request_failure() from the submit and execute
> paths.
>=20
> Since commit 06933066d88a ("scsi: target: Add support for completing
> commands from backend context") that is no longer true. With
> complete_type=3D1 on a fabric that sets direct_compl_supp,
> target_complete() runs target_complete_ok_work() inline in the
> backend's completion context, which target_complete_cmd_with_sense()
> documents as "May be called from interrupt context". For iblock that
> is the bio end_io.
>=20
> target_complete_ok_work() starts with transport_complete_task_attr(),
> which takes delayed_cmd_lock in two ways:
>=20
>  - Every ORDERED command is put on dev->delayed_cmd_list by
>    target_handle_task_attr() and dispatched from there by
>    target_do_delayed_work(), which marks it SCF_TASK_ORDERED_SYNC.
>    Its completion therefore goes through
>    transport_complete_ordered_sync().
>=20
>  - A SIMPLE command that completes while an ORDERED command is pending
>    drops the last reference to the killed dev->non_ordered, and
>    percpu_ref_put() then runs target_non_ordered_release() in the
>    completing context.
>=20
> Both take the lock and, if commands are waiting, call
> schedule_work(&dev->delayed_cmd_work), which queues on
> system_percpu_wq, i.e. on the CPU that took the completion. Further
> completions for the same queue are typically delivered there too, so
> one arriving while the work holds the lock spins on it forever.
>=20
> Reaching this needs complete_type=3D1, which is not the default
> (vhost-scsi, the only fabric with direct_compl_supp, defaults to
> TARGET_QUEUE_COMPL), a backend whose I/O completes from interrupt
> context, and ORDERED commands from the initiator. Linux virtio_scsi
> guests send only VIRTIO_SCSI_S_SIMPLE and never take the ordered path;
> any guest that uses the ORDERED task attribute, which vhost-scsi
> accepts, does.
>=20
> target_do_delayed_work() is a work item and always runs in process
> context, so spin_lock_irq() is sufficient.
>=20
> Found by inspection; no runtime report. A single ORDERED command goes
> through both acquisitions, so with CONFIG_PROVE_LOCKING the first one
> completed through direct completion should produce an inconsistent
> lock state report on delayed_cmd_lock (hardirq or softirq, depending on
> where the backend completes).
>=20
> Fixes: 06933066d88a ("scsi: target: Add support for completing commands f=
rom backend context")
> Signed-off-by: Yu Zhang <yuz08559@gmail.com>


Reviewed-by: Mike Christie <michael.christie@oracle.com>

