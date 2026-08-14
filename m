Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2976D347FFE;
	Fri, 14 Aug 2026 16:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786725964; cv=fail; b=Wh/XzteeVW4cqyednshS+nwM+BFAlMK4XlD2QnDXD4Oi1mrw4T2dQPvR0p5IP2r77guIujtmJS+kk3RngYzY1DFBHLCPpfOhHbx8GLew4cv3ghfSkfZtnoF8W+N9dChK6ZQSSm9rB7Tv+4I1gBSPiCxh5HScWMN9ujhQU6dPXYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786725964; c=relaxed/simple;
	bh=XqnSEcpEyOLb9g0PE8yDxb3r8mePH5QNoQuMZpI4InY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 MIME-Version:Content-Type; b=dghEn4qY91DDC+eWrsXg3PetupBg5Vi3vZ5W4orcp5lYN8p0K8zjmdIdh1yHja5wyf+DpVttnI70brkMcEwoF8DsP0PCkn6rtvCzAA0ZI84tzFbwFP0DEoHXh67omPsh30l4OJVfE8C1jB37f2ImqZnaEqW2f/BPLIBeqvEH6Eo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eAXsIJUH; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rN6ve4IA reason="signature verification failed"; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eAXsIJUH";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rN6ve4IA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EFXiil2226503;
	Fri, 14 Aug 2026 16:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZtKA8yxyxGP9sFogehNysuFIHYpjtx9tCK+9dA1ZyF8=; b=
	eAXsIJUH1b/bmfZd7snjZ74POC/PvXwdzqQ8+Jd8thmnYL58L9T8VHJAfV+HMFOL
	VEqcChs6M47yMJbLUwkm2KPtsNLBuaVaFWYY2oHA/AwuNsULHf80yz2zNL0hMXz2
	sgwHq7LQXMyj4bn+xyJAZ0F16qvOBAoiq+Ubtu+6hSReAgj366WF/STNzLjRjD5a
	1tZi5LXpjVnbh5S2HjYiWkpxt73/uAArxjXcm3WoyPyrX0epDHvAmfDhaAH7jhXw
	jdjsNfvmaYjxpQbcStly6kMd5BbxadIe5BtjVTVFYGbmBDbTFSkiPm7JfuRn/VxD
	eaT0IsHh8xjnMKFb1AEGSw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvkcverk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 16:45:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67EGeddt033423;
	Fri, 14 Aug 2026 16:45:49 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013028.outbound.protection.outlook.com [40.93.196.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwuk4eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 16:45:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RAuZWkBKNCPC+OMkIN9hQkAW4oP+WhN5SFOBZvd+IF0W5fROk+MR0ZY8MGIzsA+U9cbp79T7y1a65el9lz5VkKkbGzXRLeUfqw3epfrcgaDRbsRFH9mqYr56M7DElIftTjkQAfDAE/oFnX7GemzbCZbk5ChNmtz9c7qwzsghwhPrFSz5JCtEIa05Dv+V8xhH8uIJdBvO/rR1IWrlzEeGpof/OisFp+xoMCqMaegwp+bgeNL21YdYS/rOLAAIQsKo+3SW5BlJsmtGSDJPpl9yJv7BRGzMBNJHvU4O6eKbCb7ugNFNdePzhIFFOFmMHCBho2sGcUa7YbtwK9W0fO1O3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNDb7DLaHunsVqJwYs8EpKim0XzYZRP8sdDV7aTICdk=;
 b=i3e5G6eRCsw6cvojuyY1m7ng7Lx9JoqwF2Pm+GYuXCRn2y8/T0TnjBrYVMmQO7IcqSeYCmMHCD63LBqW6gGEvh/onTB6+u2XfdDZz6YkKPQjy9j0669J+I4latUfog0vmGlQ73mOhYgLh42veQjU2ASzzhbCkhEyXIHuV3mTaAwdE10M7usU7BXO8nvoelMIpriPxIcs9VC3x8Yjbc4KT3iz5F8Jp6JNIjoDXw3ggFGrN2CtRyhV1k0O6UfYemKvzN1RzM7qGYfjLp0qi7H3YfZVMYwPn4pledOT5DhemSdCx2CzjxerfrSWRM8SJNFaIE7S0JunSsm4F1v9tzy1Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNDb7DLaHunsVqJwYs8EpKim0XzYZRP8sdDV7aTICdk=;
 b=rN6ve4IA1XF3GKCuMoWF6jTULiMiwzGFPmxU2zA6fYjnKsBuohvhp0S5gyiXOVweU/2k+YUU0XL0nPyEXpcNrgBVi9Z/OeyaCs4oCEodrf5zxWI19R8zeZhxDTWFY7pOVjuyVWhuAY0tyxHAtWIGYGVf9IqY53ruFV078e+YhmI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Fri, 14 Aug 2026 16:45:46 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0315.012; Fri, 14 Aug 2026
 16:45:45 +0000
Message-ID: <ea58d4fd-11a7-4707-8115-0ab0d305dc52@oracle.com>
Date: Fri, 14 Aug 2026 17:45:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] scsi: libsas: Handle errors in
 sas_ex_discover_expander()
To: Eshaan Deshmukh <eshaan2031@icloud.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260812194808.576586-1-eshaan2031@icloud.com>
 <20260812194808.576586-4-eshaan2031@icloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260812194808.576586-4-eshaan2031@icloud.com>
X-ClientProxiedBy: FR0P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4518:EE_
X-MS-Office365-Filtering-Correlation-Id: 90890a29-38a6-4348-bd87-08defa237cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|6133799003|4143699003|10067099003|22082099003|18002099003|4133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	q/ih2y8x35lW1DzCgWLpB4Obp9rNoX0wBIbTAEsiuYiwL/Rp4e5EWU/U2V0DMrkLXxHKS4gCRu5dAjjTVUGWW7aYNqgGGAFfmBMRL9A1bwwQFZGzbLQY4BWi2itUqAPNHXyYz7THXny48jlJPJe5MgkASi7rOeNwomLk1UGDd7YUCpEWxya0pzFPsi3CmnXany6+HAx+3vJQ8fXEy/iztaSCBlJIrLhTliKxCZKKFdbohp3+LB2Uab1sHUJgE7ytTAJhXuNNTZo9keHwZvWWjf49sPg8lbe6bmuQiLARzmlcChIqfp0rB0ks1XvlWFrx3ilAS8ZzoW/WPALLQ6gb9tLhsVke0QHgp4GChB6XHwk88ZfqHaaOD4MQat6rntR9EGRrUB/HPTsMiDsOrznlihK80Mb4GlGeeLQbXP7YBR4RSg+YVMWK7vejupea6pFMksRbHjGNO9W/qzcwlYP86OtDcF1mDnCgsbNPtx1blVzA4unUzHoKp9KaI7L4MWMxRgIMCbI4UZGsjOUm6Hz36MoAEnPFEVwOPAomB8TJac56hEhXBsVSLhHICjHoY20tks0V4SYKvQItriAVU4ik6Le5OH0JxLSmFAPie1kBw77EZBFqEpbm5uzi5K4iEM9LlvY1qUWtksdVGQU1EtZmc7g9Sh9SobX8qKTCp0a7T/4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(6133799003)(4143699003)(10067099003)(22082099003)(18002099003)(4133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEl4NlMxcGUvQzJyRnBWdElmc2xKRnZhRzFwWFFJZDBYRG5MdFpZTGJraytO?=
 =?utf-8?B?WDA5QkpYQXM1bWdsQ21ZVDh1dXBsbStUU2xFZ0dkUXd2K0poUDdIUVRoRUd6?=
 =?utf-8?B?M3ZhV0h1NkVFZzBrWndjNGh4d3FKUjhzeWxDcW56aFUrMUpEcEN2aWtJVWhC?=
 =?utf-8?B?OUpjV0pqdVBzemcwZ1A5Z2NxY3V6bnFTdEMvUzJpR2p5MlBIU1NONDVOWVZI?=
 =?utf-8?B?S3NIWGFSNElQN2lFWFVsUkpzcWNkVmZEaCtWR3B2RTM3M2E4TTVyL2l5QnFx?=
 =?utf-8?B?MW9GT2NBamFaN09PMTV2VS83c2djN0FIcjdSWmtaeVpyMVc4NXhIR1VDN2tR?=
 =?utf-8?B?KzVtK1ZKRndEdmZIdWpjUHdvSkJObi85RFNpZGRHWkdJZjh4aHRIVGtxOGRv?=
 =?utf-8?B?ZkIyWWZSVWU3TTFyRjQ1eC9EZ1RSVzJTL2Z1aUNITFZWMldnN295KytaZndF?=
 =?utf-8?B?NjFQNzFZczk2Smc0ejlRalBndGxPZVlOWDBnK1VONlZORFNqcHo0MWh6Q2lP?=
 =?utf-8?B?SjAyNmF1ZmcrcGxRYzRScDlTOUgySzFtR3RYdVVZWHF3bFYyQ01yZGVKaDk1?=
 =?utf-8?B?QVY3aStQRmI4SHZkRVdwbFl3UWc2eGwrR1k5T0V3Q3dsVGhydWpVZUlNdm5K?=
 =?utf-8?B?Q1lCR2pPeTducTFDWXExNEdrb3VOdUYzM0IxM2NQU25Ld0JSdm55K0xCM1Zo?=
 =?utf-8?B?TTQ3TSsyaDl5d09URE50TUk0NVl6ZkRkVG9aaTgwaWhHY3RPQXJHOE53TVFC?=
 =?utf-8?B?b2pEMEFxTHNuNnM2THViY2huK05jTFB4VXZtNTFLZjFibjBFZ0lOaGMzNVpI?=
 =?utf-8?B?UXhMV0ZjUER1bUVqTDJPVXJWT1ZCT05zNU9NUVkxc3RjNklUQWNycGNLb1ZG?=
 =?utf-8?B?SXVRRVlEK1h6RUp4NXc2MHFaS01VK2lUdFlEdVlnanFUYXVyVEhMODBVdG9p?=
 =?utf-8?B?dkcyNm9NVTR5RTdzRS9RU2xBUXJXY21raVBHcjQva2hpSW5QaStrbmc4VDJn?=
 =?utf-8?B?bWxEd3E1K2RwWXExZVpvOEhJbzk0eFJhYWtCaXVTNHZudEZEbDVaaEpESEh6?=
 =?utf-8?B?Q3RKRUp1SnlCTTdZejROWkVSa1NLTHZwcElDTmp2Sk5IWStOQWNXd05nbFIw?=
 =?utf-8?B?ZmNnUzh3TThHa0tybVhoOEYxcWdTVjF3RU1zYnpsYU14WUZXWUs4ZWNGM2RJ?=
 =?utf-8?B?aTVITi85ZUl1Mkt3c1RHcVhSc2VKM2M2YWpMaDY0YkI2NHE3bWN0TitZWmFL?=
 =?utf-8?B?UnQ5Nk5ZOFhsazBHR2c0Szk2OU85OTJvZHhDSW4vTjAvUEw1Szk4YzFwUXhM?=
 =?utf-8?B?TUFNRjUzeE9aVmo0N3ZoeElxbFZ5Z3hoV0ZlWmpRdjlLV1Y0L3FNM2JJcEg2?=
 =?utf-8?B?QngwZ0Z2bjNrc0plVHplSjU1aWJYWlg5ejJ5V1FjSlBRaDFvcnJ3VWdPR1Zn?=
 =?utf-8?B?aDZRMG5ra0YyWGcrMFYzQi9uK0x0TmlZNmMxQy9sN2V5UVBnTDlmSXpzM1Zv?=
 =?utf-8?B?ajduK1NIRjRidnhZRDNITEhLcmNVRUZ0eWtkR01lbVIyMnFQNEwxeVF4L2d3?=
 =?utf-8?B?OWFVWXQzN3VlQ1NrZ3dBMVhlSTBISnRRdGdtSTZqMDczeFFqSXFNQ2Fpckt3?=
 =?utf-8?B?TUxxd3hBS1ZqclFDTkllRCtoZTJ5M2pIbkhTOUF2dVQ3SEcxUFNaSEx4eWlo?=
 =?utf-8?B?VWcrUzMyMUNDS1pxZm9kUS82UitqdDY3bjJjYURvT0lYSEc4cGFFMjZ4L3lX?=
 =?utf-8?B?anpKS2ZKWTNxYjIzeVlTSGVlOTlrZTNBSi9nYjUvcjFDTGZ2dVR1K2cydktV?=
 =?utf-8?B?U3ZrMm1qT0N5Q3U1QmNYUTdWa05kVkNxR3VhV3E3RjhjZmZhNnRyUnFHQkxi?=
 =?utf-8?B?THd2TFpBVWZNU0JabStsalEyeDQwc0dhN0NWb0tPVXFNTTJnV2I3WFZlSzFH?=
 =?utf-8?B?MXhZRGlmTytaUUNBVHNjd05pL0dYdWN1UFo3RlVBMzh5M0J0RXl1MERaRTFM?=
 =?utf-8?B?K3FrVGxKVFNRSG42bVd2R1UwcG4xdzFIYmRYRU5PcnZqcFQxQWRoMmZTMEFF?=
 =?utf-8?B?NkdUNHBjZ2xDR1hTTmZzalBqdjdXdGtDZzVydjFjRDIvekZSNnFCTHBUelZv?=
 =?utf-8?B?cVlxZXZvRjEzWENXUXRsbVBEWTl4blJOMWIxaTg4YTVBWWZqUGdtM3JOMFVB?=
 =?utf-8?B?MGNsMG83dTMvN3RiV1BTUlBTVVFyd3dMRUpXak1XRzRDdjZFVnRnQi96bTA3?=
 =?utf-8?B?ZTVaV0djaE0wSWhhZnNlcUhPZ3BhL3FUMnpZMm9UbDVocy9GdWcrQmxTOFRC?=
 =?utf-8?B?UUFPVU5HQWhEOG5PbEtpTWVIVXZrQUlaQ0w0MmxMakFEL01MT3ZLYjlIR1NU?=
 =?utf-8?Q?c7Eh5vijitUUt2KU=3D?=
X-Exchange-RoutingPolicyChecked:
	d73MIBkpxZInRsp+OB7MVIO0Razhw65xUk1mIVX9hW4RpvUtD1gps3EKSr9eifK9Elv3ekgp4WZd2FJX8ygzx1L/2WogOcYjtC3nYkv1lyArsOgeXPm7e581pfCenq9bW70jb0QWqrgzjjuHmMaCv7uAK25RY46zMp/1YnYvSxEA88Bx3vgNRegi0j2GyXZYlYAgZuU6yHqb3v1w2V8BnxllzOuj6KCa3noHk0jIxVV76TT3cRYt/JxqZmPA67lPaXwR1RLQTLiMCfQTWasKQuERjVUDgiYSvwTtkWfAWO6isBBeHepoD6+T87mtemUuKiQv+WoG9ktAce1RzInESg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Lvlkbwklmxhb01TGq3PPnFRfrIhQd56v42oJL7FdmCm0tY+eFfOqn9N3GdAaiRg8cEgcfoVJp72QdyOs3lKoUFGDHHIDwNIzUeXbnpDC96kFlkUPiYyMlvluLgiax71IjC0mopdYjqn31Ryc+fbJxXqICedOg17xYIv+sZ0PzsaY5yrGJQOjpkIrqnpJ5ynKgdsEl6Yhca1Hh7v4YjWDsGoPz/pJt7fAtYySZ1OJ/MXgDZpRqOsFJg5CDKrY5kGY04aQaMMAU2Zh52lI3pfqImSys+XXbUD4piLcTP68eNM1tCbS9/3kJr0IDT5HDwQuOThrBGN85K0kGSit4U5PVAVdayrCb19yvzoaZtvrJkev80ODFkO2CKondvRMF6h17rcK4ArURG+y2TojEV2u2X/BD6gkIXJMXu0O5xCrixU5D0vQyNZ4HFTJtNpZq+AquJXKqvk5+lmoQod42Ly28cGMx548J8YaipE3ra58I5bGPdAMfzXEe/apqk75FYY4iJBrn0PKfNe6GYGn97hELbTomFsrB70CA4VS7KwjgvAkhEKI0q4GofP5i1JzWoRE77vYVM2ZXrYBQZUcpEk9Qri8kR05IKyi9R1B4oVU8fM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90890a29-38a6-4348-bd87-08defa237cb7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 16:45:45.8034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olXzYFw6xKSm7sqpu8AnYZcmeE715ZFlt16V5D+VbFPWjRefNU8H84px35TAdjCEgf0+29Qr2+5eskcC6BLMeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608140128
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: le1IPGztdobhH7SNUUOEO3xH1uFF10OR
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEyOCBTYWx0ZWRfXxU/dhdz7dqMh
 JfjCTqgeZ0vgSlf6v9AldzKncaFYgLPZGyFGIPHvCR5xq3yh0utxTQ3767c/PF/0rw1XY9OCKzI
 TSnTb0flrw7Bzk9tG3HIoKfdL1DjcB8BZ0EFFYcRk+XZoePHCtLk
X-Authority-Analysis: v=2.4 cv=aepRWxot c=1 sm=1 tr=0 ts=6a7f463f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=RpNjiQI2AAAA:8
 a=v3ZZPjhaAAAA:8 a=3R6n-FQU_Tjaw4Cp9oYA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12098
X-Proofpoint-ORIG-GUID: le1IPGztdobhH7SNUUOEO3xH1uFF10OR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEyOCBTYWx0ZWRfXzO6GnJwSyBKp
 Mxh2uRJQZ2EUSU4i0+j/+JZyR7wXIX5TANeoO4/TevH15CubZIyR7t0OHC7VddVrQjbAIoSozJS
 UY/ngHLXdue0AcY1iqap+KPsh7OWgBsaEDEAd7668VWihslVTbuaakL7CekLdYL7yNwoLC/c/uj
 pgMcjOMychjdraxoKA6aTN0q3xiR+iz4uDqYlNBgDyqtq3qn/d40hhfftjKR3CJhVkZ2mdKSPht
 KRnEgozDvSXW7lYmOwrHHjn/f4JHqLg4YFg2YX8k1gUuQg5QEgaPeqrT3y8ufpWaL0LS6dZMphV
 PMqs3KCnoCoP6TnNoy10/lQmdjIRi/czTE3LmPmWXLTS11UVteDQ9BUNOyS5pn7pVcuYH5vy6XK
 NonGJscvuDShofItnjKmeeGmM58gRIbQucvmRMVpW8LNx5xlHcwSK1mGXhLUYKPJwaGgGsHMAd1
 WEZtV57dGb5aWG8N9+k7Uk/xhPyHI27QZtvpQwwU=

On 12/08/2026 20:48, Eshaan Deshmukh wrote:
> The function sas_ex_discover_expander() does not account for the potential
> failure of sas_port_alloc() for phy->port. It also calls BUG_ON in case
> sas_port_add fails for phy->port. Add a check for phy->port after
> sas_port_alloc() where
>=20
>=20
> The function sas_ex_discover_expander() does not account for the
> potential failure of sas_port_alloc() for phy->port. It also calls
> BUG_ON in case sas_port_add fails for phy->port. Add a check for
> phy->port after sas_port_alloc() where if it is NULL, it cleans up the
> child allocated device and returns NULL. Add another check for
> sas_port_add() where if it returns an error code it frees phy->port,
> sets it to NULL, cleans up the child allocated device, and returns NULL.
>=20
> Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
> ---
>    drivers/scsi/libsas/sas_expander.c | 41 ++++++++++++++++++++----------
>    1 file changed, 27 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index ab6afbad3..a83493f57 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -911,7 +911,6 @@ static struct domain_device *sas_ex_discover_expander(
>    	struct sas_rphy *rphy;
>    	struct sas_expander_device *edev;
>    	struct asd_sas_port *port;
> -	int res;
>   =20
>    	if (phy->routing_attr =3D=3D DIRECT_ROUTING) {
>    		pr_warn("ex %016llx:%02d:D <--> ex %016llx:0x%x is not allowed\n",
> @@ -925,9 +924,13 @@ static struct domain_device *sas_ex_discover_expande=
r(
>    		return NULL;
>   =20
>    	phy->port =3D sas_port_alloc(&parent->rphy->dev, phy_id);
> -	/* FIXME: better error handling */
> -	BUG_ON(sas_port_add(phy->port) !=3D 0);
> +	if (!phy->port) {

no need for {}, however please see comment further down.

> +		goto out_put_device;
> +	}
>   =20
> +	if (sas_port_add(phy->port)) {
> +		goto out_free_port;

ditto

> +	}
>   =20
>    	switch (phy->attached_dev_type) {
>    	case SAS_EDGE_EXPANDER_DEVICE:
> @@ -966,19 +969,29 @@ static struct domain_device *sas_ex_discover_expand=
er(
>    	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
>    	spin_unlock_irq(&parent->port->dev_list_lock);
>   =20
> -	res =3D sas_discover_expander(child);
> -	if (res) {
> -		sas_rphy_delete(rphy);
> -		spin_lock_irq(&parent->port->dev_list_lock);
> -		list_del(&child->dev_list_node);
> -		spin_unlock_irq(&parent->port->dev_list_lock);
> -		sas_put_device(child);
> -		sas_port_delete(phy->port);

I missed that this was a sas_port_delete() call and not sas_port_free(),=20
so not common to other error paths.

So it does not look like we can make much error paths common, so maybe=20
it was better as previously.

> -		phy->port =3D NULL;
> -		return NULL;
> -	}
> +	if (sas_discover_expander(child))
> +		goto out_delete_rphy;
> +
>    	list_add_tail(&child->siblings, &parent->ex_dev.children);
>    	return child;
> +
> +out_free_port:
> +	sas_port_free(phy->port);
> +	phy->port =3D NULL;
> +
> +out_put_device:
> +	sas_put_device(child);
> +	return NULL;
> +
> +out_delete_rphy:
> +	sas_rphy_delete(rphy);
> +	spin_lock_irq(&parent->port->dev_list_lock);
> +	list_del(&child->dev_list_node);
> +	spin_unlock_irq(&parent->port->dev_list_lock);
> +	sas_put_device(child);
> +	sas_port_delete(phy->port);
> +	phy->port =3D NULL;
> +	return NULL;
>    }
>   =20
>    static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
> --=20
> 2.55.0
>=20

