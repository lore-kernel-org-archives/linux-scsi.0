Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ED61F9ED8;
	Fri,  3 Jan 2025 18:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735930036; cv=fail; b=CUPCiBoTMKmq4FXsgc6c51yimEf0NE36OL7bAzcHJeg0CbUED/xu4sFuAV3nE9gwUuwGvEOQMVqs0ljd77NxszkQIOTml/LA2FE1kyt1lUZtFuCKapGZrdre2PI1+earBmvXYmsCDh3rbLODprrGPBKV7w2VJkNS/kBXrZcFj+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735930036; c=relaxed/simple;
	bh=pDtreUIKOY/RZCIF9EDsCGYrvDTqpHmYj/blhrvDygo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iWyib4F1AiWWoAWZ2BGeHU31Sd0r8bosweBniALTSceLt4UJQaolgtnK7urxijzZpO4RO2joY9jY5JVEEAPIk95uS/Y0jDQBygsauv9nnrll+DMOTCRwIOAHDbTvh94ibLK4zixsCDoFoqQV6V+hisYp5knIydh7Rw6zvOELJ8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fF9cQ+z6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SNvC/J1e; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fF9cQ+z6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SNvC/J1e"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 503Id1af020512;
	Fri, 3 Jan 2025 18:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=d+pahraJrVujKbRW6rkLUThmJpiRKWCv4F6XhHgsmQU=; b=
	fF9cQ+z6NIhSxw8anwDqpyb/A+FM0mRs1X4Eo0fBF3NIbnrlsJkC3yXJZrV1mxV4
	W/aap/+kxHmUAnK/4lLnYdolZigVwkq8h7hw3DKbn/YkRUNLYI6AIYcOBoZ9ANda
	tRWy8f8J7j6ciQSVYoxH5ciGR28ECYYS3ga/N3ooQynMCPRIO+vPoR0uLxZ9Q9Mf
	n8au1nJQf+st1eu9sYxQ/gyeiqfVAESLallgfCshTYGCBWdSAQJ7JdEimRQ9i5D9
	2sKfrreQVE5rRuOcSfzzobb/sGndkwmYPZ6KypPkervpau0rQd/Vakw93y9fboNk
	BVGff8EnLW6VoZsnL4+XqA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9chgmcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jan 2025 18:47:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 503Hcwvm027500;
	Fri, 3 Jan 2025 18:47:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43vry31d44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jan 2025 18:47:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=quataa2L00jiRL8ekHQePpzEeG2O/IL5NJtCRPnO7GWNFldJnRKf4eqk7Mq8c/hiLvPIPsEPrfp1Hb9lGXmkBYpjdl/j4GOtZDk9ihirYGKFcvnn5ayGl08e3Arg/9YPhC5NjR3ECkDiHF83Z/uIqI1ebjzGJc5Wng+bou6o/pAsl8iVZuDTXpG+tyPBwq4Nh3KQzrXAUjl36pmmQi3xQKuO5vVU1kwl/mqIcVgpqFnwRPybIVVnAeZb8C8xPHlfpN2nAQ9XBbo+QpcwNz1qFVYy3rY+vavG0WVr1nG3QpdqUt6ugQ88u9SP0CBzpmB56zCo/nILMq23LWQfdoLf+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+pahraJrVujKbRW6rkLUThmJpiRKWCv4F6XhHgsmQU=;
 b=Vy0Yh8f9bOlgshYNuWmfTuhJlTElmQAg1Bjx6NIJFg9k6+q33VR57vUCcpB0Emn9ctV/YZA3TpR6UUp0U6Ju92Lk96exvb4Sp3tbfRRlL6oKmeKBKrs/13KAfgu8jqCsEg93Cm0HmzNRiNoAeTwyH8RMm7vbmLVAZopJGN6O0u/aS4qzKBv3xmJ95kByxuBTrT9+JRTNbCxlGFYkDvlKP7xNw+vfzPGIYMUXlyOfTlN4BuHyYaEPBhEyGEOPbxOPd7aST7aWvhCbCQQNJsLHnhiVRLIRtFoKTORe3iWbnXfpnnjZupjDU47xZeB2ZoWBI58WsHKAX6hi30WnhyQiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+pahraJrVujKbRW6rkLUThmJpiRKWCv4F6XhHgsmQU=;
 b=SNvC/J1ebYwXw3ziuwduhlz07UJMYA8BLssT4EEkASqRDgwSL0bhRTnAcQDoWcyKaYXsNLAsEUNRoYba5A7eqrCUu51H/bl0vuVAv5UON0toGtMvTSYqlXd1bK0QIY2/JmWXNnXRsyfDOST2pMWlTEiEt4lr7J01AW51pYQPCkY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS7PR10MB7226.namprd10.prod.outlook.com (2603:10b6:8:ed::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.19; Fri, 3 Jan 2025 18:46:57 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8293.000; Fri, 3 Jan 2025
 18:46:57 +0000
Message-ID: <2caf466e-322b-46c8-9028-8bfd8347792a@oracle.com>
Date: Fri, 3 Jan 2025 12:46:47 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: iscsi: special case for GET_HOST_STATS
To: Xiang Zhang <hawkxiang.cpp@gmail.com>, lduncan@suse.com, cleech@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250103111109.21609-1-hawkxiang.cpp@gmail.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20250103111109.21609-1-hawkxiang.cpp@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0079.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS7PR10MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f8f0ce8-baaa-48ee-e1f1-08dd2c26ffc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2dSSmYxZ0JQeDI2N1JsN2VETTZRTjBDZy9PUEFyVk9UaW90RHF6cUxnVGRD?=
 =?utf-8?B?dFVBOWZEVzB5OEI4UVhGdmN1Q0ptVWlsT0ZmRXRXeFlZQkFVYTMvZFhBaE02?=
 =?utf-8?B?YXJzY0lJK3dHcFpDVmR1NUJBczVIaWcvVUxtOSs5aGFPNVZ1TTZhbXgzSkNq?=
 =?utf-8?B?MDhEbWZwQ0FEMGNxQTNzZk1nV3d2NjRBTXBlcHk0UDkzRmtwenVxSzJsZ2ZS?=
 =?utf-8?B?TUJJKzA0YWI4Tklyc3VSWWpRUFA0RTUzN1Uvb2JYQlRkQkxkTzJNRGE0Q0hS?=
 =?utf-8?B?NGtWelZGVjhrT3RvUzA1TEYyczI4ZGZnVmVzUWhyS2hhWC83UERDSEtPVFIx?=
 =?utf-8?B?UEpEWXRtRjR6aDlHNjl3OHVrZkNIT0UxQlA2clhVejltNjhwdDM1bFN2VDhK?=
 =?utf-8?B?SUc0QVNLWStXanp2aENpZVRxV3hqa3lsT3hSUi9XNUtUaEY5QythUzYvV3VP?=
 =?utf-8?B?YXlFS0d1UGkwWG5qdTVQaWlMeXBVdXJCQ081c1RWUWFZOUJEK1A1VmlNMXBk?=
 =?utf-8?B?bGRJZXovc2RrdW9BWlkyTUZ5NUlKYVVSQVFBZHhvUmRueGUvekZYM2tpd0RZ?=
 =?utf-8?B?NDlQOFZlV29kczBNNExTMjl6ZGJDVFdOVXJCWVlUaEdsR3p2aGJsVmdWNm5J?=
 =?utf-8?B?RnJMSVM1NzdlM1NxUjBOTUZ3K0kvRzA1RkJsZHVJVkt3UVd3eVhFSjg4ZkN5?=
 =?utf-8?B?Q3dhRm93K2xvS3lyNUZQM0JzVVREbjNkUURvUzV5NVJBQXloUWJITEVCSVl1?=
 =?utf-8?B?dzBTZU0zYy9pM0t4UE9jTUR5Wk1GSE11dm02dTdVN3p2NDFmdkwzZ1JWRlRs?=
 =?utf-8?B?STgwLzdEaWU0S2FOdkc5RWZmbG5TeWUrUkRCdWMzc3ZjMGFUZFN5elFaS0l5?=
 =?utf-8?B?bFZqdmhhTTFRNUQ3MmxZYk9ROUloMVdSWFk1YWFTS2FUSUYrWGVOWVNtbG5C?=
 =?utf-8?B?UGtuY0cxVGVySEltV1F2blhSallLeDRaSm10elA0TkpKQkFNUG9DWkVuM1JW?=
 =?utf-8?B?djBDSmszajRyV0xSQUlCR1VYSDM5UEJRZC9aREl5dE9CSG5xTUM5UjAwN2c2?=
 =?utf-8?B?V0xKQ0VXbkhUKzhTOHFYWEx3OXJUeDRDQUdjazZXb1FLcXpsM3NMeU8yWEpV?=
 =?utf-8?B?WE16U0V6eFdzVmRWb3MzZk16dzF2czR2YmdzYVFnWExPeEtYcmF4SGRhSUM5?=
 =?utf-8?B?RE9JNFh3WUEwSXd5aFZTdzFEY1crZmlvV1JKNGMwS0pvRjdPSVY0RkxEdk9k?=
 =?utf-8?B?OVBwbWdIZWJsNkYyTk5jcVVkbHNlaE5CRnNqR1QvOWtMbXNaOXVLWFRYZWM5?=
 =?utf-8?B?VFJGSTg4dWJQM0dGN1hSYmRRZlVDaUxBZVI4ejd2WmJxUWNFdzNvb0g4ME9J?=
 =?utf-8?B?QjkxcFhPZ0pEcWtFd0FUMTY4ZVpzdVhYdWVtNDdaRkxuVTFzQ2Y4T1FQNS96?=
 =?utf-8?B?bENMZkxoS3RQNDRwU2RZNkdaMVcwVUJ1ZitqNEJBWC9iUUNxai9YZjJTa3dl?=
 =?utf-8?B?VDhxLzhPUEREaEZuaEZwM3pqd0xLQ3lTQXJmbWdHb09uY0xwNkpVWmtVMkVn?=
 =?utf-8?B?cVppY005N21DKzUrUmRVdWpQbDNpaTE2OVlkYk9za3J5Zktub21POG9XRWw3?=
 =?utf-8?B?WGw2YkJvU3VwdTY1bmJyQklmWTkxNHZhSURJOHZpZDRuSlprZk51bnplUkZY?=
 =?utf-8?B?d3hQeHkzK0hIa1NBSmo3OExQalk1YU9QRHEwcVVIMlhJYnNaM3VqZ2RhT3hm?=
 =?utf-8?B?RHJqdkJoT1VXaFRqb0Q3YUdsSHdtamVCYTdXVHBnODNHWllzbWRHekRjUG52?=
 =?utf-8?B?VHBGWmY2SGh3eTE3czBSMnh0M3hTOXZaWTFiZjFQZVM5Tjk4UFJ1TW9Jd090?=
 =?utf-8?Q?tonr0JAuDjKTP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0JkaHA3bXZ2ZUxrS1dkWHJUR3JnUlZCYmZUNkdZeXRJUU15dDNWZ0RhZXJh?=
 =?utf-8?B?M1ZXcXRZYldzWXhTNktRSmZRNTBlNEQ3OVdDK250Z1lqSUkwZi91SVYrdmJE?=
 =?utf-8?B?Z2lJNEcwc29peVRzTUJ2dUkxbSttUitla2IzZlBjVy9TdjQraVpLNnVoK3Bl?=
 =?utf-8?B?L2FXd1FzaFNtYnY3cHllZFJRWU9KVEJxZzdSb1JOa3E3OHFRbm82ekJ2TUt0?=
 =?utf-8?B?TERxU3orR1N5eGpQdHRZVjdycEJMUFliVThVd3MvZ2RWays5RGxFRzl5bkRG?=
 =?utf-8?B?MEJSRDZGSWoxZGlxdjhkWllCVGtnSlJSVEFCOWU3S3FrRUJFbkFPdmVKWWZ4?=
 =?utf-8?B?YlBFME1wLytic0EwZUhBejZsVldhbzdaMmplUEtxSXV1QmlLeW9DT25NeDc5?=
 =?utf-8?B?SFZuaVlmcEJWZ3NPdHR6K2RCWVBoYTRuUXg0dG9pUU9EY1cyZGtmS1k0Rjgw?=
 =?utf-8?B?WTVZRVNzL3pFL05vR2tMQ3BLaFRVaGxEZ1FFekRXQlpyaXFSN0pxYng2OHlm?=
 =?utf-8?B?QURtZytoQ1h2YmxmSWFUZmpJQmRRbEVVZUJmSll5UHZaZXpGais0ZTIwMEVQ?=
 =?utf-8?B?STVXWlhsbmNCeDlrcXdEZHBtYUY4bXY1UlA5ZUFPQ1huaUdlQnk1d1BEYVov?=
 =?utf-8?B?V3U3YWdxREpjNDVqVXYydUF1N29ITklFK3RYUDl2MHYveW5UdzVyQ1E4dXdm?=
 =?utf-8?B?YklUOXhDQVB2K1lBUjdrVjVmOTFRS1ZwL003NmpsV21UK2RRV21nWjZqaldt?=
 =?utf-8?B?MllqQ01JV0xGcmJUVzY3U2RHNHVLK0VOZnJBbmUvRkFPS01vdlJWd3FjL2NH?=
 =?utf-8?B?ME1YaEU0QTdVaTFIdjVrbFRZMFJnUEhtNXU5QWVGcFFZRUFNRGlLK2NlZ2dk?=
 =?utf-8?B?UFFqbHRMUUtkdTJZMzIrZ09obnRXZG5KaE5SdGFkZlFBTkx2MlNxaTJDWTVD?=
 =?utf-8?B?UTJLak90djJoRkhsYmd1dnRhSW0yZ0hHNDlHTTBucW9MWS9xYkdJMTRDRGEy?=
 =?utf-8?B?amRuUHlCZ2hNYTdnVjhzcHNKUUtlU3ZIdGVYSHI5NWxLY2h4dWVHbXBzZTl2?=
 =?utf-8?B?M2tCSy9pTWVZVUF6M1BDNzdwZFdLbVR2bWpyeXF5bzFhNFcxSmJOTFRnTmFQ?=
 =?utf-8?B?RkFqNjFVdGkwZDFFellJbDBvSjlDWHhKU2kyRVFrQU1JTjVmNWxPTXJFRjFt?=
 =?utf-8?B?YzZWbHZiWnBIYk1ib29iRldaYnJPSHgwTFgzc1JnWEwxSG1iV2ZLaExFVnA3?=
 =?utf-8?B?RUZiUVVvQm9VY3FWb0g1VnNSSmtwKy9FVlNJd2lLRzhBVVl5TzdUdTVINkJL?=
 =?utf-8?B?VGplV1h2ajYyV3ozUVJyUXVUTG16MURHMzN3L0FnL29kTmF1MFFvSGFDTW1k?=
 =?utf-8?B?RmJmUEVBK1E0MlJza1dzQnpGNkt6MnRsajFuUy9Jbld3MGgwQ2dEMW9GVHNO?=
 =?utf-8?B?RVJvV2dkSUtiR0JPYTNESkhFVTVaYnp4Ym9saE5PT1FRb3ZIK2JOQi81OWhs?=
 =?utf-8?B?Ym5tMmZIMnFTamFTeTNISDNvUGlIc3NEV2hFa0dUSkpnRUhUTEplUHpqcXI1?=
 =?utf-8?B?MHF4SzVEM1dlQ1FjQnpDN0p5SFlGMGNDNU1tcEkzZlh3M0JTYVBTcXZ0TWI2?=
 =?utf-8?B?UFE2ZmxaS2ExSERRZG5tNWtVenJrbHRjcDRzcGNVSklwYlF3L21BNFRPaW5N?=
 =?utf-8?B?ZkFDRW12a3RWME5neUdiUmJZeXcxbUo2U3NMRHRTNExOSSt4TXlaV1U1WWF3?=
 =?utf-8?B?QWFLUk1DOGcwSjI1djZDYVlOZzJFdEcwTVpjbGExWHJTcXpnOW0zYjA0M1dM?=
 =?utf-8?B?S1VVMXBudDZGRlNOME5vckpUSFZkakdUNVh0NlpxNm1SWHE4Q3ZTRjVmaHRy?=
 =?utf-8?B?cVpERWxqc1kxMXVaQkJtOStQQWNlYlBDb1BOLzJCUjAra1ZFSC9LUUZpNW9v?=
 =?utf-8?B?NGNtMVg4eWhORDdIZ1dNYUFqTnBKbHFSR0JTUlVrTzJXSFZ2VG9zNVN0ODN4?=
 =?utf-8?B?RzlIdUJHbHBRakhsaHJLTTJpMmdUckpvbG9UU1YrWDVhYUMrdG1PSW5DeUdK?=
 =?utf-8?B?TTNxSlFZNUF4SVhoQmNMQjZFYlBDME1ua3FBNDVSMVU4MGhwdnFCWlp1Zko1?=
 =?utf-8?B?OWlXMHByeXJaTFFjWVBub2JGbWlTdUJYTGQxelJrbkJHdUNYbjQrZFJscUg2?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7W5PEaY3Xyi9oHvC9WRlZlOLX1pDllnpJr0PJzGiAjpTyvViL7XT2j0wt7VODRwV5qC//YTKymX/cnnxSJ+L3sGAa++cfOpicjS63UycJbHKeSfcvHCJ4R8yMWCMT25tU2yjUBTG80y9GxzFbSVXTr6qUhbg+z/d0OIouOcSimlDNqSkbiJA/cedo/kh3R4vwJCiGwl9hRhzdae0mwERe4QXYp9fagICNN9cAkYV6z+e9m0jWIEkDSJkhr3qobfDczzE2r/LhIWBaMKUuRt4uY4mFE0+b/F25PoseYOWWbsMeH3GuVO+Yos5mlctCXbhsqKQwnhcp6NmEFjwC6SxJeofmx/LozcG/L/1PZJNQPBN2dvUBXUW1VFRS6GlI+J/X/E5IdhqgeChODR6pK9V2NIx0YTvTNz9JhBmhBkXFD7VW3spP5SJiLBkcdnMqdZnO8PWtQKPRfRcuSOJmEa9hpDudgE8AqX7dNrpkpiTZuOvtK9TiIUkhmDojrb2RDzkQreFJP14Dg6apeUkxZhOeZd2DN6feWvVkC922TeY6FCJ2/NG6soOGW0xXvAgdLvncyhkOAOYbtm8+ec5fLkrAQVKhX1975iSdV6Krk8YNIM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8f0ce8-baaa-48ee-e1f1-08dd2c26ffc2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 18:46:57.1085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTrVmvhX2sju2TyiBvMWkZDssiTjBDxQPbHltM1/WCVwvmVT4hKBH6N7QXefIkGHhEfgg00c2G6mbJa2N3dMbUU5t8oKRMq0OIrej1eU86s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501030165
X-Proofpoint-GUID: wEozFOCmMzkRtKIUxFK3xcA-QedI7_rb
X-Proofpoint-ORIG-GUID: wEozFOCmMzkRtKIUxFK3xcA-QedI7_rb

On 1/3/25 5:11 AM, Xiang Zhang wrote:
> Special case for ISCSI_UEVENT_GET_HOST_STATS:
> - On success: send reply and stats from iscsi_get_host_stats()
>   within if_recv_msg().
> - On error: fall through.

Could you add a line about what is being fixed? The above info describes
how you fixed it.

> > Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index fde7de3b1e55..ad4186da1cb4 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4113,6 +4113,8 @@ iscsi_if_rx(struct sk_buff *skb)

Patch looks correct, but could you update the code comment right above
this line so it mentions ISCSI_UEVENT_GET_STATS and
ISCSI_UEVENT_GET_HOST_STATS.


>  				break;
>  			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
>  				break;
> +			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
> +				break;
>  			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
>  						  ev, sizeof(*ev));
>  			if (err == -EAGAIN && --retries < 0) {

