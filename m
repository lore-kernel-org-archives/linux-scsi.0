Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1494407596;
	Tue, 28 Apr 2026 11:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374735; cv=fail; b=JYMOBB3izPT6+igx3drhPDhXqs3TKWlc2dJSvfo6EV9LYlt7zr4ubSR8eBxNLoWkZducbPlTCHumNNVAv7OY3uhPCwG18OT65hGuR2DxiUQzeQbOKNCXbiFvyfExzH4NT5vWjs089uyzCXKdMG01gqt4dGTqm36XHcFDk8SUOh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374735; c=relaxed/simple;
	bh=to8jYQLa40ZL4drVyN88K4ZNlEPtoyVKFznFeuIgvOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xbh/idzyvdxmygSTvNOHM7x+u5QsGKq+RrZWBaFq6CpQvsfMwQiJmigTr/DlS0i4Gt5nbSTLoQiflpHcVDnznWqDnd2Vez+F4zpxj4L8+tOkHz1edrK17fbKHCLZkm3i6lc3JlFzXIvMYEGfXtS1JFIv9j1wP1YYWYylxmt5W+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EC5nAe+e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qJ3rrzTU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EC5nAe+e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qJ3rrzTU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SB5Pl62128102;
	Tue, 28 Apr 2026 11:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5oz3teRtOZo4OxH32EmV9Lb3dXZ4ZwodM1gg/85Ugfw=; b=
	EC5nAe+e2vRa8xTLuqFKyH7GbHBFr3foCWLWLHy4zVA/8pzUGll7YOtHBGHRard7
	qiYmiHI4Qy71CmtsawJ2PkKGN2oNnqULlfJOMXD+Ez2/gPvi2o5ywuz2ReLbbRNH
	xVdyEzdPc9GHoCWd6lzSO6fUeY8/9s21ulktCQsOuJ7KJV2Jcdd64a2tO3/RAkLF
	8HqrKYFCggFc7Rwo6vzTouXOmyVl+5NJxwK7OZzuN5EXZOi4z6YzNnU2+E7uUwAY
	ps/DkfElsFcA6KvcAYzIWIAUlvmkCYo0Ea3qb7pkRBrSDoJ5vuKRFFlM8ft2VBsE
	7/5UUyTsH5LybxLRafcBFw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmha7jdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2j1b040736;
	Tue, 28 Apr 2026 11:11:41 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010047.outbound.protection.outlook.com [52.101.85.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cudxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rXya56z03xFYIdmf+aflSNlPY2r4RTIesbTQmOfRYoq96gEMN8I7mQjbhW+HghBKa84CuMyeG6F96Fp0HRtI3uRcdb0rUZlxfInm2QFLMhFPo6q2Oqvoduhm9Vb6xnWTa7mu5794cNfLyZGjQY5J3gAZXT9ip84rcmuWuUuR6TcLPG4wI7F132hYQw2dao9MNuWjGvVMctDO8+yhSztgN0VEjFtgv7oEZjmTNXRElnq8bXGLtg9Yy2jPsqx+Vxt7MEuzjPEQlnEP6+elu19JbHbNQiGtTAnHtkgSZhh0awenafFpQHzoODr79J854lDkV3rv54gT+C4dsvcl6v8Bng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oz3teRtOZo4OxH32EmV9Lb3dXZ4ZwodM1gg/85Ugfw=;
 b=tJcOLbKg4S3W55kCEyS8TAIaxHyFuvC8J6M1kzuSyKLtsJ2xpY4dFIrgLmTwAsqTkXrGbbn3+CXmv8S1ozYwpGW+sv4pzDMuA0Aw5OXp324qr1rPYXyoE8P2AMx4E61hoE+ViX5XPEVJNTmna0IwLz/dq9o/oU6QvS1ahpNGP5ubVZ1m86BesYvqJ2p9iz0hfq2+lK9QIpY4164VlzA/xfFMw6dY9z7eEBFDPFFvPYBGJFVFNuAu8yeiPjnF79Css5SObTzl0/gim3jCnKZ3hh6tMYv60VoOkGM0yYf6yri06lMoqSGUIxikwtwxiGGFyMppF9eEU3wVqn4oAK/33g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oz3teRtOZo4OxH32EmV9Lb3dXZ4ZwodM1gg/85Ugfw=;
 b=qJ3rrzTUMZyGHEyNxF8b113koJJ6J8QorLfjRdK+Vax4ClWpGUwYe5z/DOM9chxH/CqGeJW8kWmlPyrmDgCS8OWt3fbkgbcirJMOo9hOdWZeMPRszzmWOHIS5xB9LCr+eohYyoPQtTDBBdt0uQ343zmXM6x1gcUIgIdwZ9PcIhw=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:37 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 12/13] libmultipath: Add mpath_bdev_getgeo()
Date: Tue, 28 Apr 2026 11:11:04 +0000
Message-ID: <20260428111105.1778008-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0058.namprd17.prod.outlook.com
 (2603:10b6:510:325::7) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 2149bdcc-2b0a-4603-5b95-08dea516ea47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9iod0rY2MwrmV/9+kDEGgbJlfX0HDUN4XM6IMwILp2dRrq/23E0I84gwfWZgdlt1DZwcZAnqSHwn6OUz/Bf6AV6G3ObQvapouTI8Dx5f4Hzef3I0ShWHoBCSC80Hoi3DJs32lXKwnnTPf2JnPvToC+Mty/jgrgSsGtuFmkciUBsKGkQDKavjTPV7Gj9ulV4keE0W19d068Zswz5s6fi1MHlbWaMvq4PyR0ezHwCoNkQGB0PJ6SqJ/0FS4hCA622rczc/K9QCrvU+2Q1I3hBUuXHmNZ3GUu9xad2KOhQbk8fYssx/EwZNft9THNThxYgEqGDhVC+Wa06T7/Coz6P7s02Koiyo/GZ+qn5Z/vYyAYKME8yaCRDW8ZigQvhXAMew4J2TPhPvlt5GNdSDUxT/NsGDFzx/V459j/QjkjDgDOXuAtetyZAuFmU7+GvXWbAy3OGGRqLaoL+vf7AKckp2ptbIJbimCJyBycNTx49LPrxcV/mg+EogsT9dOEv+GftavanfNQxSR/SWo1qxOKsfcEYMrd0OTFsAyltz3qz0+a3N2swC7uqyfJizo57ilYIzeVkiRsSDy2VBcoL4dTrRXzbA5alijQ2J6Z5S59lzRJIUYMa6DHNPxIqLqH38UUNf1Ie4RWfNhZO9DeWlW9hOkeix8EEqGpAgGvMykmr90INjmE8mK5CPOI9WowD5YYSjer9btxiSOyz4mTlFm4gVKTN+0bqNiPJwi9HN7bnaByk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YF14pZRRgn6t/cTWNPgISWMLDu9MOUC00QfYODID+GqTylRniZR+AEFwJXR9?=
 =?us-ascii?Q?gGVieTogc2rfDd0O6d7n5ugLRfjt5sD+fy4yEnGku+dO2Vq1LaP1sR4/hVZB?=
 =?us-ascii?Q?x9JFfHP5PFpUdIAeLcoUk9RQxqVUUDJcW4FbX2CyjqMtQShDTNhvgSA/wLk0?=
 =?us-ascii?Q?VsSVi0+Ozi7dWq5WQXkZBesaQuxg4EtmUvClyuXC3XogRfSAZermcNJ54iIi?=
 =?us-ascii?Q?Fo+uUuYypY7DXpytNoVGfiVxxl4p/0vViiqj5FEMtRJBQlZVGJ/SU7x8r0S1?=
 =?us-ascii?Q?EG8tzJ1VQJwG8enXR1/6W3ZPLjIpUc9tTIZtPMjVtZQ7yZvsIMewC+DwBeXs?=
 =?us-ascii?Q?Wy9jqrHlh7XEuoduVq/5VsJVIXchvRCWYWUMH4PVFoh+qiRjaytneRAfMSN1?=
 =?us-ascii?Q?0cYsLwZpPN1L0DgQn1Fy4kZA9wJ0AeEpUOjayEZUMfdVBUltKnBODg6zm63N?=
 =?us-ascii?Q?0f5Bme89LVkqohL+X+8p9W0DQd3W/YaBpGpBSPKHdJwQTNlz3Mjj1fjH9e1Y?=
 =?us-ascii?Q?EO3xcy6gGVmabbiQco7P4yPpZ04vIUmjmR/TxzqeRJdpHRki6liAMrlJ4NAr?=
 =?us-ascii?Q?Ur1+tSsvWl6FPRdQb1Umf9Ok2ZvBvPoaUQnizuHkEz55cs3v1Y0eJyFTqy8d?=
 =?us-ascii?Q?aur11k/4J2pF0M11PK+1K/+aEv7LcSdEJDAR2P9DJtreCVTVLNvw8VMez/X4?=
 =?us-ascii?Q?7ciZrLXBVNv8tnft2c5D0TU98F+a24Ra4QqItJAZHGMKHX+F/wP/sxUhMNSA?=
 =?us-ascii?Q?qdAX0siwhtqazcKHsWshKx5s2fYfACGn9T01rsIYDBXQyE8jUbRxg7BlJ2/2?=
 =?us-ascii?Q?uaIUFvpzo5BMpxYcsSyUV2dmy5x3paj9WlP7oxqXVQ8OnKKpHtovrB9p+mt9?=
 =?us-ascii?Q?TPSnalKHmCq0a8w/NJOIyX1POIkpV0BJW449HuvBLrsTx99+NuH0+eMpLvVr?=
 =?us-ascii?Q?Tcx03Ff7CSFkO47lTQbw5dKTLsNqWStuiq/r2JecNcRIvt/rbrK4ju0mvIvn?=
 =?us-ascii?Q?1E0GEUMrzpT6/H628hddV8ZynDglhLG+7pHl5QrEdggGLo84BjdyzFVaa0cz?=
 =?us-ascii?Q?9ZFZGEinVecW1Xm8ZnVMNQXZodl1lX/JBSLO9BlzUG3A1UlgR9fSH60rO3yj?=
 =?us-ascii?Q?ixX4fETB0ue0ig23NQoAEZWWFc4158/2iLNbZeKMfbVzhDAKcWs/Mfk7VTI5?=
 =?us-ascii?Q?dlGg89bWaYdXtevMdgWd3XjvAhrgfABas3bBpRnRS81R7saXxNFt9c5GFAkU?=
 =?us-ascii?Q?yWmj4iaINdP+o5O9DhMxgQJerZs5l/QVG1f1kSkCl/TKwwlfi80wSNgtGqOF?=
 =?us-ascii?Q?thjQhtNq723jb8bhAnTJKfAQ0sIKh05cs6P4I8DZwf14HQCLQtJgBWOpALno?=
 =?us-ascii?Q?jPKgKvsURHQW9ug0zZZVNn73vtQoTA3l1F9OC6Dp7rgCzDcIfXoKDDOdoRRb?=
 =?us-ascii?Q?7IweYMwvhdpWV60K8kedjUhBtMloy2Y8isfXWRNn3zTBzwkwX5YBTj++pdkK?=
 =?us-ascii?Q?PG/cMYWmJp4xwEQl095rdeolyZj7Wavtxl8hYmGE125c6DQiy0k+1jsMXZPh?=
 =?us-ascii?Q?1hh64XQUFYf5xWvIpjEATgPF37AhAViiWDhHJY7VO5yX6uu9qTkXK4eqxdQl?=
 =?us-ascii?Q?s0dfYiGA8ZlHChKEoGHsckrxamB/hmFhiIOAPFN7S7QKcR68CEOs8H0JIWtJ?=
 =?us-ascii?Q?YULuaEbCkV14TorroP2mzpT72KI30SkWHIFIPLxjvMuyynGx4urhffqij6KE?=
 =?us-ascii?Q?Q9SzT9NS6ohlTClsFj4YTSu9L+pxEXU=3D?=
X-Exchange-RoutingPolicyChecked:
	KSalwCHTHYWNoVzIevOqOa1uqSAAyPLihZWvy98jTsalCy6XzHna+SZBV3sCB0m4u9jzigPyWT/DSOHpFpxqlTR/kZc5ZZ1K1vXA7CYvQ5qKOGVNbF6uF6Vo1KYR5sA338U/qBaYPU3T03KGTAz9fZZ6OgI9TqIQc1KkLusrqPNkZW0RplWKAgN9qIcBLwKjoljQ5fo33hXhBwUAE1nWOZIgehr+DwwmZLQzsioj9xkFxXfyYgKKyj1pDMY67EG6+Da+xfL03HPDXNnbZcfu0VWTK11LuzQsTLQd7msTj3opNX4jar92MQ44ZJlgtX7w6iwpVmOrDbDUTZC2PCoCRQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HH6A6Z4rJh/WP4EiBSCAgoI5vpIBKj4LKHcW8UYVZpf7mcayxIIv57jtNghHVrUb3p22CARTX+wlFtymtWpF9Y0JHzfGv6FvmV569i85Ez4uFZj8QTU9aeSIWA82n30H4Nx/VeJFtYwaLBdC8jOR4q97omTz6JI4vTqhPwq/+QW6Sdr442luzpboVcQd2ldDVbHzgCCJqxk/5eaRbrC/+W0uZE4oVwRs6PmoMD8t/Bp699nmdlRn2Nzhs3ev8lgn3GAArN/eehgahRzXu5exlkuokwQ3g2OV+tj8f5G2oUiQ8p21ihkP9WAzxFdY4+k+yDBCma1RzozIY/LUgHSfwXxJGHiRF/fpc3RAkYAO1fzllTFofrRhoc4fmykPQZjudAxT0hZGNhdXlfwMCakIroPBG9vOQwUs5i2MBoX4uUe+rxMtu26RWvvP1GGixHJytkHqSckT6Lrlrdr0XhxYrk8+vXFylF8OQEXlZZum8AvSa+pnAbh481wXI7LfN69xocZhSlmM/pAGmKKSqq1d23EFp1/UzQOaSnKOlJdCj24GKKkoKcD0mKm6UwVAi7Pztw4em8tv6Ai0vYUB0HlSHbSbyRxsF2gvJi/eEB4yiCk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2149bdcc-2b0a-4603-5b95-08dea516ea47
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:37.3939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NAqCqeb7i/LaDk7lVCNqoqXGe/RTFdfAv/aUXdfIUlTeNbUbOgkUJpYJTw05dx1a+i6gFYx6NNrpsXGfREZCmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-GUID: VoSJ2XfSeAyfy6mR0LGk5lAWnyORLrYK
X-Proofpoint-ORIG-GUID: VoSJ2XfSeAyfy6mR0LGk5lAWnyORLrYK
X-Authority-Analysis: v=2.4 cv=CrOPtH4D c=1 sm=1 tr=0 ts=69f095ee b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=j7YgXOqi6RBO2FshDZ8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX3IbAHshcDuVl
 +CoXazb0nCKBTeh885O4sIbcrDNblZQH2+TIoU19MNvBWFaPCsojkLWCF+aMJgr6eDd60NwL1hu
 RfJsstISIk4xRgwttLPjF8pan+6r6aRapcKeM4jAOTOo1e0/lBQtW4n6U/rWPXfTU7jtAM+P/xO
 00vhAOrNPP/jEKUM55YgfJ5wjKVqG8I/rvz7dom/xtGqbzzdm4EDeKy7c2veooHlqDSO5GNaUuw
 Ic8sEz8e92r0CH8YmgHlC3PueTi49dWwWySs41dC+NKTWRgTUi+XCKzJHf/6usth1oZwlepRlRW
 2ODX4zssC5Ri8fFz2nUz4wamzgiWlMnE5LfnSpZNrzkt0c+AndG+GV7RG2NgQrr/QgtmridiZeO
 JAYeCPhGAuQnNGCw0uU9MVodeMNgIcdf+b0Kpgnlizp0vsxjZHpQodlQT7BTYGmM5cpy+yiO5jJ
 N9UiSi6cb5fQWASpzwg==

Add mpath_bdev_getgeo() as a multipath block device .getgeo handler.

Here we just redirect into the selected mpath_device disk fops->getgeo
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index e2998c1b277c0..1228837e5eeac 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -522,6 +522,26 @@ static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return err;
 }
 
+static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *geo)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->getgeo)
+			ret = mpath_device->disk->fops->getgeo(
+					mpath_device->disk, geo);
+		else
+			ret = -ENOTTY; /* See blkdev_getgeo */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_pr_register(struct block_device *bdev, u64 old_key,
 			u64 new_key, unsigned int flags)
 {
@@ -711,6 +731,7 @@ const struct block_device_operations mpath_ops = {
 	.ioctl		= mpath_bdev_ioctl,
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.report_zones	= mpath_bdev_report_zones,
+	.getgeo		= mpath_bdev_getgeo,
 	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.5

