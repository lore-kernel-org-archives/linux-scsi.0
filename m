Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C59946A;
	Wed, 22 Apr 2026 01:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776820306; cv=fail; b=SXx1R3A54rfDshDm2/n2q5K9gSqm7Cn+sW8hNyUheXfQl0cDfMOmpNHBiQibz/mkFNF7Qc4VOgZsSkvxydhXD/J/N5+urZDdWcZoIA9c3WJMytJIWpOHGaryD+xUgcJLysT3G2vnvpIFrg6vf+55g2KOMPw5kZJRap9ZsxA0OU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776820306; c=relaxed/simple;
	bh=lSQKU7VcegToW5YIDZW48VqKTJRU33bwS43uGpS/Jmw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=nJ/nLDvwWPjgy3oVAhTD09wkWSKCmWKDOQNNWy2sndLGxiRlgkD6ETl2YFmwMIlpqhw04+6LMl/Clg06Ep+wXIGEoTEe3re8HVTi5L+Qmlol70umh6VhLw2tjLsaCFvqRmUyRq203ICrPWU/p3rpitwipilCrHnPWxdBDD8RJcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WvVjW5rA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zSrBlY1u; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WvVjW5rA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zSrBlY1u"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LLaj722558903;
	Wed, 22 Apr 2026 01:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=k8nJk8Wt976mskLlye
	S7evu5YwQ1aTz1Y4wk3CC56nE=; b=WvVjW5rAeaqlvzRUSBifem0xzuhnGsmri7
	tR6rTdMyMtPesyS9IS61DCnWgQsMERd3JLNRsSmvMoRja6ukLJUqYXP5/8AA/D5i
	wXBdBcbP/Hfk376RBvBcwF9LkcscPAPEydlCiYh18KGf2thnQ68pzi1H3y1qPobu
	YagottEF9lcFa4xHTATWRC+iyAUBJxi5o+6btIoVNHF4/lASaDOBKgcfXzfD/BwV
	vupFYAA+/oh42tHtyopB+eZpSRVu0tlfemnZ9pRDJjJb1NarafJxw9l62pWyU6VX
	z5UR7f1lFX93jeB7KdgheIfM+Q4jRv6L9Veap8eOeEdfK8e9Hn3w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpha585t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 01:11:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63M1BDNT036498;
	Wed, 22 Apr 2026 01:11:39 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011001.outbound.protection.outlook.com [52.101.57.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjje311s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 01:11:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+zl0oJKgjtCCFrez0+L3Gd20m6SLRRnb9t/sJ2nXLPIjK7b2LTqD5Ooz+WAPoSOsVSUBKYLKJgZV/+fgbWvyIsPV0thDCaZ5E+7SxeQOlBduMOL0c4VIcbthCqVBA0+F2Gko4j9CbKFVvKOGlF3POMJHYum56BVj6kig8pcoO8PPXfPksafsUofWmReWMQpnuczMkNOwUcrvME0u4bHFEjH80E54mNItu8V6LYFH5qKR1IU5A0soP5XHAL/TUI3Of8lVX9QFYYYpOBcA3NOJMAAL8RgYxeAFJDwXic42Ag82LR/u2LJU66wQH4JtswTTAVgp9hj37eXNtwq3N8Lpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8nJk8Wt976mskLlyeS7evu5YwQ1aTz1Y4wk3CC56nE=;
 b=Q5T/OJeNkPI3nMNMoBrKGm+bKfrYjfnlOfDGVoxz56bq9X7FQ4+F2ZAqGF69iZV3HQWni3BRmAgyyL2sMs/cOs67oul602o/tKxoNPhiAOqkfAYlxegygm2ULVE8wj3eBQ6JpOAHYbUi9oQ47MprP+w6goYS5/mptDiA9ru+i4I+ePmyiP0GBkWdqGb4DnOe1mkSjDgrFDBziF9ea9ZVGE/4BQk2TzHX04pnQkoSeJKplnAOXypCpwVKW2NaQzae43U6hlLMzRZcgSgjCN9UwqL1R5WlFhirUGGlsFUVgFWn2OCXyDOZ0ryAx6sNLOQdGQwcyhTl1MRjuzURcA08IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8nJk8Wt976mskLlyeS7evu5YwQ1aTz1Y4wk3CC56nE=;
 b=zSrBlY1uUQgOIWu4d6uiqLL6kuTzWH79QNC1OaRQU680itZF/pk1txzhw7BCrms9N7eDT+2pySjGwmiBvE/xaLKtMMSrwjkG2TsqJ4B6PtrgYRAdszlCD+s0r7FmtMymU5uqph0b1o/2f1rpnSSl/f7cskzkY3h2zRsqdTvZfJQ=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 IA4PR10MB8588.namprd10.prod.outlook.com (2603:10b6:208:569::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.21; Wed, 22 Apr 2026 01:11:35 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 01:11:35 +0000
To: "Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>
Cc: martin.petersen@oracle.com, kees@kernel.org, pabeni@redhat.com,
        mlombard@redhat.com, kuniyu@google.com, michael.christie@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bilbao@vt.edu
Subject: Re: [PATCH v3] scsi: target: iscsi: reject invalid size Extended
 CDB AHS
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260415040728.187680-1-carlos.bilbao@kernel.org> (Carlos
	Bilbao's message of "Tue, 14 Apr 2026 21:07:28 -0700")
Organization: Oracle Corporation
Message-ID: <yq1o6jbls27.fsf@ca-mkp.ca.oracle.com>
References: <yq1cy02tgum.fsf@ca-mkp.ca.oracle.com>
	<20260415040728.187680-1-carlos.bilbao@kernel.org>
Date: Tue, 21 Apr 2026 21:11:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0092.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::11) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|IA4PR10MB8588:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e6a79b9-0b7b-46dd-fb50-08dea00c18d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZLHsCgVlKHQtN8qBYzKk24jPr5pkxX1cksjHVhM6c9KHpkdPXePb27GN76oshy3MP4p4SkAuQOfj6ezUIIpgWZDBfWrJ/hKyjfoN9YeU0cJbQ2wHKXL8dKtDNIpGYs40S+zuQlsDtUipRNZHHyU59hk5gc+5voJ/oX8wNa5BW4KKMYgCFT2WEqN0IEiAmlT3QSw+6/a6kxiYrBD5I+C7NqZkxjIQGOVICxN30wVhl/ma/52Kr0e0QgiE7pLBegznwFn30O1LHx4or6xgEif4MphQnfTsYRVtpDWCnJ7MR8oc6S0TaBy+sZT3EHXsXYhqlee1sU5L5SFaVRujoT+0sWdd2pDSN01iHjOgmtY2oMmtdLR3bUrHc1NZEXn5qAvYRvxbDrBqybwlXFyb8vK/ZvPncmjMZhvIwnSCSsge61+3Mg9StRatnUTMeIomE6xW3jLjLozP3rBBJAgClB3vVm0vmGOw75O6M8xmNL/u6OCQdChSTjc1mVnlUqJS2pXYrY9IgaQ+jjlTzZgap9vjilxedn96O9MrlMMxOqnyWI+IRcUJBYOBv55clbJV93NYAX8uE55WY4hz78iZ6iA5AQjMGg1CzweCkGTq5GjxfsewZZLYscPIpyE3u+fW3fplAom/tZhj/ltJJNB4OsNPI+AUBEz1ERifffTqJFkxUIvtoIEjkIkGPHTKkEyFa4tdCMXsTkbZYCv9xinp6jegE07h36TaDT17eS6Yf64+07c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CreLfujfCvC4yxd5kUcYASX+eLWhX8B3Nd2feWJ5544BIqijLspjTXIf+vjl?=
 =?us-ascii?Q?OIXGw9tmgu5UENonL+8hoRhnj0LUUoM9H9NMvtnV3l4q0cRY6OACERMMt2jn?=
 =?us-ascii?Q?MmnN/DRrnwvk/NB7CwCNpd1AE8dVlQbsq9neTCjohuQzB/LYcx26QrXhhWvk?=
 =?us-ascii?Q?vzChC85kSVS8qSRjYyAvz/bD8+Uow9LKuBUNcdmjAW7af6DMxVu5ZznImlXd?=
 =?us-ascii?Q?oTZRHyICG6/5xYXzSRrfugCqaF1alBTN5ORdLT+7FZC4VbkFb994Vn2Gx1CU?=
 =?us-ascii?Q?v5chnXAmV/HpCWBtL/ueQs6W7oLzN+MCEQmm+e+EUfcQbkjR+16ZLWnoTicd?=
 =?us-ascii?Q?1V7ygTRtnGYT3Cmd3NZ1D3LuUrZ4WosKHWmgDBTSeaOOLLARz701ydzQ4HU7?=
 =?us-ascii?Q?ykNqrmi4Wf4Eza42MxzQiyyzdGOY3iFlV9NvvT/NJaXXAnF2CjgvSyMipJWn?=
 =?us-ascii?Q?OVMYX0wP5X4Dw9JUZnBToP0IcYwb4Bv52ipzQr+kTtw/YBCrX7DCGZ92xWVr?=
 =?us-ascii?Q?B8qZWkDfMKvgx8yr4sbHNNgIWms0ZOZ4pNXctSjYK5CRTtEBFClIKFUqDm75?=
 =?us-ascii?Q?azFWsEnIl/dM6Bqwjae3rew+7WG6yW1qzeML5/8bW71aVpuGOTTJgXa63t0P?=
 =?us-ascii?Q?gENPThWq65imcEXBVZlk3GwoZjvV/1qoZ31Yi0EmUvfZBlLaDGvGJAWULe8Z?=
 =?us-ascii?Q?dqeXOBLTSgt55lJADQZ9lY33m5ar7Ti9dEGcVUBL+O1c6yinjAb/Rao3Qw1S?=
 =?us-ascii?Q?M2TIaXgzpHAnpgiTv1cktmRbhmgGommZ+3deS9ev41HxvoVfOtHTpdDA+RfT?=
 =?us-ascii?Q?LM2u3HgvPgfpN24d+6z/upykfSoty3KJvt0tfY2TpcRiiFojdI8dBlgohkOe?=
 =?us-ascii?Q?ooT8Z+oLchrU47Ax4cAHy9Z1WMvM2Y9WGDMogw/Kxs0DfVSDfikJc+Gnu0YL?=
 =?us-ascii?Q?uK2GAeTd+v6WlkhgJZjBZBvHBQxTUECFf+oau+p1uwNAXxdvqSQbLX3+gDso?=
 =?us-ascii?Q?6Z96JMVSLvxlpZTE8WkI2uZES46XBohUvuYc74WBN0LjIvvKdgITMV1r9N5+?=
 =?us-ascii?Q?nXLO8okUHhAdWWyb4NbeLFaPSfg6LsyJXhl/OC9cBInQImybmt+X4Ip7zCHr?=
 =?us-ascii?Q?k8g8e3mW288baw1RNF0McMCtE+w4L0Rc8Z0HoxFTIJGs8zhz5oBJWzcDbUCW?=
 =?us-ascii?Q?tRStNps/u0h+eW8H1f9+HVbCOk/V0/ddWktgMq2dNwt989A6mhPS3L8gxTwm?=
 =?us-ascii?Q?StX8NTdAU5+JrC/1rOATbPqqDYK3s1UWaEBCKEY+CL/LS5qYYMJ9+3N3BH0D?=
 =?us-ascii?Q?ORD7ZBW2Lk5lD7nmiN/n8T0+CWMJx8Xdp33Ly3WV3Ss/pphH1nbFOrOSq6J+?=
 =?us-ascii?Q?J+xV5lecXt7u/QJToP/x08MAMtbXry3NnVcZY/4vWejWkU8tFTNJpIG8pmf7?=
 =?us-ascii?Q?WQ9CDo3s6T0LVqItuNhFHUpDh1pGcO4Thutoxou33qGmn43jb82SFtkiJO5O?=
 =?us-ascii?Q?Uuv7890bsNaw4aO0k3K6qqwZ0Oh+q7q0IHUweN5cm1dJLMY/IFqhygedXplx?=
 =?us-ascii?Q?1c1iBSVeYLzwSyabY/7erFZIOqGpFJt/d+NcXkTjfAkOIYRLBW2I65uaZFC3?=
 =?us-ascii?Q?y15Lh59nh5qCgy56Wb+V5umBcJQfy/i/MpuEfvnFft3Nai+ums218W67wOGm?=
 =?us-ascii?Q?LzwkAP1UNu8Rl1SGsRTyZied+NOec8DDxNQtSNENrYmg1Mb4pz19dJG/1YHa?=
 =?us-ascii?Q?y8UnuL0jRiKgK94sVNsPNOqb0viQJMY=3D?=
X-Exchange-RoutingPolicyChecked:
	SlRBzTy6XnqBnojIY5rLoYQgrsGncURR+QxG/begBChgcqOZYHH6C0APxGYKUbNEnB1mp9//gRZYcvHAVErj5ZU2nKCPs5eKf9NMWmRDIP9s+SucRurKL/VFsczokXURRM0s3eV4tNXM7tJK1NAl759Pi/IL3Q4LTsgj92ZDuVVLj4yf6yJqJvgNUlpsaLTdNbeYoBjLhMGr56x5s/uGfUDrG5Uy0oi9byaTwz68DGKNHjxM6xFW5PWm6ELfJkFxkshA7Inn5TpqLz3V2pbtqWQMje7Q+NdwNFIUM98PfYK/3GJxF6n9efecgTK9MuDZnCUGq4uvrZe2q9ScUgtWSA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pLr03DsLN6WAD8PCXcwafcxl+SSTCiI8jc37dJ0GL9OKFeSOtD6mKGbNnwwkP4UFtILEl2bkZMG/bG5TvOuCGgSeTrpMhuav0y+QRxvP69LODNfgB9UMIKuTq+5RKSDhUixZaCO2QZ26D0OVcGl5SsWBvvNOiL1Vt0oRrplT2QGv0fZX48Vlvr5PDo+f6F9tvwoUhZ7NLqIt88voKJkXeFRI5p8xgUzS6Bo2Qnfhg94is4pSsojntDd1Eeaxrw4kccr3TCYqUhBQPjn3lHrMc3ICTYtK22HaexIVY946TXDm8uZ/brL04A8g7gDTtcsy7Vq69LLLZ9pIV/h9U5NlU8e55D8WdyN1bSSA9nycDJzkQ8GWnqQjXHwfnwsC/k85xHB0FHHw2GwRkElG7i4In0ddEo2WqYCe1RRQHIc7ZivRLU9Erc80tMKE8dPxYGjOOk3yr5HihEEIjv70hI/XBqF2piPa1HFrgOMXIHsmxHcsd3dT20qybE2xo858VhFtDzX4HUl8Zjln/6rGamZ0zolnO+WY3vSs+X66JHk+egJqQIs1zX4gw0FlHaLvxVZVT/Au5SzUfkwfJ80XvKjlKYF6IO0qA2Ufwug5/Kz1AKc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e6a79b9-0b7b-46dd-fb50-08dea00c18d4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 01:11:35.1008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: us8CgejensgbS1YGEUd8Ri7rv4vSJWdJwseOPiRccnk0VnidMg3x8ETDqbOoddyZ3DTEI2zIhVch3sUDwmP1C11mJ3YTswf1hYBFfAsZY5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=645 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604220010
X-Proofpoint-GUID: ntfxy-SAy9Ol32OVv2hpFKh9kKCooMEl
X-Authority-Analysis: v=2.4 cv=QM5YgALL c=1 sm=1 tr=0 ts=69e8204c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=UCx1J_JKcbMq7HeDcmkA:9
X-Proofpoint-ORIG-GUID: ntfxy-SAy9Ol32OVv2hpFKh9kKCooMEl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDAxMCBTYWx0ZWRfX7sYCKOx/eZ7q
 sp/itQ3uHIcF4tb4nyUPu0MNzDFkuwKnEt8GA+2P7+JTnQKBe3o+12fG/tLWNT7RFZvNc3vvkt9
 JyKWJ+uUyDSYQbYA6m3HEzqOxLt8KNcvw9ihm1Xu4Z41oBTflIxfsbUX2xyju6sPPvuKJrJJ4gO
 kEL68jDtni+vYlD5iYI+PF0/nH8rArnnUDOzoXTDVpnk2NIyR+00uri1lzi2e9kF6tSvUfuTRyI
 k5NaCl7sF5CMzHlEtDvFuYghj4AUnGQgXGDNorofe8iFYMf81cBlb0YyLAhl2nTrMuQnFx+ukbL
 XB/n76dh9FbwrtQuJpZdNoVnI37Aq/emTkc2F2MzGRi+oSetu1blgkwYdbugUP1p+OJFyq7a8y0
 AKOaX0CnpRjb+2BIkKpy2PGA179lsiKK135L95hT6dmDxzs/mqnDT8nX+xIB5Navshlu4IEwLcY
 GZ6a+5ONQhqao1BwLrw==


Carlos,

> If ecdb_ahdr->ahslength is zero, two bugs follow:
>
>   kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15, ...)
>
> allocates 15 bytes, but the immediately following memcpy writes
> ISCSI_CDB_SIZE (16) bytes into it, a one-byte heap overflow. Also:

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
