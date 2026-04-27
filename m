Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE01314D35;
	Mon, 27 Apr 2026 11:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777290628; cv=fail; b=L9xunAMjHGwEUrGEH4fvddm1R7pWsKI0qbgnXnvK6r0q8ah2YLxwjK7WvnKc4kLeaGdpNE8FMpM8n1rZSipxAv52VP11PxX5VoGKmfHVLrmYTX0KIaka6wkviJT0WJVBwsSiiMiptProHxSOCPekgBcatmbK5/WGqdlxn37dlAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777290628; c=relaxed/simple;
	bh=WaROvd0vv0EGzfYn8jwnQU5wpQNPoBxLCdY1WytZOfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BFFrxx9GPDXlXDY4LBDM4JL23JSrqTKp7MLF7RUDWkfJR+MHhjo/23Z6ftHjyj5iVS1/DtYgUo/nVhYH/zphQxl3lpVWzWGl1qGlEErAoGs/OvQo8qBBpsjQciXw1npzklzUB66s9lb+5k0n/5MVz0TrxB76jFW6VVnz/0KDFaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HPpcdmjz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=arzpyBKH; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HPpcdmjz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="arzpyBKH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777290626; x=1808826626;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WaROvd0vv0EGzfYn8jwnQU5wpQNPoBxLCdY1WytZOfE=;
  b=HPpcdmjz2i8Vx/jOCBpL9HLTzzJmk1qPsR5QXq4YbJaOC90c1PCt5KXY
   3Vy50nHRUjr2+QRRt8UT3hH4qIPor2S+nGi7W1dtUMxw3yen4bSxMm70/
   O6COGen3+EjUUqs2+OKzI8Gj4eagseJZ+vWWRHkOgQACGt1+nMXx0blKW
   eKuJ5HKrrLtGnF5SATqcMQrFopYs0eLSuIleKSBkYKMnQf04Xe9WuFyve
   hkG2ghhT4YUrLw19fDBRbAm+jmUibIP0d09Mo8+6MtyRNOdS2vkLS8MRR
   o4zrbc1RJgJYcPI6Lg/D7z3yp4lC644msLvT2e+v4Xk+Fph+xzSSPByL0
   A==;
X-CSE-ConnectionGUID: nt+h5iekT5Cf0tp1WvcmcQ==
X-CSE-MsgGUID: P8PC4nDuTW+0layUEc1XJQ==
X-IronPort-AV: E=Sophos;i="6.23,202,1770566400"; 
   d="scan'208";a="141572125"
Received: from mail-eastus2azon11010063.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Apr 2026 19:50:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9OpnJp820tp5KW3HI85isXDf5HeE+MhbgjCPf4+LYwA88PME4MEWxXnUu+gLRjyt6FYokYAsZIZpgZIP9g762fRDpqXeM+NObF9YvRTX9bDqTiHOavGVzTyQGCcDjReXey5o+Xq14bGxivqCfQ9xTJOQB8WkyEZg0xIRWiTjFTkgsUq9WopgOx0CGfe5Puz24yyOjAj2kF1Z/4tr33YOWUqrMl5djow8Zo4i+bMfln0llgI/SKMTUPc/j2jV1HqrOOVC+w99t18SbPUY0N+lU6/8OISQBI9V8pOwZvbptMEXafy7pP/awhuO1RJgX2pOr1pBon0vNRQY/XdE1VKsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pvxrWr2KpMeKo0l0bA6UA1ovzvkvkkxbomh0nAk2+k=;
 b=dUNHt6YwbbX3qTLg3aN2iBJumYxGWwulQKLIRq/A4OokK5986XKJeHmcNp7PnQjqu4XOYFLNJP0iTLze59g5ef/QoLYbECHyZ0wvT+jADLdKISWZhJmCXmR91KWsl69pwYZo+NvjJo70PZsK/mLIqhcupBEcRtBFYKCwCKdEOvWuyO/yYiuv7CoRumpYZhYAT8KqOOKVOpGSoVB4pDtXvr6VplLQN83xOyGPaMLFjayzTVu8OEu2VIF0IwZOnZubFxm8OHzormCLcTedSuJDq48fJ9uVRqriYb0yz3GbyQ4QKAUY0MLFSPtwx7I9qZlxsjmpLeGRDb1TfghpYf6Q8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pvxrWr2KpMeKo0l0bA6UA1ovzvkvkkxbomh0nAk2+k=;
 b=arzpyBKHwZtW5VbfIebEYrNHd5FruOJO60nERLPjGbNu8fJqFzgX00pIXCq0uYU7MrkrJbTED0PlSnbpspWUdTY2rxrIVfhAri0uGuOMA5J9l470wJsb4cKDu0v79aeBFPlhACiEEOI5TCpqd5O2QHt6Oiegz6DZTPeS3N0lqKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DS1PR04MB9560.namprd04.prod.outlook.com (2603:10b6:8:21a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Mon, 27 Apr
 2026 11:50:20 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 11:50:19 +0000
Date: Mon, 27 Apr 2026 20:50:11 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Daniel Wagner <dwagner@suse.de>, 
	Chaitanya Kulkarni <chaitanyak@nvidia.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, 
	Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	"sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Christian Brauner <brauner@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>, "willy@infradead.org" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, "amir73il@gmail.com" <amir73il@gmail.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
Message-ID: <ae9KM8mYjUTvlu31@shinmob>
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local>
 <aY77ogf5nATlJUg_@shinmob>
 <901f4daf-3226-416f-8741-dd15573e736b@linux.ibm.com>
 <aecTw6IYs1fo26EX@shinmob>
 <d6282aa7-4673-4bae-a0ff-fbd84f0a610f@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6282aa7-4673-4bae-a0ff-fbd84f0a610f@linux.ibm.com>
X-ClientProxiedBy: TYCP286CA0092.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b4::10) To SN7PR04MB8532.namprd04.prod.outlook.com
 (2603:10b6:806:350::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR04MB8532:EE_|DS1PR04MB9560:EE_
X-MS-Office365-Filtering-Correlation-Id: f979273c-bbe0-4aea-586c-08dea45327f1
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TPNlRU983pu5AtK3sOrQuWLLbvNRnRpuHoDVkK6K4/WLzD9rB/0JRxKl2SWhFDm+sFGf9FBN8meG6fcnaDTg1s7GbWLqd3BBcZGvAYx6HXvR2lsAcGOswbZfe0HnTPsQwg8dNfRIHXz/UCh009TjKaaLN9LO4krxdTg2NXwSZ8KcDcnTOwMfb3745dPy5/dgOsMNBzf3GyYscH7/xzipWuHl2JzM1oEXHxjvAVsVrcTRIEZoXT8ilAnlw6Eiy5R39z27gtn9EMyb03kJiaiSkZiyme1PnsPgKksUTjCCJNDp5xKO1CjOviLRcetgufO/wBMC+rPAdThYesrzYTUbZ3AVxRysvJFXoqqWCnQuHDQuK9k6YAOSJukyBY77YUL1+GWtpBgQN+EwSKux2EICV6iFXYGCExWqHpGnaGLrELekYBpsRekwUQd1YRfNm9fJM3V44SGL/C6Z6r0n/T1BJYAj9M2DA+EUE4MrBFRdMkgdSzA7q7b5qpIMkoZpO2ybeAdrNlFQ75Pf/RFGd3sZpeKC2jTbwEZ/VfU8fp9awuQHeN+FIR9JwOYSrCdwqBLpWilWq7M/JdcizMN+M02GnzKKU8JFifNiC8YMRV4X4I2QMvA3q/+GTYrxdVNoH0pmIBuZBp9Ki07oIGdnGTCiAB12tI7yG7ISBusJSnzK7r2QQQ9x37bgIjuHo+nckoyrdTzUftYTlgh+ctJk0Znconpjt54EakdiAjLssB4JR39yORNr8msbm3wkr/e9v7rQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CaZ5MLnYqzQvVSj3Nu6+48ZhrAlW7Gazbfy/SB7ELDzPoxRfqTNxkRqPb217?=
 =?us-ascii?Q?NeFD0joIZwVukFM3hqTyrX/2rpqIkgGcli089lpKlj4ukyZ17phV7YoNTuEH?=
 =?us-ascii?Q?D3I/LuwJ0AJeSAsZtqotdXGpRWC7E7J9KuwxoLweJqntIkmc+PnMgRwYNsoD?=
 =?us-ascii?Q?Pt4txOrAOldpd5k2DrmjFKaWQGcplnEiOlwPx6SQ7DXwwE6+awFZIZpCxY6o?=
 =?us-ascii?Q?Dd1L5rAt3Y5XXFldGMQ6nL6KPIO3sSiGxEsrF3hmgyjimNhsK+EFnBJo3xTC?=
 =?us-ascii?Q?sx5/OVxsCF3y5O0f9rbxlJ9URDwqQRJjQBSbFiZklbA0E0BtHmRztD+MYRe/?=
 =?us-ascii?Q?rwwpoOkKsH4hVqP+pR5gX7FbyDC2CddwHE75d0QyLWavkSzOZAChGrUrEzXX?=
 =?us-ascii?Q?+Sgvk4n3etqKQ5mk7pVjn962L9cC9BQpn3Jfd0HgXbK0B2gBCIeBo5SpWMbJ?=
 =?us-ascii?Q?+dM2NzS9YTusQmVL6t7139JB/uJaHJ6HZD5ZfUsCg/7KAMt08jFATdYmyfTy?=
 =?us-ascii?Q?EIWmMN6WVNTiAuv9w93qMeD3GP0dxdCAtnKeF0oLzsyf4JeTQYNZg+I41p1q?=
 =?us-ascii?Q?PsPyCn3vhN5lmuasJXnueQzdhFF5UgcZQKTLtZQD1cLbPx/OVT6pzGqtEXIG?=
 =?us-ascii?Q?p6fYJNopK98Dyvsc1/SWjeyoz4D1iNVLU2gl70N0cNs7h7XinemOr8rRXQxV?=
 =?us-ascii?Q?QoSFA1ao+NxSa1NiefCySuXMw4HqpL2jahK5t5TwguHL8R2Xbu563tkizmeu?=
 =?us-ascii?Q?BlghrUFF7KaG1EcdgbPvQ20/qUrveYSaTjMHAJfIsBIjybNjyDJ/vLzO+su0?=
 =?us-ascii?Q?5wO/wH9387q0kK4GvsOoGFP2kB+y6X2Sc+hRzvQ55m1TsCx/JYWanjy1ncSk?=
 =?us-ascii?Q?cjgrlMaFvNFaz/MsoC6Weyv+l1MFPpVI0/v3Z+JB7unClSHapWzJaB4KheAK?=
 =?us-ascii?Q?Wlxk1TOW+uGaYB74YwM5G0X1REnQWfFkW0Xy2LCg8iilCJfrstWEIUSoPkNx?=
 =?us-ascii?Q?tnw1Lh0o5HuHSxYmptZNA4teo6w5Nbc/Q0p6V7Gs6GBiOKSutzWYYu1bIceA?=
 =?us-ascii?Q?nLbGhfnA4K0j1DlhS7QOJPDW8cRwA0vyyfQdqrYya/u1p005vKVrw9GCO7xt?=
 =?us-ascii?Q?CIocjDM3MDRU8cWK7Gr7p0jzmQBomh/IA3gDME0TJeH2hyfc9WonuK+jJcxE?=
 =?us-ascii?Q?b4u+2xAdYSgPY+ttDbjwfdBCcBHVOsJjYBnZ/mmtD3dYHpVEkgHXeYSwD7Mm?=
 =?us-ascii?Q?XE/pyJjZWPTWHmC9VHn1V0QhJ5j8I8u7jmgbljmxiso156IUTS4t+IBX2Qkx?=
 =?us-ascii?Q?lUB5JRUF2j+eMTPNs6sgQBibsbk4Rs8PuAAG9oWP8m+IckElOzMaMMTF2WYM?=
 =?us-ascii?Q?dVU8b8YiC2QEeiyxvntriveNqVtS1zcU6NUo/7XYgWKkWCoXTDJMS4i7QrJR?=
 =?us-ascii?Q?c8z9miTOKXTrt2FRy4yeDr5q6q5r6ZOY3Ng16vFK6/tOGursk6pu8pZuqVKo?=
 =?us-ascii?Q?zoGSdM++UYUZ5wdKrG7ipDfryZVy7LtL+sa65b3ywVdmtJ6MIwZZLGoP+R79?=
 =?us-ascii?Q?NSSmMtmBg5sURS6oN3iitG5y94vzRrkzufg8tXJIgORHw1PZgOMItCt5msAa?=
 =?us-ascii?Q?EIjsadMxSJfJ8+9rQH1vfrYiWBbJ1PtKolOmlHtqnmJe/cymonbYlDVMy9Hv?=
 =?us-ascii?Q?3Pl3qQA6jyP4ShETzbbHH11g9DAUxEpeAM3yvAeUAyXPMJ2qCcrxqmOJWNSU?=
 =?us-ascii?Q?XyXdzM/6WrhfiWR/qmNbIYwJYp30Pl8=3D?=
X-Exchange-RoutingPolicyChecked:
	eHVTxhGNF4ssG9XVPpXuXCAcNrVtPhQGklPICQ/ZlyLPqbXf/qFIrkQXjFC93Bzg8aWtBL8oJwpUPiLUG8QnvMdTlyTAtlF+IN3zQ93ikH6csFs9mmnLuMcu9141n53PshZyWGmMiSrIEPFupnz/hn2nZsAKH59ntx4QK/J+AQ2Yj+9BbxV1zke1rMHSj36QhQGKQU+S/2cdbriJBywHldIwAdVPXXv97OPP8kD0ul/0u97fci/gOqGVMuuoPg4Bx9Yawt3IKZDhx9YAZcjliA7fl0GQHnxe7hC6TxIjRs12U5kRJRRvsA4J2dHolokJwEjbzj+Yg3iLKx5XjG1rIQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YUmJNsU4nMsKpJmXE8arfcMzhc3KbDT54LOMj70IPDWkAoLzcs/Yx97Ktc0r8JhSv5PJgDhpN10Lm/Drgr3MOAV9V8tL0C/6x77x+aatD/qT+70JGRCtziu+LMPbdUveYr02EDH//wR7KI6wZjfwI016V7YSB8XPrr0SAN8qJ+ALbwNesaex6JZV77kQb3+1JJ3CHn9YZP9Orq9s1xU0YyjkwfHOzuWuTUrGqvKQnWKMSuwJWXOaYn0RP2uQVBmUbtI3K8ZixRh0C8vWHyY6VJsLEZhAYmBk8F1wqummNMnICt75JDEz196Q+CoU2Z8XD1m0UfNxG7xJhoJpPhoOSLwHcLJgiKNYR2DhlPN2V6JFGaD8hPRYfFi5jCJGypo9/+lbbnCwfrSE3AjzWwto27uowet/Hs6no9ivAQ9YO1kAiq6iOnGMvzBk3knUpUCZaVS+J+T+eIwN5C096M+y9yUOnFQ/Q15ihu7AMY9WNKXEhCfA1lzNybzhSF5uXnQAwWEW3KnYM25JY3pkaCzErx7x0PvpY7U/y8RYtDPwqgs6ZdGXH3IhcDgp3vsZY6yoP/k+4VsWREWIVKQuICQu3KRmV56iI+mneMPoYdU5xyqtETMggSruzI90aAVfn1NU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f979273c-bbe0-4aea-586c-08dea45327f1
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 11:50:19.7628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CE09WZOT8I7IeE9RttuA0yz93Y/MO9APN+dEpY+VCZKwoG+bcGBOvz3dNHJ+8C2mvIpuPl8+Hqos6m3yHA8W94BUL+iNZyyUSmwCnHUB11Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9560

On Apr 23, 2026 / 13:35, Nilay Shroff wrote:
> On 4/21/26 11:49 AM, Shin'ichiro Kawasaki wrote:
> > On Feb 16, 2026 / 00:08, Nilay Shroff wrote:
> > > On 2/13/26 4:53 PM, Shinichiro Kawasaki wrote:
[...]
> > > >   4. Long standing failures make test result reports dirty
> > > >      - I feel lockdep WARNs are tend to be left unfixed rather long period.
> > > >        How can we gather effort to fix them?
> > > 
> > > I agree regarding lockdep; recently we did see quite a few lockdep splats.
> > > That said, I believe the number has dropped significantly and only a small
> > > set remains. From what I can tell, most of the outstanding lockdep issues
> > > are related to fs-reclaim paths recursing into the block layer while the
> > > queue is frozen. We should be able to resolve most of these soon, or at
> > > least before the conference. If anything is still outstanding after that,
> > > we can discuss it during the conference and work toward addressing it as
> > > quickly as possible.
> > 
> > Taking this chance, I'd like to express my appreciation for the effort to
> > resolve the lockdep issues. It is great that a number of lockdeps are already
> > fixed. Said that, two lockdep issues are still observed with v7.0 kernel at
> > nvme/005 and nbd/002 [1]. I would like to gather attentions to the failures.
> > 
> > [1] https://lore.kernel.org/linux-block/ynmi72x5wt5ooljjafebhcarit3pvu6axkslqenikb2p5txe57@ldytqa2t4i2x/
> > 
> I think nvme/005 and nbd/002 failures shall be addressed with this
> patch: https://lore.kernel.org/all/20260413171628.6204-1-kch@nvidia.com/
> 
> It's currently applied to nvme-7.1 and not there yet to mainline kernel.

Ah, I missed that patch. Thanks a lot, Chaitanya!

Today, I applied the nvme fix patch on top of v7.1-rc1, and ran nvme/005 with
tcp transport. Unfortunately, I still observe the lockdep splat for
&q->elevator_lock, &q->q_usage_counter(io) and set->srcu [*]. This time, the
call chain looks a bit different (cpu_hotplug_lock is involved?).

I also still observe the nbd/002 failure. The nvme fix patch does not affect
nbd, then I think it is expected that the nbd/002 failure is still there.


[*]

Apr 27 20:32:07 testnode1 unknown: run blktests nvme/005 at 2026-04-27 20:32:07
Apr 27 20:32:08 testnode1 kernel: loop0: detected capacity change from 0 to 2097152
Apr 27 20:32:08 testnode1 kernel: nvmet: adding nsid 1 to subsystem blktests-subsystem-1
Apr 27 20:32:08 testnode1 kernel: nvmet_tcp: enabling port 0 (127.0.0.1:4420)
Apr 27 20:32:08 testnode1 kernel: nvmet: Created nvm controller 1 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349.
Apr 27 20:32:08 testnode1 kernel: nvme nvme5: creating 4 I/O queues.
Apr 27 20:32:08 testnode1 kernel: nvme nvme5: mapped 4/0/0 default/read/poll queues.
Apr 27 20:32:08 testnode1 kernel: nvme nvme5: new ctrl: NQN "blktests-subsystem-1", addr 127.0.0.1:4420, hostnqn: nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349
Apr 27 20:32:08 testnode1 kernel: nvmet: Created nvm controller 2 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:0f01fb42-9f7f-4856-b0b3-51e60b8de349.
Apr 27 20:32:08 testnode1 kernel: nvme nvme5: creating 4 I/O queues.
Apr 27 20:32:08 testnode1 kernel: nvme nvme5: mapped 4/0/0 default/read/poll queues.
Apr 27 20:32:08 testnode1 kernel: nvme nvme5: Removing ctrl: NQN "blktests-subsystem-1"
Apr 27 20:32:08 testnode1 kernel: 
Apr 27 20:32:08 testnode1 kernel: ======================================================
Apr 27 20:32:08 testnode1 kernel: WARNING: possible circular locking dependency detected
Apr 27 20:32:08 testnode1 kernel: 7.1.0-rc1+ #3 Not tainted
Apr 27 20:32:08 testnode1 kernel: ------------------------------------------------------
Apr 27 20:32:08 testnode1 kernel: nvme/1171 is trying to acquire lock:
Apr 27 20:32:08 testnode1 kernel: ffff888121e8bb98 (set->srcu){.+.+}-{0:0}, at: __synchronize_srcu+0x21/0x2b0
Apr 27 20:32:08 testnode1 kernel: 
                                  but task is already holding lock:
Apr 27 20:32:08 testnode1 kernel: ffff88812ab7bd68 (&q->elevator_lock){+.+.}-{4:4}, at: elevator_change+0x188/0x4f0
Apr 27 20:32:08 testnode1 kernel: 
                                  which lock already depends on the new lock.
Apr 27 20:32:08 testnode1 kernel: 
                                  the existing dependency chain (in reverse order) is:
Apr 27 20:32:08 testnode1 kernel: 
                                  -> #5 (&q->elevator_lock){+.+.}-{4:4}:
Apr 27 20:32:08 testnode1 kernel:        __mutex_lock+0x1ae/0x2600
Apr 27 20:32:08 testnode1 kernel:        elevator_change+0x188/0x4f0
Apr 27 20:32:08 testnode1 kernel:        elv_iosched_store+0x308/0x390
Apr 27 20:32:08 testnode1 kernel:        queue_attr_store+0x23b/0x360
Apr 27 20:32:08 testnode1 kernel:        kernfs_fop_write_iter+0x3d6/0x5e0
Apr 27 20:32:08 testnode1 kernel:        vfs_write+0x52c/0xf80
Apr 27 20:32:08 testnode1 kernel:        ksys_write+0xfb/0x200
Apr 27 20:32:08 testnode1 kernel:        do_syscall_64+0xdd/0x14c0
Apr 27 20:32:08 testnode1 kernel:        entry_SYSCALL_64_after_hwframe+0x76/0x7e
Apr 27 20:32:08 testnode1 kernel: 
                                  -> #4 (&q->q_usage_counter(io)){++++}-{0:0}:
Apr 27 20:32:08 testnode1 kernel:        blk_alloc_queue+0x5b3/0x730
Apr 27 20:32:08 testnode1 kernel:        blk_mq_alloc_queue+0x13f/0x250
Apr 27 20:32:08 testnode1 kernel:        scsi_alloc_sdev+0x84e/0xca0
Apr 27 20:32:08 testnode1 kernel:        scsi_probe_and_add_lun+0x63f/0xc30
Apr 27 20:32:08 testnode1 kernel:        __scsi_add_device+0x1be/0x1f0
Apr 27 20:32:08 testnode1 kernel:        ata_scsi_scan_host+0x139/0x3a0
Apr 27 20:32:08 testnode1 kernel:        async_run_entry_fn+0x93/0x550
Apr 27 20:32:08 testnode1 kernel:        process_one_work+0x8b4/0x1640
Apr 27 20:32:08 testnode1 kernel:        worker_thread+0x606/0xff0
Apr 27 20:32:08 testnode1 kernel:        kthread+0x368/0x460
Apr 27 20:32:08 testnode1 kernel:        ret_from_fork+0x653/0x9d0
Apr 27 20:32:08 testnode1 kernel:        ret_from_fork_asm+0x1a/0x30
Apr 27 20:32:08 testnode1 kernel: 
                                  -> #3 (fs_reclaim){+.+.}-{0:0}:
Apr 27 20:32:08 testnode1 kernel:        fs_reclaim_acquire+0xd5/0x120
Apr 27 20:32:08 testnode1 kernel:        __kmalloc_cache_node_noprof+0x51/0x740
Apr 27 20:32:08 testnode1 kernel:        create_worker+0xfb/0x710
Apr 27 20:32:08 testnode1 kernel:        workqueue_prepare_cpu+0x87/0xe0
Apr 27 20:32:08 testnode1 kernel:        cpuhp_invoke_callback+0x2a7/0x1230
Apr 27 20:32:08 testnode1 kernel:        __cpuhp_invoke_callback_range+0xbd/0x1f0
Apr 27 20:32:08 testnode1 kernel:        _cpu_up+0x2ec/0x700
Apr 27 20:32:08 testnode1 kernel:        cpu_up+0x111/0x190
Apr 27 20:32:08 testnode1 kernel:        cpuhp_bringup_mask+0xd3/0x110
Apr 27 20:32:08 testnode1 kernel:        bringup_nonboot_cpus+0x139/0x170
Apr 27 20:32:08 testnode1 kernel:        smp_init+0x27/0xe0
Apr 27 20:32:08 testnode1 kernel:        kernel_init_freeable+0x445/0x6f0
Apr 27 20:32:08 testnode1 kernel:        kernel_init+0x18/0x150
Apr 27 20:32:08 testnode1 kernel:        ret_from_fork+0x653/0x9d0
Apr 27 20:32:08 testnode1 kernel:        ret_from_fork_asm+0x1a/0x30
Apr 27 20:32:08 testnode1 kernel: 
                                  -> #2 (cpu_hotplug_lock){++++}-{0:0}:
Apr 27 20:32:08 testnode1 kernel:        cpus_read_lock+0x3c/0xe0
Apr 27 20:32:08 testnode1 kernel:        static_key_disable+0x12/0x30
Apr 27 20:32:08 testnode1 kernel:        __inet_hash_connect+0x10f7/0x1a50
Apr 27 20:32:08 testnode1 kernel:        tcp_v4_connect+0xcb0/0x18b0
Apr 27 20:32:08 testnode1 kernel:        __inet_stream_connect+0x349/0xf00
Apr 27 20:32:08 testnode1 kernel:        inet_stream_connect+0x55/0xb0
Apr 27 20:32:08 testnode1 kernel:        kernel_connect+0xdf/0x140
Apr 27 20:32:08 testnode1 kernel:        nvme_tcp_alloc_queue+0xa48/0x1b60 [nvme_tcp]
Apr 27 20:32:08 testnode1 kernel:        nvme_tcp_alloc_admin_queue+0xff/0x440 [nvme_tcp]
Apr 27 20:32:08 testnode1 kernel:        nvme_tcp_setup_ctrl+0x8a/0x830 [nvme_tcp]
Apr 27 20:32:08 testnode1 kernel:        nvme_tcp_create_ctrl+0x834/0xb90 [nvme_tcp]
Apr 27 20:32:08 testnode1 kernel:        nvmf_dev_write+0x3e3/0x800 [nvme_fabrics]
Apr 27 20:32:08 testnode1 kernel:        vfs_write+0x1cc/0xf80
Apr 27 20:32:08 testnode1 kernel:        ksys_write+0xfb/0x200
Apr 27 20:32:08 testnode1 kernel:        do_syscall_64+0xdd/0x14c0
Apr 27 20:32:08 testnode1 kernel:        entry_SYSCALL_64_after_hwframe+0x76/0x7e
Apr 27 20:32:08 testnode1 kernel: 
                                  -> #1 (sk_lock-AF_INET-NVME){+.+.}-{0:0}:
Apr 27 20:32:08 testnode1 kernel:        lock_sock_nested+0x32/0xf0
Apr 27 20:32:08 testnode1 kernel:        tcp_sendmsg+0x1c/0x50
Apr 27 20:32:08 testnode1 kernel:        sock_sendmsg+0x2bd/0x370
Apr 27 20:32:08 testnode1 kernel:        nvme_tcp_try_send_cmd_pdu+0x57f/0xbd0 [nvme_tcp]
Apr 27 20:32:08 testnode1 kernel:        nvme_tcp_try_send+0x1b3/0x9c0 [nvme_tcp]
Apr 27 20:32:08 testnode1 kernel:        nvme_tcp_queue_rq+0xf77/0x1970 [nvme_tcp]
Apr 27 20:32:08 testnode1 kernel:        blk_mq_dispatch_rq_list+0x39b/0x2340
Apr 27 20:32:08 testnode1 kernel:        __blk_mq_sched_dispatch_requests+0x1dd/0x1510
Apr 27 20:32:08 testnode1 kernel:        blk_mq_sched_dispatch_requests+0xa8/0x150
Apr 27 20:32:08 testnode1 kernel:        blk_mq_run_work_fn+0x127/0x2c0
Apr 27 20:32:08 testnode1 kernel:        process_one_work+0x8b4/0x1640
Apr 27 20:32:08 testnode1 kernel:        worker_thread+0x606/0xff0
Apr 27 20:32:08 testnode1 kernel:        kthread+0x368/0x460
Apr 27 20:32:08 testnode1 kernel:        ret_from_fork+0x653/0x9d0
Apr 27 20:32:08 testnode1 kernel:        ret_from_fork_asm+0x1a/0x30
Apr 27 20:32:08 testnode1 kernel: 
                                  -> #0 (set->srcu){.+.+}-{0:0}:
Apr 27 20:32:08 testnode1 kernel:        __lock_acquire+0x14a6/0x2230
Apr 27 20:32:08 testnode1 kernel:        lock_sync+0xbd/0x120
Apr 27 20:32:08 testnode1 kernel:        __synchronize_srcu+0xa1/0x2b0
Apr 27 20:32:08 testnode1 kernel:        elevator_switch+0x2a5/0x680
Apr 27 20:32:08 testnode1 kernel:        elevator_change+0x2d8/0x4f0
Apr 27 20:32:08 testnode1 kernel:        elevator_set_none+0x87/0xd0
Apr 27 20:32:08 testnode1 kernel:        blk_unregister_queue+0x13f/0x2b0
Apr 27 20:32:08 testnode1 kernel:        __del_gendisk+0x263/0x9e0
Apr 27 20:32:08 testnode1 kernel:        del_gendisk+0x102/0x190
Apr 27 20:32:08 testnode1 kernel:        nvme_ns_remove+0x32a/0x900 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:        nvme_remove_namespaces+0x263/0x3b0 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:        nvme_do_delete_ctrl+0xf5/0x160 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:        nvme_delete_ctrl_sync.cold+0x8/0xd [nvme_core]
Apr 27 20:32:08 testnode1 kernel:        nvme_sysfs_delete+0x96/0xc0 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:        kernfs_fop_write_iter+0x3d6/0x5e0
Apr 27 20:32:08 testnode1 kernel:        vfs_write+0x52c/0xf80
Apr 27 20:32:08 testnode1 kernel:        ksys_write+0xfb/0x200
Apr 27 20:32:08 testnode1 kernel:        do_syscall_64+0xdd/0x14c0
Apr 27 20:32:08 testnode1 kernel:        entry_SYSCALL_64_after_hwframe+0x76/0x7e
Apr 27 20:32:08 testnode1 kernel: 
                                  other info that might help us debug this:
Apr 27 20:32:08 testnode1 kernel: Chain exists of:
                                    set->srcu --> &q->q_usage_counter(io) --> &q->elevator_lock
Apr 27 20:32:08 testnode1 kernel:  Possible unsafe locking scenario:
Apr 27 20:32:08 testnode1 kernel:        CPU0                    CPU1
Apr 27 20:32:08 testnode1 kernel:        ----                    ----
Apr 27 20:32:08 testnode1 kernel:   lock(&q->elevator_lock);
Apr 27 20:32:08 testnode1 kernel:                                lock(&q->q_usage_counter(io));
Apr 27 20:32:08 testnode1 kernel:                                lock(&q->elevator_lock);
Apr 27 20:32:08 testnode1 kernel:   sync(set->srcu);
Apr 27 20:32:08 testnode1 kernel: 
                                   *** DEADLOCK ***
Apr 27 20:32:08 testnode1 kernel: 5 locks held by nvme/1171:
Apr 27 20:32:08 testnode1 kernel:  #0: ffff88810868e410 (sb_writers#4){.+.+}-{0:0}, at: ksys_write+0xfb/0x200
Apr 27 20:32:08 testnode1 kernel:  #1: ffff88814e03f080 (&of->mutex#2){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x257/0x5e0
Apr 27 20:32:08 testnode1 kernel:  #2: ffff88814e3f84b8 (kn->active#140){++++}-{0:0}, at: sysfs_remove_file_self+0x61/0xb0
Apr 27 20:32:08 testnode1 kernel:  #3: ffff8881073281c8 (&set->update_nr_hwq_lock){++++}-{4:4}, at: del_gendisk+0xfa/0x190
Apr 27 20:32:08 testnode1 kernel:  #4: ffff88812ab7bd68 (&q->elevator_lock){+.+.}-{4:4}, at: elevator_change+0x188/0x4f0
Apr 27 20:32:08 testnode1 kernel: 
                                  stack backtrace:
Apr 27 20:32:08 testnode1 kernel: CPU: 3 UID: 0 PID: 1171 Comm: nvme Not tainted 7.1.0-rc1+ #3 PREEMPT(full) 
Apr 27 20:32:08 testnode1 kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-9.fc43 06/10/2025
Apr 27 20:32:08 testnode1 kernel: Call Trace:
Apr 27 20:32:08 testnode1 kernel:  <TASK>
Apr 27 20:32:08 testnode1 kernel:  dump_stack_lvl+0x6a/0x90
Apr 27 20:32:08 testnode1 kernel:  print_circular_bug.cold+0x185/0x1d0
Apr 27 20:32:08 testnode1 kernel:  check_noncircular+0x148/0x170
Apr 27 20:32:08 testnode1 kernel:  __lock_acquire+0x14a6/0x2230
Apr 27 20:32:08 testnode1 kernel:  lock_sync+0xbd/0x120
Apr 27 20:32:08 testnode1 kernel:  ? __synchronize_srcu+0x21/0x2b0
Apr 27 20:32:08 testnode1 kernel:  ? __synchronize_srcu+0x21/0x2b0
Apr 27 20:32:08 testnode1 kernel:  __synchronize_srcu+0xa1/0x2b0
Apr 27 20:32:08 testnode1 kernel:  ? __pfx___synchronize_srcu+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? kvm_clock_get_cycles+0x14/0x30
Apr 27 20:32:08 testnode1 kernel:  ? ktime_get_mono_fast_ns+0x193/0x490
Apr 27 20:32:08 testnode1 kernel:  ? lockdep_hardirqs_on+0x88/0x130
Apr 27 20:32:08 testnode1 kernel:  ? _raw_spin_unlock_irqrestore+0x4c/0x60
Apr 27 20:32:08 testnode1 kernel:  elevator_switch+0x2a5/0x680
Apr 27 20:32:08 testnode1 kernel:  elevator_change+0x2d8/0x4f0
Apr 27 20:32:08 testnode1 kernel:  elevator_set_none+0x87/0xd0
Apr 27 20:32:08 testnode1 kernel:  ? __pfx_elevator_set_none+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? kobject_put+0x5a/0x4e0
Apr 27 20:32:08 testnode1 kernel:  blk_unregister_queue+0x13f/0x2b0
Apr 27 20:32:08 testnode1 kernel:  __del_gendisk+0x263/0x9e0
Apr 27 20:32:08 testnode1 kernel:  ? down_read+0x13b/0x480
Apr 27 20:32:08 testnode1 kernel:  ? __pfx___del_gendisk+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? __pfx_down_read+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? up_write+0x294/0x510
Apr 27 20:32:08 testnode1 kernel:  del_gendisk+0x102/0x190
Apr 27 20:32:08 testnode1 kernel:  nvme_ns_remove+0x32a/0x900 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:  nvme_remove_namespaces+0x263/0x3b0 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:  ? __pfx_nvme_remove_namespaces+0x10/0x10 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:  nvme_do_delete_ctrl+0xf5/0x160 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:  nvme_delete_ctrl_sync.cold+0x8/0xd [nvme_core]
Apr 27 20:32:08 testnode1 kernel:  nvme_sysfs_delete+0x96/0xc0 [nvme_core]
Apr 27 20:32:08 testnode1 kernel:  ? __pfx_sysfs_kf_write+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  kernfs_fop_write_iter+0x3d6/0x5e0
Apr 27 20:32:08 testnode1 kernel:  ? __pfx_kernfs_fop_write_iter+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  vfs_write+0x52c/0xf80
Apr 27 20:32:08 testnode1 kernel:  ? __pfx_vfs_write+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? kasan_save_free_info+0x37/0x70
Apr 27 20:32:08 testnode1 kernel:  ? __kasan_slab_free+0x67/0x80
Apr 27 20:32:08 testnode1 kernel:  ? kmem_cache_free+0x14c/0x670
Apr 27 20:32:08 testnode1 kernel:  ? do_sys_openat2+0xfd/0x170
Apr 27 20:32:08 testnode1 kernel:  ? __x64_sys_openat+0x10a/0x210
Apr 27 20:32:08 testnode1 kernel:  ksys_write+0xfb/0x200
Apr 27 20:32:08 testnode1 kernel:  ? __pfx_ksys_write+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  do_syscall_64+0xdd/0x14c0
Apr 27 20:32:08 testnode1 kernel:  ? kasan_quarantine_put+0xff/0x220
Apr 27 20:32:08 testnode1 kernel:  ? lockdep_hardirqs_on+0x88/0x130
Apr 27 20:32:08 testnode1 kernel:  ? kasan_quarantine_put+0xff/0x220
Apr 27 20:32:08 testnode1 kernel:  ? kasan_quarantine_put+0xff/0x220
Apr 27 20:32:08 testnode1 kernel:  ? do_sys_openat2+0xfd/0x170
Apr 27 20:32:08 testnode1 kernel:  ? kmem_cache_free+0x14c/0x670
Apr 27 20:32:08 testnode1 kernel:  ? do_sys_openat2+0xfd/0x170
Apr 27 20:32:08 testnode1 kernel:  ? __pfx_do_sys_openat2+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? kmem_cache_free+0x14c/0x670
Apr 27 20:32:08 testnode1 kernel:  ? __x64_sys_openat+0x10a/0x210
Apr 27 20:32:08 testnode1 kernel:  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
Apr 27 20:32:08 testnode1 kernel:  ? __pfx___x64_sys_openat+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? rcu_is_watching+0x11/0xb0
Apr 27 20:32:08 testnode1 kernel:  ? do_syscall_64+0x1ea/0x14c0
Apr 27 20:32:08 testnode1 kernel:  ? lockdep_hardirqs_on+0x88/0x130
Apr 27 20:32:08 testnode1 kernel:  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
Apr 27 20:32:08 testnode1 kernel:  ? do_syscall_64+0x208/0x14c0
Apr 27 20:32:08 testnode1 kernel:  ? __pfx___x64_sys_openat+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? __pfx___x64_sys_openat+0x10/0x10
Apr 27 20:32:08 testnode1 kernel:  ? rcu_is_watching+0x11/0xb0
Apr 27 20:32:08 testnode1 kernel:  ? do_syscall_64+0x1ea/0x14c0
Apr 27 20:32:08 testnode1 kernel:  ? lockdep_hardirqs_on+0x88/0x130
Apr 27 20:32:08 testnode1 kernel:  ? do_syscall_64+0x208/0x14c0
Apr 27 20:32:08 testnode1 kernel:  ? do_syscall_64+0x32/0x14c0
Apr 27 20:32:08 testnode1 kernel:  ? preempt_count_add+0x7f/0x190
Apr 27 20:32:08 testnode1 kernel:  ? do_syscall_64+0x5d/0x14c0
Apr 27 20:32:08 testnode1 kernel:  ? do_syscall_64+0x8d/0x14c0
Apr 27 20:32:08 testnode1 kernel:  ? irqentry_exit+0xf1/0x720
Apr 27 20:32:08 testnode1 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Apr 27 20:32:08 testnode1 kernel: RIP: 0033:0x7f245cf99c5e
Apr 27 20:32:08 testnode1 kernel: Code: 4d 89 d8 e8 34 bd 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9> c3 83 e2 39 83 fa 08 75 e7 e8 13 ff ff ff 0f 1f 00 f3 0f 1e fa
Apr 27 20:32:08 testnode1 kernel: RSP: 002b:00007ffca6d9f6a0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
Apr 27 20:32:08 testnode1 kernel: RAX: ffffffffffffffda RBX: 00007f245d1639a6 RCX: 00007f245cf99c5e
Apr 27 20:32:08 testnode1 kernel: RDX: 0000000000000001 RSI: 00007f245d1639a6 RDI: 0000000000000003
Apr 27 20:32:08 testnode1 kernel: RBP: 00007ffca6d9f6b0 R08: 0000000000000000 R09: 0000000000000000
Apr 27 20:32:08 testnode1 kernel: R10: 0000000000000000 R11: 0000000000000202 R12: 000000003d0f6860
Apr 27 20:32:08 testnode1 kernel: R13: 000000003d0f8580 R14: 000000003d0f6680 R15: 0000000000000000
Apr 27 20:32:08 testnode1 kernel:  </TASK>
