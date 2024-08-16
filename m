Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10261D69E;
	Fri, 16 Aug 2024 08:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796527; cv=fail; b=CneB1TycQy9GHx29SxgFCaTs6uNNjYeyjBgb2aG3602ms/SRwZK4qsIAqkrQ9fwknUIfoLFTvceq78hvoPa9I3Kjyx4Np/HN7jbRvTv2CFllxhvlse2528ij2rKEz3JQhWuioEmxkoxin2hM0zbaqI/K3Pz+nBa2wGjZHYj37dA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796527; c=relaxed/simple;
	bh=ZZknrfS71S0grFwDAgUkGBIsjHLHecbEWI32NTlw4rs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nLTf7PlBNVPlRzlrsWAf9H5a8vv6NSvOGogCrNYfEapKAlww2FfkLIbIBhJrh/Ty9aNZ1M7b9327OMYO4m25+9J+4gMVTEcCmqaSpXx9uQ8nSBcdFPaNfbuP2CJGwflix1JdU8G4Bs/ViJt/aepQmJUZhOdLxkre8Ayu030qBMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KKsP3Pu4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BGjGLpKr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KKsP3Pu4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BGjGLpKr"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47G7tYhS003448;
	Fri, 16 Aug 2024 08:21:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=YbTH8AWHe5HdqkN7n1it9utR7A9ZuEklT4OWMbMa7l8=; b=
	KKsP3Pu40Ie6TvJsoXpXUOdeif3IG2oooR4ZigspdnJD/IkrEsrw6lhxkxz+CeBS
	E60+Z+QF8fKt0nF0MhmK6AjDpxlmOgSlJNgwT/OmW2NHvnFOBmL920ABqzkXBZmi
	3Wxt81Mp9Se4l6ElV0YhMns4jIGHah+KD8Ek7eD4o1XSRKTkI0XdtTkPxCpmlS9P
	PW1elPQ9JmFmoAZ4BOWrLbfBVMAXuJ2ioRj3WCa00mk4GzKLymWeH2vWFzepm/fg
	AzCA44dpi72k3XZRAfdAIeWVcE4OcKgKmfYJ/xFA4gCz7ZLzFg454I0osX0++KO0
	m8Dvuoym4L6GlNN0qV1ifw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxmd3yyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Aug 2024 08:21:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47G7Lhpn010594;
	Fri, 16 Aug 2024 08:21:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnc4xnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Aug 2024 08:21:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sEDB2K9DAeAG3d4ihRlPGHIWHp7E3N1s6nPcfD4Bk6BHphUg35+dMTnU5bBycpsTgxR+JNihhMvMr/RlFRAyhCg+E694N+GRXuARW9Uu6bZI8GhAjr2RxZQ12PQu1RZIA+jvX8p/XAkSYOONWTiSxNycFHGUnlsBQMa6hc6Q4h7JCIetKignI/gFvCwSGpzoo5e8yUKLgqcZTRVBKKsi4Bex8owlEcjZ2HE1dg3Nx1QJkH9tv1/sJXSJA64Wi7WxwQC7+bsHutuDF2//fTPbvmelnb5rxPBMM57hEq/ki80UAK7+Az5L+L19EFtEnYOo12qFCrbkCJ2lXg14aH/bBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YbTH8AWHe5HdqkN7n1it9utR7A9ZuEklT4OWMbMa7l8=;
 b=Nlsh3cuG8fSdXuDej3TcRvxfhH55+UUnA27po4Cd7MequV3cGc01l6nhx9ccgtjg9IYzqeoJBfPMt51Xq1Qg5OcKD4VUwelymO91LW/fbe2MH/e7uAIU/MZKekhiyUTDF/3mdinVORs70Ohw29WognQE9Mp+2FMOtsgY+vrJYrldskObMr0goeMBuL9m0+xvArmyu/i38nx0cLg+xMmeZcMaHdzWtUrYgQsDJEOSk30HKLrGpUyZHVebFwRy0GWy3r/t/UnN1wetK7pTFZBKXrZd56B32ggwLKjwGSAk5S1W41qADb+rh3tpK8sLBOLU1fVI+3Dzr7fFgulv8ta+cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbTH8AWHe5HdqkN7n1it9utR7A9ZuEklT4OWMbMa7l8=;
 b=BGjGLpKr1KZEHB/+dPSyH4TYsgti8t8Nk+OYB9M72AY2GddRlgbGo0q9Od/JBSPLFGJPMg7S2wMKnOxfiuR73dX08b1BBaeu7MJGIi+1DExIYGSEuxAnmBv0G53Clr8VtJ6jENMsCh5sgqK7MN6J9YAjSVo2H/v2DvzaiWFpUk4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5776.namprd10.prod.outlook.com (2603:10b6:303:180::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.11; Fri, 16 Aug
 2024 08:21:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7897.009; Fri, 16 Aug 2024
 08:21:55 +0000
Message-ID: <1c03c6bb-b05b-4052-8a75-c062ce3af28e@oracle.com>
Date: Fri, 16 Aug 2024 09:21:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] critical target error, bisected
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: fengli@smartx.com, hch@lst.de, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <Zrog4DYXrirhJE7P@debian.local>
 <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0110.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: 30890328-0f58-46c4-2aea-08dcbdcc7d07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEdCd1RCTkxsbzl4TTYxdEhqZS8rcHZucThHbittbEQyOThsUksvUkJSOGdw?=
 =?utf-8?B?WFVNNGVLeEFBN1lzdDJKSGt3eksyM0YyTVJUY1gvcGU5NTYyY3JobnloaDZ6?=
 =?utf-8?B?TkY0V3V1QWE5QS9JSXJ5OHhDUjBBcmJHbTFuV0huOFBtbjBXdEJmcGNhb05n?=
 =?utf-8?B?dElYd1h3VG56c1I1VWcxeXFMM1RnUktrK0M4aUpuQ3RyOEJpUFhNWHFNTVNk?=
 =?utf-8?B?anRnYlh2aUpydmFyaCtzOVJwVlhvS2Vzam9laEdySDh1Vi81cE1IblFsWkxE?=
 =?utf-8?B?Y0Qvb2FNdkliR2FYbXgvQVdIdmVRREN4azFueXdzcHlLMDg3azhSNkl6NjAw?=
 =?utf-8?B?WGdEZlpjTlNiaDhVdUxjVlF0ZGZ0QnlqNlJHRmVRMXYxdmxzMFNnQ1lrOGZM?=
 =?utf-8?B?VDlwSzhybTNnalYyMC9FLytmRklzSFNUTXdSdmg1ODNDejVDRzJYV0VRSE9R?=
 =?utf-8?B?SCtsVlRpMVM1MEQwNjhrUUw0STRvb09JQlpONHplQjZ4UDhmTnd1cU9pdUZH?=
 =?utf-8?B?UWUzZTlnUkdUajBCeFA5cHVNd3hkWUR1cVMzOVlnOVUzMG8xR1BsS1lDSkF4?=
 =?utf-8?B?djVUOWtiZSt5c0JwczROM3VGSHdKTDZ0T3FQSTBGT3FxOWJRcnNTT0svcVRr?=
 =?utf-8?B?c0FoT3BTbHh6bTd4OE1LUUswTm9reXVKVVlzTmdweFRJTkdncTh5RjE2Nlo4?=
 =?utf-8?B?RFJxS1doQU9zODY4V05uNDZjMnFlZmZ0SVRWWEZPNmxzR1VkaFFPalYyQk1v?=
 =?utf-8?B?Z0d5ZjRjS09RYWVDSEtiaVRwc2tJRVRIRGllYU5TU2x4WVRQOXVDK1cwZUVw?=
 =?utf-8?B?RGNVOHRZRVZEckp5a05GMjZEZVMxOGQ4bGR5Znd5bE9sWmpOdjZ6Y2NwcVdl?=
 =?utf-8?B?dkZYUndoUnNJRjFGRE1MK2Rrd3lhdWc0SEpzeko5bkpzRGJ0NU9kTFFkaVRr?=
 =?utf-8?B?NGRLaERwMlN1S1h1OGNTUmhwTnRxaGhjTnlidHVnTW03eXMxUzlyaWZQWTlV?=
 =?utf-8?B?czdrRzE5Z044ekdWMGQ4a2dFQkRoRDZZV3JpZnZMcy9Sb1RxQllPM2gweEJw?=
 =?utf-8?B?VlRpUTk3alJoT1h5YytkbmNhaklPMjZEVUJUcHprY1VZWGZ2aWcxK0lvOWFV?=
 =?utf-8?B?TXZtc0pyK3lDUk11bWg5RnVzTU5uVVF0ZTY3b0RIMVBFQ0YrSEI0cVNUczNV?=
 =?utf-8?B?SDdVcjI5bDlSQjBkWVJjWGdoeEdpY1dRaFRaTkZ6NEYvU21scmJsNmN2QWRu?=
 =?utf-8?B?R2dPcG9ZRjdkejJQYkZTOFcvNUZPT1V2M2ptKzVGMXhtUTQxbmtJejFkb1R3?=
 =?utf-8?B?MnRVdThqQmhSdmZYekpERnMwYVJLT0VLYU1TbURMTmlTaTZqRElUcjRTTHpi?=
 =?utf-8?B?NzZtSm1sZWdvR2wwWm5GTVJnQzVaY2FZZVFUZS9BWEdaVnFGemVXYTdZOEJ4?=
 =?utf-8?B?ai9HVEZkMVp2RGozbmV5QUlWcGgyWk9DVzRWd3o0SzBSVlBFcmZMbXowd01h?=
 =?utf-8?B?ME5VaTZ5a28xbzBIdjVwOTQybldFOVNpL1Jodm9VbkduYktDbDNUME9OeHpn?=
 =?utf-8?B?cjVoWnd4VmVNdDlvbjhRbkVPeERIR2NSaW5rS21IZnU5aGlTRFBRcWZWWUw2?=
 =?utf-8?B?UFRCQmhQZGIxaU1LMWJBcHlWaSttODZ0c2NHUVp3L0FNSEdXN1IydWloM0s4?=
 =?utf-8?B?RnJ1cmRIUjJ5b1h6NUNmRWF0clJ4SWxtOTZTbWk4aFB1WjMxQlNtNVRaSHd1?=
 =?utf-8?B?dU44YUlrcWJVVlFPY05QS2pwRExtYlpaajlpSlQ3bWE0MmFaRldMWGZHVVBt?=
 =?utf-8?B?TGVESnc0NzRaVWhScm44QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjQ5V3Znak9BNVRTTm5ZUmNMdzlzbHZaNExWY21namJpODZDdTN0RGMzbzZ6?=
 =?utf-8?B?UW5qSC9NNzBDdnNSaXJXcm9OZ1JLdHdFcXRtbmFyNHh2azJHa1hWeEdJTkgv?=
 =?utf-8?B?dFdROC90b2tHZDVPVWEyTldBYXR2SWlSZXUrT0tTTDc0aWpGSkdrNzBpdVA3?=
 =?utf-8?B?SVpiKzNUbjVJTXNGdldYNlgzTGtxUHplSFNVVFI2aGlRT2l4cFJERXVDOERo?=
 =?utf-8?B?czlPYUZ4bzRabWNRTWFQbytvbUhDVFVNcG5JVk40SngwZ0kyRjdOZ2ZvM0FH?=
 =?utf-8?B?d3BUK2tLVmdSOVFxQ2VSYmcraEhDRERHVTVtV0R6enRtbEpQWFFRM2t6dkZw?=
 =?utf-8?B?UUw4VjVQUHNUQlYrdHo0Z08rbEErbHZMNXNvZ1pET0RkZC9kUTJlQkhIeU1V?=
 =?utf-8?B?MXdHMkdvblAwK3hHcW96Q3BpR0I5Y3RVbTEzM0tldGlTUUd1eEwxRlhTdStP?=
 =?utf-8?B?eTAxRG1TUnpSeHdxRlRkbWZkNjJTTFRPZXJxN3REdGZ1eTMvbStSalA1aklx?=
 =?utf-8?B?akJBNTlrSlh5b0JHTWNjM3VTMXFsRmduNnBrWGhLL0VBdm1YSjd3S0dYYU1O?=
 =?utf-8?B?UVlweWk3NUtIVk81UlMxUk50T3V5cm9HRU9Ra0xxVENITE5zTSsxYXAzMSt4?=
 =?utf-8?B?TmhvQzduWWlpT21GMmxPdjdtTFFaNDlNeEhRNlh3SlRaeEV4bC9LWm4rWkYy?=
 =?utf-8?B?TnFucklxUTEvLzhzQ01XTXVKd2NFYTVhcW5Qc1RIR1Y2aXVRSysyZjhWZjhJ?=
 =?utf-8?B?cDhsYWY5dEdUVUE4dkJzR1ZrS2E3eFRFZ1RZOHpScElTdkdGZFhUME5EdlFJ?=
 =?utf-8?B?a2NHQklnNHFWZVZGT29YZ3dYbitJY1ZlQit1c1dZY0NwTnEyVUdhZXprYkRr?=
 =?utf-8?B?V1hCY3JPTVArd1NQOXh0VnZMNWpZUy9QV0pCQlVjOHFtZnR6T01RdUcrUFhF?=
 =?utf-8?B?Vzd4UFYrYURLTTh2Sm9EUWRFMVdOU2dsZXlsSFE4NGJncVh3TURha0daVC9w?=
 =?utf-8?B?R29jRnphelIrR21HSHdaTFdPTXRBVlNLQmU1cGZDd2ZiOS9DV0psQkRPUHUx?=
 =?utf-8?B?bG1TYnVnMmlRWkh6SWhQdXJxWThsZjlod0pUc0hzR0dIL3F2d0tTbmQ2WFVv?=
 =?utf-8?B?RytJM1l2Z2syK3RqRTFhTWFsYXZTMTVQY3ZOREpMbzZDYU1VVml5V2o5S2N2?=
 =?utf-8?B?d2tzM3h1WDgxQVNybWNvb2hNMlpqRXFkcXJkb0UrajBEakc1Qm4zNW9uYTJk?=
 =?utf-8?B?R0lWTm1qYWU4K2hLdTZpUFNZTGlXWFlkL0QwcW91ODIyZWFoQTUvSDZjelc4?=
 =?utf-8?B?YmYyeERjU1BEa29zSGZmRVlPVnRnVGFqTmtOeHRyblBNQjlOalBSRnNjRFdj?=
 =?utf-8?B?a0NZWk5PcmRHTWpOK09CQ0VmZmo0VUkxREpnTUVrVFBvaExMMjFEOUZwaWtK?=
 =?utf-8?B?R2daaEl0QTNZS05USHc3UVYwRHhmOHZJM3UrT2ZwN3RyeUl4RFlQb2U4aE1Y?=
 =?utf-8?B?YTB5SXhDd2Y2SFA4UXNJQzFoS0R3Q0k4QlNnUU9zUzlFSG00bnUzVUhkNlVC?=
 =?utf-8?B?TmlWWlFPcWprSTc4dzJpTG9Rc0NEQ0VzMDhDNlR4NWZtdmxqSDlEejU4eDhN?=
 =?utf-8?B?MzYxaE5ZMGVrNWtmWExUZDMzR1VucWpCWDhVUmdvYkdUdjZTYng0ZWg0VDhH?=
 =?utf-8?B?MWd2QkM1ZGV3QWxJeStvbGd5dFk4QjRjODVoYmk5Sks5UUt5WE1zZmhXTGxM?=
 =?utf-8?B?WXlNckQ4V1ZJSFRHSW5jcmNJVXBGTy80L3pIZHNyTGkva2V4eXh4aGZETzMx?=
 =?utf-8?B?VkdlcG1QK0FoaDEzNVgycTQxSHJWK3JsZjRnZmVJVjlmdWhHUDBkRzlRdWVx?=
 =?utf-8?B?VlFzMFM4cUc0OEx2M2EyaXMzeVA2aTJFR0NMb21ncHJLOS9SMmlML3JYTldr?=
 =?utf-8?B?Y1FoL1BIdE1qcXFrV3BMaWNRN05XNW5Hd2trSDBDZnQ3SHp1MkpUbW4zaDRM?=
 =?utf-8?B?ZTM4SDlITHg5S3N0NWlMS0pWZVZxTDROeUVtYW5WQ1VlbVA2VmM5YlpwOVd3?=
 =?utf-8?B?c0FXWTdGS1V0THhSM2xiQmpDejJlNHlKQW9IZU8xN1BBUzk3dGdKUFpocDU5?=
 =?utf-8?B?aFl0U05QZUVuTTNMcWVHV2RIZGlxMGhEK1o5UGt1VFpYeTFKU3VtTGVMeEhR?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pqF+HtWJxeWx/71iKAgpNalLrLLvxi5szCcMa5X7SZzepom9bzocwv59UnMtyRDCJ+DA1hpc+f0/yEuYV2kQ5GrrflwDLD/SFJZlqlSDdziI+XflphEBUAN4k8anmYHkTqX4zdwZpAMghpBTlKG/Z9H6dm1StxEfz1wnCYdkqLfrToiBlbnYaEimPT/cbV6zQb0qOEbwFBnBUO0kvhkK1LbFPLXuQFMD3B3sCe5KQHG/zP7KRzxvU+Rl3gZZyFdSZQ5MRLwPSr3NSiUe6lKGXPnusK7/z7PEY+a8hpTRIDX2doVbjQfziA8mQ/41fiNIG6xGlIgsGQZxtvPLVITIXeiHThDaLxRimj39Ak6PGPEdxVEP3UVa+ER4q5MKkcEyxspyMjqKC4uJuYxgJkdrIAIXJtskkTPzBIB6WkWEeMuIbDccB2Fa/KJ+J2IMMzK7+Ua15LzYQ9YJ5M8lDjkMxV3CyyfmEoPcrKmRAHh7moKQzxvomCXNx7yPKLN4hPHWP/kIIaktWgjBSHZoiGhr5z9dIIG3Q58QbKfv//nzfmzhqNtmjFjlrnKHCVlysWQQwIyHSoDuCrqLpDCQ6odehKclVvTTIl8Q7b6ea3lrNZ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30890328-0f58-46c4-2aea-08dcbdcc7d07
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 08:21:55.0467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L8eOsAn2yb17Xasgara2CFSfS1n4U+XIJo78F4Gh9oJs8R7KcLrJvSCAfPRVfz+nzOwQILmrE+nc2F4rI7U+nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-15_18,2024-08-15_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408160059
X-Proofpoint-ORIG-GUID: sQPHMSFwQKyyafh3ko4y3NcsU3t8YhDY
X-Proofpoint-GUID: sQPHMSFwQKyyafh3ko4y3NcsU3t8YhDY

On 16/08/2024 04:56, Martin K. Petersen wrote:
> 
> Chris,
> 
>> [  195.647081] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> [  195.647093] sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
>> [  195.647096] sd 0:0:0:0: [sda] tag#0 Add. Sense: Invalid command operation code
>> [  195.647099] sd 0:0:0:0: [sda] tag#0 CDB: Write same(16) 93 08 00 00 00 00 04 dd 42 f8 00 00 2d 48 00 00
>> [  195.647101] critical target error, dev sda, sector 81609464 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0
> 
> I would appreciate if you could test the following patch.
> 
> Thanks!
> 

That solves the issue I was seeing on default scsi_debug, like this:

# mkfs.xfs -V
mkfs.xfs version 5.14.2
# mkfs.xfs /dev/sda
meta-data=/dev/sda               isize=512    agcount=4, agsize=22400 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=89600, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=1368, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[   29.399767] sd 0:0:0:0: [sda] tag#166 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.401463] sd 0:0:0:0: [sda] tag#166 Sense Key : Illegal Request 
[current]
[   29.403072] sd 0:0:0:0: [sda] tag#166 Add. Sense: Invalid field in cdb
[   29.404076] sd 0:0:0:0: [sda] tag#166 CDB: Write same(16) 93 08 00
00 00 00 00 00 00 00 00 00 ff ff 00 00
[   29.405344] critical target error, dev sda, sector 0 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.408127] sd 0:0:0:0: [sda] tag#167 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.410054] sd 0:0:0:0: [sda] tag#167 Sense Key : Illegal Request 
[current]
[   29.413442] sd 0:0:0:0: [sda] tag#167 Add. Sense: Invalid field in cdb
[   29.414552] sd 0:0:0:0: [sda] tag#167 CDB: Write same(16) 93 08 00
00 00 00 00 00 ff ff 00 00 ff ff 00 00
[   29.416241] critical target error, dev sda, sector 65535 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.418022] sd 0:0:0:0: [sda] tag#168 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.419604] sd 0:0:0:0: [sda] tag#168 Sense Key : Illegal Request 
[current]
[   29.420826] sd 0:0:0:0: [sda] tag#168 Add. Sense: Invalid field in cdb
[   29.421978] sd 0:0:0:0: [sda] tag#168 CDB: Write same(16) 93 08 00
00 00 00 00 01 ff fe 00 00 ff ff 00 00
[   29.423591] critical target error, dev sda, sector 131070 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.425301] sd 0:0:0:0: [sda] tag#169 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.426856] sd 0:0:0:0: [sda] tag#169 Sense Key : Illegal Request 
[current]
[   29.428020] sd 0:0:0:0: [sda] tag#169 Add. Sense: Invalid field in cdb
[   29.429329] sd 0:0:0:0: [sda] tag#169 CDB: Write same(16) 93 08 00
00 00 00 00 02 ff fd 00 00 ff ff 00 00
[   29.431314] critical target error, dev sda, sector 196605 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.433681] sd 0:0:0:0: [sda] tag#170 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.435182] sd 0:0:0:0: [sda] tag#170 Sense Key : Illegal Request 
[current]
[   29.436328] sd 0:0:0:0: [sda] tag#170 Add. Sense: Invalid field in cdb
[   29.437372] sd 0:0:0:0: [sda] tag#170 CDB: Write same(16) 93 08 00
00 00 00 00 03 ff fc 00 00 ff ff 00 00
[   29.438895] critical target error, dev sda, sector 262140 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.440572] sd 0:0:0:0: [sda] tag#171 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.442080] sd 0:0:0:0: [sda] tag#171 Sense Key : Illegal Request 
[current]
[   29.443277] sd 0:0:0:0: [sda] tag#171 Add. Sense: Invalid field in cdb
[   29.444353] sd 0:0:0:0: [sda] tag#171 CDB: Write same(16) 93 08 00
00 00 00 00 04 ff fb 00 00 ff ff 00 00
[   29.445919] critical target error, dev sda, sector 327675 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.447607] sd 0:0:0:0: [sda] tag#172 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.449145] sd 0:0:0:0: [sda] tag#172 Sense Key : Illegal Request 
[current]
[   29.450327] sd 0:0:0:0: [sda] tag#172 Add. Sense: Invalid field in cdb
[   29.451447] sd 0:0:0:0: [sda] tag#172 CDB: Write same(16) 93 08 00
00 00 00 00 05 ff fa 00 00 ff ff 00 00
[   29.452995] critical target error, dev sda, sector 393210 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.454712] sd 0:0:0:0: [sda] tag#173 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.456199] sd 0:0:0:0: [sda] tag#173 Sense Key : Illegal Request 
[current]
[   29.457409] sd 0:0:0:0: [sda] tag#173 Add. Sense: Invalid field in cdb
[   29.458486] sd 0:0:0:0: [sda] tag#173 CDB: Write same(16) 93 08 00
00 00 00 00 06 ff f9 00 00 ff ff 00 00
[   29.459836] critical target error, dev sda, sector 458745 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.461266] sd 0:0:0:0: [sda] tag#174 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.462608] sd 0:0:0:0: [sda] tag#174 Sense Key : Illegal Request 
[current]
[   29.463791] sd 0:0:0:0: [sda] tag#174 Add. Sense: Invalid field in cdb
[   29.464854] sd 0:0:0:0: [sda] tag#174 CDB: Write same(16) 93 08 00
00 00 00 00 07 ff f8 00 00 ff ff 00 00
[   29.466695] critical target error, dev sda, sector 524280 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
[   29.468364] sd 0:0:0:0: [sda] tag#175 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[   29.469774] sd 0:0:0:0: [sda] tag#175 Sense Key : Illegal Request 
[current]
[   29.470890] sd 0:0:0:0: [sda] tag#175 Add. Sense: Invalid field in cdb
[   29.471867] sd 0:0:0:0: [sda] tag#175 CDB: Write same(16) 93 08 00
00 00 00 00 08 ff f7 00 00 ff ff 00 00
[   29.473323] critical target error, dev sda, sector 589815 op
0x3:(DISCARD) flags 0x4800 phys_seg 1 prio class 0
#
#

