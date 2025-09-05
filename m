Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012061.outbound.protection.outlook.com [40.107.75.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423F72F39D0;
	Fri,  5 Sep 2025 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058904; cv=fail; b=FsFRdTV4KHFNjYifJdVJBL/ydcSPzNXK8r0WutLjsIldI/J7akuWPz7hws4c4PXaj6rfz8p+VxFnx96WPFZN5JUI7K05BoUgpjC8Irei8JinU/HQtYkZBgzlmiECImPgOCsEEuQPqVfhPyieph/JDhcpF7d9bMxyf4C82UyAlN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058904; c=relaxed/simple;
	bh=cB4rwy6ZwWn4cguLH6/mucctLxu82yHn0ZAENJwEWRo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=qgjZt+neKz9vp3CpbQ/gzrtQxTjViapIlySW+gKaFFN/Nosmz39DIUtl4ueV4FSecQG7YTM8rvxfESVqc6NACDzLVoAoPj7Z7VTpYrNDB7cJrOh69PmDrJT4jfQSU7HLDvGr98GdWLAzzXXwsO/L+0Prat9F274g1+DkokxJWd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=UnMQUgXM; arc=fail smtp.client-ip=40.107.75.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="UnMQUgXM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lPkV1lERlK51ZX9RvTm2/0Gy4Ypy4dlMfCk6IGlLNc9Pbs0rNK+DnyZD1wf3vrTlq7o9AkFjtOP0mBWBrFGrBmc2dLnBmcUDMu27jlvtka03HmoY1fTwmxgRYLYUsyAn8EltfNWMfXxO0SIxvDR+X20fVyMLocQOKspmnGPvxZXRLlMIECXQuDo2rSm8jbB3DJVI9uPpVNvo4n+N5/4u6vK+Iz+SHLxcwlM/6nwQSQvsDtPeZ/XYQiuhsHKxbUCz7ORctsyim6SZvzxvEsAJW/xkbhBgNy7uSUztSwqyHTcQUDoJJ9Xo9QqmPqNntJuD1qjsze7/XE18Y7rtNp6d4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqr14afdrFYj3dsLgWdMVK+bol22+3THlrCp0VpjeFk=;
 b=gxJ5V4KyMkUIIrv3+riW39eV2KJJV4uX9a3fobRjcgAfJN9e8pNCQwGzNNj/ThiTqyktG038PTH7YON0hsRskyjS0ahmkT7zlls9z+1occHtouzBBQN1SkeXBnT/LTAgAem4WaWGnSCwUBTS0GzlrGzc8hAPiupu/wG+8PEiCA2Ng/rZ5QeaGXf+w7RzcjYd7KMU7tC7JeE1hDy9OGKGrVeQYE5VYZ2yi0DUPpHPpek8FPQDHaRVRiDFJzFRExsQwz11/bBlcGhCeRY16eO5yXf7Yj825DZIbKTzw3XIvZpVYG/ZRT82iqKf/DMLNvhIRtDeb7NcxmHv9fjNARGQrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqr14afdrFYj3dsLgWdMVK+bol22+3THlrCp0VpjeFk=;
 b=UnMQUgXMC/ug0/pAaVmyyVu1jmPh3o0Scmtcg9LX+k1Z7USz6EIoOvQLVA1KNRh0a7mWCgEpUXYaYzDaShhdulpKcOn/y1y8Hnp4bUENVGrBeqDG4epUlPAZ6JLVmPeoIMK7jsEO2PY57sreBV/XswltcISSaaxBKZzQSJUSI73E9BcUnD/lr/Hqwg9hFttNGa/zCwXaSRBwQIVwloWtszMTj3jJsQ640Gl/klV2jdSgg0oKXsIJxcc0PspQI+ZuC6ZVuMSCmHRIHx83W+Ee5DXkB/5cg1MbAPmKQwJErvMoa32abHE9dA/kJO6/UmlAJND1wUtIuKnZfBP6TRzjZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEYPR06MB6012.apcprd06.prod.outlook.com (2603:1096:101:de::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.18; Fri, 5 Sep 2025 07:54:59 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 07:54:59 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER,blamed_fixes:1/1=100%),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Quinn Tran <qutran@marvell.com>,
	himanshu.madhani@oracle.com,
	Manish Rangankar <mrangankar@marvell.com>,
	linux-scsi@vger.kernel.org (open list:QLOGIC QLA2XXX FC-SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 0/3] scsi: qla2xxx: Fix incorrect sign of error code
Date: Fri,  5 Sep 2025 15:54:42 +0800
Message-Id: <20250905075446.381139-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0244.apcprd06.prod.outlook.com
 (2603:1096:4:ac::28) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEYPR06MB6012:EE_
X-MS-Office365-Filtering-Correlation-Id: 44bc1814-6b07-4c0b-711e-08ddec5182e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HaQ+1sVYT1dDLdyYwjQ+D2fYygP2b4ibpJAkeVOe3NpMDToWX6UMkvXyNydS?=
 =?us-ascii?Q?QkObhC3vAhcSHO6hafNQZ5xzwYKyYjBQ0s32BBOkwbMJvM0CqEvrnlEVZLBL?=
 =?us-ascii?Q?hEs+fhw7NUSn8pBp+/v+w9TILulbZnUwPMxdB6+MkuRLPSISX5rZQ59cEbU2?=
 =?us-ascii?Q?Z7geYfjl+L1T4ufZ4HwSV20hHq4dq/h8j9tKdOSNySXyu6LVqtzm8qSEUX0j?=
 =?us-ascii?Q?COvBjzCuWyXqDwMepLD+ECZv0dQNIABEi6X03nucIn20YYtzJSmnoXQWitGO?=
 =?us-ascii?Q?h/DtMECxqdBsUb1Vqw4S771lQeSiJIBxdv3D0IAiDGwxTPmxnEis7l/L2v/H?=
 =?us-ascii?Q?joyAHhAHkrwZa2TvzaiqEX9UDhDKioHYdIeRQNT8xusiw4DVqO8oYy1LxPQV?=
 =?us-ascii?Q?eooCFGfErkDDM95xR9MFTnupajDzB2xqorLe7qVuenxVEhywBiqUQ6dWEgpl?=
 =?us-ascii?Q?ehgcvYPXHgV8CjddTX/i2evqsl3yOyrOOSm3subX8bYeqegXYJR9sHNm/cAa?=
 =?us-ascii?Q?iOWquSnYLGsqhwFXAcX8lSOLGv/TqnnYTHVP4X4CwBj4aZ0ZCtggnUxojHAc?=
 =?us-ascii?Q?6Uu+nLjZN/zgO3wP2ipVN1FVyeT+0nk4q22N8RkzyqwRcf7BWI/P/2QHTfeV?=
 =?us-ascii?Q?twXRDZ+ZIJLIkm9liIzMi6soQQVwct8QgsrGkoUPve6fu7WzejVjs9vZhBZB?=
 =?us-ascii?Q?guAGaROPJyyN0MIqC4U33HQMHPNGKnZFQ9GlhGiChRYSINaLSfbxR7RhxFqG?=
 =?us-ascii?Q?VOaNFPvrMoDpjZlMusgxl9djjd/2geR1wPJKkHQUdhbYOec0CvlDmxw7doUF?=
 =?us-ascii?Q?3vdxBc7/dj/yiV4+K0VyyyxQUbqF27VTe3C0PeNti3FKSB55pviTWxa8gFUk?=
 =?us-ascii?Q?bhKybxIH7p2NHJ5323OlSAuDSXvBiRCxXhtViTRChZZvrI+aU+J4PE60nRbx?=
 =?us-ascii?Q?TePplNBH9Nefrb/uy1gaI4R/G81lYebIIEkYw8PUIZiBalx9Cp34aH4uor3Z?=
 =?us-ascii?Q?rbfPAGAlkscZdvzibdtqXFQ7hbR1trb7YTHJmVSx1xBZzTult+WSvcii5ksZ?=
 =?us-ascii?Q?t+3YvVPCfK+z7uwIw1ooGK5X9BC6r65+sqtGyqTbHMBNRxrR880NJCISe4B+?=
 =?us-ascii?Q?I5C5/0CxstutDBKLLgAkXjohImtio93jdHQcqmNqZ7uuiKIdV1rlXg1y/tin?=
 =?us-ascii?Q?kW5ahy8vUs3EhVj2mYJSEboZnZILtxWo+TlVgQDN5JsH/4grzOWSunScvBFx?=
 =?us-ascii?Q?SeMNOajoKbon4lltahHw3OmFLO2u+32iE2+QSTWhPgEpbfblW75ZL0uiqKcc?=
 =?us-ascii?Q?97gsGlekoJXNcH0BpXHg821s1XitvrTVUUuZFeN0WBit4TW22MJQ3buiBebU?=
 =?us-ascii?Q?wGhohij851gTZYM1O7uYcTWY1M1VlgAdV7VIJy5P5COIaCZ0mGZLOnpNrt7O?=
 =?us-ascii?Q?NsTcQVBglMKWQtwwnOPiX093AKUDseQ1C/lk1ZWNE4oKfHDTq4DyBvBwAv+0?=
 =?us-ascii?Q?oHxhyFOXNnlFrh4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9ezIjj7gxiSPpA4yjoUcTSQPIOe3bKv/6/unIhyVPXltQ81Kp7Hr/J/XKjUk?=
 =?us-ascii?Q?pkd6LdkQn3wkHdNuqharJIgTdRTOiMRQctdxdlv4CP7xzH4FgCMwC4W3Z+qO?=
 =?us-ascii?Q?Y2zpPCdBfO2oAnhvFoU9dS+jnCiQhN04oSV+1o2nyt5dlCVJE78vzb4FibER?=
 =?us-ascii?Q?O51urU6pT5vIMOIYLrzXgu4vsuQ/NNBVjQW8nPeBKnPN1PtlVVrNDttSlN3m?=
 =?us-ascii?Q?Uk3FBYJMyreU1nX6wOvNQEvh9MSg9nwoqoQSDnAbLFSTLZYb92vVcRos7bq2?=
 =?us-ascii?Q?cCSXmzSbscgg3PP9lUVWkVi3tWg4xPgoSPBOWRNK1wd5Lqeny9QEN0UKfeKh?=
 =?us-ascii?Q?Ikq7EEzUhvdBlPqvQKXlVO84FzhZl6QULU2cLmnByyBQU3TJduM5J0PiyiYB?=
 =?us-ascii?Q?0+FixVkje2dgNeFKQm8rZ/DHajsFKfIiZZQD7fdHl8wPftigOKXkc8tp10no?=
 =?us-ascii?Q?5OXv6Pm0PM/VADcfpTv8t4G6zIX/CfsGZmTt1KZ2X3lFxCMq4Hhd0fXuFUgZ?=
 =?us-ascii?Q?k+LjKXiXqQkdfxi3f5Cezg+0swohE+NQxBR+kBg9AtFTGsLEwWnbQ+Aic09M?=
 =?us-ascii?Q?I4zzXP1A2ceZW7gHvNRH2QG+k3vb1opb5HIO6Aa7o49QS195ojenS6wYsQMy?=
 =?us-ascii?Q?lYQ5ryfP23AJGd4SH6yYF9iTSMR4vJzUUdwVMSKPuNf3rZ9HBK/vQfvFZ15W?=
 =?us-ascii?Q?f4Ya17/bHE5RnEcsW5oglf2DCcAb7cW82EBdY4aa0J4Zl3aoCeg4mxmu9iVT?=
 =?us-ascii?Q?97hFrQvCjdzxZft5lZm48ePnxnW74vOmjxJQ3cSwVNYtRQKMXJ/LhLQugsY4?=
 =?us-ascii?Q?EMC/7ENPmFViIUQ7DXhReirF1C56ZMbLKuvy4CdFA1C3JlpAPNJOCYYhMHn1?=
 =?us-ascii?Q?KXOvcjsiIorA0+yC6WjKjWlmPSLs1gR0IoWY2NnKIhZvyrxIiobt+bWjuXJp?=
 =?us-ascii?Q?1nasB5brWFjsB4VQl2AgXlxadxIm6tdYG4jTp0f1eguMtpYAEZyej2JIjhK4?=
 =?us-ascii?Q?q49hABxUjDBOX+iOXEUgR542Z8dY3EQZesr82zwYik7bIrmgY0kGwsX4ypme?=
 =?us-ascii?Q?kmNsiFytd+iHP61KFaXLhkWtkeTLBh+OueOX2D+Ves5Pwy2ZdSQaHRvzHSUg?=
 =?us-ascii?Q?c23zivaH6Q+PjoMjd9tk4LQA3DgLemVEwcQpCh1W2WNRZOPgxl/yViottZBb?=
 =?us-ascii?Q?GW3bfiIWlWYldnG6XGxXldk3eWP8Ax903ZAQoi+5cUKEqZD0v76tzQdL/HCp?=
 =?us-ascii?Q?xzp+Oi6Q8/cTFAXyfPMyyyKsFDNarQcdoSEQhTZljj+3yxdnxe/uDzMBc3f9?=
 =?us-ascii?Q?Jbcthyv40D1mGwOh8MqZLEo2o03UHpnBNxx6g0kA7IRI2vZF2vSCZ5L8iYHS?=
 =?us-ascii?Q?FrUwOL5DyCOwxr6nqRLdDJW+EjTdx+uE3zjNZIF1JLQvG4qZM3zc9bbG+Nw1?=
 =?us-ascii?Q?QingFKopy3OcvsErEhPWZ1ZffpqGKiL4JvGjFb1pH9lQCwP6TYDELlxI76Gq?=
 =?us-ascii?Q?dKhm5ZrsV1TKcAp000gXLYac22bpCUn0XthaWEeLWFn7ThFTR8ZUOcf0tLEv?=
 =?us-ascii?Q?clX6VfCHXXPJAJyVWESLgmzsEjIgOluwirRXvR0H?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44bc1814-6b07-4c0b-711e-08ddec5182e2
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 07:54:59.1260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWA5l/p0AeBlMEmSvUlX9aNs6vnM+wanFi11ZIE7ZCW1IBm73oNmdQ/NboBVqisPmLbq/kXpEpZWwP8KZCTLmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6012

qla2x00_start_sp() returns only negative error codes or QLA_SUCCESS.
Therefore, comparing its return value with positive error codes 
(e.g., if (_rval == EAGAIN)) causes logical errors.

Qianfeng Rong (3):
  scsi: qla2xxx: edif: Fix incorrect sign of error code
  scsi: qla2xxx: Fix incorrect sign of error code in
    START_SP_W_RETRIES()
  scsi: qla2xxx: Fix incorrect sign of error code in
    qla_nvme_xmt_ls_rsp()

 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.34.1

