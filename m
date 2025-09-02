Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012053.outbound.protection.outlook.com [52.101.126.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743742D131A;
	Tue,  2 Sep 2025 12:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756817436; cv=fail; b=CMjOhRxJ+SK0ZzLY3DUA7UXhAO5V3GgZScu6oufFxJYUceT6Kmif0/tDvkdcLkDOJbDYg0e7e7j48C4ObOvrEAC9ft3dFM7Zl2DXdsC8eKM9pwkWu8qigQHZWXu3ah/FYaB2+RQr0EJ4x+gHBAqn421K0JF5Pc+MMU+dme63DJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756817436; c=relaxed/simple;
	bh=NSnc2SZRI5O4qaazBn1jtyN8Oplmd9KTkeLcob8Kve0=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=syFsgO2NjmpGNksvlFrPvq/dn97IcPX3M8XLCY+aG+qRj0EkNGfXLQBmjDYq8/BJ+Dyx0zQIkEfHmj7rXTvaDasMBzfpupp4la1+i9BpIQN3Lcjxv/ZOABLKEcM7Rmc5euvlboLVqv7hHUno89x1d23GhTrOQHyU9ba1ZTmMHjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=LqG7F1z1; arc=fail smtp.client-ip=52.101.126.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="LqG7F1z1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUb7h004OXcCKdvYOD+XUuc2Rdt/PLChY2kELblHsZscCkAq52ZfBqmmTy7ta1TC1t7ApSciqcqecu8axKs2MCbUJmw3UkR/4LBHA/rTJMvt4PKQAuFY4cCg47fes5wAF3fZsYO34mLJfROI2K/arKO0NCos1qxzlDZ5YSe+kmW971tyThJV3/HXA0ph0DVPq3H2sQ6SPjLvKIQ3hnCL1vAxkibUSSCGDuH0SSSqGgFytZszyEtV0tq/fTdV2KesykqSDJFsOb3gjTUVaWJ7wfi5L3kzgkHGDNY3QjBScbFauRZdnuornfvoCOz9/1o14lli4zxkaAPa0R+haSd6Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SUOXOdqf6YpxYGCCScsNSDSmVWSDq8M+ikr0gWBZpQ=;
 b=kHyl/u7hvArqojtdJ1fk4VXf5ofFi8Anm3XirnyCRjOELXyXdycd9JRwzp2iphmt4GrygNxPFZVoNEXebCkCDbfySbdyBUAJIjM1qz1gI1GrRiEdGr/+Nua7JcIJ9OD2yJlCH4AgvEMhPElk3boNvfmQrLMr96oBViJPj8tCgSY4NYSVB4oH3kSG/qMftQPYPKWDLY6TuheGKA55RTA1OookuDhPCZ87WWN45XlQsyOMa+VWiu9Ow+g3pVi87wwfsRp30gZd6DNVX/kEfNVQGQtEa9KA9zFcXZ8/4h3LXXCuPbgR8WBGD5A6tUU8euRM/1c6pUKL7mJwNakIVEI0Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SUOXOdqf6YpxYGCCScsNSDSmVWSDq8M+ikr0gWBZpQ=;
 b=LqG7F1z1DDuW0fusjcb6oDxgrJo+NY9nP4eT6m6B50A11bSiqxm3iSxCfU1RfY2wImxxwdDVARn5J0+M2O5xK3G9l2PjnXfY0rZCUuc7V1nNzPeDaITHgJu8n/ii0l5UIGyDKmzMHkhUo+j9nqGx43Pwx8pg7nxFkHv3R05gtRuqshi2tqzp0jUDseHtX8i0Fy+5V2yOMmq4FGohmapACI+SUNCh8y0iol4NOsE2yEtPrnKcDLiTtqeJcf5/UKD5INKL7hoARgUqLl1y6tItOUAWIc6M/DZwo3LRFVxeyVX2kyL6iOfvgOJWlRwou1NnGERNp74/lZKqe6MmiK9Ocg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SE1PPFD39B554E0.apcprd06.prod.outlook.com (2603:1096:108:1::42b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 12:50:28 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 12:50:28 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: Use int type to store negative value
Date: Tue,  2 Sep 2025 20:50:14 +0800
Message-Id: <20250902125017.41371-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0121.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::8) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SE1PPFD39B554E0:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a77f142-abbf-42f4-7cec-08ddea1f4af9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nYMaIK4NS1PLqH02POdqiQa0rlsLE8KG/7zBXfk0EKjxBjn/cVAK4aYkz3m7?=
 =?us-ascii?Q?Iv1VBbo9uhywN7Ijiq4OgTtb9VbUHuRMTunD0LmK7aaUMKMuHZUx26sNYcxY?=
 =?us-ascii?Q?iKnt9zEQNeQc4dMuvkEUxND5UMs+eW4NWFVGp5e0Oz6uZoP6Asuss/nsF4yB?=
 =?us-ascii?Q?mdKTCOeBk4a6n9q8cX71j8LVugZrYBH8P41fvNQ1ZF2SisCq3ZPkocuBYRj7?=
 =?us-ascii?Q?teW9mFISj9VIFdfdeqECSv359ijQMFqs7AojLFn6Zo7boVvKUTU1cq5l5Hu/?=
 =?us-ascii?Q?aQ/Go3YBBVexqxN2l1mrXDK5qJJzf6Px2EteFYvpXT7AL9WIFk13I1nuRvlZ?=
 =?us-ascii?Q?Ka/vfIsLuTjH0H5kVtKHzMumw8zEaIyd60rj3Mc3vZqi+2ZoTdJItYElbcJy?=
 =?us-ascii?Q?6VVNwKgFqwkuBMk6FShOgclvdnxnQAW5t9nEEa2jMR0chj3Hj9BKUFdLGCi7?=
 =?us-ascii?Q?cphIFwDzoPLgZcH9N19hd/TxnQwemm/q4T1GNr0p9opIMJ/x5EgRZ4rVneeN?=
 =?us-ascii?Q?s117ZsS/YTEZWZ0h7vcmW0E9kxGCcCl2i2nnaqED4sKL3QkBHk0N8Kx9Mlrl?=
 =?us-ascii?Q?LsE1Bg96J6vis6lGJjI+GfAwFJu+tdfWibOrKmVprdgV2cRYikl4cEZgYqWv?=
 =?us-ascii?Q?X1yJk/eEny4zjqQbWXOeHrzKjrtW2fC6PakNgC58tGvmBh+swYEqPNZPcOx2?=
 =?us-ascii?Q?U6rS0egsCBDiFCO2STXKnd9rgyDJrOBdY+sjUcR2OVfQ9Gsc62zCxIvyFfH6?=
 =?us-ascii?Q?CCGF3ngVJ+tri+yFQOFMRjGGgA2J/psjWG98RdGVi7nf/s/RiMxkiQXK9W/c?=
 =?us-ascii?Q?ztTo8tAGLuZS0jENARPQJKHTcNadobMnnPWed2kblIrn7VvZiWLeNjw55yEG?=
 =?us-ascii?Q?lD9xMdWgtw72CAxDtQqTS8KO9cW0ANET7y809eUe7BDPihrzWjY/NMaJfkzi?=
 =?us-ascii?Q?ZNZpOSXQzg7qb822a95adcYqU3O7QNMVNJ+azS1rOrBUO8nxX5jxc4wTyIp0?=
 =?us-ascii?Q?O8zqc/AC/EI+ahoiIhGGKjJfq53G/sOIiZgGA09KTMlUravplUE8UxhAu/9P?=
 =?us-ascii?Q?sWDtreTxsadrxGVtkoTF6ExzeULLDEClDa4j5s/CxOS2ifLyihnpBOL3gyHO?=
 =?us-ascii?Q?28sQxQPrWWqguT5Rejz+LCf94oxips41WiF67joHhW/kbDVq0Zw0/wl7Di86?=
 =?us-ascii?Q?fIF1tQssGS35WVYoNN478b8vV+3sxIWOo6bzD56yk7pBrYCkVHNzqKBj2VUp?=
 =?us-ascii?Q?YcVIeK1vYBv3O2Krz/Ub9fbsDXfBpxs1JG3gIj9MD13xZpftwgCeC+JY5vx7?=
 =?us-ascii?Q?XYvEwPr4Er/GRD2krp4VMzUs1zVe5fUznpnkyICU7o4KV85krR/TVGeU198N?=
 =?us-ascii?Q?Qx+VacT+ngoJoNVQo8BsqtAEIZY8yR2Y3qHpg0AYFaK/WoKvzBGP2ZlQDZpu?=
 =?us-ascii?Q?6S4fjWAVwBE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VxXxI6mS9+ZGWvEJqRWDftmpibXh8bHnMQbztUu2mZQ5dGiEUDVcDM0xY8O8?=
 =?us-ascii?Q?yQGHUdfOTD4UHXXd1H9217EvFy6YI5wOJQ5XG6FpRF3LHIdHofAoSJ/jdGtl?=
 =?us-ascii?Q?pmzI6JYt2L9mW2kgW/4Vdd6ylsMtchUWOeZKmDV7/TqbVTpJL7QRpguQcdkN?=
 =?us-ascii?Q?HlwrN46STVMqeq8t+ZtE8oQ2l2NRj4sbYKZtJ+UZr2bMhao27erQZuOr4HoG?=
 =?us-ascii?Q?dBx07CAdylQKw797ncAVDKWE56v/Zx04q0SWHlMsGYFR5cenlg1WjQDhXZ5J?=
 =?us-ascii?Q?9ow1Z3PjqDBzX6CH6lomEiAyKArDvlIhvbxHJE0PNxVQThPhzUDONISZ/aa+?=
 =?us-ascii?Q?s/kEATyyCCYMZ+VaCyD2nNmn8OPX5O7EtnSeJlO3Wz8LX14iCk5HL3+M1rv+?=
 =?us-ascii?Q?umlhRMWlD4AbNvYg1YOcyu2WuRd6JnSRYirXrDSy2sqCR+lby2I/OzVNR82y?=
 =?us-ascii?Q?ubxRrolu3LdXnxDbkMgooXA4bLzbGUBdQnetuhpSolWWdwaKTvtteWIc0TcC?=
 =?us-ascii?Q?ugBOFDCgUyqNE1p43PUibWyTDXhJ2z4eNMnU6LUpmLnNwQK17PJi5O/sn3Zc?=
 =?us-ascii?Q?XF+7wLYuHD17N97pWq/fP+eEnwMJma0o9OniwvnvVXFGdvSUYuGfG6YBoM47?=
 =?us-ascii?Q?kn+B9oHWgj5Wron0825hTzcP9JLgt6o5jIjw43J6yKUwcxl0wluXsD7XFId7?=
 =?us-ascii?Q?vO/3KKgjpJc0/IlSO7iopZwHb43Pekwv6AN80SEcp+l27qtBjYpuqxLtC9pz?=
 =?us-ascii?Q?OXnLTZBhU3aGEi/Rq1NsyS78MRzFnsbca+jOPRfF4tHC1fK7DwiObVxVVXpq?=
 =?us-ascii?Q?VJ66C+2v6QzPOvc7IA6MP7YjiWtEnbLuiIDTKYEq6iKNQ1S5wpQgPPeusrg2?=
 =?us-ascii?Q?iokdgv8wPfPe4jOHIbdliadl68vWkxZUkYMcy6HXScm0gpK2hi+3DfPsa2Nu?=
 =?us-ascii?Q?Pz193/zqPmNLQgjkqeIfbf/0m8855pwNVQbnso/DlJRGlKgbLQD+SdVJfqKH?=
 =?us-ascii?Q?wHGQ6b8kYefgw9fwf4ZBiTufpY1Q8Hk4gab7fUhhau1r5ZDLjocqMyJvwOO1?=
 =?us-ascii?Q?ziy6vgRdN2L+xkhudm2NVOg90Im1s2X+iZl54m4f7FbXoqt2YD+EBxokvSmB?=
 =?us-ascii?Q?ebfqZDCOl8zNK115m/3v2QZJtKaVOmI4m4/y7VAYoH/Ph5VRPvJ6SlMZeAuh?=
 =?us-ascii?Q?wIgOV1hYh3U+atDQOAtJ+3uxcNwtqNLaZd98sBj2oSBxpmz9zNPzwqiK8XHJ?=
 =?us-ascii?Q?zaQvoqQXqn8WoZJ1ZXdnL6z8PzxhtyewO6uCuHb6H5CRHPdEEMboJPPwWn6c?=
 =?us-ascii?Q?KXMvCA72IOy4XiDCmO6qokiYmCM+MTf4BvW9LxsUsZqUxCYYla3ND3GNtHvB?=
 =?us-ascii?Q?X2XOXKQftCRAiYfEEiH9N4OJw/hMAGyMyax0RR16sRA2PxqhOSPueRIfe0c9?=
 =?us-ascii?Q?onAYQRGAZs1aITcBU6uGcoOGwEzG7rWEGh4ckSRcKaNnUAlo7IR75WhGsLaC?=
 =?us-ascii?Q?elnwaLHLw3GeJNALc7lL+89N1GT25UIoQcZcok0aKklx1/ooYfhaIEY7CgZ+?=
 =?us-ascii?Q?WvjfW68xggT6B19tpd5P/2tQrt3vK8cFbCQ1zRoJ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a77f142-abbf-42f4-7cec-08ddea1f4af9
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 12:50:28.1839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAzjXeMrtNh4XeQdnjxcfSDB7Xs8Bbu41XZSoaYNgW1Xl4zibPI/XICNWVjNRKCV58aXKqjYL0nYYAj8h/mIOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPFD39B554E0

Change the 'ret' variable in iscsit_tmr_task_reassign() from u64 to int,
as it needs to store either negative value or zero returned by
iscsit_find_cmd_for_recovery().

Storing the negative error codes in unsigned type, or performing equality
comparisons (e.g., ret == -2), doesn't cause an issue at runtime [1] but
can be confusing.  Additionally, assigning negative error codes to unsigned
type may trigger a GCC warning when the -Wsign-conversion flag is enabled.

No effect on runtime.

Link: https://lore.kernel.org/all/x3wogjf6vgpkisdhg3abzrx7v7zktmdnfmqeih5kosszmagqfs@oh3qxrgzkikf/ #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/target/iscsi/iscsi_target_tmr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index f60b156ede12..620de3910599 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -112,7 +112,8 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
 	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
-	u64 ret, ref_lun;
+	u64 ref_lun;
+	int ret;
 
 	pr_debug("Got TASK_REASSIGN TMR ITT: 0x%08x,"
 		" RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",
-- 
2.34.1

