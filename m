Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76B1173;
	Fri, 13 Sep 2024 00:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726188370; cv=fail; b=rixstryDLWDoTH3EgP06oyoQRk9+F75hccI4qGQ/+HJ4kZOO835HFbWvJDY/8yLoePaw57dx/ie9DSF0JQXwOotAqhoPy+rG3tt1AbCBylPA7WaID1I4Ac1a+x/phtrwcGFNswWMe4hIHLx1HbdIW4tbM5IqiZ43krGoMVHYB1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726188370; c=relaxed/simple;
	bh=z271yGx53aksgV6IjNJCHQo8SWBE1eFXCuBrtgqbquA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=B/OSEMU07J1hmzhoi8sybQF5h5BDwc1sbqcimwEVDLS/Gaext+2H08/pGmCbr3W02cB8bIzmREHKzD+wFpdS6OnVUyHkKEVr8Srwbngd8MmcgmERCan1qv1MAKy/GVnF++2mH/osectd1+W0x26uA+dT897nkHl7LAhPDuxKRx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n9qV4beT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yZO13qrX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n9qV4beT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yZO13qrX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBW8K027786;
	Fri, 13 Sep 2024 00:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=l0k3Rls6/zVFHZ
	4sicemlmmog92behQ9+r1Re9hKrS4=; b=n9qV4beT4vwli3cHKhuKUgzBUqfof2
	7aJh1N1mIZyRwdzvIJSyJ/7aurd9g5FdZhu4en34nBEviCiHA5fkTo+ok5mWi2+/
	vSnvRbYf5QnLa0DSVglhydMU8z6ojULI7q3q3NrsNVLvB42ctg70IVYruP5n4Wry
	6oMNfoOHqDC+nYhFVdEco1jViBF6E3xizO3qX1s0Y3Mqy6zScUlI346l7bLAR53/
	D6O3IU4jtBt1Hgf6JAoXC5TSZFfJ4T2Klso3bpVrOAwrDnSH+VWkRhkx2+1Z1vCR
	a2g/qNPe9Ov6erX7IRAMdhSONBTOiNumLhRRc4A8wgwBc9/EiDNZjjAQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2v9jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:46:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMLOBN040900;
	Fri, 13 Sep 2024 00:46:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9dn894-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:46:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rBU0sVKc51FO7o7+mdFnoRIBoiKhjRVjfa67Cn06uFNvdfxBh0gxkdku9+SRC6Xu09EtENDLFYOFgswMrkMCd52bUGpXfLbuwdD1DLO67scsSxm1d8QXdxj8SVuGORMQ5hm5V8zqrP0UWSSuVkvSUAX9OWTW8JGToutWKlbpoFh7Gpu8W1ujDBmVkkiyl8kyamTNR0onpHSdywxxGmPpyPVsm74P8Kx6FMgQ2zjhvYgZufOoT5tkB+A7Q0DwVp81OfX6OnEMo9P6ns3ewAtCNZpO/VGhI54D2utyw+11AuomtA41+KpaQAkPHC76T5u428EwTNhqjhfNb8NMUQ+ITA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0k3Rls6/zVFHZ4sicemlmmog92behQ9+r1Re9hKrS4=;
 b=VIhrCs8Y+jORufLRHlEFs14WC1/aQlA5KGX6jvs6V6wqJWX9pIhz1yaBExxLfhQOGmPEfLWOnWZaqxM7cV1l7ONoeQYRw5IdXKCT4vy6SKefO2GcuPPJau5GzPLZPXCCprUgw6e1FLRJlHK/WPMWEKWwO74lnXp2OzGxVgQYUhpOPdinJbgIe+DtT6con5KNUvybYBoADtwo+WzY1hJE1QwZ9jg5bCvymXdMhYvQevZxZf6xAuwz+3Milcz0oSukke0T0wr38qbd38PSc6bO4YccYRPSWbqWW6iZBU9dwLmh1CeBxDrnXlEdh0UTsTuZUeVT+TgX4p0lCE9xw2qaNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0k3Rls6/zVFHZ4sicemlmmog92behQ9+r1Re9hKrS4=;
 b=yZO13qrXNObaiNjaUkAlDp3JhJZuYouo+26f46Rg5Cqhfo+TWfUck2eTywPFWj8GzBiVupB/ekOvrqYsQJtO1+Y/0mjHwu3mZ25SIaVo68OTVkjamjp0aiILvz2N3D7ZIGW8KiaOmvTphlgWQDYS8vPiL1x89EYP8+8BpHaEFO0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.8; Fri, 13 Sep
 2024 00:46:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:46:00 +0000
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: Remove a useless memset()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <6296722174e39a51cac74b7fc68b0d75bd0db2a3.1725690433.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Sat, 7 Sep 2024 08:27:22 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ikv0wfcw.fsf@ca-mkp.ca.oracle.com>
References: <6296722174e39a51cac74b7fc68b0d75bd0db2a3.1725690433.git.christophe.jaillet@wanadoo.fr>
Date: Thu, 12 Sep 2024 20:45:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4821:EE_
X-MS-Office365-Filtering-Correlation-Id: 30224136-c5b5-4419-6dc9-08dcd38d7033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DjMYa51kTWvsz4V4JMZnf6a09kObHGfJkuqx3yfXvJXii7LmBwvVgAT/WvBm?=
 =?us-ascii?Q?0CcVX8E9AXh15oMR9hg+CGNaaOWSYiLkoSNK6wqprbQ2SAo8hyZI6tey2o0k?=
 =?us-ascii?Q?7p0W8tto6ZeweXLMCX8yPYAXcUP7+AUskBHD5vrAet6Tw8B0a5UqtKsvLDUZ?=
 =?us-ascii?Q?BDTxyTCgOWJkOONIZbnQBTfzIjzQQu0YdiWss5wNLG2jSS5INpTmooJbccC+?=
 =?us-ascii?Q?7O8y6gNCjy/5XPKfDsQczsNtc+aPJkUv6oLC2sg5h2xA2Q9Jgrvd1arNSRPL?=
 =?us-ascii?Q?a/L7jXBr+XQeYRQnTtZf+ZWZvFVsP+SvdaYwz9X8txB+Sle5i534eI8uOm/E?=
 =?us-ascii?Q?CIssgnRRE/APaDyH9RSRMeVpxtytsOu0EU//Js0bcoKq/4OLB6A9rASikaiK?=
 =?us-ascii?Q?qhS98b6CIAx0RdB03vBuIno45hUe/xhLMo+TbnPbDibTBmi6HhsVSpnx9xwH?=
 =?us-ascii?Q?T0Z8yYAMDPHEmQVFSCG5TqUJT53VqdM1npWLy5RTIOnqs9yspCFxSBSfrd4E?=
 =?us-ascii?Q?muq9a84HHH8vFCJ21aH4T29H/KUnflowXqhniaPaqk2z/38l3tff+e24ORei?=
 =?us-ascii?Q?squgG+Djc9200Y/nRJxytXH53Az1rP5OCHdtoyYTxv2g/RFaBt8G8zmmsUzw?=
 =?us-ascii?Q?an/+22v+D2Rx+NVyJrJ6AQJa4NRcZ+c6GpeH9t3hUKQGM118erf15ZL6WnR0?=
 =?us-ascii?Q?o84HI8I8AE9oUMVsoC70pwuuPcGvoZ0TRuS8DgjdC4LAWvD3VParAq41hSHM?=
 =?us-ascii?Q?atr8B22TAeO2Oz6Hviub5zPhhPZoijeuEm+oiB/0eJVCpNTT6gbHz4XwJxGn?=
 =?us-ascii?Q?DLBat8N3rEIhBC6YxV8xyGi1cZWQ1aXZeorXrkmk1ZVlsAnEVkeEPdeh1nH0?=
 =?us-ascii?Q?DLvrFmQ0HxUDf34KzME9rfUWRORzUgRgHL7ee/ooO6gcpUohumNvNiMtNnGK?=
 =?us-ascii?Q?7SOoV5CgcRUAYlO1v1Lg+ZcRQvM+nimIxzRZAK7CGdVlYG0hIsnpocGKf9Cb?=
 =?us-ascii?Q?/5BUR/iikXKI31wKnNq1PkkxioiM7595IY4VUpRU1jMAIQFUwDm/h5RK/XN8?=
 =?us-ascii?Q?v4E4F64DRHRoiakPbKTDi0HGr0F2SSYykoPhofjxThS7jNG578bN2pQvraDd?=
 =?us-ascii?Q?kHKIqDaxoPshvhVMvl/783X/blmaPcKflTcWR1PuqDi2jdMxbTlwlIXPM8Zk?=
 =?us-ascii?Q?HN03cpkfvM/3KaOau2NJA3FUdw45yikNyYfXN2dplhRmKC4MrzcWJeyEaZ1s?=
 =?us-ascii?Q?8+Y44LfmV80kURzDRAbaODzIiEkdjLKMK9GKDaN0UcWzdD13MnZDNi0J/6hx?=
 =?us-ascii?Q?KzXhX7n1shsxuQx0bGf/BjA3VyqRJKQSic32vphnfm8yhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bVtmle/GbB0Ui0cpiWPnH00+CaM2HM5GG3Ptcdl2Y7yCu0E/ogB86cvBEi8Q?=
 =?us-ascii?Q?ig5yNBWT1S79TG6MJAoHZKNq8n5+UnOwE3KKs76XraranVquALUJtbB7oMIB?=
 =?us-ascii?Q?vTfkBHDRtfAKYG1s5sKCL4Nc5veX2B8ERjkOyKqJD8bUgtkkD6S7bJzmzqG0?=
 =?us-ascii?Q?j1sNuAKbzGSXRo3UINHUUmmeF3rKJZ0+IriS9dVicaNaUn2Ril83uxcgadiO?=
 =?us-ascii?Q?eNZXIGziXQlOd8AYZaUXnQCeLdTsfLQUC6MpyuAmxsjra/MIP1a76V52sz6l?=
 =?us-ascii?Q?tqGUjlEWDOrtBXQJ0kzlpgHHlfDxrpv+OxF+THrxrdROqNj8v0IIp/1C3N9R?=
 =?us-ascii?Q?nooPrDo6z+zjSKRlapwcATwdqAf6MSe/k2UpAd7X9SjSy7oF2CcAKmSZqjyU?=
 =?us-ascii?Q?S70VRpuoIvW9tgepvpd27Y+j/pgQ8bByscNZ5zXZTbHb+kwNtEo4vqSXmiSQ?=
 =?us-ascii?Q?r22GqymXK5Dg2CVx6SrAmSp9tbJBHsloIIMgfUUG/YhZfa5YrCwETmdvquWR?=
 =?us-ascii?Q?VYKTOjzrS1+KN7C8+KPYngcmfK+Z064IJchG2ab8La/exz/3I01C0zgBGadC?=
 =?us-ascii?Q?1OFxEPhhubA5Dy3plp/jN/v+ubfTNbcXEqtgxP3wb5Wq77crQszhMXz1xfT5?=
 =?us-ascii?Q?b+YkNqZJx7u5M0fwU/eacuJFCbHmVBkUmq1lgPtCeDv5q6AR7glQMYDzC9MH?=
 =?us-ascii?Q?c8nRDEYCfdoFd0wMsOl/35u9X3Gx3zoJCy9DsJ4hstofEvjtFzOi48rK73Hv?=
 =?us-ascii?Q?PWxhMlEv7taIZmSTGhQQCe34GYPvlFR09TJ3oUT222xUHnFbiyyiglrqCJHj?=
 =?us-ascii?Q?g0NwseS/wTOAWf+ejoQFpO+6FYmnv2DBwOMcqrsQGWTQduwCQljO99ilWY6+?=
 =?us-ascii?Q?kVFsDtp0pNa+rRDRUKD05ClLbNGjmvYJYQfXlOfOSXicvPiW/bE2/BEA3blP?=
 =?us-ascii?Q?Q9NscaoyTjGvPkF5o1SwvbtbdQll4hyqSkosNSJqJvnDo7N7zJ95er1+s0f8?=
 =?us-ascii?Q?LGhCIlQmY2wtY9QevGtTgsoJoX/jDZP7TVEWgqh24W3+Tj5c2UarnYW2RFYo?=
 =?us-ascii?Q?D1Zbh1VQb1wDU2XXOuUjEvpiUqKzvKStPyPzfkXy2ia35/QUPwer2oJhRgFi?=
 =?us-ascii?Q?Dde26R63C+op5HHXGrW2OQPsX0dxM5OpedtYZHI+k4e4nJHv2UTilD2L2gbi?=
 =?us-ascii?Q?rFYMw/Ygs+1+Za9gE4cnM7caoZHaVC4EFz7iPKoeIXsKYwRLwTxHD8yg5S/n?=
 =?us-ascii?Q?HVuHoupSd2ce8L0v9K64/R30H10iKRHqnV10bZWWBNKeLkpcqxkIZz0Izz9j?=
 =?us-ascii?Q?pKdjpVgkfZJRbmqX/1h6PnsmB+Eo6dlzJHJLrhHJ5JEwSy+TuSJJB6BvV96q?=
 =?us-ascii?Q?8tKKcreRLOVQUa1mdkMC0w5CRwrCy3dDqEcGbTDMTZyzbTS45uz3+L6H1AU0?=
 =?us-ascii?Q?OiWQNsGzMmo7nYESxkYciLkKN/wzX9V1cX1eejpL9UI5ISTieFqfeKAXbH2b?=
 =?us-ascii?Q?uK7od6UJg7P+Yv5r5TfxoNDhfmrCNCpA2f30H14l7UQMKn2mAoz84xiOZ+O4?=
 =?us-ascii?Q?C5o79/J3d5cqbto9wqeVAfD8y9lLR+/D6NVZ7K7/zeUXV+/HBfwpQrsLOrq1?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lMpaMQMcunNKdFQkqQ6ovWK+zA/2ZcV1qdpnnkvLVEqdTY/LaHM/z49fgJ15p9LQzb1YhQD+1SYAbj+Q2xmh7RKbg+IYsCzb3lpGgatF47s1D2YGnIm5wI8JbaPJF6vM6xtGApwOJ2oxiB7hBfaM0hW6BYlD7Rh/Wn3/Jtmku13V6UdKsjlIceMxjWqFHKUvsvT3A73lAtrC/TJk4K8UxaGkI+ntscZrdPxxqAwERyZPeOQUDWYc+Z3F7Enzylkrw4af2339QrxB5/2+d7AobwJSwamjM9/DIDpyuUznijaPU+8Vv4os5f0EndA8TBaZFaDgAYo7qtBw6AYY8FMJxaKtUHv8TT+t7c/MaS/LXFNV+ktvlhl+a28BE6DRrNN9UJHLn5PX4cHv3QspCnIxPL3Xsj6pTho3geI3puEJFrFzrLjz0ti/CNqToIgYGh2n5zK5WTaiLjpUD1DaMzxpOldul0YvckGaxhVzNPLnNWWOQvUz2LWBpenwZZc5upwQ/iOSf3x1eHY0peDF2kyF3VAknh+GztJEIEDZyl2hurZScSzwM7bRC+4JFeek0tlbCdYaX39f66xDqZ/OkSPGkjCXmSeT306sQJLGEe3rxKI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30224136-c5b5-4419-6dc9-08dcd38d7033
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:46:00.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLHSoRmvMIP6uEq6Ki6KGymzN0jK5lqfPOVrHhqVnDnBZNlIZIz7iPe0RRKirvuIrNLseD2yjadI5ZXfGquyy2rrI9F5g+GfWpC+o1P73OI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=855 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130002
X-Proofpoint-GUID: EXLz61sxUPgtvaW1PnVsu2yVerJxTX7-
X-Proofpoint-ORIG-GUID: EXLz61sxUPgtvaW1PnVsu2yVerJxTX7-


Christophe,

> 'arr' is kzalloc()'ed, so there is no need to call memset(.., 0, ...)
> on it. It is already cleared.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
