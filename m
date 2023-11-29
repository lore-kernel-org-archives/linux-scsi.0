Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H+7RqYC7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mEPxAh8p"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71CDF4;
	Wed, 29 Nov 2023 11:10:46 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATFmfYj031798;
	Wed, 29 Nov 2023 19:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=MVSBi5ZmXJZ0F19/RE7hf7AgBCgIBiwtwjYnsJURYwI=;
 b=H+7RqYC7AmIPHgNZO3Gmy/stb20i1bFwMTkVt74TmrIEE1ylWIagbsA44dSxLFb7u/4L
 3loxB2TWa7q2VG9427+9g0K7o3x13fWqaGBWkYrkp2mo6uJhArKZzdMd1ATd5AEUe1Ep
 2qJhz0eXaDqWo+vaQKCkL2qzZKPYKomvNH5wMFQw0p1dIEyTjLM/2HBim54hGFP3ZE8U
 pApThwRsik0sNy7vibpSqn5Z13W+ZHP8F0X+6v9yKQ4o73oBYbR08/dTTvx+LxJPZwRo
 fYsRgSh4DFhE68rz80E6xOn1uRhXrR15MrHJdnCVRwM2vtHbxl/6rl4T7DW3qtNUAJxx 6A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk8yd9ubs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 19:10:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ATHtlHk026447;
	Wed, 29 Nov 2023 19:10:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c8v5wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 19:10:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHNeaElWBG3HzKjWUkjgdo04vVWtg3PJT9G7ajNJuCbUmqD1XceQN5hR+mY+wKMuA0LhyfrAyH0/Iuotnw8VrZg+yDnpDN05StpVEwaTxjN5GsSf5hRaUyjtkHN/NgwFDi9t/Z8lwapIQGZuYuuQf17KTjRWMEavKM883FA0jCprLfgLAPTKXYoSwPpdsOhX3sTCiLse1/929knaSzB5/m/QbyWIiaRobBh5zZQtbGDx939EOckDoHbUqeZk9Z3nqU+1L+R0lrH5CO0WeZPxPTSSpe+pTn+KIU2cn+c2KCT0KcfOO+a5ZvRyW4jXRJoQOTtqznnSvNgvverNg38gWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVSBi5ZmXJZ0F19/RE7hf7AgBCgIBiwtwjYnsJURYwI=;
 b=bKcv+99YyKXg0ugtuD6ZoAiigNyuUFuuRpShXmoMAG3A9f0tCAEeXWDc+vN2O5+jj9OBuHU98mzfCnRbDRFMF7MSdqry3tpc9JXa2BYzmsyeSWL55kkP3+S+Ut9TJpsqi88ucZsYOp5nkCdWhfTY24g6Te43gbQgCkdqCp8QZ4vhbq4WyTeOuVQhkFmykaMOhooS5NZf033dTfkCTLo4qglWbzG4BPMNd4+Wc+cqcUkY9HSprxuLB01wAqR8ojfS1Ubqcb8I7IO7BammC31oA6bEX6UoEUbRUtpss0ENmoWlID5T1uCopCO7V1UTxkTfn2YizxofG4ddmc47j0oLaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVSBi5ZmXJZ0F19/RE7hf7AgBCgIBiwtwjYnsJURYwI=;
 b=mEPxAh8pujUeZ80baQIcKKg/NCjHXo7TFjOYvC3TuyhdumoBT6ss4ek9hIixH2uI8WTwKwRSSDASE6UlQA50AQUOx+0KkWsYXmFLvRjfocAeSWRCPx7Ol/HVHeLQAeyMTotJKHM38pCEVaKCT+1sTeVdFVI2wfdaZ14bepbi73g=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB6283.namprd10.prod.outlook.com (2603:10b6:510:1a9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Wed, 29 Nov
 2023 19:10:41 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7025.022; Wed, 29 Nov 2023
 19:10:41 +0000
Message-ID: <abf396b7-1bf5-42fa-92b6-3f927f8e7f77@oracle.com>
Date: Wed, 29 Nov 2023 13:10:39 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: enable READ CAPACITY for PR EARO
Content-Language: en-US
To: Benjamin Coddington <bcodding@redhat.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <ad095388dbc550c5b199a1dfa71bcbfc575a7abe.1701272679.git.bcodding@redhat.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <ad095388dbc550c5b199a1dfa71bcbfc575a7abe.1701272679.git.bcodding@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0187.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::12) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ae6554-0fdf-47a1-8034-08dbf10ee11d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/t272JGSEniZIX1qfodq9ABPKW1b6isaZVlcs3kf9p1xe0e0pVHsVauuxP2GuaO5Aiav5ZUux+OGKZUoIe3dgfbG0O3knt5p5Yh8beh7GH0YQsnaRgsKlbGSb5RzLRo+/iBHyEPDnrQtRrpa0UdXs+BQEDFuEk/601J511PpKOkj4X3srk5Wtn9or0X7yG/SlCrYOA9aOpVMAlte3gA6crJLwGlQxkDNPo1hQIB9fkm50S4duH+HK863C+4Yk6215nbPWYc33KwG9SJqzXyNMpD6yihqghxjFcJ42jSWeXVIVb4We8KEe+UWtZS4343fLmi7rTgyGNq7FcxWWLJ9O82XbRC33qk/MXa9jSDc395iesx2fY9sJbHHmohsOB5J0UHLwcv/4LHf0PGE2QB8Vpvp5DqwScskXogFhqCjDsqeWe2sxTbFfs1eIVJ+E9gY9sKMz8CN0JZIqLYL9Ljj4+Qxl8MldyCxAJBoUeEFHsYTv+73WVHb5VHUoOyfJ7znbKx8tLoX9PRLLeZlTmjQj8gatHKA4c7lzbly/0mA9cCL9WYcK9inLLbMwL3EP8MO94N+c0iBBSi7OWo1UKaFUxbSsGJ58/ct7QM2bAEuMngUxXJ+fdYfKFZtYndM63XwKZj1pb+ZRIdKqnyNLyGn6w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(396003)(39860400002)(366004)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(53546011)(6506007)(41300700001)(31696002)(38100700002)(8676002)(4326008)(8936002)(6512007)(36756003)(478600001)(6486002)(4744005)(2906002)(2616005)(86362001)(31686004)(66946007)(316002)(6636002)(5660300002)(66476007)(66556008)(26005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aEJQYy9hYUUzRGhjRngzd2FVdm8zeFZkQVMycTlRZTNxZGdjSW50Y2RxSytQ?=
 =?utf-8?B?eDFaYTlVckZDMUtMVEkzUGJlV3F6a1pYV0g1b3N2K3NWV0JYbDVlRGRiNCs4?=
 =?utf-8?B?NFI1UnlBeGJ5bXB1VEs0MGVBL2RKRHhBSmhpcitmdmpTVDFVM2hYMTNoNDZv?=
 =?utf-8?B?a1QrM3RnNWk2N2svWlkybU85c0pxR1Q5bFVFN2F6OEhoQUdZVlMvVzcxdDBZ?=
 =?utf-8?B?N2VNOHlqZ0JEeHB0QkZPRnhhRHVhWE9qUmY2ZWlTbSs0UWJtclpoeWNnY3Vs?=
 =?utf-8?B?bEh2dERsR29iRGdWeTVWTDhDR1lsbXFkRGpJMDE2cDFVZWFDOGZLVHRjNElP?=
 =?utf-8?B?U2MzS0lqa2VGaUltUWtUNW9OR0J5Mi91SFJmNVcxWlJsaXR5M0xrSEdDSEwz?=
 =?utf-8?B?cmtxQUl3SU9KVUVaYVhFTGo4VFFSZEJUdjU3RFp3eHFGYmplcjJyQWN5K21a?=
 =?utf-8?B?ZVlIYWhXUFF6ODhtZG16b01qbVAybXFobWkxbU0xb2pUdE84UDMwYlBXWmNh?=
 =?utf-8?B?YWNhZFlxbFFsaWpsWVg0ZDBqMkY2dGw1OUFZOEh5TFc4em5icSt4V0VzU3k0?=
 =?utf-8?B?Q2FLZWQ3QVYvckZnRjl1R0lZSXZaTFRhbG1zYVE4UmR0R29KdHptUUh6ektS?=
 =?utf-8?B?QURjbmVya1c2RlFXelowSXJ1eEtoY1hKQ2FIeFdaZjZBZkxrK29BRVVNWW1E?=
 =?utf-8?B?VTd1SzZqa3pQQ2xEalpoZ0lqdDRJVnZjNUJnb0QwSExDTnBMR3BVY04xS0xG?=
 =?utf-8?B?eEV5dENzQ0xHK0VBYXp5cXpIYVQ5VnBQeXVOMjFrdXVWNEsrbzdyR1hrb1Rp?=
 =?utf-8?B?S2d6OXo0anczWWYvS2Z6OUY1VFdySTJhclZKQkdSWTF3V1laSEhCQktiRlhl?=
 =?utf-8?B?THVza01KNytOQThRV0lScG03UCs5anhSMlJqcExiQkdjQUF4UHUrNmhVeWty?=
 =?utf-8?B?ajNQUjFCeUlLTHhocUQyOEpPTFh1MUdZZHBaOFJnbk96Z2I5YmlJenJYS3Yv?=
 =?utf-8?B?ay9ERm5PUDhFL3IyYXVCM0pObjdXcFFnMGlRUStKNVBxKzh3WXNIaEdGZkJo?=
 =?utf-8?B?ZE52N04vVC9CSS9JQnJwRXpYVmR3VzFwSXBVMWFCbUNBTENyWlZZTFpXeWRa?=
 =?utf-8?B?cXZzUDlEWUE0WXBraXlFRVhJRU05OWxGNEZrK0kzZmpRaHRDY2FDcEJoMFBz?=
 =?utf-8?B?azN4SXhHZk9neHR1SDRwZzd5eDE2NWk0RmM1STJibVdWMTh3Z1lENEE5cm84?=
 =?utf-8?B?MXhjUUtNS3RlUHV3K1VHVTRQemxtZXZtdXVKdFluT2VBejhLU0hjbXpSOHVa?=
 =?utf-8?B?ZzBWZUFaS1R0U2UxMGY3ckdFVVB6OTdVeUs3SXgwNDlPbHViWDB6b29FczBt?=
 =?utf-8?B?dE9kSEpCei9MVkJYcFgxNW84cHVvK3VXV0xHNjBNSVhuZ285aXRZZ0JvQjlU?=
 =?utf-8?B?QmU3MlBOS2tiS0d1Z28xaEdZVTBrVmoyQ1FrWURyeGdJNUFqMnptQVVhemFW?=
 =?utf-8?B?Y3ZZSFRLSWlaUGRoTVpQVEdkQ2FYWFJxRU1QNW5KL2dsQlhTbThCTFFrb3Ry?=
 =?utf-8?B?YWxFUldpWEJkR3NQNnNrcFBQMERxZlFqVWU0SndsT3RnRURrWEVpN2NnVDU5?=
 =?utf-8?B?c3NyU3UrdVkvVlB1M0dyMkZ5UnVGUGtkTjlwR3lZM3FkN1dVRitEeStnRHBa?=
 =?utf-8?B?YkpTM1FLeHh0eGJFSGVuVEtnVW9TODVuS1J3M1d1Q2ZsU0t1WUpoODA5cHUx?=
 =?utf-8?B?NGZMeUJXK2E2OU5yTnc1aWhia1l6UXZoRW5xVXZYRmVIdjdLeVRXSlVRbWsv?=
 =?utf-8?B?OFN4Ymg2Tk81SFo1SzNmSml2ZjR4eVpvaWs2SGFVbUVOZ2xvT0UxRkZ0TDJM?=
 =?utf-8?B?SFNaT0tXYThyVERzNmJLbnYxWDJLcmFxeDFpSkVLajlpWlpWMnJsdG1STk5C?=
 =?utf-8?B?MkFtOE5XNVcrZlVMRHdKU280VitEQ3VrVzB5UTZGUitpM1B1ZkoxYXlEMzl1?=
 =?utf-8?B?TUhUb05ETng0NmxlMzA2a25MRUFzNnRxNkRWYWVLOXdZelJQRnJIam9oR2pF?=
 =?utf-8?B?d3lQMTlaVjA4dXR1bFNSaFpkOVh5eHBpYnNDQWtrTkJJOEFlVWplSmJORG1M?=
 =?utf-8?B?NWNwb2tRZzJYdldXVGpQN3JpdHdFYmpkcGpOY29nVGhnRFJSY1lCbXhoSzA5?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BVx5Wd3VKg6w1OzAAmZMhpdVwrKged7saxP9swxr6JTnulkSxU9Ers6dmA+Fz3fW8eiwnC0C/5u8t5zxPhTYXyGil6M4jjmAa6V6vk7W0rb+VTUq3TMKoulvCBYE/CtYEzV7bBGghBalgVzwER+oxHvMAy7aaQmMZY7nE9Mn/48WyGYRbxpCFQbIb6HD+vtzPX81jtUgwcDZ+u33SD7Z9CZOHCpWp6Et1I/3cUZ33R+hj2Pk9eeOfRARiQkA7ehF07w1KVEOyFQqhGLerjsG4jHcyl0jhd1BMmCDyxn+03KRS48NZ2Ssjz1HDY7qRtW67gCa24f10Z5risIZK/gQUTdMZX4Ir1p9fP5NMrzWGhXsqXrVQdR1tb1gWPAsoC7WetPrb9SK0Qf6tu+/vzWl+TVd4Zx6KU5yNcOH6ktHaoIDSBi5kRtRdAMqwtzbp1sLcBuoH0Np1KVs+AMrmMpaR0ze3Km0Fyemtjal+1Fe8HSjz6elf2DNMllwDnMaxOCr7VAV8XpMcwyfBx3hceAYiLFRaNmfwrn0aTOA870EUR9Bt/r8uTlFXI+yn5z5CgF4RTVjjtL83/iUa+X1H4zf0YNU8XbxCkiZc0+kwxCksWApufjRLfXnJIc456C5/pvemDyatdWQ28UbA14rz8NuvtvuIz4s9nw+xGp404piMM6M2MRSR2j4RUryjopM/C7QvFpfSKbhWRUtUGWjv/x3lo7kBX62i/Z61SAzE4iV8xXRenCAQsFTql7LDuVs9RWEwRUeKjEpDTo47zefh2E8BIb3T+Lff3gzh6WIbUlyl9A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ae6554-0fdf-47a1-8034-08dbf10ee11d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 19:10:41.3967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpyTxqn2c4+vAyuncLPLN2jyPc3C/6Blu4aqjiuq8QKJucbwVVWO08JJoJFdhNAg9sT4JaOciMActA4Hz2WJhTXpsB1oOiEwGqZLpmf/Yp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6283
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-29_18,2023-11-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311290146
X-Proofpoint-ORIG-GUID: wSs0yIurPzeU1i0eO6PJwl2vu3ymj74d
X-Proofpoint-GUID: wSs0yIurPzeU1i0eO6PJwl2vu3ymj74d

On 11/29/23 10:13 AM, Benjamin Coddington wrote:
> SBC-4, Table 13 allows READ CAPACITY for all PR types.
> 
> Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
> ---
>  drivers/target/target_core_pr.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 49d9167bb263..80b7d85030d0 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -470,6 +470,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
>  	case INQUIRY:
>  	case LOG_SENSE:
>  	case SERVICE_ACTION_IN_12:
> +	case READ_CAPACITY:
>  	case REPORT_LUNS:
>  	case REQUEST_SENSE:
>  	case PERSISTENT_RESERVE_IN:

Reviewed-by: Mike Christie <michael.christie@oracle.com>

