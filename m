Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28649340298;
	Mon, 23 Mar 2026 12:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774270618; cv=fail; b=RzgQPeyHwwHaG6pxdv6mzyGYqAFL5ZGhmoiU/I32g6HwE2ktlbzjedn05SrjDZi7wum0Es3rWG/+64MBEGS6EoZX771m9UXQVasXgxNvNGvOADGnJs8qB0PxNRLGpNF1f/e8t8HMRtIVwh1I13Ya96Pf7NdTOqLY3AS7if1m0UI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774270618; c=relaxed/simple;
	bh=st8Z50T22Kn/trNbKsTWh3+pHoOWhvTrASM1mManyqo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f8icKcS1HchwMZtQq1wUEKhaP1E5Lb7ukIRMIdM72rUi4c1GmFNf0jBUaOyC2SKhGw+cxOGED1n6I67vczFhqVVx6WTWD4e2lcmZPWvQYcrueoawMbroMwopwx2GZV786hQZmP471exP+8K84cQzEEYtroTBlCZUREVl211da3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lL1KtAFw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZcYG0dPw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lL1KtAFw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZcYG0dPw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N1NKd21718843;
	Mon, 23 Mar 2026 12:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ok3zI3ismws7gvk+I6tWEdo64dS9qshMe1Ccqv/2ToE=; b=
	lL1KtAFwG1u2Ztg+iSrOz/BM8riTK5mKSLZ4IaJiQn7aeL1JpZMRtbVFtoPUDXvq
	HZrnNIhlncFuwFk4H3vs8dVWsijhjKzeOIl75NxJlFkx8u0brXCiumCdi4WNjbSZ
	b5sqjlHTZFQYrxbMeR5ChBJI1+Gg2C4r65HZoKarzNGWh/B6/8/Re8PC+PY91Kpk
	WFSNudqJV4nvRfC/TSOejWpH5CbHnAJ915EV+a0DJnrg+EiyU9b9sxwRLFXGHgoj
	gnBa+h4E853Ff82cSplGFAxFmvt82/BSbEvdMScOsqwiJJWGUAfFVHBUsWpM6N+x
	/QCQscWr2+i64Wz/jqzdVw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kfpj6tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 12:56:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NBnXs8028955;
	Mon, 23 Mar 2026 12:56:45 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011043.outbound.protection.outlook.com [52.101.57.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8ehaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 12:56:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rmO4dUc6YmcaUzzP3Mb2YaBX1RJwjWxHYS2SQywgDhDmR9zMybCpfEacaxIt9wlahWCwo0g3zGfZSUfcYkctNpH2BAKM4VQJXSPDW9I1MhVWF8PphAsxztt/dd56uwvt/sz9YclG12ji2dySJwjwBxBcLYe9YZURHh8kgSnXSMcb54tckFgWCW5KIPsnFl+pFQi29fn09KYDgsr4bdv4sEUVfcFqrlF9wYL89KkyUbeGSqoROlblcaLM8XKJpOFqJXfMF0PLqlEzXf87EmcLD+NuC20+k7rhPhMqemeSaxirKzIWAVCFnyAId8VQQFIYo6iZn3sM4akr4s5q7Sje3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ok3zI3ismws7gvk+I6tWEdo64dS9qshMe1Ccqv/2ToE=;
 b=OpP+rabBdD0OBAVv2iSzKNpJKcrIkC4oAmSqZM4plJZvpqar8KTAuZaxyb1oJDfb14PkM2nV9F0OkUyuXPks79bTkAzvJHjEjxU3b1WIgGZ0JsiMg+OAwT2ak1QUl3LTGByH+0HvWVfcAOjSaq3Cua8MA0OvDjPBbzZueKZ+r+HhyXvBBCxYwQlaZ0Jf50F1BxgfYmI5SwkYVg0+brYYmaa8BUS5CexGu/7+YaCLQsxUlSaN27viBls1HeBocNezsk55X+0notCBAFS0y2rhPVEo0DcyVa5O3VyHNwlvp4EkEr36coWDB9Y2h7rPk7Id3W+udhk9wHGAoVgEU/VT9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ok3zI3ismws7gvk+I6tWEdo64dS9qshMe1Ccqv/2ToE=;
 b=ZcYG0dPwPKYXGbE+EmiNtS9E+duD2vD43StsxyOck7MX1KGu9UGODYjeky7No8nvl96148p02nAM9kwRDlJeqpzKPo/z0yGe/6zQ/XOwZQs6YIXXjWOiszd8zwKI+oRZOI9cAX+BVESUPiaJczbHXFo4UalUZmpoQmJNqoL8uBg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB8103.namprd10.prod.outlook.com
 (2603:10b6:8:1f9::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 12:56:42 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 12:56:42 +0000
Message-ID: <8d19b9da-8cb5-4728-ab7e-444fb0221953@oracle.com>
Date: Mon, 23 Mar 2026 12:56:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] scsi: alua: Create a core ALUA driver
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-3-john.g.garry@oracle.com>
 <25fd3a82-2a0e-4279-aed5-30c9b6f0a107@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <25fd3a82-2a0e-4279-aed5-30c9b6f0a107@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0315.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB8103:EE_
X-MS-Office365-Filtering-Correlation-Id: 40dfebc7-ab76-453f-f13d-08de88dba158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pDKkCvbMLBn3izcZfGM2R97oiZfyim8NpUA+sLYvsCGV5BSD3Rn/EYIC0XyBvyRx00rx/eO2r32nsLjzcK0l39rqT+ZzlUCd2MApRSzbDF8c5/YdICz38jID4HME2xz6ZX6N77OFpexnxK1ljjTHZtJ5FVIgEM8Se82ttysoz6l4vqpIaQejfEaOYS1r2LHmQojSCOvSrVyRg8pCTfRz5jrrC6dco5dYIz5C82qXySvGooh5RJpKpzy0/HnD38IAmbA5OyI0Map8h6BDeYMqe1CAI3ZKQsJJWQFwjn23WXdw95Nrlz4ej3eRotaD1zBaFpgnDfN+g+NA/HhEr52i+sw8mkn5U1esV59pT8uXYGeqVNumLfY/NXHCdmC++ERB5jbACc3az24R4GBOmvzefJtxrFJIflZBbSmmrPMMy7xBO3IWm30Ltyj24oWp0Ro1cNbXHOWowHDsEBupSGnFiASA7MSGcFmhEdzRue2rPHyw27C2/2zWCKMeKbkoYSircYZw+3sVTrShhAv5O3LFdNEcABXYhG+kSLuS2CeslB++xV3bUAKRu9U1/9aZS+jt3FBJnv0SEfekEhgWhj6XMfCeNYDnvujk2pFizYeH+uapRkYdKr7Db7xvdM4hEgwNT5MYPIHqBh9NOurhYJI6w0/4DGAgzRW0NmDNpRkVJpFVNTdgyEH+2yNB0i0+SKWE5gs2iMMj43Viu+beTPJkpbhResD9ZrUp1qSJMiay4H8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUhnSG8rM2lKN2c4dXFGdnQyY2lJTk9Jb1JRYzVqK3JwanhMVU1objVrQUNI?=
 =?utf-8?B?WWVvWWd6MFBEZUlLbzZja3BmT2E0SFd1K0FDaVlrSzh3aVArcGozeWVMekx5?=
 =?utf-8?B?b2tqSlZDY1ZOa01uR1VrSUVldlFMdUxUSUJJQWQ2RWxMZFA4c0xQRWNNZnRP?=
 =?utf-8?B?anFNSWRCcTdaTnI1Tko2ek5aL1RxVkVBU0RiV2pzRW1IV3RoZW81aFJQMTNs?=
 =?utf-8?B?SkptOFBVV0VsSm4wOXNCOXkyQ0RndmJVOGowZzJsVk15bVZqYVF4dEFkUitK?=
 =?utf-8?B?U1JnR0VSdkRzVzlPRnNKYXRITWIvc29pNDRTK1hyL2wvNGNPRUNWNStVNEhT?=
 =?utf-8?B?TUF5S1pUQ1N2T0dsazdUL09seXZTTVd6Smh4VldVbThnblFqMkxYRm1CYXEr?=
 =?utf-8?B?SWkzeHhhL3IwZjZvZWYyNWlEYllKQjZyYVhyQ0hXN2dQOUI0Qm10bUo5K2tm?=
 =?utf-8?B?RkRmRXo3cHJ1enZnUmpkU210NkxUTHlhbGdEeE1Gdk5jRG5BOElrWGd0RkxS?=
 =?utf-8?B?bFh6WFVjU1hrZnBPQWo4ckhHSEZ4RFVmMk14VFpBWGlDRU4wYWJIbVkrVDZ2?=
 =?utf-8?B?WjhHVzBZRDV0OEJzM2pMMnROY2hVcmpqd29ZK1R6QlM5NHRVMUMydlBkSWRv?=
 =?utf-8?B?UnNvZitWT2JuWFU3emQ3UStLVnA4N3NWUCt5RnRsMUtPenY0dFRRQkRIc2xt?=
 =?utf-8?B?MVNnQmlQMGdOY1F2dXE3aXFuMG5vaW9VR3lCOHlvSlJJTmh2MDUrdWNtQm9U?=
 =?utf-8?B?RDMwbHUzVGFLTEZXSmtDUE1ZeFdOL21aT1hEazNJUDVrTUJacVM2NjMrUTVw?=
 =?utf-8?B?R001SFFBUmkxcmFMSU1TVnkrMGNvVXc0eHJYVkN3M3NPcG9xSlptdkdFbUNh?=
 =?utf-8?B?U0JRTHBONjRwMjR5enIrVzNNV1VKVmNwekw1bm5SNzB1VEEwVG4wTlo5MlU5?=
 =?utf-8?B?dk1PRUVQQWRRdUZsUERLTHpWWDk5a0lQa0ViMW9SZ2wvYVVKRUJtRS8yekhz?=
 =?utf-8?B?U1JMcS9wUVpzMStQL2orQXE5OGV1RHlkNTJReStjcGwra091Ly84YnRuMTdK?=
 =?utf-8?B?Q1hFR3BRWTZkWXkyTnpIdFRUdVY1SWFkRkxTT3BBajRQY1Fqak44Vm1iYXNY?=
 =?utf-8?B?c0RoTmt0ekxGZi84QTVlMXZVeVF3N2JnRzlDcnBLcG1QL0pKZ3V2cWVYY0ZX?=
 =?utf-8?B?MEdsL1o5ak9DVWVhZjEweXd4eE9pekFjajdoZm41M3J4SXJCNSs0SENnaUJL?=
 =?utf-8?B?MW5xVXd4eFA1M1lnTldXVTMzMWVHSW9Rb1BCSFU1VmVjNVlLVlpBdjg0REpM?=
 =?utf-8?B?RW00elUzUExUSjNJMnpTTFVrRWdOZ1RQYXRZb0VqK0JWNG93VHExU2YxWTJ6?=
 =?utf-8?B?TENoeUtXc3I1QnlaRERUQmtaOFBCRTd6QUJSSW0zV01Yb0EwUWFZSVJ3WW96?=
 =?utf-8?B?TXJLRWc2eW0yazdwR3VSTXMrOFFxcFVabk0vWGFYbnY1eld4WVYwQTVHNk9r?=
 =?utf-8?B?Q0FNejA4Mnd6QzRCdDFKSkZxdEtTTlhPdFhrNWJ6Z3pibVlqemE2dllING4z?=
 =?utf-8?B?eE5ZTklMUVlrbXlqZ0d1eUU2RWNWZGlsVmJTdEErNFpDakJ0QWFXMG9wd0x1?=
 =?utf-8?B?K0dRbUtCRlJFTFFIQWo0L2NCZUxxK3hsUkw2RGxLZFdueDZhRFcxNjcxdlc2?=
 =?utf-8?B?MHI2T0Z1YlJ2VGxrVUZ4RDdqNGRwWnJlUzlycVhiS1N1eGRxbWkzMkJoY1Zj?=
 =?utf-8?B?SWVyUnFBSEpWL2wzMWllTVR0dHVQdFJ4bG1wRDNKd3lvak9KMHpGUDZJMHg1?=
 =?utf-8?B?MHZIaU04SHI5MjE3dGE5eDlwbkNMSXlYamtzcmt4d21iMGp1RzRBVGlKZGhP?=
 =?utf-8?B?TjNVeXRvTC85SWFQNEt5SWVuS1JENzEyczVvaWNFanNmYXN3Rm4xREVFSkZK?=
 =?utf-8?B?MjdISkZ2WS9kb2ttRG1PSlF5b04wSUxwaW5sZEQ3SmZJVEtSSExmNm1PcHFs?=
 =?utf-8?B?dWhmdEtmcGhUNSs1dFFjc2x3bDY5amZ2VmthTVNhdmkzMFhuZGFJWk5ETy9p?=
 =?utf-8?B?MWI2UEx0Z3BybURmb2IzUUx2eUNweDJXd0pxRWRQQVdEdlFmK0JVZ0ZPbi9Y?=
 =?utf-8?B?MzBzNmxmWFFpNEhWVWhIUEFlYjA4NGhXaEFqYkFnaDlNY3FxSHpQbERreXpV?=
 =?utf-8?B?cjc5dmltdVNhbXJybmZVbjBSQWE2MnhudTB0VjUyWElvYXlQeVNQbHh3N3RX?=
 =?utf-8?B?VUVRS2FiVXJkT2F6N0FMaDlMMEk2anRaM0RGWHZNSDVUMVVvSW41U3hyY3lE?=
 =?utf-8?B?bm5sUkNsaUp5bnU0OHkzSHhMVHRhRmp0NHdNbjc1dWlSVCtuamNaRWFHaGNH?=
 =?utf-8?Q?YQpEvtTOLgn4B4Mo=3D?=
X-Exchange-RoutingPolicyChecked:
	oiJX2X0GnycBRQPJ3RU2DLLZhYuCRB/D/XNnRz4BbWVb8u7NDd4QpohGzcBCsJgpYhUI24fZNd8x/ChpIJ+UeCzACrDbdtFfCvaXQ1/bpKJmX8kBF/3YjpvOq0EQTTyM3juNrjA4m9yab+7fec4pbAfd0QDkZcnGF0qjxL+vaT18tgVQgG2ntkNiqt2J4UyRp4YX+uR2qcmm7jm/LWldC7OU37pcZ8BWYG3cQI1HU+I7Ijy5+xERzkVL/pMnt8KxPNjzBKlAv71ajDtCzsdqKPp8cS+82hYPQ7RluoVSj7xOZFLhE562G+6/2ukeXpG5VaxmYRMR/2ePby0vqgjgNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S7/Pk/stj+kxtiD0pUgnl60rN1ZnaaY1r0/WdIkooGS0nguAE5zRIZ97JgouLVw9Vu+kOMlHJq2DLGW99LGgYHYcoe2Be2aYjO7mYuRdMYqZ0G8ESSHUw0b6d3w4UtPrySN8eGLO4DvJXlewrp4ql9sQ7sVxlnkNXfUOTncyiuAIIBwBLmFJWz/neQ3FLo8BlqkHJPSLkyXeGqLf/x2bW+LLSVfLiHFdatPSV0yFN2d8XUBUET9lR6Fo9iIhmburQLF/hlZbUNis1mpg6Dp6K4SgeVGxtbOEtPZWQHZ897WJ/bUsIXvByl77V+XKnZixM8LlOyWrUma3D6oModaH6atlLRaI3/GncE4BVT9dxvjLXxNuaavcKvlz3NTJJYRgH8ccvLVFKS3miKo5BAoJvIPz0unHk/+/N3f6UrtGMHZUefJdIDACpG3EUT6bUaT03LTjOIUrHEiT3y62lCBX6H6B0ZA1P/LbxR1lKaYwLhbkMOKAY6gXCrXD24nVbQr1EkWoLXEh4WT/cK+HrOiETSSWbzl39wCqM9g5k+zCswbeQuQfRMeLBuC+QVYbAEzCbKO5wSPQgMqkLQngPqaa2Y46XACBCa5zKjElaNCcHhc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40dfebc7-ab76-453f-f13d-08de88dba158
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 12:56:42.2533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SI/mxZKXXNOg6z1qcU1/lwcJY9Kek2rzhB/HKf2U1KLItTyx9VKb9SiO5tOPHp4HPoKbBeKbcaVl/8Z7WKwEmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_03,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230100
X-Proofpoint-GUID: FBp1FTfSZjBvUlNeco6FhhxohdFt3yoF
X-Authority-Analysis: v=2.4 cv=VKnQXtPX c=1 sm=1 tr=0 ts=69c1388e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=OubOrnJt1JOQMxTkX74A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=EBa_rOYxF3VBboPlVeQ_:22
X-Proofpoint-ORIG-GUID: FBp1FTfSZjBvUlNeco6FhhxohdFt3yoF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEwMCBTYWx0ZWRfXzspzXDa+/4F4
 Us0pLUh9YGz+ySP5YLQVTkSwLsuHT95OiE4TYv/0dCC1FWJeyGzzrGJcODC5P7wgd5i7lUyiuDq
 qRx+BBV7c2LmEmG361y3x2dV0+VlTWFhISTdGPAHE+GF9kfH/e5wjT4IIDeUJ0aHhdlfaXiM8UD
 wheVvC9hFAg5UiHXf/JrM7pZxOIB69BUbWO73gWErya3ud5Cvksx2dMWUuWYb7VwSjPp2H25A88
 yeRgGM7g9MsKdlmxpyUyrIvVVN8RwRPhHTN22ak38iYTmucpACqlZysWh1FP4cHT2PncNog/IGr
 QfyB/Z6tPQ9BzmgAdBj9mKl/YkE0gmd1UlbpgecX1YInviXinYlS7t8pjHZLlU3hMbY+9ps2Dsq
 FdlrDgETfWF4vuanv5vp02eybqCQBI/ybcSJ1aAY9dDAuipC9GT3H/i14NgOxjSxC5S2ZkNSBj7
 ECGgMYDxVoBqlYL1Exg==

On 18/03/2026 07:47, Hannes Reinecke wrote:
> On 3/17/26 13:06, John Garry wrote:
>> Add a dedicated ALUA driver which can be used for native SCSI multipath
>> and also DH-based ALUA support.
>>
> Is this really a 'driver'? It's more additional functionality for a SCSI
> device, and not really a driver.
> At least I _think_ it is ...

Actually it's more of a library than anything :)

>> +
>> +static struct workqueue_struct *kalua_wq;
>> +
>> +int scsi_alua_sdev_init(struct scsi_device *sdev)
>> +{
>> +    int rel_port, ret, tpgs;
>> +
>> +    tpgs = scsi_device_tpgs(sdev);
>> +    if (!tpgs)
>> +        return 0;
>> +
>> +    sdev->alua = kzalloc(sizeof(*sdev->alua), GFP_KERNEL);
>> +    if (!sdev->alua)
>> +        return -ENOMEM;
>> +
> 
> Why do you allocate a separate structure?
> Is this structure shared with something?
> Wouldn't it be better to just add some field to the scsi_device?
>

I could embed the structure in scsi_device, but it's just convenient to 
ever check sdev->alua to see if alua is supported and also know that the 
members are initialized and hold valid values.

Thanks,
John
