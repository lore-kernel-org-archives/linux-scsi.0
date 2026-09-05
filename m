Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5702E222597;
	Sat,  5 Sep 2026 06:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788590342; cv=fail; b=Ef7vfZhhCmODBuN8OC+DW3QqSMWeT/JplYjYh0KRe0FbJqwDIs/muaXzp3TceyLMXnlweUUzyyMer8mjWp23Cwdzzwmm1RKyQNl8nc3hgIAvsvpto6J/sh/orU1dUjaTZiz3ceVzTB6KahGxAunB6F2pNw5OPyIaQflc1Asku30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788590342; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cyWGirjjed8F0hJ305MZ8FpaF6/1E697o4KeNseOl+hE3p6YX0xLEz/9M7sQEjvPRD5lnI8tFo/Bgo3OKnLM2H52hlIngMQVf5yQnWamRDNA2Yj7wUgl5qhjge2/SBca7Cn5AZKHpdaH37m71eT7f3v+BvGx5q/yWZNtTdRelZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oHDiUf8t; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Wi2F6Thi; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oHDiUf8t";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Wi2F6Thi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788590341; x=1820126341;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=oHDiUf8tqgIvLTrxtx1uiWSZ7aML2cIyFoxono3cZQXDOnUXhVugz1bF
   +Iuoq4rxO6uEVH+jrpqWhrLuyrLK34X+VIlSvi0jBqasJhYHRv7qDeYxm
   19xpOIRgwFjjCCpoWDNinRzlXtIV6a/julC4x+SyDWOmt5scuBR1h5igu
   mtlPs1Pf5QoWwDwn00XicLccBQkDDFbrSPLHtFINOzCsmuZpG8ukmzerH
   V65fLuG/XQn6TEiNP8r/2AxAhzu60ojgL4ruvs+wQppWLrSnlYHu/2mMe
   0bTMBtQ9ZiqL63831RTQV068Bz0JLLQjnZ6VI9IuK1pO34XqkaZXtyBcc
   A==;
X-CSE-ConnectionGUID: OR+ZXEtqQZWIr+0FwRVjHw==
X-CSE-MsgGUID: 9JQNml8fTj6ky5Gyuz7hSQ==
X-IronPort-AV: E=Sophos;i="6.25,263,1779120000"; 
   d="scan'208";a="154044403"
Received: from mail-southcentralusazon11011051.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2026 14:38:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y77UNz1hdk5aDsbup7qibp/+Ex7O9rzR7mK+ZdtLHaE7yIZ2WYPSkCNOPnysRoOewbSo275VzBHC7hBAbMjhugggQFC1fxb7zZi/dW46TOTdQY7LSrp3a1xHXunNObq/2rdARjoL0Od9EytaD1EgeZ88iIXdNSPOpA3c5IyJfulI7KzLlMJIVtDJYJIoILH/zTJEyBevwAcYYY2j+1ueyUcMrkg9II3exF9ZCJOfdlQNdTj9HKOYzYAkGJZLflWcSE4P+WQQ+14xssabWEc31Vp5ApSnu0dtNvt4bqsRqN+TQLYIGZFVcCPpLNwc6pksOIDh3N6egcqTFXKEtIhQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=RbvfjL81qaonpNFbLezdMcZvp3KMlkdgAzLzOjx3XKMymFuv6vo8Za/etKUOcavg1HAmH+byia+choUVMgjj1J2KaZArapYkxd0jDhySi2GhQebqTFIfHvBZ2UWbjy6imK4IDO5kfSa3KiZ/9NfL9m87ylxsnS5K17O3dJnsr6TC+Z/p7lXsPLqIbGkAax34NVl+Z0rlBfoQldi7D6uOEMP8LWHL4Mr/fjIroDPmRDPc7JejXmDAo/SM493IDaMIzNgREUVI7OpB7vzXyT7JLsxXXQNWVe+cvdN2u5XJsrtHDoDys9V6D+2AYYdEUdRD3oelvdkGJqdZDu1xMIDX9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=Wi2F6Thi6aiSz62eZaOBfD3lGI+r6xcrtnYHDMbBLefQh/trczslJsb7IMlUOoiPsruRzTmw35K0mZm2L5aT9s4sYVylgaEkRxNIk42h87kitwPYNnNROE7PXj3iHyjsZx4dnmHQ4tPJyqs43CgsfbxouTkO65eSkkXqE/MY4zE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DSVPR04MB9964.namprd04.prod.outlook.com (2603:10b6:8:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Sat, 5 Sep 2026
 06:38:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 06:38:50 +0000
Date: Sat, 5 Sep 2026 08:38:45 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 
	Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v4 08/40] scsi: sd: use 16-bits defined sense codes
Message-ID: <apu4Q9CC4DmD-Rz3@mayhem.fritz.box>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905032224.509860-9-dlemoal@kernel.org>
X-ClientProxiedBy: FR4P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::19) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DSVPR04MB9964:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ca97078-ef16-422a-5571-08df0b185891
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|19092799006|1800799024|376014|7416014|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	RogVxSq/5jrw3sdFAoGuJDrN68H8Jhe4oU6mT8ZKG3HWsdzsWq1JLu6JHSDaFHQ3ZjWda/0wbKG3jlghUP53HPagLthhB9A6JOPY/Do+HWTAkm96wLMllHKLRRYbwG6v6KbWMNFA6cW0Xh3kqvXAMYvNWTaDcTRoKVk3EUyawUgsKfk3DJB1i2AIs8cTg4q1o+lw6aznEoEp/YkrN2qovjPlm/HmqWDjstXJ9Wjzez5H4+kqhr0IUWgTIgWSg3hHLCgDYdBGLVg5rY6WhW1OoKN59T1QgrVM/6DtbNQZHDm1f/FWPM1tbxGh5MocYm/7plFJDYjUjNE2Y5P/VcTh+Kzwapw2hH8i1b8FDEavIVSNc5wS9rXRMfx1MTaQjae5WENsT5dMsiRPDy0mkQM6ygjxn/W0rA89ud4X5wXAhYsKeU1oAJVj5CkzJqKRwyGuJu7wIF9u99ZZNWpfRUI6+O4jQAUepcyizx5F+Ug5chPE5Y2N01qXk+CzG/6PCowaI3FZgdtm5NaS92kccUJuMy3LNzTYhH4PTDu/7dV79pclW37KHz7JgKDYGMjmQi7Hqvtpn3OMm1d6e0YsOCiSm5pPRwfJPRV2nLXUUo3OjTQnJm7+6vupGDE9spi0FQ8rYrnNq2YNBqonY+qo2fIkW0ErhbGOaIRjdbweYDLgg1w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(19092799006)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5jm8VgxE7pfLY0EQuaMngNRRFjmvmG7ISdxKz+m+iMDnP1Mad13AQUZCIj7+?=
 =?us-ascii?Q?cFAHTDUFDJgmvn02teDZJ8nz0aDIBrgg+78ALVfMBNZbhWZu3n8zSMrq+MOG?=
 =?us-ascii?Q?Bg3VHQpPR+M9E56AzJRk2Fk5AKo3HqKstgAVDH9/CSDUG6PDy9dzYHT9CJzU?=
 =?us-ascii?Q?bSUCW8TjTQhppVRqv+WZeGikOBM9vCNRyPJHaBzyxlUcawfif2O+mZsD38ab?=
 =?us-ascii?Q?v5aXd2B4z8i5boHeLuNHdWBHwBZa83zxJ7Qyc7dKfNwYpoHaASqow68X5BIL?=
 =?us-ascii?Q?V7sX6qe0CBcTfyzZgVg1jtOQEuS5unNBRUD2AdvK4IWV8o1quBnTviPpbYeZ?=
 =?us-ascii?Q?Ye9ohw2fEd800UgzmC1zTl9XwFLvcjIfHanwl4PhiFAAa3eSQbTT9YHsCql1?=
 =?us-ascii?Q?fLoLdJNWShN8lIZkGAZLWt4AWVx8+qFKtiODS2c2Ta40KDfv1vaQfseVkoKI?=
 =?us-ascii?Q?bj0dcV+D1CpTpUk48mLpl8E/radBxaVz+6YUoNAZWHrz8NaA4hjYRAoiWPis?=
 =?us-ascii?Q?vuk1ToyYq4bopZecMx4BdA0nS4Jq7rCsyMN4J6J19OT0vu0jkj1PawHgZ4I7?=
 =?us-ascii?Q?oPcEr8TBCvF6ZOD+SSNYBSvm7799AAAVdafgLkGNgB2pVU7C/jjxUWbMJKjl?=
 =?us-ascii?Q?hz1qbQfesiFC4NBt8pukWc0GFvAZE8HrO7ReslxR2MtZOJGMt+nPqLcvoHvF?=
 =?us-ascii?Q?jfko4KSvJLTOAKH1LVoiWaja4FjaA44PcMBhjntECYRPMysBHuNxPJAKacrf?=
 =?us-ascii?Q?iQE1SktFm+2DGKirkjrCjetmHW6lll8fv1A1Rv9F1YqWSUSuFLWZjDjU39w3?=
 =?us-ascii?Q?ii3cfxwMLyZjTGXX7EsMFFp7M6gHgXyRnrZhpIuYoHs015NAvZvjYKZVCZDy?=
 =?us-ascii?Q?tRtLZSHm4YnyXdvi5tGMHBJP7/b0sWZEk62LJGWsGQJA5XhUrzvHANDVlh02?=
 =?us-ascii?Q?IxHJo7OgbhzIcXMSt3dtIURsQQR/aP9OyyQ1yYg+64XCCb4sdqrJgAewqlaw?=
 =?us-ascii?Q?KV27Lrhx6RfBZg+MFPDUDp++aHuI/oehIbWeh7s4moBHfQNWxLch0LzpQGd5?=
 =?us-ascii?Q?Zxx4oORn1agRxf5lNxJGhJoLOOo/NsCrNrec7RsUPKY7wMzqRhou2+bxytjY?=
 =?us-ascii?Q?MtF74JfReU0OsG1WnhoeFU2HC1CoUAZ0fH48u8/opzk2VUzg6GdJExeiiA2n?=
 =?us-ascii?Q?37KvgXfidaxxGZoBy+JAo1/99tE3bE3YSo00djq7nByzypxuVtr/0Qi/NtTp?=
 =?us-ascii?Q?tdq73fjXmIg9kj0LgTK77GLv4bYGbU5nixaZuEXMVPOGWUvBfoMB/mIU2HCE?=
 =?us-ascii?Q?lR7GImzOUDI3nXdAK5U4vmQ8QFhuRio7uNzoA4sODy8OxKWQMirMobQ5es+h?=
 =?us-ascii?Q?mnjGkrSGowK9BOpH85TaWKzCot1nlPmW0wMLFdzcKfscIg0BTow5EKoZokZ0?=
 =?us-ascii?Q?jdY6bzHYSzwB+P1Njn77kIqUWHJ1xmzZezAB9oitQuL7qUlu5iSXazONahUh?=
 =?us-ascii?Q?O8aaBPOg9iyb3YsszwRC2AGKSf61PDRcppIJj2zMCDwqvdR/52+1BKkm5AyA?=
 =?us-ascii?Q?XWUaGwtmRshZWQX3IC8jIXccvyU9SKCrNsvRie09Se/C0LULUX2v5+snqD1M?=
 =?us-ascii?Q?SH+MUH2qo6aUyYMYe28HHexN4550NlYFvuUN1IxvjeB63VyjTuXg/1GqlTqb?=
 =?us-ascii?Q?+QCASMHDxElVzchQFoOvDbtIiCYjWcgitO3zaD/BeiU8pQQUqGHQK7l8c9fw?=
 =?us-ascii?Q?U5fyuQ2LLwSZeRUXWttI8x0W49mDxU4Q9+tQweevglQ6DFOqlUZKkIVb5s0D?=
X-MS-Exchange-AntiSpam-MessageData-1: CEg/s/VINbKo+A==
X-Exchange-RoutingPolicyChecked:
	CcQ5kKSqBuWMMtxvfHPS4gB8XlTzJXLLE7sdFjdBmW/JDKV1f8zWai1PeujBxywemk/kwavUJbwzGz1bA+aGW7emZHe38B7WBroyuOhaQw/PG+fGqQUqxmRWXttxtkE2XM+Zb9q8qodpA5LAgiuXryY9OWo/XZ4aBtAxu146xG4DdHsV3sPWvXimsh4UaC6hy6U689uGhNe6eigvSoYf8gmmbtDB2FmcHlfONvq2x4M4rPui0M+BfLEI8KOFtnpS/wwzGpZbsu8MkyynFBx+yPP0+PVO/QQMfnS7DM8j0g5rJwib4qKGyHHYQqA/Xo3fhBZAlsYchW24eHGeLRLCmQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tqVnl4cKDecDNk7TvpWfUBytDrah8B2BNrSOLDphmmtvReXNolS3v3Rz023XDCJyhrQ+GMDngsgzfff+l7GxGFTjYhPAm9MUWYnTBR+wT741SyCeiqHTh2EFT5DNrrU81mv2wlRnyjzfIeD7tNsrfIGcvQQ3aEh077+EKV5UpOQuLPPfLKIIwV6+I66nEoN80+tYJ02Um2FDcpTiVoPKV7nOuFzYiQuGhTDPf0pivQJK0XdbYNE5yzfLqew3bDhICpCopgKecK88Yk5MrDsl+w9fKSGQq76LlIjjIxkXhx++2PHa55g/pJHcZmnEpxu0PFEY/t//PJMGEa2PXZgCEszaF3znj9LCCMVRQCgqhrH9qZ8wsGbwbW4+z/AOSJ9sLilTKvMJPwsq/syEz7QM7qlGdAt4Hu40Zrfps+9thRNksROvEtp8cmlnlAOEureQoZFcKtSqv+7s+6dDRV4gMDZb44vf5IxDzLBDCR7giSZAGzNe93DgqqglT+0Tg0qYy1B2bCNCGlJLWAK4Pzb7hA+uqlvRoQ9SQXZ2Py/7eKEOlnpjdyKxKSn+Nf7ehuLtLVp0XzYIJ03Rv/qYXq72SNllcYhx+0EUK6NZV1CLl0SMhgihcFe9ktQ26ptSNyDu
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca97078-ef16-422a-5571-08df0b185891
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 06:38:50.3549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHAHIxT8r6PBoCpXtl/89JbnYlFc0FtY71zUxSvCnpKj59rT3xLGyz+Jh6i6bsAAdfpx12C5FG10TjJl6GnwU6ryMYno44cgI9g5rCJ0f/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB9964

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
