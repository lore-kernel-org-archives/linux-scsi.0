Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6829547DD71;
	Tue,  1 Sep 2026 10:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259584; cv=fail; b=qo61+eTmbS2Lk2DGAqUX6qfTdQlO8Gav84LTG65stbj/3NK81rbb2d8V9d4RbOOQL4mbBjUoL3bDpTiJEH5lgVZEhWJB8YlLuOhgWQswTV35NWs9j0Kj2aiVlvfEpOFK3N6U9kbtr7ideGf2b+cMk9nDmneXT5Xs7HlVj+uk154=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259584; c=relaxed/simple;
	bh=b5l4HgyMPJklc0mR4fvgO3vVspaet0zsUO7coT8TZsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mux+u4yyfLO4rKzxbAyuqcahb7U9BhIh6lwEb0UQtIbyz9+FeYUY3IYKoucJqOp4Hdl5e7mW2S8ml+Kts9UbeXbnrvNEAgwC1W9htlfXfSAJlZLNgfMMLeerBf/CtBgnNeNRHGbHMgE+HhTgwTDKuhdcAl2BCLbNFHCjyluLHe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bt51wNIb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cGDo6OjU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bt51wNIb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cGDo6OjU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBwvZ2296648;
	Tue, 1 Sep 2026 10:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7NK2lOISdE0e8zVgrSBxKnZ4wModahQ2UE5f143WLx0=; b=
	bt51wNIbUSSOqR17qriG4IykcWhyVnN04yn2QCElAfoTEa/Ydc8elGOlrj7LPLkp
	9Wa7RKd4YFx8Bk1krY0pHt/mcp1HLoFbxhFjhPJbkFduaX87lHY3wLef+I+WHXKc
	Asu71/ngVnU+0mkc+63SpTtUMB0k5VfafhYDNXK4HWDduiC+cNYxz7X9mQCdTVtC
	yNNpQDdFba5OEd1KhJ/TANoO8bNAzSuAWpRyOFVzWuUXlCV7WdxCXOc792dB2CTI
	gLy5ohfBvAuBPGVzUUzhd7yKZATjsOP6i1+KwhQqNgRLxD+8ctlethlUN/yNgDhU
	4+PwqDR5JXHUOdXrukAOLg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xvdap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjYA0036488;
	Tue, 1 Sep 2026 10:45:57 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqfk4k-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iHvATLjP6WpmJKiDVJPtQbY5uEpwfxJ3kZKgPJKWEqddeNCtdQaw1CgkYOrahlDsmnx9JSJlJkZ61uS59ApU/ElBD5g8EqpP7x+Ng4gaEoWSFfDMy6Fr06BMoX7iQn/3XMVmCfuUt3xdZAyL/pFqSAwWLrJFtTYNPgPfY8O6v4VYHOBuJ5vS9iAIZ+3K8H3x0kTyyrHJnhuY6ZXB3KhKKgeAmvHxqYBT6htblv6GPWrrHLmUczhcUs6jCI00Aj9jo0FKFy/xl6QwN9fZX3qyI5AxB5C5SVxCoqf9x/79H7BhuVqCjpXJwBv5XHt3yqO8wGPpg4oCgsotl77q4B8aZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NK2lOISdE0e8zVgrSBxKnZ4wModahQ2UE5f143WLx0=;
 b=qjMrSPJJX6KqcW0J027V2I7h7kGg+H8OeoRahIst0QHZVBhlGvfMqNLPBTYnwERbs5H2UVWV++LkdXC269SyzIpEe6j0SFlFHUBc/aVqLQoG5wNiz4G+rFd/sHrI6T2lxuo+xmGwIpi6bVuykMGymEro6eBCktmRtKHa+8illTea7+wqSauWfyxZA8AH1UxcXA5HVk/LTyZT9zPPj59/j9KPEfOqKt+ze6/eodLUCUPSy3HJT/wSHw8sTqa0F60btnypmjDwbAvScNkuDSNENiNoW/+Rr68CISdy7AQyhnjhKdgsjFwPfj2IJFjHwFpuoONZMdK+EEndSSdhOc2PZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NK2lOISdE0e8zVgrSBxKnZ4wModahQ2UE5f143WLx0=;
 b=cGDo6OjUbf9uk2geS9QVpgd/y6V7zbF8pbq/uZa1jQcd9BxSX3dId0vXtIORZHx92Ug54BrwTIrDQxTnxPpktAxYU0n8xBO62CfmXGLtGwp1wr3eXg9PCK961W8dHt+d6ccrnHUsai1XZyLuU3+z45Hxu0fHJKD8MY+W5/PB4/g=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:48 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 07/27] libmultipath: Add sysfs helpers
Date: Tue,  1 Sep 2026 10:45:06 +0000
Message-ID: <20260901104526.3850621-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0225.namprd03.prod.outlook.com
 (2603:10b6:610:e7::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: c208cf67-3bf4-4435-172b-08df08162f54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Nag8J5PMvyJUz8beFZh26oUuAaRrfojL6CZCzXZ1z7JhKm6oM5CcGR5j2e/1B5gBdjQgkY3ifygTcHqPql3nBi91Dfu9WFMgc91++54kWeznKnTAb+uhjmCBptW9eYw0B4jnGblyl7WSBkzpH++vr6qVcDWNOVu9saGhXBhYQsxsA0tPh4HwzzBjEHse1nv0FALERZXleWzu/2pvORwij5Mwh6SU3IEvJoFB0uMnUh14xUk0eNZnw5d4s0AL7Tb/doEaEhSxrYPsxFAMDEJoQVNsz5sOq8JFW5Ljt4gPev/Cl1ZTyZRurDGp7qPg6t6IjqEKSnHqDhGsNqXgweiecNN58WU3A51w0AKXNKH99VB8ZeQN/l82U6Zx7YijEBszRGgkcPHs/LUiCJTNgwYft4E0CHhBR1tYTJjma2kWHoMXQunTgu3gazmZsDGqyq5sGFgRGZ9p/lkb+1Z7IpIU+sBnE2bVTkvEHEjwfa4XfG9+riMBzxjBi4l1xti2v5/UMAsXWACN/YKMHQ6xR++1GwlSWiv7Er0/nq17Vff1HRfTCq/KY8IJbrjLBNJ8oRmDWDTelBU4hqJDAVvCFhFrwGovUkbp7kePSJoxbrw7i3gBMjQtMW2H3E9kjK0ipzbhFjXOPuBU/doVIZGpm9dVwmnpNxE5Eh1AcMOKXUdmQoI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rn+C7po5LfetLZiauDtsuZTL0RSXL2EhwMhxLXhcOZaruVK46cogJKoIkCWL?=
 =?us-ascii?Q?kaJAebwgJLvX+set6JpKuEMYnO/JtB/H1rWjA0kk36PJv7GQ9ywH7GRwrFgl?=
 =?us-ascii?Q?iec2OQ83yP1MNM/wzxGHU+LdbyWLR71dHGWG3L5gIsKZFZRvm8Jk2XT0ZyMP?=
 =?us-ascii?Q?xkcO1/vE1XBOXlTcoz21gNC6UjdHY89pFjqMhffyf1BUodpKU1/gmLPy368f?=
 =?us-ascii?Q?xHHn8bLaKTGccq6oBxRV2TA1VeksutCpiwmmagM+xomZErTxrHauDK83F+7+?=
 =?us-ascii?Q?Qq90LDC+RVUEkDEnXNCgCdOqgwEbRUi8A6TqmumD467kY7UQqad2RrY6zlMh?=
 =?us-ascii?Q?tiHAwj8gX6H4PLVqcf8eYdONCyqEQJaLVQa7pmUu7yhOOVxm4ApkKuEg+2gA?=
 =?us-ascii?Q?zp8VVkv9IX8bMmzsr3sBWRFj5SHJ5up8ihdNRkty73KkalvdhTnFN7iMAqKn?=
 =?us-ascii?Q?diMdsew8K+eOr6WeYAOmGG2bpxSieGeKUfROF0VlDRpXY20/+Fp3X7jmpIpJ?=
 =?us-ascii?Q?cEuKemfgLL3NlJ0P/2XpAXnIMALtCxZP4TgDl/kQZhcroktNGi2uxHQ8DPRz?=
 =?us-ascii?Q?rCDNY/++LrJeAzyodivM0winq2DuFqo8+nIKy+xItOQnMQW1vDm6OMkR0Gpm?=
 =?us-ascii?Q?vN60PVKCwFa4frRPNVcOKeCaqh+JiKXmqqpEToV7vr4ID2YBx9Vtnb/wA46J?=
 =?us-ascii?Q?7ovEquvHOcwzUplP2owget9BsrYc9tBhdKMmtofZhndhNk4TAQhbiPxoE6ZA?=
 =?us-ascii?Q?MEcW7Ua1cbDm3EIwczMwnML+D6fvm5+1CMGGQCaGTRCzSWmdh1iPLrpWiKf4?=
 =?us-ascii?Q?aO3oJchaAK3aR5yVTKy9VgbqrCPBbFT1WOZ9AoEczqS5LA7K3cYxAPZ0F7fF?=
 =?us-ascii?Q?eCsyB9kFzwZmoTBe+u9fVOtyn5H6faZl7GsJOOGG7w0TCIIAbmxLRcXHLCKa?=
 =?us-ascii?Q?VQbF0oIxUjj42FK0l25BmObPAUXb0CYFWAszDUhDNk1SnPZy5U0qPkUY+1Vz?=
 =?us-ascii?Q?Ixq953I+nD9wkcvs7XIWop2c3SMLabpJa/paFUs2SDNf02mj749Mi2gQ6uOO?=
 =?us-ascii?Q?NVX01mg1EpaWoAGZ5cA8PC0pt1UACOC0i6UVMfCvafO2ox7RmRf9gK8FdgO3?=
 =?us-ascii?Q?Z5VG2IXHiyIbvCfVEsuqeaHx1FxStheoe8YX44H/FO35xN114QDQ1Mbgf9pQ?=
 =?us-ascii?Q?AeEo0UH5j92e0m6bY4/Z87h8pn2MTePbScYoR1rNHhEjAeyJk+9WwL3hlGHp?=
 =?us-ascii?Q?qjMZFOj7chDDmUZrOOy4cPq/ca3BMrbTrInZF5EKQHQmsCX0Puy9enT+tHrH?=
 =?us-ascii?Q?C2g6fM1ytI1woW2tCN+a6+gGteQVQX6I75PuL6AHg2XkeKNemd7OOGNwyZPY?=
 =?us-ascii?Q?j8k9t8p39fUVBViWoe7MFFqyz1v68l9gViSrVNoR/NYVd0YXXrw9y3Z66kD2?=
 =?us-ascii?Q?fd0Xr8aAAaFAya+i9ufV4eOzs2GODdhkGAbKd0iW/2XRwrGhrEys3KZCvENR?=
 =?us-ascii?Q?AS2bW1W001U2cfJj7acjqHFkWJrqvKs7mhgsxuC9pf1PeIF8SRG6I8kZrbM8?=
 =?us-ascii?Q?+Ya1NAkf55CqZ6SHkCUsx3Gc/Gjk7h+QgoREyDzxgvOduyJZ+Pkp2XsdJraM?=
 =?us-ascii?Q?v/6RUiDTXDV1rQb4phMladF2XKH9cXkYl7RaaJzuf5fsA6es5Ty6mu2EKc4W?=
 =?us-ascii?Q?eafaFl9lQ3tUPANN2qQTA8JccL3ji+KVf780AZCcgFNXWhw/VYt+ee3VkSHC?=
 =?us-ascii?Q?ARGbwhnCVg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	fc3tCzq8ID6PXGZ/vP9ZCbpmVpZddGXAZjvehjQAS5SEZ/gUNhJkxNIDtfhvXMzWMw7946HBff5xcrXMrZtqDfEFL2TN10NkNvA7mLpN6XQ6nanaOcdGMl8QILGvl/+Ht7KCj1w76Q3E+3kR5x/yIr6DVFGqayuPE1zVEsoBsJwpKnglSALiCBDX4HxKdXJUyoxj0D+tgaDiV/04iNhgRQrohiUJy3RijnQ15iwT8f/2N3ELIj4iXL045vUO8aZXs7noc5187zKWd6xfzsuV1kW8mRQulpo8smDcyLgcHlhDte98SJa4qlY7OnvP0Lxez4dG2L+JprIjSFkzwNxIgg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/filII8MxGD3bzot3To1hXEEEgt1QDDDqZ/IZpbR+ktb0huyNorppSM5C9UPaas5G6MXek6oA7HXSxgDmjcHg+y0S0iJ3yQ2J93k6//kzni2rn13jgc8vlHzz6Enk/cWNOsGJ/tDLkOgWzUyNrUk7VaAurESz7NxgwnB/qvb44C1JADc6HIxWwr7CiqFc+zkfaQEmxijHB2Lc/Ph1PqJDBLZtMjbOLJeBj8DokLhxIojVjxW55EBzjqh0zdq7XmP+3Ul2sKmYuyd1JkqfaZsGbPpVhX826vShkgp5VWZ+D2fAwaEen0EdnVTCGA3YYMRBhnqhDLYK5kKHh0cU5fVPLiUXVT81BOFuTO04yQVBIVgOdgxXq8k9VpR3lWF8W1OwdxyblIEwsWXkDLJC5M1M74VgDKmCP/xV9wJf7q14uwBw4S6zJNELqQVLKmWGLPe5UV83WALJiW7MXQrckIpsbPbMd0D1uezUKXm5WTOAOWR4VT9d54oU74M+1UxsjYrvmzgj23fUz6clFC+jgLTY8zwZyXDRCyVrL6GG9EiGSTVWQjdY1e7i1GrHGUqrX5Nkp3LSy8/Dr99OClC8QKRnGFI+K2V/a4tblzdIK1cSpw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c208cf67-3bf4-4435-172b-08df08162f54
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:48.7571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxbpkBbd00aGjLWlvc3deUfiY9iee3CSCnqxLnYwyo+E/Ih8qHvuyfJQiF6QXxnU1VsJpDRm/1YlCSJvO6bf7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-ORIG-GUID: kpneRblYwjExh3ajy1OTrrhyn7W0Q6TU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX7V52eBPpxe3E
 HhuHPFNsx1JXWEbUl4F+nTWhbMwz7z5uDODbrPcHCgZf5eHQ/gw6/UoflMM1sUZpWbIlQgPvKyt
 aVJ2CxkeIebId8owfTekmdFDU1UpfP9v5643xm28xxlH/jx5grYn7SyQYlWh/mXaDhucFYn9xjK
 ECPwk2iC6Ev90kc3UVaeaD+46vFe7rWSnuFNYgoVAWPnfRuV2a4z/xNOAinTHVmrGVgb4ZvsElM
 9PMie8diMx/gOLJ3L7GGQOno3Xjv6fnv3PiPzxC1HOaewy2fnGsI1gsrtR+YmM7x41AD4Fti5v8
 LK+Y0AqY65m+2moGrkBeajyRwOCzfWtfrS/CX3JoeQw6+SnxB/7BWRqFsry3RJF21wwV0+vx2kT
 sKurPPMxNjZgAMzPjOiEu1Gs7cPr1S4nvoaci3IHVZTjXy5EVTRRioNM4dPWGcJShU3KnFUJ/a1
 8p0tZO+n7JewX/drXmv0NNhoAF25pET6KtdgSfVE=
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a96ace6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=JWw5DRbbQmmJTouRsXkA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: kpneRblYwjExh3ajy1OTrrhyn7W0Q6TU
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX9TOXFxfN0kPd
 hUhvZih9TSEc+33b2l7FxN1d2AwYHwh8pWq170fsk5jnEyR74y5SzvAI6pGSvPBn2nXDCjNdUvV
 nRMt8ZdNMmc/psmvY33CwAo/Vaip7twg/ie6MoTDUDNtPxQllfag

From: John Garry <john.garry@linux.dev>

Add helpers for driver sysfs code for the following functionality:
- get/set iopolicy with mpath_iopolicy_store() and mpath_iopolicy_show()
- show device path per NUMA node
- "multipath" attribute group, equivalent to nvme_ns_mpath_attr_group
- device groups attribute array, similar to nvme_ns_attr_groups but not
  containing NVMe members.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  5 +++
 lib/multipath.c           | 94 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 66b6ad9c2219a..7a3708ff37254 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,6 +7,8 @@
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
+extern const struct attribute_group mpath_attr_group;
+extern const struct attribute_group *mpath_device_groups[];
 
 enum mpath_iopolicy_e {
 	MPATH_IOPOLICY_NUMA,
@@ -118,6 +120,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
 bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device, char *buf);
+ssize_t mpath_iopolicy_show(enum mpath_iopolicy_e *iopolicy, char *buf);
+bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *buf);
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 			char *buf);
 ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
diff --git a/lib/multipath.c b/lib/multipath.c
index fada92bf9754c..58eb9be5bebbe 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -620,6 +620,100 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static bool multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return is_mpath_disk(disk);
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
+
+const struct attribute_group mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(multipath_sysfs),
+};
+EXPORT_SYMBOL_GPL(mpath_attr_group);
+
+const struct attribute_group *mpath_device_groups[] = {
+	&mpath_attr_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(mpath_device_groups);
+
+ssize_t mpath_iopolicy_show(enum mpath_iopolicy_e *iopolicy, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+		mpath_iopolicy_names[READ_ONCE(*iopolicy)]);
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_show);
+
+static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
+		int new)
+{
+	int old = READ_ONCE(*iopolicy);
+
+	if (old == new)
+		return;
+
+	WRITE_ONCE(*iopolicy, new);
+
+	pr_info("iopolicy changed from %s to %s\n",
+		mpath_iopolicy_names[old],
+		mpath_iopolicy_names[new]);
+}
+
+bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *buf)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
+		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
+			mpath_iopolicy_update(iopolicy, i);
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_store);
+
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int node, srcu_idx;
+	nodemask_t numa_nodes;
+	struct mpath_device *current_mpath_dev;
+
+	if (mpath_read_iopolicy(mpath_head) != MPATH_IOPOLICY_NUMA)
+		return 0;
+
+	nodes_clear(numa_nodes);
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	for_each_node(node) {
+		current_mpath_dev =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+		if (current_mpath_dev == mpath_device)
+			node_set(node, numa_nodes);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&numa_nodes));
+}
+EXPORT_SYMBOL_GPL(mpath_numa_nodes_show);
+
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 					char *buf)
 {
-- 
2.43.7

