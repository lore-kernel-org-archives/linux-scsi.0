Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011011.outbound.protection.outlook.com [52.101.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABDF4B8274;
	Tue, 29 Sep 2026 10:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676614; cv=fail; b=uVDzxVkJlZrFDmc7Eqp9Mxi3s5err6zBAxgQ9F5nCgTLFZdTvnzFEg/VLZOIwpx9j70iMiAygA5Sy1WfaoF9gO88q7RRU2t8CQ7Aa8xRztJcS8sIEIAyroUCJpl8nOhBSEwyW9wQfw7iMRGLo6GWyBoQZ7hzQNuiJEM0qWAB1kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676614; c=relaxed/simple;
	bh=tK6CG3Hg6D2uTLW+1yMejrs7AGjyWteHTo1EXzzKguA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hpBH7IbGo0gdzAw8cL298y1/9UcaourgJnCFvFrPN/5CcTo7+h8bEP1E/YION1rPcnBIfsAFPjn2KL2GyTZBsTCX8Z0ayyuXfkgvvn6yoTNfdbN3WQsZvouTVlCpdNU0URlOjzVTVswvA82PE2doA0Ouh6uzhEZAoOQh+Nzwaoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=nAZJaAbb; arc=fail smtp.client-ip=52.101.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="nAZJaAbb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQw+zkMkHJgD1A15j9/gT/oYPISEeUQDbcsBA3sl35bHtEEIF/DG3MP/NeMyIF8yYE2aOUU/xPv5HGx1XeBjtJAD/DdR8NHLAeHV7PGNQXB7CRgA+dweDyG0Eony3B3NgeUzp0omlQ8bG3r+R9LJ+djUV9kmqOySjC9chI86gQ+0yvBjvDYhUNLRSgEaX/LJUxLvT0Q98sav4oyk9Kix2qKPn1nmR1nUhYiRtitv/3WAuiAfsSb6mUv1Xj/pvrAz+4DoxU3LetWsiCp175QimBGDgDTd2J4JRUnH3f9/Qo1sJFtoJ3jVZHcle8MO5MP9lIEtSm5QdcPQzv2ZKuGF4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mt4MM2b+kEda7XeWiXcjklx11vtEoBsUUQ1dFr4um50=;
 b=SZ7Dnahq5cvMPTu0iotxsL6Yg0Lkg4WhQSYO4+EO4WtKJgflQWXI0DgQBkMKZJc82EJo5jDJ9DI1lh/HpIrJvq6CYcuL054oHU+/1jgykv0k1GDeoYGIXDkiJNOx9RjqA6t6O9/+f2mM2fxmTvTBGq0A/UuaHNebDUj2AS7MTfhnsScs8deuLwMq4voDMUeDAyHrldybgwP1kHKBOxqcYRo6R5HDY3ppWkl7Trqlz+wMHP9TxE5Cy+lorZHNebsBboizLEulMnrbLUxb/RT5r/ed0WR845SvP66itpD9m2QIrK+wn67zC4Uf96yoAoEElX/2omBIbcjjEsRg2HfLwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mt4MM2b+kEda7XeWiXcjklx11vtEoBsUUQ1dFr4um50=;
 b=nAZJaAbblojuQ8tzzNox0YA1hcUNrO+GzKeHZRAliKz37G+Au3SHGnK9rnUA1vGZkccVb8sQybF1iHDJ9HIFGcE11mV5ln6Xx4XRy7WUM9o4QjTocyxGhy89hlYgd17l3M2BNK5rzVbxAi8gcVhBnIP9Ml/NV5/16jE/6J4fJ8p2YkIWLlJfinAE4IxbPJYJhWweG/pyGh/KqAF9iB8e6WdlfRsWawLiIS1ikK2KDu1+ZBkOpr0GfNQUf8zigCVI5o3XffDo5MEH/5IQ/NrGNcukn1SrMmRySUWoaTez4THeYMbE7iwvFvmGvRHro7Dj7mPWRfy8WM44VWdGeJlDMw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:09:58 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:09:58 +0000
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
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>
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
Subject: [PATCH v7 01/12] scsi: ufs: dwc: Return a negative error if the link is down
Date: Tue, 29 Sep 2026 12:09:35 +0200
Message-ID: <20260929100946.693962-2-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0028.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI2PR04MB10595:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ed3a8b-808c-42ee-1c62-08df1e11d0f0
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 ID2A4coIdOvuYdTR48zZw9A4VEFUT8iF75GqKc3FOCPvyTxnZZSXIFlGD4XgrfeEqpB5/64BDgnibwv4FIh5b/DUQ37WQG26qBAcDvkCTZ4nMUpLeYW1cozMaaWde7sLTqUmtSEoJC46+5ipo4cgS+cFrLiAPl0ShYlBKMm1iylwPWfn22iQXR1jMDlNBpcz5MWaYJYvY0I6h2Mq+jwRWgBCY63RFEeFhXCfEQOloC1LP7I7LV28dWtH1Eu/HENCUNCQxfVoT3zzPyAOUkhIfnJMp4Di699NxFvDRBVvXHBmig/BcNjReKStQusLy3CheLl1ftMADhvwCRwDbxCcbPJC3aPR+Th6Qjh/138+0vWC2ghANuNpIHtOPU4zXrIC8tPS9AFFN0i1GdcnEnuOOOg03iMzTy5uFLKXTgZkVrB0tdIbA5D3oUUiJeODoPvB6KC8sNhsvYqNUsys4fhjSQGJ6kXYlwPC9/vq11OlhYXy6t6FiT/HPT7NcVPsBx1oQo58TZh86cg1nPviLIrRXCj3E81WSY5QdrjlMmppffp3qbZroJOqHVXLG5k+RyuLDaJsM+DQMOF2BBTwb6paWoqqbXYII07xNmZJx+h5J3D7vi/+ZAoYTZqOsx5a4mj1CRY/O1RlsEphhJ2moLTVe8c0I42i1oLBcJ8IalcB49C3bwUY24S38TWVcb3CdnGS2fHaVvkIxAA1YCKjSWyoFg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c1ZjNzdKb0NyVXVIbFZNbUNYN2VVS3VlNmNQOVcrT3dsT3JhMmtBdGRzenp4?=
 =?utf-8?B?Snh0YWtYSTFGZVFsOGVzYU5oTi9CT0pSejRDa29aa3g2WVJCQWtLWk44dEFD?=
 =?utf-8?B?cUdabXp2MHlENTczM2FVK3A5a3BobGk5YVE3cndQbXRrZjZZM0xTcyt3emZM?=
 =?utf-8?B?TG5MMDlhU3NDMnJqZkhFQWs3aFY0RnpGSFlGdzFITDFHdGFkdXNSUlRJREFL?=
 =?utf-8?B?dDlZZkFJSXo0VTByNnprVitZVFJlTlVkbkVoS2hwb3B3d25FaVFPekRaOHFz?=
 =?utf-8?B?b3AvN2lBNVdyUVNxUkk1NjBKczRiR0FWenV5VFFndE1DQWVWbHdoQXI4aWVL?=
 =?utf-8?B?dHJ5WmRuVTFSbStzb2VxRHdybVB6Y0FtWkJ5c1JYY2QwYVd2cDNNWkRQTXlm?=
 =?utf-8?B?MVVzdDdOWXg0cE9FM2FTRG5KTjhWUjc0TmE2VWtsbmt0d2tlV0dIZkRRR0FG?=
 =?utf-8?B?dkNpWmc3VjZHV2NDUHhtYW1NTHhQY0xFNVRtbXlZTFVCRE5UZWNTNkxPaFA3?=
 =?utf-8?B?OHJWSWxyN1dvaGZVL2ZSQ3NEQnVhUmM2SGRGaEZjRFBvWFlHT3pmc2tXZTVO?=
 =?utf-8?B?ZnZkN3BvRHUway9FcmZsdjFZdEl6emRJWWtuM0ZQcU1IVjExRkY4amZiQlBR?=
 =?utf-8?B?eGFMOU5nTU9RdG1wOFdLRVM2REJ2YzJhd3cxbUdESkVOUWpvdHd0UFBSTmx0?=
 =?utf-8?B?Ti96V2d4YkNmVFdnS2U1cUxHZnJ4eVRUVEN2ZC9lQWxLS3Y4TUJ2VHZjcC9W?=
 =?utf-8?B?YWZPV0VxZVErQUJ4MjlIRGZoRFlnaTlGSHhFM01yZjlTNnZ6TmgxZ3ZocnJh?=
 =?utf-8?B?ODFrRzhNMHNzNVIzRTVZdjBXaUdQRENlNjRiQXliWXZMN3dsVDdhNTJCWHRV?=
 =?utf-8?B?dWNlQVBMaUlkaFMvYjcra1VHYStxNkdUWExyRHU2Z0NVMGFIcXB5SDl3ai9R?=
 =?utf-8?B?THRnZGtEaUVNcGpVR2xDcm1wRHlMRkdVaktmLzdPSlMwMXNBOTRhdWxZejU3?=
 =?utf-8?B?Y0dZTCtJRFpzWnJoWUZYdGtNS3h1OGtlK05uWWF3UXFMTkZXbWIzQ0hvMG0v?=
 =?utf-8?B?bXJZRWY4d1I4c0xvV2FTa3pEMzlDZHlJd3d3ZVpRL01yRyt1UVZkY1RnNkNl?=
 =?utf-8?B?bUJTdkNsUU9SVDJMdzFmaWVnT00wQnJ3czgvVk9zeWtIcHdtWnJjbjA2Qm9Z?=
 =?utf-8?B?dk9qM2R1RXJxR0cvUFQ1Y0d4RnE0VHhPb2ljc1ZvLyt4N3hHaklwM1hYT2Fn?=
 =?utf-8?B?WU9ueUIvYUk5UHNTQmd4dUVYbXNUeTNOb3Bkc20wSklFdDJQbmYvYWlSOFFy?=
 =?utf-8?B?SnRRbVE5OVJMN0RZUG51L3VsWENOb0NuZFFreXQwSlJKdTlUWVlFVXpsN2k2?=
 =?utf-8?B?MERFdERLODJPY1ZKMllYZExiTUtTeU1IbnY1ek1WUVBLakh3VTJ0VEdhT09t?=
 =?utf-8?B?UE5pMzNGeHVWUERDYU4zKzU0WFJ3VG56bjJHWHRqYTBKR2RSM09PVGlmcFp0?=
 =?utf-8?B?WXhISlRTa1l5SlpYaXdoK0lEdWU5c1duRExXRnBpMWcxcGFwNk9teWwraFNE?=
 =?utf-8?B?WENxTnBzM3lDby9mL2x2VXFkZFlwbDhGWDhIY2FLUmNaOHQ3aWVxOTRGckd0?=
 =?utf-8?B?Z1RuSDFZc2svWG84L1ZsTnlyZGRrYnBRZ2kwYmJRaGs3VU9oMzdxenhCaXVO?=
 =?utf-8?B?M2lUQ3pXaGxwM0F5STVMWTBiQ3ZmVVpVeVJGWmw4NnQzLzAxL0FmNlpHUUdM?=
 =?utf-8?B?ZEc5ZktYbzBtUm5OV1NGSXgvVzhGcHZ1QUZmSEtyTXUzWU9aRytTWVFMOW9W?=
 =?utf-8?B?SWZuVThzK2JiOGZaVnhrTzF6WFo0amlkL3JBenJhNi9Ca3hYRTg5K3FlU1FJ?=
 =?utf-8?B?V1NuMnJmWnIzZDJUdjFFdlMydGxPVmt4VGpvZ3Q0V1dicDVxTHRycHBTd3VC?=
 =?utf-8?B?UUJGdEt5bmJ6cGd4dmd6dTk0SkFiVlJXT3VYL1VwTzVubTFVRUpYY3VmZUNp?=
 =?utf-8?B?cTZoRzZTNjdrWHlkT2ZCL0JCM2ZvZnh6MjdtVUlraFp3d0dVeHRXcGJXSlNJ?=
 =?utf-8?B?YVFYSXF1dU5VM0ZpaFY1dUNkTFk3di85QXNSU1c5emJjUWVRR2FQYXFmV1Qw?=
 =?utf-8?B?RjQybkg3VlR3MzFkc2lVWUttZzZETmlqMVZCUEdERC9pMnNVbjRIaExHeWk4?=
 =?utf-8?B?TGpzeDRZcXNMVXJ1cC9vSGxFRXBidjBQUVRXQUNodTdud2dvODRNbzlNZW1K?=
 =?utf-8?B?NmVzKzNwMjBNS0dkVDF4Q05BSVh3bWpUZzNxZGRyVWh1Z0hIN2V5c0ZMZHdI?=
 =?utf-8?B?M2E4N2NRajgyeE1oUTlIbGh0d1BMM2lFaUpjN1ZnTXhoNjZLZE53Zz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ed3a8b-808c-42ee-1c62-08df1e11d0f0
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:09:57.9427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jw1ghpX3EXUeHYuoaXvDezKGVC0sPlxi35AkUTq3O6R113ndCSdwibLcXuKE7YXRDiT9yfOaGgy8t/WPDiFpqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up. The
value may propagate through callers that expect failures to be reported as
negative errno values.

Return -ENOLINK when the link is down, and report a failed
ufshcd_dme_get() as a negative errno instead of its positive UIC result.
Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

Fixes: 4b9ffb5a353b ("ufs: add support for DesignWare Controller")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..71433b4d04aa 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  * ufshcd_dwc_link_is_up() - check if link is up.
  * @hba: private structure pointer
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success, a negative errno value on failure.
  */
 static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
-	int dme_result = 0;
+	u32 dme_result = 0;
+	int ret;
 
-	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	if (ret)
+		return ret > 0 ? -EIO : ret;
 
 	if (dme_result == UFSHCD_LINK_IS_UP) {
 		ufshcd_set_link_active(hba);
 		return 0;
 	}
 
-	return 1;
+	return -ENOLINK;
 }
 
 /**
-- 
2.43.0

