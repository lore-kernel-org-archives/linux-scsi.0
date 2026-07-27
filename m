Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B18720E023;
	Mon, 27 Jul 2026 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163451; cv=fail; b=EXKckAkEe8zt9Qc3+GSVX6+re3WEuZi1weadD/fF0JGGsAyTypOfi/56eVXgrR62G7IORb8SrUFpq1hovwq/4qdrNerzC+4W9kBQ95Q8iLp05fsTcWLeEmXRyyqR7wQBgeNqKqUqTpyshqklNaddQOwcZramaf56eUgfs8tnmM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163451; c=relaxed/simple;
	bh=/dDdFwHA2Csoh/4qies6nS+q4D2ElQIZvKNNTuLprCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T6bzm/Glvq8b3J9YzjskulCZ1beL6AuhduVtqEMd9qgxSw8q/6cRrJU6XWzGhWHKm2LotHW93gizlOap2jbMYV5PXOSFdv4V/vM+9lq0MLd5IvL7F3HE7bPNxLdX4ufCs6fJaZ2cIiJ0LDRzVJyDvIdRypSWm0SPo5TFRSLDk6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VpXhw3DS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HIFODH6D; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VpXhw3DS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HIFODH6D"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCUMS42052923;
	Mon, 27 Jul 2026 14:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3enL0/aRIV7DFpMgFXa2Jio+36WFreuM3lK05CxoLWU=; b=
	VpXhw3DS2eOjBssTAjsjobkTn/+uFqsBZ6ImBGyWod2g/1+DhbAMCYlYh7QELVfU
	7+Nic77LXYvaI2QNYjqsRfD74UB6cAkeNlMJQVUVkWlSBYm2Zrn7BuGoFO3/8y78
	59bx0lacmrskzIyG6iC2/3HldGttMCf50KFAYy9eGgwm9/ZOJiT12BRUo9ooQevT
	7Mz3QPEmFQANh6NUC57O1uQAGYAUxnj8UhOuUv7Jiz0uyHi1BApSHxSZCXAuNW+s
	J19nEBw0W7rOaeLUS/TAziCAm/dheAE0v+6hmxkTrdO2ITzioS3PCvKw68c0QsDe
	tg5D133/xdm1+aOaSDESMw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1d9xjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeapQ021472;
	Mon, 27 Jul 2026 14:43:24 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8gewqn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QIMncY25SgJoxFZl+PxBcOOaD5jQ7LD44fdlNungQ3mQFyl65yCWixCzbd6EZtTnIgh5vtMBI7lquzCFyt3vs5qNDZ773zB7HsJtOAJpJ769aGZzW1L2thAb0UmyBfgyn3OyEOUixuRS5saupNL1X9c9NIjxoxQjiTsoeFUty4oKD1IwtE+58orUWE23ugkL8xTVFYgnvxOaKeet/Y7yPs2d1e2S+GgCht4Gq8CczTW5bcrXkifrGr2A1ir3higwk0OkjdrfeqrHyerZuJU8TtG1H9oGWiX6nCy73EZ1CwMTEp3itr2297z4DddY+CcOvGVfdH5fwWNJqStL/zUuUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3enL0/aRIV7DFpMgFXa2Jio+36WFreuM3lK05CxoLWU=;
 b=sI+5IN7P/mDOiWp87k1jAye1Zsc381YxQe957FB9FY0EwzW64Pp0wgyxD7v2yYf4sn7TNh4xqlEOrW1AmyQTBISp85iPCUfzYQmjchfcwjbWawomK/ZMO/zq0f0Midmklig6N50Fhl7UNZp2wnjU2sqUprdKWPez6cG3BlS4g+X7SHT6KokuIYsTAIuFFG5BiGfm0WGXPxY25wM1oXBvB0ihixOl4H91umkjUpqrQDSSM1izeIOTyOSOSgQ5ny6yWimtruUA7wEROYWk4O8qqV4Z9ba1o762h9UosF/ApifJlzd5SuXvoq00szeyn5RsKnSfdLGRmWRx2mn8Y9FitQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3enL0/aRIV7DFpMgFXa2Jio+36WFreuM3lK05CxoLWU=;
 b=HIFODH6D511V5D5gCtftjDJODDcbFF/5DAUxL52WCTSmUL0bXT7FSy4dUuYTp2jiJYetEmwo5clYvPs8gjX4E46n2PoxBQIUoUvMFGkeUiMDFtcmQi71hnXv+UKMB1WQoNmUWVYEllV+9HSu3me+oJFbguSilHY2JEy9vGkj32Y=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:19 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 16/27] scsi-multipath: clear path when device is blocked
Date: Mon, 27 Jul 2026 14:42:23 +0000
Message-ID: <20260727144234.3802948-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DSZP220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:5:280::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff6290a-2396-45cc-c361-08deebed6645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lhMIb+ej+toqkZQYUlCUBSrv/5IVWJb5bvD8kO31PB3tvtfOLgCVetrlYjXNXQbLRx6qXrmFY2ItsMyDJUuF6qjhZuRF+mZ0WE2KrwdxmM4lAy1cFvOUg+K5CDHwxve4nU7/ZnxpbL+eigQ4K3maiPQaYNH6FeignTrQrdv/Xhlm27/Gvce+JxGwiS2iDNeRgNsWqT1D7q8JBze00p7eXZ7Ffz9v1ZlBRbZwLO4acoCjna0ejD4QR4bsKaxg5wnoQcWDit3PgCMJhjxJmTOL7QlqytG91d1+yyODhzH/xLP8bAwtfflvftBANymJ+IoJbJNrcCX69upLdRHuBBODI9jUJa8QzizpbsUQCag2CiLo78oxp4Al1WpGqXm+PABze0Kh82rHexIviec4gj4EBHAUIIXAGV1ATH850bBmPcqRag4C2KDb7rhTJXeGprEKOjhLXnriCbWNgHMcEcczJ4W/vqtGLRP4dmINgxPs6gc3NEu0OYODvHJHLkyHWkMbxJViDkeKKkg7lj1xHEWo2FIz1Jd/hLrS2GH/Bi2rNV+z80BrxkjHsBakILu3n77+/iuWCPvnjhDKiOuoCniAF3httu5fk/QoN441w4eAgA1cDw1sifJKSEwgVWvN/KzDh4S5/L6BRl03fm4ZzcFUXJ+vLshvvYDZGYBkqA3VLpE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hpc15hhXjWt/rooPzJTismtmR8hb62/O36Z9JaMXLnC7CKjpZLFn9F8M7cMj?=
 =?us-ascii?Q?CFD1FAoFXRwnd/IS6im6h/Km5+QSkLhKYpiGALgtnVa5ooMaCoRlKceZ/6no?=
 =?us-ascii?Q?Iuz6c5e3lRaw+B227TEvxoFcUgp0hzr31pRT82NxohV8pI1ohWQMigHij0t5?=
 =?us-ascii?Q?Q/oI2puYkpmh/8WqP5lpc1ivIY9eES1RUD9GSYERpgh7hmt9BkaPlMo9iKNu?=
 =?us-ascii?Q?ipM8tvqDUh2p4bdHEAyBPN46/ecCGXbffv4vigJihoJEVgbbI7PDlUyqducJ?=
 =?us-ascii?Q?E6UYpMniaoiv21zOOdD9utbsySyA3AWvudvxa4vlzEiXXDJU6pW1wDi2b3dY?=
 =?us-ascii?Q?t9mF1LiiFf0LJGX/UlnoRLYPj8zkZo9+v4xoCyVF1M/TUU71tHU0DtHujuzk?=
 =?us-ascii?Q?TcVQlA0Q25kHYlAL4vOdP5I8HjxfB2KjinJtTkq3kkX73wytgC1fimVuzTop?=
 =?us-ascii?Q?gYJ2LhRxk7kFpCvN8/F8Hor1lcD9K4a0R9B8onljkR4JVazYRDbVzjtVnQaY?=
 =?us-ascii?Q?RTkzTP2m3XBRuzDa1jmuqw078YgdhaPAN1Wn97s+qBz4pcYqGjSkM3le7hJa?=
 =?us-ascii?Q?8EasVmJz9hYgiU6RzIrasCdfWgVh/QoHCElgl4LAA7pPlUfe0+aPhqHepwjZ?=
 =?us-ascii?Q?XZubIHpJGAsdckOqw1opM/8Vp7HfDCiNJh/ueM0YGOsCssa6GA+ue/bO25Vu?=
 =?us-ascii?Q?/md7h19yUI1EQyqOMkEWIHYwsbcx58VVHHlu9HcWgpKno7Ti3nCmJnon9ieU?=
 =?us-ascii?Q?t5OqsYVccgglVjeXfWz7Q68Qg9bW2xxjEPXarpsPYxRJeL/JFRnexD4nT/0E?=
 =?us-ascii?Q?lC6Q5cz/dmkR3+7vjK1MHFP3kX2wBVS6RjfIJCpY7CTB4gp4zoPii73G1AXb?=
 =?us-ascii?Q?Wn84nH0AZNABZbabhClyyyDHiqXyzHeFd49+WCEq9ohBZQV6BDHxA2D9xPkL?=
 =?us-ascii?Q?Kha6sUaEM8/jVTH09FyoMFfnPQP4V1aLHtWoJEEZ8eG9FDyqkfzLDYnJ84ll?=
 =?us-ascii?Q?YRJ2++K5Sp0zeYWJhQNgQ1PWcgGSFsnB6oc9Lw/8aO+u9nWlYjiabakS6y/z?=
 =?us-ascii?Q?hZq0SOnpP4rcagFpqJ9ruyFxAtyqAaZP0910Z5UHWRiAMDIui1NoQnu19LB8?=
 =?us-ascii?Q?UQChjH4KBpiwKdWeTdV2LWnwuEtIZZcrX6faeSLSBTOYdX1VeQnTUyX2uu/r?=
 =?us-ascii?Q?PflEVZuUOlhWOd+4jX5GdhH7C5YyJeCwR9Yz8IGL6UOh6+HAdiVtnBBFsY7Z?=
 =?us-ascii?Q?wi/xCIR8JyXNUNDpPW0cx6FNaxP1qxZNW9mooyIxC5cXGUg+XLx1MGhEEr2+?=
 =?us-ascii?Q?FhrI9Cwz+N2M6gV9d2EmGbpK1kf80HCJhVdwb3dIzS1s8MKpLdFeEYijg0VT?=
 =?us-ascii?Q?e6F7q+5WzrQhNLOqcntZ7IV51l7KGui4+ZuLS1PuRmCL9VhAnnS47ZPFyFAp?=
 =?us-ascii?Q?3C26k5a4eaWdzb+8ff9uId0kozxp3P3Q2ZqQp29ddzXD/citUSfCly5lgrLj?=
 =?us-ascii?Q?0OD8cDaoJb/oj5UV0Ty54dg4xt+iA9pl6aWZBJhDlFZDK8l0CGHQmSLUwZu9?=
 =?us-ascii?Q?kYUeQKcBbS27OdYLc0o0uJTx9P0TlgIFEofwq1APR3bLAIS8Iq6ADr2io115?=
 =?us-ascii?Q?3PTCjK029ldN9uzIpiBRphvnj/WvY0jtv7Kp19o5K6yRA0ksBwBPEpvJmxn3?=
 =?us-ascii?Q?peMylfsWBoAwvCbr3qgJVJgewqIfbZ2IqccsIuL+ePpcbLezDZaejTrdexxb?=
 =?us-ascii?Q?RpNRg7lGTTBu/bgFlc5mO0LH8TCejhA=3D?=
X-Exchange-RoutingPolicyChecked:
	g53SmdI7tKSjry774jgxmUelK3gqWxVEOtV0uKDlhiudAb3NwWtD5fUjWki6C6hhpzY+JbAUQgISEs3QnsZpjzagAkSWbkpIRvRVQhnAtaL/fQmZlf9DIF3PwOr2/qWRTZVKsB2DfwaSZ7A8oWD/hgIJYzrb7hBOlARpW9tVAvpT8Fqn06PycghA0QNsHkDcx64n14heazFigdb9nfRDTSqtcgIuUbuRNr7JdsvLOTgj2DxwHQFN4/PHJkN3ParwEreMjRVsuYm0JejeoEZeG9ZJUMf10OZ56PK1my6SFA7B4PFRaNSaCJHm8Q9gEDY1kKK46Tz/z11WHQnMmYdrIQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g7DwSrb/vYZlTBbrKR1r/u2IvJ6aFV9306BbUa/JlP1GGhVdU3/1K002nBKjUCp06LMI9TUZW2GVOgvGrD+bocbNW/53hQS4H5AFZvue77/OgNr6COEhUdXKXd8V+Vcgr2XxyLiWthXY2ifyVVJVleD/5CaZSYPJGZjRdUstZ0V4gp9tNvwRjQ/NcRbluJe6rgMOpKUkwjj75lwZR/tLxLvfLt8Wm0KFcEltuW7NeWp9bZpqrUVe8ux/1tuSKzWwGsa9Qeb9W6JW8JvzBFFnyaoyDFK4GRh/IQ2U14QTsfSpspJBsUPUccuDeDk3MYgxQcerROb4w5DxN0xa6ugA54rCdQ/IfdHY3KSAYIfgubzQWEE/Ye5qV5gRusNDZkwylmfkNqAIVgR5qcgH6rD4AsdmIU8B864rYrlpD77dVAhD5qnbCAsxGcPCrU8CbL5sF1xi/do3aZ4OF5Wjbc0ey06WPX+bfZ1e73AZHD+tCj02UldMrrxhVA/u4gNsf6kkjTGnZ9q7HaF0f+bdB5ccQr2UuldlP8tpur43gYGjWjcBZDkrAY2CBZJvsIhhAboDhq27cfJqmuVbnHTQuntCpluxKGRkszhxA/ogjiDYZZg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff6290a-2396-45cc-c361-08deebed6645
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:19.0816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2l91RccxStOhpEId46W7pS+W5N1T3/az2Vokzjdle3Nu8mGjEnNZZyw8VJJUlFDhQDJVWaqeHN30heShxf3/vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-GUID: LvLGiq_AFo5w6kVsZ7sBv5Ynvigp-30D
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a676e8d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=Qos1PIJNDAoiXpueWHgA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX4+3kJCF9lGV/
 BnT0BofKrn3RhrHDgDNRdgxn/IMwYAq9goQx2fu0zDbfVFILY8J5CM+rfCkQeqxuViJGPy2fFVh
 7m26RFvmt0JZfyyIDKtIV5IxgvJPCLJw91E6gZooB8KiTj2a0H3O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX8fZzeilOnPMS
 JP9IUTXWivj4AesSGKzflF/WAGBYu84d/8xLzOx4Kz0ea++7o4XWeyTjM7mGxv2YgHnbHySNUdr
 b3TVD1PcV46EgMzngUIf9JFdE9r0aio8WzDktgd5qM2UusKp+zyzQXcr8Kf8CtTS3ZvbnikL9No
 J5imq5lLKDB3RMWwukdBzVh+fhxaDVY1kXjCQ6BrKxrt8or8nLXl8oO8g6xYc5jUmgzqNNXHDrL
 9mS5ptqFa8kK5YFWYv8o7tv/jHS8tHmztAHlWeyNefb/qnWNg9JyFtz/E8QYuoaXNSo6SK9n0bK
 cX9ebG3Pv/3Lcc0joOPgp6QMq/5W+GLSl6Uk4IjDd3h6nlIr9AdSwxToVZS+8wdB3U4xeqFoChS
 Wm+8dk0XOoYaHcKRHPLJZZTJ3DOTzXDrNO7PuejisZKCxxDNdoUEus/kp1fVOzPtncdYqmxJU1c
 Mp+FL7W0zMSNsucsChRcK4nMAFC3pZnv+49hGJjw=
X-Proofpoint-ORIG-GUID: LvLGiq_AFo5w6kVsZ7sBv5Ynvigp-30D

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 10 ++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223440d..e2452392671f5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_multipath.h>
 
 #include <trace/events/scsi.h>
 
@@ -3016,6 +3017,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 		scsi_stop_queue(sdev);
 
 	mutex_unlock(&sdev->state_mutex);
+	if ((err == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
 
 	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
 		  __func__, dev_name(&sdev->sdev_gendev), state);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 5999c59bf7297..801d95652fc6b 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -231,6 +231,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       if (mpath_clear_current_path(mpath_device))
+               mpath_synchronize(mpath_head);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 5cc37acaa664f..8f58c44d96a77 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -54,6 +54,7 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -88,6 +89,10 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

