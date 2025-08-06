Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013031.outbound.protection.outlook.com [40.107.44.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC9118035;
	Wed,  6 Aug 2025 12:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754484409; cv=fail; b=SZqjWvp6z0T42PNSQlh0D/UnBqhocSsjH2CQvb01FNbPBwlja4lWwKjvwNjoXzHlVez66vkX45bKfNMEUgWr3rI3DLVpM3MS8DKF++9G+ugDYsTaOOH4N57BuNPf6unoB7XaP5ZSD/Ibfd0h0f/Bu5WWv2YuXPQSi3M/5ElML/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754484409; c=relaxed/simple;
	bh=6uu+ZaJu2yAjDesrhoPWnSnNze7eW6FcZgwd7AOmoHU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=aH1QXYCTbFj6HQjX+npKz1BsGkq2uGqSIsV7Db1ofL3DONohgzqrdQq+oiSrIW2RkajV/2ofAK+CJWFHaZmCFnuKLRWbz1/Vj7o3sgshE0kDto9LSyv0kda1Ylgl9zDV4eq8eeIGakkEs+oqxK+ZmVF0cm6hr/GkP1oDjNdeEw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=goXkg0x3; arc=fail smtp.client-ip=40.107.44.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="goXkg0x3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBYOyH267Bw3VEbmMGq5cUAFFnH5XbTBd9v9ibTaB7BPcUWqeTx9vfjr74x+fHvsdys6gqPbnDcBVmtAzYZkqiUjZtSDW2hmi6Q26GvA+vmrtOkqdcPQ/6gHX1KcNtSOXNE0ilTJPXImiAf2rCtsfUOVwmVz5QTeTe27biMv+vwrL++4yCCHIHsUMHQ78lDlEcgD1rN5jaI5+uLw5/b2sqV4tRJS5WOlFc7ewKmCTxUXgeMUOgGhhbB+Ho/rp1Fg79vbL8RmtVSsHEU49WKx342D957RqGJFVp6nCw8lu11egfViaSxKDw83S0BysmbuJQ45dUL1CL/+1XOJeZ9sOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WFaE6y9shtQzaz/hKbQT5bx1PanHYwngP1YtNzunBo=;
 b=vc1ipEV9vC8Uwe/uBR3BTndr/OkDL+w/hTAbsQB8hcPImUfkmOXnSUwIOAxbQboZzKxKFgN1s+nd5RdhfCDqpmi6IqLCRa5Jom6+0Wdr5H4kzsMxQOyofME+KqvoVmqaRdMOzWnWneKm1moLsEjgkba1pHyDwO2ETGumSJUJUyWCXOwb1bR92ksUx9ivVgVht+3qvlRiFulNZXJfkgcbR1JiLseRDQAWPKJ7MWcNEZa96uElgixKpGim0tEomer73Jt+POAHvX1ItrDLuaW4bYKGQ+5lhHaBB8Vjttl3IbCtzezloqr8POurWG/Az19J7PAsVEOAi2et8DjZEqufGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WFaE6y9shtQzaz/hKbQT5bx1PanHYwngP1YtNzunBo=;
 b=goXkg0x3r/1RG5TxqXHugAsWhhINvzse854JjwHv28kCztsFOLmC6sulXCouLOGOtDfg9/1ec9oAjn0iYRDuDsLlsdywmCDRFAYiTHHNaIVIgkQnpcmVavN+JijzyvpbVKpFc6kkFcuU9E++QT/qbxPFvUS1I1SaTQ+APey5/m3aVjIjg4G+Ir7RPH3KDfMGmtPttUbq1qrX4GkEsiF4nAFysmw9LwkEUJLAVuIND1xG0CNgRnZN2cJTz0kYjNI/FvZiTsIlOw9MzT8KcXwajN8wNJSSiudf8POeCPvu5Depl+uTJ0iLLtkRbf4vshYxbeaF/xgBlhilhqOBIchKWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB7283.apcprd06.prod.outlook.com (2603:1096:405:a5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Wed, 6 Aug 2025 12:46:44 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 12:46:44 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: bvanassche@acm.org,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH v3 0/2] scsi: Use vmalloc_array and vcalloc to simplify code
Date: Wed,  6 Aug 2025 20:46:31 +0800
Message-Id: <20250806124633.383426-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0045.jpnprd01.prod.outlook.com
 (2603:1096:403:a::15) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB7283:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c4b865-20a1-4bca-052d-08ddd4e74c32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bv5MoCHNeUAnHDXkUA164xsZELWpOi/V14Mj6wFFnD7q9fyViJZsFEhFEKiE?=
 =?us-ascii?Q?ZYSh1+5aiNMn5t+PEn8gRnQcA5H9aR1joiJt2/ebHIZwmFBKDiYOuYBDEaE3?=
 =?us-ascii?Q?yHFTQ9JFpTHh+wIVMJOnCl6eu7a5EZvwHnqIcfxwgb/iBRpZnsfxRDK9Z/mH?=
 =?us-ascii?Q?iFl2MM8CU5xBBcjey7Ujufr8dhiOwcUIsBSRihIsAXdeTIYhieC4Gtc8brIC?=
 =?us-ascii?Q?OforrgjHEkPUxioQWdjKlLWo1lqPYC1KpQv9VgmW4Wk3R7/CWUjG7sczuhGd?=
 =?us-ascii?Q?mIR5/S7WKnZMtWrOYPaweHIBm2E7ru+ql8SERFBm+6A7/wXOznivpPdHe75T?=
 =?us-ascii?Q?x9BDk+O82uJoMcjbhroYTU5P8S7ysSLsi4xwdF8hKSzifAKWLlrYWNKecpEK?=
 =?us-ascii?Q?UUlVrbP7zIy/KSuUW8SCODlzSCXNcuTWr7Js13w4wQtEjabkCMHOzxXShmfk?=
 =?us-ascii?Q?AtK8R436ZW0r7vkLzzQiiFUn5nhz+ZVpQrJGal/r1OC9+ms0fBFWFVq3lLcE?=
 =?us-ascii?Q?Us5jCfWdVDXsw+lG3Hvg6aCTVWBKOK76C27a9agmEK75UMciOBFE19/QluJq?=
 =?us-ascii?Q?2Xrc25k+cO2KbCsaXGZQBqVxc+3UrHtWGqqCRFxbKCC02QQZb0Pve7sCTK0B?=
 =?us-ascii?Q?KjiD8RNoto1GuRm+HcVmvXCkPc65BFKA5BKq0K8h4/1YtqZa2SMQt03oHcaj?=
 =?us-ascii?Q?JxS8unttolN5efDY4lIsF2nC5gHSilOlmAh9xhRrUYkqHFpLuDKKl+IEbIq2?=
 =?us-ascii?Q?kHdSIpXsZngXpmKfsTi4Wd0x2XpJU4dZISVWdJcwpW4+YRE9x4af6QebLyia?=
 =?us-ascii?Q?CnfU4FJ4vKVBQgswX99brOyCTkIrGYBBBEGQ3mxBI/GF2eBBEFbX8eocU2We?=
 =?us-ascii?Q?vbDSuna4SgQeLnyKUOW42Njf3ykU1DiUKtmjOVFLRLoW0AKDNT/EE4YSveWX?=
 =?us-ascii?Q?W9RRwY3/tiiM5/2fCD5k9y0AK/rBnzdowxRuItXxUoZ1nvMHWKRA9tc/UINw?=
 =?us-ascii?Q?yWvmtZyUkoKQTb6BBMKJIMBQXuBVK95eOTVHaksB2It1zH8wG/N4v4APwxFv?=
 =?us-ascii?Q?EZeiVTLaj3NW9fyzb/tht7Ap61HX7aYNN1Mdu7Ee3tke3Hl9gI5RKbnaM0VT?=
 =?us-ascii?Q?19KKTSVLqIshQ24NkjI76k9WLP3z8DO32IPx1Wp942c145TpMrVXdU23GyzZ?=
 =?us-ascii?Q?6JycTPKlYvAbiyP005WMD35hQgHJ7oyTidBxdltsBIZE5J7coZYAVfJok+rG?=
 =?us-ascii?Q?DRgmZHyyGWnKI82OshBwgdghhI7mxE7215/PrwG7JtrSRUSql2YBlSPIi6Sw?=
 =?us-ascii?Q?xyDS7WKeCPuJ1Cc9EPnjTJ/vE+xwZEuI9vU+pq03a6CbXhOHYOoXunkIY8FN?=
 =?us-ascii?Q?9K6h9IAJb4i26qHcLOZkj3BHN1l1AX6LB60F60XpEor1NqXpwgEbhbDUtUwF?=
 =?us-ascii?Q?1y+21Q70xwFFIQmqFObrx0A8EHS9pfKHSuYPpbaNpeTmYm4nYpbGug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ufLKt2iiA2wa9sJD4tAKQmMZSulMn6IKM6z2xjIVjJEkXAjX546OXqEUi9Am?=
 =?us-ascii?Q?QXw9CagYlNy3X2YxMScryu/Q6xSP8SNt95jWXQV1dDgs2UbDMwMAF4DVEwn7?=
 =?us-ascii?Q?Zh33vu6gB0YE4W//Eh2Ou2y+sJ8NbbDeUhviP0bwEVtGMkUCus/rFQC/VLWw?=
 =?us-ascii?Q?oeR7I022xkl56Lc12jlz8fws1xr8xs62ebWwTSGaB0IS2mMt+UpNzf0d018B?=
 =?us-ascii?Q?SgUHwIc669f+xfaK2akXDy4Z+2poHApnZdpGEo9hc2Mkf+6qlLvBz1Fnap9O?=
 =?us-ascii?Q?wqNq8bkxGl/XA/5CY62v9qxvPCU0UUM+Bk7BEdDJdFRMFhwgnNgtp0WNVMaT?=
 =?us-ascii?Q?2eLDhGgJu8KQZzzPSk740rvtvwcVXWEFrmBdCBnw0NQSo2rAgiJzPnJeAIXW?=
 =?us-ascii?Q?/dG3beJ18kOEFB2Tc4Vd4lBpADSv4TpHkTpPizhurDFjYBOjxlCcVea2nRCr?=
 =?us-ascii?Q?9WudgAJ26ooUB15FyxTW1LFmoUIgvLbhYCnKH1G5V6hQ+KG1emuDIrTrgZcL?=
 =?us-ascii?Q?wEyAwELsFKfzin6gGzx8KUs1uzHK7FqllG4/fs8zVlPABbSZJHXsjHQiSj71?=
 =?us-ascii?Q?Vk2h+S7fo3SOJeN6AmIjik2ASYDHXDl7U4iy7x/O+SqIUyXodsqgJh4B1L8e?=
 =?us-ascii?Q?/KcnZKmMLRqWxoAo63mP6/pn+JV+lvMAZ4XTsWn1flet6YFjuDfFxif/HBW+?=
 =?us-ascii?Q?e7gvyvb68f/HzeQVbDwKI743fn6f/Vz/z3f0lzJK4rB2vv21WF/kbQbl59bI?=
 =?us-ascii?Q?PCY2G8BhdgY1vRJh1zSH2wsTH/NE7eanrXaRwkwl3uU5PMHvubNOslUouOpL?=
 =?us-ascii?Q?rRp5n7BbPGgggU+h47Igrp4fP+zm0THxtMSDsG2Quw67w0dnT91B/Bi2vWNS?=
 =?us-ascii?Q?RYhLhs2BjF+zJd8ceDsc9QVTryr2fswZcMJFg6kLD2M8K2X6gPddd4jMktmw?=
 =?us-ascii?Q?cbcJO7TcIbzQ+2asCtJcfDnVW/Gq55zlOErY/FNODomjNapGFVm2xS+slXmP?=
 =?us-ascii?Q?NGxpfOtdlTIsz69Sm2gE+W+x+g/LtOb7mfcnHSquMBAgO7h0scycXlzSQDBQ?=
 =?us-ascii?Q?c0rsrJRVbCyrxjYzVxw/0rNJZC7whaMEEtMdmuVa0DFAVCCAFBhovcVdoVOq?=
 =?us-ascii?Q?yaMjHTWojTGxw4Q+jnkDpqee32OwX1cMlWaHx7oL9jR/qIt+VlVPvvWQ08ed?=
 =?us-ascii?Q?A3qJhBERndmuVFBdoP7LIXGIZiNScQiFno7CTN32/FZuVj3jgtZ4hkbN63Ri?=
 =?us-ascii?Q?JIjsA8hWG81kfcMW+K6ompx5kS+X3HgPWZaH5qm6AafcngF8Z9vM+3E3Fr6H?=
 =?us-ascii?Q?ouPA8+6EbO0+3iiXyDcoqepkOyVBQnvqX7deLg+ej6I0FpwYDm6EVdTg/nKq?=
 =?us-ascii?Q?YRq5rNMHISolZ7KEPAoyEcK8iX5NpNX3p/LoxXcORblMNgSjZTdA4ZKVgCc0?=
 =?us-ascii?Q?3gqKhlRT41Ed7aY6An4gHRZmfldm4RGi9t+1K1Q4VVkvvg+j0P4VTs6PykIb?=
 =?us-ascii?Q?2Tp5Y/6sdyKs7hh0JvXaIKUcNWYK1oTNXMy7r+tidPA3iKvcseCEk9/CY1Kc?=
 =?us-ascii?Q?zdU4Pnxr+DCjlxBrRrSILJjeWgZvJSOYMlLevV7b?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c4b865-20a1-4bca-052d-08ddd4e74c32
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 12:46:44.0100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fs924PzWl/SBon4ARj+BffArz4ISihJUcsat6ZQosWSdVrwwOK7w4g4TdvDy0YgTDBRfsrGeP5rsYOp6LjmJbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7283

Instead of using array_size, use a function that takes care of both the
multiplication and the overflow checks.

Compile-tested only.

Qianfeng Rong (2):
  scsi: ipr: Use vmalloc_array to simplify code
  scsi: scsi_debug: Use vcalloc to simplify code

 drivers/scsi/ipr.c        | 8 ++++----
 drivers/scsi/scsi_debug.c | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

-- 
2.34.1

