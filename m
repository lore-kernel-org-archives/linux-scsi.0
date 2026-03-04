Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazolkn19012066.outbound.protection.outlook.com [52.103.72.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC5D214812;
	Wed,  4 Mar 2026 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772639010; cv=fail; b=rNYkez6tjypVDqkqj63pVjZa4T9pa1wZmnjFxhe7vIMHIvIpBVjl9jwULq68UzhdBiTLqqS1Ncc3Ffvbwsn+iXcQt1ONitWIjvZSOCc+7V1RgfQt7RP6mUZNBUzmCdxQTb2YrKTOAL4v+1oxEh/9h0AL0rhJNQBe2KfgeGXinsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772639010; c=relaxed/simple;
	bh=CZ4bzrc4ZKnRa9yiEiY63tMsCAEXg++vcUPgFs7WAcE=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=oB5wTUO/Qu7xFgWQEv30QSQm6rT3ceUhAsw2l1cjasu2SM0dJMPS1LMLZy5fDYMt7akjgC6AXe4YS4OwFxgWbQFw9iCUEmbdr+8sMaVPmgcQHU4OhwaHKnG5WIn2krU3jqjivSwekSz+eQLETfIPtqLMlav1JJchkeACxIzdrDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ZFz53OK+; arc=fail smtp.client-ip=52.103.72.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ZFz53OK+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kdm5n+0uy2qSuUcKaEhVjPA9N+TPGY4JQweYIq7d7L/TL2hM+5ysuqgbOM/uPyhlYRAjoACsiXhG3pX2ICA4zo3zjWZkWeUs4e2xckAudK2zeZzid7Qe3wFBTwi+6e/QtulU0CY4MRZt8Z6Qy2QmiLCyFxTKZ38uILHpL1m3Txjsvtg5QLegeMWpn54rnel8X8DpmJmB3L37MHQ+Zwgw5rl5FZKa9XrWCtNNFRWnT3GG9t17lzHOP1q+6uuCe2150oFEDvne8GcL8Ee0s4DM5uEDjjlSL+nkAsWrbgQcuGYIgp1wS8w1WwW5IyRbE3zNLAh7wWcI05D9ghK5eJVMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qqrMpt8f8DBziKMW0CT8VVmbl2IhGuLd1wmKqrFaSk=;
 b=sbh66vcHyFRvDZJ4CUCcbkIXYPU0jxbU7izAAM2xD9LFw2odgrZQUZ6lqK7LQ1NglEVfaySjLL03EkG/g5lJYLeW6QhjgkofsqvhHnNkZBzmZ/I8/7JsEwnFGvPc4hgUDkatOHm6hjO9dLXxlDYUyx63GDCd+/9yn5+Uy6GjfVaQunLkmTJhtNEG1VPDBvAUGDfystygbq3gh7uCZebVWrhODX4CFufW+o248MATmA5Bdc3YHDSuKAUiXHrd0cauCZUp7AefRtL39n664eSkRk3IEMDhCP7z/WBD5YkgFgBevxJopce5q2U+ma1Y1mQbspj6lQremhXBAizbYsf5kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qqrMpt8f8DBziKMW0CT8VVmbl2IhGuLd1wmKqrFaSk=;
 b=ZFz53OK+5E3HNrq5s+iRV76Rf2xgT2uDfKRSsHstc1EUfIGNWhXOS5e6SJPDbWqBKE/x7aln2TmJv3c0xGhedDbbyyVF58+abvWCB265PalzM749Esu8kluf+W0U/vOBmCO2NtT5WWogAhIY70pN+aaUJn58ad+Njfz+s00pLgKe4n+jcSnq+0hjq/hwhWN0Rxaiy6hytz0f/pqQ8nqVYdWmIzsO9Hjgi72iSr/1452oXk1ibcRp4O5NJFcYOsUGP4jYPy7n/14DroMlCgsmmsXGYUh9IvJk3YL6X3BlzDtous0HaAubwQRuEid+JHxlDKPXzdvsI8sdGJoNCyctjw==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by MEWPR01MB8802.ausprd01.prod.outlook.com (2603:10c6:220:1f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 15:43:25 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9678.017; Wed, 4 Mar 2026
 15:43:25 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Wed, 04 Mar 2026 23:42:58 +0800
Subject: [PATCH] scsi: target: fix integer overflow in UNMAP bounds check
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB7881593C61AD52C69FBDB0BDAF7CA@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYwMT3bTMitRiXSMzi1SD1MRkEyPzNCWg2oKiVLAEUGl0bG0tACtp8Z9
 XAAAA
X-Change-ID: 20260304-fixes-268e0eac427f
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>, 
 Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1177;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=CZ4bzrc4ZKnRa9yiEiY63tMsCAEXg++vcUPgFs7WAcE=;
 b=owGbwMvMwCVW+MIioLvvgwPjabUkhswVweJ1B3imMFVmLFh3Nag2/o/IinNTtzL75K3IWXqi6
 UN94tyrHaUsDGJcDLJiiizHCy59s/DdorvFZ0syzBxWJpAhDFycAjCR+BeMDMv5tlgqNq2a/nvt
 pUm9KZn79mcyafZ/2RG19O9G5bITN3cy/OHV+fbKPVWucNqT3XXrv9R6i9+zPvcv8zfn+uUmVzZ
 IT+IGAA==
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TYCPR01CA0142.jpnprd01.prod.outlook.com
 (2603:1096:400:2b7::11) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260304-fixes-v1-1-160499fed637@outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|MEWPR01MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: 70b3de7b-ac98-49bb-e703-08de7a04c4c2
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|19110799012|5062599005|5072599009|6090799003|8060799015|12121999013|15080799012|41001999006|23021999003|3412199025|440099028|52005399003|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEpqUGhLaE5JWlZvQWpiUzdyMXBjYlVLRmFLQ2diQTZEd29lYmFkeTJnZ1F5?=
 =?utf-8?B?MUdTYjFRYTBWdzAraUZzQWdaNmxsaWNvbmpIc0NINXBNQXZDVGpId2lCc0ZX?=
 =?utf-8?B?bVJLaGdML3NFdCtaYkNreUJhK0EyZ2wyQWE1TWt5SG12dk5yZDFZVERoY1Mr?=
 =?utf-8?B?aUJBNWpKY044QU12TVB0RFltcUVUYVdFVzlheEo4d0FnOFhXWnBxNXdjWWw5?=
 =?utf-8?B?aXgrK1dyQ2N5eVpxQUF5R0J3d1QyMENwRWFWNnpDeldjRFdpa1EzSXZDU1FF?=
 =?utf-8?B?cGdpbVlTU1UvbFc4NWd3NW9zRlRaZzNXR21DMGI5cWo0cE0zRlFPTVl4NGo4?=
 =?utf-8?B?dHNRdkVFRThMZUlBbFoxR3JFT0NEcmorRG1TQ1VnN3E3MlRwQ2swMzhDYkJI?=
 =?utf-8?B?YmlsTGJsQktiUUZiSWN0U2VFT3FENjJrWHl3QWxpSWhSM3hYSmRGc0FLMWVI?=
 =?utf-8?B?clBrd0lnWi9kOTVBSERNUG9sV0Rlb1ByZGRXRVRhc0NIVmphdi9US1pYWjBR?=
 =?utf-8?B?aXBCYjJDd3NhOUo1c2NSaUxvR1hDQXY0cEZqOVNPdlg3K000RmZIamVnZE5Q?=
 =?utf-8?B?a1hrZVNpenFmWDVpV1J5UFpjYmQ5alRHd2tmMHVjcWtsek9KbkhsR0lKTEt5?=
 =?utf-8?B?VmNzSVRKWU10cGtaVGhRNDRNbzlpOVlJQ1l6VU1SV3VxeXZzVGtGaHZSTGQ3?=
 =?utf-8?B?azhjZUErL2ZPVUtqVUJWeTJoVXVhTUVjME1Wd0JXTFZ4Z3JhZ3pkbnN4cmxJ?=
 =?utf-8?B?d0ptL3ZHeWtic2thbk1MMyt6bmF3WnFxMmx6SmFENkFIQkNhMUtoZXZ3MzEy?=
 =?utf-8?B?bnRWOHJPSW9OaXZ2SnkvQnJ1Rzl6NWkxUGdpUUpDaXEzODVjM3RHUVhvNm5v?=
 =?utf-8?B?b0tFTEcyOVMwR3VFOUNUblZPelIzeE0ralAyWGZGcUd1cnJKM3JMMS9ldVB0?=
 =?utf-8?B?K0VxMmp3VG94QmkwVkxCUVNRL1NjeTNJQ1JUK2xTZ29hRlk3ZFZoKzBycTVY?=
 =?utf-8?B?cFVyY1ZXNlhMUUppdlVKSkdpZzhhQ0RhWDhSNUlhOVdIN0R3bHpZb29VWG04?=
 =?utf-8?B?Ky9LWjZxU0k2eHhPLzNwYWxYVEt6ZDNJNlFCTmo2UTdsMmhaK2dpcFhTWXND?=
 =?utf-8?B?cFdoWHRsV3I3UVFEZXJzZHM5SkNlNFZSU1VCT2ZzcUdBTG41NDhLbmdMdm9s?=
 =?utf-8?B?Wnl3N2VOZExrVGREN1dJdlBCdmZHcXpiQWJrTThqdXhEOWdSRWVqT2NrTDVs?=
 =?utf-8?B?L2s2QS9PTW1JVjkrZjUyUWQ4eTlLS0Q5MXpLN2xKNHhZV21CeHhjTlRUV2Vx?=
 =?utf-8?B?cS9ma2xmQnFrT2xPQkFaWEdaclVBak12MDV0RVVXOHBUZGxNa25ZRHhSdlNx?=
 =?utf-8?B?WUhBNEttK21XRHo5QVYwS1ZUdGFJVndTRjB0Y0RYZ0JWeGZZRDduMVBNVlZP?=
 =?utf-8?Q?waTbHyMz?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGtQd1hJRUwrNEh2cU95V3lNbVJOQWw1cml4ZGRNS1RLcEIzVVpBSS83MHVF?=
 =?utf-8?B?b2FNM1JwQ1YrKyt4dnNMU3lBbGFIT1h5YU5sZUNWN1Y3RjBDUlFTOUFYYytN?=
 =?utf-8?B?c2RoTE8wbG9FeTRrSnpmOFYrQzc2MXhuUDNhWk9QU053cEQwYjYzclBuRUR1?=
 =?utf-8?B?c09ndWJqTzN0M2grUEZFOUFKc0JNZitsNGpFT1kreGt2dGhuamI5d3lka0pT?=
 =?utf-8?B?NjZuK1hvVW42MHZjMHloaDdFWjJYYStuSG5rOFRjTVQrSHkxbnlFcjJZQ3h6?=
 =?utf-8?B?dEV6T1RmczRUYWZZQXZCL1VKZTQ0WnArbzgzU3g5dmRnRVE0MytKa1haUjQw?=
 =?utf-8?B?cnhFRitxRVk5RkZkb0p6NlMrUzY1dzdEbUhjZlloZlVhNDRpY2E4aW1TblJj?=
 =?utf-8?B?SmQ2MGsrVEdtWUhISld0WE51cVdoeWowc055YzlpUFBIWmNicnlscWJJUFNm?=
 =?utf-8?B?QXRRelpUSkJlejFTN2x6N0RnNkE5c2lEN0dqdUdYbmhjb1ZjTEYxQ0V5cXIw?=
 =?utf-8?B?R1RLbDhMM0VrY2pwRTV6dXRSQ3pkY3N5MnprQUpWRGtaSWJLK2t4N2VYWG16?=
 =?utf-8?B?bXhBWGcybnFEM1F3ZElERGowMlhYQVQ0R05EL091QjZhbEpUaG1lRnJpRWgy?=
 =?utf-8?B?ellpdG9DVEgyR1grcGZaNDVoL0lWS1pIUTNlbG00eUtQYWJKUEcvdG9leWdo?=
 =?utf-8?B?SnFYM2F0RlRYYVRUUnBGRWVPbEQ3Wi8xd09LVnFxY2J2VkFQZjZVTTlwY2dZ?=
 =?utf-8?B?WUZLOEZSQ0RvaFdkSjMzaGZINHdJVXN2YTNrQzNhMjAxL0oranR0bmxsWUlO?=
 =?utf-8?B?Y3g5SUxkNG42aFQ0QlNZMy9uMzdsWkVaaDBNYVpXRnY4TkVVdmtReFhFeHhX?=
 =?utf-8?B?M2h2ZnlzWURrNzhjUGlTcHR5M3Y1aGFTcW5GeXQ1aTBnWENWeWVmRm45dy9l?=
 =?utf-8?B?cEZnc1lQY2dlcDVHbUtqSU1zdHZ0azRjVk9jSmUrOEpTVGNrRzNRZnhqWUhv?=
 =?utf-8?B?OC9uVjVIekxlaUlvanpIbjdZblhwWVNMMjltbWZ1cnBrZWt5RVdGQlE5NkxU?=
 =?utf-8?B?K2FIRGs2T1ArbEp3U005c1J5ay9oQ1RxWXJzbFpCMFFoZnRRcHR1bExLL0x2?=
 =?utf-8?B?SklNZ2J2RnpKNlpSU0VGTEdDQ1d0a21FSndQZ2VWMEZwaFllZElwSkFOeHFj?=
 =?utf-8?B?WlNLN1ZycVJ2V3JvSEQyMzNEYUw5eGIwRURTOWRqZFNGN0hIamlDaE14QzZo?=
 =?utf-8?B?YnNKdHVaS2p2eG5KU2VDSjMyTDFuQ0tsalhXellIS2g2TnZZdTVBV0oxbGVo?=
 =?utf-8?B?T3pWRS9OSHAyUi9mVyt2RDFNSkZhS3dFSWpsVmNrdm9LUXhlZFdNQ1pWdDZn?=
 =?utf-8?B?V1dEMFdwbU9NWi95K2lWV3o0VXFwbnpTbDYzS2V4bDlRMG9vQXBlUlJlSmJx?=
 =?utf-8?B?WHNtR2FCSm50V0RDV3VYOUhWdklRRmYwS1l5bVd4WllZam5QV1orMW9IOHJn?=
 =?utf-8?B?MnhLc1dFbTdPbUtjOWEvNXNmaldEb0ZteHdJZ2xzQ3oxU2xTSTFYRWUvUXFw?=
 =?utf-8?B?UW1JSkptdVN6cHhnTHZlUVVMc2RVNDFhQlVraFo0MnVBbk5kek03QW1iTDlr?=
 =?utf-8?B?K2tVV1E4TmhDWkJlb0pxZ0VzSXVWQjdnVk96UVYvOXpldU95MVNTWWdxQmhm?=
 =?utf-8?B?NWFybVg5WkZrRTNWNERMaE1ta2xuRnVocEZxQTRyZkZwV1hCYkVnTzg4NHFt?=
 =?utf-8?B?c1gzRCtIRUFEa0xjOTVnYWV1Y2hXZ1lVSFRkbGpyYVJDTmxjQlhHN3hpYWYw?=
 =?utf-8?B?MHRkanM3TkZFeFA0M1dJeE5TSHpPdzhjMzhNb3IzWjRBd0lZdUpiVzd6a1hV?=
 =?utf-8?B?V3dubiswaVVkMmZvcTZXeC9qamgvazJkMUorcGg3Yk1jaHc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b3de7b-ac98-49bb-e703-08de7a04c4c2
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 15:43:23.7247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEWPR01MB8802

sbc_execute_unmap() checks lba + range does not exceed the device
capacity, but does not guard against lba + range wrapping around on
64-bit overflow.

Add an overflow check matching the pattern already used for WRITE_SAME
in the same file.

Fixes: 86d7182985d2 ("target: Add sbc_execute_unmap() helper")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/target/target_core_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index abe91dc8722e..21f5cb86d70c 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1187,7 +1187,8 @@ sbc_execute_unmap(struct se_cmd *cmd)
 			goto err;
 		}
 
-		if (lba + range > dev->transport->get_blocks(dev) + 1) {
+		if (lba + range < lba ||
+		    lba + range > dev->transport->get_blocks(dev) + 1) {
 			ret = TCM_ADDRESS_OUT_OF_RANGE;
 			goto err;
 		}

---
base-commit: 0031c06807cfa8aa51a759ff8aa09e1aa48149af
change-id: 20260304-fixes-268e0eac427f

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

