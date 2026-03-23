Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048943C6616;
	Mon, 23 Mar 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289619; cv=fail; b=n61my70PBrSg9FLvSuOX5z30dTulBsL2oLoFR9pQcUV2hnuGphuw9m/ZUtNidTM9nbZ2ZO7azaK619OSH1BDxl2WtQcyU0xT++99mlMFmxdjGHdnxTSGAY0q5m7hWRwY0X91AxcSEnEPVfCb0oXroojT+q7eZKLuWX3vvNGttyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289619; c=relaxed/simple;
	bh=DFgO1GbpUwyw+ihmkEUcSEzd1gVhlYEc0hN/LEocJis=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nx+cCxgDjewoPDFiT3ummqYNBf3B8D/725zk+yFfbB7lvLwcEybdHhJA01rQqioUhtUwVMZorUAg4WawcrnV3gjm+66krFoPfckX5tPqQlakIahxFB1DgH2IgnUj6YflwC4vz24Hhsc3pt2sXVT8yBKtN8KQacJWgQ5/kZnd6qI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cPvl0ItD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YmowJEZL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cPvl0ItD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YmowJEZL"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NHMmkT3336099;
	Mon, 23 Mar 2026 18:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/okjhVdOAtTXjb3zX//zqvEl3zORNZZ8xbfYvpFKt88=; b=
	cPvl0ItDUe1LBnDUFbYqPo6ULbe9kMnMbF4+/7bdLcapCFS8LGCDIxsFrkiO54y6
	MWbstgPeMvcjIjSaxjAj3JNhnSI/nHtdfrc+Qai90dhsD3N/GI1osobkI2c+5FzA
	J/ZeUxk7pGnXeqs9NNDl6FRG+tqCGku8Mu6oLxFlqmdc7YyqPIkZt50gnokG4BD9
	ks1xCyMshw92FIGwWXvzqM5b3vTKGb+AH8BMlXP9Y0BxnDoVcn0TXN5BYptSGytA
	acRNNN3q7Lron1HMiCPcF0iqu4DEK3i8VLhQHbtu1SFurRCn/VgHnjbj+OI/6Szx
	Y+6flTLxU3yw++2WL5QZ/w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kfpjuqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 18:13:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NHLmnj029002;
	Mon, 23 Mar 2026 18:13:29 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8u0jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 18:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E7Q/KGgxJckmr7UsZULAwE6OqAXvne2kiaKg7Sbq+wKwSxypWgXHJDHwQMhqk5veGTVKdNMO348MTAouhOlh4eFCi3CTyG1YduBIOOWzw126ctjcBiNWvcPequkeXjAdkssVtUXlc5lv1H5I+m7gvtCYt6RNObZhP8dSNr9i1/WeQ9o3gMmoRRoJi+uwBUPP81Tzrm035o1s0/OTYjikvIeQnN0zMP2d2l0/RbrtddqHqqGiA0x+3NHzIaW9Gpvv8gFrZ/MFZlM0dWasOokLCaA5foHJbXPYf3ctikhs5X2MEhIVRAJvd6oPl539wzXZre8T8iQln98PIYHldmNQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/okjhVdOAtTXjb3zX//zqvEl3zORNZZ8xbfYvpFKt88=;
 b=lmI6F6wOUmT74/9TO13N6CyVS33ws4Qh57rW6meQzmo+GbsIT0j62V0JcCIoIVkO9Rgh22ajDfDnfoONfIQJo3n5ChUTFLLBrRHC/RkYTLLl3joSGjHL269PmoHP1Z1Roo18Q5wSg5jwc0ofsNLfxlUaocehkP1oKmBnAwykrPtsFU68JCwJ1K77eW588uM6VOKjObGjCyvKyiiADY+nKHjhUnTFLZvXjiCVqai+XFbMINaJ5Qi9sT+gWjbcsqc+mIOv87YAkxhCLU3mc+XOewGRIjcbm4L+27NhH2vjDqZ8A/3y+L9WP2GoCTWeQThjSURASBgZC4DdMosEniNu4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/okjhVdOAtTXjb3zX//zqvEl3zORNZZ8xbfYvpFKt88=;
 b=YmowJEZLWcg6uhYvgJRq5PVeOC2e8TAyJHYnsz0S6Zw9G4fbujy4kdOp6nHrMVxtBC/wVlUWyhb5g4vCiGaRzR63Y/JgqV1HKHihXAzm0JWQO2LBq+Q1I8x/2yYxFmxOF2TsHzFhjlPLMXEwUqOA7zoDdDnLJvPtctAbreIVHNY=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB6101.namprd10.prod.outlook.com
 (2603:10b6:8:ca::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 18:13:25 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 18:13:25 +0000
Message-ID: <b1f7855c-7c3b-4797-82f7-efc35a2f0ae3@oracle.com>
Date: Mon, 23 Mar 2026 18:13:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/13] scsi: core: Add implicit ALUA support
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-14-john.g.garry@oracle.com>
 <acCeVabspYFjQHPu@redhat.com>
 <1f6d5e0c-41f9-440b-a7f0-4850477309fe@oracle.com>
 <acF4d-uap6KdfAsc@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acF4d-uap6KdfAsc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB6101:EE_
X-MS-Office365-Filtering-Correlation-Id: bcfcc5e0-4ead-4c7a-d163-08de8907e01f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	SM8z1i/yPE8x5ykLbeEOif7qYs6HM5zcLaMc8Y3f4GaK0HBcGKB2VpxJdkuriNHJencbLgm2eI+lSbHxmmuofSI0fN3upnH6N8cO0OMBehJ0cNr3vnZsQhusQ0i60S8dIpDxVE6b3vih7JhV5HL7ynkV68sGeIGSf/O9DKKFwN74Rnbr8KuYADCXUUsKU2E8h6ulkW8KE+Ur4ZiHfw9q2qf1LIzw6XPBhvPPH9KXgW0FUepjyhxYc9LHT+qGAlwgbmv0byh3Yy/d1RWUBRA1g8xZGKFBpxry+xYkqfLDIbTeAxs0SUV+jxHx5sPcpw4fnpC5lK49dGlz5zojif/dEWGP50ZGJ34pkF4hLL8yWHyWVzHiIggBEHMPcJtvw2XM70NehHpPPY4kMBgQT385hGDLQ59K5CjPmwh7IXzH6f3OMGzc8VjK5dvTzA99vxr4bfLgq01PtQfKNtiNFMWnrLCn/ISjTcizmQ1uizvdtzz2+/koYWTtL20UQN+hP8pjEaa80oUcA9E3oDynyiku/a59rdMbI5AI4pbXCoMv9nYrPu8kTKVQSd3H6yUgnUT38XTPX+V4x1B7DrMB9FGSOGt8RBIuUApXMhruQh7KrWnL7J8xzrVwqHZj7urRMlMFGRm1CCPUNgYLS2lJ1hQ2bQuheG8x4LpPG6wXSYf+SU2zrlcWpR3EAFhlktp61fUgo6Ad3KFdcXP8JqPgBzO+Mh4eLWEDbsvcWFKKNdIzZ2o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1k5dTVZTGRmYTFqeDhEU2tJbDF5eWVUcER0cTFPYXErSXNackdSVkh4TFRh?=
 =?utf-8?B?VjNuZEVMY3g4QlFiS3NXZXNtU0V4ekRjaXhTV3JwSkJWR1VXYXgyRm5KVTRv?=
 =?utf-8?B?Q2xpOXVUNWRmbUxYTVRhRXZKcU1zeVVpU2N6cC83TVpvYUFRN1BJVUVjK0tz?=
 =?utf-8?B?RVAzK1ZIeFh2VTh6MmdrQTZZT0R5QzJ5Sk0wU0EvUFo0YVk4dWVJckN1ZEQx?=
 =?utf-8?B?VHpIejNZL2RGK0RBTmVDemZLWW9BdWlMSER6dTBlelVJOUx5RW1zUTlHQ0dD?=
 =?utf-8?B?d21hbHZCaHkrZFc1TzhJOXB3RkxpNi9iRWhXTHZIYzQ4M3BGMlFEYzg2M0NK?=
 =?utf-8?B?ZmtacnQ2Zmw3NC9HTzAyVVZkUmc4UWxSOGRtcUVHVnZmS0FUaXl1UTFvVGtO?=
 =?utf-8?B?QmNQUWw0VmtsYkZMRUxFdldaUWJXaGRaQzhJVVhIRldXRkJRY29sYzlhVVBx?=
 =?utf-8?B?dzBWUHZHSldCd0hHNldrZlM0Tkp3UjFVNlNOcFppOWtsSjdmcHdQOXFnQzNu?=
 =?utf-8?B?emlEY08yc1ZpTnR3U3ZGUDlMVFdIenFxZ0w2anZ6bnJFVHZQZnpuaCt5eEpP?=
 =?utf-8?B?ZzBYcWo4cHBEQ01uMTNBNUZuMU80MytmbHkrZG1vMnQ5Mnp2UHUrMTlDSk4z?=
 =?utf-8?B?eFlxR3BULzhPdGl2QmlaTFVMcGJhWTlMdWtBdmUxcjFQZDFlbUVUa2RXb2c4?=
 =?utf-8?B?ZndMR0JhU0l4Mld2T0dibU9KRFlBajZqODFKb0QrQ0VwWDB0RU0vQjhMeG5k?=
 =?utf-8?B?ZjJwaTd2VTgxNm5YWStLdCtQU2dSMFh5MHpzU3ZTanEydzBnODBZQTFMaGlx?=
 =?utf-8?B?cXg5aUE0ekpSUVMyc1RVZGVtYzVZendwTk9NSDY3VUl4Zm44TlkvdW5CRDQ4?=
 =?utf-8?B?eHhDYTZKZlFxMCtvd2Z2T25QZy84WUV6L0FvQk9wOHpJZ1NDVm92TjIvOHBD?=
 =?utf-8?B?NmJJQmsyblVKK3RlT2dpaHFGbFZCcVRLYVJ6MFRJMC8wblI5NERIZnZqNDdo?=
 =?utf-8?B?TXJZQmplY0ZyYUdvUzZNTEx4WTRrS1dpSmVQWXNqWFZxeStVYmdOblg5eFNp?=
 =?utf-8?B?d2lsa1AwaXZMRUdUOTMrYmRid3N6VlZkV0VmNUFNbC8zdjZGaWYzYjVBQ2ht?=
 =?utf-8?B?QUtNUjgzbmFZb1RhMS92V3hjbUFNSVc5LzJFcUVWRkp1TC9ueUtPc3B4cC9z?=
 =?utf-8?B?U2VjQ2JoUlY2cy84dUhCYXdsYmUrdXpJV1N4bWVkVTFwelQ5clp1TTl5RUdy?=
 =?utf-8?B?ZEFOV2YxbXFoR3FtNVduNlJ2S2Z1M1hNc3pGeGNFNHQ1MFdHMW1yeSt1Uy9k?=
 =?utf-8?B?Q1R6SVluSkd4TFByclIrWVZJdWd0ZXNibU94VkVrWEd6WThNSTVPUmw0ZnMw?=
 =?utf-8?B?V0N1YlpUU0pPRlpYbEwrZldkc2J4S1FsUEVLa1JxREpDWmtBU1gvSnlNQjhj?=
 =?utf-8?B?bDFTUkRpN0RmbDUzMnZCZ2ZhWU9WYWNNMnpudTJIVVRSd014NjVjSmxlbU9O?=
 =?utf-8?B?VzRsSVdlR0RuQ2h2TkcwYUZzWEtJNEpIKzZiVyttV2s1VkNzZzBxeThpOUhO?=
 =?utf-8?B?V2tjNDJ4MGdScjFCcHl0cHg0RHRzVGFpVExKQWd5ajhtYWVLYjVST3g2S2hq?=
 =?utf-8?B?ODI4bTMxTmdIUE5Yd3Q0MXJqVGRSS0dwUkd0cWdCRThqaWRUSXoybkovRXlD?=
 =?utf-8?B?ci9YWFhKeDcyV25OeXJEYytVWTloU3k1ckhBWEJCaVNscGIvN2NYdmU4VFpp?=
 =?utf-8?B?SUg5MXNGRFZxUVI4Q3NHMS9rVEQ4MmhUN3hhOWlMWFAvUTlmS1JXSjNNRmkr?=
 =?utf-8?B?c0E3Y2tpYXFHQTNlVjJGaG43cjUyamtheVdzbG5IcDhHS1hPVEtuZWU1dFo3?=
 =?utf-8?B?YXNmVlRNUmxaZHZURFpnSHN5M0RidUVJc2ExMEh4b2lzNkcvVkZiYXJiTkVQ?=
 =?utf-8?B?VmlOcFlkNkZ2ajdGZzgwbzBkbEZ1ZTl5K2xra1BHV05wcEM2dFJ2Ky9KbDdQ?=
 =?utf-8?B?S0t1MUhOTUpNL2tPN2gxNTJaSEF0RjUvS1ZVRDdRY3dBTkJaT3JkenZON2lp?=
 =?utf-8?B?b05YVTdZeXZyNWFsQjhxb0hoQ2UzSXNwUjRXVTQyTFFyQXBSanlDbzhCOGRZ?=
 =?utf-8?B?Y1NGMVplUDhqUlRzdEp1ZUp4WXpITXkrVEZmNkREWU9SeHF2aUFpQ2lPam83?=
 =?utf-8?B?YWRPNUxQU2dZRmQ5Q2JQVGdvYlRDYVRzRGRDbXk3a1lDTkU3VU9nQkpXbjJE?=
 =?utf-8?B?VXBIU3pJdjk3ZFU3Sm11QW8xZURSQVdoM3c5RHpodTZRZ3h3NUVOS0ZzbDJm?=
 =?utf-8?B?Z0VQaFV3anFOWU5XYXRsNVc3cktveXJ4QmpyYzNWUGZadEtOUnJscGQ0RitD?=
 =?utf-8?Q?44ylNRk4bq5/D3Yc=3D?=
X-Exchange-RoutingPolicyChecked:
	oZwToiNnkGOSBQgzuHQIkqamJkf7I9BYx7NXDaaMI5jj6osdLm1+EeFT2QrKeaCHYp958RiitkWDqO930dxAQsPDis9jxlKAHP3CDL7ZSuidCwhvTBzBMnDvJrKwRfVBxdJrSjIh6xXR2DoqmnfL/E/oOdEsAUPsRMOTL03nOu7EWEtIzhtaH03QpBBvRcKCoV2iumO3ut7z84TFMI6EaoznvWm2y0t7MC13+S3UVoc2FSy9iVeg8J6NjE43eRYkrQCHlnW2cETblO8xNTM1UWULov75k85rGbL3Y2gguU0KUDxIJTSN0Y7pZ2GXajGVwk16BdAymS4a9wDistEFAQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DL9dnFMhv66FXWJDS/Ybhx05dkW2+mLwK0vFlbVKPl3DWQ0I+0Xs66U/6aRr3KfYeUYrW+QSnJxxMitH9lAv7RW9AwZloP1twTuClF3n9cSssNXCt12VOSwEF9PAF/Z81HiQITO3dj75hPBT4nc8HtMOv5bXjVva/1/G6J1iDpFKmiCddzqfbln/zhtMYT0HMM5NE8zRdjjtRUbWsUFK2J7zsfXHF8jRI687n1wspnWrtBIiMB5QRYbZCo1j6f1fwxbYf95O/qO7TF+dh2RMqNZMeARkRbRff+EE8h9OeyX6I6yOXGtzgvXefVKmhsvNvx7BaVfyQN/XUfx4ADKjFwew+V39hYFftTx8XUy2q2sy/FSxOQAd6i2H9vhhBEkMZXpEiMkKa+DdhDdHnjLuKuWyZOcZh2l/MAek4tiPGEgQ7KFnP/ms63Za2IJFdigJhq4znWCldubistAyG3xLzUmea7PI+cvoxAh8ok1qRMg0fpG+n6JDlRqm4CZ1QKszO7VrgpbZklc4nN2qtuKfaXUpvTkyUCL7z6GFlltIN1p3YrI3ajunUMeFAy/HYrlTpXJz+HPp2rgnqOOa5GSklKQ/nuZZmGWHRnE/jhu+IU4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcfcc5e0-4ead-4c7a-d163-08de8907e01f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 18:13:25.3515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /h2fCBM/T/VDk0oYTAzQzRTFd4GoS9/8Wq2/z9XV13k8RHkd1EnOY5EjC1MANVlHIfspDseci5Yli3czDBsw/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=982
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230134
X-Proofpoint-GUID: nSge6YSjnA6sVTKZSoIdgivjm18VNya9
X-Authority-Analysis: v=2.4 cv=VKnQXtPX c=1 sm=1 tr=0 ts=69c182ca b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=08pd817gyJ2sUVycPTwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nSge6YSjnA6sVTKZSoIdgivjm18VNya9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEzNCBTYWx0ZWRfXyiMILo/8JRvM
 SF49Ve0e0F3kzefOmj0jxcjhclkyOhRTJ/DSZk0PRotCYJ3Y75grRQXf+xjzpoSIpMzU6F0ozlT
 OD/DadvvsKSoN28kyHqqQOKT6PCnexteD3l2AGMnxGgZrn245Mb3OOTelflfRE4zW932NycR5+x
 G/pAxOyRDgpeWRpS6NyZbZ7u2Lw0CciU+5k/eGl1o+VPMyOaj1VDdgSjYNqhml9x+4F7Mz5ql7z
 7g5q0E8e0JQBCbjO/gSwrmbMImI73XZ7J84R9LIfjuiY9ZP1bu6nQmbHeZLRpmVhee6nkQUd9SG
 Sk1bbLsC52F/mUwnvdQmbfj2XgdYKKentmSgKvq9l/UAh4e+uLa/2x+CfvmKDM7fdaHsd7y2eDN
 jRICwPuX45c+BS6lv/hDA88NLkGVdf65bW00b/R/poD9UvXFsuMweq5YGYyQS9Q81twnIg+9lnq
 RxIPed5Qw7o+QVbkdsg==

On 23/03/2026 17:29, Benjamin Marzinski wrote:
>> Yeah, I tried it and I just thought that adding the rescan callback was a
>> bit messy. I can go with the single function if we think it's better.
> I would defer to the opinion of an acutal SCSI maintainer (which I am
> not) on this.

I'll check for a better way to factor out this code so that it does not 
need to be duplicated.

Thanks,
John
