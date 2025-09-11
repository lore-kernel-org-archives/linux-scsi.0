Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359162E54B6;
	Thu, 11 Sep 2025 08:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757578535; cv=fail; b=YSYklm7vezqIBu5ZFY/rrgdbCfdqxIpLfm2tZEpr1XBNKsx6WvQWYAJDFQoB0aa4Oek8P8G6ZTtbgsTNx43MdYaTbxSclWAu9zLS9v1hy/Cxd/aH5htGNFX9t0ZPJX5DL1WwxKvRI9OeMFvQqWmLMNzDpSPRDsJyo8eE2u9MfW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757578535; c=relaxed/simple;
	bh=7+cI6TrE6tYMbrNfOjOBxyFDibB7FVjogFV7x7VA5mw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R4Wl5r6TFgTnLASR9bHj5sOk6edx2eQ6NNkl8rNfjNDBeDHSRWy7n/6lwCURYs7cu49YjMSHDXQGTmyvWLXZj4+6oJqiXKLyfcxyctg8co54OW/T2NUh49W0MznEJkO8uJc0hzt8v+Cv3LcF/hknssad2lYp5rjukD5fNo2liJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o9lGr6Ok; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BaKPwuwC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o9lGr6Ok";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BaKPwuwC"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7thqH027597;
	Thu, 11 Sep 2025 08:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZAx0uA3/sUNdeB8wvrmYnfDG5nyYzOwCOv095zntdjw=; b=
	o9lGr6OkzHHOlRBJTFqFzrzl6JcdHQaG9gxkZnWQSBndOhA6MgxobSmxUuuh2X87
	V0fXoh+/y6Wb/GjllTmU6CDH0gngY3ueoeAZqzAE3K0u9pVfBCUvCvr4tTWrPLBz
	V2jpxA56TDUoAsQJ4H/DquLdO6jQ4bLRghK3626bylc3h2JjL71eAeSJbkUtba6a
	E2JMP112Jw9lmMqF3Sonid2bQ8pyhA7Wt9lFPsY/G+mVYah1KWBc1Lx47DpNmci8
	zqDLOJlaVpgoBl2R/UvtOOJPkwUi2rWbk2DcY6chq8rgyccdeOcehJllq/oRFdWd
	a1q/XYjYryIXWh+/nUs2Fw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shwp1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:15:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7ZipB002770;
	Thu, 11 Sep 2025 08:15:20 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011006.outbound.protection.outlook.com [52.101.52.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdjnjk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:15:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQb3fmT4DfsTHgG3ltSdtdSkzlinOO8PMZs8umau/NDbVGjn03H91vnCNjwpcfxXyMyimoqruXwU45Om5cCPohW7ln/1dDWHSMz98DIYjrWCjWOVbC+foKqCmz7Y2NHDXsMC+a7oqxG1610FTk6dfjXcWY4v+RejpChckGnMro4vzUYA2YW7PUc8taQo0/QpXi27hZR2L5v86R5K5mjxzPSk2qFb6rfgvdgfbkcatojEdmZlVK9IYenoEPUGGratZWy4qg96YfLsVjATMw08kvkr5z7kGXYrZbdOBhsPx6h6SHnmCHPFEZJmKmhxWjGOLOEJK3WFi4vqebrRLdI35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAx0uA3/sUNdeB8wvrmYnfDG5nyYzOwCOv095zntdjw=;
 b=ERo5jfWyKb5QlyjxJWDWSp98pTXDHcjtnIhCDcwe75sFbir6oyS+BLtsNBtBxZZyc5Hag1IUzCKQMaxhWBQnKjUcvRgiWjFk4kF/+bwbp5yp45+aTy/aGn8e8f7TqqgucLWwmsj+C4bYIU+idB7t7k8b8btqyZYfCkLlBhQGonv3nVLnPUpyordynI4DKcFr5XOC3AiU6d728oNitwJmLhYDIhiF+ECkyyVomZZlzGBleu2ggnG0j6Yiq0cczj51rjmKG6oHeVNEvNRPlj4ru5dnaiE9zv8hbOAyY2zr53eMvv/RnPQV/Y2qr53DkWzfknpeCP5g23q6Rfq1ur4i1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAx0uA3/sUNdeB8wvrmYnfDG5nyYzOwCOv095zntdjw=;
 b=BaKPwuwC+UHw3tBFaetwZAWZg7h7V7xIXGbFoxJzJLhWudBLWhk+v8VPCztfrrDPowDHKoVbkErQLR+kpN3WThdz3nKmZinpuRqmR1yROJOuFOK4BSv+cWrrN9GH2qj5b5FPF23HDEbf1heqtjEB7mfrhA1fg1ORZDTF+FtTiAw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN6PR10MB8070.namprd10.prod.outlook.com (2603:10b6:208:4fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 08:15:17 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 08:15:16 +0000
Message-ID: <a28d07ef-34a9-41ed-bd4b-ddcbf3de13f4@oracle.com>
Date: Thu, 11 Sep 2025 09:15:13 +0100
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250910213254.1215318-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0294.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::7) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN6PR10MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: acf0c7a7-6116-418d-7387-08ddf10b5703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjhuUlo5VStMc3hyeTNHZjk5ZEpKRTNEWE55SUgwUUtGY2xJZWt6STZBRGc5?=
 =?utf-8?B?OStuQUxZR2Y0Z0kwUW5SaUNOSDBXTGFiazhzdEk0Ukx0Y3JLVWVQVE9Za1Ux?=
 =?utf-8?B?YW1CbkR2YktwTFZQaGVkMERENWR3ajlpczRCdnV1alYxY3pxTlVNMzN2ZXN5?=
 =?utf-8?B?SDdrNDA5alo2QjdVVDdSUGYzNG9hUExCZGdObU80QTBhYnZPN203ZVlic05N?=
 =?utf-8?B?cjNVV0FCek5uT1ZodGhQK3JXZzhpNDg1eHNUQTdOUjd1VGxoZlp6NzAzZVBq?=
 =?utf-8?B?NnUxbXdDK1NwODczR3MyZ00vcE1IWGRSVmlpaXpRVTdZSml0VmRUTGE0amUx?=
 =?utf-8?B?OFFNNUlVVjZnWGI1bXQxMmNGNVYwRWVpdHh3elFVeWdUOXFCYjVKdnRzeXQv?=
 =?utf-8?B?L0VnQmpUVEoza0dMaU1rc2s4STk0RkdUMnZqTEJQcUhWZDIycm5XZEtubXNT?=
 =?utf-8?B?R1UzQTZoKzNhbTJNY1FWbTNvWGFQQTB1enEwcnRvTTQ5aG9ONVZlcmcxaXhs?=
 =?utf-8?B?U3ZzcDRvOVRZSHl1Nkl2Q3RIY3Z1WGJYbVAvT2FKWjF0Z0diSkxwTlVOd21U?=
 =?utf-8?B?aFdaNEtPL2JUWnkzREt1N3cvTEhyMW96OWNaaktFdVdYZjZhNjJSZHJ2eEVk?=
 =?utf-8?B?UmNzTmU4ZmkvT1psaXRTcW1uWk52ZmZ4SDZWVFU4ejJKdVBUNm9FWmZBb2JD?=
 =?utf-8?B?ZDl5VERnSGRFSFpha29YSzVyRjBhUVpocHpvVHZHRmxyYysxTVBmWU5Icm5L?=
 =?utf-8?B?VjF5ajVpcEV5V1k3ZlBSemtjbFpUU25KWUVhc1l0cGpPcXRKZk9YeUc1a3Nr?=
 =?utf-8?B?WU9YbWltQUttTGVIMUNxcm1iMHlpd1N6UHFiTEs3d3hYZE5uSEZIMFFkWm1v?=
 =?utf-8?B?enEyQTVneDR1K3dlRXB1M0tJRXE3RjhSM3dEK3FZMXBLMW9BcXVRTTFPdVBk?=
 =?utf-8?B?S20wemNMLzgvR3R0S3JXNHQxVE1XK2lYMmhRTDFzc2UzbXVhUTFEdjFjeFJW?=
 =?utf-8?B?ZGhGdTRMQmRmaEJDZ1NOaVZwNThXbXJWb29IWHZvOUpDUVY4TWhQbXFqQUE5?=
 =?utf-8?B?TFlpVzFlK3RHSElYVGEyanRxSVlSTWQvT3Q1T3UrZWxyZmhpMTBMbzhoNktD?=
 =?utf-8?B?ek9uWjRCV2lvcWVIeVJpZ2k0TGZJekVkVW9IVm80dU5qOUttSExheFZLbUxV?=
 =?utf-8?B?dWZWcHFTK2hveGwvTjZqNGl2UThvWmUrcXNzNHkrU3ZIT0luMURhTWlNUTc4?=
 =?utf-8?B?YkovT1llVXBIUTNVQ05zUEt4QitmUXk5OFN3VTZaT2JNaXMzSjR5TktlS0Vn?=
 =?utf-8?B?bXZNb2FtSnZIUjVWdVhrREs3UDJSeHJLeGZldnhabXVqN054UzdQSHRiRFZN?=
 =?utf-8?B?STViaWZnbitVck55ZVQ5ZEFRMXdCcGxFMWgza0xMT0VMbE03dVdlczR2ZHda?=
 =?utf-8?B?SVIwN1FCSHhSaGhLWTRWY3Bud1hIaEVCWTV5dHY4OFdBQTd2d2tzMnZPbTZP?=
 =?utf-8?B?L0d0cmM0S1lhWDZHVnc1dFJ3K3JRZlFmM3d6b2xpM1pWWUROKzlFMGFvZTVS?=
 =?utf-8?B?eTJKUUJCMTJrV1lRdzF3cEhVak9ldUczRzBjWEJEK2dGLzRmbkpleUlBcDV4?=
 =?utf-8?B?Qm1EZlBIc2JGVkltOWkrVnRnYURhTHkvMXlrZlpkSW1IblgxeGNkWFJ3eU1z?=
 =?utf-8?B?ZW5UZHlNODdiMUhUakJ6bm55bUV4REhvdjNDVVEyOFgwS3ZpRlo0azVZYWNH?=
 =?utf-8?B?UzJxMExOSFZJVExremZ3UnkvNVV2QTlFNFNzUlY2K0djOVNIMWFqZDl3elRt?=
 =?utf-8?B?bnlqMnJMOW9RdEtSRGRXYmN3NVBiaFhZN1dXWjczdzBPUUpKb0t2SnhQSEJy?=
 =?utf-8?B?aFY5dGw0K3FhVlZJQjgyWlRYcEwwbitNeDJuN0Y5L3N1ZmRiZ0ZXb1lTY0VR?=
 =?utf-8?Q?ovgMGlEvZzM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkhoeFBzcWlpTUNBVGlNWVFtejArWWErT0RRSzg3VVV1ZlFCL1lMNW9ERnJr?=
 =?utf-8?B?Y3AwZ0lyL053b2VHWHN5ZUl3emd0eVFoTWFqOTN6ODVHZmZKRFJwWjc0aTlJ?=
 =?utf-8?B?R29MT2k5NEJmL1dMMDBHTVpPbTNNeTNuWjFIelFmSGMrYW1vVmZabWRRUmxL?=
 =?utf-8?B?R1krK05RenNYUmxsMHJkaHBWQnI4MGw0VHdVOURRM1M2dlBJOE9iZXMyNXJj?=
 =?utf-8?B?NWZxREtLYUJjRmdrK2hMemxrVjBxK0dvSHh3bXFQbGVRb094YkgxNG5tY05D?=
 =?utf-8?B?MlRJTHlwbCtySkdQMjAyWStzdHhrL0wzM0NzWkg0RG4vSFNDSC9WQVJodE8r?=
 =?utf-8?B?RWxKSWV4TDJGY3E1c2c0SDBFQ3lEV0hxeDJUZEJUakVwS2FXK0d2NkFZRWRj?=
 =?utf-8?B?TGVIQ1RtWnkweXhwSFNEdW1oMndFb2NBdFlNS1hpcFNRQ3FrZkoxUnJQT3g0?=
 =?utf-8?B?VkM1QklYZENTTVpvR3g0K1hPSFNhR3ZaYzgyT3N0Y2xnQUdxSzZKWmRncXZN?=
 =?utf-8?B?QTNMU01oSG9IVDJlWXZUNVJjVnlYYWhvRWVGYlkzdjNQYTVUU2plY3loT2ti?=
 =?utf-8?B?aTNhZkIzaE9DYjdTSGRyUHNVbU5XOWJvemRsaHA0RVUrTXNwUjlKdjNaaFdI?=
 =?utf-8?B?Z2RyQUViZlB1bDRLZGtldWNVMWlQakpVUzJHejhGV0FTbUtmTDVDS3Y4bXlJ?=
 =?utf-8?B?RnhOSlJIeUpQZXROMXhpRWwxeUJEdVhoYU5xb0ZhUHFRMklBZlRaMmNmNDBi?=
 =?utf-8?B?Qk9nR2dleGtxZnpjY0F2L0dTTC9qNk1yMkhMRHBGZ053TjZEaFpVYklzWlJs?=
 =?utf-8?B?bm5wT0hMVWVYUytCbjhyWEMya1hlMGV1YTV4WUY0Q2I2VytyK0liU0FmMEgy?=
 =?utf-8?B?OFdtTys5aktuN2crN1FVUlVqelFrTzV2eVljem51SXc1cXFtNG5VQzE0ajJK?=
 =?utf-8?B?RllQOHArVFhBRmREOUpwNExyRlpwcWd5ZmRrR01ncmZUbG52Q1RUQnBPNlo4?=
 =?utf-8?B?ODNxbEE3MnNKWFFoRjk4emVyaWwvQy9ZZFBrWjYwVkRNbmxqdmkraWlRaktS?=
 =?utf-8?B?bDdRYTZhYklNeXA5OWUvQ01IMERtODhIZ2t6enYvVGUreGlTVWlLaFhoOGxi?=
 =?utf-8?B?bU9NZEJ1NFJkR0JtbWxqRk9BeGhhdFN4L1QwRFNpS3p2eDZOcE5QNTNjZFNz?=
 =?utf-8?B?bjhxZU5VT2FEVGt5d3FPZGNFY3VvUm1DT1lFOVMvVDZJdnI3U29rTmZ5MDYr?=
 =?utf-8?B?dmk1azJJcktYRjdxZFBIU0hnYTNOdU9Bam02RDQ4c0lrMTJCUmFYeXNGTUI0?=
 =?utf-8?B?YmRFbnhoREc5S0tGT1hsWUhjRWJsV011WjVUTnphcGpzemxnZ1pLbEdVa0w0?=
 =?utf-8?B?L0l4cVZ5TnJHcEt3cDMreDBZaklweGVhNWJ5eXlxSWFsSkh0NU8xRXdhSFRx?=
 =?utf-8?B?dXVvZlRZbEhyQm84U2Vob1BtUEVXTnBzK3RQZjRCaUlxVWlHNXVEckp0WjJN?=
 =?utf-8?B?bXl5ejZNTGtET08zdEd6ak1VVWhPeWZZZ25wV2lCcFdtaENzTnE1V1oyd1dJ?=
 =?utf-8?B?cmwvenZldThHL200ZkpmaVp2MzJnVlA3bHEvUHc3Q3F3bThwcFA1UTJ5anNX?=
 =?utf-8?B?SUpWajkwVHdvVUt6SUMrRTFrZENTd0d0MnhhQW5uV3VxdUFPZ01SbHo1RHdR?=
 =?utf-8?B?S1lNR2RwN3p2T09QaDh1S056YlNEY0plOU9uVkdTamhhcDBLOFY0MlJJOWxi?=
 =?utf-8?B?MjRHRnhYL3pqamVYKzdDaFhaTDFXdEwvMUtNWVVjZGVPdHRqQ0hxYkpyNHIv?=
 =?utf-8?B?U2FlempibjJtOTBESDFKNEtpTS9xSDQ3KzRmeGtkSlJzSTNVWEtKd1J2bk40?=
 =?utf-8?B?RG5oZS92K2ovVW1iNUp0Rlp2azJmemM4Znh3QXYveHdXZjl4SEFTaHVEcHNN?=
 =?utf-8?B?bEJNVVk1T29SZ05HaDNqdE93M09DdUZmSEhQbmtKV1ZzOXJvMjUvVnlrSm1v?=
 =?utf-8?B?cWxnSDhBOGdabWprcE9ZelFzTmhSQ1RTNDN1c2IzdThNT0ZOc2hubmlRVXh2?=
 =?utf-8?B?TlFHZGhwWTJmbEE0YjJXVElYczZXaG55WHkzbTNvY0oxQkxVVDlYU2JDUjIy?=
 =?utf-8?Q?aEecwFOFshoqjzRaMIVY4Va6D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8o0tRFxAkaGxOEFyc3mj6liudsBu6Hw68w3+soXbgcK2PagwufCe/tydcx1rYMLWHqiHIiuJcuaZa+wR2hn/QCyec+6i5OU6nA54PYs/bWkIGcf9CtpV8k05Pf04mps0y/jWaTcjUy04+itG19I2pFamvYhTjr/dPoy4+MguWc2lKjDBppuMWHr0ZWgXI6b1FcCAtDJPawkItlk17la9KJ04PwoDB8p86MYLLgqeOwiDP4XTJQMXTPV1P3XW2kEAg3dpg9pISIp5118KmVry+CcMoG+buyYcScy/K8Kuuzu+QpP1Pl9hb0OJNvmqqIfN5HfdaNh3W6+AbbE/kYZLOXs/DpA5+LOnnPGfq8l/o1twlLWud3CWmTPEGkFmFsq4dQFsPjQYXllO7UwPNklnfeBtpUBu/bBzon7WfBcRAFuXjvgMB55olR9GJ5iF9Y1g2Qf1JS4ylKSzO2plmnDisU+TIe7ikFE1pS5Hu18zs7xtOg7kfoH6D4KfbcNcpf58trX4ep/B1d7f6Pp9unPpifIvZ6YUSNBaDAl0UWPdKHoPXsiepo4qcFHtN3uUR3m8wTege70C+COIhvgBLusnkrmwx5Ze+fYfibZgGFXxsTY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf0c7a7-6116-418d-7387-08ddf10b5703
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 08:15:16.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBtrFzIxB3bZIyV14SCYy4YBad33Z3/3W194tflYsylVHJQKBcdvYBnLmhkkHlNoxYfWUqO5Nr44sBq4cFOHYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110072
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c28518 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8
 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=Bj0yz4kmN1o_EVaBk7MA:9
 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX9XkH7/v/8Byu
 6ch0HJpZn4ywLg7ixBoFmd4rtgx764o5d08iNFKsE+tDoaluUF+C0kGYES3kaBjm9e9S9AqZmus
 F/HTlZyn5ZGXHzuOl88TgAi88dtzd+lkM0FZODcRO0ctghlCbg7HJldZEdXibn400CyXUNpj0Ha
 e3wHFva8uUK48LEesXez9PTh4KMk3xKm0Ee0s3fGWOHNxohiS/erB03z+yoiZWeSW7UggxiXsg8
 e58kxlA1YuoqiUikrygzUHsP3OjPg4DZxGxQVYkfOzxkpgUQcJUpVGf1/UkSB1xdF5CsczX+qN8
 6EexJqCXXtj8pDdzM//evXML6loF+sol/3GwYQ4BSR4djOVw2hzTkEBvHxseLdqbseIgQv+Z4P9
 JAe2xADConExOMSQ52RpCXgcxTU0aQ==
X-Proofpoint-GUID: 6NynjClbj4_TxWHEdi1vhA-vFBGwP6Uo
X-Proofpoint-ORIG-GUID: 6NynjClbj4_TxWHEdi1vhA-vFBGwP6Uo

On 10/09/2025 22:32, Bart Van Assche wrote:
> The SCSI core uses the budget map to enforce the cmd_per_lun limit.

That's not strictly true, as I mentioned in 
https://lore.kernel.org/linux-scsi/e7708546-c001-4f31-b895-69720755c3ac@acm.org/T/#m16d3bf6266faefee60addb48ae4b5cdd65e90a68

cmd_per_lun may be completely ignored by the LLD setting its own sdev 
queue depth.

> That limit cannot be exceeded if host->cmd_per_lun >= host->can_queue

Can host->cmd_per_lun > host->can_queue ever be true?

> and if the host tag set is shared across all hardware queues.

Sure, but what about single HW queue scenario? We should also enforce 
host->cmd_per_lun <= host->can_queue && sdev->max_queue_depth <= 
host->can_queue for that, right?

Most/all single HW queue SCSI LLDs do not set .host_tagset (even though 
they could).

> Since scsi_mq_get_budget() shows up in all CPU profiles for fast SCSI
> devices, do not allocate a budget map if cmd_per_lun >= can_queue and
> if the host tag set is shared across all hardware queues.
> 
> On my UFS 4 test setup this patch improves IOPS by 1% and reduces the
> time spent in scsi_mq_get_budget() from 0.22% to 0.01%.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi.c        |  7 ++++-
>   drivers/scsi/scsi_lib.c    | 60 +++++++++++++++++++++++++++++++++-----
>   drivers/scsi/scsi_scan.c   | 11 ++++++-
>   include/scsi/scsi_device.h |  5 +---
>   4 files changed, 70 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 9a0f467264b3..06066b694d8a 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -216,6 +216,8 @@ int scsi_device_max_queue_depth(struct scsi_device *sdev)
>    */
>   int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>   {
> +	struct Scsi_Host *shost = sdev->host;
> +
>   	depth = min_t(int, depth, scsi_device_max_queue_depth(sdev));
>   
>   	if (depth > 0) {
> @@ -226,7 +228,10 @@ int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>   	if (sdev->request_queue)
>   		blk_set_queue_depth(sdev->request_queue, depth);
>   
> -	sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
> +	if (shost->host_tagset && depth >= shost->can_queue)
> +		sbitmap_free(&sdev->budget_map);

eh, what happens if we call this twice?

> +	else
> +		sbitmap_resize(&sdev->budget_map, sdev->queue_depth);

what if we set queue_depth = shost->can_queue (and free the budget map) 
and then later set lower than shost->can_queue (and try to reference the 
budget map)?

>   
>   	return sdev->queue_depth;
>   }
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0c65ecfedfbd..c546514d1049 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
>   
> -	sbitmap_put(&sdev->budget_map, cmd->budget_token);
> +	if (sdev->budget_map.map)
> +		sbitmap_put(&sdev->budget_map, cmd->budget_token);
>   	cmd->budget_token = -1;
>   }
>   
> @@ -445,6 +446,47 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   }
>   
> +struct sdev_in_flight_data {
> +	const struct scsi_device *sdev;
> +	int count;
> +};
> +
> +static bool scsi_device_check_in_flight(struct request *rq, void *data)

so this does not check the cmd state (like scsi_host_check_in_flight() 
does), but it uses the same naming (scsi_xxx_check_in_flight)

> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> +	struct sdev_in_flight_data *sifd = data;
> +
> +	if (cmd->device == sifd->sdev)
> +		sifd->count++;
> +
> +	return true;
> +}
> +
> +/**
> + * scsi_device_busy() - Number of commands allocated for a SCSI device
> + * @sdev: SCSI device.
> + *
> + * Note: There is a subtle difference between this function and
> + * scsi_host_busy(). scsi_host_busy() counts the number of commands that have
> + * been started. This function counts the number of commands that have been
> + * allocated. At least the UFS driver depends on this function counting commands
> + * that have already been allocated but that have not yet been started.
> + */
> +int scsi_device_busy(const struct scsi_device *sdev)
> +{
> +	struct sdev_in_flight_data sifd = { .sdev = sdev };
> +	struct blk_mq_tag_set *set = &sdev->host->tag_set;
> +
> +	if (sdev->budget_map.map)

I really dislike these checks

> +		return sbitmap_weight(&sdev->budget_map);
> +	if (WARN_ON_ONCE(!set->shared_tags))
> +		return 0;
> +	blk_mq_all_tag_iter(set->shared_tags, scsi_device_check_in_flight,
> +			    &sifd);
> +	return sifd.count;
> +}
> +EXPORT_SYMBOL(scsi_device_busy);
> +
>   static inline bool scsi_device_is_busy(struct scsi_device *sdev)
>   {
>   	if (scsi_device_busy(sdev) >= sdev->queue_depth)
> @@ -1358,11 +1400,13 @@ scsi_device_state_check(struct scsi_device *sdev, struct request *req)
>   static inline int scsi_dev_queue_ready(struct request_queue *q,
>   				  struct scsi_device *sdev)
>   {
> -	int token;
> +	int token = INT_MAX;
>   
> -	token = sbitmap_get(&sdev->budget_map);
> -	if (token < 0)
> -		return -1;
> +	if (sdev->budget_map.map) {

this can race with a call to scsi_change_queue_depth() (which may free 
sdev->budget_map.map), right?

scsi_change_queue_depth() does not seem to do any queue freezing.

> +		token = sbitmap_get(&sdev->budget_map);
> +		if (token < 0)
> +			return -1;
> +	}
>   

thanks,
John
