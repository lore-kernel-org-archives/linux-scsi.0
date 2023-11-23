Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dOPCT+Ij";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uCeiLtiv"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B9198;
	Thu, 23 Nov 2023 04:02:03 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ANBYfrO009267;
	Thu, 23 Nov 2023 12:01:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=FfP/dTBL7paPmZ8LnqVwgAEDn4THqzuHdizLkOLulgY=;
 b=dOPCT+IjpM1dN3hWYo4DwSnH+IBPbNJPqJ8aOVYLO06d1rR4IkfZbfRGTUfivDtipltm
 8CGaQGfVTfJOPnMoX19Wuv9AiU44Y4/OnUAqEyO98mhnVmK0D+raVGLa3h17IlB2hw3s
 SBo0pvH1xkmLNvZ38bXiOpGgr4LJ0eS6WGkI76ls2s2XSfDOFD4HH+1BAT9S3ytmZluI
 xMre/z8+D0itjTDYV6gGfax55ifcTSnItw/MLw9fYTpMFexdu5Fpzm8+2aQTL6tPUNws
 jyuoKyVvHoK3qUGp60IEeZkzRxLks7pfoieUOWMe7HTBFV6cFwGeaHcBwFH3Wwp37m9S vw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uekv31k2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Nov 2023 12:01:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ANBKNBF037057;
	Thu, 23 Nov 2023 12:01:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekqaa40y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Nov 2023 12:01:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIwAXmts+BxoxKB91tIDK5bT6zI3FSuZU96kgW/pZD5NbSEkMyetvILxVh7w6jpWrWDnHY+nTH6oTAeM5w+HJfPtytJ4776Yk4/i+toNL6tolZgHG5NQw9AwyYoRKkm+EHtbrO5LBJHlsHBWRD3Dz48ktCIlsAoJNVGT0RfyGWo71mqmhS09MggPze0Hd6utjGxi+Hvt0gtUs4r5YPu8fFAzj2qvFvOxjv5B/jrF/uWRcnGuW4B8V5gd/GH/84tpU+2Ylu3KPacug1yuZdnzTNkGTMNvHVSNhGPSyZ3ft+bzvmSSr/pGlyv+uyp3d4ElYjwaYSYp9WoXQuPnTmopCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfP/dTBL7paPmZ8LnqVwgAEDn4THqzuHdizLkOLulgY=;
 b=JyzJCiwgFmKV1ZDpft4ALCvDNWczMY6JOs2pLbyqSgilEN0vWLQ52LBVByaV5tzrrqXiMXT5ceoI6Lfphtxtpog9j/7JCND7IOMYSoR5ZxHgfGxHd00PmZdPPWjB5JftltF9ZQ0F1VsKwASSh2RevKg0MMAyPNiLsfkovSncrmlYeMFblgemh0SA1+5V2wRAfp7VbI/0vpvgVdHfDp46ChvxFUQcQhz7nmVU3rkuXhMRn+siM9grq0t1mhw1O0qieQdTSsZe2FElZsQTYFINBWBT2wPy+7mbNGy/Yxj/MAv16Zr9GwQuZwt3g+ejq9pEcJ5/o8E/O4lVNrQvQxxmuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfP/dTBL7paPmZ8LnqVwgAEDn4THqzuHdizLkOLulgY=;
 b=uCeiLtivV7YWLec9PVXu303WcFtxeITeBwBl9PiGWN/q6SgR9CagAj+T7+6tmSGrvKAz8JGy0ZXULN+EHicOPjvMPV0fQV2CsFef4iwfBiWZybEKiA6lcCH8sjUeaSv8zY4S4L97X3Q/nsoZGkh1VZgAjPnmcZeYw8BFG/ScM1A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6569.namprd10.prod.outlook.com (2603:10b6:806:2a8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.27; Thu, 23 Nov
 2023 12:01:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187%4]) with mapi id 15.20.7025.021; Thu, 23 Nov 2023
 12:01:49 +0000
Message-ID: <c830058d-8d03-4da4-bdd4-0e56c567308f@oracle.com>
Date: Thu, 23 Nov 2023 12:01:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
To: Sagar Biradar <sagar.biradar@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        Gilbert Wu <gilbert.wu@microchip.com>, linux-scsi@vger.kernel.org,
        Martin Petersen <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brian King
 <brking@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Tom White <tom.white@microchip.com>, regressions@leemhuis.info,
        hare@suse.com
References: <20230519230834.27436-1-sagar.biradar@microchip.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230519230834.27436-1-sagar.biradar@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0022.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::8)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB6569:EE_
X-MS-Office365-Filtering-Correlation-Id: feeae5fb-ada5-48bc-290f-08dbec1bf918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iiIfLVrAKDDa3w28mx7DMmDkNkjtGxKTo4JtTegFh6uJcdCkdfEVIXg6+QtqHdF+Xi4bPJZdQ6X4nRp+ujv4VnYTvVs4VS82Ri6O/hr2rdyvq2w60uZa2Nlci9ciwO3q5I6IzgsNlVv9KBbFuwqnO4/2ACWMD5isRdNW4m3edxZTt0mh4OJXVYiEwYHj1a7d/9SBmN77+svOYvoG0XsFnXODLbq/t8Pj3O8EmMiuan5uV8AaDOGKmHhUU1PzrGAde8IiJukktOAeIk9dv7PIVCBa12+0TVsza0jHOLGSBmnd/Fv+aaQZPSwf+Xrrlsz6b8HWnLw7ZDxQy8HL91OAMhaVir0uoM3IINIJXqjN7JEtwnEYATsOJ3LFbmJPKUgcbajQ6xiEUYGh3jKU7uwgRS6ElTCCApUbc9oMmg2jRaARhTTqGLPBUbNZDPETpU2A1ZZlU0jyklFvHv4ijFS9yRwLTu0GjTkbCZbKPebb2U6ruoVpKXvaEAbbx6WC3tESQAKVXe1W5C3teKfBb4MdYZbnMUwtBzGXmezLJa+nqtbzwiZfaWlkkO+AZCODf0ZFssVol9R/VrDtK+oLq7wIFYkyAwx3vzeoRj+9ryhjvFfID6qMe4qxm/lC+49p9XeqxOSromYXMx87UHXBmIELAGZniKJcf10YjhJTMXZC5Jc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(39860400002)(376002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(41300700001)(36756003)(5660300002)(7416002)(86362001)(31696002)(2906002)(921008)(6512007)(53546011)(6506007)(36916002)(2616005)(26005)(83380400001)(6486002)(966005)(31686004)(478600001)(6666004)(8676002)(8936002)(316002)(38100700002)(66946007)(66556008)(110136005)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NXE2UE9lMjFSUHlxVzBoRDZwMkEwZnFpQ3ZvRk41bzI4ZmkrTzd1a0hzdFF1?=
 =?utf-8?B?N3hCQU1TTCt0a1JVR0w4Sjh5K3JlRThYRmFuaFN0WFFFVkptdnMrZ2Q2Zmty?=
 =?utf-8?B?T3BNODB4N2I1Ymxrd2V6UHdyaW5MQ1QrcTY3bEFtZjZ0TG9wNjBUcDhOeVdL?=
 =?utf-8?B?dkgvVEMrU2pyb3lhOTdwV2xiT2xsRit4YTYwMzF3Q29tbVdONVo5NmloYVpP?=
 =?utf-8?B?SXNjdng1VDlCdGJrTXdQbFZ4dkl5Zm15S3VLYUlVaWJYc21Qa2Q0akVHY2xZ?=
 =?utf-8?B?QXdtSkJSSEZOa2NkWkNsMjlKdHI5UFhZb25VNjMzTkZucGI4ZmtBRmYzVEIv?=
 =?utf-8?B?Y242REVuZ1UyVHdFNFJuaUwwdEh3K3B6eTA5RW5Uc1ZZa1ZrTFpaRVQzRkpa?=
 =?utf-8?B?dFlCR2luWVdBWFNQRzJEanpXY3FCdUN5NGtaeDhLaE43RnMyOEg3NzZwUk9R?=
 =?utf-8?B?Wm5ZWVdKWjRXNWtyb0ZFNmxnajVranZlLzhhWFgvb1N6M0hreGpPSDdLSEpZ?=
 =?utf-8?B?MmtrU2NvbVVraUdQVnBLOGlxV2xxZ1A4Q3gxNlQyU095L0xpYkcyZzlZSXU0?=
 =?utf-8?B?b2tncVFKcTJ4V3ExQ1RSYlFwNzA5MWFSSzdTV3VDUWZXcm1vaTdIYnp5ckpo?=
 =?utf-8?B?SVZiK29HR0t6U2x4bkhKdnI0VlZ5UUR1M1VyeUNkajJJRGJKR1cvWDQrd2I4?=
 =?utf-8?B?VC8wQlk4a0pkVlM5N2VkekVybUtXSEJxcDE1UXlKa2UxNFZrTkkrSWhXdDBI?=
 =?utf-8?B?MVl0cnFVcUxnWUNLUHJyZ1B6Vk92OUxxS1BGdklFRk1JNXdlU3hHTjl5eVph?=
 =?utf-8?B?ZjFqOS9UNXBnVXB3d1czWXlJREVkQVMycllSK0UyeUx3RkFjUzdaa3ZVbWM4?=
 =?utf-8?B?dVVrRFArSDFON3hEU0R0dGY1NFdLZWNlTEFKV3pxajNKR0VmWFFMQUJja1Ir?=
 =?utf-8?B?QUExdVljQmZFTmJuUzY1emcyYU43QVpwSDJnY2g3NDFURkkvYTdCWUR4aE95?=
 =?utf-8?B?cjNUdnQ0aUVmc0QzZjVXY0cvSm9jZktzWnhpOUsvdytjZGh2cFFCVHVwakox?=
 =?utf-8?B?QTNlNXVQdDdDTDh0S2NZNlk3eTg4ZFc0R05kZkwrZnRjbk9pdTFqMUh5R1ha?=
 =?utf-8?B?TTRYUWFQZ1NldnRYVXJhQVprdGQ2WFRodlE0YTFQYlVDZDJ1ZE1nMUQ0N3Fx?=
 =?utf-8?B?WGs3dndVdGdwaVNJbnNjVzduelRZa3EzaUQ3enAzZVlUYUVabE9uZGhEL0xZ?=
 =?utf-8?B?eUxrMXdWOW4vaHNIa0tpVDIwaG01dnpoaVBJbGh6QmxZb2RPa25KQWpQbXo1?=
 =?utf-8?B?Y3lKekFXRzJKaDNwc0JmVWlUY08rbFBjNnd0b002NVZMbWIzM0IxQ2hnWmlN?=
 =?utf-8?B?aUdmMVNTQXRhQ3ZHNlA4UTl3YlVZSHpnV1NKM0pHWlcwWmlxQmVsdXRheXRX?=
 =?utf-8?B?cnUzYWhrMDRhcHlva1lRNVh2WkNPdUFQR0l4SUg5T294WHFOWkozUUc5b3lZ?=
 =?utf-8?B?OVJVYVc0ald6TXN0QlJSRHlJMnNuelV6MUdydHkva0RnN0lQcGVnWFltTEcy?=
 =?utf-8?B?SEdDaEVkMDY5ZUFFSVZ5SkVUR29LM3dYKzZEcWdraGgwT0lxRXdTUEVoSDJ5?=
 =?utf-8?B?MEN1SXNNU0pFMHVTbmNyU1lyTmRDWGtNTm1VSi9kV3pOMEJPMHQvbVA2cmI3?=
 =?utf-8?B?T0pxcGxLdUJIT3p6QmExR0hNaVZwYlo0WDhGSHkxc0JQUkRzN1VLTU8vMTVK?=
 =?utf-8?B?NWRTem9mQm1odVowQjRoTnExQVRoM1FXRVNBTHMyWlFjT1RmaHZtQnhOY0Ix?=
 =?utf-8?B?UVpqRDNualJWamFkeTBzZVJIOHRLUVN1WEd2dExNVzNmODVuRXBVNzRPY0Nr?=
 =?utf-8?B?NTMydDlpK3UyV0lGeHlGSFFjNml5Vno5RzErK1dNbWZvM3ZGQ2p3dE1IWktp?=
 =?utf-8?B?cmpCQkgrZHFZMXdqMnFVMVZFTDY0cUdiM2ZEZDRPWXlqUWkwaTFYWkFZMXFC?=
 =?utf-8?B?WXNqSEVETWluL0kzYngvcDNjTWVXeHA2YWNXOG9WTngxdFZPMnFsa3RnZmdl?=
 =?utf-8?B?aHFYOURQWVhhUnJYM3hhSFhTUXRmMzJQUkNiNHl1MTBVMk5NSGlFUjdGT01y?=
 =?utf-8?Q?0e6fZr9ebJMn1TiDtI13OI8ch?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?bW5uSVJGM1FTQjdwOVRSVzlFVms0ek43VHNEUUgrNFY5U0pHR0JiYnQ1SUZQ?=
 =?utf-8?B?SmhZQ1ExNmtMUUdiWVY1UlN6MHQwZy9YUzVMTGhKL0g2cDBIM25UVzU0c3lY?=
 =?utf-8?B?RU1CUmM0aFJ1MGxLM2lhSElZUkcrMlFoMTdwU0pQelNpYjBka0FsL1AxS08r?=
 =?utf-8?B?RysrREJYeXdTeUp3ampGRFRzMXluNDJrZ1RRbmEyeTZJVnBzMFduS1gvNkNH?=
 =?utf-8?B?NC9scGVuYWJCY3JjNXRxY0QrQ0dMOE5Qc1AvWmt5ckVIVmdpZlVKcExrUklp?=
 =?utf-8?B?ZEhudHJ5czhKVHZNQzBvNk5IeGYzQkJtd3BHRFRxQzVmSHJYWFVJUDlvV3pz?=
 =?utf-8?B?UW14b291OFZiZUpRRi9RTnFmbnIrMDF3dFRIT1ZkaTlMcHF0aDJoZG4xek9I?=
 =?utf-8?B?OTluZUdhbjRQdFZwY3NuZ2IxWXhTUCtISzBxMUlZL0FvUGRpSjZrUEhBSGYv?=
 =?utf-8?B?RHUzaENkYWFnbmRlTVpsSDNOcW9JQXBhR3VhY3AzcEdHUFFLNENzQzI4dERS?=
 =?utf-8?B?ZEk4YTBaWCtUdHJDeEx2TUlubkxYVUZXQTl0elVBMkVaMUFFVlFuOVV0bDho?=
 =?utf-8?B?NDBTeFJzUDNTWFU0bmhtTWNlVW9uK0dVdnpBdGVZN3dFYnNEWU5nd2x6RHEy?=
 =?utf-8?B?aEJTUk9KSmtnMnUzbi9KOVdNUDVDNytCT3A4eEVYS2Q4akFyNXpGRWw4NnFx?=
 =?utf-8?B?QXBwSENmWGlTQjhvVWovaFVhTVR0S0ZwalRqME5uUUlXZkNpRkVkbWhHZVNw?=
 =?utf-8?B?MVVXUHNUblp3MllPN1RqN3FlUXVMNjc0Smp3bDNjeEdGMFJqR0hqTXVQN1cv?=
 =?utf-8?B?dm9QT1FqYWRaWlRtTHpVdmVsbmc1dHRGTEgzQXh3RDdkUXRJRnlNV1ZVQ2o0?=
 =?utf-8?B?Q0tEeDJzNUpxYktNbFNkSllBc1ZpbWE3eFZSZ29vSzVjNlFrU25veUEwVS83?=
 =?utf-8?B?VjlzQ2Qyemp3YjRmYkVHbEdVYjEwNjNucnVXeFdFRlJNUUFnd0ZyVWpKWnFG?=
 =?utf-8?B?UE9QYnBxeUVENGI3dHdYd1Q0ZE1mVWN6REswbnZCNmhFNndaZEJWUEhQZmtE?=
 =?utf-8?B?c1lpeUVqVTkzelRkSWZ0eVVlaEs1aS9mVGlidks5TzlJdkNWcFM2dmN1bVlB?=
 =?utf-8?B?OENHYzJwbjA4K1NTa2FWM2VnanlZU05td1hrL0h0SHBXY3hQQ1hNWHZzVWs2?=
 =?utf-8?B?SWJsK0dTejJoZ2RzSEs0cFpXUUNxL3daQmFQd0l4aVVyYUdIdnNnR0VDZDJE?=
 =?utf-8?B?b0Y5VXRuYmxIZ21zUXZncXJwZlNpektLUDVWRDUySi9BOVR1Zz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feeae5fb-ada5-48bc-290f-08dbec1bf918
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2023 12:01:49.4028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kKLoEP60J6lYvl6YsTNfT8yCMZE2DeHc8xzTmgQZUcXpwbVezWRH8SyCSGU257I6vw7XdvZD7aj+D+fPMLKQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6569
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-23_10,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311230085
X-Proofpoint-GUID: 7CkScyWpklI7j6itovyVB9lU_PoiAYoB
X-Proofpoint-ORIG-GUID: 7CkScyWpklI7j6itovyVB9lU_PoiAYoB

On 20/05/2023 00:08, Sagar Biradar wrote:
> Fix the IO hang that arises because of MSIx vector not
> having a mapped online CPU upon receiving completion.
> 
> The SCSI cmds take the blk_mq route, which is setup during the init.
> The reserved cmds fetch the vector_no from mq_map after the init
> is complete and before the init, they use 0 - as per the norm.
> 
> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>

This the patch which seems to be causing the issue in 
https://bugzilla.kernel.org/show_bug.cgi?id=217599

I will comment here since I got no response there...

> ---
>   drivers/scsi/aacraid/aacraid.h  |  1 +
>   drivers/scsi/aacraid/comminit.c |  1 -
>   drivers/scsi/aacraid/commsup.c  |  6 +++++-
>   drivers/scsi/aacraid/linit.c    | 14 ++++++++++++++
>   drivers/scsi/aacraid/src.c      | 25 +++++++++++++++++++++++--
>   5 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 5e115e8b2ba4..7c6efde75da6 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1678,6 +1678,7 @@ struct aac_dev
>   	u32			handle_pci_error;
>   	bool			init_reset;
>   	u8			soft_reset_support;
> +	u8			use_map_queue;
>   };
>   
>   #define aac_adapter_interrupt(dev) \
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index bd99c5492b7d..a5483e7e283a 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -657,4 +657,3 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>   
>   	return dev;
>   }
> -
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index deb32c9f4b3e..3f062e4013ab 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -223,8 +223,12 @@ int aac_fib_setup(struct aac_dev * dev)
>   struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
>   {
>   	struct fib *fibptr;
> +	u32 blk_tag;
> +	int i;
>   
> -	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
> +	blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +	i = blk_mq_unique_tag_to_tag(blk_tag);
> +	fibptr = &dev->fibs[i];
>   	/*
>   	 *	Null out fields that depend on being zero at the start of
>   	 *	each I/O
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 5ba5c18b77b4..9caf8c314ce1 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -19,6 +19,7 @@
>   
>   #include <linux/compat.h>
>   #include <linux/blkdev.h>
> +#include <linux/blk-mq-pci.h>
>   #include <linux/completion.h>
>   #include <linux/init.h>
>   #include <linux/interrupt.h>
> @@ -505,6 +506,15 @@ static int aac_slave_configure(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> +static void aac_map_queues(struct Scsi_Host *shost)
> +{
> +	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
> +
> +	blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +				aac->pdev, 0);
> +	aac->use_map_queue = true;
> +}
> +
>   /**
>    *	aac_change_queue_depth		-	alter queue depths
>    *	@sdev:	SCSI device we are considering
> @@ -1489,6 +1499,7 @@ static struct scsi_host_template aac_driver_template = {
>   	.bios_param			= aac_biosparm,
>   	.shost_groups			= aac_host_groups,
>   	.slave_configure		= aac_slave_configure,
> +	.map_queues			= aac_map_queues,
>   	.change_queue_depth		= aac_change_queue_depth,
>   	.sdev_groups			= aac_dev_groups,
>   	.eh_abort_handler		= aac_eh_abort,
> @@ -1776,6 +1787,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	shost->max_lun = AAC_MAX_LUN;
>   
>   	pci_set_drvdata(pdev, shost);
> +	shost->nr_hw_queues = aac->max_msix;
> +	shost->host_tagset = 1;
>   
>   	error = scsi_add_host(shost, &pdev->dev);
>   	if (error)
> @@ -1908,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)
>   	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>   
>   	aac_cancel_rescan_worker(aac);
> +	aac->use_map_queue = false;
>   	scsi_remove_host(shost);
>   
>   	__aac_shutdown(aac);
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 11ef58204e96..61949f374188 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)
>   #endif
>   
>   	u16 vector_no;
> +	struct scsi_cmnd *scmd;
> +	u32 blk_tag;
> +	struct Scsi_Host *shost = dev->scsi_host_ptr;
> +	struct blk_mq_queue_map *qmap;
>   
>   	atomic_inc(&q->numpending);
>   
> @@ -505,8 +509,25 @@ static int aac_src_deliver_message(struct fib *fib)
>   		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
>   			&& dev->sa_firmware)
>   			vector_no = aac_get_vector(dev);
> -		else
> -			vector_no = fib->vector_no;
> +		else {
> +			if (!fib->vector_no || !fib->callback_data) {
> +				if (shost && dev->use_map_queue) {
> +					qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
> +					vector_no = qmap->mq_map[raw_smp_processor_id()];
> +				}
> +				/*
> +				 *	We hardcode the vector_no for
> +				 *	reserved commands as a valid shost is
> +				 *	absent during the init
> +				 */
> +				else
> +					vector_no = 0;
> +			} else {
> +				scmd = (struct scsi_cmnd *)fib->callback_data;
> +				blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +				vector_no = blk_mq_unique_tag_to_hwq(blk_tag);



Hannes' patch in the bugzilla was to revert to using hw queue #0 always 
for internal commands, and it didn't help.

Could there be any issue in using hw queue #0 for regular SCSI commands?

AFAICS, that's a significant change. Previously we would use 
fib->vector_no to decide the queue, which was in range (1, dev->max_msix).

BTW, is there any code which relies on a command being sent/received on 
the HW queue same as fib->vector_no?

Thanks,
John

> +			
> +		}
>   
>   		if (native_hba) {
>   			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {

