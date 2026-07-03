Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31F53D5660;
	Fri,  3 Jul 2026 10:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074702; cv=fail; b=S4VudFAOHfQk0VAWoKERhQygeR+i/8bVsxPueO3Blnfo+tgf2UE19zQDfOa+aEhKAbkhWi4Zpsm+ZTQEVLWVXl58rRljkoiuVVaFvqgM01cTrLZhKGMPaoPIVJQLemulI+raXEbfWT5hGhRo2grWCZx4s8t7twJPbDLblSsv950=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074702; c=relaxed/simple;
	bh=kYy1gFcxgxYoVOk7W+tzkAwIurekUMAmxpSk+ZOm+JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ce64O5rMFM24z1FRB97BPa/ZFhnnvI5j6wLf5XAHZu5U8oN6KHk7rKhA6B9SmGJYCJTeM9raJuWzVRtttKVjTxTUxko9QsH6X3PRUiXKIFiScXPMMyhZG1bBgiF2qKaCN+pZvt9fAU4EkBflNrNCg0zZvLcS8u/mYY7gvCwERAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jpSdlv7i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HCszI0+g; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jpSdlv7i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HCszI0+g"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638uSsC3081438;
	Fri, 3 Jul 2026 10:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0/hlNSWuhtFW7Va+ca/flBm92Fc/8bzST5JB1+YUS6I=; b=
	jpSdlv7iI66DP4tT+fT8zq4GGmFw+nQBE0v8/eVyshoa+TFCOInBSsMGbjrj2UVp
	RLUEW95opjazSvtvVnZb1yn2tl+nD2tjcRXaO7qLjRguR4JQGgulc2vj6HAmnVZi
	QJIzlb44cqGM4beCvppND+QASAw+HJ5ITvX6YlTzPMYktb7CCxmRvZIABTxLqDnR
	qL1KVk5JXuNuLPqoVQtr0Rq2h+EAju+va445gvAjBURNAA8/N3w7nttxUgDL2rV/
	+BRYLYrflpxu3XDjCKoVRFF9BkZ5JrsBVbnvcdTza0sCfq7/7kSLe8Sk4xahjguW
	JsBnGJEJlwvAzJVaVh6tFg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahe0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AT4sj004694;
	Fri, 3 Jul 2026 10:30:52 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011054.outbound.protection.outlook.com [52.101.57.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yu84d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OmJQPBxBKZaHaO5OY1pNtGvN6ikToU8GpYjzxYsKbTx0IFdYP85L8631jyOsJhtkbSQDmbJgGLUZdHhoc+HKcTUid45fXGdYX6rbeC8Pq2e+DBhwv1lxSTSNUXzRyt1qIAcsaaudsoJipg8x+Kw2Cs+GKVMiLOmw/f4Ogdfi3+8RBFnFFwVggfpOIP8Me6nVdf5DSMbqYDdPzIVBIX0avNqx3W+147NYR2Oy/PCMlCAnPv4Q3ISwoajp626vN95Cu0b0hK4FEqu4YaEr898hz7e2k5WQFnULLckzii3FfiZMyOf9mNo3WiJrSwrwb96WJmebxfeSi9E1VhR12cp/Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/hlNSWuhtFW7Va+ca/flBm92Fc/8bzST5JB1+YUS6I=;
 b=DeQQbk2bR/H3p8mc5EWQJb10CjUdZ2ZQvdiEFPRK59AF89v/a53YMfBibrRjj6sMEb61tBb0wp6RFCLkawiQuGfZeV521k2Yem4zWfsjEw2niqb/AVfbYb7CiJKAtXgnhAS9QtMeJSlBItHTN/p2KGi4730D0v55ZB4qqqqzGShtbnMO5Ah7IyYSiKLOJ5oD0dN22LjCsP6AfqFhfjc+Aq5JtIXat6ZaC/XrUudxFaTZKPbRsZIFQcLgx99l0tIhw3wTPNYf/ognYkv+pVG0YRxXdjlm++giaJEOlbdYpKc5/YprM1Br9qaCuM4GLOZ9iFHolRSSgh1z7FOWcenEyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/hlNSWuhtFW7Va+ca/flBm92Fc/8bzST5JB1+YUS6I=;
 b=HCszI0+gDTg2ZGsNVsPgIS+exw0Dc0iapZv9zAAy41nM7PzYw5oU/NiMbrIy/JzrqAFamVPbxxwcjb/sda1X0+jhprs5qRZRLGDhKonkR0nFhhgMBMqb/b0ALE3nCD66FRO5jCBFq4s/fSDknbAUioo4FEzo79cfHpUBroa7D7M=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:30:49 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 03/13] libmultipath: Add path selection support
Date: Fri,  3 Jul 2026 10:29:08 +0000
Message-ID: <20260703102918.3723667-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:610:54::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c96278-586b-4f6b-bcce-08ded8ee25c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	hnlSIExTEL8maBhrzuRZf0vm3m5YB8FoOzryx2cxZpw3yoxbv7+llB5CdxrlLWNnt5AFvVgvMTuf2nHZdUibziaKRZvvvgcr88enOhUkXMQtMJDsDdD6CX0XiPc9DrWxYRjDCPZe2bMbcyIRsJvIjlzVmZl9VKekw+XIhSbq16xHUSJpHN+mU9ALrNlcJytPCxSPlhlDfsklYCiLgHZrC5gKS8zRhiXCHrd/cftIOKOdVPmEitPzu/4RNWbMlknM3lY+M7oDMS0NCyrWTuLFSpb54yrZ7YmbC26/gGMP6cepDnpHEYIG4yx1znwrG08EvO8o2pt/k+fR1F4ldTWAwvgQ/kIAddH6OulW0z7iR1XFVjOO4Ga5Z6wm+oZgX1D0tTF2PkD+IKQ15qufkHwR8W3XJ9hDdqX/zGLqv9nkhEXuHac7WzwA6otp9ZJLMNsPKugXnAWW63vCxuwvDmPtt+EE3T7GkF7Sg9Y5cCt/2AAjtZugnBXTzilh5Q/OCUSxs5uDAoyX4JpzDmaEMpdZI+DX37LsnDySyztB/SSQTLu5UcviaD0OWtYPEMeomgjdu2qaNZWFN44TThmQ2Wbi0qEBHssmm09W8VK4p/JrvNCv9817C9G7sAheVQNU4o7SnZ2iLkn3HSsMtxJ62o6TnISQ82jyEqamNZUut+0iI/E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Dhsi6G49gC7DIYKVkcIONCPt2v1x2ZM58cC+ihMD/Ko6KIVQWdoBwn4z6Yu?=
 =?us-ascii?Q?g6AYTNB7PLAU4kZkS1A6T2G/0nwLtdFlpJs0918kz5A/iQYzq8AWVudgqfDN?=
 =?us-ascii?Q?AH/EwQ2gs5ZrNOEOKum432L69YGB5XLCv97nd19erElV8+m5BLCtMHtpF7SI?=
 =?us-ascii?Q?8vcV1JDK1PkmDwJUkZG9A3+C/MVUww2JSMkftiBe1pDcsbq6yEwAqtayP9RF?=
 =?us-ascii?Q?C+3w/XPRq76eX+bwB34bv3Z/gLy3/GOJLhvjKwkCJ5k6/GPcfZ6ix/sRiI2Q?=
 =?us-ascii?Q?gJYU5+kLEclV8S0E69ww+7NmECPLZ6r+TToI9o4DXE5ZxLVPHGLHz6lzK4lE?=
 =?us-ascii?Q?hIqVZka0LkiBK3XwKUwcmD+agrCUugz1GOc6//IdfybUwYfIBoeBBbARVLkn?=
 =?us-ascii?Q?b7IgssC7vwmtCPRJ1fHg0dQnBzOX3bKgInB91Depsfax1mrdg+/1G0ropZpY?=
 =?us-ascii?Q?/LSWD4uYVYV9koaeeFLdLB/JbaidtfemtjINe2eQSPYHyvU3gIfJm6Dwfi8b?=
 =?us-ascii?Q?SC6XjKyEmJb2OcDovCAt/pq0sS8qh+2MrSIeI/9sCPOeqhirSu75qPSKRjC/?=
 =?us-ascii?Q?fxGqTdQ5tiCDJ7s4h7af3ZK4GXI7Z2D7qFCTAUsPCKkPngFXboJsaDQ/kK+X?=
 =?us-ascii?Q?oybYCKK1Rwi0BDpo/1/lgzD/8KlEahAzgmgkXp0LsZxNI3KKXFfpYDYYN2rA?=
 =?us-ascii?Q?ZwMFp9kcPOHrzfol4x2agAYum8AU3NCRuH5NZJuiSEP5FBOfNGGOEez/kavg?=
 =?us-ascii?Q?fiYOPM8EvLZgRMlgC9KVLQH3em7OwpvC7xlu7AAGGva6mjBaF3ZKc/BMtWW0?=
 =?us-ascii?Q?ZIF7PLvrPiCdtRPZdQ31tYvPoEexK6fyzuK/QcOwNu55cnHKaPahHOh0j6P6?=
 =?us-ascii?Q?lwMpPRKrhVNGLMoVUlsojZ9X/lnM8BCJHRRMTS6wldwOz6r+Xx6EpztUEyFK?=
 =?us-ascii?Q?4gCHRh9zeUOsbEARxV9W/0y4Iet10WAGfeLmJTjN0dmNXGEKGP2PQlXAOtD2?=
 =?us-ascii?Q?dsW9IxF/jcMTJg26ln3ezdYD/xqG3S+AxsFt4yiuTaxOKnN3adCk4P+Km3Qx?=
 =?us-ascii?Q?WVAj7mSWYkpukUQIhYkYVeBEsEEbAjWVSRsoDU7Lb5FpYnpsft5gZ072Q3AO?=
 =?us-ascii?Q?VwUivPdue1umRx64Bbwp2IyUONBq4M0Q2T+/zpWMhGCEf1YFXhFTArtYcz07?=
 =?us-ascii?Q?JsIgxTOoTDBnKbTVyY2VDMy1umRIqMM3oncYKcLJIPAaf5pESwiSkMqjFY65?=
 =?us-ascii?Q?xvWBiEm2PK/EF+kTN/W2Yk1YRWzdJAeh11oEhg7SvdnZWywzM7ONo30FEdyL?=
 =?us-ascii?Q?Lxmwup9Kh1RvyLzQJD7Kkdc7Gv1B/TPuobShEGpAkGt8gqr8L0j8DaMQuwIK?=
 =?us-ascii?Q?/MBbuFouLeXgog2PuXskEAC7zf9K82KSLDZm96asjQKLnR3GfyA06DhsgN0b?=
 =?us-ascii?Q?R6rPXZNrFIa/4hM4t8rMcJRzz2hiUHxMqSvyV8aYqiXW1IUV9nqgr+NBRMpH?=
 =?us-ascii?Q?tFnyl42i5krA/x2T9R+c4Y9mQCMhgGjwp6pHh+7IHjeYje/2csBC9Ulc0Lty?=
 =?us-ascii?Q?S3blAEalrFv+kebYxcWTJVV6hN6SPhJJzAza7reeiuW+nlugTS5G9Q3sGJzn?=
 =?us-ascii?Q?bvWU5S2e4i2gGhmOru9XHID5tShJuMZTgFXO0918RMK/U+h+U1gF6pfEvtXg?=
 =?us-ascii?Q?H5Fw3l2KOnfWZNPiO6e6thcfYFcO3M1j077tQjr/Xk9Afk23VqA40gu9W50G?=
 =?us-ascii?Q?vLrfwRPVcc6B4MAvxo9ctABHEc7Cx1M=3D?=
X-Exchange-RoutingPolicyChecked:
	Dz2jFBCEPLvkVleEuvgFxiQ1b3EIxIe2yXTos7oSF1UgNz1IVJiTdhZXAVAGPVx2+YFPnOTC/xeOYX8p3o7t65hsXGk3CQktkklQlP8x6sqiT3zsl1t9FLUzKmV+91J4qSsapTuN+q9hduOCQVzYr96M/zzj3I9g/zMcCprTPWjhzBRqFyAMNPuYgTEcq4rp2fPySM79Q2VBfVD//0WjEtFzRMVMGIBr7kYIDmf9HH34MxTDkUl+vt/OkrwbtIigokUg2sF1pZzd5gw3uxBT7Tt6otw6yH1l8Sgx91dMDzLcMKePE45VGe8tVhWscNGIsgH1omOowVOkR5T/+lwkHg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9hEpfL9E/6z++bImNryNwFWlucQ0+qntVRgKTCwv7pjb8QD+O5QoJQQzR1O6wo2xIpHMGiOyqkbEso6V7tOKy89hhTbg1P6+5/st7tyi3OQC5+LQAZgJzBIvmSIO1BhLmGjMEOcBbS1AkWiKjFPDBtyOo/jdXKmxn5u6kf1b0M4zqeom357rFgbcOzsNC8+H3DCvjbp11vp4KeeYTug2iwME5RG8q/ZdIsBCjWCamwA3Y1kzCcYvSe2082I2mqk/tS9AePSJ8ymHo1sLOuH5NxAPpaZ/SlPvjM5fxW8xWx+FWKvDE31BbMdHFckn0Vgua97osTpbnDvLGPLY7Al4NwD+F42wWVXZpz2RgqTFdEusfP80DtMqhwxNT7SuYPk/PNjDHJZB5JDBs/eB3tSqZbYYjVIrlvWo6MOZfd7Jw9gL4iatR6VKHYuLXtiwjo3YPvY9CMRCLkrBw8eZkzaRc2SyeP8QbFgKD0ES2Tu023Tdr5WL2njMz7x53/0AHuRSg3fo0oIxZjCZc4SjA5OkQA5TfgHBgUADB5UzxkeBeuViREW+waDfkpZ6cc9/0OxWP7X4M0ObxOSZVL7MruUIz3oGrJI5n2zKVJPyVP6HQlQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c96278-586b-4f6b-bcce-08ded8ee25c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:48.4007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nYe53mcs/kaf8MIq8fOEiaLuOxqG6Yx9IQG/jBP9+jsOSh/URA6duCTDpQYYsN3C0i9J+OSSWneevU/Go9Hwjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: VAnb5aFI8v2C60UdS9tugSlf_U342a-p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX245V2PiVg09X
 uJQ1zaSYDMhy6M8VIKvCP1hYv8/BsvRBYkcPM61Hi+JNvki7DLU48ACa2qjLkxiJw00TNU1+lfl
 jWhUw8dRHK/zajo9EOATULWuV1De3gK1h4+M+ZrjmuYgIfrugmPYRGP7jpK5We7iCxDkQPquiTQ
 QMymtVz287udsFvHm9YIckKq3JAy5hYcXNO45kimvqM0hzijN08Kotd54AQOhiSRQdgM98I+O8T
 YzKpsc3rDDY33fMglaptqM+nr3EDT4KJOtvyiJiRVewnaZ6IIDvN80lJuBgii8soTLjybWS8gmf
 LEJkD6byWlgrZWzGiwmz7bXU78fiAoLW1NKneUXxfKk67bGHftYco/41NiQN/6PH6KlYWDKmkM4
 oiZGq65VzYJQVDpFZ5vaI6TVeCm29YULXrRgckqFwHExrdF08dBHgaev088vpBmUC8qW9Oh3LT0
 EawvHuu0suJxLpN6UExMz2h7z30ea80bIAc7jDm8=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX0LrNgJW7MEFR
 CTP08KuB5n2Ta5cKli/k8Bz1d5ygf+CSWv1SLwZiyE1siUfv3a3dIc11ylK8VarXAZIN8hCQkUO
 6vVZXMF/Nndke+DXnW8NwEZ8G+CyzqP5njQgVcoPwsWADhlXKPdg
X-Proofpoint-GUID: VAnb5aFI8v2C60UdS9tugSlf_U342a-p
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a478f5d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=Lb5UtHSxAhypNmDEWQsA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312

Add code for path selection.

NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
so that SCSI ALUA can be used. Callbacks .is_disabled, .is_optimized,
.get_access_state are added to get the path access state.

Path selection modes round-robin, NUMA, and queue-depth are added, same
as NVMe supports.

NVMe has almost like-for-like equivalents here:
- __mpath_find_path() -> __nvme_find_path()
- mpath_find_path() -> nvme_find_path()

and similar for all introduced callee functions.

Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
setting default iopolicy.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  33 +++++
 lib/multipath.c           | 252 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 284 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index ca8589d5cd8b2..6c75654c12f8f 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,13 +7,31 @@
 
 extern const struct block_device_operations mpath_ops;
 
+enum mpath_iopolicy_e {
+	MPATH_IOPOLICY_NUMA,
+	MPATH_IOPOLICY_RR,
+	MPATH_IOPOLICY_QD,
+};
+
+enum mpath_access_state {
+	MPATH_STATE_OPTIMIZED,
+	MPATH_STATE_NONOPTIMIZED,
+	MPATH_STATE_OTHER
+};
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	int			numa_node;
+	atomic_t		*nr_active;
+	enum mpath_access_state access_state;
 };
 
 struct mpath_head_template {
+	bool (*is_disabled)(struct mpath_device *);
+	bool (*is_optimized)(struct mpath_device *);
+	const struct attribute_group **device_groups;
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
@@ -25,6 +43,7 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	enum mpath_iopolicy_e	*iopolicy;
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -44,6 +63,14 @@ static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
 	return mpath_bd_device_to_head(disk_to_dev(disk));
 }
 
+static inline enum mpath_iopolicy_e mpath_read_iopolicy(
+			struct mpath_head *mpath_head)
+{
+	return READ_ONCE(*mpath_head->iopolicy);
+}
+void mpath_synchronize(struct mpath_head *mpath_head);
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
+int mpath_get_iopolicy(char *buf, int iopolicy);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
@@ -63,4 +90,10 @@ static inline bool is_mpath_disk(struct gendisk *disk)
 	return false;
 	#endif
 }
+
+static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
+{
+	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
+}
+
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 79be84d3d4f75..21f7ffdb22d60 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -6,8 +6,243 @@
 #include <linux/module.h>
 #include <linux/multipath.h>
 
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
+
 static struct workqueue_struct *mpath_wq;
 
+static const char * const mpath_iopolicy_names[] = {
+	[MPATH_IOPOLICY_NUMA]	= "numa",
+	[MPATH_IOPOLICY_RR]	= "round-robin",
+	[MPATH_IOPOLICY_QD]	= "queue-depth",
+};
+
+static int mpath_iopolicy_parse(const char *str)
+{
+	return __sysfs_match_string(mpath_iopolicy_names,
+		ARRAY_SIZE(mpath_iopolicy_names), str);
+}
+
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy)
+{
+	int policy;
+
+	if (!str)
+		return -EINVAL;
+	policy = mpath_iopolicy_parse(str);
+	if (policy < 0)
+		return policy;
+	*iopolicy = policy;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_set_iopolicy);
+
+int mpath_get_iopolicy(char *buf, int iopolicy)
+{
+	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
+}
+EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
+
+
+void mpath_synchronize(struct mpath_head *mpath_head)
+{
+	synchronize_srcu(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_synchronize);
+
+static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_disabled(mpath_device);
+}
+
+static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
+					int node)
+{
+	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
+	struct mpath_device *found = NULL, *fallback = NULL, *mpath_device;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+		srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		if (mpath_device->numa_node != NUMA_NO_NODE &&
+		    (mpath_read_iopolicy(mpath_head) ==
+			MPATH_IOPOLICY_NUMA))
+			distance = node_distance(node,
+					mpath_device->numa_node);
+		else
+			distance = LOCAL_DISTANCE;
+
+		switch(mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+		    if (distance < found_distance) {
+			    found_distance = distance;
+			    found = mpath_device;
+		    }
+		    break;
+		case MPATH_STATE_NONOPTIMIZED:
+		    if (distance < fallback_distance) {
+			    fallback_distance = distance;
+			    fallback = mpath_device;
+		    }
+		    break;
+		default:
+		    break;
+		}
+	}
+
+	if (!found)
+		found = fallback;
+
+	if (found)
+		rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_next_dev(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_dev)
+{
+	mpath_dev = list_next_or_null_rcu(&mpath_head->dev_list,
+			&mpath_dev->siblings, struct mpath_device,
+			siblings);
+
+	if (mpath_dev)
+		return mpath_dev;
+	return list_first_or_null_rcu(&mpath_head->dev_list,
+				struct mpath_device, siblings);
+}
+
+static struct mpath_device *mpath_round_robin_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device, *found = NULL;
+	int node = numa_node_id();
+	enum mpath_access_state access_state_old;
+	struct mpath_device *old =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+
+	if (unlikely(!old))
+		return __mpath_find_path(mpath_head, node);
+
+	if (list_is_singular(&mpath_head->dev_list)) {
+		if (mpath_path_is_disabled(mpath_head, old))
+			return NULL;
+		return old;
+	}
+
+	for (mpath_device = mpath_next_dev(mpath_head, old);
+	    mpath_device && mpath_device != old;
+	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
+			found = mpath_device;
+			goto out;
+		}
+		if (mpath_device->access_state == MPATH_STATE_NONOPTIMIZED)
+			found = mpath_device;
+	}
+
+	/*
+	 * The loop above skips the current path for round-robin semantics.
+	 * Fall back to the current path if either:
+	 *  - no other optimized path found and current is optimized,
+	 *  - no other usable path found and current is usable.
+	 */
+	access_state_old = old->access_state;
+	if (!mpath_path_is_disabled(mpath_head, old) &&
+	    (access_state_old == MPATH_STATE_OPTIMIZED ||
+	    (!found && access_state_old == MPATH_STATE_NONOPTIMIZED)))
+		return old;
+
+	if (!found)
+		return NULL;
+out:
+	rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_queue_depth_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *best_opt = NULL, *mpath_device;
+	struct mpath_device *best_nonopt = NULL;
+	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
+	unsigned int depth;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		depth = atomic_read(mpath_device->nr_active);
+
+		switch (mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+			if (depth < min_depth_opt) {
+				min_depth_opt = depth;
+				best_opt = mpath_device;
+			}
+			break;
+		case MPATH_STATE_NONOPTIMIZED:
+			if (depth < min_depth_nonopt) {
+				min_depth_nonopt = depth;
+				best_nonopt = mpath_device;
+			}
+			break;
+		default:
+			break;
+		}
+
+		if (min_depth_opt == 0)
+			return best_opt;
+	}
+
+	return best_opt ? best_opt : best_nonopt;
+}
+
+static inline bool mpath_path_is_optimized(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_optimized(mpath_device);
+}
+
+static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
+{
+	int node = numa_node_id();
+	struct mpath_device *mpath_device;
+
+	mpath_device = srcu_dereference(mpath_head->current_path[node],
+					&mpath_head->srcu);
+	if (unlikely(!mpath_device))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	return mpath_device;
+}
+
+__maybe_unused
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
+{
+	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
+
+	switch (iopolicy) {
+	case MPATH_IOPOLICY_QD:
+		return mpath_queue_depth_path(mpath_head);
+	case MPATH_IOPOLICY_RR:
+		return mpath_round_robin_path(mpath_head);
+	default:
+		return mpath_numa_path(mpath_head);
+	}
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -84,6 +319,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
 }
@@ -103,7 +339,8 @@ EXPORT_SYMBOL_GPL(mpath_put_disk);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node)
 {
-	if (!mpath_head->disk_groups || !mpath_head->parent)
+	if (!mpath_head->disk_groups || !mpath_head->parent ||
+	    !mpath_head->iopolicy)
 		return -EINVAL;
 
 	mpath_head->disk = blk_alloc_disk(lim, numa_node);
@@ -137,6 +374,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		}
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
+
+	mutex_lock(&mpath_head->lock);
+	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
+		int node, srcu_idx;
+
+		srcu_idx = srcu_read_lock(&mpath_head->srcu);
+		for_each_online_node(node)
+			__mpath_find_path(mpath_head, node);
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	}
+	mutex_unlock(&mpath_head->lock);
+
+	mpath_synchronize(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
-- 
2.43.7

