Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E78379EFF;
	Mon, 27 Jul 2026 15:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165800; cv=fail; b=fXg7BrqrBRGa2rBfoYUzLsCz1SDGnM9F2PL8R+rWGaVmE0U4SYXbVtLp8NocikjOOJ+9Xx56vvmLb+SfG6RNPV0mQrkzUrURhG5SJNiQuu8QsyEoLq9WdrD6JRDWgg9qsfvOLiB+PVPuvepGWsFWO5j4Hkif+8//gwyRJmoGQYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165800; c=relaxed/simple;
	bh=QD5Xry3AzvoY0ujlvwMU7i45TYSig3KaA5yfhJJiNZU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rmCTLVPrnE1KIUaxMYqzpoL4X3IJbsJ+OIaj+C6MwSwBu8iiKdA3Uhwph6PhjXTSJejKNVgfxpxrnfTtdzb+SZtnpwjk7LwlQGjlHTFLOF8z/gWhENNvRMzrZBMZl62K08NwlOTTOKrAXcGZhysfv1sDxfaiLbuVkKbTi5u7R4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MrD/CU/c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gsVWjZ8u; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MrD/CU/c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gsVWjZ8u"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66REtrva3308496;
	Mon, 27 Jul 2026 15:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JrYQ/iuqX1bO1loFX5g1IIgII3gyAUD+xrqwx1O79cY=; b=
	MrD/CU/cvwJb1UN6bPIxlT8QPlyfFm2AWmyLGO59lReBKs+GeKGy6mH2jml135E4
	nFQm4Lojos/SCMbStlgp1rPQBMruq47UbDfUjVCZoWOPH5kl+3bHPtGk30JPVHrL
	N0UdUy74zj+rH9J0Pmeh5tp12T6v9zwdvppsqb7+hfAJ6Il41jlAknOnTez95T0s
	8F4u5iRxf3BB++PaAxxCOeePXSbh8Fwi80R8qGza2Safk4c3uEfI0fnFnaLnyjdk
	QS4AM1mR90flN+IA6ixCi3pgwt39+U+gMrzqO98IUHhEsz1pTWASt7LbWWqw3oPI
	Fu2rEQ+c4ly32VvQTvwZbA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyya296-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:23:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFJx9w013157;
	Mon, 27 Jul 2026 15:23:16 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011019.outbound.protection.outlook.com [52.101.52.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehcse8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:23:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xNlFkB8l68BfWVn8902jaAv/XbOvM5JQ2xZjILFDXpSqlIZ0QM3CISrPNywX7oa5CGWgRLp31hzERd5xw1YJoSWc3AGN0iGqCizwbBq0IveY3ZMlzdBHKxRryMNWHouTfT2Xb6igiWQ3UTCx+DGPRzhgNAMuG4DtOiECdSFCdkRrtWFRi2PXareZowd0V7ELmBuINC08XJRmhJbO+TjdjXLXdQFJzzJjJ0lFvkwm3TBwaL9eAwmlC5vEAp4WDZc+TmL13CEXJ7z5BHjVKeWVbEBK3k83EBp77hNEfejWnlcLcrGvEs573bKR/Fvl9O7+K0TrchF8IK0mpBOg44TFGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrYQ/iuqX1bO1loFX5g1IIgII3gyAUD+xrqwx1O79cY=;
 b=uykhLvhM/wiHIYEq7rHqMkSYonm9R9VpMy7pzcFtZFRmeCa0VVfPqxLr6H6rTuTPLkVEELuxLQF8Pezj824hBEPR0MdIIHP3FUt7ESQ1NwFCxCnypIyNDl5JsXWnwV8geFKk351YPfBUZ7uWqM+uYXSeKdl3J1/XGXMMAlAVPSjr3KrC5lYEulgH9uzcGV5XKgKvcS3EaUedtAnzw48KAvstQePq6dfBC48TTOUuk/JQjMLGgT974FibNrZGZkTfjGs0raCdHq7McLImi6I9rbuXKjIqPIvqXg5ruYpMF6WRIH/sDH5bFfBP9a/YoaSEtvVbFcrwC//QYuXXXjdhZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrYQ/iuqX1bO1loFX5g1IIgII3gyAUD+xrqwx1O79cY=;
 b=gsVWjZ8ub/dnpTBayctmfkHQ1rrE6kBTF9V/6SjYPJ8IMsmVeZsR7GNudjuUKGjpR/jtHINz25dl8mMyjpUNbqTWZznK2p+5FOqbbVdRujY9/ZqQxvhyAQ0Xcbr8kfHDD5GhcnY1OngglTRicCBVNUFKCq9N/hSPXMF2Woo1iwQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA0PR10MB7370.namprd10.prod.outlook.com (2603:10b6:208:3dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 15:23:09 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:23:07 +0000
Message-ID: <fb5d81fd-f2de-452d-8d68-acbe6181c746@oracle.com>
Date: Mon, 27 Jul 2026 16:23:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/27] libmultipath: Add support for mpath_device
 management
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-6-john.g.garry@oracle.com>
 <20260727150336.A89441F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150336.A89441F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0262.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA0PR10MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: 6abd94cd-6636-4c78-40c6-08deebf2f5a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|6133799003|4143699003|56012099006|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2VIgSPBN2aw1texh2pPplvpnDz3gJO3PLIndYIg2nUKacGcIhIM1u2YYDu6wbvi2OGp6YTSmYtwKQThJuKx0KbdOKDRrKgvHlZXb55b0iwh3/HfSsRo5WvxjD2TL4phoRvm5S6aMQdXT5vLE1RISnBzDB1Js3AfEDJ071GfK9kl2YWCSFNEC/eqIyehGbiPq6hmcVfuF6bqcxQ2KN2r8GAMomTZDr5b9DnKd/AbfaA6xEZptQz4CKrNxq+sBLwhEv5wRHq3gDFHeR1CNddjE7FN56b2x7veDYsb8t/GN8Yk8RREh0javxI5vh9IgYaxbkLnXimqdjpWv7nyzrEy4429a8lQA/lVX8AjxSI7EjdKAp//7dJ8imYD+hmLkIWCO8lYhfs3rgE8LhG0tyRbGWdhevbPGVOZdZ+iyQDBv+uq2N0Qj9rG6PNrQmK82lVDZb90iaCpjOof3c/zhJrJlOTBfBkfZ3JC1joC43XMgLHVew5P1nXa3WV1R6NmfS4HIjJH2ZPoChsqdpeeRrO9gQ+rhvq6/Iw0qCirjALrSLEXaBxA63c2KjyoGreaBKQMBF6QMCowMmER8D5hmQsbdNnFnImOJB/z1oic25myPllZj2UiV3hr9ddBj/LfCzs0E9QZmLWMpVpDMaJKBukAN/tpT7WHUS8q3p0pbArRclLw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(6133799003)(4143699003)(56012099006)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGtpUDhlNXZWdWR2Ujk3M1A5NmtodXBsMlNPVkREM20zSFdGdklPVjFJRzcx?=
 =?utf-8?B?dklaM2RHMnpMU3M5RTkrcTJSYXFSVHdYMXZPejQ0ZjREbTFPQ0I0eGhLNWo1?=
 =?utf-8?B?Vy80dWR5V211cWVteE9qdVd6ZGY0emJrNGg3bTQ1UlJLcERsU3FqRk1aTjZt?=
 =?utf-8?B?UWdvOU9BaVlzRHhsSks0V2l0dEMxaVdxVzVtOGlZNzVzbktnQTl1ODIyWXd4?=
 =?utf-8?B?aU9tclhGejF2T0tiNVhZVTVtNWplUlVxcGtkaFg0K3R1ZGJmZkNvY2VhelpT?=
 =?utf-8?B?S29ydHJCYUpVb0lHMlRiY2NuaEpmeHBpVmszMXZqYWpTL0tZdndIMTBmUFdW?=
 =?utf-8?B?SGJmdzFhR3d6VzdoNW9MQ2s1L2Q2T1FGMGI3RW9ldzh0dk9qanhoekplaU1o?=
 =?utf-8?B?YU8rMkFwNnlzd3F5UXVYU1NWRUZsVEQ4UWhrL0VWWlArMDY2UjdCSjBaNDlY?=
 =?utf-8?B?YWdpejFWREtXRll4S0hpc0N2ckZIOWVsdUFOVFpPSTZFOHlMQUpmUXNpTDRu?=
 =?utf-8?B?STNkN3hpK1UwWDRFSnFFR2QxUnNJWjRVM0VpWTEvbm5FYTFUOHFYNDNORXZI?=
 =?utf-8?B?VCtMZThDMythS0ZDMUJHU0VrVmlmK2tEaFlYNjZKa2NIMzMxRldHU1djeTRO?=
 =?utf-8?B?TjV6TDQ2dndLbVNFODNYYllhK0tzbi9KcTI5NjZLVEFtNjdvZ09VNm9XOUFQ?=
 =?utf-8?B?WkJkK0FIOUdLYitjK0k4ejMrSTJjUHZvc25DRG5hVDY0bmdUZGN1a3Jzd200?=
 =?utf-8?B?c0k4YkF5c0FFNThDa3R0MnM4YkxtOHc3TzBuTnRJb0M0c3ZjbSt4V1FMMXFl?=
 =?utf-8?B?S2R0RHQ5bHM0NWN6U3ZhWnlRUDhVMXBURVZrZ0RmZ1g3aE5Cekh2LzUwV0hI?=
 =?utf-8?B?QVRvekNEazNBNksrT0d5VEhZUjZOUWtYeWZRWUY4cEVwcStzcWFBZ1RlODQ5?=
 =?utf-8?B?dVRlbmVFR0RGclIrSnFPdjhjU1ZhbEZKeGFDWUxncU1FRElGYlBYb3J0MDRM?=
 =?utf-8?B?MjUrWnVrZExZSXR2WnFwNVJ3MFBFd3NiYy9iSFZXQitUdkMvb2prbmtxZUJI?=
 =?utf-8?B?RUhVZkJ6Q1g1NjVySUg4MjFOUVUyQ1ZlbDBXbVJFM0MzU0tmNDlUUXBGNjNk?=
 =?utf-8?B?elQyQmZVY2pXTEFHWUNmSC9sVTQxNnpEMTBsK0NJTlYxNWtqbWVicElNcytn?=
 =?utf-8?B?Z3kwYXppQWladENPQnpDV0dGNEJOSUJKOFBlbnJVS1JzbjJLOHRERTNPY2o4?=
 =?utf-8?B?ZjJEaDBrWHdkdmFFQWlBMHBsaS9SYjh1VFB1VGRCZWhQU3hWbEtqdU9VRGI3?=
 =?utf-8?B?a1BDVXE3dUVRVnArQXhUdmF3TmE4WVRodkdrWUR0dlJySzZuWXp5MHdrenlH?=
 =?utf-8?B?SE96bVpjbmJkZUZDd2JzQnpuYVl2bjRjWmxITlQyYnJXYU1RRUtDL29UQUpr?=
 =?utf-8?B?dVZCS0sxVzlnbzZ6Q0I3SUwyaExmbENLQVdsMGlZc0Jydmw1NklmUXhBdnQ5?=
 =?utf-8?B?NEo4amNjUWVxOVR1Z2RMUlBMeXBkWjluRExxSjJxdFUveEhoY0NiU1RTMjlO?=
 =?utf-8?B?dktnbVdFQnM3bVJVYW5jN1pGZjZuazRMKzhLSGlwOWIvbnlFU2tuam94Q1pS?=
 =?utf-8?B?NkpwQlh5SFczb0FUR2FVKzNwQlluOWpFR1pCbC8xTjMyVCtMTEJ5S083bUZw?=
 =?utf-8?B?cWRqL3BsQ3JOVFUzdFZ4ZGxZL25PRTRKWmlqRWJGNkhlRTRIRFQ3WVlVOU52?=
 =?utf-8?B?U0l3K2xiSlNFTkVXSFV6RUZTRTFGYXhoZXg3ckpLREEyT0JqMlF5RFExcFBF?=
 =?utf-8?B?UTRqeEhEb2pKWHZmbzQ5dHlSdFNsTHBObHAwS3RKUjlUSG1HS0ZQYStLakhp?=
 =?utf-8?B?cVdaY3h4Z09wYlgzU3pjYjB4a0dVdm1tdktwUzhMRURJMnFyVThNbDlsNWtW?=
 =?utf-8?B?cnYyYnpBODlQS2FZVC8zbWtmazVTdW4xTDk1Wk1rREZKZTV3YUgwbEpjN1lR?=
 =?utf-8?B?MFZ5ejRXMlJzNVVxRExudmttK3cvb2w3TDFDbW5LcFF5eW5CK084aVpBaXZq?=
 =?utf-8?B?SFI5WVdSY08rd01id281Rmh6NUJYdGlvM2xhcU0zVjBYL1AxS0pFMW1reEpy?=
 =?utf-8?B?emcwVkxhcVhSWndBSVpJRWRZQmV0L0F5eGpISWF3bU52Slg2dnllUllpaDIr?=
 =?utf-8?B?VmxPSFNLeHU4aGx6NHZOQTFTdEwybThLaUxoUXRsNXRJWHlkV0YwQVJiM0RN?=
 =?utf-8?B?UllJS08yRTY5b281ZTQxa1J3WjdITG9vOTFCSDV6d2F6T2wyZGN6TkZsMmFH?=
 =?utf-8?B?aFpHOVI4RFRGUk9LTllrTzNoT3VwcHhwM1BEcitEMGo3aFAybW1iYXA5M0xv?=
 =?utf-8?Q?sIDszU7kLuG9IF9A=3D?=
X-Exchange-RoutingPolicyChecked:
	htDVNdE7FnLC0f7Fo18DHX3A+WKi245HXYpVgrHmEsvoh3J6GD0HzFSP19OVEBzXSAgdi9asEU06jQ702ND1lIhSoQWN0NYGsJ9rfZARsBeGQleN6rdowpRwX4JhmMW9LiVsVsWTL2n0mi16uHqfKZ71qZBYkw+SKW9ZVCuL3ESlmZUlrISm8iPVruVbsM27j483IgOoRxustx4siV0BM4ZXWOWJRr9U3l1Qxj9Fkt6SytPd8yivcADAIsTit37k3v2w0W9ELDaH02ZedjGYVCl9yLAdkP0hHaoh66h+x8jbh0ixK12DK5K7r4kDRYdlYiNq9RCTuf/cd5aQka8DDw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SFXFd9ICCELvtgKOXeuTNM/gtdQfbW9iyW0synDsOXB6boEVsb8jkSxeqzpeDTwizPO93mjSA+I+I63RHTlJAQ0bD907PKz1cDXI1hh1ocau4FGGAoUxe8QPg9g82G2UMiao0KFGscFfyEYJkZv0OqWgVyWkG6XnRu6l6MwXsHTIPtX1GPTdJbSLeO20wWnTf522JMP2nSFPgJes/PB0u4NRJv10NR2dxWfQGAts6moznw0RV/ZvAvBbHbCeIN5JE9l/5qHXoRTMaDz8SoTtek/p0B/47bqcEhYZGDtmBAuL1k0Uat0w8abz+uE1ba0MzItN9egi2cG+NWw80ZaXQm4E1MUUKiSyC3jZnW/QfmC0cGdX/Q5DMllKeonuThMZN8TGmSHjHUG3VvuATiqI6zSY3Nhm01aMNsW6q/y6T0xmPtk1zlloPU40qiYRLbzz06xh1MIpTCQ6t4vCglyN3Y4XqAk/pXEJHEZPNcDgJJwuisqUQNtLe4G8u4RVhOKcg4doEXTvspnJnCODSrcePe71XbFtdfLmuqhFmDVoH/N5qefUFk7qVeovpH1UA+cEIUkiLD3ugoRNFdS4Bg/ew+6x6Zx4DWEFa1U8rb13Ldk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abd94cd-6636-4c78-40c6-08deebf2f5a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:23:07.1001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dske+lQ6yXSvhONQqKqUw+7C0H2Gz4xU1KpRxuqlKyGI+t/ZCDtnwviuQwc7aS29C/kKMkEXKZ+OM4zJ5+WSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7370
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270144
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NCBTYWx0ZWRfXzbQ0RdzlW0T3
 umYJlQCk9qQaoxVTdljGZkMNHAaD6zLZAw0qvoKxO+mAENt3RXS3ZKc8ERfHzpTSqh8FfhIZ9KL
 M7fm6b2IVfUwOYhBkheInU8IQuSaz0anvzQZ8cIyAM8DrRqFkGoX
X-Proofpoint-GUID: DenBZqt4O68GOz_tWt5GBdPmIE6XFJUq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NCBTYWx0ZWRfX+JmDwJOmtCE2
 z1JERsXTajDM//oaWA2uQtg9+KqEv8XLw0VwPeW9BDAdodTDV+q0LwHNQie7cz8UaSsbbxylqfp
 rUsEfiTY7ITYDvGkDwJklgtBycJcazix+m4eMxvVp8eZ/nuGWhgkGn1nE+63wZN7dnlUEtRiARe
 eTPREo0CCStRRIEBkxLtStPrhdELy8lA7fFxzqbb0cPdYdMzLTMrQvtkkJJU4ZT9XLPHzQ/kmQL
 iP16tGdt3fsSQ/nIZy7yJVK3PVC4H+r7LhD9EwA/oULq7G/LIGdVHId+vENU3qq37qyXb9qg16r
 P4KOYfn2yta4liIhWn5PVq67tqb8pPxv+U3dAHfDaAUOP7ggA6y5hEoOEm7QRnDEVdwk2+uUPlJ
 xeAGUvohgLp6B+NLxVQnI8F95AcTqdrSi63jJYCDL37itf2qrHmPoSJALT8kQghr0RCMFfzzEDy
 GdtRFzVggnQIbSCWCZQ==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a6777e5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=c8bkGtkSuenKBMoVl9EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DenBZqt4O68GOz_tWt5GBdPmIE6XFJUq

On 27/07/2026 16:03, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] `mpath_delete_device()` calls `mpath_synchronize()` without first removing the device from `current_path`, risking a use-after-free if callers rely on it for full synchronization.
> --
> 
> --- Patch [5]: [PATCH v5 05/27] libmultipath: Add support for mpath_device management ---
> commit 036ecbe8e851ac2a476516f8e8a72ff07e94750c
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add support for mpath_device management
> 
> This commit adds support to add or remove an mpath_device as a path.
> It introduces equivalents to NVMe mpath functions like clearing, adding,
> and removing sysfs links, as well as revalidating paths.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index db5f83ebe5d7f..f70049b6cede9 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> +bool mpath_delete_device(struct mpath_device *mpath_device)
>> +{
>> +	bool empty;
>> +
>> +	mutex_lock(&mpath_device->mpath_head->lock);
>> +	list_del_rcu(&mpath_device->siblings);
>> +	empty = list_empty(&mpath_device->mpath_head->dev_list);
>> +	mutex_unlock(&mpath_device->mpath_head->lock);
>> +
>> +	mpath_synchronize(mpath_device->mpath_head);
> 
> [Severity: Medium]
> Does this code leave the device accessible to new RCU readers via the
> current_path array?
> 

it is removed in sd_mpath_remove() -> mpath_clear_current_path()

> By calling mpath_synchronize() here without first removing the device from
> current_path (for example, by calling mpath_clear_current_path() before
> synchronization), new RCU readers could still find and access the device.
> If callers assume mpath_delete_device() provides full synchronization and
> subsequently free the device, could this lead to a use-after-free?
> 
>> +
>> +	return empty;
>> +}
> 

