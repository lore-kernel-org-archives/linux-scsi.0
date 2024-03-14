Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B11D6EB41;
	Thu, 14 Mar 2024 10:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710412333; cv=fail; b=OGjR6onSJnQLFD+xCtpFh8a0jVzAE2Uha8VnWFo1uBCrt1ThfCr0Ds9sr9h73gE4Q76hroG1sxU0rNS1uEEQd2/rcTnU94OjUJElZgcms7sbKjGODdlUnZez3dFm1c8MgPvwtYhtyRjA96LWI22mwP7nrrA+GJTfe9sFIXsDPJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710412333; c=relaxed/simple;
	bh=c2R/j2S9WZMQ9X2AXdrBcSNpvbwkNe9RmVF12FWRsHs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lEn/sevK+MgKcJFQgGDF0gZR9+UCImv11Ax/BB0WXXGQHfliOdhknHAp/sEzHYSEi3pbKNnouZ0FUkuiS6s1u4DstkjXS71aC1+WIX6dnN5pEH3ecjeLOAoSUoUTcT6KABHvJbMcYudL2dBuntKS2C9urrZYlQ09FDiG2JVMusY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RWa7osaS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GpghkVvn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RWa7osaS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GpghkVvn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42E7mq6l012793;
	Thu, 14 Mar 2024 10:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=8SklKodICpd4h0Jk+ExA0vx+MtGONnbuqcTLGPFKf+g=;
 b=RWa7osaSAAjx8GlgZs8DHS0fUSsxtjUgf6t/ygKo0ybLrxmWy1LxwOuioVMqVslpiALb
 YzAaKyb0DcKRFhldB6Neg4UBL0nbnuW2hl1JePYLKI0oiays9pVHvyMLG+LrVNRh2ekb
 R4v4RUYM796hfVZko51LzAvky/KGdTeFqmv4+pSteV1dhZ+2N4RXkrqrFqseP3PmOC2K
 XJRj6q3LPa0uy9iqxTrUP5tQ181Xw6sJ9RcBLIpHTStBd5TKN50m5XiFObFna9oOiZi3
 bMEIv31kYvEXpUwu3Y+y9xIPkV5R270On6ATpb6iBpszZJgib96lJECPKCL7cPDoFMxb UQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wre6ek3fe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 10:31:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42E8vUdM028610;
	Thu, 14 Mar 2024 10:31:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7a76bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 10:31:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzzdV+fgd6zaWmVHU6zeTX/P39FncyU/lrJrJWGMuMV5eodC2u3Zw3MvO1iGG8v2es1KRMmt7npktu10EWXZ8Xu2cJKva4JIk7WwqbpZFQBUDlNUpU5wUVQYJnBE5/UlXPbifCP9L50iSfNr7BwSR5JS/zAw60IgToMwTg/L9DVmZe3/IcfepS3/kyDiOR/DvojhoYA6XtUXCVTOq2kwl2dloUfglgJK7E8BuFPnuN9JUP53uayFRGRVOAORvrL5iEj3ivXul6EYo8U/uo5KKHVZGjg9fIfHoENn2UKeCEoR17N0N2Chd4A6xL07+Uye9m9kkTal9HiVUa/yC5iCZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SklKodICpd4h0Jk+ExA0vx+MtGONnbuqcTLGPFKf+g=;
 b=WbmwAd2oja0jeJ/ZatS4D7Rvq4zLaQ6ZcBHMvBvnplSSKTvQxcMns2Gl6I99lLT9v1XHMvmAGbAYXjoBUWGhoTEnoH26CdVPnFh+04aiwz6cahg9RBOfctKZjkTWvsVYRmI/UbSGicKp6fSL3seOyOp0U21F5jKIXgaNqG4LxgI0veh95FfPTm7PjrTo7xQV5A5lWd4+GsqI6R7foY1QrVuAYUb+dUrwDjZCMTeuL8a9Wc5glveXvE10kSLq2/rsiLNuY3NyZiw3EqBz1G3qq7yoIlkCFaNxaLSfontsmtRHRWk5ovUHkRqh2XSkKSQYvl9rqYEQX13r25B8M3I7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SklKodICpd4h0Jk+ExA0vx+MtGONnbuqcTLGPFKf+g=;
 b=GpghkVvnLgjvVdQLYL50+vT+MGLGK+YECfh2RbPYzwBbNOgL6fucbeXEwnTYMvz0U6GbIGBIgwC9HCG/uT3PTo1LOSA2+0IwRxP0QZv7+7GnfRJ/IR0f/hvQNkp8SXRc5pH3NgmQf+l9ux0qXFF0pphozG0wSF+X0LsI49gocNI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5019.namprd10.prod.outlook.com (2603:10b6:610:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Thu, 14 Mar
 2024 10:31:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7386.020; Thu, 14 Mar 2024
 10:31:45 +0000
Message-ID: <36cf2d98-931f-4b33-8701-a737d6b0498b@oracle.com>
Date: Thu, 14 Mar 2024 10:31:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] scsi: scsi_debug: Do not sleep in atomic sections
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        stable@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240307203015.870254-1-bvanassche@acm.org>
 <20240307203015.870254-3-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240307203015.870254-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0001.eurprd04.prod.outlook.com
 (2603:10a6:208:122::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5019:EE_
X-MS-Office365-Filtering-Correlation-Id: b8cfae44-9532-4e06-f94d-08dc4411f2af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uRN5sHgAYoh7jG+7S6xyBEoHY2dQ+O8t8vdgsRX+XkmniZCQka0C0DzuPkvlQ1oT3itacp4/UlR/ncqf6NC3mnls3gHJJRdAYZoR09j8LbkgjFFRGdQ3YHDzPiSs2/NVmL2YAkWj5Z6Ow3b/YUtRh4QcxGb3K6/91LCzoRJxBdLBFqsHgvYPDxn77GeAQ5hkG5ncaA/XHoNyfflfW39Dw5kT7PXw3ZppD1zidkDLtOLXaqbNVZDbPFruPkRFu7tLE+Raoso0zjL5DTc8VnME9yssJGKk0n+Urs6yero/8taMPoUWQqJA8oieXzXJfz9RhtkSnav88dI6Lt1CaVb40w1Y0ITlNTkFbN0I8CaBKAgy6v19Z9GneHdrEufbcIig4MSQL4JznE4l+tmIr/lUXEkDeZ84BZrrNslNUcmfwobc8HSStRYSKnbuF05dV1TfM08KFyGWi7QkgTzzrJzRM1eBV3yPdiGUzNHLcEhEn2T07EtPHJFELo8S3SxTBle+1pPdEFRND4BUWD1Z2pvTQ6jqOPk8Ofh0cAvw/YG6x8l/mpmPYwN4er1aoJg31tWN23+e9WN5Sf3Wkdl0lW02MjrNH9zJ7zcjt5xhZ9CBQshrUMUzDdH9BqAi4KdLbicgYzU6EOBafatR1V8pjT2Sfnh0xrlpjwE9irbEXqjkI2E=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V0p4bXgwejdsY3dqZCtkNDYrSUtEZDgrQ3NHOVdGdEpXRDhDK1pHQ011Ri8z?=
 =?utf-8?B?RklEbjFMRytKeitNeW9abFhSRktkWkJlaDlpRU1Iei92UzBaZzJTWVV3cWFQ?=
 =?utf-8?B?bG1lL1NFM2RQVTU5ck9tVEpnbUdkQ0hyay9KditzaExiZm8rQVNOdDY1RTVl?=
 =?utf-8?B?U1lPcW5HamdnRkpic0RNNHFWVFFiclEyZlBKMXhSZDFrcUpBQ1lnL0VKL2dL?=
 =?utf-8?B?VW5LbllpT3FzeHFPZDhhMktRd2FCck1LR3MyTHpnTlFuZVlyNG9oZ2E0aG1i?=
 =?utf-8?B?Q1V5aHpVSnEzUFJZekFBNWFuZjFwdUVEaGtHNkFDSDZlN1FMQVJSZm1oT3E5?=
 =?utf-8?B?ZndhbmlhN2dVVDJCbWVYMTF2ak5CZ3BnYTdNMHQzUTZlWmlPUzM5aFJiTVFX?=
 =?utf-8?B?VUJMdE55NWttQXpLSFlpTEo4aTEyRHhnSUxHdStpVVU5b1lzWnNLRUZ0NVhY?=
 =?utf-8?B?R0FmeW44Uk8vM1hvTy9UeXNEcjhrZ0tTWkhHV2hBcGRMTVNCVHJuMEl1QW9n?=
 =?utf-8?B?Vmt5RHRFU3lrajArNjU1dzJtMTlGU1FkZHdrbUx3T09TRE5PTjNkMkZaMUNn?=
 =?utf-8?B?M25zcUJFdnB0SW00Si9EbzJpTWJPWGFtcGJ2TmtVUEtnYjk4UmNlQjNKbFpE?=
 =?utf-8?B?MzdwSXMvTm5Mam94djFjQktoUW85YTE2bSttdnJRMUp2UkF0UktPT1NmUDBt?=
 =?utf-8?B?L3NzNGpNQVAwNHNicyt0d1V0YUcwU29XQzdYVFd0T2srU0RiNDdFZjM2VU15?=
 =?utf-8?B?YkpJZTJxSVgzaFI5MWdZZy9TL1BrZXNzTTh0Smt5NVJTc0p6dDNBY1ZNUUgy?=
 =?utf-8?B?RFFTSG1qYW1GUjVsVTcvSEhtazVKUWtjdGF3Q3Nyb1BkbUR4SVZqWjhjbXNy?=
 =?utf-8?B?QkRRSlBGbFo1SEo2QW1GRGdPWkRGUnM0b3ljSjNaNm5zdUNGQ0FJcnlNMHVZ?=
 =?utf-8?B?dm9ySmNIL3ZsNjE0SVF3WkdwTVpwZnlnNkwxeWI4OVNrNVVxejk2ajkrdHVX?=
 =?utf-8?B?d1lrZEVrNjlSUVI2ZmxSNW0zK2I1OUpZVW04NngrNnRuWTc0N1pvQ3BNNTd6?=
 =?utf-8?B?OUtOZDdrNCs1dEJJTEJUSUtvZTR6c093UERaSFdIQzhkOEFBeXhlWjRzczQ4?=
 =?utf-8?B?SEJralBacXlteTl6MmVDWStNTjcyR2xTeWVNc29GcTVYSDI2aHVmSHJ3VDgw?=
 =?utf-8?B?R1NEUmt2WGZiNXZjVkIwUU5TbUJkeUlrRTJ6RFNnOFM4MWVYQTBBdUk5UUIr?=
 =?utf-8?B?bno1REU5RllpMWgzdWo3U0FjdTl2c1hhSS9ab25WL3lnSXo3SzZ2K3VGM3I0?=
 =?utf-8?B?dWpWNUdPanJuYW00bE5nSkJ4ZElkMGozUVhHanRmcVlxYWEyN2NHcjNnVU9V?=
 =?utf-8?B?VmZpR3JnUEpYTGxvTGM5VmtYV1A5MUdVNzAxL3hFa3ExTmJZVGtJT2FqajRk?=
 =?utf-8?B?T3RKaE9zTlIxVXpCR245Wk5OdTYvdTVscEtPR1FXNjN3WXZCWjNxNXNRNzJy?=
 =?utf-8?B?T0ZteGM1Yll2MEJGc3I0eGNHbzY0Y3JSMllVZit3QzRsTnBGeEtUK2xEL2hL?=
 =?utf-8?B?MkNtK3RMM2J4RFF3R0JHRjBWdlFRYnFXSlpXQUhONXZLKzZjNktXeFc1Yzc1?=
 =?utf-8?B?NGVZTVh0dU9SeE1DWkZBc2c3WGhKcWdrZ3hVcWJvRTF2ZHFNcEZCbHRUNnJT?=
 =?utf-8?B?dGt4Y2xIbzUyMVlyK09KT3BZTTNWMStOb0xpUDZPRG1rUUNtT1c5UEJJMkNx?=
 =?utf-8?B?QVBEdndQYnpsNkpNMCtUN3lYaGpzRVBWL01MOFVkQ2l6dnBzOVNuNTlkUW5V?=
 =?utf-8?B?dWRIVkRESlhIUkJvazBLU1hCODJQcE83VEhSU1ZzcXF2aVFaeFFjQlBTdVQ0?=
 =?utf-8?B?MzZVcnZlNHNaUDNXRTZoQlBqVk1DOGxqdXlzc3oxWEYxc2p1czI1SXVwbjJP?=
 =?utf-8?B?bjR6NHhGV1FJZ0ZDUEt4SzQyWmdIbUIvWlRoYVIyV2tuYytQUjkxMlpaaTlV?=
 =?utf-8?B?Mkc0THJ3aTQ4RG5KTlBrRWVDdnlQb1ArRW9pOEhURWQrTTlYMXgyU1U4U2ZD?=
 =?utf-8?B?K1NxRE50bGwxUTZpVS9LQXhWTXRuNTd5VTNKRVN0cWhOOGZoTSsvVDhXRlh2?=
 =?utf-8?Q?5s/znVBYbffCtPHelxNUFSJ2Y?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ht8p7JwyPAmF5jqbmFKLvWlYlBQJsNrqTi0jojaoTfzdBgHgRHtLUF2dBb2abchvHj/qVnwPKxvCxGqtkmxGBk1ubXhrIoq3k/aVYX2mnenz+0eOzFxs0pQlRw/HRaCqSWTirK0ciI5DS6Z1iCTmDZcgM2Qtgz6SKbhIAuAjr6EM63SYg/MmJA+VWbgWRxW98rJAWmtwmR2RlwDhzp/101O6drMUaN2h7Y25Giichyla1aV90OfcOpR0VlNq1uQ1Fwf21sW31PDAnyMvPYuJ/FEGuYfZqu98fjhD+rcKzAsK05zqi+nG9vM7QIN82Bmvh1kHmIRt61ZDS6JEBu4PfHIsDGsn3KFYrzlcqMGjpyBPjJ6fOHS5TdIvls2bmfi5lRxm7u2D7xfF6E7GtLLQX24RLBQtgoYrcrLR1tIbRgXXHznk9Q/2I6lZKXFH1NDA8Zj8frF1hbaVlHRN/Bp6+EyuykiarQG4iWKN91CWdRtk0QjjROnwb1NwVQLIMfbRR+bDwW1qrhyeu+cMeA/Z/bCUVEYg4N5Exk13FO4w6GXMhNdGAiv8OWCXtQ5hJse8+DVMS6Rm1ntud0jF6RifUkg22TRO3c5ey5unqcx6fMU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8cfae44-9532-4e06-f94d-08dc4411f2af
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 10:31:45.9024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ysj5GjatAa7l+heCMNtQIg0/y5Jtm2q34aTfW+HJQic9zU2AlHIy4KVxucZeTCuQrRVPzePnxRi16H5R279lbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_08,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403140074
X-Proofpoint-GUID: KVekYsBLf8-kzhSwu-zyovbAGD9VF4WH
X-Proofpoint-ORIG-GUID: KVekYsBLf8-kzhSwu-zyovbAGD9VF4WH

On 07/03/2024 20:30, Bart Van Assche wrote:
> stop_qc_helper() is called while a spinlock is held. cancel_work_sync()
> may sleep. Sleeping in atomic sections is not allowed. Hence change the
> cancel_work_sync() call into a cancel_work() call.
> 
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Fixes: 1107c7b24ee3 ("scsi: scsi_debug: Dynamically allocate sdebug_queued_cmd")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_debug.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 36368c71221b..7a0b7402b715 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5648,7 +5648,7 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
>   	sdp->hostdata = NULL;
>   }
>   
> -/* Returns true if we require the queued memory to be freed by the caller. */
> +/* Returns true if the queued command memory should be freed by the caller. */
>   static bool stop_qc_helper(struct sdebug_defer *sd_dp,
>   			   enum sdeb_defer_type defer_t)
>   {
> @@ -5664,11 +5664,8 @@ static bool stop_qc_helper(struct sdebug_defer *sd_dp,
>   			return true;
>   		}
>   	} else if (defer_t == SDEB_DEFER_WQ) {
> -		/* Cancel if pending */
> -		if (cancel_work_sync(&sd_dp->ew.work))
> -			return true;
> -		/* Was not pending, so it must have run */
> -		return false;
> +		/* The caller must free qcmd if cancellation succeeds. */


We were relying on the work CB not running or runnable when we return 
from this function, and that is why there is cancel_work_sync() [which 
is obviously bad under a spinlock]

Otherwise, sdebug_q_cmd_wq_complete() -> sdebug_q_cmd_wq_complete() may 
be running and reference the scsi_cmnd - that should not be done, because...

Checking the comment on scsi_try_to_abort_cmd(), it reads:
" SUCCESS ... indicates that the LLDDs has cleared all references to 
that command"

So, if we change to cancel_work(), we really should ensure 
scsi_debug_abort() -> scsi_debug_abort_cmnd() returns FALSE/FAILED to 
upper layer for when cancel_work() returns false. Effectively the 
(!sqcp) check in scsi_debug_stop_cmnd() checks for already run or not 
even queued. However, we still need to consider when the WQ callback is 
running.

Cheers,
John

