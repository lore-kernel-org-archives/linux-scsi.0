Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011383F4122;
	Fri,  3 Jul 2026 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783091949; cv=fail; b=jPxhGQKFbH5J2yhd9hN9prYHVCYhiceesy32Y/ZapCR7c6MPWRc0Y84hgF2II0F4nSwZ+286sbucn02kxaUkempaGYeFAtZ03ckcvl0QFSgBpPh3EtIY+z2a4L48z7VDaud7dV/GKrAhrevRwm4JoLED307WD4nbcGRn+z4OrSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783091949; c=relaxed/simple;
	bh=qQgPzv+qs3aYTifTw9BXpxA3A/pFKgIeShNEIHh5gg8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YWB8lsU8ByR54v/eGFIaHhMQ692G2EYJj0y+YwdPQFveMG1uzAB3cJBMgthlJxpHuYJ1gLdyIB1ri0IlMqe9squafEPw8cjiHd1P+1NgFELDh2HMuz46UWYyxhxzZjLwd9aRTnIVWJTfO3752jvVDbfxp0QDAXxHxcOlq7aAcaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RRYaCQ1s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hznz4TvL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RRYaCQ1s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hznz4TvL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 663Eckxt3627167;
	Fri, 3 Jul 2026 15:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EwGdl6RB1UESsFP6bX0JLVs8FW6dGbzMLLwBlBuBvSM=; b=
	RRYaCQ1sUcTGka4rJh4Guk28Heenq17tKWoSp8iycAehfuBqC7CMT+4M3Usg0R5O
	YEIpygQDdaCZT8+mQFRP1FUG70lScC2H6bt/sNpn6cJu7KDG2RO269nPb7iMDsMq
	WfE3SueAonKqBhJO84sarJujYWpaikokP58O0LuZ95oaZmXUnaPt3cE6P0j8buRZ
	tV64F3wVogy39Lj5CJAHQSmKOPy9ssYI7kyouT335bSS6PD9qiRmX+YcRynI8IE/
	8JCGYnfzDPETHbWx7gdglWvzkA3K0nCRl/vwSPxxlbv70lP68uMDKc4ig6sQ/dV3
	I89hntKmb3r19ZBXLJh9eA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qu0fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 15:19:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663FD57s034906;
	Fri, 3 Jul 2026 15:19:06 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012013.outbound.protection.outlook.com [40.107.200.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yjg823-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 15:19:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cgl6Tr+wJdRNmVHk+HT9Y9+5BiSfFFbHEsDyXNJorS8KX4bVdpQbD4lg4gmu3JKPwWjNJUtNs+Go25XtAM1hjdpcgEZTUEj6+JXMZ8/zemA8lHdoQ4AxAJMoJGlVpwfQ/xjz/c20HE6DQ5T+tkS2/eqES/8krYDkXPvrqIvPM4EfW6LBYOcov/TfZtDJhbj3AxQnZrij1OA0SOLpu+2dO9IpsvuZmgGazT7a4x2C1+iPhHnezdiA+2qCGfhXaXa/jEggEBC35UfoPvhJBLYeohQE+4F8E+zcgYd5OGyZHykDntNc4HcuyvZjiA8dSgQ6qQhhghtPpaw1bVrLN5aDZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwGdl6RB1UESsFP6bX0JLVs8FW6dGbzMLLwBlBuBvSM=;
 b=w7bNYG+YljYdOkm6uJlpqtErnS85ou9zsU6wvv4lAPFjp0MVqsigBFIWzDLUk0CBvGVlElK/vfREwQdQySCdHFSuZLsJurO95N4lmA5rrwYvPZ+1EQTxXNtUk9SdK/vJ1lixScF9/fo5mIzEq4KITINFm72uG9b4lGkDyYjVWLqbBw0P1h94Sp3HI795fl04HkbE7w4p/yHrqvLlCsoBtuVrN+9GUulwSGO0RB7hDzMilJTQnIikKW2gHbHurapLORCH8aUpFclcFaywdgTHPLjBp3aMtU5x06yrPD8O4ceS+pCA0VeIKunoVCNeojfq9YWK3qo+SCm9jm2hp/HyPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwGdl6RB1UESsFP6bX0JLVs8FW6dGbzMLLwBlBuBvSM=;
 b=Hznz4TvL3ueX9o90Ilr1iss5u/9FZanp/XWhC/cb9JH69B5hxp1OIwqaIk0wNboipGLPxFvUkf5sd51zLdFRFvq0Xi/oQwEAijIPGdXuthj+z3UmL59OgS0/mfekbTnU7p1dgEPkrs6Kn460JkavAOLn4QezTvhPF/B1rpDEelk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS0PR10MB7065.namprd10.prod.outlook.com (2603:10b6:8:143::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Fri, 3 Jul 2026 15:19:00 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 15:19:00 +0000
Message-ID: <e5719f31-ee75-4bb2-8a54-b676392bb075@oracle.com>
Date: Fri, 3 Jul 2026 16:18:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] libmultipath: Add delayed removal support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-7-john.g.garry@oracle.com>
 <20260703104506.9CF051F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703104506.9CF051F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS0PR10MB7065:EE_
X-MS-Office365-Filtering-Correlation-Id: 980938aa-be12-42a7-b99b-08ded91668e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	T1cVaenaEDOLxwXOWdNPlk+ILF694yjXu4m7rcqetryXDOOeegNr911ayn/LecYwSvZOh2mE6fb0ZU7eCyQ8KRcmkjXtUXy1vKVO8j+6cDWz0VgaWqLfIrFImHryU5711dyZP8ajCK9AFxqCdgC8r43+ukgXdhxSCtN4rhDPq31p38OV5lJ5PV4iTZxJb0epuG9+Gf4pNboc7CGI4YJfyLDHEogaSWY29qIpnCilag4u+iuk+HcaAqqjOMU30EPqI+yJzyws9u6enNDytUvBAKnzEfOiJuM6S0AStvZsiDfvxsMS0A8500ero28vPivtwrcareJeb6ZL7rqPXpIfSOsA+nAYC6OXSymk/Ov0WBD1f1xOiJRcf83fIT+moq39LUeGEpKbhcOnqsCjvjLNZ+GsYKchdrwZXtlkfey97owrfMThgPZnkck6QAkQFwwWnF1gFIpppI/7unmRf9fUrYOF/mtcEewu2mWpLSx11Uau/N1yloiU+SN8UMMigDMAMya4Qc10sL1aUz/5ic9qGP1uXCk2Fv7bHUewIaMXsFjsz4riJyfEcyYHCxr3VhBFX/9EAxQbjUsGaK4q806DYGPU+0idMRSwEG+AURRQSDg9nSL1WT8/zBR2D+LJ0o/b9H2fjSRhankAk4kgnCnxhzpdWKpXxI2bslyIlpK4iIo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0ZyQmFxT244elk3YVVrL3dQSU9lY1RXSVNSZTBnTnZOeXd3MFJaSnZodWhz?=
 =?utf-8?B?RDlRNGFTZXVtWFJyV01BdlZvSDNCZk9hcXQ4V3RlOTlSUUE3cG9DWUFmUUxp?=
 =?utf-8?B?SzFXOGdaZmtPVEdXUjFndkN0blpxK2thc21OZW1MbHZhSWhRRXRKUVVwdUdN?=
 =?utf-8?B?bkNBQnZlM2xVOC9EckRDU3BNSnBXQXowSHFnQ2dNMkMzOXZWb0dORGxaZDBr?=
 =?utf-8?B?eE10UU1saktlTk9naDBQQU5aRmRZckx0dVhqdno2WkNLczIwNGIxaWxIa1py?=
 =?utf-8?B?a1RueWtnbG9tdmtuOW9TZU8zSjEzeEwrb0x5eVc0bkhFTCtpWnNhTG00YzJM?=
 =?utf-8?B?MzlHaWxtbUJmdXBqZkdnOWovNk8yNHp4dzRvUTB5dmtzYzVUam5qTERFWGFx?=
 =?utf-8?B?UCtEWkZjNHpqOEN5SXpibWFxL0lXVjdsanZXZHZDU0xWMkQvMnFnTCt2YmE5?=
 =?utf-8?B?RW5PSUd5VTZZMmc0RDJtNHpiS0dpTVFuUTdTdEVPejhheTdJTTBaUVFucGpw?=
 =?utf-8?B?cm5tcGFFZFhHWlhFdzBGSjNXM3lUKzdWdFpINGZJSXBVelJKQjdWSUwrN3Rn?=
 =?utf-8?B?aUF5dVduK3RDVTRtdnJUSzJSWmRXUkN5RGt4aXh1R3RzTUoyRGNYYzdoR29K?=
 =?utf-8?B?SDEzeGthT0RCY1o5STRFMmd3V1hwRkFjdjBuanFNQXAxVlNzQ0h2MDdiSjRJ?=
 =?utf-8?B?QkJJOVFTMk9rd1NpZGlHQ0hicXhTbEQ4Rko0WVZIbzdKSng2V1RzdFBDV3pZ?=
 =?utf-8?B?em13VGh0K1R6TjZLekhxUnE2cEJRSXVzNk1nTlBxMDhTYmtoOURDeS8wUjR5?=
 =?utf-8?B?UGdOSlpXME9TeHUxandiRzR4dHFTZyt3RnhrVW5BNnN1YWJjQWw1ZWNMNkFz?=
 =?utf-8?B?SWptY295aDQrSzVpenB6dlhZMnl2QzJneDRYQlhsbDNIWGVhNjgzSGVia0VU?=
 =?utf-8?B?ZDRNVnY4K25DeENnYUh4dG9FejE0cjUwUXo2b280MDRMSCtLd3BBRndkUXpN?=
 =?utf-8?B?NmhYNDJWdEhLekFBb1dWc1BwWWREYzgvNCs5TnQ4L29TQlhma0FWbnhibWZB?=
 =?utf-8?B?WC9FZThLREVpUmpXQ2c2WWVaYmFsQWR5UHlLNlJtMUN1WDNpbGhDU29TSlBE?=
 =?utf-8?B?SDd2cW1yVGNBMzJaV3g1c2tSNzdOb1FjcDZqQ1VCWTVzOUpUTTlsaFJ6UVc2?=
 =?utf-8?B?ZG14amJ2REJwYWY1WkoydTRQSUJwdXIrT0RzTCtZaWdwM0thUnlwTTJlbVhr?=
 =?utf-8?B?UWNvNGZkVlYySzB4NVh6cHRZRVJGL3pJUytHcm1QaWVNNUxoekx0cXVYK25z?=
 =?utf-8?B?ZjVaVkowbTVlWHRDTkxaekVSV3dUbHlxaGdJT013ZlFwazNrNTRVd252T0Nm?=
 =?utf-8?B?SmMyUm5tWUl1eUpIcVgyWjBuKzI4VGszdW5nUTliRm1RWTduRGNqcXFIdkRO?=
 =?utf-8?B?VytwMENNdTVsUmpXUGsydDBmN3pNRmhGNEZQdmlwRklsV0pTdTMxSUJGcHBY?=
 =?utf-8?B?bkhRSFRYMkhrczZEMjhOUGlZWG1wTTR0bmJRSWp3eTFFMDFWSjNyMkQzbEsv?=
 =?utf-8?B?QzJ6Mzh5REhlNW9XUnREQlR2WStaODRYSDVLam5yTUFWbitUTjB0UjdlcjVw?=
 =?utf-8?B?aFdwU2JmbUdoMTByVk9OVjMweUI5QWJDU2daL3NaMkRhVnhGNHIrYWVydFMz?=
 =?utf-8?B?YisrOUNuMm12ZnE3Wm1nNFU2clJMMlNINkxzUlpqb3laYkkzTWdBYnRkaGV3?=
 =?utf-8?B?WERrSVZkT3dUMGhnY0JvUWRFV2ZyWERTZzBQMWsxWlV1M2hOMXFHMm9NL1Nv?=
 =?utf-8?B?cUtDeksyYkFvL0txOEp4QngzZDkwUS92V05KQURkUTlJRnA2SEVDQVpXd3N6?=
 =?utf-8?B?dWM2bEtXMW9HaWdXTGVuT296SVZsREVYakQxVTlJbzN1dXkzUGIwb01QZkVN?=
 =?utf-8?B?UVFMMGlTUXFZN2hGV0gxcGJYNURSdlo3VUZOaWhKTUdFUzNFVEJpdmxPVHYy?=
 =?utf-8?B?UGMyaEJab1E1VUd1VVN4cjdmS3M0L3UrSk90cjNSeGxhNFhwelplbkVEYzcz?=
 =?utf-8?B?dGIxVFZmeDNuS01IL2Z0MCtyN3RpWGYvTHVSY0J4dTk4M2tYRXVXdHRIUkNG?=
 =?utf-8?B?c0c2VE5sOGZDMXdNenBXMXd3ZGt2eXlxL2dSM1d1YXpBd01YOEJJVmFiYUEy?=
 =?utf-8?B?cWNnSGRRdk16V0xRaXIvSG94ZWJoSmRSendjL09ETzk5MHFCS0V4amQrc0J1?=
 =?utf-8?B?RjlqbEdGR1lVMGtBT21FSkRFYXRtMk0wUHJXdlFVbzVYdHkyNzJLUVJRay9u?=
 =?utf-8?B?Z3E4b2RkcldYd3VGazhwRVNsRW5TV21FdTk2cTNtbnU0bVdTOVp0Nm9hNG5o?=
 =?utf-8?Q?2CWFAKnmt1AhRwjo=3D?=
X-Exchange-RoutingPolicyChecked:
	WlTs02BdwOv02G0Wg8SC4SqizQQuE9fy5eXdDlRxgo3v+uSXxButMZpy9PwtPxg4wgCFHLX70q+524ZLefk60RfbpBaWDl6H88AliLpNXiCejiX1+v/Ul5WE62AiUZ1H/LCJcgBwo7yQKbXod9HwljI+QI/jcQkPB1LN/sHSOH+0hoSOL/8WDOePuSGgi+y7ktyj0irB2BASyxKHTLKTTZUHQRwrl8kvi450EYdwDqEDz1PA+M2+uz0y6w4SM4sC2bmb8hcK2UCoHFHdUQ/heHqJ0Ag8BCWJq4SMjLjf6icUZVB/t4i1M0mRlkcw+VLcZAWk5+3Wac+w7BxhYosN1Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ilH/jmwXkuxJlK8K8diTyHLnKcxas7XCpAQBDnb5fDyB1R2/ENqhqh3/YsOkhWuUiiHQYjrEUdAJN+66eno+nM3BPIZ27QSwigyk5Ynt1MF1F5fhi2M6LOa7db6TfUL7IwYcurKDxWxB1bL90/jbm5hfjSbX3F3sSAU7XbT4UMxlADgHDe4BE2yy9uGaLHWsM/I9FlH9VHH4u0OOEemUdt8E8UjmBfuLkKAIDUkjMyimLzTRDHe+SGu9IlleYgN7iv7UqXRKvDNrklsvjQZVh/u+6CuFXgCHi1sXthgXttPbuyv3JB7SGeBDenBnTRQde6fLnLwK+IBMtlEPeNTrIuJIY2mfROzc9j6WTbMwAcYzsZMKv7LJxUD4o6zH50GahsGHHZXazjRjo3fs+wFguGeJcSJDg+ltJsoEFhvSHjczqSgqEYnO1Iw5BnsgLVk1XjMWL0QiWb5dWLgp03Tvizl0TwQqmYQrzGLfAjJgViKHQ0nSpGPiIwIt7JePCcMdD9lGfbH03XaApXXbgsS5YJLXE9VQLWWUhUAt6ulgQU/pAFY4eYKEjTJRxoZLctJbj8E3bT/uA35/DwH9A2ATsOe77Uo6ygJmK8nDLeifDa8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 980938aa-be12-42a7-b99b-08ded91668e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:19:00.6699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9aQCrFxDWQgjDBKai3wtcKdl4RkA0tyNjFNLyckUbL7x7BaMMJj7ctzXTf2pwXjjOpfB4ZV5scSn3TSBlbZHfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7065
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030151
X-Proofpoint-ORIG-GUID: CWQol8yGhdwu97DmZYHPL5qbW782FAAB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDE1MSBTYWx0ZWRfX8PxNmiGycTAa
 8C1RpMRnASXyBba+ZoJ0sG5IiDIr6GhqFpjzz5esQxl9KyBYa8oovO1tMdNdUqDpq0py8WwTBqR
 ABK1c6ML81NEFRQQ6RrXrDVJJdTewGFPzn2cs1AA0XuFd4iO3YODOMP2Nn9mcx2wP8tsTLCbYX4
 eBqkZjThRGROb7xluT8gUtsEXZMGtm9phUeuhwGQO777LCyerkXLzLzIe8OvWjAZ6IJgw9kpsJp
 CnZpkxla9itB9ykEDsYK317L2wwJY5afFglbmdPRHWAXEcM0452kv1f8bh+KpOysVzvC2IfXn47
 c/pWsLH2uk8F4Mjmv4htw5ORrstYJ4lsXKHfHA9suhmUNdtuti/SlujOzcKu1FLp2o/wPTRQJ2v
 bu6Giqy0QDf3laKwWhGUwwWz0WlTwq+ruoUQF0BXCReggOGUQ/n1vKylwz5D9dlDguAZaQM18yT
 Hv7nTr6rUKLOf10FY3Q==
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a47d2eb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=7QI7hzK6KRG8weenO-gA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: CWQol8yGhdwu97DmZYHPL5qbW782FAAB
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDE1MSBTYWx0ZWRfX/6HjwCUCNf+H
 CJQvGnz3xJmEqOeFRU6LUcT0ClvQBk3JSQ2AMLVnXR47VGuaC71JkOq8GImmfFIPoVXUmANoBym
 EBSvLjtUahgvRB1X36M/rZuTSDhlmEMhu+lHNYxVVooo14tLrmh3

On 03/07/2026 11:45, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 7 potential issue(s) to consider:
> - [High] Repeated calls to `mpath_can_remove_head()` leak module references when removal work is already pending.
> - [High] Race condition between `mpath_add_device()`, `mpath_can_remove_head()`, and `mpath_remove_head_work()` leads to use-after-free of mpath_head.
> - [High] Missing cancellation of delayed removal work on `mpath_head` teardown results in Use-After-Free.
> - [High] `mpath_head->drv_module` is never initialized by the subsystem API, leading to a silent failure to pin the driver module.
> - [Medium] Disabling delayed removal via sysfs fails to cancel already pending removal work, leading to unexpected device removal.
> - [Low] Incompatible pointer type passed to `kstrtouint()` causes compiler warnings.
> - [Low] Integer overflow when calculating the delay for `mod_delayed_work()` results in severely shortened delays.
> --
> 
> commit c00bb95222f826ebc3e8dbd55ff6884abf84858e
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add delayed removal support
>      
> Add support for delayed removal, same as exists for NVMe.
>      
> The purpose of this feature is to keep the multipath disk and cdev present
> for intermittent periods of no available path.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 007aa34796569..78f88b0664c78 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -61,6 +61,8 @@ void mpath_add_device(struct mpath_device *mpath_device,
>>   	mutex_lock(&mpath_head->lock);
>>   	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>>   	mutex_unlock(&mpath_head->lock);
>> +	if (cancel_delayed_work(&mpath_head->remove_work))
>> +		module_put(mpath_head->drv_module);
>>   }
> 
> [Severity: High]
> Does this code introduce a use-after-free race condition?
> 
> If the delayed removal timer is already executing, cancel_delayed_work()
> returns false.
> 
> mpath_add_device() will successfully add the device, but the
> already-executing mpath_remove_head_work() unconditionally calls
> mpath_head->mpdt->remove_head() without checking for newly added devices.
> 
> Could the newly added device access the destroyed mpath_head?

Ensuring that new devices are not added while the head is being removed 
is the job of the driver.

In the NVMe mainline case, in the nvme_remove_head_work() will 
atomically ensure that no new devices appear and then decide to delete 
the head list entry reference (so no new devices can reference the same 
head)

> 
> [ ... ]
> 
>> @@ -518,6 +530,39 @@ static void mpath_requeue_work(struct work_struct *work)
>> +bool mpath_can_remove_head(struct mpath_head *mpath_head)
>> +{
>> +	bool remove = false;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	/*
>> +	 * Ensure that no one could remove this module while the head
>> +	 * remove work is pending.
>> +	 */
>> +	if (mpath_head_queue_if_no_path(mpath_head) &&
>> +		try_module_get(mpath_head->drv_module)) {
> 
> [Severity: High]
> Is mpath_head->drv_module initialized anywhere in the subsystem API?
> 
> If it remains uninitialized (e.g., NULL from zero-allocated structures),
> try_module_get(NULL) will silently succeed.
> 
> Could this lead to a failure to pin the driver module, potentially resulting
> in a crash if the module is unloaded while the timer is pending?

The driver needs to ensure that this is set.

It is hard to add a check, as if the driver is builtin then THIS_MODULE 
is NULL. Maybe that can be improved in the core code.

> 
>> +
>> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
>> +				mpath_head->delayed_removal_secs * HZ);
> 
> [Severity: High]
> Does this unconditionally increment the module reference count even when the
> timer is already pending?
> 
> If mpath_can_remove_head() is called multiple times, try_module_get()
> will increment the reference count on each call.

It should not be called multiple times. That is the job of the driver.

> 
> However, mod_delayed_work() merely modifies the existing timer. When the
> timer eventually fires, mpath_remove_head_work() calls module_put() only
> once, leaking the additional module references and preventing unloading.
> 
> [Severity: Low]
> Does this multiplication overflow on 32-bit systems?
> 
> mpath_head->delayed_removal_secs is an unsigned int, and HZ is typically
> an integer.
> 
> Could their product overflow 32-bit arithmetic before being promoted to
> unsigned long for mod_delayed_work(), leading to shortened delays?

I don't think that this is a problem. The delayed removal secs should 
not be so big as to overflow.

> 
>> +	} else {
>> +		remove = true;
>> +	}
>> +
>> +	mutex_unlock(&mpath_head->lock);
>> +	return remove;
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_can_remove_head);
>> +
>> +static void mpath_remove_head_work(struct work_struct *work)
>> +{
>> +	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
>> +			struct mpath_head, remove_work);
>> +	struct module *drv_module = mpath_head->drv_module;
>> +
>> +	mpath_head->mpdt->remove_head(mpath_head);
>> +	module_put(drv_module);
>> +}
> 
> [ ... ]
> 
>> @@ -562,6 +607,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
>>   	mpath_head->disk->private_data = mpath_head;
>>   	mpath_head->disk->fops = &mpath_ops;
>>   
>> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
>> +	mpath_head->delayed_removal_secs = 0;
>> +
>>   	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
> 
> [Severity: High]
> Is the delayed removal work reliably canceled during final teardown?
> 
> During explicit device teardown (like a driver unbind), functions like
> mpath_head_cleanup() are called to free resources.
> 
> Since this patch doesn't add a cancel_delayed_work_sync() call to the
> cleanup path, could an active timer fire after the mpath_head has been
> freed, leading to a use-after-free?

Hmmm ... I don't get it. When the delayed work is active, then only the 
delayed timer callback will remove the mpath_head

> 
> [ ... ]
> 
>> @@ -605,6 +653,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
>> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
>> +			const char *buf, size_t count)
>> +{
>> +	ssize_t ret;
>> +	int sec;
>> +
>> +	ret = kstrtouint(buf, 0, &sec);
> 
> [Severity: Low]
> Does passing an int pointer to kstrtouint() cause compiler warnings?
> 
> sec is declared as an int, but kstrtouint() strictly expects an unsigned
> int *.

ok, I'll make sec as an unsigned int

> 
> Could this cause an incompatible pointer type warning and potential undefined
> behavior on architectures with differing int/unsigned int layouts?
> 
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	mpath_head->delayed_removal_secs = sec;
>> +	if (sec)
>> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	else
>> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> 
> [Severity: Medium]
> Should the active timer be canceled when delayed removal is disabled?

unsetting MPATH_HEAD_QUEUE_IF_NO_PATH has that effect

> 
> When a user writes 0 to disable the feature, this code clears the flag but
> misses a call to cancel_delayed_work(&mpath_head->remove_work).
> 
> If the timer is already pending, will it continue to run and eventually
> destroy the head, contrary to the user's configuration?
> 
>> +	mutex_unlock(&mpath_head->lock);
> 

