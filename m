Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99DE3EDAAD;
	Wed, 25 Feb 2026 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034076; cv=fail; b=Ps5I+RlVB51bf5d468zSahWq9zJhACaOS2jNPnNuW2hlAfjyaia/TY6+xHLE+0M8z2F6DO96VUio8fq1E9T5do2ihlQGWD88vPg+FxYOzz8RpOTWRT0xsht2wYGqaaDf5+pnsfg6CMDD1GPVz8LGpYtMoo59/tes9KgETqVS6Ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034076; c=relaxed/simple;
	bh=kz8FWk+HRkw8OKuuLavDc0eiwSCLSQ2KJoa8jPS4Xvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R59Cze5ZkCiRmeVe7jvz4eMkpLDSfH6YorzC7cTjBBvdBb9VeULYhzYlAIgB7tY46y9iVEiqX3UpQHNWtegksVfwxDDcsuwWMJcnN4ypyOwSyaTFeuj7MKk+JrUs/SKPCFxGSchzjRDSDIK8U31L0qu17UQgGJgsw0AwWNalav0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jaHXzRsw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gFQs3XgD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jaHXzRsw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gFQs3XgD"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAMUCw719679;
	Wed, 25 Feb 2026 15:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Di9cXzOuizicpm5xR+5OwsMxhwN5bCaE1lRjnn+4Dok=; b=
	jaHXzRswrTOcYnUrTDJI+BfQkh8BynqnRk62mjd+MemDJPHTYRCEzgnjJr9lV1B+
	hGAbSs+tHqJu458huPL4TlABhuomP/aIDYp+6G1s9wv3GcELyd1Zqnn+XcRkrPnI
	E6cVx4YA3p9nHkjIuyneLirV6CHKR5zxxgi+cxWVWQIPUxdTDQJ9srWyI1tLQSdH
	tut1T+w0mgNn4kLgA0isZdbd5pREkEdwdao0Wq/QyzLnZu563stMCQVOxtiLnIRQ
	wuaOCA9ivOPTCoIZOFrz3fYRhTk/NFZvixR2F86h5X6Jv24ijziIw7yW30h81sD2
	1yLE1E8mIve2qH3noLaohw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b6eqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF7TS5012588;
	Wed, 25 Feb 2026 15:40:50 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012039.outbound.protection.outlook.com [52.101.43.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg53w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yddy4KynqwtBohN9ae1nio3fyIqfaQGKibzzcIoiP/6UmEqYSta1/jASgcHWg0tyNkGNgd5rITaLF9VV1zVPU4rYUTQF1gHqDroZbPKq/96JZ+67kVseyTpw8OUfvJohFl+7bb7anV1YLnqHzKHwNQCn1Jvd0GVf0PktkYpPQpz6yP0IK4yXncV2orHL6XWXGj0m+oJ40R4pAPWqujF7PZ9juzw/yYjcPD+K7cc/EqX6+mauNbZxPlRQnInjj7EoznBH9xv4KkKo+meSk2vjmOHGoceuStuW3pZdW1vsN3mMXgoCMSb2AE7mGhfyi4W1XfaxBbabz+AxIe6aXEVI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Di9cXzOuizicpm5xR+5OwsMxhwN5bCaE1lRjnn+4Dok=;
 b=CEAw8jnKRAvU7SbDsPcFlvFWGz7QAfLnPKQrNrUX9y3xPkHI5qeXil7Ks3CwEeWoJUXalaKB4yI0GgC4HqnMAmfc/RIrg0t0++8DCQLOuziTSEOuq49xRwcLTCfsLOycKWpg7hMuu+gBNijhqo0Edenp8DE3/D6Ugj3fMMvn5OQL+dpb3Ikl7D0SQ2oQMsH2KYw4wZdX1UtCDrOfHi5vkqWLvhiVMKZBJuE/3hSAZTIEz3Wm5ydKk9Tu/J2b3KBtKxFDFJecuMCzSodcRvD4snS542PR86rd5141in9vRJUMhcSx6I7/QiYlYld3tlcHfjTc4KxLM3ogfsAcjP3odA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di9cXzOuizicpm5xR+5OwsMxhwN5bCaE1lRjnn+4Dok=;
 b=gFQs3XgDPqRt3Y2az4T6pas0r8wOKbHyO6bWK6T0lWBDZnLfZfXlJeNdlmwVfDn3k07Yold/znH0VherEbogtu5CimIdElizyuM5R5ujzRuJoqRYWdcJXYahdgPq1EVM9St08GXcb+XRIUUKOLEvChxitPng5U0HcXPpRUdsXaE=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:47 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:47 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 13/19] nvme-multipath: add nvme_mpath_report_zones()
Date: Wed, 25 Feb 2026 15:40:01 +0000
Message-ID: <20260225154007.1033735-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0018.namprd10.prod.outlook.com
 (2603:10b6:510:23d::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 152b67cf-2e90-4242-f2b5-08de74843eee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	Z+fiN6TNU4Pl+HwXYJupcigrl7gNjusDttjHm7NAPwnxGjrtHJ6FFBGVhalxI8ajyOguiYxNKYlPuVpfxwenULQTYUs+CZaPwTTfJ6p6YRzragKwac3iOaVSEvJu0ykjGiiWZ3uVP721kkBd/nKZX4sMwCxMyJvsy+fYad9D1HCatSI6nnm7bgV8EeI2tkQSU1FcjFxsMN9fGQWVJcRMONtPeC31PAjlpqHQHkMH0mUp1NNNRu30QuvIEJmeEjlsWiPJDc2z9unGp921NwBbOvCSelquGSMfK9L29PmJgqWbSGsmqBOg3QWyIbKS+A47Yr1tjVaDdYZ5cy4pmp6/994KVnwb2xPTCUsH93zwuLT1APDgPVFXWnuQLmidRECYZ5DIyrtnC0gM9AI24KMrxep+r927PQdRfainVQ//4I54QsaztfDPlh2LqVk7UKQs9frh88unq0frA7zjwKUcTDox7gk/7H3577AITbB5juqcifHERq4AWMgWzTwlNXHj5sySiiCrvKxcWoba8mqHs7aFQyH2u7KJTFBDLUS2D+92w3WhRqakKswA6EhzKpypEN5n2Bo3XbZxQbtz65OOhDe3/9afoQMv4Ck/ORbclr6NAIL40tCDiPrh4SfuMmXu3n0NCoYlS/cPmlRAdlpx6z8VhKS5KeemC9XCFESkeDaB33IpPY83iE2IoLxNk2owTCWoZ2rg8clzh4/jlIBb3N4Ia58pPv1NAMXnsvsZVf0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HSkrksDDbot3sI236psUVQBnHpvcPZIbpcALyLRpMY+g2mnG0LbWyV1v7bmV?=
 =?us-ascii?Q?nMBPYkxkVBCvl8RduIZ7Ip/iZkBCo9CTTNQY6lotIm8+ZGqCZVeFGaN9+A69?=
 =?us-ascii?Q?3NkIGEwdLUE43xqZvZ4eF5BpNrgyuNgcpaF1Apb/QV696H4jhBZZ7Z3gkI1q?=
 =?us-ascii?Q?ssnzlt9c/uVRZzDMOXfsH+LMRX0IOmVnW1NYxUpkjB8qpEJ4EgYpeIeTnb4b?=
 =?us-ascii?Q?1Z6oPObrcvJSDpkaay5eoxGS8DZ10/hZejO+dAhxBOWDv+weqyhNhbNCUwq1?=
 =?us-ascii?Q?u+mBTcnvwzNlzSFqCOBhNKI515MUeuQfYivedYo5eliG5fKZCusIEOF0OkjD?=
 =?us-ascii?Q?4oYGKN6ys36HPCIDmECAd4czAUZcMHg6EzxVeutHmNMyMpnWn6b2YlrxEra+?=
 =?us-ascii?Q?Pny7egCoDa2+9BYvoPa2Ed2q2zsIDMIWxWDezL0fT0THPRLw01SXMmJJB1Lj?=
 =?us-ascii?Q?dFnNbyMC250OVXcetz9nU7aZ/jqcslDgQLzXju5jpEAPpBUiKli8NoG9V3gj?=
 =?us-ascii?Q?fNoE7e76CRaTJ17+Vq1OU7ajbQI39D673wE1Dk54zhhyYbwmOEHpeQzWohkG?=
 =?us-ascii?Q?r/cd4aggL4rMtGTpPZ4t5d6kPK3Ulhu7c7txREwApQ5BG9RW0y2cf1A9tUrm?=
 =?us-ascii?Q?MXSD2/v8ppayQ08YQEsk/qzNGoOlNbbRgGNXxXJZU77KeOcCf4f/MAKqT7zI?=
 =?us-ascii?Q?lxUW8FteMKLacuAS8bXIkjMN7Jh9oXxrdnXQVpNgIg8L3VW9siwQqdwxZZbd?=
 =?us-ascii?Q?kYzbAJAYYwggqrwtOVHArHaGLHmj/ODl3AiA25sVbCG2hRQcnFuD0LRVrDcE?=
 =?us-ascii?Q?TdfwbXS9IHcd4lVdiC1seq2r7MDxijnwRtJ8w8TSNcMDOyy0QYVM/6PTofp5?=
 =?us-ascii?Q?pabU5QUM2PC7GYi4mFd81prPxsWog3pY8093g09zS2tSTNEXpUHLwZwTT0Br?=
 =?us-ascii?Q?n4kdn+DQ79ArWcm2/V3+DB5kPA+lvDQVPAneKgd2NV205SRtOqQScBA39YXI?=
 =?us-ascii?Q?GvUYtUtlkbXDD7RM0+T1C5l4S8ii8X+6x3DC7d2Z4J81EQMKewTdaftcAYU2?=
 =?us-ascii?Q?vJKTBRdOl22KxiatYZkR6idTMZ2b0AZGZ6B1zL0u+1klGf837GSTvqhteB2S?=
 =?us-ascii?Q?oyAMU/jizyYKIfQtw6H77JkF7Vy+lwGR+blQA/2835QL3tiSf6mProkj11Xy?=
 =?us-ascii?Q?rq9C9W6yb2qU0RhZah5S6ulb/iA6KlkRo9Bf1eLkNNd+SgPuUjvakQORfftH?=
 =?us-ascii?Q?6oRSsVJb5tJRHm2c+WUXa4btE3hHdSzSAx1I0CwtnVflEW0iBn57cqHEgxzF?=
 =?us-ascii?Q?gRThtqha3jR5XxFe0wuJaBzu/ac2Du4stPPMmPf4x3aL01+oP+rlHVurCjvu?=
 =?us-ascii?Q?dC5iPDuM65oRruhgoXBcsQWkqCL7TWmDmnXOGA9yT4c2J49t9rK6R+MjSF7J?=
 =?us-ascii?Q?3m9QYGlmx5UvGS90qLGEbaAgYDE1MU+91A311vKeY0UHmoUQN//j3008HiL2?=
 =?us-ascii?Q?1uIqImRzqMsYVyQU/FEvN+kPgSyrhs2ulKXJVvSvUOBw23mV+s4UQtXptlFd?=
 =?us-ascii?Q?BgqKlA8hgedo6qczAa+D39AMQVdpFFeapcOZ0xrs4YIg7lgBJbT6rJUJQm5q?=
 =?us-ascii?Q?61JIdCMGx8PzwSJJc4v+tDRInzAUq0fNHCnlFWFBaAaSvdx6o3S6I3UJeyVO?=
 =?us-ascii?Q?f4ygFQhUk+URpzFbkNXt2QlVeHy62EeQfeAy0kPcq1nwfkP7KWmXmbu6/1Ug?=
 =?us-ascii?Q?V3ctU0reJGhes5jPHz6tvOcwJl9IMF4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	woIF1eR4USeThIapgnMxKJJBuGtztqj8b7OLf/AomPBMcAPk2vNh+JdM5VLSeSl8P3yqGdjEw680LYDb1MmE/DXBsD6t/tgpI4q2SamVS0Av1Y06Td5uELA5tJz03aEzcNPdmkEQi3BeU80pmZctrvgyqAZzwJYiCveIyRkpHU443GsoXzuY/drgYgMm4N3GVLvbin27fjthLr0W/L3RMMZRU/t7zekVWAIKeF3hTY3hBcAJdzPp0pR/z2WqCFoYqA+r9iYQnbsBtEjXmaUlx+B9uIiUWEuRZgS9JVmnoUiMvY9xOM5Fi4g7oeIEsGyNSBZGeX1wtjj+AaMftWigGJRqm/fp5SsR6FR9aeNSDc95YplF56ccX37daMLbiZ2v18hpuf3lNQsaF/ia2X1PB8F1BgpPf2j9y3l5KfMChTKFLSspIR++VDuDcJ+qFFeO6i2XlsqKd0RT9+8n/1QsmYgSkNE60r0X2vgqnZLxUy1uIbiZAl1VKZ2i15eQm1AEo6Fs2bWpN2IbZ3L2jzFnBfTChJv8OdvzbdU+zJoCb43batPi+3xWl+YaO2QdlY0AdMU96PCjxKoI+AMWU3gyUaNhch7Ksnk/ZXiBXs5Q6dk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152b67cf-2e90-4242-f2b5-08de74843eee
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:47.4732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s87Q+kZwF+UYGz9HHGbMS/hlAcbmy9cK/ajBilSOamnSS1lEOxRIdqFItp0w609D9wLSG5nI0tog9WiBsDpOjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699f1803 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=hvl5C5UQGyLzhhgLzFwA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: lvO-DOq4-L96xrFDcq6jyXMwBD3CZCB6
X-Proofpoint-GUID: lvO-DOq4-L96xrFDcq6jyXMwBD3CZCB6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX7XETN3d90Jq2
 D1aK5zZRLTlNqjlrKDmrNAC9uSUXLMITQnTQHpFMLwAlytgpCPSfakE11ONpVuPx/4BO5jq5WpN
 TCPwtmnMZ+EBe6dUxW139WAqT/eHDLMJd/4z8nUQ0rlUqEh7uPyRxKNjTIjnQd/NsabdJjqhsCZ
 9VGJcpBaX1+pdccJ1Q94mpbJgFbP8ZAs63lSXJyWv1vNrkyNBsYq55sHO6mZgel8TG7A+j4F7zq
 hDqp8a2ZT54oWxqsxScEFcOsCEPrUpZAsGsKNLnA/KJbMiDIh9glB6PN0ehYNFKvhF0VIHleDTr
 AkX9WPNxbP+BQBKqKBDxcfq5rAmVxfgmQwa9Ejnz4VCC8u6XCoZtBx3ynaWymbLuR6xPtIPMwGm
 iGNPdaN1it4IkNJeowkIJnL0YJEws/jVEAPdFiT9Q4zuVXQCWvOcxYc13RJWwra/5ngjmt+ohbV
 6AjGQY43dnrBaLoWPqDHGlJkBCuIwLrrm0/SnSZw=

Add callback for mpath_head_template.report_zones, which just calls into
nvme_ns_report_zones() after converting from mpath_device to NS.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index ac75db92dd124..ee7228fced375 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -625,8 +625,17 @@ static int nvme_ns_head_report_zones(struct gendisk *disk, sector_t sector,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+
+static int nvme_mpath_report_zones(struct mpath_device *mpath_device,
+		sector_t sector, unsigned int nr_zones,
+		struct blk_report_zones_args *args)
+{
+	return nvme_ns_report_zones(nvme_mpath_to_ns(mpath_device), sector,
+				nr_zones, args);
+}
 #else
 #define nvme_ns_head_report_zones	NULL
+#define nvme_mpath_report_zones		NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 const struct block_device_operations nvme_ns_head_ops = {
@@ -1501,6 +1510,9 @@ static const struct mpath_head_template mpdt = {
 	.get_access_state = nvme_mpath_get_access_state,
 	.bdev_ioctl = nvme_mpath_bdev_ioctl,
 	.cdev_ioctl = nvme_mpath_cdev_ioctl,
+	#ifdef CONFIG_BLK_DEV_ZONED
+	.report_zones = nvme_mpath_report_zones,
+	#endif
 	.pr_ops = &nvme_mpath_pr_ops,
 	.chr_uring_cmd = nvme_mpath_chr_uring_cmd,
 	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
-- 
2.43.5

