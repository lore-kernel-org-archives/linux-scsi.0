Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2132.outbound.protection.partner.outlook.cn [139.219.17.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C73941D655;
	Fri, 11 Sep 2026 10:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122268; cv=fail; b=eyt4G0SQ9BKWMTY+oSun2hI4sDUJukiOBtHNyrSL7hPCPC1CZtQ6Rh4CGe2j+MT+WzELKZ9arwIr90QouAB7/iFRyklUg2gIOoABnJt/qmLTEiXaa7v7oImtPuA3wmLHJU3QEpVdAtHe983KczgDDstrUltRG2XM3+v7Q16SgKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122268; c=relaxed/simple;
	bh=Iazq9Z/yqc8N+BtWclYt8ljpmeZL2SsPyodCz2hSxl4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=HSpK3cm72t3voZHZF8djDnbVM4widjFBWz8az9Km7dpa7o+QEve8vEfzNGTGIiCPqbcSWtjwpw74b3LKqeRqYvMWlKB2Rx9HgUab9bnZ09SRVwgiwKiZrzjdBqvCIP1GOhqex/TDFHqY1bz3a5m41NKDEf2ttyFObKJgsY30yn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZIiuNf3nVp0PV6ZGqUKKLH3ZuR/qd85CeouZbTQ9R7reS8jvnFH07S0z7dIIjxNTbMrpDwvNe+MS9b3f9QvypFmTdEvGFT5w5C9ty1L2duwEWBc155G8/7UP4bl9fUT8mCCBY3kBgHXkfV5GYTGYrlf08uYr0q72UCAizrtsvEAxOLpl4Vq4q4BaXqF5+AYZsPXHPtEm5osVaLMEepSJ+710Pb43S+VcIwbDLF/RKKUI74Pb7anEzWllAQ4zwzEzRldYm6mpzU4ZWJwRtviieJADgiBZYbkT9MaXZORO718UayI9Tsi0N4ux9gLwC+ZqDrFxYuBKw5OYc+vWLLQSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ezbCvynTZB/GRFFQQ5pPwVA+35F4+ioyoksI+clOTI=;
 b=UhO2yVfXhXqvY+KvtI5YJ2l9JLgHf57AcMVTGNzw558noBen/HdLCUWaWQ8CkuEvuGwVBDdANtRqhLDO94NJG5P2wzvHd2yLp1DOhkOvvcMFNGOc+Lh8uCyDUgRJVJDEYeaFv04iTkA34F775y3OimLSBFkkqN6ijT5lxeyV0NhpbMnRXjF2Bv/NkDTZ++g9Z2hD7MaA4jPj2RnK8J0bNItO28PKrHFJoxOlrQJWOtY28E6EZwcsRAqokG4UbxfEfMgNgDBKwWKM5YhWfl6tUHEBCTaUymxXVQ8qUFgmdn08zURVZ/AK87YA5ktStnhtlXXuQlBnWwmjSG8/rgVGWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15) by SHXPR01MB0573.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.18; Fri, 11 Sep
 2026 10:24:11 +0000
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 ([fe80::9b99:12dc:a115:b90f]) by
 SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn ([fe80::9b99:12dc:a115:b90f%4])
 with mapi id 15.21.0339.017; Fri, 11 Sep 2026 10:24:11 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v3 0/3] Add StarFive JHB100 soc UFS platform driver
Date: Fri, 11 Sep 2026 18:23:56 +0800
Message-Id: <20260911102359.83288-1-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BJSPR01CA0016.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:c::28) To SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SHXPR01MB0863:EE_|SHXPR01MB0573:EE_
X-MS-Office365-Filtering-Correlation-Id: 7415076a-4fd9-4d89-f623-08df0feed1de
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|366016|23010399003|1800799024|38350700014|921020|6133799003|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	5HgtMH9uvXc15QhA4s1Q5jKts+QNe+chH1wetvzpsSfKOEPxvZjZ3MUfOcb9omK3dmzzaZw9+zIOml+lOCKs52F4VHrGPyCaFJSEX13MnzVId3Oc9PDk2wb45SG87dG6yq/XUyxqJQd+NEA0zYDNdDJDxl5EYBZKmzB6tn4zwRncJzsOxj/ZS0iAGR3Sw6gRK48RWLo6L6egIQdVwak+kueyH6eXnd51x+RDeDboq7bqGdkq8aRCVflhKdmCWxxswvNwA8W5ePlYeEVBJxt86tcMRHplwU3vmOkSgRGf5vd9mApzPFQZms87t8Wdu9Db+5LdN2j0x2ELq9F4g/c8wScDC4L9ClbIyHv0schg5cIM3+SgOC8HvM2td6WsLcv8pMULbt+LrX523/ZaJWGU4FZMbgehUl54HfwV2H8ADCBtrYTwZc6roT4wCuZHutSWeeMf1MqUYHDfyRb8ygxGB78pt5KBvxmQ6Xm/qT2DvZ5vmmwmVuqkqm206H4zksghAO1neIKwrFFdzICXPqtUGTdNtccDaW5u92tiOKcIjWvurmFFaZ8O6V/LkA5ghxgalPEgWLwPcOkGstEAhQdPeQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(366016)(23010399003)(1800799024)(38350700014)(921020)(6133799003)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PxOJqCfkPMZZTL97pWY98gtrKT26TAk4TY6XdLQIyqRgrAxUt5ywwQM4qpD5?=
 =?us-ascii?Q?SyVCQv31TUNCkCo28TR/VnwwypEgxCdLLPgzQ6Za0SxvEnYTcLzi6tlq8DJb?=
 =?us-ascii?Q?L4jSPcMGLPiqzItphSJxG+j2dmIjIYhreJ0gtFnyxzZO2FbpEhflBgpf3tCH?=
 =?us-ascii?Q?x/JXD7DsGEk20rzH45gdGsnE//6hrRGavNmhLGsVZ6BQU0WiyWdLQhKoNGbR?=
 =?us-ascii?Q?ofkUbCEa+87wYjphsKB0C1CeUYFBbFOUUi/9OLZyQg3WH57Wf+BY+AuBjO8J?=
 =?us-ascii?Q?9TEim7SpTJ7XdQxEaqY63e8hDICnWLCGLRj3WnliflFnxx9XfQdu6FaoQO7C?=
 =?us-ascii?Q?xZd6fwWk5z1RbzI8Av1MdWoARL+D8QBnalcz57nx3n/PihcvrDbXgzDmqw4W?=
 =?us-ascii?Q?O3MpyRGAg5PJCP8BiUdzd1P0e5aUNJLxpwaZ+j8MPcZ/yGVrMY2sG1xQlr5/?=
 =?us-ascii?Q?feM7sKXZaV7Bjd5w3dsw9lgKT94LsVC1mHQ4CJ3XsdX76qk0U+Is6jPyRVu4?=
 =?us-ascii?Q?ILPOMPL7zmNY9fit7Adcja5doKvlzALyF3lam70s+UIdMBXad/8a4Hv83/DJ?=
 =?us-ascii?Q?1Qiq/YEsacYfeVyTB9Y0lQhnvO1BrIoAJcAm82hS8v2w3ItzKU4w1Onm9jmQ?=
 =?us-ascii?Q?eP1xwDEg5dsv1jP7g3HN+1dMm8YDsgJWVHu2cKIibO9hOBIUF1VySUsggPld?=
 =?us-ascii?Q?h3g3cpbZ2EF+e/YyA+GclASIJrsgTe+MX+LkGeqAdqkdP1mpbB4o9q81JHMp?=
 =?us-ascii?Q?+UL1trCptclCpJCq3DmK6W9qN0EWptwXnAtUXCQzrWC7FleMKYhqh4zqfL6r?=
 =?us-ascii?Q?BRuGVHtC+t5CelTnYaCZOEtfrh7SMlvqUeJM5O3jbQpnOBNowHL+PqA9c1IA?=
 =?us-ascii?Q?FmzXZWE+ROZuQd1S6ld9dUZjq0bPq2fhjOQGavOWpOo6PT07FpBOivBWzdij?=
 =?us-ascii?Q?Kekj/BYulbIlZyVwS0zlawY6ChIFVV0LAoUdxfMemifHt3E0apYxqgmhLJDA?=
 =?us-ascii?Q?xyzZr+faIQIVu+Jg8IDlGQ6fzTLcFR9+AAgIij3kuA+hTQbFT3AuYziuyJsf?=
 =?us-ascii?Q?FOn4OOYmop2sOI4uSv8EmDvaJKpxCaQ20+u4L5+7FsIrOlqXFAa8lNuJSw/a?=
 =?us-ascii?Q?4x0HDwLGfiH85hC09B5mPXb7Vrw0eEXU2n2+kazY1wAl8pYHul/XMJhCw2Tg?=
 =?us-ascii?Q?LwcLkklWOaxH6/+pkkFZY8r7BVTWcv1BharKCpvPZ05Ao5lyiyDwZPxiFbTu?=
 =?us-ascii?Q?1Ju0JyF1oi7eiTrkpE+MLTqglissXUUyHGQNRjRx8AdPYJHCBZFInBdnRlSr?=
 =?us-ascii?Q?7Us0NIY9EQHIn8/VJHDN4Rf7whZYlUnlcUg+9XLoDfMAABXJc4vzvM9GMi+u?=
 =?us-ascii?Q?eiiX1i8YMNjbs5iPM1e840pHin6pVn8kLk6Xepyld2wB2RgqRuHPrwohU1Jc?=
 =?us-ascii?Q?29cD6sP6ssykvqwEMBgRXD+IT87c/Ccmia7ARbraUcdcx9FZrne7qLU4gK/l?=
 =?us-ascii?Q?Ye5tkznVbNUeEBp4B9N5+MsFr2MYGr3/9ERnJMApzyREzFRRMZQX0saTOtZ3?=
 =?us-ascii?Q?VRYD1SbcapNjRqpP0tSPlk2PQ1gBpN+WPeWPLXPB8TTtttpu+M/C/rCt4hYr?=
 =?us-ascii?Q?Ke2d4cC8A7zrh6UpLHHmgtrdCSE+UxqcRPbFEUxR9L8lU7v4poRAlfoeXq0q?=
 =?us-ascii?Q?xlHV5NqND4whAc/RkaHIXNdHTFjqdUS7AxH1YJeWUcmCj9Pflk+o3RAOveF7?=
 =?us-ascii?Q?DDdGMhR2rQHh9dB/3vtKKm27DqNzEZ8=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7415076a-4fd9-4d89-f623-08df0feed1de
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 10:24:10.9463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KBRJuU9HszF6r9pPYFFkmxkBMP73pb99CzTCwdlSQhA1iJxdtEAeX58n3zF6DgduYZEYOpq7WUwcrVjK4y3lRPlX72uTtVHac2dJa0u7GY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0573

JHB100 is a Starfive new RISC-V SoC for datacenter BMC (BaseBoard
Managent Controller). Similar with Aspeed 27x0.

The JHB100 basic driver upstream is in progress:
https://patchwork.kernel.org/project/linux-riscv/cover/20260910100357.130134-1-changhuang.liang@starfivetech.com/

JHB100 contain 1 UFS 3.1 interface and using Synopsys designware
UFS controller/unipro/M-PHY. The ufs-starfive.c contain JHB100
UFS platform driver, unipro driver and M-PHY driver.

The patch base on kernel v7.3-rc1

previous link:
v1:
https://patchwork.kernel.org/project/linux-scsi/cover/20260421091215.120632-1-minda.chen@starfivetech.com/
v2: can't find. (send them 2026.05.09)

changes:
v3:
follow sashiko AI review comments to modify the patch
patch1: remove freq hz setting.
        syscon change to phandle because this is no argument.
patch3: Call ufshcd_pltfrm_remove(pdev) and add exit function in
module remove functions.
v2:
patch1 rename dts binding doc from starfive,ufs to starfive,jhb100-ufs

Minda Chen (3):
  scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100
    soc
  scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc
    common file
  scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC

 .../bindings/ufs/starfive,jhb100-ufs.yaml     |  71 +++++
 MAINTAINERS                                   |   6 +
 drivers/ufs/host/Kconfig                      |  13 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  85 +----
 drivers/ufs/host/ufs-starfive.c               | 297 ++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.c                 |  53 ++++
 drivers/ufs/host/ufshcd-dwc.h                 |  20 ++
 8 files changed, 478 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
 create mode 100644 drivers/ufs/host/ufs-starfive.c


base-commit: 89a312991dc6e638a36adc43ccb91dbc25504c04
-- 
2.17.1

