Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4161FF61E;
	Fri, 11 Jul 2025 08:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752222560; cv=fail; b=dwhHmT7G/yh0fu+8zPnThzaCnamJZsQ1x5/ml/Qqr9kimY0MPG20HK2En3hsO1TuoKfYazewUX4sKPy+BWdqo6NhzsriuemKINAyl3Q4JsjKHRhRjejsRekWP9GZJqinVNmhp8/LRogC6A3v4iXIO8G+f1N14y4pxeZVB5LLWHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752222560; c=relaxed/simple;
	bh=0WgX7sWNeEidoHkGP5j0RIDqV8ra7eb4rG6XVDQu1uU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IknxXS7qGEY+NVUDrBV9PzZgFbfWJLlkuvO/Q3NzfnGUBM6B7VRJxELBRezEHfIjljXnSnTgNGOrEOdzyKbpx+0I7doZS9bTfzcNIRBIPmY5YIMWUJcQ080UExm47MVIrHwPQgnlnw1qGv7EQ2UgCndGVYD2xc1Li52f7gKYidU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U4K42eGH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XyO+lZld; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U4K42eGH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XyO+lZld"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7rNri006088;
	Fri, 11 Jul 2025 08:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J8gmEqUZ6Z80+V20KOX6h5Szx7s+yxPGX+AhtVvBFlo=; b=
	U4K42eGHGTi1F62EL8nzOJQlA12jp4q8rdKviL5xdxZxr5FnzpJTrxv3/YTXPTGm
	Sgel0ekPxYc7atYh2IGV429L9Z9BhS+LTv06kY4X8i1dqQoyiBwYKLaqOedfo9KB
	t1NWIw7yFiPaYfiHr3FqaTGq1WXwcnfQZRDTKN2ln6gWDidqQlRo/hCRJD++Z2AM
	dirKWnoU4OG4j9cYoz91XONT11JwYPI+5Tx8oiS923Y0fvshqtiEigWcgTlhvZwi
	y/BhgQPt5TGjzCAASPwYEMEBBPjPq/PU7vrRPZKshcnoNemeIH/F6ttK+qRic9dM
	i65/DpB4ChlzLqZPTLNlyQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47txkn01pg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:28:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7JivK027375;
	Fri, 11 Jul 2025 08:28:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgda13w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:28:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l8HsBcLtcX/DzOo7rd2ABP8AighPww3UHExIF5jGyoqUFmpCCmtkP39+ufNSQY35G77NX1QqnLuYZVdJg/vYcJpjkOMxv0VZRXuZUmFET7CWnUezo24Iz+ua3ZJhmRZVmdGzS1ozgyPldsM9bLWdZQF5DGRW2sd+2eYWrVTeDRh/nlTgBqoik9IpI7X4NPeLQO3x/uZJGzcQrK+vRUzT5aNNOaQzxS1yAGMKGvS+xLcTz/jbz+s9M6u02+h79P01pjVrP8IMLH0mKyT2AjmHqTfzBU96CC+skwTCIVQvhdgeDhLdz5kmYiihHGDEXPuG1cZV/iDege9G8sNRD0ccjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8gmEqUZ6Z80+V20KOX6h5Szx7s+yxPGX+AhtVvBFlo=;
 b=iy9g4OcnI/U2C1wdaXdh55oeB0cNvTXXKcPIOYlzbMWt1LZghlcXC1nK6y/G1YLbsxxR3gJuTJzL10iywvtmgljMV+hMRLzmFiOlYV9qAHbF3SCH9bkEqJGLVxik/d2LFwvX8vnI2VVwUmsBEeClKTO4tjepPJ85vx34nnr0JgTEIvCuS+dyDr9dfDjoKfZkeyUAg9dG9ffXEdGCJjKBCpbbf9dIGrUwelUU3scZaCGxGCxag57UGtpxkD6+6CkJ55+fcwhOAyCAyEYDC+Ti6uVV9MKul5Di/fM35QESuP7eJicpgO7vKrnZOM/Uzm7Y4PO1c9gTRjgGMaFzTPB8OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8gmEqUZ6Z80+V20KOX6h5Szx7s+yxPGX+AhtVvBFlo=;
 b=XyO+lZldTIfJpmK0f5CxLRRDt42iUjRKu+lsG+z1qs6C9+uwVwVTP9oeDXPYttwI5e57TThqJfw3uNnqgYqR8FlPIkcDEwzebLnDQf4X+eyjynKXm32F28rmC/Lq3RJoktZHvqGSdusH+vgp+qp9kglZqajnIrm0dRWbN7nMJmM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7583.namprd10.prod.outlook.com (2603:10b6:a03:537::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.30; Fri, 11 Jul
 2025 08:28:25 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 08:28:25 +0000
Message-ID: <2b70fbd3-d63d-4bd3-8500-e14c41fc64b9@oracle.com>
Date: Fri, 11 Jul 2025 09:28:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/10] lib/group_cpus: Add group_masks_cpus_evenly()
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Costa Shulyupin
 <costa.shul@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, storagedev@microchip.com,
        virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-1-557aa7eacce4@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250702-isolcpus-io-queues-v7-1-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0004.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7583:EE_
X-MS-Office365-Filtering-Correlation-Id: 353aafa9-66b9-4345-3975-08ddc054e759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MUpTQ1V5TmNjQ1hHbVNXZUJSNEdBZmNhdGVLcVZzREdUcVRSU1ltZ3M0OG5K?=
 =?utf-8?B?UHc5ZS8zZjZFUTNic083TTkvMXdUY2V5bVY2dmk4d3dDUmNzejF0bCtGT1JT?=
 =?utf-8?B?Nld2d3IzNEkveThJSzZrWXMxMjFjMStXL2JjUktMbEhheU5mQ2dGWFFQYUhQ?=
 =?utf-8?B?YzU3bkRCbEluOG9NckgwYU9UYmtQMVJoOWtlaWtabWVqYU9Qalk1bk4rV2lJ?=
 =?utf-8?B?REV5YjFqVzVONVJwYkpKZXFJbU9sSkN2SzAvSUhwZjJ6aTVQcG5DTDBTTlNx?=
 =?utf-8?B?MHVVK3FteVkzMmwzNmh4MCtMbWtlL0JhM21LR3ExVE4zQU1nK1dJUmFjUkpK?=
 =?utf-8?B?WExjVkcwenRjR1dQOFh0SFAxVkZRSGp0Qkc0V0o5M3FvdXdlM1RuczI1K3F2?=
 =?utf-8?B?TUtsTXFVSExDQlpqQTEvbjNwdDgzQVArM3V5a2xCQkJrVzhWQ0NFWEc5c08z?=
 =?utf-8?B?RUx3enQ5QjgxVFB2K3QxdGNIeU02ci9VWnhyNUlvNEtlMUJ4cnIvNHlReVow?=
 =?utf-8?B?QTlvR04rVStDbEV1aXZiYW04emp4WkY0aVI2bWlmTEJBajI1NGxLeDNNWStu?=
 =?utf-8?B?TEJLM09jMGN1QUJPazIwM1llRHp0Umk5dzNzcndzR2VqNm1PM2J6Q3YzWi8y?=
 =?utf-8?B?dTVqRVpzRk54UTE3dHB2Y3IvQzI3WG5xQVRUL2NQMXM3QkVERENrL0lMRzh6?=
 =?utf-8?B?UVZnWDREdmF2c1NVbWtLQVdRQnhHQkIwdEZyUG9la3RHU3VDNVJzOExvdXRG?=
 =?utf-8?B?Q3ljS3l5a3lhWnBqZzM3cEFOVEJCdUozZW9SM1lleUcvQUpaSTNydkxQSUc1?=
 =?utf-8?B?b1MrNnRTZXpKUGN6cW56dUF3S2ZCTXRHakgrcmgvNEtwK0NWd25kdGQrUjJR?=
 =?utf-8?B?dXJBUHlqeDlFb0pyS3dRYy9laXdYdDNrNlpZQ081OCtzVlVwNk9Id1c2T2I5?=
 =?utf-8?B?MExFVHZMcHAxYmlDL2t2TmsvcmUzQkthYkVHUkxQRFFKU1lVSnhWQXJSOVlr?=
 =?utf-8?B?Q1dOdnhhMkdwL2dxVmdzdDVHTHZhN3Nkc05NSmRZRzBKSUovdjh6eUpQaFJm?=
 =?utf-8?B?WTFYYXlydU1BNUt0akJ4WG5sY1VBUHR6REVCeXAxcmRocUpsb3U0Q1pITll0?=
 =?utf-8?B?aCt1SXkvVS9tbGp3bEhvdlNpbVZyR0lmWmxBQTBCUjRJd3l3UTRNZWdmblM0?=
 =?utf-8?B?WFUvZEJGdVFSRE40cUpJa1E2MFZNMzdCYlFia1czejdnQWZnclNROS84dG9X?=
 =?utf-8?B?RWtaNXBBL3Qra2YzblVOY0xSM29FOUVMb3l1Z0d5SzNCYXdOS0VvdG94Q3Nn?=
 =?utf-8?B?Q0NtR1JZUWRvYjkyUEJFYVpSRjFMY2J5b25UendleGJqdHJ1Q21XNEd0SjNP?=
 =?utf-8?B?azgwcWUrOXo3bWU5YmNya0ROTjBFSHk0VnZrVHp2MUs1ZFhYRERNM1dZRkVS?=
 =?utf-8?B?ZElSSHBSOExrazNIa2NaOXI3ZEQ0M3FFVFNjOVl2ZzV2TUF6OGdDVVI5anBO?=
 =?utf-8?B?V0VRRDhnaDVvUklZSzZxeDNZcUtxUmxTdldSalJranhBYjBoSWRVTlRSYWFX?=
 =?utf-8?B?UGMwaEpnN2pmeDcxNitVdEdBaWNYUnlOWm52a2kyT2Jna0hHRmI1bGRPWFpJ?=
 =?utf-8?B?SVdSTTFzcURtd29iMFZKbFVqL256cTY2UmxaZHBINEc3bzVFdEVXL2JwWXVw?=
 =?utf-8?B?YndlMm9aQk1KcHB3bFlvd3p5Z3VTVG15QnVZZENGTWdJUEE1MjBOV3ZXZ1NR?=
 =?utf-8?B?bzVVM2trejJrTVpFZ21La1VIVkM3NnhCZ0VjTEwvWUN1akd1bGdzNHZTbXBs?=
 =?utf-8?B?bi9Lc2JCTWc5RCs3TmVwMG5PVmRDYncyQmt0b1lpdVE3K1VuSC9TclVmTytn?=
 =?utf-8?B?VnQ2cmtXbkRuVWx1eTZzeUl5VUI1M001NG9uNkMrRldLaDlDaElZdmtwU0M3?=
 =?utf-8?Q?ocnDF3QIbqg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGVkWUcwVjNWdksyazRuWFhBTzBudzU5WWRWQnBRaGl5alFTbCs0cGtiOGpF?=
 =?utf-8?B?MDl1RjFGaE9FYUtzY2FpU2V2NTdGTUlxVmNhaWQ3dVVMbzE2V1E3UlJjWlFD?=
 =?utf-8?B?UnRuYXpNN0l5emtuOVBOeHJpUmx4TnRPbXdKdUNqeVlyQWlPaXVNYTR0M1BQ?=
 =?utf-8?B?b2ROay9VWFNJeE1Ed1hpOFhJYW1Kc2Z6UmdLMmNvSjBHYnVqQy80QXR1dTJE?=
 =?utf-8?B?NFBMQVpHT3JzK1A4UG84OGZrNlhNait3U3ZHYjBiNHVScFk5bnpDcjNvOUdQ?=
 =?utf-8?B?SE5HdDQ0eS9zMFQ3bEZmUEQrZkFERGJQOTN6QWk5WHlnbXBsSWFZRU51Mk9r?=
 =?utf-8?B?b3NPYmV1ZHovZFNGU2VKcTUwS2UrdUV0MGh0OFdFMFZhNi8rakV1Tll3dDhv?=
 =?utf-8?B?Mm41N2dSY3prNzBRWTBubmVxVEwvUjVvVFh4OVB1UUpUQm5DckMyblg1d2dU?=
 =?utf-8?B?RlQ3TmMxQVVmcE9haXRZVU4rWmdtWmhjTWF0NGxFWnBoY2t1TjZIeHRaM2R5?=
 =?utf-8?B?V2FuZTVBaTN1dlRZa2lSRnBiMzZWK3hDL08zT1EvcXEzWjhLZTNEVmh0UEJY?=
 =?utf-8?B?SWthWUJMRHIxWmlhUytNRC8zM004Ykloc093VHZ4TVRNcjdYcjdURXBtb2xT?=
 =?utf-8?B?SVRzeGhuMnlIR1F6MEk1QlExZHdwWFpGL3BpZURYNG4rSW4wYUJFQVZiWGh2?=
 =?utf-8?B?NWlPdTgySEdPaVJnVS9QdklZMVNGS0JJWGwwQnFWWG1vdzhEWERqcllVamdL?=
 =?utf-8?B?bWFnMmRLN2NlaFVLRWdoMVlEVk10RitydCtzSnJuV043cmhySjNhbTBuSkhW?=
 =?utf-8?B?SHE1M3F1SkJ5T2RqeUdvNnlQMTlmZTB3U0VOY2ZvN2l2OVNvN2Q0RWdRNG4z?=
 =?utf-8?B?UzcrM0toa21ndXdtRTBxTHlPa2VTZXhOSVV6N2c2T3NYSjRIQTVyTDIzUm1k?=
 =?utf-8?B?S3dhYzM0NFg1d01OTHFBOXlxSlk1OFo1Nk0xSXk1M0tVTTlnd2R2VHpCRVo2?=
 =?utf-8?B?T3hsMVNPSjIxN1cwRDFOSmlaenpMOFJMUXJ4d2RDck9xalVLK1E4dDFDNEcy?=
 =?utf-8?B?N2FyT21odHJSL2JNNElPVEdtWTZnVU9Sd0ZPaHZsOXM3WVhwSkJOUFRtM3Y5?=
 =?utf-8?B?UlNLK3ovNjVMMWRFU1lBMEZHYzV3RTRYcngwUTBoc0lVM1FXd1FvMk1VUzNw?=
 =?utf-8?B?UXh6SmQwZUQxSmRFdW53eWNqOWVnd3lEUGRnVk9BbzJPQWNESkJKOHVxY3Fv?=
 =?utf-8?B?VnIvejlwNXNEY2hWTUxYazNDcFdjUHV1L0c3MnhYSy8vZkRyV0Z3ZytJR3RK?=
 =?utf-8?B?OGp0MExzSEs2QVVUN0ZTdzQ2bXAvRUFUZmRydXFCOG1kMFpaTTRTMEh3OWJx?=
 =?utf-8?B?MG5yTWl2VTV3ZkhCdDFrTGYwbmpsMVlQLzJlN1FYT21zS0ZzeVEvL2pzOTdR?=
 =?utf-8?B?WEpCUko5Mmc4S0RuQkxHN2c3d0NWWGs1N0tEWHlpanhqQnFHVTJmY1J5S1lR?=
 =?utf-8?B?bnlxQ01Za0RYV1Jnbis3b3ZkdjhtaStvRU0zTXQvT3dVcnVEam8zQ1liYlIv?=
 =?utf-8?B?U2VTRnZ5WWlrdzh2OHJpN0tXWFhNTS8rQUdMekhPVnRjeER5VjJWRnFaNkFk?=
 =?utf-8?B?WUdBdWlhZ3NwRmxoWXQ4LzIxT3VjYkNHNkVodWo1RlFHeW5jM1JoUDIzVDhI?=
 =?utf-8?B?dzNNakdhQXpvR04weU1PNXRqU3VvL0xKQlFwdGE0azBmU1V3K0VrUFFRdTh0?=
 =?utf-8?B?enk0RDBMbFVPTm91ckRqSmViaW1lQnJJLzFKS3ZCb05IakVObjFvbzJGbjc4?=
 =?utf-8?B?VGN5czdzbE9HTHNEc3l6MUVEVkUxa3RKeHByaFlVUzBsL1AwU2VBczdVM0Y1?=
 =?utf-8?B?N29GejlHbEtmczc4dTY4Y09nWE9oL0R5SWtQSlJHdXFZLzAwNGVkWjE3cnU2?=
 =?utf-8?B?TndxVkRKQVJFMVpPZW9wditRaG4yKzNLdEg0NjdyMXVuYkdaYWZWOHA5NmRW?=
 =?utf-8?B?aEtkdkNwSktLVzltMVZCT3VEaDQ0SGVUQ293Sksrd2YwTm5jRlhQSTRpTEFQ?=
 =?utf-8?B?bmRXS2FENkFxa3RGZUNCeG5TRk9BQ2grRjdtcllpUjlFV3lZTXRqMHZObmF5?=
 =?utf-8?Q?RcUWBNRJyiPCIGNepmsCNlsLV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KaXC81kXde2WMZ+jSIqY/TZW9/YuKk8vHJCTk9OcB9UWCTjhnZIsBUICDMjRBzXJUv+ZRX1TuxtmN4z8FU8l53wlGXyB0hAKULeQCpe420hOGURj1zw/fEjdRXS8TsP4S3bFkNYWCxobVXre42ZcjJi+tWiEsfEmqYxTtCdnjitHbZD2RhtoBzbHVAFK/AzretpU77vxGcZAbX83V8bP40k2gDauGaww6xe5pieiebnpN/D5EWI9s0YaligUayi/UD/Os2Ci+o2BHcNlQoN0qT0Z+epYYydUbxHB9Dx5VFMrhDuqsh6IuCyhQPwIfZdglrdhQXYbfit7MfWObld6JY3to+xxx07UX/0dl5wV7qlbQtBHRTfZMAaVya/K3LH3opZ5lyHciEhDCRGXhPnFS8/kWCMBn66zrOnT1JPPnPizH975XHUrlRVIF0wjqVxYTkyEHuIMNbiTNOjW7tRdrAsGyRgko6zL+fXhVgqtymSmXh0fXKKPS2aOMw/VMU5IEM0WdpJsSMvbra9Y4Bp3D+jsr/DpaQtK6zwNVtXHqjnIq5yWQMkZRkZ+8tryU//B9+Vm/mFs0i7MtoI2TiQ+Ew2Cq37n4Wd7KgXJdjxoQVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 353aafa9-66b9-4345-3975-08ddc054e759
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:28:24.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8gZSQnyDfhD4bUvlKjm/NAIUz9RFPtfq8DdkWBPF2dN16tDveXB2k1kjc9uKxlrcoLCQF/52D4/zQ76LvDBy4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7583
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110059
X-Proofpoint-GUID: sIG4BgMZRzwYl1w_Rban8yfzQidWQ5DO
X-Proofpoint-ORIG-GUID: sIG4BgMZRzwYl1w_Rban8yfzQidWQ5DO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA1OCBTYWx0ZWRfX/DWb3rGx3kRg bYMv73BLBrggz5tjghFLrAiGv3jRiioIWn5DCSRt068qH3s2M9SCNgxP55H0B3E8nylC0mBRimp LJjgPjFXRtbbpj4pvox6zEM7qMrEeXHrHfL0YOX0bT/+J+81Vo4NI1okZSJokuZw+jMypKZs2I7
 79Q9dq669y068cWyg2m0HfmFiWoUo/Bit/XjSSTMuBrQ4zdn2y39FUYJWWcIGTq+/3XHmPADnDq GpX7rQLU6yOs4Z1pkIbAwayVAaR4wqE9X7QkjZ5fawWlHI7VuVpjGLhCcXcgYeg0vZOWGX/ZL0K uLn6eCyM8dEOZ3AKy9+1Dp03yIoIKepa4q/ks78XtY3en12mxaWdJAn808ou9oUcqBzn8zRcLta
 4X+p4KX/3aqvPQe8uOHRr+eRHjv9r+ERaHAu8OEftYmrsmHpWng6nn7MlwwpByhzE+uNSg/c
X-Authority-Analysis: v=2.4 cv=Vez3PEp9 c=1 sm=1 tr=0 ts=6870cb34 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=Q4vjUesSlTh6kCyzSeQA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12061

On 02/07/2025 17:33, Daniel Wagner wrote:

/s/group_masks_cpus_evenly/group_mask_cpus_evenly/

> group_mask_cpus_evenly() allows the caller to pass in a CPU mask that
> should be evenly distributed. This new function is a more generic
> version of the existing group_cpus_evenly(), which always distributes
> all present CPUs into groups.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   include/linux/group_cpus.h |  3 +++
>   lib/group_cpus.c           | 64 +++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/group_cpus.h b/include/linux/group_cpus.h
> index 9d4e5ab6c314b31c09fda82c3f6ac18f77e9de36..d4604dce1316a08400e982039006331f34c18ee8 100644
> --- a/include/linux/group_cpus.h
> +++ b/include/linux/group_cpus.h
> @@ -10,5 +10,8 @@
>   #include <linux/cpu.h>
>   
>   struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks);
> +struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
> +				       const struct cpumask *cpu_mask,
> +				       unsigned int *nummasks);
>   
>   #endif
> diff --git a/lib/group_cpus.c b/lib/group_cpus.c
> index 6d08ac05f371bf880571507d935d9eb501616a84..00c9b7a10c8acd29239fe20d2a30fdae22ef74a5 100644
> --- a/lib/group_cpus.c
> +++ b/lib/group_cpus.c
> @@ -8,6 +8,7 @@
>   #include <linux/cpu.h>
>   #include <linux/sort.h>
>   #include <linux/group_cpus.h>
> +#include <linux/sched/isolation.h>
>   
>   #ifdef CONFIG_SMP
>   
> @@ -425,6 +426,59 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
>   	*nummasks = min(nr_present + nr_others, numgrps);
>   	return masks;
>   }
> +EXPORT_SYMBOL_GPL(group_cpus_evenly);
> +
> +/**
> + * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
> + * @numgrps: number of groups

this comment could be a bit more useful

> + * @cpu_mask: CPU to consider for the grouping

this is a CPU mask, and not a specific CPU index, right?

> + * @nummasks: number of initialized cpusmasks
> + *
> + * Return: cpumask array if successful, NULL otherwise. And each element
> + * includes CPUs assigned to this group.
> + *
> + * Try to put close CPUs from viewpoint of CPU and NUMA locality into
> + * same group. Allocate present CPUs on these groups evenly.
> + */
> +struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
> +				       const struct cpumask *cpu_mask,
> +				       unsigned int *nummasks)
> +{
> +	cpumask_var_t *node_to_cpumask;
> +	cpumask_var_t nmsk;
> +	int ret = -ENOMEM;
> +	struct cpumask *masks = NULL;
> +
> +	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
> +		return NULL;
> +
> +	node_to_cpumask = alloc_node_to_cpumask();
> +	if (!node_to_cpumask)
> +		goto fail_nmsk;
> +
> +	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
> +	if (!masks)
> +		goto fail_node_to_cpumask;
> +
> +	build_node_to_cpumask(node_to_cpumask);
> +
> +	ret = __group_cpus_evenly(0, numgrps, node_to_cpumask, cpu_mask, nmsk,
> +				  masks);

maybe it's personal taste, but I don't think that it's a good style to 
always pass through 'fail' labels, even if we have not failed in some step

> +
> +fail_node_to_cpumask:
> +	free_node_to_cpumask(node_to_cpumask);
> +
> +fail_nmsk:
> +	free_cpumask_var(nmsk);
> +	if (ret < 0) {
> +		kfree(masks);
> +		return NULL;
> +	}
> +	*nummasks = ret;
> +	return masks;
> +}
> +EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
> +
>   #else /* CONFIG_SMP */
>   struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
>   {
> @@ -442,5 +496,13 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
>   	*nummasks = 1;
>   	return masks;
>   }
> -#endif /* CONFIG_SMP */
>   EXPORT_SYMBOL_GPL(group_cpus_evenly);
> +
> +struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
> +				       const struct cpumask *cpu_mask,
> +				       unsigned int *nummasks)
> +{
> +	return group_cpus_evenly(numgrps, nummasks);
> +}
> +EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
> +#endif /* CONFIG_SMP */
> 

