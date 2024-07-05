Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF4815ACB;
	Fri,  5 Jul 2024 02:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148047; cv=fail; b=jwEWSibgyhTxtKCJk35VO+h6nfoiwxIQoeWU6zKxwd1AZ198SAMpZJolpIZgJoHdNDx37kJnDlDOTs+//tRhWfer/nmRruFJmWRrn8VyRJde2oZU2R6uMTTbIhkaBonC71eyQF6jpYqJt8ahF6sGiLnmC5yzdlriadh2RSHjlz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148047; c=relaxed/simple;
	bh=8+/y/CYtvLXQHZp80OgYtGRl1apKDkiZd9Biy9SRvFM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=K1cWttrNm6ecfNGbZ5e09/X+H4SfXX6pMbWdwliaDeUqeEbgr9p31PTx1sO/omM+RomV+4jS6zK7mtAoP+gwIJBJUg9du+zLyCkAyahJkDXTe4qwhqiJAnOsH5E4uwCUs969XVtIhpAPZC1lxC+BiOBEUGfcxzYajrVgZP29sfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OMtwfk8z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JjSucv9B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OMtwfk8z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JjSucv9B"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464DxCFi025836;
	Fri, 5 Jul 2024 02:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=RfWrE4kTtwRTU5
	Gj2TFAU/Ze5mjuECjouRkaCIjLWBQ=; b=OMtwfk8zLjSCW6tjFxH0xD19NYby9o
	kpTV0oh82dtLmr57ktc/ZRAr7sBGLhDdEXvJRYCDlkR/u4298pfQwg+8b7Ad8rCY
	pJnPAsi38ACT+mY3JfI0X4KtUpSB+tzO6b32Gkvk+4soyCy5wfuOwqUUdmdKo6Ai
	dT6OnQbuf7C12K+7vBn/+sS18mym6BFioSZevx5e2Bl7J+sEUqOSNV2eISBCdESb
	j9JN4n8BvfEidfKuIYghZDhUJLfW/4rP/y3BOH92jDGSehM9iFKyhYFr/rCNXS98
	1UJM+YKRIG95M5BjEGcPCEXLmOfyN5oUhV4Apw0WOxWEqfO52XjaR6zw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40296b31qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 02:54:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4651ttIo010935;
	Fri, 5 Jul 2024 02:54:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028qawvdc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 02:54:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K10UdWlePiT0XucO271p+CRwS7qyeE4SMAP5U0+8IoV5L7Q7+Fhv3ap2eY6/UjRPeqih2Hjyafyt7x/J8vM36HvVyZcU4KuqBmBtyijN9YfrbltRSRHddN0PoXeOpV+vpDeJBbrs3md5CiIfzaXsxaAIIL9jfWmfkPxrGZgnROqMjMRs6ihnZhDn1x/P5b8fPxj9ecUeDqpNOOq1tYvru/JMiYlXTLVXUdAn2BmCAtXG+gT6UCO1VYtlq3NQ4TUUPLYBYo/tP4x5s/SK/pH4b96doJT/JSdVw+b1hb13LN27RZmf4bhaNdtzFylKVaLrAUZTMmdHxhStJy+WnrBQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfWrE4kTtwRTU5Gj2TFAU/Ze5mjuECjouRkaCIjLWBQ=;
 b=N47tWxlxFL9Cp2Tt/iJ3yhr1Hu+LQk7kSnAVJlC/MM/+jTxJjjzl4PQMwYZT7yxjwMV7lULyMnlc1fDBBS8sNpiFoucqwW1IwY51UYJYezBk46m4qZk0c4bJiRb+sCqtFd31qSINlHnwlYVuKm0nJTQ9O1EmgG8vpf9itcYiU4Q+RuF4gOsTEoADmP0wQKYc3vPWe5Nj8OEofg+z/rgNd5BLJgUfBm41FRGLyfqMCwL+Nbadj/ZydUAnHgBKow9uSNKKSs98ufT9WWiF2zHjTvBzL+KyaTqsCyGcfRUiqacyZwUSbPeFkjYYE38PIcIb9h2XlikBCM6KyWtp/wXdng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfWrE4kTtwRTU5Gj2TFAU/Ze5mjuECjouRkaCIjLWBQ=;
 b=JjSucv9BirYO6FnPWK45loVYyo61Xd46gyegQAtl8dVH7bLoEkqQ/aRqR6V6yK+ppEbhdYCJMn8OrTcvidw3cgMOsL+jd2WfjKSnt7B+7F3ELFx4X9JPPDDkbmf8KRY1eUr4mN5VgUZusGqhMogqVIcp0yeNroBIi3i+ybf8nWQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB8106.namprd10.prod.outlook.com (2603:10b6:408:27f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Fri, 5 Jul
 2024 02:53:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Fri, 5 Jul 2024
 02:53:59 +0000
To: TJ Adams <tadamsjr@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH v2 0/2] small pm80xx driver fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240627155924.2361370-1-tadamsjr@google.com> (TJ Adams's
	message of "Thu, 27 Jun 2024 15:59:22 +0000")
Organization: Oracle Corporation
Message-ID: <yq1wmm0a6rm.fsf@ca-mkp.ca.oracle.com>
References: <20240627155924.2361370-1-tadamsjr@google.com>
Date: Thu, 04 Jul 2024 22:53:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0116.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bbda5d7-48e5-4fb2-0805-08dc9c9db84e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?akQV/JeoYO1cV4q19QqL0dIkXgba3snIX8orA9yEeuBvhsnTQwwqw43jFeg2?=
 =?us-ascii?Q?B8iThLCaiv1PUUi1BRzNiGW+gV1RYZydl5PD1f1DEChRR55+D06NfN1VZhDO?=
 =?us-ascii?Q?3PwiEyfduS3oEAFqutXlfXnG3VWAZ6XAzXSJ1RZCoVskMAVdn71vK00mpuCo?=
 =?us-ascii?Q?xskcmG1ex0gs2RWCnMlssyDuYRMIW77ogoGJctqVUL3OGN2WI+E1vqfw2i6+?=
 =?us-ascii?Q?ZyfHywqw9Bx3rFR2T99Shz8uprxq1GimqRriBg7AJCgnCrUdM87TDcFNlELi?=
 =?us-ascii?Q?x+nrpuywT3O8AIe4zSp7rYctjOephD9rx8KEAf2HbBa/1gSjmPjucDugUBY5?=
 =?us-ascii?Q?iay1PkmAQY2Xe8B5Oq+fBc1MdcHxjxsxShooXkh9oHyY3ylPrqFIaTJfNIud?=
 =?us-ascii?Q?WCGUeD0zQnSBjqodHZNpq/rb2gIgAZdbl7VPMv5Sc/j83We4M1aoA34Y5Icu?=
 =?us-ascii?Q?12nnNeA6Dnjk+0xJ1Sq01TLT2Pv4g3Zb+uuHKe33Ixy3sxZfEde2RctUMQZt?=
 =?us-ascii?Q?wcaAqjiFwKOvu3CLDifGlwd8HgdBuHrEGGahWjmboJ7HSilhRoZiSMq3ULrt?=
 =?us-ascii?Q?NlKsJlO2HzvEN+eYFL/lQFGw7NNDOeEdzd+7utBRcv85sVIOFGNysVqRnk+/?=
 =?us-ascii?Q?zn8TWgSuiHZxcC5WheDwls/6wq4T0f/TYD5p0DtXjL83vRhbxamj+4OitDYH?=
 =?us-ascii?Q?mGnJXWyNWii7jBMKJVFUNZn25S+E+YW08cbZMCKEiqU+EXf//zTzmD3lH0Yp?=
 =?us-ascii?Q?A8wKo+sdeyLINJPWNi1BKX+x7fh5I2JcPvLobhzKnl+nPYedOvUfpbyaaeLY?=
 =?us-ascii?Q?px7TNeikbsirOQfjuDaO/CVEunWgRRemHdaqxVkogQeVSo15NCJ7XHtdNKXw?=
 =?us-ascii?Q?0akVLNYu27GQca4HMR5U5k6FH9mXkkgIG3R+S53xyk2vY6Y0yAhF4SUykJPL?=
 =?us-ascii?Q?GgG7YvUJT5qOUS42U9f/S6PljCc8MdU6K/7b27iAX0Fp0O1NysJNSgBRDjzq?=
 =?us-ascii?Q?16LcQGHU2kq3RROS9EqmKTKEZTPcqFbTOnFLduAVVFtemEhaqsK0RHhLFD8y?=
 =?us-ascii?Q?CeGSl1xsP1k0kAqP1+J7XwVgZxpE7OiTx15dAieegQzooaa4lBIiTFes2fVG?=
 =?us-ascii?Q?vexi9gt/ZUQbLFRdRM5+xrL/bWAzb9lkwH2ZkX1VLSUUa6uDjX7U2na4GXhd?=
 =?us-ascii?Q?F7zJcKR+bOb1aqQDO3zs+b6ppPjlvQLdSYiO6i+w8188t+ODDWMe8RJ+AMNA?=
 =?us-ascii?Q?mh/llMAg1iyoyTPUXRfoOPEf4ya+0fb9qmvHDr/O6mdJWTvj3IybuYwTh7BA?=
 =?us-ascii?Q?ZzNdHo+C8TwA0r453ldYqfKpo9/aTm8+bQkejb1qe0gKXA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pQzC8FkQ6RkKVxM2epc1IWecgnIchQtSJF5M7vriBJObM1D8PcLyTEL4ilG7?=
 =?us-ascii?Q?n0sXExyLown9vXR6oCadfLC5w2x9jjFI2LrxvCr2HzNrOqjybjLktAgalLkg?=
 =?us-ascii?Q?qX1Yw7ZP/OWCjyUxgHkYeQACjhGoMCaA1A8pIGw8CUeYeFQuDTtz9gSI/jYh?=
 =?us-ascii?Q?1WZ+q3dJQpOMsQCWff2ljtoCekFbDr57c9xL8z+cO8cBgeyEvAQnVT5n0pAL?=
 =?us-ascii?Q?oE10B/FcDqN8bk6hMlLmoDVajHtzYnsGCBylZEjMOr0ReAney9L0bVkxLb52?=
 =?us-ascii?Q?m7q0QMUV1J7QIhgIciuBzQn2a8vrEOyhK6Jg4x4FWyVXJhdUtt4ua1GaOYtC?=
 =?us-ascii?Q?phU51JJBG6VF1pur3K9cG7qDtkUqMkRW2/9ez05hmFaD+Kod3VbruZVJZKHV?=
 =?us-ascii?Q?A7Xiz7+YdMIWAnNk0/yRWyr8gmkTWJ5UEaTRAcBFllhmjLXCrVMaLK3mm84y?=
 =?us-ascii?Q?c43iByoskW3cslFJttSdQGtEsWD/6Mrk1/mvzA88yAODG+UqDr+CFIi17IzV?=
 =?us-ascii?Q?/rfxum62OXvbTsgiDqwiA4bjnLxItn5gE515vjrx/kDKeGdspi5De7VFnU/a?=
 =?us-ascii?Q?6rpuBwmeex1XxFMqmt0C3f0WrMKzx9CwyQVsWxWcw4memTj2ZPECfxVibN0U?=
 =?us-ascii?Q?cgu8mksTCqhWImpQFRSwsncjCtS85SUcyySbUU6H9hAc71DInFAEReCT5oq3?=
 =?us-ascii?Q?1FwRQTOFeEwdwYexuE9e+JaY1zLYn1OoEP9nWBXHkjXa07PtESpsqd7SCSGu?=
 =?us-ascii?Q?hggI7Y9fPUSrrpK3JhIlJq1Dm/eMZa3OPgEB2emXJ3rf1Xzdp2Z6I+Us6bx9?=
 =?us-ascii?Q?fdOQTPUitiT4ezGIhFDS2kGxMepNMc9ncf30f0OK66E+psG30EWjP0qavitP?=
 =?us-ascii?Q?nkIhWUR3Inqt7/RkBV98DrPOELTjSJwPHUiL8to8Nzo7iREGRoAvaZSsMCtq?=
 =?us-ascii?Q?Lj1fvKkwpaSmGOwEMCu59cfHyfgisaZdKoxg4B0gd73UENpMrHVgn89xAp/B?=
 =?us-ascii?Q?b0/2zPoHP9Qgcf8RlxRRiueb5REMpmx7FerfGPfFYbdZzAD8ijtJSflfpUds?=
 =?us-ascii?Q?IR4k6LVIst7/YRKt8lAO5zPJSM8AOvByZO4Eq4eXFAzKu/Pf6PKEr9SqeNB0?=
 =?us-ascii?Q?W4zdbPxTvTlAdO5ScakSiRvpsPfcPrr/cJaFazhRWXguNGdE+BEJ7VmSTgtU?=
 =?us-ascii?Q?SQi2XaBpxMHtDpJmKrAASM5wJKCUoFOp9S3Ujov8thLyLhXJ6j+duTcXZVQJ?=
 =?us-ascii?Q?/5Vc/Vo6eisvbr2ThPTmtTPI6LYCZ5y5xPyY7CRtZ2vsY8WrmoDp2eWXOKEL?=
 =?us-ascii?Q?Wx/62jkTnEKk/t2BKGtaU+mEEptMQoDg5jN42jr0oNc5xER/OJoHJmGDw+YU?=
 =?us-ascii?Q?N7ISOhTenPFSGbaklgPN5+ZySnvkg00WtnylQOaefYLf5a5CdbGERZUnOC4n?=
 =?us-ascii?Q?ySoCr6mQqiimWM9Fq65dEhbTWcLjfhpgKil1V/GaBeSQBmtyufM4pb25bTGK?=
 =?us-ascii?Q?7UZvsD5Q4Nnsey+B6vdczsMaoWZkEMWaxxuwal0i46BDqOr8nAfC+KMoNdLY?=
 =?us-ascii?Q?OO0LMfEfIX0OkjqUah1q5vNpn8QgX40nBO7PrgZ3MGAqymkq/7hpPDZaWkpR?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	S7xNTXxx3TgZbCcrzO2/qSx9auZ/+KisdeOpCMyox1OKd1T+pMTn2CYogVjp8YIqlpledLFKwzKhw4upRtcdlpa8GiXeV0nFEYTBfIUWnlGkO3v8m68CKV2GGmKekWC3zSbmbKFAWMPBiLJDWNBkDUhufgf1n/+Q+GnzNQ805NDK5odfFYXMDO3+rhvI3CZADr6I94rIBtUcBGMqQ55HqfvXR3ksPDacRPWiD44mIn79HzNyO256PA1uPNSVNYbnz/QNJu+e3dJ9IoewTX2gfEb/Bqpxt+2PFCDIO4o1mvBK+v4Jec2RJximM0EMbv+dxlGdyLez2FWsycQfgCaYa7+kqSoDh6p3gR4egrw8anIMEo+RVr+KM/PbrF+Wj03VhetkcpHQtgU/9eXdZtv6TxzK4na1bRrimaGE7aB9QZrNrqWS1eAhjvmuAwPP/vCvUKmE6c4PvScboUGbalv5VwRiE7H5TrKuaMx1G8sPKZrGLWGYfcAdoo2YE5EcNKH4fm0q73mvTYoMPsK8vROxoKZPOmloWOB2TGGLGgq+cPmkaq/GrbW5l8mYHhCQACX8a5wwsdoCopqNwa7C8PWXHo5bKvrztsO+tkjD60tUTLk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bbda5d7-48e5-4fb2-0805-08dc9c9db84e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 02:53:59.6503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWBHjAE3/wuQRXBH0XAUMuVNKAibzzTnJqq2q22Loxe39UbbQsuS4WCBuZItojkubAq3D0jGnslPx82SQqbpBDetdjXGjqY3pRHLYuR0LpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=693 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407050020
X-Proofpoint-GUID: mdBOQPbyOLL9Ii6Z-m-62uJzgExZMbm7
X-Proofpoint-ORIG-GUID: mdBOQPbyOLL9Ii6Z-m-62uJzgExZMbm7


TJ,

> These are 2 small patches to prevent a kernel crash and change some
> logs' levels. V1 consisted of 3 patches. One patch is being dropped so
> it can be reworked and sent separately.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
