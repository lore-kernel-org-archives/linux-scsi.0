Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337B212F397;
	Fri, 28 Jun 2024 07:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719560792; cv=fail; b=RLMmItPgaplxvgFv1x9Szj9hGCnj1Ey+za5p76UbM5erWehbMql3Ua6244NVplYZ+BbCS+sjW1igat03/R6/bw2OD5qe+NQd50zMrcFR5urvAEe29NbVo0PEv0Y+BCIcwwsW4HdZt64W5/vRGq4XsfVkT8DGABOYINmToRsveyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719560792; c=relaxed/simple;
	bh=yITv0PpU29SsPNIceIx9VBCnUaNER4qwGQrdiCVgMBk=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Nw21w4RlmWoTOCRAbxHcdVOihNowjcLUBifLrM0htKCPkyEtjU6a4P/cSBZkIgwePLvScLC44vn33qZJEkF5zcej2GQBNecP2zG2OVzvU8hSPR9PAiZa8DYePxaDivR/9+/gaVCnG4N3cXrVAoB8l564VDqUQiIKWpNLas+Vneg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gFFe/l3I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oBQWy4b2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gFFe/l3I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oBQWy4b2"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45RKBVLG020466;
	Fri, 28 Jun 2024 07:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:from:subject:to:cc:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=6d/SsPs/d8MOoOQZEbdfJua6LJE5MAax5Xs2aJN+TGE=; b=
	gFFe/l3IiQDa0blRhPGgYntlLUKjAs8BIDY3OEx5W095GEQiv5A9k776EL5dC+hT
	SjeYHPlB6jApnSk3rYJLRkpuyziU12vMf/oHvXPj+NAiRh/4bdbFSIlG06MmM9OR
	MCycwv/fPGZBBgPnt1QZmrSs4SvzYCC9i/ni/HLt5XdFzMiwsVIbcv2V81rrC/ka
	9VdbQsAqcfS64gFrnd/NLTbHEM4PJHad41TjE1GCM/ll/XKM1hcTRGijWlJOFAq7
	HP48rpSYvHeGDZEzI5wG2d7MoQ3hqhwpzLfWqjYVtH41UwnBOxPHCivrKFaPh3Sd
	SyrcYnZHfxC0WY6hIJ36tg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywq5t7qqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 07:46:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45S5goYg017800;
	Fri, 28 Jun 2024 07:46:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2bd720-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 07:46:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbxBjPqcfW7X2JS4JcNBlWnvCuuHohxloLZS255ZEkAbL2Hj3Wu2FzXfCjq6v0DSillk+CUk3+ZwwpyWsxnFXI6gmO8lAY8D91FFhLU5eC8XSu0qsX57AEvDg8+edwauPhu4bY7aFbqaKUib2u3spOWqYDTGo/Kg5I8nTLOiAUYV104kDIMkSg9dP3FfBcY0nW/neD5vIv7nNHASAT48z4hE2AqBLDGU56nDABc9dnsXSwTG0OeZzmxg7rvYSRnZvGPfJf8fT2rms/7dKFmDti4e0b/uf1Dy7yfcAij6AJb7Jp3BxMUNoNo/9OwnoVtJBuk2cPizJkdLnYiOH4/39g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6d/SsPs/d8MOoOQZEbdfJua6LJE5MAax5Xs2aJN+TGE=;
 b=iPZQuVIUuldqHs+Zo8XJQ5zUufnGMpqan3sU7thJmrgGEBQtp2m2ZuWJ2gdBwwYBdTcuWi4xwTusCfVUL+ZbrovacvuAJAKHYIMZ+sr7MnjRyQWgRGo+OlmAsyKwWexoqRKw1Brwtrtb2JBGb9UBk3MFvXOjmAwYB/nlAUpg5gJjzSKrI772sNNf2uw30ZvrZ3PuZfxqdf2soebe5w0h1slbyVvsnyIfCl4llfF3C0OSASfAo8YgK8woqxQjuKdtL5XMbdNKuncbZq+69Y6RD/1mGk+GjvZwYdPZBxzwRDhMcOR6QX3OGJslU0Zmsg0vYWg5z5avMbUk3Kl6q8KpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6d/SsPs/d8MOoOQZEbdfJua6LJE5MAax5Xs2aJN+TGE=;
 b=oBQWy4b2enfh/S8CoNm9FEJSJwKY5la+Vff0HJpgcIjwStNxHHWwwL9gE7X0SWa1mI9TD2kdlStPxVmAfOVzCt2wr+rHaDRxIT/YZsVe7y6S3lvbribHYcj6Sw0C6D6N0MdQWmuPh/XFf6MjzTYRAD8yB1aAf+G47nIR5lfU1Zs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6369.namprd10.prod.outlook.com (2603:10b6:303:1ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Fri, 28 Jun
 2024 07:46:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.033; Fri, 28 Jun 2024
 07:46:15 +0000
Message-ID: <e93e3171-3b30-4af1-80d8-acb9ff4900a2@oracle.com>
Date: Fri, 28 Jun 2024 08:46:08 +0100
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: get drivers out of setting queue flags
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, "Md. Haris Iqbal"
 <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        linux-block@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
References: <20240627124926.512662-1-hch@lst.de>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <20240627124926.512662-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0305.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: f85027d6-d291-4e21-96e2-08dc97466330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WHhUc1FyZlgvR0FPcnZQWUxBc1BGM3ZRbzVoQjJFNzVmT3V6N2cwRU5XUGVo?=
 =?utf-8?B?aHJmanFHSm5WQVBwSFBBNHIxL1ZmbEtEM29VSXBWNVVTSVJJcE02RjRSK3Mv?=
 =?utf-8?B?YmNIMEpSeFVHRy9EY3RPVzB0V0Jtem9JdFMrVis4T1Z1Z0FRNU9KVXZOdlZq?=
 =?utf-8?B?WWxjK0kzR3FMVUpQQlVHZ3gwYjhic3FxZ1RIMFNmZWdQaHRCSkljeDN2S1Mr?=
 =?utf-8?B?Ui9hamExOWkyNUMyTTcwNFZTcGZuNDZGYXRFdFZYaENTallXRW84Vng0VThZ?=
 =?utf-8?B?bU5aR3JtT3ZHZEkxWG9FRndReEJIalk2MDlEb0JwN3FMNTFqTFc3WUJWb21l?=
 =?utf-8?B?ZXVtdmViZm16MllyTTA2Ry9JTDE5MzRScitjUWFGR2k4M3NhN3ZEQlRFaWVp?=
 =?utf-8?B?REhDblFzaXJBNW55ZGpaQU1IaFJzLzY3bFR5MDEyTW4zTFdBN2lTd1htUTlW?=
 =?utf-8?B?NWVXMitJbVVvTzRaLzI1UysrUTR0bU45LzhCWUNaa1ZCczBZSFp3andKM1Za?=
 =?utf-8?B?Y1lYeGh6bkRHSHpNSVVKL01wcWxGd1dvVHJ4REREV2RaeWdzWjBMZDBvZW43?=
 =?utf-8?B?VW9SSkkrRG1aTWFzSWY3UFdkT3ExM3RWU3FiUXlkWCsvZFBrdkgyREQ5RE9B?=
 =?utf-8?B?YkZ3QnhtbDE3b3BTcWJQOVNJamRUNkZjMTB6bmdZcUZFZnBzQWlEVHgyeUZh?=
 =?utf-8?B?ZVNVQzM0S0NDYXkvVXk4Z2RwRHVmdEdtQWtRUi9PdGJ2RnVLcGppbm5wTU1z?=
 =?utf-8?B?OERlRERpQ0txaSszY2JhQzBla2d3cHZRc1JNckI4QTkwNS9xS0gzeGpXUXdS?=
 =?utf-8?B?MVU1a0xkeVdUQ0xxRDRIb0NZbjdteDIrWXZBVW5RQWppU3dvcmd4NHE1ZDVE?=
 =?utf-8?B?RXJVM2VmeGl1R1RYY2FlbzlucjlsTDYxRVRRSldZYkRsUWcveXFlMG44bm1G?=
 =?utf-8?B?VHFmR1Z3dmFvaUw2TTV6RXVmZW4wTzRqT01WT0FNS1lJTVc4aXRDWWIycm84?=
 =?utf-8?B?bDM1bmRFTWkxNjQ1dFNLQmt0dlVHR3QyNlRmU0gwcXhGSU9DdG5ScGROckhN?=
 =?utf-8?B?TUdUOUoreU13VzdRUVpTQ2ZsRHU4UEZoT2MwenE0Z2NrWGlVcUVFQUlFNm1U?=
 =?utf-8?B?UDVKYjlPSlNnS0RlWmNWNDVRRE1LbUhOSnpyTGdSdmZ6VXo2M2dnaDJJTHRJ?=
 =?utf-8?B?b2E2MUwrejJMNFRZRDBZbHR0eDk0bzFLYmFGWVBENjRjOHRoOXBMZFhjQUpp?=
 =?utf-8?B?RUVhUHdTNVJ2c1NOOTJBSGtzd21CWGE5YzZiVTQ2YWNsT2NuVVZJTW42TVh0?=
 =?utf-8?B?RmFqVFJReU5tTUxBSVpGY2Y3SG5pZzloRndKR3MvMmN1cDVDY2tnK2xOdzMr?=
 =?utf-8?B?bktpMlozUHZCRE1mWDNicWo0OFdoa25oNU91MzJTQjloMFZ4UTdydnUzOXJ2?=
 =?utf-8?B?R0JzdEV6MFNxcXJ3L0h2S2M4OFJGQWFRYUl2cVVsK3UrWDlpV3EzK1cwTEo2?=
 =?utf-8?B?V09mRHp4Q1pyYmNyKzlDZUhGblZscXUxU3Ztc3oxVExLZGR5U2FDNXN0ZElG?=
 =?utf-8?B?c1o3K25VOHduazVvKzZZM3Flai9WcVE1WFJnbG05UlpGSWdqWGVQclU2OEJn?=
 =?utf-8?B?dnk0SzVPRjdNc2JRUGxjckhMeVVPMjNoSmxPcWYvSnZ4anhSZEpDSFpQb0dQ?=
 =?utf-8?B?ZjRod2JuQUVSZG5PRUg4cVA0QWphWnpRWmN5cncxK0xZMmRVZnJacnJ2Umpj?=
 =?utf-8?B?UDI4U0lnV2VsY1hWUjNaa1JBbVRpWTE1N2QyUFd4K0lUc0Y4aFRKVEd0d3dN?=
 =?utf-8?B?ZnIrazUrei9kMG4wM3hFdz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?b2VGdG5CKzJyTmtJd0dRbkhRUUhEMzFQc1I0QWRtOTdIQkpjdWV3WGxhcXNw?=
 =?utf-8?B?VkY1VEpSOTJad1RUUzllbFFzT3lCTCsyeC8zbDdwQm5kVlgzdG8zaUJOY0tM?=
 =?utf-8?B?YmdybHdGMlpzQkx3dXVwTjlLVUpaZVNyNlVwY3U3SGtoRmxFenhCSU0vbDNZ?=
 =?utf-8?B?eEJOVTE5ZFVWVWRDaFBhVlFTaVhDV2RGck9XR1JmbDRvVEcwU1N6ZzVtVjdt?=
 =?utf-8?B?OVZvd0c4TnBRdFNYRDMyYVViOGJRazNzVmFpakhyVHVsSHJUWUV1ZkY2OHdr?=
 =?utf-8?B?WmhZUHVJZVJhSWk1c3FPRmRrbTNPMEYvT2VPc2piY2FVU1djZGhnRWI4ekFL?=
 =?utf-8?B?RXRITis4aldMWVpGU1dZUHpXVG1ZYzU1Wi9GN21DaFBOelp1Nk8xbTBTZXZP?=
 =?utf-8?B?bmFGVW5HNVpmK28wVWVOUm5EU25uUnRpRit6eW5oRThma3dFdGRvVU5RQ21S?=
 =?utf-8?B?QXRYZkZqVVRTVXZMRm9VQi9hZDYzZmJiQlkyTXdkbEdaejY2eTdQWFJWQ2ht?=
 =?utf-8?B?Y1gyblgxQ3NQZS92c0ovSHNnN2FMUDRrbFF6cllPUm5tTDlhOWVKZFdQVlFu?=
 =?utf-8?B?YjRjWWdkR0R4aDRReE1WUTVEWUpYMWlqeWVkNWN4ZUFnYjBjUnRPM1BkNXZm?=
 =?utf-8?B?ZHpRUjUvTWczUll5c3NYUVVJdWxndTJTa2ZiVm1MTlZBNFVXR2JKaU5zMGVQ?=
 =?utf-8?B?ZW9wWTZNK3lRL0E4YjF1bEc4MFpuOEVWN25mZ2JRbTdtSGU1alZxUFdVcXht?=
 =?utf-8?B?UXE5UUJoWUdualo5dVI1VitDWWVGTWZxQURzZDMrWHRXWGhOczM3NkZEZXhS?=
 =?utf-8?B?eGozTGVUOFdac2V5WGd0dmJEaGlKbW1kQmRGYjlTSW5VZmh1T1BudGlrL2R1?=
 =?utf-8?B?QmZycUY4WEx0ODBmc3lhLytZVUhrSDQ3ZTVlWXdMS3FUOUZNMW1yQlFoWStu?=
 =?utf-8?B?THFDTGNpaXdVUFVLTFJiLy84bTJ2dzQ2UXRZRnJpcHVucnAybE12V25lWDVT?=
 =?utf-8?B?OGpZTW82c1N1Yy9sVjBoczFUMmNqbzIzR25odnlDM3hFWk9xbjNFV2JzcUZQ?=
 =?utf-8?B?MEo5UzF1eCttZjZQLzVJbDFqUDNEZkpOV05RWDZSR1lVTjJkUmFGQ1RQdlpC?=
 =?utf-8?B?TXFIUWRLQTFacXFROE04bWdMWGovU0NwOXZzWGxOQzFITXdnbW1oR0Vtd1JX?=
 =?utf-8?B?bUZDcnZDQmZhSzBVTlpFQXVCbzRzQWxXNTJYNlY5aVVTUjFTbFB3bGc1RWI4?=
 =?utf-8?B?Mzc3SGhxSTZtMW9jQm1FbGtHTUszVktxVSsyZGpZbWZpWDhHRGRrN1JWbmM4?=
 =?utf-8?B?Lyt4R0Z1WHlxamZYV2hBdzNLUFdnenBVN0FiSnVpY3RNa1ZITHh4M25oODhs?=
 =?utf-8?B?SXNoa1BkMTdnbEozQi9jM1cxaDl5Z0cwQTMzb3dtTUkxd2JKZ2d5MkxJcWFR?=
 =?utf-8?B?STN6ZXJMWUtRbCthRXNSVVhmVnZ5a1Q5ZDc5dmdwaVY4RjJTbDVnTERCQ3A2?=
 =?utf-8?B?c3lVNE82b1p2WGZkT25McStiNlhFc2RmZEJObk4weURMZTVqQzJqVSt5Tlpy?=
 =?utf-8?B?Z1BIb0pIUG84NGNpaWN4RHRrZTBJMk5hbDYwL05XOUs1R1pObUE2T2xhUDhF?=
 =?utf-8?B?cHNnYXU4U0IrYjJ5OWNSV3RqZHhKcUo0Ui8zcTJyUlFLMDVnL0Y4L0NJVlFR?=
 =?utf-8?B?MERQYk1YK1ZsVWtVMEc0dVN3UFl3QjZXWjJVZzBRdXJ1NWtkeVYxOTg4cjZT?=
 =?utf-8?B?aUUwMDNoT0xwdmRuaC9WTUJ1SHRObm91MThQYlVXdGVmK3RUNUVmTDU4c2Qy?=
 =?utf-8?B?VEpSd1hHRmhkVXNLZmNaYUpvRGZGQzBDb0ZMc3dNWUhVTHhBdUc3QUd4RStS?=
 =?utf-8?B?U2dhUTNFakZrYUF4cHBMRGprMnJ1L2ZmZTYxNmNNOEJjMW5aekRaUzRSUllU?=
 =?utf-8?B?K2c2ZFF1WndkbnNwNDFUc1pRemdsdzc1L04rejVaSjR5d0E4eVlsUVNHUEJS?=
 =?utf-8?B?VW80eE9PTlJHelMzYnZYKzRiTnVqT1Nkbkw2VnhYNlArN3NVcC8wVXdYUzh0?=
 =?utf-8?B?V1RBaW1WN1cwSWxiUHVPV0JRKzg3OVo1U25GNmpoK0t4Qnl3YmhFSE42eDE3?=
 =?utf-8?Q?VEBvciWsmZhbBNKcnIe2k6ms1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	DEVpUGXKLXjhwOa2QWZDmAsi4T2amzO6H4vhnxuM8+Km3siyYlnjM41Xtvxue29N2bQipJcAcRzdR/n8PwULxtX9sd1EbQ82SMDSDiu1JEBIUOK0fH9XJaPwMF8MiQaNhPlvdNLeWcZ6x7qIfmB6uIwwoV4ISPgP5UFlPI65NAih2sO4UsvIiIB4uQ6HcLS5Ti19nYGjkpQaFdyGjZJ/Mpb4hYYajWhARRXUEzpT8R7qEYiR4JxG3y/vzRz9CGZSQ1cImxXRLhBDcp69VSpQ3mKvMWCiX6ZeIMDjEXTJpKpI20sSui0Yx9roSzr7IZfOX5wWS7esw2P0zuRtg8mW3TixzSd7YuZsnk41DyFz8ukILfWRM2p9/SzZIv7jyd4HPxGvQ4g7F64Er+vs1D7RSpoW6rA73ayqpB1pkEVO6/l2Aeqxg0IvvkhZJNv8yjFYZIpvNDqS0vovXqZZgnAdRhDTd969D3G0lyZ+yxQgxUUogikvtuKn+gHRCW5O5lM//Xwj9FxIcmURY0gQuzibbU1F2AIv49LkE7TCn/UO6MhzrTYkipqhihhzfc086fic+2sNiIBREzOLAbXHYsSV/D9/OpjiNdnRUoSJ60ha0tg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85027d6-d291-4e21-96e2-08dc97466330
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 07:46:14.9813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 317p/+7u6TL1U2PC+of4xdL+GrcWG03MtPh6IFiaGMwiacQJExQH+kx0dgsPpg3ibQBkDRSKX+ijOyGAysdAww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_03,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=654 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406280056
X-Proofpoint-GUID: QhRoB_K5u9biFsmabZIMlAhGsgblHP7v
X-Proofpoint-ORIG-GUID: QhRoB_K5u9biFsmabZIMlAhGsgblHP7v

On 27/06/2024 13:49, Christoph Hellwig wrote:
> Hi all,
> 
> now that driver features have been moved out of the queue flags,
> the abuses where drivers set random internal queue flags stand out
> even more.  This series fixes them up.

If no driver needs to know about these flags, could they now live in 
block/*.h ?

> 
> Diffstat:
>   block/loop.c                      |   15 ++-------------
>   block/rnbd/rnbd-clt.c             |    2 --
>   scsi/megaraid/megaraid_sas_base.c |    2 --
>   scsi/mpt3sas/mpt3sas_scsih.c      |    6 ------
>   4 files changed, 2 insertions(+), 23 deletions(-)
> 

