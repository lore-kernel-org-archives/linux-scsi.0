Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712778;
	b=P/ZVJfKwyReEZgN9bMz2BCgzGWt1kDt5P/QgKUke+UuhJSnJrrQjMAhV0RRIhdZbje/4
	 PqtaG0KXCZ31ydGLQc5FrTnCjuYo6XX1q+rnR8YrwHwk1PliACtEIDlgyk2J9/VWr/DOd
	 P7GM4y/jPoytkUj9IDWPQa6bEtd2GlRRmdCFt8Q/sSEM/Kz2FmtNoCnKkxhQIglwyGnFs
	 QbGEu+8r4cmcDvS1qLLGm1vR+BDuL55N4M6aIheaLvF3Fp1Y7Kz1Gpuut9k00+gZlaV+D
	 LU1Rpx2A0ikp8O6vEERMDwthtCmPvjtG8wddSYEzsLebNLK6vvFh+cW12YfX7diKPaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712778;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SharedMailbox-RoutingAgent-Processed:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
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
	bh=eC3IOMZMzDMooZeM0dnIwZLIijwhQlkuCF3D+hfQcAQ=;
	b=dJ9h16RzV+fdU1Y+AtD0LeMnOB2Po+CMVgX40IVw2p1Qe+6pvHYB9P87JXpdryuHBD0i
	 9pLXiRF7i/GO4TEHwEY2RGqlV40R04bdlhbVdC3MvQAHWAma32udogEbxWoa4LIzHRjzY
	 jGm9R6GW3vX1ZVCAQKR8+id3mqYqTZ6dj4dziVva8oYGFCuTedxnF9qc/1ERzk6RXfNNX
	 8OCDyp809F5EZ4BgTDDDDGoymNxuT35lWaVWaHhcm40nCw/1uA0as9UDFshcYfqvF6CdC
	 dhpk5RK2T5u5/7PZSeq87nQGiqcItyshl3a9+xLR7k5ksTvZg8NnpisY1DiEWeaY8IQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Dnk8tOsK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.29
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012029.outbound.protection.outlook.com [52.101.66.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA01606EE97;
	Tue,  3 Nov 2026 13:32:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CA01606EE97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Dnk8tOsK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ObUa07KXmi0nB8+ZZDUjXfHPnRnj9OnGVS7i2zvkaJXvZ68tRCFPtgBQE8/q04Cn3Sg9NHsWPlHnPOJiInpGFROy7AOvTsZ9RlOKIM3bvj5NOkwZddyUBiRwwQwJu9e+mLYwKMhyTegxlDqi7Ys/L9+WTxRyUvlU9e5EznQ3EpZQZVqBKAPe5wBew89+h3SALSxsljAeJnJ7i3xxtVJKIiytWaBLrcg01l0amj1ubI18ueRqvVZVS7e0z2/G/5uZ24RFP9JCqSfPZYlSqN9vtUIegYE8F/7WUq5ujsJBeyJqJJ9PtvpgZ2FU0HDUWTIYJ1Ws/Mhr07c7tURmP/iP7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eC3IOMZMzDMooZeM0dnIwZLIijwhQlkuCF3D+hfQcAQ=;
 b=ZnfAGCvJr9MPhVwD15h05kMQgwCu1f8Wc/CeEXXmGLd+iJF9B2dusDQ4gJ9Q2cfs8lmt3dAn3ybrJ0L3KSn5i85yH62ALWthtUahGSihsiRzHRZR0Z421XObeawxgi0N6xhN5LCI7W8Hjz+F7IzsjJP8kdjazmUMN8pgxWCwH9gIm0Be/wKKbv8Qq5Mh8JHuOujkGhaz6ZMl+0ALDwMRhKERatJSFwM92gVMe2jd+O1cHh9MOMQxYlxSWmhNF8iTtq38BmM/iqFzt864CU347i3FLteKlX2aJt+EH4RjraexenYSuY2ZLZnnPfmN8qcFE0GAuYHYC6bvTMJhsMkP8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eC3IOMZMzDMooZeM0dnIwZLIijwhQlkuCF3D+hfQcAQ=;
 b=Dnk8tOsKEguLlqNIMGapDMTRrbyulGjJ7RfAcKfL+RT1Vcf7gRO6/cxOMUyHtiwwonhOfAJNB9cchoze0qqUnSnBtgkwsEaMzzxBiaf5alX1puAV5tMFeB/488uqR12FUyQmncRXBxMNwtqB6biHLtZuXYTuBmwCB+Zv2QLyAkHqbi5VZnIZuRmGwHTIXkogaFFsju/61qxVtbXAudpIo3ZZXVPIgbqvbn02NCRUFMlP/OG/DeZ2Z7u1nFDt3Xwha6YXPlQ9TulmelADa9gAdd4bn8yikHHxjuJfZ7fyHHilQGd2KAUOhRpmjkenGPAcsuTbdtOvsoJ8u3NL+b2sJw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI0PR04MB11724.eurprd04.prod.outlook.com
 (2603:10a6:800:2eb::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:52 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:51 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>
Cc: imx@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH v10 06/11] ufs: dwc: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
Date: Tue,  3 Nov 2026 14:32:10 +0100
Message-ID: <20261103133215.1385823-7-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0519.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::14) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI0PR04MB11724:EE_
X-MS-Office365-Filtering-Correlation-Id: 392eb26d-183f-426b-ce0e-08df39aef57d
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|19092799006|921020|261102123227099003|261102130727099003|261021121427099003|11063799006|56012099006|261028144727099003|261009223027099003|261021123027099003|261022075727099003|261026140227099003|261022105027099003|261026121527099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 +FDXz434TZEY1b2dIyEOxpl7HioBxu9QJB4xHfJraR7tbYcqfQundp+0HjVr+Tc4bhWzONBYF5knG+LRQNE879LSYyzxANo/tfmc8wKn3TowGpZgApWor8OWY+tXscJSBkHFcpxkF76Ktg1CDz9aB1s8uutEgrStjhm1oVH23ZznSo7kH+TTPYaBkYdUqFsImn/umWrbd6dJjtrElB9UrpBWAgsNiQWeBQk43cjmblXjKwR8g2vqg62YuynnrVffz08ghwisuNyQbxWuD3RtfxwlL/Pn3YYro9uUuPiqR0GOOR2/aFWkJKULjzXx8VRgpGAp63Ww4NbJW9fBgqhZ74SYL1o1JRBBjAEozdVeYOLGpDxVE8Yuy7BwzvR2vIhsE8TSq73FPcICYuqHxsCGTlGddkfcSR7vtoyZnpMV26YwnY6+QSyhRrj3e+lwSfdOIyTlM5jRRuNWsavMj1ltP/Fj2Te1Tfk7yQGxhFob5wDs1SoZYglQp7ct0anfEg49uFgTjFZU9xl9MiUVo/+VUo1kjSHtJc5I+l8IafhYguYE+ac2XSPX4CIM0yCWGg9YF5WWNuKY0zn7RkYK8CKiHerjZLUqzUibk6S/J0SbBe4Gxx/mKR+jHw3euSK0ENmCYpcobmnPNjAxLpu8YoEBpruphh7DpuJd4gKlcqcaxL0pKYkUqQzZUJ8xztuH+d/RfhuhvpNVy9c2jTUDqRkiOA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(19092799006)(921020)(261102123227099003)(261102130727099003)(261021121427099003)(11063799006)(56012099006)(261028144727099003)(261009223027099003)(261021123027099003)(261022075727099003)(261026140227099003)(261022105027099003)(261026121527099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RXByMnM4dDFFWm9ybGNtWkhSSE1hV0dxanIyMC9yZkh0NUo4bXZ0K2VVditi?=
 =?utf-8?B?VFpjczJQZHNvMmcvVXpyS01ORXFxZS9Bb3ExSHkzckIrT0xscVZNdytoaWNi?=
 =?utf-8?B?T0NnLzUzMnV6T3hrQUdmUjB1c2lkczBLZE9jYnNyVG5Gd0ViemdYZ3Q3VWM5?=
 =?utf-8?B?dXdXa09GYW00QlpkSmt3bzl5a3EzQW53czJhcllQNHprb3dLNHZBOUZHQkFS?=
 =?utf-8?B?RVAvTFl3UGtSSWNLVURXK1B6bEtSTERwZTNnRjVscFUwdDFtcVlkRCs0eHpo?=
 =?utf-8?B?TkFpRWdLVmhiZTZuN01jL1cxaUs1bTB2eWJYdkhSUlEwd3hXN1V2SHJDQ1hT?=
 =?utf-8?B?TGZ1SjBBREJkUkF2TzB1Y0ptSmE3MlloZjQyRTVKSHFLZzVydGZEc2ZiME5s?=
 =?utf-8?B?SHd2MVNCS2dIRzcxQ3FyYzFxYXdKR1Q2Mjhzc1luU1NiaTJjV1pDS09Bc0Fh?=
 =?utf-8?B?Mlh3QUcydXdaOTJqRUgvUnd6bjRINVdnQ2QzTHptNDRicWM0QTh5SDcwYnhu?=
 =?utf-8?B?cUMxeng4MWltODlPaWxUNjNLaUVqTDVQT1ZXS1YxbWRLblhOVEl3TTN3RDZo?=
 =?utf-8?B?S3c2SmxXbXRKV2tncGFqQ29BM0c4WGUvcVl2cEt1Vld6bVhTb2tMeWo5Yjg2?=
 =?utf-8?B?YVJmQ2NwVmN1Q3p1UTZzanYyS0lMTDhiSkdGVjkvbGtHTlVmaWdzWkFEalYz?=
 =?utf-8?B?eUo0VEV6cVJOYkVvWmE0ZG5kMXVIQm56S1FMWXJ5bEVSaXJLZmV3VGppNmxw?=
 =?utf-8?B?L3dCSExIWWVkWnFyT2tIa0lUczZiblZkODV2eHlKbXptWXFwTFh5WFpNNm0v?=
 =?utf-8?B?N3NCa1d5YjcrOEdKWFFBSVhvT2NYUmM3REFLYjVYUTVNMXhIVXlVeWpDTnVK?=
 =?utf-8?B?MlRzeVNEK2lVd3o2STUrdmN0TTdZeG5aTjZJRjgwL0VPZUwwTEF2aE9tYVdY?=
 =?utf-8?B?d0RXVnIzbGY5ZFd5UXJJMVBWU0Erd0JrbURCY2wyQnVBazIvazNVa3dnTlUr?=
 =?utf-8?B?am5tVzJLMjNZME9RZ0FXMjY2N0hkUFNqVmEyS2djM0hBbiswK2xRQWpWcDFF?=
 =?utf-8?B?TEVPVXJibTlKVXBDVE5wRFh5VGRwRHVGbzQ3SDNoRzRwRUw0aTZyQkhXRVUw?=
 =?utf-8?B?d3RjUUFHc0hlRzN5VXhPc1cyV1lnSDhWT1I3TEdhNHhoR1VWMDhpdjN6eGNn?=
 =?utf-8?B?UFZsSkUxQXdWbUQ0dlFteDZXSlhRN0JjajljT09vekUzZUJmQzNQYjAvTmpF?=
 =?utf-8?B?M1ArWjlzY3hNdGErMkFUZXB6dmc1OFF3dWZHcG5CYUR0cW13VDd0ajNuc21N?=
 =?utf-8?B?eUtiSG9WWFNEa3RLRis3VVBqWmp6ejk0QlJKakMzRjhKbFVOb2lKUzl2Y2Fv?=
 =?utf-8?B?VW9iUTNHaEs1Ung1cUtlUDlMMkVTdnF6TVdKV1dKV2JKNjVvcEl0RlkxUS9h?=
 =?utf-8?B?bWlTRVVLZDA0amoxRmdiWU8xbitaL2dIQm1KdFkvV1FQcHN5UC8rMCt5SXkx?=
 =?utf-8?B?eXoyTy9BdDB5TDYrekNrZldxL2xlcWM4LzQyWnNUWmJMRjFNdmY1Y2RsS2l4?=
 =?utf-8?B?L1dydlpIbklqK0kzcjZGOSttRWVER2NOVDdLVyt1WEZxeDVFbEIvbzFaQ0Rj?=
 =?utf-8?B?VzJYNU1Ha0UraWRUSS9RMzNvZWg0SktnTXZaTEhLVTNxNS9nUnNzVGpOd2Rv?=
 =?utf-8?B?ZnVVNG1kQTd0bW1IWkFCbjBOYTZrQUh1WEh3elU0eUNpQW5jVFBodzdoZXFH?=
 =?utf-8?B?TFUyRldjZkpqY29zRy9McnZVRVJNUWhiQmV0aWwrSzQrWFM1Z29lSTJmQmsx?=
 =?utf-8?B?VHI5RzF6TC9yNTkxbVFtWGgwNnltVUllRllib0M2RmRSVzZzTFRBQ0FWbFpD?=
 =?utf-8?B?Tk0za3RDOTFPZTJjOFcwTnZQaVlVNXdVV0hQbGNLUVdBYXdwdGlRTkplUlRY?=
 =?utf-8?B?Um5BK0xhQmk1Z2UyT1ZZUFhvMWx0ME9Na0p0cnFDY21ONUJUUEVPNlh2Q1ZW?=
 =?utf-8?B?dzMvSVc4R0pPaG5VLzVRT2lZNUY5aDJEZlRBTzVab1dZNmZOSXZuUU1YTThj?=
 =?utf-8?B?a2lyaWNjTm5qNkZuN2Q0N3NMTDNTUmE0Rys4aFhhUldvZW5CU0xCNjRxVWFB?=
 =?utf-8?B?WUdzZElXdXU3MmplbjJPaFVNWG5TUFdpK3RGdno5NmxMdEZrOXJUanJ6ZlYx?=
 =?utf-8?B?Zjd6dE5EOUlQOC9LNm1KSUVtOXM0L1FIMEx6Tm5VcnFpd2c2SjZ4R3lOSXZa?=
 =?utf-8?B?TjhWZjlsTG52U3JQbkpyUDVkOHZBTUlHeFcvQ1B1dkdrUjdJbjVJeUxZcm9h?=
 =?utf-8?B?emRTOEtBbU5sODdnblBpbmFSakZDanM4aVhOZDMyYllCUkRiUWFhdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 392eb26d-183f-426b-ce0e-08df39aef57d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:51.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXZiKAn0qqfMZlWOXm4j1KWZy7OECXJRMapWKKfYdnlLywoTOqp+68NS1XWmSgAIXJ1Ln4zN0S45n/oeVXc16w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB11724

The AMD Versal Gen 2 UFS platform driver carries local helpers to access
M-PHY control registers through the UniPro CREG interface.

Move these helpers into the common Synopsys DWC layer as
ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
duplication in DWC-based glue drivers and provides a single implementation
for future reuse.

Drop the static storage class from phy_write_attrs[] and phy_read_attrs[].
In the Versal2 driver these were static arrays whose mib_val fields were
modified on every call, so two concurrent callers (e.g. two host
instances) could overwrite each other's address/value. Building the
arrays on the stack with the values filled in at initialization removes
this shared mutable state.

Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
 drivers/ufs/host/ufshcd-dwc.c      | 69 ++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  2 +
 3 files changed, 88 insertions(+), 68 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 93755befb880..38ba155ce41a 100644
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
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FAST_RX_AFE_CAL;
-	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
 	if (ret)
 		return ret;
 
 	/* Program ATT and CTLE compensation values */
 	if (host->attcompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->attcompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval0) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
 		if (ret)
 			return ret;
 	}
 
 	if (host->ctlecompval1) {
-		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
 		if (ret)
 			return ret;
 	}
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
+	ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
 	if (ret)
 		return ret;
 
-	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
+	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
 	if (ret)
 		return ret;
 
 	reg |= MPHY_FW_CALIB_CFG_VAL;
-	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
+	return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
 }
 
 static int ufs_versal2_phy_init(struct ufs_hba *hba)
@@ -384,7 +333,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 
 	for (lane = 0; lane < activelanes; lane++) {
 		time_left = TIMEOUT_MICROSEC;
-		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 		if (ret)
 			return ret;
 
@@ -394,12 +343,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
 		else
 			reg &= ~MPHY_RX_OVRD_VAL;
 
-		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+		ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 		if (ret)
 			return ret;
 
 		do {
-			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
 			if (ret)
 				return ret;
 
@@ -461,12 +410,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
 
 		/* Remove rx_req override */
 		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
-			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+			ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
 			if (ret)
 				return ret;
 
 			reg &= ~MPHY_RX_OVRD_EN;
-			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+			ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 71433b4d04aa..37876e863672 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -144,6 +144,75 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 }
 EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
 
+/**
+ * ufshcd_dwc_phy_reg_write() - Write a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: value to write
+ *
+ * Write a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB),   (u8)val,         DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB),   (u8)(val >> 8),  DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
+					ARRAY_SIZE(phy_write_attrs));
+}
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
+
+/**
+ * ufshcd_dwc_phy_reg_read() - Read a DWC M-PHY CREG register
+ * @hba: private structure pointer
+ * @addr: M-PHY CREG register address
+ * @val: pointer where the read value is stored
+ *
+ * Read a 16-bit M-PHY CREG register through the Synopsys DesignWare
+ * UniPro indirect register access interface.
+ *
+ * Return: 0 on success, non-zero value on failure.
+ */
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0,               DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
+	};
+	u32 mib_val;
+	int ret;
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
+				       ARRAY_SIZE(phy_read_attrs));
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
+EXPORT_SYMBOL(ufshcd_dwc_phy_reg_read);
+
 MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
 MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 0406f2bb576b..d8673cd54d4c 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -45,4 +45,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
+int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
+int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
 #endif /* End of Header */
-- 
2.43.0

