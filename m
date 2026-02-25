Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC9D3F075C;
	Wed, 25 Feb 2026 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034130; cv=fail; b=JmcvGGNGvWDGa2luObVmLnr+mJHcyr7R1eW45GIVbNzL+F23g3C8F6BYIp6LJcd/vPwDBvg5nGoB8Po4jXslCUaC5Aau4KJXOmGVpsEqOCdddVmraSa8/MncztFAK/LTMk3D91kZ56JrygwddxHqQnF68Y0ZKsScgl5tt7t5bmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034130; c=relaxed/simple;
	bh=FrBVHfZCPPZQ/4hQOZOuGEWG1BewiYQ0cKUbisuZi6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LCcbM155umCnpbcXZ2KgsbD/w0SNyB2C7wAuYOle/61XQGI4crfzwkm4nERAAHxWrkQw1uCwJ5sec2OrwN6ur0B5lYE0uz3xCYMVYqRdfOPbjU3VF+A7PF3+F7mhdvGPbjtMt4RyknI0BiQzDhPaBi/LnEyJKGXhJMZ5+53MS7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WBAGxRBq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C0apNM9g; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WBAGxRBq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C0apNM9g"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAYSUi719577;
	Wed, 25 Feb 2026 15:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2dybJn/vBOsx8StXvDiQTGnBXjQQHwYIv1GVOy+AeRY=; b=
	WBAGxRBqNUe39HJR/14gGlkItCJJ1dbKXS7o62E2SS7zdLmU7GOaHDeCXrG/NAQU
	Yv11PPvY2hGss5KPmLU5Jx9Kn2GTqJsqRKS4LVRvL8rTNxzcgg72+wlv8YBLVFrU
	4vsRjcPLk9k0GRzBrsa2MhCDDuO70tChrrwBMh3Tm+/nuiJx+eOhUgDxgy38hb06
	BX3uJkq6MGoxSPom87xv65tDUY2OqtdB9pvPvULJ61r73hWEp8560HWg7giRc3PA
	5Y1dczxNfbvNWbgP4Wc8lFPeAErl1uauNA9hQZCWWQUgMPoN1R/hDxIfWbBfW2Bk
	0fyD5muJPCUjT6uECqXO5g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b6eqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF7TS4012588;
	Wed, 25 Feb 2026 15:40:50 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012039.outbound.protection.outlook.com [52.101.43.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg53w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uz3C3qJ+PHzSf5I8NAEvttsiR4EuXg49XGf8hTjfVS26yHgshKDE44meFKxPess2WWyWgkdP46TDlk+cAeIpNmBnXJjxScPhB606bOGct8K7gGzaCi0yydg760yGf89YAwMpiXIPwQNMP0Yw2lQo5FiNIGXYt8sZbb3ulUxWD3WD3cHQfJjYvGbcEHGQTh/sdEZnplBdK4coYR+1P8OtQrDEdNg2c32lLVGVQGOEt7F79LMCfloEgmlflJ4DKfpfTZN62X9WXNNi2OdJxqQFsMRoMjRA55hxISXHkUvXorm2CDREOk3V9eAHa7UiNkoGp0SliMROz96p2de0G+tMog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dybJn/vBOsx8StXvDiQTGnBXjQQHwYIv1GVOy+AeRY=;
 b=AEGgvTL8CYso6zeC8AmBb4TIi/WevJeMl0KoyWrhOV6ZKgyphmWiZh+4efGB3d6w7ju8e6gjBJ5i+AZN6zidOcETGdA3+gZ3KKRVxDMIFOJrHybLY+wIqJ8Gn4Uu2xqxQXtMlJ7npePfzcVom8qr08FouUPAVcSKhmV91ULEboxAFSlaUrjc0ci0NWx08eafViPCALOWqiv0nIitkU4gfnHELbhrGveymZL/kDLHCAziPyjmOJtQoUJpufIdT7Os3A64b/ex/hTcMhsFkZ3Hukt+/g/Vc4BUnnNojVv6ruIycOVWlWtZQWGm+vOvVBOMUq5UV+2Pnm0ZgPplB0FpcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dybJn/vBOsx8StXvDiQTGnBXjQQHwYIv1GVOy+AeRY=;
 b=C0apNM9gs47/WEw+5HvbGvWO4LZFxnV3277jWguEOpiyAFMPJt2BHpCkMuZ+mxT5o6Pm72s0ROdAaOpsESVfV+3maYNSvfv1KfpFZKFwtGy+DT0fbJR8bInCZWXdQtX82X9dm60BYak5HtP/cxV2PrQxKQ+MhFd2Dih81jrpqXo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:45 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:45 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 12/19] nvme-multipath: add PR support for libmultipath
Date: Wed, 25 Feb 2026 15:40:00 +0000
Message-ID: <20260225154007.1033735-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH3PEPF000040AE.namprd05.prod.outlook.com
 (2603:10b6:518:1::59) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ee43a02-ce06-45e6-0151-08de74843dbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	Gwz8IAQ/lNv9qcf5WQxOj8FkPKPmGaYuDazBTsrSIhkKIfuxIEs2s5loT1LHEGHObagBI4cLIyn2bqBGidxoLhF96OSCcsTTHcIA0oa86JWHU06gSfDfQ8uxuzy1VkiXU+tuEpZ2Alta3WzWzrj28M/VG3mBZbjUrjHM7g/cZLAq6NDAFu8CXiTCuY6H9Ue6tmo//9oihl624S19dURLSMEch2qaEYQh6FloO1GPE901TfsDrHcU09bmNcJvcuQ+RkbyeObRAQuQ68Cedh3mZzAh68vPjqp0331fvDjIhTKe8yqEFTNMUWLcTcdzJQD2R+ZZ3fZ4lwwIhdff6CFSYt5HqKwzdumodYdm1uFuMIdp9AeGrU5RB+wKkZTTZQUMzMW7eIhlyXuFtiCkXRk3w76iJert4wgQglgavzV1r7ShmFktc+SFXrWaZhxUIx+ytP+PxUElWecomBpb500j4a9OwWq6nfnNcl/OmZLs9xINkdo8EZSTSwG6fY9jGz6CZT/eQu6JTUwXCVFz0dgDqs+xUHtQBzF1zAN23ZBlSdPm0n/j5KfH8MNXxIdF5iPy8lpKaE/Cgsvg4LOFuMWkQy7kMfIx7zbJPoEyhUdEw9mYZ1BhQcmWwfr9QuyDpc9CQsVwEL3ThP1bpHjHTSAaqYcaReoEaIJaA+aOEATKWQpP8klZHbpCG5+BkM7naXX2UtwuidzvCxhmHN7dKC/MZT2068prZ0EvcdKMLkpUiDE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QeSrVnRrsdFuSv+nha1qZkH/vOdKI5/RVcClsqJaSWn3Nq1oLzMrmqAKS1bg?=
 =?us-ascii?Q?v2gQB0hrQr3q1Gj2sE9wXqcZyJOyEtray3VjQ+6DpmRWkV/m+t94o5wgSr7J?=
 =?us-ascii?Q?7wwrXDvhGvz6RW17i7Gbi2GYVW2pL3/8WyGMDc1aywxEHXfRF7+3BkmbinhM?=
 =?us-ascii?Q?zdcn/pc4/+kxt6/DP6wDY8+Xm3rNBZF57CP+s02DcnpG6rF/2MpKMKNpvi3b?=
 =?us-ascii?Q?yu9bkqs47j97azg0+MoNVRhyOAegq/Y+esj+T/fv0/+nA3j0MlT4VGUv4c7i?=
 =?us-ascii?Q?RNi3azkOpcPQVqqF2VOJj/01LSlub5QsVbkURo+ToXLD8KU0NDJIX/6uz+DZ?=
 =?us-ascii?Q?3w8OjHaHsML/ahj+qwgAaGzf5ucmiF1ewcuvGh1lVDAoyK/wmkzcpZ6IfoS0?=
 =?us-ascii?Q?pUJQaKSI3/QfduCxRqMe2v0CgzMbYFWdDDIkVQw/CbOn2CBuYgE4IbulhV0o?=
 =?us-ascii?Q?b5SwPaBJpKSNoRaoksgDhF33r2m9yR9jiJkRjSXE73wBd/4qK+Ttb3b8GK11?=
 =?us-ascii?Q?9biYn0EpWxxOB1/H01/RSqlt+UQNfheNSr1GAeOaQHeJuexeFRmMOhRQ8J+f?=
 =?us-ascii?Q?BEIpqu5jmPHxfrxHwvowFN2k/4cnlHEL2uNbMWXwLypW/7SYJ5kv/3D12zTp?=
 =?us-ascii?Q?uPo4Dv4J62Nrndj7hEPSCAnh2Y9qtnoYDAQZw/NEfDE7xvrCQh97OVGW85Hg?=
 =?us-ascii?Q?kchMxxYoF7VcX6TAeNFSqOibFI2snEhHo+guRWJ4Q9yX9vk4P1kX6EyEasS2?=
 =?us-ascii?Q?cXA+lc2In9bts8xFbRNE1Vq4zWbgYoTKE+wqR9GeMQb7TSh2JQLfMeRjWC39?=
 =?us-ascii?Q?ACsxYrGI7MjHy8ss62nUgVWUIGRM+EgCNnTNlMBAXbRpsOyGzaHbACCBjxlA?=
 =?us-ascii?Q?4ym15qkLrsRuDND2rIXi/tMi+T+nnnlo1CmfL5xXWl+1N+dxmOvKj8aHJbu7?=
 =?us-ascii?Q?oXa7uBljgwLtdCpQBfyDasHRklKTArLhbbRskexsxKWVrGgHWQARdEJZfmsK?=
 =?us-ascii?Q?xwg6pfYGMt+++mbcScJjDggD3mDanHYJzZvQU/KiBbN+YKJ7lJZuob4r3F7J?=
 =?us-ascii?Q?e4CvnzPq1U41cZeW5oX+IytA7xwV3Mas5EWB3qojYbYbh7XRt2T/moBM/OPR?=
 =?us-ascii?Q?nQO5tfug+W4UdbkTkBoV7Ff5NC02LdZQKMCkMnpoqoapISXcg3fYG/1fQP3m?=
 =?us-ascii?Q?pOhdvabb8V2qHPdDDOkKkx7yv98/AGEJtYB5SC/YlkaB23aKOuYmxFsLCLOw?=
 =?us-ascii?Q?FGER++7GkZmCE6B0Ha1RIa+Xf4UiuuOvGr0exvmbSsiBKxC6B1NpILJjk+Gb?=
 =?us-ascii?Q?GBcpzu6AEMWH1LtZRtlmTAaPA3TuDL8y/fLex/CrWomm4QiRCwDE1GFhnzwE?=
 =?us-ascii?Q?uxexg6tm8TTcA08CqpeYXd3tR5ysm2MlNV919Sy91VtFBV3xhI8RvQVO7m5b?=
 =?us-ascii?Q?/nyFWQHegFc6V1zRmC0tk2uaLB+52AN+cRWyHcegJvC4Pg2dfsqDQ9X4q/Tz?=
 =?us-ascii?Q?08iIeo/EhkQl11bMMjskOkuJtKTQkpQafk6/eTrRbT7yaPSLHKG1CL7YVAY/?=
 =?us-ascii?Q?X6w23TF2P7/qrV38M+kL2LGQgKh0eaTtua1nzs82oUFIGETcuG8NrHk54Hfv?=
 =?us-ascii?Q?5qQOwWJ8Fzn6WYAjH6P35Zi4NaP43w1NNw2Y9Shpi3kaBsCGC4NPW8OQXUPE?=
 =?us-ascii?Q?beUtVyJPtm4w+A/6fxrjIvAmyHh7JYM7KWHuegqrZqQZCO614MPakZVmuqDy?=
 =?us-ascii?Q?mrU1PMVHGpHxbQ0ZDVO+uZUq3Rdlib0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LvMi17KbTMB40xs/O/Riu9ehcShZgJ3Q/xTOKJyfcBtWct5+aLaFvE8/AWQfpjCe9X9oE/26Pw130C/WWW/yFRnxlGoEsD4FT2EGFbLjLCDUaiPUd4eaLDliVb7h+yU1wvKv+nFQXk/RRtYn38FpdrQhYxlstiqUTR48tyoD8gjQVUDWDz1qR7OQGbb/CH6YeFHb8USbu1KVY3/i1F2bX6bYYOacLxc21Z/ZaqcjPtWkelDhEF+UTWaw23esiusg3xEzDYlV853Z/JtcmnTtVSUcsDmTFoHY/+AZi9tYLMIBjz+whYeHQ0HdJZcIQ2xFfnwTgLM/QO4QLyig1dZ/0Wu9xozkfM0/m/5M4DkcRNCaPwylMIqeb3PwXvSjWbISbKGzTZYp1zmnYf/VQCSgJ/oJpZdYht3RGHV5+19YwKofdSqnCdIiKsxSDwYGq94BSZEJVw8d06u+MCNj1fCpYCLfSm7hjx6Is31EEEWJVOUszeAAeni2yWGcyCgPVb9B1/mPs1YKSBMhwwhxlD/vhkRb8cXh3t3cd2BKs5Yqf9RtVni8kahc5Wx2OXjMMFOK1iWwdQcYPMNn8y0POgb0cnAASwHEd58YS5pxYbgalW4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee43a02-ce06-45e6-0151-08de74843dbe
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:45.4878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RRlBI57s8FMKd93ev3r/DlUb48R+QOOHDuSrYaQzPN2r4Tj/U7IOkTAaTMCX5XEz9IUfTihbIGNoJIqKmI8zfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699f1802 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=aVeFJVSm2r6GLGaMoIIA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: cMKlWq5wxMFfyR34hRKEVD0LVjXHQyi1
X-Proofpoint-GUID: cMKlWq5wxMFfyR34hRKEVD0LVjXHQyi1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXxQuaB08tzmmu
 62kJkCqz/+6ABGWr8+CjI5s1h1dX/PzH0Tb8Ja0La4wQC9I10+jhNuya2E/6/KadI7d4ThkUinb
 Mpe+vxhjNJx/wDfGbJenT2pSpKoG+Vd54RDLkvEyIbsTZNrnBozaET+cg9RbVyxKs/j4VnKC7lK
 2bs/TLPA2BTGr0qdL62HRxgaPYHBicxJT8/PCg7yU7gTNrDkXqUbPvZXYffCCmmxfNuWcFDPjl2
 So7IecutSSXgb/q5KoQ8ciAZ71xYmEPlq1SsbRj0ZBtFnGVHYGmKJkakpmCdiM4lGhdBXi49PE7
 kOBqCpgedNghvW50EyNF0ENNKHVRHWUEY7Z/+sresdRYVnhN5XVBnFCs1t8qQpCx2jBgBINh/Sb
 HoN5YXSdeS70bu9ZWbmGu3dDVWXxaUH36eSsk2P1Mzo19Ud/tKPeKCNHu/o4cvnfARTV6QQXZOW
 jYm+18KHKyVhiNb0HPNCrv4BwaDt6xxaHcD95g18=

Add PR support for libmultipath in the addition of nvme_mpath_pr_ops
structure.

The callbacks here pass mpath_device pointers. These can be converted to
NS pointer. However, the current PR callbacks for nvme_pr_ops work in
pass a bdev, and the helps us this to figure out if we are for a
multipath head or a NS. Later the send command helpers can be changed to
work per NS, when the full change to libmultipath happens. Until then,
have separate per-NS command send helpers. The original PR callback
functions from nvme_pr_ops can also be refactored to use the new
NS-based callbacks then, reducing duplication.

The new NS-based helpers are marked as __maybe_unused until the switch
to libmultipath happens.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c |   1 +
 drivers/nvme/host/nvme.h      |   1 +
 drivers/nvme/host/pr.c        | 314 ++++++++++++++++++++++++++++++++++
 3 files changed, 316 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 6cadbc0449d3d..ac75db92dd124 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1501,6 +1501,7 @@ static const struct mpath_head_template mpdt = {
 	.get_access_state = nvme_mpath_get_access_state,
 	.bdev_ioctl = nvme_mpath_bdev_ioctl,
 	.cdev_ioctl = nvme_mpath_cdev_ioctl,
+	.pr_ops = &nvme_mpath_pr_ops,
 	.chr_uring_cmd = nvme_mpath_chr_uring_cmd,
 	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 	.get_iopolicy = nvme_mpath_get_iopolicy,
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index da9bd1ada6ad6..619d2fff969e3 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -22,6 +22,7 @@
 #include <trace/events/block.h>
 
 extern const struct pr_ops nvme_pr_ops;
+extern const struct mpath_pr_ops nvme_mpath_pr_ops;
 
 extern unsigned int nvme_io_timeout;
 #define NVME_IO_TIMEOUT	(nvme_io_timeout * HZ)
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index ad2ecc2f49a97..fd5a9f309a56f 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -116,6 +116,51 @@ static int nvme_send_pr_command(struct block_device *bdev, u32 cdw10, u32 cdw11,
 	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
 }
 
+static int __nvme_send_pr_command_ns(struct nvme_ns *ns, u32 cdw10,
+		u32 cdw11, u8 op, void *data, unsigned int data_len)
+{
+	struct nvme_command c = { 0 };
+
+	c.common.opcode = op;
+	c.common.cdw10 = cpu_to_le32(cdw10);
+	c.common.cdw11 = cpu_to_le32(cdw11);
+
+	return nvme_send_ns_pr_command(ns, &c, data, data_len);
+}
+
+static int nvme_send_pr_command_ns(struct nvme_ns *ns, u32 cdw10, u32 cdw11,
+		u8 op, void *data, unsigned int data_len)
+{
+	int ret;
+
+	ret = __nvme_send_pr_command_ns(ns, cdw10, cdw11, op, data, data_len);
+	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
+}
+
+__maybe_unused
+static int nvme_pr_register_ns(struct nvme_ns *ns, u64 old_key, u64 new_key,
+			u32 flags)
+{
+	struct nvmet_pr_register_data data = { 0 };
+	u32 cdw10;
+	int ret;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	data.crkey = cpu_to_le64(old_key);
+	data.nrkey = cpu_to_le64(new_key);
+
+	cdw10 = old_key ? NVME_PR_REGISTER_ACT_REPLACE :
+		NVME_PR_REGISTER_ACT_REG;
+	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
+	cdw10 |= NVME_PR_CPTPL_PERSIST;
+
+	ret = nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_register,
+			&data, sizeof(data));
+	return ret;
+}
+
 static int nvme_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		unsigned int flags)
 {
@@ -137,6 +182,26 @@ static int nvme_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 			&data, sizeof(data));
 }
 
+__maybe_unused
+static int nvme_pr_reserve_ns(struct nvme_ns *ns, u64 key, enum pr_type type,
+		u32 flags)
+{
+	struct nvmet_pr_acquire_data data = { 0 };
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	data.crkey = cpu_to_le64(key);
+
+	cdw10 = NVME_PR_ACQUIRE_ACT_ACQUIRE;
+	cdw10 |= nvme_pr_type_from_blk(type) << 8;
+	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
+
+	return nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_acquire,
+			&data, sizeof(data));
+}
+
 static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 		enum pr_type type, unsigned flags)
 {
@@ -156,6 +221,24 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 			&data, sizeof(data));
 }
 
+__maybe_unused
+static int nvme_pr_preempt_ns(struct nvme_ns *ns, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	struct nvmet_pr_acquire_data data = { 0 };
+	u32 cdw10;
+
+	data.crkey = cpu_to_le64(old);
+	data.prkey = cpu_to_le64(new);
+
+	cdw10 = abort ? NVME_PR_ACQUIRE_ACT_PREEMPT_AND_ABORT :
+			NVME_PR_ACQUIRE_ACT_PREEMPT;
+	cdw10 |= nvme_pr_type_from_blk(type) << 8;
+
+	return nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_acquire,
+			&data, sizeof(data));
+}
+
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 		enum pr_type type, bool abort)
 {
@@ -173,6 +256,21 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 			&data, sizeof(data));
 }
 
+__maybe_unused
+static int nvme_pr_clear_ns(struct nvme_ns *ns, u64 key)
+{
+	struct nvmet_pr_release_data data = { 0 };
+	u32 cdw10;
+
+	data.crkey = cpu_to_le64(key);
+
+	cdw10 = NVME_PR_RELEASE_ACT_CLEAR;
+	cdw10 |= key ? 0 : NVME_PR_IGNORE_KEY;
+
+	return nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_release,
+			&data, sizeof(data));
+}
+
 static int nvme_pr_clear(struct block_device *bdev, u64 key)
 {
 	struct nvmet_pr_release_data data = { 0 };
@@ -202,6 +300,45 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
 			&data, sizeof(data));
 }
 
+__maybe_unused
+static int nvme_pr_release_ns(struct nvme_ns *ns, u64 key, enum pr_type type)
+{
+	struct nvmet_pr_release_data data = { 0 };
+	u32 cdw10;
+
+	data.crkey = cpu_to_le64(key);
+
+	cdw10 = NVME_PR_RELEASE_ACT_RELEASE;
+	cdw10 |= nvme_pr_type_from_blk(type) << 8;
+	cdw10 |= key ? 0 : NVME_PR_IGNORE_KEY;
+
+	return nvme_send_pr_command_ns(ns, cdw10, 0, nvme_cmd_resv_release,
+			&data, sizeof(data));
+}
+
+static int nvme_mpath_pr_resv_report_ns(struct nvme_ns *ns, void *data,
+		u32 data_len, bool *eds)
+{
+	u32 cdw10, cdw11;
+	int ret;
+
+	cdw10 = nvme_bytes_to_numd(data_len);
+	cdw11 = NVME_EXTENDED_DATA_STRUCT;
+	*eds = true;
+
+retry:
+	ret = __nvme_send_pr_command_ns(ns, cdw10, cdw11, nvme_cmd_resv_report,
+			data, data_len);
+	if (ret == NVME_SC_HOST_ID_INCONSIST &&
+	    cdw11 == NVME_EXTENDED_DATA_STRUCT) {
+		cdw11 = 0;
+		*eds = false;
+		goto retry;
+	}
+
+	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
+}
+
 static int nvme_pr_resv_report(struct block_device *bdev, void *data,
 		u32 data_len, bool *eds)
 {
@@ -225,6 +362,52 @@ static int nvme_pr_resv_report(struct block_device *bdev, void *data,
 	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
 }
 
+__maybe_unused
+static int nvme_pr_read_keys_ns(struct nvme_ns *ns, struct pr_keys *keys_info)
+{
+	size_t rse_len;
+	u32 num_keys = keys_info->num_keys;
+	struct nvme_reservation_status_ext *rse;
+	int ret, i;
+	bool eds;
+
+	/*
+	 * Assume we are using 128-bit host IDs and allocate a buffer large
+	 * enough to get enough keys to fill the return keys buffer.
+	 */
+	rse_len = struct_size(rse, regctl_eds, num_keys);
+	if (rse_len > U32_MAX)
+		return -EINVAL;
+
+	rse = kzalloc(rse_len, GFP_KERNEL);
+	if (!rse)
+		return -ENOMEM;
+
+	ret = nvme_mpath_pr_resv_report_ns(ns, rse, rse_len, &eds);
+	if (ret)
+		goto free_rse;
+
+	keys_info->generation = le32_to_cpu(rse->gen);
+	keys_info->num_keys = get_unaligned_le16(&rse->regctl);
+
+	num_keys = min(num_keys, keys_info->num_keys);
+	for (i = 0; i < num_keys; i++) {
+		if (eds) {
+			keys_info->keys[i] =
+					le64_to_cpu(rse->regctl_eds[i].rkey);
+		} else {
+			struct nvme_reservation_status *rs;
+
+			rs = (struct nvme_reservation_status *)rse;
+			keys_info->keys[i] = le64_to_cpu(rs->regctl_ds[i].rkey);
+		}
+	}
+
+free_rse:
+	kfree(rse);
+	return ret;
+}
+
 static int nvme_pr_read_keys(struct block_device *bdev,
 		struct pr_keys *keys_info)
 {
@@ -271,6 +454,70 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	return ret;
 }
 
+__maybe_unused
+static int nvme_pr_read_reservation_ns(struct nvme_ns *ns,
+				  struct pr_held_reservation *resv)
+{
+	struct nvme_reservation_status_ext tmp_rse, *rse;
+	int ret, i, num_regs;
+	u32 rse_len;
+	bool eds;
+
+get_num_regs:
+	/*
+	 * Get the number of registrations so we know how big to allocate
+	 * the response buffer.
+	 */
+	ret = nvme_mpath_pr_resv_report_ns(ns, &tmp_rse, sizeof(tmp_rse),
+					&eds);
+	if (ret)
+		return ret;
+
+	num_regs = get_unaligned_le16(&tmp_rse.regctl);
+	if (!num_regs) {
+		resv->generation = le32_to_cpu(tmp_rse.gen);
+		return 0;
+	}
+
+	rse_len = struct_size(rse, regctl_eds, num_regs);
+	rse = kzalloc(rse_len, GFP_KERNEL);
+	if (!rse)
+		return -ENOMEM;
+
+	ret = nvme_mpath_pr_resv_report_ns(ns, rse, rse_len, &eds);
+	if (ret)
+		goto free_rse;
+
+	if (num_regs != get_unaligned_le16(&rse->regctl)) {
+		kfree(rse);
+		goto get_num_regs;
+	}
+
+	resv->generation = le32_to_cpu(rse->gen);
+	resv->type = block_pr_type_from_nvme(rse->rtype);
+
+	for (i = 0; i < num_regs; i++) {
+		if (eds) {
+			if (rse->regctl_eds[i].rcsts) {
+				resv->key = le64_to_cpu(rse->regctl_eds[i].rkey);
+				break;
+			}
+		} else {
+			struct nvme_reservation_status *rs;
+
+			rs = (struct nvme_reservation_status *)rse;
+			if (rs->regctl_ds[i].rcsts) {
+				resv->key = le64_to_cpu(rs->regctl_ds[i].rkey);
+				break;
+			}
+		}
+	}
+
+free_rse:
+	kfree(rse);
+	return ret;
+}
+
 static int nvme_pr_read_reservation(struct block_device *bdev,
 		struct pr_held_reservation *resv)
 {
@@ -333,6 +580,73 @@ static int nvme_pr_read_reservation(struct block_device *bdev,
 	return ret;
 }
 
+#if defined(CONFIG_NVME_MULTIPATH)
+static int nvme_mpath_pr_register(struct mpath_device *mpath_device,
+		u64 old_key, u64 new_key, unsigned int flags)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_pr_register_ns(ns, old_key, new_key, flags);
+}
+
+static int nvme_mpath_pr_reserve(struct mpath_device *mpath_device, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_pr_reserve_ns(ns, key, type, flags);
+}
+
+static int nvme_mpath_pr_release(struct mpath_device *mpath_device, u64 key,
+		enum pr_type type)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_pr_release_ns(ns, key, type);
+}
+
+static int nvme_mpath_pr_preempt(struct mpath_device *mpath_device, u64 old,
+		u64 new, enum pr_type type, bool abort)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_pr_preempt_ns(ns, old, new, type, abort);
+}
+
+static int nvme_mpath_pr_clear(struct mpath_device *mpath_device, u64 key)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_pr_clear_ns(ns, key);
+}
+
+static int nvme_mpath_pr_read_keys(struct mpath_device *mpath_device,
+		struct pr_keys *keys_info)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_pr_read_keys_ns(ns, keys_info);
+}
+
+static int nvme_mpath_pr_read_reservation(struct mpath_device *mpath_device,
+		struct pr_held_reservation *resv)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_pr_read_reservation_ns(ns, resv);
+}
+
+const struct mpath_pr_ops nvme_mpath_pr_ops = {
+	.pr_register	= nvme_mpath_pr_register,
+	.pr_reserve	= nvme_mpath_pr_reserve,
+	.pr_release	= nvme_mpath_pr_release,
+	.pr_preempt	= nvme_mpath_pr_preempt,
+	.pr_clear	= nvme_mpath_pr_clear,
+	.pr_read_keys	= nvme_mpath_pr_read_keys,
+	.pr_read_reservation = nvme_mpath_pr_read_reservation,
+};
+#endif
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
-- 
2.43.5

