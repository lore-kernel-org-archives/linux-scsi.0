Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD835373C0E;
	Fri, 27 Mar 2026 20:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774643757; cv=fail; b=jCu0JTSmxnNFv+pnuRr7rMWy9KXjm/immKGI5yigT+C+Jlta0/cRXvVPuSjGKNCmcrzuBsK4flZEj5FYOO7N5BHgbBjkDM4jy7d1+ZWQxWFvr2qgeeGQGU4Sy7Fa4iVTUQ7unBvl5/e2ewaU1nGDBSAClHL6nAxtSLSSc8NuBIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774643757; c=relaxed/simple;
	bh=bw7xD0OASAeLOqqxsQY5KA7IePdtdnpijQqjVmYfCus=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lE6KubPHd7bZEArRFNnEsa5BanNviqoiPojwfkIEzUBIQuj3liZ9SrfGzIiTGSqpgnS7oUN7YZCTIyTuF1VAM7pg7FG48Kt2mTNP18OtucLdV9dQqdjsb2l7UDL41tgPgZQNLKpUrDjZgCR/igEmsu3aVuA57h8NdvFmh3+IqaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iTgpZQ7O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jezm/rER; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iTgpZQ7O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jezm/rER"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RGvwN2980233;
	Fri, 27 Mar 2026 20:35:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZnUQWYWDnoCeOt8Zff
	CKFPOUcry+pKzk1ArVzb23J6Q=; b=iTgpZQ7OHf/pi2ZS/WIgjuBilVu6AD1KFA
	ohIAcSa1QXCZY3ReWybdwvgXnml0th0a9+TFRYDac9DGieNT26RRQbtURnNcntRL
	sr0JeWKG2L3D20hHRTgWS0FOV58Weh0o/Isi65UQxp/3DN3BVju3pUXT2UmRASLB
	yrKPDQkPgexgZjWspJMaOdnLK8mvYLAc9zUETw2QAUwJGWSUa+Vj8DL/Y68Loax4
	pcOPqbAGzF3YY2rLdjFpbzLIzNv/Ps4jbm9JBilG0MrXvmv3dQh8g4FqQz4eAGd1
	tnh9QptVTulqVRZJrfBpaozJ6UEyECX3V37XB+GOSsrgnR/sedEQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kgftrxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:35:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62RIq2sW000834;
	Fri, 27 Mar 2026 20:35:48 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsevjbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:35:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=plljuV2dS3Lkc+L35M8Q0FZqpziGbDtvbKMq1dR1GVSBWOk+TdpFCY9l1qaX9fPBvanmu5F4GKpwuiaYhtB8XtwiWV3QSQ7sE5TQFcbYGjaeWsqWIDz4JZ0gxhVeioPT59SKpC/Z6yxaUFLnMgVItDsN2VRdM4WWFOSPvXVVSGFB2bRWeNln90lkIUmnQLGPS8fT5Y9bRZYOHwDP1IjC5Xd+5QgImN4s2uDnjDVPpCooba7gBbc9rGy2DYUczU7jWaMdK4Q+QoZROHvcD9njJoyxlbNLKK3G4wMJivO2pJHDuj0DokuW5DnPcbY9WpMcf7vV1PT/7EnPfvvB2s/HXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnUQWYWDnoCeOt8ZffCKFPOUcry+pKzk1ArVzb23J6Q=;
 b=PS8e/UsNqYz3ctbfFv+xAgSoJoITCMnLbqBHiFai+BeR9ogxg02ohsMXnqZmrnk7/wIRSn4wfBSr7ojR0uLiZnLF62O18Y3AHmI19kMlEsTD0y+8JJGuGOi/JDIQnfunFTesdKN/Wc3UrvSunXRwPZIA2NX6TVgeY7/luxr4gt1hlJhw7RPaUzZZ0uHYiUkD3BScNDp1Sbjd3GXtOonDWYsg4f8A4+HBSkLOGQipN0WC4nT7hhUcjRsAm3Dry6SxI4fCe0k660f7n+Fn73yCoXve+J+3SdGaP+glms7rO0gvUYFnNjKqyf3odalWhapEojveDWLURIGKu5Ris9VIDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnUQWYWDnoCeOt8ZffCKFPOUcry+pKzk1ArVzb23J6Q=;
 b=jezm/rERlZq6BuBiILD1xf290rINpjwoCQEFUjEtZqofOTgnqIebwxI8RTvt5HaZtQXEfdAezpsKv0EPzdlKJjDf9QTckrkSoABT/5lKUyLRHpYFcHMx3gAwO+jwtS8IxZisj1CohaUboXGhzwG0xc4sOQ1VHCyMXu2eK7v1gLo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7902.namprd10.prod.outlook.com (2603:10b6:8:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Fri, 27 Mar
 2026 20:35:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9745.023; Fri, 27 Mar 2026
 20:35:45 +0000
To: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        davemarq@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix typo in fc_els.h
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260324-fix-typo-v1-1-601f4fde35bc@linux.ibm.com> (Dave
	Marquardt via's message of "Tue, 24 Mar 2026 11:56:25 -0500")
Organization: Oracle Corporation
Message-ID: <yq11ph59fjt.fsf@ca-mkp.ca.oracle.com>
References: <20260324-fix-typo-v1-1-601f4fde35bc@linux.ibm.com>
Date: Fri, 27 Mar 2026 16:35:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0014.namprd14.prod.outlook.com
 (2603:10b6:610:60::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: 4edf1177-dea8-49f4-1991-08de8c406be4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	9Rsqlz/ffGRb7UfL6jJaW5aMSW4/AlZbo8ImofTUbub98Pxyh24JUOfH3aai84scne+P8383wswz4P315e3wIu8KXuBjb2mP9Jk6IC/ScltAfKaA+Gwdvy4v5vMmCWgfCpqPeix9d4TT3Y0JSdGE93bi7jfwHvzRetRn/aEZWefww0G/ZgfoBTQyHj/YLUFy6zd40oT0rKMbgbPspLeLxutDEa68dw9yPZMt2jcGsUPk0HlyoeHCrcZHazBh2FquR4bgtlPVpTm9JoR56pDk78hcObvB6wDSrdBP9ceJG69J+B0NkX/EefqON1WhdSg7BKcYVMrdDXwD3pxQHZdd48WdBYadGfJatIaNp2u/kS0wur5lE18YrZ9Pkj1K10X9WYVLaaOTI7Vl5SYjviLrnsD70LLGwO6QTAawEuKYj/GefEQJedn9HilPM5ucI/Owq8LT8UyWQRUGoe9wBCezy5Ubf9Sbq84sppW8BouFVGa5WIU9qyTR1uwM1O2PntKjMGAoa/En1VK/1xuVLgCsA8q14MGSKqP+vYuxcWGFZv8yjphhLf2b80Sgziic5PYca3gJNok3zd93VBvI+UzSfBXX99r2UuadFEvON5HH0JnocL/FwNznxGQ+ws+AHqXSNYivC/Jk6lXXJN0t93zN7RpIPmMdiz5kZxyeFJLXTdYpzJqXdbpQrLCzPxcSTTS1qc2LxBAsOmqqIuds8c4Eg6BbRBDe8/nWlAUTxsNQ9nQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1XJ6TyAhfdl+O6CJlEp/koK10BoLkxCsZlsDEC4CGAdy58JE5RKfAibPS5Sa?=
 =?us-ascii?Q?jr3dQfb01KH5u4MOcUc8v9UIQ7ux43cDg4nQoaXKI3X4S0LiMDRrSUTyKAaO?=
 =?us-ascii?Q?pIrDgZNmnTnpTgKfyPw8i7c5CM71IuBb/jq4Mq2EZffOAkMorhfg8fL9yb2x?=
 =?us-ascii?Q?4iTwi3iQ8POvDmn57CoD6Ry+CAdFYD9//mVPSfoAn/MR+0cetieyFNwRkT6U?=
 =?us-ascii?Q?hvlnepUxofUYNXUshGHnepdpf1TefQfixmyvrOfwW+y352C+9zVMh2uSQ7Vh?=
 =?us-ascii?Q?c8lKkgq/gGzMHUgurpy746oVZSxFdCZ5hYQNH6giw8lzgnIcjOjutesXE9NV?=
 =?us-ascii?Q?VX7DFBaFkUQFklo5R8xwHKTWQFG0jOzWqzvc3ZszJI4waPAAMRvCII6xBnEw?=
 =?us-ascii?Q?32If+JWa0O3Ixgguy266jE2zcsGlspMa4vErjnsCe3p2G1cXDO/cme0Pbd3i?=
 =?us-ascii?Q?F9r1BnWEcbbJ9OWEQBmX3CCYjFwRvBdGsWosp7u5/usLTRomGFxtFPGCcfAk?=
 =?us-ascii?Q?y5q7CplcMfz0OJD2IXFr2HmgwofkaZZ3MI7FNflxKnL58j/UDlWGlTTQsMt0?=
 =?us-ascii?Q?RIdJoqDqN1ULfCiQYZWKSbh+Oh8PtyX8WNc3YYMIbleR9CBdMx58Qf3Y4Gw7?=
 =?us-ascii?Q?1gp3YfVOA+OGsXVLs72FZjXLbFjrPDYgJUcFIj7q2ieWYPilpzXDdAdQWs99?=
 =?us-ascii?Q?cJ237maq8Qop2G71Skeqx50XZN87m9VV13DCsjJHThdV2MfHMqnKr7sQh0mr?=
 =?us-ascii?Q?L93PvyGstVms14F6n/lzk9NrBrQZcVbzvQiejn/wtnrmmh5PdCDlNG1QCh/A?=
 =?us-ascii?Q?+lXoSzCnbpBUumxR/ep1ZMwO/Yl0VEmPxIXtCtF2PhXzbCvmVks42m3p+dXX?=
 =?us-ascii?Q?+C2CP8+Gr4aL7M+FL9R8Oye+py3Dp3B/SbkbBgl6TEa5fRjX5KC4Q637eLk4?=
 =?us-ascii?Q?XWnyQ4N2tXNYN/mL2/NWBU2gUdqcMygECxodBq4hwH++vi2p0vjiFaaXklU5?=
 =?us-ascii?Q?XVrsWxIigsEuy2OTW2SLO8NNXyJVmDRTeWMge3gDq16zj7NSn2exfwnnocnQ?=
 =?us-ascii?Q?kZp10pNQeis0TGNmwOijErqxLRdIRP1WfL/RI+DWfTERDzXoVDP5sHKpeqTt?=
 =?us-ascii?Q?PmDFg7A0BnLh1Lx0TpoRsw7dLUbJyCh3nEbDzz/7KS2m+4/plcjIPw19uk9f?=
 =?us-ascii?Q?jt1ox1nVmNs41J+GuldCOoAQT6zxlZ7NUJ2mXbqxX3vrA6wQUaJu/ItNBBPO?=
 =?us-ascii?Q?iA6DaGw4AcE2J34hrZlN9RGodmBL2eqpwF1oz1YdU5xkJxICbCJm6oKpcgd5?=
 =?us-ascii?Q?6prcRE64flmR3qfg1OSFs4rVJBASYYMtXAIIOr1ZwQVqMtn6DvPSAlBELzWv?=
 =?us-ascii?Q?76y+xVN9QNiyl/+aF8Utn02VIJkKFrY+8wx0m1RSkDhi5mVgWLKV8vxaB4cB?=
 =?us-ascii?Q?ulhYgkfdkP0g2/GNX3JcotEGJ2HwEPJMHchO6HtlSKjDDco6Zu9kLS2hv9Nw?=
 =?us-ascii?Q?6H52SBTT+t3QEJJRAcer0sttRIaXfvcYLlLQgTjyJHb42amk1SSSadw0Zcj7?=
 =?us-ascii?Q?xaE2sAvMqD9krsALXjOx2KI1fd64bY2T3w1y4wwhNyMaB+t3rJQWE/IbBZ+r?=
 =?us-ascii?Q?YdXb3KLSsO9g1e+8kx8mbzNdBpBTCpmKEfCC29CQIEiMjT2PaHeckFQ5nNgs?=
 =?us-ascii?Q?arbhrYdmT+kBZoKsplhwvLTSSOdwizvNSvmANvyaOwh3h0nYXzdP/VJPhV9U?=
 =?us-ascii?Q?L5mGQ0/QlBIihiPv0WFGSWrEBNreBfM=3D?=
X-Exchange-RoutingPolicyChecked:
	sixq3NVmHdLdqggUKdxfp1Ku6MkY5u8KFXqq0vO5mXJ8QrAE8DZowi7ug78XyKJ0/Q8qpbwjG2W7ncl6hBO3Tq5/nmafkjb/dca3+2MHjykZLuyDLgIF63kFL1mH9bp8VdJW96w9EH+6+4FTmcFIq3nudonL7X0su3czOvQmWyo+wszXUmxDQU3Y9MZJ1QHx4wwYpSj4UWV9IvnGOzUlX449QFqu2dntUPxLjiXNbJi5XM+sV/CBEpGmOWQez1k/E23QPcHjAwFKuoCEAtik6d5PzGQILZJSaRo9/YMO7CkaNnQKOPDF5lKvGCXeEnjmYT9w0GrsxUSNXZ6nT+OJCg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I+cyhBu+YaNcPUiFcxAFlOYoUSFfswdMIchj7phlm1OwWwnXRWVkaFzRMe00svO04HvoIYaPbFh5j69axmwI/EoitKOPwDNYZuKcz7JwckIlVMo6WWQx/tKB98jlpqTwF5PMFV6wbBZQ9sVU2VvApPFl7eeRHhWuQNpjmDCbot+XuObrd/dGRAo10Duy511B4ieohQ1XJ3srvHQS7+/GzaHr/RWk9PifpS3a5jKp73VI5Y74CtzZqdzdg+5cobLUKiQb9leLhncm4ZeViDO1OKyQbDpcyNsH06pBx2hvPdXXqB/sTvCiFCXLLfduNO0idg5tMCeB6mweBgFNdrEB4AgkviiMiAs7SkFiWCs1+FtlZMrzmINDohoScXH25ZW+d5+PE5pkf6TN6Cx/9j9yOoFSSY+HT1kG0RxyXv5hJvr4BJbzWBsNZq7Lv8JXUvfH79NTkMVxaozWK+8KaqIRXhDs/oWiB1FaPRy6di+r3+IoGpOyAz7ZCT9Q4PJYbF6lViOvEz543qxEVBsMO5U/vU+VL44XjMdn9YfTzQ4/Sqj1xFeYERz/c7oPV+fWDr8PQPQ/4vg7gIFVw0dDLHILliwAl03rm4Lm4LiV3BMePnk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4edf1177-dea8-49f4-1991-08de8c406be4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 20:35:45.0149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRAu8L28Ejk//b3anb+hyHJduEhaHTd5K9Lg59lRVOQ989fL8u+w2Bzn/U9aiTF9YiTs0pGoVuJrqDcwp4BtziXcwcPTlpycHxDINkIZBeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7902
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=756 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603270144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDE0NCBTYWx0ZWRfXzbViTKjCpkdJ
 d9GfrVWOswhd8L5A9XD3koljVdh0Uy1Ebal77r35rNGYUNY0yqhcexlDogF+10s6o3ckmCRDnwl
 CMumKMyCKVC3+uYICK4PY7S4R1TWbvXYF+rqQd9mG+NXvLM55Yvc1nlzQCHLBY84qhg2Mkpqkmh
 X9iscZJuEf2venmv6dZmvC3Sp3eutJmqy4cvt9LXAW7KY6I4Zo6QMLURsN/E+l6Pbv6n5jQdLq5
 wGNbaP3s76OQrzxv4JAx5BuDCqzSa0hc2ZJA/ivZnYVeDn+z/l1sRC5cVgrK6CONdF5OrIj9v98
 /pva6nzfHT0cqrasWj5a+dWZQIBVtmGi/HkMvpKVj8ol4cHV8CUTPgxtRawakw7zOTmCS5CesrZ
 I9nol3OYf2HCgQekbm/RRJwrWkjz1EKvOyVd62bOJ5uNMnogI8Ltl+/9YErx9H7GbZRsHLNwmzF
 0oZ3Pf2e9sZfIMiBqvA==
X-Authority-Analysis: v=2.4 cv=aq+/yCZV c=1 sm=1 tr=0 ts=69c6ea25 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=_9EsKFsg4OysSP4K7y8A:9
X-Proofpoint-ORIG-GUID: mgWhrwNr-OoBYOpKakeAYXDfFrzYyW-n
X-Proofpoint-GUID: mgWhrwNr-OoBYOpKakeAYXDfFrzYyW-n


Dave,

> Changed "caause" to "cause".

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
