Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4D8301468;
	Tue, 24 Feb 2026 19:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960436; cv=fail; b=Dkz/sKRJnxbmVxyFtEHIcXnSXQneFSC6mlbNtE1cbZOBbCU4hCFCcnA/DEAfLPj7NYbR+lBi+YlgvO4Z96sOh4Svtz2rwNx2CxqCjkFDkzKv3ywM2R6uhjYBVsNfWk51ThVM7gbrcimhk04+o9vYfCIoblBGOmEUEcOWBS/Eheo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960436; c=relaxed/simple;
	bh=JCu1hDOp/dEJhulroDwmiGOGowRQwWniDDgmExmBK8A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XyTHXKDS0W4GJ0NeYnHtEV9WrAxDvqlsn8Df3j+UbV6SWx2NPgKyCcNknlrkNcw4xvFJrmrhxMxpTpu7nhgIZobnwzYARiOVWHa/PwAPKfveQlb3qO+DGQGPUIIq23ZL8t1r/D9EMIgSflco2n2rktLSiynqNKx2y+MyR4XouOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d3sBRSea; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mmUDvbzp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d3sBRSea";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mmUDvbzp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OIu5m7817877;
	Tue, 24 Feb 2026 19:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Wk1eS6nMTUNM2k7f0J
	BoHYwozoJHv6jfPnyRNr2b8rA=; b=d3sBRSeawVlb25F9U54KidYv39SO5/pQV/
	Vie/fzH3ObhycFn5rjPfhKi+xEyukTRgK6S77UJiEeVYbP99MiPsYTcVqwqwogjd
	b5HpWPCeaWn0p8ymgnbfbk47mBqlPVc3/O1rStdKEG/MqsXNKjFt2e1a9EZpXsqc
	Gf84gPmyf4Qtt2aQlypPr81DT6GpzD8REGT7jgGSAYzWdRmAIZVoQxV9N2Bk+Y/o
	RuRbdYOH0zzu5woOQxEioE+e2nzM0OMEWU1agUFANwfqZcPccM7Gy4kkZq7BcKCQ
	ZpdkiMD8YgmZaQwaVO/KFbO1dzcPdlZsDVvlVUK9+fUQWFbDu8kg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4arcvet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 19:13:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OHeGSF015801;
	Tue, 24 Feb 2026 19:13:44 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011058.outbound.protection.outlook.com [40.107.208.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35abybh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 19:13:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FY/SHA+68I2ukRGZjv2hTlmQ/Utm4K6/CyCq1IfdxU3QU2fYcS35OT2BRTDFb6OHlu4Hmk/zeRkSLejaJc64Ye07p02NsPv90HPwtpVXJKaLm3m/gQPs5dj2NYn0BoNoj39IdBcZqrz0ra+SIqs8rhAo8j36XVfzVzM+xfHcOBmmrqOwo9jAvz0lMvIwNI4dUmcexlM6KRbX9JfhgoiNx94nfArLykNB8VTJ+YAt9TbndxZExwLwkgna1wR2w9PtDlNxykEZKwkPhJHkcarsUqUrsQNjIu9APvg26cpSUxOBwDww1Tj+uiwoUFfBtBMa9lBrETvp42UQxHunwAXKGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wk1eS6nMTUNM2k7f0JBoHYwozoJHv6jfPnyRNr2b8rA=;
 b=EgyvNXYipKmi/9QLEIxjMNfxmnmg/1vSd7a0P2WA8+LFsktej9r+2ORJ4uk3bYkKrdteeIrdzl1OE4x3UI1u6q47SAXJN0oHzTd1oFVib+9rknaSrMWPP16GKSfc3WfSRCacslhB+e5x93n9fZKSS3j+FH5S2mF9vAxYdAVKhoeRm55lqf14S+cfjxRf9d7t3+CQC8IXGso/LNLRLAGef2rwEFFl2mk+1yTIt1UYbedj+v/dxSYGUKl/RsOryb4YhQHluRpNLGUsG4LvkWKkkJX1MrZ15K132Jh+RUmpWjHdk63t02RtX9+YzSPq+GZFUd+oSK0cMwrNE5G+dMt+zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wk1eS6nMTUNM2k7f0JBoHYwozoJHv6jfPnyRNr2b8rA=;
 b=mmUDvbzpsDSp4vH5BauU4jkPYAeEWtp+A6Pv0frysO7bzir7QFZAIqJFwFulOuuiZbRon0NsRF4oOnWI2Y9XTarBFKhC5qlzWOMYOZFu+9++zRLvXvgcXy+6uU2M1B5aF+CuhzDOq1Z98VLATL4jRvE6dwrhsRZgegsCqJPCJDc=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 DS0PR10MB8079.namprd10.prod.outlook.com (2603:10b6:8:1f5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Tue, 24 Feb 2026 19:13:41 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 19:13:41 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
        gcboffa@cisco.com, aeasi@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmeneghi@redhat.com, revers@redhat.com, dan.carpenter@linaro.org,
        Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH 1/5] scsi: fnic: Use mempool for receive frames
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260217223943.7938-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Tue, 17 Feb 2026 14:39:39 -0800")
Organization: Oracle Corporation
Message-ID: <yq1a4wy7y5k.fsf@ca-mkp.ca.oracle.com>
References: <20260217223943.7938-1-kartilak@cisco.com>
Date: Tue, 24 Feb 2026 14:13:39 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0058.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::35) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|DS0PR10MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 251f1bb5-3f6c-4bcc-4051-08de73d8d245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9AhkdisKv+kConE+fVbbbIHpG5KzTkrJzUAlI2fK3AUOMpPBIlQd1ZwZkAgZ?=
 =?us-ascii?Q?+5msTP7NIsq0N6TLm3JJdpHgPjzs3wz95A4AYyoXKGwFf1vtvIW63yCXls5V?=
 =?us-ascii?Q?EH7M/Y+HIPMPT74+7x8fstZh+Kl9qGxG2EzeV8IK226V8f2iSau1N7sbIzOV?=
 =?us-ascii?Q?SdDKei225QQYWiVvwQxniq+lk+k5KNi4QhpFmD+WSA2LId3yAJ1uqhEIjzar?=
 =?us-ascii?Q?NKaf78aMOoDA38lpKWWxRP8IitC4kTV9ZTw6b7/276kexhbOfioQPsU+SJx7?=
 =?us-ascii?Q?E1QEKeSXenYuol3iFU/dRPXZH+XZeam/I80n2nlvq7W+Yfgw+Sy9j0md5EcW?=
 =?us-ascii?Q?VAYf6V7UpwQdL7L4i6EP0GVif/0jhFSBvKZliJjI4dOVXHdxSeBY1aSgxWXE?=
 =?us-ascii?Q?Ka2EoEB4jgQFx8Jk0dMGAx26j5yd7Kbzvobcohc5LdiT9nN1VlKDYbGXnuEF?=
 =?us-ascii?Q?vK28vd44z1yea2LH82u6Ykzlaexi252z6wHZQ5gBDceFkw5HRucEGcW+cjNd?=
 =?us-ascii?Q?ZEcSll0E+bM3XHBzfXdfKpw//Pibv3R71UKju1A1+0kUCz7bZ0UG+wBrr33O?=
 =?us-ascii?Q?36AsdFAhH1uWuVdZl8+nX4lViFxbIzUSm9hGhY2ATt3V7moan1rQDEIBW8J3?=
 =?us-ascii?Q?AnlaANRLcVaIJHxp/HZnyvAW1UNR6D9vm404eNa68n+szjT7uTwvTv8s7Wt0?=
 =?us-ascii?Q?ZMESgbFIlitj/vc0/ZKZKkQenmsdF6TIf6RAn4Fm8lC/K1QoLvQcL8Wk8kRY?=
 =?us-ascii?Q?AJ1wdlmjuv9grTSqFgtAaSFn4G04KVgQ75MIZENYQycxHzfrDPodj5uRVNeD?=
 =?us-ascii?Q?OBEAmdyX8VToY5A827hCKtbE56oYjNwboa5uX6QWf7Ph7HBvm500/zDy68SA?=
 =?us-ascii?Q?A8QCUJnS85N988immFpl3GkZZQhai5O8jAg2AytoTgQirud/4x5G7394QxEa?=
 =?us-ascii?Q?bdXZMhHweYt9e3oejIggQ9QVGwdUjKhjpVJ+9tdDw4KcamGVn77ioaT8RqAs?=
 =?us-ascii?Q?lAQPNRrS3hWS35UMsjLz9a/64q5mPH4WZRT2fti69A02VCYPHk+h2sP8eJp7?=
 =?us-ascii?Q?7UZ63/SFbakn/MQ3J6PS5qV5IuazrEUutkLgLUuaITJt+bbmbJza4IC9majg?=
 =?us-ascii?Q?gSnj6obd47YdBSWAbwiCDGJlMOWklsHNXUfzHvB8nxh6Ay5cDh0mDb1cgXUd?=
 =?us-ascii?Q?u6vcxjuX2z05k5B8V0mxpwf5rD8FIMiuiFdkzdzGoiSQ6rywC+6dNClZgMZV?=
 =?us-ascii?Q?HJZMsaa4cQ0zuNVIWRwV5g9bKzprM7Mj9BUd8pNOEkymwugHOn6gW2agDshV?=
 =?us-ascii?Q?aHiipTaTzoqIMiT8Y36i9KMmnyxtbCRlQmxljipsIOzC/rKQ5Jjm4GVsI3kJ?=
 =?us-ascii?Q?CS4kdTslw/h8E9GLTaX2dliujiPBhLqKo70AqfVtkJpQHs8YD1O7ZXDUf6Qz?=
 =?us-ascii?Q?bPKv1AaXcL9Jh2GPhT9eYL5jIBIxqv67EyAO+fL2cOoBmt5gGMkQzAuxkgaN?=
 =?us-ascii?Q?gkUMcKkiEr2w9SrNTJkVWLsoHrL+i+kFOp6dZB8FzsawFnuKOqL7A+gmMZYK?=
 =?us-ascii?Q?R5OFhSkiaR+cvULq52s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1pxMU31AdFTI81vXIW3oJohKEISngUuwJSQTN+P8w4W56+2+XyPP0FhjQNm5?=
 =?us-ascii?Q?WYtcZGJkF7JtSCsr2o9uZaXIvCjE0x+Q3ZuNpufD3agc55tAUHIzXmR5v15d?=
 =?us-ascii?Q?XmswiAIlpwidIiR5meRq5lWH6wbccEc9kcPI4SrG0gwRFtn2f103myxkakUt?=
 =?us-ascii?Q?bPdSh8CxSiMPJqP/BZJaRflITln11AtfYCLSGm1qzv34zYL7RzmJLiPHC1vP?=
 =?us-ascii?Q?41ovkO3WFiCCvP7Dh8PXJowLbq++noJc5f37M5MX1Ue8ZVBUYkBrqPw1ICs4?=
 =?us-ascii?Q?DA6PCS3oe1CLMZcdTsinlOQHCw87kydmlkA3F6A/dkrxw51wlx90U0U+V7/T?=
 =?us-ascii?Q?ZAC9rOjVSjazWtkUAKr6pUFCU3fGtuuRu9dldhdy/tw+3YWwn+CSHnptf321?=
 =?us-ascii?Q?UArMZSYqUJXT5mD0MuSlzkU18yH4l3A6Tv+3oWDhMXAWm2+ZhxDd/kcwShxW?=
 =?us-ascii?Q?xf5JUhtfjnYKTlUWaBFD1WNMsCZINSKhklA2hJG4T5joSVcftTMXiQQDxJJ4?=
 =?us-ascii?Q?nZJKiw2G96XLg6qD3EDk+dvLbT0eAqPHj3xN199/A8vGqzpyicvDBeWEmDQ+?=
 =?us-ascii?Q?ek/33/bxF7+tmRI1UH0c52gw4MNja/P/gf32ZaWYTfzlDGyXhDzJdfxlT8GM?=
 =?us-ascii?Q?TyHW8L0eg79XGtuMjTEKzXrcPD3ux1nQVhBIFBN9kXQybj3J1iNL7j+AYH0U?=
 =?us-ascii?Q?BIwYzOD0jFOdB4D4gKVstaVfCRrKyZdVQK5ia5jcihefZk9Pg2r8EqYZnULP?=
 =?us-ascii?Q?aRrjS41UoZj2KTezKJe1T5/4y3Tx7blPW9zR1tKD2irKNOMVaHVvl7S84XTN?=
 =?us-ascii?Q?lT6YIDu8dQglEnyvrmaxgPFVQtbqY+08ilq0GuFhtbSL99bkX5EyqMCyQAV7?=
 =?us-ascii?Q?IDdIzH8DAI50Nxwb5QhyqVwtDjrgFBAPBev50Cl3HepWes8XIjWz/4EnXtUA?=
 =?us-ascii?Q?ORnavTVj93Y6pz8/SedJIoGuDdtzM5iHsmmKc8+jFJv8aiq7KFig/CSx5d85?=
 =?us-ascii?Q?ZW/u6aPTVqOOvXPK1sR5Iezi/9RYV+YJO6KUFzl7S/LcMaLhLR9lAZjKkuPL?=
 =?us-ascii?Q?NOhqtqqbLalz4JXsyvZr21GJ3edz2jjfVlcS70n8yjqonb/7jWLaeU5v1MDC?=
 =?us-ascii?Q?qrL8xAbq0uJltbp49yMQuKz/GgIEjg4izfM/ePNl1rfO0wrYrb8r+TLZ57aQ?=
 =?us-ascii?Q?Fvy8G8YeJKomx5yoxL4FbV/v+jSRBRWrW0fJ7QTABOzv+mwrqtpqQwLjuzaj?=
 =?us-ascii?Q?/HXgAdLn/qre8NtXh01Z8HyUVaiGKgcEJOo31vSnrIvp/nr8gpGueI6L2xNh?=
 =?us-ascii?Q?VUbpR1761p3XGFzOaf71yaKdycoh/3SSG0guvOa+0Q9PmGTNzXDxtpE4FSae?=
 =?us-ascii?Q?QsqMh5hGPALhxixkPkfq4DLOHMd5C2AawhHWSv6A2TiaPPuWHjJ11di6YVCy?=
 =?us-ascii?Q?+DfH314lVZOuFxXSvPmHo9V1lR2x61CYBlH0C0NuIkqMl7F9g48fnA+HxXpQ?=
 =?us-ascii?Q?ERB0htglUPvX0c++/Dj/tmwIcXxQDKIAHwwH2MDVJ1ZW/e/PNiGEs+4UFLzs?=
 =?us-ascii?Q?Hl1NEC+mEPjTnH0FYqmftg9ovowN9k5yd7sXVu7kO3M4ZbY67cQ7IrGQdtyL?=
 =?us-ascii?Q?/Aq98SbbCpn5x7cU+Zc+Bj89ZZ3C4i4o8F4GqUnUInWNkav/FGzIYUOMHj2A?=
 =?us-ascii?Q?jirtr/bnb0A3pifEkOVvzODO6lEmzIQOU2aZ2WHZMRBWcKzucGzOuQg/7gTR?=
 =?us-ascii?Q?whYBQuN7f0JsBL5zbO/ctk71B4g3I2Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KQt4nRHBA08o1xlSXFA+QdLURbL8p/1nTQzAwHi0a+/yyAxMCBqCl4eadap+f23HrHwLE8SzqWx3o1QLetlYiPWIuTY3ttQRO8frwgRFBWxMtpkdgJv4Tpw4P/c605AlRyDC7BYWZEtRWngFKbM4LGb5R4qbt9eVM9L+hUJz0fvE/SKccuv8yiOYsEbY2wZmpp4I2VkpXmkKkdw64t2VPoBVqhGfApWIFnrG8gR7hf6HZO3uQJCCY0Ze+mkG+EkPtVUnMnJxvr9naafMdNHFOylNZ+BkqNCSTzDqnq0ReN0a98RdNQLDutVJStIJ20GLgTZmI7Qv0szDM8n2lwtqOoyMuzpZBuGgon8c0dbE6AGszJJP5t0Pbq4hgZ6H0UH8X/8U+gkvMn2uZWYTG1NGRr303NcpO5CGkqVBlRVBDWpf4FotxOfxHCrSudrnRk1GPzUzE1SX6AnitLvWm0jBbiL7Z155idS/UV+A5a5jxzmpCxUTSN5sxsuqr2YvIfPWiBEL2tkF2pJgD2J+sHSnQhnzoPT6Qv+2ylbEqopeRQrWNnPjhUsl9Wno5QgMUJKYRpZGnscTOOO+DeUdoLuJbJNMY1Y3gSSaTQu1k+cwmrg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 251f1bb5-3f6c-4bcc-4051-08de73d8d245
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 19:13:41.2489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9m9YjGTQBMLExfeRgk9oRp2Hr7aJV4oxs4YIzBETv0e0yGrMoRHFirC3HSnY3C6mT2yHH0DUqiQooFCJmFuMvY1YM91fyCWUKHvq3QkwAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8079
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=752 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240164
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699df869 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=JBNebbC9HC7U5k7cQ9AA:9
X-Proofpoint-ORIG-GUID: sUQzr3ZbaEEI8_J-_8RYQPl-UlEYGxQ7
X-Proofpoint-GUID: sUQzr3ZbaEEI8_J-_8RYQPl-UlEYGxQ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE2NSBTYWx0ZWRfX/v46BQewU+Ho
 ZxSUPzoM5rfZLInYBgXlUK+Ntqkl8FCErooiT5khfHnTQbVAw5go0jV5GhZ0PBMGSdzdIHQ/zqg
 6TMy5H/r2jTuUUZE/mp7P7jcE3bpofrnPDNnntvtA8NMnLZ4Kar0gecdWa80LblqoKSxrkk6cP/
 sy8w4d+kiFti+WqduQ/9z4vDGoUPVLdS8cFzg0kcbZEY5OyN84mjGu2VnN8ecxLVS7Kw3xVXCtr
 ajBnpIS8Pirer2B1Pp9SiHKMA5WGXwrixglQEwHDfWdFtf/YBdlwNxidrs98fnUScLPSN6yqo4k
 xGZkypwnpQw/yRiTJgkZumDoudfpECRVlw+B47wkXfQRn6DHNFV5sikpnWSJ5TlRLUCbLnhESAV
 9DIX4Qd7IHwLmFJEb7ifTQ+WvrOvYt4WYzzRpinkU/e0+uCN2y2hQCGb57qBZfGUnr0WJ+Z6Sfu
 TP66HsYa6j0Tb3NlzsA==


Karan,

> The receive frames are constantly replenished so we should rather
> use a mempool here.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
