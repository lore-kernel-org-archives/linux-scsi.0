Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD043D6697;
	Wed, 25 Feb 2026 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033608; cv=fail; b=bKJ2dNmEzaj8Qsv88Opd1bPs4PSYdUVSaxCe7ptTQNHW0u5v1y2UlwVtyZ/oxFZXadjfk6vkABSjAeGR+Wj5C0cBFVbyRV6OWZcASoThI7lPwGcfIUhOfxAHfLbutVtaDuaQenhOr7dkdExeo8H+OW7ZVIO+YvqwNsnij5+zqK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033608; c=relaxed/simple;
	bh=lNTNuUDL/tevqqEhoVpE5VS+pmQkzk22076QE52F3wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fobxDg3f8qQG3Wg0vP6S1n+iVka5N4MEhb+YTuIsQ/rrZcWy8Y+OMn2Vr04azh11zkbc9/Y+vU0+dMRG0XHZdYiUfnogm6VTZ7Aqi5dZq3sSXUTdx2uVznpsksQ9Xgs6xHteHV6FzAcMNssk7vwtlwOBUewlRB4vCHotzUbf3iQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dzH41l/x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mMOBL+/p; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dzH41l/x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mMOBL+/p"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9oPug4019329;
	Wed, 25 Feb 2026 15:33:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/waYs5J+K6nGAKm0Wn+VmXs/c0fm4MONGmFcHfqY2GY=; b=
	dzH41l/xCiFLiTlfK0gi+0IHX5Eh8WjrdnVr2lrg8FCPzv23ma34L0SrO2nXMe9U
	/I4gkaXEzEAfT+3nMeLnTbQR5vTwLRHcokNJt3Qa3Aa8/SsWM0r384OQxoFQrq/0
	6v3/+e5q+DQhFyjfYHzO6S2bQMcU3V3RXRzFVxthEpPDZutKp472jGa44/0+PG93
	xzLLY0xCffzvJ8Yq5Bpqffyx4asg9oHKaHu4FMFrbo73m5NlWLTJyFdB9O5S7PP1
	ntiEiQskshlKxzzck8wFHp1KKcV6ph6Ih24jjWdhXT6uGuMzpW3mrAkjCZ7EskZh
	tW95q+CC9eCPkH35PtbJVQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a06gw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEE0ZK006327;
	Wed, 25 Feb 2026 15:33:04 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg4wn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ny9BOmaKtCjnJupTc1rm2EyVK+GIfO2XZxQLleHWiLYfmFugZvwdIPmKEUcX1dMmHITkyxqLEhSWt7yPuNjNfBd+WGpT33ClfTiifxylnfp5kzyjfhGiPtWepL/Q/fSm6ZsGcDQ5Hp40RK1eMb6Ugv2xkMzZxQvKJDha14YxCBsyxVdvvjwfsTQ3Q0l2JXiI2O45j//FIWlDYAVam9UF5XWrRCrO5kdz/xbSu2CRzH1RaS8xpEc7Gk+b1MtsQ3GQTOMospJK9q4mnUB4WxFLxr8nfpoFy1+cMLNvZ0Er3tUKun1sLRVvz0QDxv/AA9djXDDGhxRFq+Wp7Pl+tuN1tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/waYs5J+K6nGAKm0Wn+VmXs/c0fm4MONGmFcHfqY2GY=;
 b=peUG3U6cM2/5V7FYwEydOYgYoc6QgoNUHS1XkT/KhxWIdDNIH2mN7vlSzkiJtaDfQwgHgCyOdNtNisSk06QWKcwF5CTRzaGHbOadzWmeis+HVvXsSIJ9kpwYMw9noKuc04ZFVCkBrxrFmaUrd8eYPqoKNT1zj2yvvRihVAAvFh8yGrzP/i3V/67H8MKX4uA2l/kTubU2pWy32KsD7eJqtblLjtYyIJymraQ4+NuZnlref2vMHShB8TGr++35aIBEuuEOmPOdOq6rKH4VOI2fo5Qfdr7uznOmB4S4quWzchFJRSpLjaIW/H1AA4+dVkUwqKb+fkfakqNsw+FHaco1Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/waYs5J+K6nGAKm0Wn+VmXs/c0fm4MONGmFcHfqY2GY=;
 b=mMOBL+/pzvsV7C0a2tN6MKFrArAGphGY9VsZYgfFQCvhSj5MJ7BIUdD/RN3leyNc51z7C+eWrYEoIFWun5R6aINz4BH70ayndq3megmzt49SNJ1cDb4uiublMEEk5lmkySRX9idDgKhIUWDIXktnSNRyiC+UJf+kOxTbHWOW5YI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:00 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:00 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 05/13] libmultipath: Add support for mpath_device management
Date: Wed, 25 Feb 2026 15:32:17 +0000
Message-ID: <20260225153225.1031169-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:610:b0::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: c1f885f7-fe23-459d-9669-08de74832864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	k8ykYFSl8opUQAg7QJLACWovQKAcbnXzkmwbDNXACpvxHupKpz0cK4JOzPitSUMFPuv9ij8eErm5My4Sui92Qt7J8/H/XJqE/K4tGh5ebjGiY6gTxKvL6XVlVF39B8J0lcfBrbJgAAErbwjVdjvuzzbQbRM1PC6hJT2EBvODpMbh7WwKZjzlAfe0Ak2aWSHCS97IAKU73sPqPw/A0wRQ+daYuAfo/BujqvnwaFsZq069YM5vd++Qh9uYwwVGJXw1qTrBLIpmCpa/JLMH2roS6b5sUVRuN3H/YDaPjY7yGlz8DW93Po9bwgTtz8eK/VUYHrGvUtzf/A7FkZV4OldMgXkyiKRxDI7DSVMp9f5j5/vVo1KhcL1+CxzNwf2tyZ3Mrek+AB4uzW5BEmF91h9D6qJ4LE4Uwr//CsgSOcSbIwcn/hVkJkgm0V0EnonrzspXM3O70fc60UYSWfiwAn9FuiWXDqAS6qKB+8T0XvID/UOffIUaJDIiY2RwU8PiqZYEe4FsC7P/1/+ZSZGqQw2obSYwGy0qJxeMJhkSJNuOGQPz8RzOt51PBEs1vVfXvvn4Guwjlox4B4lwcMhzi3R9CZdk5ftDirn7xcDNSH+SYiajqDpZsgDbQw/c9vrlm0hh5duN+h7Gb008iL0Gd9gh766bIBT2J5gue/5mOPkyD/kKdlKjocWZ0k8uorh4js3UDNgBIkODxm/zhha7MdAx2xv8f9v8Q0wPkiZBW3VacCo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rRDg3qHCTfi1aUG7d9wQf2C6Rx4min5LJkyrmMYNB0s5gXGE3eqhZYiARhZ5?=
 =?us-ascii?Q?ljyCKlCG885UEX1ESm39eYz3H4lBOaV9ruAbSzq/FKVcPgWqKIYIR+w1DZHQ?=
 =?us-ascii?Q?4X4ARAkV1VEzVcMcOMpq4bBqibT1Nhjq60KuYcMZ8f000F5W8kYXJkRpDC5r?=
 =?us-ascii?Q?XqH1YQMc0LgEQcKLAsY+u3BS/dPi7CDNj6wB2rLR4LQG07yjQ39Ken2J1nsU?=
 =?us-ascii?Q?jqoezKMyj+jx4wbkqhU0bUGZh5lJGPPZADFMc2KVwiryyNviSlVTbwqK6/kz?=
 =?us-ascii?Q?oNrHYpWuLhCPQRiHBN4QKJwxz7hcsGYXoEYMYer3ULtgqfRSiQcaPl7CM+Ks?=
 =?us-ascii?Q?zdfiI2rHfvuR+3yPuI5owKDfD5wiWGYgQJKKLdcaAj0+1YxeBMCM7cGvFR2S?=
 =?us-ascii?Q?rsUak9oI8NOrgVzKenTZiFl6nsV62Bri0S6m6N4O1Ek4OkOdUR1C46z7jtLE?=
 =?us-ascii?Q?dsDd6hSXHUcmsYeeYMZ5lvOwz0y9ANUMoz1kNgIeT/nwfJIJ0r4pLq8AwOSA?=
 =?us-ascii?Q?uuYhCphMbM6HYi9JgyFXbK3aA049OHbLpX/M73g70afpUm3aNLX78CONwh8Y?=
 =?us-ascii?Q?dFyyKFEZ3T/DJ9kYga2w57GAHwIjX92HVyu2zkU07VgaHh4QPT7fBgn9TlTu?=
 =?us-ascii?Q?LBSwY6Pbniju37APwZS8A4AImOnckXuSxgABgOVHlRHfnA24BN0Pbc86B/E2?=
 =?us-ascii?Q?Hoa31AgEyEPPusAMCWKPv4yyRCsVJAkouGTY5I+Z1fDR7LC8xKWReLxt5ziW?=
 =?us-ascii?Q?NKjAHkNzLPyG8vEluqLCR74cb9uIuC0dhSa1PTVLoRse7p7rF5Oxi0d0Bfa7?=
 =?us-ascii?Q?BsIh1RQH8iJko2ERyavpqZpnR3IJuuuox2QICav5k6vA32Lc7ooA6eK867p9?=
 =?us-ascii?Q?i7cqjXNE2UKjwvX9DqZJatYzrIrk2Y+r0GAH9lT0ixqlTLmQYy9+WclkUui9?=
 =?us-ascii?Q?ubOxnRmbBV/47e4F0dWd49e5yBoFJtzy7jDwXjbkuIkb8l5T2g1EIJzt/iK3?=
 =?us-ascii?Q?96ugvPRKLCGroqUdhEiiGePuUWnVMowQBcZR5fU7HPw3vsQbTZDDwdepu6BK?=
 =?us-ascii?Q?XiDTCg9+44MPxFnKt6fzxyDJProsadMEp5EJyWOtgah0lNTldIlQJhD8EkTZ?=
 =?us-ascii?Q?RyMyAMbgelhXzBoTtdfoe8P1guwQoodV818/oBihmizNhZZu6SyPz5sJmtR8?=
 =?us-ascii?Q?f8fYDSI6Z300uvZ/XniogqRLahgHu2MD6KTqKhQDHFKs7coyNwm0uBjCmLbS?=
 =?us-ascii?Q?6eL36mv6u3x3WYBY9Wj6JMcO3e7iGnx9coms9LzLffXbOzEErfmiyfSVIPj/?=
 =?us-ascii?Q?NkGJyXyT8OLmDza5vOprR/LEiJJLS7bf+TPk/SA42hWREBW0K5sJaEWwNi+r?=
 =?us-ascii?Q?M7WVddaCk/+fMo/r3pKP3ckAbl7M5cCsaqXBLKKGypJXyjQy9MxRVsz8KRJq?=
 =?us-ascii?Q?bhugb32g6bl+3PWmPZM4iq3TeFt+OoYJubuhXzpONV6Fjv9o6XYgJfsFC+Sl?=
 =?us-ascii?Q?Jmn2bnp1FJYOkuNmvyuv3VZ+0kxrnySC9jVfXW7tlHRtDco9WkSU/IBcfw0a?=
 =?us-ascii?Q?30u087fs9+b0ckhdo0/JO92i2P/AXf+OQSIr2BTjJh91Aqh/aZJBS/hcyznX?=
 =?us-ascii?Q?bKdOrRXxPIXPLzVvrqV/1sT3hEfRX2B4Gq/YCiq759X5wZgQMRr28uTunjCJ?=
 =?us-ascii?Q?tgcLO8hEleSiXCahQZATkKUwyhD4Cqmxc9ftjkQ39CmWv8sd64/2LyBqG+JM?=
 =?us-ascii?Q?/oDIqykCzHkkjsCsyocch8GDLzTXDzc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z52buNLoEtOpqQ6mOf6bW3KyS2s6e8MBEuD6TEeOBANHp7rTb2eWNtac2Uhx6N5pAfHozevbmRxGvjWaj9wO1z6C6gcotz9FEoLsGOZXSfvoa307eOG/DGlo4Eepm7YW11UKC0GRYm1lm9oXFEge40fkqJ/cnxvkgieXm4QMLFO2Ks6RvTW247EQjVB8zhRkQ4+qGtup7hdMvb+U3z3VAwTkLMx/rX/TE3N097XK9lGrKzjNbZSg9hg3S3YNnCHJvvveSVY1H6ekX5jU/AKpaO4WvmiCmdIVulhLEFJZfzULcwmnGgxrv4mgD9Ze6uBTfTcZFFKtZtHqXBhFBgj9OzJXmKLNyIopfxTo9FtZrKER6bZ4p1fX/kB01CWXj0AebuslyZ3OPFVP4zVI2byLYb2uF7mHDId8zqEQpiOocqi0JY7y/pVckFACidyqmr62Xilyjsqg4MiPV247lttjoiVMnNuSSdobJ6j18th9QQtgw3RjHkIERZi7eb8r9MFY4tgbaVya+yjRQxWdrG1QYFNTnXiwkH/xwmoZFX6C01JHKWM7z8ziSyWebexR3HB7seS6F5497sISHLVusWlVSYYu7soLQ8Ugp7QlUFq22jI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f885f7-fe23-459d-9669-08de74832864
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:00.3970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYDWOTMVrxqW8g+rXIVr0VsJTo4YBfrYVkox4bk+0FBh7Jrcsfq1Jyr/1w5oKNM4Ap45a27KIIzWRQlVAEFNjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699f1630 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=ldRTlTcT5PaS6-tWTisA:9
X-Proofpoint-ORIG-GUID: rwDpJpnQaeP9xFPuaE66H_cHnS2q6Z2p
X-Proofpoint-GUID: rwDpJpnQaeP9xFPuaE66H_cHnS2q6Z2p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfXwAhLuQYrsuf1
 bCx/I4IdGkDiTlZRxOMj14PVYfVGeVw5sfVovoQZoJZGelLU2y0+YeSCbHBS0H/5ypBfb2B740l
 te6Fw6iYX1Sj+meD9TX1mcgYdrw+1MxERtJ3LbL/nVXtCyJAeSM92HG0r+FlXJ6RHP8OUS6zYn2
 qrL+u1BX1rwBaTEkZEf4Xt/fuBR3pHfagBz8pkt0Sxuje3BRrkg1xZ16qzr5n4T0S5Mg4aCOxaG
 CurHXmtGGO2p9Pp+IeB7D2KPQsmyOuP7zQ37wGqd5R+mXOoYL2wSiQlXq5eD7wBFAsv3Zl7z40+
 5p3cdExOJs9biFCGrvEEg4WHYiqM7LR0W0u1N7mhFsLj6hEj6YwPuyOMM7PkdhB85eTUA1UHXSf
 DSr2JehFNG6iWAhl6vRnbj8rf3oJYPEvthNNhhPYcKy2OiZq95Xb3ZSXxHrXKStjVoBG8xUDiAJ
 BcAiYgXVtV1BHfLkIxw==

Add support to add or remove a mpath_device as a path.

NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

mpath_revalidate_paths() has a CB arg for NVMe specific handling.

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

Helper mpath_call_for_device() is added to allow a driver run a callback
on any path available. It is intended to be used for occasions when the
NVMe drivers accesses the list of paths outside its multipath code, like
NVMe sysfs.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  18 ++++
 lib/multipath.c           | 169 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 186 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index d557fb9bab4c9..4255b73de56b2 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -33,10 +33,13 @@ struct mpath_disk {
 	struct device		*parent;
 };
 
+#define MPATH_DEVICE_SYSFS_ATTR_LINK      0
+
 struct mpath_device {
 	struct list_head	siblings;
 	atomic_t		nr_active;
 	struct gendisk		*disk;
+	unsigned long		flags;
 	int			numa_node;
 };
 
@@ -94,6 +97,21 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
 void mpath_synchronize(struct mpath_head *mpath_head);
 int mpath_set_iopolicy(const char *val, int *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
+bool mpath_clear_current_path(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device);
+void mpath_synchronize(struct mpath_head *mpath_head);
+void mpath_add_device(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device);
+void mpath_delete_device(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device);
+int mpath_call_for_device(struct mpath_head *mpath_head,
+			int (*cb)(struct mpath_device *mpath_device));
+void mpath_clear_paths(struct mpath_head *mpath_head);
+void mpath_revalidate_paths(struct mpath_disk *mpath_disk,
+	void (*cb)(struct mpath_device *mpath_device, sector_t capacity));
+void mpath_add_sysfs_link(struct mpath_disk *mpath_disk);
+void mpath_remove_sysfs_link(struct mpath_disk *mpath_disk,
+				struct mpath_device *mpath_device);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 void mpath_requeue_work(struct work_struct *work);
diff --git a/lib/multipath.c b/lib/multipath.c
index b494b35e8dccc..7f3b0cccf053b 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -40,13 +40,108 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
-
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
 }
 EXPORT_SYMBOL_GPL(mpath_synchronize);
 
+void mpath_add_device(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device)
+{
+	mutex_lock(&mpath_head->lock);
+	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+}
+EXPORT_SYMBOL_GPL(mpath_add_device);
+
+void mpath_delete_device(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device)
+{
+	mutex_lock(&mpath_head->lock);
+	list_del_rcu(&mpath_device->siblings);
+	mutex_unlock(&mpath_head->lock);
+}
+EXPORT_SYMBOL_GPL(mpath_delete_device);
+
+int mpath_call_for_device(struct mpath_head *mpath_head,
+			int (*cb)(struct mpath_device *mpath_device))
+{
+	struct mpath_device *mpath_device;
+	int ret = -EWOULDBLOCK, srcu_idx;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device)
+		ret = cb(mpath_device);
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_call_for_device);
+
+bool mpath_clear_current_path(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device)
+{
+	bool changed = false;
+	int node;
+
+	if (!mpath_head)
+		goto out;
+
+	for_each_node(node) {
+		if (mpath_device ==
+			rcu_access_pointer(mpath_head->current_path[node])) {
+			rcu_assign_pointer(mpath_head->current_path[node],
+				NULL);
+			changed = true;
+		}
+	}
+out:
+	return changed;
+}
+EXPORT_SYMBOL_GPL(mpath_clear_current_path);
+
+static void mpath_revalidate_paths_iter(struct mpath_disk *mpath_disk,
+	void (*cb)(struct mpath_device *mpath_device, sector_t capacity))
+{
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	sector_t capacity = get_capacity(mpath_disk->disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	if (!cb)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		cb(mpath_device, capacity);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
+void mpath_clear_paths(struct mpath_head *mpath_head)
+{
+	int node;
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_head->current_path[node], NULL);
+}
+EXPORT_SYMBOL_GPL(mpath_clear_paths);
+
+void mpath_revalidate_paths(struct mpath_disk *mpath_disk,
+	void (*cb)(struct mpath_device *mpath_device, sector_t capacity))
+{
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+
+	mpath_revalidate_paths_iter(mpath_disk, cb);
+	mpath_clear_paths(mpath_head);
+
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
+EXPORT_SYMBOL_GPL(mpath_revalidate_paths);
+
 static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
 				struct mpath_device *mpath_device)
 {
@@ -480,6 +575,8 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
 		queue_work(mpath_wq, &mpath_disk->partition_scan_work);
 	}
 
+	mpath_add_sysfs_link(mpath_disk);
+
 	mutex_lock(&mpath_head->lock);
 	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
 		int node, srcu_idx;
@@ -498,6 +595,76 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+void mpath_add_sysfs_link(struct mpath_disk *mpath_disk)
+{
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct device *target;
+	struct device *source;
+	int rc, srcu_idx;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_device *mpath_device;
+
+	/*
+	 * Ensure head disk node is already added otherwise we may get invalid
+	 * kobj for head disk node
+	 */
+	if (!test_bit(GD_ADDED, &mpath_disk->disk->state))
+		return;
+
+	mpath_gd_kobj = &disk_to_dev(mpath_disk->disk)->kobj;
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
+			continue;
+
+		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+			continue;
+
+		target = disk_to_dev(mpath_device->disk);
+		source = disk_to_dev(mpath_disk->disk);
+		/*
+		 * Create sysfs link from head gendisk kobject @kobj to the
+		 * ns path gendisk kobject @target->kobj.
+		 */
+		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
+				&target->kobj, dev_name(target));
+
+		if (unlikely(rc)) {
+			dev_err(disk_to_dev(mpath_disk->disk),
+					"failed to create link to %s rc=%d\n",
+					dev_name(target), rc);
+			clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+		} else {
+			dev_info(source, "Created multipath sysfs link to %s\n",
+					mpath_device->disk->disk_name);
+		}
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_add_sysfs_link);
+
+void mpath_remove_sysfs_link(struct mpath_disk *mpath_disk,
+				struct mpath_device *mpath_device)
+{
+	struct device *target;
+	struct kobject *mpath_gd_kobj;
+
+	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+		return;
+
+	target = disk_to_dev(mpath_device->disk);
+	mpath_gd_kobj = &disk_to_dev(mpath_disk->disk)->kobj;
+
+	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
+			dev_name(target));
+
+	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+}
+EXPORT_SYMBOL_GPL(mpath_remove_sysfs_link);
+
 struct mpath_head *mpath_alloc_head(void)
 {
 	struct mpath_head *mpath_head;
-- 
2.43.5

