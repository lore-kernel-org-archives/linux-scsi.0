Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013065.outbound.protection.outlook.com [40.107.159.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0973D4B405D;
	Fri, 25 Sep 2026 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347039; cv=fail; b=o/9g3opc2wMIhpm4H8DrthTdgZnhy6hP9rXffZnDjkRjYLNmEtFoaBqjTvBdSnyciknoZTAQzgnWMbZtwDbD7oRAQ26YBPYNBRvcO2m4Jl3lIu91rZDmOfnY+j3P5GZauta6dH0lN/+mart8B7nZE/VEmbr9Sk6uCEHrjLeWa6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347039; c=relaxed/simple;
	bh=Gzlh2+HUuz6t4sQYdpgSTd87AHMOxQytTKDCMSPQmkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ePG3uS+10EjktBOvwBL5OiMD7rKdRBGg3LXatyE/UgXQcopHGIzuFQnd++fsZ4ro7w1GTnZ0lzvovGC0t8dwn3HqDfeCL77bbK9l8YJ7IhVytxp6K3FFnGZMrs7WDzWnO/Kl7t7p4Z3wmSXvmXdjkLykCaNBk8riugJG/YTdcxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=rRZJliGT; arc=fail smtp.client-ip=40.107.159.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="rRZJliGT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJ6q4OUwlGAFStybal9nXdzJDW5wdsxhyzg/veWdVglAVfKWlc2Cnf6Xk6ylqzSP1b9x/8wOHznFw1Cg3QZ+ZTEIhvhhYk5BQZk2ahUDqsDz6+Slc/mUpZEJlBTaUWt4TUa5ErvpPdiAP9HBrdR1eAJ9gwVeK+bDtmEI6iUY9FfcgpQieDtigcDxa44/0LVhXy45V8q6HXLuaRng+S56Rs/tSYl91WbNQvPva9++IVpkB9pJ4KbdQ3b82JMj/U/5gT/FdLQZUvv1EIdBnNsLsuVxqnX+Kz18x9RO4m9fOaqtOuujeuUn7pH/OWEeQG3zoyylRXCJ9+fzMQf2/sJ09A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ave/1sHBXSjhiWUhM8uokopPQrep44H0HHJpXF8zpR0=;
 b=g0zkm3gW2r6posDMvYauP5rDzwmUjSG5Q2FvXK3Gxk1tliq1Ii7Vnad5G1WSlxrOD1QzH7qqQ0YtSaj8wIpDWglfK464xVuEVHXSqdsB5TnaadReJwTFyv5aIc3EBTR84/BDEgb6eTphdAH2EvAzC7AzFuoaFnt0kUq9XmwNOc7cf7/GmiOy+z7BEviX9iG8ZoIussuWiI/OZoI3LlwJO2QDPhLa3xp7576o8YUe0yGLl7++Im3CBYs84CjPJk99EBBCWC8oH7Tkkb7aYR8303cswguJVauta3prJNMcNA8Vivi5tyVOIQw7HJRn0Nrvok7x9vXZvWVin/yU5AI81w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ave/1sHBXSjhiWUhM8uokopPQrep44H0HHJpXF8zpR0=;
 b=rRZJliGTJW1fznTw19pwEvHXDuwqZqzE67TAYm89Hrk3HdYTUEBUAn9P2zAuQFCTpUK2RIR8+S3wM9VIWSklo2WjJ7165iw0hI+ttLsslghgPHsyjQoMt7fhcPwYhJuiP/TYl+OtWVw68RwUBru1+HJ8J1jH23OzR/A8qPOZ0QXZ5Do0vgkU02PPRo7MXgK36YqkYVfL1BDswrFtYzmRzMYINzydckYJZO3mVJ/Bnht6Xt6DHTIiM7wvzsuBcpVoNmNE34/F9eeQ7D3S30/PW8gv06WFuiK9yiohnwaqRPqzKTkGHMfZWAXbomVzA6IWcsyE9T5lVd9BKuPwlTcdAg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by BR2PR04MB800621.eurprd04.prod.outlook.com
 (2603:10a6:2c8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:36:07 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:36:07 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v6 12/12] MAINTAINERS: Add NXP S32N7 UFS host controller entry
Date: Fri, 25 Sep 2026 16:35:34 +0200
Message-ID: <20260925143534.3298540-13-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|BR2PR04MB800621:EE_
X-MS-Office365-Filtering-Correlation-Id: 065295ea-8f48-4bc4-7019-08df1b1255e3
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|19092799006|10067099003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 Mv3Uudf7Q5kXukMzv/cqXpHoXvWAz4UUVSye7rDQ2uR+xAu1NMBzU8ggTM4pmfunC+p8C/ERzJfR2uBcvf6VnpqJZ7w7iefL4lfhDITIKkmgRKs1uKMj1H5M1yNCMJEA/AO1dADmh62LqUdIdvC6L9iKeZS3umvVkGCgZ3ya6PX/0Z9TZr/mMtxae0H/ax1Hrm4aKYvqz+voCcAAW7wgFMMGn+eqx6XwyvEI04iatszqvQZPIV1lhDmAaGVnea6tkRJv0QZJZt4oRS21XQU/u7mcCfuAaZdUFVjWWPTd1Bl+3AwaJSTWRXC/qsiRHA3jdXx/rzfeayiuaxgydJO6GEMTKiR7yABe742xDbZnA1i0Dck09sCm/F2GXWcn3+IMcmj/y/B0RXgoDM0QeTzzxShmmh5wwkxzMaFB/+VNiqr+hZqDMsfrlrLYUvdQlcH/YHy9J9IvHBle9fbqKi28V9rL+5RDQgoI7hld4ZmlcUvdpbp4FITJevZCVne+82b9PwmhGzYl0dr6f1Pw3y0SQNKc17A+z7NuPkkiRGfAmaBK9r/2yHJT6gJg3O2MgpuPg/y3WLO9ak8FbC96BaGK72NQXYkHpheqndByI/t8Hato6aFbLoTR9WQ/RR1hHtiyxfkK45Li5W3+3HemINIiSbcaCz7tIT0rGVg2TxVY+01QaZSl7SGM4tgob0F13R5iPwI9AYbl0FsN3Z5HUt3eUQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(19092799006)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SDN5Yktna1E1MURORUZ3cUJoWk84MzhnSWdXMEVRbHdvOTJ0QktJMEU1YVpJ?=
 =?utf-8?B?NzBsRktybjBabWhGa1BpQk5CRmtkZ1NKM3NxS2U3MnoydG8zTVBjdFRRM1lv?=
 =?utf-8?B?MHpPakFtZ3VLODNrZ05sUTN2VHZUZlBzOUl0ZWNDNmpJM09keG5mUU5rS2gy?=
 =?utf-8?B?UnRFL2RIYmhTYVVzMXhNZ1pjVU5UenYxOVFFbU5aRDJ3MnRmeXNTdzMvMEhk?=
 =?utf-8?B?ME0zWFpJbXFac1cyUWN6ekRCZkZKV3VhOVRjeW90RkdsVkhFMElMTXZFVkk4?=
 =?utf-8?B?d2FCMEhmdEJObW1xR3JxUUUxMU0vazV4VnJBTlhRYmlCS2ZOL09yS3pxc2I2?=
 =?utf-8?B?UU56YW1oZEdibCtON01GT1FraGR1Ty85MW9PUm42WDE2R05idW5sOFowU0dO?=
 =?utf-8?B?SlMrTjdEdHAyNTJkRG9EZ01HQ3E3eVJuMWlJL0kwdDJxMjhaVmhUTE5OSnJQ?=
 =?utf-8?B?RDVTNkFoaldDVWJnMytIb1c2bk5uNmhva3g4cWFTcmRPczQxVjdJeWZnQjRq?=
 =?utf-8?B?Ti9abjY2S1p0ZGhKSmRFNVNBZ3V4UzNocEZ1QnNrTHh0Y3NyejROeDJXV1ND?=
 =?utf-8?B?cm8xZDI0NWZWUE05MVErVWFLS0pjWEZyS3RhVi9vWUN2a2p2eFNGVFdLdTJj?=
 =?utf-8?B?ZzhtOTVjSGlZMGI5NmhRcWViQi9vcU04Tm9pZlhZVFJaYUJFd0pGUXg5WVNn?=
 =?utf-8?B?UGRzLzlPY05GMzZId2E0Mm95ZGQ5RitvbGxkZGJLYXFDR1k0Z3BHTDg5YmhG?=
 =?utf-8?B?S3E4V0I2ZUoxcFJtUTFNY0VZcGhBWm1TTlVKN25qU2t3Q3VHVkt3V1FFcVBM?=
 =?utf-8?B?c2tWQzJnUnVySUJEVVQ3MTcwUVFKeEVlTzl3WWdraE5DNGJVSGxIUUw4TTQw?=
 =?utf-8?B?L2JPcENSYmtqNWdkM0gzNWM4dGhxN3c5RWZsMXhhU0tCbU02aUg2QTJkdWU1?=
 =?utf-8?B?OEkvVG1KdWRPMGFGalRpQUc4ODdmUUtxWkZJd2laVXFaQStSVU45V2V4UlVv?=
 =?utf-8?B?dUQ1REY5UURsTXI3cy9FVVpHamlIektqTVhjNDZnb2tqTkdMa3lobG1wKzIv?=
 =?utf-8?B?K05zV0lRVVdPRzc5TFBnSDVMSnRaVU1wanU5V1JGbDNoRGpuSW9KcEJKVGpP?=
 =?utf-8?B?VjBIZjU1aWcwRWNBSjhxVlFRVXZMNCtZeVZJYzVzeDZ0cEFXa3plTi9FQW9I?=
 =?utf-8?B?V05ZOFpBR2FBSVhXY1F2TXRnY0hJMS9rVHg5TkJ3bFE1L3JTTFgycFRYRXN3?=
 =?utf-8?B?RHhaNU1MMWJaNENNbUtmN3g0TzdraVJxOWhhU045ZnFZeTh1Mk9Nc2ZuWWN5?=
 =?utf-8?B?djY3ZVNpSjQxOGJ0RG1QUGZCbmo4TmNpdE5KaTR3aFdvSGlLMWtGVmdNcTR5?=
 =?utf-8?B?T2YzZmJadFU3TUJhY0xqaXF0eWVWTkpzSGpSTkg3NWl0VnlFSG15WktSMmdn?=
 =?utf-8?B?ZTlkTmFLVWNCMUIzV256UjRMVnFtZjErNFRjajlwSXpKdVZoMGtwVFBvbDJu?=
 =?utf-8?B?Y3NLRGJLYVFsMXZPVkZrTWhESkZ5aEpPc0FnUWVkRzBWT0JwYkVwMmJoOWph?=
 =?utf-8?B?azZmU2I2cWQ2RzdUVGV4eGc2eUppNWlPWXNleGp5bFc4QkFpVnV5Rkp3N2ox?=
 =?utf-8?B?SElBV1VIUWl3K2N5QnZWZk1QRGt6TTZQaUZYTThXZThieHJOTWRQLzY2MlhJ?=
 =?utf-8?B?SDJsNE1NQVFxeTcyOUE1NlNGY3oxc2ZRNU9oNnZzMmxDdGRhM0YzdzRxLzdW?=
 =?utf-8?B?QXNsLzJMdmhwdVFXMzMyMUNiaW9JeTRDakZqY1FqM2w4c3E1WE1IbHk2Tk45?=
 =?utf-8?B?aGNwK3FsYlBIaDlUSjU0Vk9YWjB1QTl0YU13QkRNVkl6Q0o2OGEvYUtSREww?=
 =?utf-8?B?dWtYTytoczA5SVlySnlVRFA1KzBYVnpvSHphRmhQMXdJZUdhS2swbzUwQnZo?=
 =?utf-8?B?a0hMNXRNNktiL1I0bXhyNW1TVGx0S3dCUXRWVklTb3hSZGRWNGFURkt3aHd3?=
 =?utf-8?B?cUI3ZlZ3QkpMWFdMdUJDVnJjYU5KTGM3Ni8vQ3ZpOElwcjhsUjFabFlCZ002?=
 =?utf-8?B?ckExL09CRUlLZ1lweVBHOXVWdTEwZE41Z3M2Tjh0MFZkWFFacUpFWjRDVFJC?=
 =?utf-8?B?STNMT1FrM2M0MnBUTEx5SHloYktOL28rd1M5WjBUUWJIbHVIb3pVd2xUb3NU?=
 =?utf-8?B?QjdGUXpZaThLMSt2NEFQekZsNG9EbmdjUkppU2c1cDFvekVQRGJqb1lRV29o?=
 =?utf-8?B?VFFpcDlmSEd3NHhOVjliTnZUdmZMdElXb2dJVHJrOGk5RllxclRRbFlsWHFj?=
 =?utf-8?B?OERlVis2dzJmeTFhcmtaaHMwUlBOS3o3bGRubU5XUDhQYkUzVkp0QT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065295ea-8f48-4bc4-7019-08df1b1255e3
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:36:07.5050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZ8l7TugcutVG3j8ZTDg05wm2TOEJpYFwbLaLSMdg0lFg5rvWgHWSJCuHaYiFLf5fi6OwCojydAwqBoz4X77Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR2PR04MB800621

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc3cae2e378b..6757d6af5dba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28097,6 +28097,14 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
+M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
+F:	drivers/ufs/host/ufs-nxp-s32n7.c
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.43.0

