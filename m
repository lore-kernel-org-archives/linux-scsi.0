Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D36236EC6;
	Thu, 16 Jan 2025 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047196; cv=fail; b=gsLd93ou8/E38g900v0eeOSj6+gYQuEEIKW8D1NwhzHFgbhi1Ah6NBmazm/wjxn+XcwJR3P/QPNqYEo4JvXT9KWN1apGDsmkNgRvde8IhuGvsAkwPuU8XpaX5RbKhMecfhZhcrkAi0ta/zuVh/Zx47IljuZ2dnWE0EEdG/SDg9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047196; c=relaxed/simple;
	bh=Ko68i8boginCWVDWUqGkwr4emKFIyhkPMDh+z7EzAB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QYBJEmqPePIbxT5CiRyksXTcR1NkyCeZQ+S1Ck5xk2UPRrfNmhvei3PrdLE/DAN+46UZa91VUsNpwmQBktP0Pe0ccU2p/hchtXEeC3o5mkBs4RaldcJWPxvlS2iqDrwqGMod23JTC4Ix9CPBe9AGPMJkZwJx5ySIO7tXWasXXwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iA5SBYHn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pMAgtqVI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iA5SBYHn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pMAgtqVI"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0j6t012919;
	Thu, 16 Jan 2025 17:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=2KwqKYkfrS0/ORpRT2wJhvLt+SQcJditF7aA6k0Mk4U=; b=
	iA5SBYHnHwc4Ot/PcdkgaVnKIwc6MNOMx1JAUHwQ67MPScm1R4SZWM1+Shf+Vgy2
	NiijkSHPU646ZYbSeHENbx/4KkRMlTOHZlHXzpcnvYxVkLtx+uZxyY7Q+iBwuhFJ
	KNC/hd2NU5Cq7lvH+jMDqDf36jGpdp8Mp5xwy0r9g/c3J9GZn+hTqXzgcCUFTvTV
	N46gPiGOBUfzRTqheukCXqdE8jJbhXGr+TfnNlPPKdUiL8M3FVhNrQ7Cre08Pfo0
	XjSni0Eonoux5sH+zDDSFVxv3SfWl3r1uMw7jzpH80jJV9oHuJVgD3y2ctSQ/nIA
	bdjRlacPt7f3ul8cBkVOJw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 446912ucqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH2Opj005236;
	Thu, 16 Jan 2025 17:03:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4473e57p15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J7fOt2c/HBzm8srDydz3vmXkiFmwnr/btp1SQYh9szm+oB6PdFD9IjSOliNCSHCuSQwi/wF5+7Ut5bIX7zdxQwpygD28rLiI8Xrhp9eobW23Dq7zMIML/gU7AfGQyQvPw9xETfW53+kKNPMYY5Y2AUwiiqCs5J4VPay10n633VVhUX2Q6Dl/0+1COeA32KuocCliggH9SF5EPm2vX6c0u1ds/bfMQNn8CWoP2UTpSiBKUS0xW6CPmFxxAO48US5WBdPTNr5TqbpkUGfoY/YCNtANv7+CxphOSk5ZfU4/ha7yDM2TUKwCoHRXR38SWvvrm0HHMic1bgkmwVodWQzAfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KwqKYkfrS0/ORpRT2wJhvLt+SQcJditF7aA6k0Mk4U=;
 b=mz4ULqO8cdWf/TKUswnPBIWFfJbrUYYcG/JQ3IJzcqJRcB3E89FPIPoBu/yDFb1iHmqQwRLRXNTe3fDaaEY2ZFGo5QXFB0RXIFat3OBaCub01wGG1dILjEFIIdXyQVdI8kHK5Jn/SB4y9JNwIACUcu2TcHlkPH4GSx7Ce2LLrpBngitLgGsCHSl0o1IQzIWHpK9xXy0rtaYy7u/M+pRg4Yz4xT+hZsfM3FCQujLrQjAjApFtx4T4rm5t2yt/LTslHU/LQREdoT76whsnsl3Mr+JSs1TKkaP4DQwxLIw1lzylHTiMK/vUhWlN2WqyjHccDorFTyW+9nSlyNxWWgGR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KwqKYkfrS0/ORpRT2wJhvLt+SQcJditF7aA6k0Mk4U=;
 b=pMAgtqVIRQ8nfGuCo7s8tzG8VEr98GeO02A5bkpgae3oJ2uo2N6fL8tSNvtdx2WivrVAvhNX7pM2Eqq6To9ikioucS+RcCMurQXervWWxVZrz6iI8GgPmO3K5CNVLcvVo8EjqZ7jCbIVlwgb0l5ykSCHRnREUWvZTW6rNC8YT0A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5829.namprd10.prod.outlook.com (2603:10b6:510:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 1/8] block: Add common atomic writes enable flag
Date: Thu, 16 Jan 2025 17:02:54 +0000
Message-Id: <20250116170301.474130-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: ab96874f-3d65-4fba-0db3-08dd364fb3bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Btxe39+OA8EfJp8/LxbamsfK7wLrW24bVmbqoFYt9tNnxaiy3Tz9Q6TqnZv3?=
 =?us-ascii?Q?o1zyO9nxtnopsJPKWnwTzAdlZ656OGbp4SyzGrMt7e5Ipk4+QZFlZPZ8vF3K?=
 =?us-ascii?Q?vnehkZSJtAEMfzKFNkIfntTikO3X3bTEgYS+QYoTJhspLgWGW5wBovwBfYb/?=
 =?us-ascii?Q?UPQ75u6KdDSpYM01Z0n7RwMZq61BUXYUG4E3CZJXnJF9UiOnPjjit2PhzVYq?=
 =?us-ascii?Q?eBVbo2r1Q0bj+JQGwkW6HMyInCwJ/61cs36ezTJWY8jnTSNNKCp8HAWvAQzX?=
 =?us-ascii?Q?2gTe1GMTGRfpKLUQfS4vrapU6mm89UjKbzLgr8FDtu5Gw2AGryTIxNhHmReB?=
 =?us-ascii?Q?uRgDybPX/tgbtcmpL/dJPgCD3wQcCFGRBMUQ0F7raaNGs8tz21ZIo7Gv5LeP?=
 =?us-ascii?Q?Uz4HnIIuNqT8cnmgxJDxbRKquvbKGsGuDkUQJlx6l6tDDbjDadjMBIqLPoAM?=
 =?us-ascii?Q?rgJJgdgAWRfNsL13GDrhyvUWrnHeb10fInslPZSnrCUBLTkRETWZD+52oH+y?=
 =?us-ascii?Q?ed1jaWMmluYlBzLcmqn615ixJvWmw5XzgTEGTxQVPVCeQJIh8iF9Mkpty/H3?=
 =?us-ascii?Q?Yw6+S7hwgz6MIKig28HvENivbjd5iiVIsS7XySbeuMXKSf8hmOozQL7iQCYs?=
 =?us-ascii?Q?/5PpF/NCQfJWayU4dws/tl3h8sC+A5faJq3dFq0roNIlLMU6KOeGeMmA2C0/?=
 =?us-ascii?Q?v5DNfiJueUstTuDBTExvFFBpzG92Cqvp/vstBWNm3jZxW+cki8ShX9YGjMMV?=
 =?us-ascii?Q?3sqGBsgEcvhluFKdWzGAs5INj2/aq6viF8bkJftjahYboYESZIQ0yOlJNUiJ?=
 =?us-ascii?Q?sGzACcGeGMU9mJ5Ixv49jP78AgeZg3EVxL6CpxzxY+0TizK/qKgpzBFVFNZA?=
 =?us-ascii?Q?Ye9VjdTyM7u9DpUHoaM1CjealPRVAscn5gAvVTA79UaNm/btzOGQTkcPE4bE?=
 =?us-ascii?Q?xRf3MPR8WnKYkzKfWEzMrcjuJdVa8V9XEiUvGvB/gC23qloePKpKS8M1wZEc?=
 =?us-ascii?Q?WoawJ2WotHMdDGvwn7utOQB/E4O2AccFrGDS763cXoXxzVQGWqcwLH9ctBui?=
 =?us-ascii?Q?nMb0QId72IGFbZXje+geZZ+iatOzSTE44sDcuQHoYs9oEJ/IZGMw4wWnvrcm?=
 =?us-ascii?Q?7y8m7sNPmD5Yh1UpfmjzUkq/6cxk4oZiQg4vKD3So48CIS1K8LaqdJCOfaMB?=
 =?us-ascii?Q?uWAaFLahoUhSH0pj9ycYUoDeKsfGDeA0WOdyCy0qMgTqXCMGKYLfa2Z9aohp?=
 =?us-ascii?Q?UkhAlR7Gz/pTjSMVRc7kjV4Uy0F+IxDSQ6CmlX+rOBoVMVUm/C2k5U6MXX1N?=
 =?us-ascii?Q?rc6SqxC7SMbAB/8GhSalIdBKLF4HPVQW5ssEtLmvb4uGTQMJUJdhY6ZTh8h7?=
 =?us-ascii?Q?r0qAD3h09zzH8aRwfint2xBvveNF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C3Vu7J/Z4mSF19/G7O/3CS4II5gdKS8teLtBiagoS71f4+8BtP44Ihchs7f5?=
 =?us-ascii?Q?Mb5BLuPzJ9Qtk67wK/ey3iyOPOTFbU5o/mi8+mkGWRQlhp/RrQRZET7fG9br?=
 =?us-ascii?Q?9GGm8JzrOZvBxqOTo4ki3FOEhuHxCuAcCGj6TKJXg4EkMg3sY2zmWUc6oohq?=
 =?us-ascii?Q?9c8elaP5pWOa+R54iUd1obIaye3L4RfkckZy3dH+y2203VBs2If5yL5tB7of?=
 =?us-ascii?Q?kKOQwnWhk99+UWeUsgPbrW211rZ5ZIqbu6c9ss2PJNbRjjE3yEY1mkdPqnnF?=
 =?us-ascii?Q?HZDB7UCv32Tg+ufzGiuiZ7nTg2Gt/ceF7vnUP0NKDs4PhDx6Q1VPAEMI5qLn?=
 =?us-ascii?Q?dIcCdhQROtztT3B7JddoJWS4l/OfZmpPaWmKjww7eAcZghjvvVBVlK8dwMLX?=
 =?us-ascii?Q?fkVJcTG8HbH+PQCP6SqWzO+pm4X+ErbbGz7Im99UT57zy1Wxo3n2D8xwpZGV?=
 =?us-ascii?Q?34mpEGYf9GiP/7IHNE4iJ0IwLabGs6AB75HLyKJnWOjoEGFWQacxNaN08sG0?=
 =?us-ascii?Q?dtBUvWE728vZv6Cz8R80XKJs3rAHN1F9uE8n/RFQO2zag5F8/h60PMVn25oM?=
 =?us-ascii?Q?M9UYrJcRcE8Mz5ki25kJ2AAE7oULa6fRys2PYocbaDBQTu1QIRHrC8tlPX1H?=
 =?us-ascii?Q?EZufF9ryLfAp7apciIsxGDUaClDiJFRj0EbsPLCvNKYV5Y0B1oql3fFJnnql?=
 =?us-ascii?Q?Z463Oqqwgiim7Gb9jCOcVsqN4oCcsWsOOA2ocVLsTJYiLEBr+fdpx7iYPZGT?=
 =?us-ascii?Q?e9lWy2Ltr/hdJSZGdYsKNV6EKFk1Vr5Lyr6mBp4tH0C0fmcgivAzw3/JvCdw?=
 =?us-ascii?Q?P3f9+f19AAbgVu5snLiP5kp/hEuq9eUBnBa4bcFunVfnUPAflgrWKhQDOKRt?=
 =?us-ascii?Q?/1CTA/QrFDcCFAZriisavf5+hHxpmSuL+LOBitUdwHAqSD1mdFB1TrHxHJxJ?=
 =?us-ascii?Q?0NVyIy99lg5YvsTpjovEmHuBkDZR3WOqf+UdIX5nIVsH437moUpp8XA4CNI/?=
 =?us-ascii?Q?v0NGZHL3VHXsHXBeetT8LfJe02T83XuK56OFgMdyyooCCK2LqvADkVNPtsYI?=
 =?us-ascii?Q?HpGvVtLjopTumgLVVER7FudaZAsHUexhdL7Ql1XGlRfbGDIE2KxpIY221odM?=
 =?us-ascii?Q?NDg0CSYgs+aYqypOAi58cwRpADnH8tNz8GrRvMTyj/6y/2dwoIjIDvR3ag2t?=
 =?us-ascii?Q?itYmaAWlSngOe+BgstLPn/dFKtwdFmvTHkfZTJHoLzTctziz64OZSzPKo1k0?=
 =?us-ascii?Q?GSVm1ESn1Ar7tMNonyoOS7UmjUdnARfPOqKfphOSUTLtNiNhcqZL+2jcuuwA?=
 =?us-ascii?Q?y08VMgSB8cqjMfxhaTidhp42Sq+mrOHlkuAYZ7P0y3GFzMqW6/Z7op+JOqBr?=
 =?us-ascii?Q?1h++V3DNYAmODF6SRZjkO4BGnl3xgygiG17xzcy9PdURPbcQuZblER7qnEb+?=
 =?us-ascii?Q?WLXgPi/jFzBqDdJV9irA5sTOf0P5v6B+iRbli2Q0Q7t4QQAglu7QfZLMmYRK?=
 =?us-ascii?Q?weH+b2GPNIM069TX3i4AdMx5kFU8kwO86PpvzlDmMdcEzLwKILiIyUwFrYTp?=
 =?us-ascii?Q?qdKSN3Xx7R5NOZ+pg49o+bFP3DxXffPs2LLJYj6vXDLFo6TCK93fi/BWZRmb?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8hNCL9JYo3OXDm35wEk1QGKFYmlDHeTf+V9GKIrR1fDtwphjdIwHsmImCHlfm6zN4jIDxFzzHbiG/oDiZwE1o+mJoGKzRN8R8I+WFJsd4vswOwAzLeTsbHaD74uy4oCTSDmIb72nAIWn56wQoKPxCTy4HfS/esvC8KBbh7ALSjuFMsQ5SzIbcdFygiApChX3fnR1TTNwSUYtQ+3bg1qDB4gxwIdSAC8zAHZBpiwd4bEuiW7ZWX5RzjiHuVn8FmZ/rPdGnOBfC9X2sgyIrE5IsU1dEfTWACXMtkKnqZpxfuYmnF8tgODJXjnf8pz1V45i/kos7tuXokAXvdkVw4Ixnd24whMTDuQVMh+6VLrE4KymSF6CPqtYuW/fvFX+krewS7MrWI0k/NlA3X7qs+/nEpBpDzudpyq2PoX9Am8Yhw6S6jmiBvGRcTB3JrepPTsfhUUb+fqdREZx8SZFX3PufL380d+UmGmjEIVXfIr+joTcYEzzy/42fyxypyV7bztyyHNfgS4FnB5rQQ5OC9EI1d1beInBDsn41SHF8C6VigHx+2VHDSR4oEqMj1lqjLf9QnmW+EnE4DWzoTrFpnIuJFWKwCafIYICyxcJUerzbX8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab96874f-3d65-4fba-0db3-08dd364fb3bb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:30.4034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XYxyNHzs4ECICRSKEESeyiSDX+KW5T6a2DaJ7YjFkjwA1m73KY/cd2JtLGxC22wO0Q78znTu9MA04O//2iwaNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-ORIG-GUID: -PqexSUVRgudlNviQOJl-476WpvZTubi
X-Proofpoint-GUID: -PqexSUVRgudlNviQOJl-476WpvZTubi

Currently only stacked devices need to explicitly enable atomic writes by
setting BLK_FEAT_ATOMIC_WRITES_STACKED flag.

This does not work well for device mapper stacking devices, as there many
sets of limits are stacked and what is the 'bottom' and 'top' device can
swapped. This means that BLK_FEAT_ATOMIC_WRITES_STACKED needs to be set
for many queue limits, which is messy.

Generalize enabling atomic writes enabling by ensuring that all devices
must explicitly set a flag - that includes NVMe, SCSI sd, and md raid.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c     | 6 ++++--
 drivers/md/raid0.c       | 2 +-
 drivers/md/raid1.c       | 2 +-
 drivers/md/raid10.c      | 2 +-
 drivers/nvme/host/core.c | 1 +
 drivers/scsi/sd.c        | 1 +
 include/linux/blkdev.h   | 4 ++--
 7 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c8368ee8de2e..db12396ff5c7 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -175,6 +175,9 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
 	unsigned int boundary_sectors;
 
+	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
+		goto unsupported;
+
 	if (!lim->atomic_write_hw_max)
 		goto unsupported;
 
@@ -611,7 +614,7 @@ static bool blk_stack_atomic_writes_head(struct queue_limits *t,
 static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 				struct queue_limits *b, sector_t start)
 {
-	if (!(t->features & BLK_FEAT_ATOMIC_WRITES_STACKED))
+	if (!(b->features & BLK_FEAT_ATOMIC_WRITES))
 		goto unsupported;
 
 	if (!b->atomic_write_hw_unit_min)
@@ -639,7 +642,6 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 	t->atomic_write_hw_unit_max = 0;
 	t->atomic_write_hw_unit_min = 0;
 	t->atomic_write_hw_boundary = 0;
-	t->features &= ~BLK_FEAT_ATOMIC_WRITES_STACKED;
 }
 
 /**
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 7049ec7fb8eb..8fc9339b00c7 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,7 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
-	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a5cd6522fc2d..9d57a88dbd26 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3217,7 +3217,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
-	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e1e6cd7fb125..efe93b979167 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4018,7 +4018,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
-	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9e7f1bb81973..cebaacead727 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2002,6 +2002,7 @@ static void nvme_update_atomic_write_disk_info(struct nvme_ns *ns,
 	lim->atomic_write_hw_boundary = boundary;
 	lim->atomic_write_hw_unit_min = bs;
 	lim->atomic_write_hw_unit_max = rounddown_pow_of_two(atomic_bs);
+	lim->features |= BLK_FEAT_ATOMIC_WRITES;
 }
 
 static u32 nvme_max_drv_segments(struct nvme_ctrl *ctrl)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3d42480deb3f..7900817db8cc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -992,6 +992,7 @@ static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
 	lim->atomic_write_hw_boundary = lim->atomic_write_hw_max * 4;
 	lim->atomic_write_hw_unit_min = unit_min * logical_block_size;
 	lim->atomic_write_hw_unit_max = unit_max * logical_block_size;
+	lim->features |= BLK_FEAT_ATOMIC_WRITES;
 }
 
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7ac153e4423a..76f0a4e7c2e5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -331,8 +331,8 @@ typedef unsigned int __bitwise blk_features_t;
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
 
-/* stacked device can/does support atomic writes */
-#define BLK_FEAT_ATOMIC_WRITES_STACKED \
+/* atomic writes enabled */
+#define BLK_FEAT_ATOMIC_WRITES \
 	((__force blk_features_t)(1u << 16))
 
 /*
-- 
2.31.1

