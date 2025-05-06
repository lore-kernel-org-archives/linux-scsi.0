Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ECA298C14;
	Tue,  6 May 2025 02:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746498067; cv=fail; b=fRFknxGGHzHe61/FUVQQjLNt6slu17cQ9rmaxf2ANcDxET2QDUnn8/LukP5p6uFXWHzpkle1KuWBrT2saq7KpXZMAZcu5RvW3NRBhpm6UV4gFUdfaIZqAX98Ch2ZZPHv3Me4wvdrGZfoTEDBdtIK4yqp821px9LTCAHZ+c/EZ+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746498067; c=relaxed/simple;
	bh=IhpGmBKKLfLYdo+c1bGt3AQkgYCTlhBgoYiM2ZPo0kI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lwNdkNhNRDpfnrfuA+vGuMvFBcSdW7jA9RE8+mT3j/YgmIpm2mCjnGWvX/hcJpl0Lw1z5WID8DFYTWirgnfj6kNSo4ejPcTOJEgbY+W+D5faaqydDxHDpuFXR7p6Y3CrcWlkOw+/gSfApO5KAgEwXYfsPmPymTGFFWi3Ct9s6+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qzk0vKkD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uEyhA2jZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qzk0vKkD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uEyhA2jZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5462HU8O014509;
	Tue, 6 May 2025 02:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Kl/f/dUgN3crzyzwQ+
	wtR4WZDa8xCsUcdXLoZm9C2T8=; b=qzk0vKkD84ydlT2jkfTQrYZbkq4WDXIwLo
	eWa/m3aUbakPQmIZSIbNIyV+WsL7b4Oq6YLfG98S7bnFaR3imHuwMK69vQizDZFw
	Ke3F2TogN8gpdbrp9yRDecdgmMctxM/28V1dJ+GR3Kw2XTwLkeWz68OZVNyPf8IL
	xzqTXruvktHCxpdvZIgNs/dUn037E0irG0cxVaF88NWQFI8SFdt+pw2MEDCr5PpM
	GD2bk1twTD0umGF8ME12kvw1qR40fIbT63g8vIXrkmkP8x/eQuD5XA9NKAvcNwke
	EhMLAnmk3rGyfWymN3c0Y8HFLwMGErT9KdvYLNw/xbu+EXAUeASg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f907g1fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:20:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 545NbI0V037750;
	Tue, 6 May 2025 02:20:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k85v10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:20:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EI+DlaKqOWa0LwJraxoaJkymLFvLjKrOn2CCRcUFMzElsf/WRNve+ocA0eSY0wGq+Py5nWWXJYMywEsFeGlHtY6yJWQmozYgXr27EP/MpYxI7ezbk8C/zrKd6+eO9xVoR8aNGG1J3Zv17JAzH8HJKxM9Q7W4UAEZGGQ9BFDa3mmDQnUBovK1MtH3CskuHZAeE9jHkmgy9k5bJQvirDlcoh69hZ9owo5M3PEtzeUhvahziib4F1l+a3W6CtqkdgC+4hVYxClLQwjyw2XFd6H2GFOJCy9+hXCC7nR7vp2GoFW+vFFxzUT4mfwTIFQmqdzIpXUklvxIE3CLjNj0JIghrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kl/f/dUgN3crzyzwQ+wtR4WZDa8xCsUcdXLoZm9C2T8=;
 b=VGPE6gGGTWHlPNNUD4ASZUsHJekiop1ZgKtf06MVhenHih9+tJNpFtTrG2F/tIJv/b6PABLj2bAsBL8AjEXBJ1rxoW9lXVJwPalzXT+7JWCmJtmVKBwLrSdl/Y88koK6Zf+vSDpe22QgplKCDxnHDWXt9Mrqechg4qhinLUVk+wuExg4iexPB+mN0f/8CVaFDB075YUEn9PyiuGGsOkSpqZGqVe4G45sS1zOUzSMsFHqJ3UKjxKiSKXjYtreA9Sy7yWkF5eIN5NNC9669Km/I3fpL2/ilHjXIR0mmG3MdyaVbT6kqH8GQ+tGi1Gkg7cr5h9jQPUBI2t1QzLEZQcaig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kl/f/dUgN3crzyzwQ+wtR4WZDa8xCsUcdXLoZm9C2T8=;
 b=uEyhA2jZuJWeQdrOZBtu4RIQwbCX6qMxpPprswKaC74OUHTsfwZ9QRMZg2hFcBN0s7HsBK+Jdyvyhcf8RArIAEdXM/tiTNWBt+Z+fiJXtI0fkkkOf1skkCVk9feo1HVsb94kNYrAijQwD0nJwQJCe5BXv0bnSYXxXfghr7P1XUs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7189.namprd10.prod.outlook.com (2603:10b6:8:ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.22; Tue, 6 May
 2025 02:20:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8699.012; Tue, 6 May 2025
 02:20:53 +0000
To: linux@treblig.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: Remove unused sci_remote_device_reset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250503230601.124794-1-linux@treblig.org> (linux@treblig.org's
	message of "Sun, 4 May 2025 00:06:01 +0100")
Organization: Oracle Corporation
Message-ID: <yq1plgmv5s7.fsf@ca-mkp.ca.oracle.com>
References: <20250503230601.124794-1-linux@treblig.org>
Date: Mon, 05 May 2025 22:20:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN8PR16CA0022.namprd16.prod.outlook.com
 (2603:10b6:408:4c::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: d1193308-0414-461a-7a53-08dd8c44a0a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0prJiWrJ6oGbIgCkslcwJu7Hku8qnANIYZMoUnmNOvakAz3L+KgYjR7aYXW8?=
 =?us-ascii?Q?6gSJcmAv6FqydVYSyXt8zJnCZjEEDA2+0eDng343l5YgP5mEp4ea3cG6UEzE?=
 =?us-ascii?Q?+eRwImOkqQCMfoBQYZL8dFdxcJHWUjWnxAxXE73/vnO7O5szYwtDM/oPcCoS?=
 =?us-ascii?Q?boJ/zc+d2P1ZPqZNWPEc9pQmU8TCWejsDuMBTda5W7wkMdMLsyNy82tb5B1u?=
 =?us-ascii?Q?ALpMZuAzJOmkHg3qnQiTwr7tkQSvZ2jMoHkw4BxiPrSLZolTqRrfKRP0Vr5y?=
 =?us-ascii?Q?vITffX1m7VjG+qn8yg1PTxcxfR9q8xGju7wn7Gd364lqION9tazmG2HYTz4s?=
 =?us-ascii?Q?peuKRT+hcO4cWbcqFDND2obhmvkwcWDDtLmVtLuQ4+Ocobu7l7nM4VXdFbL1?=
 =?us-ascii?Q?fYwo59Jrx4rq4QATv/ddgOhCX+kG9Wp6I7cwwZDB6gN+o2OhjQBQ1blzmO+7?=
 =?us-ascii?Q?NvJnE6UXogRd2OAMhP7OqCsmzjzgari+1uko20TuGawITeCJubTZmyWODEDw?=
 =?us-ascii?Q?Nj26q8GCPBNaRBCtjx9jT69TvzsY79Qr6B3Rbrj2Kt2wGAvtDyHGhXb3Fptf?=
 =?us-ascii?Q?5uGfoguEUfMscy8JvIBun/TNbwhdHTFiaI1EwurwOC2dO1d3RbYwgK5aZxsq?=
 =?us-ascii?Q?SYMqAsCV6mwQzL9dcKXDaQYm+TQ6PKzAhgts/elEHdh41IBk6T5GiC3I28HA?=
 =?us-ascii?Q?0F7qLrSd2Ro1xHMmbXdKE+yw2JWloOizsWa5OBLrN7yrid2C9ZaU0MtK95W3?=
 =?us-ascii?Q?yM7qlfbfvQ/ZE+M/nuBprOKuaDfROtyJdP22xPSgF2WCU7KqwGHCBMtzg8ef?=
 =?us-ascii?Q?hWjI0Msqa5Q2iRiSL4jZqH1GaU/9SF3kOUWrELCnLOtsIil4rK8KekpU3qqG?=
 =?us-ascii?Q?f1iILnNtbvWKaMwpQmNpabqvrx5CFOTv9Zqmo9W68VDitRVpzb0w6eraFuJJ?=
 =?us-ascii?Q?7gSAva6CNK7B2JqqMpl+L+b2zwVfWPoQYl8KJnuwo1ZXOn5JjGWRW1QDKraK?=
 =?us-ascii?Q?u1BJSCCxiNavhjY1Cwee4DDDH+BO1kdgAIjAQTuqJU+rhnxQ9yCYRBbQWV3b?=
 =?us-ascii?Q?E+9H9P5vG4mtMlCdq0Ke4Vum1jgmN3mH2VkvWurhwFbFHKJmW8tlHLcUPlfR?=
 =?us-ascii?Q?d/rH/EhT4AiqO+3Da338U8Bxn65zHDSLdmPt++py0EdKovZvj90TbhWm1Jb0?=
 =?us-ascii?Q?oJCahkstKwPyGJ7KHbwaf3M65C2qs64uvFj7yyo/1G8pMq1x733Jqf8K+ALA?=
 =?us-ascii?Q?S3OTjmb1XYJs+x4twJjw4uEGgKiLU/e547/gzQquvEcM/n/q9riuVURij7QO?=
 =?us-ascii?Q?QGSqK6nEr5743hjW7MDmA89gj2SEMTKJRfEQYuNu2ZSjwjxd2rn5dVyT1eMb?=
 =?us-ascii?Q?w4O4pD8O+Lw26r32aEosycCCx82xZoBOeUx57K7jjM7so6CcDCRhVUCQY8yK?=
 =?us-ascii?Q?mMxE6PbTvXQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B3l1WrzN+AivoqIAIFSIXj2N2UM6Bc0HgieocPv3R0o0dFNKgFefGr7ehdkS?=
 =?us-ascii?Q?HzbThBH2kWJ8Y/dvwUhNgktaWPI/YAgPbOP6J+qFy9cABusDJirhyhkKSmSy?=
 =?us-ascii?Q?aWRfL8DwyOmTho2EiFDzoxpiVFYn6kK/Ev16VlSDX7GcEskgiRob3PiV6L0a?=
 =?us-ascii?Q?0N78p/J0I/PBsG1RNnpgoET/ta+pVmzbs9KFIJsgZl5PnnRjc0kbckaIkL7e?=
 =?us-ascii?Q?DWob2HHOwxmi9T3ZMuQ9IcZglKijxYKxxMKR25EqlCmyq3oyO5THFEyjzeYc?=
 =?us-ascii?Q?8ey7eyqycB2XCLTvxWXio8m9iPwnkZ2fGSTV7skvA9cgE3I0BAHuTqaucVBT?=
 =?us-ascii?Q?+p3lLfPCSL/Y1/1r2NKqVNgUKK9J38C+/i2B+KBtR1EMEvVJyVaIEjGdoaRP?=
 =?us-ascii?Q?bBFtcxffI3cXdICkX9NYk0Yf6a65mCk2ktPF7ayu9bjBM9ripGlkV9L1YPJR?=
 =?us-ascii?Q?/OL0/+TU1IMJefqn7WBahkf7xfn4clFgAEjp0oa7ke2o3IugxqjCgWyRpw7H?=
 =?us-ascii?Q?yeGVuz7jzSIArHHwNMS/1jtaDZFbFlhtnlVWCjNkcX2K94kgG95O+y+fWONk?=
 =?us-ascii?Q?4vKIWCaISP21e1/ulct+kBzo9348HOYy4xbZVwk5RRLQuMROrePxk3M8YuzX?=
 =?us-ascii?Q?7wm4y8wKL/xzNhLj9+rFG6+hqRlFEzsfDxwxhvmT24RTR7bUfscHd0TTyPl1?=
 =?us-ascii?Q?ewWuKSbfLmmBYZIuNPdDTvfS+CcIbxRzYI9kRnurdUmMn78CngwOBMbYb7g/?=
 =?us-ascii?Q?s9wKp9xDYXC63Z4P7B++Nw3LJ23roFpi71KVpfPqP3sIb18SzLluIB2tc4FA?=
 =?us-ascii?Q?y8/u+nq5fy4JTB6HszyHAuHT3sQBIzR3zQTQQ/9TaEN3JakufLSOkaqZyaN7?=
 =?us-ascii?Q?RjVJz0ovhFg1WJoMCnQ+/hz8xqBqXy+s0sRi0cwI/lkxCBT027CggkSBuOOW?=
 =?us-ascii?Q?Z0KWJXKFWI8MIBhLtPUYlwjs1n3Y1OnWHpkJXp+7IEzCLteYsF6UwUwgLGJs?=
 =?us-ascii?Q?lQEiTQCh8L8iaMVrmvZn75CTyW0pZK25oHPKgTSAA2Ow8L8ynTH0HN9p6po5?=
 =?us-ascii?Q?MRVTauAtdt69NZe9X418JgHtPb3yEQFX8LdJNzbnVXK4MF8bZ0vDBsfLrdXt?=
 =?us-ascii?Q?0Jo1m0wwhRgxNujIQPTsbAHW1RU+UPh54pwtFGDv1rNjTUte3kO5yqKWS5Wx?=
 =?us-ascii?Q?QtiRf9tslryOc3oB56PXOpnBhIXrFpr59kQyFgxaPszJGzkigPenzCDTTj8I?=
 =?us-ascii?Q?to8AEDGpxY6KAUrniaa5T1JpLOeITPtl9gtSWEX7DnVej1D1Hm3O2lLHN27O?=
 =?us-ascii?Q?9GaRI1KMCjKqEQTu8/S1k8opZLUDLRRVuxcK5Tm2VRaWRHToxRypJFP718ZT?=
 =?us-ascii?Q?+rssDwqvPe+GWURavb5h1X0X1dakMCmKMCWWGyxdX3CS0InkWPxY/6q6UzXQ?=
 =?us-ascii?Q?eLTdV2optv7Ek3hUxap/O64wXdSQ4/1zjHAWChEOWa2Qc9C19ND3pl9nwpQ1?=
 =?us-ascii?Q?S4GirMR18+XGN14F3lnyPushBe3SK+5mZYw5ZPKPq46uY15RJHLf3vNhVqw+?=
 =?us-ascii?Q?GN7X9xpoufiVu3GxixPq9xDDiLjM03pMkx0STqy3WNhbv1gp9/6LjOZmE4W0?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7Mhfb0IJp7SmLs4vSvqDUJ9XP2MAbcslAIQHsbZmhKHmt3TU//H0ZKl89f3calI8fxDMSXfIJgQxCAU0lOE1iBF/5rza4o7x6gdWBBnQQBi1pPpWewwfaudiULAftob/RWM+wquGNV7pyRhUSlBpTRWFt5WfMaV9xD+Yc0ZypOvUZ5XyBIrSkT1vhKYp5+jvF0VY7TUDXd8vjzW5078Tew0kfanL7xcX+UkDt0NwkTpXgMUQ9lzZC9x7M2eX22/yjyBMU+yQEJTTYHHjxRdcH9xVTk/iEnYOwuTSIJuAmIBnS0nqiQ+2sCIS9M7ut6ytJPc9LN9TiaFMwsvf8uh3b5/l9vyYWqUUe+yZfKd5TnCTKk/bsMLy+PAnUfzpoB1k4vuFdkRYa0SXOpTBLTiXlAXNgMCJsbUjBWD0tBjLJmPr3ZGhvvnTLktM3ovAH9dNb39tIC5okQuNSzn+XH8L2PF/o/fpR2EYGLaDYEagBy6XDBG1zChANt8P35/Y0qloL3D7kWWStYg0XdQJTP7zTItCsHdCORw1Z18NbF7HrOo99o3sRQ9qNPYT260qokHomcaLK3mRttSbtKALvd7HCXVwZz3W/CUqArX2mIm/6dA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1193308-0414-461a-7a53-08dd8c44a0a7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 02:20:53.8552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ja2umZNyKiJ5oPCpyPNdkxHpQ8B/PJiG078HFxETG6X/NIIm8XKEfIPqeJRaL26/CGnLhKU13r9d1zIdjr8y9ESbGgqH35G6CD+apRZsXkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_01,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=700 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505060020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAxOSBTYWx0ZWRfXy5eEQWNghbDJ ClT6Zl3IEmu2gsHxEdMzHGW8PpbutArbQbWExlddGTWFVvxtp0CZODKMpsO9yK1RTNLbGzZqICG QWOwAsat5Kp7hsuUTH4Zd3BCqYwfG8MmkrQL5EUZDOaX1UZQTpXNAqEdC6RspZ/kYnAwsuNfgVb
 1DhkQiWAQYQ7kmHVaWbIHPOi6HsdqrmJ0SizPLJoWxLnPSD28u336LR0U3p43hfYHjkl/O8v4fR sQAFUikHkwYXcQjI9Ntg/M+ChB4x4F0BVjk3z01HsjkBXzE3GiUxzIJJsY1S59sDzXkxg80LL3f /tlJTgBXu4y6OopOHNtvesUUOJMiZFmp7xJ8gincshgH6FAzkDI6w3A5XSYEPRZTpCV9Uh7QSYx
 2TubizxQCpmJOL+IQDMFbi3e2M6MIgRi2FpABPbsZAjXPSqP5Nrtx6kcYNX9+EQ6Aj3Mr3tK
X-Authority-Analysis: v=2.4 cv=Tc2WtQQh c=1 sm=1 tr=0 ts=6819720a cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=cNMCkp2XhuoQE_LABBQA:9
X-Proofpoint-GUID: ZX9Bcgm38kLoH5R0nIT1WDD_Qi8t3O5r
X-Proofpoint-ORIG-GUID: ZX9Bcgm38kLoH5R0nIT1WDD_Qi8t3O5r


> sci_remote_device_reset() last use was removed in 2012 by commit
> 14aaa9f0a318 ("isci: Redesign device suspension, abort, cleanup.")

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
