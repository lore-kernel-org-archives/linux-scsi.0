Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE7C3BD625;
	Thu, 26 Mar 2026 08:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774514854; cv=fail; b=HUgyskzo3y239XloF0C74s6hKvO5lhO7LcsFHGtWSJHabU55axMvbXQFbXJGbY7kZ3gEBtZKnjYjP2K1Uj6zHIjBk+vYnROxIMhfxgxXaXfTJS6WhFJhF+eREsNU/k/nFc14QLQS8Pg76XgpFbEINEePTbmbIDvXBxGNENDQP94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774514854; c=relaxed/simple;
	bh=KMnzCjq2hKZQ6PiH62+HpTskw0fwj6CjTAdKHjOWAQY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CTubLVZ+ftEwpadf4QC+vk/2xFg/Nc0r5spypz1uxTppqzNp82Y8rHk9btGxn+4P9kzeXR0fiXkXtr5vCxZ9wF6qsO5q4SUf0ac7MCeDYlbM0HebW+nxeBSaOzk6Uc3d16kskEYsfhZeWuhbf86nj2klNNfP4/u1Fy8jVKcTtak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=PHRJ+jGl; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="PHRJ+jGl"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62Q4C8WJ174395;
	Thu, 26 Mar 2026 08:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=DzTjye5oP
	I5g/UJS6krZMMng+bbL35aDeeNsb+H4F7M=; b=PHRJ+jGlcFBDt59yNqirbgzx9
	dg/H7rrcpVnGTFw+CIR4qBGw0cA3D/4yQBnd6sguOQAB6q/auRICkvWl0/K5xACY
	foHo5f2Ll2oc+e1WBX5KfisHbFK8PPykSexYVKo3vrjT0tC0ecUgKENEwq7n70jj
	+lYo4GjUBAPXThtF50sCPl8GQOyjZjz0FBLa2OpMa9boXhhEVaUMPOgeVEoZupIc
	c94XadCPDi6G8/Xrwanga/wNrsvTfpJCkUnIE07YlEKVPRMbIZ0QCOYV2ZKjYsFC
	I7aL+XPnX9vmP8xPnHfWLzGxo3pM9OcqgEWvR3Zn0tGf6Mbknw3kRqQ/0yBLw==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4d1ja6x7r9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 08:46:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TGZm4ArArM+fWbwmviTqoXgBHKTVBkVPDrgqakrP8/d+rDSWxlHOTNi84sWpmd/4LgjeDwW9XE0JFus+IFf65KlJ//GGoBnYp+EC5MWkjAuXQatTJlezHy9iYUBFkyhdMT69YusyAae+L2VJCrzmOmWjainIHYm6BHszvkMS7UdQOixWlPIKlKDV+l9F09i8vJYQB+Xim86jdl4kjvKevyQ6t6lMOP3S6SjiJ9ZzbbQfnr08aWTee7ox2EskmB3r9PK0dvSyVUSAyrVyaePHKxijt3wKSI87iZshoBk8IG1THeVRrji3pPAd9vVN+1nolLuS4/GffMeF4r+tklMQVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DzTjye5oPI5g/UJS6krZMMng+bbL35aDeeNsb+H4F7M=;
 b=eEUD5S5lLhlbiiIaMYQhFjzYHIsTU6OJpDKeHmCym5mda/pJLwUMmTW5p7AFWIjLSzgKxyHdUfICOAVFgCPBKMmn0XjbXDgU76Msfsq9Wc0MXw+/J5NNBVZ9hMJ6VoRVE001SGzSOvsnvqE4jxrhRT5nK1WpkMbvHt0ViB08NRjXk/nrSbr+6I5L4h77jwMDCKm4CF9dGd+0mTGuk8CtUt6PVgsH53Jlx9++YpE42pdgJySuldlbEu83jumVyLR2F/HBhj93/hqtSvAH59o3oxokqcBC3RSfxqyB4DdjlmN0oPxbzEkCZiYEs8RtWCPNL0/F4kskXXcmmWOhZ9UglQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by DS0PR11MB7406.namprd11.prod.outlook.com (2603:10b6:8:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 08:46:57 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9769.004; Thu, 26 Mar 2026
 08:46:57 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
        m.szyprowski@samsung.com, ahuang12@lenovo.com, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com,
        "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Subject: [PATCH v6 0/1] scsi: sas: fix mkfs.xfs failure due to bogus optimal_io_size
Date: Thu, 26 Mar 2026 10:46:43 +0200
Message-ID: <20260326084644.27162-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0372.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:82::14) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|DS0PR11MB7406:EE_
X-MS-Office365-Filtering-Correlation-Id: c6be8b7d-b891-402c-8738-08de8b143cba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|52116014|1800799024|366016|10070799003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vbc+JgqYCAtKTP1BtTsuaLd/8fUDsNAceIHvCKuMV7n6CUkxq29aeGeoUU5iHElmmf5By3wiII2etnYMSU9kYiwzYfZeE8tfHKk/Un7nU5zeY4L+qMuuqjntJtwqUjIsazGYNb/VEJzh8uSoddcyhPyGLezP7U4b+D3pH11nZc41U+Z0uCWSoth+j/Dp8NtaV1HcWax8DUmVlEhPobultQ3MA7NWTvfmT1ON9jKmjSJQ9ypBTZaZWZXFiv4Ei3zvzaNJIVjwFNIGbDWoewEsKqLJb8Y3oVAbPL/vh/kaKWXGXoJiHUQvuRhnFLOZMqZHTzhBuUM08BXid4wRRAZOPak5gRVXxdtY3/mdmFP9wQ2Yp4IF6fKB4606yx/MRGDw3aiRG1lJBNJRRb4WE2rnQSnqT5UBRrpJ1ewQPHMUf8Vvh03774vySVzmIfRLKM8vTxFyNNSHhBliFuXfGEHsa8LCYVnQkhzkrdeN6nXyYuZprVEKeW/f1EpPAJa2RvZIQkg7mSo7IBb7bKT6iWJxBCP58Vggn10KzoYk++8uF+1+nJGABbW8Jd6k7gMW4uXdlQLuz1CojFqqziFwoDiDXKSXwm7zejUG256NOUAIj/6iJ5srohYcSdDmF903T7s2Hm/92T2gl5t9rHdwrojVylvm9b85rtkH6YGZRj3odfMCaSmFxKf8jXHVnTsRlTBhlDql83Ott9zDlElO+fFqO9uU7UycwVNk26sySSzVYPDS/UigLcKmqxL1mO0+2MKn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(52116014)(1800799024)(366016)(10070799003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEtzTTFNZlhXQ1Q3bGRSMVRCN0F3WVZGTTF4Z0srbDVHMlg5R3NWd3lJZGhN?=
 =?utf-8?B?VHRxc1V1NTNVQjluUGxPcU1KbVo2SDhSYTM1YkFHd1Y3a3EzTG93OEl4V2oy?=
 =?utf-8?B?aW5SRWxMMy9Vb09iVjNNNUhWQWVFcVpkbThHYjlTQXRTNWQ5R3lLS29QS0tT?=
 =?utf-8?B?RlhJZDZ2b0hpbURvTTRmSnVkTW1WbFNOVFl4TXdHY2JlS0p6M29waXQ5TXRF?=
 =?utf-8?B?cXNMWEU5UTQ4c2VGU2l3Y3E4TElQUUFVVXlLTmQ1bGh0b0VBTVYrK085UHov?=
 =?utf-8?B?NC9YdVVzbXkvZ05RdHlIVmEvcCtSdXp6R1BKbnJGVkpCMGdXbWVEV1BRRng0?=
 =?utf-8?B?a0VmSW1DK1kyREY0T2pETGVVMHM5MVV5M3l2S3ZqUEorV0tndHlRSXo2blll?=
 =?utf-8?B?Z05aUnBHVmpmRURhUFVvWEZEV1NPa2pnS3NDQkcyWGFNcHdYeXdCd29mMFZH?=
 =?utf-8?B?emJ5bGs5RHZTSWw3a1dQWU85S2FHVkhNMVVRczhpSC9ib3FtN25oVG5aU2F6?=
 =?utf-8?B?NmxhVzl5elZEcXR0VDVXeWZpQVNjbUt6eGhVLzdoazNzd21rZ0xkeHdYemVC?=
 =?utf-8?B?TGpRakd4dW1uZ2FJOWY1WGIySlBwbFpvTksxeWE1R3JISlExL09yYnRGRVk4?=
 =?utf-8?B?UjRVK1hNUHF2Q1JYOFdGZFBsTFdmK2xCQjFnd2JTQUo0c3AvYnVJM21EV1Ni?=
 =?utf-8?B?N0ZzSWdLUzg0Y2ZGN3NXc0xOSFlLWG1WNnVlZ3p6RzhxRFh1OHk0d1J0L0JV?=
 =?utf-8?B?ZnAyTWlibEwvOFVZZ0tIVGpyVTlYV2syKzBub0E1WDh4cmFNMEVJRE9FeXEx?=
 =?utf-8?B?dTV5eGxzandwQnEvNElUR2VpcXMvazVpcmJTVXV3VVpPdzNLRHJkVUxnZ0ow?=
 =?utf-8?B?azlUeHdZcG9UTjdyTDJnUFM2RHFSRm91a1BUSlpDcllNVXpkc0pJMVR2VEdM?=
 =?utf-8?B?dnBOOWRTdlczSXBqc0lEYm5CbHFpMHYwZEN1S0k4Mmwvako2TTBucnVxT29s?=
 =?utf-8?B?MDMxZnRXMmNhdzhkR3pQOWdwcjdmV0NjU2xkOEk4Qnd6Y0J3Y2RKL3pPSWZt?=
 =?utf-8?B?cHM3TXIxM2Vnb2d1eEFqeDU2RzBqcjlnY3RnSHZkLzdEc2VEdzluRjhNSnhy?=
 =?utf-8?B?K1diNHlCMW50b3QrWWIydWJJbklrY0RtbXBwTzVHc2l0cVZ3NmF5dTNiMWRN?=
 =?utf-8?B?bm9JVUZiUHFuY04rQUR3dEx0RmREK2lrSzhSNVJqRGJVVXVVVTBqODl1N3ZD?=
 =?utf-8?B?QmF5dWoxMzZqSWNIWFB2clBtNUprelpXREFWc2VzQm9EME81UzduUEpFdm0r?=
 =?utf-8?B?bDFxU3dKRFBzQVlreERtVi91SVp6T3ppVTFkVEpNM3VNMUlzTm05QUtmd0RN?=
 =?utf-8?B?N2NobTAzbXJDaXpienJwQ2pybEVpbUtPTU1hU092VUlQdDVtN2x2UE96RGhj?=
 =?utf-8?B?ZG1XUU5tUjRnS3FHYWlPRVQ4OTNjZ2o0L1dYOGgyQzN0ZjMyRWVJZjZpcDQ0?=
 =?utf-8?B?VXpHY1B3eVUwNmx2UVJQZ1B3UlFOQzc5YWQ3OVJSZEFGRGliZVpwckFDK0NU?=
 =?utf-8?B?RHMrL2FFMU5RTzc5TFVwNkFRTHRSYkprMC9KOUJOckR3eWgyc2RaQ3JYQTRV?=
 =?utf-8?B?SmMzMFE3Q2Y0a28wWCtiTFBYY2ZWa0Vma2NQc1RBMXNtV1FybGUxN1cyeXJN?=
 =?utf-8?B?c0tKR3NYcHUxdzVLT0tBYVJxd1h1UEgzR3ltekt2VlVhQUNLcDd5RzRhR0lU?=
 =?utf-8?B?dGo1SFRQQk5KMWtyY0E0YVliNXNPNnh4c2UxYkRKeC9KWFI0QTNkNDJ3NS9t?=
 =?utf-8?B?bFF0MWdGUnR0c0MrRmttR0tFMHNRUFNkQVZ6UlkzdGVCbE95MkZZSEN4K1J3?=
 =?utf-8?B?djhRcXNPTmdUbHJzRVdhdXdUaktoWmZWTXlHa1lPRkdLaER5eFNTTWZHT095?=
 =?utf-8?B?dkpIVWpYcHc4VEFEb0FpY3gzSXZmblNCSi9wcEJ4OHpWUElYNFo1M0Z6Q0lZ?=
 =?utf-8?B?SjZSQU9jTkwrVGhjUEZBUWFhNGw1TUw0NlJqSjVad2FGM1BTNWFqQWVHaUJt?=
 =?utf-8?B?L1FHazJ4NWdmVEkwSzVCeU9HNnE0ZE4zcnBlUEl5TzNob1Z2dHhCL3JVK3Y5?=
 =?utf-8?B?SzhYMllhMTdNNkRHa1JkUndDNEVWSlBReE96dFlYcGJaM1Z1Y1dhYWFMUWds?=
 =?utf-8?B?MHJNYVR5ZTdWaDFLdHNseE1CTVNYWW1WWFpnOEgrU0tZYU1nWmVrZ0s5a2lw?=
 =?utf-8?B?ZkRicWE1OHQwU1hDaUpjY3RzMVFsL3BzNXYyVEI4Nzk1NXBxWE0rTTRTdFNM?=
 =?utf-8?B?ZlVmaXlVbitmYi9KWjNVc3o4djI0MHhKK3l2b1lwcGlRL2RKT0xSd2FpcFpm?=
 =?utf-8?Q?hKQhh4QGB+CDUTZR6fbMJ2RGjAlvU105YF06m7WcWoX0x?=
X-MS-Exchange-AntiSpam-MessageData-1: qvgH/rhRfyYZdoBMwMdY+OOntrZ+adR3d0E=
X-Exchange-RoutingPolicyChecked:
	fVv3kxbn1yIYoAS4zsTotXHPRgcmcaPuxHDw7otXLFQWOpUK9//qjts9rnlPMSsblUC3jty7GL9j3bZVlXjSKL7bcugF0srLe9FijSLcyXv82du+cvMbEBI02LISMJjg2ItSaJKg1qPfoIv23InxIcRr/AQbXgluyDnF1uAtS1CSl3yAeke43kWEviB7jCaD05RRHGHkcJx1ePCVnnvJI9RrtdSnorfmG5q5YMg1Nw78XMtg18yFUxTebQN8cGfpzAmWjvgmxVlAC2UT6wlrazxDF4pSK1jolI7b6OI975UwOoszp/R98n/WCYjZBm/6yl3a6c7hepZisDxeMqmP6g==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6be8b7d-b891-402c-8738-08de8b143cba
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 08:46:57.0706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PkLZBExCZGSYtR7yXnTtetQMORoU6puuLd3nei4gQUebABufOCEMyCLwvMXr9R8jQ5crN2OS/1UfSzcL3uRxz4duB4G+Dv+lMshUm+OKnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7406
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MyBTYWx0ZWRfX4N5yiR7Nu34J
 CAKGC3RqlM6rYg0wqyhVlJvNWfPQA8JQq9Z5CwaIIhxsmApa+vzWlg43+wouRX9sZCbZgBU4qgV
 2C3ruSV/B3Pa9q/0L0XyzHZZ+HfbkzycidmbjN+kPEPHr0Bjb0fVFMx6NQYSCYQOi7Z23J7NgMi
 +VWvaz+DpOoSrwnrLPgVs/1k/z9qyx8SuVbm+USAylhxf+/PVIztNxgikkKG6M+RvKfCFq5gZEq
 02pjehKOlYxLDS3mbadW4nnKwzoYDUzXHmLdotppbqwqWd5amfTRIXMF1JbAfsMCuU1bpFmo5i6
 DP7ZfF/Mu7093BL2WHBaFltEjgjDXAmMmh3T9UyneY6MV4/24XGEPXnxuarxbpCj+M1bSENHakY
 a6HOWsJAoxPeXGuqQBb+AW8QUBWjyUf6IZFN3A/m5dBNz8JCXDsIfkGzFb1EhxbYuw+6aOkUtf+
 jhHpLSYxbayHfR5iTQQ==
X-Authority-Analysis: v=2.4 cv=Q5vfIo2a c=1 sm=1 tr=0 ts=69c4f283 cx=c_pps
 a=SvXgiSASQu/JPdBzctYFLA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=urdyW-3pIPI3pqeIDd0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: 1waCzA6XtmIFCcw-7R8BKlIsGLA6qrKS
X-Proofpoint-GUID: 1waCzA6XtmIFCcw-7R8BKlIsGLA6qrKS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603260063

From: Ionut Nechita <ionut.nechita@windriver.com>

v6 (per John Garry's review of v5):
  - Replaced kerneldoc (/**) with a regular comment — function is static.
  - Condensed the comment to a single paragraph.
  - Removed WARN_ONCE for opt > max — not the driver's job.
  - Combined the !opt and opt == max checks into: if (!opt || opt >= max).
  - Apply rounddown_pow_of_two() to min(opt_sectors, max_sectors) instead
    of just opt, since max_sectors can be any value.
  - Restructured as sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
    with the dma_mask check moved inside, removing the need for a
    separate dma_dev variable in sas_host_setup().

v5 (per Damien Le Moal's and James Bottomley's review of v4):
  - Expanded kdoc, inline comment at opt == max, guard for opt == 0
    before rounddown_pow_of_two, trimmed Cc list.

v4 (per Damien Le Moal's review of v3):
  - WARN_ONCE for opt > max, min_t overflow protection, reformatted
    call site.

v3 (per Christoph Hellwig's review of v2):
  - Extracted the opt_sectors logic into a dedicated helper function.
  - Added rounddown_pow_of_two().

v2:
  - Dropped the dma_opt_mapping_size() change per Robin Murphy's
    feedback.  Single patch fixing scsi_transport_sas.c.

Test environment:
  - Dell PowerEdge R750
  - SAS Controller: Broadcom/LSI mpt3sas (SAS3816, FW 33.15.00.00)
  - Disks: SAMSUNG MZILT800HBHQ0D3 (800GB SCSI SAS SSD)
  - Kernel: 6.12.0-1-amd64 with intel_iommu=off
  - IOMMU: Disabled (DMAR: IOMMU disabled), default domain: Passthrough

Based on linux-next (next-20260325).

Link: https://lore.kernel.org/lkml/20260316203956.64515-1-ionut.nechita@windriver.com/ [v1]
Link: https://lore.kernel.org/all/20260318074314.17372-1-ionut.nechita@windriver.com/ [v2]
Link: https://lore.kernel.org/all/20260318200532.51232-1-ionut.nechita@windriver.com/ [v3]
Link: https://lore.kernel.org/lkml/20260319083954.21056-1-ionut.nechita@windriver.com/ [v4]
Link: https://lore.kernel.org/linux-scsi/20260320081429.42106-1-ionut.nechita@windriver.com/ [v5]

Ionut Nechita (Wind River) (1):
  scsi: sas: skip opt_sectors when DMA reports no real optimization hint

 drivers/scsi/scsi_transport_sas.c | 38 +++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 5 deletions(-)

--
2.53.0

