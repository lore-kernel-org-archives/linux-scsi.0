Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0129258EC1;
	Thu,  9 Apr 2026 02:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775702374; cv=fail; b=SR4S2FggMq66f7duTmrKPMz0xaEJpxTVfwPv0MbFoE3PZ3xoAPzJx54WXrzMNIYYAw6QSAkkPA/btFe836YgHUU54w+scNKCOpcu459A9k7uMI62Se6WoMKFltdASOqKMW63gRofCbJ20dvGxI2lT5v605CIHYGv2BHqnWa7voc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775702374; c=relaxed/simple;
	bh=yhZqO9FfL2RBukpf7O/QHOWpjU25exrNtfbTExGepo4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dKTelI/ZW9wHjQch+NsID8BsHLCTG3BXAkmOMgj0gcUqCVWppnKYBWD3XCdPntraa3fUp0p6eE2fKjC7pjsKtkaEXSYmsNH7YvceFs7Ubd6sbadNr/MPrUqL3hWLBCe1OHmNpz/qyWWwDk1v6Ocb++ZYTYJZJ0WF8PUMlkdVpC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MjddcNUB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qiF3fbtl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MjddcNUB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qiF3fbtl"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638NtRfI1189598;
	Thu, 9 Apr 2026 02:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NKfD7VjE+EslvF0HkQ
	JoRZDASmy7CNP8b1WHusgBrEE=; b=MjddcNUBSR2UBme4LViDQNxKaCZ/gI0wb0
	rWTHM4/WE13cDpG8f00HnY3dP8/QmLbHZDdy7vcx904YaeJlOwwPl6+iO11EMXJn
	PUYoADMXIB1z02rPaUbLCMJzTxZbVnibIZBrcGKhGDd80kxIVif+CrBfxPEXF+ue
	8Cv51IDGSmgULBreF85ZSNMqHo0TEYAB1/WOSD4IuDnqryzp9GQKJSBJy+WICOoB
	9fCZC8ZGZr6uZd+W3eiXTYwFPAa6Abk5NlXwvSHoE+xuiGIO+pRpjFo1G4bJ+HZd
	dgLuEgV1rV9cs7X8U60lkmHebZkwtYYZ/TuB5dbRC3+GuzhFXwRA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqavx32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:39:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6392LhLc026189;
	Thu, 9 Apr 2026 02:39:25 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010010.outbound.protection.outlook.com [52.101.46.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmec330t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:39:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XvQec5lQDQan7bB2YKQGFHWAjDW2qAEVFRGBbEdjue5H4WI3FzDw0kJfdKEuOmg1xRMHVBz1dlTaKgkr9d+LBteQF0s+H+5RVW/AvLBePzpg4zXd7bnGjUtoxqvYaHHdLS54wqLp/01kZiLCjTu1LvALHwvbw4P3z6fJ2ZJ7vik/My0JoM8mDb0tdyGUw+xcwLBAHbRrPWrlYk8k/BB4XixO4jZMGu6AcIGvepG2MooNGR56He3mckVntwB3O+Dtyi3OQ9Y9AihLz/2nq06gs3/hjmoIOCSE9mOJWy67NM9lDYnQVwvxoheJGXHZ5ojpMZOuv/Av4+MaUjAakBEoNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKfD7VjE+EslvF0HkQJoRZDASmy7CNP8b1WHusgBrEE=;
 b=gqGdL5nMUQkNURKJtTKP4OdHq2F5sPVOL2xVE6zrjcI84v5mRpsZtN7jGIW1vmVnS5BWXPpbyVhKqWVFvyi/jHMzpjqHmcgEU1LESFhMqNHmRSRQNLkJj85L5uHxE0bebMS1MjjaReHwOHlX0TX4w5xebBUjAa4h/ATdDgMfs0Z0ehmUoCMhrmdb97xznhaIE5r6EIXqBl6R2WjMCHuqSGFWFeKuBy7ac97diENlD6SMd6gNkQefaUcAGrcNK966yfYellU7oNbWxOxDNkxFHFWGfYbY8dCS8JbnfP7Bfc81miYlhk2E0bfQNgkNJCJdT68P1D/1uaVklc1xLnmd1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKfD7VjE+EslvF0HkQJoRZDASmy7CNP8b1WHusgBrEE=;
 b=qiF3fbtlf5l0d7H5oHSrk0srlhqa1BIy3k/Q/WX9jcpnyn4TXsIWHAKbGoyzuLGzEcxnUl9tBdiF6st3slkUCS1tVISLa6k7qgOjDheO/GiLRywsReSmPHY+CANl/2K0lJ/cyd+ZWK6YyRrtAW455A/wmgLWoqksWs/NPi2ZYJM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPFBEE2AA13E.namprd10.prod.outlook.com (2603:10b6:f:fc00::d45) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Thu, 9 Apr
 2026 02:39:22 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 02:39:21 +0000
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: target-devel@vger.kernel.org,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org, Maurizio
 Lombardi <mlombard@redhat.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: Re: [PATCH] scsi: target: don't validate ignored fields in PROUT
 PREEMPT
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260402180342.126583-1-stefanha@redhat.com> (Stefan Hajnoczi's
	message of "Thu, 2 Apr 2026 14:03:42 -0400")
Organization: Oracle Corporation
Message-ID: <yq11pgoyi0g.fsf@ca-mkp.ca.oracle.com>
References: <20260402180342.126583-1-stefanha@redhat.com>
Date: Wed, 08 Apr 2026 22:39:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPFBEE2AA13E:EE_
X-MS-Office365-Filtering-Correlation-Id: 762f4469-b665-4f6a-d22b-08de95e134ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KwVAvsK/01Rk6ZFZUsdzmIwtg6aOGXvT9zhGev2er4xXa/hOy/thwkq8nFj/G2FHVZrDk9Ogrq/EXnvOaU/fM7DCqTgYaRaNsw4THfdC4DKYGM9uRsvnHO/6KN0SNouZ73FBkM7p4w8WKo5BEBcmX6q2Mgn3xdZC9SBwkXSpD7vVwyRQ1N8F7pB3914SqiE5JL3I/Q+Cu+isUgruBXYdhNKRgsbmtLwgqVyAsw5m8Rw4EhpbFvGjT6y0MwB8ByCwR2DDYFmMlHrOZJVFH7vdtbFxysS9OmMkQLLmVxm4g36Z1lGYgaWlePlPm3nregLWcDq4T4we2rr9QulPYsJOm06GDuOkdsy8YgjMwlb+ZAb5QvD+IV2jJQk1w7eH+oeU0DiR4kjeSzKqIqWSHWdCtFOPbbmM6xNlMHUI6A0Y2a2+lnfJrcy5bIUZq+NxczWXi7L+embRQCZkb9tRxdN3T954a+aJkkQkqqWba+R71Ll1pDQ/9uDJS0gQ01xk5m9W8TgrFTMAJ3+7KuHs6HnuxgtqVinA19HNyllWQiTqrl2sTVhF9z8PZI8+iOU7NC3GXF0yYPVTYMi5Y2I9OiGnyr/5fke9vZvvV1p3u6h8n3kMZeyEiaWyo8zAj4fziLDecdxUJjO3DKpL3KV960s/fVD1S/FQfVJ37cOYcFhEPMaB28PNNL4bjG4CzvmroMlOCOMRrqu5VKJBDrhWAcwzxD2akFAdBlVOkBjZ0+4eFM0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B/dqSej8T5MDEIAS2p+RhK0SXG5w8QE6gHY0O3OXk9vacRBHW6+BMweYgsis?=
 =?us-ascii?Q?/IAkvYT4E8/cyg3TM9giecMw97zj4mcKSITql8elaydwdqkomA+ziqsnD2/x?=
 =?us-ascii?Q?oos4KhREoE7mxfpegO7jlg4BYB5MzxMEsW5gwM7B4AoXLa3NSd2CKIrrBMi3?=
 =?us-ascii?Q?5taAUz3QZjgF2c+sPqKiQ/zC1bQtlS5F4zX91MDxDooR2gz2DSI6QBuGb4r3?=
 =?us-ascii?Q?ukALVbaZ5vkqqYNe06hDzTz4tOdqyoNlAYar0Wc3EZA8l09fup4mrrkHkXAN?=
 =?us-ascii?Q?aTPjg8iKq2nBKCflJ3IHF0WQRpfnHmEYPAYBK6+P3h3nam6ktmpW/KA2LMun?=
 =?us-ascii?Q?SMRwIM7hICS+4FguAZkfo3W8LVxFB6UZoot0XH/ttNF2zRjQ8bpw5YhNkRtN?=
 =?us-ascii?Q?Mn4cJCoZWkLnWJ+UJPLPXUIJrjQ75ILfxlmFDpCJkaTq1Jy9yGW1rdE2JqxN?=
 =?us-ascii?Q?NWrXW5W3oMcvvNlI+R9YFfglTnCNpGnzaEX4O3SUKr6xmN7ck9WS2DlS0+9V?=
 =?us-ascii?Q?/y7XojjOSnCx+ucAxklV+Spfvzan0fqrBb3Y0Z9QL7sxEdWDiW5NtylpJwUE?=
 =?us-ascii?Q?1O22aR40UO1vQcjoP/RuEKwGiBvILWYuXM/UvHUD+I+q79bocaDZ0W/qXOLR?=
 =?us-ascii?Q?4zMIin1HLaGj/mLI0y/SEOeDSaCskqaEqRoKYqYSPakzL8Zv7w4rJa27P/7G?=
 =?us-ascii?Q?iiNvM+Tk0cER3lMKOU9cANG3rH1S16FlLzJRJbu/w9oYCQHpxFnl2XSFFIZ2?=
 =?us-ascii?Q?hiw0UJsmip0y+1RKvGhbWKbI+LQ22fkK+qIAwt2CGnbLmPYh3DsbGzdYY2cY?=
 =?us-ascii?Q?NZvA4lH12Q5nAtAbfgKxq4Oyt+KSJk1iTvZWYzLzpKAhPjam7FcrrjgQIJ9X?=
 =?us-ascii?Q?lywm47uA4dNEM0WlVTKK4XcOBx65PIMAcMT8bc6VpPkjuSFOByhYV5APsANw?=
 =?us-ascii?Q?h7dLG7+NniebvZcHWmUOirFtzA2XIV2Rw25WSgLNP50NbGavo5puuRnH6UxV?=
 =?us-ascii?Q?d9OVdkCP2pOBWPGmyKaiFj1765h7UtWlblqoNtvvFdWcVb0VIiPbrFoPab+7?=
 =?us-ascii?Q?DjuYeZAgml6/N+kUMi9m1DOft6fj3ct1LhcG0vB6AexqnWkCU8NikFuj/Ynx?=
 =?us-ascii?Q?aQ430PixWbwcoe0eyUsVOd5eVfniLuFRyctDQ/FXWSppdsmRcCTnmnhS4h54?=
 =?us-ascii?Q?X0Av7JnRXJdHaH2NgYei3AS3ZST/Cz8N+04aq2znQUOSWgFWePspOLk2Xm69?=
 =?us-ascii?Q?W8a3urmbkivjAzJUhl+8owoFzaYv34GzOphs046MQqTznGLYW7cicK3gbOiD?=
 =?us-ascii?Q?6nhFHvHmB0FfhFfHUgfZq/jyA6jZOOp0DRZUAtFHJVaiZhhd0OLKCITbJk9T?=
 =?us-ascii?Q?3cxmdaWq8s9O+BTrGHCzFiH/jCnNCZ6UGbsPQq4ALy1OBKVCVpR7/DKqGujq?=
 =?us-ascii?Q?e1o4K0oJWt4Kwn0Ql617bCrgBKNu56zu3t42+Bda/GlBQy6oVpyevHyVUX8h?=
 =?us-ascii?Q?Uy/knMU13HDPR8GK3HZWyMQZ9AxLA6VawBK6/KhWcB2WqdF7cLscfIT28sVC?=
 =?us-ascii?Q?xeb3BAoOj4bnNHHBJh6dq0LqMfEAoXVGwhJFc/Ts0Qggw1CMYnSLZsFyoinm?=
 =?us-ascii?Q?9R25rcGUiTjSKSZI1/6heWg+fXHfCTNlEKefU9ty7ISrkB2EavOSqMabgB/9?=
 =?us-ascii?Q?qBbicNziSTKjLXnLNYpbqGKNt0JF/PsdXaMdNGG1v57YwEWKz6L6146iNgmL?=
 =?us-ascii?Q?MVV+JK/B9zjjU/LWsRa+m8l3qo12iJ4=3D?=
X-Exchange-RoutingPolicyChecked:
	FlU/QMSdJpxIC049Jn0CjdLUwE+WMKgrrR9nDNYwqUAHvCMLvf+mIjZRcI0kBwV2bakbPqngGd8Y+o0LksvoNKwLcDhTFluxWSvU3522Hcl7Voce8/haupd0PXcxDU5c7bmBkApQ59Efg0OMf/UTqaQtMBur8VpbMay5CJagLa1GfmZwlvP5hAvruTP/H0/QZZ1HdufaHSrIzl4qU4niz4bSFbdFoklRT/h6215HRME92B619piaLsX0LfRN6FkgRSzcWKkaWBjjNw5CpWRWTEU06NSb2ub6/qiDIr7Zx9mbkyOYMNv3y38je4zydMHDCbmKJcMA4U7BIoY2M9iYIQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uKmdX/7meaCK72gy4kwueGuI62g5vAMLjyZol7f2ez0VWGISn5DFtjJpSiqa/Y735k9zXS5IwN0bZrcv9d9mdXbrv6Qa/W9h2/X0X5jFglUbMRl6gEWajq5zeGzEM1lPKLWxHoV2oUHKsNwZCJkyIDQRIaGKt6xBc6FM7AiLKF/p+WC4p5z1zeuzauDy9xT2OFgtrtgPywXF64pgFJ1xip/VsJlpH/QTmjMhTqG5lpaIXwOK1TdbnC02cHmQ1qZ2XT6eJglTio0ZxC6tMfzYqwu9f4DaFuGI3UtWqMSDfzaKivuyhwNYI+WdUNgrgURTMZpOMAj++mg+260mpwnha81YXgBUKCeTNnN/6PJNFFfbavqAjyIEuiJIujsMlEIypIjFYktvGISiUf3abB2zUSEq48BLoW2tC0LsrjKes1hjmI49HHw0UTlb9zg3R2hkZrfgX9T/shiTdZF0wtEh6CeQrnbUTkKkgvnv/8Kd9tcqDZ9KpHigyiAvGQrRH1PkB9/B0WHpdzUVifBGZcL24CYG79XNqb2Y4mrF6rivjbMnaMT5vu9frtZPe8cuJKNRfMv6TUd7FXk3lzKMNEGL8SSahV/Y12ny3obZBjxOYts=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 762f4469-b665-4f6a-d22b-08de95e134ad
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 02:39:21.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/uRW8xxU7d7NB+wnscDDkP75x3Mc61CmgHRfBQjdLhcaE9fDM9KTloQ49SY1bF0BOrTl8yAveyd8bxOirIZDJH3BX1paxIBsYZUoIb+RWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFBEE2AA13E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxlogscore=674 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAyMyBTYWx0ZWRfX9cfrB8/9+JJz
 vrCLJyrc2CJ3gzs0xIVguG5Radk/Lr8UoCRqCnWz58uMDnK85dr1CGKDi7/bsoHH2VsXKNw8YKs
 XOr2d//7SZzZhlNPpP7SQH5QmMoAvBEueVS3z3S8f0bbX4xceW3N5pwmVVfEos+Eq+vjQ/DjWTG
 g+58YF/iyECkQw4b3cZbhAuen2WGCz6WJ7GwRnlC1/a3r5/qk/IM9RCR5T43+xILN14JjXmAS5Z
 eG7h1shl1McikLCs2QLkChE0C2V8qEzAdFPCa3KH6eBlQBVbP/sWdBrEo9xZjECqeHbttxymaCf
 oABSWHCOfJ/CcKZ4mEoI+GatrAsUlV8eLDZbmCNGtashwlgYiMusXDZmupfjG8c+IFzk99s/Z3/
 taRSU83yvCZivO3zSSvmGSlZcl+P0M9uqfQcAjL2o23tv/GxXX21khLh+GVbCBN30Pu3uB3XqSF
 zVlsNBxdNzAC94wZISBOSxIVKfQpil70JuwIrcgQ=
X-Proofpoint-GUID: WvcZIKQhXjsTfQoMQWyojxu-1OpG6bcE
X-Authority-Analysis: v=2.4 cv=Oux/DS/t c=1 sm=1 tr=0 ts=69d7115e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=6gItoEMkhOOZMK_oc2wA:9 cc=ntf awl=host:12292
X-Proofpoint-ORIG-GUID: WvcZIKQhXjsTfQoMQWyojxu-1OpG6bcE


Stefan,

> The PERSISTENT RESERVE OUT command's PREEMPT service action provides
> two different functions: 1. preempting persistent reservations and 2.
> removing registrations. In the latter case the spec says:

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
