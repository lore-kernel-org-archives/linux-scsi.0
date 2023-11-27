Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kGpxm8ve";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PoMx55V4"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B72DEA;
	Sun, 26 Nov 2023 16:39:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AQN0nTi015629;
	Mon, 27 Nov 2023 00:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=/SdAXR7oZnFhXKFG862Ej+qFLZpQF9OCviUT46F0q8g=;
 b=kGpxm8ve39Wr8C8pVIbK1IAdC3wc/CRNAHLy1i8JmuBDJuwLG51fghNYA7JpMg6AF3gX
 6DGLPdqkHXZOu9GW6Iw7nstAi0wwevvl8B1i07KPBF70QiEHF0FAyXRMsX9ZYL08DtvA
 sBe0B48iLltCc0IJXbymatcy+s/pJFbP4IVF7LIMDGKf9ZdjiEw0wg3XEvTrs4My+Q2F
 r3WMnV84ZcV0Ob4blYOXTtcYcH8OCmGYqfoidp5udaHPrceWpbMMXJaI1NLW4t0ZbCiT
 7nOMpp75weskJEUi0cvK95JijlL/DbgVKeP06CSs0OxQs/a6ZoVZy5Y222BklZD6Uazu 6w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk7besswm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Nov 2023 00:39:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AQMxZMf026457;
	Mon, 27 Nov 2023 00:39:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c4cah9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Nov 2023 00:39:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYOgrwIMPKnZtvwFTrdVTQtK9m2PMQKKJMZtciHVk9hJhjMEGGvS6VqZfXo+p3uoWRPk3uNLG4hIK+bd4i3PpjOQkzFhTsRqlCnxtrXJlSifeXBguoJS6g3qkBgKM7LnyImPE+CWibXUHxvL6gdt0eqDcWvmQYTyGk2sE2rBcIAcTjiVyqDks7ce+IXv0G8hCl6QyO2aL4piyioyF29geO0/whfJQA7NKgoUq5jh9WMX56ehS6z6od2atRbkW8/V/Rv6FIpNcqE29Kh84+LGu5mr6z7UVMw3aJA+mbGvweP6cNlsj3LsO4/MhpxoR9BRwCY0cRzeeBRTg1KSkngmDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SdAXR7oZnFhXKFG862Ej+qFLZpQF9OCviUT46F0q8g=;
 b=I9A4r+XnQ4jJdqtkQ9Pzcv2W6T73zUclxiqTaFBBVaSAXiPxiYb9Fm/T/m5yvu3lCply++9BjmbepSGQHPfhiTgQVayac7C7wfVFi7dbkG5AfxU0S4o8TDOWhthL3rT1jQaMqU0PtAZlGr9yT2hCZIQ/1YC1HqWUcIu7ZnI++be31SMYjMKLSPAcRPrq93Mshb48hqsbgJqG7lY6MGGgKChidCIPlxt2XHgMBS5IUBgQmS7CeugUTaHi4Pnby4j4KxoifrH/kCc4I93GjOvHbQ7lz4zwRzrW+isCHhQvBLrwp6wLa3miP2x/MPxdSBgvTe/R/gaklS7DHxLBhbt+zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SdAXR7oZnFhXKFG862Ej+qFLZpQF9OCviUT46F0q8g=;
 b=PoMx55V4nDhkgvr/vc/M9XV5jPVS0B5iMMLu2/oqfJxzAldFzQMGa6fzTVS6hleiMreD3kCTbjwui8MKT0h+/A9XtzOf7rVo+ne5GhXHpJAMdPEW93iYxbXRlptT2+ag6neUb1wXBStX6BOeJyvb63/3tPpl1BRq91LTTDGpqkc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB7126.namprd10.prod.outlook.com (2603:10b6:8:dc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.27; Mon, 27 Nov 2023 00:39:49 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 00:39:49 +0000
Message-ID: <5301e42d-7fad-49e1-8ebd-7db569416974@oracle.com>
Date: Sun, 26 Nov 2023 18:39:48 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: Possible Bug? LIO does not support SCSI commands with Immediate
 Bit Set?
To: Hannes Reinecke <hare@suse.de>, Lee Duncan <lduncan@suse.com>,
        target-devel <target-devel@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Chris Leech <cleech@redhat.com>
References: <31851279-0884-48ba-8c4b-7d6147e59508@suse.com>
 <00eb0928-5691-4e85-a923-de9c4934856c@suse.de>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <00eb0928-5691-4e85-a923-de9c4934856c@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:5:14c::43) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: 67af22f2-87e4-44ca-6851-08dbeee15cfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pYx0lYjZrWXKKnzkZgniu/+SdtUaTPPdUZgHpCYqf1PEdBdelgnQX9nqovbTJ9c8FGaOEPdIYz/vfYRCOm8O7cjXCu2VEnhgNejiPVQCDinR2GWT0uQUXd4EV/G5sXjmkVHY0TOUKt1v4BzhU7Qm8wacmT+KBKED4RBMATLWtg4+QbFV25Si2Fy6qZtGyZ0t0zdhVhjxROkz5FRgPBiiYd8GYnHVuHIp80/Xr6HQTl/9t5LbhCfRMH8KLeCelUheRG/b0WPsHZd6NLe6GCfGfqLBNDZ8LjXg3IDuIklc/Zz/Gx4WpYCxHmTbrIw65vWVltEOgaL62yI6SGs02g4kJKlVgli4Nidw7bvtKiTdfg/UNmaXgogB8E+1APWGjZIVWzrOXglIZe2a62Tzisj8PI45O/9668rQ8aobcXsxyInz2PZCeoG9iDyc59C67ebpnnxpjmy562MLQNgbw9exqSiLEl6S41gF19r8WeSezsm80neC0TR2B3eg9wxE3K5dki3VNW22Emrkci6310giicQbkFbq/tdhmpCHkLLuIqGKyfEPYbLF9FFbTUloOHbJihBdhoh6cpRoJb5s+6xtdP3LUoZE+sYAea+2gaWRAzuiH9x+3ByXe2lByYEZ9MxOo+opaRXWQCwvRWq960ZP9T0tL4Q9DS8paE9CMcooZwI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(31686004)(26005)(83380400001)(53546011)(6512007)(6506007)(2616005)(41300700001)(14773004)(38100700002)(31696002)(86362001)(36756003)(8936002)(4326008)(6486002)(2906002)(5660300002)(316002)(8676002)(478600001)(66556008)(54906003)(110136005)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aHErTTNUOWUyMlZ5eUhZWWFkdU43TWo1OHFyakFRYUMxUzR2aGx1d2RkY1VN?=
 =?utf-8?B?SEZmR3hjbnNveEdkS09mUXJ5cElMMmZ2WmlONmhYYW1qM2xXUDRtN0xCS21I?=
 =?utf-8?B?ZHpKSC9zSVNqRllSRnZuTEpNYkRtQUJTU3BYVHl0VWpDenFPSnlFMmFQVHRX?=
 =?utf-8?B?aWNaNGtJWUFPMG0rRDNrMEdhdUtSSnorcXhFTWt1d0R1QTJLZktFU0dJMEZt?=
 =?utf-8?B?RC9DTmwyejRUdlJ5QVFGNy9vdHJaR0dta1llclh5WVRZTWd1bVBvT3N0VCty?=
 =?utf-8?B?ZVNrWEQ5dmFUbkw1bUNUTENtVEJKdE5vRGtzQUJiVW1BZkZUdjlQWjYxQzNi?=
 =?utf-8?B?N3BKRmpEamRzZU1PbFlhQkFaTFdYeTM1VjhiQ0U3dktrWGV1Q0NwdUxOMGZB?=
 =?utf-8?B?ZHZJRjhvWVdQTVJvSEdYVVlneG0wUjFaM05PS2tRZzFPU1I0SDdwdnBSNlF3?=
 =?utf-8?B?RTRpR2ZWbFNVdEFmRzh1UVIrNWJrWGRUNVkwMHlRUlZIMWlDV3dBckZKZVpC?=
 =?utf-8?B?RnIvUlcwVEllc0I5aVV1alFIV1ovdThrZm1rTHJ2VG9ER2NLUnZTWEIyWlcv?=
 =?utf-8?B?OHdQbGlYUXo5OHd2RkFpUUdLWnJJc0gvUXY1REQyUGcwcndkSm10YlR2b0ZC?=
 =?utf-8?B?c1RRZEIrSk8xaFJPbytsQTU2c1h6cGtLMnlCWEhDc3cxSHZFcVMrb3B2U3dM?=
 =?utf-8?B?dnNDR05IS3NTOTdrSFVJSG5FMDE2NExKRzNmNnVLOUVsbWJmTXlTdzBCRmdP?=
 =?utf-8?B?b1MyMUdRNXVWcGRLMXJnaDl0WGdHOFM4R0ZWZ1J4R0pRYTN2Sm5JZmdUTmtU?=
 =?utf-8?B?ZFZGZUFCWi9NeWlMM2JIeU40VHA5a1ZaWm00U0FBcW9MYjhyOGpZYWdSMWhs?=
 =?utf-8?B?dytEd0pGc0E4aVQ0N29URVdLWC9SYzd5V1pzWG1tRjFUL2xGWmVJK29yR2ZI?=
 =?utf-8?B?WUYxYndPZ2lNaUxkVFd6ZnE5MXNpbFVxeTZsYVB3S0MxY3RYUU9yZ2dIRXcv?=
 =?utf-8?B?UFIyRHRHa01RNE1TUWdHUkxvMkxZRE9Hd1ZWZ0d5alhIczFuZWRKSUk1bjNP?=
 =?utf-8?B?QWp2ZWVPbzZzYmg2bVU2bnJGWEdqQXRjTVZWSXNhQmZCM1lSOVBOWUVHczZx?=
 =?utf-8?B?SGZKUFN0LzRYK1hBVFduWVRzcmNxSUZmbisvdERJcmF3MS9vMlk2Y3ZTRDEv?=
 =?utf-8?B?OVJDdDV5ajRVYjM0UjZxUldoY3hqZGp6NmJSM0xZSnBEMUpYQThRdUZkUU1o?=
 =?utf-8?B?VDdoM1VReWtCZkZTdDlDUGVqanNYUDNkaUpKOVUyb290T1pPcXRzbUpKbHFJ?=
 =?utf-8?B?SXp6aXl6b2M2TDdla1JURFA2SWcrRDFVU2VPd1NWSHNqSWxNN0R4WkJ0czBV?=
 =?utf-8?B?eS9hT0xjQmZSR0RCZThpd0FMUEVwTkVVSkhGRXJLUk1SN041R0FaalIrSTNN?=
 =?utf-8?B?TzhvcDlkMUo4c242Y3NPdzVtRUMyWmtrWktvR01FQWt0MUdHZU13Y2tyWFAr?=
 =?utf-8?B?em1NUXkrRGM3bjhHRy9ZU2FUTllBcnE3ZEFybjlRTkdPZXhEa0VVMC84b1R4?=
 =?utf-8?B?STVqTTdjSXJVOVI2RVJwdUcwaHBMZFZrZkhEVFlZbWlBdkowVEZjVjQ0QlNv?=
 =?utf-8?B?TTI2RkI5aTRvY1cvOTQrQjU2UUJKeGEzc09QODVVZ0NGUTRJeldsVnBOZy9o?=
 =?utf-8?B?eUFJNnIzZmkxcnE5V2RFQkN6VHVUd1RQdG9mUXMzblBWeUx6TEtIcFQrbXBQ?=
 =?utf-8?B?cVNrQWRtRms4QUZiWmlDeW1TMHNXU3V1aUI3L3FkbHMrR2JrcmlBL3p6L1VV?=
 =?utf-8?B?RmVCakw4QkNDYUVKTjlFODlkNmYvb2t4dHFtNXlJeU5KZUpyRTZsVWFWeXBn?=
 =?utf-8?B?MFkvdlVyalhNeWJpL3VPRUJvQ3pHTWNYYnBPbDJIMDBYWXBWTmlyUWUyZDNw?=
 =?utf-8?B?aWYvZUk1Z0QxNllVOE0rRkpMTmg2TVhiMVFoV1VIcUY4OU1xWENVWkZGZ3B4?=
 =?utf-8?B?UUxIQzExSXlTWGVWVlZFemNwWlJjbDdDNWVKM3Rwbi9qWDBjdzZLWGppakZQ?=
 =?utf-8?B?VVlkWGdoQkYyQ2x5Wng2MGY0MncxMS84eU1SVDM0TWNWZDVtZUQzS1BKV09x?=
 =?utf-8?B?RUpGbVdUQjF2VFQrdDlzY1lJM2oyYXJlZjY3clQwc1RRQTR2eHRBemR2bTFL?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Ty/HhFR/K2W2yr7bsoxxFKOzzWesI/I2Wv9IoIWuXFE3WZv3Y42AiGX3HDyPx/aBQuavt12+UCctYbhD1mkNeNSavrlbGTIdcB3TTRKN74MA9pEk+2adOm8wl0aboTdfVH0/UHQNOWXClO6/yQOXnZVRwCVrcNl8qHqle3/m7aWhlWah9KxVXu0XsEzgJL1ryxV2hX9vY2jkHgAq+Rr+t2q4K4JmSF24DaFUz0yc/Rtz4U81TK+qS4IAGf/EAPLAMz7xguXv2SjafM3bZ/fyaYBtpmylZQPIo+n4auz5iCir/Jhlg4+V+IWpoT5hUL4dvXU9lmjoq2ONlnkkZNEZVf74j7WSjD5whixRiVpom7zVuxDP5uT+YVlaDtpbdOtJMw6wnbzm7tUcSRT7CjiEvy2oDpf3zqYegcBQkIN4zagbMHl8ICRxqM6AiKTWI2U+zu2BmwDC+YQFANLOqSRUF132j8XkT4Sccmraj9is6io1XHeZbXDtFNkzNHhhtX/mXi9Mk7BBIgKEhOBqRbt1N0Ik8ESdlU5pEG0fGU8pWcKviy4t84+2jIGVFP0FzYU01RSYalbzc4wsa/td4P0pbIPDCC4STHjl6hUxOrdoqjnzLb3/KhFtyhcfQ5TjkZquB+zU2DoIsPIbvSugomhNcxB8jAGSt9I1/LkJMuA81D2rJtihkNi1s+bdudyBjN4Mv1x+Or2uc8tBeqYXxCC1DR64hBPy7OFQUMV5lPgm2ddIAbaluE0ZvAWnc36JoqGl6jJGDeLMZbkCdicvx5oB4pk4N/zhtacahVpFODAIZPgQKQf4TDfqIBrbrAVo/421LblPkwVaAD1/gqMpu7G45Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67af22f2-87e4-44ca-6851-08dbeee15cfb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 00:39:49.9471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOFrbn4qInOiVfSuNTYstfukFH3UthOFXkQ8YAT59hQzo3eSdvtLXXG7Sc0ZZkAp5YE53U5xEBMFwTAjAeCJhy09T6iweznK+uyb3b1P/zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-26_25,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311270003
X-Proofpoint-ORIG-GUID: KpRSVVePZhhsNMTFJ82A1fRBcVfQxpp7
X-Proofpoint-GUID: KpRSVVePZhhsNMTFJ82A1fRBcVfQxpp7

On 11/26/23 6:01 AM, Hannes Reinecke wrote:
> On 11/25/23 19:28, Lee Duncan wrote:
>> Hi Martin/list:
>>
>> I am trying to track down an issue I am seeing when trying to boot using iSCSI root using the fastlinq qedi converged network adapter initiator and an LIO target.
>>
>> In this configuration, but using a non-LIO (hardware) iSCSI target, everything "just works". But when I switch to using an LIO software target, I get this error when booting:
>>
>>> 2023-09-20T14:10:32.835358-0500 worker5 kernel: Illegally set Immediate Bit in iSCSI Initiator Scsi Command PDU.
>>> ... > 2023-09-20T14:10:32.835422-0500 worker5 kernel: Got unknown iSCSI 
>> OpCode: 0x52
>>
>> It looks like the fastlinq adapter is sending a SCSI write (0x12) with the Immediate bit set (0x40).
>>
>> The code in iscsi_target.c:iscsit_setup_scsi_cmd(): looks like this:
>>
>>>     if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>>>         pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>>                 " Scsi Command PDU.\n");
>>>         return iscsit_add_reject_cmd(cmd,
>>>                          ISCSI_REASON_BOOKMARK_INVALID, buf);
>>>     }
>>>
>>
>> But I looked at rfc3720, and it looks like SCSI PDUs can have the Immediate Bit set:
>>
>>> 10.3.  SCSI Command
>>>    The format of the SCSI Command PDU is:
>>>    Byte/     0       |       1       |       2       |       3       |
>>>       /              |               |               |               |
>>>      |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
>>>      +---------------+---------------+---------------+---------------+
>>>     0|.|I| 0x01      |F|R|W|. .|ATTR | Reserved                      |
>>>      +---------------+---------------+---------------+---------------+
>>>     4|TotalAHSLength | DataSegmentLength                             |
>>>      +---------------+---------------+---------------+---------------+
>>>     8| Logical Unit Number (LUN)                                     |
>>>      +                                                               +
>>>    12|                                                               |
>>>      +---------------+---------------+---------------+---------------+
>>> ...
>>
>> Where "I" is the immediate bit.
>>
>> Frankly, I'm never sure I read the SPEC correctly, so I'm not sure if I'm mistaken here, but it looks like LIO does not allow the Immediate bit (and hence Immediate data), even though the SPEC does allow it. But it also looks like, during negotiation phase, LIO negotiates ImmediateData like any other parameter, allowing "YES".
>>
>> In our testing, if we set ImmediateData=No in the target, then our problem goes away, i.e. we can now boot from an LIO target. This is because Immediate Data is negotiated off, of course.
>>
>> Is this a bug, or is this adapter doing something wrong? I would appreciate other viewpoints.
>>
>> Thank you.
> 
> Sounds like a bug.
> Can you check if this helps?
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index b516c2893420..ad68706ad9f7 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1060,7 +1060,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
> 
> ISCSI_REASON_BOOKMARK_INVALID, buf);
>         }
> 
> -       if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
> +       if ((hdr->opcode & ISCSI_OP_IMMEDIATE) &&
> +           !conn->sess->sess_ops->ImmediateData) {
>                 pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>                                 " Scsi Command PDU.\n");
>                 return iscsit_add_reject_cmd(cmd,
> 


These are different things.

Immediate data means you can have data after the header in the PDU.

The immediate bit on the header has CmdSN rules which allows you to
send commands without having to increment the CmdSN. It's used for
things like TMFs because at that time, the window might be closed due
to SCSI commands having filled it.

