Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365FD47CC75;
	Tue,  1 Sep 2026 10:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259670; cv=fail; b=KlKZO87wUxYImw5PJJxHUNcGyyTyNwxLeQQQn0bq4dnZ+LyrYU4UOZmarqKhXNwpUoDmr0dEXNSiGuKUBZVZT49d8PmuNPg65onyJY/N7dKzOudODXh7m5f83Io3Lv9TGtVpWdXR7NMP7m1XyMthjwJaehpPw9opLvALFHUI3vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259670; c=relaxed/simple;
	bh=B5XC+D/K7eecREwi47Ova7lBvJ7BYgJLxt2VaUTRJ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FR7lwUeedKWqEO/hT/xUtWEtN4F7iiTETqy6aUSTkCPJIewvm8zmxgCdnkcMSuBeNVMMhmJzymGQ5e9HRzFtM8gquZEbUelqorWQ6enMOHqAZh2JF4TUHg9m7n8Jl8LkXTov1Ba4rVVegs1UajOIuC3h3CzQcfMe5sT1/rcedYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bFUi4g6B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CFaixoUe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bFUi4g6B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CFaixoUe"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLCjnX2848122;
	Tue, 1 Sep 2026 10:46:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yowEivTEH11FKs/qtsaOoa6ih5PbxcKY+XnaQ7XBdSM=; b=
	bFUi4g6BKhWqNsAJJxmgUBA8uubQlEzFltQUWwaj0MNJsNvhFkuHARLTajoEg+H6
	TYy/FiBYVZerN+pVfHFKjI4kRUnLfahxXB+gWA9oIplXdQ+dNflAr/FivNjWwWy1
	bOniek+yIiAhknrmOMvIisHd8SUwOwLRvQfQPBLEcSUD/fVhKjz0vE2YvQ1f4yHe
	r0BWYURsT0BM2jVt0xElfrAy/FGDSWU933yiQaZANot4xOfPQVRYP10U4xpdGZ/b
	rcf15HIIB8/o0bGkLWofbUrNx+Lu9XnYj8Gs0oxyMyjQbrjDRlN4RZ6zLNx8NEiE
	tosZc6cpsz7XlcRWjC31FA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbavehc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681Aja7d001164;
	Tue, 1 Sep 2026 10:46:11 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013026.outbound.protection.outlook.com [40.93.196.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqac08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mWmwdH0HGp4zcXZ//eiyHLll81slRyjSRjEN9K4Ylnp5Bp+Hpci5Lde9ODpKXScZyvMK5Vq1+8ntfKmWOWeZqSrb8hAvLHyfQ9O8BvbSVPMBz2f23RvPNcUHfMDjtTgvQDetqK5telDxbMacZMxS64bGvdKHlsLwM2N8Y68mrxlcUD2/RO1CKbm/2W3Z2fbe1qNDroq6d9fbxqNFDKqd/J12afWpPYhEbDjIY1pNKzNkKaolZcemjeYH0ipUAF5btWaWcFLqK57fM5R6nQkoi1eKC4GPnSIh3t5OAt/QqsnCQ/m5dXF96OZ1+3PkmbUzECQNVzujv+hhAtnWMErGDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yowEivTEH11FKs/qtsaOoa6ih5PbxcKY+XnaQ7XBdSM=;
 b=V2/P+1NdlhnV7lYdo1Lw0Ceyks53gwp1miZ3ZdZ6RZ+JBLQGsUpHDYqvr7j5C43IHhPaDSzEVSy6zEL7p5ZjIUKw/1Yy5Rjn71206lv6XV6w1fAiEs+nUPdQzk6eq4i1KlzCSdkXpbK2K3CHkgiCMnXWjUzw9scNkdZUHUN6OqtjZXsgmO3PBL7A23y8UdN7UUCs5TsBXa3Q+81e9Y85I7BJUnTcmH+u/KNJ47Tsq1oJQ4OLbU9a1qpDXL0z/b+APbhEAmxwPi2qsG9RZuMzimmLIiLK8F832bWE0pA/wW/+/C9mc6PqHlPmKgJN68CIzLiEZk42SdbLk/tkbs0enQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yowEivTEH11FKs/qtsaOoa6ih5PbxcKY+XnaQ7XBdSM=;
 b=CFaixoUexAnypxbeso2en8nSR3TUdxaBM4CLc4khLKnsFkVXm+sxmo3/FIca5+J5Pp+1aDWsm4IPtKSyjwyn8xq8Q4ftU5Z4G56lv6P/O1pOpUr3YlvO8DVeEeLWRmqpkpy1bFjacsDFjxb4TWW03yapTVq35GBQd3hFAli+230=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:08 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:08 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 15/27] scsi-multipath: clone each bio
Date: Tue,  1 Sep 2026 10:45:14 +0000
Message-ID: <20260901104526.3850621-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013307.namprd07.prod.outlook.com
 (2603:10b6:518:1::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: aa9ac8bc-98c3-4716-ac80-08df08163b0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	mdEVKYbnKlU5RpAkqfKMy5Kw6eCOtEALdVdwQ5SZDGcHTS0lji6PaQboIv/ZkjUUJBP2YuWDnOQdx7P2yA6vh+ZXByAmRTsXQBTRrMH4K0WzxH9Nws4KOXIz6j/kx7/YW+V+f9rLIQH2RmGbpCFjKN9tbvg/OaXqg9sv+QUvHXSxJ0bQSPU6Y3khMcvaM9VH5QYCkloEFtbL5QuIIMxINLjEfRPhfo+Gl5wqe8JEKlWa6s6Q2yzFQaqQwaOPXYD95UV3gHK7rYqA1je0e+jMNLwde8Yk5wqKk79zWb7mIPKi1OKw5iFU2CKoEUiGR8RKDPRFuSNeMfQVfmQjUGfIcoVs5FvEucXIEzn+bTj3ywIWEKGXfrMbcYm2PfuptOQDif5HL3Jek41AmH59LkiywVaJ78svqrZ8e+/JfJY9PA24Sicaw2YdJKz/Ihoh75G9CE+ZnoTesLLd2TrCwKAIRKJUfj/ItCTvlM9iup4r+xa4NQWup9byVbnyb/AV/04GJYEVo8WVJmP7L4sg/Esn4cwbpnPt7Py0BJQB2YuBcnbadAQG0hW7GZyOrPzkZCiRTfXlb3VpyJiuu5iapZFarSiloYkUHHk0TKgcxSrA2ri+dj72rBXruAAdE61K0R+AAp1yfrZ05AA+wYUNN+jxYBgGB0EgnXRbYo9kxrKbAws=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sP61gUa1rmli+vXwr64R0RKM1hi8UupMP9PsCOqgvJSgNBRB/1mGppHmXeM+?=
 =?us-ascii?Q?wW6xJGmr5Fs3oU+PJraEBG4dPtCIN6yv/7uj3MG9ATN3L5RPXuVn3uydOtsa?=
 =?us-ascii?Q?nmEXmeVih+fyHQjOFmGj/CkqiGy82g+xaIIWC2CWCGegRLhuyfIdozId35Rp?=
 =?us-ascii?Q?Npwm7spSpBoheXxpMElR90bd+fWiMlsohO96/CWAkG1yYS73Fo6urgOKhLKL?=
 =?us-ascii?Q?vgpZn/8ZOi0PqsdFE4Z7pbCatDYmVh34mI8235QPK9AqAlaUpy1ZLqfTe6QJ?=
 =?us-ascii?Q?Ga9ry4wuz7rlWh6AZs//RsQtdwNSe09bQ3xbCtsPGKowJNIuPTMAbRH7iewL?=
 =?us-ascii?Q?7NqXhjdNLD570g8qqMJSfniaAvdZowu5vF1RX8ZRB0hE8zHxTFVkV9k5siPJ?=
 =?us-ascii?Q?wI1wsc/iRqnt3V7QgYb6ahdazFx8sZPY2wGirNfZo1qKcmAitYZ4haCt/+QA?=
 =?us-ascii?Q?oPRPDECsd/eQDHkfh0VlvkbgoeXDsbGRHKGZXRUVm9xrXLBuVIUuHOKIFGhp?=
 =?us-ascii?Q?ldtNyQbm0iEdaCgGCjshs5FgbybgwIVYUchlcAdqyGzEUdyM7fyeSJjMa7sX?=
 =?us-ascii?Q?p8S6QKUOvpFj1fN2EcoPmFCjIn56rzdWI5jQ9+y67Ss/kdEGtyVPA88hHc0X?=
 =?us-ascii?Q?Ig8R2REf2dxGj1GUW4kmkiH8U0UU53+XmRwNVbDpyg0fG7yj6kgrh0punpwC?=
 =?us-ascii?Q?kSWXLiAj9ffjupbyJkq1IQWiQgVwh+9EwG0n4w7yk2eEMhZjqY34aMh912Gx?=
 =?us-ascii?Q?W5VQeS9RbBHn1k2RMIT0kt8dlg8Y7wjK5OhD1UAcrErvzCyb6AMO+StNR/N5?=
 =?us-ascii?Q?wCoBgS0X3aDmzpXmojuwYC6/MvGF2HAAf7/EvecuzB4ypf+5+ujCRgpLMfqc?=
 =?us-ascii?Q?FlT4nmrmbq/RIHG9wGMe5iRJbaVekol4dNa8IeOLZ1oDkhs7Hgz0whcosM6N?=
 =?us-ascii?Q?b2U4AdoOJSLxMWc3XuOxnTwxUj0TMcAgPMSGN6yiqySMHwl/yIUHlrzfrB1i?=
 =?us-ascii?Q?X/UbmYvq7C20eamyV9TaMLNfwf6Da8oFst8rkI/oV3lzICkzwFX+yZSSba7h?=
 =?us-ascii?Q?GBIpDHW/H3BwpVFcEc+9SthPn5K+iMwIFQ6zlZ+EVUhAegUoFZp9MnqrF+Wl?=
 =?us-ascii?Q?zwFCHYdJjOI0r9iLrfJ4R+Pfz8hBw6nR2Uyz7xrdMS7xNarEuaPHGZVZmWeE?=
 =?us-ascii?Q?3gtLu2hgeoCnAGsInYZLebuoQjmA48BOROw3UsN62G3RCQ86XnBrOa+khhX3?=
 =?us-ascii?Q?KORcIXKIdWscHWj3VFUNdLxPvhra8yl1P2YfFL+MHiZMdepnNNtwBN6zLRCX?=
 =?us-ascii?Q?59W+C2sqli3h4Z54qxjGbdk49DWZyuHPr4qPBrhgLEmJu1M0e0EONfqprxfD?=
 =?us-ascii?Q?Kdn2Aae02uw3wI/VaERjDNLD6y65PLUdrgPRZrFbomKh7WcmwNMdL5PRsKLs?=
 =?us-ascii?Q?8iREInKMVzoHF5cDY6AXJhl0x5Dpzv8/S7+pd8nonFyqb0rA1GkcV/Nyumca?=
 =?us-ascii?Q?QECCAc+hi7EV3TYAaILptX9VluY3X7nb+ddMXRtefbR8PNP6NeG8jgBO7HqI?=
 =?us-ascii?Q?A5AxOJrn0I+l7dGrxVQyy6Sy84IVmccwyqdCRHKm9kdiMyVXnpnJeKtJd7mK?=
 =?us-ascii?Q?UmpqB2kgEnuO0nFpwSo209LMOp6VLQ10rKRl+ASgEP+aUlSIA9fYzXJYf9M2?=
 =?us-ascii?Q?usFy9mlktUu5v2vWdnvkQBWhfQpwfvImUjeufs+WaC3bFSFtXx1pxqoGQnA6?=
 =?us-ascii?Q?Ol+DYcvXMuFu1uz7PZn7d1tu1XAWsSk=3D?=
X-Exchange-RoutingPolicyChecked:
	oWgHZDCfv7bk3decv+LVyxtEJ6cyfcIMjH6zSJjGA3vBqhHscFBalZEBUBN6jDe5OFWuYRMzO1swIMah2D7f8rMX0l+52Q104APJScF+KyEQPvc2N6Ylz+FyzwcTh1BhVs9ilZ/bqKEn8PNvfz/5cicTOx1QV/tvcXRp0CuVZfY+6+JfXcQfLJ9fwUxLfrNHcwTpDaBYrJUHT68p6DUwPkIpVuYTMii0NpqF+NeCDkL+OOuyX/5ZYF66mkthjzm3HZ2UqNb2PbMYHU5HhkaN4SRE0V1Uf96sbkSBPtbtF5EiMxpqMfM6J/KJ1LfMDG5qtaNI8pFhn+cSpzfLDDV78w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8UaPADu4JJSNqAewTOZp/D8Pv2h+pNyLByg2BApTUbEvTEKa05wntZ4xs6XrjGKqdPtC6yVgPPnFhBL7T/ieiABtCgwYBjBPOOLZdpeDxkUNUKCsiC0kTltc6ITkMlRN1DqSkEJoo2HInMmIGNpsO4FUYc7jIMOewuxX6xUQnZzYGwkKJ6pOlvVw+45UM7xJ3uKenwmLsHyh5Uq5tHBklgYuOgGvhFpxo8FVFI42IvI5FjeMtZc0a6fz0MmUhhLcprvS2ig2bzhwfxkaGccFZwoWyRPof4w6G+39gK2ZRjt/Jsc6nBV4VINc3500zVcTDQd+pJAeCaSumN4R/ETmzDmqhyOzPyWPyE9hjtNpodjhEfjYDZ0mTNEM6cj7J4UI8Nv7nBe8QOr4PSPvlDE9xGVhalfHL5jc6d+dfHTkGRUqQ2c4N3DJtaz4AFoW6GWAGLNVfqEfHLUl/tss6QvMNXmsPhC4BBMs/TNbd5o5+FIAdUtwvq6ce8sLOq05noEFlHBJ15NPCHwXcmKkoJqrhl3bQ1UdONmpY1xfe7nYUvcAfea4A6G2H2a1mMO2/M+NSDYkcpHyfbk4eu0gwtqsYIf6cwFI8O5aVuPxJUzR3os=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa9ac8bc-98c3-4716-ac80-08df08163b0c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:08.4163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2+e+PaqsatMRBbvrFJHQep4PBRBkPabeJvDpo44LmMQjOt+R20vR40xK5rkHYntzGdYcgiLFBGIlaaL8Hd6FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX8bmSqGsL6ZeB
 H9voz6wInhmigC4GMg/oUmuQ0GlR4U+AfYWaPImmyDOmFn3DSJF+56qp3RJMdCkz8/nqfbVDRof
 G089Sj0jc4XPbkmzB2dJOgvIFiKRLfCIc6f+Iu1Cx47USr5q9BNR
X-Proofpoint-ORIG-GUID: uOgwZAxme4faSMxvXlk7PLt8ZTk7gLTl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXzh11zKQd6srO
 ioz/z8LWs9G18ki5Z/jyRkjNx73CUghFzWQ+m9WUZzapMo5beMTm0WioCtw6O1w7SZ7FeoWOZGA
 73ND2KTQuOWAig7iPX1Sp/f1joo80wC3wjbhDROlWH1v+iK9fc3hsUSMpbrwqi+5eF5onIrNkCH
 q4sTgLdkT8uXnsWFfZ4Fz8Try+Q4EpDYi5E5PbAp4n9yaNwGzHms+5WuByXFomcVDdP9JCj15y1
 xMCkrqo2Q8SnEmbFIS+XHFchEFxpnjKfi+djyYj3ah7COeCmmXCj9PXZDxqTAfzdnQ/XaIdc3wU
 myC5pzjLTjouciWe220HuXIeTLlqrfQC3KEKwv5t8k4X1xxgB0DSV/BUzoZYL2p3jMFSeTx75C7
 jknROtztlEmqK3jGe4gc7Y9PCbwITmwwdWyOuNEMy9/CV+4P+neUTosrO+8Amm+heUjyscWNyxx
 bWRyWyz53flzHyJHIgBUkmExGWqt8AXD6SxU22Ag=
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a96acf4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=PbwEKb89bYuBhGpDIggA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-GUID: uOgwZAxme4faSMxvXlk7PLt8ZTk7gLTl

From: John Garry <john.garry@linux.dev>

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 7164bc61e65e1..68fe50f62158c 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -99,6 +99,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
 
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	ida_destroy(&scsi_mpath_head->ida);
 	mpath_head_uninit(mpath_head);
@@ -237,7 +238,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+	clone->bi_private = bio;
+
+	return clone;
+}
+
 static struct mpath_head_template smpdt = {
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
@@ -263,6 +291,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
 		goto out_uninit_head;
+	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
+			0, BIOSET_PERCPU_CACHE))
+		goto out_ida_free;
 	kref_init(&scsi_mpath_head->ref);
 
 	device_initialize(&scsi_mpath_head->dev);
@@ -282,6 +313,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 
 	return scsi_mpath_head;
 
+out_ida_free:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_uninit_head:
 	mpath_head_uninit(&scsi_mpath_head->mpath_head);
 out_free:
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d6f290b84f7f5..d2ef94ebd29af 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -26,6 +26,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct kref		ref;
 	enum mpath_iopolicy_e	iopolicy;
+	struct bio_set		bio_pool;
 	struct device		dev;
 	int			index;
 };
-- 
2.43.7

