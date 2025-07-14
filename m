Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92BF25D8E8;
	Mon, 14 Jul 2025 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752513007; cv=fail; b=ZDkVd1rP0fVanD9KQSk5aFV+aR77Gb/W/k2nlCysxpbSBsexJh+MmzeAcAVYQeeN9ZTBGzxYzWIRwQV/JP3tlJxqixNU7NVdCJ6tja9MC5h/JPLUSR0c8flR1bSi7cWfrOA0WGUsIdZq2oGEB5NqRV4T63mm8XovgkW29MmAezk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752513007; c=relaxed/simple;
	bh=bPWD8T2aLvFjqFC48me4sZsXeysW9aol7u4odVAPtHA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=D42VkuEhHZxCi5qHRklrEKgyHlm7TGo2vxGMmSwpBEvq3pIxuZrd0SVnRJGCEB/tPAydDKsupTbjliezwHRfGLN9ExSyZTj255HV4QMWdb0X1aXCbTYqCjEksELmtrhQSEO7ydsGjhGo+ezF/rApi7CNQGzr5iSlPeWrLhTO+WY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CJ/Ue1/k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FlQCzIYF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CJ/Ue1/k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FlQCzIYF"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EH8eVd031151;
	Mon, 14 Jul 2025 17:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=quP0VDZNbWTchgZE+p
	rRNJRlqnJhVWJdJYs5w8JEz3Y=; b=CJ/Ue1/kfjM+lxnNt3lX0wnz2iDD2oVDLU
	djYZEjx431RHV8gOj7fUFYBmKqI38sH2TcKL7AhN13M80e7uGysPLECbbV0sVTXa
	fSkaFDwSl+OQeuMmSf1jXCxcQy2san8fHfs9g2Ek+38+2HKTRgmUzec1RgeL/VKJ
	IfwB+F+rMIKUTtA5bYrLMMAMAA7gRzWpyCO7uucdP7be15ymINlWY5nuPZ5mwmxD
	bB0rlvNwYVkz2tBfudSBS8Szw5i972hkQL2+gec28AGin/3kbBaoghCB5Gu4gOal
	I2UyS27GV2I8RWXk2Y8VW0+Eukg+WM0kLtzBcLqqdfuSOeKnwCog==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujr0vnyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:09:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGd0vV023974;
	Mon, 14 Jul 2025 17:09:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58t6rm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:09:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9NH6bVSqHFTJLUhED3OzlhII5/KT6PZioDgx5hYrL44agg6XI8SpB8R7QmBPkoW7uKigLs1Mzi4Jok4b2W1zoSeNZFD+DKWBRgstV0uhS33zcLiicpuwdg/hGtBoF2arQF9uqadnzFaigAOz7c+t3VUD97QXsZNBUbHMMbV+8blOh0rDhrpPY5Sw7CZRp9bbuQf5r1hZ16jy+ai8WBGBjZ689wGTySRpOJUT4gfRP+DEQ/MKAGTgIlQtLtNdMCgsvDRA0D1sn2swCxJtTg74kGcuWswfNheO5hA1XZ2lQkBmQzki2bk4ohcqeoDk+dtvXdncqrX4dVQpoH1gGPxqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quP0VDZNbWTchgZE+prRNJRlqnJhVWJdJYs5w8JEz3Y=;
 b=ll0bMvoYYlLu6qafcdxI1/mTTRMhVHtJwW6spLQyMM5K7/8dDXvjIrCUJBLx5x8M/JHyxZIZv3RqP/x7J06ad9S/i14kAYX08d/ai+IkQq5aq49v7ocRZfVP/Rh9rCqMxFqmsWLMBlgJ7MVjP6pkh1KOj7RhOtcCw+PbiueqoEU7/WNyTjj+n9bWYtrf5O+0AAJGtPEJFJTrM1BfBKBZ1rp9u9r0YH6pKvSK99G5Z+OLqmXzUxRl99xcz7289drbO1sFylI0XvkmJ5VZm30seKuC/j9fLU+vfP7pnfyzJ22+xw7wJMmKvi+UWUrMDdCfOsqIGlmuO/fizeEPiJoauA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quP0VDZNbWTchgZE+prRNJRlqnJhVWJdJYs5w8JEz3Y=;
 b=FlQCzIYF92oR7SnETwe5QfmjwJBcyIMB/xX0tNmoUhKfo4HQIn6boupG+iCZCIZUHXsojfg55HGjUlOMOZSksk/ErG7wYngWgr1Xu4Ym4gV4Fdy+gLHb3btmVEzcgxhJTk4Nrh/iklPeV2xxukqxC/EsF2Nr/uRPNtanb2x6uaw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6195.namprd10.prod.outlook.com (2603:10b6:208:3a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Mon, 14 Jul
 2025 17:09:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:09:25 +0000
To: Peter Griffin <peter.griffin@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzk@kernel.org>, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: exynos: call phy_notify_pmstate() from
 hibern8 callbacks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org>
	(Peter Griffin's message of "Thu, 03 Jul 2025 15:07:40 +0100")
Organization: Oracle Corporation
Message-ID: <yq11pqiaedd.fsf@ca-mkp.ca.oracle.com>
References: <20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org>
Date: Mon, 14 Jul 2025 13:09:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6195:EE_
X-MS-Office365-Filtering-Correlation-Id: e31e058a-2329-4ca8-ae12-08ddc2f92f74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fACrhMTYK2DDoIsrQKa7wFwlT/jWik3aJOhQtdqeZdeSgiDyW5iJI1w6UFOH?=
 =?us-ascii?Q?jwbRBHnXOEdBSHjtRNAlqh68WSckVZYDIllTeE0jkm11WzB81wOGhgNmP2w3?=
 =?us-ascii?Q?3JXBy7dfKRPbF+ueN2Rr03Egb0z2OaGBX0PQ3wX35JlvDfD+bwBOibK/xoXt?=
 =?us-ascii?Q?Xs/ipBcpsxx2wOOXEzRY65e8aCA1q9Hh48/0PLgBWZfTsRG7HiwOrmMyeSs9?=
 =?us-ascii?Q?ZNA7qoEBMU1DXbxSH9Dji82ggOh/4TiOtKgxxnbv+q4d4XE1FAfb/RVISaRq?=
 =?us-ascii?Q?LGJ/FqYJCiVmyhMzhfaZ84p5zBNqdtA721QK57o/mUzM+vhDt91LOE6QYpWg?=
 =?us-ascii?Q?2f4QrutP4Dazsy1cR5rI3WAYMkAK0CnD4q870Er1Bei5AOA6Re4l3dVAIT8C?=
 =?us-ascii?Q?fLZzWQRe+apczRGqFThWLfJunGrmHqnzAYIXFt111x4V/GQrU8Ln8wjvglXs?=
 =?us-ascii?Q?XGLyAg4581xwNDD78jqjOTEsmywuQBvK286O2FlHDQ37lMcKIqmYbAlYb+zd?=
 =?us-ascii?Q?V6559l100gUb64keZR3WlxIopjLmf1xvkYinFjnDK3yMPpfmDnSTiBKtUe0n?=
 =?us-ascii?Q?D/0G302lW9i2xpm9Yxk2OEw0mIOo30Tylpwww9LgMOj4xz55aGT6CBFGntzZ?=
 =?us-ascii?Q?IcIanqhLuH4x3TfMpAkvBHzJN7mpmaptDppZA2pwn6bEP1QJgWmEAKgIcem9?=
 =?us-ascii?Q?zvAAdAuR7h/ojtH/Bg5J6ELNIpQh8UyKOv2mNUOzYqSnYTppHlkiDskje7hx?=
 =?us-ascii?Q?G2j3xyNwCurjU5PyEIAo5LXaaAHxovDtZ+hWzsE1OHki4RKLbpYEGZQ/v8GQ?=
 =?us-ascii?Q?eJIxkCS4QxPLI/oogaARgv039PvNpcT3nlp2qvYzeZrAgtbcsyubJdNWAtb+?=
 =?us-ascii?Q?NBLyJKdwPBWUJRsh3l8dtk23g+o+FhExSw1SJ4z3A+16BnI+hToTulb2lcfo?=
 =?us-ascii?Q?l6R5gF9QXNCv09X/bRHJhWWm6sCGnlK4qO4Ue39mBBWoHVpTEbRfGd0B1/Ru?=
 =?us-ascii?Q?ChOFyLzIK72ZVAmCk2R1N62cfrqnimYBgU7tyIy4v3h0kqknCEsQ6EcjpDks?=
 =?us-ascii?Q?U+Vw2U6QV6APvpJZS51pm7WclttR7IiNSh0UWsN6N/DGprqK79MXyPTDie/O?=
 =?us-ascii?Q?ZOH3sL7kTT7oWHxbzWM4tXUgFUqoRThCe37Yk18twTEEEloVi9MXME0C/2Ku?=
 =?us-ascii?Q?/15VUWwdY2YaUdoF+TDxRPsW0M0lFbGaCWKddUmG+AaKfGV/keGVAvpn8sgZ?=
 =?us-ascii?Q?2nvpECJ/1YTGALMjGLCXUlbAa+jVIq/M/aM26aa9noJ4wU7LIYnmKDPTpnQ7?=
 =?us-ascii?Q?JtoKHZheFCmsaisRCiqz9vF5gNzwTu6T3/YpdhALmZ5pdObgsJ3clsOOXuT8?=
 =?us-ascii?Q?k8g8PPumVlEeLoG6vy/brYsrIlVoNbYenDIOg1jBvh07QnsVl0KR1piET73C?=
 =?us-ascii?Q?k6IzcIUX+8s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P9TX+iQKNSxEAqHy5OXwRk0WDzMJ6Sevn75ZpjzlOv2UVMbmdd1kI3sAgB8s?=
 =?us-ascii?Q?KnUseNcDJS5lTPGJwq15pT9WaOOWLBeWup6mMslezu92Hq8ZwyGDBSymzp//?=
 =?us-ascii?Q?XZRo9vz9TjUiMcor6pv9Sji2qDbyAMNt1zxqe34twbWpcT0LbL2I+m2uw0fq?=
 =?us-ascii?Q?daBb2f1bAH/PQW3sIg5LFqFDgK202Ky8yCAgk9MKCK9zcYSNiBaE2oBjk5bn?=
 =?us-ascii?Q?SyEXmNcia7XxINCwlIiv3Ia+t40BZs0EaS/6E6GneF4Dnflbpmr4zU5on4Fq?=
 =?us-ascii?Q?dF0H/8biGvu+8BuyP3kqbpudf0DYjGzdsDyS4wu+vdEkhoVz7lN9zJ8HFkqZ?=
 =?us-ascii?Q?9hug94pudhqSJDm+1tinyxxZTmC4LM1/LSoOOUQrnM7mKoLcHEBqHk2dD0Lo?=
 =?us-ascii?Q?R1TXVRHT7vLP/OCj7Q2QdeuemqbCcr7GAF20qlKoqGLVTuhVLmYNaEnEFKux?=
 =?us-ascii?Q?3zoVuLoqNpSDfPVc3d9xJx5hKzr4rlbCPUx4niONiOBIA3epBN2LX6TioTnJ?=
 =?us-ascii?Q?gS9Yu9SvnrQhTa0pHGmO8udNrxjJwoCVZjMkgU4+41vnETvb6hAr9Q5QRBnW?=
 =?us-ascii?Q?WcEEvhyAfvYnXyqVvW2jtIyTfV36WSNPYoYh0FtyfOnyJFQ2++A0G9bU+Cmu?=
 =?us-ascii?Q?Z9nDhoqoothlVqMOPJSOOJmLEd51vIAPEI28KqPK6T1NPzhXeZQq2ql9eUg/?=
 =?us-ascii?Q?CWxlBqPkQAq9BRCCYXvQbcxK4QbseGwdqSFmapuyss9+C33Vm88DYMvaCBmH?=
 =?us-ascii?Q?WfcPGlj+v4nhtNy+gw19oVcBHCkW4sKZWofUmD9Jaw3FqeDfFcVIoYUDTzXb?=
 =?us-ascii?Q?U2CtqwohQQOevuyLtDwsaXgIkrrO+ZP/PYFbYWQozOomRutTipR1568cmrj3?=
 =?us-ascii?Q?4FRgyHMqPVIkW1q4QyFIOzGwVO3nt+l4RRXoFrRfeO26g96UK2qy8tl0xlmq?=
 =?us-ascii?Q?IfGC3HDkehYiUX6UW7SahtNAmhBHH68xQuECCUfFWV2hOzALUke4hd4nCYeS?=
 =?us-ascii?Q?Pb7DKSJr+veYrSRSeKDm1tXwMWPhSlllY6qvwnwXex1EL5PuZok+ibSxIomY?=
 =?us-ascii?Q?Sw2Uu0CgfEQ6K/KKPo0Dn9AVkegVgfaFs7jWlWv4DWAC4foMuHRPR9fyzaFQ?=
 =?us-ascii?Q?lBVv1VjDATAEop0Z5l8i12gZvxeymq/AhGhaTRLDwE/djxZGNSg5hQtee+4+?=
 =?us-ascii?Q?9pm3ffUi7KHTYpHNO03aJ9oZXgWfUqf2+LlIS7WtnuxuvI/7AM7wrJ9lQIcn?=
 =?us-ascii?Q?lHfTWJi0Zl+cp3meNnKSMl9t6EvwN2/5mvOY+2tZYTgLeaHJssRO3GXyEUC4?=
 =?us-ascii?Q?L11NxA7lH84yBQynZlco/qquEFcn/HCmTsbVLa3wEevmik1dpQWx6uJ2NcW6?=
 =?us-ascii?Q?9YYVdzEIpSb96C4pwdQ6339hXvzKwhja9FXGk2/fWpIG6rlpy5107pSKUm3S?=
 =?us-ascii?Q?VfQvQc6AZPnwrnxmjp5/4kfRSpyOsRV7pQhOSMBcEnZm46Gl21BWrGrKGfKr?=
 =?us-ascii?Q?FVwV7sW+Tji77IZfzSsYAYyCXwogy/upcxUZugE//NK5mVGVSCa2TiL38DWA?=
 =?us-ascii?Q?TdvafnTOrLKa267U1zxa9qiwye/dWHgbsSM3LN+vMmFWwfmS7zl+y+j+KK0+?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dLfNGWVoicS6OgeP4e1D24fHrbDnioc6YToOTYgZKSMTAvLuqGIhkdKe9Hc+ycnucJiOX300fHTW6it8xpt2EFkzdhSDk1SseHKTN6F3ABceBlZvkIvpAQxNrVhy6EiyAnLHyqUArwW0oMyDZ8kvM5u7yLOp92oIZ7DQDeDoc1TbnNSGQDlhebmX07F9T0jkI1iUeFIu5yRQK1hFPOR7a+1+3mo1jL0QJib1OSnkc9GEjSzfHb4JM3zQG/qAg8NfohZ4AlC0DV7GzpDkLU7v+C5pds2J8QRoGkxjEtV17Yi1eoe1LdNcciVR01aE9ounDNet+KNKROPt8+dZ3fQLhKqQQ+DhZyb4J6S7D7MMlMd1Gk5Sw2cgjjlHxKA8GR1u0TIxy9nns+AdOpIx+ZkZrbn//6mvMMVRICQjDWAXAcAoycba4oni/DjY44ST4zGJ7BOZHLlCwCyL+pEtIny7TYTLMiq+tdyKbhiiF6srdisqD2LpLKlK+3xnUZg2mZIWVxPlDzyh/+PE01R48UsBomxjD14384AAXdgsm+UAMU6Dfk3hvXfBjxtdgOyIid0EG5Wmx7w9k69nzbZwmjzwOpNwXzZlR2x8JDEty7QpxJA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31e058a-2329-4ca8-ae12-08ddc2f92f74
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:09:25.7031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jolCuavoikH0YtlWPcSsmhERXEyOrH5dqc0ghZWS7n0Z1RSN3i9uxziIV0LC//zJn2ZLotllsb5aeYi27hFrpfJas0jbpcoH9VvLAvBiGvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=848 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140107
X-Authority-Analysis: v=2.4 cv=d9T1yQjE c=1 sm=1 tr=0 ts=687539ca b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9
X-Proofpoint-ORIG-GUID: UohSszkMTvI5MAkY_bzTeGgVYBZwOuQx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwNiBTYWx0ZWRfXyy10RHP0ZzIZ GIaJtf/J4yk8LpDQRHviiKx974wNkBEDVkKR0iw8rycDm8EUrWGHzd2GgJaPSzDCaVmv3k/2QYY 9FRdevZYflcPbvFraJC+mOS19moFZcUd6cF4fH4uus/RQkJP0NvOttU7cwCB9Bw1sm6BKEQmdVc
 2WlcV4p1y+WXxA6fD8ofHGIeKT97vL+OJfsYXx9KJwFxYq7B7NZhZK4bhWMx1+WufTYVMe2xZlk akFrRm8TskTt4KBftDU/jduFlE24Hact5x4zWhnIlawemPrrfkgAjCdATRed20++Wpr3h/jKJ5t Jq6D6Sahls7baaM6Bm0qyRmq/HJIANSY8bAwzDW5vBurq3UrHB+jogYlnX+ourQIGwtuMxYhdy0
 Q4Y/0aST+5Bx4JCN1f52+o9puOncidfT7vEYWQ0c0B1URIq+5FP6JoyUioPExYlaPyomDI5N
X-Proofpoint-GUID: UohSszkMTvI5MAkY_bzTeGgVYBZwOuQx


Peter,

> Notify the ufs phy of the hibern8 link state so that it can program the
> appropriate values.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
