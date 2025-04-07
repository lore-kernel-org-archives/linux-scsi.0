Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011006.outbound.protection.outlook.com [52.101.129.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1584C227EBB;
	Mon,  7 Apr 2025 08:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744016181; cv=fail; b=k7zDdROAI647CKJBR1JiZYyEvmWhvoNHmBVRQWIFIxFXu/2HhvTagMbO6x0F0xEyXQb3YVUoJF8jdS6IbWDQ/8bLvLKJwLOkyDwGUN7IZxjQqL/YFJjk204/JpMgeuw5YWwdC5C/cV5g7+Ykfr1VqNA+tddhuVIRYOKh5gYW9fc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744016181; c=relaxed/simple;
	bh=sUT5N/vWjJ4s8K4q13NrJvR0g0qnj09r9hJzH0QUsdo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dGdxD6cPLqdiHrJhUhtomzAruCkKkXsO8QMS6LWp3yMJ3wrT/JPJLcCpmXZZukwstFau8irSeHf47CUbaa2drlo9wttgUAMcudnxelClm3fw+cNR/RbQllOxk9EXRuXDD0WPLwb+Hfm33yyFimDWQyNhoVF9AjW+CYm5xAZfPjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=WGddcadz; arc=fail smtp.client-ip=52.101.129.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="WGddcadz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vA1fIxzLrCCpmSEFAQT5SntE6KEVrmmi4fGZaOmE5+ZYjC4k8aJN8Ic5laJsmqXUar9pBLDdrhkDkyqdoj8Di4e0Kyy+UmfIpxHwD+2rA3dTdh+jbCPBDju9z94Z/WdrnRvtQJund/TFrIoiH1ocMu/tA0QtRL9vSgzYTm53o2jDKWvV+Zu2Gqd5i2A6u55j2S9CDr/jgimIpSDTHHnituzb5gupHAsJGFPkZ6qLCzU1OCMoFb0/sTm60oZ6/TdZTGX8qrT5zM11aRKbPkSper6jHEiZInx6frQfdo72UIy5AeDdLd/qiJVFFp72t6zrQV2Q1hPRZcAatdVgX15nSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cq5rdIKhDwNasBUpUi5k88bYrxHdgtMZwwtOrisMwPc=;
 b=fuUfIc8DXqlWtx7mp0oeZ8wlFUNzJmT+OZ+Y7j41s2uUml773fec05pn7OKGwDCLtgIIRXgjzC5LD28aVoGPgvjdV4dIycl/a9krYda3+Q4BEQqQEcd3UK1psOPYR+AxsK879FjC1GztfzWBlcnsFu6+L8ZuGNlpyEzBtaEJDgae7WrOLrh3OQG1Mn6wPTUq/u3W9QX9nAEgN31yrsGhtX6sSDR4vGmqWvpnDYoKkf9YsZtZg7QApSNECSbG0lu1feY01lO0kdWPH10NCHG4Hb2Rej18kWZSh4Iv4ieAAIwHTg0dABHXsd3/QNO9QOThltQSroaptS1qPZQezE2ZLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cq5rdIKhDwNasBUpUi5k88bYrxHdgtMZwwtOrisMwPc=;
 b=WGddcadzWT7VxtoMvqjRh1ZeAxB8VVVHRKSyxPcBlgbZ+UcUlhLFOXVNtIZQKLL9tUxbCU4gl4j71UH4M6+SIh9MLBjbWElYWNj1yPwm6lmHYXGIHyg1pyfVEte58svgTPx/ALuPG+BD9tUy//RxPRpogEiyrIVZjPu4xK9zhGRGjFOHhv438549/8VmknyUbq0q3MPiYQvdIFsmRtqXNdg3nBDgvhpcvXgzD9SdJfEZyVVBwytlDYMhTygH4AyLVBmWpn2nXL21t1dDdGaTFzZkq1mtKC1qN/vUHfmLaUqJF1VKMYmCIYW8S5s1p5kBigOxqeU9YDYDe8q5nwlwgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by JH0PR06MB6318.apcprd06.prod.outlook.com (2603:1096:990:1b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.54; Mon, 7 Apr
 2025 08:56:10 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8583.047; Mon, 7 Apr 2025
 08:56:09 +0000
From: Huan Tang <tanghuan@vivo.com>
To: huobean@gmail.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	bvanassche@acm.org,
	ebiggers@google.com,
	keosung.park@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux@weissschuh.net,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_cang@quicinc.com,
	quic_mnaresh@quicinc.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v8] ufs: core: Add WB buffer resize support
Date: Mon,  7 Apr 2025 16:56:01 +0800
Message-Id: <20250407085601.223-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1a7a6e077f3750b0385388187cd52010eef4a085.camel@gmail.com>
References: <1a7a6e077f3750b0385388187cd52010eef4a085.camel@gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0003.apcprd06.prod.outlook.com
 (2603:1096:4:186::14) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|JH0PR06MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: f146cc73-bdd3-4f61-7d0e-08dd75b20a70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|7416014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4seUliILlEp7vf8GR2qtUvR7DM42JCwSMBOKIBhuxSGdmqhRif0A3etJ4z+V?=
 =?us-ascii?Q?Q+v63Y6VVYgmig7+INZd2GwepZOrIPYpFNbhvypsdIt75hAm4SfTHkpmS8L8?=
 =?us-ascii?Q?1T7gD/WBrvgxtbBdJVwyxdJzvkg2/wRL8skkEN1A9FAzDNOpt705BTYHYkSC?=
 =?us-ascii?Q?OBYEIdulrsCKH9BqZHUMY4h6ZnziXVZAa1oakhJx2fkKma9Sfd5b3TlWPK18?=
 =?us-ascii?Q?TfLmTV2H4+SISlhF5y9fB8l1FI24Iwc/6kl9EcTQ/zPYgb3rLSL0jDaOkeZZ?=
 =?us-ascii?Q?qw7NvyZ7sfdMMVeLa9AXJA5dCc9L/5hXEvNCj7JVtBidjtW35/ZFxxQtlgBl?=
 =?us-ascii?Q?mmg3Yg4uY1QTk60gpEFMuEJg+G9+5bWgRtxqpfUUL4Z6iqZdWNwU7HmMDAfj?=
 =?us-ascii?Q?mFUyl5yB2MW+q6ypKP8y/4Wj0goOoTbCaP8cPvO89/tKplDvuHTVlqshNbnx?=
 =?us-ascii?Q?gMOJB+jXVDB79Mw97UspatlXRxC8Q0+nGtyF7WzolcRLDYALaCqa+p6jzVdA?=
 =?us-ascii?Q?qTcKHLKzMDjMreKow7FNsEtWa1Vaz2/A2sHrwcl/C7nwcDH1tDNtn0Z7Vrr5?=
 =?us-ascii?Q?2HVz6DXWyARjs3kY3JLwWrB8KCMQ29XRUtJO/Iy+p4pDYCEGUgubzAwa5/4V?=
 =?us-ascii?Q?nO4HBeKwVOnnXs3GAssv7hVxLRRERD4V116QYtJqgQw5KDkH1+KUXrla8QJ4?=
 =?us-ascii?Q?tJ2RGho3OuPcTzGP6Vynvt9lJQxyNS9e9g0zYN1wHoCb9U5H85j3unvyYly4?=
 =?us-ascii?Q?qg7uhLtrdmpgVhzMyRHAH+KyCIkvmHbhWJLIk49THpS8xd4M0mcRYwgJj5bT?=
 =?us-ascii?Q?vBcExZ+UiR/BXD/Gx4otS9bEUWE9QCsbCXbegFTt4JVechCK3t7T1vG08czQ?=
 =?us-ascii?Q?Wnzuia4JhEa01E8cIE/dS75jCyE8qc75LHuSGoWbbsSwRh9DoYlyadB+EAjd?=
 =?us-ascii?Q?ZRWvuXQR9ninR9FeZSsD3yvCjzJ2jALPsegPg6vMufvSQNS9ZznzuqTThHY+?=
 =?us-ascii?Q?biKwSpg9ETExmvx6hiwyeK20pK6AO/Tltzc2NFS24xpciatXs0pm6bn9wRl1?=
 =?us-ascii?Q?O5X0BvipMGueveEnRqgWXIAfGxcrje4rFDftA/YSY3QvrGju/vc48ADrWzXY?=
 =?us-ascii?Q?/h54fmAUs1wSFX99G5JNgejmuCsN3TsDFAgttH0XkXaGqUQek8iJ0DS5o5x4?=
 =?us-ascii?Q?DFhvZWulK5BZFdcyGa7VOZtDDJwG2dPCm7UEr6S0fW8CvPiBluZ75LSFgd2K?=
 =?us-ascii?Q?3cefKSW6B7aR3nyPf8kSDlwW7EI++r2mdj5u1ymkRJUJ8XlPEGdwMwa+9Ykw?=
 =?us-ascii?Q?yA0+E04sGlj75a0hmgFmVK0QFtYk5Tm78bAo0yzTkcCw4gBpEerCd6M4GpPz?=
 =?us-ascii?Q?X+pqWF0IwEbVhOASAjE3FJTyU/eo3kg6sFM3zomT/korIQ0Daj4k3y7TCVuc?=
 =?us-ascii?Q?7cvGWfiYhpvnGnebJ9aIm+JefJ5YFyAM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(7416014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jvqaUDp9ZNYjfqDG/iYW1y5dneX1brjLmQ+wjC8cbrAWejnUt8mPDlXRGYCc?=
 =?us-ascii?Q?JD8axfHt2+mx9H30n7usqez5SXZHrO9n/nCbbf9Utnew8mHonSD63xKuDSEf?=
 =?us-ascii?Q?WZGoG7oCbLmErpCk5Tijun95bdfC43OHAv1XeuSsyYh7LV77khyYHKBM1R7A?=
 =?us-ascii?Q?alE5wtMq1tXU+loPcKBk4F6XJTImMlplJ/tLadmC84IT5YUt/nUeUqbdHH0M?=
 =?us-ascii?Q?mXPr6m4+mRmxm6Pl03nzDKxIXNr5wmxPjSCZ4DF7E5X4zYAz6jCaUmKgnxCa?=
 =?us-ascii?Q?1wApGeS73KdUIUneBQZYmqgvst8Tsglh68nkuQu1F0x1GY5uOW0LJ1nKpr9v?=
 =?us-ascii?Q?++dooeHd+A5uqIrPaIvKzXNeTdUwHEAyFHTaSudq/x4l3+im3x3bbd5V7vye?=
 =?us-ascii?Q?qJhw+6tI4mrL123Jae0mQBmp9pLbiBd2NDOkuJNxuv63ZXqwMpYH+CLirrpO?=
 =?us-ascii?Q?rAvTmHo//6hgm5gUaMMoiAgDewMLMLFJRX38RZwMjwPq2T9ve8sL8GoZL38Z?=
 =?us-ascii?Q?V9UZrztIoaG9kiR1cnRpsgjHCI3gRNimWCK2ex1hA3BgyBMxJOnWLOiv5Z4p?=
 =?us-ascii?Q?JijUzhk2NF8ToDuNJy3qaFQvlDxw07vB5AzJwOwoa0FmPWdyJ3UxKKZwBNSX?=
 =?us-ascii?Q?3R0A2vTa/PNx24FazWXgjw75QarG03gobF0J1In5eCMiOK7LCW/vaU5iuJS4?=
 =?us-ascii?Q?9S+IbwqfBM8SjnlaWFAeASIkIc0zOB1FyP+wzXKUP0iZtJDnwRsdKwodbaya?=
 =?us-ascii?Q?jxHjV7itEjG4VBaKdTZhimMbD8lAF2h6QHHfGoDn0zmQZP1CzRJDbVdP36MR?=
 =?us-ascii?Q?rZpIBj3bbkhnujy9rphZzE1Z7LBAEPlXlwAgOYLX9Sn0WyxSQ9GEd+EZh6y9?=
 =?us-ascii?Q?qkU7u99UiACoBsvhARwkZieB25x8OrvFtMDstRDQV3ATvi7/cFFeLAsemkgt?=
 =?us-ascii?Q?MxW4zYtkfcPrQY9EYgsW8S5ww84XrHf8TxZ1qHM6jUOixLMfnIvwM1LKfvJb?=
 =?us-ascii?Q?ENXbSMklnVPN0sD4CxVnVoGNoHLt+fsqLD5Gre6ae50aZlJPQ3Q7iO61u4QQ?=
 =?us-ascii?Q?wOmfOpSYxfCbghNINXCDhxPYwLzVrODTMovM7XXWIISEwL4yKwlM/5nUpQqn?=
 =?us-ascii?Q?oFxEcZ45MEoD2yiu32D1P59U/EI2DqTZdPCNw0plqcrV37gxFbAgc6jJDa+/?=
 =?us-ascii?Q?x3z0jN/6gw2Y3R5wpAucNwFE8Lx/K4LIdx4AVf2bfQbqW4WEfEMeXiBTkrnQ?=
 =?us-ascii?Q?dNtIPw2x+BgIZjD9hWLgMCjsScogOpdxoB1XTLpfS5901ZqUKkRn2AdEEj2d?=
 =?us-ascii?Q?Kc6TSOP7eNdi1x76U18tWb/baO2XhV1iyWVIqtT/eBfGpx9Cyl6iUPrdiz9R?=
 =?us-ascii?Q?SVIq3eFsRHn5sjEMjGHP7laNhklpS27Vvc1s0ZToGTN+7C1S+0Rt25NHYHse?=
 =?us-ascii?Q?IJyXlE6QZWQ1gEm8h5mXdyWCPgNFMOKvIbDHZAp2FxPRwkHhPaBJDy3iOqAm?=
 =?us-ascii?Q?R/97+4lS5brFimVl6x9EP8CxcnHCYR/LwOVL+1VsA0WtxylW/oriY1oq7rL3?=
 =?us-ascii?Q?fCLws7nMQFFyC3KfRf9Go+usVLqYAfHaS0mr4tqj?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f146cc73-bdd3-4f61-7d0e-08dd75b20a70
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 08:56:09.8767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FMEu3QZ7RT1MWtNSOJlA68ixvtjLtUN84LI/2ZGlyJVxQg9CVblP6jayeRXpmD/w3TqFw7ecatgemxh6pmC7fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6318

> you must ensure the mode en_mode is within valid range (0-2), why not=0D
> use enum?=0D
> =0D
> =0D
> > +{=0D
> > +       int ret;=0D
> > +       u8 index;=0D
> > +=0D
> > +       index =3D ufshcd_wb_get_query_index(hba);=0D
> > +       ret =3D ufshcd_query_attr_retry(hba,=0D
> > UPIU_QUERY_OPCODE_WRITE_ATTR,=0D
> > +                               QUERY_ATTR_IDN_WB_BUF_RESIZE_EN,=0D
> > index, 0, &en_mode);=0D
> > +       if (ret)=0D
> > +               dev_err(hba->dev, "%s: Enable WB buf resize operation=0D
> > failed %d\n",=0D
> > +                       __func__, ret);=0D
> > +=0D
> > +       return ret;=0D
> > +=0D
=0D
Bean sir,=0D
=0D
Thanks for you reply! =0D
Is the patch below okay?=0D
https://lore.kernel.org/all/20250407085143.173-1-tanghuan@vivo.com/=0D
