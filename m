Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011060.outbound.protection.outlook.com [52.103.72.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3C71DF256;
	Wed, 22 Apr 2026 09:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776849531; cv=fail; b=bqgBeyklYOo7vDG27ehp8xR9cQ+DN0gbrYZa3VccH3EaxVI+p0mK1puByzh66zik+k6VDoH3LVbjyJf93cG8o4Fvtqx79NNsAyqbxWzCYTS35QEC1RCsJLQ75CHwTxRqFoh3Hg8fuO7akaP7ejlUXjvCsYa/7kkFs6OuJZ8LJnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776849531; c=relaxed/simple;
	bh=vDHsx7Klc9kUM8rpdCwWGoOzM/1Cxc8+OCXarCPoDIE=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=nBvHahd/ptA8u0lbTNWMYCMgCxda+ydNF/l+EHnJP11d3BO1Eq3W0Qho+OyZYUG0oSRNNZo95zdWW88roXLLxY3arb3OehBm7Ylvzz5ONSp+5l7h4LCYeF8M16yOcQtAjzaTSEYD/lyxSkn95YQ5KUwRuh0abKJydEbFIGA4hog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=HUcR7dH3; arc=fail smtp.client-ip=52.103.72.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="HUcR7dH3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hWeYomxEev1c/s/Yd2fedOqu85QW/2ETr/Ip72SMEHJhFUhpQPSSdPZEZ7LJzwhRqNS1447Kxi+3yUBBj7TPERlscxO06ys4PsvFGj7/0mgjRrbil6qJD9Uhp2jt9zftj0eeTME4v39NNGas2BGoYtdTXlccVMhMVQLgeMvEws2qknr/FJaijeg1MzXjS+6VHZiGFg8uxMdNSSB3x7DAHp3A0mE9t1Prjsholpm5/WN54+hWG6o4sqnU7slCH86qBRBcKC7/SSrYZ3io40HXOPmuHPqihB3WSKDWyls75kZL4Y7DLkaF9mNHSgmQjcXGa2yMEyzZnA/stVu875MEPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtBVJ9D48OjKEh2tZ8iWNEFiYb7UAmAIZEZzoEz+o7U=;
 b=KOdbIfVADb9fq6ZjUarH06IXgDkAFxQ2loeh2alXrEwFf8T8bIGGlrNTLDqUdfOVFriOVYnBXW8e5BR0Vk9o0IL+udAjCqi8OGfUUAZtLkEIKmVrggH6tbNB69XqHq+xsajTY6euQGUeyu+VbGhaijd17ELwK9XIDLv4YN1rUNdpclcfHyuziD0+FXglte53umgcEBOElbUWzc6chJT9vUsBkSEL6n3Me4dXcURO89zMrPE8pRrgnO63kKXEZLWoAIAmy7LNZIbNpkEF/bh/lhhDE28FcLN+51MJJq7BThoqUxWNbE2lemLusSTRdl+DPC3vPBMxELn0JAi+YdfX+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtBVJ9D48OjKEh2tZ8iWNEFiYb7UAmAIZEZzoEz+o7U=;
 b=HUcR7dH3AoHniQzf1gMZIU+N4nUNxUY7ChU33R6yhXlzw9o6Dmhq6iikXXEQeR03FacV1ElYNqeb7x1mmKdj4BTnthdTg4L8lI/TEuLpe2/qzmA8OePM7w0Vb6PgxS2aHoHL4wte3CSTkqNc4phnmPWCtjQ0BnHDsFWyyA/UiAs9sDS6J8JmZnZdmH1uq9lJjco0GuIsh29Mxcw8x5Lg4HYWeef1pnUGAiO4mAVO/gqmPPTinTTNvXKe+1vzhTNUkVthZ+eq57YC7TQeWLQ/Cf8v3thfIMrKEbUgdZCv0kE6g7ni8jQ4Jg4i8p7el6Uka+8NaY11ASate9eOF4RHJg==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by ME3PR01MB5735.ausprd01.prod.outlook.com (2603:10c6:220:ca::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.17; Wed, 22 Apr
 2026 09:18:45 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 09:18:45 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Wed, 22 Apr 2026 17:18:02 +0800
Subject: [PATCH] scsi: lpfc: fix heap overflow in
 lpfc_bsg_diag_loopback_run()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB7881DCD912ADB83C9D290F7AAF2D2@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAEmS6GkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEyMj3bTMitRiXZMkk9SUJIMk81QLCyWg2oKiVLAEUGl0bG0tABXmYKd
 XAAAA
X-Change-ID: 20260422-fixes-4b4edb0b7e88
To: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 James Smart <james.smart@emulex.com>, 
 James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yuhao Jiang <danisjiang@gmail.com>, stable@vger.kernel.org, 
 Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1446;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=vDHsx7Klc9kUM8rpdCwWGoOzM/1Cxc8+OCXarCPoDIE=;
 b=owJ4nJvAy8zAJVb4wiKgu++DA+NptSSGzBeTPCd1z/rwVKPHZfaF/dOPO6Q9ZlmW1MoZv0o10
 On9rOvJNhEdpSwMYlwMsmKKLMcLLn2z8N2iu8VnSzLMHFYmkCEMXJwCMJEpjgy/WS24hJ5qVOb1
 TJszb+/GH5IPX8qcWPxkv/NuizgL1tpkE4b/ITuTkuc0epmenssx70aaxOSJmRu6redNDF/fa+k
 pIdbBCwBIukr9
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TYCP286CA0361.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:79::17) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260422-fixes-v1-1-702b116fbd7f@outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|ME3PR01MB5735:EE_
X-MS-Office365-Filtering-Correlation-Id: 340f6d03-6cdf-4a96-c343-08dea05026a7
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24121999003|22091999003|5062599005|8060799015|19110799012|55001999006|23021999003|15080799012|6090799003|5072599009|461199028|52005399003|40105399003|3412199025|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VFZEVlRvZ0FZQTVxSHVmUW9VenkreGFYTnBNUEwrVnd2QWZ1eWFnaEV2MWhI?=
 =?utf-8?B?aDJwUzJNQk9nNmIrVXZ6NjRPWlZVQVZBcEJESnhCRTFtWlJHd0NSa2NtMkNC?=
 =?utf-8?B?MmpWSHVNK0g4WnQ1L2s2c0J5bjl4c284QU84L2F5ZzBWOWpmdElZTno5QkRO?=
 =?utf-8?B?VEV6b1crWmhVV3lOOHVjTGhmai9ndHR4bGE5TWNBNmdKeUhod1lFT2haZWpS?=
 =?utf-8?B?NEdlaWNTaFNGbHczOG04bVh4RHZwNThmaFZhOVlQU0N6RXU5MHpLaVFvd3FR?=
 =?utf-8?B?YUVrVDVudkRnVHJWQzRabzZRWTVlcnhjK3lYZHZVdnJYa0FxMTNTaExpcENO?=
 =?utf-8?B?NnNad0FKd1VZdVJPVFJPUndEUEMxdWFUV3RGQ2dyVDYwYTg1ekJDK3pKNFMy?=
 =?utf-8?B?MDMxY0taL0FFMG9FTDNhb1ovTGIwN0tSSWZoODFBZnRsNmt4Vnc3d29UcEZ1?=
 =?utf-8?B?UXlLR1Bha3dNSytMYndtWDBNU29qNUtiOVU5Z0NoSExDNmdsVWVtL1k3bGpo?=
 =?utf-8?B?aVNja1RjUUh3ZjhqUjQrZWZlR1RaSWlqa08wZ1lYOE5MOXJQc0xSUVVTUW01?=
 =?utf-8?B?T2hZWUpuMi9tZkVRSXd0R3AxNkJMRkhoaDROaWYzV0FXZnJONnRRTm9iczRS?=
 =?utf-8?B?RzA3UHcyeUdIS1JOVXZjTHZTMHZMMi92MnJEK2xDWS85clk4UDI0Nm1wNG5C?=
 =?utf-8?B?UmV2Y3lkYnF4TUxwZjFMVnE1Z0tSRHBvenBHbll6UlRYNXVuVlVVTEZkQWtN?=
 =?utf-8?B?Q3BNU0RMeEZTcFpGM2ZwY0VSOUZJcEFQTGtjeHUyYnU3ZWpML3Zmb0xzbkF0?=
 =?utf-8?B?aW9ENzhwL3R1QU9aQnJoZ2RwbCtaRFh4YzJrMHdGQjF3SkJLRmRidTQ2QlQy?=
 =?utf-8?B?a2tJZjBYaWhGL2dpNWljcUpHV25FYmE1MldENzg3N0gyREZQcC9qUmJocFp3?=
 =?utf-8?B?cE10WllyMVRYQm8yTmhRQUE0Nml5eGRIdmwxdVZpOXdpbFJjVFdlWE5GZS9K?=
 =?utf-8?B?RUhNUmVnSjFOeEg1aUphcTdsK2Y1eEh3aHJLSFJkaVlna0NMWUl0a1VjQUw4?=
 =?utf-8?B?Y2N6eWIzeXh4K1NNd1k2NjBBVVJyNk40YVlXbWtUSFl4YlhJcWkzeXRrSzND?=
 =?utf-8?B?YmJWeXI2bUpOQ0o1WjQxL2tXUXowWVFTQlZHd0wvSWNkVmNRd0xBN0ZOYWpI?=
 =?utf-8?B?cnVQUUtDSDNKTWFnZURXMU0xRDZ5SVFFSVNjOW9rU2tVdVQvUjg5Y2E5RFRz?=
 =?utf-8?B?UnhJVUxrdEJQVmZ4eEtjdFhJcHhnV1NiL3hKY250K0lkbmxteDVQbHVYY1pS?=
 =?utf-8?B?cU80MGF6Nys5eWZ3NVQxT3BQeVFERnJGaEhyNm1HdjVBYm5Xd21XVTA5V2Fs?=
 =?utf-8?B?NFZqcFJHZ0QzU2RsdlhzZVRaOVB4bUhralpRSjNRZS9sRnFHck1GYVBEY0Vy?=
 =?utf-8?B?UWdiQU9jWWRnQTU0d0lGRy9kVndKVzgzWDFVeElBPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0k5aHdzQkdLeUpNMytNQU5Fb0VDT01WTFQwYmFDUHMzeG5TTk41aTkyejR6?=
 =?utf-8?B?ZnVacW0wNkxZN1NIY29BTm9POW82WHhoa2UzSk00eEsyTUhoZ29odkVkaytq?=
 =?utf-8?B?MDFMQ2J3dFVXVmdOQ3lKVm9MZTQ5UDYzdzFTVWtMNlRpSFpMOW9ueHhUbUhT?=
 =?utf-8?B?YkVPQ3JUZGtyQWhJbDRreHJIZ0FMNWtvSHd0U01CcDExY2JOSUlLc2VFUXhH?=
 =?utf-8?B?QThXdzhIQTU0TS9DRWI1a2Q3cFVVM2ExS29MMVFwRTR0bm9QeE9tZkt2TFdV?=
 =?utf-8?B?MFdaUktYSEZMWWFRb3J2YldJTm13aVJsM2c4SDZUZ2pScWE5N3BaQW9mMU9k?=
 =?utf-8?B?clRwRlJuZm1VaUhCR2x6RHRoS3F6UHNzMjFYSUxoQUZvYUNxdjdOc2xWakF6?=
 =?utf-8?B?RUVJWVlkaFVKdjUzYnVRNFRIRUtBdW8yRlF5aXNqQnlPNjFZUkl0WGtwcXpu?=
 =?utf-8?B?azhhKzhpNzh0RjhoUHpzWmdjaktnTEYxQ1ZPenlPSWNxSkx2cERNQ05oeFVL?=
 =?utf-8?B?alVkakMrZWFrYUkyM0d0aGJrLzlrNnlDTUNsSXBhOTBSUE41QTlNbmlrek0y?=
 =?utf-8?B?ZS9kdXJJL1NlWUFTMDUwNk9JajlFVmMrVU1TZ0dTTUZDT1BlajFvRnpGYS9F?=
 =?utf-8?B?MysySmhrNzBseHdRVTRmMk9rb0MxNTdqS1laalVKZ254WHB2U2FEcE1IdlBs?=
 =?utf-8?B?SFkza04wS3IvY2MraG5SZUdTdVF6bUgvNmIwV0hYbTZBb0JJSW9SZ3N4Wk9p?=
 =?utf-8?B?OWZaVjhuTkExR2hWU011SFhZM2QzQmJzNzVwbjRUdGVZSDBJQU1na3ZaMThI?=
 =?utf-8?B?aEVEcGcxVnJneG5xV0MwaU5hbjNOQTJhNkN1bHF2dVNYKzNDbzhQRnBjR0tU?=
 =?utf-8?B?WkV0SnBYQkU5ZnFBVTJJc2Y2NGthWVp3aFY3aVRYTkpDMEY2bUo0MFprc3c1?=
 =?utf-8?B?ZzhMNHB4MWFOb05UYkxZL1ZzUjA1M0ZsbnF2V2g0cldrRkZ1TUoxTUJDYVVw?=
 =?utf-8?B?U0syZXhEUHpaM1grQWdOSHkvOWwvdkRUV3phZExmWkNiYzJuRTVYMlloajQ5?=
 =?utf-8?B?SSs5VGZVa05Ka1hDMVdHWUhVRjBhOUcwUCtSRUlOUXc3UmM3TUpGKzdFclVV?=
 =?utf-8?B?VkF0aXp3OWF3UFZJUzVRUExXaDhFVjdsUnZjMU5HZEdJNkxLQjRSNEVZWkRm?=
 =?utf-8?B?cHNWWHZVYVRrNHIzT09yNHdUbjBrbXNabTN2anNQalF0QUZGNEljZlc1NG5o?=
 =?utf-8?B?WWkrQXlsOXRRQ0wxc0UyY0ZmWUh4eGtSa2J1dGtyZWZGaFljcmZPSFZLWElu?=
 =?utf-8?B?dnAraFl1NGFOeTFzeU5rSFY5OEF0SllHeHkzb01pbm1iY1A2U2I5anNjaThI?=
 =?utf-8?B?M1F2K1FXUWlBbzBLOGRqTUVFSUt6aU1ZcGQ4YXM0RG9ITFFyS2Q4QnNwS3I4?=
 =?utf-8?B?VVZ5bmhTcUdSZ0N1T2JIai9iYk9vd090SFB6bkVXU3Y5YkM0c1VRc1Y4YzM3?=
 =?utf-8?B?cHBrK2JEb1hMWXNDVmZYVzd4cS9RZjRFM3FaMW1HZW9mVmNGOEtCWXQya3c5?=
 =?utf-8?B?MnQ4ZFV0dmlFMHpRSmFyYW1xeWVUTXZTelhXQWhpTkJuR0U0TytJa3hKZ3Zq?=
 =?utf-8?B?RmpOalFEQW41THJMdnVPLzdtcStSU05HUjJTZ2hsMzBlKzZxVytzRURaZ3d5?=
 =?utf-8?B?OHQ5YjdhYUFWVTJVbXlnKzVyN1Z5eVkvNm5nelNCMlF5ODZIT3BBTnMvUTNp?=
 =?utf-8?B?RkFoazVkWG1zUXk0cjFoanFLQThsNFRpWHY3TG1sdjNTdFRjUHpVc3hoUjg4?=
 =?utf-8?B?OGtsSHl1cEhxanRpdHhOT0YyVExXemJRVVpsT3hTaVMvVDBTODBJVE03NW5w?=
 =?utf-8?B?RUh2TTMzWTFyb1V1cFg5ekp4SFc1d1JDTWduZWpjVDdWWGc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 340f6d03-6cdf-4a96-c343-08dea05026a7
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 09:18:44.9700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME3PR01MB5735

lpfc_bsg_diag_loopback_run() allocates dataout as a staging buffer
before copying loopback test data into DMA segments. When the
user-supplied payload size exceeds 64KB, the allocation is capped at
64KB while sg_copy_to_buffer() and the subsequent memcpy loop operate
on the full payload (up to 80 * 4096 bytes).

This leads to a heap buffer overflow with user-controlled data.

Fix by allocating full_size in the large-size path, consistent with the
small-size path and with diag_cmd_data_alloc().

Fixes: 3b5dd52aaffd ("[SCSI] lpfc 8.3.8: (BSG4) Add new vendor specific BSG Commands")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7406dfa60016..83fef256f324 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3111,7 +3111,7 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 		if (size <= (64 * 1024))
 			total_mem = full_size;
 		else
-			total_mem = 64 * 1024;
+			total_mem = full_size;
 	} else
 		/* Allocate memory for ioctl data */
 		total_mem = BUF_SZ_4K;

---
base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
change-id: 20260422-fixes-4b4edb0b7e88

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

