Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921238528E;
	Fri, 10 Oct 2025 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105727; cv=fail; b=LQY0hLSniQtroM+L/8D5BtvYqKltPnCz/1hbJnz/6JKBwWo4AA14zSG5keTPxHeErp0VGVjTOx6kHhK9CT9hR+5O8WOfgqjndEESiBSABz65/+66VSLUt+5UKIhLR94MFcgu5alD4nTsTAfLuAr5m6CWEYviFeROjlQMyv9mB8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105727; c=relaxed/simple;
	bh=O4M67R3Wp0nWo0XWfKV9BHU77M58ibMWDt+VDha8rYw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=F6tZCIjIebkdAAhilfXY9l22HhnMbAhuldefVnp6JbMLW6n6bEB40eJ0CrJxu9TxygkZ5mE+yxKc2bbxQehBH+1rG0hN97efL3ZbkxSz1wnn2KLxMLSPkVHTCPAvz5cg49YrAbfpUf2NtOFOq3ay6FqX4MM9SF8Qpr+PrN/BT/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y4+nwXNd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w2f+zorX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y4+nwXNd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w2f+zorX"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8tMVf032425;
	Fri, 10 Oct 2025 14:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=TeX+VgeXJOBgR65w
	AOdRxSBPUPk/Jia470O51AHYoUs=; b=Y4+nwXNdcGjDDCSo2WN47NsON4CHuIiE
	SXSWWDgUWmeO1M655RVjyebOJ9x5zRw/MgjjXCwWlQpG/JSXpV31jA3xFpRk86Rf
	gFM1AqwQINxKM2B08mbhNhDd9Tg1s53nTFz6j9Ggs79ZO45YVa8B4sueAIUX6yEI
	OkrhRETkKqGRl8ziWR/ltHGYHMDNRlCtEm5QC+oP6B+TdlFfhXWskj54ucsfqGmG
	n4uY74uNsS20tbCnG/xWmdw1jvfYbh7RfyO58V4gsOhirJdLoyxY8/XOC6ZxbQtK
	z1oZeSXU/CPSij/mLbWvLJXM/nvx40y1X0tA21/8ZRdyr/125XRk/Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv6d3t7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ACk13Q029101;
	Fri, 10 Oct 2025 14:15:23 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012008.outbound.protection.outlook.com [52.101.53.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49nv699pnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=am02BLWFL6eXykCjzq1Q4gY2o8joD9F/Qqwh0QJ5fSL27ANzz61HXFZiB/iWuMe/7N7SdUe53NTNlnFv3Nolp80n+1xpw8W1/WBuCEOkfg40ENR+81rhPykZjPsX8v1dPDbYf2WYxuizHXtX0E5nqS+2MQwyoqG7t42h7jR5TLl/6GvGyrfxgEHJ6aPwahlSbpIztzzWT+GanOflwhAAGq/CEL7lIZDLJLoGxNPFOj7+ZMOSlUngU5fzPobsepTMtFtelGsL+jUtP1NZtFf35FGEO34EVtl3SOvwi3/NWCWkEsmb+X1qqytOzb4wwtUkT5KdzccKkiQ8otMahtcI9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TeX+VgeXJOBgR65wAOdRxSBPUPk/Jia470O51AHYoUs=;
 b=j68AGFyHAWAqz9pqtrS8koEk8uJkXpWKLrxCwjWgPODV+BYGVSyF8x4DSziiPtjyfhYXzTVXJItLjKhbqB8OCV47B/mFHB4kNPYxfp3N2VhtEWyga9+wtYGboylAwsYCGh1sd4AIFP/FSNtZQ6gA0RkIp2Z6U4+BkM+vs9pRdJcbgGGNh7SnejxIqG3o+AHXXylKH5QeP6LUdhDSZ4rTJ4xUyRx854qsWhrnWaug9h55RAjopCT5OTcDCYvIQ+7PpoXxyolgygp4VManbU/PLksYPNhXXgGL9iGZByQUgloubieooB2WpXDSoHXSXV685bLw85z7eSPnygjAzP/QfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TeX+VgeXJOBgR65wAOdRxSBPUPk/Jia470O51AHYoUs=;
 b=w2f+zorXrzk81T//vZc8oEcrlUVBxkWLY2nGYUB9sXxsC9GI/oAWiZSYn2vkKDoZgD0tVYG1Z9SNbWq66qomwarTva7fc/VGporekCu7qY8HVp3qeSabbnXPaTi3atbw9+tY0pVybanM9iKObrCNzpL2lbEu81YiNIA7jyaUuzA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:15:20 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Fri, 10 Oct 2025
 14:15:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/7] scsi: target: Add WRITE_ATOMIC_16 support
Date: Fri, 10 Oct 2025 14:15:01 +0000
Message-ID: <20251010141508.3695908-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: 55adce44-63cc-413a-17f4-08de080770f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pjr6B3whfbhhFohk+5TfBjIDLgnfZnQH1dRKmdKd4/v9zT9GhHk4NlFkg7Fa?=
 =?us-ascii?Q?DamJhGsXIowJWxrCOSZfLNr/osf5PKqTBeNtQk+ujiw0R+Cu2buqDMsnxQA4?=
 =?us-ascii?Q?yzJMnW4x8rTuNvAREbO+NlWWEMXWhEBJN/SCO/I5ev+dIf/Hb4TlztBRJE8X?=
 =?us-ascii?Q?9jDXYwFTaMuRAoEG9xg+7joy+aE+eJd6WaQWXWovQ7OR9/X0W9On2A28lrFO?=
 =?us-ascii?Q?kJ9S51JBqyuLQ9Vm3DyfaBZqqH+NsOgrf9uxGzFR6xv1d2cEJfPiq4XKzbtG?=
 =?us-ascii?Q?8hLbNkJiS9NhGqTmc8o3832DFeXgFJ/u91AsAzQA7RhIygqUS9fAj0OjYqe4?=
 =?us-ascii?Q?6Zq9zmYmDfI/sgmed3KSXozCzIQTFOz0AZRSYIB+8Vu1NsDoM7+qrzT99/gu?=
 =?us-ascii?Q?ocM7mMLVwb28iC/tzrkBC3tpYnqqKttAkruBx2qL8jcYOOLc+hjExUolAdVf?=
 =?us-ascii?Q?3YbhXcjVuXgoMmHQ9tM0oVBGGgFEaMa/fjb4buN/4aVh7SCM18CBxq+s56fr?=
 =?us-ascii?Q?nOcQ/ARtkUZ1C0ZSLUDp2ZLVjIA5FSWmp0XlTAyfytrgY3+dcSpYozz/5NGv?=
 =?us-ascii?Q?lcds9jaXJPQsZ185u6nQjHLlvyIDfD/mRFTugGXiBUj3J9reeCGweDs9xGvx?=
 =?us-ascii?Q?EpdIocwQvpzYGf+fAYoa/aQqbmmrY/5/jZC1hl4FHUpGFx5M8GtSKsZs88+/?=
 =?us-ascii?Q?xr34qOBIpCArYm+xegz5qFfOnCpGD/9GHwx78KuGhLLZGpE0dFvYkwWije0v?=
 =?us-ascii?Q?q3AIj3kEtzXvVozbzfM4fgzl8tb8PuHVFweFjnn8KJwtq5uSShE4MoUXCjbV?=
 =?us-ascii?Q?nWMlxO9hoj9MncHZ2HMomzYl4aAaTydbywn8w/+B6iQATpNEJv9x1bf8ze0Q?=
 =?us-ascii?Q?+8s4E5spTaEhNzI+9bWrj5gUDpznq5+rSxAX/F3G6uV0cyzkFDcTxZ1d1PdA?=
 =?us-ascii?Q?Gv5AL+9HFddmRcFtNmQaW0tKbia2mlEdSozeeeK+z7ys6XO5ZhhCzayzbBZm?=
 =?us-ascii?Q?NB1OBzZ9qs9IWXOzZVIqShTQxmaqwsCkjG87c6YaHF4k6dbgAbq6RmzsMd66?=
 =?us-ascii?Q?VY1F+4JXVFcHc51uXyRJOgu4SJzXUFNTkAe4N6709Gs8HKdhf5A8/iJfeQ7c?=
 =?us-ascii?Q?f1lzRF6QVU6BEbGulXENVbIVs5BnuvHhGhu5JPyRr9WKBWJCZXZ+e6Z3gaXn?=
 =?us-ascii?Q?Xw8G+aP+qQQ0sEZWNPINa1Az9uDXHRwl1E8ky9pCcQrnfvTh+7Sz43RhJ2Ph?=
 =?us-ascii?Q?g2U3MhXg+tDE6e+EG8BbnAmrZnwqPEzXe48C+4uoGYfPlYt+aMbV/es9kT6V?=
 =?us-ascii?Q?FvMsPsrqKQCBEgUAla0uzNCHcOnyGkcm/922MW0cJ2fWZ7FqY+5vDAiFtXjy?=
 =?us-ascii?Q?zg5DHUJ28LfNAwmqJb0Z1X1SFMGd8fvMnDQ10xy5gzGa5DdeczB+XJSc4w59?=
 =?us-ascii?Q?Z8bfdDnMN8WvfMRH2xn7iwROR1/dfaYT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gq0Vleb08aKwUexP4kg9Sx3vj+omifP0cVa5G6/ba7aKz8u8gxjEDp2RGgaG?=
 =?us-ascii?Q?kGJSP9yAZNo1jQrnwq2Jqmr76tUuyfr7ITsuWpblgvF8/4OqcDeJvgdlYAyg?=
 =?us-ascii?Q?rJvv3YNALoV6cXIFcLLpbE9325EUD/Q9LPCjOtYFlolsR2SZQJe5H6WB/Fgc?=
 =?us-ascii?Q?ctkKHWDGFD5XDdGp3XRoteNvEfHJzDyLCzART11uWvltsQ46kj1Kml34wLwG?=
 =?us-ascii?Q?jJ0lOHo1YmAx4gK+h15mum69jdrOtO/dJKUra3uSwugKh7Km2uar1A5Nb5HH?=
 =?us-ascii?Q?QbI29KObKYuBTCZHUD2LbMhqR+Xyp6E+2K+re5t9KG9b+m9aUW3kp7yCw8Ak?=
 =?us-ascii?Q?mJvsR/ywr0NoY0fLRggHX1ASHIiUe0DaNCVqLGCxKEODbu1+5K1LFlfwadjq?=
 =?us-ascii?Q?IqH8e1xf1SMMaUWglFInrU+eZjFMJuEM4yaTAheQPZZ1MOYLBSoHnIbbGtY4?=
 =?us-ascii?Q?0G4h9v65wZ7hO3IaKT1+vFJLoOZzb/5G2m6lLU31u5lPtujcALMaofvdPaSH?=
 =?us-ascii?Q?ua3WhSYwuCA2pU4v0/oLKNoc3uS9ihPl+Jw2cVM2e6u3FP9ttR0OzVcEaHv0?=
 =?us-ascii?Q?IBBc/gVyMWYYJSEaCX9osKambOKIelDAq6S4KNDEf+5y3jeYt7+s3YeDIU8d?=
 =?us-ascii?Q?zzc/yYNEqwEpHAEU66PiwJML/vGhnNIriUxX153tHinmd6tCjT10dXxLZcIl?=
 =?us-ascii?Q?lg5J++ZTJMWda5RNdhnMwWSBm6r7sX5WTsvvZbY/vy48xUJoqkVz7Jmxis3F?=
 =?us-ascii?Q?ijwesgu2IJfZ6JzT4RV+T2fQ9C44A5g+GdPh1HYTrIHJJCVZqIRBVaj3F8Kg?=
 =?us-ascii?Q?aHSApMm+8rMGw0brf1huNqRRc60laHu4MNMs3lMWCLIfcp9cbRHz+REK0+R9?=
 =?us-ascii?Q?Y3YRylPI7aBuYPL1PpaU5O5kpY4V2DE55gkhzmrY63yqdJs6C+zGRtNVc5Qe?=
 =?us-ascii?Q?KSUWmT/YYjVYrqBkq7Enit4h+IslGXvNmtODIocx6V+l4GQAt3nF0LXhKV6H?=
 =?us-ascii?Q?e3XSA91QCypNdfwHMtZ3b2net8UIa7LNsy2Njv5xIipDI24/KIm2Ih8pzp0q?=
 =?us-ascii?Q?ptUKcw7mqgvjXZNKsErDGaJJlKD8U/36ot1QxWJ/0N3vFsWeVZ8uGCBxb4md?=
 =?us-ascii?Q?Yo2hjQU8ySSlrAVBAOxdFvDPAi0Fw1EdtwlqJtcz3XeZrfZL5+V2cwXlbgUE?=
 =?us-ascii?Q?ydebGxXm/baW4Z/y1YUttxNUgFyroFqQ3iRc9X1MnTPPEDmjkG+gl0jxM/oW?=
 =?us-ascii?Q?aaAK2axnRS/OyilSbtgEvgBRkKejIK9wNsYgOfX+WnU6Eo23bzy38vslG62G?=
 =?us-ascii?Q?dcGsWNJw5FYTnQjYCKiVZ6u7pXGdL+tJ/qkXhgrG1Y+bePYT2GOZZ0DOJA8/?=
 =?us-ascii?Q?pUDO879d/ukPBgMicdfeqLX4RG7wB7AfEpkj+I4VyUJU1t1I/SGhP9wKH0/i?=
 =?us-ascii?Q?tv2b4gtTapYe53Nl6wUXLYsHdQcMWTQgI05HBQqAYLXo0HrswFm1IhNhnwfr?=
 =?us-ascii?Q?Qr6tGuF8fVG/WQtmiya7+HHMWYAY9HbPapy32q3CgyYG5g5SijYj9m+Ru7Iy?=
 =?us-ascii?Q?4nvunChizrs23yp9xBKXOAlM/XeniapRkmKz9UAOEMhYzRt9hP4uUvuA4dGO?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bhK+65ThfH5Vqnim8LWAtyQPewaxpgTGjttiVgd6bQd85ArMxAvn0iyI4n7mHOnMrtGnu7QoDUd3KXY7eB1kImeWX4Ie6yhVmqo23fumikmEvCYp5vfhdvKUHEyhTX2JOUONDPuSXD1QUklnMdXOPHWuD13Rscvyp5sZFyEXldWkAMSpJKXvYnjkavEjhSYmXpJ2c7H7UMLIpM/C62Q6lAj0kYFJDEIYokj56WBSCCZpQe16Qj8795KrA/wjV4AYtiLjeiJPOGR2T9tbjcOTP6LgJGQbknjNxUb5WVCSUbetr74Um3xZ6uHWCY/FLTAedRYWz/6hHjZBvFkCPXo8eRVr2OupSXpnTSvatucuK31kj5s3UGZfJUyndN8Fa0aBD7YnR4yIt1tUwhccHfhN4ddciL55+JHCNi8ytCG6wELmwvbGEbScRmAef7nOSfYgdBb75i+G3c6u+9Hm0cGloIApcZooHPqntQngTesKgfTdI2Lbf6I1X/VIEugzKlwZ4UwvdHYQDhbeH0bbMew1Wfd2brYqkrrenb4XexfWHmyLAQ5t+OEaP/WHjMgiDk97ttxeT4Kv9Ns6lICS8nPO3lgi/hT+TsVss3ur09un+ME=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55adce44-63cc-413a-17f4-08de080770f6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:15:19.8913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EOfEPhkUugvsj3ihRogpdVlN63ooyQPt71w2HLZePhYjrB3T4njg9NFHAHAPagGGSOEaI998qFebvoEgWU1lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510100082
X-Proofpoint-ORIG-GUID: ZF7BqzQmySXnMj_anspN5Cax-nuji742
X-Authority-Analysis: v=2.4 cv=bK4b4f+Z c=1 sm=1 tr=0 ts=68e914fc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=Qo1nWHBUvXFxagpMxwIA:9 cc=ntf awl=host:12092
X-Proofpoint-GUID: ZF7BqzQmySXnMj_anspN5Cax-nuji742
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXxymir26skrRS
 uOeN0fQXXiGdGFZrO8AVaYmYSyk7FwBm+QrR+o4hEawmPF76Vi0s8YaoQ0dlVGaFSfZ5fHDZ0YQ
 2e2WEHMB/zC3TYZMf+d0Kuv+ruR55FFAGyOpq23Qzk0hVdEB0ltSYfYh8/kHkJEDbjS6a1LHhCF
 fATKdv92bltJT/TsnbTZrh/KYwTuO99IK7qSE0dJbH0cDGI+vrfeMyfEE267La1M/s2NfWCpfTh
 6gPa/B0lf/a7yWVcwifDkbuDkfqJY2n8zMyUCobj+5wa2N5rmFXf8MfPGGXo0LoQ40Eb3QWxatL
 eeegNe4RcgyHk6Cp9ckDG5oEUZw5g/Jxyt1cQq/SlHEdshViFZinLQmp2d67F9+bDqEgX8mNxd2
 pNB/RGzgo9oWQ0yPKW12Qvubblq7QjAz+uJBwK24NeSjHr/Wadg=

This is a reposting of Mike's atomic writes support for the SCSI target.

Again, we are now only supporting target_core_iblock. It's implemented
similar to UNMAP where we do not do any emulation and instead pass the
operation to the block layer.

Changes since v1:
- Don't make atomic alignment configurable
- Drop atomic_supported configfs entry
- reformatting
- fix lba size in sbc_check_atomic()
- fix return code from sbc_check_atomic()

Mike Christie (7):
  scsi: target: Rename target_configure_unmap_from_queue
  scsi: target: Add atomic se_device fields
  scsi: target: Add helper to setup atomic values from block_device
  scsi: target: Add WRITE_ATOMIC_16 handler
  scsi: target: Report atomic values in INQUIRY
  scsi: target: Add WRITE_ATOMIC_16 support to RSOC
  scsi: target: Add atomic support to target_core_iblock

 drivers/target/target_core_configfs.c | 15 ++++++++
 drivers/target/target_core_device.c   | 23 +++++++++++--
 drivers/target/target_core_file.c     |  4 +--
 drivers/target/target_core_iblock.c   |  9 +++--
 drivers/target/target_core_sbc.c      | 49 +++++++++++++++++++++++++++
 drivers/target/target_core_spc.c      | 49 +++++++++++++++++++++++----
 include/target/target_core_backend.h  |  6 ++--
 include/target/target_core_base.h     |  6 ++++
 8 files changed, 146 insertions(+), 15 deletions(-)

-- 
2.43.5

