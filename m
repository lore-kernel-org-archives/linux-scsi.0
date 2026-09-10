Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021137.outbound.protection.outlook.com [52.101.95.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A2C4BE45B;
	Thu, 10 Sep 2026 16:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058592; cv=fail; b=Vq7mTjeDP64NpHFgRGS/E0uiB3WGvx8u6VgDWapUWfYtmhuJs5qbRTdRNGAuMhqvgf1Is7zXGCBbd/+yQI6yyR0JlX8zHusZirf1MeOi/FT+QKKHUPhMTU2jiNrimZSfe6lV0JgfAChh/90D+E8bKF6tX9J8XexHuEKzS2NI8xU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058592; c=relaxed/simple;
	bh=VJ6AElNAYvcx0gdRIgrDPJxDXPViLBZcqG894yn9YeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M/gmI/BC/P59AjRg57xDobCpk+3WMLSuQtsUf0Iz7Suh/44EFLyk14olRn+4toK3wFrjlSADKWJ7nQtVt1IJsxxtcpeQSDZIxVm+m1GxnDe3KslxJQLFvj/FQzbMaMbNmFaJRieQrObyM97u+YP/xTvPhXUvTc0w8ttOstFxtkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EnIt/Wj36afgR4CJFvTUHusjGbmLhVtZZNbNNj9guVytiLjImwLJ6XNEjMfKmxtGUfrUzZa17I+awinxVuswXRtphgKb17I9XuvgZ79BCNUiEwyiIoj/s3oKF+lJPqCDjaanQ+qnUWqQlA12THk2iI7Yz86MYLdkVggE9InVx4C7eaI9XyedIq5hZPepyX2Nzj8d9dSmiu6yJbLzyW+3s8n351R+CqKlhGo/4npTnaFzblEA4VcY3kE405VHntf4gJW6XwbBBlmIM6FSJK9382JBtMxX25uxXE4KcanL/UtgZL1DJoC8bmsDci9+9ssp//P97mbDg/zcjIRB7cUfdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=FhLQkGXa8J0YwNdHTmMj9UJinea4sRA8+cVsHSs5lU0=;
 b=YY/wWCsKRAz9M3RQTRa0gL3Tbbuljiu/ll4hyweoAgfafcUnIDLeEST1jCLYgVirxcLZm8kfrNnDkcDRdMIKs+9GoIqOmORirNxiBKWf+oSyY9tVhEzffs015Tf2UU2LAlBj7AjxcOn+j7owHhnAqz9tXCWEr8u3u3P3CfikdmW7gioGbpyt/98xMnDotl5K6r+L1uMD9jCOUm1ISDNGI9WZ1UpuVMHdCQqOyrcKO4g1HpA5KnI0+SBsSdlZtFUpK+TntfJ4RfjRguIRz2KVnPE/7WwNF2mMzQ4ZSIxf0EEa9jzMSNnw1F5O222gthYLVYypG/mH1DW3hmxwDt/esg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CWLP123MB4179.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:43:04 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:43:04 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	tglx@kernel.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	frederic@kernel.org,
	bigeasy@linutronix.de
Cc: atomlin@atomlin.com,
	ionut.nechita@windriver.com,
	corbet@lwn.net,
	vincent.guittot@linaro.org,
	mingo@redhat.com,
	peterz@infradead.org,
	radu@rendec.net,
	akpm@linux-foundation.org,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	marco.crivellari@suse.com,
	rishil1999@outlook.com,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 4/9] sched/isolation: Prevent out-of-bounds read in isolcpus= boot parameter parser
Date: Thu, 10 Sep 2026 12:42:32 -0400
Message-ID: <20260910164237.500196-5-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0476.namprd03.prod.outlook.com
 (2603:10b6:408:139::31) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CWLP123MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: 341abf77-5586-4a54-567e-08df0f5a9578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|10067099003|56012099006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KbPHgyWkBzDvPAo2smX/B0kbmR121BTydbCNevQk2HigixU2OnazquCn3B9T6ocOKS9TrpvCxUBhsUiU+cejYUa1HXcGj8T1soI867liXzty9HyFjxCCdRMly51TfISyFnb6PwCtd7hmu82MLrUNuDwP5fmePPsk0m2hVEDcn7ROWS8B4Jja4507QsrnvIyRcYVUAdiw4o2k4Eh1yyF8uoZIt3PuUNlPB5+Y+wDXxoBJKvVNKXccF5VzLSw1886Dwt/zsYdVsf18u8GLnx5goNbfW265DB9f27zVWnBEtPdG+lnNhmwd45GNavOxclJsH7cl/KE9jf3vHP6uXVkz/idpaEolWNAUyWyGwg68deRlEqxLMP3KwPEgZryp7pR2YMZxYD+KJoxcNojzRogwNVK5LowGSnID+mKs2KbGseHTrgaepxve7Vcq4ghFFVUProXJm35UCFloemyghvKVJ7BLcQ3Ldcls/v3anj1Hz0UdXcvfUAgBDoy69ZECvYPIhO4/84oXWYB186W3rst+68UzEeugIcR/eGbrTJ2t2LhHTaWqpBgruxG2/muKh09CLVGowC8Ky5kRYFZv66OKsQiOssQs+0iiHjEsL4dS+P12+y/twTCKeB37ZGq8Y2BQGdhWUQ1sK70vB4LBtvuDOBfFz68yVWI/IJgfxCsbdUY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(10067099003)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CN5WwxhNskIuD90j1PAPJ4A9LdxLG10WZPLIAE1RxLSPyWhMGnb7DH/Rk9EI?=
 =?us-ascii?Q?MNyO4GJFxUGi1V54Ttts9HdrK5vFHu4WFILtR+X8OJIBYxoV78NKrrKRQA3H?=
 =?us-ascii?Q?RYH7qNCB4kWis8yC3NXGocAPkb1WD8+ZzqyuDSuCnFzGQNv5g+l1q8KXy7sw?=
 =?us-ascii?Q?s0aVnNI/LV3lWYUOEfsxFBlHubE7+R34gund1AWkz+kcXgl0l4C2DvF9P310?=
 =?us-ascii?Q?Kn/1x3qnQkFDMnQBG9P8uwu1byGIVcmOVjtmjlmOyoIwtwK5YIAGxsq8Gjwm?=
 =?us-ascii?Q?wLWsnMdIEsyEbQKXsXDDV6Uf5etA/F/FyonVIiXNBkRjg8E3l67UwzHyVOu1?=
 =?us-ascii?Q?1MOz/7SonnNsyruip19FX21GgO2WZYYb3G0txEnqs5bT/9vJemzZU1s6XWRv?=
 =?us-ascii?Q?aBInL9ufGSJYa1Im4cNhFmpMJkmSoPbGN9HGb5jjnE7/5B8QTpfhIg+w2YfE?=
 =?us-ascii?Q?UpmPe0OudSwEh20iao+nkfWiwcEJWHO/vFLzeVojz1bb8339ltFpn3EOmOD7?=
 =?us-ascii?Q?cUR7JH9Vu7X3RO4pHOVq2ZCrUt77589LXNWAV+qPr+burLrYvoIpNdQVJQLx?=
 =?us-ascii?Q?J21LUPuFwewNxClmfl3uFahAz/RS80yQfleY2BdqEOQTlQxbqrwqs7OJErxh?=
 =?us-ascii?Q?erhdePzEAvwA57DutolvKudkOTvJDpGzZzGs04SfM/CXIQ2cPJpDU+VSQpgQ?=
 =?us-ascii?Q?5W+2qPG5Y3L31dDKDTyGHpHr2Hord/0gFObGSQslxao+XsVKF0vsnCWYBf0I?=
 =?us-ascii?Q?DQiXNqQVlybfnstlbJuzsSkxXJ87On6dzczafr1tnlOBqyi6iY7Cjh1iaXj7?=
 =?us-ascii?Q?HaKBveTQJXg9I0/jIpZ2j3TEd38sgp0HIxO+amynCfhhe5hoYxvRle/QoiND?=
 =?us-ascii?Q?Iv3WTTpFU65iSufJqI28wJG2bl/pavgzSJhoK8XPsIjVribAcXRZsyCDkxOm?=
 =?us-ascii?Q?vHQHeCJ7oSJQrKp2kbOjp3xoCdx4hd5LA9oWMWUP5aPn4v4Vmqs/HHhdy09d?=
 =?us-ascii?Q?egNxoeNAkcKn8FDpOqRTpeldYvGTPJDTcyKga8JrSc6ZhRoFuixfjugKrApy?=
 =?us-ascii?Q?ACOAQlFP9E0HJ+1R7iYVN9o+9P60Tya4KvJMz0vy1r3YHkTiL/K1ARtfB+Lj?=
 =?us-ascii?Q?93+xDQyKYfbqGH9E/4d0PjkN9T64K/71ZlcG7Bbm+5Fr37n+8+cQYWfvAccP?=
 =?us-ascii?Q?KYDwzeOBG4JBKEvYY+rETv0pNktraSh7c6E7wDrShpTt0Q7Eto9ZIIpdKWip?=
 =?us-ascii?Q?Ej/JvgMpmBBcqgABsrJFttIxfBw+b2UVTveIGe4aXaSCQfYdVYIucOEK4dyu?=
 =?us-ascii?Q?m78LKkLYEJEjTMSsoJGUP2S5P6oDTwFPBC2JGU3kR05UITqHgFFoIcPrwDDn?=
 =?us-ascii?Q?KBY9kLq5WSJcFwrhGVj8ZMHGVAbuiRDgQA7jbZeyKioz1GrDE+aLtP+EdfSZ?=
 =?us-ascii?Q?8z4s9AedT+FMr3qaZeTw4tOjJOHNKBhjjrC5qzSQOvMr/6zhe2OJCbdtJDyB?=
 =?us-ascii?Q?IK8TB5/Yj19cl9MKId52/yPvF1kRzF+zZqQZq957t0mA8fdfW5+UXGVqkLVP?=
 =?us-ascii?Q?vy+1tHS6kMw3ExYvzAXQPXaPo+6mwG7b83anibzNUqcYyj5KGcHZGuJOqDsZ?=
 =?us-ascii?Q?At8Agq91oBDIyx1ZxbCiymEwl5w/02hp9g0ohz8oskmxw0YReDCI0zmEbVq2?=
 =?us-ascii?Q?JP1/Gi9r8zkqxR0AzB0XfXD9yXFaAweDFjwgGj57mXMV+UNIt3pgMmjqz87M?=
 =?us-ascii?Q?FZz7iexKqg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341abf77-5586-4a54-567e-08df0f5a9578
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:43:04.0341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cl9PbUdBAXwo+k6RCjxo7JD89mT3/zG+wmceoAT+B6MSzbwM7b8D2jEQhVlKSWzuv7F+a5gGAaaAdio3SuZdHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB4179

The "isolcpus=" boot parameter parser in housekeeping_isolcpus_setup()
contains an out-of-bounds memory read bug when handling unterminated
flags.

When parsing the boot parameter string, the logic expects flags to be
comma-separated. If a user passes an unrecognised or legitimate flag
at the very end of the string without a trailing comma (e.g.,
"isolcpus=unknown"), the strict strncmp() checks will fail.

The execution then falls through to a fallback for loop designed to
skip the unknown sub-parameter. This inner loop consumes characters until
it encounters either a comma or the NULL terminator ('\0'). When the loop
terminates due to hitting the end of the string, the str pointer rests
exactly on the NULL terminator.

However, immediately following this inner loop, the code unconditionally
executes str++. This advances the pointer past the end of the string
and into uninitialised memory. The outer while (isalpha(*str)) loop
subsequently evaluates this out-of-bounds memory. If the adjacent byte
happens to be alphabetical, the parser will continue reading garbage
data, potentially leading to undefined behavior or boot anomalies.

Fix this by adding a bounds check immediately before the pointer
increment. This ensures the parsing loop cleanly terminates when
reaching the end of the boot parameter string.

Reported-by: sashiko-bot@kernel.org
Fixes: 3662daf023500 ("sched/isolation: Allow "isolcpus=" to skip unknown sub-parameters")
Cc: stable@vger.kernel.org
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 kernel/sched/isolation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 156025ef81b7..9f02e9264a3f 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -369,6 +369,8 @@ static int __init housekeeping_isolcpus_setup(char *str)
 		}
 
 		pr_info("isolcpus: Skipped unknown flag %.*s\n", len, par);
+		if (!*str)
+			break;
 		str++;
 	}
 
-- 
2.55.0

