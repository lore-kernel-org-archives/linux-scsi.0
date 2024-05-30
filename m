Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201A21CD20
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 07:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717053889; cv=fail; b=APfz4XU12etA0ikwGpQidG7+NbvQ844xvbdDrtYYf7xBpyuOkFqKJYi0gc5NLwnL7Sml+1oEOVF09XpRfoNGElxZYJ42WC9XZutJNLrrMeK5AXB0cSy5wV1diAW7oL/D6gFnujDCaqJxKpvJQAYJsVJ/Splt3fC4/oP6NaPxrrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717053889; c=relaxed/simple;
	bh=wJ/B1ch1acobAr/jPLWA566OH029nhzkJOzqiRScpXY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G2fbzWDn1EU5VL1dQsBiTES0Y7kdA4x7aqZ46TVf8uMGVar1F7b9lzgetKxOSzBPcWfPNNUzmu/ce9Yi5sP6ZYqPIv5ntyFRUID2NWplSNc+XlOS8V0Lb9K6Lk3EKmfpsHepvuCC/5jhj/aUnIExWn3AHJBvTIp+5l8NJIWeC8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44U5mfAR007287;
	Thu, 30 May 2024 07:24:36 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3D43NkeiKnh402o0Zad7smPrvoVUC/PCBzwEW2/3uwUts=3D;_b?=
 =?UTF-8?Q?=3DaK8iQM9P9XTvLPEUvS2U7yMj+wEJVQR0Hq+U3sQSMSSefELApOFdBz8j2ODB?=
 =?UTF-8?Q?xEJym9JP_t+TnwPyzYt7T2tpivLLKnpUMR8lsbe4i2h0YdgJk5U0ntm1dwS6i+w?=
 =?UTF-8?Q?kpO3qoS4++sScz_xBqLoIVjLsePkyLM/OWTbcQ3aOYW8ihJaqenQulealmwNYgj?=
 =?UTF-8?Q?sSsUOwV3BlDwrb1ugCqU_4cXADA3uHiQpQr86RgS6vkCSJD9uf2v0vi59df4Dk6?=
 =?UTF-8?Q?rGVpVUoHA41q6E0GwVCBt5pjwS_tZVLxyoikAZEMlKBrn0x7wL7l7QbRPasmENt?=
 =?UTF-8?Q?cAQWtQhdQIdAyWx7bBmxiVDdf3YQL6Ui_Hg=3D=3D_?=
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8hg8b53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 May 2024 07:24:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44U6npQn024147;
	Thu, 30 May 2024 07:24:34 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc52dgn8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 May 2024 07:24:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpPulgLjKIJjL9kf3Y3FYKaURUpFLOdiz9VzOXBiseuJhK1FTBt/5nQwdNlab2ds3zpCPjBmtmM91/uusQVfpaBU8KMHunFKEwaK6uKX4O+e5jzHd0xgg2wVUw+r8nd1tVyvrrWb3NKddiZgAFjBesetIZOD610m9E2qMHJ3KP1nkr7OlF9QtWcLhSHSZCwLyfeTw5JXx3A08dKqvO7U8b2dWcmrxLXplMMpUhOwVtxpECfxFb5m3iPrlOub4U3Urm3U48Io2yxURIfEhynOxJAg3zeGbz940zxwI/PZgP/sghs5a3VtoP6uUGtW0QYrR9ZZqNNL1wprUn55cY2dTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43NkeiKnh402o0Zad7smPrvoVUC/PCBzwEW2/3uwUts=;
 b=Qg5ItWg1EC0/TU3OSjn/K3djUPjsZ299aOtByYItaDVK2/GMTbbhtiKbTmRYmYexQgf6RK/9Q5DHbsAWFBP5RUfmfyLP6MVG/hm2k09OTbv0CKq9OFdcgS0Eyf7s9U6URne0A/EhiDi2TPX8hNk3Q7AFC+H90DUZ3zO4dwZ93BXOX6yv985GmdJNEa9JM84/eWFqSeJzN7xTeVs1t8xoTVE/VQOeFa18U+kZ+LRHWixX5olb1b1NtXaeFx6sf6u4HunWVs36JEF+zP+rbkErS+o+9IV3fmenm2cse2tQeJbb0u0wrSGid7Vv3kpH02/Kkvh5iUGrTqXsuqWTWbg/Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43NkeiKnh402o0Zad7smPrvoVUC/PCBzwEW2/3uwUts=;
 b=RYo4diRY7mTkyq1rgKeatoYLmREh66g5Rz8Jw3eTAoFUVIT+531qcxCtr+8D04QZqrG8CfjSKfWxxUHJy2ANIhdCxwUmB19gtEnkRBpZl77URPctvWdb15FuGNT90yx5hmw6eupPxJDo7OhmxnkxmE3OOGkote4vAl2Fr/RUQik=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7141.namprd10.prod.outlook.com (2603:10b6:208:3fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 07:24:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Thu, 30 May 2024
 07:24:19 +0000
Message-ID: <02e43478-7012-4cad-a865-d01f080bac1d@oracle.com>
Date: Thu, 30 May 2024 08:24:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Fix a format specifier
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240529205226.3146936-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240529205226.3146936-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: bc992fc9-891b-4468-9aca-08dc8079850e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?SnJ4Uk1tQ1JLUzlNSGVhN0lueWV5a2tIb0gzcVgraGl2c25xM0I2cHVUOHUy?=
 =?utf-8?B?Yno5b3BLUlF0RisrUUdPT0RoRXJwMFBHL3YxUXgyaUFXL3lqTVFGL25pZERW?=
 =?utf-8?B?U1lhT2MxZlhLRCs0ZWN2L0Y0dXZwSGlPR0x1WWRTRW9KUlhSOW1GRmFsM2Qv?=
 =?utf-8?B?aWE2ZnRTSlRyeEV3RVpoUnZYUDdMdE5zdWdQV2VoSEw5dy9jTExFTjRjZEJF?=
 =?utf-8?B?TnU5Z1lpY2kycFlRYXY0Q1crYnJNb285L1ZBd0VuelEwNDJIZm1PZUtnbGhk?=
 =?utf-8?B?SG9menJmVUQ0cmNjNTdzWnExV2R4bGJVTmFVd0VXbkxPeC92OURMTFlzV2Zx?=
 =?utf-8?B?YWMzakZqQzhVWDlrazBwQitPaUhxdk9QeEQyc3VMbDY5WHhlY0RoWGEwZ1Ra?=
 =?utf-8?B?WHBFcFBQR0VGTy9SdmV1RkZsbTJxTmZVUzUvWXZCWGpNODRhRzl6TWcrRVNl?=
 =?utf-8?B?SCtGSThXWGVUMmM2REtKYUZwckp2VXAvaDh3WUhFYWdJY1ZJd3lVd1llc2NI?=
 =?utf-8?B?bFNPUkFsN0N0OGdHV2h6azcrUHZxZUcrZVE3Z3hmU1d0RXNiTkFuVHkyRmhX?=
 =?utf-8?B?YkxyTkdlTTRyTGxNUGdBckFKUS83ZG51NG1zMFdvV1Ftc2Zxb1F6cWd6RFBZ?=
 =?utf-8?B?YUVhUE9DOWtzQVRHbnRmYVhWTWw2VHJ0aml6WVZTNENxNW84YWlNcy9SMDAv?=
 =?utf-8?B?a3QzNEt2OUFzZ25RZ0pXeHVTYjZESlJPdFJHV3ZZV25aYTRXWWtnbFRSQWxy?=
 =?utf-8?B?dis2TGxCL3RrQ01sVERJUmlBc204aVErS2sxWXZtR0pnaXJXWGdJZTRlb3BH?=
 =?utf-8?B?dEw4RDNBL21YckVFOFZERHZWcWFlQzJpdms3eld6Q0NlbGJzZnEwL2NFRHh2?=
 =?utf-8?B?eEhvd0hRUXBsQ3E2Q0w1c1NvOEJBc0ZaSEV0Sks0UFQ2VG05M1BqQm10V1Q4?=
 =?utf-8?B?WmYwN2RISnJHcWpaYnFHMkZXcEFmMXhRWStvVWlKb1FCSXlYVDJkWFBvNkxy?=
 =?utf-8?B?ZlB5TzF3b0F5ekY4OC8xWjVIdDBsNFN4L1hHbnROSHl2cEZHMURncmNxUlE0?=
 =?utf-8?B?OUk3NVNhdnNtQzljQzlhYXIxREY4QXc5V2l3aFI1Qld1TVM0SlAyMlBVTmQw?=
 =?utf-8?B?ckhUbC8yazl3QnBFczVYUG9ZenU3Y1I2UDQrc3N1aitOd0paRU5rYnNCMFBM?=
 =?utf-8?B?MVNrNHh2LzVYNE15NFh4amRTU3dWeWYzNTdCYlppV0kyOFVwTFZ1UE1lazl2?=
 =?utf-8?B?b2c3bkc5TW5rYnZ2UUpaOXhjZWIveDZVQWFhOE5nekFOYklGNVhyeHRLMmQ5?=
 =?utf-8?B?WHRWMGltZEJUTXU3NTRwQUhtTVJuZ2h0YTIyOVhXSCtUYkFSVzhVY1FFRWRS?=
 =?utf-8?B?RkN2czBsVkN3elJkaGxQVENzT0d6L2lwU0oxbkEyZTFsS3RqVU1NRktxL1V3?=
 =?utf-8?B?T2VsLzM5NzJWTjFZMHVwVisvdiswd2d6M1REZ3hiNUtiNkpyejYwbGVvZEc2?=
 =?utf-8?B?UVBleXNPWHIrMXpKbVlIcGJ1eVJaRkpwR1N0K0ZVWjdXWStJbFgrMXY4cWty?=
 =?utf-8?B?QTZQdE9QQlpnMUtGb2RMWGtoTlZNOU1GQ2VnUFRFQlFldFc4ckx4c3dQWFJG?=
 =?utf-8?Q?nFVAg4eL50oF9yIkW7VYj0AdWc13E79nqfGttmtD20q4=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Qy9Dc3RJWG5SR2Rkbk5tZlo0MGwyN3gxanZHcmE1RjhURlFiN2hCWHpjUWlw?=
 =?utf-8?B?a05vUVREaERUUkxmVFNOQWo2TnNhekQvaExhTW5zU0VqWXUwTmtweC8ydWVY?=
 =?utf-8?B?cDJyQ3RmMFdBVFRjZGlNRTZBcFlMN1dKZTRzK2c4N2hhUDZjYjRhQkxlUHRa?=
 =?utf-8?B?SDNueUpIc3BHNWNkdjI0cDZSWTlpejNFV09idXJBRUsxL1ZPcFQvV2NyVHpC?=
 =?utf-8?B?VkNHUzZBTXFjTUxWUWVZaGFLaGN0cklNcjJWNzV3c3JRQmowMkVBUEVFV2RT?=
 =?utf-8?B?OHZHR05UU2ljNEVJVlZnNUFiYlAvbzhqcWIzbkd3aFNWYitxaGNMYmhVV1Bt?=
 =?utf-8?B?cGhUbEo5R1NZU0h1WTRubEMzWERzSUgvOUI4YzJzN0FLOEU0b3F3dldoZ3Fr?=
 =?utf-8?B?Tm83UFFHUmQ3ekFtRDVaNVk2cXV6S1A4RUJkTElFWFVKRmlvcjZaTnZZRXF2?=
 =?utf-8?B?dnZabmJHRUQ5MUN3Zk5qRFlEa3EzVTRySytjZVhjendEOUExMER4QTVTb2pZ?=
 =?utf-8?B?Nml2bTdGNnlyM0xVVmU0aGh6MnhtRS8wK0VoSVZWdjRBU3hUNytqbkp3Q2tz?=
 =?utf-8?B?N2t2dy9FY2R3ZmRBTHlGWFhkbFIvMEx2VTZneXMrMnpBTXhXb1YyQVdCYTJY?=
 =?utf-8?B?Tmc3U0hLQzdMQ2tVMitXeDJHdTBmQndZZ3F1VTBuak1MYkNrU01YS25oQzRP?=
 =?utf-8?B?TGllSWZEZ0xtVG9KTHVPQWlhcGpYSVNjNFFZTmhud0VGTUxoZ3UwczhvVERU?=
 =?utf-8?B?VHg1dWpjcDRIajd3b091ME84T2FmRzFpT2REMG9UektvSDBPb0NFV0QwYnZC?=
 =?utf-8?B?a2NOMWpySWNkN2VEMW4yVk5tRGNEekd4Y0ZYTGNqdTlmUVZIaTI0cnJsNTJz?=
 =?utf-8?B?Z1Q4ZU1XbUtudlVvRzZQSjhwZ2hPSFVlM2h2QzVRTnVqMk9uMGRaVjI5amZu?=
 =?utf-8?B?S2dTWjE3M09MKytTVW95VFYrclpYY2dhSXhqRU5DWVdRM1d1Mk9IRUp1Z1dj?=
 =?utf-8?B?MDAvL0ptdmNDK3ZDMVJEcjd6MWhCQmpDVEszZ0x1R3JLUkZuKy9QdTNkZGFF?=
 =?utf-8?B?SkhnSnVJQ3IrS0p1YW9zMGlMVnhYODFRYVJpZmVPMENoTUtyZXdUYkczVUl0?=
 =?utf-8?B?MmFKK2s3MVBGK01FR2thZFZjNWhvVHo4T1ZiaVFOYWlsdHlDWUFRdk90aTZm?=
 =?utf-8?B?MkZiS1ZwRlVNbGRxcEdtYXJQUFJtem9iVmtMNEZsdjBwU0p1Tmd3MW9TelVF?=
 =?utf-8?B?WWdBckFOY3ZKbmlFM3I2UHdDZXV3Zkk0WmxpUHhkZXBjWi9iWHp3SzlrUGtX?=
 =?utf-8?B?MGJEUTA0N1FmaTZ0K3hjYVZ2NVAwakxjaWR0b3Yvb1c5MlU2ZDYza1JSdWVM?=
 =?utf-8?B?d2lpRGFLNWZic013ZHU2NUs3T0NCZHBaL0Q1ZDZxRk8yRjlzVUpZRHlRZ3Fz?=
 =?utf-8?B?Tm1hemd6TTNsZWVtbW1VSEo2TDZnQUNtUTArSUNJMjR6bkFaRWtnZVdWaHFp?=
 =?utf-8?B?bFRGM1lTRkVpSDRaODdFcmhZdGlaZnNGTC8zMlpVeHZFZFFJQjhlNStaRDlM?=
 =?utf-8?B?MEJINVUrdmdQek5OQWMraHFLaHpXc0o5UlZJSHFwcmM1YlVnS2tra2laRW9B?=
 =?utf-8?B?ZW14MEJSWXAwa09xTUplc0JCZDFvSDIvdmZva0MvMFF4YXV0QmJNdXNScXZh?=
 =?utf-8?B?RHBwSmg4WTcrekdxQ0ZpcU14MW90Z1hKbnpiSis4QURzS3dHZ3hHRzBpYWNm?=
 =?utf-8?B?dFROdEJOTm44eHFEdVZuQi9WeUdQelVCeGpVUWtTNjFiTVRiZ3JkZVhhc0dF?=
 =?utf-8?B?STlIeFk2NjkwbDJCRnBRZDRZaDJjc01rVFJSQ1VpK0FzRklOdENJdW1BVjNs?=
 =?utf-8?B?U3JESm9oTHVxbXczSWR1bVgyS2ZCRFcrQUZDNzBBWHl2VFo1WEt4OFF4TTJ0?=
 =?utf-8?B?d1ErS1FETFJsbjRpSVFzM2U2L3V2bDZrMEF6enUvVlpaUmZqK1Q4dm9JZXhV?=
 =?utf-8?B?UnVqaFJmU1Vkbm9MbUI1d1lWMjVvcWk1eFFDYUdITGJvRlc3MDhjZ0hCVmdo?=
 =?utf-8?B?WlA3dUk3WlNPSWd4MDNCRVlObEZrbWVYbHFpZUtNcUpBeFlpU056QnBxaGRJ?=
 =?utf-8?Q?cfxRbGxzoNWpUzRHSniS03DJt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	YigKUP6H+4kShBqQS5+tvNgkGcKhkT0axPL42xU7yM0UJYOaqGIj/07lmEeScwpIKte9a9qYedDYNoIRPrHS3n0O+i9NOWZm5UCb9N4C5f3+TngMHMMmE60vAds8wUGMOMYnD5CmHHZlF/8v/JI3rdVg1l8Vd1P+amhs/MTtkiGk7E6cF8LBZ0xm8DfZMCX/aoK9j2JsghGgpcOI2GaOzaJC25MQWktSVA4o4a1zC1oa703aG7V0wqxJt52s6lhPdHRk5x/qmk28f9VcLwYuQL78MZ2FF/7ibs+171xm79mTiudM1VIKIis9PNbRORPMeqVravv8+alitMTam4v9G7tvz1+k4xzzygU6P86JbN5rqvAImpj4W0tDgTpqVNlUUvWyHUGZITmwOpAuakIcLR0Hcksmm5/AUJ9/kTOjHeo/nBDdY8dIodtgT7RKYebxSq/0tHvYlFZ1ImnKjf4QzspcUiQ93wwHf7KHQcRabF7vCNhOyO47n4iw44yYwuksJmvVKA7IfBoinK5hpYpchdP6au326HOgEuiqBfnGkniBB0EDmvENcLKegimYlkJnHwWQl3+F7FUP0iWX70adv1AuLPwAF5KuBMzkaFg2UaE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc992fc9-891b-4468-9aca-08dc8079850e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 07:24:19.3648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UfsjP60PeXPbE/wZeyenevc6B8J4ltICVS1/0qRFLNVl0bQDvYH/anY8qShhUi65cCsz/hUGOLZ2QY9pCcZNAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_05,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405300053
X-Proofpoint-GUID: EVq9VslF4QOZru0TFL9IRSBzSfv8tvGG
X-Proofpoint-ORIG-GUID: EVq9VslF4QOZru0TFL9IRSBzSfv8tvGG

On 29/05/2024 21:52, Bart Van Assche wrote:
> Fix the following compiler warning when building a 32-bit kernel:
> 
> ./include/linux/kern_levels.h:5:25: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘unsigned int’ [-Werror=format=]
> drivers/scsi/mpi3mr/mpi3mr_transport.c:1367:25: note: in expansion of macro ‘ioc_warn’
>   1367 |                         ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",

see 
https://lore.kernel.org/linux-scsi/20240514-mpi3mr-fix-wformat-v1-1-f1ad49217e5e@kernel.org/ 
from two weeks ago.

>        |                         ^~~~~~~~
> 
> Cc: Tomas Henzl <thenzl@redhat.com>
> Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
> Fixes: 3668651def2c ("scsi: mpi3mr: Sanitise num_phys")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> index 329cc6ec3b58..82aa4e418c5a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -1364,7 +1364,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
>   			continue;
>   
>   		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
> -			ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
> +			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
>   			    i, sizeof(mr_sas_port->phy_mask) * 8);
>   			goto out_fail;
>   		}
> 

