Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010017.outbound.protection.outlook.com [52.103.72.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA922628D;
	Sun, 10 May 2026 06:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778395446; cv=fail; b=PTH85O7LcNI2Ca7+k3ljwHvlMBeOhjoo8hbmjs6kWT3jRmV1YolxcCpXljv8Q4r44NHW+Lt9oaC9ekNQd1P5AV8x8CitaW8JvuktDdGqOQCQEUCYn52zQBFvRvJPKStBNJZbZP6xOnOtwN/ygkF+aEbYH21qxYnjQxsGDD7yzBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778395446; c=relaxed/simple;
	bh=dVYi+MwJ58RH5ctFzGIVA7CLG/g9Ux4vs4EojcbR5Ew=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=AmDQk2ORAYIvv5XAVEpcbGSNd25HYClVITDhaI3JQEamjTOUyRdPu5IOYTF4fsNdfvMJStVaoDTkOxBTv+OHEke785QX74684AyWG6/p0AJuwIIbo0js/D5f0FSMMtGLvYD+kaNFA3BMRwevPQfVdaj31vHC7w5+nZC4w7H6VZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=MQoIOTvB; arc=fail smtp.client-ip=52.103.72.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="MQoIOTvB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1AchztU5njkNIFw2MvBh74WVFFkkTmE+aWiBejHPcwp42zv/yqTSpDlaurFQoSnBL4nhAkXArS/GaM0RXg9cysRsLvPhbhGh5l0g/3vzO+mqmDGQsnzeZC/2d1l5H+WQex1nzuNJ+50ChjNuAB1sieaS7WSCE1nut8XzQMMpEwaM2mwx2kAVSn99b86jw7M7g6Tle46IZrupuyNytiDEgiAqmuS3ebg7+QEAc5ro/sl1t2lG0mU9MlTVLxIgsz3RxElXQow4pBGt3VYNjaP1mHOoYS1nPRFc1MEySSksIHoY0My9urHOMtpPip12PtuLxxknsv7bwBgmJOe7+Cn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bze0Gngje9GRivtCDoBtJYxOtyMjbjiSwS1KsIFk+8M=;
 b=fqsW/ZTLsqTCOnXNLECeeOAUsM5ZUYRmKZHcb5OVqRzuZq2cc6S0mqMRMa8lx6tAbynCD0IXBDA6wE0RSEpl1doWGvmGkYRU2gQ6iG3f6u7PKWuS+UbSoXrZkDhg20J/1ZGmG8lqyHHHtU3783RTqRNGaWNjN597NbR8Y+ctONkbL3sDpw2vCYqN+VSH0+FwZ8tVmGmMaDF9L9ATzh1yKMOeT8VfuaWIVIuQa7UfuJ/rsLGuOtIVuxg3Zh1jxRNj+USrstcVrIoHOpSrdVBZ78q0nMI3+K7ZG3j9mGk0U1YfC3XTui48viSzj1G59L3v1u/MqWqcWsMb4xVTIPRIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bze0Gngje9GRivtCDoBtJYxOtyMjbjiSwS1KsIFk+8M=;
 b=MQoIOTvByqT35+/t1OoLzU2wGgwLvUHvMzpMF7AjuqZ+kca5WF7LOXE2QVTCqLTuI632ww/UV+lHtNa1jFIz+KvNzvV81IXPY/W+tIkkSBhNHry1DxH8mM7feU1UbkjHVpQuAdjnJJM6JfnOESd2PGtEXd+iqlbnWNEdjdYtibys88ue6I07aeR64cjr8RB/rNa0b2E5vyeVraX+yVZM36WxGswkaSQ8wb3uXcdnEmWWOCN51VYAInSAhtvy3hnNfWiIQjcui7SXcllfkiGfxe/ANLaN9S+NzbFXOxQUVXcpVM7ojROJyOfBOihMXbB5y8yen8wvIs14wHAS0Gks3w==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY1PR01MB10628.ausprd01.prod.outlook.com (2603:10c6:10:31b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Sun, 10 May
 2026 06:44:00 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%3]) with mapi id 15.20.9891.020; Sun, 10 May 2026
 06:44:00 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Sun, 10 May 2026 14:43:24 +0800
Subject: [PATCH] scsi: mpi3mr: fix out-of-bounds write in
 mpi3mr_bsg_build_sgl()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB7881B11E32668EA113475980AF3B2@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAAspAGoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0MD3bTMitRi3UQj4+S05BRTI9O0VCWg2oKiVLAEUGl0bG0tAOVKLg5
 XAAAA
X-Change-ID: 20260510-fixes-a23cfcd525fe
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Yuhao Jiang <danisjiang@gmail.com>, Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1552;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=dVYi+MwJ58RH5ctFzGIVA7CLG/g9Ux4vs4EojcbR5Ew=;
 b=owJ4nJvAy8zAJVb4wiKgu++DA+NptSSGLAZN7pRzC/tZnyq5ucvsO6x1RMDzQaK9/OK3S35+m
 Vr1efE1xeaOUhYGMS4GWTFFluMFl75Z+G7R3eKzJRlmDisTyBAGLk4BmEiGBCPD/9b8RZnbaxdt
 zu1kZNySKLp4y6VNm++wFE40XTFDSHT5H4a/4vsl96sxZ6mwS0dUqnz8UKHDyPTo1exrvHsv611
 c4fyRBwC2eEhH
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TPYP295CA0025.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::15) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260510-fixes-v1-1-554b1ffbb390@outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SY1PR01MB10628:EE_
X-MS-Office365-Filtering-Correlation-Id: 81ebebfe-122a-43bd-5b9e-08deae5f843c
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|23021999003|19110799012|8060799015|5072599009|55001999006|6090799003|5062599005|24021099003|51005399006|24121999003|22091999003|440099028|3412199025|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VWxOSFNCa05zNWc3OVhlUlByVk93ZFBiMldyZm9sRDRReG1GMThIY2FpamE4?=
 =?utf-8?B?VE5oNUZ2dk1BbU44SXlIUGF4K3ZYNnpnTU5CNXlSMkFsZW0rQnpEbWpEL3Zm?=
 =?utf-8?B?TU5sRG16K2hqVS9tdU5oM3VjVk01ak1VNkNqV3ZmbXZFc29rTXlWUmdZanN2?=
 =?utf-8?B?QmlKMmQ3QTN6dlBQdEZIUW00RTgxUmZzUWc2ZTRmYzFOT1BVWEZ2NWhDQjJu?=
 =?utf-8?B?eEZISDJYaUp0ZUYxZCtFQy94clVCYXFyL2d6YlArTGNQVHdQTkdWcEZ3ZS9t?=
 =?utf-8?B?ZFR6aHM5U2dSWmVKV1Yzd1pqekZVRERvR3VIemtNTGhoRkdadzhVZi9ORWtH?=
 =?utf-8?B?S21KbEQvbGhVMmh0b0p2cVl2Rm9TQTRHZkx3YmJjLzVEemFwVHJ5MTlWKzhz?=
 =?utf-8?B?NGI3ZHk2Y2Zjb0NPRXdKNHRyVWFlakJub0ZCMGJWc0lCRGFUODhtNVpUdWEx?=
 =?utf-8?B?cyt2NjlMK3Z5QzFqNXVVVW1yV1RIVFdZTG10bWE2RVh4bEFDNm1jeTJLbm9M?=
 =?utf-8?B?cXcyNk1MK1AxaHA4UWtVR0ZscUJnNEdlbENObUhPb3NTeHJOV1RPSUNwSXhF?=
 =?utf-8?B?M3dUeFQySlNhdm9MdGxRZVkvOUFwRGxoc09JVkNxOGpLc0JHbENxWlNxYi9P?=
 =?utf-8?B?cUFuZGxSSW53ZTR6VDloOUgrNUN4SFBlNDNSZnp1L2t6TzIyRHdZeVZNdVlS?=
 =?utf-8?B?ZU9hcklPN1F2TzJ2cVBYT2JXaE4zY2QyNnZneXpUa1k4TFFFVVRsWkUwU044?=
 =?utf-8?B?SkFZekI0cUkvSTkxVll0dWtFcDBEZTFUemJUUytGWmdtbmR4cUI1T1JJNUxK?=
 =?utf-8?B?Um5KdzdLa1VqT0d1NFJQZlBkY3JOTmhCTlRKWnRNNDlKODlTU1VXYmx2UUJF?=
 =?utf-8?B?a25WZXlSSE85NEoxVGVVeUIrZjJFbk5ENXY4VEl5a3VTYzBLdUZjRVo5SVpV?=
 =?utf-8?B?NTNOMWpSZUQvdnU1S0Z2STFKQmxrZlhKTmJDajlzN2t3bFJUdnF2eW5jSkZT?=
 =?utf-8?B?UStOV21TM1FmRFlsT3JHNDRuem1JRXg0YUNoaTJjL1dsQ3Y5TGZWY0hxcStI?=
 =?utf-8?B?RXFRcWlGWFRhZytEdWdBdCs5WFVCWVJUNmJDZm0zRmJmc3MxWGJNYmhhd0sr?=
 =?utf-8?B?Wk1BdW9HOTMzLzA0aVVyc3gwVWRjQXFvVDlHd3V3WW9SclFJM2dORGtNWG1T?=
 =?utf-8?B?NDZFbWlkeW1BbzJNSUJSQWVkY0xIcDd5N2ZMeXdBZVp6R3VSeXRrU0NTMUVF?=
 =?utf-8?B?UjZKTVZKelM4ZXJxdTNYL1RqYjJHemxqRXE1cnllQnBZT0p3QlNHdzFZeWsr?=
 =?utf-8?B?bE5rbmwvRXZVdjlmQVJoVElkcFh1QWtoUDRubDJ1bW5ZeXJMa21ML3lXSUxt?=
 =?utf-8?B?cmx2a1A5UE9lOVdHUmFyWGl0SEhXZ051ZXdZV2g2R0NNeG9PbnQrRDByaGV1?=
 =?utf-8?B?enVuOTBwdTFUaGtCZDVFYzJyM2VuWVQ5R1YwcG80SnBmS0NHOXVGZnFVUnM0?=
 =?utf-8?Q?4YL3LqkCjwiyu4+N4rWPT0vE1NI?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWVITHM3VXpZa2xZKzk0ckp3dVdtKzg0djZQQU1nbVRpWkVhNGR3VEg5VjA0?=
 =?utf-8?B?UGF0S1lTMDdVMENMUkVFVXF3VGFWVUdFcU5URU8zb3F4akQ5WVcrM2NPOWJJ?=
 =?utf-8?B?eE9aUVZaM1Jlb0gzajg5M205SEgzTC84ZnhuUDhKM2Z5a3JNOFlLTjYvT0Jv?=
 =?utf-8?B?bHZ6dDlxd3VYeVM5WUdyamwzWDZQZklmOVZMaS9JS3NRWnlvdnFuTXBlMmhN?=
 =?utf-8?B?dzBYTTU5RTBqOGNTWEcwcC9yMHFvNlI2Z21MeDhUMmNqSStQTGRqM094NU5l?=
 =?utf-8?B?UWppRG92bzR0WGdIWklQVWYxLzhPanp5Y1ZzQUJlZUVFdEo3b2lGREFxZ2lz?=
 =?utf-8?B?ZGFTaVZ1ZVFZazJORFk5eVBIa3VzeFFiUi83UFAzQVAvd3dYTTNvcUhndllu?=
 =?utf-8?B?eXVmOHcybGQrRW0zR0dWK05wdmZpZ09EWVk5SWJIQTNYL3V0N3lPN2Y1YWVp?=
 =?utf-8?B?UXZXKzcySWE3cDRhVFFqVzZkOVFPOXI1Wm9tNEd5ZkVndExPYlV4R1VQMnQ5?=
 =?utf-8?B?SURBRm13dk9qa3o3cmJOU2FSNzk2LzNraU5EQnZGbWxDV3JnRmVNNy9ZV0dN?=
 =?utf-8?B?VFVXcHFadEROYnVZbkNXWDRaV2JPM0tTVnpKbUtnS0RhenRmcU1aaG5BeDZE?=
 =?utf-8?B?M1J1eVY3RkpTanNncXh2NEc4Sm5sMlNwM1d6WWNjOXlmVDZmdE1EVE5ZcWht?=
 =?utf-8?B?YXNlT1RZa1NHZjBocG5MTG5xYm1tYnBkNGJweTlXNTRuZWlyNGYzTE1UMFVi?=
 =?utf-8?B?Z3NCUi9QNGhMQ0o1TGpqWU95OEVyM3RtVzVST1QyWkZ4SU54bWEwQUx5WW5P?=
 =?utf-8?B?RVhaanAzbVlOcFdqK3NTa0Q4ei8wUVZlSHFJMU4vd1VPNGloaWxxc2F6dWpu?=
 =?utf-8?B?ajZ2am96b3RweGJXZk5MTjFlY0Y0WTVWWEozMHA4bmhuZjFYaWpJd2NmY0hI?=
 =?utf-8?B?MEpYUXdIYThjYkhjTkd3ZXo3cTREQlNqRU5rUUF4ZFhFa1BBN3Y3dFR1V2h3?=
 =?utf-8?B?MDRVVnhYZFoxbFAxR3RSV2JwWlFYNHhVRm5aeTdKa2s2NlI0eSs1RE10Umxv?=
 =?utf-8?B?OG1UL0ZWTUo5K2pZU1BWb1Q5ZVlzYWVYSHdTUkRUa3QweEZIdVkyR1pLbUV5?=
 =?utf-8?B?S2g5NWZ2TTFaYzJGbVFWRmc3dTF4bnppWFVWTWpsNzNpRG50YU82SWlDMGMz?=
 =?utf-8?B?bTc1US81NDFSTktNWDdOcnJqaThUazIzWmZBMzdiV091cVlLOU5CWVE1R2ZC?=
 =?utf-8?B?SHhMWlZ6KzBWSG1wYktuRlcrWDZaNkVsdDA4d1JkMi8xNWFrTUNWNG5OZGpG?=
 =?utf-8?B?WHVZVXAyTmR3ZlpTZXQ3R3ZwcjZZOVZzTHc2YnZMYkpYWFh6ekFJcnhNeHQz?=
 =?utf-8?B?UytNbGtpMEtUQURLenllUnM4bUpRMkZnbUZzRGtSTHBHMzR0UVNLeTAzZXRk?=
 =?utf-8?B?OTdubTFKZkVOeFNJRzhmNldWenppc0p6ZUcrb2EycVRQck5Tb1FKOTVsUFgr?=
 =?utf-8?B?UDB2Umd4Y1JpU0RUZGJCbFgrUHpWWXZtbElaY1N0cm8xaW1oeGg1V3RXd3lm?=
 =?utf-8?B?NHF6ZDdGajhpQU5yMkwxTFo1YmV6MysrcnNxbUVVd3RyUlZjQzJVekFWN0tM?=
 =?utf-8?B?OUFOYWZTSiszMkpPTGJPOTE3azExbVlJQ1o4QitpMy9JU3BKVDE4UDVjM0Ur?=
 =?utf-8?B?NVFoMXFqalpGQTBMOEE0cTZNNEo1NU0vaDNMV1V0Rjg5OEZOdExpT0Y4b2V3?=
 =?utf-8?B?ZnNYRFlqUE5FZ2VyeWFRSzFYWU1qUjc4YVZidzRNblBtMUE2SzFHa1cyUE1j?=
 =?utf-8?B?Q084UU4xczdLRTlNWVdSdVUyUWcxMHpMUG1qeklESTQ5NkZVYlpDUHYrV2Jy?=
 =?utf-8?B?ZjVrK1pkNENnY1hjaVhFMDZUR1ZITVlHdHZtRm9MTGJna3c9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ebebfe-122a-43bd-5b9e-08deae5f843c
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2026 06:44:00.2017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY1PR01MB10628

In mpi3mr_bsg_process_mpt_cmds(), the RAIDMGMT_CMD path sets kern_buf_len
to the chain buffer size but leaves bsg_buf_len at the user-supplied
value. When bsg_buf_len exceeds kern_buf_len, the unsigned subtraction in
mpi3mr_bsg_build_sgl() underflows available_sges, leading to out-of-bounds
writes past the chain buffer. The analogous RAIDMGMT_RESP path already
clamps its buffer length via min(), but the RAIDMGMT_CMD path does not.

Fix by clamping bsg_buf_len to kern_buf_len.

Cc: stable@vger.kernel.org
Fixes: fb231d7deffb ("scsi: mpi3mr: Support for preallocation of SGL BSG data buffers part-2")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1353a8ff9c85..2e44a734a573 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2628,6 +2628,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			       drv_buf_iter->kern_buf_len);
 			tmplen = min(drv_buf_iter->kern_buf_len,
 				     drv_buf_iter->bsg_buf_len);
+			drv_buf_iter->bsg_buf_len = tmplen;
 			rmc_size = tmplen;
 			memcpy(drv_buf_iter->kern_buf, drv_buf_iter->bsg_buf, tmplen);
 		} else if (is_rmrb && (count == 1)) {

---
base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
change-id: 20260510-fixes-a23cfcd525fe

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

