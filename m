Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108F61E8329;
	Tue,  1 Apr 2025 09:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743499521; cv=fail; b=Zmxyq04kKr5ZWm29gCr9fs/7rioO15958JNiHnRPciU+buRwvR3JF2Deyb2IugjQowbvZo0al6Y4XTX+wf9r6howX822JMc55uWROTSP3HxL6HfTvxSbziKsdIEVyjDp5WA54UkPrh2IbGMrBN97cdhhF8A83N/O2IFRDQTCP4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743499521; c=relaxed/simple;
	bh=F5VCkFYPii6dMciH64szxzumUYWPkCvv+EQ1RPoAE60=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hqOloYBauV33RIM4zr4S5F1PhLKM3VeN9wX7v3xj/MPxSATZFerGPgLg+ABEXV5ZaF11eVxy7NvuB52gHWE76/kspeYWXH/1a+rOKnwKtnvu2AKGratZYANL94eRkSzMJHQE1QZVLBcg/cEFzNJFYcjk7knTcdyg430hU+7WOzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lh+3Nbof; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=buFFANLP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lh+3Nbof";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="buFFANLP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5318Bq6v029322;
	Tue, 1 Apr 2025 09:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ROYjxd75g2lhJTwNLwFOaPs3jM5O34OtEgyHDF5F2is=; b=
	lh+3NbofmePedkCOtdc9wslyQazwv3hiF0+d8MTzTF54oFLQqsGeDQCZnKrcr5zf
	7LUr7b7HU6MnR1K1MRk2Wl4HgCSw/xOZ5SHiMZJmIuxpYZqQ2kO6yLWQbFihCKOx
	Zh0GAb/gp2uu44L665mliFiEEMB/mqFoIAl6+e9mnsai53V6YXCByajzcDa6vW92
	Nl1s9gvHMiFcznSfLXrIzrvKsH510VDlYDGpZnv+msRvA/Z/IwXFC0T+cCsYsM+X
	Rsjyv02ecV8HlkLRMEeTWPpgGQZKxbc1VkVUhZ6Z0tn/MVfrLWpGr607Jc3a1d5i
	jayQuB45mY8kX2wdaIK7LA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7n26ky9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Apr 2025 09:24:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5318Xlme004264;
	Tue, 1 Apr 2025 09:24:58 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a94bdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Apr 2025 09:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOn5GAUT21F/HamRCbO3Fi4SaYwgMdZqVJhV/+9nDaczMIuxNvsqfEMnOWR8ZSaNBL+jbpyo5WdedMVhSgHWt2GdhtDdxI60gg/UrAJEQ9txXf6JLe2qHwc+lgbX1sH5av9IkhIL3M3jBDTE/pc9PMwyh1u1WZOOD7e6SFIQaVPndfdSo1C/j/a3Vi+CsM4s7s5tPk9DGXB/ZAZYeH7LUHa0KQDZN/Fzv9gykNbe+vcsALBCagLqH0HDhDs934Q3vlJdIsTgElulB/szd9Tgm2yEaDocMvXMpaX9doW4vveMBJx+PX5apjjwPOH5iLNV2Kb/xsm30h9K3k2HR2PzcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROYjxd75g2lhJTwNLwFOaPs3jM5O34OtEgyHDF5F2is=;
 b=aTKJx1nd5d1gaJJyBMKURH0YdxQ9MI5fX+5fEDyzlAd8l719L1ieLBB5r1rVOqnuKHlV2RVOiv/m9DGVJacKdSz0Qfvk+z2eX3U9NcN9XbE7CwmL9f6oyB/g11mK2mwtd+rDEL8PlSf+7y6MpPi+1DqbIbMJ9E2tGRm8uAen0zjfJ96bkPyTy0OfD/7geOyRNdCvIc3jXGvNsxXg6rnkyg39VR4lqPZjBDLLXJHqPQzG11Jr4cZCbCwB5F2/VpWv8/RQiacs2l98RMSN2hSZwhB2x38v+WHbfk4UgeHdA+XefSAnltniP8VjVo/6MFzLbqmPP1uX1clYqetqHCK9Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROYjxd75g2lhJTwNLwFOaPs3jM5O34OtEgyHDF5F2is=;
 b=buFFANLPQhV5JVzifg3NSInwBeov+xcHcxnX2A5L+jyCtagrJ32nQvYABHflVvR14fHcimR+frTJ7yZBt85wWahGxt8HJ+kO6+0tPozwfGciT3oQmxGnsEFHNNy3sA96jcC1IEeqT2FgJJmnNofMGJuSkIotGbV/dCF4qedzF/0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH4PR10MB8075.namprd10.prod.outlook.com (2603:10b6:610:236::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.38; Tue, 1 Apr
 2025 09:24:56 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8583.038; Tue, 1 Apr 2025
 09:24:56 +0000
Message-ID: <d6d8c73f-d741-4607-b310-0c2934921046@oracle.com>
Date: Tue, 1 Apr 2025 10:24:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: reply: reply: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce
 new error handle mechanism
To: Jiangjianjun <jiangjianjun3@huawei.com>
Cc: "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "hewenliang (C)"
 <hewenliang4@huawei.com>,
        "Yangkunlin(Poincare)" <yangkunlin7@huawei.com>,
        yangxingui <yangxingui@huawei.com>,
        "liyihang (C)" <liyihang9@huawei.com>
References: <598173fee9844be9ba19bfed35be2f5c@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <598173fee9844be9ba19bfed35be2f5c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0261.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH4PR10MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: b70aaab9-7ae0-4d9e-6ecd-08dd70ff111f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MUpGeEh1N0kzQ2dtTGx6WDRkb3ZxQ2tzN05iYU9YbVNadkQrQkR1a0lzdXI1?=
 =?utf-8?B?eFhGLzlXSkp5WHBkOEgwSTJRNjhPS1dXckpIUG9SVzFNSUV0RWsrZmdENC9l?=
 =?utf-8?B?VzBsb3dHWGJ5aEwyNE9hY1JLZndVSWhsbXNWSVlWWGNuNGhNcDZEdDliWmxB?=
 =?utf-8?B?bkdkRWphb1ZiRm1WWTFNTWxaZS9jb0RRWTE3bk9CQktzclJBODhTd2RDbmdM?=
 =?utf-8?B?dTMwZlRvQnc1dGZVUTNJamVSQnpoUUNZR1lsdEl0L1Z6OURjWEFnc0JuQlNT?=
 =?utf-8?B?bFp4L2F4SFBJamVJUmhwMHhJajBMQnBVazhsRjlHODBRMCtjRlR3L3VZVjVa?=
 =?utf-8?B?bDZqMTNveFIyZzFseUtOc2p4SzA2ZVZPWFZSbTM3WGs5NGFDY3kzYVlIaFV6?=
 =?utf-8?B?T2I0ZE56TWVtQUdqKzRHazFCYzluN3ZkYXI1aVM2MGc3aEE5RU9VT21sVHVy?=
 =?utf-8?B?cFMxUlBIbGhrTTRRZXlMalpLbnpCU1VTZ0ZWTXZJUnc1M2tsYytGSGl3Rzgx?=
 =?utf-8?B?SHhSd3VGT2g2VXVDTXdRbVJZbnprbHhlb3pseWlkV2ZVeVMvU1c4M0d3dW9R?=
 =?utf-8?B?aGh4Sy9rTzdjNlk1VVdkL1M3QXYwSGFYRldBY3kvT0hHNkZYbTlLT1VoV2ds?=
 =?utf-8?B?UCsvRVB1Q01EQVNwQk1QU1pLU21zdmt2MmM3ZlVBYmdKbDM5RWUxRE85bmVI?=
 =?utf-8?B?bUc1NFRvUjRzTVVNUENQTGFWK2J4MzdlOUM0ajVWaWs3RmN3L0pjcE12WW52?=
 =?utf-8?B?bXE4TVJYbk81L2djaHMxZXBqTlQ5aHFEYzFjVUFJOGp0UXpnUEx3eitRZ0hB?=
 =?utf-8?B?Y045YnNMT0IycW5jQnZsYUVReWJqOCtRbWhjMzJyZkVYeFdIMkZnWjFpVU1v?=
 =?utf-8?B?UUtuOG83cFZPVFprWGsxUjVKNzVpSmFiN2N2VmVvM1ZMV1RlejQ4KzBZOGJO?=
 =?utf-8?B?K2QzWGhPTkk1TWlPcnVSaFNDR3BNWXU3bEV0T3JWb3JHZE4zSi9SVHBKSWhq?=
 =?utf-8?B?RVd5dHpHdnYvZEVKQXBsUzU5M054WW9PNXdnaXlIblJyQVhZRVdTVXpLb1RH?=
 =?utf-8?B?NzlEMEZNVTBDRFBCTTViRHpDdCtwdkJrMUsxVVd3dDhmOWl6Nkg5R2VvUUFj?=
 =?utf-8?B?OVNKaFlHU1Q1REVCWENuK2pKMGduaVdIUlNwZUpvY1E4Rk1qakZQMXdTcTFr?=
 =?utf-8?B?RklqVFlOWFo1ckxSWVM5U2dkYXZjNnAvYTN2VE5Xc2l4Qm91eS95Q2J5dkor?=
 =?utf-8?B?aURVU282T1U0R0xCcmVhdXhhTGhzUmd0Ym1ISi9ET0J4Ukt4aWhveE1Cbkd1?=
 =?utf-8?B?ZXNBdFJub3JKTTVWS2RLcloyWU05RXEwTTM5M21lc3RuMEE4anNIT1hRckZY?=
 =?utf-8?B?cXM1VlEyNmt6WkMvMkZxUW14Nnl3K1hnNlYvVkFMbFZaQmdBY3JCdU81Z2FU?=
 =?utf-8?B?STZuRkZjVWZOTjJodGw4Q2VWMHJna2dDeUtDcmwyeUlZTVRaVzBsUVZWUUdy?=
 =?utf-8?B?cnM4dkpnLzBDWmZpelBndTRXeVZHZXozT21mWXVNYi9CeUpIeGw0eTJkSjNP?=
 =?utf-8?B?V3lmYjVmcnl6R05ucldGWFNjMVZPWkNaSDBhRkpOb1NyMWVYSmQ3alh3dkdO?=
 =?utf-8?B?L0VIN3QvazRNSTNTTExZMkxOaTNUOEQzWVpLNjc1Y3NjQ05qY0c2VERYMTBG?=
 =?utf-8?B?N2pleTN6aSs0Y1drT0lBRXJvM1pNa3ZWRlV6dmVqTWpHTFJNZDFuZUlkcVBr?=
 =?utf-8?B?Y216dVJCZmhIQ2lvcXNNeWJwQWhUUTZFemdqQmN0elhCQytvcTg2VC9SdkJD?=
 =?utf-8?B?M1dOQnZlaGN6RXFZTXpuZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d295NDhZekNQblF6ZkllVHZzbnoxZTd5R2QrQkJCWlBOT244aHR5Q0pBZmEz?=
 =?utf-8?B?QUwxOUZkRWxoTzV1emZ0RXh1WmpvRzRwZHVsMHpaQW55VHcwNWtVVmVXTjdY?=
 =?utf-8?B?eHNXNzYvbUJJb2JJaDJUOUxTREpyK04zd0V1dXU0OHN3UDNHOGFHOGkvei9M?=
 =?utf-8?B?MzhhRVkrVnR3QWxiemJ3STd1S29mT0N1a0trM0g3REhBZlJmQStockR0eVdi?=
 =?utf-8?B?S0tUNnZGbGdZQklzTUtYd2Fqdk1LZGFlR3pHNjk3ZzRDeG9WMjlHTHJkOXFx?=
 =?utf-8?B?SEtnWkMrQlJWemNhTXA5Zy9xbHl6d0RhRndUWUxDK0xibjh1WW4zU3pJT0Ux?=
 =?utf-8?B?MFpVbm4yaytrWGttRkhVVHJMeTU5Q1pjTGNmYjE2WEk1bzEvV1NLenF0NGhF?=
 =?utf-8?B?WW5DL2J5eklpVzc0bkRIaW5HT21QQWdnVWV2eWpXdmZOQ2dJYVdOSzRpNmFm?=
 =?utf-8?B?RWNpSzhKeWhHRDR2SW5WbC84MFBESmdyenQ1aDcyTWt5Q3dNWlFDOVM4Zm5J?=
 =?utf-8?B?WVBKTm96aGZmRTdaRGZ0MTJ3Wi9sNmhIY0dTODUrbnZXNlFiUzd1SlV5WWNP?=
 =?utf-8?B?UnFobTdremM5MlBGSVZhckEyTnZxTlg4OUJEOERlUW11eEFEL1Z0Sm9KZnRt?=
 =?utf-8?B?MGJJeVNjVVFPc3VvQ0dVNzJhRjNNdVE4MjFyMGhQTUc4dDdsVC9OODNaL1NO?=
 =?utf-8?B?bzZZTytGVlN5UktTeTZsdWFOSWZEU3VVR21INlZZNjJ2V2ZBSnVucUY2dWNX?=
 =?utf-8?B?WDhOR0prTWZKY3l3dC9kWkNWbmNzZVJGYVlXQjhIZnZ4dzJmTElLUWJhSi95?=
 =?utf-8?B?U1JPNkFUVDdOSTBXbTFmdld6KzJYUUlQczZ0czlFQk5aMTNzTStmWU1qVDVS?=
 =?utf-8?B?OElRM2FSMlFxb3IvNnFWcHFhekZlWTBrZG1kQVZmcnBRanBzQVFNVkRVN2xk?=
 =?utf-8?B?c0lwU1E3UTRXb3RqNU5uVnY0M1J5RFI0VWM5Wlo1T094TnJ4L3Y5cnlpM2V1?=
 =?utf-8?B?d29NOHhWRlR1RDhzVHlCeFRXTEZxbmoyQUR1Mkc4aTg5S3VWNnBqVXExR2hD?=
 =?utf-8?B?VWFDTjFzdVcxZE94ZUxMSGhqbWVveDF2TFhCOHUycWYyTVU0ckV0M1FTRHhU?=
 =?utf-8?B?NFErenhKelQ4ZFBNV0JtcXNyWWIySVF5ang5UzJLM1ZhUFM0bGpMWVNOSGdD?=
 =?utf-8?B?UXl4VXR4aUx4NENTTVovTTFZNVRoU3FpN2RkWjBEc0FkRVZiZzlweXdoVWRp?=
 =?utf-8?B?d2hsWmlrQUFPcFJDRDd3Qkp4ankwWk9rK2ZOYnRWREYxSnZBcGNWUkt2VWpI?=
 =?utf-8?B?RXJhSXpuclZVVlhGRWxVdklQSlE2WFpYM3BjUlRia3NqZnlCNWt1bUw1UXBj?=
 =?utf-8?B?ajZHdHlhQTZnNE5mWWMrWXc2WElHNnU5R3h5azMwUkdlL3g5NXFFQUJoaGpK?=
 =?utf-8?B?emdOc21JSWVWeThPWVNNaTFPR0l6c0xLVjRRaURia0MyVDRjcTMwTFF4NzRF?=
 =?utf-8?B?OWdmd1FrTlBqTk9tMjAvMjlxMmZhR3VocUpxWUJxdU9OWUEya0Q5WWYwNVN1?=
 =?utf-8?B?VjIyRWRWK29lQU51aHhhenRJck9ITjUyV3VMR3pmdmd2bk96dm4wNnR4by9m?=
 =?utf-8?B?blVQRVF4U0tCeG9RWGdHRnFZSTF6N1M0bVRuZGhTeEdYSWFpZVl6WWwybVo2?=
 =?utf-8?B?K0t6cHZLNzdPdnN4eTNTY1hWVkVHTWZ1cUpSRE9PVjAwSG1hMzBOcEVtL0V1?=
 =?utf-8?B?dkZEQ1RDaFZhaW84QXVkWFYwbjlMMWdmdVYzanI2V2N0SGpkUHZLU2kwWmRj?=
 =?utf-8?B?dGlNK0ZNM2RuU29yVTJEaHB4SmxqOVJUdndQNXc1aEVuU3NiK2xvL2hTUk9M?=
 =?utf-8?B?RkhZOEVTZXBjWEFqNUk1bXhOVjNNN2hac3ZzRWlzTnZOd1ZFbWlqL0ZXeklZ?=
 =?utf-8?B?L0ZBWmR1M1RNRmc3Vk9Hby8yR0xIcGx5dkxURnVkbXU0NVdhc0xlMkZ3QnhL?=
 =?utf-8?B?SDNHYnhjNDV0NnY0MGtmVVhoSGVJMW4zRTJFb1Fpb1ZMbks3NCtWR3N6c2Fz?=
 =?utf-8?B?bElzTWJ5Wk5ITEEvczhVNjBJS0QvL2hQbGhBRnBkeER0dkNTdi9QRnQ1ZUhw?=
 =?utf-8?B?TDVhNE1KY0ZQeUVtd3dVV1FpeWMvSlNKQXRSU2hidnJPbExJM3RVNUoreUda?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5Ost4X+OO9VqbAA30yue13bU2WG/rT0xYqX6zncVS/cMRbaMJmuv4p6wcqODogD77CO0biWDTRqS9rRy244FG4KByZbx/Zmy58Dysz+z0EgnmwSeiLIYqPGmgFQjZFrc+E+Bv2Ku5MpZuqXa3nFDRy34aPWeggMRMMaE0+RIAwKeDq+0CQ8wCArqbu5VEGejtnRYA0/BizF4QcIPn6IfDyl+6E0Jhk55VchRtuoenszIwtBEzLrtxKCarPN73RgqUIfpGqug8CiiU9ZfNrTXrH/KAWGQFXTJw57pqElrSnqPT+v7aifo3s4YvxcooNitMLT6A7QuMhs8tV3PPLy2+TW1b7VCZSHg9427/PgESaAwO+L3UmrkKRJD1Vv14BVdaByadLtKgnElz1wSntkfgDErjyxwXLyyjegPd6Me8R1O7OjiTZmP4a+9kaTYGoV/BKy2JxOsqcSh7doz1/pAYZV1sxHRy9mgfXq7viwgB9qkSHd5M8TvVWpzl436cn2O4i400E7KEqMwbyDpWdVw/5zWvvCCpkcuGYB2CNqpmYOGNU1Wqq+Myn3hXHFSEfO4HI9dEc2c+0VhBnj9XMIDrASyMv9gC7OSdxJXZNM/MYM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b70aaab9-7ae0-4d9e-6ecd-08dd70ff111f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 09:24:56.4819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2rszCkIl4feICMgdrEYRrrZtwOV+kTrW8KnbUSEGXmEsI4GwwJq7G2+2F/iaNldp9q1Tf2pGq3S/HeRq+LY3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8075
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_03,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504010061
X-Proofpoint-ORIG-GUID: SLWvlJ3wxeSzrKoBpwkYHQ0IKac_G5W7
X-Proofpoint-GUID: SLWvlJ3wxeSzrKoBpwkYHQ0IKac_G5W7

On 01/04/2025 04:32, Jiangjianjun wrote:

Please use standard mailing practice of inlining response.

> On 31/03/2025 04:10, Jiangjianjun wrote:
>> Sorry for late message! I'm working on fixing and testing these issues before re-emailing.
> What are you actually working on?
> 
> It seems that Hannes' "scsi: EH rework, main part" series and maybe this one can help resolve this following issue:
> 
> https://urldefense.com/v3/__https://lore.kernel.org/linux-block/ 
> eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/__;!!ACWV5N9M2RV99hQ! 
> OO5I73jOVLARfumNZnn0L_cNWCWVmFHmNuzz74pUu12bSxsb7F1wQFuTJBCzEBZrdDE8cqBRf8e_Ddc4AmrbBgdRq9I$ 
> 
> with fix attempted in:
> 
> https://urldefense.com/v3/__https://lore.kernel.org/linux- 
> ide/20241031140731.224589-4-cassel@kernel.org/__;!!ACWV5N9M2RV99hQ! 
> OO5I73jOVLARfumNZnn0L_cNWCWVmFHmNuzz74pUu12bSxsb7F1wQFuTJBCzEBZrdDE8cqBRf8e_Ddc4AmrbVJtRc_g$ 
> 
> so that we don't see "fixes" like:
> https://urldefense.com/v3/__https://lore.kernel.org/linux- 
> scsi/20250329073236.2300582-1-liyihang9@huawei.com/T/ 
> *m80bcb3f57fd176b7ce41b1f26e8560de6ad52c9d__;Iw!!ACWV5N9M2RV99hQ! 
> OO5I73jOVLARfumNZnn0L_cNWCWVmFHmNuzz74pUu12bSxsb7F1wQFuTJBCzEBZrdDE8cqBRf8e_Ddc4AmrbNUtxBIA$ 
> 
>> -----邮件原件-----
>> 发件人: Christoph Hellwig<hch@infradead.org>
>> 发送时间: 2025年3月20日 14:06
>> 收件人: Hannes Reinecke<hare@suse.de>
>> 抄送: Jiangjianjun<jiangjianjun3@huawei.com>;jejb@linux.ibm.com;
>> martin.petersen@oracle.com;linux-scsi@vger.kernel.org;
>> linux-kernel@vger.kernel.org; lixiaokeng<lixiaokeng@huawei.com>;
>> hewenliang (C)<hewenliang4@huawei.com>; Yangkunlin(Poincare)
>> <yangkunlin7@huawei.com>
>> 主题: Re: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce new error
>> handle mechanism
>>
>> On Fri, Mar 14, 2025 at 10:01:40AM +0100, Hannes Reinecke wrote:
>>> 3. The current EH framework is designed around 'struct scsi_cmnd'.
>>> Which means that the command_initiating_ the error handling can only
>>> be returned once the_entire_ error handling (with all
>>> escalations) is finished. And more often than not, the application is
>>> waiting on that command to be completed before the next I/O is sent.
>>> And that really limits the effectiveness of any improved error
>>> handler; the application ultimatively has to wait for a host reset
>>> before it can contine.
>> And someone needs to get your old series to fix that merged before we even start talking about any major EH change.
>>
> Sorry, the previous engineer Wen Chao's work has changed. Now I will continue to complete this work. In the future.
> I will analyze the details of the solution, improve and refine the above suggestions, and carefully submit the email.

JFYI, IIRC, that "scsi: EH rework, main part" or one of the prep series 
may require some form of SCSI reserved command support. Niklas raised 
that point here:
https://lore.kernel.org/linux-scsi/Zyo-E1PCvx_XULvg@ryzen/

I also remember commenting on this, but cannot find a reference.

The SCSI reserved commands series includes the following attempts:
https://lore.kernel.org/linux-scsi/20211125151048.103910-1-hare@suse.de/
https://lore.kernel.org/linux-scsi/1666693096-180008-1-git-send-email-john.garry@huawei.com/

Maybe to move format we can implement a basic solution for the concerned 
drivers, so that progress can be made.


