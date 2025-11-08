Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6824421CC51;
	Sat,  8 Nov 2025 18:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762627342; cv=fail; b=cOTluk6MT4DIiZq/Sxe6pvd1dyVA2O7icazl8oBlQleLQvuKJRQXMCjxCbKu5msOlKgxcYI5Ed2jTZ4Ww5pCUXIzHV5FJnrzL/KB62zQGN/kY2zVrwO/h3A5xL25B1mB+PfHW8bFoQeGMjgsRiNN7Q/dq9vnGpnqdEI5pJAhylg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762627342; c=relaxed/simple;
	bh=zDyYcvNjntK4XBOd32SpBhVfO49Lo46NVt2YXthnU2M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gYxl3/4hOimEjh0wcsBb/YsO5AONW3HeIBZeG8xxCzsKuFl3llC+U2vOy/i3GGeDyzRE/IoHOd8LFj5bYgWPjYL5WKhsJ9hJ+GC9U8g9wBASRRcFBCZFefcQiytgY7Gc6fsYtgyqO/0Xti2Asjq6f8l8SrZidFXtpzQNLXaJy90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NTTJX1iE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uwtiKNG6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NTTJX1iE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uwtiKNG6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8Ib9cI025016;
	Sat, 8 Nov 2025 18:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3WYL3l3i1cdJF+3klc
	DWKOIFoWmi7vPTU0wsHvFpRSc=; b=NTTJX1iETam4F+XBfWi8JSgm/puyBvHAYD
	MvDb6moME//qfrtHEMu27RWntFRs94WdsBJ0BwGA/a+hJfv8Z+U+q0E1VRlGHZLL
	w5/esjbQGCJxm1yP7Pmd9ExCrkLwFKs0PgApMbs/h3xf6rpyxCrZCvI4xolYi4Yk
	2dR5lhCwBaKckyyKzKZFF6Tkrg8DHR9uCfKqb/P49NqzF/IKknru+A1sGT9tms0L
	NrgkeR5evJbZEmaYiTkbIpcyeYOBY+DB3Q0zjpT97u7pnoCHvesVTIDjiNhUzJTj
	hSPaOPxlFvEXT7V8DFmQnBbuffX7iu559naFvJ9Q/T+3JqsGUr3A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aaahpr18x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:42:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8H4tqI010111;
	Sat, 8 Nov 2025 18:42:05 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010065.outbound.protection.outlook.com [52.101.85.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vagfu8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WB+3ToC+BT9/Ho4SMY94t25tZoMuSZ/ghtHhBQndgkD9KDaN4v8hQpjW/tBkjEJztWa4VFewEg7MZOgrbByO9spxKGjd2YcErvrefAoCNRsHxFiS2XO+bJSm4SkltFELpe30y12KfaJsdh3DvqE1iSXPIYdj9QvdaWZAjhR++1EtZDBvzYaP+5+fpZlnVW/gtWw1jjJyzZBZW3XbJLzTjGLrLNCzWhmx0lEOJLvLusbH6MOPF9LyiOF9dlDn1LUYpUBt0HPnfV3Xwj13ruWSctf/WsEO/MrJVYwdwSn60RH3rra6Mrsi5stZNDjS6Gz+GcTLWQCLm1B5NCWyenXjYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WYL3l3i1cdJF+3klcDWKOIFoWmi7vPTU0wsHvFpRSc=;
 b=sCOFafPfdJtfxHGV2Rl+Y+wMWYc+kKzPNw32yWNOVpd8gRLHFhTwjmYe+ggOlb0w20OkWi7HlaHwF95g1WjSw2JVRYnR7iWZJBFHhAfuitD2K6BI0/XAGvzkHMBbXdr8rfISjixrxI4bwFuWSmNMoHCvvnuX9N0eG7OMXS8nxAJeeSdEo+C5co2FKLUTdXGmKeWx3THG8U/0Xp9iLgWY2JGa38OjYCXfmdgSigAWbQPWCJTRN79AnOCNSPUYWlz5/ElNgvRzevYLHhxxdO5562rXtMAj2HqA5cQ0edYQPBsgAcvk8u+zCA/d2MaWpOpI9DRfOfqhZj/bmVO/B83j9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WYL3l3i1cdJF+3klcDWKOIFoWmi7vPTU0wsHvFpRSc=;
 b=uwtiKNG6yBk6z4C8hpapJLYOq/qo3BEp/HysDbFWax64ZJs/ChIB7bdQKEqA5rAOe78LVq4M6Sa2gi9mBRScg50SlcA366dRf9TC0/W6KIVoIjyDkNaMc5hG0LNWeippIfesxyoX2xsNJ7PX1YaUC2ncuh7t7JbbgJ00bSaDevk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB5914.namprd10.prod.outlook.com (2603:10b6:930:2e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.15; Sat, 8 Nov
 2025 18:42:01 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 18:42:01 +0000
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altan@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com,
        jens.wiklander@linaro.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] Add OP-TEE based RPMB driver for UFS devices
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251107230518.4060231-1-beanhuo@iokpp.de> (Bean Huo's message
	of "Sat, 8 Nov 2025 00:05:15 +0100")
Organization: Oracle Corporation
Message-ID: <yq1a50wgyf4.fsf@ca-mkp.ca.oracle.com>
References: <20251107230518.4060231-1-beanhuo@iokpp.de>
Date: Sat, 08 Nov 2025 13:41:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0319.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB5914:EE_
X-MS-Office365-Filtering-Correlation-Id: 04e04235-82c4-4988-abaf-08de1ef6816d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C8sAMsNt+Qg5mbO0uc6E3O86jq2og2E8Qb5+PSk9fG8maYpWGlRZnSrizrFD?=
 =?us-ascii?Q?Cb5k/c9nzuUzZ2gHCrYctjVWO1oeit7gmbHzieSlolEja6HJ8bqDWu06I4uP?=
 =?us-ascii?Q?e8xK0cruzfiA1jY/cnji8Rrkj8oQZ3KBbv4waAX3q9eAixJaWBT/XKtqFUk2?=
 =?us-ascii?Q?cpHoOcJD0ABIH95WR1EJgQsmqIs6TFlbcuWde8xDrspnCvm+6VbLojPz/pMf?=
 =?us-ascii?Q?e96KAAIV5dNkH47zD7xuxmUrNAiT9bZ4IOn7oVocuFkvg1HuusbjgCM5/2Pr?=
 =?us-ascii?Q?jtS7R0H1He2dDDRJQAZAkc8HCacRNV9PZkiAYb3CMT7WLbsxeGy4u/HrM1VI?=
 =?us-ascii?Q?+PFgw6MOHDUoA6ceQ5/ZSRWxIgrctpRyZGMBb9f+urpP28hmJ1StEAKvdJc6?=
 =?us-ascii?Q?6KAkIqdj55fb58YvFI9F5QPO9G99vnTKL6Ep1OM7zJXKEDl4ptoO8BtufY6t?=
 =?us-ascii?Q?7xo5+96CLPI0Jne/sZuvayJwI5CLJMPnKEy5Grz4qnyRxZuVXk/nkn3CqnWv?=
 =?us-ascii?Q?yWkUcWRtGbSXNCJT67/oRH+l+4BLRfETqDsR4bMj8f1opsVuhR5TblpCgbrw?=
 =?us-ascii?Q?koybIM9blc8lViW6uAciB5Ixy9bws9qX4yce7igoWkMFRIPLBtSXnAXdj+jI?=
 =?us-ascii?Q?tarSTZIGsRzjJyZAlM6WlXCNjQ3A4+4HP9UsLRCvS7SCvoxrZcxPmlKCY4aP?=
 =?us-ascii?Q?7dWMtXyXa6q4ViDoTlXVvSSk8j4fJMf1I/ph4m2l0ApOzz3QFwgqdZ7LJrVc?=
 =?us-ascii?Q?r5oLYIgd8S+baQdYBJMez7f0cfGZh5eQdHpYy+MqVIznyS432g7yHEWP4YeM?=
 =?us-ascii?Q?18cuGSMWYUWw3TY4opHd9vLhXLjKJBIV6xFIOj1CfAkXghaN5yiaq59JW8Pd?=
 =?us-ascii?Q?d7ZqFTdO80yAXmhJUrcOwqWxRcbgPVwjbq0PH5INv9UkdjmyZgH3rhTMh20o?=
 =?us-ascii?Q?IiNH7HSJSFWakVUeg8ZI3SlzEH3aKdR+GqkekqV6p0GynNnGOXlkwfvtzFnu?=
 =?us-ascii?Q?s7LlOIVtNhvL2rIsE6mq/BgBFJkRu18F+vVkOD1Fik8fEAcbHiw9GaswCXfq?=
 =?us-ascii?Q?VZHEbMjiSlu7QeOtYnEU8mHpRUIxz5G9cZdvbeH4s2GprAc4tORgFOwAvg41?=
 =?us-ascii?Q?oZ5uHS8dIMsxX7+pujo8jqiyymkjv+M8ANRfZZsdLvdRDP7sWuWmcLlTgxwH?=
 =?us-ascii?Q?/UvP7I0aVxjnONWoOGP59q5uNUrzMwxgvsVDqDWOhcziXohq9gWSkTVq7Kge?=
 =?us-ascii?Q?lc+iHE1kzuOKsn7WC4aqAUPT03xon0ZwhVdxmCl7n/wXhDm1Wh4GNdyqNzr+?=
 =?us-ascii?Q?hGugG+djHzYLQQAkh92FFuiaYA/GqC3q269CuDwdTnerHpKA5IMuJVscWbIZ?=
 =?us-ascii?Q?RU5aHaU3aRuwBo+OyjoRbZb+YEe181B/qs5e5TQOdtCv6jUZxeife4u0bqrV?=
 =?us-ascii?Q?6ygKFj2fgJRj0bPOjqHEXg9TxDOttARV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZKl0quF3/3mL3xdebnbvMjKUJ83IGPy+y8iGKbzSjVLz1z5kP8ymvWB+nehI?=
 =?us-ascii?Q?uhaJbJdu14wE/AXxfnL3fqsVxqp3Z/HmngchFRmLdDroNJNRldwAkm/6bRa5?=
 =?us-ascii?Q?Iv+aNKWMit5piawkhMltbqphESaYkZ7EV8Rk0jLUp5/JY19sd3pBQn+fAmB8?=
 =?us-ascii?Q?7+qUp/nhLs4bUWsws56OZDruVJwxH2lTnhzJIlbyTaQ0coAqxb7zhaxS/3Sk?=
 =?us-ascii?Q?n7v3jbgrw61DYgNkIlXW/5HDvDCVaKdW1h+0DwdlJHkPjtMU9g0rrYM6bzAk?=
 =?us-ascii?Q?eLxSPVpWwgatuLMABPOKP02BNBaw9vacF2zcBCu8iNaI2JNiXw5V9oy+04iZ?=
 =?us-ascii?Q?RWgM0GICyLjkXds/bJcF2pAHE6iS9JKOYVO7Sc5ZgBkdIGevXtZc3BRKxFza?=
 =?us-ascii?Q?93o+go1WeT4NwIVV6jR6Cq5qD85OFlV1oZzS/d5EfshW8e6UNQv9SeuINHeh?=
 =?us-ascii?Q?TMu3GIqqmV/Jw3OP1/5bpZ6o8+xPup4EMDgPHhsTxISKht8doVIHMtqCHI1t?=
 =?us-ascii?Q?Ag0y5kO+CX4aord6ZpydeHJpZGJ453d8XPy90zjv/RXWH0kFIIZh0Z7jxebQ?=
 =?us-ascii?Q?dfsVo0N+8/vTtOXJnQqQYkW+OcfDs72W3HHxCsAg9zQNvDmEBKceKp+BkAtd?=
 =?us-ascii?Q?UFkn8G7bHUuPOnYZuahdokqoYgPNJOCV/19lUgjur6ogmBOcQZE80CncNiJm?=
 =?us-ascii?Q?b9dpMMgMM9aW871J/r+mB33IiuEit99HhVoRSELIl288sFqoLiITkHUwC7mQ?=
 =?us-ascii?Q?YrOFnxWvL2dY2SKqsW/Je5y4+zEDz/+HDJCcmPb98anw1dXr9tXih6r+E76f?=
 =?us-ascii?Q?2fHVS6gXiJQduTzW8o0Ml+QuirfSjbov6NTBt2CQOIDyLDg9FW1XsBAR+s/q?=
 =?us-ascii?Q?CZGigPi8RENcxGqRmmyDPxzkfd8BAkqcq24mfYP7UPcTOJ1u01YhL3DB3S8x?=
 =?us-ascii?Q?bkb0bmjQApGLlNPYTl1xJYY3JrSwynh6gvCtrRLfbibCDO5hAYUIJrRUzpWh?=
 =?us-ascii?Q?xGGzqMk3Dr+rY+mtaqh1W+9p9EXWYBFJlXo56Tc5rsGIJJ55+UcARwp8R7y8?=
 =?us-ascii?Q?kebJqCzWFcxwjQQjxbnVwd7OkL+iTVFJRp/2spyfW00+rQGDzXvsaFneR1kK?=
 =?us-ascii?Q?HYlJx6fXFFIMNEGE2S7P2UXrDttNEMPR4AR5ohC7rpb/C6q37yP13MlNwW6d?=
 =?us-ascii?Q?OZPnmoqo828GnqkK/GucJ58j+fUt6eMWIG0p/FZKYrDOakgOYG1sp7fDLzI1?=
 =?us-ascii?Q?flNYcoMgQU7ufD8PFEuxOAL+yI2wxvY/BAdhM+WU7J4lPE2npewVuY/s2NHu?=
 =?us-ascii?Q?uPKiL2ZVMWTXMTu9lR2jdCN6LIhkllkdpDidWJJ2VWW+m5BSzvf1AIvghPm2?=
 =?us-ascii?Q?AtSqAUQzgUKLGtqm55lZ9kR0HsnkZJV14QnY15SXtU4kxirVkvZCi5YvQm9t?=
 =?us-ascii?Q?hfWkDAlXbdqJMQo2WbQoq5GbS6U3H0/DuGVsYM6FntJ9n0sVBwqCGgJfg9jp?=
 =?us-ascii?Q?mhdXJ748bEu5ZFeBDc+J5FVv8bTzuY1K5H6oSmIRAJVNsKbkgPrFxQ67FL41?=
 =?us-ascii?Q?mHaBkK7kVxx3+SFhqoa+YB0npiBaZEcFMMg5t5NbBw9ib40aPL09Wwmd4R65?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HHFEAGs4A5rifGcwZIl72dq/5o96Woo2CIMHtmxRw6qkcprW8pRsqYI6ZE+tBuILE5O6Yx/tgD7ENBParvtYQ0aUhqYGEayP4ZHMyIAFLrpva7oKkcwwXKvQcC+I5tNiv2LZ+Mou7uI+krUXU3iAfVs/zE7VQMmq/bOpXq2FR2QWGk7/RA7nAe2guDq5sSQsIzNv/Yvzkyb2OOV+N7bJcAeu7FocJ4+UkNfxq8GWmzkcGTp3lrJi/3xFPu/2RXRsVWavgFREUkWn9fnZOYUltJStAd2jCRW7CibOAlUqsLP1EX13ORwdn9+etvZJq2LcjIl1HglEZHK4UFr02xnNzTazdh9PisQbPrruuFqSOIeVkoVkRBA3qHUuGTf8Z3OMUXMjSJ+5wcmNLiOC3m+Ke+XYevoESHt8369VuJ+5m3tnDNRgjZDr+uep1+FsG6L6seSduOWcn3WG9w1byHvydua97VeHQU3+jVjX+D3858AJYmKWwwUnugWMMP195iqcr29nnzXVdtt5E1uVGf7DNyus8zUDOfZnOQaHYTPOI1BEgVx8In96PhsFzJT0rOmEKJ+cqycXBiKrT7iXcwWMCktsUEXJyMfSpdvUvU7Dlz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e04235-82c4-4988-abaf-08de1ef6816d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 18:42:01.7354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxKzJKE6aEBPBIxboer7gCyj1Uzl20SFUkguvFfxGphMmlHSH/CmgVN1q5nnI/N7R7EymWhKSxjbwL8JmyhnV9/dO8F9HKDG6kVADK9y3x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5914
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=737 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080151
X-Authority-Analysis: v=2.4 cv=etPSD4pX c=1 sm=1 tr=0 ts=690f8efd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:12097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDE0MyBTYWx0ZWRfX6TSGFPNpuU2v
 ugoG+EGDT9mmHne+BuV1AOnZxb6N5XIZ7X81BguGGGjnDMntwKkh1yWXSxrkVbUxotJfXNL8hrW
 Bmj2oEJvFk3jSdoDijzcRdnl4ZJhTPpUTJdanOPn34zG3nay9fbWaQRMPR3tjfdyXxnKkv4w/hF
 YgiPHoVT9Ovj1wlDCpKkjQO5x5Gnw/uPyg7j+Fj8JaUo2gzVCgeGXTAwpbqOtCGNx/blZILYzKv
 vyNENYutK38mEzp56zONMCqqd6PeVp8SPnv1JfimurtTika6NFsV2waEHcD4bYMb4EC52KRHk+S
 yyzjv0r8oyUqXqYJ1qU4D0pYpHw4dVky9pZSgNjy0aLSOMuEDY4yNw8BdQqgExpG5V8OE93J/DC
 5CLBug6XabzGwSK+S1jsUkexGnDwmg+1e+BzBc7/jr3ri8wTMPk=
X-Proofpoint-ORIG-GUID: lnb8cZ5wy3LDL5g7yNdbSjqEk-dy6DjN
X-Proofpoint-GUID: lnb8cZ5wy3LDL5g7yNdbSjqEk-dy6DjN


Bean,

> his patch series introduces OP-TEE based RPMB (Replay Protected Memory
> Block) support for UFS devices, extending the kernel-level secure
> storage capabilities that are currently available for eMMC devices.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
