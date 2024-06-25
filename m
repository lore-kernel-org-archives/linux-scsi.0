Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE8816FF4C;
	Tue, 25 Jun 2024 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719328094; cv=fail; b=RUogtlFgKQ9D6rTLQfANO2GuKI+pupato1nalPEdaVl6KGAe6tbN3nMGh/eAi4yTVVAPxJNEo59bY4KQra7rznUBvMxC22hRXWmjleLb5LKdIN+H+vmGObcte6Mbw8aVwrA1G0R+aBYTqlgzA4uSee81C9E3GSmiiGigYepGQTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719328094; c=relaxed/simple;
	bh=TLRuG/YsAJvh1ftvATzgnnRanrXpsyndbPKjJL0dhWQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i8mVdIwAQXExoqVLNQBKaG76HssmFXn19XteskVIsGbL8P8iC3osFujNCGJx7BvZmMwYvcD6bhfrd6Yxc1r7J0qj3+v47hjNZHFhQS+w4mYYOPhi+crN4D2IiBZVesSrsHRZCUHBMpa9pn5P5XZrxrw5aUHXrQgWYiqDx5cgxC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jWfOOpE2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p14M4i2e; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jWfOOpE2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p14M4i2e"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45PD3Z2p011689;
	Tue, 25 Jun 2024 15:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=IrADWvaI43ibuD0OtUOun2hOkE30BV/eLMq7ieWwClI=; b=
	jWfOOpE2ZvCQmlbfyRxaZQ/uY4/B30rp3xyA8o6K1xREoNSaU/dYWJeds/K5Ijke
	FxKT4qTShd87rSDN8WjzXHkDlc3Dn0wJ6KmpNjpndI9fZnDS39tVzHTE2NMZ+dKN
	FYG45/F0wW3Fd3QtjliCmi7BDt19+2g+6b2ajaZT7FfwkJhyBF/6s+Da7ASTqIHE
	N/y26ycb77xElQs87qvzq0wprtz2XRgPUMXF2ENMw4zBbQygwrOqoeVCcPDffapI
	nKan4ztmkK/4Xc4HqZKrhWne2HbyK/k3c4COW8cDGT/oJSbtqRSOGsP6DOXhhQre
	gk+722z0aVOcqw1tOxR3pQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywnd2h2pj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 15:07:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45PE0bsa001339;
	Tue, 25 Jun 2024 15:07:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn28ecr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 15:07:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdEJzaSg70VmhHRvUC6zg5jP90Psr5ZSAU5G8CqOWyqtCbob1QeLpx+NOdcTU3p5IqBhhMDA4MLAVJbDrjrtwWnxBOXyXE6JK4If5ZsxWOY6/aOdw5UHywEF9+4NYiQMXjpB5wmUDV/nalX4FhMNar29pSXih86yD/0e6bvhIz3Vj+iesUUn42Jtn4lPnCwxvBqs0AwDugJBON2rhw5k5S094jLDbkdEURfkDMatZIMSNC2zpZNGDryCDhmsoCqdtHzlZxB/S8pi4L+nO4jBhNFphgSRY1kQgzjzNV6lJyPqPM6ffRs4CfLwre5bfnTjoa3bmI6H2ep3C6Om/vsiwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrADWvaI43ibuD0OtUOun2hOkE30BV/eLMq7ieWwClI=;
 b=JRbuuYMKMn6P/X5hgX6zEi65yhohfKMlQJveSbjHVEexsTtaUfkRpI1f4sgtt/XMcXsbBPpeMuBfj5mOa7Kk2M+vjFxlbG0dH7BXs0LvsOusPyS5uMgNEh1Q7xMueo8BQGqpcHSd0WvdJl5cEXKAw5448P+DgC47+doLAfcTNlQH9nsujW+JDO4K7kz2AZ6aKGj72KKB03IcwAJw09jFSLJ4bBakl0Y1oEZh5TH7X57iWsEEC3QcvbQZ+S4u8vSl8sf/VvT4hYLGw9XZ4TT2E7PhlVs9tjUGjDz5CBS6peSGBrZr4gw+H34lvDZwQuManfSbwFLjCKywzn7DQe7X5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrADWvaI43ibuD0OtUOun2hOkE30BV/eLMq7ieWwClI=;
 b=p14M4i2eyrv6GCgYbyCDRWgKcYJFtA9+kxst8+GJRQI2CED2eMUuW0ZTp1h91vAF8mUan2sTZzF8MCIm2TDNMH1FrGfS5e9a7zKevTc/NJdN/ykcMn9KUuj8WPYBK7g9AtBk9FVh9NU1LKgz8LnFLA8+zQM8IVUhP1Hv3jrSb8k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4753.namprd10.prod.outlook.com (2603:10b6:303:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 15:07:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 15:07:50 +0000
Message-ID: <ad5bcac1-848e-401d-b28c-01151d9c09b0@oracle.com>
Date: Tue, 25 Jun 2024 16:07:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] block: remove the fallback case in
 queue_dma_alignment
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-8-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240625145955.115252-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0022.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4753:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d57fe5-c4fa-499f-a4b2-08dc95289465
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?N1ZzZWk4eEpaVmQzcTNmdDBrLy95d1Ztc2hZeFBtc1dVNlQvMkhsdkd1b2Nq?=
 =?utf-8?B?SldGdUw1eURKbTdGUy9wL2p4ZU9VUFB4MTBrTldCdkVRZWlhdEpjdTVSVXJG?=
 =?utf-8?B?bS8wNk9DNjhZQ0RKeXZqdFRzUXBKa1hzajU3OGR3Tkc3UnZJZkFSSEZpRGMr?=
 =?utf-8?B?QTA3UnpISUdUSWRSYkRFRFRhcUhLd0t1azJoeXlRdkJHWDRNc3Z1Q2podjgw?=
 =?utf-8?B?MHhkbHh3MEFJZk9UVC9WS1lUcjVGdDlMVjNJbHE0VVRVTTdOTVZudGJ0SGNB?=
 =?utf-8?B?emdXbG0zNHUwK1I5WFNDa2Q0VTh5RllNZ2RsZTluRWxuYWQ3ZUNOdzR5U0Zj?=
 =?utf-8?B?b0dMRFBLZElyek1iL3daU3RCaEtsRFlocHNRcXJXS0pXaHROMVhWdDZyT0tD?=
 =?utf-8?B?VklhMDBNSnhIWDFJbHZGeU9IZysxSk9ZRXFHQkVBT1dFS040akFDcmlxSVJW?=
 =?utf-8?B?TGJyQ3R5Z0w2VG00NlVJdWRvenB3SXJieTZRTHFObDFSdHRYUEkyeFI2VFZ0?=
 =?utf-8?B?WkM0cFhRcGJncVRkTC96VFkzL0VmQ1ZnckZ6dnRKREl2MTk2TEdSSFZPVmJu?=
 =?utf-8?B?SksrWW9yTVFIVnI4cGgrMTYyV1NyYWNPeFJGS0tXMVJqdU1oMjcreDVvK3RW?=
 =?utf-8?B?ZW5oVGIxTVNYVUVPM0p3Y1F5YlZrUVhDZ2lNWS9wVWNsSHVndmhmRkJzUllz?=
 =?utf-8?B?RU52WlZoTzdjUFc1NnVteHhCeW5SYU9yR0FrdWxvOVY3aHl4UXp6eFZyZkVR?=
 =?utf-8?B?QXV6bFZDTm5Rd2ZnVngwaEY2TklQT2d0LzYyWHMyZWJHREJhbC9BNUg3NXhV?=
 =?utf-8?B?VWtaenZvenUzbEt5S1RPVm16SmxWME1LWGVEcHVaVjRnTlB1dFdMYUU3SXN2?=
 =?utf-8?B?bEgzUFJ3Mm14UkJCVGJtVytMV2lNT3oxU2JzakN5dzBUM1BHTWszcXFjd3A5?=
 =?utf-8?B?NGJYMFljZFhsc2NseEdIRUp0NFJVZnZrM3BIQVdQNmk0eGxPTzhXc2pCQkVz?=
 =?utf-8?B?WjJnS241M1FlVC95UEFxQ3RzeDVBdFl1Mk5rNUNGUjFOQWsvMW0zMng1Y0tZ?=
 =?utf-8?B?eUh5cituMFRkT0UxUHl1VmRjc2tBTUVSamNlZmMzcmd5VHNwVW43ZHlFTXFX?=
 =?utf-8?B?TmpnRGl6eTJHNDdncy84YnlDTVcrdEV6SzJ5L2N6TzhWM1dXYThGbmp0bFFJ?=
 =?utf-8?B?TnlxV1ZWYUYvNEZSWjYwbTAwWWpyYmJ0L204NE5JdHplRktwd0lnWWF0OHdh?=
 =?utf-8?B?RTdYTnBXcDN5YXc5NWxhS2VVNTVtelJ1NUdQNUdZTTlKNFQxaVJFYi9SWlNw?=
 =?utf-8?B?M1VrbTNNL0JXaXNxNmsyNExMVW5tWS9IWGk3ZkJURm5CaXg5VnZBMUhHWjlD?=
 =?utf-8?B?bnE5c1cwVStDcWFtNjhCSUNxYXQ2S1huclFRTEhTN1lydGt6UC82OHpSSXdH?=
 =?utf-8?B?VmhVT0RDMldCS09CcUdKZk5aOStCWlp5dkpkeTg1MWVrRDNSclhzSjQvOTE3?=
 =?utf-8?B?T3dMaHlZeDFtRHRETHdKY2hsMkZOM1VLVDdobE1OcEVBWXl1RFg3UUpXRVVh?=
 =?utf-8?B?TmVFWW00bWp3NUx6MTNFbnFUV0pkNjhrUWR6UGIzdzh6VlZLVlg2cW8xNDBh?=
 =?utf-8?B?QTNEaEppT0Ewa0oxTE5VWDRsdE1Lb1lsM1ZaaXNFUHJ4SDhwZ1Q1VXIvT3Zk?=
 =?utf-8?B?bzJEa0UvTitxMndDbkc5SEkyNlFmQnNnUkRvZExPcDFEZVQ3YjFtRndoQUJN?=
 =?utf-8?Q?y3fIuGjCDwxEXUvg8mIEV/lmbvtcKPRK75gaBRm?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UVlXUDJMdUVvNHZwT3pmZy8rdENTNkg5c3VaQTA1ZU9YMTk5cGpkZzBoSzc2?=
 =?utf-8?B?cy8xRlBFVVpLcWdyWGZrRnp1L3ZoKzJwY3VtNzhFc0JFNUNNY3VkaDljYjY0?=
 =?utf-8?B?eWcyeXlhSTRISWlCdnBSbXlEeFIvRGRia0trYVJDTDkzcEVuVTJXZkpuV1h2?=
 =?utf-8?B?WUNSSGpKQkEvWnBKcU02VkxaTDJiaEhSNUR6Nm9QMFZuVldIcWFJY2FudDBZ?=
 =?utf-8?B?OEJDKzh5QldsQjIyQ0E3aGYzTUtYL00vMmI4TDN3Nk0vRjNLRzlkTXQzREhB?=
 =?utf-8?B?bUt0TjVWZ0NVa1dzaGJJY0JoQzE2TzF0NEpEUmNOb0hITTRCc0JqKzR4T29Y?=
 =?utf-8?B?NGtVQ1JCeWE0TTc4T1dLaENPQXlQOS9BZE1QN0c2YVpOaVNuekU4ZEdYSGs0?=
 =?utf-8?B?aVlVMUJtVitkc1VxOVcrWjhPRCtNS1VGTHBnYVBDZkhDbGE4b1pub08wdnE4?=
 =?utf-8?B?WUVqQ0pEbXNRUEljSWtTZjM5V2YwYnR6RGIyN21URTR6eVNYcEJuTTcxbmp0?=
 =?utf-8?B?cisrWHZ0b3lEcmdLcW4wQm12OXJCbnowVnVOQk9iZWdJTi9LRkc5WnpiQ0Na?=
 =?utf-8?B?N1BCdFdDNFJUNkxNemM4V3B1blFQTkV0ZG5veEpVOWVwVEFNR2dsbFJkbFcv?=
 =?utf-8?B?ZllIVDFzRXlaWStMSER1R2xDR25KWkVoNmFScmszU3IyVkJPZVVDSmU0YS84?=
 =?utf-8?B?VXhNRFdmV2x3NDZJeFNwM2tSQjhZY0pGOTVmeGFQQVRRMlpTTURlRHFkMzE5?=
 =?utf-8?B?TlB6b1hnblhBQ29UNjJsWmM0WkJwQTlzTkRVRXJrV0ZuK1YxM3dOVmhTMzI2?=
 =?utf-8?B?djRIc0t1SXNGYXdBVGpYSWdDWkQ2bjhaZTRJVGYzL2tSSGluQXFRRE8xR2xD?=
 =?utf-8?B?WGxaWm45dEpxcEZUeEozNkY3ZHRRbWhENkVQcVNMKzR0UTExZ090NWJLcTFG?=
 =?utf-8?B?d1NhRTVIUXVLRjF0bG1tZzdJT290Qk9EcXBKR1o5cTNBNEZ3ZmlWaWRPNEtG?=
 =?utf-8?B?SFVhMHV2N3U4UW5HVUFzdlZkS2ppOTB3ZTM5SDh5SFIraTRwdkN3YTVNdjA0?=
 =?utf-8?B?elVBQURaak9DOHRNeXJiTW9LbVJqc3c0SmVUM2JPYXhZcEcxb1NyTzdBVXNM?=
 =?utf-8?B?dVR1ZFBremw0UGg0MTY3d0tPVTA5ZDUrTmE2OU5pRTNrUU5uMVBnU2c3WElN?=
 =?utf-8?B?VWlRWDgyb01HZ1RDTC9SbzM0T3hpTHA1b2taa3lKUFM0WkI3b3BZWU1XNzRV?=
 =?utf-8?B?d3NwRkpOa3VQSFJobXU2bTdMbmx5MzltbG8zREREdnJPUTllU1U3Z3lrM0Qw?=
 =?utf-8?B?TWQyZ0JFMDlRbnRCeGY0YjBkUE5qQk9FNXRZeTZrNmwweXVpOVhvSHVCM2V0?=
 =?utf-8?B?UVZXTGdoRlRYYTZKdlhheXk2eFZkNkVmU21nT01LTFBKeWx3Q2dINm4rQmNz?=
 =?utf-8?B?RzFFbFg1UHhYa1JoVDFvOTZ4U0xSbjR3TC9ob3NLWXY3RjNpUWJKdWtUK2p0?=
 =?utf-8?B?Q1hlelJGUzhoQi9FTmlLYisrSHlraHdDc1Jwdk8xekk0a0VCaStibnB6cjVE?=
 =?utf-8?B?clh6eVNIOVBYY1puZ2JLOU9NYWlhSmJ1VS9EN1pEYUk4Q3A0UTVjbDdzenBi?=
 =?utf-8?B?VDhSNm5ObWhoUzU5cTgwYTZoVGRuWFlqdjlXbXUwcHlSWWF5SkZaR1ZNc2Fz?=
 =?utf-8?B?c0NwMmE5RzNNMTJibjBLQnRtK2J4VkcyVHludUx1Y0FXT2RzaXdjV2RGMDY2?=
 =?utf-8?B?enRnL0JSTzRneHB0UTkvUGU1SnRUUTZ2YUpEWERGTnppVkxnQVZMaG5rUE52?=
 =?utf-8?B?OTZkSE5maldwdjltNm9BVVpMaFVacmFQR3Z0OW00LzdoYUZ1M2xjRjZHM0lk?=
 =?utf-8?B?bTd0YW8vc0hsYUI5WEg0RTkrRUR0TVYvS09CWnBGL0UvQmZJTVo2ZEhjc1V0?=
 =?utf-8?B?Tlk5UFJnU3BFTnFPZlZKRGNLR3ZtelZVaGJTS1RwUDNvZndFZ2E0U0JFN3Va?=
 =?utf-8?B?YlZWbytCbTR0d3dLdis0VVp6V1JzTDExUDk1M2pGSUN1NzNka2dScWJNK2Ex?=
 =?utf-8?B?aGVmcFJkZmpoMTZ3V0R3dGFkNzNhV2g3V08xekxVVDM1NTFPcWs2anNHMDJF?=
 =?utf-8?Q?ZgpDoTURYfLtQHy/7dQ98Sh6C?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6qcHVSMVCEqTNv9Gis0buCTZY0McHhKe7S2QX8H0DfZB/Tj0axntMx+i4YfqBzzusVpceZcrCwH7xLSeB5chuklZ1NuAsf4ilo2V9WTkpc304Hplwrwar2o9x+St5CE0q9730J6bUZkCXf61+rwvakbuuQR97UTPCu8Jj9sjIdRfFR0Y0WUlgK+7l2wFTHOkw34H4IBC6LMoVvTx7xiAL30O2b1LTSG37AW8+hpiJ16kDBzG2Bw17cg0IFvtVyMO2Ow7Oyp8YqySPjPg75jJJUXgdLM2D+/sGoGQm5fle/PtKsy148/YkvaBAhinqx8lB2my9lXGNq61rqCASfQ5YMjzPBn7he//8v9RvRnJjqpfdrALWp/kLcFyP58DkbUcftcPdXnRB8WAYv8r7HSHUuFdNrS7tjGCerlDCbprQnlum4ycn4QN6luwaHwej2meluAX6H4aRwlRT+my6ia+QgStaHXiJ5AFOQoZmTb7PVGA3xV0pRxVeYw8Vw3dCap8JXNXeraqWDIf6A+mfoQG6uVkooHeOuQ54d2E5LjZRznBZpvNZrG4j8lHP5TYFSIuYkMybpiic93kAdvfd9otDIqWJ81OLZ0TUd03bjz+OpE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d57fe5-c4fa-499f-a4b2-08dc95289465
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 15:07:50.2699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XF4VuxDhK3ZEqkYBKy7ifNkVPLzas0tymVF8hzv5qdoqSGHWyV64suV5U5PDm2hQFOFY1vD7yDhrg3h5TsHLHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4753
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_10,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406250112
X-Proofpoint-ORIG-GUID: 3RcTPa2EldPSSIdCPne_BHgUyKUq5h9m
X-Proofpoint-GUID: 3RcTPa2EldPSSIdCPne_BHgUyKUq5h9m

On 25/06/2024 15:59, Christoph Hellwig wrote:
> Now that all updates go through blk_validate_limits the default of 511
> is set at initialization time.  Also remove the unused NULL check as
> calling this helper on a NULL queue can't happen (and doesn't make
> much sense to start with).
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
