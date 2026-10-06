Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EB03E5EF1;
	Tue,  6 Oct 2026 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791295164; cv=fail; b=c0/2kSfZ2mnJsu2iPIU/yDWmxaXCS18nzxKPvBDRtK87kY4bcGCnQbEhRS1TFe3DQLsW/ccWvepfEfoyW82Szz9UhYQha/tQRSYhjCbja3tAAi2u5AYIKFTl3geIfu6/qImvSHjxmFQEm+M0cawgb5gnpD2Oh7MbgPwEcglleX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791295164; c=relaxed/simple;
	bh=fVfnyvni5uaFsiCqVKj81r5BedN1R95fOKAPeRSiHTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e2ZLkf6Dq47mIHG8WaVYq9XqG/eobCpBPt/nLpoiYgI4cuOF0nwBCiRNZlgxuuGxgY5X9Uxu4kgFIfYKiG7eEv0ekrIk1o4obrYCzMVRcbSIbTL+nPdoAA20NOzNqVNay/QmVi1K20ICU6Az2qcJJPVpX3DFZZtWHvFvKIq9JmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=HxEnMipI; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="HxEnMipI"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696DVif9675698;
	Tue, 6 Oct 2026 06:58:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=8XwUySrKGdMC7hzT8M9e3v6V3n4V0VASVF4JmX+VHVE=; b=
	HxEnMipI6IAuz+M2qxZyyFIGKmhWE8s85ffCohORuAYtVfeIXUaqyTK5bQEPom0a
	Z42MPq2Q6o1LI4okBz9mVdLyfwDy+uduhQ/EjcrqAMa7bteISymdAPgpzwHbIab+
	+XEBh8y1B7yL/sEA5Nt/xvFvz92e7LAY0ls+g0rCdI7ifqCliBOvaGf0XJ7jbm8q
	reYVy0vXXnep7srVWv7kXxgUoUO8Kh7NhEax2bMxTFmte784EkUzL5wVez1Bn9xH
	hBx3289oKyZMXYircTefMZcvEerw4El2BiiHDzlaPqcbZ0feT/BgOiVgtne8fvwD
	O4eDtIBkHI/1uurF/z9EvA==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020140.outbound.protection.outlook.com [52.101.193.140])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4h2w013w84-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 06 Oct 2026 06:58:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2EdYkkzSuGqdyPLvg5wBrBYerxNAfPY5kWD99UJqtxYw/ClLsrXsBCr8h9tvkIUzPYhnWiYmc/Q1y3Fz9vm6/xV158NFIyzqnm4+jC9mjOQPaOLxYEbDjgcrKx2bLWXiuL3YuwOpDWwx7WNJfaQt9BPCLH0r+5GE8ZmfzvouwMpKOEeBTZPWDLactC3p0BciMbb4zCnyisiH+F0MbXEzqCdgd8PIHUauDIv7e135vzJH6lY+0OHa2ZwUCuHMEs7p9FYeBnsXJlJTfsqKUJ//oKABqEcwVTrCC4zqp478W1Z6JfQDl4cxyxupNriZ8ClddUjKQ/91HWh/QdfR3dc6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XwUySrKGdMC7hzT8M9e3v6V3n4V0VASVF4JmX+VHVE=;
 b=ltNveTL+UIEQgjCPbOUFYlnKmPR3U34lDgyqmgWsMwLiMxNHq1VLtrBtJy+ukygiCRg6cR2e0XO79Bhy+e8qF9b5uhWn2kP0PjZ84N5WNimKLfnX8McEQfo6tr2/09SwDfTuss4Vz29z/T7GjQDIODuuFiBMLmOcLCCa99u6dFZ53o/69sJO1utcy1WSUjHKJzS55JnXnyR7ADTYwQ//svvUhP0MiqI/l5SLF7+wlYcni7JO84FaOh6BZ7FfvAdS+3hKMYpW1UTO534agxbLhsCaUNgWjMsIDNyM+2jTSwc/p3copBgtykUTb5srbW12SdWwjm1OBL/MiuMsR9QeSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=windriver.com;
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by MN6PR11MB8217.namprd11.prod.outlook.com (2603:10b6:208:47d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Tue, 6 Oct
 2026 13:58:09 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0472.016; Tue, 6 Oct 2026
 13:58:08 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: atomlin@atomlin.com
Cc: axboe@kernel.dk, bigeasy@linutronix.de, corbet@lwn.net,
        frederic@kernel.org, ionut.nechita@windriver.com,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        marco.crivellari@suse.com, mingo@redhat.com, mkp@kernel.org,
        neelx@suse.com, peterz@infradead.org, tglx@kernel.org,
        vincent.guittot@linaro.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Date: Tue,  6 Oct 2026 16:57:44 +0300
Message-ID: <20261006135749.348637-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005152449.468696-1-ionut.nechita@windriver.com>
References: <ul7xqsblqnrzx67s7urmtc34qpemuf3jeduxmsuwxwlnky7eli@mzdpwwgug3hg> <20261005152449.468696-1-ionut.nechita@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0170.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::8) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|MN6PR11MB8217:EE_
X-MS-Office365-Filtering-Correlation-Id: bbd74f63-cb97-4a87-d781-08df23b1d9a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|7416014|23010399003|11063799006|4143699003|10067099003|38350700014|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	lnjyi5FpKsx6bsi0YwSCWjUlew3xoknUv0IYhPUjHFUXWitY3CZXWEY13XN8Vogj4vonEAn3petxNvXHlyVVYm3JAeTiUidELBKOXdDqn1X+hv4m9yzwqMjwuX2GK3NINdrF/44/SyXqwCULVxupTSuP4DERL9AKCfDoAR5Ni4kihgOwFQzqWBiM9DPn9WXO3Lb7qNd+i5GXN8T7EBmWFnMDPXkFiQHkFif0LSwfw9rnTGjfsS0Pfy5l/RXiZ0nfO7r2CbG1aiSIasoYZnvGY5e7YvNInaurB6it5N250Ev9ohLUernb8aMm7k54pUhmmMpjFDESGoTgx3ZsjwgV7bUSHkNAXDiST8/wz6q08uXWPQ2btqE4FH8qDSyCxYSaaZXKiW87Sp7rAmnK1UkebPs4lfVCysQNM+ILbElKzvrmQ/i+x6zfodtIVpI76TwT9/2oJ9bPL4BJuA54ZdJo2uj5F1/fns9DlLzmJnS1IvY9mU8/nmGs0dHu/u7VGQyCKa8uW7/Sjt8qdhFksnUCRc5OMorzwKeU4lrEt22b2X1JSMiBDDJKpCgqNKNOn9DxvqI2l9DVKNuVOQfLxvTAMDMclFjszEeGskERl8ndcbU8dVDdwVCzM9b9FEvtUJDxrYkzztK+g6Ne3PD9Y76U2YenZBGJ+jHTUhOvf+Fciz8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(7416014)(23010399003)(11063799006)(4143699003)(10067099003)(38350700014)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XWZAEzbm55kSzp87e123h4jbafoXvBre0J8lO4I/WyCdlPAqZy19gfC6lREr?=
 =?us-ascii?Q?GHOX7fEEB3QCpSlglL5w4e/61Bu2uGEtvPOsi9NvpaQd9UM3dvJeVfyNGjSX?=
 =?us-ascii?Q?cLFwB3O8Gnp6SpXMb2WDNrWF9W3opiEVLqV4vFnxjMb7koqBXqc2p+QGrw2d?=
 =?us-ascii?Q?bL14tNBlBR4sbxYX9BJVLYEIeL2nDvnRI7jSQfQP7VbsBffvvW6EJHGT9U3Z?=
 =?us-ascii?Q?nsEX08DG73ieg3qwn1k63tWRqasMubXB/ul/UOtePznc3uStqfTFgpklkq7Z?=
 =?us-ascii?Q?qeuXTnxSe14Gp+ckWehongxyx7TC4eXNW8V7GxTUp1I9dDJTHY0MX88u7Xef?=
 =?us-ascii?Q?fQbI3x9MmZBJXHhh+rZPEsyK8ILZHw+m/StPWNnEt9o+9I2eeXcGu8i9x+Ck?=
 =?us-ascii?Q?d9/TZTuHTzN4h2+S76JgZFNQLlXQfxtIvgIFuYc9GkXIiyT20JDGe5dyv1vH?=
 =?us-ascii?Q?qHBwiZWE1CEnSmFDn8E9hJeR65IvcxD73c4BDNBhu8ipLMLirdkjJw5Lm2tY?=
 =?us-ascii?Q?yGInhIiE2H7sq3zTztZWo4IimaJmS2hgz42A9yLeW4956rRwrDByHGGIAiXd?=
 =?us-ascii?Q?5L/LPUPLrbdKRVqP6FjgXAXd2NTeFjWjEq7Oqy5o03wMKZPKMoZ4dU6Zn0GF?=
 =?us-ascii?Q?yA9r5GNjRj5/fowh0mKy15fM0Nn+BRJrbty3E+yInffHd+VPyPoeW5iNJWyI?=
 =?us-ascii?Q?XJH0VdW1DCxZaCgcdoir6IQ60fFMJPgmPvRS/FZEPIUArH6nQGlEbTSbeOGs?=
 =?us-ascii?Q?seoF1FXEZgLwCpK6aLDqik7m7MympxajCzX9dUowqo8BRfXwRpB9NNgcSzyH?=
 =?us-ascii?Q?c7rVG8OKC/jYdFM/06nMIZ2MRgm4loyYBeENAtDcXkCqvCQad6hTruMhxbB7?=
 =?us-ascii?Q?uQcgasRKYvg1in7EKO8g2E4zglGoSj9Kz77AMEHVC14ESoWbV28WychZrxmt?=
 =?us-ascii?Q?sSM0e9fCaGzjPd6UoKOf7mDte/OJfVo5x1C54sNBDWRGB59JeYhkGNdCgM3w?=
 =?us-ascii?Q?S4yfTHR9SozHTxzdw/v6p9V5uiTbxBaQ2xFavSaDQjiF+ljVXNrWfd5IzsBe?=
 =?us-ascii?Q?sujO4BmDNDw4OsR+/Rdh5XlwQyDHa/NNJnV4TZwbDfeZ7RNBxDEMDOTjfFUF?=
 =?us-ascii?Q?0UtVqVirUMRkrugw6zd9bnWAjtVROBTAVaIA44xVpqQcLh+Sib+JSet0EWX4?=
 =?us-ascii?Q?Lp1qG+8bqjLd+8k6RNyPa5bE6UNJ0//C8BCL3AqFCdECT2O770g6HwcB1J0U?=
 =?us-ascii?Q?zpyvinPfTvSdkLyva0BAra4UYNTpGB/8oB3pbx7K7S2CyhDVrkL4osp4r4l1?=
 =?us-ascii?Q?n1grxfeRGBrksQKU2HJWfk2dwv/I3lfL7C97n5FhLXLetsLom3gEzNtATnzm?=
 =?us-ascii?Q?qRTIqCsK0v6aFkbkBABno2LFHpsowVw3czVKgQ9VkfdO65O+BCfe/eUdsXnM?=
 =?us-ascii?Q?FjgwAVc1vLIgCR1knW+7/XU3q7sIO6KDbt18x6JhBCevw9BpmwCRzopGhQmT?=
 =?us-ascii?Q?zGyx2ZVUN614YUnyVFtcv9GZM3fd12WIryn9sK2nYIC8ldjA9+wK/UNEUJEf?=
 =?us-ascii?Q?xdlKxysict/qi2jtwHL8nQPzcFExLGnG997W0CMRRSLoj/JZq2T7pFAI8t+4?=
 =?us-ascii?Q?Vwdlb/6ViA9gLqwNV9Y/UMcDJxNYsYxZoNV1UGqbIoZ62n6quZTyro4OyF5y?=
 =?us-ascii?Q?HTgZ8EEHfMNBQXbCRMO6yIDq45QWM0han7XM8wgCBZeTagAKNhduJpgciuDp?=
 =?us-ascii?Q?cKKEcO8AjZTpAkOXoXTQWkgrFM1WtWU=3D?=
X-Exchange-RoutingPolicyChecked:
	CrP+qbyEOl1+IVzL7VqamNWc5SmiJoiRgS5VX0pJlCIpf7189PJVroAdOvpFJjWxyYwvUuXJPD8kbaOMt6AChO99Ki7u9dRKbOwx5pCFfPchzhboDadAByKjfBzS+SOV4QbFfqs7W6gAGfVZ5KMS+TyXfrybnbGP3RPbXMB+AqgQS5selfyS6DP9AoabZfI1ZbSzogpe85y15Lez74uJan77zKgm4VBVEO0WpEbwMUspgcpB3othSyh4mQwVwNfwIqSjOVCyrDfgn4EnP3mg91GEwkhnSD15yVy9NzvfZ2A0KOdgWPh1BfkuLMfc0oyIuIHwwAJ59RlVriGvnGKvXw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd74f63-cb97-4a87-d781-08df23b1d9a4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 13:58:08.1024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCumIvkFMhNdZibm+Rpf9PaiEbcwmVFdx6JlK/YjyD/NjWYEcfdESslqhqracuWp3/5FZTGtnPHVbMz7hqLlNC2RkYv7qm4rqDyZJPorEdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8217
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA1NSBTYWx0ZWRfXxoKC9gSelYZV
 ceXDUfVEW2shP50z29eIYBo+Z6Lye2QX/JCQ4Ooc+xGa3/7ZKn0cf1idE8uc7d/vXK50RcJMLy5
 LQXj5m2UdaQpmlKlbABgynxRRUHJxUcR+K34xW56ceGq4vxFWvvp
X-Authority-Analysis: v=2.4 cv=fKesTpae c=1 sm=1 tr=0 ts=6ac4fe76 cx=c_pps
 a=Wk45V16OzwFZ9uDPeOR8rw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22 a=xV5-xVNmMFwFGRjQoTcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA1NSBTYWx0ZWRfX6nzeEOSFMLqN
 HukXHgtMvESZBN3ERpctu/GZYAI9Xe9mSocq5q9zTZqfIbYAmgxHPCqEVKhrvur0KZLhfPuX2V2
 rsv04p3z7prrqHHORDKPgpQHLouo+kzwv7GRszAE14mM0gXDJOoGHemw+512M1uniYb4yEg3H8M
 v1tqp3Ma03IBV57vupmJxfLxq5av8mD4uAuSuhD3xCKBHiIBexwpybrIfozHm7FcwNziB5BLVJV
 6CaJ9I4860blenE20wtKCtBMPD7FD4uTQBpKEd6fFvc+tUF6kVQSGXI3SY1u91V38kUUUHs8I60
 gzawPrvGBZseLakqbNDvdsBg8iitzJil6RsrFU6xP+nufpxluP+avPATSgHHLZnYIP1vueOH3Vj
 cZLAx9D2a3plXQUyooL/ybLb5+NPDAueg8VCI6pbFsRok6pwzQPiwc7YIxOsIZL1m3FIjlEASR1
 OxTRFXgIj0ayj/xrbpg==
X-Proofpoint-ORIG-GUID: Orh3Wb6e7FFuHH-aSlsdScKa1u6jx_Vj
X-Proofpoint-GUID: Orh3Wb6e7FFuHH-aSlsdScKa1u6jx_Vj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_04,2026-10-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610060055

Hi Aaron,

Follow-up with the controlled data I promised, and a correction. I was
wrong to point at your series in my first mail. After a clean A/B the
control-plane stall is a shared blk-mq queue-contention problem on a
shared disk, reproducible on *plain* managed_irq. Your series does not
introduce it -- but it does remove the per-CPU-queue separation that
otherwise keeps it from happening, so I think there is still a real
I/O-QoS question for you. Details below, each claim backed by a debugfs
capture.

Setup
-----
  Kernel:   6.18.15-rt (PREEMPT_RT), v16 applied
  CPU:      2x Intel Xeon Gold 6338N, 128 CPUs, 2 NUMA nodes
            112 isolated, 16 housekeeping (8 carrying managed IRQs)
  Storage:  Dell PERC / MegaRAID (megaraid_sas) fronting a SATA SSD
            (Samsung PM893), passthrough. etcd and the fio target share
            the SAME physical disk (sda4 / cgts-vg).
  Workload: one fio pod, libaio iodepth=256 numjobs=4 direct=1,
            SCHED_OTHER (NOT RT -- RT is not required to reproduce),
            pinned to one isolated CPU (CPU 2) via the StarlingX
            isolcpus device-plugin label (verified with ps -eLo psr).
  Method:   per-hctx in-flight snapshot from
            /sys/kernel/debug/block/sda/hctx*/busy during the run,
            cross-referenced with each queue's mq/*/cpu_list and with
            etcd's CPU set (ps psr).

The decisive observable is not "etcd alive/dead" but which single
blk-mq queue the isolated pod's I/O lands on, and whether one of etcd's
CPUs is mapped to that same queue.

The clean A/B (identical kernel = plain managed_irq, identical fio 4k
randread, identical nr_requests=5089, fio always on isolated CPU 2;
only the device's blk-mq queue count differs)
----------------------------------------------------------------------

  (B) default MSI-X -> 120 blk-mq queues, ~1 CPU per queue
      All ~35 in-flight land on hctx61, a queue mapped to the isolated
      submitter and NOT used by any etcd CPU.
      -> no collision. etcd healthy. Device load ~82k IOPS 4k,
         sda aqu-sz ~1020, r_await ~12.3 ms.

  (C) megaraid_sas.msix_vectors=16 -> 15 blk-mq queues, ~8 CPUs each
      All ~33 in-flight land on hctx7, mapped to CPUs {0,4,64,68}.
      etcd runs on CPU0 and CPU68 -> same queue.
      -> collision. etcd apply 2-7 s, "request timed out",
         "context deadline exceeded", /registry/health failing.
         Control plane down -- on plain managed_irq, WITHOUT your series.

Same kernel, same disk, same fio, same depth; the only thing that
changed is whether there were enough hardware queues for the isolated
CPU to get one that etcd does not also use. That is the whole bug.

Supporting data point on the strict kernel
------------------------------------------
I also have one capture on the managed_irq_strict image (earlier run,
so not parameter-matched to B/C: it was a 64 KB read profile, and
/sys/block/sda/queue/nr_requests was already capped to 64 -- that cap
was my doing, the only way I could keep etcd / kube-apiserver alive
enough for the node to stay up and for me to collect the capture at
all; the default 5089 took the control plane down hard). It is still
informative directionally: with 0006 active, sda is confined to 16
blk-mq queues on the HK CPUs, fio on isolated CPU 2 funnels all ~30
in-flight onto hctx0 == CPU1, and CPU1 is an etcd CPU -> even with that
nr_requests=64 cap in place, etcd apply still blows out to multi-second
with context-deadline / health-probe failures. So strict reproduces the
same collision by construction, and the nr_requests knob only partially
masks it there.

Conclusion
----------
The failure is not strict-vs-non-strict. It is whether the isolated
pod's submission queue coincides with a queue an etcd CPU also uses:

  - On a device with enough hardware queues, plain managed_irq gives
    the isolated CPU its own blk-mq queue, disjoint from etcd's, and
    the heavy pod I/O does not head-of-line-block etcd (B).
  - Shrink the queue count until CPUs must share a queue -- via a low
    MSI-X count (C), or via your 0006 "use HK CPUs only" confinement
    (strict) -- and the isolated pod's deep queue lands on a queue etcd
    uses, and etcd starves.

So this is pre-existing shared-queue contention on a shared slow disk,
not a bug your series introduces. I retract the implication in my
previous mail. (It is also device-level, not CPU: during the stall 7 of
8 IRQ-HK cores are idle and the backlog is pure block-layer queueing,
aqu-sz ~1020 at ~70% util.)

Where I think the series is still relevant
------------------------------------------
0006 confines blk-mq to the HK CPUs unconditionally. On a
well-provisioned device (B, 120 queues) that is exactly the config that
*removes* the per-CPU-queue separation which was keeping isolated bulk
I/O off etcd's queues. In other words, strict turns a
"only on queue-starved devices" problem into "always, because every
isolated submission is forced onto the HK queue set the control plane
also lives on." That is a deliberate and correct part of the design --
isolated CPUs must not host the queues -- but it makes an I/O-QoS gap
unavoidable rather than incidental.

Mitigation
----------
Capping /sys/block/sda/queue/nr_requests on this device (megaraid_sas
with the SATA SSD exposed transparently / passthrough, e.g. 5089 -> a
small value in the 32-64 range -- lower for a slower disk) shortens the
head-of-line backlog and helps, but note it is weaker under strict/low-
queue configs: when all submissions pile on one etcd-shared queue, even
a depth of 32-64 on that single queue still hurts etcd. For production I'd
prefer cgroup v2 io.max / io.latency to protect control-plane I/O, or a
dedicated device for etcd.

Questions
---------
  1. When 0006 forces all isolated-pod block I/O onto the HK queue set,
     do you consider protecting co-located latency-critical services
     (etcd/kube-apiserver) from that I/O an operator concern
     (io.latency/io.weight, dedicated device), or is there a case for
     the series to leave a per-CPU submission path / reserved HK queue
     so bulk isolated I/O cannot head-of-line-block them?
  2. Is there an assumed minimum HK queue count relative to the
     aggregate block I/O of isolated pods? 8 IRQ-HK vs 112 isolated on
     one shared disk makes the HK queue set trivial to saturate on
     depth even while it is CPU-idle.

Raw debugfs hctx snapshots + iostat/etcd logs available on request.
Net: not a v16 regression; a shared-disk I/O-QoS gap that v16 makes
unavoidable by design, which may or may not be something you want to
address in the series rather than leave to operators.

Thanks, and sorry for the premature pointer in the first mail,
Ionut
