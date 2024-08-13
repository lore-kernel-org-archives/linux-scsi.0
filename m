Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7E218EAB;
	Tue, 13 Aug 2024 02:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723515144; cv=fail; b=lmfWrS9oDBBUEDiNvhhnonNMch427yj0WtfU9P6SSu4t82BxqnJeFjIhB7vArtPMpAzZhdnOejIrXFk/1a377VYxG6xS1Tbycv3Vp1N6XbriP3J5Sh3ITr180nc+krUqrABoZaubA9UumtgGVOq9TI5vdSApPOp7xyHq1oCgxO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723515144; c=relaxed/simple;
	bh=v1DereN3IkQ7xmXTxpYuEvQRehggBaInYAfhnMMjvcg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mpq+rrLS7EJa6MLB6NQBgqeHsE+gIv5c2ssHCrsqKXhcY82YTQHbZMGTtJiEdchk6JpPhMeZcB0TiqEXUW0cHjcWfslMGWIIu/PkERKf46sTAMxcPGWMFMjcyzrejB360m+EwM23/6JVcVTUTic3ezFTBBzRDY1e+sYf2Hub0tY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IGj4HAlI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EHkSC7Ct; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IGj4HAlI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EHkSC7Ct"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JG8011566;
	Tue, 13 Aug 2024 02:12:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=1jycRdehVXZYs3
	8Had7Jf0smMwV0cTX5S7snoWs5uA4=; b=IGj4HAlIlGYAK1QI1CMJqdH/Qrbufm
	Zv8W/Dl4DLffdjWjgTraXNy9Vb8WwuKGi56xrwE4+n1bgd6k3S6S4SndZ44yaDzG
	SctJdpHLjEWe5RJT2c2TBGHDciqzBzPzmNoHP8jdHD9dI8HSmHEG6MvhmtzvmODw
	3ixf2FdBnp4H3q0V07krr1/j6EktzGKmuVCUS8egigbBs4m9fQ9pPRBKRX5RuxhP
	nqVODqNet8aaCnTAF1qBufLWU3aVfz7wP8pSy4CcRcI5M7fLTiRi9TQmCGk4w3gU
	OaBHhvq0KCIw5KRE1ilKrTZkDSYiPt3MrjW5yB82aUDe63wDHfcmDV4w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wyttcxwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:12:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CNxDWJ003446;
	Tue, 13 Aug 2024 02:12:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7vkvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:12:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9+gJLKSuM44PcMHG4+RGF1wBMILLIqbvopS97vbpUJZ4q8IRIwc0M371zkbsEgF4QwduMuAorXl8Wpq0Xw9Ypf+gH6mlPO1GQIuPgPCDVHDk3QY4CZfS9/bpdydII6F+O79Eq5RSNlyqVmUlYIlpGTXm3NUljS9FdjNIEfTQb1E7esc2LnsIH77iT2pZK7SX77pV1z0VqidQ4BeaBoD5fcFUqdA0epBxEPGqYAbloSDuUpyeYGCZ7y1CgnGIhfduzTvq3NBQ6wRPTx14IWUh8waldum7057PlnsuYfYOBXtQ2CanpN0bkF+MpeVFl5joEXYISdizW7ZaM7rUXytUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jycRdehVXZYs38Had7Jf0smMwV0cTX5S7snoWs5uA4=;
 b=KDBxGiNFZiqbURU0DwhREiHQou5xOMxCY68cWtzq86bKDpUrt1TaukAIEOeafC4X2Mc2FYyrt36JLJVMF5XyL1JlBOKxBQOy6OHxIhzMOtvAOUfQE5lsbdQy1axd7EBqCIpVFYpVzWnzpIOvxEzBrM24avLaj0U/xn5nuKe5A2twaVfbRzIewzK2aOWR/e+y6cvpnwCAJdMxRT+OzYp4qhWwnClot9nAj16wUuFkth5q1/p1pMU8k/GyXT5xMdkTRkT3nhuhLJaCglsqok0jp/cURp/eFABumyE+KeGOui4oQXDw4ErCJlgEL7wX5PiBezIODTs3D5ARLv27bPyeOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jycRdehVXZYs38Had7Jf0smMwV0cTX5S7snoWs5uA4=;
 b=EHkSC7CtyYLNmcd88H4IaVIPpm9/ZuCvI1wJ03M+eWdduoA8EV3pe1ny0Z8ZR9pHOqKWgNmFzwZ8rWUZ4fTCzva8q3k4gOWWnKUh2v+rNY5bk8szEyCdLjoxavxYIETeO6aT5ZSAlzAyaT3rid7bCwp7P2qI0zEVPbKHfCXQt7I=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6967.namprd10.prod.outlook.com (2603:10b6:510:271::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Tue, 13 Aug
 2024 02:12:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 02:12:12 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
Subject: Re: [PATCH v4 0/2] scsi: ufs: Add host capabilities sysfs group
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240811143757.2538212-1-avri.altman@wdc.com> (Avri Altman's
	message of "Sun, 11 Aug 2024 17:37:55 +0300")
Organization: Oracle Corporation
Message-ID: <yq11q2tw4rz.fsf@ca-mkp.ca.oracle.com>
References: <20240811143757.2538212-1-avri.altman@wdc.com>
Date: Mon, 12 Aug 2024 22:12:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0048.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: f3092c80-7f0c-401c-a5ae-08dcbb3d57f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Szjr3iex9gVbUeUaH6zI31SN+Tw2Nd/BUKSzwNRYOKWseNt2p6s97VXQ+p8P?=
 =?us-ascii?Q?rtI1Vm+Id3sJUOKdXSMAl8XvSw0l8XMLCeWP+Hhgzvb/QZoNBgPT48xrBVhS?=
 =?us-ascii?Q?tatAQmiRfCoPlEJ31JG/JXKNvPNG2J1TOGeLT/PHj15cBAt+YA4Bfn7Av7nT?=
 =?us-ascii?Q?1TJKGqZJ88eJDdBk5KTPJ+plGv6LqeV3XtWgyqa8XACODmdXfPBKNMQWS5H7?=
 =?us-ascii?Q?ZFOm03/jDdVEzAtVpvAWdR3z1BlBc0go4SKFWnNh/MtPTI2XsghZHEDX7qhE?=
 =?us-ascii?Q?8CKNv8eyOKN3gNmGBnXDOSuibQIYhCs/9YEyyMnb4yhTI5PmXLzt39+ymr53?=
 =?us-ascii?Q?maG4G/b4gyV/IVY03NQXcr4kwp7luu9dgVS89B2Z/G5JKVRaPq7+dEd/L7pv?=
 =?us-ascii?Q?cKAOPcgHuV3mpGXnlok+AcsDUMFQnwhRKGsJ01qzdaFupUWVnah/i000LQHV?=
 =?us-ascii?Q?8zlCBwt7JXDxDAL8GebPnG13P7vaCWvg+PXIu5IgEvsAzm+CpGN6LPYw/r6x?=
 =?us-ascii?Q?71s2m3BhKR2smCopZXFYfLrXzdKt5DH4mTT2lBMXXVZdrorASbywa0WE2++y?=
 =?us-ascii?Q?KLXTboIqEW+Qy/XsgqHX1CAEd0O7x/Ym++OArrhTPA81xRCwBkUsF0Z7FnID?=
 =?us-ascii?Q?nB9S9TENBlgpieZG6fsPpWcr/H1Sve/TpvhocGG4oPjgWeDSge1Nxy3q64bU?=
 =?us-ascii?Q?JRhZWihLpWfdCm7AyC8dv1XIzw5kuOHlkaQ/xxev5YLGI5LZ+R/cZxOI15Rr?=
 =?us-ascii?Q?hGavZhrGxEs8TO5m+XB67RP45zMFZb8jiXPtqwNuYHFR9MUupCSwV5g5VKkx?=
 =?us-ascii?Q?fOGrYf50Za0u9ER7RIHQf+y5G7TOZUGQxhK88/kqLWhoqzhk41CK8iG/epcP?=
 =?us-ascii?Q?tTRodjPD40LH9ttontDCP7IA0lqyaouKgUEMgAPSjeFWpcBuNv0Rt2OJvNWQ?=
 =?us-ascii?Q?dlaui5vAxdsL9cmpYN+9QOBJDJAokPK+zzXlUrKRc3h4xKCdQBrt74Ec4Cmh?=
 =?us-ascii?Q?ABtzvYUpFdQoDlk8BInGcwarSOKGDX8fahE+2HeRvypsJVrOa+khDUlLr5SF?=
 =?us-ascii?Q?cvETCBUETg0EWS3tXJIaVJc0eiJ1e1pzoJVvF/4YCDd6HTjh4dudkp10hw7y?=
 =?us-ascii?Q?xqfD0vJ6RjQ26LK1RZ8Y2OFGl+2snYbfYjr3uyv3vdxaKtWPh12S3FWeS94C?=
 =?us-ascii?Q?ovdspbnmc09OlB8IRUf4V6hx2+Upzic3nGm8gC6M966ytWwwNQqaw3aTVDnF?=
 =?us-ascii?Q?9AbFmzS3BhpmRdpB3K/+Yd0BvWwJhc3FFtcU7/xmGQo+rhL/6v8fLjPnCLxl?=
 =?us-ascii?Q?Hs2h0A3MauDtC/ji2WBeFrOB3gCAOaiQy5HqkuRSD565gQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hfJ4kPePh5gob7U5dacarEgq9/mjxaxdAfmNsSxYWorFSHYrRSKv0oZRp04i?=
 =?us-ascii?Q?f3PpXyaD6MQk0q9WQtWYqGh/3YU7Q3aIvtEajNRR0r9Q4f8l3DWUZDqF2RfK?=
 =?us-ascii?Q?1/8Mgh2uoamQ9ESzfSMucIpX7tfUeVNKrUCq3Z3pWFxmI41tCz9Ky96/Ta17?=
 =?us-ascii?Q?fT1EIJ87jJ6IT4jZEK0GRWWlVg1jjtNwU+2K9DxF4ShF332gi/l/tsxV2rxh?=
 =?us-ascii?Q?eiuWQDVHEXEdxe6wUStIcPr1J2Vbau7wy2PFzP6MKCeNt0g8aI+6Xz5AmIKb?=
 =?us-ascii?Q?+v+PJHa0fDRW0dBxYR6HJbujpbZpwMolSHZLxa6TeKruFT1aDUzBGO0+xu8X?=
 =?us-ascii?Q?DDNTyaVJqsX11GzP+D+ayqEflu8PGfUB3hQwmtQknDmzyd6fsczT+rz7UPmq?=
 =?us-ascii?Q?8vy7XC++PecFYYyNpadHWT0drVSYDbgBKcYhyayI+howgyMVZ4OGmjta6K+O?=
 =?us-ascii?Q?ptvR0tfX3QDlKRRv0DTXBwVywoxmDnpkueZck2SBVmahVX1jNIwoRubEr5nt?=
 =?us-ascii?Q?ZN2g2HWSogfP3TwjNxb9xCiQs+hkXvj4RuumCheriXPcOk9tG5CTZs6BoES3?=
 =?us-ascii?Q?byT2DR8zGlL5JbQksCyVE9ywmGqlexYzL6fwEaFwQSxQVdfPqDC2Pc0xYBhn?=
 =?us-ascii?Q?mJpygcMdw542lujpe9sA8CAM/YALWrp7OVzK9WfRr7/64LMJupGqkVOHuIV7?=
 =?us-ascii?Q?U3XAPD8Ymou5HomNNvv7/p1yTDJARS/dUPqwjQMvMKnBdycgKvRnYfo1i4cT?=
 =?us-ascii?Q?h/rFt87tA1tacFzNOcXSDjHiEI0xFtXvdUdh7Q44Zbz5LVWr1FzbkTnyrHL9?=
 =?us-ascii?Q?616l52oZTwRszF4z2kJChzbfOYslmANn8OtrXQm868IxQeXYRqans/447Dtz?=
 =?us-ascii?Q?4UzxqFPcbFzj0BRagXzTwwKOcHbJJadl4AjFAcmm0k8a0pynYPXMGh4TV7XK?=
 =?us-ascii?Q?eX1iT0TFwLW6uedbcMjy+yfrYEwcUltWgoTsgQG/QcWfyZxGPSggzUEhmcSF?=
 =?us-ascii?Q?mxnUSJBsagliNqrr2HAuFZUMXOaP1ZhuOSQe2GJWWB0Hc2HNlz9RAooSd+vV?=
 =?us-ascii?Q?2dQN0hIinXRlNQMNPRbCLht38Ti4HVNIvjtQARZ8GZghZT4S01sqdELZw/lL?=
 =?us-ascii?Q?sQwk0GIUI8/ejrVvt7/hOj/nvaL50sbmTBoy/D1XVMoXx6aUuWYkVCBNOlqt?=
 =?us-ascii?Q?GObrc81zktyzBIqMJSmrEbrBM6y1Y8Q96pO9R8TIg5/tyLwHcKKHeJZoGXjX?=
 =?us-ascii?Q?oIfwjkK/V8TNqZIiDYz7LBLXqexv8OGOcC9n0kOd1llyfa4fpoXKl1l6EJ9I?=
 =?us-ascii?Q?PuPGwrdHfufk++OToQemdXBgyKA9NfgZpcvy9qc+pSOdtXHRovlknOLgTJ7w?=
 =?us-ascii?Q?PBE2H6yqf5pWpMmxUBtvyaAXmiCaAQZ17fPJG6UbwrhTSttwdp6h9BFDa/NV?=
 =?us-ascii?Q?rXsrN5ojj4JA4DoptAEtqoTCmXHl6ZlSJsIKPx3dxaXvLS4MvSwnk2sji6/R?=
 =?us-ascii?Q?qY9ibxw3lnJcKZBi8RRGm2USpunqntD+3Hg7yTxGr6PJQ4m5jmPy350s9M64?=
 =?us-ascii?Q?Ka8u+mf/Xc7a1sFI1P7gSC0/x9RdDUSabyr4+PISfDDtM7T+a9NrwUMSm4aB?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k8lYZQV5LYSt4Frrchh/GJbctkuGkmKGJSUBOoMAcbz1vyn5ouN2uj6Dvsjjf5cvfMg/GJOTVPd+ijX+F1lGSRlKb2+U/pe2iJG8jY6UDxhrzvwzGj0TaJTYp8cqcZbX4JPU5Yu372sRW3iG1z4946NwO9M1HgQY/7JnRFovCt9BwVOCKfzkTOoacBllhF4rjFsXJggvADcdAQra3+Ksz/WhicB6GhIOoYJ3GsJ8VcAn3sI+G/4fiGeriOVOnixaV/j3Op3BeCzFp0Zz6Eh1rXJJKSNu6UTo+Ur1UonWfI8BlOsVeGUkp+tQMMh3UHZnIEh28Rud6JQeEaNCxJV8wbIkf3Q7y75auofRIoe046evb7uuLjpaL9gtX44btmtSBeULT+Z1qfxd4k2vWzBaH6+a8PpLGutrFd5JYXLlyRYbA/xl484Izn85lfF4x8d3s93GtpkqZmw8Nz+dkd1T9YsGn/MifZ9fUPkrE5LuC0WGNI4ev+qTZHibtONkuii5Y4g+1LI7npHot9ovcfJ2snnDJCG5KkkX2atgwQVAVEIhaaQD3YPQNPW9Ubg3CzYqWwfMEnagqtiFuPpMZmkcxCwKVReuP8oKO4WQBO62Kj0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3092c80-7f0c-401c-a5ae-08dcbb3d57f3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 02:12:12.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1lRJ5VvGCYMOT+JW6pSoYdeBgTmOfDBVkM/h6jpiP33D8tH0GzUZUA8rkE25JXnqUaYZ61vMEI8vNxR5mMdYvcyqK7EVV0BLEZpl2COsVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=685 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408130013
X-Proofpoint-ORIG-GUID: zlmD9Xy6MRKZLkWYudpExwTZt4RKoaGB
X-Proofpoint-GUID: zlmD9Xy6MRKZLkWYudpExwTZt4RKoaGB


Avri,

> This patch series add sysfs entries for the host capabilities
> registers. This platform info is otherwise not available. Please
> consider this patch series for the next merge window.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
