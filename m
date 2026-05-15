Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC971387363;
	Fri, 15 May 2026 02:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778811056; cv=fail; b=MH9bYsWqoFiAkgDNop6Ea04rzqpUqfBweowwtlziDS7cubpgfc3opvrvjd2E8aO5qLctsq7FMFUoN21E7dXxZ/VLkXBkkrp3gnrCAiRIPDc0cPgljCpMWKB3MivbRp6tmZN+ju1YZ9o7jFxnV5gavTnlfXIFMZwWO5L1lL3/2ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778811056; c=relaxed/simple;
	bh=tLUiIdklj1BlEGA/UNp6TeateBCn4gT6gdZoMlAQ67g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tASQAsYoX0cY8k5ZdM2Cn3R3Rv2PL/rz080RJjSxZHN4Ps3rMs0otkJIWAtQcOhxg14dfO1t1zjviniGZPOrpgn0e+oY5Ndbj/pD+Xn0iHqtadO011X+rSG1vO+MJPvwIz8EZ3jNHglDbdguWyOfHRxBhwNyd0vYGNV0/nFwK7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AfRzscmE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J10tAF8M; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AfRzscmE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J10tAF8M"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0T9SO2807207;
	Fri, 15 May 2026 02:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DaO8JPy1ufGA+H2li1
	5dH03TP97Nsow/pOW4/Ge57HY=; b=AfRzscmEMP/CftPgGyiWlp3h7pRDLggudl
	fbpYpBF+jLLKoA2WJAy8XhdS/oGVrvfrnqlCKar8qGcQQk1XqfGbF+dhU5a5e1Zb
	wEpaN+LZGmmT/0tkvTpnNDxTzIJUHM6XUpoluDTQrsAxfSbNuWgzNyffIcsJTg69
	eYtlZ+7AKjTydR3Ynvdfo16irz5/BBHTK+LsTrikjIgTCQ/iJGPto62ix2/8JeOY
	DDZfuIK8MJZ398eO5uC+FXFRR3a4nEcz1/QPrdp/soOOENfUNX5ivz2FPuZE/EhK
	MNhodvj+Abb6xcozllPql2EIyvQNFN6p+o/UAHV66RRRcOlGFHAw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m208dn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:10:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F29hBS018200;
	Fri, 15 May 2026 02:10:49 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kw0cprp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:10:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cAIkOJjZEepEjwIg1n039v186sWwAI/3PGIhtddK+SKqqCpzacNUybDKsJ5zte6aEjnXDaiQgNb2IG32JzA7anj+XREfHQ8r2SnKDldas+2ly8MeFGcw0+lnKokpJYc+2UYil4TZjl2MF33Lwj/82uMmj66OLZ9jdIRWXqUCf9nEGwlDPAvcjOr+LIgPiYN3BXPy//lHxUFB7dluMkES/FJKSGqtJ0nlQO9D/rOZsXv7LCOcrt7JHl9PgRokD84Bb76aPArtwWoVJrFbZiUIHw/VCZ2NBtYFsXmnjtTLDDqUu1MrlRaWhuK/9qLSZAyB5m3U6DmfUTyohOMW1aTm4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaO8JPy1ufGA+H2li15dH03TP97Nsow/pOW4/Ge57HY=;
 b=xSmt4y1IjzayAVJVT+K2UUWbB9T5HndgILGmWZX5mJpvc4sM8dNeuSMIb9OHXMHdbFgH9nY/8wwZNWS88d2eWK+UMod/GU2/FAsAiF4VckQ1CwOVuGGR007AeDWvSO2jYNQG5fGXpz4hDJoz+mKDW/xq3MAtGEQLEeY+DmNMktu2qUByrBMXkWoMSkykNw8QOq19Wj/exqGs9weGrqnmvLbWuLKEGg+TOl3LrpQnxDWnvCe0dBO2ALWJIsicR5JQKM8xRMjkZ/sKy1bhAQqXYDsj+0VcMi8cKxSnS9W6q2gCQbOxGKjVAiyG0Q4fb90FRdVNfJkOULYYyKgXElFunw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaO8JPy1ufGA+H2li15dH03TP97Nsow/pOW4/Ge57HY=;
 b=J10tAF8MZU6caaqL1QY1CucvKEugJCzSIEIMVlLoxgyKyKaq71QTErXJT9AIZ2NYPWLV9svTsHk0SvAAkurkDFhhko3mhBkgwXH62lQpgntLfs+jJKrEeI6MwZVXjnj6PHaul6mVgA4FPu4Q6MzcQ55j/QV7P2WhPbIyhF/oV70=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 02:10:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 02:10:44 +0000
To: Sagar Biradar <sagar.biradar@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>,
        "Brian King" <brking@linux.vnet.ibm.com>,
        Don
 Brace <don.brace@microchip.com>,
        "Raja VS" <raja.vs@microchip.com>,
        Kumar Meiyappan <kumar.meiyappan@microchip.com>,
        Abhinav Kuchibhotla
 <abhinav.kuchibhotla@microchip.com>,
        Uday kumar Bagam
 <udaykumar.bagam@microchip.com>,
        Advait Churi
 <advait.churi@microchip.com>
Subject: Re: [PATCH] scsi: pm8001: reject non-fatal dump when controller is
 crashed
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260416154650.415624-1-sagar.biradar@microchip.com> (Sagar
	Biradar's message of "Thu, 16 Apr 2026 15:46:50 +0000")
Organization: Oracle Corporation
Message-ID: <yq133zt5soc.fsf@ca-mkp.ca.oracle.com>
References: <20260416154650.415624-1-sagar.biradar@microchip.com>
Date: Thu, 14 May 2026 22:10:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c8bab1-910a-44c2-2a57-08deb2272c09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	d1fUpj3dxKAWcveSYUGaNGyN/Tkr2ffdkwGQwRmbwwq0728IK3b8WhV/Kpb5vpsVwOVm1hmqf68RFlgVT9sTN5qFyVdjVTPTWwk2pb9Ff1NjqzGm+LIfCo4SbHcTz2LUsKT5zZFaH0J3vfu3Fu/xlENW3unlop43CLF5OM0zZEfyTEwV6ONQCJRPVOD+r30Hb+ikOHvY6lBSxx3SvPd9Z1jVeWY1qrNxfeAD/O54h6FLOe9l+Z4j6bNAZFkhRfzSwUVJME4HfQsOk3tkdbvTY+H3JIFd49WgkvWZIH5nLoSg1EGWyc+Tj5OrqNQd+Pr/rZFUI0NsA+cgyD5A94YsrRnwkCoI3NmSR+WvWoL5HojrVPkitIy5hKKM7jR6aKTJC8HGhbxdUVhCjQYMcM18DHZieD8mq8HTIE789A+yyMfyrqT/AGV0DGKC4NB3wZChQlTwy2hOBRz74mV650SOaaOdymxUhF1CEvjc/COZYMkgOe20cH7LXK3DM3TGgB2txsOVuBcj9aM3w/gzHdzFoEuDANpjBnzTxSXk86jho6SPnYLou2ZYC4UCIe7dJ5+5KXc2u6YjStXeegfwRJmxvUtJtrJv1v4T0pzJcGf4Tycdzjdp0KswFCr3D2IxwuptBX9KtxQTdcle7r3JDfPiwJevc3FjQcRwwB3I/ZvHh5Hdu2UHnzLPIrqTZpzdyXKd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6v9li+jnus37wFaw2gLHPuuVnsOtrPYqqG9CR1GZ+O8Le6JC+pX52DHxlu9U?=
 =?us-ascii?Q?Vuayw0W/Ri+zVTdtipUunANlcT7JK3e6HcY0mV3jyQhJwtrc/I7ZJrEoOu/b?=
 =?us-ascii?Q?DBVPpHbIj4YoyWG3lKHT1HQ8ZhB4d2/kZHJ3SmtO8weFjMbVi47vyLpUTUCX?=
 =?us-ascii?Q?HNEjIvV393IfVHMpKO8AZO5Gm+KQgPSwKjKmkP4H2DFgoXRbMZOurEuoYWsZ?=
 =?us-ascii?Q?sXiu8ZMZgldh5qwQagL0QeistGFXc7KVirrgQpqdgkfO8ZFVf1Ovv2MbTSS8?=
 =?us-ascii?Q?mHWSOeDkdzaRqXcJKuABBW1cs95RBrVNWkN/txVfa/l9j0xQjUkDJT2hR30K?=
 =?us-ascii?Q?zb+5EvmoLMQHjgWWHq0U36ZP6kMUbq5wni410QqWtuzLcYXbUw5OEWbvKtbN?=
 =?us-ascii?Q?FE+iHDMv9Tg+FR71KFirqe9t863IILlRRO3v9fs68hNsYl3WBlO4RzqS11Nw?=
 =?us-ascii?Q?FpHrA/vTZz85kaDWTDz34OuEwqtw/a013BsqZoF5GRWn/phdG1qCZJJCUQew?=
 =?us-ascii?Q?ttOoomD5VcYcV07lOCH6MiY3Uhlhx0SklazkREUNulskj1QSWvXUfnYRA7A0?=
 =?us-ascii?Q?4t9rWeoL8DziJHaAxTDENqhc9kzmIxvz+GCoRtoaGP9pja6XTWHWPs/KARkZ?=
 =?us-ascii?Q?3qOIvvKW0IIjEmhX2ixyEjD9XnuscgXT87tHavrnFmRBX28//83NLylGYhKl?=
 =?us-ascii?Q?RiORH5Wbwp+eB7EJvkcciQIF5VY9Ui9OSYQraUp36Gsky6eZusAkH13jYomC?=
 =?us-ascii?Q?Dl3h9TXCHUkvv45suCuPXGSlDaDsQOblzwosH9HooxNOgnrr/NtqRFjH8f8i?=
 =?us-ascii?Q?B2hXTa0p9L5/Cce71UOuen35r4ZT4bTPe8gXOv7m/AqGrDEkpGhBT8L/5qxY?=
 =?us-ascii?Q?VHVpdMSnYxE6MsWUBUuIjjXB5OBqqwhVM25K/urxPC+HhBxa6Q1zPc+vi7lB?=
 =?us-ascii?Q?dGrInemtNKxitlscrxxleqK4vXuB29EULgvl97f20ACJPVoo1O4KMhDibRbZ?=
 =?us-ascii?Q?nVPT1GZ/sLMFORD065bJxTVUVhydGWyJdoeXYqF/INxbruFamSvXuADw5ojr?=
 =?us-ascii?Q?7zEE1vq43z8N6DAHqKCMWiUvBnKOicY/uCDDzAsfKA0YPapeU7mF8UlqClqg?=
 =?us-ascii?Q?sle1JHK9bfLLaT5sQiV0fxaeYoK7pb5cBRx76jy12A77/B1BZhl1EgvXN/LR?=
 =?us-ascii?Q?4e3Z0LxB17vSoRoR19YJcVzkKc4ML95whi9KF8bJtqCEpvkLbKI1Qu0O4aSF?=
 =?us-ascii?Q?6uX6cwvmsBiePZJG9XmqX3ZeKrbg5wtwkfcDFPA8R2EHM6zHyv5kd1VJ0ygD?=
 =?us-ascii?Q?707jzseiXeau0BRZ7+di9bOtsB7b+zH5wwiW1FVzB5lZf2NcGYRVgc78r9w/?=
 =?us-ascii?Q?5L/hydLpjt/ibvtMJPLpmvUbraOU3fenIuxoXqPORrgH8OIpCeTxPCwR/Ce1?=
 =?us-ascii?Q?uZwMyEN9aWeXgGZpoxTUfQjte3Uew9/1IKFrw+WKmoKXb3cI3mw9JJ5EW7a3?=
 =?us-ascii?Q?1O3iHToid1ScLjvj2ee3hZkgFeKojGT+gMqV7graYU/x2leC7ItaCzb9Favs?=
 =?us-ascii?Q?bhILsbPXd6/f2r0vVYfq8CiNfEL7eRVyz2ZPUFCDYde45Q6tvjjLI0y7x9AL?=
 =?us-ascii?Q?OzSvXigMCKSZprKSMNU4EfyYca7kymkijba4e91/ZpUu/M5sxAbZln+NjPtg?=
 =?us-ascii?Q?UqkNdS51Fcg1FvKl66vazkhD0Ztba5OFkOGKi2fgSgt0/0b2buGPhecwZ+J9?=
 =?us-ascii?Q?7f95x1iSxHa7dDFUo/3s3X5XfJ0meUE=3D?=
X-Exchange-RoutingPolicyChecked:
	dDW2LiLDDN7BXpr+U/g5rb4oiejMcc4pF6b5Suu+QIHT3+1XkFnLUCu12GncMra3bMT+7r2wyC7kw36FDxGa43+VsNqAWtKcVa8sWLmcw6oZ12906n5T+9nKXA6aPgwAI3i8879j6XMmWb59kj+eP52roOhoSE/OS2AYzwuYGw0xCFVBlXa9p0OVe9/yLT1s/rJKGcH4TyQTJi6dOGHaJyO7S1oBpfS5aHITn2LGg5JYZGT9NoXMFKayn5YvhD9TFGY/jJ5XwX0YhgIlPl0qHnB1125LDYe880aE7W5WCXmnfiBVAt5t2fkKtnJ86LWwLohn/BhttbiRqBvjTglr0Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JZNlj827JYMzkfvtEU0P9Ds/sBKks7WD7sO9Z+MMZow2KDPI3t6n764S9v1lF/tYS39t3YFL9hQl0lq876/wSW24pTVObx8PAXF+dGjFAsyYiYbwybJd3qFixpYR1k9a59cxoIv7wt8FWpNzZ72tKFZGMtTYtpyd12j2oGg3sj5H8sEGuG4Nq6oUBUpcFkUQYVoJrFs5JkTqaaGYHbthvAtDh1Dtxdt+m9vlr/tq0jArSoZodRaEkBy2zu5fNcE98RDWRrPsP/cXFIcnYfM7mDa6kC5jC8Ed5eCaz1Js6dIWnhmQPGJEMXz/6grhthQUU8f2O6Z4eTvc+5x57ezIs46YMzPwtzhDko417ByYoVXVQDW6xp+otzQmGVcLYxGJvXYNWOuIFafKRBp11Zj9yeN25ZnwMsM5hOdIDJ9xXJegadYrGflTPWTxO1CdJkH0exwKvcwAj3ir3DoB8ZDg+ZVExOGXq6TX37MI83VhrWqDiZrPt/vaqqtGdslVZwovoUtaC/5KC/pIvzjls22fvrB3XYpYKgqmuh0AOYo2Hcrl6w2rwI0csBcJqctgg7XekVqr6GF1AbsvADaqQ89ZETQPuAbFJ0km1pSi5g0N6yU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c8bab1-910a-44c2-2a57-08deb2272c09
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:10:44.6524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g9F1zY/yHxGrw/wTK9Af5OcIPrmg4CI2II7KnH0G9R5H9+n57yWegxecS7s0M260J35tk3hDYdIX9Sw3TIJ+fvwXI5JSFGH9XDfDIl9iNw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=905 suspectscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605150019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxOCBTYWx0ZWRfXxdcr7BPuPDgB
 kR5noGbVqEBBaxv2/xoILgfy9fzdu62DJsJDs2lD7A2dSntztmcgwLkAMuR2hjKNp0tYsss0XTr
 o26XVkDN65m147Yl49Ckj+ZsgeCuzBTgxTJkFeAFMfp988SvBZCPkQr9nshvCF7HI1WTK2zdeYg
 tasxHv5gxwaduMeSKhFTTb7NQJYAB5/5vDuLSBvDgNmHqGjVayz4CJUfXNfyiOwlkiCa+5p/5r0
 Qe5F79I4QKnpKjG+IPUc1Xuy27GiYNB2TMLYbYhQue2eZSmWB/nfanf9cwVJIDDBCHkXgLHKZGo
 cOZ/fgjURm8cdiXcjsbbdGoZpIxxD+vTRA80w0gfuaZF1t50uUKpY3dij/g/5QXP5i+i5BaCbs6
 l5Jps5paOWeCJo+5Vsu4iXkZXr0NjXVKdouZPxSjNADEf+kkA6MxoGH6LqdbY+qZ6eGrucGcpQH
 9UdxK9p99LoXI/7avOA==
X-Authority-Analysis: v=2.4 cv=T9W8ifKQ c=1 sm=1 tr=0 ts=6a0680aa cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=Qd_XJmDTjCV-o7kNHBYA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: lVZ0kPxpotzpK45JvmmrsZ-u0H2wjzbI
X-Proofpoint-ORIG-GUID: lVZ0kPxpotzpK45JvmmrsZ-u0H2wjzbI


Sagar,

> pm80xx_get_non_fatal_dump() can be called even after the controller
> has entered a fatal error state. In that case the forensic memory
> contents are not safe to access for a non-fatal dump request, and
> attempting to do so can trigger a call trace.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
