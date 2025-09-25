Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5C810A1E;
	Thu, 25 Sep 2025 01:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758763724; cv=fail; b=TqRjf43Tyb0rSZH+5WVugmSC9GHr6yf0n9Vj2tSgl6/+Dpu3bJjaIpCzxOKSHfb1sFq2TJwCLcjemtNei2yCH60nkGEUV4AkcdUgoLTxu35wEhN+cxKdCJF0d1LiJX+n/zNFdESFcUPT68uSPgPkNI86rcNtyCHumO5qK2LRMmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758763724; c=relaxed/simple;
	bh=V2CcLFJf0wiS+gQ1Ngskd71Gq2BYJ5Fd814aLr6vaxw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=apgL9hiU+JPamMMWxjfQ1dl1/1c9FV8RN0QKxQ+C2ztGCA0zbQjk+9EzH4vJ69H141z3s+hccbuvSjBHEvQZWCnqgYYt9SDWJBhIPWXozWY9F7mDOyeNktFl6orkjKbhfjhVNMhdqYSUlr+wFr6gc6gOaAsEZ4DZuqWB+RiG78U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DAaghPYa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x1d3gr3I; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DAaghPYa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x1d3gr3I"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OIuAHr008156;
	Thu, 25 Sep 2025 01:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QWpK3Pj1pNnWOhZGCe
	yGsJW3gtjEZ0vZylFOksEkzYQ=; b=DAaghPYa5EaITTkCv+JsXBCj25ftbxPV31
	ZbxVTy6s4iq5kXOVMgQoylfR1+4c2rTRGbOt0DgR7kTgxIbA4kUQure98w9sTY4f
	vxoae2iIbE823Palop8riv5b8JPjGGlm4qEYWJaBiU48CxVFY7fYmL6ZF9aG+7Rd
	NhIv0UTIiv9cD5USCMMRWcYusD73JOJlGqbWZO0oVKP3WdvKPVB7gUy3uV0IPO0e
	D/DvyqUTZUgWb1Hq+mzWsFnfQy48rIZdBYMFcIoLYC766/IeY/vzR+bdcb81Tq+s
	NF0zsnAR1ZAuQnubpl/1eRzRUK6Tz0bwTmUMiQRggijUK0bHevVw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499mtt90a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:28:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58ONrKee021664;
	Thu, 25 Sep 2025 01:28:19 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jqacwj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:28:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qbJdxK2KGflDoJeKNvg9bG7+ARthuAeSSu+KkfMuqOLCvCp1E4xaxAbdGQLLReE1Q1W5tvpRqcg+Fd1TFbyjos/ysLh+D2f9vDs9by+NrSEnB7oKi70/98dY34+BKuTRRGVzMW23tQVFCDIRiyTse54xsq40SLhPGpr3Adp2g3hUn9CZ3YlaiPS9h4Wu7pH7uQktrClZXmaSuCVloEablxRgbNT0JkZqdL6YqQqJbzOWu/DAmYu7rOUqthxiOVpVlQ/cQkc2eAofGMWEWPVs+j385XhoZZz0mJXpv2aGGv9r55XXbpvo0xUkFQcU5A0gTFjLbVvHaOrXh94w9mRhew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWpK3Pj1pNnWOhZGCeyGsJW3gtjEZ0vZylFOksEkzYQ=;
 b=FFRcRbDMmBZ4twM5YGRzLKRJoXjA8gxJogPIwvkVbqu2PRpfspqHpqffSjVsmIdWbbHkqPFDDrsyi6d2d9U8j5Wjiuf9g5bto4NrTgNhoYHVyAV4Fm65Z2jy9+udyfqhWj+q256f2d6AbYtHtgcMWYrbQVGQKTn2vNr15ewCjzHowQe/8sZaOsCZ7peJCPrrvc6LTRjeBKkZ/Zb7V9vpxOYGWo62y7WHsFRBHJv/xEWpNC9lPMJv0dtEu/rdumk9PaUGNV5x5cxNUsgzByg9I9hIWFEH3iu7Fiq710sU2m+viIHz/tkr3eviwgwCa+DWHw2cm6o2bYRpdK1KOqrPUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWpK3Pj1pNnWOhZGCeyGsJW3gtjEZ0vZylFOksEkzYQ=;
 b=x1d3gr3IfCTJxOlcB01bf9ki3le3rB9oD+kFgRwpTpvtYdf6kboQo7IaxxekSpdGzKgHlxFm+mKVgyckZjHtBKZSVxtRT2lsjeqRb5a6SUabjhs7Ve3fMflb2d1R59F9gt940QTZHSZXNcgxCPfwjx5delSp8I9vB/78JFI2+kw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4231.namprd10.prod.outlook.com (2603:10b6:610:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 01:28:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 01:28:14 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Mike Miller <mikem@beardog.cce.hp.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Alex Chiang <achiang@hp.com>,
        "Stephen M.
 Cameron" <scameron@beardog.cce.hp.com>,
        stable@vger.kernel.org, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: hpsa: Fix potential memory leak in
 hpsa_big_passthru_ioctl()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250919092637.721325-1-thorsten.blum@linux.dev> (Thorsten
	Blum's message of "Fri, 19 Sep 2025 11:26:37 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ms6js4m9.fsf@ca-mkp.ca.oracle.com>
References: <20250919092637.721325-1-thorsten.blum@linux.dev>
Date: Wed, 24 Sep 2025 21:28:12 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0082.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4231:EE_
X-MS-Office365-Filtering-Correlation-Id: 16be919f-1e8a-4bcd-1862-08ddfbd2cbe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?psJxoWq0gov2go/6ynz779wEGN8yGHA8z8P69S4IvNK6QhI8pGlbMd3FDz5y?=
 =?us-ascii?Q?HBb5R2XnmbJYcO8IOq6WlNKkF6IjM2HGnn8+7+VnmzG5cD6UHP4ivUYTjZo7?=
 =?us-ascii?Q?EhebGvRxCm5VKr7SEMffbfmdOwZHKkBGoetlQ3oKdeYjl4XiMgy0bTiF3L73?=
 =?us-ascii?Q?kSovAy4ZnWvJEVHjpaqzqqW7EgBWmsa2kkmWuXFExN848A5qVrcsmXxcchkk?=
 =?us-ascii?Q?m6rGINlhotQ4iOXBeeaxzPiPSLttgAyiRz+ZZ0I4YLBUxZ3PvfIHVEufJUn3?=
 =?us-ascii?Q?m1seBGzJBA86WOTSmTzlUQW89I0HdH+K2O5/qPf73rPeSW/XtbEHDcGcTNNG?=
 =?us-ascii?Q?70PoVGS96qS0iiNiTA+tvnphCi5XfS5YqXV8VgsN3D2YsuKSCaNEQcphtI2Y?=
 =?us-ascii?Q?KFwQ6ccqEAu2HK3AUWEPwx8w55HAj/LrRH4wPTgNyM1veGoHraeVR36raMT5?=
 =?us-ascii?Q?D1mhKQZ8DmMslFDaNQ8hAxTsKaDUPmTe92SnubPoOeQvpDZO1DICwafdsIXC?=
 =?us-ascii?Q?IzCMtp5fx7wLOtUNgzi3nMFIaO3WLeIG3MG9E77gOux7diRRiyrYbO70OEMW?=
 =?us-ascii?Q?Js5/e4gnA2m0M5WGPmuUu6x1R8aBF+7ht7FutCz+3Yyzcl28ono/u9pEi2Ep?=
 =?us-ascii?Q?ZehqfD4vMc+iQKOik7DAZ2IKy8ZVPLIroir+pXgHqDgQ5l7Ts61aH6r7+rAx?=
 =?us-ascii?Q?sUW2uSOdsN+1HsBiRw906VcsHa4ZiKCtSrvUoXDszASVJJoSi8QwfG5+voBU?=
 =?us-ascii?Q?0tui3IXCOuCs22LADgVxX7uh+w+eqxh3NuZgYJ7JG6rUkDBrNGH04zDRE+xs?=
 =?us-ascii?Q?epE83WLviw2sUhtHL5g48SnGCyfqhdLuBCevKu35DVcxQZk8QxmHvgvi/n1s?=
 =?us-ascii?Q?zbfXDZZcU21O8WfXuIYMRhhPvRY0HxPUU3WqYUJ9q4e4DtjIS8k7F39ThSfm?=
 =?us-ascii?Q?jKQjTR7Wk3FlTTpDqGoO4fa48olv1sBwJMn/Mcn0hjHMRLDUdceYm/EaIsjn?=
 =?us-ascii?Q?W8NYHwDH/xFhPj/nyZbT9hAQ5jh8eXdlCdWbxRkJWIf17oBKA3kv8tXmNuib?=
 =?us-ascii?Q?3wfWOBMlN1bWOHpkMEymen6r+XJe9RnwenK2T73MP0ovjTwxFacHZGG8Uwzv?=
 =?us-ascii?Q?VuNz4ASyKN6hD0XmSMDwOkftLMCqgywlkN34VXYKm3DzMy0KNXGfYP4NOhLQ?=
 =?us-ascii?Q?6WK19elxtv/pOiDkv1B5jx4Vq6sB0D2+TWe13D3wtln3/Z2sZiyN3iZ0l3eM?=
 =?us-ascii?Q?MdG6QndDSyXLouVNXxGXmI/EL9JgnPC1MM/XncNT7HHVzic55egu+tmnWULT?=
 =?us-ascii?Q?9gOaidnyPkBIK4MBdON+M6g3Acy1V6157T5gNMlWfJR1/ocreM9hl44XMP4M?=
 =?us-ascii?Q?cBZojjdF0b8mpfWVS7gcs8ma+X4eA6pbQhcmPtHVqxoUQwXldohZxMXy41Oh?=
 =?us-ascii?Q?uYTCtXwOhaQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jqnXe4fwH9RQVGo7vSmQ2SFt+7+n/OpkSF3yJPdADL5KSO8nwGXMC0gxlHrq?=
 =?us-ascii?Q?R2SL6+D1rjcds3xuplV6n4/f5GdCcNZiYaxhqyk1m/qZXWWI/yhxISygDwyc?=
 =?us-ascii?Q?Wa4VLAbrfcHWCRMWAKjTvUZ9R5FOvv//HOHQPgImx5FMaCstU9qd658d8TyW?=
 =?us-ascii?Q?pr2WfYvHOKS3NBzXLEYpZP/2ZzVKP33AiCVoEgKwynTp49Yx8ApgUl0XJ1xG?=
 =?us-ascii?Q?hcGhbS3Qw+Hrhil4YRH74nS9AjRMyNDkxT0zp4fc9Ow5Kvh93x7ITnuMCri2?=
 =?us-ascii?Q?xz0JtXjbHIOQslwX1ykjjy8yrRxSS8/jQdRgODD0FhGwOUlxwS7Cj2Oz/Qmg?=
 =?us-ascii?Q?gSi0hyql5dR5OCi7YckDCzBsTV54k+JPpottUcJSXgKGtHfGJzzTTFnBnplB?=
 =?us-ascii?Q?6KZ1fsAl0UdK9fNVw2hs4TjFXiSBpoXxrcDNxxY683l+/922fBzoMJDd1VqM?=
 =?us-ascii?Q?D3al3mcnCzUd8rXt2LqWbYVju0jiSKbo3jbk/IBj1qAqtYemeCNNln5bupzn?=
 =?us-ascii?Q?YKAhSNOwPiHTxMUIpPUfG2knLvOa/y+CJ+mLTI2ZaaqtQqrf8ZOomYWhx92h?=
 =?us-ascii?Q?9YU7IpwEgFyW4Q/Si36BE8grtMEJPe+PkHinAAfn7kc0L2dhqcX1xvSK4wbC?=
 =?us-ascii?Q?+w8QurRdzBhJ1esnWFqK9SsV81sOSm+lgqoWc9+HLTQaUvHNREePojnXaAo5?=
 =?us-ascii?Q?/6PZIXa4WoA2PA/dHh1+C/M4Pki8KY5K3QmC5FD38muENLAFwBZxG1kLGWCv?=
 =?us-ascii?Q?AILVPK92doci6q8soRa+FBLl6xlp9juKA78XP7F6myt4Chjc38ojn4b39NJB?=
 =?us-ascii?Q?C0O1xXBbUVoEeYt5pa4RefFvlle5QD/psReH+/EAx1qHw7HUUSELjrzf+dxX?=
 =?us-ascii?Q?JykoB6t7aOVmTpPM+WtZ1pimGXGS6Q+ir9U4M0OZriy4cDsqYeTvqHJeY0V2?=
 =?us-ascii?Q?1n0I6LMfOanGzmsbd5XgwQs/Qx1gLDJju2w0nXSsVqpOhjXQRtsPR7GqU3aM?=
 =?us-ascii?Q?dbrEzO1OObcZ3h84wB9ezE7dtut+8QPqWIEoPvdJLbw9H5vP9BOU8P4QzhMS?=
 =?us-ascii?Q?cDXJ0yz6nGFCQPz2AwnPH5Jl3/rIXoGSF3929O2XjTTcrumfunopS0ygPHHv?=
 =?us-ascii?Q?Shsk45x4cVQWF2gwxIB8RwBGb/RF6lPqtrW42DzUkdDnd7IxMRXVM5/jj0SH?=
 =?us-ascii?Q?1OV7EIiVda3Ss9rpbX/qA79JAW+Ede3URcpZ9sUHV43lE/atMttmiR+whjTe?=
 =?us-ascii?Q?ljfARkt+acjm+qS3Xx44qbxxzeKdViaxceOKXlXeFCkTd5J/6s1aJILIfwcx?=
 =?us-ascii?Q?P7dKWEPs+uqjAfTohJEnbzkhxJdckUavVqU2dqhT4KEePj5vS0UPurF7F42o?=
 =?us-ascii?Q?E6UH1LKhj2OyCSJ1IXBQc/cObuzJmrw+hdWdyNZveV4u3ZSgDCYFeBEWfXLo?=
 =?us-ascii?Q?N2VuT2OeB73NkakPld+/M+wr1NwT+9gNJqi9sYTXeEJnkaXYLAsHVWlLczr6?=
 =?us-ascii?Q?BwJK7WikQUhnq0xcX5UChWNv5nEBp8R5LJpQbx+LXPu55K5SEJPNV1Lp3nkd?=
 =?us-ascii?Q?J4Bjg8UAmGBJE5QJVkPtop5/p4rJ871V0Z8yeIY8m1myaNERyt5jkFkOm7RO?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qTZmC4Wo4BzKL8IR/g5wQQz5cilpseG6BI4OUqvagH0aabio62IFNKceNTN+3lIxnYDtUFcAWc9K6rVxrHI0Q/Ld7iRZmV54/Qo6yMlr/lJsXn0uBEeQN4c2Dyalmj8GaAaq0NR/fTgVZW66qwCo7hQtWrMyYDSPU16p0BsRalnAQCZ/cZpmWhb2HsqPVNcpNLB3Y5rxTs6Cr/jsGNlWOobourjKzhzgijKPSGeO8Ju3EhNmDgHil+a1Ljpyui1YPkXQcBsdsodDSjOgd52gB5GnZik9Ec239yYICiSZH9/6GXNcT6hMfST/gcW/KeHcRbMXcnmUDuPLx6DPR6xPoxcrhxAyt32DljgPvyQRc7CivmW5b6D1uZj+UrzxOM08v0/YGSZku9s+BowHMUitY0taa3xDc8OEJ0cWEJ3G/KhlND5eVTgT3Ac+zf9bYtUfi8VOcEU3T0eaTYaE/IQiqxX366RviXxvDK7beL9pGYZx3XWi0OKXOh09xvtW8hUtDNRoF5N55AwYVRMbD2zrqsZdVx9bGjOdIDyV7fNkI4QdMWrNk6smKLndvLeYxX4mJbcNEZkG9FGM4CAv4wdqup1qxS+ber6r5hz9SDwXLb8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16be919f-1e8a-4bcd-1862-08ddfbd2cbe1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 01:28:14.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TWnu6HjNbIn+bHjWGhv2uIkrSl3F+lDqAXXPU8Edqc1dGeOEQuvnCPxme3kW0lXE0B2kZ4AuJeeA4xZYtUAKsMNx3fzJpzfi3XToaFdGzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4231
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=900
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250012
X-Authority-Analysis: v=2.4 cv=fd2ty1QF c=1 sm=1 tr=0 ts=68d49ab5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 cc=ntf awl=host:12089
X-Proofpoint-ORIG-GUID: iOiyzP7VKr8LF2YdXQRQM_I0cHYFDXCM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzNCBTYWx0ZWRfX0HLnE/2+euqz
 Ybahln7Ad0EaxJXsOn+f/sDd7FEAOOqQ4a9OGJPSW7StjgjcezyvJCwrF9vNAGuV8BTd/pykpwK
 omcwJK1Y0UCYokyyS6Ur4MnoA9N8Qq566qeUFFHsS2+hdHbNpw24wSEGeJfKtIo98UdNJvGD3aM
 LqVEQnN0zsq9iIfq07KIsISOK4yT1o8cNRNq8MyMJZYaZVa0xnDUa22A49IJY+iUBNX3TkIXDxm
 DZP2n+Mmx1EuSCZMe8x9cwUd32tF28s8Nxheh3/weuxCXruaDTzZdDUhphjzMsSavYjGNzlwm5X
 7is3CASVvEyk32l3coPrVXDiEMGCwUsrhdRM6hIeL15bTdCLsYnhNKbGQiqqUni6zWIj7qL8jhD
 f1NeCIaAw1zXEJGNelBi4pk9YP2kGQ==
X-Proofpoint-GUID: iOiyzP7VKr8LF2YdXQRQM_I0cHYFDXCM


Thorsten,

> Replace kmalloc() followed by copy_from_user() with memdup_user() to
> fix a memory leak that occurs when copy_from_user(buff[sg_used],,)
> fails and the 'cleanup1:' path does not free the memory for
> 'buff[sg_used]'. Using memdup_user() avoids this by freeing the memory
> internally.
>
> Since memdup_user() already allocates memory, use kzalloc() in the
> else branch instead of manually zeroing 'buff[sg_used]' using
> memset(0).

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
