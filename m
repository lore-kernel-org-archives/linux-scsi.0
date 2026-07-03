Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B888332E729;
	Fri,  3 Jul 2026 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783090145; cv=fail; b=c0BxqE6ejScLtWL/7CDTKxQ94Xn5frXC8QxqgZiftBM1EuF1n5K+OkexJ4qbEJPLLR1z3PuhkqOdrFvfAQ+t+RZTimyxvHJlTJaHGmj2QJORU12YHxwjUURNIH0GtiGYIN7C8shjTUAoezjXtMgCmuk1Ce0xXLl3/3m3GsIGh70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783090145; c=relaxed/simple;
	bh=vZ7bSbOaTlHK06WSete245F+7KX/VnwFIldwBTVNGws=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HT5LpwZ4ubEcQcwkJnWWfSSeSLeSpsmBClnDYCFYr+WAzrOM5zUefIn7at9KUVihJgAF/W/nxH7tKQB6yXV5Z1fjT2/bRQULTyaeMiFBwNDg4EPZ3XESzc8b3Afrp+UjsakiNkc6AOdsmV1pKxmykOLlew22shzMHUIX50pqywc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sXASy7dG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uYALq0VC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sXASy7dG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uYALq0VC"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 663EaM7F3689038;
	Fri, 3 Jul 2026 14:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yPQsqFsRlRYt+0Cl8Mzj89GIi/T9kr8E4pn0LhT9z24=; b=
	sXASy7dGCnUnc9MTfbFknMKduY73i4zMxIuIexaWsHJvm5u3oaY1GwyEgqYuYX4t
	dhUR4ZvLPSlgFys5bFXu5uTHGoq8bS2EIYyr51c7MrIqOJMlaK7dDoT5QpNNtc7W
	DVWar+7iQJLHF2jo+NEJcHA/48gBsxtMvXarybZcYDUGbV2S0Ompucsw3v4k8gff
	lcfvvxCADWH2VNi7xZTPPTD6DcgfCkYHRivtv6c8eJa35cLR41F+umRN0vDzWnON
	AzWKf1rpw1V4mkSr0ziFDc6uHgMAla/QdOOGcERtz+8BNe6g2pYS0RKmhbh4LNIz
	QKkgkoRMRa+PLY40TLz+ow==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqb3kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:49:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663Em9RZ005549;
	Fri, 3 Jul 2026 14:49:01 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010057.outbound.protection.outlook.com [52.101.193.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yv5ese-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:49:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxcmsTMzuf1m6bWBLC1z/qLAZGB0iHHMtWqhycPVVpjZzC72dxPzL0bsTDz0yFdAA4jaR8xQeeyxAT6CcZgddwyYFyOwsfxymqVKAA3CFr+0qunc6SRNoDhKbxBjTPfw9ITQf+F7vplVwoGfOSKa+9WZ3yOVGLzI3mApavahigNff5Oe6HoGmEM/50P82oQHWLXvMHsu/OAgKmqwn47ExL/MY4UvYWsN6gc1BQdPGoFWBy/tE4JCSvVUeq+/fU/0by0C4qsYEEO2N4o33VwNHjKG9PfKJ7Ct8NH87GsGJIw95d93Nwwh5H4PMyVJObKF5LrU5yQ/ilfciUZsddS97w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPQsqFsRlRYt+0Cl8Mzj89GIi/T9kr8E4pn0LhT9z24=;
 b=lUXYdg8HBj1LdAwh03cgXhcrFIEb2DAQYzZCALYXYUG2xSXc/cOhgLf1GnrfXN6SgYO40UbUgoZNX+iD9dNOQcnn5QZuNwj1rm5o7voujEhHsIbNdWvXktZ11N3jon/AimQyNSkAiTKq3PrvC1Yqr/ACKi6VmIkaEuJSk9KG0CvO5CONT3UoL8+atUiossaNEjixh9hXIwQG2lL50tYYKBLtvbaTeNLtdk6xzZaIH1yxoLHqpxRpAij3TEjRBylD2tHGWUBgq9NrhlhJIqu1jVPW5Qz5zOUJR3DyGvTYmQZa+0IPN2DBIPP5a8c6Se4x/9B1mJZRFlNiEX5pg42OCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPQsqFsRlRYt+0Cl8Mzj89GIi/T9kr8E4pn0LhT9z24=;
 b=uYALq0VCQ0SOhVnro8Ylgp68PnVTEKWyK+/kefP/Yw0MmH2Mg0lGFxsYigX2onFlELUvPxv4C1Pn1OVG05RGLiYgaHpbhmLoK4/kvZQUi01yGftOPCibESfMfLvK8CvUND7L4xWvTh3OF0ZMMh+T1Qh+z6x+ICOSX15Rcvd6bfs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 LV0PR10MB997615.namprd10.prod.outlook.com (2603:10b6:408:340::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 14:48:59 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 14:48:59 +0000
Message-ID: <7857df14-e143-4798-ae6a-3a1ec4cbd2e4@oracle.com>
Date: Fri, 3 Jul 2026 15:48:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/13] libmultipath: Add bio handling
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-5-john.g.garry@oracle.com>
 <20260703104915.5EBEA1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703104915.5EBEA1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0052.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5a::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|LV0PR10MB997615:EE_
X-MS-Office365-Filtering-Correlation-Id: 348db3fa-e506-4232-3198-08ded91236ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|56012099006|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	6saBggzaWlycOSTjxyS3YVbtxW8g8lRG+djoAWLo1guoIBHB94ltpRBicmSesPopnWI6sw9YzVxWuVY9K9cREE54D17dLLPIb63azg1tdajZ5aKeIbtM1csZQEEM/PROs4yB3ku9ZSyQNTVAxkwuhWsq6olyVrPe9KhT3PX0wqALgVJ+sq6v97dpLaEGsY9vNEgULSAUgiKnZHx7EOcGPld8m05T7qZoPmBqDS6O4Vmn9rdaoTmVljynR32uNOTszwwYa2OiU5bP3UmUQjIkQQzKq2ZvZyNSmdMvb6cE70paJaL1pxd9F7O3Kl6/15TOpAKscXrDzRofgoks4tU2OMbB97G0vnuvmDtH0RGEGb1eK4UANgPSIoEI1IDC9CXivwgvbSKVScsR+0wghJFaTWtGfgXzRK5uASDagUEMF99MFhtPC4Bu61qxs8j9QikZOTFyM/p1IsKactWQLZTowHtRek1pdBTAlkbE2C7eZ+DxZ+sJdcd5v9wxsPHwx4JQ3//8XqhUyszOg09lfJH5TBoytm9PBlu4RPhHlTXNGvka81Ljl4+xBhbXkdutaJgOmRzCxFvyQrhBMZLvnoFZ16Gxg7E6+7wh1k+nRaaYx4QihZ3CXU+KfIFxeJMft1qZuod+0iC9PFNOCCCcz/ZKsw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azV1a0k5dmJBVUdpeWYrbHBVTkRlVU8yeVNIcGVGVVFKelU1QWJybFN6Y2Rj?=
 =?utf-8?B?OXU3VW4rSjVvVzlNc1V6VTl6NXN2bFFpSEVGVHo5Q2lxNURQRDdmR2ZLSjdB?=
 =?utf-8?B?SHBpNGN6MVpqYjU2dnRGcWpUcmJSZmR1QTlkOENVYzhqeTRkcmY5NHJlaG9x?=
 =?utf-8?B?UmlEY2FNVWJHbS93enBvRldjbmRsZzgzZXdid0R4WVBwbUJsdXY5c3BQZWJY?=
 =?utf-8?B?SHdtYTZSY3ZXLzU4cmtrbUcvVmx1TlFEK3daSUZHWVhCNWMwVkFNQUx0Y0Ux?=
 =?utf-8?B?TmhOSTNOSHJFdEc5ZVRVMWZYejBJMjRUMFNNd05UZVc1V050azVRY2hKQUNk?=
 =?utf-8?B?dThyT0hMZ3ZxRnBUOERsMnJIU21wUzlyUjMvc3VTVk53eDl6LzRPamVGdGpX?=
 =?utf-8?B?WXdtdWRpU1lEMElIUTlsU0h4eUFxdi9PZGE2cFdPU2R4eHVVcVE5TmFCNUVy?=
 =?utf-8?B?RkJhY0VwTVoxajNpeGxnNHArWmh2UURmbTdUNlozNFMyRXcyWkxmUW83c0o5?=
 =?utf-8?B?WDhZYkpvMG9ibVJKc1ZzVEk3bE12WG1NYjJmdi9JdG9mdWRiRkd1N09qZHBn?=
 =?utf-8?B?NVFsRVRtM3pUd1lJcmlhNzI1VnUrZGllc2w5eU9hWmFXS3NwaTZaRTNxeVg0?=
 =?utf-8?B?RmJ4SlJXUHduNHlpVFg4clp0WWRkbFBKOVEwWC9NUy9vK2lCYXR4c05uR1p0?=
 =?utf-8?B?OUZrWjFNWVg3aWtVUGFsM3hYYWVScjNwS05ZVFJXR0JFeDhINElvYkllc3lF?=
 =?utf-8?B?ZnllTVFmNzVTVTYzT1oxcjBBNVhISno5R3R4M0JyNHJhWTdVRFJ6YVRBRUMy?=
 =?utf-8?B?aTFKOUZPVU1jR0dqaEJ3UjF3S29DL3FWR3Y3TlFLRU4zMjNrQ1dQODB2Q2lK?=
 =?utf-8?B?VkJEcTd3eUFZM2NKbHdrdzEwUWtrMVk0aXY1a3RiSjc4aW5ldmNscFc1cDBB?=
 =?utf-8?B?NjlBM1V0Q1J3VEJHckppOVJxZFhkWUJMcVBQQkFxQ2tjNVFxamxmU01NQnpi?=
 =?utf-8?B?SmlTQTh4UW5mcThrdVY4eHFaZ3E5VlU0RmltV0tDSkJGbml3LzdWQXdFclkr?=
 =?utf-8?B?VnZJNHdvVEY2K3pqR1ByMHovcmEzN01iMm52Vk1MUFJlMXVEQTVKY3I3WnBU?=
 =?utf-8?B?N1NuY25WZTdaOEQ2NCsvRE5OL1Q4b0llV0hjb2k4ZUVva0Y1WnltQzA5Z0R2?=
 =?utf-8?B?aGFhcVB4Vm9XZlYra3dmL0RsQlJ6LzhIMHNlU2l6T3AvM0xwdHJuKytJd21J?=
 =?utf-8?B?R005OGdYUDNKMi9Jc1FvdHhLU2FKMUYzS2MybFJIbjFPR1phMWRlc3lmN1Vx?=
 =?utf-8?B?Vi9NNThXMzdYZTZFdXVRTWdJM2tIMEIxbnovWDlFaHB1TXlkYkk5NnZNc3Jk?=
 =?utf-8?B?dGl6TGlBZk05V09SYUJiNTYyZmt3N0VsZTRBTHJuQ2o1TW5CcWt1b0c5MWt6?=
 =?utf-8?B?QXpRTmgzaE54OGxkeStnL3ZFd1Z4VXd2VXpZZVUvL0U2TkRlUXYweU9sUVRP?=
 =?utf-8?B?L0o2QVhwVENjYytHVElQZ2tBMUJlVmcvT0lLaXRJaFZiWW5FL2xFMUxUNEQr?=
 =?utf-8?B?V1JvYmtUdUpOeU9IekVPeDlaaldreG50K3JIK3ZQbzF2SEpWRUJBdEFrNFVv?=
 =?utf-8?B?b0pjN0JCT1F5MVFEZnZ3TDVFMk03U0xBcWFad3hIRUgwUXU1K2FCaHRQMHlF?=
 =?utf-8?B?QjhhV2hyL1ZrY0MydEtibGQ3S2lEcXpNNkpIaUJSY2g3dU5ldHNLWm9RcFp6?=
 =?utf-8?B?cXhmUWZUUjJ0VTgzQnVwanpscVNhcTdxMHk1SzRMR3dRZ2c2WFRzVkVSL2hW?=
 =?utf-8?B?QkpQNE5JbXNpQTFZNWs1czN3N2VwMStwbCt4VGhSd2NLdFdkZitHNGl6UzZ4?=
 =?utf-8?B?NWxueFlrOFhxQm1yQWhFTEhzVGkvcCtwZzdCalp2clUvSGNKVjUxeFRyaTNJ?=
 =?utf-8?B?U0lCN21KU3ZMbFpSZitOUFZYQjNiSVM4ZmU4T0VMN1JqVEpSU2laRkVBK2xM?=
 =?utf-8?B?Ui80QjFNZ1ZIV2dORlczQTJFRTBHYkxLbWJzNGZpRm9ScTdwZHRUYlNxT3J4?=
 =?utf-8?B?RTRBd1RoZks1M2NoMHU3Vnh0eEVPTzlqeC85dHloS0JMWnRKcklRcmVXaEtn?=
 =?utf-8?B?VDFyMzgvamlVdEpiYzhraWtscFUxN2xobS94RWtaeTBBVnYwTGNCZlYxVVVo?=
 =?utf-8?B?UzN2ZjVTLzVpTys1cVo1ei8zaGliT0FUbU4wRDFmWnFGUWEydnRnZndiWWR3?=
 =?utf-8?B?VTBoU1VSUmVoU3pGN2RZUFBQWloyN0JER2kvbUYyTDNkK2w1cU9SaWk4d3ND?=
 =?utf-8?B?dW9yRHJ2ZzJFWlMrZEFhRllKV2NwUUdXQmhvSURKN3ljRXBNRzBGVWZWeE8x?=
 =?utf-8?Q?St43Mxoh9wp8+69A=3D?=
X-Exchange-RoutingPolicyChecked:
	aF0FB1eD9Fgi6nELORv77VURdl7SfEngekJnGkbW0dnRwVHfVvBkAIUdnPbZvsUucH7N5XLFZL6lkI6Lb6yAFWAiqrkvgCn1dHj9HbaFBdYqf+PQjLvhG+v+OQodsVCg73DEfMfCulpSNScRGatkzFzwmr4lvzaa7u5HfcjlbqXBqVeT0oHwRYKJqWNxGk3o7fG93DMWdRptQYZfCNuaPhWMpfbxuqtg/oKlL6ktsbx6Gpox0lt637I5UOcUanvGFfxp372VmRXHpyAo01PIs7QI36KaNXvYaVcTca8wLdjJhFsCOTAT+b2V082UkiNqkGVNkeh2v4JhQYHSPl9Biw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I4NnjVo+3H3xvDiov+d74S0Fq8pZZwMYiNjF7BGVssAiouSaRqLjN1gKtu3hGqevnB3GRZJDLAa7gAKPBMCMKyYC9ZGdeHsXPmvBSjDfanpDPSz3PgS4RHISxGpRXa8iqhjL6Pn8dWQ1V50d0mgHwE68kai7RXMO59gvVBuXNxWyIabXVSzpFdUjxptVLNFLDsvEs6UyKXAsmfWSILzj3pn5TqUqfoEvRsuBPY/pC+Q2OiKDX3Ln11GI1Oo1shdm4Kk1CqTOZUWNd6PN1gTTU2RZ5NxoWLmlUzPPI9ZH/rsUIcCqJwnyjmrYTj1jbuUZ7RbchBUtAQOXBa4/jKmk/bVkCE0+mh8Z88nBsmKFW/QtK/fLgIBxotpICQ6FLwtzvPGudbQoWpQPqIv5msPUrVRh0CY+BQLZ+m3XRbpHeD4AKKtHqLYYKrtpDbxJ+8yhSI6H/ESViEZtP1zwsG12o0TZ8dx4es0M+hfYScik3cRvGv1DYRc1xirgK2mAiz85nFX9n3CuY8xG2F5heSR3gU5+SQjplpdGTA0JScE+e8zvofNGNfUKIFYPnVkYgHSMf5tuYuBsCdFelZtYaOqAH8VSh7TfSGz6AYOixjdp2hg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 348db3fa-e506-4232-3198-08ded91236ec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:48:59.0078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWxkg/qK/qWkHEFKMmv7OX5P6oA/BOV4IF+ecxfNhjm8J4BoZiR85OIqMvSTedfJpzL1LED5C/yrp2iQ8nqLGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030146
X-Proofpoint-ORIG-GUID: JqmbGvSOuFbEjJu_m2kbq6K-XBafenIx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDE0NiBTYWx0ZWRfX78XLipJcw+hh
 TQQxOLsDXbEx9upmvH+y2lZv6fomiEcBv9LrWbKxWo9Kq+9t6w0mDrua/iFXxFqanfanMJkqqJR
 R/jNnacRU4MBb/QQsC1POsBet89rpK4rE6QFY6LOIbrS/kYSM0hoG4kAJF5QgAqY+f+dkmt3LIT
 /NiRKpKQ9C0kxktkiaxk15wSjltweNGwp9t+5gpDQ18p4VEOxMWa8ZjytWAB2HHq43HkvflzN8G
 1ZMK0V8th7c3w4d+/FNtn7y11fximYQYeDsY36Ngy+J7Gq8uLexw7UhiSitYvuBmaWcfk11RI7d
 zVkoNDoVIn3SFkxAwBEM7QZlLJBdnPxbMQLc1llNwp9MhPfuYTcck44D3OAfwKGgbG4qiwda0G5
 z5ixn+cZQZ1OTAfLZvYKXsifZTfA2vqztlqAOcKEMcoFZJzUnD6gpUDSc1In7E6OPkojvvEPS1D
 v7mme4fs9RaNDq4nMkA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDE0NiBTYWx0ZWRfXw6QnWnXPKBcv
 G//C8rrseGBBvVl7rTgQlakaDSeywM3RB0VaWgXoCmiyqlP8oZUNTYNxt6j3lvl9G+rOoOQ+BZY
 Xh5WiC5mvzEseq5Qk+6nbV56Rq4PzyhGknMIzk0ssms3JFkOjKoC
X-Proofpoint-GUID: JqmbGvSOuFbEjJu_m2kbq6K-XBafenIx
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a47cbde b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=FvO75sEVc6Oq1wgAEfcA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22

On 03/07/2026 11:49, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] TOCTOU race in `mpath_remove_disk` can strand a bio on `requeue_list`, causing `del_gendisk` to deadlock.
> - [Medium] The `trace_block_bio_remap` tracepoint is called with the wrong device argument for `old_dev`, causing the trace event to emit identical devices for source and destination.
> --
> 
> commit 1f99dbf217347b66f1710f734eac617209a4e8c6
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add bio handling
> 
> This commit adds per-path bio submission support and failover requeuing
> logic for libmultipath. It introduces mechanisms similar to NVMe multipath
> to clone bios and submit them with the REQ_MPATH flag.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 21f7ffdb22d60..81e737c1ce469 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -243,6 +242,81 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
>> +static void mpath_bdev_submit_bio(struct bio *bio)
>> +{
> 
> [ ... ]
> 
>> +		bio_set_dev(bio, mpath_device->disk->part0);
>> +		/*
>> +		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
>> +		 * enters submit_bio_noacct() for the per-path device. The EOD
>> +		 * check already passed on the multipath head.
>> +		 */
>> +		bio_set_flag(bio, BIO_REMAPPED);
>> +		bio->bi_opf |= REQ_MPATH;
>> +		trace_block_bio_remap(bio, disk_devt(mpath_device->disk),
>> +				      bio->bi_iter.bi_sector);
> 
> [Severity: Medium]
> Does this tracepoint call incorrectly use the target path device instead of
> the original head device?
> 
> By passing disk_devt(mpath_device->disk), it seems the trace event will log
> the new path device as both the source and destination, which might break
> trace analysis. Should this be disk_devt(mpath_head->disk)?

But with bio_set_dev(), the new device is from mpath_device->disk->part0 
and old is the mpath_head disk in mpath_head->disk

> 
>> +		submit_bio_noacct(bio);
>> +	} else if (mpath_available_path(mpath_head)) {
>> +		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
>> +
>> +		spin_lock_irq(&mpath_head->requeue_lock);
>> +		bio_list_add(&mpath_head->requeue_list, bio);
>> +		spin_unlock_irq(&mpath_head->requeue_lock);
>> +		atomic_long_inc(&mpath_head->requeue_no_usable_path_cnt);
>> +	} else {
> 
> [ ... ]
> 
>> @@ -314,11 +389,34 @@ static void multipath_partition_scan_work(struct work_struct *work)
>>   void mpath_remove_disk(struct mpath_head *mpath_head)
>>   {
>>   	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
>>   		struct gendisk *disk = mpath_head->disk;
>>   
>> +		/*
>> +		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
>> +		 * to allow multipath to fail all I/O.
>> +		 */
>> +		mpath_schedule_requeue_work(mpath_head);
>> +
>>   		mpath_synchronize(mpath_head);
> 
> [Severity: High]
> Could scheduling the requeue work before synchronizing SRCU cause a deadlock
> during device removal?
> 
> If mpath_bdev_submit_bio() checks mpath_available_path() and sees the disk
> is live, but then gets preempted before taking the requeue_lock,
> mpath_remove_disk() might clear MPATH_HEAD_DISK_LIVE and schedule the
> requeue worker.
> 
> The worker would run and find the requeue_list empty. When the submitter
> wakes up and adds the bio, it will be stranded on the requeue_list.
> 
> Because the bio holds a q_usage_counter reference, will del_gendisk()
> hang forever waiting for the queue to freeze?

Yeah, maybe we should do that. This is same as mainline NVMe multipath 
code today.

> 
>>   		del_gendisk(disk);
>>   	}
> 

