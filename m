Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F02B41AAC;
	Tue, 29 Jul 2025 03:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753758581; cv=fail; b=RB8cbFVvP+NXmkPIMRKnk+iHhccZVHxbn5eKeQulPTgotlJalTQD6tvkdCPovb073+GezL0aiGvezk3cVKJRm1CvXWF33KY1jtro5YxbqiVtregWmCiu2nBUJp+1RLdQN40Jy4+nLNPZVbJSWZ2tTwpSN/OqIjEPhflpWEq9xfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753758581; c=relaxed/simple;
	bh=tsynwOhJx8eVvryeHflOmvhv5Jy0x3ZayFPFOrgJk0k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BM61v74vFqZZhAfthYYDP5/wg+FhoTfx+hG1t4xnrZCJJ05O5WgNbRssJ1RO8kMWfiOGuradDrDr8aPZI1+K7B3cwgQYCE9/vmOHeV6HvOYKSF13dyR1XhoEfyXkxlKJfg8xLXl+izZQafnMSE3tVyjagZPJGMoQ0VQBcZ0VMYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L+1Sslhi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iEhaSj2m; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+1Sslhi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iEhaSj2m"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLfuIh012750;
	Tue, 29 Jul 2025 03:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=L3rih8QQEjKi/tjz3E
	FHOSMFshpn1wl3HwLOjpJuTow=; b=L+1SslhimOTR3mLUTvDOxwsexdsy00VeCo
	aNXrgsJ0eCy3R0VvnWbJi4tb3Wga9ssDUI9TTVTlh0tOh2aMLFZbeQwfoNGz2yjQ
	unX+hEWwUX+dIgY/23IdMeAYAdTpLmB2YYUU0Fz52Mmgku7QiC5xkSJmGSW6yCPg
	KRsv4eNm2RW3Q9dzGE172v2YzSnQS9PvfhuTKUltprOp1v/bjUCfP9kVRm9CVio1
	tjMELphL6+hKaC2nN5DpwbL4RsJqsXVWmfF9iHDfiAmq04yRK0OPNW52RBEfPDxX
	2ISCDfaga7Xcse67vDvXZurtUd03ljMhhSr1coKLmDcpaGkSBMdQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5wxnbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 03:09:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T2pPUL038474;
	Tue, 29 Jul 2025 03:09:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf94ehf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 03:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AWu7S/OP3pJ7u8uQ1QnP3BI/maSIImj/N7TSID8oXfSJWB4gVS73jkGSlyOIUHz635trhfq/09bDOq/K2utFVCtC7Jb6XqH87rACj+B6A5YglB/BZTcmaCRHXyt2FcDW4Vjhhoegx0NmZgbLT345RZEXWue9sRCdPfpKW+3B09yAlR/3QTYZQUnIsn4zMMy0KM9nCNs1iPeHgB0VJz6cZGTumx5XPp+lI2WKXNjDnq0ARhD1VZT/ZhSwrnLegfgCeYbSom6jREZ622geVJLMmrMyTOVCaDKOEbaKljAcDSejIr0AQdjNXaoB0Uua7QH701FMkH6Lr8nAcBoAW1MQfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3rih8QQEjKi/tjz3EFHOSMFshpn1wl3HwLOjpJuTow=;
 b=zRCQoID7l6f3CT5SqO+HfaGjKd1otvUysSACIoR/DMABX26yr8FIXDnMEmEyDaaCTxYb9HzcF/ZaEwNc9J3lWxAo2tGXlPX7xhfZsNUKHr/njtP2lzMaC86KBbNtKOVnsxVr5nKXy1pjuu4XGV+XN89WCuUMJZoPqb8GA111vIhNXWeQtYu+/z+OZXmpd5SDD9XiC9VZe5QoK36vqGKGyD9ZtSCojqDfbBxHH+CAxQOXQbVurqKQh2hnP/yA3Zewx29Kxh/EUUdlEWXuskAOO5p7hHBqMvmPXV0obgKVaoxbcSxVpALU2Vro59pKJFv99PWaA2e4RQAJF3NbO8obOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3rih8QQEjKi/tjz3EFHOSMFshpn1wl3HwLOjpJuTow=;
 b=iEhaSj2mEPVfBr8hzrkB7SO67BbeqBqVXWckjsr4o0H8ccZ7oeOuQjpbtn08HEngi5ddp5eOg+w8zf4TzTQuUDqDLQz9DFaYYLGmL3VTAhzAlILFyfjLMChpgEK2bBnGeu96wcFdgNH8ZjtjyPy7Js6HNHMRhNMnQ4UBfkarhjA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB5673.namprd10.prod.outlook.com (2603:10b6:510:125::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Tue, 29 Jul
 2025 03:09:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 03:09:32 +0000
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] target/core: replace strncpy with strscpy
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAH4c4jKgPv-Mb1=WvOW+jvGMABXcEgaDMxV0Wit32LPgJitekQ@mail.gmail.com>
	(Pranav Tyagi's message of "Fri, 25 Jul 2025 17:46:24 +0530")
Organization: Oracle Corporation
Message-ID: <yq1ms8nn2g8.fsf@ca-mkp.ca.oracle.com>
References: <20250706092522.9298-1-pranav.tyagi03@gmail.com>
	<yq1bjp9rqh5.fsf@ca-mkp.ca.oracle.com>
	<CAH4c4jKgPv-Mb1=WvOW+jvGMABXcEgaDMxV0Wit32LPgJitekQ@mail.gmail.com>
Date: Mon, 28 Jul 2025 23:09:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: 58162c93-a4f7-4bc2-f85f-08ddce4d56ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3re8XrkfmbkKUeR6ycscArIkL+Q7B5foosEBZE0Ptc3AsfcjLrUfmBqmAtyR?=
 =?us-ascii?Q?6vwG/7ludzn+O7E+alIZPrzbHFfiH/cghJnZ0vte5zOztQLA8f+7ZZwoMkQI?=
 =?us-ascii?Q?E05fOXfKI4KgCtxU4b3D8aVeMMLjcihulqomMZy6vi8IzmS9aJTruE5ZDgj0?=
 =?us-ascii?Q?AsN0VB/XS0n/uLnMwS8vRRCj/REqaBJHz5WCMv5+iarQaSd9DXT2SlFPmTjh?=
 =?us-ascii?Q?1eOdnMUrrcBDk8wF791AbEizRJuOp690KD0nvJNAsDNNEDclEK4/7tN074zx?=
 =?us-ascii?Q?0Egf2NfBSlRUO6JEeSbmVkEiCws0WTA8eIRXUohc1lvU5FlzD8ph2y9c68Uk?=
 =?us-ascii?Q?qXdyLDOetDJYtmQF1i5kZxWkHW05BqkGeDdrMabJHkAH1Vvvyb16rowtrQmn?=
 =?us-ascii?Q?rCmVY1ydEJ2WhH+Mg4HJSQHQO5k+mGq7n0ordmFra50JkcPVZ6uPOciZCqRU?=
 =?us-ascii?Q?vKESQe1pMrZNS6LdwiyoLDT6kpr/7G6U9p8cb2j+y/n1sr+3h1n4eU1d/9Qk?=
 =?us-ascii?Q?w2lkOYesVJ2/7qhjXmyExdEoMC0OwYdCw70nejo2HJ3/ZVBO3XnZE/+JBYGI?=
 =?us-ascii?Q?AKTpnPNRwdytuKcuNvNbuk8KYLD2scO4LmZSeDw7F+cWZ7MlvqdP9mgD2ipv?=
 =?us-ascii?Q?k57NYOaflDLe7BvqeLWVZoLLEWa9ZRVv+dEJVKDwwGwyJSZsj5kU0eOq9yPM?=
 =?us-ascii?Q?ROV1weJCs5YmgdeRwcnRGeDSZHgdvM2YXLgeSCIIcs5ccUfBzIIGL6gU4IRD?=
 =?us-ascii?Q?x9CYHO6pPGKipOWMNNZk/wdfm6lv0+sT3WM+EoLPUa3l5hQ30XVR+U+WNFz2?=
 =?us-ascii?Q?kU+kIUSIVeDh8M7ZxyyI7Czty2IKTNv073IJQFaTT5frrOOqUfiT7aIJPoWH?=
 =?us-ascii?Q?cfjHOcGySp5m+nTirVc19Qyz2KyX5W+JYoiqw6odqDoAHMxNO9jbG0G3nHp8?=
 =?us-ascii?Q?Dy+tQk+xlVa24xNqr7s2LX+pa/GJfOM8oXIf77XaGHMCR0sknC7sNhnc0CfZ?=
 =?us-ascii?Q?iNRIcCvPM1hx/jjLnbiF3j5hp6rmMWZypG7O68S4UmpXsnlzMbJUToRkQgHO?=
 =?us-ascii?Q?FJXFsKzBz/p0UP62SyF+A/70/4Rm/RFWVfYhF/GpTZ3KDboTKONUF+/x7rbl?=
 =?us-ascii?Q?VwdGFCA6p2vRDxOazkpA12W2W1eqmvISHgLMTG/1gkfy9n+SJPEvQAH0L+Sg?=
 =?us-ascii?Q?T58dvIUYz/lABncDmLzq9CH4E5Wv4JWAh69fMckZmTEYf7wuA8zarQ5oe7hA?=
 =?us-ascii?Q?q6C2iydI9JqpGZpPu903+2YnNbsUHTH5KLuIfY4jb7z37PI8p2wRNwANJS+c?=
 =?us-ascii?Q?H7GUahXrI22htozYcUgtaS6lYC8FIgolcfHqvgW0JKRV5mP+yq57WPy03pZj?=
 =?us-ascii?Q?3wzr5B53W4Mrhmp5e3j0tpa8nVObDwXfEeQQAPc9goe2uKnI0aKlTVt/wTgo?=
 =?us-ascii?Q?G1k2tgvQ+Cg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?csO1vYpYuSb9Km3P2pNjlCfAvu3d2GiAb2J3AOtL8sIVwzk83r2+dN3H37/y?=
 =?us-ascii?Q?QoIfOzIM58JiewQeyCGbU/NimRcSfn07M0va8Ixk14JjDfR3xTQEgsc7fyBj?=
 =?us-ascii?Q?Q3l6yzdo2e60ZJYnx7V5BkbAUNXxBYmC+lmu5tpFn1IXNtTXF6wayY5r5UVC?=
 =?us-ascii?Q?vw+XTJyI1Oqt6JNzx/Rq9qqHvG1DRKK/yXFBF/R1Djb+RWU8qiIxVc+7qtbM?=
 =?us-ascii?Q?84o4HoNQ21QnS8lA2Pgm7KDPp34TN7kp2z7nLhwdcLCyF7g+YoaNUvU5yw/X?=
 =?us-ascii?Q?q8wX/5aACceWd4ZdCDaHRK9HqGxd5ySR/atR2CbWAbtzG2lj5/R6xb980sm3?=
 =?us-ascii?Q?zWixWxAnFAc9BXZsGtNBuoZGrtrSoNv41MymgRdQb4rUCCqbtCVXN9CXifzu?=
 =?us-ascii?Q?2m0HXXRHK62SXxTZXo/MKmqSN6ckgxw+BFquy+l9aUqZLCIpTYlLHiYferu7?=
 =?us-ascii?Q?Iijr4Jfif2DoV97LTtayaf6dhOAGU+0BJtBPrXIWgC6TPabY8GUqAp3EjO78?=
 =?us-ascii?Q?m1i3Hj/i7w7XKZRgAoShrInDc9m3dfOGUvfp1NLI5i6+jvlz+VYmSYQ3CdsX?=
 =?us-ascii?Q?fehgPClp7DF9opPemuOhYvHjpCrzK32lbw2MOgLde7btsziVpIepEv2l72bu?=
 =?us-ascii?Q?iiRVLDj56ysKCl8EXsRCdS1uCd3/e5I8ozy6ZB8D43JhhBkADW0Og5H3AYzA?=
 =?us-ascii?Q?M505XxNOw0HWgJ7aiyxEXO9hsiYh7W+fmunqlcdps7ROnYp3jH8rJgORhkUi?=
 =?us-ascii?Q?Q/ViyH9RGuOZypAPhyOdLzfupv8YNFIqrPm4UbGGscLZrDuasZKA8Q1X12rQ?=
 =?us-ascii?Q?R0CcKrPsGX/FA8M+uZudr1HnD4UKKXWSAUjwa5EYf00rABXcYFtd3r9GTWmE?=
 =?us-ascii?Q?GW0Zr3QlyA1mzaXszlztq0gXY4H/6dVd3F7VtavHbovYv8HqnuTppesqsH9r?=
 =?us-ascii?Q?FL+uc/qBcnPY+U28B65eB16r5jWuxyzGY0YtawZDDS40Ut8KdmTZ0NfLQSQ0?=
 =?us-ascii?Q?BLhdFwlSWcWxsgxGtuLQLm8aV7kdMd3z18B5IYlBEbS+e5IqxC0Q0pO5GiCA?=
 =?us-ascii?Q?hd7Uz3fzV48a50h6LI9Bp/vvSTUjWivGkzj6EGU/rPPkbcqmIA8IzH2EhZ9n?=
 =?us-ascii?Q?/KCzFJ8WQtfpqjL4nIGFQEo05+oyyGXkN/ygNYJq+7zdvLQNY7sbn2NtNFGe?=
 =?us-ascii?Q?GO7et1kmSHuLcLhnDqn5lLsnMP6klHMhBmM2UCUpoPQh1wmhvNtaMsshCfiz?=
 =?us-ascii?Q?8rFiBcd+r3dLIlnpWN8JHLw7xZt+pTe7x+9o+EwAUf9osgWi39N/3/hPqBYu?=
 =?us-ascii?Q?DIuZ4EKedrh6/mhcr4sX0gsH5uz16Oyq9VccRjyXfrHcLjfk7AhtALBd+Uv8?=
 =?us-ascii?Q?Agn3XscVBqeXkz/fg05A1naa8vVrE7nd+ZGkv54CsU0LK5Puy2SvDp+Xwtex?=
 =?us-ascii?Q?cifJUUjrPpUvhFY/9enJ56MwzCPMoDheQZuW/AcYJlkqs7qbSxxz38cW+Lic?=
 =?us-ascii?Q?pG9t6OdO+6c3z10pU/FR67DFAriboexs3DatlNqaKSSiUFgGDSnB6Aj4zfVW?=
 =?us-ascii?Q?5kK68XJuW3n21wqWiaogWSsSvO7D95RsAfjb2CSqWuktuRJ5Z0FxOw49X2XJ?=
 =?us-ascii?Q?qQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iEl6KAwfxGaoWHSuuBeZ4jmq6t1UqMMtf3cNaCK3druCRMP1wb/DdmMwyIZ/7tszGSrHOrTDfE9l1KSlzIIgpvsyZBXoriD5Snx+7U3U9wTspf2YgIMmo501YjdKx2IJBAcAcwkjHsy953Voe2k7p8HsO+gJrWsTM61Ln02uiklt6WkVT4XdFsqDVqtlYe4k0/Oht2qBceiVyny6Px0MQm3mXHmwCkXsBrVNy+kwZBbd2w3VlM3VLhptNj0nsPkh/0ZhmCJ0nsMr/Z8RVRrd90Yr6d9qOgVkzoxFGr0WpNyruXWBLfmsjhw7dAKKT0eoUEMsuH5fbcvmyVQ8nqyaiGHh3QJY0Y/FBIb4kOUvp6GyQjEk5OgQFFUNTNz5nUcbm6UVAUcI8WufZJhu3OMTFeVEd7XNTFRnls+NcSQwjfSjPqUTMqVoxxI1L97E885gMru1ylp3IPdRsaft/OzuIVR0MOaEYcJ2ZhOhGoQrKI1g1vu4xoMq+YjbcvjazkUuqmCwAuovpOXXoT7dfJB/p3aUvG1WPTAlrg09WPH3b6eg+1giqKP/Ppy65BKBLjZADri8YoDMLaQCk1aCzKcu36IpDl4Wxsu64yOYUaJp0sI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58162c93-a4f7-4bc2-f85f-08ddce4d56ae
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 03:09:32.0119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PEDPpc16zG0xf91AQToHP2r/zB8aVWiCA1xffNDc4KlsNNJfLU2GpT91Id8xndFQiXvZBgCZInM81Oj7e+hAJGMHyKWouSGsF0NJoyWjX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_05,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507290022
X-Authority-Analysis: v=2.4 cv=X+lSKHTe c=1 sm=1 tr=0 ts=68883b6f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=kg2uK6yyNHlUWSYu6IwA:9
X-Proofpoint-GUID: IexJhOiVGHEHRpXoG4jJvUZbRcoW3my7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAyMiBTYWx0ZWRfX3dYdML2W8dzl
 AVUOpVxdJtlBuOHBa6hVm2Tl79/lTgOTEos7cXBWlVa4PEx+iOB2mTPUL3n0VKZ+oD+kiAD9pqZ
 80IL4gFCAAQ7QWAbiGuHmH9AeiQjrWQ3XnsKTf+JDbkxfZH3BYiBZjju48wcbDSb/vWJi+lZU1W
 qyggbRU9vfL/DGYzvfKzf1FQ+wiGk6XQXwKjlB6aHHyFfx3eGnaJa1g6APlkE8hcmv+JYp7/YWI
 sg8sAYPjd4Y7aFzheI+YF6se8oAZ0paToLA7C2yFcfhHGacYUy2FflTqtWx6X8Vgss4E1tNU+th
 WgfeIfFRAfSfVC27y6C8nqi0ZhDZMCHPfA5fFF1bfB3Q/kBhvcZ/FyoJ7XS1J/KvUUZt8zWLXzV
 S/GyU/iZymc7kIs4FPxkdDFAf4lHmljDWo3osvNr2DV5pDMnHSZ/X6aRlABvY9qtxGJCbJu0
X-Proofpoint-ORIG-GUID: IexJhOiVGHEHRpXoG4jJvUZbRcoW3my7


Hi Pranav!

> As far as I looked, I could only find the following 4 instances of
> strncpy() for the file target_core_transport.c:
>
> target_core_transport.c:1115:           strncpy(p_buf, buf, p_buf_len);
> target_core_transport.c:1165:           strncpy(p_buf, buf, p_buf_len);
> target_core_transport.c:1225:           strncpy(p_buf, buf, p_buf_len);
> target_core_transport.c:1279:           strncpy(p_buf, buf, p_buf_len);
>
> And I have changed all of them in my patch. Kindly point me out to
> other instances, if I am missing any.

Sorry, I guess I didn't read far enough. I was focused on the VPD
identifier dump function and whether it could overrun the static buffer.

> Also, I intended this to be a cleanup patch for the deprecated
> strncpy() function and wanted to replace it with strscpy() which is
> encouraged. No functional changes were intended.

In our experience cleanup patches come with a very high risk of
introducing regressions. Regressions in the I/O stack could potentially
lead to issues such as systems failing to boot or people losing their
data. So we generally only merge patches if it can be demonstrated that
they fix an actual problem.

-- 
Martin K. Petersen
