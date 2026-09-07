Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504C349F102;
	Mon,  7 Sep 2026 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778364; cv=fail; b=gNuFfL2fB7Quz9h7i0QZJexstXwjKhS75yBtDIkM/0ptl7P9F2a6vFi75GlO2ii/gBwb81GXcnuhIRMQyU95f+Sk7SSfM4YbVl5GXjTDVtAUz/kYQYjMsnkH50xXv3j8oFiO5pgcb88k6P89b+fqhQkSwtbZEe9S7imloX1JrlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778364; c=relaxed/simple;
	bh=avdacaS6XzmqXRJM3Sd6/Jiekpzj9H4UVti6oU4GBh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WSaWZXDe1jrUPyagTMhmvELbfomeoTQNSEa6NrOnrT3BC8iN3PzYr8r2QyAyBmvHWLBOuaozxZaKYWESLlkgz4DP5ILvc+ph8C3kX0jJTomQgrrX2nUh5LRTfxRR09DMXIzYxf9ueG35ewoOix8hAT6OO1dJTkKkDhCZ6R602Fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZNq6s1w+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bdp7yga6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZNq6s1w+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bdp7yga6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6873vFRE1033787;
	Mon, 7 Sep 2026 10:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EHWLtWnlVItwvNDVIU/wu34YTqCvVj70IP/OcNTUg4A=; b=
	ZNq6s1w+ze9+uN8WC08zqLDB3RoaJ/FCmhCSMjnKqhAlu+z1E1AbJ+HVW7vWZdh/
	Jss4QIC+wHPk5ZZbOVr7XQm+27+bkoPMON6FeDb8GXp3ictZRv9bxiGeG99Bl5Vx
	OyGYbqbpiHmi9Z5Nqs/J0HErHeqxEv9bBO90Sl5i5eIdmjWrWBOXH1UaMHX9Hwd7
	gxKbGrMH09rW0jKnv8YJlYW6k7JB0NRqkPFB2o6yjO5y4tdHYZ/0+y4DQL2R9XiY
	AHdinPwgwSqVqVgCbT8hCSnVO/e0syI1Knf4yv7QjtuNupWnoHZmzODtaDZ6EKYp
	VbbIXiPOTOjSqECb1JCN2A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbd3st0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:52:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687Apnin012930;
	Mon, 7 Sep 2026 10:52:06 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh7atpvuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:52:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtHncWBwY5z1+x0OMoSh21Tqkb8K3HBURBrtTTiWuBEzqq4pzb4se/r+unvt56eWAIX3/EwTNQvBvD0HUCgJoQUbmQepJVcor7FixdYAZ+sNcMNrMXi2qqUr9uC3EYXyPBj4mUWtSUN1tV03V2PpeIFZIl7Q0n47FTshc87KcBR7n1OyE0B0nT6doK0MpNIxdqHajlLeNboAxanujtQgnxLHGZwIx2BBHw/KopaiCJaFdhG2KCP5/ddKCTVnN5xLT49FRhtz3ioUkxu1AOm3sUGB5Zxzd5EP+JkfWn+qlfwxIDLB6gln0dakidktb7Ar/Evw1HsMlpJkCyHarJs2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHWLtWnlVItwvNDVIU/wu34YTqCvVj70IP/OcNTUg4A=;
 b=xNv6Hf0K1I1igvVGJF9GvjNxb55S50ay8fwa7Z1viPggLi6jYsm+RyBkinQABtwL1ITnSgPNyC9Z4aONbbPTavojk+00wjSxWA5PZOmpqIbt2Nw+nBC6Ix2N6GMWtVVcJW4BYRCUYjH3yF3fMrlJWp8Wf6rtpcfyUROhjhfeFsXupdaI1Uk1YjQsRZq5jOG6AelmbcPQXJkaeOOJatVoRXsnQhKN/aj3c8gRM6KBMQncDzIy0kYKu31dTg0uXEdO3r/+EHKFqpHfLaOoPLj53syrgJVVr92/WD10llVOfV+Rrnn5TzUwvp4o6Z4OIg4ioD0qSDRPuAp5xRFaoqaHmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHWLtWnlVItwvNDVIU/wu34YTqCvVj70IP/OcNTUg4A=;
 b=bdp7yga6yQaiSVVi6c+Y1tp7/41z3NH4DjuJRv3PyrxeUp8y00jXk/oi3Z5XqLkbhLd+2NZk/k4/3RtF4L3ewDX1nLI8KFjX9rA2HVhoNVgrTrdoTCJ6ndyOK9268GvkP9lbsY12OjNBr0HysfNTXt/krcH4+QV8cGsTNJZxClk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:40 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 03/27] libmultipath: Add path selection support
Date: Mon,  7 Sep 2026 10:49:57 +0000
Message-ID: <20260907105021.1763236-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:510:e::24) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: ec2aed83-8bd1-4732-8fae-08df0ccddb80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|6133799003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jSXYtKiaGorbID85WMwK2eqh58BmY8suooidRHn3OsaGyGA3JXxOLnSqizNKMJ9gAwro1BVn916IgmDQmbBmyC+fLYoHKhhDmOP7cXx4lgngcdtFjE5i+byJTk6sYWMHlVbKOsrtGiDkHv+qPmh752HO7ZIBXnRmrlQPo5A1RNs5XlGrqYP0oPSLygV0HkeWi0XOTsdFwLA7niBJGCQxo3+8uQ7RSbjAY7ms8tCfSEZrFk8grty1AqQtZORQK5sC3DY8RTTsGekzIBqKXKCpKOHBA1dZsmyAujF3w6+N3j1tX5jxdvVxo+MgUsDra3Oi4WTf3q386MA0W+n7SeUN+3+KiPs38LKALIBUpjG4u1f8yXM+cnq7WmuVWakvTGeRyqlxbCJr9Hrv4rK8cRCjU7ICfh/feWjKEYh6uMjXBjtE59YFYVLgFZYaYMZxc+fCZ+YdO1nQpDzIIL6Sne9/0tH6DeIE2xPeuZF4RPrO72VTod3m7YoeuEM3oO8I4inkNwXVzEK54c/mOwWqb85i+XEsMsmZ/6IeOE23xkXUwwCz93MPN5EgygftZRvdacHAVzt9/aUe7z0EE0vLo+7Oeg1uYSTgWBW4jZKQtF9DcMVnAyYepAQXa4+kE0QIzg5UajeJYmtruGqlS1d+mxR8D8EE1DtLwuNNCbAT/ul6Kuw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?USzi8XSNLtJfOxHTTRcYM6FtsNRwzPqt86rhrBrHrWCMXd5VV/hx14AOXl+f?=
 =?us-ascii?Q?7gvmVxirDUN32ICXOhChWDnwS7qjQ4emWLqSctcJ6UmY4O1jeQRBoYUAvFOA?=
 =?us-ascii?Q?e5PFUpGPIle4K27Zv7hJ2FXlefyTxS61/rk759CrJE1xGteQjrc9JQP+vFoW?=
 =?us-ascii?Q?Y9V/EAYHx6bqN5+Bd5pvB3dg0fru2SMy78MH0Cvx6oFW/DM5ZzB892tP+kb2?=
 =?us-ascii?Q?KF5DVYgfU1xPB5Tr5pKFc107PFeXB1JBOsl20q8EFMjJSr5oQghzmjtAmjIh?=
 =?us-ascii?Q?FY36EAfqNzKLx5v3LjQY925Z0GgH+g4NPSbTcERV3ST3/t0Vde0f5jtMa9o0?=
 =?us-ascii?Q?ZqdGCXlm3+tmArqCGHvtMp8ku8mxrALuRiVP+HDhjW4xg0QoJhmTXu4nSMxU?=
 =?us-ascii?Q?AhmX7jM4RmXvkU/SzQvH9B0o5RBLy91+zafozmKrIhDDmO3VI4sW6T3QqFdk?=
 =?us-ascii?Q?y2NaPg9Onn8wAE2Y2BBC8hYWmX0x3ToN1xrFADq6ykAKGxoFi6AMr8jAvrfR?=
 =?us-ascii?Q?uMrt5eJU8i2saHQ3Xr2YmqitQL6Q2RaRcV3AxJnNVrs2YRwMFtEFq++qpL6Y?=
 =?us-ascii?Q?g9/fYZ6dwdHUjrF7U5JrKhixIHr9bUBDxpjWjT5wz/teDMz7VyMleTkv7iQu?=
 =?us-ascii?Q?+sZSvKqUhxms3SaS5l1OVnDCHkZEywi9smRMYxxi2/D78Nl7/edviD5rA5mf?=
 =?us-ascii?Q?4TN+1DxZfQVvRVKFKjp4Oppv67RIbFMChhONnEWEe7nPAAgplLRY0ReZGLFG?=
 =?us-ascii?Q?WQmBzLGPOk2VOSpCx8+EWORH0q92vPL+aRW53p7iH8q70Tpsg25Svou53OlQ?=
 =?us-ascii?Q?1F0BZLoyZtOt6b/7s6wGJsJZECd6T81IFiBZHBqiDemZx3jom7xU/yT5Ig9b?=
 =?us-ascii?Q?HiI3gOyOCCSD10s35rWsat9xk2jpTTPnWegg0ZgkxjErRjdwkStHGmN6RrLC?=
 =?us-ascii?Q?zjQJmCAcgxVx7++xXM1HizE+M7JnYBiREId8QG0Oio0P+fu8oXitT+rwMo+E?=
 =?us-ascii?Q?aOdA3UfRam7s7Vqw5Quqly7u4vAmDgN8F0lisYqIf7iHrHZ4tX+gCJyMMQBA?=
 =?us-ascii?Q?vPxBqf820GeZZhB0MorpxQIEcbM755OF754vkTKMo9H5HGJ7sK0JpI0zovqU?=
 =?us-ascii?Q?2zvKG8u1mqHfIcHvBtKMpkZKiJdetYEfsv7VA7Wy0HImnKgBMvarxIW62VJf?=
 =?us-ascii?Q?QyXdnbi3zuWZBotM/ox+GAHT7SxZ5avRWM/SLCh6VAfqnaVm2l+aMXGBqRZX?=
 =?us-ascii?Q?rK2AV3j8wbQv+YT0bW0k20OUB5RiBcWZI4W/vN8IyV+vES47AfZgRtLjwoXa?=
 =?us-ascii?Q?ChqQ0T6lzwAhoc9iA7FDRorX1jZtZv2AprC7x4HvHEH9kId9x1EvUrIxY63N?=
 =?us-ascii?Q?cP+JSKHnE31ZQ3KGq/fT/175MuaquHiO03v3gHm/tR1cGl8gMSvK2QOh1HiW?=
 =?us-ascii?Q?7Gax72jplXy3umrUTRNGXA1or82iEw+turq3G9x9URL6/afcwYzLr2dR69zx?=
 =?us-ascii?Q?2ZA/6yGlMbXgZG2eXEMgjRnGiBdDCZNU7vdmM6INBfipa9YFXF3xLQP1St6N?=
 =?us-ascii?Q?MtLZL27lUmMIv/UK/IUcHzeIXqctS1mzJJk3pMrOy0bv7oUL69L56FjVBENF?=
 =?us-ascii?Q?t4uEajvLSeGXkTvK44IFec6clPoA2BKWjBe9GjzdqzDjTc2OF5lma15d6JC4?=
 =?us-ascii?Q?xwFshYFn/IXH5XlI9lNAZC6sGsaEZriPeOhuMC8bdbZNlPEk9GZ5oH1Ycbrs?=
 =?us-ascii?Q?bumAMhatfI6oXB3wGRueUiuLLkBFDFs=3D?=
X-Exchange-RoutingPolicyChecked:
	b/GCF6phi+h9VqTSAAp5tj18pNS90I1ly0XBMIHTOKZDUQcZh9FGDEfs5fSw2QE+jRJytGy1jZsq3u8msQB37d6u/fSghwnCpnT479pXOEYJjqzq+0YD0A06xaCxdKiSzthUed4TnrBi/fQA36zDbULYn3bp+wuHi7ut2ZOasTBliw/bC/+EED3ds5XJ45NrptKVJkuj5qj20/z+3wXg7Krd7SyqOEEUtgmLNejewOpyb0ZkRhVtDqMJ6/KbVaZlKfHGDScTRaAvJOlJrDngGhg5DDdYJfp+8+v3ZbxpW54YX5L7TojIM9t257FDJ3z9IKpZD0sAy7AjM7zPyJJZ4A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S3rDqhkEJHWWKkCsrQLO7Xy/Z7q8ZsjWWwMZQiWBxDt69udTf4LE48XWU+iUnYqLPpvlVt3GMeax8omZ++kxmTn2hFhQUu/68sFV+62PlsTeiL4pJ76tXE4F44dXPgZ20x4DXNmj6apPBRCEPubGkOsjRhO9jzI0owGt2SKWYQ0nAcrIzBKyXRie/r+ho4QpkaGtXyz3nvuu9KiPiPEpxsBVZ7d568ypj+sLUnXQpC8b6o8VtxtYuChMuX5DoD962NMfXnuRfeNxFokTAZk6OoOLqkLCFoeESaT/qhRviuphUQtyE8dQpvq4EVi0hJIDJArJKAgtD6gS8GVyXujXOZXr7M4la1qOemsil0wOfHQRVYMURP3HqEcgNAxvd1WWPHtqucZOLgziM8c1dIeT7MxCy49VB+z9+LpjCH36FmgMfmaDErjBUYOuH8WoA2XBQYKoVN56w1ivaDUCpuNRdaUpqJrPSfFH9lupj6/wXs+YO6hMGjGoAV82tHo8P3Bn7lBXPApRAebWtXG8FDvRk2FJC/hH8sWgKl8a6UAmCkiLdRnoUelLFmAIdJ1jxQM77dqdWhD5F+30sBBEVfXUG402QP/yE5od+g8oWfPdT/I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2aed83-8bd1-4732-8fae-08df0ccddb80
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:40.2210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WX1fTy57rRcMm/hsoXTwustSbApX6JBa+kvZtBUwSqARvP+jGCx3UnqD7+Vyucm1ark9n97EUOGLgzLmLZk8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=EuDiaycA c=1 sm=1 tr=0 ts=6a9e9757 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=Lb5UtHSxAhypNmDEWQsA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX4qVHnMoRPXhe
 iG8n+hl3wYtHzPOt5UNhvbZgan37J8iN0BNoOQZck3SM7VoU2CF6YMREaIj56iwUgB2tqdKmFvg
 oJyPh5bHFwweipDQPUNVsHRbwok2jMGbd6BrztRv8wF+k784dxcl
X-Proofpoint-GUID: Hvb9CfWemuYOoadXCwlFnf_Xg4966XRZ
X-Proofpoint-ORIG-GUID: Hvb9CfWemuYOoadXCwlFnf_Xg4966XRZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX3zEGKlWdBhJw
 1RKdZlqsKaFRtA8sRu+zkTe+U8zNq5g1To2yTKcdyTL4w9zwXenCLRSHcMPlUkAt1an+OZpGzMm
 1VM0dapfGWF3htpK3uQck9IwLxmTp3kq1e0mn5HGxae9L+Ly9Gd9zHdlMJs0veyOmMj7GP4/JCv
 r0QeB5YDJCk293NFUF0jdfEyauuO6f1kWCG8UhaTtBSaR6aW06iZt25/3xU0YksR4WQ/BPoMDwi
 INJrFJLxDtn8uSOLPgC/a56oLjzoQAJGtllSWHOSOk1VDdMg+HwRV314RUJK2qvCSx8HBXt+GkG
 a0dp2ioIkmuyQ9nZ6acofhnZvvNGrQxU/yCCVpz+A6VwMNDZu/51CivihNiFGPCpPVnhm72f7Iy
 VhAzO+MxkGwc9gtPev/Orgxl8T7lOKLprHZtxvnTowaCOn0wli9HIQFj/Cgap2RmPEDkJ/gfiZg
 qeLuOIH9IyPXrdNFtcbxJ0tezWCjimL5RRu/Kz24=

From: John Garry <john.garry@linux.dev>

Add code for path selection.

NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
so that SCSI ALUA can be used. Callbacks .is_disabled and .is_optimized
are added to get the path access state.

Path selection modes round-robin, NUMA, and queue-depth are added, same
as NVMe supports.

NVMe has almost like-for-like equivalents here:
- __mpath_find_path() -> __nvme_find_path()
- mpath_find_path() -> nvme_find_path()

and similar for all introduced callee functions.

Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
setting default iopolicy.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  33 +++++
 lib/multipath.c           | 251 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 284 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index ca6e02505be43..9bbab0aa8961a 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,13 +7,31 @@
 
 extern const struct block_device_operations mpath_ops;
 
+enum mpath_iopolicy_e {
+	MPATH_IOPOLICY_NUMA,
+	MPATH_IOPOLICY_RR,
+	MPATH_IOPOLICY_QD,
+};
+
+enum mpath_access_state {
+	MPATH_STATE_OPTIMIZED,
+	MPATH_STATE_NONOPTIMIZED,
+	MPATH_STATE_OTHER
+};
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	int			numa_node;
+	atomic_t		*nr_active;
+	enum mpath_access_state access_state;
 };
 
 struct mpath_head_template {
+	bool (*is_disabled)(struct mpath_device *);
+	bool (*is_optimized)(struct mpath_device *);
+	const struct attribute_group **device_groups;
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
@@ -25,6 +43,7 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	enum mpath_iopolicy_e	*iopolicy;
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -44,6 +63,14 @@ static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
 	return mpath_bd_device_to_head(disk_to_dev(disk));
 }
 
+static inline enum mpath_iopolicy_e mpath_read_iopolicy(
+			struct mpath_head *mpath_head)
+{
+	return READ_ONCE(*mpath_head->iopolicy);
+}
+void mpath_synchronize(struct mpath_head *mpath_head);
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
+int mpath_get_iopolicy(char *buf, int iopolicy);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
@@ -63,4 +90,10 @@ static inline bool is_mpath_disk(struct gendisk *disk)
 	return false;
 	#endif
 }
+
+static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
+{
+	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
+}
+
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 574868ce53381..3541357d07f8d 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -7,8 +7,245 @@
 #include <linux/multipath.h>
 #include <linux/wait_bit.h>
 
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
+
 static struct workqueue_struct *mpath_wq;
 
+static const char * const mpath_iopolicy_names[] = {
+	[MPATH_IOPOLICY_NUMA]	= "numa",
+	[MPATH_IOPOLICY_RR]	= "round-robin",
+	[MPATH_IOPOLICY_QD]	= "queue-depth",
+};
+
+static int mpath_iopolicy_parse(const char *str)
+{
+	return __sysfs_match_string(mpath_iopolicy_names,
+		ARRAY_SIZE(mpath_iopolicy_names), str);
+}
+
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy)
+{
+	int policy;
+
+	if (!str)
+		return -EINVAL;
+	policy = mpath_iopolicy_parse(str);
+	if (policy < 0)
+		return policy;
+	WRITE_ONCE(*iopolicy, policy);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_set_iopolicy);
+
+int mpath_get_iopolicy(char *buf, int iopolicy)
+{
+	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
+}
+EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
+
+
+void mpath_synchronize(struct mpath_head *mpath_head)
+{
+	synchronize_srcu(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_synchronize);
+
+static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_disabled(mpath_device);
+}
+
+static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
+					int node)
+{
+	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
+	struct mpath_device *found = NULL, *fallback = NULL, *mpath_device;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+		srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		if (mpath_device->numa_node != NUMA_NO_NODE &&
+		    (mpath_read_iopolicy(mpath_head) ==
+			MPATH_IOPOLICY_NUMA))
+			distance = node_distance(node,
+					mpath_device->numa_node);
+		else
+			distance = LOCAL_DISTANCE;
+
+		switch(mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+		    if (distance < found_distance) {
+			    found_distance = distance;
+			    found = mpath_device;
+		    }
+		    break;
+		case MPATH_STATE_NONOPTIMIZED:
+		    if (distance < fallback_distance) {
+			    fallback_distance = distance;
+			    fallback = mpath_device;
+		    }
+		    break;
+		default:
+		    break;
+		}
+	}
+
+	if (!found)
+		found = fallback;
+
+	if (found)
+		rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_next_dev(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_dev)
+{
+	mpath_dev = list_next_or_null_rcu(&mpath_head->dev_list,
+			&mpath_dev->siblings, struct mpath_device,
+			siblings);
+
+	if (mpath_dev)
+		return mpath_dev;
+	return list_first_or_null_rcu(&mpath_head->dev_list,
+				struct mpath_device, siblings);
+}
+
+static struct mpath_device *mpath_round_robin_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device, *found = NULL;
+	int node = numa_node_id();
+	enum mpath_access_state access_state_old;
+	struct mpath_device *old =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+
+	if (unlikely(!old))
+		return __mpath_find_path(mpath_head, node);
+
+	if (list_is_singular(&mpath_head->dev_list)) {
+		if (mpath_path_is_disabled(mpath_head, old))
+			return NULL;
+		return old;
+	}
+
+	for (mpath_device = mpath_next_dev(mpath_head, old);
+	    mpath_device && mpath_device != old;
+	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
+			found = mpath_device;
+			goto out;
+		}
+		if (mpath_device->access_state == MPATH_STATE_NONOPTIMIZED)
+			found = mpath_device;
+	}
+
+	/*
+	 * The loop above skips the current path for round-robin semantics.
+	 * Fall back to the current path if either:
+	 *  - no other optimized path found and current is optimized,
+	 *  - no other usable path found and current is usable.
+	 */
+	access_state_old = old->access_state;
+	if (!mpath_path_is_disabled(mpath_head, old) &&
+	    (access_state_old == MPATH_STATE_OPTIMIZED ||
+	    (!found && access_state_old == MPATH_STATE_NONOPTIMIZED)))
+		return old;
+
+	if (!found)
+		return NULL;
+out:
+	rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_queue_depth_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *best_opt = NULL, *mpath_device;
+	struct mpath_device *best_nonopt = NULL;
+	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
+	unsigned int depth;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		depth = atomic_read(mpath_device->nr_active);
+
+		switch (mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+			if (depth < min_depth_opt) {
+				min_depth_opt = depth;
+				best_opt = mpath_device;
+			}
+			break;
+		case MPATH_STATE_NONOPTIMIZED:
+			if (depth < min_depth_nonopt) {
+				min_depth_nonopt = depth;
+				best_nonopt = mpath_device;
+			}
+			break;
+		default:
+			break;
+		}
+
+		if (min_depth_opt == 0)
+			return best_opt;
+	}
+
+	return best_opt ? best_opt : best_nonopt;
+}
+
+static inline bool mpath_path_is_optimized(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_optimized(mpath_device);
+}
+
+static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
+{
+	int node = numa_node_id();
+	struct mpath_device *mpath_device;
+
+	mpath_device = srcu_dereference(mpath_head->current_path[node],
+					&mpath_head->srcu);
+	if (unlikely(!mpath_device))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(mpath_path_is_disabled(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	return mpath_device;
+}
+
+__maybe_unused
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
+{
+	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
+
+	switch (iopolicy) {
+	case MPATH_IOPOLICY_QD:
+		return mpath_queue_depth_path(mpath_head);
+	case MPATH_IOPOLICY_RR:
+		return mpath_round_robin_path(mpath_head);
+	default:
+		return mpath_numa_path(mpath_head);
+	}
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -76,6 +313,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
 }
@@ -133,6 +371,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		}
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
+
+	mutex_lock(&mpath_head->lock);
+	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
+		int node, srcu_idx;
+
+		srcu_idx = srcu_read_lock(&mpath_head->srcu);
+		for_each_online_node(node)
+			__mpath_find_path(mpath_head, node);
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	}
+	mutex_unlock(&mpath_head->lock);
+
+	mpath_synchronize(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
-- 
2.43.7

