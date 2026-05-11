Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0EE3845C1;
	Mon, 11 May 2026 07:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484677; cv=fail; b=qoVVcHTJMQgWobsAfqyhtY8MOPHKK/YhqUVnS3jmjDo5EJe0Xchh7hLRd2Rks/9zK10rhOGNPPv2Cz6UTfbcaYrDq0PHfwneMCns0LbUKFMFvvBO7jmIub7pHE20RFnp9G0Ym3XcYqda+4GyCmP0SM1vKSdMY6LxuiA1y7qG8io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484677; c=relaxed/simple;
	bh=9yMt1Cabo3xv4lYucjUA8wb3uwprNZzHGDa4vZ73/Sc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bPEf9DXSzQQgnbVmi3+4k6X0I9DiXs72rMbVK5gurnAO2ELKFdZ0o2ehE7aDyUuZa9JbHM4o4MWP3WbRbQ+loWA6XklHw+YYuAMq6F7gQuDMTAwsbncWPXFMPApFjVlHnUwVboq/YfwdVajBKZ4C3aTA4NjRimwbeCd12MAd8oY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LhLMIJEL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p8OQjVPA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LhLMIJEL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p8OQjVPA"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ANgQdd2174121;
	Mon, 11 May 2026 07:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KQjQM0X+zI5JOkX5PhcHx6DrIS6fJ4A1JbzWxQfaIDw=; b=
	LhLMIJELBkOpaPer4slAoj17h/Xh5nx0/Qs0gkWYqBEvfIiMPhUJpasQxfmuNPBj
	XOnxKPIyEk25t7uUETCAPoVix5rhg7GEKgBuJghjaxzaYJFNVKeOiOcGm/zTa02Q
	4j+sQlaD7R5esf4qcB/vlZD1o4S9hPqwUa4Lt7E755bGsyEwUWmRSaGsraY5YANJ
	+BdwjRrNboOX5yqEs/oWLP9FqCx2g1qEPE1JvEUfXKkgxy2xdlE29bJfFfGAK9R2
	ZQzpuEDnCnEjO4PlTSATZeyjQGM2GpSxqejxuRfI4ivVMsSKX3R/vw5YZahwYNXo
	ng2hbBZcvoSUdF85kbXA7A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e1uq521t7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 07:30:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64B7QEuZ005450;
	Mon, 11 May 2026 07:30:43 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010040.outbound.protection.outlook.com [40.93.198.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e1uc8vawq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 07:30:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HqiYQ+WtrzWEPkuMOuOg9CUXtag4/QQsNAk+0xhX4LeYmgYOQPSJuw4cOHFBF6zlPnK9rJ6D5uYkk/Wdia6Du88+fMZtE5URBHLptWTJSYfVIrS1qXcMgeCdl1GTMNDIhNDMyEYYfkFJit9fB9jskB+4EbD8Ul7VPEoNA8Q8gcnaKadyj/pS8kqJNdr8CNs6BFalz60QcUzn6/0YCBez1t6uWzZPIt00/MaU6dXmTp/aR2tZ7asHe8WQh1uLt4/jdYA34TeuEi+SRJxND1r0Gc8r0S8yIe6JwWLUiB1g9qrVFZIjI/l1mUU5aq98I7KsqAIFglqkLGhn93EZKguF9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQjQM0X+zI5JOkX5PhcHx6DrIS6fJ4A1JbzWxQfaIDw=;
 b=NLimDIny7zMQgLp88zJL1cuzlXv22EBqJZd2itWaIYnAL+v8AKogEqQhEd5yLyDmRf/607gZWzGxFfozyCF0Q49xYD/icaoNuIQFnnJY2z12n4z1GZ7O7ECCFkfNlDEcUmSpEmeTcZnFNrzwLEXFs3KU8HnZ0B+6r/oyKHY0RfUn5SFcAD1n51JxwDIt25yIFLV6Vkt5uAzVWElOSArxMdjJXCKd5xDwS6XXUjFPQ1wOYbe0mvIAeQCGqDTepYGAEiuch0+sqsq8NMeGLnkKEO2o5YADCkSmkFWhJhpTRm9afAWKz6wf/weuB/VLt0XX8XOuE0u7dm8u9tb9drng2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQjQM0X+zI5JOkX5PhcHx6DrIS6fJ4A1JbzWxQfaIDw=;
 b=p8OQjVPAwsPJ4laacIhUA8H+/tdzHBksaOzJGhgLzNoIF38pjLJSQ8ScROaKjI+5ah8EOOrcsiOvQvl6bDuASd/3U258/V05iFlLwrMX/DoZpsK6Zzo66Smf7h758VH5kJl8WxYdtPoIY+07BLrQ6hvbz8Ung2cy8CDn/MBiSnM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA6PR10MB997683.namprd10.prod.outlook.com
 (2603:10b6:208:5df::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Mon, 11 May
 2026 07:30:40 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.20.9891.021; Mon, 11 May 2026
 07:30:40 +0000
Message-ID: <5acabc13-2c84-4881-b151-d82bfcaaf8c7@oracle.com>
Date: Mon, 11 May 2026 08:30:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] libmultipath: a generic multipath lib for block
 drivers
To: Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, kbusch@kernel.org,
        axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
 <ad0a1191-4928-4700-8c55-4c844a7058e3@grimberg.me>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ad0a1191-4928-4700-8c55-4c844a7058e3@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0348.eurprd04.prod.outlook.com
 (2603:10a6:10:2b4::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA6PR10MB997683:EE_
X-MS-Office365-Filtering-Correlation-Id: 9835f62b-531a-47c3-2316-08deaf2f33d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	S/yonPeNyQbzx6962PeQvryV9pFp6iu3vsZITWpuO0LRsCWDlQovZRbzIAXQCP4u85pOR8ssh4YF2g4qCFH+9/KLBWnU7/0llvV5jTowFvFsBRVwGIjS0jawc3NeVPYpz/mxPX0uwMuYtAlQ1evWEy1QMjW2IFwGiGV/hDcR+oZPYD7Pot7CEpSCD5Hc5CXdmI5+c5Ox0BlRDZJILjvLxLyRTzi/L8dojCBNwvSqx6OmLTgiZ62xLGk2iW/JdcWsIjyOzl15L7RjrjhCouwEfRdCuO4vRA0ay/+AD9xddywEqUhe18dTK2n9mr2Ykr6UR82btlbY5ZfkIdmZc8jmo7UQ5KTN02oewAHurrrjo9pi65OeG4eoAY4fcpCTKaMUKvtFkyHIwTnJxnW2ORT2wYzQtsDJ0DntO193qfb3NxbN5Md7w3VIC6yRMDEQWUTQeZSHDXXls00Yh5d0IO5espy7te/VZoil8GOpXQu3xIwHbjRrFbbfpYDqkMlSU3fxpuL/0sXH69IhyM/V8DOcEZSbnTVMnTqu2fcCp8YAWw4Igt1OEFBMzw1WvbEo1djm4S6kaSfha97OJ8eyLPX6TFEeUlCCCw3jKulDD21FG77khELtxFG081qsQfKmFoIMXSGxqc6QrtqpJJQPekR7hGdCg4oI5RjtTjGkKCx7cB8HAdjs01P/rZlV1GATChgK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aC9xbFNhd2hBM09wY0NSZmJqRmlIM3ROeXk4K09BNnJQUUhIM0N3c3ZWbUZO?=
 =?utf-8?B?YkxHeHhkbEZTcm5rdEJwZEsvTE5MMkt0TGRaUTgySmlMRFZXeDFWeFl1T3pY?=
 =?utf-8?B?K1AxRlNEOWVQM2VIaDZmejZYVEpZdjhBdzdNblYxTXFxK0YwUklEWWNTdTI3?=
 =?utf-8?B?YnVEOWpEZW5TK0tHQUlDREIrOENtUDREdUkrOEtqMkVJdVY1SjAxc3VNbUE4?=
 =?utf-8?B?OTBKU0FJNHozVGRkcDVxeUYvdjBqZ3o0ZERSZ3A2dVpmczRaaysyWG9UQlha?=
 =?utf-8?B?R3U3dWk3d01pSVVnVXhjR2dmK3p1a25PV1gydUZ6V3kvS0xTVWlueWxSZk4w?=
 =?utf-8?B?QldBd1hZdTBOM2hBTGtUQllXMS9NRi9PT2h1SWUyeXhrV2ZiY3BSYy9ZeG82?=
 =?utf-8?B?N0lRZnVoYmVUa1lHTnpRQ1g1Mzh3YkY4Y05WRkdWaTI0UUlvWXd6aUFRQ2x0?=
 =?utf-8?B?VjRrTzZaaTd1NTdtVi9NeFZrdXovNkJkTVVmekM3L0g0V1l2RXVxelgva2My?=
 =?utf-8?B?cUhPZUxFL1g3WlRRVDdXYTZJOEZMWVlaVHlqMFg1NllENTZCMk9qZzZxN2lQ?=
 =?utf-8?B?QWpCd0M3amNYRjFFcGZWTkZwS1A0dHdpWTluMmlJVDljUktSUnpUcWNWcjZH?=
 =?utf-8?B?R1RrTm8zNk13UmRMYVp6ZE5mRXNjMnZvK0ZueURnYXpnRUYvR3dVNHhlRXVw?=
 =?utf-8?B?NXIxZDc0c1l2d1RIcEg5dzdHQ3RyT2xmS2YrVCtTaEpjcUxwZVNyY095UjBE?=
 =?utf-8?B?RHFQS0p5WlQ2L29NVVRHcmsvS0IyVVZPWnYrMG4wZnVOaUlQS0srZWJrU2hv?=
 =?utf-8?B?dCtJY1B3TnZ3TGhxRkRSeXVNa2E2dE9pWGdtdEErR2pUamJibzlxa282OUtR?=
 =?utf-8?B?QjJDM2w5T1RZMENZamRnSm1LV0FHeTdpU1hNK0ltcWVzbTNxUXBMQ3lZUXl0?=
 =?utf-8?B?aWZiUFFkdkZNUUpmeXpaOGd4QkdJQ1FxMENMR1FQelI3ZmJoV3pMOEx1TFhT?=
 =?utf-8?B?NWs2aGVlOEJ4QlpWaGtnQnovVnpvMmIwY2tPZ2NuVUhwWWZaWTVvT3lDbXVX?=
 =?utf-8?B?NHF0YXUxRER3cGRTZjhzSGZXMWV5aG43RzlGZXJsTG9pWnp1ZUJQZTVFU0xV?=
 =?utf-8?B?VHgyeThJNEpkZW41aU1vU1pscVU1WDZPNzlTQUhHVGFYUGJNUXNjcHBOT0hV?=
 =?utf-8?B?QlNrMk1ZTG5LTytvVUJXMy8yWVpFYVNZcThaQzFucnpBaGNNMzlCWFFRZFN0?=
 =?utf-8?B?VVNNOExFMFptUGtzTDdGRmUrODc1a3cvbEcva2Z0aG5Qcy9iRVh4WWVRZWFF?=
 =?utf-8?B?NlRUeTFabkhiZ1hsUzc1SEVMUFAyRG84MHN6MGtUWXhIUjY4YWpIMnZTYktF?=
 =?utf-8?B?d0FqVGxkWFZjRnI4YzNRUXdFRTlPUXVvWVp1ODBpR3Q2VVZvVlYyem05T3BL?=
 =?utf-8?B?TEtYOHF5WmhUTXFwb3RXZzNkS016QmlyeFR0ZlVwL0tXcEZoa2JvTkZ3UGdS?=
 =?utf-8?B?a2lrcVZKTExoMk1IUy95dk5tMnUwNE1Ec0tkWkF6N04zTGhxQzZrZDBWUlR4?=
 =?utf-8?B?TkI5YjRvajQzbTZOMWsza21sZE16SkFVWTQ3cVNpa2l6UDBGclhOcnY2aDFG?=
 =?utf-8?B?SWE3N2tuaDhKTDRVZ3BHUEc5WHJtWFFuamxna2JmWFdvMTM0bTZXU0MzajBJ?=
 =?utf-8?B?TlUrSHRoTmNxcC84ZXFLVVdpcVZtbmNMUmtBSWVLdWU0Z2wvMXFJdzRPaU1D?=
 =?utf-8?B?azJpTUVVSXZncWwyTk8xd1YwNE51Q0hhQmRSblltSWh1NkVyZ0FaalJOaFVH?=
 =?utf-8?B?SnViOEEySFZZYzI5S3VWRkxTaEFEb1BWZWVYVWllam9GSm1iZGwybXo2cExU?=
 =?utf-8?B?OWIwd21CQzVyQ25SWjRRRElsd0pGcGQzUDcxYWtsSEdmN2xMdm16ampHaWNN?=
 =?utf-8?B?NWZ5MStDa05wU0hZNDNQY2NUeWFvV3Iza2tjZzFuUldCZCs5ZlJwSUJNMVVE?=
 =?utf-8?B?UWNkOTVxVS95anNDK1dxaGdYZzM1a3pUYklPR01DRmJUQzJaZHl5YkxEaTdN?=
 =?utf-8?B?REZMV0tyWTdseWQ4RWNLazJwbEZMWm1qRDZxWVkyeHFYVWdWRW5DVkowOEdD?=
 =?utf-8?B?VFdEY21BYXplUGFVNk5tMUdPUE91U1loQ29DbUJqaGJhK0RFc0NqWk9VMlVt?=
 =?utf-8?B?aVF6NlJoek1OaUF1L2hyS3FGeEkxS2hyYzlOTVgxNEswZ0w2Qjk5RmIyYVhq?=
 =?utf-8?B?cG9vTXVqajVVRkhqTkRhTWJxemd0ZTNzWUpUbm9XWHVPVE0vSlBzNVM0eEI2?=
 =?utf-8?B?MzFhSWt0L2owVlc0TGpWQm1qYWM4dERhUVo1aDB6alVmam9vNm1FQT09?=
X-Exchange-RoutingPolicyChecked:
	wV9RpC5o5vynHej1XoxQQCPP6TlaG0wquJEf57xAJZvXzN5fZp4WChtlwRiH6k0xZ12z8PDA32H0DhepUxN98LmxFg8nNc1i0yv8FHTAL9S+w7XUErVIRXOsQlycu5mLskIC3UHzbDziNxfhdUJBXQ+2NPx2m8y+kFM53Ay19Ye7cccTCY6wDAFUFb9QEoK01YfWhwz8GFo2pXbjTiHvCd9opbL1n66hCYL6RxMFd5zzQaDaTfCg+bMNxLZbzSohc6CxxREUwt76Zjm4rmj0Dcdd0u5yFmViYORVcWWzmwAKZz19QKQhljjFuiFep/xeTlsFw96EyeZ9JIiohVHNHg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XNa9zPHEmWbiIIt5BdO89RwDsSic2ci/e4GXfNNvm2i6srzfJAcLOn3WrruAE3VRlaw23qiDWsIqWRun7rnf/zDmb3kfROjL2nra0+TjR7DtrVXKmOquEbq+s4iJ846QmEPZjo7zzaqlvO9zRYbCcTElJwhhzt7gQu0QcR4xU9Er0JTbVzTPEVUUVhY7aMwDeokTte2IAjCeKE00CkQgAhjTWZcI2g5jRxhEeYsgRP5eI1BRo8RJK7Wv+vodlMlE+lpJfgRctAkwelnXfitULhoVeSuVsyt9lgpSkvq/KYB61PJOMr8fH0Z7jKadNQLTOb/kN2GZJ785wVdkqCsT9TDO6ZjtOG2FxNYobc/cv9fzib5U0C4IeBz1koYo6S10ja36lOYLpLQkuwo25Jm5leWhvzAEvCKF3V+hmxarpI46p3MZfFDUyY9wgzbu4joKGMDzBnODL7Bhz4S8jebXR/pM4bweJzarqTJoGs6GWtVQIbSHH6d2ReQLHOpvNfWyn8cj0WqZL7Vovcus8utRmfvRT4+tVpQQvsDed4ILO0np8LEcbqsAA95+44PBg5OTGss3UMKcuBcsQRuUVjTvzkmurytUpzU/QveMtyKI/A0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9835f62b-531a-47c3-2316-08deaf2f33d5
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 07:30:40.4681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVAkBYMxSDYknSNdTf9tTxMSEHEmui/rNXCfpavutGag1RJGhoZH+Qhl2mIJWKawWVpmyzxsWHdN8B4F8aZLlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR10MB997683
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=870 spamscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2605110081
X-Proofpoint-ORIG-GUID: B0XBRDH36OJq-jS6GBo-mUoV2hDoBZ98
X-Proofpoint-GUID: B0XBRDH36OJq-jS6GBo-mUoV2hDoBZ98
X-Authority-Analysis: v=2.4 cv=NrrhtcdJ c=1 sm=1 tr=0 ts=6a0185a4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=sKyGE1fn2-_buRAmUNwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDA4MiBTYWx0ZWRfXygLu6blH0vZD
 rKMQiXtG4wrnwuUwRXOk1smH5I/GV6W1R/0dt7LrvQI7Cj3XG+npFY876qGx/ybYF7IO3qyWSbC
 12d2xPgQsbKZFJSsomroqmsdxQGTNynfYrWV9qotBE+qRjwebHZW4syvqvA44/x7V1owKyqqqdG
 rcgwLKte933L5Szm7UhK/K30NWDGNDAM/cV+2nZ6ahlJNO6QoAkeasGBlYOrzw4UiVWqmZAD2dx
 kYO326mLIPmlKH1XFbLr2586LEd+nbLcbLlKrnp1pABPFunhC0Tgxn3nRJMaef4z0wXUT+gle5r
 jFnk+GbTvm+h2/368n8iB6XGv20P0dpZMxdE2Te9+hSK1IqnVqmHXXlItAMQJGxnk4ScXhqyfPp
 vjSCFDA+VW1w0aHi1AZPuWwsLjh+a64xfeUQchrBoct23foVRb5DnKnHTCOGeZ7lLVEJUhumyiI
 ypaW6uoqN8hvAw3iR4w==

On 10/05/2026 23:03, Sagi Grimberg wrote:
>> Important new structures introduced include:
>>
>> - mpath_head
>> These contain much of the multipath-specific functionality from
>> nvme_ns_head, including a pointer to the gendisk structure and
>> a path SRCU-based array.
> 
> I think it should be placed first in its parent struct as it holds the 
> hot-path
> head->srcu and head->list.
>

Yeah, I did originally try this. However it becomes a pain for managing 
the lifecycle of the mpath_head and nvme_ns_head/scsi_mpath_head 
structures, especially for the scenarios like the delayed head removal.

However I can see again if I can make it work.

>>
>> - mpath_device
>> This is the per-path structure, and contains much the same
>> multipath-specific functionality in nvme_ns
>>
>> libmultipath provides functionality for path management, path selection,
>> data path, and failover handling.
>>
>> Since the NVMe driver has some code in the sysfs and ioctl handling
>> which iterate all multipath NSes, functions like mpath_call_for_device()
>> are added to do the same per-path iteration.
> 
> very nice, overall seems fairly straight forward.

thanks a lot
