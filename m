Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F563547065;
	Wed,  7 Oct 2026 00:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791332151; cv=fail; b=lLvrV1qLlfUDs2PrzHhtU6t3kLou3nQ6FeJEmr0B7KAGhxgIRNYTLUS7DlACvHHwD+FZR/J6u8uP747M07qRZve6y66PvwtCT+I9Qlx6zZxjG0sprRYZ0wG39Pd0kz8OBETxw0AEEtAM6T8/3oPuJLI38fRwnCmL0RP206qwqVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791332151; c=relaxed/simple;
	bh=xzxzVS7mBPL1SrpZ7vKTAIH0T+yC2dc4liiHJsdJRJ0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kjSu13gJgf1MI5Uo7YISA3udWO/xiqR9HypXy7eDeGx5fJvZQM336y1JwAiRSHeOKdfR+b0oL2lRjHm5JEULqlPFrB8OzLMfVRcY/8maTlmL+97ZWGPrI53MNaWC2hMtDnD1B1VFpxGADBqWCTQJVqMEuA6rvFD535lfmgisWeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mokpWPe2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kT/8py2L; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mokpWPe2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kT/8py2L"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696LaHrt823704;
	Wed, 7 Oct 2026 00:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yOgkKlAhE6X+U8THinXVl0+0VCUZMVoxvRLdgIk6gF0=; b=
	mokpWPe2+9wOjDJ0sLFELrIiOKhVmzd7gv1ahtBRJIFfHhV6/Ckvav3Zfm06xkL3
	ifHeA9o8fnY9exGz3Ll2Qk8QDYWQ2an9662MQlPdUYoFcY5hXuQvY1uNn3cjbwxE
	18RvFMCSce1JxhIDU0ETQPAcdc+wVRYcV0zGJ4eOPVXgJGizT2z2FjxcMiO481v/
	Avbpgw7Dwtl/UumojFJU7e9+CShnQDJ/nn9RjeD64lUr3b9si8gAJXU8KytjkI1z
	ygsPEFfDkGQ7Bl9Z7Id3nHn5REA1+j4CpEz4kJ7fH1QIUu06hvKNqBqJUx9zteFm
	7roHW3336t1X0Pwbv4CRYg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2r4bcw9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Oct 2026 00:15:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69706lO7019612;
	Wed, 7 Oct 2026 00:15:44 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013041.outbound.protection.outlook.com [40.93.201.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d4w96m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 07 Oct 2026 00:15:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rjON7saoJllV5N2sOFGnBds9jOqL8Ni8HkXXv337Js2fyw6IEvbZroIp+Br7DFYBr/Dd3yAkHWWOD99GPLDhKdshzvIpiXdjMdTvR74T7Lft+RKaoRB4dV5m4aBZRCVuW/zl0O1hqYJCOhJHK6EMX9IOQfje7kMJGNQNEYSrBaHXa0vxIvEiE1SO//gMvFYVWLZ/NllpMMIeI5iClEkHu2TGMBcdu6Gld10DHUxY2lDsex4JmQUNnOGuJgfQ7y6hNrcsTnbB157DLgCFUJrYK///H1VQ+GzLDvK3mWFkmgBlZZx2mWfndXrMuxrcNMtl290VN3zudl19dzrl93qYWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOgkKlAhE6X+U8THinXVl0+0VCUZMVoxvRLdgIk6gF0=;
 b=jxwtAlhm0z69i6oTg9fdKfIfcXowmwWSVWG+EFxW0BfrVJEyHq5bTQEfwWM5+z8PcorgFGcV3kY8vCOyZ9KKzkvPIiwgHEMPzImJCsaGewSQNTlb4bl1KPRTScOBd+cdcUuQOPslVd61fFXY9s9BWdohVGrWQC+7Q37M39lI8A6yiedbOHyWXqem/jwdB3pRhTiT+vy1tJUj1/YFhXVBkF3jSSS5nKJjGjLjTro4FeikOc7MMSJld497pi6pCOw2SQ0gNeFPbimfeyBhNOw9Pwwc2EyIlCTp9x30vdWWOeMWEtMmThN6olV46DC/kd5dU+lF3vCSu5pgLPwhRtKnyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOgkKlAhE6X+U8THinXVl0+0VCUZMVoxvRLdgIk6gF0=;
 b=kT/8py2LGHP05YDNMlwVdfP5h559+pXTBad3YyxtWM3ZWemAY1M+UnZpn95vkzujqeCHjsfSVG8YCm5CimaTTHIMPHG3Cdn8JHeEyu1leIUAhe8Wp976i12Lg2JtgULsJ2ZM8OeOmjsDAOsjkLgB9KUCydYl3E2LIjatBWUX+eE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by SN4PR10MB5560.namprd10.prod.outlook.com
 (2603:10b6:806:203::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 00:15:39 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120%8]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 00:15:39 +0000
Message-ID: <06ac2254-99e3-47d7-bc92-79ea7b581238@oracle.com>
Date: Tue, 6 Oct 2026 19:15:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: libiscsi: validate the task named by a
 management response
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, lduncan@suse.com,
        cleech@redhat.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
 <20260804040546.2264137-4-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260804040546.2264137-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS1PR07CA0007.namprd07.prod.outlook.com
 (2603:10b6:8:456::8) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|SN4PR10MB5560:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fd2035b-60c4-4a41-9309-08df24081dd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|18002099003|22082099003|10067099003|4143699003|260925021911599003|260925022911599003|260925021311599003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	5EBfATmYeyonoMfQlACAUU+IzWtYD83j+8gk+3O5ytb6je1XqCPc8+dk/e5tWllqjvU4L81skBW7gnJBA0HISBcrpNNXUN5KsfFe6r8WAZs+saJF3eUikzuqh1O7UKpuN2hYjxuhA4nuPDz52s2xnqHQAa5WwORygTBLH3wGVDC0lmC4XUYFxnFoluCPBt5QJtbTBmgbP/r/N2AIL4+jys4XXuphJqJw+OB1DjABA7YySCJMWX4kKGnsMEWYjKd0ms8yKYD0A6ZoqTl6Z9icHaCv+lmuxC4ZN0N1pT4e0l1vgCh88CGm++VVu8NdLlVv2jA6QuSvEC2+HcMjd8aXRJsgsiNeKga7tr9gcM1hrDRdjF/nEk27IK4gOy/GgoDGE2DIsYFxRgrtU7dmw5u8BjegXPpPZVlgM/r6F03eTDyneDwwiNX/8VMCYXTwFAxTiaEU9spb+Y6YwnYHiH3EpirXVn5XJRgzHhx5lIoVDI3tJzuPvCtRh3B7kuaMdVC4mA4WYqXFRhoIvxugfpJt7BvGS3Xv4cHrBt453PdXtQEgUw4c+Y3IKIDZMMOHSmrFZTloeJRd3/ZEvUTnN1HCdp7jHBiyYjhK00lAslI4lW0Pqs7yKqx6LGTY1w5waNjVGdLp6NKh3jmuB+pctm8Efw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(10067099003)(4143699003)(260925021911599003)(260925022911599003)(260925021311599003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVJWaGpFTXk5U1Zpb2ZLQWxaL2RhUWkrVUVvQnVYWGdnOERiTlJQdEpSY3RH?=
 =?utf-8?B?WkkwMjMybWE1OW9ia2FjSGZSdkJOQXZNWVc0K2lSWTNNS0lqR3NmYitkUnhI?=
 =?utf-8?B?ODBYNlBJZkNoTWoyWG9relg0TFBoTmtWa0RTYnFQdFpSbEROM0MvSWtBZkZT?=
 =?utf-8?B?cmlZUzJ3MDRlQXhjMzBZcWlCSWtId01KalpsRldIRkl5eHNRRlB5YUo1dXZi?=
 =?utf-8?B?d2FSL0ltbmF6aUZhelZ4R0lKQzlTc0ZETXBMdVAycG1Nam8vdWlhRC81VGs0?=
 =?utf-8?B?Q3B6K25oTGt0dXQyVkxoQnVaNmdna3hkV2ZoV3FHME1RZE1BTHYvRHpIeU1C?=
 =?utf-8?B?UUZwREVaU3Rnd0NRejF0VWdQVlp4T0MrZkNxYXViY2NCWUlkYzdOb2hvU1Jv?=
 =?utf-8?B?VkFPSXdzVFJNOVBrMlhIaXlYZ1IrZ0E5Sm5lY1ZSUysrcXpUL1BhUkE0c01q?=
 =?utf-8?B?VU9DMzJIMFhOMUs5MnNyUTgxRVJkTU9QQ1lrN3pEODc0V0hKVmdsanRMcUdJ?=
 =?utf-8?B?V01Vb01DRzh5VnVyRzhhMGg3REltWnlTN1NXR3A3ekZvTWd6OHZtbFVNempz?=
 =?utf-8?B?OTdMNTBRYnpPMlV5K3JZS0ZUSno0alF3SCsrNHgxZWQ1RlJLVDcybWpHcW1Z?=
 =?utf-8?B?eC95N2loR0h2N05hUGNMaFBESmZGYmRsdzJQMG4xWS91K0dqSW5JKzlQb0Va?=
 =?utf-8?B?eTgzWU1vMG4ybjFuWEVCeTNaVUhqTi9GdjZUdUUrWVgxcGlhUlg0ekVxb2Ny?=
 =?utf-8?B?SHM3ajB5dUx5MEVZbkxSTVV3Y2FKT1FoRGlwUVk4K2V6cVdPSzVnQ2FiNk5h?=
 =?utf-8?B?SXJ0dHVOdVQ5R3o5R2hOWEFFdjNXYkkyY3MrclJMTkxLWWs2NWEwdTcrRzY4?=
 =?utf-8?B?SUdlNjZLYVIyVDZoVE1oY1dueVpjTzFHUlVrdmgrNnlzbHk1TjhCT2tXeXRu?=
 =?utf-8?B?b205Ymw0THVrdWZURW1SMHBRT2NRa1NkR0lmekRKYVY5WFB6V0IraXVQMDhQ?=
 =?utf-8?B?amc3ck5NQ0hSMWxrbVpoWm9ScjR3Ync2SWU0ZnFweUhMUWhnQ3BEbkEzKzZL?=
 =?utf-8?B?VUV4VXNNYVF6ZjVGSUxmaXJpZmhsYjc3bXBUYmJLRWZncUtGVXVyUVBya3F1?=
 =?utf-8?B?UG1wcHZlbmE0NDhNZkM0MXR4K0hmQ3ZzRnlSRE5DdExsK2hYb0x6eE1ybkRS?=
 =?utf-8?B?TVdCZHdQN2pNOVhGU3N5Z3NEaW55WHhiWUVLTkpuZjVVOU1HWksvaUczeVB5?=
 =?utf-8?B?dmQreGZoVG82dkc2ZndWcUNrdytIWUxMVjlNL1JsdGhyNlF0Mm9DRk1OWXZw?=
 =?utf-8?B?VE05YjNzbzk0YVh6ck9OMlZMNEdqdXhsSXhPbHhZK3dwd2lXVGNMUE1pN2Rn?=
 =?utf-8?B?SXZjOTlQNCtaTW92Y0hXeU5DdUpLSXlRdWZNZ2FtSGU1WVN2S2szUUVPUDJM?=
 =?utf-8?B?VXBrZys0WlZqNE93Smg0dVprdENOU3ZtOUxLVEtzdXB5cWFVSUNucmN5R2xZ?=
 =?utf-8?B?bmJSeFBIU1YwbmxFU2JLTk8wQzlyU05rNkJmaWs5UXlXSDBqV2V1VXNmcCtm?=
 =?utf-8?B?N0VyeHpmbm5qMUpLaXpuZjlZQndyS3Nxelc4M0dYeThIVlZtRlFmb0VVRi9a?=
 =?utf-8?B?MU5janVZTHhYWUJ0cnFGekU1MFEvbTF6eEw0WXhkTllkbm5WczQwL1U1c0Ft?=
 =?utf-8?B?ODlyUitOMS9ianRNMDkzQk9obDBZemtyWmRxMXpKMWQvQWxPbVgrZDM1ZGJy?=
 =?utf-8?B?eUhxeVVadGQxanJCb20yYUk3WDR3Q2lMUUVPbTBhS2VoQlRMc2JjclZNemV4?=
 =?utf-8?B?VnN6Wlk4QmZHckhEdFBvUTZ4UDR4WW83SWRic3VJOHFXWkRXNWJBcW5rR09O?=
 =?utf-8?B?eE9FZnRLeE1Hb2RpYnZ2T1lrcm81d0hlbjdZcUpkU0dqRDB1WnhHb0QvWVp3?=
 =?utf-8?B?ai96TUZDcUowMDI2cFpyQ3BlRnNOVGJxTWFTN2xmdWJTTXJraXhQR0lTejRL?=
 =?utf-8?B?NnE5enR4TzFlNmp6YVlrRnBHOUx1K0pSYTIxSzdhQnF0TGVlWVBTSXVGODhM?=
 =?utf-8?B?ZFF5dzBIUElac3hHMkhHeklqckxPd1pTTGtLVExTU1pqT1d3MkVlZ2lEL3dh?=
 =?utf-8?B?YWc0YWVVWnpuQ0RRd1lRK3BNS2ltdW4zTFQ4cnFWTjg2akE0T0VJMGhXNldU?=
 =?utf-8?B?NGFyNktONG5tL2RQWkFOTVNYaVFsYm82MVRGRDlPNjMvdVZjTUk1RDFydkZM?=
 =?utf-8?B?cUE5SUlpQkZTK0QxVUNoUVdWdzcrN3dOL05saVAwV0NuaHphemNLakpPS2tm?=
 =?utf-8?B?aDhGOFB3SjYyNndkZ3B1bHJIMUVCb3lKdXVRdW9PYVRlajdoUlZjUHdqQzVi?=
 =?utf-8?Q?LEZQbD/0uto96t7I=3D?=
X-Exchange-RoutingPolicyChecked:
	VCcaD5AcTirvctagmDB9v6GbE0mWt6pDS8uQbIb26F5j+JuortBxZpX+TlG7p7Z6R/OBXOoSf2mWg7WVKYPD++gjxf+bL6QIEwg0tNm76AnOBxEfhOe2vlH7hnnDHQuHJNHoqmXX3A+u9VufsBu8/9BHwCU+KgO9ljMcMnJkpao3eLviParuJ4GPwDVKsx9UnfA9scwa2Phc2500ZsHZTh/tconPJjlDBghJAP1bJ8cX3O2sBNIXDVznT1gvWjuqVpT9qfVrqVl4n0H+W1fpAfSPjpy3rSn5JOiCKIAp7hVh7o+KrVWkgOh70FStAS5AhGgM/AaSiA+IzYd0SWEw+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ajcrjAQuJT4KAS4qPkEY7utrR/1V0iWZ8v3qLCk3AZ6tROoVkiUfUPbnlMvnh6yz+6SBs2Du5okr2riK2G728f21XdnQwY5lrNxFaPs1TnWbSH5eUDpo7qAr330vZvedrLi+fMcV4ZYQ9SW4uBPAG6bJS0s2GXSxmxkjHYpidOXBgvvzoV4KznTuSoNY4MNPlzcMKzaCnjUgTS/W6dJ4Jn30uuDdRh8dic5wqSfW40RVZcQ5+W3wmbs7NtMxo4k7uge5pLE8NRPo2dUSBhYYO3qoz+Ah4Aa4t6Ds1EgfLl5IgAwXdxsn1Syf8M+2/55T4u9DzO8Lva+3OPDHSk7Bqo1hWGa0ib5bBB0AIO4wVpVIg0THJFoBWVnItIUVvfQdkeOcjfMFOgt8naMZ2Ndb84XpK7mh8L1d4yhIlWYSekA3KIDKwGOoaDpDEkBFPcWSq0VwjzPYLYRtu3OdNcLXvsR/m5rznsY36l3CFtT+Z6Xp135eM2wijzCUdQeu+7zXFJ3aSNJGeKU//BL2JXI4jQT3faZ4W10s2bfw6egqDkGyLTNpjlR6tlUB5F3O7yHGuHDvohgD7xqFgrfWGy2XfI/DkJwC/9DTZ0Ny3THHWIA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd2035b-60c4-4a41-9309-08df24081dd0
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 00:15:38.9963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lx3cCwXwIrX/FmRIqlshhLsWPGpDsVol9D/JmpZSt1FS8iREo+qZ+PUUeBrHy8v+QwDeQGlC+m3n/AeupXa8aBIch+XR75F8Dxw1FWw4LYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5560
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 mlxlogscore=898 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610070000
X-Proofpoint-GUID: r9T98WkSK2pKesx2MNlNrMv56sliPCil
X-Proofpoint-ORIG-GUID: r9T98WkSK2pKesx2MNlNrMv56sliPCil
X-Authority-Analysis: v=2.4 cv=BIQmP1QG c=1 sm=1 tr=0 ts=6ac58f30 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=GHTgmjVe-9SRDJZ2VMcA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX7aIgQe03bBld
 H+9zFXGUR9E5MJsWEM6YcY3Tf3Sr9u22Nnh0wuGtGcTgdkG+v4XRy4/qo1+u+m7F9BWPa1tNBeR
 V+nRAOovtnJ/LnIwdsORnt3a9CL2l6TJDJ1FTldOYukIRb9xmBTo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX20tUuG/6BIVz
 Ed9c8/lKjcV/JAwbDQLkXX+bR8AB/jIqqmWq00+gZb591lBA8Ns1uu1xwE0QFwnutdG4Qe3annq
 61RrAUS1S7JYb/l3vmlTE4i4q8fBhYa92Uwr73GbfQ2A9xYqxHyRn0jUq9OYRk4OqVg2+VxORMr
 /c6z1DmFF/cSVM/7HU9TOblmzpeRpuB6dZQxPDXRySAcUZrXTAcKgFtGAqCf3ErwTviQgWlAHSc
 XduSF34sB8pqpT/SsvF/P90nQegYKR435wzFkve+ViTfyxaXYTSmvj3T2wPlpDEKwo+e4VS6nTm
 EtyA9kOb2fNCDrB6Fk+GxOLy+Xx4fb+6AGLh3CchzGr2eNNWzM5XfX51NbajeTyp9Lhb8D0w79Y
 iX7AkmTdZvDERWbbyedUr/JePi+r5HhY/Y5mwLca/47A7SR7c3bMXVsCbwrVA84OGpXYZ84QueA
 stTqXVgykTQygu6RGqh5tGfk+RClpnrmBtmYPj4Y=

On 8/3/26 11:05 PM, Yehyeong Lee wrote:
> __iscsi_complete_pdu() fetches the task for five response types from one
> place and checks only that the index resolved:
> 
>       case ISCSI_OP_LOGOUT_RSP:
>       case ISCSI_OP_LOGIN_RSP:
>       case ISCSI_OP_TEXT_RSP:
>       case ISCSI_OP_SCSI_TMFUNC_RSP:
>       case ISCSI_OP_NOOP_IN:
>               task = iscsi_itt_to_task(conn, hdr->itt);
>               if (!task)
>                       return ISCSI_ERR_BAD_ITT;
> 
> iscsi_itt_to_task() bounds the index against cmds_max and looks at
> nothing else, so a target can name any slot in the pool, including one
> that has never been used. task->conn is then NULL, and both
> iscsi_nop_out_rsp() and iscsi_complete_task() dereference it. One
> unsolicited NOP-In is enough; a Text Response carrying the same ITT
> crashes in iscsi_complete_task() instead.
> 
> Require the task to be in flight and not a SCSI command, the way
> iscsi_itt_to_ctask() does for the command opcodes.
> 
> [    6.298634] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
> [    6.298642] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
> [    6.298652] CPU: 1 UID: 0 PID: 111 Comm: iscsistart Not tainted 7.2.0-rc5-ISCSI1-gf5098b6bae76 #1 PREEMPT(lazy)
> [    6.298654] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    6.298656] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x46/0x160
> [    6.298691] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 f5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 00 00 00 48 8b 45 60 48 39 c3 74 50 48 b8 00
> [    6.298698] RSP: 0018:ffff88806c907be8 EFLAGS: 00010206
> [    6.298701] RAX: dffffc0000000000 RBX: ffff888006116800 RCX: 0000000000000020
> [    6.298702] RDX: 000000000000000c RSI: ffff88800525d578 RDI: 0000000000000060
> [    6.298703] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [    6.298706] R10: 0000000000000020 R11: 0000000000000000 R12: 0000000000000000
> [    6.298706] R13: 000000000000002e R14: ffff8880056eb440 R15: ffff888006116800
> [    6.298707] FS:  00007fc02d1c2740(0000) GS:ffff8880b29bc000(0000) knlGS:0000000000000000
> [    6.298710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    6.298711] CR2: 000055fe3b56ddf8 CR3: 00000000053b9004 CR4: 0000000000770ef0
> [    6.298712] PKRU: 55555554
> [    6.298713] Call Trace:
> [    6.298714]  <IRQ>
> [    6.298714]  __iscsi_complete_pdu+0x13a8/0x22a0
> [    6.298758]  iscsi_complete_pdu+0x54/0xa0
> [    6.298759]  iscsi_tcp_hdr_recv_done+0x870/0x2c80
> [    6.298778]  iscsi_tcp_recv_skb+0x31e/0xec0
> [    6.298800]  iscsi_sw_tcp_recv+0x12f/0x390
> [    6.298804]  __tcp_read_sock+0x1ab/0x810
> [    6.298812]  iscsi_sw_tcp_data_ready+0x18b/0x510
> [    6.298814]  tcp_rcv_established+0x1f56/0x3a00
> [    6.298842]  tcp_v4_do_rcv+0x449/0x960
> [    6.298847]  tcp_v4_rcv+0x2245/0x3bc0
> 
> Fixes: 7996a778ff8c ("[SCSI] iscsi: add libiscsi")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Mike Christie <michael.christie@oracle.com>

