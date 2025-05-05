Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AD8201270;
	Mon,  5 May 2025 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746446673; cv=fail; b=aWDHFr0HGQpr/7pd7IWe0AtfMSyV7AIjKQ6XENdtf911NSnTcq7CkeqdRFEcOnbW8VkRc/88iumsvexwniTPFxq0HqcPL4jWlB7STdgIdIWrhKJTFTt6e5mEm3mzDZaa0aGr6mpgLATet/K4ZM5tpu3XspooJ93P1uLPk4/Cbi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746446673; c=relaxed/simple;
	bh=dDO9++kLeEwyZ0/VJeDnks3UJq6Kuj34OcI8lDm3eRU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nsjfCet/urSAyEJchET6lH2c04f56s5I05r4EJ9z61vM/jvsa47UcTyNJnqD6JE4qiv86nAQsM4a3oALs/CfArj4gh0r+E3JbqCtUQblEuoLZtEj201r8qBF0T5lX+2yg0idNj8Krlkev+9sTE5Luw/we2atf8MQR/meGRR9a20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wqo/yheM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WMIrIjGy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wqo/yheM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WMIrIjGy"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 545BcvXp001347;
	Mon, 5 May 2025 12:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eukK2zTNOendDsKSdcCgAl78v3YSQzMv6QRO2dOMVdk=; b=
	Wqo/yheMSdflEWZc1sCBOf9MaFq9qFGULV1LLAz2sj+h8WnntfJ2d80O0o61UwHR
	EV8pHhgyG64RKaGQX//T+ldRHcTOA00gMEUO2YlN6E5RY7S9KHmOmVHChvadQUEq
	H7s0RZD2J9Ly2ljcI9ZBMAd4/JfLsTW14+xjJ/kZtY58QSrPR/a7JXyCpGfgTJ1Y
	vz/VvKC7kTTzVttb3vpUPhGyaBHcM0bgD8l0C5tiAwSldV0sIwZFI4st9Z72qXar
	NzS6+3Bcy0BejO9Btq0QtSYcf1OsToif0ZzDXF5KhaMCN+alwp78j2m7bSrPIucb
	iE6jmBx0GpgWT71kmiUDcA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46evmy01m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 12:04:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 545BfYh9011178;
	Mon, 5 May 2025 12:04:16 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azlp17010005.outbound.protection.outlook.com [40.93.10.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kduej7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 12:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+qJuAf4gdvqrL48GBP2KQnF+w5LOMRaEZ1Q1MXvFcKEKiNoNCNCgCxbRetlWwjJnq1+m0VcfRkixFmJ1G5wAr3S6NK7ohLbXmzRyCOSlJyJ8E43UqzEgrXrd+tPBei97rxbGP8pMBmA6TIOmVU2jUOjCJjgMFGAni18Ssj+ogy79MdDGOsxpa/tR0AHQGrlUTmZvw8CJ2zwx4piP+8amRfp6iYRJv7nJhYA1HP5mMbbzxnJwTIbVdMEuogAFMIFZGM9hkhzTQfLiAXBszPjWs/4ZoS9J/rmSe5g5hPtiL/QGx3yC3Vy4gVaoOmnJI3wSIIpUkL6vU0F96hnp7nIzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eukK2zTNOendDsKSdcCgAl78v3YSQzMv6QRO2dOMVdk=;
 b=dJ7WkdXC2qbx1j8a/5AU49QhH/DZy7Ycejk7oQNyzNUAsMYPNO77WNgcXwG8/bTKIHlCSwLFE048llAa3t151Qmb3ewONWfi9Lgwf2gGhQ6MZjOfvQp3r9Tawm23kf6cREuWeftGr8s1duQM/aW9Y1GyNJh/2pM+qWv6Ft0j17yckZccuTBrXoo8gsilZwiLIlqrr7lw6zyGP5JLkaZpa32GiEmwpmr4G8oLA8BOmZVtodDRud0wVu0fDSPJ3D7Pb6BGL35SEi/WXHQW7mMxSiJkLQC1ruHmbbkxT2o8iokhO/z2nVSEyS9pNH6JrvtYJLIxIxvjs7lZDbF5IpQQcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eukK2zTNOendDsKSdcCgAl78v3YSQzMv6QRO2dOMVdk=;
 b=WMIrIjGyc+UuS1uPbTs9shkoy8hrN1KvHuxARFrfPDccGjfe/Mnw0yI6u/hY/mchViMXCyOvZp3qzNou8qrDdUI9Apq0Qfr16w44Gb+eUkZuhgUzLE1issd9FpwZpTJfNOvr8gviM4DJvganJmDfuTimNk+U28twoT06P7U7Btw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB4833.namprd10.prod.outlook.com (2603:10b6:208:333::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.35; Mon, 5 May
 2025 12:04:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 12:04:11 +0000
Message-ID: <71eb1f3d-9234-43a3-9996-af8d10b37ace@oracle.com>
Date: Mon, 5 May 2025 13:04:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] block: remove bounce buffering support
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org,
        Hannes Reinecke <hare@suse.de>
References: <20250505081138.3435992-1-hch@lst.de>
 <20250505081138.3435992-7-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250505081138.3435992-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0092.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ab23275-5ead-43a8-6f63-08dd8bccf29f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zm4rUnZvMk9SaHQrb2poMlovZW1Pb2xySGg2VlBDVG1jaHh2eDNldjRyQlJi?=
 =?utf-8?B?TFh6VkZtanh5ZjZiSk1nOGJpcnJFUDdPelZDZnpXcnRJdjF5dFVsMlRXVEl4?=
 =?utf-8?B?ZkZremIvUGhoRWczY2FCMUFUQURCWG1iOGdnTmJOUnkyTFFhWExPS1RNRXcx?=
 =?utf-8?B?RlpYbnJySlVja0huQW9qS3doVnJpQm13Mm1LK2Y5dFpTMEVsZmllRFJZMEl5?=
 =?utf-8?B?V1ZZWnA1M3VQcUdoZmEwMTRCNkd5Ritwb3BSNFpIVU1hZWt5cmJoVlZ3RldU?=
 =?utf-8?B?dVZpVzdRZVZ1OEk5K2JJS1R0dEtCZGpYRGN0a01tN0EyNDZvNVh6RTBPQlVL?=
 =?utf-8?B?Z2FaOTV0L3AxWWE4RWxsMUNLZFVuYmZiaGFwRUdkWE92ekhoa0lGbzUvUFN1?=
 =?utf-8?B?aHljdkdIZUYyQzF6QThNOFdsTUI0U3ZvdE13czhMRmw5OVdZNW5WWGkrMXZQ?=
 =?utf-8?B?TGoxbTAxcXhBbVZ6dFFtR3NWdUx4STFkY0ZQeFVLcTVBeWxoTHE1Zjljd1RJ?=
 =?utf-8?B?NVdEanE3VjR0Mi8rNVZmckZTVEg0bWo0djVFbHU5SEgyeDVRMnpUaEQvY2Vi?=
 =?utf-8?B?ak1PSC81ZG9yOTZ3MFY5ZDJIdHVjcm9ZTTlabkhLU3NDbW52dGtqWmdtRGZm?=
 =?utf-8?B?bUM2Tkh2RUVOMjRhdWsvazM1ZHBqcy9EOVJxc1p5OGN0RFRyK1RXQk9qME9Q?=
 =?utf-8?B?RFdENzFLUm5MZXdPd3RCQndTeTZnSlZibk0wMUo2a0tFMkxRYytnMGYxazMr?=
 =?utf-8?B?YmxOS0F1dk1STzlqQnhkeTlYdTZXSUlOR1J2d1orQnltbTMwdjcwMFJmbXI1?=
 =?utf-8?B?U0xEY2dESnNYbVBIVDhlaXZpQTZBZGx2dlRHcW0zdU1qZWNJanJrWmg5YU1i?=
 =?utf-8?B?cVZweHpzcnEya09LQkZLT3YyYjhBT3ZkMDUrbTZRclAxYnExNVF5UGZRdTBN?=
 =?utf-8?B?ZmtlYzFBWUhsU2hxTFdNaDg2aEVnc3N4ejdwZ2N0eExhUm5sdDVHd0o0blVQ?=
 =?utf-8?B?eE0rZ1hLSGIwZDE1aDJFNWZpbGFDeEN1ZnVGVnMxc0RQdjh5bFZDSFhEQ3RB?=
 =?utf-8?B?Q1VTSTJ4OTNhd05KVEhiZThTMWdIMXlMcW0vaTA0bW5hRWFUL2V0SGMzVzlC?=
 =?utf-8?B?TlFkNkhSV1JveXlzbFlHUVdjYTlnL1RKUHZuYXJJaXZxQTdJRk1ydWhRTmFo?=
 =?utf-8?B?bmxNWGt1alhIY2xWeG5OWjNlV05SdHdzSzE5WThUUnpnNm1xeksvcWFHdW1K?=
 =?utf-8?B?MWFxNUIwWDRFNDlhZ2FHc3NjVmV5ejE4T3ZNTkZOWkphTDJ3TjNPVThhdU5r?=
 =?utf-8?B?c1lIOGJSbXBEMzIwaU1ZWFRXYlpRSGQ0MlBsNDRuakEwazk3NkRBUFlGL0Rw?=
 =?utf-8?B?QXNmT2x3cjlZRTY1UnJUZTJTRHVBOHB6eWdmdmNjRTVLRWdhTFd4a0g3cERX?=
 =?utf-8?B?NTVwNEFYS2d3N1QxZVRrUkhiZFBNekdORHhtZklOSjNuYXlSc0VyY0JobnQy?=
 =?utf-8?B?dnRmRFlic1Q4dThLM3cvYXlieU5FeU8rVER4MExFWmdJdDB4UStSSzFVaGNQ?=
 =?utf-8?B?dkRFaS85ZG83OWppZjV2bjJCNng4M29DVGJ6d3AyWWkrc0VMYUZ1RmVQM09H?=
 =?utf-8?B?UGN5b2tkdWsyL2dYYzlsb3lRNlk4bytuY0VNbmxqRGwyb2xVdVZIa2lXNVl4?=
 =?utf-8?B?UkduU081anFLM3puUnlqYm55dU5td1duS2pZeVZoTUZzTXY4YWN1bnY2R3di?=
 =?utf-8?B?RDNLa2gvVEVxK1pRZHp1MGQ3NWNJTnluMEEwQWQ3b1lJSllBN3NJRmROZHd4?=
 =?utf-8?B?RG5SWDEvZHpTL3l4RCt1Y3NNZkpqRmxNUlJTVU5sa1dhKy83RUtEeFpLWHIz?=
 =?utf-8?B?RXBDOUlsQ1BmaDMxSmUxMzNkeVpFdGtqa1JnSTRzNmxBYVQ5UlRTMkZvRG00?=
 =?utf-8?Q?jzV5OGZ5KY0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3NLUlEwTXBWOEIydDZTMmN5WHovbXVSbWtTR1ZZMUpvdUU4bytZWExncXIr?=
 =?utf-8?B?RTBBdlFMTWRhVzJBMVVSRnVRQ3pMMkRPZ2laUWNndEgyRGtacjZGLzZHQkd4?=
 =?utf-8?B?dXBqM1BmMSt2WnFERDU0Nnpxd3p5ZGNOZzVKbHB4c3RYY2c5VkNyTmEzR214?=
 =?utf-8?B?Vk1PUllKOFZJdytWb0liV04xUVJjbklIanM5REY3OGMwOWtYeXpLemsyS3Vq?=
 =?utf-8?B?MlV6VmtNelRFckZES3I4VW9IdjlWbXZPSktYdUdRdVZuN08xdlFrbFRCcm1q?=
 =?utf-8?B?Sk82Qk96MUMrVTNaRWRrZGIwaGtZSXFHUEFOWnRtNzF4MEFHTWowQlZiM3Vp?=
 =?utf-8?B?ZlRkSU1Xcm9kbDUvYnhiZ2ROQVZKUC8rZjRIVEVMVjYxdzJwZloxaFV6UUFQ?=
 =?utf-8?B?dVdjZ2NQRWljMlRaOGMxSlJoN1FxZDdZMDFuNkRYN1JVbkViRFV3NnNFQ05L?=
 =?utf-8?B?UlNyMkdxN1VENlJDMndsdHk0TnorZFBIM0F5RTN1dUs0ejN0Y2g5LzNIZnNz?=
 =?utf-8?B?YnlWOHFTNmNPcC9sYVVVbWVWcU10cEdSbEd3bkJobndjU0VhNm5nRUk5U2Jr?=
 =?utf-8?B?N1E5SkdWMm1YLzcvMnhCa0dmOHBCNEJUeCtNR08yeTZNMmlmd2lCQXlrajda?=
 =?utf-8?B?OEYvbFFrTVhKSjEvM2RkRXJxd3N1RCt4Q3F2RXA4UGRVbktTWjFkRGRicnZq?=
 =?utf-8?B?TmJwek05d0dZZEhjcnRnMjQzWnNlTHBXZEJtL3NYY09nZks4ZTJDVkNGTXhv?=
 =?utf-8?B?SlZEZHZyc0tMeTdiL2hXazRrMURsYk51dnlYc3VvbG1XSHBzUGlDeDRDWENX?=
 =?utf-8?B?dnhkV0RlMHZscXpiRDFuV3BVZE8zOVRxR3FTcmlrUUlaaWJQY1hzUUtaQ0tr?=
 =?utf-8?B?Y3FaUmhtTjAwRVpWWmZvMFdaZ1VXdXduc05nbWhMa3dtTnIxT09tK3IzbTda?=
 =?utf-8?B?ZW5ESkZZaG9jVTBpUFRUOEE5a0JUMWxBKy9EOGM2R2l2T2tIY1cybmRSNUh6?=
 =?utf-8?B?OHNwdXhYWTVhWjdQc1ZCK2ZqZFZHUUJZcmFRNkc2bXdTZ2lBcU1MWW51S3VE?=
 =?utf-8?B?TDNzdlo3OGZVdmFaOGVvelpwMnlybG0vZ2dobEFZVitzZWFHUGk2Z3ZEbDlU?=
 =?utf-8?B?V2VReDNKaWRVVDUzWFZ3SER5U0FOYkp2bnY0VEFWdVQ2YU1iSG1sNDJjNTVp?=
 =?utf-8?B?c29tMEdlNXZiZXJIUXlvWDQyN2UvNVNaeXNHRTd5YUd6YmJ3Qy92Z0kzR3FU?=
 =?utf-8?B?NUI4TS93MENHWGllaHVzcDVYdlF6RGZRa3BaRjNoSFpJeEZaUUt2RkZSeWhq?=
 =?utf-8?B?RjRRcXM4NzRmd3RsT1RxSTM5SGpFa1F3aFBCWFVtMDBmeGFRZkhhcUE5dHc2?=
 =?utf-8?B?SjRCMTg1dkhPRFUzYzFxY202Y2lRZCt6Z1JEamtMS3IvT002OTdoVzJUckpZ?=
 =?utf-8?B?UnZOeWFJRE1ZTFQzUEt2bVExMVA4UFZzNUJ2bWxJWDdmelJldUxuUkJiK0Vi?=
 =?utf-8?B?Tm84WS9vQWVJN2F2WTh1MnhkRm1FVW8wNlhlUDJmdWdIMW16eUxuYVhNU2dE?=
 =?utf-8?B?NWNIQm5Fa1hnSmtyclRHUEFsa2FzeFpHSUwraHJsc1BidlFzQTRua2FkZlJS?=
 =?utf-8?B?NzU1Mm41QnJERGRma0E2dTRmTXViZ3M0NUMzcndRWktsem41UVJuZzI5S2F3?=
 =?utf-8?B?K0s2L3cwQWt5S2F5c0FqQjhxQUVOeEozU3J1NWt0SndXRTJxTjNYdmhuWms2?=
 =?utf-8?B?VUcwaWJrSU42YzMwcFAzc2VrbHpQSkM3N0ZibEhhMTFGUGpYalppKzZYVDFG?=
 =?utf-8?B?RXVrUVFldlRRaGh2NHFrU0RhSTZXOXRob0pYVVhwaG9jSEJDV2svY0J3RTZw?=
 =?utf-8?B?Q3Axb1lrd1dVQXlmekNHa2hxVHpya1FQYm9ISUtzUldrb1pPbEVQK2dXWitG?=
 =?utf-8?B?SzEwamhUMzVONkVZNDNnRFVnYlVFL0ttZ0pNTm05Y0YyL3FDdmk0Wm1lWGdB?=
 =?utf-8?B?aXc4UGwwbnlMQ2FWUGJnbzl0QmVzMm5KUEQ5b3VpUUpvTnlUeUdTRGxaM21C?=
 =?utf-8?B?bWZFZFJuWFRscXl5ZC9Nd0FlS0kvd0JUWGEwQm0rVEJmcEU2SHkraFJoRGVt?=
 =?utf-8?B?S01UK2kwL2IxcTlMM09OZit3L1BUMzBSSkNwalptalNFRmJ0QXRpWE9rUXlE?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E+9AEaU2dcQnpugCRaTJBvfvvADIqXRy6AC3hVknisW3refXj5DVqKQ1xjz7Rm8SdN16dqOsxF3LfRI9/L3g6oMtdv6Y11zyvsq4tmZADqQbW9+e6vrwohsrzLoALWFscD0dOTw25Q3AFZNExeCdDTPLXHupom4xpI4NX3A5GhjAy196B7e6CfPqXqadAlsBqZcwonUYesZ/0MpiQN3ZMnZxHBTlCHbPZqwgjzLLro7iweA6/yi12cJa7jxjs8SGbhB/bO2ZD+6pm7PkwVJ7bW+HC1+XdRB578AJS7UIP2MYtx0phtw9C4b33pCnptrkKZAULCaOQyycY0176JBEY7nAPwopU9eqLBDMN7ipPRGj5+d8iR06F9l9juk+hBxhEm+EYJ5CJCJ37uOzvqsvhBF69KhtBL4gxfRcx00uT79eC5BmFRMX3YRSvmgajgblh+ZbvF+9Q786TfYTpfpRxcGk4jfJ5/okGIQmuYCCNV1NZTL+xqX0nS+p8cqqqhfSjgPJey3KCYNjOYziXts5j/SbKLLsadwJiH6Zxz7E+uGjiX1LH6uzRosIDTdsF3LlQW6/jS3mlC1bF2AYodzCCHvEACiIdzRX0/CsiZgF2RA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab23275-5ead-43a8-6f63-08dd8bccf29f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 12:04:11.8885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eDxXpVMhr8r/d5qKzL4MzAp9061Cd0Slbo3Zwao9//2A8dIEBicT/L59Gw0/X5DDWw49R1QvPjNCy4Wy4QZxgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_05,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505050115
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDExNSBTYWx0ZWRfX4buG0rS7VO0R oTWSdh2e4UalIEda+L6Plfren5F3FeMG3OiaemLudi9wkiyCZAg3MCcsMMto33gqZ+Ew31r9bRU aAXuQNCOocOsyZ0qxWFQMW9Nb0kvkMGWtMnfjphpes8jqbDceWQbiFgO3MZcTYyCE8qLXXJluEj
 S3SHvjQc9cD1xFAS4JCCGiXlCPrOcrOdkCfEORU73pViozaOLy+N6guqZVN9ACtGFjml6tZgqxR EQBDDYOU3VXq/HXyq9djZV4XBTAcX11eJZfcheAsjo9s+SlOEhMaYGyRkAsgRpPCUCLfVRaWSIa yPZPus2DcVQVYnnpaKJyhqR1LYqiOgrGR9w5xiMnvBeMHmDZS7F8TX1MwcZaz3I34LGVBElCJu4
 dq1+U4nqQwcRz4DYluvmMUYLK5nhSTpnUKhN8SERYG+erf9H/7NV3dGKTSZgTPYHMaZf+HPI
X-Proofpoint-ORIG-GUID: Gnv1jwZowkwgsa-n4xwx7uFJexoSEtPA
X-Proofpoint-GUID: Gnv1jwZowkwgsa-n4xwx7uFJexoSEtPA
X-Authority-Analysis: v=2.4 cv=VPPdn8PX c=1 sm=1 tr=0 ts=6818a940 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=QWjiJ_0dTQriEb93NaIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14638

On 05/05/2025 09:11, Christoph Hellwig wrote:
> The block layer bounce buffering support is unused now, remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>

>   	unregister_trace_block_rq_merge(blk_add_trace_rq_merge, NULL);
> @@ -1462,7 +1454,6 @@ static const struct {
>   	[__BLK_TA_UNPLUG_TIMER]	= {{ "UT", "unplug_timer" }, blk_log_unplug },
>   	[__BLK_TA_INSERT]	= {{  "I", "insert" },	   blk_log_generic },
>   	[__BLK_TA_SPLIT]	= {{  "X", "split" },	   blk_log_split },
> -	[__BLK_TA_BOUNCE]	= {{  "B", "bounce" },	   blk_log_generic },


I don't expect any problem if someone re-cycles "B" in future for 
another action

 >   	[__BLK_TA_REMAP]	= {{  "A", "remap" },	   blk_log_remap },
 >   };
 >
