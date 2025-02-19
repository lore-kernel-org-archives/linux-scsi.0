Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A690233E1;
	Wed, 19 Feb 2025 01:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739930062; cv=fail; b=SxAo8rILmLTfEf00kb/4yCvKUY0T1V5y2r+C1hPeEirMSPOe0kClTVEeRPPGMc+Zu1t36NNNOUM/zywxvIhY8z9Zia0PsPUJduI05KcDh9WUEVDwRhzeecBGJgdix1VGuZx7srOKIrzoRS2sxj40LorryEUeccFbK57vtdfIhTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739930062; c=relaxed/simple;
	bh=p6N3IRdKDVsvbJy/JZ1cHGVpGwO6DsJ5M+BU+WmUQhQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=E06ljlXUcp/iwHMQQCy5OYo1XZssvr7vY85M98OJD+F7G9AG4LdLD/qnVDbwD2uEmk+0Bm7aW8UDSUxOUt03TwWd0s3GmpzXE8TwY8cbaVhAqD7b4lX8DUi6RrunJIU5KDklVj0G7k7OU5Tqtu4+cqT8h5UWnFjEXhMOYqtOEmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QBi0e+XW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vIgWHYVn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QBi0e+XW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vIgWHYVn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMg7vF007173;
	Wed, 19 Feb 2025 01:53:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=6tKuXyJC6XPnNG/YM6
	1JSqCj2xG6FM/qPjhe8h5vcJ8=; b=QBi0e+XWKJv5zSxr/ItB8sJHVy2YVbrfvc
	/O3A/phklek9aW4C8uUw/eAA9p5VP7S6zG2HLgnPaYMqrP6tRCyLx6LQmI7R5VfD
	6/sxersSeoi6KZaGSpiXvDcLRPGE1SguHews0qfg2Bp8V3IclEBy5MFezxTT7S56
	GdZAs0p18KUNPHkVOgBe0ua0T7bZPmQazcLCQN+oK3zljTJ0adbdr4l7XVV5GPPq
	9gDhN0tZzK5/d/5mT0By/PkHNS9k3KHsthy1Gtl+DPO/DYmRWU6150jXqd7hUsS8
	KLItfSwCrn/ouSD7rTIQ+enDeAR3rcZPAA0b5DZfIIlGESfF6sMQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00n0m3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:53:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51INMU4O025214;
	Wed, 19 Feb 2025 01:53:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w08vuw83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:53:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jm3aQowN2Q6iOmbiQUx/zCRwOM9zTNSIX8IkxJ/z2HOOdSmeiXk3PUoFo8+0KwDWS/jpumv0u116lfDgceTeViB9y+s7DZFZ5aABXXACbqOI+DWSsZ5HOAMi1HNjJhgmbXIJlhplutLKOKd67LitM9fvQD1xwsCPbNKf1dNs1ySqeJ70/e2Q2B8ggViz0bYU6La2zK0QzOz2K/sWaCmb4XFK884S7ieKkgGZ1CzdOsnPP0/oX2Wpk7CqgHhMC/pAld9m80SRK2w4Ec7hkLqLNREGhNsuvTXLBA11EpNVsD6100FP1opKozB5t+M8iah+KkBWAri5H+8JON8bWYcU3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tKuXyJC6XPnNG/YM61JSqCj2xG6FM/qPjhe8h5vcJ8=;
 b=FSngUt4Co9+Kd6cf5xYjas4VXvcOMgj4IPklGNsAFBwBkpVXEBL5Ce69FZN/UZp3UFOH3FDuYP4M6UDJV0fpt00tD99X1Jx2QlbUjaA3xMQOC7Yc1FvDCcRrYkO0NQTOuMejsTK4ei6kZ3+lrqgHsE7oLLWe/JUVBv63UeZV6ZS42i+IioWs1mFa8DwHOkToNVUUS/0T4LRSobDVETptRo1GoRcPQpH/4PEeiQXXxwzMZQo4NQJbZtfLflzcvqJvzfylNGBRaCfta0fSyAGyrkkva6GYjMFon9YReo81FRETxxC2WnzecF6/5g7WEGioo2WVl02n4fHlcJWDfh1QZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tKuXyJC6XPnNG/YM61JSqCj2xG6FM/qPjhe8h5vcJ8=;
 b=vIgWHYVnDxPyUXo3evoK+TtvHXZ7u+sKaiTmEDW3/0Zp0V0z7/DXjzBMHvUjYTtHTOXFnbcYDtnNGND18TToIAa8EdndX+2in7pdnRTLlWbFnoUabEv+aD7YuqYXHIA7N21MlVTppSaKMF0Sx8u3keI12hemXCIMZCDiMzq6q2s=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5541.namprd10.prod.outlook.com (2603:10b6:806:20e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 01:53:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 01:53:44 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org, Kees Cook
 <kees@kernel.org>,
        David Laight <david.laight.linux@gmail.com>,
        Bart Van
 Assche <bvanassche@acm.org>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: hpsa: Remove deprecated and unnecessary strncpy()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250214114302.86001-2-thorsten.blum@linux.dev> (Thorsten Blum's
	message of "Fri, 14 Feb 2025 12:43:02 +0100")
Organization: Oracle Corporation
Message-ID: <yq1a5aiog3o.fsf@ca-mkp.ca.oracle.com>
References: <20250214114302.86001-2-thorsten.blum@linux.dev>
Date: Tue, 18 Feb 2025 20:53:41 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0101.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::42) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5541:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c1fd15c-717c-4d06-12a3-08dd50883df5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V5LIVpxAOGdbk4PQtl292OBg+4v0E7E8Vi/TYwBtJa1rvbbDlFfSkav8xGGE?=
 =?us-ascii?Q?BJEfMg6Z0UGnpytp/ceDJxN47fxfCJvb7EfR8WmY/gdc5il1s0jXmDcMrqnk?=
 =?us-ascii?Q?tAwF/VOrD6SL6v5jEqy/QDi7nijk3KtVZp+7cqQX/nBlfTiDRoMyRmMh0eOY?=
 =?us-ascii?Q?AeUPCfW7PUvmBe/MwUH9/T1yMVMt0OKqpSMx+mc2dp+CTBTVkIbxRu1fFgHz?=
 =?us-ascii?Q?iHpbcwMgJRzK0bm2VNXS2lhAKijShOIcKWegZNVmaTLxZ0X4VhbSKTGjEBwE?=
 =?us-ascii?Q?eU98N0DkZJaCqnx9yybyta+TtVrfDXVt8kgq6Iux8Fh6tQHQWjkHwE+i0lGk?=
 =?us-ascii?Q?GB24g7cdSDlHIAZw27V1aELH20XXDzeqGXTo/C5NpIge7P+Jq5bLY8EfmMxE?=
 =?us-ascii?Q?gCNtWWxWUJGCWC1ZW8ayhtXM6XVCh4VqF8By0IQ84aUTvydaKCpHRU+xhKlV?=
 =?us-ascii?Q?2WL+yQHmQSswnB84sOibY/Qx/p5SCuNj111UM5Q22EvTFjZT88PEB34uWiRp?=
 =?us-ascii?Q?S7+pORFvceq75Tre1f68nD8IdqNKVxB5JeuYi7g+kjMpgh7oKONyJrznkZYP?=
 =?us-ascii?Q?JfD7ZgyW9TS1P0q45NcLuNCj9Vgv7DVUlme0K6RbZKM+h9BR5/2Gaync9yw+?=
 =?us-ascii?Q?VT/poY6FcY36PuO43BtrVy2nfjjYq/+VjtnBrJvuahJ/GCtSVOeyNBanSMQZ?=
 =?us-ascii?Q?I1fWYgaygqEQjs2JqlIGlY5Lfhg+l/aoM8zxBmPfl0dF+4dPuBwYdbdvwaVf?=
 =?us-ascii?Q?vfHJtt8iAW9urhBI4riWVz8iusEwT1wuw18E3lwkWL4RN8gpT1ycZcvEhdZa?=
 =?us-ascii?Q?GBQefktyxMUamOSAdy/2OxGC+CW5I50L9YBQoISVR8HXP6Rxw8l/n69zbvOV?=
 =?us-ascii?Q?ooCvHOr8tSOLUQgY7iLDXePdGDVqInq6S5jWuepjXYK+6+zn8PUWJwdUPzkG?=
 =?us-ascii?Q?xNkQjOg5DKHUtxp70pa7VrVBbgMnat7EwPS6xKkrakn0OYq0eBixkpO0Zs7N?=
 =?us-ascii?Q?fXvaLBXp6IV1VMdXv5z6uiWQpgHuxgEUA1yvaYoQFDY+OHZZ1GUi6Nm7yilV?=
 =?us-ascii?Q?QMWxxfcoNTETxNkgubR+1IsVbAJ21GG2BnkaFS/TDN+Eu/eCe3VfgRIyzX+H?=
 =?us-ascii?Q?Io9h2g0A2Ec9k4LxTSh6p6lY5WprgDGT3NCrRo+dtitXJncHy8Q2LUnS1Bzq?=
 =?us-ascii?Q?UzWB+29sgjl/12FF+ywpW/8apmihgf3OHUyZnl/35RqOkp5c8JMC4kRiLJzB?=
 =?us-ascii?Q?0kJoTUuFwniuDJfkIjROHhkP3/zxjHpmjX36CViBnwO8ARd1VfpEhU11Sz2y?=
 =?us-ascii?Q?BwqYlTKvYQo7Xt97EQ1uNXg/K1tv9BX6SiN02zCrSNy8bHS6jBD9KyG0anFQ?=
 =?us-ascii?Q?uKkiashBvYU3mBP9qtxbhQUH7Z6E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nflV82bTJSDXv3mHcA6o8l+EzhkGlYGhbXtVPpphNLuEXxpm3ZMV59/PyIf5?=
 =?us-ascii?Q?PhmMRYkhZseIndnvAx2UXT9m6322qHCicyK6r6Nej5OJZCzPY/skkxfIgpep?=
 =?us-ascii?Q?GjrI9DW+1r00Syl0g2QZUBgihrMfIT+ibAPUuuj7fZTthTPC7mdWJ8Cdy72X?=
 =?us-ascii?Q?/u+eigkqI9EKEkTiDC7XI10nl2ZJYXyRbmBD8iMBGky2OB6B5/AWjAyCdmdz?=
 =?us-ascii?Q?r5pBUG3d9j97fCQ9SSyzSexMI7YTGMmn5POY8gs7AZz/6UkHR8Rbg5FR2w2o?=
 =?us-ascii?Q?CRtLSjeR/ErYTTsg0ydbnO2K2N2qpYtNADGjc18PtUbga/Qtzh60UBkZZ9Ye?=
 =?us-ascii?Q?WcF1viIc1gjGJvd7QScLAjfSZ+RjmlPHg7+GBNFFpmvZwZMuyeqUxtR+UQIu?=
 =?us-ascii?Q?5l2z344upzSzJ3E7BzTphOgzrFvM5oH8j3u47P0q++U1OFLP/+yJG2DyiPpl?=
 =?us-ascii?Q?R4E5geIj54gpJr8eEvkHZFbWgGbjZoo0z3lh/t7prFaAW3g3SqWHRWJHgZlm?=
 =?us-ascii?Q?Y+SXx2FJgqZmsZFaSuYKs5kqO8c3CP2h51iPCrso3neQVVWjZXl9TiIsRcsG?=
 =?us-ascii?Q?j+oAO2eGustrUaslIQZWd7/0RmKrfjVjiVKaK+TxJLqSuEWv4ySQYrMOWuK7?=
 =?us-ascii?Q?PlDxTiuQWD0tvxQiDasSnufu4MemKeJaE7t8xjQolyG/wmPv0U8Fa45Vvs73?=
 =?us-ascii?Q?q+kuYO8Tk35ZqX59ON8M0TqAmvoANxafa20k/aywR4dbmIkPO1xcis7uKX5Z?=
 =?us-ascii?Q?J3xiUJlouvNKpd+glikv/qDAsp2bbcp4Q1msU8i/z6dbgtmEZC2Qp5Z4qLE7?=
 =?us-ascii?Q?Pfp8sxwfz9jGosrEiSOuFczhlRa/o5RfiKAMqbehdez4JWEOua7fcP9S3ATo?=
 =?us-ascii?Q?kWfQUF06rVbe3gLaddydxQY3wqzSmztXFCsFHHxji6wQIOzw1IDrH/xTeDan?=
 =?us-ascii?Q?qoJYj4Y/TLl2Q6t5zObhSSmj5F1rCxXX8XwzCzPdrbZRMb29Tta7U7/1Fozk?=
 =?us-ascii?Q?ZJ50lUlhcW5qR5XwEb11mz8rrLlvDOOoU89zikvfW6YR10D0D1qly3aIm1m5?=
 =?us-ascii?Q?rF+ezv8di4qLZSVDiwY0VSj/zd0BOa5lj7yNYAIIDzf8wR1CZnr0qTJgh+wg?=
 =?us-ascii?Q?H8QcH/GGj64H0Zf/Uq4ygcRsWuLVS9z290eU4aj8ZnZ2jGn3O2GUy/hmxP5c?=
 =?us-ascii?Q?Zg79RlfdV13s1kvkUGrFOyRkFnrYo6ZTmzyxx64cSXCeExVvh3dToJkiTU5m?=
 =?us-ascii?Q?ZXNVNzPCrTWiwLmouNcBM8so44qU3RtCVfSNij9X++LTjHReMaDvBcbnoH9+?=
 =?us-ascii?Q?k5DpPQJRvXbL7tQmhMH7uHwxe5CD6FmfhALA7qUy1mqG3NaJajTqFncS0aJe?=
 =?us-ascii?Q?1kvh1N+uH2vG1YPRJsgPm1gvUhe1McrFgRdcB9jGzKZXZJIp22WLV6Us6tjW?=
 =?us-ascii?Q?m0VJuZxC+qgs6JHoidPCF6TFMt6tQG3FRfGvSclbfaapTKyCkhfAoalhmLQe?=
 =?us-ascii?Q?+QtKW3jAgV3nix6MQ9iRnkMovgdEGUkUP3vp7qKqrOazCEVIf4dOxb8Gu0WI?=
 =?us-ascii?Q?BSG+NQTWknW5Q2oMezitn4zD1imXsDYCcqRlawJ0asfN2OnUnvowsItFPRSV?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vRHTxj0vprL84tEsG792jWB5WWOFoRD30bh9z6fTPdX0guw2qXT866d9VuJ5ob2KtmGjK1PG8vMHgcNbZI9J8YYwUp9xBFeUSYvFXE5cPl50jKl73bzskBQ3aN4w1KjIxkyo9VmOIpzQ4Eck66Vo94vyvN6i0+SGt/T3iWlufGF7FnVklK6IeA821W254GYmB50Zk42Yt748sN0oEtCS77WnnqlxLShIxGeWIoNBcO2CsLxsNOCZKu9VSxaUdgDilQv307ZanivTD9sMwOgrK58JgnYGfWNzaMHpny+85W5MBvS0vkx6P04Dlku6CtaM5bewFvHXrmQtHYud1YFSS2xfApILaAHVNdSJX98xy6OGDO7lKZ1HkuwprGZHv60mcJcFtSVXgwmE2au7xFexFc3O+NIBXE2988lltCwf3EXasoyCDA6BPnlWE5bXvwmaXcE4aLs81dK7jym5tRVZtYA4UoYmtnMGXRPdrZBO9ZgeiTEU4qWmK785smv4MsrQcp3jF62epsSGFNgBSl3C0nZDoRuH8YpAf8S4p87wWZgcXd1quhvUtFrZDF2mYey1xYDnXNju11vpbaiwJfVsaPtGOIpc6gBUTEchHQLaoG0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1fd15c-717c-4d06-12a3-08dd50883df5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 01:53:44.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nW1I7VLrAutIQjOnggUxK3H+l4C9pAKjR4drlAhLHhbppzOzIQWSsoTjU/Fo9PC+hMTvjG5kW0aag4ty26Ie/FpMZQ45VX13tC2nMQIwqA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5541
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_01,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=898 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190013
X-Proofpoint-ORIG-GUID: LuopwFNTHbNNHxzyw74DMk5TMzglGXnz
X-Proofpoint-GUID: LuopwFNTHbNNHxzyw74DMk5TMzglGXnz


Thorsten,

> While replacing strncpy() with strscpy(), Bart Van Assche pointed out
> that the code occurs inside sysfs write callbacks, which already uses
> NUL-terminated strings. This allows the string to be passed directly to
> sscanf() without requiring a temporary copy.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
