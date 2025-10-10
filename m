Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A642F3C1F;
	Fri, 10 Oct 2025 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105729; cv=fail; b=Zc1uKwDJ6adROzZxqZ2ZBYZorJnx9+e6POY5j3l2zKGbO8wsWuSYtE3G8sydSZTqOZrQnENGQUI62Y4svDDIPaWtsqI4tNktSDLLholhR5QjxRWGWQAh8+bwDMEysd9HaQ+oBn4I9RhTYec7Ytz795e6AGsSkH0skQ5gz4pjo10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105729; c=relaxed/simple;
	bh=eAAbsKdHvJWyL9UWqYnoFCxp5kck6wTMVlVpVg3Z+8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JR+y38f6EZU1rDfspfrxGWk7ZA+vDD/vVmSa1Ojfx4jiOjNo3b6bRYo9dTIeBBp1N/GAbrAUPO60YeghGFyZVrK4Pfe2Mvedy/zNUdrxsrAfZT63yUFS/eZXBMWMpPHWnm7P2aySyJCgHwV/d0AxtkO8n7FwQd/2WrwAv+/Nsp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SQmNJUS3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QF1c1ui2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SQmNJUS3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QF1c1ui2"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8tb4e011435;
	Fri, 10 Oct 2025 14:15:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=W9yocODtiQPUh1b+nQadGIczPJgeL+57tnNNQcZ42c0=; b=
	SQmNJUS3gylEN9i0bC4T/58MGTV7BaIEU7djnqJqHYQfsACWcS5gGBSCv+ScJveS
	inf+quMHFI1GuiBHLIYEbs//P5fWDUGkS0bCvQTLevMVk9jMoRztP9DgOjC/kgbu
	vc1ODQuwdsxgFu0VGH4gY8ucUV1gz1WWTzq3U5/WiV8E+0P5hPwUCqqa8WRfjJ1i
	MWPP1Ietd29PolSXemtVnGxxercn0hB7wppiTLLyCih2i11NnbA5WKZUilPdFZVI
	UMd8wGADshUMKPiEq82QU8OkXTn1l9SFi+gPUv/JyTlyi+9U4oV198bBxBqlyrUy
	ulMzuZw6Cl4vRqsE7D2BXw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv69urpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ADUCOu036569;
	Fri, 10 Oct 2025 14:15:25 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010011.outbound.protection.outlook.com [52.101.61.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49nv691fxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BS2WdQySD1ipseobVDtUY5tQKJBGStI52Y3A7W1gY350uooaXrpumoP3wRMbeQRr4sDdW7VaewaTCs1dWHzY7s8KAnHZe9eKhgEtvCQ+1JOiXfH7S3HUhZyZRCnU/9zIdHyT5fMsEGZ62BIWH4a0W0n1+4IuZaQvYAy7S+jt+S6+h9EqVhamyA0/qaVMNrczccXVH/9YzB3IavIWqvGWxqDvU+QGRwnRKGrAE8GmhF8LJpLipGCqnTlLQ5daFA/uls5Qzx8vx2dSbSF2cQ7+R62YwKRBGQTh0ch5guMtTQmvEaXJKuZDqpwvr8HLdLhHQxf9MB10Il6FzLaAsYbHUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9yocODtiQPUh1b+nQadGIczPJgeL+57tnNNQcZ42c0=;
 b=IsG4natrgmSjNhQatcGV7B43OdDPe4IQM56u48Kw30L6VeAy+QXsRuH4CIVapHeDZbHugEqTaJR69JLlFmYFSE53Ex8kivRox3w2ZyAYH/7m0jDwhPNTQbzn6r79f29kPGi9z0GrN+YfALIEhlxohFoS0+NjdcI4JL0ztX51pk2jP0y+Udfp+g/wrLMcXvLFmOvE508S55+a4yoyblPrcRKNLlgSnJP6PWZR/qrmQolKGu5zL5H+TwKZgKee/1E5ZF2uUm2JlReB3Mo3Ylq2lzzmb0lFHJwCM0soj2lEBeoOy09ZqEqXCScXedC6RDNFeoBYhd1WjD267b31BjPIig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9yocODtiQPUh1b+nQadGIczPJgeL+57tnNNQcZ42c0=;
 b=QF1c1ui2iBZ0LjNqaNF6v091xeK2IRlawp50EjO+LKX7ysJpA1r2BzFX1vQAxeAikikenxADeYVpNEBw1SUFBZuYbXQPvfH1wcsWkw5Bx+Dtf+Uh6otreVkA5ih2WxIMO6koN4seFzm59vndEeM5+rYf5HC6IFDL/qXp545jP10=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:15:22 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Fri, 10 Oct 2025
 14:15:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/7] scsi: target: Rename target_configure_unmap_from_queue
Date: Fri, 10 Oct 2025 14:15:02 +0000
Message-ID: <20251010141508.3695908-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251010141508.3695908-1-john.g.garry@oracle.com>
References: <20251010141508.3695908-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0054.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:346::24) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: 909261ea-05b4-4f9c-9d9f-08de0807730e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j3BH6l3TZXslwXAStuOos1wm6TbnAQHs9cbQ3hG0Nlv3Wiq7UgD1Pcef1OQE?=
 =?us-ascii?Q?XX3dR4IlZOHAmSHtVJQ58YwnM3rI4NtYPyM4YnhVdNaur1MZcvOpS/WxSmIJ?=
 =?us-ascii?Q?edWaqe4fuVpaEJ9otNdHuo6CjuVYCINaTpWWuRCDlxGDVye/UBGdWh59Sw07?=
 =?us-ascii?Q?4D87PJ64PBc6yyXfTtJpbMoKsWYWEkiuSFsWMS7Rm+xipfJ6IZoNE6T2LjBn?=
 =?us-ascii?Q?zG0uD6AQEVYhLdbx6k0s+pKll3KHCOw6i42qksuPkKogzJWpJnFTidZ8ubaS?=
 =?us-ascii?Q?/BRfmOctHS5pD2WpeqzQI0ltFEReVfGPICxzkh2vRHO33TBYRMTWr3gRHcbb?=
 =?us-ascii?Q?8BpPwbaR2VgNEI1KbGPTTa9u/C9GZjOB07pRfj5pfYHd19lj1jIPH4axQebi?=
 =?us-ascii?Q?NPmMafCRIKfmXuyOApHRjDS0qYD0xKUMBsQ/eBiV/xZHjibHjB4QzAT+qACi?=
 =?us-ascii?Q?l904aIEU59a40Ja604lRZ+rM7dxcxlTnzXGb6/7UXE4YcP1cggHA//WKYe1a?=
 =?us-ascii?Q?0kGCmmzLiUJODcG5x2YCr+qcGUzmFAZlsa3/daPMOzsybl0XagtuezVTbwqS?=
 =?us-ascii?Q?zOt6tnlAjHiDuRhlDTHdvCYjWAg0Eu0FK3e+//JlXDZuwcm/XnV/QT2Vz6Ix?=
 =?us-ascii?Q?AjvO/uX3llqELVNDv62e/oD1G6q4iUwxnKndA7y/XyfU2LA2v+qQAxlbBPot?=
 =?us-ascii?Q?s/vbbVwO8/rAACoV7yatF3Ibj5Ks/SgAxD1G9BgXCqOiTO40exewdkfpnmdY?=
 =?us-ascii?Q?tkLuslZS2toPaaIrp5Co5599Ii1iu1z4vk0kpK1rmv75IxGN00dOxbkSv1j0?=
 =?us-ascii?Q?8GkXuKCsm70PFH27X2slpU/O5OzXxG0HUTRL9PwjE150B/NZo9v1+w1SSGoS?=
 =?us-ascii?Q?71RUESoizxcZrrT0p8+iO7y1ZvoJQSdVZ5Ha/TT+Cfw55fG5osIclBzox9tm?=
 =?us-ascii?Q?oxGJsI9O+50KD1UnssSof0HUmpRLeRVMzVRGdw6Ko+UfFV8MbK71rrcJCSRz?=
 =?us-ascii?Q?fadghmhRCvGjVEUyB91wiNYxmWFiWkFh4yOPMFY5kTkNNnHvRIa/IwYk635I?=
 =?us-ascii?Q?+xpzbjLhsKnK4DltTdwFwc+aXI1wE25b65FouipCvmHX9/CDL3LyTDB6ahbS?=
 =?us-ascii?Q?PjvwqcFivHCykoIOzE9EYmyrTKFnoz9cI6NFq2pN76QDpfZNLYKOw11vXago?=
 =?us-ascii?Q?3DYNt91NsQWqY4LRLs4xB+yilTwBa2Ccuhpcsm96sSDtnDqM9CPCoJkvCAEe?=
 =?us-ascii?Q?bpRujoT90DNLJ/38jbSeZL4ruZL5LTikeu3tLZ4AWZYs2QywPX+esSEYzcJp?=
 =?us-ascii?Q?YclC4E94VujLUOGoD+GexQYos3DjD2Y37dqVVOztelG89GBB6HM5VxrCF+zY?=
 =?us-ascii?Q?SLVuYHEgPKFmU5Ujobpv+V4AUUEO3cXLnT5FW6oVj639nGrAuoMSHXjvf3la?=
 =?us-ascii?Q?NWRyhd1y5DezPNV3p3JfERwjnSnQ1OKS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IgE3S8jdPCAsU1vfuNNYQunBQE5UkFo9XIbh47wtgcC/OT+YyJeR8v48Y8c1?=
 =?us-ascii?Q?YGW3pvsdf2WK7Bj8GeIOaWUS6H9WBWSmy961RQ8RS3/Sy0xcPMIA3oCx2cfY?=
 =?us-ascii?Q?6EY2oQFecofxDbD/6tCTO4v3hOqYyMpQFqkmZqhxCMkLnKy7siedI/5P9pam?=
 =?us-ascii?Q?qQ3MUbACqX7ruRYCbd5z7ajr0OekV6lWfZb5kRxcc+pR1vfkEIybHsJKpBJL?=
 =?us-ascii?Q?5ny6yyn7lJDd8r8Y6mJMFlVUqYtq10QfbKxGVyksobwPlRNbUsv8Y/2N+o4b?=
 =?us-ascii?Q?3h3YrxaZCvhtuI9wOyful12bGkrIrJGqb5GgBHs5Uyp09Cqj8tjGN2Ge0SlE?=
 =?us-ascii?Q?UAFFqKsRz9xaCSVwEhGX/2d6SLq2+fChrpQA5rfYX836jPbGf6D0MiPTEv1S?=
 =?us-ascii?Q?6BfjUqf70znZqAaueNGCfovUKZwHHs44ALo98f5obX3IqzZ+m0BysShjuPnv?=
 =?us-ascii?Q?jFwHwuO+4KOs7A/lNXxkPf7FQ4P3OT8sxdu8bS3jn+etIsj/uj9kEJJxch80?=
 =?us-ascii?Q?2DdQp4jJP+RJfFq3t9808NwaXVw41aB5dV0HdMg0Ff4KHQO6vCaAd9CR2Gnh?=
 =?us-ascii?Q?GYE10wrKetM84cFtwemEzgN9fYDK6v68nnC1UDWk4oT+xLmpaJoF2BKtkfKI?=
 =?us-ascii?Q?F9/raQPN+z70ZjdZRVeUOEG5cmA7Ul8fkHbv2+SOJpx8UFH0KxedYqDCJkkC?=
 =?us-ascii?Q?ZWHqygpBnIIyJU3J47AJnny/M6eRUmbCZ/OlOz9e65tdA80HuqCwHZ/jJCNK?=
 =?us-ascii?Q?a3r4w43wvxNCj7iRgyGz93SPfDP6xs+74WlEIaxOYy6RJEwar+wK13oDY06z?=
 =?us-ascii?Q?wqOoe/mQAKK4oou/gLNiu/EkwykF0wldpTe4k3xtvwq0I8M2pNErDuhucPcA?=
 =?us-ascii?Q?V7bwByQ5yxssmdZZ84A8yCcStDZ8wvjGcMZYBkYZs7qMNDCDIAEA9krM9ZE6?=
 =?us-ascii?Q?gMamdL+w0A4XNryFm1WfkL4QlQD9mMwZkUcgDtocZHPRAcLARV+wBZl2TXjP?=
 =?us-ascii?Q?uKWOsFmXyZQ4xmar45jLaLFOujagqp6eDYKn7b5mXtIYD8gnC7tHmj/JcJFp?=
 =?us-ascii?Q?2rNmLrtQuU3gVjea1NiHnSdkJOuQC55g5Op1dpWZ/6zpQELXkf2e7iX58t+F?=
 =?us-ascii?Q?LFglV4UaMAym5uBLB9nF7wjjHwdn6BBAt1ZHRrwhwBW9yKQwQv8OT1CJpeEC?=
 =?us-ascii?Q?s3gZCUAUhgdON0o66q8gG0KEIkqBIOTKNL73/y9FbUhPHos+eHYEmFOwTiee?=
 =?us-ascii?Q?ESbydgkUkvFBjdBcVbwWkAjwDqPV668ODmTxvaaYCMhjdS2VnQYeluYq2m0g?=
 =?us-ascii?Q?NUq/2kkrnivnPvxawcSFpyR9Y1OTIn/30m0k9FtU6IMUeNbIlM1KjV2sTw8x?=
 =?us-ascii?Q?a1RVo5JBrA8X8o6/+ICMTmmYl61fSn/ixApM7nfs6fJTrJ/0ig9cZB12tcOz?=
 =?us-ascii?Q?TYOeBR10D9rgoLf4BBSKkxcHQ7ZGQto/foULpeB8rfOuDpWnjrTgl4wnPbWc?=
 =?us-ascii?Q?LFq+wigL/yEPYch1Q+dYA41W0YYvIdSw2SAj14nLDzx1ObcKTfQx/HbPfVec?=
 =?us-ascii?Q?fR9Bk1izBW2NtdEaO3yGyLTFCMIZlWo4wrMgGybBUDlXRoRx0hVrIrXYF+tv?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+4vCXry6TGMVpt2CnCZRX3js0APyVGx6xey6dTiC5b1dpilKuyw8hpJEh2c2iNxH2S7UeykXj/SJqZ8KyFrtjdI54mkwLpMG2u04X7ETHc3QrIu1+Hp/zjMMj5uJzsMOr5p6gTiPJqQrFogtib4n6zuoWg6cDgKrPOKnla4M1lJu2ZyJRHGVF1l98//Wtx6xdqS4dIaZUOVUL3TFZsbaFVhnlSLmkB8zkiGLjTsjp1hgk1CNYENJzQbdihSUcyFIa8E9wpa4lxlXmLf5tInRk5hs9sYc6JvxsoGKpG5kflf54MpyUBOw1r6qcBxJW06JZ5TU9EJNPcWZGaUcFURJYikRJTAYCyetGzhTmp9xZBn6dhqtGgWwm4fHD3czxw0PPgowwNs8OlZAXKf/0qyWPaBYcOOyxWukH7Zvmn5px1xT54MG0YM1pBbkL7bfe61XVYTRFFU1CEsg+BerotXFQnD9JYInFYc1kC/S6LdGGM/6BfW2ZvAygQRfL+4+WszlM6U+Ok7+i+VPoTYWycCrHesCEZl8iFR2XZXKU/1p9vXd5puDMNJYiLj+7/5qRu7Z1u2fD7w2T3RK50uPL0PXwiAU5PlthPXU399PWPSYT2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909261ea-05b4-4f9c-9d9f-08de0807730e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:15:22.8298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: roUzyfJFID6Y05tsvMlBZ3/ADulHlCV7h0X6bju3AyEagANKOg3MFk+WiXBgJVGAXKb8k7vkNa8c2DTOpvHrsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510100082
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX9wkVjWtOJafi
 vbDTPBPwqD7obbOe23w/Aw12hD9vVSk6jBXsG5Opz+8K5A1EtNeFnyA4IssOjWiNjre84dNTBZE
 JUdWT241dDAgp8tB4JR3Udcea1SddeSb4tr6NkWLGfXx6tuWas8O9zgIqsIpmF6k5MODME9Dhr8
 QKDb6AgNxaWAO+BWQPKEjdRx/2eKnr+2BMo+Zmu7HUbPb+TyiVMnWvr/v6Vc2CkJ59LN/TyTteE
 dNxG0ggFF1H8zEbOD7kUCDekT/A7CRJ5pwnYwf7YYokn8rQZbs8RZR7zdKENkRnA1cJ/8zRQEQ1
 i1xAq5y/jzgD2fxGlWPF+vJw05T0o7n+yDlKgjSIiTqyLi8/6ADDxJeAMYS76wTvnVY8t16o8sW
 tdiNMlyUEGIdXwrIxCsxB+7hraZc3w==
X-Authority-Analysis: v=2.4 cv=dtrWylg4 c=1 sm=1 tr=0 ts=68e914fe b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=gXlpGWOUVd-z5TKqso8A:9
X-Proofpoint-GUID: WTHw7roiCxc153uTsmKNmqC7NL7C6r08
X-Proofpoint-ORIG-GUID: WTHw7roiCxc153uTsmKNmqC7NL7C6r08

From: Mike Christie <michael.christie@oracle.com>

Rename target_configure_unmap_from_queue to
target_configure_unmap_from_bdev since it now takes a bdev.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_device.c  | 6 +++---
 drivers/target/target_core_file.c    | 4 ++--
 drivers/target/target_core_iblock.c  | 4 ++--
 include/target/target_core_backend.h | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7bb711b24c0d7..83fe3d9a9681c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -844,8 +844,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
  * Check if the underlying struct block_device supports discard and if yes
  * configure the UNMAP parameters.
  */
-bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct block_device *bdev)
+bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
+				      struct block_device *bdev)
 {
 	int block_size = bdev_logical_block_size(bdev);
 
@@ -863,7 +863,7 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 		bdev_discard_alignment(bdev) / block_size;
 	return true;
 }
-EXPORT_SYMBOL(target_configure_unmap_from_queue);
+EXPORT_SYMBOL(target_configure_unmap_from_bdev);
 
 /*
  * Convert from blocksize advertised to the initiator to the 512 byte
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2d78ef74633c8..b2610073e8cca 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -92,8 +92,8 @@ static bool fd_configure_unmap(struct se_device *dev)
 	struct inode *inode = file->f_mapping->host;
 
 	if (S_ISBLK(inode->i_mode))
-		return target_configure_unmap_from_queue(&dev->dev_attrib,
-							 I_BDEV(inode));
+		return target_configure_unmap_from_bdev(&dev->dev_attrib,
+							I_BDEV(inode));
 
 	/* Limit UNMAP emulation to 8k Number of LBAs (NoLB) */
 	dev->dev_attrib.max_unmap_lba_count = 0x2000;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 66c292b7d74bc..281612b9830f8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -84,8 +84,8 @@ static bool iblock_configure_unmap(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 
-	return target_configure_unmap_from_queue(&dev->dev_attrib,
-						 ib_dev->ibd_bd);
+	return target_configure_unmap_from_bdev(&dev->dev_attrib,
+						ib_dev->ibd_bd);
 }
 
 static int iblock_configure_device(struct se_device *dev)
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 4063a701081b4..d394306f8f490 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -121,8 +121,8 @@ sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
-bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct block_device *bdev);
+bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
+				      struct block_device *bdev);
 
 static inline bool target_dev_configured(struct se_device *se_dev)
 {
-- 
2.43.5

