Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A615698D;
	Mon,  5 Aug 2024 11:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722857630; cv=fail; b=cQhj/3PIr7jxx32CHuCbHit1AFMOeSv8X1a8zyNTz/O5rVbjDnrGJQ2z1Qkuh2V7gLk54fdsUPclzI3mUf4trvMBfD/2wWPE4fFftzoIHka9Tj46bgZ5ukuvzW4Sp/yoxW89n2BGi+w8BShpSaMu7KDjNplbTGdbZb8InVdFF0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722857630; c=relaxed/simple;
	bh=ProXs+x/EmoBoSYV9+91rLQFSUBchAfPU37S6gCXHBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NlsbdQR/+DFFsd+NKwh6be9+slLGiryTzztN1c7UHOo0+dom5/0ANFpLepxZRH/W4Knboz4VYRaESdktJr77j3aCVie9oJZJC17WGUonFChi2wovN+bxvYP1Dwj4T4+QCAKkHrJqmGJGqbQ6U2obAUSC6dqbCmhnw5p92MSytlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iG9TT4SK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LhyTZQID; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iG9TT4SK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LhyTZQID"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4758fYB2026939;
	Mon, 5 Aug 2024 11:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=L3ewAtTPzXvT+RhfPxFOjTloynAmwHF5OoqsWyKSikw=; b=
	iG9TT4SKV32El7iAS8rez9hDRR7eFfraOr/FW3LUCvO7zAvvuUrAVgauoklN0tTz
	4rvZTsmWxLPU/UfTdLh3uwv6D3dnBJxSnx9jnH+DzWrkmoROqxvLjF8ASipFJYIY
	XDgyOmVio1rIbJRDH9BQuvj938+xw4m+XGGjx6ROnEge8CcjvEgWwZhmN8lnd6GD
	uCGcXQLx4kZQ/Jjs44+CXN4qIwlTfwXfPcEX59QLMYECyRhv+mxgJhsItUqlhVgv
	yGW5jEBgMEml4XJNCp++Td8mQmqG4nKZTen7muCrdbuj/PcH/7jX+Z8mCC+JOnfh
	5/KUf3jWqPb0ilItZj6JZQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sb51aee8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 11:33:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4759vHoo027322;
	Mon, 5 Aug 2024 11:33:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb0ddch8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 11:33:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bnY70qDvk2GZb9YF2rHPrAFT/Is2G2v2ZMP+U8jeEej7Q5mcuD9Gf/BXhx4hW3nFQ97hYaQEIF8PT6sOSeKKaBOzyS5DhazR4hjGK4netVDBSJjRX2dxrA/K/lzNiSvAZ3WQNrIlDlTtKvb3tBt98tKxVIgksJH2fcC3ga5hZV3CQQqQ9B8uPslgie2DHkDWcw4HUyI0hqt0qkn6YDXlayDiuWM0aQsUN7lC1c77Qnie6XLiKBQhh9jSxucVpT+9Wr8Plc1cCFNvKM5frznyc7lyEeZ70xQkXdEeNah8Y9F3qz5yHbaP/P0Brb68eDaw8+vP4ZfvGU5acoGN9CQ82w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3ewAtTPzXvT+RhfPxFOjTloynAmwHF5OoqsWyKSikw=;
 b=GGVjsvBknI4dLZQsIptMA2zPbTChNb8ESvIimfjCAwjFgmJ82AFuGvYE8v97l0q7wezhQD3wGs37ztHyMzVhRw5kH8wc1KaAA2bORS0VNZWlqD7RRzJzLXz1lhTzckOYn3+CjnAezE1ynTcSPwAm8y4yrq8SbUd/UbOHz74SBBPzlgmnZi3b3U2Gek19toP6vjn28Fnnj2TwWgq4ZNx7Q42ynTRA1IZD8k149yhMdZ+oUD0dCKbAua6/yaT+osvfShuu6trk9KW5vAjdhgoZZ3IXxLyoSW9SQ/oFH7DUTwS2bSxc9/+4+pDKLivuuwQN87SGlNm0/lUIVWXSPM1gIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3ewAtTPzXvT+RhfPxFOjTloynAmwHF5OoqsWyKSikw=;
 b=LhyTZQIDBvGINjj+BRfxf2c0UGIKMfuOXQTWJB4lr1KrJX7WGk+OsARepBiD2Nh4LuJH/aH7l1BSCGHOTWpWFtHrk3W6J9O+pEuz4Ld9pBEgBMSa7//TUvajlP4MOkktg9i70+R6jOY/V+59u+lvYajZI277+mjyNpjqcMoPYTI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Mon, 5 Aug
 2024 11:33:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 11:33:42 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] block: Don't check REQ_ATOMIC for reads
Date: Mon,  5 Aug 2024 11:33:15 +0000
Message-Id: <20240805113315.1048591-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240805113315.1048591-1-john.g.garry@oracle.com>
References: <20240805113315.1048591-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0089.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: ff79ae1e-a045-4191-8bf4-08dcb5427552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MXDKhzP3JJwIWS0Sn0PP9tvaobsEXriE+0LUyrLC00c43j5mWdrobXzYjaqv?=
 =?us-ascii?Q?xE2VtI47TzVipNN4mCvlp7PDXAIa1K/2MMhDAlkH+px52chjUQEFoegX+vbD?=
 =?us-ascii?Q?NUFjMH5UuNYMoJ5VDrQqodVmZlnDTwXv2b1VmzNg2PV0XllXoC/6a8RmVP2W?=
 =?us-ascii?Q?SDrF9X8MtQkOYURAchOD5NcVih0lDbxBuvuizIZkkC+6mkY4CZ27Y1si9RVi?=
 =?us-ascii?Q?SPj7dIpD1OtdOMeOjRdkFfpFhpoidRVTIrpY0iQcitAjE9qRAA36HqBDuOx8?=
 =?us-ascii?Q?9oMC94L1OrgxIuiU8KYuwc5K9UGE5gpayyvTvQ0OAA7MUfg0cMgdZIPuptQ7?=
 =?us-ascii?Q?ZNY2qgbRkOmlROSybvHSEZIoqZoK0xwrXJ3nO/A+m8WMfVVMij1gKm8FuxF9?=
 =?us-ascii?Q?9mYi3uT0uod+selJsrfDR/QrDBXqF+RwCEJh57x51Y/F+ymH3xMd3+/UC+5w?=
 =?us-ascii?Q?549vxHgNdwAiXEXUrOnUuAKn6TUnWIZIv9DQzoENMp2IXw8Rg3uz0JORMsqZ?=
 =?us-ascii?Q?sGrpIqmazRO33Y3u6BcxIXIEveuC7YqpstZvMzGXxfY5wXi2c03UY4Ovi01Z?=
 =?us-ascii?Q?5ti2zzErH3xml2iI2LacgastGReEaOhQ4pILt9ERTnRGq/2dcsPMiwiyUxdg?=
 =?us-ascii?Q?1SvMBGAAb2vpb8/C3+b7+4KjXZe8ETyUjVl2HhreirEcIiRAIbVI74U2k+Vv?=
 =?us-ascii?Q?hMPe1mQS9czrnLLlCut0lMY/+IR3ao77ojSzqAcZ1916pD8hssDmDyVUfVRJ?=
 =?us-ascii?Q?AO+FYy9dnZqOPJ/Hf3CQXUIBKdfMmFw+wALg3bZBgrPcJSa0gVD7YZ4wsD+r?=
 =?us-ascii?Q?A+4JWx4d9BWm5UCXLGFQYFKE1vn+gyuBspx5yos332Ft+qNRYapMztJ5SmsU?=
 =?us-ascii?Q?fbaRyZvfXQG+OcCLUUWZ9kqWnU03mSv1Gh+ABHICjP9DDGEiQeh0HOWijRsm?=
 =?us-ascii?Q?/jbQoEGh3KWzifSrneT+shtO3J+JHdihMmUBFwxIyXJS+BmBRNkxitzDwUmu?=
 =?us-ascii?Q?WuRByreH8tIc0T7NpZldaSpgpUtczz+beoAb1z6xDhK/0ZQuX1Mp4HnZ7YVg?=
 =?us-ascii?Q?Ji7Z30kP+e8b3eTo9zPcWMpO6hVFYWWftAruIvuQbon5d1MPDIKSbJWzICuP?=
 =?us-ascii?Q?WdrZRKXZlLTgZ0KxDfd/2+A0aicJxu9oLpd00n/nvQMnSQ/qpa0m8w+Os93j?=
 =?us-ascii?Q?/SrBb6ogDL6rjSQL5ZI96E17Jk/pmPW04lcq0HIUbADFmFdPGRs04+r4LiqY?=
 =?us-ascii?Q?1+djI0QDeitx883qB7dETFuCJ0XqlgX5NRq3JE/r/+cPz9IcAz1i5AHwykLm?=
 =?us-ascii?Q?YOZ/ovehuBxd1ohDS5ODZ8Ma84sJGObMTc0YNB683GOc/Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EXAcBH2cUIO/7N14Vj4zEOOkJph+3mn1UpRxuW1hv5XKEN3N9Yr1ToWHHSww?=
 =?us-ascii?Q?f74AwBA/6A/xO3b5ZlLtEet8co5qZByfxHxX/cbihOZ8zjrdzWztoW8bsyoH?=
 =?us-ascii?Q?xEtaKKWSZ458WQpLX99CZlY7Vny0RN9VoqJSQ3UlmeVmQnx/fhAyU0OSvv9T?=
 =?us-ascii?Q?0Ie9VcaX0Xy8OOsSKOrDJrbg5UAka2x8sxhMEkInQA/8R8DICj9RcxvWv1Lz?=
 =?us-ascii?Q?Dzrs/PcK1IkYv/ubj6TG4/pF7zflDlQP4qJoVIH7RC8SfAz0NuvaMq3L81bs?=
 =?us-ascii?Q?42otWWsvukm9SRbT5ThcMB/ST2GCabgIcyky7fIVM5TyYcy6SKtHZc+9Yi1G?=
 =?us-ascii?Q?akew41IqLmG/CgMk2zQHsPX/Wu9FwmNe6j7t4A5Gvc+izdHx1I1H11sC314Y?=
 =?us-ascii?Q?nwEnTjPqkc81p88I+e+lhl/c3gtBwWRYTFlTI+H99zf5KA/c/EE/2JGLBejg?=
 =?us-ascii?Q?yn3Bzb/tFXLq8PENi74PXN2pxFmoZX8t9o1vdMmv4zAj7BG6AopMhzqlM6fF?=
 =?us-ascii?Q?QH8DMM6lFSRK52aRy7MkjLmY3NpePHGoUbr9awkCdzU/esJ2iGIHnUK5lKzh?=
 =?us-ascii?Q?cffVqhpIiaIXnrRVX/hSRvwxlU7cLHgwE9SSogyT7SAsWnH/FQ2Rn+lkdwBv?=
 =?us-ascii?Q?H+54BzoZnUTTkpV7BHHv+CFX2XPa8XXkXsvHu2s4VhEX1mlL/QI3Shkdrhhu?=
 =?us-ascii?Q?nYYXlDPCxiqDfMQOWovXs0hctQRW8qRABLnhMG/JGM4vigIDAmKRxCpFuco9?=
 =?us-ascii?Q?BOnoD7+eqFCqrJiM6ogvkrRpt54JHYA8u53R50dFVY0ZZfz2pY88Sg3Vbs1e?=
 =?us-ascii?Q?q2PZ47gOoA8WKpw2UZPRqwX0sbP9+IWZVwnkBrueJaJ7gFWiZDgewsxr6b/f?=
 =?us-ascii?Q?Jl010BntLyhqhhWGTojSj2S02fweBIPSowWDPUxikRLyhh9I+juMzzIsSVzY?=
 =?us-ascii?Q?4WgNXfmNx/Hk4BaHf4TofQj6eOhb7YwbiuD4dmOWf3aTCueuuOhyX8M0IKnz?=
 =?us-ascii?Q?LOcya9KV1X3FAinTWMhKUlqK6Q01w4hle7UVp5zjFIAX0+dxIHPdkVhWER6R?=
 =?us-ascii?Q?Po+/kb9kdifd8GOtLb737AIsHh8PkXfwakiufiIOxf76SCutbGooA9Ne9H2b?=
 =?us-ascii?Q?uO+kCAac8uz0Bb82yuZs2bzlKu7KUSWVoGnD/6Q+RArn+FRbcWjl/JQbUlDa?=
 =?us-ascii?Q?aAxlPiqNaVULcKYtjkCSU6nepCAC1X94ze5JkFUIinMok1P0wLEZiubUJJlm?=
 =?us-ascii?Q?/w33AEWtLTsmptAV0fI4B6JqoKPWsCIDc9D4eAY0ltTcZXB9MIonuu2J/mM9?=
 =?us-ascii?Q?B7XndEtjHK5XR1nl2Ad0VT0uye+VnhGEhHgP8g+4xMOA2zm0JfQKdO/ogarN?=
 =?us-ascii?Q?mLvaUTcssMMYJAMHPViOo3h5+0WPU4Ya3/NzZZ8yAQxetZZkb8zTdLN83wWl?=
 =?us-ascii?Q?qPa4mQbibn6L/CFMwMZkbX0DMlXJgU3njuP/ELv/9y8uz9/sgnFmv/IasIeq?=
 =?us-ascii?Q?09ZVmT/5Q81eZvLd1lvJKVnjdiDmQtZjM+bhBm+mdB46a2G053qJb1fZ4rGG?=
 =?us-ascii?Q?D+79mlvsxdkRj9AdbvRz9O/YCQHABJOcyvYn00Qgg6C/V+dDjdTbui8qARaP?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JCfTIbpa2/EHREGtV90oB/yjT76vhY/4yn/XFjYRwh9erK2IaT6plztqIt+i2ZrS0qDLyfvmoH8KZnzL7A4/+wjL5D1IVjGbKXOc1BJWzrE4ELBb2sE0izrR3S7pDLel+b1MGP9MwGFlwVne+KEd3iFAnIam+1fYvNwVXtvgSv7KJsT3F9Wu7gWXsDDZ3WQ0tBS+W+8Ynjd5h+EZC+ucEdJHNcA+diuU794BOJ528kvEiP/gu3qrykdCH2MjDm76I0TmolI6G60WrDJ+TKbfPgO85VuCibA8NYMQ37Do8DVA8UySbOgsxvCujwzSfW07IG4h4b/0+g8XGkSGprdeaODeSr1x/+asQ8QI7oOlWo3PgbAXjLt8sIzf9V86PpUjXkfloP4xYfHfUW95zPuytGYX+MUUOx6nngFFVmi5v/IWNnwB5KO75KOyWKQtBeFBPvNbz1vMSPPfrz5oygdlLDQZoMtqxw25htEpICcszCu9pFyoo/SyGIhak3Fcf+gq35fJ7QE4ym/dBad+xuJxRU2rqdpi+ZmWKMEGx07fZqkxD+xGrl1pcHTzsh8zC2ckfOgagpE3Kt38OxSzUebeApuC5tL+kkBchvXrBHm+WVM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff79ae1e-a045-4191-8bf4-08dcb5427552
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 11:33:42.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OAU2ssHMBAwYpJ0X5GtFE64zvJAsRCqccL2u27JtZZouL3zDclRiAJED8/Qjcum/7KoZeKA1GVgi6M2gLfaKfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-04_14,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050083
X-Proofpoint-ORIG-GUID: -63jvwXBGDKLKpLBJgGF7x1NrdPyGRxj
X-Proofpoint-GUID: -63jvwXBGDKLKpLBJgGF7x1NrdPyGRxj

We check in submit_bio_noacct() if flag REQ_ATOMIC is set for both read and
write operations, and then validate the atomic operation if set. Flag
REQ_ATOMIC can only be set for writes, so don't bother checking for reads.

Fixes: 9da3d1e912f3 ("block: Add core atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1217c2cd66dd..bc5e8c5eaac9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -799,6 +799,7 @@ void submit_bio_noacct(struct bio *bio)
 
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
+		break;
 	case REQ_OP_WRITE:
 		if (bio->bi_opf & REQ_ATOMIC) {
 			status = blk_validate_atomic_write_op_size(q, bio);
-- 
2.31.1

