Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F352740F8D1;
	Wed, 25 Feb 2026 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034076; cv=fail; b=kw03VeEMU7LMqgpZPFaMBQWgxfvWPUDfBfXxV70pCUQOZPwUFUwB2qqDWnKg1ns5K0dn6/XDnQ9b4UYws7g1pJaFTfB9ecDNA7y72qznKQL+tNGQ/dF5dGxUmKvRaQe/r50P1nUfI+4itbxOcfjfRu3uQpVGdHGkTqBPJAJ9+t4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034076; c=relaxed/simple;
	bh=gaQzTbyvL/X/7dF6q62Fww68RTOUar5uN/YZoI1vgwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WTaWDBKzmLegvQDjK3ToRsuMXjNvIEzxG+cmvENcgsbOtLbtKMEJm9bMg5xXypbodI++P0n6d7pP1LQgwcLnLJ7SXfQbBj3Qkh4ljXMR+mCv6TlRq+rR3MC2TI9FydAibTSXjOgLpnQ7j6cBypQML7LhFrf/bAzcIhxQ52jtHa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T1ofYd3j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gurduigy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T1ofYd3j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gurduigy"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAYSUh719577;
	Wed, 25 Feb 2026 15:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=f0Vv9Cug7sy/FVm62WxPMWV+cFakxfixF0kUBW1RUVg=; b=
	T1ofYd3j/Mw0FNuDhvEefyMLPMDJPtVFDbHteKg5f0B+vWlLYLV3AG5m3SZAg7+X
	juKaVnYHir21+gStqS/ckxUYwwhbZb+vL4O1d8N6RTiYpMXnLRxqT7wPK5+KIKr+
	rXctwUWBbifiKdaVbf75KHqJwbgWPHBCkT5qhFZL+hfl/guMHKtke2qyna+fnJMe
	j4K2rGOMBJDBJJ0WHLLM/VYB70T+gKEoASylKqwcO+B0lFyLy8xpvf8G4kAQLdF2
	5v8SLzlwwwN36sK6vTVNYC/JQGyqB6/Gzxd6MxtbrgieAB87AQwyXmoiuX9MUR/+
	QaYFsxDtnvRnv3fsTUpnRw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b6eqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEPdlw028627;
	Wed, 25 Feb 2026 15:40:47 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7pgm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NX9Wlsr4sG29DH4NrNIpUaNgjt6AYMWWrmZrCsMSBTy2IgHh+Lo0xg0SZVxH2CW5/JU8GWKMC63u1er7LAoZjIVYJO/zEfb5I7I6VMZ7xypfnSphaBNX9cQ1e5xTzlXIuZ+90JtDi7xgHTs60cX74u/Y8ZJv22g0ePU2PhpJke24eQwY4mNA7OV/Jx+/qZGQIXQRp4jaumxPln+59DPIhe5o8vmqu+rjuyn2PPpBIlq86Ig1Wj4R8K4oXglFVQWM0N0CRHRhD9camudjQcVvQXnjhMbKGOFD/bFyXzAgd/9ehzP/e068UEF8n6TtxPv0bv4hquJjozOWA2yBErwRXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0Vv9Cug7sy/FVm62WxPMWV+cFakxfixF0kUBW1RUVg=;
 b=HPsJOzQXCPmHkeVoQlf0xIWxw9L6s4a7fEmWOV6mffUDazgk/gGAeWQ3dbrawa/Jw/D51vT1oUsdDVng1NYYubW0vt3wVK0f83vwJSxQzkkFKBF3LE+iYWXaGiIZDFaGZ5XYxpHn3jVSaJJ/Db3JrSaHx1Y5b3ENwoPrQCorNuelZYrq2uJ4Ro6bBWTaeqCQ+D+Tg/Y4VckXj+INh0vT4TXId7fUJDsK8BWFuY02rXg+pgTZwa1Ff16dtKsHSl9oH2NeIpv7oZgG381R0chv2CV9E3XlXP0qRu0IIVwRbEqzF84iebe6S3qgvsHx7P6A1PbpggZG3D4ExVoAKER4Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0Vv9Cug7sy/FVm62WxPMWV+cFakxfixF0kUBW1RUVg=;
 b=gurduigyRMMighmCq43vMMb0GxrzC67CNaPo3iJtVMqeDViACOoinLkeR5+c1jutarWxh+QymKtDHomr3C0QaCELED4UDCakusxokON/wDDf2/JjqW1QMOUsii2laTvyrLgLCtyc0chf7GI4HbfFZcSCLTtfW8uvLp5RG3shtPI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:43 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 11/19] nvme-multipath: add nvme_mpath_get_iopolicy()
Date: Wed, 25 Feb 2026 15:39:59 +0000
Message-ID: <20260225154007.1033735-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P223CA0029.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::30) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 04e20985-6123-43d5-6862-08de74843c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	1l9XA6KAOsBi9T7uEWALWq8XUOORmyeZ3TdnYUpsIbmVkjXR36SEX1nuY4wf15nFwu/qcMIOFqmCrmyN639mVHtKwHCCDfE+iBt4/bS8Fq3qPGEShfywqYsQo2DwHPj5b41xeah4e9iTtGTQN2Pd02lEsIhR/0BvCxnt2ASyKNRsRu5Lcx16FWzSYH3IRfXN2As6BBsykePn/xpv+g7WXzv7kbaw30K7Gse1wOyXz10XmgJGsGbz9jabjfMkLoHP7gS9K7VCo7Xv+vJwxv1css9KF5ypC4vX4COX0itZLITS1HwbarlShZVwV4FiOVEp+Ji38CPP2dNRrijutiRBmKb6Y7CKfXB+G79lBXJc0sUqdjd/jSmv7yq1Om5E5caH3QJwOigVQsCJu72w1x9m1Jj886Ko6Gg0w5BXEN8dnIK0TB8HxJaqUhymkqw2m+znCUuEWOVRnCb68WY6xuvFUg8mfKHt/OkuKdjY/iaYkJr6xr+MoHfKLVPteA15XG9awNYmeMV1v/s208QVG+bjBxm13b07iuW8YOPQv95BSxUQIQ88bRYfmOJQ+461dQ9mEcfYBy+/KnUNllvwK18ZMW5+TEhCIRnT5jlBHWeqGe4bWvEeCDvUB0TsdoHTMsImOfB/4hF4smYJ80h4fgXQcUkJnnhDU+QyYgCIBtf6nwgvqxBlJZD9yXzVh1pt+Vs1LosLIKpjECvJOjczsajYVcwclN5dK5Sr5MPSQrnWJ1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z3dButgZRwNnmwsKYf36b/DuiDEau3o/OAaqmT9uAknz19/M2SiIFpMIdlbz?=
 =?us-ascii?Q?OXqOvMXWuJ3J7f5Ae9zHvUiATfD8uY7+ep+h/g6yOZkrYCNhGOUdr6rqX17W?=
 =?us-ascii?Q?f722mlON6se4Z0C/L0WIwQs9tVyNGGRybrJLTupV+dx8Do7bni5CX09ktps+?=
 =?us-ascii?Q?5TUxr4qwXxxkPu7x19c9myuXsEs4LZrTk7paphpOepcTofQZVk7LB28qs0/M?=
 =?us-ascii?Q?KWQvxizgvqNk7FIsBYgJq8fYoIatgv8FyypA252GoQHG03QVd2v+NtQ9K7Ht?=
 =?us-ascii?Q?GHasHZvul2oLa41xkwln7DinCK4kXWNB2YD6AQN2JCkjRNBsx4H1hnpENs/I?=
 =?us-ascii?Q?bFWRcdOTfli2hbfizUlpZ8YjIKffUhOLMEtIiiw7b0IL4fDIiX456xOgvkIu?=
 =?us-ascii?Q?XT1mye56dELLgyvsgNx9EFkSjzEquqMQWUEeBO8vJMAlpAOI626yVKg26YYR?=
 =?us-ascii?Q?r62F/b50MWo+KXhaVbg/H89wiuH9O3kf8vjbUBhbVvgYAKMG/bOm56B2fQYu?=
 =?us-ascii?Q?qZTMJGiPvP3WwwbabfFc6RByyw/8nm9P2jKBpkg+WXdQBCYHbkbW0qSlje9R?=
 =?us-ascii?Q?9CoxGbwofVCH+5pqKt+fO/7oUXRz2BAJLrYRvbriyf11RSGzL+63XwMGH4Xf?=
 =?us-ascii?Q?ZJJotSOU4kNA8dQu7y55JrGlyK9l7rcBVQfHXGluVaOVZzYSxxS89GH5elgS?=
 =?us-ascii?Q?p5VCRERsDb7FGnDxYaMWIwBTPGCUkqbwZeFbW/i+Dz2BXTyd7sRO7U0hBQ40?=
 =?us-ascii?Q?JcpRDS8vNPbPr9NIVbYq2YSXrqKGTpt17kW9ZQ5XmEQoebRZhaQTnP/dHRCE?=
 =?us-ascii?Q?dgdMCURZFdBFMjZcgb+h57+EEusiYCfYiMi/UUQSutmAkpSfnN6A8ZrsacMV?=
 =?us-ascii?Q?VyDycnn0mMaAEsoyddpE9g+vpaqPfGzbT/LHzL4dWjnn0V3fZ2ir7Jp5bRvj?=
 =?us-ascii?Q?ZITniqzCuGa2VdyAzG2WG0Uqv1tLyOfh862mK8kYgZmAcUHURjk+IBUca3cx?=
 =?us-ascii?Q?QS7rOZz+ovOhL9lmpoADmrdVKq3CtCbWhQnWzZnNh3yTVfdAYUy0M4Fain3w?=
 =?us-ascii?Q?rEpNiq14Zwns/rhsVsyBvoXXZhvTNggxOHZEbdPFvptdezCvOISGmEFxoUPe?=
 =?us-ascii?Q?6XauXz1DpM6PwMvZDgu+eyPf8+yzhWq6byvKJgd7siPmHqr7EZUPEso/i2sa?=
 =?us-ascii?Q?SV/MQ/xhj3jbm7zlpc12G5lb5GAwuGbvjrCfKoRW2HH5Mp7ax2HyPnm+Oqqs?=
 =?us-ascii?Q?gbL2Zki/7SytjsviQaQQmlxaur261EE8qrwzsyI3mWLeCA2IETppKFCdx3vW?=
 =?us-ascii?Q?x93ks3xAa7D63+wCSYWEx7nq2aW687SMuBKg0k7mDvvBaOo1m8Xd+DkZXrEV?=
 =?us-ascii?Q?+VAG/zUzG9P0VFPTKjFUNgfcIg0HaLYtGqxaXJJl/V7DBauIN3kl2DURMz+9?=
 =?us-ascii?Q?PNP/hvQSKXx4wlAp7Ay6nMT8zMN4S6DwMuSrXOPgOH64LwtuolHSretDi/7F?=
 =?us-ascii?Q?xSww7vPkwROWc5UKAyn2fG8+UHe0ChcG7aAH19mSov3VCMzRjtB0QM5u3mrK?=
 =?us-ascii?Q?urvfOc6ZWAHMkwhcKxX2nZM8nWdIbvpumIDj4ahKKkPXfqNFOzEgRgGSw+fY?=
 =?us-ascii?Q?dE53FA2HKXv4FrxmWVn6cQqTxxU0uaW6KOgX2aTxoV2OMbkI2QJl681eyXZm?=
 =?us-ascii?Q?UOd27Q6gQcW3IpcgR9xZTytQQyT9DnIjETXZDPO8fClGW31gtkbOLPxUrPSc?=
 =?us-ascii?Q?4eXk2NK4yKvRn73oxT9+sOz1zsN/ce8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k7p92oymkZ2mmtB7FCbE9rS9IUSwR52QCUBhD/GzpzxmxEdMdLu1ZGJFLXc8Hyr5BUEG2FQiLXlF4XKo1oFpb/P9AMkZLKe69qAyyTnG3Y/vPezSib0uVSrBSo6y7s2xYgGEjn8BI/izlvi2YEZCY11eHPRSOCVDHFXvjXDS+4/pDhshTI6BthOKo1/CepqYumC2SCGLgurs3g7yL0+S0AIOqktAfF8lHUN/g1WyitU9sYrAitgWXnz9Qj/54HH4WmCb4QHXz55UM0IDwTpSfZnCvvcNMtvRikFLeleXadREWJHA4/LxRIj4+t0meh7NMsEwkUA8hm1Y1o2QJKD6bbe6IGvZeaikQ/HKC5sHoO4Fewytv+Gil+EBBOB2gW89t89xqjq/mGCZ5Aioceeq3fUrw7lnuE0wnhDAnTbuUAR+yHrI2pYPL4d8ZsZxnrAjvy2rU78A9NNlaBQvee4Cb/Er74LTGQD6vuxMu9MIWxmDekkVyHdTZTyqWpTPHTV3/Kqe6zg/vNVltkdLPffnDc9mJJQAOKzvxG8k0FP8vi0seO1iLe5ZxTBRWcnUSLMnDOE1/9MH2wwUZ+yKWhMRH/3IUH3KjlK2Ua71slNPtjk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e20985-6123-43d5-6862-08de74843c9a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:43.6111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFegPZtXBFipK0KReJj1fcResxDHnBLzltuGZyQOCzbOuSP/wtbsqXn/fLcz8WGypNq48uACUM6R6VJJdveGfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699f1800 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=J1s_sOXE37Cxi8vwOuoA:9
X-Proofpoint-ORIG-GUID: cRsMuj280zOdow7LMWCDoyor7aAanB4E
X-Proofpoint-GUID: cRsMuj280zOdow7LMWCDoyor7aAanB4E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXzc+oOBnXoX6H
 Feq3TGUhalAxYJ5MiMfpmwpY4sBOKDBVgFB9yS5lpF8h6sum1fbMSY1BOrEDTqIGZ0Av8i6AsLl
 dmZGfoz0hTR2+6jgl50lca+ZS5q6/OMuRnktTUK4JhkjHKJu9s29Cj3LxVvfgnXtE9TLS5QKAJi
 tb8rokqQngfbXBc6NejBOui7OHFSySq34WuiaV8gHAVsK14rbGKXaVNV/uTWFvOV3cRyz3Ub4Ch
 wfETw2novylDaA8/K3Lm/V2YBfwDV4OmMXiUKpU7orCNZNkmbMJpiE+xTSFQp82VMFoCwx1FMle
 dKY7W/gXOnezriY6MUcqcH1zbKTtOmgtBHGEzeKmHFeRo155Oykg8k9CNlSmEI0FRibE01ZQWD0
 Wv/iQYWEdSoI3tcRRQpzW4aEX/j2HS46jpCvPiGEcWmTi+nnTmtCHolNJpL7MdsGabq8ejv7Rwi
 hr2sBVsE+QuHB07yU3w==

Add a function to return the iopolicy for the head structure.

Since iopolicy for NVMe is currently per-subsystem, we add the
mpath_iopolicy struct to the subsystem struct, and
nvme_mpath_get_iopolicy() needs to access that member.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 10 ++++++++++
 drivers/nvme/host/nvme.h      |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 12386f9caa72a..6cadbc0449d3d 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1464,6 +1464,15 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 	ctrl->ana_log_size = 0;
 }
 
+static enum mpath_iopolicy_e nvme_mpath_get_iopolicy(
+				struct mpath_head *mpath_head)
+{
+	struct nvme_ns_head *head = mpath_head->drvdata;
+	struct nvme_subsystem *subsys = head->subsys;
+
+	return mpath_read_iopolicy(&subsys->mpath_iopolicy);
+}
+
 static enum mpath_access_state nvme_mpath_get_access_state(
 				struct mpath_device *mpath_device)
 {
@@ -1494,4 +1503,5 @@ static const struct mpath_head_template mpdt = {
 	.cdev_ioctl = nvme_mpath_cdev_ioctl,
 	.chr_uring_cmd = nvme_mpath_chr_uring_cmd,
 	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
+	.get_iopolicy = nvme_mpath_get_iopolicy,
 };
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index bc0ad0bbb68fd..da9bd1ada6ad6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -502,6 +502,7 @@ struct nvme_subsystem {
 	struct ida		ns_ida;
 #ifdef CONFIG_NVME_MULTIPATH
 	enum nvme_iopolicy	iopolicy;
+	struct mpath_iopolicy mpath_iopolicy;
 #endif
 };
 
-- 
2.43.5

