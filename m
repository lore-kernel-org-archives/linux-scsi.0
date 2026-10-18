Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013070.outbound.protection.outlook.com [52.103.20.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD43C399360;
	Sun, 18 Oct 2026 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338068; cv=fail; b=lXKVJ+2AnyPVQ13uS576cwgg46rwSjQyJcbx9xhiqkfJJAwnDmhJrl8ppnKSH39h1ExpldHWk5msbg+s02rhuMUkfLHudX2wBMi3xL7MpuO0mZGnOghBOP6qePmjxniBAcx5hFtB/aHflEhrU2Mdb9hS9OvIrV26v56BVSSNTDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338068; c=relaxed/simple;
	bh=cJvevRR9ZhF9Hq3e/pKeV0O7MuYsm71dPVjocEKkBt4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pK8znB7ACBPTnL+R1FFxEjMDs9S7df9wrvA8e/zBVCJF4g3bMNu3kZJC0+kCzlj5Oo4Ou6ZiBPE7LzvZEtxDjFiK39g7B1F4wgZb6Rdg0Ibaq9/QOKqsE3bxnEUBkfXhbB2/yBhePfwxA1SAWsmAkzyqyfGudiMu/p8aBmB4tog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=F2f34HcD; arc=fail smtp.client-ip=52.103.20.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="F2f34HcD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V2nehXLSv8dVYqb1D0ApTgprUaj3Me+7kJlDXBQDiJ0xvjSJ3b9/bTQNKgyNRU+kgbg6z9avieffdKjkeVkMgv8tpL4/uipf4IlPwvBPFj8tdawPURFuWmsWPiuDuV2C9sKnYHvtdwlz9n7vUHufnS40Eel98DpjfrG4GGenmEgChaAUwtc14UiRlbF8pyv+1xjfXgzXmVlrqhvD8cveNOOhNZYg3UzXHN2iVVnk90EgVa/65T9yHZc6AMYaARTHxzDHyFGHLgDD6iWfF2yYl/nlMxCO4lKKM/51juzmKoP+QK8aq7CPgahbNUOowb+KuALERYuE/UaweAqXml42sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=lDWrg9xSz9OKnGlNA3tRyXXO8KTsa5b6ZJktZ6FbDy0=;
 b=U2fkGoCYyz1nrNHMfNHrmcX/9Hd2JPfN9W0nPF5GQ33+fUOEzxs9xPj8wm/nGA8/0ipaUN85Xy5xx05EvUstMtpNYlDwNkzuj2I+fN2VjDi5X4gfPaoy2yHiVF9EMsV5qYfAXA7e2cvJTN4hArNsZkYa/etARKTSSKHmVaRWrEGFuSWqynEnwBjbUEyalqD40qvh1Uu8g1rATQnlaNmjHMQi+MuUI51XfbRcgjbHUkQ+QPKaokwPAU+RbBEbe3O271EUg99LDknf76aUTrpShGpxj92z6oDOE5kTXXTWSzC1dRGMje7UI021nwEKDoPQWUo1hIlRDJc6IL9c1fwhsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDWrg9xSz9OKnGlNA3tRyXXO8KTsa5b6ZJktZ6FbDy0=;
 b=F2f34HcDwgsPFTRAzX54ajC8sTMP1lKZq2EWp6z9VcG1sD5MKehsKgHd75pvXMwqXPIlnIrc48ARyujuNegMf7bg6XrEpeVTRtCCOmfvhrmSUp0IP+z4vWjmtKBvTIQ8S9DwV3QUN0WZxRLyFbybNVXT1uXN6aoVNooOVskckPLBsAIYQ9xsBFC1OnOjDPV7W0xEBcbSDBTFefUHBMwzNpzC8D8SiCa/bTcsou1buJu/VEaLXdHE4KI0mv6pIb5Qi8HVCLlEA4zC+3tF6vMvbbvsS08SdfmLrw7f/YdDJqZpuPO6DEQfMjvB6SBBycmZ6eKWZjq94VrIiQlWb01sBQ==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by FT1PR05MB999137.namprd05.prod.outlook.com
 (2603:10b6:170:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Sun, 18 Oct
 2026 15:41:04 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 15:41:04 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
CC: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Wang Yingjie
	<x-professor@outlook.com>
Subject: [PATCH 0/6] scsi: make SG_IO user copyback failure-safe
Thread-Topic: [PATCH 0/6] scsi: make SG_IO user copyback failure-safe
Thread-Index: AQHdXxcV4d7XNHMimUKXaFSWzkcXtw==
Date: Sun, 18 Oct 2026 15:41:04 +0000
Message-ID: <cover.1792237341.git.x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|FT1PR05MB999137:EE_
x-ms-office365-filtering-correlation-id: ff30cba2-e97f-4e99-8bac-08df2d2e384b
x-microsoft-antispam:
 BCL:0;ARA:14566002|8022599003|24021099003|15080799012|22091999003|8062599012|8060799015|19110799012|24121999003|31061999003|38102599003|25010399006|102099032|3412199025|440099028|12091999003|3071699003|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Fb5ArY1MJklTHwqz8ZS7owrz1SvY74MIHMZKEZKt2ZePahpPshxVUEKNvD?=
 =?iso-8859-1?Q?xgY7p1u9WYlAbe2u7Km68GgIzPI349Bl6yEt90Kzq1Shz94XyohThgtDG2?=
 =?iso-8859-1?Q?NpQRjAJyCdKWiYzeu6BJBsvZdLhxOfssa4EDMHW9YjV4BNPDiB6/qnhqt3?=
 =?iso-8859-1?Q?+knxuwSKwBkWsMnBJiDie0qRSizxBWjbn7RYZcqjOlIgIl4X39dHL1i4s7?=
 =?iso-8859-1?Q?e7bmCLm4+bSqAnx6XbznNWtD122b/VDPm3dteBV7TWDjRlpKdhVQnMX9hS?=
 =?iso-8859-1?Q?EM/qYW2SMbVjW11AIpiwhykJ8kLy3MChYRUKrMAKWh2piMITnIBW1nOKNo?=
 =?iso-8859-1?Q?GNZJW0swpOyXm526gurcD1UxJUgVeud7lySzES42zxypGo350HBZQOzOxU?=
 =?iso-8859-1?Q?wzsiYngU6tsBJQAyqb15UjagldnbzYB6d1nP1qyzIxj9+jpCf2wLw9OZtT?=
 =?iso-8859-1?Q?tl9Rg9F5SJY1wZWHj5JB8z8vQ1J/AneL7/cCUr38z7CkwPVWmY+EyUCEm8?=
 =?iso-8859-1?Q?Njs4qbkkXOjFE7pEQVWcwIE8Zd2fSBU6julxJpSjmrXj41KTOK/TNRyF6c?=
 =?iso-8859-1?Q?frfZbNhNv6WVZ0PxDfe+wJ1Bio4LFhsKE7EAevkaNP1ks1xuE74Q4vYijb?=
 =?iso-8859-1?Q?DSYV7P53eZaX0f057i+fS2TMXjmoY64hM6NP0EK8iP+G3XSjFYDx94NC9V?=
 =?iso-8859-1?Q?nIpC2DB4Y0UwKNn9eJ7jgYTGh2+ETbPQktUlqA5/JfEJPPIdkbk5RbQwJy?=
 =?iso-8859-1?Q?ggCPXnEt4kH8TXqAYh223iE/oVIapFVxt+XC33XKacr7tJf2m5TSwe0t1A?=
 =?iso-8859-1?Q?jLVOOlUPJilN+NSi4JiZGguzmtIj+WvtJxV+TITDzZenX9POg2PgxDy2bb?=
 =?iso-8859-1?Q?ZXOpW3WdegUpwwJEnHWUd1mTzzEQRBZcmRj1ReTmK9RcsUjxP4EoW+VLBO?=
 =?iso-8859-1?Q?rSHk3UU7lC4FlJmr+oSWyI9dAAWkDcRlI4opuR3dpPoXOXYF8R/FbIG8w6?=
 =?iso-8859-1?Q?JeF8CeODSAFnw+Aj+Vh1XXRFxr0dpWrg/3HMHEZfHIyHlQEl9PLvlFyRMB?=
 =?iso-8859-1?Q?2ON0cldOh0wbd/ShNY8l+VZE9xn7kr7ql9B0Tbz3pE5HC/Qeh1uf73Ow+w?=
 =?iso-8859-1?Q?I9szQUslvrSPlKn4i1ME5oeKROHKOX7sbvyw8H5vwndPXGjJLN?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?el+sjHIDhULDwxhq13slqNLuWQ1boEitYm/OlQnGD32Pncbx4K4KH1FTZg?=
 =?iso-8859-1?Q?wwSW23MwNd7wHtnPzUUvZU6YVeIgPshYhTGk+5VwpcMUOiX97/dGMU/LVS?=
 =?iso-8859-1?Q?jWif/m0c+Y27Fm62lVLsmlUWCP1ResS8HeSb0xexYUV8Ee5VpCapdqnP9Q?=
 =?iso-8859-1?Q?kDTfJ87YJWOhuAPasn0f98Swkw5SpcUBv+1tJHqwd2ulxPF7OE/HTDN12L?=
 =?iso-8859-1?Q?rQnHuPnvjmcGpjILrch2MmouiY69ugnhteBfOojbqQyNqtS49Xu4Kn67uZ?=
 =?iso-8859-1?Q?8o0C4trfxIqZ0AAv12dpuc2vjDbmJvIhEKOQEEZoh98ix7Ukhdsi/u4CXI?=
 =?iso-8859-1?Q?Ybr5b23uYcDEFyUGLLrcqeqvmR62vUGhMHCcqQqmo9CMwgNi3VHk4ErEPu?=
 =?iso-8859-1?Q?lKhPg5Fsqn1IuCVE3I05o5T764iXzJ1xEAdZhiiYCI2Wrz0/WPtvTuM6Fv?=
 =?iso-8859-1?Q?w5IMAzTnX0ohSiI0PR/jwXtXTBJjMdf7PEsxKKX2PpiKboDOJgIFzk5+gp?=
 =?iso-8859-1?Q?GOhYpwZSXY2r2MpAhC5GBCrTnTJlIsAM5OV0EuEJ87Jr/fd6WDLGiA6s6W?=
 =?iso-8859-1?Q?VSa1usp2ZpLz/dQjdmTkkvL9glmR3/HsK7kh9Jl88qBGNbZ/uujdPBzasy?=
 =?iso-8859-1?Q?LYbCajfeWM8QB7WDC3zU84ghmWksx3Xx91dvXl/TdmwG4Hb8BGYvxAIgLp?=
 =?iso-8859-1?Q?fiJVAoSz6Ly+vQXnlxwleubD9es+ka4OYE7ga/JbwiQijn7y6u/que0/Zt?=
 =?iso-8859-1?Q?kbzk9pxCqsV2CkuzWUBIp9+jgGkASuKKkwsfdtsLTNJeElP8+9HetcX8QN?=
 =?iso-8859-1?Q?Sz2uPe/469u/Fyd3V+wxvvL3zPLhId6G/D76X1fwWpwjpXWqnYM72w2/VU?=
 =?iso-8859-1?Q?Ea3U4i2QdhRgRnNVYZrV2Mr4OfTg/D9vaTno6TliaKZOACLFw5stv0gLuO?=
 =?iso-8859-1?Q?37fe10xV0ahdH3/zqyOPFGI2qkXqdjTrvzCMIknVRwQx3Iil5xICcdBQ43?=
 =?iso-8859-1?Q?ECkQesxy4Lig0BUJsSSQWhH4HAl1kXMNsFG2AUlVq7ywWTQQQAw8kWqRT4?=
 =?iso-8859-1?Q?Cw6bzxHA7jRvsL5sFgFlwD3kJEc3kULMpNio1f0ljyGQ/tuwT/brAlpyoG?=
 =?iso-8859-1?Q?pTRR3j4z4VqvqSRhishD6i07kJentMtCfW2DrbwYo2KYyiTbjv5SuFyNhh?=
 =?iso-8859-1?Q?ld0QGaY9S+03vjcZkWqWgC5RTuJwzGnOhYvGE7HtztA5YKkwQ7EorEy6Pk?=
 =?iso-8859-1?Q?FQ9U59EbVEc7RmXYpAiPNzvDdQbtF/4qVlX27A9QC5MjFstoOy1EVszw5M?=
 =?iso-8859-1?Q?U8Dj2lC5XeSsB4XT7rTpBjIf1bx/6i13fUySOON6uXY1Pr0tsX34Pzrnyh?=
 =?iso-8859-1?Q?TT7QQydzNQtDkux5VXC0uq61XLcO1I28PkICDXqCVVApPo6H2svmHJd0H0?=
 =?iso-8859-1?Q?PuWvwiByJQ/CJ1gW?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: ff30cba2-e97f-4e99-8bac-08df2d2e384b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 15:41:04.6055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR05MB999137

Several SCSI passthrough completion paths touch userspace while their=0A=
completed request still owns a queue tag.  Sense or READ-bounce copyback=0A=
can fault on a mapping backed by the same one-tag device, leaving the=0A=
nested I/O unable to obtain the retained tag.  The synchronous and=0A=
io_uring BSG paths additionally discard data-copyback failures.=0A=
=0A=
Snapshot request-backed completion state, free each request before=0A=
userspace access, and preserve the existing error precedence while=0A=
reporting copyback failures.  This covers block-device SG_IO, CDDA,=0A=
and both synchronous and io_uring BSG completion.=0A=
=0A=
Same-device one-tag tests previously left SG_IO, CDDA, and BSG tasks in=0A=
D state in blk_rq_unmap_user() -> filemap_fault.  The fixed paths=0A=
completed without a stuck task or hung-task report.  BSG tests with an=0A=
unaligned PROT_NONE destination returned false success in 20/20 runs=0A=
before the error-propagation changes and -EFAULT in 20/20 runs after=0A=
them, while writable controls continued to succeed.=0A=
=0A=
The series passed scripts/checkpatch.pl --strict, focused W=3D1 builds,=0A=
the full bzImage build used for the wider audit, and QEMU differential=0A=
tests on the affected paths.=0A=
=0A=
Yingjie Wang (6):=0A=
  scsi: core: release SG_IO request before copying to userspace=0A=
  scsi: sr: release CDDA request before copying to userspace=0A=
  scsi: bsg: release synchronous request before user copyback=0A=
  scsi: bsg: report synchronous data copyback failures=0A=
  scsi: bsg: release io_uring request before user copyback=0A=
  scsi: bsg: report io_uring data copyback failures=0A=
=0A=
 drivers/scsi/scsi_bsg.c   | 60 ++++++++++++++++++++++++++-------------=0A=
 drivers/scsi/scsi_ioctl.c | 45 ++++++++++++++++++-----------=0A=
 drivers/scsi/sr.c         |  3 ++=0A=
 3 files changed, 72 insertions(+), 36 deletions(-)=0A=
=0A=
=0A=
base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053=0A=
-- =0A=
2.43.0=0A=
=0A=
