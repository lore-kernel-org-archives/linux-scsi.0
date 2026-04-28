Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397BA402BAE;
	Tue, 28 Apr 2026 11:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777375002; cv=fail; b=nwAIMWyEKhzb/qWmo9QO/aRBqOcW70LR8sCY7JJCfdt9b/Sk3TwYOeAM7O/9eu58y1sdEOw6JsAMAzkAbUhxV6hyORm7E4o5sRYLU6+nnko1WTIGs09VcFlUyKuApvro0U0WN2uMjWNcQMQZx90d7S4miAMnLlxOeHu1JnPljgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777375002; c=relaxed/simple;
	bh=nOlcAM6ySBw/hz/tBO8BL53mJLs35G9Cl5vFzlzFJgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SV2GCYGkSS107Ji21VokSwn1GN9U1m6mQzShEWYzpKaqbYfjGlGlZFBXnITYIsO0+C+4b+bydGRRQfC4aYZZgzovNsuULqCH7fNuhHPcke3DM0TjcG2ZQr3mGG+TZ06p4OddBDM8Lfv3h/WxuxxLoBUo3BWowQ2yUfUp/QaMlZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JhjNKxzN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EeVBye7z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JhjNKxzN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EeVBye7z"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SB29aQ1015471;
	Tue, 28 Apr 2026 11:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mD1qmOqm4knm8wCA1FONMYgre911vMpP/h9S0RGoY/4=; b=
	JhjNKxzN64B/AsoLdQEW3UjoxetW5zLzqBDyd5sa7ToVZIWFu2blw57teZAGhY4V
	zL7SDzIQXFZ4wgdlEVHP58xAwfBu3zkgXHvD0Fuk3i3WdJxl/iJ2FvQriDp1RXvm
	FAjj0O6KhaALSbu/0/zqOHibkflyNrGg/LC8FPv4txsHOMkmYryLqCktWffgLVOq
	Mb0O06EsovYQUpqMaqSch5AFNaTuYOUIRep3QZptb6k807snrWGLCleQlAw9CtZM
	yZFRxRhedk1uxITPL7ijK9p4YqkaoOSLXtNZQf4kVoZ8cmDNMYqzxhR+pETqmrR9
	1N1FeE82MwFBp6+M8F0siA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yykbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCjFU004724;
	Tue, 28 Apr 2026 11:15:22 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012053.outbound.protection.outlook.com [40.107.200.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2jm5tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RC9xsJlqG2dI209VEfmdQhYnGzQzPinCj5UF65W5rWQrN+YBSS/fJ8mzn04xDlfgYw3icXFm6gpeliN2kogAun9kgUMVi9lc4iWvLgrCNt8WH9RKivklmaiCZaF42OAH7O7vEajrw0wGqDmMQCieE5nmKRIzU+oR1gNggTNv1hXjccGCv4+lrXEZlx11+pB3EIYN4bMSxCcho8emyOS2q4tOhtGWJ+sszYf4JvNa27XL9ipGViBGJ9sdpGtPEbQGfzqFGr25aLJlCF8zosqNmVXluHLm8TclZZMz3POR3AJWBCnkFQdxR11DQSwVITOVJDPBg2s45VoiUNreHP1XNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mD1qmOqm4knm8wCA1FONMYgre911vMpP/h9S0RGoY/4=;
 b=hiwqLAQdIngaYCA5xz/1KgY0wDoDQ9W7svhn7e54X+hyME2asZ3cIirLU+QDzO6ulVi984fJqp1wgY9lKLyU0YNjaTQA5TQ5LF2drb6Xj2LZbWR+F8q10QtJWbkTSXcymYAPBOO/XpXqhq2UEKtauZro0RfH3CWj8yLeJKH5lQmguA53UYyLYkMhbbq7dOq0yPrIMQ5oxE0X2G6SOJBF/WUtPudo4u08z9Wcfb4MqOZPjK5LJXgChKpPbdJTmCmtjYJrMuCz8IsNe2M5EySQB2W7Lu1GmemYYBsNEFfEik5YcpLDrrtNZdQcl9FHPQOAqZjuvYJ076wjv9i6RpXQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mD1qmOqm4knm8wCA1FONMYgre911vMpP/h9S0RGoY/4=;
 b=EeVBye7zDNK2XrubF8LXUPuiyBJ7QXbXzkD0yEwF5j1Z/xmhd744xbYbuAVHYBo1hLAjVP0E+paQkXQABI7/nEauwSTmAsZCeRnWjv5+xiXHE+bZiMP4PvFggY0pXls4byj/YaBrWg9o9i0yo4mEmsAkpDcQCb7mqtQj3Mj/hI0=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:18 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 08/18] scsi-multipath: provide callbacks for path state
Date: Tue, 28 Apr 2026 11:14:37 +0000
Message-ID: <20260428111447.1779062-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:610:b0::14) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b0b9ca6-0020-4c54-8215-08dea5176dc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pFpWBlwJQIi1ML0oqlOOonoKVnZwl1wZG4Mql/VQ4J6Blnu8ZuXXCY3zIV2bupzQ/uWGWmMwpQogyn4YajeUBDXH91oLe9XgYmPMaWeCEC5FyH66VvSVRtnNHlvN/4i7qLl0kuSBnISeYkxpBa6tzcGVhF4xnV5w6eTWGwF9FM6ICUSWHgq9QfJD9lx+CuGEA7crr/pSGcb0ETBlzR+D3/4RFP1sCaRUoujslOKS0fXUYKfASc5fNh0iP+xC2QYgYOsv4p6OefaxWBVL+ql3rLrw22hthvAf9L64FWUEVWxEpThRQBpLpQcYl91FJHhTl0FPlyhV01gNNgBGlWJ7TueZuYcHCTLrJL4CPsvePoJq0+U7TalARlUZel2mddwfaStihlZaHogfEnxhmojL3I9YxY/fHRXYHuvuhBAdLzoOFj1PUbkAkpbXThFJ4GMihmZeCSRXo2Ra3Hw92TkqK6SqrHy/PRYVCDATcQIviXf6g+fRqoO834tYxB1tKYmwvbf2aaxSlegz36fXj83in1Pj0GyDRrzj3Y/1DyUMJNJcKDM/c3qIyeTWiyHsiNUeXks6zdFxTZAa+vieA4FttmYEd+Nd2v0WXsOO6LCmlfHVbtwnFl+1a7NeQakfuNtb34DuOWCXKpNfUUSRdigzaYX0qYuoxAO9x8ZzLXcwtL4XAJrrWI35aKcy5+CWGFZhI4Ooe4dBPT2FWEBF58q9+hAnfAqJuq9LO2RnEv05tpw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NgrfvQbDB3PsY1o0iVV6yAyniSp3u505BQWuLkR84RNkQUWhI4GPR0TC5rz5?=
 =?us-ascii?Q?g6hQ3u1IW2q25xADDPtzIsVXonP95yrs8u8Oe5I/Ako2ZSTaP5jJeGQFVKuF?=
 =?us-ascii?Q?cXFegF2YZaS6gyAqZ/pIXRGUOkI2auIzq6Ss2n+mmjhE4eEMP6IeRqiM1LV9?=
 =?us-ascii?Q?632S5cp85M5M1z+QMyjqBdP2PcMt/n4LVaXVUY5HVjShCRnShnanPCH4r4pP?=
 =?us-ascii?Q?MfTRvOSQPccctU8pZ7rhhWXETdiHCZPschRS3d9Yf7+BpzBPOfQwCy+HpVxM?=
 =?us-ascii?Q?wflDKYRAzAvX/s0ajZmVsZA8/LOVtzXSoq+gpfIBJktdQ6xpDQrmMDtxJgrv?=
 =?us-ascii?Q?pZCHU8OFB5+j3kw5Oyj7ufbn6260jaKBGc46o/s381NoTBUD9OptfIEP+wom?=
 =?us-ascii?Q?fFEB6DhyKDOH+D2iBv5R4b1XgZv+bJdIaQ4ftvkB9edia2Ixf/gYwyrC1ssS?=
 =?us-ascii?Q?Xw3E/k90xQotSvm6ymJa4tcaz0dYL+zg0Zzq1yQfRDMZT1F+hrA1EI0DRBFT?=
 =?us-ascii?Q?9I/9yEoa0zCPkoUK9wx6by8ntHgL+3E7tUvKUiuUavzhl93VZSPTnBo1u2Jx?=
 =?us-ascii?Q?VPzMocncsn7FA7iLomCg9lvowP8aVm2Amd8txpsI8RIxcYrWo501WmN6rXN6?=
 =?us-ascii?Q?TwrhWoqIOWUbLXKlbxHo7Fo9+AdIWLVVOLTGUzRW44xbpheaFsxneD1gvN1O?=
 =?us-ascii?Q?Osh3RxStYXNZAMCtt9b5QSFXzqt5z3/IS+S9dwRiyrpBAvki9zBcGqgFIDFT?=
 =?us-ascii?Q?B5cpgAGl4N4FKLdzAy7loa+dl1OpwyneYQZcMpP2s8r2Z5UfTUVJapUtkqL1?=
 =?us-ascii?Q?ckIY0oBHV0iHuWF/LDiWX5SpT21MTeBQLPy5MCDdsTQDrDU7qc+lzWgJbnzO?=
 =?us-ascii?Q?EXqxVUanBd86XoGyRM2ct5/HoGOMqWBL6QuyeC4pXlhtSL23P0lE6zJ+UXvk?=
 =?us-ascii?Q?c03u+2+3ZO8PNehUnNVCl5cGmyVNGBO5RnCeIjG59eyb9W9PCNAoEqPS6ZYT?=
 =?us-ascii?Q?isbiPkpWbvxsA679na4liXrhL/vlYGlYSNxXfilUoTgZ/Gr/wPBvousSgo9p?=
 =?us-ascii?Q?Af8Lm4dSq3snFiSDPt5XW9s0voH5Pv3NT9G91ViAhkMN3pVinwGqFhk6zybq?=
 =?us-ascii?Q?xxLZcILse+5EeiQxHiGf/TggKlZymJtVNZKBZaTn/QtNbXfDJb0KtGmYpsCt?=
 =?us-ascii?Q?SuG9fObIUyhgETgw86qgAJ76y/8CEQ9c9ISKU8L8XR+aQbiXykylf7ahgvDj?=
 =?us-ascii?Q?1NGYVEHGL+XVptzYX2Ic+6IoPU9kA0j+Yltn9DpZrEosNdN/qs8k+krtSMcC?=
 =?us-ascii?Q?oEepQun/Wi+eOEwHS9YSpfB+oiwyp0hMIq23z9duj7OFDQC9Gpb8ZsmNh+5n?=
 =?us-ascii?Q?X+JBpN1jYsg1pcabF/OOZEvz58iIwE90WyK4el0tL4IRjIBx+B5kun3NUqJe?=
 =?us-ascii?Q?QjkZEw8HiBdKrEqQDZziJavN5+Evb/K228vARTZFA/oxlnJplGcBqibx9TBp?=
 =?us-ascii?Q?vScX9Zy5jxxA+2eRDXP9d1fc6qC7M7qJqv/uz8j+BT75f/62x7ubBdcK+PNa?=
 =?us-ascii?Q?JJQwc0c1cilAh8xVTMuQbyiUl3O6Bh0NkaNUbIPeg1efvubp2G+XZhhG43E5?=
 =?us-ascii?Q?Ki3M4O1clat8Daa0CtpjGybtzrywjpK7ZOJlcC8u/AxJSFeGYIpSYd2Vq4vo?=
 =?us-ascii?Q?LU4BnxihLtIyzoBy6uyGuzZXz4sb576Clc8UCv5jcuiVXgKdR+JGOVrVvR8w?=
 =?us-ascii?Q?IMkWiYKczKGM/KHVMnrNjYBgcPLYc0M=3D?=
X-Exchange-RoutingPolicyChecked:
	FaXRHQqXl947gRFhatf5gomaYKkBmBJ2lwV/6oaKm/hvJqDP6F39WyQyqMweLD6gCtCuiTnufZsSPnBz/PmN+esqv7oUPdXh1G2F0AlgvuiHe4n2b/JW6L1LlFrnjyhZFYQUlVnacZJJIwyAoMO9x1LCGXeOVTI2BUNwSBnQKEAeRbaa+0Z2BQw4AZpVLYDsLcSmPA2/kHTCRBJOQQNLGZbHNL0LqT2+3Gr4oWKkwoAgMmKSQzhEi3FFVZXbEqrWpaMKPjwXfejWcqbPJAeCKL5noyz8nKk8gSvR6v8iNGv2RhxQkxYRmWcrlHsQh1ju1Txqy5ekFKj2t/rCL8I2mw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KEH1nyIXbST1j/87z2qV6IYg1Bphdry7b8/fr62NQs9+Tr2fEqYdRD9GiSr5TNHWPF+1qWN9rM8jG51xTOjJhF7MTqU/Goh+FX48TPujAGM/1lwlCFr54cY3pXBAueHMqAfcRL4Sk+287E2SycI2g+/RSXDpvNod6jGJcpGSlz+FWa+cH47pYMn4EQyEsXOiwl1QC2JiUuMO7o8+3nPYK4WY1bCma66JZ8hiHAO+VdfEIwlWfULXRpcBCWU3UPm9HBxOK/MXwaBRZGOyfOrGaaBqT/Gcyu9sM9X+3468DXpaNIJkC5YycaZObsVj9duQ7hT2sOgkoR4znsT7ClqLLRRe5BhbiJjUVrE0nly3bVP7FWhlnoPnE9M6j+yLwb5WjI7gH5LV1cxCPzUzs70nsKjr1d95mK7cGGYnUxspT65aLY4rLhZyNuyzgIwBNobj06B28mDtSAdVjHcPlHyAsb/EbHWNkl4PM9IsdyG02lVxvssj/VcRb/B43Ecpe4AjfTviuRfRtd9ZVj+kkh012eb9qzrx32RmWLhcg5yAAWgAy5dIbQ1YTmHO4u7Ayp7IrmvrpNlyZglqV85FwPmKmewHg0eGjECcpSZbuxkG2ug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0b9ca6-0020-4c54-8215-08dea5176dc3
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:17.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8fv4NNFH7IwetpPJOYEELmYeMNeCTLQu79VkweFSlT2I4JCeDRcesgyik0zN/X61a6lGksk7OeBnIPJvVmzbHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: qg-b0mfwojjBJ2BZjgRTZl1hvZAQEdud
X-Proofpoint-ORIG-GUID: qg-b0mfwojjBJ2BZjgRTZl1hvZAQEdud
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f096cb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=DHJJM_rHgSnfI6yttmIA:9 cc=ntf
 awl=host:12309
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX7WFFhWh2Xtvs
 2mgpIU+lfaVQEymV1lJc1asNTQm0DgVFwIR5Q/nWQxR5EGKkyg35//CVUOeChScpKQPQEt+HRew
 y2NsETZ2uoIetAswJtwyMbRk3we77nVTfdzJp+iJuv1zaRShaREDX7y6UPUL8OC8k2n31A+V93m
 wD+/c2/ic3fxyTeiHkuRSg5kuUBujzHoNuPz9e1Hbvkfy2N58e0e1YH7hE0vW4JpfArYFz928rm
 KPR6P90LIxQbIqROGbfD507XOmjpbaa+vk3jclZ7KLFc9o+GjLzw4VZ2QAHXJu5TcAhr5B6I7lj
 atVOn+ClQ09HE/HL54FicPhGklrT20HkHTTvDNrty6pxgCjolE8R5Upee174aZzwaprhpI3omOm
 QRqClUuwxRkO3mzknitbXQJZcvTWZjf5RuILvl9UfokIfLSxndf3qrfHCRMg9DHGyZ2JiEecQ9k
 OqkAOBZeoMwoFI1mYTC6GMrfFzzYJypbfysQ+lRo=

Provide callbacks for .is_disabled, .is_optimized, and .available_path.

These all use scsi_device.sdev_state and scsi_device.access_state.

Member scsi_device.access_state will be driven by ALUA. Currently
only device handlers support this, and in future we will have core
SCSI support for implicit ALUA (not relying on device handlers).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 0dcbf12217165..a3bf95e2a18eb 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -308,7 +308,53 @@ static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_he
 	return mpath_read_iopolicy(&scsi_mpath_head->iopolicy);
 }
 
+static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state);
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return true;
+
+	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
+	    access_state == SCSI_ACCESS_STATE_ACTIVE)
+		return false;
+
+	return true;
+}
+
+static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return false;
+
+	return READ_ONCE(sdev->access_state) == SCSI_ACCESS_STATE_OPTIMAL;
+}
+
+static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	enum scsi_device_state sdev_state = sdev->sdev_state;
+
+	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
+	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
+		return true;
+
+	return false;
+}
+
 struct mpath_head_template smpdt = {
+	.is_disabled = scsi_mpath_is_disabled,
+	.is_optimized = scsi_mpath_is_optimized,
+	.available_path = scsi_mpath_available_path,
 	.get_iopolicy = scsi_mpath_get_iopolicy,
 	.clone_bio = scsi_mpath_clone_bio,
 };
-- 
2.43.5

