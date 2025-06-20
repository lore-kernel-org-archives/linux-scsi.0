Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC0661FF2;
	Fri, 20 Jun 2025 02:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750388296; cv=fail; b=Bw+bBAjpuH1JJ2ZaBBYqe2c8YvrbCg9ONnWnPBkg6s3N3xd2h1W9q/qzzI5f32hDXn11TgdHF1mm/7E1fxo8zZzAe6fcmYp5l4jWgaCF0tBAztqmOqVbThU2mJ1/71GQC3wO4O993hyEB/4jekJphageg9N4NHus3X4HBr7C2WA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750388296; c=relaxed/simple;
	bh=vTfrqsStRyQWJWgX/Jpv3wYk34/ir9qAWtRohAiC7nY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AvISlR478e9NJ9qE4l0NfpdJCfQxSWIfvxigge9a8Jg840ncls8ZudpERFK3Tw4htiWjkGvNzayVQRRysFLBu8FSzfRNvITB4uT4ggGJjo1rpSMfUmwZI3Shuctj/0tneEQGhQnACUkhw5BLEt/xlnJyo0UAG+mwY48tJSFVUJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J3cvA1zU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cUIF0bbB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J3cvA1zU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cUIF0bbB"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K2th3p013781;
	Fri, 20 Jun 2025 02:58:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QjVjSp5dgiP7yY66hM
	cy/fCxuxAmMuLsjjadAUwv/5I=; b=J3cvA1zUfzjaMOrZzwQTlNIX1pyEuBAmwo
	srR2wi3m7gBJ4M/OJcXzdSIFcK5pWIBr5rQv7pnOq8ojsXoLQ8iobEXX6kLRnSEl
	5P3V+AVvOmW932RcSzFNAFPtznf5f57MQ+KodNFtjYdpWCp6rE21pIE4pfizsHQo
	cQbsxNG3Muvg1ctV6y9uIQpYBC1BcvjdFY7GHKPmhjqVjd9W+rijTSnE95BmWBOf
	nxao+izc6sCPApIPlaQ987yKTHLJg9dMKoyO2pTKFQ4b0ZynWnS4YHIzl7w99ls3
	q+wDQEUJVM7jt/9kGznBqYMfRQHdsQ/lBT9noa+MG1gJ/Xy/F3Ww==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900f2vtf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 02:57:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K15tfv009614;
	Fri, 20 Jun 2025 02:57:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhjy1xf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 02:57:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jaeDgca0OjH+NMMzDATLczwlg17TO6ke9dadhLjk30/BmytEyJHZqPadZBHrxzySdaaeJ/m2fVO/5iYhX15A6RBxkA3d+XnxLNJ+6jH4tRu6vmbALxYBiqND9qmHe3Y6lW9fHhcsFZmXugKye7d8kEF24rKNbHFjiPvvhEkYm8yD2ItPEqHuxCoqC6xTrQH5rrUhIEy0eBce+vrjglOENTJTLCHqHBaZTE5xHH11YiU/GH8VywKzoLn0M2Y4jhd8s2Zo/1+35eP9V+Mw3jF6Kd8BMoQoPlQhan5PxUjiS8I01t738I2PfLmb+A3sjrx2Xuk/sfrIYgYw+oarQjLwgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjVjSp5dgiP7yY66hMcy/fCxuxAmMuLsjjadAUwv/5I=;
 b=Urv9CKvn/cHfGvf4mEmLx16dQOwQx79uImTaLiEBqS+ybjH0Vm01WB48dgqR5nX5KMejZCwO3tgO40yIYf7jTJWD6aL9KPoy9nctgLVKb4gqqGeWI9fk0DyhiqBbDLCXlKJua2K1QGrONScwpCGtSPJEdIoS8620MlUerInPcoS2ruFO3urgnqhlZ4XPOYP/QpEDOMQiy4sEKQ+B0weQZakn7I+mYp2p4Xij9pO6FVTK/7zVngdnh7/aTxuizoVBpspiS2LXnXv9NrtD8kx1OHTTWfctAPvyuYep0RJFdghwcZk8ny315qFILDrI38cSrmgu1+B1wGhR130fJ8lqNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjVjSp5dgiP7yY66hMcy/fCxuxAmMuLsjjadAUwv/5I=;
 b=cUIF0bbB20kk8T2T3FT+d97dLPD3cwyoWzAgOxCxAap2T2E1BtBM8kuKmws1pT/eSLx95+JQWGlJx03L9K8tLiVymK5KBA3pzypHDuzT7HHQML78MgQkF2SAf4pwvDr3emMK8+UmcQwjQXb5jOqYVZ5v7MiwrROhkCRQaOEWiNQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6634.namprd10.prod.outlook.com (2603:10b6:930:56::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 20 Jun
 2025 02:57:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.020; Fri, 20 Jun 2025
 02:57:39 +0000
To: Francisco Gutierrez <frankramirez@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Free allocated tags after failure
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250617210443.989058-1-frankramirez@google.com> (Francisco
	Gutierrez's message of "Tue, 17 Jun 2025 21:04:43 +0000")
Organization: Oracle Corporation
Message-ID: <yq1ikkrt90p.fsf@ca-mkp.ca.oracle.com>
References: <20250617210443.989058-1-frankramirez@google.com>
Date: Thu, 19 Jun 2025 22:57:37 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0110.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6634:EE_
X-MS-Office365-Filtering-Correlation-Id: 068497e4-8c2d-43b0-5ec8-08ddafa6380f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nu5koPWrPJ40Vu7obOGGhaoj+mamnDQjTIW/mVinx8LiMyRJ+UbuE0wGlv+9?=
 =?us-ascii?Q?ZVhf9lazzEOA+jbAN62n2/O+GDSRgF8WTte9OSXD8MYA+NSuENFpRB8HM8KP?=
 =?us-ascii?Q?zG1W9JS3+ZsRyDZYQg/vjBwWNYFXQVAUndCBPfhWM3GpZyB1IQb8OYMr2kek?=
 =?us-ascii?Q?zdlYQmwEklkyE91o2V5K3fQNY9tP28cCjHwk95MP1TN1rp32wQlZvoUmXKXR?=
 =?us-ascii?Q?UYPanmcOBL7d5/asAn1RqNkTChDBtBx0FKnUnVYruUF1JefbvJE0u2IxNwPI?=
 =?us-ascii?Q?peyC6OmDUXLcefyCjqWq+3QxN9Mucc2sB6edKjrQ7wgdeFCP7anOSEMAeB/w?=
 =?us-ascii?Q?dlyu9pE84eeQGoPXJbcRst1/IHzlksNNoyUOck8yuoeHgKu3PH1zQfMLuXJo?=
 =?us-ascii?Q?kAUFi/bCJ6gldfxwI/jz1ST6z7pryN+Iczlc8JiF7TDUKVdR55K1TX6eHqp7?=
 =?us-ascii?Q?IRhWg731TRXnErCmeUV1cfFPq7KaRTVREsaXr2Nx87G5c/FZDfmm8bGXimwH?=
 =?us-ascii?Q?8HbZ0zjjAHEXzfqh81jHOJQTbOUCLKkB8w4MJl+z+8C9FprajnLTkBNzMTwC?=
 =?us-ascii?Q?+pJ/tvU508wdCWQr67dJIeafhEg4vy7BROfEoRsxQgz2gzjgtcLKbM6NeWNR?=
 =?us-ascii?Q?v6tx/oxKyrTYaI1cCU8jdlNYcnLiknIqXaRKSemGs5XsQMALXpapT280pKtH?=
 =?us-ascii?Q?aEEzNMOx6Y3n0A2CrxXuKePxnWp9vbg9mWe4e82MkQlrTDFIzcwiISJErrQK?=
 =?us-ascii?Q?qufKlMwjUH1sPt2s3ST6uKTCuErZV+vBhbEUGHPbby7BRfwE+Yc8ARtRF9Fr?=
 =?us-ascii?Q?ExskZSPdx/MIOrHclNh0IJy2+1/OqDmAa5QFFKqsUIl+6DqCGNku7b1odDMm?=
 =?us-ascii?Q?J6oVAxkefCyVhShoTttif60DhSaMF2versPmeNKQuRW5/ipOQ27Ma2Sptbii?=
 =?us-ascii?Q?Rt7td5qRu81N65bh7wqFCIbJeaqRyauUEsIEKrJTS18jdr8VXLeTQH99d/Di?=
 =?us-ascii?Q?G7PBhg4/ET0fjHg+WAAeOiIG8xdzYHifkd6tAMXr6HyP9GCYEzGns2om4qp/?=
 =?us-ascii?Q?9RhcdALTr2eqHKBDb00dTFDhAsMPP5SF8CnlVr3pbwkXQdjDbd18MB3+Hyge?=
 =?us-ascii?Q?bO46j1wk0gRQUKAMT8oOAdGDQWp0Cmsh+Pr/yHnf4rpccpCm8nBH/AatEueA?=
 =?us-ascii?Q?k7utnvpn80Oa4tnojCXYhyf2/dW/o5pOCBiMpQGAtgn8RC3Oz59Gjk6S45f6?=
 =?us-ascii?Q?2XJ/WxVzhJ8Ge6DOcM9apCMfM6hgAGldrxeAbuNjxN7+gABMzYwFk/sQMC+s?=
 =?us-ascii?Q?+fzk1E8t0CpnQwymUruDfYV4InzFAZQFCXZEfrPuB+Uuu+wFjb/1woQhPzdu?=
 =?us-ascii?Q?7pGp8Jze4HcBuby7Lk53PnEZuj1JGVrQyLVuGBMVPJUiIo2AGrQ5HFtocXn+?=
 =?us-ascii?Q?HX7TrYLfX34=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v9Kcjo5zRiPpURLDzIDydf5PVF6cjjh3DACfALV63SpHpIgoB2l/IJfJ1x6L?=
 =?us-ascii?Q?l2WedGSrUOObnL26gaCHNCklgJ1dS2wJGse8ST4bTvSkmvkKwm0JChJyvi9m?=
 =?us-ascii?Q?BaGxPqNzu47R8RBl78nWDbDwgEp0BJqWhtIRMMHEaFFu8o7lWkzjaLApAECq?=
 =?us-ascii?Q?gWQqwoR1jhMIWxvSXpdqUY/0SoYmch+Cao7uM11QXI7UPeky+TK7KHPCt+0e?=
 =?us-ascii?Q?ax2mzS/MCQBkQa+aQH0UMAchADiPLbT9qHKamPTnnEVCIi4LdTTVNDY/1Yas?=
 =?us-ascii?Q?QesLUaPFnxkW1m61CEt9cNAH0z5/tQUfybJ35tpNjwjrMsD3m/S96xgmuxBU?=
 =?us-ascii?Q?eJGpurQIJv3bkEEbPw6x2vmp51+Ts/lTRRFYbUjDJE+Jebgr79jO6FhOGL+2?=
 =?us-ascii?Q?9OHwdOGc+KXtyacwGezL2t6hP4eVwWYLNXoIiAERiwLFEkNE/lzMq08ZaMMn?=
 =?us-ascii?Q?oRBB4XX+p0dahWcOTIu9fyLnyFRDnuttLVvV1NpFDhO/hK26GOGjdZpckLCW?=
 =?us-ascii?Q?XjLBMkgly16YtJf9q1YgL518eCDHUvULdEvWeFXqLN8phtTlhK5IE+TUcfOP?=
 =?us-ascii?Q?6CgmG258A7oLD9HA5FjxS1DgjT8GuR+6JPfy/Lg9TlbW7mNxaRnWC6PMW+fa?=
 =?us-ascii?Q?lWPYJFKYVY6vAtB/4HVaxQc8DgpyuSSp1isqQ0GbkxvTGujTXpnwF/V5Tdkj?=
 =?us-ascii?Q?QP2l56DrvproKdIdIV56/7VmF+K0P6V6c4nNx0yXtXsaP4IdyhNDCqIwfFS5?=
 =?us-ascii?Q?nu6pGHIkSIFBJB/c2BG9PED1E5hyLt3OWyDsqdXRW7TMTJmGfYkfxxAZx1sA?=
 =?us-ascii?Q?BGLdOmGm/xfQoAHQErr8zW67Wnl138wdS1Z+9XQOVbEvFWLr23VD14Cl74mj?=
 =?us-ascii?Q?RrjMnuAE9UcPuEt9/ZLjIsWvyKwPiFF5trWZxn4VwTJm4j5MIjJMxgT4p799?=
 =?us-ascii?Q?ezKIMsVkSvL6jEemIypQisCB1gH7DugaPcl7QS5S+taYxuJDkRd9v25CuYpp?=
 =?us-ascii?Q?VKgH5+rgd+sUsX01bA/P1xb1JTdXeEE24KqWV9VzMTIGe3XvmVbINH+fOYiW?=
 =?us-ascii?Q?8LfX2xS7il1huyYgLGfxR9huIxiJjmvF4rnVZT/pj4hc79pAo7AxBoHAk2Xd?=
 =?us-ascii?Q?e8Z91DmeAsSv55dqctU/4rRFaLabHEBaxUojo1XvR8z2pUNM5bO+79/F61XD?=
 =?us-ascii?Q?GYcfX9zrwQshlE/NJ2xNOnZA6MU4hsvr48f2Wkm57+FLR+3A8rSzwDHNC5KB?=
 =?us-ascii?Q?92ijm8H8SPCIxb/jo6nn9H0c3PD2m70Du/ahZC5Jw44e3qjSKyEQKy6r0zsC?=
 =?us-ascii?Q?TSI6JLzED25VkFldJCbKIWOqp4gYUc73rd6G5kQOHpCRLj6S6TqW2OUO7cWD?=
 =?us-ascii?Q?lRTAkKXZXE9VhwktMVy76i36U4tAf+VLl1EOJ/HWUJ5oimwSI3vOiqBLwJkv?=
 =?us-ascii?Q?QwK06hdsXNDX91fJFrwThrt62zqpo4gg8avoEf52ZYtyXp37YdKfy/H1Vepe?=
 =?us-ascii?Q?ebbQJoj7OSvQm/4ue7y+/5HzPy+VKiFeJ213I60ttDXFrIRxWGLhqT1cKum8?=
 =?us-ascii?Q?PdnTiJZl2hLC6nTpmvtti566T9R2BeVsr2Yrn3vyzfFNdKFDA3DEqX3jk3HE?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f80I8FJZgZseqGDPjz0RSbAKwCtNMi0xvIzzf5wps/xqXAfF+FanArtO82VV5S3h00u5BM6wLj0E4QdjkTxTf3Q6qLoEM0rX4Gjvei9pfcuF5RRxvIQkOR+hP2WYC2+BE6OIIPQGu4PDc12gm5tjmLFKbxwl43rWpoPXBHqKHEGDNmsJXedhx0WFSja+Lft1eWGB7lFF1tiyAmgHojWOQJ8OHb7GP/qVs4R/KWvn8sSusWtwZNjVSeZC0dweuDs7vhPXVsF9V9GJhHQ/K+aSUM3PuW0ruH9f7LFbsCGuHJmi+s2FwedDw4swd6sIAx3un9UNuMav77U2S0V9BIsgUvg3HXtyAgjPcZ3If3wNtztEDm24ZCFMqkH/eqWbbO+oThyVsmT2n4rlvGgy4XXwiJ0Ks1IjmXpSysYrPMGlDT1Et0O7FCV15Wmhn1mUMD2RBEJJ1VvMK0DiO9m6fbSpHI62z8NbSrftQ1lnc/NQ5Tmt5DeTh0aKnJ5Lg76D5zidY0+o82foLPzrSQSHbAVEx3x8K+jSIgcWQBgpKpPev5HJDtPUVprOR2prMPFONkiUNvDTdnTMdqL9RpbqJvuhf/yn93jJIfbUn+gPeJNizxQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068497e4-8c2d-43b0-5ec8-08ddafa6380f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 02:57:39.9559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFmYz/l7LCEAJ0CGIU7y2EaHxdI21WRCgvWv+p+5DhogbhYxcreOICm9N8psw35vkN2qbTZuGGCK8zyGhtOiYMZNtT+EQiyq9xw+UvFyFHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=720 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAyMSBTYWx0ZWRfX9VPIqgbuy4nD qZShb3QePAtO4NlVG5igqPs9s2Pg05v5y/8shTqjgxzhsi2hB6yfoCE3K1jeGUiOPedwx5xOBg0 VMaMOnjviVECw3rVirC9+ayTA8zY/dg3Zq/di02aZ/z3Q/LjOtE8JOILMGg7/V20hZDmesAW78F
 hdrp6rJ6XdmzC5L6/FIFYUWQvv/PgsK7M6Sk4xhjTMuKtNgW1U0gcUHcWB2DMyX8ejvi/comlgR eT9mFHhmujXgFWVI1xKGLbilhnBeXIw8d6/wCQHCY7Av8wmziyUdx2a82iamYW2JH3Wl25nwYic Lmg1LvvRaio08oszAejUnaiImHuAiNA5C8B3+FYjtWS7E5E6uXYdI7gFHsjS6YsEiFjZ8O8p859
 bisy/q/1WVfw8rww3RDRsrtrQiQ/eSo2h13TBYlEd9qGex1HbKJSSKuLbX7eD7c3szCKH32n
X-Proofpoint-ORIG-GUID: uz_ORtVU9yhFeosoWhbvlxzgklphEdLw
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=6854ce41 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=7RySB5BrSG6qNBJrBvwA:9 cc=ntf awl=host:14714
X-Proofpoint-GUID: uz_ORtVU9yhFeosoWhbvlxzgklphEdLw


Francisco,

> This change frees resources after an error is detected.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
