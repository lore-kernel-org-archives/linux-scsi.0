Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A997E3DA7C4;
	Wed, 25 Feb 2026 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033853; cv=fail; b=eQd/os0ONagepZmidPm2y5OCeqr+V4HOnw9ClA98r7uat6sxGlG+vcxsaHjAhuCHGVNpHieDloFkQkIzoCWxKAN4ZqZ1OhzChsrx97OSCQLTxpisxu7jFl8yYhd9YmuxN1u+mlfkEJAnWm9INeMYfHjRH/9DFqh/bcz919Qrmww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033853; c=relaxed/simple;
	bh=kqkaxiXP5ENkHdaVbCbeD9/9Xzq/ciNQtl5a/wJIKi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Le5ydW71c5kECUv0M11WfzYmufOqJCwoJkFeVo/FEFa8bQK8Bom0mFsd0XawLXNpUP5mofyMfre/UNRy2OS1gYPoDLr+C9qDswYhoQ6UpvgFnYrXqJEItdlFaNJVX+C9bTlza3U8AwbjW9XIOsIAHi/hgZxCyVWiDvmjPL5esVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=In8gBJpo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XJ8nriNe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="In8gBJpo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XJ8nriNe"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9u3vq369379;
	Wed, 25 Feb 2026 15:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LmxpdzNzPgqNnHu8qUc2jeCisRkWcIvSpSXkdVWmyZ8=; b=
	In8gBJpoNTaXqxnAJIG6yUF4FSqDiD61eYKyEd0d1U7/8DxIteT2RwZ7B/QtzUG5
	BiycrBhw+SS4BEGajrRnvhXdlHyBpjReclcTAmjSfpi2zsr4Y4YtZyLYxYNBBaQi
	QUkTHSXFkfzSkbNKyOEpI5gF7mSGN97Kxu+l6TofQd5JfZDo9s3yLUQHDcrzhV4v
	bDABfkadzudR5va43oHt7c/cMypBfCuEwK6I+D6+GeBvrUzTKkIc7krcaC7uVugv
	GUK0ORFnwV3KvfhBpaynb5iSi2Kf8ikNIQmeNiReAnXO3GRt9uBRKRIuDWE+BbP0
	1mU38KyaEl3Co1QS6m3eew==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5xdmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFWE8r038454;
	Wed, 25 Feb 2026 15:37:13 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35nfrbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NRjwOr1nz0SJ/LkmgcIYnN4QgXUSvbxCiC7AccPUzsmL2LLx+Suj/OWTbqwN36XoAf8v4ixUPiOZZyaiF3yFDanrY1heUR2pEzONLC5cvZIup5rF+lDhg1/wAXlGTDwA/MHHvnTw3oy8CDVwV9hJ5Tk4p75nKoIFOnUI2535VDpRJTH6N+1T2s505DRO4OaVenR/mITFoMqxijSGZROZ+cvPLs9LnxsBmbIv1o7HHZKtea7bH6QwhwDzB+wxrwZMTPf8q9WApbYCbdlw5dLicEc5Jh6OpS5076c7NnBarB0ExzW6uCwl++BqW9WHzKaGc0pqUFYmHCHTWutvv4s0dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LmxpdzNzPgqNnHu8qUc2jeCisRkWcIvSpSXkdVWmyZ8=;
 b=IL7F+lv/w4PWTUJjlUSHTJF9SIn2Mm6IljEWuvaZygCXUEyJXBPmf8rZfZE+Q8uMhH9eHZfzxeHE7SYDsUjOhgdp6SrQfDBtHdQvR0BCpHbN59FLp8ft6Ql7ogevKcly3iPa0O45DrIKlXK6cj9Fw0NQvWxqHqm2P4Wd4G5p/AnKeQI4AuWfnd2FfrXPMidmpQk+U1W/KNRb2EithnkrPDK09JmtSsf0ZcrlblhpH4JXqjSDU8i7Qk4lDDOO0KFzWp2qLa9DeGq/58Jo+31SLLvYHQ6DmSEhveiNMrkAToY4N2RZ44CiKEpoTKvJsY7fCC5eWKvmulbegu2pXssI2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmxpdzNzPgqNnHu8qUc2jeCisRkWcIvSpSXkdVWmyZ8=;
 b=XJ8nriNeBkTilXjAf5YsfTn6RUN56FhSzghF7NHWVpjKjRLHQeKvFWqXzPWyasMe2mbNE/tPfJI4VVDmmspOmRkoMF5o1iIHbRV7QVucEbgDYINs/AO4LCifWC+AhRbuOl5E2Ml/hlyNY7Cxi07xFwqHDgF3+5KXTb2zDqzsBMI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997712.namprd10.prod.outlook.com
 (2603:10b6:806:4c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:43 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 01/24] scsi: core: add SCSI_MAX_QUEUE_DEPTH
Date: Wed, 25 Feb 2026 15:36:04 +0000
Message-ID: <20260225153627.1032500-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0039.namprd02.prod.outlook.com
 (2603:10b6:510:2da::26) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997712:EE_
X-MS-Office365-Filtering-Correlation-Id: 38714e48-5635-4e12-e947-08de7483ad1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	5EyRr/VKhdUhd0VTgJ0rkuqaq7Xko3I0Crp7B+2RTZ41W/ivE6etlzib76w3nlnonbAwb6u0ywJBdpxdQZMd9FTwnK31ofB076lw7ufmlU60dt6XJ99ynbWuEOGSXJIRCEbd3HvUPUJOykRN+QXYUby/OBZvOiQWyGh5YB2mUu0agU1hzjI7acA6oQToylwpyhj25ISDTecqxbKOshr3j6ETtQmAVfvXU9UG/zvj3Ze2muk5+dh0GIMp1scxexazwhy4xlFanQFL3TkRdZ8+OzQxI9EsaJ3qGnMoyNvIQCOYkmxs4uoeVj8LYAgyj7TMTBxuCNOaDAHh24tksofsYwRvclPHe0KhRJlBqLj0tpOztn4l5aGKh1uqiaBHtFO8/fuU6NVXQ7MC80J01t+NJ6GH8+mlLZofBmwubAUK/z+FWhuTQ4thFNqT+xKgwCXgR45qE6qy8BZn6K9+T7o3ZlAMwYuMlX98SQt6Y0V0gYmwPa9eLjb2oluyTvJaAEHyKJOqpZkZN6zQu0tKPpkGRYtFnxn9jMJhME+tsuyhsh4OlrpX5WBXQxxV52shdtpnAuXgS9PlcP29BnZGr0dIs6K32bnqAg+dTgbuIDZ7zr1SZSP/QU3NZmYB10C2e0pQYGM38NQ0KiIX2OLWJGUlSzMVZHuP76AE/I1a3l8qQpfHojsbJuTVKVX4xZgv5PPBrm40ANkP138nPpPbxwL/Kio/QBG2Yai6ESFmMvmJWQs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZC+Vy74dl8Zn9+t7R1qyK+7x0BVHeAkGiCROnBnwu/F468YBp9tIKHtqGi7Q?=
 =?us-ascii?Q?uBH9o1ssldBtxwJrAc1Dc4QXBl2VXN5BW8iIrw//eGoOvPKSOfBFm+ABQoQN?=
 =?us-ascii?Q?47Y4vFti1F+p7Ibvrkr77Aye+ZUNalHec/ctRRZ/D1n92QiI2CgFfh6FHXWp?=
 =?us-ascii?Q?4GNzAuisHio2JMJuz8/bqzhVxDThdeRa4zZX/OQCoWFaI+4HXorsQ+3SCvyD?=
 =?us-ascii?Q?MSJNKYF4hhwnTi0Y9JvC3qgjK/FwwnHPAUVgGpoxxmYO6Xuie3K7dJxh2oN8?=
 =?us-ascii?Q?ZzvqisPIfqkGY5PfC/Kh/dRpZ97GbrY+uL25lICbV5pwYlGMGz8NOvQ3VNFH?=
 =?us-ascii?Q?B7g0qB+g6P2JWX2Qc8nEpyI+BnyC1PfM0Sjljs/ZCb45zzltla6oJYAdaeWJ?=
 =?us-ascii?Q?Ed5Jd09zlNEfFQvyIR7oq73pjP6WVgsFRbGWzZezJSCQeFIIceSKUtwz0vpf?=
 =?us-ascii?Q?tLUQBY2OU01vLuq18ftkVz1N2jdPWhIK27hcSei9u/Tbgmd8OhegEBSLyuv8?=
 =?us-ascii?Q?kHdlhyFu2nigSO7g9WVNk4bcUmNeepeGqfyjArYHcF72O21gXv59rilmUYOl?=
 =?us-ascii?Q?ZS45G0Hmv15izvrIiHEltK+uXnVIvtPQmMtIZ/m1QIRauhJwNv8HD7qXoqm9?=
 =?us-ascii?Q?/+K2JYV6UQiJWFTm3VIr41224M54mqAypMUSvni0YTy0vZYCBcS2FilS5VJe?=
 =?us-ascii?Q?f71Ei/9TZzFgskR2JRPBwOuVWXlTmGVyRTNt1soiPyFA7CYHqVkPLOZL73OG?=
 =?us-ascii?Q?2fhW1jJ/1O/8qwHZ1riyaQZXxU++2Yf+Bmhmdn8xhn7eRsmJx3xy+X4KtoYc?=
 =?us-ascii?Q?o33n2mlEsrdYKhZQ5Gqpa0s9+ID9WMtKzUm7DMWNNhRPpzq57H27lcp/P15T?=
 =?us-ascii?Q?fq3CldVcbiMskfcSuQxibPP3U3s6OaSv7T/atTocAkPoXCjPwr2Tb688UTzX?=
 =?us-ascii?Q?ODkZm4hp+AB6PkdTXxLFDDr2wo8mBLihEua7UIeJrx/B7dubcsVM9p0B2TYt?=
 =?us-ascii?Q?WIIhn3gBMzNSWwx9dZsE96rMeebFJe0eorVccJm7hZhoU1biYJVMm68EQcFe?=
 =?us-ascii?Q?hUwljyB8+vTLwiZ0rJoPqdjtZ2aFqq/tJaZfBJhZj+/OPtDp5jO9WnYnbWz9?=
 =?us-ascii?Q?CzVjImKI5UR8lEspk6g6VA6wyBAIQfSHa5+5u95volLqkvCeVJ1J5h9MkT5g?=
 =?us-ascii?Q?TzAfHKndJz8el6iv7Im2cWD8XP3Tp7CnHv1HWd5PGst6dSSZl53rgYbJ1c0X?=
 =?us-ascii?Q?pgU1VU4rQdPPyezbytARt9EEM7eT4w/BqpM/MMZAhdAjRxZ3uYsi5PaR1rlw?=
 =?us-ascii?Q?NPSKG1X12zR1XzLOobShp21zahjOL/Ip8qkmMFfYjOm/RT8Q5R04VlfMvkoi?=
 =?us-ascii?Q?NGhAkxANKFJFqHTPX8qqBOdxF5aDMFjdCN67hMLvwOmdDopHP1Zd9Pmywmus?=
 =?us-ascii?Q?S+Dy6W1VZ1EWuZh1u0lBU08IzkNJePgOOxnN6pZO1hAPYTmqTKhrrEq9a/tw?=
 =?us-ascii?Q?vzX7BHgNUvvTg90hTJhh0F/xweJ3fX4MnMkXjlVQcBXHcF8wBKhFobUa4jh4?=
 =?us-ascii?Q?5CRCxmQ+IN8yNfCdZApc7dbvJNCwLDySyCdMD28J0tjmfgm5h6efo5zAWX96?=
 =?us-ascii?Q?JgxYww4Kdrkpw4bGBqcmBv9BAomx/npGeLVPxcyVFITgNVeFctK1an0s/EvK?=
 =?us-ascii?Q?vY39wmyWkfWcjXxQwfwEo5U+t2wrQOZYaG5Ry8NnDCy8jsTyzYs5p5CMz7oy?=
 =?us-ascii?Q?hbO89tTLIal30KVE6RDtdvC9f7dF5NM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MiQR9rMe0SzlsdQLieMPGWWSF8btkqa7ckz70NgcHzVklALWPkIIr9mD+pcioWG90dDnXd9Rc4pmEP8PNU+QxGfdoX0VUaxPi9CkncSo17zL3dvyuV0QeF3aEsQbwiWIu9XJi24k+Sbtd3n9i571yCp65MVLNQpaPScQOC/RRnN4SKFSQaLoc6353AMz48j16+O7K671Qiw6K1H6tMF39u+gBtRh3YeDRRrvr+awZdmDoF+BUkS5gFjhqjBfMlrn22sav3jM0b4qeS2kjz11jcqwJmStou7czLptrSd+LI0JsfcziHwx52pHd0MljSZPJz1IYHonVqRJm+JLxDfZ/RzA4YhSjMzVqd625NDnor9TU5HrVQvfQuMIZzpJl0uQ53CHw6Oji0XK23RuVjyJWH+S+U6sk+hJLaULKcI3N7m2ZIU60kMYPG3Don/faMH+Eg6k0W9E7FhjoVsTAEjdGw2m+0ppnqyue04Bco3VtRquRFB/YHJwpx2V/6EJhhIoDEXRLaCdbTwusvcAjd8rQx0Py5ipViceAhvr7RX3dChUJvFuWgNoQ7VgqTj1n+1Nw7nJBckFw5v2tTLDh884m5F2wooubsNc+dWFziT/HNs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38714e48-5635-4e12-e947-08de7483ad1c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:42.9269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /44NcTQ3rMs1cPMS+47E++g50Je1h9ZcnTaOiuZ5QSlTCUygHOj1yd6WuiIVuz5A6peUy7IJO5VTnxgzsVMR1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX5oncwW3bgWQ7
 NrLNovyJdAj5cpqS4dB7+7f4IgdJg6nD0QLhq+GP+xIrTb0SDtjO3YmtTWctT2tiIba9tC2e771
 YKlIEIFuYQoBSd3ParvhssDxghNBuSKGZE5ODN/LJ7HipPHKdZk2CxnDGL1soF1PXvNnS80/sHG
 t+V99OlHKdIpON7RQH1K7APVJz0jcssL38wbMiYzNCVYcN+VklrVjzG2Mzxfnh9SdIR/qEJvnA3
 +wFKbEV1n1nVeyQg3iAtBYCJa/qdDM54EOGIyiFvgrbROzR7UhLdS/p6cdBSlMYJxvpjSnGJphe
 ZtQHl47edRWyYCGZggPpqdBIRhzKV4/HKpfohEEBxHGGY9r34rAOqvzcEzDWssn9u/JjiJjy1zp
 V2GQlPHycaJC6ItrEXIE3ZWn/Z4TrBtYfv1wh1dWhpT/HjbLrVqbXqDgfxLLQVcypfAJAeZTidX
 EaPe6cacTYpmbobc4TxIX+gZ2NKYdgKQ4CKtcZ0U=
X-Proofpoint-GUID: m8wL7koU5q_BBbbr2IHJgobDA5RQs9U9
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699f172a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=_cAOlNeyQ_0Bm3u0bTQA:9 cc=ntf
 awl=host:12261
X-Proofpoint-ORIG-GUID: m8wL7koU5q_BBbbr2IHJgobDA5RQs9U9

Add a macro for the max queue depth which is supported.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi.c      | 2 +-
 drivers/scsi/scsi_priv.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..28c9bbf439db6 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -204,7 +204,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
  */
 int scsi_device_max_queue_depth(struct scsi_device *sdev)
 {
-	return min_t(int, sdev->host->can_queue, 4096);
+	return min_t(int, sdev->host->can_queue, SCSI_MAX_QUEUE_DEPTH);
 }
 
 /**
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d07ec15d6c002..679752c5f8bba 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -18,6 +18,8 @@ struct scsi_nl_hdr;
 
 #define SCSI_CMD_RETRIES_NO_LIMIT -1
 
+#define SCSI_MAX_QUEUE_DEPTH 4096
+
 /*
  * Error codes used by scsi-ml internally. These must not be used by drivers.
  */
-- 
2.43.5

