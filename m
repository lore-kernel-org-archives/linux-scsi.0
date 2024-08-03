Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93DB2599;
	Sat,  3 Aug 2024 01:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722648474; cv=fail; b=NwIMx1xNDTtUpUAnDvWfYLjC8Tv+YXIqAsrX93rcvkSBJ5PWdixONcPpfsDWvLTASDL3iOpPB76HBAO3YPH2yV3oUbr93cWAkwtOEICjkrX11Dsak34r0QhaUvxsJ6c2LKjjQKKsIMpVvJvhy/7h67iUmBMF9mhuBpdZxdlqKxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722648474; c=relaxed/simple;
	bh=SBMg2qObR8A8BwIMQU2o3VkBsy2eWsrp43esyif6cmE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fn4tWCFxaw/YtPphHwuYRqtW/dgfRm1Pyrn3VlUBpKhtw3fbUhmIIouqBjkNYWElQ7B6sQHnCMs6YlPiklToYben3OLP6HS/tZnhRn/tCYPJmE/qBek+pYx6sfFONKOSZbec8Wz9tUZRh+OzdYY0slUDaeaHUtExPEF9mT0uPp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VQcZSudQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hFgQ7RcO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VQcZSudQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hFgQ7RcO"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472GtlAA010375;
	Sat, 3 Aug 2024 01:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=yQORy871KDba2K
	FoIfiS+GnHm6MPm3aQqJHFq6zxrQ4=; b=VQcZSudQ9xLPWw5YEZ/46el6ycZSHF
	U034aseQSMq91bVA9H7E47dFaTwuJ/W4ZLXlRJYKhmaT8IhVzj4Ei2VXt1e/voGU
	N4K1WznDDB79/XhAjtMgtSohdMqFPRxlPKVOwQGYFsOU8pWdrUy3lVWgCTcxhOac
	aTQ167bb7ypQGHlG5qDl1+mYau6BtrnDC5uArWq4cb42jv/L3p2VeOkV4hydRfkc
	kXTUBWe5NadHa3y+tGbyOVoir2OjqzTmdlYgk3anyfj2T7YlwfmlJPZyqBroF1Rb
	eO3pNFj9o1/Liyk/KLtv8o/mdB49ryqbPpi4sX1qoSViqCks8hnGZvIA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rjdsafbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:27:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 472NEOiZ001824;
	Sat, 3 Aug 2024 01:27:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40nvp2bcx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:27:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHvngJR/Jg1pcfEIdSu472eJVyz6tMtCU9GW5oueBOPbs5lwUIAOl1yQiYRlD7W9ahxOjEkpYgmwr0KOXDnFWxCbZD+5ltlXtMY6Owez0Z6f7XMeO/Uy+i5nVPQlyfSdUAuVCJQLLvlTqn+b2rjA7Cu6VqAitJYP2nQmfXWb6Ptq50uP2Zzv66jqbWbrYkAbkbmfqCIBtF7drisNdrNykyxXOC70TgJs6FxXM052ow58uChVJOf2Ke+Wyxz6BlnakLeGTLSL4NQIrJKHNZMbjdG3cQ/+k8co29BB5amRM1F73bToUR1iHq8e4wzV5gF7ZLhqezoKkH6t8vs1r+SyfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQORy871KDba2KFoIfiS+GnHm6MPm3aQqJHFq6zxrQ4=;
 b=bd5WRaqH3CwWF+LnCi8UMCKe9JhlI8zOmTyoo4zWY9u53HzHPbfSObnhnCnPcKTn8Ju3umJ2HiNJ1srfVjUBCU9czzBA4lLyzN9t9SbzxPfqV6L7kmgW5U0FiOM73DmcDwo6lZSZvYCYYweZiNAXE4im2U1NAPj4r1p/W6C6m5iLFNQomyzdb8pFZBgh6a5ZmtBUiMBg43pdx3Oq1OZzG3P3uvdj1pfufj7AF/j/J4aPXFmwyXjHD6RtM8n3lx/apAQSWadLi2uDl+iBL3MJL0/nJ3QcXKq7d/GTjICQFz73HudKx9i2O1hVUz5PxCM8kIumPqdb9RYUhol4gRYTmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQORy871KDba2KFoIfiS+GnHm6MPm3aQqJHFq6zxrQ4=;
 b=hFgQ7RcOVU38OygC13redyyr7JuYk+otAV9GO8ebZd1MZXRfG40zalr87mb/g26hm2Nc0+Tdl3qkunJkzLoh0qQwYE+F512qvLeMgS5l1VUQlqG/2GAeiNkaWlQqVyjEh8Xc7bDUEgY6I/P4r3bCFOqHbz7B9qx/PHtjCh4yvQE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:27:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:27:44 +0000
To: Kees Cook <kees@kernel.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: struct MR_HOST_DEVICE_LIST: Replace
 1-element array with flexible array
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711155841.work.839-kees@kernel.org> (Kees Cook's message of
	"Thu, 11 Jul 2024 08:58:42 -0700")
Organization: Oracle Corporation
Message-ID: <yq1v80i75vb.fsf@ca-mkp.ca.oracle.com>
References: <20240711155841.work.839-kees@kernel.org>
Date: Fri, 02 Aug 2024 21:27:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0448.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 221abb39-951b-47eb-54d7-08dcb35b79d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LdFN0zoVSR31KGB5kGKa7tPFAdt9PMsomBhyYqduIwGlzqP5r6wbQwkHexeX?=
 =?us-ascii?Q?cldBxXms/Q5OYq+GdQUrF84aFG+TlmxbQND6wrDEYEcGJXtf5iOTuT3l7E/t?=
 =?us-ascii?Q?haWIimM7cw0FlzLIyCeV+jR6EZYcFDQ+tkD8nicCkerKrJq7ECrYuFtH9gDM?=
 =?us-ascii?Q?QXn27Qk6AI3ea38HdO0pAgndsyJHykd9JbsBmG7i8Mft0/agLu2hNws8yW9Q?=
 =?us-ascii?Q?k7KJdsnqFo7aR3mGSBcX6faCu4xN57rbQqh8oh6ZoMvKYXpTLiqEWRdnhVlH?=
 =?us-ascii?Q?eOEiolTLIF4BjBRYGS2FFTaC6cwEBOOGMaFpTHy46qaDjoqbz+2tpldBq6CC?=
 =?us-ascii?Q?xC3wQY+HH8r903n15eBHZliJX+8zvdAYfeGYXrC8P9dNagyJP1iw27CxmGgp?=
 =?us-ascii?Q?ClEVh90M1eOwrY7tokLOIN3MAz6pDS/Q7fvbl6LjCQ5XMP/keA4TjMmE44Sh?=
 =?us-ascii?Q?OVtUJl0sX04EqyOokZfVN1bT4MtkQZraNIp1j+bod1whi1YxBH02JYDFZPHg?=
 =?us-ascii?Q?h60aOZLIgZCm3uAS60lVDJSjxRaPJjTAS4hx8sby0VBMufBsDiiQ/d2d6jrZ?=
 =?us-ascii?Q?Az2e0rkPRVuS74mI01RpXqVTMOezidLdQ7V79bOzTNHyK0Vp232IWFq6lr0s?=
 =?us-ascii?Q?wtYvNPLAejCdUS0Oak3SMXtQBJwhY0Ljjf2r8OZtE6wKDIrcfT9gOMEBCTqz?=
 =?us-ascii?Q?gMlWlBwD0fcgX1tHWasZtACo9qyP3xFp434KLFIUwF1dTsAsKk8zm8jM2VP1?=
 =?us-ascii?Q?nsaQdVgKqtcc+y6AV6z4j6r0vpRjXRnafRAs5S2HliDM51vgVC21IFqkk/ZX?=
 =?us-ascii?Q?oI5myBrMU+IZwhpoHsIJHskWa/Ab803avG6TlEevxHORm3+rcxPSGd91DpNE?=
 =?us-ascii?Q?fwFfEoBE83fBpewBCw0VxFm0fS2MWYDDtbWrJ3fEcc3DGi3jm60f9zFENkzP?=
 =?us-ascii?Q?aps6uHETmIe4XiZ6m5iPSAuTdVZ9i9/Wg9rp0Av64TtwXV+1fPJXUMA5e4DK?=
 =?us-ascii?Q?Cri5uTS9MDyF/uMSyUaWkuwp+uxAxZZZi32yKbIdqPygYMW2zdtXFJ9l44ug?=
 =?us-ascii?Q?DnQi+GwbatE0Es0bpVaKlnbD12q2daxLKBaPy8Eob0DJzID5F72h2z8+uXLN?=
 =?us-ascii?Q?UHVK90yAz7Ad0L7upK19bR9RVzZplfJ3HYgMfY8yCe/1vipVEvd1DebjSy/W?=
 =?us-ascii?Q?Jl2t9xjnO48pEgV0MZkIrllv+Px3HlFKyvBtk93QP0BZm0nK/aTG9yvSFMoP?=
 =?us-ascii?Q?NgDdEk8okGszRHz8zNMRq5uUOJsGjhB4iAATxayjxZ+hg90q9hmyOokSNOUB?=
 =?us-ascii?Q?jbQjRBTJ/35FmRt/akbyeIunfCIrlsbYuGQgC6I1GpYoQg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qRwWSnobI5HD1vPFjF/As0XhHoHlF5+0zCS+R34Z9/MNHXT6KifBN8gaPe90?=
 =?us-ascii?Q?IJn8CyGzC1JZU6QzM0mQW2G1zAIiqlZsjgGrDAA+ZQ874rO/yBXeSUYcBM6O?=
 =?us-ascii?Q?4ge7TRe7+pbsCEDI+CZow26cEuCL41B1n+226xYL8RvTJVZVrM8RpKm1Y4y4?=
 =?us-ascii?Q?2CCcYbSvHN36aw+FS5xySG/6GAACYjN6tN4eHIQWU2MPvvBOjFNbfE9r7Qpy?=
 =?us-ascii?Q?ljXrgVkV0+6QjZsoD4mjsetngQASIukT8ExrSelaIYuNEU+NMA6/SSJ2TQ4S?=
 =?us-ascii?Q?j+XARxr+dNbUtbcdHb3FE4768F48zzpNeF6PvqmwfKZI5SM5egizK/ZDF9x+?=
 =?us-ascii?Q?+6M27sj7l8rutDxONeOEM4NuMITY51rUyoLW+OwFUSCElVDJZGQJoD53LGLc?=
 =?us-ascii?Q?9G1beErfWqMVwst2jOFL540Mqcsz3LOsvMUG02Cw0bbe+FbQjCAIkx89uYtT?=
 =?us-ascii?Q?CNw3R/4IhWnUAjDmE7w8vVn3G1fUIDaJK6V3bxaW2YbTD8lFJkCs3qOvEYX4?=
 =?us-ascii?Q?NTMZDjUSHnnxzgmnGQyCdeFNrHz4SmHOQbIFdJmjNc/nXVSiWxHAfxm802Jj?=
 =?us-ascii?Q?05olD5Ku/tWdeclkECHbGG4b7E0rVDesvDGt7d3i8AHx42uR8vB7Wk5FsWpv?=
 =?us-ascii?Q?CVyiwboT87pU08GfBepfgWdnMGT7O4IPnDuwJXe4nYFI0N060kbC9jDeDbu2?=
 =?us-ascii?Q?GCiUZrzxUP4JK/Icudk1o/XmLkYBstrAKqB0LCwA9GdJNOIj3Tk6vktN9vIs?=
 =?us-ascii?Q?4m8rEcuNe510Ux/n1aeDU0iFKZam6E1diGVGOoKQdwPqimsVYTRJwNXcUowy?=
 =?us-ascii?Q?EGCwr1jKMbb1pZ5zAiAGGVOS+unOBsq4lWBYXBIOwD0f6+BnjYb1njofK7VN?=
 =?us-ascii?Q?gpoiXs99AN9ffPJ7rlX+lpX8mDLX2iCqHpNXv7C0QLNW/gx+G0tPomG1iB3j?=
 =?us-ascii?Q?JOkTTX82m5c7d3bQPuUgbiYLDoLARo7U9lMYelQrYiTPxbE4JvH+IYsYQeSv?=
 =?us-ascii?Q?v2kgsBA6/WTAB0g5EV0PwmxqGf4sw0Np4dH0jnuFhGOE+pXvdiwfbIausUpO?=
 =?us-ascii?Q?r3GRIwvzxvoelSg0g4Oao7+6o5wOmbkwLfWgQtFa9/GjBTZh/WkqLa9wQqaU?=
 =?us-ascii?Q?pMGrMAV9XfvRWtTKL0DKxXQmit7otluntD3Filr+Kgx3xXE3J+8LpuLSQt45?=
 =?us-ascii?Q?rDseWss46R0/APcez1IYFp2N1Dx7qgu99R2XSeYOigjm0rWHyG9vcvXgk+x1?=
 =?us-ascii?Q?1P7yIK+MW1OvTDpluJP7MUpbtAMByhw0FHVc8V3DNTmtmcjSrtosaLAjBzbk?=
 =?us-ascii?Q?StOsthshj6JMuALaBmE8Um2ycpoK8YMVJo/Ng2clUAsFYs3e749/E/BsRTDx?=
 =?us-ascii?Q?5nzgfsfG7R9wbasEvrTNyVbqxV49Htph1bNM7lTFqsbdECgUT3N1pZ4PWU1i?=
 =?us-ascii?Q?dFQr2OvX08pDo1mnJHbKWjq5N/inhCZ1Kw53TdKPAiDWT8DRTpyK5m5nNUYI?=
 =?us-ascii?Q?v2VJd8Bmih9c3nztPQQwOsEw6eEPgUoymp1zzXxJVPNnnKKU5QIArXCjOPst?=
 =?us-ascii?Q?QGPlzsuV52wBj2IiYNTUBkPgLei8ZTOhnOIH8Pp4svrf/satx4xCvkkp3M6o?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P6drw78iUS6yb5J5k6SPpBKpEw9DC8/H7DWlTmYVw077buCHrm/sEY9tYAtWb/x+3f+ps1lZZo4I2f9A2czPQY2bFIuaOWQfYNUO/vU9OlqAsIcXKahP74kU4DLyYTpPeCBHfDs6jIboNITh4vYL5raaf2TpRBYX6NWfsHQOoO7msbvGi59DLRLy57sJ87bZTjiiIUViat64uu2PI9zs6W8k114tB/XUkEVZ8A48RP3ACBBoGi29vv5fdPEKXXjA3+Zmq6VjaMTYfawMvGymJQmC1/0BwyVbwM4GKE56fGFjWqXMwqUxxKcq40RBmW33uWY2yNu5un0PifGhZjwxjYG7Op10ypL/6FARN4/phWjTvTeacpySSlkkg0zp9NrzEqpWnAhX1FuibYP71tRVVD5xfd5k2mYO7IjVC1HH/bOyK1R1siRbP/zgNRMiZr6FGSiaPMKrTgxwM/rC4Hd09pt/QKfhnkSmL9AotY+xLBKK9P9Nt4ciRK/44Ov85Qz75aDRS9mm/aXM1N4/BvM19EZ/eILVbRD6NniMtzuxxXDdNUXDYxVkHr7OAEjn8V90bWdoXd97y5N5UKRpo/cbtwPUAbYdmgPlpxYNIh1DWlE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 221abb39-951b-47eb-54d7-08dcb35b79d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:27:44.8036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rup0iG2XvwuD2/q8dFyTF9qp0/4MULDUhkhVlo2i0qZ0G4dR/QFcfkcIW8ydrCknqpIXo+lKZb4pwN72Fi/G2LWpdR4aSoRzIwC36zrcTTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=767 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408030007
X-Proofpoint-ORIG-GUID: cmlRmY6LmXXhl6i1nzwj70P29AbPmUBa
X-Proofpoint-GUID: cmlRmY6LmXXhl6i1nzwj70P29AbPmUBa


Kees,

> Replace the deprecated[1] use of a 1-element array in struct
> MR_HOST_DEVICE_LIST with a modern flexible array.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
