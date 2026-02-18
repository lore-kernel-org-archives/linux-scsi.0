Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB5C1E1DE9;
	Wed, 18 Feb 2026 02:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771382196; cv=fail; b=ESfRi6rvFj94hxE11J5p/FU0I2xsx8Y9auF4d9+8G1n7jtzs2R9OMyCeT++XNFRcEFuyMqpPvz9Usv7I1tNDwS5mUPZydRp9E3/W7StaL/sXa5P6QlrmT+OufooDsx4wt0frY7qEbDmpUv7oJKOvakQibla7NKkybXVuj4Mt+2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771382196; c=relaxed/simple;
	bh=XfkH4WC4FM/QEfqD0Q1OSk4MsKLgvteP4wRYGCzWOnk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uwn8aZZGWMxdRZoY4zruafOWCe3hlM09VPhJcyYKsjlx9JRed6HSIxGyrZG5Qc456HIUvuIEBZ9JIYz58wuYO7lknaQpHybKPO+3g9VnlLmdF6piAKco1q1OENLcZgNAYRZeXYfvoRqulpkx5UTEBuPHx9L9JdjqGiLFWfE4i7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VRbpmvHD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BTjT9nSp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VRbpmvHD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BTjT9nSp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNTcT1535500;
	Wed, 18 Feb 2026 02:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WH6c8m96yyGRGOMHVz
	tBu6zGWnfTFbO4cBhCQDGXA3A=; b=VRbpmvHDK4XY20oUFodAPbxFl68JerP+3I
	9fjI0jpklHF1my0k4PwP9OD7RQN9Sk0lYl/14HQx+cUSL0yTpr3LCC1D+Fj8i6p7
	ErYZ44QZ5t7grnAIkpNxlP/wrIvpY6kaHIKXeCoEEE2z1t5zboLEec67JKOb8xCo
	NBq77eIlwN1J2E6K8eWOXGGYDNqZv2pTVOx9tjLEs+Z1V636X+YJ4+zDVC4qmIfc
	Chr2NjgwGdr77N1QVLKfGMn3ZijXVxhuQvga43ySVV66nh4mwygcfGc4P1rP3XBF
	D3IehMj4Dn8l6TJlHlLXFR38K+pKOV47HPpr7HRHaOC42+6GRfkw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj3t4t4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:36:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I217BP009941;
	Wed, 18 Feb 2026 02:36:28 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb29h462-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:36:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mVf7+qv7nEnIHx1GguW9cKQC5TYlI5L1SuHVh/glq6+iOCwbHMmxtV4wKAeq7VXDvhgkM/H+uxJe5HZdq/mNkrFo31lGsNxgHovGt8jLbnZ8YAp/tOfbh5mEWh2Jb/8rRrH/zVHM8LAyeRek8XLrsXko1n8LYFxXnAv0eA5ZJxp8YZEfdawhMbjzfbvO5I89gyIEOrY4f10qcTmJdjs2neNb9nRbf6/WvyUrBToS8zck1d+iDZBghVsIYg/5ffmV/mWTEJxnWMYLVp2Ls4zZ6/Y9JlO1+oDnNxt/+irj8ycBbBuAO5x3QxBZ9rS6s3VqawBCMGpkBEAgONZ9868+Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WH6c8m96yyGRGOMHVztBu6zGWnfTFbO4cBhCQDGXA3A=;
 b=UQdwFjUsKo1uXLSXaS2FzRVF86JkBYvXPSSKBrhRn06vTeHa9QguJI7PW+MedHTNtvSQ5++KUDICzKb14rEvT0cT82Q/aUTwGwlTPLCES4gVlHfGAUf9VcS8A44A2HaSd5aAH0GiZEfK6e6ifROc33+hL26gpRnWE+Rgeu+VWvJJ6IjiMalCvSrWu9glD1r0yZEz0llRI3ISwQ8OcPta7h1XOy8HGUHrHRXvj9XlcltR9jMxYkqsoaC6kHNg/lf18qKo93clNp9NNXAMAkjrKpebJgjz3S6sC+uAIwI19VfZqvSUsPFD/pB3aw0+y8XH6c/j4SJQ46rPp/9sERMEFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WH6c8m96yyGRGOMHVztBu6zGWnfTFbO4cBhCQDGXA3A=;
 b=BTjT9nSpEOIq/nhW8Y6dNomAOJJetOr5Shyy2KU/qRqmRvvnEHTsO2dJPW7oqYi7j2SIGfZPumDyAJcrYgV2KgMOP3ZJcAsoWNHOr9JFwm43ghwOHqguUy22WlupXrZr+Mvh/nBl1pQh5tERrHowARJXYk8ksKDbT6dB/nXsmeI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN6PR10MB7492.namprd10.prod.outlook.com (2603:10b6:208:471::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 02:36:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:36:25 +0000
To: Salomon Dushimirimana <salomondush@google.com>
Cc: James.Bottomley@HansenPartnership.com, damien.lemoal@opensource.wdc.com,
        dlemoal@kernel.org, jinpu.wang@cloud.ionos.com,
        john.g.garry@oracle.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v3] scsi: pm8001: Fix use-after-free in
 pm8001_queue_command()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260213192806.439432-1-salomondush@google.com> (Salomon
	Dushimirimana's message of "Fri, 13 Feb 2026 19:28:06 +0000")
Organization: Oracle Corporation
Message-ID: <yq14ineeq25.fsf@ca-mkp.ca.oracle.com>
References: <20260213192214.437871-1-salomondush@google.com>
	<20260213192806.439432-1-salomondush@google.com>
Date: Tue, 17 Feb 2026 21:36:24 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0102.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN6PR10MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: 28681854-a29b-457f-76b7-08de6e968321
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8G2ZWQyzd98TwUjwjTpOLM+azGk1bQHS9oTLpZshvOg+Iql3SEIXHOkyrTrE?=
 =?us-ascii?Q?oRVeO8yK8neCOGwljJM5kK2770Vy489w2lVcfYeo71dKLODyMWzw3W8M4b+/?=
 =?us-ascii?Q?P+wv4AZj9X69+oSYcbZK3/3dhs6uCB4MV10m7IY9av1bn91i/sPB39KSZ42R?=
 =?us-ascii?Q?rAd4kPK+iTdw5XSxOlfY//f45fANf3yE1T7yc9wpyJl2RijeBARIdJEDIsvC?=
 =?us-ascii?Q?VTxNz6xnZvNUcwIMfmEj5FYHxXshCpqyROtpTzqMUN6jArXvn6ugGWo+zBzo?=
 =?us-ascii?Q?4KO+iSS6C1VNgApnVnE5hQAL3Pn933juZWjLn+HR/kGiRUa6qU56vBI+Jh3e?=
 =?us-ascii?Q?jj2uPP0WNh/fgmoLfZr22Oi5yIo8lYXGN92btvDmiTCBlsPHCByjJiCzkgge?=
 =?us-ascii?Q?EeMf6DGoygZpHKpYzjsSxP2CwiXdSpknhw67knHtoVOvcvQ4qwpx+Xjvae6k?=
 =?us-ascii?Q?vftfxRfWR6HwgbGH2NqlU/nWVNx1NhhuA4f7p3nXwvjUz+FgMbwFnYFp0xnj?=
 =?us-ascii?Q?wChPYxO9U23mNInby8FDMVlDp2gdgCXIddRDgU9RMM8EpRO18dbWEN/FJbbJ?=
 =?us-ascii?Q?BaBlLgR37tFUB6UlhMyNDcXwmorFAzhP4MImkZKbwM8WOonmdvNuEtg+aZ3t?=
 =?us-ascii?Q?E8YMoXiu/ouBtO6Ns6s81W787LwAmbqqWui5NqLjyinPAAxLQFjzft8buLwX?=
 =?us-ascii?Q?Ze2eANfCrOiLI1dCWyUg7XnKdM2362lXPUFWbeN1il6s1+x7KSPe5EN26EM4?=
 =?us-ascii?Q?uUUXkPkkCl8siW36GqNxsFFff2IH4VZs5RsdDPbZ/yDW9LZ6AUiZkX6QaqIH?=
 =?us-ascii?Q?jVmXN2hCSVk81w2W5mx1EAQV8PWt/1Jnd/Kac04DyiWP6tcn3tcxGaOKwwBY?=
 =?us-ascii?Q?xw+IxGr+DOg59V6s35ubYF5JR/JrDqvHUEyodMQ6AqmQHDiqU3N4knyY39nL?=
 =?us-ascii?Q?Oj2Bw8YDSRUOlABC4gdMOeDPAkUG3Y1yGwh9xpMJ5BMjqdimEMc0jbkzwBN9?=
 =?us-ascii?Q?l8kaXG6Q63FzEI33Ty6om9OdlJmdSFjXzxAWh4lRo+i5I76NyLmDCgNZgBx6?=
 =?us-ascii?Q?ACZvA07+oCeJET6zXZKd0Zi0zpJsDfTLpkVe47vuO/BS9ydKYiMrGM+7DbwH?=
 =?us-ascii?Q?hY05y7fjEQNEnQ5o4pLsyR9WX73m7ivqBALumiBSMYXdPm7ntt+S9Kn0B+4d?=
 =?us-ascii?Q?ZyM+2/pl3sJesCnMDZ6WlvbKTv3DRIJ2e87Q6AzvJhkWsnJbbH5VIY7vyPL1?=
 =?us-ascii?Q?RAiICTjyzukIQ9P3opAQRjMjwobA6kTV/kk5fxntQLdD1NRVd/V0wSqoJN39?=
 =?us-ascii?Q?9d8md2Y8YCRRDuukhYowXCETdLUVpGbvUpXg+c51jcvvnBvk2IwCG80hlblK?=
 =?us-ascii?Q?VhP6+2BcOMO5lrvnA75xYMFkcTp2TaWXU7wRFySOA/SUMSUv/uvPkiQW50WZ?=
 =?us-ascii?Q?ar5XMA8zxoIrRTTnDW/LGHMxfRvnLoDc9qJAN8Iw1XJQznZ1mRPxexITlHR8?=
 =?us-ascii?Q?m0Li0s3Uz4+me7DhC0VdV+cvfliZJrjBEpkWdBoJushJilCGeNbZXDjBpvh1?=
 =?us-ascii?Q?1MQlF/UwAQvz1iHRprI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?52CDhnesQDshG+uzI5HxLPCVu8xvrxscIc/P9tfh71Bu6oOZH9thEOOgzZkg?=
 =?us-ascii?Q?QV3gzqfuQXbW4HYtMhGc/ik7pcd/ixUAlAOz2zFTk/zkWtPvJBBuUuOSNRnE?=
 =?us-ascii?Q?VAKeFrK5QQ96terJxy/JUIEfHgfOTXDlE+rBIJ6s2BWa5NemcqBpcvWfltBk?=
 =?us-ascii?Q?hSdwAd9Z4hu+f0a3WuM3MMs+g+MJmzEiBG2gtg0VEwE6bcQhjvir0+yG8RqC?=
 =?us-ascii?Q?a3NrPS1r7+2mw5hMyWwYiU4Uurd1DFr3GhN915Y4t1LQVwS24QQPz9N1Mey7?=
 =?us-ascii?Q?Z20B9kZMlGPXpqcxpWiWmpRb+wHldPqwLzna6TjizibqlNUJBAy9zGWckheu?=
 =?us-ascii?Q?R/3bCaKrmymQmdp7zfaizBmCM7BSfVJMpxAe5kvt4cVZe8Je9TTlsT7z53xA?=
 =?us-ascii?Q?SnPh+t8MFugE+pXYEUSLcbA6pvfWVK17nTI1YRWwWLt+Lw6dnLEO2ZmG0JWa?=
 =?us-ascii?Q?S0lVHoThUXu05oJKwkeqw1nBP5X5EKQzaUsCoVSpQ1Am6cx8/pHq4g/UPFsi?=
 =?us-ascii?Q?jZP+49IfmjqsKKph9zpHPozh+w25T/OyCgPkhnLsEP227AR3JsNakQPE4/Ho?=
 =?us-ascii?Q?QhClSDhRKLwWgCQCRcrkEz/yxW1TusFKvRgVf1KA5TOB61Q72hbrWsbljWAE?=
 =?us-ascii?Q?hv9G7PYwApxd3Th11viafMlmYMsolwFOKapjrR+A1+OFhVdlAvUTYqHapjWw?=
 =?us-ascii?Q?nFCTjzSbs9TvdAwlqn2uDvv326dQXlaQ8MvJGSgXSHIm8SIQbbWzZYVnPqYe?=
 =?us-ascii?Q?q+w80jpTVsQG4VbhDBI1YY/dygqO13K6+CCkszhgF4dg7U+jdAFlACGJmAuG?=
 =?us-ascii?Q?STx1MHw7/v9Dg0/B9JUJIiBtTPd2TWXas+JZm3jY8rlDgLF1cq0Iw/0uigt7?=
 =?us-ascii?Q?mBtRwbNMziZ7no76Ki3gRPVOatfVqTKZkGzZzZE/gL8RSJBZ1QEOcdsYRXEj?=
 =?us-ascii?Q?mUb+MJ2OR1jJEDAdWjsR/Qj9O3qxna2oGnMIjMLqNsFOcnq5hIHva9fm7XBk?=
 =?us-ascii?Q?cHppQVgdS4EcPv9Jz1OT15ClaqxPU81KQ7+uZw9yvt7/2XkSKgyha25IgewH?=
 =?us-ascii?Q?aEwnSIMgwpFN/Er+mIId6RjE/zcbuSiDEJGn214QXNywIlXH/AWnx16Mw9kc?=
 =?us-ascii?Q?oT+yxgRpps8HcEk2r2FMu7J5vNRhWM8W6sflnK/b3brJr690jL+lpLvMDSMh?=
 =?us-ascii?Q?mV8MlicVe0x+GDZ4cN6FxomHBDlqvfWnget8nnO9IDjTM7rPIKCT0jKxdEpp?=
 =?us-ascii?Q?l/4NufPh7X/8SYbg6alstmKpZJc91kYejz3FznGUQwzDBZFGNCUS3ccJpubv?=
 =?us-ascii?Q?N51pWdiMWKJzb05vZ+UNvqFDBhInT5kAM6VrAiAjt61Dnjo8L8+YA9HCs3/o?=
 =?us-ascii?Q?lTzfmEnZz2rCF8uCf+apiJS6Tq31ASveKxpSmmpCFF+fgijjdotWVbRkBPXd?=
 =?us-ascii?Q?4tgWeyF/WryrOlGOH7OmAv0DzHajgAnUlFpy5VcjG+xhcHdK/jagE1rFCSKL?=
 =?us-ascii?Q?cqz3jxIQcyZlJUn9Kba29stsLe9XwsOADm0cdnMZhnx1WXTq11URJp6ROdsN?=
 =?us-ascii?Q?iSN7HMRzznKC6xA1hMleBamD1/kVB33iPEXeQZxNo0rz9VLMsETZg/3NJNuC?=
 =?us-ascii?Q?l13cOaUw3JDHc9H93dRjdfeFN8ZfMiqSeHr+yaFkjN8faCSt3bA7XJJcmLeh?=
 =?us-ascii?Q?dBnbcAdrdJ6O2d/elvJLQ4a1YNzxL4YL04nsQXQiVu5OCp+MP239ApI+lAWs?=
 =?us-ascii?Q?FezBb1/LiZ/U6gNHeFn1hF7tvq2NCLI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ydtqtsZtDqS7rJ4o3j8QU/VYJujHwElZTZGuvUjByL8ioL62YsUlSY3fLa+k8/fwEIjZveirI8+BJ7wdKs0OPWksiSfmzrT51HQblqWXR9HM88y8vPGdrMeUWDtR6mBgCKH+5ypOZ9d4dEURdjZp4AVOCZLlpNUEPvmZ04garNcBCy6QgPfh2ROUmosBVK2FbUKiR1437I4je00crgAy7764qsnxIjZbAM5NxCjM0ibQeBWbLuI5tTkcNHCtg1RP71Jc4Kfyx3KsPU5Wi8wkYAybzui0q3VMfqUbVIt8KxWGO7Eb6XGR3/21HzKfxRZ09EMNil9ysyuSZTuLzxV0A/7smcBMeufAMSvgt7R06cvpI38X5EmH1jNgKUtUGWlTyDEsSinBLFN7G+dixGMrzqKd1Eh7wcN7h5VvmqqhpL17j0HWFSpWo4YaWo9GOztJOvDpMcvLrkt/Qf0KxSrs3OVhmI1gNTUVLy0zR5hIxEtgv3YVCl+V1NeMuVFFXeZisWdYrNsAkJ3VOV2sDjeBnnJTKv5bLUSDTdrw5kWbmcb0CqUXLGx7QS6H2EKp9VRz/LANJuk3fgnoUflpUZGGnu6LZ5RQlu4vumHqdKiNhWg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28681854-a29b-457f-76b7-08de6e968321
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:36:25.8740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7BRjsgF3Rw29Y5+P19CzxxoieQ9YxfDE6ayg6QcqYuZZZiGsxp+PCZquP+GiAOhM9vnmZIoUYcki0FC6j472e6yTX+RUjizfg8FZ7xWCrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=806 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAyMSBTYWx0ZWRfX155/ECm1c3hM
 t2ORZeJdDQuqLNIsbrBDUeQounjY07iDDxW1n0tqSnPhR8Mak8Sq814vnwmWoRnoBs4OyzLViMb
 AtMIfP6P4PT8P7nVbJqVUGi9etrReu+36Ysg0FsBKgINNf/GIAEcSEvEWOGoqL7ruwGTx1uVkGE
 6eOkN1Bx8vIw3IyngOnhqX4ArOaHYOFizT3m8NwG5Jnijx0F0Z/jGYvd+MAMQ4DPcx3KyxDsFvx
 Ur/80Dan0BZj5Og+wAgeGhaWOYHoAPOlt4eYgKmXY5kefEnbSBGZD/tI/ikY3Me/b1N7BwI+Qba
 bWP0UfdgF+vnf35mKdaMVN+0nDrS9aIUYOeb0nOhO2gUxqSMUoIBUpa25R4wct1rmTriIJJC4eO
 LGXQZ95XoW6OOYD+6uV5SLTNDDLgChBhFcTyid8Nyo3ICGgLmr/XxcrVmdjGSu/cRh1CTTEYeaC
 RtgbtlLTW1a8Sg8vkkVBzRaxqrqPAKKSECwMIDc8=
X-Proofpoint-ORIG-GUID: 4cHIJjXWnNqvMOdC0GjOWGCysVhXqLgI
X-Authority-Analysis: v=2.4 cv=b/S/I9Gx c=1 sm=1 tr=0 ts=699525ad b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=J9_3lIIJs0hlrCRY9FoA:9 cc=ntf awl=host:13801
X-Proofpoint-GUID: 4cHIJjXWnNqvMOdC0GjOWGCysVhXqLgI


Salomon,

> Commit e29c47fe8946 ("scsi: pm8001: Simplify pm8001_task_exec()")
> refactors pm8001_queue_command(), however it introduces a potential
> cause of a double free scenario when it changes the function to return
> -ENODEV in case of phy down/device gone state.

Applied to 7.0/scsi-staging, thanks!

-- 
Martin K. Petersen
