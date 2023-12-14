Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oAvBjFPd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s2kV9Rf3"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A69E0
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 19:07:05 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0UK0s016583;
	Thu, 14 Dec 2023 03:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=w8+/vMiI2rMtgxYqsSPUohqP+QIs5Tw3LqzVCMHn3AY=;
 b=oAvBjFPd12L2rjcoIy3vONrSBJujkAmpDfkHY3IMa1mvyD4Qgu0tpUMgT/r0b5BDcJZ7
 pxmLs7gT8xVR1PPrXnVlDjJ7SO86Jkssmn1WcX80dGFSqvBHFVv6GuYc0ZlWMFAM7AHk
 Fp760IFzfD2W/WJs0j35UeDirQUVcfFCSlclGsIapH73XCtTEpcmdDaIPbpUEsGdvz3c
 QDNm/rjwxverTnD6msXNn4C8eet8i7351AN/SIe/cL+HsLQNnV/iS9IjTh+izVPfez1T
 SKo6BzfMQsuPF/Pk10BPcwfCfs+xQFUjQ4LpYAV/AWTTOiUyPCoi4k6qAI4Ol6qOr2XN UA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwfrrr57g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 03:06:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE36d0M009861;
	Thu, 14 Dec 2023 03:06:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9c0vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 03:06:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kgvp/c9hF4uD5VeT5+zc1mI9Sgiw84bj32lSursb1T8TfQl8FNpF04Mf0o3sX8+m7OfVfuxZ9OiYMwUhuAD3d/H+SS5cqZXoWWAd5Ewg7xiJX6Mx9mJ0idfQgX/12BRw6KxqitZGlVIH+Kc6qGX25eIjL9Cp+IvcTmySSW3CWyAW1SgQoedtrqS+ZaGN10cvx67w+aC6GdgcwBnT5Q2LR1RCKpVs1Ey0fUI5xvWVbRFJ7HP82aIpzn3iUvIz/Bq8Dp4dwuqke0qfY2TobsLBjVY58gcPPml4JHY/mAb96pneDU29ozfOyXuULtdsNOyGA1l2okjiDp6EZXmMvr+xVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8+/vMiI2rMtgxYqsSPUohqP+QIs5Tw3LqzVCMHn3AY=;
 b=DreQP1/Tzs71uFn6Bh/o9fVtWzdkCOiAB6tm8nim4ZC9PWuUJQmGNYVNhwHJY9blqX1/MzsDjhRvnSCR36F9X7Q7HrZ5x1beJazYowtDDHY4DYAKRlZEqpRX6yyfLZIstH+oCVCJoUAShQf6fQYs87pB+tKqA9/SBY8LId/x7k2cO4OBg3rhBp5ZF6fBlfQ0peLaZzLL3yN2WCCaxIIVb/rqXfhNC+GnqfKFI1NrFpxducL1oBvEMgGP3yJ9tk5y9m5illsvjL3rduy95IHm3kHQYIYSeZzCujnogG8NU783nedtgSteOS1se4XZZvjHth/FtUrfz6w16ZqXzgTzqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8+/vMiI2rMtgxYqsSPUohqP+QIs5Tw3LqzVCMHn3AY=;
 b=s2kV9Rf3nFMw/qEZ/K//gCikN/FbGpgrqvIyvQ5EYOoKUtZfTIubBvVxIY6e/miRMuIIk24mniWgrcZVMGydB9Tgs2S08LfBk8ZVRe3xauEpN37QyMvD9sY26jo9f4sC30ejGPRz2LeLAWwu5Tir67fpC+iVihEcHY4qQK9JqBU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4287.namprd10.prod.outlook.com (2603:10b6:208:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 03:06:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 03:06:48 +0000
To: "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc: <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/5] scsi: hisi_sas: Minor fixes and cleanups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jglij1l.fsf@ca-mkp.ca.oracle.com>
References: <1699932486-206596-1-git-send-email-chenxiang66@hisilicon.com>
	<c45761ab-beba-ec17-ddd9-005678a3abf5@hisilicon.com>
Date: Wed, 13 Dec 2023 22:06:46 -0500
In-Reply-To: <c45761ab-beba-ec17-ddd9-005678a3abf5@hisilicon.com> (chenxiang's
	message of "Tue, 12 Dec 2023 09:14:22 +0800")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: cd4fd394-8a2f-4382-0990-08dbfc51b60e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Pfbp/lrZhB2BRIvB3K1AuelFYMvQSM8L//sgG6aDJgDq+OF+hku3nhZAri6ETE9eOzIlFpro1eqjnit6ruMiE+1MnucecaMhmxrf9ipTfAEA1XIc0DE0UK2Gpoip/cMpjj6bAJ3SuXZDh/LcDkyNe1YhTTIbpnyFg6tfYRnze1B0FfZSXeW1JYqRnJmDBTpbqKEXMwz65mJ9CY+bGHPhtq9dwpSO3VWErkl6prkI57kYw2x4PEn0ww2Mrrx+lPBhMgDfMgjEUMqGPjqyHGUn5IuIw3MP9nOdw2/4UXd/M/9LCq9CT1piXQpy5TKzT7svFzjtyQVOng3CFvphyk3L8JGT98YmYujVb0TjJgfLp4+D+W4OX7DyzCbpTTeMZcLBdEiTow24gZ9xm3tBFpHQ4X6BRLovZXZ1b95nrrad+3PMRfV35WxFhi3H7o96ak0xpibwnTz7TmNq0U/3V0KW+4932EJdhVaZNI2zS12SteX00EcC0Kshd5BNUu6QdZVtuTeAIPTKp0Cqd5C3KVrJ8ZlJEp9xMqBByw3oR1ZIwfKEMsoKJE1rpehWvPBV3RLo
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(136003)(346002)(376002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(5660300002)(26005)(4744005)(2906002)(6486002)(478600001)(316002)(6916009)(54906003)(41300700001)(66476007)(66556008)(66946007)(4326008)(36916002)(8676002)(8936002)(6506007)(6512007)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RWNqWTlJU083a3pFeXd5RzNuSHNERTZHQlpJZGhhSVNiSm5SNHc3Ymg1NjlH?=
 =?utf-8?B?dkd4MjExcFhIc2t5NXVKaGhvZ2JhL2FtMFB6blNtcEVpMGNmUmpZRlIzUDJG?=
 =?utf-8?B?N3VNcjh1R0RmWEVZMVF2TzgzQm9Gcm9tTEtMeWJoeG1PY0ZiSFUwSXRCZTN5?=
 =?utf-8?B?NUhpZWdTNEZSOVJJT2JFMXVzZGdXOWExRWdQRU50VTlIUWRmbW9WRzlER0dj?=
 =?utf-8?B?dEZNazUwelUybThPYk1YWkhucU53L1graG1VajFHYll6RVBWUVpxazlheGw5?=
 =?utf-8?B?eVBOZVVYeExiUHVoVWRrR2ZpVXl5OUVIOVkrRCtJaFRwblRDREJmQS9OeU82?=
 =?utf-8?B?WHRtdFpPQjRJMms0WHdQczR5Uk04RStyelc1NnpRQWtTczNNZ25PUVhGOENY?=
 =?utf-8?B?UWhIUzdlUVpSS2JwcitLQzlLSjJrZUxtN3JFaTJyaWMyRzhFS0I5M1BiZnlX?=
 =?utf-8?B?aU9YQndQZHFzaEs3Y244cFNwbnRZTFppQ3c4QkZXNW1qQ0hTYnM0b0FXeU9H?=
 =?utf-8?B?RmRxVElJYVB1amdWZjJWQkk0aDhYNmIydkZ1YVlqY1djRGZpdXp1OXdRc1VR?=
 =?utf-8?B?dXF1WkNVQm1LYmRaODFDNzdwdyt5SHZFdjhQVlRQYnFTSVRLRlVabjZQWkF3?=
 =?utf-8?B?ZitsS0NFdjBZMGZaWXNXS1hhOTdPa0M2RnpnZ1RrYkw4bEZKWkhDRHR5L3J2?=
 =?utf-8?B?NmcwTkF4ekdzc1ZWL1VVTUp5UlpHWENxN1dNZGFhT2RjN3U1c051NXdmazlz?=
 =?utf-8?B?VnpsMU1LT1UzQWUxZDVEdFR6dzBhUC9aeEMyK0ZRQ05Ydk9zaC9yUytOdjAy?=
 =?utf-8?B?QlVnYS9qdE1HMTNSOTIxNGswYjRiVG42cTd0emQzY2I5WkZjQ0dreUV0WVVV?=
 =?utf-8?B?ek1TdmIxWi81ZktTOVB2SkdSR0tMZTF5NTd3Qk1GUnorSk94LzQ5b1ZwTWlv?=
 =?utf-8?B?ME84QTN0M3lGK2NZMit4NlhYWlBGeXAxMmZhMjk0TTFoZG5jUlBMd0JiNVJU?=
 =?utf-8?B?MWNZVXVSSC9EZDE4SzJXbFpmYUFKRE9XQnBMNGZkSkhBV1lFbk5OQzNhZXZ5?=
 =?utf-8?B?bis5RVg3bGIrbmlTNDZFbGFEdWgxNDBjZTJpYkZJbDl1QWo1MFIwWUdCNXVK?=
 =?utf-8?B?WjJSMUN3Yk1IS2hBTFlPZThnZVB3eHpGN1JrQjkxY0VlOVJaYkVZOFprTERB?=
 =?utf-8?B?Q2xFckg0MWhNeGNhN3hvOXdqemEwd2QzS2ZVOHBKMDNoend1cWdBNUFUVENa?=
 =?utf-8?B?Y3JHN3Z1R1Y5eTR0OEk4TGQrTDJnaGhnbnErSklsbkZSYk04R1Z3cktBejZB?=
 =?utf-8?B?TDYzMzdBcXNtRW9wSmswaU9wNHJLMjhONWZlbWU5Y3VieFcxV1hLQkUvL01W?=
 =?utf-8?B?ckR3S2FpMDk4aDhkbjlaUzFucEhWMHN4Q3dWY2lRRDA5cVAwQkVTQ2JuVEND?=
 =?utf-8?B?MSt5N0UrekYrMlRiR1FkQWZXL1Arcy9QSmZZVUptN2tjYkVQZW1LcnhSRmRD?=
 =?utf-8?B?V3JRZE9ZRjZRT09NbTFiYmRVdy9kZUZGQTk1TDdsWGZGSjN0TWtDVjhmOUxZ?=
 =?utf-8?B?VHE1UWtSR0JlRVdMaEoxeXVRcW9SRTJkNzlJREFvOGg2eGxTK0h0OXpCSDFR?=
 =?utf-8?B?R3lzanZONC9WWkMvTDlhVnVpanFCMkJmajlzeEM5SVNOT2tBL01BcGpkZ3Rj?=
 =?utf-8?B?eWZrVVJDc3pFY0lBSVY2dWNRQ0UrcUh1dTh3ZldZaWpiUGxpOUdwbkZINHRS?=
 =?utf-8?B?N2o4emJ5aGRMVktpSnhPMnByaFJpNDVhWFJaU2FDWUF2eEdGYWdDN1k1ZFND?=
 =?utf-8?B?V3NoUG9Xa3Z3VCtZVnQrNmw3WTQycDJxQU1NZXBXNVF5d2lWRGhhQkl5b2hB?=
 =?utf-8?B?a2FYMU9UdUtSK1hYcTFUWndPYWxtUVErNGZIR09KK21Fam1jbU90b3FuUEx5?=
 =?utf-8?B?bDliOXdVWHZHTnF0bmhyY2RiNXFlS3NxZEh1YUpyeHdLVnZGMUg2ZjJuZ0Ev?=
 =?utf-8?B?SUhOemY3a0g5ay9FTVU3cis3MnZWNEsvRWZhZnFCbkh6QVoxOHc0dUNxTW5h?=
 =?utf-8?B?RXpEQW13Ujk1M0l0SGs3MWNRdjdreXVLV0hTbmFZdFNYeG83Sy9IVU45TWkr?=
 =?utf-8?B?ODlvV1lMQnN3bjJQeGdsR2t5bHdGZFZmellzMGxhUUpJaGVEc0lTMnVrTU9B?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	OuLM84IGyb8IZwAtWxqytmeytom1rNjJ75UAyYMdc9ij8dsueFKgpgDxZ9xcN953HGPt0PskaAYkyWR1QwSNOmbdEJVkUpMDQ3UDbXQXAO9qH/HwkJR6cszn65bfG9VW1kAqrv4t/cfNDLnt6L+ylgkfqCg7Jqdi3NfB2ZYgyNxsPoKRcJZfuqmFga55OVq5MGojSH9oKUS8Av+OTy74nagjQG7u4ar4c7xNMbtTzHOQ370Nl83bNjCV7rqB9hntyjxDmMkMBX3fk/fb25zJC2AXNrRZTlpdLZSSUIDZYUxqkYRQUYjh2KO7wyF+n+THjyHUvrXfUfWdtvoDymzY5r/fs42ON3AleaqYaFFNqWyNMScEF5qbbqzsB4axzeAT0rtPt5z+gCLfG25KjX1svTIDmJSrg23JMN7lFBgyYRCoWrhW8IxS21sJbEur6jP+QEcmixUzSVCInaiVokOy7pKciJC/d9DrzYkDKVcJczTVIK5rN0HxwdXcKPLytYooo2yX9EDU1UGTMNW5J1mrylgb59CT+UKwbJygGKlVfT+XkP88dabZ8fdONJaUon0CvEyYnYYGEVMXmDAlft0Gwjby22KUbQbjSc924P+MU6c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4fd394-8a2f-4382-0990-08dbfc51b60e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 03:06:48.1602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EcNFp7LvmEd1WsVJqBUMnGe6YiR513H3L3mu4a2OH81nAWrtGvNcpOp2mxqSG5kCKtXbBbEH+hYf/sxDEtpKGOoEcQ+KIn825rRniPDH7rU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_16,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=884 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140017
X-Proofpoint-GUID: dG5TejhvHvoMl6Be42Ca6LLueVbiSFMU
X-Proofpoint-ORIG-GUID: dG5TejhvHvoMl6Be42Ca6LLueVbiSFMU


> Gentle ping...
>
> =E5=9C=A8 2023/11/14 =E6=98=9F=E6=9C=9F=E4=BA=8C 11:28, chenxiang =E5=86=
=99=E9=81=93:
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> This series contain some fixes and cleanups including:
>> - Set .phy_attached before notifying phyup event HISI_PHYEE_PHY_UP_PM;
>> - Use standard error code instead of hardcode;
>> - Check before using pointer variable;
>> - Rollback some operations if FLR failed;
>> - Correct the number of global debugfs registers;

I don't have this submission. Can't see it in neither lore, nor
patchwork. Please resubmit.

--=20
Martin K. Petersen	Oracle Linux Engineering
