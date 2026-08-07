Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D97026B2D3;
	Fri,  7 Aug 2026 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115410; cv=fail; b=arOXPMSBytsGRY1SPv00RW6JSYORvHx/7IjHHRD3DISykCQI9JJBHFdEwLSRjboinMU6ApOjMQQFD7P6YV9SrisIWvU9v26ouHtekh4IBzttHBZr1v6aio9ppV7ClmV80bkNgY/jz655tSpulvDiFoca6IzIGtMoS7hI4eRFmvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115410; c=relaxed/simple;
	bh=j5a6+5jGqbFILUc7VMvFBMLTe/ZCsROrYCwMOZVxYXo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Zlb/J8gLtpS77ANbsoEQ/ZfJtIolNYtgieeuNiK689rubmfy2XyLu77d7eJsm1X0xgrQtGoX9zuLu3MGXzriUugs+UDpZ6xyL9xa7Y71DK2oAE6Uw8CpB9j34wNUvDJGpICaSorzVX7lw+ce1jQzIXejOOs1D0KoZN6mgDC41JQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PDKjV+Ij; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YW1xpb+M; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PDKjV+Ij";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YW1xpb+M"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677Etr3R1202894;
	Fri, 7 Aug 2026 15:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=t9EpTi8W24XbhEbKk8
	ooeVxDRYTLDW1D/j0tfI6UNow=; b=PDKjV+IjCleDwZQ0oRXxyHFQX6YYzavOQb
	4xvSru2rO4DJgrldD0gzf1O8kBu06iAzxP5TX9Y7oymAMM3x4WMn3TggIcf5M+qz
	XKcZDXW4JbGfsiSFO+OK2NCdmvIqRfSjBIjNoNNucbdKgsOgVl+H/CAVTkT4Vmaq
	ZxGF0M09fHsggON6lYxPGr0o6PA1EqD4QSNxggpO78evvMTwezGbLpN9R0A6J8JJ
	NZzgrPuaAdfGF3sdl6cGzKfpvQ4iyrNYekz7lWI4BbTlk9VdPJrwdgK66h8X2koP
	4bQNufaBdRh1fkL13oxzeVy60CvovZ+lMrRxY7yH5wbo3XvTU3kw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs77f017v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Aug 2026 15:09:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 677F574U027069;
	Fri, 7 Aug 2026 15:09:39 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010002.outbound.protection.outlook.com [52.101.46.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftpyw6qd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 07 Aug 2026 15:09:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZVcLkv8amI3hLSq5FIaZXu+/pvZJ+WXuCDsXGUIeHVzBwtW7TgPidn54L92bWwWoknhZZAJHfxlYGaEDWwGLpOP1sdDUx3+M8sMGS8Cl1pPVZkIBPwKX7+pYEI3Cmr3kr1UOnnm3rf0j6YLHV8FMrr5FlXSFR9dxRRZssVRcnsiLxkZFSw5iF/C4a3Jh/ATZXau+lfUJ5FdJVP1QX99d/WDs9BQrZGYfYup6LUPSE4Qo20Fb59Zo8hCubWclbK5HKgtuLwGg56cF9NlTPylFng5u7aSnHrRb6P7zDG0fOH4W4vIWzG7SDjmB/iTRKFIiYzFFr9rvrRT/hhYnbE9ayA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9EpTi8W24XbhEbKk8ooeVxDRYTLDW1D/j0tfI6UNow=;
 b=mHJ4HMLptGIowO9kOI061jdmee0nPmPbZxi7asxqqiLEIftj3d2pvN8QZEjmS83iL9sG4xEQ0/zqA3GxnoSoQAud4zwvXD/j+zXusOPC9bNpwCLmOzGPDgbDXPJpdFrlAB6AGeLpd/1W3EfJXOXWsz1iDWmkAUaNTEiSHVTO6ZmeXU9UHaJz6YJ6SXs770ee+HfPSfPr1+6R0Ee631Z6bo44Na2BUxvnrNMW14zR/G7IQ1C3W6nCCD2uxlPPXUvGze7ZSAd0bWVmxfyhmE93ddrvcc64+8O5m179cKCHLwgx6Mo6BAfemMePzXnPCZ0q4ki5HZpAGPlOPqFQuDncJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9EpTi8W24XbhEbKk8ooeVxDRYTLDW1D/j0tfI6UNow=;
 b=YW1xpb+MN0EDD6sKAwW1Nb+08uiva7Trb7IGFCVCshkZohDAago4YFyVEqkma590EVUxv3pHGdT8YnIb0pvXNOEeRfPkiOHVP4xsm9OHsTzY13DFpMvdqzQs3v8Jll3DxCX02ohpJ0dAvqZCuR3UQCBLiaiEXJwgd/4MVmx65mg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4612.namprd10.prod.outlook.com (2603:10b6:303:9b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.24; Fri, 7 Aug
 2026 15:09:34 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0292.019; Fri, 7 Aug 2026
 15:09:34 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        Christophe Leroy <chleroy@kernel.org>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ibmvfc: Fix spelling mistake "Deleteing" ->
 "Deleting"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260730222951.352872-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Thu, 30 Jul 2026 23:29:51 +0100")
Organization: Oracle
Message-ID: <yq11pca3r39.fsf@ca-mkp.ca.oracle.com>
References: <20260730222951.352872-1-colin.i.king@gmail.com>
Date: Fri, 07 Aug 2026 11:09:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0066.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4612:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b38d174-385e-4142-eba9-08def495e3df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	98WxJCBlwfwhmc4mA3IBNVP8GUzRZeDvtpEK5COdeZTtPLYOluvC1DLkHjsLqZGjZjRJEARL6paJ0rExybdpiKWxenlV4MayzaAIB7iZnXGfh2HmT1SOdawSPQbDPNx0upMOlNWUfgrvexXSZlfmZXBcQnadeU5EZQyDOg70HXGtVJoU/gnE7Y3NagOpJM/J/SrlkqFBHm6sYByQ++S3K7TQIpP9ZKkZ92EJcKKN9QSEMgd5MFsxsYRBfB4U3UcocGeG34j3Cmg2ypzjWjlZHBRJLSc3GV2uzjV7uQ728ud5eZke7w/fmIuiZR1Ss55fGmhqUx7NDz5aJo3krpVWy/bc4QpzpHicpuS4mfcJVxaZRhaAPZWYpgkCr8VxceS5m0aaAIQjLQgaKoHHAbM12kAYCrEiefCkNsv8JKt3sFZ9Zr9vIgistTa/DI+weaaM/94JDFuCgnJzdKU8G4txL7it327RXVEnG9N1TvFvGzzKeP0OvrY+CHajL8mr6Yw7Vrr1ynWriRyPAG5B13g4hQeetcn6F19rXsfWXz9uC6HW4cMGEVrQMWqJThT3f6Kl4jP/zEFFvwlxQjncqwhNwamRbiGw1OJNI+0ZGOFHjIDsa2RVeFCAjTg+G/7NfpfDh5HQMXzjA24PXhVZmQzAnw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V7LofWrYRJFlvL86c/0l1byrKeA8ZvlCerJn6dAWHHHIoxN88/1Jo+qzv/CF?=
 =?us-ascii?Q?sSBwsaKF8FGQhNdZkFLonAVjjRx0usZNbJH3cJg50mYHoJkFA6BiYC5Xs22j?=
 =?us-ascii?Q?MDxplOv4O+0WUC4YA19fZ6k3llfCMzTPko3uLy5JYS+eWi9QStwtsVtlPcfp?=
 =?us-ascii?Q?7vwXngRyuUiLHg2LtF5uq83RTrk9ty/dnHfwxRY0WzWgKyq8XaYrlvlDraKU?=
 =?us-ascii?Q?qYni4x1gqBddOMAW9n2+t6CFf1iHNVwpBfUqiFnjxToz+2hgvV0XW8PZ9vFG?=
 =?us-ascii?Q?qRkfHur465aMRmPPEvpU9QGKwMkZFenP1uZnMH+pO0nh+ymb33mZaCWDz2PG?=
 =?us-ascii?Q?1LNLwEdpUpGR8sdy1JUVfycQM0r4Lz7RIyX70rKvxrKZqvNzTX+BLvpHQ9m1?=
 =?us-ascii?Q?xXZF6gChfBo5tHqO6Cyr1paasl+XH6zc0eTObtWTkNZBplGneSpKl4ngOoSn?=
 =?us-ascii?Q?RjBG0Ph37e0IkzhrAejoUj5xQSFcwwRlBYNrTj6tTbQ5rxlmEXFt0EkU4iTB?=
 =?us-ascii?Q?KssjPVZ6gPbt15i8gwfnGWKLbNh25SrKL2YrbtqQSwnRwolpsH4BTD4xmbR1?=
 =?us-ascii?Q?brPPhBwkFMZPVwnE+LC1A+aEEOT93fjsxrP+1xuKZtd9bV1blSEn5fVHdE55?=
 =?us-ascii?Q?h7C+ulTS4/8qoTrqQT/fz5l8e4SdWL56eoZAF+blJW4Z0Is2qyysaM1NTEK4?=
 =?us-ascii?Q?gXgMA9TH6tplXR37lwEdluQRrr403Ezs/wk11znveCgpQi/fom7vxBZs8AJr?=
 =?us-ascii?Q?ZpC74N4bxLiARMYUw7somMRVbTjwgWhBPqaHd6wg9fX1WgiGfU0la4vMy/2b?=
 =?us-ascii?Q?BR1bLEcwlXAtz04uE0oZuAm3OYuAhHTAY41l1heYzTqvW07iMjqAE/oWeRnz?=
 =?us-ascii?Q?S36P3diNgdQPA2ivDMYB80UVwKauqvN/1eIRp4IKTScFmm6O3i8N3bgkhlW+?=
 =?us-ascii?Q?k17HSZyAtKVhMywaAgIj+coCfvTZgfUICeSawviiczST8VObHThKwl2CS4gW?=
 =?us-ascii?Q?bZOey35kDw8MSIlDIZgpQhmX/W4BQ0JLhEVLWbBk6p28wLG7i81dVk47obiz?=
 =?us-ascii?Q?Oi3g3hlFH0AULSSXk5nJO3ZWKP4r18LmtE3TKa/Yr0W0J4aaLWEbb70xf2vw?=
 =?us-ascii?Q?bc/3BOZiwLakQAImiNTfAmNb0O5YFZ2IXH8ocqa10hyByB/6DpijmBfDHHAE?=
 =?us-ascii?Q?pk3TLRa1MFwyNkPsZXvlZxaeTkGnGjHmUIxMYu94CtKJox2DBl+r/zkJqZPp?=
 =?us-ascii?Q?IX7sZlUFTkeAd6haNWZ3Vkqzkb91VqPWdLjrg72BNmnR17Xg1uWWXovQusPZ?=
 =?us-ascii?Q?fz8mrzACSNKM81p+XowUdmSmCvxTh+BjXpTn6IW9Tt/Jwe+yabkmykC6rwKr?=
 =?us-ascii?Q?dR7HEQOyNXGO5U1ftAsAT0dKNezfYPl9vcgn+vuCW/NYfDgT2tQQOk9/tok2?=
 =?us-ascii?Q?CXCdu5zE67OHasd94RGxead6ZTDaY9d2/DMp4aie16yx/ikIX6L8LHM6CHyu?=
 =?us-ascii?Q?BDJ9+BQdEy6HmsbSMxsFmemJXQjEzdh24RXjkklEX/Ieybd0CdDJQuDz7Jej?=
 =?us-ascii?Q?9w75WMAPOyuDAnw88BTXZ952NRRd6/BYkolv72ER+kPgSNsWnA5fW2sDZo3o?=
 =?us-ascii?Q?HmvRmyCoSevfMd5fj8cuSb3a4fFOxY1Nr4/y7r6gdosBZAGS2TDN1x5+YxXz?=
 =?us-ascii?Q?i59ygJZ/eBGFDZNUkZJ8XtRfGCrQp7toDaP5mcFHn97Oqf2FJ78ADjL+0Tee?=
 =?us-ascii?Q?VZGgxEUSo2RGB6FewFyJR5qUHA0PNCs=3D?=
X-Exchange-RoutingPolicyChecked:
	YNMXbqX6bdCKS9gqvAwX/ksoNuSVvLhW0ov6NP2nUPCRpqsE3kpf9C9cY6c1wR3gsYWIAXlOVdmyTvawHPVtRSNNz1GsAb/aTktP01asjMJi4oeH1Sm7tFDjKYwvf7LRwUYfmaGc7fyVLzDKGf7wu0YC8oGIU5KEaWr3wyPO1g5RPAtc9dEV4LzGE4VeAxMJsqUM5iFe1lmVojWCErD5XJvw+cgOstSPIoP/LzR7WVYf6jZJlbTsoTvvbzTiHcptbYs+hRbTrmOxuzrSzI3ydozJjAQYW6JXHga70/OP1CAKwKgTkslVwCc2+WcyLyd0+M+Q7Tv7lU/oirO6GbJ9Uw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AotI2lwjtZ1xevH6f0PXHYJnzL0VNGPV9UFLt81/xEr86L9A+yFAg/4R0PM7Pa8sMU1OFHDJSlz8eQRBYWvDILoNK51FVZNDjs7BJs/PDhlEoDU0l5ZlfZ3xVbMwD0FdGj1HTCB1lfr6SQntqlI12CtPOlZm8GCgU1KrFSxGLVefEUchPWjz7Ti6+Uvo6OUrvymKBq+A1wUwcEatagWdnSSn20GUJAEWDxKClRvgvNSUxI4PVyQIxZJHV86cZXSuwge7MtilzWELffTawnNdSXMl1FvGNW9pY16chh+JxWUfsSmfXGi0KPw4rpOIlxveAQnXjTXAV7NeJaD7IgupPED4wSzh5G/kilLtu6c69g3mdn1CtG1d1197E2n+aF6JYJ0QCSra0Ph1gaGxy0XWic5NXhepByaM6QKB0RggbJfep1ZVXLG7p0eeWn1CXv0RQe+XMtXiNvluVafPL9go0BJL7tH4GeUY+O2CWmTRSAxLzM5/XS8JFcfwaX+5mMPkGhLKna7r6kikseq91SI9aDCkrF3PEOLtSJ8F/SjgUBvLHwhCwNBlt/Q44y/XjkyrvVxK0hWjaP2F/1Fa/ZDuH+U1vVzQ+pH6CalRawQO/uo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b38d174-385e-4142-eba9-08def495e3df
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 15:09:34.4760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zdd+VyYvCElRb5Xx7ZQ2NrEFz1pvb1kecR/GHCNuq9mKNIxHOpeY/FhP/+UJ7dmq+kT7rsIcPO1MrAI8SzLNSwDtzMMvQvkIBLjeRROZt4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608070118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDExOCBTYWx0ZWRfXxtxYDAGb8JOZ
 4meF7Rn+GS9D2NHsYgfmgVhst7stjDdfozBeDkKVFjgqZMx0YcNkBtqXTyc/05/io9Zgu9Rfj1b
 3TfWaTTJndhdWOg3LpTYPTuS/IJ/5MuyK72a8lXbWY8bTzUsSZCEjkxAph6h8LnJXhcG5SSjpgD
 EV31aI3xF4LPc09v6LbMP5OlTGudpzCBiwAH3pu1M8pWQc8QnWz2cYSLk7RBQsPSMzZpys+mlYl
 16okepw1QPC05PX8wc9nBpF4oBbQpktqOSsnOudLH/V3lrf3uXJOniwPxwk8TE5ulfVm8YQtRvh
 Q5TJYc3TRjOFcG116wLrTLThYB3B6ibVS3UI5oz6Ce5k7qe9benIt/hxroI7hwNaMk34N903gIj
 IJZLNsDzUh+WrveV7eVGtxXXxOhD5reZTruTc16dOoTGiWNTcfi13/Yh3bCIQTGzC2Z5V9pIReS
 ubxLyo3sirK4LBFQFqQ==
X-Proofpoint-GUID: AfQrbCtf-Tzdhear8rBfSHINSJGXbPOE
X-Authority-Analysis: v=2.4 cv=OqZ/DS/t c=1 sm=1 tr=0 ts=6a75f535 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=_pUgLgvJtE4f3i4Bk0QA:9
X-Proofpoint-ORIG-GUID: AfQrbCtf-Tzdhear8rBfSHINSJGXbPOE
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDExOCBTYWx0ZWRfX66IyndsZlwVh
 efNv9R41kcJRiidANAOeeRvGwh++r9nxitS4s29tdq3VSoXq1jYpz40YGfBUazGAF9lm1PX3GJT
 HzAzCy+yNM8Qo7VeZfAz5+3VC8k4GM0A5mY2OOOx/GMopdt/t7U9


Colin,

> There is a spelling mistake in a tgt_dbg message. Fix it.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
