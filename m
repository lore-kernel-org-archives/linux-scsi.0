Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7DE3D669F;
	Wed, 25 Feb 2026 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033866; cv=fail; b=WE83Ib4BJ6pAlKt2R/clRfohZsJiZkR/uLkSqdR2BMOXVD9SLfac7fERR5XPjY0SQ2tSZaM3XuhxRv49esKXtf3DSw+j98TPZNCxTwIm0K7AD2/vRP8GhLgVn5JOjHXh8LlmEC0PmWOfmi94iyv6EKi2aKA7c4rkIBrTJ0tQ2GY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033866; c=relaxed/simple;
	bh=Nhv/kev6euaNxYED2ELIthL47CueFj2RrYEehi99iG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bnMvGRK8Mc0l7N2c/7nKEySnQeAajJ+NiRc3u2Qtwc2ergOUPZBgYx/CmTxZ7eOUgZm37flg00VjL2iNbRijBd+FQm0gq9T2CuQvAV7FFjy6ZvhbboH5ArzcqhbD9dP/ypopUvjEOW2VXfjyUqZ7wYz9eE0LXUW/Un/LBV9xClU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IgKacqT8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V7zvFkNr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IgKacqT8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V7zvFkNr"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAfTNt359637;
	Wed, 25 Feb 2026 15:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7it50XOOBptMHsQd5rqt9P+z1b08O3963czVuJuAmH0=; b=
	IgKacqT8XTty6JNKt6WNTKuJtPVwM50xQ2V4af8FWdhjqYhjmS8z6OLmLGKzdwSs
	NIXW2G8jink4i6aUVNQczcuuAepyRit5NYpeoxQSEtZeT+Krh0mTrLvY0Z3MWcE8
	Zl+aKF99oxgyn8Kovn5fH6dlzQxJeVuOmV5knSiczHX2WEvYMFNwA882dnZRlSQk
	X2kasYrwWynPm+rtpkQKzqk/kt6qaOlpBaYQ2llt4DzwCkDcaRhBHQqCoBOXt4Aw
	S4y+0KlsSF2Fmmws7LZT0+EGTetWuuvYX3KJEWIx8ECgmN9cSInaVcX3zTQ5VypS
	iA+CFomkOZBRuMx6IR+kRw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7xfgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFWE8t038454;
	Wed, 25 Feb 2026 15:37:15 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35nfrbe-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JXmoJhA+BOa+S6EI+8URItPkRPPulk7/lB67DVmtyfPwCbRkOZwdeQY3ZAcu/Ipazcj0oRhDEkHo5w3MalivJTzDA7PnS3ouQh6nMuSsMd59RiC8KhM0Uk63dtcYOoFjVLn002TD5ZxUDV3bQlj2W7M8+zrk25nTem2a2Hwx0VfT4n1W2VKx3wU8GmNIHsADkrAll71LNSn/QzB+CpLsm+Sz0ue2C/BG5KDrqkgrZ27mKtX4T49ctz/p3FT8gcB1EW2KpqWD0RTHdDDgamOI66yDrKg2KJ9eaaeDscwfKinptbmIiJMd9syvNlujRtbiAyDDy32EEQamibRFyjX63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7it50XOOBptMHsQd5rqt9P+z1b08O3963czVuJuAmH0=;
 b=DGxEgmqFa0ANe1NlmO7OOybig1T/wMLpNjsFxJPEESRjw7x0k645VJ1f9qm9gXFHtF9bjs7dg9E+JBXuD+IRrAtulctlCLVHIGXU5bMDqpkX3ezzA4ZUJzONIfdEwaIiekc4S7UKfXE2DjZrjsUWNx3e+QJVaabyzmRRYMqspF6ple+fzu6casGLv0XdQXQlJ3f81t0mYL/WO01NwVn5QXECxnRIOjpZ5rkPhSE3v9NtnaTvUdkF87Lqsn4OdILXgdHq8kSWbtNuF+kRwLu8j1nTa51lZhijy0GfTdkrYG2hLbfzkPKDTTA5BdPhOJEVc+cKn59lccNgOeysWuO0AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7it50XOOBptMHsQd5rqt9P+z1b08O3963czVuJuAmH0=;
 b=V7zvFkNr/Zd6bXWNfSOuvREgx+xcgV6SuNMueUyoAa/U6XA6iM5netz9UzXsl29oaCMODP/ib306iMBet8BUmN5rcPrq315oxPJieaEOeQ5jt/lja8v86LHq8tqlU5tIORhUm5YtsgO4j7hbVCP1Jndcdgy5HOm7ZIoBiFxfFYQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997712.namprd10.prod.outlook.com
 (2603:10b6:806:4c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:46 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
Date: Wed, 25 Feb 2026 15:36:05 +0000
Message-ID: <20260225153627.1032500-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0003.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::6) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997712:EE_
X-MS-Office365-Filtering-Correlation-Id: d149ecee-2655-4d93-a147-08de7483aee7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	3n+rmOOpvMADfXWhFdqOkmbJTRjg3sBIJADYHb0J0p6ubnIibPh8C8AlWi343z4+vUJoNajLIzUDKgO4V9qCMVyf6XnCcwPOlMklvIug2ZIOqKWcurOR+0w7wnFypIbHl/6cXL03VQl1LEPCogj9y9DHQXMFE5dUYz5KSq0eqPNo2Srb+HkVeZbHH+ESPnxxyuuAMpAOPdflpzYrg39zybeOuzyGZNndFJfa1LYBAYJt17wCMDZ4E3LBU0lhEorX+3+9jpEVCM735ahPAbQ0BNoPZSHdI743z2eSLWUiGSA7xGFKSjzDClh56CNYKorT/865WcBm1RVpWzIDiN2kErUiwEyJtr2NTRvOlPebUITr/EwyTLQN3+C7ITYuQZklvPTEUQGRvuK6MeZ5s5srDi4kpG8XZMlTznocWXblUOiUrtQUZlLIOkcHqbcAW8P3vJxVWjGcLwU0GpQVQkeN622ESZQmtIgmRGZzRXWmdmvt0OpcZrgCQMJCa2fVl0bgoPxOZkbNH06nhtFdND+qbsuAz6o9z6M9vIcdk87BgV3aPjujvD5VR5PcJxCBvEM+Y349ObtJqLidBGRBIalTnmrCn3CKxjmGAv3PuaOztdA3CekSw8V+C0I9xvhZVlaFtr9QkEi8GM/DUKp/faX8yp1MijirDkOEEUeNaUkfs36nZ8kFWPa86rtOwQy0q3+i7pvcnkeoH3OgCDNJLn0835r3zUXdIFdT/xE0GIkNE6U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Hqd8G/OfMELjAIen/NmGxaRrm4szI0dz6FudExmwhzNZYOb1HfKkkWDM+6h?=
 =?us-ascii?Q?EBVy3Vhi9MWxgzLC25PX47TERx4F+Mr+VLNgt61bsUYwBwP10z9ROLN/YXw7?=
 =?us-ascii?Q?/qmgRZOX9DVLJ6MnYWmLY4jjYwy0xM/GK6LGYpudVdCN74IdSWyCCeat2HxI?=
 =?us-ascii?Q?msT62qe6htaQwjAaZ/843ZI2tlhD2Tq57CJvrnlbs7gkwWqkyTcXoo7yEchZ?=
 =?us-ascii?Q?Fr03JjDaCPgnfjtMx6CQTSFa1hnub3dSheZ3DBLctK8cGLrMqy3smEj+2tf5?=
 =?us-ascii?Q?6gguqk0SlZZvFeQzaiN3iHftZUmROE4y4dZZqVAp68M6xi+n8v0AFGyyqqjW?=
 =?us-ascii?Q?8aNIfcEeVJ1vTZy+ITaTlHYSRI1QGzCAqbx13T1FnwOaerkclrpw43dfHpYk?=
 =?us-ascii?Q?bULu0kPkXP7jqxI7zt/SScGvLWlu8pWFOGXaMmHuI35eDxEseaPcbcgjYL0s?=
 =?us-ascii?Q?YZdapxYq7cssaoHdCo8Yhq/jMaddgc5+N1Vo5ludB7VHyQQsgFP0DgFhGeqG?=
 =?us-ascii?Q?S7h2YnADXjCFrUKSj1qxL1dsmm7yOoCWUDSqsNKfYjh5+1gwuGvOsCP5+dF5?=
 =?us-ascii?Q?aX2cZeb7Pm7y9Nfye8uXVBYU773rIVMMpKG3/G0pHXU3e0KD+OZGesAsdyn0?=
 =?us-ascii?Q?ZyBJRixoPnlia09wP2a/gYRApYdXv+AD9YyIMTmHUkIRrwLeQms7LwGAVS7f?=
 =?us-ascii?Q?VvqzMLLj8eLNMfKqAPfVT5mpDdZlkxFCaz0iDsTvpFzVw+JRcIZb//k5WYNW?=
 =?us-ascii?Q?m+wjeakgXaBCmTkF7SKIDADWt07TdzlF4r7jsCAhwcpTqp2HvEG5QSlWYqQ/?=
 =?us-ascii?Q?AtSPJLprxO85lrfTMzbLDZEKUtIPFiL0HkjhTlPeDzjqst9XeTK6N+568OHI?=
 =?us-ascii?Q?OnXFR6yoaJtvE+hPmTQdS4Ao1unD3jZCGld9fzSJCW9LFAFMfH1+xu0Da/Jv?=
 =?us-ascii?Q?Y2T+m0WmvlZlE3av6E35GSiXlqYonHYB0iHSfjLRjtLCHkgmxKqUdzbxc+Du?=
 =?us-ascii?Q?ROUr/LKnwgU7bt/4VYEjFI8LF08EgumVXMeL3YScNuunvO98cjO4IcP9gZyr?=
 =?us-ascii?Q?iHxsZLA7B8N1MsaPfv+tBiz4vjti2mnKkwBH5JjU6vyXwpZY+5Go7qfbHnmA?=
 =?us-ascii?Q?rF+ikA520DZLvsLU2fwkwSg3m1nEOEGyEzFSgC7MjnGH3FvPOhs1cbxsrMTB?=
 =?us-ascii?Q?ZOrMPeVXsZD3Q1eYyASH+jVnJN0UNZRaPibasL4IW91XUw8VICrFpk9UX26S?=
 =?us-ascii?Q?U7IijFG3Bah9buKC7tra21SSrJ5ufOau30lal92IxFz6soVWZYORksqwYqvW?=
 =?us-ascii?Q?ndqcrlHVg+g/HDdQdBI16mSdDZTaSfDKa7NgSTTp2CNGdH3mZL6kgYdJAOmy?=
 =?us-ascii?Q?OCjPHv5G1j8pup9LmuRdnUd5e/AT9htRwkSgPhLoywTNPuH2x5j1K2CYNG+x?=
 =?us-ascii?Q?1uDQkkBk1FX8FSejD5OrZ/i8+9yU0SATCt3oYB0fZVf/V8142svBzV53699M?=
 =?us-ascii?Q?msKcF7k/vuXZRQ8YSI6zkM5ao4nQszNdSyONxbLI3Pj7+2LxaS3NVl4N7Zti?=
 =?us-ascii?Q?2+VyjaDYTQclrr8srEB8LOOJ0+//x/VyvJ2EkIY2gzI8W7nJ8K1gJoRkwAQt?=
 =?us-ascii?Q?bhCr60dGnTk79pWbRfAvI8SFQatbEMvX6uEDJC/Q5Flhq6j/avTNqfVUfTef?=
 =?us-ascii?Q?7N8nmdkjFG8WsqnK7KubdLmhzI0eZs1bZ4B4REgCQu9xmDHsAiIT0Vv0qVMh?=
 =?us-ascii?Q?yoU6upA+Rbznue4JelmQYQOsMoabJyE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ok7ZPeCeA373Q4JSKvjB04Oib1yAuPPwrUNt5mE3vQjcil6Wp/sHx+bgnJeyL/cTCrsWYYpjQ8A3D11M3QJw4Owarpn7LwtH/txDBd1Ya3eRIVXeSY8xy6wY46J+h9iXHYWYZD8dmRLExTt9eCRzLWZ/wvJuwRn7uAbIo6b1nIgrOWcTQpeZ7XTu/YuRMsNNO8RHSQFNyidHFpj6CNLqXZfC4fyMX1F+dehqfTNopEY41EQL0pthl5lX7f6hMjS2FraLO164g5P1MxbE9mZcm9Sd7BPmbwKgumjUqMcatejhNfCnKvDs09c63sqjcKmy411cQ9TvYQ7fl+P+qeD9VLLb/Dc/PDXQ36Mdls8LugS2QttxGbTrYdmH5YzQHMj+NSqhH98We7wCOFJRLlG3M93Lze9FQCiREDVXqqw48Q2b16qhmYxzCsyKocLdW85JskMx83haYdN9WrGSQA6DayFYDolDHKtszKjtUVCRNuxNp+r2YMeCdklCdTrVW8ICRIUe3XxPapbkyDyYj1scWelCcDzCgXe1kCeqEfwhmSPV/HHMy0eAgvrNQ7MiZrAwzQz3E6AjkA26bNJiZ2195Iq89TemWR3KY4cJA26WL3o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d149ecee-2655-4d93-a147-08de7483aee7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:45.9247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4uJXgcVvRv0HinD0aQMY8NV32NbA65WTolsvhxOEGszWyqsFeJXsdoOn4EqA37Ey8XmwfjFRIIpco7MHGzADg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699f172c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=pCOl5fTshOrEa-n2-VQA:9 cc=ntf
 awl=host:12261
X-Proofpoint-GUID: 5UKmJm9QbSBYmI50yngMEfcFpUjfF858
X-Proofpoint-ORIG-GUID: 5UKmJm9QbSBYmI50yngMEfcFpUjfF858
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX3KBSIMiMZ0yP
 pR2sBDQ7K/Vik2HccQLdYE/8TRr6rlIO3bHtPhjEWn5cClpJ3O5Go+IWqcAzwAno/f4528iXtL9
 c0AcGyyVtew2Gd9mFDbjBSIeINllcE5J2ZNYHnWq6smUTkyqp2G/3q5N6efBWTZ+HMTZwClRYGj
 pWfJqlBPj2R+hfOULqak/WaIX87xuMgu3yd9oBLMMYU07ovaqH4kYwxv7EY3sU7X0ze9vd9vskQ
 c9CatXxZZVfRKTgJnnzsQjhK7SxLM4ZLkMHn9OVOo0zHtt+28j+YTzPRRnqGf3e4PG+6kvSGhIm
 XPXypZczE37UZa/pe5wLDlSFXhE/s5RQXfbr7GR2lGkbWu6QTmRJs0+MVyS635oy1ZOzjrbYGeM
 QQxvwzQocKlApWh8TFYEn1b3TvgBD/9lqS8Oo2So5rTY4l1sshcngdA8XCemUl9OH+3hcDgoAOM
 pPvPgcd5ySJDwj9VvKNwT4/qpZWBe15el8fCbqr8=

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like NS structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

Two module params are introduced to enable multipath:
- scsi_multipath
- scsi_multipath_always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and ALUA supported and unique ID available in
  VPD page 83.
- scsi_multipath_always enabled and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device, which
means whether multipath is enabled or disabled for the scsi_device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 158 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 ++++++++++++
 8 files changed, 239 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 19d0884479a24..cfab7ad1e3c2c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 16de3e41f94c4..64b7a82828b81 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,6 +168,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 28c9bbf439db6..99920715a9896 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1042,12 +1043,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1071,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 0000000000000..04e0bad3d9204
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,158 @@
+// SPDX-License-Indentifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+bool scsi_multipath;
+static bool scsi_multipath_always;
+
+static int multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	bool *arg = kp->arg;
+
+	ret = param_set_bool(val, kp);
+	if (ret)
+		return ret;
+
+	if (scsi_multipath_always && !*arg) {
+		pr_err("Can't disable multipath when multipath_always_on is configured.\n");
+		*arg = true;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = multipath_param_set,
+	.get = param_get_bool,
+};
+
+module_param_cb(scsi_multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(scsi_multipath, "turn on native multipath support");
+
+static int multipath_always_on_set(const char *val,
+		const struct kernel_param *kp)
+{
+	int ret;
+	bool *arg = kp->arg;
+
+	ret = param_set_bool(val, kp);
+	if (ret < 0)
+		return ret;
+
+	if (*arg)
+		scsi_multipath = true;
+
+	return 0;
+}
+
+static const struct kernel_param_ops multipath_always_on_ops = {
+	.set = multipath_always_on_set,
+	.get = param_get_bool,
+};
+
+module_param_cb(scsi_multipath_always, &multipath_always_on_ops,
+		&scsi_multipath_always, 0444);
+MODULE_PARM_DESC(scsi_multipath_always,
+	"create multipath node always even for no ALUA support");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (!scsi_multipath)
+		return 0;
+
+	if (!scsi_device_tpgs(sdev) && !scsi_multipath_always) {
+		sdev_printk(KERN_NOTICE, sdev, "tpgs are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0) {
+		ret = 0;
+		goto out_uninit;
+	}
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return ret;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7acbfcfc2172e..e22d3245d4b65 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1122,6 +1123,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 99eb0a30df615..0d69e27600a7a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -455,6 +456,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d32f5841f4f85..52974dba0a724 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -279,6 +279,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 0000000000000..ca00ea10cd5db
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 40
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.5

