Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BF017C21E;
	Mon,  5 May 2025 10:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746440217; cv=fail; b=peI6Vw/eisSsbkWan22UL4w/aSVQtBYjT3xTX0Nkh4DbTk4xOephKWHX5MIPxUibCRHOWaZF9XEI9JgF3dS6/nPjGtcR/ZQOtbaa8gVZWaIuDxK1S0oe/fYXZsqIVkRNmnhiu+N07bTqpTsxUrpG5DLb30/fmbhPH0wlN6F/c24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746440217; c=relaxed/simple;
	bh=CGqRCQK6QzxdE6pBubjlYmEzKdDnn80ic6d81AFgjoU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wu0j9GOUzo0h/rJmg9EwkQz+O6BSo5nfaAZ3XtZV0ZTTjPU83CIkczy2ap4B+uPUnx5Ba+7aly6gzfcP72N8pLLJXmROr4c/fXcZcI/JwPcaq+ME53wwSc5cCOZLxaLSY4hAA8bUFL2ZrXLKrj19vDsLovLsG8KrhlWjamcJepM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qsME22dq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ffkCc4AF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qsME22dq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ffkCc4AF"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5459bfWV006124;
	Mon, 5 May 2025 10:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cI8cYHuWzh536aBKRYQzCS61POnYH0fFmw/zD9qKwEk=; b=
	qsME22dqSi7Z3Ye5Rqqseb1nNuzkzuM6//Qr+ZblTo6ZCqRaHmR4LNwmX1tkSdDP
	SrhVhn1/3/OKBjNw3kL/x/Rxa0lIPSLioG8j2OjTLR/+Rbj2DsdXS3/y5W6VInp5
	Y6ydM5zlB6kHktpMO6stotxM4UzXm61/xyhp5o8328ZWZm2lql2z65gnt5jTl+Y1
	9NMI6gWuxg+xpb+rb7Z9yjPrJe+0hEW0iaZxLmnU6ek3oITU14NlRgqTyTFPA9vd
	Q4fNbSR8GuG4NKliCfeAlKt6iNzwGXH2y1hgCV6yyRAtFNjjH9naDgByxIPBQROd
	+VBdUDRSaeuA6AC9kUOiSg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46etuwg23m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 10:16:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5458oQio037649;
	Mon, 5 May 2025 10:16:36 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17010006.outbound.protection.outlook.com [40.93.6.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k78ph8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 May 2025 10:16:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VB9g+fPglZsnNw52nwnUW8q6KIMqODwZ0aSlUtJuUD5lVHNIJX8jeP6JD2+kNa+aBAie+XF1HBq9qVFCK/xeskluZxUzLaSogvp7wcUps/o+Qq4/pMbUPtA+M/IKEpDQE7fZk0i/jOZ6TJf+qjRh1lN2psu+Ur+XZXO7LwFSBlDOX+bO3uwKll/oFdbtG1/3OazU4zO1Dba4PA1gE1kYxxmzjN8PIRceR+iLauyTu1xd6hponopJKHxc1EhuHpHJnJiR/T5hECA+MV1cYypdfDTN5+/siQgFZKCKuN+Oaj62QDC6KI52rYXbJIAQ1Tzqn6UwhFORF6Oy12czm1fcvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cI8cYHuWzh536aBKRYQzCS61POnYH0fFmw/zD9qKwEk=;
 b=WsyyIQnX0lU2anwOogZmP7ddKrfz4sNHfd2rM3PotdROIVTGw4sry4rd9LdpV87vCBFOytQor4MrkIuGNerYF4ctgmLcZrO2lLVWmtLnmqZ1B2v0FQJ/eYTYStMThYbQYQX8CdIV3RZa9hcj9K2CNSeaWMJHwKCvqPrgyVxOOcAKggbRT5SC4qqXwo1u31niHsGXpKnYJ3QQdhR9qe77JDxypJuH3uAIULdEG1ISG3V9QE6mBI1ISP3bcOhzA3LlgYSb44prN3yaDeT91laNNKFC7jErKk6bCp6B3blZXEOQOUtIeY2CpuYZoCzgmVDrZPn1e1MGmpdj3BKb5W4KCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cI8cYHuWzh536aBKRYQzCS61POnYH0fFmw/zD9qKwEk=;
 b=ffkCc4AFlSfXGyLG9M3aMyTMF+JZtqcTst+jwlnVGt17M+zQGHaDFLQwF5j3fgJWXDs+n2+OWhBbyWOvUzKPhvuTtgb5Lq58WgBHcdLZInYndiBWkLOEVuDJv/P6QvrcCR5qxp8SFxPIyr6fOI8Iltn4TfFg6h2EJb1r/5tIJdo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Mon, 5 May
 2025 10:16:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 10:16:29 +0000
Message-ID: <9f8ea8a1-043e-4e9b-9049-80e3074525dc@oracle.com>
Date: Mon, 5 May 2025 11:16:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: make aha152x depend on !HIGHMEM
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org,
        Hannes Reinecke <hare@suse.de>
References: <20250505081138.3435992-1-hch@lst.de>
 <20250505081138.3435992-2-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250505081138.3435992-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0147.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e523b3e-c97d-4aa8-7671-08dd8bbde665
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjkva2xUdE9STmNTRjgxNkNlT1VaZ1M0K3JKeXNteFNSSU8rSGhRZUFZTEtW?=
 =?utf-8?B?V1ErNjBmYTUvOSsxd2dNZVRqSjgvVFZWV1pFUysvK2lmNHNySEZCdTFFamRZ?=
 =?utf-8?B?a01yK3RUVHVQeWJYckVtN204S25NdVlSVjdzckRKNUFMZjdFTjhmTGg5aEhZ?=
 =?utf-8?B?OHIzR2lyKzRQaXZKZTVXY3FDVk9hZ2RJRTNBRllMVGdtenNoU2l1b3dvdmZD?=
 =?utf-8?B?eGJwUG9MQzJacnpJK2xkdmwySWJuVlJlTFRobFNPNVVuRVBrMWhkakxXMWhW?=
 =?utf-8?B?UGpJMGNUSFhXaytsWE13RVI0ZjFhdzlxbHFhdjV1VXpFekR4UHFBSHJMZVgr?=
 =?utf-8?B?aEpaN1ZnRFJCeEhEbldYclRIOUp2L0tVV010R2lhdFI1aW5nYWYwaElqejk0?=
 =?utf-8?B?NjNuMnZId2xNSWFzbUNVSmdpUlJZeFRWU0d6SmhFdm5XS2o2ZWcxdGsyREVt?=
 =?utf-8?B?cmo0Q0NsM1Zod2IrYXVIUm9UWithV1BQR3BjWENQcDhSWXE2cmFpMytHbkxB?=
 =?utf-8?B?a2FXbWozbmNvVHk5Qjkwd2FXVUthclBOVStkSkNNc3RlODJGa3RHMmF3ZHoz?=
 =?utf-8?B?N3c0QUZoQ2l1clA1L2JjaGVOS25tSHpvWkZqZDcxLzlZbElpZVA4bGYzYTR4?=
 =?utf-8?B?TmpIaEJSS3loMTMvc09hclo1R1NmdmJDYXA2UG54MXczbHY4Z1YvbFhCcVhO?=
 =?utf-8?B?UXc1UHFlSHkyT3RUSUtxdVVEWlN6TlhKUnRIenF3YUZHT3E5LzBJc2syRzV4?=
 =?utf-8?B?L0g4bTBRc0I4MS9XVmVpOFVlWFFUdlczVWVqWmRCQ2d2RFptZWVkdVpHL0Y2?=
 =?utf-8?B?Y0o2Tm85YXlqa1hPdEhkL20zcXJjb1l2VEphbFlad2VRV3VXU2plSFlxaDQ4?=
 =?utf-8?B?cDl6SmNlbStlQmQ0dHN3d3ZENVRSMk9XWTV6cFkvcVJZekwzaXloVjM4VFc1?=
 =?utf-8?B?dFVJbVY2SFlQOUdQb0ExajFINDN2RjBhNE9ZbW8yTEZxK0lMME9yNTJnbGxW?=
 =?utf-8?B?RUc0b0h3OHRpcC9HcWRSTm4wNWlyMFZ6emxGV0lzSVZKelgyYS9MYTB3NVZn?=
 =?utf-8?B?ZEQxNlQwdDNEYkkwckEwZzBDNFNjSUYxcktUR0JHMW93citTeE1MQWN4MWNP?=
 =?utf-8?B?OUtUaDJGYUZuaGh2WllOZ2EwbWhyeXJSTk52aFNZNVNRdGJFVGxudWdqSWpH?=
 =?utf-8?B?dnNiU1hNNEJBZjF4ekJGa0ZmZmZyVTR1YjZYT0Z3MG1USlNzNkdXcVFnRk5C?=
 =?utf-8?B?ZnJ6bEduNEpwekpyMStBTWFGK1BQS3JtT3BrTEJ0N3BNQVRNQy9LNEZEQ3VW?=
 =?utf-8?B?Nkt4akdMNlBqWWVzSXFhWnJUVDl2M0VhZFJ5a1R0c0NrTWhodENnU3hZNWZy?=
 =?utf-8?B?cU9GS09Jc21ybkNaTkhzS2NCdVRnVmZNNTJmbytpby84NnFsSXpsZWtYT2Fy?=
 =?utf-8?B?RkV1d2pEZXBwQzlZSUd1MVA2L2Y5bXl4Ym14NkJEVHF2VVk0WXgvb1drbUdN?=
 =?utf-8?B?alZJaFJOZnd1T0ZwL01oc0g1SHRFQ0tzcUJvSkhxRy9pUUdaaGJUSnN4Sjla?=
 =?utf-8?B?dFNuemxKNkhvTmhiaHBVNXNidGROTisyZDVVN0VvSnp5MTVTSnR6ckNrdlNQ?=
 =?utf-8?B?Z2phbDZPZXhNZFpYRTlFd2FLSkMzdFhaSnZnUlBhakRXL1dLT3krakRyQ2Vn?=
 =?utf-8?B?dnJHcld6U2lKR1h2MmRWbkxzUEpqZFpIdUtTWmNQVlBBSFJkSVFvdkZUYmdY?=
 =?utf-8?B?ZTNYYy8rWk13N2F2VklyZDRaSlFYQ2QrVC84MGJMdHVEWmJGQ2tTMGRNVjdR?=
 =?utf-8?B?VUVnZ1B1bmt2dThyY2Y0dTc1ZVZrOGVlbzdOdXI5YUQwRVFCWTd4VFB3b1NP?=
 =?utf-8?B?Um1zT1Zpb25Kb1VnKzNTendvcWJrSlVBV1crcGdEMm85MDZtRFJpaDRPTkww?=
 =?utf-8?Q?IwzuwCGlyu0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWlEQ0lvTzdmSjJBYXEzcnRRYzVFMjl0ZGFvUlFYVmlBTTJOQlNLeVA5VzJY?=
 =?utf-8?B?SnAyRG1wRktPeUwwZmo4dmlDNnFwaDR1TlJNcFBSUDJUSDI3VVNBWG9ZSWdH?=
 =?utf-8?B?dWNyUU5lQzZmSWdUTll1bU1abW9YUjEycjd3ck5hSmNteVk5TzNkOEU5OEls?=
 =?utf-8?B?UmhlRzlHM3NNck92M2pTa3V1aWxFdzJMUEh0aXIyMlBxTVg3NlZ2SDBXeU5n?=
 =?utf-8?B?RUVqSjRwMzFRU1A5NjBYMUFKTG0xaDNqS3Bhc0J2eFBZVEIvUlBhWHM1Qy9B?=
 =?utf-8?B?ZUhnWldHZjZkZGNkbWVuOUt5MUcxYWJ6c3E1SG5BWGlNV1VrSEcxcmdsN0Uz?=
 =?utf-8?B?Vk9ZejNQM3JvV3ZWQ2xMVk5tR3RWVU5yVzEyVWhvWVQ4ejh6dC9laGpoeDJE?=
 =?utf-8?B?ODVLQXpYTjJrYUp4RWowNFJjbit0T1N4TWtoWDVENkhwRnFERTRGY0VyT1JI?=
 =?utf-8?B?dngyblBZbDlMczhKU0VvbkttdTY0UEZnaUlWNDRBZmFpS1pRVTdBMW1HVzhx?=
 =?utf-8?B?bVJxRXJUMjZnQzh3ZkdCVHpoY3lkWng4R3JvYkc0ZG40clVUam9HM2RUWkpz?=
 =?utf-8?B?ZEYvTllOTzJFUG43MzFNOXV4MXd5LzRpUVdmOFBiSmZNWWg0MzhwRld4YW9T?=
 =?utf-8?B?MlRkQVFpSjVIcWYxY1c3cFVqVmxYYjJqdDZDN01LYzhDZHBmRGE1bzF2b2xa?=
 =?utf-8?B?SGVuQU5jNVBvd04zbXdXZ2MrbEl2TnhVMC9pWk0yd3ZPRVI3eWlzUXhOWVk5?=
 =?utf-8?B?Ym02K3NLeUwxZUgyMVpiNmR6Y1pOUjNqS2lIMkpWNStMbDcwR3pBZk1NR0NO?=
 =?utf-8?B?S095Z3lEVGY4QlAzMjhqUHZFZ2twYWUza0VDZEZkKzd3ZFNnd3g4SlExVFgz?=
 =?utf-8?B?UjN0TEpKem1YZHpEVlFIOEFFbGdrVG4weitCTXhjKzRhYjh1NEpyd2JmNGl1?=
 =?utf-8?B?anpEWGZnQXR0SVNDRVRuVjJNT0x2SU5UbHZDTWZaZU9wLy9lekVzZkdzVFhy?=
 =?utf-8?B?QWVuVzJiclRIckVJWGNoVXdIOHZUQzdYdmFaeWVWTWJ6QUwzczhiSmtJbzdJ?=
 =?utf-8?B?MDBLZDhQVHB1TmlNYVVVblZ2Wnh2Y3ZjWDZ4QTZRb3JJZFcrQjhCbG5SL0Jm?=
 =?utf-8?B?Y0FZRklBR2JUUGpMV3J5SUpzKzN2M3Vtb0ZxZFltNkRhc3kyZ0lESTRyakFN?=
 =?utf-8?B?RE5JaHBMN05xWUs4RFNJSFREN21DeFdPL0RibkZsR3NhNFg4UFRCZVYxeE54?=
 =?utf-8?B?MnFGVlRCS1RwUGU0bmNQczBTWjZWeFdxcnFRWFdQN2JoSjBlZFJvSlhzT2xu?=
 =?utf-8?B?YjNwZ1JWUTYyNkg0RTJNTXp0TGE3NmNDK0d4ZnhhQ1lpeFJNbEhSd2MxMzJk?=
 =?utf-8?B?OENUcXRHRnNZeDNabjdGQWZKUVFvdEh3cW4xZ0c1L1IxMTJMTXhRWWJNWXc5?=
 =?utf-8?B?WkkrQ0JHSE4rN3dBcCs3Q2R5bTlyTHR4WURIQThqV2tjV2RmOGxHRFV1bGR1?=
 =?utf-8?B?OURWS0dxRWJwUHQ0QktMaEdaLzlIc2lJaEN6WExrendJL2hvRjZZcktuNVBI?=
 =?utf-8?B?S0JNU2gyRktwajBKclBsRnk0RHNyK3FqVmJIOTd2eDFnTkVNb0E3dzRhN3Bz?=
 =?utf-8?B?akNvUkJ5Qk9HdmNmNVViWnF0NXIzazlad1lDVFN0RHYzeWhOTFdTQ085VmR3?=
 =?utf-8?B?R0MyaGJ3TG5SK3cxajd4OTB0MHhHaG5QZXNPaDJ5c1dXMW1QcjExMndoaFJ2?=
 =?utf-8?B?QXNLOHE5dzg3Y2RrcGVFaHgxcU9MZS9jNmRiRWFHZkl6ci94S0QraktWSUFL?=
 =?utf-8?B?NEt4bWNBY2x3ekxJZlQ5cU5RcTQwYkk0NnI1TzBocDh0V3RVdjA4cGIxdDlL?=
 =?utf-8?B?d3ZYTUdtY0gxQ0NoTkE2MGNGUXhub1ZYRVFQcVhnSkZlV1AwMTZCUzBYQXRw?=
 =?utf-8?B?WE5CYW1PZGlwbXNLaHhndFYzeVlxeWd5QUcvT1ZXVHF4ODZqNmh6TUYyTnZL?=
 =?utf-8?B?bWRJeDlQSEpVR1hKUXVGaGZ3SUQzWHZqVkdYVFJ4Q2tHSnZicmowTGNKS0RD?=
 =?utf-8?B?bFVxMHROQmpNR1E5WWZ6T2tRemVFNzY0OHFYajJjZ3RQQ0FGdjV0Wk1RSE85?=
 =?utf-8?B?TFVPdXhzUWUzUXQyakhWRXVrS3pKNGw0K2NkR3drZW4vQXBrelNjS2ZQNzNL?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PDcW3TZr56LJi6ykFzw6bEI/NMUowgmVkM9JWQ/iYNvkQpy2sDk1VPE1tqFbJx7yt6RJbYFeN4zZL4f8Vg7LeKRq33iHTH37o7BKWmCFjNP9qbTqE+4uU0fK9ZuJWAXQnnUwSK+pJDxNLoKXqWaLlS4OwtvuTkcvLYa5l0APRilv2y36/F8nSzxBaInfZO+zRtwJdsnyCClhYnwk23mRyGpM5j2A3Srw3KCYN0As8Fgk6/5wezqkm8JWIZsYOXdT4IZrhpyPrfEMKuFGEwMwEN33GSRshC0iYEMxvF7Cwm1MImdseD1o2sIg6xwqHXqd1fqJOFNMMG5lRIT8fvkKj9JEDzM4tHkGTIg4+N+brmgT4fHJqwhJFuJWTPS9j9ii82AfCcPwUj8gyyKwphFO97xFb9NECiNpaO2ct7lQxV9hGTfqJhEXe8X3BoBZIKZH3XCAXnoISBfUcaCqg+yM3jgXK02diJd3rZ8+56bYFRPhSoSw3TLEABzENsAYxCdUDupxHeIzlRJV3mAC7HiRaFP/q/Js8ackSt6a5LOSyJ+aVX3zGJ2rHFvaliiD/lZbN4m9HMQASKVwX28aEmITxbldB+ojtAshkE2kmvEXyn4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e523b3e-c97d-4aa8-7671-08dd8bbde665
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 10:16:28.9784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xDXw2Mt8bYfnxkn/JzWHERE6Lhd6CVOSkv/p+LbYr3Ox+wneuQknhZm+9p1Neo9FNjIv3wSF34xVv5UvFrpRPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_04,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505050097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDA5OCBTYWx0ZWRfX0CqfKShJyOC7 b8k1CIiY+YZ8WnqmBehPQWgke5rBnVz/Wlt6VGs0ti4ruM4hMZsoRdo27HKTIp1/P7Gqrn5MwwW NNZWBZFvGGAqAf3d04AmiNhNijH3IhT21w75n9VfnDkWird8OSKk97VIfSrWsxTTagGliDY/rUF
 6zxexirss+Ba7h01uJ/lsZOJlY7tBikHwlodX0qB2v+yXgNAHObY3tmoRCdSIAUwCX5NLiKAdaw kNokRGoTvgKwA5QRFghhQRCQ1oZce+1xh9N1PTV+Ack7FqWZt6YFae4i0R7Mv6/K4uEvi9Z0aJD BaOaC/DbaHC/bpahPRE37V6DSplGzMqDvXbi7C9rCLvEGsUE0994F6jEEjEO/+P8s3pUhQCTas9
 jjl2eSDOegdWi4HLMPVkW80q7dx++43HaPqgXTnJsq42ZN3n9PepEFN2kmHK0Cts1iR4+OsN
X-Proofpoint-GUID: 1JlfuTz5HwDEWMxOXvArb6uP5OZvwh_b
X-Proofpoint-ORIG-GUID: 1JlfuTz5HwDEWMxOXvArb6uP5OZvwh_b
X-Authority-Analysis: v=2.4 cv=eNgTjGp1 c=1 sm=1 tr=0 ts=68189005 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=_MckG_xjt8bSkswAZlMA:9 a=QEXdDO2ut3YA:10

On 05/05/2025 09:11, Christoph Hellwig wrote:
> This is one of the last drivers depending on the block layer bounce
> buffering code.  Restrict it to run on non-highmem configs so that the
> bounce buffering code can be removed.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Hannes Reinecke<hare@suse.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
