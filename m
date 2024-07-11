Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2896F7462;
	Thu, 11 Jul 2024 02:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720666089; cv=fail; b=UlCMPr1rgHhkRTt2pwfwb3flGfP+9eMgGBACyX8XAZUjBCTLbxUmz4Nsk2GqlTXt+y0nSsOgT7l+99Dl/Qj+Mu9FvFOloxkzvWqEpW+UB9Qy1U8RrADRTsGuvcWX9IDrU6aJS1Kqp9jiyvqegjrXk4pJku10t4q2XBIqPQpM5NY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720666089; c=relaxed/simple;
	bh=yrSHP9f/45LHmVk2BOU7mlgDdqvx09GVM+NZEcvDYnc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oI/B989dhPmx3L/oHavo7/SV5tSHQlTHkThc7mHhbKfCZ8i6CE+n4vJExSmp88cgnWVguaqlBM5i1zzNCT9JYPfIfXFXUGK+0WumkSLJ+I2htKIIGgzjZSBzBxeXv0T06r0lfRGYxhX16R8xtq7A16OaBh/ajfrLSHUx1q2nmxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FpDqGLKb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ix5PBusb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FpDqGLKb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ix5PBusb"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46B0NN8S019284;
	Thu, 11 Jul 2024 02:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=nRe8uydZaU4+fu
	MXpb8uK3xMAqTBzXNVB+/jNLjO7E4=; b=FpDqGLKbfXoz6l+Nfs9KounsyeJ9f2
	JamlRh35TJEFP/1+axWq6C+YGXYfG2F3vTWTVTfqibgncv1V9QVJdV7MXblQkxxg
	x21L3+7dXpmPXSVSlab6gqYAs8BBWFOOC3g8copJDS7VBHuGfT2te7fh+Ij5HJ1i
	FxwymRBzN4KefwKZ9IVpKybiWgEMCl2Sk/XJy+9CewVdzSJZDsKGGKcwCz7MYdMz
	tdrOjOgfb84FLb3U4fJmAxmu4bPVuP0kWN+bDFpP6Fp4SJ4NhMh+bE9f7udWumcy
	qX+v7OYBF9o/YVGrAdEmgAcskRYRE3wbaziVje/IXX9Qc8EiUlAZ/9LQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky8pv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 02:47:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46B22T6R010950;
	Thu, 11 Jul 2024 02:47:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv55833-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 02:47:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPLHGWZvA4nsuA352hVCdqJLP0H78hV48nqnieYBUaS5x9LbnPfsfdv5tdPOJSIN7wGhJIlTQRY76dB84OnUCMWc3Tt2f+iPXMDyR4TjqtXhFwet/xo3LIrtbUBhC44j98uDPfbGtzltVV1HPV7+67/jaV26kT9jBgI+ryh4lZfFefCZ66lPWY1X9hSHKn1gRbJv8ggP59iP5ui5iBwpldkMx7grCAe+/ZD2aFAMhtcFgmSfmunW85tHs+JUzjR/C7WY80F/eynTxRzR/4hUIcjp+W2tDT5SmQmoBlyYhhv+u2XiQLe+w42IysdgzZ99R1M+CECAVoNn1Jqppdcf/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRe8uydZaU4+fuMXpb8uK3xMAqTBzXNVB+/jNLjO7E4=;
 b=inPS7i1EI8OmIR0JuH7wh2iZL+h5hZ3sfHAeCvrAfhc3r+5FVq30TdD3O1TtxeKgJP34d0csSjLLeUJgE4gnLQy3oizFji+RJOMJuOtBq2fxIPpWCHaWUVR84s02tPqo8kkn25Gt9hx8I8zn1U+9ko4sOwncX2qhziHrWbkRmttlFNoPGugq3zRXugmbZNiX1Ht9WsdqkSGhDetAlY/MOUmTb5Hsux3AAx6DiDypu/f+g7VA5/AmCipdGhHAPvT4jvNorL0w0V9R9hyDoaHMe05KW1uEuyU5JhujmzsZ/UBM0h90hsblMjrzFhtjfijMF7oFMPTcYPfkXMH41vCytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRe8uydZaU4+fuMXpb8uK3xMAqTBzXNVB+/jNLjO7E4=;
 b=Ix5PBusbb18hErFUAvRUIBPco5gn5HbKc+RGiJLwSpKQn5DpZ20ziGa3udZ4A5+t+nx6L3f+N7hIK6PI9JuEhjqynqys8BjAe0tyM9lscQXen7CwI7MebDoZeB6pWGanniA4C8FNQ0f8jOLG3Xa+kEWw6JDv8XJNRK9p/mY0tSA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4983.namprd10.prod.outlook.com (2603:10b6:408:121::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Thu, 11 Jul
 2024 02:47:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 02:47:49 +0000
To: Chen Ni <nichen@iscas.ac.cn>
Cc: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        skashyap@marvell.com, himanshu.madhani@oracle.com, dwagner@suse.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: qla2xxx: Convert comma to semicolon
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711005724.2358446-1-nichen@iscas.ac.cn> (Chen Ni's message
	of "Thu, 11 Jul 2024 08:57:24 +0800")
Organization: Oracle Corporation
Message-ID: <yq15xtcodag.fsf@ca-mkp.ca.oracle.com>
References: <20240711005724.2358446-1-nichen@iscas.ac.cn>
Date: Wed, 10 Jul 2024 22:47:47 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:208:e8::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: aa5c5623-d07b-46e8-e80d-08dca153da2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?8JjXK8Lc9Lmb6HOq9QPIMHJVj+d12uIwTXO+QOo9yhk/n92sXhdC32++78yX?=
 =?us-ascii?Q?qirLTUEv29SJxhgZM81s6Q2LMm998yrtTkUROOMPLsDvvFtkbA0A7jRTINQm?=
 =?us-ascii?Q?/9hdVz9SaPAFXb61vKtMWGx6fZI/3X20g56i4kUFlGqpM0TQEyNCEUzYHAkA?=
 =?us-ascii?Q?gKrgv9YttlefFIBPp2xbgYr4QPxqc/RAhiKp5M4vST4n11oao6YKVzPFCWyo?=
 =?us-ascii?Q?5Ey/viLjAkZjaRSPmrWmTpCaQLFczf/D1kQteMg9Jat7Wu2P31mk5d6CjmGk?=
 =?us-ascii?Q?O02zP9hsmbbBjkjPEObuKR1A7lx79lybv2DqzB/M3amYGFU/tKvFSW3l2zDv?=
 =?us-ascii?Q?HPj84qnjxiUJQqVoGW5J67OL2ix2bpecfnnBKO6L8E+/szta1TiEpv86CWdZ?=
 =?us-ascii?Q?yPdQ5r/Ofgiff2LsHjgI4WsiRpmj1y2cygPVbOevv6qdmjr6NeypxPQNCpVz?=
 =?us-ascii?Q?D4kmdA3o+VxV6FzgicbZA0q7JKxEof3Mpy0gjfYwI/TFaqXy8xAFlLoeaG1b?=
 =?us-ascii?Q?1pYSRmvlY6U2+BJZEzs1l4coJke2qiGYa1V7iJ+fuaer65Xc826NmBaIRNZh?=
 =?us-ascii?Q?Eb7D9kLHFGeRXgB9UogayFdh78tPI52drXgawITlrZphZW15sDuXk+Y4+4RK?=
 =?us-ascii?Q?jXWfuFOlAYIvxrmbSgxzQ2JlADYfQLTZFyeE+3Lj6RZE/QPf1iNU1mXgMOoe?=
 =?us-ascii?Q?doE/uIq2fjG3gtbb2cpD7mT3cxrJe+ol65UVqSrQZR+gZj47oFFVUtNr0Gro?=
 =?us-ascii?Q?9tiQJFhGd44asF3+I1qNb9cZlaDh3HQKhQrPGzO4fEK/Uzauga++e062bpm1?=
 =?us-ascii?Q?bfhpt0VbsmWf0UpVkuDoC+3bL70wedb75EauBotcaPB6N6ukb98vSublivVL?=
 =?us-ascii?Q?9NEj/r6DdkI6MOjzCCyMzD/AnKvSnUWFZJqjNUduQTXdy9/4mbt2KS2tBzad?=
 =?us-ascii?Q?gmPPgm+fch8T89PbV0cgxVXSk+5vYhMFiBy13r/N0CwWUksxPn7t7fyWFc6D?=
 =?us-ascii?Q?z2L+3PEDsaTGXamyILjsHzQe+U5RcCtihc3zT1Kh1ZwMhcqs7xb+iF+9Eis7?=
 =?us-ascii?Q?IhvikH8z08FwbV/p9EbG4kNviNZFr+fmKXozhp2N2In41Bb//8fFRYb1DPr+?=
 =?us-ascii?Q?GgIfOrhutujNS4cU7KPra6KTBOBHDON5MWwOZozrARh/1vhivfqlw3NeLfgS?=
 =?us-ascii?Q?MuzYTobvO22xiIEM9shDGH0sgyw6fuB4VF78nMneWgLmexMsoH3hlDU97mfO?=
 =?us-ascii?Q?2bAwzIRjdStXHa7VsCWK0ysLIirmQFV21Vv/TVSggKsIOozPqJAmUHQOmDZ2?=
 =?us-ascii?Q?D/3SmSL7Wxe4orgq+0ChvFYD1W0qBaRnR+8k/irzMiXWJw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?IIJqouKvLWABVkYaWimlCRqvf49vUCZ/oPkH452zefTQVb08p7uV/jMcdz6T?=
 =?us-ascii?Q?g7pPK67Rtw773oU4WjT5I8vrwIa2XtYgoKmNnLKaWWvbsXNJOfUn2GzXPWwK?=
 =?us-ascii?Q?e3kII1P9TFlz7uFDAMxS9/KvOe1/cJCESY72OJSd4pRNjFQ6KSix6acC9VXs?=
 =?us-ascii?Q?cHqhr6lbrhqE/+DVKcBmFpVtYEggoqyFDr1bjD455TT5KB+qsw/XoiI6yTr1?=
 =?us-ascii?Q?OEr9st5ofM5vpnHLJYcC5gvoUIWk/lOeR8kKz4dVUvL5IlUGf6ty2U4m3sno?=
 =?us-ascii?Q?EgR8PrU5o5yCHTwAsNmBgqvtHEBCNJIQ+RsBEDEJIDWdhr+uvMPmXrF9Uh01?=
 =?us-ascii?Q?QPGQ6iZ3bqakjvisAoGDXu76KNMwjm13dFokO3cBeGJOkbUs7+FedA4k3/MV?=
 =?us-ascii?Q?BnHjCRonhWvdlqyKEdc9fDa+wgEf+o5Ao/nbQG+J5pvvez42oxI+XxNH2Kp/?=
 =?us-ascii?Q?wCSDdeDLA86szUiKI7oUOc3LK+EgvnkCOVOniYGv6g/l35FzoPopVS/5Q1Uj?=
 =?us-ascii?Q?8dO7dZLyMeLtKznBHgl29oRVI/Jyft2zyoSIr94OappN55ajSPGWkgfTNwUO?=
 =?us-ascii?Q?jpIOSiPj9wzSVj57NLqKPuyuvJVqu1FHS492VCyLh9cjBRj55xiXBqmEZGBd?=
 =?us-ascii?Q?yaZmaEOh84HugCRq6lLr9obQ7iFCTtuYHZfVkEn3pB4R9jOcKlQSPA+Ed4bv?=
 =?us-ascii?Q?+1rS3rXX6hQEivy550A8tFGkMf/Pofc5gpLczfZDbh9ZVC5DWZomVtYxA+Hj?=
 =?us-ascii?Q?KQEC8vEw3ob/61c47chfVxQ+UwTdhoO+lhgV1cab3r0c2e8jQuD44Dq6+Vid?=
 =?us-ascii?Q?WpAsiFYEQCSXLgtUF1w/sh3mUxwwvbfWpMEV4tk7lq+jWON4n/DioP5NU5B3?=
 =?us-ascii?Q?Ux46W+b5CklaovKBjBscWm61bFGd2KBxPjRLKFOHDQBk3fMvUK5BQ1f12Drg?=
 =?us-ascii?Q?dzFTOwD2GQ+39uGpqCJXhyfEnuBKZ/p8UBQGYU05aBd9vOU//FuPyiOBGjNS?=
 =?us-ascii?Q?C4p+x2GEDTiO2hBOl5K27TzXjanlVzGG7K3XLoUT0sGPNHQDcczaDVRNAQDL?=
 =?us-ascii?Q?Uh0Ls1BBg1dWq0FEDpBZzwqPXy5kp5DvEhVugF+AXw2Tqgx4FTt1Fud1c3HO?=
 =?us-ascii?Q?Wo3GBCDopM8Xm59cEN1ZmvtO0Nhu9V8J81ivoEUYlSe7D7EGp5PNR0Y5wnzG?=
 =?us-ascii?Q?UDCVhmOZKpQ/BVEQZHW2jtugOTDcneQ7ef4TuRv3s6++DTOCY9LZWuuwaMMj?=
 =?us-ascii?Q?uxFR7w5GpFMnOIPz1sygGLSq07MX+hLrh/zonFtHlWFWoaZ78OE0C/c9HCQQ?=
 =?us-ascii?Q?/g9SKBTVYqfG1wutF0UzOSeob8NJJ2k7KXl2Qwb2CNmvjhoL3vLaaU7mNAmS?=
 =?us-ascii?Q?unHdUp2m4oSYM2KLwXqmRLP7Ae2dQmTJ2C+AG8y5YHAUG8Ou0X+anktfLOcE?=
 =?us-ascii?Q?PkPw6qCi3obWthG4hPDtafrMml8ZDH43ijfyMOwnG2OR46dRvRoCuGQHgi/m?=
 =?us-ascii?Q?08NBsj5ftl5EWMMyo9faMWSkmz6Q7H5yaKYjgzMTHAwEGfA3v+LZvpMjrwwq?=
 =?us-ascii?Q?8A1hFmtMmPvYNq7sC2JAVQFrLYkD+G/9ZVwhU+8vE0d62PNERMsz3uVTfroX?=
 =?us-ascii?Q?iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	EQW7s6gf+08KyzIQK/F3oyhYz/lLkrO4/w8rFYSNBYG95XUsjsOcka0Jbex0Nrnh1c+OEZ47eTKzO6tbdtIE891NXwonKWNU0ETmIkBfy7tV481YS4H2BWVRBUE278Kx3vsk/uY+SGk31+ASP7/Lro7U+gz6fuMBbOPBY0MOzaxHmPsK3CmWan5eqRSXLrfDstSYpxNk//D3gAtvMCquL1JBDIXu6EtWh6gZeZCQPkwq9icRV2aN9JWlh6H/JYk6mMBSzlw/I+jv4HEP9LkICShjUlEQwYHtxPK6E9fdTG1t4/K1U6vvLby09yFSIpWJircr01ACG9zQlKujbmiMBFkq3xUcRNdLrbtpWu/T1yfQ3IB88cd8kUfF3Uzbx9gWc6YNm2RhpB8kk/VC1Zi/Lo22FgTGW5ZBk/EGfV7sjOW/YfxGEARK2ZBbzolp4t76pOlM60/KRKpRpVFEe1lhFlGaIF1zzULepvHpNa3wU1+xcukb/YD+8LdwaALy93gLM3g3AT6Cr3Rky0dTCPm2ZAmuqUv9Pk+UU9v8P4aRt//Fa6ZGAGJH93lpBXIpg6n58Wto7S/39EOelmpVEE1NSX+6+eaj2cPYJl1unzuSkx0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5c5623-d07b-46e8-e80d-08dca153da2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 02:47:49.5462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQCYsScCtiD2BQy0BUCLePyZRrQvn3xqs1HwqeF2J7JRs4shBm77ps4jWODeCnWZw4khZUH2eeTFEa1Z1pkcRhJ+vbf4Dq0dNOHS4C6MD+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_20,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=759 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110016
X-Proofpoint-ORIG-GUID: VbU2Rhf6E65rKaPYs7eOH6S83xMgbw10
X-Proofpoint-GUID: VbU2Rhf6E65rKaPYs7eOH6S83xMgbw10


Chen,

> Replace a comma between expression statements by a semicolon.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
