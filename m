Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEFE2D46D9;
	Thu,  4 Sep 2025 13:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756993777; cv=fail; b=Zcr7hul1fVx63E7zgaZetsCYCjxfHtYwFxCkj9pkFIQw3KGzmG8rM8wqct740FCkyJ11P/S3h9Z3GjZQlECZZYudjif9RVU25SB27dQnclOrlj/9kyMUwIMASWtUyyRX8O7FdHPJv456XxaPy6luWqnseFe8HNDUu71RX+kTKKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756993777; c=relaxed/simple;
	bh=yVXBFhCBo6shUdS2fmoG2sWPWQU2sGQM/Zjxa5P40/E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q9sA1HT5CI+VVutwj8D/cokg1ce7YPMQcCA+/VjuZL4nmEi+oQaFQGG7eZRnmp0bGjsRVeecK2kjFsaXbXhgmWcFemP7FFueJ2TaU9AVzM2Stk5E7C5ihRUrRihw178LpuwETr76C2iaYekJlQjOlxOtIil4Sw+rYERF5ZYoIPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dLP6zVFY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ADruwfKk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dLP6zVFY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ADruwfKk"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584DPYAJ029685;
	Thu, 4 Sep 2025 13:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t9rUeWq7Ey11bI2JQVP0AAoGyGQwzxkEQYUub0xIlMM=; b=
	dLP6zVFYDEORQANSfO+JFk/+OsSZ3DBvyAO36UWbTGp5j9qN4w6PIeSp9WroKPPp
	xierhU59PbMnik7my7dP48rAn4SPW5/CiryTmOOTa26BDl1G74pNDv9kCcoOOikx
	WUgousY3bIrg9CuTFdpMYT/9i273d+/ZbXodmd2CaWhghPv40ehU0+a4Ib0dA/+u
	somDX49CLt0+tWKbfABnuymj1RwikjznDXEvLJT7noMvG5BeEHId5+UwqN4IVUo9
	Y+e0oRrBWpD2zb3rXsreWxdldQaX+OOu8x/rUj9YMC9Z5N4d7Ptnx7/F3vJsuMen
	I8FBcUwcTgY0oosDcPKWnA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh027n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 13:49:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584C8dWY015810;
	Thu, 4 Sep 2025 13:49:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01qv6v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 13:49:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmu+KKV6hxRvNO1I/iEyS+vcGS/lg/Mix+aNhlvxfO74lFbV9YJf/4fKSdAGEoAKxfPvzJ3HbEqTuViovHhy57g/m/7h2cJAH9vf+pEHyXeEV/ee9PhZqeVCcERKiDNkoKyJ03TzKbdiUhOyjbyXwQWiK203NPoySSwqFkaPsPG9X0+frNZxKy5giZMwLx+e9RFq7VVFvZhzoRmGoY2TMtvhMoAuWca45iLNXpswxRZXALPMCYx+B303AtieHNG4eTU9mvJFJdekye9e+OGho6egx8zmw2XVQggBHGc0qQNzctoHwCPglIRTAsJPrGI8Hm6UE1VIhiP1BH6rWK/FAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9rUeWq7Ey11bI2JQVP0AAoGyGQwzxkEQYUub0xIlMM=;
 b=imcu6Kt8aMWFbMGaDTiyX6crjj1jNzPhgCFCOwSqMU2K2oA/AzAM1lVBFZMfAxo583LDvVsDuttsoIlBVwwlP8dJ3a8+ApqIfZ3T/q6rhHjnU8rS3EVptUhxnJSE2+W8gFCCtUQmPzxyHC8Fr6BwcF+AzlmGoctdG4x3bIs30m2xFr1slksCkbMgOHmZhx6Weg1DFv59C/U70Yb1C41QARDHH4Rp0H7Q/bbBpD6LPd3qJht+yYuo+itzn1ggX+7U1R0/HlIIdKqX7pMtqDkA5OnWnXhyRbI09RdoXYRNvSzgAZELmhbu/Bwo/eKnGhMnT2ndA3ACOqcTqzy5JtRkJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9rUeWq7Ey11bI2JQVP0AAoGyGQwzxkEQYUub0xIlMM=;
 b=ADruwfKk4jrgljmA3CyWHGw9X7Bo1Btbk4G4uWzpI5Ql+fjJeRYtrhwElkvC4YVgOmRDFiWLy4YhmANssiGlaCRShKwwKch9v0mmWEFBj87nGO0Bn0tVBz81ALMvwtll4D3d5Bpet6rQ3GgVGUt6ra2OBHf4ssTxkaUMVz18xBQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN6PR10MB7421.namprd10.prod.outlook.com (2603:10b6:208:46e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Thu, 4 Sep
 2025 13:49:28 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 13:49:28 +0000
Message-ID: <30d62858-0ce5-41cc-9599-23d5c38785ae@oracle.com>
Date: Thu, 4 Sep 2025 14:49:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: pm80xx: Avoid -Wflex-array-member-not-at-end
 warning
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <aLiMoNzLs1_bu4eJ@kspp>
 <7b60681e-a964-494a-a6fa-aba00086b7f7@oracle.com>
 <b79c69e27b4ccd9556c89a88bf6c69ed441193ea.camel@HansenPartnership.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b79c69e27b4ccd9556c89a88bf6c69ed441193ea.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN6PR10MB7421:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a604961-a314-483e-e59f-08ddebb9ddcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2M2amhudFhoYXNoY1p5VTlWU2V3WGhBc1ArMis3WHlvaUdKNnNvc21XcW1R?=
 =?utf-8?B?RjZhNm0xMHNrWXk4WnNuV091a2ZoRlBpd3A1bHdKZGxGRjF4TEl2bmlLWGlw?=
 =?utf-8?B?cC80dnI3VjJJQ2FqODRtbHV1UysvdXgrR01vM1ZGNWMzVGxyL1NDSmM0MDNI?=
 =?utf-8?B?M0p4NTRHVjhJaW1VUHM3bGxWanM2ZjFCWjNDRU9ibHBQVVF4RFBPUS9LYWls?=
 =?utf-8?B?Tk1PQlU0OFcwMlBqK1d1eWpNcUVDSzJSRTRtd1cyL1pLdEhxdzhPZnZtbGE1?=
 =?utf-8?B?N2tuZmxXbTdnQkh4OE94OFZZNHJYTjlOenlyMHFCQ2ZydWVmRzhVUTlFem1O?=
 =?utf-8?B?YjdGYTlOenRhNVAxdU9pOFFaVDA3b0xqWWY2VC93TzBockV2RUY2VXZDQWtJ?=
 =?utf-8?B?Y21NNVVjQWlsMXYxdTY3TmNvWlU2RllzWmVKbXBxWUxBV3lER2w4NERmb1Ro?=
 =?utf-8?B?cDVCODB6ZXVKY1lYRy9nbVhNU1ZLWGQxZWN5bU1PdGdrL0tvSFNTUGJvdSti?=
 =?utf-8?B?YlEzT3k2SjZiR0I3dnZiVEZGYkpWSTFYa3dESTQyUFBMMnRPamRzMkRRb1E4?=
 =?utf-8?B?eWt1N3Fsa2M0alFqUmJSNUJ2YXVvQ2JWOFViNEI3UHBpL1JoaE1JYkU1YTdw?=
 =?utf-8?B?eTZKUmJweW1OblVZWWx5K0luWENWVXZxM01Celd6cUNJTXllaERaNnQ4UEV4?=
 =?utf-8?B?dDYzTDhidUFiMC9QdkRkK1MzUU9ydnlnUlp1QURsemZlNm4vZ3dtMzlKY1k0?=
 =?utf-8?B?ZTBrYmtHUGtYV0xuU1dzempIVVE5QnJaWFBzTTJBU2E4M3RjMVg0eE5JNFVa?=
 =?utf-8?B?dkFoM3llOUFHUW1pQ2tQblptd2h0MEhKZUgwU2dBNGptYnh0cVVnTVhIa2Va?=
 =?utf-8?B?bzN0cTEzTzVFb1l3b242dzFJeU5LV1ViWWg1NjU5dFVoQjJSY1R1aXM1RDRh?=
 =?utf-8?B?NEV4S2NCUEJ3MkVqKzdGVVNOUXhHa012NzF6RklkYThISlpVNTlKY3dUUHZI?=
 =?utf-8?B?cGNtSXIrUEg0NEJwOTJOc3BhaVk2cWpGU0p0MDZRQ2Y4Q09VSEViTEV2QXB2?=
 =?utf-8?B?L2kxUk5TKzVuUXVGL2lTWGVDcGxibVJ4ZjhveUxtK1JoQUFtZkpvS2YrdkVX?=
 =?utf-8?B?Y2FnanZmNG5sSHZJWGREZGJqT284VDE5S2plaEdjYjM5c2JtU1VFVzRBand1?=
 =?utf-8?B?aE9XaWZEYUFOZzhqRDVmWEY4SFU5RWo0dCtZQkdMaUhubEhTNzluUXhsMnZH?=
 =?utf-8?B?WUxmVkZqdzcrR2kvS2hiY0lQc05LcDJIRVFOTndKR1FWMUFBTlpVREFqVmgz?=
 =?utf-8?B?M2daaTNCQUsrcXRRYUJmaXdUYTVDM3FKemozVUNQbVRWMlplMlZUT1lkdTJu?=
 =?utf-8?B?ME5mRDQ1M1FMSGV6aHI5bFBuUUk5dWNHei9oS21oZklMd250c29hc3BDU0JL?=
 =?utf-8?B?WU1kbWdnL2VpdEQvSmYvWG9WcmJQUWdGR3lRempsckxKWjh6NzNia1hMbnp3?=
 =?utf-8?B?emgyNklxUDZINEV2S2tlU3luZGV2MXM5R1hkZlpSdnowVlZiaFZWdi9tU0xF?=
 =?utf-8?B?ZkcyZ09GelE2a25nbFdYSnVWVDZMMDNVdGFjbzMwdXg3bS82ZWRTaG1QWUpV?=
 =?utf-8?B?dDhURzRzL2NGajFhM1NVc3dIS3R4Y242c0NpeW5CNGVHYUdOUXFPVWZGZm1I?=
 =?utf-8?B?QVo3bW9yTEdjaWs4TG5RUkZwd1RVMG1PT2RTb2ExV3pVR2xHaTdNRkQ2WHI5?=
 =?utf-8?B?SnJZNjdsb3ZkL2N1dzQyNTRFNWlHZ2JHbERKc3VBN0RaZkR4ME5OZGJ0bEd3?=
 =?utf-8?B?c1lWTFRyb1BhMmp0SjhUeUFhOUIvaENaSkwrdGVqc3A0RTJTNHRNZkNUQ1VN?=
 =?utf-8?B?Qk5zaUxIaEVuY24walVTMDYzU1loa0NlTFRjTHlNVEFZa05vRzJKcWEvNUM3?=
 =?utf-8?Q?gWcgk/jj0iA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXdwK0tqYWhuOWYza1gyZW5FUEVsSFc5YTlYRmY5cmJEY2lvdmdZNkhOMmJw?=
 =?utf-8?B?cUhlclZUUDZ4OVkyYk02c3hlRHpnSld3TGdxODVydW5sUFJJU1ZHZFdZNkZy?=
 =?utf-8?B?OXdSMXNNbFRyU0VkSm5nZTBzeVkyQmxsc2w3b1RiQW00Smp4WURHb2dLNTNu?=
 =?utf-8?B?VUI2RVIzNmpna2txcHdKRmlGZ1RxcjlmYVl2RjlBNGR0YVNuL0t1cVcrTWxD?=
 =?utf-8?B?WGpSRzBNRyttY08raEt4MEZPd0d3YXYrT1krb0I0UmlQc3UwTTNta3hrdVZx?=
 =?utf-8?B?OEswU1c0aytLNURERS9YYzRDZW14Wjg0QjNxbEo1bjlmYWpZVUpQVWpjWHBW?=
 =?utf-8?B?bTRCUW12T2V5Vk9tcFlIWkY3bVhYVUNkdW5lTXBVdEdic1RLSEtNNEFndUJN?=
 =?utf-8?B?aUNCWkEvRUIrbzNvWVYrbUY4dHhyUC9Ib1FacHhUL0EzSVlNUVFjTktkNUF3?=
 =?utf-8?B?OEV4TmQrRzc4Tnlpak9Kd1lGMXNVaVlOYndTOVhOQW1HeWN1ZXBzY3poRVNs?=
 =?utf-8?B?QmZuc3RwUDBrWEpkZGkxZkJkV0VlL0J5eVFWWGM0NTJqTTQ2bGcwQ0tNdTRt?=
 =?utf-8?B?MVJnMS8reXE3R2o0OHE0MEJyaDdWNk9zYzRjb0xleThoTXUwWk5VTHFSTWl2?=
 =?utf-8?B?bngxNHg0Vk1jRFpicElCOTZHUkNXY3hHdEM2OVc5b3RvL2NXZVp6c1Z1TjZm?=
 =?utf-8?B?M2JkVXp4MXVnS3JTZFJxdE1KMUxUNnJOTnpvck9rYmJPTFY5TFVlREZCN2Zt?=
 =?utf-8?B?Q1NBZE4xYUJIaitKM1VHbThrR1ZaMHlPcTlnNnJnWnBpSm9vc0d3Rk00N09s?=
 =?utf-8?B?SFkzL2IrNENPNHJOSmo5UEtZKytwMnFnYXpQYTFlWG1HWVM4aDdMQWJrd3Z4?=
 =?utf-8?B?WTR3WitTWFpJOW92anhsbUpPcXdncnVsTnhkaC9DaUo3WHJuSnNPNEgzMEFs?=
 =?utf-8?B?S0NZbnNmWEYvRUFaWVpieHM4ZGIyc3JDT1QvQUtsS1Vnc0FFWHJ5OTVmUUJM?=
 =?utf-8?B?aWlWNDBySTRsTUk1SmRxZjI5ckVRVnNFVFhRUGxFS0E2cFNGUGtPcFFuUVRl?=
 =?utf-8?B?ZU9XN1hqRHljZjZidVBNMGNRamJhT2ZBb0Z5WWhoampzbkg1bUtsSTlKR1cz?=
 =?utf-8?B?TmIyOFNxckFYdmVwWmNJM09nbWRwU3BYS3RhcDljcno4NjY0c1dVRWxxaTRM?=
 =?utf-8?B?UGlzVVk5b0N2SDdxcmtDT1RyWERPZ2ZUdHQzbUZUSVZqQk5RWnRma29pcjMr?=
 =?utf-8?B?WXNMQnBybU1vU1ZqZnVTdEpzbUhjMEFqeFAzVEw5SlA0ZWJLdWlNU1ZsYWw2?=
 =?utf-8?B?V292bVdrSHYxLzUvSTJVMnJMRkxLRUNxSnhIRW1HUG5TVS8wU0JXelJQcWxI?=
 =?utf-8?B?WGtTQS8wT3JNTnZJajlxbFJ1R05DcU5ock9RTklZcE5tRUJlYTh0OUtHL3hH?=
 =?utf-8?B?V01VQXA2R3FpVlRaYVBZVTQ3aXZUMXNJZC9lN2NiTzBOL29WQ09mK01xTGJw?=
 =?utf-8?B?SkNMazFBNDhIQmZyZWJxSkhnV1MwWjdTM3hTK2JVYThjcStHOHVBT2ZqKzNv?=
 =?utf-8?B?bE9zZzNzMFV2cm0zdGpaSWtHcWJUdUxNZ0duNGVSRlpCSEdEVTA4OXJpMFVh?=
 =?utf-8?B?UDVURldlbXN5VVhoNFdIVHlEYnNtaTdSYlJLUU5ZcHhNUmdrNlYyS2Jmd3VI?=
 =?utf-8?B?Mm0xaUtXQ21sc3JzR3doSnpDVUhsL2NqVVp2QmR2dStHS3llT0hyd1BCVkli?=
 =?utf-8?B?bEpGaTA5R2M1Yzl3UXhjZHRJYjFadk91MlRKZmVIQVllK0RGVnFtUW42bnNB?=
 =?utf-8?B?TU01Ry9CSHVUNTBLTmdoajgrTG9ockIrUnRwdjNpT21QWFBvazZSanV6OEdP?=
 =?utf-8?B?RW9uQnZRMmVGOGdtSU1EZlZtQ281cHhvcjRuTFdmVG11eVFaMlQzQ2ZuT2Jq?=
 =?utf-8?B?Q3NMMGl2SFdlV1k4WVYvd3VUWld3WGlJZGN5RDdVd3VSNkJJUzNBZ2V3M3VH?=
 =?utf-8?B?T2toVnJyVm9LZ2RVeDJyMC9QY2NyYWZxT3RmOW9OWVFwaEpUanNub2YzcFNh?=
 =?utf-8?B?N2VvL1NsTjdzRUtpNnVlcFFuNUhCNFBCT0FmMSt6NzJFTjFZSC9sK3IrczRy?=
 =?utf-8?B?VFMyQXdaeG1nbUl4Zk56Wi8yU1IwVDlONUJyTmpCSDdlakZNOStIbXEyRDdS?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+0308TIZDGQmj0cAPLQ2TjLhesQXyx0AkKM9heVJ/sSyb+0T8GcMYc2kz3tvINsUZIwVdsgsSfkz6HepuXudQMyrE+NijuPkaySyH7rMbuO8/58CHC9aTp4pEf+OnGcEZNXrDizUZeB8rh2YkjxhPu/1iCi0z4311ZTMBdvYsTOiRaZdSkBO1zxfd16FlWtSaG6bOn7UBCH9um+k3GFY9+iCtCpylKSJcnaf10E59Lz18mq5fKvg/Xi4K+GZ97CY+IxcoZueTgrmIqKtJma8Cyv9h8z966lyP7f87jV3A7YvVdgvH1LT4trv/CbmqXPOG7bFd9Nnsw13dI/IcK+joYF16+/jLQosfnYPJcRccBikB4P3DA/ERFC/1642gD60bFlT+hbnLT7KEhBBYoIA6Rg4jYSpVLNlJCZZ2X45WSQC1Usj5PZq80CAxZEl4vyEnBe+8xrMrqw8DJPy65qvqlCWuTtRGoXSOg7zHonL3n2AEKE68tdkHeBw2LzHSO6huUEaaQrnY2UZXU2DQP+C7y0UsmvW1ouvvGlqGmEVyvPCa+yJJYT1Y5iLEVPfmDyMvbsRM95PK9hozENcHdV82L/kuxeND1TdWEKrv1v3GLU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a604961-a314-483e-e59f-08ddebb9ddcd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 13:49:28.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIuRt+YoSfER72ZTPotFaq+RpVJPu64S3sEGDnNlstPy8P8QiEtZj+wn7lmr6Kk9kTZ8TacnC1yvCNuah+I8xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=853 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX+tj0D3x0iDpl
 N22dGYbEFCibiOLU+ta9Ow/+Syn4Hhg4GG1oy54Dh8+vziCI7vFK4bniwavDsmv+KppDxqziGe0
 9MVrexLm9Yd270ZNnGua6R9fLJ/T7ReMkUP9Kw1cO4LunJco1ZIVleTRGwIf9ByYXt1/werOE4z
 zuXybkYE0Ma+qruw0O0d28yXH7hlg1nl03mhQYilWcr3NVruFcGyQ1Qyj6cvCsnW/IJOzd5hBTW
 oP1p6q97oH3s5LUec2x3ItHKT4OdK6nHY/QQSUuk+eCoMfZmHyC9HqJ0GXOvew6dcJMy26qLScK
 CkVONSCDnCvkdI6ekd/OG1V20I9JA0Zd7Wv4BV72m6RiphVX+qA3WpzdV794CsXU52LHffgaPiP
 JH2vkNjx
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b998eb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=XkNx6ZjJ7ft41YPeh60A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: xf6PqqEEhlZ3aY31qxyDIAHJUbeyZheX
X-Proofpoint-ORIG-GUID: xf6PqqEEhlZ3aY31qxyDIAHJUbeyZheX

On 04/09/2025 13:39, James Bottomley wrote:
> On Thu, 2025-09-04 at 07:52 +0100, John Garry wrote:
>> On 03/09/2025 19:44, Gustavo A. R. Silva wrote:
>>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h
>>> b/drivers/scsi/pm8001/pm8001_hwi.h
>>> index fc2127dcb58d..7dc7870a8f86 100644
>>> --- a/drivers/scsi/pm8001/pm8001_hwi.h
>>> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
>>> @@ -339,8 +339,10 @@ struct ssp_completion_resp {
>>>    	__le32	status;
>>>    	__le32	param;
>>>    	__le32	ssptag_rescv_rescpad;
>>> -	struct ssp_response_iu  ssp_resp_iu;
>>>    	__le32	residual_count;
>>> +
>>> +	/* Must be last --ends in a flexible-array member. */
>>> +	struct ssp_response_iu  ssp_resp_iu;
>> this is a HW structure, right? I did not think that it is ok to
>> simply re-order them...
> Agreed, this is a standards defined information unit corresponding to
> an on the wire data structure.  The patch is clearly wrong.
> 
> That being said, the three things the flexible member can contain are
> no data, response data or sense data.  None of them has a residual
> count at the beginning and, indeed, this field is never referred to in
> the driver, so it looks like it can simply be deleted to fix the
> warning.

Seems reasonable. I don't see how the sizeof(struct ssp_completion_resp) 
is relevant, as the size of the memory to hold this structure (and other 
response types) will be defined elsewhere.

> 
> That being said, this pattern of adding fields after flexible members
> to represent data that's common to all content types of the union is
> not unknown in SCSI so if you want to enable this warning, what are we
> supposed to do when we encounter a genuine use case?

Such a problem was solved in commit cd6856d38881, but I can't say that 
it is a good example as we simply dropped the flex array usage.

Thanks,
John
