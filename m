Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8074D36A006;
	Wed, 25 Feb 2026 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033696; cv=fail; b=BiUpqpD5Fk+1ez1USXPeP5ECKGfSjr61DqV1ePjyfz2sdnocS3RP79p86457W3r6HlJFTxp9kJsKYiYwSH+4/Td1tES6DfoAyrJkhLeYV35RMCFF8xfB8YDL5m12yVH7D1UouSsF1zbvQGWeI/LbWB64w44AULfuAZ4MANhctLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033696; c=relaxed/simple;
	bh=MkimCx9lzjJnzx/cYKWr2ly8CEXwtxBfGlUzf8MBFCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MiEAFZFw/YwpIugbQTyl3TeAdY0YNFM1DnUgsYUcKpOknDbmJetr5UnnCKvEB79nWyknk+Ff+MVdOk9NODSqcKSr/QH6jxjYOB7YlxCmWPu0CfgfKW5YGDyuquIdsHBoZGw6kG1zKcGqS+qjO2d5oQUHo0hdoC4vo0CTuNrWJSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oPD7Rj2J; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=se5kroy0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oPD7Rj2J";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="se5kroy0"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PA10S84019325;
	Wed, 25 Feb 2026 15:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lmelC2lBtXL+7MGPYzhgwFbZKY05WyDVoXNnULTyg2M=; b=
	oPD7Rj2J9Z5k/wJAWI0MK7OM+nVPk1v93s0XLMwDd+rXIs7e5LLmimH+mHOxoBLi
	SbxDS0A5OQTIBQtc+9LeFuoTFj2XzOyHopsn6rlUPz+CBljDqbSnVD0rOE0lS1rr
	oznD8f6vS59DgFnM7yR1RBo/Ujg0OGZJUBhQeaxIOVtA5Nlgwxou9wTurvuim2kD
	Qp7D1ltxvDjFeU9fReW1zu+1fSVuntUHamWF618BVptWoG62PUoJumboaBXkyAfi
	re44bDNkDQQ28CKR125FCTOO2Ev+6xsmLUI/UOWqodeusOkPMP6rqVFL9IYUoO0Q
	1UQrqjEKdEhhiMGBFvnj/A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a06gwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEvAt6027868;
	Wed, 25 Feb 2026 15:33:15 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012008.outbound.protection.outlook.com [40.107.200.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35g8ntb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rj4+JtY7TSGADNNDEzUC5v5jkA6jaIYXiioVNZ7x4e2wSgR5ryxS/T1o+rMN3549y4NwSMbd2o+h9zVocfDd3Qh/sFZHUayjkSET+waPwCyqVvxRAQj2H8RCDo1ir8di+QOXuREy+R6NZ+nFtc9PdiorpA8J8ryCvoWUevsjNEmVK+NyAAYOMRg0wm6JK/zWDPRFFZAF9nVwl+hDExHx9/1sa7tZ0iF0wkKLYPuOQhEC5plWTJ3vJQAiy3uhVg6L7grsQTJib+MkwPJGknFPgTZUyfQqiMUf1T9fAs0Xc625Oh0qDMCpBtSZqz0UMYTXFHbrHoR28Nm056Ye9/xEIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmelC2lBtXL+7MGPYzhgwFbZKY05WyDVoXNnULTyg2M=;
 b=rSkOvzVXj0ddTCANaYClXXZVwvzqh5cYOWKTuSHGs3E5Rl7ocVp5RY6JHNDX0d7HQQFExy/44DBA3Zogiw5yDHuMovR/MWyIi9/0I/CZZyuRg1vG/3qz7RvSexUFHFmQ2AitYu97uPfIdkG2HLbjbzOheN58ewXE1qs53Gtoi9rQXVjZHn72f6cwILcbq7VXQIWnGDJV7s4LOQBoGcAw+BI8xo9mMzzi2D3qzJGnbiZjYQC/ff53bVnZhdtjNMH6/MIt8YPyHUVLgX5UoykKKk4NWcHWv+pkdaOWjQ5gEdRF99gjwjTCCFHN4IbE/2WyNdccaeB7bWcqWYivYyCFsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmelC2lBtXL+7MGPYzhgwFbZKY05WyDVoXNnULTyg2M=;
 b=se5kroy0QWRtSg8wJErFKkg4x3hwJ0W9C7YPzDA94PWKO4ZBGGUiH/ZSmDvpdyVuEWZy7ik8rJqR6bAkwGuQr/62lC9ReI+QNS7U5C1d+Rn0s2yIoprUuRRVcPOpBTUhgpnAWAbuAxI3lc6wJ6rfMBaPfDqFELi1E0f28iqlGJQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:12 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:12 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 13/13] libmultipath: Add mpath_bdev_get_unique_id()
Date: Wed, 25 Feb 2026 15:32:25 +0000
Message-ID: <20260225153225.1031169-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 97f02147-e35b-4e3b-74d9-08de74832f43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	YesmbIDTBOENlJBYvLaW4Rz7kK66Nxht4It5X8M9h9dp2FAm8C8qaQL4wGKLczjevTmbqS5cN5vWulwrTBB0uEikhIXtFconLd3X43YDEG7ka3G3sGTvkyQuMHEkgVx79/ZDZkRm8TCvtVa6Pr+SvOSUYFckSmJZI+pmwYP2JxzYSGKcGm2VOu4QJ/SqWceJY/1/zPzXdPhQmII6vzvYMdHWUih+QWC7WCk5fFBiEJ0w3R5sANakNBQp4EfEj7mWsqKoxBpTSnaZ/b72+g40l7UyYe8+f3AzEAcE/PtNHbsUTynlre8oQhxkCTVwDhs5GwlU8dIgk/Oo6ZIAf2SHT4o+eZ+LrYtosWPgtAVSTBTTIggcp2D3nlcDCmesB1BcOLZIIwo617gQvuWs0WPM6NCSXR69o3TTDIX6DUnk5U4/XkIA6FvRmfGZ39klb16FZ6JLU0jBFbMltplaxPiYfOiKJrHUaLd9lGLx278uZa8HmHUmy87s0FlqV7etvQPPmcIxxl/AOiTaypIZLjpG+fym2RLGPA6AJTWP9PoFewigiBtgA7b44Lw2K9b6xI/562gtZhjt0AHav3us/eWpQvZmhSLL6DJCBOVg0AYhDnj3mq3Ag8bLyYYl1B50nnTSp7KFahM9PQbXTk/4JU9Rzug0ISmahSfxL0Lf5PfBwR/QtxnK6FSM0za+zArkRD2o4Bv7lMC6++9CAv4dZjoCOl10ldmugez4S5hPeI4iic4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RWeku9JnHhv+IiOcK86oY9iu/X/wc9DZV8sLg3Ng3iW9h6J1naWflU8/htbw?=
 =?us-ascii?Q?CoUO8+5eolcLUxMDlWfwPeOaxKaPMKtGRiDmcAlcxE92nDxxJF7UcSUiuhfx?=
 =?us-ascii?Q?reIP3NZoi8G07JkaukLpcEzlq7Wod9Du/JKBwd91mYbxD0adYONm0W5usF4V?=
 =?us-ascii?Q?ZnbhAYcPrMxGw0ht19rXOsqM1u8GhWgAC4zBGTdOdmKJqWsoJZmvHXRUTEUH?=
 =?us-ascii?Q?E6DZLt6eulzq8UBmxudgf+SvV2JvT/junc2D8Xwoaqe9XI0g3nYal1q8uZ9w?=
 =?us-ascii?Q?/YDFBQjxuPAqslWEfyqpgVBL65ju/d6W4jaq0dFjIxW2qg27Epff7ooEdPxD?=
 =?us-ascii?Q?xWvPgPyjzZ76LeRBZjbkI4khlW2ywDxbEVZfPLTqRG+I/qhf1KFUOrX0DNE8?=
 =?us-ascii?Q?Y46pxQ/OjKWpp01LS6D4j8U+l3uWXO6oa1tCLlxmNjbkZNnKTlURMyV2RDcT?=
 =?us-ascii?Q?irDawk8UtMR8zP7O7gwPkNlVmIziDxJVaX5VgYf0rX6vUN4idS3eza5HDSFZ?=
 =?us-ascii?Q?/VmpRxEdcJ3u4xK6YyOaSfMy/is4uX1gTa36ScpcNePtqR85oLNVvnZBySzT?=
 =?us-ascii?Q?Ib8XpK66IIvbrqFz249qktChkQ8xu7faQ5OXXM6QFLKlRnF6Iv0s35n5st4b?=
 =?us-ascii?Q?a/1Mh6Bzf7ZqQh+5KIBjyqm2RG4rXVxI/o10LxwQBbC8BX2guAWaf08hFygk?=
 =?us-ascii?Q?KoBOao/Z2eO7rfIhHCCVmcVaYJQkRX6xQBJbT76QRxwwJLF5vNNFb5qqefT5?=
 =?us-ascii?Q?4U/f+RkYlQzeKDnAVNAiC1yv79vssBHhpmkkh8k4aVAaDFogEJsH8hOugDBu?=
 =?us-ascii?Q?sMjou3FVvJiYML0BiTr2EDx6muS352e+zNm41irECvlO13D3KLv9c5J/QnW2?=
 =?us-ascii?Q?yes3qyxkxni2cMIkpmrdhrNEAUL8YzLOykxfTiS/pXL/J8aZ2hGx3ydDlxDm?=
 =?us-ascii?Q?dXn9Fnm0Lhe0ql4JUHVjHPsbYs7jKy/Hz+p6FAyHNOp2iCdM3H0WkiGFC4Dj?=
 =?us-ascii?Q?u67cA2mX73Zgu19QwGUQrMuLBLRc1c6KMDfe1HwCTvWwhH2T15m/Zdgga2za?=
 =?us-ascii?Q?owRcgP2zJ+HBTYbTegeS2xh8XU1WVSe+oF7l7TGlm+pkUCd9cXZl/iJBlyDR?=
 =?us-ascii?Q?cqD/4cVZHZMnuLakVkLy1aaYhXRI7Q5eqhNVPuP6ormCEZM8PhJN63wKpUzA?=
 =?us-ascii?Q?5t3a0aGvSsUW1Mkqh5HYrA0OqBRSggoBWkaFYEYMqVBIUHq/ju9KUwg2JEoI?=
 =?us-ascii?Q?4s97BMW5MVA/c6jZfAdYqD9ecE8mu+FpFLuWoWrPtjBiEzwQpFZFLX68WLd/?=
 =?us-ascii?Q?JgLcxEHCQWxHhILw4btkZQ+36aeQV2d7/7fU00bEz0LGrD4dXAWJplnOfJYu?=
 =?us-ascii?Q?QoL4hYKXJ3Mj/1A0RLXMYUIw6tZPA4LfR86+dUAmUAcKhD5OazUnOuJPuJfO?=
 =?us-ascii?Q?uJ6RkwNkWLIkXkUq+Qb8MUk0a6BW3CVaD6sBHpbjbGnqZDuNPbkk2MIkqqIy?=
 =?us-ascii?Q?HCMuxebSTRrelGYyBVAga8QwAx0u2fcog0NAgkwF8kKivFwvpT65mTwM/Xur?=
 =?us-ascii?Q?ROZH7GhJhgu+yGUEL4cOvlmowWRInI2i3C7WH/TR2ih+Avop7pNon8Fi7r7S?=
 =?us-ascii?Q?YQvuyjvpwYT+juQz2spKbrcrlpnN/5GeKM9ND6wfzgtATeKJ+eooqfRjRPcC?=
 =?us-ascii?Q?hvm+L4YMS94avHXR2Ep9Gw/ztiiNAFEfx+3vvMZp5mC2jn2Vfq7x8z7q7gii?=
 =?us-ascii?Q?ZuIfxOBZLqzRDvOMG7Cx6vPvLXy4N40=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xow4bpwZdum6oWTXDYE1eDDxRnzcM6ltFPtxU51MX7b1cvjx+NDBmH3dPEolBbo8pNPao9YwD3mL5yCz/C3bIuKR5ZyZEHJqbrrgtrbKaTpHN/EhYKnffrrrVuAzOYHnjssSkGzY4tEisdbl2v4d/iiQFuM0L1hv3CdWX9a6XgWCHmLgo+wN9NB3VlAEj0TAgB9UoZ6mw95sUmZhiV+7SdoOdE5HSU3tsBqFfK63MN4Ea9ElWvUjpNRdcjOjk/j6MZboAcrbBljHIFiX2+Uf7W77iKkGwAajB9fDKGfOupaVcdpod4eiAb75QxP4qIdtcmcn2g1bK29bWmM4SbUb9Zx7ZFoEe7fk76QJu9pFSGFAvI2qCrUy7cj0y06cRbhcH8PxDpuQ85FZi4E3z7oXCBEzKsMeRWbdY7RQbBr9kArx1eyT2LGcwCLt+qi5e3/JXatFa4NHn0iMsECS0YqgCKUqOLjQ5gWE92FHmQFYvHMbfxlc8VWZVsdYp7USMS1UaRzZOogV2JaK+FjGnxZ0tiwt4m8WzePicpiRsiXk5dJj9Kp7beXgoiJDK2ApS/Tt/VShLeCNraH5cKZ7BiYYpg5EnAQa4gVSIhSCXOXW/gw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f02147-e35b-4e3b-74d9-08de74832f43
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:11.7407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tpr6x2YvVanNup7JxfYk5oofhXNEhdOgER1laAO9nv3qPuaQ8dl+WAR7TbFn9zH7uxvoIzUJBzMGZwoBIwGLFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699f163c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=cYe3JGuVRXpH4XBa9ckA:9 cc=ntf
 awl=host:12262
X-Proofpoint-ORIG-GUID: taxJfzMH1KxQjzT-4eI9riQUICC-G81C
X-Proofpoint-GUID: taxJfzMH1KxQjzT-4eI9riQUICC-G81C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX0izk9mM5ZRnR
 tnK/gqaN6pNJwygPb9IjdxWgwIL2XyXdiT1qG6e2AOMxxe9hsgoN/EsfO6Tf36iutkV2xjMrzDq
 3d0m/t4clwK9PnVA2CZsYEdVHe9vL5xy20PTL3cYFVPc+CqlqakinOWjptn1gRSq7csEjXNqFlk
 9+WByzTAXD7Vzx4ol7kal+PQcEEKnfxLYN5/rRhy3Cm6e0zCCat/Q1Esho7xWOrUs1M/sKZlIn3
 fPb5DdNtp/r8z2tggTOKr6C9GrzvN1x9sElFitCRrflMkrC5PDr+0qHPHAgU7hdtKbEr/PJsnnK
 TrVMPUG7e3ml90AuUioQPmFu4VArj8nQnE+D+UJVYjYHKXZyUde/A6pRVWBnLKDqTIm19sFVo+M
 cwIOCrxDTHAz7rXIi3JOvgQh6IDTH5OpGrzUxXx+nio6tHSVDRE5IdMSFQUISpgVjecDDIuTjzM
 1PkqpfNWg8cPPLflszkg94gdTkvrpiqsoy7iB/V4=

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  2 ++
 lib/multipath.c           | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 40dda6a914c5f..1aa70ae11a195 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -86,6 +86,8 @@ struct mpath_head_template {
 				 unsigned int poll_flags);
 	enum mpath_iopolicy_e (*get_iopolicy)(struct mpath_head *);
 	struct bio *(*clone_bio)(struct bio *);
+	int (*get_unique_id)(struct mpath_device *, u8 id[16],
+				enum blk_unique_id type);
 	const struct mpath_pr_ops *pr_ops;
 	const struct attribute_group **device_groups;
 };
diff --git a/lib/multipath.c b/lib/multipath.c
index 192ecd886b958..bba13b18215ee 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -496,6 +496,22 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_disk(mpath_disk);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_disk *mpath_disk = mpath_gendisk_to_disk(disk);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device)
+		ret = mpath_head->mpdt->get_unique_id(mpath_device, id, type);
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -704,6 +720,7 @@ const struct block_device_operations mpath_ops = {
 	.submit_bio	= mpath_bdev_submit_bio,
 	.ioctl		= mpath_bdev_ioctl,
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.report_zones	= mpath_bdev_report_zones,
 	.getgeo		= mpath_bdev_getgeo,
 	.pr_ops		= &mpath_pr_ops,
-- 
2.43.5

