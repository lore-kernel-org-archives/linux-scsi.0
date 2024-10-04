Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF88C13;
	Fri,  4 Oct 2024 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728006952; cv=fail; b=nS4KhU3x6aKuRJDr+vlOOlEDp669YtyffL7y4aRmQThpsqDin+Vp3EA1ImNsKwzAWE/UFZKeeUSKOJA6iOOCZEVqu6IfpXH6NQWILXmPsLwsfGHTfluuKPzVya0Bx52dyLTWhqwvbIJlrZ+nXN2VLx3wikXxkWZQidNzliMh3z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728006952; c=relaxed/simple;
	bh=IosxVK5mSa+6JcIwER/SXBjGQpQukESCnIkF5ctcvE8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oHHTViUblPL4GC4RPCNGmFcKxODk+D6ATBSxbH85pPzmxjmVaDep7jJUUsFGfFQUt2LV/jInlNrrtbp/cTfP7c6PUKroB+X9y9k/F9DSEbBF/xogC5UTXB5vEkFbUqY0j8rCqy+6IG8UYJGVp0jV9MGYSa36bel8AaxHmZS5yTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iWbLzzpO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QhJfq8yh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iWbLzzpO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QhJfq8yh"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940uAF5009056;
	Fri, 4 Oct 2024 01:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=0qltL+k2DCneIp
	u0JLfnJ1wUeID3jRS7DnA0xgbooXY=; b=iWbLzzpOnFYxnv/TOA1R14lqahUhDQ
	JV5VZbiNNHnyfWdaR3CDX0b7+mWFhiV3O+v7Sz20JK0NYk3J8Dmrt+15OiAf245L
	SBgEJ++FXrqKBY5SqcmXtWLQfSEj7Y98IekC0VwjUeqCCvm87C2YO1I8EVjkZOPL
	kIx29y9oEIXRqRh3ezgVWMBy49/JtWEaNfmlxl3s0OnvzbuQdOytGrUcMin/VD8k
	oyvy/RtnAZelOOVd1v2ocdTpinamr36U/EJNTFLIlAlI3Zsndp6Zx5nVN+fntOga
	w0NlC6W7DBgNEBdAIWfTCAqkaLVJFjRCVjz7p8L1Cx2D6Q85N9qDpjQw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4220498nsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:55:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940PjAU037879;
	Fri, 4 Oct 2024 01:55:45 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422056p0ru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:55:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEJ3TIh55yokFgS3cdk5ONJ+nSTbtj6Q8xc6E7ETzQNjnXoKLajdOAvZMFTDslqTRR+XtXYNE4iRsRyGQqGUG4EQpbBXKKOcDjKPtP3u/z8uD8JOw9O18CY175SP83lsSa0fFq7wpXwenUngq3oI7DXq+tvdqwi4DVUdj4E1RQEF8zSB7vx6v8tjg4CJW/xyV8mv2ND37k17TN+Dg+hCDRVTFPPBp6eLLsHHLL5QmEmoSE2PezuyK+2zcBOMQr9I+Jn5lavK+/YgSTBsa/2GCK/ZVpIF2HPRw+7iaQV9/cacTVdJfxkiqdh4wwutC2s/Zh9ttH+LbQGCpfXH8HGrGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qltL+k2DCneIpu0JLfnJ1wUeID3jRS7DnA0xgbooXY=;
 b=MyrIYhQGWJeD3cyArs0JrwWQv+T61sjxpjxkLpasGEjQcLPXyHBwIdykMAPvdYLn5yQK7JTb36/Vu2DCUuVVTy4YRRkniqRyQ2EccVSsrXZBKQamq5JSd5p4vwVLb3+DUHyBoWJ0FcifyDYLdZhVMOBJ7Jvkqdct9As9giqrE06aDMS7fvzKW+GUhCctNXPSqh0XzYwS/EkZBui41WtEPLA7r2uHoB6g5TMW7xnrx+NRtqwH/PvU5IJ5eGLz7ULdHTP6Cx7WuXstgXQTycLTQqXBJm7lZTOOR2F49hY+a0bo1OcS1eT7vKzATFrgllIl+FKMS1QzRdwYEUHgyitwtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qltL+k2DCneIpu0JLfnJ1wUeID3jRS7DnA0xgbooXY=;
 b=QhJfq8yhUigOCrpkKgQjK+phyJoLURDr/lYjnUEIjpercAc/to0lHp+3V2900wJBPU0uJzrAXkyDDepsc3eHweGgxVG4p1Q6yUuAJROj8rOzjfwP0enAA2wTY4qMtZOPc0GM13/sOid9lCCoWQjHPxfPQo+viVvyuLL5xyZ90Ec=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4265.namprd10.prod.outlook.com (2603:10b6:5:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Fri, 4 Oct
 2024 01:55:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.017; Fri, 4 Oct 2024
 01:55:40 +0000
To: linux@treblig.org
Cc: aacraid@microsemi.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: Remove unused aac_check_health
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240920202304.333108-1-linux@treblig.org> (linux@treblig.org's
	message of "Fri, 20 Sep 2024 21:23:04 +0100")
Organization: Oracle Corporation
Message-ID: <yq18qv43a4b.fsf@ca-mkp.ca.oracle.com>
References: <20240920202304.333108-1-linux@treblig.org>
Date: Thu, 03 Oct 2024 21:55:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0156.namprd03.prod.outlook.com
 (2603:10b6:a03:338::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4265:EE_
X-MS-Office365-Filtering-Correlation-Id: 26b6df57-003e-4a33-01c6-08dce417a641
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ps+tT6YDAckuKQQtkbHlc5JyOaytQJvoJr++4BuMP3AaWYWV22taiy2J1YMP?=
 =?us-ascii?Q?Qh5csYwiVhKEDXEKTEGO0+mktHSOW3jg8HTycVyPTrTQekcHURGU5SYEo/OE?=
 =?us-ascii?Q?4azndSfFBdQhdREQuxmRgayp4unoHiOh4WucCjR1r8egvJvFm11/U+PmK5WS?=
 =?us-ascii?Q?9H/X+/xJ86+yalrbo/E6vv0LN3ohCtAojQFWdg131mLx0xDfrLNsBplc/y9C?=
 =?us-ascii?Q?a22xBJIVdLzJtbKxu7erUa5n/77QQrEtGqaJLcpZLjFF2/DgyWrpx1+O5BC7?=
 =?us-ascii?Q?Jb9CPNGjK8BbtTHa27qVEmmQG52EZRKtL8lOgWoc2U6a4yk1iTRcE0SNJQHG?=
 =?us-ascii?Q?BINq9Sdd36V2Gkyju9Wx2CHPbpl/tVrd64Din7+qz8XAMuqpBq2QYkhc0b39?=
 =?us-ascii?Q?s/V4eLvi2ewHZDSREEXddlfjy7tClcV6GT0ZeqlfoqXBvGy2OmNvGxsTjq/N?=
 =?us-ascii?Q?KOPhPTA/hvkqjhNZH+0VNayG6tf0YEycccRFSwX9l6XC6M7MZ59TqrI5f5zm?=
 =?us-ascii?Q?G9bkGKS3J3XEMS8YT1FkC+dIZ0vMtBKFHefusNx8jTWVe2G2D7EcImhsVs94?=
 =?us-ascii?Q?VFA7usIqSbApjso8ZdedMd8oO2rmJfg2R7Toqpf4jaTUq0FgB+8+tr53Ab9w?=
 =?us-ascii?Q?bFSC+VQSFyempNmjzpvb3sbB1AnTRWF380Sq4XKU1d1lL9R33aThT+lUn2Xb?=
 =?us-ascii?Q?S1UnUAjsF0mt2j8izLKvbjXrOFuH414xgeM7Uj+j3o/Xgm7fc7UO5U/bvzot?=
 =?us-ascii?Q?uXNZphvaCw52aNVxC8kBPtLfrioGAMAqUJAeQHb5zzoAlU+nw995SpGhKdO5?=
 =?us-ascii?Q?2f+IjOHTJ8VwOtgXGuj1dig3Mp4xs0dthgZTYWxF2QlyrcTtiM9i2bG0DweW?=
 =?us-ascii?Q?5RFyCcJv4faKl6DbYP9qGN0ozEKtNawukOEeou+BMxytejvqjUIcHFotGC6Y?=
 =?us-ascii?Q?fR6/bByb81KwqhvYTyUvhsNXeDZPN4N7Kwg4/XUGM/lAxpWPfMkLehVqNmr4?=
 =?us-ascii?Q?jcMICMF9xraAIBbNrLoeZJZ95LwT7em0ijJTkDJhJHUB87t9MTyqSgN+FrBx?=
 =?us-ascii?Q?ohl+AoX96tSvR3MWHMFgu5yGsSrOz/I3ZC8jrYfSRkxtHEEojdnyaUCtlbEJ?=
 =?us-ascii?Q?KZQ8zXxlp/jsxKveSR6Y3ykwHsj4IBu8DCjRPLlrIUDghkU91lgqpU2QShQN?=
 =?us-ascii?Q?MQ0ujcycwixpDSMzixox+hvkVrPmnxWFgHacsISvtlwpeRUeT4jnylPJjRsB?=
 =?us-ascii?Q?chsVKPIJWoARqXU+1k5zidSNiQD60w8QV55G1yjL+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?weUUsqtHMTi4uqD1KNpSTGxESp6DFt+oWi0NKJ4MM5lA8ddHn2IjHEeT9H1C?=
 =?us-ascii?Q?B0ienxypDDrPe9VP8BLxyGT8nnhguD8xqa4Coe4wS83k2eHCV+COj1ad9/FJ?=
 =?us-ascii?Q?czEkbQwHNAIrfK/txjgOPD9qE9fDGUGqKbOiAseWiymuHufurirhWihnWhC3?=
 =?us-ascii?Q?aaj/3w062jV1IlDK5sfwAdMiOA//k7nHAW5WaKj6b0c3lfQumBCML12yS1h2?=
 =?us-ascii?Q?5RjhxDyfvBh3fhH2LHFUGKFaHyxnH1hkxgSqht9eWAzGnTH+BSJ5MUwvttVu?=
 =?us-ascii?Q?dTA7xlvNamp7fH4Wnaya3qekJmhdJMGF2em0laTzyb6hI3i0+JNkLLlBXZZ6?=
 =?us-ascii?Q?88B/q3pk0qtx+yqDzyAxYC2bInXW3F9LpKuc2VkarKiD8vA+YqtyOp87BgUp?=
 =?us-ascii?Q?MvI9xCHaOMzYZSUpO5UvDjcKGHcqAtmSlE9+plPSVFoClxFhe32Q0TYBv0+e?=
 =?us-ascii?Q?wdXIXwpo+pCIVfcAFq1JAclgrRfQcB3PZwp9ikO54h75GrDB7n4ydjUWUf6F?=
 =?us-ascii?Q?3Pmxnwa66OqZLTkMPCKLrb1pTHIeCC0aReZBTZ+/k/TceyGn9q69LPgQ8SHJ?=
 =?us-ascii?Q?nzYLyK4fcrbGrQJuexbrqU+092d+sI26fFONtoONayXOnhvyITnzpWZdyQd9?=
 =?us-ascii?Q?0wW0Vqs1ZEtkjl8Wj6ilLF/LVs5a/8gdHEKcQXBS6xY4ujZJ3uMSbCixpd0F?=
 =?us-ascii?Q?U+pBgmkX9iXwcYo7WDS5SVNt/elW5DQFdf7rr99CfaDVnuXZYxqZGAK1RVPX?=
 =?us-ascii?Q?42IU1hi4P25/8E45tkrivTZDGac3M3QWRqm/xT5NXZ0o9xIBFkTgbFHODjcV?=
 =?us-ascii?Q?yR+qUOlQ0phvgunCNrh+sFn6TTJvEzqAZQMQU5hitOTJ/jwEdGnqai0t0PHQ?=
 =?us-ascii?Q?KEDkY7T7P3K2xab+ncelHTE7GWszbLSzVupNF9qWCpa4HjWozYwY05N03U2q?=
 =?us-ascii?Q?D3AsThmGZnAvNcbdjiv+MOR+O1JuaGyhqms/3NzSf/159kzDnPoXP/ixINPE?=
 =?us-ascii?Q?nfYQ+m6Hfp/obXrv4LJ6oS/6OItPBJWvJ4/fpfjTKklhsRF8LtF4Ciref8aQ?=
 =?us-ascii?Q?dIvxeYf/SJgq3p5zvKO1vvCNs+DPdyT/iy7mlKLmWXO3vQjbOvXtKcZsZI5t?=
 =?us-ascii?Q?gNpJUqWMNJviZrhw1/e2ovjXR9/6g/Cmk3Rjm3gZTv+USo/T+ad3KRTr2K1h?=
 =?us-ascii?Q?BuiDGdt2Y9pdHPqJhCCoDyYSZQmQeYeyPy64MRy8oZU9ZC6NZ1GoGMWC7a5r?=
 =?us-ascii?Q?lT1BmTz1ISUGxlWYD3u1o83wRCLTp0+24JzAtQBV0WRqjJcOjJVSFc45s4O0?=
 =?us-ascii?Q?j+otSoe/dyxjrx75ziaOUQNRuHXUg7CXCOH1BHgMNc0BSxbpI3t4kNzuE780?=
 =?us-ascii?Q?tAX8ikjY7BHAzNEks70APUzBZrrJhuF3sKufOLLcUqIFcM//0ZZ4US+uHvI2?=
 =?us-ascii?Q?ahhEDatu6wDXaTsFZ4JbY8UGPRGmc7KFMmpKhI9ViLDdcK2ZSX/vAFV5mABm?=
 =?us-ascii?Q?D33JN445cN9Fh6LKjA/c/MMXaRbLDdo9RxpIKvfx9j/LCl7C/cxljPspdyNN?=
 =?us-ascii?Q?BW1dQnt4tZ2D7Qxbe5UTBXTcaapBzNbn5++mGe7waA4RWZz6pSNvnQuoUnZw?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2mM/N4tYryxdTeSzP+I1tnlVdlEcvBladtXUCgPoJ5erG0ldR6p5a5U8im/7kEaRodph1u5rv2NFKFs7sYl20rf1XGepekgy7es+Z2jNrVKsepPphgYNcDc5uGzBxD1xUQ1OQIJGFTwPN9Zl6tS0Fz3Y7+Vk2SJl6fP5MUIwBXs8ZBb5mGJvO1yM6gza8uajOmnCvGOpbSVIieEawR6Gsp1QNN8u0DDfoJn0YyJf6ZjGebMrSVy/0A2vbO0Ad/Kt65jjwyGGClMK4vmv7s1S0nCAVWheel1tu90SASz2jdkKzjes0bfaq7yXY/ZVHMCzjwWprn8BCZOhkX3eT3GKRhb50IeYKhD1QOm4me8dpC30QCQ/BW3pVYrmNiudpbqrb4orITUmVkuT3ViPwESsyzmWVi3/qJi55HiWtQrNQQ085kloVVXIvD8aRfL2JscjJnZLeNhzLsn+FKy4ZvPEpQT0ExtNJ4D//I9rS3JSh1owbJyEptM55+HE3k3K18igd1ECCWr8deT34+zNpSWJkbGE/U26PUMLbT/dXHqwZbsakgkBfiXz9DplWkMK45xPHc3mivEaq6v5IQHXJWMbfGDThExJuRUl2J4sLx9O5nk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b6df57-003e-4a33-01c6-08dce417a641
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2024 01:55:40.5962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMu34MeKf0aOb5U7nCt9EQaYazOV1qF1kG64tsGtdzk7Mqftyc8I6CXbJqBIUVyD+vtxUHcjBKqsXeyXdbSkwu1siO3ChHXZPzR7zCyAF8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4265
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=654
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040012
X-Proofpoint-ORIG-GUID: PeAqv6vH9CoaNoURElnR--bZ_8JzQfui
X-Proofpoint-GUID: PeAqv6vH9CoaNoURElnR--bZ_8JzQfui


> aac_check_health has been unused since commit
>   9473ddb2b037 ("scsi: aacraid: Use correct function to get ctrl health")
>
> Remove it.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
