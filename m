Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE33396B96;
	Tue,  1 Sep 2026 10:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259572; cv=fail; b=U7b43NvAbfhM0wif2+WUYjWo84zd6KTYHIIODd4KlEQl5iiVvCZIy9taPw1tuoMqysBMd1IbzI5UtKRz12XD9Um96Fo/W+dzfMWfQOIfI3CY9CpuT25c4aHkifh+wu2NVNO/k7nFPqoF066+/iS4FyOXwZVYnqFYGOHm3d/oDdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259572; c=relaxed/simple;
	bh=A54aNMOs+oXOOE+acUkCEe+SowsCg0jxufQuFaUahBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FBl1ag9JFqj6HYDcuea5ldZ2DwmBkH9iVpPGUTZ0YsvM5s0l/dCBBzjFuNum1FY8JiPYfDKm5KQ4zVgyIRTr6QTPlYfT45/V4e5cRjKthMvzlFrdAiZDnIG7Lobht1FzMMfLOS4ACBS41Rv3kHaKKG9emHRqI9UM+tPeHBFCj4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GaI/hM0f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N9zL28AW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GaI/hM0f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N9zL28AW"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBwvY2296648;
	Tue, 1 Sep 2026 10:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qnoFbCS2l8YgfLivgtz/nYusuYA/aAxy9zsvPCESYb8=; b=
	GaI/hM0f6vHRaK9T1FUT3pSfqTlavdo8ba5Q98nQMDDcOovy1CizVtEPxAcAjO0s
	0fH8cJe2yNgq0n6Q7geLL6bIUz4YQ61pZvWBRC1ret0igudbl3rUv6bnTc9q334K
	dUJQarhPbhEVwvqxoGURy6XLZtt8/wxF7pGWKVWuSZEe5HVQMaGAepEJdgY43AKh
	2n7xo68mkKDWKAv4953rNjk54FHjRcJ0bgGLZNgtBMC7ztqxnaXrU3FkZKi6NMDC
	pOinGtZwCogleGkl3N/7Ff7y40Ybbf7V2HXt9l+S0bSAirk7NM55MtJ5whENTLZQ
	4lRCbJr/KZ4f/wKc/IWXxA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xvd9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjJtD036963;
	Tue, 1 Sep 2026 10:45:47 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve348d-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CqeHWAyQZBTVOHQz5QVxutT2SyPGvqfQcPWZlgVa6hsmB3XQLOCDIxuO5CoZIjl/0qAw19ssildkmGnqQVUkn9cZ6KLGysONwH+rpV0aMX+YXSDtM98/Z47ghbBFotnLZDzXouuKy5RPLw38X6ppu2D4uROEcFe/uhdOFUnafa3vbaOWuzeoeaBqZ0VlN9xJ4g1enluMo9EPYe96QPqgRdowr9WsfJ/8qyl4LZpywcykEOMG6jhJZlXKSeaUFVAbDVu7HHe0W0CDJVO9rvRkAS/tQ5uOQ+5ya8VYm7p1AsKl9RJuw086T7anB11J3vvrdNJkItmJTfMZXbeIykI+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnoFbCS2l8YgfLivgtz/nYusuYA/aAxy9zsvPCESYb8=;
 b=satTRJKFRsYEXdX12UiCoPZo5wUxM91IZvpJ6mOlJzTcn/S2kp+e78O1O9JkszfHDhvpaueX+KlzR8j2P/87tvKLAtM76Qx0EA48/WQ/uyHqNarQAqNOKHLnoKXLzPs70vhZqIjk4MpP1yu4PvhxJfzGXdP01UUlFzyXEnAH05CI9DdtcBaPK2RznFA2TtTcsbNjaAr0O8TZRRWMzVT78atkdUjbFDCcU9DzkrnH0Zk9UMUUFwjHKZKqaOTUaq4q8aLUBZe0TBUQc42qZUAeAsybkhxXETOTKl4upJsLpumWps9yep7GQER3GGAAb3VDWTnGkTjCTT9H6bQrYYSmJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnoFbCS2l8YgfLivgtz/nYusuYA/aAxy9zsvPCESYb8=;
 b=N9zL28AWx051o0ib/8AmhY8wghEpibJqDcs8qh14DHKuwe6HS0AF5/lfQFIG3xXc5qMdGbqZ0uX7VFGKm/jj74sLEJ42OBd+QwhpruRCTY4UCd+TpZilUC1oTp/mgbyBjJaigBBQsG6kgjdpozL98LrcqwBcyg3XvcQfjKBQZYU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:44 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 04/27] libmultipath: Add bio handling
Date: Tue,  1 Sep 2026 10:45:03 +0000
Message-ID: <20260901104526.3850621-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0014.namprd20.prod.outlook.com
 (2603:10b6:610:58::24) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 0585c0b7-05af-4c91-7004-08df08162cc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pzNtyAIPHPHcQfKhITT53G3LQPIuFbm5iiWLJBe76P3U7Fjigl66jnH8voBdEEJ18TBxq0Fc77Xw+rlPdVqP+JArhv6ZwReF16UsDJ8Duddgu9EBJvfEDrDCs6yt7TmEDA1Hr3BIslZHBI6uZ7ABWNKPFtaLOyuZc1iKk5Dy53hemzWFcgcunelvEMDDlrxlXgap36eaH5T1YG4c10r0Jk0ZTVA4cZHfP0A7CupusBKVEjhrtvzeJ6V1RCXNePPn9BBTSOoER+UJIPEdlUVmmvv10rHzjYToEuO+hioNxQczCXy3jsGDCBFQfasjfIBecMuxzjYwRaaIst5ThJUXRVkQa9XQ3WpLzgxCJozrieXXgooD8IW40mOooZHHSz4Q49Mna1bK9KeeK2dUVCMUMSquYJYwoNNKO69CXA+R6VOHSA6kgoIxVbr1RVuMi7QwfE6Rqn0AkYDb1wJw21B5dTPtJfgtUGCyxdbrtSKHm6gYOdQK4T0rVXL8U8m2wBvLEsJNOlXP0E8oSQ49zMk8jF/U0Bbnn9nZ/FibD16IOQ2mON7S0q8O94z/rifeJrE2T/Ad/eNs/LZomDL0kBbHcpmahAE1tTXD+lIOiAaVU/pijzW4ZFPjEs56NHFJIW6rBbGM6BgOM/hdtA6xznVwuOYQI6+Sqx/cnFprp1U3das=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?88RrywEJqWJXf7QcZoM4770NdKnkwN43B1WeIqbwuXl/sVo8IWh6T93F8Da/?=
 =?us-ascii?Q?o/Ze+wlBhQij+YYW37T545wXP6DDgE4RABN5OytdPT7uK9Yl4RQ//jeUtmud?=
 =?us-ascii?Q?tvPPUB+f0864N+auH6Xv/Yyh3H0QTEv4ZKUSQfHPXWDCu1s9NWIF+mf7RTjK?=
 =?us-ascii?Q?Cw4YP7f41fnbKqeMRx6mzrgTtBAoNMKWDKjA2UqKH2G5WXoYOpxSzu3iGSaV?=
 =?us-ascii?Q?M7X/noSrVQRXdDhEwU9xQpyrYrZZG+dRqSyeXWtMitGFCM9YMf9L/m3faYT8?=
 =?us-ascii?Q?hEG22EuoX5EzLlTH9rUvp2vQuhw0CrJkhCYAzhuUtK/mbWnPsC2lIBGzzfqo?=
 =?us-ascii?Q?Pbtw477Ntnwx+7/U8dYu6+D8OAzQfgtVZTFs9Lubpveow9xY/TyZFcYvTxFW?=
 =?us-ascii?Q?e9iVmZwhJCBlPWO0Ev77oAs81mPoESYzTP4QFfZx+UzQ0E9x3+1PbJbe8My8?=
 =?us-ascii?Q?rarlEwosoZDbV2tPkaGW9qtDsSUsPoZTWCTgqJ17lL3q5flkeggXBL+sO5u4?=
 =?us-ascii?Q?ClLhIHK2/+iYHVGzMv8PmaskFMBCaWlfoDmz0+bZUrki6bYTklguJWLVR6DE?=
 =?us-ascii?Q?3isgoibE47sW8yBGr0YHWSwr1W/RfZJVwFspwI9/FP9zJyY3ChhtF6aRujRr?=
 =?us-ascii?Q?gSsT17w3x+fniqbGNI+JIwvPy9zCctWzuw2f50a4wDgQ4HIuDJV+3kiQHpkw?=
 =?us-ascii?Q?j0Ve3IaPWDLLqmyNis6TFSYjsFSe4dunhkWGO97LmDN/WPAspl4UIVS3RTWZ?=
 =?us-ascii?Q?/qIRCYeti1i4Ge4gLmB45CbYBNDg5qeI1ke4g/xlFJApI1DnIsOb8ox7Fmoa?=
 =?us-ascii?Q?RSJsJitTVDwQD6dpuX0mmoHZJlsfZm9W/K1/7zym3n1LhtpYCRaUzeFwUROo?=
 =?us-ascii?Q?sHclxG3mVbwGfPtHBPfWY9GXw279TJ36ZI++3SpYip0JqhRd0XRvmQlUwNSG?=
 =?us-ascii?Q?N7B2ff58p8u6KhFgcv7s+nA+o/mg15UB1sKaNfgD4pvxvsOgN2xMwHD57Fjw?=
 =?us-ascii?Q?Y4nrZ0a/Zsk5s4QpLZ3v/tLVvdL3Vn6V0Mb7sMpGUc5kzaqaBKexvoUb3PV3?=
 =?us-ascii?Q?0/K2h2tICXTa4bz+Y+VjIqfYX3LxOp6/2NrbEK2grEhcniQXwGI+EEgvn1CF?=
 =?us-ascii?Q?S2D9PFJSpGI+z8XFQnHjG57/DK05Q5iZ/95b8ga4SDRfHaOqgnZrj1S+LRC8?=
 =?us-ascii?Q?iLz2aTXdM4vM4IvXjFegBsUlZ86pT+04wJONKBlVHTIYm0sPlVssIjpH0jRD?=
 =?us-ascii?Q?IttwsAlEggz5t21gMxm2Tlf3JacGEsMQFJ3syLb9ldthE1OwY4m9aTOP7ObN?=
 =?us-ascii?Q?fduGcbgqxn9Wf/vp5qgAU7epSl6/QHyAZp27V+77ANQhR+pGikoxB/UaNN0c?=
 =?us-ascii?Q?CtF6Q9z41+AoRPuXCxvdmD+g7d4YOBYKJERBmBpB9XH749WyBZc6opD5bvpt?=
 =?us-ascii?Q?o3bE4ttgYemHhBKxMd7R2zsJlaZV9iSSz9nFnMobnRUJ4es6eF10gG7awySQ?=
 =?us-ascii?Q?iVnDAl3GbBaykPRWe4qjKw3Ibs3OkHXq/EqHwRyZr0lPrv56Sa3P9nvMDcdk?=
 =?us-ascii?Q?iQtbsrJb6K1srxEGpMhD1E6MXSl3z//vC7GCvEee8sfdQbVWnGvofUN/p6sE?=
 =?us-ascii?Q?h/br/jyT/xt4lbN62xRBvHH9uM/c9Nzh3Debuszolw33YNFdwrpcfeEzmk2+?=
 =?us-ascii?Q?KOkqy0imoRa9mrJ0PUU+ZMQSF1Q8KXhJ8lTL9l1/v8WcA2+GjhzcFG46ddPk?=
 =?us-ascii?Q?cUwP70akzg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	QVsYvqNtKEp3ZIni6GOzaeGXU+rMw6Qk3w89msyxNNANpLhqgLtsRi7fxlCFFa7AXnt3eXE9g9FzG74CMKG0heodKQ337EqbTcCZ8GhlhNCeqBUe4PSCZjqZnN7QD+6oVDQdR8DdB761awALEf1rpHBeCPDMcqBqlSvJyDZG/N3uK1e0V4dwKkDRar8zr09cWPF77C+kdvgh4yaAMBfRoxZUMVBtq0ZqHCwzwHrYe2D84L5Qx6KKCPqKnaSlKXL5cFf/idmJxqln7S3UX41LUm+gxRB849/rPQ1jVrCzl6mxNjKi/QGMl6UTBC/psycs5QDltMp2ERC+qSI/HHx0eQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ilL4sVDiHO5//BnPjt5ZjesN4UuepMg2m666IPTtBCVj1YknBhJTZAJ3rmYBWXX90WdGOmOZJDdVbn9bBtAgdU/i2ePAapTIGoN28OwTiCjnrEpRlahikwpF3KacB8eCxb2pMdmimjx0W0a8yVjxbgLRbIIvm1pHWM2E9dqTJxvjQCwL8oiMz1uVJQ9UrQeSCv7vUaBVPPV/Zf0VlGTjqvnEHFmVHg1SdH5ZOnbkOOE5zElZtgMbTXyVquwmh1Oqx5ZbLpATRHnoL1bAuVyuMa4Kxpv1I2Zzb3aARKWjJa9nXB4uyV4wU1YNARJtAezphW1sTCHYwSG1xWsFRQvVC8dMG9O6Pt51x88aXD5iLNmi3IXXKXpzjB/15tTXcv5sFJUJ7UKPRbo4LqAkZ6ElwRjtnI73oW2VoN8y0+mP8LVsojA5P01Sv6y9cpgfcMQ98CZLBZsz0nvQ77MsVgFYlHetZw7uxieEm2kdu52eqdYs1aXbevVK2DI40uCWKXylOD7ytHGxFg5u/F+eHrzENP5EGUlBMhkBRDRcbbAwXUyKuHSUdp+1rgiBexcmKtM2S7Jv4ozIiD/q6JrgBLFHPJ4RKZh3FZOM2x16C20vdE8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0585c0b7-05af-4c91-7004-08df08162cc5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:44.4645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQIv6AUXlHytVsK0x5IZIso4jWw4YUixbIeT/1XDHmQp0+xoZKXQFjs53Ryp44zfTKaLFK9LOgPf2gISz5ijtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-ORIG-GUID: RISG4w9HvGrb1qxQLjQ84rBS4CnTTXZB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX8QZzmOfDt9Y2
 TwPDsOm9y7QkypbjqBX1XIPdqxuhxJJuCe5opajC7ej7zK5rxfUMj31qu2y8Zw26ETYoRmy2/Ie
 67xSlGPa5JLsJRZAx29XFtHbZgbCZy6mBuGFldYHCGNlrSwtzrPYBfbM4lAGYMVIHLXQKrdKd+0
 x+e/3/OZ78lRkwNcmzOdCeR2ksIbAzrMmfsSQYttc2B/zMm0V3WzUtijTxvXdcuC3CxrE4VPkhU
 jj4jNs4tsqBW0jAU6YYQR9sOmm7gDIFzOCvRFYZ+l1ouf8AaatXDXsj8vUENQBjcJkE+E/mhM0D
 OAIogFlWvpq7a1zaZ0mEOv+kp7FJs2L8p+8rvlZ6T3tcXe7RgxUdP8T8+pzHVTVbBNu2hl+emny
 SCYDqH4ikasyeELMrH9X8v8cAJjdshpGV2t9+IFdvdd+f5gOY2jJTsdQnOgDkfQ5zjNGpWWhGrh
 PWheUypxz23AT84nUkg==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a96acdb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=0Q2gd2vOsnR98QmcnEwA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: RISG4w9HvGrb1qxQLjQ84rBS4CnTTXZB
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXzKoIfE8jpi+/
 4xnZ+Ddvt+PzlNSEt3hJ+UQFYk1sZt8L8SfBjUezcFLiCAbD38g9LFndV1JPOLUMC98KlLlbHVN
 l285sN0XxUnJ2BOzv1usdyv2FknvAjFJC7GLLu++OyUNrXYZG5OC

From: John Garry <john.garry@linux.dev>

Add support to submit a bio per-path. In addition, for failover, add
support to requeue a failed bio.

NVMe has almost like-for-like equivalents here:
    - nvme_available_path() -> mpath_available_path()
    - nvme_requeue_work() -> mpath_requeue_work()
    - nvme_ns_head_submit_bio() -> mpath_bdev_submit_bio()

For failover, a driver may want to re-submit a bio, so add support to
clone a bio prior to submission.

A bio which is submitted to a per-path device has flag REQ_MPATH set,
same as what is done for NVMe with REQ_NVME_MPATH.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  22 ++++++++
 lib/multipath.c           | 108 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 9bbab0aa8961a..374f0531f7e07 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -3,6 +3,7 @@
 #define _LIBMULTIPATH_H
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
@@ -29,8 +30,10 @@ struct mpath_device {
 };
 
 struct mpath_head_template {
+	bool (*available_path)(struct mpath_device *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
+	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
@@ -44,6 +47,14 @@ struct mpath_head {
 	refcount_t		refcount;
 
 	enum mpath_iopolicy_e	*iopolicy;
+
+	struct bio_list		requeue_list; /* list for requeing bio */
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work; /* work struct for requeue */
+
+	atomic_long_t		requeue_no_usable_path_cnt;
+	atomic_long_t		fail_no_avail_path_cnt;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -53,6 +64,13 @@ struct mpath_head {
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+#define REQ_MPATH		REQ_DRV
+
+static inline bool is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_MPATH;
+}
+
 static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
 {
 	return dev_get_drvdata(dev);
@@ -96,4 +114,8 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
+{
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 26714116023a3..93b82eea7d38b 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/multipath.h>
 #include <linux/wait_bit.h>
+#include <trace/events/block.h>
 
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
 
@@ -44,7 +45,6 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
-
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -231,7 +231,6 @@ static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
 	return mpath_device;
 }
 
-__maybe_unused
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 {
 	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
@@ -246,6 +245,81 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 	}
 }
 
+static bool mpath_available_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device;
+
+	if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+		return false;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_head->mpdt->available_path(mpath_device))
+			return true;
+	}
+
+	return false;
+}
+
+static void mpath_bdev_submit_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct device *dev = mpath_head->parent;
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	/*
+	 * The mpath_device might be going away and the bio might be moved to a
+	 * different queue in failover, so we need to use the bio_split
+	 * pool from the original queue to allocate the bvecs from.
+	 */
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (likely(mpath_device)) {
+		if (mpath_head->mpdt->clone_bio) {
+			struct bio *orig = bio;
+
+			bio = mpath_head->mpdt->clone_bio(bio);
+			if (!bio) {
+				bio_io_error(orig);
+				goto out;
+			}
+		}
+
+		bio_set_dev(bio, mpath_device->disk->part0);
+		/*
+		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
+		 * enters submit_bio_noacct() for the per-path device. The EOD
+		 * check already passed on the multipath head.
+		 */
+		bio_set_flag(bio, BIO_REMAPPED);
+		bio->bi_opf |= REQ_MPATH;
+		trace_block_bio_remap(bio, disk_devt(mpath_head->disk),
+				      bio->bi_iter.bi_sector);
+		submit_bio_noacct(bio);
+	} else if (mpath_available_path(mpath_head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+
+		spin_lock_irq(&mpath_head->requeue_lock);
+		bio_list_add(&mpath_head->requeue_list, bio);
+		spin_unlock_irq(&mpath_head->requeue_lock);
+		atomic_long_inc(&mpath_head->requeue_no_usable_path_cnt);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+
+		bio_io_error(bio);
+		atomic_long_inc(&mpath_head->fail_no_avail_path_cnt);
+	}
+
+out:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -291,6 +365,7 @@ const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
+	.submit_bio	= mpath_bdev_submit_bio,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
@@ -308,12 +383,35 @@ static void multipath_partition_scan_work(struct work_struct *work)
 	mutex_unlock(&mpath_head->disk->open_mutex);
 }
 
+static void mpath_requeue_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+	    container_of(work, struct mpath_head, requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_head->requeue_lock);
+	next = bio_list_get(&mpath_head->requeue_list);
+	spin_unlock_irq(&mpath_head->requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		/*
+		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
+		 * to allow multipath to fail all I/O.
+		 */
 		mpath_synchronize(mpath_head);
+		mpath_schedule_requeue_work(mpath_head);
+
 		del_gendisk(disk);
 	}
 }
@@ -325,6 +423,8 @@ void mpath_put_disk(struct mpath_head *mpath_head)
 		return;
 
 	/* make sure all pending bios are cleaned up */
+	kblockd_schedule_work(&mpath_head->requeue_work);
+	flush_work(&mpath_head->requeue_work);
 	flush_work(&mpath_head->partition_scan_work);
 	put_disk(mpath_head->disk);
 	mpath_head->disk = NULL;
@@ -385,6 +485,7 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 	mutex_unlock(&mpath_head->lock);
 
 	mpath_synchronize(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
@@ -397,6 +498,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 
 	INIT_WORK(&mpath_head->partition_scan_work,
 		multipath_partition_scan_work);
+	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
+	spin_lock_init(&mpath_head->requeue_lock);
+	bio_list_init(&mpath_head->requeue_list);
 
 	return init_srcu_struct(&mpath_head->srcu);
 }
-- 
2.43.7

