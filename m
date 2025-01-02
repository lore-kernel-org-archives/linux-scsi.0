Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036EB17DE2D;
	Thu,  2 Jan 2025 17:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735840550; cv=fail; b=uIP40IpmQoX10MqHqUuGghIjL89onKF0K03JB05M2O7P7pLSIxuyYPOyvPdoLCITeY4aB4ezIvS/Zra8YOJ/ubFsKb94/E3Kl1teNqwStrAjvWC3h9CnFNuZocPk5nFaxWn6gkjksNMH6PRFTLw5AhS3A+ctlNJcsjcnKD/5Mrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735840550; c=relaxed/simple;
	bh=6paWZZGeccsmLQX4sYoIUMeJc8SlCLLDjCThoSm7f6Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LkduD5OOY9Vp3Mmynq2M/frms3Z6WpSytGzzMjSrM/1ma644yUJ2emKpLmX8NG/OLJxjzThqqAcqR4U1mtafD0wJqgk+gzqWplu+Ta4dINuNqAGhct8gJfD5us7YvfQgskzkDEyFGZekEGjGc7F5rpSuc8k2qb6rqTU6G8Wan00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d0Fx6yfY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qxx1xb+n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d0Fx6yfY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qxx1xb+n"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXrxv029969;
	Thu, 2 Jan 2025 17:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=92ai0utU7B1sO2xTRu
	D6IRViW99Vn9vuvZa7NLSehQY=; b=d0Fx6yfY6ATRY1hUd4Ikpxo/1bbAE8wErO
	vsfs88o7io+8vpNIngDuFYu9rXHsNeQGvCkMpGPtnu7H8HUgkKRfY5iVPo4F5WG+
	M9klO/hsGyeeJ92qgoPWWJoI2aWsYtuAARFCGBROzjlLWprQgEUxUYa1RvSrCwTl
	bxu0QYgnRZ57NlCj/s7dvfnIFGmbUp9hp2gqEo+Vugif6XjmH2w6CFbae+LbhIbs
	K3GYCxXB19ko405/V91uett8hEqVLn5yPy5cxRPZHnWjxnxOVdeMJUj50k32RRWz
	jrqNh+iuGhTZCC7VBXxxAW4BQz4Dlfu3Re7bthTAORB0EX15yvbg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9vt657t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 17:55:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502Hb5PW009362;
	Thu, 2 Jan 2025 17:55:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8tsx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 17:55:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ufqgQ/dysFwFWk9AIH8dPsyKmbmsLZN8dxmzXj+4qJhjr998eCkQpUwGeR2yherTBr0nsZlnTK3s6V2MSA7G6c/pHIiT5MGS2R1zFtTSUGE6L3iHwzNpWjxD+PzoaKzJtqQMGlKL78c8Pw7YD0eSgBrFedCEpJE4Xij9VNvMfUJBGlQQaYRleeGA5oR9DaDhk1cykT14tQ63IDSoNjj5rihuiHhPsEta2Ur6uqQdF2TlCn1qUCOjhul95u0zw5RbTTBl8+LUofjT6IL3ZnTNMxR6stzWGYIfMjkApWwj7H4RLN5krJC1HBAptqcteI9SigBagrreeQDNit4srm/ZJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=92ai0utU7B1sO2xTRuD6IRViW99Vn9vuvZa7NLSehQY=;
 b=uTipioI2G+wJPqN9FoExMEbZcPFqmL6bRHk2Zdw0Ci6iV+U7qXMI+t75ITSWKvBwddo/CDate6bunIQHm9dLmXWGNWxeeQYBCBjfXW32rJRxsGtcJV06XYR32xM+fFrubHr1GWQssPmozIRlmEWWQ4FNt92KfY9ACeXtXdIw/2gWvCuuMogv22p4LbPcBVxbZ/q/950rdXV3AJf+GKLCAGXGaVgpU3CAkgarnK/rNjLM1noqnbzins2FsB1/t7rp7rGHmGOpl69e1uXCUelmlOkODjLhFtlLHOP6cmsKAU5CoQV3XVdvX1BfTkmyylAddM2rMUbrUD9TJcQtn0oHsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92ai0utU7B1sO2xTRuD6IRViW99Vn9vuvZa7NLSehQY=;
 b=qxx1xb+nyf+GzPghJu89jT2h/P/0+p6QPgAVB3tViddXw/M6oLbE1pkNJnJL9ipOiq6rfQoSU8Rr48pM8+/Mh9aG1zlMvuAqZmSintnolYW12ct1kZ3GEiC45wm35W/cWsL2N5AWQCRUVR76GVguUcfFEEn1iwYSzevtTslZAyA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB5962.namprd10.prod.outlook.com (2603:10b6:930:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 17:55:31 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 17:55:31 +0000
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nilesh Javali
 <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/19] scsi: qedi: Use kthread_create_on_cpu()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241211154035.75565-6-frederic@kernel.org> (Frederic
	Weisbecker's message of "Wed, 11 Dec 2024 16:40:18 +0100")
Organization: Oracle Corporation
Message-ID: <yq1pll5gkxi.fsf@ca-mkp.ca.oracle.com>
References: <20241211154035.75565-1-frederic@kernel.org>
	<20241211154035.75565-6-frederic@kernel.org>
Date: Thu, 02 Jan 2025 12:55:29 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN0PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:408:142::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: c99981a1-9379-4b00-114f-08dd2b56a627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?01cBsJMXMLzxoeMvwGcgPyUFPsLlGVP8Dt2Yjp60claVu7hsXTv/Jq+huVtZ?=
 =?us-ascii?Q?D7Rw26SMNna0qIfcELDoZC9fkWdW6WarPxnKGbur6YONhYJzZEvzGsJ7Vp64?=
 =?us-ascii?Q?gqJwdCR840CMvjv8qG5RR1OubWaNv3SdvDqVRpTouNKQ/eifmf/XebgI+uhG?=
 =?us-ascii?Q?YY07FQEfjhwUu5XeBol900kApxUE46sQNqS6wBMg8gRkaD9/nIuWCQbVNii3?=
 =?us-ascii?Q?C6H/BT4adKlXs3xv5ybg8s/yiD11HRx4h1vwbV8nDZA11DwBnakWi8KjrvJe?=
 =?us-ascii?Q?JsM8pX7fX6EHuAEaEaWplCt982fJ611MI5ijA/GGVyFhkff9aETgLVlKa34P?=
 =?us-ascii?Q?Epxevv9FdGWDAV4cqFj2rVR6hfgjL/A9kwhz78Fr8FiswgPxkfXKubX1vhdv?=
 =?us-ascii?Q?q+vYa/stI3UfVSLeQscsVU56U7ODSmknMEhW8yN0MFrv3xJ9hR53AB0t/mP8?=
 =?us-ascii?Q?dnb7pHYnnhdHDbr8x57sB3SW9tTvN8b2TJPn+Oy7nW+GK8Pg3lcQ5GPYfbJv?=
 =?us-ascii?Q?QqEja3E5qRdVF4u7d9IaPHEQZ4hRWAs0VY7qMxLF08zGpF2SBB7b/T2acIJD?=
 =?us-ascii?Q?7jiFUJry6S2NeKrHTuNXwG5CmsdiFMotyuVn9FQXeb13r+yhQaD/1KM4W4z5?=
 =?us-ascii?Q?HWLayk0Z+Unme/k3jRkxQtI6RkHinw8EVgNKkqcSggZMEdkdg6gCq0/QdKUX?=
 =?us-ascii?Q?6tTrIFIMhhoExks2X2fBEb0RN5tu2OJdGOt6WAz/I9yPKqbF1iTKlACLULN7?=
 =?us-ascii?Q?ZOXFV8cl8v5u3zeKSObkW6z5BR2IAnrZJS7wWJYG1ksyTc4RsrB+oX/PN7Oo?=
 =?us-ascii?Q?aFUSCxwB4/gpdB41XQXo2yaKohwCKum+mH9iCBl+KfEIzGexsyrsV6RA1z+u?=
 =?us-ascii?Q?QhP/a/lv6oinceC3RGr8LExz5t5fOGHtJXYU3pvEdhTPdkzRUXcu/5j0eIq+?=
 =?us-ascii?Q?XAIJ1l8Wu0or5MXY+YnkpSQiFmfzE6eBpa9MTYy4BmjxMeyKVmMfoq7qfdrv?=
 =?us-ascii?Q?ebP7F6pIhrN9xC18RTLHbuOcn5ImgXWPiguS9zOFfEGnoOt6KnZ68RfiOIlS?=
 =?us-ascii?Q?ERRAYu3ngsMEY2vh/O0sqdK0/0oymB8ID4DXaCGI1KgnpPhVKcJBluriPa5B?=
 =?us-ascii?Q?1tzI5O4jjIvtmvsM6zHR2aAlh6HxD5gJx/CwUq9zunp2CJpM2wgtbf/mVTat?=
 =?us-ascii?Q?HofBjKJ69t9CxM4wnyaRES3LiyJ0ERdVkJflhJIFSWzFwAHgtZeSZCnZ5PRc?=
 =?us-ascii?Q?6XpFBx2vGHUOtgbkKO9IEPLdETdtkFhDaqLVEZg+U3mQv/GbRsp2Zunu2hU3?=
 =?us-ascii?Q?CdoQLp9Uypme7J/AGRbg6QDwIPQ1to5qwmmm+fDeoXWPULICft2yswSO8LiT?=
 =?us-ascii?Q?KNSNFhODHrGyiGuKposvGsaCkVcb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5knfU3nVTfnK1bpl8t9btQgRTgeekdiOzu3GMvHd2Dbw9kjKifQE3uVYdJfA?=
 =?us-ascii?Q?x9J6bL3RJQPD/v3KEdGv84vEPkd0R7EkE7odTDSo2T6V8wimIYRMIgBTwgUb?=
 =?us-ascii?Q?rhMSbBpBJ45fu2UrTOugMeQ0qeY36r5XWVFDTE7TjnJF72/ixVroZtzeFiEo?=
 =?us-ascii?Q?KqQnNtry1/usCVf/wWCLfBGyLWhSE6gTcx8NKD6nQA94iqGws+Nb/iIaazwm?=
 =?us-ascii?Q?P1x6y86L+EvyLaR71JGAkjxNFLzSW1Lm5oI0hsNZhpennNKLEG9nl/qqx5qG?=
 =?us-ascii?Q?OFmWAx3S18xokJporvYXhyRe+7P1tGyuAcsnsuJYGcdtQv2mZsfYWDEAHsOA?=
 =?us-ascii?Q?5+KN7oFRlnup+m2fex6KAnf9se4PXEraTkzSgcoWuxSXViknDNc5mvU4pZPv?=
 =?us-ascii?Q?cT4YMYpYOgEv8wCySipsiQXQg5HDirvtIaklJBbl6D37a/0WXaYCCRewbjH3?=
 =?us-ascii?Q?0vdEhmnwjLw4eehdKyD7vM564HHIxny8VGaDUOdfJGOOR9Ge7VYDPhF5G/xr?=
 =?us-ascii?Q?5DeC5VC73WXNK/ZSDOyIIouVTabKe4MJ6Mx4WjLAUxzorqa8A0EKN1e03nHh?=
 =?us-ascii?Q?ZL6vakiLcqKuZVnAIVchQCeG8PUFDplvbHD8jLqA7/bapYCQiB+/pnUgxpuO?=
 =?us-ascii?Q?9iPSkXCcBNhxdRe2puufl9/DIPH+la1s6szPM6VBE/P1u2t67IbE/WU88gMD?=
 =?us-ascii?Q?V/0StlTlUMAMCxDPXS0huhJiPRqW8bQIfkaMH1sk5PLABtAyeK/B2DkrsYyg?=
 =?us-ascii?Q?8HymXI1eY+FV4GNEhRdCFcf9DGOGbowH7ESMAWeDlCiLqyxZVgKp9pa3CvNH?=
 =?us-ascii?Q?cJLO1Ug0YnHE+kAkhaEkfQ0GsXafxOadinErhO+7uHN6CObMqeHyU6Ew9v+u?=
 =?us-ascii?Q?U4X2MbZBDFnW/MMF9M2tJYkXi1dnqkOUwcoRJpZG2CmcTz4ibi7QDYDK1SDH?=
 =?us-ascii?Q?OUjRlbV/8CBRv0tIRkNqEn1BrW6bWdcPPH4LJbn39MOa6bSVLGD+x11/UjAU?=
 =?us-ascii?Q?ky6h7Dof0WwjsXAu4oLPnXv8pYAJEFRMe+SDF8cGgrRNRJnFT7YWmV+Ac42x?=
 =?us-ascii?Q?i8Plqr13K4Pu/m+3SVdZ2lsYtxJrwbkyWibujCmrazOf+Jv+huWyRCCR9Iwy?=
 =?us-ascii?Q?L8WDALIFh8CoxnOyI/KmcuzaTuxBBi2SxlnDiK6DNe4usqDrdIhUOe+87cAx?=
 =?us-ascii?Q?qRap822jcw1Zb/TrrpN+so5aGn6uhfgHN9y3HCL25SNZDJWn+5DTPdOKPuUH?=
 =?us-ascii?Q?1u4L6m8eFzKrxa5foeZXibIw8cQUNNWisZVm+kytEw6at5KWl8LeDSG5orOv?=
 =?us-ascii?Q?BlJ7wTQdIfE8q4KRii35XklQepPJv4ZoGPkjQgOPYcvRFumwj7kYeS3zdHLK?=
 =?us-ascii?Q?I5blSaj6goxQP13B2WmfV8RB95ReQnVST4ugnILJPqh6/DmLXIqPDEC3IHUE?=
 =?us-ascii?Q?DOT5t8piDrYyEn6OYgPCXWoTEsAO4WUIE3NXEFIGpaqp+vB99ghWWwHJVDUW?=
 =?us-ascii?Q?yCyFppQEBpkrdkAif8bXZ2AQNqU+gehfEtTWyXD0nL7si0Ie51PGnBMng7Fa?=
 =?us-ascii?Q?KT4oRLzqpHpWTq4KyskPZnuIBNhPtIng90vb8qn82tYYWmK6TCQ8ZBhtBlVv?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Um1ZYKlCOqzYEWLpUPFanEAwqhsIbYsKtrNDRb+pnd5v//ukrwHdbeF1CJ10OOmU2WB/tJXnm1tXrQjIn+YROCVKZ+I9UNqo2It/bQHynEPdtbGViXLbgrvkQ9+CmflwTSN5fI+rVtn7e4sA9LS5xXFF5rzM4Rycb7vfY35EXWXYTzrWNyThwr6JLGR/fWMKlnZCx7D/rbta4SAMurjwGcPeJdB+mP1aoyHCMyHg4uj9qTAYkMRLWc+nCrS3uMuO6THmDnvLkN+bHZ26cm64xpn5f3APgC7lpGm+edVE2CDp5guLrzDek0NcyHuwObDrzaNdF/XgBEd89Wj0M0Y8TEOOSI4pjhM0ojt/8Lyu9ypQf1f3WRix7mQbLNzNSpT8gZY8JUIzQWLx+EnTtnHkSzaXBtdjFzwZjEdrSpe9pnpuDdK77ITwlojqJFdrSNWPfkuBUsP88fykSFFQm0au1izlfe8Tftk2zObcy94wjc7/+72gI9gOaNF47QlZJkHmu+sDs/5UNaaSerHQDPje0eMRjG0QGpihl6PgWFIo1ROQXSHGXbKGqzC4gXn7rJlRdnQCZkKGHZdi1uSEy5MBcQBbzkaRR4UCwJVtYgvcm9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99981a1-9379-4b00-114f-08dd2b56a627
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 17:55:31.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GFyKujqIUTRisUh18xQWzqs2yBOqB8JnrknCB4Yimc3M5oddnvA90oezZdkrSzJJqGsd9MCl1V8vocZW4ZEhlggyZ1ubeZnmCY6eLOyFW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=538 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020157
X-Proofpoint-GUID: VDOanGlSPFFtU76zTdZfy0Nt-O2hKZIY
X-Proofpoint-ORIG-GUID: VDOanGlSPFFtU76zTdZfy0Nt-O2hKZIY


Frederic,

> Use the proper API instead of open coding it.
>
> However it looks like qedi_percpu_io_thread() kthread could be
> replaced by the use of a high prio workqueue instead.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
