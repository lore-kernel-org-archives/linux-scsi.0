Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82312223DEF;
	Wed, 21 May 2025 02:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747792831; cv=fail; b=VEGi7rKwyLJuCTDrdKhNwabnQkcqc3l2vkoOcphrlT6VFGsUzakJACJlGOr1Sc8FMBlkhurqk4ABLfFb3mpEBpRVJhB5nzpZ8W+GZBzu8jgZp6ltEvgeLktE3Eb33AZwGkQOrg7RrMuz20tM/07lHYwGsoA6zEuybFgJuSy6ShY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747792831; c=relaxed/simple;
	bh=J5BftUC234s6Ah+gcF3KVge9AopWT7mTA1uNcyvjBpI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZKrC+QXllzVzANB4ot1Rovm6jANcenclLsNknE/x1++KTzzLnKY52fCYHVH0kQ+GHaOyZiS5LI/Ifrmrt7fH9oC3ftqvoyJpSU7bJ6rWsOhkjPwb7uDUwDhOQ6qznA87o/JfoFwygAsMnKvdataN67W3LZFGJl8oNXg7/6martc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MuUlHTz/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UIik7Ry2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MuUlHTz/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UIik7Ry2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L1w7lj031400;
	Wed, 21 May 2025 02:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZFzcWaj61U0q7cKCd6
	e/9U4NKqQL5Q3fdDbLakmESdM=; b=MuUlHTz/ZbfXVtBQczatQ6xg4VovwVw4ug
	SsREnAemWsMATvUQaghGJfkl1GvbrAs404xpe/8948T9Qd8AOUcq8k8L+mP4WwP7
	LSreH1mTlFt8tIn6RpYwRLFj+CFvAY4uwhGvsp9ma2Mvn6T0RQEPKQTe7Mpsy6Hi
	r93y+qayYKivf6nX4KpcUSHKIY56v6xYwH7otkFLteSzCUwgP/d7v8XGnuK07xX/
	jemOn3rwT/Djl1qh9eAmcOb9zSTfHKqEE9UNz9yBEw/3BkBAIcPwo8WP8aSbOtm7
	YXQoTqa8yfec1uxmLQxjoiflvsJq2Z0YP9EGNp6zSbs5LDM8WGCA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s5fg00sp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:00:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L0jIGZ016418;
	Wed, 21 May 2025 02:00:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwep8my3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnTP4blToZEDN+A85OxPCq0eQFAnTP0x6YOUhpnBvIW7A6ERm3172KwDbtYMjtFEbgq2foM8BaOijSLgknZaRxn7hOxC8SdjNVY38UF/HFtmwLLEWNN2+3ETHXLVf9OxyQMv+coe37V66AJoBSTBhy1cZ2UygAc/Z0m+KCfDswX6l6N/BZUxpgMeDWSYq0XPJgmBsc8s0pBckOVNcQT9+lx/VUcJXx4h1WtoimK+NHdL3rVwvkG2+qKxl4xl/ucEP9QXnj3ePct6oiAOl9sM8MumpG91c9i/PpvyK9f2W4Vm42x1TXvaPPu+PwhX5P5l60qZZGlJCZbbr2I0cLqCzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFzcWaj61U0q7cKCd6e/9U4NKqQL5Q3fdDbLakmESdM=;
 b=Y0H450u5LeA3fW/6K3uM+pqYLXtoPTFvd22PWMCZcA+BbZFIJqKITgXS4+oo1vX1fhobS3AbHuVj98B8k15mduHO9wFGCSIAKqm7T2MApM31UgdkIp8OUEbGLlnlzEWBiaLKXobf5Ge9oyOdGDbzqHWTzigkyrOju3mPaoGP68JdTLSFesFyBpu7V9AvYtZR78bdXeIyL48XC6pOYk+ICEc6edecNfG5H1JUmyxnKXDdV+LCjZZOZFoTM2vT7gx8/RA7pvdsr6PhZJ6IWvBfHgQtKdGr8bghe3EV24fs0QW1/TOWCL6bjcWyvkjAQvBKCazk39Mw7DxtAkssuM22Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFzcWaj61U0q7cKCd6e/9U4NKqQL5Q3fdDbLakmESdM=;
 b=UIik7Ry2ys4Szq7hqxGtzdXnDPBPFSxt0kjjhq1GRpHAnAGpsFcXmntwy4RJD/x2jbyPzVy2NLKa2jyWCKm4IOIGsaLhLXa0c9VhRuMXAUEMSQ+bPf7d019BWSZXTnl938EI1Nv5849tmDAL4OXJptoV+D6NRVfqZfirQyntjkc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8347.namprd10.prod.outlook.com (2603:10b6:208:57d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Wed, 21 May
 2025 02:00:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 02:00:19 +0000
To: Chen Ni <nichen@iscas.ac.cn>
Cc: dgilbert@interlog.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sg: Remove unnecessary NULL check before
 unregister_sysctl_table()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250514032845.2317700-1-nichen@iscas.ac.cn> (Chen Ni's message
	of "Wed, 14 May 2025 11:28:45 +0800")
Organization: Oracle Corporation
Message-ID: <yq1bjrmlo4s.fsf@ca-mkp.ca.oracle.com>
References: <20250514032845.2317700-1-nichen@iscas.ac.cn>
Date: Tue, 20 May 2025 22:00:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:208:23a::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 983ec5c9-e025-4c61-affa-08dd980b3cf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OExvJIv4imjLHuI6aVHjGZkvVQt/9CSJgsu6j99VzG4GN6zU6gDnFVLkswQD?=
 =?us-ascii?Q?YJxFK7NojvlZCw5kCyZxiIR04gfzT4WOzP6NoD2JLSG8t+M/3huxKVf70fme?=
 =?us-ascii?Q?5IiYMk9j6n8yMx1ZXUnqgAp266MpR3btSo1p61nwa4l3jHuUDttlIWUEYtc4?=
 =?us-ascii?Q?RkLOZIQuD1KPrUCaV3qHExzs9Kp6ZVWH/y7Psj8IElozoWych2hEBrDyAEWR?=
 =?us-ascii?Q?EifyZ4ra1NDeXhB5PfUJG6ZLLQudr6OKf8rhqp0x8RcanuJFhaPmhmDtL+NB?=
 =?us-ascii?Q?8ulqjS/UmiI0aNrUa2he37GtA321OzIOLq7wnO2+jzLF97YFdipNzxljY/YL?=
 =?us-ascii?Q?/Ckn3H/v443IsPilijwI8+aHfwDFt/OWucWhSHpJ4mBDJzHwbBOknaOAuSvm?=
 =?us-ascii?Q?kQWpNsKdFBmtH178buIAkFpkR3RAd5a/yxOUyzGJqbRqrA65N/mvM09oBGwy?=
 =?us-ascii?Q?JAwsuTKQF8tZnQ/J9yZGKRP9m7vRZ5AsWYvYz26Jugcl6CvGyz/zu3S3d+Sw?=
 =?us-ascii?Q?9wPwnqQRfRzWx8VmM11YuioDfIsP3+ib3oyi7xr0tneqa4m1Mykykz7hNqZc?=
 =?us-ascii?Q?bLli9GrPl3E1q5A/Q5ncBacASiXGRTKOsjZ5dX0lNv/x8exduGCeXoSpsN6y?=
 =?us-ascii?Q?WTzWVf2ZSqVcbNv+UAoUxmYVWXT13GWyDVtMAjW2gr5FNRtMkMYFTXmpsMQq?=
 =?us-ascii?Q?HBUXD82gS7Nw9C9RCZGEXtA8cjPMrr4UBxdLDwGJ0KgTpZcGIMN0iC4gyKUW?=
 =?us-ascii?Q?tl692BNwHaupQBbCTpa9jFOKzJTbWDCtw7cwFRgCz1yjrihPkY9C3yp2d+5k?=
 =?us-ascii?Q?/p8ZMP+X/D3qWS4UmDjTy2hmJpoE/ewJmqPPHSJJXg30dGXAu/7CldMc8F+Q?=
 =?us-ascii?Q?uTPmPd6OTsiLJUifJWzTa0td9zl4juSLaJYOiGxn9XltZBcr/3cOjGxMNoOI?=
 =?us-ascii?Q?IqghhyxFo7yi0BXiTYMMfZaI0Lio2Y0CIjXD5SVekn82TXZIbPbBSvCzbZJM?=
 =?us-ascii?Q?+NMuFNr8mKsmNZB/M2Z3nXhZZtw9faXW8SM3MA4PG31jX0ZN7kOlfP/6COlb?=
 =?us-ascii?Q?gZRLs7RDgU/yWMTYahmJ8NSYdt/bWimCOiiLYqW//V3p00LUcH5sLlpEdHlE?=
 =?us-ascii?Q?I3qEdKbztGaxnHyYpwjL2GFlAXRKLTQCzCI0wI2eYZjFbqqm8jOZ4kcPBEwM?=
 =?us-ascii?Q?itsUrHaQeaCU5YL1YCvAxQkHOU9rO7EAvpMffC9V+R2yUdnr1/TGNi1J8Esm?=
 =?us-ascii?Q?SJhWxoS50nnQERIJCBOpSHGPEEw25uQVvttAZBaWj4/ekaiLc7dteV27ANDP?=
 =?us-ascii?Q?91vvpP4ZhM9M4KSAKi03tYeUYDyfrMgAaEG3Kw9Yf9zaWLqrGw0SgRpGIPKR?=
 =?us-ascii?Q?6ar8F315PJ2wL6dOkNN+dAS0IzOU249sgS0T/T3eJW2YfZ6ayLEEBsRWIPtX?=
 =?us-ascii?Q?yYkGdYjRzFE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/65hzN8sM45xF3Qg4kcdncmEibbG8T7N7r2cOHLGlYBtuYSfI0djUttXgu9G?=
 =?us-ascii?Q?ZvGBETaOCwWiWIYh87S4VQEQTiqq7JWkEnSkNWwwxeoan+ZEtoSgHJmRDtSA?=
 =?us-ascii?Q?eEFvLjU4hHIP9AyTMw/00I1wiv4ZvPaj5NLg/dnDP0WsIKhoxNRqGvoUdD4g?=
 =?us-ascii?Q?1KOj6mvMa6QA7O6qjj6SiI0A6iHlfAK9Qn/7DACcXrJDFZoNJcSxr6eoPaL6?=
 =?us-ascii?Q?/0aGgPKxEKAUA0MobxSir73ZcmDeBM8rXh/uoBrbA6FHMDEWqANvwq31Cprx?=
 =?us-ascii?Q?+UtMNr83mpjLyJo16Kh/8eO5sN1XaawjEaji3PgMxzbNS/NDVEX8POhiap4v?=
 =?us-ascii?Q?dqTkPy6b5iqAR7jmPbCiiUpCqJZY9ENfe15yMXeoSnHQAtp7/fhErxET3ECs?=
 =?us-ascii?Q?DPN0qqq8PxNDVWt21pDAHir6rlEySt3qOaDm/r1s6af6w9woVub0a2n3mBLL?=
 =?us-ascii?Q?wV+fOusz8yu22cQwWBbK2GSOASdEcStc9XUmccEoM2bD+TLCTPqPVC21aWvF?=
 =?us-ascii?Q?eFREFT7UgsOooKKHAypzWqXb7LWnEI8r3fEyJyQu7btKA/9XxGKUxmOzULyV?=
 =?us-ascii?Q?shbP191/7YcmyLSOySjo56cB8QpgI9GrpF8YejMFni66FFBRLZn/viyvfB4+?=
 =?us-ascii?Q?+E5QdmWdk2fH1zuhscnd5J2kVvXdtDXb9gDdQi0qqPw1kaiA0QEud+WD+Kea?=
 =?us-ascii?Q?GAdSBlQC9F4BrEiSfkuwG2DXbRUPAQlDHyJ2OD2m5F8SnjuslYW+3yQWQk4c?=
 =?us-ascii?Q?M+zxxsOjS9JUdwaiCV9wFJTSUZGX0ryRjqTarpGls9FMiMcAj8YIG4t4F+i3?=
 =?us-ascii?Q?epIg6Fw/i8rNk0F9fkhKRm6l7dJmnX/t+/xwN5hwuUfCzRr3aJJHgTyFY7OQ?=
 =?us-ascii?Q?qI3zHzCBR7x+/OaIbs73w7pKsaUG21cHw7hQ4beioQ3rA3u7feCxIksJxhE5?=
 =?us-ascii?Q?N/HJ874IvfOPHB+4eLj3jVYlgs9nBiDvr+7RUlKyBtuFcyf1Aud0tlvz4HEr?=
 =?us-ascii?Q?mTeKUKbK5tZpnIoiahmhm+2Xw9g/twNr613wLUSRiwjYegnzvAhTunVYAKRs?=
 =?us-ascii?Q?rNU/iOwE7+GJKYHfuICe1oxwvQZN+zeZDWqoLvibT3w+VMq+73K9OKCqs1yn?=
 =?us-ascii?Q?fTaODojratM4rCamOj8eNOwaoUfblw8NYKvNUzbv9mDnuM8tzvZPM4vtsxWr?=
 =?us-ascii?Q?GJKU0931hyXKcxZK4w8ihdXfybFyuaRHC4OPcl8+R3Ig7kfHYiLomb6OXimC?=
 =?us-ascii?Q?Z4soiE/ZGtXQXqRq0VfbBWhpDDSd8hv2vTFMq1frkUH0aggjBMMIq6PvKRN9?=
 =?us-ascii?Q?W2lgTqG8LLfIa14Yq0ctksiYqOhKHGwJ073HlppJjHsDzb6o8D+5MwtXQihR?=
 =?us-ascii?Q?VSyRAyGuc7Wy+YpkX7XchejOP4A3EDY3jpMV9J7XWTpZF/+5Z1OBB31aEl4I?=
 =?us-ascii?Q?WFiHbvEyICNR1DgkTzjW77nKYEjgYogj897dQJSOa229Vew675fiAUw9fD2I?=
 =?us-ascii?Q?yCSQ4eEJLKKzN7sRyMBHgGpX4hf2Jg/i1erYs+ORbJhQs44PnqnQck6jGXhr?=
 =?us-ascii?Q?UcE6Iyl2SXSjLsaowx8XWwD1SNgq/v/glJSXFQr/zrvioOTl5MyqlPFSfVbR?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	czD0PWw1WJ/vnes1rTYX06/fInx7RCEswwX1rWkNBUzsIawcW96qF0v4fD0AxDtSRWOjNW14szhT8kzUlN5G1vHZH/kwx04+OMMj/2AUwzLePP4CK4VDkexBZ+oHF1bZk3su1X9POLrW5G5uR3hT5GMCiVFYFJ6zIapxqxfFFcbEkrkr/sojh2lJ0om23Fg9g5v9z8JVjlpSkgego3u1TrOIOZvpfBm/TCP6UNcgRSIuQbBEsLZVeS46zeNKgpjsPINIvq9DsPK4+wzi2aixfkwTkOF41+Ju8kec7d69ye5I8K9h0rK5i0exxXIokBWV/X4ucHAosPfali3BFVPt5iWQ0Y3g/V+XKxRrjJA0iXZnN29VrEpMSn7i3PYhVCRbBkCS+Zkwt86Ibte//dlhU8G+MKa3uxDAUQS29VET0DHbDLDb7nRGqRkgnBhcG3Id7n5mAYykJJDnc5A0qv1gnIr1wOrcR2cEaKYv6kPu8oocWLRkjUKg3tKuHogKjlOrQ6LMUn65S7kvHul2q7iTaJ/V6gSG1fRtio9mbcgPo+KwKBjn1M8wdcXZQdiX3gaWaR+Pn527vWpPC0flrps9wE6N8D2HuyjZNjeBj67g95A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 983ec5c9-e025-4c61-affa-08dd980b3cf0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 02:00:19.2337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pH/noVolM5y+w8ECBlB+JcR4XsqWJiND4P0Yd42ApWlZwU6IL+J8vJZFHEJKVr/mSedyHCsQTpXs7nfog5UleSW/0lPgNJ7rNorrKpme7zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=890
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505210018
X-Authority-Analysis: v=2.4 cv=Bp2dwZX5 c=1 sm=1 tr=0 ts=682d33b7 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=AXul5sHU0pt063-_55IA:9 cc=ntf awl=host:13188
X-Proofpoint-GUID: QWSTSxUI5hj03jmJ9lBYlVkgVChEgtH5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxOCBTYWx0ZWRfX5TLqeYmvcBw5 jV513AeQEhl0u5dfd8QdiUdqBdYVFvFtGkNV6ryR5yHi/3VkkP4Wvk3vOlRO7lACRP+vTX8wwYM YZpX4Jrd3c/9z0LnfUcz+JJPrW8UAlqO4mnSchNdAI5oAVdLluX7SXn1hzameYy7LRoB3bWoVpZ
 Lz9aDZkPgCsk5Xf1GB7DFjAFgRYDPg+8rcjJ6XIhlbHgA2FsfloVtXzLD+cca5bWPw2t+AxK5il a4e/uXb8barvenQSJw5eyI6vJZjLhOsSruZCaIgUpGCT9MUeNvx0wWwXdxqiT8631Qy8xAztck2 Ct7JHgZygby85kGA1xrNLLtR1bc/03GDSZOMO+sNQwAyyfJIqImSGLEnLgunRMmllEuawhHTQNV
 8UliA70Q3fD++ghA//iuajg4wWvRpcPmwhs/FeuYZUAgpppyEt5yFZilzyHzSVXOgi8duw7i
X-Proofpoint-ORIG-GUID: QWSTSxUI5hj03jmJ9lBYlVkgVChEgtH5


Chen,

> unregister_sysctl_table() checks for NULL pointers internally. Remove
> unneeded NULL check here.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
