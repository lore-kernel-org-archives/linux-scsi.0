Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA314D2BF;
	Mon, 13 May 2024 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715617199; cv=fail; b=eETabkCRQA6hfgo8sZJ5y8f3D4uPFIh65u1EI+jXtDy+b2nlsvyOn9yt3fSQbegaj7/rZjUFRqw1isQ+XlrRax6gFqwGYHUB1nsDrVfLOAAT9jHt+npc/vYrcqleBtWPTHzYGE3FH28rt4ec2EMUqj30F5FHGAKenST8IUVh0sU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715617199; c=relaxed/simple;
	bh=6pEShdM9QDNX5VyyexJi9zvZ8L9wVpxy602ShN9AUR0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tyBRAMHGnh4CNJ2oo5KC38TOzIXFPPhmY10msBJ6hJ63FYbLFhTrPVXTCh48Yc2/IMlldHNVLNtDpxevon3vi6cxLMNZVqoFq0bL7ewKARBG9F25ffUziEAo5c9Uty1z0ZxgZwp/mR+eSkBD+dDhHQ9Zay0UY05VDqRoAf9iQ5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F2fyQBJk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=kQkJnHGz; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F2fyQBJk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kQkJnHGz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715617197; x=1747153197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6pEShdM9QDNX5VyyexJi9zvZ8L9wVpxy602ShN9AUR0=;
  b=F2fyQBJkJRbDo/CC1y8jUVTdoNP5reYZwTzU9XKvwBoRQ3hTNfbqK96Q
   w59yHKBQU5OEdpK9VAxbKhPybH0oFrq70OWOR1JsJnVzOkk3Ij9sYBw+g
   tG2Q2T5VKSbxQEWfpGHMIM/bjPIKamjcQQV1Q78jJkDM2+YzvRkdsA2Wh
   gtxi0/cnHHN4AnuNCbe2TtSDsqr9dc6bItV7dPWrZkLLat1xqT+BnR5rJ
   vVn11RQcSANjSJQN2jG9XRJJouNaP5RzwzkewjS93ogtYSIfhBbTXLFef
   dy/+qZpvRF1GWGAiiH2IUC9Fcq3eOVMOMwh/Mj9muQTmaolCys8LzbYa0
   A==;
X-CSE-ConnectionGUID: PSSEjaXaRU25Fqlu9S+RYw==
X-CSE-MsgGUID: +c/rMR9ZSRCrE116ds2www==
X-IronPort-AV: E=Sophos;i="6.08,158,1712592000"; 
   d="scan'208";a="17042044"
Received: from mail-dm6nam04lp2040.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.40])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2024 00:19:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N48anptVxPxUmwRxQuJwZTMQ8T8YYiHqFFMZqTUm711zSSsNP7UCps1ALDDb40yKBMiIH7GCCtVewoP8wUFqx5pM55hMS3whnn/EfcSgUwp3VgXg1QvfYWvrP4j+L+Ubyls9vKzen8p8bckT1dvtPeOYBxtZm4NQX0yGiC3rMWdakN/MBj5BqxOp4dZLr6B0iihTU8tUnZwxFRYuNXt/zkpf8IDBqLdV11Xn0e+1bbjEM5xgXh45xF1lnjvhfilnQnpK1U/1FkRVv9TdIycnDb7vGLwitqShd0yeL9wEFoSPG5Qpn7uwqlYCVbvkAYi5+looxhe8q64viAcwcZC0sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pEShdM9QDNX5VyyexJi9zvZ8L9wVpxy602ShN9AUR0=;
 b=LUyXl34XP1ykl5hnmqAtZuGK54XVmnDZSVKBTaktc9kI8xGw+4c2Z0rd/zDS14F62fgNiDTfhxdfrYRedLWyjmANfJJpvX1fItLYBCxthB0C+3I6nuvZAdjGQFbao6t96AL68bEng3vM/lx6iCeYWnUY6fICHeH9x/SZkF1KHWUK1z0atWSln5Vr5ckrD+0pV7tL60TV94mRPNUTOrVxnc4fDgLg3lIgrTDqrZI6Ty5M60fs2fswz1YVLIzK0jt1XHUp8f1QRX77LIXiQvjpMSGrn8G/78Sn3Qc/fTr54PXIeiGgx33nBUdnYCwpxhb4ISvItwpLcWaRazlGO8YXJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pEShdM9QDNX5VyyexJi9zvZ8L9wVpxy602ShN9AUR0=;
 b=kQkJnHGzN6SbYsb5JfRHcf/i//IKfevL50SkidhFzD3Z+jzejPl92qKpOsQiQeWX4lbNWvdTvCqxjWtqhEf6PlkkqLy7K7qvMcVIG3Bfx7IkDkImz5+xdqEB1vCzjiYWOYrZLP7VgW2Uidg5FyeuM3xoGExcN8bFnSNUi1Dcr40=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by BY5PR04MB6707.namprd04.prod.outlook.com (2603:10b6:a03:218::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 16:19:46 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%5]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 16:19:46 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>
Subject: RE: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHanU3naXbfPalq8kifk3TPwmTFrLGU9mEAgAARQxCAABdFAIAASNhw
Date: Mon, 13 May 2024 16:19:45 +0000
Message-ID:
 <BL0PR04MB656488C153B10682116B1727FCE22@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20240503113429.7220-1-avri.altman@wdc.com>
	 <95c026bdb884a27bc6f954e3c01113816723c999.camel@mediatek.com>
	 <DM6PR04MB657566938989AC00F790EA9DFCE22@DM6PR04MB6575.namprd04.prod.outlook.com>
 <ea63de370bc984f77d5635f3d76ad43d1c8b2b3b.camel@mediatek.com>
In-Reply-To: <ea63de370bc984f77d5635f3d76ad43d1c8b2b3b.camel@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|BY5PR04MB6707:EE_
x-ms-office365-filtering-correlation-id: bee5bdd3-827a-4dee-e8fe-08dc73688130
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|376005|366007|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?eFlqNTJ4NnpaVnZEdVFqZlo1SEgvOFJuKzZNTUVXZ3dIY3NPZEpzSDhHYjJV?=
 =?utf-8?B?MThjZXlXdkRNcCt4UFVwZXhoM05DSSsyRmUvOHMvOUhCNm1aMmg1THRSWFNj?=
 =?utf-8?B?aXF1RjFUVnN1Ukt0RmsxaXZwMlZ0VXVJUGQ5OEppeUV3R2pNMUxydzJLdzlP?=
 =?utf-8?B?T2RJdHVWbEpTU01JYWs5c0RrdnhzZThBVlJTREQ3QWNkdkorZ1hhL0lrVEg1?=
 =?utf-8?B?citBVDFQYjhSRldKUk04QnhLeDFZVnlSMWpDeXFQbDJ0RlNqN0p2c0licVdi?=
 =?utf-8?B?ZktSNHN3dVVhQkN5aVBicXlPY0xTUmV4QUt6ZG0xMmduZXVKOHkwd1o3b1FZ?=
 =?utf-8?B?TmlUb1lKWEJDSi9IVlU3WjlyeVJrb1psWFVadWJKQ3d0cTEvN2ozejlWZzZr?=
 =?utf-8?B?SzFyaytQTi90SFNCTWhBcENFZVUvbVlBNmVRRTR4R3VTVUhmaGZjSE1saW4y?=
 =?utf-8?B?bHMzMWFTOG5YM21xVEdJMDY2TnNBcW5ZeHNBUS91a25hMWVqUVlNUlM3KzQx?=
 =?utf-8?B?TUU5cjdiNHFORWprVHo2UlRGWVg5R2ZPZnpzZGJwVHhhQ1pwQWJYQlZoOFJM?=
 =?utf-8?B?eDkwUEVkTnZsTUwrdldXWlBhcksrUVByTHlLSFhEK2crcmxjR2VnR0o2czcx?=
 =?utf-8?B?RTdXUW1wNWJwTGVaTnB1ZVc5NXZENktOdXJMTGNLQVpTbUhtTlphTzc1TG04?=
 =?utf-8?B?anIxNVRZV1JUd1NyWEI5SlBtRFdHSi9vMWFPTWZjNHo5K3pabU1GSnN3WHIy?=
 =?utf-8?B?Smg2UGh3NFNJQ0hxcWFxZHRDTll3QXRkT0twY3orQ1duQTdHN2JmTThBMzBv?=
 =?utf-8?B?ak1WZ1ZDbmVHQlNaOEEvR2hHZ2tESzZ3cDBOZTExRXBZb2hIRGhudWZaNWNs?=
 =?utf-8?B?SEs4NHhqSUo0NkYyTGRwcmk1UUJ3NkZXdXo4RGtLaWRMdkRTUnVVb3Z1M2cz?=
 =?utf-8?B?TllNMTV1NXE2RGxid1ZwQThpc3hLTUxQdGFhdE00VnQ4SHBoZklYRmZGWTV2?=
 =?utf-8?B?eGY0QnRkSzlVRmtkUnRuL2tPYm1MR045K1BTYk1GOFdYN0V0R3pRaDM0ZlB2?=
 =?utf-8?B?L0pUNXV4U2dqREtBTVJaUERDMmk0R0JaVkh6STZITVFuTVJQM2JYb3owbzVG?=
 =?utf-8?B?bVZpdy9HbmVyWEZycU1RcXJDbDFSS2F5VHFZd0wySXpXcG9XY2VPZFp4ZlRO?=
 =?utf-8?B?VjBvM3BDdEYvcDZsK0ZMTFpvdWxGbnd1cXdFbjJnVWQwd253TnZibW04QUhu?=
 =?utf-8?B?VzRueENvam9HV1NNVkxGL1A0Q1EyaW5mc1h2TDNRWTBFRjNER1hhakIvM1k1?=
 =?utf-8?B?UElRSXhUbVVSd1Fub1lCNFVRUFNtZnlpTWhyeGVVZEpvb0RiL0pCZ2RzWnZp?=
 =?utf-8?B?VStMajQ0cjhrUDNEYnFVMW15VFpsODIyT2JvZVhQbkt3dDBsRHE4aU9Zbkhm?=
 =?utf-8?B?YkVlZU80akxWbHllWCtVb0FuajhqeFR0dVhLbytzRVAvNjkwNzQyRDVKaDdu?=
 =?utf-8?B?WldETlJlQUFSSzRDVngyWlNnc2JlWjlJcEVsSE9qSW1QYUNyUmdKYkphNWtY?=
 =?utf-8?B?aFpycU9Bd2EzZUxvVFpBSllhMHJuNzNxSVFhR3ZuVm5Pelc0R3pOQi9EZWJR?=
 =?utf-8?B?ZEloV2JjemtvSUFxV0lrb3Rab3RwajRBVWt2dGIxTVNRTUFpS1BzNFRZcG9w?=
 =?utf-8?B?WFMxb1REQkhpK2JMVENLS1Z6cnczT1NpZWttSkFqOXhxbDhkbXdDTlRBYXJV?=
 =?utf-8?B?bW01RmZnYUpvOWhlSllUb2E2cHpaQ3IrVG8xUUNhZU5jN3BRcUp6UzRjRFlP?=
 =?utf-8?B?SFRqT2JleWg4NFpFcDVLQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cFc1UFQ4S0pLRnFEQTVVbU9Ta1VpNFJSZDhwMHB3WjZXcWN5SVdFQUo5Vjcr?=
 =?utf-8?B?R2g0djdvL0lMRDFjS1RoR3QxSGhCQmJEU1RtRUNKcSt2Rlh2NWFGOTlJc1Nm?=
 =?utf-8?B?UnVnUjhOaFB1VzdOREtlcys1emM4U2dLaHlVeE1pRUVXa0h4NWgyd2NHT1JS?=
 =?utf-8?B?Q3FiYkllQmdBNTF0eUhNYnZOOVZ1dndsODJyT0dDVXYxUlh4MUFPd2k5cWdF?=
 =?utf-8?B?WERnK0doYmxCSDlBTjFJS2NodTErRkpwTTNlRXFJWkRuWTl4UE9pRnJnQUxy?=
 =?utf-8?B?MFUzZ3VEUnhENEkrZ3VnTTV6OFhNdVkraHU1K2ZJaElLWmJkQ2cveDNYTG9Z?=
 =?utf-8?B?bzNpbUtsN2xRcUNlc0JCcmhWb1MyZFozNXVCazc1NGw5dEo5L3Q3UmxBUC80?=
 =?utf-8?B?aWZMb2dVR055Q0Zjc1QrSUVvcGhRYTZpUTdkZEtSTUltYTcrdS9ZTUpRM2E1?=
 =?utf-8?B?OGhMRVJEckIwdlowZld3OFBGdWhScGlzYVR0WEFGRHIySjExNnNiY2xmbHFY?=
 =?utf-8?B?VDB1T1p2RmRCUmZVSklzcS8yWDVJbDl4S1JOWkxTT3RLY2RkeHdIaUNVbmxk?=
 =?utf-8?B?N1RQMnBueisycUFKaThpb3FQM25KbXFqRWdGOFo1cHNkZ3VUNjJ0UFVudlRh?=
 =?utf-8?B?NmxQVmlQTjI0WUlkcEFTOUEvWUlwWEdXSDMzOG5YcGxGYjBSYkNqWk5NWE1l?=
 =?utf-8?B?ejlpNkZpUm9oZDI5QTY2VkZIb3Z4K2c2bjJ0RDhOZ2p5TWx6YWdzNFFLYzc2?=
 =?utf-8?B?N2ZXMHA1RHFhQTdROUZFeDlTOWZZb1Vwa0hCazlvaEhzU0pSZ0h0aWtTelh4?=
 =?utf-8?B?d1NaNzNsMWNML3BoVXQwQ3BjSnpPUUFmNnVoSHVlL1NoSTlVbitTeWRuZi9F?=
 =?utf-8?B?VjlnN3pvUk9Ibnl1d05QcGFaY2NTNElpaHd1U3gzb29EM2JiUnZjMFhhdlc4?=
 =?utf-8?B?a2tvMTFXQ2RtdTlUWFBoTHFpY0tNN2NaY2JZZ3k3UjhkWGZWZ3lqZVZvL2wy?=
 =?utf-8?B?TFdqdXV5QXlQOVU3Tnl5Rmsxcnp1dElsMUU5KzVOeXBHeDNzbUc2Nk0yRWRx?=
 =?utf-8?B?eFQ0WTQ2ZU1NNFF3YmFkelptQ1hTMGxORDEwSVloK0JNb3BKbTBaZXQ5WERl?=
 =?utf-8?B?V3FkdmlnelFBM1h5U0FkS2RoeGRiVlowQVBsNzBRR0d5eFNYZTJxWllVSWFl?=
 =?utf-8?B?cjZIK1JaL2VSazkvREhWUW1kK1Npc0pKZ1VlS1gzdC9iZHZEVWVjOUhuM0ZY?=
 =?utf-8?B?MjltaXVkcm9OUkQrZVllekgzRWNvWnNMdTh3Q2xvVlo1V2x2RWhXRVJIbUNy?=
 =?utf-8?B?RTNlalNlQTF1VTl1SW9IV1pOSm0xZjMrQno5TmRIMkJkeGZEQnpBUlp0QWg1?=
 =?utf-8?B?WmxJMmxhNkFPckRDOVppRmkyaVJSNXMwYmZQWkNGOGkwQzZ0S0gvUVlNN1dX?=
 =?utf-8?B?SC9kRTRGa1BtcFZHVi85ZG11UlFCV3A1U1RvZjRvbmJiNVVIRkVra3NPaS91?=
 =?utf-8?B?cW4wcFlPcjFjL2R4VS9TbzVYZ2NaS2xIYjA1cnBubWo5MmdEYUtGd2xqWC8z?=
 =?utf-8?B?eVlNN3B5UWk4ZElIU0lWa292ck51SFhvV0pYdlpzdlk0ZVQ2RlJnMm1MQUwy?=
 =?utf-8?B?blRFZzZGYmlqWWEreXZXUDVERjc3L0dieEtXcWFSWDBwd2Q5RWtkMUwrMXVS?=
 =?utf-8?B?OElJV2I1TXhKVElyTXI1Qjg4UzlLN3FWcnBHRFNRdi9jWlN2dEJXdXJKTnBN?=
 =?utf-8?B?dTdPbWUwQi9aaXVPa2FtWEtMUlpudysyR01Qdno5dm80VlpmekpvOENPSnNC?=
 =?utf-8?B?dnQyZHpMSXUvT2xvWG1SdG9KQWZZOWdZMnRBV1cyLy9IUThoYnpCY1RGQ21j?=
 =?utf-8?B?WndaRS9NUExocFNtcnNxUW5BMWtVUjQ5aGg2Ym9CRDFhM1p3cERMYW1JK0RX?=
 =?utf-8?B?UStBQzRENTVaUXUwUUQrWFhjNnBRUWFRckpCTkYyZXN0VTJhUHBsTysrVy8r?=
 =?utf-8?B?RWNIdEpheG8zOEpYTll3eGRkK3hyTCtRT29kdFp1a0pXK2toZEs3c0hLbjNZ?=
 =?utf-8?B?dHdVcVFlWGlrLyswOHJVMlhmcGFrR25VTTJoY0xjWURDbkd0TlQ1SXZMa1Fq?=
 =?utf-8?Q?g2Fp51dqTO0S794wJXwL+dJKC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NfrGfvKozcjMqyuPm2cImbBhz0o7LFt4w/bunmqfNhAY/pM5FYUUd13OZdpAOrfTkPeF/zRWdLpSLwyAj8bL/I5W7eTWyTI6fEBWdApGLX1HmXJMnS62+kIY8/hl7F0KtNLwaKjTF5fbplrcY/MA0cXtazRKrNihNVw77mVb8Oe1VopIcy91bpHp4GLj8rEZuWbvpE4G4fhzdeLSgS9TeCaU3QHUZF8rQoyyos7LyaA5BhI8RiSZ3sGILsoREuNyNtSs5u9blNPXVij+n523kbU2KbHFSJEDG7HSuCt6Nbdz+jWGC4JmUGd/xtsYk7o6ZsqHNEUkp/95QtWq6UN+bX9pobyf4ZDHst88/HLiqxQTfto0rWCwvWpm50T5+h3QYWvE8BqUZSRXXaa0RYwLYqJ+v7osihWegwqbSFbhP5QYpbx7W3wr3xbixxiXH9KV1gDyFD4Ut0UZtgn4BZ4OP4f3lnwG7sl6zoCQG3NTtLley92QLuxN05uhMX3+TY3WlOFq3rVEipB7FBaJmS/lWzSZRfGjgUUhEP0z+CGixPUx2bnuVwH4hIjItb4va7auKkjNTYSZbKFm/sHJCYtH7+new9avknVq8oYeG8dwLgFB5GNroTTaM2/5VV1N10qC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bee5bdd3-827a-4dee-e8fe-08dc73688130
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 16:19:46.0472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ZPIFy3K75XrmPGXXgKYqx9rn5YMKA+pMleiPZmksLOnntNGw7LFX4Lm7n65hT34q2Fq+T+JRb1e1eXtWpryOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6707

PiBPbiBNb24sIDIwMjQtMDUtMTMgYXQgMTA6MzggKzAwMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0K
PiA+DQo+ID4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW50aWwNCj4gPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiA+ICA+ID4NCj4gPiA+ID4gKyAgICAgaGJhLT5ub3J0dCA9IEZJRUxE
X0dFVChNQVNLX05VTUJFUl9PVVRTVEFORElOR19SVFQsIGhiYS0NCj4gPiA+ID4gPmNhcGFiaWxp
dGllcykgKyAxOw0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IEhpIEFydmkuDQo+ID4gPg0KPiA+ID4g
R2V0IG5vcnR0IGZyb20gTlVUUlMgd2lsbCBoYXZlIHByb2JsZW0gaW4gbWVkaWF0ZWsgcGxhdGZv
cm0uDQo+ID4gTm90IHN1cmUgSSBmb2xsb3cgLSBub3J0dCBoYXMgaXRzIG93biBzbG90IGluIHRo
ZSBob3N0IGNhcGFiaWxpdGllcyAtDQo+ID4gTUFTS19OVU1CRVJfT1VUU1RBTkRJTkdfUlRULg0K
PiA+DQo+ID4gVGhhbmtzLA0KPiA+IEF2cmkNCj4gPg0KPiANCj4gSGkgQXZyaSwNCj4gDQo+IFNv
cnJ5LCBOT1JUVFMgdmFsdWUgc3RpbGwgY2Fubm90IGRpcmVjdCB1c2UgaW4gbWVkaWF0ZWsgcGxh
dGZvcm0uDQo+IEhvcGUgd2UgY2FuIGhhdmUgb3BzIHRvIHNldCByZWFsIGhvc3QgUlRUcy4NCk9L
LiAgV2lsbCBhbGxvdyBwbGF0Zm9ybSB2ZW5kb3JzIHRvIG92ZXJyaWRlIHRoaXMgZGVmYXVsdCBi
ZWhhdmlvci4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MuDQo+IFBldGVyDQo+IA0K
PiANCj4gDQo+IA0KPiA+ID4gVGhlIE5VVFJTIGluIG1lZGF0ZWsgcGxhdGZyb20gaXMgMzIgb3Ig
NjQsIGJ1dCBhY3R1YWxseSBob3N0IHJ0dA0KPiA+IHN1cHBvcnQgaXMNCj4gPiA+IG9ubHkgMi4N
Cj4gPiA+IFBsZWFzZSBhZGQgbmV3IHZvcHMgZm9yIGhvc3QgdGhlIHNldCByZWFsIHJ0dCBzdXBw
b3J0Lg0KPiA+ID4NCj4gPiA+IFRoYW5rcy4NCj4gPiA+IFBldGVyDQo+ID4gPg0KPiA+DQo+ID4N
Cg==
