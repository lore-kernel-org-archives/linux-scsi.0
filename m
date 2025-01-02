Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD37A192D87;
	Thu,  2 Jan 2025 21:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735854230; cv=fail; b=YWrs06gPtEkFVqE/ylsNPMI+SV+a0lcHOv8/0a5xZ1D4a6+mV/yld3I57Jg2mDm7otdhGdIT1l2X0YfiDLNCWCvYLsAQ8pndNxi+xibyyRBATfaRI68IVyqrJlY/gI4e2tkARpveZEOwgNl0Wfk6lbDBAZc8/zK8hvF80rRHlyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735854230; c=relaxed/simple;
	bh=6HJbD2N6VOKB+0U0mIxrpkLWeUzzlG5vi+0wIlV3hAw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ArZvFsTWMdk2csOzx1/EPuwvfhUNG4D0Y62nFsvkcxk9WX/lhwZTd98KTHkPr5zhMwpm+8axZgyNQbO7rB5GBK8rtUmiNjJV2O5L7E/d/oj2vGFtYEbCx9f6xdV9OlZaXxBQ+LzaXnLER33yf6Tg5pctLr7w1ZGZzhwb6DMM4K0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cirMF8lx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ii0rhkLY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cirMF8lx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ii0rhkLY"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502KgAkO011504;
	Thu, 2 Jan 2025 21:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=dx24Qs1O5qzzzczhE1
	MjmWiXZNVMwii/PCUkUCz+6Ds=; b=cirMF8lxm6M7n+1lTsaiJXZfK7FWb8TsQt
	1zszttKwXlySj1ylI03gD9TqCt+D7UkKaBQhFiZgez2ywp+L/5Z5ys8cuWJKUiNf
	JIVwBFeKgNITMX5DMGVZULxUgRf8yk1Sirb26VvoQ6UgjUBqHFxtOIqH1NF+7OXA
	EjSgYKRpHgLZ/bKP0WWHdlYbVvstHbFgUWAu9wdGwMDZGYpnptGsCkRtnK79oGc0
	WNW13s7HM7ExdGAit1Yz41S/dLIRxneyrbVAOcGM/2DFPJdy1C8KnlFikEIljHc0
	afAcz/tir07wTCRoEAxhvm7S9oC4JJfhwBPiG4lDjmnCfnM1S1gw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43wrb8a802-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 21:43:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502L0x5V027823;
	Thu, 2 Jan 2025 21:43:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43vry24csu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 21:43:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VTRaG4exhFrt4AgG0uMtHI2QfKcxLuCAO70VsqIrSMT/lsp7BNUcKyp19/VLP4hfMdMaUJPnyE2Kjb93BjuNnpdNV1jh9WwTluXRA3uVCTwDM11PE3SSgouqNtHbIikFUZOl0aQ9gjCA54IBHQplpFZ2m+Kw06buNHV7y/7ZKxG4M+cAkWXlx00t780Jzt7cJ/FZQgnQ2Yz62dfsbGApQtHjkQIRCyfHKJZMci4eIjBagpvaGcglB6EttFCeqSS7hHw+z23gFGSMbOlgM0/tiHi2/p7nr3cAmi4gUvLCk4pO5NgNryKiVfecaP3R3H6uKfbj9DacNZU9aKyhbXoTJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx24Qs1O5qzzzczhE1MjmWiXZNVMwii/PCUkUCz+6Ds=;
 b=QjnCr0+hy/W3j0N9m/iV8UGPddggVs/El3wOxmOBmW34KgM4jlag7C5VpAKaj4CVZh4IU53qWE/U7xCkviqjDSJx+umQ3g3LELWKwhoNpOoJTgRqmjuE2fCAoHrvXbbzaqJdmHWa/VX/kR9sn2UtxSLY4bnhj40QkBdnBmVI/jN7ud0Tu9QC+/WvWE87rTHXFEDGLeql4UPXFKcWRhfqaIoAi6vtCb2sagcypYqWK4+04RcS/pcXlzAaJ0HiFJBloxpPofSQpRqRA9ivvVoZMBoymIdsp3V/bmcOhzQ2FrYUX9hevONGvVVgeUOWdaAoM3lPF8XziIq5S1RAsOj/ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx24Qs1O5qzzzczhE1MjmWiXZNVMwii/PCUkUCz+6Ds=;
 b=Ii0rhkLYJfCxM6TrOTYW9i4t92/TrxlqeUXceITfn5LdjfA+dgTxlayTiDnbCRRMRIlY1BEawjE5Z6i5frzYeuJrEeVFHUx0us2wTOBpNT0gYyW7Q4LE1BkSu15CMGdTeeWhGgfSDzaFY5i0+60kxGgDfcPPiSuy5mi++xT1Hh4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7319.namprd10.prod.outlook.com (2603:10b6:8:fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Thu, 2 Jan
 2025 21:43:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 21:43:38 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: driver-api documentation: change what is added to
 docbook
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241218000748.932850-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Tue, 17 Dec 2024 16:07:48 -0800")
Organization: Oracle Corporation
Message-ID: <yq1v7uwdh8h.fsf@ca-mkp.ca.oracle.com>
References: <20241218000748.932850-1-rdunlap@infradead.org>
Date: Thu, 02 Jan 2025 16:43:34 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0186.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: 45761e37-9593-484e-bfbb-08dd2b768435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1qCaMnVgGN9BLTkRyPPUqXQb9oB1YcAfOrUBXtynZANUN4tYhE7zwAAGr5xf?=
 =?us-ascii?Q?6bEcvwgV/KFkGvAlzYNAHGMxSFCEZhijaLxw9vvlnrdpA57sbhtB4FB/tjKo?=
 =?us-ascii?Q?CpLPvri9pjym7ieW0WSa/T54Ej70/TfRZ9edN92dqZxCBrwyzY+fKGtbIn2j?=
 =?us-ascii?Q?2Y3PDYXTvfGwg0ZAJlO0eByilPHy7J1/4ukek1YSMoefAz9BcCHbzhgKAPbx?=
 =?us-ascii?Q?Etbut9YQ/PcNJkrg5iLXlM2HjHkkr37L+9Z16dzABV31wJaByInUfccPFLWb?=
 =?us-ascii?Q?fyNP5Wtf3OK7L+U8S4+dMcT66nm4XfgTvUf5JAmQGzX93I+FaNOQXO7kLvmZ?=
 =?us-ascii?Q?79QYicRiGtkymSEujiwY5IL/tZOvoqxjxQXm9sJMKBgZAY6IZJI2DZNIni/Y?=
 =?us-ascii?Q?0zcjT0HKSANRoPC5capN8vshZs4LzqX4lcAYshEYohTyNIV3fHcJoqk/X+vz?=
 =?us-ascii?Q?DHfiEoBkzBNC32OTIrXN0dx56rxGTgvazWXbkSK9XsEzXG/O0faoPJ8XM1Tx?=
 =?us-ascii?Q?QddEMMWjLc3yAIozQz43oj30Pfl60sVtLCn3mHaWsoDu3mhGJjfAADA/Ajdn?=
 =?us-ascii?Q?GAwiIEjZog65JJJhwnlrlDuOy1sbYaxyiI2oWAvPEtsqf8Gz+NLv+PJVt1A0?=
 =?us-ascii?Q?HQ+V21ddY3iU8XhEpH3+uX+5y3r/J5ybvWQlYq1uAhNAQSO2wVIKCGiJrE/F?=
 =?us-ascii?Q?D6pfsi3QZm/HAiiIDA/q4Pgs8AMBdWjkiAlNM3ZvmVZOC8mQNlGSqP2qLQyC?=
 =?us-ascii?Q?J2HxPxJRmDvNHHdg+vYo90sgYSfUUMcVXeKkA4f6T8WPZG+0Ep6f9hcdMcrq?=
 =?us-ascii?Q?rkVDmMsRIU+KEjb9wrOaToaMbCTJMHmm6bX7YsKxHPl0AoUISU3E/6uj0RU/?=
 =?us-ascii?Q?LnVjeCG/FRBydIwCVCl7BYgGnaHYNa2I/Zol8B8qKOoMRwSzS5AkKnRTOLod?=
 =?us-ascii?Q?PqCx/dYAj3ymAbneImVJl3QrQGjRVEJn5DdzNLkhQKN2St7din5H9BYxxOAv?=
 =?us-ascii?Q?N/BNJyFjWw+wJpgpWryHqbtd08zL7DO9bRR5z9qSW7AiH7F3MRhZFJAOgnKO?=
 =?us-ascii?Q?3wu0DtYtXpKvMu44fEn92FvB9iCmUM4MsWaYPlV8ioDf1fqCN+2q7q2aPvyy?=
 =?us-ascii?Q?hWSKLtgLtoGiILC0Zp35sfIlOx4u9c90h/j/L9DI6/SDuSpkQtI2zu0bPacs?=
 =?us-ascii?Q?G+TCC6LZmEb1wbPCBPdLFOwBg6VdVDDkV0sOrUrlrUJQkRAGGoSA+qwMhnkZ?=
 =?us-ascii?Q?s3eMZp0gG9MtokxqucVgcqy2cNM4JrbsK5LnRRmluuk8/h+1qgTx2YvTBvKg?=
 =?us-ascii?Q?OuZzHV5TAZYzsOesAVavZm+/j35HxyzbkAJsALvJ8oT1aH0yDv0yKaPnuyXz?=
 =?us-ascii?Q?LhNgd8Y8KGmcNGb0gPZvNdjr2OAG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dq9sPb8gMjol9vO4sjVMzZeCFsZjr8TnVeyo7PjoSA/udicsi9AOFPa58VVM?=
 =?us-ascii?Q?CGFIMWYUEYsr5AKdGPGuekxpNU/d2nYJ+Fzj2iTVB8SFNimdJ9b0L4K3ld2f?=
 =?us-ascii?Q?DlxdfdotAZp4cAaaS25h3OtcUng3bL9FZEDgHI42SX0ZNKQL99NquovWgt+x?=
 =?us-ascii?Q?9DypPTDAMc6GJt37jE5ibBm1JB4SX6HOEfzaXiTlsanzSWLGxNYyvt6Z/6wB?=
 =?us-ascii?Q?D4SxKWiro/u+hwU/OAeR/GKdnrUY9HH0izxa0cbQCZ1cpuwh/5u6r1eb70pw?=
 =?us-ascii?Q?rBL08wNr3ODjiL3pZcLXIDRVmAEEIkNmEBv43my/2qqR+LZR2z2A9h9jVdmj?=
 =?us-ascii?Q?Pfjh9pz72VHkIXw+q86aJU8Ko27NP/Aw63Kmn6jjsxj3G+CIFPatQwF72ZH+?=
 =?us-ascii?Q?o6UnffALQMFn/N8hXUQxEtzZl0FQbVuPflOpOReSYhfC+jQdodttjMunnMgY?=
 =?us-ascii?Q?62SYe7Xqixo7SOEWHiP8K7qPTqh5XjXkbTzel/8wRjNSA/bMwNv2TaImTPJZ?=
 =?us-ascii?Q?8s/Wpb264O2luWkGLi3sWjklmJchwIUJRh4qDxA8xUGX+FYP8qNh6oeMPlso?=
 =?us-ascii?Q?Riru4wEsQmucYtMwi7h40WkIGNYKhraKTsJ3dk3JHfCcHh0LHJi43WmbhmUr?=
 =?us-ascii?Q?jF20/ZsD9f56IguQ796N9dTKP5uVY7fYCfeUmRi/WeHOHfcq7lKha+/AtKei?=
 =?us-ascii?Q?piceXoLlSaXZZQtXPpgBiViEWhdTrlKPBKCfhXBq9qjtNjCf6Fg7z3y1/GA2?=
 =?us-ascii?Q?/uFMWHopyStw1WiMC7lGsoPeI4Ns0E90dU8F/fxwqFxnRaptKwKwRKOtdfvR?=
 =?us-ascii?Q?QyVdva4vscm9/V+M/77At7XYPkozslXIRJab1cYz8qsu+6v3KdMkVuBIbyOw?=
 =?us-ascii?Q?uvgbtMc5P8gasnP2T5dZaibTPV7MBkV3xZxloJCQRdjUT72JLG2GO2D/+mGO?=
 =?us-ascii?Q?/VKDrKGrmUGl7ZwUR0U12gSh1JFlq0hBiSbd+czIW9CYA2T3kQb+uWkqvE+u?=
 =?us-ascii?Q?C8NKVWdZXiYOjppWdLDAnZQkC8nNmoo9o/sHLKaYuU9E7zn1rWmHdqayhyBe?=
 =?us-ascii?Q?RNaKBl77r/5LVwAy+3TA2/9Oup/oakTMfzvOUk0D0MNhkuUK5IPasUoKzS08?=
 =?us-ascii?Q?M9CZ9JCz7ApNj82gqEb3/OpHg5KhUo52etdkrjg2q/3ZYL0+xTeR8Spbfm5N?=
 =?us-ascii?Q?ueKQe9d32TsuFIbdz6tAeRJoxLyCMb84Pby4dRKvzUbuNgQP+exvrCzEXRQ+?=
 =?us-ascii?Q?U2ZYF3+YLslqq5sNqU+OhPjMBn+Xz4P+B2r8UFrJY/iHZuI4rWZjzyV5iwOk?=
 =?us-ascii?Q?UiA2zQXfR+o8GZJ8AAvK1QxCB0IxE9wnM2CDN+DAZFt16kp6zAgGWhFsgp8q?=
 =?us-ascii?Q?6uXQwoLVprv3B4PJSEiNdDOB2D9FRfKqLcfGgedSTaxdxodCWw8wV3EfO+LR?=
 =?us-ascii?Q?YLk4wo83XlypgiyzDe63mBXv61x1yYZkqsKiyKQFl/wspCNHzyU2YnGqQTlN?=
 =?us-ascii?Q?LZkT1gaWa1lGjbAlcNu2VK8220KTJB1GLYljqzu5MjHqITv7Ier5wR9ERbmS?=
 =?us-ascii?Q?nvTdq//f1fXIQQVXT5xqfRbuahUs/T+SnUdteZhaqBoJk8qSS5bSnzWe3pvw?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZxfY0KSR+RpM1xnFVqQS8CfzBSylmvhnOglU6mdY54T4wCtDEPQPwUWj0XYH9R85lY2nLeZ6xxgwEDf4W/Uwjq4RzC+fZl+kt+eYMa8Ljluei/D3Lfxw+xvyplrkruMMi45BJs9tqEzebqfMzm7/DpyaaW2lDdA1N87jeUTX1nawW6Dkf1WfxvRmxlgjl2PtsDlegbBVhX7Z4yqf3/CdaXTfbs1al1re2VSYAU6OvamggjolXmbJqlMSxqhdm8ajNSopdOMlnJHzQkwt5olMRrYYHu9IXI3pUQpYR5hN2SUHffHJxauAqNOhxiOVp5fKR2quUFVJirMgqaG4BTbJFfnlM7JAQpHM940vvyuz8zFUdjauRFYnjQPfxNnMaqqvYGmPpx9QeZlnz3I0JIWT44jAfGi8o9UB/Juh5kly9GahbkmFQO8e2OAldQH+yLlX9a8RDrVCEvEcwEURdigY1/RvREyFWUrPL5Q03SJL9UMzW8/fZyXSNbT07L+ahXjD2kkUWasEgxjRz8knXBBFrauZza/aHYKbXtg7cg41f26NRybbtYQ+355W7sTMf9nUxu15mzN+y3VnpixI7WIohnFsdFLKqXlY2Mz7W40yu1Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45761e37-9593-484e-bfbb-08dd2b768435
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 21:43:38.1828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yA5n/D2u/pIS3Vl8qkwkYb436ocl/obXwnh7YwwIK7LGueWpdOe+Cyh4TVEIx+wNmgBlpNy0WX33BBEngRZoG1bT/DIlXPDESjplVD3odz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=868 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020190
X-Proofpoint-GUID: WSHyKpFVksEw2x915dlcQcBN3n2WxMaD
X-Proofpoint-ORIG-GUID: WSHyKpFVksEw2x915dlcQcBN3n2WxMaD


Randy,

> For scsi_devinfo.c, use :export: so that exported symbols are put into
> the docbook. Drop :internal: -- they aren't needed in the docbook.
>
> For scsi_proc.c, drop :internal:. This will cause all documented private
> (as is already done) and exported symbols to be added to the docbook.
>
> For scsi_scan.c, switch from :internal: to :export: so that exported
> symbols are put into the generated docbook.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
