Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237ED3FE350;
	Tue, 28 Apr 2026 11:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374817; cv=fail; b=t3S0/hVx0iXdsEIl1/wc3mQJuG31veoUSXyGJc21c/h0V/dgnEsVRqVX/09ydnum9bxD3JilSgBK/dJMtreiCjWDUsYxagRDyzQrinz3zECG8PQhQff1EZIYwfU4yE3syKSZa0DzY2GTTvCEHM9jlnBXROm9ln2K2UzEtYluZvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374817; c=relaxed/simple;
	bh=xO2vFIiSTJ1GEdtw4DFD3yJg+4K9w7Y9dQ/HZVIkj70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cIsOl5huZCbl/qVOUIkRAShkwVJ3otEtJcW65JCmIMJaoFqz+yDkLp9r+91KRwUs4G36yxxt1RYMmLz8wwax+K35ENyWW9Y7ftj95Px58g+6T13XRwYHawpiJ9IH7cxXoh1gYIr5EeG37XcW9KuXYAxcmIj9w7y1BhAauDkIJDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ieqxfm1Y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LQv3HVal; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ieqxfm1Y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LQv3HVal"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S90Q5n2603467;
	Tue, 28 Apr 2026 11:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ekbzpYfL/aT4xGzh5rJF5P8IKhqhx0GynjjYt+eaWbs=; b=
	ieqxfm1YRzudSOggWuS9H/y6joYjKSCuK8ga3shphuA0gi+ou/9Yga7ppOtFUp/S
	D+ghx6md1nMkQlHFzHnZ6r/OMCGXsHw1w0mO9GSLClsY1yk40zGH3TbLmguFcatw
	0fSqOCxfVRPGnb9AY3/AJct462bx4dOU8v6i8LU+QPXHBQcD1IMMUlZbdIScH3CP
	4Vodrilpa3q1A+H76llxe68A4KZZSvbk/nphTe6ngIrChp/CpJtY/86djuLcdQAL
	Umo/OXnfQa6vyTTCtAXFu/nPWzhpyqnCRNLkeniPrkbQIpf7DtU+2Am6locaXKVc
	TsDjPHf4sxbgW4iNRybPLQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm1cy8vy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCjEX004724;
	Tue, 28 Apr 2026 11:13:19 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010028.outbound.protection.outlook.com [52.101.46.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2jm3da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p3mf538N5yoNt1oYQvYnh7b30iOlT+A3m6NsLGZGzwXkmHR3wpnoMTXe/JYxM3hec2zYUQiBgk9aeNxlQAQMbMIysJrmqmU1l1BjsJVcG1f9mPagjp61dEtwBrxAm5ZxPaboD1+J3ijyVlFiZfO3V9r+jRL4EySq3XlllIcJ5mvdOMqc4lE+xPAvNSZjADP3rN2VBmmBI/7TP+WBeQAyVDw1COKUCsER6EixPI6t08x+V8bG+ka99dYt081C7b2dZJaf0gxwcZibYCUDcCMksJtgnyjELbBMj4ICknzgSWbsEVX+YLR6JaQmO3WtVCnD50djN1h0Nyvb+d1Ck4EPZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekbzpYfL/aT4xGzh5rJF5P8IKhqhx0GynjjYt+eaWbs=;
 b=k+m1aC8Y0TnpPrFWXlsIY0rozyrW5m9WYTk1twU0OyiZ2thjcGJG0tnkwy627qv4lTSOpRqsX+QHDkC/Om1z/c5BQeO93uLAHltifm+Q9toHsZyEp+iL2vxr7M2WyPOa6UPitg9CHtibY1MphxSJGxIVNhbNz9evXF8pvVV7NLTNib5UbOpyIe0JoUbsVGLTlrmDgR9C+QyUOtpbCVkzPsC+ipyM5pS/hf0vl/BjSymctrEd0x7nG4HBHbE2wMufRsXhLIcxiI50k14OlWVN4m2FZND7X2FqaNFUoa8a5heX718YDBs07HaGIiDJSFEiOKUpuB97usSzT44gNFpNpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekbzpYfL/aT4xGzh5rJF5P8IKhqhx0GynjjYt+eaWbs=;
 b=LQv3HValLyFvZwakhGn1zLne4XgDyxD/D846AEMdM0AN8jhVowIzRKhyialeBupAYT43Ha/0OKcAdQF/fr8kLtO52iGQq/Uzf9p0m9FjV/2HBmjVrDsbwbYJa+FLsyqvJ3EG34dlORmLqgea2DFzjgKjaLu6YAqptbQY8qFysL4=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:15 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 06/13] nvme-multipath: add nvme_mpath_cdev_ioctl()
Date: Tue, 28 Apr 2026 11:12:49 +0000
Message-ID: <20260428111256.1778475-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::27) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 999e3b99-6934-4f94-258c-08dea51723f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	B77C/DjuX/3f8dNvrrBho0qZbImwaBsH3Fn9aX35NQx+dH56sU5iGT1JM6PDUPMrYCJuYdnFp7CXV+PfFeoFK9ebGjyKDhKzLm/ERYLko6GZJxWqLkDU3aPnMI2gILNz5GS0o/EOXD2KoX5kKQUvIBEwRWLX/s/Jup+sBU49ETOPa6q4lF5kLO9tIPj9CWP7Y+o3Z7jKwzT6rpKVgGZtccbWeQB6H5Eviaz8kWfPThe0r49ITl5Mb9yR0I1WTz5PQjVRB2EBs1x3fCbpDfjUNX20SFpQSAv7LFYyeIlnAhpM+dUPxhLjg+pSujtIp0D+rooefuDmNqSNqoxXs6szbNLjKzQprAIGZrAJ1tevQv6FxWs1g0mabtDxxBXmB5O1McxkWpB3VWrjfeGB16DtQbhcADuIY47CpaKdqPhii/ag2i72IqDJaLCK0DiIXlC/pGsY4utGE8JtSyopArLd8rJwjerAfcjPm+kxSNfELEjxwe9dMXYXCxhyRdZlDlTwmWWSpl7tTa7ky5gCZpk3KlZLDWC4t248gVRnpSoGLKyZCyR+1nEeLEBM+Am2nx001C3gI3NAjQXRHTOiKmLk1j130JU750gIqzIf/bWVAdLr54w/OCL/cvE1r9VZtGZloU17Gf0aJOaST1Zd7BwtkW87QeES8MWheGb5w/N+83o3tHr5lvdpRBNoIYt58Gcg9M/BXu64x4SPf0M93lyYB+KKopk2GrjEM0hm060JTkI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K3AfqgueA81zLnn6oXoiTuwPhZs9D7L5vOE0ZC/9QJ5R+v6P6B/34+giOh+J?=
 =?us-ascii?Q?J0rTCUh3Rf7MO3Un+cV8S8nCOmhmYfxMgNRflpNrBBfyL84AJYgl+rbCqGfg?=
 =?us-ascii?Q?hWxLQfFiGaGtMZRsOJ5SUuaEDIOeFELAeojZp7xbzZ4hXJvLyc2F9FCWQM2A?=
 =?us-ascii?Q?uvN3RSvV6M86HqBCi9lJmtFIrEy9w/qMDNOVtNgt3heZHy8+H+sSf+GNPR/2?=
 =?us-ascii?Q?ib586oLhHY3d3DSpu0N9HuDFO4WbvUtGcJnPNqVRjzQJBHK+5xuEjHsZqqvC?=
 =?us-ascii?Q?iwECeDOu9eTVrQUlG6NoRYm3uT81gl6tVeN7KVUTENhlj1geaMJbUtzTZbd4?=
 =?us-ascii?Q?FTQLPBn7r4J+2+XCXiuR0BLyCj8WOR5wYKCmtiWZjvpvHQBHAia9M42zoGQf?=
 =?us-ascii?Q?y7gVOvQMeff0j7h0SXt4Bd5dZTRuRs9H6bvTjl2L2pW3c3bNGCwI/04KpT1D?=
 =?us-ascii?Q?CyL4sA6kXSVySYyYEivXJH1cLHPo5YS8A/KY3ML3nvYJR+qHTgDExyfO21cK?=
 =?us-ascii?Q?5E5BGhl3prK4kiR1UUdiZOsg73VraGUdLGk8G9e3cGWfcIDH15EOI8d4v4Fi?=
 =?us-ascii?Q?iuSo1kTC6bWp13trQcjWGgz/NAn0jklNp0SP+E5nLpJaZa6ReScfgOcS/cDR?=
 =?us-ascii?Q?HqDGGBi4xoMve6OWG/vhC7jphdfwUpFWS0+S0AfGPLi5ugASyqfsfGskzPxs?=
 =?us-ascii?Q?L9eLJuGLB9RNcVxTjAAcQmUU0wcUZt2BnNuytL306jPs4VSYhlNL5WSloyPt?=
 =?us-ascii?Q?yJuB3P/zbZuN1ZblgEtT42iw8L2dJ/3PO8ljFpv6UBTCxyFjNVWSzFyeDihi?=
 =?us-ascii?Q?ZmdUpbWVoY16ryUVRdK8r6h46Sg8jWi67O9p9W9QowF47YZ4faAXk9Gmh8es?=
 =?us-ascii?Q?j0LyGJ4cuUonnyjqk6Z56odRadGht1ttPzO/2WeL6dztCI2+0/s35WoGxD4I?=
 =?us-ascii?Q?AQxnjWvkSZoV2fKnXaZ5TYYUGET5fxsbJUdxn2sKJTMyglKj25zmZSsCvSyE?=
 =?us-ascii?Q?Crty5a7sUEnd6DZT+5eKji2xAJ9iNrNN+N+tiQhu4d98f1six4EZpGtq1tsP?=
 =?us-ascii?Q?C47Od22RcE4iqAsU42sNZhwHRiNLsjw2eB0jfpMQ4a5DfZvp0sIVyLyQGd5A?=
 =?us-ascii?Q?KJYfbdtDpJYjR1Uu/LYve1yNGw1Jy4u63713+2p8GMYhdmL5TLMFyu2i2TB+?=
 =?us-ascii?Q?RpNsJYHXB5WJlRIDTKU94eBeeg/zVObg1JZRw8yTkYASkmv6cOggiqQKihIJ?=
 =?us-ascii?Q?hoRFxSm3UDyjAyVZ0NANA9xhfCbOky8gP2n77pPcl4ijXr+HVZLpdW3Ar+U8?=
 =?us-ascii?Q?yYSLLKabL1YxSq4CiuU900t3AVVDQgw1xsyN61RDXBqQ+LOu6X+UCXo66sbB?=
 =?us-ascii?Q?b9ddHU3/TDPtGkhBUMduCJ2REPozDIs8DT3nYnmwJ2R6rcohwJA/qupWYMnG?=
 =?us-ascii?Q?zYp3whII5lfpq1OZmF8Ky7eqfAczctamNUZBNaa+ilszc0jPwxjCZO0+cD1T?=
 =?us-ascii?Q?+N10pnoELk+rw04ve5qcz+E9/zToHDqlyS9GMS6oZur7ELagHZAjTR2YAF1Y?=
 =?us-ascii?Q?jSkiwvvGX+UHJq8dAqWpB1Q2I0LVMDDdjqjhYDYiQnp+pL6Jc2vF+eKw2KZc?=
 =?us-ascii?Q?wo6Suhr3QIVhoCMFKJzoCpjXK9P1jPfw3CmwREmhU0UNA8JzF1pS2yCFnJ7D?=
 =?us-ascii?Q?XmrnOCOyKyBouGsviXoZxnR/myDyynHnx9QdJzuBOWviG3LAJ3QPm24PgWQG?=
 =?us-ascii?Q?dPs4gV5fxCYIm4P6/4NIHbqbBUfk4nI=3D?=
X-Exchange-RoutingPolicyChecked:
	gFIsA3NXSG3gwqdbQqiLx/tQDduTEqX43+y1wj/0fqI2jBGSAoTLt9Zc4D4K2uNMnn6Pv4xCuiDxYQIOvHtzkNJXWWwO5J36B3+yGcFxe4Y4/C2EShtqF+lKCzLx8GpZxJIXmCTMCNZSu6qlOx5WpQF1y3dvzREZNi99UkbAD2v/9zkojVCaHhVxHPmW2rACOc46sO0FnrBY82iffcENcnSaU1Lr0YWIKfFDGMnEE09PNcUPS88ZRnOjeJVrwe/a0Cz3485Fzb2ciDD/1wzQQAsx0w9DO8BVP9cwwvsAJ+MsVrrzfW0NWpr6CH9uXXjE+iMWtcbZ5NfG0VLaMjzpoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vQwGKOcvEMuDxHj5Noh0tGYjvD21QCs9Iz/XGQgSJbtakYroO+G7V7xlN+6MRoyvxuKQd6wj3NUQgiQd99yZ4DkUViTEJmvDaEeWVl1GizFfAQVvxjEqmCyp8uAWfXv28IB7lbpCTFh6fgijhjkRolGswrMDRZhkH1O9cddnBGwNobw/O6CJLuyU/LfjE87XEWsNQtFYr0A/axgKrImq9vMUWKKAFAIkUYGM0YlEMcNz0BF3CAqkv1UW4+iu2a4u6sOYvDiscONJ3/oIZFIQRN1Z5yJbjzdSGXsmYJRmykkUZWn566DQhOoaAOmdDAvSmnpCZ/RPXPpDuTKkGLpVe8ymC+hjQ+LJIA1yhacv4xUewFQz2FC+8xsFR5s0A0FzRYfLkpy2U4TmkAYeSWedVi7KIjeCe2y4t2vI6FUr5ebCL29VvdW65IYV+aLe9sCU5zogRDcMvHo6eWjE/OuGUbRCJcXFLI0ybRLDkLFmI9USEyFWXCGScBq/g7faVsQCvB05xaR1ErkyRDqa7vtKuFvLiIoRf0tf7kSRFzKiZTI7Udwjzqw4VR66c1f1ruzIxcrpGBM0ziUm9FLYkSdantJ5Li1iOK93sN6xICmWgOY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999e3b99-6934-4f94-258c-08dea51723f0
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:14.2538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17eZArNLIeJZp4iXCEd0vMscRqbFyOy7PVAiheHXswFgVwQrUuyzwG6qw2EAI7dt4R4QNsAcpz0t+AVag/4t3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: mMRSdKEEDs7gj1jiwqMY0YWtnHXScRfb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX+r7z0QzC87yR
 mrtR3qXs7chdArcbs4aLpd+k0GIkAOdm+L6E1JMPqeR8ZJOdkDF3AFMyozOkO8gQp0V4vPTFZ6g
 hHN9S6rCY//diPQm0tCpnGAODzFzQCZFJhlLzhktCCJkfQglnxC97V8d6OM2o/oBVVSmYqmLS/2
 F56UYB02bKL0+bwIdV1LHJ42aIZunnMVFO8OD0639UeczX87neiYRA4SDD6DhiNkCw8EuNSmVif
 EkeiNfVrA30Z55es8I0wjlKjR9U48tkyYaSW6EwdynsvBUICFhhSR5SDHc6hkD/5JkJrSdNMWZO
 n1ixIt0jSRWqKJVRG3CGne04mtDSyHAHdoQVTEIaNBo2Pylbvw4Eip4/4lMeRqNlyzQUdHC0klN
 /uqvVDFGh97jy937zPkoMA8fTWwthx6oVQcewuJpxVS7MnlEMEBYggkNzRpOu6dBhaPWK9JMJjx
 RrZvq3Y8MAAKU/1Emf/ynRaIJVh/G1yWcS5miYgA=
X-Authority-Analysis: v=2.4 cv=I89Vgtgg c=1 sm=1 tr=0 ts=69f0964f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=7UCe6NBafOtkRfyzdoIA:9 cc=ntf
 awl=host:12309
X-Proofpoint-ORIG-GUID: mMRSdKEEDs7gj1jiwqMY0YWtnHXScRfb

Add nvme_mpath_cdev_ioctl(), which does the same as
nvme_ns_head_chr_ioctl()

Also add nvme_mpath_ioctl_begin() and nvme_mpath_ioctl_finish() - they are
special handling for how the SRCU read lock needs to be dropped for the
controller command IOCTL handling. In this, nvme_mpath_ioctl_begin() takes
a reference to the controller, and then mpath_chr_ioctl() will drop the
SRCU read lock before calling nvme_mpath_cdev_ioctl() and finally the
controller reference is dropped in nvme_mpath_ioctl_finish().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/ioctl.c     | 37 +++++++++++++++++++++++++++++++----
 drivers/nvme/host/multipath.c |  3 +++
 drivers/nvme/host/nvme.h      |  6 ++++++
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 8844bbd395159..ee99b8dbcdfff 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -624,11 +624,9 @@ int nvme_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return nvme_ns_ioctl(ns, cmd, argp, flags, open_for_write);
 }
 
-long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long _nvme_ns_chr_ioctl(struct nvme_ns *ns, unsigned int cmd,
+				unsigned long arg, bool open_for_write)
 {
-	struct nvme_ns *ns =
-		container_of(file_inode(file)->i_cdev, struct nvme_ns, cdev);
-	bool open_for_write = file->f_mode & FMODE_WRITE;
 	void __user *argp = (void __user *)arg;
 
 	if (is_ctrl_ioctl(cmd))
@@ -636,6 +634,14 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return nvme_ns_ioctl(ns, cmd, argp, 0, open_for_write);
 }
 
+long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct nvme_ns *ns =
+		container_of(file_inode(file)->i_cdev, struct nvme_ns, cdev);
+
+	return _nvme_ns_chr_ioctl(ns, cmd, arg, file->f_mode & FMODE_WRITE);
+}
+
 static int nvme_uring_cmd_checks(unsigned int issue_flags)
 {
 
@@ -690,6 +696,29 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
 	return 0;
 }
 #ifdef CONFIG_NVME_MULTIPATH
+long nvme_mpath_cdev_ioctl(struct mpath_device *mpath_device, unsigned int cmd,
+					unsigned long arg, bool open_for_write)
+{
+	return _nvme_ns_chr_ioctl(nvme_mpath_to_ns(mpath_device), cmd,
+			arg, open_for_write);
+}
+
+void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
+		unsigned int cmd, void **data)
+{
+	struct nvme_ctrl *ctrl = nvme_mpath_to_ns(mpath_device)->ctrl;
+
+	if (is_ctrl_ioctl(cmd)) {
+		nvme_get_ctrl(ctrl);
+		*data = ctrl;
+	}
+}
+
+void nvme_mpath_ioctl_finish(void *opaque)
+{
+	nvme_put_ctrl(opaque);
+}
+
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx,
 		bool open_for_write)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d9ab52a29ea8b..5e49cd716f859 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1445,4 +1445,7 @@ static const struct mpath_head_template mpdt = {
 	.del_cdev = nvme_mpath_del_cdev,
 	.is_disabled = nvme_mpath_is_disabled,
 	.is_optimized = nvme_mpath_is_optimized,
+	.cdev_ioctl = nvme_mpath_cdev_ioctl,
+	.ioctl_begin = nvme_mpath_ioctl_begin,
+	.ioctl_finish = nvme_mpath_ioctl_finish,
 };
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index f3026da0f39d9..1ec45cce05c9c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1053,6 +1053,12 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
 void nvme_mpath_end_request(struct request *rq);
 
+long nvme_mpath_cdev_ioctl(struct mpath_device *mpath_device, unsigned int cmd,
+			unsigned long arg, bool open_for_write);
+void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
+			unsigned int cmd, void **opaque);
+void nvme_mpath_ioctl_finish(void *opaque);
+
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
-- 
2.43.5

