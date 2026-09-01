Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AF147D93B;
	Tue,  1 Sep 2026 10:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259606; cv=fail; b=UslByMsx9D5to7QgZ1TD23YON5VpESPT2/b4jb/hhgzXXAJgo8E2mPAEcYgZy0HTAi0Abb0eqs6OIeRTY50mg4SDiEFq7cTc6gnm5BbDjGK81ll/lbilLSozx0nDYrfJILaYYqMu00Rn2NCJZtEdonLAvN6DBFmhEUnDyxf/hJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259606; c=relaxed/simple;
	bh=7wcqtgkHnhAe74JUtIFrFylTrCRLUC/KbMS0CvIrSvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UfviCTKeTtyhzuhgvWnH4CW0dDgcM0vqD4evpO+430ZHh7u3l+4ePjcHUJZHP+lSL4h+CweJZVF6nZm/GUIOi9aW55vEuBM1flTl0GqOepw1hW/rPl/CzyEHdaqhffNdkV8tg7ON72ft70kjgAk80Jc473o+CwFH0KZPb+JFpQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nozj5YZa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EF0z9AOc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nozj5YZa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EF0z9AOc"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBtwk2846774;
	Tue, 1 Sep 2026 10:46:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hbqzcuEsPdqOUBsipDrHIJ3A2EtCUW+jd5jKcHYplxY=; b=
	nozj5YZaY4+b88sCTexWqy0+R4JZp2UXPL+rMXTYhg/gsqrYz5nUNcfcjs5cWDfH
	rC6apO70H+Bh4r5HV03MRkkiKQHDHRCAf8PqSjjqXOeEm/uMX9rXWJ1k8z3IVS6m
	qW/vHKZdM5qGgDShHpvqd3IbYuQsIp+VCT9PeNsdOqb8G9eBS60sO+Mq6NXcw/Wu
	pkKaSXZ4NYWgRjd9KtLWgMwuquWEmfS5JKM5nwfceaFkUW0pfWEZB4ovGwabqcKO
	Avd2n6EpuCImLGsklKbqJoTcvZyLb+IgED6Xom8v+iX9nvobt7zrEm0KYL6cG7XT
	5ErkmyJHsYn3FWLc2QDgYw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbavehm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjMxM037329;
	Tue, 1 Sep 2026 10:46:18 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve34rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lWDfMup1w2FSTBucGaSyAJ/XnpDl1tIhLmoFHspBkvftcvCDzZ6Zs8Wop3HAZ1svLyfiFKeZp4fbf4rNn7STLircdHgeuuxTbtRgmg5CLZLMja0Ih4ayhZCIm94mhpGcYRKpCGZgRmMZ00YwMI7tXMiHO6L1wXLC8m3VLVzB8W6+NkI/GZG2d9X2HQ7OxdMNNSMYMLL5KZDTPdtNbuzTDoP7byYGWl2Ncd4V/pZfdVp51vFeZamUtC2um+BgAistyyBmnIQrK0N/nUzCyN6bj1h1LDdp+gVNxRTauZYokZEGlmqNW4l+pEfqAbTCUiLrVjul3+am+ZZVfn1oZRGeuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbqzcuEsPdqOUBsipDrHIJ3A2EtCUW+jd5jKcHYplxY=;
 b=KxDlJV1oVQuWoQvo9MVLDQCnGrA5yfO9bzCwmvWLYsWMUpRtAg3XjqnB4S1b76cHUrZVfSZRO5qXTpxCbx56mYxQvZd2ZGXJ8WJgFcz+9y6aEmlHmbykfuUIOL1KueNsdl7CKQyvCUn9K5E77PQ1A2GiFpzoeR/QnE8HKmEf4yJPfu+6ZzgAW8T1TXuGAMmfvBEQi3EY53kBz4YUnY6nQ/QcXuozxpAnhxtEwYFoYNV8//V7mjQ8NYOhkGwnZkm/4PPk7wX6yGYhwX1qD+524cYCxAMKu7d6LmONgON47SAOYT7unx9wQzBsG0Zyzbs+XVbduY92A5mQ+09Xpi4HHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbqzcuEsPdqOUBsipDrHIJ3A2EtCUW+jd5jKcHYplxY=;
 b=EF0z9AOcDXS7K2ZFMlfyypXxiRnalOOV0BzZCgF95Yw5zGElD3OSraiAYOBJX+vMcLBWa2hPbljZSA/8OJJOo3D+jWJp7gej/K9SFbb52gU61UgflbhIH8BzIsVxc9YXu87H+iHRm6vQrpp+oW6JLroAFB2uO5K5dWgvOoN8lfg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:14 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 18/27] scsi-multipath: failover handling
Date: Tue,  1 Sep 2026 10:45:17 +0000
Message-ID: <20260901104526.3850621-19-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:510:324::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af25da3-934b-469a-7d3f-08df08163e9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ul+EVmmcsDQnEsDDBL9HL8dghR8I/RBETokG/4Kh1DuUsgHBq9AOnUwU+jB/0onUeGWj4Oy3YNAqoYE6BSI5o2ugeYeojuWDBLw9s3Qqc4Hp7CYqlitkcQngC2U7XWS4fOxz1LrjCuvTl1IW42NQS+L2Knn8aX1xaY4nZdtDyJoUpd/ckLonC6y+E3V5EV5m/iqaVlqJFgasYShY0vffLsSpjo9dKSGoQrBTtpwUiI0GUTGN4Er9ZY0FmOdlI6XfXK+mHx9e2L+Dys5RDjRe+Ylnvj1cUn1rHiMF1b2hLwYukMOClmcs0xfGUsCjijL66Du+XeHSmLpjpIYLKm/4BUE5d4QbuJMavZZ0LwgFyT+l7V4k14QJlvAZWd8aCOzHkvPREnU927iI6dywi9UjEPFDKnZC3/TkiHWJZWX7fiBfOWxQXmO6ZihBcQ1Cc3OZVjQSE22m74y4Hw5x5BoO2ShCmiK1tz28IS0RkjuqXQli+8FFiXhR7LUT0Sm05skXqm9rJYmyocveWACXAOHyc3Hd0hAXJuKvhxUiMx/VvEMQhShKslN9pi9AhbewYuyOCeDFtKV2X5t+CLbzo7FMMQFsNJGow/lgQPdPTvcOdmLJc/GhoFWO+1M6SY+ZgYu4jaPwyYbLHkp4YvFw66twf+bONv0iKQVtP/ki8JYH6gk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AG64fcwSR5/J/21Iq+KREnR8bmOmT0YYKkosTfouQKlZcqEMxOSnkQrIy+N8?=
 =?us-ascii?Q?j9UrW71p5PfYC/sVzfQvbs2HY7R4iaFkW10q4AMk8UPW9T6nVrzBwbNSCREP?=
 =?us-ascii?Q?x0lFjKPh7pVhek9kVqsC2AN1st2PLi8U/RV4MlZMvsnugsN56EtC2/vOlFm+?=
 =?us-ascii?Q?CEqIHgqoprZmu66gK/8tCiAESDjjqqwxW7jg1AdZlHV+TK21Hl5CKFMwipNS?=
 =?us-ascii?Q?OW11IYDuDHKKMFcXjI9AjdWm/yPyHfQADy6OPJnrbTPYyIQL8b6tq/lxHRxm?=
 =?us-ascii?Q?qXDWxqlpUrDrS39VJ2V7zacvfpPmfLOhExR0jihzVfpSkrH0WLq57gY20b+i?=
 =?us-ascii?Q?6Cu+ec65I7cV0dwhW7nH0HpD0oqmbFJyoif4Ty6LRZMN3MqO3IwcvakpXz8j?=
 =?us-ascii?Q?22EZF0dKBvtiOLsL4220ZV4cic1/EQqLaJ8TrL3XIDw7gsXS0aanM+SQBtc1?=
 =?us-ascii?Q?o13rUOSuhbnH6vZo3bDIzw7c+s9NpHEeQ/w/Osb7nTVMjd83/3rbSXwW4ifN?=
 =?us-ascii?Q?JuJbCrbYSgJg9Qm00uS5tR+phI/0dszMJM1CFtgdeFT8eOaEEn3FBa/IzR0g?=
 =?us-ascii?Q?ZIG90y39a9LA1ICwstu+ltIyl2GdDejlFpyGGaKGi8kaCOCnFp/kqYkvx7MO?=
 =?us-ascii?Q?a+1rU6CmhFBSAZ70v8cYjyaExZi5YzpR4ZU4Qqdnh5ST6K3/dhkfZjxcwTLD?=
 =?us-ascii?Q?2c91waHSVB2bH+nj08fbHbcfUfi3EaxojmYn7Yov98F2SkxsaBFmGHkRIZh+?=
 =?us-ascii?Q?tVj5kSRq38oHtsI7b03//jDIVK0DTMYf1Aqi5ZYAiu/HBBsg4zSE/vzCcmb1?=
 =?us-ascii?Q?5OHwVudCkd3MShfl7IHwWZXchOQ28Ksm1m1jFnsBsaTWDJdoJAzygO7K+sUT?=
 =?us-ascii?Q?8BsbP+PM7ltbjW0Tvbu/jdU2tFC/WnoXJa5JY741g/fdRveN5wwVovaM6mXN?=
 =?us-ascii?Q?GMOGd1s9fTuhrzqFDYx9mcl/KAY+sEBUlKHOo2/WbNV+6zLxqo27pBxFeQgM?=
 =?us-ascii?Q?mOHn6U+JTt6M5OHTxWid/m7beoaKqNTu2tuegcAwVzg4B57DDVH+k92KrHEI?=
 =?us-ascii?Q?ghMWbyIUhcIlW1NnarSe35Milx96eMd7vhw+s8zBitiF4vfTh/b1dUmrNkKb?=
 =?us-ascii?Q?iSzz5xD13Nzs7PJ2FBYqQx9epFwEOGgrJvn0VvJJUw0WgCnDaNgJD4pae+/1?=
 =?us-ascii?Q?JvUvAs0lONr/J1JNCir8SSRVUmGwJSxRWDS/9S9u7/zej7n4BqeW5f5uhFjz?=
 =?us-ascii?Q?qLKoJuKi8MHYNQsn4Ry/D7Jv6XNH2ZLu0wtPplJwkEcYzUo78tJtB6tIqyU2?=
 =?us-ascii?Q?NBGHc/b7vLG5blmna1nyCvkGEWlROEvOLAlumWM3tzEO6/WWMf2Y1PNjSOWT?=
 =?us-ascii?Q?uMcpDCp5zRX1zRHB22wAQW77Ipm53IwsEKq7OIyGR3euMpdA2EMZQnI69h7S?=
 =?us-ascii?Q?yClN/oJ4cjzY6zNN9uhbrCelfWb/6SWnIxth8ffPg1HvsUlrD/nBkohfLeDY?=
 =?us-ascii?Q?kWOtFrUzcFrFr5ZgWn36huSxC/DAzxP0JVf+0C1m0R0qEFYNOkaiWq/5IU1p?=
 =?us-ascii?Q?hS/ccJaXuuNtsGL6vHyVmLgcX5+hXyQMaFhcioqULxGgyhWhCXAzRbLfcpPg?=
 =?us-ascii?Q?kQ/oUgpzKOTvkarK06qGWv+Pg+EO1g0lQ+vS40EgsJ5vlCTs9m+t90NSV2rR?=
 =?us-ascii?Q?RknxxT4P9TtO08RMpp2b/QQw/sAO5+9cDkWx9KE/uxS6+yASgZmIUepg/Amq?=
 =?us-ascii?Q?qxpsov2q54iviRYfpi7RMwKwdAVJv14=3D?=
X-Exchange-RoutingPolicyChecked:
	JZCKZyy6TJ8y1heQsMao4K/edlhu3ijx0S+vklWl3kLzWqNOjZiZ3YHTN/bpmDmBV2deS0E5k+ycJU5jM3m21mlyqUbMf14t5B2c3dCrv6Af4cAFNN7zcx4Iusj+H3Jzefzccz3+wbMBnKC11jJhuYXiYMVT5SSGx9SCPNsPjs72Jv4at7f3HAXzKlv5k+d6rAL9H9owUkhfxlxjTahYJR6UqR/yVw/DK0MfWO7QStWZa9sGWe9YywBaQ9ZUWL4dXJR/aYBnkzfPt+B/QVdZM2uW1lviuN4beCQ9iEpe8rdJMgExMtREmyN7qZCCfZsPxtxqzOSRG0j1VdL9wZiAYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8tDah7Npxq4afAU3IEOvkmWf5EUHJVf7Dsd4Ye9dpZ3GL+3rREZZKG17oiiuVtgYyUZyCPCgPhOoNYva4W2DlkiPjsGc8/owvAF94q5hhn10DVUoELQoq0TtCPqKDuD1vO2HjgE5piAEbChNfEZSx6QZANkwpnH2fgQj8412bpbTrTO7S3n4SPDwnGLZjBftIeIIbsGCmbCBmci7kMUJMR4zQSctVbCZKLOJ4UQyMTlPhr8Q9xsvIhFeLpLpbde+7bgFc60qORJYDkISSpkTdjDt3ea/gNLvPVm8lzk//UH/rX1pdKWSTiGk49m+bMTEOAs63dZBWcSk9SuiUR/Jg4WTwLIcn+bGA9rWx5fw2VC9bBmF8f7oK8pTegdQ92qlJEWBDY3wzLo+Ne7VFcBPYUcxXfZivEAom4G2FyyE/aRColJh0d7XVvQw82EZUNjgVaguGGLckNDZGNR5Rx2yMgRxaMF30MdQtIvjyFuJE6+5V7mWPDzo0nfZkydsWfRa1dV97vImiFl4+2wVP+qifrHGoQNsnaUf5AdXXn/Ix5Zj4vWrF++S/3vsyWjGxWjAwwYUFZcO39u41cbQ6PEAarQ65ElWQVrQWRwtFMkthZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af25da3-934b-469a-7d3f-08df08163e9e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:14.4346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwavPuey+F0dkO3ddbr71DrBBFCcUKvzvhGqB2SXk4+SEJafLR7iyD5EUU1kGVr/7b3MkoHFJsg1dMe2y8nm5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXztz9cmZQ+Y4b
 cHh5iXq3PXrHIBUEqj4gHUqQMNY/Qmvg9s8q6+hXTr6IMqkl+QCkEcZHiORCXYJaNHzr4mVvgW1
 qNzMP66O4IhInQgQee1rcIvJnWZdjyy28rLkUy6uajRKbBqzofIa
X-Proofpoint-ORIG-GUID: 48MTaeUeMW1rRHml6Y_zx55vXrQIGqk4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX690QtLmqz3HA
 QR5jLbauMA8aAU8iA2wp4xoM4I3r6ysgSbi4A9WcAaJiEy0uNJ9PRO2GwadF2FA3+Q1U7BmJk2O
 7uObh05PL30LgsfzBVcL7wStxAegKse+BOWc6lHn9PM8CAehe+iqFqjUYh5kTOHTGdMDwuzmGFQ
 GTH6gQbdvMYUPkuMcq6rGwZze7M2uMxlVqRCgcCfTlJQAszyk0T7/f/iN05O+eZAmxWPczL18jM
 JHnawK2/dbiG4Z+rBvc8Y56OxooGNfHldsu9S533v/gm07aWGm8sIEZi4McY4Kjrwy4oqDXNq5A
 owqom7NvTpuEnfvIpXb0xv+q1IHKi6wKLLcDl2CQOy0055jmEpmd8GOPFiF8T4BDtyMDa1Lcsyj
 1t5xqPKRYX6IugtbSfstsNCR9jaP+iu1hI0u9OslppdABGKJwh0g2sgJs10MzEQHFoC84lkNfCV
 /Vc1KPqoEJyEbcrF65w==
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a96acfb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=KFrTxiSEMK9J-XJLMaMA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: 48MTaeUeMW1rRHml6Y_zx55vXrQIGqk4

From: John Garry <john.garry@linux.dev>

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down.

For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

A bio which for which failover occurs is handled in
scsi_mpath_clone_end_io(). Failover is detected for blk_path_error()
occuring, same as how dm-mpath detects this.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 456351fee4b98..fd28667792472 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -256,10 +256,49 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
                mpath_synchronize(mpath_head);
 }
 
+static inline void bio_list_add_clone(struct bio_list *bl,
+				struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	if (bl->tail)
+		bl->tail->bi_next = master_bio;
+	else
+		bl->head = master_bio;
+	bl->tail = master_bio;
+	bio_put(clone);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
 
+	if (clone->bi_status && blk_path_error(clone->bi_status)) {
+		struct block_device *bi_bdev = clone->bi_bdev;
+		struct request_queue *q = bi_bdev->bd_queue;
+		struct scsi_device *sdev = scsi_device_from_queue(q);
+		struct scsi_mpath_device *scsi_mpath_dev;
+		struct mpath_device *mpath_device;
+		struct mpath_head *mpath_head;
+		unsigned long flags;
+
+		if (!sdev)
+			goto end_bio;
+
+		scsi_mpath_dev = sdev->scsi_mpath_dev;
+		mpath_device = &scsi_mpath_dev->mpath_device;
+		mpath_head = mpath_device->mpath_head;
+
+		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+		bio_list_add_clone(&mpath_head->requeue_list, clone);
+		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+
+		mpath_schedule_requeue_work(mpath_head);
+		put_device(&sdev->sdev_gendev);
+		return;
+	}
+
+end_bio:
 	master_bio->bi_status = clone->bi_status;
 	bio_put(clone);
 	bio_endio(master_bio);
-- 
2.43.7

