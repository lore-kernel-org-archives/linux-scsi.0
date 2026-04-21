Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2112.outbound.protection.partner.outlook.cn [139.219.17.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4493A3838;
	Tue, 21 Apr 2026 09:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762760; cv=fail; b=HTy+gEcrGz3RCeIrdATXr9gSpp3uAjev23OLms47e5BYBG8KfxVffLYf7uzFNgQuH5lvURt0fjbKNtON+36E9gOs34O6MpyCPsyUQzr2Bp1luWLm3GOtsRNh7I8jgVRLUPduJYTRE0o0bmxK0FLQHowsFkRN6cjFIcRngEClrnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762760; c=relaxed/simple;
	bh=CQBcsGYAkNgY++4I+9bWgka97RRCnPU91a9DwEl/8O4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=cB7iOqCc0VxvoaMJmB5s+7TutRv/qfXOZox5Gip/u/lMC/5mK5TyqbVsdAjfvuuGrUWmUWa0YiWjIGjDMMrR0lcwdxkGKtDVaBRaxPSRypywl6iaDsOasMUEcjHOReb9RSQQhQ7hApCq9wuuTO7o/E3VfaDEy4sgCuTperOq4+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlRYV3iIVunsn/b32tFQcbB9Z7z1mrOVaqRNdSddrGBgwNA2EcS0R9qTWirtjwCkJtvtvxsn+u8HfinYQSU76d+cKJAlJYfQSY5AlwW5KyNs844FNNme7rYdiWQ94RpXRWpQ6D9uwf0B5ZYWkWXXmdTqpxMgfU71r7tx766l0zkm7EFq8R54NO0nPVLVzRUTnaV4TV4jLw9dGN504eZ/JgkKciPOpPTdDWjKJcBd6yKbG0Me3MYUQIuzkQTxGGVU8/zlQpW8TmwASpKrnbywQbycGTyqO6p5K+4gO4lfQArzsT7yvNWKtX4U7TWN2MG1aGBl0ZYqs2RRdfF5B0V9KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCMY74dyL8cWuYLqZvUsrLetvSyY2XLhHGjhTbAYMfk=;
 b=HfUDy5EigdlPAxNre+yGYyMxau4jyHOUCS3TgZQr50ARUfblG94ssNn2nTAgbOaSb5Uezelpv7MCwapBwHvlvYCJ23IGDnH2UscsKKNkoPjKo5BbFUaW3E/VNV7DKLAHtFYgklu3kWxttWYbg6TH7PXXZvw2Rzb9kT3DI1FToXJWGRfR+IueQiImYC53Eh/ZFA/ni4jgL1Wql9SkzO6MyUzL/maG1CnHpN5iCgJ/JGPF0jGcUoUSarSU6ZanTc0ZgALr/Q0dot0AFKCdS6cFlze0RblBi61NryGQoA8bUGf94vagcIFx9z0Owrz/F/fgRte4unroTYXA+PNIaBG/iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0519.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:15::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 21 Apr
 2026 09:12:24 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9769.046; Tue, 21 Apr 2026 09:12:24 +0000
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
Subject: [PATCH v1 0/3] Add StarFive JHB100 soc UFS platform driver
Date: Tue, 21 Apr 2026 17:12:12 +0800
Message-Id: <20260421091215.120632-1-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0030.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:c::18) To BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BJXPR01MB0855:EE_|BJXPR01MB0519:EE_
X-MS-Office365-Filtering-Correlation-Id: e82bb117-fcbf-478d-3cf1-08de9f8619f2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|52116014|921020|56012099003|18002099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	AvChBTstbWXp4se/GozYynlp3oAg7KyAcBiHndst+TYOb96M/fg59Db2OA0v4Ijqblli2NvSZLDgCoPHVqwItW7N5DWE/tx22xgkbXgNNbFa9e5V65FyIwWnND9p1pPWdw2FLQ9SI2xKduvvn/KTgoixAMcy51IWfax6QeU41jxcyEm/UEAxAJnMVzpPIYCE6yVA3H+wC2NcPycJdJMidrXAm94k0+qiKa3Lp5oEYCqWB+RizzoF3Qbllf7RvPC1c+O2q9abbK0Y8k3pVl+gSC7tZXYHIRKTiqjiEvP+V5tJimMSv2y3VfyFdvgKd9mAE0/ArWrLt2i5BYaNZskM5DbhFM77+YtxAvp7bTB+tzbyCtavmnqy36OitUSz84yleVauFRjycwdgPPjfcqDHfEsQ/Y3inXPwvS4kB50PBJX47UoydOIEMFb2Oq1mPcz0IB332caN84faS8P2cU8ZE1Z0JTRZsy/NpPDlB2HRGQla/QY8bbd9th3LUGZ711NdNe8ZNYPvBNAdJcmPpvi3hv370Dz/nLwcex/zJJtJILJ0IJYM2AndLtB/7zf7OtghVnblVUVvdbquq8rsvnqUMw2c0vtwfyWeKWXJBLnbrCc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(52116014)(921020)(56012099003)(18002099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+d5wMcVO0kdtbYA2Y42O47OTgg7twM2dXG0/7tpXPMq+rprcrWuOtPoybKYY?=
 =?us-ascii?Q?z76H5zgLrdbyIlTomUQggr6fQe2YokDflB+vVuAjQY9YDXVnlqjqZtHmljOa?=
 =?us-ascii?Q?RfRB9Wp8At1ifpiAfNmze0e4ZHlTKcQ0XekbVf/qmOio2Z/cELmdl+M7MqR9?=
 =?us-ascii?Q?IxeYWUg11kQLKmp6xn3jpyDnB+J4Xstc63wiLKxJPa2UfS8VC3HmBolLDNAO?=
 =?us-ascii?Q?XcORyRAroDDIuQMwQLMWPczM1IqLkPzw8tv6/cvDok7hx8U4bY69DcgCqmkY?=
 =?us-ascii?Q?WZbb9VuWYA/xurLRM2c9TNH2UAHBSsoD8l1wZ9pNqWx0qtuzis5zHOeNN8EV?=
 =?us-ascii?Q?1PLnHuwk9dKNA1GcxpXz1fSTM4TdOvrqKF7t2WXQO0WGoOrVNmxEZ9M+XF0T?=
 =?us-ascii?Q?p3D+KipCYg7E0jyvJBwRNu9mOpJ9NOw3LpbRNHEIMz4rC+wwuum/Gse1tYgR?=
 =?us-ascii?Q?CzJqVF4TAAiK+u457dX47PhawarX9Di8K6lwhyLLHxTCCQzf53cKZ/f0scqz?=
 =?us-ascii?Q?EUB+/PQUjk9H7me228bIYseGcb0rDqTxRFjEWbD42RjxmlE/VMalUCEHEGUX?=
 =?us-ascii?Q?wQ+ZQey+wDADuH4FWYi2JfP7H/30WCn+7IKL9HJ7w+/7C3O7AK06625Knnob?=
 =?us-ascii?Q?/uKeP8YBJ1SykroKzkcp1enVrKc8Wk3OO/Xi/k7mFmsH3Zz5VkjW/c8iJG0s?=
 =?us-ascii?Q?kE2arGLzLlZ29ghh5rdzvB8OslCAwtVyOHqpjdRo0JO1XTXa1oAeeAJRU/Of?=
 =?us-ascii?Q?6EE8X9WHDgXwSjh89Z2bICQswfDECfyVPDo/VLci7Apu3g8WxV8HlogxhWIV?=
 =?us-ascii?Q?xTfGUJP0JgwwOu7pxs3TTtA20nHcH8eu14Rv4DULZGlj+YIRJBA3Ysy7tEIL?=
 =?us-ascii?Q?Y7cK/dDnjHLgjT3fWXyMOuj0q2e7fWHbz8wWpXN6PZiOp9tuHBVJJHOv5bwi?=
 =?us-ascii?Q?DLi1oSSiFb/tGKqTl5ZEEeaLnZAhgBwis6ou/kGHhYyAAISILbYxmqYDdJ4Z?=
 =?us-ascii?Q?BQCudQZ4fRBIqAhus8ruNMnxaKll/HRhpO8iLkDXK/DIO2+qK7XVKlv2UVPB?=
 =?us-ascii?Q?eQR5jcK23VNECrXAc5HdMCGid0VNsVsdXkTLyHucEiVnNS915UFcLkBCsTKs?=
 =?us-ascii?Q?x8vNS3/UjFhID1tYHf1n3Ifh1JfTzjp5x9bj/OVlaVJURFtG7/FuYufH7RPI?=
 =?us-ascii?Q?A2bdf4BQuk3tNRbtIGrRlVTrpeR5Z2iPYhwaXG9Cj3Lt2igr5HpfDwnSShhn?=
 =?us-ascii?Q?IiqYZbN1YzylXjFZYgvXsAclk3EfMq0yjfckeslvUJFIvCr80/XrxXdbdZju?=
 =?us-ascii?Q?qrCSkuxg3I+Py03NpT1fH/iLCs3Dm6LdHCCQu0c306ygSIP0kSueFR/9063l?=
 =?us-ascii?Q?iG8ZL3gnZ3iaE9l2Q/WrX9ceHDIrkTEYoGpE98YpKCRyEYPILbQfxmqpu4Hv?=
 =?us-ascii?Q?GisXDndUqojSD9ptY4aNT7d2MlIBT9RlOYS1qJ5cY8ItFJOsSmOBQscQ0n0J?=
 =?us-ascii?Q?ygRECKS2u40qboodwEGwc6/McZBBsMstMte/AXAdSYueC5nr114A1EvVRpqH?=
 =?us-ascii?Q?0UoXm5nYe7DkRpTHgtBFN9SbrINLqe9NqFH0rKhS8MSwtlJVHXVPT2VL0TmE?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e82bb117-fcbf-478d-3cf1-08de9f8619f2
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 09:12:24.4281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /10MjZrPHvD43wGk4fpHMkfL9fhMAmhG4TNsdeNrwOpijkoOc+W9YUom80u9DGmhCU8z/hLi1WNyO1QuSaOHYfX9FP3IANkDjL6Ulq4fBmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0519

JHB100 is a Starfive new RISC-V SoC for datacenter BMC (BaseBoard
Managent Controller). Similar with Aspeed 27x0.

The JHB100 minimal system upstream is in progress:
https://patchwork.kernel.org/project/linux-riscv/cover/20260403054945.467700-1-changhuang.liang@starfivetech.com/

JHB100 contain 1 UFS 3.1 interface and using Synopsys designware
UFS controller/unipro/M-PHY. The ufs-starfive.c contain JHB100
UFS platform driver, unipro driver and M-PHY driver.

The patch base in 7.0-rc5

Minda Chen (3):
  scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100
    soc
  scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc
    common file
  scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC

 .../devicetree/bindings/ufs/starfive,ufs.yaml |  76 +++++
 MAINTAINERS                                   |   6 +
 drivers/ufs/host/Kconfig                      |  13 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  85 ++----
 drivers/ufs/host/ufs-starfive.c               | 279 ++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.c                 |  53 ++++
 drivers/ufs/host/ufshcd-dwc.h                 |  19 ++
 8 files changed, 464 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
 create mode 100644 drivers/ufs/host/ufs-starfive.c


base-commit: c369299895a591d96745d6492d4888259b004a9e
-- 
2.17.1

