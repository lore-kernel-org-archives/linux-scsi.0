Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444F817278B;
	Fri,  5 Apr 2024 20:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712349608; cv=fail; b=b1z7A2UvRng07lGLUhC6mOsHxgr6ZsTzkWtDFYjVtbsi6IZJ4XLmyMJd+58pWqG6RzW21gYU5Q0A7Z4PXMoS+Hbj6VzPYVAxbtdMSuiqmN+6BVvAsRHh+L6VjO+rQXwPMrtEEzRIuQ9JyhixtPc+aQtpy8sWm6gmckOEUTZczf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712349608; c=relaxed/simple;
	bh=MWBVn/NtCPLIX7Wzw20M/YtLFHs5oSs5mCEkyFVgEAU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u02ruP3LDu0HsO8w9iY2A7Py6ypYW/XFl+Y6x6ttrBBg9n9iPiC42sngaHBFcnb6gT4pIuaPvxRGf/RYrxw/JqV2Sd2dy1yue8ddNnT7ZFTCBZ/YNs863sBA0H+DKVHLZOXQ9VP7IW9g/wsiU4U5MlUtvGGEYNRK2AwjKKcjfhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=InLjki7L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HSBy9/XL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="InLjki7L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HSBy9/XL"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 435JdmNB015792;
	Fri, 5 Apr 2024 20:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=/uNeJ/W2HDlJuStTRn9DEKwR4RyUDaWKc6J075LFFlE=;
 b=InLjki7LRmYEQvrfIQixN33Cm9rTUzr2eSNNZMs0HQRdkmuYgFbh0ZlrJQGaI+FnRvq9
 5Jc8qbibGXa2mKEKMEkKp49wdbcKKtyaeA6SO3pCk5k1h0AC1Ep+wepQD+dLrfuGfcFu
 VodOqJuRsYxuVl+I9lTvQxL6LvVJJr0hoYwnXdv9QYqj1hEFmLIcS4s86/9oaJRvwk/R
 4JHIscVXPe5nGeHFip8JadyEvTgPOZb2MwEJ1TjJ0uXwwDtXiTmBKq83i6bDVhGyYD93
 RecR7YO3zOUlMGBuQm8+RjStmaDscfC0slgnzTE6pUFCoB5xWl7XqZXx8wgXRYxTyjX7 CA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9f8pc9kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 20:39:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 435J6imP039368;
	Fri, 5 Apr 2024 20:39:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emt35dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 20:39:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byr32rx+3q7xrDScVfr6ze1PgqOS6477Eu0JLZwqEKDilStubzoQpY5jg7p7P5GeoIaSjz01hi0xF0rMy3fkZ61Vx7OOCMa+/tgmylM2qdqSHVm7nK+q/gRUjvO347tpWXDzIwB7rv5OUhxOskKYggvML5jmfuQ1BACQ1XLbd8hmNcHq199NvMgEuGdyNqyAu7AXOv1Pzv7bi9PgFNQmBSClKnNsn1W8cvAe5VRzq4WIUj9l4q+QTLQvoTYiQQsDVzCMo+850hqq59nCiXCCIwiSa7h4Bb9XeRCJe+SiaQU+XDs+qs1NydydD0OuK42zy5EFL9aPGxpHmHPk+cRdxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uNeJ/W2HDlJuStTRn9DEKwR4RyUDaWKc6J075LFFlE=;
 b=n8wLmrPx+jJtX64ALW7Eae5kokPOq2TrhiqSTK8DE1nzo7nEuMgAbIH2p93Z+nz7WPbhPXtmzhjCifHzqWsH9diNGvB8kkqVM8cTlUH97dqRtSODNSM47j18kg5Fv79qRJpPuaOEaPAZNu4NHXSt7DnWeTSsecw8XKxohY0HdSawESb5YvQQlGWter9Ad30f0VpJDm0SFeom6Z915bos7zem4/VrxRR4Yor1ZMJReD8WBDzg3Tiavr/MqcNyA24asi+WzPHqJKU1B5qbL04vj+AWkTEibrkcG8LN8lY80l7QSi/AHrV50JIJPtpD2GIIkWdiiF/uB4gwfkgMQKzQtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uNeJ/W2HDlJuStTRn9DEKwR4RyUDaWKc6J075LFFlE=;
 b=HSBy9/XLO2y0MjEqoUqqfjf/2Aso08m8y6OgUV6zvEHcFwptCJJxGnomh2j0FqYuHQZQaMApEe5Zxd55YAStQakM9USZmOH3llOmU4FJnOKl2mekrwBQIqDYye/AQIwRBBuOUS+8Fxyi/zw6vA7ipa/RNT4hdJdSxFTpkrWhd/s=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4365.namprd10.prod.outlook.com (2603:10b6:208:199::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 5 Apr
 2024 20:39:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Fri, 5 Apr 2024
 20:39:46 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        dm-devel@lists.linux.dev, Mike Snitzer
 <snitzer@redhat.com>,
        linux-nvme@lists.infradead.org, Keith Busch
 <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 00/28] Zone write plugging
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Fri, 5 Apr 2024 13:41:39 +0900")
Organization: Oracle Corporation
Message-ID: <yq1y19rsfx3.fsf@ca-mkp.ca.oracle.com>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
Date: Fri, 05 Apr 2024 16:39:44 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:510:174::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4365:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	n3O7wD10WnpzKh5xbYN8kRHF4FUr9Hj57T0OwORV08FOrLAMQ3ZeetDk8SDTNf8fXifyKDw/Ee8x0e0FxVjZliXA3H5FUPKIesTEJVzGgT2Y7QzTBoGxP7Hmmp4HvHdcpFLEPA9u55+8knAuO0lWkfAhD/nzNx9o9Ad52ABn35R1x4SrjPN0LzO+DYEWRrodqX+VuHsLuDLMCZ8cJOckyDsL4Pd3FQcDwcJ+TV99iA8OCCvolPqvUGiG7u0Owu/f+dO5Lp5h64IOqpWoxA7mNA/XGEYJf+b5WC23pbqQ6yL6mqNUudNk+YqgehQ7kMExk3JdI9T7KZV1Fc1DpfH2yFqHajooBadKqLku4WhZ37LBOfCIbGO7f0tcIpuuUMgnJzJEQLYcTN0hJ4NlR5FrGJ2LqCFCR39nWTLuEMiTj2y9fgxDhSvAHL19fdcYJs4a74MhwXBnR/3/wiXU76myRNQqhdjQ9I1NsM+l5l3OZcbN5TrYgFPk9Xe36dQTMGo0hMCvZc9BngEJmWiwQm3/8IwO9rf7hRMXYDqagd8EvX79J3jrP3hacltd5dq7rtdzb6shD8EP2PJFqC2Sg+3xVZ5UzrUPRXnxvF7S/65o1JZuRZ7fV1dFoV1hFuvTvce5oDhgRuzBnLPeWoSa3we7OrbkqnuWy1mHKEV9VAx+rDg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BKvND2N+LsUJv6Lt88gdfkOI8u9kQTSztFV06Q2WIb5C9Mpoo7aeSciKXId/?=
 =?us-ascii?Q?Ntoa3Bt4MDWmTErhK/pF5Kv8LroJQ9r5RmG+i5Rt5un7WdnJ8llQreAV1xVr?=
 =?us-ascii?Q?KeZMdN7Atr4CqmmkB95lvOGIxA7hJMZbWYBKAupXtG8D8ECJ2E7QHQuax0fo?=
 =?us-ascii?Q?N/PK40CCdoY3pr+shEQwUvbl4rcn9WigLkHQ9MQG4xH8EerozpMvMkZMgdDs?=
 =?us-ascii?Q?9Pfzo6vCIdzFVkjpqgteyinCHNmCqMV8dxL7LZK2uPZxYed2atdtobVfZXKR?=
 =?us-ascii?Q?oaqwk7+OTcVqbWLX2Yz5aP3WSZgMO49kzZ16kYlm3JThMC/stySdF1buscc5?=
 =?us-ascii?Q?hA03cyG55nJg1sSssLcCteHXLhtn55SeJYOJEiIxbqmkWAKKL7pwrwc9ofqu?=
 =?us-ascii?Q?bjrnOThlEYvWaXhiw5aXy0R5ioycFcYL8CTiDSdM1VpU8//ASVqmkIvY/Gl8?=
 =?us-ascii?Q?ZFhdEyCWl28QeCeRYiRUi8TvJmsnaXyoCJ8dqOlnuqAIF78LZhn1Gkl1Ck3Q?=
 =?us-ascii?Q?MmjzEdVIbFvA6Puus+pkfki5jad0W9DfuCqJ4V34mMG7wa3ZkuP0xbN8Pkni?=
 =?us-ascii?Q?tu1x532TTOn4Kz7CF6HE0gEGcGYyVc3VkPfZFhTqfOUVzZ+WfxW+GdsG9gL4?=
 =?us-ascii?Q?A+7AoPs7nHgAEHPbHcHtET5Y2i6izX5CVb+O0blBI0Yi1224PfFyb04yRQWg?=
 =?us-ascii?Q?A34Bhml7HyxpaKOJmhEJ5uSBmlieFKbkxIq7tuB7RSbTVKZfkTVLFy1rEVxS?=
 =?us-ascii?Q?0802LCZ6g5z6TQa6pZjeCZNno/uQll9A0ab5/5WQQ+v/QmCN5x5RLYAioXRM?=
 =?us-ascii?Q?O94KvWVutSeJQqtHSOzeCpBYUZ1R6p0X2UzMDEmLcL6X6LiIfB8v2Dr2zg6d?=
 =?us-ascii?Q?2JUgSfegPDrLsOz18g8WLUOogUI8rN4xYQtw8+sJ7LIrvue2qL5iAUGOmuGv?=
 =?us-ascii?Q?nMgeXWV7uOepwdaSCq4yKBz2PcGVfkuZ6/RHkG9ss+l6mSO2Zxj5KuocjzXP?=
 =?us-ascii?Q?sSX9GhAJKvFvePFB+5Z9AcdSDqiyevgvCbsC7OGxd8qDvkiK6mGzPc9XlMn7?=
 =?us-ascii?Q?6kGERIKZPjaKg6CEPXlpRcP8AnMx/Ics06BHOXk9Lomw4o/su4u5mhUgG51R?=
 =?us-ascii?Q?kBTBEfqvFjHbmSr/r3vtYqNWu0N1gHQX/6VPuI3nzUTibPmw/nBdfM3uHQjo?=
 =?us-ascii?Q?aXy/U4X2VMno6v73HSDu5pQ2S0RAvUd8wt70uNiVZKtGS9N6nPuvX+SCEknk?=
 =?us-ascii?Q?gVHp2vZBLRWzovQGqQQy2UYbJwXAnKkHG0TYwdj3fESNd/2KsYWJ9lUYT2dr?=
 =?us-ascii?Q?K3eNd11OGfVC+BWwu8F7nRbUsfEhe5Yf7dT+zqtMzj1chJzZH/2DFdtsBR4p?=
 =?us-ascii?Q?INmUI97bxpug+UTG38JvfyzjCkzZfTzyr1SxuYpsiu8OfsIu+ZdLSbMDxf2m?=
 =?us-ascii?Q?8KrxuXBsHcjycHyCT5JIV4cM5Z9x/mn3Sm6vcuxlmCPzHrkVGexyRO0hJPf9?=
 =?us-ascii?Q?YCpi8IvMLteRv6ebvr8IN5Iee0rnJnB4sl5MrMkRgxQEKFqYTrhvc4Xixlw/?=
 =?us-ascii?Q?0nKCOK2HOqCXbKJ5ArdTf3CdgNIwM0ecHLOalFwxZ2UwwGnz2zW8otQryBVf?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+TsLAtyrhzU1tcIC41A+XXvg0dn+jGjYgY+SAWWUJxxwJqBVxbSw98GpG8af1ociyBMML/lpsY5QZQPHVMEmWQunK+n+/aCLPqVeJQcf2KRBZMZOMtBNhUtcLmFS5mFl3LjJ9nHgz7Tlc8QpNEi32an+RZnCS6JH0P7xJ8HG+PG/hvaD2mBROSFZQeu4N+yMF0jAJJ13TPcBjbgPOxdpcnpGp1EY/gUrFWJu5p+TuGG+CxVz9nprwdCEscl3msampub/6T8UfYaG65Ks+Z/hPZi3nSMryVXNkSWr3czsYJV0LDlhundMGWvLe3AR/g/6KIF8W9KDtNT4AsStS/L5QKfYMegwEIzWHpA8FnPy1M8lxsRh1ZpGf54nBQNx0qexZyR7o/FIFSro9etkQt6JIsV7tVcWb42P8wg11Jmp6n0OlmgbMg6pKn1zcEDnzo+/DK2/lnMIENNXIhx+UTQMBI1Dz7PpwP8JMEuTwUTtqG0DsHolwWpul7I4uGs8G7C8Z7Zs06vM2FrsXzeioJj2vV0kiCnBAOr72ToaSw0TnZy3oFghmGP8TQZHTkF9GTKcAWDRvi1vvskH4BADyBr2BCM6tEK2LhbvzhqC9UsTbcM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a683923-e4e2-4cc1-7065-08dc55b087f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2024 20:39:46.4831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0WV7igvqUnbbrKimeD6qja4vvgxLYf3pBAK+L4hhYOhvyB8BcNUUP0MkVpG9KBuCPHFoTrW2YHVyNSedYdP857VfTfLzYJGCF2A4DOx67y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4365
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-05_25,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=942 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404050147
X-Proofpoint-GUID: 39J2ExAYgxLEkfyBpJqYXIh4wDcPH7Jv
X-Proofpoint-ORIG-GUID: 39J2ExAYgxLEkfyBpJqYXIh4wDcPH7Jv


Damien,

> The patch series introduces zone write plugging (ZWP) as the new
> mechanism to control the ordering of writes to zoned block devices.
> ZWP replaces zone write locking (ZWL) which is implemented only by
> mq-deadline today. ZWP also allows emulating zone append operations
> using regular writes for zoned devices that do not natively support
> this operation (e.g. SMR HDDs). This patch series removes the scsi
> disk driver and device mapper zone append emulation to use ZWP
> emulation.

Did another pass and this looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
