Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DF98F54;
	Mon, 29 Sep 2025 21:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759179668; cv=fail; b=cDltmnyWzxs5yUlM2hwad1n5II5bmb02lBOH6wULatU2uSmLwYRluOdIujFBOj2NhlwLlc/js/SB+XV3GZTJgVq/i1EjFLMXZ1p6HMvrTu+B6lB5vs9ahUdrSeVtANwrwHYXR5ybx8hLUzPzi83r79v2N5VEtZ24KVfK4s6ezCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759179668; c=relaxed/simple;
	bh=08aUlVUqIyF6I5q3OCKbHL5zz0aNvCdmzQ/IVS6EyUI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UwBL7pJPGtsXhvKk7aptgiT7r2j5C9kG7r7uPG9s162YgD09w8/txmVBAM5m2qPkqsFnrjKgDqYTIlrg/V88eBWjWc+mFR4DotTTeeMEyuKIGaVtsNC/7vJ2r1H7l8ZBrNQQOMNqsYd0V1McEw40+ra0g2VIyAZwIUL6YG7XUKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZU4C8g+H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ne0pBpNS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZU4C8g+H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ne0pBpNS"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58TK9fg1012120;
	Mon, 29 Sep 2025 21:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nakZM7R/HAgECt8iK8
	8mucgk3f3MHjgeatlNu0q2sRA=; b=ZU4C8g+HEnZwhwi4S4LciTeIeKXDcEDEgO
	W+FZk6xCJMD/AA/uGz0hIRwbJunu4HZuib5I69Kvuj6xOt8IL0tD0ybNLZZKPAXq
	hRZ0uG9nemvRYikhgawJ2ZFw9KnPJV2OJN3pzpEpzOCMjwtIGdW1rddRPmiiCZZy
	MIljkYF46uF8vKsVYAcr/GcI2OB3STR5iRddnJwEqySpfL//CebX8OirzhnmQZL1
	jyR67VzkjM109UI4fKvPAfDYSU3G1j8OePaPE5Ej8+gXrAr9uNu20lU2viAYyxcq
	OBG20EUTE3H7Sv3nApL6qEc5NuzStH74Ag3xtu/VNN1dIh/2Pspw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g0w9g2q5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 21:00:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TL0KXS007732;
	Mon, 29 Sep 2025 21:00:54 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c7xx5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 21:00:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZY7cnI65J8DKkkEpacfwJo47efOAKWD9YJjfDO6TaPm0Ofw4/clGzDnapuicqCIxH2kyj7WMoYWTahs5uk7VpgGDvamI3+q3hjhWkBTKtwyyJmrpPqvQB41ZK5lDVnMVyuDKpzLf5Ei4MF9An8JMVyl9g1WhoVDfydz6mh0OKLaxRw7TsTfscA0ybMUeL0hYOj3MKnr4w8an/wC45+NjsN/antms4EQ1AkKteniEHXyNnnOxljNNrXnbNykY0r2tvv7KVrAq8OZZwX8OuiIqwfsaMv6n9ikeR3dgxeeA9sEVGBNjXRF3mc4GCziFVkXVEZZTdlJsIqbKzWdPXcXx9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nakZM7R/HAgECt8iK88mucgk3f3MHjgeatlNu0q2sRA=;
 b=j86Aewxr3cwsN9eAxSPPHHrEkHqQUiT15BgECeOkEeAkSr3AaVVoCvWDygiZLtZwQM9ke268lxMcWkCiisNOAqJ+e6y3KDnlMpYY8M31iKP94zveohVRNGSw0XQyAjRj/SXN3ft4KYOtT8eF96ZG9Nt6NrMxFyOgNHI52AXCbUQgdGA8m3OZVAD9j6ES28LYLCdt9ClDg0/EX2LnDNLfxcvLX5hG1bmbF7MHzPruv0I/XmLpdRshiiOMawEA6gNvTUYjPXYiHhbmycf6LpYTPL3bjK18assyCdoZP7+DDE/ZJOoLA1rCaVzhsPqDr73MQ0vzNCKGgcrJV6XD8zEQQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nakZM7R/HAgECt8iK88mucgk3f3MHjgeatlNu0q2sRA=;
 b=Ne0pBpNS3f//0mNnuhyr/oPE4wkqISJlBfQIY3veQfiNolnhviw4C2+i3agjljAUIPz5Tn4BuuNss7z2CfucaFR0mtIR7HE2yoR+rbhPZxQ9zhs2b23nTyk2JjcSmGKO7RcN/aFObffDSQ7v8cZ3eHIRYW5VQ4Qpz9MltOwsRvg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5608.namprd10.prod.outlook.com (2603:10b6:806:20b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 21:00:51 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 21:00:51 +0000
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van
 Assche <bvanassche@acm.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Zhongqiu Han
 <zhongqiu.han@oss.qualcomm.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix PM QoS mutex initialization
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250929112730.3782765-1-m.szyprowski@samsung.com> (Marek
	Szyprowski's message of "Mon, 29 Sep 2025 13:27:30 +0200")
Organization: Oracle Corporation
Message-ID: <yq18qhxnfdg.fsf@ca-mkp.ca.oracle.com>
References: <CGME20250929112740eucas1p284c5c49f54fec23c55260edf07aa1138@eucas1p2.samsung.com>
	<20250929112730.3782765-1-m.szyprowski@samsung.com>
Date: Mon, 29 Sep 2025 17:00:49 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0301.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5608:EE_
X-MS-Office365-Filtering-Correlation-Id: 10e85d62-6309-4ce1-c9e4-08ddff9b45f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uWGHo5vvs/HGvT+C8S8/wFzsqs86wAFg/DPfTcUlEv4fSoQUfFTgLScbhpWh?=
 =?us-ascii?Q?69T1kjFhhBisIpCVDREma5zmPEhtbW9tVA4L2OgXyQ3qN5w4MDTrfgABFIP6?=
 =?us-ascii?Q?GLn3dWKsSCFBi/dyAZJczGwC7V6CUSwMZo2bCJFuCdsTVyGba3MzDfX8PTH9?=
 =?us-ascii?Q?iSDbE3SCvVKy4KiIGDbqvsB7VMevYGPTYuNG5N8x88MTvx24mUfIDOrEQjVo?=
 =?us-ascii?Q?uAS4/wY4YaZJKVgDq083G6UBWqN5NXzBzN88yYBWlnU8wSmXElka+7WeT6kI?=
 =?us-ascii?Q?Bw4+DM+JIRUgXBbWVi7lQ3IfPUCqUuyJM58QZglgWJlr574h3/qNYxaF0v8F?=
 =?us-ascii?Q?XCiyG96IZe6FFLfSiNJD4fdTS3bKLaktbFYdcsoZHeD/3pzcbR3eoOI1uTu0?=
 =?us-ascii?Q?gw9V099RmlJ1FrhK2eETeb2m3U/CspNi7G9ksQ8IXhFfKzJxTLMFzB0B7J0d?=
 =?us-ascii?Q?GQ7JK7RgX3921zHUqC+pLSvoZDhdWgojD+TSy2TGxJZ7XhczIOJFh1xUPj9D?=
 =?us-ascii?Q?myY6p0DQqHCrKRjPp0Dm+zjULniTrZXSiGv5Kr6UeCvueJESwytc+zJuMskV?=
 =?us-ascii?Q?EenElh1v8syFhneErEA/fxJMKSvX6GwE4Y1OyeQibrs7/A4g6T/PcHYxYeKv?=
 =?us-ascii?Q?sQLFGxy9y74KCUPGPGt4D+YLmHHNeyzisLOu+6JhpqQuyMfVwtcHiMlbNdmg?=
 =?us-ascii?Q?6R9S8vXtSNyHvu5b+hY4VTtnVjbedyxSs5C6Sv+HlLg09y1wJhQNxGAFa7G8?=
 =?us-ascii?Q?+v74TQjsWYLBc6cx5gepCc0uJ/2FzqMsdVwBJSjGTp4/0MT2wzBJv0JY8CY5?=
 =?us-ascii?Q?bbNnyN3PxXvW18LM8xJTwQdsVWyQ2xwU7ywxvj8yBIY1sA/PqgLjbS70NPBB?=
 =?us-ascii?Q?W+jkBcb36+bVFhwduSpUtfAnryHGQoEljxilnExskJJ5JLOeaYiJHuVJN/uW?=
 =?us-ascii?Q?4g7g8uiahlsQcqwyf6GhWbLqxU0AZmQ2yS0mFfyk2CZJxnNOs7eKmIQLuQWY?=
 =?us-ascii?Q?2bAASM07Mw5UWMaR0utXRTufclrFpYprgnolXVhBf7kypfGhg9H0Qc4SUCKy?=
 =?us-ascii?Q?iG2UKFiRIKl7QhhwBicFPcLLk5bbWdXJM0qLKAmB2BVAjFe4G4geEbKTXb6s?=
 =?us-ascii?Q?RurFTaw+ik2SszbJLYf/LD48Y6eAzRQbH+phhc1U84oGAtB/WnyikR6Y8JLP?=
 =?us-ascii?Q?6c1fjdPbD6ImMvHpcu1qcNuFnror9p3sbZUKQyvdNSsiU94t5EtYmvU11vxc?=
 =?us-ascii?Q?LAJ4hb4tm5d8pZrrrj6oqIsqjXyTwD4Tyb5I6ecBfspRPsTSEB+O6Kn/1DC5?=
 =?us-ascii?Q?CL6Gwa7eEmDcW/BpH+2JlxhBhSDNd4jyUYAWZir1AelXk1xZ+ylfj1ucluiA?=
 =?us-ascii?Q?41FH4itM+pa4ZqA4Z5sJaLHZFiPqNEl3kp5prXfVSU+MsgWYFxHcTklR6W5O?=
 =?us-ascii?Q?pyirBXuGTojb/jTtqGQCOXCDuQJ8LveS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B9JZaOqKMBFoA3bmQ96yUj3dUjIhSODgRTYKImlcGOFgQzkgbr2Xqb2qPrw/?=
 =?us-ascii?Q?IbV89gVeLDX5cErnMf9ydOTI56Eb0rjF6IUK/9cxcWZ0Cp6b4H1JsehyvIDM?=
 =?us-ascii?Q?02Ls+XfWR1JfwJAlLqzqseWC+7LPsMW+B9UCcaM0ts8tZ9fFGZf/vle30ioH?=
 =?us-ascii?Q?PvMY11W6SSLKNNf9Mf/BJpJLKwJQ+ub87fpy2tH/l3+iOJDM2l0/3Gi/yYlu?=
 =?us-ascii?Q?WDp61RunkmSoqZlDMIW/d5iKpOL8yAfqaidqeNbtc+Ot2j79FKFFeDNfajWT?=
 =?us-ascii?Q?vReAvnJoziDR3TWs+GDsEjtYH+TofKQwBGyHuegyBbcdl+DHTSIjpe/1KJPh?=
 =?us-ascii?Q?JNyy41YGwv1LgeDgOql3a+4aPxh/A/9eTrc7aKdMIn6rjR7a3BwPxzwqxcpB?=
 =?us-ascii?Q?FNpou9xgfed82PYsGIIHzra9p2S5lRGF/3Wi8pRUpiEnF2Eh1FZNu2sFjvVB?=
 =?us-ascii?Q?PPFjvM17XJME1xH7LuK8NtsWHkeDsIInkRGIys0G2LNM37EwU6Mp4MyvR9fW?=
 =?us-ascii?Q?xuKADxbqZmAn14nVx9qeUD8x98li52U1ZJVCNzoSs826K/D+Njbp0eZLRCO1?=
 =?us-ascii?Q?qf0iaC82qzwG5d2zUSMYtoqaASUbiqKq8jbX6mkvvuPttp//Kr2+EIOLhS3A?=
 =?us-ascii?Q?jKaobW8yI6WSp1aR63I1DLjArzhoUocrRsDonNbAT8R+klr57KCIqdW1Gw8g?=
 =?us-ascii?Q?1HlyqYqipvVoqpbQDYUPdQuBZOjWd7l76nL2RNeQ1/yJF3F4dySo+RogDH45?=
 =?us-ascii?Q?ezlR9q2mNriUSbwHvzcpWk/PrGitjIwnjubx3TreHSx1chIx+J53Fdq9Fd8V?=
 =?us-ascii?Q?NfYIQkYeqXbIXPsMaEZRNVsLdF0HKd5/lkamQeuNHfDiX/IxTjG+qa3hCQzT?=
 =?us-ascii?Q?QkpfReaeTVj7qvSVXTtV1+eykodQdWgugKKeh/JmBK7kSu4DREsO/B9n9puO?=
 =?us-ascii?Q?dkHFz+SepQWD4GiiQsQRKpXQydqKg0XtMdToSEcoDGy2lKbcLoF/FCxkpJN5?=
 =?us-ascii?Q?0joAVIpp1HldusUzuMA+qLynJWRbUIi5A6XAHNY0PlcsyIDvH2YpgsPDOWiH?=
 =?us-ascii?Q?7s2/sdQLMTMQNXeMgiszq+bJKEwPlq+vELRiK/gp6+tGkFAbv+SSL/nT9DnY?=
 =?us-ascii?Q?EQ1JM5V4CK/dQBszFuBcg4WbLPH6coxOha0hb9IiSmUyEKkB41lH/97HoWgH?=
 =?us-ascii?Q?IOBhHoKnjQ4VpYv3YsH1RHvV8PqJ01sFCfef+di0kIsJ7V7TuaSFBUczvZca?=
 =?us-ascii?Q?2ZX0d6ySv+cxVXleDV57wmP5p+C2ojhbDWa2/h7Z5gc0Vx7Nt+fpXqrKUDp4?=
 =?us-ascii?Q?0FbUAtODgVu40ELjBlPPnx8hCb0SXWU2Ddfve03T4+qvN6KUFbn38hQIjGox?=
 =?us-ascii?Q?G8HPg4OmqzPLhyG0B22PIyDLlPxgkIhSt7iJXLsE4//ibwX+8bq/4evrkxIk?=
 =?us-ascii?Q?lxyad+hD5n+KWWTaxd4YHFw7zJrI3qDRqzGcSXg/DNZDYcKuW2gSt27LFy1v?=
 =?us-ascii?Q?RIImBu69EZBeX/otMmAuiaokL3Ffm4OUskIQRyKxA4aeNtcDjMtbbbhk709Z?=
 =?us-ascii?Q?w/gr0bm+P4TXfQx62RGbCW7bzOHIYlVY062tunpnxXu+HdJ4AfajUh1Hqarw?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FB0haiiqRH6gYwjcSlxDwZVQ7qCgBS+8vpK7a6A4yUBlFvbtnBkRRWuckj1xMie5AhRQEWF+6n3dV1tdbx0Kx9+81mujZnSRmFnSIt1voa6D87lPLymdFEq9fuJGNc8wUIBcJa89KhUNHNrHLUgKOLmGWT7+3ayKufZBk6Y+S0QIbLXlvSWsPnFOYAgRHbPIJTQLfCiRb3nnZT65iUYKm+6nHzRiRQm/VvjSCo0eQT5gjdllYEpyfaSDvYBXJ+2S4L0DBE/W6PeuXvth92gM03codzcebqyRuJCsBMUh7cqDwjphe+59Le2Lhe7n3O8pa1ovj8WZONaGMjtI7j5ZaABfXikmFFwMHgOo4X35tL5oWsC8Z5b2kh88NxLJwgwiKVYCYbFBiMD2O83/CoDuQigz4XBXIG9DfJVdPNTckn0bCUz7zBe7AbBnjA/hMAUeI2et6C+7vxpZX/w+/xMUtcn2/kh6JyaZDDTJbCnwnTUEqkqiLx9kGjrGfxBKcqd87jPWpzDNn4Y0FuHUpi6W8yP9G88gyIjChYoIuB9nj0IT4XtC0XxjxtWM5J+MnnGaGId2wJcEKA4eZVPtSKe+E1pMYxmTw/aMZJS46p0gieY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e85d62-6309-4ce1-c9e4-08ddff9b45f8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 21:00:51.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVsvl2UwX2wwggPxnov+WMoYMA0GOXjDeyaWq/1C4rdBNySvFleH3zkQewQ5MNK+c41Cv7VecEcH8CIyJd8buCIcnVZ/rW9Niql+ZyJjL3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5608
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_06,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=780 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509290195
X-Authority-Analysis: v=2.4 cv=IauKmGqa c=1 sm=1 tr=0 ts=68daf387 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=tVCE2XYSQaLklwrAeloA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE4NyBTYWx0ZWRfX73uEaQhTVh8C
 wIybN4LmvqiEDnolgrj2wXUSvtuIxtdHarVTGLyIVtx/H8DozAAUs2xWaVIiveeqwyRCoqBCS5V
 lP6xtpPU5xi3++qssS16zQVu8NIx2aPL/Us42E/Hlc4CCgvsbto2b4ZkwY4BZGS2jm+fPzbIb+z
 MASPL5nIpvRjQ0bP39l/Ycutb9dTq52BtFPcF+virSLhnO1yVTJ80jDOffeUgZlZ+NZLnKM4TMW
 6cAdykCeHFFQumg3vQNcD+W4IEg/BdLcZrhW9yVGxuEgovoM71w4oSF9MYeKOlfOvxHK6QIC0+/
 9Y8s3kv1+5gG+VSJkkEucXx2iifkdX2IozYRsEqTT8FCCinrImgOEjxTxOsiaAFnY4VNmTrfumo
 56gOIv+YyrDmmeNGRDQEBu/ajspMNw==
X-Proofpoint-ORIG-GUID: aYk-2v-mnRUel3HKC54X17P0J61FAE07
X-Proofpoint-GUID: aYk-2v-mnRUel3HKC54X17P0J61FAE07


Marek,

> hba->pm_qos_mutex is used very early as a part of ufshcd_init(), so it
> need to be initialized before that call. This fixes the following
> warning:

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
