Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928EA7083C;
	Sat,  7 Mar 2026 16:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772899565; cv=fail; b=IfyTp1nXZXaTYtAjM4/4LPrvB0ziabfOHTL11nFzUwDqj8Vnea389ns0H/iiGzvIeEWu40B8MD0y4SEYxy6u9TXqulBwxsphDTyL0WqojkvrWMhuvz6sXXMoY2dgdWD8Ak6z5Pib4P2JMSEZdcYyK/2sCOSa7O7djElfLQargNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772899565; c=relaxed/simple;
	bh=OBeyrUEUQw4MJxC9buO3S+MmI33HCMte16XC7f/6yvo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bXaB+hVpwpp6v/CilSeSIMl+ETQbTy6j/8Juk3Xtq/gbvxu6N46r/x5ZUcNm1WNksaiONxvG4eM8QnI8kUAmdC94IQxW37gP67T1/88Ny6e5OfKYiZWfvaay/4qmOnnCCWWCvx8cOiUAijdAbZ0e7D4KwReErT6CKbxCGhRw850=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XsjkxIs3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L7FIV78X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XsjkxIs3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L7FIV78X"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627FXcxg1045676;
	Sat, 7 Mar 2026 16:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=p0aJIzDPT3QG04msLj
	NOKAc9Zmz/iJ3QAR2Myrg8hPA=; b=XsjkxIs359lYw0CxWIlIEK8KR0AMkKW03P
	9v4FUpZZeAd+nq+mid7Kxnd8ct5WmPMFh4WOvOka7Hr7fuYf0GVdVxY5gTGbvr9z
	s6HK4IgwRxkjB/wB6rOaVcuprHznLLr60Aic0JR+r6FJF6pE3NFXQUvHY8mTXqT0
	N7sqhLVlWsvslUBW9OGfNz0Ok/9TNR3/n92pWvQ6alC0BaIvSBAGAl80pUbyCX1c
	qLjXPdqP7fTW24ZaaZnhMyJpue9N8jeSPs3AKy+6kbcmVEIAJsWe7MJCwi3kqHH0
	0KwyHz1QYDP5CDN+uSJ9ZqoC4p0F8BcM9fWEi1F5W9hcFEVLfP8w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crprhg0b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:05:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627C0WNu020420;
	Sat, 7 Mar 2026 16:05:48 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011015.outbound.protection.outlook.com [52.101.57.15])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafb6m5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kOfTJWLcCzFvijS9V8NYBT7FDNPTj7g8j2yyA7bG3UPjLIs75b4LiYh8yuXYMNyouQvIwEk6PIhokXaWQ8nsOeTIDct49ZC0htxA1I/qTXoXvCtGumAM9mk8fujuvapYJ34sHFf+rALGVaccPHbhoBwYBSWHW0FY7LNhAtrsn6BDOSZaUzHkZodfucT29HLBBdd9RS6I7dOdn2l1qQgtlZYHAAtqAjtMpHUmNnBM5u8jG8iKPJ4ygRR/pLUQC2L6amQB3s0zP5hk3NMXp0D/WTWwJzifnHT4ntSvPZYUOJxwDFgId82g1T5K/8vDA8PZbJOEJI1wVI+AdYLBQnp9YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0aJIzDPT3QG04msLjNOKAc9Zmz/iJ3QAR2Myrg8hPA=;
 b=x9d5CT/tdEl+qq85ihQOGns5PuEXTOy/nz02f1WLG9096Opa57gDqeAdp6fNW/+HSixQLtXbtvK3eNxwufb+AbdQjhqgZpypO1o+MY7AsIGs0T8Ozez4/MdKFktmb9D93SDpMVgKcHKMKtfPkPgquXVEWDg564SoQ3DaSM9hgEvvx6H9kQelU6q2+R8OWm8EJYgB0rlJZ59J2PFd7frSKhkBf2WhaM3PNPOUho/D1fNnOwF+Ak8UccnOTbJxQPXHiMchEpQYLx0r/eTFkTSkHxct0gDxeGhffymy2c07JU+8wM3qEl5HYGuFC9l4KYIngmZlKLE7JiJ0x6qXgHkd9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0aJIzDPT3QG04msLjNOKAc9Zmz/iJ3QAR2Myrg8hPA=;
 b=L7FIV78Xxb/T0x2Y1dxb5OFYaspB2zv3OyXHdyJEnZtGScxY8iovb6JLLH12ZR36qFymZcdFnCX0yGWrfTw8A5M17QlHx4fi43Cjp/lkaxWGO+GqXhhpup1JKeb8PRm1zZvXTnSry91YgTbyDImgDE94p69nJGOvdVIb9yWhd/4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB7046.namprd10.prod.outlook.com (2603:10b6:806:346::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.20; Sat, 7 Mar
 2026 16:05:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 16:05:45 +0000
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>, Huan Tang <tanghuan@vivo.com>,
        Lu Hongfei
 <luhongfei@vivo.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Yangtao Li <frank.li@vivo.com>,
        Keoseong Park
 <keosung.park@samsung.com>,
        Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
        Liu Song <liu.song13@zte.com.cn>,
        Ram Kumar Dwivedi
 <ram.dwivedi@oss.qualcomm.com>,
        Daniel Lee <chullee@google.com>, Bean
 Huo <huobean@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: Add support to notify userspace
 of UniPro QoS events
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260305110856.959211-2-can.guo@oss.qualcomm.com> (Can Guo's
	message of "Thu, 5 Mar 2026 03:08:56 -0800")
Organization: Oracle Corporation
Message-ID: <yq1qzpvwroz.fsf@ca-mkp.ca.oracle.com>
References: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
	<20260305110856.959211-2-can.guo@oss.qualcomm.com>
Date: Sat, 07 Mar 2026 11:05:43 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB7046:EE_
X-MS-Office365-Filtering-Correlation-Id: d7333d79-b137-4491-dc7c-08de7c63639b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	8Vbz9futra4hLGVkIqmHIDCRqXxJz5eN7DSlXfmhSOpm2rY7cwTvhghmOl1LiIZ15orwRvhYAJHNqJlYPSm7CvpdrHKQMRL8eIUIIdhTsaHRWUihoGFFTUTFnFioAjbN2MC/sltn2jpkKsi1B6yw4eu2xeziBbsyjEv0vDoM3SO8s7blQGBVb/QbAFoTAg9xWmCohroZfWxKsXOMhmZvLVL7pdQqjf3i1c4SGxjOVs28nQd0/FzNA1y5ZzZUHxnIqwCyBwTELcPGXvQ1mqu+ncqakVSxoItYfPQU52HumuNgThFtFcEK7L0yd7+PrGoEwk2GFB/pQ4n5MG9tIlJWOsVhozpTybjbUCqCZY7RuKzpNYiAMRKwdFsipc1mHUx5FggsiUFh2M9Y0eR+h7NXkU4lww9JAC67VtvoiT0arVNsuVUsLBjGa6wHOq9vNzYIXHiO3kh722zIdpJIYqnHzNsb5DtnJ7qcdAjpm0zqqA9YzmIwbIPDcbeAkJIxEmd7TU9NGZLqX745YFYUhuHPd2saRvv+6Fx1PWNLvuEoa4nVIWj/WBjzLVenQCD2HQUrV48VlaAWIsmB9/0DxjJiFlfCefZG6z5ZT3jCSn9N/F7zKPyFy+C6A0kpe7jK4RDY3RM9t2tShOudSsWXaslEGSSN63Spn9f07IGM7Nn8SoCXGdMxoai+k/oWtadULKCv+S6ATqkZtWm8wj7Rdz3Lv17zsnWcufNxhUOGxu/NqfQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sGjJfvL4+Q1SsL3c7GsoV3glQf+I4TlVhPxZ0IdijXfmTtqYrTiibg40RDsh?=
 =?us-ascii?Q?X2c1zQ75/rjPcn62S5ym1V2cnuIGSocvMJAnVxaksgkx2mmIEGkfKglbeyhT?=
 =?us-ascii?Q?1vbqAXJHh64hr040mISXwwvIhn9QoMkno++PzEu7TGLnxD3K4xs1myxwM1w/?=
 =?us-ascii?Q?3b9kWgGy91GzGj4EJoELMHc4r7OTGiRYFt1KWKsRwz3gTNA0fpK66fxCAqjQ?=
 =?us-ascii?Q?0qi1EjxiDSlJ8y6gU0DH2+Gimtd00rVI6yd9m5+XhJnb8l3aMObvqQB7vmVN?=
 =?us-ascii?Q?SgkMsVJB6tH2fyqENDNPZrzuN/sK7IMhisYvrKuSAbcU6yZ/SZGhRdEBrssG?=
 =?us-ascii?Q?yfUUWDFG9cs6JeYkaBtNDCZJy1xI7CaO/dRfsA5CF8yAmteC5A3Za2HpKg7I?=
 =?us-ascii?Q?oga1Y003p2S8SUqkc4Qn/6NMeDKZVfcz1fM2dsaAhJeV79YvP+yutzzjsqMG?=
 =?us-ascii?Q?EdFoQ+ovpcQkYkYNyVbibqV/ghqTUvNH5MrvxfIuYUxyfTHXVPHvwDoXof2c?=
 =?us-ascii?Q?Ab+ghVu2R7TUyrpTO4OcMzD7I12XVjXmCmrgCpauzTy4uGXN/OGEox4AyCw7?=
 =?us-ascii?Q?ymXlo6I3bTk/5AVvGoWQsY1PPxA6KUVEqF8BZZbhHHQCaiYsIRg4tfQBQZgj?=
 =?us-ascii?Q?VE1IfvyeGPQNnABOR6p7BXtoYbjzUdjTrD0lJK3kDOFi9dmLXCZUu1uThKYT?=
 =?us-ascii?Q?y8g6hW1t2H9EfeN2C5g2XkahoS6fwuOn1UsQITzIqCHR5Yknc06OEdyPJKmw?=
 =?us-ascii?Q?ZzT8C2ROAr6YCAOj1IflseRcMx0Zj2RspKdjrs9uqDC/0FDBSlQicsh4poBR?=
 =?us-ascii?Q?QwD4u5IFnep5t949Ps4QnRbsLPtNstPUTGuDDGTQCpmSxnr4M0ztpQzGk3qX?=
 =?us-ascii?Q?KFkCm05aXzqbIrFpay8zMQJ7vYg46SV5LVZvSbAzsPZnsRRWg+fRKkQFCt9q?=
 =?us-ascii?Q?koEH3A9FuuGCgMgzDE1iW2oiJnd0Ef849Nyv5honsFJ3kAzDhIYtvot4PMBJ?=
 =?us-ascii?Q?yz081j1IpHJ6QCRx6ZlDIh+urJx0YFqhDZk8tduAGx5qtGF4c0X6mVCYNlV+?=
 =?us-ascii?Q?uqYQpGSbj2tvw0Xcs47JkQ6CaOER4TzkxqVAKutR/Psp3V6X4FbjC80QOe9R?=
 =?us-ascii?Q?Wi3g9doJ2q/HwXzrOZEIVvobfdqOSYPQCk7rpb5562EbtmjULYWtHNMt10TK?=
 =?us-ascii?Q?l40ml+9nXYant5xt1T4ZZkTaADeDg51Pz4radsCVzfvdnfwTXcc9j1bPX2jU?=
 =?us-ascii?Q?c64vMXXbsuLiORhfTI9Z1dFcgjmiiZwt52yDpmDpCXdlRAbs/xfh8DBaHhiG?=
 =?us-ascii?Q?TQQy8Xiikgw/zL5qPdDeiXD2qup1RJeIpbEJb6mcn2OfKmQ1QID0wkId/y3M?=
 =?us-ascii?Q?jNDq+K32XKG2lp9VcGzfJJEJYUbFgiH5Cy/C3AIQHbI1uzqJSMlW8SHzVOhl?=
 =?us-ascii?Q?1gzilwO9iSmYzmd3WNOkIcu4zTZMmVYmMkLb4fjccWKbtzWvkCyV7NUCPhZg?=
 =?us-ascii?Q?rvZZ5J3yfE9DRLsnETDsn/KCFrGEQ1UFI3QnsGUBA4l/+it9WrhUvHG0Dwm4?=
 =?us-ascii?Q?0zsdyntbmWJk450bIii1ZjB8Gugg24KraVnExSqSHQwJFtmKAZaJ+Bgmof5y?=
 =?us-ascii?Q?AwpSokWxeoxRst0DOMtgX9n0LM+39WvxDx+pk5VYWjR0XV0xlD75SUY6gWNE?=
 =?us-ascii?Q?tL65MQfy9PGrlx0FLgm9PlwWRzL4nc1bQIa/rKU1K64fmqvrW3pHqaV/92X8?=
 =?us-ascii?Q?6r5z4ECBazN3cC9lOF4sLg3zEHlKNgw=3D?=
X-Exchange-RoutingPolicyChecked:
	wazMJLmuGEuXJZMYs2Y0hWfnqDUGBif6RYNjSMUB7MdBEY4q+1b/8CRJ/tK4rc/BrewVzoLzejo4SYc4Ao+ReBBzFElX+1zukJ5Ja3DqZbN9eeofhp6/VlR28HfDpsrFI4zSTAVXAJSH53pTmvadp58dHTkWE9cZpTstQ5ynHFR9LggK3wQNXBW1Hs+3a11Sfb1WT4pz4oHyfjpcXClm8g+ssTDNvQsphMLruru/5k20P/o4eqedLPAij2uzTZCU1FfFJsqsdEc+jFk5a9qiT1/PsbKIrUt3mvw5brvEqF35oEscf4SQB3eG5gPqrCW0cJlt8sANkaHy7H4Hu7QS/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U0IDO51gUz77rntP+WXS/+GXVeoZ/FNMYUcz54j6Gt/R9LS1n9gWRl0pkxES1wLUTjh8AjR6CZgCN6Uv4a2Rm8PvptVCm0eddXIE684CRnKIPwiMkjR29kuR0u8SmkALDC2x2sHlw/zX8TuS3qROGH80GwywnDSMQPH71JxzxMMjpcWkDK3G58WxdAgLs1QTVIUNiTNJRVXY2QthCjdilRQiMRqG0FpMHmtfVPrmBkjq2gfgnH4bMgmoB4ayJ1QmvzeWXmTuQTYf+2L5fUNMzM5tNXhUS7MSZAaSLhSeYylTUhtn8JMQYoA1/VkcQ3wUSZrU/gEkQSEah1cwWgVV7SR16agnba6gnq3Fc7pP+ZIVEY0kRZtwZZn4/IaQrI1eJ5M3fXSchg6aydyUwXPMhcbXb28H6sEWY8y753KcboQEhpzijwRMbrogjTTAMlKt18Yy9YD23sSeCLF8eC8wG7pf9AI3bREVFlBiKLPAb5292k5d21NkNK6yZGjzx65k02aJkR8gqNz3/OXxHeWO71hMmNwcZTTz+nHfSxhmqkMW9PExRd7+g19/tF9qVoViDqi7oU94fo4qQK9Lk2gLLoU8h+QcfZTGGJcCg1NAqBU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7333d79-b137-4491-dc7c-08de7c63639b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 16:05:44.9097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1GzYNC5QZqEUg1gezoXGXln6WhM/ZDnKwrOZesLoYmqbwCFok69+kirM7VT7iejd6GeAhiWsUPGlxaHZ27mznVdaWu3/xzlA5OpBWnxmj/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7046
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE1MiBTYWx0ZWRfX195WdF7jWuW4
 MedqEJwrdR77u3JjEP7ya9gRcBPme6G0U5zN/pwo/3jIn9X4VTxbCUEF9o46+gDIQWUP/zFHQPJ
 dMt3dVa926PdFUo2AGDXUqDchP1r2n27bV6UFRhlcTKuXuu/56k2XcPE+bJctGml7jMMyAq0COl
 SxePgQwj2bniKCsgykq7QXIQo6ShTHWb9xkUyiQn2cRHNrH9zYOJhWTvrHF1AmlfKulr9CydWEP
 ag/b5RkBQOpEZS2VEMIREZEhlZbOLZ2rLpLW8Ss6PX3+AdetwLBaWyN/FyGHRFv4BNi3b3TCJDD
 sWiz39249ej+FUiwS01DrnFzicMIVkyjXmE9WQij5FRabVhvTPxpMbqkKyfI+zV3UWo7ZAXmu6r
 8t1qzuWSt4Bn/GZkOkA3a92pi7w1T0GzCdTWi90P/FxR+jbDslBpcr42i46CFOX03ROseQHZwap
 czHQUIKDAmpqhTI+R/TcrrTZ1bdmrBgXPg+Q3i3g=
X-Authority-Analysis: v=2.4 cv=MohfKmae c=1 sm=1 tr=0 ts=69ac4cdd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=JBNebbC9HC7U5k7cQ9AA:9 cc=ntf awl=host:12266
X-Proofpoint-ORIG-GUID: PS-a4RFI3lyoxyCVeiWsU6orMcxK0_up
X-Proofpoint-GUID: PS-a4RFI3lyoxyCVeiWsU6orMcxK0_up


Can,

> The UniPro stack manages to repair many potential Link problems
> without the need to notify the Application Layer. Repair mechanisms of
> the stack include L2 re-transmission and successful handling of
> PA_INIT.req. Nevertheless, any successful repair sequence requires
> Link bandwidth that is no longer vailable for the Application.
> Therefore, it may be useful for an Application to understand how often
> such repair attempts are made.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
