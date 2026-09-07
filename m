Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED0F483BDB;
	Mon,  7 Sep 2026 10:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778329; cv=fail; b=rdRWxitoBcR2W99mwQ/FJDfmb/WBhZiIGWRxAd0LeQ9zus628tZihDl5D5Ziu3PRNpSg+wL7VSgvQM6N6aD8VrW7EEtuCmJl/49VydjMdAJRsEOq3cHSGMq7WvjyC8e3RZcndx+BCb2jFA+2vvQVUi88kNFThujxpT+1GvBJv90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778329; c=relaxed/simple;
	bh=OFVKOe+lsmHmuCq0omcn3uxsuRZP87isof0hIZ5sXoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rxOQVLFFQoriYhvdm55jiQqMXRa4WkcNjsmYyu96+SZY6LYZw5XxNPMX1yrgJEP9fUTPXl7aT1ZP3IQ4IJWLUSvNAG+ZM1FXjx9hPPW4et4sMNVS23THnelQipqSNvBX9WHScvtAQjXtQjvGamSTvP0fEjUnNPU4LHAlNqeZFmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rVEdKXaR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J8NhpCTo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rVEdKXaR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J8NhpCTo"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68700hK2137039;
	Mon, 7 Sep 2026 10:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hSi7NiA0l4fTaLtYpqS6Rx+TIcgVNszoNjieFIW5moU=; b=
	rVEdKXaRKGkXXlxRgPCOVDUGtRBtwTQi1C4vRVMVAJBQGhZMgXE7ptmKTLRabnNx
	tsAXX7gFhACow9HbW7kFHf8eDZKrXp85eiASb+PVIE/SlQIrWHV1hY0a4lvRHlZ7
	poHzNQ00zVWgy139E66sWleCwwipfcvzj+LQqKzQAOQNaX+klimNxAfyhXgk4C8o
	PKzqi8eYGKKBzVPjVzqe2koRnf7yAItMTOpzwV4yWwDS6Nylpc6bLi7tVAst/h/h
	9ENRdjrVy+bLsyhDdAutiQw0M+IAY61HuMs0S5aAcB8aErS/z9S3T+bYRASPXXhq
	jfgl+xSUN05R5J08FK+gDQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbmq9t42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfK019106;
	Mon, 7 Sep 2026 10:51:21 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-14
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzyWN098yE6nqcJI26j2PzWqdIPgh2l5msdI8oWdJKKSCiZxBf3iVNOyaDMubYp4KJwQEyv68DQGrP13A9RotQ5K3K1g3VTioj71iTsKPlxqh4GlLKkPikB+NQVGeZS8svE/03GZHZfTz0cmmKQ98Jy0sx2UiNdO1dvY5VZCuVjzvCByijolEFl80zB8C+lhTrLI7ueKcNwlqG14Vpp/itOHLzGhZZu/IuWbqwQ1+NLPQhyKRhs/u4TS/8zcem/43e+SgIjVI3VctABb8n2WvGQGEFPCNsevJwZGujeRSIM998uMrBYRN5prbXQEWiccL/ORw3iym9yIiYQ1vSITPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSi7NiA0l4fTaLtYpqS6Rx+TIcgVNszoNjieFIW5moU=;
 b=CvB81SSvruaHEYoAYoZrT/F5qrW1z96nlSNXsjJXMuml+jwN6C5m7mceyWr2E9n5zSB/DK8j5i1DCgy70ytXOOaIFZZsHc7j5z8cgovzQ7aD6MG7kZhyjfkJ8xuahW5uc1KRkdBK3xCut3XAb5bRWENdypva5hL8K7Hy7TDFjdYo77MqEbW1/i0oEYPeo6oQr6sai7cpvJ8YpHMoVJOPBY7I2PLVlP6g3RxSghYrq0FoNdAjBovPBFpB2CxJ57l8EhW5dP9PLHZWoiBTuzMP3gN8FYhWno7KW6GrsgwsnNcoD8E0Dh70wsVyt0UDV0B0BLPyBUi3qxc5ANBkT3yytA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSi7NiA0l4fTaLtYpqS6Rx+TIcgVNszoNjieFIW5moU=;
 b=J8NhpCToJIDhTEC8FcG/Xu2YzOdlTP/9O53BZbllJHWGQcFzYB7nDpF0r3VZF8Rl8oTXjbAvz7B1z62XPMqOdHtmLgb2Ww1dnNggiBI3ehUfYad232T6ZVeTW47utv0DlZjP8wA+vkTeEqKyltT7VFiI3wH1zt5QjnQFzhSShVc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:11 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:11 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 18/27] scsi-multipath: failover handling
Date: Mon,  7 Sep 2026 10:50:12 +0000
Message-ID: <20260907105021.1763236-19-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::33) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 99cc62e2-0602-469a-165c-08df0ccdee0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dca5NJttUaAzn8F43O7xsDAJecalcJD9KS8ppWQgqQluMbO0nqWjVAu6whkWDnq6HVagP6Sv7ijdIEUSy2DcsCDz1Hn9trcVfHwaidFMC26WNNqGJ+f/YaxWXHQEgtCnz5NfOEdVRhLVtTYaiRI+YcF6wuWs8MQYikLM45YM5/boejSJvmucZhFKx4twbVtpKfdfnnEj4N7EH07WvzFvRMOtzv3v3JjSZk1zmWhfXqcdaMDbGvdJlvo6btCtv+MV5K4gHsCACLlpcZofWQ6XMJNa/RxL8l7+6r5NJ9dfFv5gigrX+TOYplTnch0orNB5H/3yk4HGWGhYvpfpbG9k2rlnbw36DmFcWzurXeUP6A3UpUvU+fj/J7XLZUdb2vy2slnhDyoNChqIe5YO5b+LXSrUh3rPOb/546ijwULvdwDDulMHX2GZRIZoo36abq7SRpkgn3eyj48x06mrx4hL8369B5y8KO2XN5jtU7YJ9kOB+MkZ5NEuw0WpD/uGXeG/8BaI3Tyfl4ldCUpJb8rOKQbmejegRPoVXEmieXy6er/1wbN8jL82OIlGFbYIYy7GVQbSm2R0diMbOVe/yUWTAO78liNCkAzR6Vx/vb2aUsIlh6FRw+4oUASNTKCP0qThLNgVAE7DcMA1pUGO61SX3i2D432M/OS0DOVmr0NSWFQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QtsJbzm/8TGTwgPXO6rzrrmMHm3WQUW8jaKpkPk99b6qxHm3QvH2PenPEpMa?=
 =?us-ascii?Q?Rns+DQb1B6YL0bfPUCwVye8KSmu5X2tzmXPh2mAcGWRMb3B8cAZ32EBJCoGA?=
 =?us-ascii?Q?uk4/mdXX5XnQN8vhGA8OR4Ug3mp2ZroAWrTvbQqouDFLoKE9FPlDrI3UA+ZV?=
 =?us-ascii?Q?mWJE/O8IjAMJjSegjtY2VLsjdTdPuTZnQtn6jELdb1oTcylK6gPpeCCV6xys?=
 =?us-ascii?Q?lW4P5u2O4v3wbeRKHZ96z3e3O9XLqjJ5KouShrITC2YGr0GXr711fzB8Ifny?=
 =?us-ascii?Q?eI95n3CjCzHa0Onb7z/vlV5yn4LGg+LtwqlvMqsrx3OYJVwWeNGz3I0MfrMi?=
 =?us-ascii?Q?zW16+2Tku95QftVL4x9t+u59uUmad4lePUJk8rswJ40alIB1xahN0nDkCJDe?=
 =?us-ascii?Q?NB0kPRs9rozaW8rY8tcuKax4QRmoZvAvmxkYiWgF2KDsMiS/ihWvDosu9n6Y?=
 =?us-ascii?Q?AH+LNTHT+Fi05yR+0i0uPKn6yfjbYg+AcAaRXrP1qwn7f2sacY0yN+lIl+d9?=
 =?us-ascii?Q?fodMpzjwdrNN8jZz/F6CX7Pgtm+lYFxl1903vDG+UBTQ2BRDcUGpmJEzJNzG?=
 =?us-ascii?Q?pVyScNTT9zHMTWTnbQPe49t9yF7p15R8np4iZb1Z8i7OQ9hdhqsAOJXNFBJU?=
 =?us-ascii?Q?p0DeidhsANj3Ahcy6EI89cKRqzd96i8n04BNM8NTH1jPW5LEzHcbzWr7OnsK?=
 =?us-ascii?Q?zgk8kk45puhaVkU3RDQlzcoNZe+F4+VXovGk9l2AbmqBELhOOVXzgbZaqPKY?=
 =?us-ascii?Q?MnwT114Yp59L/XHqKt8kdM2r1b0ovRk8K0aY0zoqMsGFgLVdJ0uxFPrSyIH7?=
 =?us-ascii?Q?2vuRa702gf6KOzg/ffjW2OAfdJ/BD6za6/UDhudINx6q3mX3AgB4vz1zNqBj?=
 =?us-ascii?Q?owD9vRqWa8DMG2CbDEEfneFtwACZKVe785tQZPUkzFQSd8BQBFXGsasLxY9v?=
 =?us-ascii?Q?ugeJrhZTloEcQ3gaZXpGZ0wpDNtQvP1Bxv/ARJpTshAOKgZ1jggDYqCMjO3B?=
 =?us-ascii?Q?TX0Scm0P/ZovE/K8IsDyvTmJ0/B98qQIwnd08wDpO86FYw56oST7CVWOXUN6?=
 =?us-ascii?Q?NGxaSfdPeHYaTROiXP6HYoWlkpK6ujIb4XcFrQcQgrTAtvyYr7C4ki8k7QlE?=
 =?us-ascii?Q?5BgBNd7HtsGHyud2kpw/CFJthXGMIReIzy8nAtRR7hKjwQajfUbcCeQVRl4a?=
 =?us-ascii?Q?EbDDThlShRrJsaD1xHmb96DXfDn6f5o58c4Ykppew78+Rh0XnX2XErQBxbT3?=
 =?us-ascii?Q?x8sqSnfA0LvtnOI7oW48aUVYtWESh7IYiERB5iVdJi2uFuCHJaswSyjRUJ3O?=
 =?us-ascii?Q?knKHHnpoxgF9/e2BY5eYDTwq5XZbY6DmOo5V6cgsK8njIC91a1tDqbzt48X1?=
 =?us-ascii?Q?6HGxmk0W86yVuhguxq1bhv0NjwN8iZqoDX02zTvbgL7KIXIOAAQJtxT2btOo?=
 =?us-ascii?Q?bgTBQrQui91tc3WblbP+duI3lwX8mQbjMJ6UrkLNR9lYMRWTxDB8JgjfNThj?=
 =?us-ascii?Q?yGWKCGDzFINwayoxQWOrcqIOiCQdDhXr2eKOhDUsNGKbCch29o8pPhSywQsK?=
 =?us-ascii?Q?mlAdVlC1PAWgll/SnAbUbMI8VOGMpNrEaJQY7E7PwG1wFBolWYLWiNhNOP8N?=
 =?us-ascii?Q?etgAEs1UrlhisdmSyU3iqUe24x+8M2FhzxR4ul9qUz3FRostsLnczyZ3A94n?=
 =?us-ascii?Q?rzMp/20CO9nsXAs0F/36T31MsyUYoc5bWicfCbaL+gZlDuZUhflhP4XnT5pK?=
 =?us-ascii?Q?6hAn5p92hg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	nOdT+lBniicVxDZ+6qejmJxQuhzxpsJv08lxXRiW1BPnmQ5oFJsoJdahaJFwpKuUksgYqQTcMuJQYnPH/3rIsY04r5IZcJaoumoH72QDIQmcYbNct2litPzBjlB6wlk245ODPXE/wWyN6kuFzQiyqTmcfB23om1keFDbjuaUGkL2XROAhKX2SHl1c5O5WbwzEcAGJnxGtV5gEi7L7B8VXbW4cKh/gVlFdq17vfvthDebf0yFxAIoDQJoENWyAt1JjGegl7+fMUrvwup7bKRlI3T/jn4NCXBt8BlLeR0nPGBZNEz37N1s+WdAcAgd8x00wJQCqufMC/Uf8sNumeM7+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M9KCCbY0JPzz0xJMAUeVOgptySBxDkABlFO8HqV3F11pGld7CPdCJwwW5Z9LhTEveXzngz2huzzzpYJa0vQBjTba32hlL6fn7yn3dO5xXp60/WU3vHgO0ESQxNtshMGQa2AiBFmkI3+vxHWlMDFi1JaNlSuuL2hDl9HC5pNfTJkgD0378Irvc8H/wWSC/FTjs74r+g8cYaXAr0Gup5TPKVBZvaNoe1Cwa0Yco6bW3JtvXryBjhEzWmAPnwq3xg1b8so6FFUrV1lNB1SzrpAdEYx6GwW8RHFLtD/7jnLBz8344kwH2m7BGf5oavO//nnh1kQUKNDxAR8wMOY8bHkmT+HgGSzVoysp4PZZtOlbwvJ3C6P7T5e34mu8UVTxzWJnM+5SK7fZg2KKS/lGKbdF2yMDA1rx8+SBkGokWKxxaPxXSGqevu8F04vYk/6uxuCkl5sVHs811HsIn9W2or7RCsQhd/ZNWSb++0jYsEbVsOdzufqvV+T0AePIaxstczDQ4l+V1eSrtc2m2tjvGqYWSNzf7Oo4UesOP3iyz+IX/F8UUhVV95aA6Vo3n0GQj0BVEq8yW42b4PHXHm008iUgT0O6ng+sN6usJ9b1dkhafcE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99cc62e2-0602-469a-165c-08df0ccdee0c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:11.3484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRtZOEqIO2jYXF3yc691PdlfMm+SvuV1SiUd40ze/vWD4cMw14+LONNoGZd60rrwCoRa4GEmS2zTXaF1hbh50g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=JYiMa0KV c=1 sm=1 tr=0 ts=6a9e9729 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=MDoXrTVN0QxiaFRtCNIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX+eRo3+GdainY
 lBF2cHYl61PNENWSNFjTy/bVDo+5vwNaD9L9QDmIPKW7VH+ta3ZgYRjMX4bJDafs9Cn4mP9Lct/
 JeDRr1GPu527PO/o+lHSI5LF7mzt4DZa+WIWrGYehpvPrZm5HtzY+WRImwYNrcEu1TehRmKnNma
 AS4Z+MYK4z7X2AVUG/0L7kvIgcX1bOOBXI+5J+NR25XdM56/dyvG6/jrZS+3ntFHf4Eav+8ySDP
 kwuYVoH1TBPapBzB7+/A37uepsFPgFNcg5BDpYk5GO1cShDcONJJBzLs+Woajrz/2rfD+uBVfYF
 Itzpcn4NGr3de9U/ng35Ie+dGxIhMGl0wKWBDaANuAvOZuryPx1fTHYTg91JFRcYJ1wjM0Lxub4
 NU5TMD9lBYXWjBr0/2U2XyMFNlHcaqBhOMar5qtfPbPp8fLajezS+gWPpzzb2YaXykLLEvFIIsA
 3o18eK18v4ttgZyHnFQ==
X-Proofpoint-ORIG-GUID: HvuzPnq08YhsA7I9k21GhLAF0v41JoXs
X-Proofpoint-GUID: HvuzPnq08YhsA7I9k21GhLAF0v41JoXs
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX4XKfIv/VYsRY
 hFLX8+WXf1sDTHhlPqDrM8RrFBR08MoYgu/zmeiGle59Vu52mH04ZuVhkDu5TviLJlILbgpzC+t
 8SrxTWJPj2eFq/HhYDdA+nxVFSacUAJaDzmIiTJHdEhnJxJ51Uwc

From: John Garry <john.garry@linux.dev>

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down.

For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

A bio which for which failover occurs is handled in
scsi_mpath_clone_end_io(). Failover is detected for blk_path_error()
occuring, same as how dm-mpath detects this.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 456351fee4b98..12200664ed676 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -256,10 +256,34 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
                mpath_synchronize(mpath_head);
 }
 
+static inline void bio_list_add_master(struct bio_list *bl,
+				struct bio *master_bio)
+{
+	if (bl->tail)
+		bl->tail->bi_next = master_bio;
+	else
+		bl->head = master_bio;
+	bl->tail = master_bio;
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
 
+	if (clone->bi_status && blk_path_error(clone->bi_status)) {
+		struct mpath_head *mpath_head =
+				master_bio->bi_bdev->bd_disk->private_data;
+		unsigned long flags;
+
+		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+		bio_list_add_master(&mpath_head->requeue_list, master_bio);
+		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+		bio_put(clone);
+
+		mpath_schedule_requeue_work(mpath_head);
+		return;
+	}
+
 	master_bio->bi_status = clone->bi_status;
 	bio_put(clone);
 	bio_endio(master_bio);
-- 
2.43.7

