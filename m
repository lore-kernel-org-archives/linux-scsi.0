Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBE746BF;
	Thu, 11 Sep 2025 01:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757553471; cv=fail; b=YbtyATXfAiVe42t98glbH0ERhhw3p16qG0T2NayQASdfoidEVEmVlupSKbSY5H85zgQOj7639sXO+q3Ok2aGKpNyU7+e7/OQLLeZgFzMcS/+p9PYt3KrKv32vp4Ih96bvqpTT++j7ycZA2kM/Poa2a05mISSrN8wEuhqpsMD7Xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757553471; c=relaxed/simple;
	bh=oOJo7jqR16sfo7K975oz4Nru2d8MqTpRKKv2Q7DJB8o=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s27AWdRVSka5Ilttmc1duqSb0sEMnHjJnAreydw7d488t+lAlc/h5qvpyTWUsGjRLIW2vhh37T8sbFdgmOdrYZPMWup9IsGrsGQDuI7SiNW1vRM9ltXZy/GcXm5s0RI+OR4FVqKC1fpFF9igB+qppGci9ntnPuala+DIB01n3hg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OKtHuVQC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EMOOc7Fa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OKtHuVQC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EMOOc7Fa"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ANlxmP018673;
	Thu, 11 Sep 2025 01:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6k4FfqzTTzbAd1zQavI+R/q6drNyVjKmwS9kszflcvE=; b=
	OKtHuVQCtUf50Q5XmAvYQtHeyLJNfxzfwb0YdcUElKcZKw5EgQruvu/Ua24nOhvb
	tXZMebQzUJtlHWGLs2pU8iEPg4Ggexb6CjSbAJLo0MYsZGNr0p/3TLDOBKV4swOb
	RVnGeQyuKmaRXvJyRNTwkOhS28An8fE74NrjSaQcYC2Hty7kYJPTQdaUJHxrThex
	w1Ykfc1AY2ys7xE6IPHDi1dDJOnVW42XL3gH3y31gnXd+cnaLvYjCVP1V4y2cctF
	QBkp1kWJ9vHN3zQKTGCzrrgQoWjVXtYALFUo0SXNrhS7VBzjJy+p+WS8+P5HERQZ
	M846icfVQQT8vFFu5EmsLA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2wahn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 01:17:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58ANQvi5038913;
	Thu, 11 Sep 2025 01:17:41 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013007.outbound.protection.outlook.com [40.93.201.7])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbr8ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 01:17:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K5YQ3BM6UB3T/RTxzif8ZODIhN9bUEAj3/Fl1AV2iFjnKGAFFOQZuI08Ck4uUCheNcygo+fB5AoSCaNMKq4d8j+UuWQdZdK+tMbdwqqsyx1n3DN4H1Pm+ywIL7s6g+OdpjA10/cBAlzk2GIDAbyN8dMG+NImB/8GINvMLLc+lZkMZ7og12DnjwwzQOj7a4uMorknRslA6+WdiqAB9zPwSxo0nSSKCuvR+D2/pqRjyACXbxK7V2e2o0JBcsg/ZfyrCrFoMNPll33GKoG/vyCoeUB9aCJIZSBNEY7YSsyZVENy71lljeUXCXbPmvNmpiAi8yEne0uRc3GuIM+gCaiQiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6k4FfqzTTzbAd1zQavI+R/q6drNyVjKmwS9kszflcvE=;
 b=ygIg1h4jllctYmv9k5aVzbRjQe9STm0j/eSfibIviK7IHHYh8WEu/ofYglpPxJyWJr2EumJXVQR2ajD1Ic7Liy2UuvHttGEGwZ+/9qIw0MDqUQYxRVvJgSx42LHFqX3A1fl7IHpAlsFGQCWUaHoMAcIX6fRFY1fkJyQ9jaRJPM4D3UK2c6MaJTPn5gYInElwJtNcmotVhMUpiD0Gyr6vpHJwwx2m0powKcuOx5Rwos8bHEp1duWwJd9T0VJsLRAnPj2K/hHzF2LbhghgsHY62aqpox38Tkjf1xu6DjIU1RmfvUWMxtsjori3WlNlq7+9jcdluqqNVgfBut4vJvYNFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6k4FfqzTTzbAd1zQavI+R/q6drNyVjKmwS9kszflcvE=;
 b=EMOOc7FacK5pnl9feHSmt7MoaCsrkGVhPjFLw/DXlJInIgm+C4XHQiolP5Xx+gGx1pgHYM0KgqR7VdosJzKDsjswGWqFQlbdUNFsKqK7RTYXjY2GrXGchVxNdK+2jnYDJXtlWrMyA71hxWTFgwqH8RvUUcUmMZxKpvDGPO3uem4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CYYPR10MB7606.namprd10.prod.outlook.com (2603:10b6:930:c4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 01:17:39 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 01:17:39 +0000
Message-ID: <7a6fcdd2-de25-4ede-999e-a9d98de86e83@oracle.com>
Date: Wed, 10 Sep 2025 20:17:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: iscsi: fix typos and formatting in
 lio_target messages
To: Alok Tiwari <alok.a.tiwari@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250910190728.3783157-1-alok.a.tiwari@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250910190728.3783157-1-alok.a.tiwari@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:5:174::25) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CYYPR10MB7606:EE_
X-MS-Office365-Filtering-Correlation-Id: 29c2c7e0-9d8e-4d2b-dbf1-08ddf0d0ffab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z040MzgwR05seU5Sa2lOb0ZXa0ROSGhmbDdPMC9FcVNtRmRncy9NNGI1ckZs?=
 =?utf-8?B?aitLM0ZPVlFlSVhTc21YcHJQSE9hM2RUK21mWFBKU2VTaXdZUlRGNEVsYysz?=
 =?utf-8?B?UWJNRVArNE9qR0xIUFFrSm5LejZXMjlrclNKTDYzRjVvYjdCOUFOZUgxZ1JJ?=
 =?utf-8?B?dVRxSG13LzVseDlhY1FNdStKbHk4aE1KY2pYYUxRUVVDZWhLODNpY3c1QjhR?=
 =?utf-8?B?RU13ZlAvKzRGakUwbVllN05hZFltM3VDVGgyaGs1elZnSlAzNGJkNTZmaGJZ?=
 =?utf-8?B?RXFrdWttY2NkdUJ3WXNTdlI1NzVac2Y1S1pWZTc1a3pjam1IZ29iMU9WM1Bt?=
 =?utf-8?B?bkVwK1J6UXlXSDZrYXNQRkpKN2wwclQ3dlg5VFZMbTFTUGNOMFl2ZlVSZU0z?=
 =?utf-8?B?Qkx1dnA4b1BIZHFaaVNXeC9DbVBjcWJ1andSb1o0V1M3Y3Q2MitaVFVqYzBE?=
 =?utf-8?B?MGEzSGswSGc3bUFzNGFEc2owWEJQSUNWREtEWlRmS2hUZ3loWW9wdW10UDJt?=
 =?utf-8?B?aThjd09EanRIUnNIVjhlQjFaaGk0cVBsUitlMWszZFB3TjJlU1JCNlVGZ0dX?=
 =?utf-8?B?NVphSmtka2VqaXhoNEV4ZjQxZ1VQbU53UzNlVmVLVG1jbUVLSSs2Uy9ydmoy?=
 =?utf-8?B?NjBQS240Mk1ndThxMjVMckFRc2hSaVJFa2ZTdkpKc1UwNXM4ZlpxcW1JRGcx?=
 =?utf-8?B?VHFFMGVSOEtkK2J0OTVNZGVTdkhRQWRHY3pTZGFHR2MyR1h4U3R0MkpLWGM1?=
 =?utf-8?B?R2xCK1N6S3FlUHJmVVVXY3VjMjd4dVBlb0VRcVVNQmZMSmVMdm1Lc0FuelZp?=
 =?utf-8?B?N0wwSWR3Smx1c2hJTlpKa2ZxeU8rQSs3c2MzVm1DRno2OFFTK1Q2MUhxcUsx?=
 =?utf-8?B?eGhaMG5menliL0E4VGdKRTZkTjhMRmVGN0JYYmlDbmlVS1FMZE15UUpoT2gz?=
 =?utf-8?B?ZlRFdGdJajh6SC9aOEJMYnYrdDZSNVlpSHMvcUtVWEN6RHpZQUp5dFVITG5w?=
 =?utf-8?B?Zm1DdG55Ky8vVXRKSnlzM0hCa0R2VWRIM3FraUlPcVM3bytQVzNIa0VtWGVT?=
 =?utf-8?B?aTBQcUJyc21mSm9TT3ZxR1orVWJkbFZtY1MxY0NLRklBZnptUjlBREtJc09j?=
 =?utf-8?B?Ukx5TjVndjZGWG0rOG00alhEbUFSWDl4NDkwM0VvK1p6OCtjVGtFN3VYMFoy?=
 =?utf-8?B?UUVzSFdXcEwzenhQSmJKMUcyVVBHa1lFNkwzT1R4aTRyMEpWN1l6MXBMdVYr?=
 =?utf-8?B?WmFFWGQ1UENoc1lSWHFHUFZydWVCYUtYTmtVMUpUaDYzUXh5dTV5WjFqMEFt?=
 =?utf-8?B?UzF3TnFoNUNhRWJUY0oxU05KRW5nU1BoaTZKZzZZNkpkT0lrRHNFQTFJU1Jx?=
 =?utf-8?B?NmRFSTVHYTkxTitTOHJOR1hKR0VwMUpjYVZ3VmVCYUttU0ZFY2wyMXBtLzZj?=
 =?utf-8?B?ejRVN1JLdy9CeWR3OC9wa3BpM0pjczVVNm53ZXl5YVJRc1VnWFNLL1piTGdy?=
 =?utf-8?B?dEV3RUI1MWIxWXF4cUVQb1E4ZW1NUUZoeEVjeHF5M2U1YjlMWEF5L055UURD?=
 =?utf-8?B?YWpEbkhacWsxM1VkK1BadnliQzN4N25QWHJJblIrUEJEaXJzNVhKc0t4Smk5?=
 =?utf-8?B?bzdXRFUrOS9XUHFnUktTMk9OREZaMUNhSWloWTRRSnVjSnUzcmNaRUxSck5p?=
 =?utf-8?B?bFlDbStUTFIxTzBtaHJsU0hNS1RtZVp3ZC8vVDlVOE1WdGd2VGQ2ampOaW9i?=
 =?utf-8?B?Y1RwNWVod0Y2Q0FibTUyRXNqUzFadzBzaFlLQ3VTdmY2YUYvR3NaNU5uMGtE?=
 =?utf-8?B?bmV4MHhORythM2dUdnpIY0doRE1HWTZpc2xtaXdYNlY1dTBvc2dWOWZRYnRL?=
 =?utf-8?B?L0FuRHpwRmd4RVpNRmRDc1NMYkZPbExEOG15UVB0SGthdjZKY013T2xrREJy?=
 =?utf-8?Q?r55/h06tQpA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDRJK2QxQ05maXZ1T3Exb2szQkQ1ZGJ4VXZVRWt4R2h2QndocFFjUyt1U1RK?=
 =?utf-8?B?MzhUOVBRWEFSVmh3RFFja1M3ZFZIZDVHSGFmWVBPU3ZXUnpCREhoeEF1QXp1?=
 =?utf-8?B?aTdsa3FtUFNSYjI4U1ZaRjErcGNOcjNQWmlGWmhYano5Mys2dWpDMVZocGh1?=
 =?utf-8?B?RUtpUXFhWnQyNU1ONTg3aVFpb1FtaGk1czA4d1MwYnZ6SzZUdUhCZmlJZTE2?=
 =?utf-8?B?ZkVYbmxDQ0kvKzZNRG5PK204NVdFNmJtZU12YmoxSks1NFYwUDA5UWVPQVRh?=
 =?utf-8?B?THBqaGxyWTZLczA3Vjl1ZU5idktnd3hTb1ZraStoRE5xVjVldVJmc2o4Z2hI?=
 =?utf-8?B?amNBaHU0N1ZSTkJiemloeTlhMHh0dHl6bFAwYTdBU3JnaTFJOVN4aGJwNENS?=
 =?utf-8?B?OU5MVUVOSlVIdzR2UGdOM3R3eXRtbVJHaFduUE0zbjNianlJb3gzT3hxSlh3?=
 =?utf-8?B?LzRJSGlBTVZhU09rQXhEb0s3UXZVRGlkM0VZbHVQVUt5T3NaVnVYdjZiVTVa?=
 =?utf-8?B?T3p1ais2dTJrdDVIL1lBRnM1VUNBVE1PR2tuSkduTndWSGJZSnlDaGlDOFZM?=
 =?utf-8?B?RWdrOFJnN2tkTXJiTmpkSEExbVBXbG1OMk1meFcwUFpmZWQwZ0FlZ2k5dDVu?=
 =?utf-8?B?TDNqanJwMEVQTnVRUnkvQ1EwSnpsQ1NISDIxbW41Nk1sSStpT2U2MkZLeFUx?=
 =?utf-8?B?dGFkanRWRDFjUVlDb0NjQmxGQ2xYd3pscllCSkY1OXEyL2dkNXRrVk8rVXZO?=
 =?utf-8?B?T2FZZndwT2x0MS9saXNHUDk4RzVCRWFqYkJ0TU5jODBkUytHVW9BMmdSVEE0?=
 =?utf-8?B?YnJUM0hNZ0ZVdDhLc3dYM0pHcktLWm05WXhpb2hKclY1bW5VZGU3c3k1ZE5E?=
 =?utf-8?B?R3d1Rk5KVEEzL2tDZEFqZDMvTHphQWVLNmVMOWQzL1oxbFpCRGFZQzVrUWtN?=
 =?utf-8?B?QkdNM0p2UFo0NHNRWEVhZmY2NlVyNjhlaDZIY1JkQk8xcWo3d0JkcjBDUGpL?=
 =?utf-8?B?dkRxMXJXTWtTbFN4ZFdyUHJDN3pFNzVDeTdUT2hGdDNSb3FiZ2NuMi81dmts?=
 =?utf-8?B?N2tVemlZQmw5cGRnUEd4TGFTQkZ6QmNmSS9aakdFVVA5NTNKZU5ubENNZDhG?=
 =?utf-8?B?b1VZQXFlUkVLenl0VlF5d084S3VUUnNFVzlkUXBYa0F0cnFCMHFlSGZ1V3VN?=
 =?utf-8?B?Z2ZHK2RFc2x5TzdIdHNyd2pWZ0E0QS96ck4rRDg0RHFCUFBWZzR4U0g0WHFl?=
 =?utf-8?B?c1Vyb3QrOVpRTVBSR2t0S283a0FTbW5abjkzS2p4M21na3FjS3B0U0svWVpF?=
 =?utf-8?B?anJlQ2c0KzlONmI3T250MlpDT08rN045QmFaMXAyNTgydGswck4yVmY3M2Ix?=
 =?utf-8?B?MUl5SjF4WWdqSWZMTm55Z2h4WGRlVU4vQlM3b0tBM2ZJNUhLZGsxS2JwRDh2?=
 =?utf-8?B?Q3ZNTUtIRTF4RksyMklpVlA1cWNLenZpNU9BQVFYN2ZjZ080amJISHlLTUhW?=
 =?utf-8?B?TXkyRWJXSFNLMDJudHRWYlNXV3E3UE1sVVczWitNUnZHanlpL1F3ZnZEdlRk?=
 =?utf-8?B?V2wxSlJuSzJzTUxZSXBRM05mbGFLU2ovSkI5aDJYNnVCVkNzcUVTS3htbVFl?=
 =?utf-8?B?a1NwT2NIOU1nVDkrOWpPNytPa1krTHlDNjhBZVVOZ3QvZmMyVm1FbUtTUDJ1?=
 =?utf-8?B?WFNQSFV0OUVQemhTdEJWMndNaWxENXNvaUhRMXovY2lVYWdyNXI4bFFabXhn?=
 =?utf-8?B?TUJIU1lFV3ZnbENyZHVaY1dlbkxXWUdHUUN2TUFTUlZWeGhvS1VwV2VzdUxV?=
 =?utf-8?B?STZLZnBYR2t4UVdKQWVmcEZnanh3R0QvL2N1bTUxNzVIZEZzdXc2K3FObFZS?=
 =?utf-8?B?UXdsby85NHYvdnlkY2o3ZXlsSW5XK3VKWDBVc3VVd0x4RElSMVFxNEtrTzlB?=
 =?utf-8?B?cEliRVNDN2hCU3RjRHhaWk84NnhXUTlVNUpmZG5XdG5UdHIvaFVhdS9IdFB3?=
 =?utf-8?B?bTgzdVBDbjlob0RocTRXbVlNQ1VMeHpZSzYyVDdjWUNtWlFYc3RZNWFDa0FK?=
 =?utf-8?B?Z2lKa3lBR3FIL2JiVUROeXFTUFpQdmFoZ2pmcVNFSjBuUWlaL0w2WTYwZ1Y1?=
 =?utf-8?B?OUNnR2F1VXFiYUpjUTZnY0l1TWVTWXhWNHhMc2s3eVBlY29UT1N1ZWt6TWk2?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uFxp97VDhgDDjiz0gUXHfWf3A8QkYCxe1PE77PZQGocD8A/gQyU/aaWoKNeJ96JX4pP9qyIBuB/a7NVxrAmv3jkWAub8pkuBxge1NUzCuczvi0M3Kl3xRN4PUa/MLyDzMGKL5AK5A0zSx08cbOCbmQMBa99BBKMBCvschavJqWhmN0ZhxcVSzpt0GarIOWVbEtVN8UOjlbyoq/JZgVW4XGn+qc6fd7XYbAPXpV4kEpNaRvWFFtmKrLVP50NnpjwclWrC0pzweKz9zyeYe7agPTpuuqndNeO1YtLEtK5+9bZtN/38rSWeS868zPBCfA+dLkWsd9KBYqffk9eQRA6ldXRWIxW+pB59RRc3cneBwxxmxbpEZ/2VSm5Btt+VFm8NYa866QFSYdfWt6eUJ+YCkqIDomfRFw6T0qfqbOozov/BcsFwRccY5KqvDbGLJLtp1X9pJWWboz1xUVg/FRID3Yz6N+iVf47Ftn65aLLola1LzpWox+AyM2091MoXH/TFpHVt9Ed002DSY73avrCeGSjWWjSXqRo46gD9pholBI5ym/KuHE48f4GJ8Eoc3z0pMc/lH/Irr4MIWmAvmzrqIja0BAC+DHquExVEuxV9oBk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c2c7e0-9d8e-4d2b-dbf1-08ddf0d0ffab
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 01:17:39.1869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nLy1PoHwG/CCrbADfZZ85I/o8BMvg/xwd3al/MgNPfGI5DEdkqlgHDNYSwz/xyb70CpCBgigP0TgYRaUUU0PQ/Ytmkty5XThJv5aV0zz52M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110009
X-Proofpoint-GUID: m_QNnGs_tGcu5Cmkqgh5MYP36zO2Ner8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfXw8g+zURdy6BT
 4uY8SjVP5EKklikfDKP/kaezUlpuJkWphSWUiQkeVgWsbkW4rBgY9poZ+p0Iz4vmht1Fdh8GyIZ
 Puh7Ir52nviWRMdUzeDmBDLXavkyUQd5t7LoccItPFMWNDLhvUN8BrkzvrufBGQxGQi1gTuTR6T
 A6tcjFu1bGwvtG11Y8s6gKuvonBKoihDUkr7SM6StiuQZtZ7a+NKFpcYenu2FIYql6rWK3hf68+
 6Ti33Jztj6Os7cK5mBr3CgxdNNtcsm+MVZck5SY6cph06hUMUkMfohZFtpaMhSe7aunqEv04E3X
 dz+H8Wfe3mFv0zKl95lZqftYbhMKNGyj8RtJxhlnzlSb3qSCdEyQAYox9pSXSH/l4SXFEv1/IaC
 rIgeJe+wvLav1gUKxhXnMrXjo4tTtw==
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c22336 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=A8grC8wFmQRFXEc_IFkA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12083
X-Proofpoint-ORIG-GUID: m_QNnGs_tGcu5Cmkqgh5MYP36zO2Ner8

On 9/10/25 2:07 PM, Alok Tiwari wrote:
> Fix several minor issues in lio_target code and messages:
> - Correct typo "locatel" -> "locate" in error log.
> - Add missing space in pr_debug() message for better readability.
> - Fix comment typo: "contig_item" -> "config_item".
> 
> These changes improve code clarity and log readability.
> 
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>


Reviewed-by: Mike Christie <michael.christie@oracle.com>
