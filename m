Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1710D3043C7;
	Mon,  1 Dec 2025 11:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764587176; cv=fail; b=rp6LeJZZTeJnu2fj51EfyJXRiTVd8DoSe5seoqUGzy52vAx6sRtKglQJ5irVQtY8Z8RdfXBI7vRtwwy7sxsey6RMhC5g6d6Qq/07OsJ0QvmYhPYn2BAbPRBDBIpwRx/MWdnhaaPKLvMUHLm/HZcWCGcHkaiQRBuoVh477i28jrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764587176; c=relaxed/simple;
	bh=15Hfys9kPunTzONYWY+k8bnjGwUqWSox69vcJUq75J8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UhhZMgEeob+JberCUrHN8VF35WRleJ1F9GvFRUBJAl+/zKn+KoL6Ld9cQEkqheUR9/JDyWQ/pna8Y33dKQ5Bvjus5tlMKFg0hur/QYVU8/ILh9xB9ibX4kRRrh2Ds1uU02zwP7QE47MNYhP99cQeWmG47zKOHHMDir7m897XyTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dh0+Nxnd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z6QlHl6K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dh0+Nxnd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z6QlHl6K"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B18NMVo1525939;
	Mon, 1 Dec 2025 11:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=u5COGB6iDnLSxBs++mXepS16jebre5M9pI1ipeHtR3A=; b=
	Dh0+NxndnGqxDctvWDO6WjHvYVxwBv4MpiRNSNzCzVy9nhbMoXTXYdWc7Zh9Wl+6
	WJHc7y/leVE0ATV73kgDlKeJj7bNSyNyXyhM5msKrz/J5c8li2BMw2Kaeof0G+WC
	nKiS5p3m8UoALbeHDmFYgS0wa9+3jcJUNSRJn61X3deJnXnapX0L3M1KrunREIQZ
	mA1yMK+vVwR9jvtTJ/a0T2BMHZAJHgziyjywH+kOhObVHdgxFUUaxwtpsVS72tEf
	vADV6JTS7Ae8MTSHu2Yb5Ef/VQRaFG2FgkyyYCBJ9H4VPt4r1e19JlMgRz0viCi1
	b3JdmZXnFaCaec/UkY8oRw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7f2095h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 11:06:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B19kG2n017595;
	Mon, 1 Dec 2025 11:06:12 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9hvjny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 11:06:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bNWy3rMYlEOPPm4vRDIJ5sHSBLjsYBLR1wTXrao0PxIZlvG+BVxk47tq24qpmMv8IVdVv4gI33rWvunVUYANJmKAWJPX17FpKLCJj6bAGMRX5fUPgrE4Ul8AvfLOkExdKsWErIY2YslCSTLJ33cS71ReyEq994T8bosARebTVZ+2jRJ0PGWpVo0f3M3IuCf2302Kxr4PHAzfzC1OTpEJBEhdx+LUrVHOK0C7rhVqZHp376MHFNcFXT4b5WD7uL1AjsZ/20naG5iumnDVYn6p//Xq4H+OV51UvHUPnRu63Qjz6SNJxWJZNRwo+5TGe/OESZXc23VLlDwPc3COgZwHrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5COGB6iDnLSxBs++mXepS16jebre5M9pI1ipeHtR3A=;
 b=vJm68J7pv/KH7UjKesb6q/OD3jVH9Mqac5j2XZby61VdOtYcWmFPXsH43nB7OVAagutPaDS6gYjmuy33AGcc18Y1DS5zwJEKooTV2Z0jgBGZbWREEF61IsGcKJJYq6TNR/j8aT8Nik3z3OuNlbHqezzmTKzsa+B3yts+XkTO1pZ2A3TiOR48Kmmt8QDcPQfBEo0cMCliZD4FrkcQj569YM/zuChJT9/mFro4cFv+MadUIcNgkjvP0XgsBfiqbqYNBIvmQ9rpG1OoilZXe4aq1EBfFufQ58uzttvKZXtJrltYqfO3w/aelT79r4OzpSGwgjbrMXBxVv/s3CQpTs7+nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5COGB6iDnLSxBs++mXepS16jebre5M9pI1ipeHtR3A=;
 b=z6QlHl6KnygK+JPtNZoJ0kZA3Y89UvguXT/uzq6ZSd+rhj9RvC4u7TqIYvuXYo1Fyhy4TwcI+YiDGMCzPKxZx3FXigcuwV5UqDvQuxulzmfElnrN2GOUn71h9MazYNQ1+PtBknFz39nfx/X7OCLfLWw2CE4P/GMyhiTLfV0xU54=
Received: from IA1PR10MB7240.namprd10.prod.outlook.com (2603:10b6:208:3f5::9)
 by LV3PR10MB8059.namprd10.prod.outlook.com (2603:10b6:408:290::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 11:06:09 +0000
Received: from IA1PR10MB7240.namprd10.prod.outlook.com
 ([fe80::6ac8:536a:b517:9364]) by IA1PR10MB7240.namprd10.prod.outlook.com
 ([fe80::6ac8:536a:b517:9364%3]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 11:06:08 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: John Garry <john.g.garry@oracle.com>,
        Martin Petersen
	<martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>
Subject: RE: [PATCH V2 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFYING_INFORMATION
Thread-Topic: [PATCH V2 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFYING_INFORMATION
Thread-Index: AQHcX5HaAVhzN6Fx00uKNUEChPPfLbUGeMkAgAYsmgA=
Date: Mon, 1 Dec 2025 11:06:08 +0000
Message-ID:
 <IA1PR10MB72407349AD07BA6FED67C87998DBA@IA1PR10MB7240.namprd10.prod.outlook.com>
References: <20251127113448.17526-1-gulam.mohamed@oracle.com>
 <e6d503fb-a99b-473a-b6fa-5ca3b02b9c86@oracle.com>
In-Reply-To: <e6d503fb-a99b-473a-b6fa-5ca3b02b9c86@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Enabled=True;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_SiteId=4e2c6054-71cb-48f1-bd6c-3a9705aca71b;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_SetDate=2025-12-01T11:04:29.0000000Z;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Name=ORCL-Internal;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_ContentBits=3;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR10MB7240:EE_|LV3PR10MB8059:EE_
x-ms-office365-filtering-correlation-id: 0d322454-32e0-4e71-4f5e-08de30c9a13a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?Z1NXa0poTTN3NEFNeVZOVnNqYlhTMC96SThZcGxLOUFZQS9zU3B2Z1dGMTUv?=
 =?utf-7?B?ZHp1Z29wTVpaVkVzWmw1Q1JpWG1heWhUYm1xM2hyTDFiSC9QVnMwTHRadEMy?=
 =?utf-7?B?ZGlPSEtEeUZoc20wc0QyNmN6TDR2cSstTCstN1lQcmJlaDZiYlFGazBvaHdz?=
 =?utf-7?B?azY2ZHdpOUVkKy1PVXB3VXNLWUVjZnVDakd5SkFleHJ4SkRPWkFBQmlSNE83?=
 =?utf-7?B?VjRkQzRDQm1YdmJDL3FNb3pCUFpXcHh4alY0S3NCYjBhTkFYc1NVN2xYYXVM?=
 =?utf-7?B?MDd4bGI3Q1ZhRkp5cE1GWWs4TW5YaXFLWjZzYzl5Ny9majV6TnhCU3hwbmZT?=
 =?utf-7?B?V0tMa1czcystVHpRd3dqdTZmMFZ1YlRxYmtFdG1CMEpnTjBOd1kva3NNQzY4?=
 =?utf-7?B?SUFrakFBYXl5V1M2aGZUeFUwR3ZvRzVWVkVsTW1Mb3VEZ0JFWkcydFA1em12?=
 =?utf-7?B?NFBNbXptYjhMd3ZUN2JGSUY1d1FsWjJFZmJ4dlE4RkQ4QUlNMllSd0ZWTlJE?=
 =?utf-7?B?TXZtdFh3YzJuMmtTTnQ0SXpvTTlRKy1GS0R6S0haQTJBNC9NS2NuWDRod245?=
 =?utf-7?B?WUJKaCstNEhwa09CMFdmNVNyYWZta1NoS0dQU24vTHlCU0NaVCsteE0yQURy?=
 =?utf-7?B?c2lqdkxWcXlEdWxwam9XdWlaLzNGZ0xEVXNIZE9oTklRd2VSbjRFWFI4YUFs?=
 =?utf-7?B?Uy83OG5uVmlxMzRjTVFTOGsrLVVRaHBxWGVRYy90bjN4U3IrLXoyb094TTQw?=
 =?utf-7?B?YTg5T2kwRHJ3c0RUUGtKWGtYb2Z4enlMTGk1QlVpdVNUQTcvNElaeTAzWVht?=
 =?utf-7?B?cXhNVWdvRk5hY2s4SkpVZmRQTDE5aGJHWCstQWlXdy84dXRjbFpScFR1TGhv?=
 =?utf-7?B?di9ycVFaNGxaTjlkZ3VzV1E5RThlaE5GYXd2SUZBd1J3cENVNkpBanRUL0ZQ?=
 =?utf-7?B?cU5XNystWGZzOXVBaG43TGY2dGpueDZ1STlwVlZGYlRIVUJ3eW0xcGpoTjlI?=
 =?utf-7?B?NWpZRjdYN08rLXNZRVY1Rmw5UystR01oaHh5MThSWldiZHFxVS92NW51YnVZ?=
 =?utf-7?B?TDVGU1RoY3VOUlJDYzFPaXdIKy1rRjBjbHZhUSstalkzbHdlSHl6MjA3RUxv?=
 =?utf-7?B?NlF2S1FhYk1KN1h0R0FVL1RTd2JoZk1tcXJnM2VYbCstYlN6WXFJN2x2USst?=
 =?utf-7?B?aHRFR2hVdFZqdjAvOE1WZDNVanJlNFlWSGpMbnF6WjlkZHVLS3dhUW4xU0Nq?=
 =?utf-7?B?WHlDOFhSUlJkaEFKM2ROL3JLKy1BdEZacDZKZ0k2ZU51Ky01R1V1TDJBTWJx?=
 =?utf-7?B?U05jTXU2SjIzdndqMmtFcTZxbFpuOXFudHhPMlA3ZHNEMWFhdnVRMDl1L0Uy?=
 =?utf-7?B?NWpUS2ZWTzJ1RTVaTURpMmhidDFRNXljNnFJNHdYdlRPNXlWdkRZVFpvdWhS?=
 =?utf-7?B?Vmt2ZGVBV3A1Ky1KWnRqYW90bVUxOXNSOVNxTGdHa3hiR2NveEptbk9HOXp2?=
 =?utf-7?B?ZncvV3d1emt1RlM1RkRUNDNOMnRuNTZDRTM0Y2duYW5FQWFROUJhaDBLdDV4?=
 =?utf-7?B?M3ZzZklKV2ZPcTg3Ky1xSUtnQ2p0ekhLaSstbzRLYUdVUFAyc3RKaFpjWjhW?=
 =?utf-7?B?V3Z6STFTdDd6N0krLVk1NzgzNEU3VWNWdWQ2UmRuZjdCQ0dqTkpOYkNoNXJ3?=
 =?utf-7?B?d1JhSWZUMWFGaVpqcGgyY3ZYZ0toNUpCVldvQnUvRHRaS21tWWMvMUFvSFlp?=
 =?utf-7?B?UFo2RHhlSVVVTDZlb0JDak51czZrRystRDN4STZLZjlVMFNYMVgvaystZE5w?=
 =?utf-7?B?U3M2dFFrNEs0RE8zL2IwVHEyYW9pWnlqUU1zNEJQZU1ybU9FQVJIR3p3a1BW?=
 =?utf-7?B?RFFsKy0weEw2UGZNS1BDUGI2TzUvcnlvRlpvd2xMQmxZOW04dVdtMk9NSnd1?=
 =?utf-7?B?V215RWcxTXN2WHNXa1RZTVFqcWU5WjRPS3BUZGFLT1VJLzVRSjNOV3dQcG16?=
 =?utf-7?B?NHFSeUI5WjFvbndReEduZWhXbHhWUHlFMFFuUWZ5MEQ5MzU4YVRsS3lsWERZ?=
 =?utf-7?B?QW1ZckI3a09uMVE3VWpGRlVKUFF0SXpEbVRmakg4S0w=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB7240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?Q0JSQlJJZ3FSWjhlNkhpYldxVnJLVlpLSFBVdk9wRmFJQlUyUjlyZXcxMHRr?=
 =?utf-7?B?TEYxdGlGbmc2aXYrLUcvdXJURVRCdDhib2xmKy1pYXVDWlV3V2dLeHg2L1B4?=
 =?utf-7?B?UE5VKy1qalc2MkttUmRlUU1DZGhZR3c3cWZqbUUyeWZ3ZTVyejVPTVVnYnA3?=
 =?utf-7?B?YnZvWktWM1pjVTNzYTB3Z0tNVWJWN2pyalZ2T3czcHJ0TXc5aTEzL0VVYXJa?=
 =?utf-7?B?QTdDOTVQRmsvYlpFUk5kUEV2S0hib3ZPR2lUbTMxNlp3TG5scXZGNy92dWo2?=
 =?utf-7?B?eXUrLU42bFRQTlJCdmlGYVdaVnRndDkyc3lTL3pOcXlEem85VnpXSlpVeUFt?=
 =?utf-7?B?ZFRFRG55SEM2aHc1QmNHeU9LKy1LazlvblcrLXMvNGkyZlhrQlZoTlJHN2E4?=
 =?utf-7?B?RUMrLVVQZWFQcjdabnFHRUNiNFNiWjYxQTVUdnY2TjhSb3JOeUQ2ZFE3VDlI?=
 =?utf-7?B?UUdjQWIxL09UV24rLVR0L1I4aG1ROVFkdVhveUx4cDBaMDdaTjcwTnVoMWx4?=
 =?utf-7?B?RTJHTGFYMzdHZE51dC8vZWJ5dTJISVZTZ09Hbkhkb2MzRDJDdmpQeXozdXRv?=
 =?utf-7?B?RWtRdnczaFJPdUFJQzgrLWlneXBWMmoyVTVlaTlGa3d6ZjJUZUNwKy10V1ln?=
 =?utf-7?B?L3lMZGRxWDRBckpRV1BrUEl4ZTBrcDFmKy1ZVXhhVEJBeGJiVSstS0xrRkhR?=
 =?utf-7?B?WEswUHZleUp5YlNmUW9iNktrT0QvRjNBKy0rLTBXNG1PaWlHSUtuRWU1cHpn?=
 =?utf-7?B?VXhva0d4UEhISzlJMTRSNVJST2dTOUo2VzNyeVB4RHhwNmtFRXptdXJORWhB?=
 =?utf-7?B?Z2VXUkJLQ08xM1JMUkVQMXhzQXhGeEQ5eFpvaThWL2lqZ2U3NHZYVHVZYks2?=
 =?utf-7?B?SkZsbjNCaG9yYXk0ZEtTcnlxYmRzSElJRHpFUjdMd29uY1VRaHBNdjZtOHJ6?=
 =?utf-7?B?OW4yWjFqTGtOVDNCV1dEZndoQ2dabDBaaTFmanNObnhjVVh6S1RTNW45WUJn?=
 =?utf-7?B?RDVPMVZTZzhZOW4xYmUyWkcyL01FcHBGNlFoZGd4R1ozZmlnWlplRldINnUz?=
 =?utf-7?B?Ky05ZDF6WHBZZFdEOWNFT0dkOTdyc1FMR1hQOTZRWnZYMktoQ3kvdFk3NWJr?=
 =?utf-7?B?WUdJSGhtbjZQaGJkWGRrV3pieURxQ2xWaXpkQWliTkQ0a1BMaXpzL1k3bGVE?=
 =?utf-7?B?Q3JYU3Njb2J1MWlGRm1WT041ZkJzQTdhZ1lXOVdBc3NiKy1lRHE1Ky1qNVBp?=
 =?utf-7?B?UUxhb2RIWDUyRElxQUNWTXAxalRZNUR3TTUrLUtSSmRDTDRhNEFIbUh1Y2s=?=
 =?utf-7?B?Ky11TFhLV1oyb2F1ci82VzBSaFI1a0pFck80Q2lUVVJWNm9qZDRaZXFwR0kv?=
 =?utf-7?B?R1RIbWQwMWY3VWJSTk9NRkZ1NmdNR1M1VlBOTmRuLzhuMXdZbHhNd2p3SDlj?=
 =?utf-7?B?WjNERFZlN0FETjJldXliRWR0L0tqQ0d2aXlaMmNlWllJY3J6ZFA0Z1RnYTlX?=
 =?utf-7?B?QzZwdU1YcjBoMHpuT2hBWXJDeGprV2pRQUxYSVBBeFE5RXBVWUhjZ1l3Rzlu?=
 =?utf-7?B?M3RpaE9FcEJJbGNpSkF4bnpHdG9wdSstOXlHbmM1eWlIbEdIRjFhQXB0dlRS?=
 =?utf-7?B?Z2lFOXZ5Qzh0bTRITHg5eThVelZ1OFN6U3UzRzRiR21WUTdLQWN5eGVHbjJa?=
 =?utf-7?B?YVFvbE4xTSstYWlnZmwvSmRzMlBPUkc3aDczTEpLWlVIWjRxazF2MkMxUDBC?=
 =?utf-7?B?cWhKWHNCRlRhWDBxMmt5VzhvREduNk90Tmo4bk9VTVVwMmZjbnJkN0tnN1Vx?=
 =?utf-7?B?cVZpRVcxT28wcldQay9Tb21iakp4OEo4Q0JEWUl4S2h4bk0zUm5oem0vSGN2?=
 =?utf-7?B?amFGOFViKy1kM2pJTTk4WVU3OS9pMjJPM1QyUDB6QXFONGloMWthNlRjUnRj?=
 =?utf-7?B?NmxYZGJCODg3cHJqVW9FdjJxV2h3dktvd3NJWDVWL3lCbkhpWjg2MXo0UE8v?=
 =?utf-7?B?QjczbzdkWjZqdm9CZU5WRzBDTGpCYkQ4eUVNOVA1UXg4OGxYSGxMcXVVdzE5?=
 =?utf-7?B?Ky16M2V0VHpsNTROL0hLcHFXbzB3aWptVE0rLWNhSHJHWTFNc0xxTU9Pc0V1?=
 =?utf-7?B?L1d1a1hBZUpBT3lpM1FHNUdqbS9aVW5BVGtBTSstRzBNcWkzUUNBdldhSXFC?=
 =?utf-7?B?dVE5MXdP?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MMxB+MXvtn7yMKYcS9PiTolzKMHBpDZrH1DB3pFl0EWRXdnzWp0kkGMx9JBXdhuLMmrR8M7DvphiZM7YZgKhsi+ozxIPTReAj29lbgbMS04aYdjZMomK3uDIEyVeBN4Ls9fdqroIYxayMal4Lapr0xAV03kAPoF8Qe+zFchXsnOPrvgiaZI2GBJVM3C4i93hn9u/DtP7S54Nu3UNP8WL//7xg2dKLUvCy2PGpyVBVy11vvWLkLtaU6bkoPD01i2JEbHpQl7AudWb8YrAjiuZEbvfHKBzyb3LTwrmrpT3jTyaBgQ4WA+2SG/I2784nHNOlxrnquk3KX3K/vv6llZhIo4EmU5ZzElWHanKXmdhqN0QqJuE5dSk6sW4QoTczu0u09D2IypSoLUJxFilxEiQzb9t5nsT10v90ixMNtYdUfK8yJSsGxrL2huV/6bmrPSi4nIYeQ4cFbKPjNHqlOu1Emuip41YI6R07zxynd/98055TauO0wKzpdx2lmOTP+VW4074y91p/393hoWHHkYF1DS77WzKo+44KMqntsFcozHPE7Z3pyGi70yodN623TG+4FpljpSf3LVVrcnNS3y9EfSXpTIOu70vQsh+nkXyPFI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB7240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d322454-32e0-4e71-4f5e-08de30c9a13a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 11:06:08.4189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tajDE0LKdH7E1L1KblaAgVRLh2zWaf+d3dUbWACV4kDQiHsGnRLF2W/Ly3gePRx6XeZN3yY028/YR2tRwKOEzYXVMsSoji11JH1JdV6tPNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010089
X-Authority-Analysis: v=2.4 cv=QMplhwLL c=1 sm=1 tr=0 ts=692d76a5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wzW8d0FwaosA:10 a=YU3QZWNX-B8A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=DunTZruMAAAA:8 a=mQvHCebiAAAA:8 a=jrgxHc1zxpd_y7SDqvkA:9 a=avxi3fN6y70A:10
 a=hULGt_N_ZHD3gPdQZC9H:22 a=wsrb8zZI_WQ3QAEBCXTy:22 cc=ntf awl=host:13642
X-Proofpoint-ORIG-GUID: eRKQn23C6UigtyinQ0DQWq7CBYjZm_e-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDA5MCBTYWx0ZWRfX2t0wvxLFljk+
 pUhni7VBc0u5UG12Sjf/ZD16RcPDi/KFZU6JpEmvCTggzbEbMeXWbvHwrGNMYZiTmNS4v9JqQH9
 MYwxClqmeFfaCYBUfvbQ4qzpSoXyNAQqw9e51w8UX4A8cXwBroGT1CG/4pexPCoxCym6I7OKQtU
 +mPGjQBph685sehUs0LIGQVXCsO6OZybtzCtPYj1w6cMGbJYPpIc9Yr53f7yBAn4WYsUcKCPqNI
 MY6yHnT9/VAoY604BV/bN/zmNBXK9xoqyJlk3/Csa4zeR3JQDmwLYXZG1R2skp9G/uojc7u51JC
 1P8L/Ifk88pWrDDcaPUHxASAHcogyxT2IwqueGhY2wVYufACiGvG6LHYFH/ku4R1/g83WPAx6Ab
 jWxH1SzIuWWsQEd3ayeyX4K49CJQ/BVsePO5WWXlhpeuMA4PUxs=
X-Proofpoint-GUID: eRKQn23C6UigtyinQ0DQWq7CBYjZm_e-

Hi John,


Confidential- Oracle Internal
+AD4- -----Original Message-----
+AD4- From: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4-
+AD4- Sent: Thursday, November 27, 2025 6:17 PM
+AD4- To: Gulam Mohamed +ADw-gulam.mohamed+AEA-oracle.com+AD4AOw- Martin Pe=
tersen
+AD4- +ADw-martin.petersen+AEA-oracle.com+AD4AOw- linux-scsi+AEA-vger.kerne=
l.org+ADs- target-
+AD4- devel+AEA-vger.kernel.org
+AD4- Subject: Re: +AFs-PATCH V2 6.19/scsi-queue+AF0- scsi: target: core: A=
dd emulation for
+AD4- REPORT+AF8-IDENTIFYING+AF8-INFORMATION
+AD4-
+AD4- On 27/11/2025 11:34, Gulam Mohamed wrote:
+AD4- +AD4- Add the emulation for REPORT+AF8-IDENTIFYING+AF8-INFORMATION co=
mmand
+AD4- using the
+AD4- +AD4- configfs file pd+AF8-text+AF8-id+AF8-info in target core module=
. The configfs file
+AD4- +AD4- is created in /sys/kernel/config/target/core/+ADw-backend type+=
AD4-/
+AD4- +AD4- +ADw-backing+AF8-store+AF8-name+AD4-/wwn/. The user can set the=
 peripheral device text
+AD4- +AD4- identification string to the file pd+AF8-text+AF8-id+AF8-info. =
An emulation
+AD4- +AD4- function +ACI-spc+AF8-emulate+AF8-report+AF8-id+AF8-info()+ACI-=
 is defined in
+AD4- +AD4- target+AF8-core+AF8-spc.c which returns the device text id when=
ever the user
+AD4- requests the same.
+AD4- +AD4-
+AD4- +AD4- The details of the REPORT+AF8-IDENTIFYING+AF8-INFORMATION comma=
nd is
+AD4- mentioned
+AD4- +AD4- in the section 6.32 of spc4r37 specification document of SCSI P=
rimary
+AD4- +AD4- Commands.
+AD4- +AD4-
+AD4- +AD4- Signed-off-by: Gulam Mohamed +ADw-gulam.mohamed+AEA-oracle.com+=
AD4-
+AD4-
+AD4- Apart from some nitpicking:
+AD4- Reviewed-by: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4-
+AD4-
Thanks for the review.
+AD4- +AD4- ---
+AD4- +AD4- Changes in V2:
+AD4- +AD4-     1. Corrected the command name to
+AD4- REPORT+AF8-IDENTIFYING+AF8-INFORMATION
+AD4- +AD4-     2. Included the spec reference to the command
+AD4- +AD4-     3. In function target+AF8-wwn+AF8-pd+AF8-text+AF8-id+AF8-in=
fo+AF8-store, return early if
+AD4- +AD4-        the string is too short
+AD4- +AD4-     4. Check the export count before string correctness in
+AD4- +AD4-        the function target+AF8-wwn+AF8-pd+AF8-text+AF8-id+AF8-i=
nfo+AF8-store
+AD4- +AD4-     5. Fixed strings in single line for print statements
+AD4- +AD4-     6. In function spc+AF8-fill+AF8-pd+AF8-text+AF8-id+AF8-info=
, return error when
+AD4- +AD4-        transport+AF8-kmap+AF8-data+AF8-sg fails to map the comm=
and data
+AD4- +AD4- Link to V1:
+AD4- +AD4- https://lore.kernel.org/all/20251026191309.34968-1-
+AD4- gulam.mohamed+AEA-oracl
+AD4- +AD4- e.com/
+AD4- +AD4- ---
+AD4- +AD4-   drivers/target/target+AF8-core+AF8-configfs.c +AHw- 50 +-+-+-=
+-+-+-+-+-+-+-+-+-+-+-+-+-
+AD4- +AD4-   drivers/target/target+AF8-core+AF8-spc.c      +AHw- 86 +-+-+-=
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
+AD4- +AD4-   include/target/target+AF8-core+AF8-base.h     +AHw-  4 +-+-
+AD4- +AD4-   3 files changed, 140 insertions(+-)
+AD4- +AD4-
+AD4- +AD4- diff --git a/drivers/target/target+AF8-core+AF8-configfs.c
+AD4- +AD4- b/drivers/target/target+AF8-core+AF8-configfs.c
+AD4- +AD4- index 77da1fc82b8d..c2855f4048cc 100644
+AD4- +AD4- --- a/drivers/target/target+AF8-core+AF8-configfs.c
+AD4- +AD4- +-+-+- b/drivers/target/target+AF8-core+AF8-configfs.c
+AD4- +AD4- +AEAAQA- -1741,6 +-1741,54 +AEAAQA- static ssize+AF8-t
+AD4- target+AF8-wwn+AF8-vpd+AF8-protocol+AF8-identifier+AF8-show(struct co=
nfig+AF8-item +ACo-item,
+AD4- +AD4-     return len+ADs-
+AD4- +AD4-   +AH0-
+AD4- +AD4-
+AD4- +AD4- +-static ssize+AF8-t target+AF8-wwn+AF8-pd+AF8-text+AF8-id+AF8-=
info+AF8-show(struct config+AF8-item +ACo-item,
+AD4- +AD4- +-           char +ACo-page)
+AD4- +AD4- +-+AHs-
+AD4- +AD4- +-   return sprintf(page, +ACIAJQ-s+AFw-n+ACI-, +ACY-to+AF8-t10=
+AF8-wwn(item)-
+AD4- +AD4-pd+AF8-text+AF8-id+AF8-info+AFs-0+AF0-)+ADs-
+AD4-
+AD4- I think that we should use sysfs+AF8-emit() these days, no?
Yes, used sysfs+AF8-emit() in the new version.
+AD4-
+AD4- +AD4- +-+AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-static ssize+AF8-t target+AF8-wwn+AF8-pd+AF8-text+AF8-id+AF8-=
info+AF8-store(struct config+AF8-item +ACo-item,
+AD4- +AD4- +-           const char +ACo-page, size+AF8-t count)
+AD4- +AD4- +-+AHs-
+AD4- +AD4- +-   struct t10+AF8-wwn +ACo-t10+AF8-wwn +AD0- to+AF8-t10+AF8-w=
wn(item)+ADs-
+AD4- +AD4- +-   struct se+AF8-device +ACo-dev +AD0- t10+AF8-wwn-+AD4-t10+A=
F8-dev+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   /+ACo- +-2 to allow for a trailing (stripped) '+AFw-n' and=
 null-terminator +ACo-/
+AD4- +AD4- +-   unsigned char buf+AFs-PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN =
+- 2+AF0AOw-
+AD4- +AD4- +-   char +ACo-stripped +AD0- NULL+ADs-
+AD4-
+AD4- nit: this does not need to be initialized
Done.
+AD4-
+AD4- +AD4- +-
+AD4- +AD4- +-   /+ACo-
+AD4- +AD4- +-    +ACo- Check to see if any active exports exist.  If they =
do exist, fail
+AD4- +AD4- +-    +ACo- here as changing this information on the fly (under=
neath the
+AD4- +AD4- +-    +ACo- initiator side OS dependent multipath code) could c=
ause negative
+AD4- +AD4- +-    +ACo- effects.
+AD4- +AD4- +-    +ACo-/
+AD4- +AD4- +-   if (dev-+AD4-export+AF8-count) +AHs-
+AD4- +AD4- +-           pr+AF8-err(+ACI-Unable to set the peripheral devic=
e text id info while
+AD4- active +ACU-d exports exist+AFw-n+ACI-,
+AD4- +AD4- +-                   dev-+AD4-export+AF8-count)+ADs-
+AD4- +AD4- +-           return -EINVAL+ADs-
+AD4- +AD4- +-   +AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-   if (strscpy(buf, page, sizeof(buf)) +ADw- 0)
+AD4- +AD4- +-           return -EOVERFLOW+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   /+ACo- Strip any newline added from userspace. +ACo-/
+AD4- +AD4- +-   stripped +AD0- strstrip(buf)+ADs-
+AD4- +AD4- +-   if (strlen(stripped) +AD4APQ- PD+AF8-TEXT+AF8-ID+AF8-INFO+=
AF8-LEN) +AHs-
+AD4- +AD4- +-           pr+AF8-err(+ACI-Emulated peripheral device text id=
 info exceeds
+AD4- PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN: +ACI- +AF8AXw-stringify(PD+AF8-T=
EXT+AF8-ID+AF8-INFO+AF8-LEN +ACIAXA-n+ACI-))+ADs-
+AD4- +AD4- +-           return -EOVERFLOW+ADs-
+AD4- +AD4- +-   +AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-   BUILD+AF8-BUG+AF8-ON(sizeof(dev-+AD4-t10+AF8-wwn.pd+AF8-te=
xt+AF8-id+AF8-info) +ACEAPQ-
+AD4- PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN)+ADs-
+AD4- +AD4- +-   strscpy(dev-+AD4-t10+AF8-wwn.pd+AF8-text+AF8-id+AF8-info, =
stripped,
+AD4- +AD4- +-          sizeof(dev-+AD4-t10+AF8-wwn.pd+AF8-text+AF8-id+AF8-=
info))+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   pr+AF8-debug(+ACI-Target+AF8-Core+AF8-ConfigFS: Set emulat=
ed peripheral dev text id
+AD4- info:+ACI-
+AD4- +AD4- +-             +ACI- +ACU-s+AFw-n+ACI-, dev-+AD4-t10+AF8-wwn.pd=
+AF8-text+AF8-id+AF8-info)+ADs-
+AD4- +AD4- +-
+AD4-
+AD4- ...
+AD4-
+AD4- +AD4-
+AD4- +AD4- +-static struct target+AF8-opcode+AF8-descriptor
+AD4- tcm+AF8-opcode+AF8-report+AF8-identifying+AF8-information +AD0- +AHs-
+AD4- +AD4- +-   .support +AD0- SCSI+AF8-SUPPORT+AF8-FULL,
+AD4- +AD4- +-   .serv+AF8-action+AF8-valid +AD0- 1,
+AD4- +AD4- +-   .opcode +AD0- MAINTENANCE+AF8-IN,
+AD4- +AD4- +-   .service+AF8-action +AD0- MI+AF8-REPORT+AF8-IDENTIFYING+AF=
8-INFORMATION,
+AD4- +AD4- +-   .cdb+AF8-size +AD0- 12,
+AD4- +AD4- +-   .usage+AF8-bits +AD0- +AHs-MAINTENANCE+AF8-IN,
+AD4- MI+AF8-REPORT+AF8-IDENTIFYING+AF8-INFORMATION,
+AD4- +AD4- +-                  0x00, 0x00,
+AD4- +AD4- +-                  0x00, 0x00, 0xff, 0xff,
+AD4- +AD4- +-                  0xff, 0xff, 0xff, SCSI+AF8-CONTROL+AF8-MASK=
+AH0-, +AH0AOw-
+AD4- +AD4- +-
+AD4- +AD4-   static bool tcm+AF8-is+AF8-set+AF8-tpg+AF8-enabled(const stru=
ct target+AF8-opcode+AF8-descriptor
+AD4- +ACo-descr,
+AD4- +AD4-                                struct se+AF8-cmd +ACo-cmd)
+AD4- +AD4-   +AHs-
+AD4- +AD4- +AEAAQA- -2086,6 +-2098,7 +AEAAQA- static const struct target+A=
F8-opcode+AF8-descriptor
+AD4- +ACo-tcm+AF8-supported+AF8-opcodes+AFsAXQ- +AD0- +AHs-
+AD4- +AD4-     +ACY-tcm+AF8-opcode+AF8-report+AF8-target+AF8-pgs,
+AD4- +AD4-     +ACY-tcm+AF8-opcode+AF8-report+AF8-supp+AF8-opcodes,
+AD4- +AD4-     +ACY-tcm+AF8-opcode+AF8-set+AF8-tpg,
+AD4- +AD4- +-   +ACY-tcm+AF8-opcode+AF8-report+AF8-identifying+AF8-informa=
tion,
+AD4- +AD4-   +AH0AOw-
+AD4- +AD4-
+AD4- +AD4-   static int
+AD4- +AD4- +AEAAQA- -2303,6 +-2316,74 +AEAAQA- spc+AF8-emulate+AF8-report+=
AF8-supp+AF8-op+AF8-codes(struct
+AD4- se+AF8-cmd +ACo-cmd)
+AD4- +AD4-     return ret+ADs-
+AD4- +AD4-   +AH0-
+AD4- +AD4-
+AD4- +AD4- +-static sense+AF8-reason+AF8-t
+AD4- +AD4- +-spc+AF8-fill+AF8-pd+AF8-text+AF8-id+AF8-info(struct se+AF8-cm=
d +ACo-cmd, u8 +ACo-cdb) +AHs-
+AD4- +AD4- +-   struct se+AF8-device +ACo-dev +AD0- cmd-+AD4-se+AF8-dev+AD=
s-
+AD4- +AD4- +-   unsigned char +ACo-buf+ADs-
+AD4- +AD4- +-   unsigned char +ACo-rbuf+ADs-
+AD4- +AD4- +-   u32 header+AF8-len +AD0- 4+ADs-
+AD4- +AD4- +-   u32 actual+AF8-data+AF8-len+ADs-
+AD4- +AD4- +-   u32 buf+AF8-len+ADs-
+AD4- +AD4- +-   u16 id+AF8-len+ADs-
+AD4-
+AD4- nit: Can some of these variables be reused? 3x or even 4x for holding=
 lengths
+AD4- seems excessive
Yes. Reduced this to 2 variables.

Sending the new version in the next mail in a minute. Can you please look i=
nto it?

Regards,
Gulam Mohamed.
+AD4-

