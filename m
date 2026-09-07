Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42224479875;
	Mon,  7 Sep 2026 10:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778314; cv=fail; b=YqSBOb/SNToWQjHyKoVnlj4t6jTgTecQvBaabW6GW7c6YT02I6FTgGHN3ZY8z+Gk7hb2HfBqv5qzk59tN88TeQbnCiFdyKrRoPsE1qw3vuwdKeXNuc8M/BBJrCqw7J2l5MQhu02IVM3BsdInnWSuHqxhKYHYK/JNZ9anFRyosh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778314; c=relaxed/simple;
	bh=xWVzKMoCXic7ZyE7Ybw80e0bY7GYGYOkCGTmWHw/UR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JpkjGB5AqDxg7oQCvoQpRkHmTUxQpzcZBLPI7qAbgMM7I7+jI2gmbhe9crNvlLJys/pG/L2WLRneGqZCdhDXDTBxQo9WVqmOUW1fy+IR5yt6EtrOeZzVip3QWtc3a84VRWsBbItDZ9iJqI0eqBv0K0E64ISVO2EFis67LP0fknA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cqU7edZ5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qjsoe1cy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cqU7edZ5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qjsoe1cy"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686Ng5HN187870;
	Mon, 7 Sep 2026 10:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gx0Nwrq8SF+b8bDDMAsIxDoC5NfsOaqt5sGZDxeXuyU=; b=
	cqU7edZ5s4ezk8LB/YwttKxac24seJWQbCDwjAUil/eZV2DQA3UaOcCy9J+uRWBD
	GnplrK4++wkdCNLBMKR0JlGvcN8XTfytvf3sUkPU3Cc16ZpF/Vm1b3T7idRKpTWm
	HgYuPssrqsDy3h95ewXmkZK6jYZCRXKD2KugAdFBlJlWK/BcoiuXnygO1coE5LE9
	0hPwYd5gkwAxycILZ0aZnXanZhu+y2yijSoLZcdYSW6iBrzKBJrliUJxyU8MIQtm
	Qn49N8N7IMTY5Pe69LKSudV5ogRWgEO/jME7Da0IFzoxSX39T7zYb3zQQYrSO+wy
	ssUmXZEcMF3ORZY5D1cMVg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbgvssfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfJ019106;
	Mon, 7 Sep 2026 10:51:20 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQEdh73apjHur+3UbsAaijPV22mtNDyKT9p+WiG3+a74CaxDWVctcJec+QRpXxaDLcuF8nsq0GknaqMcivd0msfkg60fxNVUj0z9Grw0PsKvLsbyIQaAnzY4pYzlJwU5z1McveGrDkl/kS/N8qp+TWdINIyizRxoy1uKWtd2EAZaCEdjmA2Sc2fYSU8fHUpj4s+Rq0/a1cHDnCrOYE8Nq5HY0F414gea1NEteYdlPCwB2qXToLLhnta6dcvMbpcKZp0obB/PP0pjzZK09MCGMsV7BcrJrzr85FGyKc8zDCXocOwrCxvpThHxwFNBvRuNZlk+RSzABEq8MoXIKH0sEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gx0Nwrq8SF+b8bDDMAsIxDoC5NfsOaqt5sGZDxeXuyU=;
 b=gVio98tkTEo+jh5eLZGC0oT25vpAli5lmVFfdrqDuzSCdq0FvgBQOOezGFFoKrpr1PAmhw2qzdve8VvxJbZw41CWDWzUp/5tChQxgg5BAzeqkhVihzmnFnsIOyQadScStvGR7MYmF7a9faevODqHz72dKmkyKWgCIttUO+NN1pwpq3cQG6K9O5/+uC4mlqDpsQj695ups8mSTvTINqkweS28u6gric4WqjWSxi2icRDlkOuIngX9viI7vEcjCq64/KeRZHZT+UrIg03AhyXFN2obGcGe+P0EeRqGzXFKDjz4BRp6FtXEIr3y0sPGR4lHAoGlnOkP9uYp0vQd65wtag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gx0Nwrq8SF+b8bDDMAsIxDoC5NfsOaqt5sGZDxeXuyU=;
 b=qjsoe1cyztMXSL6tM2fJm4xuW2SA8tUEwpkz0DmKyfsGRHbl/N/xYKDAW5c9rjkdNx7JOy+p8Z/Sw9Zvnf/MM7wT2iscQl2+UalhM0gVSo8waLz4M3BumdPGRhhgGbftRo2rxRIcrweLFEkem9wDcgnElkS1PKcBOrLZQtM7v5A=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:09 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:09 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 17/27] scsi-multipath: revalidate paths upon device unblock
Date: Mon,  7 Sep 2026 10:50:11 +0000
Message-ID: <20260907105021.1763236-18-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cde276d-1c12-40de-aa39-08df0ccdecef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tUo8PxdJv9rOlU6hnk4OIycbGIgb23o/2rEmfC3uvyYsB8BvLIJfQk3pWjDIumDiJDd6EHkwWdXiOPC43daVZc52I/TDjdmG3bScvp0+NjUniNRWKCXmdYFI1Ehv1hW6r9u+vlP08z2HTpBgQmsp9hEhLGr8WKEr9tihBA0BJPbP1qOeKBiZktN24PJu5VUkWl4fpIu4UicGen6x4XLgchawUa5QQl1frcu44/X7iVsi8nWF/QtSTy98Di5OYKEq3NVzg5/mZf7Kx1wxg6HN3NdxCKD2HYcIFbEWwCA9b9CzV9wdg1Qh9QByR1qrHT3JJQ8+JToMFtCCZ3gisSISadfkpVBWeX2HWWh9JaDZ0IO0CaeElMMIn+rPFfbS8OR8WOoVtNB92+5CpAKJ0F+mg0dHhN5rrPDX0MuT3/Am4dijqPpn4fv0b9Ajg/dqcdfPjJjvL7WSVdKbXQ0AJTDZ0S4FUzofVHcjcI4y9CtCu1qXMhqGertKesgLwhmiWlm3QYd2jbib6PqGaJj4Sxp5rWLovSpO2CxPZXSSmQVuKhbt4TbiBSuXZ2XFSh3wSEMxpi/IX6DsHRdd3rbMYEJYqeDjZdbfXIjNjY/Fi4ozxRFph4jo58NlOvsKD7q8HOg4K3wlAsKiDgn5nn3/57ccGHPe1w5bKlRuR8GuOIV4/cs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QbktVUCO3UrunGK+4QMK8iiP0VdpNDBjKsvQJCEzUayCsuaepJCwVTkjn3Dl?=
 =?us-ascii?Q?YvtOlwhYRL/b2WcOMYJyHGjp3JFZe0or1B3zNwk8uqN794jb5Ha/750a2m9h?=
 =?us-ascii?Q?DqH8HsQOAvwshYi+yuWW4KUdJYJTCljuB32G4rfCoPWn/5lrgvgFENmJM+dF?=
 =?us-ascii?Q?HVHdNEKj6hfppVXs4akJcppnsfuYaaG4eO5bbagbOnGkBHbm7bZBZ17ByYOL?=
 =?us-ascii?Q?8TfDUJcZoafK/L9PpatbF8SHJ+nuKIQzx0RrsTkjc9j9DVzsyCfvrrfI+25n?=
 =?us-ascii?Q?4N7vl4fo+tyr/YJS9a6EXYUoF7TBvfFT+FarPx8UxAcc/BXL5f0pjlc9NOlQ?=
 =?us-ascii?Q?9lb80OqGls6M+z/S2X7ovjyXXtGjv/PguoSfuBmUJXUMGbr7nfxDeaF/V/mZ?=
 =?us-ascii?Q?kHgOMeT1Jjze5LXZ8dLTWDMabABT2bm1kkaSxlE6Gntu3K2f1ZyQxNboG/ur?=
 =?us-ascii?Q?p5Fdwl3mPPzTDEn7s/4DbcPsi1F7u5e0e9caiFWaLJTXDV/o2B/TgQMmwddN?=
 =?us-ascii?Q?XOspmDvQVVSqU1Tj0h/ay5gMuHu4fPk7zoiadU1M+eFcpfIMdk5wfOex7f+e?=
 =?us-ascii?Q?F/UV/EhBSvDO7kICifrP3X9CVY0joqBVDM34uMek9fUgNT/+CQXDMj8FKqt5?=
 =?us-ascii?Q?3chMUl1/so/ZmJL/ECSTBrRhYVPaiGt30A01UZKzkA7PrzUli331bJuJiW3l?=
 =?us-ascii?Q?KuUlud21PLOTb/Qfe6os9oeSstl34Fj/f5DlrbmuneuiRzs1V6iAVE8ci+L1?=
 =?us-ascii?Q?GYOkGyLJAGDDjujfpNFZ7evSY0gJPe7YEwZ370FGwqPGSjopVEBVGP03QJMV?=
 =?us-ascii?Q?0LjS1ZhzC42UazYorIk5LSLlp5btyBJMrJEjf+p9zAh3WOIpv8BVa/eIXbVm?=
 =?us-ascii?Q?VZFR6vBPHPVXGyECxFnqMND+UEhEOkv5Ah0uiYUXSAjsklSig1hUhyxNQ/d8?=
 =?us-ascii?Q?MqMe8+7HWEvaa5sXAQ1/oregTQYcf/ktlMwsVSdHiiw6BdiVk+F613LAXaQv?=
 =?us-ascii?Q?+1yjuJ8AhiFQ4HgSYkLHjz7KDkbT+R3Jj/ksd5wfyDAqDwIKhza4/j7gvdqk?=
 =?us-ascii?Q?UYlXFeHalP7GivKvSJkYw4KZf/0XSx0mlDANKm+W9tnCcdAPNOeWjtVuVqAz?=
 =?us-ascii?Q?V96lGNZEryOC8EEoMFyMwbHSfEtzdu0/fPvx7nEXo9+soQBiu04Cp0AIAG3R?=
 =?us-ascii?Q?NhTXYIUvaata3zptYc+ThojR09143xPagbGLVIaZbEOp3CJUEXV4+hO2c0Ge?=
 =?us-ascii?Q?ZwfImECl43Ae9JfW/+/KJy9iKv4YXXAwIBv9acXt5assh/PAApBirpqAxTg8?=
 =?us-ascii?Q?JsQ0cdVnZio0hJ89pCR7TdEuHB46jJ2RO0Gq1HHqO2dg3ZX59eiEbdGeSNZB?=
 =?us-ascii?Q?3LZ3S/u6WAe/putoqEvYTtCjOO2kTRfHJSOQyVGm5FNv9FSKOJdOUj75zEDD?=
 =?us-ascii?Q?3s2ovHcRgwoaiZpVjFaxH7uLHJ4fByNt5+G+L2LuDouVEqd3FC89LIO5Barl?=
 =?us-ascii?Q?DhOLrrs3JqXZPJW+2v0/P6kH7n1hvDZFwn+LR4QwUtcWXtympjxK/+0/U9fs?=
 =?us-ascii?Q?8/ZP3+89Dqw495fenV8U071pz/Jv8O8rg5LBKiecaiE7ekfJtd0aPjNPkFUa?=
 =?us-ascii?Q?MJEQKBWXGCUIzKtm+8A7qpxzScD4CpzT7VaHHJiAHH/N7vkiN1/virv5YdDF?=
 =?us-ascii?Q?NEQX2Sj2n/hn+WH1asWh/wSJmBhQVD/otiyJhWzt+HMxHD90lLV61x8GmQP1?=
 =?us-ascii?Q?qif+bqQvrg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	rxFQvIReAI0O0L8vP2OU0CoSetwNfrc/izx9IQDobjGEX70q/Qh/r/47hFNKcVXqJrWZrlp+bDSX+L+qgSTVMaz/olg/tP6cFQz8IWGSI3krplNFAtDWo8jPALKEjc3cUjTKPg/WXjKJ4C4plQx5vvG24Bhzco4N3BsKrx07Y3im1qV60d68rv0hwYApTT3xkO2FPsOf0y3dh8e1vGNWJ2CFfE6qZ0n9D7MwYV82wFXUgU47azr375gcQu3hK/FU4qwkH0x1NZjx1oz0Gixhx/Hxn6y0UvsF0bp9FyrpzqijbnB/JIMCGph5lQm25YFI+INhBL26y+P2/SbpkX4NZA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lc1VfLrVVUlJFz18F0i/kYKH+hn3t+ZOQIgjAmSQiNi4JpSlFxaSAVdweY1NWCnLzSe5yzFbuFDdvn5INpIwjsiWr8ZUfJucFLll/fA4MXmrYp/DdTuJcW9W0bJbWCWiJZCQfUi0iGdJl/E2ZVCuc4JZ26p13AnWrX0rIhuKiKpdMfaSuwMBsne6uJcEaEeGEWyH5Fi758l0ANYp0XOXKWesiJKhfTppZZFajbFjXFAZ3b2K2iq0ptIRitBXz89MSZceaYUtgjHTY49P6OfcvV+YPOlvNTOdOBNdQFD0ajb/5sTtEylVNtJqxzGphzaET1sU4rsqfKiXd4JhQen0iKoQhgWBWDv5gve4aj7zAZaDlVsCD6pbKpv9sp2j3SQlpS1VL+DprB47MgiYVRymbJxZ4+rwr8gf32SpUeXn5JmejqDWgPzpwzbQXAFBPPpCbe6p0aPtGgTpNcaeIVScg4YnNe7C9VG54Te68nU+d3mS0V80dgRkltuZnTUQNZSjdcbDwtdnYaJzEBOCDYhicuiXjA5B9rOuPe0HBqDo4LRERNXJ3sbFn/qzgcDIdNSxk5wycOdvwu53sl+ePJJzdC4jePGOeUIyPyZNBVzqVpQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cde276d-1c12-40de-aa39-08df0ccdecef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:09.4288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqLEaPsC19g8FDGh2iMrYDQXvj4AaQOl/5yg9p7LzyMJOgqp3wDuBh2btmFLaIiPhCfxUOqDe6bcvNBLPXZlJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=921
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-ORIG-GUID: S4A8AGwpOS0OJHzqssYSZ_ql2VOga2Cp
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX8saCp7M+dmR2
 H99xqxp+5+IrFI5aeDfljbt4Kn1JE6HQ5HvC0jkKhgEJDkxbo5eP3pocMctv8m6DzAJc9x6QGo8
 U7yshKcR9kjMH+YsDuOXhOhCU0Tw9IxZH2Xjco6e2GmvQFR0Y58S
X-Proofpoint-GUID: S4A8AGwpOS0OJHzqssYSZ_ql2VOga2Cp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX8C0yxIshyYpm
 XIWF7OvHNZ6KFM47tbskry/GiuR1wDuAyzV4xchSdJ0kTH9E9m6J2+vmZ8vxpVJBf5vIKjdUeLB
 vL+Mo/M3bY61Dg3ZxJjy2yCybHO2Uzxo6I4o+5oiIGRac0evDFNFCHa3lH6d/SE7M+bTm9GNdLz
 WLYxnmfAt/toLa3+ltr6P7Q4S6UkIGME+ndjBEQCC1tZYdUNpCDu/hEkuJsLEmcZ+S+w4ow7mW+
 x/35Y2UVtIr1I3Ayxjh/Bg7IDPzKwAWLOliu228ozLGorx5oSZvyAOM/5+dID4n6fxgOPUBUIFm
 Bjl4OgUx6ipjrFLoSb+Ht7XMGfkfOJaZUUjgfX9oHM1ckfTzA72BK44zsRkbQzZhucOnKN9IPJ0
 V2Mm+0s49dLHgsxiPYHoAwLQNJ4bA8ed5/NLqXEbBzXP8xs47rC0rJ8kRT4sSJCsm7Niw1IaVLf
 sq7U9edEBahThzB8O6A==
X-Authority-Analysis: v=2.4 cv=Td6mcxQh c=1 sm=1 tr=0 ts=6a9e9729 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=dGdLxrnxUM9qrin9hOsA:9

From: John Garry <john.garry@linux.dev>

When a scsi_device is unblocked, we need revalidate paths which means that
we clear paths and requeue any queued bios.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       | 2 ++
 drivers/scsi/scsi_multipath.c | 8 ++++++++
 include/scsi/scsi_multipath.h | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 56200a7f5c748..1a6f5e1fd80cb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3093,6 +3093,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
 	mutex_unlock(&sdev->state_mutex);
+	if ((ret == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
 
 	return ret;
 }
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index b16fe6a55fa73..456351fee4b98 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -238,6 +238,14 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       mpath_revalidate_paths(mpath_head);
+}
+
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
 {
        struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 2064a3e922748..6e50da94fc5dd 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -56,6 +56,7 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -104,5 +105,9 @@ static inline
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

