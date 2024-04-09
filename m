Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999775464A;
	Tue,  9 Apr 2024 02:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712631530; cv=fail; b=caBiRIoZnd5h9tpHIS1Qjo4EgMg3vd1W0+UETiJlToySobGSx5BKWJfEED7qFWSfKR5vaxZNY5rUZEbzBptWnxJ8XNla6/neYkvzSSjBi10sO9Bv10kFdLU49xioXnh3FoRMO1cte4wOXUAxzLdEcZe0acedVziA/H9cclyOlA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712631530; c=relaxed/simple;
	bh=2wnTFgMdg7Oe+pgs191U387G/YWhp97kRPM16idReuA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gq65djM6UKWKStjGIlCJ/sXKAkdu+k8QOk251nBLAEds6IoiMnCgn/VAjtIDQ7bNhsaxiRcmYM4sTtULtmyQi3MmwK0lg+f4+szgThJNHk3Bmo1Qxp0Qm9izwZ18O3cD6MIukmO9EWYGBkZ/bgkDnE3UAUVgftjFc7Q8AE30jf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eocXQbk1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fAscA4ge; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eocXQbk1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fAscA4ge"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438Lmwlf018610;
	Tue, 9 Apr 2024 02:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=5J1UBsxgGIEx7dcEv7FXYoe35liVY3DBMvQZeXkmQLI=;
 b=eocXQbk1XPp2Gef9MU/vLr+yaC4qBITVvPqAHGi8aye5+GkaGTTADXM5vvuOn7jrXLfv
 /uUqUvpZn2kLf51tFgokNNQDdraOYLhNnpi91Ld0gpWyZy4XesrpZd5fOHLb49ne6qWh
 r3HHzqKpwTvnY3zVGRHZxaglBsMxjzC9/2KtitUrZyOhitdzZWWRq/0sQBAwevzTzKTd
 KrEbm3Vs4w89Knb53X1amlyeNFQitF0M5+BchqpP93hY+EyzCIeGi+r3t6vDFVCqZHU2
 HQS9nfbou5kSnkA1ixTSos+vlHzbC2QK1AdNm0TkSKrrPBi4eHU1MYRYFP7zfvZSWbi0 Pg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaw6445n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Apr 2024 02:57:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4391AD0C003080;
	Tue, 9 Apr 2024 02:57:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavuchhem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Apr 2024 02:57:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8HyM4gZG5CRpEjHMJJvhpH0S1n1HbqezXZ27qP1tOQvM7XkqA9LbLgzJ3AkoWSGramR78UqyUr7iwTadyoUOlges5laMU8kWa9CuY2NxvM8ZATcsW+W4DgrAzLySGEqkSfJ/sqMydM3mC73Bhp7P+eyE6qV6Vk81vQ6W4gjanlEv7AOORBwsY7NciP9SvoSCNzNW/paZBUCDhznXJB3d9ggDXpPMjqoHWL+TA4WHnwQ5qLnU/Vn2/7GWmZGufnY4esuSnViXme342c82Kb8m6GT4YXF5FZQpv+kID5wvrXUexWpKa8Q8iFs1GasEk1WxF4qZXhy9uhAVNj13H83LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5J1UBsxgGIEx7dcEv7FXYoe35liVY3DBMvQZeXkmQLI=;
 b=n4CvGIHM/VZtigvdrmpPHj/qHwaHTm36vw+9FG4JYTVj5uJoDVymofNyt3gIfUWe0rqQ2vqeuKsRFC66W9gZxOGdcdLCmS7bWdW4b6uG6mLKVTkLFAFIC5qwDsSKg8XSJ8A1qBY3MlaHOrXauA6PO+cLdnJOCxuP1LmRXh4Jk8Ls6l31hKxVY3n/G4siNjw+CzTAGWLh2uHJpO8OwhiXySbiYkphTQ+9ahobZoPhEcI2SbTEMWHL2GbNoZj/achyBmdriBJ9Pj6DkOk5HPOaJvD9LdKqyVHRJXriUICMxy5GZOl1UZsK+QEkHmZiKFv/iVCi9HxtWMNqomaAoU00yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5J1UBsxgGIEx7dcEv7FXYoe35liVY3DBMvQZeXkmQLI=;
 b=fAscA4ge7MAW1TZtIIAQlZumqc4jFt4b7+ftrRYCAJweYIR2nV1LgtKV976uRwBX5ZLcfVDCZvYaScW7CRe1RWus/+sYxJqYLY775KbIfouxS1gzwyjdc6tEO8IKC0Rv1dJcHq/yOqJK3dAm7WuDYGyyPJO6djmpxGPdFOhPtBU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4746.namprd10.prod.outlook.com (2603:10b6:806:11c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 02:57:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 02:57:47 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Takashi Sakamoto
 <o-takashi@sakamocchi.jp>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "Juergen E. Fischer"
 <fischer@norbit.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        HighPoint
 Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler
 <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
        Lee Duncan
 <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth
 patil <chandrakanth.patil@broadcom.com>,
        Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alan Stern
 <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: convert SCSI to atomic queue limits, part 1 (v2)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240402130645.653507-1-hch@lst.de> (Christoph Hellwig's message
	of "Tue, 2 Apr 2024 15:06:22 +0200")
Organization: Oracle Corporation
Message-ID: <yq1jzl7nt40.fsf@ca-mkp.ca.oracle.com>
References: <20240402130645.653507-1-hch@lst.de>
Date: Mon, 08 Apr 2024 22:57:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0002.namprd14.prod.outlook.com
 (2603:10b6:208:23e::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4746:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	eDp3IBdSTZ4O1zNFmFDtDSqtDXsHXTMRtQIvQlW8F5NH1m8MZDQ3BxrJOQ2Z9eH+yF6qTcB4nToEFTTRw8M54xxAwoJKiekNaYRQi2oN73m+u5r7zvQNJpl7cIX2nTCcxaMJWsD++xaAgIKXVmpeJ25zyjgSb4UioZ2V0S86qyINXO0VjeXUCgh1yt6H8D6+AbjXn6hGlFMcKsyF7YXZPZqcGhXkG593/dmVxh20tYmzcpQiVwbIRWKB8eMo2tiriqWvOqCjAG2++WaDiuJttKM8oNEynwujuzA35/cp0DPtyM2oZdklKIKzkipULdjlFmowf5tSOXq0Fqh4e3AGOh+YWIeMBKWvd2FdttmiyPJYTrkPrFl4MZVO2WhoYcFXY0OKWo7DiYBtEJDjeKZTG4nPuC+/VO2AUZpAYKGF9gh+7lGAJ3HsTDx0Yw7QqYdWdK81NpvnLctqcG5ZMd+UcLqE6fAKCMDYUFca00gBg1fuov3pOBeChQdyaSQukAnMg+SMXacEaGBRKVRaDhZofu+2tt9dzVGp55/yseHG2lmFbDujyepSa+NXxra8TtlP2pmvMtIeGsFGklSfuiVJOp4QLgqpDfvtMjZHrvZSPD+CLS64VHTLCcXRr+SQDrHZEzcW99NffvZPYBF08qIUjyPTh8FxXthOEnVrAne1ta4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8sroKBFLira5qRZt862V1katRD01G+TGH045+mvkY8P+qwqbVd1+LibYz+uf?=
 =?us-ascii?Q?2sCPwJCiWne02qaRQSJqxAMQyQRSPPgSBrKUAhP7QzNEtBaCunsPxDy5MO3W?=
 =?us-ascii?Q?CEbjWB/M5Wjr+tp08xSZXGynlwVJYKR++sq6buQTk8ftC9FaKWXpy7iW5GOM?=
 =?us-ascii?Q?jG8U5a9ghrjW2IaOJ6r3yg2FZQ8q7dW61a0GJZk4ZASNsVr4Yn5FdCqxzadF?=
 =?us-ascii?Q?0uAGLZfJpBoS7wurl+r4SHcXL91wZRW6WFlDPmW3RfhGRnyv2+e2OqcLbLOS?=
 =?us-ascii?Q?yPC9lPhczqBfLaPO5HrHzVGy5DuGUxvB/LHUtNLkwqSYVlaDYOnW14xgopVJ?=
 =?us-ascii?Q?DzVs1FvR2tbB3NA8eL+YLz+s3hIVTwwm6TXCVW8jwVQrj8VO/gsQkFa8jkQY?=
 =?us-ascii?Q?ADKHC8pFYmnGbits0F7efQgD8T7TKe3+HYz0bjJxgs3RwkiQWQH+jXpC6drO?=
 =?us-ascii?Q?CAO0pKnf/5PvTERTnMqVPWexF0P2qUrlK4Z9B7Pp7CRypI94mVI0YGLuaYWl?=
 =?us-ascii?Q?AP5ZCF+fSJGn2ahZuEFuF16xBoIaSKp/SIEx1afDupGC0dycvG2ahCGzC9SY?=
 =?us-ascii?Q?hxXixeDCkpp2+G7B/hXbBDKtQtWBW5TqfqfMfznxiYUIurng8yDPoyJQbb8f?=
 =?us-ascii?Q?8YkbL5gqqrNZ4VT6grLrl+rBvMxWFjJqiT8FlER9jVOEU0epo9aGhkv1DPHn?=
 =?us-ascii?Q?XYrLB5rR6+3SXD8JMrAF606cZd8KOwxmLMxIXZ/28pz+heQdG9sbx4fkZUah?=
 =?us-ascii?Q?YOwlQcdgRKQo2ae0bnuBf35f8CXmN/g67sYY7RY6b9zvvwAJMEjMelscdfVF?=
 =?us-ascii?Q?9WhmqAyssfQkBTU0j2cJAxRsAI4A3jdTCY6eq5uEVpWfNX7NhQYoaNDUeTnX?=
 =?us-ascii?Q?Ba51r+vzu4gusgSDO1piQKuM+zf8vzEG7K+QsxDVEq2WA46RLLycU9mzE7lB?=
 =?us-ascii?Q?73CQiMix/Xr1QU3HB6Tl5MYN2c3XmN3PKQqiDHnSqpZh0uvpOBf2clVt4PlI?=
 =?us-ascii?Q?ArbPxwteeHZm8PQnAD+MQDBAHBmRlKqriaT4OcJPo+3alUNM1mfMTIACqfwh?=
 =?us-ascii?Q?/V5E+N1xUL2qrIMpMMdDv/WS+KzvoxEQXRG2CZV6PIOH2z2aTHOgzxltzEWd?=
 =?us-ascii?Q?HOqSGHvAbFpGGX5oC76cL6TASUyhRTHtHyNNUq2NFX5ZdLDxaYt+JSfL5Yp9?=
 =?us-ascii?Q?cIig7xhIpIBYFFHm7F3ujLN4iktbBbYL5jdxZG7bxXudF4J54Qh1Up7U4djy?=
 =?us-ascii?Q?h6pkCRuutOZekfUMfmI+JeyxE86u6b/M9B9+BDE834OC82hR0XBIyV/yuPcj?=
 =?us-ascii?Q?Ia9ofI/jglQmw4d8I0upV9FLoftV6cPKoNRORn38FQHD7U55wjVgMRkQkwwM?=
 =?us-ascii?Q?EbiQNPLre642Fw0yZrpE81V9fP7Q7B/og1yEscCfZRK8Hu+sT07rPn6YJsba?=
 =?us-ascii?Q?ILU5ir/IP+Sdk5SC9qgAfkiUzkIVAgSnY6juuO+mIE1dvwoyjmERPtslXjrL?=
 =?us-ascii?Q?jC1k9V0MuiNGGmfZNTURBy8XkZ69rBo8J8P7G9IRryx8BA0hB3L54UxvRq2Z?=
 =?us-ascii?Q?T9MqYAJj8ofwA6an2XAbdDIYVKIy6VZSq4y8iU9LCVlL82QasOhm6cUfhG3o?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kB6OeUYw18TH24dYq1FxPX+oa6IxMXuQEZvAXEwmJBf8eMS/Pd5c4HVbN1H9c28bJs1v5k0V4EnKK3wrS6+FU9pBH6hc2nmYKKLVpAbyCusACMwCR2BZXQELv66EbyEFGOxAh6UAGkKNOKu1pLemaXJbOTmXfy/1aW12eb/qTnsalWV/3CQbDcCtNsr3OWs+mDrjaB7YZsZdzDLAJ0dV58aM23kmxpFwpa9Y/g5sfip4Bdn7ASYgxRzc2DsO/kXdOYbR8X4IoVH4JWTGx0QWew9Tcb+YE/56xWX7nYyVEXs0wB7t193TBpz3eT0TNV+f9xdYkKXCdBHzBSqbY80SqVzJ7Rck+hENKzGqTykPOBtD2IfUVJZbHfRtpofMhVXnx+IF/loi1GfI9UsyGLd4hh8X3Q/CkoPBFVJnfIOKzzU1C61FOLj63fPSoCsraEwZW3+xXjVKbO/MDyxocORRAVqCnF2f9BmRkf31IVRI7N7H7USwUFVUqVJ+UZbYv+jKqfjqQ+5WuGTvl5aXR27DFtCkG5i9BhvBeFIwqL43KZiGkLTupe/JTJ5GHcrgmQ/QxfG5ohu0qjxfBvPr6KKoRrljgYP1ERWgRPXgtUt1kXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a8edd04-4bb6-4fc9-f5b7-08dc5840d645
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 02:57:47.7473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2HX3g3+kYQeWVeWktTeHHuUVsP4FjnAK7U42pLYxfhfi4TOIbn0RXO/KI+IURuWgSAamdQgmcsIe0ZHhUvjpnN2eItqyOv1b+Wa7VpjveCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_19,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404090016
X-Proofpoint-GUID: OMDxbmlyocRiOzJr0eCa1xEcODEqiHzl
X-Proofpoint-ORIG-GUID: OMDxbmlyocRiOzJr0eCa1xEcODEqiHzl


Hi Christoph!

> this series converts the SCSI midlayer and LLDDs to use atomic queue
> limits API. It is pretty straight forward, except for the mpt3mr
> driver which does really weird and probably already broken things by
> setting limits from unlocked device iteration callbacks.

There are a bunch of conflicts as a result of the libsas template
series. Please rebase, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
