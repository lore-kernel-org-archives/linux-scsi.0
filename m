Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DB92D8390;
	Tue, 25 Nov 2025 09:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764061704; cv=fail; b=YV0iUTbHeAh38y+DSel6BxeNH4lykkucJj/pHLhKXYn/fISHTFlpMCP3fcislx9605+M1DwoIqjY/eAMjHrx6G5eCsNcZY79y9mTYAu1xLfevjmw2o/WjODzBuv/ssv8QNbZh/io6N35IZ5oTY2RJJiXfDuoHrVOzhNLo0+9SIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764061704; c=relaxed/simple;
	bh=a05PVRLG4gZqKEdmRFFjqsdi9zdAkREKqpJZYL9ATWs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O086LelficItvEDvy2fLurlA9+cIyGaxi7GRuaHlW6bdaSMmKffovOlI4iGUn9TN/eU9DKNJzV2IBN9h17AewSyQuYSdtf9JMt1E3lc+b8++B5fOlRv7cvQ9IWlJqAWmdcSGnI3MCucaT7x1/YrNEgEOdIc9bWAUlNDQgbk/6OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ea3Q4seP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PkOBXPdZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ea3Q4seP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PkOBXPdZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AP1Cfrq2342892;
	Tue, 25 Nov 2025 09:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qexi9qj4uf/acMxeaYHnG4YUr2GCaG7apbmgGy/oPRY=; b=
	Ea3Q4sePpSJO6eVwQyl8azXtuUQ1ER7KWCA2gQ1ZhR1ojaRLu1BUJQk+yDEWiep2
	XUbb+3+UfqNFI/vwz888bhFlFvWYZd/7XW4TzHvnjYgfV60byp4BN8rSPRtEIlZ8
	W5sj7iLgdfllcpBONhWO7fQ2f9kE9hMhjambmSpCZV8Zq4MknGR4cLPhFOnEgv7b
	lTKFz0gx4ZqNVYrlxmI4RnQA/IaYc4fOyHC8m9o5XfpxXgfn2C1KhOXTpn7hn5QA
	+2gFItNFwNvJzaUlRh/lJokfnmwteJsViMnBg91I+O/JIMi9O+xXEGXiqObKPqVU
	yQTD4LyT+UB0mJMwc1TO4g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fkc2bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 09:08:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AP8iKcw032651;
	Tue, 25 Nov 2025 09:08:08 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012014.outbound.protection.outlook.com [40.107.200.14])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m96u0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 09:08:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UvCg3cD676byfkXDbmiiIaDYYL63cRA/Za2hLfFE4KQ8oXOAgj+eFsD0z+ww3iVl47BXk9Jee6by+7niO23gPGgnP8CtDZ4ajwY8GaC/ICg5hVx4yLdyfX08P2uP3xHzKDaR+E3PyxETXYP+KBv5JS1eiFzk3oNiKDsfs5hIwnBtludoiJQI+/43SSzCZP4PadJcmZsznQMH51U4xgePAOcXy7wxphzQZxN5r7po22rXaPiEmrfli8WBi8xow49/5ZXhAIkO1lHbTjEH7WxidOIyQcK3aAS8v+YQVxCBhECvXjS2ON55JtpFcD+o6D8Pnd6WPzd0QRbo3PJs91hHeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qexi9qj4uf/acMxeaYHnG4YUr2GCaG7apbmgGy/oPRY=;
 b=iEHWKqZm4bPZtZvKL/TlxJZset5ZLG4LDcJh46lt1zQgkXEh+bV23oqIu1Ag4tCEOHW6xHHSPfCzGxSf90ybVOEZrOa1Jzjj4aIdwN7JBt64Cu28wFzwj3u38lRppLqP6iOsWf41ERkd37jOAU9it88ZpwPimBtubCVmwUL9EZC0TM7SipBOxuBCoiJZ9UJpC+1k48HvZJLYjaPC/bJvAnIgUtAOC7pjdo6n1js07/n/iyb9U4Mdg6dWp95x1eWYr7k3O5FWe4BbuXyDW1eiIUtM7Q5xdIsfaCflvBZz4Z7ClagKnZn/653F+4iQTtbHxrLV7D4nWs9dHYlEez9L9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qexi9qj4uf/acMxeaYHnG4YUr2GCaG7apbmgGy/oPRY=;
 b=PkOBXPdZtzYOqcldkm9Kkj3HLCWtzsCaV7VoT28wnUiv6hJA/G8+bwIVJ1/aqBOQa3/eds/a93L7LQVhWyquboJj4opuZjpUcTC++KibycsmjQ63b2t6BEN+EfANhzW21I7bxFJc1t674pimeAupg+eIeEXV1x9fD4/orQVdn6c=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH2PR10MB4342.namprd10.prod.outlook.com (2603:10b6:610:a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 09:08:06 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9343.011; Tue, 25 Nov 2025
 09:08:06 +0000
Message-ID: <28f63d40-f9c8-4c84-ac3a-9d56eb9b4072@oracle.com>
Date: Tue, 25 Nov 2025 09:08:03 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Increase SCSI IOPS
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, hch@lst.de, dlemoal@kernel.org,
        cassel@kernel.org
References: <20251124182201.737160-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251124182201.737160-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0191.eurprd04.prod.outlook.com
 (2603:10a6:10:28d::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH2PR10MB4342:EE_
X-MS-Office365-Filtering-Correlation-Id: bbac60cf-7850-498a-1411-08de2c022564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkllMWZoSjBxWWhYYzNSZXNSdjErQ3UwZVIwdjNrQVdKaFByN2RYQjNEVUR2?=
 =?utf-8?B?L0o2QkdER3BPbnV3QzY0Vm5NRm5URnNmekRCMFdUbU5aTGUzL2JiMzRGcXlp?=
 =?utf-8?B?Nzlhd1FwdjJUaFN2ejZ0UXpvRmd0cDIwMURBblQ5dnBVR0xNRkJOTm1QaThM?=
 =?utf-8?B?dEpOYTArQTZVUXVyNGcrK1hSWEJwaTFlR1FqVm5BZ0QwSW5McUVMV0ZIbkVv?=
 =?utf-8?B?T2d0WmhveUJFNUlnblpaYks4ZGZWK2tGTzRGM3YzSGQwSnA4ZGNEazNpa3VQ?=
 =?utf-8?B?cnhMbUNjV3V4MnV3Mi94ZjRtL1NabkZHaCtUQkpVL0tETHBQWHNxN01qNDFM?=
 =?utf-8?B?U0lWUi9kZDU4Z3R5VjFzTXJ2N1JmVzdhQ1RSV3czZ0l2TjFHRURzY2FOK0ox?=
 =?utf-8?B?RS9YV3dHRm52UDRPVHJZbXIwTmNxRG5SdENwM0k3cVIwTWFJMXdsZGIvQ3hx?=
 =?utf-8?B?VTNJWWY3L0tkVXhEY0hvUjdGNzhRczZSR2xSMWt2Y1gxT1ZjWWhWbTZHN0Nk?=
 =?utf-8?B?cGZ3eHhZL3hyV2prOVhnb29NRkNNZ1FES1lLazllaEFxckVab3hLZXowU0U2?=
 =?utf-8?B?Wm40Ym53d3VEMHc0c2pVdGtKSi9tbUk2bVpKd2U0UisvYnBQQ3RjMmpPTnJC?=
 =?utf-8?B?SmJMUkwyOVhWVWdYNmUwSGx6TFV5V1BTc3Q1TXVBUVZrWTRWV2M3KzZXYUpL?=
 =?utf-8?B?b2RNNy9wa3BYZXNzOUZiUldRSzgyeFNMdGlvTUdiWGtvZEtxYkpVTjhIMUdI?=
 =?utf-8?B?TjIvdXIrUHBtQThyMUV0M2NlZlFmZGdBM0YycDZ4S3pCT0Z4NmV6dmx2a0dk?=
 =?utf-8?B?T0R6cnE4bGc0WGxkSEpIYVMxVlh0M2U0QlU0M2tOeWE2eHRmdW9nRzJxU0Mw?=
 =?utf-8?B?UHI5dmxnWW45L1hDb0Qva2l3UndNUzlpbjl2SGxGTmc3M01laUd4d1FlSHFk?=
 =?utf-8?B?a3FNQTNMK0ZKeGYwVkE4L09YcVd3cC91Z21PblA1RlFWZHdxNjMrRXYxdVgr?=
 =?utf-8?B?bmt0RERhQWYzRDVvVVpaa2M2MXNvN1pkODE4RHFQWlhQUm1wTUU2THRSSGFT?=
 =?utf-8?B?WHBlbkhwbUpncGZUVk91Y3B2NjZVOUtPTzRTNzJwd0NvTTJQTWswVks3ZFNY?=
 =?utf-8?B?K2s5UWs3L3lqZnJKU05QSzAxd3VLU01kTTEvNGRDOXl3U29IWGdvcG0yeEVz?=
 =?utf-8?B?aGllcmdnR0x2aGlLNGtrTmVTcUkvNUJlSml1Q010cHVaS09tdW1DZnd0YjJr?=
 =?utf-8?B?Q1loUUFJa0xzejRZeXVyK1hWVC8rOC94UzFlcVFKMkVpWGZBZ0txZ0ZxOUIz?=
 =?utf-8?B?SmJzRTkveERNYXNRcmRiY2ZhWXMwaHI4aGhsbGR0V2NRYkpVOGM5NmhIZHVz?=
 =?utf-8?B?dmwvbDdzd092d1gzVldlcXdhK3c1WFQwL0FTR241VXVQQWZzVmRUWXgvcUpv?=
 =?utf-8?B?RVJMS0xrNmpWQ0xSNXVZZ3lNWm42aUhWVGVzTlBhVG8rZEtKZTd6UmZ0RzRM?=
 =?utf-8?B?NEhmSmk2aWVZRjZFODVpc0M1K25qbFcxRm1kY1RZQ0JZRW1VUXIzUHMzanIz?=
 =?utf-8?B?ajVXYml0aHN2anY4eFFwem94MW4wZ2wzeExYOFJORzNhak9lbU1YSmdhN3hD?=
 =?utf-8?B?bkU3OThCTVFMei81SHVpcmVrajVNVGFLaEZSaVhtOG1zdmkrVGVtYWNWTUk2?=
 =?utf-8?B?aTd6QkFydWFNdDNSYVFlSHZmQXVIOHdkVWVRaDhHbXhDZUEvZ3pZK2xyU0ww?=
 =?utf-8?B?ZTE5d1loNGo2UWNUZGhob0pYQk5peTV0UEd2eWZ0V0FSSm50a0JQNFRoSmZ5?=
 =?utf-8?B?VlJySWNIUW5VTkF0QVZVUTg5WW1MS1huWXJOUXNlRjk3Wkg5VTgrVHNMWDJk?=
 =?utf-8?B?c2kyUURKaDFUdHllT1dXUjk5RzhXajZ2R2dQV2NocFR4T1h5VlZhMk41ZFNN?=
 =?utf-8?Q?np798Q/yyBcSd1qG3q+SrWXZnFCwpzl6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEZSU3UyT3BHUUpGNXpuNTFGcmpWMCtabng1QkFTNS9HcmJFblEyQUhDRXZB?=
 =?utf-8?B?bWIvVjY3STh1UG8rZ0JmTnJmUkIwWW8yeHl1YnZzMi9mT3R5elNadHlBdTBG?=
 =?utf-8?B?TXRDNldJODY3b2ZHRzQ2VDh0YzVrL0Q0V3JFV1lWYlpWeVAzNGg3cjhyRkVU?=
 =?utf-8?B?UkpYbVMxZi85SkxYMVNORERGNWMyMzNsOG5SNXZEazdUTkZuTU5qVzB3UGVZ?=
 =?utf-8?B?T2JIaHB0em02TGRJZllmUGU4OHEzbHRuc0Jha29jT2tlRlJiTWprdE1RQWtp?=
 =?utf-8?B?d09JVjc5T3YrcWFNUjBVbnlacUdqTU1OYitSelNGSzRaSjhicFFJQ1hpK1FY?=
 =?utf-8?B?SUpBRDFmcVdMVytKUERhbkhiN25LWHN2bng4TlZyZFJ0WkcrbmpscXd5N0s1?=
 =?utf-8?B?Z3BYZFhHek1VZ1hjQWFseE9YNkorQUlxQWswM1dnNlEzaXZPZ0tZTzREWEti?=
 =?utf-8?B?clZ6MmE0VXZCaSt4akRCWEJtU3Nua3hPV3pTWlBycnBjQ3FraC92Q3lHMDlv?=
 =?utf-8?B?TFhkZWlQN2J5V0xqWHdlY0FJenE5M1BNdjhvbzFrSkp5WGdqdEx2UnI3MjJv?=
 =?utf-8?B?N3pyZGphTzROcDFvVS9FZ05FdWVVSzJWU3JETHpVWUM5RUtEQzVqclUydGx0?=
 =?utf-8?B?VXJxbzlNcTNZbldteFd2akROQ0VXa0JTMDRGSzBMdkJyWmx6eWJlcG5ZcUE2?=
 =?utf-8?B?UHBEd3JUSWtKbFRPa0paUlJXdHc4ZmpDMUVNQzRBVEx5eFZZVnVuak81R015?=
 =?utf-8?B?MEV3UWlIUWR3amZMek11bGFGaHUzeFhzbFhnV1V1cHE1d2NiR3Q2U0FYSHFa?=
 =?utf-8?B?c2xReTNpRWRkMFA3UWZRZ3c0VzlCM1J3cXJYcXBmVmF1Y055ZldEUXFPVy9O?=
 =?utf-8?B?NnkwbHVoaFJKeW0vM3lmVGhpc3Z1TDlmeTBKdG9QNURHbWN4aTJqOTVRQWJ4?=
 =?utf-8?B?QzhlQS9abkhnejkwdDBRMWV5cXJrYTdsT2lNVHFHME5zOTNvYVpiSVpmWW9K?=
 =?utf-8?B?cExDNzFsb1pZL2xYdHlFak12VFRqam5MbWRORUJBWWZ3Z2xITHN6WmQ0UGJJ?=
 =?utf-8?B?SC9xM05FeWZqZFhXUGdXSlZPYXR1dGFlOGd1QVdwbGN3U3FON29wVklNTlN4?=
 =?utf-8?B?RXM0aVk1YTNxMlFsTnBsMHRBdi9HTkp6Z1V6VG9TWDRVVWhhbUJ5a0NTWmo1?=
 =?utf-8?B?ZmM1a3U5eTBON2dsRlNzelRhSzljdld1VjkwSGZicnFOUnluYm5XbFZMZXh4?=
 =?utf-8?B?VldEWHlmSDJjWVpnT25rMGpMUHJHZnZ4Q3MyTkZVRlJsYmVRQTF5RHJEY2RW?=
 =?utf-8?B?YnA2UnpFRmUyUG5rbWJmL3Zsb1g2MFBDaEdGL1NIcUlLSDlxWWNORjQzeDdG?=
 =?utf-8?B?VmdlcG9PYUJNUjljTGRpNnFMNXFoY2RVVG1HeldQcXc2UDFCTHRnQkgrV2NS?=
 =?utf-8?B?ekFUSnoxbE1LOGtKVDh5VTRLRXNPOXA4UmZtYmh2SnlTVFM4QW81S1hKeGkz?=
 =?utf-8?B?QzFpMXdiZWt2QlVtVEFzTlBMaEliOFVjUE12bnMxWXBsVnh4Ulh3Rmlsc0Jx?=
 =?utf-8?B?aG1teExtcyttRFF0Si85YWM0VCtJb2FPa0NpR0MyZTRkM0NCakxMOE03QjdH?=
 =?utf-8?B?alFmZzMyNGdjT3NVdFRSU013L2ZYT1JDUDlPcmZXUGdLMm5GQjUrSEw3eExO?=
 =?utf-8?B?N0g1bEFwR2JqdW1JclZDcG13WnhRcWRXMEowZ0htWnJZYzNmVk9lcU9nQWVl?=
 =?utf-8?B?Nlh2azFSYXBBeHFuKzRJSzU5ZG9ZSlNtZ3poeGh5WjQzVm9jRzU5MjRoMWlu?=
 =?utf-8?B?L0Q1Y2F4ell6RW9jV2I1WlhBZFdhSmU5YzkyRVFPV2hmOGlON2tUeGd0bUov?=
 =?utf-8?B?SG9zTkgvVEtjVXZ2L1QvTDVyM2lyUzM5VkNJYXJVS3dtd0xCb0tzSFFjcjNI?=
 =?utf-8?B?QjJia2wwYUNuTUtCc1loNDVuZGFEQ0VDT3ZKNEdGaU8vSXEvcE01dlpHRksz?=
 =?utf-8?B?bUpWSEdaeFdVN01JQTZ2ZTh1R1NzOGkwbkViTDBraFJHWnRITy9JSVpXRDVk?=
 =?utf-8?B?bEFNQzJjWjRmblVOb2dxMUFyZ2x5T0h0dGlkZHBQbzdlWElQdnI1elFZMy9u?=
 =?utf-8?Q?2G6rmR8pgaXd03aw0hxoVjU1z?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K1asfUyH3FNEdksNbaeXBfjgovCGfhzFhrSjGIKPJWfSrdSXn04i4wEBZpIbo24iFNd3UfKppIwDyBaM/liKaeMRTYjO8Z17+bZ0DHGE1TS3mzyAuP+CCQnBKtNqMORZNNVjfH2k3K9CpZo3d96WWIHPuiQOpRr5b9eEaXoo7qLKn0q8LKITCZlUm7bsrlqzo0L6Q0h9X1vCktEdMcmINEnv0jLlOWJ5LJ3RiNbbQ2mqN97T1EM/EOo9pbsYjhQOmN9HgMN+n0T1qYkvEcVvqc5Ux5saP5P5cNmmp1MSvYOp69+d0ojtYX7w3MlVy0FVM+0rBp+7bCbTZwdwnwrbNwaT7Ovz+XLKsaQpz5vtYDskjz38I06fROoS3SrbGHYheH/18LsWQjdvJnRTahujEu1Jbwvd+qk3KdAAkXL2ylcTMkubZVR5u/QWFBxjO1fmZ7AycOocq7M4Br+qu9JpY4WPZGGVKQgLml4qjSgm1wKfycUUZTtzfAFagV+f32Teo4RCxGhMV/VCqYfSbvC+y/pEq1L5GDqxg3YSDwdfWXxkmtES4k/fsCs4g6S6ljtW1j8BsOYU9+Svc8Iti+mAjctA/BMi7htsYNiSlABMQE8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbac60cf-7850-498a-1411-08de2c022564
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 09:08:06.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOZiog6RUrUY1mtxFZIVo2ffvTAL7CVA30NI3oNbepPrGw0Y5Zz0oWZPpjsDH6jnphNl9yZKZ835z791dMpVoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511250073
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=692571f9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FrEzGMS24_3efXhvvTkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDA3MyBTYWx0ZWRfX3snL+TNvmGZZ
 lFWIoyHX8c/b+w07ib4h1VI30lJ+o/cez1I6iXg3veedLLNoQImN8lG0ZDUd+lTugOIW+0AGDKu
 1ntqRBwtSAsNqXF5H00MMsm+gehnZp7u3LvNkCL1HKU99Spaj3ayyyG3ywfqcmjMUQl3wjW0aiW
 LvsW4NpbGMoG3p4o7UU3F+rHVWkGazgMIycXeiaTFx++pV+u0W8R4J8yGtnc0E1YDeNNRui8dPk
 7VBAV5junHVzyu9dCbxRb+4qdM/CSr2OjO9HmLZRusDiCJhfU0a7RZF/dASI8Y30jsE+BrWBmyw
 VoP+puN/bLTo4YZfZG+9mehKcWULLXNBMMXOrjboRLNx7RBBMDRD9amJ9PeC/CLrHOTxi5brOOR
 fQMnJV7LUUft6TEtae+y9SrJF1VvDg==
X-Proofpoint-ORIG-GUID: CobY3d8gpiW6JPQk9FkV6NGUumrkcfn7
X-Proofpoint-GUID: CobY3d8gpiW6JPQk9FkV6NGUumrkcfn7

On 24/11/2025 18:21, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series increases scsi_debug IOPS by 5% on my test setup by disabling
> SCSI budget management if it is not needed.

Performance results from scsi_debug are not a real acid test.

> This patch series improves the
> performance of many SCSI LLDs, including the UFS and ATA drivers.

Please provide results from real HW / real scenarios.

> 
> Please consider this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> Changes compared to v1:
>   - Fixed a hang during LUN scanning for ATA devices.
> 
> Bart Van Assche (5):
>    block: Introduce __blk_mq_tagset_iter()
>    block: Introduce blk_mq_tagset_iter()
>    libata: Stop using cmd->budget_token
>    scsi: core: Generalize scsi_device_busy()
>    scsi: core: Improve IOPS in case of host-wide tags
> 
>   block/blk-mq-tag.c         | 51 ++++++++++++++++++++++++++++----------
>   drivers/ata/libata-scsi.c  | 18 +++++---------
>   drivers/scsi/scsi.c        |  6 ++---
>   drivers/scsi/scsi_lib.c    | 38 ++++++++++++++++++++++++++++
>   drivers/scsi/scsi_scan.c   | 18 +++++++++++++-
>   include/linux/blk-mq.h     |  2 ++
>   include/scsi/scsi_device.h |  5 +---
>   7 files changed, 104 insertions(+), 34 deletions(-)
> 

