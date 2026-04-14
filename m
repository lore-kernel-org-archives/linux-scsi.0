Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D402848BE;
	Tue, 14 Apr 2026 03:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776136615; cv=fail; b=FTQvglJ6thldSkaCT3sddhlU8LGfCYt+/Q04FXSoXmkZwQ0+d9iC6RRyuBBv//P5TvufP+SHJ2lOxUMij1bL7gX3KrPLKMlsLP81xZPlt2BkUTQL8ZEALL9YNVZzW7dflj3p0NOjV1p8O64m3/hjbLTDdo45vzy3FlXzzEtI1d0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776136615; c=relaxed/simple;
	bh=sT0ilTVYUOcxnaC8TRpAQ6wreyjHDACyGzs0AYNSTSY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=q5i5OC1KtY9+WCeTQd0ob6zzvMWK2zBVVWtniCckuz7skJV5PI7kf9udjIrC2aJuN07qO54EXlqPP6UboRP5ampA8dRYE+OHaHv4Zmi5/PJywffU2hpdtIdFzjMNIXgfPtEPidHmllmxpI5bvV8xmx4ZbnBx8o9plXt4mv4PYbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fF/rgnJ6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G2TJfOxV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fF/rgnJ6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G2TJfOxV"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLAimk779629;
	Tue, 14 Apr 2026 03:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1tUNL+oIAhRoTFFrIl
	QFAbtf2rdiVpajP0ALB7uf9E8=; b=fF/rgnJ6KneYy5aPfNZfDZTSgnSS2Kz+qD
	C3/cr46PCECzdxKVU9nfkstRfJPDaMnWpodOMSVbTUNB4xnxwyyAutnsnbQMIaFM
	pVo3gAZGsC2B2detGcl0E1SMFzFdWPmafhY2AYv2tmf5bWUt16mXwtuOWW97TO3Y
	p/YbA0FQeqDs5xsCpCPDbfnSqwp8z+5+38i3SG+vCeodPhn5HFkrWOaejrCKZd0s
	s12iUxSt+kWJCGxtEEDzP0ejIGtPERwwIM3vaRi3u91pHuACDEPzEoUgVuJY8T2u
	IgQXd7Pmyal2QqtuVFlTBkRAATRrds8Zd9i5ttfYoJXNtCcTW6zw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qge9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 03:16:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E3EK7k008367;
	Tue, 14 Apr 2026 03:16:51 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010031.outbound.protection.outlook.com [52.101.61.31])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nj2db5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 03:16:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ezfbk7YaydOV1apCOgLS2qNby/mJpp3VBSsRBzWJpNW7T1Mld4oZcEFgvjgvJVQ9bv97/BFvguBDvzqM9rBW9loFDt0m3JJvB9JC1yFUcPPeNDzcqwCziEo0XR1qrEzWM+6xLOrid9NgbPPDh0erPYYZuadp9PhM9luzZotNbN0k9Or1jU1T90zhevx75asuNtnbUL4F5fqQ4SFdW2gCzcQWIp1YjjlwEdcsWMLwSrnDBEk0wYs/LTj0e4EzKpjVY0tTJE97sU3nMKQXXv1B21/e9Kt8BSO7wLoGCMA6zF6BvSvYCUxBXD5VvHxXL5beM8hiqOkepA8Zcsi2DFpgKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1tUNL+oIAhRoTFFrIlQFAbtf2rdiVpajP0ALB7uf9E8=;
 b=PCtawudFA+j1w5lltoDYx0P0xYQFHjRq9ue3+lxd8ox/DZ2paKTgTd8EYLTHVdFEHqqWRHCSeR98laEL5ON8yKlVerKVi+Thf2ioeDpapizGyvBA2JVhs236xlnlD2ig3NZh3OI4SAC5YJVlx7F/XzTocb/gS8GEW393EyaXriAUt2+VxFm169B46QGr9SFnJ3bvYsSUR2RZVEzkyg7+fkOh7/YDretvwN69wvj76bAufguVcrnIBUreXkxKlwnXri5Ff2grm5Jlc+fys6W8uU8mz+qJ2Unyh0lqmFgRFaJheiBw3bcXheRBl1DmmTTYYMFgVN79RbylqqOoYa1RwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1tUNL+oIAhRoTFFrIlQFAbtf2rdiVpajP0ALB7uf9E8=;
 b=G2TJfOxV8Ar26l6P3AM8XgF1vQZ1elqUJ7DlLrArRPKAqkrHtBWiVphsvBPXGb+Qmkx4LoKEPyQCFlPOYpodQhswwVg3OH6lweUXSDPwBT/kdNR4oQEHJA4qlCog80EKemORIYtYyIqHJl9k+2Ai0f1diY6pnKTSOxRCW5pQz6c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6579.namprd10.prod.outlook.com (2603:10b6:510:206::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 03:16:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 03:16:47 +0000
To: Hao Yao <hao.yao@intel.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: infer lbpme from VPD B2 when READ CAPACITY 16
 lacks LBPME
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260402063959.4005814-1-hao.yao@intel.com> (Hao Yao's message
	of "Thu, 2 Apr 2026 14:39:51 +0800")
Organization: Oracle Corporation
Message-ID: <yq11pgitfvz.fsf@ca-mkp.ca.oracle.com>
References: <20260402063959.4005814-1-hao.yao@intel.com>
Date: Mon, 13 Apr 2026 23:16:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0004.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6579:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a8def7-2e79-4f47-b0e4-08de99d4435b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Gjj55c6tC+pDs0t5DqPwgWDhzSXFbcYVheooOZp449A36UCzJzJ9iz8heBXN4kR8MsHslsDR8Us1TC9lnhSn5vQ3+ED+nwGr2Q2Nnkin5GtihOtKssN0P0u2fdp3s4YqmJJ6s8ECXhsiXortOULjjF1nY+c+bvdLGMkYR47C2lTn4MzdKipf8/Zndazyw26hetIrHijCYSBP6qY1RF3SQRTuYLzn69XBbWotXTl7Q6fXxGxpPiTwNKCW/IvNWkWrcQBP47MH0NM9P5HLpMDFbojURMFtx+JYUBNsz6u3D/9NYZgr0yTbG3704Y1wWU/V57UmL+Y1b/yxHBVtDCE/4pokEj2hQ+pW2hn3WHV3OD3BsIFXw6TapoEbwgFtQ5KOvZoEjOY4bkV8kY8/B74uNp3jMoIAdOVEDX7G5jBaiaW+FiDS+xsoihijyYJDPV9+vj1Qy4N4gMqbxFyJshuf/XFSsCC3PjN+xnv4G83I9oo58i9UeSmHJGy0WNU8n0HhO0/BxuXrQd92UZEn+kkqPA4oIYu+bBQ2CM8XsZKYBbBylKH7c+/Lk7D5v8f2bBm236MP3LCeS4nVKX2mzQEmHPvu0n3CiY4rU1vnQ/OMVw57BiXi/nTTAb/ZkGcJoTkdU+o6bLa9WlPLB7zWGEJeaOp6XggaqexelP8V0QldELfXNzlGl7bUr9PwoARAsPhKV6fIqN9WZRTjzuMqOrjedATY5uvCFDg/8Ayyel5TXE4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z0PHcxjDFcYyRx0NVEiPRrpR/XwWRpXlfp65n4nSDwLyjMRCAjplTGXofmg/?=
 =?us-ascii?Q?foDWYxgMlt8VHE8Ebj1RzDatDMrngR2ntm+awyHlujawW+Tc05Yq5NcGNl+w?=
 =?us-ascii?Q?OgQHkN4HC0Q9rih3D82ZFR+wL+TO00pJ6bdYftJMYNSddlMf+vi1hP2Y9/od?=
 =?us-ascii?Q?oLhYbId1VapEPk+ldoX8KfWgL+LIZzJJNSGb7YmXncyngI8XdKETQtlJO7HP?=
 =?us-ascii?Q?/aX67DvQv/RQRg4EWg5vBE/itX4dZhwkLu2keoBBp8Wzc0u0HC4719/V+E/F?=
 =?us-ascii?Q?RyGZ2okiHQGNPyCMOqMCk2UM3vjjY0DQ/rPJAB45pnz364JFOPEK/mrTsIj+?=
 =?us-ascii?Q?CFjitHGWX4VWb37SijNucVOuOEZnteNx4C1v9E6xOtkx7FqbPyCkTQAFMhFg?=
 =?us-ascii?Q?xexRIH0bR5IAab436rfOW8KNu+9+D+lI/Q7QYZEwhqzl2/7c91i5mM/fGGoA?=
 =?us-ascii?Q?zsrnjTl3oxo/eKlEOD/wxd5uHHEm6uBRk+Kbzk0A8/DVupfw7HMXcD7RKDgv?=
 =?us-ascii?Q?6CBFqKLh59w3NxvLqbkvpnYu+21w34u+OY7Vadey66fPGAt5XGNFdScLv8Ju?=
 =?us-ascii?Q?/rvP3ykxAmV2PPtRAIhNZS/6bawzCiBwvluX9an7J2vLXMBOk4ZEeCWqK0ZQ?=
 =?us-ascii?Q?STJVqJrAVlSzgMJ8ofY/AMB0oDMU1MLy4wSerMT8RYzdlokE5fCySXIttcUC?=
 =?us-ascii?Q?OyqZ5Vgq3ZCRKdBgzWCEFvk6mP5JYJQmAVBt1qP96jXjfJ0l3PFzYCLMmzr4?=
 =?us-ascii?Q?J4cd2JiJaDH72I4Bd8edWPpItEIPlXY4oSaxQvCjmbeI3dYWrzow9axTejz+?=
 =?us-ascii?Q?pWHUf3P0slAocGZP3MWZiQV/wU36y7r7Ayn21jVqLdmayj2fHNMOqcoTGMJs?=
 =?us-ascii?Q?nDBJuvr/f85QWEUeGn1jvMTc/F5jiGtOKWFvpjWrEQlSENwQHJtKOSkVPZvx?=
 =?us-ascii?Q?2+C4gkjmCcajAIVEEYSQ0aXWjGdwv+p/EBAbySqoVIj4CQPURYagZkkvzX1p?=
 =?us-ascii?Q?u5ul9/TehoJW/K8tWw89XTlRFIDsy40KL7CUf+/Mt7CB8Kc9JNyOcmTmUnaY?=
 =?us-ascii?Q?2+NDQ/0DswhRCl1wpwcTSj0WN26L2dkkdg/2pX8XcvkE7XfINl4kmgHGWmEg?=
 =?us-ascii?Q?ogMRJljG5bpZ78P4aWkRVBiImuT2X2OYVXbQTf77oiOCCsSb57/4x8QfA22b?=
 =?us-ascii?Q?i7dhZIG1owSG7A4AwZRovQ+GFnOYd/9UD8TwFDxl2VjWY6Uss9WpRfcML09M?=
 =?us-ascii?Q?6qTGKt7GFTojw54l64iDuhoO43MnKxw+1kyWfWygCA0BaXq5x28LeUySyjz+?=
 =?us-ascii?Q?zaBHfRPGOyXHI7+PWSRj/qlWSHY8j+kzS7aY5ma8m3jZkR1bnfCsS8Vu16h1?=
 =?us-ascii?Q?fhcWYAlGxp8j/VWTARqmLz9LCMsu8ykGFWwUllM+UWmabLp73VeH5Q9SsY61?=
 =?us-ascii?Q?MmNaP7DegZhG6M11hV/J+EeP8t6dOOfi8W+DRV6Im1X0BfMaXTnR8dG0vLw+?=
 =?us-ascii?Q?TXgbMtmU3dduEWRAz53A/7dsTsTVBSH6CYc4gNFsbeWOmIzj8XtoSm8uK5eF?=
 =?us-ascii?Q?tiWVfEowdnyeZNBMVKCTar7vNvnhY/VeEhsR92pSMtZhVu3nrTVuK8BF1AMe?=
 =?us-ascii?Q?xMjlJF0vh4XzluOHBRgCNMe+H+4iGrjNygpgjqy7tAm1/LXkUpaU0vMYeTdm?=
 =?us-ascii?Q?g09HAZn7JNferUAGpWhGfT6lix6MsebOCdkKlAvaPSSxTzNYhvA/oHitVJ1B?=
 =?us-ascii?Q?o1lg6Nq+3je9BhP420RR3ng1uoH55WI=3D?=
X-Exchange-RoutingPolicyChecked:
	LN/drE/o6avt1vLyVgpSMI3MovneEjNmO/J6Kawjcfh4AhblqfkQ2dN/cbLN9xP4EQJRrcKRj+GfxhYCTJHn/st9OosPiLmiy0P9jZUDwswsPge4rlRyDLa0aGwReT1d9fzCv6EdivUnuctwn8a2Dl6Wd6INlQHGw0zQgg/iYKRPOP04EelYVM6w2CTPj5EnUV9i2iFJDk7iAEBKe2cbe4oqe4cWmlyBuiZj6i/y2aIVIsLkxDYZYPLzg+ptqfxbBaVO3boq/wuGsmFqIju33dXFqYU2XD1jQO86hOgHIaaJj492RdoqGyIJpRr1OiDu6NYbA7EkKexRoeG8xZKO9Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2QVb4HykeQ8pWbiu8JKLuIcAD/F7brJnEWYcWhux0khnGdNEVBxjf6gkkxFjgL4yp+76giNghRG9Lk6sV+JJPNt3rj6ImuFZ+MW6hwGQNitmv1OvcbCGiSkTKMQfrXSqHQCTjhke3+CGSJdFFnvpwKb6GdoRl7RHpm0Kkqtm45DcuPRIdHleZTricQoe9M9n7S4sKyctNOgCiL9VWSh3CDcE/+nD/CqcxJcQAOYplNw0ggILxub9YOC44fM3wZsLE6pmt+j/aXB9SWV0wXgPswSfmJr8tS8p+r/w3Bb51JuwCUr/rY645HK9v+1DcRsMU6ZPGq8HcdRT3ADADbnKayCkMGVIkWUpU0kgI1+FeLgEBBLxkFW/c9FmGEkE+BiBVIHDXPzVK0niY81ShznDE7ahncGxt5Y92o1Z4qSs3/Tq9MG6jRbINUD/yUUig2HP5HhVPi38E9hXfyPTXZ2/uHPvPn6WGsDLr0/p8Hk3+oqgxZHhT5AfxPcXN7+jhKxJMQu2xv1ALKP6bYEt2fTZgHUddItrJ9C5Btv9zJTlvSCxjH80txJmxTsZiofOH+veuJEP1SIxqR6PffDzPjaVDQyVZt3Cj2M6q+GZH4cvGto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a8def7-2e79-4f47-b0e4-08de99d4435b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 03:16:47.6974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FP4T0jgN4XXlnhFLZ9henSXzHo+rkyG0gn12qFEUcJhV4XWXArnCgnEMZt1Xkd71VCDv6pzm+hek0jYrqVNb6TMTf7+BToWc+9Lv+2W4ZrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=973 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604140029
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAyOSBTYWx0ZWRfX0RFodbChbuUO
 hvV6QwKbs5R2kLIOa39CHKOB7GVsJHwjmSZK4k9BB47yi/2FAVE8/q/P2taAInF+5TScy5ojWxj
 sAgy7cC1A1TYM1X0MIE0PJcBmQF5K0SHlRvo17QDecgvSxM+Lft/93smENGvjya79EfjES8bTZx
 31ovb42QXtinh+7f1wo1jQ7Ouz84DplgYIq8u91hwF6iKQeBJzarY2BI9D03Ab1Xa2veUGReXqS
 ZrNRmYA9zDphVNziTvdalnNdojAlDYhACGD/6hQgwLuzy+2hZLwZF0kRNySuE1zLfaPmq0rbGJa
 TKWjL0H0SlJQM06M8mJ7Q7ei1kw0CxBCT9FO6mtJ/4OG/9jA1vMg6qRfJmilrKjOTmr5vR1Z7we
 PTu1sfoQQbPaWYKUb9lZsSf+uuFRYS2A6/BXGG5rcgCG/SqLMw2lu+Wa+xQzCAA5Ce+cb1NW6nA
 IIDbIFN/IdhcLffgMUQ==
X-Authority-Analysis: v=2.4 cv=Lo6iDHdc c=1 sm=1 tr=0 ts=69ddb1a3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=MY60QjvaeYGShkKRLfEA:9
X-Proofpoint-GUID: zvxqJgH3OxKgZFfcLaRHmgi2r-GxP6gj
X-Proofpoint-ORIG-GUID: zvxqJgH3OxKgZFfcLaRHmgi2r-GxP6gj


Hi Hao!

> If VPD B2 indicates LBPU (UNMAP) support, set lbpme so that
> sd_read_block_limits() and sd_discard_mode() can properly configure
> discard.

If a storage device vendor can not be trusted to fill out the most basic
protocol fields correctly, how can they be trusted to safeguard your
data?

You can create a udev rule to override the provisioning_mode in sysfs.

-- 
Martin K. Petersen
