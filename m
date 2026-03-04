Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B70390211;
	Wed,  4 Mar 2026 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772622739; cv=fail; b=eCf4crX10ACy0Di37EHue2lhyt7ydvNYdB2bN9/igHvCj9vs1IoiEpF5aGeawsG1I+JMrEj0ZHdaIfgIGqc94dJ6dQk1IpneL6QCpFPf4OENONFqvKPZSk4OUR92AlO9UXiEQObNAPZjJH0EUcUIsKbayeXid31SP7Eksnh3QMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772622739; c=relaxed/simple;
	bh=8y4DE4JUJ5t9xORh7ru1aIDgd5MfOXi3OV5zUx/jN4w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Unqu1gV3WRrRXeo0YebksII78MXO9F+DIwu7PgPKaIPd1mBxgqs7BiDkYKNP+llH6o40HiKF1qRAj7ddWA5fOYwzjjv+GPfm5zpu+Py4zX9HlyZAJ6JuFnXSaAPrhsRXtEvbFmAUu6O8xYoGmhaCmxqrnWHZgmDrnY5dMOmcWPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oib2ekbA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cfo9zwtj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oib2ekbA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cfo9zwtj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624AqOU11555565;
	Wed, 4 Mar 2026 11:11:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ef4XkWIBQGR5Vgg/Uam6wIOhYjMA/pNzWGaTSP2f4uo=; b=
	oib2ekbAdPLgUzXsLFqhCO7PigbFk6S+rV9x8yydB6Y8gI5vN+sUghBgTV/OaI91
	3sxgR5+XW0E9OdzbA3OULpD+1puNIRm1QPm2bUCSJ+qVenmHhPCzaB4tYdS7mGrU
	W5OlJu92U/o9IDSA+D+MvT1ny2AieNO14el26d4Ydx+hViZ6Jhs5giUUKdy/MBjX
	T7nAgVmrWE4yICMHItRICU8iqtkKkzhdfk8dZCGCDTr7/kvEVKDMdERPMsiZxZ+n
	CuYrX8AoKodlaGlR3phArF4VeqTCwUhzubK3yjfNlsYRFKTc62/Vm1CRKAHzhEs0
	6haWHuf9XIzllhZk+TaJEQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpkc8r147-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 11:11:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 624APCPt036951;
	Wed, 4 Mar 2026 11:11:51 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbddxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 11:11:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KojD+f4hCsSUuctegwc5ijshF2KKt1/wPIZbtbkpMXXD0+SaOnhyrr/jQVmKKrojdveYgM0hW90rweOgAuVlZWJwSdUIduKveUD76So1Q+hEgJVzt1eYu8LifC9KdhzmJjBHW0nmYiQYN5W6dS1T0k/CnX3UX12v/nOkHir1t/lsTVlaLOC7rDRJx2xn54l7YVobFflLmmuC0pEM66IwYKZKMGIvxRVkFYUVwjL+rDObBjCmELIM3RaAWMmE5jVvGY5/Lz32VNr94UFT5FXRGujXAS+5F8ZL92+acCyuHLzXntUP2HaYh5dfCx1yO+WFYFbYCeUPs5iRJEtDAmZV2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ef4XkWIBQGR5Vgg/Uam6wIOhYjMA/pNzWGaTSP2f4uo=;
 b=HNF70Lbm6jc2jetosLIKWCXF8QOpQGREtNrFwoHc7Mjh3BB0YqWJ7W3uMV4kGT+4fuDFXGIcgATLP/V0Q+jFp6mULNrr+mYHELUAcL3mu40cKqmC+3IXziyw7ker65joN2BHUN/rnHs8sGXRScdSXJ702xnNSulIP8jEoGbpIAiDhDtozAdHq4cbmRKOIwsM4pJjW+pg4qGY5OGNLEHmhTGE2U0Lv+b7pqq2vyBApdVzxt2Qrrpkoj/45VI+EbR5qC2zqvJXFoy0eLJacUfKEPhsyqopFKubgk8Z04HKGx5AjUAMYqpUWuxbsP8/hgPL3Xm7rouLWHYLURo/2CmKeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ef4XkWIBQGR5Vgg/Uam6wIOhYjMA/pNzWGaTSP2f4uo=;
 b=Cfo9zwtjsrJHNBA4XEDuJlzqYyBCL/DAMRBqkrU+grmrJLd1RO/n89dnpTCNJJVTKzJWItGaZ2FCHpbZkbSDm83QS9dDoqs14lqAlNmVsponzHtD2Q9XYm8Jpy8XVjHf+LxDWB6wU6XkZKAXheJkxXodxko8J9LKHf5TxaIR1dM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ0PR10MB5615.namprd10.prod.outlook.com
 (2603:10b6:a03:3d8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 11:11:48 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 4 Mar 2026
 11:11:48 +0000
Message-ID: <2cb6a32b-d709-4b32-9605-e07a5c4acc54@oracle.com>
Date: Wed, 4 Mar 2026 11:11:44 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/24] scsi-multipath: failover handling
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-10-john.g.garry@oracle.com>
 <aafHPC3yncBxuBVx@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aafHPC3yncBxuBVx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2P251CA0015.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ0PR10MB5615:EE_
X-MS-Office365-Filtering-Correlation-Id: e0b66bcb-5dbf-48e9-ac6f-08de79ded40d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	1zIufNgIsvjlxbB+pMSLRdQgsm7HQso7Mkl/qYTcSkePUyDFzi1F+E77iiRP0O4TUoZECZxRkyYX0FJrC4yHCAHln5/yeX4lkEweOaAcYQe8fg6biC6eV/hUestZuxHOfQfN2PkBaV5XT5TfIOgmJRx6rjbR2STPZcawHBxBz0JrcHAae9tyiZ2iToF3pYIU+8h/leR7HHW+7K76ncJB4jwaXU8KdevESTzj2dD8d50rnL5sU4ruNjQPW0Pu3ENror136oAQMUdVkL2Yi4HVupQQzCsJggoKxr2CbPLGlfaRNuv5gb9Lei20JHlGGLkl2jWq575G9+f0f6yNOhgr7RNc6OW9IEagrrmoRA4d9pJt3QaOTka8KMS5owEvyA5QAzUVcY6MtI6nIgJGW35mKh1qR80s53fN8CVHf60itxIMv6Vqcu3tzT2WOhEatH23SIRjAogmYv3d2DdtpAEW6AoCV0uJe1YQu4ogw9IJmIDagfenRhNTI2H2PjrdXwBLl2VWj+YLBB39gi+1rdVwYhoakB5cgriRh42brbFP7zFFgwv//hjObHrl9O9aDi8ND7qJbCdLXpHbo1VPZ3w2Vnt4B+J83S5vp9fOnz0PykwrikhmK62X2JnsiwDxLRhRLf8VLh2WOvS+o36zkO5cuP165b5jFfCY3UIFk4IsIHfVOZKcaKWwoU5cv/bDgZ5EluSaqV8z/sI3r7kpNS8slzhXCNcxfpnyZqfbu3nAOCk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXF6VkVVZDd5d0QzWU9sYlV5WTN0ZmZrR0JxU1pDaGxyeTBsckwxVUtWRFUv?=
 =?utf-8?B?NjNiWEY5aklGbDY1TVlXYVVXVUM0eFh0K3AyZlZTeng3eXIydnRTUXMvOHky?=
 =?utf-8?B?NFJaUFIwV0t2S3lpSzVPWDY1cm95T2RmTDVyS01PeUlrRERGRmxoQ2Z1TXp6?=
 =?utf-8?B?VFY5bjZUcnpLRm1BdWptMFlOWW9UL3hjblpBVHFiUzVRdWVPclZvamIrdjZD?=
 =?utf-8?B?K2tWYUtFM2wvMko1S2VlNFZlQlVWTzZicWhhVTFBNTlOLzZSMkxvb2hTc3Jp?=
 =?utf-8?B?ZTNVbVZQVHdvL055UFk2bHJHUWFkMmo3S1piSTJta002MGFiQTA1aytpdkp3?=
 =?utf-8?B?VDY5b2pGSlZaOE94SmVoQk93SEpjUXpUWjVCR3FZNFNEek91NUN3WUsvTEsr?=
 =?utf-8?B?T2NDOFRGNCsrWGJsWHREdzdTNzk3QjZxUTh2VE1aYlpMd1duS0NYTGtITm44?=
 =?utf-8?B?a3dYWDhLR2tkdDRRUnhnK0RxaUtYd3JCcG9RSFBKK2xmb0JKTjROT3hwZUxF?=
 =?utf-8?B?ZnRabzAwUDVYNDF2b05sc0dmbjVLWWhkekJwZmFUSk5WblFoM09CUCtYa3dO?=
 =?utf-8?B?cXAvTGhnVTdMalVjeEhaT09WVmVmOU5yRG9DOFo0VCtmbWNOREJWMTJORWlT?=
 =?utf-8?B?L0U0MVlpaVJ0dEpicTBFQmJwbFh2WmdhbElQWFVUYkJWK3pLdmJxRDF3d1pG?=
 =?utf-8?B?SzRjYk5oMnNpY1I1ek12TENSN2hmdnY5alJzb0pSbGZPNTBtR1h5LzlKVSs5?=
 =?utf-8?B?c24yS2U2YmRqSWhsT0g0TWhoMmVIVU1sUVFhRWdDT0gwLzYrMVovL0h5T0s5?=
 =?utf-8?B?bWNKTDN3SmZ0Vkx1UE9zMUQ4R3hJK0Y4diszYnlzME5BK050clVjK1N6dGpo?=
 =?utf-8?B?NUxCREFQTU9lWEZTN21IaSs3UjJXS0N0RHpKb25Nd0lpUmV1L3hYa1ZmL2dW?=
 =?utf-8?B?b3dVOGhjM3V3Rjc4RWEyZm8zMHFyYjlnYWVHZDlDc3JOQVptTUxJWDFjOFYv?=
 =?utf-8?B?NFBDb0RubzZ2dXRURGlkU2cwR0c4RUpFeVBmZk9URkJpck9PZkczaWVTUVo0?=
 =?utf-8?B?V0Y2R0FzVXNpQm02TlN3eUw5eTRsTHRuSUJSTXp1S2UybTFzZUFJa0V1SE9x?=
 =?utf-8?B?dU1raE4xanBBeFZEeS84dnEzQTdDbFY0bjNBQlNJRmhzL3lkcEw2dzRxeFlM?=
 =?utf-8?B?MzR4SUVQa0Ria25lYVdqQkMrUS9pUEVTZG1zQjJLeXc5UjlYMmVtMXBGQXBJ?=
 =?utf-8?B?SVp5dFlhanp0cWNOSkRNVlN5c0ZTdGZrb1p4YWN2YWNPU0ppdEZud25ReVVt?=
 =?utf-8?B?K0dvTjN2aWtOSmJ3Z2VWZnBWQ0tUbzRsVE9xbFl1MHE4QlUrSmtSL1BpZVdl?=
 =?utf-8?B?MnArU2ZWVkIxeEovZ08vS1VaYW9JZmRwUkhlT2dJbUc5ejVtZkJkbklBcFpn?=
 =?utf-8?B?bGg2UkxyV3VRQWlmUmFHZHpkRURqcW9QZzRuNVVnN0tCZHVFOGhmMFl1SDFB?=
 =?utf-8?B?VEt2OGMxNDFtWFczYUZCcFo2bGZDMnp6VTJFek5sVFN0c1I5OEpZVnBwVSs5?=
 =?utf-8?B?ajJ2aC9aS0VJeG8rZEpwNkRJVytLOTNUNnBnbkhEMHhQd1BtbjVxeXJNSkZx?=
 =?utf-8?B?dGpOcENXdE4rdnNuckJiNmRSOGFKaDI1bHZNcnVQVlJhVjhxRzcvUm9CWHF4?=
 =?utf-8?B?T01mRkxWcm9aZmdFR1ZVd0VvTWxEYW44SDZKZGhLWDRaRDFVbFJGK0NGRGRx?=
 =?utf-8?B?Tk1mVnZaTEJMZzNLT1NyT1pIQXY0Y1NHdSs0cHo4SHljMEsrRFFjQ0hXYlR5?=
 =?utf-8?B?MWJCVStFRUZjbS9pMWtUMEh2a1BlWEVNYnZ5RU4rcW04aHhVSGRWM1Urd09V?=
 =?utf-8?B?MDhPWTRQeWEzQy83RVYzMzRnbVZScEZmbXJmdFk0Q2VQeHlUSGNVMWkrVnFJ?=
 =?utf-8?B?SllsajRWVnMzYkZQKzRXL01TUUdIM2xzT1hMZEI0Q2RNa0xsc3ArWnpTMkc0?=
 =?utf-8?B?L3k5d3I0UmJvQVdxdXFhNEJ3RHJxd1djRkRISGlCaVErcFNYWThKamFUTXdC?=
 =?utf-8?B?YTZxTFd2SFZFR1Y1dWE3YXM5aGVuWEFrbGlaUk1ZSGp6SU0wSVl6RGJyR0VN?=
 =?utf-8?B?ZkYrM242c1NLSk4vbCthREpkU2hNUmZoTStISU0yeHFHYnZTeUt1MnZFL2Qy?=
 =?utf-8?B?WWlvWldCU3VlSndQS1FyT1VxSStMRVFhSHdrL015REU0Qm9GcndqbGptOEsy?=
 =?utf-8?B?ZFhWb3plRTIveVY5ZHBMNnBuVURRamhNY3JQU0VKcTZGcDk2WHBobTFXZVVB?=
 =?utf-8?B?Tm5qR1k5QnpzaTVXanVJN1ZRejA3KzRKUlYxVU5vclZLdjU4TmM5dz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SYqDfZEYBWoRzmPXHTbRGA92ys7BsAWNwsRldDAmq5zmR2j3iW/Sxs7djwUyT41s2ewU5KpzQtSkH/1a8Gf3jybkEYDJxaF9Y0wJ59kpzQI4T4gkDZjtDUr8Cgt6KM2i2QqGfIek51cBGIauGmaSA7s2p2TDY7Z7dzXfCl5dSGVaQ29x2ZVB/Fv8dS8vVG6wJqPsJvHxd8GbtFdy0pnETHfXIAHlTWzVcoJhReb9kSe/XGWZc8O3L0GTWC3ovssml+YJgbNR8IWfRAbMl42521AK56iYXbUBXRio51YDm1qB/U8+tBIIrHi8bjHF5/+6syjTYRxbsaJVStAk1JUblulUL6CGP762G2a1Vygk0r/v3CVrTrXGDxoZrecXeLEttGdpwrbBfbBAx+T6bQFfCXgTQCSftwW56ugLhe45rNJZbv+Eqc7v5/D8eoQsQktn0C8w1Gkxvr1s6KG+/9ptWzKRXRbRMk7VKc211YLSiIQO3StxUV5t9i+3D0m7U9HjUoNsoeakjKyZgNw1r5leO73O/HZzaN2MQO3m7MTD8l1yHt9U01Y9jP3CzJhF056nYFW/tVa6+ELoAJv34DG5mpNsT16Ki9bqqxsn0WzhWaU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0b66bcb-5dbf-48e9-ac6f-08de79ded40d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 11:11:48.2541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnpR3P+GdSklm2g4bLqT98nOQqMd53FBAts8/8w8a6hGEPze2ipofquN+BVBQxObVdP8l1CvNX9c7IaI9Vj4rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040087
X-Proofpoint-GUID: FsQUE18_FnXduJyKIRGDuJ61e8kSs_Vl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA4NyBTYWx0ZWRfX6QjIAnFDLvSV
 1gHomuFnmk/ClBy0Neie6eN57C2/JEAV3YysadOObElyBKwIbOjkLwhb8ypqFxORWtoOX6MHOnC
 VONvZDqj+h1gej1YibXYA2QiODW0Wy9JsO9OMpwXaX3PiPy7pdaCR1dwO8aK1Q9ao5BGzjlfObU
 NQy57fAmYM4taCHLQ7pQPKgm8lQPkd8HOmUU1FkUXr1lxPHeqbiOi1zTY4q+98vqG7822Vt7ZyE
 aGhqmyo3zkp7vPAVSwJQZoeGDXxUHfnfQwNCikYq0gNFkaHG9IrTrfpQMZM/9n/e4qDALvNEwPq
 Zbp7Xo5nsdOmU3N95GSH/bab+8H7uNA+UEzsGTRMqvnLgYKWEKOjloVW8FWJMBUgpMpqMtS8k2j
 dE9fbVN6/ekyX8PVz1BnGA8yOfCLhjx0fpPPNwIrFznSgvjf8ttkxX09++694IsboNWcKezcBoI
 6OBF5Ec6xz2EYPGc30A==
X-Proofpoint-ORIG-GUID: FsQUE18_FnXduJyKIRGDuJ61e8kSs_Vl
X-Authority-Analysis: v=2.4 cv=Q+HfIo2a c=1 sm=1 tr=0 ts=69a81378 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=SI1eWFDOSFOc3m-olbwA:9
 a=QEXdDO2ut3YA:10

On 04/03/2026 05:46, Benjamin Marzinski wrote:
>> +
>> +int scsi_mpath_failover_disposition(struct scsi_cmnd *scmd)
>> +{
>> +	struct request *req = scsi_cmd_to_rq(scmd);
>> +
>> +	if (is_mpath_request(req)) {
>> +		if (scsi_is_mpath_error(scmd) ||
>> +		    blk_queue_dying(req->q))
>> +			return FAILOVER;
>> +		return NEEDS_RETRY;
>> +	} else {
> nitpick: this else block is unnecessary.

Sure, but I will prob be changing this code anyway.

Cheers
