Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E34718E1F;
	Sun, 31 Aug 2025 01:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756604296; cv=fail; b=I/Eo+rvh8pjbzXwXUtFsmmx56BTyO/b/jHJiFBPs6U53nfpc5S+FEjnvR6s/99O9gEqekx3R1Voh92gzLAkIRDI9w6u99QsPjUfUp0DuXdMiJWZkU6jfkyH8X5KZR5isuKsQObf8HkqqTQwfNIwmMyPTbzrIH36wjqcby1ZZrnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756604296; c=relaxed/simple;
	bh=/+06IThqdlg9OrU/QACFjV5Q24qGZmS91m7BmdwRfk0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rVj/iLld8llQP1xwhbgp/E6J8PQo1kGV+MMz+p9//GJraOj+y1L5FL2mUvoaXOZuDQJ+sXPtj9msmaTwa+r8XLo39Wz8t88pXA8YXXXGYy3Wvop/N06I8pQohlZ2NY7hCkpChkbhfaPrnJ0EXM9iYhfSPG05cKoSRb+DfgQSzGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V1rPQ6Ln; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Mh7PVDj9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V1rPQ6Ln";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Mh7PVDj9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1Twn3027029;
	Sun, 31 Aug 2025 01:38:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6UdGROcfWpee50Yjjr
	Japr2wDpTcu9WdabsVuyTSHGo=; b=V1rPQ6LnzzZbKwxRtyVJlu4q8ixNgt0a+6
	M7j7ALNIfBB9aSF6+S0oTiXcGSrSjEWDwGCngjRO7bP6kVeSav6eOkFUN7MDQVGv
	dxZrL96UKKQLxxnk0ivnzZ87Z+N2HSc1gSsTOALypxgvZ0PjymJfpp6GHe6yMqZj
	dUR7PmtLEApR+SJgBdfzuvMhSyzxzD/SufeCWartfBVL/vVmXC3QqoOEC+jRmCpa
	P5rOj2mQ0mFWW9fuSzW8P6ku2gaH1CQz3QwDURRjS8QkGzP+onCLoG7ZXzZtHayM
	zLqyIyNB/z0K0fDcXao1ihwACHdKl5TCNoJIsh4tTYshcYU4Iegg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmb8ks4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:38:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UJ59B3024892;
	Sun, 31 Aug 2025 01:38:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr6snnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:38:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SDpH7FwxJaVphrWcbJ2JranS6ACGQcU7WSEqz57H/tFOfTn35wGKv44UmTGRqq/XwtsU3nwWS2bZTYiELQ4HYiPVYkINB6P7/pQY3/HB5yKEyju3Ny+l6ZKRYAUbhXu+AguX2VO0I/lwbuqabQybj50KNLLSv8IIQsz7h8+e4w3osHMYYIRyxdQ4JLoLqMx3PSYVpGm8U4mbknbR3laB2r7TA9ggkF5yHBXNYcoU8RVHaV/ZOedLRMUI4Ye77eh9H06XLclyPWuVu+cePohkAekhpOO23AU6vjyHInXcBfhs6vhF9Y3IIBbW5vtez1H9CZizVy61i5OYWjaRdI8zWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UdGROcfWpee50YjjrJapr2wDpTcu9WdabsVuyTSHGo=;
 b=MHIk1/qwRrf4ZO5VfqmvwEXsidOeC/pgXbxvKj9mT1gjhdi8CgAnUWzfwjTebHqY/q7aAqJVAULBMBqadnAuMBPfTKKUrfShZ8KYAKm7Bf1hKLFWR7nM2naPC3Qw5r3FKwSzI2vfQswQdDpUDKcfvq2ESb4rBF96SbrbJMvCVJLMAeKio7yn/qxjvskBGChO+euqEzuu6pTtn2tSsm0+tKqBvoaweMlZCI+uY1UnFr9jVxbbpn9Es+2Byzy6kX8H8cbpeZBe3zPd3xm8W2dkmrxLlLajhg0/lFLOe75Fh0i6VaS+k1rbfNDqnFvWD3XEJt/UGHQiOQV+MQZnHvxs9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UdGROcfWpee50YjjrJapr2wDpTcu9WdabsVuyTSHGo=;
 b=Mh7PVDj9Vb3j6koHiFGyAOhOA/aiEucTwD7pxav0f33xbbWHQ3yQBYMtNyNcU4iSqTfMJ7rYEL3S2Emg8J4U2fct4JRgtxeNRzWv+SovZtOEYwjqLFXDXlOUxAqr4+Lbr/JGCaERb7OHgywg5jSj7PngSmiGeD1jDVGuu+s1qwg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF415C917DC.namprd10.prod.outlook.com (2603:10b6:f:fc00::d19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Sun, 31 Aug
 2025 01:38:09 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 01:38:09 +0000
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: Use int instead of u32 to store error codes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250826093242.230344-1-rongqianfeng@vivo.com> (Qianfeng Rong's
	message of "Tue, 26 Aug 2025 17:32:42 +0800")
Organization: Oracle Corporation
Message-ID: <yq18qj0feyz.fsf@ca-mkp.ca.oracle.com>
References: <20250826093242.230344-1-rongqianfeng@vivo.com>
Date: Sat, 30 Aug 2025 21:38:07 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0131.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF415C917DC:EE_
X-MS-Office365-Filtering-Correlation-Id: e8907210-2744-4763-c495-08dde82f0a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YtC21McYH+5b+soF4x8EXMh2e8FL6Gz/EIiFKu+vMir8S7ztGXxGFwErIFwB?=
 =?us-ascii?Q?UNq+eJBr836Ze+/3Hvo41GY6MzhjPiPCktnTUpN0fwv8nkJxth0TpBBG2iM5?=
 =?us-ascii?Q?OElxR85N/jr4Glp1njmo5VjyKnyr0h6QsP5n1cZ7qc1jogVtuBT4MTvfxX0L?=
 =?us-ascii?Q?1Hw/SboZ/zANviAHpJaLx2Bc8nkmIO1UBM6Ef235KDUGlWkyPET8H0JEJKRi?=
 =?us-ascii?Q?PHPf054ZnAXsv0Vol/XvsMTUikWRwvE/IaI84YA8l3wP+J1vOl601JmB8ADh?=
 =?us-ascii?Q?h6h9O51kYe1bQ54A9RBTLQkxvTwctHuIq6NEwYEyAKNPPnyCfrzE+QgsmDo7?=
 =?us-ascii?Q?z/VvgetzYL5weahek4oNWElFdb78V46M4ibWavq3n3fKnHDOqtT+BFOsX0ug?=
 =?us-ascii?Q?zTku5fX8B00yV0drfX5mNBcfobAiMFftKYyUYhUalvFwZ+B2lrU6zADXf9jP?=
 =?us-ascii?Q?snqKjS+ze6NwOiGW0fdjpYGBnZPInADJPcNrYQGxbDsDlw/UyoqKCLpGhc6n?=
 =?us-ascii?Q?ddAXnUTu4RyeTPG+xfPA21NUCvHzHSRRcdVOQXIrbpTNzbAGDYEiensh4r+S?=
 =?us-ascii?Q?qOuMgIVAPYjF1CxgMkjwqNXEBDlmNfnxl06szIoQWdm3gDAoTvYGucuBd17J?=
 =?us-ascii?Q?4TzwyNvmZEquRzu4yKHqPQdMU37bDngt7JhXMOuzXEPCB4jRj0rt3kMhx89e?=
 =?us-ascii?Q?sW6YGWUKckoiCvbhK6XxZXoxlskV26ujmTu4gvOwqKTdDRTN2Og3ECU3SfC8?=
 =?us-ascii?Q?QMIYck+MkFeQ2vK0seMKNvUUbbXy4VD2wXvJcnSOFc6aTBLypcGGmaSofBGS?=
 =?us-ascii?Q?cZbVYjnK0DmHaGmVpK9ml1R0nfJlnboc5Gezq1jMKtART1s23Hh/+/V12LBk?=
 =?us-ascii?Q?uNYumGZHdq0X7Co0JkxcJ6q8VAloCKpfXdFbY+XsVgZs9r6r6ZNgdcLRtAaJ?=
 =?us-ascii?Q?cNT8bxXusW0/whHarDmRIgEpqqEBJ9aNBHxv5RIz0+2O1trmBPzz3tD/yp+P?=
 =?us-ascii?Q?kc4Umso9RDPcNOtb8oqnEBFpy9UT+EgPS8aGx5av2Is3T5i2cgTFLoiuF/hs?=
 =?us-ascii?Q?BoPj9OS1isDMucYRleSG+gd6bMOqs0oynlHK8kNkhu3Fk75x8/qIZPP2adBR?=
 =?us-ascii?Q?RKJpi0QwvrE+8hMtm2WQlQdmCsPBj7Wmg3ecR0pDsZOsxUb6bg65saitTQ2W?=
 =?us-ascii?Q?qWNK8hcW11TZcK7Coh6Jf9zFg/Takb0NT0RT4Z75sGzGx6RXbRgE0GFXoOJX?=
 =?us-ascii?Q?zbgu8AoohJY6kg/+vtdDVAa2jYiJADvqr+3Dcuj7/H43PbV0/ixGiI+NIguB?=
 =?us-ascii?Q?NWKsJVV+ArFj8sAbuI0dUWNPFCreRuei6WVF1q4DnXnOO3olYTUbSC9niuy3?=
 =?us-ascii?Q?eV856R0lCOHoCIrvoy/3wa4iDihSdWfWqWHckxZCC/tLwUXxqQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jFUrE3w9g8lGsy5tTk/T03TfLg354CPSKuSEEi85K5Paf6bBbv6WCWah3gab?=
 =?us-ascii?Q?NrqL2GGTEuSk4OOioY27GnhWQjPmJrwulTgn7FtNqrFXdCzZgdmm6ANaswbX?=
 =?us-ascii?Q?sBvp6R9xsSrUFHJ0bYcuzxrA434PL0mdIQbOsGDrtSkT32juGBxzxX43UnMr?=
 =?us-ascii?Q?ri94b2lKXoFk0Ef/0QisugO1uQ5YDFI/VuYwaX8Av6BrMGbruguwjM+yecXT?=
 =?us-ascii?Q?nEe2Nkrcu5ICbvUNSEXt7IARo+ieJVvd8t2tfqcwiXgRC+6ch+4jbKxCtXZT?=
 =?us-ascii?Q?Bx0GLNHrQW8AcvJczQDNuWIoe5Wkta7mq8cpF8MIsslhpwTtfaxKGTwyHyu3?=
 =?us-ascii?Q?eZXOWSGIGN4KPAhLFesu5myuUpKX3YWKo5/Omw+k3cOFJT8DRrpGVAOhPG7j?=
 =?us-ascii?Q?s/vNV8GGWxQoaz3x95U+3uu157uTEDd/qkWL2E35Obe5YVZfxTB/kRXCSCuH?=
 =?us-ascii?Q?Bgr8dzXl23f/TeGccJElCWdpp21y9CH5oYNPsjLkzUDpCbOr8KHdRUzHMv9N?=
 =?us-ascii?Q?GxFy6EU2vwva6ycu4hmFAEShFj/EYIlYTw/r1pIX94HOB2H5dKGpww1nURww?=
 =?us-ascii?Q?jWa3MrSobF5RGWy1mpPpJHwxaJzHdWfWaxHvXWobca8CxQXCjJMrsY0bEeeD?=
 =?us-ascii?Q?j/QUpyPE1gKjGDsrM3iOK7+4LEEqHqz6P+UcblWdUyRd96l+/kVcfDTqcBMQ?=
 =?us-ascii?Q?syG/GrOzYWIc/cvYpgwLiOLJlKe0tKl1cRMmvFiS4rxr6LSkj0SV+gAqvTA9?=
 =?us-ascii?Q?QX7RSCDg/4RkuAaPZ9S4/JHPFhRbf04qx7dtyBT/kBxRfPHR6x5hbfPOquZW?=
 =?us-ascii?Q?A6OZv699ImE9Ch67lg+KxVklfD6kg/NycwBbpdemcNXloBeuMdge7PLJIVxK?=
 =?us-ascii?Q?WybuDHQxL2Yq15QVD/0RmVladalO10K+fR8x5ngi3dkrMMjWaew/0ud1gunt?=
 =?us-ascii?Q?rWZW0uhqyZDxqbnm4UXOaWpQBcGyDRXnFUNUFweEd7R6CogFlDWwZkrY/M/+?=
 =?us-ascii?Q?iNEcU/OU9vOlJ9sY9YzXJMariMylsrlcnZ7CtxfbwY9DalIkc9d7IaVVHn73?=
 =?us-ascii?Q?2CsTaLZrYPh/UUyIjvMUbzEfVl5ErlYVw5ADaTXOSYswsl8C7aJnSw0I4PEf?=
 =?us-ascii?Q?U2dMfvMfaXRxufM63TsHAs6Vvf2vGEewHoPwPn4pVydWEGeGGdOfUTNxpNSm?=
 =?us-ascii?Q?NvA8xCGowHOhS3DpTd9kNVaRjoajS44+Dj+vFT/TAY4zTq/Pvi8nS9pFDpsP?=
 =?us-ascii?Q?mpqte9Q4jmQRm3r33Gh8acAGf0LNgsAuh6QHJNVoQxLdh/rIqfe94HSQcDp/?=
 =?us-ascii?Q?j1v2Jh4MQ4EFq+EG0soGSDXGJCjlbiq06CFSQge5OsWoF2hbJ3ztaAhzBN+p?=
 =?us-ascii?Q?haHg6ztHRLgsiZMaSM11WJCHcKXMMKi+x6rA80uRGfRj9qtt+62VjJLqfDZX?=
 =?us-ascii?Q?TePmRZYVlJS2+tFscDSGD/xBzV81bZe4Q0qs0SmBvAcJoh0U9o7tysYZLBPb?=
 =?us-ascii?Q?V3dvfPgP8C//cUSOnStvexA0cQ2mrbi/eI+CW1+niTeTQw/NNghLb7C5OZY6?=
 =?us-ascii?Q?w5ydMaSjtqGHOZTyApeO4PJIMfr4Sy4smwKQxgZQ0WQdQ5AbJX81fvjfVwX2?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8RCBAp/aaNO2rb+z0KY3qMq+PA6bqG5dd1HkZoxRNNnFFcJX02Fc0c+f/DHE6oi/4qgwI6pl8S1oV5r1T+oE867o1CM62RuLSEI426EynCoWClfqWyEk5UGWu9QniyKe+JRIB/ZUwlz1ttUFZQY2P633cVOSgh34X/pGdN6dyQmVfk5VxSqs2lo376GRPFzVQdsHGZezqKCproogMl5TS83Oqrt/MQjl9BVPrfEthjdLBWSZL6HEbENPiZzABnqvUmM7OyJjM5Cq+LUydqKgPazwVcAPgpcbl1VI76F2qc+KAsfAzmBCrEU4b8s/6FhSlWikmR2Wv+8lv5IIbNzq2lzJj8ZnRcyVxZuLq1OWQqznhNjFCAsNxjDc8LEaRd4Dt3I3DmGttfnyqTgEVkUF+I8Z4vryT6G12pApdiR5DmGeZxQ8/QWPkRLgS3MPHFFUuy9aHG2IP3JGNa+1rSFWP7fljhz3+zm/RrKC22Z4T+A1R0JeGsFFQAth1spTjByOtMXP5mDcI/98D5wr896UocI6/fnVsTN4+zgMbCWbaFDrceLwu3dLcUxkbwsJXQf1FRSmTYufaxzm/N2ERzXlml3iCJLRPrViTzZ0dN8MIxo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8907210-2744-4763-c495-08dde82f0a77
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:38:09.4858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7QRpg6FUPwC3DdeQAiwsixDyNR+JIhKcGJks/upEZR5GOMEZcwcNOomXPVXnkcw03UxYDx0g0hJG33xIl1MXeu43O04LbxYxY14m5rEEdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF415C917DC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=947 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508310015
X-Proofpoint-ORIG-GUID: 2r7wpn7NHAcVfl9sCCgQqT5K0dTCBfBB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX6gLYCTM6kYFo
 4FxRPU8ZPry7XNGz0Ai2dIcNdKZ3ZXhiklEm3PGwAMTuil9SdQTff91yXrR+LQ+oMUyLyeSTBeg
 XkKE5Xl2gYT2vx43yRWvTcszcsmgpaexmnWc5Gnl62t7WTnnaq1x0TfKSR1LXy2oUTHLIBTnBcu
 D9Wmd7zi2+41lEhXiZb0W/EBfArQACZ2Zs/1YJhgSmOaKfqrH4sPH+9wTxj2y1r8OLh/2nJuDHF
 +Rh1BOJBTbxswRFU7uVaWCI/G2/+zOA2PLFNdv/RQOROMTQDcZtovECA/1u72gN8gvk7SkFbqdc
 lR1nPwIadMu3SALjTDUVy53wWJZbH61k1uxCB9l3OFBoGCQfJYnB9AaeCXzgBJK0geXjgfrTtEz
 7MQiWCcn
X-Authority-Analysis: v=2.4 cv=KORaDEFo c=1 sm=1 tr=0 ts=68b3a785 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-GUID: 2r7wpn7NHAcVfl9sCCgQqT5K0dTCBfBB


Qianfeng,

> Use int instead of u32 for 'ret' variable to store negative error codes
> returned by PM8001_CHIP_DISP->set_nvmd_req().

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
