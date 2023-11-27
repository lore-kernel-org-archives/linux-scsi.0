Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Izeql7rd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0On4sTV9"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C82BE;
	Mon, 27 Nov 2023 12:44:51 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ARKcnn0021953;
	Mon, 27 Nov 2023 20:44:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=bGXS/fNtOieN/Zpg9P7DTDyatRv0QOQ/U/kXKyI7gfM=;
 b=Izeql7rdc7lbf1OiMSUwnjBNWMxOs5hWozsy3V0NAuqUSD2XPhZIKPh/D9h45TYyg4el
 siBUp3o3OSauaZC7H0fxJazDsBSK3vUv+Iaexh1yv5b4snEgaJlKYj5fA+yfqOpt3ep4
 lVU/uUpR5DWV7Il03gB1wE5bgsBBSh/Fz+xqjM/NZfqZ5M0Aux1scQFJmjOe1OprT6ew
 P/eyLqCPhbv0w3JPwCFadWdaPq5XlPtovfGIQUH7Wwildn5ruWrQdqiZYjV/GQmnitxA
 uu0yPpFyRiyHit86/gax27Jr3ks/EiXhw8bsisy/fOOF821Vzh04q2NaGZA3RMX9SaKC eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk8yd43uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Nov 2023 20:44:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ARKZjJQ027002;
	Mon, 27 Nov 2023 20:44:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7cc3k5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Nov 2023 20:44:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9aAJa70s5sW9Zeib2JCTk2yz/uszb7LhSGgN0nrk2esC1iQsLXzXRpYRwQeI0c4oWAg2Qe5Lfq0LoLsiNeQ1DsnaL1J6TKuXetcYXULzBNHdCqhh9/ndQ+uk1I7Meg1BUjN9eEo+TpXfwtWvWk/zMn/3rDXbVPrKfZFWrqihGiOFuVhhPUGqfkEM30BaHsYziIB2mmAt19hDd/LYiSTzm7xRF1rgN/Cu6mTQ1cxHgQrHS8c0xn3oAewk41GbNkHpSQxFKgtl9ls3u79+JcZMweMVXXKc5uq9y7gYbSKwBS365BzAqUM6eLYBpGZpd2MX9bwQMBTo/mc67bywOimOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGXS/fNtOieN/Zpg9P7DTDyatRv0QOQ/U/kXKyI7gfM=;
 b=KJZSu1DC/kA2n70xE2ZoG0urIDML6ieT5cNLVU7+bBcJaOp8TSYshwBL5v9eUIxrUWW8/bkyq54scJ950BUjLEAc8IioMwW3HWZVuZeRpajygsF+zdZiOpRHlXLvsxY3se77Y+T5BVpN8Y/oLOte1O3Sr/rrVuoobYXXUZBHBegjOVUOpI4W8fj1v1SfK65WMAzg9BnoJ5wtR3kDjJy12nnniERX6p5abwnqLKVI2W3X/btT740FBOXoyfgYCO7EKrv+kfk2Vcv6X5qaeqPh0ZW8/H5/8TS7RBeah8OqAhZ8+KWBZTf3tsHWLcj4/ds9Wa7swJXCQNFvtFjxiMCnTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGXS/fNtOieN/Zpg9P7DTDyatRv0QOQ/U/kXKyI7gfM=;
 b=0On4sTV9Ftf9KgYrU9fV3Kzvtm+MyAERzeszvkcx5df0Hx12ndxDYd3+wcHMPb9NiXPquXgxussFQak+rOTLMLtzp2iwMzcqfuM9letVAHDZEsqkz1XOMGJbh8tjR/vvyotvaevrlakLSiwPcAjDKWFmL2J30YCCTZ5j56MaM8c=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO6PR10MB5585.namprd10.prod.outlook.com (2603:10b6:303:144::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Mon, 27 Nov
 2023 20:44:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 20:44:42 +0000
Message-ID: <f30da2a7-90b8-4396-9bdf-922862195a0c@oracle.com>
Date: Mon, 27 Nov 2023 14:44:40 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: Possible Bug? LIO does not support SCSI commands with Immediate
 Bit Set?
To: Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.de>,
        target-devel <target-devel@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Chris Leech <cleech@redhat.com>
References: <31851279-0884-48ba-8c4b-7d6147e59508@suse.com>
 <00eb0928-5691-4e85-a923-de9c4934856c@suse.de>
 <5301e42d-7fad-49e1-8ebd-7db569416974@oracle.com>
 <8eaf4277-04cf-4c01-a96b-760c8fedd5e5@suse.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <8eaf4277-04cf-4c01-a96b-760c8fedd5e5@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:8:57::12) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO6PR10MB5585:EE_
X-MS-Office365-Filtering-Correlation-Id: 12454ef9-e373-46ce-99d7-08dbef89ae84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	KhS1/Hr0S/1ZebmvOdnuIcfpNrhMCTtmPxQ+RIZ/vLfpRdjK+GJD1t54YrM8udGG6qHE8m0GcO9ovoCuNycvW1Q7aB7OLnjV9UeeO25uCOg/y7yyHNcrGxR7ORqHqRi+5m521F4TWjuZxRuYXZO6LrcCZxPEE4m4Q4ARcjwjrAhc1vXZmmGMmnlbWKoM5zPSVlexxsqDyM4L7x+ZCW5BX6+5xwan5bHtebwdge9lGSzWR2qc9Tdd+0gyozUroYNZ8WNUGgTHJjfl9klbv9vC6Drmx8j2cVRNfsmlki2uE34YjYoxjsAD2FZfkgdz8BUdgJhT9yryvJcfNQP2PNY2vwzlHSptQdSPnOPp00fqaJv1MddPv3ISvqF2GfOgFf6DjQIfMudmkRvGcC2cUg4216i6hfI4wJRCU1d9mwm8ygXT4c6rDIFbSzu7+fat56I0xkDRrRnL/KksqT3ctSdIqfP2SbE9w0IV+iPb2Vy6r9kK5DoaTAOtJSKLVuFEGzxJNd6lDL23TXc1xCyUGQLnmTEjpCGNOPPFaBelXzIDCCyaM3rrXRz9Td8c1DXcTXf7MXpFq9Pp/YIFq5Y7ZJPY3qu06i47yk3D2i63h7YqRQlS14mwusguL0JYtKUxbCOFQzbNl3BGeCIAXPeueeLMm4uJuTpQ7YNWdU2m4olbWws=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(376002)(346002)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(31686004)(2906002)(14773004)(5660300002)(6512007)(41300700001)(478600001)(36756003)(4326008)(8676002)(8936002)(6506007)(966005)(6486002)(38100700002)(2616005)(53546011)(66476007)(83380400001)(86362001)(66556008)(316002)(31696002)(54906003)(66946007)(110136005)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y2U4OElScXpoVk5nRmpNb2lCaFAxTFU3SUx6dVN4WWxiVmZpMlJ4R2w1Q09a?=
 =?utf-8?B?bWptS0FrU2xhSDAraHk3bmhETFRPLzZQdkVJeUE5dFdMd0MveVNULy8zL2lH?=
 =?utf-8?B?NE8wNjVxQjV5UEFFSGxUVEVVVXRON1NQRjgwZG15NytKNVZ6YklzWjlwN0hG?=
 =?utf-8?B?cXlWKzl4NDF2TU9LNTZmd0Nta3U1T3p3Z0ttTTZVMVpvMExJSHJhMGh4elox?=
 =?utf-8?B?WW1RU3NiSEpuVHZaQjRnWDhNV1B6WjlKWHFFL2JCTTA4RzlsL1JCYlh4LzQ0?=
 =?utf-8?B?T2FDdy9yNGsyOGdRMXN0aHpTOVFMUXdqRGRYZHVKMmFtR2JORWdaU2pYNlZU?=
 =?utf-8?B?eEdWc01PRzhUUXhtOXhnN2haMUpZMVloL09mMEpLTUhBbThHMURORkYwdGxi?=
 =?utf-8?B?aTg0eXMvWHVXUzlZdDRLSmIyMWxqbE43RkJjOVhMVDBDVm9tNDZ1RTZ6bHV3?=
 =?utf-8?B?ZzlTNHkxTWF1WHRNZWY2aVRubFRBL2dhcU42ZFRvSTBSUHlvN2l2S0IxM3ZF?=
 =?utf-8?B?bXZialhhYjdyV09OVHFtbXFLcGxMekNKM3lvQmpWbmY5dVJMTWZNRDNKMUg1?=
 =?utf-8?B?TmNzZERaTE1rOGN2K3F5WTFBRkdPY3lNR045Vlo0azJ3bkdidlQ2cUUwTkIz?=
 =?utf-8?B?UTBLYUF3eGxudzhaa1hNMVgwQnIxcG5ldW9UREU1ZVV1MUNBYy9LUGZOcXR4?=
 =?utf-8?B?ZmdJU0grajlWZENPMThKbnpjNzdzWUEra0EyN1pjd0Fjc3E3RGdUcGZheURK?=
 =?utf-8?B?bC9BN3ZXVlhuVjJ6NVNjRHE0ZkRLdGcwNk54K0FHcGZHOFEzUkhMbUpkQ1ZQ?=
 =?utf-8?B?N0NpY0Nkd1k0dXFNZGt4Vk5tdVlvWXFHOTNObzQ5cVdvUitOdHB6emxRT1dp?=
 =?utf-8?B?WmlJK0ZrVFFHWkc2SjVMVE1QajltMVFsZVFVbTFKbEc3SHdQNlMxZW9uNmgx?=
 =?utf-8?B?MFUrbmZ6ZFAwT3V4cmJnRWpobWk5YjlVSzh6MjdVZWFOSWNUbnhZL2lMVFFm?=
 =?utf-8?B?VUFCT0pnditGL0p3V3ZBaGhOd202QVdDSXpMVThEbHJDWnRzQlNLR1VMM2pG?=
 =?utf-8?B?S2NzQ09nWFpnZ0ZZZHFFcWI4dXhCVzZlQmtxUkxCdVlvejZoQlpVcmN2dHB0?=
 =?utf-8?B?MTFKbFVFTERvRWxpeUdZb0VoeUpSWUx6amtVcjRZWUtlR1NDWHFqd2w1RFIw?=
 =?utf-8?B?U0plMm9TTmZ1bEhOU3JxYXIyanRSR3A3WGN0NFkzRzk4b3NLVlM2OEI0VGNv?=
 =?utf-8?B?cFlwY2Jla2tKSWNCeW93aVI0dndtVGI3bHBTT0xXYWFPZEhvRUVZUVFFUHVC?=
 =?utf-8?B?VW4vc2d0WFd0WnIwWE9KSEZ1bzhuTjVMdFlTYUwwOXpxWnVSczB4bmZyV09M?=
 =?utf-8?B?TFcvbEZ2T2k2UU1QaVdOK2Q1THNndmp1Z1UwaXhGb1lMSjNIRFBuY3hqZkgv?=
 =?utf-8?B?NUthRW5wbVFHK2hqWDg0akswRWVPK0RxRWhHZWhXVE9zRjl1SG5lVk1xdHJU?=
 =?utf-8?B?UDJnWDVuWGp5ajY3TERIQ2hydlA1TTdNcWt1RXdrTGdSTVluSUJnQmZ2amhq?=
 =?utf-8?B?QnRZMWw4eitIcktIS0o0eUNaRlUzd1RiNlduMHBNWnpMOWMyVlVBY0lodlIx?=
 =?utf-8?B?ZktvclZaRGhuRGF2YWZlRXBZUGpGYnF4NWNjQkF3b3piZnZZakl1TGszWWhq?=
 =?utf-8?B?djNFVjlmTWxVWUhtOTdHSVA1TUJxamVIblVMRGlXT0lzNzFOVGJvRjJ5Y3BU?=
 =?utf-8?B?NXpZUVJtbVNmN2szV0dYMFo4NHNjT1FaYlBaeDBjRDFySnNDa0VtaDNjeGs3?=
 =?utf-8?B?amRQbDAyMlNkR0djRDU1QTAwamRsSUVEeHpYZi9DZXhkUDA0NzdKZXhUKzFO?=
 =?utf-8?B?Y2ZTZU1zUzEyMWNwNmxCMitMY2dZSnloR0krMTBQUTlSb2VGb3FMekZTZ1lM?=
 =?utf-8?B?LzZIanBpTnFEMVNMQmRMa1VSb1VRUnhBYVlpNGY1aytKZmJJNS9lL3JSaHBp?=
 =?utf-8?B?azZwVTkwZk9KN05GY0VMN0hJMVZoaGVROVJZdFlmTDB4N2Iva2RmZm5UMHg5?=
 =?utf-8?B?M3RkVFJMbWJNcXkvYVVTbXFJMXhVM1pQbjZkelVpb1pWcDVwK0xXS0YrSndw?=
 =?utf-8?B?TkFta1lUUUlCc05WVDYrcVBNeU1xOGhoRS9UWG00bTBKM0JCcEtXOGpuUzd6?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tDZtAyg7pe9Z7aCP1S04TMtdkqOb6+69wegEwdbRGpMszhbnvDWZcowHkTqM0EvJBiYV9WgrHafckf/977kAxHM1dFT1WWS7iheLCsqLOL3AU/dfW/7ZObtDF4H76nXdF51+M4XLC8QHzelzmInDck8VqsvlGJER+cJq+fkPacjEBjNe7+8QmIPIBY4gLfyw/cnXhNMt9dHj6dp2kQDb9vwGGI1MOBKKxBARDz7H1xBsjKqwu/N9DnL6iie8wcUbYSfBrtckax12+WIszKqTWHienymLRjIQuxHf048QUQnIeDKwzlmGKgC13KYSM+2hwSP3na+rSOUAEpkiRzNRHTigMRBa6ah/8H9OVWnP5y1KvbAzEAdaPVlxPVxqac+EyXZIP5po5xwPa/bTP7gDxOHs6o5LpmtaQwXMbxOXarLJGhNwZYuxe8xF8v15ZVWRyrA7j71HZqC5NlRUkLQm+CM7b5xS0DoxTLptAmyHkGNQq2Dn5pP8ro1VivN8T1IwCmFZAzRWIUTNMViw+CWy3memb8MAzkoMNHeB/HTcBf/VIKmT773d9lCGS9WRw4iZ4bdEqezFUJmmCilsLJVPEgangWgsHKaSYEnyyR5YQeuOUYb6rV3duQgz8ib4ImrGO3/SOZWOGG4Jcv/6pcpXHvLJSY+zV4SBYf1tAoNHlV2Bs2ToqZhXPj1KD1Te6TxjYqY273n/lbgpcA7GknjtTG9uHenYkGP3a5QOOtGMr+gKufNTnX5ksi5n0PbBNmypPPxT3lCJgJ879wIDuaq5Q2i+ktlsX7x6OzN/zce7ZubCXxtkE7qtc+a4ZZdDNOp/xPPwpAB01vE9rWjs+67veQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12454ef9-e373-46ce-99d7-08dbef89ae84
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 20:44:42.2156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H0Mt8Yms25r7uwWym9S2aop/RPtNsB8iZNaIsGx7AByLsOBR73hPvaexborftWJgfu059Ef2DKpjRRwd/MhflU2WXp3WSspl9ZNREt/BTTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5585
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-27_19,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311270144
X-Proofpoint-ORIG-GUID: ydHWfzcjNfCGs_aaThVDP5x5uS7wnslS
X-Proofpoint-GUID: ydHWfzcjNfCGs_aaThVDP5x5uS7wnslS

On 11/27/23 2:23 PM, Lee Duncan wrote:
> On 11/26/23 16:39, Mike Christie wrote:
>> On 11/26/23 6:01 AM, Hannes Reinecke wrote:
>>> On 11/25/23 19:28, Lee Duncan wrote:
>>>> Hi Martin/list:
>>>>
>>>> I am trying to track down an issue I am seeing when trying to boot using iSCSI root using the fastlinq qedi converged network adapter initiator and an LIO target.
>>>>
>>>> In this configuration, but using a non-LIO (hardware) iSCSI target, everything "just works". But when I switch to using an LIO software target, I get this error when booting:
>>>>
>>>>> 2023-09-20T14:10:32.835358-0500 worker5 kernel: Illegally set Immediate Bit in iSCSI Initiator Scsi Command PDU.
>>>>> ... > 2023-09-20T14:10:32.835422-0500 worker5 kernel: Got unknown iSCSI
>>>> OpCode: 0x52
>>>>
>>>> It looks like the fastlinq adapter is sending a SCSI write (0x12) with the Immediate bit set (0x40).
>>>>
>>>> The code in iscsi_target.c:iscsit_setup_scsi_cmd(): looks like this:
>>>>
>>>>>      if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>>>>>          pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>>>>                  " Scsi Command PDU.\n");
>>>>>          return iscsit_add_reject_cmd(cmd,
>>>>>                           ISCSI_REASON_BOOKMARK_INVALID, buf);
>>>>>      }
>>>>>
>>>>
>>>> But I looked at rfc3720, and it looks like SCSI PDUs can have the Immediate Bit set:
>>>>
>>>>> 10.3.  SCSI Command
>>>>>     The format of the SCSI Command PDU is:
>>>>>     Byte/     0       |       1       |       2       |       3       |
>>>>>        /              |               |               |               |
>>>>>       |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
>>>>>       +---------------+---------------+---------------+---------------+
>>>>>      0|.|I| 0x01      |F|R|W|. .|ATTR | Reserved                      |
>>>>>       +---------------+---------------+---------------+---------------+
>>>>>      4|TotalAHSLength | DataSegmentLength                             |
>>>>>       +---------------+---------------+---------------+---------------+
>>>>>      8| Logical Unit Number (LUN)                                     |
>>>>>       +                                                               +
>>>>>     12|                                                               |
>>>>>       +---------------+---------------+---------------+---------------+
>>>>> ...
>>>>
>>>> Where "I" is the immediate bit.
>>>>
>>>> Frankly, I'm never sure I read the SPEC correctly, so I'm not sure if I'm mistaken here, but it looks like LIO does not allow the Immediate bit (and hence Immediate data), even though the SPEC does allow it. But it also looks like, during negotiation phase, LIO negotiates ImmediateData like any other parameter, allowing "YES".
>>>>
>>>> In our testing, if we set ImmediateData=No in the target, then our problem goes away, i.e. we can now boot from an LIO target. This is because Immediate Data is negotiated off, of course.
>>>>
>>>> Is this a bug, or is this adapter doing something wrong? I would appreciate other viewpoints.
>>>>
>>>> Thank you.
>>>
>>> Sounds like a bug.
>>> Can you check if this helps?
>>>
>>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>>> index b516c2893420..ad68706ad9f7 100644
>>> --- a/drivers/target/iscsi/iscsi_target.c
>>> +++ b/drivers/target/iscsi/iscsi_target.c
>>> @@ -1060,7 +1060,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>>>
>>> ISCSI_REASON_BOOKMARK_INVALID, buf);
>>>          }
>>>
>>> -       if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>>> +       if ((hdr->opcode & ISCSI_OP_IMMEDIATE) &&
>>> +           !conn->sess->sess_ops->ImmediateData) {
>>>                  pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>>                                  " Scsi Command PDU.\n");
>>>                  return iscsit_add_reject_cmd(cmd,
>>>
>>
>>
>> These are different things.
>>
>> Immediate data means you can have data after the header in the PDU.
>>
>> The immediate bit on the header has CmdSN rules which allows you to
>> send commands without having to increment the CmdSN. It's used for
>> things like TMFs because at that time, the window might be closed due
>> to SCSI commands having filled it.
>>
> 
> Mike: it sounds like that implies that setting the immediate bit in the header is actually not allowed for regular SCSI PDUs (like Read, Write), correct?

I didn't mean to say that. I was just giving you a common use, so you
could check it out in the linux iscsi initiator code and spec and better
understand it if you were going to add support for it in the target code.

Scan for "immediate delivery" in the spec for more details but to
answer you question about support it says:

https://datatracker.ietf.org/doc/html/rfc7143

   An iSCSI target MUST be able to handle at least one immediate task
   management command and one immediate non-task-management iSCSI
   command per connection at any time.

For software iscsi in linux, we only set use the bit for TMFs and Nops.
We don't use it for SCSI command PDUs, but from the text above it seems
like its supposed to be supported.
