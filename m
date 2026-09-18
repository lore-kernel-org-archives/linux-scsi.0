Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013008.outbound.protection.outlook.com [52.101.72.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5743B38BE;
	Fri, 18 Sep 2026 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741257; cv=fail; b=hjC9s4kvnLCtyWMMq7GCDQKEMtvEpuKIwLz+Oh8pyCYwBkmcoEja5wm/nhg7bJrV7Td6nBNJNBmHYAugssf7zPhq0OECWdbXeBCUPtDYMaChuSbwUR6zWC4WcgRk8P/eEkxdoly5o4sCkPPRToXD1W6QRtaZyTltRjcmEtcTC9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741257; c=relaxed/simple;
	bh=e8F4dD+bry6esshqxy0i3Yvazhw9mGAaKrUHAVuNUHM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QJW/DalCZDlar0xEJYyaJTjEondBI5KyjCdqnY/ZhfI+2K6OxpGiOqTx4ySDPkIxr2VtpwD/iE8J6pI/0mlaCOrs2sTuZMrpJ9ZkWYJ7J2S8n+8PNm3k9ayB+nOY4djyog0ccdDUodehxYRC6PjZ+pbdgOqYd6c8ft5n5YzF9Xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=udgTmkEY; arc=fail smtp.client-ip=52.101.72.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="udgTmkEY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fHgip9S4I4BwW9UKRh+MiT+Li0Kr8xseTSqN4cmRuADXQc8JF/NRF3rqL+RywdDZQdQKcsmYSCI7KuI3lxBmr+NkQUaEwoNsRgr3uRhq3ItIQs40bQhEwEzdiwOOEEDRg+4ARDpvKAWbb7xKNXk25TuApj8MIssN5nTHOvzFkNQQeH6i6AcGgRSFi4lT69bfpMlldT/pd9X5zH1KvGVhdDrNuQU42yJ/w/Jf2H4TkwKMkETM51F0gldsVneEPU4YYMIQ7TZT7qGI8YjBtgir6fW+gUzwn0pMU1BL5a9Kz47JF+dtmuf+xOOfjaQtFiXz8KVdL7KwOe2GBLQUSUilzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDexf5BnAVwxk+WSM++omqGaM3obIrQJDXYHTfIAwdo=;
 b=qSTN3h1TNqr1GnUsDFCuZvVAYAFMLCJzafPfodCam3BLBl4UhDpVaGcEOXAWvDsmfqz+YiyH+NTNCLQSCcneylnziW446bpdKvEypdLjfYGNTmxDDf4/CyDsJ5TVCTYMPmZJU7AbfcD6t52vXFbYg6a3+fWfA7Ih9FUQ8I+25vuEy5A1m4wl96Llffp13zduhOh6Y+harc7AOl90jYKlBmUOHFq2/aDV2k2FaKqD5XMWBvQNx8frQkHHp28jTQfOzijAYVjYZ7hshtlNHE3mSXlaVQjS8TGQhZAZpjlVZl72KrXxKoVG7SV2H7oMb3MAKrtl0y/Cwe3Wrgyxg6fpxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDexf5BnAVwxk+WSM++omqGaM3obIrQJDXYHTfIAwdo=;
 b=udgTmkEY6bBz8tP8gKCkmMV5wEVet7byGfhEGhF77q1bVDlpnmdaoZnfDf8fRIpvaCvYjBJrHxfc1AjkYW6e5GFOOzgUg9BxjIH0ST+aMwDxYf/59wfjJY50FUOH8/a6ArWNQiN0FN3q4BG1ZRyEO+FfnqWFBU8ks6gfLk7GllKrmjwr+yYE3xWTd7APuij8S3MrXUwCdcfeaz9Utxzm4raHd9SNQ7aCFeovFpQnSNH2MzK9ga1xPlrqoKL1nRRfvV1/7xUt6JRTceoAZ9xX6Ji7QnpMhmUjQseKq/mJpbG1zUBZCL5AhmVRf3ode5U1ICQ/lI76MTSuiOBXHbRPwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by ZR6PR04MB296659.eurprd04.prod.outlook.com (2603:10a6:910:e1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 14:20:53 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 14:20:52 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Bradley Grove <linuxdrivers@attotech.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Peng Fan <peng.fan@nxp.com>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: use assign_bit() where applicable
Date: Fri, 18 Sep 2026 22:18:17 +0800
Message-ID: <20260918141824.3023096-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0186.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::14) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|ZR6PR04MB296659:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8281d0-b63d-4447-ff7a-08df15900bc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|19092799006|1800799024|56012099006|3023799007|10067099003|11063799006|921020|18002099003;
X-Microsoft-Antispam-Message-Info:
	BLb2t/VubBbsyPXK5sInMS5emE+o7vzKXYrYOiVf3ugeNswaji1rKzmjNlMs/dCyHWVnbs36Oe1BjBOwdzOo+vASQTValbPdSn6FLMWSs92uGicxUlYNWPIra/vfQdgkWo2uqO6WmBiMfNwp+r+CGnqV6T0Rpnx0SDjazxPGlBxKZtghZIugGhyIieqUc08EfiKLXNHryELuug3OJ8uPQ5njXDZwW8nM8vsJ4jSrfTEKUVjxYQ2vUV3qzNUWpjC8ArhItjyZxZR62TfMCwH5DuttbzgmdeFgh5H1m8HEEX2iOM+nx7f9V71jVROMqbhrGsmTPhzdHbiBiydH5QnPRIjeiEDbPfi99DTZvzN7t8dZzQhjtBrw2+VxzZU02PxE6/g/X9LEbtP0oKrNv44oKnS5LrSbPMrCAcI8Vmkr0WWJljr9CLEQ/ho27Hv4uxgBzjTE541eVwrRYcqhrYCLfEAubcQMRFYazb/TrA7Mem+BFArI3l4ok4nTDNEOXO4epxYubbMv8shQqsHuF+HLODr23A1oaT2IJCW+S+CVX80jctGhEbmzP1OEpKjQoWwC5SX0mvCRJv/blq2w41LjKOy1pZ8azUHcBs+ZEiC/dhYJAgJtMy7UZ1ns9mnhByykWlVBYhRKUbJnHK13BBfEZ5s/bYfKMUbKlTUSu+vPQYtm5tJBqqX3+wvVhUlqfmSe2k+mCM+rGmICK7Ix/3bBhg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(19092799006)(1800799024)(56012099006)(3023799007)(10067099003)(11063799006)(921020)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?At15qw8+y+Buy9/Qty5UNX8WwbxaeA4IZFt5UQSkizFnNp+u6h4q5jHjGpEf?=
 =?us-ascii?Q?tiaHxt5W/Kmp/Vzf3tYyL4HtWzJKpwcpDLBgXpoqlIOasXSAdSNcvq40obDz?=
 =?us-ascii?Q?HnXJHskPZSIRPdPQxD+W0wYrjGAPgQlwU2gy0f6v0kj0Ew1YKrA6nCiIxMOX?=
 =?us-ascii?Q?cQOWBmIwd+ZRXnYKKeyltNHGfl6dX3RSzvwsZIl9CjFDdhMgHYN/mmxQVn1O?=
 =?us-ascii?Q?+YEUvQPDcTPwNzP6q+7t5+rxZlZ+WN1hmxs9fDyxaebWLiJys8KKei0W1f/s?=
 =?us-ascii?Q?bx0V9zFM9rN4yfWARVB/6cXf9505Ddnbyukztn8imC/udUpsWFOeeyqv1hze?=
 =?us-ascii?Q?HWoLfvl3/u9RQN3+4TQhs/CAeqNXw/tAfARTqa69bcfQDtX6aunJal7XjDw1?=
 =?us-ascii?Q?nMx2lZC2TA8M9FP0pct3qNncP9UM22s+wM5sIF/m+mavs4/hP2eKDDGW99fa?=
 =?us-ascii?Q?BLmLumyhWEXP02Fr+XJyMdClR48ZywG0u/2mAk7060nx+rrPHEmdILh6L+mj?=
 =?us-ascii?Q?GyqVay44S5vYJU9M/RFZDndLk3CfbzHvAIe3CsltZ1hju87borouj9f4INze?=
 =?us-ascii?Q?pGv0ahF0eVO5NcZm92lYeDpJcT7/AglyXRiRoY9lwal1I8Xkt3759miPScdG?=
 =?us-ascii?Q?CY3sxwgBvzfbhWA5+sxD9GjXRbr/78SMuM4DNH4v3bbj4feV/SJ9CNpVnfg+?=
 =?us-ascii?Q?WW3YBsC6ep2fegKfaV+aXNTJWWeaY1aigVQ1xdISCSLl+nFT08RHsAavGMam?=
 =?us-ascii?Q?4elvg0nmwaNN0D4WayHi3AGLHdylbI4NOhq/XPxD8LKWjbEgYaGb7W4Dy6zz?=
 =?us-ascii?Q?RaG0Xf9pP1LbQKRb2Hqj7shdNfPDgrPvQYTgK66Ua34t1kYNLGoyT0fY+HDl?=
 =?us-ascii?Q?tlqs4CaSIXpXaole6CNF+OWUNgfYwLBv1gg1AswI/ofUnEqYWtdq2ONkJmp5?=
 =?us-ascii?Q?k4N9LdLN9BYPi/n19uXYPBdT1kuuCg2/tRSzIv68OYd718nxyaQsfaoM1YMD?=
 =?us-ascii?Q?CunPd1Dzx/rBdHHZuJLY5o65uS7gORAU+NWdJl1tuXzpNbYBxZy7SFFZolXI?=
 =?us-ascii?Q?xW05pJKO+Buu9e5/wihp2nOiy2lysuLC6woGJQPz2A8TPDmvMND36mQbAHCq?=
 =?us-ascii?Q?3c9hzQPCF0PUsgbXqvQvUeQnBGhk+412rvCyq5b427dmM54JZzHTStvluUV5?=
 =?us-ascii?Q?/oHsLBgDDuiLnInAXBRQpkv6bl6OC0HLbTLF9q5jVZ3jGF6H7a33XVOSHNvC?=
 =?us-ascii?Q?sXBVxF4ymudWWWxng5824ILBfh5HY5GXTuiPURMywG/ceGVKQcSPjZi/5lZG?=
 =?us-ascii?Q?Q4Sn/9uyFBUDUles8Gi5BG8FS0FNPEaVZVJr8qTkCRqdTFUGTuPnvXzAzC1Y?=
 =?us-ascii?Q?bo7YiX9aFVGW43/Tzgv15BlqJDcArqDGnwaYSRSSnHLfUPCaOvp2pyGjnec+?=
 =?us-ascii?Q?Krrx4djcp6BbPkP252fzQYr/+szm0MuXh7M4Sy0t9zVGOpYcnBHdLnMCOH/S?=
 =?us-ascii?Q?wPWwD1DcyL/MWGtTe8bUvjAOmobscQXb1IrMFOZD3Zl0rIxA9Hd+QQc0a/EX?=
 =?us-ascii?Q?E/y8Hg8kWxPLiNyCgbtmNnAIhKb2n3rNdXt66vRF9KtZF4YZtvyvZNKKNKy3?=
 =?us-ascii?Q?u3IA0MH1LvGPBTUqaPqj0K6nRTVMlUKLXYe9HGu02j1moSADqqMNmr2uvB1q?=
 =?us-ascii?Q?HVkaweBzT00kcic31ssCYSYiSgh5oz7/guQ0FTON18qLmPegr0fECK5gqUeX?=
 =?us-ascii?Q?12/hj9/txaj2y+UtYQIJ2qQlZAYum2vocCCIK2mw366zXTq62DSX?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8281d0-b63d-4447-ff7a-08df15900bc9
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 14:20:52.8690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 59qUc130dZj5jE3xwU4sNeBPLtARd2Eatagtv0TF1Vh9Rf85AVUcocBnISrUHgp0RR6IngR2BdT7Re4pMew8YvJ+vMWBYTX7M03YSp9diyDhjwO/xk6/PSTwq4EvdoZG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR04MB296659

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit and their
non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
API. Where a bit is toggled based on its own value, use change_bit()
instead.

Done with Coccinelle semantic patch:
    // set_bit -> clear_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        set_bit(bit, addr);
    -else
    -        clear_bit(bit, addr);
    +assign_bit(bit, addr, cond);

    // clear_bit -> set_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        clear_bit(bit, addr);
    -else
    -        set_bit(bit, addr);
    +assign_bit(bit, addr, !cond);

    // __set_bit -> __clear_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __set_bit(bit, addr);
    -else
    -        __clear_bit(bit, addr);
    +__assign_bit(bit, addr, cond);

    // __clear_bit -> __set_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __clear_bit(bit, addr);
    -else
    -        __set_bit(bit, addr);
    +__assign_bit(bit, addr, !cond);

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |  6 ++---
 drivers/scsi/bnx2i/bnx2i_hwi.c     |  6 ++---
 drivers/scsi/esas2r/esas2r_flash.c |  6 ++---
 drivers/scsi/esas2r/esas2r_io.c    |  5 +----
 drivers/scsi/isci/request.c        | 18 +++++----------
 drivers/scsi/lpfc/lpfc_ct.c        |  6 ++---
 drivers/scsi/lpfc/lpfc_els.c       | 36 ++++++++++--------------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  6 ++---
 drivers/scsi/lpfc/lpfc_sli.c       |  7 ++----
 9 files changed, 31 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index c95b084cad69..d9957e8bc04b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -785,10 +785,8 @@ static int bnx2fc_link_ok(struct fc_lport *lport)
  */
 void bnx2fc_get_link_state(struct bnx2fc_hba *hba)
 {
-	if (test_bit(__LINK_STATE_NOCARRIER, &hba->phys_dev->state))
-		set_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
-	else
-		clear_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
+	assign_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state,
+		   test_bit(__LINK_STATE_NOCARRIER, &hba->phys_dev->state));
 }
 
 static int bnx2fc_net_config(struct fc_lport *lport, struct net_device *netdev)
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index d24cc2c795d6..225d0e7a6d1d 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -96,10 +96,8 @@ static void bnx2i_adjust_qp_size(struct bnx2i_hba *hba)
  */
 static void bnx2i_get_link_state(struct bnx2i_hba *hba)
 {
-	if (test_bit(__LINK_STATE_NOCARRIER, &hba->netdev->state))
-		set_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
-	else
-		clear_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
+	assign_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state,
+		   test_bit(__LINK_STATE_NOCARRIER, &hba->netdev->state));
 }
 
 
diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index f910e2553fbb..44cf5af9fe90 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -1240,10 +1240,8 @@ static void esas2r_nvram_callback(struct esas2r_adapter *a,
 
 	if (rq->req_stat != RS_PENDING) {
 		/* update the NVRAM state */
-		if (rq->req_stat == RS_SUCCESS)
-			set_bit(AF_NVR_VALID, &a->flags);
-		else
-			clear_bit(AF_NVR_VALID, &a->flags);
+		assign_bit(AF_NVR_VALID, &a->flags,
+			   rq->req_stat == RS_SUCCESS);
 
 		esas2r_enable_heartbeat(a);
 
diff --git a/drivers/scsi/esas2r/esas2r_io.c b/drivers/scsi/esas2r/esas2r_io.c
index a8df916cd57a..75c0876f804e 100644
--- a/drivers/scsi/esas2r/esas2r_io.c
+++ b/drivers/scsi/esas2r/esas2r_io.c
@@ -149,10 +149,7 @@ void esas2r_start_vda_request(struct esas2r_adapter *a,
 	if (a->last_write >= a->list_size) {
 		a->last_write = 0;
 		/* update the toggle bit */
-		if (test_bit(AF_COMM_LIST_TOGGLE, &a->flags))
-			clear_bit(AF_COMM_LIST_TOGGLE, &a->flags);
-		else
-			set_bit(AF_COMM_LIST_TOGGLE, &a->flags);
+		change_bit(AF_COMM_LIST_TOGGLE, &a->flags);
 	}
 
 	element =
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index bb89a2e33eb4..7c3eeb7496ea 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -888,10 +888,8 @@ sci_io_request_terminate(struct isci_request *ireq)
 		sci_change_state(&ireq->sm, SCI_REQ_ABORTING);
 		fallthrough;	/* and handle like ABORTING */
 	case SCI_REQ_ABORTING:
-		if (!isci_remote_device_is_safe_to_abort(ireq->target_device))
-			set_bit(IREQ_PENDING_ABORT, &ireq->flags);
-		else
-			clear_bit(IREQ_PENDING_ABORT, &ireq->flags);
+		assign_bit(IREQ_PENDING_ABORT, &ireq->flags,
+			   !isci_remote_device_is_safe_to_abort(ireq->target_device));
 		/* If the request is only waiting on the remote device
 		 * suspension, return SUCCESS so the caller will wait too.
 		 */
@@ -2696,10 +2694,8 @@ static void isci_request_handle_controller_specific_errors(
 		*response_ptr = SAS_TASK_UNDELIVERED;
 		*status_ptr = SAS_SAM_STAT_TASK_ABORTED;
 
-		if (task->task_proto == SAS_PROTOCOL_SMP)
-			set_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
-		else
-			clear_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
+		assign_bit(IREQ_COMPLETE_IN_TARGET, &request->flags,
+			   task->task_proto == SAS_PROTOCOL_SMP);
 		break;
 	}
 }
@@ -2886,10 +2882,8 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 		else
 			status = SAS_ABORTED_TASK;
 
-		if (SAS_PROTOCOL_SMP == task->task_proto)
-			set_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
-		else
-			clear_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
+		assign_bit(IREQ_COMPLETE_IN_TARGET, &request->flags,
+			   SAS_PROTOCOL_SMP == task->task_proto);
 		break;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 0734ab3be3e3..c90e93f20f34 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -832,10 +832,8 @@ lpfc_ns_rsp_audit_did(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 			if (ndlp->nlp_type != NLP_NVME_INITIATOR ||
 			    ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
 				continue;
-			if (ndlp->nlp_DID == Did)
-				clear_bit(NLP_NVMET_RECOV, &ndlp->nlp_flag);
-			else
-				set_bit(NLP_NVMET_RECOV, &ndlp->nlp_flag);
+			assign_bit(NLP_NVMET_RECOV, &ndlp->nlp_flag,
+				   ndlp->nlp_DID != Did);
 		}
 	}
 }
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6f6394a0047c..d91f8362aafa 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1810,48 +1810,36 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	new_ndlp->nlp_flag = ndlp->nlp_flag;
 
 	/* if new_ndlp had NLP_UNREG_INP set, keep it */
-	if (test_bit(NLP_UNREG_INP, &keep_new_nlp_flag))
-		set_bit(NLP_UNREG_INP, &new_ndlp->nlp_flag);
-	else
-		clear_bit(NLP_UNREG_INP, &new_ndlp->nlp_flag);
+	assign_bit(NLP_UNREG_INP, &new_ndlp->nlp_flag,
+		   test_bit(NLP_UNREG_INP, &keep_new_nlp_flag));
 
 	/* if new_ndlp had NLP_RPI_REGISTERED set, keep it */
-	if (test_bit(NLP_RPI_REGISTERED, &keep_new_nlp_flag))
-		set_bit(NLP_RPI_REGISTERED, &new_ndlp->nlp_flag);
-	else
-		clear_bit(NLP_RPI_REGISTERED, &new_ndlp->nlp_flag);
+	assign_bit(NLP_RPI_REGISTERED, &new_ndlp->nlp_flag,
+		   test_bit(NLP_RPI_REGISTERED, &keep_new_nlp_flag));
 
 	/*
 	 * Retain the DROPPED flag. This will take care of the init
 	 * refcount when affecting the state change
 	 */
-	if (test_bit(NLP_DROPPED, &keep_new_nlp_flag))
-		set_bit(NLP_DROPPED, &new_ndlp->nlp_flag);
-	else
-		clear_bit(NLP_DROPPED, &new_ndlp->nlp_flag);
+	assign_bit(NLP_DROPPED, &new_ndlp->nlp_flag,
+		   test_bit(NLP_DROPPED, &keep_new_nlp_flag));
 
 	ndlp->nlp_flag = keep_new_nlp_flag;
 
 	/* if ndlp had NLP_UNREG_INP set, keep it */
-	if (test_bit(NLP_UNREG_INP, &keep_nlp_flag))
-		set_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
-	else
-		clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
+	assign_bit(NLP_UNREG_INP, &ndlp->nlp_flag,
+		   test_bit(NLP_UNREG_INP, &keep_nlp_flag));
 
 	/* if ndlp had NLP_RPI_REGISTERED set, keep it */
-	if (test_bit(NLP_RPI_REGISTERED, &keep_nlp_flag))
-		set_bit(NLP_RPI_REGISTERED, &ndlp->nlp_flag);
-	else
-		clear_bit(NLP_RPI_REGISTERED, &ndlp->nlp_flag);
+	assign_bit(NLP_RPI_REGISTERED, &ndlp->nlp_flag,
+		   test_bit(NLP_RPI_REGISTERED, &keep_nlp_flag));
 
 	/*
 	 * Retain the DROPPED flag. This will take care of the init
 	 * refcount when affecting the state change
 	 */
-	if (test_bit(NLP_DROPPED, &keep_nlp_flag))
-		set_bit(NLP_DROPPED, &ndlp->nlp_flag);
-	else
-		clear_bit(NLP_DROPPED, &ndlp->nlp_flag);
+	assign_bit(NLP_DROPPED, &ndlp->nlp_flag,
+		   test_bit(NLP_DROPPED, &keep_nlp_flag));
 
 	spin_unlock_irq(&new_ndlp->lock);
 	spin_unlock_irq(&ndlp->lock);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4c673dffa671..1abed5aaddd5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3776,10 +3776,8 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	memcpy(&phba->alpa_map[0], mp->virt, 128);
 
-	if (bf_get(lpfc_mbx_read_top_pb, la))
-		set_bit(FC_BYPASSED_MODE, &vport->fc_flag);
-	else
-		clear_bit(FC_BYPASSED_MODE, &vport->fc_flag);
+	assign_bit(FC_BYPASSED_MODE, &vport->fc_flag,
+		   bf_get(lpfc_mbx_read_top_pb, la));
 
 	if (phba->fc_eventTag <= la->eventTag) {
 		phba->fc_stat.LinkMultiEvent++;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cd285e87c278..e21bc1acd76a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8575,11 +8575,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	if (!test_bit(HBA_FCOE_MODE, &phba->hba_flag))
 		lpfc_get_platform_uuid(phba);
 
-	if (bf_get(lpfc_mbx_rd_rev_cee_ver, &mqe->un.read_rev) ==
-		LPFC_DCBX_CEE_MODE)
-		set_bit(HBA_FIP_SUPPORT, &phba->hba_flag);
-	else
-		clear_bit(HBA_FIP_SUPPORT, &phba->hba_flag);
+	assign_bit(HBA_FIP_SUPPORT, &phba->hba_flag,
+		   bf_get(lpfc_mbx_rd_rev_cee_ver, &mqe->un.read_rev) == LPFC_DCBX_CEE_MODE);
 
 	clear_bit(HBA_IOQ_FLUSH, &phba->hba_flag);
 
-- 
2.51.0

