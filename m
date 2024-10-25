Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D25018BBBB;
	Fri, 25 Oct 2024 18:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729881952; cv=fail; b=tQr6yNpoP/HG+C09RTv/Iw/y6azjf7ah81IaQ14aJ2IasPrJo9wzVvShb0cH0B1TJouaezM9JoCr6mv4Xd0EHm4usqD55af5XdVlX7YDlOZi7x1dgVHFFuwSbBraAyqquwL6mCcalV6WVZfOuNO/LPG9Q372Ru+/fCero3DwoNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729881952; c=relaxed/simple;
	bh=FF5IQL/E//U0UaGvXEvfkaoGZayzBCE9MCJd67yBcpk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Etu7ofbUlMHFKynBuo0iDvja1Kh4ASDd0XxMmaQu/WZ74BI3CFNzimjvC5tEE8hT97i//d7l3Aru0wWn2t9xBIkBSmfefdOkvpgWTkCiQkvOk4E1b+85GedlRxoqYkIJb2qNwKW7qNypfULvu8+gfvfHpT2lj+QajGdCxjV14a4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=npluQWIB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fHHCs2xy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="npluQWIB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fHHCs2xy"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PG0ZFh029551;
	Fri, 25 Oct 2024 18:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=cXbJHjTS6Dza/THUbM
	yfGBJrOM3ma6iQ+VOYNHMzOxE=; b=npluQWIBkP2mNYtCfG+I/pB+ZURfHDSmvf
	m7O1AIbWX1whX+enICCbs9tFTnNay3ZtZ+TVL3uvCgsnB6EDzqkuXjtfTOqQ5LPw
	UfQTg+fnn8y2YeF7i4CJ6b3TAANk9z2DVuFW8dEvgUf6jf1pfr1hzUEeUltaKN5m
	bfKvivAFF0A2eWz5FeIyS5o8otQe3xFLlHFMmlCiHcZpab97Zx30CWG6fbPVE/Ed
	/l6lCZuWW4Y59AWOjxA4LgOF7/YiGE+nBdMRANUcDBOFBhTz9zaPw7BrdhQJZMF7
	RCIcnJDHrVIO2KA8QHc88LBa0m+PydnW3tuac011ozGBA1T1olog==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c53uwnjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 18:45:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PHakMJ039116;
	Fri, 25 Oct 2024 18:45:40 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42emh63v36-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 18:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V3Cj28MAeR4NQRphF+26PccQqgfNHtZfe8SSrLX/ZuugKiWB0Ijr7xTcmw2mnp3BS1326lPeCLgAK66FsGNW9HglZ++ic2nxsBQaqDZZoLhInjANhjVQmd/1FMSFYfcsBkdyAuDh17C6CfYkUTKAAv94PElaLthUJcaXqfMPYQbLq/Dcb0+1N7g5XluUcBghn3k5HSKCzltSwi6of3S6X00uvK4WX4tyEkPh4fopUIj5X83+CmRIf7W9szxiCjTFKW3CP/qE00w60cbaG9yd3LvrmXSM4hLzevkZ4ziljSmSHK7q6a9NH7Y77hbbqFS4C4jIDeOpdpg2WfL/x3+4dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXbJHjTS6Dza/THUbMyfGBJrOM3ma6iQ+VOYNHMzOxE=;
 b=t6LGeW/lTTUzdJofLTwu5s6Xxa/1ODOXbE9RnXYV9Q2xOIhlcjGiOxVSO7eK9Y12+NSjbjCJ2inqaAnMSjYqPHR2KDm71FDdlWqiFuP/XiuqXA7ubKoCii4LfHo7BclCcu8JXHAmzuBwSlZwNUx+iz/xaAA2VHC0j4Ynahotl5zxPPGCkZy1EPvXAXGOl9ndyaV503uQqLfcmcLRG5ur4OaA25C3NVCqtOJMsFuaJ8K7TtR5PyoD+R3ab9WJzfuhmqSEtKKDAxLeJnCBPVtnT69d+Sz09nyZDXAN0kcfmVoNGJMR5rbccQYqsFVvATZPXDdWAYUFVeRkr3bkSp8d/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXbJHjTS6Dza/THUbMyfGBJrOM3ma6iQ+VOYNHMzOxE=;
 b=fHHCs2xyrELP3RReDfjL9tul4WOHiooEyCVdJzKM+UGtkB5WdYpj2Q366QbWh4T9WPZoeUXEhmmz8LieCds0K9/bAq5zp3h1UhkDveLGDp5gXZuo7hWBhkfCN6hahdF1835G6Pf4MQD1RMJ5ry84+7AyyMUc4PG6AKc+ct0hZIQ=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CO1PR10MB4548.namprd10.prod.outlook.com (2603:10b6:303:97::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Fri, 25 Oct
 2024 18:45:38 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8069.018; Fri, 25 Oct 2024
 18:45:38 +0000
To: Salomon Dushimirimana <salomondush@google.com>
Cc: Jinpu Wang <jinpu.wang@ionos.com>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bhavesh Jashnani <bjashnani@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Use module param to set pcs event log
 severity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAPE3x15ryZw4s=qA=7HSDyZZXf3FUz2Ms7cxXHjc_R+UbPZTwA@mail.gmail.com>
	(Salomon Dushimirimana's message of "Thu, 17 Oct 2024 12:58:10 -0400")
Organization: Oracle Corporation
Message-ID: <yq1frokf2ii.fsf@ca-mkp.ca.oracle.com>
References: <20241016220944.370539-1-salomondush@google.com>
	<CAMGffEmEJp_oVAsbCVV9PKs7vOKWLrUhRGcBGoUSx7+t4ZtsQA@mail.gmail.com>
	<CAPE3x15ryZw4s=qA=7HSDyZZXf3FUz2Ms7cxXHjc_R+UbPZTwA@mail.gmail.com>
Date: Fri, 25 Oct 2024 14:45:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN8PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:408:94::36) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CO1PR10MB4548:EE_
X-MS-Office365-Filtering-Correlation-Id: f9be4388-80bb-4bd9-7dc2-08dcf52537d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YZD+BS2EHSBHOVXBMR2ngMnBvAaYBk+n88D3mI7JLHWKdeliFYaWO8+l4+tT?=
 =?us-ascii?Q?71Ix76bFk8sfAX0FyrUBIs8XFPsg/O1Fb0AoAzvj2DkPEUy2A83i0qCx8T+R?=
 =?us-ascii?Q?jj7gy0jDa0uTqiRUqxQFFvaiV5NzS+9C1w2KwtFIzhIygi8sEPgG3be7Oiqk?=
 =?us-ascii?Q?clmy8TIWVDvixxMv0lT0SQwPpInLWq4Uw6rcwysPv92YSNODkdEAznQVvZL6?=
 =?us-ascii?Q?WXxNGw3jQymRcm8B1yIaVtdGlTnLMaQ1Rltg93F2VlP5661zOp/BhGXnkDlh?=
 =?us-ascii?Q?qcw5oAM7QVIZhqZKHPnYOrf2bylipc+bZNb7hoZsprRXbFhaaEjNKV2Wb6Ab?=
 =?us-ascii?Q?Ig8pIzWjR/VHxDnMmm0EKkHemcIkmJEPowhMh73FKJ9kjbIA8sNyWJ4sufar?=
 =?us-ascii?Q?al3W4d4ClSel+ZAK80x8NrFSOuE5NR85jFYx0UJ8J6owW1VDE7xZ6k1LWAP1?=
 =?us-ascii?Q?He2rNlAtctBMweGQp9UcSkzOirGTLWj1jY4fHZiuqqe5h8xNiB3JTZe+V49a?=
 =?us-ascii?Q?MF9QABY9ZG1cKAJejCANoUL8nLoPVsDPw0/D2qM7m9sENcNSD1QnMMSB2es1?=
 =?us-ascii?Q?VydfpvbSpjTEwuHBPp4lOVqdm+ec0KH7HjXvue06sMW82imX+HlZYdzGbGia?=
 =?us-ascii?Q?RBq3w9u+iTyi9CXvAPV2Ar+GVQFqT2h/RufjLvpux2nCDUVtgRsPAjQTXe5h?=
 =?us-ascii?Q?gPpf5htpB/dI1Zg1EjEtREUSAHfSgz9RPxqVJL3DejSPKo7NwwJsSYK5EbAp?=
 =?us-ascii?Q?gVAaDGw0maVKybQ4SMBwRvmuvV98jlQ7gQU4z/IE0fhi5dgcYiM51EIBSyK4?=
 =?us-ascii?Q?lFeAtLyR0e3vhgH13gqhIfvCxobllkooMqSzAjZuaqadHG+dZmRvVw6ecAUd?=
 =?us-ascii?Q?O9uq6O0f53XzTSEwqff9i+DzoJKc+2iFxoZN4V1GlETLYl7cK3bkTGKBj0zy?=
 =?us-ascii?Q?Tl4XW6Ken/5leZe4LyxgdfKZWdgrQKJwb/vxp6D6uv6jyu2DOdVSxOPf0BsL?=
 =?us-ascii?Q?jeUPiLW/RkWSTgBa/M4HQvxFIVDliGYXVocH4J7ayERZx2ZQ9hrTdjxLMKwU?=
 =?us-ascii?Q?Xe8UlnrNywGDngIGT/NzX9GU/QGf4KmdgFy4gR56Y1KEa3teDUDSi1xGVfVU?=
 =?us-ascii?Q?+o2CypUco33L+5DOSGnCiCCV8p9Mtw0voZuIyWIzyZh+q16BfrXvXwavtTgF?=
 =?us-ascii?Q?kUmcuoPFSLwkAPAQf6l09mP7OYXgLUEyPGo04Uf0dxnq3fh82DrsCncW9dBf?=
 =?us-ascii?Q?KiOY+74PR71dyD3mIdtYGnOS2vrh5gkHHg+bYA2wU4B8tN1Jjl8KKWKsSVhh?=
 =?us-ascii?Q?96eIt4Uwn7BcE30wVwc1zJql?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f15nuLwUcxTpH7EkBDB8RuSgh41BgB08oViU95Mp+YvFR9PHAwgyXWQZJh93?=
 =?us-ascii?Q?fi47WRUZRQiogqdyfEaTr7PxVPby+riO8XydDWTKaWDSP5yAMU1dxqH01EmJ?=
 =?us-ascii?Q?ybgWq+ZgV/GG30wI11Fw7bpNJftCThK6BF//7zKniz8RC8TnT19ac3viUL7u?=
 =?us-ascii?Q?IEizKJDmLT/Lqf//Lozospwi20vgX1glHzJg8R9PGRnqV9ojChHv84cYAPTQ?=
 =?us-ascii?Q?waSDHioXrUAGIe2cxOykI3PJfhZTia3GG+9j9C75bmY5rB1hHZHBQBd5EddF?=
 =?us-ascii?Q?zUpj6VVT9ZWCQJptAJkF2jouy7zmJtVAm0bkZnf9b0D+0fO3qGcVveNRC+X4?=
 =?us-ascii?Q?f7fXN1oDNL/w/8Zp2KnfYu2Jls+rxR/wZPk39Y+UFyKf6uoEVwqlZ9q+Y26J?=
 =?us-ascii?Q?nW4TUb/Bbvlby/Ba2Siy6niGcKJ8a+DxQmEcRVJ0c1r1J/vU4llTQvtm8hDw?=
 =?us-ascii?Q?EhS3y7pK7sF47cZNY+lcsMjZR6N0n7h3x/nkFOjUUmEQg/uBPnijb+RjfTFS?=
 =?us-ascii?Q?Q8PhjIIl0J4CV5HQsP6XW1zRtZ5+/DNitW1tBwFrlq42JjzSjXSXRdX0swkM?=
 =?us-ascii?Q?LWa4yaa03lRu6XdyYGpmf4FZzrFPAtoy/IBB4Y4u9yED4yCtX4HNc75qFKjz?=
 =?us-ascii?Q?jfeGoURJtu/HMuE2nTM0z9opFlwbp4cvgPKxIIe6aDS9371YnsRy2KELOaDb?=
 =?us-ascii?Q?Ev8fUcCSYG+HxPawxJmPxSIoW3U9UTxVPF+KYnPZbto13ZRZe2F19gHVgjoK?=
 =?us-ascii?Q?+qTpAls6g3oDT66ZNM2iNEtZea9duHzSwrJS1vWFPJn4dLdjJlQcOzOEcDok?=
 =?us-ascii?Q?tvOoHPFr2cUG8b3M+o1RUddhcRObm8OuLEUfi/YK1RtkZDwgUCiL7PJD/pQr?=
 =?us-ascii?Q?mjBu371ebss5N7Ph+p1BTnvClNTEM6gyheVDbDiyptbxRwNSbRLb19Wp4i6z?=
 =?us-ascii?Q?EriKGH8wI3cf1YfK6Re0aMyjFYr8+KrtbOUMcxnPu3fRdAn6qaDUT+HUhToQ?=
 =?us-ascii?Q?cws4+D1ii+2nceqRPOmFwzdr0Ag/U+UsvQwAzXJo4WxUbKVGe+f0TX4bFckm?=
 =?us-ascii?Q?rpsHweutQZmCXooyYV7HDfuY4FaM5xYGtHIA7CndhE0Yi76NgBPOK89PfLRQ?=
 =?us-ascii?Q?wvI+N4Iq1oM1mjCtwDNK7yOJCcuoJRaAFlEXYcnc0tNH6+8GP1juq6JRTu+X?=
 =?us-ascii?Q?qjSqSc3KdxycnyPsY3fmwJ2sEDH917cRRIw27znMAgdNWP458ZkjkMzfuwpP?=
 =?us-ascii?Q?6uXTIXNn3Aiz2fsU+Iv5hkQioy0ueChxjbpNJF2vIkR6WfdBgXpCb5B8VQQD?=
 =?us-ascii?Q?3TVtlnsW/TSrpOY6dTtHCpMloQJYtpT3lUjCBE7nlUrNiVZfhxD5dw3lZHet?=
 =?us-ascii?Q?PdRTBQwvanXqmsk3BJthsNcRanc/lCXXgamlN+Vku7j2U1RS7nd+DbyckRoP?=
 =?us-ascii?Q?Y2zY5nY86GH4cndplteuv1SMtfoBOUjfcn1RxNqQFZbx03muabX91WneMHgi?=
 =?us-ascii?Q?tFzXx25fTksjmB+yGpUr3OkBv8yox3txxKxfLNeXEyCA4emN2eZIMhupeHeX?=
 =?us-ascii?Q?Y4PnLo/fxz+pkmfjFLwkz6ChEZ3TLu0ICcuPLAt5ndfnYLpY7mA8FsT6TaKE?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aneTcYTU6wtuvGxFrNI+2FWIluOMfEGn+nY6BmA0ITPercXop/0h1y4qqGSC/NBnG87VGASmnlGKvhf0mO9urytwrGiWXOnc0HdhRns3PnFi9T+Z0Cvx9kn4Vsu1SrYR9CfKdiifnUOIK4I9JjAl1rYQvy3u3Wz53KzjmuaqVGQlNm15xWPe/GbzsedIw0QPAQMEr45/+P6uOp+n6exHZZUxa1hbM9Fnlkeri7IjmZyIUW6aHRkX43FhjJGUUAHoDjv26jJhi3lJ4cIPo0voZFpqfcV4tKVpX6vQYTHebXAUiz5fA7u7gB0WBljrbeInqgcYVL74D8kzPsLtm4/cH6Z430PbucyxpqOnFfQuEKZQTdycZrNYQehE01D4LlHedKDSQidi+kvIRokXh2xRsjvfK/TChtTUoDUFcSbAFZiFkrWgPTHXnLDyghsK4AvypO2F32QvR9HIQdKs9wMJNZDDE4DFLFpF/j5N/3lHKMAFl07fkBqP6IdM+pNtWvMCs17ZmqIfZqVB4QA7dXyjuuEdPr8tXhSvqIfN79r/udfjijzGMpBYaZdXi88bzAHdOtYiq/hM6buK/2milmOMhNK/9QqCuxR5AMroQgxlE44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9be4388-80bb-4bd9-7dc2-08dcf52537d9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 18:45:38.0334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bM0U8w23MVBqyP32QOVhMsVkHmVsz0vrXFGMPqX8Y1QgXzxNcoJcA1lcTZgOfQojcNiA4xlxblMLpoMyyNY7JeHpZNFsQ6NhGMHxi700LSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410250143
X-Proofpoint-GUID: GACOp0AhXUbSXNbBIMCQOsofIvUIwLB1
X-Proofpoint-ORIG-GUID: GACOp0AhXUbSXNbBIMCQOsofIvUIwLB1


Salomon,

> 3 works well for Google, but a different value might be better for
> others. Having a module parameter would allow users to customize the
> level of logging based on their specific needs. If that is not a
> concern, I can change the default to just 3.

How verbose will a value of 3 be during normal operation? I don't object
to capturing more information during failure scenarios as long as we're
not flooding the logs with noise when things are nominal.

-- 
Martin K. Petersen	Oracle Linux Engineering
