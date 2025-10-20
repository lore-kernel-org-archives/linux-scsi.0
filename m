Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A612FB98E;
	Mon, 20 Oct 2025 10:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956722; cv=fail; b=Cqb8CVVL48xQBsAHH5f32RJ2CTHaX1weo+VILv7gI8B4K4VHBWjEQEnuJHeKPoiLqm6DesKIA54XZ2ZsZQHhovNfpIq2r5weT+t5lRueuyC+Vxbo5V0fV2apun7VsyfvX6XbrH+hV6izkg4tocJK7nNa1NTIEaDlzDHCZx+jwU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956722; c=relaxed/simple;
	bh=7q7fvISRHlOSuaQgGSsmw74aASZM7UimU2n9zoqt+Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FWaQ7RsXDVw+5FEB8sG7hpCs880mCJUz2O8Vmgr+/YRBiR0JfKGA9yAUUYUDsRy1cam75iMUyzt5S6k/72LfD+b4hZO+6fIc/iSLz/foDklX6WAoaCr9j/TG1ef+h7deFDdreFcO2QhU7jyGmJkmGf5C7lEF3F0ZDlox2ZijEk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HDtcufAj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VAc0zuuy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HDtcufAj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VAc0zuuy"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SQh9025951;
	Mon, 20 Oct 2025 10:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4CBO3F99vxG2oSE5QjvWJFrskOyDJ0xkzF1EfyyOIgE=; b=
	HDtcufAjSwCxPDV4vy1iBRbLBLO0jlqQJPkl1ZRLnbzCrnMWPZrwK1/CrDPwdDtZ
	sYUMw6lL9K46KIk6BpWnhPnoF8E+7rJ6dKKiEjy1U/oWUuH64ysxF0q+CD6JloQ9
	tJXcsatb/StpOqTj6JpnoCvd9MKOkbz70wuCKeiwpomtNF3oZUuFyBi+wceS+Dgt
	ZvqngFNpN/SuDkcoAvMuXwy8WnfmGDPJjKtKJLYik/OJpkoilNTwBJ6wGpHOQXun
	jLEY2h20V1TrBxLb+OOLKdJcje06xtoAJ4KdgUtGhyVaOcGcujqWqZoSYIWydaao
	YjfDy3Evhueqsult6A+BZA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3eshyt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KAANrc009365;
	Mon, 20 Oct 2025 10:38:38 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbt4fk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xV4PgLW/uyBX13gdNlIh6gAYRkFWJLB7C4yNFbvcBBADHXvDV751Cn56xpmTtQ5ZfMpZlb8IkHqKDVk9WHx+60FSvRHJ3l1DkzZk0CH7n1VJA5wF/tJjmioZaQq9ydDGVbk3Q6OMIy3IjPgOekAuKmHlVEeB7A+PsU0Ynk22HbRzahRw+jtmm/gaUCSz7iXl4zJv4M7gHaAuo30JGjSzoXuWLeLDuC5UWqvYacCsIz9qHPXxoExnIHzwbtAqz5PIw5spZRfVe5sWhoUoC1TQWfSI8AK0v4G1+6EtD2Y/mmxmSmLaQNK9iWnjnROQqFYv3wiMcRstDUJKXD1FGeEyvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4CBO3F99vxG2oSE5QjvWJFrskOyDJ0xkzF1EfyyOIgE=;
 b=RiPGt128lsTej7WiF8JVuvEq008g2Vh14uzgQ5c+PKgUzSHKu1udvFOqU+ywwBueayFH5PP5DIV8hc2KWqgWRTEmbBeLD1HREeEEW8GUejF6rd2qIvqTLGqReT8VKiZaBZryEa0Rq/TmjPBUDEgqLyEm6o4p8yoIXDX/TzllwC9KsqmDmHT1WgTvbygXpoydljAi58cqjMe5GXU2VWyuDlvXCoUCQ77/Bl5maV0oINJfVb7sfXUCuQu9EmHqn2LBZYdc7wKcM2NwpsS19h6DCeQzihwT6DwKTAAG+MveHU7Hm9fAasNpAsk9uxBLQ7Augsolf4VGFpqLJOzTbf57ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4CBO3F99vxG2oSE5QjvWJFrskOyDJ0xkzF1EfyyOIgE=;
 b=VAc0zuuyYVDnh/4L0HQP8LeH8qGHKiArhGYQ7FgS9s2y0IyUkONCVTrFzAlCAr5HKJm+vGTrC03xSbr6DJe1NMZRU1j16Q/ExFxNAN/xvzvY43IrS74BGMiTDEeBw1z8j5cB+NTPX1hBEbeNg3o1QqnckLCYR/G1Vu8KeOctl+4=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 10:38:35 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 10:38:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 5/7] scsi: target: Report atomic values in INQUIRY
Date: Mon, 20 Oct 2025 10:38:18 +0000
Message-ID: <20251020103820.2917593-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:510:324::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 56c5fa28-d5af-461e-34b4-08de0fc4d291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YZfacn8TYz8ZpWIkJIETNEMA2b2rAr7UyD4PGdwzYqq6YHAI/hOMQ+VvxUkf?=
 =?us-ascii?Q?eb42SZMCVD4LxH41UpRh2vB9uSb+5FAxUFNiIfZ9nSFMO72ASKWPV+Btlops?=
 =?us-ascii?Q?Rx7LY3G16CMNFCVeLy3a2IO3ZoZ4P/N566ahmjXAMMLl2ouqiS9d1NlxRRvq?=
 =?us-ascii?Q?mBbTIXv2a9Sb+k0j//snF5hKwjKnwrEd1SKroDLUmQsOW+hlIb/YArD8aBhL?=
 =?us-ascii?Q?r9LU/6DKU3bFL++NRZFr9WzzbwgdjNC1ys/QljABfdh7mG0viYfsIK3r/+kZ?=
 =?us-ascii?Q?zaIitBAQM8bABdzKYh/lD0vWo+gKnbK9K+rLPG0vP4vEXNRZLSCE/uimpq2w?=
 =?us-ascii?Q?/Dkvnhr1bRMy9unn1SmFW6MfGiAGwv5j/kutTjXi85G7nvMJRTsAXr/322kG?=
 =?us-ascii?Q?Oj3dx3yLr7gfM0NNTUamrTwcUK7bIWx2TMiYhimRMKgSq8AcXEQO+X3F4QlA?=
 =?us-ascii?Q?PgTr2XEJIysN7L4DRT+uE05vnG1ASW4CacL7/G/5GEIepSmmiqEtBzC+0AzQ?=
 =?us-ascii?Q?Tdr5vAW3VYH3TWSTD3fVRN2QDro4kplaBZTF5r8l0wXjQXf6MoWc2tV+BPJH?=
 =?us-ascii?Q?m2F9Hj7b1OjV1KYJAFOs0hUGcFvtZuDMIIXy4Hgut8JvjmgGC5ppSpZe74Ee?=
 =?us-ascii?Q?/P4AKddkTgOnjUuzUjYq6ySZcUEMcmQUvmQMFNlTNoK9qTpDxmG8jObErllJ?=
 =?us-ascii?Q?ID/8typ6jRT5zH1UEchTuEwb3Khazy5OIjmf6WVQaZ7uuLhQtA00qxGcXyK4?=
 =?us-ascii?Q?xTkD8UGH9bsHUtq8VPEocbJ6WYrNl1CkqtYt0QNhkXcAcBb44d16275xz4pH?=
 =?us-ascii?Q?G6Jc0Q/p2MyoideW1VF8PYlSWdoHBKqj4Cx7kPCWFW8VyQfR3bc9vv7CR1b1?=
 =?us-ascii?Q?+x2icJUxmh49n8jHtB+Tu5dLcBrfm9h0H4TwkvhaOiOgEsDSDBgd0jlcr6LM?=
 =?us-ascii?Q?Cchf2gZPQAFWa8HkwQAx9ii5CfIoXWyfEhAXUHRFrVeSHEfNov9EA8io8c7l?=
 =?us-ascii?Q?sCjBOPopfqQD6piYAgvhBRBjIbjEM9leoTMBrZaR3B2raloxr+aLVSB+lzDz?=
 =?us-ascii?Q?EXZTw3ZtPOah6JhRZcAzp5FkQQqv1vU8lkFbtpQyEGSbXs7m7J8Fxk+g1j0Z?=
 =?us-ascii?Q?rX6qKFkH2mSpmP9KymtmMUYOJZy4MDROfJS6yq/Qs2XQnz25xlY2QOR3I/JX?=
 =?us-ascii?Q?eHITJ0KZqa2fKB/1JGXCJ162Q2LT1cViMOhAfgc5h8rDHBm9rX33lY4waAa9?=
 =?us-ascii?Q?6qodW/rYUE6/NBEpYnXWnBPnMSfG08VxbAQ3B7AHpJwSsrPNATaTOvnDMNed?=
 =?us-ascii?Q?WdmBrfTmxVW/1arTBzpSMHg7VtGzSDBuyh13pD5cYPjuqs0mOjs7TtTlu8QX?=
 =?us-ascii?Q?6WST+kYFd1cPltP/J79hXUxwIw1bGPNc8jHlrrhA9LJLW/Z7tFhVoQ0K1loI?=
 =?us-ascii?Q?q/J7GBX4+xzE0hodrUX1eZ0EhGYfa/2nJbWKGllPl/re0n5Eost/OZ9hCFaC?=
 =?us-ascii?Q?MGBp7TycfwpXo7Ns59zxmkYGqcpNv4t9qmbs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gwcs3zFR/wEmaBOf1zYgfn+pfVuSm+GJdDwjvT0/sNDIEOZE6N3b2Zjshlzj?=
 =?us-ascii?Q?NXbr1VS0ng8K/IDndcGHeF0HOPtrI9SUaX10CF4m5e68gQBwTFtXLGzJhwiJ?=
 =?us-ascii?Q?W541p9Di56RU9S2hmIEYH5N6s1At5ntt9aMFG9wlHfS1dtBRn15UW4+vNqAZ?=
 =?us-ascii?Q?DQlXd3CRZoyl3TXIK9KhxeMk5BFGHzZqAc5G3PkzaZ/yhsBEQkgrz9EjOsJI?=
 =?us-ascii?Q?ws6SFtoK474TtH5VbwHa5F3goA7QsPQRJyy0AfVVNHOkhnu606cVd8KTHLYI?=
 =?us-ascii?Q?lOXzFKK1kP0FQqL4MVzvmW3a1uMpsCXi3K3sAMz/5wUZ1YMDF7VShPaA1VKB?=
 =?us-ascii?Q?yPlc0RQ7dfTAHdlWHi1qbprylQ6IWPv6QhUCqSoRcvsm+MnTGMcXJFSVC78X?=
 =?us-ascii?Q?P79FjTUIlpoyuj2bGQYd8d2ZT+rXXmhMgpeSHikwPbrtXmyFrfRzBoiQBStv?=
 =?us-ascii?Q?w/C+02tsLPrLFOXQmdpNHXu+eOMle1dNGyhHj8lHAzOJPLfPtfYlqGuKiPsl?=
 =?us-ascii?Q?OugXm1XrU11Av7duOHshCJbtqIhyNBRDyPJGAijbjFkSgLNLZchJJZ3beixl?=
 =?us-ascii?Q?tE2xPM2lNrNRIAwOjk2em1zEm1Mv4mH1SodChgQsb8nqWrzBH4ALMRI0HXGW?=
 =?us-ascii?Q?0HhmJLqr2bTzDECTfSp1VKAWLcgRQoW2Wl33MT3AHI57EsvNomJVITJqouHb?=
 =?us-ascii?Q?7aOdZUFhEGc6N6ci07v8CL/nrAQUPmefIApdxGeOCqoZBiUQm81nNaPsE42U?=
 =?us-ascii?Q?zNTkekJXx+DUZj6dyH+p+HPe37dV2y/iHmCfgSWI6QKT5FgIb2/FemVE1gyH?=
 =?us-ascii?Q?kxrljLJ9mWBe+bIKdAZL6mw+HlnYmf8rig5GT+rJnGsLFz+5THLc+8WWCvkg?=
 =?us-ascii?Q?DZRqpAtuO+krS0gndqI64xyNLQynebK5UmcJhxZh5tQ9wdpb8l9e0zUGkDyY?=
 =?us-ascii?Q?95AqSDP5wytwhstYb1ywOP3mfvQ2GYNlx8MULYOHGq3bPhidZc+g7pSaBQuw?=
 =?us-ascii?Q?eXiM09ff4sficrYI7L77brgpNC7gEwwpn8TQX+YehyOheIRY3oNsg7jgXGhw?=
 =?us-ascii?Q?W4Bk9cEiZWYJnRLXc3FclHhOVQ/i5fq3RrTBoNgSeTcj2oYgr3C5uhiJQOyi?=
 =?us-ascii?Q?5+gYQgDRjGWh/TN3yKSguDLh0bOVP6UugiDACbNkPbF4yO80MwaH6qgu7a4W?=
 =?us-ascii?Q?GwramJgXAwFMiI0gE3gCy8VOwuS4QtzA+fFGaFv7wFZ3ZD5lftDcZvIX7eeX?=
 =?us-ascii?Q?+OZgM7sQ/e0OwM9Y2zc/5oHU+35gjUawKa3xv1iC/AsaWnBAq+709egDbskL?=
 =?us-ascii?Q?S+2rgpRdQid8mWXo5iNTY4eu12/RH7iaQqSo9VbmUSg7+9U2XYA/2FdFVyoQ?=
 =?us-ascii?Q?zkto7t9jQwMaHyFQDYTwypaiYn/pr34YZd0jby7SfC2LN9o9FK/i8pt8k5S6?=
 =?us-ascii?Q?hpvX1btNzHGTYy4Jg7VOrtg3ddK4pEYaMbbW1OCCWqpobDF82kMtd1pBXykA?=
 =?us-ascii?Q?i689gmh1pay50hvfddIwfKfOJhsnBiabfikOJPIXsfYccA5Sp44hcAHFV5r8?=
 =?us-ascii?Q?TXR8/uoU3lUGsZr9YknJ88c9bmLqsUtJhE16UONWFT9Sb63g16+LDy9HTNOy?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	25gqwv7yQTcveFjwUtO3cOL6xZ/hcg52G1z7jSvXl2Cy0144yQLTIxesDQqZCxzUS88+Ibxo3gjiO6MeK9UWkW1ZXobNW319sJ28GXirjbZVVMHtkYIvmhcb9r6i51lS4DyzmtrgHjNDHT0GFRxX7GA38uzWVNPHmRRggB1+GhXvfAdbhjJw5rQveWFlsKeCZjuOQe70btEhMSe37T1oM8B1ZqZQFN/0w0DM2F+BLNp/YNH9jpaOQkJL4AbcglG6ZTJfrcRqKrfS0SmpGEaXsONUhucBYqrL22CVC9bTI/W8o0gD4d9D1ygQneKWwaXj0vSty1lmimYiUFFFV8QVyUgcmgQ4qXujsbPvbSYnam5ZgFDTX+VQPVunJiEkl1y6h/Ijf2nvw327MJY/+DcdPRafROjVOGqNb5ePSKPRg1381u0EIrL/jWMPJT469AfUV3rr73U1jx56rGr22lh37dirF0renUSi/xzP+fEEC8YQnbYwGBAzDfFj0ByhufAbq/0YEfmgoQAT7A/gCqFBrNepLdh0uogJbXzAQdkIvCQaudKYMllV8CNu07B9SvfmNcAjKTOOBPsmklpWuUPrt8VTAb17/hKSgIy1uHnRpP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c5fa28-d5af-461e-34b4-08de0fc4d291
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 10:38:35.6897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POVqFj+0AD7WaXMUT6dUR+6BiBD5QXEmqgizfVwio89LiiN5K0MUwx6GXETqNbfbYuVn6L4NGcqDq+iX1f6c8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200087
X-Authority-Analysis: v=2.4 cv=N8Mk1m9B c=1 sm=1 tr=0 ts=68f6112f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=iQ0eGL1bR3Y7-yOI9L4A:9 cc=ntf awl=host:12092
X-Proofpoint-ORIG-GUID: Lsm5fi8gfKP6oTqfX7NeLPQkWwF_W9Nw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyNSBTYWx0ZWRfXwdxKQbJR6J1a
 zdgWr9wlR8rZh4dOHCJsbADtLKUQKDCMH173DYKQd/Cb0hBWHnbWNJwlTnvtUfvGhtgvTa3hUss
 ZqmAmLu+sIlr9DG3Std/NEhxWVwENgzqVnnCEz7LnXz1FK6BDz+8R6Z/mSiJ5emdJcf/94Z+p+R
 8rQzyVdWOvviI2DOLqSZUj9KGE23WyauJdWz8kesgpBiBdhdwmb/pP036vg+P430cib0/7iGYqS
 j/UV5mCx5jdsqSLvlJaGQX92XJpbo9KDgkI/jX/MQ6c3VlFwBxVdvYRCqY6S2XlSpbxGqa2US0y
 VMQsm+npeqBv2rouIWttRAy0+lE0YZHAPvCRCsrBksIdZENlu2FEe8Pu+IMkTE54ZO3u7TWQ4IN
 LtZz/mT7Bv1Lvn+YJuXxFsvIr83U5OfwaMcENhcCmqkU5zYHylc=
X-Proofpoint-GUID: Lsm5fi8gfKP6oTqfX7NeLPQkWwF_W9Nw

From: Mike Christie <michael.christie@oracle.com>

This reports the atomic values in the Block Limits VPD page.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
jpg: handle not having atomic_supported attribute
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_spc.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index aad0096afa21c..ddf8104645d1e 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -521,7 +521,6 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 		have_tp = 1;
 
 	buf[0] = dev->transport->get_device_type(dev);
-	buf[3] = have_tp ? 0x3c : 0x10;
 
 	/* Set WSNZ to 1 */
 	buf[4] = 0x01;
@@ -562,11 +561,10 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	else
 		put_unaligned_be32(dev->dev_attrib.optimal_sectors, &buf[12]);
 
-	/*
-	 * Exit now if we don't support TP.
-	 */
+	put_unaligned_be16(12, &buf[2]);
+
 	if (!have_tp)
-		goto max_write_same;
+		goto try_atomic;
 
 	/*
 	 * Set MAXIMUM UNMAP LBA COUNT
@@ -595,9 +593,29 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * MAXIMUM WRITE SAME LENGTH
 	 */
-max_write_same:
 	put_unaligned_be64(dev->dev_attrib.max_write_same_len, &buf[36]);
 
+	put_unaligned_be16(40, &buf[2]);
+
+try_atomic:
+	/*
+	 * ATOMIC
+	 */
+	if (!dev->dev_attrib.atomic_max_len)
+		goto done;
+
+	if (dev->dev_attrib.atomic_max_len < io_max_blocks)
+		put_unaligned_be32(dev->dev_attrib.atomic_max_len, &buf[44]);
+	else
+		put_unaligned_be32(io_max_blocks, &buf[44]);
+
+	put_unaligned_be32(dev->dev_attrib.atomic_alignment, &buf[48]);
+	put_unaligned_be32(dev->dev_attrib.atomic_granularity, &buf[52]);
+	put_unaligned_be32(dev->dev_attrib.atomic_max_with_boundary, &buf[56]);
+	put_unaligned_be32(dev->dev_attrib.atomic_max_boundary, &buf[60]);
+
+	put_unaligned_be16(60, &buf[2]);
+done:
 	return 0;
 }
 
-- 
2.43.5

