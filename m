Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A268328643C;
	Mon, 11 May 2026 15:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778512698; cv=fail; b=kHwcnRdrVPGzdALQ2j7PabrvRHhMEMSGa3tj79epuvG+f4aeRp1tlnYRfD4WCqUpjHWRV0jjs527ZCvd7If/eRnrF2DWBkTSDP8UrBk4L5YR2jor77a2xoyPaSbQ6/5PvbejpuzhrkpknmCMn/D1E9zfBqkYRckfBav7k5nnyOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778512698; c=relaxed/simple;
	bh=P1qBgJb/2b/RHtMlgpwkQgNWPkDf+wn5cLcGybn+qUw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZlO5lobDENH2/bcRi0H4pIsLxtxqnrU9yz51y7CiwsUGvIecgrrq50LuyEl3gRaVP8Q1zFtK7cMqU67BaC+J+2nLj/XWYbYI2LqxTOU/hs3dyyeUDml6DKyMdZeqJ6MJ5ozajaQ6SGv+88BK+h7Mjd1/p5EnPKrv7ijWgBY3wmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H+0mejFb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=souXIL4D; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H+0mejFb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="souXIL4D"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BCVuWP3452645;
	Mon, 11 May 2026 15:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=32OJWPC1uvoDT5eoRkBk+TSlVJWm5bnb/DnNGTIPyJk=; b=
	H+0mejFbTUiBlS+LwBZh8WJKKKU9oLGqs2lP4rqzsYmZEPiV/bUIZZXD8FQ29pBs
	8bw09G3mVrW+gzkvLdveQEiwDy7cCz9hPGjB0UzLaYMsvFZEgqWgrhkGTXgS/Ddb
	bMzS8QuvkOjLO7KiTcomML4Y7zNvBed/44iteru+ZtbOtZ5PCSdJJLxmOOZad9EW
	OcycsNViVyfiypMjNt2aRjmTwolSehXQTqODinEvPaqHz3ftF77Ms0UFRbhTB9tf
	IKSjyti0M3EWCoccJPEiGG+2Xh+CYYRAiK42iHTDT9epWiIccSJgJpFwxbS/d55S
	SFZNlB7PhZJqcfUmp76jqw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e1uq52tbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 15:17:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64BFGQD3037177;
	Mon, 11 May 2026 15:17:45 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013062.outbound.protection.outlook.com [40.93.201.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e1uc9c34d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 15:17:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEH9k8zDyNzNTp1/Lod6nQIauV9Kpy2Md+zlJrHJs7AJmSdg0vaLObkqfsQhHa/OEHxvuvb2U6xfrqYgCRYFTuRueOSyU1+OiN6X8FHE6ZJMg0HFaQa1lKg4obvhR7e6cOwx8udis/Jr9ONyg2Aqo8AaIbAh1AGKtCDsH6967VYClH57AySQOGGCuwEA/miZHWbbzfIdezNr9XKLW04FAdrh0Eukxqp/17pnoQ1NIQ5VhfqSgWFAL8bb1kHlnS+J+2L06N6xATTznbhbwSrbp4ggwxVP/YEO/AwuufBWZinafzTiWGDvCM041atnGu68egL3ZfIgjDdEIzrTPyHnkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32OJWPC1uvoDT5eoRkBk+TSlVJWm5bnb/DnNGTIPyJk=;
 b=eSiQjJywfhseztidjr7YNnIh8MLBFsxWQDrC/khLf08zfGGup+dWBfe3KIDlFRiyypFCm2JikHqQkhImr5loHQuJlLOu0Rlofh5NzLNIu8RbBncR1n64RhJgly5wvI8Ir1EUTHc9z6qTEVap5LhU8JETa5gjDeBCMFaaKOn0/gJJxac2bAMRx/7ZcdLhQlG3eywu71c+RYGWbgNAh5be+T3aBEzv3V1l97uYxkAUhX2zoYG3nkWFUOW+nmoU1TeRJSB2Izd0rI3yCAl6y+sl/tvJqRxOKSxao+UJE18JOEe3P8Qjte5MTqkxLiHaUllVVCxdn+zT0FNnnLQYlFYKxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32OJWPC1uvoDT5eoRkBk+TSlVJWm5bnb/DnNGTIPyJk=;
 b=souXIL4DWGk09shzGPMXAncjx4vFyghq7Lj2KtJpQJ7uRPsvsgKTFI9vw7hS6sgqsfWLQPuHoNKaUs4bH9uCAk5xmKvMEzMtovbhwURm+ntsVcM6kGaUk8/ncK/5kPdpOf5mrSnA7b1uJOfFFvnwj4sI0s+p44Oea2991aU3T9Q=
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6) by SA1PR10MB997606.namprd10.prod.outlook.com
 (2603:10b6:806:4ba::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Mon, 11 May
 2026 15:17:43 +0000
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3]) by PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3%8]) with mapi id 15.20.9891.021; Mon, 11 May 2026
 15:17:43 +0000
Message-ID: <1c8832fd-07d1-42d8-a687-039e0cb83b57@oracle.com>
Date: Mon, 11 May 2026 10:17:41 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libiscsi: fix spelling and format errors
To: Wang Yan <wangyan01@kylinos.cn>, lduncan@suse.com, cleech@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260511093030.63542-1-wangyan01@kylinos.cn>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260511093030.63542-1-wangyan01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::19) To PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF8C8C3D129:EE_|SA1PR10MB997606:EE_
X-MS-Office365-Filtering-Correlation-Id: d113f9af-47a1-4d00-abdd-08deaf7072a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	HL2VQ8+m/L9ZweZVi8DpFS4kXs5hrxDIYPgKBL+UdJ2Qrc1jYE93pdW0VILNzzGyDtJkjVlX+5Yza2+olPlwE57DHhE/S1zwa0jYWV1Lw0xAT06wEvn4mNDTD8U7GzVa55FAkAYuq2clpEhIifz4lij63S7K8cCq7zYdESjUpNxgjOYDmTdxqxBFdUZN+WC3ulezSiaE0eqKipP989JMoziDe/nj85/BpP4a2of5AYSZ+rP8d1913p9sHGQKqwrveAIRx5e29Swwhk4xV2FdaOIzqVQPhIsA6ysArIJj17csYI7SVFgTszkEeqSTR4RqQDDw8oiWtontAJZ1+2ytlCvUxrilUwSnIRW70Tkj7CQ14OanE1EF0ZbFgas/NIFim8qgZ7UQOeeMcRjhVwWJofAcR1crb5B6oQAEBR2ju8oHGvOhJfmSSwo+92fEa8I3CJKxBqWY37h17w9o6afsWLheDqCLsvEZJOE5K7fGhaWpPMLmdtzXkJuen9lsdV7mfdD810uwLACZ3jUtGlmkECU7VNjKo44g11WWGclIU4ubtNRqRYY6NkHEWU+7V6lsJauJywBca1r1xc8Mc+HgrnRZXLZFiz0gzLAZXiB7UOjR/V+r1DARLr3bP81Uebnd2CNzbCK1mjAeOwPqvVNQDZM9hsuIu0TBdEc4THqEO2pSxb7wPRmekyuvtDwJYE2f
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF8C8C3D129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVhhdHR1Ums1WXp4UU16SHRnaFN3WWhUb243UHdBUmtCRWxYTDMvN255U2FE?=
 =?utf-8?B?c1ZLdUJFSVFmUVdvSjMvbGlpbmdQc0thREFnZ01WUlRzQUlRT1lrQks0MUhW?=
 =?utf-8?B?SGRDcWtWb3dqTThBK2I3MS9zZkYzKzU3T3BaQm5sVFZ4V0ljNjEzM2FBL3Bi?=
 =?utf-8?B?TFhFelBoSEx6WlR2Q24vRS9rK1c0UVRNN2hKYzFvdWx0a3dwZlF1L0VPOHNl?=
 =?utf-8?B?bXc2Qit3dnJFa3lnd3prNnNkY0pPMytrd1NaWG1mOVVJbGVXaGt5VURGZ3JL?=
 =?utf-8?B?bUNmY2MrYk1Nb3psaTVQcGpqa1hIQjRJWTBOTHFDdDgzK2pJMm5NRUNXR2xT?=
 =?utf-8?B?WWgzNVFZcmtDTTZ3Q2FrUDNUT0piN1RScnd2S0pnMXk2SzRNdjJYNVF1NStj?=
 =?utf-8?B?MUNQR2YzbnRBcE5LRGpodWp0RTJqb3ErWUpGbjRkbXArUDRTK3NtUk1BMWcw?=
 =?utf-8?B?VkxwVWtOa0pMK0hNcjhPaGdpbTU1Wng3Q3d1UGVxRHdlcUo2TURmd0QyYXI1?=
 =?utf-8?B?QkRsUDZoVXFKTktVbUlVQmxnZ2R2SC90SU8yaFZzWTlieWxoU04zMEV4di9S?=
 =?utf-8?B?Z0xlb1BpWkZ6V3o0REJlTkRXOTBHdkhrdjZkUVU0WUpVMlNiZTIvSDM3SEZX?=
 =?utf-8?B?eTJQZTluUDVQUHF2aldxM2orQzl3d09hMDJkOXduRk5pSTdIK2E0QkFpaG9l?=
 =?utf-8?B?OHQxR3pFT0ViWHM0aWxpRE4yWkl0Wkgzb0tjTGZUZUQ1NllSNHg3K3VTUlBt?=
 =?utf-8?B?S2J6M0Z1a0VacUNSNnNqd3lhdWJHMmRHbVJDbVBkYnRvNnhhL1hLRGR0Rita?=
 =?utf-8?B?QkdkK0VTTkpPU3hJTXdudnFEcnV0eHFmN1pHTWdFVVpvbSt0dUh2cHVvOHo4?=
 =?utf-8?B?ekVSZjNLOGtxNkhQTEdLOGZmSEQ0TmVOWERGQjk4VytRcENybzFueHpUY090?=
 =?utf-8?B?bEdrYUhQcWJuTjNyMTBLaDU5NWdrU2FRL1hwc3I3RStnSlUrSklMWTJGU21K?=
 =?utf-8?B?U29oaHkyUkljbHloNHZ5NXNFTmxKK1hSSU1Ock5ORVRCQnR5NXEySHZHUDVJ?=
 =?utf-8?B?dE9KVytidnk5d2FlZFh5V0UyWFllaEk3UjEzTDJqak5vOW55UVZ4eSs5SXFJ?=
 =?utf-8?B?S2pkdGxDMXZtQjdQMVRXUDlEeG1CVWJmeGdvRU4xSlgvWEo3T3N0Yk50T1M0?=
 =?utf-8?B?NXpKNDZ2VUc2dHpWYjJxK2Nka2Exek83dC90QTdLWnVlNGdGdTdtZS9KQS8z?=
 =?utf-8?B?T3phYklXMFM2c0hvcGNiNmgxc3A1RE1FQTVoWXdURkxtWEFiZGdkckpTMDA1?=
 =?utf-8?B?WEhudUhJZ1Y1ZWlRNDhtY05YbHdyODRUQS96YnBOWU03eXdoM1FWcGlwN0pS?=
 =?utf-8?B?M1ZTRHVvSDRyeWZSQWlMOUVCd0Q3aStqL2ZsM09NUjRnYzhsTFlHb2hPQVMz?=
 =?utf-8?B?cXRLNUJqZXY2TVhHYi9QUEkrNFl5U2h0NllUaUdCQXhvWkxxclUxaEFIaVIy?=
 =?utf-8?B?ajFqQnVEOEVNaVh0OXhNdDlUV3ZaYk80RG9QV2ZTeXdKaGlJMGtHd0piZE5a?=
 =?utf-8?B?MjZCT3l1TWMvbjVzUnk4RnBsbGljazAyZjZzYm56YkkrKzVYcElJQncvUG5T?=
 =?utf-8?B?MHdVWU1mbW9mUDU1eENNKzR5RHNocjJPWjdjaFBrNUhLMEM5REJjOTZjVjdH?=
 =?utf-8?B?bmxld2tPUDVjMDhrUStkVFdocFhlSEVhUDFQK240MURSRDVHWkU5RmxjYzFr?=
 =?utf-8?B?N2FUckpRZWsyOEFZRDg5WmVybmNuZWNwakI4TzdFOEVwRHM0MUZJdE00L0tz?=
 =?utf-8?B?M2Y1enRSUFE4UWcvSThHVjhia2FPakNqa2t4WUNZZG4rOGlUaFAybXljR1N3?=
 =?utf-8?B?RWdHT3BqaGFVdzhsWlpxM2NmNHpEOFVGdG12QW1YeFE0WTVKWE81NkhzNlU0?=
 =?utf-8?B?dVVjMHRMaWRHOFRIdzBlaUtoUGVhSEJZVmo0YTEvRXUwa1lUUUJNcFVzaEZk?=
 =?utf-8?B?b3k4cWFJalVXR29xb0NIRE5YRjExTUxmbGYxZGtvWmphSTNidC9OeklDUGsz?=
 =?utf-8?B?bVIwek9XRzFuSTNFbWlwbDVyallmeHBtT1kwdmRwMXZKNi9kMHJlNFdNM254?=
 =?utf-8?B?QmExdWZQaDZHc3huekRBUWdZYWhJUWNWbFl5TEhJbkZ4MytURHEvZ2NTWmt3?=
 =?utf-8?B?Q1UzQTNzVit5cGo2YmtZZTMzNkUzdU92cVhFQVhPYWhpTGlNUVVVWVo5bE01?=
 =?utf-8?B?YmRKa0lEZmd6SXlsQ0EyRHg5VFYxbzdKT3dZT3AwMlpCa1NhNEppalBYMUs5?=
 =?utf-8?B?aXBLYlVVNHBDZ1BMdFdreEwvWGFsODdDZHRVV085aE9XUCtwdnRKVDhjblIw?=
 =?utf-8?Q?k9qUblx5uePwQfns=3D?=
X-Exchange-RoutingPolicyChecked:
	PoReJyL92x776ol+KskB7dcfjesiaHlj3hopk7pUEzQiRD/9F0VC9DpkYtkMF8mGhrRYfguYX3a7kOXh3pTLjmeecDK6ewshuWJpgnW1/nM4aKsDdLPPNIWypINlfE+eXi/RZLYkepLME4/YmYgpz9UEl/Jxk+3IR5SGVI3jq+iIptrLaHlNjyNs0nj/Az3Q0O6atQouMDR8m5CKO7myXjk5LrHbl5qgmdBQzclFEPOq0aW5LOBRpec4kXM0W0NZhx7GghHXO/ZL8YoBo9Gs6axGB8iOEujVup1olUDz5HUZQPZl4WuA0+6UBFp8hTpMlEI8cRdH4bjMyYcDyVNrWg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bGmphFb1/EG60zpW9/JZhTr64HgGeK6SxtSMElNpBX9ZWVDsIXY3+pRBpMIxBWUhTSA3kKZe5isvmpzU1TkkS07aL4yoNJXDZA8tDcUffX/Qt49awNQ1jZ4w0WTeOqbpP+yFzmDPnskPsHkKjvWUD4roKq0NYoNKr0KP2ZFI5AM5k5mG5r1QNxn2fu5wawpYkCC1l0U1QyFzreJPZjFFlHY6U8LXCMcBPVQw5iG/RZF1fpKjAznU1R95c/pBq2Rx9fi8TPovN9mDTDIVPD4xX3K4pwIe8ft47QPsx7sXmzQp/V0ALw+VBRtwauvdKSxcXyJB8aJo1MsF1V0TdhBYRRbndb+51pnYvWnaAL4wPa9/lkgfxsC2volMp44lqEKQSLrdA7LZGhPA14iB4ZO2ml2UByLzLk4wpqFqgNXswO8Xdt874wkrDFr/w1CnRLQia4DdE91xlgTpOZXZ66FBWqMSMhNO+RkFZID5CPsVrONvmg/cQs24g0iy02lLkDKBXEZqi75t1j+fhu4Fw5xbaga70pPdelld4KVuv7yCYDt8Dz0l+V4gkx8DCqo/mUdfvUaDrcfsDLsLMSlffaWnQwt0iKtatIiOsbBbi7lUMU0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d113f9af-47a1-4d00-abdd-08deaf7072a8
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF8C8C3D129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 15:17:43.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4inKGLuUCsz1I06E4Lxx/wnjeEAe9Ot1uv5AH0AJT1zmIsVydD9wfk2368nGTbKMzq+cwn4HwC+czI+LhK8BzczRXafPt0FYF8Wr2RzzfrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_04,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2605110168
X-Proofpoint-ORIG-GUID: eTzrNMr2ysXevhQ_gicLtVNkqDPY3EpC
X-Proofpoint-GUID: eTzrNMr2ysXevhQ_gicLtVNkqDPY3EpC
X-Authority-Analysis: v=2.4 cv=NrrhtcdJ c=1 sm=1 tr=0 ts=6a01f31a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8
 a=3h6muG0NllwC7HcR2TIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDE2OCBTYWx0ZWRfXxCK6vNG5b+H9
 hyyc0r/mm4v62uMj4Gc8AeGH4PVbRqiu4oFl1aTQAobjlH05QrUCSnbbT+SRKSz3cUSQW6Karpk
 8Bg3bv6+MDCd9W/oy6qofprBFbkv6I2O7B9Ayo170v4sValMQPW7gv+43sNb9JYEXt8VGY0mJoM
 bH1Pe5mLdWhXiXa2O0Pxm2H00DqEO7JWE+4rdnq0R70IpVqfGSi8nXCY/NTT9kF4KI1QK2j2Z4c
 w01rEVFqLOkWvLa7lkzX7fJnntpKqNyN3tg6p6wa/+qnEmOOZquATkn5b6iMvebD+9Bo1dvgx76
 Krqb9SFrxyZkjlCg3t6W5V6sfZdmrUm5stuziRJSsGLskJMvVKb52J4KtEuEiIEp+XfNkcHe8Tp
 0mEaKJAPNBiIZj8qaOcjL0ABi8l5+tUIuojGS4dZiFPqugGCCrLx8uwPGn4WYlfOrUs8gqbQrhL
 j54PhvN51iCCN2iBNYw==

On 5/11/26 4:30 AM, Wang Yan wrote:
> Fix two issues in libiscsi.c:
> - Correct typo "numer" to "number" in iscsi_session_setup() comment
> - Fix format string "seconds\n." to "seconds.\n" in recv timeout warning
> 
> Signed-off-by: Wang Yan <wangyan01@kylinos.cn>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
