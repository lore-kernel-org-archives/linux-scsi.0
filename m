Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.134
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794470207;
	b=R8NFHNpk957FDPYJdP2Yfe73++Vp2mmd+5l9mykeVaEzwy+Z5mAYcdTlWkQf6TxUFOML
	 XETgihksoNUykLAdpf8b9BI6LxzQg3sW6zSHptTJ5a8r8+z+kGxeIBckqo4yQPNhKcfnH
	 usy7hbo4PkvHKEe9PrgKBBmgj5HITEWJx7DWi912gKK41ySEA3QmBI5BAcxHIZDVkU3sV
	 BGTd5PwBMLdBqJqxhKgX9fNpC2wiTfbYt40Ysj6CgUTccc1zHrBBQ43eoTMN301OJSrD3
	 apQ9+k8HjIjeHgPvFJrdJMWRPGctSFMuwtG4YJgTNt86FohRDQ4ENpGUAU9pAwgsGXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470207;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Type:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=uhi5vjrubpXVry8qF9/9Vzw+w2C0xPxR7cHJeTfQbVc=;
	b=zLaco30VF8T5a0UKPy9PPzUIV0Ywea0RhOoT6dlFQufuKUOXs8NHKmEZDzojb/FMNaTo
	 IrL+YalKpXJyl30OtDqWJlX5VpM79RhFaWhmdIQRxvEm4/NaYiBSG79+IiKVNggii97bz
	 Xa/g9XDdq7/dSuLtsv1Vvpw3pYF5oVTSlvv8XNejlntg6QXV+0nvkPZJSm0odhHsDKVfp
	 SeDsttMhEpcdzFIpyXMNxHfmMycRYYSs/s9j45KZCyf94V9qZENfSvsNhW2ZXoPt7D+Uu
	 c7pKNq0bPt+VzXHPT4DaBthEFmiJ4oGOYbYfU7olI3lcgK8L9VHpqiK1/nLYSH0d/LA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.134
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2134.outbound.protection.partner.outlook.cn [139.219.146.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1B1606A323;
	Thu, 12 Nov 2026 07:56:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D1B1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5JQQbHTv4HN8Re91oKz4IsHTozog0DCc8rp5q5pq7rq2p7TQoNvabeJGfvTpDvfgnnvRZ0f0sxq1FcwBvnUatuA7IBK0FFMtV+sgBYkNZNcwObvmY3BBAzAwTE5zoOhkDTuX3DrnYZhTh7SIHRqeVMa9Xj5RHjAyTJzbpWA7E5t9ptf+00WDkDT49xtUys+bdieFFF0aDy/am9oic3DYZtV4ArUAcfUHYw36SnkFhne8bAHiI24YgrNMY5C5RdaSBcWpyLe6CFR891LZ3y5utBgWgRcOGlH0/CNZj6H/G6g99ftDPb+l9WceARWF+pmSHd5Ulmdujms1pJDqjqYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhi5vjrubpXVry8qF9/9Vzw+w2C0xPxR7cHJeTfQbVc=;
 b=RcYWQfYPiEeOMDK8gttW2CwCK0x2I6QpkportMhtv0CsSsuiVsduSQyY95rQ0owijN1NsT8tAWiHLl95J9toUOF+/ifGGNhZ4UngpAe1r49qtJeLOfQ5bnrUCjn+eqsEJOVwo0cNZBIxJtzo+R0oDnMvpKswDQpm1PNZzC30bCAFScx9Tq8PzN967nywRa+Wm5A0+k7tYBcr9RrmsgzZiXeQlENgIC/gqPqIYTg6PPNLkCQdtfosVkzazS55GHWgmcFA8+SfQYL9aF1TWeV18pZCZLzLav2/df9Wk2UPipz1mPscxGmq1wW0toqSeYSHUFLl8ll2dxAXEKRx6UTa5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::7) by ZQ0PR01MB0999.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 07:56:26 +0000
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 ([fe80::d777:e23a:d111:5fa1]) by
 ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn ([fe80::d777:e23a:d111:5fa1%6])
 with mapi id 15.21.0615.009; Thu, 12 Nov 2026 07:56:26 +0000
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
Subject: [PATCH v4 2/4] scsi: ufs: amd-versal2: Make PHY register DME attribute tables per-call
Date: Thu, 12 Nov 2026 15:56:14 +0800
Message-Id: <20261112075616.118436-3-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20261112075616.118436-1-minda.chen@starfivetech.com>
References: <20261112075616.118436-1-minda.chen@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: 82925fa1-36db-479d-6a24-08df4092740d
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|52116014|366016|1800799024|921020|38350700014|56012099006|10067099003|261021121427099003|261021123027099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9zPhQPXhcSKZqejyofvyhsirN0W0dNowkxlJV6em18svMUNeXBfQpWdTz+GGxAYd7OvTuS3ZGLuzkgJ1KlSm2RAeGaCOVQ3isPiZx96mWBxqAMlim9IEON2sxL/yFPcNy5d1C5vPTefmyKrIFOEAKRMVmomOmUxtM1jWPkfgeYog5EayOWt0C+4xXS/kv71F99JcEOoITTCnkoNOWgs7/bKh/PxiUk4u8ilQg4MaBcAT+2PE5cy5FoKsdpGS2EP3XZNRTetKzg4xmGK9/oVeds6CqvAa9TsNYW8qss+f2I2Rt6fDrETpg66157a0ZuysGpGxVpBV1sCqeJEgDtdVk3peLvzHdgImfHOTtJESy5joyaGO7lnntKbAUBS8Z+3s0lHLAB+SAf22fz5xDOUdDWksz1IhHWKUY9hYiKQcaF8mh/ZMrc7abXu3oG8Yar8GjZVA+Z6UxiIBlnOfBY7VP/AtPYe0h7qcAPSHYpJkdGI20jcbo//fMEtrg8v2Cp7/ddSuNrlM+4S53TciyyKabb26zF+bQICImvQEuQsmEZV6XBd+QrCQcHFGfTHaiEsqBGDXgZ7iHQr2ahNmOs2gRw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(52116014)(366016)(1800799024)(921020)(38350700014)(56012099006)(10067099003)(261021121427099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AIsDGPc0Pu+Mti99l5oR1I8JGUsD7h1JJjSuUXw4HhL/9ICCpFrUOdgKVDtr?=
 =?us-ascii?Q?IU6mzCUXZ397rOMF2nlh/d7d3T/St8WqkioWditXp1W5JSa1lHg9F31feAHp?=
 =?us-ascii?Q?SmonmdukhqpD4bl5RMuSmhdlAS7iXtwZfcNnVRs1WDvr+XhdGkyihHnJwj8d?=
 =?us-ascii?Q?AWplvJEonNlvt4ifHIaMPrNh0GhRQHVANZZkbjyVP/GLW4Wf4Jj+acjXs1SL?=
 =?us-ascii?Q?WixXH1y7g5CS8cvkudMpwnkjhCTa59w+uN4uYBRZFVH8Br/CR/08uC3PGQOU?=
 =?us-ascii?Q?6YkSMrgAe8efn8e3grB6YH8AGp0zu3Lz++j/0whqg/8Kg3U+CDM9U43PRREH?=
 =?us-ascii?Q?Lu7FPTp+g5FAJNyHsDt89njuHxqN74i5fwOxcTNQ/udRK6+L/d1ZN1TDbj1P?=
 =?us-ascii?Q?hihY2VvRnU8WDoJpim6IE44ap5CNERddJVx5onURn6Kg7xH97TCLMqKxBJn9?=
 =?us-ascii?Q?FIKAkPwYcVvbLhMuSfsd61eqZl3uU69EPVlXVwatyGNLOAuGst+L+/fN4bBj?=
 =?us-ascii?Q?hGm8//7HMrkYNKMOr/+YKt8b6DVgGMsdUwvGjrUzEzDYKo6g61mOY1tjL6wQ?=
 =?us-ascii?Q?8iEDRiaaGD1nQNSppEKuHh9Q7Ixl89g3KUO5qKAITYEAbeNmAS+AW3XryB8T?=
 =?us-ascii?Q?dhaqWYS8SbH9SVPuIJz1x/bBQek1HVBr4bW/fiD9qmd+9Pcco/oI0kFEH3n/?=
 =?us-ascii?Q?N8TAeEKsjEPs90Myd/oUIBqDgsUfW+QY9lX+3On+EErDMvabozfnY0TQGTP7?=
 =?us-ascii?Q?FGp8vYzTUg61IDvP2NKfsGiKFBB1m3JV/CWxNkWASTBbrwbDPUPPp9EFLubZ?=
 =?us-ascii?Q?XP9+LBrLrC0pIu32wZHSz2zDFxnmww/uy33WnAtjOiZquWXUDYCFtbv4ZeD6?=
 =?us-ascii?Q?hUm0ky5W86oOp3nxvtZfzNS83esh+iuZUMyRq3ql0R0iqBQGjpnbeMEjezqa?=
 =?us-ascii?Q?x6HAJ1731nDmbVs3P395VT3VXVz1gTwHxGHYjYip0X0Od53AV5iT1u/AOl8O?=
 =?us-ascii?Q?ZXUF5+hhg+j9yhJssfHnHj5RgnZxydOS4bitAOQV4q59pe7cZDt4WMzZBoLW?=
 =?us-ascii?Q?kCWEjTGXHOmvYrA5q3X7gWQD5gCjjVmrvvd8VGo2JWYga/1B/mSEC5okYMmU?=
 =?us-ascii?Q?4XN65/Y0WTgM8nLn1vcZ7nlPvImAbUf7YfMU5JX2zyRPrvgOr/1VyU3LkMb2?=
 =?us-ascii?Q?j3dFwI85OvzhL0J7ervfUuBQNRO5QMr3zeIr1PDSveJgtBYEzanZx+X08H/x?=
 =?us-ascii?Q?pt/WMayje/8G7niP3tpIao6TVbPcuaCAOpwmZIBRRlhHSOkijEXu4/2J5NTJ?=
 =?us-ascii?Q?cd2A+uHhSti9sQeWnBJX29mFBiEi9NK4VqVnMMpEpMvqtT/NbvEfM7rqZsfw?=
 =?us-ascii?Q?DK6FXbOW3mfPK90/JAPdMx3t08jJhKo+pTpqh6u63xGGhOd7D4co+TNXPDzx?=
 =?us-ascii?Q?LZLgqnrPq0ZIpBz3yE3Cd1eCCcUYQPwmQp4KcXII7SSWmiKG04eZaFfqIBH0?=
 =?us-ascii?Q?z3iYY/lmGba8xr+ik2h2nNE118JbkO/qYKnnTZez+p+SGnqumCLx04M5uqEb?=
 =?us-ascii?Q?vrq4lxVfboM1Ze+MgO9/qWuRhQkHB1pxZK81g5isfZzU+Q6OlWwkzEZWSSCw?=
 =?us-ascii?Q?LVqnYrO+DujpoE/ySAGUlIa+hUe7zQTsDkpNhC7xgFgvefRPc3jQ3N/4h/gU?=
 =?us-ascii?Q?ABIvlT5x7+IwJYIopNNpTd+x8vR+t4kiFL26I9FIrUA4yK+2HSpotlu43CHL?=
 =?us-ascii?Q?OusUqTgHodKi+Czi00ZAulU0q4i8mo8=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82925fa1-36db-479d-6a24-08df4092740d
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 07:56:26.7320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cn4KR7lajS3U3O1HWG04s7bsN1rxcw0WZ1fldsqHk3IfcaJYvpEl9d1Hlt/qBzw+RKXDd29L3GX0dwGq2UO1dy098XxNqICxrtPCETVPHFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0999

ufs_versal2_phy_reg_write() and ufs_versal2_phy_reg_read() keep their
DME attribute tables in static, writable arrays and patch the address
and value into them on every call. This is not safe once more than one
host instance uses the helpers concurrently.

Build the tables on the stack and make them const, in preparation for
moving the helpers to the common DWC code.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index dff0c2c95486..18a5504279e6 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -45,20 +45,15 @@ struct ufs_versal2_host {
 
 static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
 {
-	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
+	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB), (u8)val, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB), (u8)(val >> 8), DME_LOCAL },
 		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
 		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
 	};
 
-	phy_write_attrs[0].mib_val = (u8)addr;
-	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
-	phy_write_attrs[2].mib_val = (u8)val;
-	phy_write_attrs[3].mib_val = (u8)(val >> 8);
-
 	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
 }
 
@@ -66,16 +61,13 @@ static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
 {
 	u32 mib_val;
 	int ret;
-	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
-		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
-		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
+	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
 		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
 		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
 	};
 
-	phy_read_attrs[0].mib_val = (u8)addr;
-	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
-
 	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
 	if (ret)
 		return ret;
-- 
2.17.1

