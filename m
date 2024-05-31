Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACE48173C;
	Fri, 31 May 2024 11:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717155328; cv=fail; b=hwzMtnDMsvp/E97EnoJFUyrqdAR3r06m2Z0q1Od2zcAOXspRjvgeXlJZm6fgDefICB63zqSxEjvY9VpiCm1xa1WU1tAp89oFZaVy+mf17v4uiOdLjiLOQ7aJGrk5xO2bb/MWlkxEiAv28YEEqhEaUvq/usI9y+ZmhByXSE2GsxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717155328; c=relaxed/simple;
	bh=fgk1U0hza/6zj7E9KIDyqiOqxZEoC/NMkwFde08/Da0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lyTNW/9WhQ11I8IoVzQt0zBw44jTB6ibZzLEKl+VC0H7k8nPzgLo0605XOgQ4P1GTSr23nilbqrfjN8cuU049Kl322mziHhofg/JgPk4KTjS4X9DyXu1D7tx0Ynmj/MbhOrxDh6alAArE6r3LWOcDOlX5u6MxwKohL0U5clGo14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V9Vfrq025637;
	Fri, 31 May 2024 11:34:55 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3Dc/o75S0jRnXqE1AiLDzyv0X6Ye3yWpS9b0ZDev3AVfU=3D;_b?=
 =?UTF-8?Q?=3DIL9BxH26tZCBICwB/a1j5GfUhpMYot80v1T0zsUENhUpNOs6eCHxdZQ77bXR?=
 =?UTF-8?Q?Bffd8+Qs_u72qmmrUY3+vGCyh11qkVMlqVZxWihTeyVRj/2OzGqNXnytJZrDk+7?=
 =?UTF-8?Q?P9M945tCAN+4Br_pwh8ao/8mgsbLMkZ9eJ5F9n1ABC27NyxMyBgvO7ZwFHKNoh3?=
 =?UTF-8?Q?SCjhCynaB7uDUybNU6ZA_o4Wf6ibavedYR6muOYQVzVoL8SVRIU+jv+L1FtuJ5J?=
 =?UTF-8?Q?AWhh+ESBdkyVnATmhx5LTpCeaD_C9HN9PeNgjtYvDQnOGNBLDJJpyQ5jwCd2ZPK?=
 =?UTF-8?Q?TmuelkxPcatcWUx4QWEe0EITQ3iQ5XmK_NQ=3D=3D_?=
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8p7tvr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 11:34:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44VAwbVT016267;
	Fri, 31 May 2024 11:34:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50trgj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 11:34:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGXenzG5sY1u3vF5ni28A7xCbOpAw2Ce0WIeDCB1exdkr8rCW8Ady6jK/iOsX5u6UCTYPjmBbN5ViowEwT41P6p+5NdGBl2oPD6jcNBzDoq8w15baoMrRLRoe4541sC3gJ+UW7GxkaPiHjEgJIj5RKkOvjiMnMOC1ZpmQrBsk1cNYRelaDkjwxqgGA2LDz+8dYhrFBYH6/yr6hJ7eVs7Q8k2fzoON7DB9fpBO4PNEX4bth3obCIlx5NqzYuglK1nQPu+MUMhYWNgLHLuGVMNI3GinatZmnr5x8o7oe34+UxSRpiD8HZD59KvKgtCVvsobxJoyNEgQuXEbjUoPvs2jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/o75S0jRnXqE1AiLDzyv0X6Ye3yWpS9b0ZDev3AVfU=;
 b=RoQH/N+orWBJoto1HBvT7zOunFD0bFQggsyawMW9ARVzBztoSP5YQL4KfA942J2Awfyp6405Zb7ZMYMuMF3AqAJZ2cZOMr22m0JdLLbf5AHmGqAN7AWpB761EXylmZegdDB0GgzjQ1tRn3HqPsb7/9df1C883M/lAQZo/0spwLhAl0sF4XCueCc1ypJfbkjwPDHGZhX6rwoHMqu3U6HfJ/UJwdrObTaZqEq+RLftf79Cu4eVfnK5/SzeWS1evsLOTaz2lHfelG/2ZJsZ9zICwfQDWMo1bWxmILBf8/oeC6H/kXgPc/QKBuwzl2Ry+KvGaJkga9NlxbmZfIm98pR6AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/o75S0jRnXqE1AiLDzyv0X6Ye3yWpS9b0ZDev3AVfU=;
 b=euNCWObatSp1hnPcV4yvVokXZMyRM8Fzqn6N3jFQdKPgOTv8zcNN/x/kvNyuyReor1+00UUpeQyAPcr5UlOERnrs6cyJE4ngxcbLWUehQqMUy6VjGJaNpHLc+58Rflg7vn3ifjia5B5MxxT5d5xxxsA6Vemi/fJAkfgbqLtF7yA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6839.namprd10.prod.outlook.com (2603:10b6:8:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Fri, 31 May
 2024 11:34:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Fri, 31 May 2024
 11:34:52 +0000
Message-ID: <a6768ddb-54c5-456e-abcc-39ed99509c87@oracle.com>
Date: Fri, 31 May 2024 12:34:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/14] sd: convert to the atomic queue limits API
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        linux-um@lists.infradead.org, linux-block@vger.kernel.org,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>
References: <20240531074837.1648501-1-hch@lst.de>
 <20240531074837.1648501-12-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240531074837.1648501-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0040.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::28)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 936c4abd-e5d7-42dd-cf8d-08dc8165afc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?N3ByRFNFU2tOcHg2QTNDR2VrV0p6SUFzRHpMQVVTZ2lrK0tvV1k4UVRtOHN4?=
 =?utf-8?B?aU93ZEE4YTN2N1ZUODlBMElwM1lCYUJQWHJwQjhpRmMrYTI2UktsNERVcllj?=
 =?utf-8?B?QUc0eXRQeEVTUTVQMEdYaWdNRFBmc0grcDhBZGVkdnFWZExBZEtLYnAzUHVY?=
 =?utf-8?B?Ti9KWEMyTml6Qjh3eGFjY0cvbndmR2tqQVZBT1B2ODJ4WHZZRUFjWHZRdEMy?=
 =?utf-8?B?ZkxrV3A0dnFQVTdHN0dvaHJ5TTFKQ3F2MGZka2V3VThkcVhSOXg0SGNFeklH?=
 =?utf-8?B?bVhCSzA5dHNUekJ4Z3hGVnQxZVlJYUxqUFV0VVhTZVFSSC8weUZweHF6N3pZ?=
 =?utf-8?B?Mjd3SHozWHhXRFRNOU5xNCtzZENmYzVXVXZZcW9uVTR2bEo1aGQ3VytsVkk3?=
 =?utf-8?B?M28vOWxPOGFIR3U2MTg4TDhPZ3N5UmlkbmVLdmN0TG1lb0svenJZaWlJREI4?=
 =?utf-8?B?NzlKam0razF1UVJaRFV4MlZBbHBKc2xIczYzYlJ1Rm9yU2NXNGtaeEl5VUtm?=
 =?utf-8?B?QW1aUlZCcUgrWk84QlNVNXJ3eTZuNi9idkJ1QVNVcmdjZ3FXM2ZMQW1SenNZ?=
 =?utf-8?B?bjJkK2pPREpRN0dCQ0lsVlk0Z25McFBvTTVLYzhGeWN4cG1aSktzUlhQdzlT?=
 =?utf-8?B?WGtIWHVHNkxGcmVnYVZHb24rRGFJdTZQUFMxd2t5bDdoWWlud0lCL1dsa203?=
 =?utf-8?B?QnI5M0J5TlM4QlBrLzdEejZncCtxSWsyOG9WcTFZelFsSUoxME9GenUzelNu?=
 =?utf-8?B?azJuOWxJK3AvTG85UlRxTEx2SmdkSGh1Wk1hSm04M0RFVG1BQ0JmOWdiMWJ4?=
 =?utf-8?B?VUdIUmV5cDVHSWRPeGJjOGRHRTVJb3RTRFVXcHRNT1VsOUhBaWQ3Y0FDMU9U?=
 =?utf-8?B?Mkc4R0U3clJCVzZUd3QzTGNIR1libi9ReElVUE9aNFdpdlZJb3g4T2wveWhF?=
 =?utf-8?B?ZXhhOTN0QXlhYWhNRXhMSXI4eXRnQjBza0lYcGd2Y0p0VUhNN0dtcE5KaDZo?=
 =?utf-8?B?cU90NUpzNlVPcDJ3aEt5SDkrY05qMklzV1hURXk1bGNnL2Z2T05UNEhvVldW?=
 =?utf-8?B?TlVMY1J5K0JiK0FxT3RwQmsyWjJHdk1zNmcyNHI5eTFPS1RLNWZkNHdtTjhS?=
 =?utf-8?B?VlZaY2xTVVczSVA5Z21Rd3NQemdpeGJ0SXlkenJrYWlQbWdtZUFkSHRpSXNF?=
 =?utf-8?B?YUJzVnc3WG5QN21reUhFRmJzUXVTdm81TjFNMmpwb0xKS3pNU2dONFpCU2Qx?=
 =?utf-8?B?amhMYzdxSW1YQnBFNlJ4M2dhOWVXSGFZR3RySit5Wm8zYTd6aVlJSjFqQUNo?=
 =?utf-8?B?QU8vU2Yvbmh6aFlTMjRnbGxNSGVycCtubTB3SnhnN1MxMXJJZjFYVm5pQllY?=
 =?utf-8?B?Sm1TTVlaTXd6ZmVmaUtGOU5nWmdBVU5HUmNLSm5jaXQrcElwZ1JWeDY5SUdz?=
 =?utf-8?B?U0QxWDR4c2dBdnFDRytzYzN4TDhlbTlaQ3pMU3l5TE9SUUZIWVVtSWUzVFNM?=
 =?utf-8?B?cmpIN2NtYkNmM0IxTlV3UlhFT0dBWnF3Z3V1SnVpZWUxUTFxZkR3MXkzdjEy?=
 =?utf-8?B?SjdST2luMjdLL3Z2UDd0NWIyQ0N3QTR1bjRkM3grUHg1MzBOMXRYZ0VTL3BT?=
 =?utf-8?B?b1JHYzgzcS96eGNLR2owL010dStlckErTGZCRUx0dmlOb0g0ZzhmV2grWEl0?=
 =?utf-8?B?OTc2anZqUmJPNW1OK0E1N2NKQXZRV1l1WkYwKys3V0l5b2E5S1ZBbTFBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bElBSENtZnIxdnErVnYvc2pkaGdSWi91ZDk0ZG5vZTJjUVZXaU1QeDh5RFQ1?=
 =?utf-8?B?cDBndkNZYnB1OFNtZENuS0p1eE9NK04wd3JhYVhGamUyNDhiWUZYQmhVUUFJ?=
 =?utf-8?B?MUJ4dUxTNWJhdXdrKzh5SnVsZVBURkdyU3pOZWFESmJsSXNyM1BGdmJEcnVm?=
 =?utf-8?B?cU5QVTZDNXlUM1RJTlN5blRDQVpzcXBYdzZNZUJOcWw2ZEFzM0JYaS9rNkQz?=
 =?utf-8?B?ZVJjWjdadHRZWlprcnpDMTNGZG1VNzVZV2dlS3A0dVJxdU1iMXFuSmtEWjJC?=
 =?utf-8?B?dEVPdXlteHdhcDZ2ZGZydWVIL1Vvd0ZrdDA3eDkzdldlUk9rdUhHOWpwdElR?=
 =?utf-8?B?ZlBBSFNrclB6ZDczVHMreGl1Q24wU2FaWTdHajVlc0VMOU9icFpGZFQ4amRo?=
 =?utf-8?B?SWhjb0l3d0xMVnorejN1L2svWmtVNXFSKy9DeGxWeU1iN1hlZEkyaWFvQnJ5?=
 =?utf-8?B?RDhkL2FldjBzK2lmYS9nYUhDQ2ZsS1JQeHRVZ2ovb3BMUmkwMFozclNGMURP?=
 =?utf-8?B?M0tPQjMwa3l4WkgzbFU3Zk9JYVVuZis2K2tJQXE2N0JEMTJwcmcyc0N2QjFS?=
 =?utf-8?B?UThRYVM3ZHVHUFMwdXY1UE1idlZ3RVAxekxlYzZ1S3FaYWlBUDRHZjVxWitF?=
 =?utf-8?B?dm9pcUpzY3orM0YvOXFnaWZwcjcrWVdMdnJkVWQwZ3JIdldIOTk3M1BseWwz?=
 =?utf-8?B?Z2xrRFNDWjZjMjVTSkVxd0JOM3BPRUQzWWwyTEdBbDhuVnJPS3BLcGEvT0xh?=
 =?utf-8?B?eEkzUmxsTlhBTUx3aWkzekZ5YlREOTVkZDVzaUEwazNhTnBxeTk0QzNSU3Mr?=
 =?utf-8?B?WWZmbUxjbEo3QndXYXROdmV5eWNzaXoxakkxWXZvRHBlWGc5MzJJZCtFK2w5?=
 =?utf-8?B?NUlhN2t5czQxUXk0M1Y4R2F5Nld4K3Bxdlpld1p6Q1pXalh2a2lBK0hJczNI?=
 =?utf-8?B?TnpSeGs1VG9zVHZMeVMvNUVQNmRPUWlBTVhNSE5KaUdMRnVXdHh3TWpPakt1?=
 =?utf-8?B?eWFJRGw3cndSRzFMSzlIMFgweE5zWllOTTVkQ1FSR1dLVUs0NHdKY3QrS0Rs?=
 =?utf-8?B?L0NJSEdEM2dZUEJscE9MTkpNYitzYVdaWlp3Y1hHeCszWnRQTGR6SWl2azJT?=
 =?utf-8?B?RlBZeXptNXljaFQzQmwrZldrQWFGVytmZDBNSTJES0NsQkhZR09GaHdkN0hK?=
 =?utf-8?B?S01KZmZOV0dYYVhQOGFYMGVGcGNQSWgvcVFvZS9FQ1p4b1FYaHU1UHZubHdZ?=
 =?utf-8?B?V1FXQjVtVzdNenMyZENRbTdEajdkWlNqclRncWEzUnQ3ZE1jZzRFSkZQUTF4?=
 =?utf-8?B?WjIwbWpHNDZqTy9sejNXUDBvbUhMOXlXS1Bmc2pRZ0o3d2tYQ0I4czJicnQ0?=
 =?utf-8?B?SzlGQW1YYWxrOTFQazVJS3JwY3lCc0hjSlhsbkE0OGM2VzB1b2lkRVBUekVp?=
 =?utf-8?B?VlkwTlRlRDltT1hpL3h4U2pvVUtFbkxoUFRGNEUzTWpPdXc5VENIV0NXUEV4?=
 =?utf-8?B?cDZ0ck5GUlpNMm1mZ2hlWHdTUmcyclRnK0Q1MFN4eDNVbFd4TlNLRTVLRUFm?=
 =?utf-8?B?WGpWOW02dm84NmNLd2ZBanVGaWlFZlpLZ0RRd3pDS0NqMzNpWVdVOWxXOTdt?=
 =?utf-8?B?UnZrcVBGbm5EVDhpakhGRjhxL3EvT2NSRHpGQ0doRWtEaXNWSlc2MDVWMkkw?=
 =?utf-8?B?WU9CalFHS1pJSUppNFNNQjZ6ZXc0ekZKVkY2NHJpcUdBZTcvcjI5aVNmUEgz?=
 =?utf-8?B?RzJNV3EvS1ZkdGtFMDJxMEtDQkh0NWo2RHNGeW1GOVdoWTFzUW9GVVdhWmRY?=
 =?utf-8?B?WXhMcVpkYlJIR2Q0aEx1U0E5anZLaDZGelE5RWpRajVteE9CTVVZMXVlZGJU?=
 =?utf-8?B?VUdLVEw4UEEwSTBjdFdCZGJsb2xnMFBjTU9XRDZ4OFhpZjhJM2FSeDE3RlBQ?=
 =?utf-8?B?SUZ1VE5FQmNUZ3lCWmJwMENaN1JidzlQT0RFSWN1UnVoU29HbWZ2Qy83Q0w5?=
 =?utf-8?B?ZHNoZWdBczBiM0YyZnlidS9jOGJQNGN1R1lSWUd3a0tVck1NWHpMUkx5eUtG?=
 =?utf-8?B?bVEvU2hQbjR3TnVSRjExaG1GNzVoVXFPY0pvN1FrVEpqU2NMVnNFVGliUUtJ?=
 =?utf-8?Q?prqHOvwO8DUgdKPiBbHn6gl5T?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tw5B1QTBDcjNGsNwzT+rV48POHjqkUOzwQa/L6a67uIkMBWPsZQWPZRx+IAJK8aTkaFLJF2O+RG5xANZpqxZ+943zvz+ITaAAuVSXVmiQzb+lZV9MXlsXEwvYUl0M0u2Gbc2kt+mFJ5zyQdcOAPlCx2Xz0ZHVhdKlwX6WK+6k62mFdB0dTcUJOt6cFMTRcs2Y8yG5xfLQSqG2Kg0yF+8ZE+y0HG4VBUkLQ4DCe2EC2nZPNnn9pCrLR8C922b+RE1mqvzKhvTNazr/ih/+m2QEuw29b/hZEj5zOBUvO8K2EfjnSHSK5hGWdu1q3OR6SAPiiz1MNrKD8v4jVm9O4LtlsA9OefIlYchgKaPUe+hjRgCvMlS8+WmGcVwClrGJ+J4MCS3k84O0zqdmx7eJeWvMQwSt1Q7MTNIdORXvszjylA4sH1QTufsBXtnUEWy87i47BfsD77XkqwVMzmlVvkPrjjwScwuXKGVDQ6Sy2TkMkOuZEoLsxlOGr9naX7s5XGAWq9d9UrFh/uy+vdjABzY4EFHXpMOHxHpxTJA9Sb41oivrqm3oFeq75gOft2Jxj6PyFitBTyr6BkOkEGtdGHNLYKeO5fCtSw6v4bm//YoIZU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936c4abd-e5d7-42dd-cf8d-08dc8165afc0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 11:34:52.2013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DkTYbYrC9k6wM9GxKt1HVQ1FEA244/KCZCU8tRgwERMgmMgjG3Sp8nWedFBwBrfMiZde7B+x5cFa+DR9NRNSaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310086
X-Proofpoint-ORIG-GUID: 4VOGg0iTfSa4Hi-AE7demkKzZNFEXj5v
X-Proofpoint-GUID: 4VOGg0iTfSa4Hi-AE7demkKzZNFEXj5v

On 31/05/2024 08:48, Christoph Hellwig wrote:
> Assign all queue limits through a local queue_limits variable and
> queue_limits_commit_update so that we can't race updating them from
> multiple places, and freeze the queue when updating them so that
> in-progress I/O submissions don't see half-updated limits.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Damien Le Moal<dlemoal@kernel.org>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>
