Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD4C3D9033;
	Wed, 25 Feb 2026 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033610; cv=fail; b=IDbnzU/NWnxai/imOyO9xk5Vk27+umGRnQ/qnT4BIZBdo3nHUG/bmonmfN2o4d6ODhIk9po0Ip8cna9K3VBkj6Q7sAydDiiQth6yFe51REkKcGr2sc9ixn8ZBT9RUdNg478o16F1ReBtKZYKkTxqraINFk0cWUz9ihlcKuYHvQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033610; c=relaxed/simple;
	bh=UMAB4tDt4k7gBwIMz9+6q45vkbIczHQk2upGGvkcAUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JFVVpZhPZuzEpP4yHjQal8zNi50zF7IBH89baSyrZFaMxFWs7LWPhrb8C0UQCoTKEa4ig6h+Bv2d5rVRNdnb3/t0xS3PAGsKqgSWgUckBhAfOqg5rO5XJEOTIVYDFV+/Q7b6GDM6qdRy/RLy5X1abaEqV4bk3KoDMR2D5pBVYrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NfU65r8c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cl9oDw8M; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NfU65r8c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cl9oDw8M"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAGx6v359748;
	Wed, 25 Feb 2026 15:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jOCMQ+0EevgG67V7BBIXSAdS2cJ/aI6eGcpq75Gsnvc=; b=
	NfU65r8c+CU4r/pDMKFT9S8GldRHArNOQUdmWGNEIffwIBI06yhd58+XwzOofryY
	83FY5u1v4dc1XAnw2CAdlygET2DjCiKq0iMLWeF8uuOlYqTIxigg0SOas+HsQ/m+
	j+I1DYCa60Wbrc0HSWykgxdZXJfCPi/pCGCbYkIc7nOUIRfhIJ5SAs0RlqLjlYwK
	UGyQYQ+pvDTkFp7fgmVCx1i/XGMhpMYmh6W5UrD4B71iWpmfH9tLh735OoAz5rGX
	PDt1jaBTvpx+nVJlwYTljUHD+rKVGV3Vwsm5G58sYDdRSYFUXcue9J2VYbOhk8xR
	DIr62CzlW1omSTaRpXNGkg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7xf5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PET33Z038418;
	Wed, 25 Feb 2026 15:33:08 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35nfkr0-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOUuDoq5nGa65O8QP1I05ZM2+rXmsvNb218IO1FqKt3Nzxiu3APdReHod2P4hoQwdy7SvB5hIJa1ZHF37aDh9FgzfMHO885+6mVvxbDd2h5lc2s9fSwhgfwQIFURlQJoOH+w4BMPPlxnNQmEdNCiZaW1bsCM6K0ih1l4QKxuwY8afhvVwMYdLqK7XNgooSkUNr7irYE7yBs+pn/pkEIQpIINXaOkoIYo0oN4R90lM4+8W1Z4Rrc7RA+2cvuumc8kr8fqFoYS4He5xM4p5tfFb+QX76LpNlncrYPabQJ3EoSPN7EEkACTA3rWqw+tVet7ycsX74Fr6RGZhnRrtFrlWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOCMQ+0EevgG67V7BBIXSAdS2cJ/aI6eGcpq75Gsnvc=;
 b=KoFE2IlKMqDxT264qXPBWwzm4COsPNsZzYrRbDp72dTYbyLcJ/gKF63cXjowzZXguV6+ChEQVD+NyLfGwh23uCXfNOZssypNE5p3yGjAeO/uxOLuEalU/QNPegaCfNIb4E2DBlCeFNLrny7ZX1797Gl0B5rK0rkZT9dxJ8ioaOHEZvZiubanbS2ZOwZnpOUsBg1rzQ+O5K9/1RahRUJxC9QNsuYVXBB9HNw4fnfdoVqC7tDY/36cRvR+s4LB8QMB+WM+qddiYM5OC11mCKRZlwoP/pZC8MZw9fM/KWyXmIyYkIkhTRdKo3uR59aNyzMEYC0Tq+OkrO8w7Mtrxo5PeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOCMQ+0EevgG67V7BBIXSAdS2cJ/aI6eGcpq75Gsnvc=;
 b=Cl9oDw8Mf+v5XDfqqAmOfHWgq18bpQelxh0dqPTPGT9FuS+9Y9chWo8TDwcPlyphc9J/dp/kwdM5RkxMolWr/vykKnR9+DUl23O0ZYTHqoZRmpLCsZjQIifQiaizojOlsjEYzOWtHukK7u2Ui06WRetWMFipTThW6UgaPHIhy64=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5017.namprd10.prod.outlook.com
 (2603:10b6:610:c3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:04 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:04 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 08/13] libmultipath: Add sysfs helpers
Date: Wed, 25 Feb 2026 15:32:20 +0000
Message-ID: <20260225153225.1031169-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0016.namprd14.prod.outlook.com
 (2603:10b6:610:60::26) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: fe310499-aafc-4546-2535-08de74832b0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	YUIaJE/jQCBz3yU2wAb9eiHp8GOZ82RrNCtwn1yk2fSI47aGlrB8bWYbsg6LfDSEoNsLWUfR/4OKCUm1Cr1vAEJugku8766yQnB+qh9jdMg2m0xJGr8Wh0yaoYbUsXYmnq/YOT2cMmMT+MOsdEaCYk+481eYnBUoeYBqfdo7Lkkmp0beYEuI0oTTKTLxiFFS+c6I0wepQZ9egqg3UDu6Iznf3VOoDmAVoVYtm6QTBo/htkmRU85c/GcrY3/zuJSz8b46eJpyJaYu8HWXq+Dew+MRW7MnEeXSmUcCyMyyNDB2WK9nc9mBWPRwO1rO1x9j8wET11ZkjWLPrrO+2fdtsAkJFXb5ggGcme1ltUzJj8bvGVyJRditcHaiMEwIstL9ItyXbOCz0w4ZCBNxBich6F/7jR+jzAwbbsQxqPCVI+ob/SrHoR8Ojq63XlrwjaEe4Gh5NWuBgT6dgN1Mg581ShcCQiWTks1KlZivdquAr5O+HPLoa07ck1S9hMWA/tNU/eaFpKXHQ9n9kjGj7zVa/chrLoYlibo/Q/rOZ2CPbC0WS+5bheKmDPvJ8k6JbO6qzNQlKkjvr65NGagc9pAf9RrG3QmFrGUuhMiYp1m3v2+R3bRnJUP67yWn2dCf0k40U8RNx/CbePbInjaIsibEMS4bzcr1PILckFU9OsdIMyrf7riJPOMOtIEnOwDR1JcR71c+hWfPop9AU3cYVuxEccfAmZSTSzCfyug62AEXK/U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p3tdV8QRhwYrvX1wo6M9IVqCZw1L4oSqcNQ2dbWPxjnv5YqxXjAS/KzDnFo7?=
 =?us-ascii?Q?IyjQ1BQBL+KV216PVXnuufStxewDSMsVE+KaUCRaaPEopKZGW47ymaMmPNvE?=
 =?us-ascii?Q?pUFys4HCkNaXl0BGfALDjvobzdZYH2S2j27nnVagEoayR6cE4QlrzoxfghrV?=
 =?us-ascii?Q?bR1O/N4Mavqe0GAXAMqg99FEC0a/oNn8hevQ+RDa6imFVk7eQbb/gSRPWxAe?=
 =?us-ascii?Q?zdIHxQOKGgmJ7dwXcCw+lft3YA7R5i5Kmb+WBopBwvZ1ybD+yjjNF+ciNfwG?=
 =?us-ascii?Q?7eiqyqY+GBGXKcRMeHFh/l729s4wpAGGDxrR7yovv3YrCD2rOhrH1PzvXp7k?=
 =?us-ascii?Q?4CJDByxVwRw7FGAmJVrs+e0wf/+gh/NPXuWtu0QuN0Cu2Tp9p2GItRo7ZUbT?=
 =?us-ascii?Q?dwhCuLEzvuMd5YApjfSAq/3LaRSsEANTzeLcXPdxatLj6zDiQ24D6lK3nJe1?=
 =?us-ascii?Q?8tiH6NCgS4KQ5RnhRGq5XT8qr4GWyMNAEw/E8jL6J6qLxZ+NZtBrAfPio4d5?=
 =?us-ascii?Q?hodTDBaFG7Q+VWeki5vluKyfmj757LZqk2X5Htr/zsETWjuBIW2wJGT2LyKK?=
 =?us-ascii?Q?nKYpF8a4k2LxOlSwgVqB8dNSKMCE1MUwWeYgFBLiVDujI6Lan1et2GaCx1Th?=
 =?us-ascii?Q?qG5aa655+q6aGOlxgIN81ACUWMcfdkS2xkaXKrWoDlwu4SqSgCFzObEAO+iz?=
 =?us-ascii?Q?fh9IjehwULssWk35JMHEjX/8Sj2ygnQnsFOAlyfhdcu5qIFkFsZ4JwWTr3aG?=
 =?us-ascii?Q?PYoaeMFLDfSGS1cx4qgV/JUmf0J8oY+APeeqUoNlwYnu5Np/XcJKpjh4m3YE?=
 =?us-ascii?Q?iZG+Rbm2qA5kq1qIlMegqAsCwbCb7nhHYm67plxU1gDVUn5gKqYy/UAVt5B6?=
 =?us-ascii?Q?VtmX8fzEqNOtjr5I+f+LwVZUGWU/z6vi8jI/JNRj1mwV9BKB5sqNRZfXmkye?=
 =?us-ascii?Q?jM03dRwHEEbaJgxW4gIyP9BPczM2MPx57Dzou/cbXgVUDLew/w06+GBQTq7O?=
 =?us-ascii?Q?9InTCWKGdz58BQ4DaN+AwgIMgyQScA8lk2GlPcEpPs8dtz0Pzxl6LiFClMbF?=
 =?us-ascii?Q?nKYO2TWHCRKyIleNqpBXbYBpuDjjTox2miqMgCgfRmFyNm9za19sU90GNQlH?=
 =?us-ascii?Q?3SShFwjSuSDm6p8UERA+FikqtTzPgKAJGph8wuU/SLRP5BUT9lQLKXysWHqn?=
 =?us-ascii?Q?IwbBrxMk4B+Nvh9fJ1pR6Ny5U7Afbc5K8N+fwPTyq4O8w3S8tgYH1xeGgHPR?=
 =?us-ascii?Q?JSDAYmxZTwUHt1vDUtE2jkxHUHTV106GydE9E32iY9xB45HH0vpNlbMf94iv?=
 =?us-ascii?Q?BTzA6ceLWy4ue9ngKb7pnIbT7Q7HDNwmJT8gcQmvRaDl/c9jz6WmYlxJWfDh?=
 =?us-ascii?Q?NlywKtZGGWcVf2K2wdbJPUU2RdE64A044FYk7NGhvgMNT2Jgqff8K1M9Xj9b?=
 =?us-ascii?Q?2abTZ3BtO0WKWRFuR2+Na0QdZU+xT30eQ7Tga6fbk2wlcUfHK+dx3COswHAQ?=
 =?us-ascii?Q?7XPKAH7DPkfs0yVHLUAh/whoYDyIjkR0kuk5Z+TSv8Uvk6TfL2HTCWjrhvPH?=
 =?us-ascii?Q?PnOd8B7lV2WtRBtw2AkZ4O73hHoP0V3kFTJhoztXpHnNbZ1W4y0Ay7VmeYPt?=
 =?us-ascii?Q?QrtWNj2LQMrVsUUM/TeQqWWuKy9dvRkKeEX32H6R+8PcnjcPTPNS+/+ZwXMS?=
 =?us-ascii?Q?OQKlUO6FVtO+7pWxKxYiskUONTv05a0WZv7v12jwaqoGC7aLSWlSjtrEYMj0?=
 =?us-ascii?Q?zNTEnaYUlVYIJFNGCvFivsrKy9HEea0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5JEhx5BsJ/WaDS2S8sGKQqGfxDGCzrbEtGB5GI4Z4VaF5tSL4mNrDm2dB8yHs4dP759Gm6ASpsmweES2ClvhCheZYgwtNEOglkUr4ldvPjnfe+M5peme0fPgV0h7qe9bvq6JpeiH0ZHdfjyKZsBlqx3MveA+J9JOl42OQSNBrEF+3jg8r6QiV2ewUnZYT81tJcVo1tRbLZBl/58Rt7fElwSL9z1Rp95wA3EVxAzFgnt5WDpjVtSHTK/b10IX0f+3sP2rZaa7683eOk6iKl7Le6k5dFJe6wTO2OQWY6YYZ9p9kAw4oYRmxbHBkZwNLmklK2TQaK7GlLIO2Wa+/7HgFz6PWXIZ1lGPuDiZ7DSivsTx+fqhkQyqjIF1baqEURMuDpazMADNyVson2vNIJwGbEZCbL8xslcBgOE62KNbOgwxUCzdEB94y2ukLLoToeNhDJFk2KpVwF1BZ1My7yAyDCCwRKQoHeY36kNmKNBvIGcpg2IZ4XeehkOB/RKPV6TU6sHjZiGCyXcJxfYD5z3Lwd4c1xv8uzb1jTBil8L9VDEWqieKLutLLI+sbdLG2mgIXdca93r3Dy8bLEwtdOcmZenYOsq7MDSf2fHyW6EjUpE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe310499-aafc-4546-2535-08de74832b0c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:04.6869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWcvpjKwEe8QPs62u94/1rFQ7auVarxvF7awCGlFNzITyyD/PBKkKWbd19rE+/uEhVr2ClvozqksmdGiINSJfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699f1636 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=FsjrASi-RhFkZEIeDJ8A:9 cc=ntf
 awl=host:12261
X-Proofpoint-GUID: WeZCTi4Y-LCUzs1Y-FjzYj2SgD69-XTh
X-Proofpoint-ORIG-GUID: WeZCTi4Y-LCUzs1Y-FjzYj2SgD69-XTh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfXzrJoimY6ZMzv
 W8GhMgcK9XkbF2vMtvm+bDpv34vikEAE4gz691xeJ7KBGmda0PyKRtnjzjCrn4hUjhwFebF1LW3
 JdOGuow1Rj5giRr1TEY58fg9luR45Ajjw2xxUPSr/c3dHjYnX3Gl8foWATTQlmkTFzrP26CqLFL
 i8IadHg6GfpxBDO008PIj1HFDriK0/5TTCz3JdVvBW3mY8pLPGfreaia4e3eMwCftWAtmP09SVf
 ZgJUYU4hm79OriYI5TeV3XvZ/J80Rg9rfjaqy/OyZYCXuklef/WiwnFSmsT/2QHCjbXOv20udPi
 SQwM+Aygt4spmW96BEhg16arpiqCrl5AuzPGtQpC1kiNpF9xSBjzlRgf8/2MUwBXVLw8zukRKfN
 kiA3k2xVEw3qF++Tp/6rrZK954WAkydkDnSi/w1hn4NfM6nFnQKGKIC7ZmhJGSswvUUyWQAKyVQ
 NdX8N16UsUpkKHuTbD/rV/uqSOrEpFlehy3EjF48=

Add helpers for driver sysfs code for the following functionality:
- get/set iopolicy with mpath_iopolicy_store() and mpath_iopolicy_show()
- show device path per NUMA node
- "multipath" attribute group, equivalent to nvme_ns_mpath_attr_group
- device groups attribute array, similar to nvme_ns_attr_groups but not
  containing NVMe members.

Note that mpath_iopolicy_store() has a update callback to allow same
functionality as nvme_subsys_iopolicy_update() be run for clearing paths.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |   9 ++++
 lib/multipath.c           | 110 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index f7998de261899..9122560f71778 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -10,6 +10,8 @@
 
 extern const struct file_operations mpath_generic_chr_fops;
 extern const struct block_device_operations mpath_ops;
+extern const struct attribute_group mpath_attr_group;
+extern const struct attribute_group *mpath_device_groups[];
 
 enum mpath_iopolicy_e {
 	MPATH_IOPOLICY_NUMA,
@@ -145,6 +147,13 @@ struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
 void mpath_device_set_live(struct mpath_disk *mpath_disk,
 			struct mpath_device *mpath_device);
 void mpath_unregister_disk(struct mpath_disk *mpath_disk);
+ssize_t mpath_numa_nodes_show(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device,
+			struct mpath_iopolicy *iopolicy, char *buf);
+ssize_t mpath_iopolicy_show(struct mpath_iopolicy *mpath_iopolicy, char *buf);
+ssize_t mpath_iopolicy_store(struct mpath_iopolicy *mpath_iopolicy,
+			const char *buf, size_t count,
+			void (*update)(void *data), void *);
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 			char *buf);
 ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
diff --git a/lib/multipath.c b/lib/multipath.c
index 1ce57b9b14d2e..c05b4d25ca223 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -745,6 +745,116 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
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
+	return is_mpath_head(disk);
+}
+
+static bool multipath_sysfs_attr_visible(struct kobject *kobj,
+		struct attribute *attr, int n)
+{
+	return false;
+}
+
+DEFINE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
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
+ssize_t mpath_iopolicy_show(struct mpath_iopolicy *mpath_iopolicy, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+		mpath_iopolicy_names[mpath_read_iopolicy(mpath_iopolicy)]);
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_show);
+
+static void mpath_iopolicy_update(struct mpath_iopolicy *mpath_iopolicy,
+		int iopolicy, void (*update)(void *), void *data)
+{
+	int old_iopolicy = READ_ONCE(mpath_iopolicy->iopolicy);
+
+	if (old_iopolicy == iopolicy)
+		return;
+
+	WRITE_ONCE(mpath_iopolicy->iopolicy, iopolicy);
+
+	/*
+	 * iopolicy changes clear the mpath by design, which @update
+	 * must do.
+	 */
+	update(data);
+
+	pr_err("iopolicy changed from %s to %s\n",
+		mpath_iopolicy_names[old_iopolicy],
+		mpath_iopolicy_names[iopolicy]);
+}
+
+ssize_t mpath_iopolicy_store(struct mpath_iopolicy *mpath_iopolicy,
+				const char *buf, size_t count,
+				void (*update)(void *), void *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
+		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
+			mpath_iopolicy_update(mpath_iopolicy, i, update, data);
+			return count;
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_store);
+
+ssize_t mpath_numa_nodes_show(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device,
+			struct mpath_iopolicy *mpath_iopolicy, char *buf)
+{
+	int node, srcu_idx;
+	nodemask_t numa_nodes;
+	struct mpath_device *current_mpath_dev;
+
+	if (mpath_read_iopolicy(mpath_iopolicy) != MPATH_IOPOLICY_NUMA)
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
2.43.5

