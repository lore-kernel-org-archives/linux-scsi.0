Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A98B45C18;
	Thu,  3 Apr 2025 14:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743689111; cv=fail; b=MYPOuzE4cPsmb6pnHsYWTdY7xfQ+sBDyGsJKdNFo4mZREzKVpbveU+pr6lj3EemnIQb4HT5oXGkwzljM3U/YW6zQbxvm+YuTBzRnCnluxyu6I3WhmKcZ4wti6bNkgV5R6gHmEyfbhKlJI9k08nqk10bgFpyCXZjf+p3tpgHqXrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743689111; c=relaxed/simple;
	bh=WZDLjIaZ3St4z+36ivih4j5ephgp+OUea70mV9gaZzw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RQMaeQLmuov8HPgBNnOTvimv0RYiImgsK0XucmZOOxxYSnUjfW9deUQjswC7FXK1UpvOKoWHnvFOLWc64n5hqeVsspzG7XBJsN40V/DmF4SBUOwJNd4P22sF55xxAW4xY5VvYx389+IRdLbX7Uio/LclX7N2ppM08DNqpvF+tP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=izON34LX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bEFaOBUJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="izON34LX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bEFaOBUJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533BHYHx026182;
	Thu, 3 Apr 2025 14:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=b7tuyEJld97m5rx0Xa
	fTIdEbBSOZnHx3jHm7NP+GFpU=; b=izON34LXUqPLspcJPA/+PT+SUdilGTJpL3
	ikIzP01z+uPVjPzmYo4brfVpzNulCcov+R6/R33rpH6MlP+yRQA6Ttxtae1KOxWX
	4RRjEGPMlyMoe/wBhR3wtItrKBIfSwD8mAKQDx8rSXVKuY+qTSBaOGJCeja40ZNL
	kpVyEZVziC7suIC/354ZfJqgZUECQaoOzlLfvC3V/TymToncQDjRoVFO3F/P2hfB
	nFQoHUaXSzPKjmVYRuVx5tlAZO3+XYwc6LdOPctbi6KEZKGrcpClIW16B3PYkj91
	M6vZG3xPH+z767J6WDc1WU1dykQHZEfuRWjm3joXPNXIygYmEI0A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p79cd2xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:04:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533DR1A1017033;
	Thu, 3 Apr 2025 14:04:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7ac7h5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:04:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXU4rMnapsPkT2Vv7lfWSDwZcW82dzeDU5doJeNb4hyB3I+JoUdWqBqucRRP0nLy/WtucTrQ5MYyQ4bDpDEAAJhsk1RPVzmia4xJ2xFxVhS8HZ4M3zPyhUB7R+01EKFEY3oZFa/Fn2cwLQJG9HqlyTzQjuPG224vjTmR1GfJMUdWWy1xnA8ooOlqdevmnFrimwPp20NFabvYjIsSIdM0tkRxTpGrWLUyMUXgp2FMBy3jfWLe/85yzHRD+G+Hj5msDUTEmoeNVe1il/fPvobsoFecS4ncRCKcd/xEb3hvCsVbo8jJO4HdRZP4DRN5W7lQhsemOszJOov8tO28DPXC9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7tuyEJld97m5rx0XafTIdEbBSOZnHx3jHm7NP+GFpU=;
 b=mAv0zjnMh8GY4qdkyOAV49YcaWQs1oBTdKOHK9+c6lQ3gjI0lKwAdjDstgUYTfm701MAeYA1VbyHnYwiOp9AQnAPi5yRTBttVAjqmZhsmExaDGqjqMV+WZL5LxIAELhfjIe892C1Sq6ZHnGoDaspdESziARZhvKhjd/rWRTNN69TAzbALJrAUixjIja5qddvcFN+56eu5a9ARs/iuzE0AxDPEDInSt70Gqt/sJTu8Tb2gB9ir5ILwA1blqfbayA3CGUzjsykBSTgBM638nwrfTEpUT+RTRqjys3cluSAz1XB5ud+pkH41duFlvGaA06ZSE9A/5+T8IERyMJOOGgE8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7tuyEJld97m5rx0XafTIdEbBSOZnHx3jHm7NP+GFpU=;
 b=bEFaOBUJPVcLZzHPZjg+zAlufttticvJ+/k0CVrYlR/oFlxmX4Vhl7N2BkU0KapVmqgwuo+7daonfPQmw206TIjvKbNPjWnSt4U3vWQu0Rd/n2mykZWVZWdOz0bhJVRFBtafxkBZjssjkTEj1aOyIUG9FMhXLpbts6ZOb23ziao=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BY5PR10MB4356.namprd10.prod.outlook.com (2603:10b6:a03:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Thu, 3 Apr
 2025 14:04:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8583.043; Thu, 3 Apr 2025
 14:04:32 +0000
To: Peter Griffin <peter.griffin@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Chanho Park <chanho61.park@samsung.com>, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski
 <krzysztof.kozlowski@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, willmcvicker@google.com,
        kernel-team@android.com, tudor.ambarus@linaro.org,
        andre.draszik@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/7] ufs-exynos stability fixes for gs101
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250319-exynos-ufs-stability-fixes-v2-0-96722cc2ba1b@linaro.org>
	(Peter Griffin's message of "Wed, 19 Mar 2025 15:30:17 +0000")
Organization: Oracle Corporation
Message-ID: <yq1wmc1uys8.fsf@ca-mkp.ca.oracle.com>
References: <20250319-exynos-ufs-stability-fixes-v2-0-96722cc2ba1b@linaro.org>
Date: Thu, 03 Apr 2025 10:04:31 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0014.prod.exchangelabs.com
 (2603:10b6:207:18::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BY5PR10MB4356:EE_
X-MS-Office365-Filtering-Correlation-Id: a8ad431d-3d7a-47d2-7b52-08dd72b87569
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yVfrTzdCc8fghb1N/dqZoefQWJ5eBhJUJmLlqt8UbdWKxeLypU5MIvJEUVei?=
 =?us-ascii?Q?qrSN3ImAKOexzpH4KdDQuSPr9cXq1hPoXFtg+AunsO3pONBVVyP8/qL8vR7O?=
 =?us-ascii?Q?ACJPnabTDSa+vVNaNAl9Do2ado8zKX74KUMk6cAADF5ECzA3Rx8ROgetAnXb?=
 =?us-ascii?Q?vpa12KizbpwE9wOEEybO6KyRQUzGBEgNi+l/jcx0AuczDG7sf8ft5Yd1p4c/?=
 =?us-ascii?Q?ZEGUu/ogKaQFgbtNFGbhF7LgW3LfzO+sDZnQ6TzKGTD9A909lQD+t4ow+zkg?=
 =?us-ascii?Q?4xhhIPTB0CivAUiw7p9vYqxFmN6N/EEpkA4wBgPvolgKzZZHrR37VyTrJF/m?=
 =?us-ascii?Q?jqfOC95NbX4XjTvTWLxuVkb2sOqUYjcles8lCjjxhqiTwGERmCZExBALgXwi?=
 =?us-ascii?Q?NlhyQ0+vkAvDoM4hpj3GkanE0n07C4hRu46O1nCUS4smoHestRj0AwzCN5Zj?=
 =?us-ascii?Q?yX8o6SO4ZkDAekPNojei4AeLOosRhFB55XykVfOG+Ofn3hQ0qbd+h0slOa4m?=
 =?us-ascii?Q?XaOTrpdlZAqDzrBMv9KGwfy/jnNqZCQHxDQyrIZmWT5EQeVfEuhoSq+mK3XN?=
 =?us-ascii?Q?g53vwZDYCtLiv/N5R5kkCys2d8eZLu9hcL/2E3W9rRVUq0r0PJo7ash/O8AB?=
 =?us-ascii?Q?p+PYgh5VbJc1Pe6txPEoNhs0RBQXYpUZtBOhEX4BMtfcs1Q3o7Rr8TDcQKH9?=
 =?us-ascii?Q?+MD9JamFxr8x1Sri0OE+Q0cvzAxyiLfOLn3qi/2XCtBEJh01mkmDpF6giFv8?=
 =?us-ascii?Q?YB8rNREJoGliBzYTCy9wswSIxjnUXGQBz0esXWwcBLtnmk8jhKPs9Mw4AsVU?=
 =?us-ascii?Q?mmszAXMwqPNYM9Im/h4p7O9o4gGlwW4YU5Cd79tn8fGuKRfefB68h2/qu9v0?=
 =?us-ascii?Q?a2U1ysOd967yFHbtWp/ZnsAss+bWThaTRCBuWI5v7fPYoh+TGBZ/8U+RMQNr?=
 =?us-ascii?Q?nACXB5Ia2mgcBK9bvw/zSbJKAMWKdMkYzQ5RUYZcS7auzsnklJfXbHCFIqI+?=
 =?us-ascii?Q?us16BSgroBbt47sCJeYiLuxVTRM2OhjX6r32Mr3lrRtf+MTmuZ7IeOnOs44t?=
 =?us-ascii?Q?kgcplVh64hE+mTlpV9gH93h3JjbAC4/qvJ/I2aQWjrCOnqyMCM4qr1OSoCUX?=
 =?us-ascii?Q?I9+QCN0K/7UnSVfzHV7A0f/cUl7x+hu7zO3jEFPpMxI6JoXuMys9prkjNFjB?=
 =?us-ascii?Q?mdXaBBB2khdBwfb40xUYyZXTMLcVwPEqutsyH29CwLw5lBuNyIlYdkV3jXLu?=
 =?us-ascii?Q?0Kxf58e0vwbecJWdgEhMnAJTnL3J0UfNgnMjMxKmZTFjUDLBhHuD+w37VqFW?=
 =?us-ascii?Q?3GHT3q9/aObBNN9UtdWqBsUdtQnvLXqeFSUuiDWT9zg3GCN8JDUhP1DhTII6?=
 =?us-ascii?Q?PTIgFK7+uZLnD4+OqojlKK8rkh/Z12Y2uvrZZ6EOvSNe2B6Pt8ivPU7UppEy?=
 =?us-ascii?Q?Ais6NaV89Ww=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3oqPnEhKx48TB5FcPnvvtvA/twmuE9PujAlNI9uAdpV6zsJimowfywkL0BsZ?=
 =?us-ascii?Q?vf/qkO3Sw3OULOaEvTd3YTv3irrJeQAT5kMhdh0KilKu27zEPAfuNoSZvLeM?=
 =?us-ascii?Q?b6Pofp+3M2epC0yV+hifeATAe6DUYzO/EAnNtVg8rxgfnR8ee71wvw3hfVlY?=
 =?us-ascii?Q?E2gr+wtlBrtuD+LZuYQvgOMrjeqD40hijlYdcg7FG8ZEIXZbvpToKhAnAKE3?=
 =?us-ascii?Q?wuet7d3r6rZ4rWFI68cZ34EuiXpljN1ik1cM8ocdpNrqUmk/sjXHSpcRAJV4?=
 =?us-ascii?Q?s6bKnH7v0rdg6KeICkv5LsvSbM8nvmwljcg1M96F1pnKSAYylj9M6VcGUDy7?=
 =?us-ascii?Q?m/ojUecyNME/NHYBtJ8T5H/uzq/4dHDq9Uaq+Wocr+PVuCruaWEjMCBOOvis?=
 =?us-ascii?Q?9zOpcRCR+VyvLXH8p6qG3HoGWoT2oVA+IZ8Wu2azvaT8c4v5oZk71Sa2Wmh9?=
 =?us-ascii?Q?czofVlJ3G6tDf7HP0xZt6QaBrEhReTLdkwRGSj/fOMEwZwaU4Q6YkakpdXY7?=
 =?us-ascii?Q?kBGN0sOcTnij/yZCvbhYRtan6gfsAZgneFt43GxZ6HbTKZOLbR4xlyz4Q9uR?=
 =?us-ascii?Q?kO431o5o9fpn0yLw8j4ciJSDvxvg3anJf4VX3XyJ7fpKm+Zjp4UZAoLeWLM7?=
 =?us-ascii?Q?e5rfZOf4MjEry+ej4UJdqn/tl4TdSYdIcMmnB+8VdQeN9IrtDpm2OSpfmqKJ?=
 =?us-ascii?Q?LAc79SfxM9KaxZrO1wNvH+2wGzqA4dZhqiHno5b/zeXRC1NOiQHkLdmLQwAG?=
 =?us-ascii?Q?jAR1hwCCnqQv900pnqHZPqJz5Pa3LS7no8c2mzeayjaoG6kVSaytVwgY+NV0?=
 =?us-ascii?Q?IdHfJUkGyT3bS186F47cn1hCz8OMv+xsWXSmZ2DxhSbaT2V8EDdOLKQIQuiJ?=
 =?us-ascii?Q?7uvuqgXkanVr11nYmH5k3UMvRQRDp913Xb6JB1XJ/RwG6WgN89KK+Jf1OX58?=
 =?us-ascii?Q?tOsrhVesP5IhZfqJ8OFNEuhLcfg6H4nVSE4896QSn1MBrNb6qkkEDCy009ex?=
 =?us-ascii?Q?QohuAbNXjevZx0fXpEkNLdOxE1KlBgRQvKUzEpI0Lz7PjH/TULJTDZ93YqaD?=
 =?us-ascii?Q?w2ELUaQk5xb7UU9UwKj62wwlHb0ohHNRsFCJ6cWKW8ykkv5rV1jtjd30VFDX?=
 =?us-ascii?Q?eFbCPcNlIrVh+cktofJdcv/xEvAlTLutlxSjw5HEsN2sGQuya8JpIz6s/f/7?=
 =?us-ascii?Q?fVqeDyw45m4CPpTo+ItqIlKbfssUfELsuAccO414J/MSVGc8vJluzbPOFG4R?=
 =?us-ascii?Q?MHRGi9cjU/GKm7J0qUVdPoyn3J/9R+LPd+Xlnh+7SzZTw8kPk2aEP03BBmGE?=
 =?us-ascii?Q?kAYv6Ntay3rNrzXbhxoFg9VR1VPP7fzkkAzSQtEj+fCf6uCqY+7J1N/Ufzbu?=
 =?us-ascii?Q?vgcMNmnL9p1wyLbKc+wuBC7l/Hij79oHB3D9W3j6sM56OSzmFc0b2C5/kvZ8?=
 =?us-ascii?Q?TGVkTSCAhUWIszuPSLiJQRf7s/rORvRsgvCWoPuFVHf4JPjuT8eud08um6Ar?=
 =?us-ascii?Q?eKbT8c06l0tXKi8wtpH48hQSnR0HulZRrMHOb0vYSDnmypRzqLaNqo7AQ0l6?=
 =?us-ascii?Q?D31H1ea3cmhneSEQjVw3WWZ3kwg9JjjEl+XYkt9YOvamTB1+4i6Ej5MXPWu+?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OoKLwVXRTELN22gWK+usksWloOACuElGf0dccL1PmVo5GmZG3gA7JBofDfZZQO9Sn5jSSIA3tbF9G7FHeJwBOjT/NCy2jt/WaRv1FDA1FBbBOL0sngm44oNOZvk27J0Abu8FNOZLd2dIJlpfTnCg8vduBFPOgbNcrEbOJkDtuXPBE0u8aaYe4h35Xx34nLH2m8RGl72zkJn2mlEoYMNLEbXg4AcIzTSf+LhkGSxHKrxoBAoNPA3MqanzxeYsYOp2jQERiD9UeCd9A9RCmx7MCNbRj7IATuWHgsYtjRsFEqgHfUFDTEpUmbJePz2AOB+Hp86FRWOggTRc3wdFtLL0eGxDxz/zpoTnudfd30OIWBnS/LVo2cIeg19ONVIKnyzju95ZXlmmryDb+LGG94QsXL4zcm84l7qHB9U9zlNgrZKgeMcesVJaiBqt051ltaPlasqXCDB1lRKu1/Usb9cGosPPiWmqpPLevpt+SQM3CvNlQO/TQ4YK/dsGHHo0XwIJQjAHAVpQfD+mZ020wp+yCKMML4CGNpl1tVD1bl2Tj22FVZVV3xsGZKnG3nrdkXE8pXZNoj+F10qr/K+L4mO7FB3VnhkMoQEq2Ru3sJsxuXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ad431d-3d7a-47d2-7b52-08dd72b87569
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 14:04:32.7032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lObu1f87M2qyNgOUqQmF3zR9yHjKoF1IH5sA4viiQFCormsGov/j7T4kSzowVsjjir2JWX/tZy+xyo5SqPXK6Oq7jEQLpfrQ+JxAbgwgSwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxlogscore=770 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504030065
X-Proofpoint-GUID: 3D_RuKHpenlnj1zJD_XJBGsI1BiNEyCz
X-Proofpoint-ORIG-GUID: 3D_RuKHpenlnj1zJD_XJBGsI1BiNEyCz


Peter,

> This series fixes several stability issues with the upstream
> ufs-exynos driver, specifically for the gs101 SoC found in Pixel 6.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen
