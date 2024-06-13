Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC46712FB2F;
	Thu, 13 Jun 2024 15:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718293615; cv=fail; b=gY1hDFTLsODEiQy0POSlZu6RYup1TI0/RCalk6qF0dffGFKEurvDtFgCsnzKREo2kCDSxqNulS6yuDyWd1c1zpuZbX6AdN8xzcar0UaY/dCwFg6aJukbyNJEqG01RW1/zv7veKMeoPTSX1+Owu6ae4B+rctIjcryO5qaBX701lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718293615; c=relaxed/simple;
	bh=m9CFbCQsmyWUiajT+E6TzD+WEuqOQ0fQNaESRapZ5eY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bHve/25Bjaadb75djh5V9VjD6d18wBMXNZVwT6u01CmIMxhOYuMCEIvsVwf8QtuW9l7oeemFu0FEEW7Z7EhPy9wYB9DE8vyzVsqYZ8y3YFUr0a37LvheDPPdqP+AtkCmlte2SK7uzQvjZ387RTtV0faKWjb5myJulc5yuyZNNeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Swn9Doai; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aAg6ShWz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Swn9Doai";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aAg6ShWz"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DEtRmk004351;
	Thu, 13 Jun 2024 15:46:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Ka3kkP+mnEprTBovvfhpsLm61xc26jixGtpIJJpWLM8=; b=
	Swn9Doaiz2w/DF/hnDE2E8OGr65IYwyAUhaoZLzo585Wvs28wSMza89sd733+Qxt
	VYUlyFzdCOIjN3b69norpJhq2IEPMYKsY8921gv5Vl9E+KzWf0oiygoomFKJNJ3c
	e9h2Bnvoqa8NYwQvhuZMqtv0Y8mxf18W4No0Tv4kt64UuLLxpdba8A2UTPg63GBl
	NBCIKxEVEyHuuVxznFniyke1HXLMLlH+sWqzWlXKsRHiGpcAArjBss7yPb2/NjSv
	Q8r5iDpL6xkmOklL34GN4Z4vZxN15NeuLf9llRn7TnQRRQg+OXnSeRsmk09ers8e
	9IqO2CvLvZMRan3mTJgrsw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh199ua9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 15:46:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DEtOtw036760;
	Thu, 13 Jun 2024 15:46:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ynce0eq6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 15:46:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jREKJIuJfC0GvthpmmfjJ1nRDidDJhejcV4v6deN87JT8f0Jjqxb02OsnHUcVb6kaCC7W6peeCLAufekibLWnPc6b8EDBLZVDslH41/AVC1Jx/L1xUSr/RiC8Z7e+ax7sBBea580VKcrSQBFCD8hyTK5rT4DTflhF+D/emh0R+WXlg7ngZW+ZLadb4LsMdRRk0QRJzTB0TxgwWR3VUsXCHT382/17048D4GTwJdUYKWaEtnijWLIDiprZkHAQvbeV4IvRr4Rx9c7BdHVRvZrLQbXYIrw7g8ixS5OVjpUICppGJl81Njth07cJik76fkCrj4jwV0OEgrDg9UpgmJjLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ka3kkP+mnEprTBovvfhpsLm61xc26jixGtpIJJpWLM8=;
 b=AryKbZQJFOAB5j0vOdEH4qUfswfQ1aIccSQAbU84/BPCfzTbnExVAQbuppuqJSLGn7wDmRNMTQDMUG3hKhsWrOUNZ+kXrAcArBkApkUBYbGo1qGxsKtbWByr/5/FxlzcPdvBGQ7si3KktENdnIxDPOZVUiVAEPIwYBn1tor/ar5kRWtUGfPMAQuxJ2xlp4uDt4EKIlVbqJWKzjNv7LrFvuj9+ibSR4qWleUgnp6J2fcd7wgGk71ZcDV2rDstYN2KVAfipJCCBYDG2tiPxXirdY6P9F02deG2J+D11Njn9wRaQc8YIjgUL0mKSD+j64/uWjz0ETsSIEqeXlQHkFzLxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka3kkP+mnEprTBovvfhpsLm61xc26jixGtpIJJpWLM8=;
 b=aAg6ShWzOpciKhi4q3IY0GN87VTD286GAtPR3Uu5qO3qeIrIAMfNNEH1xnHsuqNIZ2ZWZx7W0fOcxQiu1I4WbpX4J0rW7kQvkfqOgHUPFMWof/01e5TLJOVKxkdfDcO9sJKiUG/g9hHZ+5HCP5zxCHniZ6Tz6UYnIIBNtS006aU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB7462.namprd10.prod.outlook.com (2603:10b6:610:188::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Thu, 13 Jun
 2024 15:46:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Thu, 13 Jun 2024
 15:46:42 +0000
Message-ID: <5ca4b94b-8695-4355-997c-3f531d8b8702@oracle.com>
Date: Thu, 13 Jun 2024 16:46:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-8-kartilak@cisco.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240610215100.673158-8-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0273.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB7462:EE_
X-MS-Office365-Filtering-Correlation-Id: 853d6e45-aab2-4bb4-f0db-08dc8bc005a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|7416009|1800799019|366011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?VXYwTDJFSkFmV09zYUZEM0xOY3c0UzhtcVRTTmt6N0luQUdJaWVxYXBaU3Q4?=
 =?utf-8?B?UlRYTEFlOTl1ayt2Mm5SUTZLbGdJcTUxS1l5ZDdES1kwUnhPc2dUWTY0Z1Y5?=
 =?utf-8?B?a2d6aW9KS3FMRnBRbkFaMjg5WVd2Wkw1bTVpSUpQcnZJazhHT3dBdWg5RUx4?=
 =?utf-8?B?T2F1dHQwVnpvbnBZSERjUEdVVG1BZkRsaHdmdmZaaTRsWTNvZGFjbWJUdzdL?=
 =?utf-8?B?aXhiemlRdUdlczJmS3YwUWhxRDNzZElCOW40T2Nsc1d6TVJTSWFIKzdvb0JF?=
 =?utf-8?B?MjNybjRMNG9pWTBQZFhGb05IdHJ4Z0xOWWUvLzNlZGVJR1RnaC9OcGhHZFp5?=
 =?utf-8?B?dUxDSjRkWUVJZThYWkdZNDhqQWEvaEY0dUZYUkljdWZWOW1EK1lkbkxud29m?=
 =?utf-8?B?Y01SaSszTUdNeVBvTEwrc0p4MmpFdTd0dmZtK3JsQlROY05EUDkwTmdxUW9t?=
 =?utf-8?B?Qm5xNUtNL08weVhXS3AxZHluZlZSOW43WGY3NnBWaGRtcHV6TDNPL2hYQlJx?=
 =?utf-8?B?eTVHdVo3MkJCT1F3enB5eTB4WEYrdHBtbG5Lb2V5dXYySWxMeERnb3lJaHdl?=
 =?utf-8?B?ZWFmQzd6dVh6VTRjNXM3M3hxcXpDMWp5bDE3YTRacm9MMk1zT3ZnNjNZamFn?=
 =?utf-8?B?eTJYUDFReXpwSXp4WnpqL2pybXYydGVIZ0diajFwRXF4M1NCc0k5UjN5NzNQ?=
 =?utf-8?B?L0ExeFN1L1pFSXJYYzNnaTI2OWRuanBmQWxaL1NHbFBVdVU3STFOM0duTElR?=
 =?utf-8?B?OEtxTVYrY1E0VERPa3djWlc3akQ3d0dVVXJlQ1l4MFRKUDVIMjBDWHJoRlZL?=
 =?utf-8?B?KzBScnVLOFVnWXpROGFJa0Y5UzA0SHJXSnA3aWd4R3hyTWZMWmk0S01zRmVa?=
 =?utf-8?B?TU1VMmtDVUNXVmt4L3RibUZMaWNTQjNTei90cFFjTXkyNnIzSE5tME5MT0ZO?=
 =?utf-8?B?TmRsYXlyV3dnQktYZWY1SXFTWEdENHNoU01NTVUzbUFFTEtGMlV3WFJKV1NR?=
 =?utf-8?B?Q21xK00yOVFTVlY3Qkc4TWpxeE8yNnc1YlY0alBZR3VRV2l2SnNSVCtqY2No?=
 =?utf-8?B?MVZkK0l5aHpTYkh1eUxQb0REZlFtWUEvZXNteVJLWWU3RmFPZm1aQUJyaEZk?=
 =?utf-8?B?TnFrd3g5Q3hvTmU1MGc5K0FPNlRJUmtudlNRQ09PWm0zanBGenpBaHNCM0gw?=
 =?utf-8?B?T2JSTXZvbUc5Qkt2NmJlMUNwTGVWWGZRMFVpQVJWS1hHeGJXU0w1U2FqRlJr?=
 =?utf-8?B?QlF1OFZ6QU9MNWJlOS9iWC9UZUNUK0RWUmhOMnF6WXJKUHJYWHdRL3hHd20x?=
 =?utf-8?B?eXdMR3NZZTZRYWJVbXRJY2Q3MjYzVmJxN1pEdFNYakZBMUpWd1E4UG9ZRHFw?=
 =?utf-8?B?VXl2M2Rrd0tKdlZlUzl3UlE3VEJrc2Z3c2hZUWd5VnMycGxYNitkOWRoK042?=
 =?utf-8?B?MEdRNUxSdURrNlpzQWJTVU81aXVjOGtmY3ZQUWNJcS9sYy9tcU1KUjVMMlBm?=
 =?utf-8?B?ZVBTazRmK2dRYnZrS2JjM3o2OTdDK0lFYzJXdE1YVmtMVEFDN2lveDRsc2t3?=
 =?utf-8?B?SndjU1J3djZ1Q2pScVZWQzdaOE9RRHZhL1AvM2NXZ1F4UG9UdEp1VkVKYUFv?=
 =?utf-8?B?Z2VBeG16clVTMDg5TDF0ZW9Gb3pBeTlGVGU4TkhrNVcvRmMxUlBGUDI1YlFi?=
 =?utf-8?B?bXlnNEhZVDlqbG5ENmp2NHhoancwQmVYaHJRaExlZkkrQWNQT05IL2xOV3Y4?=
 =?utf-8?Q?C/00AvVOe8HSUzpz4LjHSXz7yVnSUAQ1f4Kbqf8?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(7416009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?R3ZtUkQrU2Noa3Ezd29CMXJXOEFjUEUvUXNDdE5zN0RabXdzL1VORTBPelBo?=
 =?utf-8?B?cGMwNk55ZGRmL0RQNWJLaFJUOTAvZERJd0I5SXZMSU16S0dpSVRFa1o0QzMr?=
 =?utf-8?B?Skl4YVBKUlVsT2d1cEcvamh0UUtyNDhtd0dpcEhYbThJUFhtemhYMFJIUjRD?=
 =?utf-8?B?bktXQzYyOFhhSVVubU8rRENQMnVSWCtjdHN5dWVON3l1WkQ2bThIWUV4dklI?=
 =?utf-8?B?UDJmUXlNcHpzRldsOVBFdzQrb0V0bVUvSXhKWks4RkhNUitOc0M5N29BQjBL?=
 =?utf-8?B?TkJOQ1VpN1BFNnhScy93cW9yYnN5Ky9VditKSVE1VDNJclRnMTF5RGExajl4?=
 =?utf-8?B?V2JIL2orWDBwSHN6OVZEQys0QytTS0lET0dvYXhwWWVHeDhnUDFSOGpJdjZ6?=
 =?utf-8?B?dlZVTllQOUNhMnJKanc0dzh4RStZbFExRW14WW1wL1ppV1lWKzRzMXFWa1g2?=
 =?utf-8?B?R0Q3SUFjSm5ZV1Yza3JjU09lUURxdnRERGo4aHdYbk8rcWNpcEQ1ZXZNWkx5?=
 =?utf-8?B?VEJ1ME1zdlQ3NnJremVEcldWVWc4WFp3bVh5SGpvN01nMTZHUUIxNmRuT21X?=
 =?utf-8?B?bFFQWDhiMFlPMm0xOTUrdEpLbDNTQndtcEFQb1U4UFMwTE9IZ05PaUgvYkhi?=
 =?utf-8?B?OVd0OWU5eWF3QmxzcG82VVpOSjVod1hQRDlGTmVPeWV5MHBnbFpYVlZqYWg4?=
 =?utf-8?B?RVV5SjAwSjhMK0wxOU5tZE5XcGcwQ25Tdi9pRE9iSXpLdlhmNk9keXBGbXFG?=
 =?utf-8?B?SE9kNUxqNXY5dGo0RWRzVStVenRzN1dRcEMvd2I2UWd4NUtGNk9XYzZmYkgr?=
 =?utf-8?B?akhlWWloOXRUN21MR3JsMzJzazUrdjZ0aFA1bkl6TkVsUDJBSVRSZ0NFM3cw?=
 =?utf-8?B?Y2JhUVIrVDZOMm5JVDRYWmdmbUFXOGhCTFlIZkFFUEJrbHpwRFFVYm9ocHcw?=
 =?utf-8?B?d3NuTnlzVnJSTzhUUnE4d3RBajI2V3JJT0k2N0FzbzUzY09ZWkZSb0dvN0da?=
 =?utf-8?B?NU1jTkV0RGo0SjZUeDY5V25tQXNRTm05by9XUHRTWGNoTk5jUEo3SFZEcXJj?=
 =?utf-8?B?U3dOWVRsSTlCT3hqQ1g3dGdEcjBiaFFmUGxVeENIZElxaU0yS0VLMlBXMUZy?=
 =?utf-8?B?Wko3TTM3a0pNblFVMFJWZ0ZuWDVNUGQ3N2FxZzRRNnhTQlZyc1I0UjNaUFRw?=
 =?utf-8?B?UHplRFZhK2tvOTVuQ2lOdFlmNVZESHhPaFBFQmNEWWNmMloxLzhCdStsTVc1?=
 =?utf-8?B?UE1wZ05USm45a2ovRFpkdmR2WXllSXBBeVU3N1MwdnVEVytseURRY3ozYkNq?=
 =?utf-8?B?cERhZEN6bi9hY3FSN1VHUGVQc1RpN0lwYmxId2JXbnE2MTMzbFR3OVhXMzMy?=
 =?utf-8?B?SldnM3hLSHJvTmdpeEdLTWJDQzRmSmRZQWNZWXFFbFc1aHBTMktTTWpha0Zr?=
 =?utf-8?B?UGdZOWwwYk5jR0FiZ0VhRDBPSWFMN2VhWDk4bFM2MklvbGs3R2EwazM5Q2hZ?=
 =?utf-8?B?dG85Ull0N2liM2tMV0hjaE05Sy9MNWRZNDBsUzJwdEo1VjNQQ0R2dnk4b2NQ?=
 =?utf-8?B?UDJUTWJPVTltMlRLQm9razdrZ1VTdGNGQ0ZibWlqNmU1YWMxL3k5bDRRRFdl?=
 =?utf-8?B?cnVFRlRYWE5zaDdOSWkwcUpVb3RCZlVUMEdaQUJDK1dxaGp2Z2xGVHU2bEk4?=
 =?utf-8?B?amlVdnlsLzdtenFNREErdTJucUZjMjRoMHBlZHFIUjhmU0dZbFlKUTRsdU1J?=
 =?utf-8?B?L20yNXVsSXNmVHBuR2xIZkh0eXFSRTg4S1BtemxmSEFKanF5UXNsYm9oaVdY?=
 =?utf-8?B?aFU4a0dZRUZCbllMaWlzSk90RkdFa1l0ZEhtdlRBRUtlWWgrNGhNVXBML3Y4?=
 =?utf-8?B?SDliOUFGanc0cDZLaUE1K1R5dzBPMzJSMHJlN2l2Y2NtMHhSRmhPNmh6dDRS?=
 =?utf-8?B?anRNeWR2dEJZRGx3bmNLSzA4L3NuaVdrN082MGltRkdQT3ltS0Z6anpoU2Y1?=
 =?utf-8?B?c1k2bHRCU1AyWXlNMFpKZ0EwK3RtZkdqS3crN2g1WWVMNEdqeFdWYjRSY1JK?=
 =?utf-8?B?VU5lZkg0c01WMHZ3aVJVbkJDTFZtREZFMGcvVW1YMjVXSDFuSEdKU3FqeG1J?=
 =?utf-8?Q?AXTtfnoKu8BYLljwfYYF853fY?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	a9mrJSqolyTol2a6JO6v/fZs+7uFbNMtKe+Z9FuupUaQYpefbmG7Zo87AAxC3WmYDRg6t07RgfOsztm5U9xmUpyJZoH8KaK+NNDIvsGPll41EVtO+vCEb3C7ljb9nzJKmztnb16AJB10M+abDznO3OboKR1eqAbIuEe/v5o0kQpJOdVi3MnrLLQFOn0NCuaJcQZepZGhBnRCWsVqUQu5x4lZXZzmJlLx4UHNV2X55MD7lUEFBkRb2XYoOhDUwYQ6knNvPuRD6q6QybSMv1InA76rBtBzvoRC9aUgI1eKp2vC2+ghiIg+iKP+Lfht+O7j4xkythTYkHjVhqY8UFy669J0pIGosDA1hmMURcgb/iJxDCSIwjxy/ZLw9AEKU9X6ORESlBma6pmbUPqiu0b/hNU/qDz75QSj6ZURUyfFB5EuuhiVS21xHmzNdhv1O3hKL5+GzJqAUyY0sMDd2vfFK55exZA67R8jObmfmHcSga8V0BOqEStGttZ/qn+CuHiZJ5szIJRTL4uKMKeMZCSvIeENEgNFTRWHRCMJ+b6DHEIkZKwUBtGkkLf2EcQgecY/ukdMOiYJzg0qw0QK0GJQKQVcE3MEJNdsrDVflmuD5Zs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 853d6e45-aab2-4bb4-f0db-08dc8bc005a3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2024 15:46:42.7462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: un7OMtjrIFlyOBOt9B/64AADH4X0i49tv+nuUmp7McaVtfqqEs9XYVtwZDhOqpWxdB8F3bDCqjkqU0kcInXIpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7462
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_09,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406130113
X-Proofpoint-GUID: wC4Fsh4fGC6j1dZogUM-yjMfn5btDla3
X-Proofpoint-ORIG-GUID: wC4Fsh4fGC6j1dZogUM-yjMfn5btDla3

On 10/06/2024 22:50, Karan Tilak Kumar wrote:
> Add and integrate support for FCoE Initialization
> (protocol) FIP. This protocol will be exercised on
> Cisco UCS rack servers.
> Add support to specifically print FIP related
> debug messages.
> Replace existing definitions to handle new
> data structures.
> Clean up old and obsolete definitions.

Fill out text up to 72 characters.

It really seems that multiple steps are required below

There are approx 2.5K LoC changes here

I don't know how anyone is supposed to review that

Some sparse comments, below

> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/Makefile    |   1 +
>   drivers/scsi/fnic/fip.c       | 875 +++++++++++++++++++++++++++++++++
>   drivers/scsi/fnic/fip.h       | 341 +++++++++++++
>   drivers/scsi/fnic/fnic.h      |  23 +-
>   drivers/scsi/fnic/fnic_fcs.c  | 889 ++++++----------------------------
>   drivers/scsi/fnic/fnic_main.c |  47 +-
>   6 files changed, 1402 insertions(+), 774 deletions(-)
>   create mode 100644 drivers/scsi/fnic/fip.c
>   create mode 100644 drivers/scsi/fnic/fip.h
> 
> diff --git a/drivers/scsi/fnic/Makefile b/drivers/scsi/fnic/Makefile
> index af156c69da0c..c025e875009e 100644
> --- a/drivers/scsi/fnic/Makefile
> +++ b/drivers/scsi/fnic/Makefile
> @@ -2,6 +2,7 @@
>   obj-$(CONFIG_FCOE_FNIC) += fnic.o
>   
>   fnic-y	:= \
> +	fip.o\
>   	fnic_attrs.o \
>   	fnic_isr.o \
>   	fnic_main.o \
> diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
> new file mode 100644
> index 000000000000..8d4f6b98407b
> --- /dev/null
> +++ b/drivers/scsi/fnic/fip.c
> @@ -0,0 +1,875 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
> + * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
> + */
> +#include "fnic.h"
> +#include "fip.h"
> +#include <linux/etherdevice.h>
> +
> +extern struct workqueue_struct *fnic_fip_queue;
> +
> +#define TRUE 1
> +#define FALSE 0

use true and false for boolean type - they are already available

> +
> +int drop_rsp = TRUE;

this is not even referenced in this patch

> +
> +#define FIP_FNIC_RESET_WAIT_COUNT 15
> +
> +#define htonll(x) cpu_to_be64(x)

why? just use cpu_to_be64() directly

> +
> +/****************************** Functions ***********************************/
> +
> +/**
> + * fnic_fcoe_reset_vlans
> + *
> + * Frees up the list of discovered vlans
> + *
> + * @param fnic driver instance
> + */
> +
> +void fnic_fcoe_reset_vlans(struct fnic *fnic)
> +{
> +	unsigned long flags;
> +	struct fcoe_vlan *vlan, *next;
> +
> +	spin_lock_irqsave(&fnic->vlans_lock, flags);
> +	if (!list_empty(&fnic->vlan_list)) {
> +		list_for_each_entry_safe(vlan, next, &fnic->vlan_list, list) {
> +			list_del(&vlan->list);
> +			kfree(vlan);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Reset vlan complete\n");
> +}
> +
> +/**
> + * fnic_fcoe_send_vlan_req
> + *
> + * Sends FIP vlan request to all FCFs MAC
> + *
> + * @param fnic driver instance
> + */
> +
> +void fnic_fcoe_send_vlan_req(struct fnic *fnic)
> +{
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
> +	u64 vlan_tov;
> +
> +	int fr_len;
> +	struct fip_vlan_req_s vlan_req;
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Enter send vlan req\n");
> +	fnic_fcoe_reset_vlans(fnic);
> +
> +	fnic->set_vlan(fnic, 0);
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "set vlan done\n");
> +
> +	fr_len = sizeof(struct fip_vlan_req_s);
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "got MAC 0x%x:%x:%x:%x:%x:%x\n", iport->hwmac[0],
> +				 iport->hwmac[1], iport->hwmac[2], iport->hwmac[3],
> +				 iport->hwmac[4], iport->hwmac[5]);
> +
> +	memcpy(&vlan_req, &fip_vlan_req_tmpl, fr_len);
> +	memcpy(vlan_req.eth.smac, iport->hwmac, ETH_ALEN);
> +	memcpy(vlan_req.mac_desc.mac, iport->hwmac, ETH_ALEN);
> +
> +	atomic64_inc(&fnic_stats->vlan_stats.vlan_disc_reqs);
> +
> +	iport->fip.state = FDLS_FIP_VLAN_DISCOVERY_STARTED;
> +
> +	fnic_send_fip_frame(iport, &vlan_req, fr_len);
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "vlan req sent\n");
> +
> +	vlan_tov = jiffies + msecs_to_jiffies(FCOE_CTLR_FIPVLAN_TOV);
> +	mod_timer(&fnic->retry_fip_timer, round_jiffies(vlan_tov));
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fip timer set\n");
> +}
> +
> +/**
> + * fnic_fcoe_process_vlan_resp
> + *
> + * Processes the vlan response from one FCF and populates VLAN list.
> + * Will wait for responses from multiple FCFs until timeout.
> + *
> + * @param fnic driver instance
> + * @param fiph received fip frame
> + */
> +
> +void fnic_fcoe_process_vlan_resp(struct fnic *fnic,
> +								 struct fip_header_s *fiph)
> +{
> +	struct fip_vlan_notif_s *vlan_notif = (struct fip_vlan_notif_s *) fiph;
> +
> +	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
> +	u16 vid;
> +	int num_vlan = 0;
> +	int cur_desc, desc_len;
> +	struct fcoe_vlan *vlan;
> +	struct fip_vlan_desc_s *vlan_desc;
> +	unsigned long flags;
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fnic 0x%p got vlan resp\n", fnic);
> +
> +	desc_len = ntohs(vlan_notif->fip.desc_len);
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "desc_len %d\n", desc_len);
> +
> +	spin_lock_irqsave(&fnic->vlans_lock, flags);
> +
> +	cur_desc = 0;
> +	while (desc_len > 0) {
> +		vlan_desc =
> +			(struct fip_vlan_desc_s *) (((char *) vlan_notif->vlans_desc)
> +										+ cur_desc * 4);
> +
> +		if (vlan_desc->type == FIP_TYPE_VLAN) {
> +			if (vlan_desc->len != 1) {
> +				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "Invalid descriptor length(%x) in VLan response\n",
> +					 vlan_desc->len);
> +
> +			}
> +			num_vlan++;
> +			vid = ntohs(vlan_desc->vlan);
> +			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +						 "process_vlan_resp: FIP VLAN %d\n", vid);
> +			vlan = kmalloc(sizeof(*vlan), GFP_ATOMIC);


is this alloc under spinlock really required?

> +
> +			if (!vlan) {
> +				/* retry from timer */
> +				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +							 "Mem Alloc failure\n");
> +				spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> +				goto out;
> +			}
> +			memset(vlan, 0, sizeof(struct fcoe_vlan));

kzalloc should have been used

> +			vlan->vid = vid & 0x0fff;
> +			vlan->state = FIP_VLAN_AVAIL;
> +			list_add_tail(&vlan->list, &fnic->vlan_list);
> +			break;
> +		} else {
> +			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Invalid descriptor type(%x) in VLan response\n",
> +				 vlan_desc->type);
> +			/*
> +			 * Note : received a type=2 descriptor here i.e. FIP
> +			 * MAC Address Descriptor
> +			 */
> +		}
> +		cur_desc += vlan_desc->len;
> +		desc_len -= vlan_desc->len;
> +	}
> +
> +	/* any VLAN descriptors present ? */
> +	if (num_vlan == 0) {
> +		atomic64_inc(&fnic_stats->vlan_stats.resp_withno_vlanID);
> +		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "fnic 0x%p No VLAN descriptors in FIP VLAN response\n",
> +					 fnic);
> +	}
> +
> +	spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> +
> +out:
> +	return;
> +}
> +
> +/**
> + * fnic_fcoe_start_fcf_discovery
> + *
> + * Starts FIP FCF discovery in a selected vlan
> + *
> + * @param fnic driver instance
> + */
> +
> +void fnic_fcoe_start_fcf_discovery(struct fnic *fnic)
> +{
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	u64 fcs_tov;
> +
> +	int fr_len;
> +	struct fip_discovery_s disc_sol;
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fnic 0x%p start fcf discovery\n", fnic);
> +	fr_len = sizeof(struct fip_discovery_s);
> +	memset(iport->selected_fcf.fcf_mac, 0, ETH_ALEN);
> +
> +	memcpy(&disc_sol, &fip_discovery_tmpl, fr_len);
> +	memcpy(disc_sol.eth.smac, iport->hwmac, ETH_ALEN);
> +	memcpy(disc_sol.mac_desc.mac, iport->hwmac, ETH_ALEN);
> +	iport->selected_fcf.fcf_priority = 0xFF;
> +
> +	disc_sol.name_desc.name = htonll(iport->wwnn);
> +	fnic_send_fip_frame(iport, &disc_sol, fr_len);
> +
> +	iport->fip.state = FDLS_FIP_FCF_DISCOVERY_STARTED;
> +
> +	fcs_tov = jiffies + msecs_to_jiffies(FCOE_CTLR_FCS_TOV);
> +	mod_timer(&fnic->retry_fip_timer, round_jiffies(fcs_tov));
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fnic 0x%p Started FCF discovery", fnic);
> +
> +}
> +
> +/**
> + * fnic_fcoe_fip_discovery_resp
> + *
> + * Processes FCF advertisements.
> + * They can be:
> + * solicited   Sent in response of a discover FCF FIP request
> + *             We will only store the information of the FCF with
> + *             highest priority.
> + *             We wait until timeout in case of multiple FCFs.
> + * unsolicited Sent periodically by the FCF for keep alive.
> + *             If FLOGI is in progress or completed and the advertisement is
> + *             received by our selected FCF, refresh the keep alive timer.
> + *
> + * @param fnic driver instance
> + * @param fiph received frame
> + */
> +
> +void fnic_fcoe_fip_discovery_resp(struct fnic *fnic,
> +								  struct fip_header_s *fiph)
> +{
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	struct fip_disc_adv_s *disc_adv = (struct fip_disc_adv_s *) fiph;
> +	u64 fcs_ka_tov;
> +	int fka_has_changed;
> +
> +	if (iport->fip.state == FDLS_FIP_FCF_DISCOVERY_STARTED) {
> +		if (ntohs(disc_adv->fip.flags) & FIP_FLAG_S) {
> +			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +						 "fnic 0x%p Solicited adv\n", fnic);
> +
> +			if ((disc_adv->prio_desc.priority <
> +				 iport->selected_fcf.fcf_priority)
> +				&& (ntohs(disc_adv->fip.flags) & FIP_FLAG_A)) {
> +
> +				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +							 "fnic 0x%p FCF Available\n", fnic);
> +				memcpy(iport->selected_fcf.fcf_mac, disc_adv->mac_desc.mac,
> +					   ETH_ALEN);
> +				iport->selected_fcf.fcf_priority =
> +					disc_adv->prio_desc.priority;
> +				iport->selected_fcf.fka_adv_period =
> +					ntohl(disc_adv->fka_adv_desc.fka_adv);
> +				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +							 "adv time %d",
> +							 iport->selected_fcf.fka_adv_period);
> +				iport->selected_fcf.ka_disabled =
> +					(disc_adv->fka_adv_desc.rsvd_D & 1);
> +			}
> +		}
> +	} else if ((iport->fip.state == FDLS_FIP_FLOGI_STARTED)

switch statement is better here

> +			   || (iport->fip.state == FDLS_FIP_FLOGI_COMPLETE)) {
> +		if (!(ntohs(disc_adv->fip.flags) & FIP_FLAG_S)) {
> +			/* same fcf */
> +			if (memcmp(iport->selected_fcf.fcf_mac, disc_adv->mac_desc.mac,
> +					   ETH_ALEN) == 0) {
> +				if (iport->selected_fcf.fka_adv_period
> +					!= ntohl(disc_adv->fka_adv_desc.fka_adv)) {
> +					iport->selected_fcf.fka_adv_period =
> +						ntohl(disc_adv->fka_adv_desc.fka_adv);
> +					FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
> +						 fnic->fnic_num, "change fka to %d",
> +						 iport->selected_fcf.fka_adv_period);
> +				}
> +
> +				fka_has_changed = (iport->selected_fcf.ka_disabled == 1)
> +					&& ((disc_adv->fka_adv_desc.rsvd_D & 1) == 0);
> +
> +				iport->selected_fcf.ka_disabled =
> +					(disc_adv->fka_adv_desc.rsvd_D & 1);
> +				if (!((iport->selected_fcf.ka_disabled)
> +					  || (iport->selected_fcf.fka_adv_period == 0))) {
> +
> +					fcs_ka_tov = jiffies
> +						+ 3
> +						*
> +						msecs_to_jiffies(
> +								iport->selected_fcf.fka_adv_period);
> +					mod_timer(&fnic->fcs_ka_timer,
> +							  round_jiffies(fcs_ka_tov));
> +
> +				} else {
> +					if (timer_pending(&fnic->fcs_ka_timer))
> +						del_timer_sync(&fnic->fcs_ka_timer);
> +				}
> +
> +				if (fka_has_changed) {
> +					u64 tov;
> +
> +					if (iport->selected_fcf.fka_adv_period != 0) {
> +
> +						tov = jiffies +
> +							msecs_to_jiffies(
> +						iport->selected_fcf.fka_adv_period);
> +						mod_timer(&fnic->enode_ka_timer,
> +								  round_jiffies(tov));
> +
> +						tov =
> +							jiffies +
> +							msecs_to_jiffies(FCOE_CTLR_VN_KA_TOV);
> +						mod_timer(&fnic->vn_ka_timer, round_jiffies(tov));

all this code is too complicated

> +					}
> +				}
> +			}
> +		}
> +	}
> +}
> +
> +/**
> + * fnic_fcoe_start_flogi
> + *
> + * Sends FIP FLOGI to the selected FCF
> + *
> + * @param fnic driver instance
> + */
> +
> +void fnic_fcoe_start_flogi(struct fnic *fnic)
> +{
> +	struct fnic_iport_s *iport = &fnic->iport;
> +
> +	int fr_len;
> +	struct fip_flogi_s flogi_req;
> +	u64 flogi_tov;
> +
> +	fr_len = sizeof(struct fip_flogi_s);
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fnic 0x%p Start fip FLOGI\n", fnic);
> +
> +	memcpy(&flogi_req, &fip_flogi_tmpl, fr_len);
> +	memcpy(flogi_req.eth.smac, iport->hwmac, ETH_ALEN);
> +	if (iport->usefip)
> +		memcpy(flogi_req.eth.dmac, iport->selected_fcf.fcf_mac, ETH_ALEN);
> +
> +	flogi_req.flogi_desc.flogi.nport_name = htonll(iport->wwpn);
> +	flogi_req.flogi_desc.flogi.node_name = htonll(iport->wwnn);
> +
> +	fnic_send_fip_frame(iport, &flogi_req, fr_len);
> +	iport->fip.flogi_retry++;
> +
> +	iport->fip.state = FDLS_FIP_FLOGI_STARTED;
> +	flogi_tov = jiffies + msecs_to_jiffies(fnic->config.flogi_timeout);
> +	mod_timer(&fnic->retry_fip_timer, round_jiffies(flogi_tov));
> +}
> +
> +/**
> + * fnic_fcoe_process_flogi_resp
> + *
> + * Processes FLOGI response from FCF.
> + * If successful saves assigned fc_id and MAC, programs firmware
> + * and starts fdls discovery.
> + * Else restarts vlan discovery.
> + *
> + * @param fnic driver instance
> + * @param fiph received frame
> + */
> +
> +void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
> +								  struct fip_header_s *fiph)
> +{
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	struct fip_flogi_rsp_s *flogi_rsp = (struct fip_flogi_rsp_s *) fiph;
> +	int desc_len;
> +	uint32_t s_id;
> +
> +	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fnic 0x%p FIP FLOGI rsp\n", fnic);
> +	desc_len = ntohs(flogi_rsp->fip.desc_len);
> +	if (desc_len != 38) {
> +		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "Invalid Descriptor List len (%x). Dropping frame\n",
> +					 desc_len);
> +		return;
> +	}
> +
> +	if (!
> +		((flogi_rsp->rsp_desc.type == 7)
> +		 && (flogi_rsp->rsp_desc.len == 36))
> +		|| !((flogi_rsp->mac_desc.type == 2)
> +			 && (flogi_rsp->mac_desc.len == 2))) {
> +		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "Dropping frame invalid type and len mix\n");
> +		return;
> +	}
> +
> +	s_id = ntoh24(flogi_rsp->rsp_desc.els.fchdr.sid);
> +	if ((flogi_rsp->rsp_desc.els.fchdr.f_ctl != 0x98)
> +		|| (flogi_rsp->rsp_desc.els.fchdr.r_ctl != 0x23)
> +		|| (s_id != 0xFFFFFE)
> +		|| (flogi_rsp->rsp_desc.els.fchdr.ox_id != FNIC_FLOGI_OXID)
> +		|| (flogi_rsp->rsp_desc.els.fchdr.type != 0x01)) {
> +		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "Dropping invalid frame: s_id %x F %x R %x t %x OX_ID %x\n",
> +			 s_id,
> +			 flogi_rsp->rsp_desc.els.fchdr.f_ctl,
> +			 flogi_rsp->rsp_desc.els.fchdr.r_ctl,
> +			 flogi_rsp->rsp_desc.els.fchdr.type,
> +			 flogi_rsp->rsp_desc.els.fchdr.ox_id);
> +		return;
> +	}
> +
> +	if (iport->fip.state == FDLS_FIP_FLOGI_STARTED) {
> +		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "fnic 0x%p rsp for pending FLOGI\n", fnic);
> +
> +		del_timer_sync(&fnic->retry_fip_timer);
> +
> +		if ((ntohs(flogi_rsp->fip.desc_len) == 38)
> +			&& (flogi_rsp->rsp_desc.els.command == FC_LS_ACC)) {
> +
> +			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +						 "fnic 0x%p FLOGI success\n", fnic);
> +			memcpy(iport->fpma, flogi_rsp->mac_desc.mac, ETH_ALEN);
> +			iport->fcid = ntoh24(flogi_rsp->rsp_desc.els.fchdr.did);
> +
> +			iport->r_a_tov =
> +				ntohl(flogi_rsp->rsp_desc.els.u.csp_flogi.r_a_tov);
> +			iport->e_d_tov =
> +				ntohl(flogi_rsp->rsp_desc.els.u.csp_flogi.e_d_tov);
> +			memcpy(fnic->iport.fcfmac, iport->selected_fcf.fcf_mac,
> +				   ETH_ALEN);
> +			vnic_dev_add_addr(fnic->vdev, flogi_rsp->mac_desc.mac);
> +
> +			if (fnic_fdls_register_portid(iport, iport->fcid, NULL) != 0) {
> +				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +							 "fnic 0x%p flogi registration failed\n",
> +							 fnic);
> +				return;
> +			}
> +
> +			iport->fip.state = FDLS_FIP_FLOGI_COMPLETE;
> +			iport->state = FNIC_IPORT_STATE_FABRIC_DISC;
> +			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +						 "iport->state:%d\n", iport->state);
> +			if (!((iport->selected_fcf.ka_disabled)
> +				  || (iport->selected_fcf.fka_adv_period == 0))) {
> +				u64 tov;
> +
> +				tov = jiffies
> +					+ msecs_to_jiffies(iport->selected_fcf.fka_adv_period);
> +				mod_timer(&fnic->enode_ka_timer, round_jiffies(tov));
> +
> +				tov = jiffies + msecs_to_jiffies(FCOE_CTLR_VN_KA_TOV);
> +				mod_timer(&fnic->vn_ka_timer, round_jiffies(tov));
> +
> +			}
> +		} else {
> +			/*
> +			 * If there's FLOGI rejects - clear all
> +			 * fcf's & restart from scratch
> +			 */
> +			atomic64_inc(&fnic_stats->vlan_stats.flogi_rejects);
> +			/* start FCoE VLAN discovery */
> +			fnic_fcoe_send_vlan_req(fnic);
> +
> +			iport->fip.state = FDLS_FIP_VLAN_DISCOVERY_STARTED;
> +		}
> +	}
> +}
> +
> +/**
> + * fnic_common_fip_cleanup
> + *
> + * Cleans up FCF info and timers in case of link down/CVL
> + *
> + * @param fnic driver instance
> + */
> +
> +void fnic_common_fip_cleanup(struct fnic *fnic)
> +{
> +
> +	struct fnic_iport_s *iport = &fnic->iport;
> +
> +	if (!iport->usefip)
> +		return;
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fnic 0x%p fip cleanup\n", fnic);
> +
> +	iport->fip.state = FDLS_FIP_INIT;
> +
> +	del_timer_sync(&fnic->retry_fip_timer);
> +	del_timer_sync(&fnic->fcs_ka_timer);
> +	del_timer_sync(&fnic->enode_ka_timer);
> +	del_timer_sync(&fnic->vn_ka_timer);
> +
> +	if (!is_zero_ether_addr(iport->fpma))
> +		vnic_dev_del_addr(fnic->vdev, iport->fpma);
> +
> +	memset(iport->fpma, 0, ETH_ALEN);
> +	iport->fcid = 0;
> +	iport->r_a_tov = 0;
> +	iport->e_d_tov = 0;
> +	memset(fnic->iport.fcfmac, 0, ETH_ALEN);
> +	memset(iport->selected_fcf.fcf_mac, 0, ETH_ALEN);
> +	iport->selected_fcf.fcf_priority = 0;
> +	iport->selected_fcf.fka_adv_period = 0;
> +	iport->selected_fcf.ka_disabled = 0;
> +
> +	fnic_fcoe_reset_vlans(fnic);
> +}
> +
> +/**
> + * fnic_fcoe_process_cvl
> + *
> + * Processes Clear Virtual Link from FCF
> + * Verifies that cvl is received from our current FCF for our assigned MAC
> + * Cleans up and restarts the vlan discovery
> + *
> + * @param fnic driver instance
> + * @param fiph received frame
> + */
> +
> +void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
> +{
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	struct fip_cvl_s *cvl_msg = (struct fip_cvl_s *) fiph;
> +	int i;
> +	int found = FALSE;
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fnic 0x%p clear virtual link handler\n", fnic);
> +
> +	if (!
> +		((cvl_msg->fcf_mac_desc.type == 2)
> +		 && (cvl_msg->fcf_mac_desc.len == 2))
> +|| !((cvl_msg->name_desc.type == 4) && (cvl_msg->name_desc.len == 3))) {
> +
> +		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "invalid mix: ft %x fl %x ndt %x ndl %x",
> +			 cvl_msg->fcf_mac_desc.type, cvl_msg->fcf_mac_desc.len,
> +			 cvl_msg->name_desc.type, cvl_msg->name_desc.len);
> +	}
> +
> +	if (memcmp
> +		(iport->selected_fcf.fcf_mac, cvl_msg->fcf_mac_desc.mac, ETH_ALEN)
> +		== 0) {

you could do:

	if (memcmp
 > +		(iport->selected_fcf.fcf_mac, cvl_msg->fcf_mac_desc.mac, ETH_ALEN))
		return;

and then have the rest, below, to reduce indentation

> +		for (i = 0; i < ((ntohs(fiph->desc_len) / 5) - 1); i++) {
> +			if (!((cvl_msg->vn_ports_desc[i].type == 11)
> +				  && (cvl_msg->vn_ports_desc[i].len == 5))) {
> +
> +				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "Invalid type and len mix type: %d len: %d\n",
> +					 cvl_msg->vn_ports_desc[i].type,
> +					 cvl_msg->vn_ports_desc[i].len);
> +			}
> +			if (memcmp(iport->fpma, cvl_msg->vn_ports_desc[i].vn_port_mac,
> +					   ETH_ALEN) == 0) {
> +				found = TRUE;
> +				break;
> +			}
> +		}
> +		if (!found)
> +			return;
> +		fnic_common_fip_cleanup(fnic);
> +
> +		fnic_fcoe_send_vlan_req(fnic);
> +	}
> +}
> +
> +/**
> + * fdls_fip_recv_frame
> + *
> + * Demultiplexer for FIP frames
> + *
> + * @param fnic driver instance
> + * @param frame received ethernet frame
> + * @return Frame processed by FIP
> + */
> +
> +int fdls_fip_recv_frame(struct fnic *fnic, void *frame)
> +{
> +	struct eth_hdr_s *eth = (struct eth_hdr_s *) frame;
> +	struct fip_header_s *fiph;
> +	u16 protocol;
> +	u8 sub;
> +
> +	if (eth->eth_type == ntohs(FIP_ETH_TYPE)) {
> +		fiph = (struct fip_header_s *) (eth + 1);
> +		protocol = ntohs(fiph->protocol);
> +		sub = ntohs(fiph->subcode);
> +
> +		if (protocol == FIP_DISCOVERY && sub == FIP_SUBCODE_RESP)
> +			fnic_fcoe_fip_discovery_resp(fnic, fiph);
> +		else if (protocol == FIP_VLAN_DISC && sub == FIP_SUBCODE_RESP)
> +			fnic_fcoe_process_vlan_resp(fnic, fiph);
> +		else if (protocol == FIP_KA_CVL && sub == FIP_SUBCODE_RESP)
> +			fnic_fcoe_process_cvl(fnic, fiph);
> +		else if (protocol == FIP_FLOGI && sub == FIP_SUBCODE_RESP)
> +			fnic_fcoe_process_flogi_resp(fnic, fiph);
> +
> +		return 1;
> +	}
> +	return 0;

what does 1 and 0 mean here?

> +}
> +
> +void fnic_work_on_fip_timer(struct work_struct *work)
> +{
> +	struct fnic *fnic = container_of(work, struct fnic, fip_timer_work);
> +	struct fnic_iport_s *iport = &fnic->iport;
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "FIP timeout\n");
> +
> +	if (iport->fip.state == FDLS_FIP_VLAN_DISCOVERY_STARTED) {
> +		fnic_vlan_discovery_timeout(fnic);
> +	} else if (iport->fip.state == FDLS_FIP_FCF_DISCOVERY_STARTED) {
> +		u8 zmac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
> +
> +		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "FCF Discovery timeout\n");
> +		if (memcmp(iport->selected_fcf.fcf_mac, zmac, ETH_ALEN) != 0) {
> +
> +			if (iport->flags & FNIC_FIRST_LINK_UP)
> +				iport->flags &= ~FNIC_FIRST_LINK_UP;
> +
> +			fnic_fcoe_start_flogi(fnic);
> +			if (!((iport->selected_fcf.ka_disabled)
> +				  || (iport->selected_fcf.fka_adv_period == 0))) {
> +				u64 fcf_tov;
> +
> +				fcf_tov = jiffies
> +					+ 3
> +					* msecs_to_jiffies(iport->selected_fcf.fka_adv_period);
> +				mod_timer(&fnic->fcs_ka_timer, round_jiffies(fcf_tov));
> +			}
> +		} else {
> +			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +						 "FCF Discovery timeout\n");
> +			fnic_vlan_discovery_timeout(fnic);
> +		}
> +	} else if (iport->fip.state == FDLS_FIP_FLOGI_STARTED) {
> +		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "FLOGI timeout\n");
> +		if (iport->fip.flogi_retry < fnic->config.flogi_retries)
> +			fnic_fcoe_start_flogi(fnic);
> +		else
> +			fnic_vlan_discovery_timeout(fnic);
> +	}
> +}
> +
> +/**
> + * fnic_handle_fip_timer
> + *
> + * Timeout handler for FIP discover phase.
> + * Based on the current state, starts next phase or restarts discovery
> + *
> + * @param data Opaque pointer to fnic structure
> + */
> +
> +void fnic_handle_fip_timer(struct timer_list *t)
> +{
> +	struct fnic *fnic = from_timer(fnic, t, retry_fip_timer);
> +
> +	INIT_WORK(&fnic->fip_timer_work, fnic_work_on_fip_timer);

do you really need to init every time?

> +	queue_work(fnic_fip_queue, &fnic->fip_timer_work);
> +}
> +
> +/**
> + * fnic_handle_enode_ka_timer
> + *
> + * FIP node keep alive.
> + *
> + * @param data Opaque pointer to fnic struct
> + */
> +void fnic_handle_enode_ka_timer(struct timer_list *t)
> +{
> +	struct fnic *fnic = from_timer(fnic, t, enode_ka_timer);
> +
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	int fr_len;
> +	struct fip_enode_ka_s enode_ka;
> +	u64 enode_ka_tov;
> +
> +	if (iport->fip.state != FDLS_FIP_FLOGI_COMPLETE)
> +		return;
> +
> +	if ((iport->selected_fcf.ka_disabled)
> +		|| (iport->selected_fcf.fka_adv_period == 0)) {
> +		return;
> +	}
> +
> +	fr_len = sizeof(struct fip_enode_ka_s);
> +
> +	memcpy(&enode_ka, &fip_enode_ka_tmpl, fr_len);
> +	memcpy(enode_ka.eth.smac, iport->hwmac, ETH_ALEN);
> +	memcpy(enode_ka.eth.dmac, iport->selected_fcf.fcf_mac, ETH_ALEN);
> +	memcpy(enode_ka.mac_desc.mac, iport->hwmac, ETH_ALEN);
> +
> +	fnic_send_fip_frame(iport, &enode_ka, fr_len);
> +	enode_ka_tov = jiffies
> +		+ msecs_to_jiffies(iport->selected_fcf.fka_adv_period);
> +	mod_timer(&fnic->enode_ka_timer, round_jiffies(enode_ka_tov));
> +}
> +
> +/**
> + * fnic_handle_vn_ka_timer
> + *
> + * FIP virtual port keep alive.
> + *
> + * @param data Opaque pointer to fnic structure
> + */
> +
> +void fnic_handle_vn_ka_timer(struct timer_list *t)
> +{
> +	struct fnic *fnic = from_timer(fnic, t, vn_ka_timer);
> +
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	int fr_len;
> +	struct fip_vn_port_ka_s vn_port_ka;
> +	u64 vn_ka_tov;
> +	uint8_t fcid[3];
> +
> +	if (iport->fip.state != FDLS_FIP_FLOGI_COMPLETE)
> +		return;
> +
> +	if ((iport->selected_fcf.ka_disabled)
> +		|| (iport->selected_fcf.fka_adv_period == 0)) {
> +		return;
> +	}

exact same code is duplicated from fnic_handle_enode_ka_timer(), above

> +
> +	fr_len = sizeof(struct fip_vn_port_ka_s);
> +
> +	memcpy(&vn_port_ka, &fip_vn_port_ka_tmpl, fr_len);
> +	memcpy(vn_port_ka.eth.smac, iport->fpma, ETH_ALEN);
> +	memcpy(vn_port_ka.eth.dmac, iport->selected_fcf.fcf_mac, ETH_ALEN);
> +	memcpy(vn_port_ka.mac_desc.mac, iport->hwmac, ETH_ALEN);
> +	memcpy(vn_port_ka.vn_port_desc.vn_port_mac, iport->fpma, ETH_ALEN);
> +	hton24(fcid, iport->fcid);
> +	memcpy(vn_port_ka.vn_port_desc.vn_port_id, fcid, 3);
> +	vn_port_ka.vn_port_desc.vn_port_name = htonll(iport->wwpn);
> +
> +	fnic_send_fip_frame(iport, &vn_port_ka, fr_len);
> +	vn_ka_tov = jiffies + msecs_to_jiffies(FCOE_CTLR_VN_KA_TOV);
> +	mod_timer(&fnic->vn_ka_timer, round_jiffies(vn_ka_tov));
> +}
> +
> +/**
> + * fnic_vlan_discovery_timeout
> + *
> + * End of VLAN discovery or FCF discovery time window
> + * Start the FCF discovery if VLAN was never used
> + * Retry in case of FCF not responding or move to next VLAN
> + *
> + * @param fnic driver instance
> + */
> +
> +void fnic_vlan_discovery_timeout(struct fnic *fnic)
> +{
> +	struct fcoe_vlan *vlan;
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	if (fnic->stop_rx_link_events) {

I assume that you are relying in the in-built memory barriers in 
spin_lock_irqsave() and spin_unlock_irqrestore()...

> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	if (!iport->usefip)
> +		return;
> +
> +	spin_lock_irqsave(&fnic->vlans_lock, flags);

it's hardly worth dropping the lock before the !iport->usefip check.

> +	if (list_empty(&fnic->vlan_list)) {
> +		/* no vlans available, try again */
> +		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> +		fnic_fcoe_send_vlan_req(fnic);
> +		return;
> +	}
> +
> +	vlan = list_first_entry(&fnic->vlan_list, struct fcoe_vlan, list);
> +
> +	if (vlan->state == FIP_VLAN_SENT) {
> +		if (vlan->sol_count >= FCOE_CTLR_MAX_SOL) {
> +			/*
> +			 * no response on this vlan, remove  from the list.
> +			 * Try the next vlan
> +			 */
> +			list_del(&vlan->list);
> +			kfree(vlan);
> +			vlan = NULL;
> +			if (list_empty(&fnic->vlan_list)) {
> +				/* we exhausted all vlans, restart vlan disc */
> +				spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> +				fnic_fcoe_send_vlan_req(fnic);
> +				return;
> +			}
> +			/* check the next vlan */
> +			vlan =
> +				list_first_entry(&fnic->vlan_list, struct fcoe_vlan, list);
> +
> +			fnic->set_vlan(fnic, vlan->vid);
> +			vlan->state = FIP_VLAN_SENT;	/* sent now */
> +
> +		}
> +		atomic64_inc(&fnic_stats->vlan_stats.sol_expiry_count);
> +
> +	} else {
> +		fnic->set_vlan(fnic, vlan->vid);
> +		vlan->state = FIP_VLAN_SENT;	/* sent now */
> +	}
> +	vlan->sol_count++;
> +	spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> +	fnic_fcoe_start_fcf_discovery(fnic);
> +}
> +
> +/**
> + * fnic_work_on_fcs_ka_timer - finish handling fcs_ka_timer in process context
> + * We need to finish this timer in a process context so that we do
> + * not hand in fip_common_cleanup. Here we clean up, bring the link down
> + * and restart all FIP discovery.
> + *
> + * @work - the work queue that we will be servicing
> + */
> +
> +void fnic_work_on_fcs_ka_timer(struct work_struct *work)
> +{
> +	struct fnic
> +	*fnic = container_of(work, struct fnic, fip_timer_work);
> +	struct fnic_iport_s *iport = &fnic->iport;
> +
> +	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "fnic 0x%p fcs ka timeout\n", fnic);
> +
> +	fnic_common_fip_cleanup(fnic);
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +	iport->state = FNIC_IPORT_STATE_FIP;
> +	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +
> +	fnic_fcoe_send_vlan_req(fnic);
> +}
> +
> +/**
> + * fnic_handle_fcs_ka_timer
> + *
> + * No keep alives received from FCF. Clean up, bring the link down
> + * and restart all the FIP discovery.
> + *
> + * @param data Opaque pointer to fnic structure
> + */
> +void fnic_handle_fcs_ka_timer(struct timer_list *t)
> +{
> +	struct fnic *fnic = from_timer(fnic, t, fcs_ka_timer);
> +
> +	INIT_WORK(&fnic->fip_timer_work, fnic_work_on_fcs_ka_timer);
> +	queue_work(fnic_fip_queue, &fnic->fip_timer_work);
> +}
> diff --git a/drivers/scsi/fnic/fip.h b/drivers/scsi/fnic/fip.h
> new file mode 100644
> index 000000000000..33562c5a41e0
> --- /dev/null
> +++ b/drivers/scsi/fnic/fip.h
> @@ -0,0 +1,341 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
> + * Copyright 2007 Nuova Systems, Inc.  All rights reserved.

Is this a driver for HW older than 15 years?

> + */
> +#ifndef _FIP_H_
> +#define _FIP_H_
> +
> +#include "fdls_fc.h"
> +
> +#define FCOE_ALL_FCFS_MAC {0x01, 0x10, 0x18, 0x01, 0x00, 0x02}
> +#define FIP_ETH_TYPE 0x8914
> +
> +#define FIP_ETH_TYPE_LE 0x1489
> +#define FCOE_MAX_SIZE_LE 0x2E08
> +
> +#define WWNN_LEN 8
> +
> +#define FCOE_CTLR_FIPVLAN_TOV (3*1000)
> +#define FCOE_CTLR_FCS_TOV     (3*1000)
> +#define FCOE_CTLR_VN_KA_TOV    (90*1000)
> +#define FCOE_CTLR_MAX_SOL      (5*1000)
> +
> +#define FIP_SUBCODE_REQ  1
> +#define FIP_SUBCODE_RESP 2
> +
> +#define FIP_FLAG_S 0x2
> +#define FIP_FLAG_A 0x4
> +
> +/*
> + * VLAN entry.
> + */
> +struct fcoe_vlan {
> +	struct list_head list;
> +	uint16_t vid;				/* vlan ID */
> +	uint16_t sol_count;			/* no. of sols sent */
> +	uint16_t state;				/* state */
> +};
> +
> +enum fdls_vlan_state_e {
> +	FIP_VLAN_AVAIL,
> +	FIP_VLAN_SENT
> +};
> +
> +enum fdls_fip_state_e {
> +	FDLS_FIP_INIT,
> +	FDLS_FIP_VLAN_DISCOVERY_STARTED,
> +	FDLS_FIP_FCF_DISCOVERY_STARTED,
> +	FDLS_FIP_FLOGI_STARTED,
> +	FDLS_FIP_FLOGI_COMPLETE,
> +};
> +
> +enum fip_protocol_code_e {
> +	FIP_DISCOVERY = 1,
> +	FIP_FLOGI,
> +	FIP_KA_CVL,
> +	FIP_VLAN_DISC
> +};
> +
> +struct eth_hdr_s {
> +	uint8_t dmac[6];
> +	uint8_t smac[6];
> +	uint16_t eth_type;
> +};
> +
> +struct fip_header_s {
> +	uint32_t ver:16;
> +
> +	uint32_t protocol:16;
> +	uint32_t subcode:16;
> +
> +	uint32_t desc_len:16;
> +	uint32_t flags:16;
> +} __packed;


Do you really want to use __packed?

I don't even get what you are trying to do here in terms of formatting 
of these structures and their members.

> +
> +enum fip_desc_type_e {
> +	FIP_TYPE_PRIORITY = 1,
> +	FIP_TYPE_MAC,
> +	FIP_TYPE_FCMAP,
> +	FIP_TYPE_NAME_ID,
> +	FIP_TYPE_FABRIC,
> +	FIP_TYPE_MAX_FCOE,
> +	FIP_TYPE_FLOGI,
> +	FIP_TYPE_FDISC,
> +	FIP_TYPE_LOGO,
> +	FIP_TYPE_ELP,
> +	FIP_TYPE_VX_PORT,
> +	FIP_TYPE_FKA_ADV,
> +	FIP_TYPE_VENDOR_ID,
> +	FIP_TYPE_VLAN
> +};
> +
> +struct fip_mac_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint8_t mac[6];
> +} __packed;
> +
> +struct fip_vlan_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint16_t vlan;
> +} __packed;
> +
> +struct fip_vlan_req_s {
> +	struct eth_hdr_s eth;
> +	struct fip_header_s fip;
> +	struct fip_mac_desc_s mac_desc;
> +} __packed;
> +
> + /*
> +  * Variables:
> +  * eth.smac, mac_desc.mac
> +  */
> +struct fip_vlan_req_s fip_vlan_req_tmpl = {

static const?

> +	.eth = {.dmac = FCOE_ALL_FCFS_MAC,
> +			.eth_type = FIP_ETH_TYPE_LE},
> +	.fip = {.ver = 0x10,
> +			.protocol = FIP_VLAN_DISC << 8,
> +			.subcode = FIP_SUBCODE_REQ << 8,
> +			.desc_len = 2 << 8},
> +	.mac_desc = {.type = FIP_TYPE_MAC, .len = 2}
> +};
> +
> +struct fip_vlan_notif_s {
> +	struct fip_header_s fip;
> +	struct fip_vlan_desc_s vlans_desc[];
> +} __packed;
> +
> +struct fip_vn_port_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint8_t vn_port_mac[6];
> +	uint8_t rsvd[1];
> +	uint8_t vn_port_id[3];
> +	uint64_t vn_port_name;
> +} __packed;
> +
> +struct fip_vn_port_ka_s {
> +	struct eth_hdr_s eth;
> +	struct fip_header_s fip;
> +	struct fip_mac_desc_s mac_desc;
> +	struct fip_vn_port_desc_s vn_port_desc;
> +} __packed;
> +
> +/*
> + * Variables:
> + * fcf_mac, eth.smac, mac_desc.enode_mac
> + * vn_port_desc:mac, id, port_name
> + */
> +struct fip_vn_port_ka_s fip_vn_port_ka_tmpl = {
> +	.eth = {
> +			.eth_type = FIP_ETH_TYPE_LE},
> +	.fip = {
> +			.ver = 0x10,
> +			.protocol = FIP_KA_CVL << 8,
> +			.subcode = FIP_SUBCODE_REQ << 8,
> +			.desc_len = 7 << 8},
> +	.mac_desc = {.type = FIP_TYPE_MAC, .len = 2},
> +	.vn_port_desc = {.type = FIP_TYPE_VX_PORT, .len = 5}
> +};
> +
> +struct fip_enode_ka_s {
> +	struct eth_hdr_s eth;
> +	struct fip_header_s fip;
> +	struct fip_mac_desc_s mac_desc;
> +} __packed;
> +
> +/*
> + * Variables:
> + * fcf_mac, eth.smac, mac_desc.enode_mac
> + */
> +struct fip_enode_ka_s fip_enode_ka_tmpl = {
> +	.eth = {
> +			.eth_type = FIP_ETH_TYPE_LE},
> +	.fip = {
> +			.ver = 0x10,
> +			.protocol = FIP_KA_CVL << 8,
> +			.subcode = FIP_SUBCODE_REQ << 8,
> +			.desc_len = 2 << 8},
> +	.mac_desc = {.type = FIP_TYPE_MAC, .len = 2}
> +};
> +
> +struct fip_name_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint8_t rsvd[2];
> +	uint64_t name;
> +} __packed;
> +
> +struct fip_cvl_s {
> +	struct fip_header_s fip;
> +	struct fip_mac_desc_s fcf_mac_desc;
> +	struct fip_name_desc_s name_desc;
> +	struct fip_vn_port_desc_s vn_ports_desc[];
> +} __packed;
> +
> +struct fip_flogi_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint16_t rsvd;
> +	struct fc_els_s flogi;
> +} __packed;
> +
> +struct fip_flogi_rsp_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint16_t rsvd;
> +	struct fc_els_s els;
> +} __packed;
> +
> +struct fip_flogi_s {
> +	struct eth_hdr_s eth;
> +	struct fip_header_s fip;
> +	struct fip_flogi_desc_s flogi_desc;
> +	struct fip_mac_desc_s mac_desc;
> +} __packed;
> +
> +struct fip_flogi_rsp_s {
> +	struct fip_header_s fip;
> +	struct fip_flogi_rsp_desc_s rsp_desc;
> +	struct fip_mac_desc_s mac_desc;
> +} __packed;
> +
> +/*
> + * Variables:
> + * fcf_mac, eth.smac, mac_desc.enode_mac
> + */
> +struct fip_flogi_s fip_flogi_tmpl = {
> +	.eth = {
> +			.eth_type = FIP_ETH_TYPE_LE},
> +	.fip = {
> +			.ver = 0x10,
> +			.protocol = FIP_FLOGI << 8,
> +			.subcode = FIP_SUBCODE_REQ << 8,
> +			.desc_len = 38 << 8,
> +			.flags = 0x80},
> +	.flogi_desc = {
> +				   .type = FIP_TYPE_FLOGI, .len = 36,
> +				   .flogi = {
> +							 .fchdr = {
> +							   .r_ctl = 0x22,
> +							   .did = {0xFF, 0xFF, 0xFE},
> +							   .type = 0x01,
> +							   .f_ctl = FNIC_ELS_REQ_FCTL,
> +							   .ox_id = FNIC_FLOGI_OXID,
> +							   .rx_id = 0xFFFF},
> +							 .command = FC_ELS_FLOGI_REQ,
> +							 .u.csp_flogi = {
> +								 .fc_ph_ver = FNIC_FC_PH_VER,
> +								 .b2b_credits =
> +								 FNIC_FC_B2B_CREDIT,
> +								 .b2b_rdf_size =
> +								 FNIC_FC_B2B_RDF_SZ},
> +							 .spc3 = {0x88, 0x00}
> +							}
> +				   },
> +	.mac_desc = {.type = FIP_TYPE_MAC, .len = 2}
> +};
> +
> +struct fip_fcoe_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint16_t max_fcoe_size;
> +} __packed;
> +
> +struct fip_discovery_s {
> +	struct eth_hdr_s eth;
> +	struct fip_header_s fip;
> +	struct fip_mac_desc_s mac_desc;
> +	struct fip_name_desc_s name_desc;
> +	struct fip_fcoe_desc_s fcoe_desc;
> +} __packed;
> +
> +/*
> + * Variables:
> + * eth.smac, mac_desc.enode_mac, node_name
> + */
> +struct fip_discovery_s fip_discovery_tmpl = {
> +	.eth = {.dmac = FCOE_ALL_FCFS_MAC,
> +			.eth_type = FIP_ETH_TYPE_LE},
> +	.fip = {
> +			.ver = 0x10, .protocol = FIP_DISCOVERY << 8,
> +			.subcode = FIP_SUBCODE_REQ << 8, .desc_len = 6 << 8,
> +			.flags = 0x80},
> +	.mac_desc = {.type = FIP_TYPE_MAC, .len = 2},
> +	.name_desc = {.type = FIP_TYPE_NAME_ID, .len = 3},
> +	.fcoe_desc = {
> +				  .type = FIP_TYPE_MAX_FCOE, .len = 1,
> +				  .max_fcoe_size = FCOE_MAX_SIZE_LE}
> +};
> +
> +struct fip_prio_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint8_t rsvd;
> +	uint8_t priority;
> +} __packed;
> +
> +struct fip_fabric_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint16_t vf_id;
> +	uint8_t rsvd;
> +	uint8_t fc_map[3];
> +	uint64_t fabric_name;
> +} __packed;
> +
> +struct fip_fka_adv_desc_s {
> +	uint8_t type;
> +	uint8_t len;
> +	uint8_t rsvd;
> +	uint8_t rsvd_D;
> +	uint32_t fka_adv;
> +} __packed;
> +
> +struct fip_disc_adv_s {
> +	struct fip_header_s fip;
> +	struct fip_prio_desc_s prio_desc;
> +	struct fip_mac_desc_s mac_desc;
> +	struct fip_name_desc_s name_desc;
> +	struct fip_fabric_desc_s fabric_desc;
> +	struct fip_fka_adv_desc_s fka_adv_desc;
> +} __packed;
> +
> +void fnic_fcoe_process_vlan_resp(struct fnic *fnic,
> +								 struct fip_header_s *fiph);
> +void fnic_fcoe_fip_discovery_resp(struct fnic *fnic,
> +								  struct fip_header_s *fiph);
> +void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
> +								  struct fip_header_s *fiph);
> +void fnic_work_on_fip_timer(struct work_struct *work);
> +void fnic_work_on_fcs_ka_timer(struct work_struct *work);
> +void fnic_fcoe_send_vlan_req(struct fnic *fnic);
> +void fnic_fcoe_start_fcf_discovery(struct fnic *fnic);
> +void fnic_fcoe_start_flogi(struct fnic *fnic);
> +void fnic_fcoe_process_cvl(struct fnic *fnic,
> +							struct fip_header_s *fiph);
> +void fnic_vlan_discovery_timeout(struct fnic *fnic);
> +
> +#endif							/* _FIP_H_ */
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 7d7009197dbc..0c7926627663 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -230,6 +230,12 @@ do {								\
>   				"fnic<%d>: %s: %d: " fmt, fnic_num,\
>   				__func__, __LINE__, ##args);)
>   
> +#define FNIC_FIP_DBG(kern_level, host, fnic_num, fmt, args...)		\
> +	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,			\
> +			 shost_printk(kern_level, host,			\
> +				"fnic<%d>: %s: %d: " fmt, fnic_num,\
> +				__func__, __LINE__, ##args);)
> +
>   #define FNIC_SCSI_DBG(kern_level, host, fnic_num, fmt, args...)		\
>   	FNIC_CHECK_LOGGING(FNIC_SCSI_LOGGING,			\
>   			 shost_printk(kern_level, host,			\
> @@ -406,13 +412,15 @@ struct fnic {
>   	/*** FIP related data members  -- start ***/
>   	void (*set_vlan)(struct fnic *, u16 vlan);
>   	struct work_struct      fip_frame_work;
> -	struct sk_buff_head     fip_frame_queue;
> +	struct work_struct		fip_timer_work;
> +	struct list_head		fip_frame_queue;
>   	struct timer_list       fip_timer;
> -	struct list_head        vlans;
>   	spinlock_t              vlans_lock;
> -
> -	struct work_struct      event_work;
> -	struct list_head        evlist;
> +	struct timer_list retry_fip_timer;
> +	struct timer_list fcs_ka_timer;
> +	struct timer_list enode_ka_timer;
> +	struct timer_list vn_ka_timer;
> +	struct list_head vlan_list;
>   	/*** FIP related data members  -- end ***/
>   
>   	/* copy work queue cache line section */
> @@ -462,9 +470,6 @@ int fnic_rq_cmpl_handler(struct fnic *fnic, int);
>   int fnic_alloc_rq_frame(struct vnic_rq *rq);
>   void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf);
>   void fnic_flush_tx(struct work_struct *work);
> -void fnic_eth_send(struct fcoe_ctlr *, struct sk_buff *skb);
> -void fnic_set_port_id(struct fc_lport *, u32, struct fc_frame *);
> -void fnic_update_mac(struct fc_lport *, u8 *new);
>   void fnic_update_mac_locked(struct fnic *, u8 *new);
>   
>   int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
> @@ -493,7 +498,7 @@ int fnic_is_abts_pending(struct fnic *, struct scsi_cmnd *);
>   void fnic_handle_fip_frame(struct work_struct *work);
>   void fnic_handle_fip_event(struct fnic *fnic);
>   void fnic_fcoe_reset_vlans(struct fnic *fnic);
> -void fnic_fcoe_evlist_free(struct fnic *fnic);
> +extern void fnic_handle_fip_timer(struct timer_list *t);
>   
>   static inline int
>   fnic_chk_state_flags_locked(struct fnic *fnic, unsigned long st_flags)
> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index 90d0c4c8920c..8a7c471d3ff5 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -25,16 +25,9 @@
>   #include "cq_enet_desc.h"
>   #include "cq_exch_desc.h"
>   
> -static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
> -struct workqueue_struct *fnic_fip_queue;
> +extern struct workqueue_struct *fnic_fip_queue;
>   struct workqueue_struct *fnic_event_queue;
>   
> -static void fnic_set_eth_mode(struct fnic *);
> -static void fnic_fcoe_start_fcf_disc(struct fnic *fnic);
> -static void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct sk_buff *);
> -static int fnic_fcoe_vlan_check(struct fnic *fnic, u16 flag);
> -static int fnic_fcoe_handle_fip_frame(struct fnic *fnic, struct sk_buff *skb);
> -
>   /* Frame initialization */
>   /*
>    * Variables:
> @@ -252,11 +245,6 @@ void fnic_handle_link(struct work_struct *work)
>   			fnic->lport->host->host_no, FNIC_FC_LE,
>   			"Link Status: UP_DOWN",
>   			strlen("Link Status: UP_DOWN"));
> -		if (fnic->config.flags & VFCF_FIP_CAPABLE) {
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
> -				"deleting fip-timer during link-down\n");
> -			del_timer_sync(&fnic->fip_timer);
> -		}
>   		fcoe_ctlr_link_down(&fnic->ctlr);
>   	}
>   
> @@ -299,496 +287,73 @@ void fnic_handle_frame(struct work_struct *work)
>   	}
>   }
>   
> -void fnic_fcoe_evlist_free(struct fnic *fnic)
> -{
> -	struct fnic_event *fevt = NULL;
> -	struct fnic_event *next = NULL;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&fnic->fnic_lock, flags);
> -	if (list_empty(&fnic->evlist)) {
> -		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -		return;
> -	}
> -
> -	list_for_each_entry_safe(fevt, next, &fnic->evlist, list) {
> -		list_del(&fevt->list);
> -		kfree(fevt);
> -	}
> -	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -}
> -
> -void fnic_handle_event(struct work_struct *work)
> +void fnic_handle_fip_frame(struct work_struct *work)
>   {
> -	struct fnic *fnic = container_of(work, struct fnic, event_work);
> -	struct fnic_event *fevt = NULL;
> -	struct fnic_event *next = NULL;
> -	unsigned long flags;
> +	struct fnic_stats *fnic_stats;
> +	struct fnic_frame_list *cur_frame, *next;
> +	struct fnic *fnic = container_of(work, struct fnic, fip_frame_work);
>   
> -	spin_lock_irqsave(&fnic->fnic_lock, flags);
> -	if (list_empty(&fnic->evlist)) {
> -		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -		return;
> -	}
> +	fnic_stats = &fnic->fnic_stats;
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Processing FIP frame\n");
>   
> -	list_for_each_entry_safe(fevt, next, &fnic->evlist, list) {
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +	list_for_each_entry_safe(cur_frame, next, &fnic->fip_frame_queue,
> +							 links) {
>   		if (fnic->stop_rx_link_events) {
> -			list_del(&fevt->list);
> -			kfree(fevt);
> -			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +			list_del(&cur_frame->links);
> +			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +			kfree(cur_frame->fp);
> +			kfree(cur_frame);
>   			return;
>   		}
> +
>   		/*
>   		 * If we're in a transitional state, just re-queue and return.
>   		 * The queue will be serviced when we get to a stable state.
>   		 */
>   		if (fnic->state != FNIC_IN_FC_MODE &&
> -		    fnic->state != FNIC_IN_ETH_MODE) {
> -			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +			fnic->state != FNIC_IN_ETH_MODE) {
> +			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
>   			return;
>   		}
>   
> -		list_del(&fevt->list);
> -		switch (fevt->event) {
> -		case FNIC_EVT_START_VLAN_DISC:
> -			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -			fnic_fcoe_send_vlan_req(fnic);
> -			spin_lock_irqsave(&fnic->fnic_lock, flags);
> -			break;
> -		case FNIC_EVT_START_FCF_DISC:
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
> -				  "Start FCF Discovery\n");
> -			fnic_fcoe_start_fcf_disc(fnic);
> -			break;
> -		default:
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
> -				  "Unknown event 0x%x\n", fevt->event);
> -			break;
> -		}
> -		kfree(fevt);
> -	}
> -	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -}
> -
> -/**
> - * is_fnic_fip_flogi_reject() - Check if the Received FIP FLOGI frame is rejected
> - * @fip: The FCoE controller that received the frame
> - * @skb: The received FIP frame
> - *
> - * Returns non-zero if the frame is rejected with unsupported cmd with
> - * insufficient resource els explanation.
> - */
> -static inline int is_fnic_fip_flogi_reject(struct fcoe_ctlr *fip,
> -					 struct sk_buff *skb)
> -{
> -	struct fc_lport *lport = fip->lp;
> -	struct fip_header *fiph;
> -	struct fc_frame_header *fh = NULL;
> -	struct fip_desc *desc;
> -	struct fip_encaps *els;
> -	u16 op;
> -	u8 els_op;
> -	u8 sub;
> -
> -	size_t rlen;
> -	size_t dlen = 0;
> -
> -	if (skb_linearize(skb))
> -		return 0;
> -
> -	if (skb->len < sizeof(*fiph))
> -		return 0;
> -
> -	fiph = (struct fip_header *)skb->data;
> -	op = ntohs(fiph->fip_op);
> -	sub = fiph->fip_subcode;
> -
> -	if (op != FIP_OP_LS)
> -		return 0;
> -
> -	if (sub != FIP_SC_REP)
> -		return 0;
> -
> -	rlen = ntohs(fiph->fip_dl_len) * 4;
> -	if (rlen + sizeof(*fiph) > skb->len)
> -		return 0;
> -
> -	desc = (struct fip_desc *)(fiph + 1);
> -	dlen = desc->fip_dlen * FIP_BPW;
> -
> -	if (desc->fip_dtype == FIP_DT_FLOGI) {
> -
> -		if (dlen < sizeof(*els) + sizeof(*fh) + 1)
> -			return 0;
> -
> -		els = (struct fip_encaps *)desc;
> -		fh = (struct fc_frame_header *)(els + 1);
> -
> -		if (!fh)
> -			return 0;
> -
> -		/*
> -		 * ELS command code, reason and explanation should be = Reject,
> -		 * unsupported command and insufficient resource
> -		 */
> -		els_op = *(u8 *)(fh + 1);
> -		if (els_op == ELS_LS_RJT) {
> -			shost_printk(KERN_INFO, lport->host,
> -				  "Flogi Request Rejected by Switch\n");
> -			return 1;
> -		}
> -		shost_printk(KERN_INFO, lport->host,
> -				"Flogi Request Accepted by Switch\n");
> -	}
> -	return 0;
> -}
> -
> -void fnic_fcoe_send_vlan_req(struct fnic *fnic)

why is so much being deleted?


> -{
> -	struct fcoe_ctlr *fip = &fnic->ctlr;
> -	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
> -	struct sk_buff *skb;
> -	char *eth_fr;
> -	struct fip_vlan *vlan;
> -	u64 vlan_tov;
> -
> -	fnic_fcoe_reset_vlans(fnic);
> -	fnic->set_vlan(fnic, 0);
> -
> -	if (printk_ratelimit())
> -		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> -			  "Sending VLAN request...\n");
> -
> -	skb = dev_alloc_skb(sizeof(struct fip_vlan));
> -	if (!skb)
> -		return;
> -
> -	eth_fr = (char *)skb->data;
> -	vlan = (struct fip_vlan *)eth_fr;
> -
> -	memset(vlan, 0, sizeof(*vlan));
> -	memcpy(vlan->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
> -	memcpy(vlan->eth.h_dest, fcoe_all_fcfs, ETH_ALEN);
> -	vlan->eth.h_proto = htons(ETH_P_FIP);
> -
> -	vlan->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
> -	vlan->fip.fip_op = htons(FIP_OP_VLAN);
> -	vlan->fip.fip_subcode = FIP_SC_VL_REQ;
> -	vlan->fip.fip_dl_len = htons(sizeof(vlan->desc) / FIP_BPW);
> -
> -	vlan->desc.mac.fd_desc.fip_dtype = FIP_DT_MAC;
> -	vlan->desc.mac.fd_desc.fip_dlen = sizeof(vlan->desc.mac) / FIP_BPW;
> -	memcpy(&vlan->desc.mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
> -
> -	vlan->desc.wwnn.fd_desc.fip_dtype = FIP_DT_NAME;
> -	vlan->desc.wwnn.fd_desc.fip_dlen = sizeof(vlan->desc.wwnn) / FIP_BPW;
> -	put_unaligned_be64(fip->lp->wwnn, &vlan->desc.wwnn.fd_wwn);
> -	atomic64_inc(&fnic_stats->vlan_stats.vlan_disc_reqs);
> -
> -	skb_put(skb, sizeof(*vlan));
> -	skb->protocol = htons(ETH_P_FIP);
> -	skb_reset_mac_header(skb);
> -	skb_reset_network_header(skb);
> -	fip->send(fip, skb);
> -
> -	/* set a timer so that we can retry if there no response */
> -	vlan_tov = jiffies + msecs_to_jiffies(FCOE_CTLR_FIPVLAN_TOV);
> -	mod_timer(&fnic->fip_timer, round_jiffies(vlan_tov));
> -}
> -
> -static void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct sk_buff *skb)
> -{
> -	struct fcoe_ctlr *fip = &fnic->ctlr;
> -	struct fip_header *fiph;
> -	struct fip_desc *desc;
> -	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
> -	u16 vid;
> -	size_t rlen;
> -	size_t dlen;
> -	struct fcoe_vlan *vlan;
> -	u64 sol_time;
> -	unsigned long flags;
> -
> -	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> -		  "Received VLAN response...\n");
> -
> -	fiph = (struct fip_header *) skb->data;
> -
> -	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> -		  "Received VLAN response... OP 0x%x SUB_OP 0x%x\n",
> -		  ntohs(fiph->fip_op), fiph->fip_subcode);
> -
> -	rlen = ntohs(fiph->fip_dl_len) * 4;
> -	fnic_fcoe_reset_vlans(fnic);
> -	spin_lock_irqsave(&fnic->vlans_lock, flags);
> -	desc = (struct fip_desc *)(fiph + 1);
> -	while (rlen > 0) {
> -		dlen = desc->fip_dlen * FIP_BPW;
> -		switch (desc->fip_dtype) {
> -		case FIP_DT_VLAN:
> -			vid = ntohs(((struct fip_vlan_desc *)desc)->fd_vlan);
> -			shost_printk(KERN_INFO, fnic->lport->host,
> -				  "process_vlan_resp: FIP VLAN %d\n", vid);
> -			vlan = kzalloc(sizeof(*vlan), GFP_ATOMIC);
> -			if (!vlan) {
> -				/* retry from timer */
> -				spin_unlock_irqrestore(&fnic->vlans_lock,
> -							flags);
> -				goto out;
> -			}
> -			vlan->vid = vid & 0x0fff;
> -			vlan->state = FIP_VLAN_AVAIL;
> -			list_add_tail(&vlan->list, &fnic->vlans);
> -			break;
> -		}
> -		desc = (struct fip_desc *)((char *)desc + dlen);
> -		rlen -= dlen;
> -	}
> -
> -	/* any VLAN descriptors present ? */
> -	if (list_empty(&fnic->vlans)) {
> -		/* retry from timer */
> -		atomic64_inc(&fnic_stats->vlan_stats.resp_withno_vlanID);
> -		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> -			  "No VLAN descriptors in FIP VLAN response\n");
> -		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> -		goto out;
> -	}
> -
> -	vlan = list_first_entry(&fnic->vlans, struct fcoe_vlan, list);
> -	fnic->set_vlan(fnic, vlan->vid);
> -	vlan->state = FIP_VLAN_SENT; /* sent now */
> -	vlan->sol_count++;
> -	spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> -
> -	/* start the solicitation */
> -	fcoe_ctlr_link_up(fip);
> -
> -	sol_time = jiffies + msecs_to_jiffies(FCOE_CTLR_START_DELAY);
> -	mod_timer(&fnic->fip_timer, round_jiffies(sol_time));
> -out:
> -	return;
> -}
> -
> -static void fnic_fcoe_start_fcf_disc(struct fnic *fnic)
> -{
> -	unsigned long flags;
> -	struct fcoe_vlan *vlan;
> -	u64 sol_time;
> -
> -	spin_lock_irqsave(&fnic->vlans_lock, flags);
> -	vlan = list_first_entry(&fnic->vlans, struct fcoe_vlan, list);
> -	fnic->set_vlan(fnic, vlan->vid);
> -	vlan->state = FIP_VLAN_SENT; /* sent now */
> -	vlan->sol_count = 1;
> -	spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> -
> -	/* start the solicitation */
> -	fcoe_ctlr_link_up(&fnic->ctlr);
> -
> -	sol_time = jiffies + msecs_to_jiffies(FCOE_CTLR_START_DELAY);
> -	mod_timer(&fnic->fip_timer, round_jiffies(sol_time));
> -}
> -
> -static int fnic_fcoe_vlan_check(struct fnic *fnic, u16 flag)
> -{
> -	unsigned long flags;
> -	struct fcoe_vlan *fvlan;
> -
> -	spin_lock_irqsave(&fnic->vlans_lock, flags);
> -	if (list_empty(&fnic->vlans)) {
> -		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> -		return -EINVAL;
> -	}
> -
> -	fvlan = list_first_entry(&fnic->vlans, struct fcoe_vlan, list);
> -	if (fvlan->state == FIP_VLAN_USED) {
> -		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> -		return 0;
> -	}
> -
> -	if (fvlan->state == FIP_VLAN_SENT) {
> -		fvlan->state = FIP_VLAN_USED;
> -		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> -		return 0;
> -	}
> -	spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> -	return -EINVAL;
> -}
> -
> -static void fnic_event_enq(struct fnic *fnic, enum fnic_evt ev)
> -{
> -	struct fnic_event *fevt;
> -	unsigned long flags;

it's very hard to review so much code being deleted....

> -
> -	fevt = kmalloc(sizeof(*fevt), GFP_ATOMIC);
> -	if (!fevt)
> -		return;
> -
> -	fevt->fnic = fnic;
> -	fevt->event = ev;
> -
> -	spin_lock_irqsave(&fnic->fnic_lock, flags);
> -	list_add_tail(&fevt->list, &fnic->evlist);
> -	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -
> -	schedule_work(&fnic->event_work);
> -}
> -
> -static int fnic_fcoe_handle_fip_frame(struct fnic *fnic, struct sk_buff *skb)
> -{
> -	struct fip_header *fiph;
> -	int ret = 1;
> -	u16 op;
> -	u8 sub;
> -
> -	if (!skb || !(skb->data))
> -		return -1;
> -
> -	if (skb_linearize(skb))
> -		goto drop;
> -
> -	fiph = (struct fip_header *)skb->data;
> -	op = ntohs(fiph->fip_op);
> -	sub = fiph->fip_subcode;
> -
> -	if (FIP_VER_DECAPS(fiph->fip_ver) != FIP_VER)
> -		goto drop;
> -
> -	if (ntohs(fiph->fip_dl_len) * FIP_BPW + sizeof(*fiph) > skb->len)
> -		goto drop;
> -
> -	if (op == FIP_OP_DISC && sub == FIP_SC_ADV) {
> -		if (fnic_fcoe_vlan_check(fnic, ntohs(fiph->fip_flags)))
> -			goto drop;
> -		/* pass it on to fcoe */
> -		ret = 1;
> -	} else if (op == FIP_OP_VLAN && sub == FIP_SC_VL_NOTE) {
> -		/* set the vlan as used */
> -		fnic_fcoe_process_vlan_resp(fnic, skb);
> -		ret = 0;
> -	} else if (op == FIP_OP_CTRL && sub == FIP_SC_CLR_VLINK) {
> -		/* received CVL request, restart vlan disc */
> -		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
> -		/* pass it on to fcoe */
> -		ret = 1;
> -	}
> -drop:
> -	return ret;
> -}
> -
> -void fnic_handle_fip_frame(struct work_struct *work)
> -{
> -	struct fnic *fnic = container_of(work, struct fnic, fip_frame_work);
> -	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
> -	unsigned long flags;
> -	struct sk_buff *skb;
> -	struct ethhdr *eh;
> +		list_del(&cur_frame->links);
>   
> -	while ((skb = skb_dequeue(&fnic->fip_frame_queue))) {
> -		spin_lock_irqsave(&fnic->fnic_lock, flags);
> -		if (fnic->stop_rx_link_events) {
> -			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -			dev_kfree_skb(skb);
> -			return;
> -		}
> -		/*
> -		 * If we're in a transitional state, just re-queue and return.
> -		 * The queue will be serviced when we get to a stable state.
> -		 */
> -		if (fnic->state != FNIC_IN_FC_MODE &&
> -		    fnic->state != FNIC_IN_ETH_MODE) {
> -			skb_queue_head(&fnic->fip_frame_queue, skb);
> -			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -			return;
> -		}
> -		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -		eh = (struct ethhdr *)skb->data;
> -		if (eh->h_proto == htons(ETH_P_FIP)) {
> -			skb_pull(skb, sizeof(*eh));
> -			if (fnic_fcoe_handle_fip_frame(fnic, skb) <= 0) {
> -				dev_kfree_skb(skb);
> -				continue;
> -			}
> -			/*
> -			 * If there's FLOGI rejects - clear all
> -			 * fcf's & restart from scratch
> -			 */
> -			if (is_fnic_fip_flogi_reject(&fnic->ctlr, skb)) {
> -				atomic64_inc(
> -					&fnic_stats->vlan_stats.flogi_rejects);
> -				shost_printk(KERN_INFO, fnic->lport->host,
> -					  "Trigger a Link down - VLAN Disc\n");
> -				fcoe_ctlr_link_down(&fnic->ctlr);
> -				/* start FCoE VLAN discovery */
> -				fnic_fcoe_send_vlan_req(fnic);
> -				dev_kfree_skb(skb);
> -				continue;
> -			}
> -			fcoe_ctlr_recv(&fnic->ctlr, skb);
> -			continue;
> +		if (fdls_fip_recv_frame(fnic, cur_frame->fp)) {
> +			kfree(cur_frame->fp);
> +			kfree(cur_frame);
>   		}
>   	}
> +	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
>   }
>   
>   /**
>    * fnic_import_rq_eth_pkt() - handle received FCoE or FIP frame.
>    * @fnic:	fnic instance.
> - * @skb:	Ethernet Frame.
> + * @fp:		Ethernet Frame.
>    */
> -static inline int fnic_import_rq_eth_pkt(struct fnic *fnic, struct sk_buff *skb)
> +static inline int fnic_import_rq_eth_pkt(struct fnic *fnic, void *fp)
>   {
> -	struct fc_frame *fp;
> -	struct ethhdr *eh;
> -	struct fcoe_hdr *fcoe_hdr;
> -	struct fcoe_crc_eof *ft;
> +	struct fnic_eth_hdr_s *eh;
> +	struct fnic_frame_list *fip_fr_elem;
> +	unsigned long flags;
>   
> -	/*
> -	 * Undo VLAN encapsulation if present.
> -	 */
> -	eh = (struct ethhdr *)skb->data;
> -	if (eh->h_proto == htons(ETH_P_8021Q)) {
> -		memmove((u8 *)eh + VLAN_HLEN, eh, ETH_ALEN * 2);
> -		eh = skb_pull(skb, VLAN_HLEN);
> -		skb_reset_mac_header(skb);
> -	}
> -	if (eh->h_proto == htons(ETH_P_FIP)) {
> -		if (!(fnic->config.flags & VFCF_FIP_CAPABLE)) {
> -			printk(KERN_ERR "Dropped FIP frame, as firmware "
> -					"uses non-FIP mode, Enable FIP "
> -					"using UCSM\n");
> -			goto drop;
> -		}
> -		if ((fnic_fc_trace_set_data(fnic->lport->host->host_no,
> -			FNIC_FC_RECV|0x80, (char *)skb->data, skb->len)) != 0) {
> -			printk(KERN_ERR "fnic ctlr frame trace error!!!");
> -		}
> -		skb_queue_tail(&fnic->fip_frame_queue, skb);
> +	eh = (struct fnic_eth_hdr_s *) fp;
> +	if ((eh->ether_type == htons(ETH_TYPE_FIP)) && (fnic->iport.usefip)) {
> +		fip_fr_elem = (struct fnic_frame_list *)
> +			kmalloc(sizeof(struct fnic_frame_list), GFP_ATOMIC);
> +		if (!fip_fr_elem)
> +			return 0;
> +		memset(fip_fr_elem, 0, sizeof(struct fnic_frame_list));
> +		fip_fr_elem->fp = fp;
> +		spin_lock_irqsave(&fnic->fnic_lock, flags);
> +		list_add_tail(&fip_fr_elem->links, &fnic->fip_frame_queue);
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>   		queue_work(fnic_fip_queue, &fnic->fip_frame_work);
> -		return 1;		/* let caller know packet was used */
> -	}
> -	if (eh->h_proto != htons(ETH_P_FCOE))
> -		goto drop;
> -	skb_set_network_header(skb, sizeof(*eh));
> -	skb_pull(skb, sizeof(*eh));
> -
> -	fcoe_hdr = (struct fcoe_hdr *)skb->data;
> -	if (FC_FCOE_DECAPS_VER(fcoe_hdr) != FC_FCOE_VER)
> -		goto drop;
> -
> -	fp = (struct fc_frame *)skb;
> -	fc_frame_init(fp);
> -	fr_sof(fp) = fcoe_hdr->fcoe_sof;
> -	skb_pull(skb, sizeof(struct fcoe_hdr));
> -	skb_reset_transport_header(skb);
> -
> -	ft = (struct fcoe_crc_eof *)(skb->data + skb->len - sizeof(*ft));
> -	fr_eof(fp) = ft->fcoe_eof;
> -	skb_trim(skb, skb->len - sizeof(*ft));
> -	return 0;
> -drop:
> -	dev_kfree_skb_irq(skb);
> -	return -1;
> +		return 1;				/* let caller know packet was used */
> +	} else
> +		return 0;
>   }
>   
>   /**
> @@ -800,206 +365,146 @@ static inline int fnic_import_rq_eth_pkt(struct fnic *fnic, struct sk_buff *skb)
>    */
>   void fnic_update_mac_locked(struct fnic *fnic, u8 *new)
>   {
> -	u8 *ctl = fnic->ctlr.ctl_src_addr;
> +	struct fnic_iport_s *iport = &fnic->iport;
> +	u8 *ctl = iport->hwmac;
>   	u8 *data = fnic->data_src_addr;
>   
>   	if (is_zero_ether_addr(new))
>   		new = ctl;
>   	if (ether_addr_equal(data, new))
>   		return;
> -	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
> -			"update_mac %pM\n", new);
> +
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Update MAC: %u\n", *new);
> +
>   	if (!is_zero_ether_addr(data) && !ether_addr_equal(data, ctl))
>   		vnic_dev_del_addr(fnic->vdev, data);
> +
>   	memcpy(data, new, ETH_ALEN);
>   	if (!ether_addr_equal(new, ctl))
>   		vnic_dev_add_addr(fnic->vdev, new);
>   }
>   
> -/**
> - * fnic_update_mac() - set data MAC address and filters.
> - * @lport:	local port.
> - * @new:	newly-assigned FCoE MAC address.
> - */
> -void fnic_update_mac(struct fc_lport *lport, u8 *new)
> -{
> -	struct fnic *fnic = lport_priv(lport);
> -
> -	spin_lock_irq(&fnic->fnic_lock);
> -	fnic_update_mac_locked(fnic, new);
> -	spin_unlock_irq(&fnic->fnic_lock);
> -}
> -
> -/**
> - * fnic_set_port_id() - set the port_ID after successful FLOGI.
> - * @lport:	local port.
> - * @port_id:	assigned FC_ID.
> - * @fp:		received frame containing the FLOGI accept or NULL.
> - *
> - * This is called from libfc when a new FC_ID has been assigned.
> - * This causes us to reset the firmware to FC_MODE and setup the new MAC
> - * address and FC_ID.
> - *
> - * It is also called with FC_ID 0 when we're logged off.
> - *
> - * If the FC_ID is due to point-to-point, fp may be NULL.
> - */
> -void fnic_set_port_id(struct fc_lport *lport, u32 port_id, struct fc_frame *fp)
> -{
> -	struct fnic *fnic = lport_priv(lport);
> -	u8 *mac;
> -	int ret;
> -
> -	FNIC_FCS_DBG(KERN_DEBUG, lport->host, fnic->fnic_num,
> -			"set port_id 0x%x fp 0x%p\n",
> -			port_id, fp);
> -
> -	/*
> -	 * If we're clearing the FC_ID, change to use the ctl_src_addr.
> -	 * Set ethernet mode to send FLOGI.
> -	 */
> -	if (!port_id) {
> -		fnic_update_mac(lport, fnic->ctlr.ctl_src_addr);
> -		fnic_set_eth_mode(fnic);
> -		return;
> -	}
> -
> -	if (fp) {
> -		mac = fr_cb(fp)->granted_mac;
> -		if (is_zero_ether_addr(mac)) {
> -			/* non-FIP - FLOGI already accepted - ignore return */
> -			fcoe_ctlr_recv_flogi(&fnic->ctlr, lport, fp);
> -		}
> -		fnic_update_mac(lport, mac);
> -	}
> -
> -	/* Change state to reflect transition to FC mode */
> -	spin_lock_irq(&fnic->fnic_lock);
> -	if (fnic->state == FNIC_IN_ETH_MODE || fnic->state == FNIC_IN_FC_MODE)
> -		fnic->state = FNIC_IN_ETH_TRANS_FC_MODE;
> -	else {
> -		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> -			     "Unexpected fnic state: %s processing FLOGI response",
> -				 fnic_state_to_str(fnic->state));
> -		spin_unlock_irq(&fnic->fnic_lock);
> -		return;
> -	}
> -	spin_unlock_irq(&fnic->fnic_lock);
> -
> -	/*
> -	 * Send FLOGI registration to firmware to set up FC mode.
> -	 * The new address will be set up when registration completes.
> -	 */
> -	ret = fnic_flogi_reg_handler(fnic, port_id);
> -
> -	if (ret < 0) {
> -		spin_lock_irq(&fnic->fnic_lock);
> -		if (fnic->state == FNIC_IN_ETH_TRANS_FC_MODE)
> -			fnic->state = FNIC_IN_ETH_MODE;
> -		spin_unlock_irq(&fnic->fnic_lock);
> -	}
> -}
> -
>   static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
>   				    *cq_desc, struct vnic_rq_buf *buf,
>   				    int skipped __attribute__((unused)),
>   				    void *opaque)
>   {
>   	struct fnic *fnic = vnic_dev_priv(rq->vdev);
> -	struct sk_buff *skb;
> -	struct fc_frame *fp;
> +	uint8_t *fp;
>   	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
> +	unsigned int ethhdr_stripped;
>   	u8 type, color, eop, sop, ingress_port, vlan_stripped;
> -	u8 fcoe = 0, fcoe_sof, fcoe_eof;
> -	u8 fcoe_fc_crc_ok = 1, fcoe_enc_error = 0;
> -	u8 tcp_udp_csum_ok, udp, tcp, ipv4_csum_ok;
> -	u8 ipv6, ipv4, ipv4_fragment, rss_type, csum_not_calc;
> +	u8 fcoe_fnic_crc_ok = 1, fcoe_enc_error = 0;
>   	u8 fcs_ok = 1, packet_error = 0;
> -	u16 q_number, completed_index, bytes_written = 0, vlan, checksum;
> +	u16 q_number, completed_index, vlan;
>   	u32 rss_hash;
> +	u16 checksum;
> +	u8 csum_not_calc, rss_type, ipv4, ipv6, ipv4_fragment;
> +	u8 tcp_udp_csum_ok, udp, tcp, ipv4_csum_ok;
> +	u8 fcoe = 0, fcoe_sof, fcoe_eof;
>   	u16 exchange_id, tmpl;
>   	u8 sof = 0;
>   	u8 eof = 0;
>   	u32 fcp_bytes_written = 0;
> +	u16 enet_bytes_written = 0;
> +	u32 bytes_written = 0;
>   	unsigned long flags;
> +	struct fnic_frame_list *frame_elem = NULL;
> +	struct fnic_eth_hdr_s *eh;

so many local variables tells me that this function is too big without 
even looking at it further

>   
>   	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
> -			 DMA_FROM_DEVICE);
> -	skb = buf->os_buf;
> -	fp = (struct fc_frame *)skb;
> +					 DMA_FROM_DEVICE);
> +	fp = (uint8_t *) buf->os_buf;
>   	buf->os_buf = NULL;
>   
>   	cq_desc_dec(cq_desc, &type, &color, &q_number, &completed_index);
>   	if (type == CQ_DESC_TYPE_RQ_FCP) {
> -		cq_fcp_rq_desc_dec((struct cq_fcp_rq_desc *)cq_desc,
> -				   &type, &color, &q_number, &completed_index,
> -				   &eop, &sop, &fcoe_fc_crc_ok, &exchange_id,
> -				   &tmpl, &fcp_bytes_written, &sof, &eof,
> -				   &ingress_port, &packet_error,
> -				   &fcoe_enc_error, &fcs_ok, &vlan_stripped,
> -				   &vlan);
> -		skb_trim(skb, fcp_bytes_written);
> -		fr_sof(fp) = sof;
> -		fr_eof(fp) = eof;
> -
> +		cq_fcp_rq_desc_dec((struct cq_fcp_rq_desc *) cq_desc, &type,
> +						   &color, &q_number, &completed_index, &eop, &sop,
> +						   &fcoe_fnic_crc_ok, &exchange_id, &tmpl,
> +						   &fcp_bytes_written, &sof, &eof, &ingress_port,
> +						   &packet_error, &fcoe_enc_error, &fcs_ok,
> +						   &vlan_stripped, &vlan);
> +		ethhdr_stripped = 1;
> +		bytes_written = fcp_bytes_written;
>   	} else if (type == CQ_DESC_TYPE_RQ_ENET) {
> -		cq_enet_rq_desc_dec((struct cq_enet_rq_desc *)cq_desc,
> -				    &type, &color, &q_number, &completed_index,
> -				    &ingress_port, &fcoe, &eop, &sop,
> -				    &rss_type, &csum_not_calc, &rss_hash,
> -				    &bytes_written, &packet_error,
> -				    &vlan_stripped, &vlan, &checksum,
> -				    &fcoe_sof, &fcoe_fc_crc_ok,
> -				    &fcoe_enc_error, &fcoe_eof,
> -				    &tcp_udp_csum_ok, &udp, &tcp,
> -				    &ipv4_csum_ok, &ipv6, &ipv4,
> -				    &ipv4_fragment, &fcs_ok);

I think that cq_enet_rq_desc_dec() accepts too many arguments, to say 
the least

I also could not help but notice that there is a cq_enet_rq_desc_dec() 
in this driver and also one in 
drivers/net/ethernet/cisco/enic/cq_enet_desc.h - could they be made common?

> -		skb_trim(skb, bytes_written);
> +		cq_enet_rq_desc_dec((struct cq_enet_rq_desc *) cq_desc, &type,
> +					&color, &q_number, &completed_index,
> +					&ingress_port, &fcoe, &eop, &sop, &rss_type,
> +					&csum_not_calc, &rss_hash, &enet_bytes_written,
> +					&packet_error, &vlan_stripped, &vlan,
> +					&checksum, &fcoe_sof, &fcoe_fnic_crc_ok,
> +					&fcoe_enc_error, &fcoe_eof, &tcp_udp_csum_ok,
> +					&udp, &tcp, &ipv4_csum_ok, &ipv6, &ipv4,
> +					&ipv4_fragment, &fcs_ok);
> +
> +		ethhdr_stripped = 0;
> +		bytes_written = enet_bytes_written;
> +
>   		if (!fcs_ok) {
>   			atomic64_inc(&fnic_stats->misc_stats.frame_errors);
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
> -				     "fcs error.  dropping packet.\n");
> +			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +						 "fnic 0x%p fcs error.  Dropping packet.\n", fnic);
>   			goto drop;
>   		}
> -		if (fnic_import_rq_eth_pkt(fnic, skb))
> -			return;
> +		eh = (struct fnic_eth_hdr_s *) fp;
> +		if (eh->ether_type != htons(ETH_TYPE_FCOE)) {
> +
> +			if (fnic_import_rq_eth_pkt(fnic, fp))
> +				return;
>   
> +			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +							 "Dropping ether_type 0x%x",
> +							 ntohs(eh->ether_type));
> +			goto drop;
> +		}
>   	} else {
> -		/* wrong CQ type*/
> -		shost_printk(KERN_ERR, fnic->lport->host,
> -			     "fnic rq_cmpl wrong cq type x%x\n", type);
> +		/* wrong CQ type */
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "fnic rq_cmpl wrong cq type x%x\n", type);
>   		goto drop;
>   	}
>   
> -	if (!fcs_ok || packet_error || !fcoe_fc_crc_ok || fcoe_enc_error) {
> +	if (!fcs_ok || packet_error || !fcoe_fnic_crc_ok || fcoe_enc_error) {
>   		atomic64_inc(&fnic_stats->misc_stats.frame_errors);
> -		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
> -			     "fnic rq_cmpl fcoe x%x fcsok x%x"
> -			     " pkterr x%x fcoe_fc_crc_ok x%x, fcoe_enc_err"
> -			     " x%x\n",
> -			     fcoe, fcs_ok, packet_error,
> -			     fcoe_fc_crc_ok, fcoe_enc_error);
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "fcoe %x fcsok %x pkterr %x ffco %x fee %x\n",
> +			 fcoe, fcs_ok, packet_error,
> +			 fcoe_fnic_crc_ok, fcoe_enc_error);
>   		goto drop;
>   	}
>   
>   	spin_lock_irqsave(&fnic->fnic_lock, flags);
>   	if (fnic->stop_rx_link_events) {
>   		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "fnic->stop_rx_link_events: %d\n",
> +					 fnic->stop_rx_link_events);
>   		goto drop;
>   	}
> -	fr_dev(fp) = fnic->lport;
> +
>   	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -	if ((fnic_fc_trace_set_data(fnic->lport->host->host_no, FNIC_FC_RECV,
> -					(char *)skb->data, skb->len)) != 0) {
> -		printk(KERN_ERR "fnic ctlr frame trace error!!!");
> +
> +	frame_elem =
> +		kmalloc(sizeof(struct fnic_frame_list),
> +						   GFP_ATOMIC);

GFP_ATOMIC is used way too much

> +	if (!frame_elem) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "Unable to alloc frame element of size: %ld\n",
> +					 sizeof(struct fnic_frame_list));
> +		goto drop;
>   	}
> +	memset(frame_elem, 0, sizeof(struct fnic_frame_list));
> +	frame_elem->fp = fp;
> +	frame_elem->rx_ethhdr_stripped = ethhdr_stripped;
> +	frame_elem->frame_len = bytes_written;
>   
> -	skb_queue_tail(&fnic->frame_queue, skb);
>   	queue_work(fnic_event_queue, &fnic->frame_work);
> -
>   	return;
> +
>   drop:
> -	dev_kfree_skb_irq(skb);
> +	kfree(fp);
>   }
>   
>   static int fnic_rq_cmpl_handler_cont(struct vnic_dev *vdev,
> @@ -1089,62 +594,6 @@ void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
>   	buf->os_buf = NULL;
>   }
>   
> -/**
> - * fnic_eth_send() - Send Ethernet frame.
> - * @fip:	fcoe_ctlr instance.
> - * @skb:	Ethernet Frame, FIP, without VLAN encapsulation.
> - */
> -void fnic_eth_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
> -{
> -	struct fnic *fnic = fnic_from_ctlr(fip);
> -	struct vnic_wq *wq = &fnic->wq[0];
> -	dma_addr_t pa;
> -	struct ethhdr *eth_hdr;
> -	struct vlan_ethhdr *vlan_hdr;
> -	unsigned long flags;
> -
> -	if (!fnic->vlan_hw_insert) {
> -		eth_hdr = (struct ethhdr *)skb_mac_header(skb);
> -		vlan_hdr = skb_push(skb, sizeof(*vlan_hdr) - sizeof(*eth_hdr));
> -		memcpy(vlan_hdr, eth_hdr, 2 * ETH_ALEN);
> -		vlan_hdr->h_vlan_proto = htons(ETH_P_8021Q);
> -		vlan_hdr->h_vlan_encapsulated_proto = eth_hdr->h_proto;
> -		vlan_hdr->h_vlan_TCI = htons(fnic->vlan_id);
> -		if ((fnic_fc_trace_set_data(fnic->lport->host->host_no,
> -			FNIC_FC_SEND|0x80, (char *)eth_hdr, skb->len)) != 0) {
> -			printk(KERN_ERR "fnic ctlr frame trace error!!!");
> -		}
> -	} else {
> -		if ((fnic_fc_trace_set_data(fnic->lport->host->host_no,
> -			FNIC_FC_SEND|0x80, (char *)skb->data, skb->len)) != 0) {
> -			printk(KERN_ERR "fnic ctlr frame trace error!!!");
> -		}
> -	}
> -
> -	pa = dma_map_single(&fnic->pdev->dev, skb->data, skb->len,
> -			DMA_TO_DEVICE);
> -	if (dma_mapping_error(&fnic->pdev->dev, pa)) {
> -		printk(KERN_ERR "DMA mapping failed\n");
> -		goto free_skb;
> -	}
> -
> -	spin_lock_irqsave(&fnic->wq_lock[0], flags);
> -	if (!vnic_wq_desc_avail(wq))
> -		goto irq_restore;
> -
> -	fnic_queue_wq_eth_desc(wq, skb, pa, skb->len,
> -			       0 /* hw inserts cos value */,
> -			       fnic->vlan_id, 1);
> -	spin_unlock_irqrestore(&fnic->wq_lock[0], flags);
> -	return;
> -
> -irq_restore:
> -	spin_unlock_irqrestore(&fnic->wq_lock[0], flags);
> -	dma_unmap_single(&fnic->pdev->dev, pa, skb->len, DMA_TO_DEVICE);
> -free_skb:
> -	kfree_skb(skb);
> -}
> -
>   /*
>    * Send FC frame.
>    */
> @@ -1245,6 +694,27 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *payload, int payload_sz,
>   	return ret;
>   }
>   
> +static int
> +fdls_send_fip_frame(struct fnic *fnic, void *payload, int payload_sz)
> +{
> +	uint8_t *frame;
> +	int max_framesz = FNIC_FCOE_FRAME_MAXSZ;
> +	int ret;
> +
> +	frame = kmalloc(max_framesz, GFP_ATOMIC);

why even use GFP_ATOMIC here (and not GFP_KERNEL)?

> +	if (!frame) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "fnic 0x%p Failed to allocate fip frame\n", fnic);
> +		return -1;
> +	}
> +	memset(frame, 0, max_framesz);
> +
> +	memcpy(frame, (uint8_t *) payload, payload_sz);
> +	ret = fnic_send_frame(fnic, frame, payload_sz);
> +
> +	return ret;
> +}
> +
>   int fnic_send_fcoe_frame(struct fnic_iport_s *iport, void *payload,
>   						 int payload_sz)
>   {
> @@ -1269,6 +739,18 @@ int fnic_send_fcoe_frame(struct fnic_iport_s *iport, void *payload,
>   	return ret;
>   }
>   
> +int

who checks this return value? None, AFAICS

> +fnic_send_fip_frame(struct fnic_iport_s *iport, void *payload,
> +					int payload_sz)
> +{
> +	struct fnic *fnic = iport->fnic;
> +
> +	if (fnic->in_remove)
> +		return -1;
> +
> +	return fdls_send_fip_frame(fnic, payload, payload_sz);
> +}
> +
>   /**
>    * fnic_flush_tx() - send queued frames.
>    * @work: pointer to work element
> @@ -1342,44 +824,6 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
>   	return 0;
>   }
>   
> -/**
> - * fnic_set_eth_mode() - put fnic into ethernet mode.
> - * @fnic: fnic device
> - *
> - * Called without fnic lock held.
> - */
> -static void fnic_set_eth_mode(struct fnic *fnic)
> -{
> -	unsigned long flags;
> -	enum fnic_state old_state;
> -	int ret;
> -
> -	spin_lock_irqsave(&fnic->fnic_lock, flags);
> -again:
> -	old_state = fnic->state;
> -	switch (old_state) {
> -	case FNIC_IN_FC_MODE:
> -	case FNIC_IN_ETH_TRANS_FC_MODE:
> -	default:
> -		fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
> -		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -
> -		ret = fnic_fw_reset_handler(fnic);
> -
> -		spin_lock_irqsave(&fnic->fnic_lock, flags);
> -		if (fnic->state != FNIC_IN_FC_TRANS_ETH_MODE)
> -			goto again;
> -		if (ret)
> -			fnic->state = old_state;
> -		break;
> -
> -	case FNIC_IN_FC_TRANS_ETH_MODE:
> -	case FNIC_IN_ETH_MODE:
> -		break;
> -	}
> -	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> -}
> -
>   void fnic_free_txq(struct list_head *head)
>   {
>   	struct fnic_frame_list *cur_frame, *next;
> @@ -1449,24 +893,3 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf)
>   	buf->os_buf = NULL;
>   }
>   
> -void fnic_fcoe_reset_vlans(struct fnic *fnic)
> -{
> -	unsigned long flags;
> -	struct fcoe_vlan *vlan;
> -	struct fcoe_vlan *next;
> -
> -	/*
> -	 * indicate a link down to fcoe so that all fcf's are free'd
> -	 * might not be required since we did this before sending vlan
> -	 * discovery request
> -	 */
> -	spin_lock_irqsave(&fnic->vlans_lock, flags);
> -	if (!list_empty(&fnic->vlans)) {
> -		list_for_each_entry_safe(vlan, next, &fnic->vlans, list) {
> -			list_del(&vlan->list);
> -			kfree(vlan);
> -		}
> -	}
> -	spin_unlock_irqrestore(&fnic->vlans_lock, flags);
> -}
> -
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 7d10d603f53b..d850ce4b743d 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -85,12 +85,13 @@ module_param(fnic_max_qdepth, uint, S_IRUGO|S_IWUSR);
>   MODULE_PARM_DESC(fnic_max_qdepth, "Queue depth to report for each LUN");
>   
>   static struct libfc_function_template fnic_transport_template = {
> -	.lport_set_port_id = fnic_set_port_id,
>   	.fcp_abort_io = fnic_empty_scsi_cleanup,
>   	.fcp_cleanup = fnic_empty_scsi_cleanup,
>   	.exch_mgr_reset = fnic_exch_mgr_reset
>   };
>   
> +struct workqueue_struct *fnic_fip_queue;
> +
>   static int fnic_slave_alloc(struct scsi_device *sdev)
>   {
>   	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
> @@ -413,13 +414,6 @@ static void fnic_notify_timer(struct timer_list *t)
>   		  round_jiffies(jiffies + FNIC_NOTIFY_TIMER_PERIOD));
>   }
>   
> -static void fnic_fip_notify_timer(struct timer_list *t)
> -{
> -	struct fnic *fnic = from_timer(fnic, t, fip_timer);
> -
> -	/* Placeholder function */
> -}
> -
>   static void fnic_notify_timer_start(struct fnic *fnic)
>   {
>   	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
> @@ -531,17 +525,6 @@ static void fnic_iounmap(struct fnic *fnic)
>   		iounmap(fnic->bar0.vaddr);
>   }
>   
> -/**
> - * fnic_get_mac() - get assigned data MAC address for FIP code.
> - * @lport: 	local port.
> - */
> -static u8 *fnic_get_mac(struct fc_lport *lport)
> -{
> -	struct fnic *fnic = lport_priv(lport);
> -
> -	return fnic->data_src_addr;
> -}
> -
>   static void fnic_set_vlan(struct fnic *fnic, u16 vlan_id)
>   {
>   	vnic_dev_set_default_vlan(fnic->vdev, vlan_id);
> @@ -814,26 +797,23 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	fnic->vlan_hw_insert = 1;
>   	fnic->vlan_id = 0;
>   
> -	/* Initialize the FIP fcoe_ctrl struct */
> -	fnic->ctlr.send = fnic_eth_send;
> -	fnic->ctlr.update_mac = fnic_update_mac;
> -	fnic->ctlr.get_src_addr = fnic_get_mac;
>   	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
>   		pr_info("firmware supports FIP\n");
>   		/* enable directed and multicast */
>   		vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
>   		vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
>   		vnic_dev_add_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
> -		fnic->set_vlan = fnic_set_vlan;
>   		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_AUTO);
> -		timer_setup(&fnic->fip_timer, fnic_fip_notify_timer, 0);
>   		spin_lock_init(&fnic->vlans_lock);
>   		INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
> -		INIT_WORK(&fnic->event_work, fnic_handle_event);
>   		INIT_WORK(&fnic->flush_work, fnic_flush_tx);
> -		skb_queue_head_init(&fnic->fip_frame_queue);
> -		INIT_LIST_HEAD(&fnic->evlist);
> -		INIT_LIST_HEAD(&fnic->vlans);
> +		INIT_LIST_HEAD(&fnic->fip_frame_queue);
> +		INIT_LIST_HEAD(&fnic->vlan_list);
> +		timer_setup(&fnic->retry_fip_timer, fnic_handle_fip_timer, 0);
> +		timer_setup(&fnic->fcs_ka_timer, fnic_handle_fcs_ka_timer, 0);
> +		timer_setup(&fnic->enode_ka_timer, fnic_handle_enode_ka_timer, 0);
> +		timer_setup(&fnic->vn_ka_timer, fnic_handle_vn_ka_timer, 0);
> +		fnic->set_vlan = fnic_set_vlan;

so many timers, work structs, lists. I don't know how all this is 
co-ordinated sanely....

>   	} else {
>   		pr_info("firmware uses non-FIP mode\n");
>   		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_NON_FIP);
> @@ -1030,10 +1010,13 @@ static void fnic_remove(struct pci_dev *pdev)
>   	fnic_free_txq(&fnic->tx_queue);
>   
>   	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
> -		del_timer_sync(&fnic->fip_timer);
> -		skb_queue_purge(&fnic->fip_frame_queue);
> +		del_timer_sync(&fnic->retry_fip_timer);
> +		del_timer_sync(&fnic->fcs_ka_timer);
> +		del_timer_sync(&fnic->enode_ka_timer);
> +		del_timer_sync(&fnic->vn_ka_timer);
> +
> +		fnic_free_txq(&fnic->fip_frame_queue);
>   		fnic_fcoe_reset_vlans(fnic);
> -		fnic_fcoe_evlist_free(fnic);
>   	}
>   
>   	if ((fnic_fdmi_support == 1) && (fnic->iport.fabric.fdmi_pending > 0))

