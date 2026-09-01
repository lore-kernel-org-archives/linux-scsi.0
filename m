Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0FF47CA73;
	Tue,  1 Sep 2026 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259584; cv=fail; b=WqDGVvltKQPsXx8teLrN9a7CLjvyGoe/6ly3KoR2NkeCcFjxFCpgJbdf8+perSTBxNSxczj2lVgLiT86iNrlYHqaGD+sFOBr7B/KvbqU11IZ/Bm1Fc0pZXU/35YgrgStudjtdazYnqw5aoDjIyNlMDrmNUCNxelpPCDJoES4G8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259584; c=relaxed/simple;
	bh=2eGB+ecwkSOzDYeR/zeIA7kq/x+xI5dKU+EcUkjinIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m7s1GrkmlgU38jlWnS6pn48dH2UXdkTvZX1pJSWgXo4Up6qiSzv4d7u06TutbrEh8xyxDExNJT/2mISeGGVkxTwjxpUIk4JGMr5acMKtM8SRRKMEtT+EO5TqtAOfXHCei2ws+bshkBOLHLxGcwQ6erSl73ydRujNhky8UWBQ/YA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RVqLmb/C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XSj64fVD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RVqLmb/C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XSj64fVD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBpPT2679686;
	Tue, 1 Sep 2026 10:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+mzc3eVpKgFgeGTJnW1lOXHmi7F94fiKvs//K+VETaM=; b=
	RVqLmb/CJYQooc1lqntZu7KW7nWqcr6lhMfvrC4QVdIWUvXuMSxCfPDy37aOjQuk
	ya+zvht9NQeUrkvXCNFruvpoGfYIXa583RAxx4H1Sa+q7mg4L31ZVKdJNYtT9VrD
	VnAIB1HEkFXP+Z5ZyAtkiOJsTsobjTLq+bS8d/6wLUVxigqjTO08YJaF02ITaAJg
	a7WALnuxm0VpdJSCYRRdTKGOcp/VDWCOJMclTbxw8Ma0mcMHEAiaiIjS5uiZGIgg
	/93OHOtvajBdBOS387ZBb9IklPK2aTwt9aStmhTF3EnMKAnt798CLu73KYq4OAwq
	YXpeHgwalYsbXR2xxhrjaw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqa7mby4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjYA2036488;
	Tue, 1 Sep 2026 10:45:58 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqfk4k-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEq8qBP+Ua6IJFzHZk5hxHKFjEMRXtQaEhILUdLMdZm28nQNYfrrCrD1Fy3utHOkB2MNFyPQCQg6Cy/HTxTDUuHzzhNLmAIYpeDp7by0Yf4dU97uU0pUQwVCG6CUihJaWVE2mzRrinwuf5EJ9eB0zcB7l93GD2yDy4c05L2yhApoIbLpZ/Ew+f+ozidq56Lcj5aNhuUysvxHzVWn43gAS+iJhPKF3yBRo1AhYnKZGfgAIjqXRgjO+SWrfUr5d45zrOucMaSt5jvZ51KScL2TxFWaLIV2Rz70AHXEgKTmrFsUqfoHznPXVi31Uj06xA0vveWsg+vPeOqLTAJ95I1WNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mzc3eVpKgFgeGTJnW1lOXHmi7F94fiKvs//K+VETaM=;
 b=orPDYaWprAp+Lws5JvSVl+ySoGtVC5ug15G9N90FdkhpWyUxTJ5zyq+M38MMMxclT9o9lt2UJFImbkq9F/0Swat1f/Et0FsnqcF3kBzAT9pMksj2y64/+PFh/+linVJLSkTRRSXfysHNTCDNiZOoeykM1b7YLt3NFz2V1sq5La/YOf1LArhdiKSaYJEONpM8nXFH5zVWL+9t/UXuBUIubUbaCwPw1kMbLaEXYh0UtPsL4JNNL8i9EMCr4B7OtZVsbZSi0MtH6iz0E1GhQx4tLTTvJA/GlicGZXgsN2iumTqlwwo+gLZ+Sm1NMkTDqwXy+KEFq6mm9SNgO5KgWn7Hiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mzc3eVpKgFgeGTJnW1lOXHmi7F94fiKvs//K+VETaM=;
 b=XSj64fVDTnhH/dDRviwmfdRcu6s1m2NAtRLQ7HpgCNS1jmZcb3WejM4bE/m8UBd3wlMzBv2vcXyfffyJyLRNJB5cdId44ZmKOswHcvl/hI6QmBSiXn/37aEfXV1lR96bvcrRy6X+0HNntCnuGmMQ//cdZV4xqVqPS+mMpypyJw8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:55 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 10/27] libmultipath: Add mpath_bdev_get_unique_id()
Date: Tue,  1 Sep 2026 10:45:09 +0000
Message-ID: <20260901104526.3850621-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de88144-2c04-4692-f784-08df081631f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	PoLyUXZY3ti1KFTUNc+008yPlL7SZr2UmLMi08Dx6oncLpugfplZV7FvAE/Ssi5uxltNPYnorbrrqB8xKTvVPZtV04lMu+peyRNXWE7dbblbqZ3NFss2ANRcqBasTarJNCx/WGF2yKad0Xy4D3oOnKDlki68ZM62OJKlxGc26LR8VkF7JUOIl3mdDHPtXG1VcJSIvJIqpHRJhCYg5yf39+Ey1CZOMgYplWIDvUDNRbceaAMa2k/LJWZkU49xx1OrK+Y1/PwzRSR3cB+o8QLuyN+IBl6dDzu3Ig8TSvWI805DN1pF3jHcGROvEPKT3qNANPzEzkv4dfgNrzJYQ3ebAwHwABCitoqWVybIK4vX3lYtvbTbFfnFQnVx3szzd52OaOyGPdJ1YhCIsMbYk709GOSOtR5Pic1wN8RIbpcBy+X2KVDw4hqAqYPn+wWGRy5XwiEbyQybuT2J6sU2ADpINnoj1CSCY7QbZiJxLUf8tFzyXI+x5J10Re++Oo1pmaIaRSgSzOObd8eWYX8IXwlH5g3lHHo3V4Png9SbSmep8npSn5R+7dRJ1MV4KsafF7zIsRufK2IPxNZk9IWAn2xv/uILbbRTteaShUF2sFbq7wfMopJH4or+tbor/Y/wMkMFDW7mtLasbclg+ZvnFzXpTLyMDrwdvJWhVJg0pMqr+WU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U4rMq6lqjaEX+0J/MwhyTWqMrUWoXLd9POr2lenEmM9LeB6VNr3vUXODaFdC?=
 =?us-ascii?Q?ik8MrFYWkcK0GdlzeJm5UK3kcChTCn5WchiobhKQ7Cp0uwwqxcYF/qWdWUc3?=
 =?us-ascii?Q?b+IBjjzh5uc8tx8Lc2Sy6F+ZjH6bHEHzefTqQuLheRWrlq1jsZe9hA72N5y3?=
 =?us-ascii?Q?xoUNSn+X2tXlkzr1CX/g+fne1efHKRnn98wGmq99AQOXlUgYyxkkSRamHt5f?=
 =?us-ascii?Q?FxO/KsobSCw/8YmzY5oRDvNsVREXDp6CDohE6DD3hZd5vW3gzrOynZBmW6hp?=
 =?us-ascii?Q?llwn8KcBCnHFkWVVqOsfyVIPEb8VCjszsx6VEjfK9hDTN7J3s1v+R3Id+ADK?=
 =?us-ascii?Q?4cmOCoVbRavvoM+veH+t5Bh6Y67NXu/fxYYcMQh2VMlTGmk3bwJDcU2BNwEw?=
 =?us-ascii?Q?yeR3Ph/Y/VbsmlBm6qRw+t22j2M/zg/G6oIEZD7fVTKuwILnvjWQ6UZGE9Hv?=
 =?us-ascii?Q?nikgeFzn7hLanGX7QpEphA6bPbnp67ItFTDQTVa49bwpQYcaHuzsrlG55yHx?=
 =?us-ascii?Q?9JW0e9+4OTg09Sib9VlsWE60t8LN9Ea0O+MjDN9tOpisNxLCThjMYpQfV5Ho?=
 =?us-ascii?Q?BSfydEjOpVn2DcjEztYMS991V6iKS68wbEA3aXoa9funp6M7BaMaAhRGSfWp?=
 =?us-ascii?Q?biudMntS3Z3xUwKrGoDhYZA7+oH9CL/Gj1qxSUQg6fQHnkRlSzJTIG52eOG4?=
 =?us-ascii?Q?cVBnntaieWkRNg4URdhOsUjMKT71DVB1N554lM0dSdsp6K6FB5n2lEi1ST6l?=
 =?us-ascii?Q?kGegAzS1zi5AVmJOokjrWQz6FSq1Ljixa4L41Q6PwH8GIqbUpoIC4xnxrcav?=
 =?us-ascii?Q?/7AMuA+8cxDDa8EbaCkgKPlxM2QAwTh/Y8/+NxWO13PHjO+ZLFYPV1bu0aeo?=
 =?us-ascii?Q?Ss5oqBqGNa9KTMTVEGeQl7SYt3aUbQ7X9id+yQ/O3xb6PkivAEiPQEJ+fpwP?=
 =?us-ascii?Q?lQT5zUGr/0TETk19uBGM0XJq0WeShNZ0D7I0JPp1EvND8OdmaPvuD/NIbx3p?=
 =?us-ascii?Q?EyxHUZmbeav91x+Gasf5ny1FRJsCWKjccZWLWr/z6MGPNJV9a7vlQ4DMkEOJ?=
 =?us-ascii?Q?L8/XcunWqrPmrmqXGlYwuWyVDVLtBrk2GvMQUg3h3IbY3+ABuPDkUEmQ9B7K?=
 =?us-ascii?Q?CkDmMxbGjTI3M5fuTi0IdAWl+PJkNKGkG2ZkKe10U0A/xlWZTUF0NwcxzNR9?=
 =?us-ascii?Q?wpgQVaEYlWgCQu5DEuWxLlczXr9WrYwGsNY6m+UmJnEhtVFdXazojnhr0JLO?=
 =?us-ascii?Q?fa7tsk0wxj9RJbTpHDipRMII7W2gebM/8CXDhRl2QP/R29qo7L6JgR0KMGOS?=
 =?us-ascii?Q?znZ3SJazFd6gGFoZmM9yINjkIjyrTVjZKwUVahNpj1eivOdsSmWHG+OKYNcE?=
 =?us-ascii?Q?A9Aw8cDNZsBjUWuAR7YBspItrbV0he8NyAd6vei9r/KXHkbI1Ke73bTm74jF?=
 =?us-ascii?Q?FKzuLUIzPAIzGY/N1e3Dhw6hou+VLsNFqxa5ynxiWC7MYKTM9HWGwjgXoffR?=
 =?us-ascii?Q?096e1YVyRFQJ4b9gdVcbU3lmzNYIhVlfJiJY+7kJUtA5uTf904ncFXmos/1y?=
 =?us-ascii?Q?gbBzEXsERrY9sPDDDPs8dG5zwTKv9SBsMPlx5s15pi1jJwf5aM3FzdcN1Sxj?=
 =?us-ascii?Q?QvGoaEofZxP5r/Ztt6ti44Y3j4WDhQd9qyrBakMKCPCbRz6+88euqZvZaEfY?=
 =?us-ascii?Q?H3cpNU3hxH3L5gF2yZFZ7G5+S9iGEOcfM8aC4C7Kch80DUa1r9chIHoKapgZ?=
 =?us-ascii?Q?OFelIB/cyA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	wrWqACtLD4oJPHR1b1+AWNXO6+U63wuwjiGge7THL9jOxSdW4S9faoHKThT/WDjg+8FXkxmPZ/DRviR1tUSY0zsGSl7h2Hnjo50Oq56lUfon3mk9RI8/UQTdUKNOyTkQYwbXUhiaVbas6hV2UMLuA/1vTBkqsBD0LGYa7RxCikl4dM31pXIq++DHv+OcA4WDh2BtAhr/VuvVBhX29dLisDwtxyzXAV5OIqH3/0ZHVq9QBwFtBfr4V7h9Sy7uTgkXkuh0Za9cqxl1HddzAiL4tMQOUCo0sWQrjBbT9IOmgdnO2VsXWsLwHq0F7tdvakcEUFmw0oTB2zjzgtfJI+fbew==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RKrJXP9wC81k2S8XxAoK7cgfdYTxCURuUJ5A/iUdvS2JXhxQrOBe58+3X4e3El+vdxCAeIaNU5UHzkegecUnYNRGWIJDf8kA8rTSbEdgvG8BwN8+umPzfs/o1Il6CepYZEeCs57u2crMKosPsSIHpqhVu0w45ebKWnVGC7TkaE624znqN843eNy2zIlcUpYEM4unGKKQGE3ZzJbSsqEca+DLzVHJJiKnLM16XM3i3SJ5vcHtbPueZ3d9KnzXZGdf0RdA2gXa8+7eq53EVo1Fh6g3P/3zopeSDoszxzbkWOhgAIpve9JEHVPUX9Y0u8LeCNt3J1/eKZjjYMAEPFuJwJA2VdakH4U/QLXI0uAlg6GXGJebuq/aXD8RAlF9yh/2OiUJuPhCwaPqC+2GKzkFX6ISJM+/i5mnIa4QFlsqs38tMWRBWES/XqHSoHhmWtpHHoK58SI6RN81PRtX62yIwHMtwdxYdx+v8Wc5RlEP7kIMlyHjyBm9DeARPwgew0X+6UT2CxQgnxs2RD2Q52HRmLEzszy1Rd4iXvq7swXVcsXwEONJXJYVRzURMeVQqYI6TpqmxtYFUV0gj1fKUV+6tohqmo5b1s0eYNlTspQ19go=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de88144-2c04-4692-f784-08df081631f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:53.2169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7kyF8zHkbYRgpgdPDuNimuNdzQO5DcMa11EVzFTf5qAO/YUNGzj7qZyLO6TacKXV1OVhrnokzl3+UY5ws3PDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX4nkvL10awG6T
 3MNIuv0BmwDUsgoXsKxZq++T5a3rMa0LBZFdqv5k/1qMkQO+A7QFCLLTM/FU1GEUn1BbFyL4ylo
 RzoQtPZ3N11uOG8kCHyP37sLmGOg7nXA8k6YA7z8em9diKxN2CRP
X-Proofpoint-GUID: fCC2svWboFIZEKjbhAjS1VUU_XiThnry
X-Authority-Analysis: v=2.4 cv=DPu/JSNb c=1 sm=1 tr=0 ts=6a96ace8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=wdrd9TenfaMKdVnI-z4A:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-ORIG-GUID: fCC2svWboFIZEKjbhAjS1VUU_XiThnry
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX6ZBfe50C+NFj
 Y8t9IOvdP9Zt9+Gehwj60Bo/wHSgTTNP7/qeWHZ8ri03wCLrUIFQ5206ZtItL45nKynSLBWWcF4
 +0toNhk5JbOjCCSbiMZD8SSVmSCGDBAMPM5nBg0aRVb0/RaRrEqv50wqA5trkdXBUBrSYVRtIFM
 lGbx4Gcy51sTKRYDc2YCw5AwSn4Bp33Fz+zja6cwlFpmBCQzCdTnhS6G7DUF4ZClcO7BB3Pijfp
 344uHvjuTUAFVEi03dHmXOFGgFEWbz4Md/6VbX4xz2ZpoI++pIHE///xqIKXWOzaSDUl/upRPIk
 u86fQ3/87spTUPDm36ITaoOpIq4ZUmN+iwvp5Kqn4EOYrLLqZqxOmzdzCd75yQ5G/I0zf3FxHja
 UFt8Gz6FFtByuIaj7agq1ipCGcEJD5+mIarlLh0OogAnigpmNQYaqhDBIzPZ/xDS6R21V2xihDB
 pQg1CWlmMGCwnQOpCQKtVghmAz/wm8cPuOycuSQg=

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 2017c4d0a210c..66b3338cf8389 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -454,6 +454,27 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->get_unique_id)
+			ret = mpath_device->disk->fops->get_unique_id(
+					mpath_device->disk, id, type);
+		else
+			ret = 0; /* referencing __dm_get_unique_id() */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -521,6 +542,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.7

