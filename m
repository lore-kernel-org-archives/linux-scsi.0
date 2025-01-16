Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376C015442C;
	Thu, 16 Jan 2025 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047052; cv=fail; b=nyoqMmoNA0scERa1a1J1E72/JKhkASdyWOrxElJg5ajoRG9y/8USdHaT8+lAMVBmsWnieyt3VeHGq9lK6qZK99eh7f3V5II+7qXfDMSmVrdjPe22R28yU2hz1jFRgJBvJ0WQQrLWvrWAnZpY71jNOLEIoj8iJvPbi88UMimNkKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047052; c=relaxed/simple;
	bh=1FgAzCEP0XrxY6Tny9ZeneF6mhrOIy1vc+XQ0Ol3+as=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VBMkCKIChHQPJNIDB8cc/U/cf3QjVYhnMe3TVvigufk7mDbdiu4Y0C41CKN0XhUf8TLHgydwDXldQE+b6J0B8cove+v6GNmg5i9VTi5ssY7Dpd+aVRDJhL+WZPxtTgxrznTjY2MgR5Eob4WroZrQglWRkGXr2zMdplhk/BuDSIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dwx4emOy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=piL6J2qn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dwx4emOy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="piL6J2qn"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0j6s012919;
	Thu, 16 Jan 2025 17:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DxjzV7fvvvrL/a7Lig5VeXZqa/WSR4USHvAx04Sf68w=; b=
	Dwx4emOy34mKRcxtPZYJeVKBaAMzIBserCzvwCE9Nj5Z6KrCUA3bEyGi89cfFojW
	nIcyVhPU947QPIGRY8g5NES/RgYKCIUKSK8FkTrdFK6einFv9lvqcz3wmkdqD3VW
	VwZPyNUnXAGg77lr7771tJw5H2GcUak0vsCRb69TcpMMR7pLDVfKr9SvOzyvg/h7
	EhSTmtCpJnZxSyimhr7gRGtVUNdpAywGHmbV+zRcMthM32AnPe5ZGzP3KSYvpazr
	b6Qd0p/RKi0QtSXn7aYlxerrcLRPV+3Nn8Lz+y4QHZlxJqONV1wiFxSYqonkUKfA
	EqbCz5LeWoswHpWnYV52qw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 446912ucqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GFVoM9020422;
	Thu, 16 Jan 2025 17:03:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f3hdeux-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qJH+VGBk1+PzXr+K/lFaO+aknFWhRVNxepMc/bB9nHWOW9kI5T4w9lJwRT3EOX0FZiE+BEAT3Na2sG0cv0Uq5KlwaTLrbd7GDrlNB8hNENeCTFbBHk986kCMutgGco6Htn7k50je4Jzhd2xij/PqDNaW/al/zbH/FMq7/HYgrQAOTTl9kkOU6kwqsIqtbpCr1DeKkHoWz+WHhozyxtqCzmsJfoWcBZZfjfZxGnTh1/cvSvVHQAolx2RAhZ3V3A5VerB57x2gOthPn+GBn5VSvzNe9zCq3u4x8bVRCXRF3K4o1l9cIOLEiJquLvFaZo2cKGGk43DZrmLmuOmD7hS+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxjzV7fvvvrL/a7Lig5VeXZqa/WSR4USHvAx04Sf68w=;
 b=R3N0ArirB/HTT92QUq/CfsL2qgcQIla4A3tT8FO7nfdKKJaA7717a1q3BZuUoNqNSY5b0Pc3RdsS9CN+Toxk6JVtxpi6PT7LN2XaH0vP5unrQF1JBbG8cFR63Y6NCgmaKoCmRe0o0xFT2lJvKtnZ9YXhfEwpMxciJd52ggqcvaIYB1c3sxMKQ1OEG0v2LQzeILhkUOQr7eYLHfKC1odnfy51OyOTrch5SNuE35AtDBeiok3gTFHypiU8L5HU2Nz5hDWAZPXHNZ1quzwnsQZtK3VvGwQKgEq2qslmVvlwdZNocrhZQFRFf5R5GPeXyt5mVtLluJ4r/AL+5+8So/iq4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxjzV7fvvvrL/a7Lig5VeXZqa/WSR4USHvAx04Sf68w=;
 b=piL6J2qn72ACXhhZC6DYoIQAFp166Mzweza47VJNdndrQPRYFmUOUMaPOvjk0v7Q9iThw4pyKSOhNY3BCm0vs8DIzijgutWu76NAeRwF80VUA4CBWtfy4jIzQ0E0g7z0KbjcMB3jdHMDcvO/zg1comCTMDUsY1bEmm+NajeFQDw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6235.namprd10.prod.outlook.com (2603:10b6:208:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 4/8] dm: Ensure cloned bio is same length for atomic write
Date: Thu, 16 Jan 2025 17:02:57 +0000
Message-Id: <20250116170301.474130-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0119.namprd05.prod.outlook.com
 (2603:10b6:a03:334::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 7135d3fe-e637-4975-41b7-08dd364fb740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E8XgZ6eaDuEtTYXbXBwRdkLDSHXVe9aFjPoGt1ZBywW5BF+WK97KLaE/b19K?=
 =?us-ascii?Q?dwc7lcUL3h/seyS3TxkGQOzozd4T3IN9nV4DM6PED1sOjSEV0aam8M95A8E4?=
 =?us-ascii?Q?v83QFyRGfpMHF+sN68eFWlQ9nUmFTjaZ5Vh0k8xv/vMp6nh6z/gX9ZH0h8zw?=
 =?us-ascii?Q?8KokJX0AMOIXJmz108SJouvWiH3yz3Y8GjTNiskGbPwdHsParKomKKmoc6eR?=
 =?us-ascii?Q?eVdUhg6CYYpcpnFYCi0/1lbGWfjjHmp5wLAkU9ZF1BLcZhxFLDIFhj0ngCvU?=
 =?us-ascii?Q?qn5hFYwOnjOYPXEZr6AXxvZIiC3aialSPD1CcL7d09NDlVjcXLZzFJn7Vs8d?=
 =?us-ascii?Q?Fa7zd2SjaUihz8DRgU2LLaKSmFwYuI1dFva9Xo84H/2VcQR6kzER/RWdNIfA?=
 =?us-ascii?Q?EL0F/eIfoYgro6xzsN6s6wcJzel1LtVWOJyb7gjE+i4kysyvhpK0d4t3+Wi8?=
 =?us-ascii?Q?/aggmo7v0SC5e+4ec0C993zArQnPDc6gYwh6d4ZzdG9V5mrgr5g07r3t/2GM?=
 =?us-ascii?Q?XRA1VgDNUIN7e3mnoZdC8g5xTux70857bG0+Y1/iiAkLYFWFnNDi9RNxLTYK?=
 =?us-ascii?Q?JrJI5fTK9llfQeP18pr2ijsP6Xd5TMpd8yhjdxRrVMX8ewNpCa5VKN/jkg2L?=
 =?us-ascii?Q?cqTFJlKkSMYxmUNdllBH8Pcq7ykPLSC6zD6kds4AIgI3h/ym9FvPnJ+nUM6M?=
 =?us-ascii?Q?g0GUEFkHFsgjt0DwIbM4vJk+5b2gpWDbX6LhH3998TRWGIlbYwQ/iLUl/5EO?=
 =?us-ascii?Q?sKPGWibHpGNPIels+pY9OlxEgIthJascJ83iZZBpF9hQy6DeB8Sjl6iIA1wr?=
 =?us-ascii?Q?AK7Fvs07RI0sKXRlQv7JfuFgeB2Jp58T94T03+x1l65nw7MdRzLbYoVpl74G?=
 =?us-ascii?Q?tUUM9iHmCVZNEGraxptp9XJl7XVeHfwh2YfzlneNkDrpHkVZgkHT4Ws6drwp?=
 =?us-ascii?Q?lPBrnIiNR7HPELYOrSMFF84m1xnqK44CbaNgN0eHX3y0NrLkt3y2RlgA2GHZ?=
 =?us-ascii?Q?i7uUd2bSbIIfUb+2IEKMZad2unbsGun1f78gJljpo5GsI3dZo6AusGWK+p7e?=
 =?us-ascii?Q?utTupx+0nSiCDn2pmQ7RX8/fd2nos0PWOXrx3z4d/+r/xlWInLHljfosbSLY?=
 =?us-ascii?Q?vL3cLP2v8TLTt2kZ5J1fhMysDrnEo7/ymzfDREltXmziW4hhELLErRW8pRnR?=
 =?us-ascii?Q?Qv5dM1Lukak3xrojS+hEq+o5hmeoBnxdNg4V/LCLAPk3/K8KmJYIBcKZFddN?=
 =?us-ascii?Q?rn4KWNLEytfZGjN9s2m6bNT7sRmnu2iObR9KafXitQwY7VjzH/2EXnHGISKN?=
 =?us-ascii?Q?XBz2ZQgovgPamU/ehjRW5a0BfejyvCBTDMXsQCsGr+Nc6J92KwRtDfP7b4we?=
 =?us-ascii?Q?udUybL1oYTSvyxfAWZWd/UsVuAGY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E/8GxGvuKGcNf1ncbvtjCv1J7zrRqnVmyIfyQQ7v6gbo2OxjpVO87iK5JYeK?=
 =?us-ascii?Q?mUE/6ALGBgfUG2dVBYkf4y5/sRKhglwPBV0cnRABV3xe+FJ335iCj6/lpFzL?=
 =?us-ascii?Q?ySXSwzqeWgWwbmEsXTGOZwF7WkeFaXZybhd5LJwqjBsyTWbSoCgh7DwHTg72?=
 =?us-ascii?Q?HY9YdTf4VUBK6rrrHScuuVWeqDsdzIgf1wC/uh+FghJrNtvWvFDz3bEudbjy?=
 =?us-ascii?Q?q7ICUddyLuu1E57ctR8Tv2pyqzxd2dlSeuz4UNZetRSZtIfDQcMIpukAAABa?=
 =?us-ascii?Q?LwQdY9MlvbHA6RYvv4VXeC06zPA1lhBxXch6VmInGK7eLZFMhhPV3xq4Uojv?=
 =?us-ascii?Q?RuL9QAp1HNiADipGBZHnf276w9JLWPKbsH9prlRP2V6ROXUDvBmHyB3FTBph?=
 =?us-ascii?Q?aLKXEuj7dN9iz6LfGqSi6MOXr3i+ZLZ7LL4jppQ/UUxG8pl8R81lrM8cedGw?=
 =?us-ascii?Q?TcOvs2VkmtYXJ7r7W19ixW9eh79FJJanLQXCLVBj2xI2O1bhRwpKIhP2J50f?=
 =?us-ascii?Q?U67RHwjp8K+XCNrI6GWScYbgohm7eNwu6HVn+z9adFJd4NgLM+BQDgVn452x?=
 =?us-ascii?Q?JAq0I6Q8NRfywV3q+YpnYogVQcovU6RSeGLA3CSBc1kHPSDY4MSO5Tcyk2bY?=
 =?us-ascii?Q?tk22GG24lCSi6P8kbK7dlq92nNkv5EYs6wf4kFEWN49BZiQKqOwv6ZHdvk2a?=
 =?us-ascii?Q?9n384sWBwdnbTrq/kN9b8DRJJD/xwQipGFCrohlFlSQ9pnHbGC0QiZNxpSbn?=
 =?us-ascii?Q?A61E7BCMLBYkeOPpD6CCT/hFTBNxBwWPzUvgumGB/w+/QRwr0jcPm9nNOC5u?=
 =?us-ascii?Q?H2b3aGGFZzmVqeAD3WOE0hUZYuPm7in8AkzS3u4T0cov/U1tVI/MjpYdlMMJ?=
 =?us-ascii?Q?b/ORn/HXFujcbF97IsgMgkTudxmdU1HLHoCmOd9OA7UY5Jdw+yxC/dPaMAZ9?=
 =?us-ascii?Q?K4SEk+p0Iz2coUc8iajRtjpQd8YqabTxIImYgfxL7dOAAWHNVN2vv8qCVkgG?=
 =?us-ascii?Q?hBtN2lPIbi6Yu17d7vzpIt8Nt57y0wXEhMjrEJR+YrlyzqtKvH0ufP7O07tP?=
 =?us-ascii?Q?EpvU6T3XhEUZoSUZsJhPMmrchhlqMyPf8eABgNFLYCyy8M3a91lrc99e/ja2?=
 =?us-ascii?Q?gkCIGqYb3fwhot9M3rIp9cI4ZR5oUxfOJS4AvI7Y8XYI5HKzCd0yPBtKgGBp?=
 =?us-ascii?Q?GIrLg2u3QJGJKVQxqwac/H2IDxEsDG2kZCJOOqDf+bkf1MfSZroSUbsbEUqD?=
 =?us-ascii?Q?cdOQYs03NiieeCfgH+0lAbyN3FQhfXHkhupf9S5Sr3cPOEVNpTBAirSemSwb?=
 =?us-ascii?Q?GzXY1VgqI1O4xzbm4u3mgAAHlWBl+q/cAa7iQ+AeCuy8N/KZp7SP+J5FqyRf?=
 =?us-ascii?Q?EtIX2kNM7rzNw5KG5ZVEChC7ECecvKAjIsn9s39gajO2OOMqyEALMeMMqvdK?=
 =?us-ascii?Q?ODqEVUx9i1LvfsRi9DvIlQ3M8GWEHCukOJLJgZ802k/F3xfqe2ZlBLLEhh3H?=
 =?us-ascii?Q?tvHVEFRyIf4OHWXh2fo59I/JUOnEfDW3AACgAwMRDBz/PQsXzNjKGtYW0BTT?=
 =?us-ascii?Q?OoQpJNr9YYMii1PCAD2ZqpK+V+vKfKdiCLt4yt7PlCNUm1mecFus9nD31qid?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DNCtwcblGkkROJ9g5kIFL0j7+aMDS6jalGFxrckdjU762ARUGXfSfAN3lJekcVb9r47nc0eYaiivtdJuAYrJoL4qPg3RTli0NVnWjIWLJT9lhfbUVvxn6xp/21quJIag05+/q6aBcPczGH+Y07sSK8FIPcha6ylORDZkQF7PVslWa6ohPYjeeMSIiuwHg1HgFsMHxMnd3fZ75rhnmujerf9lRNHKFPHAeYKT1ImjtENA1EBG1kwol+AA7EDATYedIHSXTWI4Oyg0dQJKxJI75CawBRwFdMvZtsE96T/Q3H4apVar1UJFL/EmeNC2zrFBIOnY083M2LrsWsnjJbGbLTkc8SgiFmBp8G6BMREVv6l8Dp1132nIPQ86tcyCN0KI4Jy6GM4Ydec4XVnEWmeN1RpVcCFSMi4kbOpQLnzSjmK5eyHquyR7tsaVzdjdfld/BTdywDNwRVQktrfUiKOXK6QcFMTJUB0FSZrogyFlKHFLPLn95HmRtZYK+svXIqITxZDB0qJ7qGGQzXfppJKkqqJA3reUMRNF5eACZ53x3ioa5vc14y0mhd9/5pObM7WlvInrftpYRCNxpzHvWzmjSoV2rxLpEbN6/Jc05ZqlZao=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7135d3fe-e637-4975-41b7-08dd364fb740
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:36.2485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HxboHjyanZigbwoeAEc+eIN8RaMFA6yfkMyZ8ME5k9ZudAsUaCnwJHV10JD/vPz4LyN2zejXhkcobpcv9t3C0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-ORIG-GUID: l6okdEzKriNxqvURF1F-2vP1ZEGv3GoM
X-Proofpoint-GUID: l6okdEzKriNxqvURF1F-2vP1ZEGv3GoM

For an atomic write, a cloned bio must be same length as the original bio,
i.e. no splitting.

Error in case it is not.

Per-dm device queue limits should be setup to ensure that this does not
happen, but error this case as an insurance policy.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 12ecf07a3841..e26c73fb365a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1746,6 +1746,9 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	ci->submit_as_polled = !!(ci->bio->bi_opf & REQ_POLLED);
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
+	if (ci->bio->bi_opf & REQ_ATOMIC && len != ci->sector_count)
+		return BLK_STS_IOERR;
+
 	setup_split_accounting(ci, len);
 
 	if (unlikely(ci->bio->bi_opf & REQ_NOWAIT)) {
-- 
2.31.1

