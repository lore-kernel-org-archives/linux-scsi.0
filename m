Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2048.outbound.protection.outlook.com [40.107.117.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D14F192D66;
	Wed, 21 Aug 2024 07:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724223757; cv=fail; b=GQ5NTLHZdXoIcxkkhdqVf5aYEugun4llRbFoZtP/chs5B2FJA6YFbRfpeHLbG/sHJbp/f6V7TKddxL6BOnV4G80bK6Em1gtuyeYCB7mOwgDrtDOO81QXvQweCwCQrmMCAG8bXEGHX9I8DolRWXuXTTbz8jlG9ynJNRhAE0jlTSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724223757; c=relaxed/simple;
	bh=3knthpcdY9b1UB2CuMfp69Fu4iw10obB/6x0xCvYCzM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=mV56G1vqqvIeiJADBgDrrWe6pw7R632aeE7nUs7xNz79df3tXxtpjTT5QvsuYTW+UVGMgRuBhfue3DoCwP1IyBaCzvCzOM7wJ/DGYhY9Okj0AXRw30VqF4qks1Ac5w6uf8jX2ZbGmbQ+5RdoQWWSVuyj8TxeK173azk/Zdwsv10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=UFL5OKFr; arc=fail smtp.client-ip=40.107.117.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="UFL5OKFr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpxMmAqdsI/0z3Kn1wCyAlZQPi7+ZzjC/QOo4t0NmSts/uXoofurdUxP4XXa4hUySdw4QKJka1VHT0CjXzJNPO1S974GIGqLvw6PZnyALsg/C4Uk1hXpPhlqtQu2on+oeIgl1nyGIoSxx+CEbvBLPDHMwLOEbGxie89ej5UbfyNdjtY7awr58VUlQPlCZWhbPP6+Jjp2kR7jC583mBHkUrCvF9fv9BbABrM+MdJ2KDzFnhRoZYP4NJGEZuamrYr1bkgBuOUZH2RFbuOBd/QQtg0NQkPf2cW0T1rLRp/qI6fZhiHe+72Hd+rw8JL+bdyQ0/o6pDQdj3VcTTDvHhpfUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joBuJgplqJ5ipDYuDuhn4NvKsGOaa84RDM3iCts7Uio=;
 b=ypU18DRoZ7kBWeRuwAIe2Ih6869Q22V03fUM9Dc2BnrLisqfN5bSZhqb7hEZhcnu7RNniJDaeTni2gAn2Lq9iGR6Q/v1/Advx3iR+vofMTOFXKCuYnhmj8KU81t1ZjfKRHkVeHT+qQeslOh9aA9W4y9jVoG62h35rQvGXm6S9b6NoabEui1GsOKMiOlNj3amO/jQFxsiRLBkIQomZZGnIk6HDdh6tTgvv/epzC57t6CepOF74D/lPZdNxFjgsw0nB0jkUwKFYGk/05Xaaqd87zbSjl/1GUgwQPk2/7raf72bHeDLoQy3M/Os1UPsSMnPsjCqJV9nD4kf+e0y4KxXjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joBuJgplqJ5ipDYuDuhn4NvKsGOaa84RDM3iCts7Uio=;
 b=UFL5OKFrZFrfHE3RZFs1u2llidgeqxNs0A+pXygrZvrOdgpeJY4wyP4hsloU+2hbVFTUnOw8ZpXfCvkJU+22t1u6/XrlsBVuuZRGKU/K8b6j2fwC7BnUwlQxmAGo06wihWgYzdcJeMoz06nYHqgCdxGaO9s8fFM2PqRmoGK5jUY8VMy7q4z0GrCUGM8BGkrOBAx6NKGFcPdOLPzSrNcfcB7i5aA0nrnwRykZEsKRXLtc63itV8iltS0v9qIuwm7ytiNvUPSN0kFHhJO8yVRZ3arPNyFRBtGl+TKPTnVPISmqvGXz3Afl8MGCxBOX9+SWpy80BXBNJq0oY0+72Zx7ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB6263.apcprd06.prod.outlook.com (2603:1096:400:33d::14)
 by TYZPR06MB5074.apcprd06.prod.outlook.com (2603:1096:400:1c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 07:02:32 +0000
Received: from TYZPR06MB6263.apcprd06.prod.outlook.com
 ([fe80::bd8:d8ed:8dd5:3268]) by TYZPR06MB6263.apcprd06.prod.outlook.com
 ([fe80::bd8:d8ed:8dd5:3268%6]) with mapi id 15.20.7875.019; Wed, 21 Aug 2024
 07:02:32 +0000
From: Yang Ruibin <11162571@vivo.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Yang Ruibin <11162571@vivo.com>
Subject: [PATCH v1] drivers:mpt3saa:Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed, 21 Aug 2024 03:02:20 -0400
Message-Id: <20240821070221.7157-1-11162571@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0179.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::35) To TYZPR06MB6263.apcprd06.prod.outlook.com
 (2603:1096:400:33d::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB6263:EE_|TYZPR06MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: ca8b6394-348f-4c64-c237-08dcc1af3a2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014|81742002;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ihiujB9/Cd6bVOosb4iIP4z390XFRc3l3+bsofIQz+mGoJMFFDm2vI6258EG?=
 =?us-ascii?Q?0zjImwmRKhCtgUktwb8zTZUxS60p4pYJahex8g5j7OcJzMKtmjWRiF9MZFMd?=
 =?us-ascii?Q?pKoLV9k4B0UFrO/8f1CR/RzxF5PCD3MKmkevXmzPUcKzfnaYj9/o3/q3WEvD?=
 =?us-ascii?Q?RP0it6E9i6m6+7ZUh6fFZvRXMcmQ3sujkh5u1xspZcizU3vOAmJDdSCE6pNA?=
 =?us-ascii?Q?j8EiAQLwJ3cdShG8dL4xKESMmfCKvnQA6sLk2+crE5VM2ls7NVQIpdmjggWW?=
 =?us-ascii?Q?8W0cp6a5nDLHAhMxKQKCjlQtTLD9mV8MzErTc5dUlJe89buiZBJwt1WlT6De?=
 =?us-ascii?Q?CUmKujK35tccvtLN1kghrAD74DQ8W+2Sb9yYfsfg9HdsMQ4gndy9mgKEs80l?=
 =?us-ascii?Q?HnZu7NOZUeBYu3sZ7vaL95Pr1RFLEUes7T/LU/VkK2wvDamObuRWt6M7SpPl?=
 =?us-ascii?Q?qNu5bVpYGoXNvhiTrXVYk710CdJ3LWKE0TKYmU1lV4RLmnUmXD5yoSBMElym?=
 =?us-ascii?Q?y/QDdGZqLYFBeynBj+kQaPQVV2fIOm/ZeNjifRCsm/9UIlQlNaWT+VKq7InE?=
 =?us-ascii?Q?1BTGDFq+qGJMz8VWmI7MOt+yI9g9G61qp1ncu/7LGW0Kwh2bSrpkck+QZHN9?=
 =?us-ascii?Q?aHj5k2J7y/PNbCntF2CvOz+N9ryPy4OZ+vrkRNe2TdfqSWRDnib+SQicCuJq?=
 =?us-ascii?Q?O2j4LPks9bBQyc5BbbUpk4d4KIFufgl3dyzgJn9IRse22Ugb1xHttmAz+Di2?=
 =?us-ascii?Q?0RdO7m38SM1vrD54BMPItDiDRRZ3Vatn5d1vQO9L6v8qogxzJOiLR4blvNON?=
 =?us-ascii?Q?TG410MvJ6U+3C+KEAWfPGfy/O3cPIZ6CofrwPmLFYqAInWdZTpsdZehH3CUU?=
 =?us-ascii?Q?wU8wlMCXF26Ykph2iS7vvOlfGqE6OhuyYhPASw6R2V9l2CuvWOIzuIipC74h?=
 =?us-ascii?Q?5ja1S4VoLjBLd4B83e7etRhq2xDC5rTZQn+U4XQh2Quuj5CDEmCOfkTXvDF4?=
 =?us-ascii?Q?CcfVgiILsh0+viddR8W44gyMioDOcanTvfXwjcafrCqkZWRlRPVyGqhNFARU?=
 =?us-ascii?Q?GTHi+Mlwlw2tRD/w4sLAseZt1p4ETUfWV0vqekOjv1srorW8CaT7BSwnhqbq?=
 =?us-ascii?Q?dxB5ViDv1hA40gIhGzL+yOXyct+BBB6H/O4svk/1nFhjbm7s3pUIvleA4wYY?=
 =?us-ascii?Q?ylEzsB4kO3q7pS64TNWzcPaWx820y1zejLlYYmH6Gv5JjfGKYVUZQEv0n0sL?=
 =?us-ascii?Q?r+Pso2FK23YZe7P7xVk12XCFesajJB+OpUD9RUSmboTOh2wi92Yj4KUZriO9?=
 =?us-ascii?Q?WBUKYkI6utJraMkVdIXg731mgsn4rZbl0PwR/EQB12FeuF58LGDcE1EQ6+Wq?=
 =?us-ascii?Q?LhpYXyuxxsDWmUPG2uZVdQl7YffLZi3QzcZOvXBraF+hSpOHioOv8Rrzz4GQ?=
 =?us-ascii?Q?7KGZRB9tZjw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB6263.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014)(81742002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?scbdyemFTR3UC59ydK4LtJyPyX3x/tugVUIYgMXunxk0g2fBttJg2/fMmd79?=
 =?us-ascii?Q?APuCBdXPjow7d6URZ1+1ig/xW0bFtrKhZLJ4F+SFTO6GQ5Qh6ozZ+RyUXaVX?=
 =?us-ascii?Q?MdzTOFdPt6UXQUZD4rpAawl+fNF2fe5iUPNvJFyNwvYPU8nwTrEYyQwklhbX?=
 =?us-ascii?Q?Hv0pQCAYHvMbVIbowPnYcvKdGrElQukuY4ezvIy/fenjQTykimL4D0S2ZjvS?=
 =?us-ascii?Q?hd0vOC5r7rnXBzI4qqSASxG7QMTfzmujRYZE3firbUrMsXs2LMvSrBB7v54I?=
 =?us-ascii?Q?q4GZ2gCkO9zceYn3NdDu//EM7Fi5/+C7BUIfavf54BR1+l0Wl7w+/9atHccJ?=
 =?us-ascii?Q?ASY05YSj8oguYAydI0boLuqbAEVN6A0bppzgYJ+gVzIvZSCMEsWGqExhnt32?=
 =?us-ascii?Q?uq3cjVDQP2P90+LO5OYyL5KxItb9a/lg3TO/Mj8akWWvg4dZ/con1ElPVMKW?=
 =?us-ascii?Q?zlkSKzbZwvSY4f9frbEXojYGWhAGfHBOEwAhRZ5ntS2wlYB7sEJW9qNUouKF?=
 =?us-ascii?Q?wns9iYmdBykYU9Pd9mec3wwqdikk6zcZD9msZ89m4cN5NI73mg62/9BdkAFf?=
 =?us-ascii?Q?e7BEPkLsBE1BWeZik589KoAow1Mg5kD126D+goBzotZt5kBG+9hglVcRiS5v?=
 =?us-ascii?Q?HDtIOfBsd+UbxHbml/wKAbreHdeV2/Q3lkOmIyjewPVoVcyGzmffn5MpMr8L?=
 =?us-ascii?Q?QW6jItHxDbDAWVceTYc++pkwiQy6OCEOYRNNIb4IPMwifFr8ZOS8SxOlJRgE?=
 =?us-ascii?Q?qCESpB8MqYVr/1rhg2f/hpPTLupHyx37CMrMcNdAbzg8oh7ohmJmVk8wqWmo?=
 =?us-ascii?Q?DokMTuoQWIlBWlrLo5tSASzezy9i5qDvrPKRDuJICsKQ6ZFVGKm+FanvM9/F?=
 =?us-ascii?Q?66GsTv+4D9y26fVSUFY7KnNFkn8dDPWjNgOByEtdRC/sNH9Vg4e4w7ce4eNI?=
 =?us-ascii?Q?d+SBakvlBUvFtAGyX39SQmhwPUqgxTPoeJKeILUBgtYSL1HggtL+iHtMsfFT?=
 =?us-ascii?Q?T6o5UHUF9LzGEGSHn4HlMwZGfyJKIQslswUTvTZ5zdf4lroVsljgZ8XIVMAX?=
 =?us-ascii?Q?RmfKBGvqwuUwrYbobmIfh3BwpcWExW5S2bJdCLkODiB7rmLAgKeO5t1v2s18?=
 =?us-ascii?Q?BUb8S5SfDjlHGbo+xrGt20GkkEk33Gjt1P9Uo8rjh7ejFRZszfqBCk3Dbs0B?=
 =?us-ascii?Q?yEP+sbJaliMqzhGFxliPZNQJoaiM846CKM6RE0diJ7GKCAjldjObr5TPgMud?=
 =?us-ascii?Q?9L2xYUpSVKM6OUXx+9azGSnTBFTQBXXw5zy4DxSqIBrHoLgdr9UedFlWLcxo?=
 =?us-ascii?Q?ivBBCsUVziZnf7RCPVDxiiwKMv4zth7UKr6mESM58xIzpcAzBS6Q2fiXDIWd?=
 =?us-ascii?Q?0+T7doFIJ/SLTK+y8KRiEkMefkPccY36Aku2D5mWJTu6VoLnBsO95qeRwP9w?=
 =?us-ascii?Q?lGHVnNJ2SJyVwLMa8klDvUKaFkYrP+37yydxkUN2wdQxJeEzXqKoZ+KxhjXd?=
 =?us-ascii?Q?4EVJ16WQsCu1t5+AsH2yCmH8CbZ9zeOwMMOXd3gteQCkmr1yx4L7hHsarfho?=
 =?us-ascii?Q?95+fQkHQva6+73MIcGY0MKYQIrK54DrmvLrH256c?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8b6394-348f-4c64-c237-08dcc1af3a2d
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB6263.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 07:02:32.1081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1BWexCtIsLeky7sxygvv5DikuT2mhuTACLMkbxeXj60af/cyUkmsztviQtKmxzt79kG9haY7CTwpUPn93YFo3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5074

The debugfs_create_dir() function returns error pointers.
It never returns NULL. So use IS_ERR() to check it.

Signed-off-by: Yang Ruibin <11162571@vivo.com>
---
 drivers/scsi/mpt3sas/mpt3sas_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
index a6ab1db81167..306616bdea83 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
@@ -99,7 +99,7 @@ static const struct file_operations mpt3sas_debugfs_iocdump_fops = {
 void mpt3sas_init_debugfs(void)
 {
 	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
-	if (!mpt3sas_debugfs_root)
+	if (IS_ERR(mpt3sas_debugfs_root))
 		pr_info("mpt3sas: Cannot create debugfs root\n");
 }
 
-- 
2.34.1

