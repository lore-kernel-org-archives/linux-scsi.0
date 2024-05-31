Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6F8C138;
	Fri, 31 May 2024 00:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717115259; cv=fail; b=ZvObY6Rn2F7QaUoKaFByyFTb7gjF+ZkStA3NPnsYIYZCgG+FMeXrnO79F4z+48zU+ioqMZEUT2hqRVdNedM+DRvvUHemsiwCjM1tFMh68tdybJ+gfG0ZwPQF4IrqACHbb6XOWI9rxbqu8dnoo2FR334XbqEH9BGZfUh/j7bFVPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717115259; c=relaxed/simple;
	bh=m1gzeq/YTo42yxnV12Lob5fknalA5VK398cLoMjJWh4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=T6fks3Cgx5H0ZyGZcLjY2VYW/y8vWSqWrg3sMFRQmlDAo8ujmQuiRC2CsOOnL0s5O03nT08Jr9ZTp8OT/q5Z0oydQCVUgpiwJw2R2XbvjcO2vQVu8Y63Yr/vB199gY9j7JPAuy7GbtqCTrDJxuoLqL2+WoWrBcDtHfgQZsu7Gzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44UFPhZ1001872;
	Fri, 31 May 2024 00:27:33 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-type:date:from:in-reply-to:message-id:mime-versio?=
 =?UTF-8?Q?n:references:subject:to;_s=3Dcorp-2023-11-20;_bh=3DCU/mEVpj1PUM?=
 =?UTF-8?Q?HUOT5hYd3a0HyN0jxhFlKE2bZgZd6Bk=3D;_b=3DkqvZEk//LOTSzkTNndX1SrL?=
 =?UTF-8?Q?jdCmHodEtFQyLNA9c2rn8Gsv1KVfY+jG0bJdSIXZIsRfY_Pxtal8X1/GPyOI1o6?=
 =?UTF-8?Q?N8YNdTT4rNG+JwrdVdo+ov9+AZLPXM6a83tteV99q8BgGjFWBOG_76q6+R+DxoS?=
 =?UTF-8?Q?X/2cCIG7PRa4kbI84IUiCeSxy8PXakGfB/lv6HHB5kb7dD1fR7Ot0fe+v_86MPP?=
 =?UTF-8?Q?63tNC70zlJHhVmQLbDeiTDAtWYPqh/PoSwJFLoQZW+FSnPfKfpgrR2jH5Wy6O1U?=
 =?UTF-8?Q?_uYN1X6gvv28iJ77uvUrE8vq6M+/0aiktZy8r0TOVDkAYnQl69YBj94AoxNDpP3?=
 =?UTF-8?Q?voaeU2_lA=3D=3D_?=
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8kba6qf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 00:27:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44ULlDgw006205;
	Fri, 31 May 2024 00:27:32 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yd7c7pbe1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 00:27:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuGoOHD6uh1DYDz7IPBiuHVZpvCTgHc1Wnrrjxb7MLuJUgYCPnqsMhnlZqoGsZNReBZaTu5Q9zE66wdVWgwv/Mr8jFvkWzG0Lu8gTWQ72k595BcXGcoKSyNKMA7rbhrk0fHEcqcC3lZN0afURMFMEfFa4cgFIMr/gub2G3JA5dbpyebJEMW14KcKZ+0axFMha8Me7b8ZLbBdSDwVyge3AHSKVRatBs8/zPAsDOg8Zmro4g4dEJ2JFXQqCtL+tn+06djKX9YVLgOYQyQ9oBPybLbxrJ97GSAeIU+Grpwc6g3tX1qeKUiGLWWz5rAUnO5rx2zfjG2eOaR83KjEpaDwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CU/mEVpj1PUMHUOT5hYd3a0HyN0jxhFlKE2bZgZd6Bk=;
 b=n/GNM+p41lfOHVsdk/CysWsks6rBE6qFb5d5pTjgw8cp1lstOi36eCN82U4AC0BjUgNnVm8wAd6NGd+p1tKY/rAs9nxLni2wPe/xI5QzQ8/ykXSDglj9wGIbdxJbakG4xPZBTkAaD6S2G9hAogqo+CjPflN4Sn9ze7TC8OowoBATZWGUYReS4DQDteOWHKigxLcZSJUfzEZcDiAyV9BvN/SOt9NBlL+JoCz2xQmRQIogFlgQpGateWnz7O/mpdXpmb34fDxv6VoLlYvSrB/gluuoWz7ky/7hE8dd3hm1rUji8CZ27KCXaBeaMZ3dIVw0Lv8sReFRQXODESsPNlUTfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CU/mEVpj1PUMHUOT5hYd3a0HyN0jxhFlKE2bZgZd6Bk=;
 b=BhndAUHUx8ZD3ry7f+5WxEbvDdQzH73h1ZONCYNK+pwJEhrupfZ6VF8XyAvZlvB1emu6lH85E62XRkYBqLWg8l9Q0mmAdnuc3rpJ63biJDnoPZhPDEc2AnjP5wtP/ELFp9G9nYC7zeahtbY0aBm2VSeBCRFF6myFyJl2jTxtn24=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4281.namprd10.prod.outlook.com (2603:10b6:5:216::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Fri, 31 May
 2024 00:27:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 00:27:28 +0000
To: linux@treblig.org
Cc: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: remove unused struct 'scsi_dif_tuple'
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240528215640.91771-1-linux@treblig.org> (linux@treblig.org's
	message of "Tue, 28 May 2024 22:56:40 +0100")
Organization: Oracle Corporation
Message-ID: <yq1a5k6g718.fsf@ca-mkp.ca.oracle.com>
References: <20240528215640.91771-1-linux@treblig.org>
Date: Thu, 30 May 2024 20:27:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0535.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4281:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e63844-e8c7-49fb-f83e-08dc810873e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?u6zG6S345DPynPZSxLknlZDFk3g1sU70ty/LRf5pl/iFYyVj40PIux1PiGqm?=
 =?us-ascii?Q?Nh2Lo0ZdlsLruK1kdqmjq/3eK1SYNKffhdwnqijknG5ehNrT+AKlY37wRNlJ?=
 =?us-ascii?Q?WE0aOj4cmYxQrDt7TSfclROd6M77f7N58LeDchYYChVMGrFw0sPSmGgbpO2/?=
 =?us-ascii?Q?JzCy8zshbea6jogTC3xaNBD2ujfp16+mBDVVaWrKQI56gDZdDfgZwZ7rk/7c?=
 =?us-ascii?Q?+ngULrjz+CT4rT2HeEWcaSbXMl7SK/27ioPuvSCQEPmK/H9VIEFHs968GRie?=
 =?us-ascii?Q?0Knr/Sh+5zbha7eql1yHCfT/upF5Aqi26wVPLwhMO6q0LPv3QUoEUVSXpbcU?=
 =?us-ascii?Q?FO7UXwKX241+m6b+hRI45VjscRqGI9qm2Xpznox7HF/7sqxTC5Q4MRgEp09I?=
 =?us-ascii?Q?85t0GSsBWu6qEr0RsrQC70hgeRclnMmzRYX1Sk5cFfZ+80/i3tC+zLgczO4a?=
 =?us-ascii?Q?DKSYqhX1/f4NKUtMY8QtQNZJxILyKa81HjJeyy+/fvwYxPvG4lo38LGOFuwR?=
 =?us-ascii?Q?WqSL63FwDntHNH+zUVE+ZYlodSUiIO9FDDhHYT/aTEvlVR3y0XNZcZ8KbprM?=
 =?us-ascii?Q?tPo9XMsd//6xzRa/w4aNKsCDSe1q9WrgedpRWWsWO8pdiHm4ahcA8jixgYy4?=
 =?us-ascii?Q?uTRYBV6fB+O/sCnhBpxjIv00dd4x2Tk311N0TUp59D9X/uNeH605SPdvZARN?=
 =?us-ascii?Q?/kMMwSkEsS11S6WZnBdBycN14muiKdQZMQbIfZNdZYvs1d/VaqnJSCEMKkjL?=
 =?us-ascii?Q?d0c8CZ+Z0qbmV2yEVnlCUnwkgEKgrSLVtNpkp0PnLkVhfp5Q2IQxoe1D3jrm?=
 =?us-ascii?Q?WFbW7TA7GWKGCm3EU71Q1Zkqm0SPsLEGUDvguA9Z2gsn4ZXvsXSf89OC76hG?=
 =?us-ascii?Q?QpHF0NGpHOGmdGZmIcdkAQvltQ8wh1duxk0Hrvb7jnJ32rdQpNR7GKVst7M3?=
 =?us-ascii?Q?RFErHLXFEu6NFhSJAw8un1SeBhxupKoDxECkBn9a2dRmsrhq0n2q+3/2oV6U?=
 =?us-ascii?Q?8ZA2vhZzD5vcwmYGOAe3YgaWc/s3xbdb8/Dq3lSXujkr9TN6Ha48ldPQv9fE?=
 =?us-ascii?Q?NVO64C2/MNkK+FkmATegRFWq/4we18NH7Dz7PHJpgZ0XEKFa2wS9q9ixMnuu?=
 =?us-ascii?Q?ihcibzsZHaqz0WrvxKX5Dr4vvW0v9JeCzJW9ob5g0x/pgzfDrUCLMxiEZewJ?=
 =?us-ascii?Q?NTIF7yCWivvAoNcEatPdcP8PLaBS2RbkzW2ceEf4pj6nNLwqfQr64MDrU6MW?=
 =?us-ascii?Q?g7vUO1cffX5YHmOjuMNIdVy4zelu3h66Z2bkbbm6SA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YXD/cMxBdKp+oEOxu/NQC00ODXtsLeaE9W/VmyWDdkjgC4lV6AUgxYKtjnvA?=
 =?us-ascii?Q?x8X0r2T3WWKnkZtnuhO1VEJkt4+pOrngaJjdyIKK7XA2z8IOFMCnCKWaOWoR?=
 =?us-ascii?Q?30WDb+G/VV84aRNQXbTfiu96CArUuz710t90++tIBxfer9JZGImKQyKoAiKr?=
 =?us-ascii?Q?jD4HZOMYVcHuBvILHVejNfG9sdk5hm23wmhuXcjL8zAg2X8FRBEJtP6U4YMG?=
 =?us-ascii?Q?/Vasvlb/+VjSwgbxue+oy79koiblRCh78cDEKubngQgwU+Zy6E/Gl9LmayIc?=
 =?us-ascii?Q?mT5VsT6EN/nC91OOI9Sqk4Xex6pz8Gux2YxrEdiUhlAQvgMSz7DLS60n//J8?=
 =?us-ascii?Q?acdQ9Kh0WX1Zkjre8aqZRdNRM2gAkSqAHChxcETyfVSyEVNEFuiXP/pNPEZ1?=
 =?us-ascii?Q?W15QPkyhSyh3Pk8kNINoOLLcmAxrsI3HPbQl8xb/yNd5ySaWXVQm4tv/vddZ?=
 =?us-ascii?Q?ciAjQG8whIuZLBq7v859QkUZBSf/bywPKKeiSIV/g73f65xYS0CREIJnJ+Ih?=
 =?us-ascii?Q?k7Fsv/15AFn3w69rgl8T9XGNbE6B7b3aOer3BaxolVXtLKKC96BosWxQn9BI?=
 =?us-ascii?Q?VOfPLlGm0TgeKrbgjP+R211mUjabszBdwpNrY58PTm0qExs4HZ0gFiBXL1gx?=
 =?us-ascii?Q?IsPA/fku5pJeq98dDtG/zcLB26jlC8t6l35q7qKFZo4sy7a9T/tLdPM4CSQS?=
 =?us-ascii?Q?pONgrs1qAR7cF/QsThv58LRrdaf63Tf7hwtCUbaCi+XalILaHfX30TOWuomY?=
 =?us-ascii?Q?mxgBj/cJybnncw8hZCxfaWn2ihdoTvfSOVi7T0wkCmnySMRlT3e3H9hkWEt3?=
 =?us-ascii?Q?dXdrEbHxf5fBKMVz+EG94quxCHMt5MdnDGi5n+t2yTgbGhSCBVkuI/tQRJC7?=
 =?us-ascii?Q?NzvcwelqUtbdbUGruu/vyFEtlRxaKRZd3tzvM52VGXdrvBLGl8FWLrTnzJr8?=
 =?us-ascii?Q?z4GyfwDL6jj4aUG1Xpu5DDvjUDe0F4tcjABsPpNBEafnm3LfhBDFA5upN+bF?=
 =?us-ascii?Q?7Gyu/bssgE2aX/emywR2j+/WaJqYZBsDlb7iltLBlFRCQW3vyEeFC98xPzsW?=
 =?us-ascii?Q?S+uXHrDgGFacBtyApgj2wRbfmIUutVxxfjDhUxrca4heBsNGBkJiBNu98poD?=
 =?us-ascii?Q?A9rMIiSr+Zol1wFGGQRvUSLmm/CSWzsWNTmR+4rMmnf/QmocMvjaL4Go8oe4?=
 =?us-ascii?Q?rbHcaFQEFNc53nBPY++f0Sm0+bExF7XCbarp4DqD4wTJYZGjPnKq70mpQEax?=
 =?us-ascii?Q?am7ARAL5sES4YTAvkco9MKXuyGbC8Ot5ym2/gNFILpq3ZuCByzPp6/ZYoWd7?=
 =?us-ascii?Q?j6u6hZXl5MhLqe6R7Hoyn1372BiOvGd2uWmqZP7Vskl/FtGXG46rN/WyA1xJ?=
 =?us-ascii?Q?yRFs7W5xJYwTJ2xqHGfbxoFP7kzu8rL/IhpnXTfQUmEB25PrFG3U9JVYIVSI?=
 =?us-ascii?Q?HPbAFvz0R4CzIQ9PYcgmWjgdq8VPG5s3Q+LgI2FTDUwvTJ82RhfXYQmITtid?=
 =?us-ascii?Q?Vwg7rCtbpkSN2qsAn6gnhcS4H9dbr/ROYPqiCicECDQkx6x5INYGOS7g6ZPE?=
 =?us-ascii?Q?xRjM4w2wxQ/B5AC2XOeMSnfzDBZ35hI1+NJ2dLbFAAZpoTPsjz9QOY1MiOqy?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tCjw9L5+oSUZO0MdK0wS0h10yygU3fuTqp3yAJMhRzcrPYWQWkh7jZ4VLuB5SHTlunchbBV+NkTP/1aDPvBZmfbDhcLyozu39nY9oH/i1VLNWdIh25NVil7Xkj+7F9P0X1tETLy9dTMquedMvqhGVJ5PfHoPMMygTdyGNXrRJ9kXhj2JjxWbh1sm3KSYGXzNaCjWzk2YIo5/O2IJ7nuxcXvZLnbb9qCvUgsFfLvb4/JU4TY9b02bJPj7aMqvlpIoJE9FulatyGv8rdoZCtfxOXitOM879QG6QN6276SQCp9QQvcZ04SIAH7S++CdDb77VmNGdh947qscxoyvpndZoDjok+htvCJcsEm8fT1CfiIRDQrX6Piq+dPm2elrMyR4qRL1c6zVs3/V8dWnjkDaTg6fD6V6q7nrgMUeu4A7EBZLkjACjHbc1/9CpvletnPRkG7NP9PnJsyjQ2Db6EEwqRXbroGNrbq+KqlllMaprkg/YxqWL19pTca0AuPES6AeRhC9z5pOnESPJDGfU/qE1rc1n4LOpiCTnCo6BCsNNzOpUJ+fvTNi3HzxNsyyBBjiAySXsZrAH5K+qFSYeZvusFZcmzw07shnzPQHHKtnNsw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e63844-e8c7-49fb-f83e-08dc810873e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 00:27:28.4714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZeIXTTQQJPwD/Mixtz01+cb2MtJphFlBGTaekt1w0RiJHAXUwlmPaIX5A6B2k+gTeQfVaxZBhh2KAWRa9uQ3lfz4p/0Bx+Hn9LLYRAJNXp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4281
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_17,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=663
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310001
X-Proofpoint-GUID: WTZME0A4GRS69Fk_2_L4kKy7Op1EiNKx
X-Proofpoint-ORIG-GUID: WTZME0A4GRS69Fk_2_L4kKy7Op1EiNKx


> 'scsi_dif_tuple' is unused since commit 8cb2049c7448 ("[SCSI] qla2xxx:
> T10 DIF - Handle uninitalized sectors.").
>
> Remove it.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
