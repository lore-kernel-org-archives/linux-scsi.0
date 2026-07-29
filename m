Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF413839A3;
	Wed, 29 Jul 2026 02:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785292490; cv=fail; b=KK2el3ZCVM6XNMM3OnpAZyI8jvqvxpUGfVmQW+/ulW4/POBzTZBnsJhRa5lLgK2DuwrithIvn7QYhe+IDuY8DHo9Pkd/j5jL8dJ2ZqkadvGCQqi1o+IjgD2a3DoruQO1bFAutkoEjPAGWPvNLEfCrMTHJW+CPPxRxTPG5NpiWnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785292490; c=relaxed/simple;
	bh=QTGb9sqMZuXLy6RFMKD7wqXSgH2KmgCwGfx5iY8UNFE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DQOEc0dUyHq1aBPHvKqlLt6pItXtUC1gnuvOBpQGRpk9fr/SoRIk/+U5vMdzEgafhfEYoHI9tx/WhNqs8+0pJ2VI1beyaIffuUKW+nH/aOb/iMpxTOWOP7iWIiiKoZK1TlRQ7f1IipAJK2Owioi0JwmIVMMvzSshwWM1V4wNjUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OiDjakSF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tmE7kZIu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OiDjakSF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tmE7kZIu"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SIti931402103;
	Wed, 29 Jul 2026 02:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TiApH+1Sc/6xIvGaN1
	3YDL/DOQjDSyjStyHqGlPb4pQ=; b=OiDjakSFkWXhnVD3cpIuIkG32I2XfRA9PD
	aN+6lp3U4oNTUDLEems9PcDLDbpPykcS2ZdBLUVeuNPUmV1z0IiLsuCC16zvBHx9
	wV66E/NQ5pKndFAwjBvs3oZ3+8q1JwLo7/pgR5aAmLxBmBibNu9usdtNmT8hwXBS
	6iUsgGiy6+bFEQFN1lJBF2pQUWN3gPcpDmqWG5sFeNROTw8QMo9JHgFF7dA8ZuPo
	2d3NRvW/OJoBEQb38WtHtxs5qti53DrKT41D0xAOFIcUZwQsk9OMywefxTXZduxp
	9euLPeInmSzJX34i+Un8c9uys4XXexbqgWcVWFQRh6fWPD6h68Qw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr01586r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:34:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2U7cP038149;
	Wed, 29 Jul 2026 02:34:41 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012028.outbound.protection.outlook.com [52.101.48.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87nnx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 02:34:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zHq98jWuP5/sf7LDsRgLxZ1cnpxrqrV6ExyKZ8KuHmJ1ahiHH0+YEfkKPxUduogcfKbUY8Q82TSjsatKPITzJUHDlmosd9ZTqJLAtbY5LP6B8UYAA4oHLN4EwJ1gExhmzT4qERirzbmiTc/mlnaFeEVWiOCd4ndqRh8sP3+i39J1K4BMOhCWKi5D2uSn+61jXwF7A3uORQ3pRk+uKrDoa4eQCmEMIcHm2jtlJglzf+gVqvZF/0LEtKaZa53v4PvoDlt4Ucsr2ZbIihG2BOiKS9/0/T8qQoxPku1dfpFI/xWm8B0iuEalrj2fEAyQu3lQE+72lcBU2A7cT5nIDPwjIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiApH+1Sc/6xIvGaN13YDL/DOQjDSyjStyHqGlPb4pQ=;
 b=ubF79IxN1IX9qriINn+Kbww/NK44SZDw0obChIKDvL4NylKyf3Kh/zWc6eLkbrouywHqAvdpwklgKThNRy+l6wMQcakCCIV4TyUTOc4UotQbRED8CzPu/qIPG6rh4g4C4zJa6AoPcSIavMT43Fzuu+YCS4W2qXiO/0QYzagP757jybqLtofwUacs4Xh1XpeqaSe4iS4YiIqwvmW4csXb7TNXpmcMVh7wTpq2j/xv2lKkAvJLbn+DwSyrdKNhSTrgW5/dPQRfE5AEv5iRmUjN3fxsGY8dX+Jjl8+wnCXZjFjm8WaehVlDDBKWBHJV6KAobkFOzH2CUiCPbjD59XXC4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiApH+1Sc/6xIvGaN13YDL/DOQjDSyjStyHqGlPb4pQ=;
 b=tmE7kZIuKQLz1xJ9i2Eq7EY0kwXJKW/pMLcokRG6Yu/ECNid0IIUI5XRL6U6OQ4eaBwANnV04YadtJ7ZzsONjp0e+3Gh//Mcia1VoIEhe4hOv6gorD09+sMnUzhHWShVSJ24qDHK+xdomLuOPUmuFnZnz2xwY5ofEVnmVt7qUxc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6218.namprd10.prod.outlook.com (2603:10b6:208:3a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 02:34:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 02:34:35 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
        gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
        aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmeneghi@redhat.com, revers@redhat.com, adakopou@redhat.com,
        lduncan@suse.com
Subject: Re: [PATCH v6 00/13] Introduce functionality for NVMe initiator
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260724174811.5118-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Fri, 24 Jul 2026 10:47:58 -0700")
Message-ID: <yq133x2wml1.fsf@ca-mkp.ca.oracle.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
Date: Tue, 28 Jul 2026 22:34:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0001.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: dcd42f51-599f-40d6-93f5-08deed19edbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sz/s9hbG+Sac1/KZUHhXfes8QEJEM2POLluaSWqb0RyXdjehMOImP+R2OhWN25iI1ry6IuLIyc6vuJMvq5gEQfvoJ9op6WNuZslSmDlDA4qhLPKthwydeyl1hWSTqdYwIemRvm24PsEv+Gf1tlyOhuXwOsKg46LLote0DB1zwHAioYBt40wYfR6JvTSBwl7s4lb9hhGlh7Ij4Hvkrj6/s3zRG1Z6MsdMja73MWYN6OICnHRafCOdc1CGD0R/bUEu3bYPVepqgAEuEQTQoz7kVfEL8PZ4oo+jO+mOiO0vBYyvYXA3FA8YXtuVb9YXvLS0QqiJz+oq0As0S+3bBzqjOKA/qH2L6wzHGQUGOz6RFJ1G2j3uPhRWTLlhEKJG49kaPr6sCWoatuIgj9Ida8/P0JkLsgQ1oSEEUM/hhPsT/RvzlBMuNtmt5PprwaOhyhXYVUMbTHIXOs+TfBG595I7fkFIHmh/Xr0ioG2UfdpanlKBE1xpf1VHrKtsct18445RIwVbX25eIkS1CAdUWbX1RtblG6pTy0DNFubRkRZpB3h9IPBkci5szR9vc8XMHxwCWZm/efZ6tjRZLH8suvnEw4bOSdf6HOaKhxS6lwrile8lgPOF7pFyq+X3ktAHltNMjiHDv/IkV1fOT86iRwR8wLuWTrVCCIjJErTdCTXaD14=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C7VfcoQ/yM48SupTLLVto+8nSGHhc5gDrHfjwtFu6YI/sPDlV0TiQTrCR87C?=
 =?us-ascii?Q?xiEOaVImtNBYIjZxEvEiZgPZQya7kqTBJILVCougJEdowViCM19RM6glfBMc?=
 =?us-ascii?Q?8qPXrhZBwJaQ8fTG1qNw55thVkEWmoFRNk3KKUal8g1jQ1L9pdO5ida17s+W?=
 =?us-ascii?Q?4MtzFoWWoegvwdTwRJEgXDUrZ/5n4Cb57PAzELLFdpjDKSyMCobJPbwhzjtE?=
 =?us-ascii?Q?cnR2lA6CvGdfekowN2OREIYVUneZqhe0q2Q8U6bcB0FR2cg+lK/3k3uZhcH5?=
 =?us-ascii?Q?qE5FQOxd6dYBav2V7VsWHeWzSCgXWTUg9fmn/b+3eT9TEUoo/ZgWpKM7mM5R?=
 =?us-ascii?Q?drWYuuDVoyV1Zqshg0RUb+Fh1aLzJcRTm9LB1FlmmGj3gdSdKFhBoHHgU9pW?=
 =?us-ascii?Q?JIwqwmHgRO6dmU5pniI1ovBiBChnv9FWl9gNhmdHyDqE/kIwyO18P7ETMSy9?=
 =?us-ascii?Q?qDfAiJmD0k14FNjeHu1Kw/rO9DfUi0gztQ+uxreDFOuWdwmqRzSsQD02vl9+?=
 =?us-ascii?Q?dUyFkiIlN4XynWIbkShlZUnvINfIP/aYNGfC3TyXMEAkqbHD9icPq0Aqj9kY?=
 =?us-ascii?Q?ttFNw2g1TvZMfp3vye7NZ8Kw27XuEVBUNWlfaY0u/MrPCUtjntEq966Fd5yh?=
 =?us-ascii?Q?3JKJd8fW5b0H2pTW7XTFDZhDMHrftdnyRPNBAYqMoQH5EvbHjgdi3Xg29pLp?=
 =?us-ascii?Q?NfEkv5rHecCkmiBoBCECwH4FyCnrIMd4a7s40j+aqMFmA6kPLeLGxRI43J7z?=
 =?us-ascii?Q?tkeTptBoG9n0Ofm5QRpu6xo08LZFR198dhyYkLTNQpz3ZNIB6NtKCFAHLx/I?=
 =?us-ascii?Q?aqq1401o7RNa2XuY+MBnWsYTtA4lnXUpKnbwKoCnG26tyDL/jk5I7tH42IHF?=
 =?us-ascii?Q?8Stv/rc9+6Fpb82ORfhBofHgQ7RZQPOijYJelm+3QEIpMfQoa/z1Qi+OGd8F?=
 =?us-ascii?Q?qOVss9AtDC8zwjg+zRz3vIbWlI6e1f8KD1mWm2AXRooOrReswGVhCXDGNleP?=
 =?us-ascii?Q?GnmKeHA0D6/nakrVEcrTLeuXhpq6O52/Eg4N2GPwYjcqKflJbNT6KSrFxn5M?=
 =?us-ascii?Q?0H76CYKwH2vdumDwcKQroHhrneyfRCFSPiUoy+uBUd7gCcSJwbdnnMutoQ8z?=
 =?us-ascii?Q?xKpSHAgw0zh7LlurrYn/Db1FtgSUWR3CKcxibdkG+eSh4JBgylFJWXwMoJ+Y?=
 =?us-ascii?Q?Ja1VaLKFbRIZJMvW5ilQ0alTt9/jFBkhDMbpvl0Q1neLNnR0e2eBATd3CYwv?=
 =?us-ascii?Q?y8UOA+JykBI21vEhLsQcUf70GLhi7XNOnL3NI/l4EkYqHTtlMnonP77sYzxY?=
 =?us-ascii?Q?Ts6gg7JW2hceJscd/I4M9RaSvZXTuepIM6oyeL6NtTDf+Q24kmNcdB4UjerO?=
 =?us-ascii?Q?v4/G2px7VdA3uSx7BBlj0QbPTYxyAO+YBuAVUmfPa3zWVKghKl4aOLEDfhQm?=
 =?us-ascii?Q?Uxu+ANs4iXjHpPfHUrfC0klvyLXu4fXudjWl/6utv1wRpJRE12TVDt1tol6M?=
 =?us-ascii?Q?LoUnrJbPoNT4NY7yKFFywHIbdAca/dqRbiim4R0llAMRS0bcgefKPFCCuErf?=
 =?us-ascii?Q?79MXjqnydTCc9dCh4hDet1ech12btkTBodmDpLWsuechTRyEukt2pzlcRcD1?=
 =?us-ascii?Q?FFSDypET1uG1AzIu8iDVlrf6lbrlRHZQkNU1NE4DRIShbfmKSaY+39BkQ8Ze?=
 =?us-ascii?Q?K4Hgn9WKDSp0TYUtSa9XDujRHSEMXd2GTbzGw2O3O58MWlSkZpLvXRutPEwZ?=
 =?us-ascii?Q?3Pz46akVt5gCmVA7McUig4cS68j3nsA=3D?=
X-Exchange-RoutingPolicyChecked:
	s/z66tCyqTeAbSd4vXflTWjSfxPLzDAeIGpW8JaQQIe302X0jSp3ETQIl9khdhV3TPi+99lg/CPohnmXm3A2OGo/h91JxFk7OmPcvJn00HGX4SzhsHHxsoN5bzcYhpQP0O8MfafscmD8W8R1uO/OF/ciDbPoJ7OTAphIf2CoSp/CsTS4qEnAQrMx9RfYaIgEUpo2dtbPoRJ9OMD7xbRv7g86rCrfWxQR+lS3WehQfJ+CuRWgJz3Yi5h+ppz7hsM5IZlZK9/Gri0DKNIvqZPstFdXoHOPHLn1fbWDmplVxDmvkDReNeYf0u5G79n9Y42Gkqka+nHrLgNFisBLsNvykg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FP6K0f0eYfHQwy7+bo3MuVt2jPc9k2q8fLYEml4VgN+oVE5mOXOGRFjTHxtqELJEOInIHQTi911qQMXAyONhRUy0CK7sMKJf3fmM8XA6DEWnHRH/k1AP8V5JOQDW7lATuK3rrAtNuTlSfFq0hZjlmM0cgWrOljv94vXLW0Vy19PQ13aIl+R1dneGZLCE6iQGUmFK/4CNZRPOg8zzh6C1Rm1JWwOUhu+9L0hcm6fUDb7YtRb2ujWuW8A0k5iuJICRn5lG90sJO0H82Xaez43VnrhOkKskvSJ6iW6csvFVIT5FIgljIYNEKTbvQe1p7bfelTQeGrB9dJPN+9MeCZDy2nYjMHNprtiouGlak0J9T93xo9dkRYrTgdoKdv7fw9j2pf/i7Ht0r5khq+8aWdxeFZY+URCeNbzCn+nOQ5A8vXl8f2kwZqB4BYexBiVuZ73OYDseyJ5jdcgwI4QDev+kPTUa8LXsQDikOi/3X6ldzk5ZOcLS6XfMRIZ5nWbE5WvB4zPDBONK/qTJ9aq3KJhiTnJN5WTRGfbDJc5ETyAf3E44nF8rR076OJeBa2GsMrlmPpKsf3F8VnhmVR58rMxi/5lEN7RrIMS92n0Vpg6gsvo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd42f51-599f-40d6-93f5-08deed19edbc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 02:34:35.3004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocgn0tEIEdeRtP2Snt/fQU4QW7X9h5uk+yO/haY4D9f7I+ZfHLCoCbh/bUqxbb+cXBwlAFC+vHHceC5SpIgwA3JlCrSH0dA9vysbVmpC3rE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=823
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290018
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxOCBTYWx0ZWRfX3WwL2xj2tAE0
 FWrPrazC5XWLMs6Ytmk9VKR/Q3kmbToRQZYr3dWgiaxLB/QY1z6JGmxHg0arzyeJKLMAWCRcxrP
 kwvVf/NtItvY278ZM5EFfbSHGr4lo/cct0jj+7QAFs/EniFOd0SW
X-Proofpoint-GUID: fzJ79RM5DQEDDckWArpkeuVo_WgA9H-_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxOCBTYWx0ZWRfX0NLZEYH87pE7
 ooLKI/Zi4WOd2V/4Cg7kM9CJD1h1MGI1Mkd5z7iOkg3r6uBVCkufwnD8j6Mqnq08BKJGSLquqbj
 ZCl1mLV9Dzit/UYxE6jfeJZHcFJlMvqiTSckiahGNG+1Ht+psvJw7mm2Q3XnXQEM8dc/btFhcDJ
 +hoeaO3yRuWIADc7A27rqnn3tVeUjK9fl6wW0AggVb6eMXaFDyLE/n154Vqu2+0wXmCD5p+AVyP
 gMFFhRVw/RJtVTESkiVD7My/BCH1Ekr/tCryaBbQGIyXtZofW7NC8jfY5fnZoq9cTrpSUcNPDUz
 YqkEy1e/G7I7/0ODjvr77Lkgz7M8Zp8nQFLuGaT8z2W5Zmqkd9svh+wZrAflBs42WaXIIUfNBGq
 qcOsO6booOBjtSlGt9E5xVfP2wiEyzSgc8L0s5+epkYrYzs7mUM5evkTIFm0tQvsqZ+2ulthYvg
 pj2mkstgish9w7dtW+g==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a6966c2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=uALulf2T401AiPjdZQkA:9
X-Proofpoint-ORIG-GUID: fzJ79RM5DQEDDckWArpkeuVo_WgA9H-_


Karan,

> This series adds functionality for NVMe initiator to the fnic driver.
>
> The changes enable the fnic driver to act as an NVMe initiator over
> Fibre Channel (FC-NVMe), allowing the host to discover and communicate
> with NVMe targets using the existing fnic infrastructure. The patches
> prepare the driver for full FC-NVMe initiator operation while
> maintaining existing SCSI/FC functionality.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
