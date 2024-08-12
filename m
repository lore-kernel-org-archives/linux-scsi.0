Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC14274BE1;
	Mon, 12 Aug 2024 22:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723500248; cv=fail; b=kC0CeX41XNVkSzcEahPdq3Vs1T4LBqUgRBfzxPlC6pZxVBieG7aG/JTOaRkl6au//dDmD7kTGkFPTlVh8LIYrCwyByezExkO3YhVyk4FjmdGC+/xY1kZsLAB+06f/12DDz1MP6bmRz4LG/+T/CAy+2q7Z22XpzxtNBUW9MOp0w0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723500248; c=relaxed/simple;
	bh=62w8LVxnkccIHA7O8Bhfp9WxfAJI9kO/DTHpXIyRFzM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fiQHIOm2hPalHs4N5Hq5+9ZB7KCKYPUvmZf5sLrUSfGdpT1+Pk+A1//GSI8xqHbMMOvdkq+mToy0ZGPG1O2j4bFJOpeMxl4U7ReYw+BskZvTeutA9jhqD3nLWTFs/VZBk1QhmRqmhelRDG4Xp2kSCKErk3DEZHwL560BBkfJiFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cag4ica8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j9pF29EL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cag4ica8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j9pF29EL"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7IYU017240;
	Mon, 12 Aug 2024 22:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=u7annRkhU34CgN
	mmXhAwA1kqXNmdiFSSJSg94+BV06c=; b=cag4ica8Q3gpJ9jl3Hign1aUEeltCK
	0hH1zgLysZ0h8lH+erqC99r08onQTEB7TFosl56dfrfn8ZxVVfkNScw3AzzvEWoG
	HVkFsQMo9PHbzlJwFut7jB3zIAXxZE0QfspAnRqUM3zofFGIDz7cgEsD95ZczM4J
	NE0LLmzkVAaNc1Kzfz9s9v5kZewj1eFeC4v9sW1KrftAwH0XvmO/FF9Pf5ny+SIJ
	3FLoAX9AAy7MLeTGZtX3bm5jdXFNdvYRrM/0rIkQ7A3lGsyNDojasI0LfNLk3qn4
	iDwUwSVNrTB1EV628DjM0uWKuL0SRq6LhVw3g2f52rFX+ijmf27R+2aA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bcr64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:04:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CKUTU9020991;
	Mon, 12 Aug 2024 22:04:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxne8ks2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:04:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NKMdUUFkfBlMxm31NAQ4tAH4U6gcz++WmvXklX2j+lrH14BO74F3X4Tle88dV/T2gR0NO1BzO68yjie6pw3jkNcI2VcQuI/Uh3aNLkxNy8JWQnbkHK6O/yUU3ctGYRLnq2j2C7/f1Md4tCKTgPs7OaOvgxIdxp32m3V/nFa1lcmfHm1eQMiryEFMgmpAzDWHnhZd8+C2ZYj0M/DqbQ5UWlv0F7jyBXjZrjxXVpy2g1NsHzd+OtZkGxnamJIXUUFjEbUgOTmB336yR51sgd0eHBoxyEsuogfPIVTwtHpfFM92x03iNPGm9CfnBLyQgg29VSZtTHBc/om7XoWC+FWCyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7annRkhU34CgNmmXhAwA1kqXNmdiFSSJSg94+BV06c=;
 b=YljTpDCYpNC/9dmd4b/rjfhqqv0aD6sQB9KI8iP/so75Sj1HHFn6EE2vxXsWhVnpFtRi7e5HpWO/42oxZpCtHCEF3mU72DgSUtwl8ILhSE4NWw1WX9/wpTDXBHORujDKYvnxyqhlCA+jSkiKOB4YFwW6M/0bEY3IF45o0IKwjvhE0dy08BO9zKihJsGoFgdAks7sxgBTn9Aa0i8zAeHOpvKgb0SFdKXmFAxp0YIlKImLOkrOEukB9ASL6O2B35NsXEpo9ZwUYio/Jdus/ESzqzGYHh83MLrz6xWqkqmBitPAua/L0VUFriyNYe5NqtZojf94+s8JIsGq5j/zCfG/dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7annRkhU34CgNmmXhAwA1kqXNmdiFSSJSg94+BV06c=;
 b=j9pF29ELJxvgluhNLJWtriGzSRx8cq0J5zkYm+4TWHqm2H9EQ+VDzK14eYC7c6xJ2aL3tSyrBwHHl0Uvu9aW7CBA5DwUdZrVnySZu2R5sveFU6IN8A9BfqqZVIYHShmfdTSDgeCPObxYOkzBE6Ki8mN62+DlEExEr3AxHXNNvDQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7763.namprd10.prod.outlook.com (2603:10b6:610:1bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Mon, 12 Aug
 2024 22:04:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Mon, 12 Aug 2024
 22:04:00 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] block atomic writes tidy-ups/fix
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240805113315.1048591-1-john.g.garry@oracle.com> (John Garry's
	message of "Mon, 5 Aug 2024 11:33:13 +0000")
Organization: Oracle Corporation
Message-ID: <yq1cymdz9dr.fsf@ca-mkp.ca.oracle.com>
References: <20240805113315.1048591-1-john.g.garry@oracle.com>
Date: Mon, 12 Aug 2024 18:03:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0422.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: c18cba52-79e8-43e0-9629-08dcbb1aabed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nsrf5q2D0AAN1oWHmzTiT5sM4z0D90rEjBL52O44EDrFl6khf65D+jgdEO3D?=
 =?us-ascii?Q?p4nTIQ+s7OUbK/q1wkOoxPBizOmV+ZXqcXxEL4WkK5IcIQSlrzldtUxvMK7g?=
 =?us-ascii?Q?Yaq4Ke4uujKLT5rRrPDeVV2B5YQJB4PWr1kvsLPYq4XU9uYiQsQllFOuZIPy?=
 =?us-ascii?Q?fVNWCmADy/wYMH12JakA92Lwis14D1zEhbzBRczLyvGCk1ynj7x9QPoXe0jy?=
 =?us-ascii?Q?l29aKwb6+U1+ZVGAOMRko27o2rSZSzrTAGJbDvRMvIY5xcZNivgYqHoKf18l?=
 =?us-ascii?Q?jRjDs+yRSDHF5pPXfH1PxqkdoojxlsfD/bCamsASwRbFmWMf718gMzerEtSl?=
 =?us-ascii?Q?lE1EDvvNT7k+8Ji9ta+3K9IrLAQiDzK9V34j3QbOlUljhx927e66sBatyOKi?=
 =?us-ascii?Q?47vbNzUQvHT0olPXkCE+oZ6yn2M+u1OjTZ9plK5W0kwhVaY0UwvAkQfQpRcQ?=
 =?us-ascii?Q?I6vm9lHYo6fuzJMteGu0tdXSxfnpJkz9iuNoHZouovD//6Fl+Pm0LR8cZdMe?=
 =?us-ascii?Q?yTTRu2eRVijVdLc/bJ5FrSbJ7XtBy478oJJaF8NTy4AOJ6rpda/1VS19bK1j?=
 =?us-ascii?Q?IhHGsL9kWnqeF4hpk7QASgEqaTF9nFQkAq6kPpA3HmuRjne6tYyRimopzqGI?=
 =?us-ascii?Q?6aiXsbQcwfCOHPlkqGhLVkly+SubOWCgJkRjQlaAJ9boWONaHbWyiINhfpCV?=
 =?us-ascii?Q?iSnm1zGavJGWeUHQZurn6XFjMNwDRsqw5sjIrZXjiQ8mfyQMjixmt+gIl0Bt?=
 =?us-ascii?Q?o02UCU1bxNdFPNP/HK/FS6TuxtcvISi9YpxIVCaDVnWR8SJS5Y3TPhWVdoX0?=
 =?us-ascii?Q?/Gz4o1g6ZzL/db7Sj6TQKa+yOCsYDZcakrbmFXX0DpJr9okw5KvCbMV1HDLM?=
 =?us-ascii?Q?Y1y+4SOeHNdhF7AxPPEvGBzWFyToYjENsUPE6zWWcrCo5bxvoTQDS5Y1mWI+?=
 =?us-ascii?Q?4Q8bZ1Z3imo9a5m8l7CZjbeg/HfdKyk9AQ1W+LmX+Lg+Bz/s8HjRjbRiFyia?=
 =?us-ascii?Q?6DneXaZ3jTDwFxjMCnwHF6aVdQuooz0tXGdgGx9XvA17s6JqyytWbetGfwoB?=
 =?us-ascii?Q?JJvLbC3XCmaIE6BrQu+rU/DN559z0mNk2fq4+8Q5NrLAkU/K1Ruftae60gnc?=
 =?us-ascii?Q?MLwMYQoIfKP1UJkg9FxOQbzKzTmGTg3gMxgHyuKzNsKsVGOnfrJZgr5hj7MU?=
 =?us-ascii?Q?L6h2CAppBnee4L9FlGeyrSe3XlszJnQZp/YY4DUU0c2oLeNI3oUs+hVZ9364?=
 =?us-ascii?Q?Jv7iImC+6Q0pMiiY3VbyYXMNFDbFVpdtkymi7QukT4QXiR9m9QaJ6poSkkDQ?=
 =?us-ascii?Q?qjMum4XhpSXi4w5eT6fyR3qlEoUxR9RrKSqVBrHdJAiQTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?POsdBc5hSWiqRZ0c+c9qwIE8HcrT8Y/u/N9aZxFyw2jHUFP2hJHv1ru6FZeq?=
 =?us-ascii?Q?BNsBnsMyF8qJGd05/DrKidhYV3MQLy/4WSTBrJoPW+wdoIAwOUQFxwKW7xrL?=
 =?us-ascii?Q?pflj3F6a/3Te2GrtgV5CzwF6dvuadP+Vh8XDKuEXofcXlUuEmv6mQpOdU5pW?=
 =?us-ascii?Q?R/qLK+yO2fNHDLruILgCUUbtnKkLo2aeBbG6gGi4MXSN2nS4/70+CbtzfdD4?=
 =?us-ascii?Q?VetZNJnTLuBWBPn22hh+Bx2p37YhSwrrI9O56fFKhcI6IZyXRh0mQF9VIsqT?=
 =?us-ascii?Q?dM+fwDJqUvanqPNXLASomc0WWROpXOSF5SbqzIUWDwQuJGZ4cVHpl8HhvxTp?=
 =?us-ascii?Q?nq6wTQqBuy5XXoPZs8U6e6LvAC1T4dcGIA46oguUB1S7YlJxnyG53SX9P97u?=
 =?us-ascii?Q?yozpT1wrlSzIKT9AMv7tCb8XsiHrTZHSfB68BV2iGXkreSvJrD6qxs0ykKsS?=
 =?us-ascii?Q?E3/yBppH6x+yrcNs2BS8hML8BFPaqGEKiE2B/8ayjwcjWIMLhNKJxZIf2EuQ?=
 =?us-ascii?Q?lv/nzkPbO5NKAW2uSsWz8VgSJ0SLGqziD6j0rZRhJQTlXgsuJQhENr14bKco?=
 =?us-ascii?Q?XWzrOKDIK//76g8yMp6DYY6hUWZd2JwuzX6Tt0F8jUBDMffHDI1lgArUc+V5?=
 =?us-ascii?Q?2vi4QhlfoEyYoKspMXbkNUVnTS+S/qdykqxC4Yb+UXOQK3VDIlBlZ9YLycIx?=
 =?us-ascii?Q?EXnQE+dA4/0xpKbKz37Nex9OnbEE4HPDOyg6L6IJkU/1RhJPdQS8vl5KrVCx?=
 =?us-ascii?Q?EtWWCPbbJwndlvHjYxhf0NAdoEHk5o9JbjTGfAZd8vGbXOoI8kZPhlCOKmRf?=
 =?us-ascii?Q?pLOo1xbxl5ndeuu0xXpOeU0RKF57OO43N8sPjlEGD5ews1hb5y8z+tgVcAUY?=
 =?us-ascii?Q?vSYHeAD7vdLcd7y5GDizVZUC0Dvd/TVEi3eDATpXDOeJUymgvBTBCPQfQHl2?=
 =?us-ascii?Q?BaGmIVySY9dAGifEtjg4hScG4lmou9gMtTfCMLr2pmq0qEiFnP+FkIG0kXRm?=
 =?us-ascii?Q?SJ3rkV/KC57TpHulHdYY4+NqrPtlx+07lYu4wKU+Ctog6wxHl0sCno4DB+7H?=
 =?us-ascii?Q?kbZsnFj/D21tqQye4L4iuamlHnVUcqD4PNL+TwubUvKQrCsIAHlAWbIGdc7R?=
 =?us-ascii?Q?vk9rW/XohktLK4nQx29jJUOHJIErrU6yFivQc9SL8kTRt8PPWNc61p0qSPUb?=
 =?us-ascii?Q?HlKY1fO3MKJ6kNZcEQg/QaIUhF/wfWglwpcywRj2KANzYIjafD3JWjk/70sY?=
 =?us-ascii?Q?hHsvSnrLNguKXflp/DYnywkTiY3+P0BVvtd79OpbNhtQjYQ/Hpf1g5/4OH1+?=
 =?us-ascii?Q?4PsgQOyr9W+w7Cf7QPH+ZNtlW5JH2rjWFoRBP/v6E10MZqE/e+FKCAyutt68?=
 =?us-ascii?Q?HcfDlzpDJ64g0iWJWmMf4TvhjwYjOUR+HDcZH1EuYA+c6jB40UZpbsV6wDCR?=
 =?us-ascii?Q?v4vkDr575PtT6XDASn1KIvMCWTqNX4P3bRdZT2cgSU24UW/Ub1PHDwctuZgZ?=
 =?us-ascii?Q?oIEgYicdtzO9JYyAp2QQQkK99nbpyyM51NhZlibawqLd8/nGApXEGEZtCB1I?=
 =?us-ascii?Q?OD6IAF+8H9KbHGI3Dgibkze8gBwMA1nC5ZZtDzFbjaKgqC1ls79jcbgVllTM?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KlCFIlobrTWEq7eYX5SU3rIubfg2N9uCZQFWUkMfw6mshW/9dUBZmStmduIoHzBHwpN90R3I/JZuGu9t5IoC6PrYykatYtrARWytQC5SBBrRxSfoYQTAKot9xkfdt9xRChgzYmAS6StIbCozjobLub7hs5WtS43LTfX9mKSyA/3Rycc2c37upLUx97innrzS4pbXUiIeeI1gePUY3tlr8JVD5o2uKyfCo8tU3eXleRGx+46DmVm6ySrJYqTFjjtNdTABTPiwVdAO8JO5nSu9VnYieMOYloKIh4JjNZN67yComK+AzvPfl6n2ulQ7pCOTA/R96KMTFXPxzsbOOJ/1xPvKXKL235sitOxTk3RDrB0w9tD1PkLkpkb18d3cOGOFFfYCknNMdDHUvb6EMZZRWoXysreQFCTwiaodiLgDWOoW0n2qGHsMZVsN0N/iucORS+mz0djVKrarHPqdRXI9IQLniU2iyTkzU8+cbPs1ADTciLxqux3iqli3jtsaOnKNZXzxjha+pvXav8IZb1gYuh4ZdWNpY00agARmNdqsHztZ2Vw/T/cUzub103/WLh+0dtEXQeEWRgn8VHloWGqWWJBLzO9coageKpW2GQfIw3g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c18cba52-79e8-43e0-9629-08dcbb1aabed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 22:04:00.8820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9um+qY+gKV4I6oelNcrDoVnkXhcMWV/KZX/hLsj4RsQQ20kV1NjtxYnw1/BatNuOQIxB1K+fh/HROoFRSVojcz//vlXWgolaiwpGySNjUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7763
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=892
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408120162
X-Proofpoint-GUID: tC0l_A_fxCh8EMM8BhniD1lDZ6f2D1nB
X-Proofpoint-ORIG-GUID: tC0l_A_fxCh8EMM8BhniD1lDZ6f2D1nB


John,

> These two minor patches are tidy-ups for atomic write support.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
