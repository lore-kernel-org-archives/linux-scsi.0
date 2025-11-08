Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E36D25A326;
	Sat,  8 Nov 2025 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762622947; cv=fail; b=AYkMtbjZcBF5siBB9kjAcWGh55WlBrK9ghsQiVT6aguNaWRhGAeSqQbwyAQk5MJTLmW8sbdLmtqbfy9fzF1WfqVbMRaTp2qGsupiRIGv8Roe7vhqCMyW1CaSoq4f5JduqLmJHsN+4iRr+90ezcJCjAr191EDPKJ5Hj2LLQUi/L0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762622947; c=relaxed/simple;
	bh=CZ0WM+OA4JGwmjckyqd2z21cdgaeB1bpCkTQRg3Qd7w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tJh7sfpWEbGg2ecm4oRoqutr23C7/5+yJ4+i9Na1oUlnVSl+T3aXLIUs8vQwJEqmg8REgbQwnwtG6xs+FVtsx9GhYPYOp3taI3e5q1EA7T0/rONu0nLFoYRH/oPKEYpX4tOXXv1kPvSTtqXYyIIfATT0gltwlEnLpSAXGwm8fuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aDQPjD+P; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u1gp3sA+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aDQPjD+P";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u1gp3sA+"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HMpqR001626;
	Sat, 8 Nov 2025 17:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zAhlCzjXevlN6Li3s5
	PdESERoHv5sfQGFrV/MLlctFw=; b=aDQPjD+PxT5fK3Wg63sKNLGDngHQS2deJJ
	KY3+g+ihtM0u/MOnDSH++6cr7ASUOzqCADyP/bPOLdaFzBBpSFiM5U1ScLrvcszq
	34AUvfiRV2pevJoijb8Dl08dxiNw4eDWorj12vH1JJ8QNfgstbmXaLcOh63Wd5wh
	H0YltlrBDQe9aEu6qCswWvGSnMZqTZ/dbM9uMS91fgt2uJILJrn41Bm00XiigeYp
	fWYn39qmVw50T/bK0CXnoeUCqGsW+/kB58TEJp9981gOEQ8WqIK9sFJfHKX2ZbTA
	tMoeltasY1bIEosTjWmjwPoZfHP6mxsVLHAVzB2s51AUeAQKtcAA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa9k8g0uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:28:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8FfHgf012740;
	Sat, 8 Nov 2025 17:28:41 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012059.outbound.protection.outlook.com [52.101.53.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaa73a6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:28:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J8VB9v45u2xU+XsL4fRmkVoXYT5MizVRWMRB1TzecDZU8VAp//dEltS3l/oESWpcLk59J7MQcOv8B80WhDYHyAAte20vjLZj1CSIc2vbQktWkZjp6mbDFOlQVK9HUlWTqwz9jOKsp2g/VyNYlrk/+IrT4ccgQNpc/L9NyDu6Ei2Y7bjgZKcHhblJ5qwOzD3VIKY8NvAkeALkWrxnfNd2Ek4sfbOBjEKKzeQfLEF2NMfEkns3wZVfK5+YyHwp+2eb6URRhkVr7jXjFE1xu500SgRlYVDrRKIijkVM2Bx8EqfzvFNg97SY52dAIcdS80ggTcmYgUTU8m6e6MjlWkoHxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAhlCzjXevlN6Li3s5PdESERoHv5sfQGFrV/MLlctFw=;
 b=I6DyC8O8DJv+SgNB5IE9euuk9SXu9xxRU4KtnZ0cy/Yx75nl5P6dkxOECEmAukYiEnKXT5aByBqdIAOFt86o7M+tbTeaBBwxoj+OuocY9Eoj4IoxCYIm9LzDqP48ObCorL48KKStTgABlS0m0YXXrasLbwFYshv7t0cWEbWBtXEI8EX0pn6cyxYBBxPCXKmKxuP19l+fY+OTN+j+Sd+aWnnn66OJnwxC2v4FQx5fIOYIvLGB0sJFgHA10lfV0DAESN+I9OlhXgfXIW2IC6IkmBcKoJ750d563sbaaWre58GtMsPCb7//foeJEcH8+9RRYIzq6/5YiN3CCFb5V6fp4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAhlCzjXevlN6Li3s5PdESERoHv5sfQGFrV/MLlctFw=;
 b=u1gp3sA+4xcyKQBI3h9Ro06Ih2j6Qkk28CtA7eM24pQjCAes2emGK2/46blAUAAzwew/cMNxCfSWK+vfBIUPLWDfjyjkGMtxNgFhOZi/WvZEUiKkrroiavu/FJmUDXdrnW4u79NqERbdHZB5y5Fxe1jbh8tSNQ1/g2/P9uqcEf4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6126.namprd10.prod.outlook.com (2603:10b6:8:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.15; Sat, 8 Nov
 2025 17:28:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:28:39 +0000
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Tejun Heo
 <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic
 Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: fcoe: add WQ_PERCPU to alloc_workqueue users
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251105150336.244079-1-marco.crivellari@suse.com> (Marco
	Crivellari's message of "Wed, 5 Nov 2025 16:03:36 +0100")
Organization: Oracle Corporation
Message-ID: <yq1zf8wigcl.fsf@ca-mkp.ca.oracle.com>
References: <20251105150336.244079-1-marco.crivellari@suse.com>
Date: Sat, 08 Nov 2025 12:28:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0347.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: cc56e658-b794-4474-cbc7-08de1eec414d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QiT7AMU/MTexs6pflp62U7dkk/GpjSQuXojgZiTMEenKAnJXiFMHSFzgGmy1?=
 =?us-ascii?Q?2ZGTgQytlgQ3jX5WRCvq5mQCXPKOn0JjcT/f/i858UdW3CHwDxi+P3AZWera?=
 =?us-ascii?Q?LCUrW5yMRc/MGR5hKZnzVGABND2p+s79XxBL4EsHYMoIToW0gDSNv8zOOcRV?=
 =?us-ascii?Q?eMssm8vVoCOrT1shT9Q1Uw6EM1xtkPfjx0X4JdFCnYWeIvoozzv8cchYgkqr?=
 =?us-ascii?Q?yzSrPZyx6qcahc31Ms/ixeBeoSbRlO+plkqFa5OtUxlzBwbCixwwvZKobN9j?=
 =?us-ascii?Q?9vPprWRisqVhGHsx0fAGGDxvkIZKQ4TOHuIx2/cOUxXJ6WZWUh8glOzmrOtn?=
 =?us-ascii?Q?Uo1bsRhwLdONC7Jn0y3ENXFpo5Qe8I1rKv3eFBSs+dZCFfVDYM/nbzaqspYT?=
 =?us-ascii?Q?8X2bhFTVmo9Yx70aGsH1hmJzfg0/4HyFqFendAM09/X051SJ47qyMBiFsFTw?=
 =?us-ascii?Q?D+wwOGF6SW/7M04oqGsu87Ig4BtnftMUVY9/EeF7nYEEUaxoyNfnAHou1JX9?=
 =?us-ascii?Q?FglQ2EhKYVafShAD1YAeC8BlJHGBJBjDkI7oNtzHPTtgmdFosc9cLEcWQdIv?=
 =?us-ascii?Q?yjOo1zI4zPl4DKFS9+i/WME0ssdnVvX3nTGJzExfx/79oOV0UFGUvJp0O0tn?=
 =?us-ascii?Q?C8iCJB4L/INIoRpPJyUcPZ0Hb1hLmwEZXjpvOp9VFuzGCCjaInyK7qWPzM59?=
 =?us-ascii?Q?SV2uF6QIJA6AGunSVCxAi1WjlRXRrWw7cTOUfH72GovGnPajWHpXgvUh9abl?=
 =?us-ascii?Q?X5faKsC2H6Y46bhLJ32FLu86P9HFUnB+/CfGHCOv/m3NIi3WSHdTtLToXibg?=
 =?us-ascii?Q?fPwvgsgQlKxoxJgCBDidzV3YjhCuaPqbLZgWIt/ZhzHpvx40xdrSyG7Qb2B3?=
 =?us-ascii?Q?YjN1CrJWLcL/EDZXHrZD1KcLPpzbE52WbH8T/PYCqo2esGMnFnFzNh/kYRVA?=
 =?us-ascii?Q?rlVmCjspZcgiKQWcK6s+HZ9t+toqLu32+OL/D6TNJwk2ouB55bIbJrw64+yd?=
 =?us-ascii?Q?uLnktW35S3o9O3ezFT8bA6Amt/zZhPm+NAisfrEPyj5hNeuNCVla8JulaFBA?=
 =?us-ascii?Q?hz5VkDVH1obH1jJuoc0zyu4P8k1Rd+pJg6uQOgFpPkuHesoIe2F1kjoGf4RW?=
 =?us-ascii?Q?HrTeTiiaLwsL10ZMv+kSOpTDWNSwj9Cttje+k8gpHK9xoEkZkIvuAQg3F47y?=
 =?us-ascii?Q?SGpuen2H6ybhuEs+LaBWmL9X//diWWl73n99xKKQEZy11bHZZadUB+NWb3Rg?=
 =?us-ascii?Q?cenLAsKZoMt/HDQmc+MK3bDwugqnILe6dzdFcaqvjveTdBzhYzUJN/CI26sl?=
 =?us-ascii?Q?sU4Xy4Z1lnvEKm1xmcKwXM6trsPcXOrX+Tj8XW/gySwZDV92G3Tu5cDeKXuI?=
 =?us-ascii?Q?gydxMoieVm/rnfgEKlaX99Btk39AezztULU24vKqJhmhMKYwf3EtFZ8n9eyg?=
 =?us-ascii?Q?fEr7KYHrVP/Joi/MlVWd+jhURcRkpNPR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M5ysG6puhoUYFnUGXDVga8Z3N1Y1Zi9nwnBbEIubl1WfGmk/3C2zkae27FFu?=
 =?us-ascii?Q?HhmIb/wohgU/NMaIccBBYJEdr9J4qAnJH/k+CQ67OXrcbvCdZHFPlX/8Huy9?=
 =?us-ascii?Q?ybQgPGK/HS5OZXxpF37hMx/8NIzqk48bMLUqizy9ANydO0pwN3pqCBF4j4nA?=
 =?us-ascii?Q?wwjxlwm06YC4Xi5mcVj+yJ6FprlaiiQcRtj2OvaMWMXW/690M1OBsFXPZfxT?=
 =?us-ascii?Q?QPz3YEAKhIFJ68DNwUSqhQfbDzY4vidOrEZbvydqcbaZQc0l6GKVKW7eHIiM?=
 =?us-ascii?Q?SBMA+x3ZjiS7kiBc1l0qPReIB9B59+nURajxyqydc9b3YirPfZls2FRLghuz?=
 =?us-ascii?Q?cxGA5a8pUeDgjZWUdwTYfovmdQvzclIKdpRkc628Gj+rBPFEnK3lHsjLYWz6?=
 =?us-ascii?Q?m7O4Pfp6Kw/6uwucWoa1ddSBGXOxbIvgBNACICqd3xScQ8ypMkF2MVxiM6Q7?=
 =?us-ascii?Q?Krm1pWqc5wWBmRClk0nK4ogwGXhNCjROdwttZJuIUX/HScX3Dk+onx/lvTnS?=
 =?us-ascii?Q?5wb1gk7ApjKSo+xxvUygvBoh/WoUOiUmMhLyZEWuHG7mY1Irc9d6skUDbKat?=
 =?us-ascii?Q?pTwO+DAZsuSuz2SskU0VlDBNXILdg7zHYgauQ56vPyehtGayPNgBh49wm+7V?=
 =?us-ascii?Q?rrQHDwxDN01VgeYwT/dtRqdZgShAoCxgYJK7eYEcBQKDP5o77unxDTcmVUsy?=
 =?us-ascii?Q?UZjxm7TUJt0mdTEvFDymsGK1by6pyY4ctXGczzsYyR1sViWE0UmsnSeuJwrS?=
 =?us-ascii?Q?3KWrWL6ZxC+BwUD1RKXbxnAKCaos9uEwuh5fKQe3HV57wfZpl9DslHC8WZyz?=
 =?us-ascii?Q?PQ3C1EvpayaMtfxwgrY26sMfHiJIz9pYu5ZrwHa6QfTB8lTRRj2EGdC9p1xU?=
 =?us-ascii?Q?5Onj4DbZ8+KRrRa9oDpiIspEKStcsLEBnWz+h1J8/YYxxM3iA5MsmE6nFDu8?=
 =?us-ascii?Q?gVs1urid+LHUjaWs6MUqn9IJAlETiGHcUk2hH5W64uLLjW3O1fQmVwg4f54E?=
 =?us-ascii?Q?l7sVn+S7SNqTh1dmuBSWCP4b4GHmbxQYxP502juIXil7MNNOlZMSqcB73eHg?=
 =?us-ascii?Q?71/rg29cgv8Lu146Hjn88gLA+Ygu3IIj2RrJLLrWzfA8TJBOilUKcYy5s4Lu?=
 =?us-ascii?Q?TPFhzCyR12yPhW8xpsKK0KTZio9/C91AWR7EECQCK2heHsGq9gGPabKpbKNr?=
 =?us-ascii?Q?76WVMtGVtQ45ClV4bzXqbX3hKR8DpH9Z2erKtxdLRCrTTi12+N9NY5fAcb38?=
 =?us-ascii?Q?fmEknJ0EtG8YywpwSXJoWLFuB1+6ikATZ3cMDN8UqvoLmbi8KMaZM/IIstGk?=
 =?us-ascii?Q?EPd2mbOpaqXFMNWosD2sDa/x+v48wH9tug94RTVwsFrWCcHktf7w2B2Xnrnm?=
 =?us-ascii?Q?Uew4W7ElgXyMSka4ZdSjbJZEgbDP8Nk9QkWk5sltwYNrEl0ulh3X6km+o/md?=
 =?us-ascii?Q?2frQV+A5nKuHjOqzaaGQUQG1tPTYPu5FvwUyeUpnBbu1zPc35BStjeoZrxuZ?=
 =?us-ascii?Q?1Rd0S1WomFO/WVlKE00AR3Vmw77yrOju9C1h2c4DjGj7shROAOETfYwnO3N/?=
 =?us-ascii?Q?EPHY4mpIFki90ssbwG4ZOrYhF/xazhLjuvxWjFR7HgndHBTzwM+/PX0Z498x?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mV6A87uSDGxd57/WboliBbNqCKPdrzBRw6NVmAA2XYaWCljosYp+/fncobyGtf7tviW81y7ZBiXduUdaaesXI+5D8ymr0+37JkJHnPoCdqMMPtQXlGnEdZM6gtRtCPy3OrqjWWdGhMd9T2Olj0Zdrw+9dd5MJ2PH8BUSbn2s6k+OLU9hYPD+8suJVcIzRre1fGW0++E1vjvoz47ODTmfiPZnDSHvri4FyKDSqwf/ttJzkkTFbsbKP88MgVqINitLm0IbcVySZfZtuXeR6rtf7aDh+tJXDPHuqxbktubarOMTIkoeiizaiE3KMVF6vaKHbCQ0DHVwFJx+aPJyP8L4IK8LXDm+BqOFpwKA6W9jOQJI8W9ZBPJULuYar6IAtPNYQZEU4JieVqS/lrzgGP54sAlBhxkOJcue0XZ/ydy6mLt6l5Nhf7+X8X+NRDaz5I7ic42lJZzuAMV0Bsoeu9QYduxRgHT5ERWDnFOK2xLPAvanCA5H9+l2wJO4Yh1GlLl34uhh+DxyWxUM1hHRbwltA2XE9k6LCnpU9YgQV0pijCBOLAQ5TgeR72i0ZaLkdPBwBOKSlVMwAzH/JLY5WR02iF1o5/PHvqTy/GUTOjz2960=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc56e658-b794-4474-cbc7-08de1eec414d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:28:39.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6129nEF40/RbSY8Jw1fYnisb9uzIMtDSJSxAyCwF01xK34L+wS7ZTdfTMaQ88DlCRYci+0eSuii9UWxVt426XBf8MXxRPz531doSF8OegY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=960 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080141
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEzNCBTYWx0ZWRfX62vgwcf9ebcX
 SoZOWk9Y8vHv+YmjAozLia0YvtkGjClpj4GaFVcj/PZP2/XaaPWPqKlxj6sQZCH9V6T8zm/3BlG
 qmS1/V2+AiQpM+1dx20H6voYzKvGkXc2a6S9d0iYyCsXLVbQRSFNTOhdbbMVggF4aFjny5aheMU
 JAu91+JDn3WkGZ4ddyul6f+p8/EzUNViSsirRwVtWHlbxWXGkggDCuoInyVJ67ceqljdNYeHVk7
 kYwVbZv7iKQlkabIbh5ytjNbEwgnDLgQgdy35Gi9dU6OxJxCMUnz0GjpWWr84jsZhJZ7Ep+PZ8W
 4LT+BwgiArhRaukglVWf8hA/CVlUm5cThTfRChS3yWI5fiO9QBs2Bbcl591zU4829mOYMNBzEdj
 o+AKRV97YBUgTIPOk2+zb3HNxwZ6knK/NX2q51WXw4xKOgqCC4I=
X-Proofpoint-ORIG-GUID: vUqf8gvaWObwRQlKc3LkigD3jJlYBW0r
X-Authority-Analysis: v=2.4 cv=U4ufzOru c=1 sm=1 tr=0 ts=690f7dca b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=1UkpK0ZxVwo8KScvbu0A:9 cc=ntf
 awl=host:12096
X-Proofpoint-GUID: vUqf8gvaWObwRQlKc3LkigD3jJlYBW0r


Marco,

> Currently if a user enqueue a work item using schedule_delayed_work()
> the used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies
> to schedule_work() that is using system_wq and queue_work(), that
> makes use again of WORK_CPU_UNBOUND.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
