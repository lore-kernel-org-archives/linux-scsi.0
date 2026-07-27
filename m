Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6A41D111;
	Mon, 27 Jul 2026 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163433; cv=fail; b=qWT02Z3qj7tOodGtq43izv+U+5HT2cc9AWlWS7LcYNdrva7U6DCOinFI4SJyRlkdW/yPMNQ/8dxWlQGG5Iv3MVLFj/CHgMLiKCwNYp+ixkhX7GBVERA/mBRdZrEiTf6Lfqg+8HvjkFzA8zGv6K0akY8fiFpeSZCurkgjlqS5vN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163433; c=relaxed/simple;
	bh=PP26C7oiJUvstPoA1/1z4k5kF9LdULgck0MWyjiEglE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kxmd5YpCV6QVKmFWQKHy6h0Ty+cZlyx1uDA/erRFKCPFJ3/H3+TpdO7iu1UR1wLedCt/J7DmaPvHimd/TdhhrHNlOVPHFawu8VKuff9rlbGthzEazBCMXGDNEfReS7+AAME6aJ+9e0ixnLX+3Il7AsrqY5B7HgxGaypmfTsf1Hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jVnRMkBV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DL9OzAZx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jVnRMkBV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DL9OzAZx"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCUwXR2244818;
	Mon, 27 Jul 2026 14:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8QZzh6Ee3fMrM0q/bnHFnJmf6zYT3M8aOTi2CH/Ewww=; b=
	jVnRMkBVQYl3nyAyrQDJvMBZf6UluTwNsLOdG3qzNfXNFqO6UNeqPoMkSLZ9qLN+
	psztR3uDvoud5HuloTYyDiZIZCOUfD7qmiF78FBT/DChhKDBFqwM5ZQ/4hDUW4mq
	XPzHJvQQIPmpqcm7CrfVr12VhySmiNLFR1rZBXVJCoaIt3JDrA1JnvvjHcPNkL5v
	WCqpDVLVcmm+gSOFPYNO8qKnodHb9OXHqHKzm8kKaZgKHHu0LMn/7OxztcymPQu5
	v0JnFPxBpH9gL4UPSmSy1QES1d1lz6VxykkbLvECaHDlyf4mpO4Py3Tth3cfWBcO
	qJ+MRbsCsgnqkd0LAALFTw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3phxda-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeGQk034755;
	Mon, 27 Jul 2026 14:43:15 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh85s1uf-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E6kQVGKklGufDQ/8L0J9YIpfrYkLHWciP1XAWRuXnsxuGq1n0CwXABkoJibfJkSHTGwA+fCXkLP4pgnXz9Xznc9QRdITNzVREM2mtbd10ZspgvO4TwGtwYqHUqyW7bZT2Rrl/5f+1ThSOFAKsxyH4xsbjhX/G0lVO1dNMHCYIXpuoIUGS9qk29AUsiOnJGmrOpU2dLr4w2sRbAixnIe6TeVIDG4x/ZKJrJ8Z0Ur2QvUgd22ZEnt7Ac5u3u6CvctFSZWw4a/XkvKAgL+PCwN4xLO2gBnw1p430PYBxgsYdZjS9W/TSXAadLfEpZbTKoJ+p2wuhnpAKLQE0raUD6G0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QZzh6Ee3fMrM0q/bnHFnJmf6zYT3M8aOTi2CH/Ewww=;
 b=tM2aaY0A7EdZuaDfMXrVzXEYL4VRGN4LkQPzCSjMTrFn5ki/dORrQ8uvV3c0zGnRCgs3YlzGeZo05lJce4nAH8cc01xeegYxpD2uu4qbXOLH6gWgVVpuIK+OxQOJUO/O+eCs5y5FG9HTEVm7onMNOvUV/lstNhA6m19fVYgAjW7UbDKp/m7lTj5u4L/TMcVkkYw4dOAgoL2owTfbZO8zJUu1yn9OAs2Fu3r98kNIDfuLAHebyOhPrHm2O4lUijStS/ELH/VXrJYojgEl/qbr3dyi+i81lKcP2ri0aAR0h7PP7fIr0CDYVSsmog8DjPdwwq9IoFF6FsU5CWHarywnCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QZzh6Ee3fMrM0q/bnHFnJmf6zYT3M8aOTi2CH/Ewww=;
 b=DL9OzAZxUt1GRG4CPJ2JPLwjEORBGGQz19Mr3IKFVZMt6S/uwWtnqPNJHHFbynhyH/CEQDTMJJ7VO7EP2cVDyyHPGF24deEfnRzttU7/s2vF6fpxh1CBSeJ4TM7viTJNPdMAFf5QnZ6BfZYa6FFYGWhfTSkRmNnIMGPvSbOO0Go=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:10 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 10/27] libmultipath: Add mpath_bdev_get_unique_id()
Date: Mon, 27 Jul 2026 14:42:17 +0000
Message-ID: <20260727144234.3802948-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:610:e4::32) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b4ccdda-0170-4fbd-05e9-08deebed60e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/pwy1uszc4n+ljLy1pps/D8MqplpNSZi0T7/VhZxASM9e5FIMd/+Od0IeEFIX8CCAtcSKybsN/0pdTFOzy/pSH5nD6fT0xr2/vMM6lQl0Q7519IPg4wZSkxsE9yDMODDeRkT2rfD//VB6uaeoBwY9uLpOMc/yIJRjTq+GtwF/xqQN/c8jKOSdanmwQf83Em+8Z/pmsjnMarGYKsm+784BMPYXIhSCmovIzkEumzpVyj8pWEYQKJIcF/ztaYkJ3B7r0SQFkKyV6t/zfEmPFOJ2dC72/SzimxjYJ0Gc3Vf8O2wyWArIrtvwFwqV3RzbGtrXsNeq2Gm5bt9ucO3VqXJxt1fQQZu51fn2pXel5R8o7xEMGk6mBgfco7J94S+I8BVzA4D+6xM4WfDRpkJnZOhR4RgEfx2ZAnwiFc513MhyHNnmOxC0fX1wB/CDOYkhQSU0qyjzGODVmeaFh2xEDCn25g/uIXAl2RtApfEPdp8LgDd3sSTSFdLsNrEx8C53YYbWod5x1wSYaYcNx9FZ7gpEr9CZu8dH3g0w1XL5jDhCM3EIkeISnKEbS5l3ThSUXDJezmicEvd6103myZBygVkhXwMMRcTV1qeMB2DStO4EWNcB459lQ6xkmH0HgG0XMsdENfxhAmmqRdW8e2Zx7U+n9puNzrQjj0bnLHhWQoFEGc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qq9CwEj+PubJDO4RY6jb4QVb4zLpMjOLhbAmcIkDyMJ6dKGoojnhXTYpTgeR?=
 =?us-ascii?Q?J7DY6sxozQwRXYuBtsHkJfcxyuShInaHzE3QgcA2ibYHUjVVRzAJuxqWhie/?=
 =?us-ascii?Q?HzuxtYLz7CWhMmsE8aePExn5xQBnsXVIXjD0vSjfFyCzHcWjiHxZYb8+RruD?=
 =?us-ascii?Q?HKvsZFPpdTrLeU+BHi8kYNIE6tlx37cRkwC3xpiIt9sJ5V8aGMjvwpskJyKN?=
 =?us-ascii?Q?4b3OMRiuPuHPTLQyMqei8r0iCDn+Au0KIiwAvzAKCD831bsVMJNMKeHBMLba?=
 =?us-ascii?Q?v2CF1XchHaVeeQZydQgSQMz8lw/qie4HKADh8yL5ik0xvqxpQQF8v97RhOoy?=
 =?us-ascii?Q?6NojTMUwWTHisThcCQ3+5T+piNZrB2iUa3WJWXDc05PfEcDWUjywC5W9zmEO?=
 =?us-ascii?Q?UaOeo7ACKYZOdOibAolh4ch3LkXh+R0AzUjmxjldHN3bm/fJWugPh4i7o1XC?=
 =?us-ascii?Q?Skl5MdPHSPYEDKTw9YOYg658ereArtfhE5FiqaYUg0Rbb22Jx2bh4cmjqS2l?=
 =?us-ascii?Q?LdiDJmZbJarnZrNtIGpusm1nj3dztPLPm2ilJOGWkkLDcNdiwLMKdo//8Np8?=
 =?us-ascii?Q?BDpfT0btNFpir3ZfxOQf20iQBa+QF/EmlzEm7GcbPtU01qN76SDSRIhoZcU/?=
 =?us-ascii?Q?AeuIURrOGSeRqf3uhZCLEMyjOMF+JfP/FP56eOIBNmhyvyl/XeciUb/Jl2hZ?=
 =?us-ascii?Q?umGfFrgLaPlkmtJAwXcJKoDjOTWOT1/rGZujX+69NMJGuV7d7lvTX/ZejCvi?=
 =?us-ascii?Q?KF7wWNg7zbKPCd3FvVmL4aonBUluM3g8oaAyvF3aXPpPh9l90rTJBw5FQe9E?=
 =?us-ascii?Q?xDwbTgen8vgEtjPZ56HyujzYICywNtL2hY9gr6BCFkRo8eDuExrHNP7iPuSZ?=
 =?us-ascii?Q?ZQCEfIH3gH/bEKDGukHTEsAXjSAVxXRKsnW7J4I2YHFFcgDJayGBm42z7hAI?=
 =?us-ascii?Q?IAMIpQtxkzOUg2hOByisHrpg61upi+pze2tvfU9+faXvma3BQ/CdNuSX0ose?=
 =?us-ascii?Q?St6hw853Nn1UguQfdBYG6Q2BhgTikBkckNvSSpo1TZTnmvpp0cxMJVDNN73c?=
 =?us-ascii?Q?0NaBJFR+2x9dRL+r5xV4zbo12LCdN+36GtKR4NoNJyoiYNnE7y6jyOA9Xp4k?=
 =?us-ascii?Q?3lOISqHaPvOJjmbB0MCOfBS+2f6TcJvHwkOvTUtTNcPPNI+wS/IR+cXeQyb+?=
 =?us-ascii?Q?XnP5UkwsltCGlW87516drYkXLQHT7Jys7+FcePpqIQhK9TuHFoEgh8NRBZd+?=
 =?us-ascii?Q?crjWzaPafoDdxmx6qLe9DTjxj06iVxskLj2nRmgTMat8RoF/hDgJRcF1Absn?=
 =?us-ascii?Q?p6MyMFr4tARODpf54JnsJSTZDi8UC4yJ6yEQ13hJXogTBlR1plhqCYq0ehs4?=
 =?us-ascii?Q?dcjA/Bu0eB13sdAPk3K4ndSwvPVkWs/Mnr20owS/d1K4pK5Mfk7dril9+tQL?=
 =?us-ascii?Q?2RLtJ72soF2tdh8IlzGruQbsiPL8tcwIqhMa+Z3LByOITEyIaHgMHY/QF1zS?=
 =?us-ascii?Q?V1Jv3m3ovYorNz8YniLntoWqmPFofcm8vEYO5YRLV6pSdP2Q8CLzEtkM3Usx?=
 =?us-ascii?Q?4kBkScwktREp95CAllcHazB2VCHNSNTNLE+mifYNMDj864kWJkFesbX26nVm?=
 =?us-ascii?Q?Mj+FrkZdm3AWU6n+1LNxKSsQLTaaYfJrRqk0mVSGQxFuWKAS3F07DF23TohW?=
 =?us-ascii?Q?HmVWmynzEExEHqT4I+0THp/IGkPKe2ABly1T/wC67n2UwE+UAwqIIb5U8HVZ?=
 =?us-ascii?Q?BbrwajnOhNMM4OWS/Nm8KbSn3AnfHms=3D?=
X-Exchange-RoutingPolicyChecked:
	k/69CcCWOU/ZGjy1sZSqbbK5OfA2wIop9bx7pnGFQSFdEaHUXAi3NgeI9kF+5cFIW6WyYAEufhGrU9r07gdsB7DLJWC3Xhs25f7I5wq6z1buk9rBMnEq4ZvDai+p+466VB58Xvjp+ZVqVSztqB8djUYlKGPbGE9pi8MfAzQJb2hggEKpbS6zohfT53LtxJ7mOcgDEXF3TVsiXXT8U3LJgIfNO+0hGFbsC/WdKh+ucA0xovfWthTZS2FtXHETWAVMqAz6hDclZYH6nezLeSSLx0zeXKwcq4gLK8NQye4lKG3r/biSMrYPEUl4br/GIfh6sgO+WlN18ehLEF86DiBZfA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pLAWUHOghQ+DbsV1JEKZMKh01O/gmUUoGn6oc8lkiKsoV+SHi1FenQCZo/wX4jraOFeHBVv1ubsh5pDZh2U702qExYFcpO7ik2Aor7mTZ8nxj6PY9qpyRseQoVjcVtl5oWMKrKZ61udiFmTQj4C/aKpWAvMM2KbrkFRANsM8t/vtr3bsoxNTKm9/x0z/N6oMjaqN9ubch4OI+LchBGoutQ4F7oTR7sCEINm2u8PIKoOxqoHoDpm6IYtdPy2b7it7a02TKX3rAru7PP3ZIOu2HxZuYw9zooprqoY7n6leQaXyZo8B4z0FtyLMHZumh9+uDy2xqm0ikH9BJ4+MLnW9S56RR+8vOs2sOKVLYyrhcvibvJ5dFe9t86JrYgWjVS4JR0D4N9Z6Dr/l6g/xa/wDjnBW/lJHWYhWdlzvsJs20DsN6tIlxLhoj4hzhPky1xYLeSCSaDFz330uPe6vy2As0X8hGG2jydH71BBvGUzXiiA/PpSpcAKrs4ChMXL8q3F0A7TfYBvlTHMqCDpGSwVo67ghtATsBB5SxYMvTEZXOmsxTTPS4oHyOjhD7MjPe70MT2g4ERPwsEQvDZ/qf+H4AyJ37S0quM2PXD0qKSw3M+M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4ccdda-0170-4fbd-05e9-08deebed60e7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:10.0775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zs1lp1UtP0/sjEEdm2tP7zAMIlJ3b7cPRwq6l5qB0NIK5/ADO5VKUCO+Bk9LK85aGmFE67BW6hAKKshB7z+OuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-GUID: GANRXnkqWJdsFqmcaY7lPVEqWIVDsCS-
X-Proofpoint-ORIG-GUID: GANRXnkqWJdsFqmcaY7lPVEqWIVDsCS-
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a676e83 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=fcCod4qu5W597Y9LbqEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX+0ZjwKn1VITF
 kdgCLbDm0kn0EvLrRfjJnhYYLTt0jTBB3ORMCGghf0bStDo3OoadoyZR1TFQJ9gg8iI0GL4Qq5c
 TMChf/zv17fcfUaN78KFHhBM+TTAcy8Kg0SF77tN/YV6rKGjLz6VUdujoWEa6sXb0/dZOHcMsNf
 6qLiwcXb1DET0kIwRHnQ4bSVw2HRx62GpgKxOgxV1px/AZsaKWmqToZei0tuwDUQnUwALrrpk3J
 6BSTG52E4Dh1ab7nUFCgzV01ZIcB9tnCsvRjlAMwXZNjeP665wMUrvbTW+c4vEJ6PG9TwyzMeDZ
 dJpPujgkX+2DGmroV26W0O3c+XKJW4hFeEquIoeuWzdwDkfFFMEFkYnmkYkH6KYu4uhQ+mJ8YEO
 /iLKCh7lJCbTOTHXsW5wyAmRt8AkhkkWg9NWqVfsobTsSKE51JpOztoSO7G9FlJ46aR+GnpPf9M
 Hjv3FJJHCkd+KIWckCA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX2GtVB/kobRBr
 EBU6sovR00vPNsxEXsjKgeEEu4xlB/qA3I6/X7Lnzgo5FxVNj86/eGsjEW+k7Q3YP39men/snYE
 73dMPoT0VWaBKiwjM42/AYnZxuIaW5UYfpftCmzqxdiwGIO1lKZZ

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 76b844d42813e..ac3816ae6b0a1 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -454,6 +454,27 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->get_unique_id)
+			ret = mpath_device->disk->fops->get_unique_id(
+					mpath_device->disk, id, type);
+		else
+			ret = 0; /* referencing __dm_get_unique_id() */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -515,6 +536,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.7

