Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDE5244675;
	Mon, 27 Apr 2026 01:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253394; cv=fail; b=UMZaDiRXnIzljk9RwX8cun6reIImn1+pnqdoVWZBPC1xfzhykNZU1OaDtyK5NTUAgKLnagbH6wkwYh0xHBFNjNFkvPxNpo6DDlV9csXIWfPNuOi40tHkxFNJ7wzA3DVc0ZSZI4fxoL3O2XVO2dmL4rOvMeA7oJNf/uU7FXlij24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253394; c=relaxed/simple;
	bh=XKddUKwBQORAtRjJKwTEL8IzkpPlMYvsqJKUwpqpCtU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XKeqMapSvs1x/YR9l/6VSQC1CEzOlQ68iyiya1WBZWGLHShjbF93uRZHOZTfFHqTne0dK/4kLi8OfVKzMX/6whzswXBzZ1GiC7d9WUdQzPZv1pXKeb5K7vnsvL9aT/uk2H8m9yCWFnFwrDF665tHz/H7wYQ05wGzZ/ywFTlWArs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RTQfs0+b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cOsWnUn3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RTQfs0+b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cOsWnUn3"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QMcJDl2534447;
	Mon, 27 Apr 2026 01:29:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=X1vAPEqlzu0AnjTcj2
	IK74fWKoqLDrig8jgs9L/q3/4=; b=RTQfs0+bScR8jbFoc1xEqi8odJ125jarsH
	ZudA3S0ZAgvCJxg99TKKate+hUrcNKlQTXjFm0dHWXw5sdjz3xpnJHycQaiA/Sab
	FGikOk+5EtmgrNzna+I/17CB0B4Xxbg12sqSdu9MdLBBxEnyX2BVOy2KZfsFhQos
	OZGVjFub3gjjCom7pvujkbvHtQrV8XomFncMU/tSVAI6UsZuFyqmbKkUyfdfWGw9
	isGpZdMThw9lCnagul9ItawCw/sl/r9B/50F3ocX1ghqUM7HEi0yJk8/BRmXCdUs
	M/P00qCWPa7WteGfMYUh9C8i+gh8XXgH4+KObnElPUiqcp4DkyIg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drp5st5dk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 01:29:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63R1QGoZ026286;
	Mon, 27 Apr 2026 01:29:40 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012053.outbound.protection.outlook.com [40.107.200.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2atu6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 01:29:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dDqB83QrdVOdm09ZhzffjM/BfKt46CsZ65mK8A9mctj/yynFju0NHv51CwDMlYj77BDDfiDBp0QfJS8aMEiEOvnQFElvx5T4VOU3r7fgczC6k3vN8q0yLj4kJ+/sLhQR19p9dw0Uj9/47K/yG3Tr6jezfN0UpxTF+QgHWVRN3eFESILL/4O+2QWJ4utcwC3XmFzlkKeWiJ+uTdbYOyrCEvXjBc1h564pL4+6jYgzSI3hKcezRrCdFrrPPkXV7BWutWOa1FBQdc6e4XjZ8gxH7x4SyxdNTW+Qr1xZJZbLiNkNCpZimsoYOwcQCbro2bHv1s2uqLTPzB7bTvGtGbmBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1vAPEqlzu0AnjTcj2IK74fWKoqLDrig8jgs9L/q3/4=;
 b=AMW61sDEPTd6xntgPNW9CNiDCQ8n6BohQ4FZYLLeIg+i6xbDNHQShxxTjt52Qa49m+Z2Hcc+0Ivp5Wp0PjPjUcaWBjpYUWZzCPxrWcHgCkKz4VDrTV1ED+ld2yg5OeQcgTMp0zPy3IQp5U3N67pUaZJQJtVzi4gD68tBExjcWUpqUWPQu+0T+4nMlj7YQkSnaIO6Vt86ReAk1y8VlhOHl14J+xWCOm/Nxfmr6QvM+IwHFhwUO+XFqY/n5sjn4/N3AJgxxQYY3WENv99DECdAd2jZrUZALhvG4CvqoTlOh2LNRTdiwa8M5MhHUxKtV7ZcB/emV6PoVmLysKQ4Ht0yQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1vAPEqlzu0AnjTcj2IK74fWKoqLDrig8jgs9L/q3/4=;
 b=cOsWnUn3o6/Iqua/Qp+DQjLhvowE9fyMJb9RlGswlznvpUjXPIb3jRdlj8GAw7KtP6RE/dDydcTKURckaWpKIIhd0/FuTBO+T+dG4PJ/9wwv2mHMPX+fXSXdx0p3SmhkV28/9ksFqprbI5hRf38hHbNPEC9ew3AekQK2nsT0R4U=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BL3PR10MB6161.namprd10.prod.outlook.com (2603:10b6:208:3bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 01:29:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 01:29:37 +0000
To: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: phil@philpotter.co.uk, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, axboe@kernel.dk,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daan De Meyer <daan@amutable.com>
Subject: Re: [PATCH v2] cdrom, scsi: sr: propagate read-only status to block
 layer via set_disk_ro()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260422113206.246267-1-daan@amutable.com> (Daan De Meyer's
	message of "Wed, 22 Apr 2026 11:32:06 +0000")
Organization: Oracle Corporation
Message-ID: <yq1jytti447.fsf@ca-mkp.ca.oracle.com>
References: <20260330133403.796330-1-daan@amutable.com>
	<20260422113206.246267-1-daan@amutable.com>
Date: Sun, 26 Apr 2026 21:29:35 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0057.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BL3PR10MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: 91621f16-8f61-4607-1736-08dea3fc71ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	W/yEtOWwZknhpYIOGbzeBSI2r685woPm4YgZut1AcGS7SkeqTAJupAuidXzjT1pmmi+r/VAcrtc5jriqLoZhHtHnQIzjmw2LX5LYagRoAWkL4X7AkpfLTCmnoSOdmuktiW33c9L7gqBwkCNxJyHjiZdSFtvRFOppBfvcG+NtN1jRbNc+e4BWEA1moC+4RNlG6GX7ADeQ7wGSFVuYehjc3XgHcsP/gKMYPOD6cM/N57a/TIDduvwZKdTqZuy8cjKZsKb3bOfhn4Vewi4S0Is8mIV81HYo3wixTlenxsgqsQTJwd8TTHp3Q4QHfcdtl2sjBsfLFvk9ixH+54EALix5zcfk8ts3Pejmv2HG6YU8ZtVkHVbM82AGm4KquXAGbqoXVhbquEoE204KkmWDes0Z3n0922cMcxBMyujvNd5dpR0bQbGiFQ8e+XUeuk201lxUjoyhXVMMLRcsFEQaes5PsvwbTeGC/LAGvaAAYJrZMEU/AyRHhHKJBRhxOkCMXdbuzekhg/16ua02tjcSkaJQPY4wRkb483wUsgIbgW+IGu/zZ5p+P+HzpaMlT6XkZqyQhydeE6MIp9WcLDvAY8R5sDu4hR+PphT7NP6KJpXhpS8VOVFcSevrbqZkcKXn/S5umfxg19Iekx1oNuqdKA35IOL5AWSdmggGdKDFlF8mhvUY+pVAyN9yfzW7OpMtFsl+b3ZrtzwJoddEAJ7mJhx2D5ixqORBRdWSS1WFUj97Pfo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?phgtKvWYkvBIgo7dc8ptrkzDuIZolVG9yltXBpiP9G5xmogSRdo2TNF7DZN7?=
 =?us-ascii?Q?fJr2Tu7h66wFYQcE2OoZyl/Iko2T6uv45VHIUDuJnFT5Rp8nyFb9nJummbZn?=
 =?us-ascii?Q?gUgpMjWjQVht6CJfB+6YdogzoyYEWkWXLRRAdunlj3Y5TILp3PMZtyRZX25R?=
 =?us-ascii?Q?LH7DxX2lBOyy1mgGjlP1WLdQx4of1t8a+thKTvSZaRnPLWMJowVgctpn2a3o?=
 =?us-ascii?Q?KAPcNiJ+bLlEflxYDd0OyAO1sder8gBJTlUJ8ZeJUgpSMqMUAGHKkxjH8bQu?=
 =?us-ascii?Q?p36Nodb0PdfIkP3MMx5rI7WaRPxwemS1S1OxqrsYExEfCPEzPMgSATUYQC0j?=
 =?us-ascii?Q?L7BI0/dQTcvTf54ROb10qY5rwRSBzq5bGONJ8qfUKhhwYpHBR+KYanpyYlQZ?=
 =?us-ascii?Q?qrNTZ48tbpbX5YUw5ic6pmnfrtjI3AENWsaLEvm9BOB0mPGPpVw4G38Euomd?=
 =?us-ascii?Q?V63LARnZ7KcfFyVkXaKbQ5etGj0XEPXGPYM318/i1FZwO7FVDsNSHpx2xQGO?=
 =?us-ascii?Q?Vd87w6x4f94fIcpMMMimNtU9sQ3xXna4myH2CxQTNmnoMCWt0nByHm+uv8JU?=
 =?us-ascii?Q?G/cMLTKSZ3t6OBlFy/LoNol0v4eScMjwH7FCJPep/OH52BgeiHdOnOBFYigS?=
 =?us-ascii?Q?z8znorvw7t/j3Nala0jR2aMoZb2cR3q0xVWu2kdWouDUEbE+Vameu4WM0hqf?=
 =?us-ascii?Q?8PsbAJL5N76cASUnTuHR5VXDwlrvZ2d1b7wCZLb1HYVBk7Bn76C6c/H0z5b/?=
 =?us-ascii?Q?RDMa+Z58Cy1xWoUvG+usF3S8h4Vyvk36hUU8JzZ+Gqv+TIWbG6c/rEqvu3R5?=
 =?us-ascii?Q?MT+qRqbHT7nvAn2ro28L1nJf8Ut/MQiPe9sH7G+akGBOGrfYGMG1DFNJqwVR?=
 =?us-ascii?Q?3gTj5fPk58f0AEA26tH705HDWYYoeM4BiAWHhAddWBb2wlDYB0t6YVmq+QyN?=
 =?us-ascii?Q?oANAbkZ7/h2pAIf2jIXnWbJxmCqRzHkmDAVjmzQ9HprvVaXo8/JnkeTzDqUN?=
 =?us-ascii?Q?+pwQOpKiKOC9UpTk8iO21JGowRDANbgLlwgX+E3LBimyMIGj7AKuWCE2Y4Vp?=
 =?us-ascii?Q?5QdbE2ZW/3AWs0YWimA4BkVBiG5nDUwf+U4/ToJ5fHbcKmkyptd8mJaJt387?=
 =?us-ascii?Q?pNkZAK04sJvxxivLle1rtMJBYDSPN+huBaP0HhOEKor+zdT694FMDuZn4dVC?=
 =?us-ascii?Q?EfsEbE2CybtoQ+0w2CrKmj0+KaIQ7YgySnlPTY77Hu9FzxigTkZHUEr3Fw6M?=
 =?us-ascii?Q?GfPpfgGaNnkH6GJJUspeBcsMx1jl3t/tmF9AfBvxMKXV3OPa7r0s+8fOjAY/?=
 =?us-ascii?Q?LihxIIew3ckmvX2PIQMps7/3mRySHif0nbs4GX9i36kOOWekC2IWRBxIlgVd?=
 =?us-ascii?Q?yjjU+UIIT2eHr8Xd0l7d9ktP6uXCAicOZwZskDfOK5Xc7COnsFyd4h4nVCUG?=
 =?us-ascii?Q?qx0h8vyHYUZ+xAQMou13eFLNmJHwy4cN7PDuTEMoEcmAvynVnP04hP7AzEeH?=
 =?us-ascii?Q?DVyjj++2lMjQMwm5Dgr4s4DFybE1a6W+AHjVgq5zp5N0Zygy5OHTFNgRfLNO?=
 =?us-ascii?Q?yKXvPOr0m6rklORwYETGZXtr85AWq3j0lr5jhuKhBHpdipieOUcz5WhB5iAi?=
 =?us-ascii?Q?APIwmDsa77ZduOZlhs7KceVOGCeWjYV2hr85aRS59Zx/5V32ooOQv722Ji/r?=
 =?us-ascii?Q?S7r1RM8eNq5XAaj+V0HGhIjsYNvQY+sYsF2uiwHi4EZNk+D7kbMJv8aBJA4G?=
 =?us-ascii?Q?X4MtZW8J7dSej1tne+bK/I8h490TXsk=3D?=
X-Exchange-RoutingPolicyChecked:
	EDigC/sEaBWwXIy8VwkJGsFH7MVDTAHEOVqO+VS4bQkN4GqtgU2hVXDyc5n9eOH2EZBhLlH2dHOPCpPK1FqpiUU2QC4Wd7wHfWeWKbDf8tcRUqYgv53jo1YDQCbsDntOsJq5wbIhWU9v2ywiCi4XSjnVGMb6ZMmTYw5zFM1NeT2lia087WBIh+jTSTfukjNiP369QOvc6kWly355nBoZm+Inlr1FxaScMXTA0BNhW83AHWXPYnW4COi8BSzNZUHHxxNHqLexXCTUnHUgiHEQ69WKTZpQIIaiSm+RX+yKdrBIN1molekaPf2bhR9MNwygvhbxNOEWIwU4ksIPpxVDvA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sr1G+S/paqRLwgMfR23wrMcrxPOgeK4R2UH7Wc9O7A15qG+Qt5uQtqDxzxEimty36Fw4gV/Gfe+lj6+V9l+mrpcP+i8zgLGtq1gSqla322eaPmaH0Agiu7YTGrQMiNR+f9++1Tt4y8oaKrUGVvo9cPt2pWxTnY+p7rJ0BMUfx9QlShhYlZTTjFbAFIPYgrjJJZAO+rrj8Odcq8z64uvtbx8iX6+6soCn1grMTpU0KG+JwpoQC6ov1yZ/GrWHc9bBKlJUjB+tk1hB3I7z7++V0eYiUkkCBNoQNSvfgpAHD17sQETFCZBwzlMKnpxLj8Yn2qCbl/GvgbsixVKf69KpqaUNhVMSonUD4Ytckt2HTYzqB+RNbV+Wqb2PUKPfjbkymhviPPeYLXJTbQDSfCbva6JRRlQj8Qi2gD3BYcKLxrNwZlunTl+i4pJYR+ByBJN8eJVREVuwRMdge+fb0M71Sr1K+f8pmZW+6tfMMRin9EEu3GjaqSKWVmeksYWp/GgZG8R/qQefgAKsQpTMzoFP3AWrgVLGj3geBH9AzCvtxgmm+tUCgEx0zpPTYtiYD9YP7/wCzHv4NhLjuU3m1AhaSyaAezkcWqiBkCn2bUY6Pu8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91621f16-8f61-4607-1736-08dea3fc71ad
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 01:29:36.9474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6btCML7vIG+lRu5jVnAd4m0562z8TQdtCoVac2ty/0jBKeVFsGSEIEx5ikUBKOMxBHHXiBYRXuStiB9u/LKtl63UEM2ZpYFoZaMuQS6kcFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6161
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-26_07,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604270013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDAxMyBTYWx0ZWRfX2wsJnnAg8BMf
 /uTJZ34MziBwQ6/Vd07f+OXd+JSJcaDO3AJnKLEujxz4zSWEk0ECV5znJctWuUDK3fgZEj9ahvZ
 WEfrTBsZuNjgLH2OFJeHSIr4JcAfnFjA0D5vfV9jTygaF4QIL1qqI2bqB5kq91v3NGdevR0na/G
 zAOk9OdMjFHRbc8udgXrgQePgCap2si9UaXFHsWs8v9u0sDIIPVlGsbUzJ/HJNv8go9Xn1TRBBT
 HqBxa9Ubqzv37w9c2obqUNr9jiJLyitEAndgPco2PzreUSnZcxc2Jcn4NvWnkHMO5qzD+/jtn2E
 gIePVArkF9nVxhKWvLX77ALl49nVhuboVliE37Wm+x7TWikgkshMWKEomJji15bAHRQsSSbcR9F
 w1Iz9fdxYPH3J5tYbXlNu9gTeoR2PEgkfqZvMTyX8O9A+Am0s3Fvm937sZmVgQpUYT0RoTJSXrS
 SRP+4sPxAC5kWTb4QcQ==
X-Proofpoint-ORIG-GUID: jpHosgqmlm3v6dkxlisNQz8vO295afs2
X-Proofpoint-GUID: jpHosgqmlm3v6dkxlisNQz8vO295afs2
X-Authority-Analysis: v=2.4 cv=E7v9Y6dl c=1 sm=1 tr=0 ts=69eebc05 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=BXy-6XygjoaRhVGDgXIA:9


Daan,

> Fix this by factoring the GET CONFIGURATION probing out of
> cdrom_open_write() into a new exported helper,
> cdrom_probe_write_features(), and having sr call it from sr_probe()
> right after get_capabilities() has populated the MODE SENSE bits.
> register_cdrom() then calls set_disk_ro() based on the full
> write-capability mask (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)
> so the block layer reflects the drive's actual write support.

LGTM.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
