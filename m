Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCED71C28E;
	Tue, 21 Apr 2026 02:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776737855; cv=fail; b=cEWlG28A1zyK7sY2rwxiJ0otsR4cRcTHyUfeHMcVvN8rbJthMvcnzh8MR4azN71GK4ekKfwNbHQCC2xO+1OxUyUzRvTzgV3w3TdKjNizeOu/kvN3cIBp49IvNGEuqFbtnrvPUowclt4U/M68/pndhiTtrdI7UIVdGpv3Wa1WmpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776737855; c=relaxed/simple;
	bh=zbOtSrb4kXNzWlwDE88U0INsl7+ERvTZDvi6En9XBk4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=h0HHD1B8WaznK2Sm/NbRfkBLaRGK8c/d8doS6zqqG4+9rwPkDIzI+UM93xakz4GGk+V+aN1xFFvh/4PcP55w5yyfTNjdiuspuFXBHOJA1wQKiSq5rWQj072IkN8z2bvnTfkx1td51pZ4v+xSYx8wOlruG7gh9tEM+9Wu19JMwqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kOpXjuuq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FgDSDvqA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kOpXjuuq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FgDSDvqA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLuG7Y1333528;
	Tue, 21 Apr 2026 02:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PaENtJn7dvP7sol3gA
	FCY0Xy3qT/Jwyg1NbdF1Tv8tc=; b=kOpXjuuqSuMkac0V73oH7iFy1fD0GGTKFV
	482a5doucfGiCEVznQfwN9VA5jx7B4SOvEJxEbs5I9t9P+uWAM1pG2rIBDD/TaIZ
	smKF52jFEeoe4nCIImRt10r3ZNLR04kLzlk2pcW4nicOo4c2nUD8wB8UfzrM8GPl
	4V4saEuowESIXaKZAuv+LttE8/PusDephzyhUwFQouAsnUxFPVBHvcRAOacDhjzH
	PzmWWU9ZpGbZGIl7FtsN6+rXs+2QE/3MlXxs7aHARmHVwBy7nv3DFHS2FxO27hk9
	b5WVck5O5U7CTKskyp14ZtCeMed2QtderoXdCLcAM/sKtFtNaR8A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm27vvfgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:17:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L2B9LE029256;
	Tue, 21 Apr 2026 02:17:27 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012031.outbound.protection.outlook.com [40.107.200.31])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn187xx9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:17:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRJ+0Dh9jpe3jAE7dk11n660JEhwRuLefIWEm8YOONiQazbAlCoshOvH4esasTJf6k18YPoyec2ntfwEMZzcuW1oyo6ykYPK4FGOtTY7m66hkG/oYYBzazFTw90DPwMq61LSoQ4c0lu/Sym+EfCx6F7PH/VoApvflMyaDs/A9p9vtQZbbtX9q55JAVyGr9y/BqSJ0Jao5nXg5Igr5cF6P37nZ5K5nrDCVh0mJhPSUTuYE0Osw9yYLg1/ZBh6PaNFT+QWJnEJ5x1v23Km8yRBwl598PythaHLpCKdmcFpa+wshJR7EZzEMZewo3WNbp4+Ex20sy8gFCpqgHkXQhW1SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaENtJn7dvP7sol3gAFCY0Xy3qT/Jwyg1NbdF1Tv8tc=;
 b=RTt3nBQQIcCie8nkddRsUarZL2Ahcj44yUiEKOCTTqxsxhlm9K1UL3BhEUvoPMKSwLCRR/hgsTU84nGfdCIsjepceE2U/E19uzuRF3sKmvN485jsm+N0UhcBA0swn81NHTJeT+9ElqNcxvIHREgu5/mz5nmEymO5Wa4zKG2ZrYSumWVcdDRWGV3CNTHpvunutP9yjg5jlgDtRXJrbpKx6M20sjfxRorym6f59PrKm/Zp7ezYsoFLk/o/5pxzDO6mjc7n0SoTNw/UGTP+6fdjxk5WgzJv+f/3ujDY+aFDGXGJYAje2M/MCIompEYWwkOPoKtPQ+lzF9KZ1K52GF934A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaENtJn7dvP7sol3gAFCY0Xy3qT/Jwyg1NbdF1Tv8tc=;
 b=FgDSDvqAAWNTtv8XRe3Lr6w7AV4sKHC0v5f0iLkPZwu9dE6Frg2wGvySxduuXWUlFcgN7gb+ZY4hZ2pFhjkhHLdZqiQIGPTwqjaEzoEtcdHEzQiNzb/ro2ZUByVdKCe9erLc1RXbd/p1/SIGJRwa93kbOGshH36UNfR8Igg9FVI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CHAPR10MB997696.namprd10.prod.outlook.com (2603:10b6:610:2f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 21 Apr
 2026 02:17:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 02:17:24 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shin'ichiro Kawasaki
 <shinichiro.kawasaki@wdc.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: fix /dev/sg allocation failures register
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260415060813.807659-1-hch@lst.de> (Christoph Hellwig's message
	of "Wed, 15 Apr 2026 08:08:05 +0200")
Organization: Oracle Corporation
Message-ID: <yq1y0ihoy69.fsf@ca-mkp.ca.oracle.com>
References: <20260415060813.807659-1-hch@lst.de>
Date: Mon, 20 Apr 2026 22:17:23 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:610:cd::31) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CHAPR10MB997696:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e13226c-2e37-46a7-4439-08de9f4c206a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|56012099003|18002099003|18096099003|11006099003;
X-Microsoft-Antispam-Message-Info:
	x0SCih0JFJLPbM2LAXtMYV2+d6NeWnW6hngNxj1oQS3agWh2Fl3gQGjbHFmUePcq9cQP3qqrjHB+VbaC1006nYSaLs7eLaFAuLvGBE/xQcWv3KXgIEU+B9j6H19SBE5qMD8lgc4IyIX68MWoC8XDkO0mmTNXOoyqmvTC+Lp5A9K6yyMrEWHcKnf40m0DxOTbDLpp1FqPK8w1rnbRHXAkt/5Z4YoVSjRtA6GVrFOU6RpSiJ6fVnEDnJUfOisMjs5iXWH0O5sWtpz/R+9y/JkiXpSVNnvJg2O9IQuIdYge8MyXDKMDJYCmI+lqH8xIkvVyZ+IRdChwIJtl/BP04VSY8FG+XAJQmd4wxxg8AILov5rgiUxsKab1qZudQSgd2CgWv+47/Z+pBapHaQAMbnSOK26sbkr8ztlYsMZXmUNY8j6S3MwBewtdfLDsiRIOG6LZjMg9yJpaLbMx7WlR4UTL7ChsQo3lY7rEuaV1nRF1T10zRnoL/LMfOULvgczaTNcNN6xkRyXScfZ2QlXanHrtn3//uUm3qLSA5YYMD+UpgPpG3mRGFXbpb7MwpwVCFdlPzAojdrFxdz5rJ7D2fe36LBSloUACPLiZrKNxkbkBxWwDg3ARPtvqnK2v36PoleGR39/whWEMRePz3rFAixmQ1jT+bw417FbNNmLEoGboVFhF437l9/c+xcrignwFXjI2Ck7Ln66s7C7YnRGx0dHraxDVVsvmsZadBY1KON4Mhds=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003)(18096099003)(11006099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XQnc7QHYgcCZDorfPvrAiPlY8VO+2mTFNNX2rZMF8rPvhgBbMjReagw5H3B9?=
 =?us-ascii?Q?OOeKK3DCboP9caM6BI03hgHzP1IwRqU5nBvGlklV8eeM3q60+tlRiGrY0o8v?=
 =?us-ascii?Q?DklyR1kgrLNF0O1sdNA9RcTJYoiePz5wV5bX3AZI8v/4Hhb0Uc684yi7tPfn?=
 =?us-ascii?Q?yGYXaMmD7K0KCrcY5GkUkjuCUzrFcUpbjcLL7ELlklefxxdVFd3OaiH8HHx3?=
 =?us-ascii?Q?MiKrbpo2rfaSePLLd9/O2fumjybBPO0QzEH44SoDt4SyNL6mq5gNLm+zYIRg?=
 =?us-ascii?Q?qIg5b/HAOdvhc1Q9VIVx6GT1oJty5R/e5mrAorgsE9GyihfqqOdNEysDxWFO?=
 =?us-ascii?Q?kl8bPfcRwe1GpDzSqYAmuIH1/vu61c7Ue0edmC7E43bJhg5ujEznXT8SS28M?=
 =?us-ascii?Q?XErJn327Ir1WYqq+DvbSIc4l5oWiLv3EQz3GsNsgsMz9Ej9BBWQ5f160qzkU?=
 =?us-ascii?Q?ZBlt34um8xjGjsLDirysQkMct/Rks+ciM9AfGg6j4J+cY98gukS4AtCgYghx?=
 =?us-ascii?Q?KVt+RZbDc7Me+t92pJN6VFaWq0kolULOSXThTbke9WUCIO+2G55Z82m8Flxx?=
 =?us-ascii?Q?WajmI+SoJt7MW3B/y+zIt9wn8P7WkXBX5uadqaMvSSAwNKzm7QBH9Yu5V2Zu?=
 =?us-ascii?Q?Fhv0XEQ1eAyrc1BfD8C2SVYBPO82UfNBVibIyAn9RA8LnBB5rwcCBuw8lNQK?=
 =?us-ascii?Q?T//asNnMDYFwdC3+9eJs/lmnOmWDAVFJ9IBF9pC9MQrhUPSa1+2O0zuMmC4s?=
 =?us-ascii?Q?71wNe61vM0HgxI4HV1yWPvRuZQ+8Zh09ylpUttZUTAV/RGgfoomV0gTfl+qd?=
 =?us-ascii?Q?E8jOpcHcrnj1engDPbfon+hirMzPWkmn1euW/hFczqW8dz9SZpZV6W9O8TDR?=
 =?us-ascii?Q?fdtvdnYLTocJEyxCk11wCeVXd0jSn3MOf+PaxDxJdkNa4iyQE1mee5TI+i/w?=
 =?us-ascii?Q?I1gCZN4/Fzk1uSda+rWcaRZBIHMndZ2polXfWCi5LVPqD/l2ZnmSpoYTFqnQ?=
 =?us-ascii?Q?9p0M7qLY7XuzyEiL2fRcbBHpiEfKibjAcmTftJqxLwGBKkjjSjuENlOGlxGC?=
 =?us-ascii?Q?4UnxQTqoxtENTNW2aE7YdykioOjU6sY37fbxPVKFikgEuPOsW1r/3Wr4D4fZ?=
 =?us-ascii?Q?rM6Sh3YP8aCI/28XDwAdFAE62E3zWURTMRSFEwRrOH/vLqdJv+R8ynY9abIv?=
 =?us-ascii?Q?EsGwOsiNy23Pp87uTEkNo6E/RfhAFKYm3k8UxKC2uZlQkM33L9TTHKNSSIid?=
 =?us-ascii?Q?oOao1Uv2OfeaKvN0sqOhohY3YYBmIGH7E7xeSPkgVu0ay5iATHtOJcwOrOBb?=
 =?us-ascii?Q?ABsfYxmxN02IWTut8rZ3JTy6IX4C+03DDDlepUz2ndAGTax1f3X2Kf/26AMY?=
 =?us-ascii?Q?43jxDwXtYXGsSVsm45oFLUeXpbZPC9HY8vnxn8e/I8+Po5b/4/bwziorup+J?=
 =?us-ascii?Q?aE19J1GILRoe9MQdtk9oa20gUdQEL6o2/+sazWSan2gIneubcLeyPDF0H1Cc?=
 =?us-ascii?Q?oiePcns1J6xoHgTfZjFJa61X0DqjNs7FGCgmjKas46u+LWcWFaGL40qtZ9yA?=
 =?us-ascii?Q?y5E6P2Ofi+EoSL14RmgW8fxtIWZ4F7X+cfVu4xzJZTxVbqS49o8YRNhUv1qQ?=
 =?us-ascii?Q?k8kEvmWx7D/vImA8CwRe68pzs3014aszVIRgAMNCEWoZPhVU4txaMq1mVIpv?=
 =?us-ascii?Q?Pnf3oKG/pUfgdm6O4OL9dNz9fIQvCsDeVCpUOcl8gZfbyom8raAP2ABH8hcG?=
 =?us-ascii?Q?xOHsxkkE9UXiuziPsaLYGNT+AFiMTjM=3D?=
X-Exchange-RoutingPolicyChecked:
	JZJ9SaUmcwq1oUXIXF02HOt58iCSlR48G3iLNQvAKa8JdahXRKs6rresWe/0AZYXpFv30sURI+pqm5dz+JMf3ysD/RPFqqTWiqkjlWWhJaGEkWzpj8cL49Jz46muy3Oj1mtrHooP2qYHQ77pSlmFRCL5obxjwBSGnTMAW9uSJDa4o/nzkT7K1eDzVARYXB+ZAdIR8+q97tNU1+NbokqAHcufZfCZJuhJtNCgFroc+HVA7Ic2T4CCoTT/U0uVK4wvczlYuH7+ggBzk2V/o1yFJ8u9u3whwCtdiDnhZy64jExyZLr/KeWqo1qrL8D+MPcyOTTEuZ3AYz1RJ7tD8c8YYg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QcPH3eG2pMbNaBaMYhPYRI6nbsoHh2VINbNaKXK6bwcUe7V4kmmLHZtNHQYHKlhE6yCDOeCNjbShDudDAOozG7g5PuC36qHd7gKCgN9PrqiY0spFn3Fgn0elD43uY3St3xRmwZhQXAY1ZD0xEHqnkEZVNVnIOBmaO+2rE85M2qFtoFz2FDBDFhtAClkdtzAGclvkSP+l2AKop0/nDXHoumpOds7THMocy0F/IqBTkGck/ACMSpMaYkwqXgqoFJ0/TiLcJFPbDzZqj8uIiuCDBlNXE3+0w0TqwddJ4M+8Foma2zPtTbZ4On5ZdjfttORx71zppbzh/jViq2W4wMYxMtOx0x0CMrCK83yqv8N900ry0zBeLyiz+f8d1lYsX3HA90wDbVahdND91omicTJQDb6z3Kd3QRtMbvmp3My7t6R7qDPdvSlWS9IAHcvitOzn06VHpnMSLM/mdFb15p7h9yEe1D0q4QCa/xCQOEF2EFhNfGEWbXGcNlYLaUEvR7UDOs2GM6AMuXyQINWqLD/W1gn+88s8TqR7szdna9QviRCO+5z/1NepgyoL2qJTTyLO0qV1YeHTkZomYvtljyCN+1a2/sUgwsHdmNt+XJdDi7s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e13226c-2e37-46a7-4439-08de9f4c206a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 02:17:24.4501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hc4gWbt/T1MPAmwBfBiOOVEn86fU4jXqucVDlZG/NC+zVvnMulwmFPC67n12HJR/nH5ss4H9gQcV0hVAOUN92142scjHAz/F+zjMufm0AE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_05,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=911 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604210020
X-Authority-Analysis: v=2.4 cv=JYCMa0KV c=1 sm=1 tr=0 ts=69e6de37 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=GISNUztzvdc1q_S9rGwA:9
X-Proofpoint-ORIG-GUID: 5cYax6MTqYPefSW5Z283WxkV7xzRX5DU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDAyMCBTYWx0ZWRfX4XEUF66xL29s
 Z9Dq1fcCfDabmooyNpIaJ2yqFiz9BBDd4rVKh1eMy2TlunBxWxI0cRre2SqJlK0tmZwdoznDm13
 x6fTVQQvk1TEYxhy4x9HdRxPLFSa21thYGSrZLsoHueRfzRmhZjfNZiSiVrSMJEICqdn5qSDTdp
 pdX9dj9YzRUkDUtCJRCIXRR3CHU0fMeeVT+XmtxamZy4iKBrSZOaRPYhL1YuE5W1WTQ2n/zdn8L
 nejQk/KjqEmwUtS+UnFjrGlz6ea1UoDSMabG1KYJ9FAeYXgXyHAiBxy6OjXn9Twy1jDHjgqRhSI
 St4Fxqc45/cbqaHKxbkA6uLrWj8EvtpmR8sIt8scpMwxf1wEsTXDHKxOeJHodPwEaqpV3OcW9gW
 vSzEX/FAHey+OSx63vUNP8mCn29DSTjSg4hcuZY1VRkWjY0vlcB9ps0FpAkQKeu2e50Z4YeoaqW
 WHl43+Cx5QIDpB9jG1w==
X-Proofpoint-GUID: 5cYax6MTqYPefSW5Z283WxkV7xzRX5DU


Christoph,

> This series has two independent patches to fix this from different
> angles. The first one changes the completely pointless GFP_ATOMIC to
> use GFP_ATOMIC in sg. The other drops the reduction of the gfp mask in
> the bio allocator, so that atomic allocations of bios work as
> expected, even if they are a pretty bad idea as the bio submission
> actually needs a user context anyway. The only other uses of this
> seems to be the ocfs2 cluster managed.

Applied #1 to 7.1/scsi-staging, thanks!

#2 needs to go through block.

-- 
Martin K. Petersen
