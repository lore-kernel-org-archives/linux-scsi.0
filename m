Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EB941B352;
	Mon, 27 Jul 2026 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163435; cv=fail; b=bCiN+DN8RQo5E5OuDdqrawlGqnmAXlzne0/R9aEvz+MSAR1+vG748Whd+v4cDpGj5P/MgFGL7fKQ9dm6QZifwxH/wQ9qycHMr1flYaQJ9QfiqfjXGCW3ct4sVUV48mUzMhylwotUFvifBfpq+Ofsgeo/EG8JlaF3TLNF023RIN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163435; c=relaxed/simple;
	bh=W46K6drptJTubRDiBMHE4/OCm8epIAGz2eu/EmS4bxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T6TmLb4YMagfFdkhRlBuBmlKhvAvQciALFq9/GwlUnyoBHbJwK8ZD9PFWi0gEWnz1QbNk1xjRzGASUIFt1ETledoe0HNgEkLt72hq86WWnB8s/4TpMP2eHiBjEMj0IkYcOoLmfuamrHWTr5Jwttcwj5HXgE+aWMv+w3LKJ5tOCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oWz5ZqZb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Yl88rzkx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oWz5ZqZb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Yl88rzkx"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCV2PG2245164;
	Mon, 27 Jul 2026 14:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rfeg31cWGpbZ1p59lGRIDe6axOjplllpL/MfO/8pzEg=; b=
	oWz5ZqZbNySLRLghAvvoWdCSfAltZ2xJo7//UKwGWqBPZ4m+b0+UvoGteFzEC7wP
	lOCaKqOigiqVB16lj8UHTpvXtWiHDRB2Fo+rY8Gjy5XgA4MeQPZL6h+WvOKzaQEe
	ggB3FEKwT5xvuCLmvAX8B1wVGDgkFUapBsaV8iTW73RzubTfJVwzr0pPtLsQMiPR
	EiRuchumwN+5FXTJd8qzi+BF9X/ExtbdK4jWUuVWjGVZTOxQclj1qBMlK6BNqvlF
	gnqoGaRaX8ECex0G2sVtvOH6mf1xfGbn3cyhkJrI4iwAj6DuXiaJ9qkqma2nyeSN
	dO61moD/enYZukvSzqYE/A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3phxdk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeBxD006879;
	Mon, 27 Jul 2026 14:43:20 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehawrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YuoM7fEsR+R1311KeSpN2dGaleP4esJi3bMMP315yhOu8paqJ9ZrT3lBHq9MSpzcVw1r2YS822HzPaftzG+JxfrmBQP+DLx12gMx7z/Ex4Jb5L7YFzi+IYV10m6yR/OHVSvf+stiACP3PmBR7azW3RT2i49CabeNI73NHeaBNEjdM48D3GfIfyyFRS2gAd/QptFuVPILWpJJn8ZqBMXwSJ8/IKqpFXL0dmiOZQaqVw9akQlsgaGsGCgGsxfI3EhRKnxZcmvyNKSWg+HbRF4oc4huZZmJMLNDX0mSqOq/0WRZxHnQIiMzSgT7qIwE193rblp6y/qhneBnbKmxUoZJQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfeg31cWGpbZ1p59lGRIDe6axOjplllpL/MfO/8pzEg=;
 b=rE50lAKvPV0ONHQIsTuabbi9+Gx2+Z/B81eWd+r+A4OX0EeBAC/UOQlOXCXYBbKjWF780OjEvZw4Z5aCYcAiuaHzE0J84KTxhCDzmM0fyipwrmypitqfDztIRllrQtQQgby+xyIgjLb0Kr2PsnPfqlRF20kxLn/UBWhkbVJznzpXDYISKxo+PLwok7O1IgATBzKFBs2L5KMcEYHP/4470E+DxkG+73jNzEhmoNi5SnkRjCG9fdPHkfutxN6sL/08ub8Uq187fDonRXWzzfpEov7zWyCY5UB/tveGxT+oqZ1uBvMJonu3MJf2h0K/8EW0vqjsayifDyuY9f9tl56eUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfeg31cWGpbZ1p59lGRIDe6axOjplllpL/MfO/8pzEg=;
 b=Yl88rzkxnTHECEX4EmOA4h+20wq1UfgWxsP6FIUM1L+QWAEfs3GPSQ695uiEtCXjjwkWE8CGu7S5yJmCFxl1YOWm/49fUIPp6/B2GxIEbP2HrcDjTnFwccGjTiQWpWB5OgPkYkLWxhmpme/gmEbK39bF2S8FUpbV7hEGsrUAO5k=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:16 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:16 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 14/27] scsi-multipath: support iopolicy
Date: Mon, 27 Jul 2026 14:42:21 +0000
Message-ID: <20260727144234.3802948-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0086.namprd05.prod.outlook.com (2603:10b6:8:56::7)
 To DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 3327dc9c-e118-4f9e-972c-08deebed64ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YJeiUAGgHRvnM4mPPdr/cchBlCXmr8f5HQrpUX7NBHe+G1mNATJqTQkj1UrLZbQKOjL1rApfH44BXKk7Ohh6qs1vZPgMchgtE8ULPqCocl4uHsekSbM9zAZLucKrAjJsZBE+UQGv9G79S1XA9dtPZd+WOevFrYQSctAGeOp7vHLJNUkr8553l9mxQEwmXhwVFx3TvpwqZTZYie++2XWI40s0Zv3RmhmbwH5TBPj2CpgRWktl5WNhMcd1dbMhl6FiC3fSmcDQELJ9MsmE8zAj0z4uoUPlau6mFhn0FM7GzkTUYk3j7g2iDHnE2Q33YlVbWvLQ4rSriFY5tKjoI4yv5BGtNx9JwP2ceawk6HNWTREWgJhgM4XTNC81nybhU4akK7v3+MWUhIXKRy8T8dFlbQ2/rdrDUWs1FZscBJbVi40IGWeDVojBFIzL+9Cb+AuC5mG2/aKESg/X3DHFK6QrdhD5cBtrHQEhMIdOi4U+Vbsj6u9XlEGwPM7eWGkZpp264E1bqnqVf7ogtkxPjAlwBqz1M4geImowpHrvClV3u+5i23HQPui92EDMn+q4EqP0Hk9W9ahtyXgmrFpisX9YAU6cCzPrSbtAJue37/tjhURzQ+hL0GBi1JAbwUh+iX5lUDhTWyS/ymheD1cnIC/HEkpc5ESZPDUW/5UrHP8nDMs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uNbUkbzWhECF8USl+kMk8d7wtUud2KA8KDGQMwfVWvfLUsxAYTqIZkgaLycL?=
 =?us-ascii?Q?AcdbmuyRMw+KGJSnCt0vmDFQUTfZrUlpxfI7Ot906y+70ZDUETxyQJG++6hA?=
 =?us-ascii?Q?yjsVOunBbTGsLipSGIzcC2H8gNgNQVoQPHktsw/W7a1lgfs/6GnR92NwYi48?=
 =?us-ascii?Q?nvpur+dx/a98eXgCknvoUhwP8tPjHqxNOcaWPMJLcVXnxmguIP9Rv0mcu3hM?=
 =?us-ascii?Q?kQNNs3v9jqzJA3G/H9DVR0f1wT2ON2hPhbualeWP8h0D75d6mk3bHSOtf+i0?=
 =?us-ascii?Q?3yKMzsIS5HXiY3tLsm3KI+DHD7MmyFE/RMZFouFOma3EWizp1F1oblkGw/VP?=
 =?us-ascii?Q?Uz0gPsoEw1ps1RaLlsIXExm6FwEsuuQo1XE7kLuGNhqPj6nMB7Gk1UFClkz6?=
 =?us-ascii?Q?oP0fyTsEBy2rw5CbgYpsasBeCxLIOSp+0W+FHdVcDLZrIRoNOzD2sT7vC70H?=
 =?us-ascii?Q?V4UuSOuG43pejR2SGLVIJPhEN5hmxwNl5BeswVucqY1yERmiLuZz/BiaInyo?=
 =?us-ascii?Q?RZHFZNuuhNsRHT1OgS2KJ8D/i38W/zgvGEg6d5mD0Kl/V4dvL5qCD2XtmsSv?=
 =?us-ascii?Q?bKzNPHgDPObJoxETveLl6u70vgS4lomBbLu1+EDrHa7Fuy+/Ufr9nBcevzv6?=
 =?us-ascii?Q?T4VZ4NUlgxD+Yz0lJk2fHNMWSU310UMp0GEYGNxAMZrCNZfb0g2fXfPMgOOx?=
 =?us-ascii?Q?oPr7o9e+fv73YAzGrvi/wZxK9FvE5dpMo62fVNJLkx493EUAu+BAkjA4yogu?=
 =?us-ascii?Q?ElXdorKwRmI8HdvbcjG1sVZ/HKp5eKK3EJROaZWVEgyRE2hZ3mh+mtwMU6pG?=
 =?us-ascii?Q?jTfXmlY6zRR7Llm8Jc6Zu+Or/+UqZ19wB3uukbXYIYAyJb3oMYunkCiNzJLR?=
 =?us-ascii?Q?YiLPsCS6ptq5rryESVkprKwfXE4eBrOZDKVw8wA6I5IoSd2qDgnay9/RGclU?=
 =?us-ascii?Q?zZavYtZzia2yOwLAgphU33RZ37tdSNZBAvP/NPIcLAHbR1TzrAvR+x/TFS2M?=
 =?us-ascii?Q?tOgt+dvBzuxBwk2QAMyYxbxWSjDyfLItnad5QcyiokUfDifhRttvP6FIfZ+k?=
 =?us-ascii?Q?QxG1d3iTaKwKa3Ny3Ms0JYSbTsg/baqNDCXUz7mvne8RXiJRA5CP9GNMdGxo?=
 =?us-ascii?Q?eiTMXSVdVVjq/Id6WZ1kD2yRwjOCtYpRwC7GjQkTvMmHvfz/AZEPSwRlRU1s?=
 =?us-ascii?Q?ReeF834BnBU45/g3Qar82cxxbS/B1KSzGaA9YqedC/7XjNNW72WcLh/mxZ8y?=
 =?us-ascii?Q?Alc8a45MADxMOVs8sThK3EPrsLc8Cnad3ssw4+HptPkJvgHV3GF21Uapm+8P?=
 =?us-ascii?Q?rsKnNd5YnSLgGWb0Al8T8qy1QtCyWKBkTi2hYj7l8bv9d9eDhY4Nx65fDQdn?=
 =?us-ascii?Q?BAgmtjM5QB5DJdzuXEzoY+cojQ/y/VUYyCpnDAGLYQovfQ901iPzwR2s4Im5?=
 =?us-ascii?Q?EjbVp1L+JfnVYIvZKMdbTqBgfs7osw1o7XRLXHJc1d/GoN/1bkn/BkhIhSsk?=
 =?us-ascii?Q?PY/MIZ/DkRl+1NLxdYtrtu3PqRtnkUegc+37lz3EgumUlFMShd3b/Iy9AxOa?=
 =?us-ascii?Q?P1Qw7DU90+Eu5er9a+5WFdQzDxmshupZFgzNWAOESnHRsuuu5ajCyXEatPNY?=
 =?us-ascii?Q?ULh/+kgvunsXk+h6j2GmM3zT+DO4IvBGonhTd2zY3jzozGP+rXodkBByNo+u?=
 =?us-ascii?Q?ZBUvr16KrGYS9WwlD2takjQnEcLdOh8o4AacrSPMPwJQCq29G/2SOZhQT9dG?=
 =?us-ascii?Q?Wn5E+UHn6LUv2RnfeSiboxvoQo080vo=3D?=
X-Exchange-RoutingPolicyChecked:
	WIEoWxeVkhSDVNOKAJIFoJn2+KlvvF5Trw0hIRnZppvY/icZejKaULfEeksN+lO6m7cWnhF1cw6eD0pxMUiDdlU481+HKcYW2M749Yygn+9UnDswV3Q3Bm1NiLg+BVuHtztsMpEHnc/36QEnPKS2iI4fCr/zIwnJ77RSkJlpt5SBjylmOQnDNrBofHDeuD8S4lzSNTXmrWKFNHSqkVePK2sS72MpJoJ84LUF0Ts4ETNi3YN0tQSC46sDiWjApG4LZp6m8DnzpHM9mPknbKowPDP4bFprax/MbaJO7HSfpxKlqqZwIyCjFm6QNKe/+PxJoImZ7hTh7y03oeQ54LqUMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R8lXj18MAEY6mUz4afZqJWCLkNEglDrjDyypXkmxPdi3+fhd9534365I8t7xL9p7/P51sl55mGrazyjFxEfRxqkGwhjcNEb9NXgjS3KaU9doVIj7x8FVFmZyg6FmcXqMNiUCDqIByxJggDkTyAFpWfymEgZLar0ZNfNdt9ESWajLaWXiIEilTiL6fT/2hWiFqvEr1dYpph2+GfyDvPGJZLp9a2lMssinii/ldFgExjVFf8u3WOULKGRVv4sAULjTzQOnwZgQeYi0fFlvBU0dGGHxkXL63KtDgjKnDRHXLlYGCcdo5ZQ1yAffXNkWn7Y4sfYXRjV+WYrDmob6hqs5spDZMjZkNePZ31KeTVmYaKGh676qeqoSP895KAJ3Zf+1PQcD2gaI8UdXEQyoRFmeNQZgeeQNwnZePopEIH4buuGhVy4lpEIlgnsCtJXPaxC3jfIoEHwfx08JCmCM/u6Z9qZSRcfWuIuroySDhkC93PDtFERCyCAM07FhL2G5gkJDwqAIUOQs5MWFUT9X2dKY9bzIWhFnBzvjqb295Lf/1OYVPTKNL1Z5+r5Fgpiq52TZbNlhMsMmEXTlXOieHblxhz7i/aCmj46MgPrpbRmi0nc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3327dc9c-e118-4f9e-972c-08deebed64ba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:16.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXPT4CmjT+qzZ5W3GhcEl/DXL9J89nkjJ+Xj9cHLNzS9SRCdUbBAKqTRcty/m3VdaRyUfZXS5gb5JeYYj6bkqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-GUID: 9rrKM3xQs-hO7b8XyAi6nd1kT9EgKqBP
X-Proofpoint-ORIG-GUID: 9rrKM3xQs-hO7b8XyAi6nd1kT9EgKqBP
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a676e89 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=8fwEAWchWUUFBy44-ZgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX/+eMavZ0Dv1f
 iy1T2IrY49jG9OuBLDXvDivawJeUm1v7KQFBiQYwc4oyIARmOaeTSS/Jn4phKBZmdY/b/RKnQdJ
 fz9F7D3+aM6Q6p500Oq3DkS/1GdOOmbOkjfhjCYtl+W3eG1txtl1cx+qrvwbv7fu8ZPxDvnCDdC
 vbnyIyxY6szuNQg+dne5Ct5ODMyyCcIPcbhYFAZ2KquCSWbtzHprKiSs0QUNK2oViS+x8dm+PdE
 N0avhOHBgv41cJffcUv2xhxtNzHQ3BTSHE5dnP82cFueEUpoywMZl7m7UgnfoOgcYb+cUk5O9B8
 BaeWrPMmzk1b22BgnlaGgn8XAWvNSWSPvTyjkIVgshYxQXgxI1VsQAS0au26fmM3vWVNUnAnxrr
 fhMRt8YeX/LYqTHSOV3vBdjjEPX/TBMSzQWi2QOA5JnVkicdVN5Ww9I9rM4foemjTYWo4PXATRI
 clhlerJbTwuEiuPTPzQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX6tRXd8R71xyq
 214vnOacnzsEfmVlNiEsn4Q7G497k1tcxmERGR2R8hWffdZsTGuIGW0yqEUWHfk6C+2TqN3rxFo
 o2+uU2NgbOBkvCJlI/oDxzJlj94RQcSdaoeSj+8SYr0z8QonaWOz

Add support to set the multipath iopolicy.

The iopolicy member is per scsi_mpath_head structure.

A module param is added so that the default iopolicy may be set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 47 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  3 +++
 2 files changed, 50 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 1866f282c15cc..1b955e19a6814 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -61,6 +61,23 @@ static const struct kernel_param_ops multipath_param_ops = {
 module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
 MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
 
+static enum mpath_iopolicy_e iopolicy = MPATH_IOPOLICY_NUMA;
+
+static int scsi_mpath_set_iopolicy_param(const char *val, const struct kernel_param *kp)
+{
+	return mpath_set_iopolicy(val, &iopolicy);
+}
+
+static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_param *kp)
+{
+	return mpath_get_iopolicy(buf, iopolicy);
+}
+
+module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
+		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
+MODULE_PARM_DESC(multipath_iopolicy,
+	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
+
 static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -97,8 +114,36 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
+		return -EINVAL;
+
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+	return count;
+}
+
+static ssize_t scsi_mpath_device_iopolicy_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return mpath_iopolicy_show(&scsi_mpath_head->iopolicy, buf);
+}
+
+static DEVICE_ATTR(iopolicy, S_IRUGO | S_IWUSR,
+		scsi_mpath_device_iopolicy_show, scsi_mpath_device_iopolicy_store);
+
 static struct attribute *scsi_mpath_device_attrs[] = {
 	&dev_attr_vpd_id.attr,
+	&dev_attr_iopolicy.attr,
 	NULL
 };
 
@@ -202,6 +247,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	if (mpath_head_init(&scsi_mpath_head->mpath_head))
 		goto out_free;
 	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+	scsi_mpath_head->iopolicy = iopolicy;
+	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
 
 	strscpy(scsi_mpath_head->vpd_id, vpd_id,
 		SCSI_MPATH_DEVICE_ID_LEN);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index a9fd02bc42371..2dc02313b0496 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -25,6 +25,7 @@ struct scsi_mpath_head {
 	struct list_head	entry;
 	struct ida		ida;
 	struct kref		ref;
+	enum mpath_iopolicy_e	iopolicy;
 	struct device		dev;
 	int			index;
 };
@@ -40,6 +41,8 @@ struct scsi_mpath_device {
 
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
+#define to_scsi_mpath_head(d) \
+	container_of(d, struct scsi_mpath_head, mpath_head)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
-- 
2.43.7

