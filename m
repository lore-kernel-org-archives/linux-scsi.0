Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80732293B5F;
	Tue, 19 May 2026 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779198830; cv=fail; b=JpJaPGeYzoWKyyzwklJORBlXjqR8Kt2TyEYEaKG60LpK07QJZc+Jn6941Vv56vITKkhnrrZueKm2vu2f6oqsmPmE7pfOECr1RTAsv9mWzK+SyIwvmKQ8s0FL4I9cv/MTeNswkXhZto/3N4feVva0MctrPX/MXGWUO2+aUZVGhug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779198830; c=relaxed/simple;
	bh=14C6fRqFnU+TMCykbpBuoyw45vsVZJa9LzUMsuYpNIA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ahsCTJAOcTd1bIAuOfhrbOzTCkG+yM2kVW/knWrcWyV/yk/zJ0wrC+VZktutlwLKmy8RWzSLg23xfhlSbbTvaT3/cFfkreMFhS0EahRqX+LXFUVoHwbN+d5CTkrWJ+0WUu311g6Dx9jqyR4ybqoqIZYPJBa6fnOQ2ptvCLdhQsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=WGL1suA4; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="WGL1suA4"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J9LZUn3553532;
	Tue, 19 May 2026 13:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=elJuv7RYr
	vmbOlFDm4RXYUpxPISjHF+dlb5v1lw4QOM=; b=WGL1suA4YBCbukXagClRK6j0w
	B8nlkSktnVgTw6sIKmChJrPIpGoTdHJZ7pGuuTJFCFdbxe46sM9WtjOiGS8+1gK7
	AQfBJ60BVGTJZkjhI/VbTEkZg9oQAcXvNm0dhiSoo8CpEKEeFanZVP8S3rz74B8A
	bGWKzTJGD4ZwiSZfmAcTtSP1HbXnSoMVuTQKulB23OVRmbqKjjYrXQLYrCRwndKu
	PK5DN+pQ8ERYB6tGaVW3cTDZhdmmFfAaoL25Kkq0E08y+wpfJlXBiSPgOf9dxQLK
	BpMPc1PNLh09kBSSqBXGBfJCjCOWzNxNzEnY72St7k35S0WewKFtlxDVltFPQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012018.outbound.protection.outlook.com [40.107.200.18])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4e6ecf3pyg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 13:53:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BP4Bx7QdytgIE2Kuqxgw589lpHF0+87RNhboe24MICxxAPCCW1tmTXO5I5WMeZC1X2xhvGOEvYP5abudgTjeOHGcVMRv28uH1P1Bcja9gbxl7S8TSppXI0U1P/IVpTKQ0+3W5399cTus1kugWjfsyU/7iRiGbGRR+mrmjE/qnOsyNcy3BbXWfFI/nceT2AlF/cAxck86BjgwlsEOIOEHCsfkbVQ9D4w6ExrYazhFbuVVpTkEFIyifQyGCtP0kBy0cl1YcWdv58d60MpLTtY40aKhJBG1nuPqsuPqxetoLb/D7QrgHzrLCNusqYa8Aqvu3oUfO94XSQSaKImM8u1apA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elJuv7RYrvmbOlFDm4RXYUpxPISjHF+dlb5v1lw4QOM=;
 b=l+fzRNfhAYRWXxtX6Plj2pPddlTq1MJdPEyMTHVBnL6b77piTmYYXTahW3OxDoQCRcg+pngMpGcgT352ju8GszdbLoCWznLHhpASAA2n3josLLq//YwC0DfBQB0BphzRhD5NZUkWpNOI3EMNX8Wi7VcxM4CLnjSgMDLED11dsW13VN9PokezF3lYNju44TZbFpHIQspUQ5UeHNmOHS6sI0OvWVQsA93/mJLoPMSRqHPZDAuosaX87Iev7VrXggqg4yPD7WTtfAZUoq+HLapYBNc2kr8P6dC7P8dhxbPoTm7prqUQc68Qc/EXm9PEwxOV3P6ZH9vjYhXkhCpL6QyPbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by SJ5PPF0DADD6EFE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::80d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 19 May
 2026 13:53:07 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0025.022; Tue, 19 May 2026
 13:53:06 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
        m.szyprowski@samsung.com, ahuang12@lenovo.com, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v8 0/1] scsi: sas: fix mkfs.xfs failure due to bogus optimal_io_size
Date: Tue, 19 May 2026 16:52:32 +0300
Message-ID: <20260519135238.373784-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P190CA0045.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::18) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|SJ5PPF0DADD6EFE:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c1c8ee-7516-432e-7abe-08deb5adf3db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014|11063799006|3023799003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	2PWFzGehqhblSyXvVzMWd1bWf0ANAneQ/2K7uR5VN+Ukbx3gAfqlfywqAPNplTwQieoHDhIR4Raxhv/0+bWICjM/Xj0pfa4CF1Dn1X2qGcLlasIs1s8GLnQIHWhn+YZ0MEfctO5e+3869Or1zd6dZE2zvoIdRrdUgRsWLnO9TluUz6BksuM1TtE1h6Wp+OtMf2Psby1JPw7TDBilXRZ78l5KTs1M1PUQqoCMH7JjJ/ATo5p+FGLYfy7o//e8+olOUGtY8wCQUaV2HZ5beoZJAnUUE6cr+6pIgC0SdHig/4EAB9i5nW/KWLEcyPIzaFILJbaZROoU27cSUOov6bc5NOtCeUXRTXBmX03TpNZtznVubrd5gyjIiDeb9uHDUyNIibjhuByDfkiM9nrCesjvna/ul5IAQ2sTjG5N97g6575dBY6ZLW4Kj73bqtfRMtxZwRRUh/f4liQA/MkALgA55E571vaJxXBU9VB2qHVjGyoy5CbZqbsI7gbPZ5CoJEwZCwAwYKLl0iwXwRTtNZENbia5L6XLpevNPXxqU8mrS8dgznGbW7m25x5L3+RvJhM4luuN+uTnKM+LDFqnDbhBXs2o/F8tl9F+xu5uQzy+PFcj+ZeefN8Ljy3xbmZ5/X5rv0igsRuyxacdtfld3mxeO8FXFrhUIuOyBFFUPpgGZawrKFRHyk8JrxtUhXKwHlzlGARmokRNTEzlDW/UFGO7uQzfeRV4TtTJVq8zR8bYOrHg1JvY+UvFNx9nz/2A3/Fm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014)(11063799006)(3023799003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmRsa0EvYXdFc0JhNjlhWStDeU1YSUdzSzl3SmtZSW1zUXlvUG5jVzAxNWhq?=
 =?utf-8?B?dXN1WSt2ODdWV0JVdnlHR2NGTWdGNjlWbDAzTzZMQUwrUDluRTkyL0QwbzVE?=
 =?utf-8?B?TnR0V2pnVk5DNVdPV3RnYy93K0tndVBUb0haZFhxWVJhYjNCSVUyU2VaeXdr?=
 =?utf-8?B?ZkRjRUZUcFlMZnRBNlNvb1pIU1BVTVAxRGlZdmxiOTVPdEdOSjhlaE9McTNU?=
 =?utf-8?B?eWVWaDBiRDMyT2ZMWUpIWjFlMEFWT1JiUGFXUlNOeVFjRnpsdDFsWmlyQytr?=
 =?utf-8?B?NDJJajQrczM0N2hsMWZTVTVHUlJ0eUhIanFsejI2bVV5cXp6SzJ4TkNGaUhQ?=
 =?utf-8?B?NUZFZnZMQi9rR3NyaG1qTUF1dEtEaXBkU1lseWpTY05WaHh3NkNtMXhtU3py?=
 =?utf-8?B?ZFVDSitKZitvN3NIYmN1cE5UMU16WG9VMXRUc1duTnFZTlQxbkhWQUZwRHR5?=
 =?utf-8?B?OFJnaEdHY1dId1p4UGhmMXgzZzdCdFZFNjdmSHlmaG5MUE5NNXdrZjhkTnJo?=
 =?utf-8?B?SytBVjlOTGs5KzFUbWFXejRSTzlZWHE2eTZwVGEvb2d3ei9jNW5rdkowZ1Zm?=
 =?utf-8?B?eXJUTG1UVjhkb0RVZUZxdC8xN3p6dTBQWndMMnZlZ1YyZG9ydTlPK3RwTUt2?=
 =?utf-8?B?dk5QQ1VMMFVmcENDNDdKTzR0SXoySnV6QlljU1FNaUh5OUJXU2RwYVZIRkl1?=
 =?utf-8?B?QXJrK3BVQ3dZQmFCYTRJSjBEd1dwYnBJbkNQZHNDZytzcng1TGtkK253RVB1?=
 =?utf-8?B?Rk0weHA2TlcxQjRnWHRkWmVuUGhZT1ZPZitvdjU4SzlJWG80bmVIQjBNdHR1?=
 =?utf-8?B?c2xyZFN6YTNuRnBOb3pGQVQ4czU4ZmxtSXA1UU8vd3k1SGpoWHpzZXBLUUl5?=
 =?utf-8?B?L3JXbG1wNmVDaS93dlQ5a2dVd0VqVHROU3V0MisxSWp2ejFNYmFMMnprVTZQ?=
 =?utf-8?B?WWs2NVNRblp6RkJTYW1WMUdIOGlEYnJjNkM4aXdTSUowZUxycDNUY3RSYlVr?=
 =?utf-8?B?UFFJbUNxaGkxdlFsNXhiQjZoek5WMXB6a2RJVFZHaUZiY2xNWm5SRGlIbWpp?=
 =?utf-8?B?REVXMXF5YTMrNURwZ0xzQUd2NXgxdnV0TlN2TnNHRlU2RklMYXYxaGF5b3Nx?=
 =?utf-8?B?UDNJZ2EvZmJndjYzeFoxeTZmZ3hwY2pwR2M0TjV2M2xPMmdFYzVnT2YxUkhi?=
 =?utf-8?B?NGJHR0E4TEo3cnEvbGpGUGtjL0NIK2tWWVR0R1JBdzhPLzQ1bjRRbTJYcXJX?=
 =?utf-8?B?aXRwdjFrWlNyTjhTcHgrZkp4WmdZT09PSUl3eWRUNmc4bjZqMGwydEZkRktR?=
 =?utf-8?B?ejZucm1KcFFKQld2bDFPMlZnS1F1MnVZR3dSMkMybWpQQ3BsRldOaTM1QXBK?=
 =?utf-8?B?Y1IyUXR3NDVIaGU3czZpczFNMitwRFZjOUhJbFRTdCtvWm1jSndPL0xwanps?=
 =?utf-8?B?SldqLzVjaXBXWnhxbEZFaHlWdTZSSy95cExISGlKUk9iYWh4NXRveVVzbmoz?=
 =?utf-8?B?Wm5NRy9YVTZBMjc3OXV3Vm1UWmcvYjZGOEQrVHdRcmQ1TjcrbjhXc1gwcnBB?=
 =?utf-8?B?VE1EUTh1K3VzYUFkMHpjTDVjRnlCQkxEazc1bnAvK2pwYjExTG5rNzlVWVVp?=
 =?utf-8?B?SHVLb3J0bk9XemlzSyt2YlRnMnVxVndPRHozTWppK3FxamorT2wrelBJbzBL?=
 =?utf-8?B?ZzNaRXRJKy9DUFY3R1NGaHNxUkg2RVBZMUxmQ1pQQkZrUlMxN3gwUlNhcEo5?=
 =?utf-8?B?TTN6Q0w3VXJZWlNQSW5JeFZYSEpMaWk3SHNjZ0p6YlgzTHFvZS9SVlRTSGU3?=
 =?utf-8?B?RVo2MGNsNXd1YmFvN2YyUzlKT096M0RRcnhEL3E2MmYvSUdPRjVxSzBpWUU0?=
 =?utf-8?B?ckcrN25aRUwwTnpYRW0rRUkvbks4NFREcG03dTZBWmdBZkVPeTVMOFZ6QXE5?=
 =?utf-8?B?NGJ5KzA1UjdBUmp5cmJJZ1ZnRmRCWWphQnM1WnhCQVR1MUZJUjVvYjRmVjQw?=
 =?utf-8?B?QjdoMEJPdWhZNE1wTGxNeE1EUndxVGJxQmhHK1NTZG5mbW1JM2w4QThVTTJk?=
 =?utf-8?B?WC9qVzF6RFh1SVk1SGd6U0l4cnF5REMxOERGNHBKUlJ1c0R4ZE14cm8zaFps?=
 =?utf-8?B?RkFhak5yaUo2Q3o0MFYyMjZhRkFLbmtHTWczQTBpcUsrSGNMNU9od0doekY3?=
 =?utf-8?B?TXJKVmJNUnNUMlR6VnhmTzVHV0pJZVRUT0IvZXhoc3QwZVpYbitSekNIMmt0?=
 =?utf-8?B?cGd4elVPY2I3WHNoeUNiQklGS1UweUtGQzVlQUlQcjVQRFFJUkN2RkNJQTRV?=
 =?utf-8?B?bEZzbXY5ZlMrS2tiQlQ3YktxZUNrRStYZm5wMlNFMXlXWUZHbEJtMDU5cnJY?=
 =?utf-8?Q?c43sAtdn7oAkKGsA=3D?=
X-Exchange-RoutingPolicyChecked:
	IwgRcKFYuAbjLMjfLWU7G60RqweinQdUZPwr1T8NxLbEbLMySzMojqqLQrFegQIh5czAH5hWJ49OKY2eBhDRGq/qVYWNdfqX//BYWmt3h6K5RHe2W3mIui/7uia4lfRvPGiVqnh/2T0dbGf/tnSk/QHSgXi6jeIgqnnV/wm3CcqALs+M4g+PL9G641RrFE2ccyiz7CyKUHUwReGqSwSeuULIO5SkjgX4AKXDsto1Mf4zu2vCx/0nyxwiBxFBLfJXGlyzpsfCtQ4LMbAJRFstn4JN6w/0cXxGCvf3aBHq8HQVjEzZhkpzO49aSSw+gpBf3JInsU+6g3Ew1R9vW/eOdg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c1c8ee-7516-432e-7abe-08deb5adf3db
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 13:53:06.2259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ryjdjJj7OV4D2EkJZ2YVrakXPLKiGGPYTHGOSdD3aRm2L6sUQSuo6mIL9ALkdkNGVvLGHbk5KfcDSpsxzqwOZBEPmC0kTTjL25UOOpPxvoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0DADD6EFE
X-Proofpoint-ORIG-GUID: k8LcXzizw8KqHfgHm4-3X2KhP_OIRRBE
X-Proofpoint-GUID: k8LcXzizw8KqHfgHm4-3X2KhP_OIRRBE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEzNyBTYWx0ZWRfX8YAOokPJE5jZ
 zYeYVNsyDLhmxfG88/yIJjoKSbwzcYb6kvqiubcXdg9T2Wo9N92nR89nNvrmdqidooBvy2n1bJW
 S2Zh6pDMDJShtKzq4592jKc6DXtjL+nT0dxFb6GCXlS8vFVWs2IjoIgyADLsRVcwKSMvbv6C7sp
 4GNoFldcbl0+99YGiBROOPCt1/Xh+wA70I8rFwCw6OmaCCaSBMh80Tcjk/mulRBMJK/CC3eu58N
 kk2XXLYCKyk2nPsKxCgbD9ExtIfX1kThH4ItG8hetZxOSeQgh+nuBZL1N/Pt0TUmgmZlpjN5FKi
 YnCNGnruyi8SerFR7ZJkmb9IahGTSvF3viEXVj3vpNr90lz23UkrpN2vpXxGF5D3/yFY3R2yzo0
 MR+lyfsKnrl5f9/hQMOkeQYojy8plW76bHySo5qeh4RdZo5a/5T5ttDr/o3hE869/EOCMO7hoip
 pulbNnaAaKX93yAZErw==
X-Authority-Analysis: v=2.4 cv=dK2WXuZb c=1 sm=1 tr=0 ts=6a0c6b46 cx=c_pps
 a=73h/HchST80NzqUzJRdbyQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=yPCof4ZbAAAA:8 a=mMGXWFx0uVFFMC0gYRQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190137

From: Ionut Nechita <ionut.nechita@windriver.com>

From: Ionut Nechita <ionut.nechita@windriver.com>

v8 (per Christoph Hellwig's review of v7):
  - Removed the dma_dev->dma_mask guard — dma_opt_mapping_size() and
    dma_max_mapping_size() both return SIZE_MAX when no DMA ops are
    present, so the opt >= max early-return already covers this case.
  - Added inline comments explaining each conditional in the helper.

v7 (per John Garry's review of v6):
  - Dropped the redundant !opt check from the first guard; the
    !opt_sectors check later already handles the opt == 0 case.
    Now simply: if (opt >= max) return;
  - Added Reviewed-by: John Garry <john.g.garry@oracle.com>.
  - Rebased onto linux-next (next-20260414).

v6 (per John Garry's review of v5):
  - Replaced kerneldoc (/**) with a regular comment — function is static.
  - Condensed the comment to a single paragraph.
  - Removed WARN_ONCE for opt > max — not the driver's job.
  - Combined the !opt and opt == max checks into: if (!opt || opt >= max).
  - Apply rounddown_pow_of_two() to min(opt_sectors, max_sectors) instead
    of just opt, since max_sectors can be any value.
  - Restructured as sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
    with the dma_mask check moved inside, removing the need for a
    separate dma_dev variable in sas_host_setup().

v5 (per Damien Le Moal's and James Bottomley's review of v4):
  - Expanded kdoc, inline comment at opt == max, guard for opt == 0
    before rounddown_pow_of_two, trimmed Cc list.

v4 (per Damien Le Moal's review of v3):
  - WARN_ONCE for opt > max, min_t overflow protection, reformatted
    call site.

v3 (per Christoph Hellwig's review of v2):
  - Extracted the opt_sectors logic into a dedicated helper function.
  - Added rounddown_pow_of_two().

v2:
  - Dropped the dma_opt_mapping_size() change per Robin Murphy's
    feedback.

Single patch fixing scsi_transport_sas.c.

Test environment:
  - Dell PowerEdge R750
  - SAS Controller: Broadcom/LSI mpt3sas (SAS3816, FW 33.15.00.00)
  - Disks: SAMSUNG MZILT800HBHQ0D3 (800GB SCSI SAS SSD)
  - Kernel: 6.12.0-1-amd64 with intel_iommu=off
  - IOMMU: Disabled (DMAR: IOMMU disabled), default domain: Passthrough

Based on linux-next (next-20260519).

Link: https://lore.kernel.org/lkml/20260316203956.64515-1-ionut.nechita@windriver.com/ [v1]
Link: https://lore.kernel.org/all/20260318074314.17372-1-ionut.nechita@windriver.com/ [v2]
Link: https://lore.kernel.org/all/20260318200532.51232-1-ionut.nechita@windriver.com/ [v3]
Link: https://lore.kernel.org/lkml/20260319083954.21056-1-ionut.nechita@windriver.com/ [v4]
Link: https://lore.kernel.org/linux-scsi/20260320081429.42106-1-ionut.nechita@windriver.com/ [v5]
Link: https://lore.kernel.org/linux-scsi/20260326084644.27162-1-ionut.nechita@windriver.com/ [v6]
Link: https://lore.kernel.org/linux-scsi/20260415071849.25693-1-ionut.nechita@windriver.com/ [v7]

Ionut Nechita (Wind River) (1):
  scsi: sas: skip opt_sectors when DMA reports no real optimization hint

 drivers/scsi/scsi_transport_sas.c | 43 +++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 5 deletions(-)

-- 
2.53.0
