Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.166.238
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795533296;
	b=1L/Oq8Utd+oP88y6dfeR1HXFLYINRyOTD2XAO3guzdWtD0hVkeZSL614/+LwqH0afy9P
	 C7mUPSa3cM9lfIzlMT0DVSvTN7AUMMPXajq9vgftaDcAb8ES1Zq9yamfxEgme3nW/3F0a
	 hc6MEqVs0wWkpqGhhK914WcwUovyo98gI2O1v64G3ElbMO5qyv1tJhJ5I9OmGpJu3YUGr
	 tXvj1cBN1U1ICbviHhhhNWdp9Z+lIQ3zuuAi8+UohysLuVXZDdTm3zzDr1G2moVrAJKmw
	 nuX8qWl5aupHyP6XgvvVamAnYb4rTESe2334nkNv8241M8gnhzm4GLqC5rY5AvbFdSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533296;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=WbRgqjICetzgvxdVZMybBQI+PGotIsOCPCuJXQ9o4iQ=;
	b=SsBAtrmDS+BjITzJbmvNSuadCWzmtzBL9xYR853vabgitKSzDdvbE4s/1CBMAFjx1lMz
	 qOrn9xZtCLHIaIyAy8GEMxR/AztZwjDB62SfVCukpiz1p9JhlA9F86mAJtbEsWnUkihov
	 YYb7AJ93qw8V0yAVkhTioQEf2Q/zOaHk9h4LM74PTqjFgox2iAxCVCouDhoP9ejlSq1Jr
	 RBzeUezJZQn17xVMNbM5MP2KGDw5KHDUbcfqY+IvwDztLP+yU1U9QvmOfPI505C6YoB4Z
	 m1q9A6AbZuRrJtxz1X13BiIsM1nbkkhTsRwpebyxvRMgW29A+da6O9e0xI6cSX8r6xw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=windriver.com;
	spf=pass smtp.mailfrom=windriver.com;
	dkim=pass header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b="hGCn/xhu";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.166.238
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BE0606A333;
	Tue, 24 Nov 2026 15:14:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34BE0606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b=hGCn/xhu
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOEd0Sl2160695;
	Tue, 24 Nov 2026 07:14:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=WbRgqjICetzgvxdVZMybBQI+PGotIsOCPCuJXQ9o4iQ=; b=
	hGCn/xhuwi3pe70oRSxlEqKkTsSwQvet7FbX74Mq7z5bm0GWsVBgGa/TOsCZ0wt3
	s5JuYO+CDCdgI39k7CdsYdveZuorR6RkIoKKq52MhmYMURk6ZMOtSdK85RCVIKSz
	+mgFXVMcvAKfETW57E4eeB7uXOwlVu/K1hh1RBWlKlaIP3YWWGaRKIU7FLGrn5HB
	z8SbEdZdZNhUWRBmydKTDpqvNuOd6EjEfvPRnH4eiA6FXQmI2mSsM2IUdaF8SVUu
	roY0XbfxY+nbCjjHp00TBIR40sdD8+q7Be/flrl3vGzMiHqp5bk32pH4nUT6jKrm
	N9VBi8n7BWw15yku5dnkfg==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023096.outbound.protection.outlook.com [40.93.201.96])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4j516ws0w2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:14:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SDJhp+AekiKgV7UOqf9UlnHAsovvzZkGy1frzN9SpgE/0f3nZMqoY15Fls3awLUXmB0aIumKl/RSPX8C2XuXBsJJj/pDBRZSQ9RnuaTOeNQYBoKMm88H8eomRfzP2zjY5NdnsYjxgfdTnOzVFwhZJRcL97bU5MqGLGEooKXWOkA0kSpWnFqGxrARD1VB2/Rzpr4IGUIu7rPmOxvLPkXtNaPlmYlx5U29RRjQNL/EKN6hGCBB/XZl76j8D8Cd/PWpFv/XoJNYU0varzkn3CcNkhkMKwCEVUby2yfnvRlC3xsnPuGHPNDZEcR+uXvUwzN/sQAnRx1owUc0/Qdaa5aCyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbRgqjICetzgvxdVZMybBQI+PGotIsOCPCuJXQ9o4iQ=;
 b=PaljI+RgTJ0BtRaShn4R4lSVmgDiMNnQS/ehmCs/hk1BllshlD0UOkXq8mg/Cke/dtz7Gn7n1mNChy6rX8j2ONvmrxhpv1Uv5t7xyIfa6yDNpeMGlLIh+Xif38nBt8aNKT44AqfSBMPlVd/RWLK8UoQarfLq7N9cmAQ+oiDd4Mh1FwXgnSZARwcX1p5AIdIY9ylkWwNaB2AQgn13rlW4QcwavTJjXsGOXY45xSrGr/AJBQDeTA8wr4dNRb1HvxTpKpe4qxw+5qno0+3eY7uFfOQm1ppNYal0DyhM3TmlqQ17tW58mZbDvLG2d27xfVpnVlGSt9CuNJxDGPbp51rZjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=windriver.com;
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by CH3PR11MB7913.namprd11.prod.outlook.com (2603:10b6:610:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 15:14:35 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0639.010; Tue, 24 Nov 2026
 15:14:35 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, mkp@kernel.org,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ionut_n2001@yahoo.com, sunlightlinux@gmail.com,
        Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v2 1/2] scsi: megaraid_sas: retry zero-byte DONE_WITH_ERROR with GOOD status
Date: Tue, 24 Nov 2026 17:14:09 +0200
Message-ID: <20261124151410.43279-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261124151410.43279-1-ionut.nechita@windriver.com>
References: <20261124151410.43279-1-ionut.nechita@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VIVP296CA0113.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:358::6) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df29526-9e08-44fd-0ff3-08df4a3da63b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|23010399003|7416014|366016|376014|1800799024|6133799003|22082099003|18002099003|56012099006|5023799004|11063799006|261026140227099003|261026121527099003|261028144727099003|261021123027099003|261009223027099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|38350700014|10067099003;
X-Microsoft-Antispam-Message-Info:
	mjIg1he8cvUH16x7zvIg7m4Kpkbs0JkepzJpA9EKPwM7R4yaMHDkyXjgF83UMR41ypyEmo2k0ElnlaB1Tl+UInyYcp45ubO+T15JFCsZRmV8J3KTON08nFUA5qS2G3MDXxScF5Wju0co0lqTVu16y37uDN/K3srwvd3FPOicwD7yY3u3o/0l/wArXacZDZeguNmcyI4ezSUD2fQDxdDmw6q2YKN91drefn+ycktc3gd8JUA0WYEkLrf5kPF+wRKYRoEw2q3ZR5xZ7WkQIZLmSkqY7dazwoCrH/fS9da/w08btkgNM3k6MUSP84782yhPZpKruCMT3XifpRv4go0zvCIOGDoGXBi8+aQsLHUysMgpk5wuh4+gLgWIBnbsPShabMS1qY5xFq6jx0bL4dRUiVNwZgJSc1bQ36P8NDwFZ+Fg/sfO018ta93yAX3gA0jpTJLY7h/7y2sJl8PrrqksXoIX8PgRdCBAGoBEHwww9lUmTxi9E8DIDxRsARtZWuTRZU/gHsRx/8WsmiD5gCu8cEz5AzmdIyJTC3N/HduWJhaWk6WntfnqU4QtsEmcH8jSb5l5QAjgcUc2riTL6R+t7RDyiNvI6vRRM0e4Nfg/A8mzvzvs8NzPPhvpV2Qb6UQC+JMzmjti6x6dkPOnDXUCFM8wk5sxQxroV/NQVsRTTF3YGYJHdPb7g9UL2csORSC8J6k4xeUr7ZLUWTkj35iUgIB3wYSL/UYddYDZM0DS4ec=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(23010399003)(7416014)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006)(261026140227099003)(261026121527099003)(261028144727099003)(261021123027099003)(261009223027099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(38350700014)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PfYRm1jM7y5zx1Is7GGNFIBdyjwDhee3hkCVGt4oaGcf+frICT21sPIsz81b?=
 =?us-ascii?Q?I7OJdasT55yR+0UVUe3AEIpqWtIC7yj7N164g3lkK5sFtD76Bk8BhoByYCFF?=
 =?us-ascii?Q?221OH2DcI8zeenPpyEEMFCxqGmB6cJu3F2dqI/7Q9kX4thgivdAItK0/PPOR?=
 =?us-ascii?Q?jzDjOlf16rHhtexRCqpNNQ0HiCJAVypbzeXvvKEIhefFwRjDy72w/vOTUJIw?=
 =?us-ascii?Q?E7/IkNrW1ZY/Tea+qwfI4UiCsiwGNfSQV6gFKSQDwJ5TDQBKJ7fRuwG0DZme?=
 =?us-ascii?Q?Hy7Xdugchjq37KxONiPDYuoZ6EGGAY8bDtQRl+Q1jt+UYPKCvNw7XEv6D912?=
 =?us-ascii?Q?HF+sfooaRnlO/4Oa7e/JAmqcJtPjoNlr0xXTqc/7zKN1Ym8Y4o/419eN+C0O?=
 =?us-ascii?Q?n98TFQ6wVX7LR2pj+ICIPM7j4aWwf67o9+i4z7kMXFH4ULV4IIxW9l7ec3RS?=
 =?us-ascii?Q?B1r7nN9EHFt/0hVpb/hA9rlAdzLEgLFiJ57ZXBB0cwpCMuxTnTqPmIGYPaY2?=
 =?us-ascii?Q?ztTHq8SA3o4h9M5iq+xXuCMSKlqWDj48aSexWCvUjNokHli3Bmkp2fpB08Ho?=
 =?us-ascii?Q?HfUdI0m+kCBkjJ3Xc70CvDhvCDtY92p24bNQMlyOYfeIaeiohRu09NwhXFrL?=
 =?us-ascii?Q?6frlOVVDkO7s8FHzQkBGRB+xq7IYOI0p28LMoi9LLYhSYq7fqpaHhGeHcj0s?=
 =?us-ascii?Q?w0b7HUV/1Pq9Vz0c53yOtv03zdd2n9dKIhLRM7ZXNXp+ryO1QnatK6CPZVQ9?=
 =?us-ascii?Q?suA3auKSKzp5Z7Xwqqpkk0y6j/mZmgACz3RNBVb2h/tTxWiakJCd7Ax8Ir5B?=
 =?us-ascii?Q?aViJwWAQ2YKz5f3v9/idkZLl9/SY73px4SDZlkNqnBHvpq+u2ujXRJCJwqdy?=
 =?us-ascii?Q?SK53CMIa4ax1UlqgCdQ3deNR3+Pcf/0iFthLVS6Jwqn7/VewRFBADjET1Ibe?=
 =?us-ascii?Q?I9BRTUWXPi/kEA5qxkw1kwA3I28cuxF3h15oXgC+25Z34hPRnbO8kJoRgdPr?=
 =?us-ascii?Q?Nb+d+syaei9vQjkvc96O1y/WNFcsB6cjG+v+lHSSkEzEdrP/ZSVrtgNNa2sN?=
 =?us-ascii?Q?FMnj9Xebk/FBNYrTrDJs/38Q2TMqtdzZzgPoijrQPS5PdJQ4Zf+SuIcbIRUm?=
 =?us-ascii?Q?/0499cqxV0qMzhAovAw8WEHbj/qoCtlkPq5uopgXLn06/sjawHdUo+kgAXpZ?=
 =?us-ascii?Q?7EZVnH3pN9TRo155ynqGNk7IAvqnaY5YoNWqZ4yT1kroIyaD0MO/e4ymMDyZ?=
 =?us-ascii?Q?gqbos/OE8PDl/X0YlhPTXzicXnUwlEsByjIqdYigyICXhal1cqDdYHjtH9dV?=
 =?us-ascii?Q?dQGQYRP8/2s5ITSux5+IneLkrgWG5rvy+19niX8465YYJBw1kptpbbYs8HJs?=
 =?us-ascii?Q?oQWe0DHzQrKg6vY3k9xbOHHCyukkHtqZGVYr0KjIthb8n+Is81ncvEM2h4zL?=
 =?us-ascii?Q?iJ4/fCeS7sxezXECIBNM3wustG7YkF46fB2PhN+KpuaTLQdMjV7Yfm7TuI9y?=
 =?us-ascii?Q?osYQEu76r99ECnFM11yb4CvGwEiuaHvr3liCWl0gVQ/ncZXCMfVrH8Q0r41z?=
 =?us-ascii?Q?CkXyfuEhmgLhKe7E6mH9lU7O2sx8eWPdZxLgt8umtVnPzh8egBTwZgLuwo6a?=
 =?us-ascii?Q?dNuLHnj5mwcG7hpW9tO87o9Ev2lH9+RSlij6clvhhJnlKyDR+Vd6mkIudRIx?=
 =?us-ascii?Q?KDQsPiFTXpPCDO/5PZDuxLrtzdMiPpb/8b9q06vsdsdIZikRWHpvv3DA0ZEs?=
 =?us-ascii?Q?kp9IOxLf3Rl9NRwmdRAXlyvtJrD3e3Y=3D?=
X-Exchange-RoutingPolicyChecked:
	C2i2tprngJ+AR+EUr1choP9v1Z89C4gq5T2xCOH8w+Y5VRZxxiA1uhPGLheJV3Xvo7Sbtu2NlxKls6GGw6GfcY5pYewkJdgvhJ0iSxOWJvU3kc1HPShz8Y8hOwOD4oyxUCUPz60xVXuggqNdv+ysHbVx9Bbt5euKs0moLvIVmBMixWMK8PgK4w16CnhyJUNOr3UgdfzMN4YyWej28om8Cz9FZxvt7hIgS+RsVrSduGlFN2dPE9AVnCi3CuW09Gxp5PF48l37R2pr660K/ojemIOpuP1vk29B9WLAH0Cfs1a6FRo2RR5NyXn/gZv2Txk2lFiSeQAvXpUwIv26JnsdDA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df29526-9e08-44fd-0ff3-08df4a3da63b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 15:14:35.5327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nAwIKa/y+omfTK/Xyga2bIrKVxV+fXMbcx3BFZKqDNU1BTWMYM9eUixY+bltxA+UqMg0hTwn/lJnr1IKyVNh3Kjnm+CvfIKXOEoXmt0/Q/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-Proofpoint-ORIG-GUID: G1CNvA2KhRrk9aQ6lOKqTyQA_70Jn9Cd
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA1OSBTYWx0ZWRfX/xcSw0u9gQtw
 H8TMRD840hNRbFR3tLZ85/pHQnJ/zbK6ccMyhyrKUFYDO9TSRdBLjbJ9Lzz/v5vgwNbtC/Ujl1c
 +YamqDcnXW6mGMjqIQVpWjGtEPrxuyvQ5pMWpHz3Rr+xRsG/f612
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA1OSBTYWx0ZWRfX32SEIJ5pJ+Q6
 MBN2xbYgLXlLMkdUqupJoJJmEp2g7KLeGFyLOrEJvOoMfJBrGHlFbcUCpu3W9GooE+ynS2IF+ON
 bXgauxRP5kBDEFRNgN7GP47Ba759cLtst2KMeE6sBdIsmW8EQQ1cczSw9c633aaBv8ZpsRtiDar
 H1CUNsODIyIbTUjODJbwJF73w3aPcMkcjrPU30Dl//D8VijnWVizSXwtXnCemfP610uiay9CCWg
 UNY4T5UkplDbxU2HLwdJgTSsEwKTImVgTfGYln2oF2mu2qO19JHtUQ1DLk1GhilAOY9WdLuxlqZ
 7jV19WnPrPQrvcMVCDZo7TateQY/Xj0NoeYDDz3j7rfxWTXMwSzL5ZEymD2bgZfepHV4TDRwVGE
 CFNBINCZhVQ+H6JEvaqYRO1F49d4C1De83iLfvLd8ujBVyhp8eMhuUo6oE2kKYISWtDf31x/lEw
 26O7shC79SYD8MmrI7w==
X-Authority-Analysis: v=2.4 cv=bofZl0ai c=1 sm=1 tr=0 ts=6b05a9dd cx=c_pps
 a=8ytssxGH5sXDYVMDm1fH2Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8
 a=VwQbUJbxAAAA:8 a=GYMwZzm88pOsWk0foCAA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: G1CNvA2KhRrk9aQ6lOKqTyQA_70Jn9Cd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_03,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240059

From: Ionut Nechita <ionut.nechita@windriver.com>

When the firmware completes a read/write with MFI_STAT_SCSI_DONE_WITH_ERROR
(0x2d), a GOOD SCSI status and DataLength 0, map_cmd_status() returns
DID_OK and sets the residual to the full transfer length. sd_done() then
reports zero good bytes, scsi_end_request() completes nothing, and
scsi_io_completion() sees result == 0 with bytes left. It requeues the
command with scsi_mq_requeue_cmd(), which does not consume a retry. If the
firmware keeps answering the same way, the command is resubmitted forever
and every task waiting on the I/O hangs.

This reproduces deterministically in a kdump kernel on an Intel
S2600WFQ with a MegaRAID SAS3508 (1000:0016, 8086:9461) and two SATA
SSDs exposed as JBOD. With reset_devices on the command line, the driver
disables the JBOD sequence map and every 4 KiB read is completed this
way, alternating between both disks about every 90 ms with no end:

  sd 0:0:12:0: [sda] tag#60 BRCM Debug mfi stat 0x2d, data len requested/completed 0x1000/0x0
  sd 0:0:13:0: [sdb] tag#61 BRCM Debug mfi stat 0x2d, data len requested/completed 0x1000/0x0
  sd 0:0:12:0: [sda] tag#62 BRCM Debug mfi stat 0x2d, data len requested/completed 0x1000/0x0

The same pattern was seen on production systems as hung tasks:

  INFO: task systemd-udevd:267 blocked for more than 245 seconds.
  INFO: task modprobe:296 blocked for more than 246 seconds.

Return DID_SOFT_ERROR in that case so that scsi_decide_disposition()
retries the command up to cmd->allowed times and then fails it, instead
of looping. A non-GOOD status is left unchanged: it already makes the
result non-zero and is handled by the midlayer, and CHECK_CONDITION
keeps its sense data. Partial transfers still make progress and are not
affected. The legacy MFI completion path does not set a residual, so it
cannot loop and is not changed.

Fixes: 31d9a57b419d ("scsi: megaraid_sas: set residual bytes count during IO completion")
Cc: stable@vger.kernel.org
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
Changes in v2:
- Only handle the GOOD-status case. v1 matched any status other than
  CHECK_CONDITION and overwrote BUSY/TASK SET FULL/etc. with
  DID_SOFT_ERROR, although those already make the result non-zero and
  are retried by the midlayer.
- Drop the megaraid_sas_base.c hunk. The MFI completion path never sets
  a residual, so it cannot hit the requeue loop.
- Rate-limit the new warning and keep the existing debug print for
  partial transfers.
- Describe the requeue mechanism and add a deterministic reproducer
  (kdump with reset_devices on SAS3508 + SATA JBOD).
- New patch 2/2 fixes the cause of the zero-byte completions in that
  reproducer.

 drivers/scsi/megaraid/megaraid_sas_fusion.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 056cbe50e..2877b3829 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -36,6 +36,7 @@
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 #include <linux/irq_poll.h>
+#include <linux/ratelimit.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2064,7 +2065,24 @@ map_cmd_status(struct fusion_context *fusion,
 		resid = (scsi_bufflen(scmd) - data_length);
 		scsi_set_resid(scmd, resid);
 
-		if (resid &&
+		/*
+		 * A GOOD status with nothing transferred makes the SCSI
+		 * midlayer requeue the remaining bytes without consuming a
+		 * retry, so the command would be resubmitted forever. Ask
+		 * for a bounded retry instead.
+		 */
+		if (ext_status == SAM_STAT_GOOD && data_length == 0 &&
+		    scsi_bufflen(scmd)) {
+			static DEFINE_RATELIMIT_STATE(rs,
+						      DEFAULT_RATELIMIT_INTERVAL,
+						      DEFAULT_RATELIMIT_BURST);
+
+			scmd->result = DID_SOFT_ERROR << 16;
+			if (__ratelimit(&rs))
+				scmd_printk(KERN_WARNING, scmd,
+					    "mfi stat 0x%x with no data transferred (requested 0x%x), retrying\n",
+					    status, scsi_bufflen(scmd));
+		} else if (resid &&
 			((cmd_type == READ_WRITE_LDIO) ||
 			(cmd_type == READ_WRITE_SYSPDIO)))
 			scmd_printk(KERN_INFO, scmd, "BRCM Debug mfi stat 0x%x, data len"
-- 
2.55.0

