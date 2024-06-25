Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B616F1494CB;
	Tue, 25 Jun 2024 12:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719317206; cv=fail; b=e2JUs5H3MguaPpX9lAPU+mlI59D1kObWDFxTPqt3hOK1dATyO9hFE6+15CmHbMrD62C5DzqxdQEGp48ltvbd1GiyMBJJ2Qw6AyqjcCi+OfpQqvzsUCHSV5p4NXyqPFwNTBR15A0cUG0nA6ZXIDzly1TltFVetrwXYU8RvcVnCa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719317206; c=relaxed/simple;
	bh=kzkAt2RTsP+Rd6DMaqY5OJczl60beTJ7fR65gGbIR24=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I6mS0wfM9SQ9QlF2exDQVqNg8HEgb6O12DObHIN48qTWyGjYnsAb7pBqlBXP2PqT0NSRUoAlB/6SpPD5NoiNurInUuELz/UQ0iV5L5ue4Ol8bO3AO4lRdHrxOB7Ce6572CHa+6JNnYtdp8fz2AST8YhC3XspwBWnVtsP9p4SLZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M+N9DwTP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RrNUrIfp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M+N9DwTP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RrNUrIfp"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45P7tTed016649;
	Tue, 25 Jun 2024 12:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=c6qfuLUXwbef+X+gBtBE+Sxtct2oxJkLtwPPeysmwYI=; b=
	M+N9DwTP3BMk2IRErLWU/4yO/siMF6NvoxrkIcO83Z/VDLCppup0K95q/nwB1bzq
	0x5su+ZGIAd0Sml5aPKZ4eJgNJ5jTC7Hb3vN2ithH4taZgNsNdT0VYkPJBWbLoRF
	KwALVD9dNKpXOgLTgqOF/uWpoJoKw9QnLD+7plOXPOliKRJwOf2E2iUEx8voIpBF
	g6eG2+QxfNk941AvXA5mbKSzMFIP4zp0xKPRAOKa2gFuOAL900fcq3O0t7R95Cgq
	9HhdI5Q8FLMlmj7BUsdlq8Ub+Rm9wRYFgl8nrR5Ul5EG7rHR5yckcQyYzGRtENLR
	kV5E5p43H7Tp9X+rX+Q4Rw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywnd2ghaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 12:04:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45PBNQfI001320;
	Tue, 25 Jun 2024 12:04:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn285pkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 12:04:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYwmzkuYtBp8PNXS05urGVca1/Nefh1Alvb9witeYpawm8zhEdJTC7PgCGhJ61pCWL5zInviZB85kZVc1hmQQ5kHa2ImpT1OJdvHHCdnTQj6bWAcU4Gt+PH2WZRBit8PIEeJKKFnxTZyKwRG1bK9MYrXjiqqb3wRfpDGqjINH2Fa4bB0bwf3CPJtvZ2MIJaSWWQtfr62WIWHlzMCEvh51bOgysu2EFCLg9ADru5Zu+37q17lH3sGJYYz8NOjtCSV5qKu0ISsDTaaLQFMj0SJYl/B+IMEr1wdGu5YdS6sOOCw4ecToRcjqbpeMDztv9HlXE9+64GF7OeawC6bGacNDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6qfuLUXwbef+X+gBtBE+Sxtct2oxJkLtwPPeysmwYI=;
 b=HTB98htYhTDbOGcrVo7aV1n/Qhg6UyndM8PxT7CJMFBTo1cUnhWPLAAoP05H/uieHO6X5PwBzWXza0jfKAZ6QC5xWbwkM39+KWnlAxGCbSslC3yHYI5wq6YufNraS4EGOH0zzcHkLgHm1YoSWUgSy9osYdMitgaMcNCx6EuOFJnJkZ7mXBK9yFnFQqAfpS1fapQ5MAy4cCrNckrL5zZejHAQBhoHegm7OIv3fiQTYwULarrieQJ7uCldesxqX6Kc+uGmYd9RLJOVBUMtcIEHqu/5fH2Gqb3dLtmcz+bj6zGfEm933RzkCdTQFf+KPE7HTBznxvWSYhIOjN9s086Pjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6qfuLUXwbef+X+gBtBE+Sxtct2oxJkLtwPPeysmwYI=;
 b=RrNUrIfpATz4aaw1Wzh+OK2GJ8doreQqiPH65oNk3cjr1/diQTsaZ2+a42zwC5o85cpWKThsds2AS8ksFPNXA9U7xVA9SVZq4IicTcUOJElop7ZCUZ5FkF8JqvAaWQjGzqhLG4RwzQt80jux3r8AVHIp+NFf8zYn+xXqmNMI1dU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7810.namprd10.prod.outlook.com (2603:10b6:a03:578::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 12:03:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:03:23 +0000
Message-ID: <7b800a42-e3cb-4c1c-9a29-74907fcb2c8b@oracle.com>
Date: Tue, 25 Jun 2024 13:03:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] block: remove the fallback case in
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
References: <20240625110603.50885-1-hch@lst.de>
 <20240625110603.50885-7-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240625110603.50885-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0061.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: ffb7f3fd-3943-4a9a-0faa-08dc950ed004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|7416011|376011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?Y3BXd2lSU3g4WGlodUNRd3I0cFQ4em5GdVU0eUhOLzJhME14S3QxeEIra3lL?=
 =?utf-8?B?dTE2aEN1OFJ5dVk4MzdBbWpvckpWUGI2R2lUNDhDQlY5NVA1UXlhZnhCUXh1?=
 =?utf-8?B?QjJvQkYxb2paek1FUDdkeWJyWTc5Y01GNnJyV2lmaHdmaGlRcEhEc1ZPR0dW?=
 =?utf-8?B?cUlEU0lqVUlRYUZUVCt5OVY4akJpL2Vta0EzeGdSS2hrcjRJYmtKRWRYUEZV?=
 =?utf-8?B?bERRb2hId1VQQWN1TzNNeXdldFpLRU9TUkVCSDJvQXBwRlBGTFJSSUM4M3lP?=
 =?utf-8?B?MDBWdGhDQmJka2IrUUFRVndjQUdYaGVrT05MOEJDd2o3VkdzQlQ2clJnWmpI?=
 =?utf-8?B?NnZxdlY5VDAzZ3N0V1UzYm9qa1BxblhNRVVHY1FZQkx1V2NLVUVBSWN5endz?=
 =?utf-8?B?bjVheWFGM0lpKzJ0ZVNPcWExTGdMN0hPSDZXNU5aTEhYTmlvU0tvTFNWSDIy?=
 =?utf-8?B?ZmNBaktNbkdST3dvMGNyTGdMNUpkYjNiZkNPZkdWTlJnaWRacnpxWkxmQXRE?=
 =?utf-8?B?eTZ1OVVRZU1oRFBxZXFqWGZEbVowVlNVTXRFdTM3TXdKNEc4eG1JdWh6QnZS?=
 =?utf-8?B?amVSWkRiNXdTQ2FOUzZjZSs3dmhrcWhYT0FtaE05dGJhTFZwZEZJZ2lUckRn?=
 =?utf-8?B?K3VoQWRjQlR4VFhTWi9HcTI3OFdnZ1hpejVhOUNmYUZNYkt5TmlFcmR1eExt?=
 =?utf-8?B?K0tSWk9vY1U0RExDa2RJS3BQMHVROGdSNG5kYU85NytUZ2FiUkVWN3RrNFNB?=
 =?utf-8?B?c2hreTNBYjhxYlY4SXR6TzVER1FoV2kxbTduQjdLUVlLSlRoVlFveUFUTlNp?=
 =?utf-8?B?ZW9BWHFXd1Zsa0szVFdKbmpEbmdJOGp4YUZJWXZSQWthcEVRUzE5V3Y3SHVj?=
 =?utf-8?B?dldvaTU4SmdYSlY3M3ArUU51czVRclA3bGpMNGYrenBwbGt1MmdVOG1wNWxO?=
 =?utf-8?B?bFRnTDJFMC9pV24xQm5EcFVTNjFhSHJhekU2Q0tpQUVoR3UrZDVWZm1BY3lV?=
 =?utf-8?B?NmZWeWtFdWp5Z0xQY2NwbUtOMVl4OC9BTHBMTzljVW1DLzRWVlhMQk56REVG?=
 =?utf-8?B?MDg2ZkxISGM3WVMzZmIrQzVwRENDZ2NDak9ZQk9tK0c4bE1lTFRyWmNKMXhu?=
 =?utf-8?B?NVhKVmRjRG9LTzVDK0daYWNYOS80S3lMaEtIN3lqRUgxcHFVQ1ZsME55TE9Y?=
 =?utf-8?B?anIvVWowTXJ6cTI4OWI3ZDQybmExaWN5bjYzSUpUSjYzd2lDalFVVUtva3Ji?=
 =?utf-8?B?SC9tdW80dTNkcWdvamxSUDlBZldGenp0MkhsZVB6c2tVckN1SHV0dkhoeWMx?=
 =?utf-8?B?RzkxU1lPa0NDaE1rSXdGNzcvK2pGZ3JwVzBtQ2hoNlN0Y3ZFei94WWZzbWlp?=
 =?utf-8?B?N2F2WWJZNUVPeFBpVG5RM2VieGZsaWN0NW1wTFFNWmkxalg2RnhqNnNJVitS?=
 =?utf-8?B?ME9NOG5RSm4vYk9LVVBjTkxKYWtMNmFxYjk1emxSbWdWdGdUU05QSGZiZ0Jz?=
 =?utf-8?B?cjNTUkJ5dGNlREpGTitHZ3lGbUhUTk1vVHBOY3k2SUpUeXpoYVVTbDdPNXB4?=
 =?utf-8?B?cE1CdE9qUDNXci9rOVRZSjlFRkUwLzFMUjFqUHFqa1R2Y21kM0xwWFdYQWdM?=
 =?utf-8?B?bTVVVFZPVnNZOXpjQjRvQjQxcHRDVlB4THpnb3JyTEthSFdTdTlZZFEzQ1NW?=
 =?utf-8?B?Q1V0ZlZiOVRYT0dBWUdUME5pUm1vcmI2azIvQzdzbDVDQ29PaC9UR2NCbi9T?=
 =?utf-8?B?akhPWEF3ajNMRjFuYS9EK1c0SWhUSU1mL2tPVjJsUmc4aVZqeGl3eDYxa0Ra?=
 =?utf-8?B?bHhtaUNSaGZndDJNQUlCdz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(7416011)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Z0UyMnBkOWgybTJUTFN5Q28rYmtUK0ZlR1laOEp5TFRscEhLd296ZDE1MXli?=
 =?utf-8?B?VjlDbVZoUmVvWDNWN0hlYVJhdy9RS3AyWnk2YU1BT3lnM29La0h6Z014UjE4?=
 =?utf-8?B?Ym9BLzVNdm1BU0tzcGlZU3JLOEJ0S1NoM2VMZlEwRkRscnNLdEM5b0RqVklq?=
 =?utf-8?B?cGY3aUw4OE5TdVZxa2EwMEE2QVBtWGxjNXJZVlMyWnJUVGpId3E1ZmRheHlu?=
 =?utf-8?B?WXI0cnNhckE1S0txU3c4YVl6cHYwRDlmeWNLQmRLMzNlZmZja3Rxb2dxVDcy?=
 =?utf-8?B?Y2kySFhOVkN6dkFISjl0NldrNCt2b3BiUjA1Y1ZMNDZER1FQSFBZeXdZeSs1?=
 =?utf-8?B?dGtQb0huWWsyaE8yZW1ZNUVlbkFYWWlUV3ZTQnRTdXVPUXhkZ0sxa2pCYzR6?=
 =?utf-8?B?YW91dUJzdlJURTBtcURpanpIOEZBZUhzNERDZ0I5ekwxWlAxRGN4ZEtkdXds?=
 =?utf-8?B?bnRkNy9Qd09TcXljV2FIQXkxWkZQYVp2T0VNdkxBQnMrLzh6MDAxZ2RCMmVS?=
 =?utf-8?B?c1hYN1NOZkQ3VHFiV0h0V1VVSzhLR2gyN1FaUmJYZGpEbG54YThSbTY1M0pO?=
 =?utf-8?B?SFdJQVNjbHJadmUwcURnVzNjMnplV25NZ1lEcER2dWxVRWZRaGVEeXo5RmJB?=
 =?utf-8?B?Mm9lb2p4R1BRSmcyOGJEait1Qy9rMkt3d1A2ZGlnQU15emtwM0t1ODd6RktM?=
 =?utf-8?B?LytDeGNjZWZCOFl0VW9kbzUzcm9kL1NyUytDdGR3OXBBUGdlT0tCVGdGeldo?=
 =?utf-8?B?akdOYWwrbVArbVpqZklBT3gwZUdrVnNTSUFweHBmRnM4d3dESmNkc0NEQjBi?=
 =?utf-8?B?MUNWMVdhTXdrUndNY3gzdVBlVFFCOVBOZmZCajkvVHJtc2FJdzhhU1NsUVJy?=
 =?utf-8?B?UU9YTFVrVmxwUGgzcW9PaXVsQjhPU0hJdytPWnowQUVzdWk5eTlzVlZVSVIw?=
 =?utf-8?B?d1EzMUNhY3dZbDhBUDgvZDA5UGc0cXpwSkhWdlJENVZFMjVpYStBOUxibFhz?=
 =?utf-8?B?Z2xqZ2lUZ2xGYjVLbG1DaURFNmJIdldWRTZDVjk4dkRJenNIenI4OGk5dy81?=
 =?utf-8?B?R0FxWVZzalV6Y3BkRGh4ZFBTWk5KYmhHOVBTWE5CQUhYVlpEOGlIOFZYcXBM?=
 =?utf-8?B?VHlVekVPdVFaeUlzNkRSVFJqYUdENmIvdG5UczlxTzlRNTBBTVBUd21pTTB2?=
 =?utf-8?B?OFNRc3hBUjMzSHhGVEUyOXBHb213MEoxSU1tVXhKbHZOVU5RZEJ5TEY1Z1NG?=
 =?utf-8?B?UnJXYU5rVkxoWFJmMG5EQnovaURDOU5WNHUzSExBSU1UNGg1em5OSmVFR082?=
 =?utf-8?B?WDFVWENLaWkzL2dnYTNBU01wSTBTU2FnOWJEbCtPcHJZdVNScWNVQkNLdlRU?=
 =?utf-8?B?M3B4RTFCeERLKzFLTG9ESThFNjYvZ3IyUnhRcHFHckt1NWZWeVJ1WXNDWDlt?=
 =?utf-8?B?UGZPY01SbmdTMlE3bHdXV3V6QXJZQlN1R09NUVlaSyt5SUg1NUpxeXo1V29G?=
 =?utf-8?B?Y3ZuZURuSEpuckR1NGMvMDBFbzRmdHpRcjlDY0lhbmxyRjVVYllCMlpWTm9q?=
 =?utf-8?B?bS9vdEc3NFBnODl6blBKaUxYM25VNFB6Rk1abFZPK1RZSlV3U2d6c1h5WGNK?=
 =?utf-8?B?b3NJeTl0ZEdRejlkR1JjVGdoaUNnZ2JpRWUzb1lnclhwaEdCZXNiZDhwUnk5?=
 =?utf-8?B?UnBsQStweDZiT1Naek90UTFZU3llTUJ5eTlJQnliTWl4TThDQkR6eFc0YzdV?=
 =?utf-8?B?c1dacm45SDZTVHoxMUc5NitQV3l1SVRDVTFmZWN2cGVLeWZCSGtXZDQvaXNX?=
 =?utf-8?B?UU1KSE9TOEswcGN2Vkl0TUo2YXNiTk16dkpPVVBFRS9ObTQxRlhCUFJNTHB3?=
 =?utf-8?B?ZDIrNXZGZmVOQ2krZVYwZnFxTmttMlZ5M2MveXRINGNqUjMxN3BhSDFRbGVK?=
 =?utf-8?B?UExOa1BMOG5EaGtSZVJwYW5vSUNJV1pjUExiS2NiQWRDZSttVjR4WXhuTXBz?=
 =?utf-8?B?TFlQZDRtallSSXM5eWtTWERKaWREWVhwMERqb0F1Vk1GaEtsY01wajlIS0FV?=
 =?utf-8?B?TzdQN2xaYkwzL083WitzNTVicGZGakQ5U2lmeSttYVBYeS9vVVNtdFRXT1lO?=
 =?utf-8?B?RVphQk8zLzdEeWU5VjBXdHlCNmVmQm50MVF6OE5OQjNLV2MyWTVLQWZUS0ly?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/Xz+72msLJM2SjK30bv7Q853+fPoI6U/wic9x5LQERXVt69St8XnyZR0UgwQm34y4THCXFAYdfqnu/1eO7fAwIHgKRKEF1mnfoBE7GVHYklEsksXiqttCXqQP+LXvmeRwaMaXmpjUkGKM7fbfWiEAn90oAMHFBc3XcccVb60p8v8SK/oZvlXUjefrKxUCAkmzuYQiC9nqHggSEYfhtRhP4fQIyCuUc7z4ljWBHGpyBOQJ2rbf3mWtmuCaqN9nKjBVwzFDHoOwS3N7aktV4Ftz08eyDNy9XqOWoCRRnYsZ3cJinZgwadLw17D6ajw/PsXpAtTJ1H3FTgN4mAAi5y5NMZrUeS9P8KNuE/bU6EEMJ1oAE+79iW/vqKv4dSSp/pLPzC7225jykazHOB8bPVFDLG/TaqYH4IHa1JfBHX3pSimEsGboxbtxqmGiP1ClhwakVZC1aCqRbgRr8M/j9iuojNR0UVouML1WrWYU1tZFmZDXnM3Eg/4ZqRvYOtTBxl8tkhDteEBq5zhdBnltK4OAYWxPrxa7G/9teQIMwgrEyLYFByyTOy5X8fvTsaSZaBhMF/TBvMw4+hwzpoWbI2fduFWnZhfCx1JYbvZrpw/lNk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb7f3fd-3943-4a9a-0faa-08dc950ed004
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:03:23.3734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kOPb8xh2O0UDqhuwOymr41+rLU84g6T9T9lyMozONs31Cf9/zyYGnaTyo6I79VsUMp20pzf53I0ARGzWZtmDsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_07,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406250089
X-Proofpoint-ORIG-GUID: tZ-dR77_itDy8r-n486GRN6t59Ixn7gC
X-Proofpoint-GUID: tZ-dR77_itDy8r-n486GRN6t59Ixn7gC

On 25/06/2024 12:05, Christoph Hellwig wrote:
> Now that all updates go through blk_validate_limits the default of 511
> is set at initialization time.

The code handles q == NULL case, so is q == NULL now impossible?

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   include/linux/blkdev.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index e23fc418bb2260..d93fba7a1f3162 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1393,7 +1393,7 @@ static inline bool bdev_is_zone_start(struct block_device *bdev,
>   
>   static inline int queue_dma_alignment(const struct request_queue *q)
>   {
> -	return q ? q->limits.dma_alignment : 511;
> +	return q->limits.dma_alignment;
>   }
>   
>   static inline unsigned int

