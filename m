Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48D029BDB1;
	Fri, 27 Mar 2026 20:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774643407; cv=fail; b=KwM04vsLytFWJKNLZWCk+LnqtXZ3nZpOKeXM/ysxzLG9JVb5ZgzsLlN7qan2/r8tA24X30P8qVqCHQDVG9Pgoft7iWEy1qIlaFMoRt/HSF0Sanzce014rQMjrahiwvSbNSbMxgL2bZJFfju0F3S1qAIQKefrPDx+LBATgVwjMng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774643407; c=relaxed/simple;
	bh=mPBxqQXr81jFZRiiASebbDikatQQ6KQiTm6+gK+tYvs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UsptN2yndoMFfaqtZGWnAJrT3XiP+6VVc6Zh4HwtAHSxUAN209g7e6wd+ZSqOrODxX4FUDKFx8WKzlM7g2rVRe9x6lTvB27K8ZLkLE+++0yHCZf67E7qi6HBt+Nz+NKkrEgvPZCWBREzswEb+TTyqlaqe5znC8DEzRVyZe5uUo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZhYBXuwE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j5P7ZQ+3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZhYBXuwE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j5P7ZQ+3"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RGvrYT980051;
	Fri, 27 Mar 2026 20:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Jsyaee8V+G5HvpJN1/
	K1UqJ1q5mgYfzzL6VEzi8VLQE=; b=ZhYBXuwE+/dChxMOU8Koy7MhV6Qfjo6uRo
	8RRRV1ruidIMQ0trM+Lk4PF4FPWCx2QDJp5aoVQfwKIsOKnwqpy94tiPYlEDRsPx
	JuRYPT6uH3SCl+RzuYthJIKWCV/kJs2eqAO+XWy+Fft5Fs1VgSxq32+tkIrCHX99
	GdU3RbMdfU6l1JT/JkitFfUM4FL4FrGGOsvMWwzkIgnrLChbM+VVNfFeJ8Q15xA0
	Yf3NhafW85f/ZRxNa7xoE5JdNW1plkbCDg9QUk5LGUw5obY6OgwYA+IU/eRxav1v
	iW3miJg5WX5acBd8U9TADbbtLDR0+aAgU1M2lBoYiIZfIOtpg9Yg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kgftr82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:28:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62RJeQ2V038876;
	Fri, 27 Mar 2026 20:28:38 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010032.outbound.protection.outlook.com [52.101.193.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsf1c55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:28:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oeMSP3Xdwawoh+40+wykKSLpUl2se/Sdln2PVbVWTSP3vS5JY4LQDnendpamhZos6nWxaaUgSaT5vlpfOUfsHSTxzEm14abpInh5iMrf+BKTWDh8zWe4n5dWw8hY1d8ihvEyaD94B7NzsbkOXPvuywXa+BuiDpmY3/f4UtT1vlLYS7l5QTjJxTJ/ZlXZCq2Qkou34gLOpKU66PTdPPSBQSv480CST/PcKeGrYCdq8iWjlGOvXoHZejEvsKvrWaqGh7gOxbWznkWL57yc2cQhBA6qXziPxPBEJAEz/Z45UpkC5P5NcySJUzTYv6sjIXrfLGGr7uaS1WnSygyCC00GmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jsyaee8V+G5HvpJN1/K1UqJ1q5mgYfzzL6VEzi8VLQE=;
 b=GPOnOmBlmFcIHwa8FnnZbVX6LLpue4op272uxZs4be3yZlmUMRnd7NFHULuN6hdlVy/bsly+Q4HkQCh4h57ziV5kbERrj1d93vWcBo8+TEf+FjMG+m10GHgGiK2eyq4OA2TBLHXHIe4Duezzl7lAKLmg4bO2+VQ1Ym0XUEJph+P+ONrpvxGspxZEosoo3e26ULZgKh1+WMm1j/9HouWVo/cY+KXclXWtIKFXPEeWiUNbBVTgp89KGY2Xf178NZYoGqg6SWV4hq5m+z7gjPzVbS8Of0lBPEOHvrsHkoquEO4SLgjXRzfHaOfSVKBZG5Ru25fW7gQD3foaqWUlh1RL3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jsyaee8V+G5HvpJN1/K1UqJ1q5mgYfzzL6VEzi8VLQE=;
 b=j5P7ZQ+3HBbQGBNHZJfrHUTuP+5xv6PzoVkKxedJKbpQmHil7r+d+c7b3Geb5ydcQrvCFt2BH+J5l19fhgvNGgMDr6+if6YAg3MhK7yi3S/1B3aPPPWXpRlfpzO0yXZlyvUVC7LMhqqWF8UtJJtEP8ws8lgnHiC3CGaReavwH0A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7414.namprd10.prod.outlook.com (2603:10b6:610:155::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Fri, 27 Mar
 2026 20:28:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9745.023; Fri, 27 Mar 2026
 20:28:20 +0000
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Shawn Lin <shawn.lin@rock-chips.com>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Heiko Stuebner
 <heiko@sntech.de>
Subject: Re: [PATCH v1 1/1] scsi: ufs: rockchip: Drop unused include
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
	(Andy Shevchenko's message of "Fri, 20 Mar 2026 22:56:06 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ikah9fwg.fsf@ca-mkp.ca.oracle.com>
References: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
Date: Fri, 27 Mar 2026 16:28:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0128.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::31) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7414:EE_
X-MS-Office365-Filtering-Correlation-Id: b128d2dd-f858-401f-3bc4-08de8c3f631a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R+2yyG1huZYZcUXj44lGxEREVF4Zq8qojHUkfnrznm36lb+AigogLnRDQKsR7z125Nys7N9ZWNMhHZuDQDxGrLMgtPD8FggfrVrIDMzTBPkVlQlvcOJTLNfvtaa5DzOjpO3uu8MaRpsC8khTAKzAo4OFsIerArScg3T8jbjqQQaoVKBGd4t2ZGCxhaD+YJlAfvj4RAP1SQrGfUt4V2shHJYLCGMxbwmPBSPr+rfAQJvCKcFNVaj0CMFhMz2OjVwy592r3/shn4Z/6CeQ1Bpnx+TXbq8B9cJmV799kYpsdoc0WC7wuLjneChx77KjjfSmESW0SSv/+31Wkq63x9fXB2rYPGBcf1FipLCZvCyWjpbW9/ggtFONlKxz3P8IMPRiao8ibriMNtAb9C/kEL05FZLKd9J19Y1BfA8Pd0Yq+/y5iWNLbXw2iGau1ZF41MmPfzNS3bLFECddiAeDbxkQwJMbr/59AwnZna+zTDO4oH0C+G2MbcSkFBAIQHNrUdd2PK9lrkuSsbF8oWfo54E4kLewpfGtJb782emc6OhcED+J/lL0ayyAkuyA7OV8Lv8SWPksDqNDR9zm1Usk0k5pFCZq+q8ZwnyB1ZbOZZ/Tw3lFfw43jMpZiatOpbMiq/u9xFH13r0+6lTkJ/MWzIv7rjzyMwGJXn/21YMFSGrWBgVXdnPW/Ig0IHV/KlR+yA4lR2Spm34SqX6/X7cXMi6RJwJsuslr22BR5M6NSia9+0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BePcwIxO7arcgG5rUk9ztYE+N+OX6BhetzLSOTCXxPl9JWSIxNVCGdhwCXkv?=
 =?us-ascii?Q?euGQgoNucBR3HrObW1c1P5NECzAWlOiihQyrz9K/vHSZSX2F8MjMnok1SBKm?=
 =?us-ascii?Q?0x5YYx1KgNkFYGoiO2UwmHVu/SRrlMVF9tGPErbukMOs5Sbtr9SfPuKfpC2V?=
 =?us-ascii?Q?7fAChY1lKqtRMnOBXDlstNOnDXHvwHxUuhvezy7TsxbbMXxQZDHOH6zy0Svr?=
 =?us-ascii?Q?e7GNPdzSo7qpDCnneYF4Y4uupwABzpMBQEvCyhbh8mqtxgFJWWQrez2f/REp?=
 =?us-ascii?Q?UO9/AkwGKPAQGTanXmWB2AEbmNeolBAlaknLqkjNx4qeCO5t9svPMZUESiUK?=
 =?us-ascii?Q?NRg+IBRxkUvlVqI4aEftcQTuntVqhTFvtOBFWsklhWWAXABgsajO/tTSh16D?=
 =?us-ascii?Q?/LCNql/Rb+TK0avqFNa4ZR3HeAMx5+zFahhFSqg6WoKvnvogZG90agg3F1sM?=
 =?us-ascii?Q?RpMj2NTG+IrunZRwcmwJLi/TJwWE2utEQ71mGyd/AkpOmqDDRLFkxk0NVH1M?=
 =?us-ascii?Q?Vc/iS6dkJRSFJhwR6HbqtVxpOz60VCOga060uhQzbO2ThA7d79TP18nyOl5s?=
 =?us-ascii?Q?hHuZC7eZ2JZDUt0JA3lI8j8P/1DfH/Tu431d/Ts+5ZJycTALH1J0fchC/jbf?=
 =?us-ascii?Q?9aBuUCQRcGXOjki0n4RjxfjG55M+1BJSrltJecXoUVT4yuKblTA8kkoT4hj5?=
 =?us-ascii?Q?V7rE0/WLlWMQNDl0fok4NNSArbjSdxwKLeDVXtRp4itjrG1VGUDbwijUec64?=
 =?us-ascii?Q?UrjSK8EdN3q7QjToZ10KDCpo07UvdwxnojBl6Y5FUXfK43zIV9HkYVutQ0q3?=
 =?us-ascii?Q?s8hZqaZV6Lh/J2qk56+RRZsJKUJC/YUjP1umaS7qq7jj1Oi26B9FVz70DcAu?=
 =?us-ascii?Q?iKi2FdIgxP60q0Gl2OnCsU+PJbyuzNN1xqOANsMlkgjY3zoylDN1+OTBEZNs?=
 =?us-ascii?Q?yefNOj6h/R0awXVjbr204StsnC3A3LFodI7YgdsOnhnWcxV25brq63mQtHb8?=
 =?us-ascii?Q?5Tp0w+D9YEwyAqwWP5K4hGJUNcSOea5syn2UXfMjquPa3nY4vSfpJCJ6IoBu?=
 =?us-ascii?Q?1ommy09QQ0jvoKxp1Joe+D+WlpdNNVbDwi9jGx1ngsKo66ZIUxxOivhDhAHA?=
 =?us-ascii?Q?A2iKb+ncM92hHgmMG+unaBvXMlMT6qBnSI1h3Gqw0JWCUEBQUwE+zl5y3Meb?=
 =?us-ascii?Q?Og+wFTDwBDC8w4W6r4ryXijYAkl0iRFeLH2b4p0dkmbynkr3dNW0GdPWH4LB?=
 =?us-ascii?Q?fGctNPBvbYAeO5pfm/plHtb8TBdRfnLmd2X77U7hqTKvQ4vdPGcxv/7Efivc?=
 =?us-ascii?Q?m9m99Jbm2+pTY0nTotCirIrQE78X2g1sg+xyYRm8a0Y7xIuQCXdqukgi1M60?=
 =?us-ascii?Q?tXdzUFf1+vYZBFGnBTc8t0tyApuNCqUdBxc4O0gBJ6uh01a700VCcBh3A9F5?=
 =?us-ascii?Q?Asjg3MCGhzabdRy/6U5LbebecAC5wkbkgXe7Mw5AOZRzTA2uzzUSSty68o08?=
 =?us-ascii?Q?bKY1rxG1shJtxiTXXPMgvuUKjcTIhXEeJyNonCP8lVY+XV5T8v1DphJpFMN8?=
 =?us-ascii?Q?OQCkE6dFrEwLTyQZBPOvmzwn9i6AxEpJSDJT/l58ap/nXm5cv3YUZNfaq40w?=
 =?us-ascii?Q?R8OpZ+C75MDQxixw3FYMY7YjOw2j3eDZ6qA6Wo2AymywpAU5Kw3I0RKNH/uW?=
 =?us-ascii?Q?75tCdxmQzZyUIjfijTvwIExMWC/nH/3I/wfKcEa5TynTUE9vYYN/y0LXNWGW?=
 =?us-ascii?Q?VNoOs+zHqvZ/lOrXqvTmOOFrydVgl1Y=3D?=
X-Exchange-RoutingPolicyChecked:
	vEM7FHfggWLtgghEh69zdmJSVVGrq+BttvTKknQJFEGhW+YrfgJ+l6O0UuuFx+3RpbIQvtVW0hqjMzxdXxJsdS7/ukx4hh4BdWRivPrtHBWCaXGGxOr9T+YplmwjUIp1KHUaPYurmwLikP5qRXGtX2rfJDLFFg8dylKJ4gZsBSoye/88FjeuiWC5XaTfki9CX9hhSd4R5vjpVussyOHI+B8kQbOcA2dMRleNgNua9YKBNWIkj6YboFeBmwJf01uVeDv8iBAH8y1TqcsSbJwPbUnXmXacMsiYEg2p2ugacbSm7YQRIqXqMiYZevUsho4WRJ4H6v6HlUgYb0oVsNyBaw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gdw6+tCQoMgphrEUQzlHKN9bwO8wQI27Ktfumvvtv5P18MwOS6TSPJKVTt8spsBqyhWkdkRio6QnPOYvb/0+c7dDO44OuMxO+ZfU7vgsT6p/92LoiaBomZkA5+EQIHFY3d7OZS428jFjpXamZVpZG5Ue7wnYGEYHTHxTY7WLJ4XwbNiP1qqvKXl6nBr5f6DhAhB+Ob20VPggR6ztZV4il07XwJ/j1lH4SAtGolfDWcjey99cIqPIkXutnq+Fq6p3Ax+x/4o9N4bNQDUoNWA1IEXhToSnlrJEdUPpHqz/5wUyNFaXP7X1XHtwdOl6CO9kCVMHi9CbiROxn/8HDD3DlSJQ3iamq2KO0l7leu7cEPYBIZdudRbUiLRiNIfCDetKRPPFhSkKz8qkkLAN/oiR9XmK7A+hSBMsDFT37peEF6mEszPmrx/WgYAEs6r7n4bNn5zRQRuEpl5p2wuZhi1KHAHga6P1N9tIN9BMPZGQUvgB0KDD80aXpIgd3BUEr3x4zAuM7O22wDu5q67mc4G0PRqggkR1xjiVU91V/xwo0vbWCLui0OvWxr01wykwy7a5bmUoWe0vZ3kpHbIJswBLO8Fuw0VGF5fWlJIXEuSMb4s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b128d2dd-f858-401f-3bc4-08de8c3f631a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 20:28:20.7727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qe/o3QgyRtCYOW3jMjOazVfs1zbTQuxA7DNmTjalaavuANPkZO9JOg0ElE7Moou/7RrxY+Y62HYXulmxw57W5VTAtKgs2anrP1MIbESlRXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7414
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxlogscore=695 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603270143
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDE0MiBTYWx0ZWRfXwQxejmeuMHNG
 VnVZWTu0lLFvg4tqQbJgFgTrYKNqN9BIF5bvMUyVqNVPQ10D/qSmRzEhkGrhvZxi5au+CviJNIH
 Lchulqu7Nop1p+qO58lcUzY8dHYkUOcAoBYR/QKCm5bLa5Dc705hQ4fS25LLv4tpJQ40AStNb5x
 gGDs2+LgJ6JN1OnbsS6g8V7GwWIIYOB2Gmrclgi3d8UmtUtr8nlb4ueGru0w1UBNwl4VOf4LJLG
 c/CNJ2MyPNAze/y/jmSVEm0mke/MImoqACDzAB+2a01lQf9/rYnBDbJVU+r5vt7XujsQV8rTeXF
 yV1Qpov+m9ObIBavD/5XFhebsjpN3OWXkIx8f7UGeKl7WnlCiJvjLLvUqc4BieLZbrHgOSuvrKZ
 xpr59QajRhgf9XgY4RAqTZqJiNm5ipM1mPPLv0R92nweIdGdz87+qi1AX4AH+BUn8sFW+nhjn2P
 oqFufeqPVBypDedR6VkSXUr5D7a5rwXENAMGXM9s=
X-Authority-Analysis: v=2.4 cv=aq+/yCZV c=1 sm=1 tr=0 ts=69c6e877 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=-MMmf-VsBYFSy3H-XEcA:9 cc=ntf awl=host:13811
X-Proofpoint-ORIG-GUID: kbP4WORVyifLMONJyT0l5_JEc0xEnQSt
X-Proofpoint-GUID: kbP4WORVyifLMONJyT0l5_JEc0xEnQSt


Andy,

> This driver includes the legacy header <linux/gpio.h> but does
> not use any symbols from it. Drop the inclusion.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
