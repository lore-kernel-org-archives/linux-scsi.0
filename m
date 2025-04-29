Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE21E1A18;
	Tue, 29 Apr 2025 01:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745891386; cv=fail; b=QG37CI1hq5rtFSfxsE/faU2Vz8lY/kEoPmUDCQyiZajImsLm5HCnSudGML5wLEsPnZs+ooOZ2yMff9DK6eIzXYBjaNirP7jK7PShLVH/VmQSXAN1g8ltexUtRDL2vsbd53PBJ+Y4eeZ4ksY/dSmLChuSlUiDl6JuAN/YJ4301Ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745891386; c=relaxed/simple;
	bh=KEOSmhm7xUtNarvPQABJMs0CB1Twk0Zh3su/0xxnqFY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=k1AJrCemNBlnLusW2zpMUghXr6wikR/QVhl0IJHxZ1kL1F35QgxYarjRmOKAmu72Zwyy6gX4BBlyOkU/N0ZLMPrWjC/WhjPUsD7FAFStUsZ6+mrX8MAF0ySNnUVCJErFgHPvkaQi6+9ue+e58SLdIr47KBkigc0bw48LovfHGEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DvUZFII6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Yiw+q0M4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DvUZFII6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Yiw+q0M4"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1httv020461;
	Tue, 29 Apr 2025 01:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=vKTxlnoE103s7LYqtg
	miwU00w8ZUvScRnLUtJ7Ict+Q=; b=DvUZFII6N0mGqJwRGP6PqV9WIIO5i1Xk6r
	litX9iVcSaDD2CimmU0gZXAeXWwjutgvAoIGfMyxWUTE+NVtPssNGwnadrvO6mq6
	1pHtoonGu7Y2RUKCTAtSsbQmOD7OU79pRXSD31E2cduWM142NgsduI5ZkCPIKegV
	1OgWWlUj5Z+RvarRsujvsIVLGgy19IeGUHh5fyPdmT2EagF1PC40r9Pu9O4apPx2
	yE3TqXszOS2Qa3sjwitjHiiugpCQTnLjeX8GWCQ0pDgacuvXtVEtRsZnrBo5KNRQ
	6ixl+Gt5+gUVlenSwWd4dAjKajjUxb5f4D9AH2Z7bjOsHPPYGRHw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46an2r80ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:49:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T0LUeO023924;
	Tue, 29 Apr 2025 01:49:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxfeqbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:49:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQW+qe4KN06tMA8M6HcP1mCN711N9YXoUqAGAK8546zprJSjhd6SjgYSIactM2vnX9vKJY4sVrwrXhoz2v31ga+cBi2tBmSFbkZnmWZJJ+5pOXBiaT3XtBWt7m8clbqIFLkZtD5F6Ql1tRwyO5mixVCK0U0jjFOH/kkugkQNdExJe7ijBG/cfx2mainAZy2elHDIo3/5+xWvYMMD4eDSAiZAq6bI6JD5FvhLh34ksQkIiQBup57bp4HIqONUJjIhkeJo84pq02fSNC3s7yn584B6R9/y2fV91sl7xHeW/UdJRhXnpsI0OY30gMYu3QGtqVwzm3lA369uqTLgySL7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKTxlnoE103s7LYqtgmiwU00w8ZUvScRnLUtJ7Ict+Q=;
 b=V/X3wO3M3ygorEGQEALq0TILmEZlbnRqjl5CjbaZqjEpsNQ0Js5m2gmGKojrXga6N5UbEtgjYqGJ/LjNDZyDDIZiCx2f/Zu5laythcfsuO+3F7/xDWaTz7scLKzg/YZ5U2zexdH2DBTyA/Yv/Xa6h+8VUOUGD+FdoBZ63EM1FPRVDorya+bK9VUizvlPz4iKpcgwTm3u5QaMbpJ8qHAkoeV6NmAqO1w61g9xF+EmlcTxxgvg3dja6Ai7G8K5swACtfJ+zmDNoe3lfhlG11PhMtBtj/OyHK4yWGeFdjVlLaZe99W28iviqQim3KbMVaKZdLwDIZG37ar6x0JD2xWoBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKTxlnoE103s7LYqtgmiwU00w8ZUvScRnLUtJ7Ict+Q=;
 b=Yiw+q0M41g6YUIkJOlWokHwJeRX8qHtgfEqOAT8vVVZmUw80BzzD7fi3AgvIH51BNlEmnpqiMkNKZ2/RqizQh7QQDhvm760ZlQEwtjtzJvMi9LpNLmZoT+nTJchxVpJT6i3+9gOPenFwYKlA2rjofMH+DHg4WykwInBXsIrfhs8=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 CH2PR10MB4213.namprd10.prod.outlook.com (2603:10b6:610:7f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.36; Tue, 29 Apr 2025 01:49:36 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:49:36 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] target: Remove atomics from main IO path
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250424032741.16216-1-michael.christie@oracle.com> (Mike
	Christie's message of "Wed, 23 Apr 2025 22:26:31 -0500")
Organization: Oracle Corporation
Message-ID: <yq1zffz20uy.fsf@ca-mkp.ca.oracle.com>
References: <20250424032741.16216-1-michael.christie@oracle.com>
Date: Mon, 28 Apr 2025 21:49:34 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:36e::24) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|CH2PR10MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bc1bbf6-d5c2-42ef-84c5-08dd86c01871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U56iYv+AsLswGcAKbCMiV3VYj1ZAONbfj7MbDsDjeb951CCC9HpWMEjpQmF6?=
 =?us-ascii?Q?jOOqsJWVc+ZSpkaBpZYNDYIYkK0p6JjQ/taCtsyhtn3HdjSszLyZHaMd58yn?=
 =?us-ascii?Q?FUL26d1iWd83F/LOcvJzgih4vm4OYqz+6yivrcvxvbsu/Xob5sCapXQdt6tA?=
 =?us-ascii?Q?OQxxWdlUWQt5eT/fgKu46F73jbK+RZKqRi6VaTJWV0kMFsHhSOT6wlQwj6fl?=
 =?us-ascii?Q?vRim8YnNK5SnlRe/tEB7iAhLohrnW+vY9AXj17GHV46sz+Mgw6v3fVFwNND/?=
 =?us-ascii?Q?7/wPiRRCSf3kb2pnyXvxtr46a9+9XBK5Ek4OCTIQaK+SqGLMNTXs1LmyjMD5?=
 =?us-ascii?Q?SA5DC2GfIREe3lfVtFkEABXGEolsH3oNhjbbhdD4zeUUWBMPB/2/B6e2AZiE?=
 =?us-ascii?Q?l4/1TCDLn0RRRPthjJE/OIdJ4SipwYW06kcV5BK444AHfUSJgYOP2LMs8iHI?=
 =?us-ascii?Q?n3oS7ApyTFYQh0Sed1KeRfyM6T/rvXTDg13lnFJVxOClF4B9WHzFtjj5kIqi?=
 =?us-ascii?Q?SoAqc4L0dAYyb8cBxTDQ+X/4H5tw2brVv7Lr1CvSvOV6/kTEDQUyUSRBcT+2?=
 =?us-ascii?Q?bDpgGRonjM9dxExrS+49FNZxqZDtHTCviKqx3SqzsBil3cDHRoOp3niYZ2OL?=
 =?us-ascii?Q?iYl4UhllN4hGCxCU2nrBhPFUtwLiNZJyn/kleJTGBnMMCa6SLpe7gJMWG/Bq?=
 =?us-ascii?Q?VvLgsLG8VtvaP5Hcsr07l1yzbqBFrMY2hMIfh0AFg5lEJpFwsjQuq0xfL9YQ?=
 =?us-ascii?Q?IXbNxYUFvxLkjAc+DQvyaaSMdaAA2qzov6Jyo51H8SxziPubarzEiBngADdE?=
 =?us-ascii?Q?1ufN8FaJSPZdOI5sLSafO1qCAu9dmG1UDbYXbcSWsUcNBNFbKxCGeIOQ1iMx?=
 =?us-ascii?Q?WQXAGKAuScyHiJyB14SBmGu4CwBl7e39NcoeAXxU1rGhBMn52BIwmykgLyMz?=
 =?us-ascii?Q?J2FQqTVj9nituQ91V3wcoywvrUwwPUZbKN662MZpZYX2UnphR2ayichz/FPL?=
 =?us-ascii?Q?N1E9lO1z463o5dmf5JeVRYq7RjwpgFYQ8qPmtBcG1VeOflBwrRgfyxjwG8U1?=
 =?us-ascii?Q?05cBVoS3LD270xiO0q2uenFHtFOoTiImEEfl6ejPTOgjPyJsA3jhiCxLWoS3?=
 =?us-ascii?Q?jjFwlNc6YFYYli/dTArDH58YqMX6VKyI2g/ksNygzh6PVQLBkeHKw8aO56Yh?=
 =?us-ascii?Q?9Lg7VNv6iNJfVDFXJSQnkFJWmM+PoYH7JhVeS85RfEkQy88N3uWf59PaZq/f?=
 =?us-ascii?Q?LVuE6WGSPkp3fuLjQGExFOVemGXaXh31Nv2C4rfYK5fahStMok9gCnRLY0LD?=
 =?us-ascii?Q?xy/CWV7qq7/03CKGbFxRtOW3HABsTAPvqfGdups7yCDOR/TE+u8z1wjTOjBh?=
 =?us-ascii?Q?n2drf/ZSW68zxbpxVw/+n9Ppxq2pfmSAjOHPz4myEzB6Eg0M1intoZRnRV5M?=
 =?us-ascii?Q?Ry59+s9Pyqw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JXPh9g4ZMBGrqiKq8uQEyITH8HFflGOGlD9/qNfYj4NGV0D0e66Rs1VY2ERW?=
 =?us-ascii?Q?MV8WhDKGw71dlYtCb2nj6Gz6zLKS5CBE3v9S2OH0tZiaOpB6bxe22N9bFVFy?=
 =?us-ascii?Q?YoKdqH6VQp8DpBHyo6e769WtsstWDPuJjAx+7mSbbnxF4/XtbzOzGYbWBpAH?=
 =?us-ascii?Q?b8Ll67Q1cxz5m57nTOciBo4gQiE/XQXhTLhI9YKqC5c3WRSL157jvC2Ogr9B?=
 =?us-ascii?Q?67osB8yHMK8d5FqdR9EbmwkahCIZN0VF+NZ2v0ux6H+u6ns+HTdl0qWrUfog?=
 =?us-ascii?Q?JP7bo4Q1L/wBV9VNPrLHpN8VKAsoaEqWKFDE+qOCTS2PYNHKeBAC//Rymeii?=
 =?us-ascii?Q?nWpEPNlqHcy/Z1OwDIfvGB9+DQECMPkTrThpfUFLReQNCD642xaa3WaFqrMA?=
 =?us-ascii?Q?WNBox6IBLCkkWzxw7W6X1ja423PeUFBg6W3Vxsomfq9VXQeMonn4FA2AVpLt?=
 =?us-ascii?Q?J7G8IigmlD5HCmQaj7ZjrUKNVHTObh8dQWccWhwK8fF8ZKFLx7t7/3QbpRdV?=
 =?us-ascii?Q?/UuQg3PU9E9ofjc5SW0nVnut1V4vw2X7aHvPfkNfKXtOdCVrL9HKl8rzQNUo?=
 =?us-ascii?Q?aflLLI23X0RapINVJAW3HjunBqPSTEwOu5gsY1hIelBx+LxmNs7kS98VIB5h?=
 =?us-ascii?Q?PjOQukR6UPrm+wcLjwETIvWLN6ypOnNd0B1BK6lT2ura0ZXeQYEHvAEABC0c?=
 =?us-ascii?Q?zYA0H24MZmEvS8H2mrpAcJIa9jS/pnzG2nkIj4dqv9ET4/LtbpBVxYadATkr?=
 =?us-ascii?Q?fy4CFl8C62B4Ik0gIjjmCl730uBjzjVNs+/jMMZhSDw5eSsxOklJ/pF4fA3b?=
 =?us-ascii?Q?rQz7uzgODWufHSa5SNSwxy2mNNih+IJNK3m6XKKSFBv1ZxC/QA1ll+OdDBb+?=
 =?us-ascii?Q?tzbtHrCq3I0POrszDvGSKcYwEriniLgjDI/AvQC8cCElapCHWZ3ivjk0+ia/?=
 =?us-ascii?Q?oSFDq1wFpEgua9RtqA9Y3Ioplkzshv2jSOBFPKaS76fICvB8FvbG2oVSxQwi?=
 =?us-ascii?Q?pmzsIwEmDAJEO9PVBuvH39YLkax883gEIBLrSfH1E1GerIbW1zKwI0w8wwI4?=
 =?us-ascii?Q?4BM6Ib9/wUFxLdvrfkhoICZD60efktAmO58Yu0TXhP03654mT0royQknGGj+?=
 =?us-ascii?Q?Cu8U9n4nXJev3Hy0oAaYU+rHhMkSEroWokkWx0tQejD6VxzjCe0Fwu153LTq?=
 =?us-ascii?Q?Dy19NCQw3/6ww0RsXIFxSKJH5rW8Z/0HbErhGfDMtDTucJsfeiP+hmNPNIyX?=
 =?us-ascii?Q?K30m46H0V7kCD+8n0dxKJ0Y3wpKU99piVa9cWgwCJ9nzBCWIs3+IAb0z5GT6?=
 =?us-ascii?Q?mHKKC0VSBOwL8SyjJqNz8HkjmlzE24u7UFfu5SYfuq4ong3rpXCKlE3KYPSO?=
 =?us-ascii?Q?KovwhGIUmiY/eTcjiiFnTe7rjUdRLOQ5tnQQdh1bh92Aaf6WGlFIK4z7Kz4l?=
 =?us-ascii?Q?I2OGgIXrMZnq/dsmsGgQ6wTNMZVrzAaqy9jHH6BVii/dcEEEQtkwPZbozlm/?=
 =?us-ascii?Q?b3L73A7MbEsbA6S8gQh6YyXYZ5T5stuY9MJjt4UDuGVWFLE08aV0FwV2I60S?=
 =?us-ascii?Q?usclROamTJ23l4ml0tuqbLsfirjG/W7KgmxgfIBS5evKWtliKIowA3EzL5lB?=
 =?us-ascii?Q?vA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LsKRR56/LgDsVs+Qmu2J6IXJQuMnVUmB3U7cZsqkTJlf5SvAZ/d8k0b+13DLStHMrw48mew6H/yC01qrF1Xnsoxpq/zov1GXcjLg8ihrmHP0CP6lJDQaG8NaeCjRHzTWWStnb0yS6LdofA9TKVSwkmWbK1XlcN5BBKn8nnFw2UUQho5cqbGKBNfYy97XqMvyC3tcVx6hGdtXV+J/UNzDHX5sMn4h3LTkhia2tyPEhuBEqdOnVDEh91YrWzO78MFYyUkL43Fs8kLnUHnw0GFKtDyNxvQT0FH+6yQXWbWWJj/sgsbu0TUIft0d54M+dxXQF4jpeVvAx1xmqkUtfeNQYyFmozjmgsdKGg0pGqrMXRPAt8U9wjn4sW7xGMQXCvcT1wlm0vcQlb2UGLL9uxaw+Ut+AHmQR+Hw5uLDKGNwvXPRueqdpJ8D1BNciV/dpQ8UZTutTfUNjYYjX9x04MuIRTgVp0fzZIHCp8f2yWqp3ysnJkehos7nzNkCiupcT3jSGaJbTpgLH67zNhNj92uh8WRFKOQixeBm7XTfo9Drp1ACunNu1rzedSZDOssM9mBUH5vxqXZnonLVlmY5u2c4hlYTVAcBeCLgOVn91Eq9vNA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc1bbf6-d5c2-42ef-84c5-08dd86c01871
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:49:36.0064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ud67Ir9oFJAPD00wD5evi3Y7qVfpPH/vPVmic2154mxmpBoSKOO0fA+wCMqvEJ9+ynRYWCnTqD5EIG+t2iwlFG+lBC953A2Uwf5khoDJNsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290012
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxMiBTYWx0ZWRfX7jcyjvmep04/ UVyAOeHp26CHRc1VR28GQZssDfM48iewNBiZtDaWB/C98YoIWOBlOLpQmI/9OASc281X/ID2NSr FtG63SqgVfSXp8zWtBjnj0GyDxvN9dUL1D/z89/BALbvhsy78ad72OF8q5QXFI8DmhSy5DTVbPo
 kb77dAC1MytV+LpmETN+tTG02NF6a/2hzhmPPck1fDYQlNPddVwO9QGXTAaudp8v9+YhS5Occ+c /AfWarFKKOZt3VjxanHmNO6ZVB8yLclusOgQEeI/sRU0usKgfx2kwQjoJZCEih0t45MNViHoIts Zd7g2Zg3iYeEcxJHMdV+vM+KSwDpKFbp86KgCZ68xKbr4g9HtnnU7i1jvM7pVwgQfUncItyGEOc WkYMBNIz
X-Authority-Analysis: v=2.4 cv=MvtS63ae c=1 sm=1 tr=0 ts=68103037 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9 cc=ntf awl=host:13130
X-Proofpoint-GUID: 1lN1-Ktdh8rDRVW0TP4TuA-YEH3dsgeW
X-Proofpoint-ORIG-GUID: 1lN1-Ktdh8rDRVW0TP4TuA-YEH3dsgeW


Mike,

> The following patches made over Linus's tree remove the atomic use from
> the main IO path. There was a handful of atomic_longs used just used
> for stats and a couple atomics used for handling ordered commands. These
> patches move the stats to per cpu, and moves the ordered tracking to a
> per cpu counter.
>
> With the patches 8K IOPS increases by up to 33% when running fio
> with numjobs >= 4 and using the vhost-scsi target with virtio-scsi
> and virtio num_queues >= 4 (jobs and queues match, and virtqueue_size
> and cmd_per_lun are increased to match the total iodepth of all
> jobs).

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
