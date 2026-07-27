Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A79837F311;
	Mon, 27 Jul 2026 14:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163502; cv=fail; b=ldWDCs5Tt98EuDjhTaGBQ548V73ydF/s/tYP4nYZQl5xKACMDLeIuFP59zL72g5Rpp7gs94+CIr9QCnct61EPfcp1SiaZwaVaMRgJL2cqyWFpNurLlmfcsxGdTaYnDL14gNnq5+VAbQvzP6z3fVa+q8rceOgljhETk26aeuCVQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163502; c=relaxed/simple;
	bh=c0KjNn68NpgeDhd0dTZn4BexU28e28bKzf+hVvWjkck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jPtfc/3MWB9kSrOQNijNzGdPKR1X7HlNMGQ4TIi5sjsw3hU53XiKlsTxyCYSEKZDiji8HaQSDf0Il8zso9j+WnqrgIBYOzFYL4Rved36D6gqtS+XiCG38MV6yYDEPxCUWWew60iUcgRxlXC02y3QomlOK70WSeCzlCFD+NCRmvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dj/zBn4m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tF0zJz/A; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dj/zBn4m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tF0zJz/A"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTPbX3047942;
	Mon, 27 Jul 2026 14:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gQi+YvA2rJ05xevo5RmfOLjNrxjhnLXgnTWi3nEpm4I=; b=
	dj/zBn4mlrkTUKUacgzGrPKS/Yii9222Gt0B1jr0s5j5BAOVlmYXK9rY9GJCPVN2
	00AHeTfCtBd7TnYO5uP/1SJ7bxx+PidvSYC/HVPirrQzd3S4fxZEtwabbLkmTNPT
	fQcCvi3L3Yx+t0OgpLZ+U5jH5KyNVpgBfEyn5qJwU3TlLuo/1rjeRR0CPXDhnpiZ
	Q+SCjK52dbA56NYfJBN5BGf+wZiqTH24bHeXETfymlKyJnKDvNbQ8DUQWiwGvUw1
	Mr8A/KEgz5riNIdgqt/w1wiwHreWzQse24DQs45GCL1aT7QUgqQqBpip3TTN6rIN
	WjnWXj5zCDzmOhYQGqSBBw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyy9yq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REZi7T023434;
	Mon, 27 Jul 2026 14:43:36 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ngw21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pltz3TX3/aWuQjgWPcNNWwi7IwoOzqx+F0v21yHwfhEuG+kts9f3UMRXOziHW7kHAfsBRYUXOPPncU0msz9tVSvDc+8D+RRfk0Ro+aJDpWt7eTymZdYR4q3dQHu6dNYaA/7v3RB6GYvfjIU8lpQxFuyYdZDEe3jX79w7NkAII3OnJ6zdlTyttAF7S+rzGJnlJzzJx/MszW8k2ift0uWJ2P5634pPq5dgQ7locZqhuM9DvRrBboDDmdQUwO9ex8DEQxr1ldWHgbzRBEe9WmEU6taKaiC4fh+n3DPgIxgHg8HgwLcm1bBuih2HS0bPibQW75WbIFdkOiQ/pbM0J1f/eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQi+YvA2rJ05xevo5RmfOLjNrxjhnLXgnTWi3nEpm4I=;
 b=vgGN+yYAoSGAlhAIfG9ExQpCgKN6eklPH9Kgpwg5ib2iAxw/44B/a+HVc5a36KxoTNGa3cEBHc/RI8Rx88O12K/P66jIFQzvWEK74hY1m8LwmgLP8NM4Wk87Mx1weq9jtpDeQGtkoTfeqGhc0FeeEe6pkeHgnc25gPfZmpBRs8EIXCZbvk7n9rHDI1cHksBtZ84QOAe9ZFZ2zHVXhBKtqiykFvwJEue/01q0eR5MMaGOxIQqFkichDl8hadiQjxX4yp90vui99Oa8rQ0myKyLXEti+yHRTsSXV++1vDwUuWSkY8LTFgMW6PrrEWaFfVqz4bkhSbfP14szLk8BbbKGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQi+YvA2rJ05xevo5RmfOLjNrxjhnLXgnTWi3nEpm4I=;
 b=tF0zJz/AgZyw/flviQDMXCCLHoalEkP96dqX01ANyg1FLUuvMOBMS4suKM7fO4aNr3QTZv4TH08gEgCOHLPvnPtmGc9P4PIc3w//fWLFmEx8suRna++fzt+cxXC1gQRcOnZzR1SYMR14HUyypvQHncs/7aSyN+L289MjR+FOfzU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:30 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 22/27] scsi: sd: add multipath disk class
Date: Mon, 27 Jul 2026 14:42:29 +0000
Message-ID: <20260727144234.3802948-23-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::27) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM4PR10MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: ae3e4a03-c572-499c-e039-08deebed6cd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YoBtPH4qt9LLTCdKJRfunWHR0tS5ZY4+saHe3tdi/PRmC9YT9TgiHNxKoE3JaonDZr16HsuW9dwI7/2bQEiezhYQ5EvWgNJm1UIaE3yvlGGs8yRvTmYCGM6QTQ4UXBBiYviyvsWc1/Q+CZ2EndZOc7FyKAn3tNYZCYXMzDa5kWhhM1gqKVUbtpMuHn112rCTv3hnaHUUBLFtvnfS48TA9KgHYuhSzJ9pkwoucoAMtYYA7GuwYjtm+Ymfck2ogunqH960PjfqHLyWS8zSTGFGCVhmh3eMp2sQsnlAU0JPh7dEl+H02yvigHLwSGoAemJmRFlKYWALdfmHLiRBhfsEGATuhXHSMeeg4EroLyHSsK/TRAnuQyWnyU40YAueOT94uaH59yWgwEQMORWXU7zJrzwyTy8/TbhXnnI0r3vRS7+ymGcX9ERari9h2eSyzNyU2MEGBgV0TbtJu/TwdYhwxTBlm8gm1OiymOajqRIr4+HRGeVS/kx2P9HeEs18RaZSYkHqDyoarBi13GvN4lGnh5yeTLfhg46NVnlJtz5l8u/eVP7h4wODSqprjlQ3Gu0TslrweoD4teWQC8KcDaCR0HEX88iP+yLaIyFvBhF+a4sreIt5jadB9jJUxmID3A1m/1J982us71mEQ+qwCVVPa1CXXxFIQJRmbo+mRSZEn0I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ojLZgIUFPu6g17d1b65w2SMCbZowDWyi4uvNdxEC+zbS039sN+2RR6bjnFRy?=
 =?us-ascii?Q?NY2IINpVrZuZG0DTNqbDZ39vNeMhuvfYzY38l5aqBJkGooticyJegRu1xRGz?=
 =?us-ascii?Q?POKZG4IR2jLLNq5btdkeoSiDbhY0UdnhKzqnzi2xUCW0X/fdNccm9JSyUKfb?=
 =?us-ascii?Q?Jf2UE2MTbTw7Hn+84byQs0+Aaw++hXxJ2CN/yEx69dBDOGxkdfV9yz7Utpyk?=
 =?us-ascii?Q?hJdTa1ZE+vf3f1go2kK014XohClmsuXpX+KeTWsEwEog5oRjOAf0x+VGjYkj?=
 =?us-ascii?Q?9qcpdSdsqtzZ4m/LDw7B/wJ1k2NxdUhjM8Z4DIcYdtyFCJkAPXp7Xyll+Skx?=
 =?us-ascii?Q?+C3yDzK7YH3chxFBew7/cj2d4ij/Wb0d0w0CpKzDbba6cxmRyrdShX3z6Eg7?=
 =?us-ascii?Q?Ng5bEm5hU6r6vlTlZ3uaYidNDENiI/KKECGGpXXv+d3ByjqqBVCasdneTk1S?=
 =?us-ascii?Q?wMAK1yyFKm+JdGmixaLKqRwwbCu5mVopnOcRUCX6oxEiVT+yAfyZTZ2oZxRv?=
 =?us-ascii?Q?K65ot9Mbqek5OGBSqT35RX71bL5pFrBuSxmuZb3PH4NmQQcwGtZ2HaPskh5L?=
 =?us-ascii?Q?SwF6JPTJp+eITmferMtUf1u7vcA4ikGoMooTeopTSjFkBTSVElkwdOQzSOlx?=
 =?us-ascii?Q?j6y5oxzd+37z3ev4gyKnonknG7DN7ms9oEDLOQ9Plz26b5VcibnXVNQbOkjC?=
 =?us-ascii?Q?NKPFNhdmovQaegK9NbT5HeWwB4QCdOTaktzYG6l6Qv7godtdzzwE+/97LaZP?=
 =?us-ascii?Q?tH3frMVmECa2r11WN4UAtt2XfFzpQsmp3UBVct6oQz5WiEy/b9mFGTWC4GAo?=
 =?us-ascii?Q?GYX+BrHHlFzK1fH0FnmRPd1PZSTSUqKtOK3GLQWKs9iryWKSqlG5Rf4M6K4x?=
 =?us-ascii?Q?tPhEwpwwbBdOuHoOMHhg6FleRjFuYsJZAnt61zZIFxXOVcLDdLpUTk5Cq9qB?=
 =?us-ascii?Q?aOAIWhQGZFVrrNaQKQ1C8eTmzCBx1vV4Uq97PbVafNYVNn4vnvODzxk1KJqi?=
 =?us-ascii?Q?Btjt2DWW3uOyswgh8HPk1clvBudzYTXgJ+AV9Etn7+qH9TAR97G1iK8TuFVq?=
 =?us-ascii?Q?y6Z9j5BShqJw4acBoAYmbZ1NVv94ITsJmSfAWILQAlP9vD/6NwDawK6Je+SC?=
 =?us-ascii?Q?jLZwzAqSbQYO+nqdGB8Ir+rm7ZA8m9J2UV5+at49VyFtpNN1lbeVjrNbNCPa?=
 =?us-ascii?Q?SuC+o+kkkfmUxYEQ8s5oRqJFtSWvMilmHyMma+WbUYx8uw52H63hCCQA8ZoJ?=
 =?us-ascii?Q?b0e8ygc8a5IAVJ5BdJmWWpojaULYYWdObn/D1oYMQ0ucSOIu3WQwPm+s0vFj?=
 =?us-ascii?Q?y5rqJgzmiGRHkg3lP28tHrH43MM83bPMV7qanr7LoNj2ZsWTqe+0Yh6g/Vap?=
 =?us-ascii?Q?eivq7qy63OuFmT9VApZpBo5XFr/JCBSR2adD3HMZvAN6rsqSO1uqLSX9MaVP?=
 =?us-ascii?Q?qXYoPkb7e7+OW/3Vptvwy585zwNcDChw05MQlqcpLeRS7t5dRda/ialQfxrO?=
 =?us-ascii?Q?oai7SPKuMGUWtgJHES+HP76QuwgekJvw10HGEpLy1aakatqsS///y+rsVLFF?=
 =?us-ascii?Q?KurNMU/edRM7s3d79R0udPF9u8q15BRbSBvDu8zlLD2z1FkXfHmb5wk5ICDq?=
 =?us-ascii?Q?SQLZUkgjHbB28Y2CnDpWw2IWknRQ2N7RkU+PC60GKvyxm0VCRiawsp0qjy29?=
 =?us-ascii?Q?vACDSmu14z7P4+v3NTo4M8A2kjtknElurWoR3wnfc68KW7tJbAPQ+uP5V32H?=
 =?us-ascii?Q?VCflpSuJRX06yeJmtF2oZNTR4cojhJs=3D?=
X-Exchange-RoutingPolicyChecked:
	cnR8w/3ZxC5UkU04qfEBRLzY5F4sW6aOL8JEF+nIKF5uewXzcJvrV9VQJuw4Lj082R3Vv7xsdj6gjcXyxKToFVmXc5HM1nwB0k4zIh8dckGECayW8MHm5pOh4x0McAsH+CDxQvsd2aY2hJYZFvoS0772imecV/RAY4B1r6wr5gFC8VgSCk0kyqRfGuYBF5KdJ13JnsykcoNHppiXmkzJu0xuby3uYSilFsVDZHH6g6+OVywUWyCZqWRQ+Fhia2MLQaNTyjRLRpzHjJK/8TwfkF+mxlwNwlOBaMFh0SQLxz3v96sBIF9cHoNLKQ4hrpr7PT0B4UW4y6QwPya+e+gh7w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TL8J7C0XjyKC3MxQiWlX5vPg2AksAJh06Pfrn9xGAG1FoGq2BtzGmNQ2c25/e/al+CwMxfQsxP9E1eSTjJoZxgHaXYoMIL1ZlXCI729bn/KSYIMQywSU4LZI5FF84SGoVifwrAd7V5vgYgf8snrKrKV0lg0kXjmNPC9aYuWVmWlFzyuwXAynPSR6bU3MLjmfCdzKYNH6w5DoIJg78m+olJc7NEAIyxZiJi5+geOTQPMx1fNtkZtiwFIDviks0X8SRSW9TSEltHXUtYqPwiFRhRuvpBUPJ0AkQn98925edtjf3odE9rWcQXeuCKUPTL6g5Y2O5tsPnz/2tRYuS0K8Fc4mRrhghgdEdx8itT4J4Pe6+0gLCZ7PoqoXQbB86D5CYhTsh3vMqhVmjwoRDBrR3vAJZQcHVQRO8vEg8umTtFNzXaS5vGXkXGw4D4VWfmVT91pXfvrOy3EoI8AU8ns4Ht7SSok6Mc0pZ2nfqO1gI4NI5/Inb8DHDBM83KW5sdWPjwm1Rk37jRUCEuy2IZzPxOSbtn/v4AKE6LbavlMiDNqg+XksqpCyp9xEtJ/O9K5KijIUawIy3t4obR5sWi2SCmE7WyXPaerK8zIWvMw+L38=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae3e4a03-c572-499c-e039-08deebed6cd8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:30.0557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5uOckKcmIoI+N/rJeLPn4ChBE67DfjIdRQ0KuU36yxnWDuDyZLjI5cUgyDVfvDuklNKhF8IQIcGT4Ij3NHaTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270138
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX7Ii9O4fn/Qhk
 LOOadgiZQty+IzOVfNzL9WIDoW2MTKY6otgD92ad/xonHR7iR5KY1Qc2OJRijqisTsUeQfiuvxI
 eSx/id2aXjFkAdBidRqpQzanA58td2WNIXPx6f+I2gi64O1XijM1
X-Proofpoint-GUID: XOeXukeGZtJVxboCJmloYwNTJFlLSZ_6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX/uDO6q8MsdWA
 EYeuH6H0Ey0Zywn7LW2BSGDVs4qeKTtPglzrrTKeRW6kW7h0kysmYGo8Pec40qSRwjZk+eEQajv
 4mZrn/k5jrfqDTY82m6XdCUsql/Yta+MgKdXntNKTm6KTwZ4HMTMrmNFQcTlmorfvr79U1+Q3jK
 8S9WU8g6q3CvtDj8Es3+em6S1rRyd3c8o4HFpW8OhCmY4QYg0lddHLmldQWN9PHKxLkhF4wDPqf
 6PeqjqEL8/3ZvS99pN4Gmu428Bc8pB6qQzPuUbl+wPHjgBLZ4hWDGMVinnOqb8nCkJR435yYHUY
 4fhPjIW0C9f1ja1CWtEbUzduYMTSZGkhiwdvOLC8T4UosTrp6zeomTsJUGuNcNPbhbzw0hkigv9
 5M8q5TcIQ3vCIN5tP83qhGQJuY7YZjwrDrByCCoEguEKB38AbFnMauxycnlHloojUGJArK5fHqB
 4PXLGVx8xRcxxJDeo3jFTejVhqN5Mv/4GZ8BYltQ=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a676e99 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=ecQ7zCoEdOpy3JLqRw8A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: XOeXukeGZtJVxboCJmloYwNTJFlLSZ_6

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the multipath gendisk.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f333343..242a15bc2c5bb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
 static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
+#ifdef CONFIG_SCSI_MULTIPATH
+struct sd_mpath_disk {
+	struct scsi_mpath_head		*scsi_mpath_head;
+};
+
+static void sd_mpath_disk_release(struct device *dev)
+{
+}
+
+static const struct class sd_mpath_disk_class = {
+	.name = "scsi_mpath_disk",
+	.dev_release = sd_mpath_disk_release,
+};
+
+static int sd_mpath_class_register(void)
+{
+	return class_register(&sd_mpath_disk_class);
+}
+
+static void sd_mpath_class_unregister(void)
+{
+	class_unregister(&sd_mpath_disk_class);
+}
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_class_register(void)
+{
+	return 0;
+}
+
+static void sd_mpath_class_unregister(void)
+{
+}
+#endif
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -4453,11 +4487,15 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = sd_mpath_class_register();
+	if (err)
+		goto err_out_class;
+
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_class;
+		goto err_out_mpath_class;
 	}
 
 	err = scsi_register_driver(&sd_template);
@@ -4468,6 +4506,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4493,6 +4533,7 @@ static void __exit exit_sd(void)
 		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
+	sd_mpath_class_unregister();
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af82430169..22438173ea2f8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -83,6 +83,9 @@ struct zoned_disk_info {
 
 struct scsi_disk {
 	struct scsi_device *device;
+#ifdef CONFIG_SCSI_MULTIPATH
+	struct sd_mpath_disk *sd_mpath_disk;
+#endif
 
 	/*
 	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
-- 
2.43.7

