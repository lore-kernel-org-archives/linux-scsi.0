Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A639AEEBD;
	Tue, 18 Mar 2025 02:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742263499; cv=fail; b=LzTD/bIyKsChlOifNB6I79l0RHH5+OL0HOZrcOeBJBcwcdnPedWRp+K5xp5+/LHPnoZLc7MQLFPcBEBvbbqELY72I9mqjdi34rmcFOcLYBLCHY1bVv3peCz8WsjixE3rX7G4kvqTZhmSIHMDGuteSFGPZg/pKGvIXAsnydLvpi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742263499; c=relaxed/simple;
	bh=EEKrFDazo7q4XHQRVgS5DTmJwahchYZumtn9EJs5gik=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=E2vH8OLOEWOx2DH4PNj2tlSZNdC01x22jJPVBRmevs3t59gdBA1a+nJeLVuRs6hsLthRdl165aAkbBoS+UnFjkOlvUQv9Esxz7orYlROIZvdc7LjL0tlHrqc1LxV2YlStsRQTncIs1aCWwdnRnQOeXR3fG324be2w/NosCD6014=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WaGd6jJw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YZinNbu9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WaGd6jJw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YZinNbu9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLuIEX029296;
	Tue, 18 Mar 2025 02:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=5QOuoB/OP/6CNp0TAl
	HXf55jKZbOr1EyojYouQkAOg0=; b=WaGd6jJwh8VwtMcm5aosHwteMQZjn/2dS/
	/m/7pYo58eMR3erppVx+q3ccGjvwalZNsTnTF/d5u6P06eoKffgIq6jK1gCzXVxv
	rRb+oZr0K0LswTYF2nGdlQXRRpV3jIRaSxdXM25ml83qzyfmJsLZm/n2pzKX/Ycq
	KJkzyuRTwimZx1nMnkY2gFWSoDdpBG7rit6FNrHbwJ6Oumz01aIpaOCDub6eCofb
	d1+uGRJiCPCZVwOLWzmahymEc27U05Bs2dd97CXzygOxPeTe/KmJmgBQP5zr4JOY
	26yFoqs+au1ewUfnkgbHZhhLz0hLSskUXQ8lWdKtL/Ytf/vee4pg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d23rv6w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 02:04:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HNquXm018685;
	Tue, 18 Mar 2025 02:04:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxdjedp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 02:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pegy2Q+EpWRa6GIuW4o9m9vokGmlfDO8AauOXQp7Gzb0TJ/2FXdjgtVn7WaXqghXM49zGub1O0Bgf1Ds4Q2l2hXjDjK6QlYwQQjMRBLyuGVOL+O5UFGbUsla84MSnXBgmIshYkESIsPkr2Q0zh3AGaHlNijE/tlbA/f446fXN19lfjVjchdE+uhHGE3I9+9EkSdchcS1UlBiJKokh5jTuTrukm3/2w16H4yXD+jhaaSkD9BUMKwjpeoq4MLzmzP4fumKSuIaxffjT0ArkO9xDrleoaG6i7zH5OHD7bwpUsN7OhlOWZcschMkanQhba78Vys0LOy2aCXZVjSWjZ0GYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QOuoB/OP/6CNp0TAlHXf55jKZbOr1EyojYouQkAOg0=;
 b=j1sf9BP1k7X06biq26DW9jBwOcCWhH/viyOdBJ9lH3wMPCZjRxIXBpJNB/VsaiGh6m1vPqXEDQEGwE69ubQcSm81a1xRNhZIz6ueT0jyqypXSItS2fEFSOZf1EEY0Kb05zLr5gZgwaL1XYwD/Ap1J975MOiytod0ynAkNQkxqGQ5s1l+iO9ay0JpPuamHMp6nsw6Fd9bEsz/PA+nN+1l3nFG+msYdbK2CQqxyOvc1h450ocdFrnGTOK2iKj8ZBCz60/5BPkwqZtEQIWXBepeUmZwd9Eow86wCKy+CZ2fkjBN2j8N+8Q53XW4ySCHc8ZT52Y3Z73zVptHMMMA3bIbJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QOuoB/OP/6CNp0TAlHXf55jKZbOr1EyojYouQkAOg0=;
 b=YZinNbu9p5BTVv2rlTmpeJm8Xn2Brck3GQD+eVud4a8yPnfwySBTkeErPSQwxIpBJxsn2U3JUY2YGNEU9rMohDTsoUA7qxLJiP4aNVpRKAKSz0fiPmystmP5Phc79tc2wNiCFSe4kcj8xv1W+81c7QEzhl8hIzj7r4MjxhBxEP0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB8204.namprd10.prod.outlook.com (2603:10b6:408:291::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 02:04:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 02:04:44 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela
 <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Remove unnecessary NUL-terminations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250314221626.43174-2-thorsten.blum@linux.dev> (Thorsten Blum's
	message of "Fri, 14 Mar 2025 23:16:26 +0100")
Organization: Oracle Corporation
Message-ID: <yq1iko7ccwd.fsf@ca-mkp.ca.oracle.com>
References: <20250314221626.43174-2-thorsten.blum@linux.dev>
Date: Mon, 17 Mar 2025 22:04:41 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB8204:EE_
X-MS-Office365-Filtering-Correlation-Id: 87061baa-6bde-4ac4-6a3c-08dd65c1405c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?koF1YqFbJKgklrQYz5i92kEhvkXadHomUXTB1KqdmKlr9lxK52Ru2sK0/HKr?=
 =?us-ascii?Q?KUNUqAx7wv9mX/ELc+39W+qxk+pW2096GF0ZMaVtbdn+jbCTQAzkAjERwPUj?=
 =?us-ascii?Q?r9SHiRXzQ/gsfwTLdrTL/kQf8H6FJv/HwuEiTirfA7g7PXOOw02Jq5A8zia/?=
 =?us-ascii?Q?9Z5A6DGt17j9W7Y9t8Sozf70nqQeApjxOAZZpjGhnAmlJ/iRSe0EhILEBPsK?=
 =?us-ascii?Q?aFO0Zg4UC7H92/z3JFHxgMgojEc6FeKxLQMLAPfuUoc/lDAIbB3LrwU3rtVc?=
 =?us-ascii?Q?+DCCZ/M0NvCtw15it0ywQbCMahZ5N/Pja85e0akWy09aov50tie4sCKMiNfs?=
 =?us-ascii?Q?epBb6V6EWrexpEqRhzHiGmuhXa5Ljzykr/qF46FYigVi/7JsWUHUrqs/XVw6?=
 =?us-ascii?Q?E7jUIju75uK0vLMLsq4PbzrMF6pXuquvdxIFGlsw+gWQwmK/ojcpSxFYq4HM?=
 =?us-ascii?Q?MXtGu1soSjKBgwMOX3dphAuw/72Z5eYMPv3aW3z8IcpLjuIukFPdo789jWHb?=
 =?us-ascii?Q?IQLQwPNIETv6ePpWtgmoGVn5p20kVDJlhlEc0N7PGnw/JgvehBPK/V7l8sy5?=
 =?us-ascii?Q?tcQ7Dj79VaenZE0KNdqn1oIkgE93ZankTy5JLTEFryYZ049UMUovOKzso43D?=
 =?us-ascii?Q?F3UD8oqnGIVUwDDH++e9nVnTrWmvV5xoIMAFYvGaiEK/fJbfvtwGP7ZEYxSW?=
 =?us-ascii?Q?iYxBwuQvBv82bCaE12yzdOQZDHCgoK7Z18T5fDevibx4W/OSgJtH7iXaZbdF?=
 =?us-ascii?Q?m98ESZS+eX2ubSd7zcfH7k8IBVJ+1zqhQKWsvyQzly8u3OJ6IZXePOBaysZ+?=
 =?us-ascii?Q?vIiRzytY+DfsM3sJupRoqx5kAcACf3Lj+U6l7HQAmTItrOrqPK17GmQE/J03?=
 =?us-ascii?Q?Na47cpmsDKED2rxDlHIjfp8kPvGmS4McVicKUeHnCAi4aF0HCUVNcYAhOXUk?=
 =?us-ascii?Q?OEOCATA4SmPsiD8X8Oye9kAHd9xTfp3oiSoADC5h0rpbY7/UpHbdRqugckcD?=
 =?us-ascii?Q?agj7RdQ7Fw5TfkZOoK5WbWVj/5KI5ENsBmxIsUrGX0oAtdlFCjilcuRojjj9?=
 =?us-ascii?Q?NcMNMU14a5pNIWpjnu3kXvcYKkMiVMFbAhaky5aUHIdmp0BUycDekKKpqR25?=
 =?us-ascii?Q?jS8u1lkV/dhaWnyQaNkY0azJCEFiE2w8Gt3QNX6o+E/NVx6X+7PVnVE4v1Yo?=
 =?us-ascii?Q?ChkzZw88z2la9fUxC0rhFbr5mPorCC1YbiO09g5swZ5NGKVoYLDS6yXCyAuB?=
 =?us-ascii?Q?6v8UJe8P7pZrvlfOtIs9GjmujBk/XDUxRerISnkzChgTG7E/XkvVBf6I6/il?=
 =?us-ascii?Q?tBZTQ/DHcDz00KfXA0TYO8bOi0irnYpWj0oCNzflhcXSgKjrX5QFZMbSH0rS?=
 =?us-ascii?Q?7OEG8p5UEaNjQV2PQ3CPmrPe98s6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sjUdL9vsVrQjIcMPlLGSCycokS1IZBR+1CccXlvDcdTTzuIbkAOQFNukxdgO?=
 =?us-ascii?Q?A/2Xsq4ZS1JQjGPEX0u/kWfTatI0GS5Jgp68GQTU3VNvGFC40WLOaL/uS4c1?=
 =?us-ascii?Q?y2mCObgLalLwWMdvHpZwCbVjRdow7lMnk6C/nkaWIXStpCoof3vOJom6Q8a5?=
 =?us-ascii?Q?0yiONiaLBz1nSrxhrYnLXjeuXtdZfyYsvvMsenawqgzH3yPf1oZgLw+cdyUw?=
 =?us-ascii?Q?RSCE5k6xM6/5+xhpQcgx/ru3Z77ItNXyMu5lhrrnNOEKSAtLUb5nE0HGxjzM?=
 =?us-ascii?Q?W21VKOW8dA6Jfzb9SEp8a+JdglYBlP3SBD6m8igy0xSIJVnK+SxrP9/TAhSo?=
 =?us-ascii?Q?N30REdm2qijmkBRqfVqDPAYBkL7HLZundsMORyL++6f1lpjFHt6Ez3ld6UgC?=
 =?us-ascii?Q?N41f8ETYJIGeNH8CQhQjOWcIH8aZzAX+dUuT53EGbIBjt6UVz110XiAyBOCz?=
 =?us-ascii?Q?ajCb7R8VFatdTOyVfXAp4DIrXbrBub3vIIJ8gTtbdLii3STAlx0rntKqdv0k?=
 =?us-ascii?Q?NUo32BX3mMxwmPEa9zgbfjvyUJPEdEUZaVnMp9SbdC7beE1DcELlBWD7ALrD?=
 =?us-ascii?Q?bAbByS893j95Q59Qe9dEKZq4JJsdUzkMOrAuDeDF8c0dIZuwuI44JSIZTBLi?=
 =?us-ascii?Q?niAD8hAXZjXpv+rUVBYVResnLbHjAD4GNT0H2vDiIDjcEl+iWRILjCGbHHNR?=
 =?us-ascii?Q?Oj6KVAek/aITGuuyX0R8GDPpF5os7co1hJ8IIrCNJokSqhBvGT+sUGwX0zHw?=
 =?us-ascii?Q?7G+PnbtIkXIJjoMTprkRKFnIiDxhG3GZFxUx7KCRBjusJoCv1c3VHcEKKw5Q?=
 =?us-ascii?Q?mgyXh9qUwD/di40xr5WSLOAk3DXwyl1TvcLsFQt2KC9mXtVukn2qNPqJv/N8?=
 =?us-ascii?Q?KPzhmj4crXV6Hx9rlKeeMZS9VSlKKWOhiWNf5yPAwvYfRwScOGaSWA2XR4q+?=
 =?us-ascii?Q?53YDpGWArjrawbWj5JCTbAMw1Nd2H9ApOXGIJTs7uMZKBQS0Es0NCiCpv8q4?=
 =?us-ascii?Q?mcIEqGTxNL4O5AKmyeaT6E9VEWJDQvSktnAtaCKw/nG9Xt7+6ahsEnHtnkRj?=
 =?us-ascii?Q?z/KyoOqkNU+dC4Rt8J15oakdoQ7k3praatCtVFd5uyXlUUI/xnZzd5Nlt1GM?=
 =?us-ascii?Q?kX/w7wymHPvkOcii0MMqQyssAxNz5TpHmp6qot7voEdVYkvOXEqLiq/1xLzd?=
 =?us-ascii?Q?RDN0Wq+6RMmTfITkHSUHytO/5uarGE7ekfxUqVJucnlTtxlfMnABRJWr54Rh?=
 =?us-ascii?Q?itreh0gqNFLCu0w1GZCAT3tuGevpZcPE2cvL4qFrMfMaTgrWNkThOboqie1f?=
 =?us-ascii?Q?77IA5i9chNCGZflG6jyOxo74wq2x+YNql4418dTugIuKCR5bU80ho9i23OmR?=
 =?us-ascii?Q?vXe+VdT99H4u3kF2t+X1W4xjxfoK+/S92eBGkHibaSGiVqFIoR5GvMG5lq2h?=
 =?us-ascii?Q?I2kQaH1+ccv/GT7G58R6eadwgK4EA3R0joGTlyZVpb7REeaZoNsKjuAlJaUa?=
 =?us-ascii?Q?pQst8ySRCKS5RceiUUvWmF1fU6OyWuDMqHFlpXJBsQxeRz2GMRPxGpl341ta?=
 =?us-ascii?Q?1n0A8Sw9FEndDBUEsRuSBuE6yGyip/Z5z6lvjICu0AFvaXkxEUmFcP9Yi2m0?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GP2A3BbXQuMdwwQMxMFsjOEg9UNpdL9e+Ghjec+rSoDZf79bpIOtxXF2WeFL1FJLDfZfhnLYXMtEe6m+zeLifgfM4C53VJFkEjLB0LQ22x1MoVPr+B+jgTYqthmkFFLv4nE8YCg+uQgDBiSN2ZJZHA69zsfandhapBqjgvZzsZ8n8QUZYK2anVI+RtlxnFHGtwHMDOPZ8EAM55iOSv08jvM53OtL9KHeXDyB5645GMiRqBdU8OCDARvpjpp0W7XElznFWXpAOcR37IH4/jKVGcJ6MN0okkGCFDjCYsGtXCF0K5dvOYG50CPf6M0lo8jP1vyjRGhhN2onHpXbbxSo3aj2ek+EGg48iyHvk3lAbWM10NDeukohGjMH/0MZq4hi4OJxG4dG42GbjFC/R+FZG0d1bTQcdIWmBhIQJkdI9Zti5cjor7HxYPE43A/Y6lEfMvR0lDmSWg/YwS/KlSO/fPu+MRYhNJvMQdh4sZ7gxQ/tLln2zb3GIi+cX74a4KZQF6hR4sgueTt+LRlshkAU6POR2SZCAGU/JANqOmDTy5WNMng28+d0EgM2hQusu9p4zLwPFdsBQzAb5GtMoLXj/E6nM+uo/r6InwxcWPru9JU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87061baa-6bde-4ac4-6a3c-08dd65c1405c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 02:04:44.1104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOxEnN3zjF57JNad69RBovIQyoBDLaayg8CKFwihkEfGOWlvT5vf7iZvPLGNTImqaO1R1rrcB7PjZ9FSTQTHLzmF3jruJg78eR3I9sTgnZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_01,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=875 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503180013
X-Proofpoint-GUID: UWgDZ7wnIGSVAApr0bqwyObMnOgWCXL-
X-Proofpoint-ORIG-GUID: UWgDZ7wnIGSVAApr0bqwyObMnOgWCXL-


Thorsten,

> strscpy_pad() already NUL-terminates 'data' at the corresponding
> indexes. Remove any unnecessary NUL-terminations.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
