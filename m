Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C043ECBCA;
	Wed, 25 Feb 2026 15:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033865; cv=fail; b=j0kknYBD5Ng4Zzqs6p9ZHTtSVxX7o+8470sY6W5Oy5r9iIbzzDJv/S73DyNCm96dDHJ0Pr4UGlngJSQbT2kGsxErVxtCu/5gDct7h4wFGZAngZKHdFFgV597QMtNYs0lXskQD80HcmXn8jaD9CDLL0/PqoX9Qvgcfyg9N7+MVcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033865; c=relaxed/simple;
	bh=JYSW90zJzIADkpREn5bvpydDBGOPHMD0LKK+Z01sBZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YLZZv5i0TchExxXX+woxU3aI7U9FsUOSDJGUAEluKFbfHMLBd+IaDDIz1l8pKmIv9hcZpdbk+NDPX3Y47RwzTTxy10/3ipf+Ux6dzrDWbCnYvjABWB2lWvp5WQ+ScvI4qGs2YI/jtkx9nzxu3W+meoWYwmivWKGmUWwCNMzKLsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EQchh+ml; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ewrB6CbQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EQchh+ml";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ewrB6CbQ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9vMm2369228;
	Wed, 25 Feb 2026 15:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7Dq5gnbE59bS6pgBsIM9cRoR5XcG2ZBZzi6pFtllP2c=; b=
	EQchh+mlFXdwv+xb1u9O4oGzPhEoNwcDRfHriBHLM61JfXi1HqPGTgnKrdlH4jwy
	qfOmscqjZxcVbqrZAVbIU+Sf9wEymeZR9Kvt8qT5yG+GBKxbwv0Rf9llLUaPEaaE
	CPfGecAy+o6WQbLTlfF6RgteIOXAZY5M7f3h3rIHnzK77Qdi62zfrTp6VF6qwFN0
	74b/1vXO7cElJn54e0rxPQfx18yVRKQOFB2OgGlSmy6PMPaMcv/pJHo5oBOcHjvT
	7WhF91r8lmMp3KK6AOudNkUfU4Q+XThzUzaVij/9d8iq6oPjFFsG98e/OaYa8e1q
	lCf3qrqoMXgSF1O/ULtzsA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5xdn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFWE8w038454;
	Wed, 25 Feb 2026 15:37:17 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35nfrbe-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wXaKomZCtiV+b244nWQEF6iN0W7y+V5xZJA/Ngt14K1rkdqq8tFzol+vLzRZEpAiGumL/aYYlYC35F5EyP3O52T0zuTM1GP0Jm4/15mYJLZmEVAp13iVQFtRBD92Gh0hf8LwFY1vTfgsM2FvjTWAbXdlfEhvoOb8uVomfoJS2405GqbtSuGVi07HBnnSd5+jImfqfyUDcynuFz95wsrfz+WSzbEZr8T0MhH/rMIuFgTMcn891TpyCfaD12rGCJ/WNLlAJaiDAR7woiDH+TVeQjUEDBROh/6pw/+BktBPQImPopWYDEuY9LSA78t3ipg8qbsbjKCEf0V1dbEW3Ea5Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Dq5gnbE59bS6pgBsIM9cRoR5XcG2ZBZzi6pFtllP2c=;
 b=JUwltvjTI8A3J/vRRd1LaZWTer94g7+7yE1rg4/pqkB4fwrwgQvXAZwNfLHaoj+TlT+aM0SorD0ZKfDpla461EX5vXtfnCKKXhvGPVwOO+QbYR9fviHgrJIGd9Yz3ggxg6tCKY18lJCeGtYXDX9KwEUICnPs93SHTOsn3vWsGGrJaVuvF33MWIvs2itS3Yaic9J4Ya7zTCd97mzmorsq4i2TJZTMJxsvp6jV73fJneEpD/2ZTgr95IqOxAPr0MVhs3c0ISSuf2KzQB4SwZ2m87rqv1UiAGRE+84AVhtbVzu/9cpRDM54ydWBs2DrecEB6egANlmvQkQ6PeDHr+nZ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Dq5gnbE59bS6pgBsIM9cRoR5XcG2ZBZzi6pFtllP2c=;
 b=ewrB6CbQfv7YdUTf5J+7nTx4X/DGmZcbDklCMzTLwokFxvxZWC7c1ZuSLaMmf0BzGSZrHdMnbsRnL7pCNdofIf4jpBRii5fsVC2n/Srwnql49Avs3PHWQy495zYmYp44NA6Gs/TWZzKFhjxHqXUZBu1yHKZ3EPK/M4kL7j2G/ps=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997712.namprd10.prod.outlook.com
 (2603:10b6:806:4c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:37:12 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:12 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 14/24] scsi-multipath: add PR support
Date: Wed, 25 Feb 2026 15:36:17 +0000
Message-ID: <20260225153627.1032500-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0070.namprd17.prod.outlook.com
 (2603:10b6:510:325::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997712:EE_
X-MS-Office365-Filtering-Correlation-Id: 9276e4c5-6c1b-4b30-4abc-08de7483be88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	Qf4n6+TkdLESBtTS6TMUV2Jesb6WAU5Q6eICGdoLI8jlv4eErTfh52SnyIJtNixXFbS8Wb6XNMDqP8MCMgu+IvUJrXIYCcWpQfriujJ5kBG8vn9rKWa6Nmk2wQVr7bhLXSsROn/eDIOQXJK9CsUKLa/4ZtOvdNGiT5+gVOxy9zQLZVVZaMaRSuHOsTK0wUTojd96r9yxnW6C1ZZbYtDSRwYba+UJzruNTWZCL4tgiM3oQTkerxd7scVR1kJnSpJttSxvgY4izblUBK0e0TewK4q+uIL9DJ3THEEclXP9gr7rx/g47F2cUzHVIvpOAISttREjH+VS+eOmDXmsP0+PxTAq39upmf8nUPqpW0xQ2wfd1+XCBcTPNTND9tkRwz/DJ30FAdEH74d/KVs3jZXtyfne3g+15jLxyRDzDU4xNNTFEPT/Ufrz0ol4e2O2iIJEgKrBc41WWeO1UytYLDB3K4oRMFkXt/sHdI86j2nxBwI3pqdrKoBqHybmPA1jX0eM+K0fsAnVGyZiiGNLfGPV7grmUUEAWXRYYd1uKg3YClsjPoDy1Tuw2uhjorcXP3acyxY6B18F4xTbZBHr1oLKrhSsXL4zOuFfskEnJk7JClyguDF3OihgkM3ZGUmx7hsx+AcHFWW1WoC7RGJ98au9AYYlYDDJwAJF0URTQVnTIMSuvcv6UPaySpaI1S7/o52UA8dBw3izsUVwIDKh14PkU8JT+BGKGQCqtocYqPUCqHE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9aEOqLKoB+lkuIMKkOPYQEppZW/5wMdymS4JcV34Z5U/ylkZW6se0MU52b7x?=
 =?us-ascii?Q?E4gYirsps51xTiB3rK5AXjqiyTe/Elv5gFqsqp7sZtstUTpCAGVolk2zfwRI?=
 =?us-ascii?Q?RxcmYog06RWkPY9A4JUl+iN1X06yJP5C3Hv7yeybqAhLKxygbYPP4US6gSV2?=
 =?us-ascii?Q?D36pkCCGNelyTYpAJhHetiqyWQwRqso1ijYLRc2Kynua6PgvKflMtY8PCbsB?=
 =?us-ascii?Q?uKAedV9NtW94S2mAWnRaHSiIG60gkFCBkkXa6j7uSD3M3SzBhbRD32J1/0Hz?=
 =?us-ascii?Q?1HhcIjE82ghcXmdzmIb3LKU9Whr+WyLjaLZn5jqzHxVZpe3s8c8oojKiWNN/?=
 =?us-ascii?Q?DtakEB53JovhPRIqR4MgaaFr7TKd1aUGltKwlodVUqfIkn6ujBUCBAyM07GR?=
 =?us-ascii?Q?P3R/zAGhhuAUdSrJgSq9Vnfq4LhcuQXqIPeM+JbMf3HraK5FukeIAwducsbK?=
 =?us-ascii?Q?bsYR3zDXFLWMM30a7oWN9Dw0IE2H3SkVspjff7sNSccZzb2PD9JdnqPK3XXE?=
 =?us-ascii?Q?B1EGnNHWZWAlKXcv4fUwYDxJ9DaUMxfGE8UgR57Q5sEnDk6MRIlQJ8cXY21+?=
 =?us-ascii?Q?iv/ti3LC5GIRWHg8zrrXNUXcFF4z1zevzP4ip5OVI8tzZjbh5sVhYlZPYBlV?=
 =?us-ascii?Q?hlI4WKUUOXTt1JE8amVkIIfA5OCoCdDNagLfRIODUJXAPJciRUocdSCzHYro?=
 =?us-ascii?Q?K1ttqBBRF9QXWlRGvAKvULpJroBYR0/F6FxdJS0RgTrEvf1hz/g1EeA856Fv?=
 =?us-ascii?Q?b2GSqaKzNf5r7Gn1X6XF5Da15VqUBvs3ri24eG6tgmeby0eWpdpJ2GHJLh+c?=
 =?us-ascii?Q?xsV0p3EYOpfMqiJR0+U6/BXpJhEcFOJbR9hPOmWyrhvz1Jhbpi/CMW/Yf3/X?=
 =?us-ascii?Q?Mqtf519Yy3L6KGBKXzpybHDXQKj1whYSKIZ+PGzoso3KmrbfPPnOdcQHoKSe?=
 =?us-ascii?Q?F3Oyez2O6KfP+gFKue3HcEUd/G7HMd+jRcHMQ/7f+9tPcCps0oTIqJKdKrBV?=
 =?us-ascii?Q?dRIg+HOv463A/T/12wmBKud4YBAv5vjpsOUlD9FsQsHgOnvR7QC3QpSfiDjy?=
 =?us-ascii?Q?ZzViH9vHcLZyXKGKVoO/m0aQPCFrtxavxSyiguOp9yHeNoaiy06C+kVI6sYO?=
 =?us-ascii?Q?+SRg4zXUBNwj5BwJsz5ghw5hu+xVuMz71rfvOM3qNrLZ270uUXIiNp4p9hS1?=
 =?us-ascii?Q?wJqKV0sMjC6trRoTDL2qBL6L6NTOq/VnlIqcdNjwEL3brekmBKUPL+jK7RFz?=
 =?us-ascii?Q?nD0cm8QT12rre8Xy5AfsvN6z9xG9hpQKMrMrDAi8r652f3ryPNyyUpeKl1dE?=
 =?us-ascii?Q?fSyFbNlO8OHI8aBzj8Lrw/3W1N7QzLS/qqF0TrfAIZ+9B5Dor6bFPDWT/K4T?=
 =?us-ascii?Q?qtpftg0I/5itYpUcpbOZJgYQ4kIV+s29QmU3c0n63qYgbUKkaYOK21dPqhkh?=
 =?us-ascii?Q?XveB1LnKznV4fzFKdVBUKiJImCJuUbqx4QixhwQt0YUerdT5hMNSH4Gg7EL9?=
 =?us-ascii?Q?cU7Mrnl+pNdILzh6w3BiIkmPUZQBuSEBiP9OYDuMUffvy3WRptlaA6GPn3hk?=
 =?us-ascii?Q?irkdHNz3UehUVNDAiY2tETpNN865ScfbpeBcMx+gmL8JkqDIL3/Xynf8e2X6?=
 =?us-ascii?Q?0NV7HpLJ1q83E6kJIAgg1eVuPXg8XkP+RkodUHhX5+uuxhcaALfGGJFo/1Qn?=
 =?us-ascii?Q?neHCbBW4sDkNg4OLO1uMm3TAH1I+n9tHehDMwFWYZ8JXH5oTmbJeFhxlVgK2?=
 =?us-ascii?Q?OzWzqlZmvpuua8ZPiA5kdj2Y3xI4LSw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CnTa9Tbbq3NyPKB+fvB1J27eKSyV4q9hfngxHztDR297HxIlZgGyJXvx3vh8Ycmluue4iMDXN4gZKRkiVr0W7cM23df1ASwVFBnQ2RVpFbaQl/hNay8urOKMujretzJrNV18l8RDBHP9zrgwStm8UfwymGwZCCRFzGC8jXgXp+GZBLJ9+JifmcUFFpWME2iPUpX6zw1NNVVWjn7R9vsOYUjPuClsg1Wsn3qSo3mPt0J4ZKZPXdSpsKsf2OtzhLJlsoPWKXtPaKwZ2oUY9U7exyuothTq8mFDRaZHxkURpQ8SkXIGMr2Hevr6El+1wiXRmQYzBu8J5U8HsBuz3l8yxvEuEEmptd0K96PKIhHXhJ6FIDQoK29ULkRLWiKZY10hWELpjWtrTwOFbTjI7HbEFWwbNbk9f3BnvjeQQfNNzWVktOspp6ss+/ovp0Y9u0hTSfRby9cERR8/kck7dLbouLeVRTIHlqbPea54HOuFfc+UECCNC+/6KmEJM9EmGv4FNJTGBjj4C2VQCO0qZIXzjEfc1fyBknHKWSoB0JOjUHjaQF5UbQkQfg2G1pKPEPTWl9VcLHTk6kenMGmWGXaAnk+BEKwVlTYRl5YA1cCo1BM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9276e4c5-6c1b-4b30-4abc-08de7483be88
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:12.0907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlHTVEXRyYHuDcptQbCq/tm1BNxYKogzZaUtvKsXCo17DhNcLFJs2N8LUVIWt3XWUjpeW+Pu1uxgy2iN0zY9zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXz7X1MKVkUwCx
 zVUbCSMw4K1sYLfqF5VPxYQJ7KkJas6PtkY5MmaeUn3Q6il9iHtuyBr8tPU1YJ++C18cvr3wksl
 g0RsneYS/Ffln34yFWG6oWLeyfHZDYZ9tjT4+cPQqSUx3NEZCGiWI8z8fzs43t66aNN3jvKHExv
 93wFA7Wd0DTvFzBKODtwGW+dHx9DcTNwpfTi6naCjGzJzjjYFox/MuzWOfo1Z7YRoUHb7JIV0md
 bohAJzwL6VQV3pD4oaARt5RNMOaquQXw101QLHukLeMDqV1bEp9IYQrtrERgJQMVeAsymWwF7Tq
 YQg50mLiGDClbWze8mKGTX/03j60JImB2jHMN4UlkXDD36jfHpfbW/F2pYSBDov6OfeXx7lUwG+
 TSXR9OmDTojNtTUNp0WLImSYd6gifqaQ9E7egYRxxMeyDOeTQXuV9iM8NbpCyVgOQVRTO7c0yAf
 lWYIFqi7o7q9XCOLSYISGDc313SRsjA5725DxoBk=
X-Proofpoint-GUID: TNbIvy69k05mSz9A9gbtoQqykd1P1F47
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699f172f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=0lX8bk87CFIzALYfjnsA:9 cc=ntf
 awl=host:12261
X-Proofpoint-ORIG-GUID: TNbIvy69k05mSz9A9gbtoQqykd1P1F47

Add path_pr_ops structure with callbacks.

Since PR ops are related to mpath_disk, add new structure type
scsi_mpath_pr_ops, which allows PR ops be executed for a scsi_device.

Since PR are related to mpath_disk, provide scsi_driver member to allow
scsi_disk driver set it PR ops calllback.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 110 ++++++++++++++++++++++++++++++++++
 include/scsi/scsi_driver.h    |   1 +
 include/scsi/scsi_multipath.h |  17 ++++++
 3 files changed, 128 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 73afcbaf2d7de..1489c7e979167 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -381,6 +381,115 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device, bool *a
 	return scsi_device_online(sdev);
 }
 
+static int scsi_mpath_pr_register(struct mpath_device *mpath_device,
+			u64 old_key, u64 new_key, u32 flags)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
+
+	if (!drv->mpath_pr_ops)
+		return -EOPNOTSUPP;
+
+	return drv->mpath_pr_ops->pr_register(sdev, old_key, new_key, flags);
+}
+
+static int scsi_mpath_pr_reserve(struct mpath_device *mpath_device, u64 key,
+			enum pr_type type, u32 flags)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
+
+	if (!drv->mpath_pr_ops)
+		return -EOPNOTSUPP;
+
+	return drv->mpath_pr_ops->pr_reserve(sdev, key, type, flags);
+}
+
+static int scsi_mpath_pr_release(struct mpath_device *mpath_device, u64 key,
+			enum pr_type type)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
+
+	if (!drv->mpath_pr_ops)
+		return -EOPNOTSUPP;
+
+	return drv->mpath_pr_ops->pr_release(sdev, key, type);
+}
+
+static int scsi_mpath_pr_preempt(struct mpath_device *mpath_device,
+			u64 old_key, u64 new_key, enum pr_type type,
+			bool abort)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
+
+	if (!drv->mpath_pr_ops)
+		return -EOPNOTSUPP;
+
+	return drv->mpath_pr_ops->pr_preempt(sdev, old_key, new_key,
+			type, abort);
+}
+
+static int scsi_mpath_pr_clear(struct mpath_device *mpath_device, u64 key)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
+
+	if (!drv->mpath_pr_ops)
+		return -EOPNOTSUPP;
+
+	return drv->mpath_pr_ops->pr_clear(sdev, key);
+}
+
+static int scsi_mpath_pr_read_keys(struct mpath_device *mpath_device,
+				struct pr_keys *keys_info)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
+
+	if (!drv->mpath_pr_ops)
+		return -EOPNOTSUPP;
+
+	return drv->mpath_pr_ops->pr_read_keys(sdev, keys_info);
+}
+
+static int scsi_mpath_pr_read_reservation(struct mpath_device *mpath_device,
+				  struct pr_held_reservation *rsv)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	struct scsi_driver *drv = to_scsi_driver(sdev->sdev_gendev.driver);
+
+	if (!drv->mpath_pr_ops)
+		return -EOPNOTSUPP;
+
+	return drv->mpath_pr_ops->pr_read_reservation(sdev, rsv);
+}
+
+static const struct mpath_pr_ops scsi_mpath_pr_ops = {
+	.pr_register	= scsi_mpath_pr_register,
+	.pr_reserve	= scsi_mpath_pr_reserve,
+	.pr_release	= scsi_mpath_pr_release,
+	.pr_preempt	= scsi_mpath_pr_preempt,
+	.pr_clear	= scsi_mpath_pr_clear,
+	.pr_read_keys	= scsi_mpath_pr_read_keys,
+	.pr_read_reservation = scsi_mpath_pr_read_reservation,
+};
+
 struct mpath_head_template smpdt_pr = {
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
@@ -389,6 +498,7 @@ struct mpath_head_template smpdt_pr = {
 	.available_path = scsi_mpath_available_path,
 	.get_iopolicy = scsi_mpath_get_iopolicy,
 	.clone_bio = scsi_mpath_clone_bio,
+	.pr_ops = &scsi_mpath_pr_ops,
 	.device_groups = mpath_device_groups,
 };
 
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 799071b8bdee2..2aaa5d270d818 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -25,6 +25,7 @@ struct scsi_driver {
 	int (*mpath_ioctl)(struct scsi_device *sdev, blk_mode_t mode,
 					unsigned int cmd, unsigned long arg);
 	struct mpath_disk *(*to_mpath_disk)(struct request *);
+	const struct scsi_mpath_pr_ops *mpath_pr_ops;
 	#endif
 };
 #define to_scsi_driver(drv) \
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 6cb3107260952..cb63c6536b854 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -40,6 +40,23 @@ struct scsi_mpath_device {
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
+
+struct scsi_mpath_pr_ops {
+	int (*pr_register)(struct scsi_device *, u64 old_key,
+			u64 new_key, u32 flags);
+	int (*pr_reserve)(struct scsi_device *e, u64 key,
+			enum pr_type type, u32 flags);
+	int (*pr_release)(struct scsi_device *, u64 key,
+			enum pr_type type);
+	int (*pr_preempt)(struct scsi_device *, u64 old_key,
+			u64 new_key, enum pr_type type, bool abort);
+	int (*pr_clear)(struct scsi_device *, u64 key);
+	int (*pr_read_keys)(struct scsi_device *,
+			struct pr_keys *keys_info);
+	int (*pr_read_reservation)(struct scsi_device *,
+			struct pr_held_reservation *rsv);
+};
+
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
-- 
2.43.5

