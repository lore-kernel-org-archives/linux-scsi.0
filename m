Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38423955D2;
	Thu,  9 Jul 2026 01:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783561218; cv=fail; b=l+6T4sLNGnU8rmcJksOPCM7UlZ8dcJ67w4FJ/JZ/T7i4stIpMoBgH3jQvo9+jRNSwqdidwqRLT0Ig46CCiW+wXL7kE215XEf6NR1lpHbJSSZIMKWrj+7sDq+nmiqqJV9hOxfafJo6c4OSGd0AzOksyJI0/qVgEGrsEi0V4n3BFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783561218; c=relaxed/simple;
	bh=bREznIgYEvHj/DxHkhEg8Y1umNA+31h/7QFz0Ga3kvI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dskuXJxY32a789SVtJfNGB2hATgZ7VzgVqDURM65Y8TPYKJD26wU1dKsG/AXwvf0ladJbMuj8TvA8KAG5vBHPc+ljsYnm+9zplipk1Q65oba36PymBsq98holyrM6iytYwYJotP9TjKDnwE7UunIAFpG8QWgb4DgIF3r//Xedfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C9Vdnx6P; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tKCY/eLM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C9Vdnx6P";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tKCY/eLM"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668LDZhG3145432;
	Thu, 9 Jul 2026 01:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5dlVK5Y05966rRg7+A
	VRUIgOqQkM/5bmDjxkBlMU05w=; b=C9Vdnx6PYVn5FWy6lniJwDqvP4uLPSJ2WS
	dNzbmEpnnZbkDpima1SFSXaKgsSvFmqM3APe5B1zdhBN1xV5yWk2Ts5fsjZK2K65
	kFLNsBclbluJwRuTVobMQkGXkpTq4z7OOt9iq7nnQaIYp64Et/MkRSE5x8tsnmDi
	o4ZubR1MN5Bns7ART5oSZaMuaNzvzRw1Z+ZO7FPYgm5OA9+qXbt81MelrIfyjMYE
	yFEHgjzYPDaN1Pm/K4/eZ3ILCks11Z5gDV3Xv4/7xSPiYTEEQca8y4OkyCOfCbWG
	AZM/E0UsH1ULKEsL+FRqIYo1F3hrWU1YlJNdJddqJFJJFqJ538Dw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6ry50uh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jul 2026 01:40:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6691Y9I9006865;
	Thu, 9 Jul 2026 01:40:03 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011035.outbound.protection.outlook.com [40.107.208.35])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f84w181pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jul 2026 01:40:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RqWsi7sErlsq9rOYghrDlN+0HZKnxxUB/TgfLOpH+GsrSr6W1BgpLgUG/jzqVW4ZW4hvII8TT2Cq85EjuXsMbJF2Lflx98SgSdy8dUaIkZgHx/2AKC8XklZIpm2nuUExyLVBaEf3UtFPXth4fqeqiF8yLTxhfSerucR1yzAoSWXalWkN/JNvwOeSia0PWuvPuLYz2buwphxxPb2Wj6m0Q8/RA/q+lHuQMBIpMWNhG2xemtN+MIXBXYUqWabGVN/S1WNxxZqQwETkeul5CHkt2xLvOZFN7xreMf6nKZZCSKtoBPWdTHPMeeIdVQyRaHnRk8uAej0BY31SsA2EwetPAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dlVK5Y05966rRg7+AVRUIgOqQkM/5bmDjxkBlMU05w=;
 b=VK3wIDyJ5Km0nCXAIYwbRCLD1zO55G65jA/7qT+uSVuJapTkCqBnObNNeJO5RgQOCdU2uuFuO1c7LxhlP8+J0qGC/hXHYG6Ug+fV7cGalf4rjzstDIrnlNASNNDEcQ1myXkDVdUHbyIMrJaH7huxj8mzLgKjrskr3aIC83Db63RfsYr9qYhxmsH5CcwVdwovSxi/uoAKfrZ6tN1cGuJZJ36fVt1lZfehiaKQlk+hMNbuAVpYKd/QHWegXtseer2e3BFYGR9Wbl+k/bViAD+syvF3vgg1bYGmzYI6TjgUPv9pFrl2s/tAYbh3gCU6+ZxZYaVNAGRrU7CV2x96U8aRZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dlVK5Y05966rRg7+AVRUIgOqQkM/5bmDjxkBlMU05w=;
 b=tKCY/eLM2TPUlKVMx0HWTWBpBnIPaq96tBL110UL00SaRA/c9yV1axsvoziwVYdmzgArhcvIWa5hqR5wqkXx5rF9eQi1PdvJigBpT7/ryOWTrEmhy9BscvBBITdmVOnIdbBIHe5m4Fgmy7I33c3NcBOz26sOOFISnGB4Al5FMcI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB7439.namprd10.prod.outlook.com (2603:10b6:610:189::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 9 Jul
 2026 01:39:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 01:39:59 +0000
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
 <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan
 Hajnoczi <stefanha@redhat.com>,
        Eugenio =?utf-8?Q?P=C3=A9rez?=
 <eperezma@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio_scsi: fixup endian conversions for warning
 messages
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260623132427.838900-1-ben.dooks@codethink.co.uk> (Ben Dooks's
	message of "Tue, 23 Jun 2026 14:24:27 +0100")
Message-ID: <yq1tsq9hrik.fsf@ca-mkp.ca.oracle.com>
References: <20260623132427.838900-1-ben.dooks@codethink.co.uk>
Date: Wed, 08 Jul 2026 21:39:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0225.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB7439:EE_
X-MS-Office365-Filtering-Correlation-Id: acfaf091-5df2-4952-bcea-08dedd5afcd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|56012099006|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info:
	siOxqA0INNOxlhYF3CowmzthOWpuJcZ229xvxIFC8l1kIXeB4NHrYdnleMbRuR3qIP1qYuoqq5G13uXboeNehz/4ZsqWQBlqqMIDdYSiJYzfVLJStASe6sWah+LcFtqEXrMHi8hSixzzmws/YJZg6mNAKVhXYPH+5Arqkqm/9/O9btoBpwhoZsad6RPnnw6MwKDSSudqEn1U/hVo/uG5nGcGdu2OnxoTTMTvsJ9qrCJjm4v9WdwBG4tAmlsB2FJFI1xso8cDXF/nIpKrgF9+0P2667KRbjhz7fIVTfJZ8nXljYb01XM8PRH30VJFalKT3cZONf95trpRRd7F7axnqY2GyDPKHgEyfJfw0QFyrn6dL1a9TX2XeqBGaWubd60QrSMDTLv59fSvu3e1I36jJKIO3graBvjBqs+fQqSUcGUhiFOgI+wmEjMRl/cM95yTJW8QGXy7eOiTH8rVMuMOgCQbzOOPTLijXQGcL8BTiXV+mWpwYS/OWzSb+SQZPTQZ8Imo5BqKxTHoVmxpK0mSWgnG2GpTn74BF3FAl8p32gwHKl6dXFDq2HrzlFAMX5wRN+nLXKVReU0wi9DtmGF+p/RZ72sVOiBJxiOuCCfxWjdhxx2TWAS0TMm95JrhRcfOoGeCJdq9NmJiaSMQN4v2a+trdby/v5JbjucO6YWuC9s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(56012099006)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lfjiBz1OMSVV5nkVFa4LWtutg2aTE0HjUQ3sz8aMyAOC4ktuXONs8kFjxCcC?=
 =?us-ascii?Q?wo8oL6OUS5JTQzuLXPUJvUIYNykOfUUuHpCbrNCPqUDB89cMAHmdoXD5NhCB?=
 =?us-ascii?Q?+geyX1Z7YEVLHGsFBa3lh60kKUfoixvwe94Od1dFnVqd9dkqGj1lOgFYaC7k?=
 =?us-ascii?Q?teZoFy73cnN6ynUx3+sq1JA+ClRQSKSRCPE0N9PJjO8PtXcWJBygqzOBw55z?=
 =?us-ascii?Q?KNiZHb6QGlHgpiqI6NHX1K5ImbH6vqy11PXdn+K7uW+Bpyv5aWzzxEWMlcAj?=
 =?us-ascii?Q?otBgw9FMheL9aBBW+0YInJ1ZwYoB5lMw86PY0+iLl81emAoft1Ux6WWDOym7?=
 =?us-ascii?Q?0/UN45hY9Wx1ucXY9+eW6T6yCm9b1NcOf8VpPa1wDIcAF/E3vflnSnQfzTAn?=
 =?us-ascii?Q?5hUcbGvynruHqugYkJycayS9IidthzfLV+vTdUZVAxVVI7RmhriSwcr7bY3G?=
 =?us-ascii?Q?IGo9YsTPzKLimQ7W79KkYwnat4njz0n9sUPcOJq1padDxIWIkIOmbH+0GwNF?=
 =?us-ascii?Q?HbTUToQRAJh28wXds4q3beYh9kIQYDZMeiZNAd5AOMwEwgaOqVkOd2M30+mO?=
 =?us-ascii?Q?IJ3viGjjFadDOVHuLE2/um07moBrQ6SyZLLErwGQOC1SEh4DK4wB1oAxw5kb?=
 =?us-ascii?Q?zvZjxmY62sKNVq6KjhrK88IAteUl+xYRV3GDqTtg4H2l4XuhnHQt2k/XLhay?=
 =?us-ascii?Q?X8/flbPgj0eZNV6cUMaqHhvimxFa9H9+sLyP798qOGKRMQQ3YTd/SHURqsZr?=
 =?us-ascii?Q?Z4YD6oSI7gVBgRW4/xG+M8+B+a87YV0egm9k5vd0LbjmBjYj1eWsDKLWAvFV?=
 =?us-ascii?Q?TfvugNfyeII0O9/VuR8i8Xj/UMYdAOVZMo8D48fIGFAe/MgWW0EOBalLzQXt?=
 =?us-ascii?Q?fBxMXFQY+wkocPyRQ0Xj7++i2SsVDPrrkdOUPYb4cilpFAhBfXG21BtYPnQi?=
 =?us-ascii?Q?7cs7IxF3BMiX6WiQ3sPtYSnbPh4o7GCqY3PM6DG8f8zaG5xeEjXLGXb5yJ+C?=
 =?us-ascii?Q?wjZGbVE3yBqIgnaUMg5oWqlO5HDutmkPpJO0yS1RNh5/md96sbkAbAFbISsx?=
 =?us-ascii?Q?Nlbwvk1Wu8mwPrFTq2ZT5b3p+nfp1lnQZnUAIIz3tGgKRMDR7aZxnKt12HHE?=
 =?us-ascii?Q?YDBbrltqF3pllkTx92o44al5E6bnyVPevXX0PBM7sWvkwMj7/fZw1je6LqjA?=
 =?us-ascii?Q?i3sN2sO8iMX8EEE00OA28pb1fAzAIgSmbPGnVGA9bCqdazEjn1bjsRCodTGb?=
 =?us-ascii?Q?FwW3Uia6kB9f6LYEXwQ4pj3luvCDJijSrJ7CO3wJg9lHWpPxXln2syFwomPn?=
 =?us-ascii?Q?kLIzHRuiF2ORZxp3JKlvat8FgKhQyR6o6BF0tf+CjVRUFCJT26NmhmtM65hY?=
 =?us-ascii?Q?VOFv8i35CNTAIMD5m1J4CI3YaZBlPECgPrLSFBWoguVUNuOERVJO/kKzAm0r?=
 =?us-ascii?Q?v914VIQBH+eKyaa+z4PZWD4n3WQ29oFnpNdVHfTBWQDQjZ4ZlEb8JvHFRD5P?=
 =?us-ascii?Q?CbGRA054Ze+8sCNbyHm9RZdGbr/vfoFh7CWbH2VRXQFoegbQZPPdn21F+GQE?=
 =?us-ascii?Q?N1zYm1QAUPFdasjSDYeg/NKanIEAqB1eakuz99oGJEdIhULC33qkaBqvorXD?=
 =?us-ascii?Q?OBiTWnjLABXH/mgcfdIU65ObWR8/K/JocIC4t6ImH8m4VmgyHID4qOXrkuE/?=
 =?us-ascii?Q?tYjhn6KAAVCUVXI0hWKzlm8PenY144EFXapC/3CriwguJ/1NRC6fR8OGw++Z?=
 =?us-ascii?Q?72ir08YY+xf23Y1u73U50OJSfPfw560=3D?=
X-Exchange-RoutingPolicyChecked:
	gzFL1ynT2EZM5Q65+EVJLTa1qo8iymgwzMbrDbuGU8YDy+kOyBpFlctPAt3+YQHi0ESLGtFzX+Xu7nIPUnJWBSJ4Sb98Up4nC/rDQSgj2FphSt8bZKcF7PtSwOe9SoqH5/4LZfByb4r/dElJgHkYWgg115+Rz1zKG6IpcD4XkXxgQ2Gj6xkH3D++I7AfkALm0Kwf9APUMJF+4+XDUhqa2RGN108z97bKJSzSrd1os84bRneDcgshorQBWq8RF1bY3ZTQHkFOymxgGSYiJ8Fa0/FrNaPPsktYZgOVwE6ZuLj7Bo0nsY9pfZHC0TSfDh+AwhA9qiLtkQUmPS0+uGI4yg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jjVBNg86piYz2NaE2XEV9dEhFPMP0hhliHTZ0IJJVm5ylr6bCKdhllZBdujEyxBQCARue5EMSkktcWiUh67MMkVVrmA97AxkGuLAUpzQHVJ7BnwUP1WJSu7z5HN+DocDBNAoSoPkq9KP8KYSalFYpmI3w1zuT367pCgYeOElR2Hg1zseoEHOLduvB4L5u61MRAW3M/HzJFFMYMlDiSJ+qk0weeLKZNUrt4Fhsi6gnnZWxjGvxlKeljZ97+6d/KEwXdbNBw399sKN7vwmABnjj3kqPgtgT5DOxxgc1VPURFmX/zWpdGwyeu2cAziI5hfXhXEXklKJklVVFgwtO49V/DSLVI3d2RwZHG9zJPNpeJDFTb/QZXEnLlQh+cZcZd9DajNcbptAOcUOTtOYIdpkJAVocIdeLdb7VBcxYWVZiGYpRgc7HgBIAEQm3SR/L0HwdV/uQfzagPHadcfj7DWjGgk2HBzyHtrykWnG5TtuxPTMwrtc2KQ9qfzQ2Bfs1AOfBq0oNbMntTa54nlG3I2kyUqn7TKQUx/ZlONsqX2q89hWV2e50klBi4T7Hkmhhi4zBeVKrqITlSL6DQO44nniaYXxp45t11/ouQb8Z4YLcJY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acfaf091-5df2-4952-bcea-08dedd5afcd5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 01:39:59.3332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4T1t7sdOVwQ6YtY/Rn33bNrUZPZHlcwNftRfvZ8vOOnSMV3BoXdOf8VsZ6N9GlVWiILNY6OWX/fmBN48amxsLGQr0/3hHVt9pd/tEBdarP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-08_05,2026-07-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=684 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607090013
X-Authority-Analysis: v=2.4 cv=UcxhjqSN c=1 sm=1 tr=0 ts=6a4efbf4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=U75qAp1fu8h16lXNoiEA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13633
X-Proofpoint-ORIG-GUID: X-oaa5rNGI8IKZ08dH05GA5_6g7AB5tP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDAxMyBTYWx0ZWRfX+vKhZ07b9Vr+
 TZ8VqRbnoeiuQHpKJRkTSPpY0ZySFc82J+nwbirQfEwzeN39gazBQWGNxEsZfa0vIQhloFJUHCh
 EqxL7dLYHFk2ujJ03nflwYwtxQMm1v5IfbfpDWIG9f39i1bMSTtBS0CxWWGXB/OoDGvt8ZC6leK
 eN7sb8UeOkMaOO43TecpdzgJ2cbh69MDowqFxjR3TglFdGOeEV/DD5z66xFVPZZhtiSVm7cvfFa
 p0R9hH5owMruMmuvFY0QuZAhCVkNg9gYeaInLR395/OWFqqNg6BDuZfvi4Wo+U3/vADtIT1Zy9x
 dd02C2btpVf6X2/SM8ll+PY+vm6tg/ejIZ2uVajAW2NVMhCsPzB4NriTGutJcvnNHGgoAG2D+1J
 EARo+IemuGHS11dcEy0Scmil4HM/b8qqpiXaaIRND6deZYbibdcStfY7TBMqRJN4Xt1TjR8dd8M
 wG1gdz7LSvSB1Onatjpn4I4BjVzULHc+pzkEbJd4=
X-Proofpoint-GUID: X-oaa5rNGI8IKZ08dH05GA5_6g7AB5tP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDAxMyBTYWx0ZWRfXxQJd0PMvjVq+
 K+thtnNDq+Orql2mZpIGm0GEilp3TKYIs8Q3DI+zzYs43D+OdbWl37flPHqQ26HS1tkZZylPpVF
 G/OQAVAbdklYK1NEptVq5GtST8kRvlJhw7M8Tj8+6QV0hhEE5EZG


Ben,

> There are several places where printing functions are being passed
> parameters that have not been through endian conversion functions. Use
> the virtio32_to_cpu to fix the warnings.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
