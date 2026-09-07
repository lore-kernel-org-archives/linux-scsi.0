Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163F7468C3A;
	Mon,  7 Sep 2026 10:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778333; cv=fail; b=TJRxJ2J00kxyqQ+D6zAHegYcc8AfE276qg5RvnDPwIoCfDB9KEDsPs/OA6lUZVJzdLQW0loEj+i4MBMjAGA5eH34ABe3vniKA6MLHlI9IiPm/dfyRNnq16cHoYpBJSgadNTp2FYzK6IrenZOb2HO8yuY8UisodjplVM6ZXdzJTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778333; c=relaxed/simple;
	bh=cCYbuWhd84FDxtj/k2JbLpd62ibteWkQiyApg0FrR8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JEnRIn7bkZZsfVDvlyXTZK2XoVfF0JFYv+tccpj6VHJ5xG1cQCwiQMUg6yzL335AVyECJGG68hU4F8JHTiFdQl0wvsLO4KfeFnFya2ANNAhinJns1374kysR8zX9x6W5jhlZQJG97WhY7kMpmXGEAvkH5pXC6jJmEllRWt6nbu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CW1dWn3T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nxGEGlc5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CW1dWn3T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nxGEGlc5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6872PTmw882645;
	Mon, 7 Sep 2026 10:51:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UXqE56dFlh6wU6U8s2kfr7dSMVfxo2IeQpdEa1NT6oU=; b=
	CW1dWn3TyZ1zouH/VyebpSRzcB5MXAZupO0ZSCsqktY/WMUuy6ki4W+5Gm4m5QOI
	I9gEatW1zpBdk/1tFr5uIyQSLS+ahh/DCUC6xWaURBRo7LLN0ib7Wik88gPEE2ET
	SxLgucC1LMb+2uMZjGVfE5lNWkXrZUT+frufv0gCInsPREdvtinwh6OwtvnX04y6
	P2/w/bv2+GqfOk//eNdli0GmJBh1qN2d/opDtqieeRP2TFy5OMASQ1Q+CaJsEplK
	7ypI93/Kzm0UyG0hId2a/QwSkHbR3BLJYqqwFWJarwDH0nJ8mtgXSGsJ99U6vYuF
	Wjk9SltlWo6Kd6D/HzYjqQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbd3ssy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687Aopf6019106;
	Mon, 7 Sep 2026 10:51:12 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlUICCwH9pjiae/WfmYyszSexYBYGy2krPvHdTNFTSRVEi6F91X89SfxUsaQzvV9GjNg4lKRwOyVJC2cleTFvOKPRx98FH4HJKFybn1jQ5a4FdT+qQlBeNz3q5jcHdFv21w9bv6hg0nvHZXPO3xrHCH2VgquClxj7Ssn5Oq3NpiVraYy3MQx28tsI3Y3hFjDLrSsayU+XHqQ8WO6fpUysvoHaUFyDeqwrTcPsKzINHQyJfvs4eTLpLkBQOBJzBzsDfTcvzGAOnv+IUIbA9FFdLvkddnBoeU5jIkvdroHKoTNjd3civx73BtuAhkh0THARbf9EK+HsgMVd+3KnCVTGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXqE56dFlh6wU6U8s2kfr7dSMVfxo2IeQpdEa1NT6oU=;
 b=YIE1koNzxH3ejKjSCUnN4A8z6rxlYHgOuYyE4i5I/2MFqegL/4cnxXg3kyJYnDpM8HuYJ52t7yGw8BKczAOqhMJPhRvX6vT9jILZOw1cW80WBPOOF3P85+8Hd9WOrVQ5JQpB69cNn5kCYQ2D1gfZxFMM69IMoK9F/Bj8j1KpzsBkfgoaui3YbJngt1TOwlLr767hdWk2GFVED5m/cMR7yUweZq5FwxO5cHy6kiq5B5I5HBOMcMzZ9Cfc1O36hWcyJqqXwOMOrNewtOQi2lPDYh8tHKeFfHY62E5U0g8w9tk/6iLojCTi8EZ2CT4m8BfsN2FPfHa5uX+OJJAXu4abkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXqE56dFlh6wU6U8s2kfr7dSMVfxo2IeQpdEa1NT6oU=;
 b=nxGEGlc5N+Iq30yE6M+2fg2DxKIdEIrn+t1dZvOAAgBr7uOzPdVVbefuxZ1p5yzRjJLDw1GHjuX2OrHhZ56mLE7moxOxIPUXPLczAq3sVA1/P+RjM4JQs6WRLEYFaj7c1BvBQn++TayuQDipqNSMZPPL2DjYqH3gDs9bmgEtJns=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:42 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:42 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 04/27] libmultipath: Add bio handling
Date: Mon,  7 Sep 2026 10:49:58 +0000
Message-ID: <20260907105021.1763236-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0055.namprd07.prod.outlook.com
 (2603:10b6:510:e::30) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: dfb07027-cf17-442f-ebd0-08df0ccddcd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lysLPZ3HdOSuu7nL0yH3qmFxbltmMz3Val4wqFKH9+YbL37UNKcrgegifqVdvt9ZI9gI9o/AVNMwyrR9WNmyH9K877dYLVJ7W6QHw/ZdOpENERJxzaabLNZFYhp0KQ0IrJFkV/FsStha6mKF9gCoDnZOhsut7/dMuob8xdUuRzB4htLWe80y92/T0U50jDH0jAoFlAA6+3nQcsUA7jRF1c0FmQzQQIjtiu87bQa+ekyJaLtoS19wzAGUkXhJGRT0eF6fzWXrCQk5Ttn9anExlXe23wUYebzYR+pJUHW5p1Bwkrh37R6m9lsEqYY9Hir/IvtvlBX79Jt6sdivxtOg7zvzVA7TmzcZLPqRtk/nIDIbX8/fdqXpKRl+6swgsLzxcGjeqxOVAvD5gChC2M9D+2LdpuBmcyUmO6h0+RcqrEyeZHAdG2tvSdrskyngxUUjBqdjdwNKh4vf2chBLnemPkksB6V/7/1GDoCLFBMSD1U3LfwlDjI5UvGm7VDm3LjmXauqMLZ3IbvOO7tFuYBT2vB9KsVQUBF70jMZMAihFA1d2avfboz4twEICv97WmVWy/oC5R6hFqYy5NjEJMlnD8WPiFkUUsll7dIFTAMdO0FNnLvn71U52jcl6QosiQ1yH6XiQKunSfL2gmu0LbGTUneWfa/tbB5DUuNDYrDEzxg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?scKuPoGugCuS97hXN67CBbN0xDr/lfnI9uefPeVTaVECunM8tIP857bSPeyy?=
 =?us-ascii?Q?yhABYYQUUohQfFTxXtimU11yMeIJBqTMEb7h+CHDGc/isOH4OGkKW27fpcfG?=
 =?us-ascii?Q?drKq5UnRXM8uhFBwaEIS1VYfZWEH48kjeSrgsztItyxVjyX1wFzZj/HSEy28?=
 =?us-ascii?Q?tHRafocIv/2lA2TD4sjTxzx9/h2QRDyuXo3uq/+qQQtvqTX6QytfeWu4Yu22?=
 =?us-ascii?Q?WxogD+Wl8SMQrl7IrmlbUrxBXt2N4adeYR72xTPlrkkwnjIz3yYrWo8+WAFv?=
 =?us-ascii?Q?Md9bwJg2UBCXbqJFVKppysYpI3QRieZZPUIzCT6Pl0mj9/VAkcnt8vhDavH7?=
 =?us-ascii?Q?ZqwGSufhctuyTXxBtCZHJ3ue0VOReofJBO6Je9S9bJbrNdGsNA1Q213CT76j?=
 =?us-ascii?Q?X+bFbm/MGaFbsuddw29w9Q4ewhKwJ9udeajdSEw8dZGmK+YpehHHqBo/LxN9?=
 =?us-ascii?Q?gpTyVjn1Bh4CGFpSNqOWnL+5y3GoaKde2N1MNNpFU6mi8VzVh3LxjmhLZv1C?=
 =?us-ascii?Q?+WY/w+e1e7Mlu5vbbhTNo66h6QgLdiym8Bhd+crnyILYBlzPBH0fK292HXhA?=
 =?us-ascii?Q?UPVdoJ3Ly6upv4pPh6bjwrDUoa/xyNbnes1WZAcr8JAUcSeQAmYnygues9RQ?=
 =?us-ascii?Q?kPMsML3+RhM8QdZflogpw7vrgdIPgJYGAmTdC+UlxrcRD92AnjDOGAwIoiyp?=
 =?us-ascii?Q?77Eekc8op6Kwdl46hqC1u2uwNatoZFtqY6DXX06zP6CmGL4j8/K1J8pd+Tii?=
 =?us-ascii?Q?akUgI3iaCLth9Z97C8ejLdvM3D12SUrNEdCo7ow2ZKgBRmLMHscPpFaAyyCn?=
 =?us-ascii?Q?fyK1bqMeK8Gt3oufTbCiSQfxkQanF4HgCbP1C3TQOEexpvRqmlCvpUSIkgDd?=
 =?us-ascii?Q?ZT42NS3gSQbSoWkZpoI+/uD54oLO/bwFgp460xwDHBm8FiEmfkNj0p5V7ZDs?=
 =?us-ascii?Q?OBq7s/BrncXeKy9fvRa93ItSpwt6CvVHFrYbPqFw22KDUzG3Uv4nIrA8IVwg?=
 =?us-ascii?Q?iilSNXfA67fknmBOo05KOUGZSKI7Si3XSloZfGoDkHtwsx3lTMu7ROm7oXC3?=
 =?us-ascii?Q?dCdbc/v1V9SIYGj3HMb183mRhDBcu82DGcV5KLQ3Pw34ZIOqjIQfV5DrlRz2?=
 =?us-ascii?Q?uRTFUuIuw7i2hDCdjw8rGqVp5cbPMCKv4VOD/0rrnAX9TyGtlwZ17qav0jG1?=
 =?us-ascii?Q?Fu6GtHPOC8lxaPUlvQDh1vaI5rOjOV/EMZgHh3GqVIehP81Z94y3kh0msKm5?=
 =?us-ascii?Q?FkZYerqjb3/1Zu9ifq7yEduJzqVT6Uh0a8NM+qrXAqZsm2IPyjW2W/9J8LWz?=
 =?us-ascii?Q?id0EsrLGA4HZwWaF04Z3M6HrdL4UfqtUqjTYGUmxUnm1oXjFzRtU5zJnyWb7?=
 =?us-ascii?Q?hhyVYJgR+jRDqFgkSZJK2+IGrA4qNFKTnxQhKzn259XFlFe4K2u7MmUUGce4?=
 =?us-ascii?Q?7GKieBWQveYPKyqlODX/PzXLVnmED9Yoj10kf7zNOTaNuqzrJvt/bPLplq6N?=
 =?us-ascii?Q?DlfwHgnoZLivaXKRcNAlffWwzSnQjzP6FzGet+/AJQwtMB5RukNi5+BR24SQ?=
 =?us-ascii?Q?hoyVxNf3iSMN7Fe61WdjmjIotqx2frUXEN6WQJZihBqk8S+XwdystEc3/uvY?=
 =?us-ascii?Q?ZuirKn4AJfu2oLY58UAYlv98SohMvIP/pDo+GjVxQ8dHSVen1dtb83KxD15n?=
 =?us-ascii?Q?nfYMGJCgsE6+v/XtWaCc5A1WiQ13E9D+GqwMQjUMPf1D+SQgZhCyLFWHpXUp?=
 =?us-ascii?Q?HLe7P3MnVoqcoFXiOFDAaV2X4WRIYLg=3D?=
X-Exchange-RoutingPolicyChecked:
	KfjPuTitI9Bdzq0Iz8z43EFK6Xwj8xquUAIQtAZaPvw+5knax1wVviMV0Nf+V62gOjbCGHByny1yit5oNY6CVabrv7DnQRnK/ywUxp/jEV6UlgpCkBW47VLjJTDegvnTLmI1o3LfCaFE5xlCK+4RYEfMoMSnsaXU2kUwmZo+Swg7RIYnuKzbi9OUD8dNnjn+eOWQ7YBeVzaIAoAXTmfw2m5iotoG6NS7YClTiLi4Lq5rTQmLb+V881ImHprNYgl49ULUesH12GVgSiI9cUZlE6XEZqvF3jAO5TYdgongFMSb3NL8FaTFMQDpWSVyooLZ/qsUqxwlBJM30N5Mi6JEwg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yYL4C9nKEHPS39MOYcqVNUvdM1EAzHR/ET3lbFKi16srGLjMtop5sq3t17Mk82qN65PczxtKc0DA0/RLK9LimEjceBDsrl5sPjtE/2M5u4spTetpDhTeN+eUmAOgic0A86w3gttnSm9hQxSH67SddocoE3mV6Q/dJympI73HNesA+bUeTY4ogWFkEUYgk6FSWnc01JOP7BVD3/N94h4eeitzK6XDUw9crZdQARe4hO/U9uQ241jZ3cSDjP3EdmfWprHeVMhewuH5xFkfBVDLmiLKiQeMcoV8V0oU5U2WqaBgjM/UCIX1qrGVTc4XoQpT7hBzJI7tZlEXyrXPE0a8O8vjje2NJdbFGsdHvqgeQR7HhkGLcidW1QoRfnDI4i1hsFNmVX2bnPdQ3j/QEr27K/m0OdlQq6Mw29gYBam2SEvQkeKHYgldw+knJAJM2vQbKgf+KIcMcrkI6pTw6B97MzpaSLskxa65GBr0ZK4C3gvnEJ6MOus0fbTOW4v99r0Yi5nxUYw2WUj+HkKcEkr5JkgckkArise9ZErWzA/snFF30P1JSHfCJH7IMYprEeJmb5LLoissF1QB+dXSsxPTTbiVx9af4W+0/79SctLmiiI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb07027-cf17-442f-ebd0-08df0ccddcd6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:42.4953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L1XOz4RCREjiFnCbn7vsMWunMf1mwPTT9wrI2JAZxjFUo7xmpZ7KCRgkWEILV4vYkFWCQearA8BMFqxOwJZjSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=EuDiaycA c=1 sm=1 tr=0 ts=6a9e9720 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=0Q2gd2vOsnR98QmcnEwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX0UuNmpht8CNs
 X2/8KLTYbGet+UkC7yc1pAXo3aSLzyJsOy/djLNeSRIc1NBbBXL1+XuretLrfp6cSEu7tl3Knyz
 hDu8j79A1mC3z+SA1U6DCeF7gsy4snJfjpYgGBoDyn9fgR1OcMXY
X-Proofpoint-GUID: 8FexTgZYS-sZ0EETMr2xRF4pfrQTt0J3
X-Proofpoint-ORIG-GUID: 8FexTgZYS-sZ0EETMr2xRF4pfrQTt0J3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX1j2cAugRgxnk
 FmjDOn01Wy5Wpp9ow3kwVDPzydwc1iYXCVWSMcKnyIdzvOUheKo2u4qD81CWnIhwIWCnBK4Rgz+
 dYIcijQhqrmbj0fKz1DBdI/leylThajVS390wOzstAdSVXOxvde3Szg096MTZl+rY0VAbam9xkS
 EoaWI60PQOI3Js26TW0AkZ1pK5EI2Nd/vQ4K5sMFGE+k/iNHnFXWPyzibU/obBhgHcFcZee5iNT
 3I5ntuHJk49wBB1z1B/ajPcy67qAX9oqg+S8rAVDONXen2JU9NnD6ebyk6vHYlRgV64Zt5y8Hoq
 dLX1LPcFroBfd5YMfHFKhA4HtKieLRzLujX1NIUFu99m1ZmITdTi7y9abguECkvYTrHLV2pZdBo
 rnSy8njhh1+uyfGit7dcEgXCUlI9azge+994G5B6W7gHi47UZMPwbzvxfpyeFKZuWAV8QtL0ApI
 n5u2D4zV8DUXAt/6XfQ==

From: John Garry <john.garry@linux.dev>

Add support to submit a bio per-path. In addition, for failover, add
support to requeue a failed bio.

NVMe has almost like-for-like equivalents here:
    - nvme_available_path() -> mpath_available_path()
    - nvme_requeue_work() -> mpath_requeue_work()
    - nvme_ns_head_submit_bio() -> mpath_bdev_submit_bio()

For failover, a driver may want to re-submit a bio, so add support to
clone a bio prior to submission.

A bio which is submitted to a per-path device has flag REQ_MPATH set,
same as what is done for NVMe with REQ_NVME_MPATH.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  22 ++++++++
 lib/multipath.c           | 108 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 9bbab0aa8961a..374f0531f7e07 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -3,6 +3,7 @@
 #define _LIBMULTIPATH_H
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
@@ -29,8 +30,10 @@ struct mpath_device {
 };
 
 struct mpath_head_template {
+	bool (*available_path)(struct mpath_device *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
+	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
@@ -44,6 +47,14 @@ struct mpath_head {
 	refcount_t		refcount;
 
 	enum mpath_iopolicy_e	*iopolicy;
+
+	struct bio_list		requeue_list; /* list for requeing bio */
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work; /* work struct for requeue */
+
+	atomic_long_t		requeue_no_usable_path_cnt;
+	atomic_long_t		fail_no_avail_path_cnt;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -53,6 +64,13 @@ struct mpath_head {
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+#define REQ_MPATH		REQ_DRV
+
+static inline bool is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_MPATH;
+}
+
 static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
 {
 	return dev_get_drvdata(dev);
@@ -96,4 +114,8 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
+{
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 3541357d07f8d..3b801c52e1a3b 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/multipath.h>
 #include <linux/wait_bit.h>
+#include <trace/events/block.h>
 
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
 
@@ -44,7 +45,6 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
-
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -231,7 +231,6 @@ static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
 	return mpath_device;
 }
 
-__maybe_unused
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 {
 	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
@@ -246,6 +245,81 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 	}
 }
 
+static bool mpath_available_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device;
+
+	if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+		return false;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_head->mpdt->available_path(mpath_device))
+			return true;
+	}
+
+	return false;
+}
+
+static void mpath_bdev_submit_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct device *dev = mpath_head->parent;
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	/*
+	 * The mpath_device might be going away and the bio might be moved to a
+	 * different queue in failover, so we need to use the bio_split
+	 * pool from the original queue to allocate the bvecs from.
+	 */
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (likely(mpath_device)) {
+		if (mpath_head->mpdt->clone_bio) {
+			struct bio *orig = bio;
+
+			bio = mpath_head->mpdt->clone_bio(bio);
+			if (!bio) {
+				bio_io_error(orig);
+				goto out;
+			}
+		}
+
+		bio_set_dev(bio, mpath_device->disk->part0);
+		/*
+		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
+		 * enters submit_bio_noacct() for the per-path device. The EOD
+		 * check already passed on the multipath head.
+		 */
+		bio_set_flag(bio, BIO_REMAPPED);
+		bio->bi_opf |= REQ_MPATH;
+		trace_block_bio_remap(bio, disk_devt(mpath_head->disk),
+				      bio->bi_iter.bi_sector);
+		submit_bio_noacct(bio);
+	} else if (mpath_available_path(mpath_head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+
+		spin_lock_irq(&mpath_head->requeue_lock);
+		bio_list_add(&mpath_head->requeue_list, bio);
+		spin_unlock_irq(&mpath_head->requeue_lock);
+		atomic_long_inc(&mpath_head->requeue_no_usable_path_cnt);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+
+		bio_io_error(bio);
+		atomic_long_inc(&mpath_head->fail_no_avail_path_cnt);
+	}
+
+out:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -291,6 +365,7 @@ const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
+	.submit_bio	= mpath_bdev_submit_bio,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
@@ -308,12 +383,35 @@ static void multipath_partition_scan_work(struct work_struct *work)
 	mutex_unlock(&mpath_head->disk->open_mutex);
 }
 
+static void mpath_requeue_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+	    container_of(work, struct mpath_head, requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_head->requeue_lock);
+	next = bio_list_get(&mpath_head->requeue_list);
+	spin_unlock_irq(&mpath_head->requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		/*
+		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
+		 * to allow multipath to fail all I/O.
+		 */
 		mpath_synchronize(mpath_head);
+		mpath_schedule_requeue_work(mpath_head);
+
 		del_gendisk(disk);
 	}
 }
@@ -325,6 +423,8 @@ void mpath_put_disk(struct mpath_head *mpath_head)
 		return;
 
 	/* make sure all pending bios are cleaned up */
+	kblockd_schedule_work(&mpath_head->requeue_work);
+	flush_work(&mpath_head->requeue_work);
 	flush_work(&mpath_head->partition_scan_work);
 	put_disk(mpath_head->disk);
 	mpath_head->disk = NULL;
@@ -384,6 +484,7 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 	mutex_unlock(&mpath_head->lock);
 
 	mpath_synchronize(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
@@ -396,6 +497,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 
 	INIT_WORK(&mpath_head->partition_scan_work,
 		multipath_partition_scan_work);
+	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
+	spin_lock_init(&mpath_head->requeue_lock);
+	bio_list_init(&mpath_head->requeue_list);
 
 	return init_srcu_struct(&mpath_head->srcu);
 }
-- 
2.43.7

