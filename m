Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95317430B90;
	Sun,  1 Mar 2026 01:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327746; cv=fail; b=OaB0VNG6KfNk20ATP3cSeJS/nLKw020gQ6GVyfbHBqpkN0TyjMC2S50sU0eCamKs4zw7oC9H7GifgodpNs9iE23nV6S1vLfxrYpDp+vo0fp3gzDxEYlDMqGnliEchyfA1WZKhBnLeoUktIO7Ox7De5ywkQuNqgGYvd5/RdvYzfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327746; c=relaxed/simple;
	bh=QTHiJMzbmVcU53FcBaQuvQcEl9JYjpVgLFC7ym96PoQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=D34V5BxEErOg87BHAmt+9G7q9UZLZjHZXP4SCVW9BMCk9BW8aIU1L3mmGgc0ilAr3m9L37vUQ8l3KFwudUepCwF9OStIaUxy7HHOTb4dd8Oanqu9vknNLiynUbfXmVW813m1zU7/tfBKrGxYfArfY5Nrp7rwfq265hSqViPVVbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q2tBfDxv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JfnNjPN9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q2tBfDxv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JfnNjPN9"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SNVR7i2255648;
	Sun, 1 Mar 2026 01:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n2kO5E658w8ljtXrOP
	o38GirtYp/axzRkoRL4exuJt4=; b=q2tBfDxvtBm2kugltNR6gdLDcu3XtaOyIB
	aBaf6yKbK2o1hMvAU4cRbviUEB3s+8KeyqNqX/IVQnYtC11sw/SFPyPJor8YXUmU
	zgT5Lz5v3f/fF3nLmWFyOaergdNr4L9qEREPChyvcoIJK+tFnhtKSgtAEZYVzjnU
	aFJooNBhX1D1XAg3Y2cXsdeWIMS6SW48nD3gCev0l+hPNrirfk5F0T3KNXVkFIuM
	XpDE2pxb4AdeGn9pAfrMGEveYYPzo09lFabof41h9v62QcKlMkGzoDHhZp5aeHWv
	lC+5lyvQ9/y0Rirfx9hTuwXVw1MWV+xYUZs6sWmOIf1BQJm+Fqjw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksqu8p8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 01:15:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SNefnu027513;
	Sun, 1 Mar 2026 01:15:41 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011013.outbound.protection.outlook.com [52.101.62.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7ds62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 01:15:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HeqijmNzrTVE/OnnsvqeNaF/Jr8uMlb70hF3iZKgBpf6HUCA4r0V8MgclzlNKPlXV9HDzHkWL91A7gAf9GU8bdlDy1gXMViwRnOrk8xucS7GjVPEZ6iiID+MxWehFH7QwUfkHHaG59WVhWO+Dty5lVqHn8HWLIN9waBWx2Mwn+nS66XamRhPQbNJGSS1cB8daoncV8HzWEhXHEPcPP+JkrE/JDp9PotXy4yKPLcnhFSbkJmhPjnytDCnoH30sUE4Z6awupOeyvTCU5kALWh6RuYx9Z3ymlJZ/jMZmwL+nTknEGA+JOLfO0053ScEpFAJDyg4MDol1JBQcegOvCSBdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2kO5E658w8ljtXrOPo38GirtYp/axzRkoRL4exuJt4=;
 b=Aa0TIkPRyLWHOQCZ3+7yfoO4erHtt2L8f1pRUcGJRfzoz/WsyNHf9eIn+TSX6I0hT9DmcUbmHERWq/+Txmo2GN/2fjtaMA/kuNcyAVLQRXfKp1eivbKYVOCaFWb/bZedNiiDBKVbSG1c+X90KQxjBik5V5+xN4vIxOjYs9dWWI8bK0ikoSDDtt2qaIQQ3aLlH3vvTZJCtpzp4lqlME0prz3+ls6TTFy9H9lynVzWMVoA5C1cmJcdo2D3XjC8Twv4rQDVVNL3gPtbtHKYayqLNEcJp8guOfpx8A8Akh1prVYkHp7UNL0kqDGsWIr9BFmzZPVfZrfuRYUYdfQAiuM9IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2kO5E658w8ljtXrOPo38GirtYp/axzRkoRL4exuJt4=;
 b=JfnNjPN90kSJpM4F9Oq9ejutTI/PXg1UJZK20GBWiuLN3OHL11dsL58QHBAWA30LF6eFQ0XhyQA5oB9IbGzQMxqmR7OMBOX6FVbrCZbjHETE3eZaOZN0/mAYhJHKBRzamgAW721udvigfJr4jA5+633Mr8sV9CXNweDjsTg2B4Y=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB7438.namprd10.prod.outlook.com (2603:10b6:610:18a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sun, 1 Mar
 2026 01:15:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sun, 1 Mar 2026
 01:15:38 +0000
To: njavali@marvell.com
Cc: Vladimir Riabchun <ferr.lambarginio@gmail.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        skashyap@marvell.com, himanshu.madhani@oracle.com, qutran@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Completely fix fcport double free
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aYsDln9NFQQsPDgg@vova-pc> (Vladimir Riabchun's message of "Tue,
	10 Feb 2026 11:08:22 +0100")
Organization: Oracle Corporation
Message-ID: <yq1tsv01hdg.fsf@ca-mkp.ca.oracle.com>
References: <aYsDln9NFQQsPDgg@vova-pc>
Date: Sat, 28 Feb 2026 20:15:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0083.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB7438:EE_
X-MS-Office365-Filtering-Correlation-Id: 96220329-1357-41c5-41e2-08de77300c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	IGWy/c56VdDvSv9vJSjPbFKMseE7W25ODPyQPl6yCouGVxASmGquIKgPQp78C+kTzrTLlx9FVf5JSq2cabNWtF3+x6Xu7SwwqVHl8ZpvAtnq5md0MTehdXrz1y6P4hbCmqMGjTb/BAIOHXTVWQYer4/Ox4zEvpz8IsI0PtGy3HCpwn8q0gdt2Jk2Vo7Y0bmVBn+FJaWu23uEkufp8kdLG6t0mPzZWo8bI34LULEcouGFmZppYUGBVZQSt+ow1O7kvD77wa8h6DMLAM7y19TR5aFUldD+86L8ij8UFMtwEUT27NXRDFj/NsmmUn59jJXQ3i5JsxS/ZS8SDMsUDiHB12mtOHf64QU1P8hU616A8HW/eF8v64YRy6hDy6wWd5NEy5ffFqTBHbXZnHAYreeID2wkTXsx4k/EMksblSqQ9WVYYnOHnsJazTQaAbZhdb2l/GrXYvt/xXW0VNJ2Bay61TUbwrWZ0xvxoB24seK/33Tfa5kXd/1vw4p81u1DBUNFG6Vv9T2fYnB9JBK5mXHTjHTnwPrcqITEm8B9ioChnkK+JMo2lCvcmg2ID1HViyP8tBipLTm4To1H9gZLhHRClVnK9/QqCPtDIgHV45DzjFtW7jA93D2r5jC490tBgl2QnYsfe/iwAxXb0eqNAyq42ZotDeplRZ9t3RvTPb5PwufQPemDlD15+dJQll8EnyVRVm28A7z+kNyZ7UJ+Uovf3P6fBeDagomoaJakygY7dvA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9K91Cy6tIl5cykclOs6p6w/xeoDGOt/wdlcHwMkBvmrbluHEsQ/8ZSMCIv+n?=
 =?us-ascii?Q?s0NskU8bVuP/XpSQIpu4kY2cME2xtfus9I+gVCcwpv8G26QX1557heWIw0u2?=
 =?us-ascii?Q?VkfGSNLPHkn+GUp4kFCkidImXwrjcB43f4Pe6fNpTOuKEZkQVyQQcYUZF2qL?=
 =?us-ascii?Q?Du8V38H4v5bLb9b4wlRW9eLdv9x/68mmjD/jVtAn7HtaKs2/QtR2XwzONrxS?=
 =?us-ascii?Q?WC+q2hhd6Go1hcyRP7MF7TuRnadaYDczG6fGe23jxRcAuYEP7JuU8F7o95Db?=
 =?us-ascii?Q?oCSAK/Z9YUgMsCqYabj49/QcK+FI1yCmRetV65cXhQibKhYm/mPuU3R75WzH?=
 =?us-ascii?Q?YL+GqiDtXOhXqGGcx1qR1bvmzPpA3IInHeCq/oyXBR21Pdkk0MBQJsPqcqXy?=
 =?us-ascii?Q?v5gVkTlO7sbexaa74SWKqe2p0J5n2kBDrIKiPCtOxhv0yVtYsn50nglYAIIb?=
 =?us-ascii?Q?Lz2mhb6Jv99XnAL53EolkhyZg+iSeiXBp6/13AqCRerwiyecJNAUxFhqtAvB?=
 =?us-ascii?Q?pIVXaj86gHcjMl3ToclwH7O2FHU3qn0bqJIs0DWeyDawOp4Bl8m4DkPPFYBV?=
 =?us-ascii?Q?Pzx4iWIHhiRmLYk7wTLvHgTVH+U1VGL4VJkMZ1oNsQ/ZGNwhzjKgZ6RWEdRJ?=
 =?us-ascii?Q?tv04YsP7W3plZbmVS2d8sEtxyQkj1BCo5dErjwjHTsjl0t5ChDBUitVkerlW?=
 =?us-ascii?Q?eZGqmwlO04loXv5gvyt29s2ypidfuSsKOndg7f9sM+kW/lyPdGJhYVofXAwH?=
 =?us-ascii?Q?HBWq9VZezEwc5oLTqWTwKESNi5qZ0UX4z97Usm15gA7AnIKMGU9VcNjecxyd?=
 =?us-ascii?Q?9R+pNXNETQ508P3ggiHq8hCDc3etFCoJI2NtXrOKK3dXk/QsaCqc8WUsBAsS?=
 =?us-ascii?Q?Nw7g8B4SGoT11GLrgQ8tO6OnniRQbSRG6Yx+KMliDyCSc+EXfA/guefQSgTA?=
 =?us-ascii?Q?+e9ui9/rkmN/4eDeP1em9M+p0bhrH9DYlIxQh785VIFZd1C2qsh9sKjKCWk0?=
 =?us-ascii?Q?3uH2i1FuOuAkF2SH3SNtcaMxbQVMKpFHeGTaxiPDNxnLNzLIS8IO027bA6C2?=
 =?us-ascii?Q?pu5HtKg+sIs4E63AZt3CMGhpKEwuGypUeffcrrdURiGUo++VoOKl3lpUCQK4?=
 =?us-ascii?Q?o9xy4i9e+vuAZhi9G4vXYWT0FiKtL8qIxXGQvwz/pYFam4vjUbWTW+JxFtU/?=
 =?us-ascii?Q?OR1enZLUScrYkJ2fysFSgXISyI6HhF3REaoNDCjDFXQRHku6VozUsMpf4qag?=
 =?us-ascii?Q?84h5E6zfScLxM1i8DVm//OHRGMzbYrEuJmnnZgrj1IplQFwim7y7YnVCGCnA?=
 =?us-ascii?Q?YwpVjoGMKdfM3UxgrMUpSCa7hueR3HJ0V88Gd09xs8ybI7oKT0n9agqJ8Fpc?=
 =?us-ascii?Q?8T/4OF0BMpXBycrvKVR5Kn0n2HCH7qPO7E+v49FhMIpc8mRLUt/RhY5TtpC3?=
 =?us-ascii?Q?HEQ6IVyh3exA0oIlfD5R3FiY9eqjqVBb2Wg4SPLAMzi6AZpspbzuaWGdOjzo?=
 =?us-ascii?Q?1tT1H0JspoiomPnga1rKqi7CibaKMAkTW5Q21x3UN5m4cV7+EO7M4zmHSSUY?=
 =?us-ascii?Q?mo/nrR4Fno1bqsxZ30UJV7ygplAc5KPUtOfgtyhYbGt5zAPSZio9EG3NEjEH?=
 =?us-ascii?Q?BkmAdV2hQ98ATYAzsJ1UV5PUiCNuPZUPTICy22sIw7bHhIXx5fKrf/t46es1?=
 =?us-ascii?Q?Om0xhgjlthIXpkf4JBVExFugiCXGyVDXBufOn2F7UCaibrmaZtT1eiZtH5rb?=
 =?us-ascii?Q?ZyIljylYEH7rjNhMevKmI98kGa4WwME=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Lm5mIiBkzVJYHkVeYoBbChMuTgipvaP9GLm3sz7TRc3yvJ7jIFhQlZIMqQ+w1qUnJU6qlY2GMSdrK3FB3R6LxDCoIu2naqKklowe50RHS49IpZZfgu6mfd1aPQsLuKJp6R+Zy6xRiK50xbXyFIHFh3JcQPvupnit7g8WwddnDCgDIbKJJ8b8ioLbT00lG4buRcKo1udDjpj6yLsSwNgQJaLzNQ56TbrYnRyjF63nWzMXAKB+tAu7PV76VDnwuCBINMM4G9ceu1RYAs7FKa+CisGFTEmlW5xGzB93fsWk5GLOFklCJLzSYafK/TmwwqXWYWPl98Tx2SjXfiGCHedIJ1bHlf33YlsjjIBFnup9lboJKrtMD38q8JvpaQ1Rj1D0Atqx9ktA01SGGgMLceKcbtjaCSlldZVYQDtdmDKLetrQMExSECbC8rduPCOJ2H26Ujq039EAJtTMN+Zh7tAXDAQJR0jVdUDYUDfi1VCGqAO5tD/prrjTq66Cwoz+Pd5RqjZqeX+G1QE7oXNmGIUd33rqawbc8OeS2QAJbrQCSdG0DMHnB377zJkP+jkD+LUUZs0jSbJhHQt3ScvgJCk+2ccB3HrN+tNwSyJO3HcfSME=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96220329-1357-41c5-41e2-08de77300c74
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 01:15:38.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMZoIFol8oeUJujkih7zZTpdtDThsWxYjE7wpxns+p1BjZ/QI2yeYgk/IjF1qcmnANZhWgCDQUbs/MUjeUB5yhQT0FgYgyFq9rU3eabF4KI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7438
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=436 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603010009
X-Authority-Analysis: v=2.4 cv=DqJbOW/+ c=1 sm=1 tr=0 ts=69a3933e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=IMSr4KHKDerwzVwD5LoA:9
X-Proofpoint-GUID: tzqXMabykeKBEHVl2DXb0VfexXPHraYX
X-Proofpoint-ORIG-GUID: tzqXMabykeKBEHVl2DXb0VfexXPHraYX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAwOSBTYWx0ZWRfX45IVnMhIFQ10
 EMzDYZMmSmcP9jcjeW74RAbeFQX3ELZ0XXH5m/5HuLb6UqfM8NHABe5LyMJOp5jjdE0D/WchRyS
 PjiNZ4tHOaXC8u1pO3/IRI2gLcvDj6mEZt6K2ayEGLH9RPmWYp/UYZfjO+ZsOPgdGTowUnVy8/P
 SVM3xM5jO5xZyaEFGci9AyLkuy65+y1O/aBD3yc6+Gttr7ka/XVK2Iib0QIFabjvxlAFNkqd71g
 rE1SuERAogK0xwl7k+OZDp1GL9Pzx6EeNPxhRm/V0eTedIr8b2ZbucVlbXJDk6tBJsYCJVKA782
 hnTTL283OhvGt2Njm0l/PzTLsyYVF5VvguHZqJAqkMxPto39zkETZJ/3EUMssxfwsqbXuYBty0z
 dPedwmQc4KdYHi3OFATbn3tb18XUeUpJwVrRSAHTKF95NGO5HGU9SB6189Xf8Sj0ybAqxJqnVQ7
 gze8VAfto2vsPR13jnw==


Nilesh,

> In qla24xx_els_dcmd_iocb sp->free is set to qla2x00_els_dcmd_sp_free.
> When an error happens, this function is called by qla2x00_sp_release,
> when kref_put releases the first and the last reference.
>
> qla2x00_els_dcmd_sp_free frees fcport by calling qla2x00_free_fcport.
> Doing it one more time after kref_put is a bad idea.

Please review!

  https://lore.kernel.org/all/aYsDln9NFQQsPDgg@vova-pc/

-- 
Martin K. Petersen
