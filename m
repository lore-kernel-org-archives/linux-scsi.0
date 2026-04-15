Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F7839A059;
	Wed, 15 Apr 2026 07:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776237592; cv=fail; b=Y1tOl0U3dA3JRM5sEUcgmtEqCtof2cq4j1ivvsx6V17FaiYF/xJgabqZzSBt85S7wfCKiAePh10ND+/G2UaIYTw8sA55XK+F9fLB4WZreEcJrnhagtr+0wNEDpOe5Mo9jtQq6W8cLAYe6eaRv8v+mozXoj22YGz8+E/5C2QFrXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776237592; c=relaxed/simple;
	bh=0FUa0yNP5H5Dda4eKY9WuCtLff3+lrSFlW/WtVXsgb8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mLypBA0mS1NBAq/cTxp5/5I7+T62uLrkLFjx88PL45lLT3CMTS3Xvlr30HZERRgVRjwPULDN3j8VFwDAs33t0p5lLRzw/TH61UafP7levArIkfVykQIac3Ea1mqCoQTSCqShtVlLBe8Wc3VSGL66BprK1MF5wgDEmbTk3GFxL0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=s2vQaJIA; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="s2vQaJIA"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F4cDds2656125;
	Wed, 15 Apr 2026 00:19:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=MQehokm0z
	0IhTNiFcooJhO+AiiF3EYP2uW7m+03OSh8=; b=s2vQaJIAXY2tpPiqj0JO+m8aN
	6TwqlszQOvyrwmFR6H60+xz3+vQbH8EabDDoKn2vVWEd/i/o9gjBn+WXSSbhpLyw
	BwlsZ1K2FKnLrJIs/CI7F5AH9zHWz7wwKBMMPG782tuoIwzCr24vu+1OVdMpTWNe
	Hd3P+sNsHkHpUSZQs8UkTvI1r1lGhaL67qnOlSmINUICmxFPDSL6/4Ky/nYVCssk
	KTBq5g33lKyX8OYejhwvYt8s7wKgvo+d416Wz/9ZadKlIHllt4MgydVYAduCnK5M
	IClLj8jmzSZHpv1k5h/jLbxfGrR50LKpQRIQSSqqCxTLJCP3l4yGm5n2DpF4w==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010047.outbound.protection.outlook.com [52.101.201.47])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4dh87mspmn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 00:19:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j8CtUdOaU5qMJdhWytoUhJiYzuE8fv25bMqpEf0rpD7fKjM2aUWkRT71yQp+o0WTEuEnwusD34x0mQ2H6Eie0wzOcTT1/DBc/L3UZ+gYNleiYH0tyFOrUT8ZKDCPdvyFg3qZjOtkxtW04ZVWX84a6BVtRq4VBiyxIkl5VISKqPCCt8ly9wHOdfShQBIG8N8m7rywI7DWTsmCfFTToaQJ3ZOc3H/BHojlJQxJrzJMVuO9Mjzoi758DhqzNHz6Cs6KeEezpD5Vv1YR4pBKQ9agJbzblaB6HyTruFpy9744/7I2f/1Cnsei2V3D8qXatWCr9OTnLSbJr5SwjhnMbQn4yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQehokm0z0IhTNiFcooJhO+AiiF3EYP2uW7m+03OSh8=;
 b=PtfS3njmA/iu7I6XdrJR0qoVXS5p4vgYgDvhDubuD0B/T5uax4MQY8XIm3CBtU2EX/7hXlmDLSA22wiCo4CiVqEA3ubq8+SGAFDQncXsaDXu9ODfokgIu3x9KLMI/dGyfz5cPG3J1w0FEq9jUtkozMQsLbvSpdypAaQlvIi8HXZi5/MIT3cpZ/U1k6jponPeAvUCmeUvby5aKmSeGR8SsmPKgzYb5mHdBdh7ip9N7X5mDmicEAx2RTeXpVOSm3oFabmQfMFte5y6+IocpUKLmn1BwExf792c4g74kmRnszYV1QnXawoyYNHkvtLmZMG3PopiK5Z/+cflCUQpXH+ZhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by PH3PPF4EB9556A6.namprd11.prod.outlook.com (2603:10b6:518:1::d1f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 07:19:09 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 07:19:09 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
        m.szyprowski@samsung.com, ahuang12@lenovo.com, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v7 0/1] scsi: sas: fix mkfs.xfs failure due to bogus optimal_io_size
Date: Wed, 15 Apr 2026 10:18:48 +0300
Message-ID: <20260415071849.25693-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0137.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::21) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|PH3PPF4EB9556A6:EE_
X-MS-Office365-Filtering-Correlation-Id: 7131cf72-5b70-44ab-56f1-08de9abf495f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|10070799003|376014|366016|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4HIVXck6Gy+11+eQ9QnhCM5Rty56HkWMoeFVFEO+SGsw0/mJMaFTuQzTEBlwcZ4ZXUoURPuET0TIQaZUE6uoWI3JVRCEGYhVnTeRNvLzbLBAdq/8Gv9j02k+PNx8kJyRx3hxH7cRmOeIwUPINhm6Myvr+7uC7e64dmrjCvgBgU58tJOM5VG2CK0zSBPxezC5H5SX+BEMR+MelAahQyAMP5GKxbSEId+WnE33XFE3/mE5WeIlk1U8HAbOPCa39wokunkoG/yVx0ks5vg0fbD+a2i42r3rGYagb0fofrKfcXRotEyiaUAg+QymHUwR7oi3u/+iQdsc5Fftz8CxzD248FB2ul0g5OVhbTn2XpUWhhmjLPBKGV7UjdgH6cCXXYbldCiUOnRihQBY0qyQ6oZ3AQUypRCTyMsG/lijo5xduYL0XXPeenlK1U4t9REMIY2t1NQs7kERSecG5afZ3n2xb2hL/mR4kknGmUtrO13UwvRmXcH7Ci7w9wdrpVaW3pu0zGMscS9SUjoQ+FxHXo5yoebr0j8J0JMN3CFwZ3m0jcJAzPLPOPbNGkvR3ErU+gMASkrsqMdqR8YLBvZ7QLEOPPTeauS8uyH+/Td2aET/BgRmSP7YO9kfFjv36rjF36avNb3mEih+tq/DLnLhqNxKEcH+LPYG8yWa+Fnrl6GZj/B6apA2vmnI+AF9CjPZkBjIt27SlYVbFrf++/M0U0jtLELwFdAFziEf9fuse/X0uDgq9gXUSucA0G8k6/m6WLli
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(10070799003)(376014)(366016)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2JjRjRSVzE5Q1VVejV1aVErdWd3em45VllBVENkZTM1MGFGbFA3RytzTG80?=
 =?utf-8?B?Q3ZTdm1JTHBhQ2loTGNSZ2IvdUltTWZVRnArNUl6LzExWFc0NGdZVlFWTUw2?=
 =?utf-8?B?T28zaUx3bUlQRytyUmQxaDZKTVVKK2dqWnZMSUJ2dURJeWFQZHhJMHlQaGM5?=
 =?utf-8?B?UldCWDAwY2IvUzRmRXNrTVlneFRWVjVIc3B6ZWVjNG83d050bUhickExeURo?=
 =?utf-8?B?OVpXYjV6dWF2Q1RjNGN1VmE1Y3VWbVhFMjNLQVVUUFovakNsNG9CUGxQR0VW?=
 =?utf-8?B?d0dpc05xQk5ybjduV2xsbXE5dTZnZUM0NjdVZDNCMWJrR2g3dGN2d0FnQ2Ew?=
 =?utf-8?B?Y0FSR2Q1Qi83Q2FzOWNtQU5Vc0hHZXlvVHNJY3ZNOWQ5WUxiTEE2NC8vM3hC?=
 =?utf-8?B?QmJ2UHpXUndXNUtmTTN6MExLaTUzM0RDbjBqcCsxMTJQdkpsTjRVMW9LUmto?=
 =?utf-8?B?L1h5aldnODcyUEMrWGVnNUhYS1MxYldRblhQUG5sUnhPMGx1a1IwSWpGT1RC?=
 =?utf-8?B?MTZYSkkyZ2xIazBkL080WVpkdldvMW5HbitZSGhUOXozdmgzOS9Gc2hORlNF?=
 =?utf-8?B?cjRIYkR4L1M3M0JRcS8rOEJrOUhYRjdMSFVkV0dQcldDclhEVHZVc0hzM2dV?=
 =?utf-8?B?Y2xqN2Y2YmxKYXF3VnhwQ1FHU055dmR5WEpVU2hvNEl2aERKUmtEZDgrTndO?=
 =?utf-8?B?aS9wQmxwaGtsQWRucmh0UTJqcFI3dlYwdXQ4TWk2MTJYU3dLVmhyUGVsbDM5?=
 =?utf-8?B?NVFpT0NHZnlhSHRtSEpFTmZpVHZxUGVPekZEWWdlelgwZXpLcmNjUkc4eGNu?=
 =?utf-8?B?c3IxUzI1ZEk1bloraUI4TUZpY2w5QnN0RkVmS215bjFTNlB1MFlqU0Z1K0pZ?=
 =?utf-8?B?a3R5KzdORWY0YVlsVnFyQVZrTTZFOFMzZGF3ZlhEbG5mMm50ZG9PZExaTTBv?=
 =?utf-8?B?bUo4bmhQN0pQNk1mVVNZNURXbTM5V1hTTWhyTGg1WmZ6cTRCWGo4RFYxSnBu?=
 =?utf-8?B?T3k0bjNmbnBlNjRzeDF4QVkyejBRZzVYcE9tQTA1UUU1bnhLWWd2bFBOVURH?=
 =?utf-8?B?Wk05bVg3L2FoMytxOU1qV0RkMGtpZkk1T3F6Q2EzNVR5Zms1c29QNzRxTzRB?=
 =?utf-8?B?d2xkOUNYMGZRQ3ZXbkFqeUszdnMvUXlKSHRjRmtYZUxKcmM4K1YxNmhsRlc1?=
 =?utf-8?B?SlNlaHRpU1BRVHJoVTZxU0IvdGp5bGhCQURkVjNvUXVraGZ2M0cvTDN3cWVs?=
 =?utf-8?B?cEtYYmVFTTB3clF6di9ocGFXV1dNQkVLU3I4eDN3eDB2dmpKdzVaMXd3alZs?=
 =?utf-8?B?cHJLb05TQmpCc0RrQ2ZXeXFRZ1VNSXVHZDdYdkp2dThvcENlVmZkS0kwUmhP?=
 =?utf-8?B?Q20yQTFFQVJYbzJYdVltMitMSk43SFV6ejdPR2d4NW9Qem1Rc2dzWm9hRmNI?=
 =?utf-8?B?Ti90VEtZazdhUUhpVk1aMmdhRE5CSkdsM3pra0tBNjQwMkM4cE8ydnVoN2tw?=
 =?utf-8?B?RDlSU2tuNUwvZGFCcVlib3psbVhvblZQTFhvb0lsaE5meDduRlNjOFAzbkVu?=
 =?utf-8?B?VWh4MHZaSDlQYTlQRE9vcGh0OVBVWVlOZnJwY3hqWjFFNVBoK2MwVU9KalBv?=
 =?utf-8?B?Q1VxZ2RnQVIzSVpWLzZwenU2R2JXbGZJaXFkNjdUYkpKV1lTYnZMWnZOVVFi?=
 =?utf-8?B?c3lVbnk5dnl0MklGSS9iUjVxZ0ozREZJTjlacjJQTE9LUHJFUUgxeDNndVAr?=
 =?utf-8?B?VEkyZ3JCaEtKQVpZVnY0R1BDMzYwQ1JWanR6OEswVlRxTG5DWjJ2dFd0MnBm?=
 =?utf-8?B?V2xPQ0s3R1VMcUtyNzlTOFIzMk1vSUxxZnNrbFdsclk0T2YyTldjYjdFc05P?=
 =?utf-8?B?b3prRmI4dUxQbzR0WmgrQ2VSeVRHY3gwTzZjdzRDaHNsSm9SQ2k1bndKZks0?=
 =?utf-8?B?WG1hUThGTmlmK3JBK0QyUktHZ1hkWnY1NXR2emFVMXdxZng5R3J3WTFDVVFB?=
 =?utf-8?B?czdwRHB4dyttRjc3VnlGZ1ZiVDlDaEcwaDF3ZkFTT0cvYzhUV3o5V0FtRUdi?=
 =?utf-8?B?RS90VUIvRWtEZkVuQ1B4TzR6WXVvcjJVUDdBWm1Mb2t5QnA2amFnWWdmMU85?=
 =?utf-8?B?V3pXa1dyTXJRUkF0NkVhOXl1eWt1bjZmUmNJZGNubkxqNnFTTUgvenlkME42?=
 =?utf-8?B?T00wY3c4ZnYxMUVCY2FXY3crVzhON3FKa2I0eC9lUkY1WmRESGp3SFlVM2c3?=
 =?utf-8?B?ODhIR3FjNjNGQ1FOdnJjS29kSlpJY2RpRjVXbXFqRXRyR2lYd0l3UEEwMXJP?=
 =?utf-8?B?YTJsOVQrMlBnNUxSUkI3SkZpaWxydU1FR1Z2SUJ3V1ZWeTc3K0s2RDRtYXhV?=
 =?utf-8?Q?Mb5DbfhTXWHHzcP5MtXLy4arVkw5SkN5twqj1FrWMaZ5e?=
X-MS-Exchange-AntiSpam-MessageData-1: RFsqyry+OcCEAvglcqFD+cbM6wJOUDpoorY=
X-Exchange-RoutingPolicyChecked:
	N0B/myFrFhSASzqdoJqIeaQIjcIr83VljCmuWljmHdOkzsUdZuVHznnscR1F4P/7KJsxC6yC4WPS69m+VKo+BwAk/nkXEyyKVJERNHSmOaErDcmINAYo+HjcASOmm4ZIr/vaqRPrX2TmiN7dWwXNQ24t2qx3wIAWNhd63Z2cSgf82gdhdxeDLaN9EQi4DPNV5Ju9PnMGnh76QSWS1g1MspP8OFcE3r0hwIUPsxRIegTHUjz+MVZgBc7gMz8/GDyO6HuXdJosaXQQ8ctIVIKSZH1my1SFyJuDKTKEPqXi3gj7au8GIwwlvqpEIyWO5/NtGaOJtyobMd73g4GfiMqrNw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7131cf72-5b70-44ab-56f1-08de9abf495f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 07:19:09.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6AACWgn9pFFSCgukPzLqY5j5LNZYxA7+b+lFxfOzhqXnJ9uUIdkosGMRLPxSy3DeFd2SHm+Pl3eLQHBBLOm0+e14lRAyov7fkMKwhoj6E8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4EB9556A6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDA2NiBTYWx0ZWRfXyRMmHO7M1KnV
 xOtvyCJ2DTf38IMXbtl7yuZX1bzWARQ02ZTEJ+W/XLXoMIzdSRvAV+HXZUI8TldtsvzAnp7IMrz
 1vUKAZPbLzehNbLUSZHnDmo+Y/pvKwH4W7wJArgjSANqxkmlr1tvLWfTFgPrt7LDXs9XPrp2rQW
 AAc4eM84SWjE4/EA1k/pmWcyGr1DBQ5MEy6iYKllY1rV7YNFxYT+OREKvtlfMnyUkSREnX6sjsS
 iAYMM32iagvK46etMB2tu496ZP34/QnVNoDLKrsE3pxCrjQAcsbEEyeePxfPY9X4fuZqSl0ATr9
 m5e9eobenMFYqt1Fpfe8ADUdiWNTyWHE63ngYGwFkaMKV+f/dz+kncJRNROmQGwzN+uYX0Vkn6a
 AO+TDymmzitFpmspkFQCaKb91COby7xcjSazITM7AHjLddV5QXJAi5MWpV/TByVSqhCduGZh+4i
 OWnUwHOOlIVwjaxr7Lg==
X-Proofpoint-ORIG-GUID: CMYUZsgCMZkkED6K2UQu_x-4zDWoioP5
X-Authority-Analysis: v=2.4 cv=GupyPE1C c=1 sm=1 tr=0 ts=69df3bf0 cx=c_pps
 a=6zE/HbjXcl5L3wBq6eN3xQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=yPCof4ZbAAAA:8 a=V15U8FfMQWWoAWRYsloA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: CMYUZsgCMZkkED6K2UQu_x-4zDWoioP5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150066

From: Ionut Nechita <ionut.nechita@windriver.com>

From: Ionut Nechita <ionut.nechita@windriver.com>

v7 (per John Garry's review of v6):
  - Dropped the redundant !opt check from the first guard; the
    !opt_sectors check later already handles the opt == 0 case.
    Now simply: if (opt >= max) return;
  - Added Reviewed-by: John Garry <john.g.garry@oracle.com>.
  - Rebased onto linux-next (next-20260414).

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

Based on linux-next (next-20260414).

Link: https://lore.kernel.org/lkml/20260316203956.64515-1-ionut.nechita@windriver.com/ [v1]
Link: https://lore.kernel.org/all/20260318074314.17372-1-ionut.nechita@windriver.com/ [v2]
Link: https://lore.kernel.org/all/20260318200532.51232-1-ionut.nechita@windriver.com/ [v3]
Link: https://lore.kernel.org/lkml/20260319083954.21056-1-ionut.nechita@windriver.com/ [v4]
Link: https://lore.kernel.org/linux-scsi/20260320081429.42106-1-ionut.nechita@windriver.com/ [v5]
Link: https://lore.kernel.org/linux-scsi/20260326084644.27162-1-ionut.nechita@windriver.com/ [v6]

Ionut Nechita (Wind River) (1):
  scsi: sas: skip opt_sectors when DMA reports no real optimization hint

 drivers/scsi/scsi_transport_sas.c | 38 +++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 5 deletions(-)

--
2.53.0
