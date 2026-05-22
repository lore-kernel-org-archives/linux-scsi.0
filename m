Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D49F3C5528;
	Fri, 22 May 2026 10:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779444698; cv=fail; b=om9t+r7bNM4kBMoJ8rR0tUa0689fH/gekM12Bu89OTBhulPmwBnSrZI5BWtNhGh+x3nGH36wPTW/UA8BOe+nJCyPeyCarlrYX/r4bJB7cxdfXIDgF0G3qGfkj+7YPvuDRPvu3M0hJztqnN+QWrM+z/p7CZ9aAu1p8nNP9ng+XRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779444698; c=relaxed/simple;
	bh=qKdb7ge9b9bw3AlM5NGtslka7gp93JcZAJBpxMzIO6E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ObkDxrxDdGXUPEAnFstYrkSp9XLl9C/uA1wm1nb6geZla63HZCTT4bPtU/f6XFNaCD/eCgUIbbSOlRWandceQE7oUyHrGIOOkBYErM78FTuub2y85RmHe/7TiIofwJtLryeCYHLIVNiRTkwJj4eLuafVJ8xqm5QXnTQdfGzWDq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bbfWg1pX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BZglEVmJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bbfWg1pX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BZglEVmJ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LJfbYi1933370;
	Fri, 22 May 2026 10:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=delGtPrUR8773Q5qgFAwE9598jgCcSuU8m1E6/NkhX4=; b=
	bbfWg1pXx2fCNOzoUEbZf8dbfBwSJluhlDmNsxpKHgZLk0pw4//Qqf81cim+DPVS
	iwv+Rx3tMuIRxky06mn7E2G11oMfZk3Ttlt+YVDvFm9RDlrnVo/Hw2avjiKrRLKQ
	qUhtBK4Xq438liTA6yhbDVHc8/Z53v3w0KX2CV8O1i9GFJ4Afs/4kJLYQJo5cOLA
	ymqjqRUEjFACOM9PtxyI9X43dJts6VheCu3xux8bvTW94hqya3CyKztcQc11M5Nd
	me1sV/tqKqsGqRyNZEuoI4SI1nHai/Fio8kJhrvXWqUopVMMVl74B4VDnmtsuZc4
	YQZEt/khsk7tYjZxhGfaYQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6gyxaud2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 10:11:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64MA9wK2037752;
	Fri, 22 May 2026 10:11:21 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e84egae25-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 10:11:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fNV3fpFBGcLokwM/jgLnjOU20yX9y9aGbzhuB2lGaZZ49aRm1/5+wrITrcjwiNMDseiQJzVbtdXnULYmlslumRxax4HxCpWzNQgehXYGZxpFR/PiVkD7oOKIEszRyGS07ch5iPuexyIARvduN+7wHoVUHHd8JhqRmspBHJ4OUuoZ3hVUoygpWv5MLFLXOFI0Xz0WYw4pGHzgC0wHgLrii0EFGe3O6aPfSU4JRIvyj+0ib0ARzL+lXQH9MwdrpQwP0nSpvroUnHH+P0/G0LYWsq8n/e0dkdQ19DsAleHDgqTi3UzmR4GfnzIIjtdpTuc3DtDLOj5QGFwpIpBcidIvvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=delGtPrUR8773Q5qgFAwE9598jgCcSuU8m1E6/NkhX4=;
 b=R5WZXUyLdoLe9WIVvPaUypqTnOJLF0bhzzl1Ag0J3tOQwCDBtZS7a60oF7TDJK6plTAejZ6hqnp20gC216bvul/xMsjtGUxteqfMdzyiTL+8C2TKOvNsvbrh+9Vo7P94gvKQY+6aOBWCsjpSHSO9MX6+/uckjMhqb6e95T5S7himvz3Nu+XIyViL1LjO/gn5U/6ehozcWulzb7jahCOY21F4fjmyVbb1FoDOfD3EGx7yICUFzUx54eilXkVL2cDWRfrIw7wqeozFrM/PZ40ZiyxlNcfVVrBFJR74arsTetSzCywj7AwJPF2+cGl4W8Dl7kkLUNVUMN4yI1RWbvKtXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=delGtPrUR8773Q5qgFAwE9598jgCcSuU8m1E6/NkhX4=;
 b=BZglEVmJuEt2H/Y8yKMA7X79oiZ6fQbEQlVB5PqlWaPNjnX8kQIu9Q97JMcej5r0ym9o+EkGVvGKpOlf0GiS1t/6t5TrIyas8zP29XYaO/v1eUoeAXueztMcvx9ZC7h6E2HbBdS2td+6V4tajT9kraI8NzofFr7bEiqyVnkdLJg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA0PR10MB6769.namprd10.prod.outlook.com
 (2603:10b6:208:43e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 10:11:18 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0025.020; Fri, 22 May 2026
 10:11:18 +0000
Message-ID: <30167a58-371d-4a31-8736-561496352a8c@oracle.com>
Date: Fri, 22 May 2026 11:11:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: scsi_transport_fc: widen FPIN pname walker
 counter to u32
To: Michael Bommarito <michael.bommarito@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Shyam Sundar <ssundar@marvell.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        John Meneghini <jmeneghi@redhat.com>,
        Bryan Gurney <bgurney@redhat.com>,
        Justin Tee <justin.tee@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        David Laight <david.laight.linux@gmail.com>,
        Keith Busch <kbusch@kernel.org>, Kees Cook <kees@kernel.org>,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260519190615.2761667-1-michael.bommarito@gmail.com>
 <20260520133015.1018937-1-michael.bommarito@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260520133015.1018937-1-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0109.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::13) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA0PR10MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a6cb2ca-8733-4700-523f-08deb7ea7738
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|6133799003|5023799004|4143699003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 /xcbAKlsUSibeU6XK0FM9RvPvmYaGGv2ijXTVu7arz/hOqglkhh6F1F532qWrb5ih0y90VrjOIcltcSqcBv0GvndaKOAFLcqWVIGDqkUQA+xAyXNHvn9p/6TZ+nR1K5+ylp+CVfFQRqviDa1yEqLTbgfHrzC1jVqzYDYujVw/3CI2IuG/C3IdgSEFMDOsF8Q8HFB2msrm4gPNKiK2ykTGY0uxA9+cKDS15aRZVB9AEkxa9K1RayFctMwSNW+Wh1Trdut0Vi5FoKZP3dQpXUwZyYnVc0923abiaNR1Lv1DcSTbYyEO+h8jTAnusSXMXqv/wIOoGAqzJ6V6QapF7AafxwQWxtUjKH5St1+fXZzN8C73Dttpr8eKmuSJJnNg/FqlWR686e6AoTZKndFVmQYbeZcZJ4U7el/caW/g5DUQqlQzO7tC2wN5DkkuCt2Ht8zWKpQ7fT92cjHHFGz9BrwRQ+cgi7yDIxX9kO1EvWiqoViYTk6aAynvTPYVLCF26B8u/6Lfz411b7PUaTjxqLNk7P99BcHm4O4fHhVXNlLoPqYtDnbgn+edcZ/tsJp+Pc5Vu1aR4hedx+pcyZfzdC5VTt7iE8E/DpJS++fBWeZbImxwjlI2giIkgn99wZlK7pwWRzFTIvK2UUjqWlM/JgT+PnhuXLi3yrMHjf5TnTj3BDqmQpyEJiOZjMhw5lBiFBM
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(6133799003)(5023799004)(4143699003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Yk1pVU81T0RJMVk3aTVDMlA5R3lqcURMQytCb1V3ZmpCOCt6MHgyZS9PMmVD?=
 =?utf-8?B?S2piKzl0ZHE5T0hHWnRkU0lzbit2Rk9VR0tZTDJUTUJqajZoQzdkamMyZGpw?=
 =?utf-8?B?VXgyT09wOTEvRzQ2cVVDbFdsaVRBVnhyUENpSDJRMG92RGV6dzZuZHpCeUlx?=
 =?utf-8?B?Q051Q2hWa2RvSDhxaEdQbTdydGZOQjZsK0NOSEdhR2FQemhkbTh1Q3owSExx?=
 =?utf-8?B?OGIza1lQTlNKQXFhcnJqbFlSeldWNUhvMUFOVHNtaG1ocVdrdHNQR2liY3Y3?=
 =?utf-8?B?dWV2RVZQSXh0RGZ2OHp0SHFnYUtNYW1XV1pMc1p2K0UxMi8xZm8yMlJRdHhR?=
 =?utf-8?B?OWFRLy9GTTZPZFhzMmVuMTB0eVc3NU9lMWdibWREMnFtazBJWEkwL0xhYUgr?=
 =?utf-8?B?SmJhREZ2c09rUEdEdzcyWkIrWlV5YVpJSHVib25USzlOK3VJZE1vNjlTa2VZ?=
 =?utf-8?B?aHRpMmpLbFYyb09VTGVHbDVkTll5YjFiTHdZck45THh3TlhrQVlGQ0pnOXUv?=
 =?utf-8?B?RG1vU0QrYm01RU03UjRoVVUzaVFtajBLc0ltQmttQTdnSnFiQmd2TWtIZ3JW?=
 =?utf-8?B?dVRSdC9VWndYTmIrMEpaZEZmT0RXU3FvdmJrZUJRQXFmdTlPZTlsREk4SkIr?=
 =?utf-8?B?bldqbGM3Yk4yNW12QVN3YWd4d2FYVG8zYUlocHpINHUvT3dUeVgwZkdnVGR0?=
 =?utf-8?B?QlUwTXNkZU9wZjlBR245QTdSUHovbG9kTFc4NGowRWtnbWZKQ1F0UnJjNnJ0?=
 =?utf-8?B?WTVmSmRaZXJCaW5abjM3OUVXekJqbGg0Ry9UL1hXMWlFOHYvNE1pclJjbGcr?=
 =?utf-8?B?YzY4TEhXN0d4cjZBV0FOYzJzRWxuUVd5RitwVjNUNWxOMG5pM09FNmFEU2RQ?=
 =?utf-8?B?V3NPakloYlgya3hxRVJIeDQ5ajNEeitsOFNISzRTNjZKcURzcG96RkYveklF?=
 =?utf-8?B?aGpEekhTSGtxaHNFVFJUQzBLL0FqNEJWK0NuSG1HVllKZUU3RGtDTCszaEpL?=
 =?utf-8?B?ZnBNdy9MUk9rWW9hYmVmek5JeWhrSGhOSkVTNjF0ODc5UDNYRk1uR2VJa29i?=
 =?utf-8?B?NHYrbDA2OXVYTUVUS09TdW1HT3kzRzRpVUpUUkM3d0FRbU4wYm50WmpDVkN0?=
 =?utf-8?B?d3JhdW5IRVlZcVM4eFhCcVdydEM2clpxSXc3L3lSOFZKZUtNL2xRaTByeVB4?=
 =?utf-8?B?R00yNDdvQUdnd0J3VjBhMVhYdjNOS29XZWNzQWg5VGdwQ3FiZkZhN0lJOFFV?=
 =?utf-8?B?ODJTUmlVdnE4VWlMYWZVTThseXYyOTcxVHhrV2JuLzJuZFMyVW1IVlYvbzE5?=
 =?utf-8?B?TnZQRUhOTi9OUVhndkVnZDlLZmxQL1g5YWZMV3VnblJpdG5PMVVvRHVYcGkw?=
 =?utf-8?B?aGtmejN2ZStnWXhDYldYRng3d1VlcFRaNy9QT0ZWQmFCMDBtMWhEQlVjRWJR?=
 =?utf-8?B?dzVjTWtVSVBWNGN0K1VuNTFraDlpdzVSbmlNL3l5Zk1MQXNQRzdLQmlOZ2dr?=
 =?utf-8?B?Tlo4NWtJUUxXcmdHMndxUGRJdm9TMjdKaml6anBMRndKQngwVFFxa3huTDFL?=
 =?utf-8?B?NFhQS2FHUGtNWEw5SEI1SGMxSnd6M3VKdUk5dEh6Z3lvSTNCcUFqQmNKTkpJ?=
 =?utf-8?B?SS9rUm5MY3VtRU44aEFMOE1ueTFJSkdJcGZuNFN0QjM5RStGNXl2UTJ0aHNT?=
 =?utf-8?B?ZlFkdVl3bEYySXY2TDltcDR2aG1kM1hzVUpHQ0IzdWNzN0s0NnNtZGdZVW1P?=
 =?utf-8?B?dUpRZyt5d0NGMEVNTEhsWkdYZW9DaW9vWnZieTNSUkZXRU1rYTV3a29Jd3Q0?=
 =?utf-8?B?cHpRSjVtQ2NvckNBS2V1dGxRaDFoblFnMm4zWW9vSnRyOXBadkpBMEFQUTAx?=
 =?utf-8?B?TjBuUk1RZlFWaVcvOWVybnA3aHh6dTcyOGtmbjlKQUNqK1hnQURiVnZnWlUy?=
 =?utf-8?B?TW8vclBzOEQyS1J0eU1UWWxVc1FGbUgwbTNFWjI2cVBCZXByYzArcEZackxS?=
 =?utf-8?B?ZlFpeXpwaDV5U1lVZyt6Mk83V0pWYy9zN1N5WDNtQmxjSDNxL2hXcU9nOWVT?=
 =?utf-8?B?cHpzd3BrNmljSWp4aEJsZnMvT2JFb2Q3QVNuV2xGYWVrd3QwSXgvc3ozWmdp?=
 =?utf-8?B?bjg4Q3ZDdnI0TStQbFNQVWRpNHc3Qkx2V1V1OVZXME1aVG1LZVBaUVE0NUV5?=
 =?utf-8?B?ZGdETkpGcGFlTWZrY3pzRkNrQmNuajVIeUIzU09FUkRUdEpwY1RDSGczaEY2?=
 =?utf-8?B?Vk9nUWNleTRmS3VjK2R5bFQvYS9QKzdHQkJWWU40K2U2dFZxdzltR2ppQjRS?=
 =?utf-8?B?MnZkZEVhVHRqbFZMSHF4SENRb1RMM3dzaVIyaWQ4Tjk5UTRxQnEvUT09?=
X-Exchange-RoutingPolicyChecked:
	N/PN4EbdLI1y1D3pR2MafD0NpVSBW8OMY5fJsz6r6iuPAcnJmQ9Sef51qxvvpdMzRCdQ5cLliIOhQTHvRdzZX0CfG4EgtSG6EPQ3DuYSYylW+4y3Xus/XNssUY+1W4slE0gq9gt0v/mxDw+kXKg8W7iDx28pfsRum+DNP+R+VH01miIZHwjgY5BXBgH+qOGAkHa4FqgC2lQTy8l7CevGtchVeynNWnGBZ6kvcijyqYwmJXp0GBb3OYBfsGZ4ccw/KpdAFY5TxJmZ4NPzbFdx8hDMF7dcDfF+m2LXvM5dEpO9urLb1qIKP33ILvCP0QzwryfzqQT0QBxcq2iNCAbTHg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tsa6XGGfps35r7UzXoPSxqqi3YndappCVrhlzjGPHgaTAK7/4e+/MF4V5uUhk/BWydCmubUSdDxqiJ9ZCGm+WtAUmt/FZ3CMvzU3JmF49DQJzUagZTovJIny8fEic7cWjxNfoUVKnJffoExR8daS8ZlblqIymDf2w7JMceNZkXkdWPg7jTkQSJnxuvhEnOUGZMq30LbuRgZmOksyVz31HG1zTHKJFzrYZy+QEWLqS8bKWxFxSPgDtav9+BT8ve60FTiTdp9BjOGfvQl9dxBAMLL4YsBo/NVGFYgEki/s9VPRQyI7rC9VTBAzgrGxq14VBQMdWi4lA4lfHY6kthKXiBqRSz8F8NuoiuseTXwalyATsZZPeak1z9aB/b86k3op4jmcbj6CDLDwi/6/7TsaKwOCpG96Imllkb+8jmPv+1ls1YVAdoR+a/JMCNB5kCDP9/xNMMpK/0xvmvtJXIAPWCN8vHROK1MXmluCQt3i6/A8vkNMt3PL3mFImiH+1HUBnV2wM4OdWP9X/Q7skkNJrdpxsNuG2UoPqxGQQ9IG4nupnE7gQOEaMMcIuLXUXY+6XAZlo0NuMqenXj/PffwSvQCs3UPN0d8fj8y3VzuciQc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6cb2ca-8733-4700-523f-08deb7ea7738
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 10:11:18.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPzAiLK47biNJlRPh6pTbxnzHOH23jdMpF6IrTJewqFyLe+8sRB8UNXH32yPUqRpVbzfIKr/uyT6dBWR3CxVEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605220101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEwMSBTYWx0ZWRfX6sttf7TZDr4S
 BvdbrnZFoYCz6gqNy6C/lWg8+urTkoKSb2GjRuPVCYbIU0B4BX12tuRo82nItZxFgTvETTXdoDk
 jbvX8JiVe9FeqnqlYEOOGiL2dDE4pfMcFjpVmrZh3QWrG6GfmplF4NdkAgUTgE0DcTI3C0Pv8dc
 TtmJACNyRuWAC/sXF2yDf8fRvVfc3SqrBzfLwzl7L9Nj4XcOPfbEWOYRsVaICvtzP4WHfPRErYU
 UWry/q6w5BbgJMJziA+MYDtVCXuT2EYGAH0f1LSOgDKfZ/+QD/CW0PNzIuXrSg5/OWjXtLpeZW1
 DAygs9Ch6P9v6bvYqxeHwCo6DzHTB1pIePLi8QqWaUlkhUkbbeLinm8rwCvug85AJgnZD0wCYx0
 YZ8XYuR4n3vS8WqG/lrkWpeSSScDJnn+1Uz9wuoaq91qZWp12QU9OwjxWqud2ZKIedA8ayuEKrt
 jtLqLKN5RRkbK7qEeZ38TKUYUQhgs+fGI7+RSbWw=
X-Authority-Analysis: v=2.4 cv=Ls2iDHdc c=1 sm=1 tr=0 ts=6a102bcb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=eRdvOwO65NWgu67WTiEA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13839
X-Proofpoint-ORIG-GUID: trb9wT3MBI3HYlJ2QXBp-ZNPWEyilKZG
X-Proofpoint-GUID: trb9wT3MBI3HYlJ2QXBp-ZNPWEyilKZG

On 20/05/2026 14:30, Michael Bommarito wrote:
> An adjacent Fibre Channel fabric actor that can deliver an FPIN ELS
> frame to an lpfc or qla2xxx Linux initiator can trigger a non-return
> in the generic FC transport. This is not a local userspace or IP
> network path; the attacker must be able to inject fabric traffic, for
> example as a compromised switch or fabric controller, or as a same-zone
> N_Port on a fabric that permits source spoofing.
> 
> The Link-Integrity and Peer-Congestion FPIN walkers used a u8 loop
> counter against the 32-bit on-wire pname_count field, and did not bound
> pname_count by the descriptor body already validated by the TLV walker.
> A pname_count of 256 therefore wraps the counter and keeps the loop
> condition true indefinitely.
> 
> Factor the shared pname_list[] walk into one helper, widen the counter
> to u32, and clamp pname_count against the entries that fit in the
> descriptor body before iterating.
> 
> Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics")
> Cc:stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Michael Bommarito<michael.bommarito@gmail.com>

Regardless of nitpick below:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> Changes in v4:
> - Use min() rather than min_t(u32, ...) for the pname_count clamp and
>    fold away the temporary max_count variable, as David Laight suggested.
> 
> Changes in v3:
> - State the fabric-adjacent threat model explicitly in the commit
>    message and clarify that this is not local userspace or IP-network
>    reachable.
> - Use min_t(u32, ...) for the pname_count clamp, as Christoph suggested.
> - Use FC_TLV_DESC_LENGTH_FROM_SZ() instead of open-coding the descriptor
>    body length calculation.
> - Factor the duplicate LI and peer-congestion pname walker into a common
>    helper while preserving the LI-only host-stat update.
> 
> Changes in v2:
> - Drop the redundant cover letter shipped with v1.  A single-patch send
>    does not need one, and the v1 cover carried stale draft markers.
> 
>   drivers/scsi/scsi_transport_fc.c | 77 +++++++++++++++++---------------
>   1 file changed, 41 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index dce95e361daf0..173ed6373f04b 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -737,6 +737,37 @@ fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats)
>   	}
>   }
>   
> +static void
> +fc_fpin_pname_stats_update(struct Scsi_Host *shost,
> +			   struct fc_rport *attach_rport, u16 event_type,
> +			   u32 desc_len, u32 fixed_len, u32 pname_count,
> +			   __be64 *pname_list,
> +			   void (*stats_update)(u16 event_type,
> +						struct fc_fpin_stats *stats))
> +{
> +	u32 i;
> +	struct fc_rport *rport;
> +	u64 wwpn;
> +
> +	if (desc_len < fixed_len)
> +		pname_count = 0;

you could return directly here to avoid extra indentation in else leg

> +	else
> +		pname_count = min(pname_count, (desc_len - fixed_len) /
> +				   sizeof(pname_list[0]));
> +
> +	for (i = 0; i < pname_count; i++) {
> +		wwpn = be64_to_cpu(pname_list[i]);
> +		rport = fc_find_rport_by_wwpn(shost, wwpn);
> +		if (rport &&
> +		    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
> +		     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
> +			if (rport == attach_rport)
> +				continue;
> +			stats_update(event_type, &rport->fpin_stats);
> +		}
> +	}
> +}

