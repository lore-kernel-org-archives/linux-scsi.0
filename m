Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51897364934;
	Tue,  2 Jun 2026 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780415869; cv=fail; b=tMg7mtbDltzxOEu2w+zVsNn5uGktXVWFRp91feo/NvfSJmj8Z8CJz5JunLxXfMd/+2qY5fgCkSmBOs/APoIFeL382IXKBEEMzGrw2ktgBRbopxb16qKuSU8UmrSXtT/Z/HVHup4K567JvI7DjUQWxZsiVcp49QBDUszZADMHsX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780415869; c=relaxed/simple;
	bh=0zqEe5QuFYKGZ1mje3gV3lJx3iMV30jlgBKnVe9u8Hs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kT82FhJ3q2KpG+0J96WcdS3CugeOqfor/HVeEzziI91YbRq4cAfaR6E370jUH/Df/oCEQWl8D9VzbmskZuxsGQFBnCtUTo0U3CCFyBhDYbB6hzWKOE/t74kAUlF5oyLzwwrbLW4HAm0xG9CBSfWeIYYHtGJZcxwmh1QxQoYeqxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=exGD/LLC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ePczsQ89; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="exGD/LLC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ePczsQ89"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 652FP0Yq1971003;
	Tue, 2 Jun 2026 15:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IfDGeevQNNkzXNg/KLRAEOibTaLkoSqkJDEA5towf2E=; b=
	exGD/LLCg2MUxcjfb+K0oJp5mMd2C34U0IIMBaHx04fT2whPLXzpMKkGCVcHAl9v
	vjXpqbwFXzu6ARP4rJwdTmsBxS0Scybuj3OHeUEt8lmIE28rOunEn34fDfK1/KMD
	MCBwq4KcJJtN4adAa99LgomVaAsDc6u5F4cFUprlVe6rJX8wQrpEkTUkN3rZG74/
	49PEQtQ/QIEojVWFNoCzE6h2KAF8IuH3Lj/pttxd3Y9jJwX1pUIBcIhNhsBUsMUd
	6dqvH2DhixJZ9TiytVPtalpz8WTw+nMUYAeKS22LVG4WbPWA89x+E/6eivo9+6nv
	JUmn4r2++cr5p5bpQjTUHw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpaavf3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 15:57:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 652Ft50p034248;
	Tue, 2 Jun 2026 15:57:44 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010040.outbound.protection.outlook.com [52.101.46.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbdames-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 15:57:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOpnmuy0lGzIU25CVAfdzHs0/n4X+EiPyXVwXI32rde6+8y84Hdm2mbw2r6ilSgG1OoE/KjG+P3O9S5qQLIGO3JfYHZTnvqUAfLoOW8J0ARA7o3s93RSVFHYtQsq+QxjmNmwprSSNTYGkX0yK71F5USVF9+NB9K1sbeyCcFeliqMQaKQ2Mcri9QjrziLwUfmVtGLi/09+Hmb+boL0iLVcWGXc9C0DJrx7bDO2b1ZEu6U6zLA/kCpLFqGREg2nyFBog1LLqj9BHNqpgitKLPxWfiMF/br9gNogvPexjzyYRvWRUFjvMlWB37A56kMkjo9AFYY+wUZFfC56kRb4h9h8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IfDGeevQNNkzXNg/KLRAEOibTaLkoSqkJDEA5towf2E=;
 b=BrNxzBXNaMYjRRoJiLccVGmyyiJn2QDeXAxLFXO0Ia5zZLViVlfXDAWMMDvzpKOOZM5BTmsqXURPeEysnF0SBjQqkQjIkaZerrfAsyDfjCvWrPXviy2zrkO6PGrszo8h60SBMXtgSo7H79rHsP2wIWM8p0eM0GsCC6R+YYFYB9iF1fOUBN+6H1g7/rYX4LHO2q30JhXitXd6VEs3vsow6ImzsG1JM5JjhdN0dm0qLjx3poAbSRXdo3sZHfDLtUVdUA6Uqo0th7QOuqma/DwumpWUSomwgrSO+9+B4GyqEV9ebHLenR82aDPMnWYkA/+8cTI/zS3IwRi+Remg1cG3rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfDGeevQNNkzXNg/KLRAEOibTaLkoSqkJDEA5towf2E=;
 b=ePczsQ893QoTAt3N/+fnqu6GtybSIbBPmTwljc3IyyEOzW6BmITMAO3PV1XDonHf0xU7fVWjJiEL6V+8CMehUQrsTUhTVJ9vwuZ56J3hTxS7JUhmWROrW8D8+8fRIKCFPhgH8s1ZZZVoRdaokhkJJoUOLp+kyyxkQHh26cDGAQQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CYYPR10MB7608.namprd10.prod.outlook.com
 (2603:10b6:930:bb::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Tue, 2 Jun 2026
 15:57:39 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 15:57:39 +0000
Message-ID: <9a259155-594d-4242-b0c7-655665215cf6@oracle.com>
Date: Tue, 2 Jun 2026 16:57:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: iscsi: validate ECDB AHS length
To: Jeremy Erazo <mendozayt13@gmail.com>, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Mike Christie <michael.christie@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260602031654.3462944-1-mendozayt13@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260602031654.3462944-1-mendozayt13@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0065.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:59::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CYYPR10MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: 61e4bec9-000b-4cc0-21d9-08dec0bfac00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|6133799003|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rnYDvyKA01B4bMZgwExDRemStrCuakcYCaTztfmsb5Ywrbn+I74OmHnJw0pQCRCyc+yIM/C0GI5yUyvR4S9Vr63Gch83pMHxUn2ANTt3EYlENy2ZoxfeK4wFXEi0wo7lf1lclhJGIO/Yf72VdkAbTRhzwtyWgF6wJUDNKcqOhpG1mPYiYgbaNdyN6iZJITj9dl1fVTFN1lOCG85UQiHwb+jKAP8BVsbbl399CRZEBjl8h5YVFwnYY0z53DS3EdEglzhImCCMK0uMMbF7vv9b93m05eiucv0w9NB38dECgQoj++kChBkI1US2POTUNC1jYIDHcvS/l6ztF/n0kVg7eCsUf7omzmYj+1RbCjCwnjxMa1119Wvg5+wbyhPUzSzTsbV4DpOY6OfncTn3F0wwUS5NS3wGgNFUtwZoTKOO7t7OKNz2mD8unmXN4y3p2IYBDjObSmJL4VNDcl5KpB0v2CF7GKsqmKpLRkoHjqyVoyxRv4XJnwf3qvD5X/Z5X2RfkoeBKdkH51CDTUZvoCQzznsP83mTiTm1lSBzyGNznI/1aAH7JVn8lh1yg52qoReqXGLgp/qqcJny6x95s3VGHAY8kwmWw0uy7upGFBPlOkjay5H8/7LYjvPPgMFzD2KsftfcP0d4yRVXiUZrweTzykP55Z0Qn43R9eHLNK5P/bGTTesREtO9+59TacusGqd/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(6133799003)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUZsNjVJYXdsY0hoQjZSSjBTcEppd1haODNXY2xYWHhCSHNoZ2s5SVhjd3p2?=
 =?utf-8?B?eTkxKzJrQXhOQythZUNZVStyWmJVRCtSYWlNNXhEY3VxS1Y0LzljNXZ0Y2xP?=
 =?utf-8?B?dlA2V0hDM2QwNjB0SkVvRE1rWmVhM0hOUXRQQUU5N3pKNHdJOG04Mk9LYkJm?=
 =?utf-8?B?QVhFK3J3QnliaG1sV1VhN1ZadUtzc1lHQllmTHRmUC92bmxtRkFyb0RML0c4?=
 =?utf-8?B?WHRlaWdnemFHYzQ5bUkzdDBlT0Vrb2ZyN3VKNm9ucmE3aUNPUFh1WjhWc05G?=
 =?utf-8?B?ejhDTE9hR3ZKaG4xeUJ2R0NMaFoyemNMa0dadVNPSW5mUnorK2g2UjhBVUhy?=
 =?utf-8?B?dHorY2NQYjNWMThJNjlqVS9yVkZXaE5xUDFpWFl4bXlUUTRRY01GMWZOMm1m?=
 =?utf-8?B?T0pFdnNiNE5FLzZMbEZiNHZyU2tRMDkzbUg3L0lTZnpzWm1RbjRPSVNWM245?=
 =?utf-8?B?Q3dEQkxiN3BiZFUrVjdKQ1lZcU9WSnBJT0xkbjBoOXB5NXZUSGszemtVS2dP?=
 =?utf-8?B?OXdjZXVYZ0ExNHJYaHdmczJ0TjZCc3FkSDlwZGNZT0NCSmdjUm53RWZteU1B?=
 =?utf-8?B?T1dQYUdWaS9adXBSUzlaSlUwcDdGajdRR2swbVBnOTYwVnVkT0dCTHVPR0hM?=
 =?utf-8?B?bk1pc2V1VDh6cFM1T1hsZW81TDhVOU9lSS9vbTJ1RFY3QjdkL05VUVp0ZFFM?=
 =?utf-8?B?NjBsbmFUVVo4cW95aGdQUVRrSm1jeEpjRG1IQ3A1emVLUnVtdnBCSThiSHgx?=
 =?utf-8?B?eE9PS1BBeTVqUWQ4M0VVcFVOU1NiQ1VtbWJJN1pBNjJTc1pVc1J0LzJ1MGkx?=
 =?utf-8?B?ejNGQ29mQVhpTXdzMGJzeWlFdkdmTmZ2dm9sbFdzSXE5Zm9IclY3Rjc2OHFV?=
 =?utf-8?B?OTVVNnR0YXJEa2cxcG0vWmpBeml5UFIxTzVVemdqRkVuV29oVHE2MGY4bmZa?=
 =?utf-8?B?VG4xa0JRSjlWdkhncE91L1NUNXNoWE1nUFZtalRQT1I4OFRMeGt4L1NnNDlZ?=
 =?utf-8?B?alRrUzRkeW4ydE12T3pFbWhaVzVEeTRiTXE1Q0U4blNtQnRnVE5pd2d1MTBl?=
 =?utf-8?B?aTlVaFA3Qk1aYXRqdkNWdngrSEMvb3o2VEFkbjRmT0lBdUROTXc4ZkZ6TDg1?=
 =?utf-8?B?QWRMYXA1QmdlcTM5WUFqRlppNVc5VnIwQlFQcFdscytuSGZPU3duanRLSFFy?=
 =?utf-8?B?KzlsNlpVTUY2c0JQL1hWbUVqK0VVUlhJc1dPNkVuZkdBSWFxSGF1Zm5QSElI?=
 =?utf-8?B?cGxkaEVaVzRjdGMzb2lFa01WWVd3TlJzc2l4MjlxWEdTTStlRGd2aTNUWUFL?=
 =?utf-8?B?UFZacTlTWS9LenZSOC9UcGV6dWhVK2hqcDRNaXpmOHNwMDhhdDByUjQ1UEtN?=
 =?utf-8?B?WXdBUWx5Z2NJMFl5dkJRazhZQTF5Z0tXUzBUcnBRM21lWVlHUkFhdzI1M3l2?=
 =?utf-8?B?bGR5WGpkV3l0RC8zc2tSNnJZN0NEWkUvVDI4TGxjOFZacWJaUHhVTU90UVlo?=
 =?utf-8?B?ZWFNMGg5c3duQW5HelcxaCtjdFh2T0JNd3dEWUJuVUx5NGNRVXhsMGRuVEl1?=
 =?utf-8?B?QVBmRnpPODhDUjJsMGVsdmhuTmZWMW83dGwwWEZlNVBWUFNTSWpMQlVla1RS?=
 =?utf-8?B?YWc4THlMTGUrVHp0NStRZjhlMzRZYXlZcHR3VC9sdFdQMmRoRktXSWVvTTRh?=
 =?utf-8?B?NktndU9LekdhWVF6UHNpMFFNNWZaanpKV3ZKTDk3Q0x1bG5jcVNZYmlkYmNm?=
 =?utf-8?B?eGgzZW1EdDBiTTdJd3Z1WjZicEVRTFlZMmFDT3huWjVpOU5OakhpRzVjVThT?=
 =?utf-8?B?YjZlaWd4WUJsTFNVVm9YMFlnYmlDVUpueW9ubHN5SmNCblkwdFZVRm1PZEZK?=
 =?utf-8?B?Yy9aU3dVQzBOYldrM3BFZDdYV2hsTVhxbEZ2V1ByRXNkekM0OUFXeWZhQTJQ?=
 =?utf-8?B?M00wYlJkOGdKNWhNUm1NV3NUbjNJOVBFWTdXNDV1ME96SS9BZmg1eVRKb0lD?=
 =?utf-8?B?ZHNKdFFNM1Bnc1pEZmw5YUx1NWpqYXZmazJPb2hValljZzZFVU9QV3RPaDBI?=
 =?utf-8?B?b3FLZm5OdFF6MitIam8xQnE0Zkl6Wndnd3hvaHh3c2ViZ1A5bmN3MnJCaStq?=
 =?utf-8?B?MUdSVU55ZDFSNGRjL0xZU1F6enp6dTRSeTFVbFl4Vitod0dtOVhTYUpGaDU5?=
 =?utf-8?B?ZUxZVFhxMkpHYTJwM05xNmRxSzlzbzVpSVpjeS81blp6TitFdUo0YWJTZlZZ?=
 =?utf-8?B?ejZ1ZzFMaFZ4T1RJb2p5OTFVeFV4NVJWSTJNZUNuVXdoUlZHOHhyQlkzdG1J?=
 =?utf-8?B?d2N1dEhTNzB4L2tuUU0ra1A0Y1ZEdXEvUnI4VGhIdTBXYi8vRDZsNVNvUjN2?=
 =?utf-8?Q?qsN3+A5/oImiqDpI=3D?=
X-Exchange-RoutingPolicyChecked:
	MRQkwWNBd1enuj/TT5z6yGE2AU/tEdxicHEzNJRjC5GMZGC3zZ6TAHRdyBi3HRj1Djf/Gzzynk4nH79y7/ZF8Xphu4LSxldhyUptv5pxM1VB+1RGEJ9hy1UiztyNEKXmXjlHk8k3lqR8cazj+JCop6j6+jD8eOhoAm8ARIDdiwUZuFEM+PxKpJoIVNfu++A0i9K521v6fk7oQKS6gVeOPCh3kgx1+WGGr197IyvdKBsFXDMsCrZ+QGDXP4UyMLpCUMLeXZu9UxEqgqRqU+RURozufL592+GtHCfR4yPQHrHqAZSYTA9dbPdOrEKPTg8SkyxpsEHHC+BuAbEYoQS3pQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PX/JmiLEICAI/IZIWJaM4zBXnIuTG/YD/qcIAh1EMbXZCS7VpO6+SoO1wfhLCMxvtMmBJ0hkrsWHktNWuYhzlJjntsGyyKmxSa/5skj03/ZX7zXCV3bhr1ekQFgeMH1Q2ZDKpaSFKro3hzYA7rQS2l0V6U3QEYx6CPc8xphE2xzk+c/uxp84BnfHupKoC1heWHnJ+ZJd1yz02ayqM2meANt7BxusfRZJIAXesd/PfP0mE9oVMWu5cDCQF8qr0FGF6WKsXoDxVPVGfck1TB5YssR0COb/ci+SgRME8G0kxQor2qdfGoXGRPv8wcjdF7hBOhQpwOqCBhTf95LkDq8XPcZ23NiSDbhDsfxXzFda9na40fnF3A+Jqx40AAftYbQUygh1eaRFlDij0owIvpdGrWYe1eqzdjNYIwL72h9n18rXA5QbroPXluAJO4kFm5OLX1hYiI1O8R5Dtu6S3xIzrZ0RKQA9QxAmDRzpfAyKWltVYBPTR8miUgetN5oJrzl9UMgHus2LSXJSSahTuA8ji+Ixn64cDdE3ZLkrzAicN1ojbwkMH4z8eXlagcum5iTCxSMoktcfpKlLE76Wbr5TF3eJgw2UxZSHZ0ux+KYCmzU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e4bec9-000b-4cc0-21d9-08dec0bfac00
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 15:57:39.4592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: viEssMTsfsDVVdG/2nxxDDw/M1N48wqZ49dtevlfOo20Sq8n7ESBeUFQ5wDJId58JC6vieAaNNWaAYa8kuh0iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7608
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020154
X-Authority-Analysis: v=2.4 cv=T/S8ifKQ c=1 sm=1 tr=0 ts=6a1efd79 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=8SSkkMLj37D-hKsiMrEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MOYnqAwuaecFRr-PKJa-r0YuLtlVpQU-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDE1MyBTYWx0ZWRfX2f39vqxqq7a+
 vDbqV7toFV+IXpSAhs5E75NhUc+pKYL5WlS2K5TE6z0Fft++1Vd1CnMmrFi+ARNJJx3TvLTdXIt
 oyXGWltwc0G9VMOBrg0bl1ZeA93yTR2p4CrkCUNd9cBUHs20U19YQcMfYpFlll62kWzxbGg1DEz
 UzdVlvdu5PcmDft6K6XOKNj31sINwFVrNQ3Xz3LSOot2sRZRRfkyN4wC1kbOmhpbdeVd7bflngK
 6msDooTtfTBh/Q2SivjDrgNZiPYdKB0lKvJ1KinTB7Ct5nGiwHLq2e9WZvxufGe/LzPFGgc24lS
 BzSbcwwJLKsCOujf1L1S6UXpt0BoF5c0v2tkoNrsjIII84ksHTsmyEQGoYa9PGPsDg2bq7bm6NB
 /oXeyW+EXmnMT0nb/K33GlDZpSz2cbdhBYkqI/uIFL/hwx9iVGp5WhQLUqTCzFuNMhbScBzMmzO
 tckqYwqhfPGJdszRR/w==
X-Proofpoint-GUID: MOYnqAwuaecFRr-PKJa-r0YuLtlVpQU-

On 02/06/2026 04:16, Jeremy Erazo wrote:
> iscsit_setup_scsi_cmd() processes the Extended-CDB Additional Header
> Segment (AHS) of a SCSI Command PDU without bounding AHSLength,
> despite the long-standing "FIXME; Add checks for AdditionalHeaderSegment"

if this is being fixed, then why not remove the comment?

> comment a few lines above in the same function.
> 
> A SCSI Command PDU sent after iSCSI Login with hlength=1,
> ahstype=ISCSI_AHSTYPE_CDB and ahslength=0 reaches:
> 
>      cdb = kmalloc(0 + 15, GFP_KERNEL);             /* 15-byte alloc  */
>      memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);         /* 16 -> 15       */
>      memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
>             be16_to_cpu(ecdb_ahdr->ahslength) - 1); /* (size_t)-1     */
> 
> On CONFIG_FORTIFY_SOURCE=y kernels the first memcpy is rejected by
> __fortify_panic() because the declared destination size is 15:
> 
>      memcpy: detected buffer overflow: 16 byte write of buffer size 15
>      kernel BUG at lib/string_helpers.c:1044!
>      Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>      RIP: 0010:__fortify_panic+0xd/0xf
>      Call Trace:
>       iscsit_setup_scsi_cmd.cold+0x8c/0x224
>       iscsit_get_rx_pdu+0x9ec/0x1740
>       iscsi_target_rx_thread+0xf7/0x1f0
>       kthread+0x1b4/0x200
>      Kernel panic - not syncing: Fatal exception
> 
> On kernels without CONFIG_FORTIFY_SOURCE the first memcpy fits in the
> kmalloc-16 slab object and execution reaches the second memcpy whose
> size argument has wrapped to (size_t)-1.
> 
> Reproduced on Linux 7.0

Please post against latest mainline kernel / maintainer tree

> with a malformed Command PDU sent after a
> completed iSCSI Login.  The trigger is reachable post-Login by any
> initiator that successfully logged in (anonymous on demo-mode targets,
> authenticated on CHAP-protected targets).  No claim of RCE, LPE or
> controlled write is made.
> 
> Validate, before any dereference and any allocation:
> 
>    - the AHS area received from the socket holds at least the 4-byte
>      iscsi_ecdb_ahdr header,
>    - AHSLength is at least 1 (RFC 7143 §10.2.2.3 minimum for the ECDB
>      AHS, which carries one reserved byte),
>    - the declared AHSLength does not exceed the AHS bytes that were
>      actually received.
> 
> Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
> Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/target/iscsi/iscsi_target.c | 33 +++++++++++++++++++++++++----
>   1 file changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index e80449f6c..de291eb6f 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1100,6 +1100,16 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>   	cdb = hdr->cdb;
>   
>   	if (hdr->hlength) {
> +		u16 ahslen;
> +		unsigned int ahs_area_bytes = hdr->hlength * 4;
> +
> +		/* The AHS area must hold at least the iscsi_ecdb_ahdr

please use standard kernel coding style for comments

> +		 * header before any of its fields may be dereferenced.
> +		 */
> +		if (ahs_area_bytes < sizeof(struct iscsi_ecdb_ahdr))
> +			return iscsit_add_reject_cmd(cmd,
> +				ISCSI_REASON_PROTOCOL_ERROR, buf);

ISCSI_AHSTYPE_RLENGTH means a smaller structure (than ecdb_ahdr), right?

If so, for ISCSI_AHSTYPE_RLENGTH type handling, the return code would be 
ISCSI_REASON_PROTOCOL_ERROR and not ISCSI_REASON_CMD_NOT_SUPPORTED, 
which does not seem proper.

 > +>   		ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
>   		if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
>   			pr_err("Additional Header Segment type %d not supported!\n",
> @@ -1108,14 +1118,29 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>   				ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
>   		}
>   
> -		cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
> -			      GFP_KERNEL);
> +		/* Per RFC 7143 §10.2.2.3 AHSLength counts the bytes of
> +		 * the AHS that follow the AHSType/AHSLength fields; for
> +		 * the ECDB AHS it includes one reserved byte, so the
> +		 * smallest legal value is 1.  Rejecting 0 prevents the
> +		 * "ahslen - 1" memcpy size below from underflowing to
> +		 * (size_t)-1, and ensures the kmalloc(ahslen + 15) below
> +		 * is at least ISCSI_CDB_SIZE (16) so the first memcpy
> +		 * does not overflow.  Also reject any AHSLength larger
> +		 * than the AHS bytes that actually reached us.
> +		 */
> +		ahslen = be16_to_cpu(ecdb_ahdr->ahslength);
> +		if (ahslen < 1 ||
> +		    ahslen - 1 > ahs_area_bytes -
> +				 offsetof(struct iscsi_ecdb_ahdr, ecdb))

please use {}

> +			return iscsit_add_reject_cmd(cmd,
> +				ISCSI_REASON_PROTOCOL_ERROR, buf);
> +
> +		cdb = kmalloc(ahslen + 15, GFP_KERNEL);
>   		if (cdb == NULL)
>   			return iscsit_add_reject_cmd(cmd,
>   				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
>   		memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
> -		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
> -		       be16_to_cpu(ecdb_ahdr->ahslength) - 1);
> +		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, ahslen - 1);
>   	}
>   
>   	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
> 
> base-commit: a293ec25d59dd96309058c70df5a4dd0f889a1e4

