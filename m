Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA2141A793;
	Mon, 27 Jul 2026 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163452; cv=fail; b=NEBRYRtPg6w6lMOVIODSxLQEfJXqSseTDIyrvr2l9GOPsfV7sPDycd2cU7Qld475laoXz46moS22db3lLhk7qn/zmyFwhugKelhXKU077LuX10YrjJ8AaIg5dVkPM9ss8ZfZ2D/zDNGG6+MzlSzw6mfeuisqbrt/Qh732wxPMhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163452; c=relaxed/simple;
	bh=NqfMBiGOMqmjb05noGDuBJil0rSi3kqlLDb9/PkckQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QejiV429gWZ/2Dkmgc/J9FlaJwb3aaZMW0lfrwn9iIZ6nLlLAjjb1U6Je8ylDdZyGG4EbwkyFd7iYlyGeq0KEY1QYgHMQbjt64EbSfuXHuajivtfAcWzawLVOFobU4n7XKjMcJ/GcIOJiJkax36zmdfHfDnGO8d3igEZgaQJXD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FD/oxi/I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M85AqgSZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FD/oxi/I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M85AqgSZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCUNH42096596;
	Mon, 27 Jul 2026 14:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zTG6faN1eLgJOTzwj4S4u0QborMUFiRFC3OC3vZN1d4=; b=
	FD/oxi/IFHqjBVErd9lZI6hI0R/LX/ABQZaJcZTRpZsGsnqPYyVT3honWbpXwRiH
	O25V/zAykhLVwYbG2TnOVLgZmHlxY84RiXUcwHXo6MgC5FI0dKTk53uv2RCVkBXV
	09HWMLL47Wu5ep4dW0lOL/t+1pZhxMgE4a+l/S1/I7fPHIufqwSoljSkHItSprxA
	vr97GvpwVPSTIrwkfk18/jRqH4PuUQNBa2Ug63paIa5QPd8nNr3EerKmK2vRJBBn
	kDgoK6Bo7ASdgGDAaHgx4J/prKGaZsM2grfYb5O9cOtFizZt4ZnVPJ8+gprVW/CL
	8J/T6j1WcutUXXiDSVCJIg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xsxj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeapT021472;
	Mon, 27 Jul 2026 14:43:25 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8gewqn-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BII33WCsLhtunQ2Si7FV2jcPS2ql3PUoWmxVPV7mr+4i0itHzkVzCoa2INval/Xnh3ZeNohouUVXFM1fvzMW4Sp6oHNEtAwwBb20PlDcLrky2Wmhs+NFUSnuFXQ1ijVJgyzeKh1mgjTvWu8qFAy/1mnLjteX7+Q2UFakxlSAT39632D3iMWa8LOqLQsAUSkUcOVWOP7+7RQCMfCGOqB4H7WBq7nkZXkkwGxjx8fg+MNewQrLw2lzrwmutIDQ8KJDo5s98RzxPmvMDlmSaRMGIo8nPSly7jiXtJmFwquBLGJ3leN0ut/QUvGDtoOBbw9J4+spNlJAQCoLnJXpve6zUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTG6faN1eLgJOTzwj4S4u0QborMUFiRFC3OC3vZN1d4=;
 b=Yc636ESVSMm2F/6H/iszZjaGlnlvUBAkWLjwxYjMQADaz2oSje3UGwvrAXvnmvFGUZoGCI9wyA9vyWlUTbbFqaovpjhaScGW+dtEy0NmqvPa7Rd8E5QnkuuLs4goS0s0YBy/TBLSw0B4WMgMYBL4S2VvsWGqzsMRGgkcVhRoAksxkqzhZzncDmbMcTotMLY6za8q8T2CYy/ygWtc5TZfq9LPhxISuA+8iSPeCIJqIrP3KUsbwQjrkEtooPIEWmTQOCMRQ+NsllcbWtPjB58EeRpLxzjHQ0ul4Q0CYc7sR2S07DhNBpjQbtxmAepEAbERmMrasygQBB/FyvlpAOXb2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTG6faN1eLgJOTzwj4S4u0QborMUFiRFC3OC3vZN1d4=;
 b=M85AqgSZjAG7wpA1w4Afelk+KOMo4ceHGYxcAUcp4rJddxBwTphkT7QGiMgb7zbWjFxfZ3uYAh7agLq8Xrhr7bPPzqxbaaDZBZJRsudEJ50vypVRn6iJrAplos6/z9qTjcP7w3FpJVBEBMIvxQmwKS1+Zic8BON2XRu9xJu2HFg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:22 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 18/27] scsi-multipath: failover handling
Date: Mon, 27 Jul 2026 14:42:25 +0000
Message-ID: <20260727144234.3802948-19-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0005.namprd17.prod.outlook.com
 (2603:10b6:8:191::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f5bd1a3-473b-4f97-a470-08deebed67fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GnIVtkRxq0GWavWkZah3Sa9XFJ8QI51nKIxjuXvdlMfcrQIgHcLmwrj1AEPKyH+vAbU0R70pTJvHyPXgF/Q9IqESPp3XwzVzd2c2SHYmFNABBVNomNUOn1NKr4h6hrbaf1c5rgUiqIqdkNS/aOEUmGV7KbTHiLw8oKTEX1tcK5aAmGXDgNP/ZNDf+zmEnp68YbdftaB8O48wMiB539/avRyiuso5LWOUr7i6LhB6w7U7GemPzC3LT4KRqkA5MWkcvnj6Wd/HWBnDL6sUiGMGHB9KjHzjZ9uakSm3IgE8K5cblYBAQ/RygeHOVCuDYSCJICw3lQSkGS1nLmsC8FTtzZL3HvRNBdpygvRT0O9rW+cFivuCulM9aezoPkZ9vuJNMDWZawRWW4H99fmC6VRsrb63e8OAtKZA/5EtcYOYXAQhyY7puU1sKlLjvZQt53fmC697su+builAE99ojPggU9pxbPgaf+54kkySQUTSc+BdANntrx9h4+/WrnYllAq8+EDr2u6QqQhnatdcCbijpwC6IarxhF7gNAmggjnMMHb1hHulu0WGKha2Oouz5wcA5Sx6KZd2ORt4SvZDaj6vkGYZzDdtf0DCQD3c9+h85sz776R8uUxbx+FwJPIb73WfNrmOK9sXSw9vxrXqDpRhWRkxVKRiKl3RsUrs7W9Q/jU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V7qfcffXYg+D4eL6wZk3PDL4cxEulfSegdssHKzDWgVl5xH/ugrLTIGK/miH?=
 =?us-ascii?Q?pnUG8GhCipAyHegMb6EW6OpkFbVwWT9hbAGr5te7EaewX46/1z6+yp78Kw5p?=
 =?us-ascii?Q?y+P15lLJwipfBCnlMLNlpPVTSQMne6WUgLLnImHozdBKZ6yb0ZCYE0EsY63s?=
 =?us-ascii?Q?kfrWzvAmXpFHWL+pZX8vzzeEWd0fzVG+8NRcsucCAzKgOhTPavmVmDs89iH0?=
 =?us-ascii?Q?C3kH1Tt4rOvb2qVvecqIziUk4HfReUBxHVzwjZLrP0QmmLCFDVzBeNj6HQ4S?=
 =?us-ascii?Q?xOBil8GMjJ0mzfj8OtNyRj9zi+QuAYmb0vaCGBe9AnCIRRaj84U348C0tyBR?=
 =?us-ascii?Q?qlwFWioodsZqizmav9W59Jy+b5RnlRhmi3ewWiMILKLFnsB6iwkrY80eFVi3?=
 =?us-ascii?Q?nnM2prTm389egPOqqYhCl863N8VdUIfqpEhqkgvrRghy/7SUGal6GcgbHfMO?=
 =?us-ascii?Q?uUkpC/eVBsz50qx3/OpUK9/C5yvauXBJdjK0HYTpRWE7yuHzs5znc30yrlSQ?=
 =?us-ascii?Q?03/XRyYxZO8oBy3UKc+8OeoR7GNA5PNBIgGtMxdGHxySNf3vhTJREWLXak52?=
 =?us-ascii?Q?LLr07ZxudigOxTrUpwr2w5XUCr5ENrzd/NFzA07ODTMZMeG4Dt3JnFxmABK1?=
 =?us-ascii?Q?m8WgcbEjk5SCuFpISWROlzyzzaxTaJ99IuaiiWMUrWaL2k2NdJJQQPzIhrdn?=
 =?us-ascii?Q?0vCbFIFuzco2ByGNnPrdisbAmLi+WGqgVntX4dDurvddKJlB64AS6B25DIdu?=
 =?us-ascii?Q?fUWzPCj1wF8GDEfGtJYgbP0MbkE3k3FqrQFVELLlXJsWlrbV/18ara/PY92C?=
 =?us-ascii?Q?BEgqKAs/9ms1fp/Teja24b8L1OZaljMm3Xu16+iGTC37yA9P2aWaG5SuJ4+j?=
 =?us-ascii?Q?6pDckCjECxzVGnANykxyrR9MEqV5ZHPiLenZuQHxOI3AXnAUNMdUckkRw/+O?=
 =?us-ascii?Q?7Q3taDQTAs71NW4iGyBDKqZeMMB3Od4Yl++V7aE3WgbuTBJHJ1JBDve+rUC+?=
 =?us-ascii?Q?aBcrJTG1T8F6e40LOVuzQYyrgP9viyvMLdD6hRLzdwKLlste8VyIsUsXbhBn?=
 =?us-ascii?Q?GAap5V+ePvibj56bJbTZGu+oKpfrKNpB3Z9oTjWnwkPV8FkBJuK2LWrRiizH?=
 =?us-ascii?Q?sx6k2ElfJEyYj7bNBuUMZNIwPLbSnTax3RoxArdpB++Sn5KemwD3C1ETydM0?=
 =?us-ascii?Q?mxopLBm2vRD6ntAq0k4qT6IgUds/HrG7+kOpwhZoARhQUDS0fJ+yQ19zEjXk?=
 =?us-ascii?Q?XVFRDUb22fzaCtwav3f2i13imHiHnxBPzA9r0RoIu/d7ZG1kTZJne7BqGpWV?=
 =?us-ascii?Q?6fCdBDB8VE8gkgNSiyXrEz8J6hnrKQ8+K8KiTlHvqy/qP1c2K0DkqtlGeyMl?=
 =?us-ascii?Q?gB6VqCIyoXB4SeipZP2iqrgdYPGgnNZWBCpGPhHZvOJiblX4LNTJCYvkLkcu?=
 =?us-ascii?Q?3p7ybjBA+3ipi1+ehzZitTRlwbQgXVzz/iIhoE/1VrwCxtHe3ZjRMqNcWeaj?=
 =?us-ascii?Q?D2Z19fHGdl2Y/bX18iOsx5w+suI2iLobLgboL3XJLOwX7N6lksZbjWGU5JLq?=
 =?us-ascii?Q?PeA2vB0Oh6M39bJHauetB5BCz2oAZdVeE3qEMCGv60Mtp8fIPlP0wSd8cG6E?=
 =?us-ascii?Q?64tOXQ+hRugyZybmoxLrkWgIJubrZJgE4cJlVilwwuC6auoaW5AOX4H4Hagd?=
 =?us-ascii?Q?E9D5YgBQrbadkQwl94W87tnc6L9T2g4wQnV2O4GXP3pWeeHbEbsnlXB0ScoJ?=
 =?us-ascii?Q?LJ1lF2Q3ubS+mLbvsrdP1gg6pzRZJmg=3D?=
X-Exchange-RoutingPolicyChecked:
	eEqQtXQKohNG54Es/y0aM0P27LgliX7LKC+4faCANN3mLVrS3uB7l/5diUgqd2OBGDor9zObo0DwiDh0m/PJAmLLUdflZrly/UKLQaWHL9+iLtgHJqW+XetqNdRCvTzlU2s4lndri3VkkcC+HfmYPhj10lUJioPldRpi2SK8E8jiSzsQQ1ZQfpIo3RZSGtefXRTnMNXjHgC4y0SxHGLQqfCMRAI/vmOP5DAyCbD9xAzfuQMiMl1B4oaCxevAcrD+ksXujs/KlBaZwvqGZtZcz/+TLnG82JX46rjzQ3coP+GBJnRC67aQQUg5mQM1I01tQ/h9w9trsVfueHDDnUCdLA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D0rYFoH/t1bOMNSyoBaozUy8xArNDQt4ST/fKXeLLXbRv/aw1wVrCUJBHqb14XQ/K2u+LEMg0fz8qL129t9RmHga2avaRlNWApG3/dRZgqdQVypnJsNRSMpOvBmbnjuf2vJnXB2UdJiqPH1qTz/t30A3W/X+ho8K6sXcnLVZ0w4PvpZKwNjnIh1RIm+XLhpy5L5807vPnP0ksOBELopmZCpZvBSPrRpde+SX9e3sASjM5JaRwVokatR6n7bl33U8PwLCnoU9Ohc4sn238cTsmzGXWNyMCg39VUVQLHtWux+UyHLvbjvWm5Y64tG9N+dvJYx0/ixXvLtVHr46AouEbcpiIAHEJIBZb54X+7eYCmG7+7m822IlcX7Zl9gZSUQDc2LG8WDFua/iZxJ4/vPMwNvBg67lL8k5uIEaw+S55Cpfx0reL1GTwA3Jr9SUmBbYREF/ZkQ2yGibIj32l66HPWmujBDQk7a94CiuhpWCGzTpUTEHcs3RQ369Fgrt/jdEn6quKhIz9/ss1o+iDZq7xE8FLVFD/wlh967pEWmCay3Z8bF0W/D75ls33Taq5WsafN/i0VI+D77PrHRb3kHKaxPDC2dwLvB8GVgqaFPDBso=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f5bd1a3-473b-4f97-a470-08deebed67fe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:21.9206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vd4SInAYgkquwUbfAZ+IpIDV9EHTyzRlefyHLicS3R2gOyju8iT2mrIn21aCIofnANAfn1CN6G8UEk4FT3MMwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-ORIG-GUID: PmNuTZewDxquNM3opQSZzw-fkwkbNXG4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX7zh9cFqlDrg7
 zTH8AfuAkRfeSG+csdWK29Nvvcav1ngHArGrEwLtjps02RSLolf8MXrUJehz2Nhl25zxrxoxnN9
 rGCzzK9X1FoesOvHGmmSsd3Oi1GQeOVyY56lP6q/Ytp5ZVb/gkvH14lmDqQ6ZO/DZn9ffa4l3of
 hoXC7uXCG6ug+gUxZXxQHqp/QpvG8n3d5g8ShFtUBksq4mucXzVn5vlDmV7GhelL7AHaG1epuS1
 jC00ryOCfqIWaqX6Yqc/qoioVvtNjwnp8N+LImduBpB8D18m2PqJm1IKVvBJygPiNhX/5GRNRHG
 2Lh5FE6v11t4AjlfFDmpGhpl9lGlxml5WyHpwdYDVvGZ0MWcHjirSJJeqfjdKxFn3oIxidrBvca
 pDo1xyaUYXo/5jEJdOQ2XhweVBK+hNRWvJ4Pd59qsWn9AXN3aR7vCvqRycwk2C4O4u/Bs9QoFgY
 Sh9iI8/dn8rjxctrFbXTzBNarj3oFdbyIXQG2ELI=
X-Proofpoint-GUID: PmNuTZewDxquNM3opQSZzw-fkwkbNXG4
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a676e8e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=KFrTxiSEMK9J-XJLMaMA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX+iW92VmjYs5F
 exuUL0bflWovFlj0FNuKu3SfCOc0UaHc/d8jvJk9UOlS20aP5Ke2O5rbBFkmqpVmi4YAMnwY2dp
 Y1imTPaHI1rNUdqDT4HxO1KceiRamr+9kMK9aC2Dq5ykXDsl3LGt

From: John Garry <john.garry@linux.dev>

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down.

For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

A bio which for which failover occurs is handled in
scsi_mpath_clone_end_io(). Failover is detected for blk_path_error()
occuring, same as how dm-mpath detects this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 582deeb403119..ec611f26d7960 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -249,10 +249,49 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
                mpath_synchronize(mpath_head);
 }
 
+static inline void bio_list_add_clone(struct bio_list *bl,
+				struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	if (bl->tail)
+		bl->tail->bi_next = master_bio;
+	else
+		bl->head = master_bio;
+	bl->tail = master_bio;
+	bio_put(clone);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
 
+	if (clone->bi_status && blk_path_error(clone->bi_status)) {
+		struct block_device *bi_bdev = clone->bi_bdev;
+		struct request_queue *q = bi_bdev->bd_queue;
+		struct scsi_device *sdev = scsi_device_from_queue(q);
+		struct scsi_mpath_device *scsi_mpath_dev;
+		struct mpath_device *mpath_device;
+		struct mpath_head *mpath_head;
+		unsigned long flags;
+
+		if (!sdev)
+			goto end_bio;
+
+		scsi_mpath_dev = sdev->scsi_mpath_dev;
+		mpath_device = &scsi_mpath_dev->mpath_device;
+		mpath_head = mpath_device->mpath_head;
+
+		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+		bio_list_add_clone(&mpath_head->requeue_list, clone);
+		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+
+		mpath_schedule_requeue_work(mpath_head);
+		put_device(&sdev->sdev_gendev);
+		return;
+	}
+
+end_bio:
 	master_bio->bi_status = clone->bi_status;
 	bio_put(clone);
 	bio_endio(master_bio);
-- 
2.43.7

