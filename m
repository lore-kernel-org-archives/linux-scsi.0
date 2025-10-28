Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010018.outbound.protection.outlook.com [52.103.72.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742BB285058;
	Tue, 28 Oct 2025 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761669027; cv=fail; b=pdw0l3mYjlUn5oJK1okZDIATphShjH8aiwhSlfU9qkSdXZft2yGJ7lUICsaFg9xzlc/eWALWG1UNtPmbIE/lud+a0P+k+vMVpHUdKki8+33OEO99s8V0TcuHYLP92Y659Yw22WWw1GArGQ5/dQM+yy6E0CXJyjI8Q4iBycgwepg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761669027; c=relaxed/simple;
	bh=/9Z2X68DcGLALreBlj6sU63ZZvYMsgpP9Bh03XiBicM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HhDJajiZsyH6yEdQ/pqWBBvC6SpoOvCU5V7h+v1gYDmWbmwcqbYqbm1sRyNtpwa/4Ha3oFw7vDyjxBgZk1twABWrjJxwypYmJQBbS1goeuMpSBBBVOatOxRyl2HwaM1EqNbqm0YB5AQCsPEJRmJTkJ1I7LI1MUTwyLzw4KqKOwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=g9jVUgL/; arc=fail smtp.client-ip=52.103.72.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="g9jVUgL/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbF+sFzXGpXvevHmiF4MKk1UsIFChEG09KSHeL7GYdPW8sDLTArXJrTQWFsTLXEo+3JZG190d/dkm6+RpX/izWaaWyVn5v1mimIuf8eUHRRBB+Ztrg2GLTKZG+KNDmZ87rsl/+ftLf2EihskuBIeNMXL6I/Jvg+Q2srahFsRqpyvMqeQac2eb6tM9UUrpxV1lnkJEj/si8t+KsZTUD+1AaGI2gw6HcdzjCtyzWb8RGgcRCEOtrYTJruDYaHCVs2q9kR0S6OefIo5Z7pnh0OjeZKRgGQYNoU1hnJn6j0AL6XXygqtfGreKE5/BVuv73Ov+Izum6FAK6bBGXZNvh/XHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1O64jdz4bCMPZi4gObdEnkH3AmIGpFuugBALyAO2Ohk=;
 b=Mn9vqTi8+qwhB57OYXnJnVA17aeYEeFuFycZz6o8dTllXfjJNuMvrF/CwVc7py/6PpHNQdnn5pEUmCXIVPfvRj3vtm6CA8lX0jjWkVS3hPsejoArBPFazAsZLHeQZUP67k8Z7iN2FGJOXZfhKyEB6ua/e+kX+8Sk86kL8wxuOj0YnSz4WcZ191U7U1rsxyfbg/V8BMxGsabYf9oT1OkxxDda1Pmov2YwRjXrCWC9h0/m3Ts4MQkDkVPOLiXUB8zUmqX3S4Jq4vlXexNplLs3mVMIX1DDLlhQpLM86boDbfACXodQQK07tBiqsoJ4B7XgaCHi1tAKeIQcri8jes46qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O64jdz4bCMPZi4gObdEnkH3AmIGpFuugBALyAO2Ohk=;
 b=g9jVUgL/0m0ivoyJtgkUWa0ujohKcdnU37E+a9g64Tw6qftRbOxr0NeScGRSwBjKlJa+IhD19QfO3aU4GCbXzQOfKd6ocuTDWOqs0yJUXJSzXiHuXVKOiT+ZPm2JrW/oA3XQNAjWPms+dDuw0ymF1CmoqNlRj6yd+TWCdV5qCh2nEuG+wOkf/DEh6aR7/qX64itpnThuLvOHtE5T6okScn3lHrW72B9Max0f82KS7t9QLglrvDIrFZco6ryckSoINBls7pyFw5MqogzhsxtWjKHhhs47AAOvdXm78cMoc1p9kA4ix+xqvcCLCPL7Qr2b8YR700xAHxB1V5i7FqiKtA==
Received: from ME2PR01MB3156.ausprd01.prod.outlook.com (2603:10c6:220:29::22)
 by MEWPR01MB8833.ausprd01.prod.outlook.com (2603:10c6:220:1f6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.20; Tue, 28 Oct
 2025 16:30:21 +0000
Received: from ME2PR01MB3156.ausprd01.prod.outlook.com
 ([fe80::443d:da5:2e96:348d]) by ME2PR01MB3156.ausprd01.prod.outlook.com
 ([fe80::443d:da5:2e96:348d%4]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 16:30:21 +0000
From: moonafterrain@outlook.com
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH] scsi: aic94xx: fix use-after-free in device removal path
Date: Wed, 29 Oct 2025 00:29:04 +0800
Message-ID:
 <ME2PR01MB3156AB7DCACA206C845FC7E8AFFDA@ME2PR01MB3156.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.51.1.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:510:339::13) To ME2PR01MB3156.ausprd01.prod.outlook.com
 (2603:10c6:220:29::22)
X-Microsoft-Original-Message-ID:
 <20251028162904.44718-1-moonafterrain@outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ME2PR01MB3156:EE_|MEWPR01MB8833:EE_
X-MS-Office365-Filtering-Correlation-Id: ff2ae6bb-f196-4ffd-c3a5-08de163f49da
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799012|15080799012|23021999003|461199028|5072599009|8060799015|5062599005|40105399003|52005399003|3412199025|440099028|3430499032|18061999006|12091999003|11031999003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dyhh85adj/idAwYaWyHKvkcLkRjnohvnxpbiZtW+IOmQJjvr91bX9N9Nx2Ty?=
 =?us-ascii?Q?2u7vTSYUDJEWktvXEjF4eelHLPlHeaIyPqllJEMkRZUw5KbnP8q+lyvbRe/4?=
 =?us-ascii?Q?YYubNi0Whg6Qu7aISWN9ALpcJsLJh+itQAGKyv0BQc6EUOJi1jwnouMXBYGH?=
 =?us-ascii?Q?JQ0XjtTFVBbN1lE5hxTTqMjBRBxvXEXVw35cTNhdLeeTm824NgiZqb4OSYps?=
 =?us-ascii?Q?KfaR2dYgkEr9KNNxxf7mS2JirGHT7Vx3v0JgnAzXf8hj4Fdh08gpWM2YUmXJ?=
 =?us-ascii?Q?990H51NlthEEmecMrbJCqGVhOMGhZnQY+R7Y0fwoUSdsN/Ocz5G7HtHvQM9W?=
 =?us-ascii?Q?BKMVhOFfVdXVZ7G0IS2Of8SazQtTo4oPMEi4C+drigU5sbViweHtzvslF+hO?=
 =?us-ascii?Q?UtZWWWyv7+0jSJ5DwJ06OEz8Jn3S4vZDxe6NiFNUxbkihx79NXU3XXJd5A2o?=
 =?us-ascii?Q?1n1zEM/WSSSYgyccMblc+jHW0FLx+kxyc6e9hPgG6mAp3/WWMCXknyPyKDeA?=
 =?us-ascii?Q?3wWDHZjlEsbu/oKT+Da1av9Dgw0coWKKcaFbGNSZfkzNiR+ofHy39ycRHiV8?=
 =?us-ascii?Q?VIBsbKVl6YNGMCVPvLXmkPBCboW5uk/9c3zKTOvDN/mcFwvyTs5zP/MZuCSL?=
 =?us-ascii?Q?eNIaXXcjtOhmsIHlEhdSiz6mtHV/wSxcTehylQ33dnnNtHm6tghMzeeDRuQY?=
 =?us-ascii?Q?c8rmVGMghjLMuFuvMYD9rVILLOayPCvB8wI+aieFhqrIRYuCax84Y9YT/g27?=
 =?us-ascii?Q?1ul1DSpnc0ArFSYwnxMUEp3Jyybt6DYTHd8VSxWmWjhwJ5Dnf9LPWNlN28eI?=
 =?us-ascii?Q?WD40Jp2GJq33eEb8I5LtWLArRt0SOsn2bvkY+GNJGHoeP/XadqqXk5Rvw3Kv?=
 =?us-ascii?Q?ZjUB1vF0ChuvdSeKH39mcPBaVEe54cvr6UaeUHF1MdNGElMiMDahNvIxNH4B?=
 =?us-ascii?Q?Eh9wE3BFhJJsZIcnoY5Kz1E14xWkGlbE6yfN4al3+rQfwVZT6aS6l2LhgRKS?=
 =?us-ascii?Q?HqcINCK8hK65WNiIkqnLra9t3A5cH2HEGqIVvG7WmEKrS91wRyBUy4mzs8/+?=
 =?us-ascii?Q?t73ouvwvmtXHNdVxR+/DkRPn1e1anvUXDJJG71GTt4OB2ujPYiM9Vmr5lMaM?=
 =?us-ascii?Q?KhoAd7OWpazdpnH2/DYClZ0IFVgOORFB1l9EZjYMK976Xu66H3nJ/mR59rjX?=
 =?us-ascii?Q?yfA5iDxY2MeZVcqFEEikb6cSW3vRWXCCgDZWZaqUGwXMr9z4z8LOKCpZXN3Z?=
 =?us-ascii?Q?afa0bK0x9KjhkS1X90+brxsFqDOiT8/uky+1eDXMYtF3UKlMOre7vkkocWkP?=
 =?us-ascii?Q?q0KgSEn0PwOPm3LL7pOCQ/ftiNWn0rtNxQteeAs3CKXL/Q=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?42UrjPNxouenFHh31lmoic/1bPb+48W1pS4D4QvE9Lqxy7pouoptvSqDXpd9?=
 =?us-ascii?Q?HdtA7dmOlecAoqF4xjczCHUCPy88MysiC2tJYrUNRo9vjn1TTNtwY7warviG?=
 =?us-ascii?Q?GXKXS02yxC3anrnufrPFBxPDUUotaXgeALBFkfqbGkQDOiTHsXXk9Py6DqRY?=
 =?us-ascii?Q?zaBTiNH+UKHsa2fuzDVLMyJmyOGKuTGAMxqKKoRk/5KBUymfeT1LpFMlXvfk?=
 =?us-ascii?Q?xQKyjpOi5ahUwSBCoQb0BlmEfCJ5i9AjOLZexvBdqjoUTabc1zf/s57JALAf?=
 =?us-ascii?Q?YzVrkDTqUhvDpJq5Me0ETJeax2d4sijU9AmHoVqVUROfSNHAIig7mXmEF+je?=
 =?us-ascii?Q?/7u0nkT8tvbfxTmT1qN149u+n+x9BIU8g+cnMdCqll4Sr2HCJXw6QEJCzaGW?=
 =?us-ascii?Q?dQX3w94zIELLkznX3uUwjRZx0XF8w7LVm2S640bPgPAX7eh5NdrqZ2vEKSYI?=
 =?us-ascii?Q?mnXeLBl4C/NrfpXTdANMv1ocqKWqUEeIJGmD7IuBjOkZYTe30DZhroZg15bP?=
 =?us-ascii?Q?3G+Rp2PV3tY5dOifEsouNWIohVX3gIOFVdinHJkLFN7vE8Da96FJGZPY4pWs?=
 =?us-ascii?Q?pfVUPJWnXV0n1WOK0FPEJ7+Fp9hGeUt08pUP+RB+4MS3nm23HM93JXJ/VzE/?=
 =?us-ascii?Q?XayaccYdhQ7Ird+5eDjPuTGa3NiumTR4JZbr0aoCZoltcPyYwhfhL7JI5J3J?=
 =?us-ascii?Q?23RndYLC+0rZMRophG1Q6QZH5VjvnO0m2LfWidN8j7+Pyenb0bcZFr5axFlJ?=
 =?us-ascii?Q?CZv44mfFpJ/Dw1owGnbKV7FQ0dIoMyU0gvDYuFmV4n7zK3vKqEptkRkcxZth?=
 =?us-ascii?Q?whTxtuR7soir/LAJdxgvJz4GkLG0sQoMNgCDC/UqAGSXeILd4RBKg2R1xd+g?=
 =?us-ascii?Q?0A6hfUaV5Mq6cujXklX379uoJ/wEMDnLKl8p50z6cz1X99NOQQnhn2vPW4x0?=
 =?us-ascii?Q?D8jfmot3HUgKm08AqUS9l0uTF1ehFf2XPG74uQPOhq1bIdEBHIosOJW0bup0?=
 =?us-ascii?Q?0uFDmBH0o0qzN8kC4Puq9PSZp1zSolkI5xGOO1LOkhBQgRwJYTrlSskzARsc?=
 =?us-ascii?Q?n0YU7wDYrq+HoY9Zsh17hV5Y5OeMcw+YAsWoPZYat4UMjHTnmDmPATDLyHNG?=
 =?us-ascii?Q?//uBU+3mqOPfc00uHrXyRam5Zokm+ImHZk8x1nP6vmPOwSOUInHEzWnkvn8V?=
 =?us-ascii?Q?ZFcV8Ft3jXVQVBtHRrNhax3Gz1d/I4vbUKcRbL2FA/GLelr20Rc0M1ImcQKc?=
 =?us-ascii?Q?Opxtpdu04c8M2Ws+WnGK?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff2ae6bb-f196-4ffd-c3a5-08de163f49da
X-MS-Exchange-CrossTenant-AuthSource: ME2PR01MB3156.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 16:30:21.4021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEWPR01MB8833

From: Junrui Luo <moonafterrain@outlook.com>

The asd_pci_remove() function fails to synchronize with pending tasklets
before freeing the asd_ha structure, leading to a potential use-after-free
vulnerability.

When a device removal is triggered (via hot-unplug or module unload), race condition can occur.

The fix adds tasklet_kill() before freeing the asd_ha structure, ensuring
all scheduled tasklets complete before cleanup proceeds.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index adf3d9145606..95f3620059f7 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -882,6 +882,9 @@ static void asd_pci_remove(struct pci_dev *dev)
 
 	asd_disable_ints(asd_ha);
 
+	/* Ensure all scheduled tasklets complete before freeing resources */
+	tasklet_kill(&asd_ha->seq.dl_tasklet);
+
 	asd_remove_dev_attrs(asd_ha);
 
 	/* XXX more here as needed */
-- 
2.51.1.dirty

