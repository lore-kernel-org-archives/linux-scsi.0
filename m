Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40262868B5;
	Sat, 28 Feb 2026 23:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772320598; cv=fail; b=CBWnrZJ5y1WgDpqYigxYaG06sjiQ6carwQYPZNvFQd4rNBsedoMCqE8dgR+GMSjWaas6DIhn3NQPb8P/4NdAqoQ8qsAuSZ6/tbUHxnP1DWzvomQUghjIHNW92djqvi2yO6gNHfMBqkDGkxTSS5QJld4hKOEhAO3qA1kcjaAH0xI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772320598; c=relaxed/simple;
	bh=ckSQYVMzTxgr/CmTefW7oBBQZdLRBNkltZB7dDihM9M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JU4oTLYBDskP+RBD6q6XUD7Q1N3X/7WE9X+Mt7IJ1mkHEmywLrjXDv/nrFMnmI3ZG1ty+yaejAvGqBbzkQa/nIDQgM4vj+I63ZHrYcwSoOVIXbg+Z2h/ZmWkPtrR9o7JUdc4CrwHpX36HuvFSEm8BgIbnuH8B5HTEJ569eMLTVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hTLkvv2e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M3fZalCn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hTLkvv2e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M3fZalCn"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SN9DRh2219353;
	Sat, 28 Feb 2026 23:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VX+EfZUKpLBcFwK0lf
	W1nCeU7/K7DEL3CZGBl8IsaMY=; b=hTLkvv2eVCjqF6DeamBPWvert0KXkjKm1x
	LuymrPow6Hpd/R5wCMNtWP5WYNnjU6yN/kAtTMgDXgifE58HZ+B9Ll2VSxzDU8UF
	81YLebreT55u4Jl6G6nqn+bEBS2LSXCoLWE2gcqycu75AE197iUMEE8odsLEU/NP
	lQ2F3m3gT0HuEXnCO0Tubi0hr6nf9nNrQnHoEtbSFHmeDbvnNTGn1AFM/2wSsJVV
	X6T+amSCWJ6spLAG5wgAG21C3/FyK+nRzyRRwmvvlT5j/7nZcHz/z6qBVh/hL07b
	8SVXmoFjEk5Sag0DOIaPp7rH4fo3kvQfhnN/wlKIuX4yIy3+ZBag==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksqu8mpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 23:16:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SICQSp027494;
	Sat, 28 Feb 2026 23:16:33 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7c53a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 23:16:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xz/Kyg3mIdb3y4kS4jdv61eZqZQM8dJWOj9+EcG0acRr4LVcT8zJPXV9464LslnNV6RyxdA1kFBc4DTawoXBUin/w7rIcml0d5PZXngyxsH1SZSJmgn1jOi9w7UtNHnpBSE7rMLaU70qlr6GpYwODRbge7FbttVNqqVv7Nr6/8fyoNeWBQ1BTRLBb48Wxo7vYeIE41iRCfWJfD6OD2gRCyPfDyNNgcJo/eBlY57CZ6kWs5b/viD6gs4bTHNlwmPefTlhHfUpeZahJhXfufapqmz7KmiqBtmD7MrGXSkdMl7ZvtkSmgntObhMRcgU/YJ6PA38bFcZqQhpDVLkdtdv+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VX+EfZUKpLBcFwK0lfW1nCeU7/K7DEL3CZGBl8IsaMY=;
 b=VmxwYagvX08T8j9FER+Jj2KXAHdvn0jOUu1QdO/H4+W46Ol7GP1Ydn2RTCj7/pn2utvchZsXcfejKYDjQuhRablrRMxitO2eqiRGmvgMpX15ZfetoOGETYIfpUhjPW2CFmFfke8vaU7K8EVSrg5uoWAJ8MMLPE1a4AN865pTU2YsMF5j4cR7MuJ8eCvNLf9mgXeOqRfIKAZJ3PXBVeBpr2/D/c9xSSuszBbW1Y2GXRCDeI9cgblikWaryzu6KTtwKCs1hHbnVI8+vW2WZXynKpLuNhjg4cklMkOGBoabCKmydTF1fudwcLiT70gzzX9BXcUdmZ78DWNmnZbxTv6Ikg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX+EfZUKpLBcFwK0lfW1nCeU7/K7DEL3CZGBl8IsaMY=;
 b=M3fZalCnj8ByKhFm/4GgQYnZHvdrReB8mOB3UoKp4sCxBhjb4kzjZ59FmunUSaTexSPLHcEOoExeI9vyrZXImTx+njoOSe5/FRWdwEudvP9MZtLTDYRMAE+8b5TuocX+8lR7r/BLYSyizQfRmgI5W2sCzAW3q9KrRm2/6tn8/k0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sat, 28 Feb
 2026 23:16:31 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sat, 28 Feb 2026
 23:16:31 +0000
To: Florian Fuchs <fuchsfl@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: devinfo: Add BLIST_SKIP_IO_HINTS for Iomega ZIP
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260227181823.892932-1-fuchsfl@gmail.com> (Florian Fuchs's
	message of "Fri, 27 Feb 2026 19:18:23 +0100")
Organization: Oracle Corporation
Message-ID: <yq17brw31f6.fsf@ca-mkp.ca.oracle.com>
References: <20260227181823.892932-1-fuchsfl@gmail.com>
Date: Sat, 28 Feb 2026 18:16:29 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0482.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: a8c72aa0-4f21-4b9f-c680-08de771f6835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	VsiMYJlhEIfBT7ZyWDjd6sB3ez1r/NJfLO0y4B8+y0kmmHHxggzQhDbVMXBAvGEJ6k+dRuB0oC7Za7VGDU7aJKnXfAFiFHy/ziFNrHnnoaqypuV3Fafbs8BINZRRSoXj5L4wDhJmvUuIUfZyO/vxmk3f/iL/w0jcAPI89aJhZQnOiYwF6UXmCzzyw/mmLFBVpacRHXGlCpYA9GiBgiPuo3kjuLFL1sENpOTnR1OKXvv/sn06vRhE/tvwQ7ob3DjgeQYQ84oVKHJouL+oz6o4pxjG2i4mQ3p3uHHVhwQYbJfGM0ZjRUhAbGnNbkii1Yuz9cJOkHhlLQ3EVWbUt9RBbAoGM5vr5fHXsnVjWthK/H1qHibuS1AvZ7FJ6jXvTkEwYTIYVqGFKbGxJ+Dn4veU1xv47WOzq2hdHy/7TZCJsnf1U+ZWKNQdyPWWcUm95vWRZeZEoUV5NQshiBYxoWqvARp9HvHhgzderE7VR8XfkAEcTfuXfLYw/wpzanvzn58DQTNHRunHi61bmKyptO4mAczwc5+FAhJjudpG4k9aDE1uW6ijkvd0eP3biQXSfR2FUc2AuHEtebhFUj5dCC6A4mjD5fRc5FYYLbtwebtmcHYywwpKtqzu+SR3rgD+JRa6cRsUonIOCNZ1rYCTLest1tmjjTNZRObe0twHeedBPND81Tg16GGio11ym7vZY9ecbtl+8N2EbQWBFC0CK282CJ1paRwc4XDef9I2JAMSRjk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LfggGaA51ZyAKomZP1pBK7H6qobrgoLo2sTs5SJSANgttcTGehUS+wiI2u0T?=
 =?us-ascii?Q?3NyUlldxfU36d+sKTbU7F6ozAnVTaqqF5STAyRDFR6YYO+Cdc7nMZCUqw6G8?=
 =?us-ascii?Q?rOEdSgXRebVZrUk0r9+Iw2bXHMj0fEHJ83kWzwvweFzUGGWAh2J5DaA4BSog?=
 =?us-ascii?Q?T87GzmJCRs7iOr7zXrBdAHXIKUv7SXMElK0GyMlHvDYOAxbZJSZIidktPr6H?=
 =?us-ascii?Q?6cAKa0PXTJs+Ea7qW3pNlAh4bM95DtWTa0Qrs6xibTlp3MnbqXUfGYcy9iir?=
 =?us-ascii?Q?VEpxHs0Gbz3A9cXlt74p1Wzeq5vrwRLyn10K/4Q/L3PHsE0KQvnOBk6kfFyt?=
 =?us-ascii?Q?YBtoysEyFCoIlfvxbki53/F8lauVzPHPv1ivAwpHSq6q3U78THGZsufgr03+?=
 =?us-ascii?Q?SftYeLQMFboWKcHhov7PzrAdHJR00Goa4Gzikio/QXU1zeSIsZDaoAJ7sH0/?=
 =?us-ascii?Q?9HdML/nya6T1wNezRpAcnRiRpCaXuJq9mJ4zoghxME7p1FzWaC991mhEHGgm?=
 =?us-ascii?Q?ns/A5FpeOtW41qiWfj4OdTs4hm09WuR+R0W1Cn8ktHw9pY1ui+Y7hIBL/7nB?=
 =?us-ascii?Q?DUUipK5RMvpd7hz42nCePN2QjqZuGZJMjhdVbK105hQSGbJMov4UlTVJ0OPH?=
 =?us-ascii?Q?vLMBMIZWDdFs+mXumFxZnhbJjDJYWSEQpugDQjYiVCbiHITLtFSY1UinO8ko?=
 =?us-ascii?Q?djclaqrJ/UJEl6QClbtJufoGqz7cCX06MvLcg/wUs80/47PhQTOrTLohb06n?=
 =?us-ascii?Q?cIW3rgTJ8tiCBa44aq50KImWY7aKW5Ek4TdqmJps5UWGeLi9hYUSbO3zQUu4?=
 =?us-ascii?Q?EixqyBkSFs/oiXHFVC94/tCLZ5muqxpRQfov/eRiBnWHuJNYFWRNRrBpiD4e?=
 =?us-ascii?Q?P1SncRX5Iav4ps4sF9H9ElNre/hqgeOJEzkkLk9ccwaMQKrlb8Jlc2IDNUWX?=
 =?us-ascii?Q?cGskN9NdM1eeIQvnXqP9XkTJIStOCLaqy8qubk91PYFBr6fO3K9EItORGhd1?=
 =?us-ascii?Q?kCrduf71akEKWutQXidsRH75XMADJn5vzc0G10g5M6hFhEsay5TEYWs/l5Xa?=
 =?us-ascii?Q?gSua8/9GHs78Tt0GhXP1eYV1/QYctzvoHIfJeBkHBplDAsofQQoaXxCXtt8o?=
 =?us-ascii?Q?0viImVaX8/OqScQ8sdYr9ZBqYDPu8rr/ev5JKEY7Gft0a9pG7kyug+cwqjmY?=
 =?us-ascii?Q?4WwoTOmJI16kYEUSv4lcjery6BqddTRzCeglKGewhZwt9ipiTrR//f+dJunx?=
 =?us-ascii?Q?6Av38PZhlxWneAWSC3ciBDvc3QKU9CXiSeLwhWjw+w3inAaj8tdbSVO1VDDm?=
 =?us-ascii?Q?OssLJf+DP8O7XyOgIZlE19XOB9LT4PJ6+uuuE0KR5dLjOs5AAnLP4H3b+t2K?=
 =?us-ascii?Q?lTfE1kuIRcCJbLt5HciwPIs+Xb38QOKl7N0SgZb1pBrTz8ZUn52D/j0lZ0uv?=
 =?us-ascii?Q?zViVNo2Arg3A4BXdKQJKXxBH+L0Y2O2dp7cnKn+ROfT5dUewmiNsWtBwgczY?=
 =?us-ascii?Q?O5M9ougdProsbTSQQjJI3HFTovuGoKte8kB+pJrWkNNEfa/7kN4TGgUnu89e?=
 =?us-ascii?Q?UmjEFWwv26qIHaP6C4TYnbYmndyNv5kDYp3cNtRFqLy2Ue0mUqTnEHhSB/7X?=
 =?us-ascii?Q?f9LwGGMfVMK0kAi0AXTQCvqEE7ibFv8PcwwRlbzIE64qN8iV1Lm8zD50z5/s?=
 =?us-ascii?Q?9aFKcI7/752uPoHzLe39Y64eSWFJHmgbER4RFffKuh0h+xw9wluII2VkdMOO?=
 =?us-ascii?Q?Zgix+kbgpQlaTqmtiov/mZJ+5x1PsbI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GkWCTz6jq7tlnIcMVoOdXELdhGpziUAbUMcBpHL9+fzukVNsiJ0G48hbTxdDdgfORGOuGqIGWV2dF9+s6sLBRUmssvIAgTUr0Mvm+uoo1lA/mrAoMtvwR0VYB3PHpd7EVGoMOYlQVntm9sSNGCZtAizKO5OUnbuq8qOcrPie056wclQlojoWogrKoHfcGbPbYNuwqp96GUymZTLVt4ndBaeMr2uQTqldTq4zLGW6ngbXkluQwevgEusCB4okb3e5o89lM9JC2L2ZUo+diCTepTrZEfuWjEAl+pm9SWB1fGpolzgpDrlYKYyCba8TvvOHUgr89QQghbsh5LWAbUQH5YtTL75fPUG0RkU6yutR6rS18f7xF9W5YKKgd8EyY0Kol1fM74YyfnMuAB8Imry2h7cO8BQLmY9k0aWndf9XOn8cGgPgggUx4K/xHdvj7mr2uXaxIblCb4yqe2HpS3o5Nzd1p59BS9plAFrc74FL7LU8QrMiW9TgiAPdn9ibOvk3TAStWrqYkfljMd3lMq+3VEOTTLnznYxapdFb66Uy9fYPX0kgt39PnjPX888SrpjXHDAOm2Xmas6XMfiIjMQwOYcimmCDPeovRfW3dMBngsk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c72aa0-4f21-4b9f-c680-08de771f6835
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2026 23:16:31.0536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TnEr1LbpjZU9tVLDXRMkpbyu3ZxE4iRHjz5FiiLRkK18G6LIzzDoOUfpGlyK3y5AF0Xy/+A5/0FTnW/uVYJwK47VwvtcUNJ0eZuXrKBHh6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=924 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602280217
X-Authority-Analysis: v=2.4 cv=DqJbOW/+ c=1 sm=1 tr=0 ts=69a37752 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=Gv1qhtdonJj5bGLx1A0A:9 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: sysJxNZuveFl5rnTDBWgmGwTXaeMEDjV
X-Proofpoint-ORIG-GUID: sysJxNZuveFl5rnTDBWgmGwTXaeMEDjV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDIxNyBTYWx0ZWRfX9g2/UO+ZsU12
 r1vxwubv6j5dmdozCkASw5xxnpMyhagSppmnMNKlK6FglBguiYMgaqxGNaiKUzSWy9/bY86xnqK
 lqFPWUR/StSBi2kbIszrAx0o5XVYycGgDDGUJuXCBPXaQsvebdxOipGRRjh3Urht+uT6qSMM+zT
 HMrUgF3TboljJvm9M6JM0aTZGkwBfLOCsV3ElwqRdH8dIE93cwa93q6s5QSMiN8/wYR/vf3ShbD
 fJlqHZs3zPIWg0fFjKsYPgORcC32z/eNIEtrB38DRp+ZxVzRpwzD7qOmthWKZ4cOR2d9TvCrRSP
 VKDmAh+LEoViIm9F+h66rgHmoUd8ELaKEtzWxLQrisEPlZ0hd7Z9U0S/DYCoW2x4bL1i3JShNiS
 yl9MQ8B5X7YM1l3eyycQAH1PcQWAOa4qjyqCzpFOmkpkDfVinoJoWj2Lkms8StjLaJt3IxqoAGy
 z4j8r/Y0sQrJ+EPeb2w==


Hi Florian!

> The Iomega ZIP 100 (Z100P2) can't process IO Advice Hints Grouping
> mode page query. It immediately switches to the status phase 0xb8
> after receiving the subpage code 0x05 of MODE_SENSE_10 command, which
> fails imm_out() and turns into DID_ERROR of this command, which leads
> to unusable device. This was tested with an Iomega ZIP 100 (Z100P2)
> connected with a StarTech PEX1P2 AX99100 PCIe parallel port card.

Great work! Applied to 7.0/scsi-fixes, thanks!

-- 
Martin K. Petersen
