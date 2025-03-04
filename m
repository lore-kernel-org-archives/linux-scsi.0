Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA4217E8E2;
	Tue,  4 Mar 2025 02:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741055178; cv=fail; b=Mmb6bTphaBMZPIUiu18tjdIjqqTwCIBNZ6ycHiiWnDiohXV4EzhcyJQTga1dVu7ZC0tyja1HcAq8Up4ANNHVI36+JCSHYnrD+e/KaG3efg+me+MMqD95E0w7iYzMKiaLlmhEFJJpOfLuyCrU351LEvATbWVZoNO24L1aXoG0k/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741055178; c=relaxed/simple;
	bh=OftbPFvWkHf0jWqGvfQyz9JAtAqTrZf20yb3/fEzuNQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dNc34dzve1bYeyulnMfNsPq6h6voWUKmrJqApW8JWi3/t8/AacfUG8xrpkVLtTlArKbUVH6hKPbFnK3zD28TvYFJSp5BTVLLJSrhG+rY9FYEor81LNqQluYXRnlu8O7o/KlVY11DEvHkUymWb5t0Ybdwn3QXXzWPmmnsA9lX9Fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bmZEMUbp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S/HpgLlV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bmZEMUbp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S/HpgLlV"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241Mg5f013446;
	Tue, 4 Mar 2025 02:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qvaqHBCQHg/nqxyHDz
	jGAORTxgAcskj/OOafCK0Sp+4=; b=bmZEMUbpngFXjmmt4EisqKZs0tmhbFR9MO
	8cLHK6WWWjQ1wqQVN5ydgTLyak8OFz2bfC435Z1IcOAWCfQMVCDuc1CfhLRpyr3O
	cnZFlMPzAHk05jKorl7xQs8/9hkWXGqQr850CToAxIvFjJ1Na7WtSh1sOmftJNlM
	HjDCSo/C6I9y+CeFdznXpR0W8ZWyV/i8Nh7daMxl2/K1JmtQSBkboRMF8Ft6Oiyh
	LJ3HmTeYZcMwug0OwoFwsPWqhCeCEzHLK0jypzCPAGXqLVjisy5aAtVBtSWC35FO
	bIzHbXm0RfbgoE/kVqgVmoO+5kJ6TRORDSxE5drZDZedA3pOR+LA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453ub7424q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:26:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5240v0wt015712;
	Tue, 4 Mar 2025 02:26:08 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9j2tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:26:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bo1Y64n3HZF4g8ou0qsm+mK+4jeXyoQLKAQGss423QVHi+SNw7vpnMuLkOgw0m3iYB3ndwKjUtbOZGCDlUDR9ciigrG1bWiT1U8ViTG1beYQk1kCWsRbrQufjfNS7xDvsdEFvnYjT22jPfOqFVkdOBGLEG1cSeQQIyn6N8SgiH0H4ISOkMEFfz0rOm/E9er7YydkIIA4Yg71APYtL8/o+jJn5dPUyrXwMdbJR2VxuVHpmIBvh8MWpcutajDBdqFBuYSplinwMDVmrm8mTZdBFPFZAZRyEoJCEwbBwlQJCrigzQLt7X6Q40MOIdnfbXmnV4r2K9Yp14XWbTaVej2MNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvaqHBCQHg/nqxyHDzjGAORTxgAcskj/OOafCK0Sp+4=;
 b=QEDFi33c4YkFw6yvoOxUWw+e2mW9xhn6N9wTKDxYEKOOjR28yh1wdPgeXRi3dn88v+66KyO1ZWla5v++1z5GizX8mmiHavqIuJ0H4D/c9n9rQAFLQQauAFR8tbeM1+MiHJTudwCmOhlPzG/Q4IZj4qjxxNa7up3WWTb78bgMdv2N4kFKXrwl/kdKaBoGeZfymQ2mJIBFTm1J5h+pZDvn5wXUY3zoyAKrMd9whlqrA98yLKGYHkwTJpFsqEVcjQc/ohEaHKmqix0PJ8bVUYrf0wiHIIRD07QhOdQFnhIboykepsGdqwonaO8eoRDRFlQLf7/+tE0pit8M/KuXdjhSiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvaqHBCQHg/nqxyHDzjGAORTxgAcskj/OOafCK0Sp+4=;
 b=S/HpgLlVrRakaGfXbBM8ThAfhGjEwR+sJpqNpuQIyCNjArslf1RGBS6D/TZX+QIUBrTvLYObgxCDwzDwLQGlZB5sjm5E4CSohr/KAW2Sshg+ytPh8W28sN23MUnxcx89ZMO+IfCazYcV4TuMjQjy4E3MMk3pLiXHUAiY39rSt+s=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7258.namprd10.prod.outlook.com (2603:10b6:610:124::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Tue, 4 Mar
 2025 02:26:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:26:04 +0000
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        heiko@sntech.de, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Abaci
 Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] scsi: ufs: rockchip: Simplify bool conversion
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250226021157.77934-1-jiapeng.chong@linux.alibaba.com> (Jiapeng
	Chong's message of "Wed, 26 Feb 2025 10:11:57 +0800")
Organization: Oracle Corporation
Message-ID: <yq1wmd5ttu3.fsf@ca-mkp.ca.oracle.com>
References: <20250226021157.77934-1-jiapeng.chong@linux.alibaba.com>
Date: Mon, 03 Mar 2025 21:26:02 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0053.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7258:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b8d1ea-6dc6-4cc8-aa63-08dd5ac3e9e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xsOdguB75Cx4C7/jhJqdRq6adTyf43IpTpucYlLQ+VUxBBtnOXL7c0x8XmMg?=
 =?us-ascii?Q?tTP7gdft19F2e3oX5JJIs04SK7TiYQe69gFZhawajjrGlDvQxg5Xsxso9plE?=
 =?us-ascii?Q?fCLYg2R8rznyGsfPbj0epP8M3pDVQcN2pwgSQsENNMThLNO2fV1KmBtacu3o?=
 =?us-ascii?Q?f8Y3IIKCmhfDiR47Dk8WSyc3Ic051xbj9qpbG4M5oqevXtrIWC43tOdDzGYl?=
 =?us-ascii?Q?BN/eFeECfEFGbS0qzOSBmMO0bLAm0rTqrmRQRhqaH75zESX23ZKNd2wwzVSu?=
 =?us-ascii?Q?QOG+0CuYk/ut0+3tyT0gnty5jUc4T15NatBT4aymVVMExgN56I82oP2tHJv+?=
 =?us-ascii?Q?Bml48CMNZ4/5ZtQWMXvgTFNhoO6/XujzO+ocThBvEm8fl565mT5JtGNU9UVK?=
 =?us-ascii?Q?4vuIO8JNFPs/AlwWNyHG7O2YtjvHTOZ7zuSR7laIZMyT7m/dGZaMf/KvVMxW?=
 =?us-ascii?Q?hnWpD4NZ3V6/MW5bNTwwwDrunUCWk0CSPcq3GKApHsvsvKwVEz6iXNISXZwf?=
 =?us-ascii?Q?WokIK6N5fhR/zs6hGbQtOPc4h7c9IAEGdz/jPCj9TO27+DLTp6rc3yl5uqQS?=
 =?us-ascii?Q?GjOLvJ7PYHdbbhPutkGokN2Bvnmot7qAQ9idJ4LV0UB9FZkhy4IpzTFHI99N?=
 =?us-ascii?Q?enu57gKcrACR2HObl48+eAjqD8OWkfZghhp3Waz6v/nXwYKRvYZJUEYks5GA?=
 =?us-ascii?Q?G/o0xt5V1YawTOJ8sF+MVULoAEZRISV+BkxPztlolKKDWt6nUPadES7NCspv?=
 =?us-ascii?Q?sjstlB1Qtj72qOKv9jMHIEOmj1UQdpjSXvFnN+3HxgOZH1wjUqW7o0CJ91BT?=
 =?us-ascii?Q?sGHv75FUSyF+BT769nbXUH0GtMigUWOd0xz/eseBE5PaBmmJn6MS42vjBlWo?=
 =?us-ascii?Q?a5CFMN5YjwnoboHu2KdNZTUgNKNDkuqgMmw24qQ01PWaLd8AAEMErUsIUolZ?=
 =?us-ascii?Q?0w5MsvfQ1j4amKmiOHoT9tHLljsaI2jEd/sWTVpCZ78hxBaktjzMbQ6SPKT6?=
 =?us-ascii?Q?VhGllj3DUbJvAJ6chSIB2isOG1WDa25+xWwJdNzfN69A35bOC3Tn+6XGRUDt?=
 =?us-ascii?Q?bSbg/VpzyBiaLFNwCN14+ERDH09jCPKqwscdp99y8koMGk7zfY8jgXP4iIgW?=
 =?us-ascii?Q?0yWOOdz9cakmJMPmM7+g5Jr662Cf5w0ETGzvpWOD9K7BLQkKxzSjZG+LAkCH?=
 =?us-ascii?Q?SDhR1UU7ruObM6V6QIc0vhpHGQkTyBHilNYMJRUhDaTxIM5QQJmEjHaJqvEL?=
 =?us-ascii?Q?YIyCpqE21BtpUcqjn2zNCFdxMNfj9ky4E7KMy+x3m+Khpz7V5qESpCvCO6U9?=
 =?us-ascii?Q?YOSWb1vJqow1DaResIzhmPYXnsdRmxi/5n5OOo2SKNkWhJd801o5YheTbfBE?=
 =?us-ascii?Q?H0UPbjBWq2+itdt7XOG9tEjxSqrQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hRjyOX+GNO8J5X9lOaP0ha8fXx7N2cZj2gx98KLck+hgbby1TqZj3lzpHh0H?=
 =?us-ascii?Q?1FudabZHlW6hicR+JMa4KJnbbVkH/Twy1QGWIq4BPZ13ZvMpJF/i75Dfjn7S?=
 =?us-ascii?Q?hfAmhVqoIE4tgEMFbH9FdyHbj4LuTYxbiVsGRCXSXcwDjas/BvZWR1ZJiW4y?=
 =?us-ascii?Q?7M3umvlCkiWbL77+/zl+2Ub2ioHpqcWWwGtMr/C6i/fcv7TgpP+b6/XxgxkH?=
 =?us-ascii?Q?pCj1NLISu0jHU0CczMDtKkaf/9fKS8CHJK5HJ+Jpe3ud4bkmPwZj7ElvtIHr?=
 =?us-ascii?Q?Gt4ORY3qzuHWxsKU5tgTZyOVtkmbbtPiVS166L8BCUN0DDHVbilV3BC3C7RC?=
 =?us-ascii?Q?Elw1YvIY5kdEOWDeuh5Slh/oA80o+GGW3sJZlfrJnVdzqjMuKRszZaHCn7zI?=
 =?us-ascii?Q?chEp4sNSId42qVfRt36VdbARSnE3dQxLSOMr8ZNoOQI+9AnbVbkq6YSbRxiP?=
 =?us-ascii?Q?t+DswfLl5k6BAcypxIKwCon/EXagITFt5ms/xSOvQY3QrlFKe6SKFlDAYs9z?=
 =?us-ascii?Q?j/LvoyOEq62sowHKya/GKrf8wNpTJjw4GwZHJcwT+VF7xPhZ+7s6FLvk8W+9?=
 =?us-ascii?Q?77PsEQ5i1/ZKdrYyf4Wf4N/MbHJM/X1LZVeer9Sj1EsRWwXcmQJ7iFiiuN7d?=
 =?us-ascii?Q?9nO0RKv8KiV9etWEWHf2ixp+QfwAlUNBVV0eiP9KfrT2DFKj+8HjzDmTDiL5?=
 =?us-ascii?Q?bb8Ngvjn2/cr+nBBiWpyAfNQdZQk3tqI0GqATpYh17ni26AozYmPht3FcPPd?=
 =?us-ascii?Q?2f+PVpCAFBOop0QLLWkNULgezMVMVLJ5GqqKLNomzS+HQneJ93x51OOv3xP9?=
 =?us-ascii?Q?hZ5eq7q8858tygbNeN1Bnf6mMYdxyG5+eZ1xOMfRYWDGcA/nHVWSNH3meWSD?=
 =?us-ascii?Q?lFOhhjxZPNVjMBwDVrSTx9cADmZ2dLCqT/8FWbO+zaKg+PjhURnUr5Q1sTiM?=
 =?us-ascii?Q?65pty3jn5G/T2Mh5NW8/D46lSmXHmqsfAieZwUnFZp05qSGIlK4Vonjv4nEL?=
 =?us-ascii?Q?a2hWhPIY6/p4JVrdci3dw8nx6YJNlsCBvVe2hNvYK+gQ/tGmNZcIiqJ4OjJS?=
 =?us-ascii?Q?mW+195q7oy8Da9Z2uQlP/cXObka2dARz76S8FW0CyPX9W9yd12+0KawtOKQ2?=
 =?us-ascii?Q?hLKYWv8MZ94AKXQs4Xmfji60P9czFF8uh9a+ah0snHN8M81SVZmORlJnHA0X?=
 =?us-ascii?Q?E7YvHRdke/nt7XrpjNK4xttYoudxHoAlM1cCkqMExee+NTasJBte1dXwdqEt?=
 =?us-ascii?Q?iC9ntXmpd4Ggbl9asQGYIVZ0QUXg98zC8G3UBsEKvxZjFSgS3je2t2bj8iPH?=
 =?us-ascii?Q?qVGxCDZeoMSkaKoDE60qgkeWysCvO72sadvJWqxqWf7hKj0DflQTmVtaEMxo?=
 =?us-ascii?Q?Q96ca/lJWrob0l3U63/cUl1E4wgeXnWKj9txNX0a8aTKl+iukswRNNiI639X?=
 =?us-ascii?Q?OAG9Csog0YX6WUE68hUBLTLrUXoSdM8GphQNidTYjCclWimMbr7OWYiEpOXv?=
 =?us-ascii?Q?dNqKvCTFuCe7J8+NsVgizqD4qsRZS1kRavCNXKoGwk/+xgRnlTCimY9I3SM/?=
 =?us-ascii?Q?x3r41BdiAX45hwResBTXrfBAnSnRwrkn/tdLlA+iLWt3o4GOjsLUB3KgPGvF?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8fOA87l4hHLGD54FaRB+nhoBJiJTU6sIATHKluz87CHcIp19huQbD7eyMN57AR7KplkzyPlYIT1Ib57GY9gk0RbHV4kb19gVRoWFitAfJwc7R0EZ1wI7rcTHd7tOy70RC/b34cqma673hE9DBywE3yyVJU+HtIAUS8y5OxCoq9neFXRz1t3vhzlH5WWHhPO1gSItk8yUuvfFaaAm5cyk2J6S4cRU1fAHKBmNFgzMlSfSoPvhxkXZWhhgiZiUsm6OwoL6oVqwffi89Ktm8SVEu8ApXeIZxWCvX3XuJlFHqGocdJsVb2Sy4Yy4MMs8rbVKDcbl+1xkaNkZ6iUftbOYcvPNsYHCiJ3hLvUbOP1BrPNBn2Ggh4y22RFybxg/ufGS2cA3ddeFiulrlIZCbwsQfQUK1hUKNwpi9bvlbQr+PxLrzUk7AKxfQNe6eBSq0upVMi+ccuGKB7tV7CQVvTrwTySFo/0imLkDwr6PHn2IDyf1UbLDi/Aw+vdKlaMsWsJ7YMt63lrAP0/OkvgBOMrkeqP96GLtJYRoSmrfeUzVj+LdKJ63SVB2Hpbdbfrr2uIY+0w6zttJBG+8Ma/j5542hHdBzBXHaXFghpwjTilgH20=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b8d1ea-6dc6-4cc8-aa63-08dd5ac3e9e6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:26:04.7966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mbEEiB/MzEiwSwvG4f9P+l56V5dMH+/aKyTgN9uC+TBLYTPDIMYP/ENs3tdAjthD73++vHdalaau39qAgMEBa6r/QJO5N+FNY+9urij2unQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7258
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=632 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040019
X-Proofpoint-GUID: kJp4QFQ7X9GlLvP8oiRvDQGJIlI9tfBv
X-Proofpoint-ORIG-GUID: kJp4QFQ7X9GlLvP8oiRvDQGJIlI9tfBv


Jiapeng,

> ./drivers/ufs/host/ufs-rockchip.c:268:70-75: WARNING: conversion to bool not needed here.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
