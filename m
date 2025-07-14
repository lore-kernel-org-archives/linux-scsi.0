Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C728B28EA;
	Mon, 14 Jul 2025 17:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752514763; cv=fail; b=Gqc+iAaEh9+KGONXc2rquSeauAC1aARTDMHdM7XQmEcTUSGAyryjFarAhYYEc17bkuWqtkL1gmNDb349NKk/NlDShhgmo0NpPPTy+EfUffTpwbtw8TenA2y73Iyuv51q99Vt20NS2ECEZ0zkfNxnebl2L8KDzuZ4foEn8mFBGgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752514763; c=relaxed/simple;
	bh=cVLn7UTMi6Opydyqmk+lLf4LMLUtIKlquV5I/z+A/Mo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mRg5qCtV2GyH3+RheP+RF/Zi9ZbUQuVTZf+urqU14xvzx55g+SSVoPFpxFaVbqbdZkZ0XBLAdbQuofVeGE48AISvFlh1C6OwLUiJDGrEJzUueQz5B5UIIYH1Dc/hrhwZOGnDXFkPIk0EXXOns6vJRfio6pff4gbU1eA013AUhYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kQYyiNzU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fv6uwC0E; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kQYyiNzU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fv6uwC0E"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGssYQ031168;
	Mon, 14 Jul 2025 17:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yC07ImzPNs2xhk+CgT
	hXkYoBgXH/Irb7izMSSSSWpXc=; b=kQYyiNzU68rHiPrhabHCYk/OnCOStQww/5
	hXb3pKEPYblnpM7AoW/yQD9VW9qQAtnV3g2PNIYcQPb+NGuSa1Doek6Zf5OPGHu1
	3eNci8lpPDUcQTAGf4NZrLDNl9gUH3kXhCZH/lilXfXoedK1bcBP1llGQaitjJct
	jtnIQShYNQuCyoQMQCD8o0hmk6XeDUhoMsXuiHBxpHV7/CL2ZNTK+UcoU5sQxA87
	hRmTMHF3PQlFx1yTA0Fzly69yEUknMqhkuQrY0/MCyF1GbRkEB4t8k6wCD7vGfs7
	zpOEs/OvXU/lPv0FV7/fydKkQYaBy0XTVVeaG34KbdPPUugWfHug==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujr0vr3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:39:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGaj4e011639;
	Mon, 14 Jul 2025 17:39:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58usgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:39:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Whtlt0d4IVsF+55Hka31bEeEbArxDfiv2JGR6XR5nFQetwIb2/WiCnWq0UHZ41NnwHGJLBzXQgUlANobNAC0ewMBh2K7JoOetke4sDUi12H1oZ+fPtnCcw5oEnejPdM7grAM8+add2s/L/PdXhaUpLsnBnPd67LMS1CUHVtRBPjaSBQu3o+haZLehEkp1rc7x++EEbKAa1O0TXVijOMOMV0WMNR3m2vQ+cXLfUiYSLitF78knQVGnZctiuxmiAv2pmfDoHIK+YB3aGhRChcKu1Z51pP0RmwgqouMXC6ORDzwaZQuxO8gdFEUsbmv1CZgkg6keU/61y/nCGTrZCRZnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yC07ImzPNs2xhk+CgThXkYoBgXH/Irb7izMSSSSWpXc=;
 b=XKuxtFK+Eq0LF3VTHfN9COuQvTd9vdP6D8QRpLKTbM1eU12OvHrYWT5R4HR5tFWfguBBcSj4EclHt/vW0226ae0EkMSeZM/ZKJVNupTemTfEzLhO0Ixnz3SuWS7b1FkNNq/SbKYAKA9UbNyb0x8pnAZWSmp8EsFEtOsxrvfxFxWivXzW4/mvDPstTqjRVNdvRJbeXv7qTvBRUEdLMMJX3OuHT/eGG56HIEu19MlwkmTh1XDuiZEd4x3+JCK7826IB+J3xX///XKuRto/Tmkco01rUxTMvMdsq27rrDQvb+uio/fDrY7UcZCayEbvZda4VSVvAtI9wgCdC23xtLva9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yC07ImzPNs2xhk+CgThXkYoBgXH/Irb7izMSSSSWpXc=;
 b=fv6uwC0Egvdu3tUOE7oiG5S4/iftOCUdZArdFTIf9H+VRgGCnn13nU+n3o+qC9HE+4r9/MTjwFajZlO6h04gCd3vB3ulpundm4sLK4SeVU5Mrcaj9HCQcwfg1yAXZ26yInS6qZhsK0j2gohPGlQyEJwiCHSGraFN4z56xMAn6WA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH8PR10MB6453.namprd10.prod.outlook.com (2603:10b6:510:22f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Mon, 14 Jul
 2025 17:39:07 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:39:07 +0000
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: James Smart <james.smart@broadcom.com>,
        Ram Vegesna
 <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Peter Wang <peter.wang@mediatek.com>, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: Fix dma_unmap_sg() nents value
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250627114117.188480-2-fourier.thomas@gmail.com> (Thomas
	Fourier's message of "Fri, 27 Jun 2025 13:41:13 +0200")
Organization: Oracle Corporation
Message-ID: <yq14ive8yfl.fsf@ca-mkp.ca.oracle.com>
References: <20250627114117.188480-2-fourier.thomas@gmail.com>
Date: Mon, 14 Jul 2025 13:38:59 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::25) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH8PR10MB6453:EE_
X-MS-Office365-Filtering-Correlation-Id: a7cb8eaa-40a5-45d2-a598-08ddc2fd556a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s1/1oc4JuIrOe1ClBzm3kLKoOQw9a8hOAm48W+w8sx+8khW+UnrgYDtvX2vR?=
 =?us-ascii?Q?E24F+BzoxeqgtygskDeHTipROt4lv88Vpe48LgBu4EBtwftzASv6AdmjiKHt?=
 =?us-ascii?Q?Qy8n5SDqWk7z8k8XbTluz7odaBNHo0mA5JeBYzLjjfvErfunekPEvTmY4YZ2?=
 =?us-ascii?Q?iBTsVRxN0j+ZWgWqe3K9Qu0TP8bP9eW2JmpxxgOrnvnTREFR8tHR82GWUu4H?=
 =?us-ascii?Q?YMu//ny6qHHIu6tX3aAVnbLX6qAUEFrZ+zTEiazKEhkDENu+KY7Q6nxMBc6x?=
 =?us-ascii?Q?A5KICxA6+Flq9UO3GKN8se86B3glOZoOQu9ISooHdDiK2fbtMt/orxNFkKEX?=
 =?us-ascii?Q?j98x8VtcHn9Y8SIe66fAo1iG0wlBA3lk0RI7tfobV3Oq9k8gB0UF8ivNvu2h?=
 =?us-ascii?Q?r0H/zOkZpVeIZ2VxepgsIV4Jn5ndOPvNxPJhkAYjTjkU4QZXpIA3O57hpksZ?=
 =?us-ascii?Q?w+ylNeQovFIAa9ibwOis3F+OKTFe2brnYAa7KEI7VsYvR7BCnJFE3oZZV6B/?=
 =?us-ascii?Q?MpPWE+4y3axOZXg+4ikxrANqmCNo0lCuMaZeGX2AVW3bVgigSDBaphA1fdMP?=
 =?us-ascii?Q?aj32x5KZW6a6oWpUzbIMVsG1rmCQv55HjmTdJK6KijppGYUqsG3muRlNN7/D?=
 =?us-ascii?Q?MFZ+YB4gL1uOUAgjkswvJ+1DOghoGs8h46vzflnxnNk8dQ4WXseF53l6fhzd?=
 =?us-ascii?Q?4YvHKAhwcjOLGRn8+dR/vaFWHNyEXtz4/NZOqizLOf507yduKqeYrPeTAEKA?=
 =?us-ascii?Q?HXPN993pgBE/ItUSBgeJewJ/QVYfS5uP0/GAdd58aGjDojlSuJbMdq2RBuDL?=
 =?us-ascii?Q?J+VJvIZF+c6LXY57Vij15nbqbH8DUKNgfYb9d8NjrFHoqDq2ixaInprVtOca?=
 =?us-ascii?Q?hTG6kffYDFm7O2Llx1VvBsffOKP10i/ZHlG0OwGEppMjZN3nZYzCkWWabbLW?=
 =?us-ascii?Q?yyqj7WDD7EDYmC5f4UOveA/LPhagXC1DaMbyqH2kvE2/N1wRy5W/WFPo+P0x?=
 =?us-ascii?Q?E2fC/5xQdersv5GSEgctp+VOlBhsV04yJLeu833v5cUTsGWfvn6cZBX+nZIh?=
 =?us-ascii?Q?gwUAeBN1MIBXdw006yRjzf3fEutWW2rMjoHw2J+GKgvZMTnaPCtQ7BZ7Ez+i?=
 =?us-ascii?Q?3RASUWAz56qTKfqsurXm71Ujwhcb2oFJ25EYHjms14X4Dz3xCmZFSKYH75yW?=
 =?us-ascii?Q?RTta9/YyZw7pAf6ImoNJxMWINf/npxp3s2lTBzv36euBriXEEbSfk+PeLyf3?=
 =?us-ascii?Q?LCgpT/7EIej/0izWSLx3BZCHHMUR/GTCjm5MUNJInHCDuyWcN8w+knQ53U88?=
 =?us-ascii?Q?3F08fCibaL+H9i0VkYNUgMZ7pwfEa0FVZ/1LaNQ51iwnJW7Xk6iOVSsQ2ICW?=
 =?us-ascii?Q?k6jqQxKbABLtlXP4YXlm3o7p13EajvWIsumTVEygLPr52FHonw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ijJk/6Pv4YMZgx+ljvGDNFPZcyeXDHhfQdrxBeHAWvlQotEP7l+uxNiiZ+vc?=
 =?us-ascii?Q?KDcelHpjOdegN2PafxXdxwtg0ddJJh1bNej9Ewcu8MCdA5z9R/pUUG/oJkB1?=
 =?us-ascii?Q?cASP5bQ25xXHXsRM7CYVoVD+TURcI1lOtdUA7TiMKuuT0hjWSaNFYh15E7If?=
 =?us-ascii?Q?4qrelR0bMpNZfhLgiswXeMrfCl7KKgorP05aRHAuTPzShdJqDjtl/hotphf3?=
 =?us-ascii?Q?m1Xv4+rJhM3Ss5beRufTsZq93l/C3Binv7F1ffmLupEWqxf+BE+nDoY4HqpF?=
 =?us-ascii?Q?4QGxFRzrdfjc/q++u56AIJXCcQwmppUWZI4wL+8ixD1nHyur3Gml9jGHvfjx?=
 =?us-ascii?Q?aP8+blQFvRufTTmKz+wDa6BH18JA9/TMkadw/T90nk+hnnsjAoFpuNv1f90L?=
 =?us-ascii?Q?SunrN2lX3F575TmlgBcQW6b6pqqmyGEj7Dgt5QdMDuOdK/O/kt1pAXOCWq9j?=
 =?us-ascii?Q?hRET5D6e9Uh9I8GlG+VHiWyonBXnkNTwe0lA9lObmyZECmk8Bi8fp4bWOjoc?=
 =?us-ascii?Q?yE4PQMBtviI1GpklHxBQgk1dN1UAqzU45CD8IyIQj6vie82i+GohZ5UpAJiu?=
 =?us-ascii?Q?/CUnOzPN2wTbrJJPxchUj2Jq7SCkiGdkN6yFGuiZSH2UKFRKk9+T0V+huQpB?=
 =?us-ascii?Q?bGLU2cYqIC1qA6qxNbiwvleefO6NL+l5rkjWPwMspWdVzVHcynmfW6bs8q29?=
 =?us-ascii?Q?SXpC0MtjVPAi/fIa+6VAyqRgrt7Q+z8638mDEP4aDLrX5DVT7Yz+2pugKH+8?=
 =?us-ascii?Q?Duy23VR1QWaDyo62k7f8n5BbMWHP2BD4sOY7w1hNUqfTnKqudGPZkNDRGXXb?=
 =?us-ascii?Q?cVve2ijqfP2O85a9ap9gtmgNYFflKDcZs+POAdob2/h7arUTWYX/PraQmR85?=
 =?us-ascii?Q?T3Mh+K+6/XSFjPuuUvnVMIu/piIxp41RDdBAwExlZcFt8B1ms9Sf4kLhE6+B?=
 =?us-ascii?Q?2bvfjAEv75OMIz2m+reNcSwLxRWEUVPFpqYjt7p9syIRng5YLFJwsWS/7rOy?=
 =?us-ascii?Q?sBTGZayHzZ9v6mbQES+Ogck/x9zeM0Gpp9GxP16Fhfj/FZ+AsDgoCjq4w7ma?=
 =?us-ascii?Q?mIvz6kto7umcZ6JJHJHMNyiU3GpZftrAgblmTDXTNoLU59utiV7+q8gcaCvY?=
 =?us-ascii?Q?PI+XlcwToFFO6v5RVfMsOEUkIOa1maYD534xlfGSURbjSvM8GJ5mpjV6xB/B?=
 =?us-ascii?Q?oaYGIz4JOcZwOu0G5q0En53O7w9GARQWFAL1ntZC1HWtwZaD8BSypKUath35?=
 =?us-ascii?Q?LpKgrcVp2IM6Ftg6Hv2AmCSbTqNMXdyVKxXbcrp6CJTxtmyjso5y7x8MgiB0?=
 =?us-ascii?Q?9ikX5B3D9yPUnMCyIwLRZCIgEpP2hrAGxx3GVLx9MUl5jIMLQSklFkgAS+j9?=
 =?us-ascii?Q?2cGKK2tMZ/vSgKyzHZU0LxMn7s5DtvC2Kpb2CNPd8rKsHMw5S2lIHQ7+TfZ7?=
 =?us-ascii?Q?XVwB1ldGqeuXQeMC9eGAjfDJqVFUmJMgWIKy4rlkjMBJjBfDzXB8NikpxZiO?=
 =?us-ascii?Q?fvbk9Xahr9ElzRUr4MZ+JfwFLbvWqxkT+W82XVxiiZ8lIvgFm1l3cJKs/5A9?=
 =?us-ascii?Q?lZ2bmOXp++CgLhR8X5AfVPclikdpKSNOfGfVx2P1nqa2beCsfXdMFQhPH93n?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ndZEfphdXWaw9m20Xp3jFBjlHbZDEJ5KU9YFk2jASHCepBLoE6sFnxrdfXHXoyHCzR7Hl9GMKAp/lDjOzGfmjqccyI553PnSIl7HVN/a3zfr1mt+RyIGd278xe0M6zYNJu+eenUD6OBL1+AlMUMMBecMkuO5H1PVTbzpzFKw06EoLkO1qHWpNxkwy3hk9u5MlxMC8Kz5f1xLVtAOB5y2Dphyq+ni1ejo5geYPiDW5SSBW1G8TANkgqFGrYdKn2q8q4biy+YZrT/W1pMiuxIBxcCK+sTCSbhqaowCrSdfgJpJTS5NAstqN6kgS66jpI6w9TacfJPpQoDi0XrjCH7usnA2b+Q2Mzn63QZ6iad7EIaa5Nck8eJdJh/qUdZkgdbaNO5mVc5dHrWIfu7JfoIVhdIErTgwWsJvr2b3oXJZWp+5HF6HzWsQ/rIcwxYCNkiwis4sagfwa7SpjQGetDMmDKeZG5Rr1xotzP079/Aqr2JHIZa10YIKVI17oIS9NhFS73V3bxsibsC4VMhdkYkxAo/u8T75UosCoiv9IY03rEx1AQ2/MCU6itnfcP8ZnvKtvMktrkHcFNiKWHNW+H/UNcwGq4bgCRIjcm8k2J/39Dc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7cb8eaa-40a5-45d2-a598-08ddc2fd556a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:39:07.7893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nlNheqzlP/aNKb9eaMgUI0+tn66qnMrSt6IZRRxD5vcDRiZaYSdqoazL20MMgNilByesy7xyKmTcGatA1Fmv/Ti11zLIl9cGzDCLqIsgM8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6453
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=712 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140110
X-Authority-Analysis: v=2.4 cv=d9T1yQjE c=1 sm=1 tr=0 ts=687540bf b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=6SykWSlyoIXIk_ZA4WkA:9 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: mU9cym-pYwQaHXyaLdkppPbP9QkrnM7x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDExMSBTYWx0ZWRfX0Cu07tH57HyW DfaYnsi7ojGWE8gKXOBeVFCTdgDa2v97bKIEFt9oKk+X0uUN8Dzl1cIqvN5GipXMiZFJAAVL+4r Z2JtDQAiV6bg5BbgBD5cT+NwONQPi+lGwDPi27xFvaloLkcr5dKawO1/YCTxqN8n7lvgTtRM+9f
 g0CPtG3TCTTbtRGoVxFZVCLSW01KTDPOLqgdru1f9/KsedJZdgsHG1cDzuWTRy919Ft2bTlDEuD qI8//V/pnwXwz9PthgnhVlLKVSAp8vQQ6XnIsmkjoiaVee92/ISNKYKo9LTit27yloBlP3h+mPF qqw5Iylfr8lQSQoQObU9JJ8rEVETBVg98VaCaEK4B28+YZ/g8OpSLSFc3auDDw0jc5iCMabjVqi
 00PINE7YGLAvQur34/83aN2oqa9H3oGF32J4n0UOSenSUYOegSbnPPbgaEnrnBBwbWxnDOxT
X-Proofpoint-GUID: mU9cym-pYwQaHXyaLdkppPbP9QkrnM7x


Thomas,

> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
