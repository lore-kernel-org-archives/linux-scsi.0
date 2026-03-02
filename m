Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805314014BB;
	Mon,  2 Mar 2026 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464352; cv=fail; b=cl0ZgceVF/5RqyXUjjh9wYkM974UGCTpwhnVU15GvYXZpaVO7EKV33XFeLM7rZfX4DSANhrLUSj8L0P/vEBTuPi493KxI1i4e6jhmY4vwhpRW5Vi4atqk2O95yR5HYRCzwrUzsq2ZVT75wFcrF3KNYQ4yuBVkiCQMGUrXYHjRSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464352; c=relaxed/simple;
	bh=oM9iCKvWC3mVVoAtGWCMtNERAjYXybTD1Vd9/Hcf3NY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ldNgvdQ5EQ6lZjN4ziC4buJ6KxfdGeC7n+1Etv0ffx1EilFECWXhyIK6jAgtRn71uZaC7VGL93spUpMSygXwrfGVu3pUjL1eazhDIvYep69MpKUYE6zdAmzB7cNz9lV/p/GeXu64mgcfV6YfY3rOw3GHez+Qj4t0praxrxtzVx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c5jB8pBo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BB9bfJaM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c5jB8pBo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BB9bfJaM"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622ENpZd1915617;
	Mon, 2 Mar 2026 15:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QV9M0XoROZFaqkiCxgGeigYuCwuZf+pCI7cqvq4g1FY=; b=
	c5jB8pBoF3loQxV/nvQaj5IOBBlBOvI2XamzESjNtrvfCjy7BG6y0dDN4eI30n4W
	/Xk/B8OdUCx+Q1z2EpLP5Xd9njWgGGlhc0sqGeNrZ8uuUX00Xw+REo7PnTz/v1fr
	K6GruCf8CT4tSzLZShUfG0j2FFpF7/QJWkqttC4DweZJCthk0OKR7/oWdzUuDGTI
	P/dcDJaIuEbksE1dkf20gDmtCq9nYLBkVerjWou2ag4n76MwWyk/lzzYlv2JNQ6R
	fPwmUcHFk2S74gosfaPLN6fpXYVGXUN3A6MYhTe4K2NJiXgXyvIY8sfMpkM3ZreU
	xX5JQBEyT95KFwwmDb0dqA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnb9w076s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:12:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622E0r9I029882;
	Mon, 2 Mar 2026 15:12:10 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013026.outbound.protection.outlook.com [40.93.201.26])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt92n8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:12:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A7ukMpv4QsbpKwrq3M7+arZoOj8cWl66v7bL26FJvuRZDWVa+g9oX8xk2I2qFSP23IKabkQFffnl5zeqRFlctf9jN4y2PoCH9op4TTMcK1h0Ekn7Xd1YHNr/iGkLnlxwcSptjus7fmREL7RgebzS9pD95713VuhIO+QRB6BcMO9JQn/3WgJ4iSap9ZnADGmOCe/qI0XE4xG+nDM+ATaYGMojr0X7s0laMflObLiKnYwIEtYjpAmbW1VygM3KTaNFpwUvkLsiLv/z+mQLn3fkr8EVE3sk8sTTKeE4wFMNP5zCUNuBFzzWX7YQq+pKvrXJzDczymFw+dPalXGlmdAdWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QV9M0XoROZFaqkiCxgGeigYuCwuZf+pCI7cqvq4g1FY=;
 b=es/nZnthre1TADS8UrWoZ8TrvdVENXywK0yWzx6P3TrD8E5YdsFSAaZ356a6IJfxW4vJsVWuZGCqXqYQ/WD04x62z1OKabZKJs39tfUJajMimE6nJ5k1kmJSHwczFBeqJ1JSU7Wbb9lfgOxGyfLw1Is+EIi2P1FFdQqjYghQFIg0zJWjRYzA70dqWnugvR5EbO21cn3hw/VqIJynZuJsEBE73rtkjhHn+U5WJM58RKp2asal3yz1cnj/VueiOAt/sTSFYWoSkntubcnG/9+nxRhv/CL4RnwOCDzxFTxG8fMtznTvWD/sY4+i3IMFBuegepA/hb/Tlh1bORbM+dCdlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QV9M0XoROZFaqkiCxgGeigYuCwuZf+pCI7cqvq4g1FY=;
 b=BB9bfJaMXeeqf0iL4VWMi39oiCEZkejbI4KCcgwKg0VDwVoUPeAmdEYQJ0YMJopOz8+bheQIsazH4C2sFeiMmVxMpt8YHe6sQicEKG47L9XcRh+c1VFH5/8CGLnfAnwJaon+5CV8gJSz9En8xD5VEF5pCE1MpXxzpwUOq5tPbu0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4529.namprd10.prod.outlook.com
 (2603:10b6:303:96::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 15:12:04 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 15:12:04 +0000
Message-ID: <f9fb6d73-9b90-4c11-ae1f-3f2e76773d7f@oracle.com>
Date: Mon, 2 Mar 2026 15:11:59 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
 <775dd360-ea41-4e27-9690-e0633e0522d7@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <775dd360-ea41-4e27-9690-e0633e0522d7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f2::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7766db-7052-4f0c-63dd-08de786e0ffe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	DLulzyerpYLzfflQo3T1TjlqC6HTjcm1X1yI1tR1MDAdii3z8pxi3IL0fkQ0oaFAYUEkCjwgP0wlQXwwIlc11Z3OUW1G2h1qPO4sfYAQd6B15nHGXElwD9PV06suSFu3ousLDRJImrw7oqXcmmPGGwguqqBi9eGqtvB2lKc3VGUkhmqSQBsjko200Tlpofg58d/xxXwviqMrjjySXdBtRDSOJo671HR4aqHmeDljkekWxVyAzsXrYtlWmez1pCUL5nL3ELHyqz6iXkB5s/L2Fw+Z/Ienek1fpIGvuznY5mJXRE7woFz6cgGTm5+kbSt9dNC3om6Sn7JjuIIVP8Sq6nLibTeOkO9QnEsqsZ8wmFMi7BZsx0qQALJsz6EPBexJVQGescc0KCBWROV/k4u0b58Z19CxAEU87aUnB/ou5V25Gu2/keRkoMd423kfctDN/xEeelBE3ovkw+U0TYrrnYYjTyjgEvJhw6r29Sg40ikUPd7QdRt3yvo+Je59pvf3H4TwBDE+PWhFBqU+gh5Yusz0RH++bZOg3eoK8ynnxjg1rIs7oX1KPjuZg1D77aVMnJdo3kssFo5zDv0h+esZiWRa6LJoLjrNF+CfZqbY+ia4oembNr3+NlZXWQjlaTUAgHYNwANp6/+a6XP5tGe2gR/HSPZoATCAAUcu5jzAwiQIx+pTzRh7nafwfuCBZYFLTG40iMym7i+HcxKMXqIwM44je/hhBy3+b5brkmhBDGY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkUvYXJWVUFUV1Z0UStTeTJSeUhVbFdmUGlUNGhCT005czZLVGozVVJHeDhI?=
 =?utf-8?B?b24waTh5N3RtbWpIMHhmWWFVNjg4YVhFVFBIL3hTbHd6Ym80OVREVFBwanlV?=
 =?utf-8?B?NndPNjNIem5zUTJXcHB6Q3lOVEd0bWZvUExVK1JITFR5QlZCVHBmOHRrUWxW?=
 =?utf-8?B?cTZtWUtzaUhXbHkwdXNJWWUzMjhJM0FOU1RSY3NJKzB5REI3THpGenl1ZkRJ?=
 =?utf-8?B?VnEweEp0SWE2SGQvNTZIWjV5QjdQTkR1QmkyNFp2Zzl2UCtoVnRCQmQ2TGZj?=
 =?utf-8?B?eWcwK0YzOGV0OEtPQk1hZTYwb01SSmFMM1QzV3U3ZmIzTmFoZmx0d1VDdFdQ?=
 =?utf-8?B?d2VuaTZ5cXVjZjhiQUhlSXlMYlkzUTJFT1h2bUVGQWprelZ1emROSW1RdXdO?=
 =?utf-8?B?WjBTVWpiQ3pKeURxaDRJSGZGcCswZGZtclVScUN5NzhwU0hnR3FqQkorQXBq?=
 =?utf-8?B?NTU4bGFmUFN4OTU4NTI5K2YrTExFMko3SGR3cTlodEcvaUdMbE5TeUFTQzEw?=
 =?utf-8?B?N21uODB0RlZIc21sV2tXQ3o0MVhuTWN3bDVuNWZXbHQ5R1FmbUNYeUlyZ0lz?=
 =?utf-8?B?WkU4NHp0cU1LZW1nV3djL01LMis4OGlETkx3TXliaU41TzlIYVFHNmx6Sk1r?=
 =?utf-8?B?dnRNWi84bWV4QjBjc0dSaGk5ZUhCOGU0ek9YQ0phY3E3b25RRmsrRWZwWWow?=
 =?utf-8?B?d00zWWtzaFRyWS9JRVIyOFdMdmhMV0hBVVlWQ2JHSFQvaURTYnRTY0pUOS9u?=
 =?utf-8?B?RDNpWVhxYU1sRmJleTdCd000VlZTaVV4R3JhWk9PQkhyK1hSY2cyOUJtczhW?=
 =?utf-8?B?OE4wTEplRFUyVWRiaVlYUy9KbEI3b3crVHJEWGhBaVdYcEVaVHk0UHh1V3hn?=
 =?utf-8?B?MnJ5UFoxdnl3UVk0SklEOTJtaWN1cktPaXhGYVF4YUlmbXNWcGpCUGlKM2pB?=
 =?utf-8?B?Nzg0RSsxdGtZMFVCWmNkNkE3SnpWMThickVSNlgzUXF3TmQyY2YxYnRpMml2?=
 =?utf-8?B?aWVEd21BV1o3LzZNa1lUdjhlUVZSSlV6RnBac1pxTDF4ZkpiTTFUQmkxVzUw?=
 =?utf-8?B?TktZcDljay9YakdDQittYW1BWlZSd0k2U2h2MVdSK3R2SmlwVkdtRUhVRGFW?=
 =?utf-8?B?T3VhZjgwczMySUNjc1NHZE9udnlIaDJzT1loQWlIZ0tMMmZlWFp2MSs0RkUy?=
 =?utf-8?B?bUJZdTBYajZydTFmd2dnVDRDTnhsMGcvL2pMOE5ZTi9Vc1NoNTdZQTh5Wlcw?=
 =?utf-8?B?K1l2cWFDSUMySGJyRW13dmlvMm00eEhFNmdwbWd1WDltR05UWWVscitCcU1r?=
 =?utf-8?B?azJoZ3N3Z2VaSFNrL0FLVFlkR3pqVUFUSmhLM0o4eHZBV3lvemo5amY3TjZ0?=
 =?utf-8?B?dTJwS21TaWJUT1RLdXZLYk5mMHdDN2NES013OHBvU3NsQ09pL1lBbEFmdU40?=
 =?utf-8?B?V2d0SUZaUWVIZ0VEMksxMHNxaWRpT2tJaGdZNm9PZXUxQUpuaVVHbll4cXdZ?=
 =?utf-8?B?d3pjZ09UZzFOaUdIRzAwTTNIQkpPOThWblcvTVBoRkVxcG1FZ0hzSE5FckhN?=
 =?utf-8?B?VUZOZ05zZFB6RFJhcDFMUHowcFEvWVRSWmFENWlBbHIwditUdjljRVpUQjhU?=
 =?utf-8?B?TjhNaG1Nd3hzU0NpSVV2Y1JxNXVIa3FpQ2JKSGNqMW5GWjhMS2pIRThZa2dF?=
 =?utf-8?B?SnFlZDVqOTVZQ0RHZFBsRlVZMStZZWxZa0M2eS96cnRSSFU1Y0ptbVFVelpX?=
 =?utf-8?B?ZG1nYlFLdlhMYVc5MkhVRFhTNFByWGVxUTdMV1ZiOGoweDM1UnRMNEtrcGUv?=
 =?utf-8?B?aFRrdkYzRExMZkkvUnd0R05wS0dHV1JuUUxLclczc0F2WFVLSlFBZEhCNXAy?=
 =?utf-8?B?NTJkdlhXSnFjYXRqM2RJVWlrS3ZKbHVJQWF0K0dtZkhIeXpaVlQ4bkxtaUFV?=
 =?utf-8?B?cEl0dXBOMkpVSVoxWDhhUjRSTmIvbnZnUU5uMGRNMXg0UFROaXVWQ01xT3hP?=
 =?utf-8?B?YWF4OFZUaStEby9qeXloa0psYTQwRWtXYnk0Vy9Od1EyTVNkN2d4WmxBZTJT?=
 =?utf-8?B?eHNtV3pEejVWNGVZcDYwTmIvM1MyWDFqUHVWQzNsMFpRMzg1QjlDRkVTZG9I?=
 =?utf-8?B?SHA4OCtBWm1zRFZKaEdGKy9HU1I2bkZWZDE4TiszSURjTTN5K09ULzZJdW1K?=
 =?utf-8?B?RkUxWGt1ZllsYU9xUExZMlczSHBSVHovVWI1ZGpIZVFlWlV2cGdVMnVJL2l2?=
 =?utf-8?B?TDJXdkFvWmdhYWpZRCsvMlB1cGNsY1VSbnFwMHp4enY0N0Z6aFpaZ1l0RVZt?=
 =?utf-8?B?aC9CQ1dyU0hYZVNwY2tDNVZCR0psZFZLbERMN3ZnVlVMK2o2YnI4YklRdFhB?=
 =?utf-8?Q?wEMSkVni1/6Am9/k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OsQ2JVvdTgTpCzQjtX4c7JjySbQ4uHh1zjA/qMBOUAT7/qVYAv2BufXtwpXe0S4HYk4Lb+i2ZRCTGGxNz79en05wqQDpEdy7oUpeAMwT/2RoHqPR0x3HUl3/hEjTpwLxt1bOXnZ5/JjOBvkYOVEX/55eBS7p4cYs04GKHlnKs8bmGcZyvIDrKdY2s7WgkwjYJogmDnZx+1PbkxAEfrry0m3YDhYig9jaqPsHKlbNNS3nggAcTDV/TaJ4K8LIcUz2RTeVOLVWdOvHc1hXZtP3lala/7mAp1zBy9oQR4IxFFXXSInJ5gaVWgutQ2krrJ+9A3/8JGWSDs0iBLTt0/34/Kejl4k5Eu5Y8T5+UsK2o7Nor3ubshwx7v2Xj0Hg32z0wPGQAmyp7zJ4rZ691CvSQS1Lzlkd2/c1s/V3TtVXZ9VcT/CrgNeSh8llHoNqMwkM3710Jn8TrrM8F0MIlWJlGAayUL8LMloQdlLCPd9mPugCmUKWIlI/i0wburlNiY2wO+Y7TnKxQsyo+mAUh1zAsk1pCc5+Jeo1nR8z9H614DiRCMz0M3q4jIh63/UbJBhZYPPV+/DrbOX+a6NDf169N5EA3d/qq6UgWL2Q/o/s/gE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7766db-7052-4f0c-63dd-08de786e0ffe
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:12:04.4997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtRiJ3UO254j407std+ZgfL5RKY/Wnw5NDwre91nQK0PIcDgiWDyd+5xFQj3sX+3ftK7fARx2P1UFmR37EA9Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4529
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020127
X-Authority-Analysis: v=2.4 cv=GesaXAXL c=1 sm=1 tr=0 ts=69a5a8cb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=7XenLk5A2h033CMWEDYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: tRyTjbPHi14zVzvAroAEEMF78MD52Wko
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEyNyBTYWx0ZWRfX5vyx8x3UZ3Fu
 V/actOdpFSQyThjbLblBWZKyDyiPpalpDo4tusKfEjVLzLMI6rK1tZ5FHcqoFepF+Wl3RZkm+bU
 /z4R7uj9Y+oEI3+KOgpo0/QILdDLrleCgSk00ljNJDAzBoRS8mbDx0HazJWEUm9n16fQiscV8hP
 jw2a7QeyFIOZtI4+EytzlKDEzRraSOJadQ8VaQ3JxrtmNWw+1eQVo6w+mbg/NrFmOaY90xjyqIV
 y3bEbo+5z8szzR03zJVKlDUb4uCKnT8nsZ9T4Ys/1dRGvZDrMrBJNymCr3zifpgC40eu8ABmrzV
 5VRN38WiZe3QciUgiDxCU3X1hIicgY4hNKYDwnJnBMpXFzu/4epru9WONhGwS4XTGpPW+j83aqs
 G7TiBI+cS10NlXNb1M4rB2VBUhBzy92RkFGqjojm//SkSfVnhLNSq37GnO64EDQiV0Kjms5BDJk
 /yl5dp1xYYMUWUqzqZA==
X-Proofpoint-GUID: tRyTjbPHi14zVzvAroAEEMF78MD52Wko

On 02/03/2026 12:36, Nilay Shroff wrote:
> On 2/25/26 9:02 PM, John Garry wrote:
>> Add code for path selection.
>>
>> NVMe ANA is abstracted into enum mpath_access_state. The motivation 
>> here is
>> so that SCSI ALUA can be used. Callbacks .is_disabled, .is_optimized,
>> .get_access_state are added to get the path access state.
>>
>> Path selection modes round-robin, NUMA, and queue-depth are added, same
>> as NVMe supports.
>>
>> NVMe has almost like-for-like equivalents here:
>> - __mpath_find_path() -> __nvme_find_path()
>> - mpath_find_path() -> nvme_find_path()
>>
>> and similar for all introduced callee functions.
>>
>> Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
>> setting default iopolicy.
>>
>> A separate mpath_iopolicy structure is introduced. There is no iopolicy
>> member included in the mpath_head structure as it may not suit NVMe, 
>> where
>> iopolicy is per-subsystem and not per namespace.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   include/linux/multipath.h |  36 ++++++
>>   lib/multipath.c           | 251 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 287 insertions(+)
>>
>> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
>> index be9dd9fb83345..c964a1aba9c42 100644
>> --- a/include/linux/multipath.h
>> +++ b/include/linux/multipath.h
>> @@ -7,6 +7,22 @@
>>   extern const struct block_device_operations mpath_ops;
>> +enum mpath_iopolicy_e {
>> +    MPATH_IOPOLICY_NUMA,
>> +    MPATH_IOPOLICY_RR,
>> +    MPATH_IOPOLICY_QD,
>> +};
>> +
>> +struct mpath_iopolicy {
>> +    enum mpath_iopolicy_e    iopolicy;
>> +};
>> +
>> +enum mpath_access_state {
>> +    MPATH_STATE_OPTIMIZED,
>> +    MPATH_STATE_ACTIVE,
>> +    MPATH_STATE_INVALID    = 0xFF
>> +};
> Hmm so here we don't have MPATH_STATE_NONOPTIMIZED.
> We are morphing NVME_ANA_NONOPTIMIZED as MPATH_STATE_ACTIVE.

Yes, well it is treated the same (as NVME_ANA_NONOPTIMIZED) for path 
selection.

> Is it because SCSI doesn't have (NONOPTIMIZED) state?

It does have an active (and optimal) state, but I think that keeping 
NVMe terminology may be better for now.

> 
>> +
>>   struct mpath_disk {
>>       struct gendisk        *disk;
>>       struct kref        ref;
>> @@ -18,10 +34,16 @@ struct mpath_disk {
>>   struct mpath_device {
>>       struct list_head    siblings;
>> +    atomic_t        nr_active;
>>       struct gendisk        *disk;
>> +    int            numa_node;
>>   };
> I haven't seen any API which help set nr_active or numa_node.

I missed setting numa_node for NVMe. About nr_active, that is set/read 
by the NVMe code, like nvme_mpath_start_request(). I did try to abstract 
that function into a common helper, but it just becomes a mess.

> Do we need to have those under struct mpath_head_template ?

I think that the drivers can handle these directly.

Thanks
