Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3372D3815E4;
	Mon, 27 Jul 2026 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163463; cv=fail; b=jd2FxOd+jbO16mOxdACeN7V/+c1Os/wm87vKAl2KIbol2GwwvbqRyeHUaCh40/xsbpwytBpHZSrFC8CZWd4zG9UiUo9F7AOW6fmjvKOtLoNmVKz9poUUzySNJAqvOizUUrCfzINu3aoNLC3GHHTsz6XhVBux+x6qst7uIVlnJbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163463; c=relaxed/simple;
	bh=26ZpYTTMjBdFu3rNmz8CYRJ847v+8a1hBL7OVzPWXRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Co8UOWGmpQ9OlmuvOGxzsyjyCT0/l/Szj+ddJZvEbv8MrvKQS1v89qMVaDnM5IvuYDMGInNsuVDxW88hvOfgYuSucRu05IIp6CtKuSrGYmppWnwc/3xpuIiJViUCN5JLW4lNhn7VhBS/HdPamo8DVn5nYA+/BGYxzBHXsg+rvKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q6njMZZG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u4qZpmbp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q6njMZZG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u4qZpmbp"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTKP42056990;
	Mon, 27 Jul 2026 14:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tSMUe3u3tz1//lMo/LYheiihoOvwF8eYEw8q+04Qnzc=; b=
	q6njMZZG7lGJalGzCYbZO7d5V7hPW3fXQ4nW82OSVa7EZzWDamdkdeORAMXfrA25
	EIQuYHk2QQjh5/WYxDcp095gsgKWDC5nPAw3zSDh+Qf4nvU7Iwj940cE8q0CjVwD
	e32aOxhEWXWsqjZ+oVn7byC+Tv2vWwLkIOBGll4/c5QzU890dQtm5hbmNOpLX0Oi
	vUuJVvBbziktyRdhIiJKAftmuWvZHqJi0RMrowDNqSN8f5EHqq+lpFUoBeOs/S/B
	p7/Gv7UkoXZk1H7ZHPFKw8Z8gu+ksIrd9KGUpw2fudIbxkNVcpD17F9BbS8TbMtF
	HfXQafRYlqE3QI25kE6dBg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq1xhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REZi7W023434;
	Mon, 27 Jul 2026 14:43:37 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ngw21-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SA3Wip/BkXazQ3zWaQOkZHi9RsdI1rk6UHRhJ/wcNbqh/Yur6g0u1nqSqAU6hGh14L1W1pQS9nmT/o5K5Clwl2gjWMFUmySoKPzdEDSK/lGhupUyOTT8CmvZg3ErMTfKXZNwApO5vtTe9Xg2KiyeVif4rX7Ty77xHiEC5fegsZ4HHO/z0geMXI54+s6FTcJcHeP/zuhI5ku7yqTnECwr8xOg4SUBtqknvYmAYC2mi5QFhwYRbMQQ36kiY4NqF94rixEtoR/wWbX+shYsGFB/pNooNsWxRpoAYOejsFEGfKyvFM186AAVHVJRAk3oYdfPUE7xCuInyJzu9AVz1dOTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSMUe3u3tz1//lMo/LYheiihoOvwF8eYEw8q+04Qnzc=;
 b=u2DpKqsQya3FesMtBOh/m3mRtgHlZZGy0ed6OxQofX0rdT0k6rgDw/L2wYiFQR8++NnIfUgUWnpay1NFrICrVJtqAK5rUdWXFf0kkZJ84AD8VaqMuG6vAxszRAPfzrRVosUZiNVmQR1Ig1w4y/suegZEt8A1gKoaSDp2kzyTe3ga+qwslE3Zie8NAbV4HfI9eBStBrsn4SDkVL3cJ/+1QXc1lVv1aKgEk3q3LHOn+HjScaGHyk7O8lMPFt6CwkUk16vBjENBesfb1rPrvBIdrbNdy6/BbL/tWL8eGS3zavI2zmaX3cemUJSKiJQgK/xrsA1Jdkb1tkLS1jQodGJJgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSMUe3u3tz1//lMo/LYheiihoOvwF8eYEw8q+04Qnzc=;
 b=u4qZpmbpClGEYcfZchqkiJ0fy4iJowpkSYQrTaqSaFKKTDyw1A1PTu2cTIBFaJeJsXuGyG+wL7C/71w50Paz7RGa9bLpEN4VaVDnKz/ChEhTB++nXwXpJs3L/8klc+U3k5yp2+npZlpdYYbuZdPBBdCjv1rj2yeGIokwduOY9I8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:33 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 24/27] scsi: sd: support multipath disk
Date: Mon, 27 Jul 2026 14:42:31 +0000
Message-ID: <20260727144234.3802948-25-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0100.namprd07.prod.outlook.com
 (2603:10b6:5:337::33) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM4PR10MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: afc7b6ca-276f-45d3-eeda-08deebed6f01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|56012099006|10067099003|5023799004|6133799003|10063799003|20046099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vvFQJXDhgobO/qS9oCsku4Rckieho3SEC0b5UIN+/w+Fim/K3W2SYp3U3jN63Nr5278j93R1Q1/rUCNsTp6fVt+3Rokg1iXvWg1heQrpJ4f8r3Z61kQ4ysUY/kIpREbuoM4uyriF5xSaEt2N26UqfCTA5t0WUB7vsS4Cz6Q/no5kNJsQ4DuU9zTmSRyAXpS2PWk+Qonys7e9f/vazgvCQuTNeI+1rv0B9r/6Tammr/j+FAcpEoBlmXbkTR58qCITviSmWwxlpK7JxZ/z+hTkoXEARa2LS6O+kLeX9VQ3M3IL6TecoBmol2nuTMtb0hYqKeCbIZct79Gf+rbudhuzEKN3Qd/QtWZy/xAzqIc7EfatQyy/raLt6Vh0oxab3WMLprcjpps+U8IDJmKy+YayTCPH2IumfpSaHtdalW9owoXPZh6kjIDLpMMZn/BAvWjVAeJsEp1wCsuTeXo8kRWvHhcTtIa9ZHt5KssvVCoE7iwQWgvm3UBY9rCmw4B6qoncHJChQ6hPMWCLQpayPt4zByS7ZhxjoHTz/lA/SH+OHohKLIbCDwf1lR3W7u3p6cOAjlPi4pb7725gb4gju+TWgrv7YSj2IATUzhhDgvdDdxGpR0lI43xKVQbee7TK1+zcTmSC0EzvkM3yfaeSZPew0h4Hvt7/2QEQ4Bpf9muMGhU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(56012099006)(10067099003)(5023799004)(6133799003)(10063799003)(20046099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j+83lwvr/d+zwlDmGdtfw3KKsnuU+OnZDmKIKbJbisdzxhsrag2tBr/liif6?=
 =?us-ascii?Q?HwxjvqrsueEK5tEZtC7G3g5Pz0mZcvrBTohSYlCcZXlfA4f4+LK7csNnh2W9?=
 =?us-ascii?Q?BOcPvLf7qbloYbeG7Qi711b2p07cbvt7C9iWk/SZwn4bmQJxCvO83IOZ7jR5?=
 =?us-ascii?Q?mrwIKXdmekH1RCKrIYoRPLvSZznb87H/7wIf7s1VA7WiohCj7JXV8S0Y+Sc3?=
 =?us-ascii?Q?3a4WpAZy635lCEpPL1Fpi8oQKOFk6rSv6Swp008hfBrUrbYlIyFoB155IyxM?=
 =?us-ascii?Q?MUvDInqGUuOnyhcPMEkXbHJvKF5nei7KeNZw/So6+5Mxvx2b7uhj6Q7N1l/l?=
 =?us-ascii?Q?/qHP3UUEw60U0rsFiRQtK0CaVTaUVqI7K3aiqPNk4k1tHNW56cecpHxt6Bzq?=
 =?us-ascii?Q?RcMoHlDDqHJma5+4ixEu31IpnP72zPMQZQp9ePfeJ7W3RyOreadKZR+bNwQw?=
 =?us-ascii?Q?L/U6krLjWreeOH1CimuuszuplW+BrMQjvz/zd8DdExyzly3IqhOQO4GF7snD?=
 =?us-ascii?Q?XX2yEssfkv43hrsrSPSbg6EuhxLQXIQq2oC0/MO9R0+o3JBkZi9LkuARSDSP?=
 =?us-ascii?Q?E4sQh9Z5TrVZRGxOzzaZiLJ6HtA1KC5dUXdDRcpR4JnJygO3QxkQkS6tPcjl?=
 =?us-ascii?Q?Eb9fFdYU8ksJarefhCHov/HV4nU0IAZwOHrMpLeiQIoyRiwlo8a1v9Z/+iNH?=
 =?us-ascii?Q?qvpnz8QeyHnY7/sHKhJfRzsC/jahUnPKwdMvsLP2P+jWfjvu62O/m5PSuuWE?=
 =?us-ascii?Q?+Cfc95DaY3oaogCfxX7JJuUQ5RRr4mlmHnbO7OH3MYxydKyWoPRuMGkgb/GK?=
 =?us-ascii?Q?4yGh5s6532W3NFQok+J9tbXOu6VXXHIpRuRZ+4MYLRVvZI/J1x3xOm2DGWZT?=
 =?us-ascii?Q?4Fyvdq7K5C+QyhQFujDfbbmqy2R8D9s/twnQgPYr/ZTPVqrwQlWh6iVwZ5I0?=
 =?us-ascii?Q?qhMe2Jk8pCYs172pBYEp8km15BwJWTm53yzBFeDfNUGcOwdq9w6bmh/J0qYl?=
 =?us-ascii?Q?c55f70qWf/7WhGgqZGr/MyIAeDkAe4pi/7U+7UbY3ujGMWR7gswEhaYi1aGv?=
 =?us-ascii?Q?GQOCs0KJzAsKpoxO05kOA1U+xCSxIoWy3kbZ5m8TRGnZVuuGh3PybI0H4FAG?=
 =?us-ascii?Q?4e5FKfevEMofdLNPnU8NQsUO0PRir8wqkLLZZ72nwpCYFvaAfs5smJcd/POV?=
 =?us-ascii?Q?4pZvp2fVSGdO4BeLcGOgiSucRW+pL092LoKsFnrpIG2lLmoZFt7Uh2S+0LBR?=
 =?us-ascii?Q?bxoaxZQaaSd9yd987/g/izJsrseLst5gbjOtAPahp8C6HKAKGB2TV+8q7rlf?=
 =?us-ascii?Q?W+srUH7yUOXkYEkCWdXTG8mXb6PIr4KlgcaE8C4J6PE0bNaLBCqoUgWjH1xj?=
 =?us-ascii?Q?ra5FAGqE1x7IwRH4e7vOZ2+lqD7A2oUdbB18SZDQzEYpNybsSnXOFbn1o4Gu?=
 =?us-ascii?Q?ovAZiY8abvacwHRm7KTrrR3fg2cR17mfTbN1rg71t/jOlwRl1hTLGmGxEci4?=
 =?us-ascii?Q?lbAR/iSqSNpVuCWdqFQZzL0KcJgjLIFqS4lM5I8rmEWoX7vsLYUWLu6jBp8R?=
 =?us-ascii?Q?vSPYfW49I7b8Ms+Xb5Bf//M1fovjlh7oXRZTBd+mkNkx7gdcdyXz2/kVum8b?=
 =?us-ascii?Q?0Tr7frPVSqbUdcsp8DHfet4azc9QXnkxlTyUFZPDMlKCHTUM1tp7Hsyp67Cy?=
 =?us-ascii?Q?zuMctP3Wwf1BR42sDJ6NR1H7Yzwx1R0e8Y2tgeTXykInPtGs4JfclhzElOrf?=
 =?us-ascii?Q?hjuQAaQ1n0Eu+X8dJERowafQb6JxHPA=3D?=
X-Exchange-RoutingPolicyChecked:
	abVkF/EXlCOU3Ko8UhQep6GADyoAuqxE/Xll4b/GEhfRgnawJ3TWH9dhWpzbBNxXjjqcTRPzH4pM4XKaPdbPZlME159SPxQgouMOZZ42OzoxCze2A9E6Kayjla9Y5F/Z3ZG32lquikKG+MO5MMt+5rIkBpT0a4GGubARaL+a01HMzrUFh1QA7T+cogTWbpvdkV/f7O60bUKN9yWNZF3UK4NNi8xOx1Qr7mdKic6UtYIIWYmZq6IrrXrsYpAOWRID/Jc7vwuJxDR2ZH4VaKi1pcWZvbAks3geSAdTFM0/lCAe/b0MOs8F1AMot1dJCJWo9t3CJPQ74keZaexbGIs3hg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1Ov5hI6H5raFDDqiZTPCPul3shs9TjtgJEqRkvrPv+i7QqMtVbqz68XeoRFdyPuwBRqgcFrq5hO+VvBkBTD7TamNM0A3iZLQW16lGqIHTvbtJKYlyQaTGr8gPPgzz8R7yGyZ4eidnUVqUBpoMJbBT3R3ScpEDntjS4I71paiYZvZcYNLarpLwmiTp315r7tEgnmGPpnIaJhEfgzOTfN6oJx9IM00/5W+X4t19RglvN8Rhqn5JYpAQVhjQAOBmcTXz4oHDBTR8IQub9UN8LW+i2fsPVQjWPMYTGHthuHlxtIswVYtPF+7W6ySewunsy7erm1idb0kYbAI6AO1yVy/hKGq8fa/Mhz3mEOYCq7evzzt2tbRHHjq/V4bJyvM+12H8e3735NZdHlMnPp3LokpYZ26dgwuWNQVLIa5DkHVFJew0wk/B+/HaiXx7MokxRTkAieMUkojhHBQpu2PWBjenLXFVVtJ1AfzFc6WnQU1YzlwoIG/oFNJnMC0Kf/Hf+LVnvMp+oJ1luEOJpLShurZsGYrrUOMqVSNHFogMlDVhz9rXq644hi62au0kA+u4Ze9pWUQGNuDWkrKuLN+YB8R5HLjoOeYHhcLv+3OvwApPSM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc7b6ca-276f-45d3-eeda-08deebed6f01
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:33.7488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwVkT8lmRleejCKF8YJCF7701BKHR2hozOYXPW2MQsunAQElvbh5UFiX9hc87ZgDOpJoOWg2Sk5XOwAkEjPVLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270138
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX2Ox64LFCHebS
 aoV3k67cLtvV2Xh8frqD+L4okM3E9fA0jtbAF3/oaiN5gQGN83hzi6WP01xFe2pdogqpRVX3WCN
 2v2zTXRy5+QmHLiDxhmFY+uHrUapBNgwQt6gKzeQa0i96apsDQcoutyE5kCW1+mR0Xo2wXnOXpn
 U9NVXRin6TmZeOieF5q5nFaDV3/NrQ4zZhRovCj3wKujOHtOEF/1DX0W6Y79olLC0VBKnyiADsL
 pT0Jad+iWtWYdiHNohrAL5L1WpqELLRlAvh5zTyUl65NpB2yyNpDeGQ0he8OtXiTJ7P68KpgLc7
 oLaeP1cZf7tRqJYcxcIte96/rE0ERHaBagS0kFMpG4Zgbk7MqNKN3oVF0NMMahh99b6D7k0khWq
 /FjYfrav/blyjigGQG7qnsZTL9iyIzpPMo5UDfGVmexhAlK7a23PGSNcdkFo4mcL5noIj7BMmD5
 OtT/0VEBIVAllY2lSAX8buNmZbUY091YR4ZAf01g=
X-Proofpoint-GUID: waPGN9zCNHcvO6XLbsltdafFCcP-zeG9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX8nB6ytOPF2XZ
 GuaRQC70CxOoptPBAqftS/U9lwWAZ0yyucZIhsY0apy7opKiIV6U/hG8mWJ1ntTGRJEf6NysUnP
 8BDkJAirbEvX1ycAL0lFaTbLb4WU3JlT++jVk+wICGweKwxeJE6N
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a676e9a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=UnEsLBAWqG5TZJypXWwA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: waPGN9zCNHcvO6XLbsltdafFCcP-zeG9

From: John Garry <john.garry@linux.dev>

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

A global list of sd_mpath_disks is kept for matching scsi_device's.

The multipath gendisk has the name and disk->major/minor set to minic a
scsi_disk.

The following is an example of relevant scsi_disk and block sysfs
directories:

$ ls -l /sys/block/ | grep sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1


$ ls -l /dev/sdc*
brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2


$ lsblk /dev/sdc
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc               8:32   0  600M  0 disk
|-sdc1            8:33   0    9M  0 part
`-sdc2            8:34   0  568M  0 part

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 425 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 405 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 36c745cbb2619..f044b2dfaa9fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
 #ifdef CONFIG_SCSI_MULTIPATH
+static LIST_HEAD(sd_mpath_disks_list);
+static DEFINE_MUTEX(sd_mpath_disks_lock);
+
 struct sd_mpath_disk {
+	struct device			dev;
+	int				disk_index;
+	int				disk_count;
+	struct list_head		entry;
 	struct scsi_mpath_head		*scsi_mpath_head;
 };
 
 static void sd_mpath_disk_release(struct device *dev)
 {
+	struct sd_mpath_disk *sd_mpath_disk =
+		container_of(dev, struct sd_mpath_disk, dev);
+	struct scsi_mpath_head *scsi_mpath_head =
+		sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	mpath_put_disk(mpath_head);
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+	scsi_mpath_put_head(scsi_mpath_head);
+
+	kfree(sd_mpath_disk);
 }
 
 static const struct class sd_mpath_disk_class = {
@@ -817,7 +835,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	ida_free(&sd_index_ida, sdkp->index);
+	if (sdkp->index >= 0)
+		ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
@@ -4006,6 +4025,90 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
+	struct queue_limits lim;
+	unsigned int memflags;
+	int ret;
+
+	lim = queue_limits_start_update(disk->queue);
+	memflags = blk_mq_freeze_queue(disk->queue);
+
+	lim.logical_block_size = sdkp_lim->logical_block_size;
+	lim.physical_block_size = sdkp_lim->physical_block_size;
+	lim.io_min = sdkp_lim->io_min;
+	lim.io_opt = sdkp_lim->io_opt;
+
+	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
+					disk->disk_name);
+
+	/* TODO: setup integrity and zoned limits */
+	lim.max_write_streams = sdkp_lim->max_write_streams;
+	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
+	ret = queue_limits_commit_update(disk->queue, &lim);
+
+	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
+
+	mpath_revalidate_paths(mpath_head);
+
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	return ret;
+}
+
+static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	if (!get_device(&sd_mpath_disk->dev))
+		return -ENXIO;
+	return 0;
+}
+
+static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	put_device(&sd_mpath_disk->dev);
+}
+
+static struct sd_mpath_disk *sd_mpath_find_disk(
+			struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct sd_mpath_disk *sd_mpath_disk;
+	int ret;
+
+	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
+		ret = sd_mpath_get_disk(sd_mpath_disk);
+		if (ret)
+			continue;
+
+		if (sd_mpath_disk->scsi_mpath_head == scsi_mpath_head)
+			return sd_mpath_disk;
+
+		sd_mpath_put_disk(sd_mpath_disk);
+	}
+
+	return NULL;
+}
+
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	int ret;
+
+	ret = mpath_add_device(mpath_device, sdkp->disk,
+		dev_to_node(sdp->host->dma_dev), &sdp->host->mpath_nr_active);
+	if (ret)
+		return ret;
+	mpath_device_set_live(mpath_device);
+	return 0;
+}
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4035,13 +4138,259 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
 	.attrs		= sd_mpath_disk_attrs,
 };
 
-__maybe_unused
 static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
 	&sd_mpath_disk_attr_group,
 	&mpath_attr_group,
 	NULL
 };
 
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct device *dma_dev = sdp->host->dma_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	char disk_name[DISK_NAME_LEN - 2];
+	struct queue_limits lim;
+	struct gendisk *disk;
+	int error;
+
+	/*
+	 * sd_mpath_disks_list is kept locked if no disk found.
+	 * Otherwise an extra reference is taken.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (sd_mpath_disk) {
+		error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+		if (error < 0) {
+			/*
+			 * Should not happen as would fail for the same when
+			 * allocating the sd_mpath_disk
+			 */
+			sd_mpath_put_disk(sd_mpath_disk);
+			mutex_unlock(&sd_mpath_disks_lock);
+			return error;
+		}
+		sd_mpath_disk->disk_count++;
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		goto found;
+	}
+
+	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
+	if (!sd_mpath_disk) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+
+	mpath_head->parent = &sd_mpath_disk->dev;
+	mpath_head->drv_module = THIS_MODULE;
+	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
+	error = mpath_alloc_head_disk(mpath_head, &lim,
+				dev_to_node(dma_dev));
+	if (error)
+		goto out_free_disk;
+	disk = mpath_head->disk;
+
+	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	if (error < 0) {
+		sdev_printk(KERN_WARNING, sdp, "sd_mpath_probe: memory exhausted.\n");
+		goto out_put_disk;
+	}
+	sd_mpath_disk->disk_index = error;
+	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
+				disk->disk_name, DISK_NAME_LEN);
+	if (error)
+		goto out_free_index;
+
+	error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+	if (error < 0)
+		goto out_free_index;
+
+	device_initialize(&sd_mpath_disk->dev);
+	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
+
+	/* undone in sd_mpath_disk_release() */
+	scsi_mpath_get_head(scsi_mpath_head);
+
+	error = dev_set_name(&sd_mpath_disk->dev, "scsi_mpath_disk%d",
+				scsi_mpath_head->index);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	error = device_add(&sd_mpath_disk->dev);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
+	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
+	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
+				(sd_mpath_disk->disk_index & 0xfff00);
+	disk->minors = SD_MINORS;
+
+	sd_mpath_disk->disk_count = 1;
+	mutex_unlock(&sd_mpath_disks_lock);
+found:
+	sdkp->sd_mpath_disk = sd_mpath_disk;
+	sdkp->disk->flags |= GENHD_FL_HIDDEN;
+	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
+		disk_name, scsi_mpath_dev->index);
+
+	sdkp->index = -1;
+	return 0;
+
+out_free_index:
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+out_put_disk:
+	mpath_put_disk(mpath_head);
+out_free_disk:
+	kfree(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return error;
+}
+
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	bool remove = false;
+
+	mpath_synchronize(mpath_head);
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+
+	mpath_delete_device(mpath_device);
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_remove_sysfs_link(mpath_device);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct device *dev = &scsi_mpath_head->dev;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk) {
+		dev_warn(dev, "could not find mpath disk\n");
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	if (sd_mpath_disk->disk_count) {
+		dev_dbg(dev, "non-zero multipath disk count in removal\n");
+		sd_mpath_put_disk(sd_mpath_disk);
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	list_del_init(&sd_mpath_disk->entry);
+	mutex_unlock(&sd_mpath_disks_lock);
+
+	device_del(&sd_mpath_disk->dev);
+	mpath_remove_disk(mpath_head);
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+/*
+ * Always calls for a failed probe, so we need to handle that some structures
+ * have not been setup.
+ */
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_head *scsi_mpath_head;
+	struct mpath_head *mpath_head;
+	bool remove = false;
+
+	if (!sd_mpath_disk)
+		return;
+
+	scsi_mpath_dev = sdp->scsi_mpath_dev;
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	mpath_head = &scsi_mpath_head->mpath_head;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	return;
+}
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+
+}
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+#endif
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -4065,7 +4414,7 @@ static int sd_probe(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	int index;
+	int index = -1;
 	int error;
 
 	scsi_autopm_get_device(sdp);
@@ -4094,22 +4443,33 @@ static int sd_probe(struct scsi_device *sdp)
 					 &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
+	sdkp->disk = gd;
+	sdkp->device = sdp;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
-		goto out_put;
-	}
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_probe(sdkp);
+		if (error)
+			goto out_put;
+	} else {
+		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+		if (index < 0) {
+			sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+			goto out_put;
+		}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
-		goto out_free_index;
+		error = sd_format_disk_name("sd", index, gd->disk_name,
+					DISK_NAME_LEN);
+		if (error) {
+			sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
+			goto out_free_index;
+		}
+		sdkp->index = index;
+
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
 
-	sdkp->device = sdp;
-	sdkp->disk = gd;
-	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
@@ -4129,6 +4489,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		put_device(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
@@ -4136,10 +4497,6 @@ static int sd_probe(struct scsi_device *sdp)
 
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-
 	gd->fops = &sd_fops;
 	gd->private_data = sdkp;
 
@@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
 	sd_revalidate_disk(gd);
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
+			sd_mpath_fail_probe(sdkp);
 			error = -ENOMEM;
 			goto out_free_index;
 		}
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_revalidate_head(sdkp);
+		if (error)
+			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
+	}
+
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
@@ -4177,6 +4541,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		if (sdp->sector_size > PAGE_SIZE)
@@ -4184,6 +4549,19 @@ static int sd_probe(struct scsi_device *sdp)
 		goto out;
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_add_disk(sdkp);
+		if (error) {
+			sd_mpath_fail_probe(sdkp);
+			device_del(&sdkp->disk_dev);
+			del_gendisk(sdkp->disk);
+
+			put_disk(sdkp->disk);
+			if (sdp->sector_size > PAGE_SIZE)
+				sd_large_pool_destroy();
+			goto out;
+		}
+	}
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
@@ -4197,7 +4575,8 @@ static int sd_probe(struct scsi_device *sdp)
 	return 0;
 
  out_free_index:
-	ida_free(&sd_index_ida, index);
+	if (index >= 0)
+		ida_free(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -4325,6 +4704,9 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_remove(sdkp);
+
 	scsi_autopm_get_device(sdkp->device);
 
 	device_del(&sdkp->disk_dev);
@@ -4493,6 +4875,9 @@ static struct scsi_driver sd_template = {
 	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
+#ifdef CONFIG_SCSI_MULTIPATH
+	.mpath_remove_head	= sd_mpath_remove_head,
+#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
-- 
2.43.7

