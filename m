Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B77447D94F;
	Tue,  1 Sep 2026 10:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259583; cv=fail; b=hVyRRmGHjluAg4kuX26fH5DXdkRC3i0g9KzBtY+V3KHHFI13w4sXgvqkdcW9kYFix8TFU21SguH/W/XxSjl/Fotx6ZVc0sNIzCOgma1THzlcqtFyvNxBBDgtCcvX41m/7siq98VjXIUjyKvkPxIS7Et28qy1MG1sIfKsIS+bs3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259583; c=relaxed/simple;
	bh=zdQ4TAieOo3zFUsLIGHdyqNlVpjNCccSJPd+tWLwZdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gjpqUZfR6F3Wa3niMAC43nMN5RjL4MKVV+lTUj4xzKrQfkvmD3gEtool2Ao7d3h4xIWJjE92+hCMnRaEnwEEFYSeihMKlOu76N8m9mWT/fI2EZxLxXBQMqOWQllhaqM3wzlMhk5fZYDPqYxhcmX9LFc3wefB2dz6NTXZnDIKycM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bhF3TFNb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KTzne1+W; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bhF3TFNb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KTzne1+W"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLCoLF2681576;
	Tue, 1 Sep 2026 10:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pIrdTxggcRFXzd7fCKWdz2+G/7DxutvADb6b1h2Fhbc=; b=
	bhF3TFNbMW/aO6OCiqN6s+OZB1QmAviRcsF+aKrdVc16Xz5WCuNe1z/JjnkGezEJ
	FKBmfNNS8JIbIkYhEsXIsXvBaDOemi7IuBCF2T3bhqeLU1XCc56ouM0dGbWuVPTA
	RqQsjoayvBVYc+afmF7J5f7W1BicgV7muq8acq+CFcGQVR1oOLPxceWLLOpKK9XA
	W62qUDMWajhBDSdk6xhfwEdXWs+u/TQlsv2nDfrJ6sK1oJuHme5oUYFltDIFCKos
	mscyXB0HrfkiySF8cTt+Rc6PjGMa/H4t08XODnYkApCq328qojDFoRsGLMJAS0OP
	QuOsOUe/cpY8h6UNa3293g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqa7mby3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjYA1036488;
	Tue, 1 Sep 2026 10:45:58 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqfk4k-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bejpgV1YzrsZ7RbOr0rhWQnZqM3diamUwn6SysOtfahmi+OqmF4tyWSGYVdPz9nlTbsbifmJOH3Yl4XKrHmp8Cl9a41cKvtBPxbFY3ldTgj7ygvxIiCAsdv1l8v4x37pjU5QH+k/gDgZABftKnAWm6yj8vl+28nyuy9PEwuo6H9pyBkJiflQT/gQ0YGm9RTkqHikmUIml8AmiCD5Tiq65HM/X5Le3zr/uFZhcVBf15ld1cHXpUqSk0buH8yXnD1SHosrrz9tHLxrc+DbofwdzdqhcH09MRhOoenKPpB42xFG4uS7RNfQUx9PeH1sZEatskW1YBL1TAigDqmWULrKbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIrdTxggcRFXzd7fCKWdz2+G/7DxutvADb6b1h2Fhbc=;
 b=sEkyFTEXRauwzNWdYHS0WsA9eizhNcA2C//H7uKNvF9ZKNTLnUNfJGu7pMSgLziDo9SK3gMNaWKzlN5pELQtE5dBKLh1nSVqgKYAKWDjLWPG2Prw1pqU8tkeAiUWop++QThwlU9DxZv1aEA7UBkPHF+zUBsJyADIeil2MyGgxu99aideCwskxZsKC32GUWFbSC9hBKnTzC8zJ5+wGSoO0Cg3puU+DcN37BZlz+ridCXvZAT4eZMSiJ8fLPVhRtErbx9dXKMvRmcuIgaGksiVL9m0o1htB4kPJVnijML6rNngBUj/HxLCSY2Rg+HJ/Ygtr3dL4BloQ4UFMu2REppahg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIrdTxggcRFXzd7fCKWdz2+G/7DxutvADb6b1h2Fhbc=;
 b=KTzne1+WZF9aE3qRr9anPVyw0XRkXZGxmL8letK0smIBtM4JlHdpwQ1UJ9ZrrROJ4eTG2z35ORVTLoxdtXI/J0tSvQa3PDEDJUdcvFWMkVCVeYIvodz9Vol5iLSF4Yl6eueE8hAo5GoPTX8U3wcNHsVORuIy7G9I9eX7WoU8VvI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:53 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 09/27] libmultipath: Add mpath_bdev_getgeo()
Date: Tue,  1 Sep 2026 10:45:08 +0000
Message-ID: <20260901104526.3850621-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0053.namprd14.prod.outlook.com
 (2603:10b6:610:56::33) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: f6ae9343-9c48-4e00-55ad-08df081630e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	gA8Y2x9HWNpuGp2pK0MxkQ67FeRwtWcUIu1P+rJg7GGaWu2i6YXw27QEm8oBlv4/mwKW09PPqx17n4Ku21RqApEUPm6JqJyi4Y3ocqduI2Kwy1XFtYWGmfZmSYykPH0eCymfBjaGRqtKXNUDsSPDa7XRyqTUcPzVektqhfiy9m8IW4QI8EpHCfsesYtpRrviUYBgBpmSyuMwLJuz814+imuu6uW+v0SPeLHRnsMVrJ/3Cd7nOmSKj/jXTv/t/Fh9l7VpOI/hl7ypd4VT/4shC01I4vc1sT/+SFxoYIdwhPSIREdA1cIIwlFuWMiTjeqly/esgapNemlYgukguNpLPcqRp4wdxknXBzNUF/Ct9FvsiFS6aK/WMnUfwZ5FfJe6AEgr2tD5QkRJ6Lg7sNQXrVmFeGckIwLay3Nkbr0kiqpDTlT+L9IHudp5iZSM+6DZSpg6WnT5KuXkf9Tf0oROc6D2vKSsVDQOz17qesKv4Ip37BMH1Appj/8MVF9cz4dDEdBoSKk4MF9VRoWRWetp+4eUQ3At0gSypBpWHMYFL7rqf/rFOdv9EUFMnwo7twUXW4TojCIEkxiWOjhzMNqStB+skb694zx6jqrrgCbEC4fdVDr2gWq1eYyLwpP88m2y1wCwEB0tY8l3In1rAOLFBxDIiYOfdpPnw3hNcckBW6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iKGP6AzfZ93YStPDxF8uPa+dcJAGHZtIm7QBaLrClCPzI8gImPtEO+dmz56j?=
 =?us-ascii?Q?1uPrC48Udafrb4QTmD3mT+nsBEn9D0/3Mg3ieuQjGVo9+s6qbf35NE2h+U5+?=
 =?us-ascii?Q?6n/tQqDjMCWbwNdvsD8PQ1KfbSDcfrzuAd2amPnV4wOM0Y7B9rAFodhBixc2?=
 =?us-ascii?Q?jqxdMijh8lWy2ycFDRmJsEbSbwGHc8T7QkNBfayXGUzk6jbA1QHz2gUBOrfE?=
 =?us-ascii?Q?MimyFPd6X0+L8E1YUTjq6TQIdHHbjwktvbDgERNqSincuukA6Erd6Md/JiZ7?=
 =?us-ascii?Q?7o9LZ0PaFp1xURxXqnIrc8ayCh1xriwHDZJF/aM8eJ9UwRSOaecJMSrmmD/1?=
 =?us-ascii?Q?GYC3IN2NQxyO3duwRx+c6o3+wN/qLM6ARw6Mmxwsi6vSAk0SnZZNjV2Mb/cO?=
 =?us-ascii?Q?2wlvEX5Z8E0UYDyksvY2uX9ojySJHsq2gv6L0WbCJf9tHX9EzC8/LOlbH/2B?=
 =?us-ascii?Q?7Ri2DfLyiCg+/5T7AlU6WT7VdtL0ClokcNfFHwrovdN+w7NWhgFpIShI7xTQ?=
 =?us-ascii?Q?7/gLeF9A9fKOJjqhQpIQz7xFYusYzuur8V1mWsbSofWNXyQK/xtQ8MVC20eS?=
 =?us-ascii?Q?H8yvZrCW1DFKFuvUU1h5OaRrYWXOrUkD0LRE+PACwL1NUdRKpMhLWzzc8ZfU?=
 =?us-ascii?Q?1UhjyZCwH49BtPEhPDfw0Uj9+Okwb9GZW6LjFjz8jC2AtQM2zGbYv8084h00?=
 =?us-ascii?Q?q3wdUu3jQ6EloEXvlw9UDy0ClpEXzz5jHIfyUPoZrvSQLLIUByTakJrR0q7V?=
 =?us-ascii?Q?TP5h0TxASF7xLGkk4yctzgAl2V36lJQJ+sZhUSb1PPKvlmDHeSMFrBWrPEWq?=
 =?us-ascii?Q?SmK2zchUy/HapuqXeuwozzqsvPdNnSu+YQsXkAjaOOhGpM8MvkSELcPL+p6m?=
 =?us-ascii?Q?ASE9Y2HsWyl8zcx9Y02NZL/wmvt1t6dHcXHYaDII9GpZ1ks0QqqTS25BcvsZ?=
 =?us-ascii?Q?VMlWNn2OJXn2GDNeZgbA3VW3r81xwJM2vxmFcWj0XPHbjFD/gUeearXRkrmF?=
 =?us-ascii?Q?U3gE8Ig+EyWIRTb1FJZ2KXNht8uV8o+Ps52e8d8AvH/UataO5LmcaZpRw/wH?=
 =?us-ascii?Q?RGu622n8/9BGD0OHiUJ6aWTjoFuQjddmdFK1sME1jJepPajbcYEbfkopAPDU?=
 =?us-ascii?Q?y1/+61TTlrzo9y4hPM24CoO+TDtfPb3vz3tvRBgK5PAygAop0Je9WUOMfKOt?=
 =?us-ascii?Q?LCE46BnIeQ1s2WLejHEQJRX8IO7Cfo67OnPliwU0mKbB2E5qsWF4bE4kQ/o/?=
 =?us-ascii?Q?9cnXAzKt6stuq0x2wV1bhrnuUZA9DWQlKc95tbXa4on9gDEBOW5XLLOrMNH+?=
 =?us-ascii?Q?x1t0R1Eg8DPFP6uWzzD1apokC+C+Ao1vk8GxsbwbhGbjKoHJKQqcWx5IfBR0?=
 =?us-ascii?Q?Uofn592uc9+Wew0CQLJRmRUirEHDJYHBoElBN0Smh2qnkwS6tYCIUTlHMXWD?=
 =?us-ascii?Q?V5RUj25iSpSdn/Iq4LCf2mEOMDrYJXIGjLnIDmn0YhnTNBfEo0i8AYDrrTo7?=
 =?us-ascii?Q?KNnp5ih66ZqWguwRX0gtLlKgssY25T9Ix18S0dYk23PD97X7pW6dzSNj0dwy?=
 =?us-ascii?Q?3QDMWg2ESA8ipfzoBHbjh39jwF/MHF33SUc6EhaSBktDZZo2KCogRHlquehq?=
 =?us-ascii?Q?N/gOH7azVPhiOt+narA7eceHrsZciYZXZnyQz3KSJBZ4I4+yg9XciMF8f8qN?=
 =?us-ascii?Q?nSV3QLceqUdFZHSBC32eIJncOZ8AqvU1iPbM0vgaRCErjWRiaiBMnQhnw6YD?=
 =?us-ascii?Q?Mgo9MmnmMQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	T1TiK1yqFFONKGbzFzhdA1uW+oYG22pufFvx2KzpRPgQrunxLE78SZxfAt169jHi3WOxrZ9PZYtLAo8MXh50E4++9YrF/XCJOzqq8cU8VBp+oJuTK/1MejRt37pXG60idI64ZYCPbu1feu3UHPK4ep1ygAhQIx09KOhTezTFgIWv5cDwVMDKZR96JQ/mqTiT1OEUfVgapAK77EpwLPYZpUY2nTJk7cR/+Qk/2U9qAHcXY28R733ePVVYI2kwNUWnB7B+iWl0zutmBoai52mDP0w/gfVtVfI0vv2vi3BJTYA3yv2xcDB+3ObVzptkIJFPlLQKqBHu7Ygud/AY14Zhhg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SCS7mP3qH3y4Nzt3ecMnk4jJ4K/Fen/SbO3voVq3TPvI5C4xzeW/Go6oBydQy2KmOS+0fZZYp+0lI/bEDGEr05UnYHweKazxir3gTePqRVpliGRvpTNM+ioeIzbft/BFZIK7HJCXN9hvC/2UnLlyl9Eeq3SHCssgnhf/NsNDNh5Eapc1skUgGsftrUT/XSDxis9nK6Yvbh/CcSQXDo+Lwll3k4bOw6N4oR780zE5RnuODJaFW8t9x+jZsm+noK9LcQB32FKqFfPA7MEGZtblxqYu4GFuKL+h3CX1Th1mzFMGu+6waV24et8oh6gzMK/76vnqZwnq5+07wCWXtu7eOlUFm0sWvN2BO88cvTA7o2iGzp/QH/29lljYhtEDoXIKpcng/ru1gErEUFRtNfm+2y5m3TY5+rg5bM6AFrjMUSYIib4GzWjRzxdEM0XreeAaA96FP0pnn5rt6ntkDrsIerOem4lExKPZI3VmVPDh+l/cHIHAgsRF+NrjQTl9dHdbsxV9aG0rTX0ixPkabjDG3JqHw8a6rXifhNCVfQpSFxyop2Q6ttJSlDf6pusE6GAI8f4uJH5/E/qJZVUjw39XZzcuZKb9/hWwo4Z9u/qNKEQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ae9343-9c48-4e00-55ad-08df081630e2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:51.6555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2tIImiuXfpFPHAzqsM8wQjQsWpcNVmLlDC2GAPnIb+FikwgzXR9k2c/BtTtT1eqzd5lxDw/B/GIYOArzzpB9EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX9XR7ahAGLKnH
 kEinu4qXR5MGjv/z+TlRfXBXslarDsmxFs+G+dPQzFtoeGeJbsmj8of7jbkDzBtD1+Pa56gZVv9
 bzyic+ULlrmsyxBpQgLMuPq0BKrRSHbWf0BLsBs6W8Eu1HwCuXMH
X-Proofpoint-GUID: ZZf-6_uVp9djMqueE2ahYggJofbhToiq
X-Authority-Analysis: v=2.4 cv=DPu/JSNb c=1 sm=1 tr=0 ts=6a96ace7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=-Y819F9slc_s4kW3I9oA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-ORIG-GUID: ZZf-6_uVp9djMqueE2ahYggJofbhToiq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXxBpMkjpx/w3j
 mM2WV6YM8sw3lw9cTz9AKZW/UDIsqjcPBvfNH8STITBBNwd2VKQuSmRXmTT7XvPHq6qLdl2u435
 6N63UFbuN7fINCV2FeKGrjljEwgJLiHBc4w/FF+eWxZQ37p6Iu/Xe1dLIlgRqC1/8PHL8L2GPRJ
 lxoovhe5Q1a0FAPILk9qYgBTMhzqfZ0pyjvypgCjT8Go6FS0yeo90a62WGS9vBBtZEZ25TOfM3P
 75abE1HDeQAek4sgXszqI4FiRuypJTA9aDvVg+U2w3fdd1IBIeQntJMrAy/bLUfGe8XCb0opKa4
 dvvs0py+fulE7zeg8FovMCyfC62Cow7CYxKmo9OhG3Gsltn8N3mWTTZxOh86rYRJN/napyRErpi
 Ds/hz6m45LFbKqQvUF93jkZGHycBv0caKdSeQkh+X4HabWAnowezPcIO5qQzwzy8qSPN6JLZ7Xj
 kTOwqFhzJW00KrjyEj7WjZ2OQXDsNl28WX8ONtgU=

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_getgeo() as a multipath block device .getgeo handler.

Here we just redirect into the selected mpath_device disk fops->getgeo
handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index f1758d1e60a60..2017c4d0a210c 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -490,6 +490,26 @@ static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return err;
 }
 
+static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *geo)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->getgeo)
+			ret = mpath_device->disk->fops->getgeo(
+					mpath_device->disk, geo);
+		else
+			ret = -ENOTTY; /* See blkdev_getgeo */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
@@ -501,6 +521,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

