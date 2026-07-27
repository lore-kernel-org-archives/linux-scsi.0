Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8DC429CF1;
	Mon, 27 Jul 2026 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163472; cv=fail; b=IzmefoqGwQmIsNDverF4dKzEUwTIgrFxWZTj8J8T9EJsDm7jnaEkK7msa5ss03xgnE5ZnGqxSfWTFEyWNNNF5bPB5GOEm+0eghoUiknnalUlQBTd8g6QjUB/S7/eIO/ndu/vWiv0Ro384hH7/421o9dsJuExuSqsVyj2iWvwyGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163472; c=relaxed/simple;
	bh=GC8tB2+9bhUIq3+SCQV/gyXTACu87D3I5/DCqVdLFV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YEflae0J61ql57Vn+ofptd+0piyNyfJppnui59ZtZeZI2FW/3qtIFyktJoPJYemeTLmRRwizhsqlV32OrtHozd5s7LcSUpIRHr4LinYYqbGTbn+YPCLWsiqOJFSZ3aO7bUqSZ2dxf1EI+ONOLDi2+dBDlAdPtFtj2jqoZ39RnWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=moEFgjFo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r78TU07K; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="moEFgjFo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r78TU07K"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCU1u53048935;
	Mon, 27 Jul 2026 14:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SNmGMLmuLEpUvAREMomZYROM94tdu2ghrGvVv8K1cD4=; b=
	moEFgjFo5k4Ik47EidY4FHMhTrdD6XdHfVIIuQ0o7VUU6ZrG0bJx+s8ZC6xY9RUP
	Pr0Dctc48lOqXzG2MHoBvfe+ugwE5e3CY8HNkwGyXKVlH4C07BK3T8V9WoKxK6zh
	oJwq9CoSYfn5Pee+93mUIfZJcADLAvC4m2ARbQ7yIImmu1fheP3jHK414td69ZH/
	UUJQnHTuymothb3xlf9/vnJZ5dbNAAHDfqA9lAVBFYRj5ljxd3njRDpqF6sk9iPw
	cOIbBrb8WUnF12JR9d0ZW/P6xG6v3OlmfVUf86tBO9PSO7jvFx23cL5IL1T5wBtj
	OqPXkq5GGfk2dhx/KcrBqg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyy9yq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REZi7Y023434;
	Mon, 27 Jul 2026 14:43:39 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ngw21-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1/fuqNfKjutVBFyXy/aU1RD8r3YHw+EDZZU3U9/LMIZQCqWOcVqi0Ry1VgHKUYcs4HS9h6eesfcUwjPWfWfFWqA5apgi9687E0EsKfI5nTgoDIqLIbu0l6MADS2uABnbNSoTkCXi7+OrkYpx+D+cR08tgxz1FP2pZobrpR6V/hyiRLcHbLrviUd0aXoW3wK4dKR/AexANoHz7L3IdmPzNLiCFJlRvljvEZxWryJYFcmG8tU2Ph/0l1aDe8BLAjAPI/v+ODOAsBiTxVrOS+0kmL5gjtrycY7TerRfNpzWJlsgkM+h6wbeOlM1FYWzR86tlRnzLdPHTKvMGPNYG3L1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNmGMLmuLEpUvAREMomZYROM94tdu2ghrGvVv8K1cD4=;
 b=YX98wdpoJZTdhBtHtbZGGdU5CfeOxbho3dGlTcvbXrdVH+dQHeXfd8Ac4z5gemB1C2m+Z1HFfw5xHIBx4hhjbXHUEVxyiqbsy+ug5fabU6/vWkHQwCqKRF0XI0wMpg/gO8Pnb1NMlpM72zZ5rsiJLyyiBh1HgIRLczt78fGUZWtBJS4xutUqj28Ve9i28jIoDRLMqC5mqW0jibbEkrVVgOJOqBHtbj2bsYYXEOrzKLiK1uq59QFRUS4d70jqDIB6DfflDCl6rJQ2aY+HveC0rrGk41xjHi3j4P9dnqElylvb/9xkeqhKqvd5Gsetozz3mzhAYLUyDCFmlNSTm1vUHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNmGMLmuLEpUvAREMomZYROM94tdu2ghrGvVv8K1cD4=;
 b=r78TU07K8zfuKeMRy8OEUXKT0FUBQY9LhuFb7y7RcxkOC5R52mFgku778qCiObOTfuJkKedQFw3WrZZdUXfvgUV3T2xDbNHCXku63YJ7xVDPEffzHgsfijF/ZHbZRBrKK4OFarVwmB9sXn5VD0JIeWWCdrT3RZw3xDak+mnP5xc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:36 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 26/27] scsi: sd: add mpath_numa_nodes dev attribute
Date: Mon, 27 Jul 2026 14:42:33 +0000
Message-ID: <20260727144234.3802948-27-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:5:174::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM4PR10MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fc71b85-79ae-4ddd-67a7-08deebed70a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xcFMXa8fVSBa4yWxw6s6auKGhtyNky9tn35+8XeNJ0Ss+GT/gi4UZEt7F8VGhUSEwD5JFk2Mn4zTCokSNWixKhT5gk5Ejy67Jhwp73m/VB5IBDpQJZNtqGCeKc3BuAeWGhP31whXbPFxxvLjHKTIRDD/JmYalBYfXAt0IetJt5+Fpme65Md/T/rO/hKoiRAbTdP9reCubteidoTraepCs2mnyqXtxerPxukrE8LjScdNyYZgDYzwABWXB1NFl3545sRvEEg6McNa99dgz1zL8b7AYOUw4BQaIHx9WCgHV90CI+yvrJaXl+3pLRaIYFDVUWH+MXLIqPdWoLDdKmYKcjf1vFokwXFTzue0S8uK+4UngA5HKeIsKdolaLjCbKF9K0yOSh5QLQBMJ7ANFGJFGOnj9OpOajoniTNSEjPHIaB8lOcaKYldTJLqgMGKu+cYIkD5kQRf3NW+6OoErySPnuu4r8ln7ICRv+m6valevJa83C1jvtvkqmP1KV4AbZjHMXcMY/bVl2yGbEYPXRS1djarTkj9V28ZozVJCJmsXzy8TMaZAc6YdyeA71QhsRUQzwOtXdirYst0GVgTVY/DI8vQf7LzuuOxNctzGZx2vZocQ+FjzkCKq//qY8FLT2V7Tu/taQyE3ZLhDHe+1Al+qoeb55xkIJuQXOmRBThPJR8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NXSXoQLv0qtNa56vyUJYxPRYB5syRsrYBXqp1lT5P7JVLs8GXexCRI9KD8kf?=
 =?us-ascii?Q?RKuDnb/QO0QF9ivZiOzVAKlFSc/8QNpGEMlrF6ePXewyd3R8faC9y7nogcJ/?=
 =?us-ascii?Q?Qu+l5Cwe3waC4BmvckW0X1Oz24CiEwowBahS2SRx2BjJLl7s8mOAKUZ/2/wu?=
 =?us-ascii?Q?7GGo3QwMPwbRrv/6YWbdl47RLyg4HA2g0L1PFmELylRxKhJd9/e5/ZZkOiJg?=
 =?us-ascii?Q?W9kk8+nBKsGLbzXa8hsWrTzR+PjjxdZIZQYxw+xi7beuQz2rmIQDDKIkiQh7?=
 =?us-ascii?Q?7GTKT+HJjEG815Zjsdr8VRwn53BBpG6zAbxJH4kWVBNG5VAdTph0G0V1F7JO?=
 =?us-ascii?Q?RrFapcBj0Ax8IGuvumeU0McN0kD8dPkIz+i39pGb4E6+zEiC1CoSCS7eoNkY?=
 =?us-ascii?Q?MJuroSzpAU3YXwyw49U1VXxMGNPJZ7EOuBUXMPF2MeLbjADwRWFW6yAEQy5p?=
 =?us-ascii?Q?xU9tE0g6Non9TcbjkI68KC96WjWyC6arwVU8cG/q+Tqh0SRWmzC9VZmsKV7B?=
 =?us-ascii?Q?LAICYTlmoYdcWSiGVrAAiD7V+hO5wpvcxBziR2Ms6SX0qooWsS1RMoQ1S0+z?=
 =?us-ascii?Q?LxVhK0YSEYD8972CfcTMy0jJ5TU5stOzGjfemmr2KEzSNfWuLVlEmCPHPRc3?=
 =?us-ascii?Q?v3n8o+jhyOCd9AqVUCEiFza/xuZXlICY2IZM2ljXDFBikhjPgc2S35jmwvrQ?=
 =?us-ascii?Q?JdRoQUUTzbmDfqUO9rU6jAqQ867AK6skrNFS1hRVpc5+AjWqBTX7SSYB3c6R?=
 =?us-ascii?Q?aliAFHCkvT13aRKwD/nkVPwOap4/Mnnd+ddN9iB62IcDwPNnNS5GsFYUAK+b?=
 =?us-ascii?Q?ASF/09NA3RhKNq3jSYAkNnOrbufXtFKnqFCi0d9Jl8A7wG+xLf5tXFIom5NY?=
 =?us-ascii?Q?QdrM/xjBSmDclZuB+QDyKSI5pjOUSfv5ZXPBkrlVV6q/g4Xzjv67rbKW4wa6?=
 =?us-ascii?Q?LH5Mtelzhf33gDpDuEJUWBOVPGJr4PVbPD/FALu3C1dFju0TDhpYRPD4vaCg?=
 =?us-ascii?Q?g+gqicfOY3xQzrBJSmYRsB7MQpMRuQZ7xzNKepzyPA3ThOs07HE/mXR8bGjJ?=
 =?us-ascii?Q?Y2HIKnSxgR0pHtVRXr3pGRbFPdhWlWitwZEMrMeB9oGHKWGhrRBUoQzW6ytT?=
 =?us-ascii?Q?6gEZiRjtM1hPLwuqIroaEw5PhxGILlM6smjNrtt9EMjP+wYUIykS8uZmGWF7?=
 =?us-ascii?Q?YzQZpX5BiCR6gHJkWWOXTlt4w8aCF7Uh5X/sem7uXKYuGEBaWOITbq+IO1ku?=
 =?us-ascii?Q?mvoBsHrZKJJ5rJB4/aoN+TkB32bkWAFbqcM/z5n1xXdcWM9w0gyevG0EegbG?=
 =?us-ascii?Q?E85sW27LyjWnULLk775Z5pXP75YO70LdvRRGlq0SIzGYQNvtsoTv5nqtOt1h?=
 =?us-ascii?Q?+H2xdqFmeIHJ3EG7n3+mLtTZ1921gXAdxtt9eBFzJjTN52M+nIo6aFJWqj5D?=
 =?us-ascii?Q?ci5ru/a3GFSNytk8P5NNHJHIuFvATOu+wSUEtJ4JqKKQm7Via3z627hLNBEF?=
 =?us-ascii?Q?z7JiTAPsYoFvavLzjXMedxhWyfr5vjq+6/vSWRbdpvksM9qaIlen/kwDGwQ5?=
 =?us-ascii?Q?bk0YnMMVVKS6EqTEEUkmD8VPDeW6XNy60BdMnAMHli8B4kpTUhjcOvYf2CUj?=
 =?us-ascii?Q?4Ljnery64fKCE6QEG7WWUBnW4lmgPXDRJTRtbTCwRceUJJUGv5gwHyJ8gE68?=
 =?us-ascii?Q?mgrnMkmHpNuKCV1ZM3zW3rf71HACEEOm8sS1DM2Qct2CEEt8500pAdkRlL2G?=
 =?us-ascii?Q?+ooQrYUoPRVJFLRqIo0aaEgw1dYEatw=3D?=
X-Exchange-RoutingPolicyChecked:
	INzdtmDEo+3ZrdQAB7/BFGyQ4SfB77/dqVh5Y40WGj9iniPrCiXzfWFFWI6GD0Zo1YBiRbUgx9Uia8p8OEcuimaRP1j2k72v9rn6mMUDQDhz3pZ43pVYhvdYObsolo9c4oFR8yrnNA+pvGnRY0VI/9MEtY/DaFNWY4Qz/1tM+7zAEDCpN8tLmSNTCn9jvCQdakGXQPCe9IA8eS1mJB95WMTEwJGCLpIAybgD4oogEwDv7+CMJJQFa2XlWGTS5/wgqKzWHVGN7zX36HqEM6xs5t9zEoRXnIFBSHT0/uQ4NSJg1WWUkFlW/owQZjz121VHpX1xh9aJcoQAeUmMyiNsew==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pw22390UI/DXXRmKf3VhJ6GlJk4TdsdlayP82ucxNrQKhlEurQsFXGd1DxNieyD9s/m0UdkUgwF+64bRthrFHhnDNSCyAma5y9iywrWT5375uflwbMF2NkWQVkkhikr43LdhR0MvpaPY4m/im2gC+5ZpWc6PICaMLnxxMrQVp4S/bX+/SmLv7kdwXFJ2CjzlUetHuduQLcHC1jtGKUj7CXJEBSsXUO0CYb6YMwpRWkxBWSxnIVhsWzADU3GdNyqafeP1zYYd5x19DOIICtXr0NPWv29+8Bp2YT7z1OTuYrF0rb4uKdGPh9IK78eN6kYcCpnMS+H5ec4LTmdNWeu6yXahsyFqRCDtmlq7AucvYimIRuYUEdG6SyAQws75UIKbA0bfWdH55kx35ACXUUmfLY9MavciGKt5RjPnmwFovXIyhDTxxspu9Qwq3mHtZB6E/ZIQ+zIXSK7wTPQlsf2abT7ZFOAlcgJb5AcP6JPAkXKRaM9FfCDZUXy3kv4QsIXosTD3Z7h8RYGuwIZe2Eo1imZS6WdGUqBnstALKpxhMpeIhhzpkLnOzoNWXsyS3A8zYODCiwLbHxrgetxYWSknNqWiI8BTbiUKaptbgEFG9Zw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc71b85-79ae-4ddd-67a7-08deebed70a2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:36.4101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FutqI9qcQ3d5zOlhwjv3gnAqSpTZVkAVjQHZ6TOPlwNzdsWSXwR1HBUKdyi74+PROz3SsRTQ9HsqWmA59KejQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270138
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfXwMhQaUnrWzUs
 +Retwl9dNJKUhSomf6C4gQxgaEbbNnxdZ4GXrVezCa3GTjD/UfutMSDQfGkKCogBCObc1t0TK+x
 kkUuDci8NcVvBOE7Uu5MmNL02IZJv0i0HPD2edxuFvfG3pY3TNzx
X-Proofpoint-GUID: 5P0pfR-yQNcGbVqjiKc6-EUWNsYxsOiG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX5PWZlkYiWKTe
 sxDGLLm5Eg8kUxwpHbxPt3WY57G49WSSBiFrizyICyAV+mQMQPKGAFtDabE6Z9L8ifcYBnElTsv
 IB073p71m7fVAm9N1KkNq9+mLeDxCm7Sklu4mwEUhkzLl/LD9PxIUlotNlHs0Nd+mWTtkoN26wH
 WaV26Kq60/xr4arTNsJLwH6xVJ1WaEexxwYvYcl2M03KyAd9iFrW7Jojuxm4uAsGqbVCKZe4Cz1
 ku0/jpp6ECsRCjlsdrfbEXrV9zZY0gRjgVW4qzKTr4/4o+VkjfjGuU3L4jJBKzvLMdbMOWYUCUC
 /NxwawJNlTBzXN4vDuHGBjK1iEFvrqUj+a3RL413hMzi5g57yAe02WNiqM9QxjaX4mh2OvIwOBa
 B/fq4bi+dI039jEPODwLnBoYZk7VBUDOt7HTWvZAeemEzuDuxscsoTZSxBwXrZ5sOPCGzXz9RHh
 zzM0EnEyYbu9nX2+TW0Z1TSpDTQ1zcRDS12BjVgM=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a676e9b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=P2_R26dytZ8aPJic-48A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: 5P0pfR-yQNcGbVqjiKc6-EUWNsYxsOiG

From: John Garry <john.garry@linux.dev>

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0d73b03a3daee..6b6aef361ae22 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4146,8 +4146,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
 
+static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+
+	return mpath_numa_nodes_show(mpath_device, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.7

