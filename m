Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200091534E4;
	Tue, 18 Jun 2024 08:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718700977; cv=fail; b=PDym8N0JFagXERL+f0m+P3E2r+3ULBG5MGk8WCzfM73D19w7LDpj74jG87YoExZcOb8sEodEvGAtNcIsTVM6+UIdlCRdl3P2V0Bcg6Pcczn7FbMpJbV4Vx5t/TgWOMGCpaR5V4BspGtT9zzJkqdfgY0Ve1tpCIwljgE4XyGyMro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718700977; c=relaxed/simple;
	bh=fsly/mVZ5aq3fsCDtBjQjVFm+5YfLvm4BqAHf3lq8G4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fhCnxdZOfma6oX2N1aoHetoHFE5XeEdpgO/2hjE7tJD5aeWl8Wt2b9vatDAWk/koY8oVsS2eOf7Kqn57E+YvdJGnY5iYqNg2fnEAKLsH7DQY1/C61cKx5dAvw2DO0caKTDqYArXoBTUv2Qws6ZAh03aLIsPvwdK2eq0265MbVq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cfub1/cm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GpVV7PCl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cfub1/cm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GpVV7PCl"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45I7tOeN020792;
	Tue, 18 Jun 2024 08:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=/sRqE2bCTQC0qXm1xplI9xmGVkrTWdmY6lagcGcHBEc=; b=
	cfub1/cmMBYAc7d2dbScOPHhfM9BP3wrKKw2/YycfWNHRC9uAKbGEhp5+Dz2IVvc
	Jgqk6GHnQPpS/3xKRpSbFM8aa9qju/lxSHJDz3mBKeX2DQOxbzWqNdAyoLBaFk7T
	Zi9Xeb23kHhQ+xLMVE0QJRxSDpvbdxMdrano2GlIFqOeHN4E0MaeaE+OyKIWQlrt
	/VB1+llLQn/SMRAGnnkcM/zvph8/LXuzMWif9MbzJYkOb1mlGRMayHBurlg0cSmi
	vPQ/pKnkddiACdQMVX9MvImRp64//sK5exV8lNLuJla0tDC9md9j+Rqm2Tk7EvkQ
	b+uorpUd1h6TVMVpu4A6pA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1r1vfhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 08:55:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45I7lr3r034502;
	Tue, 18 Jun 2024 08:55:51 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1de2tm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 08:55:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAgmsrDTzXdVyzBOCeK6+48FiQ5zKlj0ZPLwxBt8ydO8Ojp0smWOI4sxmF3/klQ140AluVb4Y7Ph7fsS2t2W/Ywh9iZKUw9SioIK23yuqfm4GaZbfrVi3tnKlBi+IS0hirqjVwAOk3+rAMDbtwUTgC+ReNX2CGwa5Dm3oexiHaKSUjsmj8ks3qYZ2mXQgDBhJ0UP66QGx8XRNqOlZpfK/Z4WNWzOzlaj2PyiSauzQ0/C3MixJcThwguKo6hb5a9CaKqWQtVcZGRfMtFNQo87sArduh9ePa/cN9ORFzimBlgHK7HrDOwaekjjUYg8mBkQjdxrcifjIY8flEWtfw14HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sRqE2bCTQC0qXm1xplI9xmGVkrTWdmY6lagcGcHBEc=;
 b=EEj4BECfV8vfO2EDsWrLC5BhFdegxwBwgppUD++Nkd26FDRCzs4QXDyIR9/6TQP3sB1gMMnqbWobkgz6XnauToMdwWynKkMfHtrg9lqLgaOGAfyB0LdX7pupfK4yjoAzNwrwVinIkXXJOhxXghIoSvFXOFJcM3I31WgK1tInOsAExzpYW4wUatdP7r86HY5clE17BAc5t1OpjR6sOcTdiPXk/m3OV+fpNW9Ade4gEXz0QWyEKsCOvQBbba8OsOiZOBs/lJMLeO6kYx2dH/gas56cLUOxCu0/or89lNLHCgdCqteAcOsNsSVEjasZpkeMPh1og+TUQ+cxIXJmQcv/Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sRqE2bCTQC0qXm1xplI9xmGVkrTWdmY6lagcGcHBEc=;
 b=GpVV7PClOHwn4tnCcCn1HvI0t766dpQ0JS9/CZpOQH5jGn5nFxRgzf5eNVDV2IShfLm8nRRpbYJn0zLfwA+6Q9RfFA0d7ZSG6zx+f+1TIVWCbSuQZ+1Dkppth5WuZ/OG7aoAK4Mtn1QGM8RdbeaEqXU3Yr5BpbPsEc/kQjAiBMY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB6400.namprd10.prod.outlook.com (2603:10b6:a03:44c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 08:55:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 08:55:48 +0000
Message-ID: <437c99f4-a67d-48d9-98ee-58cbbc3d19f4@oracle.com>
Date: Tue, 18 Jun 2024 09:55:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        damien.lemoal@opensource.wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
References: <20240613122355.7797-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240613122355.7797-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0162.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fa5359f-ca0c-4aaf-ef33-08dc8f7472a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|7416011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?ZU9TMnNiVUh3WkpIV1hUM0RvMGQrUXU0RWFkaFlJUDFVTERxZTQvM3VaanNM?=
 =?utf-8?B?b25IZy9SRG9MbHEzd1dtSS9SN3lSYlk1MUZEaUxkbmV2R3N3djM3VGQ0R1ZE?=
 =?utf-8?B?THVlOTNLa2NmSXhON2tKNUtudGxuL2VYRnRFYU9sWXUxWVZNQ2JnSGlndXpo?=
 =?utf-8?B?Ulk0dUV1dVQ2M1dldzVXVEtPUnUxQ3hQbWlvRzcrSmxyekZpaXFZQXVBR2pL?=
 =?utf-8?B?RHNGQjRUMFc3cnRsYXFkSjZrYWs5dHkzaURqVm9DTThVUEw2SHAvRUNQUVVE?=
 =?utf-8?B?Znh0VkF4SFUrTzhuZjM0ejlWbi96Mjd1YmxLUjFETDlqSGIvMFJCT2ltM01W?=
 =?utf-8?B?WGk4YlNaRlo3RnFTejhkYUN0WlllNkVHTVpyMnNhSW5yek84OTZzaW9sTDJV?=
 =?utf-8?B?d1hiNzVSNUZidjZSQzlKV3YzVFh0ZDBadHFTUVF3cXNKTkErSzQrMzZzSGRQ?=
 =?utf-8?B?MTEzVytXMHJUb3VxUkNSMktxUnVFa2V1Qi9PaXRYODhYVGtVaUtrTUgzK3lT?=
 =?utf-8?B?VUpVQTBSQkQrRDlNM0UrZVowaStwY0NtSDFoOGdMa0o1SlNDZ3Fzck9BOUUz?=
 =?utf-8?B?ZTVSbDFqeE9MY3M0UVlEY05kZmV5UTduS2VNVkxtMUxGSmdzUlYwdGZVNkZZ?=
 =?utf-8?B?TXV5cW9kWXJ0anNXQXJBczFxVU5TRVRhYis1SE0yUWtaT09TeURWd2l2RUR4?=
 =?utf-8?B?ODZNcEM4aHUwQUY5Z2pRRTZFdFNmOTcvOHlTcDhUNFJXTHlnYWs0eEgyOEFZ?=
 =?utf-8?B?b1pEOENOTmpEcWtqUTZvZ3IzbDN4V1BoMFFreTRSVWczaGptNnN0bmx2WHlD?=
 =?utf-8?B?eUVCSEZHbGdGc3MvTnNvWHNZNkFCWUxQbCt5YnF0MiswSmpxWkVBbXFiMlZV?=
 =?utf-8?B?ck9HYzhvN2R5QnY5VXN0bWlmVmpzay9WTjJHNjVMR0RhakY2RFVEOFh6MTJ5?=
 =?utf-8?B?amFscUVhRmZVTVZZc2VNTis0bTBCUUQ2bFFhOXg5cWJlbEczZE5mV2swNWha?=
 =?utf-8?B?RHBldFl2SVlDclFwUEQ4c21RelVuUng3TkhabmtzZllacEpOczJ4R21CeWsx?=
 =?utf-8?B?TVg3eHJHM0VEWElnS1EzRzlYaWZaa2M2NkhOWnVnNDJtZUt6a2hKajFtbUpn?=
 =?utf-8?B?Ym0vVTFpaFFYdWVOdlBZR0cvZFZCOGNTTmlkWHM3dTFhb1pvVFIrM2NKN3M1?=
 =?utf-8?B?QjhvZXA4Y3ptS29NVU8xNUZwUW5EK0QvTERVK1JhYkYzdG11MHFjNzA4M2xR?=
 =?utf-8?B?aCtRSkQ3bCtqcTk2NCs2MjZWRUxZdFk3RnZwSWpsaXpiMlJDK01xZjhrZjBN?=
 =?utf-8?B?T0lOR1ZUbnE5WTI0ZnlHSTFmdFlaTEIya3RwRmVXSkg3R2ZQN1owYWVOUW9Q?=
 =?utf-8?B?WS9lT2l1V2xmaXREOGxtbGE5S2hLd3RRRTJFckg3UnhCcjBSNWNWaThqUFNO?=
 =?utf-8?B?aGRIMUNQa3hxdUcwL2dVR0Z5bW4xVjNDdU1PSWRFeFUxbUh4YWFmUWw3a2l5?=
 =?utf-8?B?aU9EMEZnRndPMDFnMFFES3FZR1Y1WjErUW9vVFdIQkQvdDZGQ29DVm5Tektv?=
 =?utf-8?B?UDcwVk11eXpTbCtzd3k2a0p1RFZDbGFmRU1lWUZUL2krdzFuZ0JJSEovMFF0?=
 =?utf-8?B?VmptMFdSYXJDZStYckt2ai9FeTJnNUx2bmpUcmo2Tkk5S2FuNVdJako0bXJR?=
 =?utf-8?B?akM2Z09ZYi92aitRN2xYNHBEb1JYTFhpYndhYjdZVHFIM1h6MVFITmsxSGg4?=
 =?utf-8?Q?ZAnkyKGpOczD6j5aBxjixqvVtHlJC5vsyLv3ppw?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Z0xGQ2ZqdG5manZmc3lOalRoRXRHR2EwM0UzWHFsRXMwMjhpY3VGOHg0dEVn?=
 =?utf-8?B?K21iTWVNamNUQXlNbTdFdnRtMHhUbG5EREJUQ1Z5SlV3TjlpVzRBeHUzVnds?=
 =?utf-8?B?Rjl1SmpQQlhJRlQreThSQnB3Qk83eFkvZkNvaDFLNWRiTDdRakFLQTBIZ2lK?=
 =?utf-8?B?SVdMcllac3FJY0RORTZrRG5HRnBOcjNTN0lhQUZEUStxaWxvT084QTB1dTdY?=
 =?utf-8?B?M0x2N0N5cmFrOWFrT1pNZXF5VW15d3BER1FkREhmOGFwVjBCSjJwNkhQUkRQ?=
 =?utf-8?B?VmxiczN4dm94UFFLT3hjdVJTMXRlZVQ0aUhFRG1QbnQrV2JVekZMVVpvbmly?=
 =?utf-8?B?L3pyZ3NSejdtVWVkZ1lrWmVLYVgrbnlLSmhXcHIyYi9Ia3lFcEliZXZsTktk?=
 =?utf-8?B?YUJWS2hENEN5Y3NFbEt5YXJFczlMSUZGNkhCbmZnOHlMWW0yUVdoNzlVU2pa?=
 =?utf-8?B?alp3RVRCeXhaQ1ZyZnA2WnVBTnlyalhHOU4yRy9nRlNYVmFEK3ZERVpnWita?=
 =?utf-8?B?bXBlbXpOK0srbXNtU3pjeE13OUE3YkUzTDVnTDBQcGxXMnR3dmdIRWJCTmhN?=
 =?utf-8?B?eDFLMnoyVXZOMzNUVk80a3pmSzRMTlU4eWpCMk9UaS9JZmt3OXNtb3hHTTlO?=
 =?utf-8?B?eWRyZ3ZXZFUvRmVpbWtOT2JGeW5JS1VJc2xFY0hRNUhJWDhnczRQNlROU0lw?=
 =?utf-8?B?b3RNKy9OQ250R3Z6VXh2c000Z3RRbUJoYlNIRUlDVmhtM2hlaGRheHJJWHhK?=
 =?utf-8?B?ZzVlRGhCUUc2K2dBdDQ0ZWNyWkxoekxMYmdXd1pPbENlWWw5M3BZeEtaWitR?=
 =?utf-8?B?WE9kWEVzZFI5dit5aVhFcnFGVXpoTEN0UFBXRWpuSlhwU1RJQmVwZVlLL0FW?=
 =?utf-8?B?UmZMN1BJRmUrUlpMeklTY2dHbTNJMGxrWjAyQzd4L2dhRnRyYmUzcWloMFZX?=
 =?utf-8?B?RW4zbDBRYllRV054ZCtoNGNFRFVjU0dDQkZEeGFQRnpaQkErUHoyVG1MWlVa?=
 =?utf-8?B?bWVUMGVXVDBIYm54UkZ2VHNBb25GcFNKazZYdi80SEVSL0duZnBtcVlYZ2tL?=
 =?utf-8?B?ODZ3Rk45MXdtQUVTQ1FEUzM2dndRTnpsbEszVW9OY3g2aTh0Y1NZWDFQa2NT?=
 =?utf-8?B?VUthcHNrUVRmSldKOTQvZGg5NE0zSUxJMkFkeExHSmdlZXhVRk9yZ2pRQmIv?=
 =?utf-8?B?ZVJpa0g1OTgyUlYyNElZaTFZM1U0RXRBbFk0SXRqQTFWU0FoZFA4Z1lyVExt?=
 =?utf-8?B?Wi9xZ0wzcUJ3NVlGd2RBakJBYmhxVkxLdVYySTVmMWluWW1iV3NQenhjRVh1?=
 =?utf-8?B?Z0lwTEoxOXZXZkR5b0t4U1pIVS9Xam1PV2RQUzI5ZktRQ2g4SG11eW1haXRN?=
 =?utf-8?B?Q0N0azhKanZVaklmYy9DbUJkMFN1SHZrR1E0SkdsYjVmODhYVHZvYzB1dXFG?=
 =?utf-8?B?S1hJdk02UjRoUk1zdVBwNXJtV1duTzZaWFI1STBTb1MxMXJMZS9OT01POTM3?=
 =?utf-8?B?SDB2TDdjODA1VkVBZmpObUU4RW8xeUl3Y2liWTdOMTc5bmcvVzdRRDQzZEZh?=
 =?utf-8?B?a0Fab1pVaWNtTnRCN01KSWFORDdJSEJIL0JmTnAvY3FYaElmSU5rTVpDcjRk?=
 =?utf-8?B?OUdMYUNkRWxmdFpDbEdtaVZjV1dUa1ZLWkM4R2NGMmRkZDJoTjE3dUhEWXdC?=
 =?utf-8?B?VkE0RGh6UmtYY0RZTi92RXByd2gxQjc2L2JhblVBK1IrRkE0RVZBcWhzaUxs?=
 =?utf-8?B?Vi9SaGpFTktEOGY5UXltY3o2cFZHOURQTG52MlAzS2VvZnhSTVZCQkg0UEtY?=
 =?utf-8?B?T0Z3S3ZqcityakVicTl0TnlveXZRN3B3NW5kcmhVVWdZdkFTVTdTeTRxOGxF?=
 =?utf-8?B?bkQ4NVNzeHJvdG44K01HVStjNGxYL3NSY1RSa1JIa00rNUY4RGxBbmNRU3lu?=
 =?utf-8?B?Y2haY0NjS3g1ak9LOHZjdUhXN09kTGN2NlZsd29xRmpjM3JNQ29uMmlxMGZh?=
 =?utf-8?B?OUxoSXlKVGowZ0xCQnVzd0gwRW5HbFplYXNxRFBKSGpFQVE3RGpOeFBqNXJR?=
 =?utf-8?B?OWhWSXZQY1hMYitqM01EMTVpdUJxcXVJclZmUkFEYWs5YmNVN3REcVpNMk1S?=
 =?utf-8?Q?YOYB++RD6HqRwYTEdJGO+kckn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	khh/jG4amK3OpJa7XM1iuVxHAnwA5Awh1NoXdcgJrk23VsKzwOFyAc+/oVQ/lAogI3Wk7PlVDIpkZl3kPOBU7TBYcJ/p6dXirxvFGAwryooK6VNE8YFT4WuBAsHRycP4yjCzchFmUkLVPtT+K/Kj2oIWfNSv5P5FXDLEANUx8NNB7u63P4DoPOlCRmxVhLpQU23oV7pjWtmERlpCqo0HoBDYyJ4GN6s1mCPvzIVsMZwLPpR5Yd9y21KHEscCw/M8VnUc9tYmNu5m38S/rqxxXo14+OJydn5H1vV4hp96fYQf0jqYCdqcWlQZw0kKYPzcMp029Hm3ax09QPDRtypKPnctvhh5xX0bAhdgUDy2+AaY48aAqhMW7xe65Vy+eOcXftjmSRBd61kJRk5+GAvCZH80RD/MmYjLa/iLsDOhmc/y/ZU9nJ+J9iKzztbfYU+8J48J2PzhjjwhRFFDMCHMCOgPVVPAF3phUQLe04tkey5p6RLa1UWY00unn8kNYLyXjUbBKZ3d15Gc96gfu8wBT/AjCgGiZqfwM4AAkLSLOYXwpslhrDTBkJv2REv2r7FENoPguLs7Dd8fOxo6GpZP+pqblmuGQ2ZLVroEGAki0DU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa5359f-ca0c-4aaf-ef33-08dc8f7472a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 08:55:48.4344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPWS7ZwQvlp+F1WCrYCG8apwhMMfiF94jBChvujl5tB0tCS5nTbBkKJUjqrAdEYj7+bLrHPWnrpeElJH1Inyqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6400
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406180065
X-Proofpoint-ORIG-GUID: SX0Ep6sedc7EgkNaQg0iUapwTCAr6LP9
X-Proofpoint-GUID: SX0Ep6sedc7EgkNaQg0iUapwTCAr6LP9

On 13/06/2024 13:23, Xingui Yang wrote:

Sorry for delay in responding and asking further questions.

> We found that it is judged as broadcast flutter when the exp-attached end
> device reconnects after probe failed, as follows:
> 
> [78779.654026] sas: broadcast received: 0
> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 500e004aaaaaaa05 (stp)
> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> ...
> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [78835.171344] sas: sas_probe_sata: for exp-attached device 500e004aaaaaaa05 returned -19
> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
> [78835.187487] sas: broadcast received: 0
> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 500e004aaaaaaa05 (stp)
> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
> 
> The cause of the problem is that the related ex_phy's attached_sas_addr was
> not cleared after the end device probe failed. In order to solve the above
> problem, a function sas_ex_unregister_end_dev() is defined to clear the
> ex_phy information and unregister the end device after the exp-attached end
> device probe failed.

Can you just manually clear the ex_phy's attached_sas_addr at the 
appropiate point (along with calling sas_unregister_dev())? It seems 
that we are using heavy-handed approach in calling 
sas_unregister_devs_sas_addr(), which does the clearing and much more.

> 
> As devices may probe failed after done REVALIDATING DOMAIN when call
> sas_probe_devices(). Then after its port is added to the sas_port_del_list,
> the port will not be deleted until the end of the next REVALIDATING DOMAIN
> and sas_destruct_ports() is called. A warning about creating a duplicate
> port will occur in the new REVALIDATING DOMAIN when the end device
> reconnects. Therefore, the previous destroy_list and sas_port_del_list
> should be handled after devices probe failed.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
> Changes since v2:
> - Add a helper for calling sas_destruct_devices() and sas_destruct_ports(),
>    and put the new call at the end of sas_probe_devices() based on John's
>    suggestion.
> 
> Changes since v1:
> - Simplify the process of getting ex_phy id based on Jason's suggestion.
> - Update commit information.
> ---
>   drivers/scsi/libsas/sas_discover.c | 32 +++++++++++++++++++-----------
>   drivers/scsi/libsas/sas_expander.c |  8 ++++++++
>   drivers/scsi/libsas/sas_internal.h |  6 +++++-
>   3 files changed, 33 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 8fb7c41c0962..8c517e47d2b9 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -17,6 +17,22 @@
>   #include <scsi/sas_ata.h>
>   #include "scsi_sas_internal.h"
>   
> +static void sas_destruct_ports(struct asd_sas_port *port)
> +{
> +	struct sas_port *sas_port, *p;
> +
> +	list_for_each_entry_safe(sas_port, p, &port->sas_port_del_list, del_list) {
> +		list_del_init(&sas_port->del_list);
> +		sas_port_delete(sas_port);
> +	}
> +}
> +
> +static void sas_destruct_devices_and_ports(struct asd_sas_port *port)

"and" in a function name never sounds right.

Can you just call sas_destruct_port(), as it takes a port arg? Maybe 
rename sas_destruct_ports() to sas_delete_ports(), as it does "delete" - 
this may avoid some confusion in names.

> +{
> +	sas_destruct_devices(port);
> +	sas_destruct_ports(port);
> +}
> +
>   /* ---------- Basic task processing for discovery purposes ---------- */
>   
>   void sas_init_dev(struct domain_device *dev)
> @@ -226,6 +242,9 @@ static void sas_probe_devices(struct asd_sas_port *port)
>   		else
>   			list_del_init(&dev->disco_list_node);
>   	}
> +
> +	/* destruct devices and ports after probe failed */
> +	sas_destruct_devices_and_ports(port);
>   }
>   
>   static void sas_suspend_devices(struct work_struct *work)
> @@ -350,16 +369,6 @@ void sas_destruct_devices(struct asd_sas_port *port)
>   	}
>   }
>   
> -static void sas_destruct_ports(struct asd_sas_port *port)
> -{
> -	struct sas_port *sas_port, *p;
> -
> -	list_for_each_entry_safe(sas_port, p, &port->sas_port_del_list, del_list) {
> -		list_del_init(&sas_port->del_list);
> -		sas_port_delete(sas_port);
> -	}
> -}
> -
>   static bool sas_abort_cmd(struct request *req, void *data)
>   {
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> @@ -538,8 +547,7 @@ static void sas_revalidate_domain(struct work_struct *work)
>    out:
>   	mutex_unlock(&ha->disco_mutex);
>   
> -	sas_destruct_devices(port);
> -	sas_destruct_ports(port);
> +	sas_destruct_devices_and_ports(port);
>   	sas_probe_devices(port);
>   }
>   
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 4e6bb3d0f163..09be69ea09a2 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1878,6 +1878,14 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
>   	}
>   }
>   
> +void sas_ex_unregister_end_dev(struct domain_device *dev)
> +{
> +	struct domain_device *parent = dev->parent;
> +	struct sas_phy *phy = dev->phy;
> +
> +	sas_unregister_devs_sas_addr(parent, phy->number, true);
> +}
> +
>   static int sas_discover_bfs_by_root_level(struct domain_device *root,
>   					  const int level)
>   {
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 85948963fb97..caeda847c919 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -50,6 +50,7 @@ void sas_discover_event(struct asd_sas_port *port, enum discover_event ev);
>   
>   void sas_init_dev(struct domain_device *dev);
>   void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev);
> +void sas_ex_unregister_end_dev(struct domain_device *dev);
>   
>   void sas_scsi_recover_host(struct Scsi_Host *shost);
>   
> @@ -145,7 +146,10 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
>   		func, dev->parent ? "exp-attached" :
>   		"direct-attached",
>   		SAS_ADDR(dev->sas_addr), err);
> -	sas_unregister_dev(dev->port, dev);
> +	if (dev->parent && !dev_is_expander(dev->dev_type))
> +		sas_ex_unregister_end_dev(dev);
> +	else
> +		sas_unregister_dev(dev->port, dev);
>   }
>   
>   static inline void sas_fill_in_rphy(struct domain_device *dev,

