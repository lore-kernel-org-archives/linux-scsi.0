Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB32915B0EC;
	Tue, 18 Mar 2025 01:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742260970; cv=fail; b=k4O4sePWM+bWQbLe+M2yGKSXoIUjDmQ5zyuKqXkNyjaObIgCVkzyXy9RqO2xJjfx54UhHeI/iz5vByqEnY0pQH0LuMjKNJIUghqgqJdn3xxltle1bv9LaFEP4cdTVrIjkMM7lDug3AaIWWU+EdQD3I41V0yW4mkmAl+zkuDTjG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742260970; c=relaxed/simple;
	bh=2RzGh1RfZEj/WBrWljN+htVJlUdU6QDi0B/9TXoufso=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kclJI1iPSN6Aa7cT0CRUBDY7Fg5ZfPxslsq9FbONuYMEfgCNww6BanU2TVuAYI8saaN0U6K9uuXfGrgJIOU737JJezEE9HXTZ0mVexoqzPUZQAWJ1bQ35MFlR4qe++IQAgr26LzZ8BSWviYJIKJzdtfqpkyOYYRjtr+mJRQfYX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PNiZOnUx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GXdp7CV/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PNiZOnUx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GXdp7CV/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLur9F010165;
	Tue, 18 Mar 2025 01:22:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=RRLDo4+sDT8s3DNa8J
	1L+jsvkIXCS4K5094GFO/EQIY=; b=PNiZOnUxCepRk+YBETSvkLfAd4gUly7I+5
	f41TPwcqCWObV9ZvirNAs9cEwwZdO0Q4DcDib56HDmwcnqMtE4Xzap3NUnVjZp4Y
	3T/GdtQEfSBQyR+mBU0B9SsBs7DVlyd5/rAXujVIRif2CW49W0Agw7P88SuVhwXk
	UbI1Pkrb7i5GnT9Xd0jUya0nmL8iSxTIevaAIYtuoSGfHHBCcGEdh3bJcmg5REAX
	rj0sMeHS1LcZgE2aRObb9n9h2x4tVDovmWuN3cZ8KRpdJBV+YqyEHaTKLJqywGLa
	4B1E3nM64Dw+1w9X2Ig62jXMUtZk0nCOByWVu0NaS8bQOPmZLy8w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1s8m7av-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:22:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52I0ZQd7022439;
	Tue, 18 Mar 2025 01:22:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeenpyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:22:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ilOzQoT0iwgI42u8Nmt9pKilZ+f5/qS1nHUr5jvkq6atUz7BDLC4+oF6xxZHd4IVHz9Yknvnk2i9NeAG12ETI6zniWN+Ra6ViWO+gBXmzRwfyfmVvW1IuPivY7cux4bn5HAHQmX7DxEqgnQqv83FClYJLR8aXGFrNxdrzR9/vG2x/LK/B5EsD9KeAT07rrZ41yKdulSKtn5Jn6Eia1SQc7F1mP/KehD5aETbsgj+x1g9oyV0cF8ufWsAJ1OYR0NKAAFyH6nKfD8ylSGqB4n2bZGtRjSg+6gDUOkNervRbHtZsfg0kecotYN95eA3ykc+WmG8VdUmv6hTeAHQvPf3rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRLDo4+sDT8s3DNa8J1L+jsvkIXCS4K5094GFO/EQIY=;
 b=mQb7dlnbf6X0f89WFk3BgPcmHaXHJWuMpOQNDnaG+nG09zm8V9UC14jW1Dn0gZdsvkFT1wer5AZQhyxhh9rHpfF2o3TiIQESsha3uqFImdVkD6UWYpdv3GCih9nhMmfMAsCE6BzXCLeyJD53VZUOnh4lVvJH3nO8XYZS/2m6cy3ULcLWlz1685m2Ljk1c/cnEImK+EDFo/BJgstMrkMxS/loeUD8zYUux4FML+vIzZ/tZ5EWtvb4pvNVe9TD45mIYReD9zg7CIbIj+FI652qXLQs7Udgydyvp9QEKLIn/w+UbHvP2GvZZJuajYAIiqp7nRMVYoEDyMk5M3h+CzV9EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRLDo4+sDT8s3DNa8J1L+jsvkIXCS4K5094GFO/EQIY=;
 b=GXdp7CV/QXla5xPUAzwLrccVvlEFZ8wpOOQdXENQwVOMGtDX3t5V7nPiNG2owccMslI9gWkT/B0sTswS6CMHe7takA+k8IZaa4TSEYkQviGK5YlZS52Hnc5CYUXvOq0HGgTHQQ+w9MgThCIf4g+qngJa8FRv+SPVBiHiwYotvT4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7831.namprd10.prod.outlook.com (2603:10b6:806:3b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 01:22:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 01:22:37 +0000
To: Chen Ni <nichen@iscas.ac.cn>
Cc: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Remove redundant 'flush_workqueue()' calls
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250312074320.1430175-1-nichen@iscas.ac.cn> (Chen Ni's message
	of "Wed, 12 Mar 2025 15:43:20 +0800")
Organization: Oracle Corporation
Message-ID: <yq1plifdtf0.fsf@ca-mkp.ca.oracle.com>
References: <20250312074320.1430175-1-nichen@iscas.ac.cn>
Date: Mon, 17 Mar 2025 21:22:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E0B.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7831:EE_
X-MS-Office365-Filtering-Correlation-Id: adfb02a7-a008-41a9-0f17-08dd65bb5e9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ar7llgC1Waw0qeOkNSSq6EByBigXTbM/6304lGM8MiQ6msap8UEkiXD/XdJr?=
 =?us-ascii?Q?AQ8vqDL6lM1MzQXNO5Qgep3hLUhW8yM+ZrQ+gkFTZwQyO6NNx4bfouUk7cUK?=
 =?us-ascii?Q?6MR3WkwiDoiFtuuqUYmuJoK5VLzIC1LylceSZ4WNa+H+30KBO5AZ/kaw/95p?=
 =?us-ascii?Q?m370DUGABrWv/MgT7BtceLMIbAJjw/Q5ibCvlhxH1Aw2QdPNshnp+0/TpaYL?=
 =?us-ascii?Q?AhtbOoKqyj7fF7Ziwsqq865Bv1fTJaYeg/ceTzHzAB5pxFy3Pl6N9SHY7gh6?=
 =?us-ascii?Q?Bkf2PlvvxTekpQ+5EKPwn1ALvEmyYjAhWM6kA9oBXG/p+h81wmwrID8yiij+?=
 =?us-ascii?Q?nijOIhyB0C9PDbiQCVDY5tTkoXguGbbZZO8nSbHEz7p90EFMqZmxVXqjXb6Y?=
 =?us-ascii?Q?GTSfNAhDAoH42ZN13r5fiuKjmrb+0lWa5ch8lxog7c5NhWpjcYFX8cXWNBBP?=
 =?us-ascii?Q?9XqdnhqdbAABTbK4N5Bg5B542ZTbXrKPWI8R/5rWI8L0B3PQPp7wYIBdvUig?=
 =?us-ascii?Q?fgg4ECUHN4bFi6C8JNrhMPHA3e9rnwDRoBjCqiqWri+4pXjO+k0Y8aeRjkYJ?=
 =?us-ascii?Q?uxwZ7YAGyZTjRs+qmgCGurhFY9psW4TFFhyaJCmRycDis+xVxv1Em8Yt++cd?=
 =?us-ascii?Q?piD7tGDl1wkJewD1iZcOCR55H13t/jGIxACmFDiNnRh+h0WWY3DJuXwoJb3g?=
 =?us-ascii?Q?MMSB1Z598k2HVx3oZKFSangQ1wJ9HHrRktieBMxdXw2OJ2iuR9HD/cjk2gSs?=
 =?us-ascii?Q?N7b/S6joMVi6mtECnHdiMFXn+s3oSohB5k/mEI0XsfTP3ZYzdWHMcRArXMrY?=
 =?us-ascii?Q?nZJ5MN7RvYgqTSJAiLmfV6hWCBLoa4SkSyyiAGR4F+RKQLkZIzY/01eYKf+w?=
 =?us-ascii?Q?u07YdyqGRC5My9coxMrbdkJJyQPEU1Akqqlt4YibMkz0TvXrQg34MZpyg9jB?=
 =?us-ascii?Q?ei+oMMY5QXBMQYZQODS495wR20FmGoCY9FmdUI+Hdv+Q5LOiiQ79He83V4Rn?=
 =?us-ascii?Q?emLCjncYAT09gkNRI6pH0RdQcRskBTuHX3qA4RIq40OvGnwhRy7U+8KLLa2S?=
 =?us-ascii?Q?zRmezUOlrUYi4nYRZJnuO/AondoeY2hpncZV9xH9XJHn2vn3d3v+hk3CGq8w?=
 =?us-ascii?Q?j+FVe/zqIICP5ZpyRiskf3XivR/lz+h7sli/W5CapkTQA+aHyNFe99AWgqUG?=
 =?us-ascii?Q?Uls07DUjh7WVGKM9i3k6vd6ksIaWJMvoDTR5Wxz+2JR2QKemLF5wql6TQUZm?=
 =?us-ascii?Q?TPOfb0jGj+IXx0EklpFGbOAbokJsTAxHJvkCIjZI615OXOryhyd+BY36aEKk?=
 =?us-ascii?Q?TPwJdNQ83uAu9EsAgQQhCNYThmkVQNlYdLvm8I/Qt8bzQ+0tjxPSyezm3Era?=
 =?us-ascii?Q?gYraERFTyv0XmHWNttu09Y4T0BTb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SoojONTslbs7GFptq9P6TONXwZjm7yFliaH+vfmNgea03yihvaqovusisBav?=
 =?us-ascii?Q?Qy61uaVlOQomjPAoybwSrwUa135hnsIbaeGOIicv9GCxuxYvqTCWXlktTTNd?=
 =?us-ascii?Q?gq7ilal0cjRstPo9hNI1riOugpOFJQpW2Afr4Ubdf430uHO95+IXa8x4LWZO?=
 =?us-ascii?Q?knDGahBNccRcgS7PobXAoQf7HBm5iBy3yb1/OeCHYQZxpjraY3ywB0xW7Zai?=
 =?us-ascii?Q?JJbJ8J87O83fWG2XnxjFCHrZ3njziyuePllkRvSGmt8bpqL/3mVGSK7MBL2r?=
 =?us-ascii?Q?Gvpn1+JFE/ODhMgBc3F52mlgJVzTXketKYeIyemsAP0tb1isdN+3QJE1yZLf?=
 =?us-ascii?Q?MAF6KmsS7M3J2OarXVtZtrlH02jwGs616SEK5Xfgw+4cQPigYqD4+BDLEMm6?=
 =?us-ascii?Q?EXwzT3/iK+sgRWt9zI7iz88fjEjTSICxaWkB82x1vpc2XHPvq2YJF3AiGlUb?=
 =?us-ascii?Q?9hMOTpO/CCFuJ+oHS9Gnexx0/x8/P52Y6TJV9SF+5MRSUjI+3hEC8uQRk4QB?=
 =?us-ascii?Q?EDnKh9CqetfmafAO4RjbTMBT4z+fh7mGyxnHluyl5xYQYVnxP+rEdCL4zjb0?=
 =?us-ascii?Q?bAETyPsYhwaCDMHgwxTdemTytnPfTbvDnsQHFOUj0DMv9vyu4q9V/nVaPcRp?=
 =?us-ascii?Q?Vjb/NVzO2Hikpj6sWSIgADGj7Y+PCeN8M1/9TOTdHDBtFKCXyV98vDFlIFEx?=
 =?us-ascii?Q?zYUnXeEFU15p4bSg89bz2nnbtLX2S/I6yL+V7pfU95T8aGk6YClTceGxjxrq?=
 =?us-ascii?Q?RQ2R0NikWoqFNewr3t5/hZs1JBMhvI9D8q04DYePmNBxeypSg11j/Eav5MKT?=
 =?us-ascii?Q?HuZ5LW7fdfXFSwq/qqfeOcaN4+uQrImfY5hV0OfleyhYUIIL/rS3FzbGvxX8?=
 =?us-ascii?Q?KVxzg6ooMQJvk9pafNUDxNkP0bjggJ30QzOmQ/pBibrRS5SF1PQTxlP6zSXN?=
 =?us-ascii?Q?twLv2juiazpacjB5o/vMzPujhz3PV72H0h38bZve7vXrkUkBavF/L6cn/EOr?=
 =?us-ascii?Q?LysNhiT7vkb3zosVtGhs1GkLvVrdWFynoIYD6ny9gOEZx/YvTNH4yke0ATYF?=
 =?us-ascii?Q?ZZDzqyNPu7+zghAG4klqHRPpcN6Uht7yN4dm9PqYG1cDQouRLxVcy/p+KSBD?=
 =?us-ascii?Q?Wxk+PxqR0enbDWd7LxodMBd15Yrt4bxylryJ6+c5BqQBIDMulZBucbljGNbx?=
 =?us-ascii?Q?GAI5U6vyAO5JPIuD4r/xgPnE83MtxwOB25ILbdovtx2ddu0Vd1yk0OhQJRiJ?=
 =?us-ascii?Q?nktMra+59r7zYq23rG693SuINHlqrr7PGe6g0dAYa7FXy9imHWxNLLR9D6sH?=
 =?us-ascii?Q?ClboHYDCl6LpFKudrsmAPZE3MMN6eTEX1lqiEihtK0Ygg4n048JZ0FrG9oM2?=
 =?us-ascii?Q?p79Pegnea+8QARHb8IOk4TcslWZM2IoiYu4HV6oGLn/Isvko/wTg7BcTzgYk?=
 =?us-ascii?Q?mv1lq+Wk4Vm481tDiwP7ZoJU5+yUZbOIAqFl8vdBLL84rYdoI7o976cS+l+d?=
 =?us-ascii?Q?U1CVWUDZXyxmZMQhWy/Hrq/nRnkNDaVlCjNBQY15Occ2+uqcgKUScTmDKFFY?=
 =?us-ascii?Q?KWIbEcBS7ANhAgnKMRdbLfY2ybAfUyEBqMC5evivF+bgRthAoShAzPz5HMBH?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vI9+kEkqrHaeTD32U9Jq/SkBjs34FL4q+frZkyLMdpnJaES2VuhK7KYHJYgLjIJ5//msHCMx5iMNX0JEW2DliLuSmSyDoZDEAG5DDLJqnEolKvGkl2ZihVjoldo19uFIDbq9Z6rJNfsFnWFUCD5K57byrtz7H3BllT3v6L8sQHHsYFtehRfQQpx5tIjRxgWgbSl8XXcO3nVTV7ifJoVsD/xAcmOVTKFjr9aa0NrcXs+3aAV3GttxosxjFREiczkpYcD6el41lsBlIu+2v7MgNMVO4+LcWCKTN8V5l2TXpDFtNQUxks+LZsu5Yhhi2g9r5pd0ak68VVJKKly/0Fj5Pr9LfPiUk6iSWH5eEPvE6X+ThEivaqThvyCHgS27xlj+uVIzUli0b4Dzebu3RHFRGU1Pv/m0zOm1JZtoftosrNzR74ffR34Mw88gZmNXatUUhqePajYt25vXQAqpf0aR2NKfmN4n2OJKa8ZtGnvYRLtfn/249spwoYgv4D4RF+lhCFiwgo11GpBiyIkvHfWfCISp0rYc/JJUaafPtM0QMHWvNvugKk0kHSg2rVOmc4tVdFDdwkbHhjVPtl3lHVAOST44zMtQhFflufyXuQvznko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adfb02a7-a008-41a9-0f17-08dd65bb5e9e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 01:22:37.8445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VTNDkbBYiV0Rf6caYeGR7CbuzrMoBsN/jyTnI7SfamDbNeHJy8wSY79LmzIp5PlkKlA8k1Z9HKvjX8N7+LZ1Z2TeXotjvixFP6jLY7gB1O4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7831
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_10,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=764 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503180007
X-Proofpoint-ORIG-GUID: _mRDXWa02UD_4CX43Tsild3WxeppWVI8
X-Proofpoint-GUID: _mRDXWa02UD_4CX43Tsild3WxeppWVI8


Chen,

> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
>
> Remove the redundant 'flush_workqueue()' calls.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
