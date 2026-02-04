Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E5749659;
	Wed,  4 Feb 2026 03:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770174225; cv=fail; b=HE9/H5OMZNkOwr9XjomkuQbpWR8jO7LLSQzMXS7mrY4yvndLGNPL+kKwdEMtpIsbeicNnuE56QI0KSXZPbTiB6ANu/rHKIvb2r7pZYvzz9T2wfB44OObBA/qXR+vBU3aPsQRV3V4yNmuP7D+QzB7wlQRuL/s9GJm+1OygA87kvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770174225; c=relaxed/simple;
	bh=e++Yh4qT8nDmmY1ZFPESf+MjmTFLbSH2JFlveNwT55Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=W2/BSI7/Pj6hsBVW1kCcPXtLMQb9xL5xpP6Eb5y7P1zCD4p7UEVruS7O23+fQAEH8++oKLgZYqVCKjhpx+XhnDVwI1ERi/CzQdMuD5VPW2I2KL6Dz8+AvFOG3ohVV3FMhex+LimgfglCtIpsqPxU/PZ14WovjE0+7hTeC8nlIHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DiGNjjTL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LHPbOodG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DiGNjjTL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LHPbOodG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuDNs4087834;
	Wed, 4 Feb 2026 03:03:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VCXsAg4xpNTjGBFd7r
	Dcz9k2G7u40pAkD/xHgIDHgVk=; b=DiGNjjTLcMTehAuPbvW5m2U9XaAUdUcW3I
	b6F70zYyXXmqlLLwyzmpkdE6jxep3Qtbvv/CKlGq73aeuD8jwGAFUhorAvIKXx7U
	lyEFftOz6Tl9o3Kt07W5jE7AkXa4Qo5UJJT4/gJC+k2yoSnGCb03121fdXVz5ejy
	Wx3Y76RW9uG+bJohNOg+tYwu4rkdOIUHw8juAHoUgeUYWTEduTQvJH0cX/P7M+N3
	oxZdg1q99S/91AjVPZ7WA/pWF3QQEebCJchL5+byiOPPuIcmUB2R6PizPQtX2sFT
	Tr1JdLRkupvcKqY4hFfrZEZOJV2slQtYaT+aOYkBwVC6RcmpkVbw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb142s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:03:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61412ACw025765;
	Wed, 4 Feb 2026 03:03:24 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010070.outbound.protection.outlook.com [52.101.46.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c2579e8yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:03:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nVhzawcso7hm6O8Qw29vN8ik7E+ij1eTBTPC5u1i7ZUA/NrNpzLPO5CC5mcaQNAqBZBaVKjXqp5BullVi9BL2x7/tgJbZbJb6NM5XxGal7BhPM/mWgCUplzwj5KM/gGSHRPt/A8merZv18ZzBjnXGRHQyM5Nl7ApoWAcuxiCWQtHS5vZ947zNWuQE9+9YIIczUu+iyfsHQ3MaoLwGbAzjrI90sSwVuSpNFOTVx5/kYFK4PeX+Sf0pVTpuUMUCkg3Q60z4VaHNbndg0FE0MDNNUVr9QwBP0CW4gEqrVSgOO3IWbU/t8LFR5X1kdbKbAzWedG17AYyNSMt/4YdbJCNNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCXsAg4xpNTjGBFd7rDcz9k2G7u40pAkD/xHgIDHgVk=;
 b=hfNWvaYiMZThPfldeTMXwHbalPYS4V/rHT9JdZhyQV7W39RIcvoG7nbG3wxZH9p/vubBUrJWe1bbSwZFV/0oKYBjrmykAosAnH6I4px6SZ2kiwbwBNAapuAKWrCgWam4YLcLtdQ4MoqumNa3nqOsKA7n58kownitS+4ciRLamMMjTHtmvN3h965OFm1mMgCuF36UtxwCfd0aZT2Oo0+kxt9+f2JDBbhtLqR5qy1+sOm0MOuVgXZPL13WDYU+g1EOKi4Vky67wSMz7ka1Ez9kgKp9iYEXjUy3WYjO+LKSqmuq0KsceCO0lceNg16z6RVbQg7vzFnqBYLUZo5iER3ymQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCXsAg4xpNTjGBFd7rDcz9k2G7u40pAkD/xHgIDHgVk=;
 b=LHPbOodGaC7ScOzZdjB7fLdf2L2doKCb2RcjD69A8CWddkJnUtwg3g3XI7N6slrNUhkHcdQLmpLWfuo5NAPg3PJp4S3D9PurWDWNmcws444UR767VScV7UQMVCCAQnBX3bjMX7pQPaHZJqNrRTteCX6Z1gZdJOhaQ4JjUALMSaU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4937.namprd10.prod.outlook.com (2603:10b6:610:c5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 03:03:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:03:00 +0000
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Thomas
 Gleixner <tglx@kernel.org>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 07/21] scsi: efct: Use IRQF_ONESHOT and default primary
 handler
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260123113708.416727-8-bigeasy@linutronix.de> (Sebastian
	Andrzej Siewior's message of "Fri, 23 Jan 2026 12:36:53 +0100")
Organization: Oracle Corporation
Message-ID: <yq1cy2lp5ww.fsf@ca-mkp.ca.oracle.com>
References: <20260123113708.416727-1-bigeasy@linutronix.de>
	<20260123113708.416727-8-bigeasy@linutronix.de>
Date: Tue, 03 Feb 2026 22:02:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0265.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: b8d27ff1-f71e-4a1a-aaa7-08de6399e797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZWDy5AgKDKaToMBtQFV28z4VbmvOa3u1E5neK1ogkqMWEiZD4L5OjgPqzGaw?=
 =?us-ascii?Q?dhEsiErQ7HHS/RQs6rjmpiI4cJON8EhuSHtUUKB+PPGQ9RUMTtB7JbYkpt8K?=
 =?us-ascii?Q?h1AQGdItX1vtxugGq2CKdEtK9FNWRWRJvwEgIzWDNXhVLcKNLY3lRge+x7en?=
 =?us-ascii?Q?RBaGfNjBU6fB13pCrLuAyEDCf298Z7O92tqUBVExLkPypBZooGYSp/rs1f0I?=
 =?us-ascii?Q?N5jgpts/V6GNRNfCdVh7zRgnUbGLqUJ87Tkn9/9hwDqkhA4yX368TkHojROT?=
 =?us-ascii?Q?SECQzJnl/6NxRL3YnpGfTehQOcHgjj/8K+fYezUXxWL0Dc4sfBjTZbL0hLTD?=
 =?us-ascii?Q?fJzqd6X85nocyoN627mMIH7aAp5VXtrmUJKv6BtrJLLENvUScv9gIee0l9te?=
 =?us-ascii?Q?ttEvpWr5bJxem0OeQ81E/BwxHkGxNR0EDEKu3ts8AFa/a4RNTpsFj5aCQ1ed?=
 =?us-ascii?Q?92r/TkWfmZTDmS4G3o3H8UTQhedsSMhN8JDO7qA+JQNI+bHN76zchxO7MAH3?=
 =?us-ascii?Q?euok9DePCaYrGkJyxmR4fe71tbfYXFf8Wah2bK0OBtQXBHiHxP+nsxQ8LNFg?=
 =?us-ascii?Q?75c0sY7jTb2MIheM7RFDIG2CXPF2MCb8lkt9krmVcF03CeYjvPnhHIFFv7Dh?=
 =?us-ascii?Q?wKVesO7bdiYoWA+kow0s4uRJnxdHM16rQxFUVhv0fePLoPB2J4aF7lRcmq0H?=
 =?us-ascii?Q?3H0fqklI9afhsi8FfQ1gKO8PL7FdM68DdSEpkjgG71pKdAQg1ahJjrBj1NZP?=
 =?us-ascii?Q?HeEdMU26XLVzOsTpkVwji+7QkSqUHPuLZwEksSC7nDMwEfGoi6wez64sdMkg?=
 =?us-ascii?Q?guMJqX/JSUdC0n8FRIXIIxPBxsG18c2/mmYLWwZSrLDCzM1Yq8hhHJkyrnZM?=
 =?us-ascii?Q?SROwdUJRo1lamXFq8bZXmKTMuQ12+9dF9Q/wIhHTz8T+PkkJDzgyLWKW1/39?=
 =?us-ascii?Q?o/TnmNQrRyTdQ2jt2t5bl9Q8oHfZnIFJYHp4zsm5nFvMChNlgsEyuM8EYVGa?=
 =?us-ascii?Q?8srQkaLLNsDxWBuujXkAtqqGQFjQ+O3fpEWoYngRCW/RkpxTbz66nBMPS2Yp?=
 =?us-ascii?Q?rq4oXtpZxFw7de/IZPlv10awZaoCkRJWns8wuyWu/SzF38EbzDsMf9Z5zMb/?=
 =?us-ascii?Q?+jy3q1sEGUbcJLhdXyCPFO5xISgt1pT4XH3TxbUw2Rn0/4cAkh2b7vUihUCy?=
 =?us-ascii?Q?m3jnP9x70qUrKezL2ef386HFao0CKCDnHVkiwJawlV0i4SbQQZJkfJhHrcVY?=
 =?us-ascii?Q?j5c9D/CX9baGNj4TkbR5ZHayDDZ7tnXtsPyizdA6GbZR0lMcsiF4joDke79H?=
 =?us-ascii?Q?4avWAVzS8n05VXR1qM12Y7BgEtoNBIp3exG1krILfOEyYT5/lxVwN4+RyLN3?=
 =?us-ascii?Q?h/xthZR4/TzL7nwwPU5CxpIz+r15sEzpjt08F6TxL9bB1IEdr4+awH7CZMsK?=
 =?us-ascii?Q?BXikckfRKPKmOlgEW//e20rAj7vjxg/LcWrLcLdpytkLDFgKrxNeIl8vQE97?=
 =?us-ascii?Q?/04jdqP+fNOYJNXoKWoO/5Q7QFQnXC8b137UgByIIMc4G+z27dgD9mZcdPL2?=
 =?us-ascii?Q?LENzBTiTchYmhOjdeLE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BKiwpBLEIBx4WVICyEOCViJFUVLKgxVXuhAA/7IbppvW+cMbBwFTjIgOpDh2?=
 =?us-ascii?Q?08qGKiHRLV3+bfx5r9la2XoVnqgm9IY2QxpuDNNvnTpcOYJSKN+I2bCzVlwr?=
 =?us-ascii?Q?kcmJoS82p5wCE7Wo9dh7YJ1Cfy+SZqR4BZ9yp5C9GXlmOrs/C48lFIqnRTJC?=
 =?us-ascii?Q?k8Forii80+1sGNVs1/T2WzyW+oFFuqdOkqyUJwQFLRm9c1NBqtWGNjHqwM0+?=
 =?us-ascii?Q?kIUE8d4CIdqJDDnMLrrCTs+JfyAQiF7s6oWiJ9RZrpl/POBhx/3iDH5j6jQi?=
 =?us-ascii?Q?Bg52BWKjlBWQn1cfXisA4dPf/HX5hjCajyRiZMOhwk9W8+jxD2pImWm/cxRB?=
 =?us-ascii?Q?Whl0WDrgINGsvVBFwQrOpbAGg6ld7YDw+x5PtgduWBp8uc03Sz938idRBBHY?=
 =?us-ascii?Q?mxsXuUEgyMqQvwF3APFtu8T9RrsaV1YVFkiyTGhomnDD5iWOBe45DrnqxKe6?=
 =?us-ascii?Q?IUrkKU4oT4JBkdQhDjFkX1U+biqAaLzf2/2aDodcb1groRIAE2kuk0251WZ1?=
 =?us-ascii?Q?cDolecwCdXVe+wKG4O+1pZSXIOLPTN2VfX5Ox5ZGr8X/HDwC6miNbNw3jr4u?=
 =?us-ascii?Q?iq+hBkMjVlOPwxKr0DkxEr4UomIVECUhcDMKxeufMzlcsq95zYE4DBQqtsEy?=
 =?us-ascii?Q?Dqagk3uYbPeZecoEorifjDob3P3YQhaFQEEUI8hCVRmQP5y7qWaX7W8N9CIn?=
 =?us-ascii?Q?LLAZq6M8+vl5MrTkCHVsxkuobbSY+m44aeMpBphD6ufqt0F02irjg6tpmWXU?=
 =?us-ascii?Q?BezhkHOBGgsqciWG62Y1+m3ZOG79h9tSYwFKLzg66II97M7NAog45J9oBxAE?=
 =?us-ascii?Q?7VCAlfEUUOaFxg0dBp8EtoI4QPXB2ZR35+eAA/YttqKkgNcdnAQnCz4ceILR?=
 =?us-ascii?Q?74nth7os78IfNVZm0Phq4nlRF3bppx7861k5jHPCZ8f+9i9kPbLJoA0NKb3Y?=
 =?us-ascii?Q?Hry2r/fyjHB8CAZBW2abk7z0p3bwHQXhxSqeFh20qp9W7BJM9gjpCO5GNyhJ?=
 =?us-ascii?Q?wvqsGBms+TVgejexiKCZNWQJAKte5jWXD5yf5DFXq2i0izFE7fXZ4c4sr/K2?=
 =?us-ascii?Q?YmL/5vDtVYgD+AJQm2CWQB/lvlxzJqlwUmAMN4v9GF7v+EhokZugPZ3+Qnmq?=
 =?us-ascii?Q?05UlFE6wGlaoJ2zQN7FXIwlojQr7uIMCzq1JOEZ+ssyo/6Bo2UF8wjW9IyLI?=
 =?us-ascii?Q?AatllMDYws9tc9JpJQr6Rn0XkolKvdVcmBBJPlpAY9e/2xjy8ztSvz5n/MaM?=
 =?us-ascii?Q?WQeBtHr9M0wNVNy2k3dMgDo2xX0RUiP37CPRRfSnekISBKz8tfCx6ofI+juh?=
 =?us-ascii?Q?3nacc2IfzHyQtLqeI7VAwb3k15W0pa3Hd2t/o0iOKFejQ5AblfXXBy8bnq2O?=
 =?us-ascii?Q?8AeKLerkAtVfd69MMyEU+VxRF/B0eYa27DbrjZvIY/JnTrt9FMr7g+KH+YJ8?=
 =?us-ascii?Q?ePPk4eZQUIDjY4XIMgq1TPkRME32yCOo9Y5spFgNYCbzkt1+IrlGTpB3RYg1?=
 =?us-ascii?Q?x36RuaMon68BW6A6tno4lNVXoJWptSri2fA3KrT2+obDgMy21fwn+YHeATVg?=
 =?us-ascii?Q?/5eKt0dp3gkB7b54LppPqIXAvDwBmFPvdLUQDfGJ3noDoxB1UbEhCVBOTFl7?=
 =?us-ascii?Q?2L17MaatyUIOxfWAO6ADOeRS4mvbgkIh6n9ui+U5w5B19TN3/33zrbKK7Gzd?=
 =?us-ascii?Q?wb0BfMv77xtDpl0DxpAv42vh5rR8/660SQSiG5ap+3uLgftBjNz0vpc1o9z+?=
 =?us-ascii?Q?fP3F9+vsWRxqJIQCWiUcu95ARqP5AL0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cWAptKyfLu2v2fvcleoDpT2kCesxCR7LcBm/gJoobzDfU2RdtR/fFOg+ahVssq6ndLXu7C7hdk/ac8PKjRimP5En6z50oN+JWeaYQjrPMHqbgu3biGYuNMph/7SshSMLFtPpVad06/hY2PhBxZQYyo6zzF33dylUisddyn1SVh0eKYlyxDaPPCJ6JfVTX6rgg6xuM1uBx97yNccQy9YwvEsCvmczFRdeABt7JqgXaDHPTbGqVV8XpAKvj+8v4rVMdFfBAnEoqroKn8DNjkY6fR5XV8Jqpb+0AJWPxjlCdsRsh/cLso1yWbvs6pNa9UH8MchZUb71RkcADEYVbUO7FqLlgHrXo6f008y+saIaNzCIpkYMzOS9VVNqBrf/uALB+9/aU3PExCg6do6avtpBzLTdUOL4c+sEuZQmYEWTcewk1o3hqaJTFq+T9plTZbjCelrrMkjTISj4GSiPg8soo8z7LpVWFAzR/+eGwIO1rg/eAvBRJKDHHrjTPzVqG72CQ3Jy4h8C7A+6dyP7clch/afk3RB8Hap1xAgqqHcWODlXLi4YhDaHQ7kegtaQa0rSiWim/mTuh4qrFD7iHcfp/Elxy5F6nyd9nKBD8SsZoVc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d27ff1-f71e-4a1a-aaa7-08de6399e797
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:03:00.0981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4a85cqmNf+Yt4KVPWogHvEF9dWoltJOFuZcrdmc83RxjaUMIxUXCv4BU9ElQVAyS8S7EZHeVcbCBWX1Xgdpgh3kO5HzUWJgUk0AnD93/Tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4937
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAxOCBTYWx0ZWRfXwl4oeIbYmpbl
 TI82nWqrKffZ0wLZXt1VtjxRZtY0cQ+NFLVfOjrfew0JiJuklSPlwebZWOjFi9BTZt3+ETXi+pw
 2UgzVZWkSeXj/sodMlS2PeAnwl4bC7MjgnW96jXICrYGN8JEGAJCOUnVd9zpXbpuH4WnR20WzaK
 s/p07E2QpoSmp4yysUksu2TbEaOrjMWxuvtXApbqVqKjW7gXFWLBrfemLLc8PjXNwNowD8uZUaj
 XHeiJXomldTkUhkuq1emF6Lau19/qNLnBnoBAkiLXFHeJ9g3Uy0ItSQoyZyxg2z+y2Q5vNOwokd
 l0nd6QMr3XWfjGHAfUhfuO8RtdC8kmT7cCwM4312B2wR2v+M/Kl8jOKJMkxtFyPLD158ONOLqcY
 Uz7yDqpJdxnyfH82Iwe4HXtw5SJ99FfmPO8Njug4/xM0n/g739nViTgUqQ/sgLs+XHfZROiWV77
 NcP4bbDddAxQI/FgYy8xpfU++wimFOMpNNKPMBAk=
X-Proofpoint-ORIG-GUID: eHVbLGHDW5hYGNsxmq-pWMvUTvqaw40I
X-Proofpoint-GUID: eHVbLGHDW5hYGNsxmq-pWMvUTvqaw40I
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=6982b6fd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9 cc=ntf
 awl=host:13644


Sebastian,

> There is no added value in efct_intr_msix() compared to
> irq_default_primary_handler().
>
> Using a threaded interrupt without a dedicated primary handler mandates
> the IRQF_ONESHOT flag to mask the interrupt source while the threaded
> handler is active. Otherwise the interrupt can fire again before the
> threaded handler had a chance to run.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
