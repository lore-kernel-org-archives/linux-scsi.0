Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA05372B2D;
	Tue, 24 Feb 2026 09:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771927005; cv=fail; b=LLUtXrU8DCaj0hCLhyridHvli/fW3Xi0awrgybS2Z6KWcsXfmRLvGqKUPt8S/UFUheuzSwgTbCxHXYNvNOF3Uv6WttR9Zsqj1ATvXrDkr/un4hB13qoafs6rlH6SwZjIMDAG9kDfgUwIOY4EKii3iqspCoHPP+Y3jf6MUr+BLbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771927005; c=relaxed/simple;
	bh=m+ihMzx7bVfuON2liGwFwddfb0HXZtyDq/UHCuHJyCo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A/trkUJf6D/qy4zV28TCJNJ3pDayXH5mbpb2LPXCVFW/9359il9yUyP74BC0OpeDmL6JbdA6QwNUZFbsNjZzfIjiitm8GiWPkuXZk7Wk7R+Am5NOsg3fBFHozr0wTaQNyq46XQkqQBDJJrDUQK5b0DAh+j9hc+V0GPsiLf+wEqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b6WpYPNw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uFwe3SFO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b6WpYPNw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uFwe3SFO"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMwRaV2780975;
	Tue, 24 Feb 2026 09:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z3Gi2WPj/+E7LrwoJ1ykWHWgtCZsZQ0lKVSgaj8npI8=; b=
	b6WpYPNwnlx59M2IjkYuYIqz2DkQhcpUQtEWsnj7AOQPW+ryNbX8JEvX4Hdvyrl2
	u/D+QodX26YwEWtUVs+KFk5S0SiakimIsQgDnWUXMx1PP3VNsKOZ5bLbcCuv75hy
	0F1JJHs5KengPt+J/1Yz7/lzs+F93j9xlzB9udpjWQfd03jlz4LxCEsU/nGbouZ4
	SbcI3ZDMel9GP2Nwz8iPc0CB966KpIBrKVUW4v82/B0JSPloUpAze+8mcY8dZZu+
	cIS2jmcbLeeoXZ09G9aIioQXnPSJaVciKd6vP5f87CLkUusYIMfnN+CMWj7uxueh
	05yYSNwDhKyjo2Dld9WmnQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3kyus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 09:56:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61O843N6027842;
	Tue, 24 Feb 2026 09:56:35 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35eh3pc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 09:56:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gGFMOGuh+Xkqr7myVU/jE/2R4QFVAslwLiECJoXVrzMM2v9DMk1RonLqKh8ZZZ+NQFUxe3R83Vq/3efCx84Jk3t5ky71yJ+OXSxafa4CZW5TYdE58G2E8MiRJOSOib+w3LuRbxGk38PABw6JZhUaVs1a5jyJ1ckJddAZJKHD0KZROu/x3jzfm7Uv98FAa4N4OGtAOxBRLSKw7fbdiMAQEe9fOrt5v7S/HFK/N3Po8lWb/5Pp9tJ0z3jbtP71WJ7nfVOdeWbFLTuPBfzVE6euG47fCtLqC7u/Ib0RIKDubWj28vUuzmusgSdgAfGlIbEXKD0SCMUwn6fGPsltF6HIhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3Gi2WPj/+E7LrwoJ1ykWHWgtCZsZQ0lKVSgaj8npI8=;
 b=PuRtjrIFYKNC10/aTnsvm0OsqLr7nZPpPEYyhu/qmNqkXSg9+wX2sAgBYycXT2WakIsJgvojBxBw9sZPjYwXZQ0AfuK1nC5BrkT/sJWLbARyIY/HqZkQBmA4N9SFhjAB837C8i7dWyVYbpmMxzpPk0ICdLjm8+KVngTnEMhdcFqwY11czOZPyopdum3CS6XIHOS9flmLzXmE+pL3jbg3BK7K39IkmRkGOFwQXYjAms7tk9af7twK++hhziaXwootlN4gDBqQTVS9AKaL43jfhuBksf/Ekl/Yf07bJEa/ALVID0oO7FrOCri4/wmDVgeMndVUGuyr7Hb8XU8ndlEZ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3Gi2WPj/+E7LrwoJ1ykWHWgtCZsZQ0lKVSgaj8npI8=;
 b=uFwe3SFOw4z4QnMewZRPdU7AdxW6dGClDblbRhAcbHMQLk65P4dnucA7n+f7JpgCedAyCT8Lc/NGPM6nRJC2Tv4Lq6d747sIYpEs3Njea+FJHkI9JDh06QD+xialcu3G92u+5lWAjbzKr8ge2p4NMD3onyykVVcapts0H662VD8=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6246.namprd10.prod.outlook.com
 (2603:10b6:8:d2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 09:56:30 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 09:56:30 +0000
Message-ID: <b9b7da0f-aa16-4d0f-b994-5d0087b01a4a@oracle.com>
Date: Tue, 24 Feb 2026 09:56:22 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: Mike Snitzer <snitzer@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@lists.linux.dev
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <aZnuSC0qYfw0hiwM@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aZnuSC0qYfw0hiwM@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0495.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::20) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6246:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b6b2b4-d10c-4924-0205-08de738afbe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnErN2RKb1BxRnJMREFKeEhCK2xYQzA1Q0hVTk9JUHNxd2J1OTFjYS9aNUZQ?=
 =?utf-8?B?UUdiaG9sbERzNmNaMEkyNGNBaHpNM01EYUQrcnFDZEMvUnZiRnRRMWIrbUlH?=
 =?utf-8?B?M0ovM091cTRITU5JVjM2YmtaZVB3NForMGxOTGJ5dGtBNTlCdHVVSmFuUjh1?=
 =?utf-8?B?b0Z3Q3Z2RU4yTzhNczNUakU0TFJaK2d5bWJmRnJHeVRJVGxxaytrejJKRTRh?=
 =?utf-8?B?eXhDZEc5WXloc1Evb0QyM21NRFNZdUFwdnhHOXJpRWlnOHJ3bE0wTVFtbU9z?=
 =?utf-8?B?bWVscFVucFo3b1M2MU91cFJ3M0FySk14ZFlJM05aZG1CUnBlQVBCNTFvclo3?=
 =?utf-8?B?OEMzcVRKcjRaNFg5SklwVU9ZUjEzMGY4azV1WUluN3E3YTdtcng1MTUwOXZI?=
 =?utf-8?B?czZDeGQ4K24yTE1jSUVoMjZsUUFTR3h3eElGSVk4TXhBeU40U1lvV09BZkkx?=
 =?utf-8?B?MGtrSmFMNnZ6Q2NZVnVUdHRrOVFZUFl0UU1vNFZyTWt1TmIyK091eFdka2ZP?=
 =?utf-8?B?UEl4cXpLRG11WkFCNnJJNzZDSDAzSUxxSDluQzFIU2VBWFdXZGZ0MWMvazVY?=
 =?utf-8?B?K2RkSmlzNEJSNjJjSzBWRy9IdFIvOEdaNTdJTTlXZE1LbTNZMmZvWjBjdU5M?=
 =?utf-8?B?d2pubFNwckhKVnMyYlp5dXhNTjM1dE1UZmZSbVU0QWFYTThKTFZmVk9KbnhO?=
 =?utf-8?B?RzVWc3JvY1ZiU3oxM0hKbHNKMXJFaGpacXRsZ3RwaEtlYkFscjYyelB2bHBN?=
 =?utf-8?B?SGt6Ykc4ZUhMcUtnTG9Fd2dHTENsVm5YaE1hRjJsaEo1NWJXbUQ3MEFNUzNU?=
 =?utf-8?B?Y0hCeEU1ZE11YWtrMFVCUUE5Sk9UR1pPQU9OczNkellGUW91UVNEMDBNa0J5?=
 =?utf-8?B?S05hV1BHdFpSVk9OaTllSUpvKzAyeFUxSFRSRnVGaW5BUmFQNitSSkNWWmJQ?=
 =?utf-8?B?dG5BMTEydXplbWIrbk0wRFNoZmM2dHh6SlhTenFzMzVwdWo1YlFRdzNQbmh5?=
 =?utf-8?B?OWdzMlZqOVBFWXlleUovK3ZrWnhESjYyOUZYaDZQZGcvZk1TMVI1ckoyRU1C?=
 =?utf-8?B?aGR3WFk4Q1htckhoYWYrZDBDZFl2VHc4bzFPV1NxNXZxWnhTbmV1bnpTbkxj?=
 =?utf-8?B?amw5S0RXMERlZ1JjMjgwODFjNzdTVWczREZ5RXhybjdlRko2SVltc21IWlMr?=
 =?utf-8?B?aDNzMmpTZlY4aTNNemRJWkdPbHhJS0VnRUQ2QzhxMDlvcVYxVW4zbFFmYjg4?=
 =?utf-8?B?S1c5UFZXZVFzVENUYmkrUFhNYVM3SWRTMlp0NlNScDRyaUlWNGhNUm8zMDNQ?=
 =?utf-8?B?bklqdTAwbkNzUFZsSjQvbCtuTjl0aU40amxOY1VhbjIrY1ZhUTJ5a0VaaHNE?=
 =?utf-8?B?aXlPY01saGs3Z3plYSs2SnpMY3Q5QjYydW9OMnVzRHpTblVjNU9PTlJOc1Q0?=
 =?utf-8?B?eHZTeHZrOHZsa0lWVEczc1lzUU1TcWI5aEVnVm1lTWNhMjRsWVVFVEg5YTIr?=
 =?utf-8?B?STF0UlNvY2h4L1NVWGlrMHFMOUc1clpqVFlVSURVUkc0Q1IxU3dUbDkyOEFI?=
 =?utf-8?B?aGtnNm9OQ25hY1IvSEI5VWVoQ3ZGVEdvdHdtM0JjUmxSM2pObUh4T21lazNS?=
 =?utf-8?B?bzg5WVhxRGtFMUdGTlBNNWdhTkozMXE2cHlLUmlXNnkvdG5NOHQzREFpL0ps?=
 =?utf-8?B?YnJlbWF6U3ZnN0pYRlhlS2JjSFNnZU5aYy9EVzRkUk9DQkY2V1Y0S3RhU0Fr?=
 =?utf-8?B?R0g5c1duQ3EwTG9TRzZ1SU13WGlrK2o1R3hWeks3MnJiakRKK1pNblBDTzRl?=
 =?utf-8?B?VjFtMjFLS0IrOW1XNHRIR3plR1FaMDBMVy8wb0xIVnFqc0JldVdqcHB5WkQ5?=
 =?utf-8?B?bXBNZmt3dVk3VyswM2lvbzcvbTlUZzdWcit3czl5ZU9uaURyZHVjOTA1OGk1?=
 =?utf-8?B?aHNlZFprUi9Ea210T2hQd0ZtYmpoRERKb1NxTEFSSVAvVStqL0drNnAwc0Zr?=
 =?utf-8?B?MDdua0xNQVpRZDhnckVqaTFLQjExby92V2FhY0lmM1czMkZQdU5PcWg4b1d0?=
 =?utf-8?B?QnI0TFRadHZ6ek9OMmNqb2tmb3lWaDBpNS9DK2g3akpzbjBuNkZrWEd0Ky9y?=
 =?utf-8?Q?EwGk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?all6bTZNa205dUMrSWEvTnNGclRjSENLZ3VpVURqSW1ZUmFIb05vcDJHMnF2?=
 =?utf-8?B?ZlVTbTFFT1ZjMHhmYWYzS1ZTR2dzYy8xb2tzNzc2VjlqSm10dmtDVmsxTjdi?=
 =?utf-8?B?dXNQM0prS3F1aHBQSHRSNTk4eVNCRG9CMFc1cVAxUE16MWRBRlQ4UDhpbHJI?=
 =?utf-8?B?UUFwMDNvVGZIcGtnYzRqT3k2SlEvMm42YVRvTFJMOFlGMFU3QkxNZXpXd09t?=
 =?utf-8?B?RStLWmdlbzI5RXdVN1Bsc3FXTHcwV3lJNXBiQ1lQRjlVMDFlKzBKMjViYURq?=
 =?utf-8?B?SXJNdkNUZ3RvMkV1dW4ySFNPY2J5eWNVek5PT0RjUm0zajJMK0pwU2FGM1h2?=
 =?utf-8?B?M1lxbnFjODdvbUlyMU8xTHpWbENOalZGbFM3cnVhWktjdEZ4MGxGS2dUcWEy?=
 =?utf-8?B?TWRHQzFyb3U3cGo5OGhPTDhaSjNXQVBPVTZscDB3RVZ3a015WHhmZVh6M2FT?=
 =?utf-8?B?ZkFIcXFMTnRpQU81K3VVbmE2allmN0h6ait0ZGY5c1F4cFQrZDNlRW8wVGFB?=
 =?utf-8?B?cWwvT1RGYlZOUkMzcVp5dnI1Z2lrZmhMa0JUWEtrVmZMRGFYREJxWVBzd1VC?=
 =?utf-8?B?OVdCTjVUTGEyYnB2OGNXbWJMSFl0NGRRUkxXN0Y4U2o4Y1VIMktmaUg2VEdH?=
 =?utf-8?B?VHlEenpkWXNtdWlPSjNMdFlrb0dINHdYZm1kN2hUbDNRWXVKVUg3V2NNKzFY?=
 =?utf-8?B?OXVjaWE1cUY4aG94dEpDZ3FRQmtPaUdwclNBWUJUemU5dnpoNnVRbUNYanRC?=
 =?utf-8?B?TUg2aXdNNldxWmVnSWU3cUFhNFFMc0F0dWZVVGhpZWJNNWFjTlJIZlFEMURi?=
 =?utf-8?B?dEJ3V3IxWWRWM1c2Tm1WVHlIZVZ5TnRUWCswL0IzMXdHYmtzcHJ1dWMxRXI1?=
 =?utf-8?B?ZGFrWE5MVEdVdjMrMTVGU2dlb1VKcVZZU3M2L1k0TjhSakdZOWQ1cFArbXZs?=
 =?utf-8?B?bmEwdEhnSTU0QkdkU01UajRPVE1RVmh3d0FtamtuNVduMzN6TkdOZXlxVWFz?=
 =?utf-8?B?REp3TXNnU2xYaHhxTlQ2V21oN1J4RTZVRC9Hb2tkWFRoa0dhZUpVU1ZWSzVu?=
 =?utf-8?B?VlpzbE5WYThJOXptR2UvZDl3QjVVWjdSSUoyV2ZFbGd5Szczc1VOSG1NYkdz?=
 =?utf-8?B?ZVVFZXFiZUJjNTFZTTQya0dPWlpKQlgrSWJJTU5BNGtMNEwyYXFQRzFUQ1Qz?=
 =?utf-8?B?U1paZlpEOWxYa0lnSUIvbEJwRU14R1ZkRk1aRmF2V0NObUduU21sYjlaR2VC?=
 =?utf-8?B?RTJtaGJOVjN0bHJKQ1YzeCtpajNIekIzNGk4eWdueG5MMWVSZUFlQWVXU05v?=
 =?utf-8?B?Zk5saDErMld4cU5KczNFdXo5SjR4UzU5NTdQaXNKV2plTEFuTzFsMXFsMXBH?=
 =?utf-8?B?L051R0Jvd0hON2RWNTY0NnZoTUVsSXppWFJLbVcyM1hVSklER0dWVEpmMFdE?=
 =?utf-8?B?cmpOb0sxRFNVWVdpNjJmNFhOVXp2bWxPU1JadmppTFpYbWpTSzVSVVA2Q1ZZ?=
 =?utf-8?B?NlpybXJ4N2NUY1hJZHhhR1ArMXJCVE5nektqbWNQZzRZYkhiZWRQcjZIWmZD?=
 =?utf-8?B?dFQ5V3A3ajk3ZDE0d0xJTVllUGdZREd1aEk4eXU5UzJrKzJGa3ZFTUVSNHhN?=
 =?utf-8?B?akxOMVJYaUhENmE5cnA3dDE5SzUxUlFjUGk1RW9wWnRFbUJHQ01BNG5SOHhN?=
 =?utf-8?B?MU5GdWROeUNZWHR1QnoxTXRMVU1OQjlhRlJhdWFQbHJESlNJTnptNVNpT2Yy?=
 =?utf-8?B?UnJld1d2TEd2Yy9QbTBHQ3NmNVdWbmNlUWttRXJxd1dVWEJjZHIyNnpFeVpk?=
 =?utf-8?B?aGxrcUpZMHI4Wk1FdEVqc0hoK2dMcDFoMU1HWTk4b0xJREJkWStaVEo3S2ND?=
 =?utf-8?B?S042RjJFeDZQVml0cU43UnJvU2w0ME5iUGNMNG5ka1hRK0xIa2ppSEczbTNr?=
 =?utf-8?B?dkZCTzd0MzZSMkZqUTd5azNSZjljaStjTXE1ZExiMWR6cUFVTjZRMEdYVU5t?=
 =?utf-8?B?ZStJUzRoRXpJVHNnUVlQSWpnRzBHWVQ0R0QyWFFkY3QwNit2bk9ER1k2QTU4?=
 =?utf-8?B?Q2d0UTRwN0s2WDJFeXM1SFpJcE4vVDBoQk5ibUhaWGVPRWVyNGdVamgrMG5x?=
 =?utf-8?B?cklJM3h1NW1Lc1ZxT1VUSzF5SC9mbCtXVGRUVVN3ZVN1SDB2ZklyWFZyd0t2?=
 =?utf-8?B?Q3FrWEZBT25kOGtIOEd3MHg3YnkwcDliMXlUaWZHc2ZNN2h5OGtlWDFpaUlB?=
 =?utf-8?B?ZGMwVmx6TlFSWjJuTFhjajM1SklQWjloZTFwcm5xdTlRdlA1d2Jpb3lEMEta?=
 =?utf-8?B?YTVKNmFKVDgyaFk2dEFSL05jWTZDSlV4aVJ4bG02Y1ZrdHQ3VmlaUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1CZXbRz8Pp2dRFg92sklxqGQ7QgvR1jHZS2jtMAr9skBURTqhZprztp3j+wF0XqcHq9pdvhgXYzfPJYtFLtEDXmFRPsEDN1ZjLWNLluvX20uYWLp8eYiuWQwP3WBfOJxTzVRhFPm1AqotbFBTel7K0RFt7ba9ZR/vNgIGNAtfKS98WIxCiEo+epx6k09r9hrFhWNlTenPgPgHv6BmJKW0WbQTHien/BvhLAd02Ht+zmppLChaC2/WcD6sOz4TrvYF5XrIgtiL2QidKzsgx8a/6WwtoU3Cgm1pWsnqxs9jj2CGXhEqJ4N6aMJP6vxRpLDbCuK4hs2Mb6LQlID8jTHqtQqB8NV5drnaatUdR+ONbrLg069QgW3OoULNoEJTkb7BNNGwjKyghOFiCPT+ia6K8gejE6PA+O0qoFSpv3o1/ejEBBSyDu+MWTWt2PIsXKPMznXefGIBofswrVjh4LtB+n/b3l3gYRtsOUeDZTy5A8/SxUTY1R932PPI40X2hW4eONTs9OshxcizfN86DKc2hwC3xb4sFcCHC3eXGUX2w1VNoPIOM7OGI+U6w7BJFpY+7xEjWvNtvfWgtcM1L9/Pq+WuTnvYeDRmhZMsfzYSjM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b6b2b4-d10c-4924-0205-08de738afbe1
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 09:56:30.4377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfYnTyovyMJ+LslKxMj8/F/9jUk2ietXkdxUfHC4gj9kyzbjz0tPWFNUsNVPo9Ifmmhwwftj3D+9L4OqZmKGWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6246
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=990 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240082
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699d75d3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=8fI8DI4ctqT9eTTScy8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: 41mfnAVFWR6GvIRhrRMRuWKAUXxwIWZ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA4MiBTYWx0ZWRfX3UmIymFsoMBw
 ofUlNnSz9FfzYdLJEzoNBv3p7DTjVGAtV4YqirO3uOTUGbdm3XEByWnOpgx2Kp/fu4rurEuBtBC
 q/bAN6FFuQy8Lshy49X2nME2ZpVNl+tebKFTGuk2+4LEvGN8y1D2QB6PAFtVweWnjMpT/CPwhnW
 tqh3JAq4NpNp8i0wQl0erJ0GUNCWj/ynb2bkrGFlkDIcJhghdgm+L92B0jcGbrBfm+yS8cZwhO9
 RnCe6V/fBWBRu08GxRrv1FzypO5lq17FrPtnR3XO3J2iUOIiiejf7Fm7vs9TGEKCHxMeGTvCswa
 V6F7T+wA2MSJHZySz4L6lgzO6C5po48HVtMmhiug9HHZ3DafMT9LkMbZrL+SsZ71Tczq3WQ1NQZ
 SXXFGNl0w62oV8MC1xo4AnYdObfy+/gSzjMgxF4R30f+D5uN+xCm6XqkxUvKUVnje8dugZfO+Vr
 mpLZgqgtnk4oRO8WbzOcIu1vMZ44ByU6EA3vQNy4=
X-Proofpoint-GUID: 41mfnAVFWR6GvIRhrRMRuWKAUXxwIWZ7

On 21/02/2026 17:41, Mike Snitzer wrote:
> On Fri, Feb 13, 2026 at 02:19:11PM +0000, John Garry wrote:
>> At ALPSS 25 I presented a proposal for Native SCSI multipath support. Let's
>> discuss this topic at LSFMM.
>>
>> The idea for this is that SCSI could natively support multipath, like how
>> NVMe host driver does today. It is intended as an alternative to
>> dm-multipath support.
>>
>> I have been working on the implementation and I plan to post patches in the
>> next cycle. I am looking at a 3-stage approach:
>> a. create a driver-agnostic multipath library, very heavily based on NVMe
>> host multipath support.
>> The library would support features such as path management, path
>> selection/iopolicy, failover recovery, PR, delayed removal, gendisk
>> management etc.
>> b. switch NVMe over to use this library
> I can appreciate that the kernel to userspace interface of DM
> multipath is clearly unwanted (hence NVMe multipath and now SCSI
> multipath).
> 
> But you should really be switching DM-multipath over to using it too;
> or at least detailing_why_ the core of DM multipath
> (drivers/md/dm-mpath.c) cannot be updated to use this common backend
> library.
> 
> This line of work makes little sense to me if it just ignores
> dm-multipath.

What I am proposing is refactoring the NVMe multipath code so that it 
can be used for SCSI as well.

I am not sure where to begin on saying that this library would be 
unsuitable dm-mpath. For a start, the bio flow is totally different. 
Then path selection is totally different.

Anyway, I'll post the code this week and you can check it.

John
