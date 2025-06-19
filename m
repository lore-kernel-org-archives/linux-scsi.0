Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6B521ABDD;
	Thu, 19 Jun 2025 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750330021; cv=fail; b=QG+2NkHLlgBkETRNlujNhB251UoIyE7qC/aI7khDUfqkIZRmWJ5U44QZTmhxtaY1h/YS3SToLPdDDAlRxWtXWHLh/tRguE6VrWESMBe5IWYkfAWWSs3VEcq2+0sbT+CMCWP3bNTg8LKoD9jRi4s9jdW2JdBPJlm9erHdd6Iz1XQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750330021; c=relaxed/simple;
	bh=MsA9ey4hepVWXTmIvh+CdmLZbdfS0foc0uFwl3Pd+rw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hbBuqdmhxiU72DWTiTPyUvgoKPf7DPerofL2v2CqFMjBaRmsOLzPXYjwlNJAEFdpkQmoADkC7EfBi65aVSg+dsnbEZ/SH/fQGy0crGjWd+BrXCvVJs7A+ZSJSyOjf5Ost5B9+KKMZH9PF7gtboektKCyJ5NLso9PXRC+5mOnYeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OlOmizgd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UJZ4ppIv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OlOmizgd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UJZ4ppIv"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55J0fbpW013654;
	Thu, 19 Jun 2025 10:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wiVUtlgaUHxhqmPqZZtEFTWjgRCNrMCKr4lkyfwbrBY=; b=
	OlOmizgdV4TvTwv7dokuJJb8vbPxf+KWT/W/iftG29ZuBUDYZ20w4/BbpMxRKGaB
	fzH6/2kkPyKXKJ/JaeXUZFsmhC+qVWNTAChVV6Qu1RpV8i0ZnXv9cb/HqonCfkon
	Uteo7KaCWVwUOOFlGEEpxYr/Ds7MbJX7pU+6x4OL4eaED65aiXHlfVUz7TWv4q5/
	+CVI/hfHIfJPAIRgdRQRzsc8fBmv7uQU71M4kMnARd+wT4sGJHQJ5WwYWVsrdzBI
	XbpjhF63jzufShTZBSbZfzCpNr/oTOiJo9O4gTs1e9NRO2e7W8vQ09wVPDZIQKKj
	xUfy0ZTcBtF3wL+78iLKzQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 479hvn93jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Jun 2025 10:46:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55JA0atj025968;
	Thu, 19 Jun 2025 10:46:52 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhj1fcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Jun 2025 10:46:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bz2m9z81kKiqgjpYfysBQmngxlrE5n4h8sKjBcX2dnKeFvQ0a0M35WgYg2E9nNa2BVZf/cdljCC4cWJi8zv/zZ6vzIoFVoPaE4RRdn2UHqMWzlkqmgy+I8CMHRWN6Ptq+1aa+S3FeEdgtEXnBJLLCUZWsqXLx479uC3bur2kq/OkQfH426SEcH9IBgb+seVrkBQ9hlKNdalgFXeA0nNlpTC0P1TGymBCvBoqQfl4B6kZhdu6HWOOljJ0j8wR/4CJ+kWlbdoF3B/FdKJw+ZWw1Uhyxtss321be2CNU8z9YYYTr0hPZGfN2wKQCsb5ua+bxVlllSjyyIa498MMM2H5pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiVUtlgaUHxhqmPqZZtEFTWjgRCNrMCKr4lkyfwbrBY=;
 b=UzA+cY1BYAJclUIw8mw/obX/MQ+sM8HnJVSZMDV8CQ9XtjZZ4ME/N5UUff+/qKmevI8rPIqtPqvhes541FrxWCTJLOiC9vXRMlOEQYN5YLqzrfSTBjjrKd0Avs8GJaMGZMnCGCHeiRtqaNrrDRMeHLE3uZYbOSHqzIOFRYnPatOxOZi5FET+gnHXJTqV8+SOPHA8DBzb/c1Bu2Qk6NiuYSjydcaeFvtHbRwCj1W6BNTYGAaoqtrMQz7shvf8T/LIxmhOech7RQMU/SUP8X6nU7d0hOoDYwVubiw//a4k0LlKuRJVJVLJuFF7aswW1imQUg0K7S1qb2l6gwLcad8b4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wiVUtlgaUHxhqmPqZZtEFTWjgRCNrMCKr4lkyfwbrBY=;
 b=UJZ4ppIvP7S9FeFrDQbuZPpf1kfnBL94JbdOGA2tqWTNSD7M+W8UUPmCNuR+LsGxnfK1wMHpRKMsx5R9FKEDdtBHfy5vXqjZX2ncyM0E5pvWppXGCqXifqdE0kbzQj8mP2ZVwUWKnRGmr3/tE5AgUARqZwJ8rq61Xm0d5zO/8yk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB7097.namprd10.prod.outlook.com (2603:10b6:510:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Thu, 19 Jun
 2025 10:46:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8857.019; Thu, 19 Jun 2025
 10:46:49 +0000
Message-ID: <682ff953-9130-4920-a9f2-88dfd6718be1@oracle.com>
Date: Thu, 19 Jun 2025 11:46:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: aacraid: Fix reply queue mapping to CPUs based
 on IRQ affinity
To: John Meneghini <jmeneghi@redhat.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, aacraid@microsemi.com, corbet@lwn.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, thenzl@redhat.com,
        Scott.Benesh@microchip.com, Don.Brace@microchip.com,
        Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com,
        sagar.biradar@microchip.com, mpatalan@redhat.com
References: <20250618192427.3845724-1-jmeneghi@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250618192427.3845724-1-jmeneghi@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0132.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: f7f07a75-cf99-442a-ec69-08ddaf1e97ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bG1Ka25mOERadGpGNXNBMW0vMFhVd1IvbFl1U1htYUJrRzVJV0Zpa0tyOWFk?=
 =?utf-8?B?QXowNzJac2F0UGVJRFdwVkhGMExzMGIwemtwdXF1YU1kM2ZaekYreWwrWXNF?=
 =?utf-8?B?Q25May9qUVhFR0tRdjEza2FyQXlIWnAzaUIwN0xLd3EzUVNtZXV6SkZKZlRM?=
 =?utf-8?B?TjRSSzBzd2NYZDR6OEVYN0ZoS1AvV1ViclJWTnVhWUQwZUFHRWc2WmRPK0ZB?=
 =?utf-8?B?bXZoYklWMERXQ3dYVzhIVnpDN01mT3BUZjFwODlaSFNhZWs0Ky9XbkVNZGIx?=
 =?utf-8?B?dlJZaENYdHBKSkZUOEN6TE81Z0lXOGhXOVN6N3hUWTdyTWVlR3dyQ3ZadTJk?=
 =?utf-8?B?MWpvd3VoMmtGVFM2NnhDdDBBbHVXbVVLb3RQaWhKc1hyU01saFl1OTUwU2U1?=
 =?utf-8?B?cTFteHFZd3RrM0IxL0FCb2dCK1ovaGZpcHhLNlBWN3lrRUtseDUzYS9qQUh3?=
 =?utf-8?B?aFN5OXdIVlh0My9WbStpTndhR1lMa2REb1dUV01wNCtpZU8vckhtdExXN09h?=
 =?utf-8?B?dU9TZFNiSUhrRkJzSDBRc2tYbXR1aTRvVXlaNlJ5NlBRMlNKVmhvVHhiR2RQ?=
 =?utf-8?B?alhkcDdEeHVaYlNwMiticTZUN3BLd2ZlV29YdEprYm1BdDB5S0NreUowVkNI?=
 =?utf-8?B?Y29sTWdvQXFSVHREOVIyUjVuTXQzK2NRMTRqZFJ2MUtjZnhmb0VuSkJubEhR?=
 =?utf-8?B?bFlpOEhRWE4rRzAzcHdVcnFhSVVuemdNeFk1VHVRTWRYcW1NblZqb2N4NE84?=
 =?utf-8?B?bUFtVE9RanFzeHpoVjF0cE9FNnFsamkvbnp6SmMzRWNtMUtPQTBiblA4eGph?=
 =?utf-8?B?WFRIckY0SWtQWGU2Q0FJT1dNQWhhdXhWcXZTNEVuenp2VGJuM2JVd2JCNGRC?=
 =?utf-8?B?aDViMmRlSFpGK0hRYk1Ma3pUMmVQazlEU2pFYWZjWElxbkRDQ0h4V3JvbHBa?=
 =?utf-8?B?Vjl5bjBOWVFMQ0VQYWZpdkU3ajFFdVNUVzlUZDl3Z0x3K2VtKy9YUHUvTGZo?=
 =?utf-8?B?aXlQYm4xT0x0d3QxNFozWmpSN1pBVDlGQzhPZ25kaE5rYXIvMi90dys3eTh5?=
 =?utf-8?B?eFdaK2I5alplR1cwWlgweFIyMWQ2WHdBeVlvMXVyeTc4STNKK0VUNlJBelpQ?=
 =?utf-8?B?dko0RGo4UW1mdGJqcURYNElXUHFYTDNiRG1UVjNHbUh3YkR4eFhFN21VNzc2?=
 =?utf-8?B?cm1QemN0K1MxaWxFNE9NRm9ud1lmR3ZNa0M4NXh3TWFhSGZjTkpuU2ZpTUJW?=
 =?utf-8?B?ZkZ0bjRVdElTWVJLQjNmREdKOXFPbm1RK05yelp0RUdXS1hKZ1BQcmNReXVO?=
 =?utf-8?B?amdtTDY1SFhWQW0ydjFUWEgzWjNvRENCaE1VeUJUUVpEWExrWTc3WUxhb0ov?=
 =?utf-8?B?Uk9DbW1ZdEJRb2VNdVpzNU1ucTFOVGczWU9PSnA4VzE5KzFCSllSeDdUeERN?=
 =?utf-8?B?RkFEZS90d25yblpTQVlxVmx5THRSVGpKRjFIWDZTUjNZMXJFR2ZQc3IzK1RB?=
 =?utf-8?B?RHI5ZURVemxPLytWZ000czJ3R3FLTlBYb3hGUVBEM2YxU2dzcDlKQVJrdzJH?=
 =?utf-8?B?VSs5RHdraE1sb29mUHhJY0U5YzB0LytoYWJSR3dNdFVVUkJOOHV2L3hBeG1Y?=
 =?utf-8?B?dzNSUnlWR0RTTXVoMTF1eTFCZU1tK24zb2kvamsxQWhTMUhBeGMyWnNHRjVn?=
 =?utf-8?B?di9rWnhzM3NXYUxGRU4rTHcwN3VZMHlwSmtWQmUvVFZzZ24wVzVhM3U5NVdi?=
 =?utf-8?B?N3FmTHZucHErZEx5c0NMdHBzcFJZWThNTFpoTWVFVXBpWU1hTmdKZWNOd2Ur?=
 =?utf-8?B?bVB6aFNBOTF6eGhZVzVqVUdwdXBMU25GSFV6SDhLYXRzckI5V3grQzdORWlu?=
 =?utf-8?B?SklCcXIvdm5seTI5TWtNK0IxOXkzZGdUR1pXbnFyUGEveURsaG5LaGVPOGdh?=
 =?utf-8?Q?7n53OUD3V+A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3RjRFdnVkFNNERDYVErWVdTWCt1MXFONm1nSzZPYVRNSlBZZGM2WWl1bmVn?=
 =?utf-8?B?RjFuejJySGJpR3NqVFozdHlteVVmY3RjMStuT29RUzlVdFlteHpNN1BGUVJn?=
 =?utf-8?B?WmxSQ1NFZTAwbEVRaVA1ZVJSVUQ2VWlSUlNCM21hb2dLalRRZFlzVlZFTEtj?=
 =?utf-8?B?T1JVSWVOMURXb3EzR1lybEczc2htWnVPOXhYVWlSME95dXJWRmhraWYzNVZi?=
 =?utf-8?B?WENKNWlXdWdDSXZMaHpsSlZ6ZDZnSjg5VDd2bFJuVXpJYTB6V2p4dE16VlVp?=
 =?utf-8?B?SmloZUtNUWdIQVFJZ1lyVXRTSDdUN1RYSzkrN1FWTTdzSWMveGRFempDdjdR?=
 =?utf-8?B?ZEpZT3ZMUXN1ZTBBSzB4RC8wMFZPL2lTYWpNdmhaWTZtVUdaSjJ4WFhUbjhR?=
 =?utf-8?B?ay8zaUZWeCtLWGJmVTl0YjA5ZlV0VCs1U1JqdjRCVGd0YzVKM3dGVlNmN2dS?=
 =?utf-8?B?Z1JPb2RyRjhqaHB0N3JWWnpMaE5LLzNZV2paUldobWR3RWJ3NmhxcXdZbWl6?=
 =?utf-8?B?RWVTdGprODliVTBoOUExYmpVelgrc284dW00eWgzSmNNNGZRanF1bUJHcVIy?=
 =?utf-8?B?OVlHN2FCT0tHNzhzUzBSY3g3WVJXS3AxMERGOWtFZGFTYWJrNlRYTEtvc1Vt?=
 =?utf-8?B?RDFhVkYyZjVyeDlwVkhtVEk1SjhsYU0wcjJtQUxtNGJSQkRNeG5hcVUwa1ZT?=
 =?utf-8?B?NnduRGtwVWIxZHlubGJjNW5Wdjd0OG1iTSt5NHRsZkYzeXJ2eXQySVNBdjh2?=
 =?utf-8?B?K3B5NEZOV0tTNWh2bDc4WktCMFRmWG9KejB4RTRZekZUR2tLSVczMmsrTDZT?=
 =?utf-8?B?TnlzNXhXNkQzM0JWcE9SUmVhMHpjWlI0UmNYRy83cjlxZW53U2ptb3RiM1Zu?=
 =?utf-8?B?SzArNTdIVE1sS0NCT1cxaTJ0bllKWlNOVVNlSTlTdnNTcSttNE8zczdMR0Ny?=
 =?utf-8?B?MC9UR3JvTS9ld2xQN2Uzb2V6VUdmMkZibDcwbnYveUxwSmt1anpjMWE2Rit3?=
 =?utf-8?B?NE82V3cwcHZUQlVKSm1CZ2MxNVRZR0pIYThrNHVaSnVTU0NJNG4wejBENFd0?=
 =?utf-8?B?c0xCODlFMGc4YVpTMjkyWktnTVFxeVNSaHZkM3ZsRlIrSFNNTWtMM1U2Qi8x?=
 =?utf-8?B?MksydktmSE1tTms0ZWZpM2c1ZkdIZFZqa3JOaG9mSXpJbE9vSGlLV29yV1Fp?=
 =?utf-8?B?SnJZOXBNYTZVSjIzMGtwY0tXNWJKckE5NXpVa0V3K1JJQnBML0x5ZXN3MElJ?=
 =?utf-8?B?T25HV2xBN2dva3dENFgzNUJZRWhFR2hOL09PNDhXTmhEVGd6YitCQ21TcG9v?=
 =?utf-8?B?dy8xRjlRZjN4U05Md0x5YVhUSU1WSHc3czJOWWhIOWNQMVNKV3RBU0pGdFYy?=
 =?utf-8?B?cG4xT3JlalNVRnRKLzc5U3pVUk15QTdidXNpODg1ckQ0NWtiRUdpblFPS0VD?=
 =?utf-8?B?djdkcC9aUnhZT3BaaXF5R1FTUFdocXpSSDRYcEhJOUJJWExockx5bVZaQXd3?=
 =?utf-8?B?LzErTThYOEhjMWNCRzFGRmJYZFZGM3lrOElZUy9YeUFsK2RlVVB4Y2FUeGlk?=
 =?utf-8?B?bjNYeXBrUTFSZ0M1NHhON3dqMEF2WjFrYzAyc3A1dXZ5SU0xLzdaVVZEWDRV?=
 =?utf-8?B?ZW1XQzA0Qk5xQnY2cStRc0wyQy9BRks3aGNBSkxQQUcxSWtKeVllTlQyRndS?=
 =?utf-8?B?bEdTV1oxaFQvaURvbDNCVk9GYlRGem9qbFFKeStIeHBmSTV2ajZRRG1makgw?=
 =?utf-8?B?NVYvMkg3akl4S2lJOXZVRnV5b0hyakNOUFg4Ly9leUxzTGFPT01Jek5zamJ0?=
 =?utf-8?B?NURVUWVMRzhPNnM2VkI4NUU0LzVBNEhaUzFteTZUZ1FYQW1Rc1Q4TU5PNG5t?=
 =?utf-8?B?OHg5eVdPWDBpYjBld20rWXNuWGZVbk5tT1VNOG9EcWdvQmJBbkNSQklTbDFJ?=
 =?utf-8?B?YWsyaVBydXFZZnduQWpnc3dBdmhoUGsvS1dBY1FUUFNNbUJ3TktHWWpEdisz?=
 =?utf-8?B?OWdaaWZYSjN3L1p6akZuamtTaXlMV2tNQ1g2U3JqeDBwT2FRUkd1MDMwc0lG?=
 =?utf-8?B?WWwyM0Nsckw2UFZnYXUxcXdJdmhrYzh5ZmR0eWpLN3BvV0RYajFwTGlkZ09B?=
 =?utf-8?Q?3mpALvqEapWd46C7b1H5gdfwF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t+RgRIepG2HwI+QC6jLmwQoMVDKG/iXegoqSu22TYMhOf0s8KuJKunpxN2SPje2Zp0odBI9nHQB0XJwulqEr89cu4dOR599GxzeXeSUnCmqFRZU/5USIzQetmSB2ejD+X8+7MzDpKBwPsG+3v3F+e8Wt5M/W+LE/aMVXgx1/b2261lEj3CdOwx2bJEXjQ/Tnn+3uOyG89iWZf0/Kxxf4sO/Kk/KRjrUD+9Y8eHoBSD1jd4i+zkpcS0nlPykFW91Xg3rE/cIdh6QeneZl3Y8VaE/SjdKnhmZTNIDj1SDMcnByqrby3Ubv0+SC1mNUk0S1XkT+MOEneDzkMoVPGCovLrLr9QPcd0Pp1MJPXwEImtyAJux10Fdv3PSHItD+06ve90OPjTgxIS9v8S6BG8C+OnFaBPbhUFsnIEJNkNiIzDgcXsAO4tomZ36df8yJ6E9fwJWrDyNnMsFvDnCJnzDH0+PrrnZYRIeSmnHPbZQ4iZMuK7OSXD9/FEbD1rZqSUXh5tMqOFirt7G0cXStdceqphV8Xk0zJSA7QGcVtXzP/rsgdH9qPSJ9O5Ey65dZgqHST5IjYTuhdYQuBwZlhaxRnR45CkHo42adY82UGMuVL6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f07a75-cf99-442a-ec69-08ddaf1e97ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 10:46:49.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieu1hTcofV0WOxOLksEFos6n7i8Ebeff6FlswtEuXCdVE0lcOeJSv7wbuMiNDgxMb63NgZV9kMm8pMKFCvCB1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7097
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-19_03,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506190090
X-Authority-Analysis: v=2.4 cv=XeSJzJ55 c=1 sm=1 tr=0 ts=6853ea9c b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=XYAwZIGsAAAA:8 a=d_txRPmOw5E24vjTJUEA:9 a=QEXdDO2ut3YA:10 a=E8ToXWR_bxluHZ7gmE-Z:22 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: pPsYWjpvo_6eu0RNgrClISeUJH_52moj
X-Proofpoint-GUID: pPsYWjpvo_6eu0RNgrClISeUJH_52moj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE5MDA5MCBTYWx0ZWRfXwn5GSaR9Wii7 NPt7D+Z+llCin9+vEKToYi7E39uavwIt8d0+mUSFCRNZPZykKrXRcFXi3b9VoT2aAseH5Fm1CqE 9n8XZ56DVGBlNR8owafHzb2ut62YxlsT1K7+KW3j0giGZI9hJ6o4eLaR1Q34xBFNcpfO+Hq35f0
 qVuL+2cv9qI2EE3adQ97RqPc3pY+dRJjK+AHizDwpiLyGRu25/LJZEF9rd+GuZ4IwbL3qEKXcQA 7265ohIhBOrPyGT8JTQzUydvMRnZqMqhyX80T/mfU6EWz0cZ3/FdeveyCfdFrhvD33jaKX/cRKF b8a6VV9OQBmbP7bietP9Kj6uCwCDe0WFO0o8MXcoIKbNz9I3bmGNdsmvEGqyeur4IKNGidKmxXM
 rvZoRae1+ROEigksA3vUVa7tKL7W1Jkh1pl7g7w5I8SOYrVAJgiPjOCvXX17FtfGtqgSN15F

On 18/06/2025 20:24, John Meneghini wrote:
> From: Sagar Biradar <sagar.biradar@microchip.com>
> 
> From: Sagar Biradar <sagar.biradar@microchip.com>
> 
> This patch fixes a bug in the original path that caused I/O hangs. The
> I/O hangs were because of an MSIx vector not having a mapped online CPU
> upon receiving completion.
> 
> This patch enables Multi-Q support in the aacriad driver. Multi-Q support
> in the driver is needed to support CPU offlining.

I assume that you mean "safe" CPU offlining.

It seems to me that in all cases we use queue interrupt affinity 
spreading and managed interrupts for MSIX, right?

See aac_define_int_mode() -> pci_alloc_irq_vectors(..., PCI_IRQ_MSIX | 
PCI_IRQ_AFFINITY);

But then for this non- Multi-Q support, the queue seems to be chosen 
based on a round-robin approach in the driver. That round-robin comes 
from how fib.vector_no is assigned in aac_fib_vector_assign(). If this 
is the case, then why are managed interrupts being used for this non- 
Multi-Q support at all?

I may be wrong about this. That driver is hard to understand with so 
many knobs.




