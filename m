Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8320C3B8BD0;
	Tue, 17 Mar 2026 12:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749261; cv=fail; b=gjnzQYqKf+b13OcJo5SL4G8U7JI4Ef0aVt5l3WLZCzYEE7nJoydbJ0pcmBW5E5xOyrJUNVGzT7eEmW9+prHLZ4zyF49SKKkGRa5RVqURGqe6JxpUfVylFtJZIiU1BjLlB+SZ73/yoUdWv3Sq+Ww7TZtgwkooWYpx7KK470X/ED4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749261; c=relaxed/simple;
	bh=F42IRHpKl7xwhLVY1aa/XNVbKbbMAtXSxwvzYDRPlgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T65uAJlzikm5NQ8E99/P070bk1vp7CGEpsefmWrWFwCIfefs3+k1C0n9fpjDvRIYrD8hurJalalyPnk7tl76YO2V0MtGovhIofnUUgDek9Y+hRf2PCyhHln99X6k5bLm/Rmg+wGYPv13b4IOeWMGDq0HPynulrdnBuZ3XTEbgCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iw1+Ql6u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xp6wV9oe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iw1+Ql6u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xp6wV9oe"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H03P9X2998684;
	Tue, 17 Mar 2026 12:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=g/b37hqSZ/N7I2gb4kUKYKzzMqIfUcGvay5cozlOnCA=; b=
	iw1+Ql6udguqEvWH666ATLEwlrCn5C7Cb8MGauIHhmXPNJEaABwKanR8p8b5CAqZ
	Z7ntXGWsKh3GEFNHjQCr/x7N64ZSEV6+ko8v4Mjh6bwitZa5uOMZakIP/T3uzDMk
	Lg4jwU4+Kaxe6EvsXNIzIH22fadvRDF0CIq6gWuOPhWuD9V5UZapZV/PRVERJzDO
	BLdm4bGFImewYDQUU+nFomDEUOs3zqqXhLa3j1ZhYui1x2L164KO2EI+Esfadu9L
	oV9L1i81j5ofdn95enUhYDtdaj/O61HG03ZSd/VPBhfznTyWM7tU0/zDr8nCKEmR
	rOfQGw/+EpLnHxn0Y38RVQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqbuy63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HAarIb030802;
	Tue, 17 Mar 2026 12:07:31 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011041.outbound.protection.outlook.com [52.101.57.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx49ypqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CjgKYFVPqo+gAI5akArdPob2cBDlGd1F/OER4N4CQWZuz7Fkerbyk6XyIhP+NxmtYEyYhmMGMTiDMLVx+Hbddin4ymFpnGx5YMejBbEITGyUrBvCHjEL5nf7JP8W4i4tZBJkMzIubQJEYHIFNrh3bkj+oZ9wrkddP0kHybr6HLbj4bua607S5aVTZ3/yOLaoMVY3YJuNWLwKywC7L7M+t7gMMNxjcdpJxS26vAbvz3xR8o9U9bds5/yuNKTu2n0GBrlbpkx8Xtn0tWAwweShimDl44o5CJxqeAZ4tt9uS4l+vBvxp5DeDSkDwCv3TWSxzUBtXEFX+gIJ1eha/jUexw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/b37hqSZ/N7I2gb4kUKYKzzMqIfUcGvay5cozlOnCA=;
 b=AGBj8P8Pq61GPGdxERkCjV5CWZmeI+IxLHdya1wvTZs/rgBWKKSzsg/yQwaHxS7QL9hIFS1Bjo94DeCLmHAdum8JisuLb6JyILFTKkNFWlYVeNc1U4/Xkd9Uw0jf8+xqYXyYiKKgWuUOUVf0xCCyJBw9e4nWhA9pTD9otosffrQAc58hOaLPBqnjJ/R7tKhDNAb2gukTUVNfR5dEszDOex0CGu3GjEaIwommZmLxlbzarZp8OzE3WxcW+WQWvO0zKR5x9eSXMIQvy9Wi11zD7WMyb5zbhyNtLoXW1eK15uMALhMSa1PEZ+dF2cpL1wwFsRPkDunGOD9+4Cjv9qkscw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/b37hqSZ/N7I2gb4kUKYKzzMqIfUcGvay5cozlOnCA=;
 b=Xp6wV9oeXW+UtZdT913dSMrpCsmG0cjHPRcR/nsVCfT4hUQhpYvhEwG52t8Nq7dATrPuhzwgmqiVtnv+ggmEjUcRjTuLLqBUGv/tzfdaVgloRBY65oSDM/Iu/1PUNSaJN2kmfgSYgqXtwhIWwp0G8hlSv5nipyXq9hlpefaEA8I=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7454.namprd10.prod.outlook.com
 (2603:10b6:8:163::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:07:28 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 06/13] scsi: alua: Add scsi_alua_rtpg_run()
Date: Tue, 17 Mar 2026 12:06:56 +0000
Message-ID: <20260317120703.3702387-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:510:5::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d195be0-74c2-41f8-9acd-08de841dc213
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	gBLyNzedTgHenC/labaiG9K+8EHvpfysYikqzLjA+cOk/ixRLSktUC3HJIRTDWY3hNMjjRYopPK05UeAC/vCLwnmaOfRWubfoBazXonGQosMmMuQHH1RZ+XPt9e1/Cs0PW+dNleHI0aH5rGrIgqX4LPYV+M1MsjBjKSr1Yc16droTu7twTeCcoPg2uspBiOPLF65eF+o+YCfYZrHQprn+nOlY2HPI+SZejWaQGdDiKZfyFZby0RHc7Z9NPV3y55s/iEJm8WHgtmlxNcdQmGoD9UsjAoxFeAM25nA38iWR+uWmXzpdpZVGApExqZP/uctmfDDOzza5xvi51Z0n/XCrneJD2tgBJetgrpW6HKr+GSNvF/AOEHr9p0UVoU+7scSD0X3xfKtsHq8TiIKrf53GxShCCqLnkFFiudH7iJwc0oP0lFF+l8oJDrEk7b32n9qeWsKnVbLfbunNcnxiQuE/I1BHeo09d2R/M/QR23WHXGgBS/Lvji7PMEPQyseMu3l5kXmU4Hw4sDDnIw5q4aS12Agc+yQ1kC33xy3mZioVTai+6QD2wveGfaac6QzheYj3KLWD0iY/cIbHfiuywoMyTjmwPu+11jBrescDPBFkydZ11xy8eaIktGcNcQrHGtwam9SdqHzA+2imWtORPfX665R2w+d/12srru75pEMKSaveRvx0RHE37ko7MXQpD+5WkjXIKDzWxeeT5JQJswMUosN8HnoDVMeEKARBIbrXx8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0MU11HNkptIA95GCyfVuBBuN+pY3aMZhOg4Gex1d8L6PIjeWwJ5JEevN3rWn?=
 =?us-ascii?Q?bqRwTnZFN2tNJ77BUSp15jkhU5E1E2U/wOCq0+IbCDwwPChTNMlCkkf7JYh6?=
 =?us-ascii?Q?b5PnKWv1vsGnJanScuL5Su635o/t4w7EOGZtxpZpe8EQqBn4VjcwYUul26kh?=
 =?us-ascii?Q?oAlEWP0O44Y+aYXnVkb6pl4JOVdfwSE0XZUGfNePRABZPjhL8PMM+/D36HYf?=
 =?us-ascii?Q?Oy6jj9f23P37tJ1/3C2MfAMdtF8fdc1gkhiGQhfv8L66iiEAseF9gcpoBUth?=
 =?us-ascii?Q?hwH6RwJfz9MJeMUNNYwk7/zaH+ftQOMsP4TIigio+1qbduV7vRGnpJecDxPo?=
 =?us-ascii?Q?vIqcNU3acZ5ofTD7hWLX8l14pJZYTEPnhmmZx7+6ybhv9mnvJsGM445c9kk/?=
 =?us-ascii?Q?qAwWebY9rNQEdsSR1nnNfDQmYq7FRv9XQKwqPlVTNFzTxOmkxDDaR/oicIHM?=
 =?us-ascii?Q?vB3ONSRxHjZM3yG0Uuji5+0eYacL4PmiP20cfHpYnROA2kzkc7rijNDzuiat?=
 =?us-ascii?Q?QlvIHVgIJQJKqmUJa0MIiVnfgn9g+mKeW8Jr5OggpzLxe0kUeIqTcfX2x6OK?=
 =?us-ascii?Q?Bm0GGscsLuN8gwMlCE+Cn/tjB/458h9AN74Jazx/fXeSa5MRXutL3iMHxHfs?=
 =?us-ascii?Q?sp28yl/P2UfPIe+c7dmsUv0fR46P33FoJKQfAKUFflQCLcxHTt/B5RikSsLL?=
 =?us-ascii?Q?k3XqbtbwaNESRWKq5qu6bv7FgPKGLzZoNCnjdHdfZZpo16r3TkmN9sEob9or?=
 =?us-ascii?Q?ACXtrGr8LIUbP4Dp7Y16OyxjIYJ1G6V/VyOSUy5i6CMLqrOL5Q77Qsbhhr6O?=
 =?us-ascii?Q?+k0kdtNgwIO8thK6IRQZv0urwXvXXHjI6bzhaD9POkIucpmvntgC+YJdtD/5?=
 =?us-ascii?Q?MOVhwoy+Sr6ZAvtA/uMAAk1zSgsp/yKbDD0AH9hajwavnh/ExdlgTKOFkatN?=
 =?us-ascii?Q?jI9iG5m+HEsqs2mO95xsvxt1QrEsJJZfk1vThWYi7xgbT23ueHLXH7dGrYUs?=
 =?us-ascii?Q?C4UOggftOG4x40ysIOmuxRRyD79rdlGsd60OoHKHg2qheKDyRal7bDayycqr?=
 =?us-ascii?Q?aRfUWxGBMlWCkZzkMDEWRO0dLtB2dwBgglV27SF5WasI0qbm/lRr2kQ2RXEI?=
 =?us-ascii?Q?7TgI7Byk6QzTRFQZhspsPpy4cKGJ1VBQ3fNe+W1D18n0tji4nIOTxBsajjf4?=
 =?us-ascii?Q?33kO6Bt7dQvSuprXEU4HY8NeTfnb4guh4lTmI9n0jopUU/sHFWEf4Yndl0jB?=
 =?us-ascii?Q?WVL2df0Md2fw3Cc+mR/nxZUc4GmahcBMDZ/fIprOz3F/jsqNSmC9NWQf4LEY?=
 =?us-ascii?Q?OWR2sBtNn5sz9jH7uFI2eYhCvelrOcU3cceoFjZuYXQzQAVxz2CNIHKuNYG7?=
 =?us-ascii?Q?JRJSPkwMZpD6szs/5E1U5EGptsK5foV5PicZ4JRatiuXvctkRKL+koLGGPfl?=
 =?us-ascii?Q?H7wMCAFCWtj7FnARym9pSCVbDGCoY0oPo47EwOZC3OAVUw+EiYWw6JUIjlzs?=
 =?us-ascii?Q?jTAa7GRXDZxO6RXXczuDvDOcZ0yCm/dCcBF6iAPaBC9MTOzFqIDL460fGfyz?=
 =?us-ascii?Q?8cmtrmlMfxDc/4YddUcph5JxbHjW30MNM0x5uGnmhR4tQgfY1H+YPK40dbPP?=
 =?us-ascii?Q?JJEA6QHxtDXIRLcrH3MWiorHMjx5T6QwobDrsJrGK8aTr9lNdnoNcAOPndVq?=
 =?us-ascii?Q?w54zjHuoULuq1Wil+eGzK0xLxHTOl7aL7Qit7NURgzU3H709GT0YwC9UXUZk?=
 =?us-ascii?Q?HzSwaoj8cQpIagHJS+9SVSwCYCrqheU=3D?=
X-Exchange-RoutingPolicyChecked:
	XYtU+X3Aly/4mvcmzc/mqNmlCjQw0bi2tGA8DAgmiWV3QVbPZ7H2ugJ9FQaH7QBh7isaZMWK9C97ghh+/RD5xS0BMVF/q7y43kcPr29laZlbYAhWfzq1JXsJR+F00QboveuSR52FbNBQubcyw4tdAKGWpK8oUBGH1qv67rBNoFp3gIpdtVeNQjR1FnAFDI2pHFD0LcPB2KPeBVMNyVa6ycGjVSNX+92RrTQai5FQjML9HBNr4DlHs7qv1CywhGTkWo1MjkED6S6PhUzBjen2RYGSWp/n1ZUlr4H4RKupqmXeFokD5S8aW1q4NC445vrJCw3WyoBnECmmIPlUxOIrvA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SYymoFxpZMrVUjU57gfrgVsDog3ZMyzMp9iAvm4MaM9AAfFMEP+RN0WL5UjrL+NT3GBYL/kTsSyEDkXSAq94bM+tR4yQtbHJt/+lq2z9PclJMMrMctGktLaONDO2JGTfFThIG7lZjncB9L0K4TN7lYH+dsL486Y0eWCCRHPcNiZ8ybchXmGX/r8hRKgiNG/5bPUCh5yoESAN5R06Qa9GR1x2Pqz3nVqyqb7WkwIx+r8bk7hADaPEalJ+WvViNHhxRZrNtM/p4Rwx7mauDgtKCyg2S/eqiSxAZTCBaopbwKjPUQMI30smUDrGPX8puSRJBaq1QBF3s1E75gGV5XWa6PPNmD9jPD5fFBQHm6W9jaSdo1Vxlttzbhrtf/nS/DKMOnkeE02z2wYuLtD7XZlgLgCgAMa1N89zkPm3ln8Myv9IUJ/OVuOJGwFS8PSS0XqWuWgsw5Cha55nBpMCjlqrMJ3FxVTCWvrfcFCg/aowy/v1YeweNAjNG8NqUPg6ThXIz8ymMPvm4ER66Z6FeCl40BGeoM0c3TDwLxu+RqbZTXyuoA1TCVJyBliGjM4C+encpxJ+8u0AvtD+b7ywyJPjhBwpgEOiC6rc4BtetHVKq0E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d195be0-74c2-41f8-9acd-08de841dc213
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:28.0075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExMbks6d6zwp8Gh616S1Hm19AE1mbgmLoPGqq0bKq3tmnI03MG5flEikMd06XXg4JdeUaA8KMlvM2RZ7/QZi6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603170107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX8sWyC1Jqnpj8
 eSFTcUVdXWBBSNNo5f6qlTSRTf62FCmaALn+8tyeYnRoRF9MlT2JeedEDdu4cQDy9bTKZj3UXZ7
 qWubYwrmVJ1VrGtRR6wAvHlhPUDdvXKFJKmWXYSeS3hBF23nA3iHPHTNSlS+AYy6F1EzddLjD7D
 sPM0A19Lgc1R8+u0A2cbLer2BHCwPv778rrLekZMWM+AQAfZ2l2PiXQ6wagJd1ZbPrvqJSWumAP
 O2Za8Kq9I7ompcLr7Kz+EjdQFqqJOeA9blzClF9kkqieIGPnkYh6FWJWqe/qMaMdXufMIJ3ZL06
 uthFJxQ/vFVqoVOT+I0UkQxAa9Y8y5J3p3hzaATQSs1ctIe9J/GErSHBhh0MlXcyS1RP2Qyhl+z
 SGd/p2mVYD5JMEkFEAtTTQRLvhXuE20Px+wkiVh4gIvJa3FrMj3JL1Z6gncH53bw2MI06qH1cE7
 Y51eXAMsr8VXuN0Mi6w==
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69b94404 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=JoSIP8vjq7l9lMBlepkA:9
X-Proofpoint-GUID: BniuAr-F9vdM3H-7ggaYkI4PhgH_SCri
X-Proofpoint-ORIG-GUID: BniuAr-F9vdM3H-7ggaYkI4PhgH_SCri

Add a function to run rtpg and handle error codes - it does equivalent
handling as in alua_rtpg_work() from scsi_dh_alua.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 33 +++++++++++++++++++++++++++++++--
 include/scsi/scsi_alua.h |  6 ++++++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index d8825ad7a1672..e4cb43ba645fa 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -48,7 +48,6 @@ static struct workqueue_struct *kalua_wq;
  * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
  * SCSI_DH_OK if no error occurred, and SCSI_DH_IO otherwise.
  */
-__maybe_unused
 static int scsi_alua_tur(struct scsi_device *sdev)
 {
 	struct scsi_sense_hdr sense_hdr;
@@ -159,7 +158,6 @@ static char print_alua_state(unsigned char state)
  * Returns -ENODEV if the path is
  * found to be unusable.
  */
-__maybe_unused
 static int scsi_alua_rtpg(struct scsi_device *sdev)
 {
 	struct alua_data *alua = sdev->alua;
@@ -390,6 +388,37 @@ static int scsi_alua_rtpg(struct scsi_device *sdev)
 	return err;
 }
 
+int scsi_alua_rtpg_run(struct scsi_device *sdev)
+{
+	struct alua_data *alua = sdev->alua;
+	unsigned long flags;
+	int state, err;
+
+	spin_lock_irqsave(&alua->lock, flags);
+	state = alua->state;
+	spin_unlock_irqrestore(&alua->lock, flags);
+
+	if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
+		if (scsi_alua_tur(sdev) == -EAGAIN) {
+			spin_lock_irqsave(&alua->lock, flags);
+			alua->interval = ALUA_RTPG_RETRY_DELAY;
+			spin_unlock_irqrestore(&alua->lock, flags);
+			return -EAGAIN;
+		}
+		/* Send RTPG on failure or if TUR indicates SUCCESS */
+	}
+
+	err = scsi_alua_rtpg(sdev);
+	spin_lock_irqsave(&alua->lock, flags);
+	if (err == -EAGAIN) {
+		alua->interval = ALUA_RTPG_RETRY_DELAY;
+		spin_unlock_irqrestore(&alua->lock, flags);
+		return -EAGAIN;
+	}
+	spin_unlock_irqrestore(&alua->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_alua_rtpg_run);
 
 /*
  * scsi_alua_stpg - Issue a SET TARGET PORT GROUP command
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
index 068277261ed9d..1eb5481f40bd4 100644
--- a/include/scsi/scsi_alua.h
+++ b/include/scsi/scsi_alua.h
@@ -30,10 +30,16 @@ struct alua_data {
 int scsi_alua_sdev_init(struct scsi_device *sdev);
 void scsi_alua_sdev_exit(struct scsi_device *sdev);
 
+int scsi_alua_rtpg_run(struct scsi_device *sdev);
+
 int scsi_alua_init(void);
 void scsi_exit_alua(void);
 #else //CONFIG_SCSI_ALUA
 
+static inline int scsi_alua_rtpg_run(struct scsi_device *sdev)
+{
+	return 0;
+}
 static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.5

