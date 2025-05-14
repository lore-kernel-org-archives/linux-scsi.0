Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AB81E04BD;
	Wed, 14 May 2025 10:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218389; cv=fail; b=Si0PmCQr2vwCcGh6eSFTcwPmyLsCimM3aI5ZrMzot6HE3H6xbhVVESscHdPWF/zjJ8pWffBR5ZpBRC9PDoTz8waWLEX+uxXaQ2dUL/9IK5AINlcZon0NsBogThnEV1cvqqfvPLQgmhw4hSTi2xP+YJTIj7irg9qeYp1bkS7l0DU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218389; c=relaxed/simple;
	bh=rvRjCCWi2SStwRRn1xsnY0DXnXKw6jtl3xglZTHTGqM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hqCMq8qArkod7vsQFhZiKY9g40T5Qb/rkDZ7h+nVv7xZ+OY8ffDYOuZBw08VVqrEvzRcn/uelaJRJLaMnfqLrTi3h6zblLWOFGdrDICyw9fA6Vah/Y4s8BUPJNPr325hrEOnMPkn9JkirkG/vWR9jS5mV4No/GdZ26r3uk0JxIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RO5vmaOr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MnW+wAdC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RO5vmaOr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MnW+wAdC"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EAC37T015966;
	Wed, 14 May 2025 10:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XUjmn2PxP80Kb+NbJ1WVpYaeIPA3A23ImlKK0NuWzYg=; b=
	RO5vmaOr57vc+URCbGok5nO8kH9aXXy1QZdhiMYfXXuNAcwRI9zBMElDZH0gPQYv
	Z1jKVmujP3ftKV2Pra6IfqlXF1VhKhF1OqpbZrCMImUKQ7OtZ/lZDEBo7KA/QS/r
	CE9QUzOyxUJA6muvGBVJnQHtk7KzOxniEDND44uueyCbg++tCVS+EVZOiLOFbPNv
	nnSOLq3RrB5h+Xancc8Y4iikUjbChOzgi7+NIXWVBlXYq8I7tRYgH+7l/7g+k/ff
	PUT7sTur2jHOvTAclnPCidWDOPGpR+TBfN/AUO0IHTPA9D+cqKiuJ8lZ80gYJjIu
	44QD+e0JTVI1FvDZU0mYyA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ms7br0p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 10:26:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54E9RmuF026189;
	Wed, 14 May 2025 10:26:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbt7rvc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 10:26:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtsXJcUpvzdYXoySyg36uL37LNy9WRXuYE2ZrZ/9suBG+/sm0fN4SLWYvmWG2s65Yjtvto8z+cXeh1ttbn39XNi3v+LqyVIyCaapcP11LLg9kXNwvufoiTGRMKywN1JGyOlWRPfo3mLPTFWn3E2OKdVNxeQATxK5/hxaEc7KQM1gCr5Wgp6PxwgzZNIEUhpIISAD1TgaRwal87F/nLNzWqpdRsYH1VTk4g+yOaW48lxJVm4nz99Kr8T+dylNEmblCLNd6FTh+fcs9NWs1oT2c0oR9sxpf5pHEQv4lAOXn+ARjisBTU6+L3spxH0Kdt4vN3pBdgD7/kM6+S7ScNw1AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUjmn2PxP80Kb+NbJ1WVpYaeIPA3A23ImlKK0NuWzYg=;
 b=i4Wq7H0z7sY+uMlgcelSig5xH8bSZAtAX8kTko6IXzvp3VB0jj8z+YCv90VX8z87nVcg6H5VA2eiEgWSQPxoR4l67GpTsNA6EbsPVAx5Q0Tic7ab6IsyUABpQgcSRE5uH8sNyDJtQcGNd32ihcLqv7JjJQKDZhNJn9HHDfY1Xb+lrr/I5fm0m21TZIIripquKp+UOhocljxJ+bg9MBwuOuzYysOBL9y5ucf4kQ1koLW1uJAr1dEZekxEBSnF/eoJz5OrNKSaKFyG9eIQjRLePKVvzn92tPjyVHvWRe2K5VeOiVis/4/ox+SvfgQmJdQ6uxnYCqrwN0cpRyvz0P3rvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUjmn2PxP80Kb+NbJ1WVpYaeIPA3A23ImlKK0NuWzYg=;
 b=MnW+wAdClD5r9tDYVnGcgIGP5IPSQrJ1/rnP1ElFqtJ0BEuqOvZKHlq07u5k62eOMkb2YfuSDhVf1N0C3qEcZ5Xg26CXvLGvINrf5xnicNrxJYOwrNaReXPrdeenSZ8kd+/2So34OqlLBtYz87fPsQJJpeZGAFE+e9/AHVXYyds=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5818.namprd10.prod.outlook.com (2603:10b6:510:140::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 10:26:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 10:26:23 +0000
Message-ID: <9e789a42-2522-4df0-8c33-db44b790a7ab@oracle.com>
Date: Wed, 14 May 2025 11:26:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: target: Add atomic se_device fields
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-3-michael.christie@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241008020437.78788-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0075.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ce164e-73dd-4d36-5e8e-08dd92d1c687
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODdyb1YxZXBUdDMyR0JVL0YwMVR6T2FpRVhVTXZud1NRaFlqdGF0ZUt4Tmd5?=
 =?utf-8?B?S21XSzR4bEVHMzJieUYrWnNvb0h5WGZiS1NBbjMyUExRSkdQN2FUUVFtdmlI?=
 =?utf-8?B?TmZZemVkcGZvYzIveXY3dmF6Sk9BU1FBclNlTWpzeWkxYTBKaVJqSWd5NEl6?=
 =?utf-8?B?emRicjZNdGh0M0htdGRMYStoRnBSMEw1alpyWU5rWVdhSzBaQjF0cEE3TjV3?=
 =?utf-8?B?UUNWQjM0R3ZYRGxhSDk0UkdqK001eTJYV1FaTGF1aWdGSlpzYmZDblJ4T3NZ?=
 =?utf-8?B?YnQ2STVRTC9kODJ5cEhTNFR1VFRwQTY3VDVJelNMV2ZBaFRjU0hwRitPMnB3?=
 =?utf-8?B?YUgyeGdFYk5aUVJHOTloRDByaVczcnZaQUhHUXdxbENZZDhzajVFMWZaTmk1?=
 =?utf-8?B?ckFZQmhLaFVFYjZmekovU0wyUm1KdHUzNXJoako3Tk1pQS9HSGowUkVqVXB1?=
 =?utf-8?B?WkJKc1RoS3RBd3hxWHhjdTFlVTJrZ0w5K01DRWZaWGZ1RnVndDV0ZmhGT2gr?=
 =?utf-8?B?NmFnQjRveW0yY3E1TlJuVGFpQUxodC9wSkc1UG01RU9GaUU3N2gwZmkzenp1?=
 =?utf-8?B?UTlyNnJiT0ZmenZEbnhkMXZxZ21OZCtkMlg4YU43MzN6dEVaanljRkIxbzIy?=
 =?utf-8?B?YnlMdktEUHRkSXNHMEVVQ0FJdTZCd2tuNHpnVDFPbEJqckZVUVRVRHNqeWYr?=
 =?utf-8?B?d2hjalRjb0lOc2loeVZXd2F6TzJxTWU3b1N1ZllhVSs1ODFGUVkvSTV3ZElq?=
 =?utf-8?B?d0tjbW9Bc2Z4dFRzRVdQSmhVMVZBRlQxZERIWDA2T095NStUNnZJejROR05q?=
 =?utf-8?B?cjFVc1ZoKzRNRzIzV3JUNzZLQUQrZnNhYkRxamxtaE9lclU0SGtORXhXTFVp?=
 =?utf-8?B?dG5vd1pmR0lpeUowc3FkcFdNR0M2SnVUYTJGaGlmUWFPeXJ0OHA1MW81Yk11?=
 =?utf-8?B?UlJEZW4xNXFLSHpkdzVhejVLZUtyUUUxYWZ2Z3dVd2l6NENwMnhHbnpMWVBH?=
 =?utf-8?B?VHpTZThGb3puVDlwRXBjNE5ONWNWOXJ6YUdYTTV4Qk9teEhBanRuTWJkV2ly?=
 =?utf-8?B?SGhCVkw1enZ2ZXJ0ZGpKNXRuMUhCT3RjZTZIL3BQb3JITVRCN1hhV0x5ZVp2?=
 =?utf-8?B?Y1RuVzZQeDRVSGZ4WnJ3Y3lOdHhST2dpMHZ5M1J1MlpjcGRZNlJleS9QZ2Q3?=
 =?utf-8?B?Q20wcHhmSDhhaEFWVGVhWFJIN3kzOWRlb0NCUU1CbEw1Mjc0WUhVckNFOENx?=
 =?utf-8?B?NFhYamRzS1NNZW9GamY5cUJPUjU4WVhMeTEvQzZUY1dsU0V4a2F5T291OEYx?=
 =?utf-8?B?bGJKZXVYWkdtQjBTNzhMaTA5ZzN4N2RNZzBnakZ5ZzRkS293L2pYR2NzQmhL?=
 =?utf-8?B?Rjc0ZXdLZW9scXYxV3VIeHZqQmE0a2J3b3NzOEo5VWF2RlZwa2ZOSGlseGxj?=
 =?utf-8?B?RmFRc1Y2UU1lRkJyaWovVjFqMEVqbnYzd3FJdGxDcjlXL3d2d2pWS2RONk5R?=
 =?utf-8?B?OXFFQnVUKzNyYk5jTUlTK0M2WktSZWdLUWhvWTJMRUU0M0VuWnQrTkxOY2tt?=
 =?utf-8?B?VXdXZ3B2ZCtXUU0rdlZGQ2NncU9VcUx6S3dSUnZvQXBjWmY1dXRHa1RJeXkz?=
 =?utf-8?B?TExoM0dhMm16MGhTZXdoZlZhb0dPL2hORHBJczZjV0dRMHpSRVdxTHpLbjZz?=
 =?utf-8?B?UFA0bCtlREhLNFJDZHRnWERUQXZxUU9NU2VEQ3M5bm85T1F6MTlHNFBrWSsy?=
 =?utf-8?B?SmhQdUxmZDVGQmV4U2RtcmJpZjV6cWU5WklmaWhTU2VRNXBvYjlNbk9ER2d5?=
 =?utf-8?B?YlRvblFZNkJZRExidkUrNGsrSUdFNGZwMjZOZ2lJNnh6VGYyVFVLSHQvaGFU?=
 =?utf-8?B?QU9RYnJrSWZTT3ZHM1h3Z3lONWJIcHF1S1VldVpyODJBRWN0a3k3YnE1S0N4?=
 =?utf-8?Q?jSE5tNwBSTY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzliMUhubEZQK2NSa0g0cDU4eWZwSmpoT09ERVgra1c1QWVyYkx2cTZLMEJn?=
 =?utf-8?B?TndBc0VieHMxdE91R2QwNEIrZEdSRnNZMHlhMGhqdHhOWFpmREEyS2NEcVZJ?=
 =?utf-8?B?cUFHbzBtRkczdGwvLzBKSE4zWldPSkpVRnZmWDF3SCtQVUl5OVZ0YXJzOTRj?=
 =?utf-8?B?L1VwRUdDWHdIMDZucERnNlZnd1o2UTZLdnpORXM5bi9heE93eEVDT0xYazN1?=
 =?utf-8?B?VDFHa3hpZHJ3WUdmdWZNTi9HNlcxZDZhVVVESFpwRlU3eWxIRklLOXNwclBX?=
 =?utf-8?B?aU04NVVQTmNYVVNWanJSM1E1RHNMdXQvTjYyT3pPci9hMG9wZGE1dTNUeS9F?=
 =?utf-8?B?SXNRejhsbE54bGRPdVRUamZYUmpHaXZ6a0FneUNTa2JHTFRuSlM4UUh3OEc5?=
 =?utf-8?B?RVBRVmdrSzFhMFhpWm1XL3M2WkJPdTE3Q2lEb3ZYM21sMHFvT01adW9wNjhy?=
 =?utf-8?B?VTI5K1Q3T2ljWG5jSzZUaE9qT0paYlM2UW4rUitBajZ0bWNkcUkwV3NSZDc5?=
 =?utf-8?B?Y0VqT2ExWHVidEdYYjhQbDZGb1p1aVh5NGEyWHRacHFyQWJqME5WaSs3VTc0?=
 =?utf-8?B?L3dBOHFFSUZDTzJETnExWUhiRmM3U20zNk4xVW1JOTZ4VThvcFJXOTRpc2hM?=
 =?utf-8?B?dU8vaDU4UThLclpWYk90TmNaQnhzd1ViK2FEU0JlaDBkajB5aG41eUpBV3pj?=
 =?utf-8?B?N3J0VVBSWkVTdFJZWDhzUkM5VFBIRWFjS1MvMzVIazNJRThkUTViTTVLYUhr?=
 =?utf-8?B?T0lvL0N1dzRMN21Ic0daWnZBb1kvdkdzOVBnbzJDSUJVYUVYZ2gvcDF5N1Nm?=
 =?utf-8?B?RktzUjJrTTdCa0hnalNpcTBTNFp6WEZZc0hSQUtTTUFoRHQ4d2lwVVdOYzRN?=
 =?utf-8?B?R1hTK2MrZFFUeVlwOHNNeHA3WUlOOC8yWllaQW1kMFBGQU1qVzlrZjQwVnVv?=
 =?utf-8?B?ekdWOGFBa3ZvWWJpTHlkbnE5SkN2Z09kcGlOY2ozWlg4RUdOc0dmdUNjZXkw?=
 =?utf-8?B?RWNIa0g1bVdjQ0hNeHBWb1FXRUZZa2VOd21uNTdRRFJHdm1QZ1lYSWJCZk8z?=
 =?utf-8?B?TVd1cDdSRlJjTTlLWDhHK0NTeVFNbWtqTjhkbm82SXdtdUpEemNNeElnU2M0?=
 =?utf-8?B?VUw0RDQzQzRGU0lqVW9jRmxzeGlhcTVBNWRwTGxXc0JhWlhjMG5ETnEvL0Zl?=
 =?utf-8?B?azFNQ0hsdUtNWTVsR0FTYVIrQ2RuV2ZTUERDSWhGazYyeW4xWlJ0N1UyZmdy?=
 =?utf-8?B?d01IOXBoRldMZCtQZFdnaGFPTWR0MllScjRoL0cyWnB4R1NDZVM5U1Zwa2R0?=
 =?utf-8?B?ZzdhSzVjN3BVNmcxbXlCdWhUNmRuRkdGT1NRTXFkYzZPNnpkcmJBUHd1VVhJ?=
 =?utf-8?B?WDR0MHVJRzl4YnFwUGJLMUhHSWd4bHJUUk1FNWVMamI4dm1hV25OeFN6ZzFW?=
 =?utf-8?B?bE9iMUdEUm90SVVmMmx6bHpPMVRxWVZSdnR4SHR0UEljd3N1V0FFT0dLekg5?=
 =?utf-8?B?SkU3NGdocGJBdVNKNzQ2QmtYRVF5SWpQOVdrZ2pWeFdLRldmOVRHTGpVK1Yx?=
 =?utf-8?B?b3RhUHNIcHRuK25IeEJwWitGRE1aQkF5WEwrQTJZTEZwdGhkSDdYOGRRRWVr?=
 =?utf-8?B?T2ZvQy9QVFR0Mk1wYm1kVlJGRG5nSENVU2kzWTFhWDVHb25WMk44emNEVkZS?=
 =?utf-8?B?S3EvbjFjQ1U4THgzaEk4anZvbGcyS1picHBaSnhrL0ZqUDk4SDhyV1BMbStx?=
 =?utf-8?B?UWxtQzFjSnlXOEtpbno5QWxTTXRYYnY1c2YxYmpCVTdkbmNJN1lja3k4eVQv?=
 =?utf-8?B?b0pwajRjS1F5VFJWK1loc3JPWWN1T2gxZ3RtMlA0d29UVEtwbk9od0pnQjFH?=
 =?utf-8?B?eVlVbnBsd3NvSFVvSDhTYytGNEN1akRoVGFCVVhaMXpKaHNwM0R3c2wyODM5?=
 =?utf-8?B?ZHo2dlVNU1RKVzNwQ2pYNWoreWYwa1JKUGZUWnFYNVN1bXBzR3BpdDY1bktp?=
 =?utf-8?B?NE5uMFp3N1hUUDJLQ0daK21ZMFJWblI1Um0vZkt5ZTlPNVNreEJJcmNvSmln?=
 =?utf-8?B?SXdiNUNlY0pNM3k5OE1BL3ZORmhuTjNPRFZueGZnYXhwR0h5cnFtdUIzeHh3?=
 =?utf-8?Q?byXzksdYH5ic2GBNNdPbSinUM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aj8uBRpGMvv4KF8kmChgOVRsqa26e/XD6b3T4IoAJVEkx9JUoZeLWWOYblomw2wkuSJAHpvNzU3FM2WA6B+ACOJ0541oIVjJse/2qYvxFdnlVX4fhjV/dYMK9aM+Na15BngMUteUdp+6xbKffY/5p0UwutWoJeLQ2JrySxQxX24mvj8DligSpgtY9paln7q/fJHcXZvjx3Itp3yXXqennNt+13lu8yfsCxGY8IZFK7PV+NbTuperf8a3j2N5Dlj+/eAR9qWo26oCJ0q7KLuSmCpBpywI+uRqiEIyOkWr8yNTgxbXi2MR3Is6aZE42OIxPimT7nZMGRYMpirRtpEGXnqGTVAe1qcepj1l8VUPenVA3uD+IGnbTESiyo15JO8oaKH1eO8+ZUDWq5x2RQ07I6+nrOOVIgBSQUcP4RCWfq2C4vD3CY4KI7DYmFk3y4akQzp/wX+YnoXvB5XZzlLcs1Yqa0o/F+OyyTkUBzEN+kJ+YNfFMcbEEAXAuz4oB/JJdbX011LACQCA04sxvx9jtIU0Q3WPKcSMOdwHj3hS54EGpVwGVXIDlr99Z54v5N9MywBhsocEWir65kJslQhV4UfHBGusONXSMmPyrqav/d4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ce164e-73dd-4d36-5e8e-08dd92d1c687
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 10:26:23.6916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0okFB2OJaizPq+WazNa6L5hx+5FA6hcIJFfuS4uICcoajPYJplxNU9H+ZOxqqKOypC3i452BNBtId7oX6QS2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5818
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_03,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA5MSBTYWx0ZWRfXy2taslFn1/wI hisgXF07q4kg94bgqYCUvAp033b65eWjWsNIwybd3cuUDX+8KPBKMMUfjfw935O/VjqAk8WxObT /x/tF64C3z3Nou+gnyBBh/ZX5Jg5eICokHHDUsKSAcCSVm3H0VBz1Uz2hyInYkue7LtDyUTc9uv
 85X7ATMkAC4aXaRudoK/mLmkXZlYdyobHfRs8g7gnOR6RCfa4/6AWEzcsskn5Yn0r9hjlQH0ae6 2TKNzOWOFCNz9j/i5dmdtkSA05itBPDJF6o/maYrm84cx5NW/MyIDhP5H+g3LWzs6j7oRMtdBpP FFczQa6nwUGR+eGURBw5nsXZkLMU6a0Jioxx//feus7EBxmUB3Uan5tEv5u5nEi8zUjNFTTXHfv
 DbXxhiHRC8DsPDgmYLVvVtGNhR6OKZPZoEWsbqIWm3A7uWK96EU2u7OI9L9/oX2f7aM+xQsr
X-Proofpoint-ORIG-GUID: wmNBTCXoKzs6xIl1__a8oGCc_k38npj2
X-Proofpoint-GUID: wmNBTCXoKzs6xIl1__a8oGCc_k38npj2
X-Authority-Analysis: v=2.4 cv=P846hjAu c=1 sm=1 tr=0 ts=68246fd2 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=JACbq8jzS09GjkUK_RkA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14694

On 08/10/2024 03:03, Mike Christie wrote:
> This adds atomic fields to the se_device and exports them in configfs.
> 
> Initially only target_core_iblock will be supported and we will inherit
> all the settings from the block layer except the alignment which userspace
> will set.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_configfs.c | 42 +++++++++++++++++++++++++++
>   include/target/target_core_base.h     |  6 ++++
>   2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index c40217f44b1b..f3c7da650f65 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -578,6 +578,12 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
>   DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
>   DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
>   DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_supported);
> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_with_boundary);
> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_boundary);
>   
>   #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
>   static ssize_t _name##_store(struct config_item *item, const char *page,\
> @@ -1266,6 +1272,30 @@ static ssize_t submit_type_store(struct config_item *item, const char *page,
>   	return count;
>   }
>   
> +static ssize_t atomic_alignment_store(struct config_item *item,
> +				      const char *page, size_t count)

What is special about alignment that we need to be able to configure this?

Won't that be derived from the block device queue_limits (like granularity)?

> +{
> +	struct se_dev_attrib *da = to_attrib(item);
> +	u32 val;
> +	int ret;
> +
> +	ret = kstrtou32(page, 0, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (da->da_dev->export_count) {
> +		pr_err("dev[%p]: Unable to change SE Device atomic_alignment while export_count is %d\n",
> +		       da->da_dev, da->da_dev->export_count);
> +		return -EINVAL;
> +	}
> +
> +	da->atomic_alignment = val;
> +
> +	pr_debug("dev[%p]: SE Device atomic_alignment changed to %u\n",
> +		 da->da_dev, val);
> +	return count;
> +}
> +
>   CONFIGFS_ATTR(, emulate_model_alias);
>   CONFIGFS_ATTR(, emulate_dpo);
>   CONFIGFS_ATTR(, emulate_fua_write);
> @@ -1302,6 +1332,12 @@ CONFIGFS_ATTR(, max_write_same_len);
>   CONFIGFS_ATTR(, alua_support);
>   CONFIGFS_ATTR(, pgr_support);
>   CONFIGFS_ATTR(, submit_type);
> +CONFIGFS_ATTR(, atomic_alignment);
> +CONFIGFS_ATTR_RO(, atomic_supported);

isn't a non-zero atomic_max_len the same thing as this?

> +CONFIGFS_ATTR_RO(, atomic_max_len);
> +CONFIGFS_ATTR_RO(, atomic_granularity);
> +CONFIGFS_ATTR_RO(, atomic_max_with_boundary);
> +CONFIGFS_ATTR_RO(, atomic_max_boundary);
>   
>   /*
>    * dev_attrib attributes for devices using the target core SBC/SPC
> @@ -1345,6 +1381,12 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
>   	&attr_pgr_support,
>   	&attr_emulate_rsoc,
>   	&attr_submit_type,
> +	&attr_atomic_supported,
> +	&attr_atomic_alignment,
> +	&attr_atomic_max_len,
> +	&attr_atomic_granularity,
> +	&attr_atomic_max_with_boundary,
> +	&attr_atomic_max_boundary,
>   	NULL,
>   };
>   EXPORT_SYMBOL(sbc_attrib_attrs);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 97099a5e3f6c..6c87bd018983 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -715,6 +715,7 @@ struct se_dev_attrib {
>   	bool		is_nonrot;
>   	bool		emulate_rest_reord;
>   	bool		unmap_zeroes_data;
> +	bool		atomic_supported;
>   	u32		hw_block_size;
>   	u32		block_size;
>   	u32		hw_max_sectors;
> @@ -726,6 +727,11 @@ struct se_dev_attrib {
>   	u32		unmap_granularity;
>   	u32		unmap_granularity_alignment;
>   	u32		max_write_same_len;
> +	u32		atomic_max_len;
> +	u32		atomic_alignment;
> +	u32		atomic_granularity;
> +	u32		atomic_max_with_boundary;
> +	u32		atomic_max_boundary;

these will always be zero, right? I don't see much point in even storing 
them.

>   	u8		submit_type;
>   	struct se_device *da_dev;
>   	struct config_group da_group;

