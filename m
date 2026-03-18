Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA382D4B40;
	Wed, 18 Mar 2026 20:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773864426; cv=fail; b=rxdNnX3oUF5cWWJIF/U7Y3DliZJd48NCvP9cliz6xrBeveTHl3OA7VjH3f3xSupiynuZQgFdFsxx2mBxAt+dAMkOpEiruz/oPYKwUB7VBjUYkHVd8xwyJNljs75vrTCoMCtk0rDb/yMXjthDO7H6d2JbsOz/Zy0wK2EyMxERtEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773864426; c=relaxed/simple;
	bh=sIaqwuqFKeFBSeEo+qTTjuzPUb8wLlHqqfz27sY27NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DFNaW3EQanz/cPlqRRO0KYyd19r7PK/uYC0dfMjn3Pt7mIT81VGHD9Cbi6sr0JTQNP5GurH//TFCqb/CwG8FDpYP3fCQXAaOB/qe3hN+cf0zwQz44fA9S309/vVn3xHAsnMy3TJ5mVL3Hw4pG3VyNeBQ1UPtxBJ8hjxoXIlgnYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=bPT2tOu5; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="bPT2tOu5"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I4SuEP3787204;
	Wed, 18 Mar 2026 13:05:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=38Hp78XV7jlDgRSwLCUfqOmH576kjvuj28Xec7TyiM4=; b=
	bPT2tOu5/wS4z616O16W5nL8KOFlf+IRhGDHo9mzprKn2TRrsWS7vED5cHiuqAe3
	VN1v1TA7/NzhF9eFXhUIpQT05SyJc60Uvv/BcBOyVGeE9e1HUag3GU5yLhzD+Ozz
	G5XXmAxWgrvj99VQln7PavdhrhcXqNBzL+2G37z0i7LNCKO7ceDXrUnRuHzOTHzX
	p7m0IOwteqLUIyxMSQI2JlzmR6/ym2psIjs4bup60m7Kqu2FbxrytaexGqW+2NRF
	hXqDTcHohzlTCJ+gXVNy0BaZ+AIjYhRhZFB56O4GfUZNuR2Vjv1bYF3J+q4aZAA7
	AKHhCICWOWNU18WyP/qZtA==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013015.outbound.protection.outlook.com [40.93.196.15])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cw76dw4k7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 13:05:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IPAp6/L0AwAKpODpcnNL1SEYV3143BO5whHAykVIWYUSrm7A+x6g+DFknNOvcrvOYMWekTS7prssznAelPdG2MdS0+IzKpeqpcKOhjl4EJF5cKd3RZuWE86IlbU8PqsuYMRsLGIQeo7iEevrChZs+fWSKJzOIeueXDFb+MAiwa8+Vdz8BqnKKzrCgwPsnwctrGTtR8VaOr2OBMjTKAdqnkb6JCekc6F0Q/HRnXnFeaT7V7TSR+6v4zSAyEod3G/EKO9Qj01+kSnNUhSbIW/37k9sGUuyu3ygAcWl6iAz8VmnkczYzj0CYqqZXza63tOPc08Zi1xjJg2vNFfvQVjCHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38Hp78XV7jlDgRSwLCUfqOmH576kjvuj28Xec7TyiM4=;
 b=PUkZmg/0sw8azB1hns0LLk9TUE2ItBjPCJOdlVKFMUdY5nuvOzAaUG0GVSsvSwYTze7ak2pKV9m6x5zLuiXeXPw7naYqVsENNxH75owg5T8xppnzX2TjbBxStRTPFm9Ypuay7yHySaNErY0qRMiJh0Cpj8B/o+2djF19/MHiCbE79ldN/Xg+OtXEfYBXW5diZjV3MdMBPm8c3/EyT3ucu/wKnvsDDurikB5Z9xWQnmY9ArOfh8qy0bDH8i3pPal8Afxx+MPI3LA0OfT9Wx2mO8+Y6MGjLyORf0BrZjKBAQ27aBl80R1e7WUb9K5OKCJVQQO652ENx0/fV+Qtrn7TpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by DS0PR11MB7409.namprd11.prod.outlook.com (2603:10b6:8:153::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 20:05:53 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 20:05:53 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        hch@lst.de, iommu@lists.linux.dev, ionut_n2001@yahoo.com,
        john.g.garry@oracle.com, kbusch@kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, sagi@grimberg.me, stable@vger.kernel.org,
        sunlightlinux@gmail.com,
        "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Subject: [PATCH v3] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Wed, 18 Mar 2026 22:05:32 +0200
Message-ID: <20260318200532.51232-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318200532.51232-1-ionut.nechita@windriver.com>
References: <20260318200532.51232-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::19) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|DS0PR11MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: ca6852f9-6078-4b94-f036-08de8529c247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|10070799003|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wPGVvTFs6s8owDzUt4YNVx+IGZhiXgIUv/nS/tLcrQFQMi/TAIb8Y8yjicWkSQoaRis0HxkTIKyfbJmC9cC6Nt7T46pnZ3SJaIpz0bqn7CKWyIJzeUlBlwubcdOwx8d+iR43wDCS3rRBF24nBWEajf6DdnUR2sJkZuUElf0sCOFY8b7h/aUU1gkszZNUdT0LhArwETLh7/6tO1k5B8IVLz316/EnrlJ86BYdacUoSckIWIrf2y20f09i0pk5lQw2yblzyOwJcCttzo1ztuA1Mt0zfwqgF0snUospUUIs0qqbRgsZDkmGxgs7sv+lZxrFkgQCWjCAKr7nLeIiJa3+6GHYYWYsMG2UTLoLWQchwbA3h0Yw45+nGhj+/tO8Qd9iKa9SzB/tzd1iWhViGfoNbGp4ZCBsV//NsFiqpy/jE5d6D5jnDJqh5BsvSK1C+0c6b6pR5JHVxRRzidR0eqTE8XucxuCtf5LUo7nTC8Cevatiw/NcS/9rtJ2uFJzBTNNhPGT8dh9pGhQlS2hXG3R3r4LVJr/JwBJkv2tO47HckjlYMpf9sCWynoGPe0/7WOAa8Zw5hfHEZSpkDz/fJ9h9EEQGuDURYxJGzgkrB3lu9j67nj8G98CiG2wmHg68qJTF62FwPgDh8uje8+Wmomr1Lt38B2Rm1ka+iyPshLn1L1sXByeV/XoeqDZiHl4VkQp0DDlC6viy5Wq1xZm2EY2gppzbYTzq3rOXKUmlo4hserc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(10070799003)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZStmR1FSMTdHN2dPMThzeUM3M0dVc2ovbDVVN2VKa292ODVlQ2RHVHEvdU1v?=
 =?utf-8?B?NVBUR3dBV1lnSlM1ZVJzV1BPWFVWWmNzSWZqVjBHbEFzdmcxTHkwSGpZLzU0?=
 =?utf-8?B?c0M5UmgzbnN0U0lvK3lzV0c0WktiWWZwMVJBTEdGTFhvS1ZSVmlOR1Ard2t3?=
 =?utf-8?B?VitKSkZjRHpqVnVJaktSVlV0STRDNGIvcitQeis3dFVwZExrY3U4YlZhMXlP?=
 =?utf-8?B?ZDJ1Y0xYd01UL3IwdVIreFVacGQyV2lTVzE4ZkZCaU9MR21tTlJoRXVVMkVw?=
 =?utf-8?B?dHFqMktOb3g5NjBKU2o4UjJ6UGtleGFXOTAyemt0Y3BWZUlGeDN6TlpERzc1?=
 =?utf-8?B?WTVMckZTNHJlczNSYS90VU1reEJDcUQrU3M5N2tPbWxETmNjNEg5ams1ZTVl?=
 =?utf-8?B?V3lLZHFzMDVENmMyUVZlQm1EaktEdnpnZnJNV0ZaUE1uajRObHJOdUJKQ0ZK?=
 =?utf-8?B?eXNUcVYwZnU2RjFuVHBQcVJYT1d1ZWlhNFB3QThhRExQTkZ1Y2Y3YzdkdUVW?=
 =?utf-8?B?ZWFnNG5JcUxELzN1dDcwL1YybmRCcVVBZlBNSjVmcFVlcE9YVGZkSVFXbUlI?=
 =?utf-8?B?bXJJczZSVmJzQ1Z4MG11SG0ySGdmb3FiR2dUUjBROXFTTGFWMWdTWS9KbTVw?=
 =?utf-8?B?Qi91MWFsS3g1aGtwNjhQT0YxUnZuUmFnMWFtclN0Z1JYTnVMSVk4WTE0S1lh?=
 =?utf-8?B?bTcxRGFmK0xFWWpXTis2bmNLdmxRUjl5RXF4alo5d1FVbGdDT0Y1TEprbDdm?=
 =?utf-8?B?cndWdmkwMlp2ZXA3L0t4b3pEWTVBTEswWkpQNVlBK0JMZDJNUElOY1drUzlJ?=
 =?utf-8?B?TU5ZVkY2dHBmNXU1dnNRaXF1TGRZUCs1eFpPTGd2d2c2Q0YzNTU1UXdwUVNC?=
 =?utf-8?B?S203UEZFUXlKVzZ2aHpmNWQ2Yi9Gc3VmOWY2S080MG9GNWhjMHU3cjVJT3ly?=
 =?utf-8?B?d0VkRkJDejdCQlA4THprM0dGeWl6YlFndjVYMDdabTZjc09UV3lJTUx3U1h4?=
 =?utf-8?B?SjAxV0poZXNMeXQ5OWdqZ1h5VHVpVTRROVBycjJXN3k1MEZrNFMzOVNnSFF5?=
 =?utf-8?B?aHNWSkhoYUs2dXV5SktaOTMzclQrQit0UkJ0M2dWMmdjd2p1cjBqUXAzT3gy?=
 =?utf-8?B?U0xQK0ZRbW5ER3h6SGxMSmYwdE83SDFxdTFLYnFzMVBlcXh1Mm8vaFhla1R6?=
 =?utf-8?B?STZTU0h1SXdsQ0dOMTgySEVLSUp4TE9ZN3p1aWFwQzZPTlp2Q3NrWC8rV0Zu?=
 =?utf-8?B?MkRteFhUZFBvYXI0bkJXZFI2aDQ4L1FDN0JPZjFQdVlMV21CczcwQXJySkVW?=
 =?utf-8?B?dzQ4dUNNOS9pdXg4ZERIL3pMMHJweGg1aHE2aDI4Z0JVK0RkQlRDeHdTVWVq?=
 =?utf-8?B?OEMvZURLMEJOcE5ZeVVUSE5CdCt2S3RrQkRpNEJ3YkJsQzlwdldtREJaLzhq?=
 =?utf-8?B?Nlk2K1VKMUtDVUJ6eFBaNDZrOWJibDdsb2x2dXRZbmtYc3hMQkc1Yko3TUs0?=
 =?utf-8?B?K1ZCOFQxNDViNGpBZFRMcHdlV1dxZGRTdW40eFVudTRUbVN6bFAzb3F6RWFW?=
 =?utf-8?B?YUZQYlVZeklSQlkrRllCdWV1dDJJSzFTV0JETDE3dEovak5PQmhsNUlBaWNV?=
 =?utf-8?B?U1Z4aVFERjZhTHNGTHprdVNHSnBPQU9ocWIyTkJCU3lKeTFTa3pZT3MvZGhK?=
 =?utf-8?B?eUxkL09kT1JNQnRJU3BFRVhuS2kwZGVmVUFtbTBPMlh6TG5ra0RuSTkvalRt?=
 =?utf-8?B?bDlWWnN0NmVSdXBWb2U3aWhkUFlRMzA2cVU3L1hpVnRrTjJkSjYxZzYzVDg0?=
 =?utf-8?B?cUR6Zm04bnBLZEVma1ZQYTlvbDI1OS9kNXN2aEJReU9WZS9QTDYvcEk1ZTQw?=
 =?utf-8?B?TG5CZlR6b25XektOSVJzKytrWTBzN1RHaFJVOWpQWURQeS9VYkZ3WHZyWllB?=
 =?utf-8?B?L3FRbmlrVTV6aEExU0c3b21qOC9UMXIyYlMwN0RicHRGcmpad1E1ZGNiekE2?=
 =?utf-8?B?a3RxY0pZK0dIYyszaHh3dHFnbVlTWW4xck91Q0FLTDFNRGFUSE9QQW9XMnFH?=
 =?utf-8?B?SFd2TER0cnRNRWVWZGZ2VVIySkxjZnFteWZqOEt2VmRvc0V5ZEVKV2R0VWQ0?=
 =?utf-8?B?NTliTzBvVkNpYXpCTnQ1L3pHVEk5ZmQyVlczRTRFbENWOVVQRG5LRGRIZEZ0?=
 =?utf-8?B?S3NwRUhkQWUwcS81a0IvTWowU0tFUjF4VVordncyR0pGT0tQZ3I0TGU1VWlW?=
 =?utf-8?B?SEpRNVpNQmV5RmtZZ1V6NFRvZ1lnbWt1UGp3Y0hQTDBTdFRJdnlJMmlzdzJa?=
 =?utf-8?B?MDdabHppMW9Ka29OdDIyakVpL01TYzBJNU8yN2lFcXl3QW8wSGMyWG5zdnF5?=
 =?utf-8?Q?bNuniiiE+PZxRtoyhNlE354gFWvq1gMeowEUpbbawbQTT?=
X-MS-Exchange-AntiSpam-MessageData-1: BM4qUp36XoHgXrtrF4JS8pQTUPvh7idQYxw=
X-Exchange-RoutingPolicyChecked:
	QgvM2981Xo+9Dj99Ri9pc85+vQ2C4A5AS4pCPxHRmpvBRUuCgIHo2KxSmkGjNfQ8dwfuPNNfUaPTJgMmO3WSZBJqZ/CfoZLVAkUOkF6PR4m4YBvkytWwaklPWK3s+UYTYy9UB40CWaI+C9GvZUIvoPOG17K7c9nJyuHSdGWN6i8dYsHTOnTtah/PVvuqSEk/W8yLpahtUgYJuVAGmelkn96cfXaua3SpfnNAJLJMiO5Gt+RWbzcsMhaHlG8H+VyaFj0xzynS6ZIagBe2IkgBTLX6hboVPJIovzbJnBdAVAUpEUzImoRUrZO+b/fnDCrqXn9WNF1xXKi7BeUNwCLMaA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6852f9-6078-4b94-f036-08de8529c247
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 20:05:53.4060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJSNp6dBioCDbn+YXwmeYcm/YLOJEjt1cZ3TC1yw4HnWWa7Xv2QAGD+/YVWc1kR/R1eX5xUNso4WhUdqUYufoIoNr6dhpI4qo5KD3aalqNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7409
X-Authority-Analysis: v=2.4 cv=S9nUAYsP c=1 sm=1 tr=0 ts=69bb05a4 cx=c_pps
 a=KH9ZsF1Q5Y6vOSsawDVSsw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=kuvo3jlHsurVFeJ2yhoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDE3MiBTYWx0ZWRfX8Qpnn/LWhBmk
 ewHBXuLPvFbCuouJhc2oNabG8eVDNgTnNCTBxSqw7ZZbyi5Sy3KLdSs3mg9P1lTVsFEUDFgC/uG
 zgHlukQF6bVyBi/KfuGIVl8SaXtP0gg1eQqLgI9dZQNGFPt2d1xSMRl7ONw6t7SYvpr+azl5BfB
 CIVsvZobg0Afttuh6hvgWuKLIZeyBfTGOZQe6k61Bnx3P9k5E3kM2hYDaB8C4o/1OLGRzwGtXi6
 +Qq7N6f+sb5/JbNC7hcycjODutFcoXjokFOLmsN8sRpP4dqt6J2A5IdplC/DpzexakQ3VC4pbF/
 bD6Zi6rWaPh6ko4n/tO8p5LmbOugcV7yPlIdCYha+gc3hgzqQ3Nng31Q56SvEfmsvL/FJgtipLh
 QNYMnVS2N+cYc6rq9Jze/hcPReZ2BWAImz0Etd6GAKaT2KnvSh87uShO+Ev+yVb+R4W36n3qYlG
 vsfGF4rJQlHpwfzlBrA==
X-Proofpoint-ORIG-GUID: JzupCMnkTakqz_6X1BEUZ3v6uSCC8Rsg
X-Proofpoint-GUID: JzupCMnkTakqz_6X1BEUZ3v6uSCC8Rsg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-18_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180172

sas_host_setup() unconditionally sets shost->opt_sectors from
dma_opt_mapping_size().  When the IOMMU is disabled or in passthrough
mode and no DMA ops provide an opt_mapping_size callback,
dma_opt_mapping_size() returns min(dma_max_mapping_size(), SIZE_MAX)
which equals dma_max_mapping_size() — a hard upper bound, not an
optimization hint.

On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
and intel_iommu=off the following values are observed:

  dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
  shost->max_sectors      = 32767
  opt_sectors             = min(32767, huge >> 9) = 32767
  optimal_io_size         = 32767 << 9 = 16776704
                          → round_down(16776704, 4096) = 16773120

The SAS disk (SAMSUNG MZILT800HBHQ0D3) do not report an
Optimal Transfer Length in VPD page B0,so sdkp->opt_xfer_blocks remains 0.
sd_revalidate_disk() then uses min_not_zero(0, opt_sectors) = opt_sectors,
propagating the bogus value into the block device's optimal_io_size
(visible as OPT-IO = 16773120 in lsblk --topology).

mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:

  swidth = 16773120 / 4096 = 4095
  sunit  = 8192 / 4096     = 2

Since 4095 % 2 != 0, XFS rejects the geometry:

  SB stripe unit sanity check failed

This makes it impossible to create XFS filesystems (e.g. for
/var/lib/docker) during system bootstrap.

Fix this by introducing a sas_dma_opt_sectors() helper that only returns
a non-zero opt_sectors when dma_opt_mapping_size() is strictly less than
dma_max_mapping_size(), indicating a genuine DMA optimization constraint
from an IOMMU or DMA ops backend.  The helper also rounds the value down
to a power of two so that filesystem geometry calculations always produce
clean results. When the two DMA values are equal, no backend provided a
real hint, so opt_sectors stays at 0 ("no preference").

Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
Cc: stable@vger.kernel.org
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
 drivers/scsi/scsi_transport_sas.c | 36 +++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 12124f9d5ccd..c2424cf144b4 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/err.h>
+#include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/blkdev.h>
@@ -222,6 +223,34 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
  * SAS host attributes
  */
 
+/**
+ * sas_dma_opt_sectors - derive opt_sectors from DMA optimal mapping size
+ * @dma_dev: device to query DMA parameters for
+ * @max_sectors: upper bound from the host adapter
+ *
+ * When the DMA layer reports a genuine optimization constraint (i.e.
+ * dma_opt_mapping_size() < dma_max_mapping_size()), convert it to a
+ * sector count, round it down to a power of two so that filesystem
+ * geometry calculations stay sane, and cap it at @max_sectors.
+ *
+ * When the two values are equal no backend provided a real hint and
+ * the function returns 0 ("no preference").
+ */
+static unsigned int sas_dma_opt_sectors(struct device *dma_dev,
+					unsigned int max_sectors)
+{
+	size_t opt = dma_opt_mapping_size(dma_dev);
+	unsigned int opt_sectors;
+
+	if (opt >= dma_max_mapping_size(dma_dev))
+		return 0;
+
+	opt = rounddown_pow_of_two(opt);
+	opt_sectors = opt >> SECTOR_SHIFT;
+
+	return min(opt_sectors, max_sectors);
+}
+
 static int sas_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
 {
@@ -239,10 +268,9 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
-	if (dma_dev->dma_mask) {
-		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	if (dma_dev->dma_mask)
+		shost->opt_sectors = sas_dma_opt_sectors(dma_dev,
+							 shost->max_sectors);
 
 	return 0;
 }
-- 
2.53.0

