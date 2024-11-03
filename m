Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5744C91;
	Sun,  3 Nov 2024 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730593359; cv=fail; b=FHJM5onCGMQ/PJ6rfNVgM3nQINg9zwpIJmMR0qCehNjcyo9mpQ4f2Vz8eZwr7cEt2dorcWTijTAdmxGLtaJN+HpPgcjRohftD4IyFE8jPq3QzGU8fxv41kbeCvX628w70beouMQKKAGHcUJOf1HjLtPzWo9BF+c07hiik03bX8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730593359; c=relaxed/simple;
	bh=6JilGtYdGgTcU+Z3MVaxvX+ZrdfpBan7k7ggsOljIp8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cQhqcg4sLaQ2onmuhwJa8p3cbqQNPsf/fYZtqRQferLA8e9c/Bwdy+Mq3d4CPyHM3OJI1RkFr3nkqpgHf3dz09W/WgTFFNR0eI9OpJE5OHH2R6K7CLOza6v5BrVLS/MI1PqyJXtYlXBiAZLu58ekDEBL+C4wqOORtH+xjm9ILcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fn95SB98; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LwcRx6kN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fn95SB98";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LwcRx6kN"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A30GRf7021368;
	Sun, 3 Nov 2024 00:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=MIY8s0ixq0R+4MlSLt
	091ckGrvy+e4ZkkP8Gcqsst5g=; b=fn95SB98moju/VOCBe7iddG6IEmepPK/zD
	BFsFCUUY0dTaqf/Jb+9vZ7f3VXTzIX+bNpnNbnGovN186T1OqYI/TIAaOLYeH7WH
	rw/KV5bIeqalZ39by3j0KZ60mFd9p+2JkeJ0Zblrk5/NX9opdqXqu+r4TZBSAU09
	wVI6mJdgEqN5fJLGV2Qe8vl3ISdBmK2e5DmstUvrrNBNiYGF7tga0AOn706gmnYF
	pS4PrIE4SSOzCaffqDyPVIabujglfaiNVNy5PNegE+1A6SU6rG16kY/OhglLleah
	w2B1OGxRIixeh/kicCdTenbb+jWVU5ZmRXAS87mK5fLYc2J66iZw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nav20pmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:22:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2IANql008990;
	Sun, 3 Nov 2024 00:22:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahasfxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:22:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQa5v4HiOCq4bG2IXRAQAC6OxDFrITT4O26kwbC746L3/kS+IAel4iOkLRPFnsNlyKAAOlMu/fmz+yyDo9SNCieYdRWgmhPcHd4coshq3q1lvY2H0paLv9jCPyX2aeeT8f/wmArXqxyrEGlwo1eyXgSXu1GxlCRPyIvPInYFSCSOyUvma1LM6DpUFDCxLlfCxfKmjcxuA1kRcJ3ap6SqRQ5z607ouezcDbAjWnk6TPjJDfpG06MxNhzi+v5+56RqGmbPnqj3G1mpetU1eQZ2H6hNWsbz3fB8gYbAeOfZbblE372VHJxgo21+Re9R392HSW1pcGYwBJTUcJjARB+4cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIY8s0ixq0R+4MlSLt091ckGrvy+e4ZkkP8Gcqsst5g=;
 b=h1XVQEfUUdd0rjJ8IyDwKwSph3MXPVKI8SD5mNocEhJOSvoh79chECLYxgSUXuLFs4+5JkxpvxBViaZM0vVmiSxIFHfKCMF/BEni2RpHy3Zmpy5pdLnESYnQJZYaKu3pQDijPBx8BYMnjS4YBg3qOvqO6yzmjm4jJlf47mVQOvDXhCbrGGLtUG9J/n65WW53Yw/jg2M8byL7TrZhOnHp4ieSdiCP90HdN4kWwH1v2mbdhF99p28RgNXyrOL6RQuI9qEmS1jkavt4PUBUeeG87plm1CFtcF1WJEob2zqL72jtxNSn/nyfwHZf1OSXQeprEKGhrbAiNy4932wih0+uYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIY8s0ixq0R+4MlSLt091ckGrvy+e4ZkkP8Gcqsst5g=;
 b=LwcRx6kN7XW62MSUaBtRwP3xhpImxrcU1oIaIYBu+sjDam5Fs+WlfVebS5F9vH7n1hUvznz4eUg/He//RZl2SST3JgjFZJbXTDYI7s4xUxr0w6x9lYTATf1tq4Bl1ya1ZhCIwcmRGSV0G/7xuLYisPWPQXg7MTy30OGQWrRz9B4=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SJ0PR10MB4797.namprd10.prod.outlook.com (2603:10b6:a03:2d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Sun, 3 Nov
 2024 00:22:26 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 00:22:26 +0000
To: Igor Pylypiv <ipylypiv@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: pm8001: Increase request sg length to support
 4MiB requests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241025185009.3278297-1-ipylypiv@google.com> (Igor Pylypiv's
	message of "Fri, 25 Oct 2024 18:50:09 +0000")
Organization: Oracle Corporation
Message-ID: <yq1plnd88ut.fsf@ca-mkp.ca.oracle.com>
References: <20241025185009.3278297-1-ipylypiv@google.com>
Date: Sat, 02 Nov 2024 20:22:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:52f::21) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SJ0PR10MB4797:EE_
X-MS-Office365-Filtering-Correlation-Id: 384f1fc6-4cfc-4e41-e44d-08dcfb9d9815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PA3ET0SyeHeXFgnwXNO/FtySPiJSKXQ/dMQQ3RwKcgc9UUD4yl6QfhbF1CeW?=
 =?us-ascii?Q?DgrxWa7JKT8lcWyw+ydeq02XH279zA0kB991zc6IT5XTyRlRY7QGTU8WNxu9?=
 =?us-ascii?Q?fxPeoSdxnewO14O3jBrA9mUgIiYYt5LUHJcyflCmIAl5cvC6Wratp0gg5xmj?=
 =?us-ascii?Q?miVxR/okGDhNvY+M1TsVMDbQAmIKP/W3eYfDKIV77ezc+91Be62lKMXaEDv/?=
 =?us-ascii?Q?5+/Fv8FuNC2+P+y7aDDnNt6IIq2Rr2huH/3uNpsW54eUhZjAjBuXfZKaboOm?=
 =?us-ascii?Q?pOKN6Ji8pKSEopenM30dKjP/h+ARif8XcAfLGHj7Dbue763Ylf3OfT6T83xH?=
 =?us-ascii?Q?QHj6iDEf2BYcwfREfBCSwWETfFqLemeoa5vHMmWNmM+n42jrOtIpPRBWjM6k?=
 =?us-ascii?Q?+IdYxgpzU3u1ODXRxax5kST01vWgHLlezbzLt7A/P59h+Bb61ixu1q7H9ycL?=
 =?us-ascii?Q?0fq0Z4F9qHHGm2K/PRROE/0KgkfVClPOLGuO8zfcU/60KTYpZzgIzkX8jrvU?=
 =?us-ascii?Q?EmvisQrJm0hrqChkUdgZ2zDoRk4wju188gzrRuImDNj3x0Fv1nPNKYBdVGO6?=
 =?us-ascii?Q?tgsMcWA10YGn5hSkmHKO/K5BoYsHQnlTBCJPBRwsx/cmG/Jv7BY0IAtZZAX6?=
 =?us-ascii?Q?IvJDQ7h59WQMFQr4aokPJCe7R5e9zni+RAe0v6wo5WveUG8QVAafoHXsNYHa?=
 =?us-ascii?Q?X/LFvjUZ0M09CBEQnEzlxGYlz5UY2HlauOW5yKngyIYp7ER3rcbZHBNFT1G7?=
 =?us-ascii?Q?Wex1T9Y2vCfSSnU6K1iDY5Wcpj6vKCY/ym73+XNowe9L8y3KIJD6xRutfWq4?=
 =?us-ascii?Q?9Se4fL4xvGjXPCxz50t7tRSMXbBYsYe4oD/0Q4bZR655T7W0u6iTOASQfmx2?=
 =?us-ascii?Q?dy2EkloNEOwjuneoQRSXeswvM+8t29wVkvr4SYfAg8rYDk7F2+XOZqd2h6Ag?=
 =?us-ascii?Q?yay9kbEiASSfPzEOmI72g/X9RgUg+HGIpzj/mDDhb+Y6trXXVvEccbxbtaRQ?=
 =?us-ascii?Q?McAG61Q3M3z1Hos6U6DXIY9b0amL+fCLBwsCp9VZKb13xsa4BGcqlDBhqZD1?=
 =?us-ascii?Q?jZtOZ/VVCdVVv1rybSEAKaIaEfdgR0ribovt/vRa/bhkV9JYKMVGo1ftGGpe?=
 =?us-ascii?Q?qxLf/xYFvLu1uK1GcNRjeHZVOPabz38KwH1R8ECVs0LJM2XlUGaYFOI3icgl?=
 =?us-ascii?Q?Z/jxY/OYEhmmlF+IfS/F6LSVdxAA1PlSsE5p4pfvm7CeSpCLCoPfiKmOOpGw?=
 =?us-ascii?Q?0fPSFpZ84P7Cvi5BUbP70E3681D0bXIiDQXh9gnJHKY0+vCfkOB8GY1Y9MFu?=
 =?us-ascii?Q?aIqQDbjKSqIVsZXvIClee7b2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sFz8VnDxf/oKqzhs4XtEqw9L/0kAjRluHImhYWZesZc5Wcq++A5qz6ylRHf6?=
 =?us-ascii?Q?LGhYT8RUxNFb0VuzBydVuLYDWKuiMV3A438r5bShI0MXQ+L1BY70qVBufxV4?=
 =?us-ascii?Q?HowbTvU6+ifarAz+YbRvzZYSzPJGkr2jEbT8QfRFmIaRtSuEX2KIBIgvL6om?=
 =?us-ascii?Q?uzrHkLWxxt8NMpSuX00+7juyy52oKCPu+B5Di1ETB9eSaMPo1bu0/qsdbo2J?=
 =?us-ascii?Q?XWuGYkgrLTTL13SH/8H5N8nld2c+lFjA6YS2qaEefJs3HJqhIqHJkiyk1h+/?=
 =?us-ascii?Q?XNvql7JY0k9iLsq+eQ8XI4WEC3Ol6XzU8hJoXiYeH91iS1MdHFJul/98UpIO?=
 =?us-ascii?Q?triw2dSUbozdNPbFMRo7N0rl0NLMOCSy1SLW5DomaTLppXZ5nixT4hShjnHo?=
 =?us-ascii?Q?jEp0CYFGXCV+O5ITpQ/aXH4syZ7mYqDAfEExfmJzllQ+JrVhVeOmkE7zv194?=
 =?us-ascii?Q?aMLPDQYBDXqbal8YA0x6/7lxSNmQYgf9KVxzaMXSjFNsQr74z1eZqHr7DOjE?=
 =?us-ascii?Q?7pWF3TLBMLZx0dgHHjTdiGVvpOVm3kp+D4NVICqyDIefEO1RbLt1+GJ7Cz7+?=
 =?us-ascii?Q?hGP2j4s47hZ3MMi0vuw+xK+yFboSoQrtVhWiAqP22LvFkScIGe5Arh/uvGfp?=
 =?us-ascii?Q?xxI8OyEGIxfWIsQTZ1CkQgYIpB7rCiBABgFWxCWjY/rbx4uI9NDI5SqOER2+?=
 =?us-ascii?Q?iWMWEzR4KouhpJOBFK/A2g10Z1J5fXLptZB4I6BhbYgnkR5lrkQCrJnOouuG?=
 =?us-ascii?Q?tlG/mWedW0QdQXpxGpN97VWxzrwlNB4gZFJl9XRefbDS+NvJhGPMflXuTfQi?=
 =?us-ascii?Q?+zXo6cCLUeozvIkWfknUx7ybUaDgu79e6da+DMlH6Cz86+TMcL+P8X9Kipz/?=
 =?us-ascii?Q?cfbyZW47YwZmv28Vg4J+sw4gUQCHgrP76YbbXU97by4lXyTpFX6FOlHHCe48?=
 =?us-ascii?Q?HVTnVvyJ0CDYf96kM5lX981/PXl0zAVY3rL9d85F7+XCUh1B/sO4OqlmyLm/?=
 =?us-ascii?Q?/0Ib3ncG6PKqN1fS9L61tolpy87kAzKVqRv7FYxl6bHYeHrh1yZPD1PKpxmF?=
 =?us-ascii?Q?xEoWXHhlJhdAc5xKtSpRGnZ5M+HACgy+Z2iV8gHWM3ES+oVpmLVrekY0bNG2?=
 =?us-ascii?Q?uDejhEdopLFiB6g6PITckdmyvoYqAj/DupQHBFH33f655Ad6/C+Qh6Mh9/Wm?=
 =?us-ascii?Q?8OioRy0BOSmU57K/6BhfksvKmSXKVHzmSVdDLXjU47sDvhi65rSQSegnYOuU?=
 =?us-ascii?Q?1wXhpN15WSQ/1TYYrwRUBx0Tda0fuNKfa6qLrC9x/uBhbUGcvTmlxDZugdDU?=
 =?us-ascii?Q?k7sf9354JzkdfMbGMM+UtHQSPANoDeKPPjlXIsX+AyA+Y3DWvhoPWz8KVw4P?=
 =?us-ascii?Q?BDPxAYvkEWNTILr6vEAe4kbQ/jRoVfz+E1yOkIXC/gVKCl+gvgSM6DGTEZ08?=
 =?us-ascii?Q?WbNnhsk/d4doAT8d+AZ1dlYxiBke/2VqIDAi/uPjKIJ7kqMwLCP8a4sg0j9K?=
 =?us-ascii?Q?eWK9uedjfGKwzZlfkAqzppc+0BLqZofHxy9fbN9V1VXfXiYZHqxBKRjXxWIu?=
 =?us-ascii?Q?nF7kzaSEh6XcsFoikf1lvZ0pY2PV4LwR5cLPLWQFeCgkuujn/9HgMDCbz7vt?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Czb+RCE+6FwdT9r8PiyDpUAqvYTcLL8wHdtPkB47bsVH00Nxd+FGrjxC50RzgTI2kcd/x7eijqGxJU4PxuTVjZKmst9bufdRx9BdojOJd8BvYWkQfkbthF+Oxu4qgxUmoSOh4EKEYgjEAAMjFsjINlDmEe6Hv3N3R5hQuRXLZsq4G8DdhdOWlEARbCYnHU2dPGvLUN8kQ6x8/xoOu9fYTOufBx1DzNYp2N7mC1z/iL2R07qaGQPy4WyIOw+t+K8sV5ASmTuQxtkmisTXyxxRfiS5WCLA/8Cy/vyIZq6PvK/IVMo5qFr8SC6Ysl5s7BKavBHWY/tc/tp5BWj8OwiD4vANdlslkt1fRWaD3GfMUq+J8NlIeIgeOe4IYgOwLXTmR+ludmjFbHOglYGWV3iAEgWJODb2rETRHXI9P6S8QprceOEVygxp4l1EW5udqoHBhoDMWqQ/YtpezXGaLRySaxFqV9QULo3b+Aq2KkLZflkayjckrWBUwLfHuSl5OAxvFJB9Ss6jjCOR2ChnAr0PlaOPgBiAqtMwuebKQiGiwEn7E3vPaq/pdKfQtkrmcBuEWi+IfZ8beOh7QB6s39GFNBye1tVIaqBenLrxyJh+xPQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 384f1fc6-4cfc-4e41-e44d-08dcfb9d9815
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 00:22:26.0571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1M7U2d/6kyHdQoxJabRQtpsBuoHUCq1qKCtUx1ZTkWjL/UidQ/+fQgir5qTJMpy7kjJeWd8P0IdRha7CXnQ63T3hk+n6grt7EcXZpqrDnOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_23,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=910 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411030000
X-Proofpoint-GUID: o_TJ55Q1AxWdCvkptAFWnZcc0yvoKj5D
X-Proofpoint-ORIG-GUID: o_TJ55Q1AxWdCvkptAFWnZcc0yvoKj5D


Igor,

> Increasing the per-request size maximum to 4MiB (8192 sectors x 512
> bytes) runs into the per-device DMA scatter gather list limit
> (max_segments) for users of the io vector system calls (e.g. readv and
> writev).
>
> This change increases the max scatter gather list length to 1024 to
> enable kernel to send 4MiB (1024 * 4KiB page size) requests.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
