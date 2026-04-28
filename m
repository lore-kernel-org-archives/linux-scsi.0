Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849141323A;
	Tue, 28 Apr 2026 11:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374817; cv=fail; b=ttpQHw1IqH0PLR95Ay3MQrHD2Og1V4A8/0vDGtyw1o5w68vxSxr8/LRfoPZFCUqdDBPRVdUbxLwJ+iOTxiJ4fAvNhgnZBvf7IWrtn1pdHrifsvOyLEuc5lXdeipYiFD4+KF/ba0sDIFK9ZkyaZiuQ0yPCPQYuPBtkF/8N82qemk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374817; c=relaxed/simple;
	bh=tq5wAqcw2bY7s7cz20Ya9jZGJMwi8XlgekWw9xR/s4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mm3MzRvGLwyY5yAJZpX6JofY5knLn2W6FuZ5T2I6l+xyePADtSm4hT4SMRECtDbIcXTgmPKLGU0wio4i8w3O9xjuVNFNOkIZNZVquZ6dBUEGYoxUoMc/V3SG98+/fZgSbz0qqlLcsZKIt5cES8EE2ArA1ExngMLWzfF/NkFo6n0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ifZ+juLU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FvlskyY2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ifZ+juLU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FvlskyY2"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SATRIU2721970;
	Tue, 28 Apr 2026 11:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fk5u93owBjuGEy8QCCjdne6aDFX1Te9li/ruit8ou18=; b=
	ifZ+juLUIeWfcoWnEHN63ia1kq0Txh1Rbi5Ye4+hfoEzUuG+hRt4qqoww1FM33NF
	ubx+bZga5OgRSD1jyEJOZoW+iCLtBt86OLCxfuX5r0Js3bMJJXKsJOMg9tVTvHVD
	KRMn4FwuXp1IRlHY2dJg+zfd4qLfStlKRz2IFL+bqwTEpLB6915JJqDaz/j0FT9/
	TLLZnUVWOIcL7cfGPawU7Z4lUzRTQU+dYz9gaKrwvSFK4BtePl1gQin4ZEEBlDNv
	lLunO31TmeTAs9/ru9p8b1ZUU78tJSSywJRDi1CTUA8yf47SxGr82VSDQT+pme6q
	ftPU2r3Hhf4jBAaOUxat7Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drn7t78fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCRWL025901;
	Tue, 28 Apr 2026 11:13:15 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ckhw9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQn1qDb+1n8cCE4gQPs/oOAQjRr5a731Gb+1YC1BS9d0ffqWnYIEprvgk1FWhyI1RDsmIke7v01kNwQbHBqgsFOX33yMniV6XGZcTVyX2zZUBvyyEOxffEEXsHdsgU1J3LvAAouw/IVoNZt1JfNDOGkVWPyp8kvRgaUaoaLlTUKjHEMiD6T+paa8Mmrj0cm64MjcHmOz1neUKT6lqEb3Zm4PhU4FzVAZznCdPPdY5CRTT4wgt4GJq/d4h++oJHrdN+6ats8wSuXw8rJGaGPbcjPF1m3KS6KMAXd2z/qK3qKBoZGHmJXRGtcbr96oBaGcRhfYtj0vBWSi630oA2g/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fk5u93owBjuGEy8QCCjdne6aDFX1Te9li/ruit8ou18=;
 b=BOocmMjuTJhhKMmTfXu6EvGoT/+IFOIuxwKpY1Pbxw+aXF2CLDcoS7mFQalssSV3x9hENg0+Entm1H/0WVL2tp8s/NS1Hckan1KU3Z0uHPclZ6yffZVBbvLmsyWMvtdwASiQXKvWC25+6tWohZyHJnpsC/aygdxcbWPw9isoD+WybBy+TWFubib2lc9JKXPT/9yHx21z+m73aJ0i27sIcRqsvE/ntRZV3slkC1hwn1SErgZwBhJ2TJxYDusd7rGnT7ULnDIgWaPq0FA55T3ry+0e9xvrquwbdgmBrCZfKI8Y4fuDC26bcZ1DcvHCeIqre8mNASI8w5Ho2lX7FWo95g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk5u93owBjuGEy8QCCjdne6aDFX1Te9li/ruit8ou18=;
 b=FvlskyY2zdOE8EZspfP/Fj/LkiUPQzsKAI7WfCjsjbRCWXCo+RY/5eg8GKI5bqEJt25yb2LqQ5iLuyUc8OdFYtKsUZCeKP4+2SOX7MRPdZ7II7iYxNkkunbswTSvfkhJ6PdhYN98S/6zzWzIoWl/ZuPGpLqQ0L5E2TX9u645TC8=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:10 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 04/13] nvme-multipath: add nvme_mpath_{add, remove}_cdev()
Date: Tue, 28 Apr 2026 11:12:47 +0000
Message-ID: <20260428111256.1778475-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: f4f73326-4807-47c1-9a21-08dea51721ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FEVbep25z3tYjLu/j3SS5OVT3vD2PsxwBRSbxP9L8tndAnBK4WKwURjGF6IKrmdPbvXWO4Mr93HpD5xGpNMGJITetQ8zM4BtzvDeb/y1B4B6kpdbN5vC6PdVwCA6zPjPW2paBWM0vUDZnCrh0HZqavDUrAhlIZi1mniVbyXRPUzcjxniHvkYxpTqLQUja29EYLhGgCJ9I9102w+Aklwb7BuzxonAw5LX6q3qrmbrCU9+IQC8+CTMdC2VuSdf/J3+qKlgw3vUrHkKTnJU8Jm0zTbIWb84qFR2k02fV3fdMrKdpCDEgeYWRW7q1tbX/Ot8vY3iunqVabOBmjwxQG0ysc8YkC0etTnItfAkHP8zWMnNFMPPap07ax+cOT0h8Zsx3kJ1+LcmfJ0gs83UbTsLbV3KNVaecC+XVnHEzs8hY3slOxSO1qnHz7ZpEOcRRMAyLYMG6j+4fp3GU2h/lpgKoZ0y2wxA4e79uckCyisIs+oPUU6a4IURFOoa7HDvFWk1wx5vffFsuQ+ULVpGiN7GrQz6Ugsw8cU1Zhe843nWv3YPnoxXw2ULz7hIL/7H2VZWoyrvu+JSc1gMCbW03+hHTj3A7BalaGF0GZ06AqERTf2MGriqU5fUuZsWtf45ihXEWyvFRNbAOQlaaFRxmhWguAZmsxU/xXfUyB9EshVsfpWTA7ak3dyueIuMd4JBR/FKNj3tT5AbOSscJVhh6unJTtttilQckvt7HxI1vDbgqIA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9bU3BKXhMSPOG7Q/d1+IlaF8OIwnC/I1KcyYUWiDY61//CVQ2r2qCMI5fNfz?=
 =?us-ascii?Q?WunVBSvUM7+3udGEyWv6dDH1bIwBC4ASJiczq0sh15Uuz1PBIuqQv8Glpldl?=
 =?us-ascii?Q?hzYNphZkq2hLzMnPhvrmwDlH+4oSP7h89G6+0HNBex1xVsFA2VU9NNakbIiJ?=
 =?us-ascii?Q?QjS27khIEvtKentF86Dsd8Cn487YryR8YLgmuKz+flVGwgY1YmkCG33N99SG?=
 =?us-ascii?Q?xI60MD3/IEGwE5X2Edmwd9B35jfmy5OE9MR5aloRwnRMpFQsB+1y4p6r+mW/?=
 =?us-ascii?Q?yYNCxkCpZ2kH7DrJcx2OUlYlscerla8d2nkoVAh5WVHSOe6wEsoi0CKDfMVg?=
 =?us-ascii?Q?/I7YcIlcRLLFhlrf9mZ7GJQGXPQXplnj2H8fgckraI57O8fc+/Hu6Oh266e1?=
 =?us-ascii?Q?KJycr9/mULjSJNMDu1y/WDxn0gFOuURCgtnyCX1eLb/MudXQ/LFigGMHyf5b?=
 =?us-ascii?Q?MOfH+pPLyVQw+vTeEUxktyxKfyZhk7GInDpTGtESISJzlK2VJJOED3pO0k9K?=
 =?us-ascii?Q?i7WSlS/o3H9e+gjPoh27E6fYCXc9W6XQTMvj+CWtKtNfRxcezvBHrhsj6gR5?=
 =?us-ascii?Q?43NTe2B5EQHbK3xJjou0wiEmMtiSVHv9kvQl1yivfCGX5LUip3ga5ZLqFlbV?=
 =?us-ascii?Q?dektUx0h4idfU99Jkk86nql9BiYtMzG35Lqp5wdNdUmeO7+luIrSCKAxx5cA?=
 =?us-ascii?Q?XU4+YZV18DeiSJ+MLUH32vsGcH1dhza6Kj0DXKGqoxPShSc6/Fb7kNsALPLP?=
 =?us-ascii?Q?fL/QXQo+lbySmagnitJhthrvu3GRHz9zk52DowCJRY+ij5HlOXfo51LV/0C+?=
 =?us-ascii?Q?xezHJNWmsJckM7UPsSybbkTZSNgp8Fjo558Sc9b5QDYNzw8K0v6h3JROCM6Y?=
 =?us-ascii?Q?Tz28TO/AJe7ad2F+i6lprNf82MKnNEYWS+xbr8IPQAGRJ77fyvN8HYOEmf9v?=
 =?us-ascii?Q?zK2uJ/wQb2KRd52S17OuyqVUk4vxQEqhZ+G0bmea9Kf+hQv0LGObvFIA9WSm?=
 =?us-ascii?Q?y4NOXPCeWz71VKrj8ukP5AJykYKxAmP+IBZ27i1hIHDEnJ53fxQrKJeq1cef?=
 =?us-ascii?Q?tLRVrixzNciDDDVYaxZ08kbavL39W4OTRjh+nA0426Ub0CI6XOjUUuD+5mKC?=
 =?us-ascii?Q?FyETfpI1TS+4plORVFtZprgPFF19G8iKOMIlQ9HJFDCbD+3hiyjWbRmdM+vO?=
 =?us-ascii?Q?Kq+4HeZ1mj51f2sQCuhcuABFx55ytctE9F+XJ6jbmIeKNIYnKrHCcT2YhQQ9?=
 =?us-ascii?Q?+0JfPv3wgid2GUiVRcDdNaC8IDwRhEp6cX4nqximhAYFn3jwsFaewKU60nE4?=
 =?us-ascii?Q?L6TGLVbb5qhDHUGNTNsdFRFtSLn0Fe0E6UK21Iuq6rew07p/xoUadlNBmoG+?=
 =?us-ascii?Q?hV0SYgOeLWW2cWSehO3rj4Cm77X3RK8+tM/BjWie35e5mZK1SIotMaOn/T9N?=
 =?us-ascii?Q?3yyZi76jJwSFrViUHYzWAKrfCNrimUg0UHIz5xgLf3jLqS39kSAE40lTrFID?=
 =?us-ascii?Q?Iozk4Keb7GYa4qz8bOrlSR1kzFDsHfHkCOGR3+FhjoZc1Bn3H+dREKs1/L++?=
 =?us-ascii?Q?ebmqEH2mQ6uf5yiWWxj06GOamiV5TZR5SwZ8dU4zqe1mQOCDtHoPJKVe5jPO?=
 =?us-ascii?Q?dbJXfewU16cgzECjC9YQD/Erwz3ZxcWOd341y/msWcllUH4jWI+6SdkTumVV?=
 =?us-ascii?Q?YZk9/OJba/zds+tmRIQaYKufmOrsWh+BELDiTEHqXkPERq2wxsaGcFe3GrN6?=
 =?us-ascii?Q?E9s4tRFUSMrMwOo2QOUg6kOJPjT5ka8=3D?=
X-Exchange-RoutingPolicyChecked:
	rA4CuR3IE6Zr2GR+mqXtkCLAndj6GQtMIJ7o/QbtX0LrAe/h797xEclXtUckae3TtFqWjrxRAsWcbbW7pknIXGPNjUaEjT0ZI4eZ2SHbAMsZ4AUOUKR6DWaRYmviTRYTJOF4f3xlEys/fVPW/sPE0mZimXrToq//mHzdcKuwFp2gnqX2Rg8XJQYanKqqXkF1FyfFoSnZPDlkvfXPw0hC2iDyKe5fLw3oZAseKYWrk/vjRXuo+d/kfMYI8PqRSU5pvvOPbb3wpB9hn8QyY8nVBJkUccur7iZ8IsqZ5Nty9+NgB+pyH35FAcuGGwnwOwh9b5bHFJbxkfmlSis5qBHxjg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bivrq6yQgnKKaajQMTL0mxGUeAsDGKXmtXLD+Z4rUB+ES9MIPfX4SYCbjsjmcSdOFE9ModlyVYgwA8YxYyNBQmVVVdYcKs0ZLkB58z5bo71yoxvXGwKcXYaIDWABPom/JEG99+sWLNAVJv0aYOCp2g4iTI17W8sYcnABSQ50e+LcETsWlEfFSP+KciV2dUY/tds3A9HatKjKlbuuwe+mSj50/7ck0Nyleik6KKfjCA9WrX+S+jG5JB80S1yEiYhqAVzJT6cjOC1VO+FFuCT/tjagbj3VQbZtc+GWRneecBVBnNvigg/99E8eODJ1sBM8jGp62LmA8hMQTeFgqLXgXmjDEiSvQakoprzsqQSGHnMtUHQbI4+ea1dntvREn+QThJQkqTnW3taVIr6JXfeCgy4EXeecyUcYUvNvfH4H8yi4SN42xxn3+2/Y157DwhXK8YlyIQNg5XXNOZ0CRriYYhz+rcsqqHX+2YZIc3VKwfCmgIjGVckJX+4xhAOdl3EcQ4ZRSPQhP6kjVfGzg+rqJHm+MqN2SDqwbSbrLn1MxIz6D8Mx4HNr/+CPaKRbY8sz+yPrgsvfClz/Erf2REMOWBBMiXDf0iH1bEadSwujZg0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f73326-4807-47c1-9a21-08dea51721ea
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:10.7412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBeW4rT4Zjs2JRDaUfq6GCz9uXMPjMcpyJLyZkEABBbARijEod98Zxrv4mtAm7evb5JQNCYslU7GQrp93zAKxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXwXDDMHO7asMR
 9o2LTgFEP+bH7gE9eg0z3WVg9hvBPxpChJqMsUNmTCAUaItekpoeIftTxVgwExmonnAMeQgBHRN
 RXVwg8XV338GCIMH6qU/fzlP8W8EpH3iB3j7G97N+LRo7PhGekaT/Odx5PGPjWykAq72is1ttYD
 bTyoQrQWwrz7VJb7yhzxMSXGiU3MAxZIbtNwI5JS16N6a0c5U1PYrRWZzELj2CBQd9FJ1b+ywMt
 /AzavvB62OBrJS6aW7qi5tK1qJDEhTbj5894RNAc4WRBg/gFmXelPpF46zA/fywig5nR6fq8AiS
 KvDGFF9tTnXc9ij61SEfDqJ7p2mxkiHWnu2aEWKoHc9AbgjR1hhSMoe9Gm+fNWVIkUrYEgCYJRn
 kPuSJIb+Rlzc0LaQXYzgR5huaHu+IrX1iBFAdGpHfRu05s+bG/ZWg+3r5VyI6P+PZHasPKGrAJ7
 EhTySG0/tntSvtnu61Q==
X-Authority-Analysis: v=2.4 cv=QO5YgALL c=1 sm=1 tr=0 ts=69f0964e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=uY95S6If6i8ttexQI8kA:9
X-Proofpoint-GUID: RvPNRVAjqMjWrL6gvZyxBx8VtBcgl401
X-Proofpoint-ORIG-GUID: RvPNRVAjqMjWrL6gvZyxBx8VtBcgl401

These are for mpath_head_template.add_cdev+del_cdev callbacks.

Currently the same functionality is in nvme_add_ns_cdev() and
nvme_cdev_del().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index cc5a3c6c272f7..0bdc7e0dbce50 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -608,6 +608,26 @@ const struct block_device_operations nvme_ns_head_ops = {
 	.pr_ops		= &nvme_pr_ops,
 };
 
+static int nvme_mpath_add_cdev(struct mpath_head *mpath_head)
+{
+	struct nvme_ns_head *head = mpath_head->drvdata;
+	int ret;
+
+	mpath_head->cdev_device.parent = &head->subsys->dev;
+	ret = dev_set_name(&mpath_head->cdev_device, "ng%dn%d",
+			   head->subsys->instance, head->instance);
+	if (ret)
+		return ret;
+	ret = nvme_cdev_add(&mpath_head->cdev, &mpath_head->cdev_device,
+			    &mpath_chr_fops, THIS_MODULE);
+	return ret;
+}
+
+static void nvme_mpath_del_cdev(struct mpath_head *mpath_head)
+{
+	nvme_cdev_del(&mpath_head->cdev, &mpath_head->cdev_device);
+}
+
 static inline struct nvme_ns_head *cdev_to_ns_head(struct cdev *cdev)
 {
 	return container_of(cdev, struct nvme_ns_head, cdev);
@@ -1411,4 +1431,6 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 __maybe_unused
 static const struct mpath_head_template mpdt = {
 	.available_path = nvme_mpath_available_path,
+	.add_cdev = nvme_mpath_add_cdev,
+	.del_cdev = nvme_mpath_del_cdev,
 };
-- 
2.43.5

