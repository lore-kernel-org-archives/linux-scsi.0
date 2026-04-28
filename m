Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AB73AF642;
	Tue, 28 Apr 2026 11:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374926; cv=fail; b=S/ejeD6Zn7YHYFcVQgWMUFqRGn3gmcYIvlLyWc5YrnPuIhD1PiHWatwVyRyNyt8Z/jQm0Pyb5ilIjuXhJnJH4POoD3VeSFndY7uEAUYQoTe+d+jg7STTMPzeEWlU8bcIQP19DJbQ16KA+5s0itzLCevhrzvFYs/IP/fZ6B2ZkRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374926; c=relaxed/simple;
	bh=1iT354fg8sTj/fosT5qwelGCUr1wRWviyv7AvthMisI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=q2rrUn6WpLLZUXRGXEEpnn/MiNGCTAZ9BqK7nXZkMKGHRpIB+9aChQSRTJMFc0+CVhSTuci3t83KJ7Se5kLkxW5r/BmyyxWdo6FHgYyZAiLOKGtNz+bSYM0cFT5ieefyxgReNdYcCeNHRoL6ft4ROz0mKnmq4rwqenZVyb+w3+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i7S8wT7h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HPhsZbpY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i7S8wT7h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HPhsZbpY"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9limk752815;
	Tue, 28 Apr 2026 11:15:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=5SzVBS0SSuTw3Ugy
	NXLmDZh8I3oQ7YVxX/B2lQ/5CZo=; b=i7S8wT7heBGK/C4h1VCWaXn+cqwTh+fV
	C8rXoYmkV50OT5PedDaHuXkJTZMAES8JgOlUYL1M/xsa1tiBArJOcJhbUPekc/hU
	48UJ8SHmcyFUXsZDXTqz4xdohLCniB5JqvuNGsK37NcCsPqmoO/1ququpYcWmvGu
	CZr0A0rHnuHJItauJ4PzLeahLBW6sbqGsBeaEro5wXHNFOBEO7K/eXBHzBW7/XGM
	SKu+bRS8/s6upiE8oz+BS/jAKV7NqjfP0akjU6DEEc30gBPM6Lfvm3bM3B26NlaN
	VhcbPQuDEOOO7YW7k8GWcjM01luIPgjs92nCRbkpkSfvrJPnv01b2g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnefex7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCm1X038743;
	Tue, 28 Apr 2026 11:15:05 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccmrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D1Zt6yC54Qodb2sF2jcptak6DK2zQe0s70g13glbFkJVIYzy0HVQYzluTDwDWvEsCAu7oVbaoLpvKEF9JGdCdP4O/1RlRB/BMqjvONHiZxYnH2IUDSsI4NkPmKfZ1o4BoKV6kf8ENuuJRj7zQkTQdTbAApo1dgh3stlEdeaRRKQjihtOvCJnh0uGBcR3KV3JAqiFEgEFxsYG9kEVqeZ33V0is1dr79qncNMqKfvgTSNE5aA/Tvq8/1bCft6PCs4wO7fAYejT1hlQUXOW3sIDWJRqpp/dikmoQ1ICn6onONn1A8Xuv4Ssj+SvN3lUzbC6vuP5uSEOz6wkbuc5cKm8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SzVBS0SSuTw3UgyNXLmDZh8I3oQ7YVxX/B2lQ/5CZo=;
 b=cg49sVvvlU7MHTPkj1/fZV3V5sqnh4i64Jm9bdoN4QaUbB7kpSbHMjiYO/v3oNlvposHUJVaDGrpr634PqRaAcF7MXZlhSpUXlvIqhNjeHk++XiIJDJx04rxBc2K6kThBO1uIUguaehbo/sQ7IjnGODmq+iEaierhOSn6HkJI7nbLzznw6WrwCbx+jHi5wNNJFoUJokycPu5mldwoOrPsXaqge2hMCqINUCNJZTYcrlRlfJOl0vi75YY9oFJuoOEJZ02hdT9UpbCjNGMNOngTJ2T0RgH6IRSzq7wvAxH+KILMjTOaRnWyjgTGGZrUVwGDRbhcxaqz11Fdkj0QyZftw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SzVBS0SSuTw3UgyNXLmDZh8I3oQ7YVxX/B2lQ/5CZo=;
 b=HPhsZbpYnBrYBRcuw8kI43gSE1JSXpgb8+nAdVPwM5wdW3zZB8UmodkGnrSxGpAd8NJGYpGmkdvrhUPCeSmgIHXS2y+RsxMjifNgkLEVQIPsXm9C/ShGW2acfOvsRqRZduZV8Xy7/mL/ptCgG8csSWQi3OSjuizxctQIQeOwcGI=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:01 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 00/18] Native SCSI multipath support
Date: Tue, 28 Apr 2026 11:14:29 +0000
Message-ID: <20260428111447.1779062-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0097.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::38) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 8389818e-b323-4f22-e700-08dea5176427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	+3D/T+1Mpo6sPDhsppI0yKYSydJTuz3+nFlRQvnTumrc0RJJDNdUiLe2sz6e13a/S3SmLHZtCgg+OqAfzJEu0arBs2/Mj+xPV+z5SnkhxD16EGd2X4mOgP3yM0jbcbKXdP/TM3sQ2PeKHSCkIYl7Xhkkm1qnU7Eyxe3adJUvhNtrS0Ar8teY3wm01Tjd+ob35OIfQxR34hSgPWIjXYans4tYYbBSAd+3sNUXBSKa6Didn/Z/wzEJ5q7TIqOslNUrxPG2KBWj4HRL3VP62lv4yvXaa/rptdD02B7bdS8Ay0Xjzd6zRVkY1tyMjqwbAYR8zis1svwHn5QEipIUKFGx/IupQvlKjIwNoJIx7U9XJbIaJegOvXRVUr/vLr0zOhzQwCqCsn7I0fDAFOMQWlxJfZ4BsRATJUKc0lrMvyGBdxsBrpu+yqdsNR0XB1dFNtAObZZNG12KpIg0JjCq3MQBy5GBvvfDRBG84KzEwa+FGKcbIW1Rbao6Unl8uup08w2HE+L1f6V7eEy/tDruT5/MeKJJ/cUzxDjtbQkgOUE/dfUu9Qdc6JWEwtOzeiPBmxzGyIz1YNt6m0P5G7PLqhMXxogest/ceFTvKcemJ+Z5QN4V1amvu8f6WqSRTmSZcpL7pIM40D/lWmawGcDSPyRDgOS7Dr+3we/Y2zcGdS3VZ4xh0hq6O4pl7TpoOxqNryd+3bnMZxzvGfzwVgGSpkAiFw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7QYCl+I2cQ0ZlmgDOfUL+nXTuqBaSSM8TZ8MKdXbocQ83MfW37ixM0BkmKXZ?=
 =?us-ascii?Q?GKQJakTTg+wQvimRJrExWW7h+zQftJf071j6y6hn3TDneIV96VCVBSw8sDZ6?=
 =?us-ascii?Q?YilS0JwlwaP4HI4nqbtPdlbF9UWCLJ9sEV8auXkbdinR+QWqqCgYOk8NAV8a?=
 =?us-ascii?Q?DGpCegDB7eMUTdd+Q2fXC6P+HiR0W9rxAp+S9EzNvFJRU2zOaftSQl4E01UQ?=
 =?us-ascii?Q?wtzcuoFN7dIWWNu5IuEkvpQG7iJDja3LTXxlwB4f5UFvMyatzsrcjdUvnMYI?=
 =?us-ascii?Q?HB83sjzAEaCS9ex/tCkeBdVzjCwWErS6aULw5XG/mCxK3NgpLfUsgPvKuDeD?=
 =?us-ascii?Q?6nr2h+eRhGOhbOMQqvuShlz/OBnPTw+AqoW4jc8lutKvMOxcGoF7hsX/095v?=
 =?us-ascii?Q?bsqJkfeO9iw9oVpcnfhcpB9GLfm8WbRkdH0ZDWetE7v8cudQtT/loCE2KA2R?=
 =?us-ascii?Q?2UsP952iC4eApze0/YzvQ4C4ageLVJCtYpx8vaxHOpGl9ThXdzPMWQ1oN2UA?=
 =?us-ascii?Q?npLjnHY4FZXUGgn4FjLGeAgOrgPNmWGWrxFCgB/hnrYqw9VILVpvt2RWV7H8?=
 =?us-ascii?Q?IegjUsyx/AFyfbng3R53jngkONVHPXjemCXTalXGi0B9AxwFr0k4E41b7YEG?=
 =?us-ascii?Q?NpAmUVoObU1jYW28lkFEO/zGGUuNdPFG3ATA4yPG1M+T3bn2VpIN3Zz+jiF9?=
 =?us-ascii?Q?k9LUXH8fGJmKxLX+G/guxt/u201I8hjyALD+CGDwklCJgMZrnP00xJBgSzzW?=
 =?us-ascii?Q?RrKQ4l1itmyQEdmhf6O66TaB2CWcaJFkqJVyeqzJZgTJXLPcsr8xwqt9CKqP?=
 =?us-ascii?Q?MA1rM44GqiDrC2d9qWy8x6xbpuwEXdNNs0rneuVuDI6pU66x/lfb6vzGDSEA?=
 =?us-ascii?Q?cNuq9zMlzBIeW5uTZxHchIkUUDz95SC77bZXtVNyl3Pez+W2UgbABsCM2M38?=
 =?us-ascii?Q?QKiqzaA453s3zan26FRN8Ol/zhGgabK7QpdO2Bd2H/vX4iE6Sr2ZYijVoKR/?=
 =?us-ascii?Q?Fo4KLtWV9B8d/prq+8F3K/+NyoDzfCTFwWNtVjJ/B1v8yknq48rM7zqD7Eip?=
 =?us-ascii?Q?RNzM8PqmI0AXH4qIaNIK3O+miqs7wMMtyaGWZ/1lRPx4DWJID+GT+TNdNvF6?=
 =?us-ascii?Q?n1MDDigF1rO0oloxfPlYk4oAl4cgb5O5svTpUC2PU3TmU+W4IzzafXFM2I7D?=
 =?us-ascii?Q?pmsFiywwjBiC5bBwgh6A4G8ve7qeltkuiPnENuqGwsIw+mtCqYgDFNTlZwyB?=
 =?us-ascii?Q?eSsOc4EDY4+ii3xbvYXyDKLxLdQOegflXZvTA779y0sRJzmKDOdl65xCuCQ/?=
 =?us-ascii?Q?L+fOHkvKCkM/g6ffj/pBiQI1S28bEmCd4yJyli7UmSRqowIePJyBINR8qKyV?=
 =?us-ascii?Q?i1db4bjurqlgvbxQ8R7tPPbT7cPNgpWMpiot4C1jWHhZXxrRy59bUPoAR8wt?=
 =?us-ascii?Q?L6Y7qFNsW7Y+D+Chvv1zajRWuKF+ZxZhDqMJNeZvsUKJ5Kmu8zcs38UDOwY7?=
 =?us-ascii?Q?ZWe3t7guN/kdUn6Q4VkBmLxu2wnHQV4TgIX3wr1CNrYneVAz2Hol3t9uj/0u?=
 =?us-ascii?Q?kbUDh1ZSveMq8SzaeRKwb6I/HfSEHyrGK22I+s0Ns1BoSxZ4HapzbRs4mGIN?=
 =?us-ascii?Q?FvX+yvoRg0XVBQsYureqiOifE9JA9icrIfFDdf0icDSAjCp4MbjraC7SJJHG?=
 =?us-ascii?Q?+TKmGrKuxo/1+B4OJvv/jjZEB/SqXwDjiOWBV9H8TWykLfOYLFdRDCdb/xUS?=
 =?us-ascii?Q?kKgH0oMT/ow7PlVtoOGlyvKCwNHyIVo=3D?=
X-Exchange-RoutingPolicyChecked:
	m5QHk4IuimR52wKJUJD7vznJckvNnjeLqZ2oq3Al2GQ9Kgg1GWpjLG52fKnNVJIzoDH+fwjy/Ft0HRVMZEC7SjnA2BGJt89u0QVP5zrgpjQsP+jUCFuz7u2kSzjQeeQCRfJv6ic1RsevLIYLg7nVH8ZE2nsuhuTdr3N8C/7S2l1TCsiBkBvrQU4a/6i3tkQelQzH1ynEoXtuEJRh/WMZ02S3q+8DkguyesqhRg3nbAsdtiDgOedpmNUK8tZzhjY6uGUFylQ9fnpoQ0PFBLztuTdV+xpsRdNQqSTGov8AfvxDePprtLZksDX2B+E9+YQFt5DnWaXVtFGsBnyf0ql+rg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	10cfUfzbnTLKoTT0zJirCkSHcrvMnkKennO67DPvBPMkiEjcdx1b9gek6TH5xuVglQOdALrGPNe3kNeFGKWL36mwFoqpLJS0dA7wxSaAXQPG9kbaMxP29Bb10LfP66XfX8tvYejGSS9PPkS+5S/y4h+WF2rKFgTSQr2nEKiqW4dBsSQJbnlt1r+7+QZsSItupqyzmGYZTzhajWtOR/Pa0uLM0UdIjRTjGZCI6ixXyszoEGcgyVwKs9IdrZBYtv8aq3YsKoPtSsZULKwEatbPCJsQ3unn6BWDY+TZ+6cABcNH//q0p3fpUGR5klNjVih3UJ9k5v8hZTWzkaPsmnYqLW+FX68q/pPX7VRgzNypHPwQUQwcoFXnl0O+bbarJ0/jS68o4l0NLxnV7ylFxN11cmJKCeieIkz03XZegmNe4jgzHWwC/4BJ9oE26hbfymsqysxifbjTepWsg7VvmtDRl+5spYElZdcTjNOpwL3ba/XsB1kRc/TzkPfqIbMul7AXqsbtzmOoiK81UgRyL34ljKCAQhyBlxxJOOeCQceNirmWRSIAhAXTFw6K9P9wTW0g7vGDyULEM22ft0b8toYO4WXHOgsfFUfkVf12bp5WCWU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8389818e-b323-4f22-e700-08dea5176427
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:01.8121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hd5LQ5Suck471QlDHElG3KQrKTvhQAn6qSyPdNBHg5hUlWq0MsKv8A5OEkVEGMDfFtnEbk+iQSqnl/0HqxAIqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: 9bs88BIHmLInrzMCa07SfP4kPlCErRvr
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f096ba b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8
 a=nBALzb5hNvmWw0m6NiQA:9 cc=ntf awl=host:13844
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX+8LjIcZJ66Wn
 E/zNnCiet9pgiebJjDSbxe3aJqIZVPt3dFo+3lXpXAA6CyGqtRrd0YWDMHYGiWwzX6Smso+j6kf
 Q/NPI5BRyn8OQsHgnaOlbZpMvJZUnelsWDOr6lDCAa/cwwJc5PvJWZmGrmLHt7ywZ+abMuZeL9t
 USAWgaJz4zwXjb6X3KLd4fkLJwKuzY5znTPNbp9lj28YBX8aHKeP1AGTupUljVkh/HMUvgKQAvR
 6Y1pgaPLEswp5hpKMKYrKJKj/nx40tKIBPZdTxNDm70/YcuDjAuvtbEkH2wdo0PeS/Q7yfm52wx
 cx0/CAVo4n+VQ0p5eti0hl0GmAaPIQEzqpnK/+K276fF9aO4uWSc8yiT0JZLdTJihEWrLhjz2zF
 ZrzVcFFwvUpslRIrINCH7igFvQMtll5XhOvG6Y5CYSpHdAmQmTzwKqjjcDoryeyecKybfufdEqn
 S7NM/q+vG4C/Z2aG3qaHol9/4G0ca7u7E/ZfwTVs=
X-Proofpoint-ORIG-GUID: 9bs88BIHmLInrzMCa07SfP4kPlCErRvr

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series relies on reading sdev->access_state to get path information.
This path information would be provided by ALUA. ALUA support which does
not rely on device handlers has already been discussed at
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
and support will be added in the next phase.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full (for failover errors).

Full series also available at
https://github.com/johnpgarry/linux/commits/scsi-multipath-pre-7.1-upstream-v2/

Differences to v1 (apart from porting changes for v2 libmultiapth):
- drop SCSI_MAX_QUEUE_DEPTH and reduce bioset size (Benjamin)
- increase SCSI_MPATH_DEVICE_ID_LEN (Benjamin)
- mark config SCSI_MULTIPATH as experimental (Benjamin)
- combine modparams (Hannes)
- rename wwid sysfs file to vpd_id (Hannes)
- return umode_t from scsi_multipath_sysfs_attr_visible() (Benjamin)
- use DEFINE_SYSFS_GROUP_VISIBLE() (Benjamin)
- fix scsi_mpath_end_request() and blk stats (Benjamin)
- change scsi_mpath_device and scsi_mpath_disk device naming (Hannes)
- change locking in scsi_mpath_dev_alloc() and sd_mpath_probe() (Benjamin)
- drop struct scsi_mpath_clone_bio (Benjamin)
- don't use scsi_mpath_clone_bio() -> bio_alloc_clone(GFP_NOWAIT) (Benjamin)
- don't use BIOSET_NEED_BVECS for bioset_init() (Benjamin)
- drop PR support (problems explained by Benjamin)
- drop failover handling in mpath bio completion (Benjamin)
- use sdev->access_state in scsi_mpath_is_optimized()
- count queue depth per shost
- delayed disk removal support

John Garry (18):
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when decide is blocked
  scsi-multipath: failover handling
  scsi-multipath: provide callbacks for path state
  scsi-multipath: add scsi_mpath_get_nr_active()
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: block PR commands
  scsi-multipath: add delayed disk removal support
  scsi: sd: add multipath disk class
  scsi: sd: support multipath disk
  scsi: sd: add multipath disk attr groups
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_lib.c       |  15 +
 drivers/scsi/scsi_multipath.c | 658 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 560 +++++++++++++++++++++++++++--
 drivers/scsi/sd.h             |   3 +
 include/scsi/scsi_cmnd.h      |   5 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   4 +
 include/scsi/scsi_host.h      |   4 +
 include/scsi/scsi_multipath.h | 113 ++++++
 14 files changed, 1376 insertions(+), 21 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

-- 
2.43.5

