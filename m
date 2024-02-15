Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A7C13A88D;
	Thu, 15 Feb 2024 21:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708031230; cv=fail; b=GblRwYNBnieESlWCcf0cvIw219RvkxlfR/5itnMBKYcqwcla/vzY9s4PMGDRYVaCUmB+h+KRmhGypy75TuGeiDqJE5zFk6BW4E7IR3JLyotBenD4Mi0hUlcQ3LDiP2+cL8xrrCWbGdl5tKGmknIb55YluYGs3p7cFfMMcEOFd5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708031230; c=relaxed/simple;
	bh=zklGzhA8ML/J6H6kqqDuA6nlPfCE2cwD9W9J0IAZvAY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=owfNSXcvG8LFEOf7KFubIatR+kzwGcVVaH9K53lZ3f5tffPXIce3+RKEbCIV+dlORjgxoQL8FdTY2FhHwHZJLzrVI85DFAlQChV9J5ZCv/GJtn9l1FIbTyo8zVs520+xqrdLsdB9SF5vTj1rjJ63zFNh1TRtjBUXmm51h/rqv30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X3FEhUCj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CzT9Nidb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X3FEhUCj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CzT9Nidb"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFTPfL002858;
	Thu, 15 Feb 2024 21:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=NPm6/RLpiMgUYWrv8Y7E0BiwkqHj9yNxGAUftT6Ttpw=;
 b=X3FEhUCjUVZQww9EX/yruEKTNU2xwQNHpT/X3hhMEu9iNKAgiy8r1fj2xIgn/StVTcPO
 Z6F9+Do8FT+jA6MX3ExUn9iaFPC/3M6gK/AXf9mL13HvnHlFhVZr0c1Ctb5XHbCxwg6+
 s4x5HaGAniJ+Es+9OMTChp7ZrJ5gIK7X/bs9lVG18dB1PgaZROlg4rghEOOQt4F2yCgH
 7oGXBCvoKoAsFTzEVAfbZVk5Ye+ttIMKF7d66XSByRXEulKW4S0DOHuzp4TovjTxH7Nd
 nj8Jx4cij3co6bGCxugLL9zXkgMIf6VkPEFsSZTHNJbIRwvOGVOIKcCgUQzAJZZc1878 0Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w91w6ufwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 21:07:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FJYkSe024563;
	Thu, 15 Feb 2024 21:07:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykhec2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 21:07:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nB0kCilVzvBdhwdnmthIYFBoCFNeuVHz4EuaqQMOxZ7LVtt2vPl/equNbDAA1ITT4Ccv+CBpaSjHdeejeHArfH+LpAdbl36Rr3TVl60rifXkTXckfguBYxoGBXeNb8z4vFrzhB00EkyiZcxGfwrzsj0ruOVhGbZuW+yE+IgyP8y/BZDvuSlEyg1pwL6zqS0dB6yknhscZK/ZGuTnKLmr+wuZmK1sK6SsuSLmGKqB8JXyGWfqjUns3R5ikXJ7SZ7AqPAuL+0NZoECkAUKi52bALfmL7/qHJtNwdqmMleK0MT2d/Jw14cdBRTAUHz/O66H7ScDtOLRCudbi5KK9yYkfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPm6/RLpiMgUYWrv8Y7E0BiwkqHj9yNxGAUftT6Ttpw=;
 b=JDJULKjZ07bekl3Mq8/Pz5jZSyucjexol8l9mCLhZjgf5STB2mLZyrI0ARcQ7DaHYMWpsxJBlmq8sWfmZZ4vsElbi5artD9g7hqDre2iDmMv8czYx2/cXxmH5hmd5ogmrB9tEWTp6AJC4sQ7FecxetWySuAOhdq0kqN10yS/xXvi5+F2DBVwBibeNGuTV1V61bm+votiD6FbFvMQz5+rq4wlWCtOrXOUxFNFOLKY4RNvOGrLncCir0zQnisDT1WnVMXiqW1Lpb/JZHoDVF/h1PdP5jwElm2pOfG29/aB1CzT5Td2gLPhgOKgmA17P3mytka73FgPeI0GTar3MfjjHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPm6/RLpiMgUYWrv8Y7E0BiwkqHj9yNxGAUftT6Ttpw=;
 b=CzT9Nidbu+f97kniwwESjaG1eATGQpAl/52VTTfpKB8F+XhMr7RDItcpCIQY3ZL7wE1jQnlkSZ2IG6sZv9ajO25ETeRrHSloiFY4jKbG6z/geI6mQDUddVtnF5r/OZ2iJ1bOcvoS9E2xaXqOM5Ye9Bu73aObdV3lsF9hC0jIvyE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4929.namprd10.prod.outlook.com (2603:10b6:208:324::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.31; Thu, 15 Feb
 2024 21:07:01 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7292.029; Thu, 15 Feb 2024
 21:07:00 +0000
Message-ID: <8c629861-2046-4471-bc51-96f5b446a46a@oracle.com>
Date: Thu, 15 Feb 2024 15:06:59 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] target: fix selinux error when systemd-modules
 loads the target module
Content-Language: en-US
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: d.bogdanov@yadro.com, target-devel@vger.kernel.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20240215143944.847184-1-mlombard@redhat.com>
 <20240215143944.847184-2-mlombard@redhat.com>
 <094cd372-eb90-4738-acce-a3725dd2c0fb@oracle.com>
 <CAFL455mD1XEYqRb80K1REHVeyWVmD2yKEViMY-AYqxhJ8bpQBw@mail.gmail.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAFL455mD1XEYqRb80K1REHVeyWVmD2yKEViMY-AYqxhJ8bpQBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:5:15b::40) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: 551975d8-4b40-4292-a105-08dc2e6a0d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	fAS27ud1xgurBmSjle9v791/zt9PGs6KeY7vpvlYobk72fs1CbDfo0ip9Jj90gQdgwxip5vKKKro6JHdVI7r8C3hLz6EXOEPfwsGrYHrHUMoY/DaqCzEYUNbDsgTPdtn0bocCdKvd/MbhAB4AddOLfvu4g2vhTyY4waXNu5h42B+wBhkcwb6JJTKPCpNfhIkjnDpeYsP36A15geEgN22wXY8g1LVmHny/cDmFSnSjZAuXV1V6fVstlwqsuCME26uK58ajo9hTXCg0Okouk9Q0J5ogyhIQKpF8oI9v33LzmVaerzXebDiiMb9TFgblCkPCuqK0D7860HdLBTgmJ9EEK4xJGyX0Q8XiQt8yLRV5pt5hNdUKG+71PeZVXXivIwuhjSGJEnuB23p/m+IiC6Zzwi9f+ZeHcE76rwlpffF/yrn0fc2Dv9hqA50wED4Y/2RZR2S7cbt2yaAT84vhZyg+xGg4KFQBBm8hcmTVdKulA9CqjmjOTenihu4pD39j5eV/2G4dWS5aEzegpNUiUeTfGX6ummxvalPbMIm48ZNFwS9jnAvh3XVVydbK/TgLcnC
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(39860400002)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(5660300002)(38100700002)(2906002)(4744005)(86362001)(6486002)(6512007)(6506007)(478600001)(53546011)(66574015)(41300700001)(36756003)(2616005)(31696002)(26005)(4326008)(6916009)(66476007)(8676002)(8936002)(66946007)(316002)(66556008)(31686004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?R3ZxUE91YVVnaG9ieUtBQm9MQXlOQXkxVFpqVnFmQVBJaDc2dVRTdmFzRXZ6?=
 =?utf-8?B?S0RmQmRWTFJ3bWpXaUZlWGsybStmT3NhWk9mbkZhU2duWm9nUCtER0dLbldZ?=
 =?utf-8?B?S0NwYlJPbG5uN1pFMkRsSzhNTGJhMXR0bUFVQ3dlc1F1RG9hc0RhTnQrZHp1?=
 =?utf-8?B?U0MxR3RmaXZ1V0s3cmtLRXpHOWhaVUIzZEFsMnhYNU4zY2J5UFFCZmIyWkdj?=
 =?utf-8?B?WXFyeitmQXRZVVF0eVRsWExxc1Z1UDgxVU5BUlpwdE9oZ2RycDdtc1JRZWlu?=
 =?utf-8?B?QVJmZzltWVFvdzUyQ0dvaFlHZ2xqY3JmUEY0Ym1GYVpobkFmRjFGQ2V3eUgy?=
 =?utf-8?B?c2huQWxMTG4zUlg0TmM1V04wRFJBUXk0cWtnMk9nWTVoQUticG96aDY0cUZY?=
 =?utf-8?B?dkFGaytrYzlMUmZhNURHdGRxbmRNZ3BROUZvUUc2Z2podkFsaEFwbEhodUxV?=
 =?utf-8?B?amRORGZ5QWRRUTREYVNLKzU3Q0JSV1hGcStjYnlPd2FHQXRqREhoUXhvREdy?=
 =?utf-8?B?anlvV2hCU2N2TU5RWVdwcUdhL2VnZzdmQURQWUtoelZNVC9SckxCUmExS3hF?=
 =?utf-8?B?Z2RJM2wwN3pKSzI2UHp4WmE0RDlZcUE4aWFDMDQrYy9aVGdWNDF4QjNnV2d6?=
 =?utf-8?B?VERKZE53c1orV1k4VmdNSWtmTjJpb2ptSlZoT092amdXRHRJU3ZMZGMrNk9q?=
 =?utf-8?B?WXVvRTNUYngwdnlZK2lWa2dCTFNMSGdNbklPYjF1aWFOdWxBVWp1ajliSENh?=
 =?utf-8?B?RCtYWCtJaU1LcEttTHZMc0NpaFkrVTN5Wm9iL0djRXF2aEN5YVZocS9lWEUy?=
 =?utf-8?B?SklCRHlpbGVtOFE0UEhvUk5UOENGRFJnZy9FaDZSdFU5dnIwWndJZnNWTzh6?=
 =?utf-8?B?dlpzK0JWOFBiekNFU2VCY2xzcElPT2s2b25OVWpNbWZPSXYzWTFkTGRScDBE?=
 =?utf-8?B?Y3lOemFPanZkaFBnUGRRODNMWlBqSndsQ2pmU0JVMG05Znlmc0VKdVdRcWtz?=
 =?utf-8?B?SU9VY2hEcitwVEZRTnhrVzEyYlN0dEIvRkxMbk45UFZENXBGNUNzNEdITlpD?=
 =?utf-8?B?UnEzNzVnMFdWa21lV25uT2JEQjkzSy83YVVRejRXeWFFWGszcndiMWQzTkRJ?=
 =?utf-8?B?Z0k0ZDlGRTY3aWRuRk8zWEpWVWl5cVI1Skd0ajR0bDYra2tBSXJSOEJpSE1y?=
 =?utf-8?B?N0dscHFKZG5rcFdicXF2bGhmYXdzMXYzbGV2ZXlmTlhGRStXaVdzSFJpWFdy?=
 =?utf-8?B?VWx5TTUzblhjdzZYTG16VnFMWGp4SmZQQk9RU0RHeldhdXhWbzZBVUZjVk54?=
 =?utf-8?B?REQxSTR0N1RKb3JUbkpwd0tGZTBVNURkRWhabTdYTG02SUFxZHhCdmxVQ2c4?=
 =?utf-8?B?VXJnSnUwTlEza2VlVU1aZEZUUzlsTGlNTlltL0JrVVc5cjd0MStGMjhJZVV6?=
 =?utf-8?B?Q3diLzk0R0NOSU16T3NVYW9YQWJTS2YvNDRsR2pYZFlVMm5ZcDlpNWE5dUFw?=
 =?utf-8?B?Rk5oQ0ZIaG1qU2FRT1AyWWJtZ0ZIV0lBWGd2N0hxQXNSNVZ0NFZiWHRYdmU1?=
 =?utf-8?B?SEZHbW5DNVZZWC9xQTZlTGs5bFBLTW5EZ3FHdEdMV0tiVlAyU0YyNlZzaWxx?=
 =?utf-8?B?WE1ON1FwbW1nNkc2bEhmbXJmbGkyQzNBUFZtWStyWlRkY3BHNTQrUkpOaXRG?=
 =?utf-8?B?VFN5NDEzRjhwTVU4Uis5clJvN2dKNDFQeTd5c2x0c0VFYlpsekRXRlA5N21v?=
 =?utf-8?B?M253amM2WUI0UnZ5aUV0NE5kcFU4L0dOL3UvMDY3US83RHhGcU4rNUxBOVNL?=
 =?utf-8?B?MEd2NVRzRk4xUWVSbS93TXV1ZVJNN0s1VUlaSHgrUlo4Y1JGblc4L0JQSTQ0?=
 =?utf-8?B?QnVHK0JZY25nUXc5bjlBU1VVSU9aeUZrVCtGVjMwbFdJWS84T2ppRFpSdUN1?=
 =?utf-8?B?TDJFeVpTMmFzOWJKcXdQeXorSW1YYUFXaGloeWQ0cmp4ajhNMjZ5dWRnMFEz?=
 =?utf-8?B?ays5Rks3cExxSEhzcnhyMWxlL1pEUDlRRXJUbVZ6Z2ZnbHdCS281NFdnMTFO?=
 =?utf-8?B?eTQ2S0VCR0g4ay81MDYrY0d0N1RWcE9JZkh0b1BIODQycmw1aVZSeGZYZHV0?=
 =?utf-8?B?cS9VVDBtY0xyR2JONStvbExNL3MwQllaL21BTExpbHRaNGRtc0hFZm9vMEFF?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ct24NK/JvudxSjsGNeQ6ItJ37AwJQ9b2HEJ5S9OW6a0O00G8UxRmPoEgBBalSWlnTPVRUp1cFjqt4i8wCb/snsGr9MUXbp2PV2XLFJp1FSReN4MYGewaT9VbBNr2gO5M3Jwyb1sZkfBdGb43D7UfdQF2G+T90MwEDmBQ+UeU4GkLqTEdnL/I4mTZ2R1MVjzeowaIp8oV6RtCZ1bodCIgDtQQhSJcqM8pwMBi/XMGEV5cAnJKmI3mGkNAWg8euhjDeq8z5Qp5VQplUtI3h5CTYNaHa4oJmr5s07FclY7U0KIxN+WqPCKTTMqw9zsPQfu3+Ldc1Yd/7cq1X8XobPVMNrPfsIlJG9EV7wgUoqApxCJn2hiv3ys1lrlzflRylaIGlEIxBZl73H5878a50wBj58zYrp+n3mC1CUcV6lU8tjhYvYtrMM4zfhL5y1/Z+3pndq8gPZkpY4Z4571hZU5Y3F3gsn0ULpXj/YghnVB76kgMqVq6rHSgq/3X28f88hygWkRxE4jtfmX9Yv3twL7ucFdwySHTnHkjh/pskR9b0ETtnkvsyM0uNZUI/FepO888eMEcl6o1c71Mb+rbgkbsNeo0k3PcXBzeiAcr1q+VNIQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 551975d8-4b40-4292-a105-08dc2e6a0d78
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 21:07:00.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LvkStLnR0lz8IZE+3VcYWD4BUD6KgcQl8nx4K/svEljgAxC6D2f/spSxjx39IaVgQW8oRB0yBCSTAPPFKfqbCVAo1YU+nqoqkaXLWteYKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4929
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_20,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402150167
X-Proofpoint-ORIG-GUID: qv8Kv-IzLj0mmfZMucyu4UrkGNl5vcyb
X-Proofpoint-GUID: qv8Kv-IzLj0mmfZMucyu4UrkGNl5vcyb

On 2/15/24 11:07 AM, Maurizio Lombardi wrote:
> čt 15. 2. 2024 v 17:44 odesílatel <michael.christie@oracle.com> napsal:
>> Do you need something similar for the pr related dirs/files or how does
>> that work but not this?
>>
> 
> I think that in that case it won't be necessary because the pr code is executed
> by a kernel thread that calls the execute_cmd() callback, not by a
> user process in kernel context,
> but I will try and eventually I will report back the findings
> 

Ignore my comment. I was thinking of something completely different and
figured out I was wrong when I looked into it.

The target parts look ok:

Reviewed-by: Mike Christie <michael.christie@oracle.com>

I have no idea about the creds part. If the patch:

commit 581dd69830341d299b0c097fc366097ab497d679
Author: Thiébaud Weksteen <tweek@google.com>
Date:   Mon May 2 10:49:52 2022 +1000

    firmware_loader: use kernel credentials when reading firmware

you referenced is the correct way to do it, then it looks ok.
