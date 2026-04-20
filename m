Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazolkn19012066.outbound.protection.outlook.com [52.103.72.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8431429D;
	Mon, 20 Apr 2026 04:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776658661; cv=fail; b=ojueLdT2bcF1GhaYtQqOSJTQClEONgrms6QbpZJapPJOZmgX2b8n69hYQ15EpJhoeW9Ng8Wvf8Zki1gcwr5uBfLWxA/kCI9D8kRpiAYvrmNWrVCHpEpohwTRCqrUi62+PqyB08cHBxP6yG9dbExyX2ZYC6ME2dhmBQNNyxdaeU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776658661; c=relaxed/simple;
	bh=r4PFZR20tnWoX2TGxZGWttAPywSSDtGYyQ9xWze8Oeo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oIRFbgO7zGT2B8BcKPkUL0dpYlLstxT5G4nseBKHZkUVMdPyhoN/YeUH47EFzDsZ28ylDbp2yZTU8i40RW2yBsf9vH3bPjl2g3gCgS5RDeqPztUNwHXV7YO2uVUigBwmVGlJRni6yDYC9M7f4N4p/bmrEXH9dWF8egzojAPiGX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=p+h4xQLH; arc=fail smtp.client-ip=52.103.72.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="p+h4xQLH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xovWn1+RsuIWfLnnwR1G+kXxdWDc5g1ojtx3wqmJu7Ccp8UKBbN1gS/YIyS8LCSMN16VLwH2XhamxJ1+Gcf5y7AjQGKpHLhHFc3iZJ5xclCWs1tJlGWepP1TrxubzkD1DgpR9UAq/QRMhhS8H9DP2PNiBQF/8V0ZBGre0qEPbEVmhOxY4Jgi1dElk2wToQCHpQog5BIPO3wOUNLRjh3kjq4ZNrXFpY12uyhtJuWX4SrnjlCr+AA+Og8kKI8yOWomP9IyWeWdRghOBhStXe04krAKUEbcfJHaY+qXSmTqf1G75qK8GATrT/vgXO5k6BrAmmezfV7nl06WhV1w4pZpkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4PFZR20tnWoX2TGxZGWttAPywSSDtGYyQ9xWze8Oeo=;
 b=i4SQPDTPa5Qh2V0njJpaoTcdO4VxlN6i+jwE4A3t9ePku8oS/+NBG915XAL+AhF/+I/Fh5ABJ8shQ2NNGK48TTEeYRLp1cVTCvCOPlOG8mL+pyu1B0LoBTl8nBSiA3k1mxuzlIKZuaXxnMoetdmR4W56mvXMcqj6guQ5E0QBPgegW2fXZCRpxjv1kZETOrU8N3iDju/jKiV2aPl+oAl5m4DrW+H4eJIIcVD7GXukhDqEqy2mz8tYG707Z3NAG1g3YfahQjihLkEXYM8whsTWzSh5oSgGTNvFOIL8z2s+0i5WD5FC/UewqSM5BQqge9WWJjWTWy3Sijn8lzU9RaRtKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4PFZR20tnWoX2TGxZGWttAPywSSDtGYyQ9xWze8Oeo=;
 b=p+h4xQLH/2M7Pgp56sN+cHwVsEXV9JNvuMVvbXg4pdHCgHmMboc+X432tWkiprqQF35rf0irXS++6Yzp3HMHZDEr2tbIJ5ktTh0xM7/JUfUOJexR5ot5VTL/oE60LYs7pBHMkRoHAk6CKp2UPONATOsVjQHR7HbLpxcgyTH7TaCUaodmEP/8cbWbH13ir1vKZYvGUR4+Teo7AB9/hEGykPpDaz4nscJBPEIGH92KILterl3XdDCwkfu2JYRHA9CebakoErZSIaCASTc1CxAvy0ZKpYQvVU2ElX/5U5TovX0aFXc6cPMA7Kw5TMQ+O7U9vc9pe6KlsWkgPhlwlYUwIw==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY0PR01MB10353.ausprd01.prod.outlook.com (2603:10c6:10:2f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Mon, 20 Apr
 2026 04:17:34 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9818.032; Mon, 20 Apr 2026
 04:17:34 +0000
From: Junrui Luo <moonafterrain@outlook.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Himanshu Madhani <himanshu.madani@oracle.com>,
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yuhao Jiang
	<danisjiang@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] scsi: mpi3mr: bounds-check phy_number in
 mpi3mr_update_links()
Thread-Topic: [PATCH] scsi: mpi3mr: bounds-check phy_number in
 mpi3mr_update_links()
Thread-Index: AQHcz/VIJiimLEFV+EqGuGyJXcwKTLXmcM+AgADoK4A=
Date: Mon, 20 Apr 2026 04:17:34 +0000
Message-ID: <923EB978-2D34-4152-8C27-4594FDE3550B@outlook.com>
References:
 <SYBPR01MB788162EDBF416DC5E714DFEEAF2E2@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <3b89ea4a9a664afac39744d6f58c68d6adea9f95.camel@HansenPartnership.com>
In-Reply-To:
 <3b89ea4a9a664afac39744d6f58c68d6adea9f95.camel@HansenPartnership.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SYBPR01MB7881:EE_|SY0PR01MB10353:EE_
x-ms-office365-filtering-correlation-id: 6fcad265-d5ea-479a-2bf4-08de9e93bfaf
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|22091999003|51005399006|461199028|8062599012|19110799012|8060799015|21061999006|15080799012|12121999013|31061999003|440099028|3412199025|12091999003|102099032|40105399003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?D4HgMfFhFeuV72s084JvNBN2BpVtTDh6da4LiRDfDEyYH+ChdNKR/HqVD3a/?=
 =?us-ascii?Q?n8xdINF15RCTLrAcI+kW9U4IlmVa8uxN4MjoXVsfudD/vjYsyOcovdC07Re0?=
 =?us-ascii?Q?iCkhgRjpHTuhubMe7IjUmL96QwQTrsB3IhB3YF1thISvzQk80vlT1FJQ9wra?=
 =?us-ascii?Q?jONqb537gbwnaAtrCJLShOzpIze2oLFoRMFGhRzBHsBIFiphPRo8xlxY2eTB?=
 =?us-ascii?Q?WzhTw74kEX4cXq+0RUBJBJ7D14aKqKNxtrkvRBFxYt1wu1KkssuVdUjliwQp?=
 =?us-ascii?Q?PJIuwKio/rR22qDa4jFj1wzqG4900E3QIL6Vv8ScRTPDkOClS8LI2xbyX5E6?=
 =?us-ascii?Q?iqZ79a2OkaGSH7jeUIblsm1nZNtvcaSBqigRi6650EZeFshiq26dsE/4Pj3v?=
 =?us-ascii?Q?KPY7Ii1RYIvK2rk6BjvxQlhL76bJfZYX55NAMTOEej9z4m+1e506VWd+kS5m?=
 =?us-ascii?Q?us3i20eN3YdBjCw+ymSU2UwPdtmDA7rQgfB4IkvNG3v9oubluMr23yAX8q3j?=
 =?us-ascii?Q?dV6DMafIxLFS38thhpTbj1iVddNqlEfkRJwVbaGk+HkdeHuaOhqnVK7GgxfL?=
 =?us-ascii?Q?N9Wy0hrS+D33vJUOmjQIbzbYSFsZZ3Tjow+rVol9ZhQzd03zxgm3rFDy3TGG?=
 =?us-ascii?Q?b7k1IYB5EnoO4apmO5YebGW/06CVUUWfHfvberI+NWb6lZaZDP2Fso0SKImf?=
 =?us-ascii?Q?EpQ9hz4VOF/6iyEBoDAJ/cnqOQuj+eMKclzO2g2NzTtmJp7cdgDfKRWzXhCB?=
 =?us-ascii?Q?4wtEyIPhnt7uGBwGH10OPDX2wSwDieKL7mJPWWhkhrpC22Z/pN5W6+926N2C?=
 =?us-ascii?Q?R5fOEpKUSOIzLMU0++7Tj3WGdPW5u0bwPIHn7jNWtZfX8ImFT1xx55HKRkkc?=
 =?us-ascii?Q?04jzZRE2Rrl19fdj3yYHXHY8uScDnhPgtZeVv8rX+3Acx5fcHGzF8GXjNH5U?=
 =?us-ascii?Q?66z1YVDqlnptTy4iWubw9J8ZDuC4b0w375DrMMv8kZ6gahxL8TtefRO10VLP?=
 =?us-ascii?Q?7GphxJi80D1iYTxxOeX9yDPIYFw2XmTZECXAc4WCcaPGd0F/+35G5Yuv2Ig7?=
 =?us-ascii?Q?9R5EFZ4k?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Nhv1VBKAz2SH9somUx+7kiXkMaNvvzhB+nIn09Fn7keN0JzqjM9EBhryUXMp?=
 =?us-ascii?Q?aSxwBa0zy6qEEJJNGoWqeosrNJzoVWxPPt9Ek2vQ0k2vxdLIBohHdaYL0BkO?=
 =?us-ascii?Q?AsHZweyVqZTg/BFqLxoxPEk0mo1SUcr8mRzfCkiGZkIphPVWbBAegbe3FhPL?=
 =?us-ascii?Q?l2sQIAnX8on76jCWBNtAsnrU5g3QT/nai0RU+o2kG9rkvvZaYaeT0LKGx8pM?=
 =?us-ascii?Q?xa/3VfdMh/DhlX0B9A4q0Te+2CUGneTc3jL2cOoVb0453k0DgD+ebkw4HSjz?=
 =?us-ascii?Q?a6MTP9RLxt0feEpt+IvyrcTptq7AUm4lFlxX36QrnDK7fG5uvcwwv6bNepJZ?=
 =?us-ascii?Q?ODuXCJ4OptbSAVKAk6J+ReAXHZTwiLC9oWZUKoVEld4uHz6RNb4ROcf+pdpm?=
 =?us-ascii?Q?NXCmh5sJCJljUiDNf/zFkJZE3R0vqIzRF/a/n6AuRanFPeCPHjw1Z+PY9spB?=
 =?us-ascii?Q?X397nhHkXqiqokf0ZF539JU1ifwY3+5tO9kv+sY1tuAor4YDilBHyKBZS73p?=
 =?us-ascii?Q?chNDvcQwljYzbGuW7un5iYAErBXjnj0K2ahszL6XxREPh8Qc3uNsNNJ6LKsw?=
 =?us-ascii?Q?SghsU1rKo61AehRz3lbftIRA52e9aSLIMZJQQdXGfSJi0CQ0v4ihScLtqw4t?=
 =?us-ascii?Q?qWCbz1BoCfeKA+ltq1UrIZZTFHzGwvANZ1depsjyc6PwDk3pyvhBBDtnCQ3S?=
 =?us-ascii?Q?1CmqP508/njlUrbrFoYOVhR/Af1goQQFlCQhITh6Nlc6JRjTO82gqokifV0Z?=
 =?us-ascii?Q?1f0cNFbSnTuJlCM5Si1qdE0m84kbL/sK0XHhXjmj+tMUxeauRvTVxOavizee?=
 =?us-ascii?Q?bVIZ8i7T3VxjboNuenRetEZbjxoM8CkL+CnTD1J/rO7e2cM+QVc/8ItVRrZD?=
 =?us-ascii?Q?xQpGyR/wioU6HKRBsKHtoD79l3NEnn6JDO4ycbHLTtNxMkoh5Ocg1k+UMd3A?=
 =?us-ascii?Q?0Ybj91pMWbcJbNxqGPWBha0A/tmnRLbbAnIWNgS2xgVjL050IPt9CX8hXc3u?=
 =?us-ascii?Q?dwknfRbgP+yGQ6QnlK+kkIhs9Bwgq2YxBp+/kjtoP+0gSMcXy3FXa4q5kWui?=
 =?us-ascii?Q?VuK86ZagodAw5ayiPsckCXPCFDZwrU0Tk/GYLsGAcS0JLE1mDSJXzC0phUow?=
 =?us-ascii?Q?eYGYWuSW4arP0e5F+rWe1rASDyBr17V0sTXVF0roUPQp9Wsgku0aGDXtS7sL?=
 =?us-ascii?Q?6CZ5EpCECG27V5uSdSPV9Uz3dH/IUnY1G+HVaeme7yudNjflwUaKfFeGZYN6?=
 =?us-ascii?Q?xZKh6O+SNzw7Ssek8xWm9tm/X4iqKqrLNa73noD0Ez/rE7GPC1U3SSUBtSXs?=
 =?us-ascii?Q?akjUZhes3d3mRA2mkAobKGSRPedbjyiCWUgXbv+FNJW57pY4V+kX8I3Ko7iA?=
 =?us-ascii?Q?Nu9u4sti3YJXI02g30jjzu19TFych/g6w0D24LGjWVAKNRwR9Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6812614D7F8C8B459A662F124A0B40A4@ausprd01.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fcad265-d5ea-479a-2bf4-08de9e93bfaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2026 04:17:34.6383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY0PR01MB10353

On Sun, Apr 19, 2026 at 10:25:25AM -0400, James Bottomley wrote:
> Our threat model for hardware is that we assume it behaves correctly
> unless someone finds a buggy instance in the field ... have you found
> such a buggy device?

No, this came from a code audit rather than an observed incident.
I noticed the sibling mpt3sas driver has a similar check, which led
me to believe this might be a real issue.

If that's not the case, please feel free to drop the patch.

Thanks,
Junrui Luo
