Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B9483814;
	Mon,  7 Sep 2026 10:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778326; cv=fail; b=kZQMbhl8Po7sU5J5UxkpUW9C2u1pZLluEhix25ogg7EH/ggcfuaMfj0y+As+PpyTzSju/vFH9jKGqi1gXraIPclD09FAo0SI8lhJx2vixk8foH0HiMAsphDwqOhe3Fi1R5VhrTR46By4F36YVpLI8eBAjQmf8QozpyUZRXDczZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778326; c=relaxed/simple;
	bh=2Ik7erG8b3f+M+YthkR8zBsM239sa/PicPIbV344Ub4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tLEI1u+448tpl/8CR6RwyqpFBDSahu8NL8kSuUMR/0v0gR2M0OOn+01qD68ptBEgqwooEhQi3cGNMf73kjxOj7fPphW5NTXgIhMoQvx61VHfXkKaln903OfNxN/ZgL+fRtEmf31BQjZftvpRUZrCwWb83KHsD4Osmdzuoh3wdM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Govs/ATX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i82LHCPe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Govs/ATX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i82LHCPe"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870UZ3L186187;
	Mon, 7 Sep 2026 10:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1Ms7IxDUQPuTDo5BfD17e5isRG4nX5vUE6xvTEA0Noc=; b=
	Govs/ATXbwldXKldFFHUI4pBjOun8S2Z+AERYxgm+WdrRCvlhvH8VVZINj9Em4Gu
	ji4WAYFHpLDoQMgqp6BqLuVqGO96nGwJC9o7zjHs+D17cXWc4JC7jcgwe6fmFRyO
	UwZ6+BtIkgMqhcLBw0qzZMNLnamgn/jc0y7kugKpB4fIbn1ckPGUSGogQ0UYtNmf
	lzzMitZ/PWD57lwd6r+Z9r/0DAsssB3ArNrhiXyFdd172vl3aL2UGKNHxwQZEKtv
	LWvNNfElMEkcGME/nYGlprz+nHw9GE+HJDXxyZH7XykMvWAPuvIoa8BCcm1nmZz1
	uL9rZ9k/nL5FFE1W2ZByCw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbmq9t41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfG019106;
	Mon, 7 Sep 2026 10:51:18 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qfjO3m3KVczDK+bb8eWnPpeytikhCxavMOodZcqKuo7P65RfOHWf05C1dl3Qz+L+YXOH6s90fxIOu2Coztlz2Z2WbJxfKRxB2rgw91dmk14yU4lwMgwg0iIq/Ga2shbLrKUJgBywst25O+wNcKdnxHyaj+xG6+9k7PYD//Ns6deafLRgP6PjzWCJmsiF7WWTU2YrEOrSWNAjk25fI2N4Ehs3Ig7Qv0eEKDdf4GJYEA/r/xVpb07ri9FXVNB8aLD2r1J+NsnE3mFdpdu18ZIYIqodc3x0+VAN/IB/rUbDuLRlSfqdmq9exd/XDCRu822GHrlFmKzmio7g8PrEWKq4zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ms7IxDUQPuTDo5BfD17e5isRG4nX5vUE6xvTEA0Noc=;
 b=LYysRlf+FevLXfMRL9zhS2nVO0vXcV8ucIihTLwwhxAUMZ94i9gGzYEip77vijIB4i1m/hGF4YjzBRUrCC2uwmSPS3eQOMcElp11/dSoz5Ykxh/Py90fKbnIlulJxTEdfyghcC/4L2e81/fbe/6eVzCtPlAbOCffz2555s1hM+61sOc1G445OouXE7Jh55ZIggVOjehnH9FW3jflL5fm853e5u9T10WlzdyzWStac472fSjJMl5zQdv6QBCBYngcNKRBHKU/LFi4QIdFcBAgicOddzSXz/Ne/E7kCDin1K4YkAoRfLwPtMI8i0krp2lv/ZavgIY9qk2yU1S+tGSGnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ms7IxDUQPuTDo5BfD17e5isRG4nX5vUE6xvTEA0Noc=;
 b=i82LHCPeDuka3VoadLrDf/G505nioQdpz5YrCLZIWOIwWRaZn81j+fjVIuDOaU8saRgfKmCzHfTa/w2kv35PEyz4149PJLm3kqQGSNvfiq7P+qU12bsDskcFBr2p0qdx+IecVnJyVqCpHlcpUvnA8A++kqepifgyzLY7Z7pjEYM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:03 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 14/27] scsi-multipath: support iopolicy
Date: Mon,  7 Sep 2026 10:50:08 +0000
Message-ID: <20260907105021.1763236-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 536ad148-b397-4735-5f13-08df0ccde95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wL4JpiPpkRwVfSFdSgJvBgeTaFziM4RLiYOtjUCMyn0E0meiz0lJBFmq/sR0j8ZDLknDg+u+o7FmX8IIpOjYzFfj+/hRFrN7GwbZdnZ/HurlYr+Kz1I2qMQBtdMWr9lqp9U2S3v2/WFy8DVSqxpNOSKX5RiyrgqtI/C3tHynoQuWo2oQpFjo5Qg6m7i+OTtGG+cIOAkt+AcLUUSmjnR2k+Unark8E/MRFG09w4LRJAS5lknHn8tMVQTpnkwGzp6Wg3K2BMNMwHNs+2oSrtjsvcuv8vhxx46xbc0GRjDSRbyXmOvIUp0rgVCtIkethGfZwvQh0kb5fqc8VXiz5j3TIKQ8c33byIy2Yq76fplmsRUdG8/3q9h+cOG/LSVuHA4dHT5mcomLoATaJElqhjkZqy/YLQeQViMGtZEl6WLzmLo7rfBJpH2Z2AGF1qHz/D5yUVC3dpyCPVOclP3n+yN6QY2j0cl6WbsLWF3HxkN8+89JtO7mEapHSDFgPTRvJOPGJKnaTdBY2ROsa5GoIOMtoJfil9BW656vXHJGjDSG3Oxg+xRkTd+y1hTYU7ya/SGaK+LOqzyg+py9d790aVS63XHlebVPC9DuAyBr992kFKlSWWAJuRpketpldgI20oMCYtnxbWS8T5gjLUSQPTh7wJ4nLkAKK58yS32uuw4SNNE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9PplvjxlhCVmR4gFVSujCZkzdHw6FOOBPCvwzH6q62VS7dviQbVJcuv6/RdU?=
 =?us-ascii?Q?bixm5Qo9lIVgjutvfTn9d/ZQsuY0jCw65M3zEVKp/QoTemS6pTPIDoyS6j0Z?=
 =?us-ascii?Q?SD9KQ5OwnDt2din0JH3dAfEuVpA61auUKZNPiscfGZP2FZgHiuqLC4KmQg0o?=
 =?us-ascii?Q?sHAcVHM0/BE4ihYLK8s/nrDKKWCcQNkM8+80vK/f7TvDKPfYHqLI3wF7punO?=
 =?us-ascii?Q?CHgboFsr/7svpMj9vUTEvKB1Fvox6oTs95bPifxKDWPgktG5jhaMBDxC5HjL?=
 =?us-ascii?Q?BJcyrbSSvs2SAMQJYOLZGFI9SoScMXoEq5qCzlBm61mwOTLADgzhUVDU46fi?=
 =?us-ascii?Q?VRm0JruhxY4py68Wn02OEImRxK5Gf7apJ32zmUTwzis3od6b5FcNFK1kiWHe?=
 =?us-ascii?Q?hY2Z+a1CPXFYKyuMv3Dj0NXBfHbs79TkfYKWJLNwvEfRpeRn9MAjWwvw/gFT?=
 =?us-ascii?Q?paH/EzeXg8rM9HFHcsAeHVuZ6UudUuWr1xGJaELpIQ0xhnat27sQKvVMBrve?=
 =?us-ascii?Q?uCwaYcYh2evpvYIulxScvUPnB7VszFZa7Zd7RNd3jnJ98GBTkTnUClfrPkrt?=
 =?us-ascii?Q?qb7z0ECVCKqZMsH+cBPtyKP3YjKMW2RHiNnaDXZXPAAdQ5ChoMYjW1yxkLzX?=
 =?us-ascii?Q?eFEzxJgaNRLJuYpZw/c5KsrGs4fT26jv17AkAuZtwt6gHusjWTF9QhpuZx52?=
 =?us-ascii?Q?6NllgRH5XB0iyS+gOh3wUUCHxyF6uUAXIS1wxQNGaIAkaZ1uFvAKj6tj8hII?=
 =?us-ascii?Q?Qc9up0VkdlVZgSdoVCqdzmkl5cgd+FoSRhrAreeTdqLJv9F8/fYK2QorbDvp?=
 =?us-ascii?Q?RguEcz2RBdATPyuGzBmgzJCZb6PDxjh6NXo62s7YCgmFgW7gE8m5ST1xS5BZ?=
 =?us-ascii?Q?BXeRiFgRja3nN9tqwXwPb5ThhZ/mcGG6aivxfQlBAN5wGm2JYwdeTnnHBvoj?=
 =?us-ascii?Q?q4XKUwpV4PAP4Oa4gK0qrLZbrhZdgj4z8IZFBq1MZ+NBzD/l9cFlvnJ8J+SE?=
 =?us-ascii?Q?gbmaFRBvZAWNayM9rRzUpMj54uHO/Ttka8N70qvMcHgPDhTiPJdlX+6yBvoB?=
 =?us-ascii?Q?WLO0jpKH9lTPVGqA93FNJiGkKkS89D5anK5xoLt2qJZ4eZ2GPL6Ri2QCMrLB?=
 =?us-ascii?Q?g+c5YPaTej5gSSt4AvUeIaaKP7tHfFhbVzfJEuQ6K8ZuziamqMPR8R0WrUlw?=
 =?us-ascii?Q?WsMjcSdpKZdEl6+/xeAzi6h/JXRnlZcbok3tdX/+LIi5X+bo4i2pTa+t2ZSI?=
 =?us-ascii?Q?GZthZd5NizIkNcHBHWG+/MLsj8IW5GSy+nxtIeJIWOo+uRJk6R77VL3nzpKF?=
 =?us-ascii?Q?iAOkB9aj3FgffRNZId1tgdgToF4BCJzRk35RbUq7vQLNR8j6vMnaOUIEzqeB?=
 =?us-ascii?Q?pHQG+Y7l7uYHFLxI6pAmO3oXazHvviZDXQuYRbTo4OT8GxEn+zQyBjwAI6OB?=
 =?us-ascii?Q?IpQcNaAc+cbBm8iPi6IIwUqsMcITw/nqqXg201V+eeFnlsWjc1kAN3sY7Jxj?=
 =?us-ascii?Q?T+GUIYctOw3Ipk7vgwCk3skGYFEDK0vkXVNt70W1SMS7qPJylbW0Gik7ReU7?=
 =?us-ascii?Q?5Fc8y9wvmxCG4uBtBA9+MEXaDe2F2gLT5SQ5qKdO2CiLAYMzTlwNWTGz0FAf?=
 =?us-ascii?Q?7m6NiiAOMyCv18yRDwAOdcXqBSlKQPjk/PYQi9kI8wT49MzbYXOfEwT1ZM+6?=
 =?us-ascii?Q?d2CILPtJ+9/HdvObH0HU27sVq3pdOEJlr7dyRiWN8Xt8jqFlujRdysABmt9r?=
 =?us-ascii?Q?u8/skrMLuQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	rQYY7PwvInLR5xR7MTXaV2Olw5bHYvauCjaShfiPEvH6DUa7tQLTXRxpecV7jh206tYccsMjQCdjCOdEUCLcH+Fo7aravVRiqJKNH4Iq+o8xv85xA/4GmX2LAnc6pp7s22kJCaNZ+krQBmkKN9cjTcLXBrEzdo7GWkSYYlNoFG9A0D/6xgWuqjakt8d/rjeehrp4/H+ZzqACrgkKncmfAmoc3qE3Mwr26piwfGb/s8zNUNfvsrlFjUXkxZw9GqOP3obH+UM9OW/7vMD8GSAJ9CwBFM6B+apsOXncgh7Ck1ra3QyRcUjkUaUJUvMhm125VqcOPsayXDsemmjngs/Olg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WxYL4Aadjs02TsxUi7vwtuLVCOK2z1pcgSTy9EQXze/ljfpaLlMBL3SAEq5GBvKY56/bBLgMUb4oinMb48xoAz/cYt/4I6eZYnVcyVohMfydDmQR4qWu8jXA1rXpkBIGWj9l6yMllyTenKClZPwHFueb8sdoBEpbwEUry3esrumqfZX8Vj8OxWtDBntGTjJDYEXeo/u4dHUOWEAzSU7Ub6pIeixyPsHXGYFhj00tQeEldKZW0jhpwV3b/rKzGH3Ef4A3iLQj6Dn8I1H4dDr84INW2WGtVAU2rsGLqYzYkzIlGFvhzktYSclwHm9l7qs8fHGE6obfXdvpdy9QWxu2aiqXbvrwBrytt1x41CgDqDZPn4fIeQDP+DFwssCW74ouDfm1SnbQ4Ll311YsuxRoBZw4pCP6d/XrygIwEGvmtTO8Ey2QLcDYXsIxxNdl50QfMjIOYYXrf9iOEpZipyikLs1Qke0JlufdhA+lNB9hCxwytPBt+eLWmeO3lxE3f0abOrns62feMNcYjxLnznPIMyiV7i0MynFjS1PfHs+xkUUj1W+BM3N6j/sM9D6oh5cJD/3Y2/FL3gU9nv2kgHxh/KccD30isrPowGiCqgVmpr0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 536ad148-b397-4735-5f13-08df0ccde95a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:03.4283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djjNMG/yqZ5Y3R8p9Ic3djhEGzjaADGJF++vTSS5xVPNm3GSG9fQYrC+8i9Zb43dI0TjITE82VApZRTYF3uK4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=JYiMa0KV c=1 sm=1 tr=0 ts=6a9e9727 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=YKYambv--S9dnOAEj4gA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfXyJUop+BbaY2u
 2femwLDEvuP1ja7uNZLj1V7PzOVqFJEgCxGwZHDuDZw6ROS6dTLHfSFYJWGaADq2F9k9h5UA1WA
 6KTk1a6A7/Y6WczPH3YQt66OjsYsplMKTVMTjKsjvzARklhwcwODd5DsXgNsoQvHvUqBWfSlodJ
 mzY8dy4Wr/4Y0EPaVnh98VBFVzWTnvv8xCrCGXm9go6J21czPuoUm8Eb/yrZUXMAAGhB3yirknM
 eUrGg4qSXaGR/aWlNoiYBz2lBEzZsjeCLNwGl/S3hmF8I7kOaE14a1SRxsubN7ltp5b7eH25jzQ
 xZeEZqykgfOccFxiYFPDvIIHuYlFpq4kGNGhishLGGQEElt9X+VAUSSuFeP7QiWn7TktWFBFyP6
 EBmzscTdyhEc788IPCD1RFyNDVC5j9kHt7sjF3XCP3dFfbPNomx58xUQIR2rdyfP1EmvOEuDcOB
 ZJ5e7IiEnWlBcxtJCbA==
X-Proofpoint-ORIG-GUID: yXt9zYJEflqg4U4ktUO66RFOHw8npTOP
X-Proofpoint-GUID: yXt9zYJEflqg4U4ktUO66RFOHw8npTOP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfXznRI7Se9maA6
 VF3YtiGbd7tsAQkmJ1x3AG8fD/2g3MkHnQMV++JjC0mpwK27p0ElWepP2EBlRxS9Ntxnj99P7i5
 m1VtPRaw/bIsQfA3BAN86I6vgGxXN5n/v6Prog4rIB/IBP4s6rEA

From: John Garry <john.garry@linux.dev>

Add support to set the multipath iopolicy.

The iopolicy member is per scsi_mpath_head structure.

A module param is added so that the default iopolicy may be set.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 52 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  3 ++
 2 files changed, 55 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 1c04947d906ea..7164bc61e65e1 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -61,6 +61,23 @@ static const struct kernel_param_ops multipath_param_ops = {
 module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
 MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
 
+static enum mpath_iopolicy_e iopolicy = MPATH_IOPOLICY_NUMA;
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
@@ -99,8 +116,41 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
+		return -EINVAL;
+
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+	/*
+	 * Ensure requeue work completes, as this work could run later when
+	 * the mpath_head is gone.
+	 */
+	flush_work(&mpath_head->requeue_work);
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
 
@@ -204,6 +254,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	if (mpath_head_init(&scsi_mpath_head->mpath_head))
 		goto out_free;
 	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+	scsi_mpath_head->iopolicy = iopolicy;
+	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
 
 	strscpy(scsi_mpath_head->vpd_id, vpd_id,
 		SCSI_MPATH_DEVICE_ID_LEN);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d224a15ce9c2a..d6f290b84f7f5 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -25,6 +25,7 @@ struct scsi_mpath_head {
 	struct list_head	entry;
 	struct ida		ida;
 	struct kref		ref;
+	enum mpath_iopolicy_e	iopolicy;
 	struct device		dev;
 	int			index;
 };
@@ -40,6 +41,8 @@ struct scsi_mpath_device {
 
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
+#define to_scsi_mpath_head(d) \
+	container_of(d, struct scsi_mpath_head, mpath_head)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
-- 
2.43.7

