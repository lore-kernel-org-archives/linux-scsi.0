Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011024.outbound.protection.outlook.com [52.103.72.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD6B20ED;
	Thu,  5 Mar 2026 02:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772678949; cv=fail; b=ndn7tkkw4XdN+lOiWonoF6yPmlC3tE0rG8CHNAZs/kbEQtrG6h5vHsHlsA82Jli5ePHJ7hcVJYRQ82zqvz0/o9rH3kcPlESUVQRz4v1jPYfGWW/WGEI48cQgGbFn6hbStO/hfvFgsHoG7aOaCS2BttcxTrOcsCGx9sfwsQHmAH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772678949; c=relaxed/simple;
	bh=crf73NUUzvrxTX0Vu7XOCKfaGniwcBvzI5HZKuXY/Oo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dxiotRudfAwOhaBpX6v3W5VpEoroPrydOaW6njjsXbo8uBDCsk0FhrJiRG7frNvJyvrT2/IeyQMJ1GEU9B3Ooq7hgeshrNJGmKiaJYgtiwIMTPiuNTtP6Gx/joLgfWbbYsUSuL/++NGS+l1LUX4V8GJ15hvdWuLBUGu2k5Fevy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=PwALEQJ3; arc=fail smtp.client-ip=52.103.72.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="PwALEQJ3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nk8MdI9W0VHrUoemcCulE32o7fRSZjEvzw34VlwEDO0OlgFrh2xEiVCPiHlF2qAc6CBYHUxebBPU9dRj1YgcKR+lztUpB1mr/futG2Zo+1CeE3NbXLSkxrBfdnSAcT8RI6NmEkUisS35cWs3kW8n37uJRwsR1PRAp5pdsscaQ5WBFP7VTn2Cc9IleGunnOMAKRVLNd7NsQkMI8jrhA6iQKrg3+MdVoUXGfVeMXxGQVgDBo6bMZMm8zf3nSfpBQXIpJ908QDMWBXmJyzo4BWlPR8LZeuASUji45cakv0PN5O2FOwAR/Ke5dGpjdmtkupwoXXTWs1Bxhx0hM2F2QFIww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1izccchhNTMyPdnZ3IC61c54o8lsmMzQjC0yGSr2J0=;
 b=jRbm3zk3sxhrU5CGpQ8omtS83bo9W+XL479UC9+K2/3UTJ4007oG0GxyPkR5ewjf/c7WA5DzdIyL+mvU5PDPNADL1ULvmm0jHU/qN+dBlbESV3VSXYup04qhJYkYa0kXiQ8f8tq4ZolLPMZUwoO3b1OtftBK+DYfeuN90C7xA29IuAupHzttmHa+Epo15Di8KfLRk34BHhRCd1We2L9EMvn10jVhX6Kx2Ytr2eKXkk6kpzyUAQWRtDn9nr3tYE3T0qBxTJVw4Hc8J0mTrEes9JcF29HunuR9HV1qbtMpQSdPedRxxB1KVeI0RK7VwQruO8P8ojm5Bx9CNE1usdK3EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1izccchhNTMyPdnZ3IC61c54o8lsmMzQjC0yGSr2J0=;
 b=PwALEQJ3uQqY2C4sVopOkEaHHueAyoLbhglFqOLR1OcflgRdOdMP7gFqfQgDwtNSOn/kLUjeDvymgOCm+9VGZ6c3TRrARpzrWd+Sl/272ITMCphljkkFGSHtCF7/Q6Ijz2pOlKinBkz4AW8ZwdrXWh2IW0UxXPDvcM2620/Qv0rlv84evB/QFa3cokpMBiNjNJOhEnFv5Y1i3MbfqsDOpRapRN2JOt1x8aMFN7DKEGeNvM+N4/Rb2yYDa23yS3YUY8+uFKOjSsuu4dpgf2DGuqRaJPqmUqUxwNBux0nXwBwfq+tmsMTfSzEa/9AQIXkhFm3uc5toHbGfmnM6UyMiUA==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY0PR01MB8601.ausprd01.prod.outlook.com (2603:10c6:10:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 02:49:01 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 02:49:01 +0000
From: Junrui Luo <moonafterrain@outlook.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger
	<nab@linux-iscsi.org>, Asias He <asias@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yuhao Jiang
	<danisjiang@gmail.com>
Subject: Re: [PATCH] scsi: target: fix integer overflow in UNMAP bounds check
Thread-Topic: [PATCH] scsi: target: fix integer overflow in UNMAP bounds check
Thread-Index: AQHcq+2irpso1+WEh0i6au8hZMqNK7WemOWAgACkaIA=
Date: Thu, 5 Mar 2026 02:49:01 +0000
Message-ID: <956B2459-79A1-4C49-AE89-62A949498695@outlook.com>
References:
 <SYBPR01MB7881593C61AD52C69FBDB0BDAF7CA@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <dda830851d25f66373b556a4816214124b02d669.camel@HansenPartnership.com>
In-Reply-To:
 <dda830851d25f66373b556a4816214124b02d669.camel@HansenPartnership.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SYBPR01MB7881:EE_|SY0PR01MB8601:EE_
x-ms-office365-filtering-correlation-id: 3677e4b4-9874-47fa-8f46-08de7a61c1d9
x-microsoft-antispam:
 BCL:0;ARA:14566002|8062599012|41001999006|461199028|31061999003|15080799012|8022599003|8060799015|19110799012|12121999013|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 3yyTnyT0qO/vPFOgA3sB61KZXDPDT39LrLmd+H4F/cjK8NmN2Rq3K11Pl3Rw5GV/SZ0VXA8QBtSERw+L6TEyR5bXKBQt0fKrM7P9cHolPxRk5b0lox2LbE4ysdPnLYClQwg9ixLB5ghue/1cx/EZEmc2B7k8QSuR3n5XoeXGlkJmUq/P3b+uZi/9wZYy5YrEtO6vHMmk+WyQvVkKVRs1DKYAkQeVhQprWxpoxXA0Ahuex06DG4/I3h18A+p3cExb+CCKl6vYupXxyHNGffF1+ZH64ArFVDNVfBGs4YppeTdDpxlA3hucR/q5b4UNHEqUO6lRbtYAjkk0jcTbGOSspqaJmgOtbuEbds/Be13yIdQBnv0CpaOIOPeK6KYO3s+0+3LbLz21ywwMrjdnhECJYrobWuE42gNjduK4+kZlKK543gLya0/0MWsit2s4XaxYonolIoueACC/Gp6RjeGlxQ0D7paTBaqUHG6oSV63lVvbxj0qjeirIw9Uss0wFqNVmnfaK9oszns5uK4MYZ4+ImZfpHXc7P2DjLz3oz5a043y6p152vUKbn29P7z3qKMjI7JfAX8gSBIm5IEpiHjZyuPAPlUeldlezygqPUvZHhTF2tj4j1Mh4Rud7JY9Q34z0yjA0WZW1eMLdT92DdKefN00pMmg9c0qiFNOsJCnv/2y7rzR6m7hADXIiLTRoQzQMzWxUCF1SnxfWM3UoHfHVq5oQmPGq4KjNxWpWuiO9j/Ylrd5e2aMIO+sUxOFvzYolIpsEW1WefbzAMpE2FcQSN7TP5gH66ZcNIzNQ6QdpTQs0bV4urlKRJPucTWd23dCLyiuqavGeV4VSPqBLR6exsyq0VnHYvF0uVJUb4UKKDYDorD6O3d1Ov6ySEfgrWVti/PV7Qeem8SR2N4XUMj3zmuJqWwYXZJoMa9kMZRuRVxBEdjSTwzSa5tDDnf9pXZZ
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?GFCApwOjIkkVCbvpGoaMuaJo5rQWI0PXqoaBZzeBCTzZduOmnQ+QsEVec+MX?=
 =?us-ascii?Q?IB/ZqIJPjrYtEM98R4/DlocmZX+dMS686EVAbpVWodzUKgxVmyOy/Yy8aIhk?=
 =?us-ascii?Q?mmfU6su2BLqgoIIGHmVmVS19KIH++KBlxF1QXsksqhwzF8p/ShAYbntmCXei?=
 =?us-ascii?Q?fP7CxUfApOVmO02YsdQBynUONKDnD3TCUXbM2HZ2QMUFA+lAvw+yRJwYxbVc?=
 =?us-ascii?Q?WJu40WcQUo8ZGvTHvqVWJ6hu7nxbcUxNjDuuY1MgJj6Qvl8IOT8pzwtvCVsS?=
 =?us-ascii?Q?ktfHnOhJ/bDg3SjJ3vnjG8A9W5GuEjhLRtkAARQikCvo22MVOHp/y4rfAXN/?=
 =?us-ascii?Q?9mdVRaeXFYHzQ4Q9l1/OSUCFkldjzDBrW8JgydZYOeiBCyaIlu9MePm4Z/9y?=
 =?us-ascii?Q?HEx1r42lBHkaSP5wveJIQ06YVsT4jNgrY051UUmaZdQSyMGxlROPFPPyRFvX?=
 =?us-ascii?Q?tqc7VGfzYh76ELWR2YmN+JUoCEe3N2i14uL1vhj2Jx2siv4niAE02i31VfU0?=
 =?us-ascii?Q?NiXmHTv8zuzmvD1i0iGkzX0mtWUz9gB4HP5c3pCqTp+rCTrwAJKbZINJhyuN?=
 =?us-ascii?Q?as76NsE+6iVXLhL+fsHNbsFQvTmIjJVBOOxpuOvtZ5opfwzmh0s7PyMvRri9?=
 =?us-ascii?Q?OFrSg/ke8ENW6FOZbggzMHI10h+Uoqo8aeclH3NMc4Bp3yvD86ExTdRHmo2y?=
 =?us-ascii?Q?/C5GT7qgcwnpkJF07xH4beek4EzH0UJCXYhJM1k1F8DAieyL+jhpfMA7Es+8?=
 =?us-ascii?Q?81qg1Y5q78hR0s42PuOlkis1qKuDn3jMkZVZjXxusqKKou5m1/sUnqcL22JD?=
 =?us-ascii?Q?gDNyee8JbQNPUyAnGshDbeS3pdtH2az3+718fGhfoK8GDXmcqB26TPnJVtgV?=
 =?us-ascii?Q?Mighur5M3OvUdMN9NiyuGO9sTFMPy2CWpN/kFf8vjJjJ3Yn6PcAPdsfoxsHS?=
 =?us-ascii?Q?RYX4yZa8OhaFaCq1uDpaLHlvDWRyVltFogrli8ArzMoBpXg/05EdL8kApiYt?=
 =?us-ascii?Q?Wf5pVOUmdxySC0qww0J4VP8Ivazxb1IulQ9RetQ0iYyDmz8MmQ4p8ycbVvP0?=
 =?us-ascii?Q?96ZFXbvLgf5sBQtSABMSqq1X/mu9SWM27N/aJWxstxj6fwJ31CMYaTKXiCCA?=
 =?us-ascii?Q?9tA1dsrMmdH4ZxUmyJxiv1HSmWgNjbO1m1rAgd20A8x5KzGA1cQ6xDtect+e?=
 =?us-ascii?Q?w+TYkfgmXTGTVwdqVYllGT61U/aawRrNITv8G051x3bnVsMFyNBg3yWvZkQU?=
 =?us-ascii?Q?+MC5QXysmI4/TwalkoCeDQfV031dj86IQXMQ5yxX12jnsW9LL4zxC7ky8lo9?=
 =?us-ascii?Q?7nsOy4xexf7zeD/8rOQGyqeMayvSSzrO2JYn5+V7VAujf2Lfl6e/4WaEluI+?=
 =?us-ascii?Q?hPN0xj1QMaLpnhOMF50oEkmHgePmz91eQW+GTEVsYbqE41i+7Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1AF3775E92CF8C4AA75B8D1857DC1308@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3677e4b4-9874-47fa-8f46-08de7a61c1d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 02:49:01.5262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY0PR01MB8601

On Wed, Mar 04, 2026 at 12:00:17PM -0500, James Bottomley wrote:
> What's the theory about how this could occur and the problem it causes?

lba is not the device's actual LBA range - it comes directly from the
initiator's UNMAP parameter block descriptor:

   lba =3D get_unaligned_be64(&ptr[0]);

where ptr points into the data buffer received from the initiator via
transport_kmap_data_sg(). An initiator can put any 64-bit value here
regardless of device size.

> If we send an unmap with lba and range that wraps 64 bits then the
> device should error or truncate it anyway, shouldn't it?

The backends will catch it in practice. But without this check, the
initiator gets TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE instead of
TCM_ADDRESS_OUT_OF_RANGE and WRITE_SAME already has this exact guard in
the same file.

Thanks,
Junrui Luo
