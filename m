Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB1E1F2395;
	Fri,  3 Jan 2025 09:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735896837; cv=fail; b=AoU0LI+XXWERFPwOKYZmN+66gigSLaMWlN0Nm9huD6yNr9mgdDVAQy5oyS+4TqWoWbBvhbtdy3epGhk4aKnG0iW9SgZbptpiHavx3qnkM4HRU5/rB2a3p0dLxDOcfkz6D7l3E5lu/4wLovABDNSIHo+kGf3I811JoC4ctAYdKk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735896837; c=relaxed/simple;
	bh=EpXpVjfRiqxJQ154/+v5yzjdgRctc8HTq/yZ8GnxFKI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ue0dgvNBXOIWl3tG5wCb/PmUwgUdGK8nZO/cMfnBEk/jNhjh3GFdloy0cOnjzhW0hhFLEh1ir97bFKG2z6p1VD1GspeMp3aYFvvd0kxe7Bbi8+zVCqXxfiooukEMK4Uj24Gnrd5mcOa64qbpNeh0moCkTCuEuiad+8wR1iGMoNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iea838hB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U8Irzc5O; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iea838hB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U8Irzc5O"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5035McXt026115;
	Fri, 3 Jan 2025 09:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hNlHNNc5zQHLWF7XN2FO7faBM2i6ghw4rmZT2pY7+TM=; b=
	iea838hBSCaeGVGhkAWkMvXbHQyP+l5aePV9tbfKgRvRDi5p+qVUJLLn7ZGM9q5p
	a7nHrGxFLhsxzw/Mv0PN+8wNfsVoVHFmYzqkqoxDRoci2Pe0RKTHjUtOtjdWnm9X
	CVy8fXqDYxkOSp8H06wiAW2KDSG/t5O3LFMgXrT9OaXTQ50UupD9mekEygE6mTV3
	M1leUJ5g8+O3CqQdkcFQSeekLloiljCy878qX5EIU84UPNf3mMRqYvwIl15tSr+U
	BZZ/6fZEgLakRO/Xol/5FVbNZbebzsZEFLFCa4ZQ48wGVqcRYemoQwU6hSXhELYk
	U+Ar+IgJGmSeP6l+c0Ip/Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t841yv9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jan 2025 09:33:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5038h5f8012556;
	Fri, 3 Jan 2025 09:33:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s9juyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jan 2025 09:33:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Drguq78ntxNgv+C4lEk2b+NCRlNfdG6pl2R5LMM+l5PI702NZ0x5tTwHHgLLn4xl8o7+WN7eX9M/PfHWO53Vtldg6/QVjUHZ/LmhiCxHCF5aeV0Cj1hSSHfQBNdpy1yPJkN48v0qN1DDsip4Ao0PKPWNM2LKEknteZ+wAU0dmei0yeSJBpxq42ghyi8/2iXcROsIKwGZmIkCCNwBj5gNrvFqpn1BgkMkIVPDUAgYgqe0BSGtwbBji/R3nva2c2tZmuzUNH5qRWLLfGxGAGk1DD8Mg+EMZs13eN7EENpe4owVS+YvP8dK+WavWVGjfy8rVsfMF2xPpoWrI3vmIReTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNlHNNc5zQHLWF7XN2FO7faBM2i6ghw4rmZT2pY7+TM=;
 b=bVi8O7uzkO2DOWSfZdzWLufv1lrgEuKNkc6QCETBnca6WFdBvYU/DmQDid1tjEtnaW5BgaowKPrJVJKjlhqu/kStbA/vo/oB+opR+NqBqnJ/r3rFldGXUcZD+Zi/LZMoNlzlq1krEhc0kdHH7g/vacY+8cUK70biNASIV2Hxi5tDIWrHavQa2UKtpr4EvCzkI9BumC/zFHmRvMwCz1IKNB0pXePESP3dG7VDtzSSzZTDMyH5Uj71tsJ1oq0frIAM2E5XY13/AW3PMyGL06itDuFwbt5k8pqm0Gogi7IF9Rxkri9aGQm/ppuJ0NuJbdCd3D11uBBPFUQfR562Pz0wTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNlHNNc5zQHLWF7XN2FO7faBM2i6ghw4rmZT2pY7+TM=;
 b=U8Irzc5O6fDwDv606MjkEy3WUBTs9Le+R25moL/Soj24UjE+tdOoQUtwurTMNrxuc/YIzFtUHDjXMaWSof7Gopj249uV8/vX4dWEGiO21ZMaiJZ2x7B76kOj8lwfvReanjFtwfQnUvmSKo+uL3L5ZZ5XdgZHtsukvJh5Rb+Z4KQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB7497.namprd10.prod.outlook.com (2603:10b6:610:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Fri, 3 Jan
 2025 09:33:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Fri, 3 Jan 2025
 09:33:39 +0000
Message-ID: <d7cbbe46-ecd1-4bdc-8fe9-7df499ba9e6f@oracle.com>
Date: Fri, 3 Jan 2025 09:33:31 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] block: simplify tag allocation policy selection
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250103074237.460751-1-hch@lst.de>
 <20250103074237.460751-5-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250103074237.460751-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f959876-d9e3-4b38-0b9a-08dd2bd9b4a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmhpbjNLNmtvV3hYaEwyTkhRZTExcVRiVU9Ea0NQQ2kwMklMNzhQQ1BVZXI0?=
 =?utf-8?B?WHRZdDJ1RHJkeDJBdm5HeXZWcjgrREQ4QnpoTnRwYThnNkdDMkFMSkVJZ290?=
 =?utf-8?B?WHV0V0FtMEROSzB5eEtsYTlGU2R4Y3dvN2xGZ2VyVFJjSlpQcWpjd20xNzlY?=
 =?utf-8?B?eUJQYVFlOXg5S2pGdDBkaWJ2dGVQOXRZTVJwR1M0aVgxYTN1RmJZTGsrNFdF?=
 =?utf-8?B?SHJrMkxHUndrcWFCQmE4LzUyM3R0VXpYaEpQMWxqdWpxcENBRmgzUitHUXZp?=
 =?utf-8?B?dGdwdURsdE01cnpDY29Uc21OR1RqUWtPck5KYjgrbHVaUWVnM1ZmUUpWa0c3?=
 =?utf-8?B?NGt4L2FBYzBsRXExKytlUnF1QUF5WkJPVjlLSWtueUxJN3NZV1FiTzFZV0VG?=
 =?utf-8?B?NHBqK1BaOVhjWVh2OFN1UlhNTFE0UytZN1BaS2wzMGdBeUF0WUV2SUpESlZE?=
 =?utf-8?B?SDVnL2loeVN3Z0hEMUszRDhrdVZvNENES1kzVERWZ1EyeC9VR0Y2and3Y1Z4?=
 =?utf-8?B?QnFvQnRHRWsvcXMzQ0VEL0FaTjFLc1NKT0dNaXorQmNsVGQwWDI3cnNINDZn?=
 =?utf-8?B?YVFRSDlQNFNJRkRtZkhxMThaUHBZVVozSHpkWkpKWEYzb294dElJVVlFY2dK?=
 =?utf-8?B?d0VUQ1lUOTAxdTcyVE1OQW83L1VrMTVwR3Y1UC9EdDBqUWxOL2F1a1hFK2hx?=
 =?utf-8?B?cUNkZnBSMkRpeHJpUkpxWXVIbzdreVNWNXBjck9TaWhtdlhVNjhQZktJZ3Jh?=
 =?utf-8?B?S1J4WXFzS3U1WW8yS3RJcmFPL05MRjJteGdaRHd3ZG9GNTlEOTRxMEg1RkhC?=
 =?utf-8?B?ZVNJbkxBckZmcTcxUFdXeTBoNlRkbUZYL24ydlNScjBndHZaeEc4Y2Y2REZU?=
 =?utf-8?B?YUxuUUxVMCs0T0FxMVpVVy90ZnVIMjR4N25xZEtCVVVzR1BUQTE5Uk8rMlVM?=
 =?utf-8?B?aEg4S3laOWI5cEdrMGY0QS9hUXQzRGxSNVpjUjRLdzB1SmZsZmlGenFzQThI?=
 =?utf-8?B?SmowZlR0V1hwVjFlaXZQWW43RlJ1eXV4d0lBTXcwSzdpMGNTN1I2Tnd6Rjhz?=
 =?utf-8?B?emFmaC9ySVA3WVhPYVluNmFUYkV5OWtodWQ5RTJpbzg4RFc5bWNoZzQxV2pw?=
 =?utf-8?B?Z09uSm1HNy8vOHJiQXpGcGZSYVpOSXBnOFF4SjZ1c2JKempVbExKUmpCRTMr?=
 =?utf-8?B?TXBJdENkc2tlekdaQnd2NWlyU1ZJaXdHODh3VXQ5MkJKVWJzdUNjQlQ2WS9L?=
 =?utf-8?B?TkkxZThHRmRFRGM5T0lVamN3emc5c1VqUW1ZNjR0ZmtWcGFrZFFwOGtvc25h?=
 =?utf-8?B?c0lrOXp3ZzRXV0JLWGdEenNOUG5OQi80OHd5SXZwVHZCaGgyMXFlQWxMK1JF?=
 =?utf-8?B?RDU3dFgwUTBPOHNINXB4R0JqSGtHbGg0TUd1RUR3T1hDZTBPVmlSbm1aeDNi?=
 =?utf-8?B?NlQ3QnUvVlVnaTV0Ylp3ODd0U01SaDFVMTg3dHNrbmVjNUgzOTlKUjFaZTI1?=
 =?utf-8?B?dmt5VE1RREpqTlZ6bkc0TUUrZ05qN3FnaktuYVBmS2YxTTY5UEFzZGkzRzJw?=
 =?utf-8?B?bGM3MXFoaXRGLzZ0QWxHU2d4VDRVSVE0OXY5MGF6Yng4MW16VHYzNGd2TWRQ?=
 =?utf-8?B?TmxWdzBQaDhqSk80SnNiYTRoT0ZUR2JVU1VDYWFyWUZKdU5VMjhtcS85NW8w?=
 =?utf-8?B?cFpaVlA5RHJxUVJadTdwY2RPYzVKSWlvcGNkL2dYOG4wQUFMMUx2bTVkNktT?=
 =?utf-8?B?VE5HbVltSCs4eTdVVmVJd3NSS1hHVXVoMXlwNkZnWGZmTWZFVzhLaDRSRjNm?=
 =?utf-8?B?bjYvYnl5eHA3QXgwT3Q5MkdvaFpYekZnVXZOUUVZWE1vYjUzQW5OOWdudVY2?=
 =?utf-8?Q?nXt9KI8qI0xPq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDBWNnVMT2xJZHlNTng1ZytBR0oxalIza0RzQ0pQWS85M1lNc0NVcWFKUElr?=
 =?utf-8?B?Qy91WWxvbFdhSkJSN3VCR0wvVEVKZ3dHRVlVUnY5ejhrTm5VUERycW1nK3Q4?=
 =?utf-8?B?WjhyNE5nTHlKaWl5VzI5d1hVMmFRRWpiSy9hTFl0bk5wcEZFcWg2NEdBQXNJ?=
 =?utf-8?B?a3BxaEtrQWJIRGhDRmhTcktTbFZUTHo0eVBCa2FhNktwQXE3Znh6MnlIZGQz?=
 =?utf-8?B?TU11RkpJelpiU0tpaVIwalpoeVROa3hLUlg0UEV0cXZyQ1JaN3d4TGFQY0tZ?=
 =?utf-8?B?KzhTN3IzQUw0NFY2YWs3YUVVQ0F3Y0tkWlY5VzdaQS9PZjJtRUFiMUpTNER6?=
 =?utf-8?B?ZnB1M21jeXVkZGZIWXhDZnYzTGFsYVNVUTJIbmptblhZY0lVUXB4VkRSVGRE?=
 =?utf-8?B?MXg1WWFrb1R1R01FYTJTbE0xZHVCRktpd24wYkhwWWV2QXMyOURaS0NKbS9R?=
 =?utf-8?B?dUJ2a1Q2MVROUUhBRjBFb1lCcG8zMkFySzdZMGtULzVSWlRxcmRFZ09ZMmhJ?=
 =?utf-8?B?OC9hd3h2UlV2WElaSFJURU5vbVE4ZFd4dlVCOG5JY25zNkh4UXZJV09CN3N0?=
 =?utf-8?B?bTU2K0w4eCs4UjlKY2tWQWVXNjRjZThmeE5OaWd0RkZOSXg3MERxQ2RIYytk?=
 =?utf-8?B?YjQyUlI2cTVKd1FxR0EwYmwzYTIyQ0FaeTJIUjhwOGh3a252R1d3cnJWMUFZ?=
 =?utf-8?B?dG1oSHZqZnJwalhsU3ZueWxtelRkL0pCSXdpaWtOVFp3VUFERC81bWJNeWF5?=
 =?utf-8?B?SVd6Y0lnZ0dyTFRtQktJREgxWWlIc0lrUjNPS0ZFVGg1bEhDY0xtQ1pTNlVR?=
 =?utf-8?B?TWdEOWViUGUvUUR3b2dJb1RxU3U4OXBtMlc3azlYQ3hHVnFncDJjZnYrbEc5?=
 =?utf-8?B?RDgyamFYMUZLUHVYakpEcTBjdm1hNFp3Y3VtUzh0M1E4Tlc2Q3I4aTdWekxJ?=
 =?utf-8?B?eHU1NFpaRFN0TTVyaUV3WVFFeWtLZFNBcmVSVU1GQlQ1bHY4dlMrMERCdjNJ?=
 =?utf-8?B?MlZ1am4wNTl5cEE5bHRHZXdKUkpBWTY4bFRCSEFxTVpSaWpoVjZOR2hFNVpV?=
 =?utf-8?B?SUJjcGpPUEZQUmY5VDNLRWNORERyaXk0S1dPaFBMYmlxZ0tCZWwvajJDa1J1?=
 =?utf-8?B?STNVaHM2RjlUMjIwcGszNlZPRVY1aUZQSGZXZ1NSSVVjeUNObnVVR1FpSGZS?=
 =?utf-8?B?UXRnc0VmTEJzUUJkS3R4ZXVmeWVZU0lEQk9vOG0xYW12OFdFUTI2UnRIcUEx?=
 =?utf-8?B?cGRBRHRkUXBJTlI4KytCTHE5NnVicnYybExOQ2wzWXVXaWR3NGlkanppVEdu?=
 =?utf-8?B?WEMrWkRXK0FUSFhEY0U0QnBRUVU0anN5ZDVDaFl3bUJWRFMrNktvT1A2eEV5?=
 =?utf-8?B?aGxGWTJUV0g2UUhFeTV2WE5HNTZpMnoxQk03VUZWZEsydjBLc090ejl3eWxt?=
 =?utf-8?B?VWYyZnR0REk2S1lLZHBGU2FMY0ZjUW5SdGhMbXNIdkZPYTRoZ2o1ZTZHcVky?=
 =?utf-8?B?bnZFWEpQSVU2OEFkNnNXWjdMd3lERjl6bmlmcFdEWEk3cjcySVZua2IwZ0xP?=
 =?utf-8?B?Um9DR0tpaWlyaGg0dVJSTjBwWlp1eUFwRGNub0xscW1FUld3bG5mZmRxSitv?=
 =?utf-8?B?ZnY4T09YaFZ2TTZoU0VOTmozNDBHazFKRW93TklKSTkwcjdnMmVPUEtVN2Yw?=
 =?utf-8?B?T1dnaEYzR2NHVnp0b0VFMGw3ejV2V1BqYitGZWkvSm00cHVpZitjUU1WRnFs?=
 =?utf-8?B?dnZ1Z2t3ck1kb1dqaWxpcFIyRmg0VFV4aWhGcjg3M20yN3JVQzZkbFR3TVdl?=
 =?utf-8?B?NElnUmdXSWxWUzZSU0ZNekV1VHhtT0tESERFcmxOQnQyeSs2VHlQTEVyaG9Y?=
 =?utf-8?B?dzVyQUxsWmNCejFtVGtCT1RPbFprZnpTQWVSZ0dvY1lKUExmREtQcUNET3lk?=
 =?utf-8?B?Q2xTS2EydkcxcGw3Q1VSZlR5MXZsYmxoZldxOE1zTmhTMXVOTktvSXpCWUNv?=
 =?utf-8?B?N0dwd3o1N3lPM2V3YlEyVTIzUFc4YTdwM2pmT2k0QmpCVUxvLzFkRUgrMm1Z?=
 =?utf-8?B?YjlHUnhDZFAyV3crcjMyeURYb3IzZThSVXdsc0RrR1ZZK0l6Q0pBcVBWa0Ev?=
 =?utf-8?B?TjEzWmo3MUh0Z3M0a2F5aWdlQlNjWkVLcFhpQW40SFNpazVFV050YUEvazMy?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ugVAbWtYO00ZJmsmf8873twlsb5zvaHrF8CK2Ya498oHoxF26EoBqC9bW/Htvrsf3goDRGKKr7opwxaCFHNXlxlp9NWw4ln2Fg4f9waEi9JZ8MVVGcTqBZE5X+KPqUrucwCAYUijBZ8gMK5Vtgcl2iby1qk81nfTG1CvGDgi2fuRHbsousJRywzPdPQEFQrCpU7UB5+lBJxKUIkZuLjWbIpd1Ghz/3VNfsCa99zVrMZNcxnkfY7FXm7HBZLTCCFKozt2siNGe/0KkOZGQb6TmplLdOZjDmMuIvILTkcNq4lMHPskLj7yZuPt3jNmUgc4azubhRYFdu/0+BHp3N43n+JxXvG/z5hDuvtPRt8G8WZx804x7SjcOwZNN9Fo0+VVBTlOuSy2aIGE0OckarCIrOET5rHBCCFUGVUKfZhJiZVcHgwbPj5EbpJjEXaBYjujICx/zcGrjQp3NYh5ZNWOcQJabW21qUn9yFAoLYCsASXXnm1XfJB9vfFqeyVjpvKrfoiFfAKbKNMhgcj9MMargahaoMcUHaw/B3ZF7qSXtO/qqwUJWeHefYyfViE0FnJglki+bv4kcRQ6EvQgBdHOglUbNlJZL5Sk5YXrh9uXYLc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f959876-d9e3-4b38-0b9a-08dd2bd9b4a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 09:33:39.7742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhv50mxqnJo1R3XyUX75y0sj2VnY6oMbGMdJUWMwCnUrjP60uOsy9pzOL48OPqKHcqm3Fdyes+DphkVtbnZJYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7497
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501030083
X-Proofpoint-ORIG-GUID: aXSns60BV6-OD6-JCkZipK2LnWljf5Ec
X-Proofpoint-GUID: aXSns60BV6-OD6-JCkZipK2LnWljf5Ec


>   };
>   #undef HCTX_FLAG_NAME
> @@ -192,22 +186,11 @@ static const char *const hctx_flag_name[] = {
>   static int hctx_flags_show(void *data, struct seq_file *m)
>   {
>   	struct blk_mq_hw_ctx *hctx = data;
> -	const int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(hctx->flags);
>   
> -	BUILD_BUG_ON(ARRAY_SIZE(hctx_flag_name) !=
> -			BLK_MQ_F_ALLOC_POLICY_START_BIT);
> -	BUILD_BUG_ON(ARRAY_SIZE(alloc_policy_name) != BLK_TAG_ALLOC_MAX);
> +	BUILD_BUG_ON(ARRAY_SIZE(hctx_flag_name) != ilog2(BLK_MQ_F_MAX));
>   
> -	seq_puts(m, "alloc_policy=");

Maybe it's nice to preserve this formatting, but I know that debugfs is 
not a stable ABI...

> -	if (alloc_policy < ARRAY_SIZE(alloc_policy_name) &&
> -	    alloc_policy_name[alloc_policy])
> -		seq_puts(m, alloc_policy_name[alloc_policy]);
> -	else
> -		seq_printf(m, "%d", alloc_policy);
> -	seq_puts(m, " ");
> -	blk_flags_show(m,
> -		       hctx->flags ^ BLK_ALLOC_POLICY_TO_MQ_FLAG(alloc_policy),
> -		       hctx_flag_name, ARRAY_SIZE(hctx_flag_name));
> +	blk_flags_show(m, hctx->flags, hctx_flag_name,
> +			ARRAY_SIZE(hctx_flag_name));
>   	seq_puts(m, "\n");
>   	return 0;



>   /*
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index 72c03cbdaff4..d51eeba4da3c 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -378,7 +378,7 @@ static const struct scsi_host_template sil24_sht = {
>   	.can_queue		= SIL24_MAX_CMDS,
>   	.sg_tablesize		= SIL24_MAX_SGE,
>   	.dma_boundary		= ATA_DMA_BOUNDARY,
> -	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
> +	.tag_alloc_policy	= SCSI_TAG_ALLOC_FIFO,

do we actually need to set tag_alloc_policy to the default 
(SCSI_TAG_ALLOC_FIFO)?

>   	.sdev_groups		= ata_ncq_sdev_groups,

> @@ -39,6 +39,11 @@ enum scsi_timeout_action {
>   	SCSI_EH_NOT_HANDLED,
>   };
>   
> +enum scsi_tag_alloc_policy {
> +	SCSI_TAG_ALLOC_FIFO,	/* allocate starting from 0 */
> +	SCSI_TAG_ALLOC_RR,	/* allocate starting from last allocated tag */
> +};


Could we just have

struct scsi_host_template {
	...
	int tag_alloc_policy_rr:1

instead of this enum?

Or does that cause issues for the ATA SHT and descendants where it 
overrides members? I didn't think that it would.

> +
>   struct scsi_host_template {
>   	/*
>   	 * Put fields referenced in IO submission path together in
> @@ -439,7 +444,7 @@ struct scsi_host_template {
>   	short cmd_per_lun;
>   
>   	/* If use block layer to manage tags, this is tag allocation policy */
> -	int tag_alloc_policy;
> +	enum scsi_tag_alloc_policy tag_alloc_policy;
>   
>   	/*
>   	 * Track QUEUE_FULL events and reduce queue depth on demand.

