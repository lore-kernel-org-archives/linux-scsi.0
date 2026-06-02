Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8666133A03F;
	Tue,  2 Jun 2026 01:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365188; cv=fail; b=P91scLqC1CKorV7EOlJ2nahVah7zJgHglUhlmb5l3NSOYCUM2YYUCQEMBo1CQrL5XWkwyyrCtv3BKJAuUvk9EoYVKsmbWBJX/M22yuUa2uFLm2Mohv0FhlyTKwAcbN91ex51lnuCRebOhGOOxYwdGhkzilCVLCRF7S7m+p6U90M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365188; c=relaxed/simple;
	bh=AlVJrgzbI34aeq+XxJK1zbEap4UUFQ4AIQtdgt2YGrg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NdmIdcU02M7ThJkbgB9MRF6Ssv/rmMSggeYYvSxByUqCgcvcwj5dyMQ7KNwv89RI8TDTbP7tWm2aZk9CVALf+gVP2hQrxkepluKHM01rpR8ciE0f8pTg9Bjed1APG3vikoPP1jDajFcHY23gP8Lu71aXhaFZSfGnfKS9myddCMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MNsyJH7G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wEnz4f2D; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MNsyJH7G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wEnz4f2D"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gu9lJ3467533;
	Tue, 2 Jun 2026 01:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7t4GY7xxVpyBitwa+a
	mM3AFhkba7WVNftvfQRSRrBFc=; b=MNsyJH7GmaIrBbqYyXee0hCx8BlRjnx/Hg
	BZxMQNnvHCTJk/ITN9Kt/0vc1FxI0hlSynksgIntFUGGyvAjEpLAKKpHZt0cES6p
	EjeUXP4BYt1XvWSH1K+vTS29YbKM9HFUWXi1uonsgPIwn2UjbO2O+8MoHupBHyIv
	RObDLNi0Uk6IRP6GOy7dr6oekveYfpOokHNVsZE+22BTC15v7L6uq/+BgPZ/kQ1U
	chVD3bOJu8zydIVOgy4xrZMDlrI3OVWYugXErX1/tOJhoDqr6j545xZ5YUeXYRop
	mnT2M33E1uEDfjEBxb+mWVaU9hpFemHRc8lMTf+a/6KaVBNGEnvw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqxdb7jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:52:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521nrJk026007;
	Tue, 2 Jun 2026 01:52:57 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011004.outbound.protection.outlook.com [40.93.194.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc616h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:52:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssrNQXoqaR7VNJrXcA7BcIgYNNf/kpEDTQu/m89fS+FoMCF828rIo7snKdubBQI6c+pLQPdkXK0oCodHE/V5mi9+nXFYJETemSM7RQdpNrxjDDR6Qg3BzBBRBlMnD9I4SxuGLYrOwMZX1/VbIgl0WGG+IyIbeLqAUf81j+AeWjo48DfUFspOCc4Wj7QvSvU5e7NV2NH1NQ3JMJ83CT3M+3AGl7AVVG70asBu1on4hYXuN+WvhEhVLrj23As4BZ8qYQjb4Bi1/mwqZxjIsyw0h4gjJif69vMY7H80tZC1HTznHoA53R96Hy7gcmo5ye0O9FHJZ9kEvPnJ5bNSSU2H7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7t4GY7xxVpyBitwa+amM3AFhkba7WVNftvfQRSRrBFc=;
 b=b0LbFKvjDjoqYMJxyoHyI2mP8MIm9W/nHnqw08hNI0Clx4ufJlwq03tQ7bISRzb/Xq7JxH15uW3a2gDBa1lSfkete/wx6MlVU7DzRbbNFumos10Xr6bsOT5ecAn38hUf5kfeOxNNBuApx8LWhS+DeNZKO+eW80ft1vFRkbNm1KiOIN+5Ncw4zMahYsHM7STLdxj/l+5ju9Iv5BDWesOMkBwz6KC5t2MLXTnLMj2ou0yj9ECzoNkrtQ1mcwIXeESwxtxYsq/h2vegqXBmS8KucO9J7CwcoDHFS3AkGaxDxPcVTEJWsb9odXnazqF2DfNHO3mDji4T1DtuDC1rDzeGiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t4GY7xxVpyBitwa+amM3AFhkba7WVNftvfQRSRrBFc=;
 b=wEnz4f2D+zEMpA7dto+47N6FTPncXWy3d/MB0ZW/2sCAxPx2hKuOu1Olkh6dyVVX7mmATJ4EBNxyUHo89450RCv8yVvCeWNgCNRe/jvMeywWo/uhyZcoe+/euJzxQQn8cNXuctABbHe1YNsUZ6Dmqr61udlxM91IoTSoU9fSiC4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6729.namprd10.prod.outlook.com (2603:10b6:930:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:52:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 01:52:54 +0000
To: Dan Carpenter <error27@gmail.com>
Cc: Deepak Ukey <deepak.ukey@microchip.com>,
        Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Radha Ramachandran <radha@google.com>,
        Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: Fix error code in non_fatal_log_show()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <ahs-bEsBJH0KhnsX@stanley.mountain> (Dan Carpenter's message of
	"Sat, 30 May 2026 22:45:48 +0300")
Organization: Oracle
Message-ID: <yq11pepaeul.fsf@ca-mkp.ca.oracle.com>
References: <ahs-bEsBJH0KhnsX@stanley.mountain>
Date: Mon, 01 Jun 2026 21:52:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0167.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: f5cfd786-a7bf-4aeb-7248-08dec049a976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qVAZ3E4DpbIz5rIp8AFedLtnjG1dcctSrILX6VGB3SNV0wFomroPKYsnUAT+b+fzGRBYeV0W+jyzTRrtkPgrFw4DJwTu2SFseBUXlnlHKLhIcuFIi2REhcnIBS26rjWQv/gh/s++7f8z47Ej0uBGWk/MJaDU/tWeqnO+8s+koCgZhUVlj2dzJK4Hnxq8WZJb+cwp4P7BfyS9qAzfSXg0Na4yT7Q15+QpBYTdml6CzTZFd4WVd5tAO1gb/B1x+F4sKQSOZbqp11U+7N0NqXUkANeY2NrfMf4GBPgWlk888WQsliPffYBmwgWVtKQucW0ktGbzceLSbXAPU52d4CQjFjWOPwH80O6GWlbNvZhvjnzqSPtRs8HXlJzjQqB4C7WfXKDn631qbLp6/qqRdYdahrw/PQ1r4ghjuNg3GcycDNCa4RlF4YBmYiSbTF+5UsQbEoBUscRurCltxKjU7r5lna/JyInpI6h7H2//hi1jLkt/uEAxHS4ma3iGc21ZFUnOSfyl7jcdIqou3+5Fy80D79r+0+Ype05JOOP2vXt/RpfBqEVrPx5nyeTRhlEq19CFetel+d5dyjArIfXhWbAUWpZRYIqwEUzd3nLfs8zXbYgyzEAe0KK8KY1+hr9JiYzykB7wzyxDC646z5KMzk6uQW7udDx3USR4SfD6ccyCPdN0WyISch3NhgqG8Xm37BXt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n8i+XIJo1LB2SmG7KW4XLPC3IemTszrBhdSNdiramNLKhxvOQFWa8sAz15aX?=
 =?us-ascii?Q?pX4dh+ltVfGoDOmV9SUC8/9h06zMiruzYYCL7BxtOs65Ao8/pW0jKszdQxBM?=
 =?us-ascii?Q?6C3nonCxFtwN4WAnv2d1poLT8r/qVhOscxz2pSI9QE+DMBq95Yaci+3E/KyF?=
 =?us-ascii?Q?dPeR5ZnmLcMpOnSv/0WJMm1Ovksj1LU96AI/WK9hr1C+LCYo7xkW8UG7pbWV?=
 =?us-ascii?Q?bziUCfB+WAmrrF8pHAsBtbxRZQ2wpQN7TPAmQFk2vNRvGldr6v4eJUUNE1Kd?=
 =?us-ascii?Q?TZJXBBZuZH8cntxYG3g5XFlUxiv2UX6NHGbvdwnUdDF8n3MSjXqVANuYG6PH?=
 =?us-ascii?Q?MkxdXrDXaDdvJgByQhfScJF9HXoNO2DYlx6p5BC5hp8FAD6iZBSzZbBkwTvx?=
 =?us-ascii?Q?kdXOajYiOXE7ky5S7e7YoUodqaCZ106RROg9c5XthDjkF5ah3/7bTwykblw0?=
 =?us-ascii?Q?fAHg5u3YsByazMOkT/RCXT7K22ijL6ln1tUG7kKnKUwtHktOsooWXrZAQZHe?=
 =?us-ascii?Q?naOMabpiLYYgjBpZWWFCZMZnN7TcPYwY4A++rfJCKLxI/Qi5RBl5SXhrS3R2?=
 =?us-ascii?Q?6mXCSl+LGXkmsFsfZ+vQG2a5oR4spJvjekSUr7N9tlDv0IiNGPjtVYv2lxNL?=
 =?us-ascii?Q?uEfrNvTMeb2s6zVAnvN42DtnvNSIqi5ypkUNiIk6S214FLvYLvcP26JAlPvc?=
 =?us-ascii?Q?lT0lxd8/uFPUVwUwp8VieBsGzqQVCGRySQ6zFtt/psrV9Y1Vgkl6f9XmTMNW?=
 =?us-ascii?Q?VUhRGB1qvSPJd2PtT8z6oyuAVioFwNAIZLDZJZ6qEoXcuBwmvipgZ1vUhb5e?=
 =?us-ascii?Q?TphcA0AlsvA4SIMsfHuPYOaR6TgxgWSTqi3lg8wIyXHhLejqkQIoYIC52Fwl?=
 =?us-ascii?Q?MgTj76VqRKBXpbKQ0FfJYBNugFxkxmvICQ9aICtprOHmywAnP3VX6a0aL8A5?=
 =?us-ascii?Q?dyO55ZR8h8rF8FSTqNVLIYAoPeAEXmTSR6cX9c/bFxS5xrqT/cv13jS7WLil?=
 =?us-ascii?Q?K3zVYOXkTC90tBbCwLP5mDImVSVBC5qo1UCsAHW/fOsVYobxXL7H5FJVsD/P?=
 =?us-ascii?Q?DVCUq3OcXRzR1HvW/4Qs5jp0Zv66ZEW2yovOiUI8ds5Wsc0N5hINV2GjaXUJ?=
 =?us-ascii?Q?9gukNWwG2F938xe3yH9C7N3/W1bl4jIdMrxpmoFHbh6PpUPcgjZend+oPWCY?=
 =?us-ascii?Q?ToC+P3zx0/3Y5qmr+QGeENNlZRcR7d8Lbu95Xh38ZCcbgP8YIEk4J1fgb7ii?=
 =?us-ascii?Q?umhKFcDteD2XcyvDGP1F57vuptqdq1FbjXGolXwPLCJ4ULGEqmLEvTSV/SAF?=
 =?us-ascii?Q?lmRXze0tx8IYC5VqTlf8QcPmfQeNYaICe54h8/yZhySvNLv8Beww/y4rCPor?=
 =?us-ascii?Q?MDfvmKIb1bK0pXYyXsnOeXT7XanuZrMIWh1MpYdSnEIwIH+OCs4BcUtyJap5?=
 =?us-ascii?Q?y4GPysuvmY/BWYwYzbnwzNsnkCNPDuetZmnbY17XK2NoVQTRp8ZKbmSTd86e?=
 =?us-ascii?Q?ih2jUSnmwvDxbOzsfiiqwa0miQVR+JjqgEaoGZQCpeW0PPfWtdZKspENzB/z?=
 =?us-ascii?Q?bNSS2Ltzi2/dM7H/2ovvqJOd9O/ECgCsyFWPVpsMJBaHOSAJd673uMIl5+7f?=
 =?us-ascii?Q?WqjWAHIUnWog0BnGfSAxw6jeBoWBxbQHJccEULns+wRCot6ArR7Nwlebk6N6?=
 =?us-ascii?Q?2LwQ/z479yScQPWkca9O9IqSZBmeXAKZzuQSPh97ryCoh//YmmuS1pknyyl4?=
 =?us-ascii?Q?1QDkJ60q/ZRcNRsy2yBRd3QP7V93qB4=3D?=
X-Exchange-RoutingPolicyChecked:
	sk4nC31av1gvyIYQ2pEhkZNQyB4WIAz43A4bx5vpYLD6uyoEGthpi2p3YXoYsA4HiTgkI3T1Kgnph58Mz6bi9Z2lSajQNVjd7pHWhSw2r4YtyTIIGJZoacNyEGvH5cvpIBFO9OOO5V2+fwcOaknJsff1mzCTk7HLfcNP6VGNR4AG9LAJCwh4EjlZK1c7kLixYpDAX3zKLSAxEfFHOynssFaed/6r6i+I++NvmmtkTolYq4xsigae6XfpcQs236s0VHaszUTH7tj1jdUn/cnL4igedL7XPilVs8V7CJS3CJYEDTQnZDqgnPYX6iOv8bY9BEZUeZjq9CHeVy2+4al92A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tvYTXuVQ3HG2EP/VCBPecbWFaK15sqHvjr34HFkMWCuCA3zGuCEwEnEvG5ir/k8tkIUVzSIQCaXBXzjdt775trwuhfmrC9s6XweDQc2EjFeVLBO2gaWAqCB5fC4truW2QzD2rXvncpSUn/uzhAP9Ya8zDt+AbTPMarbXlqrEo6O+19o1sUmseWSxI832MVfKjHvV5DpKLvGEVf7boXlzY1wKt3mgwsdBYygnzKQqB7oaO2h6p7T7tqNq1Ui8CrBwczkC4R1Wyepj2iSfbA6yLWi8NjI+7q10UGwrYzrq9kwEhJd8XBFxirbGISjYgDjopXF6DCSqS8uqlCVf/JMwWy2WFL7RRcA8yyTp0G4z6GZdNCdPtAH+8dorctSjvRn1qzHVgU/nPuxaRZRaOYgFO+yQdXc9F3S07wQ6iY3lP7JSo8gEY/oA6AW6YAWY8tO6zAacSduALJhG0I75DObQDxAngRhd7MgqVXi+m/PU3ZGpkG8fN4d35TyBAU0ohdW7DoAqP+fW5Bxl68u6ORmHa1YBggik/vzKyQeZuMrdxE32U1E6CDx5nFhRCpzUAGUVwFvVnKlLv2AMRDf1u54oiweR6fdndPpQV51Kw77vgK0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5cfd786-a7bf-4aeb-7248-08dec049a976
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:52:54.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fL6k8oejIqo3+fpPtsAe0uPyg0FHMUH4mku4EGJUJ0aII6YFmRVCSQCDJn//KnbA7bMTUATEKZT25/a5FF6SYf3PTps9uq5M1n0qAm5s8cg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=807 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNSBTYWx0ZWRfX/Zi8oDWEa+4C
 5sro1154ks2kIPNfP5TNCTATIBu7kWJnTHzsnMPwx+cb2ItM56QPe/AZfnp1gjPE1apAesWJZbt
 C6600FYyVleoZTB8NYirtbXFrKJp0GP3uq31wtmpSY2Ia3aKH9nXhkJt/7JjxHrXu74shczgXBg
 MYaroEj9ykHagjBuqLs96rPyVmzVMJEetMnz3vDvgJdK/FNvdKaef51rfk18HdfKvCbD2RxWdFP
 2gCfMx82c7KHkVha711VeRmdtko7aFJCjo/7BID7X33dTnPkM3mt6416vKVSIiddc6KR7WiY+bg
 WhpCWHRLoFPOdozHM6lgEcb7xsWMS2DZqqnkeyzXGUj1pYi5AQmKkLsFHcb7z+NFAMLoRGuG7mc
 5cVC/ZmzWDpoA8Oylu1U7Ug+zfm+9yQuDEnfrVX+fX4C2g0MCb18BH6DqP6TKhFO1KZ0VEJWf+J
 aRUhkZ4+qsnvVtxdHYw==
X-Proofpoint-GUID: vw2PMocb5hcTjdWRZnGah_Hh_j2kQi5N
X-Proofpoint-ORIG-GUID: vw2PMocb5hcTjdWRZnGah_Hh_j2kQi5N
X-Authority-Analysis: v=2.4 cv=Po+jqQM3 c=1 sm=1 tr=0 ts=6a1e377a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=WwpDaH9WuNZY06HOqTkA:9


Dan,

> The non_fatal_log_show() function is supposed to return negative error
> codes on failure. But because the error codes are saved in a u32 and
> then cast to signed long, they end up being high positive values
> instead of negative. Remove the intermediary u32 variable to fix this
> bug.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
