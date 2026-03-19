Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70FA3A963B;
	Thu, 19 Mar 2026 08:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773909678; cv=fail; b=ePCg44S9qzD6xgtNJ3wXEmfWkM7463GNEF+TV55M92ZMSgs8J9ZcU+jrKuywrW6TaX1uO8HCK5eBK/KgC5ZwoeVVuhSoPaWZ8kFmsiJb8jqdo5/VLSwD3FB6HYA/iAZ8yhHcrgqZ2kdlDVME4fwbOcRQkQtoyh1JMjPXzXgzB+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773909678; c=relaxed/simple;
	bh=TUjOA5Mt31rv+XBTkzTh9vJ9qJlK6nKbSOS40gshUaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sSftzFB8UsZIbUTQiUlR1Zrdv3mFZdG+myFhS2cK13mgQCswOcSVJKHIM+vrQkcAkBgafyHESkKm+RI0fcTfWCz9U7iifHD15H/vodQHDj2CEpQ6kGnsFTlkjb+gYuWq8VT9WROTmW17x+XKnoosUQGfDeNIM1fzhvFrJGTpxg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=bQ2YTE3m; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="bQ2YTE3m"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62J6F5pq1343739;
	Thu, 19 Mar 2026 08:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=C0cCGODiFcKK2hRzNTh2p6jaBf+98NXglTTyHLPLarg=; b=
	bQ2YTE3mSQbKGazLNJMKw0x13nxux61gv3jpcgVCLe99+0QeQEp9ff8rCvy9P7WA
	srECgqCVAMTaixCkItTHLOGqONJ6f5aqgP6FfHls6fWC+1XEHmyn6i4i9dGMNp+g
	Unj68zvqxUzr2pd1b+Rk9Q4xXqsEfQlbtqAKaz/uUCSp1x5w1ef2CZ8gzHJnYY3X
	CrMxsUtShcskHkmw12Hb6Mh7Z4qjNDu5m+QS7Q20HpxGkR+Jwc3Fp537Nz3dhYoS
	1uXtNrO1ktD/8Q+GWInRjACiZ/i5+6hF4J6Tz/A0ByjuGirrLA9rtplpWJ+aanoz
	rzXUgOktuQDSCVtwaoCV5g==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010018.outbound.protection.outlook.com [40.93.198.18])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cy9antmj3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Mar 2026 08:40:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KJR6iESshCas18+wGCr7eDBBGnBnD0WiLS2Rrq2lp46FmVeUkakCVB+Uf2mscwFEU8Eo1gachaQDGAQr0fWZyjHwo5xDCs0r5ALeeSho2RYpbNAMQyiCrY0RbTXxljrJgklXEMaI9iXEN0DPe3nC/7UeWiM4B4Fs4sjrUs6IzPrUHx7TPMfSfRpqKbDFz9/xcqZRTI/7vKznHOUMAs4ikxNbUUlJeQ5rtUSqpxIzfgxObEsB7SS5/Of49fCKb0lofZ/yh4wa8DsvDpTq1BAz1lNdvZHLFUbuUCab8zBMzIoSrZp4vZ/DgNU9rIC0nOKNn4u3ZaCGjzOwyquCz/2Acw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0cCGODiFcKK2hRzNTh2p6jaBf+98NXglTTyHLPLarg=;
 b=erGzSfQhsSnD8EzvHi+lu5AwCqpcUjWB4iJemnj1uUvRSE8SBF9SlaXHEwLs/OZtxj2mgd9o48FVi2/uehQMlj5Hsm8wOn1Hfm6srP5h4xNMzn0u05b1kVABWRv2tj7Pta7+98Pm5cSSMwjgB1MKWBMcP4ciy20glPa7aMoFtuGGCAbZjCh9/EhOtWni2KiVHixolP4mWUimxrAyuneTWDUCADPyU5vcfnklof1H5VgecR6FtfQTNZKrH6NmBZwKxlliFW0cnnNEaGzmcF8cdbtFLaif4QTmkNa9LQw0jIMzsmGNGHLIBGLqNVeeDWf6u2xl9X17nWYy4zINDMgwPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by PH3PPF37A184CA6.namprd11.prod.outlook.com (2603:10b6:518:1::d15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 08:40:16 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 08:40:16 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, ahuang12@lenovo.com,
        axboe@kernel.dk, damien.lemoal@opensource.wdc.com, dlemoal@kernel.org,
        hch@lst.de, iommu@lists.linux.dev, ionut_n2001@yahoo.com,
        john.g.garry@oracle.com, kbusch@kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        m.szyprowski@samsung.com, martin.petersen@oracle.com,
        robin.murphy@arm.com, sagi@grimberg.me, stable@vger.kernel.org,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v4] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Thu, 19 Mar 2026 10:39:54 +0200
Message-ID: <20260319083954.21056-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319083954.21056-1-ionut.nechita@windriver.com>
References: <20260319083954.21056-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::16) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|PH3PPF37A184CA6:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ad6d8f-b7a4-45b3-ffb9-08de859324f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|52116014|10070799003|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UpxoKEwaP1wb8bBzzlQVYojj7k8O31GNdgrTwdePflkWo1tRTIYU/PXpXMILkZfpDRgYlUlp2dT5bQb1yNITtey2K/fTJci+ETtOWC8WS0qnBRZ+pLCYSylcHKgF/oDSVnai2FmM10+mw7Sdg8SofM20eN9K1M2ncmVPEWzYST/eDtCUgzvLov1Z5TX8EL9aRg0VlTYD63cLsNLvc/ANVAa2kG7Dls7XEpvnZpFKomNv/GC4i3D/pLdGbnmOvDlaP2QfSfCaGZ5UawGfvjlLrEFDJCnzQf8HBWHeUfJr18YMpHb5zkKfl+h2itBqx7vfk4JYDJxlORLmuiCoWki7qzVEHBWMOn3jJ/UStpZrgGqlmDb8vbvNt7F6xGIsj5PbAfpvq7hJxszrt+jJ+vTeCnlY2by7ZbUC1pRKfqCUbIbIPor8wsQRJSVC110o79A/1rYn2MAjNzQZzbgcNthUyaZZSSfyMygpCZTugdgvf1yE+Cb9bHITYhcmFGFvDPMj/WWkx1dY/Gp19s/V4PUQIsXv5+TE6Ld1Ske9d5IQ+ZVIlBwHziTsNFbvaicZHUOpVDqLQWgPaZ+0TkRDwTQjgZCjfEwhWIaKN8feX8fmA+2u5TpUtlizbOhgoCKjKDl1QgSliQR64hec/QwCF2Tnz3VHhvxQsuWIFPlmeIzwNUeuky4ukPxy8i3c0/peR/BFo7M8i/nQ2Il0jSR6fX2VPHbLk6+hj03/BF83yVT+gEs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(52116014)(10070799003)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWt0c2dFWm14T0p4RGdrZzdYdGhqZFg2YnVHUGMzQ2U1RGZBMGhLdEozMmti?=
 =?utf-8?B?NDBHTzVDNGZycEY5WTY0L3JVUDBOR3pPZVVPM0lsUjlIUWdwMkRRaEVzT2Iw?=
 =?utf-8?B?Y1BNNG0rSy9BOXZuRGtwMUJxOFRsc3lRalRCQU5VS3ZCdjl4d1YwL2Qwdmkx?=
 =?utf-8?B?N3A3Z09CWDBPU29XL1Y3ZEppMjhBL2haZ2xVS0p5c2RhRTRvTTlrOU5pTTFu?=
 =?utf-8?B?a3BzYXVobWNQRWVtVHU2cmRSZlJDeFIzYWJZeGhkaEZMdlh4Nzh2bFNiZGhP?=
 =?utf-8?B?em13RnN4ZE0ybWphSmJldDJuWmo0UkE5MDhPU3N3cjZITGFDL1dHVlg0eGNh?=
 =?utf-8?B?Qm5aelNSS3puZjl2Vkd6b0xxZXBuOGp5aVE3N0FIVXVOaVZTQkg5bE44MEtT?=
 =?utf-8?B?YXVvQWR0anR5ZE52aWFzQ1BIeUlsN1F4cjJTVjhKd0xKTVlzZ0xzSXlMaWxt?=
 =?utf-8?B?eVBaWWtFYTY5M3JrY0pwYlo5VStqYXFpelJOMU8yRmFKeWVzbXFsUk9MQmpG?=
 =?utf-8?B?cHp3V0dBSlZWWm5MU3E4NUM4L0JuWUlsRzZkMXZhbjUxa2VEdkRmMWFxSFI1?=
 =?utf-8?B?eVdKbTFONG1qTTNGS1R4WU5QYkQ0UFhhbVVySUZiK1BvUm0ya1RkVWlDSENz?=
 =?utf-8?B?Y0oxS1ZJaWJUTjhxQm13K2lQeUlLYWt6WTVTZzAxbjZSaG53STNyc3VVWWxB?=
 =?utf-8?B?MW9PWFhXK1Y1UFh3YXBGZ1U1d0hjd2RnNjJMcmMzVlNXdENnZDdzN2tNQTdk?=
 =?utf-8?B?TllnQS9YRllMSFVobzVzeG1zNFBXUG1ZU3pXS1UrNWFheTQ1T3dLa3h0OWZ4?=
 =?utf-8?B?QUJIZURWYldqV1lCOVcwNnFsb1dHUmFpa2Z4aTJyaFp4SDVZY0s1YzlFa1Rh?=
 =?utf-8?B?TUR4WVI4TlVqTVRIckZkMzNqbXhaWkNyMERNTFo4K1NBUWlKZW92THd3SUtY?=
 =?utf-8?B?MUdjWEVnMnZicjJqRE9aMnJpQ2paaS92UXcvTkE2K3RDaUdXbjhsY2duUWlh?=
 =?utf-8?B?cmVnNHFXb1p5aWRjWkVoT0pJNTRiREpidE1sUWwvV1EvckwraUFZczdNclJF?=
 =?utf-8?B?bFlHZEZCdVhhRG1jZWpWOUZWb1hmN0s2d1g2dkIxVjErZncway9VZEJDQXo5?=
 =?utf-8?B?VkRTa21rRjBFQ2RwcVZUN05oVitsQm10OVc3NmhWWkJ0eEM1WWdyL1NyUlda?=
 =?utf-8?B?aUtoOTB5NUU1TmJoS3ppUHVFRGg0N01rWXJKaUJNLzkzcXVkU01pbnljYW02?=
 =?utf-8?B?RndrNU1xaE1qd2J5M0tnRWRvUGZITHFrVlZ0M1JZcDREZzJrR2M0SVVnT0p1?=
 =?utf-8?B?N3hpWGxFcUVPS2VxcUIyYkFzZXJWSDAzMlZiRXE4d0ZMZlhoTjlpVjd0T3NT?=
 =?utf-8?B?RkFPYmUxRWMybjhNU1NaVSs4U0FVQnlKcHRNMmpubUVWMzF1U3Z0TUsreDJz?=
 =?utf-8?B?THVUdjRXVXJEcnA4QkdMU2JUelBRN291TVk5U25oVTJnODB2bCtNcnRqNUZh?=
 =?utf-8?B?OEU2ZEZycmFJRDNpVURoK1h6N01oY2VVMFlQazNGcjdTbExTQzdnUUpiWStM?=
 =?utf-8?B?QWRPalZmb1c4VzVSa3lNOXdkTWR3U1A3eDY3eTUrcDBkT3BZc2ZnbDdJRjFD?=
 =?utf-8?B?TmY4SkhaOVROSC9zaWZzRFFDcW94UXdteGJXWnJtZFE0T1JhQXpqdjhrV2Z0?=
 =?utf-8?B?TkZMRGhNTzEyUW4wY2tzOE5tc2YwOTFueEdCZFp2VWNiZVBST1NEV25VUERF?=
 =?utf-8?B?RDdnRFFkMFNzYkZpejdxR3ZRUzViSEZqaUZLUGpDZFhKOVdUOUdFZVdLanF0?=
 =?utf-8?B?YmVYUHJNYUMvTUNqWmwydFVVT1c2SmFlRm5ETjBLalRobmRqd3FqQ0YwanVP?=
 =?utf-8?B?WEtUaXFZWlZ3NXdMTnRJMStHelpCRHF0L01TSng1S0gxYXpLTXFYaGhGMlpz?=
 =?utf-8?B?S0Y2amUrbndLcW9IV2gvTFVSbkJZd0tnLytxVjF5UW81UWxLTk5ySForYkt3?=
 =?utf-8?B?RktEK05aSUpZUFp3NkFORjZJbnQ0MG4rWGNLeUo0dzcreXBadGQrTXBpaXl6?=
 =?utf-8?B?bk5JSXlxUzNPL0JHbDZZa0tPM3h3bERIMWJjODdwa0F6c0R5K3ZnRDg2dU1z?=
 =?utf-8?B?VFJCa29ERHpmNUgwWmIwaldkZGJHUkZ1dmREWUhnNzdseHJxZHFKNUZMQmh2?=
 =?utf-8?B?TlJtTzJPMTZDVUt3bnFzczFkNEI5RUk2Z0I0cWUrQWdHM2psdmpYM2kxdmMr?=
 =?utf-8?B?NE9Pa2l6bXdpbkx1SGZJWDhKTHNMcll4Y1NwNUdjSjNvWm1SU0VPeWRXcjZo?=
 =?utf-8?B?bjN5d05WOStCRitvZ2dhakFCNFI5VmRIM3B4K0ZtNDEzUFdoY2lmb3hGTFlr?=
 =?utf-8?Q?tepfcpBBOOIj4QvkP/bZddSoNOZ6Qmcm64HO6awiDg5TJ?=
X-MS-Exchange-AntiSpam-MessageData-1: XbmJXwgyYwTRdz7Anz5aEktMpiBqH8yw7Fc=
X-Exchange-RoutingPolicyChecked:
	Nw6ubvp5EMYGjt/o+CCZa/yut+pZHvfcjXAW6FbdJwqZxgfWUBfvhvLCiaeUwzE+HwckkiHpVWAmwvHDbYNxZciWuLe4cMTns9rvIEZZU53DQkD1vN6XYgT0xNAnVrLLnbQcyOwqOriHo4EiJU5Dmq4rFBIjkeD5YgD1msb6atpZKJyZuniIX9M1Ikcwdxj0oj4rPXc9f6OU4FtxUro6rqTMOrHcerKWgfZ27YjhMsyKP3oxz9Hc0+PiLGOQmOJsrvnGqyE/zsyMgTMJpDBjlK8pnSGB5YiAoE6ERL4j6SHuagT4WlqxOoA95aRmIBMOt6sXd4tc1U0Q53RLwkxomw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ad6d8f-b7a4-45b3-ffb9-08de859324f0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 08:40:16.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3Dhnw/D5KH1Q52J2EIyDC6d6wUMNjhVEWPYF2H7HU6pSYtsPG3T9cKijdzrG6z7J8VUTsjZlRGqIL8iqO9vIUDjA955PNFcSpJYqZ+Ks5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF37A184CA6
X-Authority-Analysis: v=2.4 cv=IrMTsb/g c=1 sm=1 tr=0 ts=69bbb672 cx=c_pps
 a=TKURuYQIacZDyiG+Utq8vw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=kuvo3jlHsurVFeJ2yhoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: NI2A-Whl74Y0jY3I4N6N-jd6f1IexDlc
X-Proofpoint-GUID: NI2A-Whl74Y0jY3I4N6N-jd6f1IexDlc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE5MDA2NyBTYWx0ZWRfX0GaFftftR3zF
 JmTv79lvT7QZMutwWWtPtwWVSRJRyhm2qNjr74eta7WQQWXrYlrKiOBKpInvHOENeLngz3PGheE
 TYN+TeNGhlefgL0WlE8VQ0joSwkzxF7dFI6hHpAmu/DahFQACGpfF1kSEB46Fv+trePUIBvXpdQ
 mgduDjy4uFeMMJcEEMy6KiwrHMIk7BegZ4UBKZw2Ep9X3wDYKeYFWX7OwI85jTMAiV8/HK8+Azm
 TkRP2TFsbLf06MFux8Ifq7CEfzH46c7gFBz0LSw+OXZsbxWrIFGNmsPVfT1hXhW1HfLBG0CzSfp
 eAFZzO0mL3A39dhApr5tqmtIhOIZoavRMhkZrw6ndD/d5Ub+RPIySJkOgP0hKcbXqgmE3MBX0vK
 EZRS36VVcYpnEVcba7cYztBEH43/gMVt4GhBQnDeT7PWb8QRa6hCCkZfVegR8H8JKmyB/PaRwjb
 TwRE/+vL8IZeZY+N6tw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 clxscore=1011 bulkscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603190067

From: Ionut Nechita <ionut.nechita@windriver.com>

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
clean results.  When the two DMA values are equal, no backend provided a
real hint, so opt_sectors stays at 0 ("no preference").

A WARN_ONCE guards against dma_opt_mapping_size() returning a value
larger than dma_max_mapping_size(), which would indicate a driver bug.
The return value uses min_t(unsigned int, ...) to avoid any potential
overflow when shifting the size_t opt value down to sectors.

Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
Cc: stable@vger.kernel.org
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
 drivers/scsi/scsi_transport_sas.c | 40 +++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 12124f9d5ccd0..696627b6fe2c3 100644
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
@@ -222,6 +223,38 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
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
+	size_t max = dma_max_mapping_size(dma_dev);
+
+	if (WARN_ONCE(opt > max,
+		      "dma_opt_mapping_size (%zu) > dma_max_mapping_size (%zu)\n",
+		      opt, max))
+		return 0;
+
+	if (opt == max)
+		return 0;
+
+	opt = rounddown_pow_of_two(opt);
+
+	return min_t(unsigned int, opt >> SECTOR_SHIFT, max_sectors);
+}
+
 static int sas_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
 {
@@ -239,10 +272,9 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
-	if (dma_dev->dma_mask) {
-		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	if (dma_dev->dma_mask)
+		shost->opt_sectors =
+			sas_dma_opt_sectors(dma_dev, shost->max_sectors);
 
 	return 0;
 }
-- 
2.53.0

