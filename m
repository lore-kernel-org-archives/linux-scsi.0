Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E433B9DA1;
	Fri,  3 Jul 2026 10:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074670; cv=fail; b=Gbc+HaAHJK/X3e6q98iFgCcVnPaWmx9+l/tZvaQGNJPOoxNob8PnFVh1UltO0a3NOvfhfStq8bjBCADNZREv+BbP82jLOl013lwRUyHRt4OJugfEJbJQlCzMRexRLwo2KRSgjHBNTHDC7zTPqlYJ2/20pRageD3k8IrhetaNHAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074670; c=relaxed/simple;
	bh=DGE7oaXERMPqacCmh5wCUd4Uu9+FuZvKz8U8oUtWouc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NU3SHA/xCaMx85+nPWZzE30pLLUkUf6fsdh2V+6G6aI0f22V40pjFQVC1cwiLdnW25DOkYQT30DXT7GpEe5+Bs8Gx4mSVHMA0fFL8cgySQcIqeYe+5yaEexh6htr3vyD6SCMQXWEovZbeAf05+pFc4E7dZT27kUAXWrWTaSra0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q6SoTdcK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=On7UvQKE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q6SoTdcK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="On7UvQKE"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tqOo3063215;
	Fri, 3 Jul 2026 10:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lL1YHqPe3k5vS+MLCajgnLb9hmnR/luz1UWOCPgnoHE=; b=
	q6SoTdcKp3GFcDJbh5uCthlyz9viyC1M6Ag9sK8OFdxXJFpdpX8DgxhzlH9sHiJf
	Q6zA8sGvyU3GsNVlns2rOdJ9nqgbt/tRY3LksTwgunVDN4mi3qk8M4asGoYZy8c2
	uQNhsFdpczYj7cqWvzLs13eFIZgPTNVoJd3BQVmSNoqQbmnkXQdneTCCNVHh9ZtG
	BzkCAbjgBG1qUgcshW900diCq2GW+wD/XQ6puC2eTiDjgErHlt7TMTUIPBStFzUE
	OxtnBf+33imrcTkaLXznNp1g/mmb8ZS3gM1WWrcqmRaR+xzIyjIZQXOiyVNkuubg
	8Kc+WJJ9DwFjjrUjskFaPA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n1adu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS6X8013032;
	Fri, 3 Jul 2026 10:30:50 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012004.outbound.protection.outlook.com [40.93.195.4])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvq9w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoH8TzJOH8KLJORaAUEmNE8GrstJ5R9gBP1odjZurKZu2Hck33TWzVvUyt6zoZ/TCRFl8vzO9rIODJEGFsZS/OMnAVhMY0IhxSyKpzudovolJOpAXL1QcsDlzwGruvhIrSHzJU8WDpuYT6AJtqYoG4QbZUqax7LRtoMf1WcuKJQZqHvibet1/fUbKECML6MyBlCpyKumI7jc33C3b2Mk6JBXddyuPfUNvYALmJjuytPsF6GWIvcNbRVg4GH5y7QUS1tQcQ9f4m4DO/RWs6HqCY9RS2VJS9LlDpqwGOZzOYdfcqn6ad6qWKkui4QPSx1vPtVsTmEqWn9Lhwr0SpwnMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lL1YHqPe3k5vS+MLCajgnLb9hmnR/luz1UWOCPgnoHE=;
 b=c3RM+X0g7QqY+i79FXXHx8bW7dZi7RDhtxzx2022YVmUJCrtX88PVNVvX1yoPGILv4GmtZZHQoq1Bq5kQV7ZqcB0PayFY+eem0dUteN7um9IevQz3pdMW3l46qKwbjnw/ckWdzryl0pO4FrvXJKu8Z0R7dYFU0u+NsQwOluVta/Fk66ToKypu9jEVgfw3u6EsuSyP7uHNSnNwyRGs4sk0yODpu6Pit605CF/MaR8/XQ3lMguI3shwaL8LGI0P2NzsCrcnXhKZpIn5u/sRd3laDAkByK6l+Stxt4WhoF6aAz5cruXpxJrgD/JZsYbPKyvl0EJLFceoVzEwga+JmGA/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL1YHqPe3k5vS+MLCajgnLb9hmnR/luz1UWOCPgnoHE=;
 b=On7UvQKET9FviCV6E+W7QhTt2MGVoyoW1G5/kIIiEOuKAbij7sCIbifsWaFmB6CVy2uT3oBlPvf0YVO55st7GVeUTkoa1rbWxVVoLLRq+C+QcutNw05v9e2s+ImBphffs+EbwtqMleGfPQ9SSm6xtkZWiuGtom6uR298Cju51qA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:30:47 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 02/13] libmultipath: Add basic gendisk support
Date: Fri,  3 Jul 2026 10:29:07 +0000
Message-ID: <20260703102918.3723667-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:510:23d::25) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: d7e90745-777c-4b52-fc3e-08ded8ee2462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	KRg4rMuTAVcpZZHHYRXykrRvpRlmuBBbyiJu+7f509cG50DLq7ulr4wG2/gGCCM1OLbYb3CCEURUgktBL4JVVCyv9zPpqKT//xh0HRFsdpwIq3eRmasNOYE4kopzsBQFNi6DQ9GEi6mYxqtWDWLE0CR4hfTSSdXbvuWXvEX25SjfN8EY6f0lBDH4jJMDLzApVC8PXItGeTrVg+gBkGFki2lFBcwuIv4MG3s+KNWqoZnsan8808IQYPNqJSb+LBfSZZ2hRA8/zIsZqVBsncOSEjga05SmCj41g3iUtoxplHVtKom9wqkT2GqYeH9JhDrwTdoIN4yuEIwL+xnGaQD6pRFtktz0qoCzmaiWhN8lPH2i8SeIrqkBcYeRLO7eMmDG7sVXLObPBPOZQo2pZSN+rhUK5IsfVRzRVcxgSlOpP/z1zD//bQ5Wj4B4Qv5IZgdVfKV4e69aOkjudCabmO+QswSV4tP7SrIm2MQzYo/bbjuvjI99LNlwxuzvbYTxmlC4JuyhQE9KYfJpyMm9QqyjLnYkI9XiMCf8biPAKO+/g9ZIJ7VELf8JDqXWr2RkN8ez1iy/LUT6ff3G0XcoykTzw6VzxkVs/xhmydB3OEV2bUu+q9RAiC+P/+iTtV+3fkBNnEwsQpZwqZLjJx0cGILCTNZtjFKL+l6l3jNoRSNksTU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nk+sJcwHBqNQeO5QrGBNUzIETQXj4Iw/JxPNtkp9AxFwpHYuZiyhp3K4JN//?=
 =?us-ascii?Q?MRgaQti4FGloU6UM+LPL0syDdwVevZVELGbxVyKK1e5h8GEW19PfOjENQ48M?=
 =?us-ascii?Q?al0DBj+uqiICy+Ppw3OoUP/j4UEeW9VkCoGYq3Pd/m9oqd1q7yUhhK61tOA8?=
 =?us-ascii?Q?kRthslrE4QZQRF2iYxNBiAbIgA6iGMKRwS6oo4X1zqQzNAYxFMJIci40rirP?=
 =?us-ascii?Q?ls26y/9/jDJ0vCS0YKyaty2Mtr0EvVqHYGC9U+eOe3kmAyITAwaKS4O8Hyld?=
 =?us-ascii?Q?PXo4x5PbYzG/6U9eBWXBCMyn9y2bnG/Pz9cyAKe5I70DhxYFIJkdu/GqJ5Km?=
 =?us-ascii?Q?MvGMCQ+fHMPn4klHycJF1CkQrTiRKmK2WXCk+AYU2hONHI0AwUUnKO0nvrJ9?=
 =?us-ascii?Q?pBPdylk74t48xDNGzCqWs2YsJvy0Dg1VyilzBJVD7jmLuSD9PV+YsiwgjYyU?=
 =?us-ascii?Q?b3vnybGxEHityqKgNTwXm5sV2zkAVR6rrHr0sm1Y9kK8BZicEKCdhb6rc3zr?=
 =?us-ascii?Q?BWe/sjP61EMS3AywCA+4JSDaJNWVEos2pRV0agGdOENw4YDNn4JtiE4OuNa6?=
 =?us-ascii?Q?uRv44HIqaMFEVmM6ZyHuVUR8aoox1hb8bZqY9YZMKqx7mfE0k7vN4cVZXnqh?=
 =?us-ascii?Q?UkfaFkhA8H8WH6FTAB1AEPICmkhPcIsuRAcdBhanANu/L+GwVbNIGGZmcm7h?=
 =?us-ascii?Q?R91I0XcXXYuHU6RmKEJ0O+i3kjsA168cP3Jvc5rseVeU0rD1RZQubXG981r4?=
 =?us-ascii?Q?T5ZD+6P+70IjZmL+O4QGzp68W+aXu7wNmFP/tU+bmv7l2K3ZuTWr0VwUedSA?=
 =?us-ascii?Q?BEoHSfegB8b9yj73mLLe1OrfSx3LSYqkbunzqDKsL7ETYfouqZMtIBy0PSyE?=
 =?us-ascii?Q?k2yYybwnHjt9u5rHXN3yDuHNfJukmMHA57NZusqWe8ArGURRN5TY7pHhd0kr?=
 =?us-ascii?Q?fuiEB8BT6vpvY5P9CvjJVh2uzzG+4CtwKswfeSvAiEHilcdCGUSrN5oTDrM7?=
 =?us-ascii?Q?BE9wzR4IsqcD9DAP5Z1ttRe/1YeOysWU1pifs4SRFS7ZSDYea4NxRNpvCndK?=
 =?us-ascii?Q?6v22XkK69IJP3BBc77QtRO7BUg1QPkoFM6Nh8Vpksk56ovjCm0jZgs4+w1yZ?=
 =?us-ascii?Q?9Gx8yHMqKbL8i/q3FYLoYWdA4NkSMYgXPKhcer74LE/KhFOGSFgI89AtKNKp?=
 =?us-ascii?Q?LhKBZTVgZdUtQ3uVOCqgXcRGbGinOPgN0RIMzr9XK950Bc3gn5IrLisqQV6R?=
 =?us-ascii?Q?8YbmkMDL5HHyHJYz2fOnnpIHYzurdiEFEaFRXgKE4ax/7hh50hekCn8RN6v4?=
 =?us-ascii?Q?DtFHX3YUWLU70IRvgCcqdLUL6ufuuXh24P6F4r5I8wHBJySAIKjvFIOOSXO6?=
 =?us-ascii?Q?Xecqgaib7TZZpJ5Tsf6CvqQVuDeoMJYLLJEzrzoBKePtcFg9hSALKbo+avd6?=
 =?us-ascii?Q?uPel3MeSrMmUUYd3EzgV9NMqtJ+bLiJI/6Ow6cY32dh+8tmymuT0LYkuDP8b?=
 =?us-ascii?Q?I9Z0/k6TDezt/lUPApKjjTtXnekheakv2Lv6IGeGLOi1HMVRPRVI4LaFMzQV?=
 =?us-ascii?Q?q6fG/nLOHr1lqHqmN3tXXHg0nitGWu8U0pEWtdY+ARo2itp2R3Qo7oVOHxwf?=
 =?us-ascii?Q?9LDmIzl1fPLVooI/O4/aAC29nVjNexkigVKcVRQy9oxx75rsEuHTiSPFtQ1j?=
 =?us-ascii?Q?gaFqrY4YDIjC9KXkthO8YmCLZwZLkxv+S/HzbtpSsUVb9wIYGytTDlNGnCt/?=
 =?us-ascii?Q?F7PNCYUYUE8WYdBCAX5luepdQPlXJoU=3D?=
X-Exchange-RoutingPolicyChecked:
	FdWL0BBzVBqPONu/jCEz+AAjtfZU19mNCs91rPgPq5sbCwxEYaLWDdeD9urDRUhFpOBaK24jIX5FgQe4nGQ8/E0asbXIojvcBTle8D3HEKvvygXlkH5Rcb8zRlh2HkZeFxgXdR6C6hlvOZ5A9ijnGft7dnEVNz2lf4PLGzv5CrwPp5Bw5g0x0vy/Zxc5FUIlU+rS2ow3lXMoEUjkfhh84ZsSqG9YoyhAZimOUaE7B6OteJmwwU938CmxTHTbapL33zVpR/8LVlmywQF5ZTfZLmFaHMrnKtXIJB3ZaT7KbTsJYUMwQDj6l84pwjlwSFGTQ3+L6AD23xi4gZYyNAoKFA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K4lyyr+M9R73aYHAMg9sJDAYoKExf9VyJqFowLpx0Db8N32VMzBcciBmh8kemERZFLSI7hXpPpjmNZlxi1duz0lNQgUGInsfxIDl9LHkB373y76rHnGg2DY86QDaUpqyDePlF/1iBO+G5JTp4A4ap2JmSqROyL07ngVzBWOBa6IjZbUrfl2KHewYrzpsMViW2NQ496vVYd+wQyvK1FNj2nQ0LfEE7BHiPuq2nc9AdySaeIDpemGXlHn+khwBWHK9kgVgY8SZPvmJyJ3LHP92JWLbhoEhSCvou2f+b4UQthNTlEcKlY1knyMN66UHBLllIqhuzEh5qbaebhrVmGrxxbTdM10No/kvDDqKb667P+3KNaspFYPOqj8WeyFLPo7PIDzWST1ZaixU/Mj5H4vlCRJVMTdI6D5sdgRgeQWM/24zFpaLWiZqMXgzxISUlJna3IK9FxAaP5jP2p1TMqvVHZpEKoViE6eRriMO/hYhKA1lWR7kfyR5WZUGpMbWyb8j/sjICdwvb+hKHhBjZSxLHDVb2ZLBFP+Gfhf+zIfgNa7ly8rQbbsuRrGNJejBGU53hZUSVKNg+ZO108DsGCWYn4X7ESeDsmg+cGFx2+8LRjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e90745-777c-4b52-fc3e-08ded8ee2462
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:46.1468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+98rro/ItmddLvmpAttzchAfoFpxq6G4rBjRZF/TlPRyhvx7Od76EeULRAAGeZdCj6NxuaOfRF+PP8/dqDgkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-GUID: Vr-hLZ0vFV3BuU2S8fQjTQzRMypmOhuT
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a478f5b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=B52eoxIPv8yZRAGToxQA:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: Vr-hLZ0vFV3BuU2S8fQjTQzRMypmOhuT
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX7EifHiKgE6Xs
 RMnc3Ms/oLPiVF7KCh5LtsJJFdMeQUEAaKuaPkCyhaevu9fB0pgEle7QcoMLX6ofJSmEI5Ph5mW
 +hX5LLMwFPk3nfRDH97GL1CAk49MzTz/s4lgnAEVxH6ICWhRcbii
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXz3+poD8yoU25
 UhYzI1T4aPMm4ogK3qgYqhaIVzgMCPfV9UmH7lIWHesXB6gYrQWLvX1zZ5rGMtTa4P2xkVfB8Tw
 PhGaJofLMeu4skA1BYVflMMVtrY2h2+k+CGeeh0JaZwG1jdcgDHijYUTRLzRTZpSz3H9JZmvJPJ
 BYULT/ZzKpirAU4cExLSljedaFgazbGw92VXrx5AFXnm5rTYeWObsf6raQyh36BrBOMT0+rInbA
 5XqcEqO+ME6rg5SeVxnmHuFfCW4LwSehVP1hyk569c7er5Ot8aipAoUirq4OUXbFvatUyeQvE4s
 F0gac1u19fBc65ckCH+V/Ni129Fu62j6h/u3ttd8+Nx5rxNJ3OwgA0N2KtaEQyUZCjtA1tsZ6Uo
 +NczjuvgMgRGIWBETIT+ERqdUCx1qURAgPn27ytEnyM6GFd7Ddr/IgvxHNYaPAFKqaYcjEOuV3y
 8+DytZzemVSTkExAeBg==

Add support to allocate and free a multipath gendisk.

NVMe has almost like-for-like equivalents here:
- mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
- multipath_partition_scan_work() -> nvme_partition_scan_work()
- mpath_remove_disk() -> nvme_remove_head()
- mpath_device_set_live() -> nvme_mpath_set_live()

struct mpath_head_template is introduced as a method for drivers to
provide custom multipath functionality.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 38 +++++++++++++++
 lib/multipath.c           | 99 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index e98b4b241020a..ca8589d5cd8b2 100644
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
index 009d4bb875c6f..79be84d3d4f75 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -44,12 +44,111 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
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
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node)
+{
+	if (!mpath_head->disk_groups || !mpath_head->parent)
+		return -EINVAL;
+
+	mpath_head->disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(mpath_head->disk))
+		return PTR_ERR(mpath_head->disk);
+
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
 	INIT_LIST_HEAD(&mpath_head->dev_list);
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

