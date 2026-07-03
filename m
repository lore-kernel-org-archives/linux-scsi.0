Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC9C3D9680;
	Fri,  3 Jul 2026 10:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074909; cv=fail; b=pTIsw2uNZlKTJdYQZJJkBga1X+ZixZuaujsrSsuRBzH8z9hfPonabTkoIUw59A9mVc3ASeo5/76bMHzzRQHIMOwFp1Bpz3yznST84GI/0hrOKm/ccfGpeamZupDJUJ39TlddVlF9J7Pd6RMKG1kfNiqtLswlorSnum/GWieiBGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074909; c=relaxed/simple;
	bh=kdaHQY4/p0Ww3UrinCgrFEDtdg6wu1G7M+fWaHAnD88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GDfWSxWoOmtl2pqTndMxqUNuvClXg4kAEycdVSBRM0heooB+jRrm/q+gwQ4JMzcdzvurCgl4fsZUkNQ1ezLVH1hcYqtRuSOD7/lYrQCfOSq0QPHWzS2ICjGCud9SXpz6NM08p0QAySchm7J68One3RMkRbw+6zsyTr16xkmVXVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YPckN67R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X+BmQtVX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YPckN67R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X+BmQtVX"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638uWBu3063915;
	Fri, 3 Jul 2026 10:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ew/rq5TfkEhlPCoOTPfuf1YGIGJLJzKONT93pCQq2CA=; b=
	YPckN67REnZDhtQ468b7rPwuUZ8cSyFvN35YsR8jjUyASKN3JLBaqEmekFTcmyqh
	H2D6kE/TWhbKajjWv9VxhEJhdLrBfK0wMzg8JjhS9IIo6ZTcbNmxBFbvbEcym0/7
	0RrKbSgdhGLc+NlJvRuYqVWNZaXD0PRqurgqTViIvs4zgZWIj2/Jnlm9KrR2MYsx
	q54buCGB38tWLopHsZe1OaKXOYLzuySlXzVaql/1sW4yCgxeY7etwDu3KwMhW+PU
	vuIL9TgXvFBc32ZDVgl1BXoCMGOplfL/oCzNv9dAwwYAqrm1Ytvp3c/dMhnXHopY
	DVPxhlzBTzF8NcpDfDqoFQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n1aec3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AX88W009672;
	Fri, 3 Jul 2026 10:34:50 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhytwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oNnO1OVLou0enn0WaC+A19ltj/DifJ6tTy9TZIpLSGPE7c2R6/BquMVHhIXTtldY+PG/ULZ6gondrYLQDIxxLCk3o8KTvcKjddgj8zd7iXHFyP3ZXnpVhroNN9IzbXFfV3l1DgaWCmJQx8GTz8OV776bxv/TOzThXp/n7BDKf5w/Pzi8W8ObNfkDmtu1sj7uJJE27XQxT/OfGTgeolpV30ruUTwHxyJG7pPfyI5nxVxLfeb53kMEOn99IncuMSxPdUA8WIj1M7OilUbj7wJlmjDPQIWlhvEmKAq+wR+Psvv2bj2oU9pNwjqfHRCPyC7Fbv52thpHRN7uhwIeHaLxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ew/rq5TfkEhlPCoOTPfuf1YGIGJLJzKONT93pCQq2CA=;
 b=WRDTiVdn5Pb7GdPId7HsqTFqxTygC0ZFOOMp5NzPlcHSNuPcbTtFLW0hlEhjwJ74c4q28m5PWTVTJTQB9lN7/cLJwQkp36MRQ9AedMogxpHcsJvQdYAMSxaSneSuQYMH5e/fAc4gMNn/k6kNIZWhEH4Q7BsiqWWDXJ/+OujAh/nwJRRqdZR8IE3umrJ9vkqIjFF/T2JOTXnHCbbsI2JhEXTqR9Jvm6zZ9UzTywstGQUjMOo7GWaHeVJV8EEGRxiImuY+0pzbwCDS1dLhZTzQAbm0abnxTZK4S5VYtPm71/XXYzopdztQBlNpC5CPAPPYTvun0Y04hTYyK1Uq5KPbdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ew/rq5TfkEhlPCoOTPfuf1YGIGJLJzKONT93pCQq2CA=;
 b=X+BmQtVXE747miWr9LTA6cbTheF+qGtSaGK1kcMD1n4zvgksyWJy1klkfj08XYPGOY4oN0rPwP/4lr6826dDDP90AgJv5rduPANM4IbFTYuRx6YNmvuqFFIpovZ8MRgdug+B3e/9O6Hg5m/lgyd+9XcqDlYDgsFHHrkkrIp40xw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:44 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 08/17] scsi-multipath: provide callbacks for path state
Date: Fri,  3 Jul 2026 10:33:53 +0000
Message-ID: <20260703103402.3725011-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:510:23c::25) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: f7ad44dd-6835-4dac-19b2-08ded8eeb213
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	Dm48HmmfFE8m62vxLd6RcMXz7IA481DgJ9JJJZI4i6nO7AaLbkKXs1oNph7hWgkszPQMrRbCw+Ra31RDuSDnjwPXrnxmtJcveUE89+LQwwSGEyHaPVvuQsAl7S1BhnBxYKbjHRHfIVZho14tpXy0uU0NTVvCoSrEuFXbppfe7Q6apSFi9wL0jx5rbJYk9Z26Qx2ByT1ptGtpBtA6+XgG/gOThAEM5X+1+PgFzcCmBmuU30X/MgUQqQ4P8iEVkTTAk0rr0/36S/zHYgwxvF6dyfyn2Bcme8nXb0D5vjfN2Cltd4e7PM81ucV8copM7bKzkW0NHgGR+ACwgAABQMmKPTu0f56uP/vhN0eJETkwajS0AYZICl4XCqwIGKYCbi3BXJL7p39HrkzHpCFdt4A16aWc+CdWfMF5jvpNIVmjFGShXiuEeYnWANWm47YRLM7x/I9zIYIH9IgKWXIfVrqS+ELs/xFx3hRH3HaVudxTeqsoFtRZUZCUgiGhBkHZEeC489MdBMBPG5WtEL2K+hMQXQZbyXLQ0HU5leDUTLvvJd1qhb5jkyWPEZP3goB5wrzxNziK4G1n0K3Mm06pEuQLlA4bHSN5Qq+cGXkZ3FNB7oLMNjPcWUydx3rAhdxS43oZrH9JyeXpobJJsvuj3ylHxUxfp/pdc/P2XXFSB8CyTU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h+mFofmPfPaRcrOxritQD5PL9ToKQSbW6JPF20FUUe8LlsEIy1y5GJFh+ibe?=
 =?us-ascii?Q?pIG3iS9vZT0DQ+9TasGxal0f8ifzDMepp8usywCCUJzPeuU3JUe9Aj9T3bjI?=
 =?us-ascii?Q?r8hUKurKhUBPQzTK+H3iNgitkjoW1lxpGhd/VnfNxDmPASVxyGBx2+bpZsLr?=
 =?us-ascii?Q?umt4bcsFzIID6jFKRXGgu0KWr9AJx9QJ+/RwJXVrsWaVd74KYRnX3hqmBKEd?=
 =?us-ascii?Q?hpN2ovwhSxt3IGgsm+lkWt+Da6e+58kGwTHIOK4rsDILSR1irF8fp2BgW4Op?=
 =?us-ascii?Q?jtLW9uXCP2dnEivZHw4cAFjncWJa9ncHF21MXTZX1DkdO/J9mA/A9weYs5zW?=
 =?us-ascii?Q?89LhYPdRXoHDLrYjx6WufTWPUhQCtioPNYbqBmFrQzKkLEzHN+pBFQHLC3Oq?=
 =?us-ascii?Q?cReOGsYxwrRsOuXsub7ZaWgFPkheaEHnCpz++UlG/47MYJjX53897+pL9msE?=
 =?us-ascii?Q?dW2CerGvhDWEsP48MyVA4AstrbAusormQyOlmegAVgx74UsJY3sGGS5kD9A3?=
 =?us-ascii?Q?JcyYASHA1U8YhdvVox8KPoE4g363mPfk+3cCnVB2z1U4xnLVFRhDfDm+w4dc?=
 =?us-ascii?Q?6ZgbU0CFedondvkbxJMpU7q5h4Wqi0Fpc8lpnnE8/pY6tXa82nQp/CQuUZtd?=
 =?us-ascii?Q?r/nkXhtzDQcuvHn0JDJN7BcNNdfBKwUFKcrf3zNUBJNztp655ccinjrnEGYj?=
 =?us-ascii?Q?Dc3UOmzfT5ZPB9QABMz7cwjcCZUixTluCWVlV7GACweJSpNPccPddtQ8IMTP?=
 =?us-ascii?Q?xFu1yDF9M/K1uTj500cuG29X/rlND+Bq86vnGKsL1StUyTJdb54ISBe4itUI?=
 =?us-ascii?Q?QYk0jGRUy5Fp3II6btzwawk6MkIJ8BOenBISzfNd7IjtOJm3uYDgMM2x3NPD?=
 =?us-ascii?Q?SOxyJjInbFsM0sijmbMIIH9nFbCuh7RvEsrYT18+SFQBx7WRPT5LxWYDf0xr?=
 =?us-ascii?Q?C/MHRMx7sEhI2r74YQ4DpAsb2T3gSTjoCEHP2NZS9uE2j4S8I3+HAZ5fhVF8?=
 =?us-ascii?Q?oFU7eYNYTuuMT+qFu6Ogl4pFb76QEeSN/INUdDNz9LRwOH2nCn2mCNtw11Gq?=
 =?us-ascii?Q?pzgmdYHCwnW5ZmWb6MfDViV2Zxn4d8ylSngtChqzH0EYQZnvdQnFVTREulOV?=
 =?us-ascii?Q?zfCFGKOaja3zp6JHb5plspt7Fuj+UyoziH9PjAMXL+TZTgu/u0sUf5BkY9kF?=
 =?us-ascii?Q?G9SkrBYWt8brZxn/0r8huYbnctH8Luz1dVPnOe4BxmDnhAB5Kr1nvhqkwzGP?=
 =?us-ascii?Q?+Amz6cb9tld25a9UY15cVOY5oWzkhglUKXDDy5g89771Ym1dl8eXyCFVHoTu?=
 =?us-ascii?Q?QEXJU/EAgWy5SrJOmHMGQjMsDYBzyrdcJxymKBs29lWXOd0zU2Xioel6M8tw?=
 =?us-ascii?Q?54h0WkqMIpcXx61Ca/dMkrbsKJ8RNttaKv1+U7zgR+ecuYip+Y/2diAqB9KA?=
 =?us-ascii?Q?PNmDq/Xdj8g0wbaFwUWywc7siLhFVKUZ9M41l7HTSbrXyBaPPwq+bTqJ75dv?=
 =?us-ascii?Q?TwjTtnqzxjEUYcmoD0clPfC0TmMbM8sya2SdyyMRlNCN75CV1hm3XgS9OzT0?=
 =?us-ascii?Q?/Nrjhsrobh4Lg3l5YsdkdDxDREi+O+SHiTn9RaDcMBh0I+WGq5IcfhlydDHu?=
 =?us-ascii?Q?aeensmOiian29btYS+7kLO2oSQV/SAzUAZlrUkXfp+3xjHGaQlpDFMfqGcQP?=
 =?us-ascii?Q?6oE3FTUpEsLSl/EK2uFKD9OT+pKZnSoeMiJ5UU0IXCLBLcpZ9S8hzjC64mfx?=
 =?us-ascii?Q?fHJ1JE7EpQtKfBKf8g0xv2fLTRSINvY=3D?=
X-Exchange-RoutingPolicyChecked:
	PU/Q16P69afbxGSjmCDHQjI8zwmzRI39p47rRQRDVacaGon2RnbP4BMKYsIUs4u32lEplRrw8vn3KIQCDV6t42ToFkihPfZumLEHQjhadAxfNnWcltu7q33yElkVERabRu0wL7aHxHPHbdMIccnI3na8uoHiq1DW2fxAuD3s4LT5c7fcysQOYq4bs1ynDzngByQCtPesgk0dRzvqtNXPMZozXPlL/s22MyteokPV+Fswc5aUJ1ZaA/n9WrR4JEZKnfmDwuVW8slJRID6Vk04RGoQPaCo6lj/Npu708YLrgv5Yg++uEfEim6T/nR4eJ6HDuO2Osa+f36eSiocmxSlxw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oBssXAHQp5eofVtiax2Mpmtyew2lPSmeCnQ6kwsELKb1qktlVxbPo1XyV2PGcqdbjWMPHmzuVU2jslIkWtb7XDml/wFolQAFI9cSGR5WCvKMkDG/RhLY/lwWoV09bshzE6Ru10ZyDscn0JmbaL6NhG+lTAnd+C+cxejulQXmcSLHnUxEUHmmQYQKfy28J7ZsLVtp6ps0HqCdecr5SqMp3EIbHXSaDvi44roP+g3lhjqyo17S0R/WhC1j4bGMJ37R7QTHYO/eSzMBBvVxLprCXbBZvJyzkW2i9SW97kQ9geZkYfsdrOdH0sCEL02Og7hPYIuW73YEYvXUR1O/wq8uqiy9d8kfwux4ODy1DhV5U/Ga7Hq0Y8XmJzB2oKocBXLIGEBpiEBzcb7/fD8/TSwxoHKtNZrdF1Q3+nfPlqCzO23AfDy8+J5NrmCPeRQS0Gde9ZGuCPOM+pGYg1j6eu7SwQfBXWcJjn9oGEXZGKl6cfD+uL9iOLJaXigB5bANw6W7bGQG/07EyMhaXSMAZvlUauenTVqxrUWzHyP4O0tXhTkOAn7Af+ceT6Qc+RbvfAhVkDl7hGiFVZoWJVpy58SOYOSldwF6nx0dPZKam9Jzfy8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ad44dd-6835-4dac-19b2-08ded8eeb213
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:43.9948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncFgYmqbAwI1CFJYMLFPEV+KhdwP/oPhuznCnMmcERH/b2H53D5EzWaQ/9aFXd1rO0S2t1ea4nxdchSQ29kwRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-GUID: aFjF8yOjJtR3-QTwGH1waCfy4ydoBmT8
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a47904b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=DHJJM_rHgSnfI6yttmIA:9
X-Proofpoint-ORIG-GUID: aFjF8yOjJtR3-QTwGH1waCfy4ydoBmT8
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4pccEaqPXx/8
 xRxTrMbEQ0Su7JAbQnR0IQChBAiTE8yXu+Z1BOfsHddtBSPLhy/jNnfM7ZtlGxNg6bdWmu1ERir
 /iRKUJ0kiwJnE17gstT2HjgRzAao0KJMKtfYAE2rcX9oWDDxX1rs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX21SyXSbNbN6H
 CBpPz131fZo1DwjJEQmvirHwTDaxthGW3ROc1bt5SG60K+pXlwVOZiuY5mlf2MAutryMG/TJ9ub
 u57JCXDtCKBtTTXGFRRE3wOjjwwv7ciuusVSr6R9ykfUEAkd5Ttg31c19x3Hc5Zm8M1i8IuFyEt
 RVVCn3OaRd5eJv4e6jnXjoSZ9xIcEliVDV4rbm1/jwfoM5u5ZCwIXgSbH8n34pVQCBICHZ9xQlc
 7z2vGFVrWJ/oeM1IQEBpoduzuK4RSsTV4cpA58+jsexuqZFa20xntnkdkUZL/focc3WInhjJN91
 6Jt7L9YQjAUS4L8u/W5RDaKuiSUpz3LjgykydH6NOJ/vuEybbg6N6PXzYEQiA7xybnP/tX9qqC+
 4V7YruD0XI6CvAccKE94+jQWWjWA5jQ2qTNOMMUDtMmOxRPfBEsfAf41oppTdn3CaHIW9eW5ujl
 FDJvzNrkgd+jl9gcC9A==

Provide callbacks for .is_disabled, .is_optimized, and .available_path.

These all use scsi_device.sdev_state and scsi_device.access_state.

Member scsi_device.access_state will be driven by ALUA. Currently
only device handlers support this, and in future we will have core
SCSI support for implicit ALUA (not relying on device handlers).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index f22e3677cf2ad..d8ea9ffe8942c 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -301,7 +301,53 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
 	return clone;
 }
 
+static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state);
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return true;
+
+	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
+	    access_state == SCSI_ACCESS_STATE_ACTIVE)
+		return false;
+
+	return true;
+}
+
+static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+
+	if (sdev->sdev_state != SDEV_RUNNING)
+		return false;
+
+	return READ_ONCE(sdev->access_state) == SCSI_ACCESS_STATE_OPTIMAL;
+}
+
+static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	enum scsi_device_state sdev_state = sdev->sdev_state;
+
+	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
+	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
+		return true;
+
+	return false;
+}
+
 static struct mpath_head_template smpdt = {
+	.is_disabled = scsi_mpath_is_disabled,
+	.is_optimized = scsi_mpath_is_optimized,
+	.available_path = scsi_mpath_available_path,
 	.clone_bio = scsi_mpath_clone_bio,
 };
 
-- 
2.43.7

