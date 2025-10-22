Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56529223708;
	Wed, 22 Oct 2025 02:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761100075; cv=fail; b=uKbgzMwUMmiCOeYA0w1eR82KHvktEnENj3P/LzvjdV1U+8sRpYSTgCuBvfM7KgKr0ykVgh8iPxqxXmK8w5QfLjXObZKSXUwH/EDkhVdnW9vb4yFUvl7EDr/mH+joRfT5KU7WuC4Q1aRVwXJDruXCKXbZVzjdRIJu9trFP/jS/EE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761100075; c=relaxed/simple;
	bh=9vPUWHcu3pRYLkaAQCq5YYRIg9nO/zffaIZiX7eB0J0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=M0tTr9DtRV/GplUPCrGyK1JY4G2jhpdcccjUeX4bXRwBL8B++kJwAxpqLbMoDc9sTJi+KbeusHQ/JeW69JKsjT/ZKg1+OCdHneQN0iAjNWvhu5+un1AFcAWymnVwGm761eidt10gP8svKel0jcmtrLO0Vm5TVQdkW1rydUdzwHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c/FQsEgw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zsz65OL3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c/FQsEgw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zsz65OL3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M1ZZoB008923;
	Wed, 22 Oct 2025 02:27:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=F1XFwUO+V2JtLPHeMg
	i0io1vqA4zADC/qbm2nBQLVGM=; b=c/FQsEgw47yAjVWGBuNjaJiDkvmMOa+kkk
	sKK9Rg53lLfYvUFvf2SIvlX9Mzntq9ALXsHwO4bg0GzWb/gmFcBqVKqKrtJ3gqC9
	UXkUuGJ1Qyk8Bh3zAgr62UJ6t5YaJCb3u072dznY6Qtpx4/uYeP6wiuRimYFdoTG
	2mpe/PYcAHticPkMg3D1VOrvurIEOSRgEVP7bAdnaiHKiCCYTLqbE9Lzk1vYiQ5O
	UuFDvCo+TvWI/X8pUNeYsSakANEe8LFK6G88LgAzVVWY0N+Pj+3FLDHrVGMufpOK
	V/9/xeGNDLx0HBJBThvLbNjHx1ZyQIH5P8OlMcBKZvEXuSGHkxsQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d6wkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:27:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M1H7T7013650;
	Wed, 22 Oct 2025 02:27:43 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013069.outbound.protection.outlook.com [40.107.201.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcjauh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:27:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYYTBnQj5FAo1O1wRsVWOH3w/J/OkkKdr8Mlc5c20f2hDr4F0b8Hb2rg61w6hzfFizjVg27EthCAzv+kaWKz8bGU34yEnD33/8nOzDZR/WZSvRWUSIJASyLusayc7PDjC73rVz0TGJXcI0Qh3syjmkGByPNHYqOecRCRmZfg8KMIfHpm2Id8ACuszboszRkfN6zocy2rwSgZcfD4kUGkUm4v0zBANzQx2Mo9Tm+MJpB/gUs0Or1UqXrXq1YOrZZlVnm5NvgneURdD7vcl52sEcK3OhCKoeQ9fRAe+rveyqPtvarS/G3dS/onpVGjtG0qpyqPXmghrXObRiJPzkBYPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1XFwUO+V2JtLPHeMgi0io1vqA4zADC/qbm2nBQLVGM=;
 b=cCmsUDRYp5tWeHREKphFvoda6fpAW8LA2eB7elg7SVX3FdHSKyLflLPyEwUkIrUDdq2dMEfTCuFhuUBuDxZ4unkbKM2bwGkXgEFt5bgJP0f0FsRSUJsjFIKt+XIbwIcBT1GaJRdw1ZcLLlHI55mSFQNQxc+EJDNrfLtmQ5Dh8iowU9yOH9Ahg+UmxxYd9zmSv2oA3O8AyZ6Bi0CPjcZSdD/lQY0/qAA0JvUl/1WPEkCjWoPI5Radzb9jPCSvLLFnkraOVAKvIhTXIJZ0EcA8qW0ZA5oT9VNtJbpHYoHBG5BotNi0Re1ZrmNY9pKQpovvI3cx316Lji1ibGxtCiWcRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1XFwUO+V2JtLPHeMgi0io1vqA4zADC/qbm2nBQLVGM=;
 b=Zsz65OL3xarz9YUFq7MrmeTOlATyKK4p2reoQhjY5SUiWtW7h55nhHuXpp62i9F0x3ZA6/T+ukE2LQsUWtvRtmyN3iQSRbrhNx1Y+TiUu4Iekerp3oynSq7IEe+KP/kXWvSkmZQ+70vVELlisTefm+yyZnSECJ344Mj/D41Ni/0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5101.namprd10.prod.outlook.com (2603:10b6:5:3b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Wed, 22 Oct
 2025 02:27:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 02:27:40 +0000
To: Wonkon Kim <wkon.kim@samsung.com>
Cc: bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, peter.wang@mediatek.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ufs: core: Initialize a value of an attribute at
 ufshcd_dme_get_attr()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251020061539.28661-1-wkon.kim@samsung.com> (Wonkon Kim's
	message of "Mon, 20 Oct 2025 15:15:37 +0900")
Organization: Oracle Corporation
Message-ID: <yq15xc74qnl.fsf@ca-mkp.ca.oracle.com>
References: <CGME20251020061545epcas1p2c494b8e57d424f1b2dfdcc9eef6e669e@epcas1p2.samsung.com>
	<20251020061539.28661-1-wkon.kim@samsung.com>
Date: Tue, 21 Oct 2025 22:27:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0101.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5101:EE_
X-MS-Office365-Filtering-Correlation-Id: f0333b9c-2250-4494-849a-08de111292f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tKiF9vP9OyeMzmJyTgQfbiBXA3Mqel4RpjCk7oWJtahkBz+NhA0vBjwTrGaG?=
 =?us-ascii?Q?YKdomiT5UTNymyiitS9i01gOyzIebHDuxRyd6AcpGaZx2AulUB3k3hPJkQtd?=
 =?us-ascii?Q?ozjLGk3PsfPpD4rsMnuoM1RFS3xl4Cp5HeruPHEDUoL8Qi/7VHbJn0Fbxma6?=
 =?us-ascii?Q?bDR7MdICjHv7ognLQllFWnB9JnGbkmpNNQ9Jno4jeFxGbiwU8uKYRt6AfjiP?=
 =?us-ascii?Q?Cnone6KRWWuPofBY/MQM+CwjcWngJPSjQdtNTFsK6CqR03PajrHCyyT+kWCa?=
 =?us-ascii?Q?WEAs4ZRVf98Bu7Qg7pmc5XTlBG0DKfSLfmLIwKGAQu0RIPegBy3n5AnKNV3F?=
 =?us-ascii?Q?lR1HxuEqYiErLo+eV49s51f+Te/TNyoHMZWxYDMpvhpjx8rtKLIq+yz03KiP?=
 =?us-ascii?Q?zCPrDBQYaPRpRJXmNTJoIexUk0/WoCXtu+SkjvpCBSuLDGrinM2zRr3CatyI?=
 =?us-ascii?Q?13JNhOfQTWeQwBz9vBmANDwxrv5GBNA9u1+AJ5OalHyLUvx1SDeHVLf9A6te?=
 =?us-ascii?Q?wwy31eg+IBl6gmqw+7iXiIcHWLm2yeaK5vPEoats00JBWd0cecCYEviIniqe?=
 =?us-ascii?Q?ymtS77opiFbPuaKqdur7oM1WDjuoM0pcUSDJaNvwbMmf/YrI9kTz5zcsJUKU?=
 =?us-ascii?Q?++CT+cf1/RHZOzeQXGVCEDsXdy/1QPmXMcqZVnHLd4CcoZpA8WOcBKkqjP6a?=
 =?us-ascii?Q?YFheGP5S9TvTnJqFAb40Z8pEc03kOimT5qeQCxJEP+xj27LN5nLM6L/eMOMA?=
 =?us-ascii?Q?sj2Plqy4+p286iMzXVMD5o1oM3kWn/L/Qomrqq0SVWczcRQaKNJsRICZFs2W?=
 =?us-ascii?Q?fqNPk5SNCKTy11H5s9vEnT6aBHV0brB1eYrZH/KCd6iqwrnpc8fx9r2OhEDj?=
 =?us-ascii?Q?HxM2siy+SN/435/T4fPsl5zvhAWrSYvPrQuOTOWqA08xR483s74+pUjtx2yR?=
 =?us-ascii?Q?+n+umjh360Y5eMwPZdflVmvYPS6YCV4aRkvFyHNS1huGXUJIoNaUV97Oedgq?=
 =?us-ascii?Q?yjynDsJODhepd5DM36Q3Zs8fJNsc7PwVuqNZaUXFC0Pcq5clm1APRcOspai4?=
 =?us-ascii?Q?24jMXboHIkhtzlczADnvYUmo5k133/GeWitOz1fqJmQEqb4ju9bIpEjBg72o?=
 =?us-ascii?Q?w38l9uKivfbwL6Mq7LodURPf1CJ+g9lrRhA94rgUeukvx8NIngajqC7P632e?=
 =?us-ascii?Q?nwWLkR4ycDSZ1u2Zg1JLVTGZ1V4xdBH7vAoH7Fz91J5X3rZXKqm74ovuf/OG?=
 =?us-ascii?Q?OLbBqCSENw75uGOED3RYHcxdsglOu2hrrdE6Sq/Snou3E2QHwHbY8LkkjyKF?=
 =?us-ascii?Q?fHAJdoX71fjK0M9XWfzvTlIhkAqMgN8SUmtmGnImkLvhgKjjdsrmyUAeW4DN?=
 =?us-ascii?Q?jLN+WZ4gcZ05LAFQNbniX0WiG6k2tF4zTipx731aw+hlsopyVMcV4qvsKvjK?=
 =?us-ascii?Q?vMnFxpW401Q98QObcSQVGIQSJO7fpXOc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ctjyNyFfCnLKyO2wynm0GXqp1rKvAsxujL7tQlrGUfw64lAPl/Fn9cNWbpBw?=
 =?us-ascii?Q?c8+N3ct5MdinDQQ/qgqkCfwgOXNKSmRzVfC4WwvNn7sW57/VAutIWuEk/ecn?=
 =?us-ascii?Q?e/S/Oc7UCJO34A0MkrkiYixWeDx6fbx+4nRyfGRO2o8hmN5NHa9050ueaXDc?=
 =?us-ascii?Q?WTUy8s276dCeTb39GX6AoNDCZZY6WLfQpyqNkWk+udeDip+/a3hCa8urf3BN?=
 =?us-ascii?Q?QxMvo4HEmt1DfJIkBlCflZeeZqaiDk+3NfwfOh7R+KfV9LKkbT9GZBowZFZA?=
 =?us-ascii?Q?efjbSDUf44KNMd1kjbn9YfBh3mCoLyyPMc9wappep36WKmovquFRDEf17ICX?=
 =?us-ascii?Q?rpEZTurCK3GBAOyDykCPa0hKjGHEZkv6HHNkO9pXOb9uU9J3hEXnofvl7lKT?=
 =?us-ascii?Q?a/B+3grIfIregTTml34rRjZoJuMvXZptVE9VtIbCSp/oGnR1eKZ/RCs/hSYW?=
 =?us-ascii?Q?L/4xSzd6nZO0W+iotkbjDub4CJ5W4/JrTCWZPQjmiBjLJHu/XsKr/qPu9H/G?=
 =?us-ascii?Q?Q2T/MVlphVvcoflZRDYQFiVcVKv3GKAM8vb5u2v8dKMBtAlX2q288Ze2yisO?=
 =?us-ascii?Q?VgW0p00mNGwXVZz82ubJxuPWpaKIHijrkvI8Y8yWValzXguF0/PwaXR2XvvK?=
 =?us-ascii?Q?7sBt0ap9jjNgqhclhUrMgJLh6893loQPtPSMXoCtjG7hOjKRv5EDUb/q7LZ/?=
 =?us-ascii?Q?1OqYtN2P76xjjB5n67uOxgM03yukgLSBoPhI9xAiQvUqMvCNz3X4w5lZV/1a?=
 =?us-ascii?Q?xWvCWRM7hsYhcHDjOzQYZkEylN7lXVrMVFWTtK3hG3S+nONJ9vM+jt/7ew7v?=
 =?us-ascii?Q?TPWPbfjI/AKLM7K8EAloysVRTQHavBi5Y7Jbp4ZcPoQDpg0F9UNc2s+PVvL6?=
 =?us-ascii?Q?qWHjGKGk2WHKaKiteWUobOrKvf1sjjA3ir4bZjseT0J3meB3YxD8zTpU070l?=
 =?us-ascii?Q?i5YBSPkLYfDiQXXtlo/3iQYT2o9GHm3iBnJ/600jLbyjRMjgA4iSzLDf5OWe?=
 =?us-ascii?Q?nzFT5xxKvKPGfaamgrI8jMgjlgamQP1WfSyhKbdu1O7Qg7Y1yAgTl0MPldFN?=
 =?us-ascii?Q?Loq71yPA43fTC0noSQ4PK6/o63op/uqggYVfHI21qGfpU2R8ZSKxGo3GFrre?=
 =?us-ascii?Q?Yewa03ValOxcdcE+iq036tzAo0ryKVsd3GM2jNrA3fS+ubREG4XpXYwvTKV/?=
 =?us-ascii?Q?Mw1S2J01egIAT+9mu3P1R9IU9vNEXALDRdtLWfhYKbr89RJVMQUk5XqgWX4x?=
 =?us-ascii?Q?L0luUX35GJBPOowksOIadJ+dBSmzJ9IF5bX0WIia1684XF9NT3ATQmLuguMY?=
 =?us-ascii?Q?kNNEWRgFQbEVJrtqR+OpymEOneaSSFxcdC7junQS8tIDmSWA3ppj6EHxYRRm?=
 =?us-ascii?Q?A/eFnqmd2Zz3inhbMz0mohDxQ1uoSjocRxpbJV6TIoEiB8xs9fPdaC9nHflE?=
 =?us-ascii?Q?+/edC1KM+rapN+JQtt/ciegN6oIjBUQjMl+Xv7uGXzYe6J9QUnUvUHq2bWlb?=
 =?us-ascii?Q?9ZZWWLJ6+JzkjVznpFhwxpdTVwqUGa9Mcig89swub/IapJyfxDTEQfY+QqBX?=
 =?us-ascii?Q?evzk1ntkuOhztbjcz3DVCqcN1CumHhMY6hjppGVYCC+mlE5dmDcBKjDLATkh?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CgXjSuVqtwbCrJ7iJDwva7yCivRujIOZEmov0bsv0OnwDZtMWCZqjHEKkkdjIb+E+BJfVfSg1zjCYj20K2v8Mm7lVRcgDo21t+MnSL0owsuNpifg6+yAstWkNKiH0dObbZVCb8u6+s8GgWFnxX1KjB3ODLogJEY+Cyh7Gp7Lksx9jKyMP942eWeA3aBYNnXcDIUX81bkzy1/L7CcQs06LjHSvIFwhosqe6/qQM8jc3RdbFBN/yRmjc1/WzWXEdsKD10z7y/G/5uj/wwvDnHxsQz+aLznMXww3BNfdxKRtB2r7H+VCwAKnfobM/YmrjWgmBEzrNl2K83uiK2mCAOlota/uNQz16ax3hR1o/AAmppvNA5ct+5V4GEg3zwz7SToLF9bW4+W4W9T4mCPFU42KYqzqn+QMqnL7Pj0aaWG1z0lQFLVY79vH4LgPDsuEzb3Wr+z7btd4vcOMSag6mUldGj+HxAa1XaTqmBi9zNoJNamzZmzR7BEFojT+mI3HSYlQVoaGGiVshEly1zGmLPD+LhB2Psn/VgNaxAjMj567laxgBqMfl2HrDMfcrlxj/fodXz+BB1cQW9Gv+o8zyUoZ823iyXimk4Y53i+RJq6OR8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0333b9c-2250-4494-849a-08de111292f2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 02:27:40.7078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQKPURqOTFnDrlKcmhJzbx8LGkg12BdoGPbxyzd+E6vs7WnYovYvlJeU997CXDBDb5X+JBySrxdx6O7tyVi9UMdgSOlZtLiIAWXQZn9bn9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=734 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX70quDqd9/gOI
 fVHq/O7CuP5BH3HscSjr67lrQVhnFz9bcRfkpiaon2UYpkJ2l7y0BjH7JXrHqUiKxt/Y1ttkgTq
 4FoGXTAbY3oGGWB+0kVh8bGjeP4KSim2qVUGjN2gsSpogtFdEheSRGXpFV7KJ4hJKsvVubnuRtP
 uLxg1vufdxxBFNV9S1lRwOKPRcweI1M+v5wyn+jZp1WOuA5j/RdyPXwaoPxm1Rd/xJ0PDfvyFB2
 qja+wfGUtVoiruBzIBKfgTu4/gdpG/tuftvk0qx2I4P+ztaYalZH7+I1E/euaZHHJxXYGW32pnp
 EFJSqX8NzhXsPnO3kFZPEheUMGhwaAatDCnSlCL9v2WKD8Ih/lqXDAF6XVNb/JlHq+8qrhdivTT
 GZ2cq+EYiSfweMCGsPZkHU1E3U71Cg==
X-Proofpoint-GUID: oWUc6rXlql4yvuEafz1e7G-6NISQaCEz
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f8411f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=ND65YAWrIUWpliVcj-MA:9
X-Proofpoint-ORIG-GUID: oWUc6rXlql4yvuEafz1e7G-6NISQaCEz


Wonkon,

> It needs to initialize a value of an attribute at
> ufshcd_dme_get_attr().

Applied to 6.18/scsi-fixes, thanks!

-- 
Martin K. Petersen
