Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220BA285CB9;
	Thu, 27 Nov 2025 06:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764226413; cv=fail; b=SOi+ogVzxJtph6iPoLAiZX/F+CB0fYHraFdNvBTS9mdMlMSz54266lTRtdz8W99ZIUdh45MTw7ZrddAxfohG5DCaHjzNHa/Me8m93cfMrQ/yI4K1VslHH/e4IL+BbGCbupzK1h8HnA1dpzDJg8GbbfD+mDa6nrKFsuQxH1eYGvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764226413; c=relaxed/simple;
	bh=1Fb1CdiieR8PH9y4JC7y00OsB/2J2BLEx+evb7ZkR8U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QqAwHjyrK/ylo3c+hSKRF+CsTxrlGQi8bxccC2i9h8GNhgqmEmu30K5VLRnSPCKqqe/nCpE7WHiMPHGozK/zoaRDjVz7jHfmn1+MqK4Fvn3dxdAB+X6aYO9hfrXuOdZRxzyEdPuLG2LgZnakB6fnaFLHKMuW44LdhiBklmGP1wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h58PeWnS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XO8RAyR2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h58PeWnS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XO8RAyR2"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR1NxtN4135243;
	Thu, 27 Nov 2025 06:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Kjotqe0yGA/KNjvug+QSFgO9aP24FpjMJS2Ww4D7k9Q=; b=
	h58PeWnSx+N60VicWD3nJln87ineGs55y0sJstOzAm7Tz4yph9PWTieSVVYrt9qn
	ov3SNWaBGz6k8EpSPcmWorIT32MQKOPvbkx1hB2iKHW+OBNFznVflFRx4o61RoWe
	B/OttRSSaM0OsZnO0S2I1ykSmlek/TbuL93EjDmPfvnMFt9wFvhhGZ3E6JvAa7lH
	mKTRlFfIiDDIqqyDU2KJoMeHnkGCzh8v6JVOLV9RTM3uWD2K+ZtxXa2ZTJu/jOxq
	39Glo2iwbVits+yRUkzZBfSZxjEPYR89hIql+uMH0cOjaigEVuu/9UC6ZVZEUtQ/
	8E8BKjegNiMJiy5c/puJpg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7ycq7hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 06:48:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AR5n2ks032742;
	Thu, 27 Nov 2025 06:48:04 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012023.outbound.protection.outlook.com [52.101.48.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbx98f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 06:48:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jslKpdeo8B4xm9t0PpU6AMGnIWFtxh1lXX6oaUNJ7Sbicz1tb9md2a3YtoaZ9HnfI19qVxaseLAiCFy5rS1yzn49AeQ/B8A1esA3j2/okpcRg1Z9YiJsHcQPeECezSfYLEGuk/5hrRZN/nYgSA10m/lBuUXnqfxpgrolUd3rVvWqrTpVf5kPdWHI/bvfUl7QM4s44zYE8oMl87cMHtfU1ANdUb3b2dBokM8/Iyh7ChImYRbdUpvN0UYAEupMVnyrUS7SqqEInu21z6WDmNdWd1MeDiZinW3bV10S7bWAWTUetnXcZ+eecRTIKC9/kSBwdbVXDyJ9Q5fZJoZgr7tbIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kjotqe0yGA/KNjvug+QSFgO9aP24FpjMJS2Ww4D7k9Q=;
 b=WgP99RK57JME6ofpcaCrBnfC/n+HIZeDmtUFPm0twZcoo+6U0G39m+qhbE8QDRxFT4IGmkM7opYAupRv2ytqARrIrh8DZb+PAum34cRiVi//RxurfQgK8b9FEXA+AZpKrWHHl9d0gnLwwbM59CXhAk/fhe3hVgrjdkI2uve3ByKdjFtveiur0vhnXs/1M08qMXathBUHMhvksqprMQCrNdrATgEf/IvC+WOQwaAaNI3YrgWRsaaJaBN04ubghN2JGcZOFcVlcwA+jNzBx0623AaZ7h9SKoHmszH5s3US0OCBsEFzU/0ziSvJusn025C5TYY7vgaIULgPCKEnUs4rNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kjotqe0yGA/KNjvug+QSFgO9aP24FpjMJS2Ww4D7k9Q=;
 b=XO8RAyR2GM42qHljr4KdePVvqTurNBOJuevwpGW1Osy2GsXEsyBiWt16XhIRm2KVukMZeyhoG6Ir7R0BUBped1Wa1FN0DrUjwMEK8snW9rPY46vnTLZo6pvdFz4RVmPzfSHzc06wrZ/pq/i8GXGfiLI1aUPrgOAHe387wcCm0DU=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by PH5PR10MB997711.namprd10.prod.outlook.com (2603:10b6:510:39d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Thu, 27 Nov
 2025 06:48:01 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%6]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 06:47:54 +0000
Message-ID: <ef93ed19-9a94-4652-b220-cf88e5b57b69@oracle.com>
Date: Thu, 27 Nov 2025 06:47:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: libsas: Fix exp-attached device scan after
 probe failure scanned in again after probe failed"
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20251021073438.3441934-1-yangxingui@huawei.com>
 <88a3dd70-69a7-affd-8495-9333f95350d0@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <88a3dd70-69a7-affd-8495-9333f95350d0@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|PH5PR10MB997711:EE_
X-MS-Office365-Filtering-Correlation-Id: dc294c2d-ccb4-49ea-dbe6-08de2d80e38c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmdUWDNuS3ZmTXVlY0FFRXZkY1YxMng3K0RlQ0xLNTRUMnQzUTJCSVdyMXU2?=
 =?utf-8?B?Wm1OdTlRbzFrdVhqQkFsbEREcmNGTVZscy93NTQzdmtCOHZPanpKU0pBMGdx?=
 =?utf-8?B?VVFaUzVDWEtMa0xiNWFPZU1mcWlqWUVoVVZaVFlMSTRaY3lIam4wQ09HaG9w?=
 =?utf-8?B?WXhZd0tsM1RpOFJkdCs2NEQrSEpWMmFFb1BLU05nRmlVMWE2ZG4vN1ZmMFV2?=
 =?utf-8?B?RndoTlpkL1ZyMjhhcXFnODEwU2ZmNFFSaE5HRzRQME9hMEFlV2M2VnhBMHV1?=
 =?utf-8?B?WERBcFdzaTJsT0pldjZHQzhSWTN0QVNCRTRWd0JuVzZzVFlBTEhRZ1ltK0xJ?=
 =?utf-8?B?TlIvS1BXUFNNNEo1VWpFbFVHWEF5d1crSG41d2VKcEhuT05JcWN5N2didGhU?=
 =?utf-8?B?T2JyTXZJcmowMnpwMFRtampmajFNSkFhK25yelEvcC9mWXZTUEpYc1NxTlQ3?=
 =?utf-8?B?cXluU3FUMVo3c0Zybm5PKzVJdGZrYlUxYWVlRVZyQ2wvQUtsL3RSZEgzcWdx?=
 =?utf-8?B?YnllVmllZkZsN01id0pBNEhUOU9XL3JQa25vSWtMWktGTFg0NTQxeE9NTW1C?=
 =?utf-8?B?THkyQjAwM3FZblE4ZmV4NWF1UXNPRzRremFnTmFKQi9QWDVoWXVmZm05MEhp?=
 =?utf-8?B?RUFFa2xrZjRsalVVSHR5eitZSUdUbXRTN2NackNKZzRPUVJ1QVdkNXVJeHc3?=
 =?utf-8?B?UEYzTEliblhZWk9Wd1gwbGtGTVFpNmIvL2p1QWcyQVRFaVE4emZZV1U4Wi9n?=
 =?utf-8?B?THhHR2JiQitEcGtwbE40bVpqditiZ3A4L1Q4TEMvWTU4V0t1L2FjeWhQaWtp?=
 =?utf-8?B?ZkdaemN5emNxb3QyYWdHUlViSEh3NGJTUkNxYzBqeXdRUjMvSmh4b1pKbHEw?=
 =?utf-8?B?dG5kck1nUUpDUkdMTnFWRGw4VlNSV2d3cW5sVXAza0Y2YkxBUjhpVUlwZWZ4?=
 =?utf-8?B?MzlOV25MRURJYWlMRDNwelBhUVBxTFJxZXNXNks3bmFXcEorUnpIWWJYeTRr?=
 =?utf-8?B?a091WkNKb0pkV0JNTEl2RVBhQ0lNbUMwbUFmaXBFV3BTektSSXBXL1kvMU9M?=
 =?utf-8?B?emNVMnExR1VmbUREUW1TRXZaR0ovcFBTbzFKY2ZkZVk0dU9UU0RUZk1YODhD?=
 =?utf-8?B?K0tSeGhzZXpTOXBzdnZROVE5NHpWeUQ3UWVIeXo0Y3ZvV1l2cGY3QXliR3dS?=
 =?utf-8?B?dCs2VVhEckIwaHZUdTg1ZkZFclkvL2Y0ZmhoMjJjWjMyN3JqcjZLQlZWSEVs?=
 =?utf-8?B?T2F6ODBnOUZOek0wM3BmOUt1amdxR3BqTkoyUlA4aExIdDFoenRWUURpdFls?=
 =?utf-8?B?WW0vRG5TSHJ4R2VYYlU3Ympzc29pbENzZWJtWHY2YXU5VWpHMVl1RGR4ZTQv?=
 =?utf-8?B?eTNvRGlNSzN1VU11bVpIMXpmOXNXbktzNUJCQkxKWUxSSFVSZUdHNUZIMXZn?=
 =?utf-8?B?V0lRYStIakxpaCtXNjNJa3Z2UUlkUVA2dWVMRGIzWHVNU1k3dEpxMk5lMGpz?=
 =?utf-8?B?b3N6M0FEVEdMMEkzU1VrVFZHL0ZNa2tNV2t1cmpFc0V1dzlQVFkyaDlKc1k5?=
 =?utf-8?B?VEd1aGVvbDJ1dVFsZnJHM1lldDlVbUZHOEg3bVlYOXJLMjVlTEdLSVRmS2J5?=
 =?utf-8?B?VEg4eWl1VDJ2bThVYjU2a2xlVGczZUFtbng0cndCbEpCaGRlb0hxS1hORDkr?=
 =?utf-8?B?QThNa2ZvK1NnVlNjelYxd2RianBoUlVDMHo4YkZzU1N6bmd1OXZVVEVlQ1Zh?=
 =?utf-8?B?c2Fxdmo4QUpLQ2NmZFdta0Vac1RMWCtWYkpuTFlmR09rQlIrTy9mR3k2TlJV?=
 =?utf-8?B?TTkrRGV4THIzL1pabEcvN0NPZVF5aHMwelZ6QmRIQVJtc0JsU09GalQ0Zzdk?=
 =?utf-8?B?WkJIOHdFNGhWcnFqbTFicDZMK0JXOGdtemJhRDRHUkZnRjhpNzRYbjhpalpO?=
 =?utf-8?Q?NIVUfBKxTRYqYt80zpd1wJ5Sk9Lhyfto?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bSs0MWVFcTNnRnN6QllUZ2dDd2I2YkYrZXluRkRsSVpkWFhXVXJBM3hPRDVP?=
 =?utf-8?B?V285aUcwZGVDVXhRM1FON0g2R3pZSGtsVHRyK2JycEY2cE1ETnhlUWFZNWRD?=
 =?utf-8?B?TGtnU0lHTUFnRTl1S3JFb281NXlvUmZlSGJIbWNjbUNhOFAvTHlBVWpUdW1s?=
 =?utf-8?B?WTZBL3ZYTGpTQW5BR0tPbldTdFQ0UFZTb1Nzd2NxOGFRRnByclhOelFnNHFL?=
 =?utf-8?B?dTVvdG5nVkNQNzRLNk5hTFlROGRPRGZRanFoelcrV3JtckMvMGRaSzhheFVT?=
 =?utf-8?B?WGdoY1NZanExNVd2QStXdDVtL3lqZ25sZlc1KzFKRjZqd0ZCR1lkcXVvNUNx?=
 =?utf-8?B?K2tDTE5XS2trYS9GWlhkdTUyY2JSVXRvbFhrcDBFR1YrWDVLM3pPaDgzbkRG?=
 =?utf-8?B?YUlyNUplT25oUVJNdmRwRUpRVkZjdWZ4Zm9RMFhQd2N2Tk53RElmMXZsbXFz?=
 =?utf-8?B?L3NEY2luVU5oTzFMbCsxY2g2ZHFZVVUrTDREcUN0MzhmUkRVNitvaFFQUnRa?=
 =?utf-8?B?YVNZTSt6NUY1Q1VTaDV3eUR1MFplRlBQbHRvcFRqaXk0UndWNjd5eXFOUU5h?=
 =?utf-8?B?M2doMHJnZCtBR05DSk8vamRwaE5FMjAycHZPa2RySDM1d05uTmxmVmdESXA4?=
 =?utf-8?B?WmhFemd6OFVJR0c5Rkk1M05nNFJZVjVENVFuTnEyanN2cmlRaXRaaE5TbXVr?=
 =?utf-8?B?UFdsNCtIbXVBZFlBSXZpMkNXZ1dzV0hibjIxNVZFdzhhb2ZzU3hZREd3MmFh?=
 =?utf-8?B?d0thVnpJdVU3cFVmVGVheExjQjVIYXpjbUNjSjNVTnJ3dEVpb2dVaXF2WHJS?=
 =?utf-8?B?ZTBORlBtRXdFei85VW9lc1ltYkFVZTNyLzZBcDVLVmcyb0tlTjNNSVRYY28w?=
 =?utf-8?B?NkJBblM0eTVzWE9LU3JHaEFTMUJKd2pKaVBXNCtWM2VHMDVMeW02S3c3bDda?=
 =?utf-8?B?WStmM0U5UXZLMmI3WmtsM0tMSnZXRkNtd3M5VXM3Tkp3OEkvajZpVktIdWtJ?=
 =?utf-8?B?ZlM0bExsdHA2WjcyWU9iTUFOcWVBa1R4dzhzKzdldENUbks3aDFBTnV4dHBX?=
 =?utf-8?B?L2FMaElzMUF2VWFaT0F1L1BiRzdKeFRicGpiTjRmaGowdnc1NnlkcThXTEcy?=
 =?utf-8?B?WVB1ZUlLczB3MVZ4aTFOZFlqbFJjeHg5ckw5ZTB5bWhvekVtS1FrTWxURHJB?=
 =?utf-8?B?ZDFxRHdFdFpycXMwUmY0QjlmcDh0cjdNTEhDMm1ZRFFjaktNSkRNMzYwSm5k?=
 =?utf-8?B?NEh3cm1BbVJNMmE1Y1ZIYnM1QXV6cnVxWWNjcnhubFVuaWVETFQ5OVlobjNU?=
 =?utf-8?B?T1RocnhvdVEzdVVvOHhIRjE0OE1rbzNkMFVWbjhoQkxQak1Ock14czFnaUNV?=
 =?utf-8?B?MUJLWGYyS256YUd4TFYzem9BQ3p6cFlMeEwrYVA3TGxtZFNDK3NDYUZ2V1RC?=
 =?utf-8?B?bDhvMnpJeFVFRWZLRWlDZ2JrV2R4eUxiR1Buamx0TFVhQ1ZRR3ljeW1vNlAr?=
 =?utf-8?B?TnBIM2ZtZzhIRlh1QjFGUGxsMTRKcUczcWI4Vk1Ta3o4WDhsSGhBZU1seGJo?=
 =?utf-8?B?c3BNN3ZEOFBpYkFNZXB5Y3laQUt1ZENWZVVEVll3SHZod1NLM1F0VS9rTXVO?=
 =?utf-8?B?QUV5YzRoTFZ5Y2duVUVxNVRTSHNabE5XM3ZHdk9oN2MxcVhqaUZEZlk2Uml4?=
 =?utf-8?B?SGNlZWpJSG9VTWE1c3lrR3RMSE9tdTNGM05ITkRuR2xHOWIyWjRGY2ttOXFx?=
 =?utf-8?B?b05JaXZSSzZIN2JkSVZUSTJFaC8zM3ZkbmJZY3ZZUnNmQXFYcEc5MVZHTlJN?=
 =?utf-8?B?VHpNYWxhbTF4MHNwSmt2YkZ6djBOMnRYdTRSOWYwMldtamtGaGNEWFFCTnJo?=
 =?utf-8?B?d29LUlFjREhpajVsMGc3N2ViQVFkeGZpdkprd3lMclExTHBuT3phdk42alJm?=
 =?utf-8?B?NDlOMXYxbmpXVFNsM3EyNDh6RTZrR0JxcXZqQ0Z6ZWhtT1h2bkNVdmJmU0p1?=
 =?utf-8?B?dk9FbENLS0Z3VnhCQjA5QVV2YXV5bXpSUW9zWVNaYStJbnRCNnJDcGJjQ0J4?=
 =?utf-8?B?Y3p6R1NMSjlwcWg0WkliSW9jaGlhT2NzV3g5REJWRkozUjFRbkEwV2JBQlpB?=
 =?utf-8?B?eXRlR3dUVndnbUdVNnpoRjQvYjJib0V5Rnk2OGR5SVR1WjhkbG5WS0hwWHA2?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WlAPuF6fXd3PnHJSyUt+1/Sj6uFjDdj2hl0kxUcYe3SWgwfWf+vSl0ZQlsNd2vHnpb6AZNJsj5F9R2kwV1SIn+79GC0qLgiigpTBxLKCO9gEd7sRsQ4jEJVh7jkFFybTt68ybafl5KWnjRoycEHRSzQ2n27ouMfmm1iEJ3ECbKQE4BP2ylikgcov0Nz3sZgm9ePuEwUW0w+9qSekOO/i0iyDHsPN6TLpW+/kVKWOUo3v3LwsSeyPXutWH9Ce0OM3XnRcGIcNpPBRtP4/Nc9gJWyr25nVJnzQ3+FTMpdX5Qz9et6uPKr1z0w4bGj+wUM0P7HNaobknY6W7kw4dObOd19PEnsouuPd7a6yQkCmtZ8L+Zh2Xil1lOnu7TlCHtjnNeBCY68NfA0QWc3jPh3G9RlFYsJCaHd4/mz/QAZ9/glQrNDFThKyDtCqvruOrGb7Q1YG3iYgqQqUszQKfvT+tc229ojisVKKO7SyzPxpNw2dmpdwNQlRdISlCIym0P9Z4JSbFA1EKa/FNAuWY8aF3HHewPCRq9x1zaSQ7a4KJdXLKot25GQsvEN7JZgL45nlpExvtvCo0ooHw4h7f7bKXMeOOSuQAeVM6anBwmJVmfE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc294c2d-ccb4-49ea-dbe6-08de2d80e38c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 06:47:53.9755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7AIXOVinJegbugNkUh+BprGVN7uqpkBZkNJBdG0m5qad5R7S5KoBnAJ0UdZ6QQqi17ChTlAF6kIvHH/PzKCXdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511270049
X-Proofpoint-GUID: ZMwDxxnS51z6znuQCI5sY8q5ERsD8sik
X-Proofpoint-ORIG-GUID: ZMwDxxnS51z6znuQCI5sY8q5ERsD8sik
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=6927f424 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=lwCOCxD_TUOiL1mRCwUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA0OSBTYWx0ZWRfX4MTN3myHkH8H
 xf2mKxJwiFiHncqFpgIUm3qV/POiRJvdErLpbSa2lsisHsGXlhy50iZ4crt5VrYmgfCbdHoBCLt
 Z7EKfK+3x0Es1KDu19AOVU4sOdGiH0ngzz1i/Lr3tvRxcfy/TXjbtinBCw5jrJxpDIfuw1cNqgR
 xlOPXLYmKd1mDJzrZ32u//wXe6j0ABI9PKq19wCL2HYLrXrpe23lFkwGjHUFUdB50bdIMKCYKTK
 U5wLuLCzhFuTOaLPwmhRZ4jAz1aKPQ/w+7AAAhuFhT6Ih+2/f1NMoyBr8AHDAbMzqTXsL0CbYN7
 U7+bPPI+eyl9unyjoJc63fsB7fdl++T4crSHb1lMfv7XYHP6GGkLV8JZNruJM9pMe5nJCEv8+py
 6roSocXp0L+j+DsCayvd/rDT1N4Lrw==

On 27/11/2025 00:59, yangxingui wrote:
> Kindly ping for upstream.
> 
> On 2025/10/21 15:34, Xingui Yang wrote:

Your reasons for revert is light on details.

>> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
>>
>> As the disk may fall into an abnormal loop of probe when it fails to 
>> probe
>> due to physical reasons and cannot be repaired.

So for a faulty disk we get into a indefinite loop, right?

What about case where this was helping before?

>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_internal.h | 14 --------------
>>   1 file changed, 14 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/ 
>> sas_internal.h
>> index 03d6ec1eb970..85948963fb97 100644
>> --- a/drivers/scsi/libsas/sas_internal.h
>> +++ b/drivers/scsi/libsas/sas_internal.h
>> @@ -145,20 +145,6 @@ static inline void sas_fail_probe(struct 
>> domain_device *dev, const char *func, i
>>           func, dev->parent ? "exp-attached" :
>>           "direct-attached",
>>           SAS_ADDR(dev->sas_addr), err);
>> -
>> -    /*
>> -     * If the device probe failed, the expander phy attached address
>> -     * needs to be reset so that the phy will not be treated as flutter
>> -     * in the next revalidation
>> -     */
>> -    if (dev->parent && !dev_is_expander(dev->dev_type)) {
>> -        struct sas_phy *phy = dev->phy;
>> -        struct domain_device *parent = dev->parent;
>> -        struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
>> -
>> -        memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
>> -    }
>> -
>>       sas_unregister_dev(dev->port, dev);
>>   }
>>
> 

