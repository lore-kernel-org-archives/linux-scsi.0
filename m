Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13274A0C;
	Sun, 12 Jul 2026 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783879427; cv=fail; b=KEtDPNAI7BcGyfeIkTulWoxwoVFhKv0ov3FwHR3JOJWIsceIhOVfMILpCg4qnARySOuwhjLLUB04Jds4isBDggWrNe3RzvSyDB/C3P0guS/YDQhUXomfeCJ6CatAKkH05RP+OQaxs2/mndLVrJw+QzG/QscNtqqHMnhH621xgjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783879427; c=relaxed/simple;
	bh=NWWsofP8TsiQcAU6OY9xE1PRzveu78T7bZHMH2ZdVbs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VElJBMBcw94OD4G/TMH1ubFK/YijF3GRdHaNHGHnrbh4AAC/sxXhL61q9R+eNBDXCb4AMRJjTCjW2IDM7Bq1skVsRGLL/MbL6ZT6emcWYvndBMoqdqb8fZSXXGRcYVt1wr/0dwGACod2gQyg80bbLVj7d5iSAS3SpHIfXoighb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hd3jBMG2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FyOjuMXU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hd3jBMG2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FyOjuMXU"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CHv8YE3746323;
	Sun, 12 Jul 2026 18:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=in7N7w6l8h04qMKL+C
	tf7CwmU4sP1R0+suWwvg1EWBY=; b=Hd3jBMG2rG/p6CkFPujVzWLkKzb2T/2HMJ
	+r97pSYJAvG8wuNncwFL9I58s0Qf2OBwb93DzcBo+yPGCoYDJVk/X2DjbxeIB9Nf
	wRbhrcd1kwhD3QofwkFCGMpRzWuEbj/5yCjRs3+coIqefNwLt81G2H/LVnX0TaSH
	xzhJ+GL7Froi5deDmIM3fW3ktGG2L2m7okdoRv3ZRuqjmj5FZOzriibPC+DbevJ0
	HfXu+kNapNqlBoRreV0dh9dCYEg0U3KeGiMQ3d8D9gOpRkhq7v4kea+GXFPVUFh5
	fNtbfg6oqQTtobL90Y9NJPqyx0LA8w9whQy7dqjP6o/4QkFifjKA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbef0s4k6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:03:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CI3Vta014970;
	Sun, 12 Jul 2026 18:03:31 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011001.outbound.protection.outlook.com [52.101.57.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9pkqc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:03:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aIQ90YaRvcBHmdSwSUu7aqdwLNh+on7crmx1mbPlI0xs4+Fx7kRxsqeQBM0O5vCgYBCh7gE/Fbh5asEQ2YKb8Kw3XNt74bMCHFKJjciYk4HqxYTn1HP6vxDASji0F4op7h6hE1TvMJYCTi2+UniNBbeVLsSz1AHWaGigG/qNQvfsAhPXVmbIfwj4vqkDsyz0iMoGUCqJBLiDVB4BX2OPFNYNrgVojqour0UXJVhJFKtajYRRU7RV65FfR6s1Hi9joVfxKyvL8XyU3o4IIj7KO+8JnsE4rJB2Zdcx3XaDsgt+Jr+bxdHvtjrO8AfoayKUsu28G0GkkGNgmVRWVexZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=in7N7w6l8h04qMKL+Ctf7CwmU4sP1R0+suWwvg1EWBY=;
 b=PtQje8j0+K54+mY4YmUV28nxc14ITRW67PrnVwOeFKBuzkccEjiiOhUKNc8wjFhra6TiRZ49QKC8SF1k2I458AMx9rm50uxt+ivstbkH5XNdW1Bp9P2bsfFkTycrAK50LQ7d4u7yXa68KJb4+gmpnvv6SSF2yeIvkvVNF8efE+xhKz/ipgCmf/Npkndyq4XfOtWOQ93+OZKWeqvwWFlZ0l22+q0SCqjCUaH4PszOZbMfzNvG3GNrm9vF4KZ9KUDczijILafd6sWYizRj1aBBYS5wFFiFde6enDWUnYav65OYi5de79Im1cLhMMRc26YJlO3HbUog5GBBvaxbVyKgzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=in7N7w6l8h04qMKL+Ctf7CwmU4sP1R0+suWwvg1EWBY=;
 b=FyOjuMXU/rnNO5Fn05Y0wJ9Vt+HNDXJWY3nL82ux0LYW/jsX4Upk5hdtDPovQhCbAeOXerxfe0e+dDxtEKzIg4O1EarUm+mC3rBcvcrvCIZB3yqrzquCvtfy6Y7gQeXNYFrOwWTNHYe6CyFnOtNYvSp4GuYdpIISD51gcUUCgno=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 18:02:51 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 18:02:51 +0000
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri
 Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim
 deadlock in TX EQTR context
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260618140941.902000-1-can.guo@oss.qualcomm.com> (Can Guo's
	message of "Thu, 18 Jun 2026 07:09:29 -0700")
Message-ID: <yq1h5m4f5mq.fsf@ca-mkp.ca.oracle.com>
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
Date: Sun, 12 Jul 2026 14:02:49 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0182.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e520e15-c13f-4fc5-f922-08dee03fc9f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	cJKpr6aOYYDEK1rgV2v2eQKFy7qpQQEmfoE8o63AjR3hCKFG//3QE7ladcWCK0dEDWUqRPKUXStY/9VjTTV5DbuFiWyTTQS4jfr1CaVQnkc2vEl3ecxAflv95k9ooStH650QosXYel+jZicws9mKRDI+x81+cNZVi35ogKhTHO2N5MO6w/6vxQez8Ec22Jq27sK/bKBukVm9rcYCBK7peV+6vT2xKauh1jABPm4FVaylYLGfFtRW6p4xunyE60q6OepSPLfepuzGgnTUUlC6Z014nEy/9v5dsQWkpuGPWg6Eg2otGaKbYnm0bc4EYbO86uh+lZ2Ax55g+iFYb49zIXcxPJb7GSX1KzY3Iufs3D7K4QYjzPgxqCFuina4oVWQOg75KB+/shlZa4IQhUfGiO7G7aij9XRzX5WL6LqUa2MH6ggnGOBUpQbk5aWT4NofMqhDNekq4qrPdEx5I6kLcRpHHsgYXNz7wV4dph8EqgEBTyiv9+SfHiG1EOLNsn+LO3qA1XMqZJ3Rd9sSEtoUsj4uz+DE2Q5g6ccEXKr8mJHKhho1uWlQ5hobssroOLDlxD8B3k4XyrsAC9/0hM200C/Ds1llbM7tEsP8BObm1lpTQTD1dah0w9wK52fYQ1h/dZ1VlY89EvZ5JsnHXAulLe2tqY48BdwXmJMVgYd3ZNg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LAMbhPBYjwPq0byHFBTFEEygyVABSEQBLJ6KuQ3aAqFuCGDg5RcjIB2wD+tJ?=
 =?us-ascii?Q?WDKq4l6P4bGFbIJzqZkzJo9VplN7RjpvH/yYAz+xraXB6UiPgNxwHvquCFCQ?=
 =?us-ascii?Q?PzFm21JYcApl0u5Kj8KnJYmeBu49lVuYQU9frSSuS0UjlG90ljtIixMGH70b?=
 =?us-ascii?Q?qmNOQi2W6STH5aQRVH9zq7R2lfFiwqlpk/PKwia8lnSPc2lxVNhNAJujUXk2?=
 =?us-ascii?Q?hzIR8bJ5iV2m2X2TSd7ktMqydzxOmhgXSIbMGD/NI/liqkzmmcTAY+335wdc?=
 =?us-ascii?Q?dAp51yyq2PM+8o2Tx6QX86nuTj8dsZVliWKmShP4dfuwvBhstbNu+cqax41d?=
 =?us-ascii?Q?j0f56qoO9qID6yNG4gawLEIIRUwAakoXeFm7EJrN+hbe3bsLqLtrR+C2VzCf?=
 =?us-ascii?Q?4zbJkYNv7bBo5BtPnVYOrruPbjSP2ivhWOVue+H7iDhSM08tI5D7x9ac8fEd?=
 =?us-ascii?Q?CAjNSIrpUp46WDcCPmU09vOS5jk4NGc0fSwhazWBzuc7p9ztrtZOe1wF/Khy?=
 =?us-ascii?Q?fO4HcSChvQ53Ppd725Ej0jTwfC4yjh3kDdyBw1f3M32dJ5PXGypc8PaFuJou?=
 =?us-ascii?Q?Ynt08JlKkmxhtQ5pFBO2fEZ/iQXsEFyyguBmFJc7ymxe/aTPxVE/ucBvsD5z?=
 =?us-ascii?Q?Ghd7Q0tWd3guIFoOI/f6jn5rSn2aIiHKAwkeLJ73FnOek8CXWt/O6j+5MaPS?=
 =?us-ascii?Q?hH2OJppoUKCKLztt+nNrEFKhpoCdmA+KoWs+cVrvf5xfEdvqzIZOq01w1p5V?=
 =?us-ascii?Q?n/DswwKZ68z6yjMMoeaziBBlERcgbS6V0IuN204cEG8F2i0x0JIP8gymb+uT?=
 =?us-ascii?Q?NSWXu9rcXysCX1OwaYr7g89Dleqqn0zL2Oq260vHobokoQ5WXdJVZUtI9OcV?=
 =?us-ascii?Q?UFHqucO4r9hOrn4HqzD59OiVY5hnE2ZFEe+lu+Hd+Odh+Gy4wsvfCUv3Y0Yp?=
 =?us-ascii?Q?QdLV6rRBzfOyAJI1EhES+JJL3n2bin8Bw2KKCYIGjIbEFZg6Nlc4t2cjpt7F?=
 =?us-ascii?Q?/GLXz4Z0f5fvPcnY7aCebicg3RLB6yRDzwMhNf+Ayz3RCKaC9wX89bzvr2c5?=
 =?us-ascii?Q?m0XbrbXNpKmTfgbaf2obRKuMs5Sfg+agUAsVTRjNgiJqzkJqFTvTkVMhWtin?=
 =?us-ascii?Q?rPldsVnyQPAMXvhu0Unu+9hsFOT+0DLa+Wpg3ROFOpUFAM7UPUX9DZWleygO?=
 =?us-ascii?Q?q2HAaMb4JuCMjHH3e2fovs+UE0ThHnzhdqEs7YczggjMsC8cP8Ba8c9Uz4VQ?=
 =?us-ascii?Q?CP3knYLdGcR9jYxXgoKGh4G8wt2eMFXMeekzhNz6UeZ1bWL/QBTI/1mq10b4?=
 =?us-ascii?Q?zWdLHxYlnDsW6wV1FAWWPAHmJk2bYd/08iHsjl+GfjGrUWet7ThMqJ6BKhMP?=
 =?us-ascii?Q?JNCf4KSgEo8tV64/CbHUREhLocusD+yNd8mDAm1uDj5ookaE8OAz4wY4AVlO?=
 =?us-ascii?Q?aotI/huy2vTEqrETM6KIYSkVCWkeYnxV7DiWoKpW+prniukzqz4qEYdLjdWm?=
 =?us-ascii?Q?v2zcMO0L74VN7ZlMOZnS2dq4LVvdWHC4rq0KkXBYOrU8GsA80mrI0Z98qdDE?=
 =?us-ascii?Q?x5tmiLh3/RyIhRRc+gvatAsvMd49/sWkpdlTuSP/4owzOjSNrjFiFJYMpKBK?=
 =?us-ascii?Q?dnQcPigbOmIyBrfJ/6aCH1sYvdeIFPihDPFZfC6zfA2aFN1DPCYv7Rtbp47d?=
 =?us-ascii?Q?X5Nyhb1dGk/6Zua0xmfzRLvU3U5wqtUY48nQdthzJY8NwI9fGYG5Q1tzitYp?=
 =?us-ascii?Q?yK9dWnOer86nWBvTcDKSOHC+LkcVXJw=3D?=
X-Exchange-RoutingPolicyChecked:
	k5gTNog6t5LTNZk1Uis0H6EDvMCZ3Oh1D7puitQUDvUN+FPUx0fUdT60oRxuiGP35YkHFot0tmgGe+JTANW0WSQBOtDs6wzNxkIDdCuyBSlzPLjRQRL4/OdxR2j+4In6CNLUJdlmCXt92jiGaFqILz1l+AEK5WT6ojhLMNjpFmDms5yF8YSVSS66PklVjIxzuQC1zlNscsbs1Gr5eQ4BRmVZ9U+BRICOLgardrQ6i/aK2mbFaUzZnFAIESoRxu2nQ0udgNHocRiwaMvKsWJfe+HEIMXHEo9xW5iytUHmozBcLz3Qgsl+K3JMtzt+XMvdW2rn0RXFOTYpEVd7IYx0tw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DmHTp3cJijEwvwOdlunYeOOU0dvnD9pr3wiD5sI0XVW7SvVAcQtd21zflg2lYlEOBwD83YtRuP6Zu8f7oCbzfv+hzmVgCvQ033gskAiLYIR7tHxJQ/UYnwrLgNEzUWUHhXqg7+Z7LCdKm29GD9CBvT7UovjdYojAFJMl4iltWXwLTTQl/bn6vKjCLtflOytYmySRFPlgffrS9IwGekvOtUUEU7qSD0SP3tUGPJQttO+cM/RCj+uXqz5c6rmcUI3Yk0PF/GnIkF/FZTCxRy7tHXETHnpKSaIeGIqzhds1cmLV/p3rrMjzaCPA/pz6PK0m2eJNrOe5BSDeMZrfIc96Xdkgl+H0Sd0qOEnibbhKS/3LIvevb1yj2wcGSR9Wmn9MiFU1KDsIQDR1t4rv9XvNrpvRQA2p83tOSbmSbWsf6RuuWwq8Bso2TFcE7WsrVKao9QKYEfXLF6O+1sAAB7rj2aC+hdaABLFv4yFZZozqPbJFzLcoBnzAUaHnhhQ26I6kPhM/f0EoAnEQxqDh/wlHJpLQhP47BMMCdq0F2Czrxi6N7gLrj2N2IjFRFyKaHjotfuyHrgEQ8idRE4HlBaDSLMFF2zh/T9cys6RDmdsdC0A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e520e15-c13f-4fc5-f922-08dee03fc9f3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 18:02:50.9827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REVBFdPC7rqhkSfcMfL9ocqo+S/iZcJk8Y6jEZSsYnjVKmgzMN7uyWyDEntjr+sRB6hOe0CAl0kQlGsh2GmdWUcy0Dx0BzuAgYSrpg6rrc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=920
 suspectscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607120194
X-Proofpoint-GUID: f7aPJKLjV9mNlJVrl2-ozJOGcl_E8X88
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX/MTAIfscx7I2
 lvWan+v4UrDyqphhqwj8NXfHlmnYVfCv923kuY/7QCKyzGQyhOJVjhUd58svC5NsbxdrZgdIM0R
 btlYGf/A5Qm9+/3CLlrciY39kfmMGEitXHfnpZ2gqz7eRK6ZxB9a
X-Authority-Analysis: v=2.4 cv=KJZqylFo c=1 sm=1 tr=0 ts=6a53d6f4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=--jAjfM_6H5jj_Ki228A:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12222
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX45XaZxTKUfOx
 r/A7mqLmH7UPG6m2iTYgat2DPXKxBgFtjMdf6vS4Gziv4UBL5NaJ/DkG+ybjBtLKo0mwanhvORk
 byvAFzHWBB/mTL6V+rMEnJGBuxidOHKLM4kuZOGzE/Gej+vPYSGzp737BBq6I/zC5sjaeF+zpTB
 FexmwaAX5MPOIR8582+14U/WkFuSenH5b88mghUEpI/nO5HLN2LmrV2Fh0/+hBZfSxAVST4hIkH
 T+o8G84yh6HhTVLeaVSan0Ajk8/IUE4KnoyD4jfZDqTiMKXR0JjwcQQTAEeVY6FQ8N2h9uYD+xS
 VAU4/b9kx7DFh2hYkBWX1DrhLAWWcwsYosFb7tUMp/5FQE/REis1CWgy/+JSt52M79v4Ye2iBrg
 44EOqk7e3Br7e7to8VgYBHn/mU52bOTFSlksg0xsLN41BZec75LZk5Glmitv0fUAZaEOVNOqbAH
 tGfslh6yFRfh4hWDBWIi3A1oeB44TwAaYqynhx3Y=
X-Proofpoint-ORIG-GUID: f7aPJKLjV9mNlJVrl2-ozJOGcl_E8X88


Can,

> TX EQTR may run while devfreq gear scaling has quiesced the UFS
> tagset. In that context, functions ufshcd_tx_eqtr(),
> __ufshcd_tx_eqtr() and ufs_qcom_get_rx_fom() allocate memory with
> GFP_KERNEL. If direct reclaim is triggered, reclaim/writeback can
> depend on I/O to UFS device. Because the queue is quiesced, this can
> cause deadlock.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
