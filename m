Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE3E13DDD6;
	Thu, 11 Apr 2024 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712838159; cv=fail; b=rwKy8IApJTxLF4UEERxrMW3BGeMmBFwJNNRXjSvql0UY3B3b40FrY63z3zfyIbU7BVIgl4DCcPuh/OU2ExOGeGv8t46Dz4cTeA1DY35guWbiJx5SqyjA6g2AY8mbLOmpRmcA1oKH1kCFLSYOnixSlBT3bjcmrAOe0x/y+j1b1T4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712838159; c=relaxed/simple;
	bh=S+C0tJM4U8b7lSs7ZaJPWjT98SQyPKchQayR0XZxwog=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KB/IWd7FgUPOUJKedOGEDpa9gQ3dh21NFwyT/rGNyBuLncrWnEQolYzq+ENEFohAKKJEgEAJkalYngew2mRtGC/RM1N6D430ic1mBEJX6ctz0EYnTEW93+x4BbmBisYYzzLPie8q4vUa1KEEx6Z7tT6106h5irLXh8WMhRcqFyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ak1AbbYg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jy5Gm+em; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ak1AbbYg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jy5Gm+em"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43B9mfs9028088;
	Thu, 11 Apr 2024 12:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=KMJNNDJHfoOiNpC373VmztPBMVrfh0QO8NNCHErf/t4=;
 b=Ak1AbbYgaEj149X06K8BcdKMFYE6t3oQdkmpZPSDO8/7C85InadOFG+pRjplX8U07aAZ
 ev8j/+1Ov8Y1W4L49cq38blZNAFhc8RiT0+GjgxEfQW89uujlXmIRBw7r6s4SMw3Arbw
 B5+IS7r+kU/KXjXcCrdQNJySFgXpWn0ZmxPIieAstBH/j+tjqJmDXWKYsM0qUYSYmvaF
 4CmPoI8J/I86jsnQL7AFCUxoQYjd0UdbUPrgSdlcOgnSWeTObLlOD7uv2Pg52c5uiOtm
 24byFd2TVHJ0xffGE2GDNojmN/bHdNe97z8H6NBM4/9L9OdACz0OO7qpZ/1AxRa/w1GS sQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaw029gpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 12:22:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BB0KE9010830;
	Thu, 11 Apr 2024 12:22:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu9ecf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 12:22:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+u7WM7ifIgHMJTZdmYlCfJvzCY/flat9Tix6Dg+WUS7dvoy5dfFOf398thrWDi6pnyr3OtDanfmTzMDLM7s1DbxtMUHBc+wt3Yp8eItdq0td3t3rOwoOWq51QQM7XFJcoEpI0OlTh0oTqLYh31lXDXt7HLOGblM8i6Q2XaiDEb8j3lYHpFO5IT9KtYW85PFDNizQdQMwvRXSM+t2wjTzqYkQxtkejieSvyzPLWuDZ2q5QOcjiny8BSUH7BRWoMwB0NYuX5wza876RmBUctMujK1vyFdRUUyxFs7M9/uk1/vv17WVKnv5GdMlByhIFrdFZkLuqJ7O5jnt9eQ4xcuyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMJNNDJHfoOiNpC373VmztPBMVrfh0QO8NNCHErf/t4=;
 b=FxhOkLul7g47She5QLkwAXDZCMirkEK7YEK7vA9PZdVg29PGajul/5Zqn9ugtnVRAvM+wKrreOY3+XeVQ0AyOdSmyhMGHcTmrn8ahw37b741Z8yfFGIwLSMM+lFDOxw7xfxsqOXlKvhgvhZqnXeJN4Ge9GMOsVgxVuKzw5zxEQ+XaLzGFmHXxGnUZ4LxvPeaxnjfE3rQLlHN2GpPzq0ydZOFZRHbmC334aCPVtIsY/YSdRM0DQreBmSEMOhXMjW3/rTJlHVoDoJVNfbZCV9npL11R1C9RkGEzEieG4kjwRy/gDxtgHst8Ah92mOqmHl4O7n0N5bdADhbzEZ8/wb4BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMJNNDJHfoOiNpC373VmztPBMVrfh0QO8NNCHErf/t4=;
 b=Jy5Gm+eminT6ySWtQLV0go7RgndUJUvfL0+SZOFxwPzwP9bWjVE3AwLajRY8t/iaeCfKnsiGaPvLXXOTl8Ip8ILmWyLH8eKlai8VnH+L3u8ueqjCJXvqOQfdBy/JTx4iyea8BDWPMH8IFuOGP+ttVBO1s01hWmxtWfwIf18nmfE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5054.namprd10.prod.outlook.com (2603:10b6:5:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 12:22:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Thu, 11 Apr 2024
 12:22:31 +0000
To: Chris Rankin <rankincj@gmail.com>
Cc: linux-scsi@vger.kernel.org, Linux Stable <stable@vger.kernel.org>,
        Greg
 KH <gregkh@linuxfoundation.org>
Subject: Re: Fwd: [PATCH 6.8 000/143] 6.8.6-rc1 review
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAK2bqV+d-ffQB_nHEnCcTp9mjHAq-LOb3WtaqXZK2Bk64UywNQ@mail.gmail.com>
	(Chris Rankin's message of "Thu, 11 Apr 2024 13:08:27 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ttk8ks5f.fsf@ca-mkp.ca.oracle.com>
References: <CAK2bqV+kpG5cm5py24TusikZYO=_vWg7CVEN3oTywVhnq1mhjQ@mail.gmail.com>
	<2024041125-surgery-pending-cd06@gregkh>
	<CAK2bqVJcsjZE8k87_xNU-mQ3xXm58eCFMdouSVEMkkT57wCQFg@mail.gmail.com>
	<CAK2bqV+d-ffQB_nHEnCcTp9mjHAq-LOb3WtaqXZK2Bk64UywNQ@mail.gmail.com>
Date: Thu, 11 Apr 2024 08:22:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0059.namprd19.prod.outlook.com
 (2603:10b6:208:19b::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5054:EE_
X-MS-Office365-Filtering-Correlation-Id: 804bc6b0-9fba-4e08-a8ce-08dc5a220f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/9yK+QiybETm6bj65xmkEja8irfHzhnPyxTjbsL3ELFwfh0ceyZZn2bYIgOdh58YQNh0yXwWTlEjRF7cr0aGRPrv+0K/60M/aGfzBAIw5zNsDYK8vGOTvopyNH8Uwg/hgl6i7HuDBfJ9a2rXoBNNRqqgj8G/jFzjnFd8hRhTJdCluApUOEVTi3TUuSDpK3Hf9KDIeXR5X9COGL4Vo44/yX2p0wDP7t9MS9SdVP6shfnWni4B1fEQzjf4KRn7ZvesY0C+HSS/NVDR7uM57mVvzSS4M+VqWIbLmtCwrNiw7AhFwq+tu7nbQRNKWh1XYhmALSt+betQ+j6SOsjRh1kEGlj8JRGXnXlb0eW/6IzG139JZ6wDnKWUirLqSO75FktpZ8mGjcjFQMjfWsK9TBJ8PpCIkyG8lILgMuZXWLFmmL2EbrbVOX32kQL+1r8nuwFSuO8U0xXQNuxXElUZxldOlzuNOi1tr1yjZ5/vp2kJ9nmsabjh0+tcLRHLnjXBOlHvjFcJvKjN7uJOaR5qJCEjVeTFcwuBw/k/JTFhHgk1SqoUOliL+o6RjuTusmYO9zy6+rtgHJ8xgifTPeQyqW2ztvWU18R5I51NAaCVdAKNedFL1FYux1t4jDnIVRronOH69c/CIB7Br16JyjwinbjRa+IIyotcBNf/DTKDOKwpJT4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?79+Nt1wcyQKNEfqNcz7u7M+vk4lRAV4HoBt6lX8mrFrIITiBQfa7Xc19NcPX?=
 =?us-ascii?Q?4SB97WvFpP7yc1nbkVKpW7pf77S9Tl2us2HKqkWpeDrl298m7QyErJRSfFBH?=
 =?us-ascii?Q?aRq1MfwteZ+S4ljlm/Guawait6VpSyBhCy6pOcO8P1UNdOwmI0ghgYlwc/eV?=
 =?us-ascii?Q?28Bq8zI6Vv+2HF6xFdKq2YFDG+qmM3WtLknt0UZp82bY9kKJqICp8xH9jTXR?=
 =?us-ascii?Q?izTY3WqOX9DxWkv4A4ngRSo6BJIY7ZJ5q4TokyJffBXqEtPzEFy/lXK5mmVj?=
 =?us-ascii?Q?6VFSRmb+e5FPE3x408kCRLNwMY4EL5oZemKQ3OXHHwWu7CTKXSlxX+0R58XT?=
 =?us-ascii?Q?/+TTd29DC5JlcwuMMY1OVJb7KfmyHSX8BRhUjhjK9vA7hAzPQ2wXeF3ab0wO?=
 =?us-ascii?Q?OOlryukP+CjKdQFff/jOJa9NpKJQRMAWe41jUVVFsDKHeM++cJ+IWlBF+BCo?=
 =?us-ascii?Q?z5XPXUVCSWYjw2rOu3tTWCDk2tycoVHxI9QEp5IYWePlKnHGEVIzx/TjuXzY?=
 =?us-ascii?Q?HPKkiUOWHGZUdfwnGstgflw7qqX0RanUf4A+YhxpS9IrfH969x/ialfv7Lro?=
 =?us-ascii?Q?oAtLOtIIlEtgQnmgaeBs75X/sftzASpZamtgWSGaqhhGFeoHJTh630rnpY1Y?=
 =?us-ascii?Q?qXDlb+UIFoUdTZhQv7ZNqT5Hjk9/GfRFYCa7UxKOawTSIRSQ1VrxgfqTINCe?=
 =?us-ascii?Q?OdOVR/PBMx8aEuL7XDH6gXzK1ztpmkN/VQQDSkpAf5yycFiAxYQo8kSN09EH?=
 =?us-ascii?Q?lgp2liDoInw8YLzCdeHypwyctGYzdLfn22h0MGuUxKbb0Un0/SyOhyGfg3Ag?=
 =?us-ascii?Q?GP27YfrCPVABOFd3a3D+Wcs01YZJ3yOsWZEZCqnFukFdKjWGtKmNAu7mKeYG?=
 =?us-ascii?Q?KzyDt/LDnBagtOOCDMUx2LRL43X0QyPVS8VrEn5/4eys1kDDdFxAyDiZyoa/?=
 =?us-ascii?Q?veo9KH3tZ3POl8A984cS/srswT+Iz1XQjNo3h6+yCo14bx9c7CT2vR0wo35j?=
 =?us-ascii?Q?rSKrVBH3coB12HE2afs+NAhKk9ANY4oq6T6qERqRgWj0Zj5q9C5+xA+SL9+1?=
 =?us-ascii?Q?GE2P2wVFyGg7diUCQfjLPY4Io/XXubNBy3uUXTx8PYTWkXFVv7r8wAKBbBPD?=
 =?us-ascii?Q?sIZTO833Z1pkmAYmuHuNxr9Sc7QeiRu+FfTwFKhcjmD3PXWoqGejHqicg4mf?=
 =?us-ascii?Q?AStRj32wAENevG/IkepnXaqyfkXCI7NZigoMyClS8mpKqMKLgyL6hkCisEhg?=
 =?us-ascii?Q?aqgnZneTSURwUP599tPovzQSMocEiWvRuMnjcwBWZw22THMqQ/ZtbD92MtVg?=
 =?us-ascii?Q?pu+6dA9YUZbIrnnuk7LkhK9NKXP7GDL9J8fQDQutzdjg2B898/O2j/E67rwu?=
 =?us-ascii?Q?jk5uaEP3lDW1j/cWThtiWWtgxegiDS59MH7MwKH3E+8HmI5Eb27b8HvWy7kH?=
 =?us-ascii?Q?RoTHI8M4+ZF1HSYXdkbHdfYczGwCmCkyVfiXWedAU6bObPulFje/+4jgHA8M?=
 =?us-ascii?Q?7HUT7LLvNfKsEn87zSGPUPxerLAqscuwdjQgUijMV2tbHGJ+6ajgjR0Ulg4G?=
 =?us-ascii?Q?9D0UWIskUjNEpsVSViOZpjn8G/bXYS6QNMMo/uqRew9lCq8681wm0GReDySY?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	JO6cvR4aGQjD+bnODsAoEZ2e3mGSsJsAu+E/Iye4FSh///eXR+FV09gnEldwGwilH7ckkY945FA03mImwNYdyXzxJvD/0/9Kc+aa2RVQSLvBr1166DUSnUQZWSqz7vusLQXYwMztFGIskwOoj3mKdQNFJXgu1zlX+pati0zdEHFi1flzPJlROkAskKJLrO0Q/Q8+S6uLg6lKb7G+jFxCdhZt6af/a/fdSuTc4GP2yNVICEech9pHPgMIXoSQXnLNrI1L2Gff8LxQS5U2+is8xRCWMVLIR06rGaF7f6S4zvTJGcdg+0TY4HdMz8y96Lnm742VgeOfzz1SXlmxF1JH948btqh8l/9jpa3ZPm9R3F3q3obtQQBAbd9xrpftS42W6T+JRhT0cSSo8lKOkauHKcKMsJTA8x/P5DW50uq1XeqOZDrJ5JSxH2nvfpv8P1mt9VSB1x/gQaWPZgWkV2a6YzclhWXlqix0MjNi7Q6qdEh/5XOh3wlHk0IQdchfK7cF0yWLOVJswzEf1VRxs77x6G9h26D/wba8PvaxlLjU4It18CXxB+9U9/Mb4K9y52wx1nZdqSWPQfhurrQivo9uzeIdtSAvAruPWO8GERkcaB0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804bc6b0-9fba-4e08-a8ce-08dc5a220f5b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 12:22:31.3739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKAYYKWKBdf8+Hor88p/0JeVvTCDAMV4fXAPW5GM6tguS+G63a6+/hO6TA1s3IOxbcIfGhz0NoLe5pC6iaB+eIm49nc4UVRGGX6hKGpjmZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5054
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_06,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110089
X-Proofpoint-ORIG-GUID: VTVpoTM573EYuqD5qEozznxZJqofMCEZ
X-Proofpoint-GUID: VTVpoTM573EYuqD5qEozznxZJqofMCEZ


Chris,

> I have seen a patch circulated but pulled from 6.8.5 for this issue:
>
>> scsi: sg: Avoid sg device teardown race
>> [ Upstream commit 27f58c04a8f438078583041468ec60597841284d ]
>
> I think I have hit this issue in 6.8.4. Is there a patch ready for
> this bug yet please?

I merged the fix last week. I'm assuming it'll go to Linus soon.

  https://git.kernel.org/mkp/scsi/c/d4e655c49f47

-- 
Martin K. Petersen	Oracle Linux Engineering
