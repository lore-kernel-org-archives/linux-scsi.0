Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2743449B0D;
	Wed, 29 Jul 2026 10:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322337; cv=fail; b=CIHLd+GbWL3GaEkmedQmgsf7IXqSfmFbG6fRmEEYjM6eHC7b2ftrmp6SBWeu9eyDOiMq8FXQPV+me+ajc9jkxvXOgro5aPFBPp9iuAdyfAlYsLgttFQl9GHfowgWAHD1VzLE0MpCTxTIt+xdCTC2x1NXYGX5ClrvvMFiBEGVfrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322337; c=relaxed/simple;
	bh=n45I7E7jcn+sgCuWYYm9NNOpITBe3a2TunkE3n1x3ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rRR85Voh3gBk50i18lIFa5/7lZEhi1lxLUEfm0saNjokDdDCnGwUl11SpGtD4m8AcWlqnjISh4RWOAxyfqEXtG3ll5gzmb9gwoiDXVKfUjGsi9EitCjaPcRnEdeDhxRapgxIAqYkVl6h8WNT77aQIK/+PSqaZGm+H4lPjTdvHGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xd4H2O7Y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iIBiO7W8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xd4H2O7Y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iIBiO7W8"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9CXZ82091658;
	Wed, 29 Jul 2026 10:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PUUqaYbxWgFn2rbN7hejDepme/gz33w5QSGiVHteXh4=; b=
	Xd4H2O7YWGi03SskiNn9U6j/aCZlbOijfYjYL/gwv9myM+A9KeV1dyh1dZKiTqdi
	QLheGG1EWMwR2W4W/wBgyUYCuLV8TcvKzUKlm7Yw75YcwUhUtfbSepadKKw1EOIX
	co2VqEokH7wI3Xhi3exGDIP00ZlAI2IJLqVVniHalI2VSTYv7CdmZuhj19AgcCNd
	afYMrO4yAEvLSv9LC7gj3aVGQP3pPx0dQqJdOfAhxvtnahzEe1DRKu3bH7s/BHm4
	7o9KBV1hkaj3o+Yrvh+fKorZFzgTbz55YroN6L1HZ7dC9fykiiB5KPxDNFSJur65
	14TeYUN3isCHRhsIf4SlCw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyydqg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo5eB040026;
	Wed, 29 Jul 2026 10:51:42 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrk0k-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQyI9i7RN+RYCA9o2qPHpOuDfwULPE86SgS2rumVz3ggCjQlijYcYZoS7vhlt2d14sTmCAn6tW4ZXQEdkIpmke+Gw7egDPUuoDyTEco/1aCdj+HynsgCZGvix7RBCKK8WpyInIjzmouPGWHEty8yubPLBIgT0rJVVEucdQDv3KDke60ciqX6iXpLqHBHHMLtrqOzrDQfSOQqhqyPR0GUA4RY9p/4xho6SIAKOu6Cc0PFyWpJLWq20X1nEwSn2IVnkad7BKbQlzO6kfgJ2CiRUJdZeNaPbt7MkFeuYrs/fIxO5fcK+zGsyrwP5f0F82LAKR9LnFfuGIfKZzZunXyAsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUUqaYbxWgFn2rbN7hejDepme/gz33w5QSGiVHteXh4=;
 b=nheyYrePIxEwD19B34bhnalpjJ7HrDcNZIS3aagVxYmZQB93MhdYzT06WMwdQmr43lmCA7w/ftHGGFmzpWcLG5X+vd1TU6twyvdeGXcHEkDyrOv19evhngOTfUlG8ZNabLJevsZKi5xLW7IPRSF461NBshwpwOiqTkQ3sWgwOTJb9kbz2heeoENvbC0LGPhOAImv7zspha6wawf60nUshtsU7qpQ/GQ05+yLT/aHJHU54111Wp/V1iDSqmuBIos/RX5YotvFAIauEQhqu7SYpYwAt2soxRnScIVD08MofO1+luRFtTpDoFAQnDsaHxClpdRNvnvik9hGvOiRHjg4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUUqaYbxWgFn2rbN7hejDepme/gz33w5QSGiVHteXh4=;
 b=iIBiO7W8727IaKNZSlRtDvlhZOnxBkGtT4NdB5vVO9nKHKCnxuoEu51q0cet/8kt9UZkCaMlWrcOB4BJ9SEqRN97l1OpSq7FdstmnNddn8QCdt/4UQJ8+7bEelQ5aeV8jQt+4DQvpn8I3L1OLv7rwNO9zrwnKiXUk8vaVDlt1+0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:38 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 02/27] libmultipath: Add basic gendisk support
Date: Wed, 29 Jul 2026 10:50:42 +0000
Message-ID: <20260729105107.255712-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf147f2-aff7-4625-a2c9-08deed5f5dbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5BLYyuPkYFrzwgJqSVoj6XBT41Pxor0ObgSHY3SszfyyP0Fr32+VtXHeaWvo0g+/TUHxpZBhLcgMbOLqaat42rRXgHt8/RNA07lWaGC5gOyCYjcz8gg/FGYM42v7Em0+v5E/+NGv2YTuakTppEBi0GHqxMZs1n0PMgGkm0Fz0xYRHmga4+uu6FcbU0FgsEA79F2RUn9q/+ryqA06RWPd0ZtWAz9988Rzt/VZXaRGR3n71DKd4nhkgcYK4WDCskWPsv6q+5+3U93Wb9sDsgRzwaVrKilWZDgOXG/nOhNZYB4jlVjCe+zjic5hhmdyXVQYuiP2Jfk6SKgg3bycBiv3Xy7qWvMNQ3dXQQbyxTZHi3DBg0BVdlVVbG5V+7ZQmx8kucwiOGxwFeFF9MjgPxGykNw4wyERCWvUDFsFUcFMZX9cgsOFiyC8SlMkezusXEqDwoTPXMxK2VBlaWsm7QfCe2iT7f665HbViUzVAS94d0Nh/gxBv1FafItPwWRlfJBjUoR7uf8NPxM3p6to/F+IwO6iQ984I8rPAnId7qzrUu47VkoAW1swMj69RUjkY7kucPQ0QfhIaatV2JPprWUNxkNmIW3SlsWG/o4rfgBjwcgjRm7i0QM+bdwimalLxh3mpmsKcdwiJMNL2F3iR7avSobsy5WDpXgKlvJE7ngk7ho=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NAMQROUIXAMx+g1MhUMb3a+UMHWqdSsxQRwpOwZApTZhPdwNKuJCcjYiLHIe?=
 =?us-ascii?Q?XVjlj6ZMm38h4qXUa06NrsDXEmwqyOnycK/Pj5VRs548MI7LdzPlGpZ1gaxJ?=
 =?us-ascii?Q?Ojw316yBYcJDs4sckkiVVf5nO9Mb7+bY1soaR5H7dHRJ1UKEni7z33G1Mqn8?=
 =?us-ascii?Q?2OgaxMeg2Mr6d3MPcqaHl1HnnVhY7XdaiCNp9cBLB7sALnltX0U2WoyNXgVj?=
 =?us-ascii?Q?aE0cXXtObSLynUibxsp0+ISRejluhEG4onD1jFWe0+bZzMMxYm6mh/dGQc9t?=
 =?us-ascii?Q?1hmusra4663TPpp9MMkhpAcrZ4qBAI7+TbfgVRQt5i4VeKYUe/4f4A6tVBPv?=
 =?us-ascii?Q?/89fGGqYVBC4mhjpq7ttsZ4ah623CriTiOcvObgu8MpPRPWkcujdkUSvff5z?=
 =?us-ascii?Q?WL6kX308F0fJJjkiTMvKn52W4rqGGMmQzPatQoKAPEsf65QR9oINSAZdXLVd?=
 =?us-ascii?Q?7aqsEnMPjt/yJDChOI3EGmfF/125pn51M4O3WqSwiCAuCDm+RgniXQ7uOncj?=
 =?us-ascii?Q?K8rGxOTUOM+/4/5HJAq1uQKrHnGeCS+gsEwLxcO3ONl49owSss6ec8nw9xbb?=
 =?us-ascii?Q?oBS9qW/Jd+NfEdtT1yjlphMZ9QVmNW0oMtAGr59rbA0Lk8aGy9wu3b+GpEFn?=
 =?us-ascii?Q?QlTviqmhcTPiilA8GGvHboi86giKJ67mU2ApcR1O3KKlVRnIwsEQM1R4A0mf?=
 =?us-ascii?Q?KV8OYZYMz5tWs+Kzt+SLiOjW8opuw/ZcZgOAHVTVv5aGqUtVCmq4osxxNows?=
 =?us-ascii?Q?cqzR+6Yu9xaeZL1nkHz9z4e5QEhAer8v32cBLFNDz3FC3bgHAYOzN7VsXQXM?=
 =?us-ascii?Q?hA2DBbrJaARpoHRiLJs6g+Wm8Hz9RlLpp1AF8cBHtUo1yaTNMF0azAOrvswE?=
 =?us-ascii?Q?d0l+nKAaBaCCvF4LsbhStxaEvxvgKelmER4VOKaTttJCni95duD242wcDJPI?=
 =?us-ascii?Q?i4o3GjZMmQbmYuu5R9upjwUjS4Ec3NhtJ8bXFdMUOlzaU62pHG0J7epGGIn4?=
 =?us-ascii?Q?IHLxF9lWsibXk1vC3MvAbqVcl8ZxYpqkmTN29GxbR+2ZS2sOI+OGZTF9n50h?=
 =?us-ascii?Q?E66rIrQvy6vhFmbScQ0YameGmGDlBnE1F3PDKg2YJ19annsCy/OO1c8GnVCD?=
 =?us-ascii?Q?6i86jwxFSQg5dsjQ1JqILsY1HRnu65m9pVfVx9+iav80pQ9yYL+P0gN2wK0m?=
 =?us-ascii?Q?tYnMJHVsbSz/VizXWUYgkZpUlRnTewwpzRG2CilvJragH5Qp8dmgYW9vF+5A?=
 =?us-ascii?Q?nyZXtHVFHBwHO0g3kpe6iDNPU+FC5oq2n4r1zEJW91PSQg2xY3m8q6CPE1ZT?=
 =?us-ascii?Q?tOX6MeLOWbIB5CnP3/GHXh2plEvUAL9dKTAlRRvJPJY+lIeFO3wRX8b23lQe?=
 =?us-ascii?Q?hvlQCY68vK7sTwnaDp3a80xYqNfQ9dfFh41awp97wHiVYBNTi1rGBX5gvUAJ?=
 =?us-ascii?Q?o/j6mmdkl/V+bR+30af+RjyU4KrJARiNJg7V+mRrJPQL5CaV/93BdTfLc/Uh?=
 =?us-ascii?Q?pMGn2Zun7F/kEM3lPVi6hHWGPgnl1FYJahVVFePV5Rh0lwquztroYYALbUri?=
 =?us-ascii?Q?whrYhEd3qOzsAoF6hmsd6Z0IAPig61hJk/zeeevCE5h0aHzjSdVmT6NkNvAR?=
 =?us-ascii?Q?OWzsQnmD90eM+jqh24oZ/9Q9YquPpPy3aLMJ2keMMU9z3iWlQjtsGpGKO/qE?=
 =?us-ascii?Q?USZQcqAGvlv33eyECjl5EWYBmKIvVP0a9WmzJSY2D0WpDcrP/G4ulSr0htT0?=
 =?us-ascii?Q?wdwtOMjFJCXLhFQSnIRvtigWKfdyS6s=3D?=
X-Exchange-RoutingPolicyChecked:
	aqT150IIpRhZFV0wF58WfP4T7g5NdsUAbNm7nMrX7RBMqidkOCy3D9lDMJZjikil1nprOpSWuWYc4BxyvTVluvbYfy+cJ5WdMCAv5vdixF5wFFlvuRdZ/WxxDronq2rg+fVd2TMED520TCR6Np4U6NfghYBvgxGSffcW1YUWvxMIUdBq7KxCoKfJR/8pOn4aS2LLn7bL7gMweHDDb9LUrcMMFsmsKzzxugNpCOdqRzInbE+cg3G8uAa3psyeueiR0o9+1wRuk221MhsB56XKg0rxXP63sXf5bwKvlIR3be/egzRWoS/7jEb45tJp0f7oHWZ+eKstSbW6pSr5cZmjKw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HDkQaL1JxifqtpUzWKA2Onls44lsQ3XA9yEiju5rclRcp1LVPUR8MpIB07158jOXBBlBmPubm9ahipMXsvhiNhxlZO2EAzc7c1b8cWWKzOebPsFcSEINJirpkhp/WbVEuXyF+xGCLGGnO+RLELuTupUqd8EWwa7RHpXm7JW4+XUiB4cHAtISfEqb0+C4iPYOVwTf/3GJd0FQn0UxG+WASXhQOAancKlkJf/gqzIvds3346TIzoDzIvNN55WT4Li30zfYXN4Ln77iYCo8z7SzX7Zp1ifGuVujJkuIk+EO0kWkLJC5+TrDuJfS6trfb9OCxQJ22Fj/pcgL2Z+E9pHybq60I0bcCS8hEFhaaDHpj1NTH4KuvvTxcul2kwnKqsfJvVFq2fA57Pi74KRjcw13KvWKqALH+/etGLKktuPvd+VWUGGkVDWuWVfgZRnKjqvFSYUm4Irz8Fy7dzmBZx/kUDAi4aDU5EutYvv2QbZzAEMYl+DNXfFpQ9NleUlIJjPoKcs6FTRHZobjE3WclHUNLbW2/Rg7MnQ2tI4weg+Yp10uiTm0sYm3DQL25aYOuEUkSCj1Id0OPiNaOdXBSFSdPm55AahwuyzMzdsigHWlSI0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf147f2-aff7-4625-a2c9-08deed5f5dbe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:38.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2aq7IG3vSjfNA6eVeMqkK02dvX6M60Qo4w+QTeQf6ZOfUueh6w5FKNRASXhcj8ASDvGJeTYxsK1WteDDWAVNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX0GJv6f+8AviU
 EaG+ngQBBh5Ihj1aP2deOv56pLeyKSa99a6legAIjh3DdO+HJIYW+j7NISqABdJD9CgTaRDET0O
 llvzg+4r/m38leq1ZNm9zUV3Y1AmsfBc4OgwZQdWZ/t5kB5CASDC
X-Proofpoint-GUID: qMDYRb_p9zzBttNRgNrSVq6JezfmDTeO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX7evF8KEFvHWb
 0YzSXvWFL9pd/EtPqzgDQu4A20xK05bN+uSv/Q36YJAaQhr0LAQC2GJiWS+nUWjRIooPgKRGV/d
 6aZo4Zf9OtZxmhLQv0d8Vtaxq4O9DHKwE5F45ZwT6d3vIO+I6dAHlOYIjFOIHFzc6qapsapslaL
 tDrBhyNSh2iE+qrDkkezOBa9lp0nUuGrwSIkPki/HbaTZlbxvb5YBoIMaxgdQ7V/6MY0DS5Zebd
 JFoCVMMkXsq2oe6VgupNpJXeOnNUE+iPWB+8udCTLUQlmbI5iRfkKJhtmJnyeJZ5H/h9mPVX2oT
 9jcNcaXhyiz1harUYJMaQj6UfPr9VGNrlp3EtjR4RioQBSKvZYk8V/yuHYw0O98kcY0WjXCeesu
 tLbfAXlF6OExoAxQhg1C33hlcXgYgQuJOPK2tEaJi0+vT7awfBxsiTy+l4qccUS/6Ij4lzrI6ln
 B/Fs7rJhJCc78JCOCoQ==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a69db3f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=B52eoxIPv8yZRAGToxQA:9
X-Proofpoint-ORIG-GUID: qMDYRb_p9zzBttNRgNrSVq6JezfmDTeO

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
 include/linux/multipath.h |  38 ++++++++++++++
 lib/multipath.c           | 104 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 407d985cd31f5..ca6e02505be43 100644
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
index f7b26c66eac7c..1cf20b0f62d07 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -36,6 +36,107 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
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
+	mpath_head->disk = NULL;
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node)
+{
+	struct gendisk *disk;
+
+	if (!mpath_head->disk_groups || !mpath_head->parent ||
+	    mpath_head->disk)
+		return -EINVAL;
+
+	disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
+
+	mpath_head->disk = disk;
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
 	memset(mpath_head, 0, sizeof(*mpath_head));
@@ -43,6 +144,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
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

