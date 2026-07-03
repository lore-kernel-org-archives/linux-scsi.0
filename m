Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D8B3ED3AA;
	Fri,  3 Jul 2026 14:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783089460; cv=fail; b=bVQ5llLM51sMXEjXvojCYd2Qo/+CZRVJbh0JKHE7rJUToceXDbS7t4rNfU9BlE/BOwofLD92mVOZz9VpLSyb5Esl0Yoakmz3m9djc2cj9t5rOye2Gi2UZ7sLipXX4hjY6BkQVg/WAdp7U5g+Fs7QSz8Go8Ao9VQHcocwZ1aDGNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783089460; c=relaxed/simple;
	bh=XqKKfmpWDfHK7NQ1fzyfijPUS6+/niD5eTSeOkr2mpA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hJI+xmPlGHNXW7C7RCBgflENqIWHIkDDu5z1MMX2D8b8rvUyFZqyeN7IboV/HRvsnCptebZDSI2VLSIknIuoU6tl28YeYwJAsJTrMQjOtiK2KUmetLI7ZgYF8ZUc8PErBByTPJU44wyf544fg5FwffHhCXZj3w+iVsO65QiTpKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ei+Iw6d9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RqGyLgAH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ei+Iw6d9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RqGyLgAH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 663EaANE3696571;
	Fri, 3 Jul 2026 14:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C9xD+KT1NP6fJpuiDZp0yQYSrmVu+cGSlkSmYEYy4v4=; b=
	Ei+Iw6d92xi27mXZ5E42+ZIU6N35bbF4ZtDnIc42nNBxDycr3bDIffPW5gRoyrAS
	/b5Js/mrrKKaDJ5Q/txEbzF1CRrGcbhXVESBOZiMJJPtpDB5VEbNnYGMNj8w8sB1
	8rIbt7shWHyHrOGEMu/rEbtZkypBh8IBiU1dn5CPfDHK+uObrooQE3zMJ8H7g3X7
	mbULLEo8SRiTGvFpUeJlzNSh9WzujiFMpZEbbLZpGfvLi7SpVCbxpyJUo5fWi23O
	KP+3/4IZQhQPQBoQHQVvzgUIF/FB3rijD2HnNp6v9+fuWmk/iDq1Pr4l2L1KM4iU
	lu+NrenM48nmAEEXWZKXNA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p4b0c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:37:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663EXC4K040022;
	Fri, 3 Jul 2026 14:37:33 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yv54hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:37:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sbgrb9wlRew63S58fcitsCUH3alPMNoDWjNUzm7fo3niEXbAFTUgNggyyzW+QWuNTwfHIpgAr12GFD9CPKtZAWyeDB7oo+LrrXpgujYA4RqcNQWd8RoasarvamSN4USwoMEJDbY+UT9la1rOV/Ej1I/+BX3B+rBMbw9WhoTb+qeFGoFYyno/GG1AfrEZGlcubHvxjt5+ZNLCneqMI28K0TaKYD0Tpvfufff77EZTBO8LLf2xy1CrzsUz+bVm4/cvvi6LDyU2J3LKfrDxx4KD7DyZJ+D5vaYxLrrBuhzdOpBn71xANUDp94CuMKqqYVsjHr8vKu8WagdJhtsfk7zQ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9xD+KT1NP6fJpuiDZp0yQYSrmVu+cGSlkSmYEYy4v4=;
 b=aZgU/WQhlk7XTUnTN2IK8UDug8h7UXV4TxM/Z5q8g4+Ma9WbN6MEAAgT3/as4+MukpWHe9ARfdg4zDZ4qKqvYY/75Wlp/4ZsdkUFYVuYT/4E9yt8y9RPgh09g/Y7t4wL8JF5MNlAI+Jc6AQnGKCs+vcOkpMrubbG3W3Ef6vlipCuZb09Hc5twY+1/HE1nfbdjN/QVEG3M2aDRwQcbBnNKFwKES6hPlXyjqWzhcOAQCF47nPWvAVR3jkD0606Fw3rJ+0KuqVVbMInwaSVUjbWp7PQYKApJ3PfvVVDonB6HhkfqHWU+7I1L0bby5VytVohGqa9uggeB5lDL7Gpha7s6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9xD+KT1NP6fJpuiDZp0yQYSrmVu+cGSlkSmYEYy4v4=;
 b=RqGyLgAHDMZOoWCbzleYYEZJZHwDsF9koWjH9eAeRZf9etMBHcCkhKEqpXWl6W5Sia9/7wBLbLJoBdF1G5BX0HXqMgaI0lKNzoaqjeQo4ba3SFJqZSawqOGqjKSuMvKZ8uaNvtCpHq5RCgfqDM+felrBeMgXKkFVoA7NCc8mUsw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA1PR10MB8212.namprd10.prod.outlook.com (2603:10b6:208:463::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 14:37:29 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 14:37:29 +0000
Message-ID: <352c76e1-7fde-4c5d-9c5a-e6d6654e3499@oracle.com>
Date: Fri, 3 Jul 2026 15:37:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/13] libmultipath: Add path selection support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-4-john.g.garry@oracle.com>
 <20260703104556.AC6B71F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703104556.AC6B71F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0122.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA1PR10MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: 33fa4772-cc4d-4ec7-c417-08ded9109bfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|4143699003|18002099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ZfUo75Ue+RebZgkqXZXLSV0urJw2x8NDj4dCBQG27lgzBqbArUYCbhqUuWIM+LOc9HY7CKvPjqXDe/GHnwRh2ZiuSjTBBxTkqXJDSVZ4RdctPqlnMrVeVurGvLeRxj+iIpq7sJyiGTFfWt2oDEWeTjRGvHMhJKRpWrnpqIqOcsujfzsNcAhejpLM3RsLX3yHXg1PCSaK7qjRdgFFr09xMu3XWwKFQSquBP7v9bRp3K0Vb+eI7SnPPEIxB0VfOw2ehkMzTArn6VUf6DjtEOkoUWLLgaccq+5hnTBDddjDH5phPYmgb0b+dwezWWNijF+sWvvwv+6TqT9Mn6LJXIIKhYMCv0HGDLP9eSM41O2bWwtYJj8sCaHS6/Fx3wiBhtsa8psXUrEDeZ1RbsXFKfGON8+gH3ujOnexH4z3fh4GSc9qJAjLXt5Q5t9Qj/iA25vKbW6DFRaLtAFKALcaH1ZAXM7y58qZSwCaONFxfG7V1WF+e+mJ+zkELzTQXMwq/ABPlFfrivHWG81p1RgJGnH7w9JZls+C0+S4JN8PQ58SA+zqRHG14xGspOtoB06rtkyz1Pb90Chfq/4AHPGJMDOp1M09kRmRmCrcrqyXGSviaVQlv8JksvXnbNh1plzJ6Q+RtVV5yrcG5K5YTsNLrJx+Dy4Kqhg11bsDKKMKhjEfQLc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(4143699003)(18002099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWhmeFNCT29sQXRLNEpVYm5ncXFFV2lZRnhkaUFnU1p1dDkzdGZQMFNzc21N?=
 =?utf-8?B?d1hSUTN2Rk95M01TandvQW5IdHpXbTJjdlpDT0tzRG5mWVF2L3UyazR5a253?=
 =?utf-8?B?VnhRN3lCdVlUVWdlR2d2UzRjVzNFZS9vTk4yd01zR2d2Q1A5cjVPemRnWU9L?=
 =?utf-8?B?S0ltdndJV2lJTmdFVzh0TnRXdFo1QTN4Qzh0ZUU1MVd1SHhCajc0b0kxVWQ0?=
 =?utf-8?B?QW9KOTAxemRPRENsN1MwWEVFa2NiVFRIYVdIV25rbjVPcE5YOGkwYlY5WUlY?=
 =?utf-8?B?bVRPWnpiL2pKdXZxMXBjWlJPRFFtQjcxNWZXektCa0twanNLenpIUFhPNjg5?=
 =?utf-8?B?WllGeGU0MWRqQ2RYUGgyK0c1dG9XaXA0QVc0eEhMWWkrWk5DZGJZb0FnQ0s1?=
 =?utf-8?B?aU1JVjBleXhiaFhaU0JJYjlrVjhpdGxUb3RiaGp1ZGZhQmRpNm9LMGJaUGZR?=
 =?utf-8?B?czRRTTM2ZC9yaDNwZXovUFRDRlYrbkRqNTJhVTFyT3B3R01Xb29ieGlXS1Ft?=
 =?utf-8?B?VllVbXFiMVM2Ukh5SnlEUllod3lOOUVUTEM0QXZwV3BrZElCelJmRlNEeUd0?=
 =?utf-8?B?MDNGN0Q1R0x4WE9VbFBKb1lwS2VrVFdadEtaTUMwTFE1c1NzMGF1L1plOEho?=
 =?utf-8?B?VTRvQk5MMmRpM1ZSMHBHb0lIQ2sxWEt0S2RiMzBaU3R5Q1BNTWlVdW1UeFNV?=
 =?utf-8?B?ZWQ4WTVFMUF5N2xTaGI3L1BreVlpczFkb0dnR0JRVDZqc25oTzFRVjl6V2la?=
 =?utf-8?B?RFpmREd6SkE4QVYrc2xka1ZGYUZqSTBwQlRIaUYyc1I1NmlZaE5Tc3BxdnFL?=
 =?utf-8?B?c2lIQnV3WjJkRkVXZ3UrTlpsazF1aUpWb29zaitxLzZqenJzRlpiOTN3S1NH?=
 =?utf-8?B?UHZHNFR4K2lVUzlGdU5qY3dHQTFlZ2FzMDRhVGtuaTZUeU9Nc3lwSXV6ZkpJ?=
 =?utf-8?B?dXhDeDJDZFd3Q24xb1VmZUdlS3k0VDhKV2RLQXlYemh5RU9xTzFKUUFaRHpm?=
 =?utf-8?B?aVhONmJCTmowT2Vycjh6TE1FWTFQS1RycExKSTRXeVJqK0xMMjlVeGRveUtr?=
 =?utf-8?B?TTkwN1hlbkZuTWlTaWVuQVlGc2RpODZ1MGZ3SCtkdS9rRU42QTVxQ1BKTUdC?=
 =?utf-8?B?dTNMaFI2UGpNVHlXSWdLSXBXcExKVFdUZG42OCtteXY1QWZUQjE1TU9Hckoy?=
 =?utf-8?B?NW9FK2xWUktSekNpSExGdCt0Ry9VM3pRRE9XMWFjSWlhVlNFeVpJQkNsdmxG?=
 =?utf-8?B?VCtQMTdFTEtWR1poQThCTno5bDJrTmMyMzhsRTU4TVlIUmFJaWp1ZnJGYmhm?=
 =?utf-8?B?dU1VY2h1TkdaYnJCTWpoZDI4eC83alBSYzlhT3BVa1F3QmhCVGk0MllMOFhY?=
 =?utf-8?B?RHQ2T1ZVTEoyejZNNmlZQWtIZm5PV25tOUpUM0VmalV4OUkvL0YxUjJkTlc5?=
 =?utf-8?B?clBNZXd4bkNVQWV3aXh3M25KckdxMk5tUXJ3M1ZZWjZaVGRFZG1IWDFXVkJE?=
 =?utf-8?B?RWV5MHBLS2ZkUTB0QmpzZ05iMEhqOHFwUmlWNk8rUklLZ2MyUm1QVDBudGJH?=
 =?utf-8?B?R01qVkJWUU1MSlFHMU9TN1ZJYXc4YlRQdi9kY0VNbjJSQktoUHNhOERTanor?=
 =?utf-8?B?bm5zVWNXSVcyUTFvelBpQlVGb1p6MUhFcUt2bzRaWDJENlFFQkdIWWE1TXp2?=
 =?utf-8?B?OUVGTk52WDRWUEFwSjM4L0tNNll2dGYxblNFb3JUL2ZCU3BYZ04zUHdTZTc3?=
 =?utf-8?B?UzQ2L2xtWlkzdjk0SnBONFN6UGN0Y2NzK29Oa1BHclZCQStxVCtIWHo0Y2pa?=
 =?utf-8?B?NHAxejBVd1k1NEJaMnlqZ3Z0SCtJVXZaUnZQQXBrRGZFa1dEczFscXRSY1g1?=
 =?utf-8?B?MmZRYVJsTW1DbDFhSytHbTU0Zm03bkc4WXRGSU5uM2pUZjcvTmQ1WWZwT2ZL?=
 =?utf-8?B?L2NlRnhaT3RQY2xDZVljOXdpaVdRa0FwZFJKbkdiNUVNR0NkNDZmRjgzWUJT?=
 =?utf-8?B?YzI3eC9mZTJRTWt1R245ZUlnNk9iVW1YNHdpeVNma1RnRkNwREMvOHFOa28x?=
 =?utf-8?B?Zm12cytQK1h6SjN4elFRT3E1U21BNjdBTWt3Y0ZpRjVaeXp3STJ5RnZFTENM?=
 =?utf-8?B?L3d4SGNjYnFYd29wOW5tSnIrSXU2RDI4M1pGRjZWQ09DcEQ2VkI1SjArNEZs?=
 =?utf-8?B?SFltTytyc3g5ZjRtYXN2UnpTWDVUT0dWejVaUGZORjJhUDVmL3RMd1pBZDQv?=
 =?utf-8?B?c0FudWZETlVDSVRvOURQWHdpTmZwMml5bEwzbE5SK3pHZzhub24rcnBCU2Mw?=
 =?utf-8?B?cU5qSm9oRkRac2Vta2NOQUM4eHBTV2YrU3Q1anRraXVlbldyYy82SVRXWGw4?=
 =?utf-8?Q?Limdw89BIjAEHO14=3D?=
X-Exchange-RoutingPolicyChecked:
	L192VzDQjhMXrcMWbioxZhqjhr6Rdb/QM6AwyQ5IHVHR+z4RCPTWdM47rAKbSfwAMvGHVrrcpm2KxZF92cYL4Ol8qQ+M9TkOOyd/KoLzfbYnMDgrnxyhY73PEJVccYOzdi66x0+KH2KlPbsKuiii2rtknfn5ckf65X4uE899V6mNwxaUZPS45Da+Ygr2OEBEghXdfTTrtOfbmvBHj0y1F0mN5zNitEfOPEP7pgnRkf1TEkTDwZ2tTh5/88O4TzviT/iMPtvKEiusx0SQrHlC9iTcF2TfyhXLubU54ie2QX6MilKvwiLoYciukp6ncBa6B5XimdUBZF0SHHA/NyqVXQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DXwA8vU2rS1my3owGWEBnBNTBCDIyRmfbgZ4hTpRI6ujj3X0a28uYqZJufqDFvT2S5RmmY24BnkRypXzlTenjvjHTeb0DjMQt5/xQLnwRfqIRGxDxtL16w/fXTy/3vFA0LXjERZYTAdal7doFoA8Hl0lrLYjIn3doltyWZGzBzOzVnWzJoolvtBdSeBdC5lRzkfVsx4X2wnAFPlG22LmtQZJnJJaEXKmtuDCKQv0a9YcUoxYxNzksg/qgrII4jLrNR6p0PILSIl9oBFyX78Ekav9cSZ/gtSV6TixGJsaNThm/bBU6vLN9IJd5MRocEaV/hLor0ukYrWqPtb6AWdnQaiO15M1tSC/2hfjuOPS+bmJpR3HABY+bME1Pj02dtAGT2gvYnGLXjcks519MBfUQ9CKgQ7dAkZ9jIfJMZrEQWCG9cnC0qT53Vl/cZdhX2MTxjePL8NRjBuCGSDWi6qkZBwCeugm/zZGNT4f6yDGLGOeoZ2MHyoaLJfWw7lCoaoGBhOqRR9dGGLPpIXTM7bGTaCPB+rXqAQsvlTsnqSAPtTMq8v7ZRaG/eSDdVT196mNQGi2g/ymAZhqoj8dlnYXAwPijrftfHRGbcVKfD99SXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fa4772-cc4d-4ec7-c417-08ded9109bfd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:37:29.4794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twyd0rJeX24186vxis52uBxlcC1kYf+LPOi/IOj14sDbRkpnsD7ZnQ8Jp3M2AWbcGQHXvoI0O9hcP6KdYio+rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB8212
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030144
X-Proofpoint-ORIG-GUID: 3z357COzYO0qUYcZJB9D8CA6v143h9Cv
X-Proofpoint-GUID: 3z357COzYO0qUYcZJB9D8CA6v143h9Cv
X-Authority-Analysis: v=2.4 cv=DK6/JSNb c=1 sm=1 tr=0 ts=6a47c92e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=mz7TPIHIDE_pfzkqdqIA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDE0NCBTYWx0ZWRfX+T+Eua1Zo1Og
 hWAsKhkTdWo4IWtilzuPkBlNe217am1xsXaninpAPyvHB26/pK3jMlLEz1RwIlpa859CQp54NTo
 MUi7zJkkAy07iAqa71DRaI9caarGyA02Dr3FsckPRu4dvLd+k34YKhpzIaz0YXgs7yZ8YGko/2a
 dQqjWwyl5e21/iazH0k6ZbLWPB5rugUUcWN1lTp1e1HxSwZC6lZVv5IrPDSlDkyNiuSv2uuyc79
 It7BTTuWEn3Rz/oyq2+18CeN32F6+EvOOd9HpXevTCVS9I2tjNjpLOpJWQ6eWXkzsP2LCnL6ign
 UDe5kAB5REcH2Y+MODU1J8/lLMQrzn9hcg2LBA4CcmRu0K0A5kFtF06sNGVRjUJVcDfQeZIE3Tm
 hJRtlfuG3WLB/66iN7+dbEPXv51Y5YFr1RexvOsrRuJsiz4nv0PNiYCUIs3K73U6xmQNecXqRfG
 c/joY3Btu7tgyjuqE6w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDE0NCBTYWx0ZWRfX67vCwicJVF7b
 TlElzzNVXV/8wXPfQqeJM2r9zX2aUPLPS7PLvAiiC5P5jXRH/sVfM55MZ5qRfboinoFQFBgwfYy
 y5alCITM17KZxeb1H044m3UpFXYiXdzqKu5gpa91dyiGo0GhrEQR

On 03/07/2026 11:45, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [High] `mpath_round_robin_path` enters an infinite loop if the current cached path (`old`) is concurrently removed.
> - [High] Unsafe usage of `list_is_singular()` on an RCU list leads to data races and routes I/O to a removed path.
> - [High] `mpath_numa_path` fails to verify if the cached path is disabled before returning it, potentially routing I/O to a disabled path.
> - [High] `mpath_alloc_head_disk` leaves an ERR_PTR in `mpath_head->disk` on failure, causing cleanup paths to crash.
> - [Medium] NULL pointer dereference in `mpath_queue_depth_path` if a device does not provide `nr_active`.
> - [Medium] The `.get_access_state` callback is missing from `struct mpath_head_template`, violating the documented API intent.
> --
> 
> commit e941f797884516dd9568e0b668984eb3c895248a
> Author: John Garry <john.g.garry@oracle.com>
> 
>      libmultipath: Add path selection support
>      
>      Add code for path selection.
> 
>>      NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
>>      so that SCSI ALUA can be used. Callbacks .is_disabled, .is_optimized,
>>      .get_access_state are added to get the path access state.
> 
> [Severity: Medium]
> The commit message mentions adding a .get_access_state callback, but it appears
> to be missing from struct mpath_head_template. Is this intentional, or should
> it be included in the struct definition to avoid requiring drivers to directly
> modify the access_state field?

I will fix this. This text was not updated from an earlier series.

> 
> [ ... ]
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 79be84d3d4f75..21f7ffdb22d60 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> [ ... ]
>> +static struct mpath_device *mpath_round_robin_path(
>> +				struct mpath_head *mpath_head)
>> +{
>> +	struct mpath_device *mpath_device, *found = NULL;
>> +	int node = numa_node_id();
>> +	enum mpath_access_state access_state_old;
>> +	struct mpath_device *old =
>> +			srcu_dereference(mpath_head->current_path[node],
>> +				&mpath_head->srcu);
>> +
>> +	if (unlikely(!old))
>> +		return __mpath_find_path(mpath_head, node);
>> +
>> +	if (list_is_singular(&mpath_head->dev_list)) {
>> +		if (mpath_path_is_disabled(mpath_head, old))
>> +			return NULL;
>> +		return old;
>> +	}
> 
> [Severity: High]
> Could using list_is_singular() here lead to data races? Since this list is
> managed with RCU, and list_is_singular() evaluates head->next == head->prev,
> it might read inconsistent prev pointers during concurrent updates. Also, if old
> was concurrently removed and only one valid path remains, would this return
> the removed old path instead of the new remaining path?

uh, since we hold the RCU read lock for traversal, this should not 
happen. Having said that, since in this patch there are no users of 
mpath_find_path() and the user does the RCU read lock.

So maybe I can merge this patch with another. Or the context analysis 
annotations could help.

> 
>> +
>> +	for (mpath_device = mpath_next_dev(mpath_head, old);
>> +	    mpath_device && mpath_device != old;
>> +	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
> 
> [Severity: High]
> Does this loop terminate safely if old has been concurrently removed from the list?
> If old is unlinked via list_del_rcu(), mpath_device != old will always be true.
> Could this result in an infinite loop wrapping around the active elements
> indefinitely, leading to a lockup if no path is MPATH_STATE_OPTIMIZED?

As above

> 
>> +
>> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
>> +			continue;
> [ ... ]
>> +static struct mpath_device *mpath_queue_depth_path(
>> +				struct mpath_head *mpath_head)
>> +{
>> +	struct mpath_device *best_opt = NULL, *mpath_device;
>> +	struct mpath_device *best_nonopt = NULL;
>> +	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
>> +	unsigned int depth;
>> +
>> +	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
>> +				 srcu_read_lock_held(&mpath_head->srcu)) {
>> +
>> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
>> +			continue;
>> +
>> +		depth = atomic_read(mpath_device->nr_active);
> 
> [Severity: Medium]
> Could this dereference a NULL pointer if a device was added without providing
> an nr_active atomic counter during mpath_add_device()? If userspace sets the
> I/O policy to 'queue-depth' via sysfs, would it crash here?

Well the driver needs to ensure that it is valid. However I can add code 
to test this.

> 
>> +
>> +		switch (mpath_device->access_state) {
> [ ... ]
>> +static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
>> +{
>> +	int node = numa_node_id();
>> +	struct mpath_device *mpath_device;
>> +
>> +	mpath_device = srcu_dereference(mpath_head->current_path[node],
>> +					&mpath_head->srcu);
>> +	if (unlikely(!mpath_device))
>> +		return __mpath_find_path(mpath_head, node);
>> +	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
>> +		return __mpath_find_path(mpath_head, node);
>> +	return mpath_device;
>> +}
> 
> [Severity: High]
> Does this correctly validate the cached path before returning it? Unlike other
> path selection functions, this omits checking mpath_path_is_disabled().
> If a path transitions to a disabled state but remains marked as optimized, could
> mpath_numa_path() incorrectly continue to route I/O to it?

Yeah, maybe we should check that also to be clear

> 
> [ ... ]
>> @@ -103,7 +339,8 @@ EXPORT_SYMBOL_GPL(mpath_put_disk);
>>   int mpath_alloc_head_disk(struct mpath_head *mpath_head,
>>   			struct queue_limits *lim, int numa_node)
>>   {
>> -	if (!mpath_head->disk_groups || !mpath_head->parent)
>> +	if (!mpath_head->disk_groups || !mpath_head->parent ||
>> +	    !mpath_head->iopolicy)
>>   		return -EINVAL;
>>   
>>   	mpath_head->disk = blk_alloc_disk(lim, numa_node);
> 
> [Severity: High]
> If blk_alloc_disk() fails, it returns an ERR_PTR. If this is assigned directly
> to mpath_head->disk and an error is returned without setting mpath_head->disk
> back to NULL, could this cause subsequent cleanup paths (like mpath_put_disk())
> to crash when they check if (mpath_head->disk) and attempt to put an ERR_PTR?

I already commented on this in the response to another patch review.

> 

