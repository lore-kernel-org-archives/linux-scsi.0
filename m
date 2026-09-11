Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90793672B8;
	Fri, 11 Sep 2026 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139268; cv=fail; b=jTXUmqybPi53zlQA1w/nOAGOdEYW039+5ujvSrtBNzS8fbxykvuoDJKcfupkO+jEWA57DYrj2cYdSXvsAGXYZxbPlXmFSlzfW7Ge/pmTxOOgc0yG5tSdM3J0OW5N8AqnNyGbaJigH7lGceKbNmsPegCtYpKdTRZX9q0g1RphFJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139268; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gxIFkt7HVUNlkEAaDJOVdi2EWnyqQT/oXsjeXzjwMefnwTJTKg3T6sVTsWEmpeYiwlj/2LxwnFvyR0RFQT/N4fwL9pOXSj/YQ6+6H2cmLRP1xNWaJLwE9cpphGmYfKzG7vOK248skWU6BnDsmxhdYJg0+DU6aXNyonanAtOzijI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LQtvqUh6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yvfZ2gJP; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LQtvqUh6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yvfZ2gJP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789139266; x=1820675266;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=LQtvqUh6wypHiftOCblq5y0JTVTQ04II0t6if4QPcZlW+ieupCp6mbCO
   03QSyiWGzDiVE7PZ3hpeYgeGkFZdyjPYV5VxgaM5+cg0klQdkfRY5hRpV
   7Bp2jK+aTFvu+c1lNpIWZG9uxF/13ht5j0ddj/+O1bxYeRGNt9EbkTIMk
   c2YfRL9veCvsoKOGkAl0R5GP6o7Jq4KWX6Gqks10MUbtkJnLNRNrC2u+z
   BHLyMeIab/kuWeGfU4OAhNdM9qZ4//m1sJEeOE+ST9jd1+oksSCaYFL+a
   OLEllaxc97QGJbOIMZsJ3rHsO/pglAdCb70wXYWwh345/05TPOVQNX6Qq
   g==;
X-CSE-ConnectionGUID: x0081zMyQ5GtoBnruyo/wg==
X-CSE-MsgGUID: jcJ5eShwTwGuw0C+FuKBuA==
X-IronPort-AV: E=Sophos;i="6.27,97,1786982400"; 
   d="scan'208";a="156382457"
Received: from mail-eastusazon11012002.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.2])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Sep 2026 23:07:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p+qOBvCtbzimct6zp7/FiiJmRla5T0DGBvzCB+WxcRLOrpdBZUdqZJ0cHcBVes/bI+F+MykxUBYLSmd8lg9bjXq2bIjv12SKAH79k//5F2eT8XNJOH3uk5Ykr+glmCgFJfnceMk1NxQnCXebra2qI8EriSAro8vsB0QVu8jJmQ2GADcs49DPmEG1B1760lQ+MHEG+cqXiMEKJF/eBEHWiBt1iRHpEahL347pj2eJANEpgXVmSXeeJjxkv2Eo9FVVOqskQaL8Lav24gvnNSD9YbgcmDpkJD3f8F5XVufyO98RkI/RWTv2pX5igw+d4Jq89wnx8lOIMPLk0m4zCT2VJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=Zxlg87SNULA0BXEP0wEXzAjuyxD4RpKJwnuiTuOcAuq5JWxLOkwAKJY3R/d0OvwhjBIl376oMk0UgEWDSJLjI164HcJm4Ww3V7rrkrkVVqCXi8lW8lOWYL0iv1bCK+vVdggeo55VhuQmgbP70dQ9ltHWv6ae26WpuKdU0YHaBZVKjR2kDady9+XuxDfz9mLU3tlH6h33PmVO7E82ToWug4+ZkpgMcWC4bmRmJWPMvOnfoUFWHkqhhIjlEcGVtJpUYptFVmChbYTCQTLo4NJk9a/3/Uwi1CNz39zwcncVV/xPWQeVkEmyV4HheAjlegBcDQUpsooDFg7HwTPFTuj4Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=yvfZ2gJPdnu59Ma7xxnMBR07OVJkf3wqNp/konHtLWojBWSKUT2bQ5dTxnvqj+OnKkTz92VxGWgtTleJ0WiRwc6BdGklz0nyvTUcadMyLeEhjl5yfLkkF2z5yTdNlcV5cm3ZS1kOR5GIgkIEiNjw65qqZkDRgFkqzKJdVSUOivo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH3PR04MB8814.namprd04.prod.outlook.com (2603:10b6:610:17d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 15:07:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 15:07:42 +0000
Message-ID: <e104c36a-be11-48d3-9ed3-523847a50230@wdc.com>
Date: Fri, 11 Sep 2026 17:07:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: add tests for file system on devices using protection information
 v5
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
References: <20260911070831.1760646-1-hch@lst.de>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260911070831.1760646-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0054.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH3PR04MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: b7e91e9d-2bfc-4706-fc95-08df10166dab
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|19092799006|376014|1800799024|366016|23010399003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GiDsZ6f4wUp6PCoDYqAWDxRh2gTsff1AW4sNP9FlcT25Itvyc4YRPcerU8nEn6Ti8jL15QEEcfmwqPKy+UPxGUassKACNjbeEB/KnVH04qGI/14Hiy8U6g9MsZ2xRvC/x8yWeVU/4sOgiP+ydnuzppQKxyLhxGDIo3g39FgyhTLNQ9qxdS6kYPHRBjN6tGEi5mZZ8GM+89zmr/hCiNLbjvJBvpPYmP9OYc4ph8rehVtTASoHMLN+HmdRNqr/xQSghJ/G+7Virp5A1YnvnfF5NedFXGtHKgCt5LLUxjtUXr+dO4jRjGPvpSFSxH3nmwAd5zjZCfEtgQlrTxYhu1N4NAxOBWW9hd7xIHociyIyAAv7SfijNlJsym5MK5h6EghyCeAiysiuj7H5xImGQ3feiKJXLbweSyHYwphgzY+TG9d55eIN6MsI1a3zza43or3LLi6Zg/PYrd/JDxreaQQm/3xEjNT9P65+P9lg4CzlPfra50vsFmus8bIhcoiedz/nCy8cOiUdm2SAycq2Xr0orW//SSaZjw925HbnuEdATogi5IJdseRgv+CkTppZ0FbdVM1X76wAoL7MmS/PcHSZkdhhrjFIJ513eiVa+b6gQHFpyaz5nNKXUHKf/R+UEK1FF1k+dbq+mEFNXh+akdHfukr8bf5avwSA1allm8AXEyY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(19092799006)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTh1UDgrcGF3U0NxMlA2MmtKSTdSc3BRMVhsekpJNGdzc0FxeENLK3ZuWmVT?=
 =?utf-8?B?OUZmaUc1Z0JYQm9MaUJNYzd5NHJRVlp2SXpMYWFNRXdRdmRyY2JRWmRCWkky?=
 =?utf-8?B?MWVCci9TNmllTDVFdU9KZ2crRTFsamI3L1JMNnZyQm9tbFRUb2h1bFNyYjhw?=
 =?utf-8?B?R0pORHhWbWdyaGluOTBBb2FHeFNKTzZURktWaVBWeXlIakNLaUZXVU1MV2o1?=
 =?utf-8?B?WUxuUHgzM044bTVET2duQmdDVkV3ZmVNTmVYRnNyQysvUTUzeGQyWXVxVi9P?=
 =?utf-8?B?c2RPUE1kQ2N4cjBKOGtlTnJmdDl2VkZDY3VQdDZXc3FsTmxPOVlJZ2xrVm9P?=
 =?utf-8?B?ZVBrTmhseWlkSTNTbFVuaEhtUUZ2amhDTnVjdE9UYUpVejJMZXIvekxtZmRk?=
 =?utf-8?B?bFl0V0s3SmpEb0RZVmZaZmNJZHRoWFdaclNHY1hiUy9jNlNFUEFtUFcrcS8x?=
 =?utf-8?B?Qkc3TnNLSVYvNlBlTHNrVmJ5RmMrcENnYnk3RmljV1N2SStrOHRXZmlvdi9v?=
 =?utf-8?B?NVJhSm1rRkxsNll1Tm9IdTUwTXpQczZPMFFzSEptS1hIVWFrN2JyelJnaTBh?=
 =?utf-8?B?bnNDTnIvcTRiUURXeEQrYzRlUWxXcExaQ2dwQ2huN25vTlhIWnhYUDZmSWJP?=
 =?utf-8?B?aFhaZDF0OUYzOHVSTWN2ZEZHVnlRTGs2b2VZd2ZraEhFaDBjTlZJTUs3akRE?=
 =?utf-8?B?U2swa0JzSWh1K3RlYlIzSis4V1cxZ3k4MXRlaWpFOHp0UzJFYjdSSnJJUGpC?=
 =?utf-8?B?NVd3SU5Gc2xLY2xEL0JNSVkyWG5tLzNFRlFMLzdvMkJaN3F2Mkt2Y05nQWgw?=
 =?utf-8?B?cWF5RHhDQmN3YlNjc2EyVGhyeFhUZVI0VzBhcm80bnh5N2tOWlNJSTNKYVR4?=
 =?utf-8?B?RXNGQWlhMlRNUUk5ekFiMXBDc25zVEFWRHI1YnZ2c1V4aEFQcFdHZStTRFpC?=
 =?utf-8?B?cy9tZlVFdlA2eHpXK05Bam45TnpKeWtiU1loQmRjWi85djZzdHM4SkJ2eUxs?=
 =?utf-8?B?OXduOXhlWHJ4V2ZsbllnbitmZGVFTnNZNlRWaFlSaXlWZDhONFUxM3p1OGVx?=
 =?utf-8?B?WGxDL0l2M1lDZDNBa3N2Ynl6MHU3dndjZm5GZWhYNndXQjNEandORUg4VWZV?=
 =?utf-8?B?UXg5WHhTU1NHNmNpTkJPNmlGaVM5M0tZeTd3YXdCT21jVjU3S2hheG9Uak4w?=
 =?utf-8?B?MGRjdmtoQmdxRk1zVTBxNCs2VVRHdlZsckZUTmhOdGdxTGN3Z0hSVUlodE5w?=
 =?utf-8?B?ZHR2cmNlM1JTVHFXejNHS3k2Z2l1VGJvUVZOL1BnZElQdXhna3RFeG1wZGdH?=
 =?utf-8?B?bFR0dEErSTZMN216dnVST3RETGtjZWdibmQyTGZCbklSQ0JTekxPWi9XK05T?=
 =?utf-8?B?Tk5kV2YrK05PWTJXSUJubGJ1dHk3YldWNU1UL2IxSERuUUdoMjQreDZzYktZ?=
 =?utf-8?B?T0tKOXV0SmdUL1NTMEplWVN2NHQwekUyK3FXd2ZmcVppSVhaTGZ0SjBRQWdS?=
 =?utf-8?B?Z0hhWUlpNzZvU1Q2cENUdXBjY0hUenJZeFJGQUZYakdKMjhiTUJ6b1FOYnRN?=
 =?utf-8?B?MGVtczhOdEViaU82TEEwdkJJNjdQaC9xdlowNVo1UVpNQ1p0bWM3NXRQWDF2?=
 =?utf-8?B?OWw1SExBK01rSk4wQzNhdUtIM3c5SkNjeEdmdXQwb1VkSkpWTmcrVjNYVjBV?=
 =?utf-8?B?UzdlVXRwc2EyZ0hYSUVMZDRyQ09vSjhKRnVaNW5aTFNVbTBRV1k5Y2NaZ0dP?=
 =?utf-8?B?Q1pEWVpIZEVCRkQ0V0FwbSs3WjBZeDlsMHFrdzg4eVMxcUdiODlpMWVvWVQ4?=
 =?utf-8?B?dTlCenJqNzRyOTdJTWx2Z2VyRnRadlpoZW5VOFR3OGV5RWp6Umo1aTl6MVN5?=
 =?utf-8?B?WCtjRno3OXdyamtOU0ZhbFhrNkZTckFLZW5yc0g4aVJrZVEyR2JHa0U3T1Ax?=
 =?utf-8?B?eTJPSHpSSlVudVpZSGhMRXp2bVJucFU2cHV3VkViK1QxV09GRSsrMXhQY1hX?=
 =?utf-8?B?Tyt2TGhDSUlRQzZSNlhxZzR4bVdzbnBXZ1pkeXpQbmNicUcvTlBaY0lIa3Vp?=
 =?utf-8?B?QjBWdkI2eU9zbWdTWS8yZ1EvclZrWTFqdUcwOVFCMG5hUSt1LzRvbmdzeGUr?=
 =?utf-8?B?MmxJVFhKdHhPaFp4RkpjaDdUQTl6bk84R0krWVJNeDJldWhKRG5oWlhodVhC?=
 =?utf-8?B?M2MvMm0zSGcyMWZ5SGVrbnV6blpsY1lGZWtwL0taZDI5dmtGYmQydENJcERF?=
 =?utf-8?B?VkV5aFJqQUpTeGdHV0wwbW94YjJUeHJyTUlWcHVWUHlzUVJFVGM2d2hXeGVD?=
 =?utf-8?B?VjlKR0FWNkhkQlFmVkVZL2N0RkhScnRORmRnYzlwSDVnV0JqY2N2aFIrTzFn?=
 =?utf-8?Q?ei5w62RScS1za6T86gsdf561dELi8YadF0I5c1v3vai7A?=
X-MS-Exchange-AntiSpam-MessageData-1: it6224EHpIezCdf2Vdz/JZWpu5BQxyhGk20=
X-Exchange-RoutingPolicyChecked:
	j6FXvn3Dm9qRrFkJM5+sZsPpVnXFChAN68DdcGUf1gXxPLRU8ld9S6GV+AbUacpy3WHxUQsDmg8PVsS86RntkE9r/vVUauX2zzOngbyW4weqVm6BANBa077JCSeWq1mWrpm34SuOL2uAbcgf0n+I73NDUhHBwoxXVgK/ZLuIy1xlUSoPZS10Kg2/5n7sNHLx0uC5tyu2lp4jYDdZT9lJNdWzDtb6AdokErVUH1B05o4LqtcbltrNgKp4YfEENU2QlmPECKPnQNi9BVw/6bGWkbnA307ex77X6nZ/5lnGfVFaRdL1dugonCEf9xJBYHKhCPzvCv+IBLm9UjCJT1JTMQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gwTFPHLho0pQCaV6a603FdemW94OB/Y8S98odA/dSUZDeHAswTHhjU+BqZk24owo7wAkDg+nGm/vq9rRFg6HemIESMn6KwuVLO5PBFnBNgiVj2soI571Yd+riD50QCp5tEROavS60SdfyqZa58d4bhkBjMmoNzF9IOgOYC+kpD+5lUH0jWgGa1OerCyN8aCkNjUDK0FVDOITHiUx/+t9QZ9MfNa1u0klOAAs40GmRsu2xjx2fq9Hi9dmsskNzRbDFJ7zhY2gg0bEhHvxDINA/uKRe0ux2eWoDELgbRHNXD2lw+aw6i4oAG76t7iAFd/B0e0QAhi75ebzKRrJQ99m7a6kWd9XcASssE/jnx6bQkmovjhE7wgYUEgMQIlykG8eAKxCvKQaU2ggXYDqRqNw/SEzYrtSgZNQH7htm02pL88RxSFRMw389fG77QAq7ryzNA9++BAZKpwHhOx5denaFyMxLKuumyxtkrdZaR+Eb9P9AICCq/yTCfvauNILaNAwf/vhZBbOfgisQvSNMyszMDQVLgZIRqTHfeF5cDdI6u7rrdk65J51fQRKhw63cNNKETMoOO9yrwvlwCGfSkGLYzz4xdOKROEJdgyHpRh+pKI57PM1T4BxvfrtimS72nFV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7e91e9d-2bfc-4706-fc95-08df10166dab
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 15:07:42.7702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXlHZ/VPLveu5X0zqTW2/GgTQmVrpvLOH8SjlZWMetXtdYej47RnnytFigs0LuwmiFxzCySvE8+GJbDQ/bKeL3qfPQ2Jb4KOlSjFto96JDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8814

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
