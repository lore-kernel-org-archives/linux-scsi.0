Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF86B12F5A3;
	Tue,  9 Apr 2024 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673873; cv=fail; b=uTCNABZlIVHy8AwXOtEv3OxgW0jlzLd4mut8ncxemr07MNBh6W6SCbHWZuZ98gr+BtSujfXRw5ub1Mwv+YXvaqDmDe2zN22u7HANqDpJ77u8dPNBo/szW0HCHVBPIdlSkJ3lDLeeh6BjljRqpGlTZ8tRLyvHQzY0pZB+Qt8CIG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673873; c=relaxed/simple;
	bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nQ1K1+8x2GFAnJ8qvddbX3BLyuwlRPbXfeviAowqxrcA+P3ifuK92lAQHhR+J8whgPxgjaMpnKg7ODdrfxKpCB372jN2avKm9e+w95h126z7E40nYvi0OOIIZFk0TPcC3ksq4j6j+3HoWKBovR15DjKUDtdsA/mNqiJon0b5TYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xxu8gnjW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ckQTghvk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xxu8gnjW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ckQTghvk"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 439BYsXu004450;
	Tue, 9 Apr 2024 14:43:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=Xxu8gnjW2QncWRkHeJTGG/klUFotIcxrruGDuq0yMCC6XnjQUXZec874uiZX1mwX7E4w
 9dcqGOqE2AdlEj7nZVdfO1McJ48Qsned/K+lt9Y0dU9K5YTdP3UEVntpiG7SL1sSQgco
 FYNVyFazbzAy9sGy+Gbm16r3gWT9oofT4okFoWNC+5nsXpHvJlgFSynPFoPsKEP0k6R5
 s7uhJ17dwPvKf19RCh7ZpDkrFTNO4C4bSSY8e7UVafabDQJ78H0faWhIjDGmxnUD++WH
 6RBs8dpR/q/iV4x31yr1ESvlVCO+FGlnA5NCtMGzrWuiqVLlrAPqp4kp9kdpwJjIoIE8 Gg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxvd4j5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Apr 2024 14:43:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 439DW0dd040814;
	Tue, 9 Apr 2024 14:43:34 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavud38te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Apr 2024 14:43:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnUPjrzLXqDGk5uhCrHHGB10cPjF07fHc1XsWnk5xUDlxlFzz6zbAU8kJ5PZyWBoC+ophHA3d/uy4yiPbHXeNBJsz3BTfFX/raU5xzVcLqxuAlLDGf90TBnJi4ZicA3pS5SVGgOmzb0dWeUHfwA/UeA66gs+m/t0DkrIiX4oUaS7uwqGDd1ZYj9cnUk8ftPbBatoaE01fZCveDQ758hYWW5XIcrnB7ukscN1gRHHLWspGW07SfFDaIdxI6XVmqImDJ6crbO3U/zfc2nsv1E0/wdY12RK1KNQBLFdtJrm2sKnxSxWxha1Q3rpxwSUq2BbE+03p71RfajVh7oeDnNjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=KFvB4AOEezoUosNG3sScXMUmQQHqAjojPAtzy8iyCgZu3UnFlah5RkFuEra8OZ5dfL0PRQCKV385c0dMsLqAKru/7tecPLyzizrNHOUiqq1JwY3eRWjnfCET6Kk3ZKwb6Dd4RnssAqlCOMi1f8MCG15c91W4fywVppPiD3YmxgsIhMjOr0QCNPJJrxj6RXzrhILmRhdPetKXisyGQucJaN0nk0N79FHzelF4dzsB+9/cgIF3ePF8/vYiavBbi+T4s7MvRTxXLBfr6rqJogPXNiNnpoho14diUzevxOVUvCVm4wgXOtarguo0+sDryHpbADluW+3Ncrw6i0H2GPbYww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=ckQTghvkqxaHvivdCvSU82clkploBdvg0nrJn+a6e2SLe7STKTjjdxk6+a0X6fg4Be6gXYFOhdSsX/fSOwCF7Gy2dIW83ccVrzgSNRc/TGzsM+74Q4YDTvjV+dobW11vPW48JraP1yr30HWHj7C90Ia2nWqurZUWPkN5ogFLHxM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7730.namprd10.prod.outlook.com (2603:10b6:510:308::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 14:43:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 14:43:30 +0000
Message-ID: <9655ea04-6f5c-4e9a-8d3e-00cfcfef4bd7@oracle.com>
Date: Tue, 9 Apr 2024 15:43:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Yan
 <yanaijie@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        Kanchan Joshi <joshi.k@samsung.com>, Hannes Reinecke <hare@suse.de>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-2-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240409143748.980206-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0376.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7730:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	i5bMxs9i0phSauKvQHgypdpMTxNbzM8tRu2WaXrhBH4iqsJecdl3O/mEXPTXepIPVaX2WHnpswIVJGUA3OKtIzyG8jqptzNDYostzT8F+GWyf6KZCYWq5j/u7+/Ot7CPrG+oyhFfniT0VZLFzL5dWGLe/aZTz1ab5DMnj80BtSqWUZz80rbZ6EUou3RG4Lw3JvGqMx4cjSkbNCJZZMBQjRG1vb5kTvcG1k0jMaYBwNvrXTilv/xuxILkKkXnPnevVLQXmDFrOf8S0KoZ+SFlEaiXU3TwLM0Tbb+/ju1TgwN7ThHNvpEV2XMOS+talkvV+AZlPXTgNsQVzOr/DVedjWQRnZOfLEPx0WshUQb7O7sIka5c9Wr1cBbPyAm+3AllKfFu0GGL/pdng+KQZPyKfVksG6HW3mw8uhqsr7ASskc8LjObtKYwG9w5/EG+Jh43r4fgD9TSdZnz/tHTA3Qsrw6KN3Xj7t/sux5Dx+jlcP6QrbSQBCMx/w6PrQj/LBWED7970P/VQfLQfX7DwZpdFPPq1Zc/VAk3+GC23OfOitMsSr2Sh8xYUjVKCin/P9IjeNpuEIzM3gJCX2p2kg9okTJFRxySgHBkb61Z0hnjsTm75Ihfc3LOc/bYNX7VIq14eYgDFCkQiyk8ymiNonZJtl0C3mT+zD8luzBWiYzHjF8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NFRFNXRBM24ybXJpWHFrZk14R0NkTkpaV1pNeDA1MWFoeUM4RUU0dFdFenFD?=
 =?utf-8?B?U3JlNzlZYjQ1aStWcitMdXlhOFYwN1VDRCtmVEJxY0w2ci9jN2J6OHZZVFpY?=
 =?utf-8?B?YkNOM1BrQk10RkZKY0Z0K3JWWG9ySEM3d1VRTXdSazhDcG1CdmdPUTVNVU82?=
 =?utf-8?B?cWRIdEo1NHFOUDJYVEF3bGR3SHRTdXZ5ZXBFYjlXbDYydWlnSENJVDBMK0NV?=
 =?utf-8?B?T2I4UHNmUDV1WkxmaFhSUEJPUlBZam1DTzlaTTY1S01FeUZUaHFhYURJd2pY?=
 =?utf-8?B?T0JjS2RLcDF3UlMrUlBnS1R2R3ZibnE3UnpYV3gwVmxLSy9oRThTWG9lc3Ix?=
 =?utf-8?B?Y1V4aFUwS0tvcDRQaUhyc05WbHFITFlZZHBOZStJUFhRMStBZThoMmt6Qlhx?=
 =?utf-8?B?YkNtdjV3a1hySHdBWGFuVjVOZU8zb2QremhIS1pkMkw1MUo3TDhjbWhqbUFH?=
 =?utf-8?B?OWo3SSt0ekpMWGhIVm56Q3g5RzR4YktXdE9PcHJwbm51WnZHaC9VVXFEenF6?=
 =?utf-8?B?ZldrY3NLWmRrZ3BUbUc0V1AwYm1za2luRklvRm5JOTlkTHR4MkRNVTFBYlB0?=
 =?utf-8?B?aGV5eHpSQ0l3NXBhQm1ibm9yTStWbHhzVHk0aFhORG9Vb1VXNTZUZXNmSEZi?=
 =?utf-8?B?eUtTWWk0djlOdWdBVHk5SUJMUGRmNmh2dW13dk1ORG5seGZxWlFWTW5XVnlT?=
 =?utf-8?B?K2cxeDJET0hVcERUQ2tWc3JSZk1nSFNnV3lqYnhsYVhnV05CQW13S1lEWGNE?=
 =?utf-8?B?ZFhPVnpSZDFVRzZqbzFOdkVFREZkaFRSNDljVTNoZkl5Q1RyTE44Y2ZvRzBK?=
 =?utf-8?B?NmUvOWJMQll0YWt3L1BSMHF2VGxtbGlJOWk5dDFQdGNoNExIUXZpVXMvbmtn?=
 =?utf-8?B?b2J6UHJabkpEcjA3MlNjZ2FtRzQ2eEYrQlJxT3FPL0JxNm8vZ1B1bnB0aDVh?=
 =?utf-8?B?YnhWT0d6Sm1Fa2Q0YU5uTXF1eGtnQ21seHpyNThaNStVdWVvOFNiOFo5RmJm?=
 =?utf-8?B?SmJDL3MzYVZWYWtrQmNjd0FHTTZLcUQrYzh5aXdsdnpsbU5scXE5WmFEbVhh?=
 =?utf-8?B?MVJxNTFrN2w1aGVRakh3dFYyeEpjOExSMHVuc042bE1SOXdnM3h6bGU0eGVO?=
 =?utf-8?B?T3ZvcUU1WDFocTI0TDhnbWE2RktDb1hnM0wrNTZIeHRRM0N1Z0M1VDdDdmJW?=
 =?utf-8?B?TW1hZHNma0FrdlhKYzgyV2l6T3JnMTg2WUZLa2FlVTFhaU1NZmJIdXduWU9a?=
 =?utf-8?B?VUZuSjJiOXRITHdRajZRb1ZuVWR4VWxHQWtvVW5Odi9yeEN6OHRORHdKTCtE?=
 =?utf-8?B?dDNSaDZ1T3BzTnI2MXFJbDRCWnNQRC84bGRDOTNYakFHcEt5UlJpUU5qVTN4?=
 =?utf-8?B?OGVSNUFJcXFLb3FJYmVsWlJTY3BCZXdIeTE2VTY4SVJPeWtYalFTSFo0YXNm?=
 =?utf-8?B?VlJ2ZEpDeG5hOFJDeHkyNzhHcnMyY2E3UXhlQ3FJNldyUmg2Zm8rRjlaSE5G?=
 =?utf-8?B?aWw2SVE0UFpYSUJQQ2E0TmRpTVdGYS8zVHRvU0RmakpXczRlQ0JoMGI5VFUy?=
 =?utf-8?B?d1VhYXFSdFFSN0taR3gyWmp3ZzdZZ1kvS1U2WTRVcGdwVE1MMGFnRnNQQWsr?=
 =?utf-8?B?MWFscFBWbjR4YUdhNHRYV0xYY3E3UDBCWll2emtiMnp0Nmswckc4Yi8zVkVl?=
 =?utf-8?B?Vld0THByMGRpMmsyZHRlSFg2a2RaMnJrWVZ3YWZNSllmUFFla1VxMWdqeXEv?=
 =?utf-8?B?b3IxWndJSkI3U0RUMmtWMkV2RnFsQVQwZDVKY2RiZk9xdzlPOGNmbnN2ZEl2?=
 =?utf-8?B?L3ZZUEN1cTkwVk1kZVp3c3dJYXhPSUlsUUtRNFpjS2daU1p3b0R5Um1lTTdh?=
 =?utf-8?B?TW5JV0FuRXZsNGI1VngzWkJFZURyZjcxc2c2VS9IOVJCREd0eGZ5Z3JhbVpL?=
 =?utf-8?B?bmViRHNTVnJodUwzMjJQYVZJd3gwUHhyMS92ajF3YzNETU9hTXFGRTJQUnpW?=
 =?utf-8?B?U0R6bm4yZ3Vldzc4V245RytsNFF4TWl2YlBRNG1WV0FBUEtuWDdxSWFVNE1R?=
 =?utf-8?B?TG9ZUUVYcW4yYlEyTE9FUElCLytMckJjTUs5WTVyTkpiQlJUeUF0cVdoVnRn?=
 =?utf-8?Q?UmGs6xjAIH7gq9w+ecP5Vi0MG?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	dIulhvzlPACagdlbH/M/L2m2grDUCFVmjtZAsSDakHfHXd7LZDM9nqYJ4x2IU9KMNaIKHbarOvs06xFGQpeG283IgG0Nwgb2SJmAxn2JuvCcUKs5QlTtklMnnvc6FMGEYH2QSy2kOH9RV84IfQRur96Oq9E/cD/EAgeKKXxoPUIMfYfknnQoxgjMUi7ICocaxCwbgbWZ65kNL+BQWkf6ElEz/NPALYIARD4ymYK0ZV9DI575WrOXzXAZhF5utsiYouacG7/Z+5Pjbe8gTy2jo7Xr0v+oD20u6x/hx1mbmwSWPSwJ9Zk/v7BsRSu3eqgjbCq7m2DeBhNCgu2qJuLduwRcX0xNU3P6Ph+Uf4/UXX/Bfsdk82GWECCCg5jUGf8wdg5sh8NFn0jRVPJ5QmwPVYxfPCOZE7rtFVyfE9karYaPT1XSmX2g9QyMzBC1ulsBhgIq1Zpc1IjJj7IOyEZIU3kGkEgMyM5EcV6IDCfHJfapaGuhRchwERaedcBFz0mUb8CAnonYcBDGqniS+wbT0DKMskxPVAxEO8OKRqyXJTn6Tkk61OiJaZH0rcYqggbp+gTk7RQ+xZB5FokIYENfvWg8e8emll/32CSNehVNfWA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de9836e-97a9-41a3-9fa9-08dc58a36c54
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 14:43:30.2543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffyk0/5X3giz4nkaDvZFwGpKxG9KGmoDmLQELF7zOdg2KU3z4pFz9vfO3qzqnexpIPaNFtluSi56yFiCpW8u2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-09_10,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404090096
X-Proofpoint-ORIG-GUID: MP4N5nFsVhpAC9NOSx6cfY7376hK7gTb
X-Proofpoint-GUID: MP4N5nFsVhpAC9NOSx6cfY7376hK7gTb

Reviewed-by: John Garry <john.g.garry@oracle.com>
