Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EB223AE87;
	Mon,  8 Sep 2025 23:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373017; cv=fail; b=bvAfwhJlP8FyJCmThG0LeSB8thP0Drz4CDG+rzXHXR3LtMXsQQe6DjDzIEIgyUAFD8RwANx0F+jcVQkG8j4BL2WgvROYQsKAItmDX+MyFvynHAUHJw8in5w1qaQDP41oSmisyVNfUio5sJVcKBqoE3reyhKEvNsJPwClt7kWS38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373017; c=relaxed/simple;
	bh=ZgXJPpG/4WbaNP8nXfZ/GaAqVHbZEd5w/wArmrOxcy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XVp4lLxX2KW0mK/Zcl8vLhhbXGuyxMIVfDD0PvoVfqIEI44aiV0lcqk4z+HGfOeM8abud3zgalaqHFe9XSdDCa5sa1auinADRIyh7KtNopZUxDlQSYRY24U8paWhZS3wMwXY9EAyEaesQO3zbb9iEF+lvxZHqzY5pmDEOZNt+70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QurnDtZw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l3+qCWWR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QurnDtZw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l3+qCWWR"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LC5m3022254;
	Mon, 8 Sep 2025 23:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dOaLjKT+2J4xr9exiZ7iBOqp/VdQwVraUpWmU2IJKLI=; b=
	QurnDtZwh59LnCZWTcsYPc0cvYMWBO1xYh5eA9TEk3mMlpytZPllFX1I6p6wSRq4
	vmV620uQX0QixV3uNllP0KZ93/R54tyWump6+skhpaHKox0nSmxlXL56viJqWAja
	GDMBQmDGTtpxg2z0b5OPij4GWo5qmpyNXE3858IPgLQTsTqIf2hX7CKCvNd60QSe
	WURlZdPLA/DIad/dyJ8yiP3kTlRCa/WDxr7UxXzAr1ASxsxtiJkHViZXGtpCftHP
	Dua3wkprTTe0usJjG/cMlnTlfa+Dt0XQYbeY6/hlSTOChL5DJ2vax6JZGZ8+9sXv
	bZJiVkRv9DO72PVzRXHxQw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1guba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 23:10:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588KY5uI012878;
	Mon, 8 Sep 2025 23:10:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd924kp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 23:10:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IyPSagXcnLMloeiyMXbq1YaZ90lhVBmwxe78KCx84ziTyHP6HSj7NKS8h6Q9fisCILMFhYR8Vz/T05shTZccTmr5YpG4JyvFitAfgdaDopkRx9rc2YOLcd5CjATIZbv1HxX08i0bmHtWcqKwxeHW6ttPHoKT/G8SZ2hTndhD0kLkEdUs6BEf7xds88JBWM2U+rMm63MqIgrAufyVrt4sLvRlLC6r3wRvxW46KKysmgdCMJ26f62RsKuvpQlLPZ7RAxY2QVReMvUggimXLro3bNXD079IBM9ZQ2H9NvaiLb6uj7Qdv3PKu2y4fT9ufaaYcIp92KeCoeGQnFp42mX+fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOaLjKT+2J4xr9exiZ7iBOqp/VdQwVraUpWmU2IJKLI=;
 b=PZj3za+rx3EOUnxUQ0tFgd7VgEyMy+gh5TQfRpzzvmcKeTIMBCNyKD04gX76hyZpmFE3sdiIcUTVKrbjty2zaQjbZjpX8XvNoxu0/Kx8o9FTxEsWj1IyV4XY2TX9sMHoFcx8KCn8bheDsW8Y/87Lzl730qsLocATX7sVxsE+V5b3Zrq8gZnmBvr2TmRF8oDGAc9DIignFLhU6CuITQmpWc/DUD+VJZF2hDbLuN9LB8nvj9HX0uzR9Azz2j6B9qavoGPSzhbuu9VJDISzfHnkeMqG5oxJr8kockiHsMd74CuyQsowaWafUGJ7MSDZOxvYOtuesw9JTWHbeNE5nob6vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOaLjKT+2J4xr9exiZ7iBOqp/VdQwVraUpWmU2IJKLI=;
 b=l3+qCWWRImFkhhUI9bjnuzGqKdOOvthaseUXX/f2Br0Wd3rUa9vk+tOZA8KcpWyYTSz5+HA5R0ms6qHVcfxksWdSG7uI6jbeve5ySR5Or7UWE8SAj+S9uVX/1jVM2snAND5xpqlIAXuRIYS5nEkh2862lgPqFzBkMi2gdo1CrHA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA1PR10MB5971.namprd10.prod.outlook.com (2603:10b6:208:3ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:10:08 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 23:10:08 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 3/3] scsi: target: Move LUN stats to per CPU
Date: Mon,  8 Sep 2025 18:05:56 -0500
Message-ID: <20250908231000.10777-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250908231000.10777-1-michael.christie@oracle.com>
References: <20250908231000.10777-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::20) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA1PR10MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 40457b7b-c224-4b70-0251-08ddef2cda9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O+oYCtCrVJpVpORKtgJAHbwR9rvIYpyU/Dy7keOaIvZDhqjOugE8wOViJdiR?=
 =?us-ascii?Q?WZTFUWMqhq02LlivFz7PJY5Ox08IqwP5qkDHdTZq/SQxbfgGoJGKKBgeyWIY?=
 =?us-ascii?Q?KIaFCjqy5WBtFaudfwmQxZ2BOBxO+V5M75ApDDv+BTajjAk4lnEa9tcCP0Ms?=
 =?us-ascii?Q?8kV/9VrEWby9rWXtYOJdgU+zO5fS3NlTihFUY8slRrIjFB2qjVwTs54gv+nu?=
 =?us-ascii?Q?1+uNhjG9VLwE+oxGCxo/QH4Z1hANhAumJZuJFWuxMrxClthQVpZj2V4DNRmx?=
 =?us-ascii?Q?8xl8Wb99WRypNL2sRui5ybj76pfZ8mkb9l0D6A8FuHlg32PjhtpkCNB6Y8Uu?=
 =?us-ascii?Q?oHrhIoEC68X6oygtvLrMgQ14JVId1TT3kbFCud5kvfDFhR0/VXbyW83TMd48?=
 =?us-ascii?Q?xywz7JhySomixIz0X8xURuidkybi1eWZTRD1U3FPHT4IGM2YXLcLi6xSgwJj?=
 =?us-ascii?Q?ZSqrZrjfomSOsQ4GT/O/e2zANEEAqqeAQRrpGNcFxY2fLLe0yBwvHGYh9mHy?=
 =?us-ascii?Q?3IY0I7WLN0fc21sChTwFSQS7J2IFzvSdUGFjxjr5HTzoD6Af+69KReMTlb+F?=
 =?us-ascii?Q?88NPk0vswhQ2xn4FtHgf3CQ3WS3nJKkpj1mFDZt9pHsPyMzd8THypON8rw3w?=
 =?us-ascii?Q?78a5wBs7315Zk+LfHz92J2fQEBYuat1KaJPRNcna3nyUTwgnznwQn8mY2W3w?=
 =?us-ascii?Q?r14G9RiWt4i3t1duPWARF1vNtML5hBCDoUkM7tZMH9IZ+qbIS+ji/OcugA/b?=
 =?us-ascii?Q?NvMjzS/yROCfV0VatId0n10kHrrALT+RlzR2se7fjB1o4zEDHtx26fvlSt5S?=
 =?us-ascii?Q?REBcFkGGvw22wwVr8NlL5fV0B2Lp1BsV8y/9LHr7f2vxNNeFg8nSuvZWaP65?=
 =?us-ascii?Q?2MMry0AeuMlz9KxeePhHICL9rWZTD4nUaOkTJDXKm6zeUgLM+Aus6ZS/hAa6?=
 =?us-ascii?Q?qL+X/97cZPrKtOebGsctiibe1TvNbX2eO/a2pedtU8KYCJ5wY9L+XC8aIcVv?=
 =?us-ascii?Q?ZDePDBVQTpHww75SuqQtmYigEOP8uZYdznt4Fq2hGa8JsGrnw2AnaW93wmdR?=
 =?us-ascii?Q?zhljemD3flnCXNSlfGequqbQHt705uvCdj9cyxz19JpMyTBco/zXTWksyIUi?=
 =?us-ascii?Q?WIkaMfrhNqwa4jIvHnNroeBZwIkPIRwmjO/Q+Vm2z3Pb4juqikhM/mhv85n7?=
 =?us-ascii?Q?qbYZpT32Y1MuOit1/50+gwLEqBEacr81ZcYjAHRUoupPTZcOHYd90/vv/qXU?=
 =?us-ascii?Q?Cbi/OqC0FzdwXqoDe11ZKIUElhR0HRDml1LBrZ8a0+bCDNf4wBMU89o44mNk?=
 =?us-ascii?Q?ZMX6bg2K0uFJ07tJUAZ3o/P2+aAVAfigiVUVUwxNx9vWbR3dDMr5KNPvXUBE?=
 =?us-ascii?Q?JfDoWqPJtZ8+WkiSukscvSEW19WqmrBIihZZG3iy9poGiCSfNrwyUCNKn1l1?=
 =?us-ascii?Q?aJiU0U18YLU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E873ntGE//iQbojMT8aoUl+QgJLInLoKRJ5PpmuXMn5eCkV5DRfhwoBtYV6l?=
 =?us-ascii?Q?ppaCmmji1AoZd7pZN5P9Zb+vPPbk93aSyPs+bb2Dcr6eM+DMe+KUCGNBTlN9?=
 =?us-ascii?Q?eSffmg3A5fnuPLVWYJx7IVriw7gGgeIivZ6RmxWk/LECUmaxjxRVG9s4Ooq3?=
 =?us-ascii?Q?uBSGzVql17LBFo5Gkt5vwNZCiQFFgs5BSCQ0cPaOEv0h20EJnCez7dw5DsAv?=
 =?us-ascii?Q?jGTkIDQhtJEy5PbmnyP70saaGlMnc2hpmsiHWFmfeOJxvTrEzUQYsJxog9oI?=
 =?us-ascii?Q?YRQlPEObZPa538Ak802EsaSrfA+NY3yjsb6eE4ijbUaJJ06NeNO4jyHIRw9/?=
 =?us-ascii?Q?mmH1eSpjrsLHzCk+dJQIFaBqA/Y5G+11xB2ku0LethiURd/VURO2A3GJQo6B?=
 =?us-ascii?Q?zgp4Kf+h+ZWw10mZdppX48IiRRURK29M5pVgDiDe5yBOTzOiAYYvZjM+KF9e?=
 =?us-ascii?Q?H2Uscl5IXuXuRdp9nXScEN8mfQ12V3i96IrstChxmWlxklVtctMzuYCF+0XC?=
 =?us-ascii?Q?FAgoMF8V0761B3Gl0z5292B3lV2ekVynjW0SHzwc4/i5tfNS68DPltkfKCun?=
 =?us-ascii?Q?KLfh0elIYI0MYkCXnAfVMS+ISLemGCHEmL3xgdUWjTxrraQd4zyWvfGKoA5f?=
 =?us-ascii?Q?Rv7A9KYUehNcMyZCYmUDkZJyyYbACjyCRBsbqcU8JmiKhd7DL+pr6ZY02BOY?=
 =?us-ascii?Q?3FGmQCZf0b7ChchfW3GE7q2zlFpJOEnHtgSm981za9NR2ircvui+mqcqdyeJ?=
 =?us-ascii?Q?7ULvpevnp9TspyPdCcqR7YOtFjcgdxkGA5sppGHJdcSm4nZgn96WiO3F4mMw?=
 =?us-ascii?Q?bDFiwqI+oRkpUoJOEPpeEj3QGJMJzgNvf3vwz5BkUlWcpDxMgnQ+dB6vYxM/?=
 =?us-ascii?Q?KXFy7fhHkp4lhPvb2kZZWgLG6olrv+KD80+Hz44LbreOQV0iJm6ZVwgMAJa6?=
 =?us-ascii?Q?AvcK/zY1BZwf+DGWBUPEgdiaChtwLf5BTa01Ev7dHxsvoaIA+4XEHhKYJ5Ej?=
 =?us-ascii?Q?k+w3fn12B39uIv6yx1Ko0QIpHoo4tmAOAfNozfTjBF6fOnZAoHmBIcbuTvwX?=
 =?us-ascii?Q?aCsK0loXGVmE69BuLUbSAA+uyPcyHkhEcM7JtR+kA/vr39G57bU6rQdVvrN6?=
 =?us-ascii?Q?IQT6WhCA/yJdfSEbjo+OEQYRL92eX5vq4Cyey3yI4zWYruiNas15M27l7zXM?=
 =?us-ascii?Q?AiN7E3ghQd49LyoxkOZ1q40p8xni3ZuZM+fpZx8KjN4SU1PC9x4DJ3BhLaLo?=
 =?us-ascii?Q?9QV8MFGXARfkqEPsdrwPWWWmZ/8qKmxrjr2/W6qEaFCE5K86ME6uL94ixr8L?=
 =?us-ascii?Q?PAvY6Z+y6wFi5Bsel6c+Ujc6VHHkBeh4uSzbrKN0zXSBcsxHU/CjrOjTmmIu?=
 =?us-ascii?Q?M7/nBI9Cnsx/ZMn0lgqGa2nxd/NI32ReHKhQkYPYjFGoOlb43d21SaxpcIgf?=
 =?us-ascii?Q?R7UtCYA/frJfas5v7XCi4LU2EXVBKWAabRYmHyNAEMEEUtH0SQSu9ZwAc/v3?=
 =?us-ascii?Q?2GBQsbCvQr2CyT1bYqkNcOelAJcXQNnhpmUeEVSeRspa8xAwLH1kOHQa+Cxp?=
 =?us-ascii?Q?UfrluL2853Dcu1s8Q9p1VcBT9s+aMjwAn7PYB3tQoU4vA+M3muhTrrcWuDhZ?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MFcUp2V48C98adeC1S618m7q5otvgMYr4IbdT2YtRjvJ5YF8XVj73DZATZ6AuEW84o1QzX0GQBuzJrVAY5CXb9KQfILZ8GANWxpt+Jkq7pshKqIzmtlLPNp+P6vyXFWPjxQX8hp5vW/Q9dIql7FyGVeOf1M8Pnovq0HKuJBI+A5TeOmtS+f498oiz185hJ6klFCm88s3fWRXF6ahFBTJXNfVd2o9TdFg/ArZxp9+tmBA8jHdBIDZ8rwOgDMrLDo84VpvXjHX3WsbjWMMjj8HnunlpEY1l6xzWHhIu6dQnQn0mYpHklO4gOEPg0ZQye4GVN+ATTNpmD8YBLFeeQQjcGShJTjagIgb+I8otcOzWC4KxkuAkh9eMjGbvsPSmjUzT4XLk0UgTFbdXTAByXyT2kjzSX94lhOFTiJidpH+Qh0koTNPbb/8FK5VAAjh6z7xtmvP5Xmazev01FCRQMe/gLfQwf2tIjZO/oKMIKGriWg5mcRtaQghsz3yBAx+1rpILUTKsvGGchWHlCfPxTQv/lrb2ZYE6jbo2uPmB/CTMW+MnVvgfh6hFfDj5xMhRg3neOSvEWi6IWA88UA7MZHPFYtcFSHg7Prh5dhiraayZAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40457b7b-c224-4b70-0251-08ddef2cda9f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:10:08.4343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knIm6nf9i23wRuHSWKB/YpNEc1JrIymXYKZjqF1CkwhlqxDSljZBz8kyyEtm8iQCq1RAKUDYApjqIAxEpcr/pWDPgWwE3R2klTyIOXKN3Hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5971
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080228
X-Proofpoint-ORIG-GUID: tMyYwfk0efAV88yVTsHOVRefXmK_pc6v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfXw6VnrtdKsnGf
 uhgSjY5FiCdJJN3W8HLoXt6uofza6HkiGl7Q3Y95Odm3sG9XwW2sSLD5Fi4/wZLmdrVJ35knFEH
 IpNY7IMFW2APzpiEzG5O3OxjS3zxR0+JNuIvx3rm32/IoI/3WuC42WKxDtfJU+9gg81+02zwoYK
 geexspQlLL9UdNePbrMUY1lxk4Z3eoQf0UUpkao8Sg3OzuDIQbH2lFyVdFEoJf+DJK8oDV394pw
 FdIiD6RutLmgE2I/0Ge8xUyc5uLkanlxLsT2YeO11ShPvS7zJ0myZ2TM1PtH1cfVuEcKu572Uqj
 v/8uBNkD8b0PxhMmkhfBXwfEtw4eqVobtPoAzyzqEeExhEubRU/xP5I+94AogW6GzoFfYndLCO0
 pzgYUnZI
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68bf6252 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=OOAKvqf1tipb_53jp7oA:9
X-Proofpoint-GUID: tMyYwfk0efAV88yVTsHOVRefXmK_pc6v

The atomic use in the main I/O path is causing perf issues when using
higher performance backend devices and multiple queues (more than
10 when using vhost-scsi) like with this fio workload:

[global]
bs=4K
iodepth=128
direct=1
ioengine=libaio
group_reporting
time_based
runtime=120
name=standard-iops
rw=randread
numjobs=16
cpus_allowed=0-15

To fix this issue, this moves the LUN stats to per CPU.

Note: I forgot to include this patch with the delayed/ordered per CPU
tracking and per device/device entry per CPU stats. With this patch you
get the full 33% improvements when using fast backends, multiple queues
and multiple IO submiters.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c          |  1 +
 drivers/target/target_core_fabric_configfs.c |  2 +-
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_stat.c            | 67 +++++++-------------
 drivers/target/target_core_tpg.c             | 25 +++++++-
 drivers/target/target_core_transport.c       | 22 +++++--
 include/target/target_core_base.h            |  8 +--
 7 files changed, 67 insertions(+), 59 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7bb711b24c0d..2d4a7c0c69ce 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -814,6 +814,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_SUBMIT;
 
+	/* Skip allocating lun_stats since we can't export them. */
 	xcopy_lun = &dev->xcopy_lun;
 	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
 	init_completion(&xcopy_lun->lun_shutdown_comp);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7156a4dc1ca7..13159928e365 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -697,7 +697,7 @@ static void target_fabric_port_release(struct config_item *item)
 	struct se_lun *lun = container_of(to_config_group(item),
 					  struct se_lun, lun_group);
 
-	kfree_rcu(lun, rcu_head);
+	call_rcu(&lun->rcu_head, target_tpg_free_lun);
 }
 
 static struct configfs_item_operations target_fabric_port_item_ops = {
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 20aab1f50565..763e6d26e187 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -125,6 +125,7 @@ void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *,
 				  struct se_lun *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u64);
+void	target_tpg_free_lun(struct rcu_head *head);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		bool, struct se_device *);
 void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index e29d43dacaf7..083205052be2 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -606,53 +606,30 @@ static ssize_t target_stat_tgt_port_port_index_show(struct config_item *item,
 	return ret;
 }
 
-static ssize_t target_stat_tgt_port_in_cmds_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun *lun = to_stat_tgt_port(item);
-	struct se_device *dev;
-	ssize_t ret = -ENODEV;
-
-	rcu_read_lock();
-	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%lu\n",
-			       atomic_long_read(&lun->lun_stats.cmd_pdus));
-	rcu_read_unlock();
-	return ret;
-}
-
-static ssize_t target_stat_tgt_port_write_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun *lun = to_stat_tgt_port(item);
-	struct se_device *dev;
-	ssize_t ret = -ENODEV;
-
-	rcu_read_lock();
-	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(atomic_long_read(&lun->lun_stats.rx_data_octets) >> 20));
-	rcu_read_unlock();
-	return ret;
+#define tgt_port_show_per_cpu_stat(prefix, field, shift)		\
+per_cpu_stat_snprintf(scsi_port_stats, prefix, field, shift);		\
+static ssize_t								\
+target_stat_##prefix##_show(struct config_item *item, char *page)	\
+{									\
+	struct se_lun *lun = to_stat_tgt_port(item);			\
+	struct se_device *dev;						\
+	int ret;							\
+									\
+	rcu_read_lock();						\
+	dev = rcu_dereference(lun->lun_se_dev);				\
+	if (!dev) {							\
+		rcu_read_unlock();					\
+		return -ENODEV;						\
+	}								\
+									\
+	ret = per_cpu_stat_##prefix##_snprintf(lun->lun_stats, page);	\
+	rcu_read_unlock();						\
+	return ret;							\
 }
 
-static ssize_t target_stat_tgt_port_read_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun *lun = to_stat_tgt_port(item);
-	struct se_device *dev;
-	ssize_t ret = -ENODEV;
-
-	rcu_read_lock();
-	dev = rcu_dereference(lun->lun_se_dev);
-	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n",
-				(u32)(atomic_long_read(&lun->lun_stats.tx_data_octets) >> 20));
-	rcu_read_unlock();
-	return ret;
-}
+tgt_port_show_per_cpu_stat(tgt_port_in_cmds, cmd_pdus, 0);
+tgt_port_show_per_cpu_stat(tgt_port_write_mbytes, rx_data_octets, 20);
+tgt_port_show_per_cpu_stat(tgt_port_read_mbytes, tx_data_octets, 20);
 
 static ssize_t target_stat_tgt_port_hs_in_cmds_show(struct config_item *item,
 		char *page)
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c0e429e5ef31..540ff15882c9 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -548,7 +548,7 @@ int core_tpg_register(
 		ret = core_tpg_add_lun(se_tpg, se_tpg->tpg_virt_lun0,
 				true, g_lun0_dev);
 		if (ret < 0) {
-			kfree(se_tpg->tpg_virt_lun0);
+			target_tpg_free_lun(&se_tpg->tpg_virt_lun0->rcu_head);
 			return ret;
 		}
 	}
@@ -595,7 +595,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 
 	if (se_tpg->proto_id >= 0) {
 		core_tpg_remove_lun(se_tpg, se_tpg->tpg_virt_lun0);
-		kfree_rcu(se_tpg->tpg_virt_lun0, rcu_head);
+		call_rcu(&se_tpg->tpg_virt_lun0->rcu_head, target_tpg_free_lun);
 	}
 
 	target_tpg_deregister_rtpi(se_tpg);
@@ -609,12 +609,21 @@ struct se_lun *core_tpg_alloc_lun(
 	u64 unpacked_lun)
 {
 	struct se_lun *lun;
+	int ret;
 
 	lun = kzalloc(sizeof(*lun), GFP_KERNEL);
 	if (!lun) {
 		pr_err("Unable to allocate se_lun memory\n");
 		return ERR_PTR(-ENOMEM);
 	}
+
+	lun->lun_stats = alloc_percpu(struct scsi_port_stats);
+	if (!lun->lun_stats) {
+		pr_err("Unable to allocate se_lun stats memory\n");
+		ret = -ENOMEM;
+		goto free_lun;
+	}
+
 	lun->unpacked_lun = unpacked_lun;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
@@ -628,6 +637,18 @@ struct se_lun *core_tpg_alloc_lun(
 	lun->lun_tpg = tpg;
 
 	return lun;
+
+free_lun:
+	kfree(lun);
+	return ERR_PTR(-ENOMEM);
+}
+
+void target_tpg_free_lun(struct rcu_head *head)
+{
+	struct se_lun *lun = container_of(head, struct se_lun, rcu_head);
+
+	free_percpu(lun->lun_stats);
+	kfree(lun);
 }
 
 int core_tpg_add_lun(
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0a76bdfe5528..fca9b44288bc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1571,7 +1571,12 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
 		return ret;
 
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
+	/*
+	 * If this is the xcopy_lun then we won't have lun_stats since we
+	 * can't export them.
+	 */
+	if (cmd->se_lun->lun_stats)
+		this_cpu_inc(cmd->se_lun->lun_stats->cmd_pdus);
 	return 0;
 }
 EXPORT_SYMBOL(target_cmd_parse_cdb);
@@ -2597,8 +2602,9 @@ static void target_complete_ok_work(struct work_struct *work)
 		    !(cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL))
 			goto queue_status;
 
-		atomic_long_add(cmd->data_length,
-				&cmd->se_lun->lun_stats.tx_data_octets);
+		if (cmd->se_lun->lun_stats)
+			this_cpu_add(cmd->se_lun->lun_stats->tx_data_octets,
+				     cmd->data_length);
 		/*
 		 * Perform READ_STRIP of PI using software emulation when
 		 * backend had PI enabled, if the transport will not be
@@ -2621,14 +2627,16 @@ static void target_complete_ok_work(struct work_struct *work)
 			goto queue_full;
 		break;
 	case DMA_TO_DEVICE:
-		atomic_long_add(cmd->data_length,
-				&cmd->se_lun->lun_stats.rx_data_octets);
+		if (cmd->se_lun->lun_stats)
+			this_cpu_add(cmd->se_lun->lun_stats->rx_data_octets,
+				     cmd->data_length);
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
 		if (cmd->se_cmd_flags & SCF_BIDI) {
-			atomic_long_add(cmd->data_length,
-					&cmd->se_lun->lun_stats.tx_data_octets);
+			if (cmd->se_lun->lun_stats)
+				this_cpu_add(cmd->se_lun->lun_stats->tx_data_octets,
+					     cmd->data_length);
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret)
 				goto queue_full;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 27e1f9d5f0c6..372da2eadf54 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -744,9 +744,9 @@ struct se_port_stat_grps {
 };
 
 struct scsi_port_stats {
-	atomic_long_t	cmd_pdus;
-	atomic_long_t	tx_data_octets;
-	atomic_long_t	rx_data_octets;
+	u64			cmd_pdus;
+	u64			tx_data_octets;
+	u64			rx_data_octets;
 };
 
 struct se_lun {
@@ -773,7 +773,7 @@ struct se_lun {
 	spinlock_t		lun_tg_pt_gp_lock;
 
 	struct se_portal_group	*lun_tpg;
-	struct scsi_port_stats	lun_stats;
+	struct scsi_port_stats	__percpu *lun_stats;
 	struct config_group	lun_group;
 	struct se_port_stat_grps port_stat_grps;
 	struct completion	lun_shutdown_comp;
-- 
2.43.0

