Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F56321256C;
	Fri, 17 Apr 2026 03:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776396411; cv=fail; b=oCyljZ8vsTKegYlbemZpreAbderoRSAa/HprIqNwQuKTgXD3mnsJXk2W/ivzep6tEW2COE6zgiENAjl7OORyeNKW2rExeSxpi/+Y8sv/AkWRXBOunNYxLRlB/SznH1HAN67q7iVcBXEwTYhmJF8brgaZ2Kd0ANhRdiGvoFRf5xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776396411; c=relaxed/simple;
	bh=cdqAYNuxynqAP16JuzFEtGI7vCkBFRJsLdI/edOt5mo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=k4u4Mbzpe6ouCiHonqWKjCD6eHjZeeNpLP3QVUryQQ4mf9EWb9qIPPTy5F1woLIikXHnddsSSSn9MAB6bW9Vy2P3v+Nb5xBBMRvdKlJj6FILQkk1CEqhx3vWZvfzRNQtraXfBgztylqLL0ElSgp+s4nI3pGiVpxNqbzUS455RB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f2ehK5SB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=k3QKU/P4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f2ehK5SB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="k3QKU/P4"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63GLtNrh2583650;
	Fri, 17 Apr 2026 03:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uvccqz26JVFKK0rPuG
	AfX/z+D4ZevBkVsWeHSNtY2eI=; b=f2ehK5SBUGvLSPJo8HZgQ3eQgE8+jik/We
	gF6UBFUoL8Z3zFBo72AmmRXaCxobp9qUXxasfocEGfWWRIyaNpiQfISaKbiEK5iH
	n6aDPC95++uBMTM8lhl3C58nkqM4H9l4ar0oT3Kt7KD6/E07Bg5FZe5F9X11eh6B
	Z7KMJ2ZIoNFBYb87GsKOd1KCrBsIrrMSMqhINS+GHoDCtDjBc/aDn8Exb6Y0Rre6
	WMHj0N7H4I9ReT9ZiFEIU+4yusWG+069dkDplOYIrBAGsVX0zGV1lNlHS4oiYBxW
	IXU0Mp2UwgJa648Y08/Z0kvRT5X3+zV2dMb7iJzvoNQ5TSs8Wp7A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh867hdsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 03:26:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63H3Ja6e016909;
	Fri, 17 Apr 2026 03:26:17 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011059.outbound.protection.outlook.com [40.107.208.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nq90dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 03:26:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OiOGadWP/eh4JwBN3/lDctpxe24dhpF8Y4dDFm0ywA9UO0eWyceuvx58QzPGsiCNvjHzqOFcZTtmY1qNKOKP6lp2cXSZz7KY3E9JjEK+yDyzmd4CWleOTtlW+Av09WH6DWf13kycDRWZnKD+Wswaqe1Fu5ihEt2izpJz2FB76bUirgj5QYjKh2uIyNtC9etD2xVTKBFTwKgm9dxLfKsrxaHtkToT0JqCLePA5HzqzzB5H2Be0XtCurV/3VJHGVEGVkZefNtNINqZ+rIc0tCQF+SZLEOm6QahPCtk4JNZ/rqnYdDbGSQbGivyTKkJdicY3rp9//dMHLu06bU/StvuMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvccqz26JVFKK0rPuGAfX/z+D4ZevBkVsWeHSNtY2eI=;
 b=aYDSkHnnEVyoHSlNxDq4aoIVbPNlPCdd5HuZaVnG+TsUyf5eZAb50IhHVmok9HZL8G6hrK5PPZBW656SBhHAgJs8ZYf69JJhT794Jxb90bq3WQOpooneigilCO1bPIusDwnr0xkVOYL+JrDWmeM404YXi7S1LaKZP9cl8/DHCCWHyesVZvIMrzrXgiNm7WW0kHCp7MSDO+/whqUWrBEdDVUmu+E3+B6CvHxFGb6qmxG9+V7wYKsvECf6Mxj0vvkUB7fUsORGjw/O6WqLrRwosxYC+DTs/X6VmWZSzfB3DWVIfFGeXzgYxLvGVMqNqUo77xEbT2WEwpXiyf9+/QgZSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvccqz26JVFKK0rPuGAfX/z+D4ZevBkVsWeHSNtY2eI=;
 b=k3QKU/P4zAHJrElLhoV24RHcW6VSoMwSixRdhh+M4Qxsf6j8g1FEhrdPanSnof3hDqkFKpV0Cr1jlWyl8KlM5UJrxgUhbEFtahx9Recn7kC2ApOgHFzUIrQKZ2GouWWiehVP+vwnzvNitav5wGcJSo1cpxRKNodFa2gdyMZw3VM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB5837.namprd10.prod.outlook.com (2603:10b6:303:18d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Fri, 17 Apr
 2026 03:26:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9818.023; Fri, 17 Apr 2026
 03:26:13 +0000
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Sagi
 Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anuj Gupta
 <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260417015732.2692434-1-csander@purestorage.com> (Caleb Sander
	Mateos's message of "Thu, 16 Apr 2026 19:57:26 -0600")
Organization: Oracle Corporation
Message-ID: <yq18qams3re.fsf@ca-mkp.ca.oracle.com>
References: <20260417015732.2692434-1-csander@purestorage.com>
Date: Thu, 16 Apr 2026 23:26:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0017.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB5837:EE_
X-MS-Office365-Filtering-Correlation-Id: a32e45f0-9872-4836-6fe7-08de9c3113d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	llcYOBq7ZvUA3HslDXrZ/r4IZqy/pzkIN3OSYEg9vYNbECDH4bv6TsAfW/2NXaCUdzUqVlwF3HsIQHX5HOu103AhTL6UmLRF4i1ec+Ieq3e1JwVZNZTC6OF/uyzymmOPms0RxauF6VyRvWv3loXkrHy7Bkzmw+gS0UdwRAlTBQdffMxwmt+0fD+oxeLQMVAMcKM963H9wgdqfiy+IYGaeZv+/eJGy8zgnMw8mVRxzQTQAN02Vw8moZ8k1efb+LDqjEtmYZZFH+3EaPUiEf3+svxdHcIpuIBVLSlvNuyYRus6OeL35yHOK2EC+TRThnHTpORkiDF/fUtndA3AmwCc/zNSUC31Uvox0bzT6NjsGZxPqAyYZoeC2GKrRwIERQZDMksgOlW1t1rHIOiAWm/Aw3a1NhfF7YVZJUTuSDoID2yJXIpNhCkTbVgEWIzhnMn6mrsdR0eBujcUG0/hBHnLWThInqyPw2x50DmGdEsGpp54KX+jDzlh69WeX9Y8sJW3F7hIInmMzwRfkljd6MgIH2Hn471hSYyjLDWkCxXSCNsuMbS0VEblKDneMcJwDGlIXiU7HRq7GbQIM4TiMMPUwV+CB6+RP+HpX6EBY71fGgoj6Rma1GyInSXXvxFRBFyb9JKfApcX5CjRGsSB+1shbG3Kytz6tnriI2599NyLPdQDxtzxqBrCEHoX0KGqO7FBDchO2yIs2rXdM/Fl+66jXKi7jiaR6yeOc6budMiKKkk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?acIM4kdgpxHla698StQaGdt+EqbZkajhsU2wHWndocI2ac09FzB6hR01ERzs?=
 =?us-ascii?Q?4/V3XyZQR+Co1m77+yxh0t2XLCunUXvr6Zx2/Y+7kSFlnHMii+CohPvzP2nr?=
 =?us-ascii?Q?Isha5ME1ITLoTsasF0qK8+TcPhPBR0biAhTPA4B5kYxfLsLHL0j9mxDQcZzB?=
 =?us-ascii?Q?idcsIbiNXYzYTNGa0sJqPHvM1OfVQ7wTKX9r97PfFED8IJf/tGLa2mdZ+vJ1?=
 =?us-ascii?Q?xwYEr11kJJavt3ctyKKEuWpR3DqV9DpYxU6SN1R8jdl2g4KkGQXe4Oa+oFvd?=
 =?us-ascii?Q?WBz4/Yi0pkgeOrSHYgZ44TdeL+G4pwnaTVecMDcpdDQ9wKAbNV3nvqd0v2ef?=
 =?us-ascii?Q?tP1SZu4wtUw9v2VPdbe4gd56mQLZ/innbAcK1fsGQMQG2ceea6GkWRdwq6oN?=
 =?us-ascii?Q?ZbSF8XscH4qB2BCneqK2xlkxBzw3UAUKjLbSRdO4ciBdMb8//DHclwgIICTm?=
 =?us-ascii?Q?7eOS6KzGc1tcux472EnK8D+2lYdUqqoaYnh69GI73ZxSdGDiiRhHM9tPZQLV?=
 =?us-ascii?Q?VOov+S6DuDk1V0D4E5ZFHBYy4QCb6eA9yBHXYGTbKdEOC7r1HLmTMCkCzxqq?=
 =?us-ascii?Q?6DYSuRzmTLKoxUep2CJwYEbpMx8v5fDqdw5U+kfsjjfh83BDt1SW4dgOk3R0?=
 =?us-ascii?Q?zjIRLbLZ/c67Bg/XK1ZizVAxi2cdYn5R7EAosQT8EaSDZmCbMXtm3A3XUc5v?=
 =?us-ascii?Q?FRJ4S3eXWkq9BOWU5Q6LM7G27CpvpU75JfTONyFGjdvpQvTxnvfc6DLAFa29?=
 =?us-ascii?Q?V3ctJeWsBryQSBVG7PHHKbwGsFipGCkYpBodX54ApLgxCrfFXilZvPveKyiH?=
 =?us-ascii?Q?Jv6wRxwcmWcomGn3Uc/TysYeolxupx82XROfH8KxxzeL0INV7MVEMJbvAC92?=
 =?us-ascii?Q?EmGGNxPYXrFKkOskPwnXX2DagnonG/H6ABIeF5JJwYeIaqfxEvOLL8/zXyP5?=
 =?us-ascii?Q?Hj8+wN5aMt9SpS3/I2IGw334YcIEczoI/NBr6oea1LchZ8c5ez9Ro3+puo7a?=
 =?us-ascii?Q?dsWPZC5CpZe6KhMAuWumr76aZ0K6nNbcBvrVEM9iveRz51+Arm2TnIFOrskT?=
 =?us-ascii?Q?XdsdgiyPbPzsT3EfK66br3UkrjC6epjHRuA6Kj4QcQcO7NnBWldT6EQc3uFA?=
 =?us-ascii?Q?yrIQ/mgIg7o0KU2JiQ/pS6XdKuJK+KHMOJJPN3ScBO4Sjmelr5n/2f1vtwpa?=
 =?us-ascii?Q?lmd6qths1BKd+52zerxCk1mQK6cJfhPKudbfGt9Us2tgLi9RHPK6Aojh4V+N?=
 =?us-ascii?Q?QJGXM/iuW66bu4dKHpDCV/napaiZqOeg7fyhJkgQOCAc/qf0ySNBKp+V3xIz?=
 =?us-ascii?Q?/XlA8SeSatyvdqsFEvdgJAQa+ivtqB0ClWPawSAnkeUAg262XgRufTadUTsI?=
 =?us-ascii?Q?C7LsLjwSs36Hd10QgQpCUo/79Ytl98wFiZgzKEOT2q9s/uFzbIYlnosdj0qF?=
 =?us-ascii?Q?JfUV0DfeC4vCWiqtjUN7IcOaLc+RPvws9Mh0RpJYSu7DLSUJRgsTIbBSq9QS?=
 =?us-ascii?Q?2z71UnaQrNrecEzuI1+143ySICX1mw0dae8wbm32ECU34+EPZq2/xJu9KMrL?=
 =?us-ascii?Q?FKSlk9Uh+UTEK+G9lASkCNXxHA8zjUxgO/tewqv0h/h9RJqtmAXq8D8MoC6x?=
 =?us-ascii?Q?G8gMr41up+SEq+LtzNW+AtsF1Vu/bJlTvnaO9IE3sjSQp0YMeW9IlMgEOZdp?=
 =?us-ascii?Q?Tr5tA7wl78sBOMZD/sbTWjtukHQfO9UuIhwhgN2l6UUUJ9wQ71k7uNRl5/vv?=
 =?us-ascii?Q?4fazT2wLSAia+8+j0IICXYNc4C9uhpg=3D?=
X-Exchange-RoutingPolicyChecked:
	ZQ/4jp8+RGq9VY1FzIO858uc+AIJ8msn3VJa8W6re2MdtJdmTjTa+MeOZ6+lqLL/1dYHBQKuntAYm0NnduZS+0cGso32E2RLQEqu5B3+/og+OaFfduJ8jycay9P4Jrs8ejCZba6++atyOt+YEJqXK9FkEBjCWb2h8+pQr6by6jRCifNn70iKEJSgX9w/RPTtVjdBnlOBxpPp8BhENsVZsGMelbr9MCNqRdK88s0wwT73V7mnLLY32monrifugw9OsO0T8AdtT6AOkLaRLyAJPmvZuufGERHeLNygVwOmmDjEFYl655Ur/HJHXjQLm/w9Be0rS4Wwepz+sleFTU7Ilw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WjSPDeNX9FCH+S2X6vUPb6Rf9jgGZIXj9JxWuYgzWD+wD4DcuHRDF7bJzXuWt4pxDg8nZ0JTbdKEn1E3wnbh7N76KEUeVoGsOyZ/YnQkPkBLWCTzdedvLhpHhiWr/a/Efp5Rw2nvzi7ZPPjy/Ikj7lV6CpB3Hv5vhwWcffK9v4XlelyAn47nCLE2SEi0D33zIvHmiX/CsjCQ9Iz5ouy+sywkRhtdjcdDG646wcFwhqC6qIRLtLGX1o8EAOfJz/bXE4gFh+a1OuxlZu6yIjR5gYKJ9/xVjIaBEGJaB786au86OWQZ/YsqKZ4T6Fp8C6gzf9E1/ZtqrKhaIt1xck4698OpTfPKSZskKGTnoX8kSRWCBiGPFYNKsy5HK9KlokZI2JoEkd/Yv6En3U8alSunFYCr98dri+S0ThNDQjzN3IXVqeK/Y/DLzP1oMhERz74T/3Qzm6Bxatg94vofCyOnCiUPZ54js0TdnMqA4hstoUhZykTNYrt1VwB8qPoFlE6+TRK4kRBQhdzlf+GiT0ilYfPbzB7XSErWosCzYfwXXsA6tTXPb6/AEZQA086k2eKLcUwox0Tp7oZx/Gfm5jCu8jWB57M6SuvST6griNjwQlE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a32e45f0-9872-4836-6fe7-08de9c3113d3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 03:26:13.5045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKtmODPzljZSjRMRhkyGRZwQ6opFcMrDcbj5DFjwoTvseTM7H5vpURL9tKOguJDsq8Jky5GKuSBY6eRU55jNYX8KQE5YCZQLtuOU7hgjXF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5837
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_04,2026-04-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604170031
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDAzMSBTYWx0ZWRfX4Srqvf6eDW7f
 tvEVPqrixSY8V0obQGvSuLwWOAXoIjM3o9pbemu1+dE2tvzhp9mBEZD+hmFgoe2NdNfOPi6EzC8
 a1oUF30uspFFh5sDQ4vgSa8AxYwo5mNLHUtwr8sSHDo12EA6ob66UCm7wBLqVvY4gY2hwZY2XLl
 NdPk+XcVxYO1sIY3KMIbFgjuM89gqB3616IVTw/uwJaZwhxSYxQe+9icVProrEWWFjJ0C+j4Oto
 6u7HHl186CSgQ20McKMXItFNn9h1VNWZcalA3qpxuDbJySBslgJoB6VgJlrHayWkxHidil+Zwez
 w1D9csWx89+iH5xPnsURRWnPkCJDSIFrhLq+0Q+JGLobVZs66lI1zFnGt03g66lSZdSY250c+nv
 catBpgoVH709MRldPMYUO9IKmaZSy12rLXFIZZfxXA+YevwQyWUMJcPKL3oIsYNdRi8cTBpXKF7
 V9ISkBxUh/5Qe2t+S3X2bXFCsLvOQmfplQpev10I=
X-Authority-Analysis: v=2.4 cv=cbjiaHDM c=1 sm=1 tr=0 ts=69e1a859 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=qtgR8qhws-JY_eONrD8A:9 cc=ntf awl=host:12292
X-Proofpoint-GUID: rN1iG0eMF6WUVFVPty74G-G44dfdHW9i
X-Proofpoint-ORIG-GUID: rN1iG0eMF6WUVFVPty74G-G44dfdHW9i


Hi Caleb!

> The block layer's integrity code currently sets the seed (initial
> reference tag) in units of 512-byte sectors but increments it in units
> of integrity intervals

I don't necessarily agree with the premise that the seed needs to be
expressed in any particular unit. The seed is a start value, nothing
more.

We happen to set it to the block number in the block layer since we need
to be able to know what to compare against on completion (for Type 1 +
the restrictive Linux implementation of Type 2). But that does not imply
that the seed needs to be specified in any particular unit. Submitters
set the seed to whichever value makes sense to them (i.e. it could be
the offset within a file as opposed to the eventual LBA on the backend
device). And then that seed is incremented by 1 for each integrity
interval of data in the PI sent to/received from the device. The
conversion between the submitter's view of what the first ref tag should
be (i.e. seed) and what is required by the hardware (for instance lower
32 bits of device LBA) is the reason we perform remapping. The seed is
intentionally different in the submitter's protection envelope compared
to the device's protection envelope.

Using the block layer block number as seed was just a convenience since
that provided a predictable value for any I/O that had its PI
autogenerated. I never intended for the actual LBA to be used as seed
value on a 4Kn device. Initially we just used 0 as the seed. Leveraging
the block number just added a bit of additional protection.

I confess I haven't tested 4Kn in a while since things sort of converged
on 512e. But I used to run nightly tests on a SCSI storage with 4Kn
blocks just fine.

> This looks to be a longstanding bug affecting block devices that
> support integrity with block sizes > 512 bytes; I'm surprised it
> wasn't noticed before.

Are you seeing this with NVMe or SCSI?

-- 
Martin K. Petersen
