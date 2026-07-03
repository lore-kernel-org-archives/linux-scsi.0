Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E188F3CA49D;
	Fri,  3 Jul 2026 10:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074895; cv=fail; b=SdTSGNuq+lkMxSERmJWCYcyMIMt3q+WA/wFcurCCP3+F0DwvpXELOf7kdgEm1Saiw0VDzvIFv8krEXEu98b07dI/AkcwP6t50DlZUb/8paKr2kDbZoooF0djYw7OZUnRYO9jSM93KKmbTugEuOI9f2s4crhSnENpRxY9un5vljk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074895; c=relaxed/simple;
	bh=7XgR+0XMlpa3Yw8VS4C+aoj45FEe/gidAp96MqabLas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=llylkM95wyzRzgNAakygrZ/FML44M0Q2V1six/fgusOKiknhPp3Dg8ZrjExEHfSJj7d0ZasMIDZoTAL+EpWlvBUskwCKEyMd6U5frn+Yyv89ct1pfh7jpSFxCpGNFmcZVuAHLsfJQsBgOpPDYXnmeB+TMJ8PN3nzZSuNzgOAh9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EQo3XvDb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dY3KgpLr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EQo3XvDb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dY3KgpLr"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638ttRb3080961;
	Fri, 3 Jul 2026 10:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+UdOGBkW3QwUlsOFC6CVvwBatefz6kfNX4/Llwbnlqw=; b=
	EQo3XvDbnug9vD5lP1AAJWoUkMSJS9UWBqxfWnFb37uklCPEwHyrL0Y51vPtEzxA
	pVmVes5BDnbZOnjP97pEo5c3zKKRrtmnHuMqNGbybIGfPLD62zaxOq5M7FcfqMQg
	p97aMukL1htNzImKaOyiwwgCjEdCAluVaSjtYn7NfnQ2qL4Xo9JHiZ1hTFi2dDXf
	FjFNcyA0reaCaSDKXgNF8gg/TKPJKLNXGt+0pWvmf+CaL3/s5gbHdVtqUJJLlzw7
	gMCNNTtKUg3oISy6pNgkwKwqbpIjYw2EdIXz4PABBwmCyjxogM3UrvQO24Q3o8iT
	wq4NkN0MJvJS46wh/Zt+CQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AX7UR009541;
	Fri, 3 Jul 2026 10:34:35 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010065.outbound.protection.outlook.com [52.101.61.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhytqm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aovs2JHnQO3sdh55OgQhV2AgmIzYZeYtr7aZhrsTcAbISccyR2sc4KjOQf/571laBjHiKx6amGDbblpeWfGlwS28E5rT5/9B9HYBKBCWlhX4m3RSTiNYvk1Ez8RzXeEUMIhRHk81ZM8pKUbiuJeCDZ3V2iynOY/KSD4+kF5rIArN4mVHCL01dT65IvCqyAaIZT1374d6bYeAtdcjo+3BJiGJS8V5Q/FstEDWdg4DjZM/wEMedmleuwyARHDUeKx5AaU64qij324jDc5RxqOSVTk3qyk530JX6Crr5kZctXQgPO2j65DH4846l54bonQTyCAhX/vOb9oJZRsPwKal/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UdOGBkW3QwUlsOFC6CVvwBatefz6kfNX4/Llwbnlqw=;
 b=Yh4oI1TZr/Mj4QtKlkRyOurvuSsl6q6JJEAHoB4vmpfvCplSdAzC5ccqMDmbUgIFGRARR5rAKoyKK9+3GVD1mAbrT6gv+2WddT5YNxwMfB6Fc5Z9KTCrDHxBX8PHJXmSilzfpNUtSyQiThXge4rPZ44IC0erfCL7Zw+lchx2CWgWEOOn1i79lCeZhnf+XZbovhmAtT6nS9uw7h7x8qKEf0f0GsU0cImvKbLdFAMVxy3Exy7sDltKoXzju/I2tZq7AIj60XOCcatUQL5c07BVr7Weh5l2UpItCBTTlaGX5F79spdH/yTfEZ0eVjayvJiWaJZpnOggvivG0QZ3WWdSYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UdOGBkW3QwUlsOFC6CVvwBatefz6kfNX4/Llwbnlqw=;
 b=dY3KgpLroqxhBlZo1svDKKmDOjaRM7Bsy5qqrq7pFAceOkIsSfj7Ga55OVaWt3GdYMypiIfmZIS4l6Q5lnPltF0Kd3DoMyYjs7CNnD0Q3igoIKL/pJ2Ac21wZVU9U7XHsJM/JAi3ehvSCmGGSFGYdJv3SEg/2tGpMTFt2heKkfE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:28 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:27 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 01/17] scsi-multipath: introduce basic SCSI device support
Date: Fri,  3 Jul 2026 10:33:46 +0000
Message-ID: <20260703103402.3725011-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0048.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: fc067e72-78bf-4eef-3fd5-08ded8eea894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	XA8yQmP5ha8iS242RcWfDqYkRkZnhUdBvneTAZ4xcSBFL2696PE1us5qSfU7ThhtZeXn6rEj5WIaI9FoUXCkqqpO7ISyctqRvhnRUmxu/uNL8px6iPwRCgzMi0KJPmc6bqIiYZrZKlffcO2rVDbEn0cXAbuqzzEKuIr5RH5NkuE2K0/uDRwCRYpn7VQimpEWYHQ2BNwcqD/oa/bsLCVb2Sja+6QpgmBi686QnTCOfSDCzCvW839jS/BRkOCiLIqdFqXXVtsRKa2luPkTkFDF9OPftnRyxiik4y00VcUePqwUncXZbF7u0bo5V1801tkTOLe0I3imb1d/gHUrKj8mlEeC51cZx45vnQR8B3d3WiC2vMb+12xlkd8/nlDb55pB77DeZpAqWHwUxQfiE/rxUESSPF0hvaTyvSnP7L3hYORRxf519hPaZR7QWsl42L70uUHbHpl0mfWqFA9gNhmaQ+Z2slTF/nusAXnS6+YfYvgipXRZrTRK3hwb1tZ31Na7rUIHqgokg0BhmIS0MYeoW/ffr3wEzrCF6qrQPe1x6G4YqBlFSIy53d4PG1CdpVR8FKKXa3KY64NEJKIXvYpyBPs4jopv00H/SZWMfdUbArLHDUHJ4HDp77plX0+eHP7UAAfICU76w/FKVQrbzXugtxyzlGe5B7hcKLxAkES/MOk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/6Hga3uUVz6Ky1t0UvM/IWFAdmydDL20xGBjNG2uFPIDfr+MWHWw+qXdNGUD?=
 =?us-ascii?Q?OVKlJjnqAZ2+k5dztg2enzui3AH0iIDmDTT/EockHxCHMYE+mV7KHVHODJ63?=
 =?us-ascii?Q?i8d3iQ2Rja3nH3J8KfTr1xeLKojCfMyaFykV+HeC24g06rseuuNADHloUr5a?=
 =?us-ascii?Q?TuieAhKc6zn6M8JCRf2+cS6kqpCcAfEIFyioALHJZzACMULK7wHgsC5in6RM?=
 =?us-ascii?Q?ZoAtLe9lhRbOWWzV1v8lwO6OyIPdbqwvzowrhbQD/ApI+d7h1uhHxPVsL/Nm?=
 =?us-ascii?Q?z4SoNSnDS20aomRqqv6X9WCCbG11vKJDUm2EiqIgu+RuwjPn1Xc8PT8nKSuC?=
 =?us-ascii?Q?lVDEypHIaDwGqH2UmFTG/ufhNHCBHJwUeDuMuFcOxLjH4zqCJfb5vfklFVmu?=
 =?us-ascii?Q?GXuwmcMq6gMqK0N6TktY+NP+0J/OwTzLvQa7BUvVd6yDumcAdCZycntEzXBf?=
 =?us-ascii?Q?lvmL1Z5TS7ilWxHSdV0pFVKSGFazbo13TJSiMj/r4G0u2z164xe1dDqGrtTv?=
 =?us-ascii?Q?pWXd3nJtpabc3OnGRFDinbA6LHU5Hd/F6LACPHvPXMsqYUfwyLIGhYtoOQ5O?=
 =?us-ascii?Q?cmx72x8Q/aBTi7d1VbjFNmmuJuRk/seUcS79JDloMhbPVXQynLCcg1gTvDa7?=
 =?us-ascii?Q?UZ46/hxhrVB5nZyE6U1h0W4KriQGSstWUCsxWZ5p3CQ3zzAGDYEgQjsC9ZDp?=
 =?us-ascii?Q?aJf62Sz1ILQaDPu5qGWRAggy+ClcZZ63s6FU3acWxODZfq4HISg6vrlBuhpY?=
 =?us-ascii?Q?kzu4klloO/5s9vJSGX83ftlcX2C4AxJcbWoeXILRzsSCl88tp+c9JQE4d+wi?=
 =?us-ascii?Q?a6DauC6VVrqhHeqUs67MaBi1kUBfXnbIumbuxU+bFbyYDzfrTbREdBXkgKck?=
 =?us-ascii?Q?idlLqribtPnVh723d9kfbGUTSeoLHmTIlxYLT26viN4VWY4pk7tq3Qsk6byj?=
 =?us-ascii?Q?/PUOe9MhA0jBaMcnvcbqEbrfCLIaCkLCoZs/or1VCLi9CExxXIgIZI0uIdvz?=
 =?us-ascii?Q?UVa2p6O9YMZTGTn8D/L+vBsCVG4w7JkrG2UM72bHc2mCnRbWmUWc45gO2icl?=
 =?us-ascii?Q?pNhlcnrWND31uyAbni9H4xHD5OpGK+o75m0r4chc2Yqq1IbMBwexpCzyxPv8?=
 =?us-ascii?Q?NXxEiz8uqyzNCowdzMR+6ymYcU0r5p9v6Ium9NmevLbNEHDW69NfPpjwpHqL?=
 =?us-ascii?Q?Ws+9IBR4bjKUSqlLfbDadfSBh6QXbaf0UrKhtQ/fBbmUIRDyGz2jBhffdawY?=
 =?us-ascii?Q?BkB3HyywVCWpZ7K7zK62B5ROBtkcoadZac650+o987lvmvKIiWCAriONeHxs?=
 =?us-ascii?Q?3HUfo0qdsWC8K9GD1A8r6qwBsg6Zhn4pBF5hgpjQ+5DDrPQcVDIVxiizBbAa?=
 =?us-ascii?Q?sHOvvESnobA9LrouboBje0+eIzffgYmGcWOVv97XnWkx40HjwY700uv7WLIg?=
 =?us-ascii?Q?0Jg3UPZtmwek+ZzmfIiXmfyaiHdqZocEUI+AyByMA8N7Mvbj5TD5hpoO47kB?=
 =?us-ascii?Q?e1py+s0H4CCgpEg0L3jnTmXHKJ6PAqT9yW7EZ/j4V4a7oWaXKrcAb5SMdbls?=
 =?us-ascii?Q?XU3jxPhl3aZdcCaSJUnfZqf+WknAATi1z03KtpeFAtpt0wyL449aDYO+s2is?=
 =?us-ascii?Q?eu5gbVgMuBmLSHPcASbz1sdM+bWauDTri4mVNGeRihEhTG0DZADF6J4mDbgW?=
 =?us-ascii?Q?bnInlSw/9a22Nfo3VUK5kS5tFZ0h1ryC0T5jZvyLaIU2raybhVqyX9LEXfil?=
 =?us-ascii?Q?5nRqX6kABE9s+KCdKlNO2pwxJmYfSsQ=3D?=
X-Exchange-RoutingPolicyChecked:
	jYuY2Mqa7rD/VMcnz/sfZ0/X/CigPfYAZPa8JxY+980tR8i7XGK5dLiMcffQGISeR9IW6k/FNcd8wgz3uFmmzGOq4J9g0+XILwYrNnmxQSp1VMlz0jBdmSQ802v4ILOJSaWVTokuADRBEPoZxorMrW0tvMWc+O/mvIOhpKGvFvwffaM+t72ymGvOoFY4gLLDILls/CP8byqe5ZdEpvZQxIJcO/+Jc5YmyAgwI+0G+H4I7hTJ91UZEbn6r67xGK7HYFdzW+K46D8U6DS0Qy0NkwRWv4njf5It6hQ+PO2OjIqttI5Al2fMgJJp1YBMlxQCQO+cNA4RNhB5qqXiuNhAnA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HZAALSshS7bATtXvbTyqIa6UpM0cvxTr+cAvOt0ZboAKyHupgazgxDcrv0nh9ViIP3Bn5JO9kAs5I5C98knZOpJ5RL9hlaNcscSzWkFss4XBE9JYaL0wl2RDUiUOsV5jLoB3NMyJ5+93rBgDXm8pjilovaTdGMhEd+tcOMHfGR5Yw9TePmYWJ8EXUN/SwxU6QteoGbBUzvuxkcygtfsv7BHFmScWURSI9mEJ4OoTkHJZPmRXxdrZbaVivJcKNMNkhWJPaW1qTK4hOJ0N0sfR26864L53ueXJYjnKAFAOfbW0cVOy6FtYicog1GQv3TT9pFOgfzhbg4lW80jlSmC2i4x7vSGwfQC53T1ZQxv4vKDOi0Kxylnu6j7IvIttr1bxFZE3ZSwnKMnn8d1LULd+7yrCVRxvJWUz4GcHxWtDZVqkgPAiC02uXayWOgSOmu3QYRm90CmAIpT+/IwKGjW4k+knpeKaCqvD24vcauXTLsG+m4j3GIFAsLPBPpO6rMFiuTrQf+N+vuhD7yAhj3IH9q369vynQ8ZhYVWho4GB0uyLArikfhropR9+YuQ4p8MEbhEWgNGz8umhp5tUse64LOrfNKFeu8eVwgFxAr327Wg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc067e72-78bf-4eef-3fd5-08ded8eea894
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:27.7651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BupSJv5lj52q63wpkNm/hN9UxpvFGOMcROreBACyKxDelutNUJOv68V/jNBF8uDMLfd2og0Xg5jq094afFGceA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-ORIG-GUID: _9v0cFMS6ER6ECOUOBNe0v8mKnI1jO14
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXyUYZHQ/TmdK/
 0zvpY+hgtW+mdWBV3s8AiHs0TEx+dKP7nlb8aONMkbco+uwPaoVfkcLjeDlwd8pOlkWKFqgtncW
 P4KpNeQvU0MldH5sYhyfeDeno7GkB0+6DuNvfAkxc0xerPU51xSZw6GbZFOmixLKPyhNfRc21VQ
 iVGaGGfjhxvIl2PJyNemqFvjEIt1vkmYvIezIlWHavyLjKUkzNnC7vctrfZr53ITuqLimWK7CKZ
 J4HWm2bcpXcpEv0uHj7iBQgO5hZJ83Bv0fXcafG05OjPnGernjbPZXmKJHz+qF+MsBbAtTB55nE
 JJdLI4fR8c9ISpfamP/Y0zWTRB34cMFXbtPQr/Fc8lWoKm7VViVASTK1e3YaxU+IYGJVVJK62ze
 gKOeIUJab0NA9PYjjrlEBqbQcr1k+M7nI2fQc64Zq4889ZM2KR5xq7qApSp2W1AujmEJ5Fq17zb
 8GNRtiuwCBzTeV9f03g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX0USBcm5uTbKF
 8dIwedtWAoFz/2fbtAstFzCRYQhp57y67iBMinSbRxN0t6El5bAynA6SgMRtKk1GhxmRPJwZ2pY
 L7NCB2diQ8roXpVxDEQUl+KQcaADwXeLCPEVQFVbAq4qVEi/f8WX
X-Proofpoint-GUID: _9v0cFMS6ER6ECOUOBNe0v8mKnI1jO14
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a47903c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=pCOl5fTshOrEa-n2-VQA:9

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like NS structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

A module param are introduced to enable multipath - the following modes
are available:
- on
- off
- always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and ALUA supported and unique ID available in
  VPD page 83.
- scsi_multipath always mode and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device; having
this pointer set or unset indicates whether multipath is enabled or
disabled for the scsi_device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 146 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 +++++++++++++
 8 files changed, 227 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c3042393af234..d6c31df454825 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support (EXPERIMENTAL)"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 842c254bb2269..04f9c2e51fcbd 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,6 +168,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..70aa1dbeacebf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1042,12 +1043,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1071,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 0000000000000..ff37cfdf2f9d1
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,146 @@
+// SPDX-License-Indentifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+enum {
+	SCSI_MULTIPATH_OFF,
+	SCSI_MULTIPATH_ON,
+	SCSI_MULTIPATH_ALWAYS,
+};
+
+static const char *scsi_multipath_modes[] = {
+	[SCSI_MULTIPATH_OFF]	= "off",
+	[SCSI_MULTIPATH_ON]	= "on",
+	[SCSI_MULTIPATH_ALWAYS]	= "always",
+};
+
+static int scsi_multipath = SCSI_MULTIPATH_OFF;
+
+static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	if (!val)
+		return -EINVAL;
+	if (!strncmp(val, "on", 2))
+		scsi_multipath = SCSI_MULTIPATH_ON;
+	else if (!strncmp(val, "always", 6))
+		scsi_multipath = SCSI_MULTIPATH_ALWAYS;
+	else if (!strncmp(val, "off", 3))
+		scsi_multipath = SCSI_MULTIPATH_OFF;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int scsi_multipath_param_get(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_multipath_modes[scsi_multipath]);
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = scsi_multipath_param_set,
+	.get = scsi_multipath_param_get,
+};
+
+module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+	mpath_device->access_state = MPATH_STATE_OPTIMIZED;
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (scsi_multipath == SCSI_MULTIPATH_OFF)
+		return 0;
+
+	if (!scsi_device_tpgs(sdev) && (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0) {
+		ret = 0;
+		goto out_uninit;
+	}
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return ret;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e27da038603a2..3f1ac302719c2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1130,6 +1131,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04f..2f80d703ce640 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -455,6 +456,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 029f5115b2ea0..40a435e66b34e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -280,6 +280,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 0000000000000..d3d410dafd17a
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 256
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

