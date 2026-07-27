Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486F7169AD2;
	Mon, 27 Jul 2026 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165313; cv=fail; b=j3Djpsa3c3V/Hak+8wZPR6nNIGpxA8c9CgcptU3UVfmoPJ/x1TRTlburaLZb+wzhPtO2kdni4YLTHo8UXQaG8k15MfRBaJeq0AB/ilQA2VfNXVsbnBS5OJ8JQVyAWadz0K48RRvIoxxesfpSL/qQ9V+0NEAAVKERA1NQ8/SlGz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165313; c=relaxed/simple;
	bh=gzWOhMoERVqrAZUJToIRz09QmnZM57Gwq5ThAAHV0Uo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XKI+/Pl0mSVMDPylP5wFzn0tKPmMkb9KjuB6eFJDJn3xR5SS+4Wtqa4K5rEuyMZG0YNK4k5aQFNMYSOXta1UwKCCSbkkG0iJkbrK7n3DGg9+j7Km2jyI5H3ZCk2z6wV38lL09/FUxksPuUfWfv/wf9JgvUqQALo5BrdOpC9cSyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=moD0Oi+g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LyxFrz19; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="moD0Oi+g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LyxFrz19"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66REtwVb3308550;
	Mon, 27 Jul 2026 15:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CHqzA3kjcJeuIEwUYFjkWlV+fZAH/EBb1/hPQVU12OI=; b=
	moD0Oi+g+auEFog3eJE4zlGo18S2gzixF5KMe8Lo1udQptlnQSozEQmhrsg3+BD8
	VkOfM5gbPK3wgmPPNhs2kb7a2dk5OnJ9A1sZeD+WSW5IkhT6dhOtSl1RclSGL+Mk
	KVpQg/2MBfVXYqBqsKSb+gg2VM7uPU/sMDBHFw4ak6sWY6SqvojR2e1IeWFR/pNS
	KogsvMUVXv4CfHqVdm4LW1NuMcwWSm1L0/mIKcycM0Zr8pKB8vOL+r4R/slIDEhW
	KY6Ia4pKmp2t6K4XMvJJB01BRfVdm1GEekvlgbLcf1CekB5S5FoHj+rhI/bgsVnW
	GAzXuZeajFA1wo76lUUdMw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyya1rv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:15:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFAZSu037454;
	Mon, 27 Jul 2026 15:15:10 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8gga91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:15:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jHrFezrQYWrwouOL1uMs/EeA7c9p531JajuQhvhIKUZV8TVAZIvNvrqInkGxrRA68yGjQkCJjypw0SWxuNSQM5NCKrrMCxA0aTAGIZ0i5DpuEUIWYELa2+0nLs7Bh+KE/CvWDDRvMxc9uJTtSE/iLDaJYFnTqaVVLkYsNUX3NqX3gsNMKHVuC8xCLi4I5gj7nDLSdxWaIV+MpFEJirng2gPM7PU03rfRolkfn6ck03zZauISn30UkwQKhmhACaZVzpUdGUDYKceU3hhQzRD9sTy6J1E1MUr3XVtEj96kMI5sai42XHOaRRPLf1YWeYgDbkOB8dWTQtHeJNO35c8xdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHqzA3kjcJeuIEwUYFjkWlV+fZAH/EBb1/hPQVU12OI=;
 b=A8acU3A5KIwDoQFk+KxivXcRj7PQto4pvF1kcv2Y37D3yFZXkqTaPB+uZyyw+FkNsfCL2x9sBEqQcKbTvblQVvZgLs0IaLFtspOYaG9PjxXlnip14gj9pxNI3aIYj3YQ0HsQPVmTLaxyf3YhYCrOQyMpznVT2uLpHZQxGklGPfMnYus823dVwqnQFroGOjhnGSi7hVsuL5hTI38iyzM5E2C8UEQ57eGFDxi95mjklgzJeUOOqQZQkA7cbheWoIU5dXhKhB6pI+f5vyfKQNBx/XbjLb/wrlzuMtsiCLBRU/rklFg4stQBaIgsfC0j8fwxVOeOKBk9C3dDWgtMDncgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHqzA3kjcJeuIEwUYFjkWlV+fZAH/EBb1/hPQVU12OI=;
 b=LyxFrz19n2y0x8FJ3EW1rHF5xCbugFTKAypqi5p3OjDKvaiBclEL4bJEsmWaPf2CcdZzkyG56WM+GZv1UdaEV/eo1FnsSGoH4gfE0KXUpP5Lw+Mc4tRKWcc5JEd2Cfngxmn15v2L1cImg6DrPFP1KixvIJxyusFHjlznDWjssUo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH8PR10MB997929.namprd10.prod.outlook.com (2603:10b6:510:3d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 15:15:08 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:15:07 +0000
Message-ID: <14c0f748-2602-42fd-a777-2fee003f8a87@oracle.com>
Date: Mon, 27 Jul 2026 16:15:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/27] libmultipath: Add basic gendisk support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-3-john.g.garry@oracle.com>
 <20260727150403.42C261F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150403.42C261F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0090.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH8PR10MB997929:EE_
X-MS-Office365-Filtering-Correlation-Id: bfa74f69-32be-4178-884e-08deebf1d7b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|56012099006|5023799004|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JrWhYWJBLHKC9eanWowWPTIAjCtco/BjHAQym0YTFviUjIYq392iRVcD6lBOVUSPwNKN77WtYQwqFiLS9vxyP6MOo5o3vn46m53ps2INqcthiBAfLaLWVwopA7DaAHt8Ugy5keN4VcroZOwzm1+dgKcIsy0tfwaaMuXr5hLt/jySMN4Xct/cj6w514COugI8jn1FthCtUI8FA4gBQZA29pBhSnlAfEAB39puUQYrXA/im4OcetDreazwtVC92DCV1hVj5fmmXldhYS3+WFwRDkWDOUdU8LvhGwmgxONEgwxK9Le/1TZH9y0Hpboxasjs/I4NbCuo1miNbrUP7KZU1Q2i4DU3Za4ZKPOy05K7fMazHg7krYLT7EPWMKx4G4a9KEbRgfMF3WXuZgrHA7YYoazJP+XHHn3JmdQMRQoGYy2LUtrl1KHG4asf5c76A7IGBXpGKaFFyoRCULIUeTcfQteHGHfTmPlUEkUKUrLrFAVF5G6WNK3gLMiveMHzwbOLZbA9cosUgpCYB/5sB0xsJbJlSU0wbnELe7ZMQynnS/UUZADXlIzDj6vqRiyedKVBsucN4+BUV4OA1XOYK+fCgnEHPa0jtiMuUjMjbtKoXfLTTi2yrc6ltzBgmiQMKwzLselKhYiO2Cd//F/uFHMNAr6s0Ssr+g7URMzkgZPziXs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(56012099006)(5023799004)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2M0NUlXL0c2dUZ2VmMvVkVnL2E1cjNpQnBEcVhxbDhpbUVySyt6bWppTitz?=
 =?utf-8?B?RWY0VldHM05jWDdpbU1nMFBVMnBkTTZVcFNLaStkSnlBbElidXB6S2pxeU8y?=
 =?utf-8?B?SjdSTjMvclVOYU1pMUxJNENmRnFwdks5ME1hckU0bzVSNm1NRzB6VnNkRkNo?=
 =?utf-8?B?L3k2TExsZThSR0RWemxPMDVwKzREcHJMcnRCU29zZWJsLzZaN2JpVnhlWXFF?=
 =?utf-8?B?akJzT3BvbU1FeGtReW9kcU9WWFJnQmxIQlFpUGFaYWZDR0gybFZObU5XR0Q0?=
 =?utf-8?B?YWQ0VEZZVHdaMWZzZzJIQ0gvTTZlNnZZWENCeWJ1WnkrTTJ1NStQblpvOWU2?=
 =?utf-8?B?OGJGUVFDejNxRi9FVWN5azQxOExQV2dGVTVxbVlSWFREejd3TCtSRmNqbytY?=
 =?utf-8?B?Y09DRDhwdUkyUG9uSkh5S25tQm5hWEViSjZqM1BjT1hoeENxa0JaN1dqQTNm?=
 =?utf-8?B?djF4SHFwZ0FaT1ZOZC9JOXF6QWVUY1FEL3BiYkNUNmF1Z1dla1VldFRPQXJL?=
 =?utf-8?B?bUtuVVRJVHFMWXpYV0EwdDJLdHl6S2IxeWgyS1Vod1UzSG1IU3NzNk8zd0FB?=
 =?utf-8?B?VFpvamk2bEF2ZFVrMkdWd3lMUTk3R0xQUEFud1FTNTdpMEFhS3pFajZlY2I0?=
 =?utf-8?B?T3pMTmhYTExwM25NazQreWVsMmVqbW54L2dRWmdpRmNHbVNTdSs2c2hqRXpo?=
 =?utf-8?B?ZGY4TXdyZkZ6dWQrUTA4QWEybFNSUXhFZnlNSW1IUmJLREpkb21reU5qSWda?=
 =?utf-8?B?dmNTMmxUcU41VWo4amtzSEN4SlBndWRML1R0MXBKaVArak5pd2lYeko1RmhG?=
 =?utf-8?B?QVhzaU5RQXpDN0k5cHJaQ25lYjFQNGxYWjNBQWd2Y0l4dmUvemk2QWRGQ0lR?=
 =?utf-8?B?czJob3BwWEhqUk5xWlJtWDNMck9MYWVqMHR1RVF1SG5wNlpDRDY3ZDg2WlNK?=
 =?utf-8?B?UGdGRjg4ZGttZ3JkSEFTeVE2MVB5SUlxTlJCeDM1KzV3SkZqTkcwWmNuNmhO?=
 =?utf-8?B?c0YvTnp0bzZBVSt1VUhreGFiYVBGWkpndzBRT25wdllkYTRmWnBQNERvVFRk?=
 =?utf-8?B?bWxQKzhYWU5iUHo3Q1dnVlQ2enNMa3N6UmlyRXZJMXljQUlYT1J2TFAzck0w?=
 =?utf-8?B?TDFZa3NVaHoyYmRnWWFJZ1hZNWlBWUgxbkV2MWt5UjZpSEszeVNJNUdnMEpG?=
 =?utf-8?B?MXAvb3lOOTJZbjRMQU5IYno3VTYwVVFBRDQwb0IzU0JwY3lCczlrMm5WU0do?=
 =?utf-8?B?Sk13RHVKY3pWTnZnK2xkQVhUTEk1amJ0WXZHeldtSEZsak92ejZTSnhDOTFC?=
 =?utf-8?B?TkhIWStSOTlHR0VIbDRjeFN2UVZlN1pnZTQzM2gyWUpmZENRTXpUdFRQSXVw?=
 =?utf-8?B?d1hld0J5bTl2MGlWdjBJV3IwT0owY0xBMngrMzlMZlB0ank5N3AvWUM1eHpQ?=
 =?utf-8?B?d2o1Mi9nUDJtKzFYTWJKQzA4SjFpYWpKUDEvcHBOdkpIdkZOSzZLTGJ5VXk5?=
 =?utf-8?B?UVB3TmlZTUgwbzl5NHhrbGR4eHBCWk5uWkZoWmtVSmRYbW9HeG8rdWRvMHhS?=
 =?utf-8?B?c21xenBSelpmay9nSkYwVzhaZ1d0THVwRkpHaHRqTEN6SFAxWjgyZVErWGpU?=
 =?utf-8?B?YTRoSXV0bVBQU0M2bXNWMHovL0FQMlRadHlsT3ZSRzlOWmVQRkJRZ3RrQysw?=
 =?utf-8?B?MTdaOEpTL1JjMEdDNUlFZVhIUUJmWk85L29UU0U4NFlUVEN3VEkwMi9FZUpj?=
 =?utf-8?B?bjI4VjFhSEt3dW5vNU5TRUV1OEh6R1RJN2pIL0NQZmltbElUaWRvV2FJc2NM?=
 =?utf-8?B?WXgvSy92b1U5THRkaHJBM2lob21jemhVa0RGUlVlb0JvdUtCNUswSkJIVjRV?=
 =?utf-8?B?aFNjUEV4cmVEUHo4RWxqTlpXSHJKd1czSTdTNEltVEtxUUtHNDNQVENDMVN4?=
 =?utf-8?B?MS84Zm81eW5IS0M2dnlFZDVubXVtMlZNdjIySVdwZmYzZlNwaGV1bWt4R2Vh?=
 =?utf-8?B?N1h0cW84aXRVZG9IVVpPUElqVTk2bFNQSXVxL29yQkRVMFJyWW02RjVaMFJn?=
 =?utf-8?B?WS8yK0dUZ3JtWWlVd2p2cUJTOHJKdk13UTZMaTNmRFlRK0VaeTJTWHh3cE1o?=
 =?utf-8?B?V3BwdDFETitwZHYwRitFbmkzeTJoNE5FODhHbmYzcWVYTnE5VmpxUHV0aE9C?=
 =?utf-8?B?VHkyYXpHWU1ROWgxa082WkgxbDE0c0hlQUIrTEpBYXBnMnJCUjcyaGpRR3E2?=
 =?utf-8?B?cTR1Z2o5OUpPT3BkZkhwN3p3REpNWDFoR05jMExkQ0RPNmVNR1VBeXNhaSsv?=
 =?utf-8?B?OHU5cTF5U1VEampSQmNqYTdVUTVtdmlDMFpWY2c2M1crUmtVSnhYYW9XU1VP?=
 =?utf-8?Q?i+gCp4IKdjEjcGj4=3D?=
X-Exchange-RoutingPolicyChecked:
	BUQTbpvlh3uI4O168hB8XfY7z+7SjF/g37T2PNHsGp4XnNeBrtGdPtEHDusaKQl8w7A/lkXNAZvfW13o2MdXRWoMLlDiWM/VBJ/xs7BQ3gbpt7M4t1OZY7J1t0YnpqZoPo0RlXrvP1BX5yaU7GilTGiP3Ou0FykoS3SeU2PfCPCVQu9Nhd+CM/kfH1Sy3drRcmXlqFLL0n5zxBWOah+9Q4B/eikFzzdsQNnO2k0us44MxhDY2t+VEiDwOmP47pofHQkENPIwQUTQGZdTGwnr3xLNVdqiOxwQW15DgVOtxYsqk3CejxyfyYO0MtY3sYTlWVm2Kum7yBgKj995L7YrMQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gpwLE5d3SegvUWuPWCHdTHdYVRhTu3EvhKNbCl5wx46uvyTO7XPMpv3ShxXPO5O5W7jqt2b4dTPZT2Nj9pW5ehxwMlCU/xlHe7dfN5JSt0tPO+qT9EHnrcUiZa/hhjaihuzCAN4qrfMeP+w5qT6v6TBXyOMXii31WUcxIIK8yroU1IJY89fBdiz0NmvKSRXoR4kslG0O6lI8n2+2T49vFkEyVSqAvwqRE4U+5ai7HeH7jNGAfq2YoBi/iIe7WUt4yi6+Xc27cvb/Bts6WkCmTgDxzrP2UYf7Ck/u/0HQQC0B9DS7Em052O5RZTPB83Y7uJ5851cZqG5momoDWXCP8k9gVguX5gaC9Ys05QVkdOEQQU2fKyy20tCqRzhit/hRmz2ob54bLR2ayjs2YTAfmwvGOYnQkimNpT6HlWeGVeIpbpSrPYhQyGDLjmd5FJ2PkuCT5pDHvNFqe/8nPXcJVaYXEP4XewHGpae4GC0JQ0hw+200vt81mECUICQwAiqGes00Nh8gPWSw7nhyMzywgdhs/um9Tl/wF+zCvjD32/0f1xrU3x4NhZgW3vnouT4bTt39dF2Fp1qGyOSho4pDTXFI8cB7zWFEJ66YjunV6R4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa74f69-32be-4178-884e-08deebf1d7b7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:15:07.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5999quqE8/f7OYGStax0PU5kXU+6mwjDR2CAWNZR8xVty3O7NaFW+mkap8OTaGOFdied9BKGJ2RZonOwD7nqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB997929
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270143
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0MyBTYWx0ZWRfX4BbuxNCKbiD+
 j9G57S8yxJu7Mt4UU01ursflNdEtmscTa7Dy/2WwPbddg1CoKiDVYOoxpR/PX0PKZcKDa1XUpRR
 a4UbMwWXIpaCd0swEG8GjxN/ICdLLsNXWLDkLlzQ7CfjYAZyxxNG
X-Proofpoint-GUID: HfBCSl4-CuaOduQFR4oyCpWZLU7IGyS2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0MyBTYWx0ZWRfX1y3tLlskE1jt
 v33X0sxi57dx/SWGB62+YmiXSNzO61wm3eOdbXRbSBIEZfgZYK6XzaA1eQn/Ch72faIixW7Lov8
 uJK+gzPkSUQ0/yY9Ug28KC/5y8axx+DIlNXiQKsDwfVuvR8XLmQRDcNF0qeST/4w1Gf3SJ5HO+q
 DKk/YPE3p0a+BF4SWFAaLiQp2VTfSEtgXzXkyHpObQDYb+31K15jNpOZ5C/m8U6xmp0DjPV8A64
 zxGxMF0hBt13yFA1CrBSeITvVJGMEbZayFXYKo/OVWYi7WhaUP0TUL42ZsGjseaKkgtsPgo1Bj4
 yvxy2tR1y7oR6xSqAhlaG6XzKSDPLRdhAr3bGAX0Eiq3WZqxYZ5uLZF2e9Xhr6bvMbJ66bapdSc
 TnwwZWLzWbvE6Qb9HdmBp3lP2YoHBQn+Xx8E1Iwk+ULPUIkOllW2Q/9hjH17xTN50RaJa7ScSvu
 WRH6xaImRDx4W4esAy9uRf7WVwS0C2dQLp/sWcuw=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a6775ff b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=oT94WhvjT_U_dyaJ_moA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-ORIG-GUID: HfBCSl4-CuaOduQFR4oyCpWZLU7IGyS2

On 27/07/2026 16:04, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] mpath_alloc_head_disk() leaves mpath_head->disk as an ERR_PTR on failure, leading to a kernel panic during cleanup in mpath_put_disk().
> - [High] The allocated multipath disk unconditionally uses mpath_ops, which lacks a .submit_bio implementation, causing device_add_disk to fail and rendering the device incapable of processing I/O.
> --
> 
> --- Patch [2]: [PATCH v5 02/27] libmultipath: Add basic gendisk support ---
> commit 15c7ca249b473955f186aec1f0490e8ccef64672
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add basic gendisk support
>      
> Add support to allocate and free a multipath gendisk.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 9cc398d266adf..d2e334259f3c1 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -35,6 +35,104 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_head_uninit);
>>   
>> +static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
>> +{
>> +	struct mpath_head *mpath_head = disk->private_data;
>> +
>> +	return mpath_get_head(mpath_head);
>> +}
>> +
>> +static void mpath_bdev_release(struct gendisk *disk)
>> +{
>> +	struct mpath_head *mpath_head = disk->private_data;
>> +
>> +	mpath_put_head(mpath_head);
>> +}
>> +
>> +const struct block_device_operations mpath_ops = {
>> +	.owner          = THIS_MODULE,
>> +	.open		= mpath_bdev_open,
>> +	.release	= mpath_bdev_release,
>> +};
> 
> [Severity: High]
> Does this block device operations struct need a .submit_bio callback?
> 
> Since device_add_disk() in the block layer strictly enforces that bio-based
> disks provide a .submit_bio callback, won't device_add_disk() unconditionally
> return -EINVAL when mpath_device_set_live() is called?
> 
> Also, the helper is_mpath_disk() strictly requires disk->fops == &mpath_ops,
> which prevents drivers from dynamically overriding the operations struct to
> provide their own .submit_bio implementation.
> 
>> +EXPORT_SYMBOL_GPL(mpath_ops);
> 
> [ ... ]
> 
>> +void mpath_put_disk(struct mpath_head *mpath_head)
>> +{
>> +	if (!mpath_head->disk)
>> +		return;
>> +
>> +	/* make sure all pending bios are cleaned up */
>> +	flush_work(&mpath_head->partition_scan_work);
>> +	put_disk(mpath_head->disk);
>> +	mpath_head->disk = NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_put_disk);
>> +
>> +int mpath_alloc_head_disk(struct mpath_head *mpath_head,
>> +			struct queue_limits *lim, int numa_node)
>> +{
>> +	if (!mpath_head->disk_groups || !mpath_head->parent ||
>> +	    mpath_head->disk)
>> +		return -EINVAL;
>> +
>> +	mpath_head->disk = blk_alloc_disk(lim, numa_node);
>> +	if (IS_ERR(mpath_head->disk))
>> +		return PTR_ERR(mpath_head->disk);
> 
> [Severity: High]
> If blk_alloc_disk() fails and returns an ERR_PTR, it is assigned to
> mpath_head->disk. Does this cause a crash during cleanup?

That's not an issue, but I can clear it

> 
> If the caller handles this failure by tearing down the object via
> mpath_put_disk():
> 
> void mpath_put_disk(struct mpath_head *mpath_head)
> {
> 	if (!mpath_head->disk)
> 		return;
> 	...
> 	put_disk(mpath_head->disk);
> }
> 
> The (!mpath_head->disk) check will evaluate to false for an ERR_PTR,
> allowing the error pointer to be passed to put_disk(), which will dereference
> it. Should mpath_head->disk be cleared to NULL before returning the error?
> 
>> +
>> +	mpath_head->disk->private_data = mpath_head;
>> +	mpath_head->disk->fops = &mpath_ops;
>> +
>> +	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
>> +
>> +	return 0;
>> +}
> 

