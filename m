Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013070.outbound.protection.outlook.com [52.103.20.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11313B05B9;
	Sun, 18 Oct 2026 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338077; cv=fail; b=i7KKj+lJKbfhJUbWS6hhlS7VIGorfVsMJw7eXGjh15QCLIYJDln/tcKIjMQYQaeZ+0dubN2wgEVfrYK+dV57XzR1obf0XOAdwbCzUpfw+I2pR/lXc1CV34HCbNPXPkVQl+1QmcnPGESaq4LeobAr4fRszVMMrw/BSC/l3iO9MF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338077; c=relaxed/simple;
	bh=zHxFN2fKlgD0e5y6TI8AZPHoRd6ocsjonUn+ggUNeVM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T8HJI8jALdXMI1faMpw+qtgOtHxPQ6D9RFuXYSGj0NmXvv6pcfDYLLyIrakY7IXhmCV7fioDqj1Gqy+KZYNcJNwQ3JCt/UkKj/gbZ/nA50BCrYjC/I09xlNw2wjUaLS7MI6ljWRJYe1bdXiKhZh4WrHgWUtcNsaHTH/cM61t8Ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=LHDx57Og; arc=fail smtp.client-ip=52.103.20.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="LHDx57Og"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEPnEEubxdYIASUJt0+o1LI2j5G+fJ2+jRd+rnjfqbNa0fFB4C6HFNWw95944sHmFnPkFk2ex2AXHJGbGFZnrWAr0JycBkxgGEetoFf5pXmiwfw8hNKqcnRfXZRzyWxjqi9YfmdFybetzcvm24Jm3qaGgqhshTKGmtBv/P9pxcVk9mcOpJ6wRVhdmi6oclIEgWPFOW4WohQO5ty3HwoJRVaJiOZEKPMWQyzK8tFXfFAy40sDn19KAskFC8WAEp5P9+I1P/afOjz4ZmSJjvWT2aedVuBZ7Hg4ST/cDSee4eT+jLDsJPt/CapTRds2ARgwJvaTaYyDVUG/K30dYW834A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=dpM5p56XNRU26xMdR8CUp0x2QLqGdVgrys/2QllhMvw=;
 b=mhLRX64PgYFA9I9sz+8p3LuUNMowjdVlYjTejPvmaKnszfSPnQ5nAUcxFtq5BOzu1Ql0KKkJIZnV8Kk0KoKaMbBg0bkf7Z0HyoiKpCfb60mUYM17MfzSDd8aWFRAaEP5eAJPyv+EfkNhAiB9g8j52Iu586jWYixiQKTrVg9lJuWWVjVzYC+UwfvfMZGHrrgV+4OcSSI6XcxfYx6cFWfzpc5fBSyMVAXiv8tTk481uSVeOoeFbu4Ldev3W+MfoRNn2wIas2Uoexe2lwsSKVFqQiFWQMyPSVhKikbbzsa1nvejcsOB6wfQ0RUQ/snCJSWGf5TR+alQvVog2D7HwgxuGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpM5p56XNRU26xMdR8CUp0x2QLqGdVgrys/2QllhMvw=;
 b=LHDx57Ogp5MNGwYOs9NC01zGthy6+O+dqY9fTgLs4CVxr+5pmzzDixXP+79wLwBYB96RvdJS3XcKccTR/7iRQ9gSN8Xi/9URjrNcK4bNqO7Gb9r+Oaq+FW5VPxRTpCAlJINwptQAcuZRRkEDOtv1qpAzWYc1Ks5qmtX/0jdhFAZEYCBmbncjaQeCCZeS0R0y3kWv6M56p0CB0/CCKdwAyQ0hHIezmAgcfYfVmXd6xRQCiONOCRh0i1kk+2FSxiN70VMvmh7Ygc2FhRCe6bSRKfUoY09KwpjVA6LNFOQch7FYjenyGp9lTIXQsLTU9oEcQFnQXEM5yfDURka25BzbsQ==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by FT1PR05MB999137.namprd05.prod.outlook.com
 (2603:10b6:170:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Sun, 18 Oct
 2026 15:41:13 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 15:41:13 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
CC: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Wang Yingjie
	<x-professor@outlook.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 6/6] scsi: bsg: report io_uring data copyback failures
Thread-Topic: [PATCH 6/6] scsi: bsg: report io_uring data copyback failures
Thread-Index: AQHdXxcbj0vT2niKYkydJQKQWh0ezA==
Date: Sun, 18 Oct 2026 15:41:13 +0000
Message-ID:
 <3303ad865a8e75c4329769d11e281f55578ef30f.1792237341.git.x-professor@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
In-Reply-To: <cover.1792237341.git.x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|FT1PR05MB999137:EE_
x-ms-office365-filtering-correlation-id: 44335025-01b3-4781-979f-08df2d2e3dab
x-ms-exchange-slblob-mailprops:
 AZnQBsB9XmrTkIzDOCxR6E7nJ4I/6XZ7/v4IBBbflA1fd4tTKzAEqgN28exgXOWBmxWLNbpj7hJCR+Vewgxhr/70aoyD7dJ6k19En+ou23uMJItM2JY2YuKwp6fhtKIF9HNbIRQumRANfEp1kdrarlHwO1yiZOTESkv12jL8vmtzdWyVzEm6Zcne4jv9F9zrjDTXasLVdWv221ZMe7dIFyRXzYXDMbrEWRKNy1BzW0RzUu1Tr5eCUn4nPXvp8QWlBJRWxHAmDE2WGY/JRg02mtvNtdsCJB7wL4KtXno2HBAz5NYPRSHFqTH9P4xuFMN8R/Q5qLXn7l/40OsEoeN6xQ5xzEMT7S3IQgVlSZs2SNyxBWm4RineZ6zzZIxjLBaNHVSzvVpeCx//kxJhi3X2kqOojpPow3ocLWmMS40kqB9Zz4A234m58lDjLqVbGU5KQrIMRVP3LRYEJk/nOHBIZINqQbKNeH4g3LpHJB+Mv+BQXaCXAoYH1E7TE+jetXXw7JASoXZzKg6bRJPUTszTvknijuRJTixuIGwa+iusjDqJZ0ts5ieSR4tp5eLi5ho0GKUI7OF3Pch6YaEmrvht+dkh0jx/p+Fg7Vry431DT94B84KpLkj8ZdDl/JvtZzFtVHWSsudayaE263apGFt2VDRHMZ2ZygoJ1c7BM3ep7fZmuM0AWdtXg6spev7rKvxmPgrf8dg6KdcJ0uXDzcd+Fn89B7SL71JmLm3ML8QPTHsSThGliu4N2EV/cfNWfdEeQk7Xqlw2ghc=
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|15080799012|39105399006|16051099003|22091999003|22121099003|41001999006|8062599012|8060799015|19110799012|24121999003|31061999003|38102599003|4040399003|4140399003|102099032|3412199025|440099028|53005399003|40105399003|12091999003|26121999007|3430499035|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?k0Wrk3l4NnYdrcWICOtvKplMS8yxgS8bZePC/o5wY+qkEJuq9LsA4kX+vd?=
 =?iso-8859-1?Q?06U1k6Kj3wcJiMkDjeeumODnOznjaDSO2Jj5+sGLggQwyvHjLj2OZi8/eQ?=
 =?iso-8859-1?Q?8aSOUSEEh39MOZoRjsGOiyl0w2GMl/Hx0cXAVQowMBoWltEt8lzp6Yb+CP?=
 =?iso-8859-1?Q?qf+ot+r0/M4EEM0mM/Vns6fwKjw6FUZ1Ga6Z2KNYRq/7ZG3EeUOECGY0NT?=
 =?iso-8859-1?Q?AMFgk1z1NFCecPWpxeiSFgNr1T/QY5kLOcIncoDjbUyrgMr1JpsTO/x3kI?=
 =?iso-8859-1?Q?8IMi5Af7e7wa2YPl2K6j+kMbBXiadaGjFyHRBISPWIgTTeOQ5yAW/afIFJ?=
 =?iso-8859-1?Q?/Sf9ftd/4DaPW9Dt3tuj59x8aXAPkkypDU7WpmehmN6atvQCvUrVcXrZY0?=
 =?iso-8859-1?Q?KCFLNonKGZUpDYGj7Yp5cowGw2z5kNeJOk5iA192Lj1Iiob5N1TrGnMPHu?=
 =?iso-8859-1?Q?8Yf1JYWRGL1AAWZBKXM/FWW0oNNGx0HBhHYNwjfweispn3TESLlweblG+X?=
 =?iso-8859-1?Q?PIsuddbr0wlURJmKScgpOp0GnBREaHBsKHZbUrY8m46478P6ButJTVVzha?=
 =?iso-8859-1?Q?ZCaBZf6+jNC51+DLJ66WxE0elVMyqcG6TmXrXg8tVSvBpcQMRp5BCEUxrR?=
 =?iso-8859-1?Q?teT47pFCxxOhRsxyX/X9MNovB7REAA132trEcW2ctyxUkR7dqGY1OUfccj?=
 =?iso-8859-1?Q?JwZFbceQEOn7Gq+t1Uqjwq0SIwqvloKieMdyF9XiROlXre1WzL2RbM9+2w?=
 =?iso-8859-1?Q?OYRqE32qZNsPwh4KxnI3s1NawVqiw7xwWm6Zr0Hq09YA255FI1NCiBm0bs?=
 =?iso-8859-1?Q?hR8yjHnjkJIWE+vbN6+h/WiHPcjSVuaW/x4dU6Vdth9MHI3/fL9mobp2N4?=
 =?iso-8859-1?Q?2/YXrgQw3KzwZNXw7cTeXxShaPstC2nILj1D4/EVqWNYhftG+xNDXtElwu?=
 =?iso-8859-1?Q?+cu8stpb4JJHqdHczefd/hqFZS38pQbz1odYjTxpcNajutKKed44c+ADyP?=
 =?iso-8859-1?Q?ln/nd+z03gZeLMGpP5vwMTgscX94CCyc36JDcsvhIZ3TAxK7usI7MAZKmQ?=
 =?iso-8859-1?Q?i5B27mahf1sXwlrF6IAXug4meMTffeyKdeSSktXHKttfbIsLvwZh26fenb?=
 =?iso-8859-1?Q?VrtRHHadHu5sowWlDCbAuhseoc12VGHLqeDswDD+RrRLiDiV2uBLS77XMJ?=
 =?iso-8859-1?Q?iFmPSyLPFuFLanOvJRaesmOYwdgc5PeeP6r4jNfprgndXGZb7iDgJrZDCM?=
 =?iso-8859-1?Q?f3DtF26JTTkZxnsTw9fQS4go3ql6DYHtpM/u8AlrwCtfAZzOnHzad9ndTv?=
 =?iso-8859-1?Q?E/Tx?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?4dLmeWrquCFUtK0pLzcHL/ZYOTVLjsrMTJPFnil+jFFi8O7ef8DXHow98k?=
 =?iso-8859-1?Q?g7t1j6d/fJdET7n7g8XTysGs2ss6jfxdq7z/Tr4hEIHwrKIny1/+FMtQKI?=
 =?iso-8859-1?Q?i2W2AP5XPhnR37BnuSMnJxe3PIel8WRFpMFunfARoLt6lb1ZXG/0MLVfes?=
 =?iso-8859-1?Q?mnCH6eXcc5aNEUvjYcdoB5UTzqSJDqP8jYiCK2Z/jzbrLBN296xBBuJvK6?=
 =?iso-8859-1?Q?N8eOdlHzLI/WrcGGtPau0+/yylyRuuG1nARgPeanaemKyFiH3x2aVRbHxM?=
 =?iso-8859-1?Q?hRECGOu/iS+dQRxaT9tFTCjK5bcf9gBAo3e+fkUc3BLdidX1tGv8pumJkO?=
 =?iso-8859-1?Q?U/t8sK0ypRndO2zSI+HkqdqFfcfht0WyRLPWi6GENcEbARIBY/jgALNlEo?=
 =?iso-8859-1?Q?fYqCvuq05JX4cCAfv8sDi6MJgk+7Ufougotn3gwbOIfWbNCy8YEKciLca+?=
 =?iso-8859-1?Q?Bm1R2MUjwCRzMt3cd67mMNZEeSNhdognry0VqIhsLWTaM1VKvunY45xVvN?=
 =?iso-8859-1?Q?D4NgOxTWg89LTfquqe1VUz2NZor2jJqnN7WvTctu1O4xQt55XeuZ4x0HNZ?=
 =?iso-8859-1?Q?RHcLG5xdCgyzZMLWdgvpq+pjgl5iiq6q0gBJ/nu8DAus3/SkAoi17R16WF?=
 =?iso-8859-1?Q?OA9tjC/efMx103HXdkGVi2uX6NZf8ImLuNLT7uuZfabbkeUq8dmyft97t+?=
 =?iso-8859-1?Q?F6fOcPjZizJLL7tC+328cHn7W12CTbMPRF4ierbkDvLn+sfdCO/Mxdd/o2?=
 =?iso-8859-1?Q?naHhvCjkPhheaSfWYioPVcG1UOHDQWP64GCHmUnqrtQZk6JDtEqvuwu9E8?=
 =?iso-8859-1?Q?NYCH4erbBuGQzBlOpL2LMuz1ueUK3SX7FDLoL1Zj6ExzZLZALKQcEKgaDO?=
 =?iso-8859-1?Q?SjdtWtHEPaGSK8JIQvunWWteAS9yTiZ1ptZ0LnGfn8xNUsgj8A8xXl8l0S?=
 =?iso-8859-1?Q?bfUiGdcUyv7vSAddR35eIye1+vqZKvXcMbxY6Ol1f+OwHt0QS2uLxA7tzR?=
 =?iso-8859-1?Q?HSwvoBxlFRo7Ck3UHFTs08LkCppgDayjt4QKnwUHssMmTloykKHq5LHE5i?=
 =?iso-8859-1?Q?IpgCQnwvL5PKgaFoSsHHhhGK7+AVQj38T4WvW05f1Tj8XubibRjuLKYFCm?=
 =?iso-8859-1?Q?vIGJuYU+tadzkcEMoKtNaIat6f0YMxeqCf+3/CFayJhFnvDO5QEdE/bNv2?=
 =?iso-8859-1?Q?WrJqeyd4HZ6uFFNshzgqTMoO05fltye8TR7hC2ZqIurZxQTjIBA43es82S?=
 =?iso-8859-1?Q?yD3XUKoInNY+P7CpEMhXHvW/SRY1hIUm4TfIU24DaQz76pB8tuWwLYs95L?=
 =?iso-8859-1?Q?YlsMwauCpd3UQxhabW0KS7u8TcchXiGkZkZ5/p91Y7snWaIKAEuqz6DErA?=
 =?iso-8859-1?Q?zIIK4/VR0oplCEFggCq6TVqjKO3ve9RvIJrWsdpbtoy9xnplyYmZqiH9c4?=
 =?iso-8859-1?Q?QTQ3hA18mAlr2YJb?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 44335025-01b3-4781-979f-08df2d2e3dab
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 15:41:13.6254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR05MB999137

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
scsi_bsg_uring_task_cb() discards the return from blk_rq_unmap_user().=0A=
A successful data-in command can therefore post CQE 0 even when bounce=0A=
data was not delivered to userspace.=0A=
=0A=
Use the unmap result as the CQE status.  A later sense-buffer copy=0A=
failure remains -EFAULT as before.=0A=
=0A=
A raw BSG INQUIRY into an unaligned anonymous PROT_NONE mapping posted=0A=
false success in 20/20 runs before this change and -EFAULT in 20/20 runs=0A=
afterward.  Writable controls continued to succeed.=0A=
=0A=
Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")=0A=
Cc: stable@vger.kernel.org=0A=
Assisted-by: LLM=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_bsg.c | 2 +-=0A=
 1 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index 341142dda71d..f776c4a74fb3 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -54,7 +54,7 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_re=
q, io_tw_token_t tw)=0A=
 =0A=
 	blk_mq_free_request(rq);=0A=
 	if (pdu->bio)=0A=
-		blk_rq_unmap_user(pdu->bio);=0A=
+		ret =3D blk_rq_unmap_user(pdu->bio);=0A=
 =0A=
 	if (sense_len_wr) {=0A=
 		if (copy_to_user(uptr64(pdu->response_addr), sense_buffer,=0A=
-- =0A=
2.43.0=0A=
=0A=
