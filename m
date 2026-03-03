Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A6F29A2;
	Tue,  3 Mar 2026 07:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523969; cv=fail; b=iCBCgHj2i4h1+ZEyRh8FY41qISfuTtOVlFKCN9GO+RB3F6KSMCjeNSlaLAeLRTOJvhfULq/Nqbv0ZEAlBCBAHjWyWDOSZsm5fs+c05iyuxK3tMfdVhP0GSK1Q3v6M2P+wd+xN/zkKLHnf6iGv4eYHo7uvLt3Q6wqFPhEAcO4xZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523969; c=relaxed/simple;
	bh=JZ8RNZwq7Bk4hQv4NlJ1wzC8fk8C3ElD9FV0zBwmtVU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sOgdgbQK8Q2BL4YSkcoPmvmirA5aHTPASjrnxm+zk9it4K4mF4VdUx/HZGIoUUvLMSxPO63Dj8Y/CGp0uWC8GAgxQT8wFA0TQ3jRmZDdKsGMcdRB/kVYU7snYiwFxaQgtfTRxq5SEogLtXhFjGtTNV9cCH9uHn1g1ux3sGBe5Ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WPSuk7lv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Juc0kcUH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WPSuk7lv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Juc0kcUH"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6236C2W22884677;
	Tue, 3 Mar 2026 07:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JZ8RNZwq7Bk4hQv4NlJ1wzC8fk8C3ElD9FV0zBwmtVU=; b=
	WPSuk7lvcPlR1nfsEQzdlyArUef5TbMypppazbbDK21cT4Y+i6aUI1EV+oaGXRCt
	qTvOjwBifdxaFb43MjYICSRvWnLH93hE0Tvxnwy2W5PikfdQMvdfZuk08DpjXCyO
	mp3kqw+XtkMzAqbc5sk8gcGo6qJq5ZpuzLhs9Wlx3u5ESpQu0yQzeA9jHcfu93UO
	gO9JFtUVxIbwvXaEcJvHOzzkBrGCjBMdaWnfbkhIqktjX0b2bohipAc6+VRQQsjj
	xi73B+kyNlaTnubSGrYxTw0SL4ilx1FmJvkIiLWxTcVYwDpiNA9YWONNdj8GLU0c
	aw2sDOUBY2m6ur+TkgYbjg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnt5fg38a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 07:45:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6237LoAX023214;
	Tue, 3 Mar 2026 07:45:48 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011022.outbound.protection.outlook.com [52.101.57.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpte9jbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 07:45:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSkMsybS/TSs1MtX72/2sZ6ACIaimu89ZgnwvdJt0LgT026qmEF0bpjnxtuhIwZpCwQEdYHYZL+Xy0NYLOjo48JWGiKJks+syyFCawEZ/CjyEpQ15JDpfQwK3iXpnWZFYbLxWjTcRP8n17CRmXK+Zgpy2tfoRj3590keJDh7T594jcPV+TGTL4nvgIres08Af+N5jDaUqt1WvKPXiSgndTtcMizC5cSSA6EKEalBQOzkUAhIJNpI6g7TjhLVomoMbu2XIwCPDLo9t0gYkpcXevgm9AswhxcpQ4n55iLqZq9QeCD7YhTSKlJMg3Q9FHHwcGFPDUrdd63EfNcHHKnpbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZ8RNZwq7Bk4hQv4NlJ1wzC8fk8C3ElD9FV0zBwmtVU=;
 b=ZRrZYhtWtStVW87rCpF5HxVAbEnEq8BmL11i6Hdv6DiyjninaZKGhxi1UDDxw+FwU3ytIt5h26FIjQX6XCUOaAmSTOUEhMS9nn9QziZAWoUWCzKp/xWE9JXwGud6Jbq5Owo2zgAi50LMKQ4hJLL+ibz8vIHQIzz51ivGSCI/fE5yxfRcDCUMkxClknRB9zntd7n08s8++nzYJykzaqfBEL8XTUL8+nrz7u/5LteBXhlwopwMvklut19GODnQ6RBA8q/7yM+daSw5v4oTUDaJYMcEYH1KMe7SWT/4DRv/NmLW29J53JwI28aSpXzpfGU5Fk8wTNr7WGIULqXb9fH3Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZ8RNZwq7Bk4hQv4NlJ1wzC8fk8C3ElD9FV0zBwmtVU=;
 b=Juc0kcUHolvhTPrg6vI07oW9kZz7AfWfo6sC9zwnJX2CT8MHVh+auYML47h3KP5+bMa0XWPHqgLsk9TXwwpwErT7B2GIFFYRaTgJtkgUL/a/GrqTB9mX7Giw5yuNP4Z6EhNqrAxGVw3B0x8ZpCD6AwIF1EtHEV8x0/N9cKKYDgQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB4965.namprd10.prod.outlook.com
 (2603:10b6:408:126::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 07:45:46 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 07:45:46 +0000
Message-ID: <f900bb57-1c87-4c6e-809e-f6a421635101@oracle.com>
Date: Tue, 3 Mar 2026 07:45:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
 <e22f5444-f8ff-4c91-b9ab-fa95714f2df7@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e22f5444-f8ff-4c91-b9ab-fa95714f2df7@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0680.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b594d34-c306-4b3e-d2e8-08de78f8e183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	c3y/aAhlVpKB1bzdjZnPsCTU1Pt9eDiGiwuIQD6ItQOrNvdJepXyKdBKB6o3i7PbMZbE+L3JHQX3FajwFNQYHEdNdv0pORD77uUsnhgE7vs0QQkbQqYJgs4M3UOM+exUvqZxBeRUbHPIurkNem6SwfMSSezcEvEkk2QmjEV61UIfjEmcE2HyXLkRN55RUcSmG2M216K1Ia8Wc9PAGizfFvJyQSt4MfEtghA2Lju0Tv8QkdaL8Og352frF3zCK4tQdV243pPXp7ZlmipANLL+sNZrMs8m6MPAMnvz8BxYXsnZHmZ4cX0uXzxUxnlC3LSzIukVR6QeWhYEsdm4gjtBoRjxxYtvf4isVkUJT3fEPTsPpQ2EI0igkET+FBMXu5bPJEEhzopRpK6zV0cz9pvF6tkZQh1oVqqLrZHaVNCDhMVVD/AWr6MKSGyeoE2Po1Nld7HQuhf7zGJqcL8NGBpeviBljToA7I0B5Y9N1sZ6NBi4he6cnSLdjQrT55MdNYGtNjVF9BG2FJEYx1IejUYDJcMl+iX0GFgTq2HvCksevkMMc4KkEb4WEGNbXJjHY4H8JY01bTiuBo19HO15kHrgTQhOs0dfsB51VwuSOlXqMY+UaLE8kUMew0rKog27UOWMK7d72NnDIN1B5Gd+02bYhjI7+UrEo8tgNomqom7pQi9yP5nyeLfm3bGGFYqiqrStLinQcGjPJtYYyZ04+gmbjPIKE2p9Yw7w8wK+fEzNzO4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVA1b3g3Nm8zSnJXU2Iwd0k2QndTa0dhOFJtaHJjWDdkSGg3M3RqU1FTT244?=
 =?utf-8?B?cFgyaytJRFJmVE9Zdk5SZGZuZ3lSQUgzRzdDNm13V0EvU1ZXRDAraW9vd01j?=
 =?utf-8?B?Um9kNkhrL2FHL3owY21hTHJ4L0NQVm4xWDh4T2p6Mkl3WXdpc3NIYklURHRa?=
 =?utf-8?B?SCtyQkJzVXBadkRqeDZETCt2KzFQclpHUzh3UXFLUGdnNHRxZTRZR0U1MVM3?=
 =?utf-8?B?dzVRUk0yMXJYWmRNVVM1dHd3RWwyZWFycUMxSFk4MmlQUHZZUkpTcWFXbkQx?=
 =?utf-8?B?U3hMYk9DT2lnZ29JRG1xVkRNQlRvcS9QVDBNdlQvYnV1WEtQU3pKUDVZV2dL?=
 =?utf-8?B?bHZjZXFzWDloZC81S0tGS0UxQjJqaUhTV0JzMjdkc05kbld0YXJJcWg1RWdV?=
 =?utf-8?B?VVNVaEk5alUrSlVoWjNGSzJvb2plVG5yenN5aStDWVQySFJ0TCtWQys3SDZX?=
 =?utf-8?B?YlduQTJHVCtDeVI4N2xlSHFHMG9lU1J2U1d0YmdsbW5VNmVULzkrcHdXSEtD?=
 =?utf-8?B?aVlWWURMZEtKbi9uSmk5WmxMTjMyTGsyc2xRbUdzNCtOS3B1VjdHU0lvL3pK?=
 =?utf-8?B?enpLM1F2b3ZPc2U0RDNyZWVUbzQwZklpR1Y1OTRqSE5NQ0pOQ3VFRmlOVXFM?=
 =?utf-8?B?ZjdiWmVWd1dsMWFieU9aYzN3Z3NqbmZ2dFMvY0VkM1Z3MHFHRnJtcmJjc0Ix?=
 =?utf-8?B?OGdZK1lEYkZUb1VpUWR6M2ozWFZ6T0JBcmFoQXNrbG1KVDdOK21mVTBHam12?=
 =?utf-8?B?bEM1K3BkakZHeXBjOWZGa25jSk0renFzMW9hM1ZUMjZXQjJseDVHZFI2UVh1?=
 =?utf-8?B?aDZsYUVwdHk2VGo5UU9xY24zTlZhdkh5c2RYL3A5NGt0c1NkSGoxMWl3UTJG?=
 =?utf-8?B?MUl5T2s4SE1qbGptbmNqaGt3V1liOTJ0NzdtMFRCRmM0clo4ckkrSER2N1Yv?=
 =?utf-8?B?NGVNeGM5MFB2NXVuTFAyZjU2NG00cHowNjMvSlJlWnlzNkJZT3ljSTN5ODFt?=
 =?utf-8?B?YytXTU4rNzVza0JnTVFVQWxPOUVlWkFZK25oMEc4SmlZenJkazlwWXFhWStl?=
 =?utf-8?B?dUhWN01LZG5yZXRJV2x2VTJUZ05nQzVveG5PaWtPNmxQdEhvUjVOTGh0TFpw?=
 =?utf-8?B?a0h2bXBydVFzQVM1am9XNjNTY0UrSyt5ekxqWmxiR0RFdVlVWkducTRQWjBF?=
 =?utf-8?B?ODNmd2oxa2Z5NDFCWXl5c244bnl5L2h1ZkxyN1hHL2NkbTFaQldpRFVyOFZO?=
 =?utf-8?B?OE1VTUV4SkZwMmV0SHlvTjk4U3ZZdTQxUnJHQmx5RzNVTTU3ZHo4MTFoQ1NO?=
 =?utf-8?B?T3FPbnoyYXg2cmhTWkZ0bWZiYmtONTFvekJrNnd5YVBsRHpleXdmUWVRRHNr?=
 =?utf-8?B?NnNRUmxzR1FyKzAzUFdPeWs3UWRGNjVIMHk3MlhqTnhVYkxXaXZKNk1zVS96?=
 =?utf-8?B?TTY3eHlCdzRIdGIxempSMTlDSFRBL0FLSG5RUmxHN3dkZmMzNnlYb2FVRDBv?=
 =?utf-8?B?NGM5d2xmdUhVcmNZdUJ4WkJMRHplSUdtVUM1cm9aRWJWMlRDWmRyaXFWN3Zs?=
 =?utf-8?B?bzg5K3VleEpZMHR2NlNCa3lMbTlFcXNLZ1A1Sy9ZeTYzREJLVEFna1dDVlpm?=
 =?utf-8?B?ejRIY1crR1dRZnJ3UTlQUVg2OTA0aTNtYlZWZnF3a3g1OHhJSko1eGYvQlI5?=
 =?utf-8?B?MlJ6NWZUVkJBbE5hVmEvU1I2bDI4Wm1vWGh3L25QZ3NCMGJqZlJGVXltTVRl?=
 =?utf-8?B?R1I4bGtERTVoYkJaVmtQVDY2c2NqL0tHbllydHdLYUIzYmhZUWFFdU5oQm01?=
 =?utf-8?B?Z0JMTDE0T1BNdzNCbVJmUnNKTWZHeVMxRkQxQlJ1elJBVHVMRDRkZnZJZDE0?=
 =?utf-8?B?UEJoaWdvUGtQZ250VTJmQWhOUUJxM2FiTjA5cExGc0JSZ1lMVkljcVlZM0tF?=
 =?utf-8?B?dEtpdVJPZmJXTERwUHhCUEZBOWVHRktZZC80aXRtTS84aFBqSjhGRmxGeEJZ?=
 =?utf-8?B?dE16WG1lalliRUFjRy9lRFZRdlpsb243c1VsU2IzNkExMUFnaWZSckRBVGwr?=
 =?utf-8?B?U0VTL1JpZ0prRUcyZmRpVldhZjlpODNHT0g5TGJmbEs5VHhGODd6TTExM3Ev?=
 =?utf-8?B?R0E1OXoxQXdScXdHcGllbDYwTDV2VDZLalYrbEE1SW1oZ3NRd21lNnJkOG5P?=
 =?utf-8?B?bWJxaFhaUFpXZXVpZmlIT0pGUGxyUVAzVGN5WE1xL2hnZDdtSkRNaEpCS1hr?=
 =?utf-8?B?TnliU3plVW1rNGJ1blFXWFBQUTJBQXFVdTFoL1MrWUhKSHplU2ZWZEpUVThY?=
 =?utf-8?B?MnQ2TVB4MGwyM0FSL0hjcjZkNHJRVDNDV3NhZjNFeHdmdzc1Y0paRlR6Ukt0?=
 =?utf-8?Q?P+87gBrzO/7jmMBw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EprtKNwoBft34ZSlbZqztzM4C9QfWqqkPDd00yCej2R4BXtL8Ky+cD7NsIUIJcNaomqil3AJp00zJ2B3csuvamVVy0vziTveh++VeDyV8hiVQ/IkLAndkkLLeWoztjjv9+ZthNYkDN1smDX14i5Dp/qAuC0yBtD+ynZ+xcHKq/jgiVnj+9hNDNKB4jLymE9Br16lLKJXRnMNZ5l7qeN+UpyLI5jxAneIF1kWNWdeHm6vLPfKHxgWFzd4v9sqV3oIpJdRjawvDgEsEp3mdBql+f4SW0pxJ+zWFqwpjE+YqinpLPgpY/15XM07vOWD+3HvWSE2bzcs20erBoQsRDPxWL9V79ihRZiKZpMp3rW6ThPEOJbAf5FBAKOch5kgBRB2y6ys48xRtiBOCCPDjISyQ2NNiMddJw+4AZkacZRBFnHzNibEDbMghBs8fn98O5c0T+7k1FginuQ0qxd6Vb9kWK1A0gLgtrGxCLF2s1AZUsBQRwvQam4wGdpDwzwwCKmPANELGF176JEVPcGiPHno7+qK7pv8Q0iC5DzloUezpbOaOlQs0TAhl8NMSMtDYXOX9u+jE36AI8ttQGeEtAl3uCuHd88fAj3JCg/ylR5E5ZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b594d34-c306-4b3e-d2e8-08de78f8e183
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:45:46.5386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O4SezrSF0iJCpKv1WkWKUJ1IwFwXWtlvxldNBln9HIFf2U9bweTL/s3KmRNmINCdUJz60Z4heaGrt3/CxOlCvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4965
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030054
X-Authority-Analysis: v=2.4 cv=QOBlhwLL c=1 sm=1 tr=0 ts=69a691ae b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=aLr7KG9LF7g6hMyBF_kA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: sVAtoik0vfnL3KBgEstLMEcyNoLPKh8T
X-Proofpoint-GUID: sVAtoik0vfnL3KBgEstLMEcyNoLPKh8T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA1NSBTYWx0ZWRfX59C4sFRKoccx
 MIHPjkPWaRJmEd4BtanzZy4Pjv6mu+uAhVk8UXcQBuggI8UIPqmijkhu9eYJ1txTOB0XseXICFL
 FFlNdOBmuS06/hCWwuN32dIfmRJ0h+cntddRIDktj3FbAnr6k3CrmhNaw0txYOhGQ5ZLhyBka+v
 l0WrcbpYNvEJCpfD1bkS7ZgB8eivaBZgNW8oXPP7M30uLfaR+7U6XFUB3nus9FMjCf8jf5FB37i
 Q69PpMmXnhJnOdZcEvKaEwwhzuAMAZpQSWbjDhj0dVRXgoW/a+0DUSJKrODGuWSw0z6qXM1HEjt
 dvbKo1kEfKWYm0+/jLHDzFveFCc6NXKKlIZ51s3mPD0+1ICWB8XO9uS0UfdxbApBgx6akQpmXe6
 KI2j2XVcFI7SNZNmzuJtgjxW4GOyhCNfikj7v1w4n4+KxuMlShpOXowr7f6hLD14UJxwEQShvk2
 9P+TwEK3SNV2Zv+ER3H3+Eouysn5aSVY+JbkuB/A=

On 03/03/2026 06:57, Hannes Reinecke wrote:
>> SCSI multipath will only be available until the following conditions:
>> - scsi_multipath enabled and ALUA supported and unique ID available in
>>    VPD page 83.
>> - scsi_multipath_always enabled and unique ID available in VPD page 83
>>
> Why don't you merge these two options, and have
> scsi_multipath=on
> and
> scsi_multipath=always

that seems a reasonable idea.

Thanks
