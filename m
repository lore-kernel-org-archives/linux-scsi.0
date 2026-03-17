Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467223BADAD;
	Tue, 17 Mar 2026 12:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749262; cv=fail; b=RpV7yeSiuau86sLuVpeYEHnbgpV1bhyJeifcMFf0Pu6DU6i/5ggXYiC522CxBOTjacbI4utE3M3cm8lW/yD0PbWiwxEYHzuT/pteGSIGYPrG8ezBb3Dmq0yrukoaYMOnt7yjK+5KQ37YCEPNn6yrw52kBcMj+L4CV4Aq7a6+zmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749262; c=relaxed/simple;
	bh=jjg733pdKdwU4E3bWjw8hTcBBX24/Vih1U5KfajxUa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qe6ZFAUB1FjtVCw6tcXXW5l3n7TpKpSsyepWejocueW8mFgCRi0etKnGpKXY2BcejRjVO+aRAeOp6jcxCato6KUzwE2iD4wxPPaHJoHkWjWo7k/D+1sD/Ht9PBTvPaXBNeIKxCKwWMK9rX+zsw/tp/6825xJNFwfRaRqddmvqXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ib7SAAUQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QoMDbPSl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ib7SAAUQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QoMDbPSl"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H0SZMO1866514;
	Tue, 17 Mar 2026 12:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YTAMdThFVTR5pU87bw28qo/VXc69LX23iEAJFqlzwic=; b=
	Ib7SAAUQ8Lr8TTeBoRQont/7F5gkceIuT1LrAdMDzFp1UStNDC5kIMOUhiguLESV
	RKW4AGZLVI5lYIgAGRsaVmD6Fw72ZKTmAUxMCW+uqy8w15xm1LHyd/axHnSnv49R
	6vW9sSEePn85vmM3kCfzPHXDNp410yi6/C8ZMUd23U6HFT2KDi9/bd/AT5jRaJT0
	eKj/rfKQy8Gri0rOT4JTsb/tb5UHEWCtKXFowO+xVPqfrFXJLh/0HgVH471WEdUO
	1VpP3/4+8JO7KLZcINYjw7SePf24kGDiqPhdYUqEILm3mBMdNF498xcASjCU6uFG
	qIw/BqLFve3Jy4PUfglZwQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxf43y76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HBaXS8003335;
	Tue, 17 Mar 2026 12:07:24 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011066.outbound.protection.outlook.com [52.101.57.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4a0198-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXHf0zI/uHmi1jPoBiVORmGVVElgo32AVD2rYfTrboVV88CUI7aUaQ3jWOFmSnmypjKhhDotU1h9ECcbw+JFDjAsG0yDmFSpWSlMI3A2T8Y1ZiMKZUZKsZXIIPc49QxaBzB+hA6QkyG/t532cnt9rgwdpotI5R4USCl/cUPdEAXCzYz17UOvXm4K2iP5LnwJOnpYzI0K8KuwVcfPW9FIx+Imotr/QcXAdNxKo5fLm+IPoldZvQHqFcsWH+mMl4Vjbk0KBtYb1Ib//6bl+r4fkDxAHAjInVM0rl23Ys2aUbAxHi4pX1N0jJ5OXrnbu3VpRxdb9uDrmbHipk0kyROyRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTAMdThFVTR5pU87bw28qo/VXc69LX23iEAJFqlzwic=;
 b=uHYPEl3wKyP9NiFJoV4vf/JqgXufYoFN5i4enb5CoekhVLQpWmDkOZsMTQRvT7Vpkmso+Mz3pmeNM+hhjR7X0nprTXbsO7TzCxrBgxEHiKbq7c8vH4LsIrOZTJEGzv/vhr9eF28B74UzlxlHBBv5k9OW1Iklk27qFljG3aDw5boS0fz4xIyVYHtZNUSFtp1I7Ojkv/bgy20maWUwDAcNFzPamxUpl4ZEzYGbCUyvN1syWdcYtlckpJe1semoc6vUY4aBoCLlxBgmRn2GcL/Ty92gU1bzYXfbmZxXXvEAganZyMIMQNO6PBQSuq1OzQLQCygZ6dp3NPi0aoK1X/co6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTAMdThFVTR5pU87bw28qo/VXc69LX23iEAJFqlzwic=;
 b=QoMDbPSlIZDAc3vNHHy4xR1itAbDfb3dvV/z3UBc2rHs3GTGb+lRwHjddtR2abVeQJZzSamKTeyeu7kw0yYXJGEb03UkdmAp6a2FZO5FQsA1IV6oOdC7XPyV93xCcoJfYkJhUcK+AplFehEfEzv0LEkbOH9oi2cR6dyPA609SaM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7454.namprd10.prod.outlook.com
 (2603:10b6:8:163::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:07:22 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:21 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 03/13] scsi: alua: Add scsi_alua_rtpg()
Date: Tue, 17 Mar 2026 12:06:53 +0000
Message-ID: <20260317120703.3702387-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:510:339::6) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 0459dc3a-dad2-4ca6-afa9-08de841dbe67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	kT2bIEW+VUeXXJ/xiIx8h1ysMqLmBFTuhapC0cvPOsby1+pifjQd6jpek0KteK8TSbTTfJ0sfhf9m4yBjJOQ8Rh/9uLy440PWubam25F3EVdExeAWP5BEojnE8OV79FE4f4WDhvK1WVZvDoB46XnP4KEMTtOGf5pYBgH9enNkwt2I//PiDz1m9bPwI8M48M5oq3qZoVrLZH5bU25jE18jI3dVTlohm2/ekvowoNdkQKTIbvby/dswyrRzdFnPdk1++bXsRefzcvRBzzHR35nlZhz/wi6sJyNaxYVcjwdg1bZy3s/26dMFZa90UHxSO0F4NDT7ARO2yeAxsHgrwuojsHenDAvrHquuvGdbePt9lbYzYycQMme9DUi4GE5r/kreEv1vdyZHTggtZQSbRcJyToZkO9O++yp6cQX7MFLiRUs6Cqnt2GHO3BG9EaxcdhYkATZJRX0eDPbQQHBDM6f9ecIerc6oQ3kjqJkmBIDoEtXBei8wz8M/FwV+FuHNJ2wDgiyW3Zo5h9IhlBCzzBnbA5VYYSdh5a9AxuOksG8FVciItvcV84bKmiNwCg8Vt7buNW5r4RbTGeBpJ7A4qh2bjlzPgHcViQJSSLUYD/djlnevEWDQK8FP/cGnNaqlxAJNPJ25Q46xfOAC4FPgCrYm1tBvS6u025rrGls9CQgQeZVmfYTP/SHsjYXsfMkatUobnyWkvLSSQvKWZl5pPfuXSD4VG8qJyyElEqMwT2dPW4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NDy4He2rBdsBTtok2odT8Rb727rMxgj9ln50S0n3BJGT/9bnVKSaOs0rOygp?=
 =?us-ascii?Q?rr70Z3+0RRb21jeE5h1WBLioEdk/G6BytwhjUIWj6ahnHOWnCCA6y5GTXq73?=
 =?us-ascii?Q?zTbL3m3ORISbgzjaKK/MzaW15ZK3I9Kgwpz8nGFJMGTHKR5p38jSX4sHlRPF?=
 =?us-ascii?Q?a6X505JGT6S8WRWFQTQJpnPXisB9DWDVGOL2HjAqa3TmOLOR5MFdKoHYAWl1?=
 =?us-ascii?Q?kCUPBpy/+d7VO8x+0uK8S4Gu8T16xmzhVPD1jqRKahxQpiEZ2SVKjkkf70q5?=
 =?us-ascii?Q?C2ereu7wCPcvm40LMxVLqqkBMzloljIOuRzW0VTBZBHpXzB8w11SwCRkj69l?=
 =?us-ascii?Q?PnzrCDYTFOTEy5quOSACxrIpp02wgntuQd6hWFmIJvpXl6zXU9xjNXcH6h/F?=
 =?us-ascii?Q?p7EcFP+9tDttX/NQhQUheVX7sEPkgFOIo00o51x0ZbacGSUVhhjAX0tbSeyd?=
 =?us-ascii?Q?cMyIDJFq28yd5KroTjP3eDRqwYSY03HQNCJ2gUOgTqKgdC3HjJz+eErN3/iN?=
 =?us-ascii?Q?ccEI6SXA5VymKmrZYYtKL9HW3x3sZLcQlOq3aRUOiKQDau1ZC5x5NpVlDwzZ?=
 =?us-ascii?Q?vg3wQNyYUXV8IomeFa2RTH7x1EaLm1MPu/YqM9b6v3UTXHtqSjFF847djKpg?=
 =?us-ascii?Q?1Oy9cwx8fhtqG8673l9LZ4aJxji4tMrD0lvXhwddd2Ov82eNIFxQzlujj9na?=
 =?us-ascii?Q?kPSoPk3nguDQaqF0OUKPr4+yL0Wcn/o01dZqiIdH2rxRu2+vGhiQRts1h9mB?=
 =?us-ascii?Q?RIsDRe10YCLiXctobvHqmylL3bIriVY4e0cZ87doXwMHWZTfJIiHTNzP1Pcq?=
 =?us-ascii?Q?6Q2kUSgsb5jPZ+lEeHLrZaHp7yLem/myNH7cjbAmjILcjxsX5Cn8VO6f1r3D?=
 =?us-ascii?Q?SXiqhmm7W73ozT9Ng9V/IAV07Z8vYPJPcP9SkI9fITC++5B/oewwF1zIsS4e?=
 =?us-ascii?Q?Yn9pukb/bQ3egmgKrcqZqOEOJT/YWD/JZWUg3dCMaWUCrdDioYkMyHUUM8Lp?=
 =?us-ascii?Q?dRuLWM3BcaSsWHwMavKUCT8r1jog6YYX/u0mxe1aWpHZ04sWo9gGq/NapaT+?=
 =?us-ascii?Q?uQx96ezl6majiSVgPO2nJJpM49H/5Q3JZKuramiNVM+CRsBZl0YBzbgFXvaV?=
 =?us-ascii?Q?A2jirMOXxqILs61YEuGnE7vs8BLQTxw6MR6RgiN7rzGc3DVuOf14WtCkznRz?=
 =?us-ascii?Q?Xe0kj+h//AKKVtlWB5Dc5IGDE31KbxI+3C2SBoTJbMtWVmZdFBUemPNK1Kg8?=
 =?us-ascii?Q?3tPsMgMTmjXnOKGllYi0CuAp4jv79+XNrp/7yhuPkBvUuro2FK1uzGv17/O5?=
 =?us-ascii?Q?PO+IeJFR+eazQELijaGRFPf7xXQ7h+1mTZBIqQo6Orj7lUG6fnl5XPwH9N+I?=
 =?us-ascii?Q?TooGfVHtiQXcT+XhHl6nlxmT3PSh8BuPLIM7l3Xh9yx/do0yEdNWkpebRPjJ?=
 =?us-ascii?Q?RkN+7YLAurJwR5Eds+tuRs5qzB8xWl4tSZ48K2++QmqrtTYvvT2aEkWOVWW/?=
 =?us-ascii?Q?NG7vAOwq91aY31sp00+6YKOB9TdkWR5aXk3uGsX3NWYsT49lNB36Lksj/wJ8?=
 =?us-ascii?Q?ixPsbK3wNwnzjO+MWBpkzBrvJJLBN86VJDzoFOJiymYYrCcn0g7nXcVS2+3S?=
 =?us-ascii?Q?HOiwMsPh3IPhDZLrbBFSPiYORHTEjyBXg6QepmLQQFlmp56JgA1xXullwA9g?=
 =?us-ascii?Q?yqjsDG0r36dUVXqwd1Xh2fmLMu32J71uu0jA+GPF1WuehAMUKpI/HF3buNJ8?=
 =?us-ascii?Q?MDrB3nzIbW6wHx3DKiN0yaTRHJcrpWo=3D?=
X-Exchange-RoutingPolicyChecked:
	CdoDJ1vRDzPzltaZCRjpsfi8uizx78n9k1jjROCepCBUiLm5w4T01hgL73ncOdkuayYDk7YMWg3SeSaLUfP9sF9W5bwDHL6I+rJIx0H/ZXblpmnSH7Xns9BD64bg5q92SqihTyMNQ3F/Gu2KERNDl3RnRpfpkqMlalXKug5xAsWK3m6Y16ko6xb2WamVXJr1mplUw6FpFLp4jNA3Umlefs3RREAZtKOPfZ2RI88J40wkt+jkjsUrugTS6if099AP9nD6Bt5uUihrKzgXH1jnF0DU9oX0TM4DOnGMEfuL2cprYoZKk2g5by5y4cSewg9NSTt+iR95c8na+XjEOCxPEw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6mFhkA8alxCfwFIWuEqA8WPxGS8L5lcacxHGPruQVItDXgKeu9umAAlbfcwd4hSkMeab2vQ2gkc77kBgDhpo1lf/avGeWeTDMDGYyroIhWmf7mCQQLEydkT1k3dA1WjiN3htQdCoYwkGSo82rmzQ+Bv+PMm7XJTk5aOQGe7VsmT7PThZntKwWvH6GXzND5CzBtFiUv07C2KPOxXOvaSGCnnS/XnSYnhIGh7f1UMbb1fluywnALRITWtKOvEicQm/b+TAWI43AW2mTnkmTv3Lc+BVclN9XBIhtRevstdSh22WkbWOLDG2kMuJUAOSnbS7O6lQmnOGWzo4uCXY032h56nGL7ctjQNOvM6pqAZtMh5lgNvcT4uZgnuX8gG/PwLcpcFgF8+NwsT4V0GMSuCtWn3zUzfBCos5gE2VF4cp2tWdHyuIZPj0SdP/D6GFDeJFqDFRWHxUI4Bc75vpUgv5D7poKd6nZCAxYAjFZvVijcJyQ7+X3ol2L1978aVArfNKqq61F4iTQtKOHyUTvQTlHiiS9BQ3wLDRHWNMKoM5UrINLG3FSWcG5c3zAB3dz47NkZti3Rb3O4Hgbkq5xtPH1Z4YrecNrhaxvweL0JD0yko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0459dc3a-dad2-4ca6-afa9-08de841dbe67
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:21.8487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXeMO0Mu9Qo+G2d1oQgfFM6cPKQr8jS+G/XKYOSNMUHySgONoElwBLiBWqbhOvrYogtVasxytq1MB0ogK0sSug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170107
X-Authority-Analysis: v=2.4 cv=ftrRpV4f c=1 sm=1 tr=0 ts=69b943fd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=8xFE9Y0xszT7Za3-YHcA:9
X-Proofpoint-GUID: BrDGQ3Z6vlN1et53BZq8q837CKZlUd97
X-Proofpoint-ORIG-GUID: BrDGQ3Z6vlN1et53BZq8q837CKZlUd97
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfXyoCT+TMhQMiF
 by8XfB8eOF0dE99KSnnyMlOnY4MMnlwHbIxOWxGteFR1ZEfnGmd6e2jZKDIvIUXjW/tP7J2vXk1
 1f3F4CtdCLPMER+6hHHxgPtPnTrOOIaN+2ngpFYpujuk9r9dy8AueliXyl5H33ai+gBzM6OP/5S
 5VOAoB8FIJ7QisE6Kpm9A0pUYmJXOLF/s/29e1j5q/T0YZY6WuKZPwWoKwLslc9YxiAHDuWdAcF
 nrJSvT49DbinqNOT7MYrA6GSvcd9kx3bzjSNG41DNNY6ofTYQ1Px7nzWhB0ZHyE9QtsDB43oBgd
 86xbf0vPGJm9Q9vMhkFAxpbZGdRoUXwj17nJZejLe/LgkFDrExcbQqCSbUgC1nPqo8YOqymhCEv
 6+0x8CHxwbZxyeM/1nRgpEpt8a0LVfzUnAYXMlrZc/slZ+zQNTD/W0hb1p3aACWZKiMQgl6kuyT
 y83xEmSsVDKmlxnAY2A==

Add scsi_alua_rtpg(), which does the same as alua_rtpg() from
scsi_dh_alua.c

Members of the per-sdev alua_data structure are updated from same in
alua_dh_data.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 311 +++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_alua.h |   8 +
 2 files changed, 319 insertions(+)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index a5a67c6deff17..50c1d17b52dc7 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -6,6 +6,8 @@
  * All rights reserved.
  */
 
+#include <linux/unaligned.h>
+
 #include <scsi/scsi.h>
 #include <scsi/scsi_proto.h>
 #include <scsi/scsi_dbg.h>
@@ -16,6 +18,314 @@
 
 static struct workqueue_struct *kalua_wq;
 
+#define TPGS_SUPPORT_NONE		0x00
+#define TPGS_SUPPORT_OPTIMIZED		0x01
+#define TPGS_SUPPORT_NONOPTIMIZED	0x02
+#define TPGS_SUPPORT_STANDBY		0x04
+#define TPGS_SUPPORT_UNAVAILABLE	0x08
+#define TPGS_SUPPORT_LBA_DEPENDENT	0x10
+#define TPGS_SUPPORT_OFFLINE		0x40
+#define TPGS_SUPPORT_TRANSITION		0x80
+#define TPGS_SUPPORT_ALL		0xdf
+
+#define RTPG_FMT_MASK			0x70
+#define RTPG_FMT_EXT_HDR		0x10
+
+#define ALUA_RTPG_SIZE			128
+#define ALUA_FAILOVER_TIMEOUT		60
+#define ALUA_FAILOVER_RETRIES		5
+#define ALUA_RTPG_DELAY_MSECS		5
+#define ALUA_RTPG_RETRY_DELAY		2
+
+/*
+ * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
+ * @sdev: sdev the command should be sent to
+ */
+static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
+		       int bufflen, struct scsi_sense_hdr *sshdr)
+{
+	u8 cdb[MAX_COMMAND_SIZE];
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
+
+	/* Prepare the command. */
+	memset(cdb, 0x0, MAX_COMMAND_SIZE);
+	cdb[0] = MAINTENANCE_IN;
+	if (!sdev->alua->rtpg_ext_hdr_unsupp)
+		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
+	else
+		cdb[1] = MI_REPORT_TARGET_PGS;
+	put_unaligned_be32(bufflen, &cdb[6]);
+
+	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
+				ALUA_FAILOVER_TIMEOUT * HZ,
+				ALUA_FAILOVER_RETRIES, &exec_args);
+}
+
+static char print_alua_state(unsigned char state)
+{
+	switch (state) {
+	case SCSI_ACCESS_STATE_OPTIMAL:
+		return 'A';
+	case SCSI_ACCESS_STATE_ACTIVE:
+		return 'N';
+	case SCSI_ACCESS_STATE_STANDBY:
+		return 'S';
+	case SCSI_ACCESS_STATE_UNAVAILABLE:
+		return 'U';
+	case SCSI_ACCESS_STATE_LBA:
+		return 'L';
+	case SCSI_ACCESS_STATE_OFFLINE:
+		return 'O';
+	case SCSI_ACCESS_STATE_TRANSITIONING:
+		return 'T';
+	default:
+		return 'X';
+	}
+}
+
+/*
+ * scsi_alua_rtpg - Evaluate REPORT TARGET GROUP STATES
+ * @sdev: the device to be evaluated.
+ *
+ * Evaluate the Target Port Group State.
+ * Returns -ENODEV if the path is
+ * found to be unusable.
+ */
+__maybe_unused
+static int scsi_alua_rtpg(struct scsi_device *sdev)
+{
+	struct alua_data *alua = sdev->alua;
+	struct scsi_sense_hdr sense_hdr;
+	int len, k, off, bufflen = ALUA_RTPG_SIZE;
+	int group_id_old, state_old, pref_old, valid_states_old;
+	unsigned char *desc, *buff;
+	unsigned err;
+	int retval;
+	unsigned int tpg_desc_tbl_off;
+	unsigned char orig_transition_tmo;
+	unsigned long flags;
+	bool transitioning_sense = false;
+	int rel_port, group_id = scsi_vpd_tpg_id(sdev, &rel_port);
+
+	if (group_id < 0) {
+		/*
+		 * Internal error; TPGS supported but required
+		 * VPD identification descriptors not present.
+		 * Disable ALUA support
+		 */
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: No target port descriptors found\n",
+			    DRV_NAME);
+		return -EOPNOTSUPP; //SCSI_DH_DEV_UNSUPP;
+	}
+
+	group_id_old = alua->group_id;
+	state_old = alua->state;
+	pref_old = alua->pref;
+	valid_states_old = alua->valid_states;
+
+	if (!alua->expiry) {
+		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
+
+		if (alua->transition_tmo)
+			transition_tmo = alua->transition_tmo * HZ;
+
+		alua->expiry = round_jiffies_up(jiffies + transition_tmo);
+	}
+
+	buff = kzalloc(bufflen, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+ retry:
+	err = 0;
+	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr);
+
+	if (retval) {
+		/*
+		 * Some (broken) implementations have a habit of returning
+		 * an error during things like firmware update etc.
+		 * But if the target only supports active/optimized there's
+		 * not much we can do; it's not that we can switch paths
+		 * or anything.
+		 * So ignore any errors to avoid spurious failures during
+		 * path failover.
+		 */
+		if ((alua->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: ignoring rtpg result %d\n",
+				    DRV_NAME, retval);
+			kfree(buff);
+			return 0;//SCSI_DH_OK
+		}
+		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: rtpg failed, result %d\n",
+				    DRV_NAME, retval);
+			kfree(buff);
+			if (retval < 0)
+				return -EBUSY;//SCSI_DH_DEV_TEMP_BUSY;
+			if (host_byte(retval) == DID_NO_CONNECT)
+				return -ENOENT;//SCSI_DH_RES_TEMP_UNAVAIL;
+			return -EIO;//SCSI_DH_IO
+		}
+
+		/*
+		 * submit_rtpg() has failed on existing arrays
+		 * when requesting extended header info, and
+		 * the array doesn't support extended headers,
+		 * even though it shouldn't according to T10.
+		 * The retry without rtpg_ext_hdr_req set
+		 * handles this.
+		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
+		 * with ASC 00h if they don't support the extended header.
+		 */
+		if (!alua->rtpg_ext_hdr_unsupp &&
+		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
+			alua->rtpg_ext_hdr_unsupp = true;
+			goto retry;
+		}
+		/*
+		 * If the array returns with 'ALUA state transition'
+		 * sense code here it cannot return RTPG data during
+		 * transition. So set the state to 'transitioning' directly.
+		 */
+		if (sense_hdr.sense_key == NOT_READY &&
+		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
+			transitioning_sense = true;
+			goto skip_rtpg;
+		}
+		/*
+		 * Retry on any other UNIT ATTENTION occurred.
+		 */
+		if (sense_hdr.sense_key == UNIT_ATTENTION)
+			err = -EAGAIN;//SCSI_DH_RETRY
+		if (err == -EAGAIN &&
+		    alua->expiry != 0 && time_before(jiffies, alua->expiry)) {
+			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
+				    DRV_NAME);
+			scsi_print_sense_hdr(sdev, DRV_NAME, &sense_hdr);
+			kfree(buff);
+			return err;
+		}
+		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
+			    DRV_NAME);
+		scsi_print_sense_hdr(sdev, DRV_NAME, &sense_hdr);
+		kfree(buff);
+		alua->expiry = 0;
+		return -EIO;//SCSI_DH_IO
+	}
+
+	len = get_unaligned_be32(&buff[0]) + 4;
+
+	if (len > bufflen) {
+		/* Resubmit with the correct length */
+		kfree(buff);
+		bufflen = len;
+		buff = kmalloc(bufflen, GFP_KERNEL);
+		if (!buff) {
+			sdev_printk(KERN_WARNING, sdev,
+				    "%s: kmalloc buffer failed\n",__func__);
+			/* Temporary failure, bypass */
+			alua->expiry = 0;
+			return -EBUSY;//SCSI_DH_DEV_TEMP_BUSY;
+		}
+		goto retry;
+	}
+
+	orig_transition_tmo = alua->transition_tmo;
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
+		alua->transition_tmo = buff[5];
+	else
+		alua->transition_tmo = ALUA_FAILOVER_TIMEOUT;
+
+	if (orig_transition_tmo != alua->transition_tmo) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: transition timeout set to %d seconds\n",
+			    DRV_NAME, alua->transition_tmo);
+		alua->expiry = jiffies + alua->transition_tmo * HZ;
+	}
+
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
+		tpg_desc_tbl_off = 8;
+	else
+		tpg_desc_tbl_off = 4;
+
+	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
+	     k < len;
+	     k += off, desc += off) {
+		u16 group_id_desc = get_unaligned_be16(&desc[2]);
+
+		spin_lock_irqsave(&alua->lock, flags);
+		if (group_id_desc == group_id) {
+			alua->group_id = group_id;
+			WRITE_ONCE(alua->state, desc[0] & 0x0f);
+			alua->pref = desc[0] >> 7;
+			WRITE_ONCE(sdev->access_state, desc[0]);
+			alua->valid_states = desc[1];
+		}
+		spin_unlock_irqrestore(&alua->lock, flags);
+		off = 8 + (desc[7] * 4);
+	}
+
+ skip_rtpg:
+	spin_lock_irqsave(&alua->lock, flags);
+	if (transitioning_sense)
+		alua->state = SCSI_ACCESS_STATE_TRANSITIONING;
+
+	if (group_id_old != alua->group_id || state_old != alua->state ||
+		pref_old != alua->pref || valid_states_old != alua->valid_states)
+		sdev_printk(KERN_INFO, sdev,
+			"%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
+			DRV_NAME, alua->group_id, print_alua_state(alua->state),
+			alua->pref ? "preferred" : "non-preferred",
+			alua->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
+			alua->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
+			alua->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
+			alua->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
+			alua->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
+			alua->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
+			alua->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
+
+	switch (alua->state) {
+	case SCSI_ACCESS_STATE_TRANSITIONING:
+		if (time_before(jiffies, alua->expiry)) {
+			/* State transition, retry */
+			alua->interval = ALUA_RTPG_RETRY_DELAY;
+			err = -EAGAIN;//SCSI_DH_RETRY
+		} else {
+			unsigned char access_state;
+
+			/* Transitioning time exceeded, set port to standby */
+			err = -EIO;//SCSI_DH_IO;
+			alua->state = SCSI_ACCESS_STATE_STANDBY;
+			alua->expiry = 0;
+			access_state = alua->state & SCSI_ACCESS_STATE_MASK;
+			if (alua->pref)
+				access_state |= SCSI_ACCESS_STATE_PREFERRED;
+			WRITE_ONCE(sdev->access_state, access_state);
+		}
+		break;
+	case SCSI_ACCESS_STATE_OFFLINE:
+		/* Path unusable */
+		err = -ENODEV;//SCSI_DH_DEV_OFFLINED;
+		alua->expiry = 0;
+		break;
+	default:
+		/* Useable path if active */
+		err = 0;//SCSI_DH_OK
+		alua->expiry = 0;
+		break;
+	}
+	spin_unlock_irqrestore(&alua->lock, flags);
+	kfree(buff);
+	return err;
+}
+
 int scsi_alua_sdev_init(struct scsi_device *sdev)
 {
 	int rel_port, ret, tpgs;
@@ -47,6 +357,7 @@ int scsi_alua_sdev_init(struct scsi_device *sdev)
 
 	sdev->alua->sdev = sdev;
 	sdev->alua->tpgs = tpgs;
+	spin_lock_init(&sdev->alua->lock);
 
 	return 0;
 out_free_data:
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
index 07cdcb4f5b518..068277261ed9d 100644
--- a/include/scsi/scsi_alua.h
+++ b/include/scsi/scsi_alua.h
@@ -16,7 +16,15 @@
 struct alua_data {
 	int			group_id;
 	int			tpgs;
+	int			state;
+	int			pref;
+	int			valid_states;
+	bool			rtpg_ext_hdr_unsupp;
+	unsigned char		transition_tmo;
+	unsigned long		expiry;
+	unsigned long		interval;
 	struct scsi_device	*sdev;
+	spinlock_t		lock;
 };
 
 int scsi_alua_sdev_init(struct scsi_device *sdev);
-- 
2.43.5

