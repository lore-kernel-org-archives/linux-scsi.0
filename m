Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCD1150993;
	Tue,  2 Jul 2024 09:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719913466; cv=fail; b=vGGEYaReOXH02JQLoemBmt6vnlhFWSn6PsjKIV4ZWqudgPvi94zvFLYFILgXda8WV3CHWPidTj/b9OoSQ0SLGgVhYB0z2EpIkh3+l8UkQ8DlGiB5XBgUiuJVgtEGbtNF8f9pMhRSVdTLITVO42wc4vO0DruhlZzA6xRDHdgBiwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719913466; c=relaxed/simple;
	bh=+2LF0wcrj7sxAJm7HIs1vXxYAAv4SZ0ZEf3LZ+gkZ9g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vGM3P2l9ei66PnstvTb+7nxV99nVA1u5USIGd+mEZ0apix0CahOExMcDXUYlLB6JHes4B4n0ZzLtc9yD6tSdkjG0hUNxX63/0GnJRzXakONf47uj3E5mD5an9hF6mfHRpTs1KUX2Ky9iv2aZuZf2if9dbKhfYTvoErZlMWnyDxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fl/hW+o1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hrCSCf+h; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fl/hW+o1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hrCSCf+h"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4625MXZ6019890;
	Tue, 2 Jul 2024 09:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=G7+rHqURvFW/6nYY0fX3MNwHJ3jkDWdLfaMj/Pj3nC8=; b=
	fl/hW+o1daHtl7t0+IMPS0I/WCFGUzRwLUYvFPnc+LePB3SVRvbAiYFO/L7vyeW6
	0ny/Kz5qWtmO8uXKKJhzu4j8/uC4BOu3oXL79vg6nVQdO3UKbijV9OqRRaU237s6
	nobombsOdbXi50lQ67Fu5G68s555hwo/l0ZC5avi4S6SS2LnEVVkLIf5P7M4ZTSl
	Y4b1c4nFvQNWqdCXGKncC4y9rKwinUouCUtqzQXaktOX31kUR0l08BxRlPAca29h
	rzpXskm4JO1MSWrhLES3pxxGznA/mx0xAj1u7TND6Nyf5p/agHErP1qLRgI99D+j
	4UoyoT6KNIoVC85qZHAmbw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4029vsncs1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jul 2024 09:44:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4627efc0026126;
	Tue, 2 Jul 2024 09:44:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qdmmc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jul 2024 09:44:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ex6dshf3PYtqy4mG1V18UNsR0AGJYw8qpxiJpMwZ5FQRoththdHhpE7rsBB0X/idfi7J5lhijDCbdMocN0btmiG7Jx4jwsqVu+Ou2OKp4eeg4/OkpAKgCHHTzjfVkYaEYv8pMExtgPybE8ZtW2ucdwUEyNzSgSt5ndgtHnF75OgSXzimn6rMeXS16nrIoE75Gg0SkmqduaQsBZHFo6T23nHGQx+z4clinCLa1JkCD+nFmV4JpREQxt094JmNNZWPbUyo/OYgBrOzoFh+XAYoIa9wrjGrxjOw2VrS/0z3SoCF6cL0CPWdUUv7oM4ksBnlTk60blyO76TSWZqIpRZWgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7+rHqURvFW/6nYY0fX3MNwHJ3jkDWdLfaMj/Pj3nC8=;
 b=gCc9B2YSO+iPT6Vpxy4gZ9KQ0rJPphCJzipsMmMp8ZSxBZKu6Jwp439VJkoBdsnD9YddqI14r6wuvNGlr1HpRZAD/Pa28iuMNADogOx1fvW8sE7P16FqfBlxkd9QM+LxCxq9ABf25ax0FA87AzKzDLqupBsG+OwDODCJI3yDJa4o7cAnjqo5PYcJNPrmDVIzOoQ3ymEfkteTcxdQVNU7GUePme2zNSHJEnbLTHmPxFrNJXsbBgPDalDCI0ioYkWfHE6ehII4DiRseb5FeeOyiLHQ4VQ2MemfzdcBXGU4DcPnwVn/+/bsLU9qp43SOK18ogxLYUMPicsOuQvGQqB5uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7+rHqURvFW/6nYY0fX3MNwHJ3jkDWdLfaMj/Pj3nC8=;
 b=hrCSCf+hzaGFmURJYm9h8COh/QCQJ/FpUpKvS5kmVJq/tl6RFq/rTpTdeydE5z521v1uKZp2d7gOKlu/P2dUUX6rKggGTn5ogj2WoaimuhVXA3u8g6uEopiTA5qYXu3X+tW4NbW8rh6bLsLI0sulSNolHGwweQNf4qCI2YlXP84=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4959.namprd10.prod.outlook.com (2603:10b6:5:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Tue, 2 Jul
 2024 09:44:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 09:44:15 +0000
Message-ID: <486b02ed-48e1-4245-8cb5-b66045cc9c8c@oracle.com>
Date: Tue, 2 Jul 2024 10:44:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Fix unsigned expression compared with zero
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        michael.christie@oracle.com
References: <20240701090603.127783-1-jiapeng.chong@linux.alibaba.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240701090603.127783-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0282.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4959:EE_
X-MS-Office365-Filtering-Correlation-Id: 7abb10d5-9ef1-462c-1d45-08dc9a7b8942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?MXE3aE13SzNqRUxjeXMvTE92ektIRGVPMmZIcTNkbmMxQ0NwN0N5dVBDMUJu?=
 =?utf-8?B?QnJkcHlwZXVCajdNN25kK0tIMllaT0UzRHhtU2YyQWtzQk1wUDl0U0ZITVl0?=
 =?utf-8?B?SHJUL2ptNnVHS2N6QkdEbGFKalVKYzdqN3RIYzMxOHlaQy9DVzY1YzFxUHJB?=
 =?utf-8?B?cHRoN0RPdCt1bG5XcTZSQWxZWC9samFJVDB3NUdEeS9BY3FJZkwwZTRJWTlv?=
 =?utf-8?B?V3ErS1M1Z1IxTU5kckJ0b0J2UkRxY2F0Yk1DSFR1NWl3aDNiQVlCQWNEc1JF?=
 =?utf-8?B?Ni9IZ1NwTEcxbXQ4Rm9EVm9CcXF5QXFsdWVRSXREV0VBdzNWdHRianlScHhW?=
 =?utf-8?B?alZQajZVTkFNSlJzSUI0aUFzNUd4SmZGektHRnBFd3ZYbG9UN29reFJMV3pa?=
 =?utf-8?B?YXFFTkNXM1FpMEJ1SVgveXJ2YmxHeHduTm5rcUxtZHJsYVJ3a2RTdkNhWEJU?=
 =?utf-8?B?eVB2MHBURHlYQmxINW1TbE1LZTV1YlRLMDJHV0dUdC85RDRqNjVwSE04UDQz?=
 =?utf-8?B?cGt3MFBNN0dtQVdlR05YZ2FsR2NtWE03Tzh6ZFRidmx0aEFXQUowRUZmaDdl?=
 =?utf-8?B?RXVjVmVEOE5yMmtjRFcxaVpOM3ZTUXl4eEdBSzZQYVUwMzZSUms2eXJDdXdm?=
 =?utf-8?B?M0RxZXBrRS9FTzVnaVVjN0t5b08yZ25XWDJreFBXSWo3VFNNaDNxYU55ck1u?=
 =?utf-8?B?dnZwUlcwTGNRdHlXc04xRnltc1Z6M3I0YldCcmlFSDJ5RDBsSHF4Q1h3WEZp?=
 =?utf-8?B?dFBuazI2VHFkMzdNVG9qQzh6RW1NRk1sRGY1R05sbTJBVmpwM05sbHhmRDI4?=
 =?utf-8?B?L0RtZ3JYeHJldE1rdjRublVPNUYzWVR2Y2pTa0tucTBIMFBVV2lObEhmeHBT?=
 =?utf-8?B?S09wU1h3UmZ2anBWSURpUzl4RmZ4ckRMVjRzMjJ6VCtZK2p6YlR6MlZTMHhJ?=
 =?utf-8?B?VHR0OU5lZWRzZFJWV2pqZEdwYXpKbHF0N2ZsL0pCQTdKME5zeitjeFAyOHRv?=
 =?utf-8?B?dExxNkRzcm81Qk96Q04rNjZvTkxuc1ArRWFrRkxPK2graHB5a3NaSGdPYnFZ?=
 =?utf-8?B?a09qS2FKRFB3NHhnMllvQkkrNDBBai9yRFdTTmgvN3o2dFdRZi9aMmNPT0dP?=
 =?utf-8?B?Q0t3M1djY01nZTVKUkdBSWpTRnhQMVFDMVBESWZrU0J4UDQ5VEJ0MkJzNURC?=
 =?utf-8?B?eWRhT2trWW4xUXBZazdlK3R3OHEweTI4OXE5SXRqYWc3SWJPVk5kcWZyM212?=
 =?utf-8?B?THV5dkMxOTZhSzNzN0hWdnA2bzh3NTU0d1ZuNkNFcTFLcWFZUVhDbGVnM3ly?=
 =?utf-8?B?VUV3RWtiUU5ndW01VW00d1ZqMVhLYlRpL0RUTW5zY1NaUTVYcVlZOVNQcGZH?=
 =?utf-8?B?MnlqU2d5Qy9oUWY4RHY1dmlVK0hXNEE4QWZuMG5rS1o5aGloT2tIWXUxdElt?=
 =?utf-8?B?b3l0UkJSalh5ZUZZKzVQWndUTUNPNXBreHNUNldjcGdhNG9kSW5tUU9QWHAr?=
 =?utf-8?B?UmZRWnFJUC9JSHB4OG1xZzd0Ni9TMjViOWVvd29JVWJ4OTVTRCsxVkd1aURS?=
 =?utf-8?B?aUE0ek51Vk5XMTczT3pSa203VFU4QmNKUUtPcEVlUkV4Vkl1cXZwdGxSNDRu?=
 =?utf-8?B?NXljaDRodjFwVW9PRVpnemxESVlNYlZPb1lyWklVV3lmbHpja3lLREZ2ckFE?=
 =?utf-8?B?Mm1sc2QrYTFLN3FpRWY2YzFFVWtmYWdiNkk3dFNlU0c1Ty82TG4yM3hRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RzlnSFB0VDNwRkExNS9BOCt0YkZaY3JNOFpJRklSRnhvaTdJTlRoMGxZSVJV?=
 =?utf-8?B?OWE2SU5xTU9HWUczV2hwZ3B1V3R2dlNkVHIzMGxhdHhvcmNLUXJsczRjTktj?=
 =?utf-8?B?QXQ5eDNHSyttNEZZOWdLWEZpN3RqTkt5cnZrZVlUNWJPcG9WUXhhU0t5V0FS?=
 =?utf-8?B?cStqTXJIWDJnWlluaGtxSUcrWEVDSnF4Q0hvc1Z0YmEyOHRYTkphaTdTZUdG?=
 =?utf-8?B?OWhadTdXY3hUV2c0Q3BVcTI0M0pPakJ3M01UbXRNQnpJK0N6WFFsWTZ2R1Js?=
 =?utf-8?B?OG5FeU5oMW1EQmlkWHdWbEtaM2FzbmViL2prRFFFYlhESmFmL0VVQnFvYnNG?=
 =?utf-8?B?QU5INXhscDZoU3VDSXQ5THd3N1NpUm4zWTNFdWdXVmh0ZGNhZlBjc1JxeGlS?=
 =?utf-8?B?eVlJYTBBWURSYUUyM05qb1B5VXdhZ2NwKzRlMHFMWE9LUmxNd1IxS0twVFc4?=
 =?utf-8?B?YkhTSHc0L0dKdUlqd0lJRDBLdS8vWVB4Rm90bzEza2tORmh6OUlXRTZvTEY4?=
 =?utf-8?B?OG1KMWloT01VYW1XRitjenJkNzhLVkQ3eXBhd091bjkvcHRjSHJsU3hPZklO?=
 =?utf-8?B?UXZLc09VKzdwNlI1NHNQQzlmOTZ6Wk12WXVKbk55NWV6ejk1azN0d0o3dUFj?=
 =?utf-8?B?SU92dHM1V1lhc3crNkRJZHhydGx4VGo2RjlKT2VTMWdwamxrWElidEVmQnYv?=
 =?utf-8?B?U0c4N1N6R1lTVjlWVS9GNUVkR0FsdmhLWFh4Ymh1RERJeDQ2OGVseXVyUkFq?=
 =?utf-8?B?ajZ3YzFvazVuZ3NraHY2RnoyUXRaYWg1V3lxQXRMbGRxUUlRUDlvT3FvTDMx?=
 =?utf-8?B?cnBQMnFHWGRWTmJ2Nm53L2xBYjZXQndxVTRTVzN1RDEzMlZZa0ZjTitMeVFw?=
 =?utf-8?B?YlFwR09XYXNEcUlpajNUdWoycDBzL0ZUdWVzb2xuaG1GcVlZVDBuM2ZQNTBE?=
 =?utf-8?B?TmNYOG1nVW44VzFoSmcxRkFoTXFYcHFSMFM1U2o2YzErcXVTLzcvY3pjdDBR?=
 =?utf-8?B?eEt1S3RMbEtDRzZlZmdYQUtOR2FxODlHcVRPUmpYMlYyZFRzV1lGa2dWRFph?=
 =?utf-8?B?bW1CSkVVYVA3Qys5Q09na3VQOFM5R05xZWtYTy91NHFBMnJOUzFBZG9lNjMy?=
 =?utf-8?B?c1RwSHhZWWJ1dTFncmE3WlR3cnVMZjFlWDJqMGJvc0dUM1NHYUlubG1OaXJP?=
 =?utf-8?B?TU43c1o4NGlyWDNYM3ErZVlmbmRIQW5uY2lxbE1HTklyQk5vU2FqcVNocFFG?=
 =?utf-8?B?K0hCRUNxRGFoRGd6S3NXbGtWaFp1VG1lcjZRYmpsWVBtVFJ1WXNlQ3JzRTE5?=
 =?utf-8?B?S3F6U3JKejYvVVVZWFA5aDQ2Mk1FYWhnK2x1azhFb3lQSlpEWXlxL1JYZW1P?=
 =?utf-8?B?S3FadGs4UXFXVGFZRjFJQS9ObG9lK2wwTm1Vc3NrTS9pRTZjZlA1aDdmUDl0?=
 =?utf-8?B?eTc0UW9KSThjNS9vQmhSdzZqTHE5SWpFSVNpbVJyLzk2TGRxSEhwRmNRb1l5?=
 =?utf-8?B?bitPeUdWNlVabnhhTXJ5QzRwMEUra25kc1BvKzZZYVZwRVJ0Y0s1NTVCTkJF?=
 =?utf-8?B?SkFGQmFoNnZYN3dVajV0eURmbDVRaXdEVjJRaTczRGtnZ3ZTYjU3L3lNQUZV?=
 =?utf-8?B?Z1piem1kckthZGVEUzF2NnNFdEMrazdXSTdlVkd4a2VjQ0x3VGNVZTQ2ZDhv?=
 =?utf-8?B?L0tDM1RWUW8vbG1QenVzdmJDaUxocXNxL2cwYVphYmd6Sk8vUDBOYVN1M3hG?=
 =?utf-8?B?a1h6ak53ZVJuRDA0cUp1OHd3bWE3QUkwUlNkY0hiNkVjcXJQeVhWd0pGbi9G?=
 =?utf-8?B?OXRkWUEvYmFmVzFrVnV3MXRHc2dXb0h6aHZiUWtqOStwM2hmTy84VzRhUmZ6?=
 =?utf-8?B?cWI5andzckV5cUE5c3MzR3JtRGJsN1N2aWZvLzhFckFXU1laZjdNK0V6dzdn?=
 =?utf-8?B?VmtkWHZmUVZkVDNMd1ViNzVXelhvQTFVRTkxTUdKYXBYQXNqOUdxb2VhUyti?=
 =?utf-8?B?VndQQ2k1K25YMWxRN1lFSksvYXhlb3VWMVlVZEl2VzJqVjhEYmMzYllqWFkz?=
 =?utf-8?B?N3NVWEgxVlFoVjNJbitxSUVTVzhqNkY4YWpISUQ3cUYwTUdZRnFlNU93VWpo?=
 =?utf-8?Q?zjIRBErEAe6P0pbEqLZudI3AH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ta9q/o+foTstek1sNB4cRYgjrRUj8Y8aNnDVVFBYO6QKgFp4iodH+ZyF8ZucgnhqFCat5AqVCfZX93WvmhRIRpIX7nwht+IfvUCU9vMCSqJ7s/j70RH6qkjwWrfYCQkSOOlPoI4D37uASHr4eJ4ET+PD8ZFan9ohJabEdQ3xKpJL4hyl/z1dqDok8FoXp8/oXYDgiNGpZJRcrBWEtJ3bCqXT+dzvkdP8iYyLZCARe5TEOlAKPlC63gQI0907YpttLIKjda1gr3orXH9V0GQU6gNQvq5z6rIB6+S2tKo9BaQfqmerqHayx/z/40eE1lVyp9Xgu3b3VdyBxuR1DPZiNzlWjtj/NOynPanzEoYJLmJrgbX5jDOvGG41zMf723FydgEZ+zlEEHGYKERQZfjZnh8xDcLbOw7bj2OglVIvXGBTOThLbap9Wd1Kc7rLEfpcFgYZgjBjZpuDhC3fkYCtu86ad8Y+J2GTJuBKutPTQg6q0vXL4f0IMQsWSTGAuNAih8AXiUaiJbU/320Ntq0lnx+M6RvAmMZzFf9p68WlOQC1T5sqjp1ju7DkSsmKBbVbBHAkhkWU2hV5eS6ZcNyUFHJIyFa3im1u/ql295dibL4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7abb10d5-9ef1-462c-1d45-08dc9a7b8942
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2024 09:44:15.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iiAa/rLIcbQ4D2CfOx+HfqKR7DBUhJ5X5qZha+lqQwtEUAt8jCncRRcm+0a5DJ+S/lPcjCpjsHfOhWyAHSC1xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-02_06,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407020073
X-Proofpoint-GUID: 0z4spnCnKE3jKeSFKWXbb5EqChPg6FBE
X-Proofpoint-ORIG-GUID: 0z4spnCnKE3jKeSFKWXbb5EqChPg6FBE

This title should really be more precise, like "Fix unsigned expression 
compared with zero in sd_spinup_disk()"

On 01/07/2024 10:06, Jiapeng Chong wrote:

+ Mike

> The return value from the call to scsi_execute_cmd() is int. However, the
> return value is being assigned to an unsigned int variable 'the_result',
> so making 'the_result' an int.

an "so making 'the_result' effectively an unsigned int", right?

> 
> ./drivers/scsi/sd.c:2333:6-16: WARNING: Unsigned expression compared with zero: the_result > 0.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://urldefense.com/v3/__https://bugzilla.openanolis.cn/show_bug.cgi?id=9463__;!!ACWV5N9M2RV99hQ!MVk0tuPkuuYZTeD-oVg7RYLVba7HwHVUjWCL2CLavSPrJmuO4MSCUNQ0vqjbCSIKBN8eonwTlU4FxKD3vmHQQhN2YUhbLcnJ$
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Looks ok, but Mike can hopefully double-check:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/sd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 979795dad62b..ade8c6cca295 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2396,7 +2396,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>   	static const u8 cmd[10] = { TEST_UNIT_READY };
>   	unsigned long spintime_expire = 0;
>   	int spintime, sense_valid = 0;
> -	unsigned int the_result;
> +	int the_result;
>   	struct scsi_sense_hdr sshdr;
>   	struct scsi_failure failure_defs[] = {
>   		/* Do not retry Medium Not Present */

