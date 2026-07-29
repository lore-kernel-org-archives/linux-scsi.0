Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8C945A2AD;
	Wed, 29 Jul 2026 10:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322347; cv=fail; b=Tzq/yNFL8/Nbhy9sG/0x/QSFbSv9wmNUfohF5VhOA1yuOZogubaxAanBsPu3NgZ8ERrr/sSV5NT2b2xGzFNeYwOk8KGnxtTgElLXmELp6ZQWLyjVURIxi56pa7w5y+0RjiodF3jdaKkKW+0xJiXEkVqlHff4xxK7YddXPfmB+So=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322347; c=relaxed/simple;
	bh=kKEbGqW/97+vPYKG11i4wu0vmGNq1oC8126l7QRXhLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nbeZzFlp9Hz0SW0AeZgw4xJfRL5KtKZg3s3RzK66u+zR2lBA+hLtnKvyoOxs+0hl+oz0Mid45U6ATq6W/0Z29KBpoKR20TIBo+p7StwDB5ofwHcrtGuv5OJ8AtCy7bhe5BRLFhyqHfXA5x+hSQFv3umh/co1Didd/ux156r/E6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EaYve/7T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nZYiVwbR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EaYve/7T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nZYiVwbR"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T92SOL1122251;
	Wed, 29 Jul 2026 10:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=48zao+zV9KyeYdflFxnRMzN6HTz2fQE8ndw/Gh4ckAs=; b=
	EaYve/7TXPqL19g/8iR8/iTPhOE0xG0K1GNCTCpCD0h1obt1/Ec+PUIIWBl0go17
	BF45YZkh4NIp8PGtr7Ez6rFIXy9afUGJ5QwIG8mwjHfTSznm4psY89z1S9kRYgpD
	DRexJdFjujy36OIkaJO1PAj0qfjVxkP2a/wET/91jjuDwNgMv8vJ4U7Wsz/lxlYH
	vpN9V+N5dGpTcVFGw/FwzwJw84WLC1fDmNnev3kByniPWmXGiA++gfy9st1iMari
	DEn/UdPGGOlf5oBPdSgHve3QEtPjpFBNslbugdN5hgC6zSfRJrDeIBh38OnZ/6RO
	OirvYqti7g1Ne+pHq6EAuA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xwp43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAeW6j022385;
	Wed, 29 Jul 2026 10:51:53 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010024.outbound.protection.outlook.com [52.101.85.24])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6qt8y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bq3VOB2k5NASAZ7awpA5jkoPvqSTKRPS+R6Uf6bFA+fjI64f1zSr6Qg3XJd3crddEiERONBXG0l4en3+3C5FtmWQKyCXvGF+I47RL8ZmjLN9jpmkS2M/WQL6OxtMP7E64tCwKe3BANhscU0MBJM/9RkyunMja8BVSnCFayEFvqD/x0rdQNpzw1iNC9l7CDY/a/oQN633bcizo+U9708uX3viuLQay7EzfsWyEP6jeYmbY8PwcaG4lFpwbq2a58J+BIxY7lua4WZEToXXACGsyN2NvkbLttk9WQGkevXJqNjAmmP9oEDud/2vlu4GiElupqlvEm95mghsLNkTwahwyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48zao+zV9KyeYdflFxnRMzN6HTz2fQE8ndw/Gh4ckAs=;
 b=IxbbLMU3rxjLr9y5CnvWpie4q99+Qh9z7PWT4/NrD3thNlT+3UInRWmzCCJmCcrBv3pmNsW3R8ERDEN95lbh5LxHmTSCIGTnfSTPs0iaPcVLrR0amPoVl1XTFiSK+q1i6MRB3LeNq+UcZOt7KC/HCQNpqvSvPpBvfwjFVr7vSk6ZE8z0hVlIOOkWyhJhywjtI3ARvVgCbpJmBlWaIxLYZv5WGdeke5SAwa3pFDZtR3q5+sdMIMWAyS6vNZ3EfFpn4QJz+dLPGQbjmG6NAP3Et7QDwNEDtCKF8n/u3gLGXiFhsfIhLcndfxgmqfrJJlfPq1CSoxVKzh3CHjkLLUC5Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48zao+zV9KyeYdflFxnRMzN6HTz2fQE8ndw/Gh4ckAs=;
 b=nZYiVwbRyUdQf5R58Qe71EPeYEX4D2JoBLgpxPCSZpmFDOXk3L7gSdGSUYmzySOk2EaQbDCszKHZO+OjzrNKYobSfTucHu1bK2tg+Ns7yC03GOUVSTtb77ukHKZ0pUvOF8vAOqRnFFu1eKZZt3AnUmeZOC7M9+kqcg+iMR9Wrwg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:49 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:49 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 09/27] libmultipath: Add mpath_bdev_getgeo()
Date: Wed, 29 Jul 2026 10:50:49 +0000
Message-ID: <20260729105107.255712-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH3P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1e7::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d97f04c-b4ed-4b7a-a905-08deed5f642e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	82UfXI2Gf9x+gh/ylCHkHGenoWPM/+kjhdXIGlrstt6hOXVb0fzlN3D8MCXy8g3plcOZGqL1SR4nTZmfKik/wnMwzxkhTcdikFg7UeyPxHeZJIZwFVPTrKR0VEtr4b/BzKqu1JtkKfQjrapetMo50roM8dl9/H1RxdQIE81syswkh/ZJoFW9Cgj5RwQo6wQkfnAtMa8uokDPPzeCiG/k/fANA31J/uwhExiMO5llwEtisR/Op9rui5lRNL5PuXtXR1lHGMkOJ6Q5hyjyeDWmaJm+b5F+G8CVehmrpBQHglaQgC7cC7M2GKfg/FKUN9hGVocKQinN4H7Qh3H8ZJqo1jljG7eXVC0OksZl0NQhQJEjjyN4I7UqJSu+548XflTbeSZ5V6j8YdLz8EjK9Z58kDou1cbJjU1/86EqI/pPDme92r7jYbuCxzHokdj7JWWEsAHqaQ3MjtSokl4uL6Me2h4f34wSH2WqVUc9DxCP9u7WHUi6nA0945GM4JzzcpLbBUor9xm1glKtg1rdG6KBQ33sPrU2NrxeTReDiv9rMd7YaCQC3Y5TpaqRMh0NMcAWZ7DvFYZ7u7vVslm2zlrDA7jDG594vDmCtO2vjsTACsxrlg0baX9SRPGUGD2Itw330c+8yoy444iVO65gvnDqk/hpBUKF97q+ftCbSTXv6SQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sja8L4g8CCZ4BEUca5zWRYBvnylToOia1Aw4UhUjBdYVgAznC/8mXQwF+fWn?=
 =?us-ascii?Q?/A+xRnf1NqHBGAUxfKApSVh4sNkmfF/VXwvJgkKcEuDxHaC3U+CzAzUOZzLN?=
 =?us-ascii?Q?2u6aImrQvwoHDywvCXVjKr4vNJzWS57BNJsQdHvxA4x+SPc57DlviiUZeQNT?=
 =?us-ascii?Q?bZthd4D6JmYXNAUtr8GSUXjkSCn1bnGlDVTjN3q0boHYXIy76M+jxlUogYNS?=
 =?us-ascii?Q?LbZjeWhJud02bqhgCmG+Eve5Lwc1jGfn/K/d1mh2o8Lia7MDKfEE0xeRXKA3?=
 =?us-ascii?Q?AfG2kEShWwXD8jC4WoK/HcmM8Z1YhbIzsJ0Nm3EhQmtuOGCOaZzN+5sN86fz?=
 =?us-ascii?Q?f6NlcB3n6dXZx/KzTkBtNB8Xr2gOeMatZDXZVMHwjgVa5EAJuld5HehtBO6k?=
 =?us-ascii?Q?gfEYnhqNcgjIUrnhgq6HNqDdBo65wnntIgPpOTEjQcrsoT8F6q1u8y/H6RYH?=
 =?us-ascii?Q?Wy+LNklnQWJmT6gcE2PA4G0a5yzImaG8Vya0Vroa8KRXSz5Cx9tNUTDPu6VN?=
 =?us-ascii?Q?ZryvrBz39LUwacQvgJSnBvORIbycOStP5xGRWHdFxVJIqdtP1UwW+WB0DRDP?=
 =?us-ascii?Q?fzSe1ekv7cGmPAS3xQnssikwXLHDa7XeVLfNUsaWjgez3+MwqsA3Hxo9DFvO?=
 =?us-ascii?Q?sMGNf/O1uzcr4/vLPLw7+DBDfobBNiwwRZW01+Gee0e2+quRU1rBZtzQA7+W?=
 =?us-ascii?Q?rLlPEyLqmgmSaAJmLQ8kG7JQfHNZ2gAzHpyMDzkznz+VQ97dXfso9dLC4ZxO?=
 =?us-ascii?Q?QnKB8b77sVZKkQEtC5Dxdxlefp3H9CBWbPabjs+Ex3BovVDkTdmZvP2RTrj2?=
 =?us-ascii?Q?4LbETBkucLII/bWnEltKJh4N9Jl/nANtVVY8dyqkHiO4jUXOXEEQwCJFfvBv?=
 =?us-ascii?Q?V9RJqYud/Y3zrazmKaoL1tA9hJjpXQCSmW/mhfnkJQKB/vNHJF/cxMf0wZ4x?=
 =?us-ascii?Q?RVxzpX1dphb468kQrL2zA+Ky5dJUobBJ+xCIA+LtukGM1VhoaHkopvNYlLxz?=
 =?us-ascii?Q?5Y5MrOnmu6H+13Or65SGVXlEonjOQta8JwxLfu6gVS5+m0D/kg2S/dAK6j8z?=
 =?us-ascii?Q?5kOfVB0nxtsaf491QAbI9uY1xxYjDGeldKh+h+iclFaHJKqMeniIvgFaqfW3?=
 =?us-ascii?Q?Y7QN/UeeoblbL/bP/160EoyGUJfx7qnCtRPVLXeKLVP4+sWDIo+ogGIndC6+?=
 =?us-ascii?Q?vjzb6oG21HZ5q/29fI9NdfZs3RsNesaOyHvgORX3NPi8fEV16BQtD0850h2v?=
 =?us-ascii?Q?ZUvWsRUgGjC4h4rxedfcJfWWXkd+cWy8EZQVG0wsnQCYfZ5efdTNFv1+MR8u?=
 =?us-ascii?Q?PKjkQ2ypvnLdqHy7Kik0y+1ePvlphNesQIg1Mp8PkZYJaBH3+2FoYaEJdV6M?=
 =?us-ascii?Q?gZ2Cmzj4+2Bx+xJvW1IIO+h4AwR0LqlMNQ7lWyLZnH+2F86UzgIVi3gR0JBA?=
 =?us-ascii?Q?7rG1H5EWpe2TerpWjEYSlmxPI1T6vifG794035VLH0GPXMIAaoI7gmPnoNoR?=
 =?us-ascii?Q?h1HJo6nzDmU3FqtB19BV3S58vjZK/g2xwiR4rozpqwg2Zvo+/Oiwkd5a9Eij?=
 =?us-ascii?Q?yzsSMqBFhVlsG13V9xNdIN5GxPcyngduNvoUn0+iXGkTGGAx2nQ2iCRuUvHq?=
 =?us-ascii?Q?Zk945t3ATE2Y1l0DnUAXRFlkgtiPUTnqmNO9I/X3n2+j22MaSSuMKpldjBwb?=
 =?us-ascii?Q?7TZC2veAnQbNYDaoteF9/ILp6vwvrK/F85/01g9mSMQZREGgFq6WVD0c6QTL?=
 =?us-ascii?Q?kJJuKPrTMQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	KT1DAp8Fi5SlW8ee+s9taRoT3iBPEJYDqGTPLVJXaYBy0r7Hv/iqnIRGe+JOLmyRKEV+k8E75YQTyvf9mQ3Q/89Rhu3u09REzyZjAtKYXpIYQYzZe73lU4xpuQ8I4c8o0B7QNuuEcfJOOa3rWUJIDHD1Jrfpoxk9cylJBNzG3ewYqTabGRPx/XkshFslPAqIyTJEeQlQ/f+V8fMVbu3aWl61ik6cZ/kOxi2vXs/JbxXgJI9As1jW2WK+7obKCHWmb6tKwnFJkTLyS2cDnkLWkovixT1sMXHMd2+X6G9m5vjLtIJRBzjtI5NQ8kY8J48GhjPAaFr3mC2fdOMLGjI9xA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hKtfC9aYSbW9d7zGYy/QgRBQNnTR5eAETMNkqgPylkzJvvTHUVpAXGKwCU54VhqfGU9qJ5piUJlJEicClJumIudWwYvFBjf5LeocQhrwvczDIXCEs7C+WOhjt0Zi4CB1H13FuAcv5s7b2rUbQqQesviaHeKlGhT53IFsbCs49Lu1NREnX6SuPg9I2nWr6cu0RB5AOdOCbgGnsgM7MmqPar00Yh8/KIPvYadJBErGtGMXxXrlVcqUo2OQE0eUx68C1xLrDiewRMfblBbkVMEA1hpOMRq5xTabMp+lhFSAnOgCZwDL+240DzCDFt76PDbL/KBRUGrjvyD9nT5Pv1i7iy/xT9zxy9JagZxhigspfGlVU5imKV3wIG3PayMwDgAuA7rKMLS6ECf5CYntRR2/tV48F3exHTDdpGvhCrVEAo5KMMtwo8NR+FhRH5xmmYDnvgHmFUry7ypjbXVyr55LOxnXm3tjWKJqAttn+Oy8TK8fqKD302N8PtrrFYcWjWLJO8wMAtGvLafxWw8gTbkuWahgeR+rkuRMQxDZ+ks/sMYypfLeBe8oX1WEUEwDNMJfsc2ymBI7nXA4kmnmJDM1AMgxORT6cIzSB5bC981wIgo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d97f04c-b4ed-4b7a-a905-08deed5f642e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:49.3790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rglOnpvpvVVlKABq/RcKKNGvghbDyTu836SaFO/X83MXWu6VU4jUWlhhybYAIQEDAveUNFySlj0dHHbO6OqwNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290088
X-Proofpoint-ORIG-GUID: JyRjqDR29OcbLDcMVVdYxCtyLVYrcO2B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfXy4Vcsoa0pr2l
 TYLWISpdPqoH05dS9v1sqTx11kAV40lpnR/h547HV3BX7EOGDH1QZwT8q8/hCNO7lY4POrduVd+
 +hCzRzsUBeXzbPsG/N6qCfqcq5Z3/qPFlhaUFhN3G4bSlx4nlEmSRNk6ocAbXorjC+kslG5McD+
 n9ZC5Jw8dXnG8ILIZFRjaCmO2fgulLpiq7oNgz6neW5lGFl9Ou/giCIj423jKS0uG5hJ1vShutl
 C9W5Y/Qhc1hszxQTKaP32Vr8sBxoxhYE41pQlpP0fIFi33ckibTq7LmUjig3xm2woj1KPJCRq2b
 w3VP4JagIVD7GFcW8rWFOzLPmlIYw/BNmRPmwd3p9LxzWDnWbX8QmxZ0jwD/1HxhQly2KDXYfej
 PDRO5XCxBhS2IowPpBUnKBv9kXw4YHo+8MFwsTwnjDI5Eb/Cwq7abA5n9EhL7iEdzwYnDeRxhG/
 NoVMJD0vtwLmxjSxYBBdgzSN3vfAtB4KHOMMn4Gs=
X-Proofpoint-GUID: JyRjqDR29OcbLDcMVVdYxCtyLVYrcO2B
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a69db4a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=-Y819F9slc_s4kW3I9oA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX8VfT7v/b/kiW
 pR6wW6YXmrqdi3kLa3pN1cMLrY7MnqP3eb9/H/dye+OfTljaY+Pc5L12lA84KdStJA15/aNNUK4
 7kDNd0jyzE4l0bBNL9c070kgVLn7zuBjUdG14uGSI5v9vkyPmyjJ

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_getgeo() as a multipath block device .getgeo handler.

Here we just redirect into the selected mpath_device disk fops->getgeo
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index f1758d1e60a60..2017c4d0a210c 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -490,6 +490,26 @@ static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return err;
 }
 
+static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *geo)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->getgeo)
+			ret = mpath_device->disk->fops->getgeo(
+					mpath_device->disk, geo);
+		else
+			ret = -ENOTTY; /* See blkdev_getgeo */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
@@ -501,6 +521,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

