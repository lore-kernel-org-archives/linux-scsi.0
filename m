Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC29440627B;
	Thu, 23 Jul 2026 10:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803142; cv=fail; b=NIE10zxC/TZ39km1UlM+peeFE+SK/Mvd/AsfbKaCu9x9uq/g4p7eFAHMWnCvVxd5GdePmcCWV3A9SLfgiBSd+wxSFi96cuZNfZgQSZEcvc9KK9UhuA4ROr5dn/vrcK/hIDkwNBB2fKJ6dvie39mky6pv33BJ310RgOYvZYSqzp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803142; c=relaxed/simple;
	bh=fB9SSZFavFCxN7OMPVy6LAXNz1YyhKdsXJxmJ2YFfDk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bZ0JApakapB9pK4rOCefURknHmVJ9hz77tQstoM+nhrdyULnbkBolPgSnsy2bvyx3q74HVgQTlxstdwZjpZLqhrxHIFsFLLFij+VKLpaYytBLXHHkQy3PCZwLUpeD5FAl/XFL5nO31KmhktBsGfy5+GDRK4fWJYqkYviN4b9pks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DLk6dAPt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L4jyetFC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DLk6dAPt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L4jyetFC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtpO83353632;
	Thu, 23 Jul 2026 10:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=k+zM15vHn13OL/XaVZ2+EfBwqLxcgXe1boeoQHJ0Qc0=; b=
	DLk6dAPtLao44B0o72Exxnvgzr91dpNSdR6PbPBPXkGz6Lu7IWz2anE708j7O2r5
	uQfqqm8O0Gm3NIUK/bRLpja44zeCFikHliY9whmpkqvMwuV/uLXZPLRqI+fg12za
	E7YgDVwFCz3qeFzZXNKuTCgpTB6TxmnQad9D2V4mVBjx8p33YTHMysA3TMt7cJwI
	egMyXmATu6od3PQMFpg2g2U3rm4M08gvLcfD8sJY3NiXYpynOq3Lys10zU3CVRzP
	wS6W6yW/mVfgfrTy4wly4tJWJromgRt7Y+BXSXAEGdkgoPpZlGRhFoG9+1xKM1Jl
	j+S9XHKg40NVEMr/7IhabQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6npr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:38:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAcWPi000966;
	Thu, 23 Jul 2026 10:38:58 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013006.outbound.protection.outlook.com [40.93.201.6])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxry4ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:38:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVd1pvWpb4nNXbtSayYmdPXCeHuC3/A/oGg7Jdqy2o0Y/TTFNT8o2+K4O9STH85XSC3W6cZDS/t7aaUxYqLusXgA+G9zqygST+I2L6ugKQdCKoKcPB/IOi7QsHW4wTE3sMQq/wxoVAyht05iDIqQ8wT7XGud3Em5KnbVRFfUJZ6ujGNvk28iDN6VNsu9toeoXpPmzgcr1wY8IqyGXZ+7UW0iBkqG2hmIpVUIY2pJNQV04OqDEQJBoE3Mh3Ym8I+ykpye/KLTiTmbMKeAujHPno2Tj5YJwvfpjnbmbEBpSVLe7KGR+z1+O/8jAk3AdgyLwf6i/OMCTtvaNORA7Nx41A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+zM15vHn13OL/XaVZ2+EfBwqLxcgXe1boeoQHJ0Qc0=;
 b=RiRatOMiKZozVmU+OeakSnTCHo7RqLuHFP42VuSvpy0XlNrd0sMendJmlGAlth+ATjdXsDS+FC/pUm38tI764qWVq7sDRbMLfIv52+PmeT6WI2m9/mNMh2ZE8NxLMb4INkqNCi/TLIOgaZZ88X2GLSCN3hfqiyG0AjPPpXY6To3FaeY5PvrW6SxRkxJayi6FyAfhNhrMyzTACqVupeS600D+m2378xdLvVgdhWroohlULX7FTiKwwC6osVjSjSClE62fUZFGv2WcnXuHvPX75XOoMWKaTJ8ue6tyMo5b7UC5nDy4q+VZfMiY9Smx3fvj2zsKCHSvWuggMI06WYMpWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+zM15vHn13OL/XaVZ2+EfBwqLxcgXe1boeoQHJ0Qc0=;
 b=L4jyetFCzUjyzFLhhbcBKdvLU+SfcyCIcH16Ll+0A05FAf0zPHoTHkLYVUBtBofOpo+BWrt3wAaEqdFinbaJZISSCIAynS03kgArEBt/igT8sCGFnOMvXGVelHYGrEY4w8sqZERtW2/ejg7v4x/a916GIHNQZ3ealCoZV/NEIQ4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH8PR10MB997765.namprd10.prod.outlook.com (2603:10b6:510:39f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 10:38:55 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:38:54 +0000
Message-ID: <f4711431-dcd2-4743-8299-62e2639c8d75@oracle.com>
Date: Thu, 23 Jul 2026 11:38:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/28] libmultipath: Add support for block device IOCTL
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-10-john.g.garry@oracle.com>
 <20260723100929.A000D1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723100929.A000D1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0170.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH8PR10MB997765:EE_
X-MS-Office365-Filtering-Correlation-Id: 472a1bcf-18ac-43b0-2768-08dee8a697bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|10067099003|4143699003|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	H0cvpZ4vHZbrnN93tDegZ38+d4KGT2u4J3J13amxr4lQqGJs9ftiR++tfcyLxjqbCUatIlN6t2fjRZ7v+cs9jZ2pxdYb6VmgN5sSRO+5qg4zLfc3vGDqQdWW+VtV3ay5O+8Zuo7yFmUbMnho/nQHu3o71j6mdv00CCuQQ5fHu+WlCnZhxQvlLoNdOA8w5aSK4Njs9sD5HsXDt+GxDvpUdWCU9R9ED6ZY2X+7S3O7YS6vpB9ZLG2J/tYXk2UroYqjwnsARqAcs7N2d6yKaqcaB8ZixW7TPYl9EzeDvEwALZIGAGf+O5HKJXwEFHg9NyBzvrqERGJAjGMSnpDT3LHfRJBguWAp9Wyc31wpiMC5CGhrzK2S5Qnr5R2BlHcF7IwJ8fkmnZwzROfQ4EkRYUTTUGCWcGg+sK26yY+XNjxUnDFq3iALp1zBFUYO09qrplcmAqXTkiqv3VZv9S9nh06yi+dD6W3GJNniSR/Sk+W7wLe8BxWbDqbKMBmb4v6WOjDSbndvNTkP2J+/dgPM8EMMAmt58gxsRxG9wFibZfROB5v5Bi16vygCuidlHfBU70kV4DsN2/PlPOAl9BCIhLYeF6xnAKrhoLcdKl5TSRbnEmG/nfKRAZkOxJQwAHdY6Tln/Hs4axJ0KcsDEYOWqkQWr7c5MSqmlscZFN1mcdZ/pbg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDVqTjdjOHdKNUI5Y2NhdGMzK0tXNHd0R2tZMk9zVXNjbHN1RHlsQ3JjMHpu?=
 =?utf-8?B?YU1HNDVZNnJOTVBmKzlmYkUvTVV3cFRtTkNhVEhNdlE1d2t2RGVlVHhhaDJF?=
 =?utf-8?B?OTVJckNBMDQ4Zk4vZ1YwTENtYVJJV1FpcEUvT1J4Y2VHYW5pNmsxOTliYnda?=
 =?utf-8?B?Y3lDT3N4ekJQL0l1LzZLYkdxM2RmVE8zVmd0SDU3Y1llWnZIQU5CeW81Vjlx?=
 =?utf-8?B?dU9LNXhSSlJ4dVpyK3c0d1BpNmR3NG9Rbmg1eURsN3lqZzBFdmxpOWs5ZFd5?=
 =?utf-8?B?dldUWXRtSnc0N3hVUUNoYmtmSmhBNWlCbVVaeVpWakJXdnFFKzE0TVVXVlpR?=
 =?utf-8?B?S3ZLWCtzN2NmUVgvczBPcVdaWW9uaHVNWFRvQStaTWlSWjhrSU9aU05iWkxZ?=
 =?utf-8?B?UW5IR3diZU5xdzluOFFiY01VTjZMZDBqenQ1SnlMZDBDakZ4ZHBPTVo4Z2NR?=
 =?utf-8?B?ajIyRk82aU9WdXNlVDk1MXcxV3NsZk5FN2JVbjlQdFQxSzVwWldJRmpTanBk?=
 =?utf-8?B?QXdYNGdleEtWR1dvRlpVeTdDS2tzc3RGNUoyMWF0OHZzUEJyd3hvYXRiTCta?=
 =?utf-8?B?ZDhkMm1TUEI3dzhNbGFIN3NHUEVDMEY3eVhYWGlxQnVHTFdvano2YlppZlNs?=
 =?utf-8?B?ODYzUXZHSHdrd1MzZkl1OGxaOG1kQlQxaUoxRzMrMTN6QUtpZXFMcVNUQ2Ux?=
 =?utf-8?B?UEdBTFJjTEFmam1YZ0ZnWXZYWTNyY1plWUVKc0tHOUpwU2RibEFUK1pQNlNY?=
 =?utf-8?B?cDBoWTNXWkh1anVvVXVwb3NUa2JwV29HWWRpWkhBeWd5cWF3QnpVQ2JXcVdC?=
 =?utf-8?B?WkNkNGRXNk9JVG8ya2w4OTNaekJhclNCem12b0lRU3pRWWVhME03eVlPaU9P?=
 =?utf-8?B?WDR3ZjRTTEdQVEdobkF6QXNNYUdGRUJ6ZXdzcXI3SWgwb0JPWDRZV3lrSUNj?=
 =?utf-8?B?OXJYRmh3UHp6R1ZLMCtFQ3dZZDVIb3VZSnNXNExhVzVwY0ZuRFBMR3dzSUJM?=
 =?utf-8?B?R1BaNGp6Z25Pb1V0bjY2Kzl6d00wajhmNm5Uc3F2MmZLemRFRXRiS0ZhdlhG?=
 =?utf-8?B?NGdFd3c3S3RjakIrSTBxS0pYRFo1bVZoNWpVWHUxMEswZTV3dTNuWnhRSXVU?=
 =?utf-8?B?VG9iTVZRamc1T3R4Sld4dkUxeFFENHM2M3Q5UVdrRUZUQ3JoVlN3cWtncFJN?=
 =?utf-8?B?bkwrdlZuQ0RKemRhRjJMNk1KY2Nka1ZTZGovQlU5OUdtQ0x3Tk9USUNzQW9q?=
 =?utf-8?B?eEFQeFIxN29mSGZta3FSRFVJNmhPWU5TZzVkK1dGMDJLdFFjQndsM0kxUDRP?=
 =?utf-8?B?NVZ2MFBZMTRzbGk2ejRBVnpSUnBNM2ZicEUwM1haaWhER0ZHMTdWOEtyREFZ?=
 =?utf-8?B?cnpTVDJORi9UV3BuOVhpM0pqK3RxRnlpN1RnU08wd1NOZjA5aGlDcFVySlpR?=
 =?utf-8?B?STBWczZVMWVBeERhTDVyZlFBK2RGaTc5dTFnNGRGUG1SN0ZhRmFrTW1neXlt?=
 =?utf-8?B?QUk0dGRvRTY4a2QvYVBtQjRlTzR5TnAzTHB1bGhLNUtZWm1NL2NGdHRYTS8z?=
 =?utf-8?B?Uk5MUHpWZEU5a0NBUWpWMUYyeDRVelJ5bTBJcTZ0VExISWdYd3VNMTdiRncz?=
 =?utf-8?B?cld1ZVljMXVMTlVqQU1BTUE2QnVBeW9ScXRpSC9Ublp2Mk05L3NvTEszNEx0?=
 =?utf-8?B?RDRwQXBLSitqZkE0cnEvRnFIQXJsMytxczFqeXZ1YmdJZnZ4UDAzVStTTFR0?=
 =?utf-8?B?bFBoZCs2SXRNa3ZoaDhTek5tZndNTmhSZVlXRHdldm5WazVERFkwY1NmaVBV?=
 =?utf-8?B?T2tneGhFaE1hMUJKNmIybXAvTHJqVS95OFQ1YWRkRVl1cWlTNFFpcS9RUlE2?=
 =?utf-8?B?RGpHdG5KenZnQVNnblFxOWNmYzBtNTBkRWEvK1AxWEVQbUN3TmNTSkVVRmJ3?=
 =?utf-8?B?djBaNUpaZ2NWNVJtZUMrS2dQd2JWUGF5QXQ3eExHaXRueUNsZk9acFVtMEhh?=
 =?utf-8?B?cGhXV29iWjAzUzNhK0cyb25vdFl2ekczTDhLTGZlV1Ntb1RlVlNWcGhvTzN0?=
 =?utf-8?B?VVRVeEd1N1FKWmorMy9WSnE2VzYzVWgzcUI2T01peWxqeU1GR0krRFNxTVNu?=
 =?utf-8?B?ekw1Q2NFOXNVY29vU1dwV09xK1JnWlFCbEhJdUFiNTRNdXlQRllFUEhzWG5u?=
 =?utf-8?B?VE9qUGlEOWxpUHVmMVJjOEZMMHJuaXo1N0ROSk93NXlzbzM1ZkI0YUxlaGpE?=
 =?utf-8?B?R2FzeDlvdEFwYWthL0RLdk5qeDdXWWExdnlQTndmRk84SHk2MVVMcGEzL3V3?=
 =?utf-8?B?WTNjRno4bmpLZWZJcFVlSkUzekx4SGNPVWtzbEF5VE1zaXd2RCt6ZHRlUzZQ?=
 =?utf-8?Q?UyTyuGleLPLViD0M=3D?=
X-Exchange-RoutingPolicyChecked:
	IuE86hUT4iRICqMkJYR0Jz9zqCtvRcbAi8hvU37yxkBL2O6TOGJFuIH2QJVvFN2l7PnxH9k6MfczaQWa27IGQoDkD1RqAAbguQ4dqJinYz59wFjTZ/sfPYPuFVaUgd8UqQsUKhTQ2cRdDuLjKtxrWuPbFLLPg8lREw+VV/PxdlxQXcqxmE9IN0MKG9pihnt7FxrxtyvdA7NW8fMEB6fVaKPok7eFqnhPMmLlZrO9PN4tVBon0NN/cTK0WHSEWbJTMAgrAZHU9DJ0veZ1pVvSy+6E/6RVkB4JDtw4xjsipebhMPa4YEKS6WQi/mppAQmJ2b2PS2UbvWpGrNuJGZVfDg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tRVq8BDKxX9PywR3X9mEWQ9cdi3NWpkjU0/YsaUruVwFfLdjwtWb3ZxcN36MJZUH0ApxyeXJAzYbJkDZbvwLYoH26JQjF9OGNpNJdkgCJ9X32TFZ26ChfVMA5z2x4ZlcqFYM8bkCnmDLjgGoaFssxGtKemMv/af/OMa8XuHZ5BOs3WmRkwmbzpRFS4wYwFhV6UtP/jAMjGwagqVJip/QknETN5wgpKrCj+33bUk1tc0nIz3Ksud4V9F74B94LB5enf+iILf7ly5pFNSLBJ8yfHq6FNyW49wyLhV6YDM2sovkI5qf7lt3kWqB1uUhxIYDiqnkt0pKkk/bBFhKWqp/Jaq8ZU43pPlzMCx2PR2CZmwCNscURC6EbLC7N/qcPjImW3pGHfrqJqN7P2aIBIEpYyevnWspa0NicVe6rwvkkScD6tf99cmT35feHdTonWaB3gmj9S+ES5vs7bB1G12QLVR4W65kq2Vt08mKk35aiypF3GhC3jIFPCIoAfDW5LOXOkUocM8ELFEsm7xXlAtzXLVIBUc1RDpZEcj+A+6wtmNJa4ScOMP8o1yWw3b69v6wBe6QeuTkgav4PtmZPK2BjuSw4VGxZ9wLC+4OPquI/Gg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472a1bcf-18ac-43b0-2768-08dee8a697bc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:38:54.3142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7DLid01m+KPMnrzmNNwk4/DT9znSJiz1TNk42yQ4958BjNaRxCwo471Og3mf4F0i/9TjbY4V2+YxRglxR34zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB997765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230105
X-Proofpoint-GUID: Xf7jKrgv3uHDeSRag7NmyEUVQoVzc6qb
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfXz97TDJI8p8Rz
 mYr9pIK8aWX6JUvAuUedUtBLQm0eESTcvxOt23iytwza91FBVqbfUCpoMYGVDMDmXgHWb0V2cWe
 5e4vYsGcHzKFrDc1+VCRX1IHcjnN3ETwyEcDLll9PWVAiluOFJsG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX37vrcwxKHQqW
 2KOGC7XcVdXnwNcjYPg+t/oPwveQHFjpp3qHIBzhSUkp/7IEMdsGZpRZTlil7ODby+ybE/4rsso
 p4Q7WgDmKJN5kQsRrvLVddhAIA5iOvVriFqYBW9nNbf5Vwei7xwtN/JQc57wHhkLnYriee1oLIF
 CQhzAeA5CrhIFWRi2uCAZVA4mKo9hHr8juXXcEPCx+M2HD3OkCXMK7Cr2ai6sVjOFvbHn3NvdYe
 YXb2nFarAmwRueVbdVmJoP9qHOr+JUzeW2w6X8WXQaNa0hD1fy4vXZBhFWBJtsxm8SRzjpFooIO
 C9/B7fOF6slD5nnOTrkxeqpXGpq5Zq/VqdJQHMCT16jWBmOhwBSFO4A2J//Xd0D95kNOXiDyZpx
 YgqgvHSa81Aa0O0OtCYmHTMcXMvkk8jBUL9cUpXlaFSbi72KNdViCQdIxBOuxA6hSKnfTPoPbfS
 VzHCidYFhJSyqSebwSZii6Wc3kjSgxCSEDk+FLNk=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a61ef43 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=47xqtPe5dvJxZQq8w2cA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: Xf7jKrgv3uHDeSRag7NmyEUVQoVzc6qb

On 23/07/2026 11:09, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Bypass of partition-based security restrictions for block ioctls by passing the underlying whole-disk block device (part0) to the lower driver's ioctl.
> - [High] Holding the SRCU read lock around the underlying block device IOCTL causes an ABBA deadlock if the IOCTL triggers or blocks on path removal.
> --
> 
> --- Patch [9]: [PATCH v4 09/28] libmultipath: Add support for block device IOCTL ---
> commit 8ca4b41fee0b6082cd169ad8577365e7f205461d
> Author: John Garry <john.garry@linux.dev>
> Subject: libmultipath: Add support for block device IOCTL
> 
> This commit adds mpath_bdev_ioctl() as a multipath block device ioctl
> handler. It delegates the ioctls to the underlying path's block device
> operations.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 0232f51f64742..fc8ba8fc501f1 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -478,11 +478,44 @@ static void mpath_bdev_release(struct gendisk *disk)
>>   	mpath_put_head(mpath_head);
>>   }
>>   
>> +static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
>> +		    unsigned int cmd, unsigned long arg)
>> +{
>> +	struct gendisk *disk = bdev->bd_disk;
>> +	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, err;
>> +
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +	mpath_device = mpath_find_path(mpath_head);
>> +	if (!mpath_device) {
>> +		err = -EWOULDBLOCK;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (!mpath_device->disk->fops->ioctl) {
>> +		err = -EOPNOTSUPP;
>> +		goto out_unlock;
>> +	}
>> +
>> +	err = mpath_device->disk->fops->ioctl(
>> +			mpath_device->disk->part0, mode, cmd, arg);
> 
> [Severity: Critical]

will check

> Does passing part0 bypass partition-based security restrictions in the
> underlying driver?
> 
> When an unprivileged user issues an ioctl on a multipath partition, this
> code delegates it but passes the whole-disk block device (part0) instead of
> the partition's block device.
> 
> Underlying drivers, such as NVMe via nvme_ioctl(), rely on
> bdev_is_partition() to detect partition-level access and deny unprivileged
> passthrough commands. Since part0 is passed, bdev_is_partition() evaluates
> to false, tricking the lower driver into skipping containment checks.
> 
> Could this allow unprivileged users with access to a multipath partition to
> execute passthrough commands on the entire underlying physical device?
> 
> [Severity: High]
> Can holding the SRCU read lock across the underlying ioctl cause a deadlock?
> 

that's not an issue for SCSI, and will solve later for NVMe

> If the underlying ioctl initiates a path removal, such as a passthrough
> command that deletes an NVMe namespace or resets a controller, the teardown
> code path will synchronously wait for SRCU readers to exit via
> synchronize_srcu().
> 
> Since the ioctl thread still holds the SRCU read lock while waiting for the
> command or removal to complete, synchronize_srcu() will block forever.
> 
>> +out_unlock:
>> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	return err;
>> +}
> 

