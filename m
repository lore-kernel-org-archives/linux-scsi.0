Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3B638A701;
	Tue, 28 Apr 2026 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777375027; cv=fail; b=s8TCPvxO0tnmov+TO0t9IdlDb/gQ0SgvMhnMHyWTBUDb7TvhNvvY5utRkSKjRuJ5GnRJOgYtHnmsc+g7SVqWgtXgJ3teMai2+RaD01d0PQYe2hdUwedN4rfBctWyME72P9dNblOd/6usfdHLLxxSrUxm96izYx2D/871tsrXqTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777375027; c=relaxed/simple;
	bh=MN/z6L5TM2LiIND2e1rGVGLJrlUGf/NWfw+di4pva3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FJegi90yvmYLuBjQsliXkXxzglSMgB+f0XInZcKn/NWwtQzvQgaY/vSYB6XiDHCRoYv2juqh8K/KjpzE0x4QjqdQaRNt12ZAFD2ET4Rx6PwjLgXz82wzmQpnacbTCb+/vFZyUnSk3vzHULKRfhl63HDQksp9yhCAglx4yx2FY74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XjxOt1uo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xca83fJ1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XjxOt1uo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xca83fJ1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAGp9G3055332;
	Tue, 28 Apr 2026 11:15:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9uGcMUq4sj7OA6ceb8y8GwESsG3XPNBbaheMeGXvsrE=; b=
	XjxOt1uo6hYB8F8LfnWVDV/XLr6Twf+xSlImZHGpURfxU0zdF4f0juMeRH7p+P2s
	zaHCsUqNFRUsq1XAePd3nkWn7BmjJTj22ToiBqTNVscf069+4PW5bORnKS2nTA1H
	SenT8y65Ecd2U3AS3jhbheAxpuifO7EmwM4Wzztc/fcJl/IO+CYvOlLkavtk9b9R
	tvdZO55WZbiP6NXtdnAyFm564Q2pXoUTAdaefMzP/4MHzivx/IxLDs1lVv84Wqc9
	0aCdfhEIFs6JOIG1O9tKG0/j8fox0v4QTFeZHnhiIbq4s718SPh8igvKm2Mu9u4T
	JRzZNQKJhsFaqjBlOlIO3A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd5ycgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCmVf038802;
	Tue, 28 Apr 2026 11:15:42 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccner-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBj5UqiFrRgiYvXo/i+zXDWm7zqzOSLxTvcqYTqDg24Pgu3187y0NR8A2KT8XGOojzHFsNRvEHLggEAW5VQkiKnn5PYkyiZJdy3DNsmO0r+88ZpCQHWeQ+HOhNfz8vbZw0F8d30Sg0q0KlPcypqeijnA5MZKulJKf/sswK0/ZzMjXSs2D4BjfE55QAJktIg+gJN08RQeJgNRMlIhfVXuJtP9m33MybJhlgN8/01TxC6Jr1qfgC42G86Ez/GFwv71YSK4WNnhE3m1ezTfaIiZgNJ0MaG+gRnoIcXMMZqB1eTJCHPPMwYhRJwLb1Rt+6Pdqh3WNS7jfdj7HPNk0NEZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uGcMUq4sj7OA6ceb8y8GwESsG3XPNBbaheMeGXvsrE=;
 b=qy6ZVfsWgmdXt+Pj0zak0Vr+pxca/TMKHy1IEJzQlCqlDur08vw/SHMDjTgGcehPmX5chS9m1yajCMc8UywJnP7nXFEhXC6fh3WxfXLESrv0bW4xHFOBfXSpqNogWR7ft2Fh6yRDjfzqhB8+mSoXmYFYZVlXFlmrxDKaPPmx/X9F49Z/zWY17WXH2dWwZrLNxtXiC4+1cC/vw8sp7HiKctrATp8CW6U/ViVUKx1AT4VOvsFlxja5GJqbTjoDrXytduRou5HYX65NA/eudbRgtn2CvBuy23tnJW/rOkJOS32W20a+TgLH7Ad2UZc7c4UOTKPduPXFko4fdHAPmr8QZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uGcMUq4sj7OA6ceb8y8GwESsG3XPNBbaheMeGXvsrE=;
 b=xca83fJ1fyF+mCoAuXMGdUYy3EFYxYx7fBJNIZo7ip3hB5LMPAJL2TZmTM3o4aMNu1Akb22KSNA3w7syT31igizvhzqk1g4BLME9bL973mJdJgvdZNMGArwq6IcfLccYdl+0UyYgRcxpESp1Z4CasUmRV0Sqn5xnIWlJ1/7EJhs=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:34 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 16/18] scsi: sd: add mpath_dev file
Date: Tue, 28 Apr 2026 11:14:45 +0000
Message-ID: <20260428111447.1779062-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:610:59::30) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: b33b0245-70ec-453b-ef22-08dea5177745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	31NoCOgv6yRIIaluNQjaf2fA6SgxV4fEC/6N9uHhS04T7GP3+z3cFzBsX9ZSEgX1HkrTLU/X6rzq6L4XmF1VUKVZJUS57TuK1IgYBgTmkxLJALpRmqvtz4RPUw7SDAFBgMorayyfzMIXT/vxpVZmhq6jz787MmUnseKwCEgcNmgjDalHdxT93fNiYiyMiSy5MgmD9k915AA8Dw6B3bIlL+68O3xtKSlmwt0jTgO047IDNxobYLuAPEtMMZakw5HcF6jFaWWAj3XeD05w2AWACjBimn70QsnYiM4UXhuYddBHqya+It7AMNh4g1GrqvgO+CFyhb4Q2h5GspWegVg8rxA0CkXJxONno7ZQPDQT8rU616PyLrV+ebVmtPtxUgPnq6UkFXYdw1nXHp/p0UFYuLsloxihX8d7ObVLAkYKCcmazom0U5ti/MONN51ZcHbi6/P+SkkCUkrzU8Idi/SHcoTeTvT1Sy8qOksoUgI9jT/9IWVjmqrknj273P3MAeM7sJo6vLUK4GI4A3kw4BSoy4TurkGIBrfxPg8La/WDiHeGSQLY2mmg3ZndUBEZPY2nFyieYliT6iDFMLDpkk/+wD/JuM7dz/BJT1u+E+AAYiB2Gu+oFnT84xOlUV86sE12i1HGRY/f1IND3XYrm0OJ8+6sdHlHk6koE11yiEjR0S5lQPC2hf05RWn16ecWypEHvVBOwNYofFDxcQbvILfbtm3jRoEkK//PwOe9DLi4WnE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/aCZqf77PseNMT3zKEM1W8UHie17ZipkEPY4wITNdyWUhuIySXfT8TKxq++C?=
 =?us-ascii?Q?48oyuWMOBUT5xnolqYtJfXZ9XsFea0ijF3Atb2llVYTHWnZoT05EUhDcIUg4?=
 =?us-ascii?Q?mzeLmdtlz9vZPocXtC1T2v6k1oTYDYBCgtxSWntuVqwbrPnaz3QbhKuBldJ/?=
 =?us-ascii?Q?nKTYyyRE4WQk5mW1kfR//MvlWmHcTLLWVqnA6kc+FRSSBFcuwjAUMi4mFmUa?=
 =?us-ascii?Q?gntPcKa1NGMpqUR3/Ix3A3DWFYCGiLYtNBiRM83fhuof6u3vR/RBT6QZ17bl?=
 =?us-ascii?Q?ty2N7l4pnH3B6ndA6ESP/B9/POIS0ErilMqYpU36b65J0Sr1Z07HnOJ1OF9C?=
 =?us-ascii?Q?erDXLkDuq7kcULPiUYcAFt2ASEmlWz8dmQjU4KWOtKSXCF9vYLv9e41TfyLS?=
 =?us-ascii?Q?vB8Sbgq4fJKSValcD/DA2ZrotOEVF8C124JACXkb6rZVtH/HPlDH8B1duQMQ?=
 =?us-ascii?Q?6YsuK4KqZArFD2eKT2V8BnLUN8nhI61HT7L78e9ahUYqP5/5VQl4hjZLNOXy?=
 =?us-ascii?Q?cT5XPIpXoxfJmyIZ0bFwt+Ayw+t9alhU311OI2iZxzO8mVtnbl3ZtixI7EWG?=
 =?us-ascii?Q?2IdrO15IXBTgJKF5+UvwBSBKrEmi57U3MAdjkkDYWh0THBPuaaFqw3eUgW/7?=
 =?us-ascii?Q?V7F5oWBdmfyd01FviqFSETWURQlxWVwwKY1kusvgYwAgRQIcPPLTKxa02o2o?=
 =?us-ascii?Q?PKHwW3GQUPr2ZsOW5Gd0g7yTi/H5Rn8rI7j58gd44mR5fsjwwNfq6zs62POK?=
 =?us-ascii?Q?Ol3D1DvQQtREnbnhKqbWPsLtSRovujZ5aGjfefmAdPOp6zd5HyjrEmQeyVTx?=
 =?us-ascii?Q?ERth1CNPiORs6PwcaxkgmDb2pkgpdgWXh0NujTo/C77JMhvbgkUbzNDaD0Hp?=
 =?us-ascii?Q?njK/b3W9dws/iS7smGtKvjbzUN1RZ8scnPeAtnMNxB7wGczgAC+KlaOEqMtl?=
 =?us-ascii?Q?+vfhvX31LVO3bq4luJI67Um/3ZWqnYRedzyQkyyTy6p1WVEOFlN0DF226X2j?=
 =?us-ascii?Q?FhC12A0SOwtQtc5SghY1NLetAotJM3is1DFKPQaqbw1mKvPAyG1z/805JonL?=
 =?us-ascii?Q?JVKdrFFXY2Q78iBHiTTusW3brvrgpbBr+gK+PIAROss6wDUWMojBT5B9x+9K?=
 =?us-ascii?Q?kpw8hn3dkUHUdHNVfM5nlMhCkg97l2d/zcfzle96rqI1zPwH1R4Hl9F7pSML?=
 =?us-ascii?Q?h4NKVM+hAiJu/jnY8uzIGqDSbruJh4DFxxce4iwxmw445lKwwkFmjXpHeLJi?=
 =?us-ascii?Q?o8jf9VTCHzvFOfjxJYq/eD9VoHFZblyXVN0s2sS8tA9Sf7Q2VfVZnKD3FaMp?=
 =?us-ascii?Q?a1Lv8UXPYTQB2z5vYtT/qEA463wm/SdDrmGC3gcLfbKCucUi6UvDftNZwzYM?=
 =?us-ascii?Q?XDvTRrxxX7P24l1Jv8NUV2nmpNVxLBOBdMKuixOTTqZq77QoCpx0QOEA3Qmm?=
 =?us-ascii?Q?JcldRg7LEHUcEudMS9I56BksXitts++m1+Nh/oPb2Gd6V9FuoDS+1z7UXT0Q?=
 =?us-ascii?Q?QTFXkBDJ4xEI51Z8zOwJkrsUzjAKCeyU2F2bnYe7VVLYbBDy3mO448tMFwVC?=
 =?us-ascii?Q?/K9SSWxaQ8cYq2LVvbWzys+1r4Q/fGfAsvULcUvfqKjc68KShWS9Cl7Pk107?=
 =?us-ascii?Q?BmE6qQD85TnwBdHsG+5tCmNC+KUVlwwKcXulIQwS8mobIHyGUqy3lmW2kZdR?=
 =?us-ascii?Q?Qywd+9iahP4zL2cPDH0oTmDlrCQCIBhwB4yWpj/3DpDDHFKxjseLz0XMxSFH?=
 =?us-ascii?Q?uD3xjP3uGJKcUgBadr60p0tCW1Mceus=3D?=
X-Exchange-RoutingPolicyChecked:
	EBW+Yi0RmHrQBtakej9p1A3/mXfClybF1Xc2WVstPk9xzpXD5xROdBLLcrXy1O1mVM28Lzi49oLoDUrySPdepBbxDdVvYpchqsAJXEv39rcIV5Uc2+WpT1JQ0X/KCSRnXPBuZ04LTwpFrSk1A0ELYy6vA+uVPuMou0mCqBH1rumksEOaCXARht90w5qZFhQ3PjZ96zImoD5lYzLhuTnrFVhCiQ/YY8Ggh7tdYB3DVSGs9rr0Ow7hnwcUqAED/iqTqnXC6PIoKNJbrETcr6BoVJicarz3XKG2XvLxDp/biXBr5MWJGRDKTMiqiDLMVH0YCac9wknzh8fmoM/zGg1Bbw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XNm/Rh3q/6IFQ+k4RyTalO2yI/5nBIXgIcVTCipmvfWu9c9Rswo6tEasQfJ1/87XvaNdJ/e4D20jo2dPywnKuu5Wacs2f5fB8c7tHkn4uxxYsIHpSGG7gp0L6PnD53bOJ9AeUaiXujjvs4Ygtro4A91dPHcAC3ap0uTf7ib2jwEzNffdunmUPQ5SXdMxd/KJ9D09LQrYXv7TDJs2Rc3SvAUQhImpsr1MpfVQdheNYsQVE39AkVh2C3Mk8hikVHGttxwER6od/cic1eYBww+Pq9BWQdmZusALSLhshnuBoLOO/PVFOcORwLksKFrfF+iIoh3w5cma24BrY4Js+OwAbGmTOINP2zmLjGEblDxSje90PPCO3g1pR650rd18ILebaw8JhaLMlPLyA5ldD7bbJ6FjGZUtokPTeum0DXNG+nCcjkCcG5puWo7dh7WgG8i3XEE7+PHvuJzEjc2lB6QBTf9P2iT3Qa02RnfJwKwl4iOPukbladg1ckWRwAQg6DGUTHwRyLsR4qbMacsKbMAsasw1UfaLXW3xcebt69iUTNduNXDwz9cQDBvctCDpgYRa7R8zPh86s9D2kp7b+nZELuw/vtZiVcUifC1iTcypT9E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33b0245-70ec-453b-ef22-08dea5177745
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:33.9300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17eOnSU0jd2r2NL0ss301prY5MYDNKPGVMZDwV8x5q/TDEUCdhVNxbRVHkHkgSKAQlDG2sZl4hk99aPTWBXI1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f096df b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=A6hY3BpGxKl4tX3xGd0A:9 cc=ntf
 awl=host:13844
X-Proofpoint-GUID: Ql5RpRKJnZu1YHEQSdWB_-t0RU_vjySy
X-Proofpoint-ORIG-GUID: Ql5RpRKJnZu1YHEQSdWB_-t0RU_vjySy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMyBTYWx0ZWRfX5526j14myyrB
 aN7NmCnTFvFOgNgRSQso/Xcv/fcUhGDPrDVTW3WkLbaAWnO0UAM0tBJq9X2rRPn/fGyQ1Kzz1Xt
 nFusjpM1XfZPjLCqPubUDd1WBS+sWGB4JlAJCA0ORx/VPUXZLFS5xlWc2xUaAwVzjuqwC/U9v59
 cGhZJsgcjK3ZM4rm5wey+bG/68nFQchbmQhZ/u+9zD7LH+8ZtMUsZ5aZXDNR37hgvV/LlqFu73O
 IzSAhr5DLI3u+lLdY3YlnZQB6+Z9YHgMJcURJIkg5gSOS+/NrjKn+BftN/DSb4MnQ+6JMWQ+fUj
 l8d27TvBnF9VnYluLQK7dccU9ar6KCSOxHDkXOmFW1NYGPr71CTWePfhGkHEPphF1I+/uGSRTYq
 RntcHu7yrUNSo6XkRutkXlPAojGJawUcSfJQJ/DSQy4U9x9Ymk3x0WcBfO9b25lEWz7EJxLU7ef
 UgmxlBT0lCRcvkScaBVbpGLxc1MnoLcQF5BjV4WY=

Since per-path gendisk is hidden, we have no /dev/ file.

Add a mpath_dev file so that the multipath disk can be looked up from
per-path gendisk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_device is missing.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b1cf35194895e..380da0b0298bb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4017,6 +4017,52 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
 
 	return ret;
 }
+
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct device *disk_dev = disk_to_dev(disk);
+
+	return print_dev_t(page, disk_dev->devt);
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
 {
 	if (!get_device(&sd_mpath_disk->dev))
@@ -4334,6 +4380,8 @@ static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
 static void sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 /**
  *	sd_probe - called during driver initialization and whenever a
@@ -4475,7 +4523,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.5

