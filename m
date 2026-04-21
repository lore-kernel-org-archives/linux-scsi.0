Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E0D3BB5A;
	Tue, 21 Apr 2026 02:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776737359; cv=fail; b=UdpR8pE0Y2ffmSL4xgeGeioZP/kqbyZUKv7O0XDwkxA3ef047LJ5HgRTP3Va0F5y19zHIZn/4RvmPfkhcvANxEWx55eM+XDS8MLiKQ9GK5S7vufgPyDnxKgm/eF+b4l8/9g7mo77BbueVHiMcsgS0duYanJ9HBglNoEqm6ytEBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776737359; c=relaxed/simple;
	bh=YJMRFqEwSGPeKGLJ8BtsEwR0Am9x9Ad3PUSWaHkOxIE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WpYF9JL4NxRNqbVF+Hymb2bw7nVKQnzKkPVIjqhVhWHSXn6IJb6y20F1Dx2FNcRZbOXTiODAI08F+azZ3ltZBPZxVpI6Jjw8IH2+Jykmjo4s5Do/IUlSRZEvw6Fvs1/jmdkqDcHzB63LAYBVU1OTdw4sQ6IbrSN57PLitCtigvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o8NMC9Rv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bcwZnTSv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o8NMC9Rv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bcwZnTSv"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLuGM8449341;
	Tue, 21 Apr 2026 02:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=axGX/jm2BBNtwYVbmB
	ez2M+LU5YL9pUEHx/eAmraBHk=; b=o8NMC9RvDrJ74khvof/IXDx4gNNsfo9+Y8
	6AsMIqApvXHYZ3NZ6hEFtzY94s8SqoyDvogO3n52BQ2XxmEIir6Ekepe9dOmCeFd
	OVp5idhpLPJgMaURAcw69yj94BY2dW8XhMogjslL32LX/cY634p7tcLlEahX+hAS
	VfJ07O3HbBFMvV+Gkzcq5Yp8sSjU/KV9Kzq93qNv+mna3sNxIxzatdRla1TjSvTb
	z4b/y3yoFFHZ0ygfD4v6nCRYBFVb0UQyF/x54RLkGHnGJ8poU5l8RDJbi5oLWJBU
	h+sUQnGNes/BjsxcEaPqiTp3h5sfpUGrlY4BsZonn6PYtoUCB+hQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2cg4ftd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:08:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L26Kx7002722;
	Tue, 21 Apr 2026 02:08:50 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013027.outbound.protection.outlook.com [40.93.196.27])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn176xe4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:08:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jxVuZBzfjnXPxTdW2RESJ/EDXAFllcQgPoT4wYCjzyMatyaK+q1gvX1jnk/hZFqdGB0jFpC4O8KoziH9gDMN6njZKpAQaWfz58Jzdu7NVD2fAJswpOaWjq7Ln4LSQrEbvFFw4hVxQRjehQnbitAo9E73s5OtTWzOUsApcA/otXC+m52U6rYKJPIOakLdlYb6wGH46zD4gJ+syS8KSRjEcc0hg5vylKIXus9rRiAkpl59ujsHK5kH2D9cdTKx3V8Noyb4WRsmdJNa0PJAsHZm4QnzCeztazLrPjes3W07MpWUJMndKhVnMqu1Uf+EsGi69zb4HVyE9f+ifbsCYY69kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axGX/jm2BBNtwYVbmBez2M+LU5YL9pUEHx/eAmraBHk=;
 b=bHmU/BsJPZJqod/T7sO/KUyhey3F3YfedVWEHWoAb2hMAMvKPd8/Q3Ci/h1uTifcgCT+sWrJqn7i25TL9GSBpAwANLVt+8b41PIco9/5PvNeQKxeXNJaWBIwQZU0iVaZlK3w/k5gat1gML4GBwYxdLkqUznQBVKz2mRwo7YzaNo30RquCHIAWfzYqeyzdfzb0m2RKH9incIbn2pc2vGcvw8TLE0TK11w7X14LcXc6jWVtYodvrOSNw8koxoB42cqSD2X0gjkqOrzXTAvS3hzmvdVZjeH1v508JAbqib9xX5XWmEagj+yQrIGnk4eULZ9AF6ccaSdqhYeBRYSyTT2Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axGX/jm2BBNtwYVbmBez2M+LU5YL9pUEHx/eAmraBHk=;
 b=bcwZnTSvsLjvBTyGGVMR4ziITIE7MvZgJFd3f1uO/9msWhNLosAjinvem1WfJK+p1rEOIh9vcNgeQh7gHP6oBiN4vVTh4Vw6QkXp9dH7HKzUYrCkLcE+tI57s9qdgMqmoK5XjQkULUhZvlp/1YdPl0agVwy00PlnQL1CtRteA6E=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6112.namprd10.prod.outlook.com (2603:10b6:8:b7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.32; Tue, 21 Apr 2026 02:08:46 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 02:08:46 +0000
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe
 <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg
 <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
        Anuj Gupta
 <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
	(Caleb Sander Mateos's message of "Fri, 17 Apr 2026 08:10:35 -0700")
Organization: Oracle Corporation
Message-ID: <yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com>
References: <20260417015732.2692434-1-csander@purestorage.com>
	<yq18qams3re.fsf@ca-mkp.ca.oracle.com>
	<CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
Date: Mon, 20 Apr 2026 22:08:44 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0113.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: cb2108d1-9948-4d0c-49c0-08de9f4aeb90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|15056099003|18096099003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PubSds6o3sfXEYnbWeEVpD+X4X3On5JEbUrucwzcA2nNrf6Cp+zBAUKX5mKHzxgrmVNfD3FncKvysIikoK0DG0c2xt4soDwHFhlbMDL1kC8UMO/qN+vB1DN5qWxE8xm91AkelLN9BXgmQOb6fzRzJrNH0+gSzggscTXJOv/lqaBOv2D9aHtuQ7FYP/zqmjerTMPMsXcb9r5wf4hKVK3xOJmZn/hq/9mnhN6k0FgJX9rWOLeGgu01htIwCEvteNCkUvW4Z3CoYOWk6pNRFdATB3Ot41XrTvWWztPpacvTOcytwFR8TUd30cCh+S49g9JiqlulWK7xZstCVhYsaswbHRkGKVQimleDm2jLlBNkdnc/TLiQz/SMRWjv5l897Ki8XQmDQmX1nprbZvN5GDfrhik4ICPvfi02q0uj2JBDD1lvwLAoL8uGQi3wLWFAYB5MXliZoKiNjkudPQnqomZOy9/aRiI5S5Sk5PmpW4ZaO2kNTotZPWd1MsVvMqSBeEvdskAIf7mdGJrzlSWpkrfINHlBBLucKzc7jZ1Ni/vZm9GFjDGs8HT2FQn6EyppSXZK0/rvNLW5LW7aSsoc0oIhYVngs3JHAkGxve9Gkrsax30vpVgqPk2ujmn3b/gTSnM71B5G0XMK4bzDZwjsIwJhzIC4/E4g+Ta21JsSgaxMZv41hIW6olIHikUlS27Mv+g3JMNXOca+Y/rPcELxEXoax85LXMr4boI0mNlz4yqETwU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(15056099003)(18096099003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EE20Cu49cLokjFhp69JCd/M42m3uTUUq+490Lwdd1CSqXtyqZ5Dv4tb5hGw3?=
 =?us-ascii?Q?3zfCahtx7w7g9/e2kOq4Z2lV0f5nle0xF5u8XzOIMOTlOFR7IKmQc6UbQKMW?=
 =?us-ascii?Q?36FHIOmYPYYchm4vHcuvfd2c/XyLeNnu2HuSSmfDFb7Y+MFbZsoLIKSbOA2J?=
 =?us-ascii?Q?XHZklFDIuHuhkzr0PDlYcTITebN8lwwKjbxmiavIZidXvvCjTi9H3hrfp03z?=
 =?us-ascii?Q?1BFzNnAPaJF5brQvw8jBefPSVJ65Di7iW0VMjmbE6OZpkFN4Pzs159G6ANnz?=
 =?us-ascii?Q?b/lq02e30doCrzytRjMm/6CuZf60lSk7/pXiNh1ixpf3Am0gOXzEganUGLTY?=
 =?us-ascii?Q?PvkcNWcRq0tqfmafkOvTKr4BbkZxyQNTrzgLQGScWR1VWKYX/9EE5TXBsRo5?=
 =?us-ascii?Q?ATB3VCGgD4rz46jS3ZAwsfo7jb8Kizw6DKBECDfQ32VXAw8fZIqDoJ5J4iK0?=
 =?us-ascii?Q?aCSj0dRLdGIUqQk1lVfJ415nHkKnypgNobwXO8c3A1Rk/payOfvetUaQNr8Q?=
 =?us-ascii?Q?/cAStNImWlUf9fhYXkenOUQrGQhabNpprd8BcSs6m3kXwQ4mjvf1xm+nnIG8?=
 =?us-ascii?Q?IFyE0FXTwmhP/PnUvIWCO/rs7A97WehTz0EcINkPbWA58rkPbPOwWWMkbXED?=
 =?us-ascii?Q?+05d1SAcFlrdcqYj+tm/eptPTtPfbMBOL2QrfSUSfvFhSMZy1FX0FGUEETOj?=
 =?us-ascii?Q?YVwE+1SFbFBdf1u1qYTdW+BANFmX+mAGcXl8BDtt1hpyPZpiPJeZyc8J7Wgt?=
 =?us-ascii?Q?N4sIY2LXcrSOb+80wko0x+RrJ0rjcLdx7pTyVsa+TtQLCfb4oU30/kOnxPOn?=
 =?us-ascii?Q?7SoQbRP52ACOikOfhYd5/oRlVrKXT2C+h2t7lqldWlxZ5cQKLrKz2U76FfV0?=
 =?us-ascii?Q?ZLOd0sIpa6Rn1w/ushXdcogKQKXgReZSD8cDuzw4VvcsgbWtzjINgCjrtGsv?=
 =?us-ascii?Q?omNtNXKyQFTmV84ewANY8HutSPYZSiSY4OolM+4ogmZt3AOIEnbP3cP1LwEI?=
 =?us-ascii?Q?97wGaisGVW0dS9qMMGp7gGjh7AQ5oC31po6uOsadHyjwqkCRqDQ3OSW6wtSI?=
 =?us-ascii?Q?FlGkt54+eICAxsU2l8ZixvR4D9DhyG2CnphxUheb2i9RADy2Jw3+lQw8VZDZ?=
 =?us-ascii?Q?pqK9pPjxh3sm5LZB00SPUvpaCdn2WraWAiQF3V0OahPluvpHlx6JQqyyiAWy?=
 =?us-ascii?Q?DoaVyLKTsD1ViluYyssjjO5RQ9nfKmV/FMkO9wXR0eNYUXEuoUG6SUUmZimd?=
 =?us-ascii?Q?4QhnPc7VriiR2uljCNo1PcQLm3eu2ML9x41crDOTx++/uiLfJQk1o390oHv5?=
 =?us-ascii?Q?kc24M+fAX6ic0fAPkW60AN1xd76PesLaJUL/C+mRHa/Ko2FXkuQYbYguxOUf?=
 =?us-ascii?Q?kmtTCF4Q8P3mnMtt6HRXIPQIEhOGcs2K3zx2eI5L0PL1Jj3tRkgREXfP/+g8?=
 =?us-ascii?Q?yoJlvC+hLzybWkdD4LKhO9mJ8vgcJMTb4XTE2srW9em9ns8pnqjBPVc52+aK?=
 =?us-ascii?Q?RpHQdcY8BjFTNsJSEq04MtKnmejpP+IWhF2EiinG0zAi9tTJEBtMbvyF27vN?=
 =?us-ascii?Q?0XeZ7ZTDPJ54V+RXodDWijIh3965Ju7cxRcEKyOyyN0rsYm/OKWMZ2hh4gPr?=
 =?us-ascii?Q?AEdrOKpYcCl0eve56GwRyLHbn4VQZHQ55lWtDLTKgeUltw64TSVnKpMORwYc?=
 =?us-ascii?Q?RHKtsaIL0kMoZTA9mjOn4PGd0ZMiHCEvZaN+SxfQ10btICoi95St0iyC7kLL?=
 =?us-ascii?Q?D4dL6IiR4vif/QFykYHFLZx+3o1sBLo=3D?=
X-Exchange-RoutingPolicyChecked:
	DUg+8HR8zL0a2rsbH/uPh4ELIxjfTTEKTYK6bEFyCyl0+dvJiwtjMnycTtJxrwOn+N6K9OkgwD0uRx5EP4ZUr5bGVSJQN/F+wGmnGMMzYewGLtGwbd+OvRBQd0Is0IYxavIcXQxMm3nlzlhjNw24dQGUHi2SNZkOvSCiUvOi6xdCCwuoL63gs7VFa4LmRFJQjRA7zMttSUgB4hafckccswYwfzoRgsgyoqvhYf6SGWdIjLaGo1v1LXdIPiP/nvCYtu20U8zOjMOs0vSZIaUCNCwOtFDTBo2p+g8u2q/N6rAuPqMknccu7GCf/d9CX0eVKOCY8/U0gPLC489f6IsC6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qs55IDbyzif0+RvQdG4rT0zWdxX7rljQRmVKjew/J4CNQ/pmN3fZrDvnQksdKGIQyfKLI6GLVXTTW7V8gpXbxKH/jiDh7Lc0Ch3r3XnqBwvmTeyh8iztIovoBvpwZTXXrJHGU0JH4TIFQtT0aw+eazp2xibDBMvQuuLueEQbUaHn783tmEOTFqiXWCsRCswqaho7c6b+r5txT5SCbVvcD7brbQxxLX0d9yU9YH6dS28EeXFvIePdNL1ivifoF2XT88NCQwdqSDf1y5tYgFO8Wps3px/tfp82gm1XIWxe0kHUJfxfGfMQaHnoNgwAdWOdgwwHr/j0sLWmg0Ys/tFKpRQFK2t6bpSy7I6geFYX7InxC9sj+g4IazLdQu6KRJMDSMY3vbIKBt+8BblYm3cJBARQAEBBf3EYhRLEs6SoddJd98cPVOM1pbnJMsQcaNR1UTj2FvalajaboNVnzxUS3dR1Bm78g0D+BTgGSBhh4QMNofJ3oK1HbgOSbzpDIdQh/6mMLTAIDoCKMtQ06YnxtOO0pFdN+PVkbTmYm9cSKco3RikuulPbbN37vP3oBKIwFRdLVPi+BN8a/NEiKZTnzJM1ekCx1NstuTR/J/rqlFE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb2108d1-9948-4d0c-49c0-08de9f4aeb90
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 02:08:46.4643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/E9PeDKNNxo2Aj/LxnGlQNVv/RbLv5mfMWODCji/BZQNNo66f19FdV/87pBhicN2lmvH68fCHWwGjWTk1+5XD9sdASv9Auwe/4d+mYuKvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6112
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_05,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604210019
X-Authority-Analysis: v=2.4 cv=F9FnsKhN c=1 sm=1 tr=0 ts=69e6dc33 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=QCuCZn1sAYtNoLXJA_UA:9
X-Proofpoint-ORIG-GUID: dduMPulXVewORYTeL36FbJlcE3oRkbhm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDAxOSBTYWx0ZWRfXxDhm9nXbU0bV
 7LVvdLpM+z0nQh49/jPUOzVbUGPg6QKNfub7nAtzqFgjRMAUNk+kmhy/ocd0R151HYwrrDNxwGs
 z1PHy4Lfsa3qKnk1x4q9rEIJCYbIMdEoq/FQ8/wO4su5HtQr55RjjHWRR19EFnS8GAEiqWvRBnc
 do46yDSWBuZUCLsGbjoSMlbzuYOuF0Mc+SPP6ZKeLenVyXygJ5pAx34xAhEjC3R2EgRcH8iz64Q
 SUeYWM92o3nNjKAjmwXJS8GScy7i1IJtNZ7VAHfgoY/7b/M5BdWQIaR26XBFW9f976LOuOCGcpI
 2P0sLlboqhcdTcSIvmJ1SOBf7AagSq855i9nM+InOXtr5/++1LUB1UKTVcWJFWrfr6e4YSwhjgj
 SnM8mDW89/lYZiBZun++imrKpykHDu66S63Xn5L3qi/4CJx9dMCZFIK+XOppRlgwN5B4jMNshJI
 UwEnW/gaw/CY1fZZ+cA==
X-Proofpoint-GUID: dduMPulXVewORYTeL36FbJlcE3oRkbhm


Hi Caleb!

> NVM Command Set specification 1.1 section 5.3.3 requires the reference
> tag to increment by 1 per logical block, so that seems to determine
> the increment unit:

SCSI allows PI to be interleaved at intervals smaller than the logical
block size. This was done for PI compatibility in mixed environments
with both 512[en] and 4Kn disks. Interleaving allows 8 bytes of PI per
512 bytes of data on devices using 4 KB logical blocks. That is the
reason why we use the term "integrity interval" instead of assuming
logical block size.

> The ref tag used for a particular block needs to be consistent. And
> since reftag(block N) can be computed as the reftag(M) + N - M if
> block N is accessed as part of an I/O that begins at block M, the
> function must be of the form reftag(block N) = N + c for some constant
> c. Thus, the ref tag seed needs to be computed in units of logical
> blocks (integrity intervals); no other unit (e.g. 512-byte sectors)
> works.

Whoever attaches the PI decides on the seed value. In the case of the
block layer it made sense to use block layer sector number since that
value is inevitably going to be the same for a future read.

Note that with MD, DM, and partitioning in the mix, the sector number
seen by whoever submits the I/O is going to be different from the LBAs
on the target devices which eventually receive the I/O. Nobody says
there is a computable constant offset. Think scattered LVM extent
allocations. Or RAID stripes placed at mismatched LBA offsets.

> To see the issue with the current approach, consider an example
> accessing LBA 1 on a device with a 4 KB block size. If the block is
> written as part of a write that begins at LBA 0, its ref tag in the
> generated PI will be 1 (sector 0 + 1 integrity interval). If it's
> later read by a read starting at LBA 1, its expected ref tag will be 8
> (sector 8 + 0 integrity intervals), and the auto-integrity code will
> fail the read due to a reftag mismatch.

Something is broken, then. Because the ref tag in the received PI should
have been remapped to start at 8 in that case.

> I agree, the seed doesn't need to match the final LBA, but it does
> need to be in *units* of logical blocks, plus some constant offset.

Your concept of "unit" still sends the wrong message. The seed is an
integer value used to initialize a counter or hardware register. The
seed only has meaning to whichever entity submits the I/O. To everything
else it is a value used for remapping ref tags from the I/O submitter's
point of view to whichever interpretation is mandated by the storage
hardware's PI format.

> With a ublk device. It should affect any block device that supports
> integrity and has a logical block size > 512.

It sounds like the seed value is set incorrectly for reads in your
configuration.

-- 
Martin K. Petersen
