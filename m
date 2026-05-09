Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2125.outbound.protection.partner.outlook.cn [139.219.146.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD029384244;
	Sat,  9 May 2026 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778308109; cv=fail; b=njmTmZguRpr0TJCidHkmbgayUxrY76i/3Le83g34IxPCgCVKwgoGvio08tFoii3LW/3+ONEZ+h0So7FoEzRUdxi7JqaMKI7KV7t0Zwb/a8fPnRSbYzCkSchIyheJfKK9FUAbhFNWDTmnJ9YEAaJrbWHrmyn32dH0MgSDhNAxVuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778308109; c=relaxed/simple;
	bh=1md+k+jdnycV06xXtdR04WxvTvNMX+vKJAZTCLB4NRI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y8cVWEPgEfTmC9GQ4P4JpNJxcSv/XIMV8gNcSDsru8J3qKN493ClY+tWdB6XqKUQjw2s0u3YNc6T9NZyGCbv7ktYT141hKfGwtcmIbSgChIA8ISnKK0McKBYy4oZ61mSpbLWGiqXKiuOK3iT/QyKXZb3SuGaq2UvM1xp7uO/EB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDXWQZO9esqb8eHN5iPfYotm7zKUuTMsTqicd9ZmHXi1iQBo0XF9YFvVqr3zhmH2af5LCVntXIpvGW0PT9jdezYbehPBfMUZG3ChVd1Sd3/F6Lw1QZKRzjKtRPj8nobcg1qMTArfV+Vsa0YHkX6qaZILG8yu3u2YCDbXQYF16FgSq67naLEJhJsgWfNCN7fHARtyneQT6ZOLhsSB/Ud6SDC3WfYqM4MRJ30CxN2yDFSDyjITJdjYGZ2Vr6fRVVDMkmgkQeT+mFGB2EC4DeEEKYvk5lF7zBHhje61qJOT+R4VKiEflU39fGUrIEGpz9yPNDmJw3Xa6Ayiilj9ZBu8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4EzxHFUTu9WVBH+v0tR9P7XybMLoPk/e0NVjTM3rnA=;
 b=NlCtHklyGMzXZVqldgJPXjRBNbA4VuOH2C5YuqrB6Lu3ryJ9eDS5stmL9ADNc+wlw9BcH3ZFep2FDx+QHB0esEv8VkNfYNM5egh+dUv5IinXL04Vxf0B+FNOcb8aYQK2rjc4CeGF5UTD6evm/BzHH35qTNur+AGIZj5Je/pg0vZ/XQzXjvdG1AkfSpo1ysdc4sHEge13KxnS3791PVEOB+4Mh7+cys2r2fi3zyyDD76leBWWMOmzAYunO2xMRgnXbgvn4eQT4g/uldaz9NESwDDNRE9wNLuzUlQ0HqnCwihUvePhjY9nOqte4UZokEzX+0jjECotSGjB6s6lzGA7Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0632.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:16::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Sat, 9 May
 2026 06:28:10 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9846.025; Sat, 9 May 2026 06:28:10 +0000
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
Subject: [PATCH v2 2/3] scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc common file
Date: Sat,  9 May 2026 14:27:58 +0800
Message-Id: <20260509062759.125472-3-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260509062759.125472-1-minda.chen@starfivetech.com>
References: <20260509062759.125472-1-minda.chen@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4c2e7665-7f14-4942-9b7b-08dead9423b8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|56012099003|22082099003|18002099003|38350700014|921020|3023799003;
X-Microsoft-Antispam-Message-Info:
	YLHegqDAdpzHR9y703l6sm8MFXjuRnSs22af95GXkygfTQN5VRDwwU655HAe656z5JtQVNjEKPM0lp9OecjpQCu01v19zH6H0Cm14u+0nzI/WlhCHizrmkTdOr5yLAsqMboj3mFzqPr0Tp++bB3lsP1fvNS/a1l9iaplBmvv4gXJL+Ww5/T0M8EXvp9eeNjGgxHnTNarx772I4nqgGKHFTcSI73WCf1jv3chhx0bfUZu7bKGbHbNMIxy8DApcFJA9xIr4H3OPJr9JBLSVfTnggjqMTAHPu+qjICoIOQ6/hJ0y56Gakdg73/z+VdUpBzgrcusUVbtKe1PrvLDDd2mUPbw8FvP2Ag1aXtgwrPWVQyJSrR7KzXTWgm3s2DNIa0b987CXNSCOYqwz/zSBY3DU8mFh4IzIoDQ6avi/QCp3u5zaN4V23StgPMkz23aP/u9DUZzshSlUBTAEFff7COlh0DDPWGk4ZZ3JEl/nOG18Wl+6xLEVpHCynZxvBmCjQibTSJ86X5Ok25p0zXsyhkFMLEgx0gB3Gsk4EXIK5/BPVvPFxX7Rmnbi6LJkOU3W/IaeLdOLIvOCP/XESaAO3no4w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(56012099003)(22082099003)(18002099003)(38350700014)(921020)(3023799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RVVKOiHTL219M/+nWdF64rOS2CoPWOoPv1asDVPoU2//psViKrnZWLlwUaAw?=
 =?us-ascii?Q?joNNPkvL6VdN1ZeWS37890QlD9aleUvEhW2+egiNWXkwxSqQiDUJ1jhGjcvn?=
 =?us-ascii?Q?+VgED92ZandyXc8j5i1fvvxTvUy+7BWTSPSjMX68VKAoebocZxrhi+g8r0Ku?=
 =?us-ascii?Q?qY9tM0cTtde0H5NXKiUv16EHOMTVyM0IENUA8tcqrL25HgZFmt/IySpw/6ie?=
 =?us-ascii?Q?T2BQjyo9RXfQ650asQdoymbff28IeknCHe9Yl8mWCJQ4hhDRvc/HiaKXcONK?=
 =?us-ascii?Q?ArCHzjwglOvl9T1CIXLTw4EB2V3XWnmn0C6yaOYfIyu8Hfv0Y0oZVELyJy4E?=
 =?us-ascii?Q?yW6Fzx6rU/8TFmdKNgPMWFSD4p879aoRYYNIDZM58nla/DHUWyB2Ej1KY0Js?=
 =?us-ascii?Q?2fXWFmXOlP41zQ1MQ5NYbEBcvRvlfMOo4+IzATMmMbGkgZ+gWc/hs//YJb1/?=
 =?us-ascii?Q?bJD+kVrRkja0oMTJAJo7IyXjIEjGn15eG0VEWatJI4ctYoaiGAPPhsVyPjPZ?=
 =?us-ascii?Q?tVlFahPnDDHBAb4zbLEvMnhDz+FSmBAIXQYlBpsfA0pYXbQIRVKQoMtdWC5S?=
 =?us-ascii?Q?ESP0/BruyB5AckcuFBw8cM5a5LhCQ1GBflqlHA9X8J+Fy9EbBtb9pC+4Jec5?=
 =?us-ascii?Q?eR/QdbVYdP+LlCZgjo1Doz6fobKZF+wyUhG/Fd31nNLRcqjWonnQZUSOSqhY?=
 =?us-ascii?Q?B1n7YIzavHG+j5X2mqfOXaL79CH8irR02szAqjO9oPDqrUZIUvUv5KKx5m+E?=
 =?us-ascii?Q?RUfnKRLeJ5qULtz+PFSvMgJjiOC5yGo+dMVT7Atxl1nc/OFVOJBL4Xsr2n2Z?=
 =?us-ascii?Q?N6ZhlPyXQaV0a76hUcW63U7ZK321ilJn9GB4zUVJdFRRPQng1NTkLK6uoose?=
 =?us-ascii?Q?LrDDd941Vpxa+ktM3LHuFQ7sngtFxwwIh2wyXBW9LCM0xGitH71ykRMZXeiZ?=
 =?us-ascii?Q?J08GsOll5OdcfRfcsLB7FPjY8cwR7gFfDiil19yv53bRrNWbzEM2J6PRl2Sv?=
 =?us-ascii?Q?vZomUTBayidf2Cf5PPC2TWqkMvOyCAY368greld2cMHTGttc5Po3h8aOQ4Vr?=
 =?us-ascii?Q?x4UhGsLyW/kQROEji0DPEdis/UCcKbA7sr8Pv4C1USUQz5W1m5h3UzyEHpoH?=
 =?us-ascii?Q?fXV4pKIMX5DuauuzjxRLVQsVRpWWm3t1yhpHzAz5IDZfYyKAfIwXiE8K0M1D?=
 =?us-ascii?Q?sSHMDcGg1/BanX0ftfkmCE4wI08RILHC4+abhA1+hD1lL3hJU/s7LvWL+NGE?=
 =?us-ascii?Q?OIzlac8EmuhH/E4X6UQ4oNOVgM+zS0r6uSlbtS9KvwdS/50MdsI/IZ7w6sVE?=
 =?us-ascii?Q?9oAuXRzI4/b4Sid1IhebCci4nB3XrhgNXa0qqjcszwn46x/NIInudESRjHFH?=
 =?us-ascii?Q?JcGIJrsD29GTa7/cCHn6HyXIqTsDrylGZuJeFBwNbh3YimlWnhZNrVIAaM1b?=
 =?us-ascii?Q?EsijMBa46aVo4OGMEgLVRaxe54DnQMzR5edr79WJ6LIY/V8mVHW8Dd11bWF2?=
 =?us-ascii?Q?0r/JbMVTKKiiJ9fmNlP4r6anWLwCBD2/46JsIBn58EL9Jyp8xrJkn4im1y+8?=
 =?us-ascii?Q?LRS9IIn4UNjHEvLI76uPzr/2vfRfKTtnv/ZPjZ4NHhlFp07bzVUkJv6hHhm/?=
 =?us-ascii?Q?HIXG5tJ7f+iZlI3hp66rm4qPPWnjZy9VXck+bJ1UhPM1USz0qBiLS67wVRKW?=
 =?us-ascii?Q?uXiN3A9XB/CvjwdVXe0b/tkFuWENNcmMgxRlU2+iovh364KQUlRno3odECAP?=
 =?us-ascii?Q?gYrfMg15LKjOX57/aTNlt2IEB+cyIoQ=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c2e7665-7f14-4942-9b7b-08dead9423b8
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 06:28:10.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iJiv6WrLRTcyRliOu4VXjpZ2P/X7dULsjJ6aKOB2/z/MvOs14bhTe2zdZXAMzn95oxbgkMyc/eX5g3Zk7gA/BhRBU51DPdMuX7/IxUMMcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0632

AMD versal2 UFS using designware ufs mipi PHY. The read/write PHY
register API are common functions for designware ufs PHY. For other
vendors reuse the code, move to common ufshcd-dwc.c file.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
 drivers/ufs/host/ufshcd-dwc.c      | 53 +++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  2 +
 3 files changed, 72 insertions(+), 68 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 2154d6286817..2e671881e7ae 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -43,57 +43,6 @@ struct ufs_versal2_host {
 	u8 ctlecompval1;
 };
 
-static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
-{
-	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_write_attrs[0].mib_val = (u8)addr;
-	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
-	phy_write_attrs[2].mib_val = (u8)val;
-	phy_write_attrs[3].mib_val = (u8)(val >> 8);
-
-	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
-}
-
-static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
-{
-	u32 mib_val;
-	int ret;
-	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
-	};
-
-	phy_read_attrs[0].mib_val = (u8)addr;
-	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
-
-	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
-	if (ret)
-		return ret;
-
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val = mib_val;
-	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
-	if (ret)
-		return ret;
-
-	*val |= (mib_val << 8);
-
-	return 0;
-}
-
 static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 {
 	u32 offset, reg;
@@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
 	u32 reg;
 
 	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
+	ret = ufs_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
+	ret = ufs_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
+	ret = ufs_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
+	ret = ufs_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
 	if (ret)
 		return ret;
 
 	/* Program ATT and CTLE compensation values */
 	if (host->attcompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
+		ret = ufs_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->attcompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
+		ret = ufs_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
+		ret = ufs_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
+		ret = ufs_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
 		if (ret)
 			return ret;
 	}
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
+	ret = ufs_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
+	ret = ufs_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
+	ret = ufs_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
+	return ufs_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
 }
 
 static int ufs_versal2_phy_init(struct ufs_hba *hba)
@@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 
 	for (lane = 0; lane < activelanes; lane++) {
 		time_left = TIMEOUT_MICROSEC;
-		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		ret = ufs_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 		if (ret)
 			return ret;
 
@@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 		else
 			reg &= ~MPHY_RX_OVRD_VAL;
 
-		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+		ret = ufs_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 		if (ret)
 			return ret;
 
 		do {
-			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
+			ret = ufs_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
 			if (ret)
 				return ret;
 
@@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
 		/* Remove rx_req override */
 		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
-			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+			ret = ufs_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 			if (ret)
 				return ret;
 
 			reg &= ~MPHY_RX_OVRD_EN;
-			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+			ret = ufs_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..b057a78e151c 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -15,6 +15,59 @@
 #include "ufshcd-dwc.h"
 #include "ufshci-dwc.h"
 
+int ufs_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
+
+	phy_write_attrs[0].mib_val = (u8)addr;
+	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
+	phy_write_attrs[2].mib_val = (u8)val;
+	phy_write_attrs[3].mib_val = (u8)(val >> 8);
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
+}
+EXPORT_SYMBOL(ufs_dwc_phy_reg_write);
+
+int ufs_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	u32 mib_val;
+	int ret;
+	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
+
+	phy_read_attrs[0].mib_val = (u8)addr;
+	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val = mib_val;
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val |= (mib_val << 8);
+
+	return 0;
+}
+EXPORT_SYMBOL(ufs_dwc_phy_reg_read);
+
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n)
 {
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index c618bb914904..8091f186a9b3 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -68,4 +68,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
+int ufs_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
+int ufs_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
 #endif /* End of Header */
-- 
2.17.1

