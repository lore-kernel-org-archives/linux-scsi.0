Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F7916FF3D;
	Sat, 22 Jun 2024 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719074146; cv=fail; b=UIQm7I4gPXCNxtL9ZAAjzTvKZDk41pUKsRi4ddXzyIu50Y057u1o0YtqTFTDTtXY5umTAX40Icmtf059m/9uXmnOcmwC9QeVtcP2AD2rUBDktaGfv3h74RdDLOdDpvX/cPVolpaKBFiAGqTwQRw+krHsYPAmQPITpTwwz/tCURw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719074146; c=relaxed/simple;
	bh=2rerH+an8kxZJJtq2yCDd7gVukWt/o6IxD33KNnskJY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rA418q5IL9Ew7qlMdHOceAkloX3ONi9CuoJtpWUxvJn6wEw2Um8uVXC7n0YjZRAOLblkSSaeBJh33NWYn+9IjMMM547B5X8lu2tWKcvFYIQLZdpu/kzYW2Q2lfbByh9d1b8vDkao9YEcJRXD4LLPXW1RtvhTapiyJLWHWo6aJ9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SGiJGC1W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hrN8LNR0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SGiJGC1W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hrN8LNR0"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45MAgXOI021405;
	Sat, 22 Jun 2024 16:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=ZjTP0OnrN3mWik
	vxNp8v/5+f2lm/rH+76MHRGOE4mi4=; b=SGiJGC1WEleBXFDdkz9rWojbEtYVbs
	64uOtJVuhaLsD/5lj+X4bpiZxazPvnNre1s4HSiwjUyrS9FYKfhMwbvxBDfSGMKb
	9k5mqL/7CK1Iru+YrZqZ7a5qbNXV5oSz/f7JgJW6m87VxGo2RGa5zFwCxHMBG0d9
	Sx5Rg/j0dVasq1q+cS7WiNMRd30vJA3CO3Mp0K9/UkRhKEzqF8U1dPgcDCdqCCVg
	m4U3dnB2MOZcho7NTFTX8vLGF6AV/gtbmIAq/CJ/H4HvWlnuTFaOZy7YZHBRlRBu
	FVfPZCXGtH3/SUOTpIsVZ8N0kPNDadHgIvI+nn7yf8q1AcvnCcwCjDTg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywn700grg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Jun 2024 16:35:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45MFjkLO001507;
	Sat, 22 Jun 2024 16:35:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2565rh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Jun 2024 16:35:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXRVTAdXNEqusaspryWVKWjnat/DmdnJQYB342fn45/aSOLiS06IS2OEm1DArGQJ6Km06Kuemznw7DPnMknz/Uoi2NlwoV2Ez8Cj/HN7Fvsb4ppT2JulRsd2gkV/C/imSkA5XBXgUuhSubiQU8pv2Kl1ITULPRes/vv7zb42nNGBtOBtH4HIxZecY7bEDnWDNE8jTs2WnRKpEJV+JM0n9HAPO62A7no7zD1nItHl+0/64Wh6sp9pLE29xlpbGwVxUQtamPg8ICwEz+RCNi61YnK3nE5bV1hiJ0IxTC87IoKkBjINSjKN7NaU5UNhLHE72F9jKkhK6+/yRtEJ7ubR9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjTP0OnrN3mWikvxNp8v/5+f2lm/rH+76MHRGOE4mi4=;
 b=IgtWQZzVBTGyzUXHUqcvLKSnsavAJH1iwGv/YsMbmvvWpTk8691QzuRzzNKG1/Sco90DqVXG3uuQLDH3YYmYua2gLbD24oFK514JR9kYCc+AKpiCsUJShof11ZGTxE64qo5c0QOawyJzcmIkyzo3VGmUp3TmIWu3AXzqy9X7pB0DS0W2YU3Wj25fKqyR1v1smJbW9gXUv9MLQicDBrZ4iU6M7+IhD1JlLVCP1JRlRnov6YaedyLZWSmUPGi55N0azxmag0T9WKtLLiqt60JK7lvPifZR6FftXm+tsNG2ZTV11SaTgr8HxDiyRBaWxh6sV+0rEuxCcTuts8su659FvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjTP0OnrN3mWikvxNp8v/5+f2lm/rH+76MHRGOE4mi4=;
 b=hrN8LNR0b1MYG+QTJ7Erdx3yAU6KOucthD9nWc42l7a92jrs6bwYAXXS+960+Elx4eNatpwDoQEr7fSF4ObdzSh4WicT4KQHjRcM4dnp0XOJb27YIAPFm8BGSZorarzZjtFO7ZHRrCAXm7AwoyXC68I26EtQyoOk1vXRRKxKXyM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB6589.namprd10.prod.outlook.com (2603:10b6:806:2bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.24; Sat, 22 Jun
 2024 16:35:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7698.024; Sat, 22 Jun 2024
 16:35:34 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley
 <James.Bottomley@hansenpartnership.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bart Van Assche
 <bvanassche@acm.org>
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc4
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAHk-=wgLGuYSgbS90MMudryOOjuWYeXaXGeGJRg9SVy1GmLKcQ@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 21 Jun 2024 18:56:45 -0700")
Organization: Oracle Corporation
Message-ID: <yq1zfrdn0ye.fsf@ca-mkp.ca.oracle.com>
References: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
	<CAHk-=whEQRH6eS=_JwanytAKERuWO1JQdzRb4YiLK4omzL2J-Q@mail.gmail.com>
	<yq15xu1oo3e.fsf@ca-mkp.ca.oracle.com>
	<CAHk-=wgLGuYSgbS90MMudryOOjuWYeXaXGeGJRg9SVy1GmLKcQ@mail.gmail.com>
Date: Sat, 22 Jun 2024 12:35:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:208:a8::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB6589:EE_
X-MS-Office365-Filtering-Correlation-Id: df534f34-596f-4520-d0fb-08dc92d956f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?KnfpuUvkO1VDOrjOJbedOU8EzKsxu+KhnFfW9zXXyvLX3/BdHDqK80TfreAc?=
 =?us-ascii?Q?P/QZZ/j0S5Is0kAZMAE+H+3HEiZxXTZ6enlfHlXduwanUatQ6vLMRe5b4WJY?=
 =?us-ascii?Q?ltUsbBzSKBMMEhUBXZZLmQCRlViQk2eilaYrU3bybECFGDHgEAp6vpsXipg7?=
 =?us-ascii?Q?+XMqKFMXl0fMYsRa8eNQNwqWv/hdbCKTtJFfLusplxzw0M7hmkb9FgcSamf7?=
 =?us-ascii?Q?FwklGP5Xd8X0XnL+IecoR/8HWD6sNl6QMonRcSPNKu5gptdoRX1WUN2pBaUG?=
 =?us-ascii?Q?E9y/qwhvGqxG8lIbdlnKvveiXa3fTtVgoy0lLIcn6JJDyLrWscCF0qLgDEvi?=
 =?us-ascii?Q?Xcr4MqvJ6s9HY4uA6oRpUL9QJ9p7c2YP60mERjFZD86NUT2OEqsaRWv2Bfl6?=
 =?us-ascii?Q?6suGcztQWDukR+5A4liGC+wTaHUGlw6xVIyk07G4tDE/09boA29dX8nOIH2c?=
 =?us-ascii?Q?TcQ7LXv6y6CW94uiFTlgVTI5hpJisWYVJF8W+JqCmCEbX1JgFxEEk9FMVSON?=
 =?us-ascii?Q?E0n8hsb3SKx8pJlDFqJGhUw2mIdoznVC29pdF6TFj0swxIqlplNfMurn63KV?=
 =?us-ascii?Q?d40VwoVsut5AR/V9KbsENB/yj0DmU02jCeXCjOOX9WQE+kkpjgUxDClQZxsF?=
 =?us-ascii?Q?f2DioQ1bIWTCGe7DA/svXRJa1owyDtEDMxnocyyFQkVeCz9yOECYEcM5xAEt?=
 =?us-ascii?Q?LAV129/BVVWvCD6YGw8YZMpMaErVAAYRUyQsqWpUZsKGh1F/LDh6ZtQQuyx6?=
 =?us-ascii?Q?TyyMjigpaQh2BmA2Qk54XzgvDhNEuulK63KPZ5TH5l9M0PTm8FAWcBdcsMQ/?=
 =?us-ascii?Q?vzZWMyAellAQXw3FGHMNXFsgAQBr2YoJ0Tq3he7vaxMAAZDZkcdJM8Nz1mFw?=
 =?us-ascii?Q?YXCM+kvlMOsYyoaHBts6OMvEmhn8jeaw2f22JUrek7DV0YmP2J5JfPHatrgS?=
 =?us-ascii?Q?/qCNvQ6I3oOk4guV1l+5ejsbPWK48k+PRyl1lwtLqFNeyj7OrGJcrUYrEx/A?=
 =?us-ascii?Q?u7LSRQpi1RXKSSyTArWWNbKwm7dCcwEeSWn/K91VgpMjtfC2Hv3JHAuWr8JV?=
 =?us-ascii?Q?URp1PUAHpzwXGNpYGq4x38Sxlcn18O95TjePH5hE+EoajjcYAwSwsn8TCLqy?=
 =?us-ascii?Q?DAZSNa8yz7ko+hX3rtqTf4fdVo4mETE2yF5u41eDWlUXZaaemVBqXIBfkK2f?=
 =?us-ascii?Q?uX2jv+Iv1kecwwGPBAETDtp+sQRKOCyiZTRxqYV5IaBbQzrY8DpG4X/x8r9/?=
 =?us-ascii?Q?q5852AmrJ2J42AEeiWWYeuC855FQQtbL9RW9XYWqNb39tsNfiPuZWby7bBNi?=
 =?us-ascii?Q?adISkr2MAPmz/eRANFtS77AW?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?qGxgfFRhCaJ1ltyWaA/aFPS0goWE127uHFHwdl3ZOYYhhL6HIpTv5bCesHqN?=
 =?us-ascii?Q?7ymv492Zjk9v+bU20KqcgCyIPbRG196pGI5vhr6tD6GU8JP536XB5IUMQD+T?=
 =?us-ascii?Q?WUv4EL6i0XaIdKAyz8L2FhSuR02w7fTuMpBMc8gPN1uxYdU76edesCEmKD9T?=
 =?us-ascii?Q?cKcujjHOwY8xQvD7Gogd+9igsFxKTUfaat2U6OzsKrEfIiUeTh9xd1YYEgkZ?=
 =?us-ascii?Q?8Z2Qun+YUcCs41neTqA7VQ+KEHt7c0GicCb/zbLjjDsHPlCmQc5urqg3Ccli?=
 =?us-ascii?Q?Eh/J3dl6eDiL46hq6wAbQTRQe0Bd5Xx3xp/jl20wj6TtltOwzIvtJrQtoGKa?=
 =?us-ascii?Q?JDWuDEipXLKjxyroBJe5fCo2X2dJdqPPUgKmwNdf0gr9gcUVuyqxpAZjGuYX?=
 =?us-ascii?Q?gNEnRonId1K7sGxYZ3xLA6fMS21Em+/o5IRn1pq5avoRHIF1781nTh7uwD3l?=
 =?us-ascii?Q?FoofDzU+uU/hZF3VHCNWIue9j+sGIt4p2JhTHaPxiDdTNcyUSA/mBdqpTGbH?=
 =?us-ascii?Q?M+DtKWIKIHl7Fy14fihY7YW6UEUSZ9pIyjYp7n3O2o3iSIxfW5UrVJbY1v3h?=
 =?us-ascii?Q?dhsaIPQQPNjk4PCCN7vwAs1o3VJGz2uHFr9Y+qyGpN/kM42WxyaX/itk2O/n?=
 =?us-ascii?Q?DpYpwLlirJpB690gHmUdSelYLKpQKW30NjCus6l07Tc1rKW8hM0mWnZb2CfH?=
 =?us-ascii?Q?ZCzM6X7FEYr4lqWqr5Jx3f/Ti/eGwjXoMQtOy56tQuUQEpqKtIEmnNtJPSr4?=
 =?us-ascii?Q?ZN7Umo7XLWyEvNmbPEXAdPd6rOuf9zdBRBzdradT+s6hTwldT85vZzgJbphH?=
 =?us-ascii?Q?wHhMC8v8YKmeBorL4KQdhsO3qwrFV7+5xo/BZ2dn7MdcRmB37pnpWuLoD88x?=
 =?us-ascii?Q?okw+j7c7mu1xanjN1F73mxgR5JuqBI1GOY8wiwQeNbJcLbqwm/iKvf5emQFW?=
 =?us-ascii?Q?C1DZggFT1x9Thky8oG8TwSjNvvoV2GgJBH/UFnuxJWl6k9BMrbeQ+rkS0bUE?=
 =?us-ascii?Q?Usj2+XzsjGk9pRbuJftQb/8Xo4BnBu0Jr+YRpuIvf/UTSdFdGfS0al08pGuk?=
 =?us-ascii?Q?JEGUJsWCAFnZ89RLPjI9yLYvpONWJX9ZNfgDxzJn0jQpwNcsyb8SN/oP5bmp?=
 =?us-ascii?Q?jXGJbuJJe9w+kYz3O3V4paG+26xYdYhzYx3YnnI/ZP5hS12WEgGqHss4mSqR?=
 =?us-ascii?Q?PjubJIW+bs4Yw4KXuD7XqOVb5+XaUXuyedwbAshJW2nruzZOMw3KFj7UrXUm?=
 =?us-ascii?Q?scNdz6B70XBvJpNfCPjlFmGyzwFTGuf9+YEHnScrgLLG/PoGP6uHUenLkFQH?=
 =?us-ascii?Q?1GM/ZboI2C9bGaANQ7dybuiorGSPULjpPMkdoX8nIWiQ06fZFx/3vPBhczTo?=
 =?us-ascii?Q?qZzmBRAnOsXi4aGQe4M/5boT5gq9MjBIobOJO330lAULzB+RS+smFCA2DP/4?=
 =?us-ascii?Q?IPlQIIHnSDxJWMnfvcvNiX2kbUyXDVU/pwjKLFh21ESBW/Lx5f0M11GgnKSU?=
 =?us-ascii?Q?SrRecAAQ+UcJcIDQrahsOKsugyV08cCSBIC5QS2UG7jeWBfB1/26ByT8umMC?=
 =?us-ascii?Q?5JyCvDDMU+JF26Un5XoeYTgqTSP+kjdlkqfEqwOK8oMcObcf54VEOttQtICv?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	W+EFAfBe7fOMbXCbKOOtPHkXckaaLddJpIT7C3+6g3g1KHWMs3ERrxVUtRfddXqHuqP2R6OzLkITsLPhOYBW7hqDNotCF9+8zZ8j3kpYX2xdcHR1vAD6uWA7i0f7qm3KJMWFCEPpd+JQmxG02D0bGOgm3LiKUZ8VQoVT3gCy4YtIurTTXveNwboBKeHh/7AiwXuFstkWxao82ys28DtryZW37hlqPBQMeDPgKmXDGjLaTASNR4xMYxvyD8kyANwNDhp1MAfVE2+XK+nX/ndVc/jIDjPF4+/cn/Md7S7hlEj0gtrGc/SqtEWI23rNrdj5IibbYTZjR/nx4jkup9erRYgZf+9LGKbmWDY4+epYlHyPJIBZQYvqDqW7g/yMMFh9kUPJ95zxnUrxQblbNcYz1PBJbz0gU2w/JG8HgRd73CpACxWh0TVq1mPOakN1tnMTiRnyYNS/VzZmd4DO0EeNTxo+5f6rerwGcIej6A00J8wzkFWL4WQ+A5YFuCBO1+UW0WyTklC1j+PT9p06p1s2pGRgCiHu5omk7RbSSKuKs+dsNbmHdlBfguHYEgaMVhJ6FGXtOsDjvAInPoRqUw/4omzNfJjY8Hm4maeujXvZjV0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df534f34-596f-4520-d0fb-08dc92d956f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2024 16:35:34.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/romdLkcR2NEhNUXL0WZ4o7E+7unVZbDgLobm1L2BYmtDb11S2TVzULJNUgBJaKtDy4ZsTFWpm+RzDulMEC0t+9WhGX0Q7pe43wX/lt91E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6589
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-22_11,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=422
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406220121
X-Proofpoint-ORIG-GUID: Aq-BJVG1b2fk2Rv7gFWT4FtrajvetVVx
X-Proofpoint-GUID: Aq-BJVG1b2fk2Rv7gFWT4FtrajvetVVx


Hi Linus!

> But I also know that pretty much *EVERY* time the SCSI layer has
> decided to start looking at some new piece of data, it turns out that
> "Oh, look, all those devices have only ever been tested with operating
> systems that did *NOT* look at that mode page or other thing, and
> surprise surprise - not being tested means that it's buggy".

We have been working towards poking the same things in the same order as
a well-known desktop operating system. Explicitly to leverage USB device
manufacturer testing.

> Put another way: why wasn't this an explicit opt-in from the get-go?

Because the expectation is that it will be widely implemented and used
on pretty much anything that speaks SCSI except USB-attached gadgets.
Hence the ask to disable it for the USB transports instead of
complicating things for every other use case.

It is always unfortunate when a change causes regressions. I agree that,
given that this involved a mode page, there should have been extra
safeguards in place. I should have caught that.

-- 
Martin K. Petersen	Oracle Linux Engineering
