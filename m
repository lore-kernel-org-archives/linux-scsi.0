Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446BB19DF79;
	Tue,  9 Jul 2024 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541400; cv=fail; b=NHsJ0a+XU5KbSWCh7R5LZGjsvSJ+X/zoh+FPzRx7FXXNauVEWUGqe77QNp0q1516bnMiSXolFiOBrV+bGyDQ7CoI3mSPTinTuuw+jXYBIwfJ5W0yYCQKl/K/3pqzli40Art3DbkwNFj81Q+2lU+avzLESQ3OLql6ckGCGSg4yh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541400; c=relaxed/simple;
	bh=UZxuE/DGmvRGqZwW684/LhiO9n6C81vXKpnyq90HZpE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kmUvrwh6B/T+FuYKQgePMLyUpkiNj4zsQymHidyohHwKObfyUvAtxmp7u3nbWUc47qQU1kf42LFlYzwR25wKL9LSXRL2izD5MqQrl1Wetg92RrR72BAGlIT3gQwwMFMEmCpAsFNCSpKcshJmAF8yAn7StS9v0vMEMWvA41m5qzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P1gfdL9j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tMocRIcw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P1gfdL9j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tMocRIcw"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtUDR031774;
	Tue, 9 Jul 2024 16:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=SbAUcVk408baA+XFVzjM0P94HC4eFAp5meqS+p2s/Is=; b=
	P1gfdL9jkm0q56O6Gu4WH/uK4TAdNhnRRfgd3aiG1aiWAslxnVtTmjhDR7Kqqz+3
	ysnIt2eFZBS3kHXsV3ESLIX3MLasTxZze5k2xLiPdRgjMhVccOMLiepctdWsz7Hh
	GndHNML2/6KrxhqPoaIIVLilGfzRrw/SSbPZScRil+2NxwZHhqQg78PDy7IYC4di
	+CdAZgojTCVGlKn1cT8/izrCtrcDp5hHZwFqQlLB5u3Nnayx+PABChx92tPw/Tv0
	5a7341tlwiGrxdw7tK/LfowEvE3PBkNSB6eNNyU7WtEZ9ONw+Woz+ZZExdoQCfo0
	tpumTmx1HXgAdwlVoiKVMA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wybndgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jul 2024 16:09:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469Es76r005700;
	Tue, 9 Jul 2024 16:09:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407tx2xxvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jul 2024 16:09:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKuxNrD1KKb6/fWEREkrdB3l/Hwh1UXObGL/VYVd0TjkABoN6sS0dtJx/53Z03bwXttU6JixpRAUQubjeMBuiNzZ5gV4TXajG8EPsW9Ob4eTuFWEfCzKoOg0D/WAPRb0nx/rUdiEJ6BAXaLFSOdmueG+MJHWJ9TDe04ZZCiPlGVl6zVTm04mLQ2aChl4iyfe91WHaC6zZLpgltsipjJm+KTVTRAf0vfEMmyNe7DczNIxyAij3nN2ce6lsvL1you1T1Rm4qqwoYR7c3smqdqw8xwshrJL6XvjdZHfYLDuTSD1JO19vj+6hjg9MyyX20U6s2CwZWVqRqYuXEdi6dtZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SbAUcVk408baA+XFVzjM0P94HC4eFAp5meqS+p2s/Is=;
 b=N6JopSwW+mEw+RwoOccYZmp+MGDK8O/xW8fkl3QeevxPX3oZqLTewjDyBAN3x1S4n38CUzZ4GKhGHaTrfXeZ/oygO95Tqo6Bnuffgvz4fTiN8YzD4AoDmHb3w0SlgjodWSJ4Lmi4DLG1IocA/8L7uc74MQXd/w6IsF62D0tvom/7L+dJYGO1q3rDU0JS2YkcOOCsZBOkEBzp8MP98UB+9OXiMT+LOtPRIHFesBRd/cUoZtGf/iP7HjzjV8ltymNP8SErpP2IJ1V8LdkI4o5OZJWx2v5L+GG+V/YsQEr0PdJbPlhhpWHk0d2KIMXlKGPVwG9duCqd5jM8CH92mO84Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbAUcVk408baA+XFVzjM0P94HC4eFAp5meqS+p2s/Is=;
 b=tMocRIcwGIMfY4wssnhegF4gN3+us8qlhOsuOxXg8vpIRCsSkCYbTrsPooqDs+3fwUc5MzpNTXIof556dqslVCQQn6rcdn/oe5AB8dFRsdpbTHhsQygRB8zy+R0DPDjO9ZA7nnEFxW00u/ek3ELMiREYuHgxF/Mw6fPgCoc+atM=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by PH7PR10MB7804.namprd10.prod.outlook.com (2603:10b6:510:2fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 16:09:48 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%4]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 16:09:48 +0000
Message-ID: <784f6b4a-7c43-4484-988e-73fad594c99d@oracle.com>
Date: Tue, 9 Jul 2024 17:09:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: pm80xx: Remove msleep() loop from
 pm8001_dev_gone_notify()
To: TJ Adams <tadamsjr@google.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
References: <20240709160013.634308-1-tadamsjr@google.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240709160013.634308-1-tadamsjr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::32)
 To CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|PH7PR10MB7804:EE_
X-MS-Office365-Filtering-Correlation-Id: 56651c56-c234-454e-6574-08dca0318dde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?VjlvdzVScUc3V0VwUlE3OVQ3bzIwY2ZiSUhRaWExdDNMSE0ySSswdnp1MFRQ?=
 =?utf-8?B?WS9PemdWNGpGSVNRbDU3T29IUUEycFdac3JOZHV3ZGl3T21ZODhVb2ROTVRk?=
 =?utf-8?B?OVdWWEFaVklnOFBrQjFTWWZlci8xVjBYekZ4dWViSlVxU0RFTzk1bFVFa1h3?=
 =?utf-8?B?eFJ1QnovZEM5cGtTQUNlS1lZNXFLK21SUXdzVm9WTXV6akk4elhsd1RsbmM2?=
 =?utf-8?B?elZFTVRYM1JUUEhnZk1IR2Vua2RnWS9ueWpYUnJablpjYXlsR3FTTmt4K3V5?=
 =?utf-8?B?aStETWNTc3lJcU1VeXZib2RUeVBTcERxOVVxK0NOT1htd2k5WDMwdVFPbHNQ?=
 =?utf-8?B?UFRML1RXcnhScHNHakxMOVhRM1JQb3hSNElnT1JScFQ0d3ArZlhBVzd3clRX?=
 =?utf-8?B?VXF3Y3d3Q2NaZ013QnRnK0FlQ1RUYk56aE9XQkRTTjhCSTNOTndMRjlSRkg5?=
 =?utf-8?B?eDJESDlNWEVjRlVkWmxLWEZ3b0hLOXI0czh5RUpCc1RDeFc4UnVXTmxNakwr?=
 =?utf-8?B?WE9oZjUycnN6eFRHazhNQkFSKzZUZTBJMVNrRUQvakhVVkdXS0hqV1o5QUhk?=
 =?utf-8?B?eEpyLytwVVJxZTQzWUdTekh3VFgxQXlCZGxjQlBPSm4vbDRPNURnQjVpSER2?=
 =?utf-8?B?cmVmUkVrY3BodEMwbFk2eGVFWGdMWm8ydnVVNFI2ZXg0TzdBMEMrMXlMY29T?=
 =?utf-8?B?cmpYb2o0a2s4S2pDQzlRZ1AwVDFLUGphdjMrWEpzMmJMMk9XaE1kK29qSTdE?=
 =?utf-8?B?N2lwOUhwaVo3allsKzhnWTRLQTNiTFZSUDdVdTBjc08xTG5ZUmVXVWZ3NzF1?=
 =?utf-8?B?WVdJcTRRSFlwOHdJOUZHOUUxVU5qV1JIYW5hY2ZJNS9zaGJSeU1pNURqM0FR?=
 =?utf-8?B?S1FnUEJwNEYwN1BWQnV5STZiY3lPbnFhQ01NeVY0VlhrN3B0UUhROGcwMnlG?=
 =?utf-8?B?bFZLVjlpdVQwVFMxY1BzaWlRMzdOQVp2cSthMGJNSzJoRW5vYTZYeURuZVdC?=
 =?utf-8?B?b2IzSk05UVptUW5pTTlrN3h5NU1WNDk2a0M0Y2xuMlVqKzlMSzI5UVVHdlpv?=
 =?utf-8?B?ZG44ajN3aWd0OWx2S1kvcGJUenV0S3pobGx5Uzg3Z0d1ZVhVeEI2d0JhYS9p?=
 =?utf-8?B?dlhqYk14bDF4K2wzMFdGR0RzWHJrRXc1Y3pUZEVzbkc3RXc3VjVFbFgxaHVl?=
 =?utf-8?B?bG91T3N6NXMyS0RSV1c0dlNsc3AxSnhnYWw5amFRWnNBZnZQN01HbDBZcHl1?=
 =?utf-8?B?TUhsSmcvaUNLditiQTNqWTZuUm4wVmUrUkt1cnVFbUp3aFpuZWxLWktEbnh3?=
 =?utf-8?B?TU1SOWh5VlcrZ3FGVG9IbjJhcE9DQURBNzZWSmpaeUc0bzZXVys4TXBpdjBz?=
 =?utf-8?B?RFcvUUhaSlBGdkhqbWVoZmZwRmtFZjVjaTNORy9qSVppOEF4U0Z4TmVoa1dM?=
 =?utf-8?B?cDhqYlVxMWRsbVN1OGlhNm9uVzBwY1NveE1KVkNQZVlmaHJVVlV4a0pOdHgw?=
 =?utf-8?B?V1hiRGRzdWJtWTYrS285ZTJKOW5UQmlZRXNTa0dMNUU2QVFDTEsxcTJENnFQ?=
 =?utf-8?B?SWFWazBZbDd0cGJMZWd4ZlJlOG9qdU9PMENGUTN3V3FLV3cvcW9CS1pEblkr?=
 =?utf-8?B?emtuUTdhZnNjZml6VDRVZ0Z4amlkU2M5L3N0cm5YZ09yQTl6TDgwc2pialRl?=
 =?utf-8?B?d1M1TGNyOU94UkF2TER2K1ZBbmFaWGJqcjQxNUFQRUlNaTQ4QUlNakNub3hu?=
 =?utf-8?B?U2ZxUm56dllndENCaSsxTDU3ZXc5dHVjNFU3V1huUDZicWNUTEtSR0xtSUIz?=
 =?utf-8?B?L3kwSWtRa0tPTS90MkI1UT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MzRhVWRZY1lSdW5vT2lDU3laeFlRc3FSV0N5Q0JEK3JKa0xRRkpQUDZIb21x?=
 =?utf-8?B?dkNwc2o5Z0hOQnFKRGpRUUZiT0Z0amxzRXdMelBoUkJCMFl5K2N6ZjRTdjFo?=
 =?utf-8?B?NGU0Y1JUb1ZRVjRWSThvNktQWnBncG9ybE8yUnJzZ0JyVzIzTTVPeEpjMzR1?=
 =?utf-8?B?ZUViVUU5bWhCdytQVUFyNG5jbmhvWDd4cFhsTWhXNGRQK2RTZ2t1YVoyalJT?=
 =?utf-8?B?aVlGcHl4eVpWb0cwME9SKzNlYUoxOHp1ZG1ncFJWeEJjaTFIQmNRKzlvU0Fk?=
 =?utf-8?B?WmVXNWNXLzVyRnRpczVxdWlETTlCUGJFQ0hMWWl3aWQ2NGdzV2VZbE9FU2xE?=
 =?utf-8?B?dy9Va2xFeHl6cU5SMTY1YVdmT0pCSThCTlgwUGNSbnA5TnlVNmkyQUhYa0tT?=
 =?utf-8?B?ZXptTGsxeHhTdTVsWnQxVlRzK1ZYeW1KdXl4ak5UZUxmRXo0WXNTZU9DMzkx?=
 =?utf-8?B?eC83ZEl2YStkZExZMUVsTGpZanRoeTVrbHJqcGEzWGlqdE1LcDdPUWxCb2NH?=
 =?utf-8?B?dkw5SWl0UFNNcHVyak42NmZJa2FZMUNqeDExcjJkSzNSU1lCallDM3lqNTJF?=
 =?utf-8?B?SlVpZmtDY3hjaHNNT1Ztck01VDVibWhBMVJFSTF1Zk9kSjNxZklnUHo2UmtW?=
 =?utf-8?B?NE0wVGZuUDRnOU85Y1Q2UVk2UFFCTHQxcUU4Vis5KzBWYnVpMUNZbkNIbUh6?=
 =?utf-8?B?cVFuSWRIQjU0MzZzUklsSTIvSEVVa3ZMa0J6TzFLaURxNFcwU2liQjRreDhJ?=
 =?utf-8?B?YlF0UG1DbUI0Q2Z4REFEOUVrby9kaHd4dGF3aE85eTE0ejg0V3ZtZ0dGZXBw?=
 =?utf-8?B?bXdRelZvS1NzS3REWTJJaThOTFErcWkvWktVeVNrL2RQUGJ4QlRRcktQYWZw?=
 =?utf-8?B?U051Q3kvcUIwM0xhUUpkSzNFR3krK3NydWlweTJqRGM1REtZbitxWHFtc1pY?=
 =?utf-8?B?RVdHRkt2VnFLa0lxbXgvSkNCZmJyV0RDM2lHSG9XaVhpL2xkdDJyeTlMbEw2?=
 =?utf-8?B?VU9zSXdKa0hIVmlEMGd4TFg2MHVJZlpKMThQbk0reG9oWng2UW83aDJITWpl?=
 =?utf-8?B?MTBQTjRrRmdyeGNyK2NPL2pqME1XcG1uUlhCTU81T0l2czBjVFBKNGlOTVhM?=
 =?utf-8?B?ZlJILzdOaU5zTEt4RWU4TmlrTjd5b3orZTdLQzg1OE50OE5hYm14YlZ2cHRN?=
 =?utf-8?B?SER6WmJXZHhNbzVKT0pmVDNmdWhhMitMZDlZUElFMWdjT1RjV2UwWnFheDZa?=
 =?utf-8?B?ODI5aE5leGZlL2dOL0IwSjhRdDNreWJ0YW9IL0RHQjV5NUFUMzhyYlV6ZDhC?=
 =?utf-8?B?YnVidEFHeXVVZWs0cmpRTm1BeFNnaUVMWDdsQ3BoditPNVRlZXJ4c2JrVjgy?=
 =?utf-8?B?SEttbmowVE90TU5pY2VKamFBYnB2djlLOVdVRit4N3RwZ3A3ZDVKWlBtRmov?=
 =?utf-8?B?N3JWb05yejdHbWlMOGtMUmVRRTA1QTNqSE01c1NtVEUxV0dCWGlWbk91R2g4?=
 =?utf-8?B?eXdRRjFsWkU5bVNWVXpITEN0N0ZUOG01SlZmYSsySEpOYUQxem1WenpZLzVi?=
 =?utf-8?B?K04rdXJjbitLcVB4NFh0QzBmbmxTeXJXN2tPVms2NTFTaWJFSHRQK0prT05k?=
 =?utf-8?B?dHZ1b2NHOTYrNFZHUnh3Q1RYOHIyYUt6WWorU1duSk5GVDlhdWpYM24yNWhE?=
 =?utf-8?B?OUFPekxGN1FXQ3A4QVlrbHRSV2ZRMExucmtXRkF3SWQ4aGdFaURSMlFLWlVH?=
 =?utf-8?B?M3k2aEJkbEp0WVBpQnJ3Sk16cXEva21YVDRVM2NTUzBOWWcyYmVROHBTSlc5?=
 =?utf-8?B?dGsvQm1zaVZORmtjZjRUTHdCTlloUmVVTzBXL2RINFg3WVlVSmF4R2Z3R3c2?=
 =?utf-8?B?V1Z3dGNsOTd1MmlxWi9TZDUwQlhxNVZQTUFsM1NkeTdXRVdkcU0reE9sWVZD?=
 =?utf-8?B?MlI0dmQyejEvUW5zLzFpMEU4LzVFSjA4aVRxRzVDVWVBYlVVRFV3Z2hPc1Br?=
 =?utf-8?B?TkYyVmJwZWhtdnBRajBEUmhEL01hc2REL0xqMTR6clJzVjBIU202SlYwUGxx?=
 =?utf-8?B?SEMwMTBZbG5EOW94UFYyeERCRjVCMFdVVklDNGFUL3ZrV0lxRC9VQ3Y4RjRG?=
 =?utf-8?B?aXNBU2U2QW5GWXNtT00wb0FCUFNuRys5Q09BZll6dk5IY3F5OFh3K1hVVVZW?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	FZWTmgnN4TE6hrhZ0IRPqGjHUnapJHeQld5pl1Xn6cmjIHa+phEb97w7B3C5dA/Uog/imz66/biHzJkvGuaJxDPVVHRqKSZgnz1TZuBlIaE8N7c+fMgbiXWTEaY6OB548RrZvveH+8gdcTKV/ZdFN2Gvg5l4UTQsmhRaAhQD+z5KFeK3iw0cSp+53FR9NCXjsm+WDvdGTJbfDEDR8u4xD64qph2xzykcLnvduQY6nvRANQC6Ie7v2/EqQAc59UnVhnmf/BvaqwK9QPS8sOk4zIRGcA2n9fVXHSUocMm3N6bERJ8UDLdYIV5llMEbbHa0MblktirP1+FpMlAlbtC8WAzI8cNkQPKrJ2NLLd1hpnoMAuaxPje9tbntlmEvo0+67PYD/7SfUBNHGTE5avK+VdUzMNnr9eUEkPYNkTPFvuICD/pCyOMushQu5iSVZym9epL+SogrSuHsMPrkR0pRpZ9Sv7ThFRv4Ba9jGJi2i0OZRb0mZbJI4xVXdnYSnfleL/giu6faUuMGFlYXLlV5hQiOpRm2ieAyrl5oO43avZQ9b96sfVI41deo/384/YeyJyoxG/ZFz5TIJUtPFhnlFZ+3+a+SAUab2gm/xMQ5eGg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56651c56-c234-454e-6574-08dca0318dde
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 16:09:47.9496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14X61/Op4ctvUrW1UvaQrbEbv2JHMXub9/iP+sWiuP6UwQtsoyTNeUGopxPCHhSNx8Boo64hxgrRmqRMqAmoiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7804
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_05,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=907 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407090106
X-Proofpoint-GUID: dTsEzizSxO46s0GMNa9nWS8eeG2_bnA7
X-Proofpoint-ORIG-GUID: dTsEzizSxO46s0GMNa9nWS8eeG2_bnA7

On 09/07/2024 17:00, TJ Adams wrote:
> From: Igor Pylypiv <ipylypiv@google.com>
> 
> It's possible to end up in a state where pm8001_dev->running_req never
> reaches zero.

Is that a driver bug then?

> In that state we will be sleeping forever.
> 
> sas_execute_internal_abort_dev() can wait for a response for
> up to 60 seconds (3 retries x 20 seconds). 60 seconds should be enough
> for pm8001_dev->running_req to get to zero.

May I suggest you drop running_req at some stage, and use other methods 
to find how many IOs are active?

> 
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: TJ Adams <tadamsjr@google.com>
> ---
>   drivers/scsi/pm8001/pm8001_sas.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index a5a31dfa4512..513e9a49838c 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -712,8 +712,11 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
>   		if (atomic_read(&pm8001_dev->running_req)) {
>   			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>   			sas_execute_internal_abort_dev(dev, 0, NULL);
> -			while (atomic_read(&pm8001_dev->running_req))
> -				msleep(20);
> +			if (atomic_read(&pm8001_dev->running_req)) {
> +				pm8001_dbg(pm8001_ha, FAIL,
> +					   "device_id: %u: Failed to abort %d requests!\n",
> +					   device_id, atomic_read(&pm8001_dev->running_req));
> +			}
>   			spin_lock_irqsave(&pm8001_ha->lock, flags);
>   		}
>   		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);

