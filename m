Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3D220CCF0;
	Fri, 10 Jan 2025 09:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500538; cv=fail; b=ozka+Rd4ASSFRZpD19szf3bp5/e78p9OlnCzxmkOGaG+p9DjNQzoEp933o3ok1T0LB1l0Hk9ZcDcimpLCJ2z8+tu2pBPHXxjXt1Ql4iEHa4A6RtHZSa8RZsHci9/NMUMe2wxV0yDZxMDtfDXAXDehbAN0cSQ22U5+UGVYYfl4ew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500538; c=relaxed/simple;
	bh=Wh+nYMTXydRdyiwvfmozMRYL8saCarB3+GHewAGd5T8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U7C5oxgwRrg1dT/oa3ClZhlVohJJrivl3HrX+CDEzpmyWhgG82e4VkMv0zv7X2YDsCGwXiF039/JL4sbdr2Vfzr2gYy5A/Q3G80K+IBr7nABky7wTCuip5q9gFB/pDIZ9E5eCPNLp0mVKzbwhOHq60qkQuTqQyPgxVefnngC+Lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gwhozbXr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bzhY7yux; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gwhozbXr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bzhY7yux"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50A9D0N2001608;
	Fri, 10 Jan 2025 09:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Hi8tCagu44SUaYVEl2t5gui7QuO5cd1aCtgESjrr+50=; b=
	gwhozbXrhjVA/cQW8lAWgv/GNkj6WDA8/OUEY8+B9IETWHiKLaFHSo+g+1C8tzOR
	Iw5Wxz+0K4RPD0DkT2ptRtV8ljQSsT3uIu4fqQD4kue7LDcUf3TK6SVt+jWFRKf/
	bFigSLNZjaGNjbL5NL3yDz2RzoAZiumMlaQCMGCjC7VHD6Q/IKLJ3d8SQ48pyFg+
	3NzfG16rcm9nExsxRYmIIReVFRfmbGkhbKbBstbrrslMk8zD1ztVBJ1XperF4HmQ
	ZWLLa183AmCAIo/tSkoIEahHDftoj+3uWw31we1nY3vrk7kUccatYtxSwsRIrmy3
	9wlXMYWl/MNvYll1Bt8N5Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk0aws9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 09:15:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50A80B2L002809;
	Fri, 10 Jan 2025 09:15:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuec6wm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 09:15:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QHu30TbumOuhdDoS9UqgtbQUpYju8m7zEKKA03tcDCi8GcsoWEoK99oxno2c+Tgi/ipXFP1Nqje/ivSK8dk/7E6B6iDIM2/5TQTLDObpr60/1jNSH3zqKM+dcU3KwvzLL9ETrf56bhy3lmIK8oVzUjR0ML8xn1F7+19iIVGKjq7rdGJXHSK2DuBdzh5VnKGrvC6Joltj3qIGsgQlLZhY+bYBEuP/dZbRY+t1+UG+WEP6Qs8rjTFriCh52T9bTePdaAQiUw8L4FBAB+D4wRDeswBsi3V97V9CsbtsHEAWkRDcBakmvdv+im3XgE4cSmabJ1qi7s6+UiFdLfMUmmm8UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hi8tCagu44SUaYVEl2t5gui7QuO5cd1aCtgESjrr+50=;
 b=yk5l65DrKiWhd1zJyXF8DSCzwwmBWl+LgPc+KS5axaIZxe/BBDfyhLZqqoHzu07xHYP3g2ftGotRkmNQMrdatfosThMJBLsHyU3q/DQJPI4ZT2/Kzi5kz9UXnB3n04IEWLzTJCpR+kJHJCwvbkEIqqrmyHyLZN7aSAtHTXhPeREzWtT+nRZro83GwgrtfKHIMfnD4HURraZul5f/Ns3cJjEpAifShFoJvq9Et0TS3S+NZ1xZ/6Yo+cIve5hwpCAJzAVbHBGTyG3+1HnhEDeBszBT4p0PmUt86pbWroSrGxzvVF2aJEg3Uzl7Ld9RovbGDT/kGcyQsS/8al10Lss92w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hi8tCagu44SUaYVEl2t5gui7QuO5cd1aCtgESjrr+50=;
 b=bzhY7yuxt4FuouV1WhapY4mTH8nhvaUmixoGz62LimvIohOae7oZRuCLAknTrOIjjGhDBfpi3VpawFunmYQY1q3Yruqgtc+2a8XCj/sukNR/0xsIQ1H/3Rukx2HXY/iFNkkpu0AaG6nRfBPB3V03NNGnazuZeERvsWvZ4gZaSM4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5672.namprd10.prod.outlook.com (2603:10b6:a03:3ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Fri, 10 Jan
 2025 09:15:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 09:15:12 +0000
Message-ID: <e7177a33-aebd-4828-87b0-f790b4fb1306@oracle.com>
Date: Fri, 10 Jan 2025 09:15:09 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] block: add a store_limit operations for sysfs
 entries
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250110054726.1499538-1-hch@lst.de>
 <20250110054726.1499538-6-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250110054726.1499538-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0231.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: bb587e2f-e2e4-4066-7aee-08dd315749a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGd6WkgvVUhSQVZVcHg3eXdEaDhCZWxTZ2RjakkwbDV5c2tBRmNaT2ZsZ1Vk?=
 =?utf-8?B?TWZnZjY4L1F1RzVjV0VVekFhWnZ3YkxpaTNPMUdJRTI5ZVZHc2NJZi9jVUty?=
 =?utf-8?B?UlMzWnVKaVFwSFFoWlBWaDdQcDFHYXBESGtidWJXbmgxdmRtRlIzTUNRczB4?=
 =?utf-8?B?SVJYUURjMnR0emlNVC92VHVjTXhWSW91cGI0TTZUcS9Wb2xtT09wVU9XSC9h?=
 =?utf-8?B?Snh6akpXelhBMmRVTGdOa2FjMENnMGd6aklSWXIzNUF2Q1VKTy9PSEpTbGk5?=
 =?utf-8?B?bmlvenlyNmg0QkJzcUZvQzRIVzdSb0R6RmI2dVRFOE9oTHVlT1dWTURwcEp6?=
 =?utf-8?B?RVlZZjhVQnZKRmRNNVoxOTgvVWREL3RMajVkR0EvVWRxakFoVDFVWExVU0Nv?=
 =?utf-8?B?ZWhRVlhCcDdjL3VibEVIZlVPY2djeE5NdnBwcmM3QlZZeHJaeGNjU2Ivd2RO?=
 =?utf-8?B?MXUzYmxZLzlXUEd4ZG5ieUZrc0ZPYjRYc0l1UzV3WnR4RVltWXZGTHpiZE04?=
 =?utf-8?B?L1JxeDJSZHVybmxIV2RHR3QwNU9QUytJUWNlSFE0c2ZZL0poK2Y0ZTdTOFVs?=
 =?utf-8?B?TmpTNG1vVHdNZkttdFVlK3NpTHowWmxyYVg0VHN1Y0Jtb0M5ZEJFdjY1L0k4?=
 =?utf-8?B?REVwdSthOHJBdzF4UWJjU2tzZmVHOEd4Si9uWU9lM3FhYVdXMERtSWpkTGJK?=
 =?utf-8?B?UDdzYkd4cEE5ZXgrcUhNWE91ZnA2WXRoVC9Ta3NHZStlNlZaUmlPelpYaXhu?=
 =?utf-8?B?eHUxTVRMaHVabmxnMEJOODI3QTVBSkJpZlVOaHlqNytFYkZwc1BsMUVPTFhZ?=
 =?utf-8?B?dGVsSjZ6ZE1ta05aeWZMSVB1MTFid05XcTBYYVFmY2NOZGFCRmtSMFNCZ21X?=
 =?utf-8?B?WG92YWEwcEpiTGxwcVdVK0hUcU5hWmFEaWlrMlNwS25iUjA1YjdjK3FhNUNO?=
 =?utf-8?B?ZWxRY2ZmU2trREVTK1dBcHNTWmwvY1BSdW5WQWlYRXcrc2pGRU5kaFJCRldo?=
 =?utf-8?B?L21lN0MyZzU4UGwrOHNvaGxTVHhoTEZldDNTVEFTV2tITzdDd1JlU0N1N0dF?=
 =?utf-8?B?VFRBZHF0ZEtHWDdQaU1pN01ZU2FvRVVHaGEyRU4xMTNxQUxJRkgvREh0QkF3?=
 =?utf-8?B?VVp0M1FSSFJabXhSSGlsVUYzRStNTVpRWGxWd0NYUkhvV3REY0RlR1gzZjJS?=
 =?utf-8?B?VGJLOTcxTG1TMjZpSlBlSTJNNkk3SXR1K0JRUys5cVhXalpOS0EvOWJqeUF1?=
 =?utf-8?B?NmttcU5pV3JhWDN1WGxpV3ZXVVFpL2pEdTljY05vYk5YRjZDbllWWWxxU3oy?=
 =?utf-8?B?TXc0d2RGcTZTYXk3OHZpK0hnandqWW81ZjV2MmJRcE0wM05GTWlxS2NvcVRT?=
 =?utf-8?B?T3pIMVRIMCtGejBjMWc1RWtFN09UZjJ3c2F0Z3hpZWFNdVhYVmdua1Y4UHdE?=
 =?utf-8?B?a0NXTkRRMTZWNkNSSjNFZ2FMeXRRandvRUhxYklhQW95bWtkZWZZMDkxMUNE?=
 =?utf-8?B?YnQ2NmlCTzhoVHUvSUc0Z1c2bVNUL1I0U1JLa3NpMjdLcjlPNHU1cWVFa3FH?=
 =?utf-8?B?Rnd4aWxoa1U5bkFXOTUwRENOcDA1SmtzTzZQbVd4T2tVUFNLWm5FdjJyT2l5?=
 =?utf-8?B?cUkwNHNoaUFPemZDSjZSOGtwcXJrdWNCT0N4VDlublBYaktnak5ydy8rdFBJ?=
 =?utf-8?B?THFZQWZOZFp6K092NkRNTUZ2N2d1TUtQYnBGN1JpSWxwUDl1ZVovTTRIYWt1?=
 =?utf-8?B?WmhvUkpxbWlEM09kZU16R1VtQlRtTVBRNVdiVjRHWHgrenE4YVdNTEdDOGFY?=
 =?utf-8?B?U2dTWEtPdmc0R2N2U0w0dHdBb3p5MzRGbzFLc0dLcTVLUkVkdHRla0Y5SUpm?=
 =?utf-8?Q?FDMp6u1mh7gst?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEJMa0JQTWVMN01uUXY2aEMwaDFoUHRDY29oWlpyT3BZZSsyM3dqUUw4Qzdh?=
 =?utf-8?B?cUNxcWRFZUJBV2hBL3NVOGh6TTFkbXozQ2dJMHJONnZWZVE4d3Q4Q09DemdI?=
 =?utf-8?B?dWRjbzRuRU9Ca0tWZ1E1bVlVQ0JPbUgwdUhKQnc2TjlNRHRnZWo0TEdIeVNV?=
 =?utf-8?B?QS9Bc29sTXl5cWNBUmZQSm5Rcms3YlFuVy9oclkxK0p1VlpWaWgzWitVS01h?=
 =?utf-8?B?emZuc2Zwd0daMXgwbS9sbWYxbTZzZFlxdkhoV3o1UGxVYkhCaENhclVuYzVV?=
 =?utf-8?B?NXo5ZGdoUHl4ZU1ZTTBHWXNUTk5HaUFCLzlxNXAwUS9Nc1hLdHZrZ1c3TGU3?=
 =?utf-8?B?cVRvdXB6UUsxK2VkTW1ZUkg2STlhd0dGYVFxeWd1WjFsR3VVa3VSYVR0NVBC?=
 =?utf-8?B?V09UMEJlUUd4RnlKRnBRV1hWSXdDR2FXb3p3ck1FOFVnSHRnbVhSb0lWWnhl?=
 =?utf-8?B?QlhvTWxEZHQwdU83dEFxTmQyNGVYL1NkY2VTZlI3LzRBdklTa09HbzhoS0lT?=
 =?utf-8?B?TVNBR2pOVmppVUEzRktSY1FVMzRDVC83SDJEZVMxK010OHdmWXN1azRvU09N?=
 =?utf-8?B?TDIvOWlaWnllYk5rTVFiN3RiRVRxbVF4R09IZjRjYnhzaTFsNm9seThQMXgr?=
 =?utf-8?B?TWJhNXd0ZTgycVpLWTBuK040cnI1TlBNdXlDbVNTbUppVGV0dkh4VitCalVN?=
 =?utf-8?B?cU4vRW1TSStES3NCTE9sNXdQR2JQWkpSRnVzN1QxczcwTUpZK1lGUitaMUZz?=
 =?utf-8?B?Rk5lN081MEVKOFlwS3FYdk5FTUljWVpoY3lsbzd4RklTN1JENldXSUdqWTZP?=
 =?utf-8?B?bnpoaHdsbm5NczUyYm5UTHY3YlV0ZU9KSzAwM243bHcwQVVBRDlKWUduNEpB?=
 =?utf-8?B?WGVGN09LRC9McXJvczJBMnI2VHdrck5ySmkza0pnWmZiZlhJRDl4Z09ZT2gv?=
 =?utf-8?B?N3lxQ1prSWhzL3FDK3hxbFUweklYMXpST1poRlo5SEMwUWYzWjVEallOVHFL?=
 =?utf-8?B?ZnR4TU91dmg0TUdhSUYrSjFCVWxWWklMYjJSb1ZVcHZTMEdvV2FzQWVLNHJH?=
 =?utf-8?B?ZTEzTSt3QTY4NlM0NVJhbEppNWJib3FyTEtmSmljUzgxYldxTk1DSGgvYTgx?=
 =?utf-8?B?UGxJZ29QNHM2UGhJRHJ0NldMRkJNVGJySnRORkYvUzRNdm5kR3Yzck16QTBo?=
 =?utf-8?B?Z2RyNTNoMC9HczJYelRYRmtoOGZqQS9WZzdDT3MxdGtNcXo5L0pUbTZLUzZ2?=
 =?utf-8?B?TDhPY3Uzb1g2VEV4RUJ2NUU2cEEwZCtqUHZkM2h0bWtqUzYwOURqM0R5YzBp?=
 =?utf-8?B?SmN3Tzc0RWNlQjlDd2VKc0ROOGJyTXFCWURjd1lYemdubnhBQ203aGhPUFBT?=
 =?utf-8?B?Tmo0ME1PTTVtM2hoOXFLSzZvU0RxajJjcGhmVllmK2NkNENEVWI5Z0xsc0Rh?=
 =?utf-8?B?WUEwTmxjSDF0cTMza2tzdWdSTGZ0MVZnMWt6QStrM2p3Qjl3cmthckJ1V0NB?=
 =?utf-8?B?UmUrK29mVXNGMlNQWWdpQytOb0daUU5kemZ4L1RydU9BTTBtZFFMcVQzOHBp?=
 =?utf-8?B?Vlk2U2gwV2txd2IrMU13UzRuWHpCTUdOMkZHdXZPdTllSDJmNnVMUVNubnpo?=
 =?utf-8?B?K2JIRFg0YVgwTytJWHBJQWErVU52cmhGRyswL3lHclJBYmtnRXV2Vk94VUYx?=
 =?utf-8?B?TndrM3YxZ2ttVWo3UEJ0WjEwbG1hTEo2MDZ4YWZKa3Y4WFJ4cWdFNkkyVWF1?=
 =?utf-8?B?aHZZNHdyM0pjSTdBVjE4SUYwYm15ejBtTmxGNjFaRHpGQWsyL2RWOXl2dlhh?=
 =?utf-8?B?cEpEaUI2QmhpYjVpbHcvUjZISUxjdmRXOFo0UG05a3FRSVpDMFlGc1hJWkcy?=
 =?utf-8?B?SWlVMDNxZ042eTdxTVFqT3ZxbWxJY2ZIM2JUMHpDblY3TG5iT2xVb2hoTnla?=
 =?utf-8?B?T0laNE50TG5VSlAremlIY2JRWUVYdGtHbkZxTVV1S2ZJcUVvUk5oUzRKenh3?=
 =?utf-8?B?SFNLQW5uQTNMZDlCeHJqQWs3WmMraDY5RlhZSXNZNWRpYmF4T2pGbW4yRkhk?=
 =?utf-8?B?cjBYM2tibmp0QjJjaE9qcjRpLzdlRDFXVUp6dHFUWmZKSDgxd2VDOEtCMXYw?=
 =?utf-8?B?Q3ZsZEZQTzZCbjVudGpaclVRM011dERSaXNVVkl2dVRkcjVyWFV1emoyY1ZC?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rt9eJ2DOjz7p6GUtWBd032QZY6K5pVzS3bwvTBoPLhrJCDx/1jS1zyeJFp+Dyn9JjqQTYfLaiTagYXxdesCASEFuH5kXGpoA/cbE897b2m43qV/zMUMzB/ZGSpe8QYw8yTDfiRm27Pf4ly23uoBBOGq0seVfoVZfHEc9TrK5Futbal1XRCeOe+7f+FWAq1Dv+4JZILMddGJEKZWwIw4H+J8Toz7Q5Hjtc0D/RBlf6o53Wfa3GecPovmhIpsqYm/CHplPB7RYPpAfgTTEetLu9mx9jqfG/zkeTtBr36GjlHbwrl76JaUuXv22h5S1DbjbXyg/bBi+D70bxoU8CSZnCFOx+mFHdnCAEzuydNI448Ozp4iackI0onxqN9qhlHCO8sn1mOeMiJ2s89OSS7JTlgSKbXgNfyStJS9MfWRxqedlVuwpPngforRg40tT0pPS+KvA2JOk7Hq1UXstqn5u4Sek/VUiSAVYnRNssqYB03Pg345lvJm1ydNsfGAS07JrkIgMafezZ934l1jaOf3hcVt9VYZDkhtV6TOkRtLw7dKoe7vyZ2qAm6vXBU45hkMnTy8MV4Oh/c1uO66niPYoS19+rNyWnqYS6VAxLmGNqkU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb587e2f-e2e4-4066-7aee-08dd315749a5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 09:15:12.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aoJd7aHoKZwtuyF7D+L5ebQvCiKRA0OeOQQyFQNe2gnU0HPoONjR/0FWz3zA5pCS0IyX/YXVpPCG0ErnT9PLFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_04,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100076
X-Proofpoint-ORIG-GUID: QcyxYr1F3t4YTE_7pWILxFTRzUKpRl-4
X-Proofpoint-GUID: QcyxYr1F3t4YTE_7pWILxFTRzUKpRl-4

On 10/01/2025 05:47, Christoph Hellwig wrote:
> De-duplicate the code for updating queue limits by adding a store_limit
> method that allows having common code handle the actual queue limits
> update.
> 
> Note that this is a pure refactoring patch and does not address the
> existing freeze vs limits lock order problem in the refactored code,
> which will be addressed next.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Apart from the comment on types, below:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   block/blk-sysfs.c | 128 ++++++++++++++++++++++------------------------
>   1 file changed, 61 insertions(+), 67 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index e9f1c82b2f3e..d2aa2177e4ba 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -24,6 +24,8 @@ struct queue_sysfs_entry {
>   	struct attribute attr;
>   	ssize_t (*show)(struct gendisk *disk, char *page);
>   	ssize_t (*store)(struct gendisk *disk, const char *page, size_t count);
> +	int (*store_limit)(struct gendisk *disk, const char *page,

I don't really see why this returns an int, while the queue features 
callback methods return a ssize_t. I know that the res variable in 
queue_attr_store() gets mixed with an int for updating the queue limits, 
but I don't see that as a reason to use int here.

> +			size_t count, struct queue_limits *lim);
>   	void (*load_module)(struct gendisk *disk, const char *page, size_t count);
>   };
>   
> @@ -153,13 +155,11 @@ QUEUE_SYSFS_SHOW_CONST(discard_zeroes_data, 0)
>   QUEUE_SYSFS_SHOW_CONST(write_same_max, 0)
>   QUEUE_SYSFS_SHOW_CONST(poll_delay, -1)
>   

