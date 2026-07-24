Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376C23CCFAF;
	Fri, 24 Jul 2026 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784918025; cv=fail; b=Po88lM4N5lv3c/YyGtYaZE9+U8V4qOQNic33HM7TRIWJEZ1h9G/YtsNmNgHh5zqbA/Xap6qO6cPnVtEhNZbjcXyfrPigKRgcfG9SjLo47pLFOTbcJcOgDWDouqofy9ZgA+fdI0sq6K+uh3vRB1kEKTbj13pRuHJLzxT94XHssvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784918025; c=relaxed/simple;
	bh=38Dh3F/TyBtL6FKBpEoq3xLOwFvqzrPswSI7ObFfsl4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GYlWlL2jFrBZdb0Ehz65QfWXn7IoULgDbT8tUt72GOc1vF8XCSjcTuck+zFUz71zDky+7JBAje3b9mMWsFYCe49ye3iFAhGTgNKJWvnROxw9wOrJETYOLUDQsATM8q9rzXcACzNRZk7erRxCNuC4Dagm0gEX5Bre/R0+usPS+Y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mL6a6uDN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Uc3NFjep; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mL6a6uDN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Uc3NFjep"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OFBjkd3742406;
	Fri, 24 Jul 2026 18:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zREHlTQsCluX4DG7fAGpgZFTnJifnk9Xqtcwnnpo8yM=; b=
	mL6a6uDNHJhgLracywajWsmk5B7FTE3apdjVzIvESG+JBLGa7qtN7op6V/s/sDOq
	xp/nfSDA5M0AxwsTyEzOECU+tHoAvtWzUiNTAGEprX5xATJ+RPPAPE1oosxPZy7K
	1SrelVGJ6L4BroBK8IN+1O2qpoXoXePgx15c1KFK9tuOaFLT/nnI2VuZHLyrHDor
	lO5R4EXxzutvtB6hjfxbDGWyvlayR+wfg0GMiVpgf7Fo0giT6ZQvrSgF/3cVWH7i
	JfYBDWMMLEGxpUMl6QJZBi2PZtFzpO3iXFBoK7DWmtDPrst0OcNuH8kCW2QJolHB
	bz/Ccdw7AqjFvf0nIWpVNg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kq11a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 18:33:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OIXFZv013215;
	Fri, 24 Jul 2026 18:33:29 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts2k6c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 18:33:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TyBhTP3NLJ0JxAvuP44tuuwbCOcGSqQHw8MGtmSExVVoCgjHVidxsliULxsu0wtLTmn3UPCOlwJRjTRieBveLNNTHCuegM9MJnme70Q1OXEtrOmVGageGDzJKQuN4+LXbDXsoZzkRVH3zRQGAjA0X5m2zBmliMHqadXN31Z87npNYWUl/lImKjHGYzRo0TlCqqrT+P736hBS5tL6gjfS4ruaIb02wVTw1NKPAnpMSOrYH64c1a8Tyv8xuBANCuFwXpURutw82pVTXiqFyAHZ2YI+Um7hrPuzMdduPqPr1S+sQWd+FboeP95KvLYrXyfCCDAd/noY7c+M3KjR+IEhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zREHlTQsCluX4DG7fAGpgZFTnJifnk9Xqtcwnnpo8yM=;
 b=hXyNw1tZKhaQhyXJ8pw9uI+zCqPipkgC29Zsmej3Ggu+aghF37qgTd60dsz/+f50mFnV7TQTbEm99VUs4dtveisjyOuIPj2RYUMuNJkyUfwpMC89PegSrAAnfomXQUODgBb7xzN6/YcdtF8E3BpUQ0s1JhHUnX98wpNCsZg4t7umCGIwDlXqc1w9GcEmOBhlESRlRxzvacmR2zgsvEy/Cv++eC9pXqF24SY3+OG73YPN4oKnZAB0I3FlQD2CiFtxgm6CqGq4CfsT1qfBYg71Z7cScte/9UiFXJBTqALWq9BvFDzVAUEXGVr4McfHub00T5YZJ8qMLb7YghNuO01nag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zREHlTQsCluX4DG7fAGpgZFTnJifnk9Xqtcwnnpo8yM=;
 b=Uc3NFjepxGpXqdOh6nZvLkNvzalxfaQrTABsYdZBjlbkNNNCvUgSArargv7I3gPbWS2mn11jhD5jdMMsxPk8bIeUkWf1L8yTZr840gxeB0YxcWwqXrpE8Li7mR+uIHNY0DcG+PaIyJDbiMwPwHgSUZvpSVz3udPEVBp73TXRVIc=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by DSVPR10MB997799.namprd10.prod.outlook.com
 (2603:10b6:8:389::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 18:33:24 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5%4]) with mapi id 15.21.0181.016; Fri, 24 Jul 2026
 18:33:23 +0000
Message-ID: <b66a2efb-e103-4428-a081-068e2859d3fc@oracle.com>
Date: Fri, 24 Jul 2026 13:33:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: iblock: Fix wrong PR ops NULL check for
 PREEMPT/RELEASE
To: kensanya@163.com, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, TanZheng <tanzheng@kylinos.cn>
References: <20260724075850.280699-1-kensanya@163.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260724075850.280699-1-kensanya@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8P221CA0034.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:346::27) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|DSVPR10MB997799:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cdfaf93-c185-4b22-dfde-08dee9b20ada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|22082099003|18002099003|6133799003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	BWcMPrMlp3Iqh+Pxx69aPTUIfiU+bS/68vK5Wdakl4cQ0x57/q+C3usl15hG7KPMDZIzsyQmRji0xbE0QM4hmTZDwZ7bsQb2P/3qP77lmIOUYcUGBHyj522Cmk+0rXiW2oCVV1pakfJ7kW2mdJ+jxYRlCJ3qPi7AFwzb0kijFRZoNCw52nEgVKd45JM0aIFA4xe45iUbzZldNBpanw2e9xWbTSQiKvYAcJ3tWXfBxQ/iV+8Wpu4j1AH0hhdvo5P+PFvp4n8BaTvZKMhhcK4BnBFOoXc/rFmjemCg0XsVm7moUlRh+X1Em3aYjZO+AmVyH1Nm7zM7gTqyDvPyiVVrrYj5Vj/HYJGOMPcaFxcFaT0XpYaUY5Ws3ITu0muR3wHM+EAE3As5/gqgSnrIRR4J9bol7d8IxIj6p9SbaGDJ+kP34WkZXCEjApaWwYkTJXSNtpZ2W4IrbkHLi/K5pcfhwUcxXFW7KUMr18eVI3KeGmv6EweilwDx34hfGMhh2LFfl76BBctqYTY7nd66zpqYXVUgJBKwO/KMIo8X03xLNFjSjYAxtAuJDy/9F6MnfZTJJjtaOPVU8QgaLPN8uuBMnUgtfIzUogfvTnJKiGM5W9EgFbzNo0lTaSLC4ka/RMEAwqHX5RMKXn6crUBGYMIGnyn9p2RKcvtVGd0dzF/E3yI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(6133799003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFhQVm1Hck9Bc1hFTXQxUmMyOGNLMWF6TUg2UmpCZkpDbXlGb2V1dkpTMmNy?=
 =?utf-8?B?QkFsOC9UQjZpbndRTnEvcjVTckZKTWRIVzlkOTFDaDVKc3hNR1pFOVVORExs?=
 =?utf-8?B?RlBqQVdKMm91MU9Mb0FheGhpNUIvaDV1QU85b0ZqZHZCcEdJeWRQUGI3U0pk?=
 =?utf-8?B?YkpJQW9GRk50TkdxRVlzbGg4bUxaeDJqcUw3LzZ4Y1RYVzNYdDZSTTN3c1RF?=
 =?utf-8?B?eEcwdkhWb1FPdGtEOXkyeWpmdmhuMllnVVFJZ2JxK0lzWWRwbGdCSnJKOXAz?=
 =?utf-8?B?b3dnTXBmdFUxM0RaanNFWnByRGZVWXl6djVaRlZJTktpNVJSZDZBQzltSEpX?=
 =?utf-8?B?RFdYdTcyUG9PeE5PWE9RZjBQbXVLc3JtRzNHa1JwNzVkVUxOa3N2U0w0Z0dO?=
 =?utf-8?B?QkZoZEFCd2xlamNHemhPY3NsYkRSKzh0WGEzY2RYMVdieFVMcW1kbys2eHVp?=
 =?utf-8?B?WU96ZWZOekxITktrVGxHWVJUWWxlRUhWYWFSd3RSQzZhZVIwenE1Tm5pdElN?=
 =?utf-8?B?TEVGVGJzYjE4OWs0d1dPSk9lQy9YS2FxVy9XZ3MyV3dFeE5kdStlQVpGQnVD?=
 =?utf-8?B?NmZqMVhnQ0s1TlBhbjltQ2U5aERXV1pPZ0RqS08yTFRJMW9Vek9FQmJjM0J5?=
 =?utf-8?B?SzVGbUdVSmdEM1d2L0NFRmFISkpva3BpL2taaStiWWpjQlM0MFJZSTZ4ditL?=
 =?utf-8?B?QTkrM3I1UENBVjdxNVZyMTI1clBOTWR6Z2pKUGpyYzZmV3E1aHJsZFg2T2Zn?=
 =?utf-8?B?emtvYUlYeExXdWZtWTg0OURHdm9CNWRNdzdYdDVMMlBhQ2hXRFFBaUxWWGdv?=
 =?utf-8?B?NkJZWnoyZytlNU9pSFFSRndZWUtLTW8wT3Vrd2kyb3VPWSs4a1Ywc04xU1Fm?=
 =?utf-8?B?Y3V1TzBEUm5BYWV6K3JscEJ5SHdpZHJZRlNHNlZxeEd6SXFkM0lBY3hkL1dv?=
 =?utf-8?B?RGdMaFpXZ01JWkRWdGJuNEhheVRybXpLQk5sWlJVanJCMzdGNU1RdU9GZ21T?=
 =?utf-8?B?R2RBOStCVklhU1ZZSGVhZVJTVG1TQVdvQ3A3RllLdWlPbU1iTjdPem9WbjdK?=
 =?utf-8?B?UDdCdkF5ejRCcGdSNE9PRkNkWnB0ZU9kWGlXKzlMeHNHZzJlN2sxZFJmYy9o?=
 =?utf-8?B?Y2x6Z2l2RUd1emlwcjN2ZFZuVnBoRXZiYjRva0hjWmJ3Yys4UVJlaXpiUktu?=
 =?utf-8?B?YlhHTGx3WElxa2UvZ3F5bjNkcUg3aUd2UmJPTFpLUXB2c3dvdEVmaUY3NTRn?=
 =?utf-8?B?SVMvVVhVZHlMMHZSc2R0dGloMkJaR1R5aGxudjZMRDBFcCtydFVlMC9jd1Ns?=
 =?utf-8?B?RjJNb1ZzSDQrUkdvR291VUcrd2hXbHJXOFJqdHF4L3BpMjUwTW0ySWt0dEcx?=
 =?utf-8?B?VjlUNkJwd29NdGIyOHZNZGRGOWh0YzZITWhyako3WlJrVmdOTHNEK1ZvSnNa?=
 =?utf-8?B?UjVUbTV6a0YxTmZoazdGbElFT1cwbW5QY3duQ2kvNlJFNk5NRFFMdzRybStP?=
 =?utf-8?B?ZCtITTdYWFh3ZGVleCtEZW5vTk1HSmVUamdCUHFUK2NuKzVleHYva2JFMWVS?=
 =?utf-8?B?bGtEVGxTeGRHOUIrSzJRUU1tb1V0SFJMSXVsU3dXb3RRTFlXT2I2aFR1R1lr?=
 =?utf-8?B?SWlyVHJjcURLRHVwV3htK3YxTFRGbUtwemZaRThQUWtDeGJKV2FCczQ4cnUr?=
 =?utf-8?B?Q3RIZEdiMG5NNm4rMUZlVVhEVml5MWRiUE8zdTh0bGJOK0h5MDAvU2hoSytt?=
 =?utf-8?B?VG9oaUpZb0RoQURlRnR1SFMxVlgwbjAzYUUrbytPMTdpa3cwUWlsMFFMcnU2?=
 =?utf-8?B?SDFxTzBnUXJDd0JlQ0g2YlFCdmZmaEZ6VUk4K2NZSjI0b0dUelB0ZzB1cjVn?=
 =?utf-8?B?end0NXFaWEFnU0RpSXVZaDRLaGhhN0JpYU1lVzBDZm1JakxHT2NDTDhTL01p?=
 =?utf-8?B?OElOR05Dd251ZWVUdjdhdEI1UnVuU05IT2VRN0pLZnNVVjZpOHRYMWp3VGs5?=
 =?utf-8?B?RXQ4aW5jTko5N1RsVUZ3MEltVE40ZlFkZ1U2ZmtlMTRFR25hVjF5UExDYmlq?=
 =?utf-8?B?NEY0OWV4Ky9tMmxlU1BJdkx1TVZ1NzZ0U0REeFRwbllHaEl6blRMWXpMVEMx?=
 =?utf-8?B?cnlRMmN5U3o3YW5iblRXT08wb05taFRwMVFwK055cWhZK09zU2tYL3JPemdk?=
 =?utf-8?B?TmQ4MWplUXZRS3g2cjFwbk9jZGgwdFlsQ0pLeTZXSTVwbytaa0ovcXo2VWxN?=
 =?utf-8?B?cjRCWFcyR3VDTkdTM0xYVmNOTWNVb3pTTkZUNlBzdTg0LzZhS0E1RUczdG1W?=
 =?utf-8?B?Mlp4aW80MmJ1U1RDRVRkam9wWURnY3JqRXdEeUFLV05VNmVFZ05Kc2hWMjNv?=
 =?utf-8?Q?9NNiWvX6tGiM+R1M=3D?=
X-Exchange-RoutingPolicyChecked:
	c3cO6Vw5ZDlucT6jrEPr9bfZuBmE0Dc8RYO5o+Aw4yqi0W0NrxQMC4edVmTkh7Ax4d7NCipRlt3urWGwcyzy3KbihZEPRiBs1RY6/7NzxpXyUFXKCtNDqORzgbVX6O9PN9gl3Z+bICujML/du4OQgHMO0dBOMgIrO86hE/VL4KWZi/dKBFG67ZwOOo67ELbIWGe4uCEDV3wHr/EZ5/Hmx5qJgJ6fRWu4E9kI2PfjUuwJqepDoCHUA3Tc9trDTkJJ0yg/WLonumXfhpuXOOR3WbZyDX43S0tMLSCHa2VAFvPZwzVJri7FBzi4di7r57gW/aXToKgZWAN6YLVS/Gpm5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EE3vcK+FTzQK74tf+dpPWYkiKIDNpLls0JVv6ktUAGM4394lqzR9JRmOfR/o29dqQDKaynB1N2J2zKYbwYmu/cIW4N+dswZVWQ3gNBs14u3XAdh/8218QB2z42luhzqKYZKTIBzHHiwQJAPbJ0tKTwtljaVhEe6bnP9fcDdcl2RpXW/wdrdnlZYxKqHi8Dxa3BFFQOK095XXSfCUY/SrR0YHS+TOmyB15XOUdbsnp4POkeXsKWVD+6iPETWMw6LzrNKShxG1ptWpTBM9BK6BAUfQfuA1CsBIXevKx/R38jAMoY4l7mtAFOxGXD1yo9dVccYnydIAAujP/bO2PPWZR6HpvrnebyxHLm6DCz1nep5PIGzEcfg97jc9RqESjBGM6uqqT/QWyP8+ZCLF/fUNWD+vteN4tCwiME0855++hVMwISZORWBbWzVcBiVZedETuIk1crVmN5rJdhc1D5A7Yo/+gWM4SbjBkayFjdFH/Qxr+AxR/yGm4sxNTSbXKnwdqOPzlhiepI5BkLcdiZAMbbdelwsRfOWeLRuuuZvAMK+WivWoR4dne6sIZe/wabvEhg2vg7DGA47YfuOCBJta1ARaa5T1CuCTp4EEavQnj4s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cdfaf93-c185-4b22-dfde-08dee9b20ada
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 18:33:23.2583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKTzF1A/IuLawzUgm1v+CkqEO8x/9HtOHpeeLKCU1PXLId5hTGRplObV/Ku7F/fLEAqTzWE/VGikzbY5BG2hGxrvBafXSWO/DYhrkM/oN7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB997799
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607240167
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDE2NyBTYWx0ZWRfX2PVMjUaH/5yK
 uNsFxg2AqIeWsnPMCuGERdXjvCOOZSDumbO39g7bStznzCZol6qDrrrROUFqRv0TJ8Rv74fKeVt
 oK6g37OuKKcubJYN0Jav0nVdybrE+0Aa++m2bIsmiSArOKayT7Jl
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a63affa cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=Byx-y9mGAAAA:8
 a=yPCof4ZbAAAA:8 a=4vtDQnBxikGAnqUNXEUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: mWG-69H36lnzCBOuVhBKtJT6aWRt_n2W
X-Proofpoint-GUID: mWG-69H36lnzCBOuVhBKtJT6aWRt_n2W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDE2NyBTYWx0ZWRfX96ex++zjVSmn
 UsncVkYImFAgeUJr4cL+kpASp5Nj1PF2syyneKy3SI3LTTCqJ5wsaEqLg+rL3X7xSRur3aD73Fd
 9HHpZCM0ew+AnvxKN/orHVM+qLYf28vv04PCiH/4w55lat1lmCQQS1HSVsLjCcxjGkfDkvRK1aO
 fBZCTqR51L25zqqdYGOl/Rk8lMCkxVuPeuXJwjsKOqefHlcC8lQHTr8GgNLPAJAGE6ujwVG4bkj
 b76f5tzFLyxhsUD4gsJKzLrciX51fIs8TyrZnvAV6fIOAfaPVYtw84ZVLuHrYkm2PNVOLm7cHLG
 APFCY9/RqWf88y69R8Dh0cwjg+2dXcaWIzr99onqOqncnsWGmUwIDAZ1WdWawKTylh+vST5GscS
 XxIdRktkHjutza50qTwvZS8bdfOofPNn53DQ2/y50Hj0N4e1RB9x8lEOalQxO9XXPz0vPZDsIjU
 8GDL9qnrNCtkfUix6mw==



On 7/24/26 2:58 AM, kensanya@163.com wrote:
> From: TanZheng <tanzheng@kylinos.cn>
> 
> In the iblock_execute_pr_out function, PRO_PREEMPT, PRO_PREEMPT_AND_ABORT
> and PRO_RELEASE all perform callback capability checks through
> ops->pr_clear. The error check allows unimplemented hooks to pass through
> the gate, resulting  dereferencing a NULL function pointer.
> 
> Check whether the hooks that need to be called are supported.
> 
> Fixes: 394f81184882 ("scsi: target: Add block PR support to iblock")
> Signed-off-by: TanZheng <tanzheng@kylinos.cn>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
