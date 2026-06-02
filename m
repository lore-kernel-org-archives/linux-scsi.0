Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA81ACEDE;
	Tue,  2 Jun 2026 01:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780364884; cv=fail; b=TYGiCsya7VtFuPJWrsHYmoegr2btAR5t+iKgdoRBBC1R2nr+QwG6uvmQpDZljkd8K5iCkZjRT9XIdJXaYZFFQPBeMDFveS+5C88rrxLesBZQ3X42CnxRlY+iXNOU0aWEQ2RmqAKCk2qjwYcXAxeXsBoMgvsfRrQEV0P6lR5+Qdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780364884; c=relaxed/simple;
	bh=cRCTID6uTeN8dYk+NeKRwi4u7uKmjGBL7TWL5tb0ezY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gZLc/8vNzozAX8GSPBuNzUw0Eu3AlP2DmNWKZYPscg8A30ttJn1rnh7ExIdpznLJlD1Pjxeu7WoG1ZVQea73qvuddc8tVvCQrbPQulWjOzHT7tzQrzmbiN9VKJUWDYQLfBPlUGt5xNzo6wRykuQiFJY9Sbss6M81JLz7c+gmglE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZIgGBv4J; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kwYSmdwo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZIgGBv4J";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kwYSmdwo"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gtoet2718771;
	Tue, 2 Jun 2026 01:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lfMc+qS5LUVJvu6+Fv
	XptikRy3uU9/SwLiRZawxs4CY=; b=ZIgGBv4JetrTwMNkEULb1zQLY8sbMtCuaC
	b31v8clyDxxr30oTCSmI+sdYijnFo8II3DomS5upS/S75qkpNwPKcLeNSCbsJNfx
	DnkkY6FkkCmMnyB/szAitJHjzVCmR2PxADB00dD3snVO20pOYRBwd+4wHy1y4PeU
	y/Uwy4D73jgUVLxansa0UDTueBRSAN9Ohfy8tmsyMEOAH2d6YpQO+alErNRMNPYU
	HLQnnguW01o7DSIvQ9Mh8/5JTLlgAXO2rni3NvHJotk+GguZCqB+UNiEVOVeZLAk
	1CKpMzj05hWiMXOZSmI9SdPSztsaQpmREu+C94KfBTCKqboXWLBg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efres35tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:47:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521ivPl040861;
	Tue, 2 Jun 2026 01:47:58 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012041.outbound.protection.outlook.com [40.93.195.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc2evn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:47:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oVF81KsUzeoyM6X1/4KaLTss8Nl1RVHGvD/poqdxZkTa5i5qFO5kggrUdJ7X6cisaenMJL6rpWtyOHj76Z72Fw2lC53JwsrkKsM31QMHLHNW+aWG+wVlcOZILXM17ZzpdzgVv+k/Zl8Y2rCNZUyLlog0cPcSW3BSrLEBIK3sNAb2x+5cNBY7A34Xu68FcMWk67lKua4Svgi5L1XIfW9v75b5J6QgDeyJH3pOgmju/1df06Lf6S3l+M04TRgCfs+iGUPD2RHnpdJyBKt3MTcA9XvIM4HgBfCRoLOSyQvFNk4pfzKyuPc+T/FwXMo05qUHkuF1mwQhhJnL5VJCugyeKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfMc+qS5LUVJvu6+FvXptikRy3uU9/SwLiRZawxs4CY=;
 b=UdXvrPHyAnOAwsUAjqWZ2UihnyZtGIXynJXU1IQetwmhVxGs7Rg76As0wsRBR5ge0WE+GWDh8pGWpiapBq7UKXqsQzcR2LvbipXb1NSh+q7upaw9lz98cAvQa5bJLc/4jdo0UHtviRCF9xnIyu3Ez6xYuWmCxAJi6bwiDtAcRXti/fIhs6DbNBXb34plPYnQ7EwMKmB/kFzmkG+p719MiFbRwgiKdnVDV/mNSLcFr5q4usG/4egStPC3YWu4K9fECg4XDy81I3dO5t+KdGEZ1UrxNEQF15DrA099IqjAdPDZ3vYF6LJQ8OawM1oc1wxO+knSuXtxDbZvY09gpY7ZeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfMc+qS5LUVJvu6+FvXptikRy3uU9/SwLiRZawxs4CY=;
 b=kwYSmdwoOxx8cXR06beOwSWmRuz+xhxlE8Hfp4vFj4w95KjuiMsEYQE9u2FyZiKGPe/bTAKWETpy5cdreSQI+Yk22Em5bCIEPixRotfobNvrlbeHhV3WwVOJV+ql9rG8vQWKrrPPe+UAnoJHK3483pQnA7AcXmFjwpucEu59Czg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB5699.namprd10.prod.outlook.com (2603:10b6:510:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Tue, 2 Jun 2026
 01:47:51 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 01:47:51 +0000
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        Paul
 Ely <paul.ely@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] scsi: lpfc: turn lpfc_queue q_pgs into a flexible array
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260523050241.190239-1-rosenp@gmail.com> (Rosen Penev's message
	of "Fri, 22 May 2026 22:02:41 -0700")
Organization: Oracle
Message-ID: <yq18q8xaf2g.fsf@ca-mkp.ca.oracle.com>
References: <20260523050241.190239-1-rosenp@gmail.com>
Date: Mon, 01 Jun 2026 21:47:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0125.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB5699:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ecc8e02-610a-4964-61e4-08dec048f51d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qI/ZWvPvOPEafTTaONxkrdhDKMWSMwx1xJoPYFN5XL6/RhRq877ZzJL68XdN8ziWxHmOY89+0PGF3V2a2L6x8ilfXvXiE3edLP42Vh3KJw3cn96FpOMYIv2npnfU82zZ/QVKL8IQLPc239QGgKzDAPEsjOOMGxETFG7FdliVT9nyOa/xnh5ZsIuqSB4PAFZNVR1dXTFB8B+OqgEShbUpoecncB0nQfomVGOJpqDyHSW83tiJjAcQxYa39IkAhkmaotALTENNJWI6r3ZyevmETdTfc2BV5BL5EpUWjat4SNmp6YGm6FLtQmQ8UuE8BaxPVN4PaGbPKNkCpxRdM9if99epofWs3UNjYXV8lpSO5U2llmOk7lpGl31uLEsYVzx7yNYmf1QOP7oXAegrW9xSqSvhi+7thuOdbAVTo3R0hFdGFBFf+hfsUlTWaR+KNhgimcs7EdixebNhnT4ZXfmTvc84oQpD9jv43bLHpDNZqnmI3G6q0Jf9wNM5WeW4tH+x8F+WnUIksEOWqylNO2zZjf78ZT0mj/iMg608lxUin9ZezgSta+wRJ3y7sK8Y9JE11gnYgGjBILLwPMTPehMX62W8PR/phbXVOgOhvU/zNnPBOQkfFWOxZpI3JDJMqYswkpPUx9t14CQOaltx5UTxF+jqhsbNKotAnGK8LlgNz8Geuj7AP2W7bPQVQQTPnzv9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9oLU1FrUFIeYJL4NwubPVoWIo4tQLke8Laowmm4ewlT9O8nwXtxDxXYx/RVU?=
 =?us-ascii?Q?l/w9ByxhqU2UTFSuVVZTxOrbMtRs665hu2ab1Lwc8zsgukV9KOG6AVppvdry?=
 =?us-ascii?Q?Qin3zhjpV3FZJTfwOU6rCfFIFkl2xc5cQFm/z12JMNPs35tj0hrHrVGIp6nU?=
 =?us-ascii?Q?zSqZjLaM0hXN/zaFJMQZUNFK/Pg7slCPstIpDnwBXW4VA9CIQr2o0N5PXJgL?=
 =?us-ascii?Q?xgTgQ2AMoNQnEoqdn50wW6tacTx7cRYV1X6N9BWfnLSN5pnLT3h+5KF7ZGmW?=
 =?us-ascii?Q?NGOxipMftfIPFJlRR0giQRptdh8QlfCIYA0OAShdYpYnhnIQ5FTbMktLkBaE?=
 =?us-ascii?Q?rpL4hFtaoMxaLh0Jgjx1ce30BvpRfDQ/I9CsoczzZRnRUCI04IckUtqliDZL?=
 =?us-ascii?Q?YnooAUhiCDjve00eQoKxca7j2y0SFB6wQ2kQBVt/UnZtMzhYA4BX1DrIE70R?=
 =?us-ascii?Q?ZITZR3tXSEnIMaZk85ginGgOqw2NhvMn+ZAZpPE5SxAk4ayxoOUA4H28Eac6?=
 =?us-ascii?Q?CuZeidJFSPByGpsgvloOMUJhPz4agpKz8EeJlL58EWseImPvqBWNKUAIidyV?=
 =?us-ascii?Q?g2ewF32SmmGgzqxq6tzVOz1gIlLGADYfSr4foHeGA5VScYpe27dpwbNuKq0b?=
 =?us-ascii?Q?rAREILKAAMbAa5vzxiifrNC0NEC7/I9D8FlfOHNvWhw+H/NRMI6Aa8ac+ULh?=
 =?us-ascii?Q?LzVi3aROEuHnCxFiPewdpsjKbVppX8vPMnKoqTCdcQPkcFxTnt2HBPuN6gWl?=
 =?us-ascii?Q?qkWeDzdhGamJ7sYfRHkgXYYcLwVFOd7MO45VCKFB0zpuprb0B2d9FC7rfpS1?=
 =?us-ascii?Q?uVhZwHH9UcAE4GGBXYpgAJ842CpCyT7pgAM18zkwobJtAW+OAgMAIr49D8/3?=
 =?us-ascii?Q?/pZ6ZxlQyTcVNXIkU/j01OMSSISrJLsVlCTsaptXfr0yUN6frkxV4x04cgDI?=
 =?us-ascii?Q?QN8k6zqGtK7f7uD+NFZtMBVh4lW8qaDjexZIjm6Ncliz9TFQOwWZT04R1xXP?=
 =?us-ascii?Q?f0NWA4Bc9R3ynmEGyVmkjO3UI9iwXnIydhgAaJQMzcCsqpfvpwf8pwYDJv/V?=
 =?us-ascii?Q?lMuGD8qESugc0JeAAJXkVVElbvDBnLXhiJ6x73QyNnf4cwMcO8NYDh6wGL4K?=
 =?us-ascii?Q?JGD82vNkcKbmCxEQ9+6wP4y4+JEbZpVk/WxBE26RfSN3bIKQL0dPPChimY6M?=
 =?us-ascii?Q?JgbSy1zvIZ1qDnMpWwF7aNkDIy6ipqKaR4zdj7sTFfa5sdLQY++yCZb260o9?=
 =?us-ascii?Q?Z1xnWI2I4lrlbXDa4blKCTlCqlEVphojS47G3PkG0lPFnFQte6pq7LNKGPlQ?=
 =?us-ascii?Q?nXvE52/MLAsp/JOjFA1xaISE9MP7JPga+7EjzAlhBKuexs7sm73zfEKxuy1h?=
 =?us-ascii?Q?0DVnKeKzhrGs5ma4uU4Iwu3FFKjS5q5hE04EflDPcqJBmhYSka3EZF5Mw7Ym?=
 =?us-ascii?Q?ejdHqXzQD3ykzhzDBwQK9xiMvFR8KG766wz95c8lw33ZFkQaHhgO+Z8ABAUs?=
 =?us-ascii?Q?BtNaJmpiCU7vD+JrP9WTXxDTAXTFidJtF5Sd5752phx59vIuAkeWKJiDwwvi?=
 =?us-ascii?Q?qrv74/HY77LjHAvURDJ93xt5WgfU7r5sWt5RMZ6QJ+iVmFX+7NRuuu2SZYRe?=
 =?us-ascii?Q?sY9oXhPcYp+uUwM68b74ymnYttu+8m/3SGmQDQooy15U7CACA+uBRyYXWp/M?=
 =?us-ascii?Q?VySlSY8O0THYmdwAZMJebSXyQvk4DGd3P8C/I2wr7oOrs2rdtlnYz+bPcay7?=
 =?us-ascii?Q?77ifvkYNG2e0Pc/y/uT3hhTje1ibhAg=3D?=
X-Exchange-RoutingPolicyChecked:
	Rx/oMxoyL3B/8qoY/hMUCdhEi+kIegtoDyQx0IutRUZ1NHqfRVRJ+dOr+5GsCQIdciy5vywXflhlkVblnIQfIRTw4P9Fq1eTfUJSN7a0QsOVoFWsx8Sx1oWCvXQ/eQJpFIpVtrIUK8lCK+SuBL6d9lwQlMZW6MtMyS30eCObw8mmFTUO0if4Z0hscJXP07TNU1uGprmPXE63py8M/Hf47VV4BZ/DDpIOCK/Q2NnBL8eaS6CNF4h2nKfgfBFsQXJCAOkVq3IJL5ZF244g+QU5nkH4Grw7IzZcjraqYIE/UrUYscHgpxes9xmErpEbpS6P6CKe/9/g1d4kKbJFSNVJXQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NR+5OjB81VPrk3u0PgBrQpcC33j93Ul124YHiPqnmGgY7lVhfCY1YvN/2HgCR2c20dpw2ONGHaj7E6JDTsG4YOfmQ9psvEIMLXwrPj9YlPNOqfi2rn3wK0zSSsQns+chfE2Ez9exS4Lnxt1aneIexB4RLy0HuOw8JuBzDp9xFAKc3WEKvgyxzDF6YQTAG8MUlql3DUMb4T8kaBuaTVZmlBJgR2+nIIsNXhLoz4AyAuaBmXFcIv+TbTnLiF6GQMEl3h8VhOuKiU/3zfFxwZ2hovbg9pXeH3unvKFa/43wrTuZcOALIThRVxvUreicG/eloC4goZ65Io/dYHDlPTMyX7BFLeezYLrSr4vpWMpvSg8+zLwh6/tu4q3TwGUhkGooOE6zQcSkCi4w3eBAEG0158OlPFffr22c6JAzUaR7fdxMU0oZFyzIswZVqEuIadykEl94j++x/tHKraKCqa1WNzn25iXyB2k66ykFrULyXLV8mzVgT0yloGu04fJt2tccwm3a1AFIbjDUfIIJRGBbdwmZdYuG4o955+yzpg0o8nNskzH+41ybOGoGuFWx6HthaVnk/9UJf3K3aQAyLlLcp5iRPwU2VMeQpvdpwev/ISQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ecc8e02-610a-4964-61e4-08dec048f51d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:47:51.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/P+1ikMcgwu4WkD2A0/IJsF8Gzh+A5gDHMO60riRaz4AjmjYAldhgmsm2QZ+y5Ck81nOOv9VGJt2zCrIChgzzMqVJ9iszWrouRYXEtBwCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5699
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=675 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020014
X-Authority-Analysis: v=2.4 cv=U4Wiy+ru c=1 sm=1 tr=0 ts=6a1e364f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=uYIBx3HiBieq-hr8dGkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNCBTYWx0ZWRfX8AjMM3fcBeoY
 SShniCWnf/0QREGfegJBi7KDXp0aClhu38mwmBui5wk0Ro/DeZIlSeLA6uGE3V93ArJZn+95N1J
 HEpUtZwpm945PChCgJNZnS9LCuoPVXrkrdM4Ch+1iC1H+ctw0f2QZbo/1gkpJdAmPPeDCnhj7go
 VexbhCt724fw8QEfQeMEwTXTs9nAMFRFrlG4PFUfTUM2hTu7nV9azTdRYVwTGCXbZIwhKfPBdLv
 T4cX3oe4qjKENNySlxV1LJzy7sTs6FOeBJ2DVjPGCxvroTfLrtJOzbgXJgeHyCGqde2tWFpgUnm
 bB0jRdRsW21VAGKMdalKY+YK5pgp5MJmTVYSvisz8sHGzw8vng/QI2wJpxD+WGM2aZDTe7LV36d
 BCCxKcTPzzrGi0BK+lKfSDpy+X0G/oXQuqRA1xfWrX1+jhsGP6NONFiWStuBMwhSHJATm/heEXW
 R/DFNk1LbeWLmFYWHFA==
X-Proofpoint-ORIG-GUID: rWUSoScSFfPgsEDWVy7V8xTZqT5WY0Lb
X-Proofpoint-GUID: rWUSoScSFfPgsEDWVy7V8xTZqT5WY0Lb


Rosen,

> The q_pgs pointer was assigned to point at the trailing memory
> allocated past the struct. Convert it to a proper C99 flexible array
> member and use struct_size() for the allocation.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
