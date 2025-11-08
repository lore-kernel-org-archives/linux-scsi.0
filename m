Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F600216E1B;
	Sat,  8 Nov 2025 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762622140; cv=fail; b=BedhhP9zfWPYfT38QJu61zASTJm+ygPSFhIWtwluu9VeaM9OvoprQYNB1MfFZ7s3eBRe5aHg25KlF6OHKJMCnv4hrMaotPNIKq/M4sTMmc61netpBYrqWwOx5cBYvcC6vNFxtMEAL8G3oVXwMuDu5kE2erkr/EI9M/UdSZP3qTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762622140; c=relaxed/simple;
	bh=eYlIT4TYYeYNoV+R/3Y+BthDBNuEXCa7qIDDXYnd0ME=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=j6QQc2oL0FHov/eTgMzihbVlWulSeGO2Ze0cMDnV8aLNOSGZcRRC4QY+iZrDQ6UqnDlqFeS9AcBSaAhiUHPdvb8sJxCyT1eu7HKA9VYapuB+m7SFrJVLMcIthZ8c2/6ju+OhmhFPeqThClkwZlYboczPDy1XZuZ+tYWRrC4KZ2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Er8Bdb+E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h9qgeKvV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Er8Bdb+E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h9qgeKvV"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GiJ62013678;
	Sat, 8 Nov 2025 17:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2HHZ3Rd9Yu2GTGlTpM
	PKLUF68UGBqQ6rWezn0DmC89Y=; b=Er8Bdb+EzR0MEnelgfSAO3ncUOxRYOGwLv
	r8rszu6KR9z6qQDRbNoRp1CtnOzgMKsdunyoXnCdlruehYJCyKT7J9MnQbpOQpoi
	h5ngGcPq2E6XRgX1lGcQ4sbuyhuOM8Gm4fojThxcN1ta+RgaONeOoFhcM0enKoym
	CDkJfD/VnXCzrF/xmrFeo21nosOrJHPjeiObHu9xMqLC0Djgz8g4OrBbmPu91Fsa
	9T+Rf5o9x9yto0Rs/wSNa1lV7gBh1Q7xkFnhx/vnGXHR60aAUn3O2067YRYN1L2y
	olAQjeWwL1yGGdVnwwHHrhHIc5ra8rf6Vs5JwryQ0d4cu9gc3UMw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa7m603qa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:15:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HEIik039940;
	Sat, 8 Nov 2025 17:15:20 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va6pw46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:15:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xe4KMhyCuCBWdJMvP/6Nb5jx1kw3DU6GV40ZAM7mS5UqQgQU5pUE/dpGN1X0lAgmsrkC7yC9Pq2qpyeNNJgbeTEMznLPDnX/hebKxFSl7QmEP2iAwTwysYOcGfkSR0cHqrpK9sRkc5y3kBfnkAYVyY0xONMCACKcFSUh8LBojhbQ1cpw2/o4Ellv4ualn+16xUQHMkyBxS230eGnY6GKvyUDGw6eYWarcq0H8iANESncjDLY1YkQ0n2aXFJw2ffo+v+Rnl6g16eCJ7D12Rmtxv5id8UzodHEsKggaDbCaaz1qB8EqBhbkrHX4CygTXMZaeC0bnGv6WTBriZWEywYUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HHZ3Rd9Yu2GTGlTpMPKLUF68UGBqQ6rWezn0DmC89Y=;
 b=OoQH/Pq+6xS+yp+HEBSCHWGBm1/YaHKJA8e0U4omKXUPK1kAw8a3Lsm+SqQRStKQ3yNJMbGSkTqgnKd4WfWN2h8uhTA3UQuDWf+jMs45TfqcpVErx5K/5Q0hClo7M0LwUkUeWymtg1GgUx3bS3VF2eSA/kD79ZxvO0So9NO7QjiiCV90t5Kc77BJ4/4PVJ2u3EdhaO6jirWzV7JajLfB5oClBacIcrJMY22ghMCGMM2oGgDQIG9dfiutEP32zMVUwRd51gjol8dwszNkZi2nhNFOSL1COp4s0pPDG5UvnzHXI6tZZXnYsgPLQgmdWgSgpwSvrDeVOLeO/8amcDtOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HHZ3Rd9Yu2GTGlTpMPKLUF68UGBqQ6rWezn0DmC89Y=;
 b=h9qgeKvVtEX5V2b2InI3/E/0NOKdayoRHfMmkCTRDamjbBdpHiX/PIGmSCX5+X3ORoOXYOg3o7Qg7GoQloq7WrB/khDVaQ16xe5Ox+fZpvsADGERb4kp3WTNF6I4zqAN8P9t5ZCiZUd/IMKYg+gipjg1wcUE86dcPusHyFeYmFg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Sat, 8 Nov
 2025 17:15:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:15:16 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <bvanassche@acm.org>, <robh@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <conor+dt@kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <matthias.bgg@gmail.com>,
        <angelogioacchino.delregno@collabora.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <wenst@chromium.org>,
        <conor.dooley@microchip.com>, <chu.stanley@gmail.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
        <chunfeng.yun@mediatek.com>
Subject: Re: [PATCH v1] dt-bindings: phy: mediatek,ufs-phy: Update
 maintainer information in mediatek,ufs-phy.yaml
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251103115808.3771214-1-peter.wang@mediatek.com> (peter wang's
	message of "Mon, 3 Nov 2025 19:57:36 +0800")
Organization: Oracle Corporation
Message-ID: <yq1h5v4jvjh.fsf@ca-mkp.ca.oracle.com>
References: <20251103115808.3771214-1-peter.wang@mediatek.com>
Date: Sat, 08 Nov 2025 12:15:13 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0118.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4391:EE_
X-MS-Office365-Filtering-Correlation-Id: 27a0b095-41a6-479e-60cc-08de1eea6296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EPV6k4uJPJAfq9o/MXmxx35T1fQ0TNASQlR1ZQ+iYk46XK3Gt42Ro0WbBNms?=
 =?us-ascii?Q?OVIXkuhBFbUCdOH/px3LCraJGsv0u40cQzUW+AonhUz+qP0Py3t62ZifaVFb?=
 =?us-ascii?Q?a5BhX57qU2nsbulX9nYXFS8EqmAHCp+MlUlg+DwuRejgvP9U2Ha0WRjZZ4gp?=
 =?us-ascii?Q?0YgzazwdfvY/iEDBMU9ND3EBRxPRHjB+QTy1AWBZJqoeCCcgncmoaNyOHnp5?=
 =?us-ascii?Q?PLpv+EdhWQO1lbXbqs9fzv3LYE+3bjZRJ4UqOpOHqgn432tEtQV732t5R49p?=
 =?us-ascii?Q?yHDYjIDyuztbiW72johcvTAFrgMFaUuBXOfI/AaTtJZPr5uKf7676Bi4lioC?=
 =?us-ascii?Q?oL4Fd8g24qnoHXrjiT3qW3Imdrexlg5okXwdJ/vjZ8gSR43g2TiReJD1g1MF?=
 =?us-ascii?Q?o/2HW0fdxe+A/4FLodd3rKZUcadDJMPCylbgua/vX5uvxVHc7K8eP6WjN7OH?=
 =?us-ascii?Q?oOSyI8Ahx+am6eRP/uDk9cd+MZdIxdla4LS1atbUkLlcTcmO8uS8l4kxpU+U?=
 =?us-ascii?Q?zhDflB4p34T4/4yeoUN2aucoNCLvmBI6TxthcZ9H6QJW9GuOzZMpWo1l4omt?=
 =?us-ascii?Q?A//t1Z1O57erTeDbPOLgwaGxQi5VhdDNcDKm9mslbUzxRV4KG8f/DTnrg/Ci?=
 =?us-ascii?Q?uj0/A1inRSMxEOyCH5G4CLvpy7g++8Cll2Xl2BtaXbGgcUJCOJn5rwqI2wUd?=
 =?us-ascii?Q?WYm0uqH8rRlKSKlzUQNQBer51lfafV25i0EyhxSdsriIoGtxUAnG/TVvT3w0?=
 =?us-ascii?Q?CHWrErOqFTDsW1ZCKJO/QQWs3fCwGdnNwQlhCwMqSEMI4/TbBLft7fGiiss2?=
 =?us-ascii?Q?Bnqktzvpa4H4LIRLrjUe8h9Is4m8NBo1dQyHxf3WOJXZhc6HCRVG4wpmdscJ?=
 =?us-ascii?Q?c+yLWG8KDcSJt4SXnbgOGmF3gPBrZ12DiGsV3Fxom4/d6XuPwchXd/VRQ8w/?=
 =?us-ascii?Q?haJofJQcSDegCoW7BLzEtp9XlXMzDIArWVNxXvWnM7xTC38YJ8YnK0xhGiiC?=
 =?us-ascii?Q?6eRejtFZiF5rt39U8kbKsik9QLgWtfbWTXaPXbMoOk/nJrQ4fUxKSLEBQqwt?=
 =?us-ascii?Q?mJQNqto6HwyA0oC+DNsOLreVzvHOjkEq3P/2G7y+SmiHt5827de3MER+NIaU?=
 =?us-ascii?Q?/7Fkdw98A+tIMBH4oNmSRqaLr2vtLooFWcoknbS8le9oW00FzQvvONAo6XlG?=
 =?us-ascii?Q?13+eziMhunrpiPpy4bZxkfRhzv7e+BCT5dp0FIg3xknEoyNUNJrBt7sKbok4?=
 =?us-ascii?Q?fmf3RFg0rMxF+GnhvkpVsmsESwBaN17cMYg2NoPUo8ed47w7+LnW2PQ3qLRR?=
 =?us-ascii?Q?xS/i1xYffwrhuXc91uHVREIYm/2Zknv/l2tzV0SueuF0tVFev5MDc0tUWM1F?=
 =?us-ascii?Q?Vp8v02UhYXfeFzuRb0P+/xy4EDUdHu5QBLGcYMsqcSaqXV4eq8uxKS6lADG4?=
 =?us-ascii?Q?acj3PDX3+NRjELacUSO0sc+QyIb/rb8R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qHDp4R5zF/PTp9zE1x5o5cUqnMonjnfzHXVf9yMQtVUzW6V0xi0Vb7Zfxej5?=
 =?us-ascii?Q?kGz2f8neBAvep2wkeP0XHLu6b6FuMZnbOn13VLKru/M2RU9U0gipfnRafrI4?=
 =?us-ascii?Q?adjBu9z+0pS6H3dn/p8yYmVLABu6H+heVfPq9q75uR35eHRT1gWiBoRPeKMf?=
 =?us-ascii?Q?BEAy8319q7pgvYw9npTR6nQ6EvBc3Z3D2KmnkVbvLQob18GSYJRsoES8xAlN?=
 =?us-ascii?Q?98bwlzIP9IdcfUpd8W0mp+XUt3fVVKowwWVZngLltGFqtBe4NPodRPHtKWCR?=
 =?us-ascii?Q?MIDZeg7escOgy6PAiQwEjFyYJzncd4QysNJaiIi4LTeh6T+lRqLvEkAAY6EW?=
 =?us-ascii?Q?F6+qAbXZR6fb6lVb+vBoKIlpVwGPt/F80h0ehULyIG1+3s1woKfup4dyu/7F?=
 =?us-ascii?Q?rXktI3Pz/sLN2wodCH1jAYXs9SNsaEZ5WlcrzPLEH9TAwb8cCKWGupUtJHOy?=
 =?us-ascii?Q?XmFrn8HNnKkH0IpwM/TjLxCklDJwjCO18YADbzbWve8W7NAPq5ni2ovZrqee?=
 =?us-ascii?Q?t9OiYhmneqXRIPQCiprn8+11+/5MAfhou/MKdK3TMy/QLfNWW8Wpk/Xy536v?=
 =?us-ascii?Q?p6yQqt9ZS0vxB8Dc6KVLuZZvvnVS1UchXHbaVMC9e8Kpm+yZb3+GrfT1vj1u?=
 =?us-ascii?Q?fVFzqHraqXKnBqHURgg0kqHnZKZtSSZriW3n82dWDr2IzNwdKodjBcOdBN86?=
 =?us-ascii?Q?CxVbaBduuP/UhcHKW/7egaQnDHL3PCf0wAA6On2YpxCp8MVuOPLCkIFPJ6vi?=
 =?us-ascii?Q?ZD0cXJST2H0UJiJIGJUmbbasVuu1unYWmNgwhJ+P7UvGS+C3Af5BbG8KBoz9?=
 =?us-ascii?Q?WXuyiFXWhLDbrPQrbpkPxpsmn7cgdI0zl3en6b9iymyhNtWREYSPQp3ZO336?=
 =?us-ascii?Q?JaZCgAjMcWGLonWAZaGUQViqbqp2KfnZndcEWpRlFDNTPuxH4YnjVZuV/0Ic?=
 =?us-ascii?Q?gNPhrGn7T+IsJGorvWzhPt4grxa0WGAEIr6j3GcdTcsV2Vj5/miKcxUF/bwN?=
 =?us-ascii?Q?UCrepPYDP24wp5Qk6Gtw6kHMki/ONcLQ4FgDWJB3DShoUgcTOmVh/XkSny85?=
 =?us-ascii?Q?WYija6jcPrDWgnugmPyvieBTw9L3xCr8O2nc+SI1qRrwypEAlIaOWYIuXpvG?=
 =?us-ascii?Q?wE7aaRl8WUdGQM/SoYVUFc4RpVod7hOkV1yn0jQESYZWoPw2qAp8xsPymrIX?=
 =?us-ascii?Q?TkFd68s6cjX6Oq4pnIvQNlpkrpmlnkiY3YbWandLyDGM7E4BK7pyMdZQ+Kkp?=
 =?us-ascii?Q?ToLUNUz6vP9dUz1X4hCvvyfQ0WTFYeCiN6kMr/+bk4zf6+NQo8DwOQvqG7/M?=
 =?us-ascii?Q?cv2qYr74An2S5QNj2n9x8+2ogV+fX9zdSXsIU+bvwfa4ZVdg/GFoLgp9Ryuv?=
 =?us-ascii?Q?ljrOJEBikUttXOZZJDY3Vouq+wm4en5nzk1voNA5S1+X41PiSkY4iKUqxQxq?=
 =?us-ascii?Q?xf25Bbq4SVmqliZzthYzQ3j7oSC4rEdqT50jdx3w4YeAaLRps0jtadmBrcim?=
 =?us-ascii?Q?fyCbiFc0SiilRLn2O23nGEQy0ulK7bnd3Va91Cu20KkkB4rlyO5BvBUxpWAv?=
 =?us-ascii?Q?7poaNz19K0Y5t9wFsh55uuejy4myfG9KeqIJlAjACQ6lwipKyPdT40g3WaPm?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y8c8xPIrS6rKZWWe24jI1iL3/Pl5A80LG+DJT31agSWc9dlDv863KwWRcF1u804dCdZboTTVRceie9q0DGXUZsTpr9ho3XaU5S0AlwS1W121cxaA7uBLu5H45R5b1t40R9wOCiGNCjL2qXBv1lkbMM94T6p+csD6IaqJpkwYQinjd84iDVBRnXFGqo13Xor1i9vcmP8HAikVfVi4E9uJDbZI9t42hP+pfMsnP38diriYoniQb/Ft/F6xlzS402reHgOj4+FuFl/n57Kh20qwkeP9qojyRkxZqQGODk6cZ+geo6CATU3XfUKvV+pbG0ltmz1YBzfwp17o3Yiy7dY7OYgpQDCCyY7DkDwsayj8TchTGArAeNVCUBny4m9qD+I55UrR/hmPt1fWKjikv2wi+nCRIAUnuSdtrpbd9Qyq8vRYC/evutv9LTvZeMQXf2stZYmrOAYLfaiXaSEckfHqlslik/mqVISdzCi0UFHyTI+vBsRZkfKW1M91aWC67+mGk28TE9aEFy26GxgEKv0LYtZpqigkFts4zRirZ19PxsH45IoWFffChfvzM6cIuMLh4BBNfWn9io/t1pe8+zC+pM4AG7GxyMhQ2WC81HnZ0Nc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a0b095-41a6-479e-60cc-08de1eea6296
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:15:15.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Fj+fvuWt0MCVEugH1iztJsX6UbReQ4au/FiDLdsTZPukbrQN5xSB/lo5bGOlPeVNddzf1AT2vEoBBiilUbV+MbrdAV0/UW5zVgAq8Qd6XE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=880 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080139
X-Authority-Analysis: v=2.4 cv=fvXRpV4f c=1 sm=1 tr=0 ts=690f7aa9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
X-Proofpoint-GUID: FhfWBTCFMaFBRUCYI0OpKQhZazkymu5h
X-Proofpoint-ORIG-GUID: FhfWBTCFMaFBRUCYI0OpKQhZazkymu5h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDExMyBTYWx0ZWRfX0JnYdVFWFNhu
 7xorpJ09tzq9oqfbRbgy1ylgwW2cfix/VezEjaX8Ch+oSN5lEKPfHclcGgydcnKDIS2t2FtvHib
 UXCfJ+GLQ62bxIQEtG9XBTSqSyxvVxFCVFzA+zwYzO4UBWRtRjXuzChYwaWLCTNZDfxocGBDOa7
 fCWfFMZo/FHk0OwQsTTnhyL7w/yF1RS4ISH1r5p7tX+fxJQw5SrLEqbH4/mEgM/Hp/46aAFUyyE
 4dnVSsAK4+auEY8iR3qhcPAzxyZd+ONBqda6Sy+IkE+HWso1IE6XtqDPxi8Ja+AvsI/eEbZjsd8
 ruXRhHU0lWnESPLizWu8jwtdoj+YuyN1cbTswhJVUD5CyBJYlPXJLB6I30xsWw99u6ttRPd/q6c
 P1/YmvWgwqNS3pXgua9/pCD2KDm1lA==


Peter,

> Replace Stanley Chu with me and Chaotian in the maintainers field,
> since his email address is no longer active.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
