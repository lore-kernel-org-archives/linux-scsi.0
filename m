Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C072367B76;
	Mon,  8 Jun 2026 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780951120; cv=fail; b=mLysrPwNUmW1POX7WobZV+tEoTi4Qz1TH6WaAqwNGufFFtHKWX1xCe1E1um5a9dGGqRlj2omFOXnCXRbTM+JtZIdGFzR4nFEqxkVGLPpNA0Evo+lwwyZ/onSsMjK3j/UxPNxERj5otvhySGm8xzrh4g0rMDxmBbqd2pwMeCS9ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780951120; c=relaxed/simple;
	bh=IQETdfsg/pdBCDbJ6rQY6ZuCRCwUh77iT6wl7clBGpk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sCZXtNgGQMRJGh72E3Cf8aklsB0DhdOm3iOShcrhX6SVRsjkNC9IvPzQ5ObEZutkdYitNB5DCyhgCswDjy9MjI0icSxulv9kB4zuySA2mm0BRU0ZyLDXfrqTrCKq7nDMcnv981ARc0fF3nVZbSO2L4kHFrm08VQhGo2G3lJ4Ypc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Id5zvG/e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JpFacc75; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Id5zvG/e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JpFacc75"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSkEE3977699;
	Mon, 8 Jun 2026 20:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eG9NDqqjvbL9Dc3DXN
	Chuer48mDqxbPL/Aqt0Relb58=; b=Id5zvG/eveJ/0SAOScChKnM1l1gKnFN+NF
	7p9+KevtSJF+myHp0ZurQRWIs2LLmt/GmqIOTCH3UrztzI+L6SQ1SQl/oCvPLUCI
	WSjf9DBnxYM1WnQoRNNbSWNtQL/LPkfjwTGxLjeaQdrcgrMxu+EvNkR3nmNjhp/w
	nZ/tq/KZTyEm0KzFrgU1zLl3leT6Jops51bx+DZ8Yaw1EvttFdqVr6bUA/0ntc23
	WgRqzG+SM+VE5UJoitvez8OB55Xe5I2T7NZmoujLtexaHntrgc0UWln7INGz8ttf
	ArI1lLMd7cqVOejeW6ojhkA+gkblZazUfftSmf2p3iYX6huxgyMg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embkjb7ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 20:38:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 658KcWwm039283;
	Mon, 8 Jun 2026 20:38:36 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010057.outbound.protection.outlook.com [52.101.85.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0p905g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 20:38:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G9vPGlrv0hZ7UVD6w45YFznOxzi7VD1YSby9TklnAr0JB9vmMaqXYrg/fXyf/Rk6tYRiRntf9GIGdE8bnGAZFc2djCNBaboEd+8d9kO+bOnbk94YiH5FelNLe7pff6dL7PAzdNzb9FxqvfSJOsE76Mma2BiJziGVXSqPqICchIDMhXvA6JiFOaOeaXN8RxXCznJiPFG2FjR2lSZFH0UTbA/UaLSYjvzUCc36/xZuvJRkXy+IX86lNlIVlYiEnHu5E3JLcLIZUgbUKai7CXSrZVVot5E7rW1qHjXcKj9VX7VeKStGZ5Pxi/CJrWX9uKzSJTjeVLXnyBuzdull25Bpow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eG9NDqqjvbL9Dc3DXNChuer48mDqxbPL/Aqt0Relb58=;
 b=ds0CS+ScheT6SOcXwEGqB4SvBrtDC7k1nAFleqKuEMH2b7CRPwH+Mt4vvB0EuPwwZ1t7vIWpCFpOw0uxzFkrEfoRmlYO8QMftkhJ9vSmVKuUSdS4hHb++cx+UDuQzzu7hk3QQI71qk+lDrACLi8XO7NktRDwlqAx41SGyd/BsTxvClXesvUWS7GYRnNep+7NlplfrA2jyMeCXkHOMuW7Cze1tn2in++L3jABBg9rTIURmm6YmtRgqjOH+pubBU08+JxC6pqYd7EXyeNvkkl34rKDsMX/70O2zZWN5P3c7cNSdUDSC+ieRwMblH4y9PwBMV5JrjhAuE9JWd4p7anVsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eG9NDqqjvbL9Dc3DXNChuer48mDqxbPL/Aqt0Relb58=;
 b=JpFacc75xTduOHRPRhA7ix9K2T85DSsA2AahumoYblU1Sb05wLwa16lVv+5SL7ba91AMHHZ34W1M///Bp76sc7TYel97bZGxD1QMZcLWhUj+NBzlX0/DNwsxF1Wt67i69yQAgVE2M1aUCZzjguHM40QHZtqGWSqwcBArCV4oPQk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB5892.namprd10.prod.outlook.com (2603:10b6:a03:422::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 20:38:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 20:38:05 +0000
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v3] scsi: scsi_debug: fix one-partition tape setup bounds
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260604234724.1936118-1-sam.moelius@trailofbits.com> (Samuel
	Moelius's message of "Thu, 4 Jun 2026 23:43:56 +0000")
Organization: Oracle
Message-ID: <yq1pl204vkr.fsf@ca-mkp.ca.oracle.com>
References: <20260604234724.1936118-1-sam.moelius@trailofbits.com>
Date: Mon, 08 Jun 2026 16:38:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0027.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB5892:EE_
X-MS-Office365-Filtering-Correlation-Id: 92c5ce8b-2791-4c0f-70b8-08dec59dd79a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Rnjbpgc4N6PBsD8cll8wSd8GWHZC5Go5xOYL8maYOJcE1LBTq/d3ITUZE30z6FK+LtFcPiyz876J3UydO7tQKVRMo5IlNXh4xl95d3SO1U057ZB87lgT4bZDcUvOCAH0mTRP+BZ0iYVoD+ixJRJB57nlgP3AJPXmIK5anXJ2JnIMkC+txwL0I2iYoM/AdMzDfiK0FnfAMbIXPsR5tTWLrFo8hQJ2D//VtAYgCLV9bInHV+W9kEUoaKEwDEajQz6bD127c5nieI1RIWnuRyfr5j0Qe0x74hPtF7dU1Yb9zVAT0ByI6S/7jSxeVc9RxMQt5q3DNkzDOQhVVCO2rTq0UnJn/m93sfd72Rf5CZ8pZ60Dn1+LXO3tiRhSaVxfAJzt66dQM6SiVaZ5uLhjtxcoJKgAsg5SBpKJj1jt0xG/n6HHkqhyIt/QliQQilMlYiyWfRWRL8rTm4E0fXYh97w4MukMoNTLuiZpExwFmZJ9WVsvo0n6C+/+W1331bAl/P+wyoGrb3ttgklxdTILwOX14tW46Z8CZkNPK+uK121077OTa8uMtkuAR8xhOsGiYqhNC1UYE7E3KDPQVQtiqkpH5Kk1gfUtRSLDKBMFOulHSu7BAcAwzg8tiP/Rn4OVYwnQNwWRwt/jWKPNBCA4ecXp7fzPn1Z+yIu47za+5fA8r/+DYrBnHiHYqU12L0COVw+p
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CM1jQrW7C4gO3CWMDzYP6EOBLQYR/prj0qh4VuXk2D97/MjUeK76nq4uPn/x?=
 =?us-ascii?Q?0PCQuvKU3EfnqzrrrsHKegkBeh7YGtGQ7tc15FqGr0Kh2v+tbNNHhfyXv05x?=
 =?us-ascii?Q?8aORWg7snWyu9Ir/odjWj7Jlkh1DoQunfOrG0Mqw/Wj0wEaEH8UWwZDHG9f5?=
 =?us-ascii?Q?4vIiu2Xx1IcuzFmMAOxW1wjg7TgMvK94U0+RZMzjyFY0qLBR8pFRj1HHhc9N?=
 =?us-ascii?Q?4yKWVSDrZ0g/ZGd+VtZvTV6m4hHDYlkDs66QMzGXqLskzDZweC0Lshn2/Ok+?=
 =?us-ascii?Q?PRAGd39XnuH0e8OfUVLEAFj1Fjz7aheZtWQcHHhpLSBDL6qbeHAHXbtFH63r?=
 =?us-ascii?Q?sfB1EqLQOEdux44wGukIlk2g6054IaTakxkllmkPpSUXjvxgyN6mecUsmcGs?=
 =?us-ascii?Q?9M9V8FLalGiFyMhb/pJaPYS+jga9k0Bph6g6Sigre8bR8he++F5j24TrZGAA?=
 =?us-ascii?Q?nkkiG//SQFA2XeE6P3BIZjsq6NwCi4lpJhl+gGmYYq1QNZ6sVvIhiwj8eTfA?=
 =?us-ascii?Q?4SPQLTpokFU8EAav0nINf5r9IOlEQpm5puzur+UTkU8fJWGxHs3r3U1Nh3eA?=
 =?us-ascii?Q?XAEOVmjqOdhImFRtw+60YFb36T1rV5N2JUqjRGK1gOeMsxTtsjxhlegv22AX?=
 =?us-ascii?Q?7Ns1adss5nQ1k2y52C3ahB6v30hwIJ44C6E1EcpgPCG1ebShOfwUT7soUF8W?=
 =?us-ascii?Q?LFEaQjWqukaBXutnQb8Y0rNSCSTM3xCRC6Nui5BygZ7s3ruHwDRa16b3WgG8?=
 =?us-ascii?Q?8RPS9QoWnPOZQsoUGNlnCRbv9P4L+m+O+Q0r5icg2tjaRK0hCicecrNI1WUr?=
 =?us-ascii?Q?0Ya0X0Mf4i7JE5XHb8o0w+1SPC0jhtkR1sMBS/lekRQmGyTVqGcZPOI/ijFi?=
 =?us-ascii?Q?22xXfzyTXQDV4BEehK36k0ciZVCjELidi3fov+VezSozzm9UPnDaJLInZhuZ?=
 =?us-ascii?Q?kAOM+UjgCqc+nzI1JDbuM0uMzOHeoIe+QidTmKBqCUqQBeuuiw6vyMnRE+TZ?=
 =?us-ascii?Q?/wGLjBPdMQld93DeTJgbncqrHQsY5BA03UtEhXwh8lvKOKoTauJfieRbG9am?=
 =?us-ascii?Q?4alQUidbUafU5jVYJS50PBejFljBTvD//9KRo/QLC0uwChd03DCIelxDQvrQ?=
 =?us-ascii?Q?Af9aWQarad1QJqflkxC10f7uMkysYYRvuQrr0l7D7TxbKYX/9Tzuq51IhUXh?=
 =?us-ascii?Q?XNVIcRy1wO0uEe9+CPzp8gYgWtDYTnFrs1c4ryJkvtIfCyjgas2mn7At2ZoF?=
 =?us-ascii?Q?Frw9UGxuwEOpvrJ3jzX4KS/V0n3GR6Dj3qN17+f3CnFKzR87Qeqo9mrcGIHm?=
 =?us-ascii?Q?1qzsLpXgjmOvUvAcLK1ZA9kXDKhgWeFG7CrKmaIlewLv+VNznKKX49aPL9L1?=
 =?us-ascii?Q?i21QriSW3UdNkdvPhfU4fUQZGIRtK6EAL98YUkx9t8aj+GZUVtb74wKJHRP/?=
 =?us-ascii?Q?hl9se2IuK3mqRxr0y8EUZ0U7Ow5OqIqXW3SfxHKZfg0oAG6pWvX/n+5yCR84?=
 =?us-ascii?Q?LviD+1ZWETgWwfSzmSEjAp3/sW/WMXTq/tTFKaNwhx72xgyfZyv+kNCFYY7j?=
 =?us-ascii?Q?25QhHKsG/7Bi7bzniavyxtPbQGX2delTF6w1+zOeg83wSjmt85dJxd/uQ1Jw?=
 =?us-ascii?Q?bnDcT64SdmtaTLOzr5BquiTW0vE2tCb7dV1tS/JK1Eyhf+P2bMoXPKKKjfNP?=
 =?us-ascii?Q?/K7diofnxt5s+IpwyRAeL6kRjk0gPJWV5qM2IVvj3aSq7BhSu9Pdemu/ccDd?=
 =?us-ascii?Q?Hws9Pu+SY1C7mbyoWkMefO3H57J7xdY=3D?=
X-Exchange-RoutingPolicyChecked:
	Uhsipysg/b6QsTunu42XEKezMkPlTd5W0C5lxBX6hAWy1qLATtaT6dnBZUV0K8omRjDyBqFFb39xGHOF6z1jD9xE8sbKbOEeTd0ayoEhALfQvPtW7KgJcZjSbbNhGeyFuJuOB+CAO8AjaCUHMfIa4k3tXxdPto9vpDd+MXYA5ixKmc7VsbD8WVQLldjF7yj5PPUO7HBpxmuDosA/y4QHndPV+nAxqRQp8V6HBLWhJEEx+3+2cYioiYh+nmgwgQ1M01xxr4RHNDIglanDgDBdyKAbsQuvfaq+mnKs/P20S6eI8KD4NkIOKUHpHOI+64qIyw7ierjr57lOwQ4bspAceQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7nb0Oj9rhFgrRhmiJ1T1CKLPGMeuQ3ZmPY3vjOCsi60HCC37h1LkjnjzHfheon5l4Vx15ItTB30Sx5S66sQHP2su7ZZ+PSPB23qcThOijGP2wrndH2YUxS5JVmgPZkrYxroJ0R5iHDzJ0x16gJubfN5uJVDc+T17/Pzu/drP4qCGrdsDEkrLQPd0fSNlV6VanOfrZ1gggBHLX4LQFZ2+KLArzL9vYy7V4ESKxGtEmuISbnXTAdyAwS1Jhm6vh+6Le0sn6NgQ+M2n2FiW5Ch40IBCmgDkxG9pZAf8olhkNRXavoWjJFo8VvmulgqeSM+AfbqDJ0x+hMEDyz8WpbxNfQz6pFmmAEaGKiSw8qMrhT730YvbOEJiiOUlnaedxWRi1K3WsrMIVNitGWeSAnm1mn5vFYQuUij40Oqksl7wrXT1nhPm2WO8NPXek7oPhhuwHP95bfLkgV+kHBRbWraYF2udZyca50WoQm1qxd0tZKKOO65oMLN0NfGF+jej020BqsDUoX5gLg07fkyx1CzvqH3Y+94bfL0nQGyQZX4/+UfRirHJuHTAws/x9tDE6Ze99kC+mZhOMR1aVTT80oFufzAfeOFVBGnUY92PuyCrNRc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c5ce8b-2791-4c0f-70b8-08dec59dd79a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 20:38:05.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ki3TuRVW69MhdqACf4Z0WyUktRT9J7xFjAPHm82RJENEHzpX5S8Mdv0x6XbqToURxN/xtwIFZHEmCrDe8N8bFyVVbkjYpV4jgHAiNewe9iM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=811 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606080187
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE4NiBTYWx0ZWRfX+MMoh1L03XFb
 /0h8wgWBRtFKjd7yjNbn0UtNYn0GARKkPjMeWc7Jx5WK7UrOcxdokbBciJH2FnwaLejTOfcutmQ
 n3QJKysTcRnMcKSlZjyUvaqv0KAQfSp5HXz9hwreSF4Hbved23uOtmXVCQe8FaXQX70rwW764JI
 QCmA3IAS2OeeqwOig/16h0b/uSRkl0ATDwKhdY71ci1yFVrOlFooyXsD/yAkJrZzyD1QPBGT5I/
 a/myWhaSvWnIFtixfajr/IW4WhbkUy8nSnM15jquz75J3mziGllrGwKvllaYSAFjEqiry/VvyPq
 +yf2iOl5CGPQNWePSxl6BBWfgf2mRDj2AnpqeAw0wuxoA1HThVhd1fl6dXFHMoGrGeTTg31wN/F
 LwIhTb+MCJy8+4OtAmY89crQUgGFktr7OC3KNocq8Tl+6MD1l/bIGGdFGwv1klIkNzVMw/oUvnD
 K2YrswW2nYwbeJnaAXTsaTUr5Vw+c2nHzlwAsfPM=
X-Authority-Analysis: v=2.4 cv=ROSD2Yi+ c=1 sm=1 tr=0 ts=6a27284d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=iQ5k41vCalRD6ahj0OUA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: XQ5MusP5Bdps814HQP9wymoodmGU4vRi
X-Proofpoint-ORIG-GUID: XQ5MusP5Bdps814HQP9wymoodmGU4vRi


Samuel,

> The tape setup path uses one tape_block entry as the end-of-data
> marker after the usable tape blocks. For the one-partition layout,
> partition 0 uses all TAPE_UNITS data slots and partition 1's marker is
> written at tape_blocks[0] + TAPE_UNITS.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
