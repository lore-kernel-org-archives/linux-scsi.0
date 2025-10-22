Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7E1A317D;
	Wed, 22 Oct 2025 00:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761094749; cv=fail; b=kmK9TBa0JsrB6Vwy6YJybTm02zVjw1QFTAJ+gz+GP1wr5WozsnjR55XxR0qgjKI8bhfhQ5O5kaLR2tPzuIxpG7vr05qyCVDmlhLFDokjS2OEeHU185Nb1kf0CLCPNxyzY1QVDoRfNuIEIW7MsEVqmJ8na64u9OoLsYYAJV2ALgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761094749; c=relaxed/simple;
	bh=M+c0g9Zt84Fvf+KIYaar7CbK/YnitpHiFFZYwBK1LOk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=nl/NDzG4J458sEQ+R3OW1NGdN40Kpu4UoHykKyKIagMcCdmr6vXit1FFth3WFmtNJa1vtTDcHh1x086yWrSI9mOpVYjTpr9JdT9QK34aGYZNJgAoI+ar3A5SeSWEQyPJfuas7kJurCHOWTL1pYuzazGiDky+YCbkh/XB+zcpQlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=epzop5P5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JPvMM31f; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="epzop5P5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JPvMM31f"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMvIhD009197;
	Wed, 22 Oct 2025 00:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7vxnkkBU1B6W/4Mm1S
	2RYiK/5xP3ZwMswWMGMu+OdDk=; b=epzop5P5Rof80TblUu3cSKoB/Y9c8ta0JN
	uiSNGxbJi2FZ6dT4j21bowQgyyGj+X8v8zmOpQaPifQE7Xfx+0ugIjI07f3IjnZj
	f8xNg7mhM08dn3wHFlh2cV5P9jJgeamCTSj48z+e5+INs912xD8VZei73e69BQJr
	Td7eCGEyCNW/JaTTOftJEkYESdu2Ojv6k5XVIW3u4TucpL3sCppQUNd4NzIt+PPg
	ZhRJcyVUl1WR/yQpsWwRGagl1OL3aomx5wb8r5v4FFdsz4xyRv4QnRwOug80DDSM
	dCsxYS3gQVnRDe0Wl9ZN/bvneEpVP3IN5derv6I3W3C0LJ/TnA4w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d6udc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 00:58:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LM64ht009337;
	Wed, 22 Oct 2025 00:58:53 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010000.outbound.protection.outlook.com [52.101.46.0])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdrxdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 00:58:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KGoDP91WWyqnWmX1MZX9n/i6VnRbC53yj6ETiBUKSr7C1AAOVY5mAYagqLfM0dATSKtLUu5L5bb0EzA8NkY1z3k3WDTe6kdy7saIGH+UP9sec2fs7Efme3tYlzh5+T3ofKz/LnGTVJtfpbVa3h6mn2JzrInic2Gha/gs61vBT/sL++ncmN6QLiDjxS03wW3EF4+g6HVjWjuSHVF40m7Zfad1asylPFns6tUU21Ps8iXJ1laH31jSmTY3RbeLfqjZNvRtz8FMEF/BSUhV+1gWuCzDBv28eoLYnvExudFfqgJ6UnNrEj1XLwkDHJ7WrLz8Y5cmPYY6dJRdoB3VM4eYmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vxnkkBU1B6W/4Mm1S2RYiK/5xP3ZwMswWMGMu+OdDk=;
 b=C8Cz3yM9tIwSp6QkynKPqvdo3mw+s1bnHpGhP3mr0hZ/OJN3wK26Fx31w8UTK62YaULFzN0l/S4BWXIXNKd+4m6IdHZoyIl1kp/7oS9/vktvbFtwh5pEAQ/9/6zo2BF7uuUMv/8S0ZxymJ1c4y6Kf3jFmzpZYmbRIrKjnquBLUAsg+H9hs1ak+La4GqcvTCK9NsB6pyjxhhPnNGPNs2PjD3Xj9CGLyd2hn7tJpNZWRt8v+FEpNanzn4YD0pJCQYq5RXpxubntQuPUzeptBS5KL3BIAsRv48LiH27qPWjmlPFdM+EtDZoR6H+Wqqly+wGlYIc2Y8f9FJcab5BHSMbvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vxnkkBU1B6W/4Mm1S2RYiK/5xP3ZwMswWMGMu+OdDk=;
 b=JPvMM31fHwh554onZ7hFft1E9diybhM5Q/vGHYcLIuchWsae9lUyHgchlSiOmFHDqzpJepX4sHWMQX+uOdbt2Z6de95XM9CfQNGBEr1PVlkp3LwNszzMR6I5iGA1b4/rID75iOW8zH/mEFhfFEc8nArtxD+6t8nZiTcYqmDqAO4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB4950.namprd10.prod.outlook.com (2603:10b6:408:12a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 00:58:50 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 00:58:44 +0000
To: liuqiangneo@163.com
Cc: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Liu
 <liuqiang@kylinos.cn>
Subject: Re: [PATCH] scsi:fnic: Self-assignment of intr_time_type has no effect
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251017075504.143491-1-liuqiangneo@163.com>
	(liuqiangneo@163.com's message of "Fri, 17 Oct 2025 15:55:03 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ldl369c9.fsf@ca-mkp.ca.oracle.com>
References: <20251017075504.143491-1-liuqiangneo@163.com>
Date: Tue, 21 Oct 2025 20:58:42 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0129.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cdf6d49-956b-47d5-bcd7-08de11062610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OHUIoBU2X76mZmX45b73YMHtAXcfcZLEMyZGADc8q207FpuXc4p6QMNVQ6qO?=
 =?us-ascii?Q?B5Yx/Bn7LINzxGOkSkTqNGQIQed/EsEhkfR/4qvWxplsoi8dcUMx+pqratYV?=
 =?us-ascii?Q?D/JwF3H4HLuh0UJ9clRqNo/Fe+rbdSKdhIFAnsCmnNMpgbwlDmDWJ6aK686e?=
 =?us-ascii?Q?R0eVZWnnPI4a+wO4yEXFaP2TzDH0fQLiKoNSqWuLmgc/oLI8epW5f/NISqaZ?=
 =?us-ascii?Q?+PMeGmJxITv5IPhdZiuAHEOb+7Ya6DQ3V/qEENF8izmVdZqLdRbA6Ux3d2R4?=
 =?us-ascii?Q?MJG5fJG519gLlEK1hJJt8x9kGQa+jVBwlrPSEgVWFMjg6u/8lKRDSncR0SZ9?=
 =?us-ascii?Q?E6XECMaqKHtX2Na13ib+PxfdYKcljSFTyJdZ46nLRN3WvjiybqMJGOggTK7H?=
 =?us-ascii?Q?ikBEOJBforSTHf2hpIbHVT6vZtNyltvFSHsKE2AiBVsWBd3mYOCouj56BO8k?=
 =?us-ascii?Q?nWEJjBUhKJkpK4n6/Lz7dFATRw9wYF/1uCdSBZmgtl9dTq8ggc9k8mhW9rLO?=
 =?us-ascii?Q?sWcu8c90sbwlJQ/jf4SOXqk8a29XuD74ay/ndLhy73JfkcXpQCLYFD9+Y/4D?=
 =?us-ascii?Q?w1nq5wWS+vNWiEVLN60Jl3pmUbmupQZXMLz8ZtX9cBumzP4Yr4XP41O99GfS?=
 =?us-ascii?Q?ScH+7wGymFf40R4qKuBegJ66v5KcjLylRdIHzv43sUfjvMl7ar4UyaMZQhMd?=
 =?us-ascii?Q?d1N1WHd/8WEJEtup8lRLlwuCW56z+g4BVNpMs5BqAxml7ai6HP7IYGoaHXx5?=
 =?us-ascii?Q?6IDQygfpk20xwUvA68wN+mCX3S2eLXEi0v9rBAQNVMO5K5yjAascdPccE9rN?=
 =?us-ascii?Q?1Epb3zlIEQb/Z2aMfbByYQKX1as31JONF1hBHcMUo33MtLGb8YJDdqMOaxke?=
 =?us-ascii?Q?a5oQ/n9rXbpgfx5dA7PaY+yHjNE8xHQdQVoEUk/uafOGGqJ5f0uwD2oukZ1i?=
 =?us-ascii?Q?EkcxrhuK11R2/y+WGkcf2F00s7IlkBL7m+5ozZ3XJjjO7U3cEQ9abqCUEgsw?=
 =?us-ascii?Q?fysCxFEbj4NC7KgWHi6POqAVhN4FrEsMy/XH9y2HoAJyEiialVHhk4JinNyt?=
 =?us-ascii?Q?4R7heLkcVqBGV3HlMPZf9T1Fi5hOBw9lVUk/t5C92LZ/TxQgr1HCJlgz0138?=
 =?us-ascii?Q?OyhOmV8l4Jl699Ygf3ePg0eYrOajSGGPpTvr6jyYTB8OGqdUnj8Kzg1PXDTa?=
 =?us-ascii?Q?82SjmRWlYvRlWF8eFkek8FOmP+yxtedt4UZNqxxGTWL5tCbATDHM3jRBSEdL?=
 =?us-ascii?Q?fbu4Tkct2i9uAqg/DmJBMLOVWPXl0yZuXLguAkixlXvXrHApqY2xTpTDb00v?=
 =?us-ascii?Q?DYtiNQwXOfQmhx7nkGpQyvj3N12FFbGUlLwxNlPKlGOUXNgCxnSApk0N8lfP?=
 =?us-ascii?Q?eDi/bTMmZq00dVRC9RKVtndawsDGgYazQI+tqMB9glQ0ZUEWc1mbaoVRfc+I?=
 =?us-ascii?Q?wGYmwmrrPzmtuCABbvn5MVw9Dedi+pWE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lGGhZ7Zm7d5yL+C/gndDxXmqM1+dqC2N4co9BezLYfHiXR19+FOIDMhulDgB?=
 =?us-ascii?Q?TvU59ODEwZ5WgB4sYcHxYc24OtcTB9Cfj08tcRHeoKoPkFxd8O5QGxuEL47O?=
 =?us-ascii?Q?Au38fJxezHsJ6IRdyk1A057fbIBsJArqI1v+OLu+R0AJ+2L0MkFovOM8/zic?=
 =?us-ascii?Q?4qozjcdhMp5MpzLp7ChpyjwiiQ77ywbdhB3GdagfLS3+A3yi8lpAukJ09Khr?=
 =?us-ascii?Q?griAiprLsKNXUU8+Pz2LIgh9DVBCLUe2iUfTpGGCHlx0FJJ3rZ8ctNsDyBtH?=
 =?us-ascii?Q?FDUC+uHlq5mec4jaMfdVC/tclv+tgbeLLWKdfAk3BWg91TETRe7cj2G9G69p?=
 =?us-ascii?Q?Ut4esmv0WnN9pe1svk2g9YWrsTZs515wzhUi3rZBzaLUmkM2K0BXTT/q2QHk?=
 =?us-ascii?Q?/Ae+/49X0aU0fdPqrJZpu81PQSWPG7c5cJggFN0hrUstw+AGCrUIeI8dBjTk?=
 =?us-ascii?Q?5gLi9FWIkgbX/MAj6jdpL/+p3mIcCj1fFO657a/jnqfpNahvm6Ki/UT6FRap?=
 =?us-ascii?Q?Rblatls57N4fmsR4G03aZbvVwQjdSm4j6jPBHUfw9WHE+SbvsVMCDiH0AOfA?=
 =?us-ascii?Q?pLeCKxEAH7/pRGNyyv7at6pHxRg0XPeQJC8WXc5PXnCTH0EFNr6Y3oeUZlHq?=
 =?us-ascii?Q?ixTihQLgn5NkrbkaPGiYp0tJNqFZTrsu8QvXUcoV8/xQjWXXy3lFrRlk6W3a?=
 =?us-ascii?Q?E29g3ENLdzZu3FefUxiyr4Kea2qCETzG5FDQF68BZR+7INZK4FnavBXwK85A?=
 =?us-ascii?Q?8aRQCeAmKHXne7+3XrwCgb86qNvzmuXc10SKQdBgmDj5Ufcp1Utp1vzGVFRq?=
 =?us-ascii?Q?TIk1q3BhrpHaOVErtyhoLCo+TZF7H7NJbpOZszAtEfWFpc5iX2w8SnzHWcmA?=
 =?us-ascii?Q?3RGc6z3u/6KJqjf7ZAB/2cS4t+rJvNSWx7NQSdRKT6gGc329BmkebcaNWYrh?=
 =?us-ascii?Q?rAj9PlWx/XdPPgVmdfLe9olkQRXnjDqeOd0S5AnxlcylpkbfY/v0lLfgduhN?=
 =?us-ascii?Q?EVS2LiU9AgicEbhO9SPyiN9tFUmuY4TI0kB6Z6H8eoztuKyBj/ZgbtgEzrzy?=
 =?us-ascii?Q?n2Rkyr3CrsnVrRB3dYODsrrQwSO5O9Q4BAYuFU1PjQAfy+gbQUilelzxBsiq?=
 =?us-ascii?Q?pCgLdLWWRzQwYJYEcIf5GL8PK22Hnefm/4PK3HZSOdfArOPekIh8Xh2jaoXt?=
 =?us-ascii?Q?Fs589/wkJM/Odx7i5yEKFVFrU0pg0/ZmgjiKNErBqtbJ/z5W59CWFVXEtsNf?=
 =?us-ascii?Q?m03B7LfsLiqU/k/t5YldQ2fZ44mif2HXOeM/gVmUlzUD51AHLXj9eKWafgM/?=
 =?us-ascii?Q?mFrx0x1pbHM5YT4NdbqSHZ3GXGan9hjXr4vHefSibgv0Ny4ljEGYGfayJmQL?=
 =?us-ascii?Q?pjxtb4eK6dMSv7nwtk/+mgw4EZBEHMMTNZ83bPQvhWaRCZASHSJVw2oZjiv5?=
 =?us-ascii?Q?KJLxClQWXlVDcno1yHRqK9mnYtmgsANNYOJl2IUB1kJPB83o5Cj8XULZfSt0?=
 =?us-ascii?Q?ONNnfEpUy4jawTM1sHjI68MYrwEQjRZcPEpqa4bmzfb+tiTGi2q/PM5PNAAv?=
 =?us-ascii?Q?8NHYT5vwiMNXY3eeb3BkTRJCeEsxLMyD1BrOfTaJy4pb9VcLVCg9SU1zQUpP?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+UnjppH5KXJR2hoI1x39HPp5+qDcAA967gZoZiItOdZZWqzv3Z7k+4oRtCN//mIxWFql0+DPLFpZF+l4g1zxP8N6tiXO+6HTPZC2vhNN+m15pMqw7AX3hX4arQt2FMjGj/u5BPshb/cz3vaXCBflNzO2bMgT+L5bgWLCRxL0nIZtRNiudpTQVSaln7sKwuyb5xgkLE4pLfOezgl+RTZxXZeLZvCoV9kvyYCRdMWQ4Bu5dsq+c3PODEcFN2MqdqYIs799MfpToRoloQdnufmwrrgifBh0u0c551HLq++LAE2p2M3d3EUmt4pTlbpPdT4TyS1IkwSCgVs/oD9cuAGpdmAUekOBDumU7VHnVZVA3SVIUvJhz2SLk519ThZ6TkGn4P2nRDx3Mkm5KcOgfXe2dgsLXHmGsebhJ6bzThilgfkIci5FTSokaIm2kO4n+HyjUK/cBlHGjdC0MEOP4UDiqsLozroM0+dis3PRlGmBIwSlOLR9LUrbsjB/UcxRtG9HJXgcK5irw6+6obQi+G4YUxSrFWDPYo7SBAs3zNF7gROn5Ac9qUef2+TXhWd+fY3HSD7Ry88ORbADdj4jZNxzl0jPHR+DeMBaD01HgKJYqjk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cdf6d49-956b-47d5-bcd7-08de11062610
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 00:58:44.1121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Qog5sRYV8kw3pQecrv+ey2KQdsjc/QpZnga//2gwZjYj72vxDxlfi2soT2UpK5W4WoBvuSL8ZRZs7Dwl65J21n2eFTXaUQtClhAxw6O2wA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=778 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220006
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX+FSM9jpWvz6j
 gU9YtdDLQ+lAFVbxqR3mlD+cbfPPYuTJ8kR2Ir4758mHg9G+/Mj4xad+Kns2U9PHxjkV/5QSDvp
 20V8bCs2+ujE6PhGtbtu5g6bvBOZa0D1KHe9C62MA8WKR5MIumlb53llm+6fDSMatQDAvvwcLhp
 FWt6mAq5AAvDVmDask/NdRgwn9mNL/RZWf9TAi6OBIsCyT+uWPmo9Jb6G+u3KqA5YY/vb7W+B2R
 52eEJ8n+1Iq3O9X0gUBiGMPeyFL3Vek+gCsbd+D/7DmxmyBM34/trzBBksEscRrfrfmQjHiHIVD
 gfNI6XoLz1iSn56AjcQG4LRGI3nxJbEONFoSUz66nqUNmgb13nEJF+8cf3IxLlzlPwpciNFytkX
 lcfgrYIbIKavENY2jOltv/8FWN8oEzh0SNMtgPnxrBWWkxxl/Zw=
X-Proofpoint-GUID: BNgZqSA_HQf0o4ak0FtEqWLHDYMwGBVN
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f82c4e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=fdf5QHehS9EIZpnLbQ0A:9 cc=ntf
 awl=host:12092
X-Proofpoint-ORIG-GUID: BNgZqSA_HQf0o4ak0FtEqWLHDYMwGBVN


> Remove the self-assignment statement of the intr_time_type variable

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
