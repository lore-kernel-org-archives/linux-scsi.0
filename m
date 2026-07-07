Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EF6390CA3;
	Tue,  7 Jul 2026 09:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415396; cv=fail; b=UhFIilaHOos6AqaHCtzEJg+5F3M/RCMNmPR1AmPqFyGEjzCTXG6aDB3vglJK8Ag+gB2wHe2pgsKuqteKoYFZrKHRp3PGwu5O6k3hslOqoFzPfqi559QHHKcG7AzUGC7CXLBQAtp48TXoY14Jb7Fzi3/ecemkO/5MV8RbsJDvh3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415396; c=relaxed/simple;
	bh=e1RuqK995J6hTzlHUWsTbAiwfBYGoSCMe+Vi0oLWG0Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kcp4sztG8ZpqkfMkJAQjVrFZvwHBAHdHfM5Z7HhsX4dPAa69hsIsGO4UuHgBiaO7ZmW8Z+t1JiqUlIF5cl7Av2aZhCgy1Ht9yUa/2NpZuj2S6+w6wtcMI36C9wm13zfNIqwUjKXIT9MLLhT/Ya+u+o/YCHEIW/7fRfMvMGO6128=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p5mVJYNC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Rwesevvo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p5mVJYNC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Rwesevvo"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666Jtu7C3165349;
	Tue, 7 Jul 2026 09:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=47oVAnpOUqUHTVTbjTId4VYe8MB/qupwXPmd+MsC/M8=; b=
	p5mVJYNC+vAkMC0SIOnb1AEzJUDxN8blsDRd+05zigHXWJK8uvSBobzh2kTKcONa
	bbBQixzUfj1WBRjIWvZasdjKJH8IlSDkbSk31/3HsgeCyO/UgJB8VbNBMCf65KX8
	nziAtZumkwEDDeBignfxbdv7pbkxVtu7xhK3JKMdhRB2yr6Nv4fHcaBj2UhXMJwa
	SNaPP4XNsA5Zd4xdki2GbtFRsWuy7fZZnOkhA/v1wTrpGXRNeqFeTJFt5fFMHwwS
	Oi8cfygEAvLiEoOqbwnPoq7KoMnqVE9o2j1SzyYwQVzFK5L4j+XflS66AAPsHKYa
	k2YsgikT8xVVcgsUAA1D9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6sssdan2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 09:09:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66798Uvt002409;
	Tue, 7 Jul 2026 09:09:52 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmq82tv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 09:09:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3TlzBH3kHq2MVXQSrr5Z5lOkzTF6xzMhrYoK8uOc1wtR3GbVkcvWTJ29NhG4/TesJjZwPio7gw6YaAYh7WWj1UelP7fzXN5GRqtdznE2M1BHXbgFjW5V1i0YM8ibizPS7C5U5CsOMIrB161/jAHv/yzmFhIAS2DrOdesTXyKvYW7OU8DocOBKvmdWKW5xFrALWHjgZ4qwd9jsQ+xS7rwnEHhZ8t6lWWGHUYcFooxg6O9QhzVKnl/DP4+JkcUOJ9Utr8kgwFNYqwRtb1yqyJHsjOYAR98Iy59ClGRf9JuNfhQQrs7uoiYHBJ0o8vNhbHDY94kDFfSPI2HTHoGrF5Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47oVAnpOUqUHTVTbjTId4VYe8MB/qupwXPmd+MsC/M8=;
 b=Qxk2ml6SaPQ2AczEIH29fo6udy4cs6fCo3g7QCAVEahSf/bo1XbPsK4Smj52TOXzeI8NlA47gI3KsanqXBbtlQ3YZlNtqc11UCDZIcdl29DUYUlvKmoRjX7bad4gOpZlY4oweJkz9RQJKi5PgtCoTRv7lC1fK9ka3yB5iF5kwW7oCUIFSkGQHd6t6iqUYsofRThS6iBLDzVa+cmGOWDfETVRBaVfkFVva/6w+bZRUgqrzuc5MGUDRjMD/fAEzK163/gmMSn5cEcDFOSamMfw6JYUCDYcJnbTqp4JZbQ0InRDtmXp4ancdwMbIN8zB1+0xR1kNArDGd+s/K7esg2thg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47oVAnpOUqUHTVTbjTId4VYe8MB/qupwXPmd+MsC/M8=;
 b=RwesevvoYmX7dGKBRhYLK5Bd2QbDGVrTpgDRNk5n8E7xZ/RCPlm23DoIpLHCDpE+59mSemfTNwz/U7OSMByAATNsF5sDPpcTUdcPxMOdFFBx4m3P4hi5EXIkWPgRbkkgaJvNBqHmkOOPx759bfERia2G+a/kHglRwEZYYphhocc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6625.namprd10.prod.outlook.com (2603:10b6:510:208::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 09:09:48 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 09:09:47 +0000
Message-ID: <149f1b3b-0cbf-4501-8650-eb05014bb8c9@oracle.com>
Date: Tue, 7 Jul 2026 10:09:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/17] scsi: sd: add multipath disk attr groups
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-15-john.g.garry@oracle.com>
 <20260703122515.6B9AC1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703122515.6B9AC1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0082.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6625:EE_
X-MS-Office365-Filtering-Correlation-Id: c0a238fa-47c6-4a03-c6d1-08dedc077e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|4143699003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	azCuPzhwGr/t7IJ6elLB0t33d4kQHXDTvOyFlR9Chog2/mFUwGoAAxBaWPDjKDwRUx1qPVLdi9F4tS7xS8AmgaKkGpudCKXDo5Izfj5x7xlig1hRxpfvP4V4XDTAMKSuI3sIKMjFnfiuoDxmCktOHwt3Zxo0QFGq/w0d6Ql32lMHJxIH9GWTAqGfatW4GwTirfPGUTqJwy89KKJ4HGL/DyuaRTOIrSyKsOBd7Jih79zCphPi2UhLrW/aHDqeVmyFgVVUWsefH7RPA7YGvLTeFQNF5FA33rqZrP7ZoeMAJVmnWN99PUzyfgBien49Nytbo24OoQHkniyDtnzozJxU4LQ4FvhQTY77w/VM+Lu/DcLAHCyJeEpWZqM+3cq7toiZ9xMk/2MviIrLGGAo44r50NT3Ig3lSlR69m+5twe15mtFQZNVJRLTKt7kS2x+K3p444HCru1JGUO1sw5/5yLtK2TFwSc9FGlK9Csqmr4QThx5yt/dBZp5seHhII/arYbKip/KHdQiwaeAfJ/WfJD4/bKXD9NNv1aUCu63sUAhqqaQDqYKM34zWBDqEcwr2CZosvDwA5ZiBWdLFMu60N7WSONbktMqvQ1DVNDb5hZ6iGs0AsVkRzkoQKK6GNAh3mf++25ryxVfYOvg+6xr0i1zsA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(4143699003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGVqYjhkMDBQSFEzWlBVd3hVSGovWEJPS1lwWnQzclB0WnlJUmtlTGRtWDlF?=
 =?utf-8?B?VUxMYWdra09aOUFxbTYyd2pRRjJnMXRrcW9tZzhVeXgzSDVrYjlYeWhhVGhO?=
 =?utf-8?B?K0JPS2hISktZU3Z0cGd5cytWREtUNkhkN1dwZ2JuQkI0RkJobE1vdXFPdnp2?=
 =?utf-8?B?ZGdhQjR0aXZESGdrNklnUTN1NU92cWltQWpPZGNIZ3d2a3hJZXo3L1RsS2tW?=
 =?utf-8?B?Z3dLclYwN2RRaVhia015WGFHVUZEdTdMVTFlYjNoRFJiWHpsWldCM0lJSHZE?=
 =?utf-8?B?cUVtVWRIN0lUVUQ2SEZtRmxWczdPT2RINWMwUFZxQVl6VWI5MEN6TjVBOEp3?=
 =?utf-8?B?N1RHaTZ2cU1kdjhsakg3clE3OVl6WnFQd2JabW5PVEJwVzg4dFN2NHRQRWZx?=
 =?utf-8?B?SVd6LzNDOGtUTDNGTWhMcFM0NVhFSDRJYXdXR3FBQzRRaVlZVGVQTktpMHkz?=
 =?utf-8?B?RkxUODlDQlJBQ2tEb2NhOWRzY054WC8ydkIwRldWK1dBZnF2TjFrTHpUTENx?=
 =?utf-8?B?d0diY3VQc0VvcHNVVGhmbFpqOTJYVXl3VFhoVlNoUlhVZ3R5VlQvUm9wb0F1?=
 =?utf-8?B?dUVMeU1xaVp1SXh0YVFwUW9td3o1d0ZEbHhKdkRpTDhGVFdDdXJCNktkckYr?=
 =?utf-8?B?OUIzRkZ1TlpyQ1JKdVhOeHNGNHRyNVVsMTR1MEx6YjE0L0x3SXZocG5sanhh?=
 =?utf-8?B?SXJrVEVpWGdJMlNTM1Nvb0YyRHdzTERyL3lqYVV1UCs0WlJjYXFSUnhrT3h0?=
 =?utf-8?B?WHQxMGhibzJrcDZsdXRyZFhrU0JhYkZnRytnMG1QeG9TRnVXZGZwNGhUUGpZ?=
 =?utf-8?B?QUVXdjVYUUlMQlNpWkJUb2g0RnBGa05Pblc3Ykh4UEE2aG8zNHl1NTBweXd6?=
 =?utf-8?B?UFREREJsM2pSTTlEaGlZbWVVcHAzVmxyeGdXL0JnNVZHdUNzenFNL0N2eWZM?=
 =?utf-8?B?cmtXS2FldXIxQXc4OWpKaUR0QllrZHl1NmZUMnl6S2U5WjdSdnB5cHIxS3Jx?=
 =?utf-8?B?enRYaGg4RDh1aE1JNWFTWHZJcWM4ZDVPVU5ieWo2VENJZ0tHc3RnQzZ0VkhL?=
 =?utf-8?B?aDRpSDk4S29nUGI0NG9KRmgzaytyWFFhMEZVb1AyeDYzZTQ5dEJ0YTNUWHhJ?=
 =?utf-8?B?NVhZZmR3REF0ZnFNdXQwYnNQZDFEK0hGdW5ZVEZuMDlqTS9HTTBmUTM3ZGFs?=
 =?utf-8?B?am9IRXB3RzlNamdYUU9MUm9HVTYrVWpaaWtpdVJZOGgvTDlVeEd4bGpLVURB?=
 =?utf-8?B?UThOdzJMSVdSbmpORlVRUzZxUVpJc1A4bE11SXNBTlZGZkswUFl4TFVxa0lj?=
 =?utf-8?B?amtmTmpERis5V2VSbnZNZEpONVVhOEZZbVNOWnl3T3U2TVJ6QkwwTHRjbUZ5?=
 =?utf-8?B?SXhSeitOZm9lbnc3b2dQVVF6T2c2eTgwWllQaW02ZURudlBvQURYOTNoU3lV?=
 =?utf-8?B?WmxObEd1Q0c3bkZId05yZmZydEUwU3pWVDJ6OFkyMmQ0WS8yOU9BY0xnbTNx?=
 =?utf-8?B?bkNmMitwUi96dWVNeHZNMmdOeTdLcjJ2c1prYW5hdXluQ2N6Umt3Y1BLcnh2?=
 =?utf-8?B?VnZiZ2l2eXhiK3NuWHo5RFZaRGI1ZUVWTS9QeWxXUEFndHlZZ2JKSU5zbG5Q?=
 =?utf-8?B?R3ZOOWU2UTVZeU9raHZiZFlodUtvQURWcGcvOTN1RFdoejRvb0IvWTllUStQ?=
 =?utf-8?B?YU4xb1l6NyswQ0pQSmU3QWZGaTJYRFVYZ2xRd2I2SmpjSTJQNWlsUDc3bUZN?=
 =?utf-8?B?ZGFYQUdQVi9IYjVJQVE4RHRzZTRpVGpieFdWbGtXUTl5K05pME80WVI2Vy92?=
 =?utf-8?B?bjRIWlIvR1dHRHNTcXQ4cnR4ZlRzTHBySXdZREFVY3pINHZ2SVBwQWdrb2p0?=
 =?utf-8?B?V2JuMVR1VW8vZUQxNTNwd0Z3R29ITkpJZlhXMElrQjVYOVZYT08zZ1BQN0RN?=
 =?utf-8?B?NndlZ2NQOTNnZjJlbS9uTmU3VFlxVmpybFArOTJlYVEzVnRycFN2UksyTjBS?=
 =?utf-8?B?VUttK1RwR2toOUx4S09WN3E0dkRnR1pWTnNac0Y1YWRXSTlReWk1eHRHVDU5?=
 =?utf-8?B?TFFMS0JSZENLWXlURXlTRXg1VEl6elgwQU5mazdrS3pOL0t3S3ZaUGdLd0Zi?=
 =?utf-8?B?b3FHMUFKT3RQb1VWWURTZUpWQUdpTFk2eFBiNFlrWFBwK2VtaXNWbFFiZTRr?=
 =?utf-8?B?Ulh4K2cvSWo4WElpQVdYUGRjYWRRcUkrcm1YYm81OTVhK3BOZ0kxdmdJMXZl?=
 =?utf-8?B?T1NXWjRLVlEvQjZ6VW92ZStHcklDcVR0eVFiWXpIM1Z2dmdKNFFUUHRJVHdx?=
 =?utf-8?B?Z2RXTkpWYnFIZXNFR2RoeWt1Y2g3eTFJSzZ3QlRRWFJEeEI1cFJDQT09?=
X-Exchange-RoutingPolicyChecked:
	JdeuxwhNfYdb3ta/okkZq6S3Z/P4pFlILgWxkOcjmGk7J0Q5SN1ucivRe6yWJKqRmGiQXGHYbSW59UbGb62jHjVRr9KNdWW/tEkC0ElO/Xe2EK9IsfNNf22lWbeDsOZ4B1bgxa5XLntANd1sU2zgj9VSyhadSztL8AgmAkt75LpvlEVviMcI4KHhjTeHREVVXpVZti9nCUJWfv0MimLSSHhw8XfTnbezc5tZrg5Q4iqbERczkWne9AahI1SLXOUbYhgToSwJ4iRAAMM9xrAaaCiWtlj2dkNsMT/W2oumcRxShnuM/qpzm01FUhTkJY1h3/Hw5m/prUv5Rrh3tx/O2g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7eEXq6l83CuGcxdZsSnuqccXOUX33JMlLbooTeDVWAOQKS6/PoVX4zPoMXfBTIW0vAlhK7RgJtQ/u9TbIBl/Q8HD5uQ4+XQ5YxO2de6ibQpAebVLyZvRYkM5UQHYs4V4nwnjNu+JNGwDSPOLn/VNb8fdYgn2NvDlQu/rNm4tQSaG4K5iREvHgv1iHS4Q+qAwAPiJ+bblMBt/O9UR2CoFqc16VwWaazsFaqfnuUhuW2G35D/aj8NfUD/guuH7b5i9hFjvoJ51LsJKEpdbX7rDWMkOKJbL9f3Qnjr7CmlC3j4OSI1Zty7qXYTosxxrBcUFS64Bd4XrYrs1OhRMZibnMEDeOelZ6tGyg8KPcfW1rKx/hVxvz1bSz10BQ5B4UVacpkPMmwgz0oxFy8jXpSWtPWz551EAxQ8jFmnm3PUgi5wNPaUrc4JfH2s0bBUJtSRcjejA0wGk6tB5v6BUlGmgXnEfkk5RLNW5gKNubRrFrIib+NOq5bwxTE6Kh8T0sjNxZ0De1B+PQgqM5E35lCqh6iiy8wSxG1YKMHOAuWjL5OWT8h4lHf1ifLA/nPHvxrjdyYEtRs7P5YlrvJmTIRkVHD71w04QNiCzE+av0blSSQ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a238fa-47c6-4a03-c6d1-08dedc077e2d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 09:09:47.4979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wH5ouEjVTzdZM8aFywGNnx4IRIlShHZ4v5FSxdqJNBVkrmR0+WT//2koX5VGzLZZfd/gFaNh+wT6zFSGBk7R3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6625
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxlogscore=788 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607070088
X-Proofpoint-GUID: KtlqA-x_-SsA61-EDWDLdMJYVv6EX7Fv
X-Proofpoint-ORIG-GUID: KtlqA-x_-SsA61-EDWDLdMJYVv6EX7Fv
X-Authority-Analysis: v=2.4 cv=LpuiDHdc c=1 sm=1 tr=0 ts=6a4cc261 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=kI25tp0qDCT6JY0gKHEA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12222
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA4NyBTYWx0ZWRfX8j/yoy2I7uF9
 W4hjN36T8xxtfQWrK8kZ9ycP2wgXr5k07XWFQm5KZCG6csFJn1q9zCDvtuh6vCeCnVulC/rHq2g
 S8LV+1u1n97RJr7kvxsvx/jfsBOxSXi7ARZ044EMt9ItoesZL+/D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA4NyBTYWx0ZWRfX27Gt7IiecsBc
 UOvkMzPb7KD570qowAHPqfcPMw3PC0zWAYrY5ZrblLNWVPRKJM9y3YAqXBrFgvwuKy5ujvWC1BN
 9MUDB7Cym6tyje80s6lgsppO8twKGPKTyBOMOBUc8KtTG8Kgygq6cw8xjAEQ8YC8MuHeRd+Cd7V
 9rjn4rbf9X1waMf5iGNs57h5+fGRqWZGiaQBGFxWkfMY9+0JwMhp0cPVd5HYEwUxs2NQRlweBH5
 IR91DN8yAnQWbNuqxbMPz4ixHILaM6Tq7XUwqKKOit1xeJdMoMrO4Sc2NK4sO+slhnOkh7noV8d
 b9q36wbsFrV0jTv0PhbwdlKmsDLiXJN7IAAzwbVmSEQGM+oqhBmUi/qb6+mXpmlADv4XnhmS3lS
 RC1G3HhxquUj6rZawhp0Oj8ZPL/uU+K9MeEOJpEdLW1umlvpuKPj0XJXExm7rgrCGKI4IrNXiuo
 U5l/M3K4PCNajRBeogZR7urfoJ8T4PwxOupj9h8U=

On 03/07/2026 13:25, sashiko-bot@kernel.org wrote:
>>   static int sd_mpath_probe(struct scsi_disk *sdkp)
>>   {
>>   	struct scsi_device *sdp = sdkp->device;
>> @@ -4161,6 +4196,7 @@ static int sd_mpath_probe(struct scsi_disk *sdkp)
>>   
>>   	mpath_head->parent = &sd_mpath_disk->dev;
>>   	mpath_head->drv_module = THIS_MODULE;
>> +	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
>>   	error = mpath_alloc_head_disk(mpath_head, &lim,
>>   				dev_to_node(dma_dev));
>>   	if (error)
> [Severity: High]
> This isn't a bug introduced by this patch, but since we are modifying
> sd_mpath_probe(), is it safe to use kfree() on error paths after
> device_initialize() has been called on sd_mpath_disk->dev?

I wish that we would not have bug reports on pre-existing issues 
introduced in the same series.
