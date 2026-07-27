Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3D636EAB0;
	Mon, 27 Jul 2026 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166816; cv=fail; b=F6U++Hgovx1lM5h4nnbmZMq4wMyfGKhdpkn1eEuYiGCRSp/ARJYYfjqr7vj+FYO/lcvauDudufvP3FixiOn01PprfFXPdgd8FQ0RUuN/FBSCxde4u/HI6r9F9FKfowWpCJ0fTOa2A05xVd4xGOmf7E5GZuYuBShup+q40g+PK64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166816; c=relaxed/simple;
	bh=hmmlXd4TyP4oHKfWhnqdxSoICh15s5asfPSg2ugGeis=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l672nOK90rZgoSLqj3bCNTeIIn1A1zNAr2uz1dPTTjJSbRVqvPy65SFMLzZVp6jQuIjzMZ+nV9v3QCGhdcmUy7ydM48JhzG9CKAivY9WRGGeanEqfEQcB3pv++uswrCOqRfRuuOBPFFy6czU4/SRV3k2IbhXA0XNpzMrVJmkiFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O+6yWNEc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bQ1LKSc9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O+6yWNEc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bQ1LKSc9"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RFXXpT2420329;
	Mon, 27 Jul 2026 15:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bVIVVRUGSoaMRfpah1V+uAt7S622fBfWvsjI9puAS8U=; b=
	O+6yWNEcS2pefC1tdZQfbnefmfR0K4uSQ5lpdz+U1Rvt3a2Wt48Fb9D9/7fqQ/2M
	K1LFPu66HmeZS4omDEXQM/Av6PhVPW5s1D65gzcvWsIr6is8KGle2eIuNYjcr+OS
	rsouKvN4bYL7OKntM5MGlZipNFuNla8kQdAdgwTMErXIQUdYVbe+wNJDDpCrpg6n
	HA+kBssKjY75ezJ663FflWirn4EWmrpGhvZZFzupylnwBw61nF0j/iIGtM3VMqB/
	1GWN45DvJyBP+kty8Qmx64ho7jfaBG8YN+jAVxfJjtAFXvQltt7LjolUURnwut2K
	1+tNHwkbcp6QNF7xmGYEFA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xt2fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:40:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFe61P027967;
	Mon, 27 Jul 2026 15:40:13 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011051.outbound.protection.outlook.com [40.107.208.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehdgrw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:40:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=si8E9ITPdJvcew/gRxhT+gdolsdLYRIkvrUW3FEYltRMJkOsCUvnVqjXUnLkCzfZur4tzCkfW67Ec24hkCRrYzsvr/Q0EUBGleQ/qFbAgGocIrtQy99Osr1ZhD8tODII9GmtG2s7bQo6WCXlkq888A4LMQJQoDW6Q7pQeD/dGmYsOwe07KzKODnI7cdqeauqMWTnwd3IYH0lX1QbjizgiEEWcrwCL8mN/dc5BC02TdPNSaB6Q1Mrf+WofLTeFTpvgRibBAEw7t1YF9qSHgOvswYVo1JuICcdR4h4xGuR3Eg8KYS2B0CfcWs0jkMJn3PsQpou+zGDVzL1cPsYYEXdaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVIVVRUGSoaMRfpah1V+uAt7S622fBfWvsjI9puAS8U=;
 b=wCWFwNB5ib08UxBC/0vHfO66NY2jVwyW6qrwOvRquhUn6ySU1SQH9rq8dETuQtMYxyaytP2myjOCHPfVt2AmvYjM6Ar/uolQtIKjQ8ILi6VV/hjrkNqdSwYC7VHAA7jl2UTLtVVznEmmFitXh0OmyMf8mNyH1z8ju1fPSDRYt8TVh1CQpKmmterItFdpsgZ5rYGJAGSc8put5aG1liZRplrbQoTjfP//fuNkAxbQNI99qmwnkn2SzDmsJpRfQYdVbMM/o99CfIX1rK7HMLtQ2VMjXxV8oA8OKEtpj9Vxjy+xYP8VaQhL6HTudwGcFnIcn+/QVglMu4CRdwusySH8Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVIVVRUGSoaMRfpah1V+uAt7S622fBfWvsjI9puAS8U=;
 b=bQ1LKSc9n7F+lPQs0ugM6SSUoyGm5RX9vn0c/9drcWVDGJ0IoiVkJt295x+Y+Hpar1vA1TEFfMhZM9K4QLuZyZ8xCjE1dCKMyBkjYdUjwOmR8pB1NVRl7O1++2MWvzBpRUZldHQqrKHIUv1NrCijh1ZA9kteroNw+dV09r1YWzM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA3PR10MB8735.namprd10.prod.outlook.com (2603:10b6:208:576::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 15:39:54 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:39:54 +0000
Message-ID: <a61f907e-1e3b-4a08-b473-29cc70eeeb49@oracle.com>
Date: Mon, 27 Jul 2026 16:39:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/27] scsi-multipath: support iopolicy
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-15-john.g.garry@oracle.com>
 <20260727150621.8457A1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150621.8457A1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA3PR10MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: c92aac14-3652-424c-3b79-08deebf54de1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|6133799003|4143699003|56012099006|10067099003|18002099003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info:
	HzergMdQN/EkLs6D/E/RwXUfKze1Mbp5kgrcRjELqLw9jy3fddf04PjmrZa2YufkQEyQAksSseFfoyL0IV0nK1gCwMzP6VCczU3t/qram1FrGippg54BGrWn8vKvjj/z1rqBxvK/ekevwLGB8jx5H9W/UYfaGfaLjYvZtDkH9krhZ9W805MfkvzmsSqFpbEoGAmt/lR2xaK7oVrEwEh+Xq1KS3jyZRvaQ7RMkY1cNjC2WkMhL80QdbFXsqr0/WU8F3x/cC5xikNGDWLSgpWOJZLl+KWPgl3uHkzODrBgD6Z6uqNWW/FJcfZV0dtzTK6G54GXkSWxqxaxHrFxCMbTs35usM0C8BuREpnxyia0dqN1DoCYm2lqX06OF5Qq6hHaSZKDyXa57fAG7U27/e6lXcm5/9H0v3fvd9jqu7ZTz2Wi4S7fN1obpWBpSYxLlSV0DSdypbKNtmdr2PbZVIEcHVgJ/DfBXw2BooSDw8e/qHRdAQA071L+peIVMAVrH0raXVnqR6Cwx+3gCy8BBJX0ndsQyzNO+ytfIUFqrid9fSEUJ2Q5OUk1zC4E1pCHaMjvjhKH8/uMPNLR7l5iUfVvhZI5Rl9/ed179vSflBij+uDjYcCazrfa4qmFn61A9dCcoZKv1+27mpJH0h9KX7HL/472Ha9shi6G3nI2Uqs+eh0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(6133799003)(4143699003)(56012099006)(10067099003)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmQ3VTduWVA2U091SnNEQUFOUWViWkxFSTFFanVrcDlvd1ZEd29RdHdocjd6?=
 =?utf-8?B?S1V2NkFkbTlabTBUWitOcVJVTXNDbDlVa25Qby9VTmxlUFcyYUh5b25QZml0?=
 =?utf-8?B?K2twa1BXVHRIRzRzQVpDWE1pL2ZRN29WMFNHTVUzY0dEekc0MHFQa3dQQ3h4?=
 =?utf-8?B?aDVCT0J3U0thYXJXdElkRGdJcit4cGIrcU1kWk9DODl4RkNwaXVGT2lRaDZk?=
 =?utf-8?B?WVJzOWYrRFc4V0lnZFluTFBYZG5DcXBoNTI0YUhFTytGOHlCUzl2THpFcDJs?=
 =?utf-8?B?eUhHT2UyVkEwSGNXSkRSRUJwV2JSSmpySFd2cVR2SFJ4ZWRBL0J4aG9xd1Rv?=
 =?utf-8?B?aWlEeVU0OXE5THZXc05jU1Q0Qk50N0hwVWNSWHlUS21EaUxPT2taYlh5MnM1?=
 =?utf-8?B?c0lrTGtxN0VhRy9mU2VLQ242N1pabkVEZkVvN0NkYUlqVzRrbEtGcmpRc1Vh?=
 =?utf-8?B?aTdNVklySUdadS96RHpZYng2blRNQVprd3JYTXRnbDJEdkpGbG1uUVhxYTNH?=
 =?utf-8?B?TTVESFNUQkFWYXhQQi90M01qNFRrd1cxVFE1bUt5aFRpd2tKMFhSSU5iUVhk?=
 =?utf-8?B?Tmk1VXZhWlo1QzZMWkp4V3BORjdYNHkvOVpRU052TllIVGRyWmJ5dzRScU9W?=
 =?utf-8?B?YlRTOSsxNjM0NlQwNlh5dERyaGFoT0tmaEdwdTR6RFV4cVZ2QUd4dVByR21h?=
 =?utf-8?B?MExyUWZwQkorTjJlMWlGcGJCaFJ4bCtjMnRRbWphVGRmczNRK05Dbmp5NzRs?=
 =?utf-8?B?ZnRxakRHc2tBbjJDZkRJUU5mTGszcmhGVmRMdjRDd1dkdXFYdjBNa1Y2Qml4?=
 =?utf-8?B?NVJZU1l3QjVuV0lJL3c2d215VTNtMkRxWmNpcCtHMW1EaUZPVEl0VVJVOTZQ?=
 =?utf-8?B?dWpUSmxtVE5ZLzYrMW42U2ZiTGJ6SUY0ZTVqTXpPS3NicnJFQUZpWWJKdE1K?=
 =?utf-8?B?ZWVRYU55dERxUVRKS0FUQkhuWEJDdVI2SmE5TFU1MEJUKzVOWkR3TlVkQ01P?=
 =?utf-8?B?ejN6Z3VYaUpZbVpWTmk0NFVTSG1WV2cyVCtpMmFQbHZ0TU1nUGJKTkVpVjFB?=
 =?utf-8?B?U3FRb0NHR0lKOVVSaFdZU3dOMk5WMmh1cDNPQ21ldmF3L1lMaUZFZ0t6eHBW?=
 =?utf-8?B?WHBkQytLL3hkTlFnZkJFeUR3cUQvZENlYVBCbjA0bFVXTFluWVlGSjRhQW8y?=
 =?utf-8?B?SXU0UkxtVzY4ZmFnbThHb1pyOFluOHJpdUVUMU1sbkF1VzZUeDNOT3liOTY2?=
 =?utf-8?B?aE9oWUVZODhHa2h5Wkg4eHJBYmh3c1hRNElQOTFzQmFROHRjUVF3R09YaVlu?=
 =?utf-8?B?T2wzZzJSR2plUWF4NjNDMWMzQnhtNUZpeXpkc0VuOXRvN1lhaWlST2FETkFS?=
 =?utf-8?B?M1hSSkNOVnBlQUwxdFpUSzlhV2s1VFJza1RCcEJiNHkzWGJWTlVNMWNjNGs3?=
 =?utf-8?B?WU5xakRRWG9RTzlSd3psSHNRYlFEZ3hIVVBmbE0zMFY5ZkZkSGtYUXJLdVMy?=
 =?utf-8?B?aE55U1c3SGdpYkFmTEZ0Zm1uZVMzSG05Z1JjcUVWak5lTWFlMEoyNmV1b0hT?=
 =?utf-8?B?dFd3ZEo4bXNGR3IzYUJPUjB4RGtrSXlSNzlKeVpCZndkSkt1RklWaWhvZFAr?=
 =?utf-8?B?VXc3a24zU1pUSDhHMWsyUnB1aUdpelBjV3FENU5KSENqMnN2a1NJREdiVTUw?=
 =?utf-8?B?WXE1cHl1MzdqenFQM2FWSVM3UTNUYnMrLzd6bGlzYlpLcFVld2p6YThNUUYz?=
 =?utf-8?B?TFd2dFlTckFvdVhDYVY5dFlWSGRrc1h4YUs4ZVRmYzh4WG11aWNpMmJXR25X?=
 =?utf-8?B?dFUvK2ZUU3VzOEp3aUE5VENvL3Y5ZWhQdW1ueWdzQ29vSjZjOVZBMjZ1cTdP?=
 =?utf-8?B?ckF6bTNHZk1MdW1JQk55VkFYS1dWdExNNUYvWTd2MzlQbEU1UUZPSHFRRVUx?=
 =?utf-8?B?a2FiaE4vYm9SQlVZUGdlN2l6NitXdGtBY2paZlJveGNaaTFKRE5BeDRmck9R?=
 =?utf-8?B?dTRiMVQ4L1ZOaUd2dzZkYW5qSGZpQmYzWlIxRGZ4UlBjQW01SndRdzZ4bkFB?=
 =?utf-8?B?MHRjUTR0MTB6NmxybE1iSURhVHNEZVpRdTJJSUdmVlU0cmNNN1REbEhuR2dK?=
 =?utf-8?B?OXFwSVA4RnBLYjhHYnRma0RjaHJ2UWhzUlE0dUJ1dmg1TjNDWFVQK1NISUdB?=
 =?utf-8?B?RkRaTndiLzBOVWZRN0p0VGNFaVZpVEc4K2gwRkxKR0NZVlJFU2lvcHlnTU4z?=
 =?utf-8?B?cjZ4ZGFqenVTR3VnVFIxbU10bXRKanNBTUhQd3hBWmlqa1BLMEw1c3RQUGI2?=
 =?utf-8?B?VlZleFcvcVFodzFIaXlUOUNjSE1LSFVISWZwZHF6Wmw5N0I0RUp5dFhQVjNw?=
 =?utf-8?Q?gY6MK7b1cnMjuDZM=3D?=
X-Exchange-RoutingPolicyChecked:
	GNO/KPW9kXM0slHdShobIvv+Hkyk+8/SF1Sgn/PRwqB6wjOvEa0YHtOz0t77o6ort38+j7yKeCEihB2k/z2p4tmm3eSaf2qyoOrzxqyqabvfoti95OKgkwrmu9XLDAVZpuBw80h3tfJpsXLXOw5wGGlz4JEo3EFLhQJLyAqAdhQZBvu5GfB0G01folVUnx0fO7XU/T+khUfklacgzE8wajTip/Tr9Gds8G7RvfTjI9QG7RTkYshWsBkcyHEMstdmGDsRIWOGMf6vIuygJg8RkgNraWSS2cGgPxkC0PzQhU+W6LQvFytG0CDPBtj0AHgpJ0Pp55/4p0hWugMVjQ81Vw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tHyvBnoWkcLDLjdeiENqeLHjgZWsSJZYAMZ2w6gQPA2w6YQkaXG/oZ2GHrQlk9sciMKG6jDlrUlfaw0PStJjltxORyqgXupBDdxCTmvph3FoFKXSpk2BOeqyk0lTODAG/uaGdplTAJ1V3BagyTAS6yoKqTLoReCviJlU2BkkHqKyR1mewUcD91ylT9k9+R/PEbE4ClPdLI4rdY5i88wobdhLevRP6/LNmYnw6LS0hFsp9mhqj3hM81IYaRXUo6YWHkk8PE9Zate7sxd7VyPBMH06eeJG1YcMh6htdDG5Nlh2Pnuj8MIBz+rPfr00WFZ1CwY2ZI/rBTrdHRaOS7u2pTL869mB5/U0rdRfgb6nOwQ9A5ppCNvnDJrDkrKABDhPVtaqd1QzxJwyp69fj8ZLQZZcG1EllSihj6kZNAMPPHbQaEDQCWCMcKCKmIkn3/EqljyZVr3lYXlwS53tNAK/G6AFcOrujrB2eki+Obyj6lKRG1aQWfKHrZerkEkVKdRJjKculGtYIFfC0ksS0N1GpvoyKjdFVpvrQhoWNfR0+HpEj5cRMyzcRdoAR7XU/PGoVv3EHyt4MIU83Mdi+6EWb7Ia6G+gWuDHbUxnkByhOmU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c92aac14-3652-424c-3b79-08deebf54de1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:39:54.1828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0RyOldaz4TuFYdFHQi5F72BJ7WRNds7JF+ZvITOSZ0e/OvXgIAWwNCN5eSjG+pZCPX0oBrsu7zgvhPqkixnLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8735
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270147
X-Proofpoint-ORIG-GUID: EuUvZK2s5QMh0Iwyi42DeJUsanu7ytSJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NyBTYWx0ZWRfX46NhePo/D4mN
 zl/RLmG8WgOrwgbw9DAFKm2dwhPfg3D0WmwOfEN7uZc/N8eyrq2N4kHHoro1ZQfEKhPi2TcvzRC
 d+Vi419kG4FQrTv8HHX0pekv52uwcEJ+KZg4ZEm7UpLNUBlty8zQd8S4ZIv7PSx6gRzbAnbbV3n
 A8gREGEUtdACxIneUWHMjIry1yZ5z8fqf4tvP1moFe1PYTYOREL5iZcdotwpRs7JOKIc4/c7FVo
 24NJV7GIQKjI8B204+Z8HdPm+balRjJ7Ki5CDDOOliKvPwA8CE6Cdm7BFXNiWW+yP800EJGX03U
 DAfkvm4CDGqbanGpvCKKRjdiL2LaO1EeBvPiLveksu++XAzLZENNU72sKa7t0SONRZpiOKteltS
 f1B4NvXz9osljbb8XcPH9AMUqGLfFdqszKkLCoWc9oU0VdIeiC1QCF0vg5Y8i373f7OuNOOC3bO
 Ik9HrdNAa5q6SzRMWHw==
X-Proofpoint-GUID: EuUvZK2s5QMh0Iwyi42DeJUsanu7ytSJ
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a677bdd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=HeehHngS5nBXC__x8P8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NyBTYWx0ZWRfX7Rm1UCQ7H1Ji
 hkHUrw2vg+Cm0EzTy4M3VRIU/En6g8nVZYtsGJBkXH9NgNIFAi+1mvJosECkNRrdykdFGylmzqz
 L7zzHiRhn7KTxZnnjSCfOiNJd9W//imQJNGi1S0i84FSB154ebFT

On 27/07/2026 16:06, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Missing `cancel_work_sync()` for `requeue_work` in the device release path leads to a Use-After-Free.
> --
> 
> --- Patch [14]: [PATCH v5 14/27] scsi-multipath: support iopolicy ---
> commit fea581175f41f33e0cbfa8e1c00312d8a25daa1c
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: support iopolicy
>      
> Add support to set the multipath iopolicy. The iopolicy member is per
> scsi_mpath_head structure. A module param is added so that the default
> iopolicy may be set.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 1866f282c15cc..1b955e19a6814 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -97,8 +114,36 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
>>   
>> +static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +		container_of(dev, struct scsi_mpath_head, dev);
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
>> +		return -EINVAL;
>> +
>> +	mpath_clear_paths(mpath_head);
>> +	mpath_schedule_requeue_work(mpath_head);
> 
> [Severity: High]
> Does this code introduce a use-after-free risk during device teardown?
> 
> If a user writes to the iopolicy sysfs attribute here, mpath_schedule_requeue_work()
> is called, which schedules mpath_head->requeue_work asynchronously.
> 
> If the SCSI device is subsequently unbound or removed before this work completes,
> scsi_mpath_head_release() frees the scsi_mpath_head structure. It doesn't appear
> to call cancel_work_sync() to ensure the scheduled work is stopped before freeing.
> 
> When the workqueue eventually executes mpath_requeue_work(), could it dereference
> the freed mpath_head memory when accessing requeue_lock?

I'll check it

> 
> lib/multipath.c:mpath_requeue_work() {
>      ...
>      spin_lock_irq(&mpath_head->requeue_lock);
>      ...
> }
> 
>> +	return count;
>> +}
> 

