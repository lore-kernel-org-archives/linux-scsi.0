Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785373BD229;
	Tue, 17 Mar 2026 12:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749267; cv=fail; b=c5YdmF6/vlvby9797h14sO3k4SNGQC+9dWAtFTv8eNpcu/0BzTOMED4sx6H3ov0z2BRAA4HlYAP7XEpE2xKkeR/S4MWBdLKXPzC/9/rkWO4Y3UAlVj26YT9z5S7tHKi2oZzOPrkxRPDTNDQWgGVDB08QMDjQ+dA5FS6E3m44wJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749267; c=relaxed/simple;
	bh=g7OuxHwp3f9eqddMF1ToK5Ob84oNK0lEMgsOKWIB+Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=knMO0BhU7aTSpPD0KhVfiWlSdGeJ5g6TMFr1yvkMVXbL2kUY833zxkJ2BUG8I1xQo8GidNT+CYOsbrk02chs0jIu3cs1IV3NI3NUe9Kpgd55SmBuSgLZup7/neHS6nwQTnxqEdLHnb4mda6rNrciKXZ0d21XU7tI1fgmITXFPDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sg+G+/sd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H966RtnJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sg+G+/sd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H966RtnJ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GMfRnW2629971;
	Tue, 17 Mar 2026 12:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MIgl19WTgVDQ7PYxMbO/J0ZQFKK2o2MQw9P/VSrbZXo=; b=
	sg+G+/sd806NaXuUs7k6LlIhF+nzgJsE44fE5uggmFit/dIeFD20Seu6ngNC24eN
	CBSXeqghg9MxBZgvReEjeMs0FPMWAYcgS0X5lSm8N/E+nY3YoPisuq1oMokKl0Fe
	QbkoFrWNyeXBhuasKlptTnzPHxnJxQDflgSXMJZNSBaxRvFjVg+6MKzd4FlJB1rc
	XHzSICINIcNS6WZKyQuKPVp3w1+fC8VlbRDBHbv/2agJLOfoCZix3PIM/evNOBAj
	KJfpGRC6oA9rZ08j7isV++xWHTwHJDJaWAZ10+UReeO/Uod+VpZQaxOzX2xLXSNX
	+2pW7rwV7Mlr3HDh2D9nFQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqbuy69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62H9jvh5017844;
	Tue, 17 Mar 2026 12:07:36 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013025.outbound.protection.outlook.com [40.93.201.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4mh26u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w83e3FXTm+XUo69KAIFZzRvIk5tlUQWNqZ7TI9DueYZF4Jpw4iTBbGMdnNO1vzzHt3eR07diMpPhwmdO+6jjN+S2EXFWDw5o5Ei0RO/F5fs7zIXcKeDQzaL8cgR35FYC4sbBWnT43xdgvPdWpwuLf1ox5dkbfW9+Tx5+djGRsGt3f4y7PFq3sgkLwHT/kRF1AqgNzVw1LPp0wfUmfAT25MNKs66YTb2boo4nfGHfhDEdDemr38xsxL9qTOgFgjLqVJgmNziGcrJj8i1lhzq9CR7Y4YefceZK3iSYypt0436Mk3ebl9oKQt8erlYGxnuOZ3aAwYZ/6bKWkb7y+76Kag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIgl19WTgVDQ7PYxMbO/J0ZQFKK2o2MQw9P/VSrbZXo=;
 b=aANJWBGYkFRODheRcBO953vW4zN+PpLghYwz+YY9025rhSeViVM8TBl+G6DKnV4RF2Cbm6C7/WqpdFwt1ORAQ0FY6OWkE26s9rcameY+fUAi0yEZoRiQ3lTkafOOEaNytWl0+m274NzqujJ4lqdgfz7Js++gHUxW4ns77dsg6DrvDvBTh3s2QkQyto8AMAdvNArX7y23CigLaOoOf7H8835ZG4keoWvzqJFrcc+462EQzcrl3qJ7DmiCq5rMrmui36JWyCnhv/FU9aSvAuvgBMyZkSCEupQICP8LZkyjB/A+kRJ7H992w+pJqoUNbeQFlqcVnc34sXeT+0SxN6TMwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIgl19WTgVDQ7PYxMbO/J0ZQFKK2o2MQw9P/VSrbZXo=;
 b=H966RtnJeaOJK5BljQoLHo1EqNTFxFuSoG/SGmKMq/s68sELXJU7qCM1NJGNMMHnQIUhp3MNmAr5DP0r9FDtGvKDSWhYPpyuNb4pCEKh5OOMUlkxVtotYQX3yx2ib+nCO1fUYLrNCK1WJIB1rmXAWO0FD+P2W9pQtdfzLw+SrUk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB5976.namprd10.prod.outlook.com
 (2603:10b6:8:9c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 12:07:32 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 08/13] scsi: alua: Add scsi_alua_check_tpgs()
Date: Tue, 17 Mar 2026 12:06:58 +0000
Message-ID: <20260317120703.3702387-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c83d045-9360-43c5-0dac-08de841dc494
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	xXuuFS5t52AlK/jxT9707wqhbIrovp08EHq9CV8vPdLNN0HRQ71X8E0JbGA07yqwX/e/1K02e3Pd0yqOyeonWlNxLNv5MHWYgg8ZVXQNIyydJPoGNVK0tnJB5l1cXqqdIy5Zl3ul9MtMZK9igoUyKl3kZNcJdrjCXDXigLZOyG5mmtH3SLUJG3IpNmsLXem3kyzWwsP8tydAhsR/ZiIwUkL063VWgcysN3bugMoVCCO4iQDuZYg6QSatrrErlTjLuO10lQ6rJa7aYwv1bB8CaAsYdSa+fFMEv73XoNM0GnWyraFAj0i81kjeNEEuYKyhFQxCIezAYYDlWLZzQBMU54KwS89B0vCsthy+Zi2o7qB/jx5ZBJv/2yJE6+PrPBAhCu9gHxrUcHkwSMJWeN4z9thhFPLGR+3PRp7JM4zVRp2HewyixfjJqHrI1ciDGEnbtLhvWGou2UxHizCkHgilDnBaO/K4XruKFKM2W0DPIFPHbFkYf3ECQQzjOgDVsAg6+raxawij4rKO7pIWTT1Gxy9On7nHY9Nf4VhPV9znZVML9IEYlD+gAm1rk0/p++yaDI3YLLV/ClzNuKvsSS4IGobJ8x3e/MQkk2eP6PydsD4AhZMgwzNkzkLdPQhnW2d8kz7SjMbmQ+vZTXRzzlC2WnPhFzmoCfLtAE0SnDbipmBQx8ynBiidJjWGj0SKD3q/LLx4QF1R7SepRsvn7fXqwSMo7QAMbZ45saGnGIojhHU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4hkFdV/j44Zm9suDEo7nBk9zaS8M4muwGwibTOlPxmXOIANtg37oMYxtfhPp?=
 =?us-ascii?Q?0BSLszeelXgqA3uEGlE9WvaCMDmNhfh3bUosVB74AjBTEBJMOu5Qkb4Whh2L?=
 =?us-ascii?Q?D5xDmIAfhPEKX2GV4FDWvldhL5atEtDjtCyIqyVAhrXhjxokIy2Dsr+3GO+t?=
 =?us-ascii?Q?3GutTxPoUastuurL9OoqyX3o8qdEcpXcJapBKaYarJWXgktHi7R0KMtQnd8f?=
 =?us-ascii?Q?BqtRimiB+a7CEvDtux+YPKIFWDu9AvX0wuqJ3ByQ3kRKaIhvsuCnW8Gg1ntZ?=
 =?us-ascii?Q?uOITy/qCXfGe0zFYDc0AqjMVRZJuZ5vEBuQtpqnDK0GKZPSVjjJ8PSZtSuCW?=
 =?us-ascii?Q?gJbdCAvcZha7CbdLlQBJUGg9POaCFHLKk/0c4QH/RB75KLwbHes7ToXOOmcz?=
 =?us-ascii?Q?vWuxWNsoN0zQM+gWzkCcJmmy9GqSD4VBPTlscaJEfejJ0uoBJraDjyLv8Xah?=
 =?us-ascii?Q?UyDzWgLGigT5qOxr8j17WZWuOYuhwLvAF+6LvlR/WfbUfI5Jh8aTpMzOqObJ?=
 =?us-ascii?Q?fvbSMAA6AWOtchBJI63z1T/a10Fdaktl3XEMWmff6Mz6c4+WUsyM2ZzTwAdN?=
 =?us-ascii?Q?uoebdPM9KBjyupUzXfHrta8WcvEytr6G6sIFyC06BlfFfRQQnkjYmiwraT7w?=
 =?us-ascii?Q?PpnqFm+figXuFQ7xxOnXYRPNhtZSEUObc1UEwTaBDfyy2l6Q7UjPe6mAIhVo?=
 =?us-ascii?Q?9WYJB8t2EkrjC643O72Qe4cXyVLPBnRf9mIgS3BJv3RuQIu/94tFM/FkzMRQ?=
 =?us-ascii?Q?Q1lSem+DqraKBZ5+6QRKmnqh0KLv4GNsoSCdvp6PAZ5RTehQxaU6y5Kh2Wa9?=
 =?us-ascii?Q?5F+RLwn55qqVSr+aEc/AJ6rrIwUg0/JX8VDECuFNwpGlGspG04jVhd5mzwxh?=
 =?us-ascii?Q?L5uU8xvgPBSPa5hTXveWZjeXKoxggEmDRjgxbsYfcpsvEnvpAZsIBJNNP4u6?=
 =?us-ascii?Q?Md2uEZoTGs2SfbF7dXif1sTMcjRTSD9I6sdG5YgpL5wvvYNhTUjPRPzvGgo6?=
 =?us-ascii?Q?uHTMpDtAhZHRMYHtfF2DB4/dCCXnzO1OSx6Cf128srLVV1Ivl8ISYLI5OiMQ?=
 =?us-ascii?Q?W/ZXO9kofUrKPwYF0bgZXgUsAFsOyhTXqSAfOBqB7TUx8CW5Kr5J5gsHk9iB?=
 =?us-ascii?Q?5s1RUF0WSSMAe3L0onOtFxr/tpPyN/qeYZrhmpV9+5vMIlR8CeEXOALWgV8H?=
 =?us-ascii?Q?mC7V7D/H9DvzC2JhlPtZhVC8Oj5n9xKI5jQ9vKpo/LrURoc74vywi7A1WIPp?=
 =?us-ascii?Q?2aczzkaLAyU5eclPjh7/uw3hiXx/zYIT8/m+GxN/qeLyQoziT882JhBwyjpT?=
 =?us-ascii?Q?HFXzDGYV/nq9l+HWdIaRgTgDYFf6HCNBbG0EZqhjP8ond3jcSAEa1hU2B8p5?=
 =?us-ascii?Q?dpQEV15OXt3/zuHSAoomtAuRLAwp31GQ8Wr2onw2OC6OR3N1rEb9VQtwqQW5?=
 =?us-ascii?Q?QWVttSIP2oXeWeRgzKRyqk6tZD2GYU7HlSuo+mMrUg4kxlez6junSjHfJ5kY?=
 =?us-ascii?Q?FWAM33AeBIDidmnIR4l0U1kcXbIrbwt0W8OBm1viMsJe3rzoM2lrMJNShMHP?=
 =?us-ascii?Q?JwnwBnJzuXdBBakXR17My40g7iPeIg+oxzr+ni4ijoZ67xuTEh5EablRMkn+?=
 =?us-ascii?Q?S1EW3Nj9JlH2a1QrIEywqEIodsuVJsHN5Cd2IWREbvQIAuudXiZTif2gv36J?=
 =?us-ascii?Q?xqB0NdmnXUXFOOyyr42tveG1a6T5V9EQaxl/bqNvURJAXfh2ckWwPeP2jAPx?=
 =?us-ascii?Q?kA3Gvs9kHIAwRoqipmUnByipupX3UyU=3D?=
X-Exchange-RoutingPolicyChecked:
	CLv0JlJyC6Udh137KkkBYD0rCdMCsuAN8WKzxVqvm6w3iYMwTiX5k8VRiUOVP+l98oTMfVI+k+NToq8Oe0SggclOliDnGdZcfDvBxLozV+apm9baMsSGSJyUxfOdbv2vY4dg3Bc3kksWCnGl11b+1wa/A3INQWRnajohLUlvBT/P09KaMi3Km2TRn/mQ5iNgcY/y7b7ZiZvvCb9UvNNbccImjfsVgF5rJTCVfAdzoex9HKQW1AuOXR/9FZ4dthE5qmmYMqdO3uJ7Xpf69jui2ewqyK/74ayKzcqZ/4YL7lAB+/PPQqvjXhlh3kaLqcEem6tZ9zZWX0UiXobf3h60IQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ycuoyWvx3I24yCwr5XRfjs16kb1xK0tTWZ1ZUkZrU4JZXUKoODt4f+PDZ+zdOFJGDeU6u8qRpMgGhsgERpTyHXD3d8cG6sR+BjBWDBwY8OfKlmidzf6YnLDW+MMX9eeOa7OUoHodnoXRDPibHj5vtLI+9dIE1i+/b8OCaKmWkJY8fCYr8J9puugOXj4Z6LQbfTbFq2+TCD4OkGQrezfK1a0J1l4du1ws8YCPh91JJ7r1oSF0WrtVaJnqg2JwOh0ZlJZSnIoGUBFK66WyJGtFk14wEHKsc8VKyvmWtwP6g7PyXzLYQXtHdaMk2yY3yp700DhXgAFpKjq4LPeXb1sV9W0XJt4ojXq1P5M4s0rInGfsqif4lP6ppZGlj0mXV22PN2dM25nyUMOuO+L1Tp+vdRtvm/fMCmljnW6lYMF2yC3meL0ehvutEz2humne5vSJ6IL8gyGaQYiphkPor4nOBWV3bXXOZXEmdqbycLfetHG3im5FDy6UhYorTbRzCpLVDsE+V088YUyW2yEBhdyL5xrQ5a9CzjCxvOygsqLpn8n5hjh6pHw03Ynl5pyWwC7jm/YZklZYZgxus4znHo1vsYdLDr0mx9S9XKXnlYtecfA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c83d045-9360-43c5-0dac-08de841dc494
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:32.1843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4Ie+qNDNDLA7/vBJkB4zVkEhG2hSembEiarde5KlE9us5FOyAJhWdZHYi0ZSXZF7+lNfXoqcdcFDOGaOf9fDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX9R90Tlyb6XAS
 W+Qp0RGjJvcNXGFs1RsI6POrKL/8CgZ7AD2uJaT2f/8icBFRuDJsNOTVnPUr/4ty2uzSk6g+Vdl
 mrCdOfR6yT6j3oTOZZRV6vNReVnx9Tj4iIhbaU+JRqcI2UhMzYDPtsvtypr+91KqaJk1xqCeLPP
 eqfgUejapMzwhVQQY5g/Cb8ukAn1gu7i2C9RYmL5msWc/7KDW73WLvAaxGJbsyGW1f820D+7p1Z
 fHfDL7rIZWrXIPw6FSdr5tq+ssCnqDfTjdGv/aYhNKtzG5ORZRq15+z2TLZ7qW0yGNpK3fp5YdQ
 Bbr3/Fy7kReO8L58Ll5xGnO7wVHsokvGIGrGN6voNinXZq8pi1TyrgQo9H3eRwWJXrSM32NW2aY
 NaVlZmtsWucf5Lyoq1cLYGnI4mR/mP9XMs4v0/+NxT1iCJewfZIDiCmNNtAGoikbCU0rP32909v
 tUDDrMOlR5tCRU+PcmIEt0yaKtEKq01C1Dz11t8g=
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69b94409 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=hChlPkc6gP06MHZJlesA:9 cc=ntf
 awl=host:12273
X-Proofpoint-GUID: 19LNzdIY8yq1Uj1R2LIYojUgufFjVOFX
X-Proofpoint-ORIG-GUID: 19LNzdIY8yq1Uj1R2LIYojUgufFjVOFX

Add a core version of alua_check_tpgs() from scsi_sh_alua.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 53 ++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_alua.h |  6 +++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index 4e20a537a4ad6..9c317e60d031e 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -128,6 +128,59 @@ static int submit_stpg(struct scsi_device *sdev,
 				ALUA_FAILOVER_RETRIES, &exec_args);
 }
 
+/*
+ * scsi_alua_check_tpgs - Evaluate TPGS setting
+ * @sdev: device to be checked
+ *
+ * Examine the TPGS setting of the sdev to find out if ALUA
+ * is supported.
+ */
+int scsi_alua_check_tpgs(struct scsi_device *sdev)
+{
+	int tpgs = TPGS_MODE_NONE;
+
+	/*
+	 * ALUA support for non-disk devices is fraught with
+	 * difficulties, so disable it for now.
+	 */
+	if (sdev->type != TYPE_DISK) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: disable for non-disk devices\n",
+			    DRV_NAME);
+		return tpgs;
+	}
+
+	tpgs = scsi_device_tpgs(sdev);
+	switch (tpgs) {
+	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: supports implicit and explicit TPGS\n",
+			    DRV_NAME);
+		break;
+	case TPGS_MODE_EXPLICIT:
+		sdev_printk(KERN_INFO, sdev, "%s: supports explicit TPGS\n",
+			    DRV_NAME);
+		break;
+	case TPGS_MODE_IMPLICIT:
+		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
+			    DRV_NAME);
+		break;
+	case TPGS_MODE_NONE:
+		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
+			    DRV_NAME);
+		break;
+	default:
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: unsupported TPGS setting %d\n",
+			    DRV_NAME, tpgs);
+		tpgs = TPGS_MODE_NONE;
+		break;
+	}
+
+	return tpgs;
+}
+EXPORT_SYMBOL_GPL(scsi_alua_check_tpgs);
+
 static char print_alua_state(unsigned char state)
 {
 	switch (state) {
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
index 6e4f262bbfbc0..2e664f20d9681 100644
--- a/include/scsi/scsi_alua.h
+++ b/include/scsi/scsi_alua.h
@@ -30,6 +30,8 @@ struct alua_data {
 int scsi_alua_sdev_init(struct scsi_device *sdev);
 void scsi_alua_sdev_exit(struct scsi_device *sdev);
 
+int scsi_alua_check_tpgs(struct scsi_device *sdev);
+
 int scsi_alua_rtpg_run(struct scsi_device *sdev);
 int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
 
@@ -37,6 +39,10 @@ int scsi_alua_init(void);
 void scsi_exit_alua(void);
 #else //CONFIG_SCSI_ALUA
 
+static inline int scsi_alua_check_tpgs(struct scsi_device *sdev)
+{
+	return 0;
+}
 static inline int scsi_alua_rtpg_run(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.5

