Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9BF3BE17B;
	Tue,  3 Mar 2026 10:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772535244; cv=fail; b=eX18PviBrPyVZqKkAZ1XODHzUCwmzj29RzNoVOOyc+lss4N/kKdIcKclVlmhybIQ47HVwhQ9wM5KPhkFQi4UC+CvfzQGVtYk3H3+HtLQtGiSQoIhKYpHCq60zUG9j1crIemOku0nIy8yNALhCSZgBWTVueEZnfKLHatPbzItH/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772535244; c=relaxed/simple;
	bh=rmbCndzpsgGXHRHrpZ+deCXQRDn7t4RtnAKDiEsZOiU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ggOYElwko1rbo50ZCTrGQSB1+GYWap7+lGewsdD3X2d2Y24ywk2wzFbqqL2UkFvAdEeE/ONf3AEUQWRuVHquNRqM2jvLWfvHiEjE+LTi9PM6JBunxhe02gwfG4Bmn1FWZ/Espdc0ba2SKghlg3eBdB0wyiqptcd91fE4ZRC8M+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Erd5tQ4h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zzoxkJ95; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Erd5tQ4h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zzoxkJ95"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623Abho8095196;
	Tue, 3 Mar 2026 10:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Oc8e2J34NzXbxIeLD3szJRnA0LAtsM6V66RZD0GI4QA=; b=
	Erd5tQ4h5MZ8zm49iRJsk4gQdOaAXFkRfWe+yPXc6jU5mSWBbXfqd5nc+lyr1qhW
	HxjFuaAUYDAD7sa5ZdOkrK+O4/znGg6k6aEtpxLYv+OtHMayExfPQPuluuUQ3lkT
	xOHKxf5SVUucgInoBRVDyuWStY6nOutpz8V5Q817zH9O9xS4x9KEzh4kHRIF6WkA
	lQPFrTth75mrJ/XdXsd3q5QpijGyI+R9rEthTVne53OiHXumCJvXuLd7U1m0FTg4
	jK6fyUKLU741qdfwgkvbWgcyJzxtWrTzQv5cHJ8L5W4ZDikyQQqm4x3iullHv0Qv
	JTd8tWhp6NlTWiN85/NuZA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnx27g0r7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:53:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6238p2cT034819;
	Tue, 3 Mar 2026 10:53:43 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010055.outbound.protection.outlook.com [52.101.61.55])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpte6ctb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qw8fERVUp+qppMhCxcteSmBP+XjLHeuwie94+77y9qiXeQ2DcfipHUEGS8rjEmBXyl2o8qxKDx3/zpHhpUOhWg5qwc7Ms336EaneY+0iUuW6GOjqBmpfFMcvVRePWf9gr0dgHUyrTRPvC+J0+kxpmcLqJIw2jsRiUhKGN3k51A2lJqSdAbAH2iLbGzIIXxg2k059CicjGC50AhLNBt/3IChWhmrl6FfOhV58/M2DF2xrGguaQAFmNh8PtZlthbw640JZtyC7gf2x2UMopw1bOFi+C8j9DAEI5MD8bZljQtv8k84Q49FiLYSft7YN/jsGhHbLbO9QA1THdQdocO9T7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oc8e2J34NzXbxIeLD3szJRnA0LAtsM6V66RZD0GI4QA=;
 b=crVSxAdEFIoeHuFQU1w/TWfitUz0X3UUlEwcXgSmHtU9fcccJbcqL4HHVg0g1RVw2BCZ+CJgMntm1TNN2SWYwXN88l+zJZ7YHyq1rffOfwZgrZFQRfsZzw9cC4zkn6TsRodfWqOBfh2DcHBFOPg3Z05iuIGWnN5uyWv5M1bd0PkFod/6ATuRDSxYCcpeHydInqFdFqmOESP7Iou5EpWvKGBTQfkM58vTmTFMtcZkAFLBEdh+TUUnoiSnX1lPD9jZtsB6NgO5hgnFoY6ZqyIgQwgGCoMj0KxdphhDf1OGf7qw5u83eSqLHTO0bHbfF4LJqKIygsI6WYtVn/SSTWizyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oc8e2J34NzXbxIeLD3szJRnA0LAtsM6V66RZD0GI4QA=;
 b=zzoxkJ95JyvAWq+PRoY0b6oj02j8IPVreTVt2aPqSxFcICBo6zem4Ddb4U5P2fzRESBkHRBEfMEfHKw6F0AY2yivR65Mwig5PPMF0IyOAwB66Nz2rj9HLMnBSvx3MfT9rcf+RCAmv1mQE5l/TBSiduVswiMzdGmFaIvUIuk/U8M=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by EAYPR10MB997831.namprd10.prod.outlook.com
 (2603:10b6:303:2c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 10:53:39 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 10:53:39 +0000
Message-ID: <3e290346-26c5-4704-aade-c861a45a5f50@oracle.com>
Date: Tue, 3 Mar 2026 10:53:35 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi-multipath: introduce scsi_mpath_device_class
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-5-john.g.garry@oracle.com>
 <9881a867-244c-4ae5-852a-3332b7eb0614@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9881a867-244c-4ae5-852a-3332b7eb0614@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU2PR04CA0230.eurprd04.prod.outlook.com
 (2603:10a6:10:2b1::25) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|EAYPR10MB997831:EE_
X-MS-Office365-Filtering-Correlation-Id: 15e54879-3bca-4306-327c-08de791320b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	9BtG4y5wCLVtEOXEiEnS6Y2EZhuMoB5XFHplqc0QNuA6U0otM9V+3fS8BrJh0p40BcU1SJcBYQvTlxa6vF2M0OOWcc7qesJQENRSVstX0vKPfQblbj0wOsXFvMfCTHf9qf8yz4MJDF0mMDlYIkM/SKJByHq+wUZpW9YHks1lv3EJdGrUbj2trC7RoHG9EgKc94SHMnrGWXLrmsyxs3BqcEA9/kT/IFDSlMCUu94m81RQ9B8k8b6Lje3So7Gq/052FXgQBPylURJ1WdsIx294ZJqfGFYUvnlQijq3iGjan+HONXE/Qn1hJYCAg/dMOvlqtBLE4JpTU3iatItiPUdnX65BIAk1Vxd3y7zf2lLwz+VtcSPHYuGeORZDRLkMbm2xc7rqBZqysyJi44P2gbVkoeVB/5ArfrF8xiRsrWsMjnEQX2lwx4ryNdlqHWD6b+kKHorJ0vbY0+IL9F8iGPRabhX4CemqdhnJSGZBqlVJ7m3Q592siHgcn9EflLNBEO2odKTdUBzp/26L9bYbnfdfxe0JVWpLCoXW5h5SDwBlRjj11UPX9pt9ND1IU0mh942hYpVYbxXpHKFJfFPgMETFcFXuAZ02Qwr2rNK01rcPZCaWzU3O2EPvoC8ACFMqtl3mzfxAKfumYtejI4DZ+KxEjXyjDODq4Mn3gatdbvnC3uTAvzuDVAqmP9A0BBs+aV7rGLARlGeMNGIRvIDplI26b/4WH0rUzmFGhtbcDVMKhtI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3BLWDhsZlg2dWc0Y1JLNlBEM3hNVWowOTM2TEJJV2QyUE5WbFk1dk02N3lW?=
 =?utf-8?B?ODZCZTc5Smd4S3dOQngzd1NvdGhkZFBmYkdzUStGaVM0eXVhcmdER3VyK09D?=
 =?utf-8?B?K0hlWlQyUVFVZTVNMTliYmZOVjhjRXJZUElGQ1ZTdGZsZjF2WDFBSnVYS3VI?=
 =?utf-8?B?OWdPWUF5eldGWmppaDhxRkhtZnp4WVgrMXd1aXEwY2lMdFdRM1JoRmhMT0c0?=
 =?utf-8?B?YXg2SzdsR2c1b1gyMlFIaW1jNkEyb2k5eFVXa0RkYTBLMVA5MS9jQjFqdlZh?=
 =?utf-8?B?MGhzbnBvTU1DTkJEcldwYVQ1bHBPeFZRYjZBRzVhLysycUZmMDVEdUZmb0xw?=
 =?utf-8?B?RkdwZWdQWGxUWUVsOWVVY0VnSGFmYUZ3TC9aeWlqT3lxaFhHY0VGK0VHS2hC?=
 =?utf-8?B?US9xZ3huLzNsNTgrN0RWWllyS3MzSXJ4T3YxMDdpOFhmUXExNjUzcS83ckhx?=
 =?utf-8?B?WW5HMDkzVUVJYi9hZm43N2U0SkxzNUpJUkJLTjQxcDFzeWdxSDk1MEI0d2ln?=
 =?utf-8?B?RXdmM25QeWErREM0ZkFkZHJLa24xY1dmRVhuV2VwY2lVTUIzS0hCRDREMXBJ?=
 =?utf-8?B?VFUxRXBPckQ3d2UzNzU2c2lHR1grTEN4cmo3L2hyb0EvZXMxTEFPUUgvRXpD?=
 =?utf-8?B?YUN0TVZpQlkrOHdqK3pkUXdDcWJvRFpBQzB6T0RScExGYktIUDZaSnNPRHh5?=
 =?utf-8?B?WVJRZlRNVjM3NDJ4RHNOT2JsU2taaEJIVFJOVlVLazRyUnpYK01DcGVXV3dk?=
 =?utf-8?B?bjJHRFZPVC9MdW10dGpIdU95a1JJSEc0VDI5aHBCc1MrcUVCeExyYzd4S1Uz?=
 =?utf-8?B?aEJieHhQSlVxcGg5YzF5MmJXUnhKamNWNzVKS3VVSFFrMlBrSzdrZTc4UEZr?=
 =?utf-8?B?Q0FjOVg1YUROREhqMHMwWmx6c01RMS8zNVlJbmt3UmdnZ0oyNCtxNUtxT2Vx?=
 =?utf-8?B?N0MxWjkycVRka2gxVHZFQzNGMzEzbHRPVUV1M2k3RzBpNkhFQlZPcGQ3aHhJ?=
 =?utf-8?B?MTMyZDFTQURkejRpUGVIcGVIN3kvM0RqcFkwSjB1alNUL1gwbGpTZEEyL1FN?=
 =?utf-8?B?Q2VXYnN4aEFlbkRSSXdqNVpWb09iSkx4Q2lNVWYzcS9PU1hPbzR2bHp3V0du?=
 =?utf-8?B?NU90dnErcE1UNGdZeHF3SUh4ejVKVDJSMGVkZDZpdkdUcWRqTGlubXBRQXdH?=
 =?utf-8?B?K1hCZ3U3SWEvNWNFVTJEb3dVNDhidGVRMm5HYTJwK3p4UTVxa3pFYXQwa0dS?=
 =?utf-8?B?U3ZZaUx0ZmIxdnpDWDNJbElnTVV5bzNwT01MRTJNbUNVN2piN0ZNdEpQemcr?=
 =?utf-8?B?Nk5jRkt1dENYV25Cd05VdWV2S2pQc2VhcHFVYU9aMFNHODBZTFBzd1VtYTUr?=
 =?utf-8?B?cG5JcUkwM2VQdlZ2eWpVL0daS21OdjlQRTVLUXFXdjJ1eHdKWmlxMHBDeWw0?=
 =?utf-8?B?b0dMYTA2NitjclNOVzNwUlVXTXRyaE9kdTNFVUdrQTI5UFdKSElQRzU2Q1Fl?=
 =?utf-8?B?V2tYc09wMW5wMjNEeDBqT254Sjhob2ZhS0tlU24wd0tSajZaSzRwNGZFdjkw?=
 =?utf-8?B?Q1ZHMWwrOGc5clFCSUhYbXJBK1dhY1lTUzdGZzZ6UytscUV1NDkwcFl1dDVM?=
 =?utf-8?B?dy95MzVkS295RTBzSjRzRC9lbHpiTmZHU1RJQlZSbjhLaG5CaXlGVURpM09i?=
 =?utf-8?B?RVhEdHZXMnJVMCszYi9VVy90cGZIM0pUN2RHZ2xWYm5WaDgrUS9WVjBqdmFY?=
 =?utf-8?B?N3JSMTE5c0YySGFCQ3ZhTllsYkVPaTFsTG5aSVVQZVBrTG9CV3U3ZUc3a3BY?=
 =?utf-8?B?OE9wY1I0ODZQbU1pem5WRVc1MEdYMnlaZ2xaYWFCS1RSUEZxY1pJU3lVTlQ1?=
 =?utf-8?B?MXd4Q0tpZGZVOXdTektnSW9sT0tXZHRldEw4SWt0RWpoNHVoN0c4SHJLRW56?=
 =?utf-8?B?RjVmNjFHeExNNjJUNGM1WEdZeW8xQ1VzMHZqQm9DcmJUMTl6SmpIM2xZOU5Y?=
 =?utf-8?B?S0tVMklTbHRtYlRzUEhPQXE1SkhPL0VJVEV2Mi81azJ5a2thV3NZamFkbDVH?=
 =?utf-8?B?OXhHWndhLzhmWXFKaE5KY0h3Wk1Dem1MOUF6VzA4SE9yVXJnc3p0RXkvb1RW?=
 =?utf-8?B?VmVMSGdqTllkeS9wQWlEM095YS9QU2VLWUJPU2paaU51ZEsrWGh5KzJZb0NQ?=
 =?utf-8?B?UC9rVERUSW5BaWRWVnltSVE0eEFzUm9tckRMQzZ4bWR1TXRkcy9lU01TalFs?=
 =?utf-8?B?WjFzNUJtcVQ1MnhmTndHN3FOeXNEYVdzUGtOVkM3L1A4OXk3SFJlVVREdFVk?=
 =?utf-8?B?c3dqZWNmVWl3R0NaZjFCVWp6TWc4QjVQazZGMnpDWUdJTDRIdlNZYWd6Uzc4?=
 =?utf-8?Q?y65NdmytepziHpSs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x8mw8XaN5F4XEIxMXvDFZj1zArEGiu7oMsQhyiG5wN0o4ZcYlgb8wYDVVJTL7aA6KAcLVb7S7MoXdd3rQChV6UTYpdt8GpEuBQb9/XBegJYviRKn+qAMsEVDvq2ip1hZFGCrSKON7+thPxfq5ucSXVPxzcRMAuog1axZh+a39vQL3h5kjBesnDr0JaOLA/v0Awps1cV+2bxhjzHvVZkDrltvNVCF+bwRSIu1GO/mQLeRmObfjzQ97mP/qxzuBoaPGXvX4Bp50H/VwgVJh5BU7x1Rl8FCXHPhjyd5fU+8Z4gZjiuADLCVzV1Q+Hsy8lW8nqwjAMXJCbsJn4nVNEM6QdUVbVvkwOjTpECFd/XInQp3/jlMYPCAcpF6/krx83fpoqR+5bT8PLGR7V2K0GPAteXA2JlZRn1IQ+aTqPqmhS+GNeBQg/5Ua34twXNQqCVkLt9NeM05AsKJ2RzvBSZYVeKLCrSst+LkFkpjfTJFtB6aDfabGeSAseNBky2xNqPZjkLIybsUIAj6EynP/ngBQep31ZVSBzBLr3ejobeQGC/ZxJEHmAWceoXqi5A2YoSnJMS7Y3J6cYke6+uuRSkoLRKsZuIMwQKZsx8TsQE5KW4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e54879-3bca-4306-327c-08de791320b1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 10:53:39.5253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuomCC7YX09VhGXBFYQH93u/zGiZhCbcOfBKz0Zk/afJ2weSYAgZLTNsS2s97RIy+iCY7bJBmR2MSqs82zmB4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR10MB997831
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603030083
X-Proofpoint-GUID: gDc_J1cmL0kjvwEdwLxZXnivwPKIzGNx
X-Proofpoint-ORIG-GUID: gDc_J1cmL0kjvwEdwLxZXnivwPKIzGNx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4MyBTYWx0ZWRfX69buIRWWYqkV
 d5Jvlx+DqlPl0wkZ6MvdsdaQb9A4JsqOF/qRUTfhjqmaQe5G6Ul9+W0G4/14gGtNlDyx3KQ4U3p
 sLL4l5q+OJ4iqQdwkdlT5f8qMVznYYiNPMTx0gCgE/1F2A1ZoZxZNTCZk5NnqGk5f5NfQzPONwz
 pqGce4sUKvpr0w/6MgDCElfVyMxGFHHxHiwJHAgdwZ8Q7H+DcsVGtguWXA2bpZEGFd/UYD+qu//
 78ZPBRzcQP17itIuXOSNJ6cdTh0HrMdNLagL0J5g2KyYn6iEtQUYISfxNJGJMboOX19npZ8o/eM
 vqJzXucck/MN1ZQGEON41G1ZI8uKvkw2z/BQK2nRDQ9UtQq/kOIcJ488K60439/4RfBY1rp9Q2v
 1ET0aNKe+bBnIxbocP3ZXzKE7fEMD04MZt4Mx0yhNcYtdZ37lqoYkcpV7s6mGbMesQK5k9Y+0I7
 ZP+7Z90MgQW2yZUAA7VJbEuP3oUTQ6ZYTihnw074=
X-Authority-Analysis: v=2.4 cv=CbgFJbrl c=1 sm=1 tr=0 ts=69a6bdb7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=gjMdN2VlGQDwbUPg2y8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12261

On 03/03/2026 07:16, Hannes Reinecke wrote:
> On 2/25/26 16:36, John Garry wrote:
>> Introduce a new class for multipathed devices, scsi_mpath_device_class.
>>
>> The purpose of this class is for managing the scsi_mpath_head.dev member.
>>
>> The naming for the scsi_device structure is in form H:C:I:L,
>> where H is host, C is channel, I is ID, and L is lun.
>>
>> However, for a multipathed scsi_device, all the naming members may be
>> different between member scsi_device's. As such, just use a simple
>> single-number naming index for each scsi_mpath_head.
>>
>> The sysfs device folder will have links to the scsi_device's so, it will
>> be possible to lookup the member scsi_device's.
>>
>> An example sysfs entry is as follows:
>> # ls -l /sys/class/scsi_mpath_device/0/
>> total 0
>> drwxr-xr-x    2 root     root             0 Feb 24 11:56 power
>> lrwxrwxrwx    1 root     root             0 Feb 24 11:56 subsystem - 
>> > ../../../../class/scsi_mpath_device
>> -rw-r--r--    1 root     root          4096 Feb 24 11:55 uevent
>> -r--r--r--    1 root     root          4096 Feb 24 11:56 wwid
>> # cat /sys/class/scsi_mpath_device/0/wwid
>> naa.600140505200a986f0043c9afa1fd077
>>
> Ah, here it is.
> So you can ignore my comments from the previous patch.
> (and you might think of merging this and the previous patch).

ok, I can reorder and/or merge.

> 
> But device naming is still dodgy. A plain number has so many ways of
> being misinterpreted.
> Wouldn't it be better to name it 'mpathX' ?
> 

sure, maybe that is better. Any other naming suggestions? Originally I 
had smpdX (but dropped it), where that is "Scsi MultiPath Device" and X 
is a number index.

Cheers
