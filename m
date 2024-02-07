Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0579D7F7F3;
	Wed,  7 Feb 2024 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320128; cv=fail; b=ul4ieoKj0w/9LZeJoh5TCBeinjn4QS3Eu7HRHiyKQ02M0vjInbWV9AOqYHkuaf9X3vrdbfOEUSgW489STymygvoVJs5wxXRwk+j9k5pfsqahoPBvth6gFU2QljEmpSjpMgmHUOD8HgRds+DPGlTxirK+hRB3a4r/NpWow6lZJ+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320128; c=relaxed/simple;
	bh=4E+ex66a0SHMhqMD3xLO/91/H6zWnceKHpQuEsqMJu4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UU/rC6pBOt/Ajw3T0rTqYtTpCexr6Nj7YEoSvBGQDJ5CtzUA5+hkwgsihuYfNUhb6wY/YqPqSsnswbhLWKbVMT8QBueV/6JNLHxsALFy4vlJrZIMYy7QGJOXMkcwFB6yU74WG/ZrxC4tfCuJqZcAP1fLZjAgTSZeMYwP/v1GdtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fwWcysDd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x2Gs3xkc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fwWcysDd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x2Gs3xkc"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 417FQFEQ009155;
	Wed, 7 Feb 2024 15:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=yNpoHI5oIYF0GbSLR9z9NLhkZgoKt6IT/5rJH5INf2o=;
 b=fwWcysDdRfJyglvv5N0bDNTo2iiz88OcGJYTH0z1a2m/Jn0bkIPNo2Kc9/AM+EhUik19
 oupVsSQzr5gZmYguf/0H5y1z54/hWyH1xYcZfI2iCM2QWsNr7nLmo47o6s3RcUoNJmNQ
 KqttagO4J/xPverHUbjN55NOdjE71JbsYcOcR2YpprT38NAmsAcmzhJPaEcwZsKv5CmG
 dUJStqjfKzfPwrSvmR5Owy92/yDjMEVBiL4+8kqWtSjco9sMegOwaG/y7tj8oZSYRT+q
 JWAPwPYn52+1ov3Bh2q8dFfpY2u2Kv3mWgLtznXQK3IsF5a6zZ6VTi51H/s/43NwSLrl QA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1cdd233x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Feb 2024 15:35:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 417EiExW036762;
	Wed, 7 Feb 2024 15:35:19 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx963ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Feb 2024 15:35:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4b9AoHvOtpAMEhbLI8E9Oj8gBY54JkKBiOrEr2fF+9kUawgyXULFIyxkyM4vx/VYWobym3AhYXTdGpPPItIFzwDyfsiEDBvvXfMB+ePkF/m4ptTeuOE/sT5DCSMJ7c6ssx7c9Grvpq2L7mi8xAXODEH7eTjl70F5qGk3zg3kUQccRxyzxRFHEJN83kgQpJEvCC8FuHvfygfxMyIbm87f+pFmx3gbdWtQ9VfbVcnaf7PR/vJgqN55AH8aZGbebdPlgR4bK2yWCLJ4NKObxrh7KoydOMZCieLojVtMgJsufMNzr0rfCkIJd4Zrc6DerfNIlKiV4Ny0JLqcBHR9b+1Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNpoHI5oIYF0GbSLR9z9NLhkZgoKt6IT/5rJH5INf2o=;
 b=T8cA9Z35+vOqwd6ywgLRrW7TB64A5o/IioBot9rRqTB3ZfOQizZE63MFdBt66EDSWlBEN2N2+Hr+qkjNA5qCAMYgtBlYf294FB6pRtEjNgd6n42iuYAElXGJ4OTCz+djMIJJW25nvfyLbxEXF3hu6xkyDn79WfcgU2byE3+dqsv/Y1dbFMO6VaBEPTuu6/zF+XZzDJ+6a0SyvzuVboTbJTrVdVF1U/iRP2cKTX360DzlzjMLOqcZMBMjMquNp+ft4MvM7DIgk9OrYXWlor9yYpFcLHqzEcKKW8EfCbAS7X1aBr9EdoFUF0mvFqxT0U0uZBfBl5sDHj5P3CohrDAlPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNpoHI5oIYF0GbSLR9z9NLhkZgoKt6IT/5rJH5INf2o=;
 b=x2Gs3xkchRNiTzL9xP0j/DqmQ9heX5Wlugaz+lQ3rtlrff4ErYgH8l+NLIMPIFLoGtLQuvVJ9hlk/yUhQZiMsZcBBcSQIxR7vB8rXK46e05yYp2tzv2cKndVQp8o5g2/2TgwBWUMW7ScO17COyAdcQPx22A94UTPY2lwTUw9To4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB6641.namprd10.prod.outlook.com (2603:10b6:806:2ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Wed, 7 Feb
 2024 15:35:18 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7249.038; Wed, 7 Feb 2024
 15:35:18 +0000
Message-ID: <da5c3069-7de2-401d-861a-a3f1d7c954d4@oracle.com>
Date: Wed, 7 Feb 2024 09:35:16 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: target: Fix unmap setup during configuration
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: me@xecycle.info, target-devel@vger.kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20240207021919.7989-1-michael.christie@oracle.com>
 <CAFL455m_+s7nHA_FYFHzadb-qWf3VLdCqatGFbWHY1YCeuv3nw@mail.gmail.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <CAFL455m_+s7nHA_FYFHzadb-qWf3VLdCqatGFbWHY1YCeuv3nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:5:3af::14) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB6641:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c050b58-919b-4aaf-fcd6-08dc27f26341
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QrgiHOsF6EQb4VWrUsvT3kN+5cpK7ZQzLhttoEPTnDPVPWiXIWobH4Z/PvXc53vrCNP8athdxzLbJ0S0sBffY8qlcntkp7l+G8CLvGrQw0oFwC1zgIyEvDYVGTtYDXL5zt9TaKMcAPd8nPTPxtiUnVT9NT9tYnyUzd/6wlD4xZ3MPOKi18hH+ch1CWLeyi3ifdLVlDKxFrAjOzzstUEoyKaNHRPEtufGQo7q/Ie04gMUGU7mLFRdoow8cmpnqsHCXsxsZ8e3Zt1meJS5vD1lK4TCffwIhrbi1G8oJj3T/8L6ifQI1YqCRXXzHudqWipgiAJe0NSVQZk+KUK7snBPE1mMdfmAbB1G0Aelfk4VOYmhBFbEKwO9yv3H/Z2eeMDAru7SOUdBUj5S+WysEXubg5bBuF/4GmXm8s2DNxBS7qLDFzbmUTrUuWzE9sKZe2rpg+2oiucXClKLDH7e9A9COqiEQu38kx1+6MptjMa3CmYAljZVedJnJ6lpLq1/WaCdqwEjZAJTkxTVilul7gkgXeAuYtzsPN7LbfuDRsffDjANdov/f9hKgSNXCifNlBk/AxdDdt+bLvQf2t3YtvBEf3Z4y+KqKhYtd+L+mv2bjhXCDbOOyq7m6fu6NTsPo4iB
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(31696002)(41300700001)(36756003)(6486002)(53546011)(9686003)(8676002)(66476007)(6916009)(6506007)(66946007)(66556008)(478600001)(8936002)(316002)(4326008)(26005)(38100700002)(2616005)(83380400001)(6512007)(86362001)(5660300002)(2906002)(4744005)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Nyt2dm1NNWRlWG0yN1cwSHRjanNtUUQ1OHN6b2xoZDhnMm9zSXU3RFd6VzBt?=
 =?utf-8?B?ZW9Qengwb291SmUraVJQMjI4SnFTMW12TzM4NGNwS0VHak1abnpaNlNLS3VO?=
 =?utf-8?B?ckR5Ly9ZZkhjc2ZhcnJuYzRYUHhWOWZGMGVFaDJjMzNJdEhoQlB6U21kZTdR?=
 =?utf-8?B?bnhQU3l4bEd4T1VnVkZLOVVvZTJyaTZ0Q3VsZjJSZmJnVTBJR05lVDg3VHVr?=
 =?utf-8?B?dTBRNjlabXZJT0tlQ3BUZ2svbVljSDIwOHA1ZHA0R1RBdWxIc2g1TEl1ZEdG?=
 =?utf-8?B?cEYzdEpuKytqNE8wbWJTNmcraWdUT09EN2xscmZ6cmsxKzl1RFBWZHluMDdY?=
 =?utf-8?B?RDNwa1pXVW4wR2JDMUVaZVpyYVRONUlqRFpOM0Z2Y2tnTmpDNFVIUE5wam1I?=
 =?utf-8?B?Tnc2SHdwemgyVDNuMHc3UXZ1WlhwRmxFNHpiZCtPejQ1cTl4YjlmOGRpeFpU?=
 =?utf-8?B?NkhHb3F3R09ibmJpM3BqY0praVBES0lONXdqNUx2ZjdJN2t5Zk1aVU5nbG1X?=
 =?utf-8?B?U0U2L3JGT04rMDJmQkVYVzUrRHJrTUhaMzEwQUdzWHJuWkJKZXNGQ3hudmxl?=
 =?utf-8?B?TzFST05lZGRBYWp5dE41Y1dIblZwM0hPQS9rRGhpb1ZaN0dpL3gvWGhOSjFF?=
 =?utf-8?B?cmgrNjNDa1ZETWN6ODVYR1BMeE9nZ2ZxVExCSE14cy9CcmhMaWhOMERJanVH?=
 =?utf-8?B?SWkrL1N1MTNTb3FVaXhFQ2hnTGRobENLV2IxRTVZV2ViajVSK1JHeUZBNVoz?=
 =?utf-8?B?YzNTZG1IYUorRTlzMXg2ci9hR3VyazNHcllabG03S3B6bmNHM2NQcXZYZjFi?=
 =?utf-8?B?WWdQSStiRVdyamQ5T2JhR1ZyeXFQT3FoQVdkQzl6blh4SDBrcm1CZWsrcEVj?=
 =?utf-8?B?SzFNQ3d2WTZwSjEzYmxmV2hXdjZESngxb1NPbTZnRVdyTjkxcjB2ZUtSRzI5?=
 =?utf-8?B?cjBpa2REUVl1YXg2K0dFOTQwTTZMc0E3dmE2NnZPTkJnSlp3SmRuY0ZCMWNP?=
 =?utf-8?B?ci9LOGJHK3NCYUhZTUJOVUhGZU5NWkc2elRXQzN0QU1VU3hzNk5UV2JaRm1K?=
 =?utf-8?B?UkdnUXUvckEvTkhIK3FPYnBoQ2tFYlk3aE5FbVZaZzBzUWR6TTNTc2FHY29U?=
 =?utf-8?B?eXBWa3g5QnpHaXNZbzJwRno2UEFQSGdicHlZWWJtSUZaOUx1MmV3NGsxUll2?=
 =?utf-8?B?SDZLbFZ0WmxZSzBVSnpySHdHeXE5cEJycDVSY0F6NEdUM3hiUFU4QzJoZStV?=
 =?utf-8?B?VTB1Z085SldWZUdoSDRXdFUwWWpmZkZpaStoVjZCWDh3dThPWVczSTBHSjNK?=
 =?utf-8?B?TGZ0aWlYZFh4bktqY1FqbER1a1MzTlB4dWJjOWp6em1yNE1rMUsyZlVJSnFJ?=
 =?utf-8?B?eXR5eG5aamZCNkVWbTNjWHBvR3RpWHFFcGdpbHkwLyt3dHFvL3JOWUNKbERZ?=
 =?utf-8?B?c3JIakRTdyt1TXpELy9JMy9wVmxaVmRkTnNuU1RsaGhQWXlMQjBLbEhacGov?=
 =?utf-8?B?Y09hY2xMY3QxOEFlWUhOT09XYjFUWjJjYk9UQkoybDR0RUcyZVB3cEVtdWtk?=
 =?utf-8?B?WXR6SjlWRW9lNkF0RFc2Q0V6U2Z3OW80T2w1RnlFaTRvVGwrUXNXWG53WWZ0?=
 =?utf-8?B?VnptSHRMVG5TSnRHaWFkSmI0MkZKckhpV2FkWjhRL1R4MDJtenl5WVJKWE9q?=
 =?utf-8?B?MVFKc25rRDBLWXk2aThEcGdaNFU4T0xnazArVktxZUMvU04yTjc4ZjJCekZs?=
 =?utf-8?B?aEcvSWlpdmI2RlNkbVRWS3ZCSEtSMGhHb3Q4N1ZDdTNKZG8xM21BMDkxTDdp?=
 =?utf-8?B?bU05MlFuTW14SkoxNUlDdFh2SGs0ZWxHVHpzR0w0ekJScEJKeVk3cHg1ZG16?=
 =?utf-8?B?bnd2UWZWOXNaMjlUbHRvSTIvZ2V1UjNYRFBPMCtRZ1FiUjJoUFI5MWtxTE9Q?=
 =?utf-8?B?R3RSMEtJbGRBS3VNZjhlZHhCc2xQMFhkRnNFejdBcFRXUHFFNGVFMFgrL0ZT?=
 =?utf-8?B?dGJMSDEwVjFXUGZkTDgwSjJrUjNRV0VtNjBGTEk4UnVSVGwyWUx1YWZGZCsr?=
 =?utf-8?B?YXExb1BDMWtKc2NWQng2b2g5NXN1aTUzNkpIamxTNXdEMTNHTUhqRkhLK0xw?=
 =?utf-8?B?S2FOTFN2d3B6eUVpZHgrajFHSFpJcG9yNjBZS2U3c0lySU52ejluRXJBbW5Z?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	unvmgmYJ97M/i1ilmREqEm60CoP7wc+bDiouNh57pMmid0NFfI/foPARH98O0/tM4ANMoSzTrM42BAEq98d7MTM8qsGYTh3KLdVAebzlggkIQCq7RjvF8lSA2soiJWAXRCa6J7FPELuD0HfAf15QL3bfJ5+gSL10Twplqu8YwSz1OupUdP1L1qLGq+xEEHs//FLNQXRKmeZeZimJpLfD//QSC8qGDsL1/XqqZ1BQ8/f5cTyZo4ui9VdUHj9TxgEoSdBfVFS1g8SFHziRyUzOe9jKay8sG0KLFwC8msSQsSwo8qcmjOiqfl0bpc8+3mYdlAMWYIa3Xj4scE6a7I1DowftAqK1aejH7caqvY3K9rtEZl1DRzGXBkEN6M2nire0WIQHlTUKpbMUKGe+BKa/vf7fiCzW40of29z3/gCpR4BxgjGJ/5FGMVwhh9s69aXg4BgSDfpeN37vQ2K/60wmmc8ES+mObQSDcNXOr6dD8JYE3BgFWs1NjkfBvovK5nuMrAa07jkN3igScFs9nq57sTbYHd+o1K8dBHJFfDZ8imSlI39SgzRXmjomNwD1iSR4Pqbg1Sk+LuXHb3+s4U73x6cG6wSMYM9knTlUu22dZc0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c050b58-919b-4aaf-fcd6-08dc27f26341
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 15:35:18.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/zgMpX89fV4xkEhmk+JDeaRYPqjipwfw33a3IjTt4fFWwQ4rqf7EBngxUZmgRIb3J4TZeSGCtxiwOBw+eUjJ3K+z8CMcRAzTtL7OPrESA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6641
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-07_06,2024-02-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402070115
X-Proofpoint-GUID: 1hSs2chT31fJWW4yIcQJDsXQt2bLjzws
X-Proofpoint-ORIG-GUID: 1hSs2chT31fJWW4yIcQJDsXQt2bLjzws

On 2/7/24 4:40 AM, Maurizio Lombardi wrote:
> st 7. 2. 2024 v 3:19 odesílatel Mike Christie
> <michael.christie@oracle.com> napsal:
>>
>> +static int target_try_configure_unmap(struct se_device *dev,
>> +                                     const char *config_opt)
>> +{
>> +       if (!dev->transport->configure_unmap)
>> +               return 0;
> 
> With this patch, if the configure_unmap callback is NULL then we
> return 0, implying that discard is supported.
> 
> Before, a NULL configure_unmap callback triggered an error:
> 
>         if (flag && !da->max_unmap_block_desc_count) {
>                 if (!dev->transport->configure_unmap ||   <<------
>                     !dev->transport->configure_unmap(dev)) {
>                         pr_err("Generic Block Discard not supported\n");
>                         return -ENOSYS;
>                 }
>         }
> 
> Shouldn't you return -ENOSYS in target_try_configure_unmap() if
> configure_unmap is NULL?
> 

You are right. Will fix.

