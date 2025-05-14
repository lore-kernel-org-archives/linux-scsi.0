Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767EF2206B6;
	Wed, 14 May 2025 10:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218553; cv=fail; b=VeTYxI4GrXp9yI2LKz9jivKIEdAKsf8+Hp3KFB6JFaRXCNPswqBxlxJ4CBywaXCAx2t2RloCTW0RAQJLwmtkMBgYE4+PYGvGQfcPdQX92w5tCYRN3G9rfbWpvujLf3Z4C1EfeBWjDWzZeCFrcGGNUMQfA4ZXux7ww6blmKrA3Yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218553; c=relaxed/simple;
	bh=+HyLwbGG/px3PyRT3HGXxtdWjpqEV03HXNjsozj5umg=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qnvO+izLSafdQQ1jSA0ZZfTs+LDHg9wkaVtkoRfl1SCP7ckpwxHM39EkHKLpFDgdcTHMMJLxpfeUkGmWMS/wW0sICO5K6jL5E34t4Zh7ZzFs+8CIZRFKRDGoGBI+dv7DYPcywX66cOVEOmvEg03oGHHYTgYj4OXKnfaDDkUqsKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HNgamPWr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wZTq/JOa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HNgamPWr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wZTq/JOa"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E0fvrC008016;
	Wed, 14 May 2025 10:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GzlWW4zGUodgiWz288eG16bZrc7B66nnCsZ1E3FjSGA=; b=
	HNgamPWrYDpqY8c9WdrikaSR+Lzy7OfgN+r8ENr0gtjJFDSBZIE0/b+wVny5xiai
	eRhlDBd4+SpqGiKal8BK7sa2jbQeRet/uKchCbWLb+6w/hso8Yxr2kicE3TvDuSn
	GlzKm5Sg9BX79j/uJOhOPVL/9EoZYNCS163aPG60aMv9xQdGOIgKTMuqmCaAhFl4
	RTWO2MZ3liIOEc6l8BO+PoP32fHjnmiG+A2xm7g71EDAbL/l5zjuc8u2m7Ays51e
	V4wzigv+2wgGdBjuFTHOR1Uhw1pcZNXjvAa20P5QKTw6hQJBHRXuI/YBws1Al+0M
	jwICbzlqTuCS4gKH/SRPrg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcrh7hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 10:29:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54E8NJ2o004352;
	Wed, 14 May 2025 10:29:09 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010002.outbound.protection.outlook.com [40.93.13.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mqmbup0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 10:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ldSvXnWmY6CgBnTjXtRscS+XE/n6VZG1BENk4ozQvSov7V+Ic1bMv5WJVulopPjvFfuv/5Fok+agZ60EMpWVol1E82d5k5KuAq2LOaqjQnYv1gbCMeerxQchEhOnHd8HA+/30K2W/fKKkk7YD4HHDgG3DtKQzOvjdq0qLiQIOhalYBdN9iL8j5GEMUqbzgM0vnECTzLpXzsEY8oJY6R6lwiT4w0RhsTWdDBY8VI44tQYykF3qkSRBEFe4+QW4XiziuH4Z8S6EQEhq8WUZU4APPG6EqnHtbWYdqgpyttLurU/Ktv2eI2iAOCfGqusC67/f72LPMsO6EaD0kBS8N3uqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzlWW4zGUodgiWz288eG16bZrc7B66nnCsZ1E3FjSGA=;
 b=tbb5NLC9dfqEDzbw91Kn6dsy+lryzR3pM58rH/eCgfS/8nBDzLqEyhYDK2ScD/QT+WXg6/CH00EJEem73Px+lIrkLUqzvUYqgw1zJGTkRZRQKgfFyW9QbyIqzFwP4gvjhwnRO4fOBJ7JVhNjU3LjT5IFGjsONCpGKXs8/DnF2V09pBBtkOu1xrKfc1HPpn6OEUBEYoXaWoIrkIJo1OOQlfckq4Mao2tW7SmtIcQdfiUnFDYmdsjWnzfkvT8V7CMYOt6tUNolwKL3QWDl6OHo/67q3+fAB4ggNHZ5Sl8hxz0vMiDEVD0Xj4sfpALKVS8b1Pkj6+Sij5hzTiYH2fywYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzlWW4zGUodgiWz288eG16bZrc7B66nnCsZ1E3FjSGA=;
 b=wZTq/JOar+nPg0I6xuDCmDndYHHDGPDOFC+IM/r7oKJ/ltB5ErxBYdmAIoZ5o9rO0mxo55ukqIBOJHpLpe9aOovLQdS/h2GckOCQfRVjSROf4VkBOSyU53OxcWcrNhfpA8EwZpaBs/7m7zNVDCGPRFy8TVNhp7Re/1WxoIK5ymg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5546.namprd10.prod.outlook.com (2603:10b6:510:d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 14 May
 2025 10:29:07 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 10:29:07 +0000
Message-ID: <51260977-b1d4-4394-bdbb-69debae3067c@oracle.com>
Date: Wed, 14 May 2025 11:29:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] scsi: target: Add helper to setup atomic values from
 block_device
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-4-michael.christie@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241008020437.78788-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0214.apcprd04.prod.outlook.com
 (2603:1096:4:187::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5546:EE_
X-MS-Office365-Filtering-Correlation-Id: ddd90bf8-787a-4733-b2cf-08dd92d227fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aURNQ0FNUm9JYUhDOEVsWTJ3dFhvYmtnSkZ2dGF1NFhrTDA5d2x2UkwvZUdn?=
 =?utf-8?B?alRGMENucmJnbURRVk5EbkUzNzRMNWhOTGJsbUhQZHVsblpMSTBTdlc0c282?=
 =?utf-8?B?R3pGb3JZcDh1ZWVEbURLNFZ0K3VRSkNmUWU2dCtHQVJJSE8xNTBpeXB5cCty?=
 =?utf-8?B?RXE4QWsyb0xRaDNWZ0hKcE5icTl1ejlHLzNqZkIrT0V6d1RNQ0xBK3JWS1Y4?=
 =?utf-8?B?dTRXUXIybHgwR2Y0WjRmS1NTbmtUVnh2eEZwYkE4QlBPaGZsMXZXRUJiTTd5?=
 =?utf-8?B?T1M1STJYSkxmQlFuU2ZoYUVXY1doZ2NjTmNLM2tVZWRNcTJ4RnpXOFhHbmE5?=
 =?utf-8?B?eC9kTTMrOFFpZzNmVWhmZDZzeEdlMDgzdFhaWFQ2RHBWZFpzV3F4VkFrRnp5?=
 =?utf-8?B?L01vamZXM201aVZtTS8vZ0xqclkwQkMvZ2hYZE5BVkZGb0JaTFhjU214eFJT?=
 =?utf-8?B?OUJ2WnZQWGRESXkrRFR3NG8xQnJCb2JCaXZXN2hiRS9aeHNWdHVsQjkzRzM1?=
 =?utf-8?B?WGgwSnBkejFhaDlzMktRbUxYcEdoSGgxOU1YczAzeTNnNmhRUDMza2xLSXdR?=
 =?utf-8?B?YVF0aGo4WTN6U0Z1NmF2V2t6cHpVa2piamUrcjJONXQrRmtudFluZWtPWGxn?=
 =?utf-8?B?NEcxcGdqU1ZZTGppcVdVSjF5ZHhXaC9KUEdidnorcWVxbW10bTJxandjd20z?=
 =?utf-8?B?Z2d1bE80U082Vjk4bEl6enU3WUtmZU1VVkNLK2l3VEdWd3J5a0o4VWlvcFg5?=
 =?utf-8?B?Yk1yMUxWbzNDaUx6dm5hRUkrRER4amRwMzRUVDJ4Q1JsQmpMeXU0VXpGOUln?=
 =?utf-8?B?N2RLcnhNR05yaHZEZm5VMEdsNWt4dGNWU1JBZ09IbHZuN1Yxb05ZNGNrd3Rp?=
 =?utf-8?B?ODZpc0c0SnAzY1pRbWx6NWN3elBvTkFZWkxSSU5mc1lIYXRvOElFVmg2QjJQ?=
 =?utf-8?B?UGZiL3lmSDUrYlN3NzhJcXQybDBVNjIycDZsalo2RFdLZzkzNmQ0eFgzS01s?=
 =?utf-8?B?MmlpWEhHN0w1bWhVVGVpNFFwb1FBb1VFNXMzaXIrY1VQOEN6bjRQcENrNHRY?=
 =?utf-8?B?OWE1b3ZlOWxaUWNYQ0tFWjJtWHB3STBvd3RBa0wvMkdIc3J6Q3dwZ044SUNU?=
 =?utf-8?B?aUNmQWJ2RWRRb3BHSVJNUTdRK3A5N29oNHFuNjRvaVpZTnVzZm9rMDNFaEVy?=
 =?utf-8?B?dmVqN0pGYVRVdnNqS295T2tmd0hFZHZJVGpoei94bVRlOVF2VmhhRVhVTTE3?=
 =?utf-8?B?aU5BdHk1TzRBN1BDckQ0bEZDR3VSSkE2bmdjNzgzOCt6cWp4eE5XaEM3OFV2?=
 =?utf-8?B?bFRjQlpQS0dlNkhvZ05XSkd6bzNsWU5ocVBiOUl0cGhUYTVyN2Y3WFNCcHZh?=
 =?utf-8?B?Y3psMS9JR1ZLd3BNY1ZoeXI2QW95UUplUmd4NVRncndNcE8zNDl0U2NsMUd6?=
 =?utf-8?B?bmNZVmh0d3ExWFlQRUdtUzIxVi9xN25KVFVJbHozR1R0cVkzelQ2SDAzSXI1?=
 =?utf-8?B?bkFjT1ZtZE5mN1pJNjlFWlBVWXl6WHcvengxbGdnV3g3RGlmWTB4aTR1VFpy?=
 =?utf-8?B?NWtGRkU4R0lVWWEwN0xaUlZTL0M5bXduMlp1ZGpzdkFhVlMwd3A4dmtTQjBT?=
 =?utf-8?B?ZWdTTUFJMk1qYU9TcHdQeDJpdHZvdURWcEd2OW5ZZ29zaTE4eDl6WWlqZkxU?=
 =?utf-8?B?YmgxLzlka3pjOFF3RnJMSXh3cXU0VFd5TTFRQS9DaDdUbXNpMkUwOHlMZEZo?=
 =?utf-8?B?WVFLWG5NSlRQb2M5cDZvY0RHUDYrR3o4Ky9mWnRyb05YcmNqWmRyZTl6Vitx?=
 =?utf-8?B?WWZTVHgwRHVGRVRXM2ZTM1MyMXRYRW5jU2hjYUo3d1A5UzhwV3haQ1Zqdkli?=
 =?utf-8?B?STV4Zkw5ejNXSGk3V2RrdDFEblF6Z0tlUWkxSkpkRFBvQzNsakF6WSt3Nkxo?=
 =?utf-8?Q?HNRqMw+chNI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THhvdDd0dVFyQ3U3NnhYMWpBTnJBN0VialFGZ2FTcG90azE4dEZvUVRzRzlK?=
 =?utf-8?B?NEZvbVhvc0IwRXdxbC8wUTlsWWlHNjBUMElmdjlhQlNOZk85TUZVNmlOa25F?=
 =?utf-8?B?TTlxbFhBeWJMaExVUDBwbkZmUmpFeUFiby9tZDl3c0d0aDBwcFZtNXRMVUpw?=
 =?utf-8?B?VEp3LzRIcUNWQnhiZERaQndMczlVajRERTZjVzVNMkVBYkhJWGxPVTRRbmVo?=
 =?utf-8?B?RjBPY1FlUW44YnVHclZZU2djRm53UEhKdU5PMk5qU2x3ejVpZnhXRXpEMVlr?=
 =?utf-8?B?N1VRSWdDV25XS0pXa2YvNTVmdVltdlkwS0d0WU5ucmlvUEdBMUNpN0JBdkpx?=
 =?utf-8?B?ZGUzRmdDcmV5ZGlocHg3aHIwSU91U0MrNjZpd3hReXpnRDdBOHo4Qi81SGdC?=
 =?utf-8?B?ditDZHRvSlpXS1ZJNXVOTG1ESEpLN2dESzUyaWlwRU40VWNYa0VkYTd6cG9E?=
 =?utf-8?B?SXNxWHdEUkY1RmJkYVphMDJyOVMwNzl2bmwwenl4TCt2K0s1N2I1R1lNamIz?=
 =?utf-8?B?NzR6YXNJMU9IcU5wRFpML05tc3JEbjB0V3dPemthZzNsN1o2V2tzNmZXcEpD?=
 =?utf-8?B?cktmV3NLKzlWaFU1eHdHTkVNNkNIYktYWk1ORmMza0JvOHIvczJHS2htMEFo?=
 =?utf-8?B?Q2NRVEh0bjN5cUgxMnl0bUErTnRPREY3ajhEdm1KenFRc3ZJempRZGZOVHBo?=
 =?utf-8?B?cjNQdjArcnpmaGJLVEJaS0lseHgxd25QbitycnZsM25Jemlub3hUMkdFcnla?=
 =?utf-8?B?VzY3dmdKVUZEVGtFVE5vRHlOWUVMeVBHZlJIVmptcW9PeEQzeDhlSFEwVnNp?=
 =?utf-8?B?S1NkOFJjSklQWExLQkNBaGJzbFErODNUTXU4WjE3ekRpSkJ1NUlCVldPd21p?=
 =?utf-8?B?MjNCV2N6MXlWdE1JT2s3a3dFQkdiNjcvVUZyODkyRFpjNFEwVUJ4dklVOVo2?=
 =?utf-8?B?enh0MU45akNFUTVoYXI1cVZrM3drZ1VhRXpuVnhOWWJ4NitoZXR5QThNN2pS?=
 =?utf-8?B?bFNCb1l0WEZnZEc1Nkp1MXdCaTRIL1g4RGZEVUtKNFkvTTUvd01JaFBibGg5?=
 =?utf-8?B?THZqem1OVkhnRWJvekFDcXhsMWhubW9QaTdQWGNPNnJpbE93d1Y4d3BoSjI0?=
 =?utf-8?B?Sk91WUlubWZ4M3ZTUlR1d3RMQmJYNlJYNnB1S1lxTHYxVzNZcU1sa1o1ZFFJ?=
 =?utf-8?B?V0ZwUEVVdENFOTZQT0lCdkNVZjFrRUdBR1prTFlwZ00yQ3VLU2hIY1FmR09t?=
 =?utf-8?B?ZkFIYWpQVkNOZ1Iyay9SazdHWWtoVG5BN2lwMGhWNEgxYzFmbjFjVnVnbm1y?=
 =?utf-8?B?bWZPZjE3VVRrWUZpTFl1anJpTTV5OXRZV1lpTmhETVh2V3FYMkN6VkFGTHh5?=
 =?utf-8?B?d3pPaUZtaXIzSTVhWS9wWUwxcG1UV0F3UE10R3FxSmhLMTVYLzNTcUpCR1hM?=
 =?utf-8?B?M0tTQWJjUnlCS3JuUHJ6ZHdRWkJIdzhlU2crbTAxMnpnSm8vNXRrR1NjU2VM?=
 =?utf-8?B?bTB0V3NkajRkKy8zRUpodUU2ZHRrbGh5eUM3ZUd1TUsxdWlxVjA5Mml6eDdj?=
 =?utf-8?B?cjlRM2p2ZWlWL3R0cW9FK3Jya1dXR1BOVFdjekgwTzFFcXZmOWI5UWRiVWo2?=
 =?utf-8?B?RHFtRlp1TkdrYlZJaEFOOEZJR1UrTzJNYXZFNlFPaWFUWEhncGZhS1N6Z214?=
 =?utf-8?B?cFE4ZWtFZWpmWlVVMzdSN2FEK3N3cDZkTHdPbEZxSlBaMDdtemlzZ29Gakc4?=
 =?utf-8?B?eCthd3pzSloyME9qazZSaTNKVDI2RlJJM0VZa3cwT3VjdjY1ZEE4d1Y1YVVO?=
 =?utf-8?B?YVBLTkx6WndDeDdPWHd5VUhGQS9VSHZ4RTlKc25yNTk1NHNQUGNBcXByRUx6?=
 =?utf-8?B?NEU4c1JJVW5UZFpScFV3VzRHdmxXZlQyNnA4VnJ5aWgwTHFDbWhheHZKQU1q?=
 =?utf-8?B?UmxhbUt6bEpoSldzSFlydHlWSTBSZ3JsUWgrdmtIYzJOZFgrUUROdFhDSTB0?=
 =?utf-8?B?QkRuak1LaHhkejlHcERXMkZtR3V5S3VDVEJ5NDdFaVUwZ09IZklTN2xuaVFZ?=
 =?utf-8?B?blR4L3k2OTduR1hTdVpIUGFxcmlHZExiS0FWM2ROVDlQWUQ4c0hZOUNJZWZk?=
 =?utf-8?Q?2fs9lO0Wz7Rl6vtexHDDoHJuO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D1WgTDYyFSMFMkB6Wbs9qE5/3WKfwkpNtVyurmy79xRFtZXmSW1nZIAiodELRsoBQrRDTaeBh57N0cQKLgemBjwSna2zy3z3zDSM9FenzT46231N2iqp7amjwrTtCkkxnqBenRtS8v+4NGXkQS/g0yp0/oNZd/U8AsmVLSzMy5M1bm5pQXaEoTHi2r08XWs9XoSe0DEYMSG0ny2+REMYJyGf2V1wNXabuXqsWzwu87giu+yaOvf93WkFJvlkFA+SbOpdSEgEJQdcWeF+m8fJnG9L0i57CyUFypjwg3ln+UxKBArI7i39XWGdVnKfVOLGvlyRrV4dyqpUJ3hzh8ta/431i17ZGS/bvTFzJeGhkHhQM+WFv6tKOxxgpPAK/W3jpx4kAOJdNiCsSgynjDMB3PhDoR16OUI0YEBXNXAzdO+s0kwoE7faHXZ9LR7glISs65TwUbx1f752G9W1fw0jQ/6fhxiVPFSLjptIVECVqocBTr3Ktp6X779s4BTDGwIRAGV2FXAycEGsRjrydTT0xQIV3VAb6bbMbykDOhd9vWNLu7zAcqcSb4yPoIuVabszo6SWRwQv3hYv/ORJasZ5SF8eHeXgXFWu9CurebEJgEE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd90bf8-787a-4733-b2cf-08dd92d227fd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 10:29:07.1524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V22KZj7tU794sQaDIYywG8EZ8Qto0/3STkwY58z3VVgHy2I30Py5n2hYG1yP5kxTmzpxF+CYHvLBsMp861biCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_03,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA5MSBTYWx0ZWRfX8DV5bggrJtdW ksmroikygyXswaXTYiZsqEX+5HmS6bEEXK0bObF0W/P78A4CXMR/e76TuvgOvbwWXwo9wh0i3d+ a/VJFhrGD+vqkqsjh3cVy+EzCWM6lSYzooaKafGDRjOMYOAwfNHhbKO1mrJH3L41PBN81JruLYi
 atQEGYLuAoGXQoN3G0o4oU0f5US/W3y6Yi9nr7ljeMiTvaA13VIJY+TLpNGX0IROtchRyXXIZRC PrO7tyzjHv6FtS1Kov+gbCVcSQS5iQvyDooF4brb4gPpCEMNzoCqHO6go9RZQdgNnUNrnVCBPdL IdKRqWhFWE3bBXlmZ5pJYXsbToRQHJAd92B2HQtsg9Pn64vzqwD1QqfRAINzkdDVKYK63ikKvdl
 9yEzwwolhdSZzQDZK/d1N5u6GFBkjwm1yHzdqEbBmLxExppwRNwbHerqsT7UwaV0Hq+1B4Tb
X-Proofpoint-GUID: y7KayhOxxhkv9lBoSRNwlonJetU8HCfG
X-Proofpoint-ORIG-GUID: y7KayhOxxhkv9lBoSRNwlonJetU8HCfG
X-Authority-Analysis: v=2.4 cv=cuWbk04i c=1 sm=1 tr=0 ts=68247076 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=5-oMw7qAmPmcvclqcBAA:9 a=QEXdDO2ut3YA:10

On 08/10/2024 03:03, Mike Christie wrote:
> This adds a helper function that sets up the atomic value based on a
> block_device similar to what we do for unmap.

looks ok, apart from earlier query on alignment

> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_device.c  | 18 ++++++++++++++++++
>   include/target/target_core_backend.h |  2 ++
>   2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index b709a64c0ff3..4741de3d1061 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -793,6 +793,24 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>   	return dev;
>   }
>   
> +void target_configure_write_atomic_from_bdev(struct se_dev_attrib *attrib,
> +					     struct block_device *bdev)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +	int block_size = bdev_logical_block_size(bdev);
> +
> +	if (!bdev_can_atomic_write(bdev))
> +		return;
> +
> +	attrib->atomic_supported = true;
> +	attrib->atomic_max_len = queue_atomic_write_max_bytes(q) / block_size;
> +	attrib->atomic_granularity = queue_atomic_write_unit_min_bytes(q) /
> +								block_size;
> +	attrib->atomic_max_with_boundary = 0;
> +	attrib->atomic_max_boundary = 0;
> +}
> +EXPORT_SYMBOL_GPL(target_configure_write_atomic_from_bdev);
> +
>   /*
>    * Check if the underlying struct block_device supports discard and if yes
>    * configure the UNMAP parameters.
> diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
> index d394306f8f49..e32de80854b6 100644
> --- a/include/target/target_core_backend.h
> +++ b/include/target/target_core_backend.h
> @@ -123,6 +123,8 @@ bool target_sense_desc_format(struct se_device *dev);
>   sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
>   bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
>   				      struct block_device *bdev);
> +void target_configure_write_atomic_from_bdev(struct se_dev_attrib *attrib,
> +					     struct block_device *bdev);
>   
>   static inline bool target_dev_configured(struct se_device *se_dev)
>   {

