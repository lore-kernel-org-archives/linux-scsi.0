Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065E82A1BA;
	Fri, 12 Sep 2025 14:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757687923; cv=fail; b=p9+/R98lTNPYsnrJVKTTYfGybD8nDGuyFUQ/jG3RoxIwnDicxo/DdxmTHVv+GxhVzL65lx7cTdOhy5KaKjQvIHQPfASWN2kXhv0ri1yIDL7ojMq4NK/E6PKhfInMSk4u0C0VLshlMmxw82AUlYpPYaNPr2K6OW+aPy52QfoKxEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757687923; c=relaxed/simple;
	bh=S310fyihuoVO53VcixphkECIiX+g2SkeCIWl+LvFU7Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lPKmCBec8rY20KIpe+N62XhWKARtmyMwG7DD7BvGGQKhHQ5Z2a9FTDEsMLxlfRGJqn1GomRI7jzvnUlfwq5NRtnYBd/UtS6mETIhf0jtFgF+pjgjflineDWPKSpHEGxSetFGasS4mnPxruJM8Ps674Qmx8YOmrKJHpX95sapM1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CzXUhR47; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FXjL34Hr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CzXUhR47";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FXjL34Hr"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1trne021130;
	Fri, 12 Sep 2025 14:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sdlyATiygiKjE8zI41+IagxCbM1bN5miz+Z7FymNek0=; b=
	CzXUhR47PzyVaY+0+Z1MGM+qfLYGhgecBnXO2a5etQ5E7lXkhFjaSNgXbhvywMgG
	H0MG8ItKqDIHP3Cvdd2QhG+BW1kC+XLX57juPuECG+a7Q/9j5kCEsXekFNQx1bjd
	oScoxlI7lU7u0IRvixeipw4sTiX8IjhybhglCXk4qoKZzbi+PIqyelP8ztlrf1Ec
	+AuG5YEblzrTVvoWmGjJEMmNOiwzjKcMclmJ50QTjUNW9le8razOLmn3c5XOqoU1
	dZgD9vGOSbXqPxE0kjX6/jHF+bZjgiyTIR67NFaD6p30YbEg/VRjtcTvW+jjLLMD
	jDGHl4hVISVF8yDbYxoprw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jh0dc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 14:38:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58CDUDRx002883;
	Fri, 12 Sep 2025 14:38:28 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010016.outbound.protection.outlook.com [52.101.201.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdmg72f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 14:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cGDQrinEZeBjy8gmbIKoHkKa302unBgEWbMy1HtSKVFL7P2F2sSgD8WkNp8IHsgXnYqmsuhYXtKGpt6xu32L/W7H++S/rGgTRj31xnGXWGTCQf8zNuRGsK0P73HYP6+HtR8pBUS4lOJfbvjVS8yy03PEETfxvYYfhMuMV5q/PWaRmuHhn7uuZ5OMYVfeX6Lt/Z6ETBAMycebiiyy8XwaAzYnGU1Gr1reTk1cGqdzrMBUEsil9ZI7nJUn43OdY2vbv5AKXo3ZiM2zqQ1ctIYs8me2tN3U6tz7EPxuKWNlU6qpJj31L3lT8YEivMDRq/KvB0IH7/sr1DI3iqvBjgJ2Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdlyATiygiKjE8zI41+IagxCbM1bN5miz+Z7FymNek0=;
 b=QrJQn+OrW8ogTBaxgqJK6XHf+rUI0Ho+FTP6L6cGG/LHlBVfsY5e959jaHw1qsEEVDKqFQj9JXt4PB0U/5qllPmLNWNHHvuIxxQbEWrQ3TAAicfRPW5+8frXaIQUZT6ZK8Rk4T/so+EbhnKLuSBeQuEzWbhWEiqsdufJipUrbRmbrc7U4zaesf10itHqF6+QB57h3gsLoUXNbKBH/baH16grnO+1j5huZA7YKAo+mAWqH082zsnn8SH+Uax0HT217BtB56yZ/beajLRmPBWweG6hqAqnyd8YsfoKkF0XOnTBrK+K3JzpftCr45O51ixYDwdDlzKyYI12h1CHZ3RDgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdlyATiygiKjE8zI41+IagxCbM1bN5miz+Z7FymNek0=;
 b=FXjL34Hr9rNmxZNQfOq/eKiLKmO4WAE8KIuqwr/FIG2hgWFqpQYN0At+iqWgQQBBASL3NNe64cDve+vk+7lZQ09Ol3J9IwUt7sxuWn9VkIjflWeNyKcDQvq+gfA0RO5Coj8UqHTkbf2SsEz3c19uBf6ED74sJjosl4rfjcIlgzg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 14:38:00 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 14:38:00 +0000
Message-ID: <e10e9387-c8ad-4bb5-80fb-42bbafdb9243@oracle.com>
Date: Fri, 12 Sep 2025 15:37:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: core: Improve IOPS in case of host-wide tags
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250910213254.1215318-1-bvanassche@acm.org>
 <20250910213254.1215318-4-bvanassche@acm.org>
 <a28d07ef-34a9-41ed-bd4b-ddcbf3de13f4@oracle.com>
 <0c056e23-59c7-4125-8cd6-1e22ceaadea4@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <0c056e23-59c7-4125-8cd6-1e22ceaadea4@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0130.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BY5PR10MB4340:EE_
X-MS-Office365-Filtering-Correlation-Id: 48aff3d2-c978-4a5e-e15c-08ddf209f925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmthRE9mNHZpRmg2VUVwNFpaU0tYOUJxdEVwNFJ5ZU5IM2lvTUkrRVlFbm82?=
 =?utf-8?B?dUF1OENkb2U2NVpQVjk1TXdVVlhhS1ZIQXBzUlhpbjJpTUpURm1SajBSNVNt?=
 =?utf-8?B?eWdCM1UyUm55YmlOb0I5cUlwZkRvMDAwL2JxOWI3WCtIMlpuMHFacVE2S0lX?=
 =?utf-8?B?OTlqMW1RRXc1YksxTTAxWERZWFFoZFlnZFVHUTZnOXNlSEc4Mm5qUm9FenFV?=
 =?utf-8?B?VFk1bDFsZ2l3bFpubk51NGJ1VGRzVkpnSGpWM0xWMmNkMXlmWGxOVmVoOWZz?=
 =?utf-8?B?QnlvLzJJaXdiaUEzZ09oNTFyTm9weWJoRWJUSlFsMWhuNEo2MElxOEFKbGJN?=
 =?utf-8?B?ajdlUWdGeERrTDF4Q01vMmRNV0RnUnBLYnBBUXpNK25YbzB3a0JXYkpSeUZo?=
 =?utf-8?B?cGV1L1NuanZkT0pjTWdTT3ZrangzS0JZbCtEUUhTbzBNdk85Vk8vbnF1OG80?=
 =?utf-8?B?VER0ZzFzdDQrdXduajdLR2ZFYk0relE3S1E3TnR1cHRGZWc5R1lRM3RuLzhy?=
 =?utf-8?B?UDRYbW16czJza0FwbEIrNEdWaUQwWlJuNDZlejNWREdXbzZLUFUxaUlsa2ZE?=
 =?utf-8?B?SnpHaUJ0Q2NLaWJnWkZhaDFnaDFlbmFSODh3UzR5eFlPc1g0RCtBU1hiK094?=
 =?utf-8?B?b003MnNReUduYVoxS3JhWDJBNlpCZXNQZ0ZXWXJCRGFvc3pta3pDeHo0SUZL?=
 =?utf-8?B?TWpBcDVEdDFJTldUY3NHeHdtZTgwZllWSzk0VVpNaldGdENtZG9yNFlQVmlL?=
 =?utf-8?B?a0YvWjdQWmtwQ2E5UjJyTGJGS0VTaUt1Sk1SQjQwVnh3TkdRNVdYTXh5ZWta?=
 =?utf-8?B?cnRpcHV1TW9HVlkrNWFWMG51Y2NFMVlHSWNJeElIT2J3RlVqWlhtcXZPUDBR?=
 =?utf-8?B?aU56RVFDRUF4ak5JVXBZUkRsRUZES25RYldrbnlrZ2JkTzR4VXFjcDlhUkJW?=
 =?utf-8?B?UEk2NVlsY3cvWXFtYkdpdWxCN3RSMnVuaVZtYmtaOS9COGhjeEM5aENhcUwr?=
 =?utf-8?B?WG5qL3FwUEhwM1V6Y0VndUFnZHJnOCsxRFVPdHBGb2JtdzVoNXdURTNHcGNU?=
 =?utf-8?B?ZmRQcU52OW5naFpOOW9LMWdUK2hWTEJqbnR3SkdEMlQ2dzFnY2FDZTBhT2Nm?=
 =?utf-8?B?NE4zV0hVYXBuMFJmdlBzK3dUcjBHdmVEQlBHaDVaTzl1WnFyKzJ5eDRjMDhD?=
 =?utf-8?B?Mm9OdytsNVFnRW1rQndPNVY5aHVXVExTdEFtcVlRc0gxL0F5T1ZpZUJxZlcr?=
 =?utf-8?B?bUFwMmZOV1lMY202bjRKSWZ5cjJLSWxVdUlhZjRySjVFQ3NBbjNZWHNBeDgz?=
 =?utf-8?B?REZTdUFpanA2L09raHFwVEM4dno5ai9UaFcxbXlmVWVWS0hGNjhjdDJ1L0ZY?=
 =?utf-8?B?cFRaSkJrMG55RVIyUCt1Qm5CSSs0cWJRaGNlVDhRY1I1ZFc0eWsvRnFPZUZN?=
 =?utf-8?B?N1RuQkM3MUQwRnhmYWF6SkNIRUxTNUwwNVBtZDlMeGNjLys3TmhiSW43a0Q0?=
 =?utf-8?B?bi9MQSs2NHhFMDlTTkl0aS9XVXlJOVRtdlZINDJ3Zmt1WDRCMVF5WFE3R0JK?=
 =?utf-8?B?TkVuU2gxb2dNeFJvSEJ5NzJJMVV0d1V3eXhLci95SjYxVjNCZlNKQWc0ZVMr?=
 =?utf-8?B?L2dOdHQwYVlXRW9FNnRwdng4YVNweHh6TWl2ZnlpUHZ4TVlUTnIrZ051T2Nl?=
 =?utf-8?B?SlRxQU5UL2RBbjJzMnNmaUlOaGhaRGlYeEZxR0h0ZkNRVlJZTkY3NE53UE1n?=
 =?utf-8?B?ZXF3Qnk1N1YrenM5akpiSjhuQndlMHhjVHl1dEV3a0l2ZTB5SFVtdGNJN2ZJ?=
 =?utf-8?B?cDN2eWFMY25TY1o2REZTRUpGaTVsZjZrNVMrZFR6VllOSnJyVGVGNmFKZENv?=
 =?utf-8?B?OGIveEdzOWpRRDdqVEl2aXZrU1o3akdYU2pGQ1dsSjhVcFovSXNKRHo0dnJz?=
 =?utf-8?Q?IVqV+5dzg44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWp2ME9sVWtmbEQwRFhkcmJ3QVlCUUdhbHhuYVlCaENydkM4TDM0aTgvY2Nl?=
 =?utf-8?B?M3hZbjlHekVkNkN2cTMrUm13dHlrSDc1Q05XM1hQMmZnQTFOdHQ4YmpSSFZS?=
 =?utf-8?B?UDBxeDJKWDBxM0pRWFBBUEw1U0tyclljU3ozekNCbDgrNEhwUVZMMGJ5V3B5?=
 =?utf-8?B?N2l5TkdRVUhEQXZFVUFJVlR1YTVJanZxTG42WWJKRGhoa2VYbVp5S3hTZlhu?=
 =?utf-8?B?VmN4VVpBaURwUmtLdVdRYkQ5NGlEMXpQRU9rYXhXRTE2VlZjb3Bkak1iMHZR?=
 =?utf-8?B?UVdNZjdqMmpyMGxiVmhQcXUyek5kNGJWUnYyS29BNFgzYmpTWHo3Q2UvTnNO?=
 =?utf-8?B?NkJTM2JFSjVtZG9kajNCQkx4U1dxMlBNeUZoclF4emlhM3NaaVNWTWpBS1Jk?=
 =?utf-8?B?ajh6akJTQ1pBeHhTUEpzNitsSHJ0UUpQdkxRdm5iMEpaRTdHazVYZkhDa2ZN?=
 =?utf-8?B?a1RmUDdDYU9HcVY5eGNYNUVjRE92c0gwU1hJN1BURFkxRzlpSThDdzBNUytJ?=
 =?utf-8?B?cDMrMld4REM0TzFvOG1mdUpCeHBYbUNxM0dlVGFoQVFsNTNFMmFCMkt3d1Bj?=
 =?utf-8?B?ZTFMaEczYlZGRnc2S2tsdG5Lekdsa1NwaEhTam5sTFNjdDV0NlhzNTJYSVFP?=
 =?utf-8?B?MmVMVW9LNjdlSDhxTkRSUENZdm9vM29ZM1V6YlU1VDN2eEJybFVFcHRiN2JF?=
 =?utf-8?B?M3EvM2ZQd2c1eitoVFRFZVIwNTNwK2cvV1NuOUY3cmZ6dEdTU1RaYlU2ZDVm?=
 =?utf-8?B?Nm1BUlFDeXB1b1o1QlFONStLb1VKb1lOYWs0OWJPWVozVzVUckhDRFhmckZU?=
 =?utf-8?B?VlNONEZ5R0VYdGpyaGIxVjNZZnZDZ0NGVzQ2T1JHRXBTdWhXdUU5YVROVVlN?=
 =?utf-8?B?eCtvT283b0JlVXpyZFNBdzNpcUFiOEFjand2bDdsMU4zNkZ1Y0djRy83b3ZI?=
 =?utf-8?B?WVdsdjVBQXNzcGFpNGZNT3NrbTlobUo4ZnhMWUpta3pDZzc1QnVZUVQ4Yzd6?=
 =?utf-8?B?VmYvRG52SFN1MTI5SGlmRnBYM1RnMnpuUkJ4MGhwdDZ5OVFYSDd3WlRUaTky?=
 =?utf-8?B?UnFSdUlXeW5yYTU1L1hrbFRvekxCazBCZWFjdWZVZWhYWWFkVE9xRnVjUTRW?=
 =?utf-8?B?V2JyWm53Mzd4K2xCYmhzQmNzZEtyaENZZVJPTitseGNnREhoV29DWE9jYzdP?=
 =?utf-8?B?Y3lnQTVNQ1UyWm9VaUgveHhuWVRtNkx6YTZZS29rSCtrYmlOcXFDdnVyVXlM?=
 =?utf-8?B?a1B5T1ZNdDRJZGN1K3hOOFZ5NHoxVFFTSHlPUEsvRjVXZENZUTlFNVBFMHVy?=
 =?utf-8?B?ai9xRWNBZUt2U2Y1a3pkL1dlSExFUHJNVUEvbEk2N0pQNzVaazQ1UHBocjJD?=
 =?utf-8?B?aVBkNVZxc0JBQ0xNSHUyK3FyenJtc1dUU3R5YzlGR3U4Vk1FK2JTQXZ4MGoz?=
 =?utf-8?B?eFBOUTU3bEtuYW8yZnJHY2ZCbjdnc29QVEJGSCtvdTJQRTk3UXBETk1ncjZk?=
 =?utf-8?B?LytiOXJ4dlg3d2laT2I1ZEZsN2xqOFI3RWNJZXRaSG5wVm5NT2U4dEdKYmFX?=
 =?utf-8?B?RiszY25ERHdRZzhuV2NSdmtsS3FYUWNuMEhQY0ZVRmV1RHU0SmYxckhKQTZa?=
 =?utf-8?B?ZDR2SDlkV25tbHRBRmE3R1RWeFpqU053ZUFWTnJHRnFRazhNMDMzaG5kbmU1?=
 =?utf-8?B?RGRuWXpxTHV5Z2VCSHZqcVV0ZmU5M0w3eHp1VTVWYWloVnJFNG1WWmQ3b2Rh?=
 =?utf-8?B?c2M5VGtJRTRUaHFSNVBNYnZ2NHRNT0QxaEpOLzlwOTV5cUNGMm9HdnNNYnJh?=
 =?utf-8?B?Q3FMM1R0Y09mVSt6Q1YvT2JiNVZXeER0M1d2cW9zOHo5aW91NHZOZTRCM0s0?=
 =?utf-8?B?QnVBZXltT2dwY0Q5eEw0cCtwblFZdzZyOHZrVlRTNms5TkkzT0sralZHb2Ux?=
 =?utf-8?B?TDlOZU81S3d4TkN5eFBYbTcyZlZEai8xL3dEcW1qUWJsUEJVSTgzYVhHbHlq?=
 =?utf-8?B?MllQeGJNZktTQlRoNnhoVTArNDZHczN1TnVlMklOZzdXM1VLWk9hdU1oa003?=
 =?utf-8?B?SzlDZmI4cE9lRERmakcySkVTRDNKS21sRFRmMk9qNHkwTHBMV0hEVlVkOVRq?=
 =?utf-8?B?akpHeXgyQXp1Z3AybWxOa3BVQll5UnJKeGRicVFNMmp1Vi94Qm4zM2FHSVdy?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vuc1ICkDwCfA+tJasBLs8ARKrsa/CfyQyaEA5x0X+l4YFOo5BEKJDsUFNE+UY9QVwV6eGCpXimWbvwrx7Blcfn3gpli4n8xodi32SVOZ/0ZgSZRpYKIlgMu2JWxBexfjwSAMSS167e6wl5glkzsRm/qWvIbKIP/MFtcPwvCGdBoOI7q6Aehvyv33uG23s7sx3VRK50TMRBCVl5abqA4qdayi5Z0uYgjkX0RFrLrwfuGNnNcXKat+HZeV9vwvVOAlwL1aiLuAwJRB+shLuL1s9bbEzHW5PTMUrjZbxcXOI8Q/zSHKZ4+j+5GBbhz22WtsquwEkDX9eXWrsDGaQAxhg1H0OyEHkeYZpCRpQI1ZveBMp2gTjOUnAayb3jVnuweQf3PadteRbJ2dqUxVYxlYdgwqM8O6TNlW/Yk07tDzLTGbQrEV9pOLR8SXSSsN1jEcLofMAUMUzrrhzA4Dl6++Giabqq7/ir78GJCVGaF/IFaG+SsxS5Zy6xFRY54tCOlW2wFCbQPSHarnp1ML74rvpEuA3OxvFMkRZN31SrKLUb62hNW088h6US4OuUUKRxkiTI5SQbJvePosHj6kVNzC4P74Lxr9IgYY07ITD1XrQTQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48aff3d2-c978-4a5e-e15c-08ddf209f925
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 14:38:00.7248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUS62B/NDtGEelPm5fVYhrqdVNFdAHbiigvPXwBOpEsz0H3QiAS+1zgcTeCS9FCFzbyt/WCruzEUwRCy7rxycA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_05,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120136
X-Proofpoint-ORIG-GUID: r_eT9EFJ9V1wNTw32tlF1TsZ32TEwKYN
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68c43065 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=BwSWIdu51ZsbxUqhSqQA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12084
X-Proofpoint-GUID: r_eT9EFJ9V1wNTw32tlF1TsZ32TEwKYN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfX5cr0cLenJ4yu
 AML8dTzEE5bWXEh811uymHjsJZhDZpup6okDHJhawbtumHn4wZu9jADO2Fq7rjpccL+Ues3xlZQ
 sEMQ41Uvjf5bMxR57b/QrqklHplGiZG51zd0jG8GjX6o/XOsBbjaj2knGgGjmrd++abWGD23w5H
 HNw1lTDU53iBGgCZ3CAjo4gu7mWTo0GtZhM4HwYpcSxNU0O7WYnA9vNjS+ap+Iu7a3hdVUAo/BS
 Ak2JemYMAo2UMGezhLCSjcT5QnVoRWE0eOKDgVr5qkoxWPEq14Nfu5jN6mzx09XOAT+hKu75uFf
 jOiTEyS5qRuu0S+19LYj2f0fCk4Yxmi903G8LCE1ZKFVqGjYMmzyRrbmyH/Fk4l0lI5N+0nUerb
 xXqzkStVbQi5hhjkpTm9OME5U8xjIA==

On 11/09/2025 18:37, Bart Van Assche wrote:
> On 9/11/25 1:15 AM, John Garry wrote:
>> this can race with a call to scsi_change_queue_depth() (which may free 
>> sdev->budget_map.map), right?
>>
>> scsi_change_queue_depth() does not seem to do any queue freezing.
> 
> Hi John,
> 

It was not specifically freezing which I was concerned with. It was how 
with the freeing of the sbitmap now looks racy. Just resizing the 
sbitmap would not have such issues. I mentioned queue freezing as queue 
freezing was introduced in scsi_realloc_sdev_budget_map() for freeing 
the queue - I'm not sure why, though.

> Are there any SCSI devices left about which we care and for which queue
> depth tracking is important?

many drivers still set .track_queue_depth


