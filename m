Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86236FB0;
	Fri, 13 Sep 2024 01:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726192168; cv=fail; b=XyAcfQREnLLWtrcnRDGTdTitf60ZSCffaP/RoQTyJUCloe8ZeIBtZt3mV7FHtV/L+HqjovsjdUNcJeUFoCkta9qwgS0VsmKkDtWbgidDrbe79jwRfUL58GWRx2zri+/+0zoVgaovaXnA3pEJCKMc4pvFDFphwpF6PqJjd04M6NU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726192168; c=relaxed/simple;
	bh=VnFqnMP1ugCKYnysMHb0+ZArEt9Edr+mHyegNLGyXbU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dAjoi9P1kN0DzosQwiAaRJtzJtU37BdhA5GZl3kKcSfuK46f47NM19JJO6hIboloLFsrVkZCWtElS0LuMgha/GIqRuzatkjsMPzb03skT2z+A9p5DXuAXvRCL3qoX0yZUpwYXGoVja3R975LpaJj6x6mqGFR5FXKZDvTvq9ZaRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A1WShKwl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gl69Qqaj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A1WShKwl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gl69Qqaj"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBb6B010085;
	Fri, 13 Sep 2024 01:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=HAqfK04+BuVocV
	ixDwLBEhfGIuKrBRYLRZNBY2oOE6E=; b=A1WShKwlbn65Ow83RdS/yKbPjnTFMt
	/QJT4eOYCDmC+PIqOPkWLkTmDosHDpB6fDnHHKRwTt0N7kkEnAFELwsTrm0izDIi
	3q3smbomZVv/QSCJQTgI0WcSZ6FxbfQ2Ngob85g3/0tCozNXXZWZTzmjjj3IQUCP
	+q7HVx50u7RqfJYuTdWA2Csil0oR4vA8qyfru2TnvXOTWShTUNBHzlOtak9fUaQC
	xfSJDi8gvRFLI4H6INibiw2ls2DbfnLKKVgR3v1pGmO13NY/xHGZgRXuq1y/mkR1
	A6fNxwMnD35xnbzrSAvXBjJD2KLgVKp0vcEl/BAGW3pRJIlFY/dq8YdA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdrbcawr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:49:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D0dWRK004176;
	Fri, 13 Sep 2024 01:49:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c388u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:49:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYc4EAra5n3ppVOcYN43lQP6d1Xvlb9By6x1hAl+CXoNOA/wlsaF3Yh5Jp1Ac/algxv3OfammwbflBlTwOEtzNn/+IOp36bdjH7RMgPxK0zzLcZAMrKO9jYxqqED/rncarRbd3a/FnWrBEKQxnG1wjw4gPTz5+KayBvnFNRprJhpUBVPJgRt0QOZaJE0oIf8IVbEoQzK0Eo+sU6ALb58lVSTXu2w6CzYCvYzrMdsGomcwzN2LNP2lBqzdal3S+5snrRspp2ScR9lwvopBUGbzYhOIoO3MRK4Sn7Ztm1br+Vf26WlHhHPM18I8Lzu4goyvMHXLjaCpI1O8L3EBTFGzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAqfK04+BuVocVixDwLBEhfGIuKrBRYLRZNBY2oOE6E=;
 b=N6mMLzSMxHuYgVGzXY/V2C3Ri9YP4M9eAvFjls/yTuCnHWuJRU5m5v/mwx4OI2wcdL/KxqNw9YxzukgZ3GYUESRxwA7B14TJxP3BNpXnPYgadw20ah6PhMOS+rAIQMMfsfav8E+xSPz3LpF/AdcGJG1/u57uRZJRBCTTTBPEGhrE72i1kkswLd3D7d2D+Te+IiftuAjSfDj1xMN485hitO4lYa9IYhjRhQJ5wfKF17D3+N1uXCSlZPF9wZxmFCZfvj2wAw+SJkMLcAXXn7nP1PcMuXW7/KeZx7ou6REGNWR4Zc170XeQVuViOMVXLWWvwjdi/+iCw6C/4W1Fn/qCcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAqfK04+BuVocVixDwLBEhfGIuKrBRYLRZNBY2oOE6E=;
 b=Gl69QqajLDV0wXRXqJ8hIpRKoH3c0asMxgXUn8kxydBK4mtPfSXzXI6ZtfP4xsPIahpug5kVTRBrkhjqMvTxZ42zfwtT6nbzuHe+O8Op+Md4s3V5pckh32q6ODvR+yGsrBapJEKpSM/FKwDk9h5of2zpsSlK/3TWtv7jYywkuTU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7361.namprd10.prod.outlook.com (2603:10b6:8:f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.14; Fri, 13 Sep
 2024 01:49:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 01:49:01 +0000
To: Keith Busch <kbusch@meta.com>
Cc: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>,
        Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCHv4 03/10] blk-integrity: properly account for segments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240911201240.3982856-4-kbusch@meta.com> (Keith Busch's message
	of "Wed, 11 Sep 2024 13:12:33 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ed5ouxvn.fsf@ca-mkp.ca.oracle.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
	<20240911201240.3982856-4-kbusch@meta.com>
Date: Thu, 12 Sep 2024 21:48:59 -0400
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: c95145d0-d369-475c-44b4-08dcd3963dd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GpEUOckqjL8+Zmg9jqtOrtOIx5bhBzBBFcBIStl2g+VO3dviiPyD+RJb5KRB?=
 =?us-ascii?Q?nz5IxgMBnzRzQomDV2PTkzMApvn8v5xvGthAZWHkbcfpnWU/cFYJYMWTTsfM?=
 =?us-ascii?Q?m9efxlE7KsJrOW8Lnq1C1AcmV9nVuxsXMoDzj0qkP0BwM7TXY4EE6MoIjx9u?=
 =?us-ascii?Q?c1Y7fbDnCmCJtTjhgolvLrt9P+vjG1uF9fv+LzGD4a5bej1gDqFpBwR0D94E?=
 =?us-ascii?Q?zSDN+/oxyPKPSkBg5EEbJusUa9dP+FopPcf8usZc1/ElqRaa323bLRxb1GlI?=
 =?us-ascii?Q?bGm/RiGujKfOpvnyXNpjH2L/zp0r2YyKvRtfTVHLXJxMqk22GxzJql47Oett?=
 =?us-ascii?Q?42v9qhHzDJHOkrzZNuee0UoEVoZSCCXhWV32TiNGr/4XNibOKZVYQScZzD3Z?=
 =?us-ascii?Q?6R7guc7XqmViC8Tv22RlbCSjW3vc+OA0C0I741AXKu6dmC6MPFov3a+JyVM0?=
 =?us-ascii?Q?XFBp3cojYoYxrjQ+pGa32aDnmrHHLEPDxRz8uZ759a5udupQDOFlDSO4eJk8?=
 =?us-ascii?Q?+8AVRgh1CxZM0umzKiRfetWKLTYp8f3sM/ZZ6INHVdIysMwo8SDQJHDh6wq1?=
 =?us-ascii?Q?syzW0z+1/tsjVl32r677eXOFCbmUrgIddwMPa24Zf6/LgPtp8k+LFnU5AFzV?=
 =?us-ascii?Q?KqUS+iH3dOD1Cxo39lvbPYCtS2LVvZgC9J2ZPNJ96bTHLpzKtU2AVySEsLR2?=
 =?us-ascii?Q?jz1tVP8q2jgjLQXx/+jhOO3PCGQzCbNxTu3GWZGauWPrGer5Cw7hY8ck/3RT?=
 =?us-ascii?Q?9tmD41iTLpiLyRzkYMSitYcLk2lQmgyV3rmxVoVduGmxe0jx9Y901s5HAPPn?=
 =?us-ascii?Q?CEuQXDEMZ6p5nXd54NRRwwX+E+s/U6w7bVLGpLZMJ6Sj+Qn/QC/ZZmRwuMkv?=
 =?us-ascii?Q?NCbqVtOHY3ryej6eDSEsXRhL/7MCgwJhXLTeo1YQXe1zDQeYGoyxjYapBPId?=
 =?us-ascii?Q?q2/t2E3m9tr1iKHRc9m6OFuuCTXlHeXDIKCSFs2PzgSDTPiYMPojIPg+E6FN?=
 =?us-ascii?Q?rKdYSzC4BqyY+9kZ3dEjbPgnqMPisKg4Z7l4OT32xploU45e8pyOQLyLaW8r?=
 =?us-ascii?Q?G+PlGZ+MPv0gC2jvemCrn35Gejdpwdg08T26FKFgO38nt8iLyYWaANPWJg6Y?=
 =?us-ascii?Q?ksC1Sdz2a+InDQhAD2VmMPFYX0tcg5FLwruNYD2HzNPGYH8LwXM3W15zxyjL?=
 =?us-ascii?Q?toK+jKlMQNMKjWamA9WyAg7rHa84qeA/JQmHZ2oaHTbt9nzR8vH+xwfQt1fj?=
 =?us-ascii?Q?u5I3YqUV+evdgQcSLuEOMkDSVV5JMYMOc2VlcUbnM9wh+ZwUveZxc+4oCYhm?=
 =?us-ascii?Q?4nxnVw39gAsPovbD8WolQXI8Rm5877KDm4DbOlBbgKCv0A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mSEjnJorH7BXAzg7g8+FBDSkHKHKoRYCHoIezJ/nHaw53xXFfmbqzGSW4w0K?=
 =?us-ascii?Q?d/C6N4il2ZPKiEL1y5V0nWg6jq/uTNZK1PZiWVSzjXIK8ydSLwVCOFEZLD7u?=
 =?us-ascii?Q?OLKjNSziVqLc/Tm1a/xe6wvLTWIkCcwsUyRsTtJYHYOCQTXPkm9wvU6nM9Os?=
 =?us-ascii?Q?Mn99K4wYxWORdZM5Duf4s2KJvWfMYZ+mafIzRbRw3nCTtYV3lfCGJtaCSE+u?=
 =?us-ascii?Q?Vf252qQVDBc3+rEJTJsiVqlXYIWTj+4LxKbcwFgnSnnMw3wHOESh27/b43bn?=
 =?us-ascii?Q?9MVWCO5Wj7e1vujKFsMNclS6d3d8/URkkQpNKdnvpzVdL09fJ7t2j5lTpo29?=
 =?us-ascii?Q?cqx9ekuLb/4e+P5IZV3ujJHZUuoTzXpXCkikkBENNcqDxF6cI6vlnGTOaKsc?=
 =?us-ascii?Q?EOArUPyyMvTOkclh/k+f8+D7wHwM9qZx8gOznpShbHGGtV0UhsksDgWmwKJ0?=
 =?us-ascii?Q?lVjeA1dvHul/B8ieWX2mx6/4fg6wnrwRk/LKtNY5MUU9yNUU3eeJZIO7Ksb/?=
 =?us-ascii?Q?b+PTK+0j08aIESPbfdPmlBq/L1cY9vc7jg8pJmdtc6vRhg37pgjclZ+N+Z5w?=
 =?us-ascii?Q?xi12mm+qe5S+737S4/Bxo+Tknvaxej0q3tIEkthIKZgocS7JF4/4XcXjC6zf?=
 =?us-ascii?Q?8WIFAMbI5DXNe8w8DJ76u1mHxVLYJM55URqBms1y5JHB2zOkPKupXDVPYTgV?=
 =?us-ascii?Q?XWAfqj7SC7YLFmctD2CHsdU0tyElTt7NKNwDAxeXzWCUz7riLBg5ZFsYhg9i?=
 =?us-ascii?Q?sCaJ36qNjIEfzkNRdY3CzZzJiOSOJ8XuoXgWE48kgzVi7rzeZb9+ZfCpabRe?=
 =?us-ascii?Q?rv6BVpFRDuA6c89MKH2J+xF5KXrM1JsehJueTBBdNiqLP06tJRlF8ASt8m/G?=
 =?us-ascii?Q?zmpwb7z8gAhx0KRikHItwY3gZYMQbGxnDZATk/rA/ln5a0M7V1hVS6wk4601?=
 =?us-ascii?Q?PyVz5NCq4opgBR8G0AS9tDWNzKNAaJvUWo7EoP0oGfvsAQ8iLX8L9mHdm0Xk?=
 =?us-ascii?Q?bD3DfJLwv0fmildpSrQaxnl8UZx0FndWdA64JKnMDokPloxyKstWz4d5uljZ?=
 =?us-ascii?Q?Fs/PEPnHZQrQNy03T4epGeybcVE/SMkeEnz6EwwSvezf4r5J7ynOvTv4Ly+1?=
 =?us-ascii?Q?qor71sH9CzEMB/E6yH1xM7G8c+JzKN9UnGSg/jMz+bi8WFvbzEYAOIEgz0HP?=
 =?us-ascii?Q?cuO04FdWm4UAG4YFDSSOSRD8kSW3h6jXT9FnjD2T/7Mx+IxCY2S+0EKhFWTu?=
 =?us-ascii?Q?lQLtzRv9o+kkFpHP4gnkj9Tz0rBZUeby2lZeHysow0daDjm1MLYLScMSshU6?=
 =?us-ascii?Q?FNcnsbItdzPOokKedjHVSINbDFQ/TUTSmOCHcQst5RGCuzLMkx3dFPq+B7LN?=
 =?us-ascii?Q?vO9ik0SIiNcdz+2s2icP3zO3NdW4Ljw/vI9joU/Sbm06KZ+K3QJ18GL5V10l?=
 =?us-ascii?Q?5tLPUUqiuewQ4TnGiX0udjO390ldzBnSCzMqX+Ec0eb5zrFrgIQmWuiKE5lm?=
 =?us-ascii?Q?UltCoo6YpY0aUcotejIqJ/qSWzDEafqR11EDT30/z+ehNnenUgK0PAxbybLc?=
 =?us-ascii?Q?COcsvM+W0ON6aAxAve4hrr3py9OXl463J5gTA09s43fddXJOexN4qBnMjTPI?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DNZeAkbYq1mXs4MGEw++DJaFGhTBnFQyQ2hBDWmd+3JUuURM7/QOcv9WAhpyjBptP5kUzpa6CLBO1wir6Z5k4wLmRQM1gQxNcuWROWqoTPgm9oDy35iJwvv3q1xCm9oubcBT38EFojwe5/fa5wqTmOs0Ly2TdbtiiGebEj2lkRTBLHMu4YUUBvPXpQ6kLUU7M5W/ONOuJp4jVQTGKASZSHBuuzpSuTGE07T9wJVemBdQ5gid81XutK+uQSfVZ2W53tQKtImo5Bpw5z4EMyBEWBSPF5RlCcXAV3b6rYvEfZvJsx8rsLzF3E+tz0WeYj+vw7PIrDC7IUp3TwxQ8cXvLyGt5ayPkUqY4+H8eW0urgE8tWSJc5y95fxTvI4MbQ/E5zZUj7dF1sfXCuZJFFsLYeOrRwCNkeWA9jUtnFtI7mOwtN4lxbxTcHbJeP0mTvtHFZ23BiI6V734ABSxamHqjWvx48woaCkLuzTKaP9+k2TPRaZvTw9gDsJEXL0LuhBxtbMudJyWmHkD+NPZDsN/kBHXoLIQdl5ZIUp6xEwOlwDTeBR+RgvV8SYZK59xlAweoev+7y16ZI5M5v7vJBEGRv+Ifq4arZUxbGRCWOJ45pA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95145d0-d369-475c-44b4-08dcd3963dd1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 01:49:01.6302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CE27HHs5uZljKcjTX/vRfCPuR/rZw8bZHp60q4CO2rUPwsoygQMmocXoqgNzdsjgOTnSNLkKoXK3okp1pl7JOwgivcvqsvH0Dox1icXnK8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=985 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130012
X-Proofpoint-ORIG-GUID: D681TvPgGC-2sTbVeLcHtapJ8EfTuuUg
X-Proofpoint-GUID: D681TvPgGC-2sTbVeLcHtapJ8EfTuuUg


Keith,

> Both types of merging when integrity data is used are miscounting the
> segments:
>
> Merging two requests wasn't accounting for the new segment count, so
> add the "next" segment count to the first on a successful merge to
> ensure this value is accurate.
>
> Merging a bio into an existing request was double counting the bio's
> segments, even if the merge failed later on. Move the segment
> accounting to the end when the merge is successful.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
