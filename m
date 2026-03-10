Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B9F397E86;
	Tue, 10 Mar 2026 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773158091; cv=fail; b=QBbbJY3/mT1psS4YCxENef3A0BJRqe0jtq/+ziyD68zxwjGF/wc7a0oooQdXRyLf/k472wiDlCR3bM5DCBPMon29ndCW2vqGk+qAL9WlqAC0KQLrGe/zzjQIgq+LHXDuqdrBnyN3knpz+Sc1cxUUuW213IuTPerlI8IaWf3Y6bQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773158091; c=relaxed/simple;
	bh=8WDCjy1+vPbCrgXSYkPSD5ch1LkVUQ0pq5Z39Puq0KQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UvG/4BQTF05TreoIplj5x53Z9im4vzqALM5D5Ot+V7I4FwJGiydUGvQo+p5CiqNZiwUW93g2GvIyOK79ZBkWTxrjms2yofz9LDRuFGEfSGcJMp0Jo3KhHyvMSndZqId+9EhjQAHrfw7yVO93nwwlpDxgVrDNRbM1JiqbdEBrE7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ebYuGHRL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FOrySLYO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ebYuGHRL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FOrySLYO"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AA3VSZ2346949;
	Tue, 10 Mar 2026 15:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KjXU/8aoYF0W/G4cybzgCQPvcIFy5XI8/fCIMMtm4HY=; b=
	ebYuGHRLF9LgP+UAOrkOxO37NG+Ohf3JMd2FUgThNbaAaDuVkcQfaM1nsAdLiKtL
	n2cB/GgqfEccunyONmN6YUpG9tVl+eKsRWGZe9FZXWg3GKpK8u8aor44O8bOKr5j
	1u3qqzacUsqUEJOLpIH897CywGkUr9ljhySNDr7cIQlQ13DCN6d++o5sDjjY44nQ
	MMfq1/ibRpGuHbOWvkz8jQ5RtLdewii7/D1U6zfNBJRHz233eSjQ9LbQpXTWQ3jt
	wVRMGPnH/0KLc7vBtq18XJMq3W/hiQjzj6Rq9WuMRQpBA/iybdWCkDF7t9CEMRs2
	zYqEZBkhC85S5VZ9cE1krQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmmab483-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 15:54:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AFlu61022935;
	Tue, 10 Mar 2026 15:54:28 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011003.outbound.protection.outlook.com [40.107.208.3])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafa9run-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 15:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g7YSgv81chMTe4qvy6E3OupPxgbQbJxZ/xW2aLP6ZafOb6n9LQqXisNskF13V2gP5/kYRmZnzicpC7wNMhjH6ipehTfQyd7D+khrMk3CCiFvvCAcQQQD+mlmJY48ecI/XP7RQt2cEzVo9WFpMbIncmkfslKN/wjPq1ff18RucpDY7A35L1Ecu7EF11fDIxTEyHhrPf+Z72iQsQ7QRjL4IgOyerxmKIFXlhUdwRvZeF6B+cdJCykD8FfEosxFfbROBNMQ8wvsVflFty4rugNmOSJB20lNQ+DGWRZhJM63uIuGcTb986y57isjfN5rRyEpkAOPTdOwqbYqF5A0Hs/CKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KjXU/8aoYF0W/G4cybzgCQPvcIFy5XI8/fCIMMtm4HY=;
 b=UvNylmJjEY018uZCLZ+T90ZshgaAuAe/vsai4fID2J0T0hJIWcRQCGnZM4ZiSY0BG8deIFGF3S8BOw7oVGmvVpc3+r7BtZ611oXbknELr88APEoPPpctqnAhXXx6J9mdyTqlWDkzptW6lVenLQVsTybBstUFN0pftpc83zpH5ZbkhS1iUPoUVuz0CAA6HG7SY8/JOT+Yo/W/3LCpybAmkAMIqZR6NVSiJjmIXvsixzJRJY/qaGt8vFvJtC2iyFA9Bx39YXQIb8yYx0yMFQWCn8fTvAYXQg5qtmRPPO/5EfTxz4ScYsZg3jWXWHUc320haofhj5jfiTgxC8pnn6KHiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjXU/8aoYF0W/G4cybzgCQPvcIFy5XI8/fCIMMtm4HY=;
 b=FOrySLYO5zFXW+mKM0v0CTQvz/yapg/rm6fW/c3RqNfwJUf+M47sciEU86Qq0tPFvEoGaIIQwZwWFobsulzHzQW9NgoB4+8nFLkblgnGtMNEm0N/MolzEm/sICPSqq0zRvMRLE8DDOv1N7HTX4c5LCNmo4CngbEMAYOPsyD929g=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB5736.namprd10.prod.outlook.com
 (2603:10b6:806:232::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.24; Tue, 10 Mar
 2026 15:54:25 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 15:54:25 +0000
Message-ID: <0b5cc8e5-9e20-4675-8600-5c265fb2744e@oracle.com>
Date: Tue, 10 Mar 2026 15:54:14 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] scsi: scsi-multipath: Maintain sdev->access_state
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-7-john.g.garry@oracle.com>
 <c7a62f70-8a69-426e-9947-d2363a124583@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c7a62f70-8a69-426e-9947-d2363a124583@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0045.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:58::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: cfbe6906-b07a-44b3-0524-08de7ebd4df7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Io2CHCyfQlW8Yv0UNrxfKb8qayYAs6Ojml5PCrHa9d19WGqiH/937uFWkFcG0Ft0SELtosyWNcWWfAa5NpLR0rljKqD74ApNHNAvDzChl5LPGPqhYLROroeV0ZOCy9DEeJ1Vgd/DSMniWxtMdf2SUPznjsrLFQZAilx5n+TC3SM6Gw7obMfgXqswpjWxrXq7pHcpoV8UA7kcRhq1kIEwZD2jhnjkn5/rmu/0oLS5P/2PYpJDUVNJuj58yCOnwhvGN2N9Bkxg2fmAkr0figCo5dploddloYT2YJEDM9kE4J5wutfkWv9sr6kr6bcfnHFhHFAhR6jyyOs/vHAXG/jahkKzO8SzGqNcoKlHZr4LyKnR+NXjkF95GPBAvprpni2SYTSwaKCeBpBFLPA5wW7zsC6OIO2kvcMScLq16A0ppyBvbJ1PoDWr45udycbKSAWsertIOvdzjDE5G1lu4CFqfwYO8kA+zvjUPER7H5uTa2UwgsKphaThYO1+SxwcWZ9AT6R8OaKyTAQqWqIoiR4MbzGIr0DjyEKkS6JGiBsnzKVMXIb8/PFRD2fp5AsD7xPTE2cvB85/UWvHl8Qd2yZ2iNEskAsfdOTIavWNQnPbIXjiHf2W0WnGClABQRjHdMxBuPy2XbKs8JJZVVtVCSLp42bN903Hi98t1VY8rXNBLgbEvIvIO1r0VF5cY9tFPEtMdtz2WWC3/Wh88da1o2YqqCDGN/HIaNTFdMUSUf2UWbw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2RIN01CaWZuYjZ4NmFRMUtDa2JDKzBuOFRTWDV1c3Ywa2RLNFc1VEZuUFRl?=
 =?utf-8?B?Y1VPaEZUMVZyMGd1WkdBa2J1TVJpSEpWRVVqdWNSL0R0Z1pjTlRKQjF2di8y?=
 =?utf-8?B?dzNxWXNyTjR4aXp2MFlsUHg0Rk1aVUlYR1VFSm1PdDlDL2JJOG5OcmU0M3Np?=
 =?utf-8?B?VVBSbXowdjRobDQ1V2g5d1psNlVXYUZ5SWFYaHVPSlV3TjRacGdENzRjZk1q?=
 =?utf-8?B?VEpNakZHa0ZaZ0s5ejJHbStKb3ZDZ1hTNmZ2eTU1VHY1UWxydFdONldmMkNH?=
 =?utf-8?B?Ulp2dnNlWW1xbGIwWWhJeXBwYXlBMlpoSnBmSG1EQ2ZjaGhhaEpHR0lPb0VY?=
 =?utf-8?B?YzRxdWl5cTZzM1Rsbk1iWHhPeC9ROXpLSG11V1drblkwSXk2WlN6aWlpbzhK?=
 =?utf-8?B?Tm04Mi9PT2Z0V3ptU1dRL2lWK2lZWTROeFBQNTdyblB5R3BiYUtXN2xDMzY3?=
 =?utf-8?B?Y3ZNcDFCRWpocytXdzVQbUd1KzhkUUZndEhZbVl6cFYzQkpZU0JoYXJYaTZr?=
 =?utf-8?B?T1dIUHllcTl3cDVpRDcyc2dMTmRoWFF1czJudmFlOTkxUXVxVlpveDMyNW44?=
 =?utf-8?B?RnNsSUdUbGdNV090NVJDd3NzWnZPSVBLSStESENZZ1Zka1BrRWNqM1BycDJk?=
 =?utf-8?B?R2c0UFUrMEg0S29DWWpsd3dDSWExaG1WSUgycklnTWYvakVIVGY0R1YzZ3VE?=
 =?utf-8?B?S1pLMHVuMUJQaytybTNWTlpQeGg0WjRBdGgxNmJZNXRXbU9ZV1lVVXhNWCtS?=
 =?utf-8?B?YjJOcVhuVCtIRGF1Nys4Z0I4d2U3NG5tRERqbjhpaWt4cHpaNURRV1pueVJ5?=
 =?utf-8?B?OFIxdzc5RWlpSHlsSWg3a1JIRk5rd1cwOWJXMWd4WEUzMEk4WWV5aE9hNWl5?=
 =?utf-8?B?NFJBWVQrc21Fc0psODQwOFRmVlV3R01zM0JZQmxURFB6dUc1MzFadDNzWDMy?=
 =?utf-8?B?MzMwdHppb3ppYkxUYkxza2JFaWphR3kzZ3dpamVuTUphWVFmOW9mbm9nK1JS?=
 =?utf-8?B?NUtqS1lwMlcvd1JwcHBqK20vOWw5YkphaU5KQW9VckV5MndLaWtMUlB0WXRE?=
 =?utf-8?B?dElxUUVxMzE1dXR5dGpsMVVISDV1RGFGcldVZCtTNWloYVkwcFJta2REOWI3?=
 =?utf-8?B?U21FU041QnBPb3MybE9mT1BZNXFTUnp1K2RtaG13NHgvYmhIRVhDbTJnMnRk?=
 =?utf-8?B?a0hiQlg1VzAyQU5qRnBkWEppQlcyQXpjZEJSb1RVMzhTbGxIclBjdXMvT1RM?=
 =?utf-8?B?aEwvaC82eGVkR2I4Z1NQR2JFa01TRWs4bXV6T0ZNRTFxaU5IeURnb2xEYnp5?=
 =?utf-8?B?TzFSaEN2Nzk1aEhwejFJK0UyNExkVTh1c2R2MUttV3BTUUpvK0RndzMyaTdi?=
 =?utf-8?B?aDJTdlhNbWhqTEd2c0k2eGlTTmU4a1owaTlqZDAybEdMalhLS3FLTEp3dVRz?=
 =?utf-8?B?R2F5azArbjUzSG9CZnkrZnBvdko5ZkFxbWhTNVdmSzcveTkwNTVYcEt5ckxw?=
 =?utf-8?B?QjZta0JCTERJNVFkVElLNzFwaTd2c05sTVgwM2M2N090UkxlbnRhQjJ6ME0w?=
 =?utf-8?B?VXMrM2VHNXZ1bDFiTVYxOG01Y2xCNlM5QU1HNkVYVmoyMXU0Y0FsdW1RNGRP?=
 =?utf-8?B?Ri9rTkZGYzZ0Y3h1Nm1zaGtITmthNzU1d29Rc2RITUpGclhnSUFUcWhGdW9V?=
 =?utf-8?B?ajh0UGRRdVFBcFREeFdXdDUzWDIyeWF1MzFjRkVDRUltT2dMK3BpV2taalBr?=
 =?utf-8?B?VkpPd09MUnJxdnVWcmZtOGtLenEzc2dsblp3Y29lb2pNbGNpT1hCM3BqQzN0?=
 =?utf-8?B?TXc3cEF5bll6MnptbXZaNzVVNVQwVllDaTBVZzd4Q3d2aDBjSkN3aDVPc3NB?=
 =?utf-8?B?enlQQm9FV1Y0cnZCcDMxdEV0d1h5b0I5Nkc5RDBNeUVTOFcydnB2c0VVelJ2?=
 =?utf-8?B?aE5SakZSb3JLYStiUkQ1WGEvSHgxbmliOFZEaGcyMTJvODh3R2RIZ3RHcnNX?=
 =?utf-8?B?Qnp0ZkVKSER5RHVYZnIrbXF5SzJNYkNUYkdyc3kvdW1Ma2tLU1BuVUpLSm9W?=
 =?utf-8?B?alV5c3NWYkhpUFo3TDBxdW1DM01FaEtSclY5bEVXdnpwTzlROERibWxSdFNP?=
 =?utf-8?B?Q0pFdUovZ2xwbk5BSTJQa2JxMXNHTlE3czRwSGxDSXVCN2pYTng0cGtkWTdh?=
 =?utf-8?B?WmtPVFBEN1haalNQUml4MEpnZlBvNGFscjJmQks4QUJvWVZmZkRodnhVMGZ4?=
 =?utf-8?B?ejV3U2R1WnZrMW1DR3g2TXdkVzR5dXMxWUdmLzBsb1p2UzJ0VnNRbEpLalRK?=
 =?utf-8?B?Yk5MU1AwL1lmUHUxcVJwWTdJUTE3R2xVQ2NkWVB4cUxwaVVnZWE2U2dqM2tj?=
 =?utf-8?Q?heCQa5YHxTJtHbMU=3D?=
X-Exchange-RoutingPolicyChecked:
	FHS4IsxUwdndWSP7s4/U9Xtn8sWDjuo/YkXrPAXhu4tk7AcIuyClAWYgubXwfjE/Atg87iVcT2QERyQSC8M546RGmjLf5E3rc8cC0+pub5y8h4XKH08Eu1TTeLSx/4DpOrvw0Pk5UBzIibOTQQCXjDeTl3QhFkTbRpP46ptbQNFntmLCK7HxwFubpKHvqvUHPB4CbRIqlKX8KsyVRjwqs+AxguRj+h+Qnkcw+v+Bw+mRfeNMVDS9fXjP8/6AUy3yQGDNu9rF10Bt/xKJm5xHidoLqVryxChrjdRSKcIEyuwao1+2bu0DTNxchkPJGQLnf/22l+PwFTxfcOmNkIvYzQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PrZEmhIVhO9FHvwVKMXm6hGMIVh+NVd0ZvllGJD38FCRd9K0sN0HBxHjQVg/lB8F3s1LM6+9yQgbiSqWYhP/pFBT7cpbjneqWItCz7/Tu3kBLEMN6xJh2NuQlSiC55Pm3xd7sW68YPR4Rddofiaabheb36LrQCveAlRfrfW3UlfhL48tYaJ8FeyzkY/Yjq8WE27ZC4YtiEVrfIhrrgLBc1tvf+Z7INAGfEhe160R3mB4PEtx0feV166NTa2MT+WT4TGHNEYPSOJypN5tcnZBiZq6osRbFBE3rSE9n1+UDEPoSte3PiFX21NdliTF9w7NF6cPWISdXK5JdpVp/Bm4fgfi4w37R7nfXFn1rlr9Dokw7egHGqXItlH8H9RJ9UCNCGsZ+hrb+pR0Gn2N9eQNRtJo0eC38Pjmwu7HSLMgYRQ0IzZSynoxMBE6uDw4NZiT0fRV4tHB2tAZTAqeM032QUeaSB5Ds8uyQLBahZzZJaM/PVwLnjzJVdt27lgw+CZcb5QL4Nic2gV+IueXFNvwDU0Dxchn2wrciQEG10NvRmT0ALGJNGRCi7YYgDC0NkJrM4Yh67uuDXihEwrejtuR9mZ1aITXVdAUbepKhj3RpY4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfbe6906-b07a-44b3-0524-08de7ebd4df7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 15:54:25.6570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oEgUuu+By8CGQyGkUHt9zj+Q9Olc2R3xWQO9I/4jzB9askbZS1lbJSApgQcQJYiJkAYQvtE3KY/XaVRl81dxWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100138
X-Proofpoint-GUID: BKZiA3r0yN5hXYVDTPiaGkEZyCXl48X1
X-Proofpoint-ORIG-GUID: BKZiA3r0yN5hXYVDTPiaGkEZyCXl48X1
X-Authority-Analysis: v=2.4 cv=U5efzOru c=1 sm=1 tr=0 ts=69b03eb5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=MLt4-geCaH-iqpmB4-UA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzOCBTYWx0ZWRfX9fiT8VmbQkqB
 jX/JrhdF58vKA53WJp07DAn+B2c4pv7/r9tlRlHATgOhAOBTkX23Bf+CWk2ycSG9dZUrD7zSuV3
 aqLTdC/bpmsiI992P1fc650GkodZnQLpFMdy4yBx/yCnBLa5DdQKuMi+srukiYy0lGiBa9W09rm
 WH6+j4pnkG7FcNfNn8WeuaNwyLjHRFtBewe43PRPU97P3ZPBhJiqavrQ4sESQBDudjZI1zfniRU
 NDhPWzxQ0HjbJzFytM45fZeCI9jVixASwnaH9GQqPEgaLKmZ6uq3IUZNsqy91bMtfgXo1trv+/r
 GSIdx8tVVeP1dUXdqagAy6qMmnvzZINnWyjFXtxFft2nRBBnyYkgFmcZNYlwZL2CbK69F1naGpi
 ZKuFFpRQ7z3GgOgSQU0cidsJBWjsnwGnNPtPQh8HGBYq/m6iBK/hfr8OzJh0igrCbllMI11v308
 N9g4M3gAkNE21jx1ovw==

On 10/03/2026 13:27, Hannes Reinecke wrote:
>> However, preferred_path is still not maintained as that that is related
>> to transitioning  state and we do not yet support that (for SCSI
>> multipath).
>>
> There is an issue with the preferred path in general, namely that it 
> overlays the ALUA states (ie you can have 'acive/non-optimized' _and_
> the preferred path bit set). So it only makes sense for explicit ALUA
> as then the preferred path bit gives us an indicator that we might /
> should switch paths.
> 
> If we restrict ourselves to implicit ALUA (which I'm advocating anyway
> for scsi-multipath) the preferred path becomes rather pointless as
> we cannot influence path selection at all.

ok, fine, I won't touch for native scsi multipath.

Thanks
