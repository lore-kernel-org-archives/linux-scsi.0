Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7B2431E5F;
	Thu, 23 Jul 2026 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799488; cv=fail; b=oZsDhLB52wVFfFyIhOlN60mJZE51eIzVXl4aA3+jc985A9qhDfZLKssvR5NUxLQDuWVjs8gvJw5UAY/nN0J1azhahtmSw/IeNli4C3LAuNcpqFKGu9wwzG9xv2VSwHCQ5xwqX4owSf7+YSr9gg6rhjBmFaSoj7icRNdJygrOLhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799488; c=relaxed/simple;
	bh=p8i9+n6Dg4vw6qRWknSxJ3wy/2ufuXSqmajsVKveH28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tiIz0sgR0aJ+x3Jc4EXSpSZUp3J1tbJY2jHMs9HUsXes8AKmG+6FkoBk47v553pDketjhZNqnxV+uQ5Z4MB8prvEE4lsHXiXiy4Zg7b2vOMAvrSNoHmw0s7MwAFMMBu0H2aFE3VjHQSU13TVINjrOugp5nQqGVWnnWMhcjnFXcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gte0SoLg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gjk+mXZW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gte0SoLg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gjk+mXZW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N3rdkP106353;
	Thu, 23 Jul 2026 09:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JxzGoeMZry833A8V10PPpJZfNmslGlF8iFGutw61ros=; b=
	gte0SoLgyPO7/cVHjhTYC5/bR9hahuQaHAlcH9qqE+3F8NQmQX73oBMwAfswFulv
	fEemhijcQ12KJ36m7VhPlrnE9WR8B33kKxV4sSBjvF9MQnY4Zkd6uC6yrUbLoxSu
	IzbtFjpV/TGSpkztC21773fcUUH0p9ZxsWJ5MyKPkqEee9S7tS+GNXzWjN8qh4NJ
	jylh4SCvGhWcYjU/QBzormuQyD6A+Eam+Gr/N2P6ANgu1qb5q0tlCjFRBh7mQAQH
	avG7sx+zepYIJqwlFUXCMiNqe5AsbRrNTdvw/uqeGYDFWXdh9P7+/Qz91fuZ+del
	rTQNrV7ZTpN/c8BGhLZ8mg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kpxn2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X9QH021137;
	Thu, 23 Jul 2026 09:37:27 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010049.outbound.protection.outlook.com [52.101.193.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y4cn-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SRulMaDaUQOTE3Sp6teilFD7RrxDjCmmkDHtIqsrF/eVqfIlXsA15lN8BUjxvx6MgqNDajhPgTwQX6wbKHfF2mWEM/CUqVc35o3Wc1IpZ6W+wkp0UVtvL+gRoFfTTiSM6wEm3hTLekI5xG7lSedsq8kl4vJeGnYUFBuHaZ7HSt67dOEG7xbW9VsVw40AJR7U4bvyIbMWGQl99hCupICdPhtZQDKUX0KYX7PJyVpz5js6+3PJEr0BufT/M4GDAI+wNrjZ7U9HYAvkKNuF4j0Qwz2nvuRmfnsLKPxLwmLagU5aF14Op5u9n+kzJ3tIX55xC+M2klXDGtYiuLELXTt9Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxzGoeMZry833A8V10PPpJZfNmslGlF8iFGutw61ros=;
 b=kMA3vtk2Jvdi/S+SXdyRE8VOr5jQU0Js3d18iKMDdYUqoYHNfvP5ULtXB2ZsH/8dIVqZxjuDtC06AxoBvp1sXBCAiSBe+IzFcVRBwZDWzw+Y36d/jj70KPzTj14bZJFq8CcxmQoSnkCKeO0qRAe1kqJwV+S5SoYWOxCiNKuFl4y0INa+Btq+Q0lxOpPjokzboqs4uA7+WawzwNEC9ekpjbdcAciX4lDboebbl5XlFXuphvhSUv9R/Fc763kNbTlEnC40VDTJEJ5TZOtTuubzx/9daGEg5NiCYEEw8rCpFVZ+Ei4OKIOBvIApz+wQC1VrN04aAob5XmLbYEdxILNv5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxzGoeMZry833A8V10PPpJZfNmslGlF8iFGutw61ros=;
 b=Gjk+mXZWKa8sNZybEc/AoJAiNwcWN/qPj2yY7UdozUWrqZbp17iubjoBGUcpCN2ixIZTCeGddvqFOghIQ9kF/Qirc7CbJQTTTkwSsL8GhuC9EfszKkzp+XLVv27TsQhj8U/S8XYSTr7tX5WSLHGFVXp0XYsgvWbhiyaXTM38mkQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:22 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 22/28] scsi-multipath: add delayed disk removal support
Date: Thu, 23 Jul 2026 09:36:20 +0000
Message-ID: <20260723093627.2327456-23-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:610:77::27) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d976371-7027-468a-17e1-08dee89dff0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	f3SeQFulgfKlEJBpCyRM9HhXVXrzm4MiDlaXVsbYaVS+hNdU9Q5kXwhPUQ6Q7fbRoTYCCIzBYzAvFSLqIlG2XdyxW6ykU/+uxaybFex1R1itzXFF5caoYQt70LCBhvXDR/wZusfwNv/mwHp691TPJYFQjiz6+myprtvgjLUQfk48p0THP7PyWpWe8TMLzyGF49G5C0x+iHqnpVr/oMAX7eblEKoEHQ9PNe8HhVq16RfynlACLfrwsvRmtouYak1j39PFzAfJq0Qu1yn2FkdnE3nPAere/xbaaPGOYw3ZeyIHKHOxk+Gm8+VJ4dk6yxQU1+4kiNor2ow1l2/NfXA+SWJC2dbZ3FojfNNuZzQnnPuJA/kImeUE9Jfm564ZV7TVXO+lnMgXC86a+SRhrfBgfjx59rC0bor+d0bu4BhIQLtG1RH/36vnDQVePzxSI0lTztdEf0Shq+AqbGKohJ6R8vOldpWN7gnSl4PiLjLtSJm/MIterIF85tB8IU6tgV0AiKo5Qi44Ju4O4ft2ciWSZNhrhR0N2tWse/Vb6Sn2Oi0k+UYUXz1WAg2+meYe2WXGXdq02vyyPFNjVeJ2NNcCWU0MvaEiLnAmnh1JZDx2ZqBH7D8Xc/5niX5xSgyiQl0hp83JPhyNfG6lVVsJO6WHH88P7AMDldNNiHl/1Vz03ro=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0chz+SLJJesrXLP808RsGm72JCHl1YgUPZ8lQ4HKn93Ptro/peb3q4CdIUs4?=
 =?us-ascii?Q?yXQbQiFTUw3DN03Vd1kzuTA59zXUXMBo9LnDzYHnYhC6uk9VFp4DRDsiuY1I?=
 =?us-ascii?Q?YqpvY0R/DKR4S3NQLVlrXfCPf8HOVZwbRlhWSa7DdywNPwXV5foVNiTH6cx/?=
 =?us-ascii?Q?UPaByuY1leezDQXNyxsFvr2J+CLVLfV6Ce81JR2fS04rYw2psP+UKuB9kSMu?=
 =?us-ascii?Q?SO9HfH+qnRJhqAIiFcwDHpZ2pjB3kzGfbrN80Bcnw9yIiMQvnvA2uIjEMU4z?=
 =?us-ascii?Q?m3tcEwE/LzLteRJZ+ZOOCDb88Oekamq2zyN05zk5p9hm3LG1x7WQtTRR87mU?=
 =?us-ascii?Q?dk5F2I6c4mkTfblVpzqQ4jTtEv2gk94+aaJhovxK/gTXfNNa+dS8hbbxqtgh?=
 =?us-ascii?Q?eTSM37atwApmnYQrOe4DXlOx5pjtQuutBwV9MOkllXzY9blK5UYs0JKAlseu?=
 =?us-ascii?Q?qGAMLXuUNqWF4O6ZPSLmYeeXdJX5B1d1TncS3ZrHuU8Dj/25Be9of7LrCnow?=
 =?us-ascii?Q?0nduJA8H2eZXMqzcVu/S6ohoslDbRpgziH9f27VVkGZrLwbmS8zG1k05Cgw0?=
 =?us-ascii?Q?8PtcVR9ugLTN+jUOCyFrmbfcCjtzBbQ8rsrOB48jhu6mbW5xNqeWiuEwY62F?=
 =?us-ascii?Q?G+O023mlDcSaYy25CgVpcT7m2Mm6d2gzdkMUnw0FKrF3LLFd8q0hLFyOgpim?=
 =?us-ascii?Q?OZ5JPM2kF12bW3OqzJEix3E/TMqXl8Uv3KNWj4MA55Y2KsvZNE0kmbIQW2Nk?=
 =?us-ascii?Q?2HFIRR+W7FZ6lA2So75WHaM6slzA2sZ6igxu8QPkdvDZ258neb/GdS4GgMYS?=
 =?us-ascii?Q?5bBmIBIFAO8ItAW8QLXvARgApo9BQyk4ldoq9A7bgU9jVcZ6q+LcJ2t69hai?=
 =?us-ascii?Q?GJT9AcN8UvZl0eKlDpTs1gkAECGqQU9CAW7QYSQjVzZu8IBQTXbKHIcgunzp?=
 =?us-ascii?Q?IgXzsEdTGqE4Xcaaxd/NBn3Y0cZhh1eVNOcpW3gd4R3IgfzilTdaQSAr3DYg?=
 =?us-ascii?Q?JvVQWC0cTonReF09DAbBivbqR1skopGz8hQdPvpOJy7ie1cs4YyI1YT2R/HX?=
 =?us-ascii?Q?Q8+/kxHZ7dFnBdTYkc9xnIJhBg6Qp4NDl0jXrHZzCe6ar4CWQfyK8imkz0zC?=
 =?us-ascii?Q?TwghHhXA+SvCKsNMjDWunOYYo8F7nT7hH/9mIdfXy0z1STEi5smULT4IBhKt?=
 =?us-ascii?Q?GpVDsWxAXG4V1LmD854VkoMAsqzpz9J1bBQvRwoD30y9ZC3RfeNpMJmkwfyt?=
 =?us-ascii?Q?zEfYhK429SHSQxXvoPfp8p0lY3IyDSMKwusu89L/84Zt6PYetwOXjy/+DQuP?=
 =?us-ascii?Q?zYvsMMu393h6epjyc3jF/8KpOuKR6Vsnk4lAXJ9s3n6x4sk0nCWBY4kj6lXb?=
 =?us-ascii?Q?pHEifvoRp8iHOhXJjkWxLgyMYF5m/HyUNPgJmt2FBmuuGpE89sg+vKpzUq7K?=
 =?us-ascii?Q?+iBfk5Uv9UeeeAz5IAxwvvP7DLbEhfgBMWmjsQDFHEGyzv5JY9wr9DGakPXF?=
 =?us-ascii?Q?dPcKzvaH4eeQiUOhS7BB7/61mqOLvS+aggYjol4n822Ae7IIMSZaRRFYbHTe?=
 =?us-ascii?Q?jubkhRR0IBCJ9OhJ8/DJ1kWYJnarjhv2AowyVFE0hRMACKojPQYE9hIUgReM?=
 =?us-ascii?Q?7eSNtczRfFhH0SDmK3qQXF9VdB66lHhklseoP4y5VTQu8L9gy2r60K099sYC?=
 =?us-ascii?Q?VkEje3vp1VprXPfU48nsgJrVL72J3JwvPPCji4ArxHasakiVNsQKQWXWwhHv?=
 =?us-ascii?Q?oTn2YWRQU0bHLRY1hqRxZRmsH5RSvWI=3D?=
X-Exchange-RoutingPolicyChecked:
	ppidQQ2eq44XoyZVO+VMcoYO3gnIC7LKuMoh3K7j+H04fttS47boiG55GIhm4YSN+CW7nMorve4fdCk7W5XTMq1UJhmQym0RI1LMP4g8lo61nN8JxFwEyAZmN5bdahBkHUShKQDv1chWOp5QgD1+5ucVWoDml4kjHlj+Uajh235Qh9M+mpWSwVXskjd+dqMErMiVmE/B5/VndCufwXUJSQM94F7MiAtiguEBjC9rHYrszmExEvzG/ufk3VWfmKukWnq6N1qzzSLnyQe54ZbSpYRUgJXvWLWSFp4J24VkwQikvxTrEobJBeekjwMnnnGQT5lXnDpkKjcHN6dOkRKG+A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JtqCLCs61iBksJeccRl6EUkOtyLwuCkUA0qi6Xm6r7d/gfVPTrIpy7fwq4z6NzkTxVWQ1MuzBoccrDJHO7FRWxqV9V6JEaC48UyqZJc8niryynuxNoOcGRSZXnCf3w9rN4tRG9B2xzT8zqbCefhzxwRP0MnQGgFtjDpp2HC+hOadRlc3shghp8lMeg2e/bYLVbsWdCKliF5y2BKKX9dlbdptO0SBacFawyJM1M2mqbUSy6Etl3Iab+aC7jj42Jxw0Lhb8FLXvg7ij5o5cNHMTbZFfRLXyMptNaK6odEw8wnpLnS1Ks+MPONKHHKnW2ka3DqrtA7jJepJYMhXWo7JIJQIOZ3JgMYkKlaADHctg/IegZSS+l3+Tn1nZuDeZZF0Nt/UsGD9Op4H1aEmEI/OZDD9Fzke3gv4G5pcVhqi7ZwJbup7yNV5RQWUeVZVgWDpi6VQLaH9gErP2VfVnnPhuRhz8uAHoODVUuUYY9wrGZQHpJ0OzH0F9RSrU+EOgfPGMrH+W+nPdLM4GySC6S8uof8ytYlsMOxXHxKqSVNAx3PH1hk4QxSJE4gM/GoC2sgaxU/EvvSCrbxSjCXG+07xgYUvbdd4XC+EQW1mE+HH5y0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d976371-7027-468a-17e1-08dee89dff0f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:22.2106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+kX0QAm2ZjLK5V/B7XVyp6Z87DqIhvdz22VG5uS6OD7Ls/YBhFDBFSW4tm+KCIXQ8dTXlNU3N69htiy2W8/+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX3YXdd8GcnWS4
 yia7q4ZQItYOpH19V9VbK8bJwj86Ep3uDjw5zehe1XiOOEkFbnRQmMPMf7PzxVpe3+uaEKv+hlM
 jJzA+I5hdLn+e1WblGuWG4q1BlWsXtU144QmMlsV6M8zrfXl4AbQ
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a61e0d8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=S0-NFRiyq58gb8qD-mcA:9
X-Proofpoint-ORIG-GUID: vGrjhrWw095H2DTG4j2ql8WO7KDdilXz
X-Proofpoint-GUID: vGrjhrWw095H2DTG4j2ql8WO7KDdilXz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX/ME65A3vNBH9
 VyhHNaNrGPK4L6sX486ijth3CAuRVa6mHZBwXiudBk4/UvFP9Lb7QEKr6ViGZucCmrgSX6f5M9v
 xswNuBZ3KOO5VAROeqxbYxgdzksYqmuMkQ3AIojbN1O2Q3l2kiKzW0/HhZDULbCdDZqw/zaaQ91
 tD1zMmmNcJxumTH7+ptja0PLjOFsHZAvluAEniYdzNXBFMK2+9bDthF4CsrVM1jsSMOuYq1BaQS
 oe1K7HdoPxChqYPD05WBVWhWl3MymqvFw974xiz99s7BL8oEfFYDz7nYMRVRlWKWMjsAZmnt6kD
 1e7P5KGsD0UR2PK83nyVVFow4Rp/0DcbauQ7GTK9yx/00OG3X03poo5yVXCVrLzcRO2urlBhnV8
 0dPFBhjwbvMYslM37R5DxKBZ1IJf9/e52aiDsScd4gw7b0SpDFFTnv8l+uFpsJsSI+DCNcl8A5f
 taL1a/Hf8Ntcb+YfQug==

Add support in core code for delayed disk removal support. In this, the
callback calls into the scsi_driver to do the necessary removal work.

The scsi_disk driver (sd) must ensure that the scsi_mpath_device does not
go away while the delayed removal work is active, i.e. it must keep a
reference.

No reference to the scsi_disk multipath structures are kept outside that
driver, so that driver needs to provide a scsi_driver.mpath_remove_head
callback to do the necessary work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 18 ++++++++++++++++++
 include/scsi/scsi_driver.h    |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 6c50fdde70d65..056b9c35d1144 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -362,7 +362,25 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
 	return false;
 }
 
+static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
+
+	if (scsi_driver->mpath_remove_head)
+		scsi_driver->mpath_remove_head(scsi_mpath_head);
+
+	return 0;
+}
+
+static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
+{
+	bus_for_each_drv(&scsi_bus_type, NULL, to_scsi_mpath_head(mpath_head),
+		scsi_mpath_remove_head_drv);
+}
+
 static struct mpath_head_template smpdt = {
+	.remove_head = scsi_mpath_remove_head_work,
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
 	.available_path = scsi_mpath_available_path,
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 249cea724abd1..d92b63d357f2a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -8,6 +8,7 @@
 
 struct module;
 struct request;
+struct scsi_mpath_head;
 
 struct scsi_driver {
 	struct device_driver	gendrv;
@@ -22,6 +23,9 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	#ifdef CONFIG_SCSI_MULTIPATH
+	void (*mpath_remove_head)(struct scsi_mpath_head *);
+	#endif
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
2.43.7

