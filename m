Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5220181CE2;
	Wed, 29 May 2024 18:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009104; cv=fail; b=RP6NAuN2d3FYQCAp1yDqjcwzY5hc24pCbkxTwAlYNgoRF4uWPEYMxKAoAfrEbzT+8yrIvxRBoqqPPbYhYtOJZT4EAmib+pDt9DAy3OMQRFuglb+rYeu0mSPMyLm2strUzKXSRivQmH9WvbO+9rH1fCJtDkHhddhOXxmu330a9oA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009104; c=relaxed/simple;
	bh=umhNVEIZORu3OT5FEroAbAVt4iG28At0rUPI2+8UPpc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ekDm3h4f3qvtVa7mP6F7uynRpqQvKYu9d/6E3oCXuFQb4hEL8JH8wxUCcGUfmeUKp0hIjK15LtRUgXmsanz57oXdp3BJPeGDDHCopGiMb4agMUgrHW84c0wXXrLMLQN+5ewV80bgDFtvy32nDBlwmG+aTdLQZm6izlJ2X/52wtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44TGYVQB010956;
	Wed, 29 May 2024 18:58:18 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DkDGYDadYVzYm+olOFUQTZ/LzQxhr9TME/yyYf8+SPfc=3D;_b?=
 =?UTF-8?Q?=3DBa6paf8I+cT/AmYyRtGGxLlrz6dDRFD9iaSFGFxG8nWZdXutBUo79rFFiqnZ?=
 =?UTF-8?Q?R5V+7k+Y_obsdP1qGtPGk4bo8p0tFJu/1LcnFzEbaynR3JyO/45DlHRALKYOdnQ?=
 =?UTF-8?Q?WEFFPUOcUz1hjy_9KupKoxG6v/stLHW3QKwguVzrPBpH2s5S0MjO1IGeasHqb8M?=
 =?UTF-8?Q?w2Y2313huyW7XYzI8VPU_GhQ2OIUNIGEhciyOyoW8uSY0n0LUuKLIf3n30xOsD2?=
 =?UTF-8?Q?6tH6iYQN7jeWIz+TvoovdpsL5+_gDRPFd9nSHE3Hz8mZXeN/XszrrcxqFWlOJNZ?=
 =?UTF-8?Q?Ey0FM+YOOzFpzpoYapPYpDqvaiN39gkt_Sw=3D=3D_?=
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8hu7fky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 18:58:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44TIn3n9016209;
	Wed, 29 May 2024 18:58:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50rkpaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 18:58:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ay71G+5npC1c5iKiRr2NeGgQNdEXO9J39Xm7d/fx9r2kOF9UAkfdl5PUlViXWab6hoq5daggUvePF8umVbEzKmD3KLGxieJzbBhb7LElmwrfp9U1Yf7gRZUPSxiie3T+XuXBdRECOgDd3XLLB6pkKkji2jgqMbhs7sJ2BggIvzW8I5g947fddcZITaITqxR4njLz3pYXOJQXYlyk8qeVMeVmzoBAd3sxkHTj4TL2z/Qyd61AxUAOoVn3oPak1NhH/AmEKYmzWdw8vKGSKgijc4oe/ThAtvDtNw0+dwyQFTZS4bE424lKByc3ZGy70SeDZtZBYwUKOZ9CExp6MuDvZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDGYDadYVzYm+olOFUQTZ/LzQxhr9TME/yyYf8+SPfc=;
 b=USdrFgqDciENrfvF6siIF6Oh/+3LMNAFFUoak2EfLxpzaQXZvH+6y5jStjo0YNXxT+zHJVEDyhWGuzRNJnb2IFkRtLrWf//ZHHXy1Pw7JBCMYwiB6E84qQpGEqVo5gEke2sdAHOouQuTTlOFtz+d8hUM6veLZ19Th9P/76coXy2LHBS64EUuM2DW36Ejs6fClWgXGxeN8yXzaqvQUse0INTiiom7E1W5wednW22XU7AYmswEpICxXCueK78P3qAhoGljrTyLwxnNe9h7aqCAZCeszkjYeSOPBPKzjT6o3qcjjCFzO03NaF+v3lwJXE45V2//OT3sf0MplEtxYCPfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDGYDadYVzYm+olOFUQTZ/LzQxhr9TME/yyYf8+SPfc=;
 b=U0u8MlXTP/MeKLkq3QxJ9ixh4RuOe4cFkGjtALVl0qAqPY2lKKNMCWTAC26o3VycaCaFkhH5ght98AMC+6QJUDTw24qI8tFVx1ZvSrXXePaDEyjfGWHtpKIWJSJ3PpUsridaXI297C/ahCf7JuH+nF2OjCSftaoAStvckKdEBhY=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CY8PR10MB7242.namprd10.prod.outlook.com (2603:10b6:930:79::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 18:58:15 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%4]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 18:58:15 +0000
Message-ID: <06380175-c258-4112-8cc4-4420b2860e7f@oracle.com>
Date: Wed, 29 May 2024 11:58:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: remove unused struct 'scsi_dif_tuple'
To: linux@treblig.org, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240528215640.91771-1-linux@treblig.org>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240528215640.91771-1-linux@treblig.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0103.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::18) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|CY8PR10MB7242:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b5373cf-a5ff-4258-06b9-08dc80114b93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?YzYzRWZzRWtUbkY3MW1uM1E4MjZQc1RtTVlrYm84RDA2REE5enNML2JTdThR?=
 =?utf-8?B?d00wWUJSZGJhc1NUSC9SSnV4cElhN0RwS3VSeERQWUVFVDhoV1pjTW9hYUFE?=
 =?utf-8?B?ZFkvVjFxZm9sbGliUVBmamlJYUh6TlFTaURnR3lLZTZ3R2dJM0VhcDVTclo5?=
 =?utf-8?B?YzZzK00zdVBMR1hHbzFCY0dsL1Q1Uis0R01wcmo5RTY1WkczTTQ5ZW5lODZ0?=
 =?utf-8?B?azk2aWIwM2JuRHo1eEhwU0EvRU42NHc0ZnNRdWN6ZTlseTNUNlhLQUJtODlQ?=
 =?utf-8?B?K0NGdXlBR3dVaWZPc201ZURlcEVKYktWNzMydFpucGxONlRlWTZVVVF3NEh5?=
 =?utf-8?B?aEdMejVxUE4xaDlweFh1amxzWW8wWDVsMDhOZmVGRElqT2ltSDR1bHNHbDgv?=
 =?utf-8?B?QldTVklIWVBrN0hUemtCWnN2eklhMnFMcXdFMFVaZW5RRDBPSWwzcjhEdTlR?=
 =?utf-8?B?RzlpNGdOZTZLY1dvS0xWSDlYN1FZRGNYZHREVzRzcm1yQ0hpOGRDNGQzZEU5?=
 =?utf-8?B?SVF0S1FDeUFNZm5nNi8yQjRFYUxOVDBLcGl2ajJzVnlPMjZ4empDRll3ZGw4?=
 =?utf-8?B?Yi9qMyt4MnpUVlRNUVFLWGpvT1VEeFR5RWFCc2g5MEc1Z0hMZzlZZVl5T2F2?=
 =?utf-8?B?T0ZOTUtmUzM3S2FrS2loU1drdWFTR3BQOHArMWRJSWY3NFN1S29HVzFOU1Jt?=
 =?utf-8?B?V1RCOUNuTXFsWjlVNDhzSDRxemNtYmtpZUZjSDdVZEsxTE44bEFmSXFpeUY1?=
 =?utf-8?B?eTVEeDdCK1FMT1ZzbWlmMGpSY0pBUm5xU0NrVjRTNjZKZngzWlpaL1ZIQmNp?=
 =?utf-8?B?T3pjS0RQdDJhc0pjRXFSTCtQSHY4cnVHcGpCNGdkMGFwOTV5djh3U2E2N1RK?=
 =?utf-8?B?NUxrQW9YdWtObE1Scll4RGkxN1c4dXhqWHNMZUVxWDFjQTBHbnhscWZXbXdO?=
 =?utf-8?B?Wit0SUxTSHhJN0locXB0VEpqNTU1SG5YVlp6cmREVEU2WThDNlZsd1ZaVW01?=
 =?utf-8?B?QklSbmRuVHJSdlhDc0ljRW1abVF1U3laYldLV3Z0TE1xWWt6ZE1VQi9mR2VV?=
 =?utf-8?B?cXJ4NVRseW1tWHZsak9TWi9tYlhVaEJ4SGkzc0JVdHhoenBNM1YvV3U3QmZY?=
 =?utf-8?B?WTR2QkUrVzRQcm83eDlPM28yNUY1V1oyZ2tZajJYTjEySWlVa0xIWi9scUMv?=
 =?utf-8?B?V0VJZ3d6L1VyOHc5QkdoUURxZHBQUEdubTN3c0ZtT29JTDRwVWRPRXNJU0po?=
 =?utf-8?B?UzF2bXBQWW1tcjhJWUJ1ZUQ0dG5NMTN0b05pZlI0TW93N3Rkc0pWTm8xdnlk?=
 =?utf-8?B?S0ZLQkFLVmFiQjJublQ0akRwYy9tVVJaQkc1SE9TTVo3M3doanRTYkt0NmlU?=
 =?utf-8?B?cXdwb3FLS1ZmYU9CK3J1L3ZjK2JXQndRbEJtTnIwcFhuakxnVmgzekRHZlRZ?=
 =?utf-8?B?TklhNU0wY0E2S1NqVHN5c091OWRhOERSZVdoTHdMQktDMDcwKzdSblJiQkpZ?=
 =?utf-8?B?Q2dWa20rUEtXOFhPZnE1ZnhENUpuMzlPSnd3eHhva0czNUtOWVNlL2o3WmRB?=
 =?utf-8?B?Y3JRODE0cnR0d2djaERBcGFtc3NHdnErWUUwRmRyL3JCajFMcjYxUThFblVR?=
 =?utf-8?B?QkRVVHc4ajViREd6dFlYWUxqUlJHdmJ6QzVOdWx1cENmYWtWWUpCY1FYVHFq?=
 =?utf-8?B?Wll4dlh2SGJEUGVqRjYwMzFQUU5VRWdwV2tGTi9qSXQwOWhNVzhIMnlnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dk9GNC9DR0xFYkFMWENDZXgzR0xDcUUvaHhEMXJ1aG5yeHNrZjR0Ui9QdFow?=
 =?utf-8?B?V2pRanRMTko3WlRJUHRQMFppK2NVYTVURm9VYUt3VCtqUFowYzVNckpIMXV4?=
 =?utf-8?B?MHpiSWFYb3dqVnBLZFoyOVFKQmpBbjhid0thV2tuS28wVjB2dWFsOURGaE44?=
 =?utf-8?B?R21HTk5wQjA0LzczbThpUjhQdnA0ZEFEUmx4ZGp0L2F1NGp4SlNHMHh4bUFh?=
 =?utf-8?B?azFzeTlGZHNESzltT0ZmKzRVK0VJclp3RjlzNlRWYVVsWXVKcFhzL3FlL0Jh?=
 =?utf-8?B?RjIyWVY0NnpCb2Y3dHpBMDNOWnBXU0dPeXRjRzl0TEo4cVd3WS9hYXl3SDFT?=
 =?utf-8?B?d0o3MlNaNmdEUSt2YURMMXhlOXJwaE05NTkrc3d6WmtQSzBIRkt4cGFKT3lH?=
 =?utf-8?B?QUhRdmVIOHY1bE5WeklCVlNKemxXNmQzeGlVb3N0blBMWStWMFZmcWJtTTRI?=
 =?utf-8?B?bHJhdTVJV2VpekUvaHF2aW9CcEs4VWY1bkJ2NEhQcEwwTVRUVWxjN3RsZHlT?=
 =?utf-8?B?VGdzZWIyRnlBZEtURFUxMEdZQmpkR2kzNXIxQ2tWNGhDMFBzdlo0cjVWbmF0?=
 =?utf-8?B?Q2I1Tll0RmMxUmx2NWxSVmNYNVBUeUdxSUJDby9jamZVNWptRm4yaGNPS2Ur?=
 =?utf-8?B?dWRZbEYxTFgyOFdtUW9HWFE2RTRQWnBYUUVXVStPODNrRitWTys2R0lBcm5Q?=
 =?utf-8?B?dUZsZkdvMkoreldzdjZ3dlFpU05kNzZGR29rLzBWVGNJSDFKdGlOOFhZaFRW?=
 =?utf-8?B?ZXJMWURycmtyZzV4UkVuNlZod3pnbHBsbnpqbFRsTktRWHpCVjcrWEg3eXEw?=
 =?utf-8?B?Wlg3WEs0YXFNZFd2a0QzWUFpSTM0Z2Y4b2tCM09zRGVRdVNOVjQ0eUw0SzF2?=
 =?utf-8?B?N2pEZys2Y09PK2VaLzBsc0JnazNQaXN1SGhBdWZCcmwvTERoNTJNQTFsdUht?=
 =?utf-8?B?c3F5azhsb1I0MW5OVS9iajQ4ZDg4R2NpNWJnUkVDMkVqSVBGRy9PNEpJMkVl?=
 =?utf-8?B?dEFMeVBXaVB3RW05YldkWEdRY2Z5ZldRVXdXS29oVi9Lem1EYnBwL3M2aklN?=
 =?utf-8?B?Mmc3Mjd4VDR6Mm1pUDVwSFIrcmRsSzhROGx3ZDJPeEF2ZnFKeEoxcnBzTlF0?=
 =?utf-8?B?ZjNDTjZvdmN0Rkg2ZjJDcGkweEVLN0EwRW96MjJWNFpWRll5cGFzaStldW03?=
 =?utf-8?B?ZUtsS1dvNTBCTmdwMDBFcWIzVUphSkhDRmxvSU9WR2dEQ251ZVZwK0Y5YUF1?=
 =?utf-8?B?c1BvVjNaL2RZY3hmYlZvNWVDekFSdGU1UlZwNGNTN1Z1WVZFL3RpZkdiSVdJ?=
 =?utf-8?B?V05DZjhxVlUrL0VTMkc1TjI1SXRBSGUybmJTWGc2T3ZnamdmdFkza3NXdjBQ?=
 =?utf-8?B?ZndCSFVFbFluSHpOaG5XM3BrSFhTVGE5bWptenRnSy9TSGtIRkxsTzJzcGxl?=
 =?utf-8?B?SXd1ZGFYa0M4K01LajZ4dU1TNSs5Qi9kbWJCZjVoMkNPSlVYcWFkQmU1NitO?=
 =?utf-8?B?VFhqVktZTmlYdXZ6NHpwYXl0Y0ljYjR3VG1tVnZqdlJZNFkvcGVOOHVXMFEr?=
 =?utf-8?B?QU9YRVZDSVBrZVBySmtNTExBVklXQ1N2UnZuZWRlb1NtZGdnOTZweGhBWFd2?=
 =?utf-8?B?TVdNUHVVQXJRODJMVWRmR0kwNDlYbGdpMXhPOHhaaEtyTTBWaTFmZUk2bG1X?=
 =?utf-8?B?UGd6bTZwMnlrelAyMGpUeDM3Q0IrK1VzWk9mL0dlTzhyR2lKYmh1Wk4yZ1pN?=
 =?utf-8?B?Y0dvd3h3Umx1TGtBUFMvYTRUZ1BqYzRvTFZ6emNUZG03K255K0FTSkthSmd4?=
 =?utf-8?B?dHM3SStsNEhGRWZmM01UWjgwQWI3OU5ENG8zZ0IweW5YMXNMZ0FZVFhrRFpj?=
 =?utf-8?B?N0FnNEQwM25MR0FUNDhGSCtobUEvL2h3aDVFckhTMC9TbjYyZjR5RmI4M0JF?=
 =?utf-8?B?azhXQXVSVkJkWndSSGlkeUlFRUpsZEdnOU9oaldSNjJZWGpYdjEzS3d0aFlV?=
 =?utf-8?B?WERoaFlmMEJ4UTNrWmlyRTZ5Q29xei9RWGdqSDlPSXpXTXdoSVFOR1ZqT21o?=
 =?utf-8?B?UDFmdTR2VElOaWU1WlZhUG5pK1ZXSVNWMzZRSy8rWVFFRHJ3eFgzSjcyekRu?=
 =?utf-8?B?SnlZYVhtaXNYZWRVVkRGQTVwcjBORlVUM3VzL3ozN2Fvd0tVWXVhenQxc0Za?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	j+MH2azhUoEFj1eKL/7H4kot64FC+Gw6h43sXOZACQfKBzro+fEVjTt/jwWTgVM6LUyGw1LOBIr8JVYXdpD6wu3Lpp38HmfDuAqiGsSlFNYC7epbXG9KC8Lzszq5VkEENDu1tXAt+dktqGCtrNKdL7KblI93CcWcSFxdNBX4FwW7SuFkZ5VGE5xkJb1uuY/1gd1t/FjGw7JaQjBIQM9gxnnU3Xo5ygq5814e5+B2NVzKi2xSJep74UXjcc8IlMwK+fzPLN02NO3Mwy+SSSQDZrgLlo4WjoM+yY9NqKl/a0LMIY1v1tGZuFdE3rUCRgmNI3oPu0JhZiePP3ZxKk5k00udZVtgd1lAh9saNpiv4MramK4xXlBVx+TjwM6Jzc6wmqfTiliRCtoemtYCDOBVNLhQofoPqrfnIrHQP2Iq1t7JxJyUTBu++BfHd8p0+Hj1/UKqdj0MMqGrO/casgNIQheF0GtRtkzh16Rlr2y+tsI9cZ8Ly0ewtXZ+1LbU0KaNlzWu+WzCvkZc8oyvQqktnQaYvjBCyXN5FgcHOHQPNvZ0DmOg0VhJTGcxpTl9k40r3N/Ytd0rRVUhwfZP8MufbxUuPMAbwcVZZxxJFyKElJE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5373cf-a5ff-4258-06b9-08dc80114b93
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 18:58:15.2691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTKlvRjYfNipuK33jp35uknh6stgok5ahdnEX1KzeCLHEK+o/f0C5c2YfLkQYJ714oQ0SNR7+WvP1FHZjVgyjexSmd0QjJK1btqC4XG8OVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7242
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-29_15,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405290131
X-Proofpoint-ORIG-GUID: Qk6EbECUYQ__YOUYSm64WPaujvRw8VFn
X-Proofpoint-GUID: Qk6EbECUYQ__YOUYSm64WPaujvRw8VFn



On 5/28/24 14:56, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'scsi_dif_tuple' is unused since
> commit 8cb2049c7448 ("[SCSI] qla2xxx: T10 DIF - Handle uninitalized
> sectors.").
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index d48007e18288..fe98c76e9be3 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3014,12 +3014,6 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
>   	}
>   }
>   
> -struct scsi_dif_tuple {
> -	__be16 guard;       /* Checksum */
> -	__be16 app_tag;         /* APPL identifier */
> -	__be32 ref_tag;         /* Target LBA or indirect LBA */
> -};
> -
>   /*
>    * Checks the guard or meta-data for the type of error
>    * detected by the HBA. In case of errors, we set the

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
