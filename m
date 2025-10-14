Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B76296BC1;
	Tue, 14 Oct 2025 21:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760477891; cv=fail; b=T4PsBKJ1XzMGpIixRNTgllAahUS2WBKkSJxITjRIS3tRMw7WHuOFKAOsyRa64difgsO2NGLhZCOFRRut9A3jhaD0WnM8p/zdli6HOVjfjaCIMhX8NCJY3GhKzgjTMuilflMjsVcsZdbIasyPvWOAFoaGPM7KqvZhBEIyVkqGOuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760477891; c=relaxed/simple;
	bh=yGe+bkrqYAxKhWXnLhIF2DYNdZDBZ3KSLWeYdyLDhgY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uN670+kKKbmyyDTuKrB6x6mmRvJeXHEkP8lpxF5kXnL1kj4sZBHEXJUV68LCdUXxNaccRG9Hm/zhFRHOSAvUR8E0a+RKIRllRWdhY+Eu+SIZeo+ADKNGHe/7zplcuN4AZLyzPra7u0IRuTY8PWLqDoGyXSotxZs+dKpFL7HqupE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VVkhybeX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DH9Umcuu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VVkhybeX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DH9Umcuu"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEfCPg014452;
	Tue, 14 Oct 2025 21:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AWZuYOLCvVQe8QzeR8
	/NyJlY0Nsso5dNQ2/CTxlEP8U=; b=VVkhybeX0nTco5Uywl1xZdQlmhCYWze5JC
	EfVqjikSri6dkgtVwNffVjFQ3rxY6aZyMqFSzgw1+WffkulmdpG8b8HSqU1noCQq
	C3uQ9/Uy84gDaQJ57824TC3c+2E3INfiTFFtSIGPsdYQ5zR4gSlVEg9xrvt7z1Ui
	eEarwi1aVjspqATSfBLUrKHKPxnk8FiIS5hz6bMLuMUEJ169hZghXO+dptAT2jeJ
	PtlclK5Nt0ofJQAh9ewOPcCwzs4DHMgMwJiw9ftiEGRuY46E5YPlt+QrriTiASaY
	Vi/7nBAo/oFVYTjF6R14BfAXJSBoHtWUP2GdUNg06ZYJqJ/TSUfQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1qcfca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 21:38:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EKGZSr037867;
	Tue, 14 Oct 2025 21:38:05 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpfhmt2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 21:38:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kgA4dY4pUMt/aIgijaj4QxQ6ebC6oNui05inF3vLMUTR7nfH6NP+BHuea7g29l58pGKiqiKHntDlAFg7d+NQKZG4b1AJxubM/CHa6ToBf8CD4mZMGpvkKOuPJlQ8X7kuabMllBOP76EOULe5T4WIJVsFjmqbdXExzWjD0HARNwJ2cBJwbeT+zswkFRbCER5L5CNif3KjIFbeRPRnvMm9S5siYqGC3E4JpCBYNLi5wtZgp4zl2U6vvmS1EUp160Hum2rYnaajbtEwuzBTssZ5WtxOcw/b96uGJenZ/sG2bo/KyGEOakjfvDq/plfq/C2NT2AggxYHIsYxT1adPqI/0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWZuYOLCvVQe8QzeR8/NyJlY0Nsso5dNQ2/CTxlEP8U=;
 b=vc2OC7vCsyD3Go6qPKussXnfIUep52RIeI12DF5Yjzt44j6J6FtL7MjqmCnuUDNWJWDuvNQQil2ZfWcZFdUkfnuaD7QaZGPHbzIC5XO3Ybkkqa2LOJWP7nSr2qRYMCukaGY0HWMEdkC88eLcGq9/hc9oRCX/adgz2Q5aghYYF/qlwELN16a4wyKHFHKvsW9WDx2hn47MHTSgpV3ytAEU60fu2q2cl5t1BUUlRwIPqiDIvwZC70S2WrQcYpDGsROI7XX7W4OkzFmSxUsl1uqYA8Il+ybARq26NaoC1bjvWJB1pd1VHX+CrQtQ9X7s2WrbnMiIWYihqgjmOWL9AmG2rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWZuYOLCvVQe8QzeR8/NyJlY0Nsso5dNQ2/CTxlEP8U=;
 b=DH9UmcuuTMGrge5cdJjoNjKYAIOiWe114jy9eZgblj5sVnble+B6UPm6R4yC85bz6sUrHM7XGPR6TmHTLrKbWey1f4Iy8qIJLM4V4xsMJfS74FKpDtJVte8VkYbVIwrg88teAFEiGqNo4kWLX/eoVnm42rrL/SfpjzigIKkumMw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5755.namprd10.prod.outlook.com (2603:10b6:510:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 21:38:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 21:38:03 +0000
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: isci: Avoid -Wflex-array-member-not-at-end
 warning
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aM09bpl1xj9KZSZl@kspp> (Gustavo A. R. Silva's message of "Fri,
	19 Sep 2025 13:24:30 +0200")
Organization: Oracle Corporation
Message-ID: <yq1wm4xb1wg.fsf@ca-mkp.ca.oracle.com>
References: <aM09bpl1xj9KZSZl@kspp>
Date: Tue, 14 Oct 2025 17:38:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0023.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5755:EE_
X-MS-Office365-Filtering-Correlation-Id: e0b31aee-70aa-41cb-870a-08de0b69f420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fj3oC8hJDckktO5s+/1+5SEn/fDfuPUaWgAn+LRm+xfFet9Nf46tICbO4FHN?=
 =?us-ascii?Q?B7U8AQU65fnoQFesY17t1ghhl8bPOw0/qp7tJDQnPRkM3H2NJoNlTVLiNclZ?=
 =?us-ascii?Q?buTRThJkU3fZnNmxtRP+uh9BqoOnxS/NOk2My/oZIGyUeaEMOMaTWXLpDQcV?=
 =?us-ascii?Q?fgS2lV4PzNsHv8FZkXFtRrK72lygwKGgT5FgqG724QkgfRH25SeiPMa1f3WL?=
 =?us-ascii?Q?jfy+waZ1uRNq7thPi873wGw4itTFgj51rHOQaQEdK9BHMQu9Sc4p0y//oAY7?=
 =?us-ascii?Q?wgodZH/opowU9M44SITdEDrJryamOhFn6xaDOiRj3RguVViWagzJAPrw3pzW?=
 =?us-ascii?Q?paey4xlsxRP97f91sFQbC3O2hdv2rtoS+LgbfiH9UQP7yN+s8SMLhsm6If+3?=
 =?us-ascii?Q?6OHELqpTNTzdCciN8o+8dorslRMFGn5KhO425R2Lpl3qHJPcfX61Ttd/KGFM?=
 =?us-ascii?Q?SpZOV3zyDTuLT9N/5JdkIRN4tLwaACSdB4g8z9GE+urTexc2brWdfiIaRhOG?=
 =?us-ascii?Q?igG9I0kiREGXIxsge0Hoj/r88kSIsqnarQ9RcKCCULFze1gAnnt3B/7qcNJQ?=
 =?us-ascii?Q?6JStIxRLVN/B8lW+03h2PjF5wMaXfwqChVntyYirUViZNfDoKYNMXKL/8F5e?=
 =?us-ascii?Q?4v62Lnr9Rtkemt9Hj3ev00bcSuRI69BIzEzq7hHwLgjXld2d1AvLfFJpkQ4V?=
 =?us-ascii?Q?yROBafOtkLWT6V6+gx1Klt6Yizt99+P6sa1X7I7RYgM6cftk/7ZuHPPceR8j?=
 =?us-ascii?Q?jh2QyGA0wkOL+fHSTgeaZh2+wiPkhktQac2trOsqEN923Mw0Y8iu1n4MTj/W?=
 =?us-ascii?Q?ZU8nHbh14FzNbBkaVJ/a7fRc2RLC1zeFZlFyah7lv/wLjD1mOD6yMyJak0KL?=
 =?us-ascii?Q?ouvwjSGbLDopxLiWWcNUDoNzkC9axf5jLSdfWNfmvZL8abDHN16H7i/94czk?=
 =?us-ascii?Q?hDUW0h3hz5+0a+f7WDQQ0hROwm+169+cpP7MOpW+w+HdWCAMWS1NeVfRIU6U?=
 =?us-ascii?Q?RXvNbVcRCgWJPoSAXOHskRpsysIOa2wN/nO9kS64Ul8sZLeXwj3EG4ysDtqh?=
 =?us-ascii?Q?egDdF5YR05Q191bO1AabP1vEtSz2eZa/4TB+3PBErsqWLTVT+ySFIv95EdIo?=
 =?us-ascii?Q?PzX4fQrJzbaPstvBY3o2Gf6TwQOoiA2Lftri0lAG1Hz74v4eLAe1PEYbatrR?=
 =?us-ascii?Q?6jBrB9Qicvx03tOe64v0IPudBdpPmN+KvxQ0PUWq9T+HF/RVjmKVOdMvFUX+?=
 =?us-ascii?Q?J5XsHTc2clQpgcU4T0xdQPfe0fSDdIUqmplHALg/GL7YshOmvT1PqJtpObor?=
 =?us-ascii?Q?4koV6j8y7J1pm3r6rnZW0i9g/MienRoFx4spq+GKgUzo5bZ9jhTZbIVgWvv8?=
 =?us-ascii?Q?CWCCw18e8BDWKdrlQvXgbs58oj7mRJoLLh35F1ooS/Ih42Zm3Bh3ZEDmg6zj?=
 =?us-ascii?Q?qdUMrUpG52qqVSTaabKxB93dWR8uUwQx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+ScjNEezx4OPMbbCC9WdxHwK+33+dVGTumQBy5wo7zLTfqwHtxunlryKs2X6?=
 =?us-ascii?Q?sbOkT22DlgqRy7O7mgBaXcC43Ll6QHz1tRdnoP1X6is9EGmsS+ipZdgsXFnD?=
 =?us-ascii?Q?0hMNn3nAVdAB6+k3kfxG1j5TodRvnrXD4Rc/BRa/H6HuQJrE2arJYyBC+y0Q?=
 =?us-ascii?Q?YTQELb6Zifa41QkQGuFThThsYVTwaDgnflH9hMC7DwNxpluHWxBjOuEdXxM9?=
 =?us-ascii?Q?SYAEYDvvEX8gSTQyYK6oIsOj1qz5LfcFdtzo14D7h8EaJ/CHhXmYErf/tx3x?=
 =?us-ascii?Q?FgV+L/a8ygpRhFOixpf1RAAuiwMqiqA/A06q1fnFRIvA9AYyFLQPnDp+akvW?=
 =?us-ascii?Q?NZulUzhWSEU5dsmrOLqpodGrkoglLJJV6iiHkyiyHtjo8rArfXSDZIFayU55?=
 =?us-ascii?Q?YCMz3B32yJN1vRrVJel4SpK5YHhwAaBh8JrwQ63P9zoRZSo4W/YVxT2YVs6k?=
 =?us-ascii?Q?ebGA8MzYu+rFbedU1QnltcbpI/3ugJ2qfXH4q94gUpxlRb/F2IlWr7TgA0V4?=
 =?us-ascii?Q?uOYuIHwQFe84URp2cqEeyIlgd5/3OWwAqZzbGlHC/K0vaqZAOYpHjtczkRdr?=
 =?us-ascii?Q?bmCyw3bmgvFNQA3+MHYYchBJeBCCR8ucWQw4g+Uh9YdwLeNrhKU0QI/kwID7?=
 =?us-ascii?Q?rTtzLzjGhU2hb7JhEHZMVSBaSfy6DLmI8SKssSyLuXl/BWhEPWCL3laI19z6?=
 =?us-ascii?Q?17o34DsQM2yHdWCPsIR/wuD+XLzl0UaD6fWw8DuEBeqhcptXH2c3/2F4bJtM?=
 =?us-ascii?Q?Cdt8PMsyMNElsWRbShYZI50CLWYCi7e41bzgmXl9MEe6XEo5mU9QwfSje3Sz?=
 =?us-ascii?Q?0fOXDXA4ub9cs2YxUKgEGcpkfpLkg8hgvlsl+3WXVSqOMK/YDbesrgkYnO1N?=
 =?us-ascii?Q?FDj2nzJnk23+AKoJfiO8xFqNDj5FShd1ndrX/pM4KJCxSLvNv2R4FG9cHG/7?=
 =?us-ascii?Q?m+jiiOIOo1JHuDkexA28KBHNogLPpgAN9AVvAEQ5dgpS5gx6IWJepqPP1HUk?=
 =?us-ascii?Q?jSJqt/w4O+fAmgXsZISlL/FqsL56bj8afXhy553dnlz+OEbHyeVENE9Iq9SU?=
 =?us-ascii?Q?MJ8avsgOyLbyssla7v4oxFQL8OzLX/kU36HlkSPcH2Jb3LLM66CMCMwrWpOa?=
 =?us-ascii?Q?XTsuaIfKvyrgCtMcy8WiP9QK1i7pudfpF1ecGrrQ7k7PTj/Lw0n64805fEuw?=
 =?us-ascii?Q?KcexWvyyR5J2fccr2N82LEAplN7fXxOe07yPUmqzDsr+7TbqxKAIRyL5WWMU?=
 =?us-ascii?Q?FH/EWpYeMy39jTdwGuzchv2l5k4DEA4qZVRTjshr6WgaNwndC9y0ERc5X6y1?=
 =?us-ascii?Q?YfoThAFVaorF7bh5rs3d6hWE+u+rLFIx8ZwSWPP9qHplHGUnef5jHmA8O5+6?=
 =?us-ascii?Q?7DDxkvph2OQmAK/HIXx5MfV7GqEG3Ld/lte95hOujZX4YqfDIPYVXsUkwaJn?=
 =?us-ascii?Q?jTn5SiLDmxPBP2Fd91nT+UGtZLhBub34cawT7jpU73Uje1NXN3G9PvilL3Zq?=
 =?us-ascii?Q?N0GmqtvzmVdR/qnmnHsyHaKdAV2qSBmdTAIwhC4EEJ68xF/HaOOMMmediwMV?=
 =?us-ascii?Q?pvlHeQbHW9sgCteffxa7ds6LkYxqwumhoTfT8vltd+RmlC9Bi0gnGfixJ8dN?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HdI29muMLsHNl/T3wneU/za0Zv2922hrzwZpsJSwmrzJ6RUOTix43akkUixaM4o4vb7Y4W0/9+3MZFWNsqfaNU7AXYHWniGsqEp50JCV9JTxb+GTBsSHLwpHle7f001GNrHNwb5abSTkkYXcc5rP2zWpLpUTpf9Rg4B5CJqeVDxIUsMPTUxHxW8ufRJpwip4kKgpKOGWFq+yshbi9rXFIfByE618ANLoxpMh8uKcFLEERd2BRaFCzUSJVENmX1xgi7mRYFm1TDTROeX+MexkcSio/DZNm1rCbsrEQJVx0digV9ApVION5B70eBT4k3P/RZIy7utkjO11vgV+ELqQQauKQO8Bgc6R8eQAk18E8OgVameC1vbmCSVOaJ8sDbzsAhAPuE7b9ItRhiC2a7IDcmnWYaY8iT24ESK/ZnCbIPDmekVbqM1ewSZLwBmy0Oc1Qfvl/Zk89aa3mIGCZjW+e5Q+sMxcxrK/xwKgSXkon6FwXBnFfwJj7sZtqpsnzoYl/AEDSCQKEPAnNzPKLqOTB0O0hMhlgD+FHN+QoeFMFYKOv0F4Snv2T2bh6hzB4NgQn424doqls45ni8maPYIAS3A+g1o9mNg3mjipAP+xQr4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0b31aee-70aa-41cb-870a-08de0b69f420
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 21:38:02.9691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQm4NnS0Yo0CzcreFVPtkUUtXjJ/UQt+2Uc8T5nZC0VJ5xQx718FMRC9sX4P7g8ofNkklokCUkghI+41KG8ToZW/kKsa0HwBL3wAqmgn0Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5755
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=782
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140146
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX4vreH8W84Ery
 5m2diIM3jL98by0WfM4I9YH14HT40qAJ6YZUnSfySxiua1y8gx/yRlmT9wAIt0LkIZ4P494AoNN
 K1FEYK7DT0jn+HO6hE2bKCy+HexdFJglN6zYyVFGFbM6ts3QbPNh+FT//8mrmH3e0TI4JGRnpPd
 qL/8ZGmWF+5ogH9bPTwXnI3V+mCie8fwulVAnf4POZTPjDSNhsCbFsjFeAmYKThWbwWTV6brQah
 Byv0hbWxsPPYgvYd+zVKsFPSgSjsBiqU7JI+ZTJXhx/ku9d8Q5YIBwmJGrLMGYHC9kf8ELKLuCn
 sBAn8yaLtsZ9sl+b4O+qFpdBs+0BjHvInYvABdrcr6A75aSdXz8y0fQ/kgFMPMlbn3VSDFT1fnJ
 5LXVZvib4CfPrQgsTGX2HK6wJBVclaSFvnELORt/UPXu8kri+vs=
X-Proofpoint-GUID: 0jQ68vOiNAYMjpvScHB9QMQ8xQSIc3Fq
X-Proofpoint-ORIG-GUID: 0jQ68vOiNAYMjpvScHB9QMQ8xQSIc3Fq
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68eec2be b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=f_l1T3mUF-Plsrszu-MA:9 cc=ntf
 awl=host:12091


Gustavo,

> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
>
> Move the conflicting declaration (which happens to be in a union, so
> we're moving the entire union) to the end of the corresponding
> structure. Notice that `struct ssp_response_iu` is a flexible
> structure, this is a structure that contains a flexible-array member.
>
> With these changes fix the following warning:
>
> drivers/scsi/isci/task.h:92:11: warning: structure containing a
> flexible array member is not at the end of another structure
> [-Wflex-array-member-not-at-end]

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
