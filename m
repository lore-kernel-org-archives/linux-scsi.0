Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF603211;
	Fri, 13 Sep 2024 00:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726186156; cv=fail; b=G3TeYEmgvHATJvrS2H5zoA3zaXnoL1if68KgQWTdc3lbHIwAbQyd5lBMe6uGltgUj826FOX+IGF7jZmbGSqAP0/Bjpozvuzyf/fIJOGp6XM/dvlx95CoaffSooUVbMpQ3dxdgXoVQA1hGYyJrfg3Yim+1gplLNcKu6fU0VnrO1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726186156; c=relaxed/simple;
	bh=X16rVJSGDvXbNZD6EDJt2L+HhurDCywym04K3uSyqgw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hoPxefzSSgT1ITHFvUtUc7y6xb3l+DXKo8bY96m12+EX4CLkSUhaTjg+Jlkb6pVFvv2hPNIZqW+vJeeBvCYTmIR0HgCPM/HZnMJTe8fssjWNKWucSlJNXtOIRiFMJis39rh2nWBHdtHD5eoUcd5xwWdepK3/9xf9hzuCsVZiiv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V4wSskZY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wBFB6lag; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V4wSskZY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wBFB6lag"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBd2x022857;
	Fri, 13 Sep 2024 00:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=d313CQd/juZd49
	CrjsU+sgNRthWm+ul/jkmzoKL1+TQ=; b=V4wSskZYzYhrKxmhP1ghL1cJ15ak3k
	EcBen3DJhCwk+rvKAR3bOnUXtfn4DXxj6EP2xC6erzhU0slf9ONQQhAOWPO2EOnk
	r/Wb21YstKyWMgs5NQNfWXvbruVtIcQlQY0RVy4mvOb5a69S+1eBnDUQqbf4zE6T
	QYqAJOCXkd0kuLTX/KzMw2HvLBMUKUo9Nq1w85nMRQVnGb4pYzwLrDWNETbDFlnQ
	jdKptprQpyyX2VZ9bMX8m2yhimie8r0YMgn/O9ySE3CwHerNZyqzbebG6j1unqVb
	FZCay8XROCBpgpXJCQ50lJLa/jRcVr5UmGbbq8QxLm/fDG3URLtwaVQA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gde0c90p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:09:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CN5mpZ033545;
	Fri, 13 Sep 2024 00:09:01 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9bytbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:09:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CqWmRklDtiRzN7MMoDM7xDgbKvqgV5c+p63NFTmJyK3rQvHJb9zyw3jfe+MN8eG0cthdNN5+q8Sg2kj+9gABOEGk/QtdpfpQpPbiTRXCLJbwn5vFBthojs+2A5XJcNQTHo6WOB9VjyAhQ/t/nFU4RIvWi0knt8+FMju2JAR9HrcrmpDI093uqUfZ9U2Is1Cmb9mQEJueacYBt0mrFYcL5rRFs9t4V0H3vre34OBUB9V1yzqI2YvcCaSd5OGYXZPpNf8mpD+8h68D/gr9I4r+v5+vN0WgLPUAgGLbgFbf6LAwnxJveM4Ir8soANwiokh50ZzRDot2MB4AUEOp0sSV4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d313CQd/juZd49CrjsU+sgNRthWm+ul/jkmzoKL1+TQ=;
 b=yN5fZywzUL30H2h7i2RccJ2MkOaXenqLyTun39jIOcs4Nm58Ku/fJNMsSbgVOYSyF3rLdQhPA93xr+XYLn8r3m58hD44cxAOaW24UzMcL9yeTwDeJ/4Ga0n6m1VitabkL6oQwibVs4Chor9sa7+d4oF0hmVEvjjh7zoyvA6R6wOs3l5FE/yO0U8OK/MoNnppz1GXhhp27b0wHBFdNolIMdRNlHcO08eRpzDwD3NnLItNoWm1J7O3oNmJi04u3FRCYqpbreaMXbF5Q1CaCBgxIE9l5ZfRMZHl8DVsGJ5YctfJQEfUiWPIVwSXo5bYBES/ryNghCRbiI1jOSiCNuISLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d313CQd/juZd49CrjsU+sgNRthWm+ul/jkmzoKL1+TQ=;
 b=wBFB6lag+o71N5Aa0Frl/DJt2qtoSuXU1ZkbIYgFvR4sNNQDH9gTPJ7KDHvSoCUsPeG20Z8yArp9KDdaj1zxVpLeId3DiacgnfvhAEku4oLh855xCs6GUdkOkYTZ+7DTQuBo+9q8ALAMCcOH7h1P/IlGN7jxY9c5u1TxEV366dI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6876.namprd10.prod.outlook.com (2603:10b6:930:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.8; Fri, 13 Sep
 2024 00:08:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:08:57 +0000
To: Rafael Rocha <vidurri@gmail.com>
Cc: Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rrochavi@fnal.gov
Subject: Re: [PATCH] scsi: st: Fix input/output error on empty drive reset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240905173921.10944-1-rrochavi@fnal.gov> (Rafael Rocha's
	message of "Thu, 5 Sep 2024 12:39:21 -0500")
Organization: Oracle Corporation
Message-ID: <yq17cbg1kl7.fsf@ca-mkp.ca.oracle.com>
References: <20240905173921.10944-1-rrochavi@fnal.gov>
Date: Thu, 12 Sep 2024 20:08:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6876:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a8e0132-5d5b-4cde-01c9-08dcd388430c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?omb25T5qB8W+B2Haqf2ODCVFmK6ui6biKw9wCZEoTBFC5IsUbseowiLo36iL?=
 =?us-ascii?Q?SvGx9ZLgPda8y0FHOXMv+WmXkLMZ8hmsbTXAJHzuf7A2oM+hfitnbaTbYyk4?=
 =?us-ascii?Q?VUxoMfr3FSS2RY7eDiL6ydaQTvoWsEoLbzkkAjvQfD8Wg2qZ1NdURrCce8Bz?=
 =?us-ascii?Q?M6Rf3DACMvpk/VDcK7zpSX+hFvxYodG92mAE8fxeerxq9wDJJXVh/5x4gXYG?=
 =?us-ascii?Q?iq1ZlVoGX9RZMVTCZYjGArtLJZYWeLz43Vr6vwPb8i344B96bQjFazxPPqR+?=
 =?us-ascii?Q?3aCXKHW1+1kQRSiIgdQLo6OZKbTSnT7s7LdVpTQBLNYW95FVaErBL4Oz1lQu?=
 =?us-ascii?Q?Go3JeYUgmSjaTgab4Zz0HGCBcWOpPz35iFIYgyjYYafb5+HxClrEL0G5+RPG?=
 =?us-ascii?Q?e4lwDn/KHS5TVUEbkKYcliN3wYvcr62jijb276ISggLVCv9QQ0fApe5/UogC?=
 =?us-ascii?Q?3fGNivGbM77HNFI2RzBj8CPvR7BDQ8apYG19Crbdbi3yGImPDhoGMMteGvxf?=
 =?us-ascii?Q?Rq5WmQpkH6n63zE5xIcXKIh0ftXFak/iRxYyvfa78YMBR3NLHq6msylNSnOc?=
 =?us-ascii?Q?3IE/x7o6aQRAqCk3LMRVXeMODV0I8zzsVXxf78lX67h4qulA1Ucks1XDnPkb?=
 =?us-ascii?Q?Rt6VFxXx7UNmET/asp/a/L9/J6yitAZnRpuwkuq+dwxRDgiomknegYqwM9zz?=
 =?us-ascii?Q?I9au+QYqTcunnszkcB8CkVGf6g+uADT/e/Ac7CFGoMltus6u4uQ5HSNDuMu5?=
 =?us-ascii?Q?SxCJ3nEmV0nSfR2FpFJ3g7pFztOoOgVaYCAQNnguiZxgvyamehkkOwgbGQub?=
 =?us-ascii?Q?PwW85Oo7eKDMTyMTxQyeDKzwLzwgXXD4tX5KTI17ffm7ATrK+RW+yKAfyXhc?=
 =?us-ascii?Q?93vHTSjlgyj5qeHwQxwwACsosAS86KyxoDvzUWrMYiHVdof3kkmHeDjUYM5m?=
 =?us-ascii?Q?y5nT8V8jq3UWkxkw/hz4GpX6ukfsQVrtLSB9+hOE4B+ThrZAVjll9nBVmHeq?=
 =?us-ascii?Q?bCtrUCE08pBJygTabzxTiGaFLMquAfU/0Ll02G+YEzuwSa+BzpicooM3N09J?=
 =?us-ascii?Q?Y5CNkdukPWmCbcOEWUwTYUoWaaPhOkhPEZdbSn8GpkguFgvbJl2tbexcCEw1?=
 =?us-ascii?Q?ovLEl/DxjP2EqWjgpBXDQ6BPGCmkBmKt/Ib44sxs15c3v409kom8pGOPrU3q?=
 =?us-ascii?Q?KtfGDlB/52RAzVUVEgN112XSBo9zVz+WSg34QKKfAhk8TtRfwJHF7TOx6Vtw?=
 =?us-ascii?Q?YC/DYhdOoC2BdUq7ZiYg9jdvD3eh7x4zrhdlyvJTDzbCi5RxKav/ngHot6Xd?=
 =?us-ascii?Q?/yMNqoRHZhDXHREd8tiiPiEggumLXCJNpRMK6aiMLv6pHQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ujJeVx4Ij51oaerQ6TazHKXHQNakrD7MFwKfIx1Cb1mkF+3Y7rCxpf8ZIVmE?=
 =?us-ascii?Q?qCcKbE5lV34tKuFM9UT8b73WNQr30eSOhwbfwrR8iV5vzATAk3ZDfONYwefr?=
 =?us-ascii?Q?fGP0rDPq4VJvLedb3j4c3ZoEJM6+ViWIDwvbqqY2CnVGPYu92CZIihWKjkBM?=
 =?us-ascii?Q?gW6Mt6YpJbgxi6FB/lRaGFEmy9+bPL0YQKzrxetIj4a7jy+u7kEHHjuFCP3u?=
 =?us-ascii?Q?7fZN83pnSk+o41GXmViU7hmzq434aEE+HRPGb9vPQb1XUSMgiwWTSrq8t5CU?=
 =?us-ascii?Q?C7Z4H8w1DnHAS0LtQEUSZVx6eNmN0mEbU1XmTF50clKQYrz/pbRg7dRbEwen?=
 =?us-ascii?Q?yEIu6MWqAMf/Zb+Ek25Y3GKby2zXKP3PYPfnREIBjZngNEv+HRsRyEg5PoVI?=
 =?us-ascii?Q?iOyFJFjlwk42J9s29u40/es6lGrc8In2lUPr9apKlVbNzoho3uh9zp/rp6Oj?=
 =?us-ascii?Q?ztPc3ioun04B4AyAlZLfytImsKjbwkm5czLyx8xVmb3ZMsYvp3SrYtDxnzQV?=
 =?us-ascii?Q?LvfcYQBlwx2+kEqX/R3wEIJJKSjWH3vy1bP1E8bemaGEsStEiYbsPZFIY7Ft?=
 =?us-ascii?Q?eKyxYw+5l2YtpAT4PtI+1HMwRp943WielJ8h3Nqvhxcmnn7DnvOS8a8F94U9?=
 =?us-ascii?Q?ob20FvOClU+jLV9pJstSMmKpUnywsaQRouC7oKmAPRWuelWRi7Zlae/3h2fp?=
 =?us-ascii?Q?kUDze1ItF1A+FwG0+h8P7HQFsoS0qPi95v6zS7PYJNC7MG23TGYRO99CuuJO?=
 =?us-ascii?Q?TNIb9/b8vUDBlIP4I1HOQoKErbE7b1vmpONF/70hqCo9a+swnDOUndLdtLPZ?=
 =?us-ascii?Q?9p0lSkCZhvWlBt+8IEAtlKrM3bNX8EzchgjVLABNANwPa7RReAgLp8sDPIVl?=
 =?us-ascii?Q?PDVyWZeI0AuT1RaIynDZ7uB7bUoZGrg7cyR7Ch+X+etA/ItQMCrw6sd1NIQO?=
 =?us-ascii?Q?V4IyYS2qJ13N2UJCI7VfFmEd/EVQBTVXW9nU4adpdoCsnHG8k+Z+WpYmZVST?=
 =?us-ascii?Q?ECqZjVTjMHrF2U6KTFFREBLVnZJbCl6WV/IO7g/48FE3CX0fJ6CAVLpkPZjN?=
 =?us-ascii?Q?cY4yCnN4XBTyWeMcSF9fWeGSfRvOD0pNDEFD0GNzIc3bRAfZ3DLiB/PBU8ol?=
 =?us-ascii?Q?/3u2vGAMzTJrybZdvXg/UDypoBh6zFGGf/RgXU3DYT/UWjJw7MfDq3QIUYBe?=
 =?us-ascii?Q?NH4p2hIvPyfif8w5GWluGUvQQ5ltQRWTlLVMRuA4tjFsw1RVTHMtZksP0Fjq?=
 =?us-ascii?Q?AV3Tb8bcd+12Y+YcjGysGG2n2XZyEM6M2pdSHnymvMxpPYigOIjebXCMAVfR?=
 =?us-ascii?Q?ZBrPDH3n2DcBMyQT6f0Wi5xqNj5vi7KrQ6PEsJ4PQY4MyQQtGsEM/Gj9YZ2d?=
 =?us-ascii?Q?KRH+/Z64wJzYoA6ETMCgJGttgv+ZdFKJxNVDzzxlmHKtnXyBMVNCnmFY09gD?=
 =?us-ascii?Q?dk2NfMR4AJEFdCxdhqG19IPUBdjOhw33JY5gWFDRZRzyE9M8F6I013BDJlO+?=
 =?us-ascii?Q?Xh87qPqTvA6sdpdSm+XTZelhAvK3+nyWjZE82WlsUlidTLCOylpBgrdFGzxC?=
 =?us-ascii?Q?7/32NShLX9WULMiN0GiwoQ36cqwMrLt2NxmYbxsL7kF6D/apF9RuwhJs8oqT?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4TJpiemBeckvC7bSnJYex96XfbIq7i0Z1Kc4VwQ301ysrsAGnsL4Wue0NwoHvuBtNByw232zIKZkkpXToCSJOMA0TJK2XWQq+C0Dr7dNX+fArGubKEnmXzUAM+ensGxDXJK4udvglYH0vQx7XqVgUQCO6TSnw4/LSe6I1GFNc/sMY36bYp7bQJrFED5VJZS4s/MEKh7T7DTyLigbhCA81a2BwXoK2X6JOExJB0P4hr6upIevBSSRDObvIJnq8z0+9OAIE7SYgpKT2N7+D7eq8/NdM28VFETK8mWy7DGWHVuFlM/9n3UBZeZrjbQlgAvpg0zne/jhE0t7ro6wInx1zAWSlI0ACbaYzv26mJ0589HQe8JCkaqk7moh7BmieG8g+QDWqpQ1y4K3mUINhtwVsI9jgtYkP+QkJtxpq7s/S2Fog8M6K33YtvEXqYrJVHCa5ZNOhscR2zNwvklnUHO6Ya74Ef1vx1P8vBxIFonQ3vVHV76++qnh+ynG0pI9ZGifvOSqhKRhA0KC85VcsK0+/2pZG+i48imCTZHV3BspGQJbWkm7Rnkq4pRi2iaJ7xMOmdYKk05u06e4zGMd3YoK6vwwEnchM1WdgBSs4Xo4P/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8e0132-5d5b-4cde-01c9-08dcd388430c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:08:57.5315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgXiH9mGTpSjuYiRnWDPS1EDVRYzC9heFiB2p6UXwj6uQQKC2BT54sSelDBPMeCDB/HmOrBi0Y83Z4VU94dz3yc2okNQxOOTbd9VKQUpJOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409120174
X-Proofpoint-ORIG-GUID: S8ZtmOczhY4MEIbVnhEqYBP3YNcE_tfS
X-Proofpoint-GUID: S8ZtmOczhY4MEIbVnhEqYBP3YNcE_tfS


Rafael,

> To resolve this, the "ST_NO_TAPE" status should take priority when the
> drive is empty, allowing communication with the drive following a
> power-on reset. At the same time, the change should continue to
> protect data by maintaining the "pos_unknown" flag when the drive
> contains a tape and its position is unknown.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
