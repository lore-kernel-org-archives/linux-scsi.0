Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A7C79CD;
	Sat,  3 Aug 2024 01:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722648825; cv=fail; b=o0yUC9GTk2EvRFaeKAdOYyoYWMzBzu/dtMAnz/NmHOjQ0OxZRY+9HHQF/uBvvuW5dNNdtjhfMXZ+FXuSjoifM+lFLiqQaFX+5NNlOdDiVSrUabbZnKH49Oq5SW9ytpsTLwc/IZ9sOJKWz5eQ6HZZp968lEbza+HenP8qaKj3iEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722648825; c=relaxed/simple;
	bh=Va0VybqJwxP6CvscdbvRh6bcOs9tfg4VQFC7KtZ+cAg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gBGd7hqN0YUXuerEMnxYk6bClOIOjN3WqrwyU+F0U9ptKnbzAzXtJgCGu6g+T3ZRVo8H02HZozo+IA4o1zQjOHOB+QLXEnOED5BsinRg44JXh5lzzIRTp34G5qt9Qj/FXa7RfE2lrF8s9y8Oh4oLS33Fk6yOJPlxmYpIqJPaTG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bRYtSHYU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eNmVFI1v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bRYtSHYU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eNmVFI1v"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472KQHWa002996;
	Sat, 3 Aug 2024 01:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=xGiWkSqsiY2404
	igb8kJ54lbFVaAp9+54zmwzQouslI=; b=bRYtSHYUH/G6mJuRrL563iYCKVz7h6
	jiEABxZJATwIGO00ODAwovl/y9HGVDkU19Huzs8crHC6yFehR8DgLP8OnXY/kgkN
	ac2RjFy6RFPeZHpissz8cC9ExR2xdgmOc0KzTbr72GoukLxi2sx5vb8pylTTA6PI
	c9dgJZKlBBmZeepvKXUjHlDx4DVjWiIdI5KfmEAAyz/VwIAN6y1xGnPaSPlYzLBK
	yF3+0GiL9G/S1cQuydbwjcx0GqMdeQhmCuGfOHXeYaQgtqd4JVgTM0rUjRnsZZ3p
	qpm5dLU4EwF2+DCdNs11t3WUlz2ZzTeQZSj+Z9wpa7fgy9l3c2KuW4Pg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rje8je6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:33:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4731XcQY018261;
	Sat, 3 Aug 2024 01:33:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb05g00t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:33:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkEFKx+JU2O5l+RzXYa6HxhYEE1QCRHuGAiFFJbvPcqnLJgUbb12Sk6kTekg0G3p3zm3/QOcYpKX9One2BJFCMuhq6poPgzZP6Pb4JijmB0UU7a5FIxnKU9RV8Ztmo6hAaINCwnG7p0SnPZUZscUCd8rEl6nzD7U2J2MgfwKS6PlbLSYaWvd0SL77Jhx5EY5kbhoK7LLN5z0ngceQkb1CIAiCMfdxskmhITjIBM3NCsO0BZ+cRu3u1O1+WmN4M9LynJt9qSNtttZZbLmhEm8q6pcqSICiTAyWksWvmGNMhsn9aRWOAT37k0hCoBZfC5Ji0grQ5Hsk/lkvkljkNCXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGiWkSqsiY2404igb8kJ54lbFVaAp9+54zmwzQouslI=;
 b=vqYYGxPzX/JcVsom2BR5f226fPYyXdtVb8sNr2NYz7UWz8Heeqxl8G3lMWLJo7mK4rcGUtRuZ1NnWuGovjgBrwUhqr74ID0fAf6V499CK8UEj2WpffEZwZqtnoT+8DOd0NUVpYRbczn8lbdnboU5N9MTnMhLv2RRRgpE9eSoURqIM5JM1u2EFdMNXD6p5TFnLbv/nb1tP1hNTvdRQac9Um/u8GOdZOeIkrd5yTz7QQnDa8Jymd1dD0sK93F0+J9imU/+eGoE08LXWoAdqC0+sjLE2AV3wkJ+bLRF5pQfQtlg49rvpaTeUR+XqnjY6uFXjmXSK0aJzqQxLlo5bnZH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGiWkSqsiY2404igb8kJ54lbFVaAp9+54zmwzQouslI=;
 b=eNmVFI1vykLQy33/AIdGnwCfviRzX4IqDBwvZlGFwYSh/lVilrSGfrjaNdiuHOAyB1SbCe5MH2ztxk6rrld5LwxNn0opKld+j/ON3HXlLb7XuUAQKQMCan9Wu3YMB7CZZq7ZTdRfM9UV8SEEaRdn2IzJ98zpHfNQ182w+SOghu0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:33:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:33:22 +0000
To: Kees Cook <kees@kernel.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "Gustavo A. R. Silva"
 <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/6] scsi: message: fusion: Replace 1-element arrays
 with flexible arrays
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711172432.work.523-kees@kernel.org> (Kees Cook's message of
	"Thu, 11 Jul 2024 10:28:14 -0700")
Organization: Oracle Corporation
Message-ID: <yq18qxe75m0.fsf@ca-mkp.ca.oracle.com>
References: <20240711172432.work.523-kees@kernel.org>
Date: Fri, 02 Aug 2024 21:33:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: ca1c9f3a-d6ed-4e23-ec65-08dcb35c42f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fl7xzF0xzldVFTS4vKs29WwWVHysjVdwPtIp/kDvbZPPv1ZjuE5n9AmcfR7O?=
 =?us-ascii?Q?1tiuKhvAiaUfbhnXnZkgvuS0eB7aFfrrWmQVHEwMvOmgI50silycHhrsquyH?=
 =?us-ascii?Q?GFIFOUA5KpBIWXRrsyVcxUr/zvHuKUIPVm18UwZMoH/9LhvqOSQzsfvg0yLl?=
 =?us-ascii?Q?IJEVdl+6CDPgalJYFFFj/Ov5BflnEkvC6Qz7VgFhP/MOvpCIU5n1WwnIawh7?=
 =?us-ascii?Q?iZwWRibosjikpEIlX9YUDal+7/0FyChUh7jhVq61M5DdrqUo4JnZjMiBqlrX?=
 =?us-ascii?Q?tScahekeh55h9ZJHjhNjiMJOANgzUeLps1FWs3/Sc7Zs0udtsJ0TTqScarSd?=
 =?us-ascii?Q?6z2YC3/lBaAVNjEnJ60+J8Ep2fbUw9lzISv0g00b46xVD6VBfxnFmAKAkMVJ?=
 =?us-ascii?Q?hprm4dl1wLQiUYxCc1b5dnL0NliLc+j4vArlZD7zrMP9KWqQ22B9JWx6hNx0?=
 =?us-ascii?Q?RSafm885FMfTsLSBdGdOO3gqDd9ZhOuayTZa1Va3KeMnVpeLQwYCHEsvKE/E?=
 =?us-ascii?Q?0ptyYvy0kiwa/5BvU/TXfASTLIz8nIZ2fZQrPHlQXoQyJoKas7GdNQD62dRD?=
 =?us-ascii?Q?mzhp+zJdgnzutuHUcl9sGkeZ3DT/LkTqWsP5N5l5lA0kc+wytqqlghn8gqFa?=
 =?us-ascii?Q?uHxaAH9Z4SM2XVaj+TMS3u8f44TxnbGlrPE6cTbyEuO/5YFGzCm4FGfPSllD?=
 =?us-ascii?Q?fZZJUQHOEOtl+29DvhGOcGWphd7Su2lcMbd43Gb9ymBmyltMmOQiFwkzsYby?=
 =?us-ascii?Q?T1++DlWdGptuClnTweioU1JoxXnfrRNjMUM5guDdfTYwnnHQ//VW3yqNHrvr?=
 =?us-ascii?Q?uFj69UnbTbVtwokriRA3qZgOTC+eciB+MSP/LuVT5SiU4kcK67TeXFKnXBfx?=
 =?us-ascii?Q?hMrzVQ8f8xf1RK2Z0EuVWjetp9UzCqnNiZp1FxVbpRFniQogz2MGbHyvPvHR?=
 =?us-ascii?Q?hyAfjBDuDHRRTsNdG8fTzXoSa4n7+ddhW485DNOAL0pXIv9x8RN7NxhYek71?=
 =?us-ascii?Q?G3175CsV16t7ivSeOStORdeqzGft/vauGg4R/WqdL23J0+f9HP/kG3vYgPRm?=
 =?us-ascii?Q?W/YvzNKlaM8WnN9thYcP/ZsuQNL5dEOH6RRllew+4UZ4iHOwBYQMHfEqVEtd?=
 =?us-ascii?Q?qf0bi5sTKCoJ4YB5TancIxsyAcny3ApyN/YV30u2Z8Wno+S3ISYKCn+b3AZ1?=
 =?us-ascii?Q?axKdB+ZfFo/h+LNOP/hvXKHiRI71haQ3QGgV/m5UjTNcNN3eeQyj4C+ajpdq?=
 =?us-ascii?Q?WfzJbgWeUH/IZJvz61rFV1LVJpH6bLodAKtwLAirlLerkrbSLWLySoGG31oR?=
 =?us-ascii?Q?4v21QJxevTqPh+cr69gc0IvAqZI6VADPqbXhGNO0m/qeNw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kQOOAlbqsLXezX9Ltr0NP/plG20qXhmc1aHxsQ6ljl9nQUk68GUA+0QMHz5V?=
 =?us-ascii?Q?xFuiqxb6Ij+AROiYi6YzX07xCMaP3mtcGsJORELvaSHRRKQQxbAInqJJG3MY?=
 =?us-ascii?Q?CK1twoGCS6u6lWqWpw02XHa9/UfDotSfb9Pe0HFrpA6k5wBE37lEE81ElVBr?=
 =?us-ascii?Q?mGSScoIAhhbp1J4PK/omqyg7XL/Z8qcoY05PjY2YGoyy+p5rh7F29BWzyVqD?=
 =?us-ascii?Q?xFjHf+WWqlloJWGLCTCXVnPnU4Aj79RDBMVO5TFfbe6Nmhw/vxsyafduee2c?=
 =?us-ascii?Q?XR7m/V7JuzCRcC+OwgNJxc45P8DyhhSXxhJb+aPgfB4srI+CeWtstBHuN1wR?=
 =?us-ascii?Q?hd12ZX/xku/PGI51sZ3YIgyO2IE28780I7AaJel1d8NVvvwv/ew8nL69gPjx?=
 =?us-ascii?Q?CrFMU3B397fltVqWlLVkUgD19TYg6gT+CQuodYRB35UIE35QeqHfxFkXr0zQ?=
 =?us-ascii?Q?Z8lTp0RE2G6x7GyMaI/I3iWV2HWenjtk62inYuo43SMQ5xIKO2U7OHuO923+?=
 =?us-ascii?Q?IWCad3iPwZrnhmGUpNBPnFxQT1l7FHhrbN8iGrUtoUNMME74MyIIBdXtp9r1?=
 =?us-ascii?Q?cBFbI1zoUOEQfNyYUME2xG75+1JQrwnl3mtAsufmlEVatzqSfc4B5reluxc+?=
 =?us-ascii?Q?TrGSVtqWWWib7bndoqdmHgBydF9KiGwixF0pNZl/KULp1HJPBn9yXKfWq3lA?=
 =?us-ascii?Q?viDj9uHB8klG5XNO5qGcpOgNMonXKKPf4ZlEgXrox+QqnicH3i2y6lU7oIWi?=
 =?us-ascii?Q?K8ICnNSSe/EM211pReGaVp/SLjAUedXj+Ro3gPgRnPPhqGyQ3Yqkji8VyX7z?=
 =?us-ascii?Q?/1Vb6x1Iau2rwppqmjsJ23yqh8O0rZsZwEMsrpuB5hLENFS7sovZzebozaAC?=
 =?us-ascii?Q?8yTcCI+8eSP+Tq3UnqwZZJBY80DlzruifaSSKLBb8vUVt/Fpz/FjtucbbuqW?=
 =?us-ascii?Q?YQG8S2MPVF8gsV07InvBXqEWwnGWXSAk6h29LuPvBHK7CVJWfq44fsLKcOmi?=
 =?us-ascii?Q?ZXG2a567ipDc+Iha4dGKZmuZNJGGmeiv8w/MDtTIAQL+E2GxNgvpkzC4eaHg?=
 =?us-ascii?Q?UST60OSpeuOoUKmaLD+sDZ4yudfXRCZukPDv6X7Jtfap5LEEr1X0p7e+Olhq?=
 =?us-ascii?Q?S3Y9JZZMGiuKsdqp7ee6XmgFEB0zz5ehc7AGT1rXwXAbMFiI4af5Ge3L8OTU?=
 =?us-ascii?Q?u++I/3h855Gh1jv1g4iLV2QqDlckZL94BgZPDDL8RJ3Pgiw5o6uErWeKBOho?=
 =?us-ascii?Q?wME930K5h6e0PssfWTkX89idbqgoeLXK5RXiTKUXSYRmZbrs3BqJ/D+LXhuo?=
 =?us-ascii?Q?qVWiqffprnOH+xzEG81wNgpv6jHBFONtZVSYNvXvENQc4ds6+e8TqsItguYb?=
 =?us-ascii?Q?GCnY/jAwoBVqz00fnOjBbcaccz5XaAi0/uI2iuy06r1YhHilhzBbgyfQpDDl?=
 =?us-ascii?Q?TumU2kBOJhSb0olspd18ZhAuexQnE5MN4yvzK+W5FrODDTS9gIvdu2+JDhdg?=
 =?us-ascii?Q?qU3ow2x/2PhQpNnd/SidyLn5v3zYUVOalJ+dJc6aps7pclxB+rigClOF5TMF?=
 =?us-ascii?Q?GL1fDXB4PLcOSaIuJCrFWRIUCMDUuaRzpRe0xx1tBoiYJGevnbxv2EyPc4M+?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f5n9MeHmE0E23rwFS9TEXUDX6BFfMmeHiHv3DbziDKrRB/PO6vg6Ch4IxzZI05fbMYmG2pKY8yTSQ6dQyfT0cYs5sXqIKI7XkX+0mnlsO6t7z4zS8xAzLec+TaT1kQzWHCjApH5752R74ZUN2ljRoPoQvtKp0qtS94V7im3+aGnQT9Bd5dGaQEC+2WguDDuOBntI9oG7VTxDOYdA7iWPmi7y/s3DDTJZmMMfpJ/FpAoQSqlEp3UOyFjpCyrVwNtXVJVRdVsYeBpPWr/pCJ72CTdO2+9mSia3O82O2RKnu7VdUFcrc4fOi9tnW+cRvpSsCZ1KalLaV2ojvKf8rFihWL8leLkkWmb8YA9Vl5I4BZP5jMy44V1BBKosxx9192hmYXDHNVlPVlse2r4nL1i476XpEbYayc1Prb4w0hJ78E1d7PQzHQY6G3oHY9h0vB+dcVZhN48y9J2Rph/CAntWH2a2MMYEtfD0NfluiRRXJ2pRBOmViXU+Z2Sqo65i0hndHf5gPh7/WXI9PN8Vp6JqvAZBa+wUtSRqjW8eZGTJ8+IYxbdQmNSSJDGIaRKB8qrtf95cCmLoaEB9gjgB6yanjmqhvauKU/kWA4YsYlnL0Pk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca1c9f3a-d6ed-4e23-ec65-08dcb35c42f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:33:22.2967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4+1nxXLCdzztpkaeiFmcxW1ZhCvP8qQvldhpoSf8BadRz5RdwSj07KFKD9zMjMJoXiswYUdc3zeVbNZ3pfLAzRGOT6L057tXA5KdNv/+j8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=786 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408030008
X-Proofpoint-ORIG-GUID: 58TyLHjjscfGs1CmJRuD8-7suvwZB86J
X-Proofpoint-GUID: 58TyLHjjscfGs1CmJRuD8-7suvwZB86J


Kees,

> Replace all remaining uses of deprecated 1-element "fake" flexible
> arrays with modern C99 flexible arrays. Add __counted_by annotations
> at the same time.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
