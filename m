Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778C140F8F8;
	Wed,  3 Jun 2026 08:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780475131; cv=fail; b=S7VLbyS9Sfm1zf3BWrR4pZVteyNnFIH1BCu4jhxVY6UrqomyKoQ/e1ziH6QK6fKmHKIpmlkiWNmJnhyV7DIN4qKKexSumdicMbgEhlLoLb+0S/mzJH3KDVoJxxaTUCjAaXjjRtYZ4KGp+7Kz+J4pgfhx9rByeVFMF8YJ6pNGbEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780475131; c=relaxed/simple;
	bh=05NyayNhq0NsiUJsPA+Zh/g+pGpYxTm96g4XYcTUo34=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U1bKttKOMd3Yw11fbyH2+F2BASnP50u3IPzCZmXAQH59tjH0dmhci4t8ZUIj99Y1kym1rQrON2wE8+rwKghgOyENrnnyLXfcqRNcRKjFTrf8wBjN9Cx4UBs5ci/712ez2tDbLRk0U70dVEF7EEecRHG0hsYET0lHp8mgKQdBTLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I8nFmD8r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I9tPUyW/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I8nFmD8r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I9tPUyW/"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65346wYf1671863;
	Wed, 3 Jun 2026 08:25:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Cn0JyYT25+OOy7u7HDW2+a7R2noT3szEVcARU6nRx9I=; b=
	I8nFmD8rlv+yeqPCGbSVWzHtVqjqlMYrEixyYx9xC2faPyEeU0fUnS6XsZ75Uqj1
	Tqd6a5ueoQQRI8SwpbiysUCBw548oJC63INe7Safxrq72SFKIVI9vRg4ToBeF5Fj
	N2TYNt2Y6arojiQSDKitIyPTm4rB8qlgMvDlX9cl/Mhxokdv8MfFIn/aWqYC6WCd
	Vwzpj8fVxHyRT7sgTt69ASmzG76KrtDVyTQnxDjNECurjopwWAh/lEpIrTN1JM4A
	izU/exiHOJk50tL/6hn4V2s3sXC8gBbWa5a3bw1SLrXeLrQcS0eosmIIxiUUY/tE
	vrQS1LV0FsSurnN2ykM3qg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqxddtr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jun 2026 08:25:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6538PJHi012971;
	Wed, 3 Jun 2026 08:25:22 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ejfwbhh8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jun 2026 08:25:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aW0eziC7uiw3osoAAJdIuVm/apl5wfyo6GJ8HW+srirnT10O9T6YqjhNobLfQE9IomAjM6qWGlru/Yh8O3kqYwRXu3LFYE0lJlD/lfUQlvRXvyOIoIq+9BDG6KeV5a1YoCxpOfgIA8IPIyZgTRv5MOOX1uh/qYivqx0O7JlQvkYAUmxb+07Xo0DohkDdC5KszedS7ep9CK3p61z+0x6XWuadlpg3VtLIhNAoBc9LlGGwuMNuyMpr3gMO9/xBdBXHlOVBYqi2dR428JRlQcrD1ukp6WMMR8VRDNJtOvED48zEnt48du3ev1eBZlAGGEnBnwtul3llHxVJDOyWs1JNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cn0JyYT25+OOy7u7HDW2+a7R2noT3szEVcARU6nRx9I=;
 b=aUuw/cUak4/MWQnyuEh+a6Y4hnx1wYuqkILNvfrNI4eQ2PoetZKPivVCqu8eUHuoCCuJrHcSzx8I/o//PJ/XGrcvwETSAgN9quQh3e/FrHCc6txRWW/Sba6r9WMhmrpx4SqQs2d1LLUHPpgYpn41trrNGKMWgnpHKZ9j9oDWm+yKAKPcAgCIIpOABE+5AjFziNhubWrrg5ZegicHr2sLnXC1Q273/+a+caxA9xyNRXgiZY+Ny1oIYFYX4E/sBVjZwkjVyUE0uWBj3YF1KaKaN7h34sB35FExczUuyAseHznfj1mLrYJ1v7D2G51y+y3KA0oc4IditCV7fKD75AiI4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cn0JyYT25+OOy7u7HDW2+a7R2noT3szEVcARU6nRx9I=;
 b=I9tPUyW/4WibPf1Pnf8yERBgUcGu1t6YCxQa+r30wAjRdHd+rj7zHLLkkIR4f2V/CvG/7+Ycs7g0Rgg10DwzSFU4XyXh5IOQ0nTwHoJKC7ZD8269Jq+ipWnqd4U4l2lQh7qXFXn1nU2+j3jF84ENs7Rsz5qLtw2KUQZIDBDPpcI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY8PR10MB6907.namprd10.prod.outlook.com
 (2603:10b6:930:86::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 08:24:21 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 08:24:21 +0000
Message-ID: <8a1ba462-50ac-45b2-9d38-4a2671f7a1f9@oracle.com>
Date: Wed, 3 Jun 2026 09:24:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] scsi: target: fix CHAP_N handling
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260602115840.26490-1-ddiss@suse.de>
 <d8126fb0-85ac-4b1f-b6e0-b4e206ec90c3@oracle.com>
 <20260603091924.0892d415.ddiss@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260603091924.0892d415.ddiss@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0302.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY8PR10MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b28933-1dca-47f5-6ce3-08dec1498349
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|4143699003|18002099003|4133799003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	B1EHonUinkpaVPZH2/iNJ7B7IgFIx/hNMg/LQO+0Myff8BpTurUhZ7j3FXBSU+24TNcz7ZNIGeAohUaHv5Vdo23xQM8hsZ3RWE9F0+pFacXVyC5F21rPfCHWeto93lTwccXzvBrPCsEe8+zuI/wG7l6bKsY55g0dgONEzRscu4vemDimqwj1Mf8xG5NNprGqQacgDigBg+nJ5PIt6LcovIu2JfvqjozIRP+YF8z+l//SUn0g4tePYJt1Z5SM6n6quo5jHgULgW2CRUZHP2G8xZQTBybZvWLD/G7RrpMbowRiwN65MSXgE/DLQ2crn0KaWZ6ytFcJRmsBRwOsC8SCTLeRAj+20nIOa9oWao+Bd3u1OK7e4dvo+k++9way8hLpx4ekbMPf4uFW+XQ1wVRvEaPeDJVbx5aNy+eJJUgXzFHpoePCKZXXS9tKJzBjOvVMBQsOQ4q958lR3qqxoHebHgv6IcxBhE1hNUEYhGvdHMWIRAJ6uDbAVI6IMA82VusPS2qBhWOdiac9LxY2HZqaY8KfDjP11xP+7eGl+Sum1MDJ2GCUV4320aaTPR0c86XxVynT777A6Q+yeYR9fgejpysPbhObx5l0pUq+kcy1QdPMxBYlJoqRQuHqHN4jrTvLzOeli5Wz9XaoFdHbEO5CFw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(4143699003)(18002099003)(4133799003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFJVSnQ0UjZtaVFkc1BDSUNSVDlUWVU2bEYvVzNPaTJRNk02T284bVFRUEg5?=
 =?utf-8?B?aHZSNW00ZEo3Tmg5NDlJU2Y2cXFGaTFTZlVhdUVqU05va2pKNGQvYTE0bng0?=
 =?utf-8?B?eDd1U3V5UzFGTU1TR2ErQllUdzJvbU82Q0FhNml2Q3hxczV1anFXcDhDZ1pR?=
 =?utf-8?B?eTF5UDVGZUgzbWZVUXpYZ2hEakptZTU2YlNiemwxOUZ2eWJESUN5V04zVjhp?=
 =?utf-8?B?T09naUpaVFNWeTR1T1FGTkZBd0VpTUI1MlRsMk5mSUtuRjZ0SXpVbERPRy9Z?=
 =?utf-8?B?WUhoQUNWZThwTUUwUzFPaU9kblJ1Wm8xY3Nsa2R0ekI0dlc2VmJoMHd0NjlJ?=
 =?utf-8?B?bFFCdHR3NnRIdHhIRjcyU0YxblM3UDIvS1RKUjlEdGpDQUQ2d0lJa0dsS0tw?=
 =?utf-8?B?K1dPUE9MTHovV1pYUDRSZ24wVytFUlFPb0FtZ0F3UlRZVXZJSW1lcC9kZDcy?=
 =?utf-8?B?RG1CWGNVRFpwdk9Sc2xmaUxZUWZjUUV3Uy8rRXRpeWxid1lkanRjWWR6N1pS?=
 =?utf-8?B?UDExS0RYKzhGWXhpcHdQNGliZTM0dXFNeSswU3hONUpUQjBhazcrYzZwRUNt?=
 =?utf-8?B?RUt3cU5mZW5pNXo1dnNoZmN2ekNZUjRMTGJFdXU0MW5IZU0rck9zY3F5RUFW?=
 =?utf-8?B?b0ZtbjlyVkJFU3AxNjYwcHRTOVlIT2pnVzNaZVdNZkQveWdzdkd1NmQvenZV?=
 =?utf-8?B?T1diVVAzbFc1SThJenlOMzNQZSs2SkVoNko4OXlBUEZLTHcrMCtLY3Ayc3kz?=
 =?utf-8?B?b1J4VVBxTmtnNVZXSDlWRVhyM3d0T25RL1haWEZLQkxqREgwUWxCcldHdkx4?=
 =?utf-8?B?Umo3am9mYlNSVnYrZGlubWVGdEFtdVFWeUk2Zk56TUZqeSs0UEVPSTJEb3Nz?=
 =?utf-8?B?WmdUWVZUdzVxRTRva1ZZaEZ0RFFwMVZPQUdLUWdiczNGeTE4S3ZrZ3htV2wy?=
 =?utf-8?B?dldHV2x6eDJ0b1g5YzFqWUE4R3MwMjgweHhicWNUTnlHWTBpNURxNi9rM0tW?=
 =?utf-8?B?UTJVWlpvdUtYSlAvMDk5V3ZoMnAzaE5YYXVzNE5XSnBCRUM3MzNjeXRSckln?=
 =?utf-8?B?dFF5QmdoOVlZUnY3OGpjUFRVLzgzUFVZL3lEU1NieitBMGVuRWp6YkpIcHRN?=
 =?utf-8?B?cnIzOHBBN1YxNHM2YytjSEd1dWJIZlB2cE5RbThyeldNeU00VzlYV2oyUEhI?=
 =?utf-8?B?OXJnWmhhSmhPVlJBV2RTSXoxQ2ZJeERZaFk0MkFVTi9iZWhRVTZGc3l2NHAy?=
 =?utf-8?B?VDVsdmcyWVhnRitzWDJEQW9lVU5NKzRZaVRtTEJkNVVFZDV3dkw5Zk9rQ1o3?=
 =?utf-8?B?TUJjd25zWUtCUkVMcVNmZHhkRnpYT0RYOGRDb2I2dmJUVm44V3grWjdhMURQ?=
 =?utf-8?B?TVVDSGZSVWw1Y2ZOVHBMNHU3NndLVHNDWTNKVDl5QUNKTmd2QjMyREVYOUk1?=
 =?utf-8?B?MXhGamJodWtjTVlyRUJTR1ZBKys4ZkFNbVNXK042QjhCazlwendmVFVGVVEw?=
 =?utf-8?B?amNUT1JuczZKWjRQWTBzaXoxQjdxcDVHeXV2MmNta2NQYjNseGg0MDBMN3hi?=
 =?utf-8?B?cmpkYkczTXFjdDZ4Um5xbVU4TkI4SkM3SDAwTVRoemNGSkpFQk10Y08yRjZt?=
 =?utf-8?B?NFBYMUk3WjhSWUhvbTJqTEZCNDJYNWhXSkxxbmg2aWliZ0tLNEF1UzQ4MGtl?=
 =?utf-8?B?M2RxNmxONGNUemNSajRCT2I2Z0xzVHdvRXl3WnBZNkR5ckhLUDJ4VlQ5VVdr?=
 =?utf-8?B?VEZhOE9leVJWQkhmWDlNRjBSYXA2Rm9EQ0l1cDBYQk1VaDNncDdnQ0pNUitw?=
 =?utf-8?B?UURVNjFlT2NFc1E4cHpRZVJobEtuMUtnT3lteE1iaWlLR2ZCWU55M01BV2FR?=
 =?utf-8?B?Z2tCWTJGZ09RT2RPL0s1OHRzVWw5THB4NXcvaUd3UUZrVUIvb3NyOTFHVWQ5?=
 =?utf-8?B?N3ZYTkREb3dlWEZJeko0NTRhaGllRXlWZ1RSNWdzSDYySVRiYkpQK2UzMHZX?=
 =?utf-8?B?RDM3L0ZaeXlsZGlCTSt6UzBUb2hRMmRKY0tmbWxPT2ZnUUQrR1NTanQwc3Yw?=
 =?utf-8?B?Y0NzZzVQaGNvcFBnS0Zvdk1nLzFqU28yS0o3eFNyWkgzK0twY1NmYy91cE1Q?=
 =?utf-8?B?WkFCZUNWVlpBSWF3Y1JLRGZBb05pK1p4YWVJVDJYNWZnZlZ3UU1QM3A4ZGtM?=
 =?utf-8?B?NnVYOXBRUW5qV1F1d0RFVXRidUsrbXNmVjhKOEE5TzMrNlh1Ty9MR3dxQ0Y1?=
 =?utf-8?B?S3dHclNXcDRyQkxrQjZtcytkdnV3UGRsVEZVVDFDdmdrV3BGTGlEc3dxd2ZS?=
 =?utf-8?B?cSs3bVdCd2paRmRYZEkvT0dtazc5RFR3ejUwS1JEMmpwZDNpaUthdz09?=
X-Exchange-RoutingPolicyChecked:
	UbrQeSn62eZVEFj1alUx3tLUwywvHZ1iuCkyb8vNUY6c3ex3w4UjjpQRHRGLjpGtGghffCpfPSAJYRzhggr40nkBKM84jodPeP7r7jpXG7caDuBlwWR0Ic6BJY7RxSSBNMkUZNx59CnpVZ1/QmTiEUJWEnOGOB80jIt0Edm0AQ2ZYZrs5EbNWhBSOxx8krKc0HihkHeOUMLygS4TVSda+DGjDTRzcm3Y5W6zys8tgaMzvCD+uRJik2GQuOZKDajC9qcnuq2enHWpSjN17IEGHcqNNkWqAUScfIiMGh3W9ImdiBjIxIGc9zD4x8TgFLk15ccxt5H2AOgN7KFJq0jsmA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P5ubn10uMiU9jw9w4CxXzh2rlkdH5JX4VDGXIOLY4vq1xAddgIC7RTDeBPrYlAthPuND7mklLxMs5zb7Ojyt5895zrw5OCbQA30GCGeGtuq2npGCfVZ8QTbrBpFjjnOzkFTiVSELbbgDG6n8f3FBRQBotQSxXSulaQ8ZoRcRLOoikKtFaF1/mBlqA5e3yEAm5aAux9VGZHfN2AfeLtytJCUnIuymBWGSNkAUIks645U3KhZHIwJ7wPVUhdfbBeXMLLzPIBsjlyXyXdBRktm3mDVtGjEQ/R8DRL0nfhmM8QbCHDAYNEfAKkg6xp2bDyF9lKG8pf1LkMtBfOJeTaCKklXk2eEcg3gLW1GmTmKaB8Zv6bm+hhfxkAIoDey7YB2bEPpU98HCcfxZEMbqIRoRcWcT6m0ui+J5VXDzxBil+RNeMUCg3kZLeBZIlby1mIz/8L/K4BcmeM2y6g8HSnValiudfaRZw0hZif77cTaOMxeU8mMCFJE6+1P+q9vLfMyfYEOKIA3gsNIyINADtwozYo+jc/7GcBQ0juBYOo2K6zpjZ390epeCuZmxvg11/mQyiouZdeYbiaB94XjtpwPBzPds1QnWOG6/slnSFNtNgDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b28933-1dca-47f5-6ce3-08dec1498349
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 08:24:21.5399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1T/HD7LptcUK2bOidHwsmIFWSGVZxDgItN/VnT4rIbKoqUhzW2KE+l3YHFA3B8PCpkuHwEa2Whv3PPNzYN5B3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_03,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606030080
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDA3OCBTYWx0ZWRfX+i502MICtgLm
 BB+cz57xNMjgzBwblbeJ6Ds5Vhg3uCmx/dp0LwhHhRufAg8sgzWk4v4aN/GGNqsiZ9MeoYjV1jV
 ugND9YOEwvb/fsD4ZNPZumSpA51FVcj3nJSrDTBjv2Jb2pJBoXc6E7hj8nO3/j2jQEr+ZfaRLG5
 iN97kygsrHI+cVunbjJlG/HfldIeZhZicYBc9HgYfxg7Otc3rLhvN1+pMxzITY/sztHvtgt1g5u
 1TDzO+Rc5OIt/hAk2/zoct/nValndvpvFA2zxhwyzf1tjSpPy0QvM0vHIcE2TugG8GeJnugNO6P
 AIJEMJGvr70v0xld1sLJR73Os/QPpc6eq3Xx8i7kfl5nwl1OZogS5W2ZNjRRoaad0JXXgoxaX+g
 3qhY+5McZmuPncLXlQlBIahHpi8fB1+KI7Ma6TRpJyabnhuhoaPzNHRi2/1yYWH/9FKdeVyT3EG
 CQoYLDkhZ0CDyW2eTbqCqJsoT0d9yTa1pC568W+A=
X-Proofpoint-GUID: q4T58fNgqXcSM2KyI95grvk5pHaFc0dC
X-Proofpoint-ORIG-GUID: q4T58fNgqXcSM2KyI95grvk5pHaFc0dC
X-Authority-Analysis: v=2.4 cv=Po+jqQM3 c=1 sm=1 tr=0 ts=6a1fe4f3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=c92rfblmAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=RwWQKyDnMvpg0CGhvU8A:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12302

On 03/06/2026 00:19, David Disseldorp wrote:
> On Tue, 2 Jun 2026 17:42:57 +0100, John Garry wrote:
> 
>> On 02/06/2026 12:43, David Disseldorp wrote:
>>> The sashiko bot pointed out issues with CHAP_N handling recently, when
>>> reviewing a patch for a separate issue:
>>> https://urldefense.com/v3/__https://sashiko.dev/*/patchset/20260521151121.808477-1-hossu.alexandru*40gmail.com__;IyU!!ACWV5N9M2RV99hQ!MNesZJ3IsH9Mv0iZxHUcVmbC_3uwDkJgMhAX8i1TelyqqZD_dAq1cwIy6RtYI8D3boJh5iFeGhtTvfTX$
>>>     Since extract_param() unconditionally strips '0x' or '0b' prefixes and
>>>     alters the returned type, wouldn't a valid user with a name like '0xalice' or
>>>     '0bob' have their username mutated to 'alice' or 'ob'?
>>
>> is there a real world case or vulnerability being fixed here?
> 
> No vulnerability -  the "real world case" is as above: CHAP
> authentication currently fails if the CHAP username begins with 0x, 0b
> or the upper case variants. The bug is trivial to reproduce.
> 
Understood.

To me, this is a fix for a problem which does not exist. And even if the 
spec says it's possible, it does not mean that we need to support it. If 
0x prefix is part of the username, I think that problems should be expected.

Anyway, the code itself looks ok, so:

Reviewed-by: John Garry <john.g.garry@oracle.com>

But the maintainer can make the judgement to take this obviously.
