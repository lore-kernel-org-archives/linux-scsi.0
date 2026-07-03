Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81623C8716;
	Fri,  3 Jul 2026 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074683; cv=fail; b=O4LsJ7sx5LrqkT9xhnfYiomcl6XmkAQH1ZpyvUDueXjNTQcK5BJF218hfLjhrmSCYguh1lbjCZ4y3fCqfF7cjct8CdFTzthycP+H0bXU+xZ601GfifWLkQw8Q5SOiVTvwy5P0Fgq4ae8OccrUPNX59tDefFm6Y59YTAjY2tSuKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074683; c=relaxed/simple;
	bh=gRIW49F08IckRcBgV7pHMyl8pDD7wyXmQ4zxuG8d+5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N2X8ydCpZgoZHGYsxVs3gqlVX7r8qFuyWcSYn/QC7aRB3P15AU603TlLvVK5yuvlAId/LTW9Rr62+q7DVlcvjOxd3Y2AlyWXiPXzXULgB4EbpV0BNYTPUNAKUC928UEpXKuIdVq6vVnHnBwJZ/tk9SXqTHgB6/x0Ik4yiqRQ28w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DCMR6ir6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vPabXrJi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DCMR6ir6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vPabXrJi"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638teVY3112671;
	Fri, 3 Jul 2026 10:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=78j5bwpXk723gnvatkqXDVzsnIM9zx+1vZ5JQnZTwIw=; b=
	DCMR6ir666rYwSslhb9VbTvq1raEwnep1TXuIpeEIgMTR4bvnTudjoaz+c8FaPte
	r48Oa9L2j1C/2LuYHRXfW2fOauEPzVxX5J1GJIjbM/emUpOvlH3hg+r7Ep0jE7uT
	ejRBGjY/6DWMdxihPOYyfQ/MEFZ+xxFbyMZ/4cG2nQFDg5Rol6bcO/Qh0lJ9y0Jk
	VeBI6euQOLGLHaQrl7QYXDiz9VNXQvq4qRpXjb7tUIgES4ZSwdcCQYGns6XnuRdq
	YOV2X+9NBEkBRTETwPg/YhjQbzf8Ijg5cdipYxyGtJ+rbhVSWho66KiZlAOZASvS
	RY/RghjyQfLUbLy196D80A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kfjejq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS8mh013395;
	Fri, 3 Jul 2026 10:30:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvqe1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:30:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6S+j1qM86Q52510d9TFwy91XpFUwieO9dOlFgz/eQSZ2ANZ/bz/GvWYLCgMaElV8LQIPrUkX4gSq0qaFhMqybO3seYE88SjliZlv7nZ0MzA9HpH6ii3HR3McBUZfmjYOA9eoaxNYqSjAakU9GpwFfz4qtozQZEo+YVQo247GaVuXIEvY1spxwPOzwI5k7dcoDPx+O+uiLFM4PZeUyAJUvZ4uQskMSCv9RdJYMDLTndR2EoZONeG2OSoZC+xVePBFGPHujJBYY9rE0JJFGqmKOKYWg04D+BPoF8t2sfAOJA/fnQnA+21C6EtUcdz+O0oHQSph6ip6I+4VKN7rdhY5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78j5bwpXk723gnvatkqXDVzsnIM9zx+1vZ5JQnZTwIw=;
 b=KfTWHJZkZkOdP6nkHKMBchXP9sOetgWI3XkZPLraXYAqr/fUqnYN63Y8D+4W/vBqXK7yq2VbX/0GmN65Cy1bZHan3lYE7SK19IfCMOvJQVq5qp5NkVxkuVBlQ8U1G3sCBmFz919z5hyMlAoCx1TgzLhaMGJ3D35pfV4t5X49Ji4PBQmJ2bbBDOtu71n3fbPQrXzn/2SOr148WMPaFn+XQWWhYmcP8b4VaCK5Vp7VLBVPKG7ZVLzrEz63U+WvdstuYa1ecplnK/+W51gYAeqKvGEA1b+qj92KdLMrsFxdarUCX/RGMc30iReYF+a40cIKTCgu4YYpKyBkJrccH00uWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78j5bwpXk723gnvatkqXDVzsnIM9zx+1vZ5JQnZTwIw=;
 b=vPabXrJiQwFYI5qlKY16UwZBSU2KFDuI3+WWGZqh7M9BzK2D58n3gz6LMWi9rzpPwCa73NR23W+e1R3Fcukk0VyaoV+/3YxRHL7CRA1IWoxvWv056w3hxNODQDvt8mGdrIJ6sThwwKGBVmee62Xb8dnCvl4/rxmDXv32WOT60aQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:30:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 04/13] libmultipath: Add bio handling
Date: Fri,  3 Jul 2026 10:29:09 +0000
Message-ID: <20260703102918.3723667-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 59293e94-383e-4e2e-98b5-08ded8ee26c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	nvoE9UNwlENnhCStCXEhgydTcwpdklDjSXm8yskheQsNltcapLoEWQeuK43HfxTBoln3VfEAjOYflBrXkN9MgOCqpecTahHgacE+OzGE5eg/TX3rL7x75cggBGnywYk+yMRRhpw5MhInMenhv9dyxt6AW6tJaVsq1MSEl7YRW1I3V4SJCa25AaR/V4WtmlMIC4vBWbGR3PzWKZcfAZutDWHWPZfR2LIYIffGnnXaihAZpI6jGTRyEkNbEfMgttDm/TUzAjs3Zmb66jiKebEXEiP+KK3KVW+4Jgn+6s6eOZW4wJKh8hhLdFfU8NwQmFVjfxXr5Ney4j24AJ8dO8yKa6ZyT31aVtyu9gwCUNsNx6apC+czGK9TepaaH2JbhN+ylscLfp43zBEW/96Yg9eq8MITkMFzTg8U0+yOifC2FxHlPRSYLdQ2IWuVWavILH91riCXMLXDyozgIin7B/VigM5KdpqWobwFpb0s5nchfBBQ/ad+Xz5hDhrU4yXIeCQjOVsreVqPg5VPxBt5EtnriEvGezdEt6vd3FAgMbnOQ5NbinWyB6kyRXXOpq1cFCEM+WiNpkk0ENsn9AldlFevfw5/mmnybtfMFsM7OIv5fX9cRate5wSNF8tU1sirHplWX7+/0z8rtXvV0URZUYhZRnuZL+KppnbAeMi80OoTpOk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XKedk1SmC4QKjB1wPBxxWtQH539Il+5VAfeb/+GTyY2RAiXVWFaKZYf0yORS?=
 =?us-ascii?Q?EiVFfZgIVpq7ByTwZ1b3L9DD2VkT7fpstB9TJwEHeWiY4aLe5c4uC4gSlEhG?=
 =?us-ascii?Q?t4RzyMvT8x9lmUFwtn6vnDx6c6TpzSok2x4oyGXrOoaeXJ/Ap9eDfdcPBsau?=
 =?us-ascii?Q?iAe7B7hj+Spw1V8aguPQLLjCBVYTyMvt5sLGBrM405LPWd1666tsE+3je3Ed?=
 =?us-ascii?Q?JUOoWzQq29Kz58y3HdRMuwewsagNeYtUf4HKZA5WqBbGC8da9ZAMNBZUnYGx?=
 =?us-ascii?Q?HDNuEMFuDWz4B1/g1XfsWV40Nxr7wxf0kxkngiiTl4mSFmzC43C2vNYiMfeW?=
 =?us-ascii?Q?9dltBUoh70Me7i/SlKL7Olw+J+QdPAjMAqocCnCJzWpHR2c4Y96FYtKemCPB?=
 =?us-ascii?Q?9wZc5ZqYvk7S73xyimVh5e2In3KADDR676w2Ljsxg5I+AVfyBb5OYkTKhr4c?=
 =?us-ascii?Q?DoC0VF5y/b1P1dKJ74RLKwVXCNaZLKJdoDOo6bvk6O7mdhUUK0U268TQK+hH?=
 =?us-ascii?Q?jNbYiHCoRuT3xBX+Gtbxf7IKBy/JILOmeNDrM4BNKohj5r8F0jGmuwwnBjvM?=
 =?us-ascii?Q?FTb+cp1HknXeZDZrtwd3f6Ud53QWJzZbYCf5vkANquoTA5mr4hZh+hQLAQXo?=
 =?us-ascii?Q?DrE0ujPXo2igjdLHcVs3DB/VlBuKnNNxUAm5c8KDRzku+LpXDQnI3zaoU3T6?=
 =?us-ascii?Q?NRbDtRBKinDGwQNegJ2JaB72PBWk/y5eqmXY3uFCMTVxBhYzPPxuhsiorwkZ?=
 =?us-ascii?Q?RZ9ZIosTWFs0llMe8OAhZfjxvFWQ9lDwHy7X0hjtJX2QBCpmTtBqHZYftByK?=
 =?us-ascii?Q?ftrd5TM/9g8q5PyC+W7k/4g3In8sN9WzSI/PBoNi18HSE4wCS8iHLfeQUK0q?=
 =?us-ascii?Q?Yv7GwW7wGjRB7HNRJuza0TStQ8oejMYXia+Z7ZBN7iCSuwYmmWnzwqV9MnUi?=
 =?us-ascii?Q?rFmYBKCQDny5iu/0BCPmuHDvpvOnJ5xsLqZWDtx/oMNUNe4km4XiRNTOohNG?=
 =?us-ascii?Q?xYESNsmaYs29PvNRge/UIBs0/SQGQIVQWmDAeFkGrVhOnNjxV6GMKm/tUec3?=
 =?us-ascii?Q?78TbEVBq2duzucPo1dAxoV8uBtpMCS+wkUV4j0plz//7yMhx9v8BUp3EIbcL?=
 =?us-ascii?Q?0sW6ssZaFGluW47MD1lTPBtyE41nPTznVcbrEUsj4pW8VfEyp6P7tte7R/2h?=
 =?us-ascii?Q?ulqoazZsixOnspxXDLmNH0toLx68bNvh/5JRCX/mIs+jFOiOA12gh1AjQXCU?=
 =?us-ascii?Q?pfDnUYCI+8tikWihZmavlKa8OKxa2lRaHvkZbH0EEu7fR1b2yDlk//u1V2Tk?=
 =?us-ascii?Q?F8ztri0JRij2NC3ZBXf/VYZn1r8mS10XP7lKEH4BhtgnbXeWyukP79MZbvta?=
 =?us-ascii?Q?T66Ug1RSJoiX7T9CbEMX55oQYIaq9PMUt1VQM+DzMRYu/9mEg1zseziIa1W9?=
 =?us-ascii?Q?WpRHiHhrycLAZHUWPt3Io8VtZWGIP2x18PLsRpqeBkGA9EHO63AwcZC6spPG?=
 =?us-ascii?Q?SPb2uIVJMipHsB7xxFuD8HB2QKoUOGPaYrF573LuswIeZq7ZPr955xq4UJYC?=
 =?us-ascii?Q?MvKUIMD+zCWC5RS+Gm501BkcySwFkaFp0adQsEvu4fY88f4ctX9Hgr/iTdT2?=
 =?us-ascii?Q?OpDIq8E/+/1cghIhprv9ocQfzSxU1FLBD5pxGUnsk6YZH+7nJExoazI8Acis?=
 =?us-ascii?Q?CzY1K/5IzOqqZo10oX5MCNK5lIQAS9hYeue2iWU885gYAqp9ieOTBn4qoZSD?=
 =?us-ascii?Q?uUKlFQgGUaeUdfHGNkte8egEeZrkdDI=3D?=
X-Exchange-RoutingPolicyChecked:
	ayq60JxjDLTpB6acxxfJaKhvxhkcBF7y+9KqREcOejMiIFdzcW97t7UxSHw6nM7swzQsgsX2LqarLOmXtYB/lY9NsNwLGhh37OCMxlMHJ6ZjhrlJdzBaRWYXePErXPAeizaRaoOvvRtMtdRgZ3G3PCyO/ZV8pjbvm/AiHefJKcGTjXEx2Uo3+dkmdj2WgmQJV+hEhaklulX0INEwAzWf6s17YQnKTpYA+GJV4ylEZd23mGt4eLLIt57kovau4Ac3wp8a8zrUpIJpcBys4E8Zvqtvv7RV5WV0oI0c2wRgvZFOb2F9HtZjf5DsqBZ+De3GK34d0Jo4jXy6ZirS7qIVbQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5GAn5LNDPec5khehpJTw01M0ja9ozocnkQx6fFOXs7jAdKzlMisGnWaRdUrilM7bHuWmujzVCGfMoHQ2/pxuup6tyo+y8yD5VaxN8KAalzYOV1PYc8xJjB6iuqxbjAcWilP7eE+FsF1fKXhcYjaFyr8iwym/oklqDbYOqy2/Srq0uzgWRDgonFbBm4PkjCum51z/2ZhweBK54jh1Y3iHMgBoTYuHZXvFvMvrIw3XFvlxCl6Z/nIzHL82kkNckxDruS+MG9dThLZoF33ts34Xk9vENlB1tDa3nFcZYo2D7zGJNYxOC78u0CEUXqRSTsrFMUqwzj8dDKdxmhdK44szKKpbYFNjmzIq3nYtWAg5fQdn16rGRihHKoYcs3UVgbDBU7QUjxlBAWs1N8WY6eQnB7PSCxeIE4Rx+QPNr1zhVjX8AdIkT3LM38hXgJoS4Aqjv4PGeKGA2w2PxEUt7Gm7+HpBPBHcBHhOucxNXNhJVlex8F4zmLKLllpNUXDKcFmddAIcJjeLtitIbz7iqfLFaOgvv2kbaNjsSWyzxkiR3t6doU9jJPOwHkxcz1M6urGdtzheh8JlK9uKKmJWpCyrDy2MNgZ8+9rNyg808y8KyMs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59293e94-383e-4e2e-98b5-08ded8ee26c4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:50.9122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocldcY1R8WNJnSBqyAJzJoEP3TT6eoCqe2y+lB3iCPjPeO8Qxdt/DfP8wetZyyvA9/dIp5+bAaA1chmfsaBr5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMSBTYWx0ZWRfXwBBZeZ+E4Gnq
 F6f7Rhyu+is6jYLPBta92O1pIVf/lIxcUl7DYjCl2hkONrVV69m0sZvIRsQJ9HpmkNAHj3KW//A
 LmXMgmBm0eP2hlcxMqceiZLXS8e0JgYcmXc4kxEcws/0SSlNj1gV
X-Proofpoint-ORIG-GUID: D11DUtE6lBfocqVsdr-NqeJzUT9SUHHz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMSBTYWx0ZWRfX+t5C3AK4NGJ2
 +1B8+FYh0szPuM6ODlatNnHfheI/VhoUL54mlHOFVLZkH6/JzVqyWWhVQMzDNlMhGhzMJtpDWr5
 8jlTvGnDeixg/AS3krihhPKbKfJ6wAXoyp83gBay1bi6PbK4LiKpQGq6nXz+ANH3F9GyaCjgRtm
 4sYr/xTIXu8838uEFCe599YsFf2wOMxl6jlf2QjoQrjLvUDIQp37JEGniWGkCy9Hp7ltZ8k7QAs
 c/tTw2RmylDiamU0++QV5LHHfiQIj2Vt1HTU9rGjKZB+gCPFWa7pVUYiDSL/vcgOHBK7fmgn3Gn
 OHlzOZkhKbpFq5sbn2VzB09MIsAEL6BrVXO+8G4lkFdAksLlowl9JV4HO4EBP/mTESvcbGy7IMF
 XUMXIKNODWAw8u4rKat49d61AZYsaKUOWIqpTFbq5luV9/sA41VTiAuhw8u1e39d0iGi6nVgnVf
 HccW1LEll5KjG8xw/hg==
X-Proofpoint-GUID: D11DUtE6lBfocqVsdr-NqeJzUT9SUHHz
X-Authority-Analysis: v=2.4 cv=YOavDxGx c=1 sm=1 tr=0 ts=6a478f61 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=0Q2gd2vOsnR98QmcnEwA:9
 a=WmVTiCyuxqgg3mnwYu6p:22

Add support to submit a bio per-path. In addition, for failover, add
support to requeue a failed bio.

NVMe has almost like-for-like equivalents here:
    - nvme_available_path() -> mpath_available_path()
    - nvme_requeue_work() -> mpath_requeue_work()
    - nvme_ns_head_submit_bio() -> mpath_bdev_submit_bio()

For failover, a driver may want to re-submit a bio, so add support to
clone a bio prior to submission.

A bio which is submitted to a per-path device has flag REQ_MPATH set,
same as what is done for NVMe with REQ_NVME_MPATH.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  22 ++++++++
 lib/multipath.c           | 108 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 6c75654c12f8f..57d13eb1450cd 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -3,6 +3,7 @@
 #define _LIBMULTIPATH_H
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
@@ -29,8 +30,10 @@ struct mpath_device {
 };
 
 struct mpath_head_template {
+	bool (*available_path)(struct mpath_device *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
+	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
@@ -44,6 +47,14 @@ struct mpath_head {
 	refcount_t		refcount;
 
 	enum mpath_iopolicy_e	*iopolicy;
+
+	struct bio_list		requeue_list; /* list for requeing bio */
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work; /* work struct for requeue */
+
+	atomic_long_t		requeue_no_usable_path_cnt;
+	atomic_long_t		fail_no_avail_path_cnt;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -53,6 +64,13 @@ struct mpath_head {
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+#define REQ_MPATH		REQ_DRV
+
+static inline bool is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_MPATH;
+}
+
 static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
 {
 	return dev_get_drvdata(dev);
@@ -96,4 +114,8 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
+{
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 21f7ffdb22d60..81e737c1ce469 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -5,6 +5,7 @@
  */
 #include <linux/module.h>
 #include <linux/multipath.h>
+#include <trace/events/block.h>
 
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
 
@@ -43,7 +44,6 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
-
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -228,7 +228,6 @@ static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
 	return mpath_device;
 }
 
-__maybe_unused
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 {
 	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
@@ -243,6 +242,81 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 	}
 }
 
+static bool mpath_available_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device;
+
+	if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+		return false;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_head->mpdt->available_path(mpath_device))
+			return true;
+	}
+
+	return false;
+}
+
+static void mpath_bdev_submit_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct device *dev = mpath_head->parent;
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	/*
+	 * The mpath_device might be going away and the bio might be moved to a
+	 * different queue in failover, so we need to use the bio_split
+	 * pool from the original queue to allocate the bvecs from.
+	 */
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (likely(mpath_device)) {
+		if (mpath_head->mpdt->clone_bio) {
+			struct bio *orig = bio;
+
+			bio = mpath_head->mpdt->clone_bio(bio);
+			if (!bio) {
+				bio_io_error(orig);
+				goto out;
+			}
+		}
+
+		bio_set_dev(bio, mpath_device->disk->part0);
+		/*
+		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
+		 * enters submit_bio_noacct() for the per-path device. The EOD
+		 * check already passed on the multipath head.
+		 */
+		bio_set_flag(bio, BIO_REMAPPED);
+		bio->bi_opf |= REQ_MPATH;
+		trace_block_bio_remap(bio, disk_devt(mpath_device->disk),
+				      bio->bi_iter.bi_sector);
+		submit_bio_noacct(bio);
+	} else if (mpath_available_path(mpath_head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+
+		spin_lock_irq(&mpath_head->requeue_lock);
+		bio_list_add(&mpath_head->requeue_list, bio);
+		spin_unlock_irq(&mpath_head->requeue_lock);
+		atomic_long_inc(&mpath_head->requeue_no_usable_path_cnt);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+
+		bio_io_error(bio);
+		atomic_long_inc(&mpath_head->fail_no_avail_path_cnt);
+	}
+
+out:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -297,6 +371,7 @@ const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
+	.submit_bio	= mpath_bdev_submit_bio,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
@@ -314,11 +389,34 @@ static void multipath_partition_scan_work(struct work_struct *work)
 	mutex_unlock(&mpath_head->disk->open_mutex);
 }
 
+static void mpath_requeue_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+	    container_of(work, struct mpath_head, requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_head->requeue_lock);
+	next = bio_list_get(&mpath_head->requeue_list);
+	spin_unlock_irq(&mpath_head->requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		/*
+		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
+		 * to allow multipath to fail all I/O.
+		 */
+		mpath_schedule_requeue_work(mpath_head);
+
 		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
@@ -331,6 +429,8 @@ void mpath_put_disk(struct mpath_head *mpath_head)
 		return;
 
 	/* make sure all pending bios are cleaned up */
+	kblockd_schedule_work(&mpath_head->requeue_work);
+	flush_work(&mpath_head->requeue_work);
 	flush_work(&mpath_head->partition_scan_work);
 	put_disk(mpath_head->disk);
 }
@@ -387,6 +487,7 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 	mutex_unlock(&mpath_head->lock);
 
 	mpath_synchronize(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
@@ -398,6 +499,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 
 	INIT_WORK(&mpath_head->partition_scan_work,
 		multipath_partition_scan_work);
+	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
+	spin_lock_init(&mpath_head->requeue_lock);
+	bio_list_init(&mpath_head->requeue_list);
 
 	return init_srcu_struct(&mpath_head->srcu);
 }
-- 
2.43.7

