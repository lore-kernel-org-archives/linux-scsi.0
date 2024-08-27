Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2057.outbound.protection.outlook.com [40.107.117.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492C119DF82;
	Tue, 27 Aug 2024 11:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724758803; cv=fail; b=qWsF0mJhNdl4UmO6Ud2sEVWD948KqH9wduofjtL3JKKZpU/xgyCyC20hw1cuWWX48wQ6ab91dvEGrRKjJrZi2JiD60WHbKwPrkQaVuWyDa0MjS5+B2vWp60tCOIY9OjU361eKMd/YlEq2wrZIj+2xMNtKMwf5JNr7dHQKwt+zqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724758803; c=relaxed/simple;
	bh=8XiHOyW/vovSaUmBxlNC6EH1xE8mLYFxzWGqYeHKTWI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=okjXLlILD//z1rQ9wVUTdkw1Yqm5xU/jytS7N/nR81Ytwrdfhy9/FzS2x7YoQUDHm0fLc+cSFaFc7h0n3s6rKM1FnnN50bahvaUijm5hheSubef/K9ZX7Bw4ELC48Qh76D1JNYHHsF5ChesMQFamRBE2be1ja1SiSAyR1is7VFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=nDqEAeIF; arc=fail smtp.client-ip=40.107.117.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="nDqEAeIF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDJ3TEeG44hTKapVkkdvzcLz8BQjwIZTs5ip344Dc22hsFZcuKPIhZHj1kfhyfkZJ6jDD7y2j2+dEvuxKkVy4rxEReCSkgYTRvdunuyn5ht/iEyJlkjn127zK0TFLFM7IZUwyZPgLeYt7+fx5fPryUa3zOEeDLG5+U4OJi/qKNqeAFkzjAepfWQufzMwqVvWHJ4zt+O3EnOm1ZcCjVc55vXExjCloOkNonLddglCrlfDO8+L4xR7Se9Phkoi8Oi3TH4PbnlHqkqUMMIVk2QW9T5qXGf2m7y9xuzd2uKNrhKz+obNH+mR+FmedLKz0tBt2/98gKxHFqETgqsxybZdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2f50veOjLIo9uJUVIL2WbBga7cPEaU4iaDDCqnylx/U=;
 b=YPQ++bMrsDnzx7c5wtjzw/Hujx686zgAqsWKC9kNkVnTolg7njxyoRyRcJZy++GkFgTcy80XxOInED5I8wFiAM/C3Z8vhh9/rUa4F7HlDEHj3zD0zA5lUhzQlGd/PcV0qCNq/vbdNFhUbiPdijscwtrtjg4UaHoHqnTOUIq6XWLdgSoba2y6IG4ht4iMk5Obf2XTFp3S8pSq9sBcChaNnXXtBWl3kX0CqhsWONJHktYs3V3++SAYCAuVfJNTqcv8yNF7+1xvMaXrZmxg/FY0TeDvlDEF1KUVxUvwGeqqcf7ROMqjL611LUFnwLZ7L9P3PuTvN+GxBj0/I+VVOJAKsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f50veOjLIo9uJUVIL2WbBga7cPEaU4iaDDCqnylx/U=;
 b=nDqEAeIF+eTsnqbnMtOr+j5Tf/6pfFylgYHcvAG6aw7KJXlbF7EJwMexRwWA1Q/Iz/5P9GvnhWEZKjjN1ngmD6jweFJPy2iEQYWYt0HHxrrbBYgDpPwI0oGZVyi1uYRyaNyKVHAlkdOHjfTPHwq7q+WTFcah5AsydeNmyi7ayqu5G7IhTdT8xQu5uwPdZzuJ62zYrqLTDNrNZ1HUk8+8A67Gj+fpGJVDd64tK7oI2qfKw+S5PrsVX14hNfgPMj/O9nehhEOxZsXWm5wwXVQhACYinWGSQqUUFbWspsiR/ggsTboTxuXrqonjJcOfUwYioZZniucQQ9h8QDSNedrZOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com (2603:1096:820:31::7)
 by SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 11:39:54 +0000
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1]) by KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1%4]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 11:39:54 +0000
From: Yan Zhen <yanzhen@vivo.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.vom,
	Yan Zhen <yanzhen@vivo.com>
Subject: [PATCH v1] fusion: mptctl: Use min macro
Date: Tue, 27 Aug 2024 19:39:22 +0800
Message-Id: <20240827113922.3898849-1-yanzhen@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0030.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::15) To KL1PR0601MB4113.apcprd06.prod.outlook.com
 (2603:1096:820:31::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4113:EE_|SEZPR06MB5576:EE_
X-MS-Office365-Filtering-Correlation-Id: 96ce0072-68a1-41b8-979d-08dcc68cf867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yr/Drj4SHhrn+dVm/OEu2FCSJnEJyvRQ/5B4vJPBpfP7aqThMPts2myTPy7f?=
 =?us-ascii?Q?mmPi0sJl5lcT67blk68Jv6zSBXIEbIcaUZpi9Ssz3ds5AKG/034rZOGTi3OX?=
 =?us-ascii?Q?EP1ir4UKgWneZnNDTGDL9v8ySUKqvXfNoiDti0iCEl8VamXg1atcqsFKvY2u?=
 =?us-ascii?Q?Iat6WIvLmy3l3F5phy7vclri3rFYv5VDV5KYjIua/fv4Etc5dIYYT7DgOlcW?=
 =?us-ascii?Q?yZGGwVPCDaSh7sEtRoBIYXR30+YJkBbSgTy58K8qQ+mA77XM6c7lGE0kDk3r?=
 =?us-ascii?Q?9xAaIV/hcoc3FnxXr9D8mc4qixn4xYWl5/njz32jFSiGKgKQsBCM5IZXbcMP?=
 =?us-ascii?Q?JZfMwwW+6zhA3Jtbxdy1S9foml7xtNaHuIH8PBvt+vyHaXcX0MCezBPrhN6O?=
 =?us-ascii?Q?YV+sJ4PAeFOxE1I3w5AJWSokKq5zu6UsY5gT6Sa+MkgEBtL3yE/GAVljvVEh?=
 =?us-ascii?Q?seF+hi3yf7QZRiUw17QtM5buzkPNNAjQancKEjjenpFlNGp6CsZicpLcgPyx?=
 =?us-ascii?Q?SxvHr5DLodzykG9F3kKFVvvj1vsyva19puVHMIhKSDLByA58py5ET91nCmux?=
 =?us-ascii?Q?mDSLuor1K0SPGAlI/shJVOBpuBBHffesFnlHLlGqgDtM8CX5F2BkdAyvOnZU?=
 =?us-ascii?Q?P5GQ8+OWx1570hF0ZdL6ahCufl5d9cRwsnKBn+BqJWFYspK9A4UPCN4h2+qe?=
 =?us-ascii?Q?nONOOIDd1hf8ZbvpI4PO2NQgJP+ZBGp/7CCWq40MsI9S5bcLHF63erFXpcph?=
 =?us-ascii?Q?dSVHq8k7FMO0e+Q/WXJPAni07k390PsBJY9e+Cm3K8f3BR0wxuIhwxgaUzw7?=
 =?us-ascii?Q?9BIrxtc4I4icCsP1VJpEeNbyBYD4cqh5oh4KUiqLzMlHgRJpZ0C5nKJDbr6O?=
 =?us-ascii?Q?azti+6WtaCeA11pY2QRAV2/gbghtBQOuTFPn4D6Zv/CLLRe+0OMI6s6lKIa9?=
 =?us-ascii?Q?EDMWJU/8XqLdJr4XP5D9o3Kt9NO7vKrqYchrbObblONc37ZsvVpN8/vQGsNF?=
 =?us-ascii?Q?1WtwR9Zhnon7zKzsKlXs0fIja6mZQj+7a8z5xHP57Hz9TQVBFhrp653/TTwU?=
 =?us-ascii?Q?y/1zKksTOVxCy/dfga1TDsdjWKqrjGi8cpKjl/4h3ntPBm5eDHGBPgxDD0Ft?=
 =?us-ascii?Q?1Px2Hs2psND79ZW74YphHMd8VmdKma2IWtpIrNS9Pt3vtffotiwdzZlRGkM2?=
 =?us-ascii?Q?+ZQPEaI4aN94jzol5OeeHdkJcc+j0xzBxv8IuSk/YZs+nwKYES84LjxZg8Jm?=
 =?us-ascii?Q?y/iCqDh0cKQypN9L1PS1+JSaVAXLwiRzoshGskqRH1bYLpfO1FF2ugWEr5tv?=
 =?us-ascii?Q?caJOY5oX5JhBGjPQ4nrBYjItPe4ySKWcxJqQrtLtsHAD+pKkTIAS1wjtIAS4?=
 =?us-ascii?Q?KvWC5Zu6OSE8oHWIAdNcyVQOfLZMzsCljgqx77h+dWwpmtjz6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4113.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bTIDu2JHs5fRTl7fxezqeC3257qrxPDr7wBGiY1uDmp1DTlcUwlPDWfgGFJU?=
 =?us-ascii?Q?vB5N87f4UCYmElgaRbtXXNeRzrd/tGKS+aRF7w+2OypHnONOE+xiXaG/DumY?=
 =?us-ascii?Q?PIArvoHLDKOVeLL+nWpOu8Luzreuc+myWssPL1nbRa8gCdkvVvWEqzU/ZtJ1?=
 =?us-ascii?Q?+LRNB1Zrgs404a0k81JlW3O5DviitJZjc4ivkk21yy1GIxCGecBshkAeWD8r?=
 =?us-ascii?Q?8Fs17TNBoa1coEgdzyttpI61DdGrFuQ93bkn98UK0kY3Qq3PDMkvgT/O9gi3?=
 =?us-ascii?Q?Nc8k9osOXtWt50HrcZefECo1u0tO7vGNK8EpCE3xG1el8kZ8aNQyYm5SeLSG?=
 =?us-ascii?Q?UNNb4Lc3Jyd+Q7W6q+1BNrndMyhtiN/3LAvtsfmQVgfQ7iQLY1+zAN6ur4WK?=
 =?us-ascii?Q?mGJiqPwG9bzCetNuPAGXYx9p3c8wj2tKRkWTyLG4hyiphkv74M+EJe3O148t?=
 =?us-ascii?Q?zCY3uko+UJxlcjeeH4X5iu4UghRqnKjrhtGwa0zNaZ8oiSMbs5QXYo5U2Wv7?=
 =?us-ascii?Q?EoWKmtk7HBMKPQPTihCVuyZrip7Y6D80cJRBT+qp1s1KmkV3cA76NmInIT8j?=
 =?us-ascii?Q?RcCKz+kXatL0JBQuUJuGxEPnMZ1EmiAQKLCpa4KIYFf7VVka6f3Wg0j8umJR?=
 =?us-ascii?Q?U3CMn3oeyDcYIozXy5L+S8f/+inq7GsvqMiSa+J4ZaSWH01l2rXifxyLpiru?=
 =?us-ascii?Q?6tb4KuaXMHErd4B51wSE6uxkoekTi+JF5/hYFmyUm8YXXycGQusMUwQ5lpUf?=
 =?us-ascii?Q?0Ikxt+JjS0eAbI9i2wsYAqh2eP4cAqPL5AWiACY+mOGXNbBQMqkICd/VbEjx?=
 =?us-ascii?Q?L/hiWMoKfYFQgMK/YakMTUEwt8GzjFGinToZ9/WeAtawRCTIFw8ccu231LwI?=
 =?us-ascii?Q?22XdzhQxbd9KhBw6JAfJNRuF8lmMn4gBqDnDJNnxMjRiJs5uBTS/v8SLqQy8?=
 =?us-ascii?Q?e4sV8L6vKscKepTyaaJSdZdFt4Ab7GPBCn/7ORfd4sQATQeSmkZ7uENViSxx?=
 =?us-ascii?Q?4sCLAnPBon1jVhTuJy0QG5+31WzWMhLhNnxbFfvlm5xrBPYvhm9Y7Vw3WLMZ?=
 =?us-ascii?Q?lyG1uM8zuYFhC7F59JA2DNA98I+6ReF/7+8py00PJLR6m9KSuHaktq+RW9t7?=
 =?us-ascii?Q?EwCFuXunr1oDDAlBHkhxXAGI/Y5WBr1mUR81i2j2oINEcoHb1cTer6XOXPBR?=
 =?us-ascii?Q?Ue7hIeAGZGFFjol1RgQEJVYpFHgUAHB0RhNTSi4y+vPc7YnjuGoH7tuX+fco?=
 =?us-ascii?Q?F4h8wuWWZywsUtpf9DeHH+qUoehaiKt5tq8T67Y01VhAMXvtDPqMIHxpAMT3?=
 =?us-ascii?Q?Pq5bbjsJqNFZmIjTn2SjgtByzssyLaxl2tWV+dfJzkPm5FSnwjOWmkWckieQ?=
 =?us-ascii?Q?CWmPEl00KAAOadIDH+Riu4O3A1B9URCwmA8xgS13q0lLnJQ7MAPUqe6HPy52?=
 =?us-ascii?Q?f+m+JRqGXuXdSldhMKRjvPw/vLfmCBrl45vnQoRzEjuQOpxMGMiLU6ZFCWRX?=
 =?us-ascii?Q?x3rhUgncpU4uFwgCugTpi9WJ+HEHtxFqwDWSzK/xy1y8sbtO74EdJhXWlXCq?=
 =?us-ascii?Q?F4Iqk316CKoOhdGoNAoF6P9sfVxn2MtIglD8vpu5?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ce0072-68a1-41b8-979d-08dcc68cf867
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4113.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 11:39:54.6887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TiK+M5uth0q+wIBUQi7Pt/ri2nr725FI9XEohWMIKkR4n/Y5Rn67FmCdn1FLvxBw3BfUK9zfa6LrguQ++/9aKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5576

Using the real macro is usually more intuitive and readable,
When the original file is guaranteed to contain the minmax.h header file 
and compile correctly.

Signed-off-by: Yan Zhen <yanzhen@vivo.com>
---
 drivers/message/fusion/mptctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 9f3999750..17798edf7 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1609,7 +1609,7 @@ mptctl_eventreport (MPT_ADAPTER *ioc, unsigned long arg)
 	maxEvents = numBytes/sizeof(MPT_IOCTL_EVENTS);
 
 
-	max = MPTCTL_EVENT_LOG_SIZE < maxEvents ? MPTCTL_EVENT_LOG_SIZE : maxEvents;
+	max = min(MPTCTL_EVENT_LOG_SIZE, maxEvents);
 
 	/* If fewer than 1 event is requested, there must have
 	 * been some type of error.
-- 
2.34.1

