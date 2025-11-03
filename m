Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECD5DDA9;
	Mon,  3 Nov 2025 02:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762137829; cv=fail; b=SkKZSAQxa4WLYEj4tqF5Lb0EhWXeOJBzC2AqsLa24UwgozVXsjHRFP6Z+hfOdBzJEz2tpzLzA2y0wDTPWcsTrGKBIE5Wy7ffTpnWmvmPzsBJoFaAA6XscmrI9ph8QTSQjRhl6c7MML01PZyHBSRbHVNqk8LWxrrL4RxhZVLKdac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762137829; c=relaxed/simple;
	bh=Q9GHBg1vuSJZ81BWgaeoKvSbmqEzp3kRVZFdM3aWDWk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jJ8qEF1da2dQP6G5T8fHA+jiYXCeVsBhczUdnq0J4sLANTDNN8p5q9ZcXpyQil77n7scMOJN30w/ZaovtSvOxyknb7PHeoRWaysvUIE69rrHl+sGJiJ5hpFAPR9sVn5L7R7zKr3oCNJ2P0s0Ht3KTcNBYVkXg5nIfB+0cJptfOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mv5yELql; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z+9fz5SP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mv5yELql";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z+9fz5SP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A32dpfB025215;
	Mon, 3 Nov 2025 02:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BHE7HoriNCicxTi+xf
	fp75/cFCx1827Gh+BXhynHQ+g=; b=Mv5yELqlOCyWYmOV4RAs2u7vVLRoPX9Uhv
	dP7C4UYsGXC1NFRkNYcydiaWYepshUNt4B1xveEqBHEuFwAf1cLpymVkLQgd+cX0
	H3q/wjkz//LvhR5OweMeXhrsr8yZY27cn0G4tXh7brBKLKcBEQRdUCBqANNkOfNx
	Tz8EwAIptY0++V0lvmWCjK8qfkuu0O3WBiBc9PI10KYpJPEDxOxQZnNL6tgbpYop
	wC1UYX0szkiSlmSc/D/ENuGpZAkQ6K1hxDAGcX9ivp1lKnUC+5Yihl10XB4yGKvT
	JXzo/JK32Bo9al0mfpBjqRBkEenmRAwRs8E/4tuFVgQ7JVVNEQ7w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6kt4g02x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:43:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2MIEJU010177;
	Mon, 3 Nov 2025 02:43:39 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010022.outbound.protection.outlook.com [52.101.61.22])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nb2m02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:43:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b2bZH+NyqPzMMbQRQ7oKwDdQ80XdFloA2tJCncrl4e4FeG/HcWjRNxO/6KovPsngpYrAcBDIzdHCwwuLPpZlV7EmowYtocEVDrm81yALF/NeDuM/Cci7sL4bup1nqC8qMNjaDMnuxcKYjaYzF39DKbOSdIJv/R2HZX1wtFx5cQx3ACclP1Cc9wduBi9/U+wk01JfHGjdEQxkLJiTioXEOCaD0QjJKNgUwzeR0wLHixou+kZPAiby3q0Rtt4AKYEib9mduG7OJU3jw9Clg1qVVk3ROX8l+cys1iejgDjylpESlBwsvTqZw8K+UX6raDR6XETKV/6ECikcYQG80ZTPjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHE7HoriNCicxTi+xffp75/cFCx1827Gh+BXhynHQ+g=;
 b=FwpE2rBvWGC3ghBD/FYjDWH5KFulGJmab0Z0ZlyYGXsu7vuwZXCmm07jXEbzFwIfdYUJLrJmz4YKce2I1IsGdo/DcPEWrlKEmmdnUg3WfTKlEz92nDLWFQ+15rriwpfl/aZQCdUYCG8HrYZQlV3VNQ+ydunVl9w0AFUv0CtnkdgrvyS/XESYm6WYEbzh8h+9j+fO1FfDgM4so4QBFeHO453AHx8zkdHp4gvXizCag6H+miEKGU7VsjYKy47ej/ANra3WXoNzfWPyMOQ+EKRV0iIT5fanwb0xRDw/TgjVCEL3lbDL+HusTAwBzZpH8XXvvSYUaMRn27bOBi0r2EyhNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHE7HoriNCicxTi+xffp75/cFCx1827Gh+BXhynHQ+g=;
 b=Z+9fz5SP3nYhQnrKPfP5dumi3fzSIH8YkfczB0KDrXy8XEY77OVURjFAMrLlRb9Rp0UaGs/inmzDnFf7PD654kJKVAsWA/WKTn1UnU30MuZKFEcUcs0oPVzvb4HVIhQKLd+y4EQ7x1NshZgFQiRvJCsntwEvmjOg5yvw10R2tqo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5027.namprd10.prod.outlook.com (2603:10b6:208:333::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 02:43:15 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 02:43:15 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com
Subject: Re: [PATCH v3 0/7] scsi: target: Add WRITE_ATOMIC_16 support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com> (John Garry's
	message of "Mon, 20 Oct 2025 10:38:13 +0000")
Organization: Oracle Corporation
Message-ID: <yq1wm47suoc.fsf@ca-mkp.ca.oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Date: Sun, 02 Nov 2025 21:43:12 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0037.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5027:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e08242f-616b-48b6-5b57-08de1a82bcb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ysrc1RQHaaj6O20BoXqjS5HWv09cxeLz+X7RMEk1l7MgOajXSTCPFQn7ii0C?=
 =?us-ascii?Q?MLHXy7UFoBksXbZS1q+etr336IRJMN7scd2/J9pHlAw1ILkyrqBxX5RuqpeI?=
 =?us-ascii?Q?KMXC4cBZMPspQjICgftBTtJ2rB3zcn6m69lzEH1wsTaVNFBOdVsDkWYi/I3V?=
 =?us-ascii?Q?pI5ImTamFcb3jZC2YxDyOQzYxQPGI53qSOMR55pEqrDZxXLYi4B3ddDkLzjK?=
 =?us-ascii?Q?0QUn4zyF3/UVTO/zBAt3hfYqqUmr4SsYBcj1dp2EYfLPp6HNZseK4v8CSNCb?=
 =?us-ascii?Q?1smH6IltkHzGujTSpVkSY+DwoUT4pPsxTyJL1/CH7wqkR10DOnueQbXUrdu+?=
 =?us-ascii?Q?K6SXZdOzzU4bZ0pdtxg0JhHQXty1t1ZRoBeIZMblP3TGHTR+fJtOMssn284T?=
 =?us-ascii?Q?VQFCUE4aDL078nOQQzdDRRhKPRFYM4VWtL7dwMWRXkM6vSQv23GPz3lhP262?=
 =?us-ascii?Q?XQaAERGRhahp1v9K01d2T5nwilRz0tq75X3Tdno5q3vpEGGwM63TpMBtYbLK?=
 =?us-ascii?Q?cOf0+BNVhgGZo1aegrkRONKQfX5FAeQ4m0qupaMjDen01r/hOrRkrSb+uNy6?=
 =?us-ascii?Q?/dZXanMAFKwUlQyGkPoneKdwydZCX+MdccLftT1pRru1F7MFKLhnQQ1bdl+m?=
 =?us-ascii?Q?7wZw0ep+o1oLq9GavDW+Cu+QQm+k4JbP0FAbsIXmPHZms7XRFsNKIn4tEgdj?=
 =?us-ascii?Q?i6GEZVTifx4NnVfvzIrDO/xeiq6PxKMg/k1+4j8sOfW96g8aDe6DFIgft6hW?=
 =?us-ascii?Q?b66k1+gz0DnP5l/deLMLgQpMb0kTzVtywRvwqKpbAbTgyUVGJ+D3JK/4N6dz?=
 =?us-ascii?Q?HEFItHteCo0buMWcd1I8pKUnzzzxjsQDqyzq/fmhyfPg/+g6ddJ8vQILPrCq?=
 =?us-ascii?Q?/K4HxDRPW5oLMRxo+2An0QkKT8V5I+1HpaA5Byt8+EjU+gbPo9xhhzMiYQ6T?=
 =?us-ascii?Q?MrDXThYRUnR9vmU+4JnMf9ZXPPqsxKdhi0TfaXoAUI1GdhFssNHoxqzMreP/?=
 =?us-ascii?Q?rG+CEoX2kH2lf2ReMnP5TIfTUly7zSPNC8DO1ql2W96hjAfQLWw50r+QuR/E?=
 =?us-ascii?Q?wJPc3Rtc+Jshzj6DZAOKMeU4kXcNmKvaef1MlTANgFee7OSRExfmKxpy7mQF?=
 =?us-ascii?Q?Y2+CY3g4rbt4X1zxrUSxnIqsIZuViU6DUYM1JmroFqmbc1Fr+rvIDkLr4+Al?=
 =?us-ascii?Q?sCnXzvyGNVLfYiTbOE7RtjrV5mV6GWFMhn0bctN0U8SKBV4/YhhmE7HRfwOY?=
 =?us-ascii?Q?uK1ePTwNZ/fc1IREBAX+eMESZguRX04DFUPtVy8iVGuSHm5oVtXCtgUCzccd?=
 =?us-ascii?Q?vu0GQLm/H2od0FytHokHRitNmPZ3JNDXwitIqEqocbtRozLiOtYoxjvD2p5C?=
 =?us-ascii?Q?5wyCntIasqrCfxZxdLS7M6r7GTWYfYKknAMnDaOmufgX+hreFZUD9mdv4+AD?=
 =?us-ascii?Q?hlaFMq4OToKiIurdKpbxj1hdgpofdtXt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dN0dHV9cQb8klKRtjr3y4tBg+4gJYbc5EltDvK7fNao+tktAoCueitbK8SKP?=
 =?us-ascii?Q?Jz0QaMXglDRUM+ijFDkCaF4zulsJUF+R7boUTpRbwP5tlmJ9ZpmNIlM0KJYO?=
 =?us-ascii?Q?t/CjuiL0ZdjjrTO3lft90iBUDG3rZ+7ylq/UfQ7YgkHvP7OCEbMfNLAGkfbw?=
 =?us-ascii?Q?4IUeBXaMKQjgphvcsMSuOhLHnUViGwbhBj9p6bRGq8L2dw6Mcnt7RLHUbyDY?=
 =?us-ascii?Q?bwndkk0VRxlnt4TXsnthOoAzd9ZcOBvwZV2ZwAzuXZBqISTyLj1VPLJRzrJo?=
 =?us-ascii?Q?/02VGOlfJoDb/rge3LY0XeiZdFjJSr9VTsrD955wWyXGmHuh+JuoOIrEyx3y?=
 =?us-ascii?Q?BG5Z3Q/2sT0wma3fBiVP+Vc41siGRv5zoeBnCXbfaDba0FqQiATBfq7BrrTH?=
 =?us-ascii?Q?EHN1U106uXBErslvUtieLrtKKOfO3cOT4h270PiAMW8TCJ+0yfUqJxXbwMPm?=
 =?us-ascii?Q?Pb79KzlDm5Iu7ke3OSPwUWxnySp9FZui6+hU+XDI9PAw10+2xFN2EHHDDbk8?=
 =?us-ascii?Q?CcSI/8UwdMH6WSe0QmwbzYJWTaTJ8KRuJ0Uv6Ntvo2/DaAULrrnkPkolkr9d?=
 =?us-ascii?Q?cpVPD7MIjhpwFMupN1Yr4PFQmw/NO3+mQ9XKAYGGI3ouwLqzh6z8/DFLAtSA?=
 =?us-ascii?Q?Kwu0WBvK1W4RiRAaoQE7b/riuFtdAtD4gCjsGqDk9oz+QlJqhTFWwFZFqlyL?=
 =?us-ascii?Q?W6LlNJ3TKc0g7kY1kUVWszsSLEbzsBhHIpMXMTlTc6SUdqIhZPPPtkGaTaJZ?=
 =?us-ascii?Q?1oEBRegJ6O+/7RUCugxgVuPnEnt3C9uLeCpoyz0MJ4OW+PEsqmFaySHF5Uou?=
 =?us-ascii?Q?WCw8hyNgNC9wS78zKaqHynvznyMv2Cw6nlNXbweW22QIkq02bIEWOSWkOULU?=
 =?us-ascii?Q?QZjCrGqgsU9EpxCugg+gHifqH4+Pdb22j5evfKn5vcAvsT+yU8K7ZGr/r4kN?=
 =?us-ascii?Q?FwhKtA/gpAJwWhtIMQQG1reFDlxXKG/HWj0FyMF8BuXpsqVd5ID/77F/5lDi?=
 =?us-ascii?Q?wFWosROrDjUJmHRqS47Cle3qDbyZUSMX06cx/ZRlvnOERbMQ1DG7IKGmAlz0?=
 =?us-ascii?Q?DL9ETow6T39JyuB3jMyd6+SSxSRQOWUkIbq6D7XnHXIjmAWnQuxCQIBuLIcY?=
 =?us-ascii?Q?4XH7A5cCQ4qPJiXmUYGrW8iquu12ITwmtPMLxoL9YsQYz3KZuO/nX717H17S?=
 =?us-ascii?Q?5o6j+UMIyFk1tn6yK3tCldiAd15UoQF2NtUd1nn8cRJlW0wYMRCI2/S0pXMb?=
 =?us-ascii?Q?Ee1cyWcSRCB+Ks+36gQHqBZJLlVRs43XUkIQAcf7cJrDxXJLz8qecfINq+kk?=
 =?us-ascii?Q?Amu1GnOgXvVjXGEc2jtQxiJTXSNAgIS1iGFd0P/YqhZd88zHuCG+Wi1GlkMN?=
 =?us-ascii?Q?ZF9PINe9F+G2Ec7VcACYgVcxrj6rXLrEVvsrYeew/bjP2CrG4lGhwCDEB9sx?=
 =?us-ascii?Q?DMeSBCh+mI5QCoIWXbNqTZiKYNAHwNJYbkRCKMMR0iGhPSbZXO6hyBt7YKwH?=
 =?us-ascii?Q?BKO7rMeSzDFy1lqMDg4TYn9QTqyB8/o1FlMFqxdZX53wsnDH6t3t3dZCNu33?=
 =?us-ascii?Q?owBzMCvl4YZiJhl+eXN0Sw4eBC5NIpxLDyVscoQ/zxWAr2rYqN+8Zu+lf6yf?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M1W6yiDH1TBO3mGo8MmtuMt/u5YtHbedr3hOIXvplvQjH3oP+eqHKe+2EBWR2Qhkys/NSK27zLAwqdLm40WGQN8A7uSiH/iRn91Fu6+tqB2dTGsVzcpCcGYZLkrMOtjQ9wehjyoXi5zTpZ0p1+KuOns2LdBWAvzTj2bRXkRkqmRy9ueAP4w/QJAws4ui3A8iwDkaSHxqhEpDQYiTl0m3iRExkCrLmQgq//FkoesQxBm2zVtQd27h1P6ulIoGrIPUnDYtGDRL4siYNlQpjrRn0oBFgLl5/DTwOBYxgrSM5CpMcnwdGExfI81nEMfgpDqlMHYIppdkwvyjzD9ee2WtLSSwi486h8PlJ1f82fFMnS2JLtS8Cop7sJOcKWPxYC6q8dgacagpAEvs5LjdgrDxaKrhUIfmv27QdA6glhR/Abbnyle1mshHwaqyQ0Sr5Y7Vyx3YJmZaYLbfNR9JRn+Sut2NEaPep9B3kb3PWDaKWssygHy+eKdhWxVGWSPhNO7RtzFdM/Dr30WUkchvOQYgXKRzPaNL53PXKKZlvDFJQ1cLtV5/XkFNbvZIdBYpDYi/Jq9ahmhEnQjKR89j8wyAc9j9pYr3iLaO+7NUb9mjyy8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e08242f-616b-48b6-5b57-08de1a82bcb8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 02:43:15.0202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVItV+hKBbSWGxmuENeAmuuEU+cD2o5bWlq7jotsP0Vbc6thUCpZxt94qMrI/ne3nWFPbTkwEH0i1KfoeK/d1l04RIS2gWgmtjEBoevwMCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5027
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAyMiBTYWx0ZWRfX4Zw+TOKqNqbT
 hoH+WTaN99RoD8jnJhVLvUnXCpHag1zjyo+SWoW+sW3tA555QuGw0F1EreAm8rsXuSOrZ3PxDdG
 mS28ZaqY7p8f8tgLH/ct3FZXaFgZHnim85ws0ewGYyzto3yuzykWueCw0t7zx6GYqg7IrzmL+sz
 QWUlnVRZAAuWa27TeSHCSXrScn2sCDob3DChyLJFoPvd78Vo95rTUG/XBMU2VG/M0lJL8kxzAeu
 rzlUL/KmYN/17CwnZCwFY0oucXgu/zmze3oN4Dgoh3syaMZ7MPcXtnqF87nh1SEVCqVnhuRNYFY
 tCGrkpIguR4BKOUU0yzuZ1yUlkqVq9o6ZBg4+YX2VYt11NHiXuzUChLXIqM5Ds8U4eao8eDR1cA
 8t0ErNRGCDZPzBXWB/T46qRVZnA403A06mmwrhowjHLDtVUseX4=
X-Authority-Analysis: v=2.4 cv=Pr6ergM3 c=1 sm=1 tr=0 ts=690816dc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=WA894qDZC0-4d9DDV_EA:9 cc=ntf
 awl=host:13657
X-Proofpoint-GUID: P98rs0HETHKYinDQrbCTZS4zkS4IxspS
X-Proofpoint-ORIG-GUID: P98rs0HETHKYinDQrbCTZS4zkS4IxspS


John,

> This is a reposting of Mike's atomic writes support for the SCSI
> target.
>
> Again, we are now only supporting target_core_iblock. It's implemented
> similar to UNMAP where we do not do any emulation and instead pass the
> operation to the block layer.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
