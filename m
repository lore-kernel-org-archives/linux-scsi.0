Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32BB42A7BB;
	Thu, 23 Jul 2026 09:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799442; cv=fail; b=Fb2R/20Xfk3RjVltTXgVSivdzVlpMq9UihOBY5LZ5+AL1xps8mivP1vGpCxPNpJgcxXBwLyjLuO0N0M/+PmxevMOnegz40HXXQvb1WYaucCM4+i93QmSpnCxgyo+vw0iXbItTu59qFHS/vEz4slnSgzs/2cRsFZ43EQWVSESH78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799442; c=relaxed/simple;
	bh=r3Nxf6gsA9LexIjLLAn1b4FG0bDpxXQzl5ekE53YTaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oqmIwtaklhx8nWSBrV/xlhb/Zk7YkLfuJKbyMCo1ATkbGfN7XFFo1fMavFFuFQEDr+m9mVEFvZyBX0jq1orA7veITwQSYUev6iGvgZQlESdcuBoj8Rbiq79H+IxsUKoC5MEjiVFyiokiIiJSzgPhIblfr7HdyuyQYMLcYeNjLao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hl5yFDQL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RwuuXy4X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hl5yFDQL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RwuuXy4X"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N0EfTN3817379;
	Thu, 23 Jul 2026 09:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6GgPaKhcQPSVQyzazNduRj+lv5C9sJGgmpbRHdwSUwY=; b=
	Hl5yFDQLLVQGx3IzkwZyWMZZw5NaTXuLOP/oO6W6WLWzwBmL1XNt/YB6KkU4ohxv
	AILf13XFyEeTvNVzEbjxwE3QAkYteii9M4UeFFKUsz5H3ef8ei7KCVhk1IfmDJk5
	t0+j2ZLX2sL+wnH6hvNUN0q/4Fb9uaEn2dEEFbZICxj4DY1zXkg4ZO6Ot2bhWELj
	K2QDzsoQYmmbZRBSTTg4+88j0+OVOKA7LCS0anVx6HYT+l50vT5fJWJjd5i6aIwF
	Uj0eMa0J1JcUOvaBdOwlQfWMDGd7bST6jHm09JUfS3WqoTNXznwdByzsA3L786T0
	/X5GzHFQBxdi31JRhsft9w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6nac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XVPT010588;
	Thu, 23 Jul 2026 09:37:00 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011004.outbound.protection.outlook.com [52.101.57.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxsdebf-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KgBSA2KeUPNnIju8GcTcRPkik3JICkaficTLODr9+DH1g7HRSCOxAyUomNmzuZTMYln38QhWRc+7GgX2RQ5IMakewYVm0/lNWLkabs5BEpQKak/P0Q7kl5ZK/si6xmsVINFSg1I6879EWq1hKlEWCXHe78BQwAhN3cXd+y73B15fY6Jzrn6HtMch7+T657OkhhLpCzeZu14IURJeT+ZVU4RgGaUsD2T1o01aalixXCR0kKBOdUw8y+1jP4JUF9EQUeqs76cw41Vl5MzpQ3mcxjnN0kcq5fCE7MSEn9BmAw5J4jVN8Zm92YqPWgpEkK0wcaxdIn0njcuuYZE1lx8g/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GgPaKhcQPSVQyzazNduRj+lv5C9sJGgmpbRHdwSUwY=;
 b=k31Hm5PwrPsadylhy13ogKB2fZLO8D0VSzNd18ZopBBYKnD/eIPTVCm3SFFw1Qw1/9vfepOEKa6eLuV3T/lwDG+mbICEKnRjViIlOYgELFbGwvEYBednB5k3u6GGCMZN58Ag043F99Z+KvLgcygX2oycSF/krsokoSM6ykH6A5iGrAoSc6d9lOFRxXpsGab+zNZra8lQWJT1o2aVBOoTRv6olzNUrJ9A77FjS606TkdPu7QQpNLLAk7Fg59hShJaeRrQSojwsjddEbcvtlPV8/4R+Fn0s8JwgPb5c440uTWTtjVhXS8jg9NsYdx2BxxaiWY7acyRRJ2xWhPd9OADzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GgPaKhcQPSVQyzazNduRj+lv5C9sJGgmpbRHdwSUwY=;
 b=RwuuXy4X9HM2wJ5CMw73Mw13TfIVAk4wMk28zgulhMATAOOMLF8uTZRjMbVxBBIAfCuaz/qfXJ5HgQxsiWx1m8rRHOI/BDj2zPd4ij4XJYdUIEri9PxzjQkmlOhhjbMEAC7+J9Le4yVkdPcy4ynnQz4yV2JfXjEe8Gz5J5imPHc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:36:56 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:36:56 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 05/28] libmultipath: Add support for mpath_device management
Date: Thu, 23 Jul 2026 09:36:03 +0000
Message-ID: <20260723093627.2327456-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0017.namprd16.prod.outlook.com
 (2603:10b6:610:50::27) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f7d9cd7-a583-4285-32c0-08dee89def54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	cRP6M5qi2UisjDJ1LtwmUkPpcongqzLf+2fFzMbvzNEU5/xgtUjnWH+4wdPttd3QLs+Iq8s8CCNUybCRXaf+N7UgQElFjH4U6EKG+V9fBOp3XEycm71Ll//s8IgbxwxIyHnKO0IMmb7ujhaX3UcZeeiBYg92NrDi/gLuxG0sVEZuM/aFQYlOqI0+7qemALFaZ7Ucet9LVNIXhlvjtFsuKk0z5hZ1yw/+dE4iDtFdf6xd48DzrAvcKoejNRj+fHBhyGg0kB+LwJ6VFam/WgvYYC3k+k0FrMtMdaUv8CfBmZKQ6wa8ACGgUFKov4u26bZjFi8l/FkFyb/BIpgXmSeNylid/qCXQhDYAJV2OJNwF+I2Z2ojjVwxWc/NOfgPuJ+hlKnYrjI1joWYWV+5Ti6oWDjcccc/Cs8oyJ1guFoRHIiOH7s0U2rgzg/ZAkFqsNIRDKITcWIJMj+IxOo0V6w1aF7UA5dN6CJJrAoim9tGWFaXKjnvaxtV0d5JPalHw9MsYiU0QW8I8E5J0x1I31S4/fhaKjh06uwRLnT7jE7mUly2i2hyVFs3zzSo1TkyuiafC2Tzr+Pg66IsmfREz6cN7JL+oKxylEgU+XNdmXdsPVvXuzNZFx0X234Z18l05dSE4XCF0NiVISWbBvAjvi2t7c71VAqZvYWE9NbLQwAO7Yg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ctBE7xLFMzSJLEVkqAPzWk95q3fUIfm954j7oPQi32zQ30n5GkqaK07jLlOQ?=
 =?us-ascii?Q?/EiTAbFT24ISWMpAP6cWcEpsI3K8E6jLiLbspvAku+eaAJpLVKRNDSoVahxs?=
 =?us-ascii?Q?QTWbFmQyrMPCV+ms9Rfn3auv1iz60VGTyVJY9s9bttY+n0ZyxeQQ4uDqF84s?=
 =?us-ascii?Q?fz7LCuqboVG1/lqPi4Y43mCyL9nm7VInytcaQegUPDhTXetsWEtdjYgKD7dV?=
 =?us-ascii?Q?pXz6QnmVPLg3GwvBIZutlHlQV1kiI0cRAsowGkcPrfMA4yby3VdfeVsgNgIy?=
 =?us-ascii?Q?ScYqgyNiDRi/hvRrpKHAA5EDsXwL8PSGBG3H17US6/puXrmKopCy4dTv5jsC?=
 =?us-ascii?Q?gmg0m0D0oLtYRbVJowhfdkcj8v0D1zITOFqyq2+oCtF5PPnsoOeN0w2ax4cU?=
 =?us-ascii?Q?FA0pgcyDFN7KcxWAMOzqSUV5hKzCpeOHPy4E7JXo9Jl0JxbEqq7PjErW5l0B?=
 =?us-ascii?Q?4eg93VcmH9Oza/xpT/Oi+z16IHyXRVzoZJUHqf+MNH5X3xMm8EsHNNaNh69e?=
 =?us-ascii?Q?zM4QJil0jmZzZ1iN6apC4L14vQHG7yjYXSnGzDbfBfzetRDQAJNW0oSHlTbM?=
 =?us-ascii?Q?sswEcVTft1CHaaNUwolMayQOpIbvKgRUghbtmi+zybjDIslqkpC4b05aZfsF?=
 =?us-ascii?Q?WtdP3ZNo4SghfCrT4IgjuvyXeJl+CEPAK5FjaBYr6Q9TE+YcDmJdqLKBvi21?=
 =?us-ascii?Q?kG7vuhiSMXLM3IwM0LOptqV+JZuw7RHFKBKmRcQbxtPgY7OkT5sJDcCBeqSj?=
 =?us-ascii?Q?O1Ix9NNiGviDmjL2gU8bDXqX6ZcU1tQGqzIbFPkuGpH1z8/3PP6donE3Qt2L?=
 =?us-ascii?Q?TRDvza217LfyGsH/ikBZ7ScAgZg177A6lUw9bDzc1GentzOugdatGalG2A2+?=
 =?us-ascii?Q?/6XqvYFjWmgatBn7KEo9XJGXXrQQyE/eT9apOCrEtxTYzFNHmUj5eDDa3+jM?=
 =?us-ascii?Q?Hn3Ey3pi8lC4svgZHJ1DVbTG+dQIGLBXK9pLlJLrWjngDtDIZUoM8oVml/N2?=
 =?us-ascii?Q?1Us0VH+8wsmS+fLSXGk4AFzJjqxRWeFw0D4nlB8RZQXQOnvwNX62J5MCmGW/?=
 =?us-ascii?Q?hPA/bxw041i5QM7e/7U/z9BF9+skG3ymzDf9tbmSWLP4jgN/Y6W+Hs0Iaha8?=
 =?us-ascii?Q?E8sHoAfkhAyWI22jTkHpFkucjoof7c9pUxedu/+oU3VSWr/s0aEABPIR5rG9?=
 =?us-ascii?Q?BuHi2wGxe7oM6OPSJG+la2He2d0yK1MRfXeVpXRlJkazx+S3JlKq51RX/gsm?=
 =?us-ascii?Q?CBz/NCyKB4MM+E7nD3zQV9wZ809J/3apwj9CKUz4LMWt/YI+sOq+/WgiAcJg?=
 =?us-ascii?Q?uoGYmq5yVQUTAD3IjJq5MCJB2ExDYXzJrhEwFB2QDBoNXwohdy8jN9WwCMaL?=
 =?us-ascii?Q?Iy4yZ4THJjGBBmA5fh7C8WjkaifGF5UV23lFhLVoc/p6qzII/uCM458rotOh?=
 =?us-ascii?Q?7B1IkHjZTaKPiHfdZQKEAkPZ6THzOMak7XcC9D/iWiZRxwzBQfqoEllG85aI?=
 =?us-ascii?Q?CbCW4/Dv9StuJs+tntd4xcm9tMZfetixXv3lIBe7+jE7WOoq9JeQi2cNezYC?=
 =?us-ascii?Q?WwCV9rRNQw9zOonzUBQHBBu4KoE49nkwHCxCh5i1F2qRR4n4BaFYgoy8RmqG?=
 =?us-ascii?Q?OuNRTokrsf81nSRkHkA+3K4xvcGHiUMYFa7yDk8Yo4tdPd8PJuDwnkHiRQe1?=
 =?us-ascii?Q?bwgMaST5rMP4LOb/YRTCm+WNhe+BGLfO/z7AV10j+CaAb1BhMh5C/IqDmelV?=
 =?us-ascii?Q?CDWLLJDNeQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	cGRj1i/cYK3ZSaeiQ+uLyjGDdJtz07gs4HtfBnASXump59r30g2uJHCfZeGebl14adQ/O30Duq32K7K+YMEBR3eVwlA2fxqVVme95aF4JUomlnnTWZJ0HOhFRdYxurinO49R3XxahaTFQdv0hFujvmDoPv0LDNANBxhhwDW7MIu4Buh6a1fFcZwGb6xO2x0JImvL42IO/SeKRwgADz4SvVmq2nlhAejcvZ3u6GMoPehLZz4iVQjgyLoW34IPzYuP4QgrC+orh/3JPmwwtN0yeYdBVlPEwk95QCiK1N7N+qAiUVMhyANGjeNL+I7BjyMeWcyb2Z7+wcQhKahBJT/Xvw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VJjT9vsV2R93OZ51BJFxsyaNsor72+JcpBTjRzY5V6W/QjH4H6roGtXBtywGFoJtK+uzDq9SR0KHkOL5RyUKBa/kwsvISbN2Mx1z7H4vE9buSx4IHbvJ0xSF7hH6OegJii5RuRqGOuId6ebLY6l+ooFfG3sjd+lm1rrkNChsWdADEfh/dZ0MMK6G3sZJH4RnvoLo7Awnq5ri17pW4nfBOVTNTtqdHNgbP1uBPAGVy2ejFhESQmAAILXCKw1S49/fgYlCKM+C/d6I1XYW85uUpx6gqyCbawD29x15PH4ok7V+TB0jHClB0sHnanta8YS6ptsjNlSngMCir8cve7W09qjMxJ5PVeFIZzUH3SzezFOhuyW69VBSElRzK2/ptwAV84Pq8RrhT2dhAsQtM5sXokiKhViYKdACswZcxUnFjMi/k/qJ9WOSbSNJ5DHS+xaj+iMnd+3LL1X5uBM1byv4lUN1U/HnxUzMBTymYrCl6LAlBZH2lF2IbBkeRMz/cmaG5AJwmBw0Uq5nkWwTEZKd2SHedXq/nFFka0DWP0537ZaaeV1ASwC7TenJB/NgONubL6GCl6UtXAFv/eEQW05Dp9ExjX7rc+ldvg6oNHuxbAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7d9cd7-a583-4285-32c0-08dee89def54
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:36:56.0761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3FO1+Tx2HXAXH4YvyzFVnEMzNpSUh2v4J9+A3lWXZXgETcLU2mGxfR9oqgpZV5HRS9aSysMpCthKrXel56IYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-GUID: jeTC75lV145Cw8JwK42tNXws29VECpMB
X-Proofpoint-ORIG-GUID: jeTC75lV145Cw8JwK42tNXws29VECpMB
X-Authority-Analysis: v=2.4 cv=IsYutr/g c=1 sm=1 tr=0 ts=6a61e0bc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=WlZ9DiTZ2y1qVm1cHVYA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX/MEan7YCifG9
 28Fkc9ApNsJ/QSp7+mTPzd2Oxcu+Rcd5bVS/gJdMs6rM7DfLBy5kuf+IIO4CktfjOLCvRsNyVLx
 Av3Uy6WStr1A9Urwx1ybPrpFC6/EyJYv8zm1SawKhYdICdfnwZo5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX/+okhEaVKkQd
 5yYqbfylkPjTcdST/I7n88GJ7G0C9C0ZSYFr6V36nd8iJTLYZMlf9MxObR2T1jO1TEi2CwGLU2l
 P5nUFCfemYj6qnOf4rXWkYSX7z/C5pkdiA0/DrgCTt6/BZOpzWBaCluSJln/d5Dr7QlFeu/EwzX
 HPpq1VAU4RVUDA3RIr0wE695F5RkTPLM56mTX1deH7CYkV7AH/siSYKZYqectRDUsfz6vTy5ixL
 jldWHV/V988W8udfWriVWqzw7mMMgF6YM0xl3M3xE5DdRMyPQuVrIufHhJ32PBgfCutURvvWus1
 EcYWy0bj0o7KVVrbHoJWLTNzNFgYmVnFmfZADotFSGZnW0HgI5WhNBwHilyjt/4Im7l42fybEiL
 fzAQfz4/QNWdc/4a/Dy8wvcyhXCUiWgO9MZ4KUZgCbHKc3egMWH/A+XsdWwOC+Em2QbbeuCCL95
 PK7o//84Eh8iReY8+YbIgd3h63H2G6vXW0vz0T8E=

Add support to add or remove a mpath_device as a path.

NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  14 ++++
 lib/multipath.c           | 154 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 57d13eb1450cd..6915c2a979642 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -20,10 +20,13 @@ enum mpath_access_state {
 	MPATH_STATE_OTHER
 };
 
+#define MPATH_DEVICE_SYSFS_ATTR_LINK      0
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	unsigned long		flags;
 	int			numa_node;
 	atomic_t		*nr_active;
 	enum mpath_access_state access_state;
@@ -89,6 +92,17 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
 void mpath_synchronize(struct mpath_head *mpath_head);
 int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
+bool mpath_clear_current_path(struct mpath_device *mpath_device);
+void mpath_synchronize(struct mpath_head *mpath_head);
+int mpath_add_device(struct mpath_device *mpath_device,
+		struct mpath_head *mpath_head, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active);
+bool mpath_delete_device(struct mpath_device *mpath_device);
+bool mpath_head_devices_empty(struct mpath_head *mpath_head);
+void mpath_clear_paths(struct mpath_head *mpath_head);
+void mpath_revalidate_paths(struct mpath_head *mpath_head);
+void mpath_add_sysfs_link(struct mpath_head *mpath_head);
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
diff --git a/lib/multipath.c b/lib/multipath.c
index 448d879abb354..20c633ad7e1df 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -50,6 +50,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_synchronize);
 
+int mpath_add_device(struct mpath_device *mpath_device,
+		struct mpath_head *mpath_head, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active)
+{
+	if (!disk || !nr_active)
+		return -EINVAL;
+
+	mpath_device->mpath_head = mpath_head;
+	mpath_device->disk = disk;
+	mpath_device->numa_node = numa_node;
+	mpath_device->nr_active = nr_active;
+	mutex_lock(&mpath_head->lock);
+	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_add_device);
+
+bool mpath_delete_device(struct mpath_device *mpath_device)
+{
+	bool empty;
+
+	mutex_lock(&mpath_device->mpath_head->lock);
+	list_del_rcu(&mpath_device->siblings);
+	empty = list_empty(&mpath_device->mpath_head->dev_list);
+	mutex_unlock(&mpath_device->mpath_head->lock);
+
+	mpath_synchronize(mpath_device->mpath_head);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_delete_device);
+
+bool mpath_head_devices_empty(struct mpath_head *mpath_head)
+{
+	bool empty;
+
+	mutex_lock(&mpath_head->lock);
+	empty = list_empty(&mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_head_devices_empty);
+
+bool mpath_clear_current_path(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	bool changed = false;
+	int node;
+
+	for_each_node(node) {
+		if (mpath_device ==
+			rcu_access_pointer(mpath_head->current_path[node])) {
+			rcu_assign_pointer(mpath_head->current_path[node],
+				NULL);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL_GPL(mpath_clear_current_path);
+
+void mpath_clear_paths(struct mpath_head *mpath_head)
+{
+	int node;
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_head->current_path[node], NULL);
+}
+EXPORT_SYMBOL_GPL(mpath_clear_paths);
+
+void mpath_revalidate_paths(struct mpath_head *mpath_head)
+{
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+}
+EXPORT_SYMBOL_GPL(mpath_revalidate_paths);
+
 static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
 				struct mpath_device *mpath_device)
 {
@@ -468,6 +549,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
+	mpath_add_sysfs_link(mpath_head);
+
 	mutex_lock(&mpath_head->lock);
 	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
 		int node, srcu_idx;
@@ -484,6 +567,77 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+void mpath_add_sysfs_link(struct mpath_head *mpath_head)
+{
+	struct device *target;
+	struct device *source;
+	int rc, srcu_idx;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_device *mpath_device;
+
+	/*
+	 * Ensure head disk node is already added otherwise we may get invalid
+	 * kobj for head disk node
+	 */
+	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
+		return;
+
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
+			continue;
+
+		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags))
+			continue;
+
+		target = disk_to_dev(mpath_device->disk);
+		source = disk_to_dev(mpath_head->disk);
+		/*
+		 * Create sysfs link from head gendisk kobject @kobj to the
+		 * ns path gendisk kobject @target->kobj.
+		 */
+		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
+				&target->kobj, dev_name(target));
+
+		if (unlikely(rc)) {
+			dev_err(disk_to_dev(mpath_head->disk),
+					"failed to create link to %s rc=%d\n",
+					dev_name(target), rc);
+			clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags);
+		} else {
+			dev_info(source, "Created multipath sysfs link to %s\n",
+					mpath_device->disk->disk_name);
+		}
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_add_sysfs_link);
+
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
+{
+	struct device *target;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+		return;
+
+	target = disk_to_dev(mpath_device->disk);
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+
+	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
+			dev_name(target));
+
+	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+}
+EXPORT_SYMBOL_GPL(mpath_remove_sysfs_link);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
-- 
2.43.7

