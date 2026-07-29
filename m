Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9B6469837;
	Wed, 29 Jul 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344140; cv=fail; b=BAzx5jaHKdLO4udIShFP1sBqYo6BZw1s7jAD0zanI5HqFFS5a2iUNMYKLtp9DsJ1oxb5XMhkzaFLBzGI+iY1EaqaLDHbyn+qiOxVdljTkGICh61lo+k4b+cALirtJ+RscgI48ObZbREheeq9xgRYAfKLiCej3fDnD2SRDsm+DSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344140; c=relaxed/simple;
	bh=TTd1B6kS0Mczm0S4NVEf7hbBXY3+Fg/kLRJClL6i5i8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lGLf8tcwMsk/Vyb28yhOiCMSNvpELCHqVdLLTPQzk5CCuHTAu5mcM+TYcbakYrusPpwCU7GTA08L0rRTRGIKcRhknjDVVzkB1ypV8GcIYlSy9ckyxzIR3zyXHoxtMhzig8NT+qf+UmzTrJqebgqe/OFqQugk4lWvExOdyOq5wlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QQQIBgmw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TH9bWA4x; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QQQIBgmw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TH9bWA4x"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTbHB2983513;
	Wed, 29 Jul 2026 16:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A826rT1YB06RH8Me27R464SaTdJYehaeW6M7tKEvitQ=; b=
	QQQIBgmwVfBo5JChyqZMpFcAJ6XNMQM5DEZ6rSYQ6p3UOMeyQvw+TVJQm6PC2YQn
	0uH2fgFMw6Nwqqt7zkEmVNY5YZMqcqXFINnIA8F+YjmAshSzhgKncAHdWT+zCItj
	3MXWW2826gq23PtXyJkVdppeoMqP9cwPId5b9tzzTcDvQGR587i3SNXaK1dGI+6Q
	Z5+mQJlCOYMovv5v2lGrxgECWqWxPzfm5Kn/+CPFx5whoZGU/Meuin3oW6Xdx6h+
	xbiSdOhAJGTaxjQguYASXu5v3OXeinhHwUPCnQPekjwjcuhXLs3ZhlPR8RkKaK9V
	D6spP4B9IfmQtc8RwZ/ooQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1de8y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 16:55:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TGZDhj001808;
	Wed, 29 Jul 2026 16:55:37 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010061.outbound.protection.outlook.com [52.101.61.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fqjwu5q9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 16:55:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ImwDR4mt3+W1/gqXfD5sc7701zC4oOODw7PJPftlDuJn0Hj0CMpuytg2x86B6wigVhCDzkCyTdDebsepVqAmeoB5H07FgRUffpVY0oVfLgLG6XSgOR5JtLk7bbgfVXkas7s6ca4APrRmy04Al2VUiS9GyFAuepCukUnSpDEGSq7UmmKGLZf6IcXP+iY5NyJOi8npelbLnqPDVueIzq8kZs19nJsB9SIr/qi8FQ9R0//00X81Ck9y4OwMdCi1Sxaa6GeH4GrspmneacAfVz8r6M6SnxEU9pa6YqgG7lsjDPY64WlN4v7Yzmn9smmAEwCEXemxcUpjjoNPforsrlNkyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A826rT1YB06RH8Me27R464SaTdJYehaeW6M7tKEvitQ=;
 b=mdJq3satyAm6ZaYcYMrI9YVoY3xE8ex8dowFZjeOnZ6/saYZHiqwYDm8Bj0XxV3x1dViVv0zYRndig/uwWhIcT6oQJnTNBOcvKFEzq1WBdcquvAYwuz9wNH0FijYmLmKFoq/JlRVnvl90AruC+0smX7PlBotg3OIOzBADaKnFZYGMOYw4u7b8WGz+BortFIIV8/ey3n9yPVcW9SuhvNHDGwAH2I7bbLPNzkyqAM0TlfLuG/Ac8Xmp68HkIWTowhW5xiDOn5vZyaJU3QxJg73SmKT8DlzhpJjRETKM6ov7jGF3znfEYmWS0Jfuu/DAdnL2Rbu/Isdv4G4qUvVhDlRbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A826rT1YB06RH8Me27R464SaTdJYehaeW6M7tKEvitQ=;
 b=TH9bWA4xkzG/ZuzZL8LM57a8zgP9qgGh6UW2STxH0SkJCstl2toqnKeM2zAcirre6+oMrFzX0U2+bhv1hsSUjHpSWO6wUYSjiOVb36KK9GvATWcX7SSub7G1L2Q5z410HEPRWpnd9jt2ZvNlwoS5DfJV7d5PxdCNnEQqLUeibEQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 16:55:30 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 16:55:29 +0000
Message-ID: <4df1735e-635e-454f-bd9d-cf820174c79b@oracle.com>
Date: Wed, 29 Jul 2026 17:55:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 20/27] scsi-multipath: add
 scsi_mpath_{start,end}_request()
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-21-john.g.garry@oracle.com>
 <20260729161243.C918D1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729161243.C918D1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0249.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 23702b99-f68e-4ae9-b1ce-08deed923191
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10063799003|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	tiM2iS0S7Ib1HA0unNERs5CFx6KXYM6f10y7Cz13FXRi2SmLKWb00MwlGJsGw2c4kYP8m0lb9wBiHH9NBaIWdsZmsRD2qmuSiPTWM91LqUh6OGeoAGROHdjf7JTvssTAMK4P63MLXBA93TzZUbmrTI8vhLi1pqGiQ/XxWbg99JkEDk0ZTMZlsLlDoJLjTfioKaOgpMzv2NL/Eizd0F1/KXbyKb1XomMcBltCnt1vKLi38R5eu+GJ4dO7YAoUV+SkAJjN4G29GYhmmdNh3d0lWAJMmw3dbPHt9K27Obk8R37XXbNHzmvIFn2/iLkLFjQspma5NilS57MjXP3hparUlf9vzvRzRm/KU/ty/RDaMhbW1s9tvPYntfc8ZF76rdEy9wQutX7IYp1sZxcgtKbucsa61nO8IaCpTfAzGCs+Eh0SHMP5kjLLkGUWNv/N5p3vW+O64gmnYdvIr/w/U3+SjWYnJZLQJydqfFvitJitwjWzKSsqFsdcteYlj9D0DAr2UmDZo9y3IZe1P7KgIr8aX36Dm441/wYwzoxJFILOcLSWqesTHhRq2DZnuRtJwHbuDwWPln1pSnM4QOJu9ZJihfgyci/q9KMOuPuAscD8UDjFVLnHoR95fnJAObLnlBvW8/jINsoFTFiH8MApU4F0zz2Cr6GT5YTxkV3WZHEGD2k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10063799003)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXJtNnk2QVh2WWZmMnJ1MW5RZmlRZ25iUzIveXhaSDlQazFKNEt2NGV4YTNE?=
 =?utf-8?B?VUR0MnJ1cWRObEJQcGtyZmJSQ3Jhb0YvYVl0bjZPRWJHdTJGMWw5RlUvQ01Y?=
 =?utf-8?B?ZUNJcWIzbk5NcTB0V09ZTnpZTzVKcXE2dGtuRVhYdTEzaVR5aHN1dFltVEFm?=
 =?utf-8?B?aXgrZEFwaVVIY0kyTWpDNFBWbmJscUxKeUJIVmFCa3hhRFVsRTlnMmhOK3RC?=
 =?utf-8?B?U2RDNngyRmRCWXgyNk9xWUI3Ym5ZbEVMTDhWcitKSEVQUWcvL2RhcXZxcWdh?=
 =?utf-8?B?YkFiVmtobytIMlhCaGRJT0V0UlRHT2NBV1NxNlpqQmlTVWdxanhIN2FzVEE1?=
 =?utf-8?B?eVYxTnBFK1dScEd6RGE0TlhsZFdIai9XWGJibFRWZUFycnJyeTRmb0RsakZs?=
 =?utf-8?B?MlliTkFYaDRCSGZDT0pxTEF4ZnZwNGVZTTVCTXpaR1ZuOXoyM0NhYytQay91?=
 =?utf-8?B?NXZlRFk5ZzRDUEFFV0NSNTNITno1bmFXelZweXZnWHRkbGtPd0h6VG9BOXIz?=
 =?utf-8?B?TVVrbzR2REJDc0pPMXRGbnZuc1ROSGZCNHhWU1AvSkUvYm1hRjZwWURkVzJz?=
 =?utf-8?B?R0JOMTd4SG5BQzZaK2IyQVBJQmU3ajhFQ1NIbU1YT0syVGFqZHgxYno3NHcy?=
 =?utf-8?B?Y0ljNmhJdm91UnBTYUY2UTlCakQzRmhPdXd3ZEJRYmtRZzlVQzY1OTBJa3g5?=
 =?utf-8?B?RGxqSlVBUGR5TUpZM0V1dm9DNHNZcm9SZzBFWnJVV01JcVZ2OEtMbHNLTHNT?=
 =?utf-8?B?SnFHbjJPdEhyMXdmMXJydEc4UnZFSUE1ZUhxazgyaUJDWnBVUnh3ZkxXRm8r?=
 =?utf-8?B?SmEvV1YyMVFCeGt3Ni9jcnVYUzhIRDNlSzZscE1rOHh2U3ZjVDBJR2p3TkR2?=
 =?utf-8?B?cHg1blI2eUhQVWEzbzI1WTBhZEFOMTg1Y3FmVkNqbWFORTBCbjAreFVMV2Ux?=
 =?utf-8?B?cGpKL1FHd211dlFrVGVKY2JOS2Q0d1lOTnpydUZnNEdJZnR3N3hBOVVadjBS?=
 =?utf-8?B?bExxYTNKc2NWMDJ5MzdSRmRiMDVoYjA0Rk9lM0hqSW5UMG0yaUNhNnZhbWxJ?=
 =?utf-8?B?Q0JXaVk5V0VWSGw0aWRxeVlEZUM1dzg2SlM3NFAwdStkK0NuUGJvWjJiM1VE?=
 =?utf-8?B?UERyTDd6M1Rkd2drQTN0eFlIbUgxbG9qaHczUkVrdzgzWVJ0QXNua2pRbStN?=
 =?utf-8?B?aG0vcWVwY0tSRTRIcER1ZTJPdW5MTG02TUYvU2lZaUN1V1RDalBJYUhtYUpJ?=
 =?utf-8?B?WnVWWThTdGJ3SlM1N3g0WlNzaTNZT25IaHE3TXpZamZjYjRyNytUU0JGN1RL?=
 =?utf-8?B?UkEvYnZ0L3lRRGtPK2U0MTZmY0lUeU9oMmhEMU5KNFdoeUJSR2Fva2lreGpJ?=
 =?utf-8?B?NGFHVGs4ekpSa3lXa016UkwvTWZWNWZ2QlBpMzgwcHFsR3BuSFYxb2p0Ympq?=
 =?utf-8?B?SFVpNTNkVitjM0lERnplODZpM0NRN2JCcVZRbmVObzhEMUpxdHlkazB3cmdm?=
 =?utf-8?B?Nm5sNHk4M3dzUGlZYnR2anJ5SVV4bXNlWGhsUzZLZS9KR3ova2E1cU9Lb2Qx?=
 =?utf-8?B?cGowTjdFaGpnUmJFTUJHbEo3S01GLzNSS1c2TTV2UzJQbDZNUkZqZTkvOTdT?=
 =?utf-8?B?ZWJKQWZZaXJFRXFKY1YwS0pKN0g1a3VMY0x0V2RDN3Q4bXlKZjhJQXNZUUtv?=
 =?utf-8?B?RTVOTzYwNUpJM3N0em95Mjk1cE5yVzlQakNxWFR6bGhxbjg2L0l1ek92RFBu?=
 =?utf-8?B?WEllZ2VDZ1pUZ2xmZTkvOU9HeFR0Zjd5NFNhOWlTa0ltbmlYcVgrQmlMUS82?=
 =?utf-8?B?VHUrZGs3RFBRMnU4djBpVkMxY3Z1dy93RTFTNFVnWWU3eUpRY0JMT3dYQTRh?=
 =?utf-8?B?MTk5dkZwZ0JJd3FEWDlrSEhneG5FRExReHh1c3c4NDA3cUp0TEVkR1EzcUY5?=
 =?utf-8?B?NWYwbXZQL2U4eWw4eW1UZGJiQnV1aEZrblQ0aHBHNUdEeU9GK0kvRHgxOWQ2?=
 =?utf-8?B?OG1GcTd3SUV6TTYvRU9ZS1pQSFRBanJhVzVla2JxeXZZNUNlSXQ3Uys1WUNN?=
 =?utf-8?B?WnlNMlZjelJmTUNsM3hhYTJ4b2JzNFRSNU9od0tzQ3l0S01Lanc1dU1zRW1U?=
 =?utf-8?B?UmRlWTlCamNndFV5a0o3eEZRRXZuTDlFMVo4dUthN21LRTB6VkltZmVXa3dT?=
 =?utf-8?B?ZW82VHh0NkFDb0FFbmRQYms0dk9XQ0dCWndNRXJvaXFiUnhEalZCamRLeU5N?=
 =?utf-8?B?RWJTajRCWExCcVh4R0RPN1A5d0RaVDR5RTFQTU1WcVdYQmhUQ2JCcUFDMlo0?=
 =?utf-8?B?OEF4aHJ2dzhiSWx1RUo1d3RFVEJOeUpoMmExbDZlUE1NRUgyS1VabEMyTDBu?=
 =?utf-8?Q?+4Htc2VdOA/6PkXk=3D?=
X-Exchange-RoutingPolicyChecked:
	ClDM1EjbbOsO8cq4kgB/pkKY8KyCpFs61M633ipodc8YEIxKf7EOHwcWwqmQb6n4o8YjYv5bX6x37iZ0u3+GhpKWa446gLXEUSxz53a3CfpWSQfnwNvW36oT5JzMTBBT/wnJnkB+ZFPWImsLLm67q5zlFsncLbXnUjWowOVvwPeoTATO/8hHfpRyiExgb99/58o1028SbteAGlkOOZIQdNM5BlMlhb+oMFJZz+3yLtinfcAFHGqqom4kn47BBAla530nGnS9m579sNjDTBvM0eRkbdzmQFrVNWiT+6D98rGLtoLu1ILTuVC9Y5rbHJF+JqiGgKC7JOCkIDdvenhS3g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JC522ICQwbbpSxP9Dw/sAjtKMxyXqYDgE3uSw0j50B/16NbQYdl74mCYvDSp+5AZczByAY+5kBW3nwBcy77W7/IsBVcnb7nSDIQ25BXJRXpJ0puHsTicdr0URD+5Dty5Ox/fBS1ny3IYMCnAK8a3TwbDtQPVRhOhqHvvWb1IueVAUwmr+Azaagk3kFPf4+BJtQiW4t+7zvoGzgSoSlcNe5vPeL8ZaYxAl41w2TJXZvK4xeRZjl3MCKKy8PbaYpGBJ3Yt0rOqTZ0vH/9KOxigBZCNyRA/++5/Lb42Wqrg67sLd5cRfQTjJptm6VS43zHuXEsUbizrUoneqxmiPwhbikRPMUBQOsVoXBJ+1Dz3d5Yhqp4ISItboqPsolBTCTWL3JstaSEnSMXtDUYRwd76dbaPQq54R836dXdXf4uYb4WAB9C9uE3I5E9IfLP5U4iapaMjjMk6vnFbMpi2kPnBCYyImgNKrmqPEv5cEe79bbHq6Ut/NXhRzsST0lJmExcfr509ywXBC00Jpcd5D1X39RTvnTQJxXIRfOLTn4lcOmue5LNydjgJ9dG/c8f9bf9/+OKNUjGVpdRWAZdy8mtr7ZgUse0OGB7p5IttYK548yE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23702b99-f68e-4ae9-b1ce-08deed923191
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 16:55:29.3490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXwW9bJ8UuZOP9z5hDKmEolzII5vtqChhP5LLGaqc9u5i3Z+5wGN2B+Qr/LDtl3ha/yISQnvKjsbUjO+Et0hag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290131
X-Proofpoint-GUID: _eWHKM4o8B7fwsTwJbYlWgmWlqHlsvTK
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a6a308a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=-b7duZgd1Nnqqtn2uWQA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEzMiBTYWx0ZWRfXw05MRXMtZkCT
 EGo8IrO/ngBzCMtvH4US/8ej1r6aUAxPmHRi+Hrj9ZJMJUzzKtISFSeP37jZ7Ngm4hbVbsqsUdL
 jzFZBKTlXX8JgiAfMy6qv45o05g2FjE2WWj3mqToME8XD0MXlpae
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEzMiBTYWx0ZWRfX8mFd/O7T8cW3
 oUOqPaZdvEx8Su3SHcc8wsA9p6djuCfnblj7qFAj9TS3UExybRhHWMkDzK5WwVDKwAAO+wrBFFV
 Fa/qv4gASDdW7Ho5rkBz46zMxyAmvW0zIBWF03ee2Js8zRipGT0LYpqqy1YyOVkp+fWp6FYnd+B
 yQVqKbmPFvpbaK1fokqoiVvzHFYDYskUPPfmFtkwdTY44YFaiRgBSBTSKhjKuD/SAevFZ0xjj5q
 tIFJJCc0gIYwNnVZn1y2qPz0uhyL3evs8NyPYQSqN6Qmc8SKimpH6yfm7+IkyzgyYf6SpuwgazD
 8vb2axNUhQIXxd0lyit9pPYDOp7ZQSAcPDkN0EEAxeGqCQZ72rP3455uO6a2y4Ze/7WvkD4p3qF
 pzVTHaGzomRZM5ZeNkyQ5xWWB2KcWlC4F9ZEWrRvc5u7Xue75ss2OWrPzQIVrH2FPPqGna/J+vr
 HsJVqQ8je6uVolQ1iEw==
X-Proofpoint-ORIG-GUID: _eWHKM4o8B7fwsTwJbYlWgmWlqHlsvTK

On 29/07/2026 17:12, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Permanent leak of mpath_nr_active counter and master block device in-flight IO stats when a requeued multipath request fails with a hard error.
> --
> 
> --- Patch [20]: [PATCH v6 20/27] scsi-multipath: add scsi_mpath_{start,end}_request() ---
> commit 1a27bdf4453d197f11533d04e7997e7873652eb4
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: add scsi_mpath_{start,end}_request()
> 
> Add scsi_mpath_{start,end}_request() to handle updating private multipath
> request data, like nvme_mpath_{start,end}_request().
> 
> New member Scsi_Host.mpath_nr_active is added. This is required for queue
> depth multipath iopolicy.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 6a2d7dbfbe8c3..ce9a2c7fbe707 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
> [ ... ]
>> @@ -1917,6 +1920,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>>   	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
>>   
>> +	if (sdev->scsi_mpath_dev && is_mpath_request(req))
>> +		scsi_mpath_start_request(req);
>> +
>>   	blk_mq_start_request(req);
>>   	if (blk_mq_is_reserved_rq(req)) {
>>   		reason = shost->hostt->queue_reserved_command(shost, cmd);
> 
> [Severity: High]
> Can this permanently leak the mpath_nr_active counter and master block device
> in-flight IO stats when a requeued multipath request fails with a hard error?
> 
> When a multipath request is dispatched, scsi_mpath_start_request() increments
> mpath_nr_active and sets SCMD_MPATH_CNT_ACTIVE. If the dispatch then fails
> with BLK_STS_RESOURCE (e.g. due to a full queue), the request is requeued and
> the multipath flags are preserved by SCMD_PRESERVED_FLAGS.
> 
> On a subsequent retry, if the device has transitioned to an offline state
> (which is common during path failure), the early state check in
> scsi_queue_rq() returns an error before scsi_mpath_start_request() is
> reached:
> 
> 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
> 		ret = scsi_device_state_check(sdev, req);
> 		if (ret != BLK_STS_OK)
> 			goto out_put_budget;
> 	}
> 
> Returning an error here causes the block layer to directly complete the
> request, bypassing the driver's normal scsi_end_request() completion path.
> The block layer will eventually call the scsi_cleanup_rq() hook, which merely
> zeroes cmd->flags:
> 
> 	cmd->flags = 0;
> 
> but fails to decrement mpath_nr_active or call bdev_end_io_acct().
> 
> Would this leave the queue-depth multipath I/O policy perceiving an
> artificially inflated load on the controller, permanently degrading load
> balancing?

Can be improved later

> 

