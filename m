Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CA5481A82;
	Tue,  1 Sep 2026 10:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259621; cv=fail; b=ljupduD+Xz+EGWp4qJhz13I9k2vm/o9Ok/kdKNnLBdJ+ngYQYnrUuBmFSWX0Y9bqxj36BLNagX3uOWnw27eTAXhFnOY7Yq7MtxDung+/R+KuD4cr97JDeRRVcwRVrG3GkH/8PYo/lvdNQ4W6TvyST+cMqe7bAUFb9ca/aqISRs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259621; c=relaxed/simple;
	bh=K1qNmY7yhnWQ2n7OukKAYSZ5uD0PIAoq0KACcunw584=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=miT9rCPcIf+2ON3v5YDr0Ia82Ggncfr1aeqGQDFFAZGaZ1iiKy9wmmy48wt5U+xwFD9jlk+Obm74jJNZFunowC9P0iL7zREHIWVjHiSo/ZN8wbJ8tianC07Shi3l3qa8JvQeuvaNp7PFt2eK+sKT/1Ey2cY1YfcCbzOXXUCx6Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eqVzhc9+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xInSwXj2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eqVzhc9+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xInSwXj2"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBr3g2296254;
	Tue, 1 Sep 2026 10:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YnucySFgtjsQLDGVN5u9WVeJ3/xS7LfvTirXwVmh7AA=; b=
	eqVzhc9+Uqz+J5YDMMzCGm9EF6JMr/VsQUKo4wjdZsTAPrP1IQfus4a0QJlhHafB
	NBg8INMSjTBREXh3Q/AxPDzgKOMB1pSoK2UHVT9lXiuOp4aPEnIJfyODlrpZMk8P
	ImIkpzeBOtKnBqqd2PUxisjHnCHvTIDVrxMT7TdK6gbOSwUTvt/fZ7PNHOhkFGwl
	gEQ/AwoofXRTai/yUf4C4HO0K1WmVSBwyWcT4cScXaNjpzWIF/yiE1i47dK4b4yv
	6rqzhb5TCJGyrMfiy8OB1UXM9vpUouOId63LZJo8zcCsox1lvrwJ32OmzeX/yFFE
	U1SnyXQgF2AvCmBPKMYYXA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xvdbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AYt6M040129;
	Tue, 1 Sep 2026 10:46:35 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve8nfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sp63mtcdwX0HfOQPTbbBQi+VCGcD3K7NPlLvaVClTcRbkEoMqrRWJrlJGsPyUvVosdEdyyVv/AqCzqQnzHInmo6Iq3G8ZY5c+4YD16L8tP6WP2Dao3QqMOdYb2sPc0fDaeF4nMxquI4w3P0H382CjCtAzVabrcLk7b3tnI+IyqHvEoZAguaXaXIa3nmeONpe0WrVp9BWdmFqRGjfjaEZDumFb7KFy4d4Iy7ZSLyXBXo/oKXd7VYz6NybxgrvSIUjNnBO8cIA7yeTre4mTB3Mqo/rzEu3/n9fGnki/cZWd3ZTRe/Ck1eDEUclWVkT4W8EAV1CEdyEjISPcUJmlUGm7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnucySFgtjsQLDGVN5u9WVeJ3/xS7LfvTirXwVmh7AA=;
 b=PyeET9hqGtfEormsnNZm+Qtrm6VfefpsEZvAuHiX1X9T4np3lMq6ZUBFH+IMm2uInoB9MQGmx+pn7/3qoL03Js7wbibu+RbIiBuQcK45xzgLLYrJb7ugX7xmnofW5DT+XvBAIxlbkCPpTuAHjcIPySdmCpla9iq6zgQxLJJ4AL66kNwIU3FFLvNc33T+55fBNUGkyyLJFkMFGzgN18lH0G7hY9cMsUEoUSrN30GDNlMmL2qIka6Y0/Bb3mnM1xS3ilKPMvjAoXzoUBh5MPc8Vk+CjeEkn9nEwczbPO8y2wgscjTFwFzST8IcqCZdfZJS1oHBiLTj52ZxYpRd/AFPmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnucySFgtjsQLDGVN5u9WVeJ3/xS7LfvTirXwVmh7AA=;
 b=xInSwXj2o0CS+mTagDYTCOcwPTXxg4oEFw4xlKQGdse7SEGPxFECB4oXpDZHoni2Hbj1CvwIqHt0rLAaW1JujdN/Q0wF9BiOzUmr53JbQVe4F/Ac9DKMbN0GLDpJopsWrYBZGFwZx5wnnCvtGh7wbkFglNrp9GFLqouv9uQV/Bo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:32 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 27/27] scsi: sd: add mpath_queue_depth dev attribute
Date: Tue,  1 Sep 2026 10:45:26 +0000
Message-ID: <20260901104526.3850621-28-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec94192-e4cd-4696-f576-08df08164982
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|6133799003|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	IV7ySgNy91uMz4zTMUlTl/JH7KRaIhwwNVf+UVhh4Ucbi9Ugp5KAbq0PQc3FmFxmA120jZFJstf5Gjdvnx0E7Gvp138gpcA/y1FNsioVA16NkGlANL5piX4s1SkSlTutfe5Wpj5ZyKuecfp1JzF0AfK0b30dsABl/Z2jEju9pw8zAM7ZfXRFnrohFq4ZQclM987TknCdXbPD0unUEoaoOej/CEHliM8zjrzxmCn25d4RCwKjHiH/I7AA0iECgO8fvAuA2UQc2hvVhftJimk9AOq+itTUG+JZupTPkeWK+qOHHT/jFO1QHL4PWr7P9R9vJqItNJoKe2GRnI/0yCLMhgwUiYbo46Mz9REULsrUS6lEHpptwle/7dgxkYUvNjsSzjZJGB7wH4hRGEXpkWKLeVnadLBh72oo130n+CT9zkM2DYuAEtaNglp5/+jsceHO2O6zVpBMyDMNvCIHUDCaCfmTV8Jpv1BNHvpD7ziosGUfsRZr7ZCFKhQ5cnJzZvkvavJgvSEgRSc0ObXrjikvTqw+9VaWcPxCiASbzCtoOL1svUxLPPcK28mpKpMVjYtVV0c1bzwXNMIJLGz3sjCnod4uGR4PoHq5fbZm230C41SlQr0pbwphXAtgKeBeqgRle79kmlwOLliB6IouS4CKyFMiT2TnpOPZ9Lm+/4bZMNY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(6133799003)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IW3cG5VggSq30FDnGWeA6u8pjV204M3LhxFclBTt0raZRtE82yVN/vxFGRcJ?=
 =?us-ascii?Q?e5DRrdwCpKHbdsb/rpPcnTy2k0iYBUYsjCikq4duEVReIf4BdY2LwIAWC5k1?=
 =?us-ascii?Q?Fa1vHxG/bcAmK848E/GPZDMe51fAm7WZXFVRQ7bW/c6+rt1lE7u30Bare8/H?=
 =?us-ascii?Q?8dCAkXmbxftuhoKL+QLEIfbmneoaixHn4yxGK7lSNE5w5g2ALSkFbQxcxQZh?=
 =?us-ascii?Q?ylm3Xhxcqz6yDu6NX4ON0uUrXTu7XrApCnBG+0hALAjTcF4g23MjYoJv6yBF?=
 =?us-ascii?Q?2mEAGaii3W3ErdNyRthMVraQJCK4Qh+b+kGZPZn5+vRWWfdlfjr/y43twCI9?=
 =?us-ascii?Q?BE26XqLFnxZAZAdwYmIxib9BNFCg2NLSONZfQa7J4n2Ul719jz3t7gTBPGlX?=
 =?us-ascii?Q?WhZnEFZmSmwrpdmF/VccVPT4Z+iF9lGwXWHi/RPlTO04yoNRDPb8WBtcOXOp?=
 =?us-ascii?Q?A3EQDwVhu6qRiM4D8QVo8FJWJNiAZUN14s+W4LewC7RFsOsTeDaNG4Lg+QR6?=
 =?us-ascii?Q?1t6khPveqWrz6nF2nk4AYiV4uRfGdW2bCS7E+qP1SIvL6NVFep2wrtOAzPMY?=
 =?us-ascii?Q?+YmYfo3brjFBUSYLTUt/lyU6CAPY44gVTKoVyuaMH8sECjuvD4N/3rv1k4ph?=
 =?us-ascii?Q?OfCgYEh/i3k3Ek1RXWxZOXx9NIEHcDZxTFyDoeXmFBKqwzmiGyQ0u8l4FdXp?=
 =?us-ascii?Q?bWuV4M8aBwvMh9vOpvGlzh1NSmqH7iirBWV4xBFJLqOZlnfsOVJPTzQXZAvK?=
 =?us-ascii?Q?4T86IIeGJprhR9GDCp6PJmVFDJZ1MWh+KK95gdNxxD2WP7fKj7rG7pg9f6Fp?=
 =?us-ascii?Q?YxgZjNStc0piDbalpg4vdhSp/n9sx8MwxxUFG7FCj5hhSx+kgW25VAWDfEiY?=
 =?us-ascii?Q?dPH7dgHN7z7CY7kndtmH/aZcGk8w7yHXcn//cU63kbgk0C319f5u9THmT+fD?=
 =?us-ascii?Q?UsGw8zgimwVV/ByjwWrOAt03ifE9ebZhjfoyHTi9pjhstdvjrIwNiOzTRIEl?=
 =?us-ascii?Q?ZvV656mr0y0TkP0bLNva8yZAZDAA1UtiBaqdzGS+N63VxA/MSpfUfyQV82Wd?=
 =?us-ascii?Q?UDM/vUij8Xvaf0hEcUg65EqVzs5eyynR/tKnJkGQ6YZHb+VZ0UGftBZ2UiO+?=
 =?us-ascii?Q?RZAa8mefalURxiA+sn0mXzmQNrb1LGvRlmBN1LWX+7gv2HN/CkWpvv8khRAY?=
 =?us-ascii?Q?gmErUe88lQQkGii1NZfdgAUtkcdHSJBGv7KbcSBZUX3lZJFeEEWI4atS7J9W?=
 =?us-ascii?Q?OtDu84RBXR/VI3o+Cjv0DHTFdfzk5ZI1ZLICq/kVbP+xwrxnuM/JQZEppJLW?=
 =?us-ascii?Q?n6QiSpG5KTjJIHYthtDRiKvfACPhC2Dr4DvrNpIJUrf6dWkCPQwWlD3FRhcc?=
 =?us-ascii?Q?wCdztBJ7KrUGUxh9QzR8ZwgFbtMuhdCRU57HvE8yyCkvPmnPaKKXZQSOGUUj?=
 =?us-ascii?Q?EgJU1Nyw1Gb6n85b3AzNce5RVQW5OodBVxdKNuTS3TNUXWYDcr73i3QErRtA?=
 =?us-ascii?Q?tUtualaAGWbvyCqPrbQ4IxBgIQMMsk/j6eFJewiQMsHglIz3uQVUT3X7XNRB?=
 =?us-ascii?Q?Riv8S2c6GDkgpWFZgsyFkV0J1E0tvKh39l8Ssop94++8FHuoJLXiuOdhJpCX?=
 =?us-ascii?Q?o1EYQHiEKrVTFqO4wlpZWk7HRhiX4Z6BOy7mlhsP0h/NLutC3AG8LPdzrkmL?=
 =?us-ascii?Q?i93TxhAXgnn71+u+YLW2LYaGkeBLHebegt/rwi6drZxtcv5VEJn22wJQ2lqM?=
 =?us-ascii?Q?IE0ahKoGEvHPOi8FLmHPdKw3+3k+Stw=3D?=
X-Exchange-RoutingPolicyChecked:
	mTXwNwiRncF3EhIBEABv0V+IwU9mKp58IlK//XAA01kFEaBuV5T4IEERXVcG6gAOmCqEQSlRaHiT/mb4Oaf86uwzcxe5LRdxyRjbqflaLL3v3+xPX0mwxiRX1ymRwz6iIHx9jkF0p7zjOGHMAaaftw9RmmzEiIILcMOq05RFMYzfupku/v0FqCfkWIAYWLgk0a/U0gWGgMQSHwekYaV35rHDiqYQquFjMUqOoFJmXmlUxyDFiG5BqMBUesmFTrYt1E1wswyyJjO89bXXLrWiMUvjLVkzgpTlOZELESD6XL9prNO/advJVPTBhCXb85sn5MqU2pzD+3yx+6ZGLK+knQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TK0KLEYwXn8NqP6eostLxoeOEGuZl9AUlzC4xP5ysdilIORbfju2/kZtek5qXF8ksx43zvP41mYQztepkK9++jei37xcYQ5lNe9C8wNzkBjFxg1utHrRXxadtr0xk4gAdqH1sOlsgMlev372E6YicoDvrkDa5WLXYzSQj5bMsVopjeF3qFTOEVJrzndFhCcYHEA3vIWKWChVwIMxy8/VsRQK5dBT9hw1ZNqzEA+ZCCtQ71bo4Cb0LIybEhc5qXB1DNQudn+eqX7IJGAcpujbo8FfzYVWYfD36eeoa91lsYtivNFYX/b+7f7fX/y4/SVy3O/LaJhEDQhCRBCcaLfKgh74aHJXD6gmdYkwCEUwyEh2r4S9v30PqkUpujslSH1PXSzUIpB+HZzoIdj50UVhbo8Jbn0emH6XzAsFmo+MK/jxtBbROnXhfHLxcc5MgmsDFVh/Kf5tvrFk/ciGhfdqZhqfs3aD7uFDs3PQb8oXwnVsiMEY4xf40tw4hmyBK6LnZpoygWGCrSkG5FF1NhZ3A0bcK0JIpqBVXOAqmZnNYcKV5plsU3Q/Q5E4pzIb0hauZqqPhJIoF+TneONcyfjxrz54/O8O/+M9WVaBI4LAySM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec94192-e4cd-4696-f576-08df08164982
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:32.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSVfhVH6ul6UQDItZJkY5t54iM9kMRnCiSLy05sv7JYn+s8KA3ad82u80wVyX3TW/cPY1j9Dxzwq+gTcEZ9qrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010094
X-Proofpoint-ORIG-GUID: axVMLX_dnsatlOBQsdDiH2S2qA2OyBsh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX4cZ3n8UHpiB8
 njyfKqrzbQkh70HU06/0oyQ3nJbUkTBLjY5adrSX5Sf5RVdjzvbtt6G/9MXI5d1tSWeLoGsFIBZ
 xtpJtV9YvOlOZKhF/q+SHKSk4NbcUWHHHOp4yECUW5a1c2MaxQ3+7jsPb/SwXvGW4JOzc44nuzZ
 uiI0sozQW3lnp8+UD5CEfbnmLtADf3Nm+0pBoORfArvSr5rCnwhhtyeomjjVbHh3RPxS8KFFFdC
 jInZxnYW3ODk7aKN610e4pRNFDnGIGafratbwpaBioOqCzkPn6sGRITIqPGvZ1TC7zm6b82OmYl
 cy41hoQksxdK1ujPp8JpJ4F25L134C31s4k1XiHi7V7EZQmyvonRbRVNJPF3sBcD0jBQd8qtgGx
 ADAXfo3xLzUhlUoNCxZv7mkZLw+NLbE4CffMadZMaJ88rmhrhcNTIOZobmEAJGzzITSH28NVMeG
 zw84kDDI03j9W/Xj0mA==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a96ad0c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=bA5FzAUjrTEoIiOIIUIA:9
X-Proofpoint-GUID: axVMLX_dnsatlOBQsdDiH2S2qA2OyBsh
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX9+Ro49KAPitJ
 LcV4vcOWxv0Y2nd/kQJOJT+oJlzbVwhWT+8yKxFbhMVnlq3G4etdwp19orNONeHLS1DdXhiYXo+
 Vkp5rPO8kN6CJ4zLIkBoNI6V/Mq8yshGS+g/jDw6Q1J+5OiRwvx/

From: John Garry <john.garry@linux.dev>

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e8227e00defe7..7e1cdb05906f7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4176,9 +4176,28 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.7

