Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5B1B3950;
	Tue, 13 May 2025 02:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102957; cv=fail; b=A2e1oZ/vyiu4zSRaadg9OOpR5DAyjzSxl19POy/o6fHZbNiVUYuqJ7SYSPBBVnEFQCqekWFFLTOzb8iChFItaN4t1hfq1zpBfIgCrseo9hiQEvH80sD3v5fhjK4fqbW5uRTQW/a0/w441G70hhU51zGvV0rNk2wnX2JvvNeKVYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102957; c=relaxed/simple;
	bh=y9q3hG3Vm3eBVexfhkxFU8RRyk5yON1unDkIxoXsJRc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fiiVpdfoqEG9WW9jyZflR5DEs86RNDTp5fboOqS6/3vBttgJqZnrcpLBwL3sriPv9stP5o3NXAtiNzgNBiwrd+61N8jRjldvz7meK1S55XeKgBLoBI+um0jj+XnEhf5j4I4o+iX3yjv+Xr+YVW1YAwCBdyUzDdnskVbL6KTdaOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lFL+u+p2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VFVIxv8Z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lFL+u+p2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VFVIxv8Z"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1BpDT027407;
	Tue, 13 May 2025 02:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hTADFGMAO9FPIbOvCB
	AvKNJrt9XE32O/M2JMtzh5UVs=; b=lFL+u+p2MTaSj5HV3qqzsfehfulnOSBX/C
	84a7QLASswpQsaqeDNs01bO9EiDy++9tu3K3TytOU6JyCQOS3P0CVKAxn0t7xyBU
	CyOLKyfXaGB3VyIhPxbca39mAqzNvgpbhpw9oAgnpERgQqGadTEIwR9Ff2ouYmYN
	7pQegriyZc9CT65UIEDrf9OdJbiUO4U+CRc26r7O+jcLeyQORKEOWwiYkPjws00I
	8SkB5jKGCyf+QXE38yPReJm/oHv2+XocRha1bYYH0ELGuUtLeobyr5B/Hy+IHUzS
	kNifXwmjVS+y/F99skCW5xr+h4xpcpGrnKKmuiuGwDwVTbCOdUbA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j1jnktjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:22:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D0woBl016135;
	Tue, 13 May 2025 02:22:17 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17010007.outbound.protection.outlook.com [40.93.6.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw883n8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:22:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7JaH804kQQVvHNbF0AuwFyaaeSDNnMtLKMAaFtG/okgdN3xZ0mn8lzFALe0RZTU6+vZeFY7/s7sbBe799mdBDodIwS/CLrKks5AbP62rJJyhf0hPTAHerUOS07rzRim7X0s+gI4h8YFgHKW7RV6HkrR++RHJ3wPDUakwrASQYwUIZEm6stkCiyWTzvWspf4GAB6QkSJno9bfCM/o0FbKnCGHSnqDd3ZLiTfYiF/KDO492hAVlFiS6bOothSI/MAr9Wp1uMnLbXky31c+zB31bah/56pfKdWwUjMGWmctpJ3XL5mHQ+eSnnBMbh+pdz+hfRoLYsDQcPdgW883/DEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTADFGMAO9FPIbOvCBAvKNJrt9XE32O/M2JMtzh5UVs=;
 b=ZfNGjWiu4cOq7iYnjHgJF7ry6F0DQXTl3ra+6/O9jn7BWsXV4k5owMZCpCTe1c0PFnX+K66zLuGG/i883mMTE1fP5260urUYegEaA5JQs37IleA9SHao6b/3x2NUEf0S5Pmxn294getAGp21h5voimJuJj5YRY7Tf/C1EJg/vPkjpSwEEuXl+wOPwAD6T+UuVdIDjzO4wjmeA+yNEuClI7t9vzau7PtuFvdJ6qfCx2oTQBQcnKW5XjtHQnvUdjpkhVrSv9Ed/xe4sPNzO57Vo6I5evKe7VcYr7KQvHAW6dDLQ5UcvEs2SRo1eMGdBUBGXEpV9kjvpUaLXzZwjHdOOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTADFGMAO9FPIbOvCBAvKNJrt9XE32O/M2JMtzh5UVs=;
 b=VFVIxv8Zi1RBmP9yyhqzrYYwEy4N+U7z1AM3/UXNldrXNetX1tk8/kHnFzaga5z7SD/EMCY6XojdL4Rr0pt9amzYXDzuDs06olw13quRGhpgK1lY16KzF3KZZnmBpXk+kmTxT5gA+Y9jontY9KUhpUP+O6HL0635qf6MJBTq4Pc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6099.namprd10.prod.outlook.com (2603:10b6:208:3ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.27; Tue, 13 May
 2025 02:22:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:22:14 +0000
To: Wonkon Kim <wkon.kim@samsung.com>
Cc: bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: core: Print error value as hex format on
 ufshcd_err_handler()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250512025210.5802-1-wkon.kim@samsung.com> (Wonkon Kim's
	message of "Mon, 12 May 2025 11:52:10 +0900")
Organization: Oracle Corporation
Message-ID: <yq1y0v1qmgi.fsf@ca-mkp.ca.oracle.com>
References: <CGME20250512025214epcas1p273986e3b3bb3451e4039094d21611e86@epcas1p2.samsung.com>
	<20250512025210.5802-1-wkon.kim@samsung.com>
Date: Mon, 12 May 2025 22:22:12 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:a03:180::47) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cc3c61e-d2f6-4644-8c30-08dd91c4f9bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7e2E/1TEwnYRoleut9mtG+BF8ErLg2cCH55J9msQCGIDrHv7+5PXY09ZBAgG?=
 =?us-ascii?Q?+ORG7Wy+T+ZjAKeRryJa7iNCEazx+/5DgX65Lum1iw3pXNzT/NlkGb/CXQ9P?=
 =?us-ascii?Q?gCg5R9JVzUaxGA7LvHnGAZ9oGG7kNCwBbskn46AuLTj9F4U9GRAvwlDxusSK?=
 =?us-ascii?Q?YS4oD6be032ZkUygpaDtu6kesX4hXw0KM2oy+9n/vHwBmtdbUK2DNvlA8B97?=
 =?us-ascii?Q?gSmsPwRqbPtg77KaXkJ3ckupZa1uXRMydycv4w6sZUhTLYm6rsZPS1MWMBHI?=
 =?us-ascii?Q?C2xcQ8NTW8clCijLrIzZwaDZlXsp5pDtgJzfGOGXQQVFarDFVzi2YgWSzYeB?=
 =?us-ascii?Q?i98PQ4GSwnE1tp3JoC3C8hnDO1z9GW0XKLdgXXqa8x3lM/extxkbxUfodQ25?=
 =?us-ascii?Q?9g6r68DkxuPa4WLxVjD/gtP1coT7xAyE0FiFoP1duRu0BPR2Z4UDtAb0QdTR?=
 =?us-ascii?Q?lfoY94qE8ffxs700kdJZXONrcAYWSY8xCvFiqaasxisLgvTwMslFqa9HCHSa?=
 =?us-ascii?Q?de5QZMwf59J1jp7MCRdi+wu5YN3KQo8/ZYfO0/waIIIRFMXVgzvYJFaa0OvS?=
 =?us-ascii?Q?0O+YqxREwO+saZeZ5I1uHTIKaSMH0Dp9+mdKR4oHAl6CaX5txEEJWdRC3AUk?=
 =?us-ascii?Q?xmJyvCn2KXj5iXhlSxdPInIRT6jbZAQN4GU9lB3jCB9QAANMeCYGUUdi3JRD?=
 =?us-ascii?Q?8T3lhTupMIeO2q+GOtulWdbX/BfCT0M5O7mrKO7+WxOnYX0c0CcoKA1AL+Mx?=
 =?us-ascii?Q?utsobjSeBiGb3mjse5WdqfaBFxUkDcLA42wh/sTKM0B/ntcJJ7HYUo5sPWD9?=
 =?us-ascii?Q?aEoajcrfimC8bA0L2B3sHGPuS5/x9c8zcrxIUGU803u6vPX0W2XP2qHA6Sd1?=
 =?us-ascii?Q?znobnbR13Q2um5HVigiY7b4tpbBAuVi7oayFwp3tT4BpMH5uEndOvMYuYjUM?=
 =?us-ascii?Q?A9N4F2ZZqhqmmMilz65aNwZzExfK8T9+ssf1SFTYvhKNkLKRgL+JjcRSawqW?=
 =?us-ascii?Q?3wgWH+CuSr3lx7twY93wCNPlQANJQALsE/88cGF3zJL58YnaUx2FHztuLUGa?=
 =?us-ascii?Q?5BLmbE/RXg64m6Tmt9Ekg/SQ5x2Msdtv9DwSOdcoP2KWnsH29G65UaAU6PwR?=
 =?us-ascii?Q?JS5nC0/9AVzeM0KZ8HWtYliHdHGpk3e+niWxXgqOm/b2JurmBMb08O1WpkaL?=
 =?us-ascii?Q?IIQCzIP7uEJuz/IYyf6/DY72laQhjZ2Kna+Zjv3tC72XpvAsDaLWodBZCTdn?=
 =?us-ascii?Q?tSaTYLOe4baown5uP4EGpjpWXOmu9/HhKoUXDH6If7Tt63BH20DdfZsLNlxL?=
 =?us-ascii?Q?yZ7zzTFc9IlGZif5CYtkrlpbe8MAYLI3ywVUxN0pIHbTihlnhY1wAD/a74Ix?=
 =?us-ascii?Q?XY2eMmns9UMXD3+ubWaLg7s2GFRZ8qaDHa8LfOhKWNpzv2aszGW0O0jqsLcj?=
 =?us-ascii?Q?sLo+KPcenDs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oFQSxr3tQXgLL0guXJVjmxYOwCLqtMIPIUIRu/xDzzcY2xrhSGbLEN3cBxfZ?=
 =?us-ascii?Q?jzxcEbD1wrD0NdIf5SwCKrcvfNzTe1TDdzEtLsyZjnJDbGJhjUblMsoQGD7O?=
 =?us-ascii?Q?NaOrWydybi8KeMIVyDWQFIbj2koww0pbMTE3P9U+huT9lZBl9+bHD0ikDzjR?=
 =?us-ascii?Q?X85xXApBt4YR9jOq32HHypXyX96FCt0g/YOv395KFs7bWEYZlNHNR3iGdGWw?=
 =?us-ascii?Q?OeeVpTrlwhUAkEQegkvwI/Ax24czzInObWsCOdV3Yv2Myn5HeSpHBai2yLGr?=
 =?us-ascii?Q?1DdcTQmijNgvZOT45dbgzhQOk6tvDWk1j7Vny2ozrZeyco9q9k99VN1LlMjs?=
 =?us-ascii?Q?hBkgZRdBLSFC+UYX3oxm4PFW8QwbyKqYJ8AyvL1M0qBxCZTyjZWjGbf7CGVd?=
 =?us-ascii?Q?W5oipU9c5nQjqPMXduGFysUcHdAi3AvoEln6M+2PiJCJ+RoW9slFG+RlBHj/?=
 =?us-ascii?Q?KP0T/KrWYAR/QdrB6+KxNssRTBV51roxTz2/wZrxWDndtubpWdL8lk/cIv60?=
 =?us-ascii?Q?JyLm0LIrLjmgq0Yiwdf+pie8ku18oCFew9qwhZN+veTl+S9qQLjDaAaB/Eu6?=
 =?us-ascii?Q?CJCKTfOBI4ANIj1jcWlgtvnMNL4YPiVKzKMED56vtKFqh85ZXNMKLdC2FG+U?=
 =?us-ascii?Q?IVHTeD0sc0dDKfjrF8Ef75r5P/8ztovXNTIzkYDGVNn7QrUzOD8cijLFrIWj?=
 =?us-ascii?Q?HQKJu8B1UiTjT0//1Y+rbx9i9W/PwKS2X7J1RmsTNHkMkqOqR6vzUqYWOiZs?=
 =?us-ascii?Q?TlJB9eo7toV4zj4TfuHTqbQ0wWkNa0sRAADYWNA/8B0juVyh/Pz/tBxL/4Pg?=
 =?us-ascii?Q?U0GsPewRxXbon9FuzjZwsgrPWNx47J+1ulGMJ2stB3jWn6C4hkqazd9GWWCg?=
 =?us-ascii?Q?p3PMGG9KksHSbt/kBHxjnsY1HdMw6ve+APXfpQi76KAYADIunnxbA5DOlRzg?=
 =?us-ascii?Q?ULcaQLG9tqhu7dbFfxNyA26wsep1hdCisVi0ZNFBlA7tApysl9/NMYzpvTdL?=
 =?us-ascii?Q?OxCMPFi9af5P5da21aD/Lxn90+BTX0VR/dTTwLUC2HHAXvYML9hTvPssVKw/?=
 =?us-ascii?Q?QUzpc4PxJH7dgGUlsok5lGNxKdXv61pY05xfZIroDEyULAgRDWeYdlJzrpvS?=
 =?us-ascii?Q?jKOAHiLFFVhsM+xpjasX41VwdW1MpnameVAu4pEAZVh2U+eQBFzagTNdJBvL?=
 =?us-ascii?Q?wU/9n5kQPdzU3iax1EK/nznZ/IOab/F/OdyGEbzX/+HmYpmU0AspffVRvz7A?=
 =?us-ascii?Q?rlAuE3i0y2g8zXvU3lg/HV3AH6ZvF6Shyh6RX/nxliOOFf2KbexGgixfVkxg?=
 =?us-ascii?Q?GIRJeinG0dLDnq2RsmrJ4miBun6iEUjN8zNGnCcLJNq/oB7hHOlqJ8caZ39s?=
 =?us-ascii?Q?DkCgGGruqByLlJIIi+c9W7WxubEW4pOvJaB556Bkx4Rilu/cFaBmY91NHrQG?=
 =?us-ascii?Q?GR0eW6Mh6yy1IvVCr6A/hfRvlm5+/GmCcVu7l43IWQ79DtzyxCOfe5o82jRJ?=
 =?us-ascii?Q?SEX0/jNc0OZ/NtsDdaCKTe684FQfQP7JJF9jHFEapFKEfT5j3fAP8c99XLab?=
 =?us-ascii?Q?VtE1PpQLLi1IKpTVQU//4LWqZNM0c5S5/TrbaDsEbcuNqynmTpj+CwlrBKrT?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lebynumaKG9HobC+eoAcFjwkEkAlDTuRVro2V6Bkn9wAu+tFUbZ4d6G+ghSh+Wjk8Zp5ku42/zN759zyMb5WtWRQxTciu2fwvQYbuddm1RxwXnWpJTY1MM7ZeA/rT0aTU4ru/mLnYpFjVakKpxKyKJrIy6Q8oIO6PUHXj8nL4Uw0Kcnz0bXc9rWZrIf2MB9xvnB2G42nSAeRdxf3YgJzrTkZUxvWG5YidlM7OtqkXiHGwCIqFs3uNUZmNCSUT2NtcVJYeKokZkkwoosFUBMex9gYfZfxVvlI18U4vb+wO7bnmXyPCw8RxnxTFQUWOlbITJlQQztmzDxEEqA4p+XkYFRKg35zCcqigZLIZ33KqFRREepLUbZhK9i6ZiQ7yIBpO7iaRAGpFvH8DD74VQmZi52IT/bh9biJUtSL+ihukHpwi70DDmiaVC9VC/qjkGvw/KGXgwO2dFeaDh7dpd7BSscnLKIRhuPtCDm5DdlpHezkY5ZGIGcA8cl+ugUEgq+0nDcqs+odJBjMWGgYEcH00hxvVcU2uirGxm7ZIsoDmpxiAxx0xF104Yq+pkpPoSLY4QebqkE4OVAlPdAOvvixQfM8n0mBg73QQlo45hSkXyg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc3c61e-d2f6-4644-8c30-08dd91c4f9bd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 02:22:14.7345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJMqnzSqXN26mqkAs5ZB2Fv0geSAECY1qDUtbr53cVq/ptlNPuC4GyBw726fumHHCVMvrZPm1lOovUtLagdV/ThkS2NqtfMDq9r8XCffBYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6099
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=979 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130020
X-Proofpoint-GUID: S1sDELH_J3WMARMA-fif_xClGCu7Xd1Y
X-Authority-Analysis: v=2.4 cv=PeH/hjhd c=1 sm=1 tr=0 ts=6822acda cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyMCBTYWx0ZWRfX3nLtbkieSVR/ C2rOOyHD4QF+2iR5oORWDpTItrXSPVjp7V1SDZsFtkzJojh1lWoyZ9vWoupraFkOKedA0puM2aU PiNopImiJAkagu8rwktxS4nDvFV9MEytdYf4jCR5UAMP99LhP44byg+hC8MoSDSaf2FIgKDsYkO
 5GXWb7vYgUq+krIhCsXxDtuqhLHhpZ8rjDaZOc+kftWFMrH5wKQ5zSkVqTn/gFXEW/5C2If+bq7 Tw9Ldd8vwkqvntrnYkYKlVicJ/8D98voufMJNiHmoZ1QlfTXtoYN6CNM7b3r44BtMoMFxu3B+SO KZGkIpDFHADciVQJpvNjUp2nWJCYuYrz+J7rBcToQOt5Ylq8t/d7PtLzhGCWSra5cuHs+T5hi6I
 VDcskobfa5/ZSdopo5Hxn8fXQS8aPnkTBNoOxMBqwsPreEv79jNnsp5p+Eh078ccQyGFeaDG
X-Proofpoint-ORIG-GUID: S1sDELH_J3WMARMA-fif_xClGCu7Xd1Y


Wonkon,

> It is better to print saved_err and saved_uic_err in hex format.
> Integer format is hard to decode.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
