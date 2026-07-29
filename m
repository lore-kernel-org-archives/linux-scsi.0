Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B739470138;
	Wed, 29 Jul 2026 10:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322401; cv=fail; b=JNvHMHMQXv5ifKUwvHJy2i0MUHAhGxZSYRqMrv/GVj9YLo5MEGWZlmwzk933NC+ftKzXpMANgNZhHZN2HVHKIuhUrR08C230Vx4oYTymZjqkFgSbXLOiG1PwBvZWggZZiTj4388H9K7ZSBl1DsMQmUHmHFFWucX9xgRZsRqU7bc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322401; c=relaxed/simple;
	bh=yQOaXJ/uTiELJs64G3YGR0BQ3v++ItLpCpiQnAT089w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iUujk94QGzSJ16GMMfatyZgQ8ZlBgI6J6nIvniGf4qDyrei3KyAAfCWtO4P8l0bwTU9Z3u6gqON1tEx8LRiTy8YKNLg9rL18UZ7ue1a0m3R7lFisgQxDhMya1XB3ThKcXTsWaelU7XmEGrdLeuRjKyjQpXgKodr1sr3Y7J4l2ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sayZpD5y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xifFJ3VG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sayZpD5y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xifFJ3VG"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9OM5J1094334;
	Wed, 29 Jul 2026 10:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ObKDM9IFJTlrmVDPciZu3erW+nr+SZx0wgKiobR51M4=; b=
	sayZpD5ygaxI3ahDPHJTouei1JYfuT4+hDbnKs+MPXd5WakIeP/flSj07EkAcVaO
	O41T+mOofgIwD2gIBPNIJWwIRWqtf6Ywsmc+yCByvFQkwQKdJXPdnGDHdTNVz84O
	vjGZlGH0sURWmlU1iSFprrfmjWFCuY+xheBTwBw0URpGoumHgktpGJnmkK8aniKZ
	Y/+TnOSf/n8zWfjzIMdU9WoOPWnIVFI2aRT1qabfSeMS/muppdEva/17RhdCLfKr
	Em7SiYC0kNsk+em7PM33C6/kjfdJlajXxSonfjcFuBYHv3XEqyOc+pa2jS3KWhY/
	5prJtMJtCGv2D5Uo0BOMLg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5k60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo5t8039998;
	Wed, 29 Jul 2026 10:51:51 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010048.outbound.protection.outlook.com [52.101.85.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrk3k-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AHOeVR0pys77SfDCvjRJue5GNpLxaDKULkol0V6r3XBGCT6ZXJJZWmXXhdtNJI7POITtDaiVGCbN/OVnWPwtXG/FXJHhU02Uh8k2uluRg0GW6PxOal+v9/KHes8e6NA1X8lHD+8DBYOsKDsxZZHAF48OxHibQP1Uajm5ewHWwjrn6ahw5gVgGGdhUpVtETT9Em8pM65nFOY1Keu2+l5478V5uJe1CRjjVsVMUJIPOLeezAGAj/tq9DBbRkHmC4b1IUzA8GxShRpg+IvDTOTKhvfD3i9JYUFPmfxh2ZIQ5li3FaM13ewgegvK7Ky/8GMFByT5UA1U9GIOhGQs7ExLZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ObKDM9IFJTlrmVDPciZu3erW+nr+SZx0wgKiobR51M4=;
 b=fkG/yzf9CDqpekpXsGDnkS31scqZfy4N43FPI+WCD5tN4c/Cg1Uvoke4Ge72DkJpER/Ak605y3XuuZOqPr6/aW7Ouwd0m47/exnrn6NBhObK2e1s3+0mRUH1DfPWX92vDK4UK+i/4DmQyoUlFjtBntC5j+OLXvX44oqilso0HgHcsWEiuaAwE3Z44A8ew7ET7FqiEnBB4iKfKC6pMdjcGP992/Blo9NnTUYsItyZmXpkHv+JORyrvva/dpJo7Z3JLJGauO0UFi3xcUTSBn3BkeZr+qb+wB/DfjpqyrBjhgyWnXVxuW8aqDMFAdG+qMA/ddppIxpCyOOCyQ+ggETP4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObKDM9IFJTlrmVDPciZu3erW+nr+SZx0wgKiobR51M4=;
 b=xifFJ3VGUl/fETjYvxD1x3hycpJ8wK/QTL2Aw76LMSYNvNOhcDK6LQKPqk34FWAuTQuTOHrcWz9eDecsPm9l1rTZyq7Dply7x0J9iqJH4yGHWRcxE/63xP3ts9RKLud6JvdDrlM4wzrZKe4pRW2aw3cpp7yXXsdSLK4Xl82Hkpk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:48 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:47 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 08/27] libmultipath: Add support for block device IOCTL
Date: Wed, 29 Jul 2026 10:50:48 +0000
Message-ID: <20260729105107.255712-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: e53c8511-5b3d-4c9a-1e39-08deed5f6323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|5023799004|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HwjbH2uKtYds9FAtgsRzaDJzIT5udLIvpiZsXfhO6a+yPFEohqSeIBz3L1A3Bw5XRZjVkQ/dicPxb6HGSCXRjKbjuo2i+/xys+ua+qGd1ICRjne3NCpDL+CFTrswEb8HOPtnulGBr6MQPS/Dm2aOR7D0YTFr2GlCjM+g9GCLCVIojECgtfqby3tnOczFw5nW027igY7+vTAgDWd4vuq4wH1Q0wiQoEjrQlJpUvGvdX0pnOyD4ltzIlZpkGs/0kn2OmB5tRcYl69ssPdy31t0nN3igLRbqZBgEYDjjhCMBVbPeGaKutC+pFJ4w89ESXVn2NVPcj2X/7/7sxu4xu4MfPU6iKFaFCUoovTfIYGO6VeEhOpfdAPOA1/7uqfFYKkabvrlo1m4HBnyQjlBEKeufT0osFhzPShKlyoZLiAMCj3FWQetrmqKpasBlH+IRgvih8IBB9kbGQYRcWlqvXqaXaw6A39rtOdz/l+dl7kc1eYdrbeCuzoC9E1wfwhAhJhDUXs94P1yGJKHfxATM2BuIrsCO30tM1JNr76+O3HmGDxWyr6p3ZZPklQjBgTWuUVGZuGLvrsnFI6BTOoRPT6LuDGJYqHXY+q3ATq17to0+6KqOBymx3hSDIiD3culY5Bn7lYdOd0OMBAdOygtmbEQ0SnYm2T8XjU4RuEDkjNwO+0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(5023799004)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9nYViDKqxxOpT7T9KQQvQ4k+0t2un+NrIrFbh52IFr4NDoTwHl0ngQ8RtJWI?=
 =?us-ascii?Q?FAid9e2uVKNUptQc98p0fzx11Y3whKW/CD2ZQ1mucGE3kTmnQitZJVpW5TUI?=
 =?us-ascii?Q?vC5bozhsj71APOSluTl1suaSND6atvgQN9PQ18RdlVhGilJX6Rugn0+v1Qho?=
 =?us-ascii?Q?1kLOaH7Qq1hyjqj4nClIYMWUV7sSZsn+UFnX2ITpR9oukz/vAlv6Dv1qTWet?=
 =?us-ascii?Q?9lEmLKcYbiPHls1airmzXALZ2bHD/WGIcj7rKJnP1hNw8QKLHzEW/VMGCDL5?=
 =?us-ascii?Q?8g8b1HGDK3PzOs+b/XQYR+4+u3mYKmPQdjLu2huF8OqSrBbXQx675l/RGs3l?=
 =?us-ascii?Q?ik4TWFKLXkoq6FRFP2NTYrDTsxmpjlkpxtNktZjKRE05+cGPfXnL1Qhjk7od?=
 =?us-ascii?Q?Fs6Smhw2z6yttTpYJzyk7Ah7/SMMt/S+3oUxLlzyHGQ+8DiE83tgdwi2/np6?=
 =?us-ascii?Q?6Rh34LaRFmZgRzF4cWLy9SDjLmuyN32JX79WjE0hf4Py0ECam8N7Utq9Xbfo?=
 =?us-ascii?Q?Wuu9F6oGGsL8Idy4WzLn0dmTz+cUP13QYDYU/WKhZV7/Y/wz/oT8XJ9sJXfM?=
 =?us-ascii?Q?RaAsNq5gXIExuRbqcIGE6SVNx2biiFREVOZdjbcFuwOffrw8B/q1OqbRu0z2?=
 =?us-ascii?Q?cKb49W7IKtb20UwYIJjFX3Wpmnq9vZoqKvXkrO3rBs3RW2xcwS5B25RL89Rn?=
 =?us-ascii?Q?Gl/mfutlQu1N+PCLMmHeZknD0RYDQiA9gsjAo7ed5+Yoc2U2EerB1+hVkRs6?=
 =?us-ascii?Q?Mj9oYBIIfaugtK+Bgsh4NBYaL/q8cdZat3jWu3rLJwKUaNqbwnhdc8efRaT1?=
 =?us-ascii?Q?0BbwvSGJ7fwQQO+EzUhoNvc54EGP/x0xUE1qXCvuAldhqbJZiYnebDM4h5Jj?=
 =?us-ascii?Q?+/wbEe2ff9XM8ER+kgT9s26NmwDmHUfyyqaTysZZGQ6mqiF/JJrH7QjXv9yu?=
 =?us-ascii?Q?AGQckirsV8JpeSz0o+65Z8+YpU6Qm0s8LBafWLurAen1mXEvuNC3sP4osIZd?=
 =?us-ascii?Q?CF9XWOPz5NAx8UioLi89Mv3rtdMoLT6rHSN6ee5Zlw36yQ3Vv8G1VWtU2dKn?=
 =?us-ascii?Q?CRkThvlbWqndQFnQ0GQEPqjcdvK4JBimYK3/BZjwc1XMJ6uKnjxgDYXCW3r2?=
 =?us-ascii?Q?J3ns9qBGh5g1PJZwb/PhdNt/tAX8LRb7gzcDj/nbA6S76nZ0X8NFki+yrvNp?=
 =?us-ascii?Q?SgixIwZWKq+puM3AtwZx95P0peFd5kFZs5v2Oy1eKxtZ1kY+OkW9U7PZhbfE?=
 =?us-ascii?Q?it9qxRA5FIpUQFa1aRI6sjV1sXeuyF5R+IBPZEWqbNLfDHiAezHHjJAeBCPF?=
 =?us-ascii?Q?IfAO8rhy3z54PUXjcYIqcxc7UojREBvZRzJvV2uJYlQfmV0xP5iCM2jO4UJy?=
 =?us-ascii?Q?EFWU0N9TtEbmCMykozqaL4LC4imoJoYBtr5/YqwCuDoHsb52GV5kLxS+bkA/?=
 =?us-ascii?Q?BTGtoE64+zy8yH7lf9lTZN3HZqr5yw7u2GU2TvE6hFWJj35aJIbCdn8zlGmT?=
 =?us-ascii?Q?zXm6kNghf5k681fQVNCXrNtZEPrF9zMTb/bZfDWO4aZXECyCSyzjwDwVNseG?=
 =?us-ascii?Q?Zmzr4MS6gTjz5+lnGstKQYo2ukLMKozr7k5SsxLLVrva4QnqgJ9btlQaFu6C?=
 =?us-ascii?Q?gqQ0bAVxu1hn+ULOQCzGn1uGgRstYiMgZ0WWEmuKs5niItoTTyzi8lxjOQaq?=
 =?us-ascii?Q?bMDnqbGbwZLTEP+xfrPRPtrHCrPsgXHMx5k1f6RwCynU3T41ljFDNdR29apz?=
 =?us-ascii?Q?m2YcVur7Zg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	hgO9d1sXxf/0bpwacYbOQQ1c1bLKwTY72EXe5HFDGk7IofhT4YEmktGLaMhuPLTaS/Tsrj+cJ/pxsfGQNCu3RhRT9gevL5ArAUiDUA0hb3GadnIgS4xL8nyIaemxDVqF9nDYhJPJNhBcd8SH5yYyZKmtfwaBoBvao2c5Q0ILctA4DEiLadI6l490q8pn4zPiJ0AjPUYnOQNqhrMj6AveuvZPCBEhweVA9zkhjBh+f6PlJ6GoEkwI5ynQSL6pFKI2fgVxePo5lFomUTthvwhPu2YehZhhIGpuvVGJLCbZypbt6n1Cet8MdH2HzJAwvoWdaucPZwX5RIA2chfMU7FbDA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TIjTNg98cTiEW6V5S9j6T8FuHD+8RDTI7SE0EpZRV5X86RWxatNtEfMMkUCki+CJ2GXRQDh/S025GweTQxV36SsZvx4CNkJm4VYX0Qs0NeO15ge8Lx2odKp0xuxMRULhBxh9HJhpl77Hht/ugWV3voxF/IBWnfVTqBOauwdBlnpkNKP6cFQsYhQZW1BRJOrSOVBTUvst7twJB8vG6DN5hDTw6GztJ2mdA/5CgwNdAgHTbg/izbuysXCEpfO0TiCGG0dpNgItJRn5jqsRFxrKhs+aKaB4qnZbO6fvqVBsvOfCzluVw4zebGno+oMU0U+rzMu8E1WUB7WFe136xztTf4dYBClETvhjD3La7XW3cWXlWdSELlYpJyqDHNannv506mJRPGVvdqtPF5YTYPKJSQaXQQSggkW3wkIxHXVRyfOshZJK7NSN791sKZP8Fmnpmr864M1mHZ7b3hc+6El3GS69ThYWh5xkK+OxstCrb+9Zz9ZDwCpwhEIbYbihNRuvx0WL7MXh4qZbgeTL9Q75AIjKVLCJVNqJStqZUFQpKBuiAmfDuxyid9bd+3AEC5idVV+iy8deP7a1soCMxesgqvfSKKaZGjmrITxqHBV5VeQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53c8511-5b3d-4c9a-1e39-08deed5f6323
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:47.8791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XlvAO2icu3GPPcBaU1uOzhbcwjk6E299mGMQHZKuYHVQRXlziqjIXZM/8SHReIasxCu3bcZ4RBQ6BIVzzWov+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX47F3FxlBql7C
 hF2MBF0DCFVLP6b6supQjASyVL9aENNhRettrO1WS/LzaKmsQPXct2e7xo3onS5DMIvZlPGjXEO
 Gltzw+CUU7wrQkNABGvOnHNKug7odkCbzkUAbmNqCdM9cyluUysI
X-Proofpoint-ORIG-GUID: wlhNJnQEK1rsSXmNYl7vHY5FS6fGJ3kR
X-Proofpoint-GUID: wlhNJnQEK1rsSXmNYl7vHY5FS6fGJ3kR
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69db48 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=MdnUEikRHl3WmUNKqWUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX4lG6tynHQmOe
 bVF+EtKlorCdom1Q5FAPSkJ9VUZ5ivyRnj+nZOjq4ZRwATD2QN2JjRgaMXs3z/qgKnpyaOVkJNi
 5JczsfQksf6ej3SGD/XSkXjSmiOqBN+GpoZbYcJqXbEEQy8J5qhy0RYEVnlWZC4hhwOh4vjNi0C
 biQ9CIAgDH3gFCBLk0U33dWZFpjbZA7RMSCrUTwyVdB3KXjn4ZpDz1s1rXeTye+2HlzAsB9JiU9
 WLBCOtJMGPcaUgNFnEkNxyGASVRW7kG05tFl2Fp/jxPSdf0H7ukJSJ+FuCxInCawYopjO1uUQTv
 baNGD8sr8M1bm2VEbqOUq+WeneCLWe1jODtY1Advk4MlqrYVpRVyM+lhoSpY17C0MOCKwZfwpJI
 42P9WiVkJvq9qPIY0zJhV0XT3Ob5PV7oRUxgeDx2AZ9QFA5Bj9QvXgNHqiUOH7wansfiDCOg+Ao
 jw23oqHI/xIqrwefRNw==

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 58eb9be5bebbe..f1758d1e60a60 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -454,11 +454,53 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+
+	/*
+	 * This check is duplicated from sd_ioctl() as we don't pass the
+	 * partition bdev to fops->ioctl. That is not yet possible as the
+	 * per-path disk is hidden and, as such, does not have partitions
+	 * scanned.
+	 */
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
+		return -ENOIOCTLCMD;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (!mpath_device->disk->fops->ioctl) {
+		err = -ENOTTY;
+		goto out_unlock;
+	}
+
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	/*
+	 * Both NVMe and SCSI use generic blkdev_compat_ptr_ioctl, so would
+	 * avoid their custom compat_ioctl implementation.
+	 */
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

