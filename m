Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.100
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794470197;
	b=cyMH7MaNFRNXNapVyCotBHxbbiOUzVU4HH23A8n8Jud5jaBh8UOAKXW4K2bOzFPNG7ia
	 SO0F3mpPi51V9tvZhQJmNVL9JsQn5WX158UsynJxHP5Kk2HJgI6UTAc9vUcJAecFNAgE6
	 /1iMAY6OIDn85Aar/tYDBW8TcYoOn79kTWN5aWl3/AwazLwgHDJiyeR5U5WRQNap1ERVy
	 2mBDfXkyAnHGRmNzeqplbdyvzdJtizjAhhYlGuC5EPaVw7/6nQ2eW8h/bRrNa9U585Ruo
	 bOzYJyRbqjekRYobgIJSOKbgh3kNf2OuPM5kBnyvmFwHeyYdjg5A9vDgIe8khr2PSEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470197;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=6vDUKpyBzR1KWHb3bWMOUi0dyvPuZLNXwU6MhPz/uPY=;
	b=VL/8LNQHFsw4LMuTuU8c/OTlIEn3PSavFvU+H7PfR819WjGPR7tsGrAL/dw+GGlDSuNj
	 0h3eHIySEY3RNSH8LWpuFpjSe6A5GPh1grTKHvjyyLNU9yFohcaD2o6HC19+Z+qLaaN0s
	 Z7/0orJIxcISfCK1kk9R+c2mZlA9n29o01VRumTbIA/B/U4WYvtMuxEdwatt8qu+Xf+9U
	 8Jq9ZlsqjQTqhcHM5rD9EQaYIGNdTHDSUFk62gKJIjhlTHGl2vudozhS/qDps/aii9wHc
	 MgYQVVPQPQYfiaq8ClT20h5ghVC0rW0o/nimxFtYHsDyRXahTHZvxx7zkgzAmqs7bEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.100
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2100.outbound.protection.partner.outlook.cn [139.219.146.100])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B41606A337;
	Thu, 12 Nov 2026 07:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12B41606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZ8P2CNpa45lsUMErcqEvaCcHi/QSr2mo+9iPM1ARNx2d7DCTWsnksj/t3PsHox9P9++LK1T1HEgbbG9V5LTtOWwxJUjQz7pnbVDScF/JKlzD0ig6QnLaMe0M8Xz1jAyaHlYq+01MN/zfci6+cel/ZMaeScWmOSzN3f26GfNLf7+gSjoSMq01Om2r85NvPipOrhTyyxMvDm6YY4LtHaEeytz4lMFgYn3zkId+NG3yVrjop5yEp2/pkI08C8uecJ3KN+ZKvxOn2Egg3JRIj/tA62pAq/Pg2sxii/XWNx2ikuyPv0WOaBoF2ORNP1KLIddJZvNJ8Sh2aZQ7Xsopk9MiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6vDUKpyBzR1KWHb3bWMOUi0dyvPuZLNXwU6MhPz/uPY=;
 b=jCE3gD4TZmddF5oVC/M4HQUglr1tQY7AOe4+jte3vAiyL8RFxgIQVPY1r/tQ+kCuE8kRHvzCFgoP/z4nP3/uvaD0kyCjDHImAp1k/FRMhQmETXtwlB2yfUDnflI/hjrnkfFPUkn8G6VVBj0xFwAHHxQeArYMTKekqtv7XzqU02rO6Pe9UsBofNP1Azi/nF85Ue6igwElRNqn/6+tw/5OzbDluBbfgMccU4qWa2nQFdd5MtRLJDi+ksR6yBWlHels8Lw6/OP/Lh6K5FNLLGJu4qZBpER5n1iUJPX1c9jOWCgjI8Ov6VvTK0D/YFzxIucm3unVBH6S3EJI27cj8aXl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::7) by ZQ0PR01MB0999.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 07:56:24 +0000
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 ([fe80::d777:e23a:d111:5fa1]) by
 ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn ([fe80::d777:e23a:d111:5fa1%6])
 with mapi id 15.21.0615.009; Thu, 12 Nov 2026 07:56:24 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v4 0/4] Add StarFive JHB100 soc UFS platform driver
Date: Thu, 12 Nov 2026 15:56:12 +0800
Message-Id: <20261112075616.118436-1-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0035.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:2::21) To ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::7)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1111:EE_|ZQ0PR01MB0999:EE_
X-MS-Office365-Filtering-Correlation-Id: 646e969e-4a8c-4e83-0558-08df409272a8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|52116014|366016|1800799024|921020|38350700014|261026140227099003|56012099006|10067099003|261022105027099003|261021121427099003|261021123027099003|261026121527099003|261022075727099003|261028144727099003|261102123227099003|261009223027099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	dnMLH3q+W8PD2C+iD+/DV2q+5ugr2rh8i8QB5+z3WJDRZTEnwrqsiljWq//UE/AWuw2UrojP74Bd+E858YahWFyNPK4EByoqKJv/UFYC4YYmKzya/RDefun8LaK+uggCYLMOrllxHCPAm/8gs5PIsfEy616ZcdVkGAh9OsTejHa4bb8cCHAckwtfRq9FleqOkp/NW2ojlmlgIoU/V+Yf8MCgibM4aKcJzFTfdlS1Ab1fl6qgl+J0GmULuW6i0fdaMdyLYimjpnMC2Su98Y2YI5E9jMGyf7XCHpWJaOAS7p8S+NlWLXmppp+4AAeqANLG8hoWQrpzzpgOn/ST5plxPF/5/wQocnfyr4lepLwhzPteBh58FMluMXriNppCKlxz++K8rcF7BFil9jKWXZYJAxBuwyrS7ld7nzZXJ3WNdduUNds4N6+v05bkVSyvYbVfgMue/YhgXTL7pFUqKoTeg3Ou8NDCXTmH4zeRsQPqI7UNfuTzY0P8n91cn3nKcY3uxnQhOCaBMpVg4oLJBEnQtNw8R/xXi+4wdymCbNqx/YltOrXFDMWpgpXWsAp7PgzDW/BhUUFuRtPrUgRqIF9IZw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(52116014)(366016)(1800799024)(921020)(38350700014)(261026140227099003)(56012099006)(10067099003)(261022105027099003)(261021121427099003)(261021123027099003)(261026121527099003)(261022075727099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zc4D4AAwWJgbQQGCd0ZJnhwi1u/NjrL7b99ro0ySHPBhZ9d3MmfIkYXYnfaO?=
 =?us-ascii?Q?dzWMaNPkQTqqJyv5UI7C/h7SxM93RgQGqckdc8GoUX16a5x68Z8FzVSPpNry?=
 =?us-ascii?Q?B0VfzV1SDAWA2B4mUmNHvD4T2Ci8W/d1pdHlcDNnQlQ+DZsLBC72/jt5kRvD?=
 =?us-ascii?Q?EQKoMxIl6q4lA49WD6VB3EYkTAQgqWgoKulYa26YcGRkITFqMfUjIDngKlas?=
 =?us-ascii?Q?j2aY0QEmMAnUEzRR/+pjnBW4yA+V1wigr3folQjRqGa9S1/0TeTFKtaLwJR2?=
 =?us-ascii?Q?CRovVhWC7GQGXq90jeUyaI/iZIZQ++mEDKCMPmFXUZJcmI5WI0BMp9Mrq4y7?=
 =?us-ascii?Q?rSSG/c8Q94LKGGarffgRaos5SG0DkPwYnXrfJNOdBVqONpX6dm9ljD+g+nKP?=
 =?us-ascii?Q?Dc0LiXaQS6VZBwaLc4W/ani5R8K1DmBDh1na57N58cf85WkrhXiYEaeSKGLB?=
 =?us-ascii?Q?53wLRSm6JfIuJB4/2B1bkwwlhJOS6NzU+ftFe71r3gzBvO1ClpkLpXRk9e2u?=
 =?us-ascii?Q?qFv/h7VaGDt9VIUfRX9WQiJuBzeEWrTDq4qI8uNKIpMn7p5K+fobWb0SbyD9?=
 =?us-ascii?Q?8z1lx4BVO3L1zN8p88G2FqqssX6B7IjkSwunDRJMnpyngm54P6h9QqpENNa+?=
 =?us-ascii?Q?HLmZEeV2CgfVq81tgOSjsX6R6b8mTj/3IO7cdDxIKJXFewfUqtFwvpxzmF7j?=
 =?us-ascii?Q?exzUM24ZtQCSLlz1+uNXcDmFyxQ7k45a+QlDjUGNhR0Ve1CAtjSwgcis3Lm6?=
 =?us-ascii?Q?QC6eH5KLI1hTWH7MMnuEK60xVxaMQ91mvwp/zbsYMcBwmpE0Z/7NllurVSUp?=
 =?us-ascii?Q?WMLHw1ufd/U8AGxuqQCwWBZCYDP7gm917MWnz6EBq9tuI2Iu2ULZYYmrNqWZ?=
 =?us-ascii?Q?qjDzMML4AiVVwfMHelnX7v4P+JeirE9k/ifMQbzRP8pNbg4JICeEzS2TNdCU?=
 =?us-ascii?Q?p9rXPAQrim+8wnAHe4RNIDaMwe9XvX91UI/E/Wkoe+yhEblkLKCMiGD/cCx7?=
 =?us-ascii?Q?/UkYUVVXSm6tdVlMjdHBGmCcVIcgnh0p9hI3PrXP9kLSqO9xquQJq7xQOSmn?=
 =?us-ascii?Q?hCbNQOotsWRrZeFc8dD56/NOlBdafVNPC5KXBs5EP7xASzd6ke9P87dOPTVP?=
 =?us-ascii?Q?bVIMY4hqogvQGyNIxUoQBURpYgwrRVXANqMMwhW0wsVQ/ZsKGKaMGRm6Z5ZU?=
 =?us-ascii?Q?ttOpIb6Wdkbo/O5vLJGIxwRsFPUA45pV9BhJ7BkapXRQOMzeOJDv7WxWbQBt?=
 =?us-ascii?Q?QIvDM/kif9/YJx//kTpMSW7kSfXA+3W6EXzRc6vqfGFoDSyjxf56cyI53z1o?=
 =?us-ascii?Q?wokOiLEEQVVcSSWixMeCXzXsVmsfwyTpkoxGsCxthmvnys1Dlfcek71fc3CT?=
 =?us-ascii?Q?h1YH0+a5vHtwhNCRru4f/m1pUddqSuexeLnXbIDyawosqugiDByiCFII0hap?=
 =?us-ascii?Q?MZEgmQfI0yZRR8htmvfFcMgnMqgOsnjhgcN5wUfWvX2H+jo+XAP81fcr2AB/?=
 =?us-ascii?Q?0Q5qNyn3ULe1DKlgjvPqkMN7rpnCks7D0XnP3dnSHM5kfipC86x4MOKObnnh?=
 =?us-ascii?Q?Q+0EC2VhwBjijQmnN00RJgD6obGgSQW0uTt/j/59nHdhMVP5j4iLXZ12AS+P?=
 =?us-ascii?Q?y4hjewKYoUMzhTjkeMdjlU1xQ976ztV0jR+j7KjnzlVonEMqZBS4rmgaiuyN?=
 =?us-ascii?Q?gH3MPIHbCRHT1jD3hzMoWXB6nUHCBnPUwESx/F4rkxuLYXP8xgtq0OPKygRA?=
 =?us-ascii?Q?/BPdzINyqkZcgsC07Py27lxxrR/7vTs=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 646e969e-4a8c-4e83-0558-08df409272a8
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 07:56:24.4262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UH44uM8nplVR2/+JJYkRNOf6F4IMZYltPtSzRvkFYS7eQGmignz8kA0zDHjhCCT4i9zXYN6bR+u5pJLH2OYWsDLuYn5qlxLtJB+wlim+e+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0999

JHB100 is a Starfive new RISC-V SoC for datacenter BMC (BaseBoard
Managent Controller). Similar with Aspeed 27x0.

JHB100 contain 1 UFS 3.1 interface and using Synopsys designware
UFS controller/unipro/M-PHY. The ufs-starfive.c contain JHB100
UFS platform driver, unipro driver and M-PHY driver.

The patch base on kernel v7.4-rc1

previous link:
v1:
https://patchwork.kernel.org/project/linux-scsi/cover/20260421091215.120632-1-minda.chen@starfivetech.com/
v2: can't find. (send them 2026.05.09)
v3: https://patchwork.kernel.org/project/linux-scsi/cover/20260911102359.83288-1-minda.chen@starfivetech.com/

changes:
v4:
patch1: and operating-table-v2 to required attribue and add it to
example dts
Add new patch2 to make PHY register DME attribute tables per-call
to fix sashiko ai review bug.
new patch3 change commit message.
new patch4 fix sashiko ai review bug.
1. remove the main clock and make it enable in core clk
function.
2. add phy_rst flag and phy reset assert while phy init failed.

v3:
follow sashiko AI review comments to modify the patch
patch1: remove freq hz setting.
        syscon change to phandle because this is no argument.
patch3: Call ufshcd_pltfrm_remove(pdev) and add exit function in
module remove functions.
v2:
patch1 rename dts binding doc from starfive,ufs to starfive,jhb100-ufs

Minda Chen (4):
  scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100
    SoC
  scsi: ufs: amd-versal2: Make PHY register DME attribute tables
    per-call
  scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc
    common file
  scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC

 .../bindings/ufs/starfive,jhb100-ufs.yaml     |  81 +++++
 MAINTAINERS                                   |   6 +
 drivers/ufs/host/Kconfig                      |  13 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  85 ++----
 drivers/ufs/host/ufs-starfive.c               | 283 ++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.c                 |  61 ++++
 drivers/ufs/host/ufshcd-dwc.h                 |  20 ++
 8 files changed, 482 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
 create mode 100644 drivers/ufs/host/ufs-starfive.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.17.1

