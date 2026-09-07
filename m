Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A26472762;
	Mon,  7 Sep 2026 10:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778382; cv=fail; b=OOT33JrskWL2q2zoqk3uUnq4EVgFKdd3DSxkqJ0RFJFXpm79kSUrKHQ3iRFwYmkxKfSpUWS1cqgzHStruqDSdWkwUmLCiibxugsd2wMP7Aa67k1poa7Q9j/6KoCOJcCipucW2hOfEAaXFdEuHjVRyeSffZEjouiP2YBjx17ueEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778382; c=relaxed/simple;
	bh=kOZnslLKzc8ptLBgNlKDmoaiJKo9Uan8dXMhhHrUt2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b8QBSe436HWw4dHiJYsOoe/ZL7n3kn8BJ3FfwY3FJGRnU1b6XRghfUCsC4oUmErT7/IEHC/ZH30kJ7ufDaqQap4sPl0KWTUDkJOgNcqQnRp3hgrOymgvW+WYcVr3bsHt/avRXHIrTJPY+k822ULQykom++leE0hRaKAOuSuwRj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=si3J1ZiC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x3IRRsX8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="si3J1ZiC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x3IRRsX8"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687305JC445986;
	Mon, 7 Sep 2026 10:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=51UTDenyFHghqSZp/iHU7HvgPI87/ONcVKk4stwu/jE=; b=
	si3J1ZiCtuHK+qGHpf1wuQhCfrXcKsz++dMm8prP530bhdnS1YYxzTG8ffFJ9qmY
	8rYqgROxr1B4DYMYOndIrgwAs1bHocp6FkyFYQvH1pZfU03a2qMNa4WyULHarXyb
	k76lBe2JXzFO1sPql/LKwurYau+vvlATJud9KGqggwIW5Y/+CK6/VhrXF6wNOARN
	urVlS5Ec9kx+AAnzPBHBvLChJ2OxM20+VC6gfuVF1oyE5IuNGGb6SwfhxZoylvWe
	wAIGWSFhXMhz73dHohWlaJ5r2XPneVUUPuW57cpsYc/90VnAXNSyQ/WZpiC6yHNy
	BeaXKJuVz9I8UHkt0qPfMQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbdessga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687Aopf9019106;
	Mon, 7 Sep 2026 10:51:14 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aRueaUpSTuum6GR4H6j1oEfD/x8LcyayWa41avTpmji34NvAv0Fl5m7iKGSv2u4HwITfd17gO22UXme9SPPW0TApLutoAT2mLF/ZigpgJREZ/rDf4FMzA6YMPWuwZyxlmYMshOO6yozJAmjYAW7Tuhz/GiauRq4YLwN3II7LSeWmLEenpUqCipNaV9g814g1pEJ7DgyTnJWgO1EHPGWU/+inIlWbM7Ey+5PlxJJcp9L4vASBbiZk16X2pgpSD13Cnavn47PPHnjZgMAUwv9kYzUDjpFRYAAhKmziVUzvMMy455zjTuJ+OIpzeu69G8x893OkxYv3jFQIpMeqHq6+mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51UTDenyFHghqSZp/iHU7HvgPI87/ONcVKk4stwu/jE=;
 b=qlWYH6z+RiXx8U9W9STSaKoKexOTm9bSrGoL0bbvwa4PzunYWwP0AESqfWo1LS1x2LADYRG2PJAqHDqRaTcaF394HF59/PHgav4fkefeZ2597ipc9V1wUynDOwMx3XlMy3cGUI1ZeZfX3Wo6OKE5jm90ReSrNi6GDoL9fYXxoDRS/KWIyE4fKoKmuV6TTtQh/irUhZ1FpK98ZPDW65+dUQza0qlf3IYlECB5PWi4pzbgpwTerJAOf5tZ31NZc4T3KuoQ9Sr2fRbq0k4btbwT3OaeMBW1u5WdCUGA7FN0YcW4GLBbJdAblELRrBqVRi27Rcu8O8IP9HR1C8vvPgUHVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51UTDenyFHghqSZp/iHU7HvgPI87/ONcVKk4stwu/jE=;
 b=x3IRRsX8Rw20LM2KKxBAs6p16NPEQLC+g1ZrWUKG1c1Y2vcViKY5kTHGFINDhdld1FFfDZR0QVwHfm/bMeZMbCV+9gq2ZVhy2yTHdFJLmJjIvt2wnjfZ6K6hAs207agKh7YmhvkUBkPUdR/WPUhZbShZBkhZTiTvgfSgKm0/6Y0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:49 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 07/27] libmultipath: Add sysfs helpers
Date: Mon,  7 Sep 2026 10:50:01 +0000
Message-ID: <20260907105021.1763236-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::26) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 4adcd2f0-ca26-438f-99ad-08df0ccde0a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|6133799003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ADmte9525wZrowCjjYU9nkLQg3KKL9dd99tq/r2+RdZS5R8OBzAJ8H/oE8cWu42G/zpOjPV1uOJ7pNHNgnDS8wZ0ziIMKv83dEIo6ZduMdNcnFBxqOjhRAKBUX0f1jN9cv4stehuhKRn5JAjPRolO3s3Z5o0saoDC+DmFemQC0lF4awrD2rNlrSxMm9J5T599ps1lwW12kj1eAM4wbmjH/UcEhqw0Q5HfXkJBkQ9oDqVyFbHPcv6KecDrxdP9jwphesd7MHawMrN/0ALbHxsg0ClsuxYS0mhXMjZcgSXq07qvJUDTWSwf5nK431LOEXOeQqzGscJ93T2zuIcEeE8n+FLXDbR6tEojo6LaGuhMYSJsG3wJFzkzJsuSEsYzUnkQGoB6A5HcdXVAuQZ51xmAIIvD85Jrff4pk8OrK7Yb27Pdx4xQQChkucrXqR7yaa7Q60CI1DN10XapG/13xGLhzC8AnGG42j4Jllew7Z7cJhPAWvcv73FlRMITQRZioF8hxJAYfWt4LBlepEM/hf2pUJtcWDXoYISLM8VT8+8H6OWw3sY7nQxTD136wN6N8f4qEQxf+gzo1VcawcAmPDCyXJoklft4RIDjptE/U/Wrwzvz7+uwq6DpwqWi6gxYB1XvY7auRcjYafpP0RiAM+Qa2BQqDQnQfmHRinZjpYsCwg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fBLOPAAuVftDh8ahJcWB4WEZBXwPMsZiH8pEG4fN+/ru+PSIREM3wUkh7KlI?=
 =?us-ascii?Q?YAVvj1874xvbtSL5189OdJj0vJO2L8rxD6LY5NRfGaEJKJ34r+8vkO2eQib1?=
 =?us-ascii?Q?5OcGVfnw+CYoBy/n2FRwqzQ7hOfUyOSLFbZHZrqHzzKY3omF1B3GlNlI4Coy?=
 =?us-ascii?Q?3ZVQ7JH6oUaMWtSSyOBZ3eOZQZ3upgQHs9HKjXPQAZue/x5NtBULLNHO70mw?=
 =?us-ascii?Q?Y0moRSxTruVHa6eP5yYrrO2f28MujJYWkxp3tFD5rnlXeXEziLOI7tBIVujY?=
 =?us-ascii?Q?0hxAnP6piTghmAywT1NmlUMyQlz9gbulrnDtCBsbbCFUZWvObA+5QzMJhzze?=
 =?us-ascii?Q?QklLTbe5Nqn2ANXayq0NTtAFUxBLYCvmfL97Gn+WjZDJCbI9ATR7jMcGsJ4V?=
 =?us-ascii?Q?byfb4NtwlSU9QpgvaEIhaM0ntx9zFouikbd3HkQXjGPMdZElP598iuhPUJRZ?=
 =?us-ascii?Q?CSB8CZdzGx0lxgpDDVnZSZkOynajFlkJiI45sy7L0E1Iw8MRiA/G4I/5dpku?=
 =?us-ascii?Q?0ERrd1Xj1L0Bgow3WiZLN2k79qlbUrqW4NrIMJ0y4UwQnIauizkXu5xmtUii?=
 =?us-ascii?Q?McQYiKz30adpIBApkIcrZvu1sCtKMPxBpL4SllshMQ4VDEPO+vWWoWPEcBic?=
 =?us-ascii?Q?TtDUF9eNqOM8VA33oY5skXQ9CGGPbP4X4+nsU+XC8cAEum+oz4AuVEcWiixX?=
 =?us-ascii?Q?XxkpiQMkpSCmfEeNEdS5rHRoa8yHqqIX2Dq27faGAPUuq6BZVDdXtCCetkkb?=
 =?us-ascii?Q?5GpajtiNGPXLCJNhThjp5/JUGfR2cWM5PS4PsX61W44i4y08artfQv/sMsPO?=
 =?us-ascii?Q?VP+kuCKLix6bR+aNnzkJmuRtQX2DPw1YTPXiuY1MTZgyVkxoF7pjPbdmOFxw?=
 =?us-ascii?Q?ZXZwAdN4MC96c0ieehJ+74JEGhvye1gx64ThZilwzsnys02hT1IrY/2w9Xnp?=
 =?us-ascii?Q?50bmP+b0XalfzWmzzR48JUzTche1FgZa0U5vtv2Z3t36eXrAImRZ3/XxqdLi?=
 =?us-ascii?Q?2P01sZGcPktOhVFMz17KbLr3E6OwCRamAp6RozvcTmaavqpGBfEuIrmz3uCu?=
 =?us-ascii?Q?VJWhjB6X90BACYSAXU5AsMDGpNhEjk1esLslfbZaxeA9R5aV7mN6klY5eKMp?=
 =?us-ascii?Q?kqWqqIvoH3KYi5F1Ue++RJxTT57g22mEkP/x50+szrKg5EKDEN4AtbeLQSHk?=
 =?us-ascii?Q?mYmVtwQkl1TdxQyco6ji7T6JjYrGqYjYP7kejWLlmQbFCQEnbRNaTEZo2pvL?=
 =?us-ascii?Q?GdLvJXDJvIWcgMx2lIWG8WEEQz5KDUYVRm21ZKMCCJ/t8dtGVCMvZAvnVd4B?=
 =?us-ascii?Q?+w1GhByB0Wb3oY7ZME+AdV1xr90BDbtGy60EnCZ46aLULE4HAZCnFGXn3EST?=
 =?us-ascii?Q?hasV06wYXlmH8uJYaZOUrCltPOoZcQABjaIXY4CjWg0G8EniSIYh1TDJxPAd?=
 =?us-ascii?Q?DoXpwv6JTjSeypSftBNebMXlo1YADgzJVaI60BhLYQhM7jdUj2Fzseb0UW/z?=
 =?us-ascii?Q?3CTt/oas7wEaNgHiu1lnSQbkrexP88PUsYoxL+Ya7se7MUkYKygh4ZTc7PE3?=
 =?us-ascii?Q?XawoDxraMWHj5YK5vuvQ4b5U2a6RdRUgkWCll8NLaVpdS3640lQZfJDmMqd6?=
 =?us-ascii?Q?X6TsN0OUEPI+jcLt+9WEpsTnDT5+YjIk4+iGLVUesf91O1GuIQThoT1VHYcE?=
 =?us-ascii?Q?RRN7kJJO3EArO3stU84WglxKRJiash8sW3pB8r2CdCm8R7zsbM5QGHVokfva?=
 =?us-ascii?Q?2JQucNtdNQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	xk7thvINRWbSlIh8UnfoyO3DeDLZsJ8UlIdZjr8d/AwqxE6fZtxefkKNUDt5+7q2HgJykAmkXXH6Jhx8pekyF7dnmv3XeCR3beuEp7ymJp7rp/Rq+FfX9HLaTBZ8WyhGvWqIJwa6QT5VVt7wW3Ao5bgCLQUWDX/FRzgZIofA9jLGZuCRVEpCKfzLuvofXut5PqGZ9OdMgmEuxvCwF8pI062FvQT4sGPK9ayfKcXXvGA/Zt5a9ro8V/s0RAErxfTt0s5ugX9gaSNymRIahKpM+KYFT7ksj5rlBwVeSIPAB1k3C1MqcxLwi6HJtxEewEcqB9Pw6GGIdZXauJrAT3CMZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YClLcW1qBHyPSbVtrDWYOvQI+7thufSOG9v5i/Reb9a4zZwslv+NIZ4Ax21lwzvNwK7qn2EwwjL2YRcAdeKriU+1vg4tMSWgJiTTCwimSDf77cx3aSwaAV87B53pPtH56E4Q6lCINdIO1rDKFCqhJzXaCjl5Is40jKFRtQtt0iSve8cfusbA/OTXuvatKifTC+R31BIyo5ERHODQXxlb0aCJjLMTLUXOvkT+jbRrBZWsSe6Nd/nK1RELICuOTR20cI5um+VsszqTPGyWGMBjQ21ly48kh6zlCzrFsxY5l5UkArApjzmjaYgriGlgbEqb8IY6vL2vKxXxkj5OP62djrkSn6cqa44pUUcR7zds3NbDN9kC9fPsbCl9hObwDS25fNl0LfXTUPPYtWGlmq9Br2xjjJJYPxSZbbRXsIrepdjWEQzjshFgEmx0y3MOjxscLkKmDZktrF239dpW6UVlecoQmUtW9zc7AGRYC7DTc/nWBlMUyKbm9L4xGZdRUfOCIwaqqWogxzGEI3t1eQCKCc1KCszfj0i9uVcR9vb5z2OojWreyN8+grBS6uFSnC9jew22T2bj/LizyNZ2WwcKZMxX5w9WuZcmwIfvHQexgM4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4adcd2f0-ca26-438f-99ad-08df0ccde0a1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:48.8476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5HF5UR+jPWEfomaKU0c5OOmqtwNXOyFGyYY9riQeYCIbQPjUOQhrCfXqTUZBiWQ5Gw6ulRalABVl9RVAuizYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: 2W5nqIGP9GwgSGM5zrcUzW01E8a0zWEv
X-Proofpoint-ORIG-GUID: 2W5nqIGP9GwgSGM5zrcUzW01E8a0zWEv
X-Authority-Analysis: v=2.4 cv=R94z39RX c=1 sm=1 tr=0 ts=6a9e9724 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=JWw5DRbbQmmJTouRsXkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX4k7sDo3a7YiY
 9L9eZ2oGtyWEi7d6loofJxoSfxhfGrugmW5toCHyvNN50xwMSk9lVkI+eHOYWMWnVkaEpX9jeRb
 Xih+37K5PhMpDihP+ZRy14lQ8TR4Ssb4mp9G84t/Y7hCP8ayxV9F4nqaatfJbeOSPw+QgsxBWhL
 tTYluXyAJXqrKKBI2Ph12s3HLms3wn/dqvk9Y7e4WEZ0B+UlbkW79dB4Vh8ULoe2gQhSHgQpOa2
 vVlZbNNzpD/m+pBsHvUAcK4yN4GnH0I1Ry+3iiMBTl4EjfVRkDbIQte/4BZRq1ntQkfAEzfcwkB
 mG3gbBwIxC9Q9jNvIoa+TEwEny+2Id2QPZ7ufE+MqA8bSydxJ4zzD6ZB43GQpHXsHmP8NJB7nFd
 WBZsmPBCqEYhBuMYii630bjUgrZeXWYCXR25eAwVin24blB+5Mq1Jsolrryg9kHU7rDoBpRls5Z
 3j7CQplEshc6SJ2l5wg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX0QywO/gvE4V7
 f+MSonGEw5535wn0hD62MhCzusK9uo2E+KeOJGg1AJ4QfZY/334cloYb6+ugJX4bAvPuRkYCzdP
 oyhvjJJGfNtlzxKZhX+CDpnB34Y7iyAxA9Idb4Qv+v3iLxpB2/Ok

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
index 9fcf0b743f0e1..2bcad0a9fda02 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -619,6 +619,100 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
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

