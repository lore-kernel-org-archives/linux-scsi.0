Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013064.outbound.protection.outlook.com [40.107.44.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CD724466D;
	Tue, 26 Aug 2025 09:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756200780; cv=fail; b=WSqzA2441HmbPoW7rsEKLqZR1ePC6vbLhQMKDkTyk5nLYnyBCoo6GuQ5y2bjmEJ/Qeq/LW81xJjyu+bNMfbuWQ9fj1xqD63WHhDEcWCEzRzohQK0InjPMn7k9mhdmrHQWyGDkbwSJHxuYtlpVnU+XOGGpN1IR16xwuUIqWETlpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756200780; c=relaxed/simple;
	bh=+CUsyys7lrdgFz53+h07A/4PjFowva/yDGmpC7RsvN4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=T4U6hPadKeiEMU54qfpAGH3xv/K4dEcN3cEiqdWNGIetOkCmtYX+bcqkbcTFK0QHJWSYbZLLZy8/aTE+YBlptXAmj2Prhe9bAdPLlUTkxDZ+4mwjiHNhKyp0aHWmP4brVYGaxWR375bcc00QSs7xGhAry7ReztCxWtvo2AcXN/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Db20VcGi; arc=fail smtp.client-ip=40.107.44.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Db20VcGi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b8n3C2mVe584AG1g7fbSllAjN8KYxKUf2ceO03408MxaVJtH53BZxOK9UiWQJiw+cO0RReFCOXy29zKwRJmA/TEEB0epNnBwMQ8FIhteXqtm3z8mB+PjXuBemwlxDLe3awA2sDeDthetqqr/5eJ9/I/oFTa4liEibVIm3HsU/AFnp9v2YiOXdIoW6/4M+/BVJLYoIfPN1Ao8JmeCtJNd1MRzrlIeVjDaisFy1ActcDLFtQZ4WMEizvaAffz0bF5a/RixTgEIhtJ+PJN5RosBEv/DnpIU9TuezAq3RJ5fEVChZLgeFVrieli2muSd7Dq45oe6OS3Tz1oN5xU2xazQDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsGauJqGhcZNHJ8wRlUpFLM2YejaOKnBSeUpfNDRrLs=;
 b=Miy5ggXmm06Xu1kY6yYisnrAzk5zyRCGJxGVQBciMSMSrjmqVD0yUuMvb+ZkVjUu5brR23DPqHdzuZZUb6SOCyLqmwMN/zVJ2BL9hmk023e5aUTsa2YUrfLNBqPz6hCe8bo+EE1u3CLDNcjm6SL0STv53vM+q9LXyp7NQQw6L0CtdQ72Ik6C3A5dgst+DpAM7bfifY8zMwiPJ+SD3sPNbYXqZiVlrnH7jMZ0LJ2bctVCU2LE1zdvngwrl7fN2SS/JW/p2CRq/CTSzrP4Dfdvz3HRURsLEO7S6p9uQ1mde18mypnU4t3yxCTV4G4Z/Mt6b3RLqqJFSubXseiIQS9uQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsGauJqGhcZNHJ8wRlUpFLM2YejaOKnBSeUpfNDRrLs=;
 b=Db20VcGiW1fL9z4WOFBTUM50nOmcmI5n/kzpVjiQGr3VVDugeZyvHfyp6T+DjdVFkNDv+WXtZuYej46a928+rit8aij1ZQZfDXkWzpin/P/uIiri6wWBSmljGVaKDrWx9PnQuAFVmrIILOnPDYHxJswOQSkgPrUb2R7MchZSoYKDD/EyePI/brIVZ7vElfw7OqxalhTVEGMld0LwBjNCleCdskCdNncEZxseBSEEZoL/PSccGTvBZTzFwPtRMrPNRtaFnyXHfG6K6C+YsweoqOG3tRm3FlGBtzC04G/F58n25KuiFFgmADZot4HSMTB7LwuITstAHkqaqJjHMKt6Pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEZPR06MB5738.apcprd06.prod.outlook.com (2603:1096:101:af::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Tue, 26 Aug 2025 09:32:53 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 09:32:53 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] scsi: pm8001: Use int instead of u32 to store error codes
Date: Tue, 26 Aug 2025 17:32:42 +0800
Message-Id: <20250826093242.230344-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0079.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::17) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEZPR06MB5738:EE_
X-MS-Office365-Filtering-Correlation-Id: bf29b1e3-5c6d-4892-233b-08dde4838810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?82E4d7djrGOnU/0/aD/A0OX06pEH03467UOvXmBRQ+yYG17sADWG1SCKSxq2?=
 =?us-ascii?Q?/mNvAddzRfynZx3zVdsm3uJ0aich3KxWiFH+WSPJXssXcZhpBOzrSi9eIHOx?=
 =?us-ascii?Q?RljOvKthA6gueGHYrNDhi5vt54bMPAWsqfkt7yqE3OCo1YUGwQri9bljOQ93?=
 =?us-ascii?Q?ATRAcGE6MNYJ2tZ/ED0nWDnE5vut17LUp82yGjRDfSt3sKl9w9lX64g3Kv3M?=
 =?us-ascii?Q?a5px0eMfVDWGQfVqnrHcEWJjy430D6jVDctZOqeYJGPvhPnyA/JzI5BWtsZP?=
 =?us-ascii?Q?E8rKqLsVVpP4nOcOcqUccU0tnfa/7CqKHjv0ehFu9b/120F6Xo6ySYOKKCk8?=
 =?us-ascii?Q?smimfLmH6OGaALoJ8Ok2XNg/3y4HI3ywrknDuF4IXZEUAAZ2XOrYCH8oTwq+?=
 =?us-ascii?Q?Cnnlk03B5rLwQ6ntuD2987f6kxzjrtU16CHeAApVlwKCBOXLgmJ6aJCB/mD3?=
 =?us-ascii?Q?FdV+yBEx2AIgRqrxekUqoqpxuAJDMEFD8SrGHOHjFn+uHtM+h0sJnWQYwD92?=
 =?us-ascii?Q?6WsSWRg+Sh/jkGk4kPGl9w8X+PUVpzDahj/yrrjCzU+IdznOM7Dq4AMqGD9A?=
 =?us-ascii?Q?STmrDlZj8NdOEb9MdzWsxw9kkVRAfhjhf2mtDAN/1l/x1mEHPa1w9tcJ/hv7?=
 =?us-ascii?Q?i6WJXHgagWpTqDtI7ykI/APScvTgNx555e4nErx79JKXvVZcuXZOdi+GAr3U?=
 =?us-ascii?Q?IBHZQkJ8obq1fSgJIqTIicTNP1D9CjF1ztfln2PORpiv+oo8R3St18urc30d?=
 =?us-ascii?Q?iYxOOA1yOQSlNwuTWiBuCS6m4TAesCVZewUtHqNu4oDKuIpoQD/5AmFjfaBh?=
 =?us-ascii?Q?DsAvnKTMHKHVonOD8oerJrSkRQFsUTXfXXVJGadFZVLUKRJF8Vc3U+CvXvGo?=
 =?us-ascii?Q?eEPs9/vjPIj4XTeaB+bdJ/I7Zptx4QSuV9kZqy/PvNABLPO1KqQi1BrlMcgR?=
 =?us-ascii?Q?+J73PE9I3Fd76Z3/MNmgKHxM6MojjctnklW2/GWRpHOmPc8ThSwmK2ifr8LY?=
 =?us-ascii?Q?6QhjloBuNtf9Xat7b7yh18/2zCmFBJw0KV33UYvUylPaWNs45nnL836G89ys?=
 =?us-ascii?Q?VvfBLGkImnXZ7WVmoPuDDO9uZ0XX2GnyHBwIiAPeu5tvFO9idWnKq7Hs65Ef?=
 =?us-ascii?Q?vrirlrOTjiubWrDtjFJS930vhbwig5wn9Ux02N3/9+yi5+EYYNcs03j63GCh?=
 =?us-ascii?Q?0KGV2nryDLqXC5lUQFPfR5f725ZbK+EGKW5De5241wAnX0cMJGdd2a5idSYw?=
 =?us-ascii?Q?KxmUEJN2khDT2AEAOlyqZdcVmRFJyidQbHVplhbyhvOpx0O4/yst1Ckbcr1+?=
 =?us-ascii?Q?tDEY+M8t6rp2ZvCzsn4/PkK2GX8cHuEYqpdI4JSLYGycQuGCce9mVf2yq90v?=
 =?us-ascii?Q?MwQxKpO9G7/2fYckTPBTDSWoywxVkkEcCoc80f/cL9+EaYOlrP7rKYLx4oRv?=
 =?us-ascii?Q?XUoThkEphOSaNo63O5rj7DX4btGbStambWlJ5ba62SEJw4ywLzdz+A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vIP/cBpWEtN+HtRqIJmD4FXKURsGW7XYU/ls9c9NVQMdK5XWuYI1sG9VQY1C?=
 =?us-ascii?Q?2kZEOR2MMQCQbgwnEtk9fX0Ig1CC3Vm15CVT0nWvEK8IniXyDH2RZyU7kwbJ?=
 =?us-ascii?Q?3Tw5WFkSlGRdgOcTPUol3FPVnArJtETm/h1SUt65qCY1ty0Y9UFtUZ+GA/WM?=
 =?us-ascii?Q?oxVNptOUI0teCEzryyrE4GHydDVRoutOdW0kQVjia8RRXqmjDoX8s4m1wkoD?=
 =?us-ascii?Q?AjMwhlILDTumLVncGmT+lgp1lc3kjMmcq/oX46TvoTrjJTDgTK+qTC1Sb11N?=
 =?us-ascii?Q?U3K2WWKoFvOlXMsk4dU1624a3Q3FnDRZrACveBt7fihkzl1qx0H9lm9kymYC?=
 =?us-ascii?Q?f3DeNPrrm4CFApaGgMOLlaxwJzsfwMub2wLSFu5+MKiCckkJjkTzoZv8WrZU?=
 =?us-ascii?Q?ZJ5+So1hbtzJgNcimyKNzI6glp3TwI4oxRzYC6t4W8khTB1fyTtL6AriUEOQ?=
 =?us-ascii?Q?XQZtJQ+VtAzzkYFkl2CvHhHBlIbkZ21TV8A5s4qn4Egarz5hpZsglIU94QOO?=
 =?us-ascii?Q?ZP4Mqs5Fuahpsa+156H5lfA+RvXNaLcs7IUxPOvVf+Tn0yX6xaUj312L+rqU?=
 =?us-ascii?Q?LVWLrQOHPDG6BJxuyhGoI3LgxIDc3AcZa7OP4BahuwgiACA3Ak0Lj5c8OyzQ?=
 =?us-ascii?Q?0rghHxSbPW21fswij6BqbF2Q8gmdB0BMPYSYFKZrKOXoWyz/D3lCgVvkJhnR?=
 =?us-ascii?Q?eEKY2fBtL0pUHijUcVqgSnQ9Fe89ya80CXE0TjooyFpGpq+vCSg85hlH6yTW?=
 =?us-ascii?Q?d6KzwXTaxrjYIO29s4kAa/pWcjbGW3H9otMmrUUkPpy2inT/HQYn5hvuE30U?=
 =?us-ascii?Q?f9CWwE4t7zyJ6jTya0vKAYNeoXS9tPEoBcYQTS7oWdCuJRMV2f+MzVtaL9yg?=
 =?us-ascii?Q?J27QBgyMSyHEfsTxL1ZMQtmdRKy7W6oxW2D0iMq7KPPHjF4HKWPtMC9Ds6Lm?=
 =?us-ascii?Q?c8c6uUyjYQBZhFnYfAZTQoPMY7CeCWV8PGr/yg/EdKCyyWt64zjeKoUPpeVP?=
 =?us-ascii?Q?TfjlvuTaOc3oxo0kZSRzDzoLMMMu74wfpXKfmeVKvKaTa/kLoSqbFYWDQuDR?=
 =?us-ascii?Q?gWx7NxFT8MdKvWG2FUo1iVIDXi8UzPCIeQm05K+bs3w6uMl3bipE1y2571mz?=
 =?us-ascii?Q?aRLnKaJCxwY5Bn7AzpJebGgI9lTWIz5HudaFQRAoJ1NJPf90eyTgv8IADvIn?=
 =?us-ascii?Q?xxibT5LbFX8JDghEXb4ONkSiXdHPmfxD5WB78Bz1Q/kGOgwRGrkaQdQgiftj?=
 =?us-ascii?Q?sfxJmgUz1qGkdEbolSZb+GZEc8yEqNQL+J1079NaSYNsfNevYsclUIPRaBWO?=
 =?us-ascii?Q?88nkU5mzOHKhePecffKKHuz9pRDz/jRK/3++3i8OyTxmR1wo3ZFSl0S+g0hR?=
 =?us-ascii?Q?Jl9U2un1C80BeqiF+89zl+THB7dcOtRklSkN/cB7Ghtuz192odklclPSof0f?=
 =?us-ascii?Q?WQy21uzFQQeFQ7jL4Y+ObOepdawkX9RwV75w4TE6q7sNlr2kqlE23cHSM9fx?=
 =?us-ascii?Q?0gtqeQ3pzRWjJslvJkkr32XGzvWLM6j6FIkzPs5kBbVKNI9ueRHEvlhLWgMT?=
 =?us-ascii?Q?UIbrlj5Kz+0dLYIDkHsK7HlRx1BvRTOjHGKPyjjC?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf29b1e3-5c6d-4892-233b-08dde4838810
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 09:32:53.3197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: venEcJ82/EysL2O7QKQIVkoZPTvgtSLFO+8Bfw3X6Q6ibDC4yC9D9QMyKayh2VhP5bWgu4kNqnFDUkLQqAq2OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5738

Use int instead of u32 for 'ret' variable to store negative error codes
returned by PM8001_CHIP_DISP->set_nvmd_req().

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 7618f9cc9986..6e76b1cae220 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -680,7 +680,7 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
 	struct pm8001_ioctl_payload	*payload;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
-	u32		ret;
+	int		ret;
 	u32		length = 1024 * 5 + sizeof(*payload) - 1;
 
 	if (pm8001_ha->fw_image->size > 4096) {
-- 
2.34.1

