Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7175376;
	Fri, 13 Sep 2024 00:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726186859; cv=fail; b=Q4KZG3iaB90Lm6Ek/n4dwzMU5vsxDLJ7w1RslPbnXJWjdTCrsYBU5JnG1xJ6Jz8CjOeubkewT61EIxkh1AeTF8Bufs+gUqDTQa+JEqK2qYBVNKQVhGFgYSPt4XxiTsrHJ9QEuR9h6p890qKA3L+cnXDMx+GUoFERFh+1+xvxPz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726186859; c=relaxed/simple;
	bh=viFah/2otL1FHs/R93C+XSZu0MRBt4QLhWI5AzMFS68=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Id7CM3ouU+iP/rLjVisrs0gEDQi2ih+3GH+EHZcf7kjC1Y2nF1D0FrhJE35CkQovgiH/ZFW/WxZumHQYpHpngoiKLORskl2VnEikU/HYZdwNVP6TIT/HF+Hi+zLan5BQpQVoors3zSEeoDUhhggm6rZBFKosGGkeypSFzlslMCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZaVsPBZh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GJx2+zUz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZaVsPBZh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GJx2+zUz"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBW6a027786;
	Fri, 13 Sep 2024 00:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=N7TxA51pIlW21E
	twitta+ekpypnZkoIkuso4DR2RoTQ=; b=ZaVsPBZheiycCb3r1BKk0u/EsbrhBt
	h4qaacjN5aDji9wyV4XVcbd5tDAiW/i0ZNC/97F0AOkZn9QlXlXay8zCqcyEdrfN
	gyjAyQpyB362D2vRDgL2WEZoZxs77cdnCXEsbhZ24gKtQjIItY8jZTxFTIT4PkMa
	VT9B9kTjH03hVCdLCFO/OHc11nCNStm2fGODOyGzTxoSow3eCiZmjmmoa4Gkt+sm
	T+3ZY1hEsjWu7gp8IHJxO5M4QGD059Td+4TLFx5rPOkxE51gzeobnS+8Z6SErzLh
	QlTDeGgxFkLyjsBXBGVhmQ7TizM7oA5OZ48ZbMAQ+0WMgKjxVKwBtvHw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2v8mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:20:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CM9uSh019800;
	Fri, 13 Sep 2024 00:20:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9jhc41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:20:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajqvcobgGqP8OcN2EawtYB4841HAbyr9gef2iMqQKyRSKS5TkLgpryEFhmWYhNhPCqV6ptZfjFD1vCwgWUlPtdt+KluhNyqpQSi/lZ1BQ1otICsrr8zUpSGcuTASSVdWBAHtdAnhp0uP7EAJ2DwnVQdCU+wYuy5kllq4ybvQtyfbywpySGUbyCpoPK2TZELPIZ5KSdDaba0xQKvYq+DHfwEgMQW1sLRPGG+bS8xC10kgt0qe0eOpYmIsbwXRxy/SPpA2JLrNYnMQjMBzqVAxYma5Q9A1lQXrAAyR+lsOeqFJFK/DJ01CRBWNX5fQhnXIZOXN281AI2jwKeM57DiPpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N7TxA51pIlW21Etwitta+ekpypnZkoIkuso4DR2RoTQ=;
 b=nJAFja2rQAVskLWsbmGkef/mzomuPsU4vsJTJQs0OaMewCz6caOAk8rTwlHDJSHignC6BtgdhHP+izXV4EO+VccRbJshKkIY+adTXf4TR57Mf0CyhnWhCajz4Apw6l0j2S3g4HZn56oDmknkPZhpo7yRzOS9nfRfYTcEQTyjXtd/vIw4m8FYsPSSkqJ3q7E7q3uEYif9FJLPSp/En4a0v3mk5+O4v/psj3qOr7GTZry3tkOl++QG3PnCZBDvGfCPSwg19LWqMIsf6f4P9XhrSpmLKHdy2qYT++HDu8+ScZ4CTJ5cY/zKKrKhim1geuVQJf2FkF0hKUOLeqX/2cVt9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7TxA51pIlW21Etwitta+ekpypnZkoIkuso4DR2RoTQ=;
 b=GJx2+zUz4C6Q/5nXvC6hUE5c4w799UYteXVVfLinDJdYzmCYINZaAM9WeYPGY9LXBEO9wKhxywneGTl99HHYDrX4hbSUgIKE3X+WN8Vd1BA6fs++j0W51IMe0t/R0W8K7qlS/s2Nr9teUeGzHIvAb+RksktnvlucSfcZZuuYD2o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:20:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:20:52 +0000
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: libcxgbi: Remove an unused field in struct
 cxgbi_device
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <58f77f690d85e2c653447e3e3fc4f8d3c3ce8563.1725223504.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Sun, 1 Sep 2024 22:45:27 +0200")
Organization: Oracle Corporation
Message-ID: <yq1plp8z9nr.fsf@ca-mkp.ca.oracle.com>
References: <58f77f690d85e2c653447e3e3fc4f8d3c3ce8563.1725223504.git.christophe.jaillet@wanadoo.fr>
Date: Thu, 12 Sep 2024 20:20:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:a03:333::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5563:EE_
X-MS-Office365-Filtering-Correlation-Id: 40cf29ca-58a4-40f6-9f1f-08dcd389ecf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?emOtvu4a5O8tiG9CooOm2vsH2pXDdy/kx1kkv9CeS7fcWD1E6dObOqUj/oLh?=
 =?us-ascii?Q?5Bl1evvxzdOwdJi/YmkqtZSt6ApK+wxmkFnCP0sBjiMj5D9R9zaGGinHPJop?=
 =?us-ascii?Q?f1pMe6+fg7vEEBjqda3KKxujXsqseq8p6xBVZJbkjpdHgk2s5KUA4YjSQ3G3?=
 =?us-ascii?Q?0Tl5nK+qcnqJrCjzkRUtyeenjoVzJBz2oP2TJ1esMkOQ8WLcwt2x00Tlr6mg?=
 =?us-ascii?Q?oWz2Pph+2gGhkvMs4NSsVZmZ+SokRNIDuGjXler6Llf13JmkylTJQqiK13gN?=
 =?us-ascii?Q?2Pn5f9jjiRB8YtJ9/Eh45aXk8uwW9IT86DOSdV1Vp5bGfBsfcDC9fS/6Wf3u?=
 =?us-ascii?Q?ybFWYLKFD+t2jYd/4C0wJY3YDG8ediFrm818Q1hnetOoVvaFs19CC7xMvGiZ?=
 =?us-ascii?Q?rgdsVeSUEPsYDZ+l1l3MPx/uXQ1l9LfHfoX93rrQvu4T7FpkRG1qOUPmhxAP?=
 =?us-ascii?Q?QOvpO5+yYCjKe25x8Jkna6zWt0U7CxRUGQfJwFP5CN7+ydLToI6NCgWYY6cg?=
 =?us-ascii?Q?8TRBoh2anRpgExrWytPO7i2nDzzlMiKLqzl2nmFgzWVsqmRGH7PShl9MUuUN?=
 =?us-ascii?Q?C3rPwJEUT2HfOgYf1beV+lNneHXH8ZU1mw7l4GKoNHstN5JYPBlrhyxvB0WT?=
 =?us-ascii?Q?d5M0sS+NEhFFXPFGZL31ISCfkGyKIhkWhsD+EseP3Fih2NFAmKXEh2Jj4Bx9?=
 =?us-ascii?Q?VAy7uYnSdO6u41RmAWZ7ksEk41VgagmwRQxofomYsJ63rpUl+0cQc5PaR2Lf?=
 =?us-ascii?Q?r0ui/Zn/YM8+1DqcwGJ9lwWEJzWVyZLcDiWuuiPulNVjcNU7OsST/XIlbogB?=
 =?us-ascii?Q?JbZehWEidi/zq8IOR+RhTBGTIAKUXBanhY9rNDjO5ed1ZSsMJ8KhRp13mcAy?=
 =?us-ascii?Q?Ge8jEiVbjiUKdde4gcsgdXhn8tk5phzagsinX5zVRkz9iX9wELVjCIjuO7/g?=
 =?us-ascii?Q?LtIokXmgX1yw5H+sp27ONoceMv3pj9JtmZFOx+Cy0fh6TtnMB3X0kgtAV6PY?=
 =?us-ascii?Q?Gs6denU2G+EvFBa5TsTguJBEuDW+4II0YzfuWRAOuIRBjmWQkd7aTAHNUgcf?=
 =?us-ascii?Q?3Zitu67ezpMJi/LHAe/oknuMyArnu+jCjSgLVQRH4sz7Z3KJrUENbwB7wPF1?=
 =?us-ascii?Q?RsmYXcrA8aLcMelnk2T1E94mQJKvslxpZYLR5e7lLABjlrIyuVNBthE8rJJ9?=
 =?us-ascii?Q?RlAo3Geiw0YjkzrZz/iah9ncDVKON8/7eEJXcU8Z4RX4TAJoj3WelJfb7M7s?=
 =?us-ascii?Q?assbIYrtVL/04FMNNHnTX8sRrYiisRsfbAsg/TH7veCN6c8L/CL0CeiR+UY3?=
 =?us-ascii?Q?L23yzSbcVM8AKefCuqYwSA61PWwlWWToOe/zYl943FVupw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BwtuSEo9vXJFSqkXhgXAqNZa5pj9PEa6OzFnMcGclJQYVrjaB8mfU2eRTWeB?=
 =?us-ascii?Q?Y81hgKf/Ulxexc3iFs4mHrRJS4moqVPq33U4g8qdAUHBvLCW8IWjIAT42Rzc?=
 =?us-ascii?Q?xlv5yvoblxakmG1tc4+L30WGjvl/PSTw4ZgsCp5QF3Qww7Dpq5+rXY50ZcNk?=
 =?us-ascii?Q?6oGFqgl7ND0Gz8eQXRtkcD7wEbJjphyAT2Va7k77TzCj0VnpWaILM0mR9WOT?=
 =?us-ascii?Q?dYpKe7YOMYjCLP5IEJSHybhGGRrzd/iC6dITNamDmdOIiidy7zL+ECrPOB7U?=
 =?us-ascii?Q?P+4M2mfI8SkFsBF75e3tZv0W8tA1WcvsDDoLhBKqY3NhdA07gBVAYpECy+rO?=
 =?us-ascii?Q?vBBNsXH2GnaINTa1v/dOkseRaFF/xxdtqzSDKZICKbwWn7j57SiU1rBWpfDw?=
 =?us-ascii?Q?oC18AbwSEXhHnSadrxBCh8pmauUf+ZgxmLkzhLwu7WkM/3h+BvQD00EKWaD1?=
 =?us-ascii?Q?TUIZn4XHEneqZxjtDvJfxRV1rUUpS6xaSvGf4t6D5rRrYyvMetbO/nhLf0jx?=
 =?us-ascii?Q?TXeVPIoeASm77NrcMONDFuX+7Sy6psvmT0WMJq99qoN3i7HFchCGL4YZ0yWQ?=
 =?us-ascii?Q?uLTkOLfvznN/pKAvydkM9TkYb+hpiYedcaf6VmI9YCIJCsUYU78kJPTicoqq?=
 =?us-ascii?Q?URQTUdZdi+swJPtxo/T0kK5xx93nyfGJSmNdiZ38UdlQIrcbwatq93UaBm8Y?=
 =?us-ascii?Q?4/p8NLInx2XbJbhll2nIh2anT9cysMw0a/7RswE40e3Xwy46yfSoCrZQ1XTe?=
 =?us-ascii?Q?4TzzXOUj4nRyWaRNVN9iILkgNyBkiyRKAU06XxEFiT/+V+0XPwrQxhUedoS2?=
 =?us-ascii?Q?/OnUXzQZGiN1S9gJsQctXBbuSv/o5xtdpWOQF6JI+/9one0eAzEb7+keHACN?=
 =?us-ascii?Q?yHpMbkzhEXZxJLZ4W4CP7Lo9z52sFRg87sFR5buaYnBVMvZDeEmxpWB++kzD?=
 =?us-ascii?Q?ZBFQMFaTbbjz+Kziprm4vq+8Zz1LNjHa3867i3GLdijLJjj/3p11inSFh5B1?=
 =?us-ascii?Q?srX0NhiY0bkJnHvdocbKLMqjj1J4R/n3LRvnO0esSPRE64DEchcPVRhyDUux?=
 =?us-ascii?Q?U2oTBv1gSSRZk4GWK85rq7nvS3x0DsuvZEbVjlk1Ax1kBJOpvINrtm0RtVni?=
 =?us-ascii?Q?/UVKWgugtiJn1hg/CJcew56ybFzqvM+TY1FDjO0e8hqNeALxXZ0avqO0j4uR?=
 =?us-ascii?Q?sVvOIBRctWyyVdIsAgrJV2CYw3eAsN/FQGEafmZ5C6lkQWt8XrI2jWeN/Mhc?=
 =?us-ascii?Q?4XYM9xZVm319npPE/YsOhb4TvDNE8FBWTCb9ky2W/14OZoFe9x+8Cf8vJVhJ?=
 =?us-ascii?Q?19KYxG42sYbha70hyouDdYg5sBO9yvDfcZQA9KvGv5FXFtaYfeirSk8bIinF?=
 =?us-ascii?Q?lXAzjgfqfFkC03W/AnQKHwcWoP7Vh5LzszyOxKmUQsPNogNhbJ8LBaXfV8B3?=
 =?us-ascii?Q?i1ylRiY4REY92grbKo9PeJq7nDnt9REURp4h7mjt1GfbhmcUTXyc7RZOMSwn?=
 =?us-ascii?Q?GDFNZari1zM9knxzdiGtCNSq5drhoznncfcNH1HPfg9hrytFvDSD+7ASmi9h?=
 =?us-ascii?Q?VRBz7S+9929hl6v0yAXlTZBf+5p1Z2930qTK3aDCSc0T9oYMdl/NeYr0bznf?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nPd0iYEQ+aD8cfSD4Nn79TgMDpgIkGy5PVpJFqmhrZLR8iffih1X7ZWrOcUU+DG5JdV5jFEllBYjsTG/q2lDN5VM1LFus2zPKXKwCK80BJGY5PmPBdD6WfkLZf3SoNCPa6MbBpqMvm3O9WtYa/UtwX5qB0BWUUHV49C8oWFH2BpI/vBlxf/uKfzC0sWR2PRsNTRJJ+WRj6Npiv28hMblvqwESP22gMsySF5mPPt10vSZTIZ9eAPbS6gaju5PSMlORnXdtD2GJJlP4IT4rBSQqxULk5rs6gDYHunU5B9nEadK/TYe8d9ntmL0bFAuSZggwRSt/HLSPAxKnU3+UWd44Y0i9EEVNozIYqwr4y4FK/xcBdm9WkZp25Z/N6yGo5qGqHdq3oG0Zu93lsxA71Uy2FeN3dbLSQ23LJZywxr8NzOyrdBrYxTWElrzdyR2fP9vwUGPcnanSn31IXi8poMVsKGvtA9OIvUCMZtUylqnRb1Mg8mere2k0NWOZQGCeFq2yOU4+KzQ/xVthtLfnEG4f3fVplEDwJtOIXOzTULWVpWUlLvLt7HeFnytxh75kCYarPp6STVHLC2swdg+jZ+TIqf1gZgZ6CEhj7Oi5eYtiW4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40cf29ca-58a4-40f6-9f1f-08dcd389ecf1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:20:52.0400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Q963oe2TbwcZ291KRYRU7Ut8qaUmtFPyNVGZAsIpGphZroW3lMjNTZIICXBWm6WAOJT9KhUr2zBAJyIcJDVMRAHRuGZsYZQcUlgmuvtDTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=903 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130000
X-Proofpoint-GUID: ngCEvf_wMIfFoZ0xiJLJ-jCxKFRedei0
X-Proofpoint-ORIG-GUID: ngCEvf_wMIfFoZ0xiJLJ-jCxKFRedei0


Christophe,

> Usage of .dev_ddp_cleanup() in libcxgbi was removed by commit
> 5999299f1ce9 ("cxgb3i,cxgb4i,libcxgbi: remove iSCSI DDP support") on
> 2016-07.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
