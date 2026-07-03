Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115213C9EEE;
	Fri,  3 Jul 2026 10:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074685; cv=fail; b=UffKUTZfWUrwchy6uEnU8twLYYohkCXIRrYz+MiTX8tw6vLhsuXHY5s06eTJ6DLd1C4meJTrQVYR3X4ADe/xTOrnaHg6xHufBBlukGsZAjmVeTHsxQnQkulg4bYyHwL6cDzRQeeOvNWodIj92yjvUtn8rj9qfEIjKNyHm7IhOBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074685; c=relaxed/simple;
	bh=LajdnX/Tas+CfkXT/PabuPoV8EikAgAec+5HLpwpbFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hAvqBf5GciwOEC8Hg1m8/+G6sonK3UgRuCguvaEJs03gygWDnQCwmvIJ8u/PM3jkrmIhNNS56paXFzjggO7KnrYjGE+gcLXMeR9tkZ79hB9vYfmFHmtU1basHkDmYZUs3ZYHBdHhJCrJlPVhlBR60Z8CkvsSXlyd4pLrnf345gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B3X4F1SY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AoRGKuZ7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B3X4F1SY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AoRGKuZ7"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tgjU3329475;
	Fri, 3 Jul 2026 10:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iWVhwrhuAdjp4z0EipfAo6LSuIGX/lWOKtVvLZcUs1M=; b=
	B3X4F1SY70lcKvJTbFEZ8qv8tBfg5xOvHi9hLzjuLXKT66tPdeWHT4v/mDZWAXcL
	MtXHtVl67GEj4jGVMXsx1LJjd8DmkUcsEiSfPPvCh94wbv7rr3tJz67knc51slGH
	KSBUmHGQ7SHtKOm9SzbaR/r5vB8F0eib5ORMr8JTpvdpmPW+OtDyx3k6xATrpsRA
	o7WN60oeF840j3SuaXQ4fOhYpXl6jZ1tZiW69Gu0tsqro0apvOCJgfbIij9k3zm8
	7johV1LA16wmI9B2Rw+7Vs5o/o9DIoeg/Pply8dwjmheRc5tYYUGIQFPg4rH1SyC
	pgeY1ZgYbhOM1EuNeK4tqA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26mkadx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663ANThD006306;
	Fri, 3 Jul 2026 10:31:04 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011010.outbound.protection.outlook.com [52.101.57.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f3u20fr2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BMZjVqoLg0wR5A693VVf8Sm70P6Et95ufzwYBMUTzAHazzoIK//WxPrfmXuW5A8po7IzVx1vy08ii7K0Hu7Lqd19uuTjhdsfLRTmfS4PN8WSnjl6ZWhCu2cmHkzzw33URgq50dZNTVWuwUa5yIvWRCwh2sujVvLcW2VCxFnyzygpBkGzZjiFIGtfxfybaDZgjsAlZ7DEXhyXrIhcL0xFZRcoZDxqv89fxXHgWJpGHKE0J9pvFnFeZg6qoptWxpGgiApx1zkw7ygj6QasemV9zB41pqIon36WqTInMj2EuJqKDkrotfNLCju6hw6/AOvCJJSK2wp5YigPBwwFMGR7XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWVhwrhuAdjp4z0EipfAo6LSuIGX/lWOKtVvLZcUs1M=;
 b=TvSN5gNhnETPN8CQneo3gCtTTkSEfe0H+qiNsoXArVFMitxVjDugC81EXcOM9gHGMn03EDpdXXumacsAMKT8k/tXVNzw4CJ7GXJdhf8LQKwWaDpoeqRbcfovvOtunPW9k7LXGzU4sAjm71Y26jmLK/A0zq+c8zY6ORmEFxBuLCzkZlq3yMLAWxhA70igUk+uz0rnoR0NO/kIQ+/F3qiVcsRWyQgiqBTJLcJhokOnodDWyiKirgpHgIgjOuQL3kJhLpuu/U6KUZy3yf/sy52hM/dMT3Z1e/Luzljoi02/anvxp7GIZGnHpChda8bSpXS6lTbf2dv8SboGEjv+e2ri1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWVhwrhuAdjp4z0EipfAo6LSuIGX/lWOKtVvLZcUs1M=;
 b=AoRGKuZ7NZvhFXEtldiK/z2RKw2ssODgerPS8KHQWwBAcMIVWDOSLDUCh+uSyss+dMDdDdmS443hedJI41/DrPpYg1ps90Une1gB2Qc9NJNw8/1ANujhp0kC5hHvgeaHT7Pg9sfpj6EU5wxYpd+lCc+vb65rICbrYMveKmCZhWs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:31:01 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:31:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 10/13] libmultipath: Add mpath_bdev_report_zones()
Date: Fri,  3 Jul 2026 10:29:15 +0000
Message-ID: <20260703102918.3723667-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: edd63e19-d2bb-47bb-dc96-08ded8ee2d87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	e+we6SozpjaN8dzuNrO8ULSAnEXpSUZCPNX0FtLku7jEscLkKk39+lpBYgmua98Fr8XdZWjgZCZPGLr5ILu2BXvgzIPoaw3cmiUToh8BvjLncLqRFb9MD9y2wlmO+pZGsli6yzUISqdvsny/6Ze/M1SVml42II2l9G4qtTXjYJ6AjSrKf/JNW6S99vLE2OcfJNsR26CDd8iprW8nw6sSlkYH9T8qlOHnYPytmbMePEg2K663O2QXjYMX/EDId7Fq2WzXuHxFYHAVUZAcZZDqwxV7/NAZscPpaFU7QkcXyF/t6ELeuw8K7q2sj0YjZMVXIvvyVwqDD/8pvt8BZIcINPRxUMD8c6Zxfj5h8RUbTxrp41n8/VySfGFadYuQ/1YED5zEQruR3aSdeyQR9Oc+qJnuzY5WlW3qUkwPVjOtsWJQByg1ZjHxsmzcugTdyrLqOPb2kgbLh4cPLynHVicalHb/kzOje3IS/LQdbd3Pr8ggyBlN0oDvC5mTgBSPqShK3816rrUD7jQ4YhqRRzgFKS5kCJMhQhTU24JP+ia9jbOnWxWRsMkX08ijVJglEjl0LOHBg63a5nuhub+Z/GSencTgMKeCJz+lBkgTVjb2789tfsbq+j48VBF5XI6KhnVjQIotrdGVfPWbORO6VL4kHNwFD0iFK2VKkS3kCcpwQe8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rsD1nSccneO4BkCQb7H1WuixBgCZRAK9HjhIHMcHo1bOcJTNLRQSUeYJ93S+?=
 =?us-ascii?Q?usyP++USrvUWXa4sdQCaSdtHqTBzPdR7RicNhXnmvqyb/HmdmR5w0EAfTWF+?=
 =?us-ascii?Q?xURS7hPOlJcai/SmTP7O/tUONDurAm5xYoZ1MW6th6BG4AZZ9s4L/OdGPIcs?=
 =?us-ascii?Q?jUpK4/nA0KiQ+wNL20JVBJFlc8H97WGJ/YQ7tOqOKP6/PTEhsCoV7tCZDZPP?=
 =?us-ascii?Q?dOwzZJM1GpQECoDcwfNwFBHcyFY+UzYXS1OJw9De3lAHfenN303by+dbK5Ka?=
 =?us-ascii?Q?/68XbMeqtlZ/ZWfs0D8CRbv3CWP1BZerVuadH2mtk4svMY7usF4IUbCBQgS4?=
 =?us-ascii?Q?mQi2wpdEN+MteLuq3TXZqQ3tj/Wps7yXxuRjZVNmCWv5YdXqKqFV+uXNxf0T?=
 =?us-ascii?Q?Y5PvWAD3HqkUvUXITGA9Vw4kuQNyO3YsbSHefTO2idcxs4ITxvm07MbmrLl8?=
 =?us-ascii?Q?HLO8dzrPPROp11Kz0SiQjf7hDzzGsXabuUL6/yMSeRoknnul7C4GarA5yDlY?=
 =?us-ascii?Q?HysElUSoAbXK3+SFuXhI/IuSAYvqDQQ3utU98mQxsAzWwyhmMDz8DE4vTJib?=
 =?us-ascii?Q?w5qN6H7JsvaEgLb8ZGf7iMzDci+QcV/SySnTyrJrpQmtZb3H2CaMiCoT7h1U?=
 =?us-ascii?Q?GvplQ+V325WPHmbqQHhaX00Ci5r72etEflaZ2Z8DRxGXxszq7SeXeGWaPKDZ?=
 =?us-ascii?Q?EGUFELOUA3/pyLTeyc7KiJmvaFeLokXulpOD5/rDLS+ABePj2Iy2QLrnZL8t?=
 =?us-ascii?Q?bUDkZ+tWUisRTa8xFla8ziybNJLO+xKD7zm8CvpyYAzYXqt2YET9aDA9wRMp?=
 =?us-ascii?Q?jBD2IcJ54HwCu0kgMLneR+MeVa88hc3tWuxc4VxCvhQASKOENk0BesMV7DR3?=
 =?us-ascii?Q?qBoIxFmkB2Nb8qoEz18xRgSYPsdag76cjykGQxg4JT7AolrTFT/i+GOSYQzR?=
 =?us-ascii?Q?sepo+j2sTwjN7ascJAkWSrLx5K6TPw8SUVr54YOkQKv1UBckxcuhg49+pCXj?=
 =?us-ascii?Q?yfkwirnlp3A1vKP8aLdJaO0LX7CbLJdkw2dh1yhHnn41jnK2J8HhUEpze40c?=
 =?us-ascii?Q?5oewaU9OkpV+FVbvwZlj0AMi75cGcf7RO6exd5XiUExKXVfGWrtw74lPQLqv?=
 =?us-ascii?Q?G/09+kq81+OWUJUHczl1HE2GIQbsF/oFhn6EKD5V+4mUcqe8nHkMqfBzmZVz?=
 =?us-ascii?Q?z7Eqs7K6bNP6ugj0Lb9iuATEaK13OnQ50nE1cq66L2O3B1UWRFNaBTHXvQc8?=
 =?us-ascii?Q?56E0C6Jnbxm2adHIhowEy/AXYkFhuMud7Ux1+hFhp/2Hb0l1Tgisk0bhMiIx?=
 =?us-ascii?Q?jeHMt3D6YDp0R3dQZhV3Kw/0vRmU9K8IajHDQu6/d6Kr5JTV7uASXmKuZ4RU?=
 =?us-ascii?Q?ElMg8spttNtKRx88BOC0jUnHx5oc/xvgY9BgI7JoqpEGYtmyzJHWdQdYygLx?=
 =?us-ascii?Q?DOAKjtZI8lAV7/wdJU3BAf2HIi7Yb893OPO+R9RB8qIv8S4KXXrlLbuyJpls?=
 =?us-ascii?Q?/Z3mfvZzK8KbmpQHEfwPpjIqY/HCrbnteu2fZg8eNOPCabd5na5+ZWUwL+S2?=
 =?us-ascii?Q?+CvcPh5fXPl1oFhhZsTOOgJ1dzVoYeqgE7fWwY7OD+aQI5tEmuN+6/m5huSF?=
 =?us-ascii?Q?7MucCXXziVAlgdbVpzQqOzkJ+SFQpDeLJsjO2QCfoL0gup6oesO8EkSecUMi?=
 =?us-ascii?Q?qJa0ydpWSVtVOY+x0YMmnag7aCuvYQVnRLFn4oknvhOEbY2BRK7AM6aIur3s?=
 =?us-ascii?Q?7nrfW3QevGmH6ixQRfDMAR17DdRI1h4=3D?=
X-Exchange-RoutingPolicyChecked:
	lXlhVGDeRom3zcHXyJntoUGvRfVN1nM4DSYhwMyVaOLqxbdEqVtders52d8hz051nLIYjLchZVPWLj4hVV2z5YYAdi5zsB0zFBeoNdxkS/cMV60rvwXg+d5zlwAlPXgMgxRwMIMcvr6/6NXgUORqqtPvKWSdck0SCrnlb/a+qC79TSjTwIHX6JznkbBSa3t+arTuG1v10ROmIvJgztl5dHB2y7g/THqWrHsIldrVcGgscvOlmXMW9kA6tMEUAIOUPtN3AxmYtaWmgPx9iqztztzREUS9hrxWwvxKSSX1gnRA+tQiD0HdIuiqGYFMVsMudEhUIlwA49ioz4Bd4z9ejg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1yxC9SeZarvFLrDBWp/Ju4LueCIW+IKoAfsmgLnxWruO70MlS1oTBApHuH1hZb/61/+HiEBHyR3EeeD8BqQO2vftiHhWkS2rD8BqBoXEQRLRmO6edr3eDQgW7Yja0Wl1RcUj2nu4jJco7lvq1eB0D5fw2wTcT5qaUYVDFwSJkf1NGiGFCWEu/cnWBxExJVuUeVXrqP6U9anFqsduttEgtcnu6PokYAgRh0VUeDgOdDqH/jARXYKzhhowPIzk8YJ/72JqTInRJYXGVcSEOtPnUAWl25/8xifsxmYaCIuw22502GlxrqOcZCD9ZWkzWAwpAOHnxJQPiPleKWwZHWbNAHkVC7TNKTeOEzYJT1E8NmO95jpnl6ghFSp00EgiU/9G4/eDxDekkPWhgcL+xCcr7SWMmnqWeXIJKk1HJqCRUKXCB1YniL7UhmQoakEe/pv/FjcLpTljLmBfABLN99BV27uh6au/op3jabeQjzKwH3GMM87wCWF09tJh90Biixl7+ZvSqbAUF4waUyYEphO2Gqyrxx5SjE6FAcNXw1yu4jZwy/pu6alwrzJ9kxnXb3DQGE73gPAeEZ8kiavNkKzyA6ph3Fawpx/RkUWervoD6Tg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edd63e19-d2bb-47bb-dc96-08ded8ee2d87
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:31:01.3188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBMw0veB6N026A2YspS9pun2cvwwxepbssu6pngpf6f/Ae6InDP4pXg8SZP24rrBdbWZexYkpOkE2UsW85iHGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030100
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX9MrKK+gRBGL6
 mbeagS8gNvgv3fz8Xg3Y+bxHtV4NF06vHfaIrimklnPm77Z3ftltr14ZRojLWNRLSbpZQpq+p3s
 csZkBkUh6At8mbofge2R46coacFR5DJGgx6eF1L5UZkK0dnIrk/R
X-Proofpoint-GUID: 8Q7cwqRzbkZxhq-xbgz_ncQUyNsQfAfW
X-Authority-Analysis: v=2.4 cv=OKwXGyaB c=1 sm=1 tr=0 ts=6a478f69 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=hSvAkUGrqjTGy68UynwA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-ORIG-GUID: 8Q7cwqRzbkZxhq-xbgz_ncQUyNsQfAfW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX5ip3fgO0vntJ
 tFRXBqYi30Fz03kWqSVhP/MUfs3R9vUjxQqX4rNKQfLoc0RyboOPrL4fArHo0DebYCZyi6DQY2h
 GGkjrnBizZ8H3XX0QICovzy1D3tKOL/XmWlaJ7lFR/DVJJJf5a4ABvepGPDSe0yQhc5b0e2A7De
 oabtbC2qbtDBGX7WjSYl46Q2di0vHTcdQZKVgZNX88rDTDaVJCG16nU8RAIIqRKY8CrD1uRUCf8
 GZb/aK2ByP9Skrq4cK5OQdKsWPexu2M8NtLVrsuYEhxhNinHS+G6SKrAkFccWmbDYccgQVgH9ru
 w8qgDTBOJUEpkzISU0onviugrKCbBSscWuwTgW4Z03lhTyQjCTta0rdVyruZ4qbja65TyE+OYip
 rA1r2JuwFAg6snavYddmZoPARJ1l5WZVujbkcR6tW0dYodCUMcS25FCwAKB/SFt9fWbiSUX8ITR
 TXOEl1WnN4mO3Uo93RYH+AQUhQMx/2IEL+o1SqXU=

Add a multipath handler for block_device_operations.report_zones

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index cec7047ce7b9b..d335074eb5bcd 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -44,6 +44,30 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static int mpath_bdev_report_zones(struct gendisk *disk, sector_t sector,
+		unsigned int nr_zones, struct blk_report_zones_args *args)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->report_zones)
+			ret = mpath_device->disk->fops->report_zones
+				(mpath_device->disk, sector, nr_zones, args);
+		else
+			ret = -EOPNOTSUPP;
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return ret;
+}
+#else
+#define mpath_bdev_report_zones	NULL
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -677,6 +701,7 @@ const struct block_device_operations mpath_ops = {
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.report_zones	= mpath_bdev_report_zones,
 	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.7

