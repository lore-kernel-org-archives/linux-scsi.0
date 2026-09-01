Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AEF481257;
	Tue,  1 Sep 2026 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259620; cv=fail; b=Jkfy1deS/OiKRN3Kwy2/iujRhzoaf8RkmL7Xm2n2TNn3k6sVMT2JtN5oa0gzgspT56yKVTg6qA5hxNqHLyOkDcekeXGBXjGSV9tghN9E+zJR4/bSwEwM9jFOBUsQc1begBTmGz0RyMOG/j6+9WYJEX4ieqpQFPa+JNcgzgWKjH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259620; c=relaxed/simple;
	bh=d3JsohD+1ktlmBsB4BBgruoga/C5ZGx8CogqWWHpUDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PpphEyMobY/pcrt96McLtqlDJtIZ1bQG+ivjl4Ke/8snT5nTwmNz4PeFwqPe5vGqCfR52Ryv+lVr8lQsCqsiRDQroUCgmKmV+RZjzF9kBXK9a754BeF62qnTkAgLirRRySvUI0vz5BskOywkKt/tm+XI9DEx3Fq8BXgpKOMODS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h0rsLkgx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CPix58C+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h0rsLkgx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CPix58C+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBwvc2296648;
	Tue, 1 Sep 2026 10:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cCoRpVZw9uoat8cLEDF/DzHvx1Z+pfSNUE4Ge8/1K88=; b=
	h0rsLkgxrV0P+MTkEjiR7FYN8unKmcHRcFId99DqPOHGoXRUXp6dj+eV+FYg42FP
	qHBxWEnPFj2QtRPuKkGkNt3dMjNRHzvJFT7+ESRKBAU8x7Q1jcyUjsnjJx34obif
	UDYY+XrthlqRNvVHc5R3YPVPx1SwQncz6KUSGrOsCiMLwf5J79mI/8cxSP0NxLCl
	WFqOszIHptUq8wvFawO6JOdt9P4T1rdrKDkxXC4OT4M0XV0xYVU6yq1AzasVbm+J
	FpJQTN3+x2DR2yQuoYghZYv1ctnAeAIfDzXWhDaeS5Dp+0FpOWmT3znAaso+iykJ
	3DzjrGQGxSXcjjU8VOmkpg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xvdbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AYuBK040245;
	Tue, 1 Sep 2026 10:46:25 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve8n9d-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=igKGwi0/PWcWchUlqZJypVtacVnSN/TAFJJHMFj7s+2gdIh/kq+/7iW4TVCYO+Si56KzhxyfTrHnlFj/DnTXhZzn3yqaAKZZuQjcfbN0IW0YIZ1UPafgSxQ1Ev8Qn3P3+5+sOJFk+0g16dGoGsnVY7tbchjMDsMQ1h7RggeExzRKYxrv70bVs3QM05Jq8xsJcC+cyWlB9v0OqD9ZWwG88Q3mF7bpcrMp0BvmVNW0zeLDr5oefv+B56zdQiVSX/GxucGuK+uKLF7c+aIwALmlCMpRfAVawOL97c5xOsYRHWPgENVAwVjYfHztTbZwVOYOKYmrsNtBLHHmK44DzI60dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCoRpVZw9uoat8cLEDF/DzHvx1Z+pfSNUE4Ge8/1K88=;
 b=Hj/9nCUTsLvVuLFaNsSyD8VkAOq9narw6UHzUkk2uNtN/YpghP/H4ZdEJxXHW6CDqRf+XodQ/9q2lJiIWPvqKgslzpSosj9R9aKoi6RTC72834V3kw+0F3JtsOutLxgp17r2OEVrKXaL9heT21PSWxwbDGTdZtgQ8LocfchRHVaboQ7oy5caog4Jzuz+ZbKFddjSfS+Hey44euwg8qyB62EkoKJSIMu/22eCC4yKJbFjs/TEwYOxBVr42k+DoPIbLGuG+pKYfTzgnpd6Q9is6QtitZAedfP6RsNSUBrIy5le1UuGVv4y6/2i/uZDlXLKD6CRd8IQ/fqsjRgiaRKOWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCoRpVZw9uoat8cLEDF/DzHvx1Z+pfSNUE4Ge8/1K88=;
 b=CPix58C+VvMaIdGcAOV4zFs7qOpTpr0wOkq7M8QlQt4ff8nR15Mp8iKgmh/jQ4z5KgB4sPS+DPC+UYFV9jRsyCHNvuL6zCPX4RMt704ifdqI1q0N4D6A9/B9EltuO9F0cy8o44xNUZSH7UssTE9o1brGIz8ctrPmIIvYVBm0LvM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:18 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 20/27] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Tue,  1 Sep 2026 10:45:19 +0000
Message-ID: <20260901104526.3850621-21-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f69b4e3-e9ae-4336-1833-08df08164120
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10063799003|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	X61iZOEAiNM4fc4yojsLEawq/Aj8boRRFzuFEvsV2J+K1Lu6EYRumIkTFPVzjHZVkSrCCv1RURPFzpCz20Wo5BZcg1YmBXMocQTtyCPngpqa3x/WN0OxYi1XXajNGpAVg2bSh5vqUpcAPH+MsmR8ily3MC+eDr4KfdbYZQUoKwXgVoin7fS63OfSUetc4DFRwnJipcosKClHYbcfX3/M2P23VWmMtGNdgIUl0t0sY9uOHTpUTl/qgLlqLqeQUw8V00uSfx+AIqS3ZNJT0b6yhppmdij33jhgmY/9HdZ1fGgkXPY3Vfoa3cEdZOddDXW+UIpGAD15JA//WJWpr6kRDb4axarRIC0rHreMLYBu/0M7dJQztx57eCAgthVd2WjR5HUMQSxdd9rFoDFZdoM+dcsxPCAgMzvFEI1tUeBgZz3Ytg/AjO48K5n2mEtODB2srLHzxitJ8qOtauMcfapJD23KGGQLgH2kQRB6wwWqcMCnuEg2RSrdgM+16edA73k1bMFv0xNm3RAYNIZbvfYv5XWm+WfnVwjaAIjod08xFR1zbe9fVLiJ4Bf7ptuVgqtUzvUs86FyEorwgv4epfm1XkSsqor2PKWHUbzui7UjnCg9lxoJ0nujuuvhpq+1LQKNJ7KMjFZUGd08HChZzmPzyMFHdPO2DEuIBrA15CB9NeQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10063799003)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7BP4XHOp0b2auPMrGt3b5/SOGVauNsH8va6UUmrmKYt0mctxvg+DngCV7iY9?=
 =?us-ascii?Q?L/azcWEPvK1IEthStd9riffnRLdP7CRTfPDvtKlT9EfP7ngSr+DJeDXTz6Zk?=
 =?us-ascii?Q?+EqxuaY/xVjmwFVvzh6TmMJWRQhOvlsfaUfKOuRJnXpaayvdO0nxa0GxBbnn?=
 =?us-ascii?Q?+MaOkolGqZcy5df+qarsl5cL94LjodzEUT2juZocQhwgi3N/A6vvV2kYzJL/?=
 =?us-ascii?Q?c5I0R4GZMeV+wHvskWREs9sBbhKeS7dSbsu24RSu1wOGwhkTaWGGSlMPP4yR?=
 =?us-ascii?Q?ATjAc3Szf9O+W5Nw1R1QtZhKPLxuMQVDxTqm3ZIun6PU1HHAYsBMvzXcGVhE?=
 =?us-ascii?Q?gUQ8gdofYQPckn5AzseqWUptTYqlaGJG6GTWQIvuwA20xiuHBxMRvWtrRowE?=
 =?us-ascii?Q?Y5ELyl6hOuKG2YD9Rbmk2s1vmPQAV7E+rPRiIQYkBhtQcnGn+c88p9SCDxlh?=
 =?us-ascii?Q?1vC+CuyMWDcPegcfxWX3YKGeLOszB21AhYp32tQXWAFztEXvJcXEdZSxbnSF?=
 =?us-ascii?Q?BOlEZLeBV4JkkgWk5yYHWBt8TgLQXUuUwyyKNYt/+34GBKFi7F7jztdRiwJ3?=
 =?us-ascii?Q?fgUnrT6FQqKeIhtg3F66ahq+Z7dLVZeusqeF0V+DZzJ/Z6pH2peKlk80heqQ?=
 =?us-ascii?Q?lJPum9vzH6+mmke0C6R/RVqhRm+UVnn9+xuZtPhat9GXIFz6Klz62hNH8CiB?=
 =?us-ascii?Q?+wZiHQWFJwF0wOSLS/webBNlAxBC+j6eNdbiBIOBuUIg0r25IlW3oJ7kmgtK?=
 =?us-ascii?Q?H/u1NP2aLcKjThIFiX9OSNERAvZtFpnsvY99zTjytlirrgH9uq9YUz4Wj/Q5?=
 =?us-ascii?Q?Jb36PvTkZSe5vS42EobDiUL10kMxuNgfbf1MEnix/RBi7WC7SINd0cqAVVgr?=
 =?us-ascii?Q?stCOsJtpSlphggkiHRXUinrWPJwHnxT/YTjjXFjRv6Hrv3F3xUjo5xjW6+hb?=
 =?us-ascii?Q?JLbBBVw5+HrRxoEHwhQcY8qs9GQSATC9SjYEmUkDn1yRaOEWnYZ6jC+qCg9K?=
 =?us-ascii?Q?h/D1z88vdryxF3aqVA8yGhvYkMewshBo92MAl1kAJINoY7+MGrtB0fk3fYfB?=
 =?us-ascii?Q?2tJR3jZu+seq8EOr4HUKcHhCGUm7jcLFYJNBU26TgMPYfqh4WYt/Opg6zN11?=
 =?us-ascii?Q?Jwmom+PDXrOK2i8HG3Kl4BCGFq5rr406gDxkzpxPRGB83+QNEcWZiso3bFa/?=
 =?us-ascii?Q?F6xbWzdNETjka7T10QPIGmMF0dpMZDnAK2+5VHQpJN3Xr4CTTjS52lIX9GKR?=
 =?us-ascii?Q?3AQJzdB334kqnI9i9mBHPWR3QB+gJ1GOSijqSNbcmvNZxd4DqYyFpnykKVhW?=
 =?us-ascii?Q?kFTlabjqs5yz7fSNlXPQMkHbrJvAOzdymSzab4pjDO3aUeplaMlQlDrhRRIk?=
 =?us-ascii?Q?u3087DjncauwNjtFXPG4Tfyn0tsK0ximf6pwfi+aChUvRMCwg9oaCgkMpSfc?=
 =?us-ascii?Q?SmGbSga5qYzYQF9LGF78heStQsGQwickzSKj0V/1FCigyu7VUT9bIL1SZdF9?=
 =?us-ascii?Q?2g/LxG8WdEMUElaznsc1eH35Qy8tCrHiTcd4wjIphmCPGDQaejGd0hHN8YXO?=
 =?us-ascii?Q?cJH4BqOMMvTw0vIkLqJboHMl9R56nIvs6B9tYDhX+tQPTedOaS6ihHaVxfYV?=
 =?us-ascii?Q?bYtnBjIMCwKFCSw8/JPSv5UnNRIoG+adZffpUlwtq1cGe0XU8qvMPOjC9Ux8?=
 =?us-ascii?Q?76J0ou9Y6KXrL+KYeVGmiLY+YQ7EegB4XGvK2xjEJk8FmNyD/4ZCMbmLlOn7?=
 =?us-ascii?Q?PgOwiAubZerBII0W7hCb5E46Vl52Uek=3D?=
X-Exchange-RoutingPolicyChecked:
	VY/gOHptD0NkI69I2IGA9906NRgHG6IHCfqFpF/ipReRzEXbu1UfsgnK/jQVZ8L4PzjDB12BQirSIkfLwB0WLaRjg6zS1hV9zrff5APbSe4lIniuVBmTqvysPwHQjT4XZlAPV2HiHKoQm6Xzh4hFazzNKpbUv6T7bxuYkNxRNL+LfPKgnWVli++HVkbDyANs4PAJvoi+3YTge/GsEYCDWtW6sUQ0FyPxHbCwhEB05/kjAeEJDyR6TNPGJ47wkcOhv4iTRtZk5dxP6ZcoSrYdDwyGA0PxlQ/RgmyNhzQBTWfOlThl3OwEbcBfiTDlyd8w7lfvNDhc/M65lObzRxjJ+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C6VhEYij674aBvwmR267gidiX9jtPAHHwpZ1yJW4+bkunf5+He6r0W7Q3YkyF1XIbt4yCudfdOvRKLcBQmWojym/fHmLLjdabcjtg2slf/2ZMJRU18RdWJhzQiZKpbFP28Q65W+UTRTdCtiuXhYeskqieCPhJa2LQ6YINWQDilQkYZboD5fHGNV81rilr21UM6ua39TwVUhVRsBqiwAkbiPzurpwhvcbWqgrDJPXpelYwlViHyuRlGiVqetagyMd6D/hVBvyh3JXsh+3+ET56K6EIwTRhoPATimwXwEjkoCnv3kb5lsGimtKEe0Jok2klp+PzwSlZkIY4fXTocGPJAvezjwFyzIJo9uQUWNjQRdBwaT+7jNeG7Kjfk3x3zCufv3e61+pRsHaNnK6sl64djE7jzdbXyn5Ztiyhr7VX99Kkgta9l/u+UZ0C8JZ5ZESVAK+rPQ51CiHIxRoPf50m3dAvf6RFCFJZP2A+cGvnZQXIEJuJmoYFGiXwCdjKhbQVlxNOMLnBUx7EvhtiKoRilHcXGbFWXW1ojatLCDwyQup2FNIZ7fdtsMJ3zy5wPHGyq/aYE8OqOkev4YPFI+Gh8idoq61NSw1aiTOjKeI7LY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f69b4e3-e9ae-4336-1833-08df08164120
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:18.6537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vx/HjrAcfRxHYuUL/4VmODbZkt7WldT6UUsP3k5Rm5fhT+S8+9C+F+rCUCZEaebba1YxLvjydRMxLXePKMqjzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010094
X-Proofpoint-ORIG-GUID: JCXNTZgmOorkP2byBBbA0jntTVm16qJy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXy4ulH9EGGVeg
 CBffE/QjcvNnOAAiftqRDw4+5i3vudf9+kje2NJJsug+CteQFs+lc5C05rO3LtYjKVUxUKwLoiD
 1dcUWYWM+FVLNRbF7XeUsmlemOec/hsr4JAjDu41k6qiyJjU/fp4uUY3QYvG0D31/0UXwz2jQB2
 HOuVKp9p4454Mc2hvGwOR8bIIG9GigoNhO6Lfqk56kH20wcjR/pLHpPQiygtPitvGO7OActjfFc
 4WDf515bpeh7sz/OR189K4MaixqAZANUu3CovG8viM89bZ5F3xqCGHlyDVd/08+XPGxqgirPVp3
 ckWMXrk0oGYlWXl/56tEndPuHDEnA9/TPP11l8fb7h3y1P3VCKZwdD2JVUVmFyMGVUsleT9of6/
 zoJphzqsgA7U0alOfhwahi9YAawyvTb0ft5ifzF2G4zgLXRuyfqq7WHYS92pjJzIdkRb9HFORid
 7dfMjG8cTtbub9ctFtw==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a96ad02 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=e6BYPIScm8OiYhIHgSgA:9
X-Proofpoint-GUID: JCXNTZgmOorkP2byBBbA0jntTVm16qJy
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXxz26rVLWqk20
 w7ICamUFg32+EmwNJE0LVfqf+2tYoMpdSwP8nhMQdErn3JEETwkuWDYsYiRDN3s35DoqyVA4/Bm
 hBqWa/qBVabPrdr82isc3y8NycI8aDi2V+YSZCLrlYm9RWRo2tRi

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

New member Scsi_Host.mpath_nr_active is added. This is required for queue
depth multipath iopolicy.

For NVMe, this count is per controller. The reason is that many NSes may
be connected to a controller, so congestion should be judged at
controller level.

SCSI has no definition of a controller, but SCSI host is a comparable
concept.

Indeed, many SCSI disks may be connected to the same SCSI host, so it
makes sense to count number of active requests at this point. However,
for a transport like iSCSI Initiator over TCP/IP, we have a separate SCSI
host per SCSI device (so there the count would be same at SCSI device
level).

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       |  8 +++-
 drivers/scsi/scsi_multipath.c | 69 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  9 ++++-
 include/scsi/scsi_host.h      |  4 ++
 include/scsi/scsi_multipath.h | 11 ++++++
 5 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 189263ce56624..5916dead5422e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -669,7 +669,10 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	if (blk_update_request(req, error, bytes))
+	if (sdev->scsi_mpath_dev && is_mpath_request(req)) {
+		if (scsi_mpath_end_request(req, error, bytes))
+			return true;
+	} else if (blk_update_request(req, error, bytes))
 		return true;
 
 	if (q->limits.features & BLK_FEAT_ADD_RANDOM)
@@ -1918,6 +1921,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (sdev->scsi_mpath_dev && is_mpath_request(req))
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index b9f6b1eb3c883..a80aa2101ef80 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -568,6 +568,75 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct bio *clone = req->bio, *master;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_inc(&shost->mpath_nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (blk_rq_is_passthrough(req) || !blk_queue_io_stat(disk->queue))
+		return;
+
+	if (!clone) {
+		scmd->flags &= ~SCMD_MPATH_IO_STATS;
+		return;
+	}
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS)
+		return;
+
+	master = clone->bi_private;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(master->bi_bdev, req_op(req),
+				jiffies);
+	scmd->start_bytes = blk_rq_bytes(req);
+}
+
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+				unsigned int nr_bytes)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct block_device *bi_bdev = NULL;
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS) {
+		struct bio *clone = req->bio, *master = clone->bi_private;
+
+		bi_bdev = master->bi_bdev;
+	}
+
+	if (blk_update_request(req, error, nr_bytes))
+		return true;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return false;
+	bdev_end_io_acct(bi_bdev, req_op(req),
+			 scmd->start_bytes >> SECTOR_SHIFT,
+			 scmd->start_time);
+
+	return false;
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..52227e2cd9749 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -58,8 +58,11 @@ struct scsi_pointer {
  */
 #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | \
+				SCMD_MPATH_IO_STATS | SCMD_MPATH_CNT_ACTIVE)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -139,6 +142,10 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	unsigned int		start_bytes;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 16243ec376cd9..1f0b10fa58825 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -757,6 +757,10 @@ struct Scsi_Host {
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
+	#ifdef CONFIG_SCSI_MULTIPATH
+	atomic_t mpath_nr_active;
+	#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 6e50da94fc5dd..dca1307c9fa46 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -57,6 +57,9 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_start_request(struct request *req);
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -109,5 +112,13 @@ static inline
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline void scsi_mpath_start_request(struct request *req)
+{
+}
+static inline bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes)
+{
+	return false;
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

