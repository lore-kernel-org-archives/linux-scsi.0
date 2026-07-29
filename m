Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372703B42EA;
	Wed, 29 Jul 2026 10:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322337; cv=fail; b=MARJKYV3FgEH3pPH1pf3uPey+HzAzkqwJCSnWkkKw8EWm7EGWfQvKtvQ+FIgL2a/wGw8GOKs/kj6BqIErWRImOj0VYHDChCnLqfNgw/+gh/rrURyfekN8TqGg0E8YLNUQYu/R3krqnZV8+cib+34sH47LQDTp49UJ+RrxAgpvLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322337; c=relaxed/simple;
	bh=KssMEVyJ3HnA5iM5WkHUsYPtsX/lzCm07V59HBqeA7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XryCqG0D6o/m3qzQZbl4vHfxiPZNnqBZaZnu0qE048S66YJk+xBMphHT28y8/t5AkNCGNVpkqcgVUtC1NVRJXMsFQTtwznUCBhHsv9LEITM82je8e2bEi98CLyNoD9xiyIflLYXrQEnqk648utnFgz2+rGTmMR+N5IaTA5H1Aao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KLAN1/TA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B8K5SnMf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KLAN1/TA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B8K5SnMf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TA0vhF1094338;
	Wed, 29 Jul 2026 10:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HEc0XDjmOgGRp0q4YAGJ/QmFEKAAIJsk3LjPGI/urTA=; b=
	KLAN1/TAZtDPj1TLlkPJE5SPslX8rZz/Mr6vMWfUh2dFagzroqHxUfABPt6uM4Ri
	wxeLyIH4tHMBDj1tuebeuNJWfms0UW9nxk7stjnNxk3DfjsQOKLViWBXypRLLADF
	2vBjR01a1UhnDo2QQZNymkUn15qp70QPWjZqE2B/ZfPwlKFAIx3+9nGeIsAOkRuw
	Gr0Oz6xcJLxwqTVlP77euDj9J94dzD8ivEETrnR/Bu9U2WK6H0YdIvnqRfxh9K6t
	8KNUIMijv44QICFalDqYxXndVo4UsHERAnMcFUcqcJfOLy73UmrIlBE1pzzOAj4Z
	+lkhdt2CJ14xWyWBc68PFQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5k5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo5t6039998;
	Wed, 29 Jul 2026 10:51:49 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010048.outbound.protection.outlook.com [52.101.85.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrk3k-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zz6xzXgoJKeSFTnH9RpnRrIy+mR4CUuGLkyElhbPbMa4juNcazV/ibmKjwhAOYECnneCRf4DQJIjKWyu5/Ug8T7ZSNK6TkaQHGTKqdljyOf4m85XQVQ5Enuroj4ep06BTCPr/WzBmCQKhvyLAAgYYUIXHFwcRy9wtfu8o1Xw8E6QefY6C/xepjOxD5AG+Yp7qN0fQwlCPX40OBVXVVCsu6kv9p9b98eLfRqswYVqTWqlwxaPQJ1TgXxxxXK49PL1wRYu3QDlipqhrLdBPk3PdxI0uhbUAqFxfwXimbJG++d+UlDcNk2Lfoi6mdkWbw3y/1cnQFqbAfYjwqgRKZEnhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEc0XDjmOgGRp0q4YAGJ/QmFEKAAIJsk3LjPGI/urTA=;
 b=p45dvkdAwWoAt8Ts68/dhZn+7Ga4zPiY2M3XdLGuaT9AH/2xCPvsLaVPTWcp6X2qCXCJzYFBZO9ACs5xyjwXStNobO9OWDYdLjHzg13lHqVm51hh2ZOkIhwx7wUTemSw7WnGqHGXcP76V4FMK5QyV0VmNFJI9j1IUPcysxoYnOBXpa8SoJ+d8r/uvSZBs6u5jiGmcs4vwI9YqI8+g75/U3rqHjnEmRgJdprPGgEl7o02eroVTSZCRC7HL7CFsb83ygkS9WNEXXQvr77OgyRLhfHPLtqegotiajZzBsuaEjg8G0HhZ62JH/IXrNZT2kkod7DviFehweDtxOJBuz5izg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEc0XDjmOgGRp0q4YAGJ/QmFEKAAIJsk3LjPGI/urTA=;
 b=B8K5SnMfJPrWtg2OHVFef6KlELOs6FnEwAPwZIB+1opyA5Z/wM77Gj8ECZKpxbu6JjSBfVrFWZdNc9QdmSFnB9c12S3+6uoQsE7BZ8awWpmR145yDdCFHBZx/TKS0kSlNTuRM/5CiiCOoH3FyWEV8Q+ar/vgFec5rCWkf/vGma4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:45 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 06/27] libmultipath: Add delayed removal support
Date: Wed, 29 Jul 2026 10:50:46 +0000
Message-ID: <20260729105107.255712-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:25b::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a4d2180-1d91-46bf-6d05-08deed5f6169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	161zfXiQsvTRYzmwLjPRdf9++L6x/u/u3nU1mVZ9GM+bNLBHeGJ/zB58abGGTVy7rcK6kubJxp+BgGWeWkVrEv/y2ccYmWFNqav7prj2uA38Zf58wWLXji0VUwJRFGS4eBqPt9D5zGvKss9QYZz7MT+lB0FuBWJSqyPYdgOx2odY6wtazhQ53uJ3rIh18KXvkpxpKOaPz04F71N7S8UmGXLU3GWXlKXCx14mihQhtt1ik0JK4gC0U+UPlr/0TLQZHgLUjPoGw28GsxH96pHlhaQSCa3leX25arbqIRIMBOKlvVwaVRAiPpHMaDcbbmbfWXPYPEtczZJfwVYknfQ7GX4D0ELAeYsI9HPQ1SnJVdQhBtIaxfQf7OlU5tK3mhPUnRLkiNDncYJtFUwJfu4nauyCNYPTbZbE6K8BCZQjJmoeTAnaU2lTTR6jnlRqL0JoUHd4tnxzoD3hTNepTAlFp6ZaUcLUXn6G/OaAr4Kj17TVInKnW4deyEpCCkodMpUU2y9V4xiCRDmDUpvi1cF5GzwYPgmBfL8q08tG7TsxJGvy329r+CM8uey9R7FgVx++fhqL9ermMNrr5Bwn6JtecWMHQBbm6gt/ZKorAUVZbkR89tXGFyorkJ40yd0lzLh/UiNEPqNXDUGGa2AOOzgvIwFJO2uGdnPplEaPU3gI0VM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gG696RPZolE7j+6wWClKLdqF8UVL7QfM+fvG0yopn61jdPKXqVFbeh+wKN+6?=
 =?us-ascii?Q?+xV+mTBrDzx6nCfewOKgR9/5ymdtYNu7hAI5uJ7cj3rB4nUrSAnlC7xcus7U?=
 =?us-ascii?Q?UtyZvUvMUU0NdvwEJx7FpYMjguAz2eVBD6oNROCUmOTbz+xwuViLxEswAEW6?=
 =?us-ascii?Q?264MBObk84hbZUloyT05BO93JHMeL/G2LqjoT1889ZsHEymf7t9V6NYQ5k5o?=
 =?us-ascii?Q?DUVAgt0g/acE4z8yBiBsQaESobVCkh3RbIRYMc1RxbbfzC2zMvA5U7alOIKe?=
 =?us-ascii?Q?s4SdLmEpyoFfdwAsHW1qaNEuzhnFJ/ivPb2on0rbqD86FqIg96d4F6Rrc4fG?=
 =?us-ascii?Q?vBik7jiiCWGj0GaQkju/ICbGENgt8/amMFLwmuE1z2L2LFepCLU81w5G4VTJ?=
 =?us-ascii?Q?7W9n9jXL5UdDjwDspzO9+NeIw3C5NuvTF//W+OgowzSA7kTJq0tf4/zfvrzo?=
 =?us-ascii?Q?Sa9uk9Rp/UqvnzOPgBytjThhQRDgCcj5LKbLABTzM6Vd8zAl2Y3bCnO70KNN?=
 =?us-ascii?Q?zcGjX/f7zG95ioZD/QgefgVL9c2R0+S3OxqsAHs4pURwSgFTXjMw8wcfmuHF?=
 =?us-ascii?Q?rtUUQNGUbz2sthhB4JOmuLJ/OEupf1A5gHySZ5RP69UHk2F/Rgz64ZwL0BRH?=
 =?us-ascii?Q?wX3Pm0Pc9kEmJ9ngheTBdrKFV3a8Z0QXK1txaOxqVGNaGa9DjyVSKd9I9iqz?=
 =?us-ascii?Q?+tQ1jhZaVrOwNm9Lfh/Yq+juC6CShkpIcLe34yNat851iDs/ZEF4VTxv67BI?=
 =?us-ascii?Q?nh1tnz7gPVdQBgjqX0G8Uz7XnTWocm3oipwCNuIEa5cKMQoybN0NXfSIaayI?=
 =?us-ascii?Q?mC9kinkoAeYxwn4WNZlqPBrfqvsLQsDxrMXYnwiRl6WY0FMM5peqQUi566TJ?=
 =?us-ascii?Q?tU7eYqJ6wBEFxvGHiPTMme8EA5DXcZNog2WPHP9uMZ+bgceeOxDVddGdyqtt?=
 =?us-ascii?Q?0A400RdPy+inQaS0cP9vtAnfRiIIfDPxT0deHX0n2FqRbYGmYT3/0SZFoW1w?=
 =?us-ascii?Q?GrW6xWQwRaC1Ojm5xg9GCSniq1KcfLwtRxFQypHWqGbVkkFbfKVQwwLTo6Bp?=
 =?us-ascii?Q?iScMAPqOmourdYuAnQsE2M3MOQVfMtSbsbGe7MC/q+V8B2m2u3M44yvCpB7y?=
 =?us-ascii?Q?ZdJNMhFC5mjxNCeC3Dw0EXeE6WRdCeZGxBbmHpkZ0WwXn+3FFXFAllKGGY8n?=
 =?us-ascii?Q?COMbmQTnIU8I1Fv8i586HrpvXXTvcoiGjo9CBodnHc9ZwBs4LbnLhUMKu046?=
 =?us-ascii?Q?UifAcmV/hRuCACrrZdroR6vHknE8hB+MMPjOLBUO05s/L0fkbcknFUKVe6Sj?=
 =?us-ascii?Q?sH8ocx+B4wIJ83XXUbfMa2I8lZ82arcr2sax9nnm66j8sZwXFKAAMox8qc/m?=
 =?us-ascii?Q?taMzLBQd6uPYp8uahB2COINPCAsBYQdVhsfFJB72r5HqRcir3Kw1QPcsNy7A?=
 =?us-ascii?Q?2HlUCd6f1VMUk4MijyhDRw5eNOwF1r/UCYvzr2apw9lUTHqj3kdFLNFkwiPM?=
 =?us-ascii?Q?KzLuqIbJUqaOTvIhJ6wIWEQBrRwX+xOVg3nNPj5xCVwCdYcxha44i8WFyQyV?=
 =?us-ascii?Q?WpR3E315svFYUPnrqC5EzapL8eZSEaCLzqUkXihFYKkX60XPGNZOZazf7CR/?=
 =?us-ascii?Q?072FLp+66PGpV5dfqTV1+EhVsDVFEp+dBHOf64C4Ezf8cVZd94u1eNa/QNJM?=
 =?us-ascii?Q?Xle96HK6THg5hXL+QknF6Qe6Xs/aL26ks6T+9xhZocGG3+GVftvdzFC8QSlG?=
 =?us-ascii?Q?d7NuhdGz8w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	MjqbEaQtMNGheex2oLpafsxcRNcZDudXLkmqP0TonNr2kBIplRH2slscUozVq4KVWDJGMCUUxw8ayok8OA1cR9jh6E4xq/TLk1Liz6nNmXL7aR1CV4xP1DUC//xmlyGS0P2J0OFQlGG5x+kjRxx8YKHgIrRsKXLi/362A723iB+kR4x1H6awqDYQoQ0S8ByE/5YPSsyMziFE8jijKlQMkG2aj2C9uKYiGdueB3nU+O9sQY5DEE02sYr0qyZHCvLaVZ5IJymyb0FI7CD4+6LGFbGLVXHdcxvjIHFWUW4HTsY0WEc9VolalQXC8rj97vToXfgITwYnXGtZvmQPnFvPLg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TMo3kDtrWQrlN/sZ1qLh47HGDeguEwjAfzKsjy8T4uLEXwj9f8/rAzo35+hdB3hFsKI1I2zYDGFOoOP+/VN+hwFoPhwBwfBdk7GdG6GA93Kg5EMGxEC8UJxITlCIQ3TxyNnN0VK/IqwCO56Ss712Wi+QXobFjJCeXF1EDdkuiH7cBwIyQPf0c6qlSCh8Re+qSYQh/1Gx/tj5/FJQos8dSNJUQhlu0Z5kjebiac9z2jGu5BeW1yg+Lf6j3HxQd/iqDwhFyY67N1g92bCrYhOBeOauyZ8dIFqYTMHsa4MszF+hTxEsVxog/Ly6mD0Ydeiew9ibrfoJ8mNcTg/S6C8uxrwA5oE05VMnN4AbXsmF6gYfY6JhigOHDd3cg1BdxW80Ijxn8eh0ER1m+RtiOPWXBh2KXOrwTViMKgQ+T+GwzXEQEINyNXlrJxRBKAk9j0gUizxV8eCznd8M4oHklp3Uor7MRUVgzhCKwP/TKyKG8Mr98CjTHn+H+qH9n9rvPFCXzS4zWEvjf1Fs594T56eoz2u1bjJFLoCXb7bi6FsBeidU2SBEYhuWGCrzTO9/rd+6lFrRpFUGfEVKXCk2yI3EYeX8azVBkM5PTYZhS7v0vyI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4d2180-1d91-46bf-6d05-08deed5f6169
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:44.8488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ec8RxiI1BNDxOKnZNKiNiSS1/pIN8vRwO3144cJfaPRsjOEjICNQGzMut8cA3lXfhdUXdSqYXBJ+cZv9zNYHnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX5MJ2qFg6Phhj
 Om3q7aqkIdmX8LUYCVTmELoLAYtvhtrhnnf5zrM8wk/YXguSCNMQ8BwsiX/12PdYUSZ2zY3o3tu
 gBbdoyaLnndw/qVXmypQchK4hJUx7yERiaj/f/Zif3fnZScbNJx3
X-Proofpoint-ORIG-GUID: TLAGEUNEzztY7qcH25j6n9iReY_BjUg8
X-Proofpoint-GUID: TLAGEUNEzztY7qcH25j6n9iReY_BjUg8
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69db46 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=BfxcaXdt0Lgmg1IeN-8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX+IqQGg1oo8z1
 wFU5+GeskliogcxqF/rlWrN+ER2qXHHwWwNgdpBeFgOgaHl3UXtzSJjDLOPIj9VnRRVH1+tEWwU
 CccSR8LdAu8s7xM6PBzX0xEK5zq6gsov8srBVO71kGsqDpNS1lB2CVYYHGIUUIWZ0JqxBYv/Ul0
 bQG1rA01ly2uA/BRC+QgK526PXDa7xFNJkxCAF+FIw+wlnpOQ2nMj0INdUbWvW22Ek9iX09lXZ0
 7WSxOmr5KfmxdzLBQ0GF3sBCvrhSiKOCY/pMETtXLazmleYlqWzk8oM81qhBIcfVcEqYQ/OEoyr
 /IJWjeH4Y9nM/MNHSGKH93w5Z67OXAnymJqnnEvgzit9XbAF+JhTn51bTmZkZl6Y8Jsh4dxx3Qi
 nE19AQ723Ss7UVLY+ypF+2+13fE1OsPeEC/f4IvW0yMIwymhO7LaDQrJK0orE00OU8SFLIsHYNl
 1XzuwcMLl6tQ2p4Z7Dg==

From: John Garry <john.garry@linux.dev>

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 18 ++++++++
 lib/multipath.c           | 91 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 033ee8d54bbe9..66b6ad9c2219a 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -34,6 +34,7 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
+	void (*remove_head)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	struct bio *(*clone_bio)(struct bio *);
@@ -41,6 +42,7 @@ struct mpath_head_template {
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
+#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -58,6 +60,10 @@ struct mpath_head {
 	atomic_long_t		requeue_no_usable_path_cnt;
 	atomic_long_t		fail_no_avail_path_cnt;
 
+	struct delayed_work	remove_work;
+	unsigned int		delayed_removal_secs;
+	struct module		*drv_module;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -111,6 +117,11 @@ void mpath_remove_disk(struct mpath_head *mpath_head);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
+bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+			char *buf);
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count);
 
 static inline bool is_mpath_disk(struct gendisk *disk)
 {
@@ -126,6 +137,13 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
+{
+	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
+		return true;
+	return false;
+}
+
 static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
 {
 	kblockd_schedule_work(&mpath_head->requeue_work);
diff --git a/lib/multipath.c b/lib/multipath.c
index 6b8f6e846987a..fada92bf9754c 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -66,6 +66,9 @@ int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
 
+	if (cancel_delayed_work(&mpath_head->remove_work))
+		module_put(mpath_head->drv_module);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
@@ -339,7 +342,16 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
 			return true;
 	}
 
-	return false;
+	/*
+	 * If "mpath_head->delayed_removal_secs" is set (i.e., non-zero), do
+	 * not immediately fail I/O. Instead, requeue the I/O for the configured
+	 * duration, anticipating that if there's a transient link failure then
+	 * it may recover within this time window. This parameter is exported to
+	 * userspace via sysfs, and its default value is zero. It is internally
+	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
+	 * non-zero, this flag is set to true. When zero, the flag is cleared.
+	 */
+	return mpath_head_queue_if_no_path(mpath_head);
 }
 
 static void mpath_bdev_submit_bio(struct bio *bio)
@@ -481,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *work)
 	}
 }
 
+bool mpath_can_remove_head(struct mpath_head *mpath_head)
+{
+	unsigned long delay;
+	bool remove = false;
+
+	mutex_lock(&mpath_head->lock);
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (mpath_head_queue_if_no_path(mpath_head) &&
+	    !check_mul_overflow(mpath_head->delayed_removal_secs, HZ, &delay) &&
+	    try_module_get(mpath_head->drv_module)) {
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);
+	} else {
+		remove = true;
+	}
+
+	mutex_unlock(&mpath_head->lock);
+	return remove;
+}
+EXPORT_SYMBOL_GPL(mpath_can_remove_head);
+
+static void mpath_remove_head_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
+			struct mpath_head, remove_work);
+	struct module *drv_module = mpath_head->drv_module;
+
+	mpath_head->mpdt->remove_head(mpath_head);
+	module_put(drv_module);
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
@@ -529,6 +574,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	mpath_head->disk->private_data = mpath_head;
 	mpath_head->disk->fops = &mpath_ops;
 
+	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
+	mpath_head->delayed_removal_secs = 0;
+
 	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
 
 	return 0;
@@ -572,6 +620,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+					char *buf)
+{
+	int ret;
+
+	mutex_lock(&mpath_head->lock);
+	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
+	mutex_unlock(&mpath_head->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
+
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count)
+{
+	unsigned int sec;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 0, &sec);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mpath_head->lock);
+	mpath_head->delayed_removal_secs = sec;
+	if (sec)
+		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	else
+		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	mutex_unlock(&mpath_head->lock);
+
+	/*
+	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
+	 * by its reader.
+	 */
+	mpath_synchronize(mpath_head);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
+
 void mpath_add_sysfs_link(struct mpath_head *mpath_head)
 {
 	struct device *target;
-- 
2.43.7

