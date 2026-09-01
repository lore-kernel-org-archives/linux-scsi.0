Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBD93BBFCF;
	Tue,  1 Sep 2026 10:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259589; cv=fail; b=PumYrbWpDIcgbuNI3wc8ooP1wc/1kse5BtRxeCp+tSGsmuIVBWfNjw3dd4JI0cH4w5i29B+JS08MKt97BJcB3BJ7a6vwO+uMapbXIiOeHUYZrOR8xp//VLzeE5UmxC4DwA0cb9kjwDpAOgzVgPXG44JZWVFz2dZjGi7/1dN1KpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259589; c=relaxed/simple;
	bh=dw1EmJdcfR+mWefjY3rwavOh/ZjxMOoCyakioEdnhqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wl6i1rhBDETS2mamRm2Jng0JOz6Z8B4FAu4r5FH9AbBQ75md93hv+y6WEneSmEQUan8+sfTZaVWvDanP1pjdGWsn3ln+umNFOj5T+2CpV5KP+urILxRP2DxTX1i+fyHXt283K7qBCUGpxgc8fs8NrBC7J3kkewKqks2vIyYQnx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J+be5CD4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eIcmSUMF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J+be5CD4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eIcmSUMF"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLCbQf2223247;
	Tue, 1 Sep 2026 10:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pVcT2mG80vYds1Il13lslgyVg554GSkY5F659bj+2Xk=; b=
	J+be5CD41PTPAFLdfV1FF/3GgNbYhk5hCnqyg8g8xJ5msneuiOLuP5EDOFI5mNje
	efV2JL6OhXkxkhlGOj/cSW4Dv8VYkFHGCliCPD+IefSH9X1Jo8OmAl4hMhxoyXQZ
	nsyVGWi0RrQtyHyVpUDVUcCDSqjtq/D/luew1aecoGmjMgnFmiWmvRliZIVegQHp
	d/u8BxFVXkq2o1iJo7b80Q9FucFP39PHmwyaf2RGoeyCyuga9NUmQOKT9EjXVN6W
	S80hwMJyaApK7bQ1jQKp7huHkr4Xx3fthmzQXHmr6kdTshIG2JqfcV0Om3S+arG3
	M5H4ap4qX0l2fG30KWOo7w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqyrvbw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjYA4036488;
	Tue, 1 Sep 2026 10:45:59 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqfk4k-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VkB/WP4nFfjJATx/hxpkA/s7P8+vJ2PwzrDZYGePlQPDiWfFOmznUzUCs4BSadYlMaeDLdKMFjTDYSjDBC52TJqfqIQB+7HOdhP7rFjwtMpzz7rviDv6yzhcS2B6YHuM7Ah7hB/UZOSRNJKCbuIjXKcxVrDHNVW+VwvK2E5LfsTCSs/RoMBkRZZxh0p+SzgmDfGumKvjFFDrPefkihddVR+Xk/mKzHX9uD35G0stQWpJbNXrmHYyFmwtlH3SorksvgjTyQzemaPAt+RpYqi4fNPD2LsEHUzKThghf5yuJo//+lylMWKFmERk69OdClViSAByji1kXON1hC3KBzE79g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVcT2mG80vYds1Il13lslgyVg554GSkY5F659bj+2Xk=;
 b=wLZ+gMnG3qxBbcVRByM64CudMT59ToMbSvxQHfAOxeRBJ2C50fSXR+Fu9K1bNhhB7saWFz/wWHJHqj7w+4L/3aclu43kYvkWtt+iZkiN48KhvvTimh+7tDf3I7mY5w+2WR77KPHLR7Kmj0+mwBwa8L5E3A74d9C2prD7V1sypfz8d0sskoL1nvsV1kDNTX8KMvllEj6FAPOtH0mGKeszs3R+QMv1VvnW4DFJtzcjH0pa0/+s8ej3tQe+zb+OkhHGtGoqGGcLYYR0T3eBCQXlsyMnW+B1oliDfFJ6oWrOZmjpdlkUiuJxUNBquIea0qoRwLKNSUPhfW+JjWyjiG+Ivw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVcT2mG80vYds1Il13lslgyVg554GSkY5F659bj+2Xk=;
 b=eIcmSUMFeHvGLYmnVLx3RFb4GwYDPszyErYHTy2tjeR+ScZPbssoA4siKkTKGjuNGa3cXuG14b0D+DY5UKPXrNhw0H09s71E9z8d5S06wKj0tE98N4v1OZbjVfAzM5HXDnJj8GR2tXdK7JF/ASnrp3o2zVq51Tnk1IR77I8ZNfw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:50 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:50 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 08/27] libmultipath: Add support for block device IOCTL
Date: Tue,  1 Sep 2026 10:45:07 +0000
Message-ID: <20260901104526.3850621-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0018.namprd19.prod.outlook.com
 (2603:10b6:610:4d::28) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a2dd8b5-7ee2-4a89-ff3e-08df0816301e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|5023799004|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	udqZmqESak9vbgKc2KzOqqMaM06IjeaFgv1lUME9O/Rn6liwxGUd8UdG5e+oAPjZK0K2X6Fhm6XM2nUV2SKDzr+jUkbM9gHeHJEszKbiWJ3SL8lKEFs9P6hDtxnpaSIirWdhq+R3urxXByyghN3oundtVPgaha3r3z+GKIrLQ9G97loNDeyne337tl/2IlVIC121mqkTAkvlWgVDUBc7sAnFKNAwcEZmJikVgNcUVdmaYlJHctwxjsmWnuoS68aam/MyqNe94bhCACMFPSQ/QVH+zKCsAIGhZ0duZj+RoPZg69hMvBm6RFnQtSfnjpPzhruIwxLZf9tCx9K9fbcSzwRPsHxSDLFWK/7fKIOTKueBaY6Ug1JhDa8kdnWV4VPkqLempHox49uH5EXdWWa4b6iYKVUYHWEX4NlP3wZwJVEC77M++XX0n6o9OEAVlYoDWJXHKQBbyeDqaxFZDOo3V6WKq+o2rXag/2ENxOTuQpCP6wFp2e5lWX2ZNoXKs7mfHgRjaOK9x2GJ6xXNcTl/E6wnjhopWPCEHobIVFsxNJlur2hKHf1RilLB/1PvhSo0r9xxp1dG+DrMm8+P3AWuj8iYvKc1zZZTGc+rGrr4iPu3/5zUSJUBzV3K1RkOeQsbKZ7ELhdzQBwF7dsC/SOCV0zfNlSJFC4y3U43jpEPM3M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(5023799004)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pugpyrzM6Ieh85fAp5O6xi9CiZHB0EC0+lZK9je2tF24SLOAF/jPB1W0i4mh?=
 =?us-ascii?Q?TzN+8AkCqvaUBbobLBRWjcmTGVQurZhkfzrneiKiHikDKjjcFjQr90ACSFw/?=
 =?us-ascii?Q?X4CirxOcV/v514wPig0eizqwKyAknsVA0IQOUS4XRS6HcII3f87CxfhZEw11?=
 =?us-ascii?Q?Hcy3R0RypmwBFGOpCqj+Pn/XsBm5wx8Ml5uNOBO91soaTFifcN7lg4X0ZWmO?=
 =?us-ascii?Q?+0dZOcU+IeR6rtVP9Lw+dSGgRYx2P/LszbZEcITOQAuD4jcJIZ9pjNo+/nbs?=
 =?us-ascii?Q?Ggd3zDlBk4Q+zq0pOBdsjrrk1iQrHBWXwkKiaY7OBIopjRthvehplA81nwJk?=
 =?us-ascii?Q?+VWXXxpn4IaC5L7fdYID+RyAccQrcvV5k/lV38bPcBJfX/hWkLTg+zu2q+80?=
 =?us-ascii?Q?uusRYZOTA+PjWqNmfawAVFAVP3+T+m5dAIYgIzwM9w31Wz1zLdJs3Py5DuPO?=
 =?us-ascii?Q?BImOEtYuYQ7fPNAxlaytYLCLaAqi3XFqMqLMhh8eIKeBZ30V9ghJ+zudNQ5c?=
 =?us-ascii?Q?Kdqiw56rkT/WyRF3P3h+UIMtJqxYyjFDXR4hMVVHpyjKlEudbur/ZsMEUPSl?=
 =?us-ascii?Q?d6d2OZmbYV6DrjEekr96npzVxW1wkLaxgyh3NFREiF64j41C/dKF3Pyfkrjd?=
 =?us-ascii?Q?ESASSwHREgdccaadnAx013uhgV0l8wVvyLWnSwNK7AC8xDxnpWSya+vdwFnq?=
 =?us-ascii?Q?b222Owneh2yFlhawvxBHK4C7JWSpjCKY1/B1bR/YZ7fdUpKOu9sYI62hICAb?=
 =?us-ascii?Q?Qy0lHVnowJXkB3XHPvjImCCah8qnI+s6iVxCLdT9MiVCUMcgWbfPEN8G121Y?=
 =?us-ascii?Q?S91IE0BgOEgpevmPebyGRmjGFQZ2BGnL5x9asX6Cr05e4EDX4M11zs99bmB6?=
 =?us-ascii?Q?CguoWyPVsTUJz/eEG7M9Zi0Ui1Qui3FFgw9ICPOPlXt9yK4j6Wqe8QDT7OUr?=
 =?us-ascii?Q?OmLL/40n1cWa5dKAsTY4cqpPuvn1HgjnT7z5ueDQeT9x7TY/kzdlOddlKZ3U?=
 =?us-ascii?Q?QgDAQZMf1laFoAgZ1RJ2Zu5pZa3SV80jPl21VOzHyuSbhC5hHhxiIiFFtWXE?=
 =?us-ascii?Q?q+L4Y+vC68+DDXWATqj2hO4xMNn2nZkKQSdXdcU5aZXq0tMbuLaiAaXBpFje?=
 =?us-ascii?Q?/pUn/hlVb5VdpIkaxFSWNTNnihBR1SCOSOQyin8lUdxdlHoGatGy2KFXmcdQ?=
 =?us-ascii?Q?LSlo+6JZzpx9Cr3UjpEveFNrXV2K47IbRBa7yYVWU8aPAFl5On+VfK8KhYyl?=
 =?us-ascii?Q?Hb2YaZ1g2ONFwQP6RxoMLZ/cnKAR8CR1Aiw3/0SVZn8aAzn18Xa4Hcl4C5bm?=
 =?us-ascii?Q?j90tdMbjdAStRRim75RSCrgirUix5YwLIzLymDTttzyEhVxp2d/CEroX1P4N?=
 =?us-ascii?Q?h2lb+qvHeTgu8byDX9W2UTbfl5QJ0W6jJOUFX+KuQ7vB0B26xX2femZlxBb6?=
 =?us-ascii?Q?w6ux/4h/4u42eMaycxjN95/1oOCkb2ecnmmTEqvXKl7YaW8YYgY5oW9S2UrW?=
 =?us-ascii?Q?ykajDgQT7fLPG4rPLdyjEgrFC5TstmxDc1wM9gsRelA0w4kyftNw0kH0Klup?=
 =?us-ascii?Q?RzV7NCiUT0rfwKv1r95gGRYbAkcMPLdH9U2mHQJJ5I0nExLgrxxktU1H92iz?=
 =?us-ascii?Q?scLSxZhK6Jkqm01nNzCIUCXDzawkxVCzZjYyL1WnP4jyg0wXosVXrUykEKUJ?=
 =?us-ascii?Q?yQnIYrbo4XjSvx/aodisRO39SgjCucwK7sayi2EBFhlR93fSuki48RCOIort?=
 =?us-ascii?Q?JTEvw2C1lA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Xc9TNJeiadLSX7Hrkpdgrb4Tz4s9ln5dSwVilm+CBtAABCkZ/XDIi2swr5Pvt7aRBiMh0/8zSKM0c7r1pRtSK3nXY0ApjRlRXlt4KQO1X6IGRXAu8hiq/kH+luNUKV9/utTYsc1U/ecnwKdw9QnryvOx6qaRZBMoEb0stj7U3SZn1Ff96ooYcXF3zdodw5n11Thi91l9ziN5fH3+f4jakIkqbVTSWCm2Gcc47ohSDEl/SPiHpEOGlRegUU77nkejXK9R2IJQC9pqXkTZt7A6eFJgZyrUocJCn+SeIpG3RyNQI3vpYkTClqrplD85iR83NiJGHbUSUxvPr6tXel+RoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2UoBcMyJUnC6pGqEs6EgcGj5W06X1ulv5/HRxjfmqzm6rrekBjYTEHAcTxANYxLWdFRcNtVNJyaV+2KtorrMpdIEmtjnURJCqOPjESwhQ4sp4yNi8mm8u3dUpGZibn8hYWLzl3Qx1tyJbbRJvFa4iS/dON84pUPt6HaaYHzUSO5dXWDqIoZHe5VN9rlJMrUR1V6d4QjD9PNmVqLVvNlKDRo9wbHMccqUuyRUzizQG8Y8FWMNFknLaNJ6lGi4B4Enk/pKpNR0TIqqRA8+qA0eKKasH/u8u4hQ0ekLw+lj6WM0FJtIl6YFwpLt0MIzCWEbGi03g9gzF5vxGWMXrV0KWkGmaJsPqXnezunV6JNBHwh2Wi8hMzaH1DUg4UEYREaWoM46HU6/gRHRTdgjBbmXDKf4eO6FwLjfrXaRcxq+5RqA0PaK3P3OmbQAReUXxr49XP7M8YtDO5704Tiq8GqMn6w2Vq/mDYu79gaSvaP9FNzumQoezu/QE5OUd4L2+7rmS8LffjOyHMllMN0wUJtN7zaXFTxvtVmrRmSlj6h7fKC+x18yrYImfJ8wxAhACJ+WC/qChpb6bt0y7bsMEiXoXpSR4jIHtdGuEy34zzym69w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2dd8b5-7ee2-4a89-ff3e-08df0816301e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:50.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppXwQN0MslgSXWpHTRJO55dxzkNCYf+mhcQmjRf5vwi6PuZfLbRphRZs5JFBBGPMhIOz65tnHdLGWIN+R3Emkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX5rbZBK6/qMJ/
 oyauG7ahvOl+wptzO6/bzMUij7rJBkO7pHY0bcl1/ZKCmKqcXd8eLPO/tQVQ3BgQOVqodkZYpmg
 9D3K3wmBkYskeTfHMpAFR8KLagpEyHikw0P3CkofdvjRbhrbmm7OYXuJekbcMZwIrdQeCjoFi5S
 E4A8EYNRB/iZccuoJJU4MHC9T5jBsAkptQQZZTx3oDZ9X0BA0tMCyS77Ks50Omtrj4CegvIPT2H
 Vev4yPglhIaz8YAGA0EjqngGyusUR7y+ViqvZF3qXLB+GQg4pNxe92xEzyZU5Opjfm1saKXNCkM
 fa0ECc/grAPo3agzRUqCp+BCzLlDgdM41PExvnKKQ5Dv1PuQ8fJrnDFFs2RwWP/16YXk5BLBVaj
 zIgh1JqXQ7F2hZnyDvgv2fgLMhTEsOwgLUBPSMSJ+iVEqYZtbnmUkFTGDYthMTwGGKPgzRjOZD4
 RbBrF7mIlXiM6LKGKDqLwGIbDBMpmCH1XuC0FPh4=
X-Proofpoint-ORIG-GUID: fXBHZo55Vqn3JPOTodMRJ3-qC2OPJMVV
X-Authority-Analysis: v=2.4 cv=fbCdDUQF c=1 sm=1 tr=0 ts=6a96ace8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=MdnUEikRHl3WmUNKqWUA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: fXBHZo55Vqn3JPOTodMRJ3-qC2OPJMVV
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX1S1oDducxEVa
 CfG6z3LjZB8OK/6iCggSyDrI1f15xbLiU97FqCt21p8em95M2vPFq2P5kZg7l2ShFEUBOYSfF1W
 uxLoIdCwyofYBDtIxWP/KLD+W/9VKoGKyqt+oRmVw80xbTcqZYwP

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 58eb9be5bebbe..f1758d1e60a60 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -454,11 +454,53 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+
+	/*
+	 * This check is duplicated from sd_ioctl() as we don't pass the
+	 * partition bdev to fops->ioctl. That is not yet possible as the
+	 * per-path disk is hidden and, as such, does not have partitions
+	 * scanned.
+	 */
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
+		return -ENOIOCTLCMD;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (!mpath_device->disk->fops->ioctl) {
+		err = -ENOTTY;
+		goto out_unlock;
+	}
+
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	/*
+	 * Both NVMe and SCSI use generic blkdev_compat_ptr_ioctl, so would
+	 * avoid their custom compat_ioctl implementation.
+	 */
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

