Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A210277C80;
	Wed, 20 Aug 2025 01:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755655029; cv=fail; b=mOWmgnmaKk0uEhvU4JdrxQm5/BXDQuy1Zpg9CfL+PA1zFASv4lEKLsFOn7H8qr2QsiFkEfhVlcBJiyjYf750MpQI7D/JMAH6Ukxaw8Azj9f9zUkT33DFeSoOYUdTEMQ80PLFXloNpAlAuytQYMs4rTHZotm6uNDGSNN/9IPBFeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755655029; c=relaxed/simple;
	bh=BWc/xQFtK8T2VAkRwI1FZXt7j0+k2r7mHKCn9AJiAe0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Dh/qV8ev4gexzlepGRFztz6WHhlgrnl8M3Z1j6EwVp8+zF6/N6lguIpjatOWdJy26v/1TpYt2o9fhBveMsCBXl/g7/36x1wbvBZQQ/YXKTw6pa0Bkzz+eigRMcGPBmSNFEDW0+nwtYGijS5pQ75IWzLyelUYP9bN9UeM77ppd+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hPT89R2D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l4GQ4yAC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hPT89R2D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l4GQ4yAC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBmAd005364;
	Wed, 20 Aug 2025 01:57:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pUE4lOWp3DH7lDVfHQ
	gl+Mp59fEEqFPd1Q46gf447Ck=; b=hPT89R2DBd98oP62GnfZyBcG2sdZcrGxIo
	KtO13IjGgUcedcRy2q8LR9Lk0/a8kx0IDASU/JNYrgbEg229ebBJau3CXHik9MF9
	xAmZkONQzLutSnnJ+ora8q7QN8efjVEXd94/tVQOdqChqCIXI/St/EffBZ/x8Da7
	OYZag4ou+GGl80rTH+2m68DbEdHHVfDG/rQXnY9xCmya5adNRFBw3d3o74JDaZce
	aAEqyTsYw2idDqm5lYIDjyN9yyD6MurCfb26cLH4MI7gbZAMS1Dn/5u6BzPgYCj4
	zN6+5Kx4sxqZr9mIzqoRaBhTyVMu2V/n/51bI803kQ1Pen4KyEnA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsr9bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:57:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K0OVcH027070;
	Wed, 20 Aug 2025 01:57:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3svhy66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LWdM2aVBGIAuELgPo5YSuvPmWu59tTqoQn1DNLynLz4av607BA8xTNdatkIjZB091HEcaIOw8F4whNb9bFA2treSa+2ugBHqBkgSclRcx3zLlOlZqav/YE1i26tZStMQvKRgO4f67SrmWF2I002+ZldHzePfbWknh3jadv0eFeQzKOlfQyg7CO9P+4aF7/Cbs/msNidf7soCkXTiow+bi8/7xlLqD3tPBO+1bPYWf8eGUB4bk07GVPEbQCjsBG+AUUiRvKa8jUn0Hi9wk8JsXuqvEjTfc+aXuDvz6v+Brew74pI0EbBaWsmP0uKenRnBQezVEY7YRKg7TpQ7wviwYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pUE4lOWp3DH7lDVfHQgl+Mp59fEEqFPd1Q46gf447Ck=;
 b=bpldbPzjf3jzVu6crf66GM6gy6ShqxfEXk0PW+3RfHqv9xNdjxzeTt7H137qM0t5gIr1X00pGfsgpxkBtjXlqHQHPK6Dq1XGCRBftphfx5G7k4MWJHw5P2Fh6Y58swjtTFmEGuym6BHzf/YJA7ih80x06Y7RAl8a1Zl8tVSpsY3RCPWcqvKko7u/u47oOR7qvqfLmGlbttpq4Ore7MWVIxd7YehBipsNMtHQ+T+i/Ox7SoGFsbrLm4jeE5C79mvpmidyE0SE9Lxjq21vA20dCl76ckuyMk/vVMYHdCYpATMi9Ull5LN2RGKUYR0mLTOpo6vsMChgFJXoMJn+KX1jkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUE4lOWp3DH7lDVfHQgl+Mp59fEEqFPd1Q46gf447Ck=;
 b=l4GQ4yACmZL5tRp6pdO5ywmT2dGtaMPht0zZUAUopPpgjok6e1D/dOExvbILb0UHHwpYGeO/go6WLOhx+dpBeYr4XzyGbqAbKLeNLBvRD4+yJGNVUzkmyIR6ELmVPllFXeHWHDVMmSw142hSxJLhNC9iebbVBJFisPkKJszebDY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6614.namprd10.prod.outlook.com (2603:10b6:806:2b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 01:56:57 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 01:56:57 +0000
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: bvanassche@acm.org, Brian King <brking@us.ibm.com>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:SCSI
 SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v3 0/2] scsi: Use vmalloc_array and vcalloc to simplify
 code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250806124633.383426-1-rongqianfeng@vivo.com> (Qianfeng Rong's
	message of "Wed, 6 Aug 2025 20:46:31 +0800")
Organization: Oracle Corporation
Message-ID: <yq1wm6ywyav.fsf@ca-mkp.ca.oracle.com>
References: <20250806124633.383426-1-rongqianfeng@vivo.com>
Date: Tue, 19 Aug 2025 21:56:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6614:EE_
X-MS-Office365-Filtering-Correlation-Id: 177f8550-1ffe-4822-869c-08dddf8cd844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5IUjuUfQpEXrhqqI+/UtbuaDvt+OR7VREgggXjr1iIFs9IZmlDFtsQO5h+8V?=
 =?us-ascii?Q?2eAXcVrdrX2oyB2qO+Ta7EP0ona5R8au8jSuJkxDdkNwHAq2NpK9na54MIqL?=
 =?us-ascii?Q?nXIkOtWaP0rHsY17DteQ78aNMI2FlASlYe1748ehVqZMVX6QnmyiQ3/qGpbk?=
 =?us-ascii?Q?Cvt2J3b4GZBDcPCbWOrOv/06hrCoVjymW9rxWnF+AC2ojMG+6BjQaUUgnMJd?=
 =?us-ascii?Q?uWTtQP0keu7N5cYP9zSFhVMjk3uwRqWVlZS9Uf6LNEjv2yQJW38jK85cyKO/?=
 =?us-ascii?Q?ATjv5st2QHn5OsruAyVGTc2gv3JQw1lkLii6nrAiUokRbtxqhY3hYw7QWboQ?=
 =?us-ascii?Q?0OjXVkSxBPGR9ZjPxnCtTYL3H2P/ApbVJLb5Y/ubCY/TZTdM5WowyOMPpG0E?=
 =?us-ascii?Q?KSUUQyiOj3aD+/0L9ZSK6nf/2KOjlBGMKTKu2d5b+D0VNZFfokepvHGluE8O?=
 =?us-ascii?Q?pFNS2hmR0A74goWbq1OqCRTCKuofk83roa3iLHot1TTEfLcuS0Glreyic/8O?=
 =?us-ascii?Q?NqvKpYlsnXLC2gAHuvIMLSfDkp1sOIzyTKQmOXGiUcCanfKyyicVftB58bml?=
 =?us-ascii?Q?1pzq8uZxPXipd6EgUDtOnkkx6RpmKA0Cts189CsGMpG88SXW3Lzk9X9Bhakp?=
 =?us-ascii?Q?owBvv4gagaW+gbruSeOMazZaFF6T4WwP6TY5d55Zg13tpWh5Iz3B7QCLlknE?=
 =?us-ascii?Q?Ju1aWPfMt13nehjoOtHYq3UwA1/fc7N8fJ4lWkHAMZ+NF5/Lf3WA7PrTrDPz?=
 =?us-ascii?Q?VT7k1DxgMbbPrXSyHa5xNhjLLKtdKCpFGz9Ce94j11m4GCzHd5dhFgKr+Tnd?=
 =?us-ascii?Q?YThgF+Dz7pXi8NSwP8yU6WEq1gN+VArqxoSNSk9ql0WlNXmqu8+3NJAM0ZNG?=
 =?us-ascii?Q?WULn99BgEZBPS8e27PHcHb4LKN5BB+nqZo2GoLxl1mH11XtK+fS9LgBfOoSv?=
 =?us-ascii?Q?HhURV3BsQi8y4mKVZPhEyGYmc7Ga+FYeAPk6sBjIlqCU3XuWxpxZDPEVyH7S?=
 =?us-ascii?Q?hfw9TfNI9Gv8E6gOr6PJ0ATKuqLPk9RDtBGPpl7AZJqMZHcSNz+SJpGbL/v3?=
 =?us-ascii?Q?pKNA1QfYPtbZF3gqn9X/ATpV0CJBTfowmydLsvFGXeyelV0hfdSKHDjkawtU?=
 =?us-ascii?Q?s56ATgBHKebD+S001P+YLN0bxEiwTD2ZpIzlQEFDYi9Y0KIiZEtGDS8rFLZI?=
 =?us-ascii?Q?AyB0KjE4oshf1VDn7JdXw0LsLchsCMqg8iRxbMQzp1vrpG9DQgrH1DO4jszQ?=
 =?us-ascii?Q?qVUJiNjhnNQ/ccSiYr09qigSVQGtKFQX58LbQa7sNnQsm/+6Hr0Oc2M1gS7V?=
 =?us-ascii?Q?L3iP3W9r89UTAxT1glAc5OZnFcMYfPvtO/qom9fPNmK+ZLZ3J2R3MhMh95y/?=
 =?us-ascii?Q?TLaTtPt9vq5NPQIaZOfXg+5RUHXMeQIg3fd/V46wexx0EXZlIXbaGL7OnYXy?=
 =?us-ascii?Q?/12AqdaKfNo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hufH2A2IUHHgAIB2QdgmzfRnytBpJ4495M7JK9WO5h1WwJvvkJj2yYLgUXgn?=
 =?us-ascii?Q?SE8Alnk80pq6UAkFrCBXY+5Nl2DoJf6Wuy2FvwXgrWR3FGG2O/PGSErtukev?=
 =?us-ascii?Q?gxbGG9mBRGCJA1sw4wxIs2bUctTnrsDoWZM1UoJxlq4xQG3SfDK6NBTuzeiq?=
 =?us-ascii?Q?qhP1k0aKig859TIQCQUot71umuEH47EVjfiGVhDBIhhJ/I9Oyp7Bwe9eEGzb?=
 =?us-ascii?Q?IxjxY0C+IOc54plFgS3PeSrOn76QbXJHp7IqdCB0vye3QON0W+GDVwrSvYyl?=
 =?us-ascii?Q?Wbd11e0b0NQZTihI8lQHkbFMCns+v6/TVpuLi0XYBW/+xr4J/oeoMLZMrDTJ?=
 =?us-ascii?Q?mVJ5m+k8Wv0Xad9avyzgtgKFoCJ+ak8m4UidgkpFs4NlTltufKcPh7Z/mEZt?=
 =?us-ascii?Q?H8XJib6DaBDkin7axE3gg5CgA0NzbxViqPAglQ8gEfkhAyGsvEnO5Pe60J1s?=
 =?us-ascii?Q?+3AQM8PFFfrrWvAUiHxTFOd7j064ejk+ylJ/YSOSLtC0gtaEnAH8H/tpEbHR?=
 =?us-ascii?Q?oYKv/YJlJxWOjAjVFIhj1J2ZaOjl4BNt4HlBsa7sXDB1BeZlRTGuP+lcB9Ew?=
 =?us-ascii?Q?dmi9WMxD+kQNP8MdfbhKUZTFcQTMA3jQp82fGtpGdSuWK0K7jqt+60BhKfn0?=
 =?us-ascii?Q?KvVYFVePy96+BzvWniK8wUt+0gj4LkpJM4gojV1logpTtfcI622YJDwtY+qX?=
 =?us-ascii?Q?V2+6Y2XxsL2cUV2xxVkV3FxNp0vRXSxRkPvOoqDC1avvPMfN+962N+03VBXQ?=
 =?us-ascii?Q?hZO016c4vQtlFChFQYHlDfCPSf/VVnQfdzgq7OiuRgmOvuFXHYpvTaLVsuGT?=
 =?us-ascii?Q?L4e3agJvQZIoZL9ZDeBP54W/OnNsL1O1t7n8yndYk/FGlIZo5lG0vbPZqCH5?=
 =?us-ascii?Q?ldoGYtFSJHTgaiYSgIhTXGmvppeGkgcv3NDQ//MuhGGqBmO+OzM8D+Jaa/Kp?=
 =?us-ascii?Q?HYrlbwhbnCIWaozluJ+uogJR0mmgMx5rAmtWiTseQ5c3PQmoihhLv2SQhJgV?=
 =?us-ascii?Q?pc1r/0ba1Gxc96EEuhiJY+Bo54gsWSm7rC9sl1cKyq/KczJvMuNFhT04df9u?=
 =?us-ascii?Q?a9c0e6pgSOKz1P14Jfq85omgSsoeA58fIgJ4FGHykdoQUiW9y1IdSYxVw3Dy?=
 =?us-ascii?Q?QhWQeHVyuWAjGxdK7SprUbeh9ZZM4nuGMamIBY8k5xIPWf0XUREEQdYIieCd?=
 =?us-ascii?Q?/ApwN2PkV6I0o1Ys34W0gMKBtWbKO9jtWLxWqzimBAHSHJR/C2JH6JA0j8aC?=
 =?us-ascii?Q?VjLCe9EfbAYm1jSrb2yjux9S8hxfsfqo2dVT5x9Bt2I+pzaa/934fbg1uLAn?=
 =?us-ascii?Q?EL+M9878Eef076Mt0361mFr6donNbxTHqsG0Yo9JGBj8/i8VDQmpW6jlsqkn?=
 =?us-ascii?Q?B930fjRR8jxgWEfN0W3M9Gji5P5LNRdN3P3nxPHgFCRPWasfYqemwhSs0h7n?=
 =?us-ascii?Q?MdQRxGUMezpXAp1as4tYTAEFCiVPHeyz8hnJX41+eadfyN0BW2pOL2XWZuK+?=
 =?us-ascii?Q?7uGXJIwqZMdzqgHg7Zh7DBABfs9sTqQoFoljN9IPOEwETv2BIBllqg0Chzgl?=
 =?us-ascii?Q?wctbkAw4OtfLgT3PpZOQLVGkd3AYUsRL+tQMH9FNZxNpUrqD2NMXPluSjjLC?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m5F/8IYOgyergDUaNRGFpeHYcBQEqo4KOYjzTo9DkGJW0GI/27cQYnZDMa20i9FPwkgaI2/bR4Lm0quaSQz1xbN9PR3Wb3b8XFP2boahzcLNxRrTKrAqSa4pvF0WDuWf6PuGuIiZRzx0vskRq2N3f4WannXZtXBV6hvSHaKb7PYqoyaxmdM4uXYn2nQqHUwc9Z6iIj/hwwPxGBAmBN4RSCjVDVgLYAfviNusC7X45U5y9zK+1TK1eUvPy86Dp27ZFmSLmh5EzAjHukI6In5s2hGy7HWHCiYh9vCdlLuI+g7W/myAUdiFY3CfR9KlH3sfUyugMm4LtYA4UxtgtXHf5QNRCCyJrBPLP79cyQAxd6rD5q+G5K8AlVA4/YImbfIjk3mFfqY5SUtFDBjdGdZMJ84k02Q9sOCquDWqWmsTTTBwi2XHi4Q2x89fIoU5WBAq+K4Jlm4jXjMNI818Dw2Kc/S29NCcKdpkooPr6HiGJvkSszJCsNn3I+KTen4/Se7SDN3MJ3eK0qRhT0h800D4qDCtOsqgSVGVnOqaX5VJvPDLsVQr981Tybh+nRa2Vp3UwSbU5ZTOo9zcgKyR5WSfJp2jpqPzy4blJIHE2gtv1dY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 177f8550-1ffe-4822-869c-08dddf8cd844
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 01:56:57.6124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1P4ReLVnQ1u1nxXyvsSyPN4KmLJSbDOX7RGPG7OA3Bk8WrANHyPRarGN8aMXVP+uXigrDxRufR+OX/YB7yYIWobVzCdotf97RK1PXczZfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=572 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508200013
X-Proofpoint-GUID: 6DbNfLgfVFA4NW0dvP7cTXv7PK37JBxv
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a52b6d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 6DbNfLgfVFA4NW0dvP7cTXv7PK37JBxv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX3do/ugDxbVsL
 pGK4Ckj2eGSokqsszuL5iyOPo69XU3kuRNRF+7YttHKbdOyQB3TUlZO3lXRhE0jWTrN6elHw2rp
 qxi9A5YMdWpi/VNncOF9htEJ0dD8L5tG4TWFSEZ2rUqEW/vZV8bAuuOSYDuxK9E7rdZA6Qw1Fys
 8pBH5eRzu5+1KvJJXkrAKNLUPnRJPQQ5snMvfgo/U9bvTGSmBUUW7HI+iXinfurooLMzhLUOBb+
 +L0Z53EtzrhNVQ7z/PsytIhjEoxUlvsmcIEdLb8SUvjEzzGXgHSGJR81lBv+EcbFr5EQP75+YFH
 eOsbSvoWSkamPDD3vC+TMoCLPvohn9NFFC7VGB/3og1ilsg6H7Jvi/gDK+7apq8gkYLn34dB+Ub
 8wzfAg4Xt3N7vwH5ozjrrgnPMe4HPw==


Qianfeng,

> Instead of using array_size, use a function that takes care of both
> the multiplication and the overflow checks.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
