Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DB6C8E9;
	Fri, 31 May 2024 00:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717115019; cv=fail; b=ezUKPNaJVCXaqtAqLwXCMmv0399/cg1sGsvTl6RPZ5DY7uR0XzhF95Uu6BktIftrXH265dHHEWSqbTJaK6guUymhUWkE9VbtIHGQjd/RSd4ZuLtDce72JVpEnzQ73d+MaKnphb+FTixVXKxjBsHt6/7LMhJxVvCprvcBeet/mcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717115019; c=relaxed/simple;
	bh=Sk/t0+w/rFN5/hGY7wrYqtZTwRKBncMqChe1zjVFaAs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TTV+cECyAZjAzSowYh3LiUKzZ/8VYJnVlKfD71imCBPZ67pVFzo0wrXBWFLQwqYw7JbHH5ZqnlHBj73mCqHuuxQbr6R3a7NqbT2H7mJO6LZn1lNxBGCmLlxTbMgwWtRy8lfLlni5hUmyz9PHp131aGYzy4HtNvpw/1/vScPKi8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44UNmhxZ001870;
	Fri, 31 May 2024 00:23:30 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-type:date:from:in-reply-to:message-id:mime-versio?=
 =?UTF-8?Q?n:references:subject:to;_s=3Dcorp-2023-11-20;_bh=3DmWpvI/5JFC1V?=
 =?UTF-8?Q?b7Ha08MYG6lv+wygiJeFN5PLQ4NPg5A=3D;_b=3DXgjyh+S83rEJ6UdgJl35t3W?=
 =?UTF-8?Q?FoijCBpiTRwfQTyhfDDlyBWi4uXjP6cQqqt81Fb0ZMITU_VBubTvVqadz4wfwOH?=
 =?UTF-8?Q?3zqiuNQtNi3LMzi8OZ+NSq4y5QBilTaETn7JyqoCZpM1zekmxAA_JFI7jtR+Db5?=
 =?UTF-8?Q?1rNOJ5ihwxkVbCh8V6V9+1LP4FBTAdiCPLeKd3belTpqhujxUxl4gCagT_J8BSn?=
 =?UTF-8?Q?XQ8R9ZqGyBy+g4m6ELc2zsg109avvvuyAuxCzJF7lTPQ6e6hjlqPSvvm0iDgqsO?=
 =?UTF-8?Q?_4wOuX7urNqQXLLLRHeQ882/t9ZEnN8DflrLinemXKUt1m6cuuRmW1sf0UfPl8W?=
 =?UTF-8?Q?EVsVo6_7g=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8fcj5nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 00:23:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44UM33kg026610;
	Fri, 31 May 2024 00:23:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc5098614-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 00:23:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RILQQmynNrP8IZvOElFv5beru2Ad8cxsASJoLZSpbV8hHIv7QHn2irLtaOvkkCSwJjLyCIuQJpOkFZj0Uhbs1u+A8a8wnWI3yhoGeMB6kAZZB/aDbaMuqSq/QPlo0vHYsNj6MdpXgYFGMSNt5aciOr+v48DmJay0C/eNTwjyG5MXbNLGiyYu5bLpEzJJplpvcG6lc73vWyznkvfracFlCj3B3VjTQcJxVGi7n9E8T6rbBiH5hTLg/WIX/2D68+p7lFMW+vXCga4S7DcPah4KS6//wvJazFknXm6dA+KfJO8zZmJDk9+ml2EGU+o3oQdBQgjqrw+RhSebqeAficaVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWpvI/5JFC1Vb7Ha08MYG6lv+wygiJeFN5PLQ4NPg5A=;
 b=TAQxYcOYJoXp/VYChppHeVhg3yxyYWrYDkoUblQBszCfPYO+o4Nh5qcK09qMCIvxZp/AVaQFN7m8Zop0gCwSijp2KCKJguA2BK2BcYJQeJFhU4oSnfQd/sKVScepYSG8HwibxMctO9CZN2BN66/KABfzhO00D18oGNZmcpNZX4y+1wlJUMtj0pQ4jcYIc+IGWO0/VpqLSmqfhwwImpkV0PahpL+sMWwWi9VX/6x4ZQbmU3sed83K/J2SDx4MMjwpajRBnTKVzVYxrcaQloBmcontx/PtYeJfFVuVEJnCtVuy7RVO9ES/SSfPrtN3GbTHYBxVMxk/PvvbXAyeo3O6LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWpvI/5JFC1Vb7Ha08MYG6lv+wygiJeFN5PLQ4NPg5A=;
 b=Zty2EH2wT5P2t1NGE3YpUfewqAVhbI+AQuQgzTh1JSNZ4yqx+fWdw1OjtiLtgjJZzb9WtAFfFUU48jsQFmwj5ifrzSJ6atUtZhjohQxK4OiOt5OYJcrvJ4Vw1fNWyIS4zs8KFC/pkASHpd3J+0ccU3LFE+Y72hg/c4FtUQ72Aas=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 00:23:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 00:23:27 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, hch@lst.de,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        himanshu.madhani@oracle.com
Subject: Re: [PATCH 0/2] block, scsi: Small improvements for
 blk_mq_alloc_queue() usage
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240524084829.2132555-1-john.g.garry@oracle.com> (John Garry's
	message of "Fri, 24 May 2024 08:48:27 +0000")
Organization: Oracle Corporation
Message-ID: <yq1frtyg791.fsf@ca-mkp.ca.oracle.com>
References: <20240524084829.2132555-1-john.g.garry@oracle.com>
Date: Thu, 30 May 2024 20:23:23 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0295.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4494:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab36cc0-12b1-4750-3ba9-08dc8107e455
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?7TlUjnTXDrrdybmxHE/kel22Aya47zo7lNlqrMw8lf7tUnfFaS2fHyo2XI47?=
 =?us-ascii?Q?zaB8g+/COfqwtYtjy7bRnWoSES+rqkA0eFRDGisk4hFBZFcDyd3kRPr9X9An?=
 =?us-ascii?Q?/jcm0vn3LJadySd01Wukj5T3AQDHklv/0iohqH2PI0GQKjgGYXcUvitnuv0m?=
 =?us-ascii?Q?c/8JjkWLuFwoF/q5nSaLjwyfFKrgDuRVpWJQQWK8Pe+dsDzo2746gfXEewfz?=
 =?us-ascii?Q?rSsfJf8ZHZgg1559/+G0sQRl1WLque62lX6ytOYrwe0MJNhIHfs7gkurhQze?=
 =?us-ascii?Q?Cejcel4B6K6/gPIPmCz+iQoX+kzFDJ+WqCmatIgrrkdkEDjvCwwuQHWPnfv7?=
 =?us-ascii?Q?olr7KsS9TiQphA/qkTSoGMF7oOdWImqxfzFS+SgqUy33Z545trHWu6nnYHOw?=
 =?us-ascii?Q?WZDLsRF16Dv56zBfM9bEy6wkHACzT81xDVfIm9cmCCgx9o9AHV0S2aVLaZV0?=
 =?us-ascii?Q?oYoM+pHGJXHDfOmv9NvJdx3AJ7LybDdo8032Ff94nf5PM/RuVM1dPxG5l1Q9?=
 =?us-ascii?Q?r8QIg1h1MXV+cbOhYvJsKhJbSQG4CJF1v3pIyG8NBn00LWrAdMp2yn+11Gn6?=
 =?us-ascii?Q?fvmxZb4XYY8/8op4r6u5VyAl+csC+C0IbZDViPTrEZJ5RT+U+6bV0PSgFlQ6?=
 =?us-ascii?Q?fHB5hGliHqBYBMGxMC6vOfkv4x+A5JjL3pLXDvnpPBy+jaYR3FZxVRWPKKCz?=
 =?us-ascii?Q?w3wGA9zWQEmEqwzEn83WdD9AYGvJWvuqVVTcGnNNzkQIQWeA5gMMRZgFrVkO?=
 =?us-ascii?Q?b7cMakWpOck2odRhj5xyGVn71yl9vIx4PUy3QPDCmkzi3M7DDUyGljBW/OPt?=
 =?us-ascii?Q?3cPkP9t0kZAdgyakoXh34BzcwWLWLpHBwL+KOBbEJENCot0CNeH9XRF42EpO?=
 =?us-ascii?Q?kZAo3A6igkYYqeBno0woo3PKYTRBpi77PhN1w/MgYCzPZcFTdwlV3aOksKd+?=
 =?us-ascii?Q?weKPhafjqro2H7rf1bd6zCEP3QVbvDhOQYiA3OxCreNZYVaZWn8amVq3aeHX?=
 =?us-ascii?Q?hRCGhaTMo9+vqPz98vBDrdIzRCUyV4b299WVfLOMgK8fHgNhudbyhsnMHlya?=
 =?us-ascii?Q?A8Q5eDw30MTeZf/ey3BByauSLfGf9sKX62wFeUg1Y+WGcquapnsrVznXBeQr?=
 =?us-ascii?Q?MyQtz3T6fH1lzbxgxUfOZCW1TLsxy6jfuBl8NIYth8VMtDY6bDjw4XyK6n+V?=
 =?us-ascii?Q?uPBlfnknMeOhWCt33Mtip7vvkj9aNNBV2L75Gut3+cppCcFsSjfe33Nw//YG?=
 =?us-ascii?Q?DMO1rbzYOfcBlvshJRErE7Vr0yfqRTdvqHPRIvc3Fw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?t9gPrzvvFra8DUZx+NcJsetE/eUmIAL6MDEQvlN/OiUdNZqNUnWJlqKL5Ep0?=
 =?us-ascii?Q?0WmwfBW+FqVg/QRI+hlnmPwQpYRMwT6xkw+sCfn063EZewZ8W6rVZmBdopvP?=
 =?us-ascii?Q?evQeZB/tbv/FhK8oi0bfGgvEMzQtNMpViopdX/j7F2aBMYGJ5IYyXK/6WD4w?=
 =?us-ascii?Q?hWB6OOcb3K/oAPOgJ1gkauJvERFvp+FydvFcvn9jMGDUXzhdk8EEUyoIl2tC?=
 =?us-ascii?Q?mED/DPpt29HlSVAIKJFaXHPgleALxoUmjzYLQs0f0Qlp3shF/OYRmMHZ2Ikk?=
 =?us-ascii?Q?/RGk2712bB0+oSopuCsLZ2GBZtdcULlZE41Ls0x8bf4K21Bmy9pHQTRAfOUb?=
 =?us-ascii?Q?WU9okz3Z0C7C/3pG5eFMQcP8E6U11wvxrgQ4tf34Aqz1s6NEfWAv8uBPMk5u?=
 =?us-ascii?Q?R8ehhSMKXicATBj2x6vEXgIWJESjoUhKbhuJOnXQkY/JW159QyCcmDutewlB?=
 =?us-ascii?Q?cA6Y8OYaNXZHVTKFNPpFVcsb+dNgg/7aR77Lz0bo9yzTa7jHDXgA4poQHaxr?=
 =?us-ascii?Q?FtsWVnv6wu/PH3ozU9WrhbjYmdt8v92Cg/GlQIgZzMO372ukihpvPdDl+Yo8?=
 =?us-ascii?Q?FjN1RZ9/apazSLhAfxI+md/hmAuONgalZzkzZu4DX7TmNvCfzCAAJ+zNNCMp?=
 =?us-ascii?Q?pRXesnxShIO3aifDQP6e6LBPikh2btzMCeoBHr8DyhzPHsQivTl2SdkS46yd?=
 =?us-ascii?Q?FOjdJeqcp3UIrcCFeB6PjjQHOytGv/Z75iw+/laHbGbU71sNmxSgwOyUwx5O?=
 =?us-ascii?Q?Bdzvo6Or5x7Cx2tmRGGqouwzcTnk/ZObroSIDEIqVpyQ6xhXxd86JyVozZ5P?=
 =?us-ascii?Q?FH5R69ay94yTWAwdxsVCD8dlXeKnkicVbDer65yvLpezOmPU33hfqpMeWYBf?=
 =?us-ascii?Q?w+qQq7OsPUuzUC547VlCGsSdbUF6zzljj9aqr0XWXwVlAx+BCBTfGllmbwET?=
 =?us-ascii?Q?Bn4yodYC2A/JOW6cBW/lT97JuIJKbzpCCI3zs+sK3JaSottI6uXZRrrGUXua?=
 =?us-ascii?Q?9bgcpC+fG6rFt6oKbvbUmkoBupX7JK0SdOEFOe0QnzmaTeSHkSFjGXbCtVJ4?=
 =?us-ascii?Q?CNzmxB/cvmIFtGACCEWm6P8S2jpE+6Y9qSOAESfNN6LXDayJKO1aM/99jKbd?=
 =?us-ascii?Q?oyGxONBcpxcma4LnQF+i8ejP3LJHHmEbPEXX4M/rA3GIE7bqMVvp+FIhkDx+?=
 =?us-ascii?Q?HLAh7fwfVDcy6Zi+H4OkL2JzTKptO1PzYmibH1oRn++TkiM4oXy5pKiXcnMe?=
 =?us-ascii?Q?+8qmWoho4molDSAFsYwsTGEVp3vFyIQDZzY+qkUNznYaUsErlZwulmpunkbV?=
 =?us-ascii?Q?YFEvQJ2n0jn/JIpjSaOPYKgl7nZmiGNl7WFE20t/+c6Y84+bD6H6gXlQLrcV?=
 =?us-ascii?Q?+kfiteYcjZWXGwB06j3DOcA52shUpb4HOwACRZcoHk3TebkoZb66qb+K8+3g?=
 =?us-ascii?Q?M2zEXcpQEMGdtSmPg4XdAdLkcjj+7cq8d4cZnrgAnUkxY4dtR06blBLkxKRu?=
 =?us-ascii?Q?Y2jamck+sms9lPE2kS0v4VDUlZeaYjK1nOUCmcaAlM6fql+sURM4i9S0/UZP?=
 =?us-ascii?Q?Flvxy5b5OHBJqP3tWIX88QB8CU4odp7cqyjAW6iFbJPLe6cufPHzDv+xT73i?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Amfxih3XrFasfBoh4oKa8Os6Cx7o47NNBt4tJTPzIjBHGgc7Btl4KMDZw2d1yGfPUZpkboJjLxkBHkqOIGsdFz3smIFdyXekq3+HJyNwpbi6p2PDymYK10rhHC14+s85BzrVfX8bWyAdgHPF+OpCZTMt206Y9aa5qIZqs/UT51grrp4AygpnTUwfXYzoDknKqucajLJCifyp2GXVIYqBxqpwQWvTyA+MP6arRCJj0xuv8YyJ0xVqQRXDRNh4oH3+rj8juuAMPDWjc4T9I3nPvBFXILdGXbLh8UF7H3deevMXePFRcZFibzgKxQ25hlUKEPfEMvd3S3D06Eds6Bd7gjslCFjwXU2Waxnh8YYpT1J+V9s13Ep7IyuWFlKJZ7a6/tQYwsGjlbf2gGl3fm7nCn+ONHAe5nMah3HLnTqrBTPUnTAQGmv5OgOLMh2sGDWn0lUrVRmoiVQk1oUxQo+3O6KxUdINi8yyJbIdEC0mTVFO1LIoseRx9d27cVfJtRs/rMX1zX94Nb7xU3qALQC5Q2rSUsDigHc00ISbeHnLOht3EBylJfIXy2H46tMkrXATRN4SEZj25sPhJTtKjyvF5CJzspVZ5WSL5tmGUbaiFeY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab36cc0-12b1-4750-3ba9-08dc8107e455
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 00:23:27.6347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKPPblgdwiFqpNSul1wXnSQorH41hBK0vxviuV3e6urn5GMaYBjy1iYhTOPqilFaCt29uFSecKh0rG3ptYbGkoB/nnE3LV8QLTKhjgTnF4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4494
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_17,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=865 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310001
X-Proofpoint-GUID: _uF2PfExSAOa-7bMqJBTTxkhx0_dWkQg
X-Proofpoint-ORIG-GUID: _uF2PfExSAOa-7bMqJBTTxkhx0_dWkQg


John,

> A couple of small improvements to not manually set q->queuedata.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
