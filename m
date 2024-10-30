Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013021.outbound.protection.outlook.com [40.107.44.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858CE28F7
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 09:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281077; cv=fail; b=V7Bu1uqu5vJ782/xi8bF5xE6PhVObi5RUXsnyWvZV0i+aoEXcX1ZgPuEeN+o2hWHGHblzQyV7LKKKQ06nA6+l17effYrPIhrdnTjLSes74aWrwmtYOsrMahNGDFILopJ6FpyoM+9TJeSwLuBEGmUAld2mwSFSUdWjamMbt7ZofQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281077; c=relaxed/simple;
	bh=NyzVSQqfAOqwH2oLLcB9ABhkuepkQGs9VK3C3ohN82E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oveuvTmReimqP96MbJtIZc9Jt4PVHuHgt8J0AuSrvGbfBdDBMZ4NG1gF/o3nrlvh4GNBqsTAw40EFhrppiffPDqvdHBTTYrjDk9MLEZPTEbJbQPH2w4yXYyvAhMqBgHIU1bx43bm0U+vESHp6jkVS6rcYJmYx+HnkheLpl6GHao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=mBUMHCTM; arc=fail smtp.client-ip=40.107.44.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="mBUMHCTM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQSa+FFnOMmOXmGjBhOmR8S2nr4ciCrO7NPynUzqIzsBwcD/k3yCieXAgcqF9htXfSsPXAQyluH1VDwZtaDZX5ZwhOxk25OP1hfHyh2ItS8q9QFHoBEfwzeRitkXi6Y4kMAPw/vKtSZ9Q8wgA/ehEw8Dr2crh2yVDPUnNInImUDIMMbF1FR2qTyTZacziKsLvw0h975THc+jPqIn8eJ6Vi2bLcSBoLezAajn8vV+LYXfhghKzwlPNvwNnkKCMRtlogX8ykWQaf98lVhq7uN4I8prECLWVQEn/1Qb/N6tzW9QF8njEl7RPaFRmtw+1yjYchUB8lXoDWbtUbwkNjLM7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NyzVSQqfAOqwH2oLLcB9ABhkuepkQGs9VK3C3ohN82E=;
 b=fhTieW4vzvlzEpw1i0NqkYl86wZvf7ZFexnB5p5JyQQ0wPjMzwewzFVlHGGqJYUoboX2cWnHXnQtzZ1FRfNFSQ/uB8wxg7KVggav4iO8/17wHbshbOoR+12EKBZA8bXt+6OJFH4w1N78l2AP4br/LNyTsgARI8swc8FryDCzzTK0eMtDH+43WoJe1dcKn2+TzZdMGUcjtkQU6jWGsEMbsoXLuS3v2Znk+CEdJKklMvUSmL60fjJXVDznSOf0/9fDXo/RE5FjyE5mC1N3Igm6TOmaN3SDjNE9jSmGnbmjoPqXU5oCYD/1RCLy3m+svh6CCI3AIv22hb3auyYyPyJ23w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyzVSQqfAOqwH2oLLcB9ABhkuepkQGs9VK3C3ohN82E=;
 b=mBUMHCTMGkvy8FSplqisHkh5nNFQOLUiIVdn/3OVSKXveU2Fr8LnCNm9EWk+sdGQhwKMdH9bhkqOsu/VwzdQ3UuSi2XuHd5APL0580qHjjjURdmbeYcMyKgmKqzP8zf7B6LO0Bf+XsWt09ZJVHtYzsGaWItxH4AhbcfYb9OXEOsyZ/VEDf45+lwDk+51A466isDwUsJDr2yu3ky101M8Sl44JjPHuwPdh0uF6fp1wPMXT6oddpw1JYxbVOT6EYYjIAouFgn3araeKcexacnXdv7pa2WictgS9C9wAcwkzEcn2h7xl4QFqko/In9GutggCFoL5ENsMQfnMq+lxKTIcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEZPR06MB7057.apcprd06.prod.outlook.com (2603:1096:101:1f0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.11; Wed, 30 Oct
 2024 09:37:50 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8114.011; Wed, 30 Oct 2024
 09:37:50 +0000
From: Huan Tang <tanghuan@vivo.com>
To: beanhuo@micron.com
Cc: huobean@gmail.com,
	bvanassche@acm.org,
	cang@qti.qualcomm.com,
	linux-scsi@vger.kernel.org,
	opensource.kernel@vivo.com,
	richardp@quicinc.com,
	tanghuan@vivo.com,
	luhongfei@vivo.com
Subject: RE: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Date: Wed, 30 Oct 2024 17:37:43 +0800
Message-Id: <20241030093743.659-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <SA6PR08MB101639506856CD749E433360FDB4B2@SA6PR08MB10163.namprd08.prod.outlook.com>
References: <SA6PR08MB101639506856CD749E433360FDB4B2@SA6PR08MB10163.namprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEZPR06MB7057:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e56542d-2bd9-45c7-c19b-08dcf8c684ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3t2CfXQ+xJmJQa4mWITYJhfGxY+XIgQIJP+qwpid+Yc65qbxmkU/Ta3E+zhV?=
 =?us-ascii?Q?l4F3USuGq3Ube2FJyh3ChFfLVxkmD2phOaltwA+40/nqvn7pQHbS+CRmsMNn?=
 =?us-ascii?Q?lpnwlAxf1+dfwxeU69zWQf47POF/eUNUpR4WJzcoG1cSLymSY0VLpDloYFQw?=
 =?us-ascii?Q?lQPcmkKYqSyuYHJYVSlPTiMFKEiNyfrn1oXELPLduWmbA/SkRbOFmHSvywxE?=
 =?us-ascii?Q?AANZAXNmhMw3mW3f+K+dKvmJJtmm7JYJNi0r42JjDmXcQHAwFnw3rP08Fiik?=
 =?us-ascii?Q?FB2tDrUfNUo4pkmGi6XT4V4Aj2fdgk9lWEOvu1K/dUypG9Y/i2yAXUD7DL4Q?=
 =?us-ascii?Q?R51zeXz7zt+RlZxIlZ8He1aSHoel0l6Jrs8VZzxgDC78Jw5SUNYB7l5ptN2G?=
 =?us-ascii?Q?r4MGv4PEo35z4PWzJ66ExCOWtppmHwEMOtgut/BHpmDAouVw8X5hxuOdNqmO?=
 =?us-ascii?Q?tQ1/W+//R0kMsdHXSaPLre1WFnmY9txU+8zKCjCgHR1wT3hyINTk1QrHnJnU?=
 =?us-ascii?Q?+sD2NVekK/+0o0L2+WbFqXZzRrc4xhoYWdOilsLOmPKHWNUUsgyOExv2kGV1?=
 =?us-ascii?Q?fXmdlW8By6FsrJN7zDS6pwjF7Men3GZjPlk7I8ZaKOwSy6zhStswfpKuk4j8?=
 =?us-ascii?Q?j7VKsi/z9pLWs0jADc0xEzLTuibT6kSX+/sEr329Bg7seiLWvy9l9iNw5ZSf?=
 =?us-ascii?Q?D9iCgwsKJ9V6SkDnRVVtYNEXviaufgE6hPP0zF2bYumn+c0LwjfVKgpXkMBU?=
 =?us-ascii?Q?MvzvMqAFsanubHmg9Ub/TLkc31n4DWEv7KLnwDhhFyfPW3vt2lMl/8d3S488?=
 =?us-ascii?Q?VVwJOOI3WMP5qbKN2M0x8SCafa4ycGTOUo4+MR4JZLEawJuK8TVXyslO+y6W?=
 =?us-ascii?Q?9xuJkanwlF/iCwBcHRR5n/C4BJGipF/17Cg75BFl2aeNwOAGsaT7Plh2qXN6?=
 =?us-ascii?Q?VDNSl7PRImBCHYn8ZJ2Mik/5+cto795bokBTR8jMYLWaO/cERlLZn/Ksq6FG?=
 =?us-ascii?Q?u0Z7eyjyNav/zu3tca7Z0IhGJ9UGMim96q5/1NaSkhC/sXP6/i5fOtxhPYtE?=
 =?us-ascii?Q?axHibs42wX3RIoxuPU7gLLaDruDrzsoOMMxkF0RBI/h9czxoCgcTZHOwnlxQ?=
 =?us-ascii?Q?p4cksRv3PTKivoYbqbiHN5Xvr/oeo544KFGIfBGh0Yx4Q4aa/nww87e9fA1f?=
 =?us-ascii?Q?SlWK+jKOk9zXgLpYpTU9RPcl0Dxi+tClF27Mh04y4BzJdAleIZQfh2MtrKx6?=
 =?us-ascii?Q?xoWpRXdAU/OiP5p87acOXkSLLaEjRzsAJBxNLs4FrmsS9ZLNmubda8Xsppc3?=
 =?us-ascii?Q?OjyUzv8pCQuMW3SHxldgPEf4VZZADACnYhoN2rfk6pcHUlTO1vWPpbxbIcr9?=
 =?us-ascii?Q?1Vkp5j4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xz5oCWLMtBZVzxhKYqNSl/RPH6nJSnpSf9xah75nMT8cEyEA/MCl2y1SfO+v?=
 =?us-ascii?Q?N96gEgZpRQyNMB6fy1nnh0zlDCQMxL3HwBNyXQ2WfR/W8IFkUoKjFtygy9C8?=
 =?us-ascii?Q?NDUZEdAOgiI/bnb/gdDpsttImu1ZC+QXVpV/vyvXdJNeT4zWE8PyfpPlsAIv?=
 =?us-ascii?Q?f7/emh4zoTMmDs9+8Rs7+ZufU0/WohNLVYrmmr7QdvvYQwf0SpDNdhrM4YwM?=
 =?us-ascii?Q?F2aw81b4yCeubDGPZksA7Z4E/hAqCcH+xEmXIpzC23eiMGvzHE8hnd3A+nrP?=
 =?us-ascii?Q?+rYA7gopw5F4WYEDmIVOe+e2AuKGv1zRTms1NluYTJTDcHm1CkveQrBwahGt?=
 =?us-ascii?Q?KFLTKBzs6p+Iy68KEetqVZV8QLZ2t5u3zFC2f6mrraiGIA8Yp4AR6hcEZO2E?=
 =?us-ascii?Q?3J0n4bkOrIVFTNRzCcKQm+LfYSy3y3R2gGCtrRzYXdebWYz0nmMeMiPgYslx?=
 =?us-ascii?Q?PqsTtxYY8YNK0BKDTBeRTCSNkgkvZH+lVGouL02b4mkQ+cK6DmuGKLP+hqUg?=
 =?us-ascii?Q?0Ea8kL1xXXZhyw+Hl0g1pRH+fIrXmrqm+LjFyqwNsRqGEAjDw9zstjz2rx0Y?=
 =?us-ascii?Q?9PP7X7gzDGr93SlPVGCgmNtB6UEjvda6j7j+LFORMp0yn5OevDWyPYpHUq8E?=
 =?us-ascii?Q?HSJWmQMzfOcXd8NQlDFkZ4vpXaSl/U5JZMY8v8wRN8mPl+8ze3iILphDqN1v?=
 =?us-ascii?Q?UIgeucqpldzvBQcX3w2mTLtRMhMWYNxRHeWAb/F7MsiktmW72EMA95fBQR1R?=
 =?us-ascii?Q?8KxJGbqHcm5pXQ7tnqSEuJEgE5HsNn0Jfdywn3jx4tTxyzhbsCxRCDMfxiIL?=
 =?us-ascii?Q?5nDjDisRxnQI7D52n65i7ucufJCTvp9MXnlNnrLq0fetv+x4VR38UJQzomJS?=
 =?us-ascii?Q?YfvY6WbwnDxc+7oZhijW4+YAznj1FewsdBDWMAhXyiuMszkRTrrK1VCMeImU?=
 =?us-ascii?Q?nLTbk5pXafn53lDEobA9Z2eUG4+tGsAre0YBfsJVKBzkIMWQ68egc0ulVVgM?=
 =?us-ascii?Q?GemRRy+BVoiMv9ia3OMhAt2MHZMaUMou4xAFRzZyGYAs6nU3zBdWKzO6TLVm?=
 =?us-ascii?Q?GOskvT+rWSFOlD+6AEJLTFTzx+uvLiSn/Cx5P2Gmc2HHFIpCZvcFbIPakgY3?=
 =?us-ascii?Q?c/kd5ZLD8BTEGaceI9TCaFEguOtOjYFdl59MnR7LVyrLExyRPRlzkrn/NHZC?=
 =?us-ascii?Q?HgVvvton1s3ZlXtCL78YjOnavNmtyKXABA/Dt7yyHU49+NMLf9lSm2k7RIOm?=
 =?us-ascii?Q?GV+V8In/KB6fBtLBH4/5wRPAOSIrPCzQMou1e0asdc5ZLfPWeqyN2Y94efHV?=
 =?us-ascii?Q?egjY83RhZ3P0z3X2/GwunLPfAHSaCC2JAJp3wi7+mjsMGw9pjcNYlDt3gxUH?=
 =?us-ascii?Q?AlClhZk6PFaKeZMIH0KbPDFcbeT27I4qfEVbyBwmF8nnnx7ALigirkiaD8if?=
 =?us-ascii?Q?JBf035JO34zFQLgyQJ1B2CDKgUDmjkj3NZ0tmAgBDMQbT7vxwYTDJghMNyAO?=
 =?us-ascii?Q?V1ecChkE60xbz+b6+27RD8e1AR+VyfTbG4+dXDhS8y/vHbafYpsBpM7hCkUT?=
 =?us-ascii?Q?+Lb2NUKJNkS3z6MjY5kbRZX2qSHsDz3buBYKFWia?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e56542d-2bd9-45c7-c19b-08dcf8c684ea
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 09:37:49.9027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Encj2EjEhdKybBKozBVjj2zw0hYKzx5k/QrGS1feefQPO8uUubtOfesHdaGY6YswgWvZCmtNYOPTGHawEtm4zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB7057

> Hi Bart,=0D
> =0D
> Thank you for your feedback. That's good point. But I didn't observe the =
ufs-bsg path bypassing core logic such as clock scaling and clock gating. H=
owever, I might be mistaken. =0D
> =0D
> From my understanding, changing certain attributes can indeed bypass the =
UFS driver tracking. But in this particular patch, there is no parameter or=
 flag associated that is tracked by the UFS driver.=0D
> =0D
> Best regards,=0D
> Bean=0D
=0D
Hi Bean,=0D
=0D
Thank you for your reply!=0D
=0D
Actually, there are some parameters related to UFS driver; for example: b_p=
resrv_uspc_en, host_sem, etc.=0D
=0D
Thanks=0D
Huan=0D
