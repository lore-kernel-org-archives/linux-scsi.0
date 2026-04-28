Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D14F401481;
	Tue, 28 Apr 2026 11:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374933; cv=fail; b=O1aeYoJp1e3EgBduWO/DvYtrLdbDmtdBiQomNWQQWwrbZmIxgDleBf7NcQpd8KtiGn75UexKyVJl69NGwFO+0pzzO2AR+8aeBBCsbb1/cc4UULM7so3gr8LVZJ0NDVDIK89AGBc5snGbitkQB7lxz4SXreJKZOKWn3era1mmteE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374933; c=relaxed/simple;
	bh=OaU0qQTJjVWkzI5Xnq25JMC3LL4ZwoH6BDLH6WaQl9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mwzsc8IwsrtT4Gpw+eH6tW9A06qQsjzmwf/FOCI0xXfSeUfwoMoc5h7vl/o/U/R8z0sfbQk7d762v7x9MKO/VaI9mk8OdcpfGfHm506wKWRHCPllGQ+stManZwpx4W8DMA93roHsGPZCtHg5yMz1llXrYjTXy2cESABv345VPrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lesJnE2N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dKWnorS6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lesJnE2N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dKWnorS6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9f6vi1905304;
	Tue, 28 Apr 2026 11:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QhcqHLLrh4BxPRYi6OQ5hvi9aBoSaqmjqqYd0+cfPCE=; b=
	lesJnE2N7qW4LFqI9yqbhZb9o0FVJ+Ci02c5NY87uDnH+5peHkxXZmG+bNa4I9ff
	NbjXSKj9Bz2ti7ljozk8ZXQHEWUXZBviBjLIkPwZN3Tv0kQC4ZtqW4NSMX4bjafs
	93jlu0wEFlBARzUP4Pv0UMLJk8FStVGgQjvh0fnTdJs/ixq3EDOE4WM6aeNT+qkJ
	3gDImFaOpuhtgn3lQGmJrIAMCsqHAbLh0ekivN0NRreKMghdoUvUCA06JYCAcJVe
	uT2gqPEbtZxtOObIYRYB4Znw/k5oBqXC0NST+iBtRk9fun3gZ61q3HWdqSfJOCfg
	bQ1upvDWbWyux/zHskSdTw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drng8fct1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCkkj030448;
	Tue, 28 Apr 2026 11:15:09 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2bvj67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gAlKiaWnrxjXUeV4gAwOeHf1tbOlubKXPR1nBxfZmqzV+rGpFkjHSnfZyz6xrS5kG5P/gbotDtFe0bvlAek149gVnFkQ0wxmrmPlaUgyIQmHv2M02bfvTZ49B7bNtMZ4Y0fWYIDtbg85GQ0F6EU29t8l2UGMPdk5jEA2y6mR1Uj1jlE7xPzJD6fjQaS6Xr1F6FxBkvP4KgYRjh9X0mx6IDS1S1vcIW3VRSgXR2MCpkC2v2p7VmmulmuFBO7HVWYLoGqITFH4cJbHc5hKCVw0dq1e2ij9YC0QfBQKc1IBxSlE/ipOAyiCD6cLd7hZOBaqfVYWZCVLgrS48WNlMG3+mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhcqHLLrh4BxPRYi6OQ5hvi9aBoSaqmjqqYd0+cfPCE=;
 b=rT+SZvUzc1uia3fpes0O/XPOfPQKK1ZCsTk2pn6JknCB833BhPEsXcG6na/LT6pHGIGS5PE5wpSH2EKPDR0fpPG1e1yOvJARsD//JctBuL1hR0+UJ3UViI060GAGOWTK57TL3PmR8kFNfgjTtQ1PgG4WQkHguvuJInd2Y4cmvAqWJCM0qZsgNGDVVnhvh2dv7WyDoejZDrZk1xIOODX8KJv2cYi+pPD6vXNXF0makcQ49x/gOCMB9FnrEa35FO6nBTMqAcXQt/hKtN36f/OKubS7Y3rD5vBEbkHb753U8QEQwnnIYKKHx5wnTjZfTFiOXDWarVA/+JLXko3YnjW4qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhcqHLLrh4BxPRYi6OQ5hvi9aBoSaqmjqqYd0+cfPCE=;
 b=dKWnorS6jAzE2KS0FSxnsA+aP2HoRvJW014jf/aXUgL47IU1pBMlErIBJheaOGEZT6JDKrCsdbUIU8xJu3JevKiMdK69X8hb3cZw2mEL1mCi75rrTg/nRjCmTILxRoG93Lfzh2ALKinE7BODLod3UX2q88FSZj5qKk5xsoEwcvI=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:05 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:05 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 02/18] scsi-multipath: introduce scsi_device head structure
Date: Tue, 28 Apr 2026 11:14:31 +0000
Message-ID: <20260428111447.1779062-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0310.namprd03.prod.outlook.com
 (2603:10b6:610:118::33) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 8686392a-42e6-4b1d-6c8d-08dea5176653
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zBdhz2SbIjpHp5SVmf6vAZnqufqloOhczedcaDqHCcGaJN9w56Hb94iqrvZw8R0vf9mr6B4EViOpPXAwV9a8PoQeOmJO79fVZnDMk2BBpbnLdr61dUL3awiSTc96z1qQXj7zemIRA2dvDJQAuI/EDixGO3XHrHN3/L/ruSudkG79SczxFAu+to9T2PWMwiq7+AF/VpKY4J248HskWC8gBj/lWRFc//t9hPq2QjXcs5bxwpTiRRrDlXDGldX+TMs5aQ9zfatFw+3NsTh3u4lmQSgjtQvpa/b8wcTFgD58whqF6Fwf6TAnRri38gm0mK11LiYGLrFdpy3d+JmELGyfJtOKO5Kr9Kn/i1hKoYnV+yChzfQmTozHlBN+IGGbjW+YCQ5tx+yAB3PCjj0OyQtoAGJWeFrllaYKigRSU063yhmfv4k95pIs+TisLoAWMZuXLpr8gxjZsjeKcFYBnz9rjHCg8LVSQB7KMjlkRMfAI9RwpcDj4+azaqftIpHGAgaBD43G+aW8hl/4Cng4JKnXv0s13J/Ul3rRmCCQChxWMs/UudrQuGhvM0s635H7yZ63JK8nd1Rpw7OoVRlXmRXalzbIdjZMMwGmx0B07kxsCyW7Qhq0Y3wGFvzO2HoB4wF5dLaBdzk/N2EH4Dag6ZRadeNekMkvGgQ00boDErNfcaxn937DZMcJg2KqnkSdfo+WnXiLQWTchnK2Ut61ym0BUInJSpPeST93ERFTsnH7y3w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M7eDSRYA2hNFsaq9rKt7xKdgyoLcUwg4WBzDzOwJClge/vNdOLRM/e/HRXOI?=
 =?us-ascii?Q?DRsYNG4+eaTT71f09bmaHTsHnIqA+fzHSyfC3vp2oAw7lufHR4lea3+xYtmb?=
 =?us-ascii?Q?KwKfdWz4nsGKgKgFjKm97EfO11wx87IdX2ATVLByhijF+nH8jjk1tJjGH8xJ?=
 =?us-ascii?Q?e9BgdGEq12ytuKiLO+i0sIx2+deEVNEqVIyiVGm8mcbT22CVFrJruXyeUz+7?=
 =?us-ascii?Q?XBR+e959dAWOCet2F28tHL1I+UDnYURbnVvxYo0qccG8wgmJqPBu9l7Lde4X?=
 =?us-ascii?Q?jzi7B8N3maP7kOW1VbRh9nkoR6sqU6/fjh5M2sImExSIpx+ZCD919uEm+wCj?=
 =?us-ascii?Q?/YDFObzOnBtXogu5/O3oIdLX5wfGxyjuaaE4wJY2v4SvXl4138hPxOQHU1IY?=
 =?us-ascii?Q?sVAhEUJMkEIbjGt21vIXm6gaGbo/in3DE6YpciI01GNw6Y7plrAiTNTp1BsT?=
 =?us-ascii?Q?paBhkfV3+LZxuRX+7Vj2EtppXasTnoSLGPyHmpS7Vqv+Hd+W7v0g91knjPSq?=
 =?us-ascii?Q?znAXVEhMPLydkGEGMIY/tEUiW/8WO8OYrfA/l2rKioyCzizN4T4aeJs/4xe9?=
 =?us-ascii?Q?zuervk7x6vsx7KxQeouykH4y5zvLEetU/pRLf8RxFr96b38l5/ZKeujNhrhi?=
 =?us-ascii?Q?Fyc4aRSA5va/tcvH3v2DVXiCbBLOBoHfPI8JWXmwD2PKcDifz9Wl1kPuUdhE?=
 =?us-ascii?Q?qjEM0PcBA6UkSLouDaSnR/j1nrEwhhLd7cl+B4M5K3NVfa7SeK38ihmK03zh?=
 =?us-ascii?Q?UGYdXPwhWZtPtql44kscWNTb9vsmeTtsRqPtP9kM+Nd694TwcmUlnIaQk4SZ?=
 =?us-ascii?Q?agNjatVptOAxKkheBX3fpunHgN/QKHtwsJeG63+mnJ7msWVvS6L4gAEojztE?=
 =?us-ascii?Q?yACmPwTZKn+VeytFHCcXUjLQiBajBeYHLx4cRFIEopaR27AWv6GHupbUOmxS?=
 =?us-ascii?Q?b0lGT4whBddqtb+rve5V/7yx7e3yPDV/2FYLHM6vwWhqzwiKfmgkjLiqTVB1?=
 =?us-ascii?Q?mQZ5VskQE4/npovBsZPiFHq1JFBorsrAJNpRutXg81LgIeaC1eQu898uKEby?=
 =?us-ascii?Q?KEfBGSbYlu+KrM+Rdcu4+PvJU2v/Gobrs+wT2Is2E5z5Mio0hZbXjLs3oGow?=
 =?us-ascii?Q?2V59YOiptZoBdbN7szCSk/cPSOWAZ6IidgZsREY/Duwz02XhxY2HuPetcB9N?=
 =?us-ascii?Q?zlLeEOllMEDgNvjsmYvuosNnVM9bydkMoICBB1XXdZXpArUlTpGOJ2lIoGtI?=
 =?us-ascii?Q?lrF4UJilwkc5SC/2cz2XTU5481ZCaWWm4ehs3qBHVMEUGNh4Pq8Apt4IWL3M?=
 =?us-ascii?Q?yLG5tGJOdzsP+ZZCqLgaES8Je4hroAedrlVVfASRoKZB6VPpDgJ6AkuGiT6f?=
 =?us-ascii?Q?+Hd5S5092pR2GdZxdpqdFLqb+8X2wlnmeZig2CrcC13+piLr8mnRmQo4O/Hr?=
 =?us-ascii?Q?DVmbpk6tppCiFK9/aylHknIwSxcCKqaiIaL25wHSFHFv8kAdiwIB3IAyFtAm?=
 =?us-ascii?Q?Q2tWAFN6GPoDyAmDafZXXWLw/wEGPP1zhmyh9awabIo/CzbcXh9GwQqHjwkt?=
 =?us-ascii?Q?ZPgEoG7AUEFCzZGd7eqp5s5jGwB79sdnBbVTdFxVUHWSoM16N9Hs6Uxl4woc?=
 =?us-ascii?Q?nsPqQm0xR+FfBJpFPUcTVJuQkqgjGDiaMGrBR+l10l8In/mCpLwkd4uXjQ5i?=
 =?us-ascii?Q?2ktvju5DwJC0gQ3wBMXL2vQFmmQMWU/YlSqn9eTDDITbaFK0uYEFrQDAluJb?=
 =?us-ascii?Q?iXbiLaIGDdBfobLX6wYEQn14V5On+vg=3D?=
X-Exchange-RoutingPolicyChecked:
	IwsvPd3CApjNSPk8vJ3FMZ+YGsVlswBN8ZLMWnObcxQf0XS7ELbn63jrsEwwRJ7HrmOYdKCdL6X+Xes+IYqi2sCbTBiKws4o4JbZXN9zRFOuUfLb14qwNaz7Ix6iqoN533nqQycbxweDGX4oWbOvZ2GJbNGQVCEBH1xKx7tGQIwry7jyy/RppU+kjKQMcE+qX62YqPHWdgAnHErU8WtIhYMQ817gL81SX0hqMxDx5fVVObmg+E28zBubcKYNgJn4EDcWcJGsgr6G6xOAnwy6H8nUirE9qCehjKjYZjEqwSeKs/0JUJq0WaReql/dKVYe7w2958GwkZ/TXffEkbEFvA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P9Gewzy12gSscfZSV+9lTer06Ms4ONRGFrAlsFRQ3OHf06ykSlUyYDAj30RQ/3WTL8D3z/GrQJWeO5JJjHa8iKft90hHUJbJmTZc/n6T7MauZBENgGo/ni5OXeHeGh/03g8d47OSrJW7vT7UIytGk00vh7KvAV6cTiB976s8p0aLC9Hf4XzGdvRD/iLPijrBOs2IHD5t96di+zXm0bi6ILDZfMk45XrrHv+f/CEXhOBcol1MxHFP6fjout5oW0p5ozBGfdWt0YUL+HkpTZAGZHy1NNu65so5EdcXeny9usdVaRo6wL7ho04j6Ddmyh5NiSElvE/N4NnC35MjdVjHxwFS7t2K/F9rt+r8bLH5yb1Gze/stHKy6zD2CG/xj3B60/vR9Oz/by971fagJDTmp+ZwGUAALggSCnsvs5ChVvgg0fKm+n5X9e71F4OF3iqst1uThEmETp+t2ULmmaNqUdE2fyz+lAcVqMlBbUMEmhLGOdnPh/UppdiapVnbmqURP2eOXXxnw4jodI6d6xZFiJE4gmhvF2yZhc5wBBmLT4gII9tCYLS4PSaGs7X2s+6LjQwiWn8SHiE7VxJD8Namrw7tNdQKr7klkE5zvUSjCks=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8686392a-42e6-4b1d-6c8d-08dea5176653
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:05.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fV8G3hV0YuAAKAGhR7QCrnQh7OVmSJyj3B+DA4fZ5uqUmgsZymrvRCUhfKS3hbFH9MtF2Jz2+iWU+5Mte3e2fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Authority-Analysis: v=2.4 cv=U7uiy+ru c=1 sm=1 tr=0 ts=69f096be b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=rslDvqJ3sq2LG7fXSO4A:9 cc=ntf
 awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXx4Jdn03i6RxX
 gK7SyamRvuPsWpmViKGRJw8tmJ/sryX5Ekllent1iuXOu12IBSZ1DvYBJQn52iXWKeDUpIFoFA+
 lARCeCMBFH9LpzdOtjN0eJBcU4qPd2nBD5kqYnsX7PNF/clBPjRWAqHa0LON4GAwPV09fSlQRDc
 tCe+MDPFQrwy1+1slZB6p6yuJbzkNz9vq7zEkazH37s4j4Tkp8mpUVgdmM4TjKQX6Ryxnq+M83F
 ioli9b92N5PF/RZ5I1MoHj10GnKUo8lsTwX0eAIV7Mt3gTzeHXOTsJAba6yRdg6hYyCLlh0MDG/
 k2uvJ6ZcP1Gt9j7oDb2uhgt+xEaKu0bQTSAzkxBBEBPMt9AhSQNxG2Y0srMs89oEQdeLdpgnONj
 Pa6yYQ/To5maIN06XytI97IPi+/tRGr8AiMQckpmapE61wQLNFAuR9S7I2TiRTbbCjcl1RW35cc
 AJxK9cg11eNWz5CQk7UGdEy0HH2X/uvHhlcvmROU=
X-Proofpoint-GUID: 2c2JlFIk0GOflr_t5v7VfPINkPewd6hz
X-Proofpoint-ORIG-GUID: 2c2JlFIk0GOflr_t5v7VfPINkPewd6hz

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's. Matching is done through the scsi_device
unique id.

A new class for multipathed devices is added, scsi_mpath_device_class.

The purpose of this class is for managing the scsi_mpath_head.dev member.

The naming for the scsi_device structure is in form H:C:I:L,
where H is host, C is channel, I is ID, and L is lun.

However, for a multipathed scsi_device, all the naming members may be
different between member scsi_device's. As such, just use a simple
single-number naming index for each scsi_mpath_head.

The sysfs device folder will have links to the scsi_device's so, it will
be possible to lookup the member scsi_device's.

An example sysfs entry is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
drwxr-xr-x    2 root     root             0 Apr 13 15:48 power
lrwxrwxrwx    1 root     root             0 Apr 13 15:48 subsystem -> ../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Apr 13 15:48 uevent
-r--r--r--    1 root     root          4096 Apr 13 15:48 vpd_id

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 209 +++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  29 +++++
 3 files changed, 239 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index ff37cfdf2f9d1..18d50d051b3ba 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -27,6 +27,10 @@ static const char *scsi_multipath_modes[] = {
 
 static int scsi_multipath = SCSI_MULTIPATH_OFF;
 
+static LIST_HEAD(scsi_mpath_heads_list);
+static DEFINE_MUTEX(scsi_mpath_heads_lock);
+static DEFINE_IDA(scsi_multipath_dev_ida);
+
 static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	if (!val)
@@ -69,6 +73,60 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+	mpath_put_head(mpath_head);
+	kfree(scsi_mpath_head);
+}
+
+static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return sysfs_emit(buf, "%s\n", scsi_mpath_head->vpd_id);
+}
+static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
+
+static struct attribute *scsi_mpath_device_attrs[] = {
+	&dev_attr_vpd_id.attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_device_attrs_group = {
+	.attrs = scsi_mpath_device_attrs,
+};
+
+static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	return true;
+}
+
+static bool scsi_multipath_sysfs_attr_visible(struct kobject *kobj,
+		struct attribute *attr, int n)
+{
+	return false;
+}
+DEFINE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+
+const struct attribute_group *scsi_mpath_device_groups[] = {
+	&scsi_mpath_device_attrs_group,
+	NULL
+};
+
+static const struct class scsi_mpath_device_class = {
+	.name = "scsi_mpath_device",
+	.dev_groups = scsi_mpath_device_groups,
+	.dev_release = scsi_mpath_head_release,
+};
+
 static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -88,6 +146,73 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+struct mpath_head_template smpdt = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
+	if (!scsi_mpath_head)
+		return NULL;
+
+	ida_init(&scsi_mpath_head->ida);
+
+	scsi_mpath_head->mpath_head = mpath_alloc_head();
+	if (IS_ERR(scsi_mpath_head->mpath_head))
+		goto out_free;
+	scsi_mpath_head->mpath_head->mpdt = &smpdt;
+	scsi_mpath_head->mpath_head->drvdata = scsi_mpath_head;
+
+	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
+	if (scsi_mpath_head->index < 0)
+		goto out_put_head;
+	kref_init(&scsi_mpath_head->ref);
+
+	device_initialize(&scsi_mpath_head->dev);
+	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
+	ret = dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
+				scsi_mpath_head->index);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		goto out_free_ida;
+	}
+
+	return scsi_mpath_head;
+
+out_free_ida:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+out_put_head:
+	mpath_put_head(scsi_mpath_head->mpath_head);
+out_free:
+	kfree(scsi_mpath_head);
+	return NULL;
+}
+
+static struct scsi_mpath_head *scsi_mpath_find_head(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
+		ret = scsi_mpath_get_head(scsi_mpath_head);
+		if (ret)
+			continue;
+		if (strncmp(scsi_mpath_head->vpd_id,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+
+			return scsi_mpath_head;
+		}
+		scsi_mpath_put_head(scsi_mpath_head);
+	}
+
+	return NULL;
+}
+
 static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 {
 	kfree(sdev->scsi_mpath_dev);
@@ -96,6 +221,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (scsi_multipath == SCSI_MULTIPATH_OFF)
@@ -116,13 +242,58 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 		goto out_uninit;
 	}
 
-	return 0;
+	mutex_lock(&scsi_mpath_heads_lock);
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	scsi_mpath_head = scsi_mpath_alloc_head();
+	if (!scsi_mpath_head) {
+		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_uninit;
+	}
 
+	strscpy(scsi_mpath_head->vpd_id, sdev->scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN);
+
+	ret = device_add(&scsi_mpath_head->dev);
+	if (ret) {
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_put_head;
+	}
+
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+found:
+	mutex_unlock(&scsi_mpath_heads_lock);
+	ret = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (ret < 0)
+		goto out_put_head;
+	sdev->scsi_mpath_dev->index = ret;
+
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
+	return 0;
+out_put_head:
+	scsi_mpath_put_head(scsi_mpath_head);
 out_uninit:
 	scsi_multipath_sdev_uninit(sdev);
 	return ret;
 }
 
+static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	scsi_mpath_put_head(scsi_mpath_dev->scsi_mpath_head);
+	scsi_mpath_dev->scsi_mpath_head = NULL;
+}
+
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+
+	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
+
+	scsi_mpath_remove_head(scsi_mpath_dev);
+}
+
 void scsi_mpath_dev_release(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -133,13 +304,47 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 	scsi_multipath_sdev_uninit(sdev);
 }
 
-int __init scsi_multipath_init(void)
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
+	if (!kref_get_unless_zero(&scsi_mpath_head->ref))
+		return -ENXIO;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
+
+static void scsi_mpath_free_head(struct kref *ref)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(ref, struct scsi_mpath_head, ref);
+
+	/*
+	 * If we race with scsi_mpath_find_head(), then that function may
+	 * find this scsi_mpath_head in the heads list; however we would fail
+	 * to take a reference to this scsi_mpath_head and continue the search.
+	 * As such, it is safe to call device_unregister (and free
+	 * scsi_mpath_head) after we delete this head from the list.
+	 */
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_del_init(&scsi_mpath_head->entry);
+	mutex_unlock(&scsi_mpath_heads_lock);
+
+	device_unregister(&scsi_mpath_head->dev);
+}
+
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	kref_put(&scsi_mpath_head->ref, scsi_mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
+
+int __init scsi_multipath_init(void)
+{
+	return class_register(&scsi_mpath_device_class);
+}
 
 void __exit scsi_multipath_exit(void)
 {
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 47534d9f2cf9b..043fd2d9cc417 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1485,6 +1485,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	} else
 		put_device(&sdev->sdev_dev);
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
 	 * scsi_run_queue() invocations have finished before tearing down the
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d3d410dafd17a..b3e0b98f39c56 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -19,12 +19,25 @@
 #ifdef CONFIG_SCSI_MULTIPATH
 #define SCSI_MPATH_DEVICE_ID_LEN 256
 
+struct scsi_mpath_head {
+	char			vpd_id[SCSI_MPATH_DEVICE_ID_LEN];
+	struct list_head	entry;
+	struct ida		ida;
+	struct kref		ref;
+	struct mpath_head	*mpath_head;
+	struct device		dev;
+	int			index;
+};
+
 struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
+	int			index;
+	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
+
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
@@ -32,8 +45,13 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+int scsi_mpath_get_head(struct scsi_mpath_head *);
+void scsi_mpath_put_head(struct scsi_mpath_head *);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +69,16 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline void scsi_mpath_remove_device(struct scsi_mpath_device
+					*scsi_mpath_dev)
+{
+}
+static inline int scsi_mpath_get_head(struct scsi_mpath_head *)
+{
+	return 0;
+}
+static inline void scsi_mpath_put_head(struct scsi_mpath_head *)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.5

