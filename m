Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED062309AA;
	Sat, 29 Nov 2025 20:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764446590; cv=fail; b=NT/XDqAtxbgoUZGIs7CzT0d6MM+PJKcDcpS0alhCKlxkra9SlZlCjzeOHSiE6mmu27G3t39ry0SKZD9lDE2WKyDV85Z5H5Y3je1p98OPvXrANSZBLbP7jHL8YdHX2XZc0zTFhxPEw5lMKKhiiKavZhftduEAOhlLJNuE/EEYdXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764446590; c=relaxed/simple;
	bh=yIjOIy0f8u+mZ8rBl3wLV8t0ex8N/rdDf3+fXQ9+kV4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LZIzuNm9jHAvhaCLSfRqiraf2AI01Es1MMUBXq8bIZDPBNnRgVBXxe6AdCJIz5bxQiLDhT6DlbftYTC60U3QzBDB4qgkBAP4kEBb58VEqXordvik279ObN4czPx2sbKc8FWDYg3kFc8ZukjDSNZ7FkeMYuhYvKyEQ/7gBiXeHrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GqLg+2qS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nKB0YRQI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GqLg+2qS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nKB0YRQI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATDM5qr1698324;
	Sat, 29 Nov 2025 20:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wR8OjJZhDu5BsdHXi3
	dENOibVsrn4QZH4BF16vGv/hk=; b=GqLg+2qS51ZmzjvDfnOJ8QbXnB0lQKSq6a
	TdjYpDtVsZfjbWW8ROJe0lwUpNVbGdlHwiMIggfM4IkOBRdfLeO9LxgiexWKaFUH
	zyhrUnOO3QLL1cVs45mjrpFsUS/K7WkbquyQ6njDFgKhnCxabBLfmj/ZcT/x1izN
	kc6yF//6Z0HHw64zpofBn28AsdMwFUSIBBbF/NW5B8ad9Cl4MgsT8CeEJFYm26l9
	kO12SnCyPEPC9zqPM79ZWpXq6+t1HETRYwtdEb+lBvyOrUh9QUzIX6dHL3gByFOs
	+wTUFv6UQXCGEELskiy0c4PtZWTCdnxZis3oVt8ek9A7KIBWd5GQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqqrb8k7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:02:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATDcrwM017904;
	Sat, 29 Nov 2025 20:02:29 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011024.outbound.protection.outlook.com [52.101.62.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9gq5cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:02:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxp0LxiTWvs0JWhH9Uw6ukbM+i95LoMls4LSrryATRRy2XfydZLwNRu8mXmjFZPrQMSDZtSEpoUVjm4aQOqir17LmAFHHlj2KpkG96sNwmW9TA4OJjbhbmC06H/ZKB6MgbPertRTExo32kzOy1Ny+RVRyANHKu8iDt/o72zJ/r190QtABu+5XyujReWbrPQwRxW0KPptdUGywNz1OaaPmb6PYHE3nPDAwp+JLDAJOU7yea5PtsZl4DgQ4Yoqaeih0lY6DudqPHJMte8qQ3GAsSYbjCEt3KYjfs03JHFb12S3cLbvWvpQ4cCCITEmH4ARdIApjUigIZfX1q0r4q3oDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wR8OjJZhDu5BsdHXi3dENOibVsrn4QZH4BF16vGv/hk=;
 b=LjVYxY4lTGihe5yPJuO3qtVp5FiFNycu7gL1Im6quB5+E8WJADyV0nPhuudOWsG6tnjkXWn1dGyWSA2PyEH2hVCvVy2x0q23SWsO8v7C1FQ3Zuxur9RiaOVLPe5rJBvM3Tu6vJDjU96Vfh4rcgkCNuUeQfTpkviVJcYpgzs1bekP+36PGYvHFXc61tpCBqDqpDxFxhSNCjU4k32Hz9mfN5xfGFreQytL9kJRmoE+yXSNfph7MamblGeUwDMZbTFL/Ucns7UnNEOO9CbrtaiLptyDv1Wgp8HO+esjGf/mEvK0sP/RaQLwgpNpNFfTCrcmB++oZ1ls4clat92sIBf5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wR8OjJZhDu5BsdHXi3dENOibVsrn4QZH4BF16vGv/hk=;
 b=nKB0YRQIiKLw2O4iGw/JDK8PKAwVv5A4aaK9WC4lRP3S+bN8rFMUxSnyOHhrQ571E6J0ToNUgZEsbfz8rckGGB2S5zrclfhbtlvhoUf0IvtCcpDrmh2VQTGrMj0vro1HXlVkFspYFchagX0Sl/hcdSEgoHk3rxsgVMWr5xqKPKc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7137.namprd10.prod.outlook.com (2603:10b6:610:12b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Sat, 29 Nov
 2025 20:02:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 20:02:26 +0000
To: Po-Wen Kao <powenkao@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean
 Huo <beanhuo@micron.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Bao
 D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>,
        "open list:UNIVERSAL FLASH STORAGE HOST
 CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>,
        open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251112063214.1195761-1-powenkao@google.com> (Po-Wen Kao's
	message of "Wed, 12 Nov 2025 06:32:02 +0000")
Organization: Oracle Corporation
Message-ID: <yq1cy50zjy5.fsf@ca-mkp.ca.oracle.com>
References: <20251112063214.1195761-1-powenkao@google.com>
Date: Sat, 29 Nov 2025 15:02:24 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0152.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b1cb88-97eb-4307-898c-08de2f82380d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rCi9CLIbTR52vG324JeGTvMPKS/IfV7ZMwtcrayuVvNAX2mC0IB07KhNMv9s?=
 =?us-ascii?Q?JV59SYFBN/LQiMbsf8fXR40e/YoWO1XPTqANrW0ppCIU5vWCcWz7P0ybMEMb?=
 =?us-ascii?Q?gIJMQhZ1tsf5sgnFGNki+2kIezyiv6g4+XRC57F1Msl9HWSadcPUg+IJARaB?=
 =?us-ascii?Q?X0JKZR5c0kF7BYFnDyHso10K4r6RH5Jd6BldOEErlzHv70C0k9dtjNhZtp9I?=
 =?us-ascii?Q?5uhTLXC9WnCDIjVGL3IFPMH88zIZ3Z0MXxE4Ruip8BhPK7LRG9btGHUtVc25?=
 =?us-ascii?Q?YABDyNQqFcLvgBaTLRsD5G4TrviEHBvdU99hb+pMDBvxud8/an7Ub+N5Pb5V?=
 =?us-ascii?Q?OnLTFZTZyfmmJ1unXhlk8rhK1Cty1Fr1tNCx1jUTe7M7tYwJ7Dh6mtCB5uvX?=
 =?us-ascii?Q?JA5LehVv+nZtyj4rcyr1hgLrSQ5PTWprzDJ1iKQTltsCLWB88HQT2sGdtcVw?=
 =?us-ascii?Q?VHS/MsdfWGlHMNS89BlarurAwqzxO4qs2BIjhMB33KoCfrzyi6219R9ggWJt?=
 =?us-ascii?Q?BFk6N/oJyN9UzmoX5OwUhCszSoVxA9wISxgwKtrQoNUwcH0vtLWq+gvVMX+I?=
 =?us-ascii?Q?AxlELEpDuFyu2xnrcdDTo80kNhfsnuph1VPj/PoKahf2f7zQIGgMaOPRtbeK?=
 =?us-ascii?Q?n9faaR6o1NWIX1MFWRK97EsbWfMYCGa/49O3UYjWPlCknDob5L1nba2LeegV?=
 =?us-ascii?Q?d0ZCDWOYj9Ds1asbWvkl4Qc7QH7xOAIFz6w5sF4vmM5VzQEMvCeeK3NFJOFw?=
 =?us-ascii?Q?ch5oR15YeTc31VZyttxYkdwstbu4nRaeSRAg+aX7bAE7+iEGxy/XAtw9US7F?=
 =?us-ascii?Q?MfV4cQpQBvrAtn58+Tf30puxgqRQPON0tHn0/YtRA/WLlHT2tRvqp3Kqid5y?=
 =?us-ascii?Q?qsz2+swAPrg32XR0SBqpL16j9uvk8nrUrZf9J8yYcuuJDpldhKy4BCiXyN30?=
 =?us-ascii?Q?c73tE8yF2wX/PN6fxbU9pEgXMkcjvQ0rLWzXFZ9PqIszqH9PuCLxQ15Vw2fl?=
 =?us-ascii?Q?fSc/KD7+RB7WY7+aJFVb2XkzASel9DA7Cfe7BbBP1p4UeSAV2+BtO/yPP/Vr?=
 =?us-ascii?Q?0ld8uJjHLea4mQQ88tj/8eYujdO0tZ3Vs+JNeT4vkZ42Ns3uKwIOR5isvY0K?=
 =?us-ascii?Q?GiSLFDJFb3miV2263B7qDP21Zh5DC3bnm59bGCL7YAxYTbc8DDyaE6ZCIi6X?=
 =?us-ascii?Q?oKNM3VrfdqI0v6ExpVw7j8CsTTI0MGDp3EZX4LcwrFqOd1lvBO03wSSFQh2K?=
 =?us-ascii?Q?Uk8JJGjMXENsBrHfbYs4GYziqUjB5SdqFyRrHoCuKQYPJCl/RTwNeIcV8tMt?=
 =?us-ascii?Q?qXkUSxoMwWpfHrue/2ycaG8dQIOWxBzOYBOMjchvHelU0s1BMVCGNFMXftqh?=
 =?us-ascii?Q?dIKKy8DkNINMJ5+qr/WVy4j3Iihx1tMdk8cODqTXgSozx6bRiadP+q1oOJJP?=
 =?us-ascii?Q?np4NkQ6kpogfMoeDmfYySU/TX0IWJn2o?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ytdSAvmzVakBSg6rZ4lRhVX6BHoSSUxBQNilNMaBeTzpFl798itrAUmS5d7J?=
 =?us-ascii?Q?AOTuhBEwn1jfxf8VCWFEn/QqX4jhetve8SnYfGpihWS+L1iEF6fMzAY0oinj?=
 =?us-ascii?Q?EY2sceC6CZum9Zd0cryuRZGL6xZdXyKhcLBkxA9HnmOOUZrnemskEsmENgw1?=
 =?us-ascii?Q?kpI5PgFaJihOhsNRUVYAusM0KDYpKRvIfUkgXkYu4ndhbuiZwZQvW64hJHNB?=
 =?us-ascii?Q?elSR0PBrdoXkW4jTamKmSByzWZ+edGqQ7tduFW+znsA8V6bhKsNgwjK6fED/?=
 =?us-ascii?Q?ns9oj+RQOrPf5mMwmTiFHA+Ouc4EEbCNQd6ITpJVy1UhYhiseJTK8rDjJAuS?=
 =?us-ascii?Q?lAx0ArwJcE39kKf5MB0GzokT4iGHfZH1Ox/944+N0oaAMXFkBiAQ6PvcZ5EF?=
 =?us-ascii?Q?COhXuRba0T6BUFkHWcxCJTkyXTPyhN1Emlj8AoG+owJtJLlD6HArUCRC+Hog?=
 =?us-ascii?Q?1mkxEKIVPhHZ1XZzyGM4fC1nTlz166DzO/tU9aGmYQ3y1rGQCxHUwa2Ol+6I?=
 =?us-ascii?Q?de/7m3Xh0ge+sgJqNhE9w/OhMfldh9/rnBWEpuk/W3agskMnTLx8LSLr6NNm?=
 =?us-ascii?Q?WT88qkSE1GfsxgjRzvQKugUN0Dyo2+iEnX/7KnnAjkpRDilluHgJm3VMDZRM?=
 =?us-ascii?Q?KNe53zK0eQeLn3Oydg6Sdan+jQZTu/nzoY0aRV0erpnqyR7rY+OJ6exhEDqy?=
 =?us-ascii?Q?Is7opNtCazeuWnccwgt4gnMxa5s3Gv/yGxsMUkr8GsaCrG4SHrtrlNqa7IsB?=
 =?us-ascii?Q?76LiD+bVVhKHJC1NnKdImv/ZAJ12QvZMBsmU1rYa6VUYo2OCYKl6+B4P+/DU?=
 =?us-ascii?Q?E07PXt+sCrpSclvpFjSUELtxl0y6S+w3O5wqRhpseuB5wkbtdMw5VyMPB9rN?=
 =?us-ascii?Q?wnAMxKeQFtylwTC+4zCArJmDr0oQaaGktMyZ9MrtG/vbMDzAzvUq1vHL1G/b?=
 =?us-ascii?Q?+vp6zY9Xe2L0f70dgZyW7cdv0J7jjiPRSvCMR4/99dEjP0KNHdWO+xE2g66m?=
 =?us-ascii?Q?4V5xFbbDNJlm+PduLJwDFNaH3mrZGj8tzqZnkhl94W1UYsAQ23szSk2JuoJf?=
 =?us-ascii?Q?So7n7qWsBa7LFym8qNCjghH2fcBQf4E7RoSurMmVPvoX1K4rXGPxlEOwMsSd?=
 =?us-ascii?Q?C6YHUltLRHmz6vzziZvJxNvHmaRryioXSQhOXUWyeIK3oHy/VAuGCxl6JQ+Y?=
 =?us-ascii?Q?Kmk3wIKvx/YgavbZWAz9JS4XxiXPXqCxFuBQqyGAeS801P0obvD+6RzRsUOV?=
 =?us-ascii?Q?0ZL2mb4s4in/Z63svsq2XNKxg8pwOfIfuSZZYjdPjOzVJcOdZzjgYhZ4N8Ox?=
 =?us-ascii?Q?MfF9VN8lmGtVIxmijN6hZGeEiyW8YJCysKZi6WK9C9EiOheSfNsskSUuTv0C?=
 =?us-ascii?Q?1Q+1dwAmhCnqH/2ciHAx+HQtACqe3l/nr0e1JPDHvbLCASCNbLvVNZC/lgIk?=
 =?us-ascii?Q?A8butgkteV9kt8SXpHflF3M9AN864OLw8TGbi3I+jvwQre2is4wa9ecftqKP?=
 =?us-ascii?Q?wv2g5PmaBMm67jv8itl0rRIGE244st90Kf56Jfe4HbNrgqTGXJSDQszu+EUQ?=
 =?us-ascii?Q?GQKCBZBCVH4SkZbJLjZ79FchoKBFzYyWzTRHXp4FADqhSDzGkSH9pJQ315GQ?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	np5Jmn4Yt6Z/zmsjwKsAOxZEhioJsYQ7ZUvk3WQglpnset41a4GmgJUYd8pORDU/Ci2W8xpkLfHUu5oyt8+Y62Z0Y8vdQmpNyjgeA1vW0GOrNSq4UNX4e1f4nfg/abmy3UD0dVTLzbtSSNESBnH4afGnSiAXYOSy+BhGMHoqxd9oTwX31hk7F2bZXFgSlhkW4GIXl5luDnqrb4C7Hd69hps5bl42Aa/P2HCEXSka40bwqOWw22PzSxMhNlvQ7pQ1g3Bu5oqp6ICWBnw/T+bLwJMPyCcrwXOvCGjlCmbh4jFCyfAjZvpn+BLnIZ/gV7kQL3tqpwE15qqOLKP6gsiZQ3bFtzR2KXjIawyYwMvFhdWzM+37E20m2JqMW96DTgFG+ytzI0N3N93gU4BX575UzbO6fzzj21+8xgzUNPEYtcOMpbs2Bw/G60p2KG+z+YR8fb9NXuFz1iJytAeVCfxQVgvk4CCWOjHz9H8WxWcH+cU5+XrfBxhKfdlrn4X79WBby4XKCSfjf5X0HcAorTJDddm0LiXDkFCCgls0t+l2VT+E4kzEXvO2Qu5OWCd5+15rENClwBMnBbGVdcitxqhDvM0EJu2oO6M4lycpFiYaRyA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b1cb88-97eb-4307-898c-08de2f82380d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 20:02:26.7022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WRCZQ9SlELNBUlnWv1ubae0otY12IkNt6C/CFS2Afd8Mer6kIe2WRugnebXmolNCIyox/lZG10bI2wdMLb+Z4mjKVbxTBPwqVOOtFI1sbn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=875 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290164
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE2NSBTYWx0ZWRfXwEKh5I6BoRco
 7osf2363PPSc07aVZ2aaWiqX0gZFiAfi9p87GvZ3Enxz1FnBXXI9ahjcPT/0scoUDsQ51P03HnZ
 eLhtqfNGzEuY3rTo6X1yX+sAD5m687fvDq6gOWAWOUa84JNyVQwGehFdLiDKXKED6hd7Wi+/f+Y
 zdPBT/61xtsNoBgtActezupaO23ZqtV5wB0FdX4yGvDRcgk6OFVW3glGi4/foIO6c5l8r5bC00A
 zaM6QmbbL4G1+qOPoxvi9lgSsWlS/0IFQ1FobtKuzYrKvbMqbp3rPU0lJMlInOrIdK5CJB4thyD
 MtUxzvcmT6T65OUMqWQ/pjka/pEG41Y6sv7kVluB1x1HFLxvL2DC+IsOsAjuoLq6LT79EPtwbSr
 mVeVMnGfYNGr5uW068pxRskbcRllcab6FCA4MAaVc1dZLTEaj5o=
X-Authority-Analysis: v=2.4 cv=O5M0fR9W c=1 sm=1 tr=0 ts=692b5157 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=ZqE8iiNBColObR7-44oA:9
 a=ZXulRonScM0A:10 cc=ntf awl=host:13642
X-Proofpoint-ORIG-GUID: gsO-ud02paX1n92FzLZFlSrqqeoOsmBJ
X-Proofpoint-GUID: gsO-ud02paX1n92FzLZFlSrqqeoOsmBJ


Po-Wen,

> When a W-LUN resume fails, its parent devices in the SCSI hierarchy,
> including the scsi_target, may be runtime suspended. Subsequently, the
> error handler in ufshcd_recover_pm_error() fails to set the W-LUN
> device back to active because the parent target is not active. This
> results in the following errors:

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
