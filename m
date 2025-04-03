Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32BC2459EE;
	Thu,  3 Apr 2025 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743692132; cv=fail; b=iQHk+4xZqp1jzQwmhMfLJtlq/xCo2nOmW2xCGgedgmr8YYVrbV/yDJubHjZ1v1G9B3DQFIEIwb3MDa9tsUDbp0JBigC5Zv7bxH2Ap3/Xf06gVxcvUHersWxLRVxZoqExvTLTlSpNVdjUm4M+MjXJIX72TdQLz+Os95K+DysIicc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743692132; c=relaxed/simple;
	bh=0Ss9/O/o2jM2T1kbh/4TEiTdDL8o90WrzpEviASffiE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Kl1naYJqlisHRprEtpUdK2CcVcjSbtJhmG+DmCqNKy8zyBwGOdzfYIaMhwgL/fzBRiPWOkzMEFTGUQyKRkFBvpgUR/otrDWvdm8W6XVow818wLByr2dFHBa0w4UCGLyBERkITSBNU4IasY7oXw42aFHR6jMKbZk7HAoWlWOL//g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RpyESwzS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ezLiWE0Q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RpyESwzS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ezLiWE0Q"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533BHaRw031968;
	Thu, 3 Apr 2025 14:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=TfC4hAIoUWQo+V42Yz
	BrNayLbciByfn672itsV2C6PE=; b=RpyESwzSkhdebtR4ymoS/BNjO2kL1uDtVg
	Q2GY/unOq15YHPl7yxmZB9fT//NxClAqrvjFofnttSoATeRzvv1UVl6PuzRlJu4e
	5qpeEDHtDl2Yq312N9qVBq+hNpNPcE4bcuk1JoLzJl2X7Ij7jlVjdg0/j+Lp95G4
	qs9rjpQeBMH4Zu2lGvODqgUdwNooPdqlnLlbxTwrkQh6nSzc8TBIQ5lagzY+9Oak
	YC/f7oZXXLzv9r2KeCILvIDmNruniJhgMXEeF+9TNkROimJEFaWqkqmXYb+RSm4Y
	e4W93ftFrT5GxaOLEsR18A6Xu2EaMS3q0tv03ryEaEP/c7hEQMvg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7f0mwt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:55:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533EU4S5017183;
	Thu, 3 Apr 2025 14:55:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7ac9nyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:55:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eShZc0fzbFcu0OAvCMSiK2b7k+I+yvIPxlzPN/QGay1JqtK9zQR2KE2yqxz+ilaixx7FRFNMRSYQLKca4KyPVW0x2SDCq+v6/RSV15NAL8Y+HSEVKcUwaGkdBSgFw6iML/tsjEg1tK2LjpnAHX7mlnU+zu/t6YnahpA2VbnqiBZl9hVSP6Rmi8mieWu/D4X8PlnwM03KHxf1+6IQRBs5w0Piu6hH4JDj1z667G0NUjuErAVlN1WZs7Vz0s+WrTXUFQ6jnyoGBdur7ejUJN+JQuJT5tpqZ5VO663WkfCoKgvsWAnemPDrIp5BupTc3OQswi4nh/wbeJgBHY1TWqNR5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfC4hAIoUWQo+V42YzBrNayLbciByfn672itsV2C6PE=;
 b=tLE/QTK/ltGxCPpawwXRGFocxWwkndeLCXWZv+2Enjkhdq2hY+zd0Vu+n9PS830QDO8/y2P1uwfDGdfeH1Q3dkEXpuAM+EUVq3YpdrzJNb1OClg8jLIyXYivguLXqF9ebVHinxwrDlv2mMUbwOThZGIj1ipOTthgLAb795jbA1R7h4KsNEgYQYKM1oGgN60f0FNTErhb2Krgyfqhw6Z4p+PHuD1mGYDLYTcaeiHLWyLLovme6tPoZS54z/kKEaS02V33D5kxrobYoxQ+9z1ZfcVthrG+JfXiyBXKI4zi/AoEX8RbeSYyAD0/zCnhGeqpIOFRo6BWZKFrIRBR7FzX+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfC4hAIoUWQo+V42YzBrNayLbciByfn672itsV2C6PE=;
 b=ezLiWE0QMi/gTYFiFc3FF0NUnF4eFUAMxGwWFZVuVAT/lAyAk84/0lHtefuFr8z7MHSvinjgGH38jhuhCMbvdXLZTxYfB3jdg/lTmkLZWDS4oilqDb903y+H9zb6AUMpZjZGOKF1DGiWEKCKlt5ZIe/3NvpuAK+MOtEevPNVpJc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7555.namprd10.prod.outlook.com (2603:10b6:806:378::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Thu, 3 Apr
 2025 14:55:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8583.043; Thu, 3 Apr 2025
 14:55:06 +0000
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: <quic_cang@quicinc.com>, <bvanassche@acm.org>, <avri.altman@wdc.com>,
        <peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
        <minwoo.im@samsung.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Rename
 ufshcd_wb_presrv_usrspc_keep_vcc_on()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <02ae5e133f6ebf23b54d943e6d1d9de2544eb80e.1743192926.git.quic_nguyenb@quicinc.com>
	(Bao D. Nguyen's message of "Fri, 28 Mar 2025 13:17:11 -0700")
Organization: Oracle Corporation
Message-ID: <yq1a58xuwg0.fsf@ca-mkp.ca.oracle.com>
References: <02ae5e133f6ebf23b54d943e6d1d9de2544eb80e.1743192926.git.quic_nguyenb@quicinc.com>
Date: Thu, 03 Apr 2025 10:55:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0932.namprd03.prod.outlook.com
 (2603:10b6:408:108::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: 7022c1dc-946d-45c5-6657-08dd72bf855a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ju9hKV+U2nAzCIM5uK3udb0wvpgWtzlEDIEihthfYxVIJmDYZFih0QSd5SrL?=
 =?us-ascii?Q?bUYMtuoGFXiQPGCYT26OlHf5pDuz4g9sPcog3fBaatT4mZP4yApZShjb7D0I?=
 =?us-ascii?Q?qefcW301WWXrEjYOEwUCMHbk4F47BYhmNArdNULyAFQKjIFA270XFHPhj12l?=
 =?us-ascii?Q?8JO4Nuobih7yyisNeyuLxe1CV0cqnttkLxC4iwVCZgVtNCVJJcFf5iw0gBam?=
 =?us-ascii?Q?uMfcRiq41Sde9aXq5lpfCRemAVq/ulIoMeVStHKceyvPUNsVWNCOUCxsy4Ad?=
 =?us-ascii?Q?vra9KLLV00qFD/FRN5iGQUfemocxfQIwpN6Zd9eRTlw6gGInxlF5nJeRI+H0?=
 =?us-ascii?Q?uWBJC3p0+TaRUvs7oJdj6m3leJx5RKaft8F7TJ1BfL548vruyjO0iwFEOND0?=
 =?us-ascii?Q?M17samzU9MS4S/fyRnJsRgZ6io2GR9SLHd8I0DK8lbYq5zgl1vgVhIuYAzQf?=
 =?us-ascii?Q?pS5rPxXT0zFSEMIPPMBTv3GUb4Mmewea1WsrBluaVrpbwMXUmxv1J5sv4pqq?=
 =?us-ascii?Q?SoPdBzpz8PQtHzgJrB57EbEcbPTxuQAYz/yvWmsuxwPhTZDO1a1Bc/8Dq0kV?=
 =?us-ascii?Q?c//o8IcO9bQVJcck0diXsgVSSFEQdhhSfaBM2TAlEUuYr/0EcULIR7rKbSpE?=
 =?us-ascii?Q?6g8OHTCXYtd9y8SP6kv5F+o1x8xZBvuwjZ9PBE0msyF3P15ai5Mto7EX8kH7?=
 =?us-ascii?Q?T7+QuvO8knvhW+PzjFiT0osa0q56j/pAyoZkuinOSORvMD2+MF8a8QnHEGEE?=
 =?us-ascii?Q?dkuGn5Bk4nQPgme6Gr+EYyGo7RDqqRwZbsAzGk8RgU3hWdE/VVpPArs5dk2o?=
 =?us-ascii?Q?TPle+EyfCjeyQkKnP//sd5yFPYJ7dd8rJHxq3QwlHNrrQH4OXBzIAR3V3hge?=
 =?us-ascii?Q?mxlbHuV3zksBXDN5QQ6FZmsbNIMA4plRmSx0DZ2xEO0Sqp6AYdGbQCBkvKCx?=
 =?us-ascii?Q?aFxgLeQyLQPZ9FrH80pge/hCirpUXRcxSYI+o8Shp7RvYE3LD5CfjuDvQjBW?=
 =?us-ascii?Q?JiX7bNBKo3hCdF0cRIC90k4dBCN9QtKEXi3YUHka3tqs7vsKqsAIctjIgfCM?=
 =?us-ascii?Q?W3cZBxg0EvIp4NeBsCb0zAv9sKe1aHYKe/oY2NDFYtpMlJLWSyntTLETrtqV?=
 =?us-ascii?Q?vxtmBTeYpm2Lxd4UvkOlyXpze+PkhlSGn9cguuX4FguvRLUVBS9pCqs5oVmH?=
 =?us-ascii?Q?D9yFNvcdYf+LWjOxfudZdvqZEfYTs5M/yqB0KV6NfAhY2boWnm6TVTED9Qcx?=
 =?us-ascii?Q?eDIZQCZkxYmsmhQsZfeHEU9ZbvoMgzEa5eXZptiAUF99pqbJPhvDn3trTUOI?=
 =?us-ascii?Q?sOM6nXD0wcWqo7oCKlFv0S14/uXVe00eeenSUumqP7EnnIipU/aJsM5nO49Q?=
 =?us-ascii?Q?jjX4Avq9vObjQTeV1ClqkRCJPAik?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6s8F57sLgo3FEl6t/82B+N6iTRY1Qa6snC1+EE8lBCn94rJ1RaXvM65DkwJT?=
 =?us-ascii?Q?hG5KEtUCnpAnHwcemPVoVMKox8spFfHL0T5m6l+2Q+JNOeDH3EG+na2BcZsr?=
 =?us-ascii?Q?5r4YDApV1ACyq5kHoGOEb05CZMGImDcsHYPtovMnr3AAZilR8VxY9ImNKIfR?=
 =?us-ascii?Q?ZXRJgfn6ILJD78W7Lp+uphaBXzMD4AP57XnN0dB4AxWb3WjI397opYYUI2UW?=
 =?us-ascii?Q?cqB+cYZACnTiKzHep/q6pcDJWw/B3AMfasAsAMvJJIgBaVoYctrywrjYaRTA?=
 =?us-ascii?Q?JR0C9ZskhpqSteSDBZHZ5klhp9How6G54eNZv+RXaObyauF02MY/jJwGOdzM?=
 =?us-ascii?Q?zx3b1LfyEj2ac/HdcBOV2M/Gr6SxibOFm7QIHnsQ3nILlrZnMNg6S4dQJsnN?=
 =?us-ascii?Q?NbKR7+eRCwhZWWJwUFnUARSdtemyTa64NtHuK3cCeSRDqOb+i+ljXBgCAC3Q?=
 =?us-ascii?Q?c9KIMx+0cExvraDhiqAtYMSAWS7/vmm9SUVTASNObWHteYOuMAHHpa9KZIQZ?=
 =?us-ascii?Q?/25EQzVzFGs8Iqu/LGG1BoQvUONrnOU+39jXRnw71B5jzxGCJ5/MZ+rDayfB?=
 =?us-ascii?Q?sxcv2/o93DiPbR3lfAu56e9VcWhhijT7+A3w4zn//jMrfenTr4HqX5YUpbdL?=
 =?us-ascii?Q?adjRXSUiI4gLsknl3SYKkHyPUlRpajRsNmO+sB3emgkrEI6uSaTXRMRlgyLq?=
 =?us-ascii?Q?Vv+Tm57C6bL4+oy2BnIhUTk4+/m9EpqULS7pCUgnEsJc+AnIPjUvYWfwNhmA?=
 =?us-ascii?Q?yGtGduSoGiTEdOMfJg+k7oXisBbCWoqJptNgzIYmlEjigLLxKuWgZaj3W9gx?=
 =?us-ascii?Q?MNI6zCyk5XA0gju6pLSePX8/QheMYYXTdg7jy8mVMTmNM5vX8LkiKciVFiOc?=
 =?us-ascii?Q?HEi4fWIiadwNOteJ4F9E8w79UCJFcMmdsEigHbY/kJwUPKqWW8AuvZ0dIvHx?=
 =?us-ascii?Q?3YnjWWYBWB64fNFyJiOn0ZHpFdPPf11wZUNbbXv5n7uHViDbKDyTBhsgLp2Z?=
 =?us-ascii?Q?ZFq1/YFIvAxQpSAtDQRFcvMiOfUhMtbuXlgb8agGZANprwMfwX73Yg4gLAw5?=
 =?us-ascii?Q?ohe7bq2ktPRGCoPYCmoewtYXpElKm3jtnM4CmqsjqUbcMJiHEr2hANmrxatn?=
 =?us-ascii?Q?QEPDk7YXlvaRFrg1R+KIYymD39Nm5XNoaACpJq4JamgZwYN845Cfsil00N6n?=
 =?us-ascii?Q?NRXdYGoo6Gx2TdudoW1ocX/Op8MZHgysXiuHtHYlSlWuhrxGT4E+5GqOGSxn?=
 =?us-ascii?Q?GMNM1GYksHDAYcGP/87YCBJFlQ5jcWsHHS0F7s4Pf8JJYuQruB6qTnfFFPd7?=
 =?us-ascii?Q?ASXeqXA9i5LB+13H3PgAJFfOK2VFWg1iWsA+/pMWauuBWK+h+y9X4PF9FsD6?=
 =?us-ascii?Q?sFiz1OMWaAHQWJ54cBDdPt0sl2Tfy6B+FXL30plsc0GuUfzVAqTbBys1Gj8B?=
 =?us-ascii?Q?jnXtC3ZqB1HO9g8pPPDMJg9/MypCCsixqPsoVi05Wy74f8vY50LG14wizK0v?=
 =?us-ascii?Q?uMe8n4J5wKy/P56HKXpr111CBRZoCLgunBU41qmQrl83BPMBjnF538QjXoeU?=
 =?us-ascii?Q?PCnSFXxv9fwq6HgHP2Ooz6Vq3XqvXRNOj9cL+y9X2Bw10hZIqR3raL97fznx?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Et0qEhCKeP0MjDzh2JrZvXI7+XVlyD8kSgGHLb/B5Wnmcte4zGApeY8h/4uxfudwFlUYWCctFyrVeuChy3keL9WS4c/VOLuG3E/fHjqnyaccqXRvdqCNA2HjCpkRXAqjT838NzBBvZ13H4lG8j78rQ6N6S6cBrKb0ZwUYzRSIJn9UeF2yPFg8qlPvD8KE4iKOLVl87HCunyhtHxeOLtxd8ZS4Q3BqQK+900PjszUXyFHcNAlYgsKytUc36OyXsYTZTp/iE2jlXZE71/PXzU3vnv212RYqbv2NzDYU5njLR/i65gCUoD/7NnC2g3g4o5QChtvGVf9BH1mMzzisdFSfiIHuCAEDOUFf1qvHkc7/IUymPgZ895L6lEjYV0CnWt5kxZKAo3zqtvgdEWlRDi1AKTt8rGLOxPt1u/vT+06ZgX9SSy9nJJo2spnW/YKivj7eGZxSRgBoTRrqJgFl/Pj2NKBWSlJzFL9wS3k7wNTPsy/XHSJY89LImmu5SEuwq0qwUlE6haeyOTHaZkNlx8iJ6te3w5T+AkoAQG6dGo7HeQkcgQ58m+x5pi65t4vDDm27W+wW/K/Qj51JnbqcXqqmyDcNA3gDCDmzcGRy1cBv9s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7022c1dc-946d-45c5-6657-08dd72bf855a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 14:55:05.9337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /E0W/fACFGnb6xTmxsiWQQKTnNvGecrtJh9PUjo7YQIMi26VvGmjOhJY2giXhpw93JNNB6rdEtpFtCmCIrCxIhgyfiLTPUU/WOlpk+2MUOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxlogscore=894 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504030070
X-Proofpoint-ORIG-GUID: 03le4uF_lxe7Z3IQcwctiPzwD-iB0mZS
X-Proofpoint-GUID: 03le4uF_lxe7Z3IQcwctiPzwD-iB0mZS


Bao,

> The ufshcd_wb_presrv_usrspc_keep_vcc_on() function has deviated from
> its original implementation. The "_keep_vcc_on" part of the function
> name is misleading. Rename the function to
> ufshcd_wb_curr_buff_threshold_check() to improve the readability.
> Also, updated the comments in the function. There is no change to the
> functionality.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen
