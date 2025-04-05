Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD381DDC21
	for <linux-scsi@vger.kernel.org>; Sat,  5 Apr 2025 12:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743854602; cv=fail; b=dq4qzVfqV6CFpQSLaPM3ADPlGt8OHEbYNyh2uWyZ0ugc2hYBr2JcTv4p00PiB9WusR0Nu0pkc6SrXJD4s7CI7EKoCfCNaaaq7RrvqJ4zkkI+jZPMWpSYnVBtUpBRZn7Q0b5JLrmqIGcCnVF3drIcFEZrUJHZX1RUnPCRwa8sk5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743854602; c=relaxed/simple;
	bh=GpN0RKqmTiBNZ/HzULftqd9zyhT62WaQ/JNcbU/tt/s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CpgajfFK7UMxFTEwqeArvm2CpSntS7XgY67q0H559WzASRFDKMckIX7dZrUy31D30g3MZRRZ56TrAE39C6BWBcYwDTdh/Bo3u/xq0CZoDF//f0cjqQSuFs0Bb7o4lvBKAzZjECrqsqzyc0tGmENgdidw7JI3nPbaVUV5n/BnjWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=l3Ls1cN2; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="l3Ls1cN2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1743854600; x=1775390600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GpN0RKqmTiBNZ/HzULftqd9zyhT62WaQ/JNcbU/tt/s=;
  b=l3Ls1cN28hQuWapDy98KWOZI2DOoSCet3LAgG5KoS/ffkymJf/ACnrEp
   zxxdtCdyiCZXrinRWjni27b74+E/zbg8q8lLP7n2DmrTBmpyddiMP2e9i
   LJnRGY2Du2U3ox3QK8DuZdZiIyQjnr/2x2kBHC1B1T1p3zhfFtYc7YQQK
   XJPL+BTvm2HuKYhIuluQriKW7lquBhHIM5qOgFhwERb/7qOFumZhqN7hY
   OH8q8k9A5T/DjC1lBOtVx1+A4l7jkR3+VJOSegkLLMUKtzyAu4YRxgoUA
   7Y89otc4Mft2BOSZ6A4JTFVAITIzVSloGboFiKv4DYR/Sy9MUDzyGVGvB
   g==;
X-CSE-ConnectionGUID: 29evHF34R26+2sX/xELu7g==
X-CSE-MsgGUID: IzBYG3ytQACRMAKKzTuRmQ==
X-IronPort-AV: E=Sophos;i="6.15,191,1739808000"; 
   d="scan'208";a="70753992"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2025 20:03:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUhXT5VXAXvBdzuNQC4kYdVE/xHhI0F72PTswXrd2Vkw4Xc4V+UFHChwIBgFqL/ARVThw3F8UC4hixDiD1RZPPTlAYNR8Vuv4bk9twPu/HzQR7gmmqbLniywF0ZSKoPoYhaReaeub2nYbKIK5MZHojBwptnAJYUewrgSKqVQeLWo73G+9RTiQtVf2qk9+v3WZYLKiCAQdwbdNY9J20I3Mwfp/3v0J+SY4XbiE0elw8ddLM+caQKbYza1t3DvNWsjdt++Ro7/ypoDra5LMIY+VzNJ7lSE1gNF8aZndbGEbqHLco2Jy9z7HdaPCSZHqdv9sGtqlf92BH5S4c6lbOIRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpN0RKqmTiBNZ/HzULftqd9zyhT62WaQ/JNcbU/tt/s=;
 b=IHiE29zDp8VgP9+VqzUTCd+OB9MmK56EtGz1/Usf5v/d78GCZVO8KuIBABhMcohPO/SGt3dUT04Gyb2Nz0b2+QRAhhOzTtjtc6MHv27/SAKnzhoPcXxOwqMEXGflAJrQj9DB2LMSV3Ng+O95hKufmSWuILMAVvWvL6Zgg/rHw/EjRup2XIgd23KE/nmoVdTIOmxPKmabF6ydeKIiuCmap+ldZeukkvCOWa7obDdxK0ldY2JapeQ2J50Otwh9383HWul6+euKffeDCiQ+JxpmWX2OudHx3skmBaDXoxBk13kzBhJ0ny79B1ZJEyOG47/7hqhUhmoOBxarQVm+SFutjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SJ2PR16MB6229.namprd16.prod.outlook.com (2603:10b6:a03:58f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.43; Sat, 5 Apr
 2025 12:03:10 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8606.029; Sat, 5 Apr 2025
 12:03:09 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, John Garry
	<john.g.garry@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 00/24] Optimize the hot path in the UFS driver
Thread-Topic: [PATCH 00/24] Optimize the hot path in the UFS driver
Thread-Index: AQHbpN7wis7e7LiQ+Em1xO+3Ljzcz7OTS0MAgAByn4CAAT2EQA==
Date: Sat, 5 Apr 2025 12:03:09 +0000
Message-ID:
 <PH7PR16MB61963D108209A71D37BA2418E5A82@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <bcc48e7a-8d83-46dd-ad71-d7587d2b0434@oracle.com>
 <3affc917-6634-47fc-a6d2-5b57a2e34bef@acm.org>
In-Reply-To: <3affc917-6634-47fc-a6d2-5b57a2e34bef@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SJ2PR16MB6229:EE_
x-ms-office365-filtering-correlation-id: 53e626ba-bfec-4c64-05ec-08dd7439d564
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SW9jdG4zTWo5Q0ZjUTBaV2dwRGwxd0daclVTQ0xKc1NWVGZCYzBadk5hYmVz?=
 =?utf-8?B?WTBDV0lpZy9mcnJ6T3lORktpaWc5YXJSYURtOEFzRXpwb24vSFA2a0xtLzVH?=
 =?utf-8?B?NVhPRXVYS1pZbzJ0TEVsQ3FKVU5IcW9td3dtdStjYVNTcFNRbzM2d3piZm1o?=
 =?utf-8?B?MHlDei8yb2l5em55N2tETmtKTjE0bmo4ZEM4NmdYeVFwUGhzRDRPcmoyVXU4?=
 =?utf-8?B?amdWZVdBS29xUGxxYTNpWnpJV2krYlk5U2pTdjU2Q2NLME00cDhwL2RIajhM?=
 =?utf-8?B?Uk1Cbk9JQVQ5T1pUSUtucWt0VVQ0VUdNRnNRUVI1Q0VpN29heUo0VFpNKzEr?=
 =?utf-8?B?OHJvc1RQV2VNNjJvOG8wRmpROHpSdGFFN0QvS3hSMDVuU3A4V3FpM2kzUlJN?=
 =?utf-8?B?ZjhsVDJBbDd4YjBxWWVpd2tGL0RQQWpqZEJvWDJ1L3EvdG5WZTM2QXhoWFZB?=
 =?utf-8?B?ZjFsU1ByaG5YL3lGVUVZLzJSYmVkZm5ONG11RURJTnY4aTJvSjFNNXo0ZXcw?=
 =?utf-8?B?Sng2L0xXN0cyZjZ3a1dWSGdDMFEvOHZHc3U3bml0cndnSDZLT0hmSXpleDNv?=
 =?utf-8?B?YXZjV3lwMitPMEFpazNyQ3pvY1gwem1ZelEyRFlhVjZPc3RDKzNZNFB6VGJS?=
 =?utf-8?B?Z21aUVFPSDlNQjdyRytEckZvb09XOUQ1WFNWVU5CSGk3VjhmQ2IvWjRJeW9y?=
 =?utf-8?B?Ukp6ZDlIYUV4bDh0WFJOUUhEY1N5N21tUWNzRmt4WTVwbStHRXprOXRKTldz?=
 =?utf-8?B?OWpwSzhjUzVWUndMYzJDWDcvVWs1dUNrRGE5Q3NPZVpIRnlYUU9ucW03M0tn?=
 =?utf-8?B?RlE3U1FpR0xUQmhycHJzVEhEbEtubkc3dDhmV21YNGZsMUhRbXFIL3JzTS8x?=
 =?utf-8?B?ZDVyWFZkYTFuQ3J2VHhCQUN3NGEwUmdPaUhrOUNEbXdxS0gyOU1MR29Hc1py?=
 =?utf-8?B?NjFNbkUvTS9lT2Y3WjlrZVd5UGliU1ZkalJZQzd1c0dNWCtyczZXS1E3TytS?=
 =?utf-8?B?V0xNYzU3ZFNwT3VKcW02Q3ZJV2VHdVdUdFcxb3UrdmZnSFZpTjB0WTlIbHRY?=
 =?utf-8?B?ZVF6eVk5TUplOWd6VFIyOGxZTDc5R0x3aU1XcjdCWll0SXI1ZThNbTl3L3Fy?=
 =?utf-8?B?SEFaSWZiRUkxWGFkb0hBaEczdnlXenp2TkxWNVlTYkNYNVZoSGt0cE9IRGRj?=
 =?utf-8?B?ZzNqMnNCWDBLMGhXODhHN0RDWmtBZ3dCWWdQMGQ1djdVeGFVQlpVaDRVeGF6?=
 =?utf-8?B?S0o2ZlFselI4ZTcxWVRpK0FucS9qc0lUQzVkYi9Dd2hTb0o0eHBuM3IwenFX?=
 =?utf-8?B?UWNIeFBsdWlTMGIzQlRYN0lqWm9VYjJROWFaRVFYb3I1WURqTDV1RzBwUVBv?=
 =?utf-8?B?aThpUE1Ka0ZrditFNmpiU0ZLQzNKY2N1emlsV2sraUtSTkhpNk1FV1BjUW4r?=
 =?utf-8?B?aXF6dHJ4eXNlMTJDK0NFaUtmM2xzMVk1YTJXa2cyN2twRFpWcHkzR0dsVE5p?=
 =?utf-8?B?Z0dXYmtkUUkzeXo2SUhZQUNQS2IybTN1cDhrTk9HMjhzSFoxTDhMRU5KZnhU?=
 =?utf-8?B?VDdwR3VBZFNVWStHNnJZdkJST1RNalhpMy81dld4MzVIaU5tbjRMOC9ZVDh1?=
 =?utf-8?B?cC94SUZLRkZPa3BhVFExNldDcFdsc1pRMUZ3Y2lzK1p4aFA4cjg5OXRRVzNW?=
 =?utf-8?B?b0lDNnZnMWVGMks1TTVrRkh4REFLZ2dEdEZKTCt4QXp0R3M5dGxzNDJEUGtt?=
 =?utf-8?B?ZzgxVWJNMGsydlF2VWcycngrMkhacE9ON0M5bWZDZUt2N1QzODZ1MDVlcUZJ?=
 =?utf-8?B?ZVlBUFJmYVdlY3lxVXE4NjdLZFlkdmdXTmhlTmZ0RnM0VGZoSjRpVHVsZURG?=
 =?utf-8?B?QVd5cWttRHlwamlkdUp5eHQyU2VNcjRHT01OTmFmemoxNkYwdFM5cjk5ZzlQ?=
 =?utf-8?Q?Yg81h9FfaNeMHRK/MdMdycV258Ivm8DZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YlJZMzFWRVpCc2hJVGpseitBTXVFM3pKT1o5N1cxL09LUEVkQjdLZzdWVlpy?=
 =?utf-8?B?VW1NVm0wandhY2NDa1RqRnFPdlpTRW8xcmtZNDVWd29KV29rWmh4cUNZTHFz?=
 =?utf-8?B?L2xHMUE5UHIwNVp2K3VsY1ZLbDlGRGJiakpmNFZxbFpIRXVnTEJmT2lQMUU2?=
 =?utf-8?B?T3hiRStmOUJBSE1jZmtZTUJ4czNTOVR0OHF1R2dST3VEd0FvOU5VamxzUWpi?=
 =?utf-8?B?T093Mk9aVEVnWlA5Ry9hUmJGYUZiRlV2Nm1SZTdqNnFzcXEzdEFIdFlOYVB6?=
 =?utf-8?B?T09yTmxhNWV6b0FYMEtrandXMFVTd0xtNkY0ZE5uVEtGR3BCYUlrL1k2dFRL?=
 =?utf-8?B?VHFvc2FMOG5SSFJZcDNFL2x1cTJFYk9BdG55bzBLRFZVQTRQS2RYTVNHek15?=
 =?utf-8?B?ajJ3dTQrVkkvQUI1Wlgxc2Foc0hreTU0b0ZSY1piZElkOXVab1YrZmpBR3Z3?=
 =?utf-8?B?dmJ5ZjZPRk90dHdFblpERnFCc21BNGU2b05LM3Q1Q3NLMFM1NnU5TXkwL0JR?=
 =?utf-8?B?bVdXb0E4OVlvV2ozUEg0RDB4RnZ1QVJlMm9kZk5BT0RCd2c5N0d3bnl4THpz?=
 =?utf-8?B?TEs5Nk1DeEVGZTBldkcxRkVqVGhsckVFdVdnbWk3QmpxOUl0Y3NIOWJ6RG9T?=
 =?utf-8?B?RDhFWnVNVTd4TGppZWtVZDR2d2NuZVB4QUkvekw3S0hoN0EzZy9yQUc0aUNi?=
 =?utf-8?B?MUE4dCt3MjZFSjlMVmE3Q2NVQ2J5YUJzRWhqUlVXZmFrNXZsdlcxRXRCcGNK?=
 =?utf-8?B?OVVkeFY3QnBleEZIWForZjlTbFpMV2RiMGxZNjdnbWVsNGI5RTR1WWt6eXBK?=
 =?utf-8?B?MHhyZlFCL2Y3NDZwVkRSTmlEcHZOMWtnaGhnWXo1STZnTWNWMjZDYjNBMTdn?=
 =?utf-8?B?MHRJa0IzalFhZG5uRkFyZFphc3J6NjlCTjlheFVqdzZHVzg3S3QyN1lHT2lE?=
 =?utf-8?B?NzEyYTFiU2ZIVkw2SWxzNUJObHFuYVkzQnV4ZTNrVG42NDF5TkN1VXJvcEpu?=
 =?utf-8?B?WnR0UDhCUElXcTZEajFlSWd4c0JqcVJTZW9URWpYM2FqenpJVkdlUlVKRkxH?=
 =?utf-8?B?OHpCWi83ck5KbW5sVnpjSzlzYnJjbXhQWUtnV1hiZUtPN0pLVUFZM2YvQmo0?=
 =?utf-8?B?bmtCdnpxYmdMb3hsVkIxMit3RDJGV2RTTWRQQ1JMNDVTWmp2MEJRR2hZRlNo?=
 =?utf-8?B?MGlQVWtrMnVWTlVBTWFoQ0o0Z3NoNkpWRWJjcnNWbmwwRGpIS3d3U3ZMZkRk?=
 =?utf-8?B?L0J5aE1xVmxZdWRGbzBTdWVZQ2JFUkxIUlM5MmJiYjRHbEhUVWhVTm5XUXJW?=
 =?utf-8?B?czZWckRkMjBabnl1djZYTWY0U2FweHBxOVh6bzdDVVNSNU1rTmxHUFNRZ1BB?=
 =?utf-8?B?Z1FhREVlQ1hIU3Uvc1crU1NzMVYyUGo0RkNmOFNOSWQySTYyaXloOVpaWEc2?=
 =?utf-8?B?aVlFd1k5dm56M2JvRVczSmlBUy9Ob3V5UE1Zc2dzOXZtTW9sQUxJdERnZHF3?=
 =?utf-8?B?aFBkTGFiM2ZMNWZoS3dZb3BvbEdYLzl4QXl4MTg0REkybVVEbFVoRmlKNTFp?=
 =?utf-8?B?cnNYeExvSW83SWFUcnNKc3oxTHk0SHYrdkMvZ015M0VJZkRmYTVaaU4xakd3?=
 =?utf-8?B?aS82bkVPdXNZMWlhR3NZaXpPRHpUMG5ZK0ZHbWZNczhCUEx1eDhXYXdKY1dj?=
 =?utf-8?B?UlIvWlNLSllCaG5Ic3NXbzVHNCtuT212ZUxhd3lyT3kyS1IzcCtpTVNrNkxO?=
 =?utf-8?B?YVZ1NlhjcUdiRUs3aHhybkVPZ1l3aC9zaU9vUkJGKzlKK084UXkwU0gxVVRl?=
 =?utf-8?B?dkllVVNQRnUyNmxzZnlVekJXVnNULytDdG1YRXYyQ0hVNWZVVHFUakcxUkxN?=
 =?utf-8?B?N1V4QkJ0REU4V0xzK2FqbVp5eWlIL0VZNWFabFdRWndocHFpdFFxNzRzUERU?=
 =?utf-8?B?ZitOWXBZMzNaejl1VjFSQms2NUxvdXduMElFY1p2UW9xWlNoYklNc3JDVm1z?=
 =?utf-8?B?YlhtTFpoTE5wMlMzblBqbVM5U1lRUzdQemZ0QVNhc1NQN2tnVnNadkE3YXg4?=
 =?utf-8?B?RTFIdENEUHRQWm1nVmZibE9wdEs5QklsVmFZRUZmL3kyY01yeDVzdG9vTUFt?=
 =?utf-8?B?MmRrc3BuN09ZMnhtajk4YWcrYmhUN0FpMk5ZVSsxTWs5Q0Y4MGJtVlFWOW42?=
 =?utf-8?Q?xya+xbo4nINc7HTrWTHdSCLMSW/vWIExQ7iyjbvp2S11?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y2107TeB8goJjSb2BNU5WI5jZI+oj0DdG8hsL4bafu//Wp+bq+c8TqQneDA4Y5hDW2bOaITCphngsgfgJZr1ZvUct6b3B2gGeGZX9vuCiCLvl6YzLLl81PbIQcUqv3zXKFAxHIfdeKMbfcHnMnQkYwXwr+NHxDgXA8BaCxOGo58yDOxj2AQPloibheVPAqtRIyF//vK83Q1Hspfq7pHXVhVfhhz1LAZbAHmqqeSca9J2nGeHKmMzUqmY6GIoRG82h5nucc7p5t2de76vnNkSjrGeoPCMp6iDiY0kFsPSSEOmL+K2jK9PLfM7GDiMEOjCx8y/D5WXMES8pa5qMA1Dp+haoZ4stYlYbGrxaU4IuQ/6gC0qKqv/RzUL5V4RPfCIZiBwymjYVOW4jJpMxp7YPoWQ0fAIp5qmanC9EOIVlkV9McLI1o0QeS/E5s10SLYejqdmpFAfLv+pI3pvg4vUXYsq1y5iX10laiUbXsrfV3PC02YYh+G1/TqbqObEVjR3g8h7c31OkrBh7WjSrTIY+IShF5Ieynyps9Vam7XGg/qTwKl40dBR2iPcflY9tMH+iCHNrlzsLUS1ChgfO8UixeTI4Ln9+h/Y/PGdUjyzVsvPt45+BZMHvQ+0iu6KsLlSPUY7841DoVBXtxT6nX7e+w==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e626ba-bfec-4c64-05ec-08dd7439d564
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2025 12:03:09.7971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /9GY/rafL8DAS9eMY2AY9ZhsU3OVEvzkJETHQ6cXlKAcHgTMzG46CQEa/ja8AeURaN+3u3D2ZtDLyL1loidtkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR16MB6229

PiBPbiA0LzQvMjUgMzoxNSBBTSwgSm9obiBHYXJyeSB3cm90ZToNCj4gPiBPbiAwMy8wNC8yMDI1
IDIyOjE3LCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4+IEhpIE1hcnRpbiwNCj4gPj4NCj4g
Pj4gVGhpcyBwYXRjaCBzZXJpZXMgaW5jcmVhc2VzIElPUFMgYnkgMSUgYW5kIHJlZHVjZXMgQ1BV
IHBlciBJL08gYnkgMTAlDQo+ID4+IG9uIG15IFVGUyA0LjAgdGVzdCBzZXR1cC4gUGxlYXNlIGNv
bnNpZGVyIHRoaXMgcGF0Y2ggc2VyaWVzIGZvciB0aGUNCj4gPj4gbmV4dCBtZXJnZSB3aW5kb3cu
DQo+ID4NCj4gPiBUaGF0IGNvdmVyIGxldHRlciBpcyBhIGJpdCB0aGluIGZvciBzb21ldGhpbmcg
d2hpY2ggbm93IGltcGxlbWVudHMNCj4gPiBTQ1NJIHJlc2VydmVkIGNvbW1hbmQgaGFuZGxpbmcg
KGluIGFkZGl0aW9uIHRvIGFueSBVRlMgb3B0aW1pc2F0aW9uKS4NCj4gSGkgSm9obiwNCj4gDQo+
IEhlcmUgaXMgYSBtb3JlIGRldGFpbGVkIHZlcnNpb246DQo+IA0KPiBUaGlzIHBhdGNoIHNlcmll
cyBvcHRpbWl6ZXMgdGhlIGhvdCBwYXRoIG9mIHRoZSBVRlMgZHJpdmVyIGJ5IG1ha2luZyBzdHJ1
Y3QNCj4gc2NzaV9jbW5kIGFuZCBzdHJ1Y3QgdWZzaGNkX2xyYiBhZGphY2VudC4gTWFraW5nIHRo
ZXNlIHR3byBkYXRhIHN0cnVjdHVyZXMNCj4gYWRqYWNlbnQgaXMgcmVhbGl6ZWQgYXMgZm9sbG93
czoNCj4gDQo+IEBAIC05MDQwLDYgKzkwNDYsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHNjc2lf
aG9zdF90ZW1wbGF0ZQ0KPiB1ZnNoY2RfZHJpdmVyX3RlbXBsYXRlID0gew0KPiAgIAkubmFtZQkJ
CT0gVUZTSENELA0KPiAgIAkucHJvY19uYW1lCQk9IFVGU0hDRCwNCj4gICAJLm1hcF9xdWV1ZXMJ
CT0gdWZzaGNkX21hcF9xdWV1ZXMsDQo+ICsJLmNtZF9zaXplCQk9IHNpemVvZihzdHJ1Y3QgdWZz
aGNkX2xyYiksDQo+ICAgCS5pbml0X2NtZF9wcml2CQk9IHVmc2hjZF9pbml0X2NtZF9wcml2LA0K
PiAgIAkucXVldWVjb21tYW5kCQk9IHVmc2hjZF9xdWV1ZWNvbW1hbmQsDQo+ICAgCS5tcV9wb2xs
CQk9IHVmc2hjZF9wb2xsLA0KPiANCj4gVGhlIGZvbGxvd2luZyBjaGFuZ2VzIGhhZCB0byBiZSBt
YWRlIHByaW9yIHRvIG1ha2luZyB0aGVzZSB0d28gZGF0YQ0KPiBzdHJ1Y3R1cmVzIGFkamFjZW50
Og0KPiAqIEluc3RlYWQgb2YgbWFraW5nIHRoZSByZXNlcnZlZCBjb21tYW5kIHNsb3QgKGhiYS0+
cmVzZXJ2ZWRfc2xvdCkNCj4gICAgaW52aXNpYmxlIHRvIHRoZSBTQ1NJIGNvcmUsIGxldCB0aGUg
U0NTSSBjb3JlIGFsbG9jYXRlIG1lbW9yeSBmb3IgdGhlDQo+ICAgIHJlc2VydmVkIHNsb3QgYW5k
IHRlbGwgdGhlIGJsb2NrIGxheWVyIHRvIHJlc2VydmUgb25lIHNsb3QuIFRoaXMgaXMNCj4gICAg
d2h5IHBhdGNoIDA0LzI0IGFkZHMgbWluaW1hbCBzdXBwb3J0IGluIHRoZSBTQ1NJIGNvcmUgZm9y
IHJlc2VydmVkDQo+ICAgIGNvbW1hbmQgaGFuZGxpbmcuDQo+ICogUmVtb3ZlIGFsbCBVRlMgZGF0
YSBzdHJ1Y3R1cmUgbWVtYmVycyB0aGF0IGFyZSBubyBsb25nZXIgbmVlZGVkDQo+ICAgIGJlY2F1
c2Ugc3RydWN0IHNjc2lfY21uZCBhbmQgc3RydWN0IHVmc2hjZF9scmIgYXJlIG5vdyBhZGphY2Vu
dA0KPiAqIENhbGwgdWZzaGNkX2luaXRfbHJiKCkgZnJvbSBpbnNpZGUgdWZzaGNkX3F1ZXVlY29t
bWFuZCgpIGluc3RlYWQgb2YNCj4gICAgY2FsbGluZyB0aGlzIGZ1bmN0aW9uIGJlZm9yZSBJL08g
c3RhcnRzLiBUaGlzIGlzIG5lY2Vzc2FyeSBiZWNhdXNlDQo+ICAgIHVmc2hjZF9tZW1vcnlfYWxs
b2MoKSBhbGxvY2F0ZXMgZmV3ZXIgaW5zdGFuY2VzIHRoYW4gdGhlIGJsb2NrIGxheWVyDQo+ICAg
IGFsbG9jYXRlcyByZXF1ZXN0cy4gU2VlIGFsc28gdGhlIGZvbGxvd2luZyBjb2RlIGluIHRoZSBi
bG9jayBsYXllcg0KPiAgICBjb3JlOg0KPiANCj4gCWlmIChibGtfbXFfaW5pdF9yZXF1ZXN0KHNl
dCwgaGN0eC0+ZnEtPmZsdXNoX3JxLCBoY3R4X2lkeCwNCj4gCQkJCWhjdHgtPm51bWFfbm9kZSkp
DQo+IA0KPiAgICBBbHRob3VnaCB0aGUgVUZTIGRyaXZlciBjb3VsZCBiZSBtb2RpZmllZCBzdWNo
IHRoYXQgdWZzaGNkX2luaXRfbHJiKCkNCj4gICAgaXMgY2FsbGVkIGZyb20gdWZzaGNkX2luaXRf
Y21kX3ByaXYoKSwgcmVhbGl6aW5nIHRoaXMgd291bGQgcmVxdWlyZQ0KPiAgICBtb3ZpbmcgdGhl
IG1lbW9yeSBhbGxvY2F0aW9ucyB0aGF0IGhhcHBlbiBmcm9tIGluc2lkZQ0KPiAgICB1ZnNoY2Rf
bWVtb3J5X2FsbG9jKCkgaW50byB1ZnNoY2RfaW5pdF9jbWRfcHJpdigpLiBUaGF0IHdvdWxkIG1h
a2UNCj4gICAgdGhpcyBwYXRjaCBzZXJpZXMgZXZlbiBsYXJnZXIuDQo+ICogdWZzaGNkX2FkZF9z
Y3NpX2hvc3QoKSBoYXBwZW5zIG5vdyBiZWZvcmUgYW55IGRldmljZSBtYW5hZ2VtZW50DQo+ICAg
IGNvbW1hbmRzIGFyZSBzdWJtaXR0ZWQuIFRoaXMgY2hhbmdlIGlzIG5lY2Vzc2FyeSBiZWNhdXNl
IHRoaXMgcGF0Y2gNCj4gICAgbWFrZXMgZGV2aWNlIG1hbmFnZW1lbnQgY29tbWFuZCBhbGxvY2F0
aW9uIGhhcHBlbiB3aGVuIHRoZSBTQ1NJIGhvc3QNCj4gICAgaXMgYWxsb2NhdGVkLg0KPiAqIFN0
YXJ0IHdpdGggYWxsb2NhdGluZyAzMiBjb21tYW5kIHNsb3RzIGFuZCBpbmNyZWFzZSB0aGlzIG51
bWJlciBsYXRlcg0KPiAgICBhZnRlciBpdCBpcyBjbGVhciB3aGV0aGVyIG9yIG5vdCB0aGUgVUZT
IGRldmljZSBzdXBwb3J0cyBtb3JlIHRoYW4gMzINCj4gICAgY29tbWFuZCBzbG90cy4gSW50cm9k
dWNlIHNjc2lfaG9zdF91cGRhdGVfY2FuX3F1ZXVlKCkgdG8gc3VwcG9ydCB0aGlzDQo+ICAgIGFw
cHJvYWNoLg0KTWF5YmUgYWRkIG9uZSBleHRyYSBzZW50ZW5jZSB0byB5b3VyIGNvbW1pdCBsb2cs
IG5vdyB0aGF0IHVmc2hjZF9pbml0X2xyYigpIGlzIGNhbGxlZCBvbiBlYWNoIGNvbW1hbmQ6DQpU
aGUgYmVuZWZpdHMgb2YgcmVkdWNlZCBpbmRpcmVjdGlvbiBhbmQgYmV0dGVyIGNhY2hlIGVmZmlj
aWVuY3kgb3V0d2VpZ2ggdGhlIHNtYWxsIG92ZXJoZWFkIG9mIHBlci1jb21tYW5kIGxyYiBpbml0
aWFsaXphdGlvbiBpbiBtb3N0IGhpZ2gtdGhyb3VnaHB1dCB3b3JrbG9hZHMuDQoNClRoYW5rcywN
CkF2cmkNCg0KPiANCj4gQmFydC4NCg0K
