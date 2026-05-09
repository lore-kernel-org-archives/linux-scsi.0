Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2125.outbound.protection.partner.outlook.cn [139.219.146.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D162B37BE8A;
	Sat,  9 May 2026 06:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778308107; cv=fail; b=CRs37KXLE2GfVd8SitC4JE7X7bmYf2BJKtziCoipMuuwQ1EUaH0u5vtogTe0+JXggMsn9xpGFgc3JF4sMwB0PTSMocEg3oDfysGknTINM37SOn2eCAlWZQiZcSVZVUGfgVTp9lX5YpRPrhKrLKPzwYE1piovF6rSQGMclF5ysts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778308107; c=relaxed/simple;
	bh=7beq9KdK18itG4Tgm9+gH8fcCRlUJo648409H2Kwp0M=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=sViIIho5wk56nWvvoWa6TgXZpbCP49oFeFdzGioLkcDFNVIcwGuWokcqSsjApBFfpJgPXuX3ZtHjecxBNmBs84ynQI+ACrVhEjgrAXVbY3OYPgYuN7oG85NF0wzPb7HOWkctBoIhLW2FXfKhjopQJcq+yKZ+V8sAWDPa2R4ruB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsVsDlLajehPm2gX/EOBlG+7Q8IBojJ+60PZhxJIejfj9YgV72xWXcTqHhg12Da38CQJ81gCHOaszCl9lmarPxo5Ytxfmhc94uCUYjtQKZw8q5zzMC441ka512Cr+SaILlqpL31d+qySJTgAfRvZ8akHOwvg/9+Cbgce0AD3jjYptpR5XqfMelmBgelfmLxiotdCCRpfqqvfsVEYqDOd/nXDqRi7VtWaorncr9qbWmfV/YrnNePBRWMp41Hmmo4/LuPnZh6lVLV6RMa4k+6rp72mu7xtuEvJG8rmkjUVsWMRLPdHoeHfiNvYREY7kZjrZzikN7lq907O2u84U0zs4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMBlQSBVEEsfY0pJAqQYOsM0O+A3xUlaD0z2kSVR05Y=;
 b=ZyT8/ADiSaWyFIpb/Hg47bBorw4r2byXLbCBmXyT9Td/JpfAFvGFEbLydYeTcVif6IouQRNCvfQZy3YkiJb+PLCc2S9VAoydC1MbnlCpZHDdMSzyJJTMhjbTq7Cz1gVjw8hNmPnzwCLNeRfHu1L7IwDNWGMtMqohDCdvDWNV6C3Q5o85tiELl275K1NC0xTAU0S/FgfnvMXBfA+cOUkuJdZAEm0MHOWSfvP1xlAYAizJmXyhHXPm1TSQK0Sey03r7L25RX/v4sdFDsPCsDgtOLITmV1ZJiV1EGIURC6I7nvO9zYlF83SaCQoViL+9K/cL3oc+Ptfu828SpLZ/8Co7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0632.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:16::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Sat, 9 May
 2026 06:28:07 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9846.025; Sat, 9 May 2026 06:28:07 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v2 0/3] Add StarFive JHB100 soc UFS platform driver
Date: Sat,  9 May 2026 14:27:56 +0800
Message-Id: <20260509062759.125472-1-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0018.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:5::15) To BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BJXPR01MB0855:EE_|BJXPR01MB0632:EE_
X-MS-Office365-Filtering-Correlation-Id: 80afaca1-1e26-4f4c-041d-08dead94222d
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|56012099003|18002099003|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	OSm0osoZ/u9tH1ks2trQHY9BkNo4ZS2XvTNfxeffHJT3MJDD5/vQEJe/eiaRUeyvXlqFGNvQJsoLVQQbB2X70e+0Lb1WHAAgp4ePIvSoEL5uogmSF9oGUEXxv/rjHfoLETXBtfTKcOy4r1FqcYfxKooRqlVpeaRPA/k+3pOMMpVu9epmlf9HxWwR5+uzNpTEhFKXdqo6M1ZmqPYIzuH9S0rBdfBFyw8aNBMB56H/UMayvTQUasuxH324cjsOLqQQf6xo+ryWtESxh1EUZRmKC6wiMxPma/xQG7fb73Il4tda3iz1YPE493ODaROwLwDltZsipVI4lQMGErSPlo8BJO4Zv6V6NEa/Fe1KoCPXAuiyNEp6bpoLggD2rArVDNfCmMMEVPqFgGirtlDcsq4p+k8Nhl3XVsedR8+flaPXR+HtYBN8tfhpNkNvjRL0neSrTtc9wWWcxzKOMH7K0TPUccaVwrOCCLCzdgjjmzRu0lxbkWEDfjdsGYpD/k9Xle74lWuyeMmO6PldMMdAUY7borhUDxvZ7KSdJhwG2nulYUvTomDYcooUaduVAgLVP4bSYUHD21hH1fC4wfkIk5PzPQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(56012099003)(18002099003)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rKSIQhnc5IwxMsqqfoE0APOMAdKe7gDlhK9L+fs8mBqLA6kv0ax66pkgw2qO?=
 =?us-ascii?Q?JaCv+KeYfRYIM0snrWO332S1DECKaea20ufI1xKrgvgwtIBz5nGL3VjBpFnj?=
 =?us-ascii?Q?M6at9Rs/+l/oZpjHcIQ0lM0uuLhO2vtnwZqx+Z/b/r3EPpb368NiNEr8aF00?=
 =?us-ascii?Q?ve2D7VN8GJoRXAN0k03ld60k+rEYHYNy8DI80zgW+XIj+k6eKFqrTmp0PWw/?=
 =?us-ascii?Q?yWg1jk2GjOfsrts/jhEEID7oJBZRXA2dosbzmbjYHYtsDG0ibaDWC5FKadhI?=
 =?us-ascii?Q?tOYajUTGkGZZ2G8BsdiLPeFs3MjPgs/lOaupQ+s/xtxVkMvl8Ae3+EnH7/qw?=
 =?us-ascii?Q?J3/2ksnz7J090pr1CAgBYlotqKr5ggd2Uo/JDSs7H+Sr0bkwdxiLHJDBbGoH?=
 =?us-ascii?Q?jj8y1VPkKnfZWLF1NyO4VOkGxm+QfQaLBOPBfwssExHd8cjMjBZ7sI8KRYqQ?=
 =?us-ascii?Q?ZFOePP9gqFh8Oux4/sP+AN2B0zrcOIL2Te23m4RpA6xMoARrQcB1TDckUSZH?=
 =?us-ascii?Q?Zvs9gx1potwid1XDENbBusYIUQ8DVTV9wWYMWxLbUK/zyYrcbERkg4Rp3zb2?=
 =?us-ascii?Q?GkCEtJUKuySvOASfyzRwlCmjy7j8/27XqImsZ5IqBbzy/4AsUOsLyRe+r4wv?=
 =?us-ascii?Q?4lmKuMOun8KJXgsxnKb417FHDWmD9HiXK6r+BFd8YSQ8VcWf78KNwBNkjd8K?=
 =?us-ascii?Q?dCQRWaKjWGH1GIf6c4KXdu2gn7VvEFpiMkw8pBGHgszBEG11kSLv1Mx6xc4q?=
 =?us-ascii?Q?yzbpXBTtWfxrywpfZsjwyv93AHMDixTnyyhUdcrKP+1SjhDlffo+VVeTn9kA?=
 =?us-ascii?Q?h0uqBozladelnISMMZublzmsLh/NM+0umdaBMlD7/ls7dTPQVe9YXObom03f?=
 =?us-ascii?Q?1GR1i/mZFfWUnKmkExP2rvF9qWql8CjCPpr94fTG++SRLHqXZ8dTze/D7zdB?=
 =?us-ascii?Q?5NUWCXMlE6r4S6cQfhtTcGcDAe+TUwIg1qjL/YVb1qwAQ7mgdP5mxYU5gKnQ?=
 =?us-ascii?Q?gVBxv4ev7QoEsLn71OgmhPCM8hoYCxHAgsy9Zmk68U/TTvCXdtqmiMaMb8BQ?=
 =?us-ascii?Q?OrNReLZGicFLM4K8jwnvwHt/wZKYAudQic6tYOJjtH6mO6N3VhjLCuXWyeeV?=
 =?us-ascii?Q?ToEMZ1ZdaCpXwoPZve9ns1Z15GMJ9HuDMoa0r1uTiDJ5EaYRr8MEsFYuW+g+?=
 =?us-ascii?Q?5ZiMpuPLSmY2b7NxPFKg9M/GIqP5rr7s84MRxPgAmIi9Lc/hbmcxtmJhjVSq?=
 =?us-ascii?Q?CZzl6ju8rqDoJ4ZFBrk6dMwwfbofrij+zzwtasIqL4wqClDAqZ7Ogg3nDG/b?=
 =?us-ascii?Q?4nyKfpwInqZpSMOwNFSH6+1TfAs+k2aniDSqlH+uAsmRJCyjlmYIDEFu7J25?=
 =?us-ascii?Q?pi5wtg5tkSWYUxJK0woCWvBdSrhG0pXB5RkmOxOyrKuJ8wIlHF9cIH7kKv0J?=
 =?us-ascii?Q?dt8EipummWt9OsR5XV2a45K0OnPg+weMRvVwCYVNTycyS9mizi0NesXgAXx6?=
 =?us-ascii?Q?TJgZJaQI/lyT/XEx8DAuuccovMdokmJvxsHWJmkWyei9D1Rsd+E9tBOc1Lna?=
 =?us-ascii?Q?Cj25pF5d3olXDQuo1wQvpc1XqPFG5XnN5XkfBkCqCemSmq6PTt/uKysotKck?=
 =?us-ascii?Q?5Fk9FzB+stJbsEW+Hn3LGUVxn57QKS+1TAd3ppfYXu/HinkvWW8+hI+uwcyz?=
 =?us-ascii?Q?EHoLjy/3VRHZ84YPK1W9iNRtorEBSLBR/iciHfq/QGCliDZiVjq0DEoA6ldI?=
 =?us-ascii?Q?GZDu+OxmIrG03eh974n3AcxCm0SgBHQ=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80afaca1-1e26-4f4c-041d-08dead94222d
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 06:28:07.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Py5h+Smumda8LPB3DqxFJP9siMzz0XuO+BDyDV9wXnrMx8uh0h5z8RSBUBQW/568Yf+SDUfuxtPOs0nGnRHXjipqzlJFaezYnTyyxrKSGsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0632

JHB100 is a Starfive new RISC-V SoC for datacenter BMC (BaseBoard
Managent Controller). Similar with Aspeed 27x0.

The JHB100 minimal system upstream is in progress:
https://patchwork.kernel.org/project/linux-riscv/cover/20260508053632.818548-1-changhuang.liang@starfivetech.com/

JHB100 contain 1 UFS 3.1 interface and using Synopsys designware
UFS controller/unipro/M-PHY. The ufs-starfive.c contain JHB100
UFS platform driver, unipro driver and M-PHY driver.

The patch base on kernel v7.1-rc2

previous link:
v1:
https://patchwork.kernel.org/project/linux-scsi/cover/20260421091215.120632-1-minda.chen@starfivetech.com/

changes:
v2:
patch1 rename dts binding doc from starfive,ufs to starfive,jhb100-ufs

Minda Chen (3):
  scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100
    soc
  scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc
    common file
  scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC

 .../bindings/ufs/starfive,jhb100-ufs.yaml     |  76 +++++
 MAINTAINERS                                   |   6 +
 drivers/ufs/host/Kconfig                      |  13 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  85 ++----
 drivers/ufs/host/ufs-starfive.c               | 280 ++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.c                 |  53 ++++
 drivers/ufs/host/ufshcd-dwc.h                 |  20 ++
 8 files changed, 466 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
 create mode 100644 drivers/ufs/host/ufs-starfive.c


base-commit: 74fe02ce122a6103f207d29fafc8b3a53de6abaf
-- 
2.17.1

