Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CE341B351;
	Tue, 28 Apr 2026 11:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374820; cv=fail; b=Scw5u7VdKKCpA14f+sobSYKwKAfPnbk+6e79MVZ44wKj21VS0qHdrL1qhRexOcJljQWxxcOvkME8vshzh9muNzoWabS9QO6C/VkLIWi9dv00FF8kTa6nmZuEkInK/dDn/KZmT2TkGs5zuJkqesQj1s6lTOuMt7k6WE8JpwXuElY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374820; c=relaxed/simple;
	bh=Wi6tylBs3fB1FhQ/0bPVBT+AP2dgRGuXMBIDnGPOvMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mo1Ms/2hsFYwEciSzwo6ROyMMOzdYOyhGQnKec2Q9RoogcKqK27MZcBRTpkVmrKFrIfI8++r0DBW51j+zgHQd3BZZkKz+sn+n7zfs5mbxoelmB9UXnMzZBqcBifrB9kvL0Onq2x8gy+gvusoHfLg5f4/wJK40/YVqs540axqvSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aSUgmM29; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tob5CX2T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aSUgmM29";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tob5CX2T"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAvuWB2722002;
	Tue, 28 Apr 2026 11:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jHe8r7DQwGQE+NvChkqnP/9su15BOVjctut/ASsZKj8=; b=
	aSUgmM29d6WX6GSkVcPyEUPzfel9zlWUceUvcSgyPh1MZdXdUx0jrwZFo9GGZg2b
	tsiebFVhIFDSlpGVx8u+wJZbuYetXmf/AorVR6+2cjgJGy0ZcZpgF40YPD9IwNOu
	+unZpmgNQUvypslPOaaqE2XrvsAHNWCQVtldybF0l50k9XqpG0IwCS9XrV/t3Hns
	gNjJ1eJPHFJWYcSdYj5fBjA5+GeLuRRxDfsaGIbULV7XyV4BIGfwzAcKgApTGGqs
	vTZzotTg+UeMg5wU1y4BJdJ1GpnmdGZb79HYsrx+VRm73LhgxcIL49P7/8HwOZ7C
	CekEiuzIGWErWDihbDEnDA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drn7t78fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCjEY004724;
	Tue, 28 Apr 2026 11:13:19 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010028.outbound.protection.outlook.com [52.101.46.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2jm3da-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFyWvcK7TURT9OsOzu88E1ttNzx74CF+VmCCYhSgTJc+W2scpA36RWvLBJYgd1HeadVeSTf5VExMhFzdP0XLsMDYTkXiBo6tn+u2LFt8hbs8G+re3qaSWSBR0ih+SgqALukqTSvzEs/Wn+nhU1E2rBPdwvPaFq5vuxp/l+XY8GjJh6NUHhojfnNtNaRQr7xVqfzIOg4e7PhtlJ2TZm7esur5ePIc+Kzk7dFGy7+alhxXY2B93ZexGRWp/HHZ3we60P8EXq+YNNCTbg2n669ao+w5ZFvQrHVGbHBlkx8qGtHxTh9FIto8F/ry4FvguWCU/Kofe2dZRiNknsyAOaGsbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHe8r7DQwGQE+NvChkqnP/9su15BOVjctut/ASsZKj8=;
 b=h6hGKthP6utEQopoqkfk/2GJVe587D79C7RG20ZlP2Oo47h2z3ROXQzKSWwNvTjdfh5kWv9zqlsrTreEm6UL78Yx28RSY0BGjv2CX5u481jL/dfCYgrQ3lb05cOGZTdVfbFFWkANbs+968SIombL8/tciZZKDYuicJVj6xiTMP9mVwAw4ueSnHevPN/eoEFEYmKJ/120UgcXmqmw4ZUgAs+72yi1X1hPEGSffvC+Xttki9uSCJgiEIZMoXEIiJC4C6UEwFQQYwaVgBG6c1v3dpoomLeMJEsaX2B1KLCrZnb+4QxWnb4rKx/s0Rh+WYOEcN0tpTnJw51CISt6cLxBaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHe8r7DQwGQE+NvChkqnP/9su15BOVjctut/ASsZKj8=;
 b=tob5CX2T89lKNDAU5AYEEGUew2NSIaBaIKOOjFKmdHBNxO2J+aWrJ3tVHhh9MCaK5fv2V63dP7y1nNpbp7x90dP9MZyw8YKlGL2ybG9Xu+2qs3SpWexTGkpBJvybnhWZWBptNNB+QbGnGd38hpslPyK2I9lDa5sxlGrsJVLj81Q=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:16 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 07/13] nvme-multipath: add uring_cmd support
Date: Tue, 28 Apr 2026 11:12:50 +0000
Message-ID: <20260428111256.1778475-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:510:339::27) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b6ba0f9-7d51-4edd-5912-08dea51724ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	HkBeGF7mzDEgJIVStNySw7nn8OVdioiRP3CP6N+qbLUXoCMfjcJnP8AVXrWIyUCf6d3PE2pC/fAVAzt4hLvMuD8/CXMuHJ6HAOHdikXxd4RhEz4s21+42NUwxAffQHH09pKXBR9JOfbX/Gf/qpWc+Wnpfec5abGCG8xZcvu8f6zkcxxD6UZFWkkTdbYXt9PsagPVZFKk5cJ5IvVme5rahsemNCqgsZbX3wEWk5kL2B8t0xEwCCUi3Z0FyvwmtfsMi5UIGtCiruzRZQWJsqQKGHK1y12RF3v7NF7kE/qrSnZptsg3wixmVYQ4uvs8Ql7h8VWFWli2gM65XtMAEqutw9DPLy7NvVKaxTihjRkic83F+4/OaValyzihaIWxcSG8obzl9d2eakPP/ipDj3YooIZ643B8TBDZ8BKZFZ7D2y3fLdBSzg9D2eCSQPr8XsUCOnhjc3CtSGwH4zX+/rfxG8pVzsQoliWct12eR0iPhSvd1gvNFifKJnI48iHrkBLPZjbLQNys7W2YobSFXOXIgI0qfLUNhhL3fZaCCBigOgo89cW9e66UMHiDl10eUFiYt1ZDQ0Sz+02iaHcxeNmXGeWaSH25ix1uRW87lfGWiDBRGey7OSKp/mSAKboljiYTTlAR7yTQ7MlQrc9LHxSyzFL8g28YCzI75rTPXFh2cQZMycrQMY/fnmkHEwgtGN3qtyjpZ0D6QgmV+oR8uqVomR8keDiBg2Xr+YTvZ+UnEL4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WJrENEFbjT7hBhiV9gn9oFPSM/2S4ZTjW1GxdjkUe61KllzIdEeoJQJQMQfO?=
 =?us-ascii?Q?x0EuNYAieU7HHKsHKA6g2HuunrxMUfBBMW7txGCuL9C+/esqK7stEZSoL4no?=
 =?us-ascii?Q?bZoB10nNLx6EN+xWslHbqzALl7gKnbPsttxdJxjE/tT5KMC1CgLu9beBO8M4?=
 =?us-ascii?Q?pt8uMgbS0YfgfoyzKYytra4j6pXevPmghl0EwwyPxycDWYRbKAFM3iQe1SW/?=
 =?us-ascii?Q?UzgBA2B2AKOyA9cCP6wp+sBTYjw23CSQKdKzr3yEClpURGC5CQecfcq6/irt?=
 =?us-ascii?Q?twInQVCi9xQMP5y5O2U+SoEODPK2YVWH77IVNXGxSgwvi9MBKjU5BDUiPxHd?=
 =?us-ascii?Q?jdCo6DusgPD9hQ4AnJGHYXdUW8eZtWUf1x9H9UOAYA9Gc6XXEtC/Zk6/HS9A?=
 =?us-ascii?Q?TWF73tZAgBY6U7SNK0yKskt/UQM4lUpI1m/KI328ic7bsW4d8t2/z0gw052F?=
 =?us-ascii?Q?25gkFE3C4aZSf4+3aC/AGv5dSrckFh3lQUjMsx3dW4Jp+/F4SzGFfljUtsu4?=
 =?us-ascii?Q?OmT746Jw7Mr1SFY//DAWvsOj8pX5/92F0bPD2Gsw2rgHJqfEkDq2XLO4NE2n?=
 =?us-ascii?Q?ANvorAx6/gCX780Z1pLCj/Hs7xbetWRstSbvq2K1Y7sy8c9ulB8H9kJfGaiD?=
 =?us-ascii?Q?a8gwJ0FxQah3TVI2W8uofU6XBBfuXrP4JQjnaNCdeW5Cl2VuncwV72fU2F8V?=
 =?us-ascii?Q?vS70Drh1u1TrB0N4bP1yK+6evTG6TQpURObQr2WZH8hSJhxjhV2/7Nxx4aPB?=
 =?us-ascii?Q?2zmAuqj4B2bbg8AriQRa4F6CappRlY4U558VJK8aEBcPKVNxU5fK3eDREOmx?=
 =?us-ascii?Q?Amx/sxL5cyn2oaUAzAGDBzs/X+YO6ACUlXVQDCUDbF8Geo3Yom6tcExAR0Ku?=
 =?us-ascii?Q?LQfSF3czcFdpE7usM+0ElG00q+0jxElrhO/szQWtWTIqQCFzJaVoUISo2bot?=
 =?us-ascii?Q?YhVcDocfooaRd32qc8oqfGWqxb7kpx7UidrX7H+imyg6GZZsAnIfFeoJG+gR?=
 =?us-ascii?Q?Auz9P+pWTxe6J0lezmY62GNJdLEeNXeOx/CdK+LUFH85rjf74ycQColmO15S?=
 =?us-ascii?Q?1tLmGr8b/43p2AWlPJSXUpPPPPQMg+gKFevnJYTjRgOHgPWRhBZ5M+rljnD2?=
 =?us-ascii?Q?xJYtIwG5miqoh3cUSInqgU2X0uqErq0yumS1GVqjkTvXMR9GC+IypQLcffK3?=
 =?us-ascii?Q?nILYpRl9qhLyOb8uTFC6LLkpQJx8NtuuW/L3eyCBh34Dxpfuoev2Pnp1P7Yu?=
 =?us-ascii?Q?dDKOfEe+7z3LqLC8WoA8qxq4DKsTxsxROwrfnpQqv0uxp0a4gz0KIrrHBN+T?=
 =?us-ascii?Q?Ky9AiybSw8snmcAZsNwzYtG7f5qKiKYjBSfAvs8XPm54OUUSj3EHME7lGC7E?=
 =?us-ascii?Q?cZFQAR3tSPNExz5QxVT8zQNI1tabSZTaEqtDPHGXeeIou3ceg+xByWdaB5nC?=
 =?us-ascii?Q?Dg3Q7xw717gSu5LqCidgKDn2IBTrZeri/CWaNa9vI5+w27t65iuPYkGmvW//?=
 =?us-ascii?Q?wsRmFJC3P/hIks4z9L6defZiC/bir10THccM7Zl0fbBPVSuTqXUPfnZ7BUyZ?=
 =?us-ascii?Q?jafE8fY1JOWV4s2wHDnfZHhVt6QvGXF+Mj6qv/DrDnkphyAU0wvZKTKcNkUS?=
 =?us-ascii?Q?5EJ+nooOV899yR907b6rfeuN7d8Sc4ao0uEy4PrfQI6iOYYQnNb24xUeUgm4?=
 =?us-ascii?Q?iJfl2KdfxPaF6CsKtOGK5Ty/yJoQUssGdiW1KF+/hFGjj4ID7OAmGFRVwLrb?=
 =?us-ascii?Q?M1U/9ufu72kRcN8j3CGP0Q67pUGrabw=3D?=
X-Exchange-RoutingPolicyChecked:
	wtAOaUn/voVSnmu8H0ylce3kbDaLJJRqpetdBDpgW6D3ik8YhwE9d/AwMROfg1R0J6KK5AHC7g1UzrygrPgNiYAEfhGBs2FUYieJrbCJBM6QfvUwKwez5ppu7j8FYoEu8usIuGocllwy9i4m3UteJNjaCvZKVKkyQqPEcznA0featzrbkdclTQQ1Wo1VNnicCx2eHlUaUX06kzXi7V69xNE9rIAghyoEDH3GIp105dnQUE/3YVXG3ERVN0RSSiYFC/eLzLqlfdbpuq1GO1knigMDrqhytK46ZisK5P5wLDtzFzdP+t3kZ9ejY9bueY0ygzwZ4yp6lI83g/w6l2GJ5g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f8EIutnbD43iWucG8l8Zmm9fJNH0ncZvuP+jnxOTMP0Kp5g5AYTvuGjRfSJU9ROiRNUxXuX/iiV7OQl7oxP9RxgF9ARli1ZO4S+pZ/g93KQ6o8nWPM/9e0khnmlLmYWe8fkzFKp6bF+z4O5UORKY8tLZZGca2goNolVIbwX7PXJi1/jdVCc4RVr+axylkVmpqqguXcI0A3cLnzMWuUqtJhoYnYnaO/eZN9eCXqClbf8se981ZUcnaJoXpz4tupKGOcwYxpgfwToGA2uEbOSPrYqPj3X7He9xQ3Mrr+WvqISybsLJ6+YnCTWVFKeDoM/+dfXtwG6bgkc2GUy8BiZ2GwV6ev00ElYozdN2hGAfzJRsM3qM2r8h7ZaDMVTb14jlV9LpH/2hbLi9KCMJFQcFeeIyidTEZNiDD7hSYyW0hcY1vIIj+BbbSPfsZHuUFh8ML9hGt/sxdZdgZs4tZgC4lHs+7ZTbdfIEIS4vwvFq90R2KfOOqASngzXz+SJGMepsNe9/u3uKZQa+NphLKAuV9m3d2Jbv6X6wZ9QhrkFbd/xOALM3PGx8p/3PLCo6N2E9Us/wXV8lvnFXxx5SppQQqIA+xwnywwKTRaxa7f3BVD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6ba0f9-7d51-4edd-5912-08dea51724ed
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:15.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGsfUIvunOE3Zacex67Wk1nSYjDpuhrRqC0YGjt50oFDbTYsPnrXfyHnIHin/ypN9gPMBQ6pFph+v28fDXsTgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXy3hZbsutmG5c
 ZIT7bNPraphfrjRS8SCBPaGbQSg4kjQ85pDL1edfxJ7PAIGwWFzl6zZ3nlU5btsHWCc9BAqAJeM
 wqPuAl50wXjiC4RCX2iU74KpCJu/uiDNomIFlfb7QksO/MQ3XROsIVeDUSWaqU9vwiF3pKS8u/t
 fj+C1B6D7XWS9SnikyjqqzUMAhqLjpJelD+grCm6IpqTvuYIg8o6AFd/p8gzZct+bdTXkXeQdk6
 OLuz0JysWLRi1YYaxdbWIPhJV29cJ2uOXAyxmHPMy6TsuVxl8wALEXfQcnJs001d/i9GlAR8Sqc
 9Loo6q8RMTAD4qlTPNZinwQUJ0tDiZztg5t7vO0AL6CEG/P5On3pwXcC+W5vf4Lc51NB2kfmOun
 WM2BGvekQQxCNGcFlhSR0exur11Ir9G69yP92vMOOW0j5r6XYU+tC23th3ZrsXWQmXwxbjpNRxy
 k5do+8LX5ZvnUUh/ZT1RqmjDsp9HtGcHMmF6xNxI=
X-Authority-Analysis: v=2.4 cv=QO5YgALL c=1 sm=1 tr=0 ts=69f09650 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=9AqYmpHzZGUCEUQmZP8A:9 cc=ntf
 awl=host:12309
X-Proofpoint-GUID: yDVdVSuDlDZtYVTfft8BZ-MF8egByknR
X-Proofpoint-ORIG-GUID: yDVdVSuDlDZtYVTfft8BZ-MF8egByknR

Add callback nvme_mpath_chr_uring_cmd, which is equivalent to
nvme_ns_head_chr_uring_cmd().

Also fill in chr_uring_cmd_iopoll with same function as currently used,
chr_uring_cmd_iopoll().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/ioctl.c     | 8 ++++++++
 drivers/nvme/host/multipath.c | 2 ++
 drivers/nvme/host/nvme.h      | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index ee99b8dbcdfff..07509a03d2ef4 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -719,6 +719,14 @@ void nvme_mpath_ioctl_finish(void *opaque)
 	nvme_put_ctrl(opaque);
 }
 
+int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
+		struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	return nvme_ns_uring_cmd(nvme_mpath_to_ns(mpath_device), ioucmd,
+					issue_flags);
+}
+
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx,
 		bool open_for_write)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 5e49cd716f859..a51944ca56b1f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1448,4 +1448,6 @@ static const struct mpath_head_template mpdt = {
 	.cdev_ioctl = nvme_mpath_cdev_ioctl,
 	.ioctl_begin = nvme_mpath_ioctl_begin,
 	.ioctl_finish = nvme_mpath_ioctl_finish,
+	.chr_uring_cmd = nvme_mpath_chr_uring_cmd,
+	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 };
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 1ec45cce05c9c..efa868ba3fbf8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1052,6 +1052,8 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
 void nvme_mpath_end_request(struct request *rq);
+int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
+		struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 
 long nvme_mpath_cdev_ioctl(struct mpath_device *mpath_device, unsigned int cmd,
 			unsigned long arg, bool open_for_write);
-- 
2.43.5

