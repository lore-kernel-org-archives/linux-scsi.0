Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784F34A07;
	Fri, 13 Sep 2024 01:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726192262; cv=fail; b=NB481+0WPVjZzzk5yDAiXfMKfWlkS5AYmaJtahkAWBfktGbV90KEAN71EcYkiSqkBY6qFRysZGYN5ACg2vOoJnjXyBQuYl0MeNqQ1SJhlFSqucvsNLu6XquKMCeIt0RQJVMmFlNsswO804Jd7O7HuW4QJNWLyrn4VVDhCjCpjCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726192262; c=relaxed/simple;
	bh=BSnzdOWqMVjHnSpqVCsMw0ZB9IhzAA4NIB7WS9PAcs4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=n70G02rHt45kAASe2Z+lyqdm7XzA059LOFzWIzDyN6Kk+/rcLE9WT9+pW2pwSbsxxzjB/Uism2XtkZJku9RsWMUlEUMMgQIpL+63pJDMLpOanCt+MQGvaapd4NM9E+Xm8E8sbLSP0VqXfxBz82j2eRufQ2aPLSNZl0bsOdblm6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kXblRK1K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RUOThtbU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kXblRK1K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RUOThtbU"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D0Su2W005970;
	Fri, 13 Sep 2024 01:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=yUi2nQVhYaLCAy
	sja05xa0iTt8aIWg93yfVZJjGAiFc=; b=kXblRK1Kt2TZVJxNYDlKFc8UT30s5L
	qLLm7P9h0nZHXpSdkocSSXODmkZU1dhPK9yYDEM5rIGELvpNZwR4KpQQLEeAMrhY
	oEZEMBHcUT+p6k2iV3HIYyiZhaYbsuyogNfrsLphCkF4ajWxQDXl63KVg1w1QtgO
	KCqQsJmMEXGISNUNpqlr7y4UG+MZRSkKOGG9QxwBd3r+6uRsaAGEdB3jZYztOuoa
	226SzC/WolMpfxMZzwpg0N+YAo6TFDnajA4oRzpDtyGJZ48+tsuguttvBMkHlL33
	tYtkljGWpxy4Ye9wpes/CAtIk8PyfH0B2Eeaz70Rr94Me1FXsuyfiOOg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gjbuv2vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:50:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D1jCW2032401;
	Fri, 13 Sep 2024 01:50:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9jcd2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:50:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sEsHUZKjrXV60BaOLFc0cHqFZ6bc5U5c2Op4Si/hS19YsZlyevocH/1oDzsjJedbu7UfEFwtV0u/Cu+LmbXp7gwnsaE+8VwjXCMywlHEdC70gCw4jiitWArlRXKfK5GM95gjVTN9a4RVrSYfa5SiH+Nm0wKtoyOPMMwn65XZjXjHoPW3Nv+GITakM7UOkRYB0zXblm3YWAVUSAtwd5C4ffzXETCgdvezZLSomWfpAkiOaNBxedJ7WvgDD0KONRhmaEZaM1P4MSI58f8Rb9wYOYIG+ZIxAvbpOWLIbySdccXxKHSknt+v9UqGFtRhRYeJOlZxI2gl1f7Rw/fGDTZG9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUi2nQVhYaLCAysja05xa0iTt8aIWg93yfVZJjGAiFc=;
 b=kBYJAvwiQrWvvSgIXm+H4MtyCdbilaXF78Nr/FSyRLr+tDj5qCxkJZPcOGj/kNbWitfzDB3o6yHOXN+s7Z92ycgFaxnO3dOf08CBsi6v+ViEgGna2xyPSh0SYtHAF3EbVsG8lQka1+VXNwelDZhfi5W2FD05xbtRLWxwbSfVA+4w2ixsbgMvfBcfp5eBd/IpoJ7zi3kp9+mey07cpZhroQKa/0rCfgPiCUIyebZuApUsUrl6lqhR2LTPdavia8Y0BhMkjwVGryYKIx8xqrR8AUwkbQYZeiXneBcIVcUTRY1pFhur80gdvhCP0EMLcUt6m58c1CdjWHde3gvxIJOcXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUi2nQVhYaLCAysja05xa0iTt8aIWg93yfVZJjGAiFc=;
 b=RUOThtbUd8mahZNGR4F4/hyglUBAzktwLuMBUzg0rdz1tyyUVnsMvfxecb2CySwjy49WAEZ1xXfEl5dt+0UaAB1Ceeqo2qAnoziyvUDyE9Brpy01y1ZIHiSWXeA4ext1AiCm3TikYOS3Keyj7IzOClvMNaarXLqlGSOwZkUBE6k=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7361.namprd10.prod.outlook.com (2603:10b6:8:f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.14; Fri, 13 Sep
 2024 01:50:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 01:50:43 +0000
To: Keith Busch <kbusch@meta.com>
Cc: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>,
        Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCHv4 05/10] block: provide a request helper for user
 integrity segments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240911201240.3982856-6-kbusch@meta.com> (Keith Busch's message
	of "Wed, 11 Sep 2024 13:12:35 -0700")
Organization: Oracle Corporation
Message-ID: <yq18qvwuxsr.fsf@ca-mkp.ca.oracle.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
	<20240911201240.3982856-6-kbusch@meta.com>
Date: Thu, 12 Sep 2024 21:50:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0291.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: d13cf3a1-b1d4-4125-2451-08dcd3967ac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RJr6O8HUn4T+srmh+Vx3NZoeF1ly1TA1/3Ng9RwnMi00h7CNhVAL2yLgFtv4?=
 =?us-ascii?Q?y7N8zfVcLHXu2MNOXmGEPHErxGzHFtuoZYrtceUfEdoLcQPI4jy7byqDwKQ1?=
 =?us-ascii?Q?D9GVNfsR68rLJonKKbx0/eiJcb92LecMEctRFtcZp2kZofHQU6BQB4/GqfBW?=
 =?us-ascii?Q?FC4jvpFG6xRqXjNY5THhSu1v3IDG+zm2k2iRPUW0aBTE9sT8bLNCnkZegRJO?=
 =?us-ascii?Q?EnsPFKobNc99LK7qXl/CwUcIWkciEdTGca7+758p1zRoWXlnYEHnwNBR3VSD?=
 =?us-ascii?Q?Kj5NBThX6gF+t76M4Q5BdLZkP+gWEJhTCtxTeX/74h80oBgo1+cX3hET+JsC?=
 =?us-ascii?Q?zTJSwtmg7IN9yseXJD45TQ7+SU0OwqxY4H0yo2BDY5f9NCfgWp5Rcx9pkmN0?=
 =?us-ascii?Q?5XnJpB3LCD7Qgng0oeXHKw+Y1d6rv1FVuKbFMwbUeeNoWBnirBFIBTlYBUSe?=
 =?us-ascii?Q?4rmhBMZTk+7fg7YEXm8Uu7YhnSlJXBaFuuarp0vGefkI2UrisMfnrrXaHeSr?=
 =?us-ascii?Q?yLsmxLAq2YqqTQsUZQlI9H145GliRcOBexYKVRJNIO0yAHjIl5P2A/vOIGMj?=
 =?us-ascii?Q?IBozqKCAhjox2hraVwACB/l3eTWxTgaZ+EOyFasoG7edKXlJuL4qauDTeM/l?=
 =?us-ascii?Q?yyBEl98zNVu5GEEDNOwz87ibXLMo3h9AOj4jbMZkky6eM2XIcUTKKZHXBE8K?=
 =?us-ascii?Q?TYxR79YvDGDU6ro3pTRkDi1+fdkA/pvW1ECtXy14nM9cQZOFG43eBS0WlOFg?=
 =?us-ascii?Q?iFyUpWfvbAi6/G5lhN6+vAgGOchcLTClE4/87Q32BFjC8pXepAKve/v7HkNh?=
 =?us-ascii?Q?Fpyh1tQ0hskjTOs5W3O6Un5zwW9GgE1+6qENEX2P7HV1OqJXvewc9XLlVIk+?=
 =?us-ascii?Q?XdecGtsye+ie3JYdOG8xPAu4WYzP6vmINP1j+0o/4LrKQQRsB+ntAhNBVpXR?=
 =?us-ascii?Q?rs3jJSSqY1LPfqgO8+UL8p21qdpGVf9lAo1FcgpoeKdzwof0EBPuV2T0hU99?=
 =?us-ascii?Q?fNtDfURrYQipZDMDrgYlwPn9ozRHe/ljUxU7uISEZx4cYTA5Y+C8SJoRVwH/?=
 =?us-ascii?Q?H2JEPDHCAb3W6xcKA9zr/Vm8vhEgXdTetysm8hP1ksxfPk/4hURRzHRgRnJf?=
 =?us-ascii?Q?KiOxjVxC6NDfImm2ywrpXUjwazG1uYhZGLEGm3e3B6ftCGQEQ+5Itlgc6jtN?=
 =?us-ascii?Q?9vB2NVl10PMrgk2tK4adpn6AAuteamIKtIib7VmJnj9I1qK2M6za0CtJGvtl?=
 =?us-ascii?Q?HaiqSB9gif4NHxgBhREF0vIDqqsDwUQ+KT2cS/MEW5hGSqY5v89u+03aoiT0?=
 =?us-ascii?Q?yxpaCSwlHMwIicEOwSAphXL15fffyyO0sErui05OTPa71A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WOdxye+/liEszfBZ2l4Fxh53gqb4dEgQ4D4jBwgRCoXH63ueyMBN/fCotagL?=
 =?us-ascii?Q?xS+8oQ8BC0Y5KCOk5pDiW37q5lmX7ojyux7Ix+5shwZt8uMlHIl5owdkWbJJ?=
 =?us-ascii?Q?UO28+OjvSBGfttMcJWiAZrhqiK9+cML60qhRUi1LuVaznXL9nRH5s0lvSS0/?=
 =?us-ascii?Q?DiDQ0WXXb4dJHAOtvWJaYz4jL+j+XeGSWQEDi2lQcynkofSOZpzLWsgBkO6l?=
 =?us-ascii?Q?ADUrlbsTvuJ2z4X3nobUyPJMY6ZUxCmt3PMs2SiLDOekw4GhUSk9oCnXfUb0?=
 =?us-ascii?Q?S2u7KJY54pHy33fk8rgBEmiECjn8KtA9SiwimDWjSSpeyZNnKqc5VmS8LyLX?=
 =?us-ascii?Q?+qd0lIkbulg6BhqWHXiTEjm9FoGRqAD+Ux4ykd6pSO1gTCtzEV/glQ50txev?=
 =?us-ascii?Q?0koxp5cWY5WuYbhwpQyjjINjfk/wv0ixf9HAeccjVvAyewOyJ/UKCiX1wKmb?=
 =?us-ascii?Q?PbPvSfhQ/rmkRDNJYg32cdT0vR26Sz8l1E0BEUz8aAiuh73mL+9Sz8i2AOMv?=
 =?us-ascii?Q?RlS4JfE9hMmxLU0ss+iwnc+hqvg+hXT1Zh+7UAxpRK/XEiD/K6zRK+Gt18Ao?=
 =?us-ascii?Q?3osh38mqOiSFLgeZOLPN3bLlNuJ2kE1UZ3W8dQwEs8RQcFtuzX6MwrsOegsT?=
 =?us-ascii?Q?i5wOPNcApK+d/dzLO81zdpIgZeBs1ens9O9ajX3mfvny3pVxgtcQy6mwT4U7?=
 =?us-ascii?Q?X+rAG67PCF2abkZeYLrNPJXYVmKtMWxwmSK52xmJTFXT/N3klXFrhvcU6xHv?=
 =?us-ascii?Q?/q8x6XznGXl6+yE61KCze0NAKrudvEFs2uPg+JjDidFfAEkcXRtJLuHDdZtT?=
 =?us-ascii?Q?gEW4JOMHy1movHGtIEy0x2FmDHyJwr+ixXj5Te4b+2MMCPnUlYfvK4KIuQ5O?=
 =?us-ascii?Q?KdlsI2tVqZQi2EjsJsy3Lm0EODLhCnCW2eRN9SMcY1s/q+2lA9ZqPZaQIStl?=
 =?us-ascii?Q?YNh1WfzZNKyVZITd1Gxrn8VXBYiGfNbAQTJl7pq03+tVLOLGsCvGbfJTdX8H?=
 =?us-ascii?Q?qXFwk++cUJ24zXZWytScodm9laKPj3bftQtmqq6HX4HZwauDwAJV75TLz3W0?=
 =?us-ascii?Q?bAYyoIdVX3iqRKXaoSQnKFTkRFiYPqKTRKp6BQ/IRvshhwJWSFTF+iH50Te7?=
 =?us-ascii?Q?ZPDSvUrDkbxiw//OQ0VY59rlsnqXd9e+3uIJNjeW4alG7EineNEWdIVGZtRI?=
 =?us-ascii?Q?p+r4ozg+dyGsWHiL5uhZxf1RrlcqhPxKMP4NOax+Y3BY1FNlR7JVwvGzfezw?=
 =?us-ascii?Q?6W9qpuBoC7siC1BNb59ukv7hPg97z+RrydvK0FlhQdtf7qUhWTWwSZpXfuZj?=
 =?us-ascii?Q?kYPhweuPvhXQn49Yja0gYljzuEp3HoYgTn24nY1ZoOYJ0SsdtOd54yTUOGV9?=
 =?us-ascii?Q?Bbj+QCWIDEm9m+GcGAtLY59K7/BMN5wgg650DiC0F1dmfB38yGo4XLhkTzPp?=
 =?us-ascii?Q?Iv04hYCrMjeYMDvgWNbMmJmijXr0kosHX+ubU43D0RPxAxjbT5UWtPaFiejj?=
 =?us-ascii?Q?YGOXDZtT5IF+3VgX5Hlt+CHiEtY+kPUVOaYyb/XI7XSuURFa9hEKS+zOCKZi?=
 =?us-ascii?Q?CqIQUJV/HLY4of25Sa/l+oZwZRTeHw85NuU7pHxib7PrXV3yMQQqhJ2uoO+v?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OseShRYXUmsNUBkIBkr09a8/pnJ0LaCBn07YcI9BY9A0hFtPsy69wNQ4kDc6gAVa/7b+sBaupB8GrPs6sjm6Yi90mWOCpJNjbrnrA71NZbFZFmr4I1eFeq5MZrrso+4n1/E155Je/aRxJOKLkS8NPuq3SBcKYh16XZT4J0oD6IuXtqq/2pvIQqDRiFSMSbMnfzG8lsNq5woBGnOuc2rKLX1+2sxaaX/a0oeJdQfEd9tKZPl6jSRJoFzQvlXznddleukFoyB7GM//U2ffnLvfSlaQSBaXZh0iZzYHG2A62STaggHeTYQJ75CQYCp/CEQdFtPgpWi301dfNYdzmQC5HVxy8OlEGWTK0W8+bylwmhLqssP1usFvsAhISouyZZtXtfzO5ajoC9fdrh83oe8ijsov5QCqN2712yJNdaXdPseYRxyOotmNG5eue6uk+oWcdf4a6etzGdDFCZ2tn0ZnYLBt6IKIPGq3D2qA8EfhPXxLbuX6kG6s574k9p/ZKQTDK4chJzzXqG8HJDTblFL3rcmc8/Fi5CZGawb4l/xazGEwotPxC6gg4D/mvtHccWmUCnSfcLVbVg9+DPKF2vc81j8+U+VoOO6C25LuyyDA4T0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13cf3a1-b1d4-4125-2451-08dcd3967ac8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 01:50:43.9056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rDgjk7fpGpfTrPqX7YFxnM+4LYaBkq2Px4KKAeyivGIuZ9vDmJHQhrO45gtFLZXP9VBD90IDRG5fpHv/cCSOUP9ZmajbBJdiXDNPJl3m4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=933 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130012
X-Proofpoint-GUID: dr6Fxuru2yXtSQLghM4Efe1Jpvj7UzuL
X-Proofpoint-ORIG-GUID: dr6Fxuru2yXtSQLghM4Efe1Jpvj7UzuL


Keith,

> Provide a helper keep the request flags and nr_integrity_segments in
> sync with the bio's integrity payload. This is an integrity equivalent
> to the normal data helper function, 'blk_rq_map_user()'.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
