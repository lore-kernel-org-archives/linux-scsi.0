Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E50134EF05;
	Wed, 25 Feb 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033688; cv=fail; b=BgXNyOTZuceBXxXb+tfsEcnihi3d03h95VzoFkMiBCQn5OdmrKjGVrbiI+XoyS690IUVZgakpdL7UGzMbUTCMC9I5GdhUF19uf78U6aKon0WTf0qcsLijWNzLNJNBxGoAHVy84svI9hBU+nnlS+b2ian2lTYDPzP2E5i4FUgZkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033688; c=relaxed/simple;
	bh=HWp/8F2/KSt/PYmKtaJg7t+PvM/Lx5qHKs/eqPiGIpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jm4INPZ8U63M3++S/0V16VItIqH5kbr5OhkNVaF45WVLow+gxR6wH0re7TkTD9jVK8C0vb82pWgUVBy8Smy75KJrRGUf4bz6xKAvw9N83hQatEQh91eAo0Kz+ilVzLQlUcDwmzwVpDSUTbdDpxJITH6Aft8j/A31cIrWVcvu+mQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ENSGA/5y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DOg5LcnV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ENSGA/5y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DOg5LcnV"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PA10S64019325;
	Wed, 25 Feb 2026 15:33:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sQU07vUheAsYkUyfCAtTf2Ha6sRvtwEPVUrgsTH7d+s=; b=
	ENSGA/5yA9UWc3qKwtqeJeNQHzt6ucdshFnpHBph5w9Y25WkClNw4KtEJS1eOoYv
	2VvyPhts0ACRs01Oguq6946qgsDf5rRkcIuqs4Y/CSQarOjIpx46BEhTE05ogpVr
	UIeIpuBxyBM6gyBMpy4PvcFMnN35xisbYyyrLHa35SxPBkVjLm26T4AhkjI7gt55
	ockSDTNgBsRh38eErtxr87+k9rdP0AFhKgqIpKrx1v3ezVmavcjBjnrSmRHoNUKx
	V8i90pXoOudtOkF2CjV3N0jRuuMlMsiEkm+1konexdzjioqbysxrIvTiXb4J0NC0
	SrXDdamuOrm0kRS4oR2SNw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a06gwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEE0ZN006327;
	Wed, 25 Feb 2026 15:33:11 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012021.outbound.protection.outlook.com [40.107.200.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg51d-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzoWF9leb88veGnRXFPDodloOr3q+yI00Ys7iUigOa6hvEUnb7wzarwmtsas6IuQoSFmiMrhPSVp6t4ldRqHtOo+fdZQtOkToiVHLhSTZxhx5251kooqWueCsY/cLfF2lFkttUpugDge8VbOVn2QasL3TveqchonR+KLyIxGxbh7eptt+2GQyjwHrWG2OdwKezTcGlEHj3UCDN9uLYmVcZhxJSBKm93d845UVCRzOpUW1qQWh/IRgXmLLiNOlwwq/eIYp4HPDF+JociEfnDw3a7MZj64mUYC8iNPV3OH09q3lZuOeizkSS7/nBkmQXjocrSxou5ncetf5CEevsglCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQU07vUheAsYkUyfCAtTf2Ha6sRvtwEPVUrgsTH7d+s=;
 b=CgG2zde2M1tGaWS8EqzxUk/r02TvLdhxK9S3ZmQuUEzLHxa7tKUF0yoVBDV7l8dx/uBQAePlLjJYxBVUoqqSKg7VXSLGR9ptz36JGvqWVhO6yRuPgSK9cvfEUZACT6uP8i9ji/dbn5zQR6hd5OWr2TN8AotKTWaRIIuoS7D3oCNpQj4AR6cuegjyYLFvqZJ77lxq+RZ1stuIT5W4/XQyHgyUm1eYbwc27PLU1pJSwO7/uR91FsNqsWJRCVjvtwmfNJlITklqklTW4+MSrN+hYQ2VDqZjlXAblcdlPD1XlePOqgP+VtDPQ6CiaiPQ7N6MXbx9OKk/u4WIUkBhrCQvzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQU07vUheAsYkUyfCAtTf2Ha6sRvtwEPVUrgsTH7d+s=;
 b=DOg5LcnVNFbck2a2nhpm1rni0L0fz2pBMa9xowJYbS4WVuYjegqQYiiJeoSOG5mp6dOxCTkkc+z+3Wff7o7xD2dpdJ/h1VZGJms6NM9Ny5xEJuZuqQRJD/S2Rz1aanbjNXhJqZdxPZHp2LoA0affmDIYnPIgHjjq5OOD4/cCYVY=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:07 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 10/13] libmultipath: Add mpath_bdev_report_zones()
Date: Wed, 25 Feb 2026 15:32:22 +0000
Message-ID: <20260225153225.1031169-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:610:e5::30) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 5275fcfb-f158-425d-2b5c-08de74832cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	iLnLO1guR6IgKKncoY+QIGzhJ659m5w9JOCxA2dcCTFWP/CdQrEHvZcCf5yUIEtltQxUfM6RqIJ+SDKgLKo3TzTl808shfbOyfAec3SJYsNZA6eegxAByUvTLMta2l8NsViJNijKc+l0/ceocdMyjC4B2g5ofYFDNL7JyO/2+BaenPaJ4ODs0f2SZ4yST5fd3fJ1gv5Eat+X1cErQch79r14YOBAaSm+i3JKgz6tQontXBrczQ81WLVHjmTAlnyOlDfIq72DNsFi9vOnBYJbrd1RCjTTzCws2QmzL559gvxssUvoo9RzH+9WgchrdKND03MC01yKkMmIQDd5ivyYzZ+KmnD0v1NEvW39xVhi7YCszGkfD94OWRGHYC7bI4w8AnHwjV8qUXGaI1rke5QVVAnCxGFsNqiUHj6J538rvn9bHZL8Bn4ob+ACcfEwLFVEqzSq5iFEvjkkjrJZ6B38upIBrQogdGA/RCzmMkFRKXL4HhrWTCKzCQ+3v/vPESAXtcGVERHEQZT2/MSlIK/N68u+ePloyHu8A8T2LIXmbcqFMTSbtepaXI/ynSLMMnPxFNQxV2Am2eIWzx6y0wPmByO4Zd1kKpkWRF/73oGSThP1lcWWJ3S+Y3QXB5ovL5KIdOYobv1kXBu7jomEGCyWmKlAN1zbmXNcy+RUPA5/T4jHwQr0lpIOL1fVNYlO2FdNC5qrKHo7H0oYo4eFMNfPVbeCcOUbGEwNskA2EyOSbTA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?phQSG9TQr4oVktvzs64ef9FBT932c1gNFOIePp/P+yT5SiX4k8O7AIELvC9D?=
 =?us-ascii?Q?cuV7KjhfvsxfKMjsJs2SQswspttLaWoPfD8ccGdDLLxoRYm9REJXeFQBp6Ee?=
 =?us-ascii?Q?RKTrnXKzwXkxUkCC9SnI+WXWJuuSY3DMH1p7r6PnIwSK68Y1yohrC93t8+38?=
 =?us-ascii?Q?aLnKau+rueBttdXs6s2KVgQ/6trhf1s/ER5UX8MYxJONaXKXo/Y4skT3/mwD?=
 =?us-ascii?Q?d+nC8Atw9foLESFVGl7aIjDYWZeBAkYUqGFOcl1RUn/NINPATNKdj+D2PjcK?=
 =?us-ascii?Q?5NHbz3ak6pZdBf2OEvyZmkdOI5bOBSDDtiKfi4R7DPXzhsHG8gXKb2xntRW8?=
 =?us-ascii?Q?MIg5AiogIei3kFqjB896filgaPafZMWOiw91z6k2Z/+s0bsIjkAWrjSv9vKd?=
 =?us-ascii?Q?3eXGuTsY7l5ZrxPDFcUm5SH4gWo585JSDr3dAdH0jPfjAlr734r4bImtJl08?=
 =?us-ascii?Q?v9joH44tXh9CSwGZJrg2VP2ZdlemdqUfFQ/7kAskxfxCe9YAbwTd6ygsFaaD?=
 =?us-ascii?Q?yMn4wyxyhDLqNd8Bb2VVHTA28oAGoSEvJja3Isa4m9CUigXgV7UA6szBYMON?=
 =?us-ascii?Q?MqyiP7aMvIXnChTqp6G9A1OoCOVsjAm8KJpn1YKwUjTcbU35gMdKS7GIARH1?=
 =?us-ascii?Q?zhfAxQ78BXQ+j2d6M5C7xQNpYH5fjm1R0hNMNFuxj6/oYPCHgmAyc9n/KGL5?=
 =?us-ascii?Q?+NW/xnqD05nYtk1OyJ59KyT9zIiZdV6GeTNzoL1GxQ8rtENP7jPHikPbQI4z?=
 =?us-ascii?Q?ZPbvU+BNoGM1nFPUqslzJNjd5Lqn15agzdXGoZ4a+NdGrbGyBZmNRKJ0+j3F?=
 =?us-ascii?Q?ULnjEMgrGcvjiE9X1wibhEhVrv7ZH83vzloMslkcmQLETCo7i7mMG7Ge06OV?=
 =?us-ascii?Q?s3jr94M6SEfj6mxruQnhdc5H18v84hevK5EmF/g5iTaHLyoEB8Z/t3VOUmNT?=
 =?us-ascii?Q?3w8P7YuY09AeNnYZyKXkhn/3ZnSQTZ8t2YaB6/PlMr/71kfxRA2S6u+7qwps?=
 =?us-ascii?Q?iQ4WYpZqropfVK3oy2nVNuwx6tZyI39h5sqZB9oCsLQS7SVZGMu/01N8beH3?=
 =?us-ascii?Q?YZYbbOCIMqcvugPfW9GH/lYqK3atuGCSQ7QgQkpkiz92RRs/c79jvblNu6og?=
 =?us-ascii?Q?YJon/MadBB+KLG/aIAw/fqmCz0za0EHNmdgBMdHHWKWHxTKttDhbH81VyqdF?=
 =?us-ascii?Q?0Bq4qHA9sDydZ9psamoh570Fsalp7e9VuJkjuDhJQ8p0gYSuFIYgR68UQUkX?=
 =?us-ascii?Q?aPZpefWkgdtP1/T9hhCSbF5eCF8GLDSLCU45pl3EQuDi+nVQlpqs8rempIOV?=
 =?us-ascii?Q?BVd+SWSXwScVRZD2HMvYSPVXTmexoXljY/5keeoqARH/cqL9mBlW57PAlKc9?=
 =?us-ascii?Q?sZM2pFPkTIV6P+9sn14X0X1u4/LnK8bt7hdgO6FEIKuSkvKCRiqTu6//4Lvl?=
 =?us-ascii?Q?9X7aNo+cdXD/smg+tB63MrzNzPzemKUx77Neo6L9tWYwk3L4FftzmgWc4C7k?=
 =?us-ascii?Q?BaQS9AEW58Jmifptp8s6Dhb1aZ1FtavAUEvmnLfduvyppX6OWreraJ2FoZnm?=
 =?us-ascii?Q?rNztF06sE0jdzCQS+sI2DXq2zbS4qB7e1UiPPtXHlIP2G/2JgfM/2KNZLulv?=
 =?us-ascii?Q?JzGOFbkX+BTe86wLlMGu46mxIb63kq/UyGCUGVbnBSQGbnM2d3Oq+mMprNrh?=
 =?us-ascii?Q?HbaUipgKu/7NWdEas9/YJmHcDo3uvL2x8JqWriwQMZtoFUcy1cjshJt1umnx?=
 =?us-ascii?Q?m0sA4LDhiqCCMJr9fDcwfn/a6vlRwd4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ugzIRq9ROXuuN0YxGJyPGEV1C9YAg7H5Z4fbIuwyx75aKSJtBGP1sHcBavyQg7gKARkygzJLfdPCc7Ay0SY6wTBv/Oc8V1mT1gF2ykNlnZenkSdzOrbGQU2kMfI5svL8NkwsECW8KHCtY8u6xAS1XHhe/6YtqkQz54yHZXnMgWSgb8qomHyJNyxqh9HJxf7UCk4uLD00Pf7ukXhpFjBT9MALaIOfDusGU+YQUvq+kSKM3GZDbkuQOP8fzxVRsvhsQ1cl17huVvNeKrCQxHYguftO6xkk/5nwWFDRLuuSb/m+Pu50Bm4QGEdrweRNZOx5U98y2NuiLMrFfeNAyqvwLd9SHYnZkCnoQveWvcPdRyN/S7HpOQ3w9vMIoIlryDDnNa/xcjtC3P/Q5iBZ9bs1xUdAmb7nLxveQAmMNoTWB8znI4EZItUgRl4op7au2rZvbJUxj5x/PGXycW+Pq7l81kyn4pBknLfvFEfd3cvSezgNqkYrYgqvHLHFJ0UIgxA0JdvDnAd7aiiZmeWO/mCxpGEFHlHE8zUkQCOUd/WhbY/G7a+gWc2YYR7afCcmI5LUwAkbMzFUVYy7sDyxV7MpDWcpEbCWSBYCDD8gNU91BpA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5275fcfb-f158-425d-2b5c-08de74832cde
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:07.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O2UTAk4BBDlPcIOtiTORw/6STwZxDnteaz1mqHtU3+nfe5AgM3iu/NuSSV7pnFKbEdATg7zNMvOBmm+Qz6Fk7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699f1637 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=gdRrClqiTsHH2txTDKwA:9
X-Proofpoint-ORIG-GUID: p8IABHmkSdtH5fCqxZc9bM7XeF_X3I5Q
X-Proofpoint-GUID: p8IABHmkSdtH5fCqxZc9bM7XeF_X3I5Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX+rWvNPSC5trQ
 1V60UPFS5rglR7xcNrBHMgtyKjQnt9Pu/zEoiro93YpRjtFW1u+TyY33/tlpFtWrwl7TxUMZNyX
 S/hJbo/lN1rrTbdonP1ieTokk6WJQWH/pSpMkpCRMcSdQQi/1FiYhie0LSi8BeLaKPvzmNcGBKt
 Xc0PNsu4I2g25f6d8zhj6B46n41y2cuk0CwA5XJgsHGVQBJoC7bG7bdMqB3M6E3EFMj2+vjkgtH
 4lIxCJ/2NsFUwmk6uA5UH5Wq7+1uWwHvyPcNkYBE0FjHsTvTKKYp+4qRUY0J7tKIVexfOZltWG+
 5Snws5/c+82Ov4NAcijzSKr0sCc/A8jpWBi4pbeTwL5wo58otkLo+gqGm7SNDiyyZpo5Lb8f44L
 hqfwMNWo6WCmG4b7XbzECmVi0ogblpmvV5556Eb7BEo+stpOezVxfvEY3CZ2rm9+bAykS51CKty
 i0olPQNOt0YUl4MBNqQ==

Add a multipath handler for block_device_operations.report_zones

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  2 ++
 lib/multipath.c           | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 454826c385923..3846ea8cfd319 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -74,6 +74,8 @@ struct mpath_head_template {
 	enum mpath_access_state (*get_access_state)(struct mpath_device *);
 	int (*cdev_ioctl)(struct mpath_head *, struct mpath_device *,
 			blk_mode_t mode, unsigned int cmd, unsigned long arg, int srcu_idx);
+	int (*report_zones)(struct mpath_device *, sector_t sector,
+		unsigned int nr_zones, struct blk_report_zones_args *args);
 	int (*chr_uring_cmd)(struct mpath_device *, struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
 	int (*chr_uring_cmd_iopoll)(struct io_uring_cmd *ioucmd,
diff --git a/lib/multipath.c b/lib/multipath.c
index 8ee2d12600035..4c57feefff480 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -40,6 +40,30 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static int mpath_bdev_report_zones(struct gendisk *disk, sector_t sector,
+		unsigned int nr_zones, struct blk_report_zones_args *args)
+{
+	struct mpath_disk *mpath_disk = mpath_gendisk_to_disk(disk);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	if (!mpath_head->mpdt->report_zones)
+		return -EOPNOTSUPP;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device)
+		ret = mpath_head->mpdt->report_zones(mpath_device, sector,
+			nr_zones, args);
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return ret;
+}
+#else
+#define mpath_bdev_report_zones	NULL
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -622,6 +646,7 @@ const struct block_device_operations mpath_ops = {
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.report_zones	= mpath_bdev_report_zones,
 	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.5

