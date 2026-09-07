Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E31D483BF6;
	Mon,  7 Sep 2026 10:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778330; cv=fail; b=fzYr+g3fbOqjcr89JgfcV8vdck5Yu86wdAK1F6ZiG7Y+oDZVAkMH3DGnhJZ7lz3jWeUF1UBdsJ5d7J3dg9TblepR1tUqhobHc7Be4L04WlACpSZjLoIhww2BATyMqwvSwAnppgCMN0qj9GPLJmaCfKHotBH5vbXj2ZOA/yJk9mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778330; c=relaxed/simple;
	bh=MJ7T09CSj2OhJXnu6eqGDqUSNRSFdpZ/p7G/MlvP7As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hi3/rvBZ/oFOz9T18ScH5cejvyoprbBgv3ojZmWxJxbX2x9cFurOaH39JTld4mxrsgCq0RJLTo2kuqyr3F2A46RiWpO1rE2YkOLanHYPFkAe0Ir22BLYEFjJsoofv867SL2do0ro4BnF2hgo77VS2bb+OOE87cX+3NgsMT/F3xk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DtuBgLVm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JgsFTQNW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DtuBgLVm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JgsFTQNW"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686M7BLK4149628;
	Mon, 7 Sep 2026 10:51:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vJbOfKvRVlzRjL7W+H01rA5iZ6OWj9chK9K3eQXbORs=; b=
	DtuBgLVmn8lmljtjRA5+BoYm6TQ9HD5Ng+tI49T6fRlmHHQw/OmXjuywtsvAQTi/
	38WMSnAdRY7Cb4i013HfIADoLizet4iPQXVMd5aHoqUm0HYUJ9TqtgqlmN3fiAKG
	JEnRWTw63GIBqIcsWRzS2Sl5eIFAP4WIMOILG1eOnoaZisuYqRBf4hbSCe68NQyY
	oVSxygGxYKETdckzuVc0UetxZTQScIpy9i1DheLa3dvUBvBaM0ND0IISkUSo71Bi
	V5J4nEtXj0FilxU63pJralU1GzMfiuwRdRMJ7MTG7ApFEXoV47QMhErmrGxwdCh2
	pRVN5tu6W3cZk+Bc23uhbw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbmq9t48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687Aopsx019105;
	Mon, 7 Sep 2026 10:51:39 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8sd8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x33vlRnKetOk1W4XKgtpCPdO8HNSK4xdl0EVExqmJ62amIhTW4DpJAqoVD1l+Zc8fTm1yAEjDQFO9qxqiii/pAzPQ5zkBoK4crEI4YPjzeixHqrDUEmmLJHUb27G6bOOiim1UvUfGapHxo/5l38j205W/Qq0YzFaCZyegXj25j4FRWWb0xFKFfCU9faYHfrejteVabD1p5RpeXaYEyg+k5rojuhN2Gt9uL1dsD7z7iD4O6fbRD2MoFG2ZsjiuuVa+X0ttDGWw6wS4pBc+cvZecFR26E3Z3xaa0oWjBtypxlDQoyvwgj8HzAxFW9XTjAZFdUcirVW+f/T05qF01OplQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJbOfKvRVlzRjL7W+H01rA5iZ6OWj9chK9K3eQXbORs=;
 b=wmbg1+k6yun82QtP7DO87SLN4FFZDRprxLs7Cbk+qQcovICeDDTq9oJB6xNjIsQfw41YJ3lrtJ9hgDuCFq3gvxPZ6qfc2BHd9vVbg/3wpKX4q421REJruwfX+aCejdwm6nAEHFg5um2KEa5rraG920gmbdT5Pbdtv2U6EAnCJApHi6JEZexT/WzjJ2MVlM2QLQRtph/jxxQn3bSDEtK8zWL8zhuEaQsoRXVJB22shnYpPKmTjkp45GTb7D5+mN4Oexv0rtUOySXD9HdtoAtzFr6e5jK9V/O0U7DZLOFIVSF2j9NPbgr+frtZN5Gx+Wmr/uyAsoSqMrBLkmE9knaRuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJbOfKvRVlzRjL7W+H01rA5iZ6OWj9chK9K3eQXbORs=;
 b=JgsFTQNW9W9mYoLP2nMNKfzm4HhSO217fMg5/EdbFHOwJffax7eZjqWpTEDiD6qFa1WrHWFLZBK/zFlXZdW22bm8tFSm5KJ+4IcazF5OMMFgnNhE+Rzb9qkW062OPxXtEVY1JwpEfJdkZd054k7ygVPPkNpCj9T6AiSGxIhGKK0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 LV3PR10MB8012.namprd10.prod.outlook.com (2603:10b6:408:28a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.4; Mon, 7 Sep 2026 10:50:38 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 02/27] libmultipath: Add basic gendisk support
Date: Mon,  7 Sep 2026 10:49:56 +0000
Message-ID: <20260907105021.1763236-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|LV3PR10MB8012:EE_
X-MS-Office365-Filtering-Correlation-Id: e525ba85-159d-4860-8557-08df0ccdda33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	TmWbz4xCpfN9K829tzY0P5x9IFu27BJHC/RvBA+pdOJN5pCNjNtpKbnlaR3B+f+GgwJFSqZklja5bo9/rVTEuPhJteFuoHx4/Sewzk+ZiQHxnNxi0SawdFZgsj1rxLt6p2ItoHCLV12rguYoltVFNtvne4lkK0X+thK82Jsl7y+d8XXT84/aNdr48pkhRsz1H4XQHcrRbVaCirzsbv8nWz/A932TOeiS1jTP75eyyhFTEFQVQYww5tDT8XnUb35Cz29SHo3wTfWBKwC+wF71Q5oe4Ez2eOF3LHUYKciZYlbnEi9Ue2yPDOPnDWuQFsCjztjhwmjQQYlm1TJy1OIPsC8rDsVQZCN7gtkhlVwdGIO49fZA+rtm/wCx/OqiZHQPO/6ciKr4BkgYv0WHpeBSuWeViPN1JrRwUZaLNBejKBEvu0AKGjlCLqMhEtxRb651ItnIegQBbgTGNGeiTeJX2n3fflI3ropNpQqB8JcS4KP3XYW41x4KpvLhshqt5kdViMRe+Lp25/PqNYevEErusEI3hGjbacKuzGU8XKBZm3pNjpRE7J2sdeNtYoUoUFb3UMqilsoCffFd2r7YOP0QcfbZrWiFVBFT7HycdNOVOoiZouofdUXS3AkpGcgbwMMAGitgDvaDmEgatyKeJme4UylGnv/Hflrwoogdhv2W45c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z/NvxXK8Fp9yw9JPM8Jo6lGTPbrLMNvcN0qflvbMeG7L7wCm2J4uCfj+2qxs?=
 =?us-ascii?Q?ZUTlYJaCj1W3sCFg/BcauOtvkERkA0JAF8lx0/zUcs8LPDA69ga/2dg73FNX?=
 =?us-ascii?Q?F/UHmjfr6NXcNtZZcDHhPclQvl78BKgC4dGKS89x0YQwdHeSn8RuxLe+fjoZ?=
 =?us-ascii?Q?qfkY5hhkITYxaMDODfw617MXtnZBRuyzsx+ZnGI5YwWzshrybhUFZU/ZfxPs?=
 =?us-ascii?Q?N2CpkuT0E3qtcZZBlnmn+/rCRk1CPqphWwfFazJDotF2SuMPEABYcvNS0mw/?=
 =?us-ascii?Q?mtf9dvJqX+OwIQOlGEGm0SnMsedvVpaYpjI775FopMRXUPpU5aRler8cdq5S?=
 =?us-ascii?Q?BrpD3xzAvfRA8M1AVrTFwGAta/SKa/whd9Be6mndDq4gYXmWELTfpnb0tjYT?=
 =?us-ascii?Q?NZkE38fP9taGryYLzBVs7FTp8a2AyPV76XzYjXl5+/uKw/Yf53rXs8fpxA/a?=
 =?us-ascii?Q?QJIdAQrcqdZHreEYORTCWtWDHVCMK2JKqU7Dwy2modoDL7uc9rFlH0ECa8NQ?=
 =?us-ascii?Q?Pslt+4Bwx6LDMYXo+hHH2rx0+4soM5u1rijpyn6dnN3O9QgPebD9tW2aCcgZ?=
 =?us-ascii?Q?z//nSdtnPTlqZaaxt10Em0YQPqWCosmcRzfsu+rxeQOzwT+We95eb2pZhtWF?=
 =?us-ascii?Q?GrrMe1Uw/ZFJa91AuCKiGvUZ0ESPgXW1iP2MArRWZEy7L9mf/JohQ/EIoGfS?=
 =?us-ascii?Q?zBwuhlmE119DJja9Xf1PI9jOsPvWP18pS0MmpovFEyJ87truNks5rrH7DbxX?=
 =?us-ascii?Q?R5Bd7bz+9ymoA1uPFbEg2LuGtZmil1Eq0C8nOXZKGOzOh6/C+3v+b9KLtXDB?=
 =?us-ascii?Q?xzAXj8bBWW7oO14PhxHlxcwqqu5I6TyxTWSIK3ynMzDSaGI0EAY5FEjr0lCK?=
 =?us-ascii?Q?s5U5tGne7NzMVmktqyHm1WJt/yXSvUNQnB68irNNWDtX4nxfEI44FfQf66dp?=
 =?us-ascii?Q?q+tx8gwaEey1dPvtLstJGxyaxDSnStQ4YgQmaaHxo6hOX571AWXcO1Fuxbr6?=
 =?us-ascii?Q?9VZM9m+/cIDsRZHmiD1kvY3wybIApKOO+0nDKkBrMy6BCkiLgDyjSgs7vTSK?=
 =?us-ascii?Q?KLnZ6LRT6tgrM3tCUZ26paTqk2laWgweMpXmu3N2GRTxFsjZgvSfUvWcG/HO?=
 =?us-ascii?Q?mUoutR7eDG/+6gHFlZ9Vl/zYwLfijfTsvroDf0CuZ3UBsPTVaRI+QuywJouW?=
 =?us-ascii?Q?AUpyXgvBAZeJBVaoR6j+DGHY8gPiGXYiru11T0RQGYphsVGkFJ6UKq95uOsC?=
 =?us-ascii?Q?lnHnAWrQpD8RPz/mTsOP9qZeCCwbEsIdutYRgXfriVPASbcUJQ6m1SVspoFR?=
 =?us-ascii?Q?rlZ6SUy6Am4cdbYzj5XlGqG7sPC43RyFhN2qArCafAdawCo0Rve7/mWq0nTO?=
 =?us-ascii?Q?CEOuTURMJM6tgQCy9d7KjycWir42oCOv1goMPe5opSGjeSW+VuErQswrXhry?=
 =?us-ascii?Q?kNSXFzTacU8Z1nmp8X+WqslVZsM8XpRoDN0fqULiGWKGZFxyBMkGwUnBFW+C?=
 =?us-ascii?Q?Z3ZDTeLg//8oX5yEJRYzfkS/0sAWES6IGjO8u2xez+YemhNiHqZCMvp6/3GS?=
 =?us-ascii?Q?wEJppTJ3i3G3h3atWI0H8NrSw2Yn8QbkHTGFID0fyQuvkHhFVOp67+fSGM+s?=
 =?us-ascii?Q?F9aoZlKcOLi9hUrkXTmvHL9/hOroqmLHf0c7ejqno9vSGVuJs3nxIQXs4hyd?=
 =?us-ascii?Q?YC08GQvFJVyo1LJK1MEhgv83zNd6AknNQj9ZJPbgXo/iRWkcouaZtlNG4pJZ?=
 =?us-ascii?Q?ndZ2O7nSD0TPL48YcD+P8BSqYQEI5Io=3D?=
X-Exchange-RoutingPolicyChecked:
	N8cflrfh65OZzr1U6w2466jDRDFof9fqPAcNgcuuffSpndV9m2DC7NSqWwdQNuHfAc2mID3QWjp70ks6z4bhTJdzx/68LwCPgYUlcVEAw4HslBMfQrSOv8vYDOirqvNWUXQ+egXStcfv4K93+9KAkCmtcIzH9KkcrimFb75pVfxOOOBkY/Fe0p8WSvH3Q0waZf87vOx9IaZNBLIti0t3cV8PAPqxnSH/J9F6C4UUbqVse3HJg2Ibjk7iqmOFPHpyvPDM0fO1oyOS+Kv4wnyzYmGXxeivpcePvPNHEFqdv43ujPUdXt1k+giL3sICmUle5MGSTDYDkqtJdzF8hRKasg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iLXwcWC6ALZEynYrfiOrTl5WAkxGkeGmjlV0beSFGfj7kND7pVWxRtXsSiuu7FnQwnQxzqZmmAPHabxIapoWQYuqycJkf5GI4YjczVw7OjTVHVUYnaoWbl3bFCWwdRai5xf1Aew8iQ9AsiPHNzF7QEEhVZFkx6EEv4X7mcC2XrZyIpqMl2b5EebdoIlJMD0DUUu36W4A1aXmC8c+ktIA37dOut7iX3KmuayxPPT0mfilGizwf3WNq1wTp6zGa4PZDJzfjd6dvKIjFut19fR4RPX+ZtBHE9m7EcJOzLLi0rkw+EazsjHDKiCfBPcINZOjPVZon0KYL+YGJ/+l8W3F+A2G5FV/ZZ3KvAw+ia9Ol6vJEjPlYaUJuYDAhFQhEIObYlsuvZAd5Xo+84NgfmgqvuMa/9miYVD3T4vLCzdp3HAY0yP5uwkvxQ01ZZhgSMzAiBmFnpB2htwzFLEYfHEadVGpTNlNy5mAHY6K1qVi5sOT3QiLtva6rOaFyEKAPgHJ/0NxM810mhEakoDdU2Nf67eQFD+BgI17PTk2JohLPDuewk4vtfVbmGQO54DDgsAXkUaaG4rebZyEEWuzFCF/Pc1bdCrJ0RK6ncfoxXT0Nu4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e525ba85-159d-4860-8557-08df0ccdda33
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:38.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +TuvBZ/LW8Nxel/ZpHzkh0fjCIaMLwbYwrlzKUKHrA1Uz817hCf2ENawMLbjLck1iycTgtbWAZqD55qJo+uB+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=JYiMa0KV c=1 sm=1 tr=0 ts=6a9e973b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=B52eoxIPv8yZRAGToxQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX0WO6lwvjQS8Y
 qeJ3omRkMyO7iRyBXHNmypVBfRAh9JWwi3Dl544sbEDvoDASwY5eLRciI4PIhbDiSLto3xthbWy
 WiIudsaIwgIc0pSOcUpDXxQdQr5wa5+c9PWYDSAZcOMKn1ubq4Bd/QcfUHaAC2C8DPsEsQcjkET
 Vnjy0XpRXPSd1ojoT2vrMSNIZSLGF2AmA3IPEe4Xsulo+5OvF9yP0+HYNcDlz1eQ/wbDfyzaswB
 6tO6XNvks0Ik2UAbzH1xmcuH48IZ7ZyStK4/3oCkscM4ORcvZacr+aktzQ/RCRLjcxkXCc3QJal
 hy9+Sze6rU6RZk3SFM74wio/lSmQN97OUie4NaAGFnVTWvRF/sXNh9UPFMRsnqqVNbbSVhpJSpO
 SbRWqYuiiFVPlTUmorYd1NgKyFrEEDKmTR7YJyaOrROXuVMWU2qv1Z9W+K41kaAgERPiOwfe27K
 /W7DmQXgsV53iHfoUeQ==
X-Proofpoint-ORIG-GUID: 3HYzvUn_1Awz8BC9morgbZ6ZJaAVhoOS
X-Proofpoint-GUID: 3HYzvUn_1Awz8BC9morgbZ6ZJaAVhoOS
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX7U3PYU6ClVrq
 B3T8pIxkuqE1actpZn7yAur7AEYkSgXWaQIMTvyGFBbgMtRl/v2qVY4cEk0FrFR/WFvpYFV6r0b
 6YSj9ixQRV/FJSEjVNJjyx9eAutJqKiZ8Tf0L+i26ZH12ObljZYY

From: John Garry <john.garry@linux.dev>

Add support to allocate and free a multipath gendisk.

NVMe has almost like-for-like equivalents here:
- mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
- multipath_partition_scan_work() -> nvme_partition_scan_work()
- mpath_remove_disk() -> nvme_remove_head()
- mpath_device_set_live() -> nvme_mpath_set_live()

struct mpath_head_template is introduced as a method for drivers to
provide custom multipath functionality.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  38 ++++++++++++++
 lib/multipath.c           | 103 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 407d985cd31f5..ca6e02505be43 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,11 +5,19 @@
 #include <linux/blkdev.h>
 #include <linux/srcu.h>
 
+extern const struct block_device_operations mpath_ops;
+
 struct mpath_device {
+	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
 };
 
+struct mpath_head_template {
+};
+
+#define MPATH_HEAD_DISK_LIVE 			0
+
 struct mpath_head {
 	struct srcu_struct	srcu;
 	struct list_head	dev_list;	/* list of all mpath_devs */
@@ -17,12 +25,42 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	unsigned long		flags;
+	struct gendisk		*disk;
+	struct work_struct	partition_scan_work;
+	struct device		*parent;
+	const struct attribute_group 		**disk_groups;
+	const struct mpath_head_template	*mpdt;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
+{
+	return mpath_bd_device_to_head(disk_to_dev(disk));
+}
+
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
 void mpath_head_uninit(struct mpath_head *mpath_head);
 
+void mpath_put_disk(struct mpath_head *mpath_head);
+void mpath_remove_disk(struct mpath_head *mpath_head);
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node);
+void mpath_device_set_live(struct mpath_device *mpath_device);
+
+static inline bool is_mpath_disk(struct gendisk *disk)
+{
+	#if IS_ENABLED(CONFIG_LIBMULTIPATH)
+	return disk->fops == &mpath_ops;
+	#else
+	return false;
+	#endif
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index f7b26c66eac7c..574868ce53381 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -36,6 +36,106 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_head_uninit);
 
+static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	return mpath_get_head(mpath_head);
+}
+
+static void mpath_bdev_release(struct gendisk *disk)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	mpath_put_head(mpath_head);
+}
+
+const struct block_device_operations mpath_ops = {
+	.owner          = THIS_MODULE,
+	.open		= mpath_bdev_open,
+	.release	= mpath_bdev_release,
+};
+EXPORT_SYMBOL_GPL(mpath_ops);
+
+static void multipath_partition_scan_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+		container_of(work, struct mpath_head, partition_scan_work);
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &mpath_head->disk->state)))
+		return;
+
+	mutex_lock(&mpath_head->disk->open_mutex);
+	bdev_disk_changed(mpath_head->disk, false);
+	mutex_unlock(&mpath_head->disk->open_mutex);
+}
+
+void mpath_remove_disk(struct mpath_head *mpath_head)
+{
+	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		struct gendisk *disk = mpath_head->disk;
+
+		del_gendisk(disk);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_remove_disk);
+
+void mpath_put_disk(struct mpath_head *mpath_head)
+{
+	if (!mpath_head->disk)
+		return;
+
+	/* make sure all pending bios are cleaned up */
+	flush_work(&mpath_head->partition_scan_work);
+	put_disk(mpath_head->disk);
+	mpath_head->disk = NULL;
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node)
+{
+	struct gendisk *disk;
+
+	if (mpath_head->disk)
+		return -EINVAL;
+
+	disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
+
+	mpath_head->disk = disk;
+	mpath_head->disk->private_data = mpath_head;
+	mpath_head->disk->fops = &mpath_ops;
+
+	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head_disk);
+
+void mpath_device_set_live(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int ret;
+
+	if (!mpath_head->disk)
+		return;
+
+	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		dev_set_drvdata(disk_to_dev(mpath_head->disk), mpath_head);
+		ret = device_add_disk(mpath_head->parent, mpath_head->disk,
+				mpath_head->disk_groups);
+		if (ret) {
+			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
+			return;
+		}
+		queue_work(mpath_wq, &mpath_head->partition_scan_work);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_device_set_live);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
@@ -43,6 +143,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 	mutex_init(&mpath_head->lock);
 	refcount_set(&mpath_head->refcount, 1);
 
+	INIT_WORK(&mpath_head->partition_scan_work,
+		multipath_partition_scan_work);
+
 	return init_srcu_struct(&mpath_head->srcu);
 }
 EXPORT_SYMBOL_GPL(mpath_head_init);
-- 
2.43.7

