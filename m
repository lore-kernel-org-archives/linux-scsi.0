Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03EC3F0AAD;
	Thu, 23 Jul 2026 09:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799503; cv=fail; b=RkmUF311e1/QW2jJfvGgwkYWg1OonDPl5IUjkEDA1HaVzTgu9wuch/nBWJwvsuwU0iM7mhLjJCbjvgOqNVIKbQ1KyX/O/lmeWhlZxp4ENPxT3OPlHZhqip6fxJ860G8wLAI+ZESfZ7Ghzs20zzvccI2b9Cv7imGsE46EvU6jR30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799503; c=relaxed/simple;
	bh=3qM8fOiTBgIb82uchiECGOzIzu33CHhGTbycdaZtrqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YH/dkdrLEvS89QP5VNQT6rGb869Q4Kk94ADpmNzaEEgJnRzPaiAbBrRYVa8fJFpve6odog4ghZpxlsxX5kRypBWuRChEmW6iZKk45Rmda/0sptaqTCatcoEqI1rPxPA3ejVZiCqmywx3pwt8NzGhQMV508W2uZfHtWuuZctOgsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DOgYwf9s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n+Gxwdd1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DOgYwf9s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n+Gxwdd1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtdNq3495335;
	Thu, 23 Jul 2026 09:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YTgQpiCs8fuc2kcWwrSWMngGWlWH1elOLKMNWk0QJB4=; b=
	DOgYwf9sT9+IIzVwrtfS3BaylCWCUMfdQ2x/xxHyllp463t85gLmaDYue8gvkt+S
	QL97PRC8Cfxp/F0eA+vJD846+Z4btZMMvVk/lqnsG96ouypbSAmhANxd7TWkoYr2
	JkwYY+u4IPh3NzZx99aHIuNbpGRpv3UskB/bCDtbzVGZxbKddrZAwsye/kxQs7sy
	P0XRK3akm3L10N7j5qRsEudav0OBT/f1mZ0WyTJDys+QTH/weBy1+DH15CQZ3eF1
	sKGU119xbvob8gCcpYDEAubnRqGuCpOkrWpAUMxSpDXPCL0BJi8x4SFS8ZSDLIIs
	Mfftr6sFdOe1THdeZnSYSg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kpxn2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X9QG021137;
	Thu, 23 Jul 2026 09:37:26 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010049.outbound.protection.outlook.com [52.101.193.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y4cn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gt19xVETsvlU2l9CPb0rmh+iTiuDUzO6HWVHMgsL24janYU9Hu2zruJzq3tfhcEOXmLB/R/N85PADilLEVjCsCZeHzrkwGX8yDS6d+8jrtJepzXSEATK+VkHFq5nzBkErVao/2Rwx3Z9wrl2kaM8LdCb8ey/zvLmaCsp9gcQzPOUCRyKntJHAZOs1rD9M54tQR0XizorfILeWGqM4GPSfa7HYqj2/+gUhLpeKyBZoPIBkEXM/j0gNfW+dcKI+PAPXoI+NY2YnGVImcl51MaiSqTmuydBUEx68knRKgzKxOSAY9/Os8x6wF3PthlMDGAdOHRMRTBb85sQOK7POTY7oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTgQpiCs8fuc2kcWwrSWMngGWlWH1elOLKMNWk0QJB4=;
 b=gttfEvUOAGzMQVlsE34H1Rapl0XlwxMukuIUe5gl4/7QsAgWsBGCWkFwfbOJ3BfmzYo/dhxxf4vs7h3w2dFQJBevpAzFQGf4kuMyU12sstn1y2bFvAiyqFLzXeF6pgF7tqytTk00wceZEkS9GABcL/SXGEWfvEikA517CQiPAOCq0MCt9rE05flXE0+CdQFej1LqbTNHSy6J6VzI8vaS4CNt1zS9AAX47sXuf+dOgdda1GtNNjMF+18laypIQ2kELFKyaNFqm0H5McKHMZrOYDGKYoP/Ov5Mf0vNO/JZcGM7ODpb2PY78EFQy+a7WvCVwFdrO7qEoWpUIGpNJA3e9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTgQpiCs8fuc2kcWwrSWMngGWlWH1elOLKMNWk0QJB4=;
 b=n+Gxwdd1JulrThGzOs/vloNkIGK9Dhfcr0ELc/MMXu1rCqheJ+y+PCUHkpsrQhUQlKsR7l+btj2Uchj4CkZrwbDUzbYzA/Bg11HJPz0EUAW2vopH+wRgMvBc/y+Nl41pe+uF/Pe7zTBaOEQOe8Zi8j8/hK9teLSUEWeyjWFRIsQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:19 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 20/28] scsi-multipath: provide callbacks for path state
Date: Thu, 23 Jul 2026 09:36:18 +0000
Message-ID: <20260723093627.2327456-21-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:610:60::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c67e90c-bf31-41db-7d31-08dee89dfd57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	SqibVUemVjFkq4p8X2Ya/3N2ZjLVB/JV168ygzFll7aYup0EnRw/7WCmOQOeFWdRPMG+T0ByQTU4FvDd2XO0f63szxNnZsiuDqCg+OS77xBBlJ4rYYodYAcXkQyLPszEU2u2H/R/A3xZHBr1djVakPRil4pwNjAl+m6MqKHv8cSCdFE68wYDPMx0Btxt8eIa2QBxcxPWbip82erLSRfUPaXERg6I8SLD6uNWjTsFBKOfuxuiDaBm4/bih7hCSgcslDEUC9LtoECcB+SWb1Kd89DBI8/9P4GZ9utHH+Mi7DWmcsLcOKTF7CdpRXzyZSgZDDNhrVneoPvQt7KOzyLlprJuUF3yz0jtNndHnvTLCb3TT6/m4ubEAadYD4PMK0lNRSWDb3ii4qQPhTNyLHR59ydfs4DWDqiBUoOxY3Q0O2+2Nyolg0fG9irjXScX59w8+mxAC1REWO6Ht2pDcSPyNYLJdMYRGcDhgE18tRV2t6/hcdXiIt15AzFnrd8tvfCwD+SJqi/oBL1w3xxqc5cmsh6xr+pn5CG5EjY0mg0W6l4svHnUB290nHfYht3Yv8xjMes4DYDb04WNt+HAWjCTM7ZEhLeB/bEid8dWT+3D3rARNWsCrIQ9CRgTY6U64qa1gOCBiF834SUQsO6VGObp9ujacildEsox26iGpS0xLGY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XvvpC+IvKJNfOg5kEj16CnUJ1PaCSAIINbUXpCpRODXat8CC6FayyLOdnSjo?=
 =?us-ascii?Q?4uOcluB4XgC0BnHZeubz9thBwRJmLrNBurXHrRT8va+Ml+LF4RuQy7/+KbDq?=
 =?us-ascii?Q?05Ty9FpXNwG9Eb0P3PH6/bcJrGV7vukg7doWwAfA+5nS1E6zd3P0Agds8ygc?=
 =?us-ascii?Q?5fvcUlyiY6BQ6R8oYZqVVdTNsZjTUwqFYQ/AcAHKPwBLcTUEH+/E0jDWZaTU?=
 =?us-ascii?Q?H1tRg9sVZE8dasDSnGjcp5IAh65J6ctr45fbXvV0uCAwzWompbFnKbW44EXo?=
 =?us-ascii?Q?aejnM/lmW550yDG14RVPWhEiybqq+CErZVCdrJNF4ryoMH62jcj+g5kLrsLf?=
 =?us-ascii?Q?mVU4EVKoeojuQJ/U/5qksc9et+OjTCnoNijfkztsC0PUYCoCbViVut6dBk3a?=
 =?us-ascii?Q?x/PK2bfWRQOwxWSFiGSavhBrziMyCOuPLvuxFjMJ11zOOpl48h1EiFtNjCW8?=
 =?us-ascii?Q?fp1Y/EwSaGxsEO44WGHcLRY/vjiKnnpOtXeTVAN4tIsq4AUkydICOz2KQMwW?=
 =?us-ascii?Q?PjXMPm+fYKgZp4SmnMjIcZWk7geo6bQ2m7/CslNmPLJMjBUCmzJ/i9gBWc/4?=
 =?us-ascii?Q?1wQm7lNtztfa7vXX9vb8m6+JLWutQ/MAk4L7ALADD9EIMyYbzFv72MjMVLht?=
 =?us-ascii?Q?v4kY9kq4aqTh/1VU+z7cfWzFDM4iKkY7Q5BqxQieBApk2BhD/dqUsLfMQNN6?=
 =?us-ascii?Q?Igy87bAR7p2QdACuSqJhD9GsJZnKzTr4m7qIB41jLAFmCNfqY2/wjtMsldCe?=
 =?us-ascii?Q?YOiyiLarXMG+k/nd/rAOv+GHeTRhxeYkky3zeK5RLMfxFuSyWmWF2e9roW22?=
 =?us-ascii?Q?sATJ/we61f6yD6Xe7YnXgObWMQtXg/1dDlFSBZpGaNSa/cJygZ2wu3S1XAVv?=
 =?us-ascii?Q?snc75kbfxXreALiDkuqZEmBtMAQ24sNCre/KlJTng5NAUC7jMBLDMY7UDfRr?=
 =?us-ascii?Q?ic5aYo2gR/ZX7jdXw3AROSkiuOeUGXFBrFS/Ys7YYPwMMk687rwbwDD5TB0O?=
 =?us-ascii?Q?eL9B89/4n/xBGGXhPnXLM8kFEqNbY/nBn9BGxvqUX3lGrXXqfrJ6k59dVQOI?=
 =?us-ascii?Q?NTcpDEbU7RegiG5OhkttvdXRLYoLnKwYOOxhMpwObym44Amo5KIM0RXZZ3Q3?=
 =?us-ascii?Q?AWF5/CuyLZMpCAplKDbzck/YZaJgjq+DCT5Bckx+NFf8Wl3JkhFMJ0hPZx/s?=
 =?us-ascii?Q?9q7B46MQpvsgLLJzgD/HvM2U1/hpf0FeR3UvpPPzDW5OgUmzNzouJ2LxINpD?=
 =?us-ascii?Q?QP/al1B/fvAS01EJ+9kdBc3kYvp4BZMNpJmXADgm+lF4Z2O9ZbkwCCx1NbEQ?=
 =?us-ascii?Q?7cgFrH42eGrGwASduMU7TIdxaUCV82nzg3aWFamW8xLQwWKrfVXyz5iBUaNP?=
 =?us-ascii?Q?o317iVIlfY+5lJ4csZUcaARoZLGynmN951WLSIMiEUFsXhLdOx3quNXk79UD?=
 =?us-ascii?Q?4l35t3Ff1QR7uKl3QA3lOAOi8iuSuBNne6UbSy9KoDSoPDYCnBqSlOVx3dBh?=
 =?us-ascii?Q?TPi9dOq2qbiUcREn5O/E5b+hWObuZdF1Nnyilo44hcNl07wo2zkd8XsGFi/y?=
 =?us-ascii?Q?voiHs8XNY7IuPwQThraJAlDUyVfvwFUTyJfy8JnzgtUyEJj6WAKCcGCuLp2F?=
 =?us-ascii?Q?aBtIjthUjQ6Xzir+pGMibBcbBnv8MQsEW7h2iVovwpFTr7x8T0SAuCWkK8V8?=
 =?us-ascii?Q?JlCBpsX9be9hRwhF1xmK69QPsKbrhd+btC0lDEeOTlXHGc13d62/7t8szh5/?=
 =?us-ascii?Q?qY6ZJuINKvAVVIvsi1pJTCxhevOwZw0=3D?=
X-Exchange-RoutingPolicyChecked:
	YvIUQlyr674nrjNzeR0LXpgiyR4ziWxuZzQwvz/Ci4EA+Hz9Twba7KvJTB4FiPG8h92tD8PHxr4Aq+tLT9Q2AJWyzWFwEQYnvtDPLvsNLwFUaEQ2QmiqutIn2kYl8jWh5q4ti9p60AcOh+O9uG4drPiC7JSiy63a2p5FO8r2AoqNvDhMACFNbWod8tGbUNm7bNQAXJ79qOu3MMrxQVebtF4sOBUXwtqBRvKIo8uUbTCHWzWBCtZTxsYG4vu5A37fFcsY2yMAYX4Bz0ilDZJBBsI+aeNMJMe+beheRGDIUyMgLvQmrLGKhOFOEhLNl6bC3T6rtaNswwYaPSK9v2/Asg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W4H/Qb8QwSdzFLUdk051eb8dD1taU3F20ucCyWiOCJZWtIkg1zb7igBhxVv0Dd1IduKYhPJPuW04+LozhfsKug6hZfc6HcnyL/ydXWowQDdD4Cuws7RNeWrfRdBpkZxWOMeBEKw+0Zaz1ozuqZffNLJYHAFGoXleWhg1b3KlZPNmN0RIHnPDs56zunXd1c95u3X4P1o3Utipk8tvNXUYQxrvjqU+nTLe0sGx1cn4cIoOiu9XZca2npayXbwtB77GbBDa0kBGBvRkZRmINmFnWv4JfljiyXKe0LMYWK9B+3MNRJ6odtpb00iGS1JkZnqewa0tlDmSZaZbGn0kaG+bGIomUvs+44yfRC2O/LnuYDUc5WqiPkg6NVVcKpnng4H8WgYXwHYu06GgJC/+9VUsX57ysz/QdUwgFgmuuY5XOOa12WY4S5FixZUAsVOELN2Y7UL2ToSa5BVYQQptWkp+whjsjZTkmTi7GA1+9NJAkwpodc/Ww0kpDE2M2pq0GT3ltrFfNVJDYpREYLHOC/skg134a7F70sUzXqOS3kgoW/CG5NWjJPeWpsSERUTjivb2aJffbCPDnJ7OAdPt5r1IlN6qfU7wDbJDuJqZyc81NoI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c67e90c-bf31-41db-7d31-08dee89dfd57
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:19.3281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHsJLPQhTA1uuqnCguBINkFyeI9NNAtf1pDXZzXOzG1OP+Ta2X2QUC0d0JqrfzTPo65hILTgFkbGIx2uOKomGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX2ZklHHbkh0SH
 sqNoseKT7ZJLUVyZK9Gp+KVNkxboPVt3dGYkcj+CrgcvN2E79H0JUpGoAwxD0rFlSRm1ORELqkE
 UJPY6QwSLig9S3opkah9cIDeDODlyg1a1FvpPyyNJY/ejLpvuo1o
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a61e0d9 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=DHJJM_rHgSnfI6yttmIA:9
X-Proofpoint-ORIG-GUID: PsFrA5JAIda9NSPZQsLxWhLKb7jUoofj
X-Proofpoint-GUID: PsFrA5JAIda9NSPZQsLxWhLKb7jUoofj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX9rdkyQiu9S86
 0dC10KUS3rZAfkP2i4EZ14qJ/IyjAcST7SubshcCibeSzzs40IErE2lIzcoXKgHjoOwbYvu6eL2
 OKK+uDeMr537uUXenTkymIMAAgcJEKQcNxah2QMr2nIVepHyAY5enffyb0D0lD5CXyx3WLPHPSf
 E+9f3LQIgRdhyuAbSKs/MECMzLtj55gso4O+I3tt+vsGjf3tWEjSFSSKMEA2s/o8ihclXwqockP
 J+bAzxL7HMKHAgMJJJX5j2b6EvhEByvxSYVQi6CcLIDymyMrlbnaQGZ7n1QUbNF/lCB8ewqsM7Q
 vc6DLu9DcHKpFavdec3uOiuHwMBM+LNt9NqzTKpX9a+ILqvyXAERmvlgYsEQAwvi9O7orePrIS7
 3B4+YnxV5McHIIqjKWcYl59gbRh+GE62Qj+H7X5umin626tsXuvRcvXzHanegqxa9ZvYshSioxC
 7vviVGyvU5hFHLS7OpA==

Provide callbacks for .is_disabled, .is_optimized, and .available_path.

These all use scsi_device.sdev_state and scsi_device.access_state.

Member scsi_device.access_state will be driven by ALUA. Currently
only device handlers support this, and in future we will have core
SCSI support for implicit ALUA (not relying on device handlers).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index a482b6ede21aa..e566d47199fcc 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -316,7 +316,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
 	return clone;
 }
 
+static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return true;
+
+	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
+	    access_state == SCSI_ACCESS_STATE_ACTIVE)
+		return false;
+
+	return true;
+}
+
+static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return false;
+
+	return access_state == SCSI_ACCESS_STATE_OPTIMAL;
+}
+
+static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	enum scsi_device_state sdev_state = sdev->sdev_state;
+
+	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
+	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
+		return true;
+
+	return false;
+}
+
 static struct mpath_head_template smpdt = {
+	.is_disabled = scsi_mpath_is_disabled,
+	.is_optimized = scsi_mpath_is_optimized,
+	.available_path = scsi_mpath_available_path,
 	.clone_bio = scsi_mpath_clone_bio,
 };
 
-- 
2.43.7

