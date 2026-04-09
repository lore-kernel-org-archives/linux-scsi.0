Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D5A34D916;
	Thu,  9 Apr 2026 02:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775701714; cv=fail; b=s0EsX6LivdFgYaKk2pz+xqdqyvlgoZhyycCeqGqGbta3IB8ZQxOZVTreUH+1gPe6d31RRbMQWgip7XGwiy6mofL2A26ixpXnCEo/A2USej5MyFeotM+wFHYIXFNLJt4xz4gUPbZkMbNfWNnP91fDr71Jq4OSFC3GXJTyPrOHjps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775701714; c=relaxed/simple;
	bh=lIQ0z2Lh8oKDeNu/OMfUv6tG7W1gLzd/0fKn27SSmRQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gQt2gbujV9tPjnCVQVU+GDCx6OhAkeuwGzy9oh5E9w3kZPg1pH5YPsz4yEyB7OM9heMYFHan/RpxzcgH8xte+hWB+wqmALbRs7EIfIjWHLF2PEBk6JEUPnY1zQv9uavlaeIbcIsxw8WPB/nwX4bpoNEqZQUwj4/d52GEwMZ/BMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r0w1qeqh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uO1UqcjP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r0w1qeqh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uO1UqcjP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638Nu542795409;
	Thu, 9 Apr 2026 02:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7nWLIWniN3UUUFfPvf
	0z+auDW5RQS1Ce/IUu4tjO5FM=; b=r0w1qeqhfzQKTwmTpjGqIU/H4F78HfWkNo
	iN25LgbQ3O6mkiR5ed59+FaCJ/oWwj/wa5p440MMhuEweoFUUTWERDefe22qCMSE
	FOqmd9xYW1+1AnbjH+RqN0lVByO2M13kCBPZ3oEKAtjciigWsTWPnsVczcp3IUjz
	jESeamyirYyP7C7+LtMq32VZA66wwKq+sVJC7eb38OTXpG743fIrlLkDlYYbs95o
	RLRO4kOfn5wHq7mlr4iZgxhYlRyInjLUIn1o0jATFBxappUSzsFJl4DF2g46aT5j
	mMtqoa5+1C3tpuB5Lrjlz72ePKYR89hX/Mo3R/cXf6c2/A3jjk7Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqavuj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:28:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639035eo040017;
	Thu, 9 Apr 2026 02:28:07 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012047.outbound.protection.outlook.com [40.107.200.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmna9b6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:28:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=taJ86UhxyjnCex8D8+ugsOQSTtvudQc8wfFLzPlwBEUNtydr0Ka/fiOcjWcfGEr5yEuOGjP21mgFLOMSxB54pO42l2l5YeK87ddaPghbtPYc2z80DYpCqEfu7JD/4LYcpZ3a7TQ7wNQPrQRDX1zvpj5QfFHWKm3Y+ENAZemgr2c26KP7YzigCPLYuJ9lW9qQjdD5NKyawqnNWYe1kNoVhOGvVCuk9SoZrWghQbLakcaLi+2Y8SdrD2MOBL+p7JmLUaZELE5It2jfi+D2WtdE90sFlBTmbEWbGOM8ThUPTl89uXt9BA4KT3kKIflOhd7Vgh1KtFyRtyMM6aErNPWokQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nWLIWniN3UUUFfPvf0z+auDW5RQS1Ce/IUu4tjO5FM=;
 b=LN6E2YmSfcRBPCeWBNcT/eMIyrmR9q0IkOGZKpmOYsMoxzTGgkhHyFxdyZj9jjvvMKXp2cZJlG8P3I3JBEb7iz5/oCD1SSw49CYMORHuV2n3BoDNIDjwgXElt+6UysQaY2z5tHaMk9nb06XULHb2PysPg1+PyNmz2lXknFKBWFkPuyf0OK5Bvbr2QQruOESv5PIaCACh3L0gc0OTX38xqd8C/lifAE/7tyLaEAhL5TDejfVHrNpw9wongxBzZ72H2FNjE58+1HNpghu5FlIWzLR48k8l/0RlW0/KCXLg7gez3N9P99LTkisf+TDwfe3A0u5QM8MokAmaChXGBDmlwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nWLIWniN3UUUFfPvf0z+auDW5RQS1Ce/IUu4tjO5FM=;
 b=uO1UqcjP0qWxtYZcI38PNrxBAz5zQjcJF9nZb3IiYwllPMx8x0eFtMPy6SF4dhS5SrSMiHCQVVV8alQv6bhn/wBx6CGYguTSfNKyVaFH8I0byNtAKbOSxBOs8TA/voaXwhCerekS9cPPtGSvhx4Q+uhibfmyO1nINP5UnGGHGwA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LVUPR10MB997834.namprd10.prod.outlook.com (2603:10b6:408:3a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 9 Apr
 2026 02:28:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 02:28:02 +0000
To: Aaron Kling via B4 Relay <devnull+webgeek1234.gmail.com@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        webgeek1234@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Disable timestamp for Kioxia
 THGJFJT0E25BAIP
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260403-thgjfjt0e25baip-no-timestamp-v1-1-1ddb34225133@gmail.com>
	(Aaron Kling via's message of "Fri, 03 Apr 2026 13:41:34 -0500")
Organization: Oracle Corporation
Message-ID: <yq1bjfsyijo.fsf@ca-mkp.ca.oracle.com>
References: <20260403-thgjfjt0e25baip-no-timestamp-v1-1-1ddb34225133@gmail.com>
Date: Wed, 08 Apr 2026 22:28:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0161.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LVUPR10MB997834:EE_
X-MS-Office365-Filtering-Correlation-Id: 3104b726-9f29-4c4b-6263-08de95df9fcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	GYqh2D2btDVwU0fkB331XFH9cb6d6qHoGepvI3dw9gWcMFFLc+wwaE60pvorleVPx1/9C7j5C/rxF+RdOyCV+lEojsWtbpNtzutp4oo9Y0aT1QRiYiJG7Oar5rwKWKyTGhZ/WDn0Nz/rp7rFPoTzPpLfOMNotPZGMsnUYGTkVY17Ag8dg0n03bqMv3f74DNDIJh0mOtcROCadmZU3+H+PHFS+KX+GYT8GA8Iz9TYqpPloU1X6uKW7C9gez/0NkHj7b4ROTals6BR/zDBNfLld/31OLHlJXec5BfsGw7FhWWxdDNl9Ny2gxJhEnoOVXBi2zMAeLiyqIQXmVKxk+aKpGONK2RgK2kmGV1UU4VUhuU6WEPUsDQIckCFGpTsZ5KzcDiLuKB9qMdfH00p6NJNJYTrrLuQTaqhY3YEwqqbpyEprfpt46Zkw5HFrq25mIs3miJ0xHthLYbZ0IlPg5vk8h8rg/A6Y6LoBN2C9h6VIqm1hyUemKC+4I9UscMy7AyxzgGIKn/9/WHt45IT3dIGyVsGmMeAhrDi0+EomyurBhlSSqwQHTmgJU9oRqL2SwMAvyfzc5mzrC9U9lpebRPCYT9K/TnvPncJhnj3Ap9AELJt5POSfbVhLOiRFfiWLogF5deQEz3oyD7xE0Gh+kKsHDzbmwUqDJrGz1AEupxhKWzwY1Qn5pp4aiLtndfSdWlkD7tW/jSJfDr6Sdtyq3ktUffkNdzBwe9y52/LALWRe9E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ltvLKP5UVxU04Yfo5ssKCVyDipiZNEVpnwc3LWnXJ0maDi6JkXCbyIXLk7kI?=
 =?us-ascii?Q?EvcDD5lC/RPZKO22MvS8qgglM/CnMtw7EBLhbe9Euk3cv9A0ek2CyMfGke84?=
 =?us-ascii?Q?wW/Me4DZD4n3vownNvtFkWN0qhS2ontZIaEnZJsClju1l1RlWCkc/b7tyJGo?=
 =?us-ascii?Q?U/L1pkr5Z5kiuqYHRCrf4ZfLzRPoWFe4F8kngAvhOzlHYQ6j95PoNp7v4s6n?=
 =?us-ascii?Q?z2eNQqHTygPAbyeIGN2kPWmOr3yeFeDn79IYk5Y3CuPh3spMAcFwrf7L4ove?=
 =?us-ascii?Q?a4Qy6d+f9G/6aK8hyO3K3Xj/Ih3Kj5+4be3ihj5G8QMLh5GiXarXvBXQ/Jeg?=
 =?us-ascii?Q?fi3ny1vGMiC5BV6v/J4cH9N9DvmaBB0cgL6MQTFOR4uSiHt+5f5D0pm3ozAl?=
 =?us-ascii?Q?kcGRtUFS9RuXSTplKbI94mEa1wlCXZorkI6osQc8DPdHWUmfEhkifvZmlkzP?=
 =?us-ascii?Q?VYyuVsVVWazaRUGcfWsRaXKTLSiydNuEGFCdNeSGvCODa0U1qQHtcUtQ9sei?=
 =?us-ascii?Q?emJO6+/7tkSk0D+GcQ4LShDUnk7sTvzRpZI9pPrYaSMAmC+Y3EPWM45si+dQ?=
 =?us-ascii?Q?rUUnrKDjOkcpMHhfkfqHOXgVa7pmVK8eRbRMF35VHEVdo610vcevJDji9bgd?=
 =?us-ascii?Q?Iayn3sMjEDwWEpelOjxepE4LloYZlePc8uaYRLFVTuX++nwETZbybgOcVkOA?=
 =?us-ascii?Q?qDUbLQ6RugoV62urE9iBHfJTXvQt0VHNorjMix9ZzQAL9L/xD5T1PPwrz9dB?=
 =?us-ascii?Q?RFAimP4t/Shwe0vo2Ps3IjodQc2ugTW/aPD8xOBNRjZSdHn126a00WcQDhzD?=
 =?us-ascii?Q?KzTVwctk4cKEhckoWrVo8KGyaqSm+wALuCk/yxgHQIbikOiCZmYDqe9FlpAa?=
 =?us-ascii?Q?/XRGuov1gtmcjM+7v4DHM/yGauijkKWp26j/MTuf58yDXjZrScZ686nWgatI?=
 =?us-ascii?Q?9v3SCoouRmczR0/CrpbPXmGphLz4J1ViciEv8kljpiCr0087LSTp9ryqmX14?=
 =?us-ascii?Q?7m91jTQQLHE4TeUwXh5Rpjg5UKP/XlwsWsdKRCU7IDVjxdoWNOXr+22s63M1?=
 =?us-ascii?Q?ubpZG+L8YewELziMm3zeywWtRPataPT9npjywYUEJUasXSG5CrFtkXyoPh9O?=
 =?us-ascii?Q?RuDAkh3IO5QLdd6O1bA0nvyLdKMm9k/D1mxU1DLxrRIRRP0m6BJgwnM0rgwT?=
 =?us-ascii?Q?ZbrTiTHck0d3Z/giocLNTEuondLXHx07u+Ks8zg1mwgazfd9Q864D/Pgn5xj?=
 =?us-ascii?Q?i1RZ4weW4Yue0Tml+zvugqqkr3GUIkESzk+IzXYD4XFotNyTJMiw6hVuPir3?=
 =?us-ascii?Q?AOwoQoXD6upBdyirCzeLpu099elRwrsF8/vZtEFI77jy3EGDWxoO/52PDjyp?=
 =?us-ascii?Q?TAzeEfEBnccA4g1t3/PKPY3e0m75Gjq8EXiQWCE7fr9aqj8TMamOJvyAzYWK?=
 =?us-ascii?Q?V7y2KMtPdoH+pgn2Y4OsyTa2kYHDzyYd5aO0vWxYZItnRFU5Cf99E3z0sBQI?=
 =?us-ascii?Q?gFgMcABVuTeYxTNyGLzJboNRGngwb9g1JklFfrySZcyBd+6mdyat6r/ZFZ6K?=
 =?us-ascii?Q?4Pi6RZp0wN7J+YtBKLNwqztMz+hmTgjdFlbAHgx4Q7slGs73Nk6Qhgtf3CFe?=
 =?us-ascii?Q?TkIBqF/Htdt4+EYkcIrnXgo9excXOF1037vXeZwdXHvIzfhJJ1X05pY++RVC?=
 =?us-ascii?Q?2KfUIct2zzRCMRP1zBf85tjCvOZXGWwNXbE03nU9ni+/H5CIHoptoQCcEAF2?=
 =?us-ascii?Q?7aU/PANDUlxLcwewrh3qFTDmF3I80/I=3D?=
X-Exchange-RoutingPolicyChecked:
	Yvt/g5HcCjs6JrVK14RCH1JCeX7/V9r5FijkI3IUcnGJmEBn4B7VuzUagbhvSx1oQmhXIjiJWCi6C4E0W5GGL0x4oYT19zD4zB7cr6p/dJGbTFK0ud72khhQNDPe3vvEUCksbTqWxHI/VN/JU+lRuzKlxUFhlw15gg2pORYRqXL/0WFJPPt8ADdmsgPvmChDOI1mPmNLp2szS2MAx1ItjITKhINO7hEZkQvH1pBqIiqZT8XV3wH17zQDvdnQLu6Kppemx4bQCluZC/AtQYOF+1dfLjAveW/1MGtL5Zlnbdsh/46KMPE9jImK5fumLmOjuMc4hRSQ/8tj+qUBNZR2mg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sCw2pF32uEzXbn0jCTNvS6+rFUsnx5wcx4u71P/L+VdHbWry91jtQ0M2mz2PbNLLM1Fxaift+aq4qbNctMv4wrmj7iFIB6ZZfDikwpwCnFKHZGm7rTwcvQaTvGtbLeLJ0mLWoaFKQXjaFmF9CxaPP+745ItFHhqRxeCnfmikLk1ndMbtWEL4ONwVi6NyO/TJtLbFOHy5BImePQzDceNZyCzBddcOrgG0VbK1oOaoNCpS8+0zq9Jtf3pT3hfmTb5lVYdwhnT4gKWQ0PSQ7Ix/wpzkCgL/ljIlpO6RRXCWnyEI3y+VzOGJUgVCygb+6fAQLj6RwqnI3dEMnjIhQoUXUCYBT4iZs7XFu3WCeow7plm5V6OPjCiPJvavCcZWlaQgpHqxmJxy2V3/Ru5/U3kYxxXajlvkWc7JaY11GZb04ODsr/dC1yWXyc8mfZhyNC/eA51bu3geGOy1kUQiguVuyUMA0J3mTZe05e4IYkLsBaZp4OtoUrENiiyVtJzVJvCGz+QZkggHpPNLVBMGLQlY6sqwrQfdEKy7xiZz1RzaR14GnZqhwhWvH+TezQEjU2ifeX7FbO8R3l0Av/FLOAR5PsXen3MkpUvFAwfxZ7Jb6ks=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3104b726-9f29-4c4b-6263-08de95df9fcc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 02:28:02.5840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMPErp1Zk5RFNKsM/2fl0hVrxB858q3Nn09PxNRUMr4xjPb5CEp43pEDdK0+d8b+umMMaVr7LSZKj6Y+0/TR8BbrgCRmDXhZh6xP43W3WuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR10MB997834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=751
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090020
X-Proofpoint-ORIG-GUID: Wrhc0eBojacy1FWIeFXbT7T45AF4cr0p
X-Proofpoint-GUID: Wrhc0eBojacy1FWIeFXbT7T45AF4cr0p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAxOSBTYWx0ZWRfX3lyZgoL4yO0M
 UA4dH5I3czRFS7JiV85NJXwy5m6RwsQ5juazSU5piAXap3dO2loO8r+CbCOMMdttYLIDg001POS
 XcP9FTlj6Ag6N03EsP37ArlMawC9KUUZikvPfE777o0D6ULg4pQK8Hhr4ToGlYmVqncw9fFLeBf
 ENeT4KP6ZgyKVvj3WBYRdL6zuWTCTWHLfBGlb0/PqNkOZ48DXS1Xl+M4yZWgRxB5/r17KHe8fAF
 Fr/ucxfLg4zQ8UIc+bZCqw8Yb5jOm5xz2N2bxQlCQYf9keIikiD1GjP1uoiUckmG4cFRp3YPVYn
 Z4+7+KEee8FUfbd6Hvyufq33921uu1/wf4oSXSETayIEB+zVu2eGvCeiCMTkuYMnb1NGzcl5XVY
 7yETlZEEDwtHg2DC1huq5lJyYwsWnnzPEbcxApOIVgXxQdt8OMsNfqcBfqmaiUK2vJqj6g7iOW4
 z7HjCgzTRiIP3v35qiQ==
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d70eb7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=JBNebbC9HC7U5k7cQ9AA:9


Aaron,

> Kioxia has another product that does not support the qTimestamp
> attribute.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
