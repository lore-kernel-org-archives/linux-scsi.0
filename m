Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC0D3E5A35;
	Fri,  3 Jul 2026 10:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074911; cv=fail; b=akaUpGU4sX5/bSqGQaLXbrXSNjhCcBTgNSJJa1EK2Riaa9OY+/iFHyPC74mElSgI1knX1EseIu2Sp0cPuELzduizELa2ku04x9MOJazBmroc8fBT1V172UvhW/FG/+GChrR9TU/+HhdTxNLqMQ3jgVOF+wVRFJy8/KPs+ohvKMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074911; c=relaxed/simple;
	bh=dWwJ/89SQVGo1nMfMJT/4tXMD2eSxupxfAot2GSiWMU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ecYKNkYHAy/334T3AP4fmOd8Afo7aLMzRFy8JZxCNmDC1WVDNGzQ8SjX+0yqfi2/SV7GMLuj3zRWnIpiVXwKwqesN09fjyQB81GAVwH27J48MZmOsGekaDBaS+HXlLgk/1Z5iamIciZuBiXALZ/0cVPiccu78EixPLk0iVOI5Mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a65ZmQQS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QSt2eFye; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a65ZmQQS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QSt2eFye"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tf2a3016255;
	Fri, 3 Jul 2026 10:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=V4FL8TF8uFYflZ3I
	AWB2G/fmDePjdgDndqjP8v23Ai4=; b=a65ZmQQSt15xEdJYVAvNmrcVVzNddbAk
	n61v8peCTejDWkUIqUxolbNexAMExciemCfzZyAhPb/uGTafBF/kBXSqdDS0XNpq
	7fmNWB/DGCytZBmulqd/Mhi1K6OXoJ7q7QNJ+T67IzVKAKqsIrpzNOiiHGgvi/Wy
	ZvJEWWoNPK9dzOLszonyraSk0/FepI1QPikX+eBmJEGBaM6nbUU1/3GbqKBCdk0x
	Z/FWzDvzKiV/2h0cj7mjEsjOwYFPUcSSI7qiN8VKDYpNYDmJxCag9bhCzgFfhHep
	CEo5uc0vBUdtZBAs+KCfGcTS0Ur501dGdbXe6HiO5ed9nHa04X1npg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qtdq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AX7UQ009541;
	Fri, 3 Jul 2026 10:34:34 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010065.outbound.protection.outlook.com [52.101.61.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhytqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hX3ecqJaJSY2VZdqVojeLOxDLQd/Et1ZOP3YjxV6LzHejQ7Wzx96g4pL1QJx/A8zLrLosFyIK0XaUB0+RxWaZj6/mmnAriwJH28zFYFhdoGknSW2YuqZkQNaKUKjj2Xt/pZWintE97ogaLsxA92yLeN2d9MP38ezk7e1vuQm3A0k2jMtTbijydxVZ/yHs63Ir4orsNvPOVQtCWs5RNjheO0ex3dI/638GigsjZ7/cKagGpyXS9wvfGb8zN9S1hk5yKecVjB1KaAuHw2Q9ijhKy987XgR8OhIAKQpmodtlq9rE3kdmv3HyeHDtWwGZcDq9CYx3+mVK/8TnDpDoDrnfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4FL8TF8uFYflZ3IAWB2G/fmDePjdgDndqjP8v23Ai4=;
 b=ca5WlIyVtS9RMSMYhbwdx86f8YoATjMlaX4+XKTHzx5Gzpd738xvQlSuyuIf/qGjeWm+/AiBA3mr7EcuI2iO3I3snlKuAY/VYqtNaFwjahmVy6vg4f7y44SMQ7yjqH6+JV2pLxSiRh9RdI5dNSOKU0gM6PUBLMyQ7gSsmDpZbRv/1IrtNF7E9LtqNCPeuW6GycDX6bMMhRlLnVrdDLy7lXD2HyDjgpNNuON4rHkWR+yqDbWObPOTESihUaEeQjdp6qXuHQjyXzkNoFNeFpKe8UzLdYRfn0Zc2/FG/MViM1YJqqdj85kUgkZCMiOry+4ZC2RHGAL0HCfQnrYFvSAtig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4FL8TF8uFYflZ3IAWB2G/fmDePjdgDndqjP8v23Ai4=;
 b=QSt2eFyeuhNyo0+07ggIcIfzrDpAkhFbC9OGBzB3L6IFhOqdm8JtWKw3Vxd385Bi0CAkH6d3BZPmUG/uJGtkQk4y7p66K6uad/sA8lUIxdVd5rCK/WC7GN2tGbhF/H70w3vMntb9vNGQNegRoJb+3mGTbZszrtDmlLBvmImSmvg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:25 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 00/17] Native SCSI multipath support
Date: Fri,  3 Jul 2026 10:33:45 +0000
Message-ID: <20260703103402.3725011-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:510:325::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: a23100e6-8291-4b18-2de1-08ded8eea6fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|3023799007|18002099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	urtwhyocVtiOWMWhqdtWEnKcDGOhx2P3zJIKP0IHXfYCRhGa+EGlJtKBYIlHeSlNZkDJi/s9uchwJQAnqy7UsiEPhMLTzJZjU5dxZNbAUwdATTKHXNgI8RzeNAlAm34XK8U6NV0kijYUUW3gucJOsMRSpWHRHy2q3xn+u1w9YRI78K+baF0NTF9mbwtNS4qD4WYO/7jGmUtJT0qBG6jnfRd9GNTBqdRL6eIoQmBtes2XkGkjPWSUnKj/YmWtXRjIVA+t7y1e0Icj5Tmx8NIN+lZQwgziAftHoraUvii6nsN2VKgqoCnQi/BhXdg5ESyWDBXPLZWNo2qhV6pnZxc0ngv8ZZI4dhv0msEBYrAWvLDcmMXE4Y41J63HhsP2KzYvOJBqWF7OtQXim8iGeMf1VOR9eNqinHhCIt5YL6eaWprJZpfVrxT5n61i6t0jUBFPs8So0X2p0ONw+6GxTUvNlas+DcwKnniNkcbdwVZQdCwq4nIWTLjFZ9r2UAiQYgGTsYr5IZ6HTiRh62vD6qAmLhUBheGQ+p+etzg7gDoduRGNNDhRD00OeiNgCYS+cECJRvExYFcGdhYxM/oV1Cfurxj0VETFjFmYgXooT2mMkBzPa1PseWGFukBO62o59dOcQGgnwBV5k7MTzsd2LLEmjqKyAALOyUq8tuJKOZvjHYo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(3023799007)(18002099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZXig+lgOITy/B2RGX37WU25jrIVW2velrnlALwG7FtrAMYgNVW05+up3GuuB?=
 =?us-ascii?Q?yMZZPgZSPGPXCGAakNacX3KZKySLJtzYf/2O+Y32ZamOAv07qJUZUdDI2B9Y?=
 =?us-ascii?Q?54Kk1edrO+CzCn5wmuZ6n1FDWG+iwT2EwAwMeWQSjrZEVNRRo3PfFyOdlpmC?=
 =?us-ascii?Q?9RNY8D9dgpK0sLum4S9ayjDS9JELZ0WOAOMsGPqhuQN83YehDR8yAUtXAzte?=
 =?us-ascii?Q?9IWg/534yBBLLfn5+5zU6M3EBcI+1cvLofhkOl5J098DkpoXPBJwvSZb3saq?=
 =?us-ascii?Q?NCYsD3R9QutHPEgHFPhWuW1D4o2zUkXgg+WduIJM3MTYbjQcZAlR9KZy5ekA?=
 =?us-ascii?Q?PYk9r1VhN1FQqfkSCmSy9VAgWLtLnyFvnmjQxxm/oAwi5W8ytQL5Trbicoox?=
 =?us-ascii?Q?OSPsqOpNOep/n8OaK4UwdBdEJR4NnjOqFw23ej9ZBmVbQn8L+NJ4pc4NwLvr?=
 =?us-ascii?Q?8KgmPVRYolL6KF3KnyyROLjYS24OlWlmcRfoTfAuaSCwDrMrdwD+1SQDy3TL?=
 =?us-ascii?Q?mjRks5/mWJpt/lCebT/MjLcSYXa3yzLblb+F/YOOQlddivwI1gF86KbxW9YK?=
 =?us-ascii?Q?1WNQHNAhjjUFmoEtl4kXomioPECmWTsa8xaDXHEmCbD1lPcOtpSJ4WKC9PGB?=
 =?us-ascii?Q?fTYltbcTOVzSMiAbq9Ea5qpg+px1lm2hphj5WN9FXZDj/GAOVVtJd1qj5rtD?=
 =?us-ascii?Q?MNEBaxyK7534z+rO2LGGEY4cT4bvwf0Vk+PGF/UDIynPJZAkRPsq7QgOoh0I?=
 =?us-ascii?Q?37o9V/7LuBPRkk4ByBotE6JkJ5ToTnLdq79Cnqndt92e755OgoHLwb8GGwty?=
 =?us-ascii?Q?VtILB4w6txsBJFKnxrluqOUSbLXud15fiW/ZYe1XZ7J1/Wwi0ryjLP6LIQrt?=
 =?us-ascii?Q?NYUVZhNpMbAdWm1W9mEjahN2uV4+3rSHPoceFuDaPP5dDJ/wOMN3znQb+kUi?=
 =?us-ascii?Q?kIwY6bOmpmttn3kHb/bWFpGozT1KEjWvECIvxk2+7gUPL+IZ2HyzwMuh8HJq?=
 =?us-ascii?Q?15W6MQB0GlWxpfe9Kewx2es2cNDV6IC+EIbYLBJmSLTM31jMM02R5YpJMH/M?=
 =?us-ascii?Q?448jeaPvL8RGFcj0/ljUSj7ZEWI2UhI7vbeyKSgMQfFfdSfM0Vcy6SKq+bGu?=
 =?us-ascii?Q?vpadXzvVQiVHFV0W5JJvpp7ZPWdz2rXQgQxNcArnnv49jEzZxkPyL07bue2h?=
 =?us-ascii?Q?lzE5t0K8f+vByVhTDQnDdbGvYA7RvSI81+rHKQ16ykS8jgBznRT1MVcxh0PB?=
 =?us-ascii?Q?RzFgXMNnGlSnbhgTFj5y2InVYQE4nrQ1dC0XdU/6c/rhtFmJ3H8Oi2dKnKQV?=
 =?us-ascii?Q?kAvmlZsJji5zwV3cQXUJYlipHlQ/IRSkBJn+/g8QeVb/ZaysbYOw+UC12FYj?=
 =?us-ascii?Q?N1Wrbovdfb8fM/880ixATRBlwvP0De6wIQRqWYsGFkUOG5eWHCvlrGbfBYTb?=
 =?us-ascii?Q?FpZHO9w5jC5hqP9/12pHuiYm3YfoePsNpIWScG53AqBgKr50oEAeOM8Rndnr?=
 =?us-ascii?Q?teBPfV4cYmAtSOrwOSVsHFiNW7TEy4hn/xmJqtdlFsVDEZzQQI8BDdVVENux?=
 =?us-ascii?Q?AfAWHEc7NPFixyCar97BXqTMEtgteey0hN0BSAxHLLAOucmTaZFB7w+n2qsH?=
 =?us-ascii?Q?y6pDZYCzGa4MfPGWq5kU4OsXSfwnzmDWiectb3dI+Hwkn8ur85C9EHuyIQwk?=
 =?us-ascii?Q?kB0OX4c3/Cc1i2y9Br8/7eBqtFyEljylSahZJEyo2ns0XqUp7pWgw9j1/aku?=
 =?us-ascii?Q?Dbh0TNdkuEHQdq6UY+zrozzCCkyl6g8=3D?=
X-Exchange-RoutingPolicyChecked:
	ZbHEkaRgvZsgxgxucQzvele6v97YC1tSWD93s8vRk+w/IOTPkPSOYfRvXg8W71HuASjivBGzgNbgOQkpM5txNZPhQcFpy6lm8hRAy+FN1JCo79/uN/Y+c4d25k4uiN/IydmKFBjwIjvcQ39tXUXznKd0T/C2xTDoUu3m0zieAQxkSv7E0La7tMCacSKvqfgn2hmEuPH1OsS2ZSnpaJjHOznrMphd+LdoGDDmFInWs7ANFjXKHl7X5krvoZq5MZof6ccwlG2BvSZ4oeIzutwq4Z0T2U18bKqq4L+DuJgzkRlrBAGaXxnsR3X4WO3bMY73p81bfCbxPY6OwUzs5YL37A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fkeZK7UespxkAbCTSSvEJcdpMJmUHKCvRpNZu40DIRhqf/BJIGc40mxUg3TpVUILS8sAoFgfosMhVxwE6hPPhygaeSmloAYU1GSpl5qeBkdERHBpJ2cbYyY2O8vdHrOGaEHIOrMNFmms/FB5arHK1HDYE8UR7xucKL/7QT11wKpFkk1v/2cQ6TJcg9t2AqareD89bXQlbf9AVtAfAaF1eobaFhlensN9Iq5cOK85SrnsFooICJz1fOYN8ysjmiYiEBtLTV7lAdpvIUUHiTrsJWo6Wg1fi8Vwj0Smq0PIHYhNHfYbzfX7ILrzeQVY1HFH3dzman4mITmaj3NXcZMi1Jmnx4xutLr3yRAFwMqtZxjVCQpkPxWMberaFqrtxy0LHD6TcgxQvT0Qt2CzDOp+Z51wfonVUNBDowlnj5UrLz9eoEoC3KmxyO4GeJbdFQbCZNL0snVtzrT5OJaD9p3GOh0ZV4r+WSorVM2fhVWXCN9wF9vY+1t7BV/87OUy+woA8PPp5T0+9OXEhej+tP3Gi6gOOdOFhyCdDLe0bJvCE1N4wIf35RmjayD1Jk8a8k4OYrFNFZQx3oXrASfIiRIjOcbG0lwx6c4z566WPMBUhWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a23100e6-8291-4b18-2de1-08ded8eea6fe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:25.2423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHNyWlKUPBjeA1m8UmClnYn/NNojpppYqUj9n7gaMopZdHu2YE9nbth5OcqdJhH+eL+Ew1vhpVU0Pf6ZpEg4KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-ORIG-GUID: DPOQWWtIxw2qpKqZ9unV1eQLT6XFMMoG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXwKgJNA2MCzYj
 IwsJ+gsl6GsGSk+qAj5K8IaCkzSUubJ2SBvR8GmF8jo5z9w8LZrNJrvz8wGMmHpWp5b3cPDi6fN
 WiMxYdDU81W6N/kqR2JdcHFXY73RilQhMq0VGA9kFuV0Tp//iPTBYZhEPboKR77WaYKG0Nb5V6F
 JNSIoXYW7XcC0aFm8priJrew+VnxX/ZokNy+9ys9uwDNXhjmd/vuKviOe2k7cSrYhj3rMi/wnTr
 cA81FdFAdk7Bxn0LJfR3rf6DthUgM0FaVi5sFETu92dxgLG5v5d0AxV9E5lksXsXfwtWH7AXCMt
 LWCblzKPfeNpdVZNnjT6HUxlcxpTI5SYm6aYIw/HL617MpPBFgY6323+UhLlmMV+Yuao7BxSpcz
 SsQUGFeKop9ButMQ0ffQsQ9WaDZ5FHTWS1ShrsdnO/hk6LLAqSUDrbao7J3CPkE9knBcqIW27be
 Ybc6pncjkFeXLg/wkQw==
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a47903b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8
 a=nBALzb5hNvmWw0m6NiQA:9
X-Proofpoint-GUID: DPOQWWtIxw2qpKqZ9unV1eQLT6XFMMoG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXxs7Zf6jxM9Sf
 kPfgdVtnaGeCWsZSRoMXosBz3FWky6o1L9zF+wKnWgjAfgXy/Snu8wLd1h0iW4O4RxShCNv67i2
 S0BWj610Bkhcu7NXgDJKSzBJicR/JuGQnYTvt4FkDaubk5TKk7LG

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series relies on reading sdev->access_state to get path information.
This path information would be provided by ALUA. ALUA support which does
not rely on device handlers has already been discussed at
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
and support will be added in the next phase.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full (for failover errors).

Full series also available at
https://github.com/johnpgarry/linux/tree/scsi-multipath-v7.2-v3

Differences to v2 (apart from porting changes for v3 libmultiapth):
- rebase

Differences to v1 (apart from porting changes for v2 libmultiapth):
- drop SCSI_MAX_QUEUE_DEPTH and reduce bioset size (Benjamin)
- increase SCSI_MPATH_DEVICE_ID_LEN (Benjamin)
- mark config SCSI_MULTIPATH as experimental (Benjamin)
- combine modparams (Hannes)
- rename wwid sysfs file to vpd_id (Hannes)
- return umode_t from scsi_multipath_sysfs_attr_visible() (Benjamin)
- use DEFINE_SYSFS_GROUP_VISIBLE() (Benjamin)
- fix scsi_mpath_end_request() and blk stats (Benjamin)
- change scsi_mpath_device and scsi_mpath_disk device naming (Hannes)
- change locking in scsi_mpath_dev_alloc() and sd_mpath_probe() (Benjamin)
- drop struct scsi_mpath_clone_bio (Benjamin)
- don't use scsi_mpath_clone_bio() -> bio_alloc_clone(GFP_NOWAIT) (Benjamin)
- don't use BIOSET_NEED_BVECS for bioset_init() (Benjamin)
- drop PR support (problems explained by Benjamin)
- drop failover handling in mpath bio completion (Benjamin)
- use sdev->access_state in scsi_mpath_is_optimized()
- count queue depth per shost
- delayed disk removal support

John Garry (17):
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when device is blocked
  scsi-multipath: failover handling
  scsi-multipath: provide callbacks for path state
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: block PR commands
  scsi-multipath: add delayed disk removal support
  scsi: sd: add multipath disk class
  scsi: sd: support multipath disk
  scsi: sd: add multipath disk attr groups
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_lib.c       |  15 +
 drivers/scsi/scsi_multipath.c | 637 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 556 +++++++++++++++++++++++++++--
 drivers/scsi/sd.h             |   3 +
 include/scsi/scsi_cmnd.h      |   5 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   4 +
 include/scsi/scsi_host.h      |   4 +
 include/scsi/scsi_multipath.h | 116 +++++++
 14 files changed, 1354 insertions(+), 21 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

-- 
2.43.7

