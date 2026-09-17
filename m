Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8758C4B0E34;
	Thu, 17 Sep 2026 09:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636590; cv=fail; b=ZH9BfJ83L9Y5JaP00RR95tFjm0+nGGHANUrOLdwyc2V//h0xhcHqA4ZzXrFO5+K42Dgkk+WpB0pMB390i+884EFi15nDEhmk9bUJnBCBw9ViBN3g0mNTRHbVFo9Bt1mn+38C23QiOTgI202sn4EoQVBu7nrl8mW1AytnfMrUEX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636590; c=relaxed/simple;
	bh=SlPckDvgmCgHI3K96wXmE3PZMKP1GnJCHi/dHGpHhM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PIuFxgBQRUcCcu67V7js2pEa1nh36oYJfS0bUvhsImMrdIM8ED1pHub923ZbMhbEJKMZvS9D6otCcAxDy2uAHpBDi8bJTgKhv0D814Jk7rz/CUwi+6eVF/XijmaVrPjC211FMVyngCesaxFfcC80TceVoy4J0R3qK/aDlBf0osQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=OlpH1REh; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="OlpH1REh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oxpd3k6c8SP0c4TiclgqIqpyt4Bnvej0E82obE7+8rObFfsDrlz08KU1LFcbGVMyyas8vXkeqgzfug0YjgePMwJRmEe03Nm7eN8hvtzOPdWKmS3ptgdsXctE72dQl+EGUkDLRgQe7+XEftQ5IQ/j6Dq+20Ti48j76/nAI/6LzZuPAdh8IkrPvW1ZkAWHqu9OqncJkd7BdjXACLDCL6qHmld4fugeBwHspbQPV/b2ZD/fAEp8R89Rmt2TARSFQI43dj18/Tu0e8VI0XX2GzBcvmt5qolxedK2iakZeGy+oMB71SWtNgzguZc0WuuWVaPKxFM+kMGvKSWwhHxhS6m8Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=MuMDkydae5VO6Zac/eoKDQheCJ0t0Vul3s3O3TapLRm5aMBhdX4rPYY6gTSO2etKiFtslI1fbq6uMCAriF6Bus1lGgvFE0DpEFXS7ThjLX+DNfs7Gl+td+zyYPKIC127qX/3Ub0x9Z1hWJWsDfnqUOiyQZ5rNdhEkbgx6jDckBbvcX9HDRRxJnG7FNJUDCEmndX5YYyFx6Qpmx48eBGr/s97dXpk8FGnQPdphE7CAYUOgfFSb67d8bBw0BAMDFV+Zn8pVdF8saLxqXMv+nUamx73a/fbDpVQbUiCI1B2lmhFnVqfkZqnIzvJP7ditDzZ09Od2oPTz4KsVj/0uVi2KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=OlpH1REhcjJ2uqzD8ZAWE5d4s3v9UprNMIiREVD/pkxQeD4pTTokkPskWb//X8NYhgPdPjubVkiVR0BUf6NVRncJZcmw5Um9il7lFeBOhV4qJu733WWbaetbAOzYvlhGZ8AzSlTLXSHTKoC+wH4Bq3Eo3TIs+zP6NS+UtmQwRihyf0U1Y94AgCsAQdB3qde92wN7aPq+N7SAi9/DnYKMCQbKWjrPsWnhv9qQporpIgmphmuKQxd7r8pmldeu2O/HMHIYHaxfLs1NbSjQnr1K18xF2M4MOHAtjniFP8TwXFai5XzElkPTlP4x8NINy2664kHLX2bO/ED89ksRVfoP/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:16:18 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:17 +0000
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
	Pedro Sousa <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v4 10/11] arm64: dts: freescale: s32n79-rdb: Enable UFS
Date: Thu, 17 Sep 2026 11:15:54 +0200
Message-ID: <20260917091555.1443076-11-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0148.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::15) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e62d33-6e14-4088-c86b-08df149c5459
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 2Hl7NQmG4/FuVSvR25JRQmLHOiKx4Itu7oMBqcs4HHsEpewuWjkIEhB+P4xVznKek35qwK4nu2SpS447ou2hhn65i5g6HbsPaJx9XTN4sAW0tL02rlG04QRoq7TZan6cJC4x6rNGawFUKu7b21luSr8j6WLf+TXb3TDHnzTBMMRbDyR3+s4Z4+GjnTa0AGNl8cwnyXZoyb2hUMvz5PIqZXmNeW/1cKjNEhmnLDPLmO3RRrFUtcJfBV3SziATjj2/iJ74vwjI5Wcm1sY1y1X7TZBGS+h5fcomNvullzRjL6f6G4CPq9x7qLqNopqs5FfFVBmxakRPBhDC6y8+hDNytpUU7f0ArNDT4nJO1khZHsjC162ETIiAgm7Npsix/gurreuZP5bGdwF1qsEfmb6HI8mKzaeC7spe15wQf2YHAhg9UR7sERcWaR2oaSl3T72K1A20jW0hOQiz0zu1GCMD/aJmOM3XGx8dVoHyujjxkxRwSX6JKh4mPF/wIw50A53QWhLuUsxe7pCb3JdgUi+K9CXLhRgOC1WZMym39lcydUBLo126SIK9So2NEVrTyzqhakTiDts4dgrVcmEzym7O+ycwWnS1W+kdvxcs+wc53ETnUBSd/8RoJVfqRKR6S8GcCSYK1iVd9cJ9Ws7YIn3ym1xIbl01tcBkZKS7IZxYgwlioefdaDHY97H4lTUrMwNUTZjbUhuLyFIAOkdhyglrzg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WUJ5WmtrRTFUSE9WaGZwMndndlhPZ1NBUnRMU3N2TVQ3dk11bmxCbDI5dVVR?=
 =?utf-8?B?alFMSGxGclBmRWNJamtYSUs4Qi9rQ2lNbXErYW40RElrWlFuQ1NsVHhDREhw?=
 =?utf-8?B?K3VxRXIyR0xhL1BsMEh1NkVEUUhsZmMxYlpXRHhUY1ZaTldaelJBRkxXQU93?=
 =?utf-8?B?ZVBmeHRhU2RpR0xwYUlUYnZTK0FXMEdoTkNaUUxoaTNqb1JCdXNxY2xGbnF0?=
 =?utf-8?B?YnVhM2RERWR4dW5zRUsyemFQYld4aHh6aTk0TG1nRzB0MEJ1d25CZUNnb3pk?=
 =?utf-8?B?a0dPWXIybkxmVDg0bm5EcnRPMnBZQTR4elI5dGZuM0FZQlFLRlBySmcxWmFN?=
 =?utf-8?B?ZHlHTkNJWEFrU2FjcmhheHAwNmFPd2x5SVEycE1peWVqektEYXFpNWdubmZo?=
 =?utf-8?B?eWVpQk8za3NFd0FHRGNZRUp6VWZPdyt3dnQrb3g1UVV5VmpZRVZuTkU5UWtw?=
 =?utf-8?B?U2ZrLzBua2MxWUNGMXFKSm1wY01ha2RqU2J1ckZEMjM0QzBidXRlMU9rZmhn?=
 =?utf-8?B?WlB4QmlRbWZKd1pza1F4NmJBeW1JNlB2eU4wWW5ZN1UzOXBtSnFaNG9MNHBh?=
 =?utf-8?B?SHlTeWdSUUpuMkg3aVVqbmpRUnpFcmxwU3k2RFhCNHM1ZTdLcHE0eElvcjcz?=
 =?utf-8?B?bTNBZEIvZWk0NzQ3RkFtS3NtYVlTcjY4TVBSVUFsM1NtZS8zVWVhSENyNGg4?=
 =?utf-8?B?aURNUFdseE1KVU5tN3dRTC94aDBnQUtveGhoT2xvZmtxeW1vS0VrdERzR3o5?=
 =?utf-8?B?Z0xwakJUcXp1am1NUDZsN3UyMUpuL1crQk5vSFFPc1BKaGJjR1owamxpZHlG?=
 =?utf-8?B?OEFDVHc0bWZMSENBT1R0Z3Z2bzRqTlp4Mk9GMStYSUpkWkNaMWkrUlhCN1BC?=
 =?utf-8?B?ZysxWlBNOUxzZ0sycUVGRStWRjU0N3R3Mi9iZ0xOODN0N21JM2JJcTNBQXFI?=
 =?utf-8?B?RG53cWw1SWlMRU04TytUVzVIWUFUdVN1Z1ZOaDJaMGN3MmNQWXlKTGJRcjYy?=
 =?utf-8?B?ZlB2eWxVMDRJYVFDZHY0KzdkVUZiR3o5QndQa0JUcDlDTEhScWVpUVNPR3Vy?=
 =?utf-8?B?bjRocXo5aTlCY2k0aUJuU1AvTFIvZ0lDelRCeU5WUmpPQURkNnFVQjBFS2lH?=
 =?utf-8?B?Z3doVnlKVTl0cUVEYmNYaXViQVRzTS9LVDkrSHdzS0lQRWVqZFhrckt0SENW?=
 =?utf-8?B?TndvalZ3MnV5WVBkbGVqemlQZ3dnWExkRzNrTnJJcFlhcWlUOVdkeXhBL1or?=
 =?utf-8?B?cW9LYmlQUkZzRVJRem9Ob0luSjNGb2dTVWRNNXlDRjFSR29pTUVDSVNwODFD?=
 =?utf-8?B?em83cG5lZFpoTy9IdFBvTkpDREQ4Y2pxSW5maE5zRGJSVE02OWZuNXBRQlpR?=
 =?utf-8?B?YUVwTTRUdjI0R1oxTWJlNDlnZFgwYzh6TGp0UDl1YW5BU2xWS1BMemRNZExL?=
 =?utf-8?B?MFJ2cks0QzYzdjdnU1hlQXNKNGFPNks2SENUWUdKUlMyYk5CeDkrMFFKbVpO?=
 =?utf-8?B?OU44eC9nMExHejdKbnhPbnNhNVV1UG9nUjh1dzdUdklrSGZtc0hkOUZ3VHE2?=
 =?utf-8?B?dlBzNEFadUFsa2xCWU5NVVIrZXA5MDRjOCtVTGc4QUVDZ09nNkQ2SjRSYzNp?=
 =?utf-8?B?aVBqc2x0cmJnUE5ySXZvYklFVmJuQ1J3d092SjQyaWJTQ2h1Z21tVXlpcU12?=
 =?utf-8?B?QUgxdGNQUXJDSExwUzF1TnpiRUVJYlNBcEUrLzJqZDErN2dvUG5DNWtuMFpS?=
 =?utf-8?B?dnRFQkxUNkl1bGZhMWRFNHY4OWlGUXZNOWExeW5lMWx0SHI0UjUwU1MxUk9F?=
 =?utf-8?B?OEs0STVPK0ZYQTBLYU1yd0pQV1BTZkRyd0U2d2RLR0Z2SUpEaE5OWGFPLzRJ?=
 =?utf-8?B?c1AxaDFjR2RwSWhXclZxT2Z2c3V5OW1NWGtnZ0VMbWpjbVlJZ2NoZ2xRS3gr?=
 =?utf-8?B?U05KWXZKSEIyc1NocHlOUzhvTUs1RmJQdFlqRExwZnllangvTjMrY0Q4cHkw?=
 =?utf-8?B?aEZtbjU3b0ZyY21DYkdycVh4dWljOWZXNVdxQkYwUzVKWURZQVZDOXJ6Qlo2?=
 =?utf-8?B?MTFVbmFZVFlBMWpnaHdsOHo4aXZVSEdsdHd1eDdMK2I1S3V5UG1sNGdZRjlr?=
 =?utf-8?B?Mm9ZelgyN1huaTFEdkpEb3lDMUsvYnVEcFRvWDFHVEc2N1RBUnZXV3dMQkxw?=
 =?utf-8?B?WkM4MytvcjZvWkNiTGtUSTRKN1dCTjE4SktaMmExbk4vZjQyRjFlKzVuOTUv?=
 =?utf-8?B?YWdBdy9WYmdNLytJU1FyY3JOMjdCc0VFVmkwcFJPMis4VG42OERtVnZwWW1m?=
 =?utf-8?B?amZseURORm1jMWhuVEs1dURUekJia05KY1BUSWo3ejBHSnFXNUkzOGdLREh3?=
 =?utf-8?Q?Lo/y7xkGanouncpw=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e62d33-6e14-4088-c86b-08df149c5459
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:17.3252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThAUOi7Ik2bjcBq7werXWKbxOHR3BJ+WCkpmzHXtMJp25kgXfc6Cx+UfMVz6bdAk0jjYTiQtl2E+6KhH8IJavw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

Enable the UFS host controller on the S32N79 RDB and configure it for
two lanes per direction.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
index 1feccd61258e..38c5699e6d54 100644
--- a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
@@ -63,6 +63,11 @@ &uart7 {
 	status = "okay";
 };
 
+&ufshc {
+	lanes-per-direction = <2>;
+	status = "okay";
+};
+
 &usdhc0 {
 	disable-wp;
 	no-sdio;
-- 
2.43.0

