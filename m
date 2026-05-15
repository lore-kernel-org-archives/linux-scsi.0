Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC1D3B9D96;
	Fri, 15 May 2026 02:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778812071; cv=fail; b=X/KKkQMbhc/xYLc8SuAzom4dRro1IKYkxr/qExRBCXuk2+Gqv9diy2t6DskD/Zn2hDQClhwXe24tzbKF6hfVHUqeEZRKcuRx8xsBlRmPbTggZd6FdHeUAdMXgZk0XjuIUNIf87i357c1qnzDb+hzRk51oQKMXqUoOojeh+Pv2UU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778812071; c=relaxed/simple;
	bh=G3pLmgCE6IWpLsMYn09QEXvd2xQ5AWLujCHQGuZdrDI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=L8wfzLrFMFHTgF2jpkkYQmqd/imqNUJDouaWDupRDju/eB43R5R9ZG3VT/dweraB3GW9NDdlcaOJY7gP6rp2n2Ywb9QSrU1TJJff0U5NABXnoYI9VGUlJpxHlG6zCotSaTAqInCjto9kncy4YgK0qX++EX234fW9YoqMWp/hNVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PVDsUor9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x/9hpWxe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PVDsUor9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x/9hpWxe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0U1hY3652689;
	Fri, 15 May 2026 02:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MxSfIEscg9zJi+Vvzk
	gbPD9N0piPwI9Y0p4nrESR48U=; b=PVDsUor9KevyKXguDzvqzkCrc3lS7p9ZWX
	kvwENqxWV7SnI23o0cydKmW9Gf5gDpVzK4FW0ZSg/+fQeN4VYzoO8SahMzvx8dew
	/NQXOF1PyxYchXHgAXmptc9FMf/hO+UqRO4Al7r9zr+Sh2QdxHscYBKa7Zn0Vns/
	2UU4RbTTg9s+nfE7WkH4jFL0v6chf7dw6+fOIfPtWi8M4BU3bpBofDTAsLuI5xwm
	yk5doERKhruaJBrV+XI536zBbjV0pFQSwN3YxwOdyiKjWpZQ9Z1NdFEytvnUgIkJ
	NS5mrZRIc1zoFmHJL7Tz6RaKA0qDhXd5x1ZWI1CBnqR/0+fqDpiA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1t0e9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:27:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F2Omqd004200;
	Fri, 15 May 2026 02:27:47 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kvxn5r7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:27:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4VpqlbfRvfc+/IsGFIySTgKCmqoEWxueTutYuXMZgHVa7uvk5+pJu+sp1wMQzEK9nzqSA8/a1Hqx489i0gsfSjgJFla36Prw0ysZvZ6FrrwsQa/W7zahByQKNwG+wbfNHbS+YnECcOaPd4SwD0Yv8SSc3HMXZKjiXt4cpV5wXnlWszGS6asgG94Kee3EIFcSlpKjdCgZeKFm86inwJj0/MAufL8qoezNhzl0GVp8bachf8fPz1WbxiJK9OCFEvPMJwWCOUsploXyyDbTNDK/QTjdOK6kWt2iEzixPln0ZokCxLDf8cJ9RIsrSbBGmvhTieU6121X/yDV0ew6ZBK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxSfIEscg9zJi+VvzkgbPD9N0piPwI9Y0p4nrESR48U=;
 b=Wt0SS4P8asUKT3K3yNcHKCT7ff25qQu+xbsNyH5XTEhDxnH2LBbeYeAojarA+Of9Bn8Ek1vG+RvAbTKvOmMBAQy2XQ3pOt9b87LRWb3RJG5TrLhGE+WEks/uH6Bl4Spc5/UliiC62Q/FlwXDir8GP4npmI2t6l1u1NvEVZ3JZ9ltVJXjZgVBH0pTEr6O2Mh4g/reMMGVRU2lAkwHvNLi4zDNe2ttYeoM9NwQDXW1kk/CqLwmY5MJTGQUkOaVsWSMsuG1zP7uAe/BF92cItGQiOjIQPrrJ8/DyXWKsb6bMqoYKP+KgldLfrBMHS5OySlQdXh2Mg3BTosOzX6ky/uKiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxSfIEscg9zJi+VvzkgbPD9N0piPwI9Y0p4nrESR48U=;
 b=x/9hpWxeck/6R4A57Rchf6Z5sFc4UjRwMAa0Ec9qGU6zOTgcPIl87+rEQhSzr5q1T2+kXcSqmnQmq/OWMH3eIX3yla7wKxyyilBJKdEAsLP+y9CD1gHqpHKRkpO2GKoN0WtGW9Zo1edbY/EJ0gMKf1j/XwgZ632nhYCsyBbjyAE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF415C917DC.namprd10.prod.outlook.com (2603:10b6:f:fc00::d19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 02:27:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 02:27:41 +0000
To: Piotr Zarycki <piotr.zarycki@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: remove unused macro
 scu_get_command_request_logical_port
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260423081343.1813002-1-piotr.zarycki@gmail.com> (Piotr
	Zarycki's message of "Thu, 23 Apr 2026 10:13:43 +0200")
Organization: Oracle Corporation
Message-ID: <yq1jyt52yr0.fsf@ca-mkp.ca.oracle.com>
References: <20260423081343.1813002-1-piotr.zarycki@gmail.com>
Date: Thu, 14 May 2026 22:27:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF415C917DC:EE_
X-MS-Office365-Filtering-Correlation-Id: d4517206-c885-4a2f-96db-08deb22989f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TjLZbCfflT+5pjNVJlFY1X8jpEbM+5IY/Z1+X1/Tkprrju4Sy+we//5h6LAKZNqL9eHvZDXR01QigExCGyBf4f3codCxdP6/VA9yylDCx4sWjdh8OvYGmrnWGLG9+RoWMvrmNK2qtcj9A/ICzWTOAJkeVgf9LcUX42b257FurpRBKg8s0S6XWgj48Bo3+Bl3CGVciPCNPPf4ykWHxO1ljWPxlXVZKFgH+2DII1AvNMqDsg65JibsdsmDlTod1uBQk6z7vEM7+46g6pT3tRaHETEtjSBBYt3t/dNLwO3htxGTOpB54fgLbO/mgyQWUZv7jcv8PeC9MPZWtr7LTVNAzhVZr0l6u/Ro2Py058ZfalFUhYF3zkDztXYHm3qdkM1zcuArLqBFhsTIXVC4iJCGgeFQtaL3/Q55H65zrtXjmEDtAJzLbqYNTVJqJc3y2/dgzP0jbJDKaUNjWgCD9rIn/wpwAsEYkZL7L6GELPL4vmpu1IffFV0VvWXTJuDdN+4kpZlHwrh5WAkD9YGqbKTxf7SuMVsxe/ilPqKYbLwvpR8ZwjntsLCBPDA0KQa9Xto7BpSOcfK0EKUx4Yz2TpIwepp00/hOjuh5Xtk4iixohkkscMhWpUGlzfIMrR+LlzcHVZcEBQ1NDGOfD+qvdxNuimyqpQU5IAphR+/k0yhou5G9uD6V+nbva8T6/poScPed
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GbDnjfN+0o8QEThBcEftKLu9evOGD6TysQgo7wIdhjdtvUEsG027KhKy6V8/?=
 =?us-ascii?Q?pPwi9Qsi8mFmaX11+CbLqae4t9aeMYx/90DtotMFE3JCFaViU8rB48+7z+4p?=
 =?us-ascii?Q?h1HOLCOFKv2NCM5UJ9yuRFDu+7FTuzmh/FbVI6psM6OMpDYV9hH93lL36Wq9?=
 =?us-ascii?Q?FUMzq4JvDdwFd1XTjDGnDwgfE/7+4I99x1V/nosqD5et1tJZ6uL35Bkhsn2y?=
 =?us-ascii?Q?ERzDrznHc2r6lM90gvkrPiipbgVmtlXwO/Cm222Z54vsXKETWyIPFO1Ao/Yq?=
 =?us-ascii?Q?PZ1OXn5/gKPlhZdtbUiIQb+70l/rJrYIPHynawMRmi4ysdCvCB67n1Dlv2z2?=
 =?us-ascii?Q?aLUYbDodqrfNTdjBosPvhmh5gAIsOr2rUiCsVOmvrrv1wiq23aHDv1OvMyl9?=
 =?us-ascii?Q?tDrcHBCPeYsyMuAV27s3sjyWycKWBOqjh7/wn0vTIkgk18/XTjegsmVdpTzT?=
 =?us-ascii?Q?oMgPYCFrdKLHlTQtCVRpoDcNMwqxAau8fFeZi5czYPIyW/DmRPYWtqJGqhxY?=
 =?us-ascii?Q?0Xx0m/keDnio1PQwzgKkqlgzvnG1zmQKkrfwb5BlOWFJOQyGz7pSV1hhiUOM?=
 =?us-ascii?Q?ie1CK0Mu4NMtm1aNvZgUWS2LA6D8ZoP0h5/W17k/+44OiB9W3h2hXG/TUA06?=
 =?us-ascii?Q?8uJdC4L8pTC/ikVcY8YMNJTMiWhzHXG0Ljsa7EvK6vpozpFQe9f98EHNFimH?=
 =?us-ascii?Q?XLLzQFvemTSv8+TfkTWMdYG0kuzccdYEsSxbwRaRjRwRHnUrsErmRdL3lp3W?=
 =?us-ascii?Q?O6iaSY7+WyHpy8OQZp8kBhFVznyinYS/vc2MLWp/6G7niAIzqredJtOH+JV6?=
 =?us-ascii?Q?4zSOtzP+Ah+pOuhughk5fJexpcOUhehNsrqT8M1Z4jB7yg6OHKJifh18XD0V?=
 =?us-ascii?Q?ckqLHgxmF/p+zI95NV9QZXk5M3uY8JYoIsLLo/lMtaGNVwEQ862vfe3jSi08?=
 =?us-ascii?Q?a8XtIuvJDqUCD2U86Emz+mVzP7guaXFmyTBBPDd2WwecPqo/W3eEXQg42QJw?=
 =?us-ascii?Q?gg+Ie3EcQdmSKCe/WrGM+WAsvOnMV0Z/rtqqas0xt4xe8DwOzZ0J89ocRlax?=
 =?us-ascii?Q?VTDPB62QliiLjkOtC3enpCWWcMeabX+Yy6PYKFaxm9+ienYgNUe2eOUTFIov?=
 =?us-ascii?Q?Yq1eVBDCVxvp5lKsca0+Qs5uki3jeK81dHTZxIsb0AxTYmevyHVA0cErb3PT?=
 =?us-ascii?Q?zU26dpSq74v1YdXaMzG+fR/EhoSnAkZ6qmVqbJizQEHWkU2fK7WWVXHrRpYX?=
 =?us-ascii?Q?5bGBDpMC7+OEP2diXQ8g6j8rQxLEJ7R9eDEVW2k1DissJS2hhYY/gLWP0QAH?=
 =?us-ascii?Q?AaPD3+g8nnVSpL2Gbi9QWRWEQkEy3WNQi8evyuZ/nVi+TyU8X5+Qy/Xz2Vc5?=
 =?us-ascii?Q?VAbOFPNEvccFV/lScNlON3WkY5HCvBFnuJc8/hxDcM6RLPb8sCL9YfTE7SDa?=
 =?us-ascii?Q?TsoQD5/h0T0GHIr/5NdldtymgR9gE/TLjDHUe5bpRhMP7aT1cNwlXZd/QJy8?=
 =?us-ascii?Q?X4zKBRNxKVqMb5bgGdf/6efyCOjNf0Abj4sMTdk3FfttyVvWn1rmMQGQp6/5?=
 =?us-ascii?Q?wp6knz3lqptxCHpJl7zub9etaO3U21nVQaV1PbTdb14owDE7HuMQsNRqCcZH?=
 =?us-ascii?Q?b2nUbQGBOaR874YFh2JprFNQLygWeZsc1ozdwwvh82piTKSrltix0rfqvJOM?=
 =?us-ascii?Q?7r/OvxxCmRnL+s5GqLS4hyyNwfTJL7nATxwboDAGrMO3McDv5phuj+Sqew5o?=
 =?us-ascii?Q?Pspbeikm4NW7qa2gJuGBfImCz8nqFqU=3D?=
X-Exchange-RoutingPolicyChecked:
	pVDpEBmvmjxTt7gUHy1Z77L96JcWU53SBV3QNYo05CLqlKZGGUtqtnUk6Gqb5HzdTV+zaSy+pg+HYL/Bh9k2WsvDPLWPwjz4LHqy9ujDZZbSoxvYP6Hu2037hk/X+T3FaWL1JL4mcmZpR5/cuyjs2YAkcUlB8Zcg9mNmiAYq5H4MewaFi9ZrvbCuTzsBjK0WtSBYjIqfle2wzRwbNlbbtr9M8qwNvrekhmybWU5fBNb++AqNT7VOe2g0F8DLdGAMcsqZX4Um9SWqz5zAKrpzFmu//bwdXUlGkjas7N7gvCj+F5SuRapVs6s+fdNGjr32ZrjMxAXY7SS9m2mLd7baEQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vqDv4C58ifSeO9M+Q32YEQ2THBiLEvkJ5BX9l/lQXf3JnlVkfz71RXtLzOv+FL2oTIKFM+LacWoGMgUxtSSvlNXSYF1TaRydiUNeCmOY5u0qcGEBOU2ax75myCyrTK53pths2WPBa5Uduya9YRg0b+X3Y/4ZjgTdJx0Y5m56ruf3l6TqDyA6zucgk+sMvxy9WG1LRRvW4uVoGlWVGBlJJC/PESTZyk1phB06d91MF8eN7Yh4UwvAiHUQWEir75LVlxElCrlogwXMIJlODbs9Ow8xQgtT8uV5wykLK+9wvKV5atz+GqzvcTdUiwOA9vEneP7RdmqTiFFZxBaAi9bIq46oG0wjZKnmX23eLYz6mbqKJpaT+Wc6egyGShKUqgkVvtIWl56gmpUi8dnP9NGVC7Ovhh4Xu6nZbvZ8PFrtqiqseo16gvDNhpB80j4oqBlmlNAv660FG1WCGW8VfoV9luc+f2XJUxCrVnd/hyMpFjJpfOGRPnqOuS6yBIi8VFybGBFjvwTCi2KBDaAMDba2waaTC+ZtYuUJaROFGieRApBgPQF0jE0bbCzjAE8gZecq8BTtb1G7pMFm4t+EYI5vonlZ5Vr7LFT8XfGzGp9vcPo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4517206-c885-4a2f-96db-08deb22989f1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:27:41.1864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVatTjmwCYtHfu0ZC7sAB1OC4l9RsvV6Ti0c+ljePKQvmZUiy8rueNx8YzufGmvpFdHsTkL1b93rcI+o/UQ3GBdBQXmS0OywmUm+aruygnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF415C917DC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605150022
X-Proofpoint-ORIG-GUID: m7SvjLdr_c-SaLXUAjNZD8yG7oHmOV4y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAyMiBTYWx0ZWRfXx+h+0wVLE12t
 cwU55OE+xRXzIgXxEig7eN45DjsDZ85d6nUp1jQNWlAIuS46h+vTtKiNCtvfe8hSuQ2sksd1AsY
 4aD1PcJy+iiqeZsSHbWWh2zRRA7TVyWmz80WfHvvp/3Wm8Px/skpDug2jCynbBEVo/cUqPhyacC
 +qOA8maG1+/8btKjoMZKPrGQqpSj2+EgeFlvkPQzJ8xQwz7hGXdQCU1r2b5rBTrWmxJ4Jvsp2yN
 0gSN8P2GChKMZMFO6z2e2Zhu2y9dNlb6pIg9E6N7H/InoPfG9yJBlkd3UrGK7dg9Inr6nQOj0TY
 FijKr7UYasfD71ew+1fUX0MViiVdWiZVLh8Qg5U/tZigfGGB4lawRiyxoQClP1DIr7SAnkZC6R3
 v6nMo1T/hsj7di1cf+zDvI0Czo+0hI+Qu+pLSMe4tl2ctlwpWNt6v6lH0+2sWgvcXltfwVBvSFB
 L6U+5fG5JH9gGePQWEA==
X-Authority-Analysis: v=2.4 cv=Zawt8MVA c=1 sm=1 tr=0 ts=6a0684a4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=X3SM8jDDoWpPUcvSxwYA:9
X-Proofpoint-GUID: m7SvjLdr_c-SaLXUAjNZD8yG7oHmOV4y


Piotr,

> The macro scu_get_command_request_logical_port() has never been used
> since it was introduced.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
