Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35294F8B9;
	Thu, 11 Jan 2024 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aGgZ8WhP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rY9Bre6n"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BGEoa0007368;
	Thu, 11 Jan 2024 16:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=SM/L85r6x9V0wBLi3WLCcOqzP801iUojbimO8R8CYsU=;
 b=aGgZ8WhPxdA46siKxZfPz5jO6Mv6L0m/lqZs7HQmvNUMT+qLDzFa0CNB5nwuraJBOVy4
 mJ7sP8ecV0uW7hxwDWXCjEZBhI0ZgtqWH1eU57UEgoGaO3VgW3R1GMRSysVw4kKx9S9d
 Vm+MUG/CMBwQK/PuNFDXmoBpqkJyeF3tqIz8v+VOXemFh4W+i8qoOrOFU84ups81vDgv
 e4eMn1ICHdnQ2Mjczdci0O/7jy3SiXo24L0RbUSpNOnCIxeYa7bQ3H+rw6B2uc9OhLdJ
 3e37VyY9KRIqc0p3yCMT9BRH5X5jVtfpAhFzgBFh5rGkDuGmX5alrP4wzMJ3wkxc8U/1 tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vjcnv0yms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jan 2024 16:34:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40BGLSfW030079;
	Thu, 11 Jan 2024 16:34:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vfutqcycf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jan 2024 16:34:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aA5Ho6jURxI4wF4agVbOTBfCY9S2n/ZZOE4LwOx1aNoFmmzlD55fGMVtpSh1KkzIwXiWItTJ9BIqaQwocbLfCypIE1+jbr+9aO9ExJ9msnRmR2tmYWu4Eny/+VTm7feH0Uj6GGMRScAX+ksjr4TNI1FdbxeixcQuBlz3PUeKeBTPYKmtVEyurSGCcpqnGwjyT1M6Y5QE/17PGZQ/GnqvEje2xEBCz/+R4S0/SjZ7ludsl/wVZaEowKcttLs7R21LH/8nDMW2tB4TZfiL3vG6wEqQvPj/CEAOd7zaBA3q6pZri2RA5sf+KcykpkToolp+1wt/uhVby9+qv9ydGm5sFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SM/L85r6x9V0wBLi3WLCcOqzP801iUojbimO8R8CYsU=;
 b=dY8IaVjxG+aULnpkI7pzL8VQof6VjBedcNIo0LsEUHX6+uFeeXJdyDkqJqD2wy4/TpiD15s9E8vtbX/J1aM8ZSyeJka1zrQA7aS6P4iyG/zUfR4szh9SdhCiH2s+TMYplUc64KMw4lhA2D71nnbSK6znAR0a6uKX4oNPvNdA7eVcZXAGX3khGPQOIUx5yIX5Gt47S0hhr9FsrABbLsEmL8KS/0mIS3C0ExjrLgfz/V/u2EYZS7c37UJXf7PVqvrPzAR5UcY/xXVoTUTcpF8H3TdcObMS9oU4vz9inUyNoDNSynBUcS71WAQPX9mjnxBoqDwN35bCnFJaw1coYfAeEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SM/L85r6x9V0wBLi3WLCcOqzP801iUojbimO8R8CYsU=;
 b=rY9Bre6n1Crgvkdsl0Xjwspi2zj6nROkZLkfpz6JPa+il0ZqZJLuC9/oUVU+HNGqtu7h+mLBHLbkNswv+pyWQasnArxLiY++D5OoPD8F39D6tbMIPkINLkH5MiQnzMoso8qqb9UU2m+7fn92mu0+FXpuIKb+/nsxRFHHVTQeoMA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB6499.namprd10.prod.outlook.com (2603:10b6:806:2a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.21; Thu, 11 Jan
 2024 16:34:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7159.020; Thu, 11 Jan 2024
 16:34:24 +0000
Message-ID: <2b284b18-6546-4ddc-a140-2c1cbb5656bd@oracle.com>
Date: Thu, 11 Jan 2024 10:34:22 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: add TMF to tmr_list at the handling
Content-Language: en-US
To: Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com
References: <20240111125941.8688-1-d.bogdanov@yadro.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240111125941.8688-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:610:76::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB6499:EE_
X-MS-Office365-Filtering-Correlation-Id: c18f3779-5715-412a-e406-08dc12c32c10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xXMCYhq1FrnneasdjWAK0BQ542iajWzC5n2nXh00mwEkxoYyOlwndm02ZZSSaMo1FY59ZBZtceLul1gW8VqIF8kSrdYb7adcqG6GR1HgpCP6xr51EoFblolKrpwfEAQlJocSfWTxbzarPQkFO5CUDVDcVm0W96rEfARw2SWA6op5mpzUP/wVY7qG7oD+nIrfxFOlXj0Z0HMpSsGa5NBg3esFn+0uO2H3T7PrbShaqOtl8p5q1IubPLehpSHOYpBNR/EgTlroqjgauzWXpQ+0+or6tnjoSBj/n2/HkSwADXZyAUdHeV2l5oaMeBon6Oy8/U0j2NLU7pySiILLLWkDcevkF93InA3b6tmH7vq6ZilVWLKsXzUhqkd/Q1wOfbuv0efp3n7AVz2R3ZkNGHcqK0PFYSMUeB2VvBiAzvuaVZWcEw/QwWEaKGQKyXqLNHZ1AFn20dNStMi2mc5SU2vS/cCbFCzLyhohyXX/+zKPQ/OSEWzSv8z7gvy6VrKxgmtvJa0oskMfJGdz4dKSM5mwfrYUHzH9mGEs1deLxoXu6ExrySipNZ5yUYwrQf35OWcOL+PPigysRvoDzrD59yjJVAsh0GshwJ9kA+DvZaOZl6PKbh3jczxsweF9Ssqn1zfufsGvCZ/SpGWPKTv9bMnVEg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(39860400002)(396003)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(26005)(53546011)(2616005)(6486002)(6512007)(6506007)(38100700002)(478600001)(83380400001)(2906002)(4326008)(66946007)(8676002)(316002)(66556008)(66476007)(110136005)(8936002)(5660300002)(36756003)(31696002)(86362001)(41300700001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?STdlS3VuZHNmcnZoY3NGVm5HUHVqYWx3cmo1ODRkV0k1OGkwd0sza3VLTXMv?=
 =?utf-8?B?N1poQ3NJblluR0pGSzE0K203bDhuRzVnM0VML0k5a1hLK2RDWTJ2MloxVFdV?=
 =?utf-8?B?dkNYaElUdU1zdHkwUTFOV3JoUU1waTd3UXExaEI3YTRKZ3I5cjZjdVBWU2Z0?=
 =?utf-8?B?bTRDZ2xKSjFUVXM5aSs1OHY5TldmRjRXclUwSk5vR0xXdVd4MGZEbXpEZlhl?=
 =?utf-8?B?cS9FV2x6SjJOM21MeDFpeisvdTJxbjRrMTEyNXBrUXFBVVNoZDNzcklaWXFz?=
 =?utf-8?B?RWc5RzVTMERUcEdHODFlbEl3NWlsRHl3VnlXVlpoN2YvZytqNjU5T2lVUSts?=
 =?utf-8?B?L2ZHRTR1dzdsNC9DazBHaTErekFmNXljckhGU1hMNHJPNEFIajhRbFZjV3ZC?=
 =?utf-8?B?UjRVYUZYV2tiY1VjU0xIMkZlUXlhRWlTNk85MlpKTmI0dUV1V1VTb2dVbHZ1?=
 =?utf-8?B?U2pkK3NWYktPR3N6WG9SRFdqVWhmU3hUM2ovM0QybVBSVUZnaHJQM3h1MjRv?=
 =?utf-8?B?L1I4Vzk2QS80S09JcDVsUEpkRDJCMkp2WUQ3dTZSc0diTkJUeitTZStMN2JP?=
 =?utf-8?B?amVvY28yanlvYjVIUC9Ya2F6RkpOdTNlL2RDaTF3OGczaEZlSlJkaUtCLzJV?=
 =?utf-8?B?eDRiWXNEMkF6dHE5M1hNbzMzTFMvVUp5MHNjR2YrNER2OW4ybDRPdkRkLzUz?=
 =?utf-8?B?S2oxTVdsTTlJRThrTStZSUhTVkZlcldQdUJ0eTIrVVlhQ0l4THpjSzd1RUpY?=
 =?utf-8?B?VVNTUlNOcmt0S1VoZDAydkJNQS9VR3ZWSTZzTE81VEIxZDdFTW9tREpTcSth?=
 =?utf-8?B?REI3TnNOcWZPNWwxUCszNHI4TzZCM1RWeUNrSFF6ZDMwNmlMQ1JRN1FhbkJl?=
 =?utf-8?B?ZmZMRUMvOGRaVkZrVVZWZzBmWm9tdkQxdEdzL1dYWG9HaEdHWFc5NTRuMTVq?=
 =?utf-8?B?dGhUUmk2NFliL2FZaHVlcjc2WllJSHpCSjVFOEhyY1hPLy9VQWN3a0o5UnE3?=
 =?utf-8?B?SlFQdjZiaS8wNCtVMU9LTlo2V3RsLyszZnhqNjMyWlc1SndtS3NuRGpnYy8z?=
 =?utf-8?B?WFhvM3FhNDdiQlc3OThJazFRb0MrblBOcEZWQUNtNXN5RkhzcmZLbVcyeFFr?=
 =?utf-8?B?cWZOTTA0ZWZuQXJpd3NlZHBOckt3Y3o1eXZtTDhwQjdwTDBUQ2o5MW5ocWFK?=
 =?utf-8?B?WFR0TFFyS2tSVHdZMEJyNmpoeC81U2dtYnpObUpsV0xEQ04yTEMzRENBZHhu?=
 =?utf-8?B?UExhWmNLUFg2WlJtREFTRFpDTG1MWG12OXpuN2wwZnNsdFVxQW5xUU9nMVhO?=
 =?utf-8?B?UG1iZEpRay92b1ZudUdFTFkxdWVCQmJwM3JXSTUvTTI1UlFGeFRlaUVLUDR6?=
 =?utf-8?B?Lzlxc0RCL3QvUnNyUmgycWxOSWZQS0xIUWo0R1lBd0xpRERQdnYyY3gzZE1w?=
 =?utf-8?B?R1d2RE0ya3NxNlRkYzZLa1pLMFR5TnozNHZROFd2M0VDSk1BalNZQ1VoRDFw?=
 =?utf-8?B?cWtMVFFZWVJPaFhKRTdLVlhXUUZVTHp6YTI0bzIvTWlTbWJJcDcvM0svVHo1?=
 =?utf-8?B?U3NqSVR6cjNUU29PU1B2Vk9EbXlWRDdNZlBUSGZWbzdRcXArTmNESFByTHpl?=
 =?utf-8?B?Y3hja1RmU0Q5eVNuL0RvejI0cVMrT0Y2cUk2TnhtcXRtSC92dWMxMmRVM1FX?=
 =?utf-8?B?Z0NsOS8waGdobW1HdG9iZ0hsVFpuMjFzN2oxdTk1aEQybFphTWMrcU1mOGdN?=
 =?utf-8?B?V3puYmdCWXpuQ3Zvbmw0cldJNmdYR2tLaUJsQzhQNjVTL2x1YUk0VXM5WC82?=
 =?utf-8?B?bkpET0h5TUVQOUZ1ZWxUSHdOQVEyV3UxZStXeGJNeFJiZW1RQXNHY013ODhz?=
 =?utf-8?B?L0o5c1h6ak5KYUZXSldhUkhROC9tUldLQjlVaG9vMTRNOXVvTXRFckYzck9a?=
 =?utf-8?B?NXpDN2EvN1dOK0dOQUZnYkcrMFFreHdzeXI1NEw5RkNOZFZaVG1nbk1iUHJh?=
 =?utf-8?B?N0N3VVpKc2Fob2tuTERpQTk0R1hUdHVvSnpuUmp6elp5Nm9OSE9zR2NHaitY?=
 =?utf-8?B?L3FSOUl0aTdnR0VLMUhqNm1Ba1FBdzM2TzVDcTZtQUwvbGFUQ3VLVDVzY0JG?=
 =?utf-8?B?Y2ZpT0YxbnVNSkFjSjhKSzFmNHZCd2hBbEYzenFXVjlUb0ZhYnl5MzJuWWhD?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ILyDlLWNoasd6q337Mklbxhpze18l0FlVAN7IQbbhdvl2KATOBfCml5abPIteUBzMACWO9p7AGoBHfYqUlnHuMG5o7kSZ1/vMd9lfjPHF3B4iTaHXH93/pO9z14dJuQFVfHQy7q36PduA/vBACZRSw5Q3uYyesEUCadBbi6rwkCrPqbNk+hTHntdhUzOqK8p0i+hJgZiG17p2hI3V3Xs+PQFgLHkxkQivhD24NkUTzpwoQoPvTnoUVgTaA6QA1oWbTEoRc886tpdFFeSIO9jp2ISDFXQDXeq3+obvkXlMDrPT/v8/rKPKg41rJgoaWQUqkf83FR1uDW0MXwLDojcQ46sEBIW2oWoS310qPjKS5gnIRIN8dUj8yE8IFOKwYXhkRTW4Lc4bqBy/eYkVBdURGwrI5nkHgjqP0N8tF2EDo+IeUCJnmY1kPkRFi1/ft1flcQNwGQzJpMvvsWJBTKxK0Qn0cocWIR/2PN++iL+7FeOEFdQ5kDru/XvkrAhgRb7WDCw0wjOuS8i7T3AbMnu8wSOEMGAmTawmlV749j6TRpXqQhKA71WjoOX1rdfcvOdrWoNxKEOyp5T2RMjy8OUn20g0tmvxyBnQoS6kfHOXMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c18f3779-5715-412a-e406-08dc12c32c10
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 16:34:24.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6Zs2K6MB3686NBHU0mUBNVxX+BOwN5q7U7DVSAM5vdhk4kDJMKq14tXQPr2Iv5TxwM3YIZUUwjiCoB7OgjqABDZziumZqk4fqEOEQaAGr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6499
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_09,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401110130
X-Proofpoint-GUID: FVpKn5fuoDyyVmDo2wQ-ReOZ9utDxE2U
X-Proofpoint-ORIG-GUID: FVpKn5fuoDyyVmDo2wQ-ReOZ9utDxE2U

On 1/11/24 6:59 AM, Dmitry Bogdanov wrote:
> iSCSI Abort that are responded by iscsi itself is added to tmr_list but
> it does not go to target core. On other side LUN_RESET that goes throught
> tmr_list takes a refcounter of that abort and wait for completion of the abort
> that will be never completed because it was not even started in the target core.
> 
> Such logs shows that situations:
> 
>  Unable to locate ITT: 0x05000000 on CID: 0
>  Unable to locate RefTaskTag: 0x05000000 on CID: 0.
>  wait_for_tasks: Stopping tmf LUN_RESET with tag 0x0 ref_task_tag 0x0 i_state 34 t_state ISTATE_PROCESSING refcnt 2 transport_state active,stop,fabric_stop
>  wait for tasks: tmf LUN_RESET with tag 0x0 ref_task_tag 0x0 i_state 34 t_state ISTATE_PROCESSING refcnt 2 transport_state active,stop,fabric_stop
> ...
>  INFO: task kworker/0:2:49 blocked for more than 491 seconds.
>  task:kworker/0:2     state:D stack:    0 pid:   49 ppid:     2 flags:0x00000800
>  Workqueue: events target_tmr_work [target_core_mod]
> Call Trace:
>  __switch_to+0x2c4/0x470
>  _schedule+0x314/0x1730
>  schedule+0x64/0x130
>  schedule_timeout+0x168/0x430
>  wait_for_completion+0x140/0x270
>  target_put_cmd_and_wait+0x64/0xb0 [target_core_mod]
>  core_tmr_lun_reset+0x30/0xa0 [target_core_mod]
>  target_tmr_work+0xc8/0x1b0 [target_core_mod]
>  process_one_work+0x2d4/0x5d0
>  worker_thread+0x78/0x6c0
> 
> To fix that, add an Abort to tmr_list only if that Abort will be handled by
> target core.
> 
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

