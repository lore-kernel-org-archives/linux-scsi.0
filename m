Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D32186E3D;
	Tue,  3 Sep 2024 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725376248; cv=fail; b=IQtv+4lg6gDzhlVEo5OGRxLWtxYZNVgtb9dIF5SdEKRwvL5+l2t0ND5J9dxu3MxTBJ6URhqep8RUR5XZkwrvaMwX3bGaXCF0na8V229wBQ5VmpqjHESWanGowmKX5MQHMKaYZBz3lahoBUwE7pQonhaKSUlxZmO/QQyS8r+2PtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725376248; c=relaxed/simple;
	bh=11tgHcwd2vlspSsp3A1sW/deLKLzXwogOARn1ZZUDnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oWib9XpgIrcW4opGWMXMh42NenfITgZVIHRZsDBxE2fVVmrtjvuuOHnwXrlcAavmncmZicncXMAHjzB2rhTlNPp+GnmVrz1xqE4mXVEhBakYncD+gbc7jlSyw2+DY7JKuGWvgI3GFPUb0FqBJCJFMMwtJAGVk5FOZUva4HqwR04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F1lTjpO0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xpolX4xM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F1lTjpO0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xpolX4xM"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483EjAWB019498;
	Tue, 3 Sep 2024 15:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=/LVI0aImon/7Vc91T9r94DrdXJ2ycY8pPHSq4G7OYzc=; b=
	F1lTjpO0GWGYi0puPzifKyTGBgJs+wmN4/9iySR9IdZ1yaJC3rRI2as99jfqFmcx
	Ol4AwRLSnAfd/MyYuOCxIBv1VaaCs2uEm6B/NSadtPjxgtnOFqTDPbZAFhg+ZgME
	xTAaMXU7lFtPrAvz1+Mb4O2H3LNSu8GdoBqb12UIOff6fLjpo4gRzVDCm0MxroWm
	3trzplwOt6pkFfi1gIBeWbWS2QBWGzyEpUDxJml/cBm/bRq14bilRMrsaWyYb4xo
	6mYC1iDQxUYZflIpUDr8skpPASGzURsUS6VUc9c3PNB/EqE6fOcAZG0r163rLx9h
	69wzVs5/uKmbEGp3ktBhvg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41dvsa95wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 483Esjls032636;
	Tue, 3 Sep 2024 15:08:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41bsm9151j-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a0VqXP1oegKz0N+ut7IIguJd1WrOK9UBmTW8Dxfn7xUWwj0oLsTWVNe8d+BLpH/gpVZhuFZxwfg8hsUKYZ4i3PpOiGseApp/xXHLCVkWLL/pAhFx9Uzk/lNiApJsBEsSCamxk+zbfWdxKbKvt4oSaP776l9bd5l+7WtWe5AjIdW+6sd0ZbZmPtW4vi/uIJDV09JJms1SS3paD1dCZswqk6ucGTDzaII8GdPyY5k3RxombC5frQKxMW7TkhFeaSxgsQ5b7J2niGTOYz0Fg5+YyvRCPZ9/xJXpSQQCCoUtHxAAey1m5pJ+Qt9YXX4FKjFB6LBHYMCVqXl3WzZhnXEcbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/LVI0aImon/7Vc91T9r94DrdXJ2ycY8pPHSq4G7OYzc=;
 b=omJesIFbugdm9bkiOSd1hPTv9ye9Z4VI7m7YN+Ov3633wuh2aGjwFJJquzMKUj5oKsK2MSOjHwDeTrwZNAyb/8zeaqjjU7xiC9zxlLbKWR32eO4LYBrXfaM/ICUJThm4GxXwSvknYhZ3cxLK5UIlIKrdafP8AvijCpIVYUMGZ118rG/r+VkxoK+I71nw+G5Nvbnj5wllc/tlTtdTcFeoK6SucGy6zrdFnpiet+XdX7yVdNcsyGLi9Hd7d8UVF+gA2Su2E1kHt4yfXLiKu7PbgPycWvsiiEC+vZtd/4tt2JNzzBCsGnefNS6F7XA2ftFU1V0tZjVg+RA2h5REaycFuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LVI0aImon/7Vc91T9r94DrdXJ2ycY8pPHSq4G7OYzc=;
 b=xpolX4xMjlvuWS7h5ohjgtQJ41gpJOMkpJFz286VnRk4dwvbzdBkJpGNP5J8M50dpwvO3P615U9AYucc2QSAPeIOUzVXevuvRBnriH4YnTqp9wS6vBbHV2fwg+eVEBlQhq851Cfcl8I6K04wVk4ICjSoF5Zyj1bKa3tNxqsb3iA=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 15:08:20 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.7918.012; Tue, 3 Sep 2024
 15:08:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 3/4] block: Support atomic writes limits for stacked devices
Date: Tue,  3 Sep 2024 15:07:47 +0000
Message-Id: <20240903150748.2179966-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240903150748.2179966-1-john.g.garry@oracle.com>
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0041.namprd07.prod.outlook.com
 (2603:10b6:a03:60::18) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: f74425ae-e542-419a-db15-08dccc2a3ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8UFYnnL9WoP6k/4XgN5b117vizrpy+KlYoOOJq3gTKlcX79mfj17bU3wSzxL?=
 =?us-ascii?Q?X5ZRGjBaXhR2Muz3kMmgHJJZ+X98eQCw3hs11vmDG5UdpmGivkoIiMsOhQOr?=
 =?us-ascii?Q?HUxFSAdXEpAG6Lz/W+A44eM1JBv/70KOryiRM6dl0p4v/6MKNPoVz8CO5Bv8?=
 =?us-ascii?Q?zyljtkknAtnnpilGBrmzfi2Zi1eqU71LxrUbzn8Xse1Pve4Cgt0Sl36C4wy+?=
 =?us-ascii?Q?YoxCaUZJHPlCogL4/I1LaNtASLKXWVDqwtP/HoDfXX7ZJullWQ0bnOdRJ0p+?=
 =?us-ascii?Q?NtBZLrTfJ48ikI03Hxqwa20WYXwPxzBcd4xdlcxLSBOIieKiJz/FmWwlmS77?=
 =?us-ascii?Q?Fr66P6a609TLljIlk7lBez4mTtcSrpNknYBznmvBEhTxZW3Im3BxecQWIXts?=
 =?us-ascii?Q?gDLrAPo8ZvaPwvmCgUeYdXuXBBRx9963I8YIOjRt2Cp8PxIpQBGexqtz4TOu?=
 =?us-ascii?Q?gSZaRU6zuUG3vbrLI6Texktp90e+HcU+VU7fb255M7dvSo52aT9OdWAP2LdO?=
 =?us-ascii?Q?JnEd/AdCuPp4izywN/uNWjBJEvMbDPMHBlX2pYZk44tZqloaOB7dYTfpRAum?=
 =?us-ascii?Q?SmYSagoQPTYvs1x/apqN9+ck/nDMhL2LzNgxJRJvsux5qdlDihbq03eCp9Pb?=
 =?us-ascii?Q?pMnSNEZ70hdECU3WXRhNRl07+cCh3fwe9zRiEc6Wb6LzfpkSqg9c5AqYfOAK?=
 =?us-ascii?Q?3mAmzOY4wYCYA8BkPd9imTw3yRMA9S4nX70ptj4vADzWUQE3z0/ggUBf17qi?=
 =?us-ascii?Q?GsEwv+NjIoVAhU945pgLQWRPPiTWFHPJo7t+D9miYMrvJ15XzELlDLE0x2HV?=
 =?us-ascii?Q?qB6vrz8Y5Evl2RzfD4f9nJKZnmi34ie4ZUZkitO4ioWAYwzSYcz62w4oTrKL?=
 =?us-ascii?Q?AM7l16kakJwHqkyr4Hwc3JD3+c9gVx+NUpdBBLMWFEGm+8oDBNy0l8lFXVlK?=
 =?us-ascii?Q?1JfOuWUpP0RDMdPBotoJXE3oyTWHsc2KpwODhxZ+e7gremFioNEFIM1bkMh7?=
 =?us-ascii?Q?j5wNl0f8B6LwLCgbBXsdzphUqd83r2CvINguENp9er0l+ecgzSfKBwxoFooO?=
 =?us-ascii?Q?Azd9fqU/3NGzdaubmV6FM6s9o50j5bi2m6Ro/qqUP0ZjZheA2scd2iBXq28O?=
 =?us-ascii?Q?JwjTESqStvOvfvFlW5IIcSjWAa4b7icZVzBQBk47gTqcvAHsPHm+RXFuotBp?=
 =?us-ascii?Q?qxx4piO+5sbka60bYBcJ0tt1h5P5eW6gVgseu+UPKgFG0GHTizUX2Ok9H2vp?=
 =?us-ascii?Q?HwoR8Y4INpxHNc6QzL8vJIE6pzlleRbiQj7PTVuhxzNUFN3GZ/7xbUIFd/Fy?=
 =?us-ascii?Q?ITL7DS+J4hLdK1nRT+DITu5Gc7DIHXvF+bDjch6p3uRDkQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xas9A3mMikl4H8DSfFePhIDu9v870wcKmAYjpkfkTHs+rUwbVPjGDqg+XBTN?=
 =?us-ascii?Q?LcQ3Bh6BEPGkp/NDnXV7zJ0/nm2+cF36raFLhjmaYQntrs7I7iOuNpotMDgf?=
 =?us-ascii?Q?I6m6VUmGr2dKB0btyaPBiWVwYfV+0JoDZY8qttHRwuz0hEiqS8mjNc1XBI4t?=
 =?us-ascii?Q?j3vjUvVZ/8Sj5vONJ75KKNF8EmvrAr8eLbCp2I4SXspmAJiHSw0WVn+yUBbG?=
 =?us-ascii?Q?QkN7pDSc3ZDmhVHZRu33pQjfbEfz1Fl8AEaPibICxDjWdBkCxOOVEvW9pjj5?=
 =?us-ascii?Q?bokFmmROjvlr5VwF5uPG6lxDaVmZSflfW48zAMEyJ0SCq85xLKBC3G21TBmM?=
 =?us-ascii?Q?MMRaCe0Br4ldG/xjdoDLo3r5PVfGHCOzETdyfTrxNOLxV+x6sQGE9irGc7t5?=
 =?us-ascii?Q?bXCIQvQ/7F8gr0a5DKdZDzrZGDtyA9ozaCjjdYZDpxK1SbB6QMJux8wucM+E?=
 =?us-ascii?Q?aa1E4imPjtvy411C1T7QK/7LeKdvgCZloZz7oxsOVuhq5X313ynhPgQDlbi1?=
 =?us-ascii?Q?u7OmB12snYhbE9T6b3+h+RHIy2wH4AvNokyEqi1rrbLzdV37SCiBS+Vx6JYn?=
 =?us-ascii?Q?brD0zvIN2xsJBRidEaP23+uPZeX5jlL1Q09iBruYdc1Md+LDlANgbyNBNTrm?=
 =?us-ascii?Q?orux+x9Py/FzYg3r596bjEwcIeSEkRlQ+i1PE6T1N/+VwDT4xsU8yHJbeEfb?=
 =?us-ascii?Q?ofK8jfg+zBlev+ExWwK0rcvjQJH/rXWmgZYaW+d2XFa9gIZF+cLewWglv/An?=
 =?us-ascii?Q?pXhWSJom5gkpG+bfs3xStzOAbjxfnIU/4Ae9So+fJYgo9vWVLgNH22Yvny0h?=
 =?us-ascii?Q?OXnSZl0LQ0EDGBFn2rZGdblCsHHiCr+V03nkHt2U+Jr846m6cx8LJl2yii58?=
 =?us-ascii?Q?FCLERHSpYSxoj9IwoobbZ3Cd9VJ8GFC4DuS5acawx1bm+b80p4rqF2KwKckf?=
 =?us-ascii?Q?03cgzfeNtPXlTr7rvaqF5gvFv71US0nhH6Ra67UWKeUqK0NK/AiQjubVFOVI?=
 =?us-ascii?Q?TKfiv4o3EXiU9UQK75litqnn64Vw736ERWd8rYavFIxGllltQXsKTFOki3I5?=
 =?us-ascii?Q?yD+jdzOHdlOQH/4ovNGxjIwvBL9cP/U0xlm91hc5bQV/GyVLfjU26En0hM4E?=
 =?us-ascii?Q?bueOgFVIJK1WwRXxodp9UswCTo2QZEWvjP5CTIFA8/dW51GA3rz5Wx1pRunE?=
 =?us-ascii?Q?E7OrJ9YChLHU/XTHxj87Zpw+CclHwdJ2kksopHSCTawpl+ZQv8frlxNZ+iG6?=
 =?us-ascii?Q?zl5Iwgn9mMht6+xh5Od60zH8pKPxngfX2R2I9dyWTPA+MXK8THhaR6CX4RG+?=
 =?us-ascii?Q?xc2rjmMlK2DOYkdiIagQgYDgV0b7w39QQ5BNv2xHUGmlgxo9pXnrIxAUy7ah?=
 =?us-ascii?Q?Glp1wFomufN7jUFG58HkkgKe/VLskk7fIz4/kHuMTbqkTYDJIaf9mOnuiuRC?=
 =?us-ascii?Q?zniX7Q3g2UiG4/6rBwUV5RJjHRJ+J1soZHeO823KNH5IoqnvMjRQbmQXvzFZ?=
 =?us-ascii?Q?yvzQwxnLqvwV9YhodBVGxwRh1e17vLXsDFL1LFKGqV9eVN6Ildu6CnkqtM0S?=
 =?us-ascii?Q?bwzTLTPPOSBfRTj+lIRvQQn6ltMzBfGx3SBn09qZFAOPYCyF6f/MxdGkFZXe?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k9MrlXidbbFZw3j6TmdKUM8uUvsUyLenmzC09qQS2wn55w0LaTix3OfYvT+ZvwQwWVCeEBrtr2sYTFwbfCtckelHoymqvpTadlmXUhI1B4TtvuvbUta/fafCd/G6ufJpIxAP9PEJ2UQk+sE49kV68LGZpbAEJbscag9lDkcFy7rhyj30R4SzvVquaXQJZhPzhHdrp8f91CoK+q35J9jK3hfUrSqsCW6xWeTjR6vMJBjGlmCpfyHcEhp0JNwPxLZ4xAeFGo/K6hIB/lb2wNAlKRWvFvkvDXIxT57E05+H6uKokfz5d5/EzzBuOj0beFZz6xV/aoTslFHbK44d4R8nikn0FCuid+JhEWY8o0IBbOeZElz+T3taYv2gO/9U2KGsLkC8+hfAfsj/KVztvOBDZzoE01KS86xAkmUKN4rf1LJodpBGPWkAnSrhssWsOsiwAENQbWdZSFYc5sLwFXW1fKlDNLdrfVo/LVzPzZKvpqlMl6sDNabMulIIHL6Ru6Vy2If9kHWa75p/ec39MQdEIXb2WIlcot1+MUXi70Z6i2fPho2prOPRZGxDAfNB3qLrZSLptRDtRnfj5BkTRppsx1/bdgAVh0b/LU+bdG4Aj+E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f74425ae-e542-419a-db15-08dccc2a3ee9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 15:08:19.7447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRngSbvGmMtlyUNmpYmameulWTd7L2MV516ZTTdDTfobunVDf8QVq0EdGM6WdwzRGeYNcVkYyZtRLG+8xnZ/eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_02,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2409030123
X-Proofpoint-ORIG-GUID: 4XdEdjXOtHF4mzndPd_i1fLKFeFpP2G-
X-Proofpoint-GUID: 4XdEdjXOtHF4mzndPd_i1fLKFeFpP2G-

Allow stacked devices to support atomic writes by aggregating the minimum
capacility of all bottom devices.

If a bottom device does not support atomic writes, then
BLK_FEAT_ATOMIC_WRITES should be cleared for that device, and the top
device then will also not support atomic writes.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 036e67f73116..aeb05fb24801 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -682,6 +682,25 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->zone_write_granularity = 0;
 		t->max_zone_append_sectors = 0;
 	}
+	if (!(b->features & BLK_FEAT_ATOMIC_WRITES)) {
+		t->atomic_write_hw_max = 0;
+		t->atomic_write_hw_unit_max = 0;
+		t->atomic_write_hw_unit_min = 0;
+		t->atomic_write_hw_boundary = 0;
+		t->features &= ~BLK_FEAT_ATOMIC_WRITES;
+	} else if (t->features & BLK_FEAT_ATOMIC_WRITES) {
+		t->atomic_write_hw_max = min_not_zero(t->atomic_write_hw_max,
+						b->atomic_write_hw_max);
+		t->atomic_write_boundary_sectors =
+					min_not_zero(t->atomic_write_boundary_sectors,
+						b->atomic_write_boundary_sectors);
+		t->atomic_write_hw_unit_min = max(t->atomic_write_hw_unit_min,
+						b->atomic_write_hw_unit_min);
+		t->atomic_write_hw_unit_max =
+					min_not_zero(t->atomic_write_hw_unit_max,
+						b->atomic_write_hw_unit_max);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
-- 
2.31.1

