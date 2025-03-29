Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2C78F5B;
	Sat, 29 Mar 2025 08:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743238287; cv=fail; b=Y5FrYkIjXBw0hmGEyh9XLjBBCsoCwd3QqJO/BYm5fr9r9fkf1OgtfNOgt8TpW/XZDtOawFPsv5geWZd0WgzN/DrTQQSDViL0Cj4dqRLXKN3ru0qRGtu6Vznjxk0QDREKqlEbKR6bkrAj12aNRzk3FeIwiKmd+SEoakLGNQT80y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743238287; c=relaxed/simple;
	bh=Vzyb6fZLA+CJK+UBCbyJtkP8eY8B04nTjSn20Xr36gY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mFYy6HbLG0mde1qvm9ngt8pbvNRbkVVOC/ikdIMG+dWeZOCw5vm0eXjS8UhojH9TB4/omesFuVNvcTL4TkOsP8979vyVbTN1wqx2n7yznQj3qaLFLAG/XDrrPDqH7Dp8dgXFULgOhL94+rJFb7PXHTdHyUHqTfzUUhTCsFPODMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KMuFGWIc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Nr7U6LIs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KMuFGWIc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Nr7U6LIs"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52T4hRm5018343;
	Sat, 29 Mar 2025 08:51:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JX2EtA1dIvbFcYJI0hcUZT8lGzejzTI9LAb8fb0qU8A=; b=
	KMuFGWIcs7B6QkS9DDS3Jgw77nHdZI3ATtDOj6GE7EEDYz8erOwB6+Xm4IZA6kR4
	l8wDvgbUsd4ALRMJpYrxB1v3cgxzqUqjrWtNsP1xkcVk1blagJ6YBWBNRXBeKHRV
	h6SczsZFf7MiYzwzQZoFweO8I8kaaT1V3GY1Ge+wczLKDXWn+/TDQWC9YpW9/S5H
	MfjzGoDMP2SKdxc8OXMxJl5H2Xdcljz31SPBjmq9R116CxSU7CshQXBkfWFhAZ1A
	5GNmyAHaYDJcWCowWGGHgjO5gMGSVoSVag+EA//BbU9Jmc+vI9mFnoWsI4IT7bTt
	t342u1uk4hcsH9qI2wtvrw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p79c070h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Mar 2025 08:51:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52T5FwZx032907;
	Sat, 29 Mar 2025 08:51:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a67u20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Mar 2025 08:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QjVJvl5CoeD5eTFeL7YmKYHOhcYW/tax0b2LZv0HJBzR8RDj8dUJsSWDrH1bADcvrmZs+4KkpA3ObUt6W93b1+GhvFsBthdTyw7zMXcNxH+KFgSOXFuytBMqCWP5Q25f6xHX4j4peOn8oP0X+wukSXsOyOkkoTx1Y5eatKkDwittRA10b+c1xNQnD1qfgaVgthBlaQVD85EAnjwlzfA8R/IBK7hCz/oFFI5WIlr66c8E3MGr4QpZXktb1JHXqRUIpKv8PHlaof/u3nd8KeDSsEnsfKYgCDUKjnPVxCWzRqyh398Z7c7RqzbxOhbsxxiKECtCrViX9Gt8Ka4Bb2sXaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JX2EtA1dIvbFcYJI0hcUZT8lGzejzTI9LAb8fb0qU8A=;
 b=DPqkCYw2J5xhdR02/ViNr6f4RdATcxhfC9OYWc+XfLEIMhqIMMi9nJu/4ZB4MlalQ1vyx192QXznQMfrwmPkOLtfLtC6whYnfKFOoqQ9ZIZqeeLzXoYFLqba27LcQ7/L6DfM4tlsOr/BYCBLZ3pf0avDSgA6mQdNX6SRvw1Av3arbpnrsRbb0q9yVUht0iegEMuyfWSY8KCBkHlG2mPmLEu7kKeMYJMfhoc5d+owLXCjxzSoVCrG+oyifctiIkZeU6P5NZIzzPvHegHMDasCJLmCUCmEEbHaXse1ds7I1ff4Xt2OAbNgxfgcKp080c0cNZky2UVWMqUoII0rgRGJ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JX2EtA1dIvbFcYJI0hcUZT8lGzejzTI9LAb8fb0qU8A=;
 b=Nr7U6LIsdLATeaHTR/Hzax6Zf6Pf0DAgGdq2JQsag905OMlSkYGDb7YohG4ati0Amau0MNSju2UKEBMKAiQ1+pnKYmgwHllyyon3kF6bJxizhtINW1gLVotb45kZ2erHH9dWCSMoq5fE9L6sdzg203c3S44SfU7zRCLChdQm630=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4640.namprd10.prod.outlook.com (2603:10b6:a03:2af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Sat, 29 Mar
 2025 08:51:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8583.030; Sat, 29 Mar 2025
 08:51:01 +0000
Message-ID: <f53505e6-9bfa-4553-91cc-497512a6977f@oracle.com>
Date: Sat, 29 Mar 2025 08:50:57 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] scsi: hisi_sas: Add host_tagset_enable module param
 for v3 hw
To: Yihang Li <liyihang9@huawei.com>, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, prime.zeng@hisilicon.com,
        "linux-ide@"@vger.kernel.org
References: <20250329073236.2300582-1-liyihang9@huawei.com>
 <20250329073236.2300582-2-liyihang9@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250329073236.2300582-2-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0069.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4640:EE_
X-MS-Office365-Filtering-Correlation-Id: a9f156f0-929b-4c30-ebd2-08dd6e9ed415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bTEvRFViVjFjSE1YU2Y2ekpvaS9BSnlIcVZsMVllcmRQTFJ4ZFcvcU43QUhS?=
 =?utf-8?B?U3dLYUM3OE5hNTlxTHgyMVhJY3F3R2hZSVB4M3lXNmZFT1huYlFuVFdiRlIx?=
 =?utf-8?B?NFJjN292cytoUmp4QmZMTE5aRVg3WGVMRTUrcW1veUVLT04xZWtBRzZjZG13?=
 =?utf-8?B?cVU0cnNhSS9ZWE0yZ3hpWmg2VHNSNzh0S3ZRVWxUWEFPVkt1VXhyRHROZyt0?=
 =?utf-8?B?U2d1TkZLT01yTmVYVGIwRlBrS0VhdXllc1hnSkFtRnhvdkRlMnZ6Y0MvUkZh?=
 =?utf-8?B?YStYVEJZamtUNDQySFlBejhKcVVmd3dHUTkvNlZMOU5IKzdzL0hML0NXTmlG?=
 =?utf-8?B?OWVnRXVzTGdXaEpqRzcyMVFzM2xFOUc5T1pTNVkyY3NVUzN3eEpFVVE1MXRz?=
 =?utf-8?B?OHlqUElDR3dWZEJpMktYYTNPOWdBTnU3OXJtZk9QZEJUbllLMW1EVTFqbzFx?=
 =?utf-8?B?SUpjNHk4b3o4bGxvei9sRnM0Z3V5MHZZdWUzVXVBYnd0MjM3VGJVOUtZaG1l?=
 =?utf-8?B?RUFFVnBFOWdKcUJjNXd5MlZ1YnBrWldFZUQvQnBMNkNNSzJ4aDdvcHdNUnZN?=
 =?utf-8?B?bXRJVjRneU5ySzFPK2UyOUVQLzNjaHc2SUNRQi9hN2R4UVhwTlpicnhpSERP?=
 =?utf-8?B?ZHNYRUJJTHRnM3IyQTRIZ2hzRDRVMFprMHFMU3NiYm9NcytQOTUzWExicjRO?=
 =?utf-8?B?WmdCL2w1VDkxd1lrVnpzLzBSeEZiNDNINCs0c0hPdTI4RlI0b1BNWGkwV2FL?=
 =?utf-8?B?dmU4N1BXenlTYk9CRTUyc2laQW1EK1BFb2swYWF0S1FnbHI2djd5UDJWQS9I?=
 =?utf-8?B?eTByRy96QUJwREVTOUNZZktPVExkQ0p5ZHlsd0NFeVBwOXBsSTlFUkJ6Q0lD?=
 =?utf-8?B?TmxlMXR1MXJzV3JIU3VQWFRtbWhldkdYU0Y3NEZHVGxEVWpXQ3JLcFdjbGln?=
 =?utf-8?B?OTFIVVpRanhqTFVUYW1rdVVGczZhT0pOWklSTGswdEg2cnkvYXVhR0ROSTZs?=
 =?utf-8?B?WU54V3lkWUp1UzRzd1lPc1V6NUhlNjE3Y1krNml5eFBxN1MxWkVxbExHVmo3?=
 =?utf-8?B?TVlQOStqTHhWSzhiaEJ2OFdXZXlwRktaK1NjRUdGL1JFQzFUMTllVzVJbTdy?=
 =?utf-8?B?NDFSRG5qWVRGR3NITi91NnNwWEkveWIxUUlxa1ZjU3JocjU3QW5QYnZYZ040?=
 =?utf-8?B?VzR4VFRjVmZwK1NQaUw5MlNHNHFyUHEzOS9hSU83VkxLZ3Z4aTFPazV6RkJK?=
 =?utf-8?B?ZC81M0hRbDg2bUc2Wk1od0EzWFkwUnczWnR1d0VmZ0ZvT0tsTUJDMHJSenZs?=
 =?utf-8?B?cFBlV2hVOEE2VUhkODVxRGJ5ajBldTRoOWVHZXI1MmVITG5ndDVxVHlkeUJP?=
 =?utf-8?B?S2VlTVgxTjRmNjNWaFhIcTVrT3F3V2EyYjNYdVJ3ZjM4NUFqMGF2V3ZlNXNV?=
 =?utf-8?B?UHpRU0sxSjFwK1paY0hqUFZTWTBqSHlKbzhvY2pUY3RQK0RiY1Jxc2Y3aGxR?=
 =?utf-8?B?OHN0WUUyMUk1ZGxBTEEzaXNPY1ZxNng5TmJDZCtab2lUK1paOVhMNUtVcTYy?=
 =?utf-8?B?L0J3N0YvZUVxNzR4Y2xhcm43bTJZaHNWK0UwMG1QcXpKQWpyZldqMXAxNjY4?=
 =?utf-8?B?ZFBFWmVUUjFRZGZEQkF3aEdSN2dpUEIzNFhXQ3pPQkY0NVdDcTB0WUYrcHFV?=
 =?utf-8?B?UWhlTmd4NlpmWnRhQ3p0NEVnY1NkMThDNFpvSFZnY1FtRERWMklORXd0M282?=
 =?utf-8?B?ZHdydld2TkNZR05zOGFKZEdrSnFkck03VXZYSWV5QTN5MkRXZ3BXMDZ0ZXBL?=
 =?utf-8?B?cDc2UTVqOTVZTm5xQ3hXbXZQR2ZRTjRHaVFBS1luWWFyTm5OQWhjM0czclhJ?=
 =?utf-8?Q?lPD4b0l1HH+lF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVVlK1BMSGM0ejRDSjE4eVBLalRmS3BQV2RkUkpETXhQM2NYaW9hZ0pBbm1x?=
 =?utf-8?B?cm42QnlDT0wzZm1RTm9aSEJXeUpXaFlTSmp0dkxGcHVNMFp3Ly9aQml5R1Zl?=
 =?utf-8?B?OFJwT2RLWUhiMDJTZjNUbUVnWGhRNHRjeXEzQ1U3RFdpUmhSMm94Z3p5bUY1?=
 =?utf-8?B?Z3o0UjZYZjFlMCtFKzJFekx1akpVWkVxRDV6dE1HbUNSQWVxS3M1UjJ0WTRD?=
 =?utf-8?B?YnZHbUdyZFBIcndTWnJXZ0VMQys4Yy9IMTdHMnJkVFNxZUExWUdzd1lHTVE4?=
 =?utf-8?B?QUVOUWtKY09vYWtaWW9Ca3hvdWtzVVZmRE9GV2NXVG1TVVIxRFZnekpUeitu?=
 =?utf-8?B?akhwc0ExVEFBRkkwaGsxcUg2RklLVnlIbENGSFkrOEhRWklDQ0l2ak9JZUdM?=
 =?utf-8?B?RTI2WVIrY1hyZm5oN0EvM2kyNGhrekxjd2VHTnRPMDlwSGJRK0lydDczRXRy?=
 =?utf-8?B?eWFZUU1FZ0wyT0ZPRXJJQlo4QjlDcnpzclBNYllUTnI5NVpGeGMyRmg2R2dv?=
 =?utf-8?B?K29sR0hYcUdTVTNEVVBsZmhScCsvQ0p1b2dyNmdpV0NDd2dZejRxUTBnSk1M?=
 =?utf-8?B?TzVvZnZxRnZoalpjVVN6dXNpRmFEbGJTd2NWam8xOFF6dk8xUVJGOE56Zmwv?=
 =?utf-8?B?RG0ySk1QbnZvaDc4UlhuZVFJTXBZcjJtK1Y3TmtLRlNDZVJodjhvdTcvT05h?=
 =?utf-8?B?OXRjYjl3cXY0Q2h0QWFBTFRvZXUzYjlMOFBaL3I3d0ZFMmxGbUptTW5SZzFx?=
 =?utf-8?B?RXhKdy9jL2Z6a1RENjVVNU8rMndYQWZmZTMxZElHMU1hdnNGdlovc0pqR3ZW?=
 =?utf-8?B?R05VUEU1cjlnWDlqczJiczAxUFZWUmpkRlhVQ3FYSlpXN0NsRnA0dUNrSGlK?=
 =?utf-8?B?cGdPcUlXNzc1aXI3QUtVWWNOZWF6OG15dS8zai9MNnQxNXFlaVVYRTBhaWph?=
 =?utf-8?B?ZHNESkJsL1E1REtLQWpKSTNVc2N3MklINmVzYVFaWmNJS0hXU2IrT2p3QmJj?=
 =?utf-8?B?M2VjL1VGcWM1REtzMmZnc2hKenRXTG00TDhLOG1BeExNNVNmQ0ZOR2J4eDNN?=
 =?utf-8?B?Wkk1eHE5TENySENNcGlFcGMyZktFR3dablNiK3FCdWM5dHJCc3FreDM1a0RI?=
 =?utf-8?B?VXAyc0pWVlBxMG5GMHhaSUdsZ0V3emNZQzY2MjlaSU5jdTYwdThRT0dmOFZN?=
 =?utf-8?B?ZVJwUE5jY255SkdRRlFHb2wrYWh3ZkZFaDNMWDlFR0dsTjdZdEZiVW83WFh1?=
 =?utf-8?B?TUE1YXVPbXBET2ZnY2EvY2c4S3doWVRhbDFIZGlhaC9GWWhIV2ZxRUkvVGhE?=
 =?utf-8?B?V3kvUi95RXJLay9GQzlhRHBsYlB4R2FOZDhBdG50YzBBbEZ5T3VVYWJoYTh6?=
 =?utf-8?B?Nzd5M016Q25FUFZIdG42cUczaXhJRkhza1I3aXNheTlUYm1HV2VPajc1dXFS?=
 =?utf-8?B?SS9HZUc3MnJ2YktFL01qWGx3N1JKa1B6bkV6WUdDL3BHL1JMMmZ2aHpnSlln?=
 =?utf-8?B?YU50SVV2UkE3Rndoanl6ci9TMHhMVTZacDZ2TVlRWmRETXdhOCtqN2hlR0FD?=
 =?utf-8?B?eTJxZlZwYzdBNGFlNEFlN1QvRUdOR1Bma1dNVGJLdXgvSXNzTlNuU3E4Ukxt?=
 =?utf-8?B?N1hXdlBXQW9lWldJWHpiYXQzQnk1OEsvL3lCRDNGZm1QSlNwZUtBNXhScVUw?=
 =?utf-8?B?ODViWGFQUmtXRzJmeEdFVW93LytITmErZ0ZHZ2RMMDd4czhmb1FOWGNFajhp?=
 =?utf-8?B?c2NwT3RxQUdyNjVHKzloQ0JUaWx3amJWU0lVekNKVHFhbFZmK2NOQWxnTjZD?=
 =?utf-8?B?V0tQNFQyWUlaMmhXUVNDbGtWRk5Cb254YU04SERzdFpOZVo4RC8wVzl2MTU2?=
 =?utf-8?B?VjNvQlRWN29KZ2FBekJDM2JjZnVwaWRJb0ozbSt5VDB3SEl3TGs0b1N6Slpm?=
 =?utf-8?B?bXViRVJCSytsQ1puNVRhTUs3aU1EaURGT0V6ejc3RzZRVXdpam5lTDRMSVlK?=
 =?utf-8?B?bEZ3WFZEellCQzQ1UEsrV0REZ1hNYjZlcFFNWVdJc0lCZ2R4Smk4Mm9Rd1Yz?=
 =?utf-8?B?M2VlTytMUmpNWTQ1UEw2RzRCL2UvZmpZUDRCSHorL0pmbitrLy9VTlIrRjhG?=
 =?utf-8?B?RFBkWk51S0owRGN4YTJZbitzRVB1Q2pKekxXUHB5UEJYR3ZRRHc0a1c1WHRN?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uyhixa8Wb7CypHCVuaHjwxp7ltpHoHlvAZsijfYAOAwfzSsbkMX7jsaYcxYNP51wGIoEkL17bsAYtEKDVg9S9Fihw8nehel3KkfOpiSpAOoT2yZdAyc88Jf6wFkpEO8mN7F3egSQr7q8bLmI0I88IaUktzj+WoARcIz9SYNZ91d1AP06OV8ewLVYFjsohQov/JYhDNsfVl3w3fOrvD5ONPSLC/kjdhmKe4+pmpb1PrxtwqoGeUl+ioEAK78lSt2PW0WcLg0krFL3GEz/PPVH7qRFxhphgWlYMZRtjVBVjKMXo1paVuIA4d6bbFpWa5fPvmU1/lZ4dz4UkpsOKraRK4PubvZq6yIc4AU31noR6Vf7BEw4Hr9AYABMv4yZltAmUcFIec+RrABW+uERksHjDQ16aYyBvT3haRIYjwc4HgUou/lLRoUH+TrE5k76M1EKceuuw0fSmN+EThfIUFUqyueFve7d8WyHXui51fbzAPRji5oG5ifgu0zRORY3Ydc9KYv2EI0lRsKUFfiOqkBWhntx/X5J59mQtxGhifjKsJutO1U49lyrpaNhrmVYCTTuKnGSVcr6rRuTE0m0GbB3Yt1PRu3hqlnM1SZcSaJdAIQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f156f0-929b-4c30-ebd2-08dd6e9ed415
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2025 08:51:01.1564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKrGgJCvq5HNHCUXhaKB6WiFMusegp5gAEVWW3HsXknsHG1P3DYlQ+gO+hNFDEO9cSGg4i5NcC4ah4wBEgeUww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4640
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-29_01,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503290061
X-Proofpoint-GUID: WO-8J9x91MD8D0YHRKdPCwtWOjCJcczi
X-Proofpoint-ORIG-GUID: WO-8J9x91MD8D0YHRKdPCwtWOjCJcczi

On 29/03/2025 07:32, Yihang Li wrote:

+

> From: Xingui Yang<yangxingui@huawei.com>
> 
> After driver exposes all HW queues and application submits IO to multiple
> queues in parallel, if NCQ and non-NCQ commands are mixed to sata disk,
> ata_qc_defer() causes non-NCQ commands to be requeued and possibly repeated
> forever.

I don't think that it is a good idea to mask out bugs with module 
parameters.

Was this the same libata/libsas issue reported some time ago?

> Add host_tagset_enable module parameter to expose multiple queues
> for v3 hw.
> 
> Signed-off-by: Xingui Yang<yangxingui@huawei.com>
> Signed-off-by: Yihang Li<liyihang9@huawei.com>

