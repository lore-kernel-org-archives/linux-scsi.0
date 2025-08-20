Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA6022B8B6;
	Wed, 20 Aug 2025 02:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755656768; cv=fail; b=iceDm5BQjbk4cgiylL2mctXMSHA5AKuWXVFWisILY4vHYYx3mLFpyejdtx4R3zyletR3qJrwH0pHAvZuwCcTH9NsYVowSx24xoGVNQwdDcqlODH8fiQK5BBOCx7xg7G7alWMwiSSsSAH/mN5cXtOFlWbpmR2n/ZFY5x6OdQ9qUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755656768; c=relaxed/simple;
	bh=qvFwtnet54Hs1uLdbbCGUijt/je+lL3jXRRIpMeEn1s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HpWfx6anBFJNy9sElNRoRRy1X6L5R0dMAonA3U3Oo2d7a2YNneFFFU00GXP+5BNgXeUcQdG3fUmXL9gyD36MHjoDBGw5OcnLpiz6fKJdSj6lJioqSvce2nfkHGO1sI94H6fSPj9yq6iKKKeSVkGWJxUISwbZ882lkM1CQdjpcXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h5UP+9lU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BaP9fvNi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h5UP+9lU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BaP9fvNi"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBosP015991;
	Wed, 20 Aug 2025 02:26:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8EJN/smScSBrmE/OrQ
	6hVi4r2IeuOXObfP3ywRTmMzk=; b=h5UP+9lU6Cdn3u1Z8MwbhdXv+2tpbF8Mz3
	ob8R+VowsmsyecCcESRgwMH8+YfH98cWJwlSmnlH7PpEUHN2llvV2zD8z4yZcW5z
	7bif0SyV6OkJRcP8j2iyfoCbxT1AdmoZluulgBkB6tdE6PXWeOTtTcttBq//2igU
	/VHUAaaHg7c24GTZ7ri+LsIWG0lc+vcw4t0Gmzxiqab7csFH8ATKM3BHqNd0s9Lp
	2aWwC1udtEFq9xwp9ILuj8ofZrB3//iT7R608sNDLOCh+QMizH4KE3/5P1OM3Wzq
	GHE0+/eOIrJ/y1qhZTI2fiKJy0DCAvpykCJ32T3yc+Z+0TKZbwPQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ttga9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:26:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K000j7030286;
	Wed, 20 Aug 2025 02:26:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3tc2vk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:26:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PG6mwXjSu9QCSt06+ZQaRsSZpYy4EO4q2xxj+Hdk5RJ/u4eZIsz9PHnQTdJMzMeGVaniGKbU17VDmAJ+LZfn6LOJNM4xMBKLUStKHQDmb3r7noYKHBJevhlm7xFbAHReoASWGPhgAYY81tL8g43ORsWs5y1FIwRWGvLpNRL32RquOd3yw/FvgYCKZ7O2KN0THsvGXVuWV/ueuEz2EwF36kRgBrd2AH2uAg59BW8Ca4tU0Vpo8H+TPhWCKbt2Et50JzgFLOjvSKrDziUtCnw2Rg+KFsYBh3dllXFsgp524SzgLqsTAlXS8JnmMrgQDMrCQpTOaBonqyIrFDiBsbSF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8EJN/smScSBrmE/OrQ6hVi4r2IeuOXObfP3ywRTmMzk=;
 b=mLE257fb2cBuAzAQlGKyShk6rXxIuxkKr6aUzGo7HIuy8cL4R8fq4iqaxz3r1/hNVv38UMjwAQO8gi1GmSY1mERA5uq0dbzrd2gQT/XdXyMBrKjnq1GzsI0g6g/RdVfiNiqBDKNZDEXnPoCVn2TXovpt26n5O2Y33a5C8AOlN7w7R7MmGoZuva64sHyH6WK0VCS8uI3HsI2N2ua3F3tPNx8FZDA3BN1VSnz3jhza1qjm8+SwEh6+/K+iLFP2d0yIayirIW6FTn+bsHBJO+g+VibmccQ0eLPa+JihwZUQGFJPVgcqWmYlJzmmT7JyvNFeGjtjkURGYeLHnMHnhwcHkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EJN/smScSBrmE/OrQ6hVi4r2IeuOXObfP3ywRTmMzk=;
 b=BaP9fvNi/gJmoUXEIwZ6otcXzMzJmb5uMpGHD79BmGKP9rYFqZA36l0ri7xkyTcn3JcdW185POeSBZZOuxUAfW8kc2iItouL/p62Cu/Sioz2IauaNHrU+JqgUa9hWVup1l9nSgpD57SBWo9nL9qgCIhW0x7i0Wj9Mq9DNfP88zI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:26:01 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 02:26:01 +0000
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: James Smart <james.smart@broadcom.com>,
        Dick Kennedy
 <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        "open list:EMULEX/BROADCOM LPFC FC/FCOE
 SCSI DRIVER" <linux-scsi@vger.kernel.org>,
        open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] scsi: lpfc: use min() to improve code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250815121609.384914-4-rongqianfeng@vivo.com> (Qianfeng Rong's
	message of "Fri, 15 Aug 2025 20:16:05 +0800")
Organization: Oracle Corporation
Message-ID: <yq1sehmvidv.fsf@ca-mkp.ca.oracle.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
	<20250815121609.384914-4-rongqianfeng@vivo.com>
Date: Tue, 19 Aug 2025 22:25:59 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:408:e8::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: d9bf1203-679a-4750-9198-08dddf90e790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?isvi9Qc1SK4i/XsPCp/AltOxaBRx/faf/iPOX+Xtg3/rnxUNw8mVbof+SzrL?=
 =?us-ascii?Q?jMORgpD1KNEhGnwOBlErUGyi/rrajDxC0VrOw+HXVR0RVHoVmrJ/+31Ylpd0?=
 =?us-ascii?Q?eDcC1HZjGHdz+lIWUC6lyZmwzJu0O4aUvCAjKIvX6qS5PFLGD6T/tizXj4Ya?=
 =?us-ascii?Q?fxOSMwSriFVZFwvroV0U9ST+gsWboB/DeXHHgZqRQkgYqU9pA25RMnC5e+ce?=
 =?us-ascii?Q?aU3z5rlwFUiBsKCaYDXtFFa8mRqHHz46hkfNZY8oklC7gd6iuZBp+SvAhr1T?=
 =?us-ascii?Q?I3uDnqAeQ3yPYVSBKJ28qc2KqD+IVoLXZ+8BPJzXvGvyWzt3uc3iJaJieoBe?=
 =?us-ascii?Q?K8borhoDLADRE5kWk6UXEToOW72GBvxFY2I/SALv3hRc1JCU8PQmAiqR2AAE?=
 =?us-ascii?Q?OSzLFeh0P56Rx88Vjna8RdxYWRP+weIq6GLpO1O/oJmSm/zHlbD6Z3joj1Fo?=
 =?us-ascii?Q?PRM2UU4arngy9p5dmHerWL/YlhI/5KMXO8mdl/AR4BrpJFTSRsoys7ETvCQy?=
 =?us-ascii?Q?ovaTTjEbud9/BbEWwVLZJCXl8XmVeWUHte2zWpKJVpD0twM5CsXvcVq8qM51?=
 =?us-ascii?Q?ccFkAZvIl3w2vDn9DRa3u96oZWcZ5cCECkqjNd4AxYfwne8AZDc/VHTd0dnx?=
 =?us-ascii?Q?y+hDkRUminV/ga/jzwyEPzrOGxCLSxQW3BVa/W/zY+TibMvXlHFYRXUfE7qS?=
 =?us-ascii?Q?cBwC7GUn8ftbthX5kXMctp62HbLXu2wQbbp/fv7YBqMy+2/6kCz6+OAPuETm?=
 =?us-ascii?Q?//u06P5h3i7t7UYUBhbwqOC85nIH89KAgThBFgewoFFWsjFBP0mhN4ksCxfg?=
 =?us-ascii?Q?RsJSUL/PmNgwqjZ6V+kArAEdqT2TcpIU8BFZU00ytNhadlHuJ5I708nS6Px8?=
 =?us-ascii?Q?wrf5dKerMXQbWsSBz0PDxg9s7vwdfQR4hLqPij+29QEd7HJ7+A74YbCSzfyr?=
 =?us-ascii?Q?i2+ni0zBhKJw1ayfbAgQUnZBYfa4mKZTc+sY+779Y0z/EemBHpvrfiObcthS?=
 =?us-ascii?Q?AQwOAJGWYzUcJf6HnfJDYEMQcBKWG5GZAJOifRzEBFO2toFAMoDoub744oRl?=
 =?us-ascii?Q?ib1fscPRwOx1YzzSIdSYBlaGuVOHtS8MYYHBmgeYAkz7K+T6h6Nu0iQkFK9a?=
 =?us-ascii?Q?jb/7XEgGJ0PPfprxZr8iV0qlE3TOMiSp6tWf1e6n6utfZZdHwQzBWNVT4qpP?=
 =?us-ascii?Q?VMsri4TiJt/Q8VhHcxrenc2OzlAURmxO0eOsTPSeNfjP4+r4tY8juBmsBITG?=
 =?us-ascii?Q?tQRUnsmDT+lylYl6nw3LVOwQizYK1RHr2QgjB9YO65s/xPZif5P9YqsvwbZg?=
 =?us-ascii?Q?AbZ0bA2Iau1kUS89kWg+JrghGj6TPXx/LUZgJ97Stu4DSDTQpKqQicH76emy?=
 =?us-ascii?Q?L+sVgOhxZcj9Q+YGqH6/SC34Iiaj6Cw4glwMnbyMUtD69pWw46oVGG5o1Sw/?=
 =?us-ascii?Q?wrkCkxp53Es=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y+iOc4TI2zd7YGnqY2Nj7hY32yUSr2QXVkZcMv1STSXT2PlX8S6TvBN2UlFa?=
 =?us-ascii?Q?SxoE0xATrDTDNfLtOWahl74rO76HHhevKVAbDh5RKZ/lxnNXA6IXryxILJoh?=
 =?us-ascii?Q?eJh/JgrIRSMDR93ZcooR1sC1lIApOmC4qj2ioXKVlY017OdQDU5vAFIaT+6s?=
 =?us-ascii?Q?erY1LdxXiex1ag8u81VrxqZXjYOY818vwMzX+udzHe1En/K2sMaocPD2ae22?=
 =?us-ascii?Q?P7B6zGrhwn8rLYSCwY6i7AFBhF0GNWwGwOnI7ntHtLX8Org6GWx7KXJNaMnz?=
 =?us-ascii?Q?JZOuids8dcwV0LJfRicgKHAxuLccWMJ+ca+tH8dB9loFnHLAKXuMf7BCJTMF?=
 =?us-ascii?Q?1L++qoPIjuaLRrXwqcbDf/xZX/z3tcg7mg25oPfHRinVjJtIYuj3BKw5E1oQ?=
 =?us-ascii?Q?Hs03iwZqkKjz5Ym2+L/pSeKgyNE5ouvVikfb3lzkxhzw5n5D0e6g1UltAxIT?=
 =?us-ascii?Q?FgampGEAgs4uFiqAJ2jifSCsMkJ2SurbiVHew+km0hjZdqisS0a0bTMrhlmQ?=
 =?us-ascii?Q?XWeDz+EARBXkiD8zaQpH6kivCq+t19TfLNL4Qp3PsRJ4+u4Q7up0gkw+SKQp?=
 =?us-ascii?Q?HA8SLV+QX3eAxDxYwDMP67HGtvzRa5rPhNtA98oitX0gWtdyiML867Ioj74v?=
 =?us-ascii?Q?3pzEbRLw4FQly8xnb1vnRfoqg8e8Wq6vAANTSpGj+3LtTOEd2mh/4BT7vk6k?=
 =?us-ascii?Q?8ao7SAQJcksi26a5hy+50OIUsIVw8DOCvSexRZTqIGIhHCidQHwW9I6+6Qn6?=
 =?us-ascii?Q?DRcESFBK94pYoH85QMVwhVej4qUdjwmVxTq2HJ8IF7Mh5ypDX5CFCdqCGtEp?=
 =?us-ascii?Q?DNNuZz22XG7BkZGr+/11+LRFImh/69A4ljo4bsnC0ZAfQN2VHZemmL9OokQF?=
 =?us-ascii?Q?xSFhYObPc+pyxqgTKN2y5WlY9YbO7OdDLtFc562VT/9WeAHS8VBOyz9xUjQk?=
 =?us-ascii?Q?WDFBxInYUrkEQCYSkE4ZI93dJuwlwbn5eOP+f300pojFYh4hsqbRb5Vh5xIc?=
 =?us-ascii?Q?ZZl9YUexgF0CU0miiOQ7sIwv0mxpis2CzZxPgjmomLrb3nPThdz6/TclkwzW?=
 =?us-ascii?Q?K5KlkV7CEs4jOYsUfRADdyX/YdpelLnS5D8MAC8vKXhlLOHQSY2I8Nt4lZum?=
 =?us-ascii?Q?PW9WzNBZ7rPi4+ckuk4B2symOLpyAEw4U6Yb3nG0f9HKQj0Q7C1EtxswmHZt?=
 =?us-ascii?Q?ChKVs8VgjOzVXGKHSxuN30/GhdvN/CnRio26S6uNkMKQu3JhrfHpulPaTA7F?=
 =?us-ascii?Q?G1UvuJ0TedF2wwJqUNP3e1wB9AVZjTn0Cr8nQatwv0dKBr25HrkQ8v9zkPwt?=
 =?us-ascii?Q?3BUUGBiRUGqTh2+gMjue0RRuny43AFwpXB/lpv0CF5Fhb+yhCFwTl9HeRCRn?=
 =?us-ascii?Q?1btBt/e+O/vxrHOrjRLfDnIEp4V+eH2iek2yLZeD5HMI0x/SsVorGcKogDR6?=
 =?us-ascii?Q?Fv4l8QWLuvpZAByEAd8CYyEnHWzfgvCdBBGOIeMvfuMVoMrkMw0ZFG43rIJW?=
 =?us-ascii?Q?D/RluP7tUffLAyZ2OiPdck7ToCGGfHIWx1jEIKbeBWJDKGK4YXQkCpmr7rjc?=
 =?us-ascii?Q?BkrCM8LbnP47UKYVH49vfPCL2VXxBfRxNIsZI95FWJ62tPCA1cbivgkD25lH?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jLF9Aaz5giySi36Mh/atBXgJPXasNccHEf3AIXsZ3KVh5nSYnoZvhu0UVeQTU0ndgJLvm6e3H+yPBsd//Jfphem25zKaw1A43TxnGJ6d6jozDF4ILeqYhU4ylNwchDBOk/++AJbM8GQXFbSv0MdZnciX++1igK7BSBsbRRGdMS4LZ25Ak8Jo+iuq5jDJxnkoEGmCtTuBP9RlfAjJDPaiS7icMOABNJX1Mx4PVq2XzqnWYEOIb3DnOzOXr46pCju4Irqek1+C3ojA4T4aOW8Fsc2yVmJ5HkPp9qegPCK0uRIfOG5avAO5ZWp76jdavJ3Z5emZKXXlr5XNb5MFw0JZTfdrhQtJnHIwYQfcK7kGZE/5h8rpNVuhvQ6dUC4RGJ1w0+dEx2xfBpVMZi5caeF7u/LW23iZurBRMaxohYGSINofOrg5LLzK1vmjte89j5wC5ZAemR/kRDVxokt6OhsI5p3UIv8kMXADJ5RRhHobIG2UERIsXkU/wNHpSxe/e77osINcfNlN36eMZxbJcvUWNXLIcz1ca+vUmarfzbanWX6KioJ1wYFKh4SlW81UtK86cMAVvGkfVwuGwTZz+2pLBoBHbLy2EklUVWTWqUGW0pE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9bf1203-679a-4750-9198-08dddf90e790
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:26:01.0932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91NYhtEL1DoA5Qp3l7PQf7rGxYMU3e6XwhoR1DxjW67wIaBcWJcnk1ESvDxcltgDNqmeWbmpC/8K02ZBjuFWS27j5K6wPril9vpIe9esBQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=705 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508200018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXzWADNaxanK+W
 bfBORWQumwT9kI0qB5v8SE+mt+q4o2kttx+8gyZM2eNgaAei8d5gmzvvWtiZrhVUnElnG4qdUig
 A4bi6zN+HVh+B7YAwBvMJb2I/0lPRZX7203/SQQY+5ruYBpga00PgRg6IlDSbG4dK7omkClrx++
 YEgtxITPKzYOq3/QCk6KTCsdCvKY6akHb/L4YZgBr0T2lBYuqvAdNBYdh1xOrhMMxTJTcnd7b/z
 VOZJCBUZAwIyAdhviLMRtXsLIw+rYWsLbzNfTNDRISFpzuJK9UvXBf5/FbSBdWxI9PseqBqoGUL
 adQsCH1uc4IPDFBpAgnXBEanE+mfKrfoJeDlAjjzgAGVmNjN8rlsOTlpg/Uk9KvdPO0X4EVRub2
 3S9RLhCPVDnd171k000VXXqXwgsjY6OY5nqat7YwZzRfALTipGk=
X-Proofpoint-GUID: _b-XpeKj2snz2PGX8zopwXpGx_u8oTMG
X-Proofpoint-ORIG-GUID: _b-XpeKj2snz2PGX8zopwXpGx_u8oTMG
X-Authority-Analysis: v=2.4 cv=V94kEeni c=1 sm=1 tr=0 ts=68a5323c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 cc=ntf awl=host:13600


Qianfeng,

> Use min_t() to reduce the code in lpfc_sli4_driver_resource_setup()
> and lpfc_nvme_prep_io_cmd(), and improve readability.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
