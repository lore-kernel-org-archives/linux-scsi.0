Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969B42C11FE;
	Mon, 16 Feb 2026 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260931; cv=fail; b=WAyHxRECeJriWx5MjLoNLOKqxA0NeG49BDYqLCTPQmh6T1bK0V/IKCvYVeUkdu2F6QWstOweQFlZqW2UH30Ntjf9jW2cuNd8Aw5bLWkOtliL/Uc0IdQ12E/Fd71FO/Yw4bTxgDV1f99qdp3Eab6Futm4Z5+9hWUzhpyXOdvf0xQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260931; c=relaxed/simple;
	bh=kM/qkcwpuG2vaeM67BgNTy5idaAr1AgfzNvOiJaYeoE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PoW3P6oVn/TD9aKBPkFNNyZuOumSARB0ESC4F+uiL+nRrijrw72owjhiobP9yVkEuSrRTA/U9NhOsZ/bu5ZdSB0fIpfv3JGDrs8kS7JSMiSB+o+JPz8+q6rFDy42eHjn1UVPgcdLFYBOhhIoKISY/aCjLBc124Ay2fSn7DgVgNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cUvJ3VIe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hUclOS/n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cUvJ3VIe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hUclOS/n"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GFOISd1802173;
	Mon, 16 Feb 2026 16:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+msfvRS4361Vh9oSu+HzTEIkUGQBr38Uux0omABkPdA=; b=
	cUvJ3VIe1OsN3juZWA0KY/uk87dqWKCEowNax01+SMhRbfTL8IOYHMCqbDsjSv7w
	jGWI93+PB9AjxJyOLeWVmrbikkg7WSKo+XU28tgAx+4uExjvnHDjcAB9gKseS51d
	rJ9Q0Jx551F8ZqOQMp1XiH2Vhg/XhkMZ8LumYNNVwhOdrnQgE8zsXlp8Xwz5dEVZ
	PZrDaQwAN/yYUgkAwl14FoLJQB93s2mcB95QcWZ0OGOj+RFwGPTtgytsO4OIFxph
	drt7pRrwWB5cTv9Mwcg/FFquV9lhpkF5ySmU+2zuaS0nHOdSQWo38S/LWubyTGxR
	2x2NWt2tvLqBQ33/XJx+NA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj042bbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 16:55:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61GGIvKD028584;
	Mon, 16 Feb 2026 16:55:18 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012033.outbound.protection.outlook.com [52.101.43.33])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cafg8hh3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 16:55:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MydWV/Bhd7juro9WMJddFDwAVtipO44vPPXSy463uGjxiopARreVYthdqPl9wmbnDxPd2JddAHgJryWAF8rI3ccibG5+vklLw9UdKLncsTG1LpvbKpPrxR7xs0pEjXj1miBp5A1ZBrW9EaLGS0H5g2dJ44yzZDyyN3IGsrpbw0wU/5OXVUToBWHyTuRWMFW4S8z5cKZQDvVxxEMtqRar9/WySDQ/wvPPNQTSoQmqHH3vwhgaAFPY3hoPDMBq/WHqn5rZ+dYoIJG5cSNui7kKN/GD5KFKAPKseQe53SlGAjRF6Y4xsJnV5SrC/rMpGvw2HXLIFKtvyn8HChcqMucujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+msfvRS4361Vh9oSu+HzTEIkUGQBr38Uux0omABkPdA=;
 b=ulNTuZPkA4f6UcG03Jz46YMfrYGB5rTEoqTixyTD86TaugJJZdNkcrS3MzwZa3t5Weg4bwLNyuYzxPnmxIg10w4PxG06PDKjIBSqm+rPd3YoKh+I6rxSccvk0joIVs/Ob6HFf3UYBkMHnRDxur3BA32WscUhm2nXKrQxh+YioHaiJSqF6hfl4SqAaYqtaVbeNBZbFVr+3laomhSCrs8Qcs/06ZfI5qTDyewxQhdL8p3ucEncN35nnVNomLwG4uwVJI+m6luUrg6dylIb9YociUE22sl7HjolQOsQiVc4vWRXw6Y2xu00IENjITHbsxOae5s29NWuB5JmeoeLk07B2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+msfvRS4361Vh9oSu+HzTEIkUGQBr38Uux0omABkPdA=;
 b=hUclOS/nDSLRkNFncX6mXc0cJtNeaPGWH9yR36i49jVQewEajJA0XdcOi/R+Kci01WNmJlOI/1aFozg1EpbhyQ0EyX7kup9WgZ68jy+5Mf41yuGX1cAwp2wKul8fqsJ+riez9IlPxzeTRV3ncAWQ1G83TnfHHi5YIJpWnL2kQ7A=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS4PPF717557185.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Mon, 16 Feb
 2026 16:55:16 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%5]) with mapi id 15.20.9611.012; Mon, 16 Feb 2026
 16:55:16 +0000
Message-ID: <28ab3aa2-7654-4b4b-94be-bd691c1903dd@oracle.com>
Date: Mon, 16 Feb 2026 16:55:13 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <b598c5c9-6732-4661-85b2-7ab10a0830d4@suse.de>
 <dbf5fbdd-8894-40b7-b574-0c6385995ec2@oracle.com>
 <a5a0aa42-33e4-401f-ad94-8104cff9368c@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <a5a0aa42-33e4-401f-ad94-8104cff9368c@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0366.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS4PPF717557185:EE_
X-MS-Office365-Filtering-Correlation-Id: 23e61963-0fee-4547-275c-08de6d7c289d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0xxMnNwYjNTMDJydStaaFcxbE8zMnA5WTIzQllFeEhqZlUvWnAyeFZHdUR5?=
 =?utf-8?B?Y3F5S2dITGJwY1VOMlFkYllpSDN4UkVHM2tjVlFiRVQzb05zNDBXZXpZSytr?=
 =?utf-8?B?TkErYURrRUxweGs1NWMzQStxU1pjN0crMkp6YVRCMERQNmhkTnQ0aHU1MGdT?=
 =?utf-8?B?WEZkYllPeWlPbW5pSGM4Rk55MnlJcGsvMVRKZy8rMTNId3JPWlRZY3dwR1BS?=
 =?utf-8?B?VFhGaFFxckdwcE82TCs5SDR1VkkzbUtMb2dFSVI0R042K25RSTdZdWNsT1A2?=
 =?utf-8?B?dnk2eFYydXRWYVd2YzhrMmtScVRUS0dxYTNUVmU3dmdMUTd3cXduNGJnNi8z?=
 =?utf-8?B?NmdkTmpRVjNodVlnYzJWN1doaUFpUExIV0RQQ3poRzhKQ1J0SERwTGJldXZ1?=
 =?utf-8?B?Z1k5UmIrWlFXWTQwcGY2RWZ6aUdKeHZjQjFkZ0JjQzcxMlJBS2JWQTdMVXA4?=
 =?utf-8?B?VjV2VUdrckZYWlFvSndoRE51THh0azlhNkxsZFRCWmRUVU9NZHZFVDdFQUYv?=
 =?utf-8?B?b1BmNTRQWmdCWStmWXB3bmpJMDlTNHBtT1RRREVwVCtTUDVMQnIzcnhFV1d1?=
 =?utf-8?B?S1F1N01xMXpxeUtIY1ZVcTNZc0hZbUtPck52VWRMN21CREpOcUZJazBRbnor?=
 =?utf-8?B?VUQ3cDlqV3ZxSUNBQm1xL1ZOWHJPK1ZudXc1cGdhdkVpSkp2eStEMDFsOVp3?=
 =?utf-8?B?eFozWWJBS3ROWkprNG1EdVZ5OGw5RG1pUWI1YlI2V0RVamlyYVRqYXdpWWNl?=
 =?utf-8?B?WmVMdDJxNjUrK3VRcFlxbG1IQ3RGVDF1aHF0emh4NkpudnljbWk2c1h4MXNF?=
 =?utf-8?B?TkEzTHp6cEJ1UFo0WWZiYWxseE5KczhtVXNPb1Z0a0dFYXJ1TThFbHhUUlI0?=
 =?utf-8?B?UHc5M2pWd01xd3VyZG1TYXBTSW4rV05ZZ0NMYWFISmVhV3RLK0w0cGZ6U1Vu?=
 =?utf-8?B?UndCbktlTmZlSTJBWXRNZUw4NHJKcFpwRnZGVkR6UlFaRU1QeW1DU2k3dlU5?=
 =?utf-8?B?eVNnOFh4WEVCMy9JWUJwZkVLOXl5OWVaY0lzamhkNEN3anhPQWNzWFFqVVhD?=
 =?utf-8?B?WmtZQWhTa3k3S1hvamlnR00xdzJOaktRM08vem54Q0lrUTZubkFBcUw5bUhk?=
 =?utf-8?B?WTZoeDNTZ1R0RktzVjk0c2tiaXBabXU3WWR0SFFLQW5ubVRrd0JrRW8xa01z?=
 =?utf-8?B?Y25GS0FQNkRxTlpPc3JZbVFnZHY0ZWlWNEpUTWY3b3hvOFpUWWo0dGhaNWlL?=
 =?utf-8?B?cXZab1ZjZGUxK3ZZOE1uOC9CVkxwdjE1T3ZDbEw2UndzMFFvWVVXWWRSa2U1?=
 =?utf-8?B?cmtERGZCN0JjZlQvcWRrZEVuTzVzUTI2aG04bkN3dzJPWFo1RlRJcWgyeXJM?=
 =?utf-8?B?L2ZyOWdVcnBnZ1o2Q3JjRGdvT05LeEoxZSthQnZVdnV4elhVUE43QkhvNkVU?=
 =?utf-8?B?V2ZSUGdkRjBMK3NKeW9uRFZBQVF3UkhWMm92M3lJVXE2SGlOKzRmeitVQkJ4?=
 =?utf-8?B?anQ0U1p0S1hTck5xYzBNL3VQTmM5UVY1eTZoUW8vMmtEeVUybVJ0Y0g5UHNq?=
 =?utf-8?B?R2Y4bVFZVGd4Tnh4MEVmTnI5c0I1MlJJSXJaSlNCSU83UmFLa2hieWN3Tlgy?=
 =?utf-8?B?dHRaTkZXcGNFbUhmQXdvRU5HeSs5UXBVZ2ZEWk5qRkRDeTlqU1MzQUZ4L1hG?=
 =?utf-8?B?N1p3V21JMExaamhXSVRrK3U5bm13NUpZWUQwTDVtRVcyOGlEblFHYXFDSDhs?=
 =?utf-8?B?RXhlN1JaQ1ExUVBlVHVER2I1R0EvV2NheGsrTFk4eWdtUUJ3S0tpb3k0dkJJ?=
 =?utf-8?B?NHVWS1FlckV1bnNLelphUDRGdTRlRVpJU01UN3IwSXgwRGVTNzhhSWZQMExL?=
 =?utf-8?B?L2kvQWY1TmxqZkh0SmsxcDJYb083Wmg2cFFWUkVIYkZ6eEZyMmNCVnZuVnpi?=
 =?utf-8?B?aWVMYytMM3BpRkNteTZaQ05mUkVkNnQ0ZlVIdzFMUGdjSDE3MnI1ODFLdDRp?=
 =?utf-8?B?UlVIczl5RURuU00xeVFRM3lYeWdRdFlQaUwrRnROWElmM3RYRW9BTTQ3ZnVY?=
 =?utf-8?B?QzErRDFoVFBXQWVFQU52TnhUUHY2M01QK0RGN1RFVnJFOVJNMXBFcUxkSyt1?=
 =?utf-8?Q?VI7J5+83H43/uwysuna6/plSf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3U5RHFSWDdrUDduNlFiVE1lNWtURUtZN3g4cXZ4QXRFYXIrclhjZXRNemt3?=
 =?utf-8?B?aFZoRVBpZ1NPclIzbG1sVjlUNmNoWm9Temt6QnQvUGNnMkI0WVVzNVYwYUFj?=
 =?utf-8?B?S0taK3puSGx1ZU9zOVRrRk9wNlorUzI2ZFBRVGlUN3lYQ0xmNzhTN0drbklz?=
 =?utf-8?B?V1liNWRBcTY1T3JJVzZob0J1WFpsRTdHZDVpSTEyTFRURkxEVjZYZGI2d2M3?=
 =?utf-8?B?K01MdEN6eEpJWkNHc0NCalptSVYrQlFNYlVlRytqV0lycUdrb0VlZS9JYzlG?=
 =?utf-8?B?RnBJdDFhWi9SMEs3K1IwbVViOEdKeEg4MzhSNW9COEdvTGhtR09Rd05NcFRW?=
 =?utf-8?B?SEV5bjF5d1BWeVQxYklzVVQxNWZQUTVaMVJaQWg3a0NET3lwYnJQTjVaWUFR?=
 =?utf-8?B?QTZhTmpyN1hUTW1XRzFHMWtZOE54NUROdnRnbGtuUHhrMXVwMnNyalpuTEFL?=
 =?utf-8?B?bllKZlJTQ3ZuQWszTE5MN2J2ZmRYS1ppcmI4ZGI5MURzNmg5alVEaGlWT1kz?=
 =?utf-8?B?OXJhNG44V2cxOE0yTFRxRjVPcjVoeWFYMDIrRWpjT0swc1dVWEpPUTdJMDRJ?=
 =?utf-8?B?L09ieHVuQ1dGTFRJQ3czN1hSM1ZQVTZrNzUwS0MrUDh4bVIvR1M2cHVnVFR3?=
 =?utf-8?B?NUN3aDl2dzdrdlFaWTZNZ1ZrcHkvbE9ZaUptemVQem15SCtFalhQbE5lRkZI?=
 =?utf-8?B?QnhVY2ZkVmYxcS9kZlhGS0J3aXNsRk9DZDcyd01ka1Vma2lXallnMWx0V0I5?=
 =?utf-8?B?aGk4WFJkWEd4M2Z5YklmNkdyOGJwWmU0UWhDL0tjZTV3NmpqK2JSNVJPS0dX?=
 =?utf-8?B?TmlzYUkwbzFseERaSlZ1SExUNkZIRG9udkVnNkhjTTJLM3FVSFdCZzluaG5N?=
 =?utf-8?B?K2RsdTU0cExleEpXeXFKRHE5bVA3Q3duNkovMk1NTVJiSlp1ZlV2a245U21G?=
 =?utf-8?B?OWh6Nzd1ZkZHMEcwVG9FbmxVNVYwRDZWcE1EeHpRU0FoOTZhWURTcE0xY1Yr?=
 =?utf-8?B?ZkRDM2hkNy9JQlJrMzZTT1BYSW44UC8rWDhBQm9qZ3l3eFoySFJvMzlmb2NH?=
 =?utf-8?B?aDlyTnJiVzNNMlRHdDRpZHNrdmZrR0dZallGVDNnMjVLMHZ4UDMrUjk5dERl?=
 =?utf-8?B?OXNOd1p3d0pQVmN0TzZlUEZhMUxrbTV6OTk0bVFuMUQ3M0ozVnc2SVFKbUFl?=
 =?utf-8?B?dnF2MzFuOU53aXRlSk9ndUFrWWF5WUVtN1FjcU1hNkx5dGxwaXUrQW9XVWU4?=
 =?utf-8?B?UHR2TDZXdmZsaVRORW50T2hrNG94SnlTTTgzczhWSXdneXlrQ3dGZU80dmZD?=
 =?utf-8?B?STYxNi9FNi92VXFocVV0ZnkvWTRJSEdaSmdZMWYrOGxmU2xjeHdpc1JNcG1w?=
 =?utf-8?B?a1locDBPd1hYTFBFSCt6d1RoaDhKRElBdmxjdXFIVHV2R00wYmRnTHQ1QzlX?=
 =?utf-8?B?KzFrNW85OGNWTFJ6YklUOCtFU2VRS0MvdTFkbGRhemdScmVDeGxBQXlxVmpq?=
 =?utf-8?B?aWw3UkxydThaa1NaWnVINnJTd3VBL2NZWUpBTllJZE1OSGcrSlpCb2dZRC9l?=
 =?utf-8?B?UklwRmZjOXBKRUtraFhpU3BzcDQrMndBM09UR1AwVmk1N3R1K25TcUNlZ3Mw?=
 =?utf-8?B?SWZGR3NCR09Bc1BuNGNBZ0ZVM2FnM0J1ZmNTS01xcXFTMzFhbFN4RTJITDJW?=
 =?utf-8?B?M0RYeHd6ckJZVHF5SHpHMHFudFFNMDE0VVBkSi9HQkRLS2tuV1NpWW1DbHFk?=
 =?utf-8?B?cVU0UW1UVmJWNHYxTW55QlY5aGU4UjFBUkFTT0tmRzZpWW1XNm95MDUvWnhY?=
 =?utf-8?B?Z3NEZ0wyZERvRUU5N1BSVjZMWkszNjdDWVI2dG5YWThqL3UwNVQybDBrYjdS?=
 =?utf-8?B?NXdraXcrOHF1ZHVnMXhQY1ROeEcySlZtd1V6VUo4LzQ4UmlIbXJuc2lEWmdX?=
 =?utf-8?B?MDJyVXMrTXQxY0tvajRLYkxLanBqRC9ZMW1hM0ZTVXpBNVNlRFBvcEdnNnRr?=
 =?utf-8?B?RkJ4TzVjNm01WW9TN2JMZWRwa0xvQnl1YlRBeENkTTVkVW5UY0YrdytnWE9E?=
 =?utf-8?B?YmlZOHlDSlpZcGtMb3d1dkR3a2Y0KzNUczRmYlEzbWpQVXR4NjZ5Y0M3amNI?=
 =?utf-8?B?ZTNmVkVBSnhiWGFYdXVhVjh3VER3RGdySVlQSmMrRjlTYzlPK2tnZUsxa0xK?=
 =?utf-8?B?SithUmw2SGZ3a1NVN3pleDJFYTRGb29hVHhYbjdxK0VPRjQ4SFloV3p2TVg2?=
 =?utf-8?B?ZHlrdUEwdUQ4dHBLYk9KQVQzamZ4dTZGR21tUnJVdWJWSHJFQVNHdk9Dbng1?=
 =?utf-8?B?Ty9qeVVyYi81NnJma0FKemZUcEJBYnhoOE5tb0VkY3dnajA0dVd4UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ziYOUOoEqsu0W6OFllSSkgrnV29IkrL1e7qsyYlb32FTsn+pSEErWUod/U7694VaXPoli4DV3yokbABJzEWy2QP77tx3EyD6V6Hafc+QG2Ig4SewhDygUBGSS/lpMGPmFYl/im5e/GqjugY2aJK4LOsbtZzfZ2Ep2Li2A6BQt3ia0B8iwjRr5c0JF9g/wFvZHy0N2SsQnSooLVbwgcUx56GZrGowwH/HcjlwoUSvSm0LcG8Y3O57AHdlIs5ZKek5lckmMUpWlYRGHRyBVMzhkIAVFa25cTJ3ohdV70VI+A7HNATYXSoB+NNb5jSRT9k1zVpmINuL3skxTXzsM5eUKp8HSFxt0dbzLY1CN6VEh2xydxHi6bsoJdKFWSfpswXaKK2hP8juajL6gxfkuqI5n1CwmCiq+oG31vsHbCU7Vc7WuPvjF0pQu50d68WCuiM235LPSAb6Bu4dyPRTNnrckPGEFztTdI0UZ2DmFtGaCurfCBdKzDmbcfpXHU8cqWPfR1sNEq7SEi5+S1cUUywcx7XZkodmHNe3v8KPUmGba0wZ6pK/gMz5xRsUbniGC9zDaLAkT6mhZpLf0XfwCoWZLZ5seTAixavpHSGyNA3fPH4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e61963-0fee-4547-275c-08de6d7c289d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 16:55:16.0311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SV+dxHz6TKYo9jS2yk4sOcBtm+cB1TMWCrqJl++fVaFn+TDWyRVZFovP1cfmSv/IXyMz6qfa91ynXCHGzf+ffw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF717557185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_05,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602160144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDE0NCBTYWx0ZWRfX3RM2DlBqUNgS
 Vv8lw9tEKG3Fk7rq/3tzjR03hXfrlgMB/Y4X+wGlBScoNZhXRYqaPgqFYu3oppRfKWSvmJFBrl9
 xn1zZo9TSRMfxtlKoQ9yRo164IHqY8D4Ym89tagWq/To5nQ0SKT/KbN+79FRSC+NkJaQni8HRvG
 GkIYw6PN97pBihTR6Biz5v5o+VUJytL9BZA3by2NfA8dKbWkTFBljUQorLYjZ4lYQuuRGHZqlmR
 jyJrNb/7OKC5WMldURo3IrZJwoEp4CBpmt+KWje2R8DmfDw4EjQSC5sTE+65IcMf+RRFo9unZAR
 7NBC1n5E3MJbUx+2FAGoJktJwuOaUaJt3JPGmtjEp6fdBgQgpgBKrnUzkiBOSMyotUNFyajFGzC
 ZJmmWJzDi9RyejheXqFbg5JBTTJmXxtkpVL8fI//dIVKx1ZKx3NZHpfXKfK6vMUFjEu3R6dRFeW
 RzfGHy6YlprzyGTfNGA==
X-Authority-Analysis: v=2.4 cv=O+w0fR9W c=1 sm=1 tr=0 ts=69934bf7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=uherdBYGAAAA:8
 a=VwQbUJbxAAAA:8 a=A_5oazGxDXGFBK_7PhUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Mh5Fp1fBFdRIVJIbRA0EYUalAw1gciIt
X-Proofpoint-ORIG-GUID: Mh5Fp1fBFdRIVJIbRA0EYUalAw1gciIt

On 16/02/2026 16:32, Hannes Reinecke wrote:
>> cheers, in the meantime, I have some comments:
>>
>> - I need to test PRs for both NVMe and SCSI, any advice on that would 
>> be good. I don't think that blktests covers it. I did see Christoph 
>> mention a testsuite at: https://urldefense.com/v3/__https:// 
>> lore.kernel.org/linux-nvme/1438672271-11309-1-__;!!ACWV5N9M2RV99hQ! 
>> NyU_EGj3duLYY2LeAfcU8f3WP67loAPsnqoz8qYMoV6CwqUgqWuoSE_VERaSDshSIbcmLG7zUhd4FfU$ git-send-email-hch@lst.de/ - I can check that.
>>
> Well, you might have seen the discussion on the device-mapper list, 
> where stefanha is implementing generic PRs for dm-multipathing.
> Or rather, trying to. We might need to revisit that and see what we
> could be doing on the SCSI side.
> Maybe we should be having a session about PRs at LSF?

maybe...

> 
>> - I am still not sure on whether we require a multipath version of sg. 
>> We can still have per-path sg. NVMe does have a multipath nvme-generic 
>> dev, but that just handles IOCTLs/uring cmd, and nothing like sg read/ 
>> write fops
>>
> 'sg' is primarily for testing 'raw' SCSI commands. (And dastardly 
> complex to boot). I really would keep it in it's current form, and not
> try to mimick something with SCSI multipathing.

I can get to scsi_ioctl() from the multipath sd device ioctl - 
sd_ioctl() - maybe that is enough.

> 
>> - I have not tried to detangle ALUA support from SCSI DH, so no ALUA 
>> support yet
>>
> Ouch. But that is the key point of the implementation; ALUA provides
> _all_ the information required for multipathing, so how can you _not_
> have support for it?

So far every path is just "optimised" and scsi_vpd_lun_id() is used to 
match scsi_devices ... ALUA support will be added, but if I were to do 
it now, it would just delay posting anything even further...
