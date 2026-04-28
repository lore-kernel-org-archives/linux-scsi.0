Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CD7402B82;
	Tue, 28 Apr 2026 11:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374966; cv=fail; b=d3ls4nMyZcjMUxlovo97512z3WSQudVYKb5VJdRPtX0PahGfIc88thgLo9pO0wx/k7LjMB/KVOohxJvCcQMqbBoCWMQvqlEQIDPbMr2kT7iVQB/oas4UCNon4tLoSTwecSs7wzAVcnfnmw0Bs2mQmoYi6iB4XBGAFd9t/lT7zx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374966; c=relaxed/simple;
	bh=QROtpd9r+St8A0LDqL5GvRLHisvZaYTEGW0IIBMJJ8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FNEsm1fw0fI6Brv4aT5tYG0zq8xtNbqf4AxA6FY3CSfT543OKIlxvC0on5jGPJl4wmN31MRvqXTjG1MPlNUKrhypc9DYLY1J6tFpmvd6MKF1R3GjlsQrXhSKb8O3RoXsisGyu7L+Uh7eLiJqYB03n3pJQvXCQTYNJVOYUNOCHI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m0VY/rET; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H6sAdWJ5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m0VY/rET";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H6sAdWJ5"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAYxUm1015449;
	Tue, 28 Apr 2026 11:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2MEbDpmQjjSbhQLsOm1wqnGTorydIDjgCYKf/upxO2g=; b=
	m0VY/rETXGMQpcUHUy0gKojnF+kmkM6Pui/jGPtwbJe6T1f1yTaLPRjvajeA41ut
	2p0y1QBSIZ/eDRg0+2wSge5pSNNpeFC0Bg7/j+vg/tQvd+K4W0GEvCekB85+LuRS
	jsV1CbTAgdrcaZ92GB6bPM4lIq2tYVeI395YondzR5Nh1uM+1t1p3Doqi8heuVf5
	fgvbcKWk1VyWVmRjuPo9jYTjso0Bd3LgbGGR21eRqUO5ODCUbtrccCXcjzK9yGTc
	uUjN6emFjNYDyPwGOGv2ZAUKjry9yPNEsOIcvgfKSi4Qje5xUUCtJfN9d2iRRvo3
	wctje72pmyU1xZQ9dH1DMA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yykbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCjNc004725;
	Tue, 28 Apr 2026 11:15:14 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013037.outbound.protection.outlook.com [40.93.201.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2jm5ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+Ilg19Dj9RrcheKUDAzs6qz07J2JIZo9++/Rl0WUHbXvnNOfwsNXGSTE8qlVF5jZ76wSg36nT7cRMhpQb9wTCiWxIiy1G04nwtbXlKNwU0bGkgY4NDLHgwTYPJVVjrX6677bMi2v6bmVIJO1+2lRP+d2DWscQXMhYlj7KI1UQQr1lXDPnV+WxXU3j1GZvlsA7NZisp5JIgFBdrdkVT2mltelSEw1VQjkiqk/2XndZJRQVKGnRbhnipUEZRVLNuNIWxc89qdWypuRw59EXQ+v04Gyoji2O1sXjhdrnMpDbdLSmzhqHPX0rOH2O6VAsTs2Cf6qRkP5Jil8Rsc5rlNFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MEbDpmQjjSbhQLsOm1wqnGTorydIDjgCYKf/upxO2g=;
 b=DyJ/TLNYaT4N+G6+vVcAojb+G0CW1y2JtLL7hXf8Aa5nts2KM9QDF/WHg5eGZpFPpD+IObfWpdpbOjneXSxH+jRIgC7Qow26H5y0Llj8m/4gn88CDj4Aub3/K0GOt7w2Dpmzxd5042mMFlPNg2dQp3oEaEf/XaKj7WK6WBjk3yOgOzKcbwjpfpY6lUWCBUUmGIdAHs188aXWDyyM5e38pfW3vmz1G6IYQr6o+Iu+0hYgVGi4j5ct0G7T6NZby59+OPBbEbqiA9lEiVWMxxxAmQu/MjgGxgeeS8W4KAREgzyp9Kw3SHhGZY3Z+gZCS/9REvmdnOHDvUYd+aMOH8reFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MEbDpmQjjSbhQLsOm1wqnGTorydIDjgCYKf/upxO2g=;
 b=H6sAdWJ5c/kx8MgX+J6qIyBOTfvuQfd6JcsU+p8QsVctEy5VH89CUDRVhVk+1MYLy56pv8XcUEyW4Bk8Er+q9YB36bnvUdaEuM/zv0XGRc1WGfjgXr2b8KkPePDB8EnU+oFXp6iHW4nErsNHaNbqGhvGCGWoWWotOb8S6p8ipdg=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:10 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 04/18] scsi-multipath: support iopolicy
Date: Tue, 28 Apr 2026 11:14:33 +0000
Message-ID: <20260428111447.1779062-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:610:e5::18) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 54136f1a-d4a0-4f76-6652-08dea5176915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q3d76ipx3+W0a8AcfHOsroSfdV6Ufsonr3kV6trMVYwBF3bGCKHf6qP6i1CdfspCe0mLZTwAlbITJJ455XuJdqOaII/TaGMQqRTZR1O4iRfeVDeDnovvVVuZNQ0BkrRwFQKhakWuQa3JkEu797d7hpC1RkpO4JNxMD4ezW/6etsfFsQlHJM89MBxczBC3FFYVUqHhcZBS6jd+ABc/BByl847Idlpb52/tPd8DMnqtZ3ZdAeTwCbenw4MoTx1fll7v+k14JndjzH7bFWyawo9XlhMiECkKOBbUMJWs23nS3SKtVwo2++2aEDNHqqNmIeoITljG+zzcSWk4TN1FGDdusSYXMwnj6wef041YlYUZhQsNOCg/C0tYpJeWkUbt4WGZd3FqMuKBrtbHS0gJvqEfKGEASJA7guAveNvB4A6o0UsVbujegf5eXTzRKVPHuRZU6qweR3g/qjrHk0wR+o27FVbnW3ljul/yuXzPgyRKbMluHFMi/+YAtAQPek72FaLa4DNSSIotPOFu0kQ3mENSvMpn4+ljcF3ydJBCyTgDjW89EPxTZ+l2kt+RsCSJTJHpvmVukGYwFynVLh5S2+F/OgEOtrJwuayFKoj831dGoeQheDSYNtEdKfOvxzhAvWYlB6vUj/a4YQPiPokJS16zC+3nJ7HU/ZOW99H/LAejszdtNgVDtIdzg1GnpD1CwUioapvEnK5ERlod+loxDd1OgxKTbuz4OWb853FL3a3s8s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0c8cQxgexPiSXuzbWGnHfGmmHhcb56Z/Wk2kJV5XiDBkcP9LHNmakSOaAsJ6?=
 =?us-ascii?Q?AIwtgHEpO5eALZ/Vv0DoypUM+zajQxTeVrZAK2cAEQtnu0bdToLI4jSPaLfh?=
 =?us-ascii?Q?wllwxDcYCQ6jPkGvUtL+kLcZseToqikI32Q/nzcZvVsbxaDZpADVHVLyUkK6?=
 =?us-ascii?Q?nQRM+9FXeRnYaz/AWhLWhTyO1sAL+FzuPacGi4u9QR9BqF3p7rg8rUa/3WR0?=
 =?us-ascii?Q?i0P7Si6a+Ntu9YdzRWj5ixO9vUx45L+2N9MVV7CkEnn+6FInuJ7zTxolrzPN?=
 =?us-ascii?Q?9BrA17lN+DbQmr0FV2buUBuipgdUsxbV69yzUIHIEIDBoFSmZLguWTzfu1D2?=
 =?us-ascii?Q?kX1O8d+oW7n0kV7rz3HffKSIWh1hpfvv59jZQNs20k4+eOmVhnhwaDWBkXgj?=
 =?us-ascii?Q?8QVSzpDANqx06LxMxdJoF06p67dIHde0aE7KxzyCe6evovEC2ML3AwLbEjsQ?=
 =?us-ascii?Q?gwqYpxT9TlIJL8E64MITFDRMvVuVoT1eQQPgspFCI4izXjcXJE3HuYK9B7Q6?=
 =?us-ascii?Q?s2ShXWb15JUHWQJagLgV3syPno0wYs+kmiH5W9pMoVsvGOiDvIDlYqCYYxWr?=
 =?us-ascii?Q?4kWv8+fW7PAzgcLX0T+Bgb/vr1fj3synaUfYAvA5512IUvmwh8AsLoS31PQW?=
 =?us-ascii?Q?Dy/QF40bwyTg/DTGe0zbW2KfVP53uHIH7NU0G4HukVsd0QdIT8bNcIUnjwwb?=
 =?us-ascii?Q?FTycg2a7RET+32SQKQX06Kapj5YTWyWS6fqp/hvWew7ez9S3DQkvC1KBxVPj?=
 =?us-ascii?Q?HewQ53RtrOth09r49CO0NivfYBvczue/5XrfxeaNDp26JTSSniCX0zv5XNKI?=
 =?us-ascii?Q?dDbEr/pa9DDHj8X9vJakxeMeQdbjzQJuY9Ya7huSM35ve8VQVV6ijZtAfn8a?=
 =?us-ascii?Q?ubQI874xANZWWFOuiBHq/6BJjQuyTA1Y0EjCinnKgc+BnZRVFJ8GEj69UsPW?=
 =?us-ascii?Q?Te0aRNcqDa6iUW/02XnjiNCxIhJS7KNZ4M0AogqMa1q24MjbCheuytpxehIl?=
 =?us-ascii?Q?gYklSICwRtoqPwOgGKY8CTYeROaOfWlcbolvNKcsad0BdWhHfvWvsMo7a3tf?=
 =?us-ascii?Q?TFMMIGec1Ogr0Cedrzkip2zMY9HvH1z/f+J/bXoITM+9AslVcVXq27le4XJa?=
 =?us-ascii?Q?ZWdkY+hK2a2gps8KfHhz2rmu5flhIIFvZlcGIWdpJkDUl4PfW8KWZPCEEB+t?=
 =?us-ascii?Q?7wOrwgUAMVyNrj3azTRd411bp2ctcbE87NGTpj0ykaLU8G0aRSIpRpBmziWz?=
 =?us-ascii?Q?dA/bSpGDVu6ShU7hV3rRKRp+cMZ/lOooSA6JKCtvUJVTWCCv9S/C47WXhaey?=
 =?us-ascii?Q?pnSjfPI1PGHjGt9BdKhs00wK9U/Uaw62e9BHwXkYzGyvwhqnXS+yRPtUBUkJ?=
 =?us-ascii?Q?xNDaM5ehSuChmWRUJ+GXATy91CR94rikxvsFj++XBEnm+lTXYHa4fq4tXT6n?=
 =?us-ascii?Q?+fuufUPEFxgvY0TxxaJdlSoP2rVrRKyLErP+HgKKjhLZUfgNammIO/1gwScD?=
 =?us-ascii?Q?PflQVLAgKaElGSqtf6BFT012uCTrsU+JykMSCPJrHzfYOapRdmkyay837b3V?=
 =?us-ascii?Q?xsPbsWZOOsy9ptkYYtubdnO0ctI+Y7hn7Z0MLynY2McHwW/nfT0fw8fbCiOc?=
 =?us-ascii?Q?3TFnF7QklU9Ym5cPMsPUnZLDdQ8cUQQM0TyBHwvbryvwpU/WuuDQMuDLAtlr?=
 =?us-ascii?Q?oDK8cmisM2a2raG+M6vQoFF2T2OFHU/++zlxSj2eoWdnvP5rjtGQ3gn2mryy?=
 =?us-ascii?Q?4pPVtdtVSi6/GvEtLkd4BoHqlTHvpaE=3D?=
X-Exchange-RoutingPolicyChecked:
	rodKFH5hLB8CtlMQ8mvMGwme5/YhHr5A3z8ruvMRKcTXx0SU1/k3haeWT9Sh+6vXkqO62E7cFxX93UkrCvsgWAu1TOVar4vcElJQ81zlBIBYcgjM8IL7tcIyZnKgiRjlszx++Rq4iODzohvslNjLmxmegIFHGPY5V4+GrdSypzDVXtQBXu+WjnSSkSL7avONOCd/optQx8/km9pFwfRGn+YpEeojDmntcpBMIFCz6zTFUvenBJyu3RKMSCgImcOqOWovHn2IhVXmVgRAtdEuaRbf3Iq2SJan4SBgyNTZT2w3dWcZ5wW50AGb9JIDgukmPQ5+H9WLZhsbWLV7BRIZHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BbEu1OMmsctE9KMdStluE4l8a2pCYObBBE36AaxK7xCHC+yMlZV0Hl9D9S+SZNzfbhcBmE3CyuF6MokPPS23VuA9ht+ZRDZ7jTpC5dI8ERXL0Y7Hn+gDNIon0O6euWcmiXTrPHWOb3obs6UxEtUGoOBdqt7m48XrC+Tst02APH/6UR5G+7WX2Y14bDmcWV4ybBOlzqrsxM5bkUdv7kW3BylDgdabJiHGilAFBsGpczcjE3e6tBOc7x+DCCu0LGKGpdtkZC9kg+WB0jwZmRPHQvMBUfqPKyQFcGtGpLtT7RWM3tLqjKp9KYGG2SWCPog9qcY6Q2lbum8x6FFgVprwDioju1u2EJUg6pD/K5R6cGEuyR1KMDFVg+AodCrtoWpN4jMDBOx3xioe0ybHjJzdd/wHw4W40f8ZPvcV/I/okz9P05y8EgFQzLwxAF8f2vmfLSk0ZkPFku4YjuIhJQ7PCJF0GzXiBTIyWGdh91O6npcbKH2RyOIx78HAKDyY21fNeHxbqzrGUmqjq2Q4aJPcwr0sBLkNqKarqRb05yH/9520k7i1CMyOdmEmS3vqOuCIFf5Tue3i0rPFv3ZNfmPevQ2NCrO3wKfsfsaCqQqWmko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54136f1a-d4a0-4f76-6652-08dea5176915
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:10.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQX29JikY/pFTk5dkfWTb3RGtk1zeW3FWk3zv/BHtLLTIa1OdfNxZCX1vGZ9NfMRx0+X/zxwcGEUKR7GxuKhOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: VvHTbTyictZnFd48_yMxBiXi8u4_TZfu
X-Proofpoint-ORIG-GUID: VvHTbTyictZnFd48_yMxBiXi8u4_TZfu
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f096c3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=8fwEAWchWUUFBy44-ZgA:9 cc=ntf
 awl=host:12309
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXzwvZacPUg+Wz
 fl6WNkDU89sOr5KNUsfEmvewxm2XCeOFWqqVu+tWmGBHOlj5Cx9/KYQqNz12qWEpxiGgA4qIsxM
 WotwbDsQokzH2HchVyWKpaLnIbqqGTgz2EQOmFt2CDwS3zjy2m6AvbdP7beGYtL0ybFCBVz4BJQ
 ZzAO/OnNAUuZ7sTI6D4YGLX91PckO0SutvQMqFHhrDcm+M4OY42AQrJ+NP8EEKy9FMZWCpBfYeJ
 8ZuH0RMTS5Fy+WQQy89Ya0fxmh8atBWWKuYsN0+gFFuUlVadU3ttFQ9+aduurbHEHM0EyfV8lWn
 aTdHCs6voM/z8OhYAzqHh9kBrllofpjMgINRrWrezaa8wCqkpJsNyfCuGY6vNstdEMjvIUFcElg
 F4o+4FlEmwxaRJP64MPbGCDNmoujO1i+MeOjG+xaB4Z9bkzLT/A8IrtDrtpIFDsVJRez7som70z
 dJAkmsvSPp0ltA44JGNCQzf7rpiH168DY8hkV32A=

Add support to set the multipath iopolicy.

The iopolicy member is per scsi_mpath_head structure.

A module param is added so that the default iopolicy may be set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 54 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 55 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 31ab1d477c686..c6ae02644fdf4 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -60,6 +60,23 @@ static const struct kernel_param_ops multipath_param_ops = {
 module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
 MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
 
+static int iopolicy = MPATH_IOPOLICY_NUMA;
+
+static int scsi_mpath_set_iopolicy_param(const char *val, const struct kernel_param *kp)
+{
+	return mpath_set_iopolicy(val, &iopolicy);
+}
+
+static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_param *kp)
+{
+	return mpath_get_iopolicy(buf, iopolicy);
+}
+
+module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
+		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
+MODULE_PARM_DESC(multipath_iopolicy,
+	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
+
 static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -95,8 +112,36 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+
+	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf, count))
+		return -EINVAL;
+
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+	return count;
+}
+
+static ssize_t scsi_mpath_device_iopolicy_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return mpath_iopolicy_show(&scsi_mpath_head->iopolicy, buf);
+}
+
+static DEVICE_ATTR(iopolicy, S_IRUGO | S_IWUSR,
+		scsi_mpath_device_iopolicy_show, scsi_mpath_device_iopolicy_store);
+
 static struct attribute *scsi_mpath_device_attrs[] = {
 	&dev_attr_vpd_id.attr,
+	&dev_attr_iopolicy.attr,
 	NULL
 };
 
@@ -185,7 +230,15 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_head)
+{
+	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
+
+	return mpath_read_iopolicy(&scsi_mpath_head->iopolicy);
+}
+
 struct mpath_head_template smpdt = {
+	.get_iopolicy = scsi_mpath_get_iopolicy,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
@@ -204,6 +257,7 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 		goto out_free;
 	scsi_mpath_head->mpath_head->mpdt = &smpdt;
 	scsi_mpath_head->mpath_head->drvdata = scsi_mpath_head;
+	scsi_mpath_head->iopolicy.iopolicy = iopolicy;
 
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 9e92d949392d4..de6339989d2a2 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -24,6 +24,7 @@ struct scsi_mpath_head {
 	struct list_head	entry;
 	struct ida		ida;
 	struct kref		ref;
+	struct mpath_iopolicy	iopolicy;
 	struct mpath_head	*mpath_head;
 	struct device		dev;
 	int			index;
-- 
2.43.5

